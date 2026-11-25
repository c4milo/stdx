//! The Zstandard sequence execution fast path in aarch64 assembly (decision 23, which amends
//! decision 16 for this loop): `fast_sequences.run_loop` with its state in registers the assembly
//! allots, taking the sequences the Zig loop takes and writing the same octets.
//!
//! It takes the claims all on (Z4 chunk copies, Z6 window once) and literals from a slice; the Zig
//! loop takes every other setting, and every other target. Where the Zig loop checks a margin
//! before each sequence, the assembly checks each sequence's own octets: it takes a sequence of any
//! length while the output holds it and the overrun of its copies, so it runs to within
//! `copy_overrun_len` octets of the output's end. It leaves a match that reaches the window, which
//! `step` takes.
//!
//! Its reads and writes go by address, without Zig's bounds checks. The checks it makes of each
//! sequence, those of the checked path and the output's room, keep them inside the stream, the
//! tables, the literals and the output.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const sequences = @import("../sequences.zig");
const block = @import("../block.zig");
const Claims = @import("../claims.zig").Claims;
const work_module = @import("../work.zig");
const loop_text = @import("fast_sequences_aarch64_template.zig");

/// Whether the assembly takes the loop: an aarch64 target of little-endian octets, the claims all
/// on, and literals from a slice.
pub fn takes(comptime from_slice: bool, comptime claims: Claims) bool {
    return builtin.cpu.arch == .aarch64 and from_slice and claims.chunk_copies and claims.window_once;
}

/// The loop's state, as the assembly reads and writes it: every field 8 octets, at the offsets
/// `template` names.
pub const Loop = extern struct {
    stream: [*]const u8,
    literals_length: [*]const u64,
    offset: [*]const u64,
    match_length: [*]const u64,
    /// Where the next sequence's literals go.
    output: [*]u8,
    /// The output's end less `copy_overrun_len`: the last place a sequence's octets may end.
    output_limit: [*]const u8,
    /// The call's first octet the window has not taken.
    synced: [*]const u8,
    /// The next literal, and the literals the loop may still take.
    literals: [*]const u8,
    literals_room: usize,
    /// The match octets the block may still promise against Block_Maximum_Size.
    promised_room: usize,
    window_len: u64,
    position: usize,
    /// The sequences the loop may take; the assembly leaves the count it took here.
    count: usize,
    repeats: [constants.repeated_offsets_initial.len]u64,
    states: [constants.repeated_offsets_initial.len]u64,
    /// `repeat_indices`, which the assembly reads a match of a distance below a chunk through.
    patterns: *const [constants.copy_chunk_len][constants.copy_chunk_len]u8,
};

/// For each distance below a chunk, the index of each octet of a match's first chunk among the
/// distance's octets before the match: the octet's place modulo the distance, as each octet is the
/// one the distance before it.
const repeat_indices: [constants.copy_chunk_len][constants.copy_chunk_len]u8 = indices: {
    var indices: [constants.copy_chunk_len][constants.copy_chunk_len]u8 = @splat(@splat(0));
    for (indices[1..], 1..) |*row, distance| {
        for (row, 0..) |*index, place| index.* = place % distance;
    }
    break :indices indices;
};

/// The most a sequence's copies write past its octets, and read past its literals: two chunks.
pub const copy_overrun_len = constants.copy_chunk_len + constants.copy_chunk_len;

/// Runs the loop over `run` as `fast_sequences.run_loop` does, for a caller that checked `takes`.
pub fn run_loop(comptime Window: type, run: *block.Run, context: block.Context, stream: []const u8, tables: *const sequences.Tables, sink: *block.Sink(Window), literal_source: []const u8) void {
    const output = sink.output;
    if (output.len < copy_overrun_len or literal_source.len < copy_overrun_len) return;
    // The loop checks a match's source address against `synced`, which would wrap for an output
    // below Window_Size; such an output leaves every sequence to `step`, which checks indices.
    if (@intFromPtr(output.ptr) < context.window_len) return;
    // The literals the loop may take: each run's copies read up to `copy_overrun_len` past it.
    const literals_end = @min(run.section.len, literal_source.len - copy_overrun_len);
    if (run.literals_used > literals_end) return;
    assert(run.promised_len <= context.block_len_max and run.stream.left > 1);
    var loop: Loop = .{
        .stream = stream.ptr,
        .literals_length = @ptrCast(&tables.literals_length),
        .offset = @ptrCast(&tables.offset),
        .match_length = @ptrCast(&tables.match_length),
        .output = output[sink.written..].ptr,
        .output_limit = output[output.len - copy_overrun_len ..].ptr,
        .synced = output[sink.synced.*..].ptr,
        .literals = literal_source[run.literals_used..].ptr,
        .literals_room = literals_end - run.literals_used,
        .promised_room = context.block_len_max - run.promised_len,
        .window_len = context.window_len,
        .position = run.stream.position,
        // The block's last sequence reads no states, and `step` takes it.
        .count = run.stream.left - 1,
        .repeats = undefined,
        .states = undefined,
        .patterns = &repeat_indices,
    };
    for (&loop.repeats, context.repeats) |*held, repeat| held.* = repeat;
    for (&loop.states, run.stream.states) |*held, state| held.* = state;
    const taken = switch (offsets_of(tables)) {
        inline else => |offsets| execute(offsets, &loop),
    };
    assert(taken < run.stream.left);
    run.stream.position = loop.position;
    run.stream.left -= @intCast(taken);
    for (context.repeats, loop.repeats) |*repeat, held| repeat.* = @intCast(held);
    for (&run.stream.states, loop.states) |*state, held| state.* = @intCast(held);
    run.literals_used = @intCast(literals_end - loop.literals_room);
    run.promised_len = @intCast(context.block_len_max - loop.promised_room);
    sink.written = @intFromPtr(loop.output) - @intFromPtr(output.ptr);
    work_module.add(context.work, work_module.of(taken));
}

/// Which way the loop takes a sequence's offset: through branches, for a block whose offsets are
/// nearly all new, which a branch predicts; or through selects, for a block whose offsets repeat
/// often enough that a branch would mispredict.
const Offsets = enum { branches, selects };

/// The way `tables` has the loop take the block's offsets.
fn offsets_of(tables: *const sequences.Tables) Offsets {
    return if (tables.offset_repeat_share() >= constants.offset_selects_cells_min) .selects else .branches;
}

/// Takes sequences until the margins fail or one is left, as `Loop` describes, and returns how many
/// it took.
noinline fn execute(comptime offsets: Offsets, loop: *Loop) usize {
    return asm volatile (template(offsets)
        : [taken] "={x0}" (-> usize),
        : [loop] "{x0}" (loop),
        : .{
          .memory = true,
          .nzcv = true,
          .v0 = true,
          .v1 = true,
          .x1 = true,
          .x2 = true,
          .x3 = true,
          .x4 = true,
          .x5 = true,
          .x6 = true,
          .x7 = true,
          .x8 = true,
          .x9 = true,
          .x10 = true,
          .x11 = true,
          .x12 = true,
          .x13 = true,
          .x14 = true,
          .x15 = true,
          .x16 = true,
          .x17 = true,
          .x19 = true,
          .x20 = true,
          .x21 = true,
          .x22 = true,
          .x23 = true,
          .x24 = true,
          .x25 = true,
          .x26 = true,
          .x27 = true,
          .x28 = true,
          .x30 = true,
        });
}

comptime {
    const repeats_len = constants.repeated_offsets_initial.len;
    assert(repeats_len == sequences.slot(.match_length) + 1);
    assert(@sizeOf(sequences.Cell) == @sizeOf(u64));
    // The fields `ldp` loads in pairs are adjacent.
    assert(@offsetOf(Loop, "literals_length") == @offsetOf(Loop, "stream") + @sizeOf(u64));
    assert(@offsetOf(Loop, "match_length") == @offsetOf(Loop, "offset") + @sizeOf(u64));
    assert(@offsetOf(Loop, "promised_room") == @offsetOf(Loop, "literals_room") + @sizeOf(u64));
    // A cell's base is its low 32 bits, its bits and extra bits an octet each, and its baseline
    // the rest, which one shift gives alone.
    assert(@bitOffsetOf(sequences.Cell, "base") == 0 and @bitSizeOf(@FieldType(sequences.Cell, "base")) == @bitSizeOf(u32));
    assert(@bitSizeOf(@FieldType(sequences.Cell, "bits")) == @bitSizeOf(u8) and @bitSizeOf(@FieldType(sequences.Cell, "extra_bits")) == @bitSizeOf(u8));
    assert(@bitOffsetOf(sequences.Cell, "baseline") + @bitSizeOf(@FieldType(sequences.Cell, "baseline")) == @bitSizeOf(u64));
    // A chunk is one vector register, and a pair of them one `ldp`.
    assert(constants.copy_chunk_len == @sizeOf(u128));
}

/// The loop's text, its offsets taken as `offsets` says, with the offsets and constants it names
/// filled in.
fn template(comptime offsets: Offsets) []const u8 {
    return std.fmt.comptimePrint(switch (offsets) {
        .branches => joined(&.{ loop_text.decode, loop_text.offsets_by_branches, loop_text.checks, loop_text.window_by_branches, loop_text.copies, loop_text.repeats_by_branches, loop_text.tail }),
        .selects => joined(&.{ loop_text.decode, loop_text.offsets_by_selects, loop_text.checks, loop_text.window_by_selects, loop_text.copies, loop_text.tail }),
    }, template_arguments);
}

/// `pieces` one after another, each ending its last line.
fn joined(comptime pieces: []const []const u8) []const u8 {
    comptime var text: []const u8 = "";
    inline for (pieces) |piece| text = text ++ piece ++ "\n";
    return text;
}

const template_arguments = .{
    .stream = @offsetOf(Loop, "stream"),
    .offset = @offsetOf(Loop, "offset"),
    .patterns = @offsetOf(Loop, "patterns"),
    .output = @offsetOf(Loop, "output"),
    .synced = @offsetOf(Loop, "synced"),
    .literals = @offsetOf(Loop, "literals"),
    .literals_room = @offsetOf(Loop, "literals_room"),
    .window_len = @offsetOf(Loop, "window_len"),
    .position = @offsetOf(Loop, "position"),
    .count = @offsetOf(Loop, "count"),
    .repeats = @offsetOf(Loop, "repeats"),
    .repeat3 = @offsetOf(Loop, "repeats") + (constants.repeated_offsets_initial.len - 1) * @sizeOf(u64),
    .states = @offsetOf(Loop, "states"),
    .state3 = @offsetOf(Loop, "states") + sequences.slot(.match_length) * @sizeOf(u64),
    .read_min = constants.fast_read_position_min,
    .bits_at = @bitOffsetOf(sequences.Cell, "bits"),
    .extra_at = @bitOffsetOf(sequences.Cell, "extra_bits"),
    .baseline_at = @bitOffsetOf(sequences.Cell, "baseline"),
    .output_limit = @offsetOf(Loop, "output_limit"),
    .repeat_values = constants.repeat_offset_values,
    .chunk = constants.copy_chunk_len,
    .chunk_shift = std.math.log2_int(usize, constants.copy_chunk_len),
    .pair = copy_overrun_len,
};

test "a block's offsets go by selects once enough of its offset cells name a repeat" {
    var tables: sequences.Tables = undefined;
    tables.accuracy_logs[sequences.slot(.offset)] = constants.offset_accuracy_log_max;
    tables.offset_repeat_cells = constants.offset_selects_cells_min - 1;
    try std.testing.expectEqual(.branches, offsets_of(&tables));
    tables.offset_repeat_cells = constants.offset_selects_cells_min;
    try std.testing.expectEqual(.selects, offsets_of(&tables));
    // A table of 32 cells counts each as 8 of 256: 2 is 16, below the least, and 3 is 24.
    tables.accuracy_logs[sequences.slot(.offset)] = constants.offset_default_accuracy_log;
    tables.offset_repeat_cells = 2;
    try std.testing.expectEqual(.branches, offsets_of(&tables));
    tables.offset_repeat_cells = 3;
    try std.testing.expectEqual(.selects, offsets_of(&tables));
}
