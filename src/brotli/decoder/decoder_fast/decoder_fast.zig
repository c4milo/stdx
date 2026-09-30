//! The brotli decoder's fast path (decision 16): the command loop decision 16's table names, with
//! its match copy (S4).
//!
//! The loop runs while at least `input_slack` octets of input remain, checked at the top of each
//! iteration. While `output_margin` octets of output room remain, one check at the top of a chain,
//! and one after its literals, cover every write it makes; below it, each write checks the room it
//! stores into, and a write whose room is short returns to the checked path (decision 32). An
//! iteration refills a 64-bit bit buffer with one 8-octet little-endian load (as S1 for DEFLATE)
//! and takes a chain of the checked path's command phases, each an inline function: a block
//! switch, an insert-and-copy symbol and its extra bits, up to `chunk_len_max` literals, a
//! distance, and up to `chunk_len_max` octets of a copy or of a dictionary word. The common chain,
//! a whole command whose copy stays within the output, runs in `straight_loop`, a function of its
//! own with the loop's state in locals, so that the compiler keeps them in registers where the
//! rarer chains' code beside it made it spill them (`run`). It decodes with the meta-block's
//! lookup tables (claim B3), writes straight into the caller's output, copies in chunks that may
//! run past a copy's end into the room it checked (S4), and reads history from the output and,
//! before the octets the output holds, from the window, which takes the call's octets when the
//! call ends (the window-once claim).
//!
//! It decodes only what is valid: before a length past the meta-block, a distance RFC 7932 refuses
//! or a dictionary reference that names no word, it stops with the phase's bits unused, and the
//! checked path takes the phase again and refuses it. So both paths write the same octets and give
//! the same verdict on every input (decision 16).

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const context = @import("../../context.zig");
const Claims = @import("../../claims.zig").Claims;
const state_module = @import("../decoder_state.zig");
const commands = @import("../decoder_commands.zig");
const copies = @import("decoder_fast_copy.zig");
const words = @import("decoder_fast_word.zig");
const literal_runs = @import("decoder_fast_literals.zig");
const straight = @import("decoder_fast_command.zig");
const chain = @import("decoder_fast_chain.zig");
const aarch64 = @import("decoder_fast_aarch64.zig");
const x86_64 = @import("decoder_fast_x86_64.zig");
const dictionary = @import("../../dictionary.zig");
const transform = @import("../../transform.zig");
const State = state_module.State;
const Category = state_module.Category;
const Phase = state_module.Phase;

/// Decision 16's input margin: the octets a refill reads.
pub const input_slack = @sizeOf(u64);

/// Decision 16's output margin, which decision 32 keeps for a chain's common case: the most a
/// chain writes between two checks, `chunk_len_max` and a chunk past it, since a copy's last chunk
/// may run past the copy.
pub const output_margin = constants.chunk_len_max + constants.copy_chunk_len;

/// How the loop checks the output's room (decision 32): against the margin, at the top of each chain
/// and after its literals, or at each write, once less than the margin remains. Each mode is its
/// own instance of `run`, so the margin's mode compiles as though the other did not exist.
pub const Room = enum { margin, each_write };

/// The mode the loop starts in for the room the writer holds.
pub fn room_of(writer: *const codec.Writer) Room {
    return if (writer.room_len() >= output_margin) .margin else .each_write;
}

/// The bits a refill leaves at least, and the most one phase takes: a block switch's type and
/// count codes and the count's extra bits.
pub const refill_bits = @bitSizeOf(u64) - @bitSizeOf(u8);
const count_extra_bits_max: u32 = constants.block_count_codes[constants.block_count_alphabet_len - 1].extra_bits;
pub const phase_bits_max = constants.code_len_max + constants.code_len_max + count_extra_bits_max;

comptime {
    assert(phase_bits_max <= refill_bits);
    assert(constants.distance_extra_bits_max + constants.code_len_max <= refill_bits);
}

/// Whether the fast path takes a phase: the command phases, which a block switch's phases lead
/// back to only through the checked path.
pub fn takes(phase: Phase) bool {
    return switch (phase) {
        .command, .command_extra, .literal, .distance, .copy, .dictionary_copy => true,
        else => false,
    };
}

/// Whether a phase reads no input: a copy, or the rest of a dictionary word.
fn reads_no_input(phase: Phase) bool {
    return phase == .copy or phase == .dictionary_copy;
}

/// Whether the fast path may start: the input's margin holds, or the phase reads no input, so that
/// a copy which ends the stream takes the fast path; and the output has room for an octet. Each
/// write checks its own room (decision 32).
pub fn has_margin(phase: Phase, bits: *const codec.BitReader, writer: *const codec.Writer) bool {
    const input_holds = bits.reader.octets.len - bits.reader.position >= input_slack;
    return (input_holds or reads_no_input(phase)) and writer.room_len() > 0;
}

/// What a phase says: go on, or stop for the checked path.
pub const Next = enum { go_on, stop };

pub const LiteralTables = literal_runs.LiteralTables;

/// The octets before a literal that its context reads, p1 and p2 (RFC 7932 §7.1).
const context_octets = 2;

/// The loop's state: the bit buffer and input position taken from the checked reader, the output
/// position taken from the checked writer, and the two octets a literal's context reads.
pub const Loop = struct {
    input: []const u8,
    position: usize,
    buffer: u64,
    count: u32,
    output: []u8,
    written: usize,
    /// Where the window's octets end in the output: at the call's first octet with the window-once
    /// claim, and where the loop started without it.
    start: usize,
    p1: u8,
    p2: u8,
    /// Invariant 17's count of the symbols the loop decoded, which a test build keeps.
    decoded: usize = 0,

    pub inline fn has_input_margin(self: *const Loop, comptime checks: bool) bool {
        @setRuntimeSafety(checks);
        return self.input.len - self.position >= input_slack;
    }

    /// The output room past the octets the loop wrote, against which each write checks the most it
    /// stores (decision 32).
    pub inline fn room(self: *const Loop, comptime checks: bool) usize {
        @setRuntimeSafety(checks);
        return self.output.len - self.written;
    }

    /// Fills the buffer to at least `refill_bits` bits with one 8-octet load, taking the whole
    /// octets that fit, with no branch: the bits above `count` repeat the input's next octets,
    /// which a later load writes again unchanged. The buffer holds at most 63 bits before it.
    inline fn refill_word(self: *Loop, comptime checks: bool) void {
        @setRuntimeSafety(checks);
        const loaded = std.mem.readInt(u64, self.input[self.position..][0..@sizeOf(u64)], .little);
        self.buffer |= loaded << @intCast(self.count);
        self.position += (@bitSizeOf(u64) - 1 - self.count) / @bitSizeOf(u8);
        self.count = refill_bits + self.count % @bitSizeOf(u8);
    }

    /// Takes whole octets, one at a time, while they fit the buffer. The bits above `count` stay
    /// zero.
    inline fn refill_octets(self: *Loop, comptime checks: bool) void {
        @setRuntimeSafety(checks);
        for (0..@sizeOf(u64)) |_| {
            if (self.count > refill_bits) return;
            self.buffer |= @as(u64, self.input[self.position]) << @intCast(self.count);
            self.position += 1;
            self.count += @bitSizeOf(u8);
        }
    }

    /// Takes `bit_count` bits, at most `phase_bits_max`, so the shift truncates unchecked; the
    /// count's subtraction checks it.
    pub inline fn take(self: *Loop, comptime checks: bool, bit_count: u32) void {
        @setRuntimeSafety(checks);
        self.buffer >>= @as(u6, @truncate(bit_count));
        self.count -= bit_count;
    }

    /// The symbol of `table`'s code the buffer starts with, its bits taken.
    pub inline fn decode(self: *Loop, comptime checks: bool, table: anytype) u16 {
        @setRuntimeSafety(checks);
        const symbol = table.decode_whole(checks, self.buffer);
        self.take(checks, symbol.len);
        if (builtin.is_test) self.decoded += 1;
        return symbol.value;
    }

    /// Moves past `len` octets written, and keeps the last two as p1 and p2 (RFC 7932 §7.1).
    pub inline fn wrote(self: *Loop, comptime checks: bool, len: usize) void {
        @setRuntimeSafety(checks);
        self.written += len;
        if (len >= context_octets) {
            self.p2 = self.output[self.written - context_octets];
            self.p1 = self.output[self.written - 1];
        } else if (len == 1) {
            self.p2 = self.p1;
            self.p1 = self.output[self.written - 1];
        }
    }
};

pub inline fn low_bits(value: u64, bit_count: u32) u64 {
    return value & ((@as(u64, 1) << @intCast(bit_count)) - 1);
}

/// Refills with one 8-octet load (as S1), or with the claim off, an octet at a time.
pub inline fn refill(comptime claims: Claims, loop: *Loop) void {
    @setRuntimeSafety(!claims.unchecked_loop);
    if (claims.word_refill) loop.refill_word(!claims.unchecked_loop) else loop.refill_octets(!claims.unchecked_loop);
}

/// Decodes command phases from `bits` into `writer` while the margins hold, until a phase the
/// checked path takes, and hands the bit buffer, the input position, the output position and the
/// context's octets back. Without the window-once claim, the window takes the octets the loop
/// wrote.
///
/// Two functions alternate: `straight_loop` takes command after command in its own frame while
/// each completes on the straight-line path; `chain` takes one chain of phases for what the last
/// command left, a block switch, extra bits after a refill, literals past their block, a copy from
/// the window or of more than a chunk, or a dictionary word.
pub noinline fn run(comptime claims: Claims, comptime room: Room, state: *State, window: anytype, bits: *codec.BitReader, writer: *codec.Writer) void {
    var loop: Loop = .{
        .input = bits.reader.octets,
        .position = bits.reader.position,
        .buffer = bits.bits.buffer,
        .count = bits.bits.count,
        .output = writer.octets,
        .written = writer.position,
        .start = if (claims.window_once) 0 else writer.position,
        .p1 = state.p1,
        .p2 = state.p2,
    };
    assert(loop.count <= @bitSizeOf(u64));
    // The literal tables are looked up before they are read, which their null block type forces. A
    // safe build would fill their 520 octets for every call, which a Linux build does through
    // compiler_rt's memset, an octet at a time, so decision 16's exception covers their
    // declaration alone; the loop below keeps the safety its functions set.
    var literal_tables: LiteralTables = tables: {
        @setRuntimeSafety(!claims.unchecked_loop);
        var fresh: LiteralTables = undefined;
        fresh.block_type = null;
        break :tables fresh;
    };
    for (0..iterations_max(true, &loop)) |_| {
        const link = straight_loop(claims, room, &loop, &literal_tables, state);
        if (link == .stop) break;
        if (chain.take(claims, room, link, &loop, &literal_tables, state, window) == .stop) break;
    }
    assert(loop.written <= loop.output.len and loop.position <= loop.input.len);
    // Hand the state back as the checked reader keeps it: no bit above `count` set.
    bits.bits = .{
        .buffer = if (loop.count >= @bitSizeOf(u64)) loop.buffer else low_bits(loop.buffer, loop.count),
        .count = @intCast(loop.count),
    };
    bits.reader.position = loop.position;
    writer.position = loop.written;
    state.p1 = loop.p1;
    state.p2 = loop.p2;
    if (builtin.is_test) state.work += loop.decoded;
    if (!claims.window_once) window.append(loop.output[loop.start..loop.written]);
}

/// The straight loop's step at a phase that reads no input: a copy within this call's output goes
/// on here, a chunk at a time, and gives null; a copy from the window, or the rest of a word the
/// checked path started, gives the chain's link, and a copy the room lacks `stop`.
inline fn no_input_step(comptime claims: Claims, comptime room: Room, loop: *Loop, state: *State, phase: *Phase) ?Link {
    @setRuntimeSafety(!claims.unchecked_loop);
    if (phase.* != .copy or state.command.distance > loop.written) return link_of(phase.*);
    if (copy_within_output(claims, room, loop, state, phase) == .stop) return .stop;
    return null;
}

/// The most chains a loop from the loop's point takes: each chain takes a bit or writes an octet,
/// or is one of the few chains of a command that lead to one that does, as the checked path's steps
/// are. Inline, so that taking the loop's address here leaves it in registers.
inline fn iterations_max(comptime checks: bool, loop: *const Loop) usize {
    @setRuntimeSafety(checks);
    const units = @bitSizeOf(u8) * (loop.input.len - loop.position) + @bitSizeOf(u64) + (loop.output.len - loop.written);
    return constants.decoder_steps_per_unit * units + constants.decoder_steps_floor;
}

/// Straight-line commands one after another, while each goes on along the straight path of
/// decoder_fast_command.zig: a function of its own, with the loop's state and the phase in locals,
/// so that the compiler keeps them in registers, and hands them back when it returns. Returns
/// the link the chain goes on from, the phase the last command stopped at, or `stop` for the
/// checked path. A chain starts once the input's margin holds and the buffer is refilled, and, in
/// the margin's mode, only while the margin holds; the checked path then starts the mode that checks
/// each write (decision 32).
noinline fn straight_loop(comptime claims: Claims, comptime room: Room, shared: *Loop, literal_tables: *LiteralTables, state: *State) Link {
    @setRuntimeSafety(!claims.unchecked_loop);
    var loop = shared.*;
    defer shared.* = loop;
    // The straight path moves the phase several times a command; the state needs it where this
    // function returns.
    var phase = state.phase;
    defer state.phase = phase;
    // Each iteration that goes on writes a copy, a word or a run of literals, or takes a symbol's
    // bits, so the room and the input end the loop; one that does neither returns.
    for (0..iterations_max(!claims.unchecked_loop, &loop)) |_| {
        if (room == .margin and loop.room(!claims.unchecked_loop) < output_margin) return .stop;
        if (reads_no_input(phase)) {
            if (no_input_step(claims, room, &loop, state, &phase)) |link| return link;
            continue;
        }
        if (!ready(claims, &loop)) return .stop;
        const link = straight_step(claims, room, &loop, literal_tables, state, &phase);
        if (link != .go_on) return link;
    }
    unreachable;
}

/// One step of the straight loop: the assembly's commands where it takes them, the CPU runs them
/// and a command starts (decision 23), or the straight path from the phase the loop stands at.
inline fn straight_step(comptime claims: Claims, comptime room: Room, loop: *Loop, literal_tables: *LiteralTables, state: *State, phase: *Phase) Link {
    @setRuntimeSafety(!claims.unchecked_loop);
    if (comptime aarch64.takes(claims, room)) {
        if (phase.* == .command) return aarch64.straight_commands(loop, literal_tables, state, phase);
    }
    if (comptime x86_64.takes(claims, room)) {
        if (phase.* == .command and state.assembly) return x86_64.straight_commands(loop, literal_tables, state, phase);
    }
    return straight.straight_from(claims, room, loop, literal_tables, state, phase);
}

/// Where a chain goes after one of its phases: on to another phase of the same command, to the
/// loop's next iteration, or back to the checked path.
pub const Link = enum { command, command_extra, literal, distance, copy, dictionary_copy, go_on, stop };

/// The link a phase starts a chain with: its own, for the command phases the fast path takes.
pub fn link_of(phase: Phase) Link {
    return switch (phase) {
        .command => .command,
        .command_extra => .command_extra,
        .literal => .literal,
        .distance => .distance,
        .copy => .copy,
        .dictionary_copy => .dictionary_copy,
        else => .stop,
    };
}

/// The link to a command's distance after its literals: with the input's margin, and in the
/// margin's mode, the next chain when the literals left less than the margin, since that chain then
/// checks each write.
pub inline fn to_distance(comptime claims: Claims, comptime room: Room, loop: *Loop) Link {
    @setRuntimeSafety(!claims.unchecked_loop);
    if (!ready(claims, loop)) return .stop;
    if (room == .margin and loop.room(!claims.unchecked_loop) < output_margin) return .go_on;
    return .distance;
}

/// Whether the input's margin holds for another phase, and when it does, a buffer refilled to at
/// least `refill_bits`: the state may bring a full buffer of 64 bits, and every later refill finds 63
/// or fewer.
pub inline fn ready(comptime claims: Claims, loop: *Loop) bool {
    @setRuntimeSafety(!claims.unchecked_loop);
    if (!loop.has_input_margin(!claims.unchecked_loop)) return false;
    if (loop.count < refill_bits) refill(claims, loop);
    return true;
}

/// Counts `len` octets of the meta-block as produced.
pub inline fn produce(comptime checks: bool, state: *State, len: usize) void {
    @setRuntimeSafety(checks);
    assert(len <= state.meta_block_left);
    state.meta_block_left -= @intCast(len);
}

/// Up to `chunk_len_max` octets of a back-reference within this call's output, which the straight
/// loop takes too. Below the margin, a copy whose chunks the room lacks goes an octet at a time, as
/// with S4 off, and a copy the room lacks returns to the checked path.
pub inline fn copy_within_output(comptime claims: Claims, comptime room: Room, loop: *Loop, state: *State, phase: *Phase) Next {
    @setRuntimeSafety(!claims.unchecked_loop);
    const len = @min(state.command.copy_left, constants.chunk_len_max);
    const back = state.command.distance;
    assert(back <= loop.written);
    // Decision 32: the room of the copy's octets, and of its chunks.
    if (room == .each_write and loop.room(!claims.unchecked_loop) < len) return .stop;
    const chunks = room == .margin or loop.room(!claims.unchecked_loop) >= copies.stored_len_max(claims.chunk_copies, len);
    if (chunks) copies.within(claims.chunk_copies, !claims.unchecked_loop, loop.output, loop.written, back, len) else copies.within(false, !claims.unchecked_loop, loop.output, loop.written, back, len);
    copied(!claims.unchecked_loop, loop, state, phase, len);
    return .go_on;
}

/// Moves past the `len` octets a copy wrote, and ends the command with its last chunk.
pub inline fn copied(comptime checks: bool, loop: *Loop, state: *State, phase: *Phase, len: u32) void {
    @setRuntimeSafety(checks);
    loop.wrote(checks, len);
    produce(checks, state, len);
    state.command.copy_left -= len;
    if (state.command.copy_left == 0) phase.* = commands.after_copy(state);
}
