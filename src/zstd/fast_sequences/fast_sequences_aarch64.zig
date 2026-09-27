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
    const taken = execute(&loop);
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

/// Takes sequences until the margins fail or one is left, as `Loop` describes, and returns how many
/// it took.
noinline fn execute(loop: *Loop) usize {
    return asm volatile (template
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

/// The loop. Registers: x0 the loop's state; x1 the stream; x2, x3 and x4 the literals length,
/// offset and match length cells; x5 the bits the sequence reads; x7 the output; x8 the
/// literals; x9 the literals room; x10 the promised room; x11 the position less the 57 bits a load
/// needs before it, negative when the load has not them; x12 the sequences left;
/// x13, x14 and x15 the repeats; x16, x17 and x19 the states of literals length, offset and match
/// length. x6 and x20 to x28 and x30 hold each sequence's values. The numbered labels: 1 a
/// sequence, 2 a repeated offset, 3 the checks, 4 more literals, 5 the match, 6 a distance below a
/// chunk, 7 more of the match, 8 the next sequence, 9 the state stored back.
const template = std.fmt.comptimePrint(
    \\    ldp x1, x2, [x0, #{[stream]}]
    \\    ldp x3, x4, [x0, #{[offset]}]
    \\    ldr x7, [x0, #{[output]}]
    \\    ldr x8, [x0, #{[literals]}]
    \\    ldp x9, x10, [x0, #{[literals_room]}]
    \\    ldr x11, [x0, #{[position]}]
    \\    sub x11, x11, #{[read_min]}
    \\    ldr x12, [x0, #{[count]}]
    \\    ldp x13, x14, [x0, #{[repeats]}]
    \\    ldr x15, [x0, #{[repeat3]}]
    \\    ldp x16, x17, [x0, #{[states]}]
    \\    ldr x19, [x0, #{[state3]}]
    \\    cbz x12, 9f
    \\    // The loop starts a fetch line of its own, wherever the code before it ends.
    \\    .p2align 6
    \\1:
    \\    // The load's bits before the position.
    \\    tbnz x11, #63, 9f
    \\    // The cells of the three states. A state is below its table's length: its cell's
    \\    // baseline and the bits it read (RFC 8878 §4.1).
    \\    ldr x20, [x2, x16, lsl #3]
    \\    ldr x21, [x3, x17, lsl #3]
    \\    ldr x22, [x4, x19, lsl #3]
    \\    // The 8 octets whose last holds the position's bit, least significant first, shifted so
    \\    // that bit leads (RFC 8878 §4.1): 57 bits of the stream at least.
    \\    lsr x24, x11, #3
    \\    ldr x24, [x1, x24]
    \\    mvn x25, x11
    \\    and x25, x25, #7
    \\    lsl x24, x24, x25
    \\    // RFC 8878 §3.1.1.3.2.1.2: the offset, match length and literals length bits, then the
    \\    // states of literals length, match length and offset, each from the top of what the
    \\    // fields before it leave. A field of `count` bits: shifted past the bits before it, by
    \\    // one, then by 63 - `count`, so a field of none is 0. x25 counts the bits before it.
    \\    ubfx x25, x21, #{[extra_at]}, #8
    \\    lsr x26, x24, #1
    \\    mvn x27, x25
    \\    lsr x26, x26, x27
    \\    add x26, x26, w21, uxtw
    \\    ubfx x27, x22, #{[extra_at]}, #8
    \\    lsl x28, x24, x25
    \\    lsr x28, x28, #1
    \\    add x25, x25, x27
    \\    mvn x27, x27
    \\    lsr x28, x28, x27
    \\    add x28, x28, w22, uxtw
    \\    ubfx x27, x20, #{[extra_at]}, #8
    \\    lsl x30, x24, x25
    \\    lsr x30, x30, #1
    \\    add x25, x25, x27
    \\    mvn x27, x27
    \\    lsr x30, x30, x27
    \\    add x30, x30, w20, uxtw
    \\    // The next states: each field plus its cell's baseline, the cell's top 16 bits, shifted
    \\    // down as soon as the cell arrives, so the add that waits on the field is a plain one.
    \\    ubfx x27, x20, #{[bits_at]}, #8
    \\    lsr x20, x20, #{[baseline_at]}
    \\    lsl x6, x24, x25
    \\    lsr x6, x6, #1
    \\    add x25, x25, x27
    \\    mvn x27, x27
    \\    lsr x6, x6, x27
    \\    add x20, x6, x20
    \\    ubfx x27, x22, #{[bits_at]}, #8
    \\    lsr x22, x22, #{[baseline_at]}
    \\    lsl x6, x24, x25
    \\    lsr x6, x6, #1
    \\    add x25, x25, x27
    \\    mvn x27, x27
    \\    lsr x6, x6, x27
    \\    add x22, x6, x22
    \\    ubfx x27, x21, #{[bits_at]}, #8
    \\    lsr x21, x21, #{[baseline_at]}
    \\    lsl x6, x24, x25
    \\    lsr x6, x6, #1
    \\    add x5, x25, x27
    \\    mvn x27, x27
    \\    lsr x6, x6, x27
    \\    add x21, x6, x21
    \\    // x26 Offset_Value, x28 the match length, x30 the literals length. An Offset_Value above 3 is a new offset (RFC 8878 §3.1.1.5), and the
    \\    // repeats become it, the first and the second: x26 the distance, x24 and x27 the second
    \\    // and third repeats after it.
    \\    cmp x26, #{[repeat_values]}
    \\    b.ls 2f
    \\    sub x26, x26, #{[repeat_values]}
    \\    mov x24, x13
    \\    mov x27, x14
    \\3:
    \\    // The checks of the checked path, in one branch: the load held the bits read, 57 at least
    \\    // (a sequence of more goes to `step`); the literals are there; the block's size holds; the
    \\    // output holds the sequence's octets and the overrun of its copies; the offset is within
    \\    // Window_Size; and the match reads the call's own output, x25 its source, where a match
    \\    // reaching the window goes to `step`. x23 the match's target.
    \\    add x23, x7, x30
    \\    add x25, x23, x28
    \\    ldr x6, [x0, #{[output_limit]}]
    \\    cmp x5, #{[read_min]}
    \\    ccmp x30, x9, #2, ls
    \\    ccmp x28, x10, #2, ls
    \\    ccmp x25, x6, #2, ls
    \\    ldr x6, [x0, #{[window_len]}]
    \\    ccmp x26, x6, #2, ls
    \\    sub x25, x23, x26
    \\    ldr x6, [x0, #{[synced]}]
    \\    ccmp x6, x25, #2, ls
    \\    b.hi 9f
    \\    // The sequence is taken.
    \\    sub x11, x11, x5
    \\    sub x9, x9, x30
    \\    sub x10, x10, x28
    \\    mov x16, x20
    \\    mov x17, x21
    \\    mov x19, x22
    \\    mov x15, x27
    \\    mov x14, x24
    \\    mov x13, x26
    \\    // Its literals, two chunks, then the rest.
    \\    ldp q0, q1, [x8]
    \\    stp q0, q1, [x7]
    \\    cmp x30, #{[pair]}
    \\    b.hi 4f
    \\5:
    \\    // Its match, from x25: a chunk when the distance allows one, then the rest.
    \\    add x8, x8, x30
    \\    cmp x26, #{[chunk]}
    \\    b.lo 6f
    \\    ldr q0, [x25]
    \\    str q0, [x23]
    \\    cmp x28, #{[chunk]}
    \\    b.hi 7f
    \\8:
    \\    add x7, x23, x28
    \\    subs x12, x12, #1
    \\    b.ne 1b
    \\    b 9f
    \\2:
    \\    // Offset_Value 1 to 3 names a repeat, the next when the literals length is 0, and the
    \\    // fourth is the first less one (RFC 8878 §3.1.1.5). x6 the repeat's number from 1.
    \\    cmp x30, #0
    \\    cinc x6, x26, eq
    \\    cmp x6, #2
    \\    b.hs 10f
    \\    // The first: the repeats stay.
    \\    mov x26, x13
    \\    mov x24, x14
    \\    mov x27, x15
    \\    cbz x26, 9f
    \\    b 3b
    \\10:
    \\    b.ne 11f
    \\    // The second: it and the first swap.
    \\    mov x26, x14
    \\    mov x24, x13
    \\    mov x27, x15
    \\    cbz x26, 9f
    \\    b 3b
    \\11:
    \\    // The third, or the first less one: it, the first and the second.
    \\    sub x26, x13, #1
    \\    cmp x6, #3
    \\    csel x26, x15, x26, eq
    \\    mov x24, x13
    \\    mov x27, x14
    \\    cbz x26, 9f
    \\    b 3b
    \\4:
    \\    // The literals past the first two chunks, two at a time.
    \\    add x24, x8, #{[pair]}
    \\    add x27, x7, #{[pair]}
    \\    add x6, x7, x30
    \\    .p2align 4
    \\12:
    \\    ldp q0, q1, [x24], #{[pair]}
    \\    stp q0, q1, [x27], #{[pair]}
    \\    cmp x27, x6
    \\    b.lo 12b
    \\    b 5b
    \\7:
    \\    // The match past its first chunk: two chunks at a time where the distance holds two, and
    \\    // one at a time below; each reads octets written before.
    \\    add x24, x25, #{[chunk]}
    \\    add x27, x23, #{[chunk]}
    \\    add x20, x23, x28
    \\    cmp x26, #{[pair]}
    \\    b.lo 15f
    \\    .p2align 4
    \\13:
    \\    ldp q0, q1, [x24], #{[pair]}
    \\    stp q0, q1, [x27], #{[pair]}
    \\    cmp x27, x20
    \\    b.lo 13b
    \\    b 8b
    \\    .p2align 4
    \\15:
    \\    ldr q0, [x24], #{[chunk]}
    \\    str q0, [x27], #{[chunk]}
    \\    cmp x27, x20
    \\    b.lo 15b
    \\    b 8b
    \\6:
    \\    // Below a chunk: the first chunk is the distance's octets repeated, which one table
    \\    // lookup gives from them, each octet's index its place modulo the distance; past it the
    \\    // octets repeat every multiple of the distance, so the rest go a chunk at a time from the
    \\    // least multiple at least a chunk back, in x27. The load reads the chunk from the source,
    \\    // inside the output, whose octets past the distance the indices do not take.
    \\    ldr x6, [x0, #{[patterns]}]
    \\    add x6, x6, x26, lsl #{[chunk_shift]}
    \\    ldr q1, [x6]
    \\    ldr q0, [x25]
    \\    tbl v0.16b, {{v0.16b}}, v1.16b
    \\    str q0, [x23]
    \\    cmp x28, #{[chunk]}
    \\    b.ls 8b
    \\    mov x27, x26
    \\17:
    \\    cmp x27, #{[chunk]}
    \\    b.hs 18f
    \\    add x27, x27, x26
    \\    b 17b
    \\18:
    \\    sub x6, x23, x27
    \\    mov x24, #{[chunk]}
    \\19:
    \\    ldr q0, [x6, x24]
    \\    str q0, [x23, x24]
    \\    add x24, x24, #{[chunk]}
    \\    cmp x24, x28
    \\    b.lo 19b
    \\    b 8b
    \\9:
    \\    str x7, [x0, #{[output]}]
    \\    str x8, [x0, #{[literals]}]
    \\    stp x9, x10, [x0, #{[literals_room]}]
    \\    add x11, x11, #{[read_min]}
    \\    str x11, [x0, #{[position]}]
    \\    ldr x6, [x0, #{[count]}]
    \\    sub x6, x6, x12
    \\    stp x13, x14, [x0, #{[repeats]}]
    \\    str x15, [x0, #{[repeat3]}]
    \\    stp x16, x17, [x0, #{[states]}]
    \\    str x19, [x0, #{[state3]}]
    \\    mov x0, x6
, .{
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
});
