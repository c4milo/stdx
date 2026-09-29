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
const output_margin = constants.chunk_len_max + constants.copy_chunk_len;

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
const refill_bits = @bitSizeOf(u64) - @bitSizeOf(u8);
const count_extra_bits_max: u32 = constants.block_count_codes[constants.block_count_alphabet_len - 1].extra_bits;
const phase_bits_max = constants.code_len_max + constants.code_len_max + count_extra_bits_max;

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

    pub inline fn has_input_margin(self: *const Loop) bool {
        return self.input.len - self.position >= input_slack;
    }

    /// The output room past the octets the loop wrote, against which each write checks the most it
    /// stores (decision 32).
    pub inline fn room(self: *const Loop) usize {
        return self.output.len - self.written;
    }

    /// Fills the buffer to at least `refill_bits` bits with one 8-octet load, taking the whole
    /// octets that fit, with no branch: the bits above `count` repeat the input's next octets,
    /// which a later load writes again unchanged. The buffer holds at most 63 bits before it.
    inline fn refill_word(self: *Loop) void {
        const loaded = std.mem.readInt(u64, self.input[self.position..][0..@sizeOf(u64)], .little);
        self.buffer |= loaded << @intCast(self.count);
        self.position += (@bitSizeOf(u64) - 1 - self.count) / @bitSizeOf(u8);
        self.count = refill_bits + self.count % @bitSizeOf(u8);
    }

    /// Takes whole octets, one at a time, while they fit the buffer. The bits above `count` stay
    /// zero.
    inline fn refill_octets(self: *Loop) void {
        for (0..@sizeOf(u64)) |_| {
            if (self.count > refill_bits) return;
            self.buffer |= @as(u64, self.input[self.position]) << @intCast(self.count);
            self.position += 1;
            self.count += @bitSizeOf(u8);
        }
    }

    /// Takes `bit_count` bits, at most `phase_bits_max`, so the shift truncates unchecked; the
    /// count's subtraction checks it.
    pub inline fn take(self: *Loop, bit_count: u32) void {
        self.buffer >>= @as(u6, @truncate(bit_count));
        self.count -= bit_count;
    }

    /// The symbol of `table`'s code the buffer starts with, its bits taken.
    pub inline fn decode(self: *Loop, table: anytype) u16 {
        const symbol = table.decode_whole(self.buffer);
        self.take(symbol.len);
        if (builtin.is_test) self.decoded += 1;
        return symbol.value;
    }

    /// Moves past `len` octets written, and keeps the last two as p1 and p2 (RFC 7932 §7.1).
    pub inline fn wrote(self: *Loop, len: usize) void {
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
    if (claims.word_refill) loop.refill_word() else loop.refill_octets();
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
    var literal_tables: LiteralTables = .{};
    for (0..iterations_max(&loop)) |_| {
        const link = straight_loop(claims, room, &loop, &literal_tables, state);
        if (link == .stop) break;
        if (chain(claims, room, link, &loop, &literal_tables, state, window) == .stop) break;
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

/// The most chains a loop from the loop's point takes: each chain takes a bit or writes an octet,
/// or is one of the few chains of a command that lead to one that does, as the checked path's steps
/// are. Inline, so that taking the loop's address here leaves it in registers.
inline fn iterations_max(loop: *const Loop) usize {
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
    var loop = shared.*;
    defer shared.* = loop;
    // The straight path moves the phase several times a command; the state needs it where this
    // function returns.
    var phase = state.phase;
    defer state.phase = phase;
    // Each iteration that goes on writes a copy, a word or a run of literals, or takes a symbol's
    // bits, so the room and the input end the loop; one that does neither returns.
    for (0..iterations_max(&loop)) |_| {
        if (room == .margin and loop.room() < output_margin) return .stop;
        if (reads_no_input(phase)) return link_of(phase);
        if (!ready(claims, &loop)) return .stop;
        const link = straight.straight_from(claims, room, &loop, literal_tables, state, &phase);
        if (link != .go_on) return link;
    }
    unreachable;
}

/// Where a chain goes after one of its phases: on to another phase of the same command, to the
/// loop's next iteration, or back to the checked path.
pub const Link = enum { command, command_extra, literal, distance, copy, dictionary_copy, go_on, stop };

/// The most links one chain takes: a command's symbol after its block switch, its extra bits, its
/// literals, its distance and its copy, and the end.
const links_per_chain_max = 8;

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

/// One chain of the phases of a command in a row from `first`, the link the straight loop handed
/// on, each an inline function. The chain checks the margins again only where a phase may lack
/// them: after a block switch, before a distance's block switch, and before a distance that
/// literals or the command's extra bits preceded. It ends with a copy or a word, where its phase
/// leaves the command for the next iteration, or at a phase the checked path takes. A chain at a
/// copy or at the rest of a word reads no input. Each write checks its own room (decision 32).
inline fn chain(comptime claims: Claims, comptime room: Room, first: Link, loop: *Loop, literal_tables: *LiteralTables, state: *State, window: anytype) Next {
    var link = first;
    for (0..links_per_chain_max) |_| {
        link = switch (link) {
            .command => on_command(claims, loop, state),
            .command_extra => on_command_extra(claims, loop, state),
            .literal => on_literal(claims, room, loop, literal_tables, state),
            .distance => on_distance(claims, room, loop, state),
            .copy => on_copy(claims, room, loop, state, window),
            .dictionary_copy => on_word(room, loop, state),
            .go_on => return .go_on,
            .stop => return .stop,
        };
    }
    unreachable;
}

/// An insert-and-copy symbol, after its block switch when its block is spent; then its extra bits,
/// when the buffer holds them.
inline fn on_command(comptime claims: Claims, loop: *Loop, state: *State) Link {
    if (commands.needs_switch(state, .insert_copy)) {
        block_switch(loop, state, .insert_copy);
        return if (ready(claims, loop)) .command else .stop;
    }
    const code = command(loop, state);
    if (code.extra_bits > loop.count) return .go_on;
    return extra_link(claims, loop, state, code);
}

/// The extra bits of a command the checked path or an earlier iteration started, from the codes it
/// kept.
inline fn on_command_extra(comptime claims: Claims, loop: *Loop, state: *State) Link {
    return extra_link(claims, loop, state, commands.command_code_of(state.command.insert_code, state.command.copy_code));
}

/// The command's extra bits, then its literals, or its distance once the margins hold for it.
inline fn extra_link(comptime claims: Claims, loop: *Loop, state: *State, code: commands.CommandCode) Link {
    if (command_extra(loop, state, code) == .stop) return .stop;
    if (state.phase == .distance and !ready(claims, loop)) return .stop;
    return link_of(state.phase);
}

/// A run of literals, after a refill the command's extra bits may have left it, or a block switch
/// the next iteration goes on from; then the distance once the margins hold for it.
inline fn on_literal(comptime claims: Claims, comptime room: Room, loop: *Loop, literal_tables: *LiteralTables, state: *State) Link {
    if (loop.count < phase_bits_max and !ready(claims, loop)) return .stop;
    if (commands.needs_switch(state, .literal)) {
        block_switch(loop, state, .literal);
        return .go_on;
    }
    if (room == .each_write and loop.room() == 0) return .stop;
    literal_runs.literals(claims, room, loop, literal_tables, state, &state.phase);
    if (state.phase != .distance) return .go_on;
    return to_distance(claims, room, loop);
}

/// The link to a command's distance after its literals: with the input's margin, and in the
/// margin's mode, the next chain when the literals left less than the margin, since that chain then
/// checks each write.
pub inline fn to_distance(comptime claims: Claims, comptime room: Room, loop: *Loop) Link {
    if (!ready(claims, loop)) return .stop;
    if (room == .margin and loop.room() < output_margin) return .go_on;
    return .distance;
}

/// The command's distance, after its block switch when its block is spent; then its copy, or a
/// word the checked path started. A word the distance wrote straight into the output ends the
/// command and the chain.
inline fn on_distance(comptime claims: Claims, comptime room: Room, loop: *Loop, state: *State) Link {
    if (!state.command.last_distance and commands.needs_switch(state, .distance)) {
        // After the straight-line command's extra bits, a block switch may need a refill.
        if (loop.count < phase_bits_max and !ready(claims, loop)) return .stop;
        block_switch(loop, state, .distance);
        if (!ready(claims, loop)) return .stop;
    }
    if (distance(room, loop, state) == .stop) return .stop;
    return switch (state.phase) {
        .copy, .dictionary_copy => link_of(state.phase),
        else => .go_on,
    };
}

inline fn on_copy(comptime claims: Claims, comptime room: Room, loop: *Loop, state: *State, window: anytype) Link {
    return if (copy(claims, room, loop, state, window) == .stop) .stop else .go_on;
}

inline fn on_word(comptime room: Room, loop: *Loop, state: *State) Link {
    return if (words.word(room, loop, state) == .stop) .stop else .go_on;
}

/// Whether the input's margin holds for another phase, and when it does, a buffer refilled to at
/// least `refill_bits`: the state may bring a full buffer of 64 bits, and every later refill finds 63
/// or fewer.
pub inline fn ready(comptime claims: Claims, loop: *Loop) bool {
    if (!loop.has_input_margin()) return false;
    if (loop.count < refill_bits) refill(claims, loop);
    return true;
}

/// A block switch's type and count (RFC 7932 §6), both codes and the count's extra bits at once:
/// `phase_bits_max`, which a refill leaves.
inline fn block_switch(loop: *Loop, state: *State, category: Category) void {
    assert(loop.count >= phase_bits_max);
    const blocks = commands.blocks_of(state, category);
    commands.switch_type(blocks, loop.decode(&blocks.type_code));
    const code = constants.block_count_codes[loop.decode(&blocks.count_code)];
    blocks.count_left = code.base + @as(u32, @intCast(low_bits(loop.buffer, code.extra_bits)));
    loop.take(code.extra_bits);
}

/// An insert-and-copy symbol (RFC 7932 §5), its codes kept for the phases, and what they give.
inline fn command(loop: *Loop, state: *State) commands.CommandCode {
    const blocks = commands.blocks_of(state, .insert_copy);
    const symbol = loop.decode(&state.insert_copy_codes[blocks.type_current]);
    commands.take_element(blocks);
    const code = commands.command_codes[symbol];
    state.command.insert_code = code.insert_code;
    state.command.copy_code = code.copy_code;
    state.command.last_distance = symbol < constants.insert_copy_last_distance_symbols;
    state.phase = .command_extra;
    return code;
}

/// The insert and copy lengths' extra bits (RFC 7932 §5), and the phase after them.
inline fn command_extra(loop: *Loop, state: *State, code: commands.CommandCode) Next {
    const extra = low_bits(loop.buffer, code.extra_bits);
    const insert_len = code.insert_base + @as(u32, @intCast(low_bits(extra, code.insert_extra_bits)));
    // RFC 7932 §9.3: literals that would exceed MLEN; the checked path refuses them.
    if (insert_len > state.meta_block_left) return .stop;
    loop.take(code.extra_bits);
    state.command.insert_left = insert_len;
    state.command.copy_len = code.copy_base + @as(u32, @intCast(extra >> code.insert_extra_bits));
    state.phase = if (insert_len > 0) .literal else commands.after_literals(state);
    return .go_on;
}

/// Counts `len` octets of the meta-block as produced.
pub inline fn produce(state: *State, len: usize) void {
    assert(len <= state.meta_block_left);
    state.meta_block_left -= @intCast(len);
}

/// The command's distance (RFC 7932 §4), resolved to a back-reference or a dictionary word before
/// its bits are taken, so that the checked path takes again one it refuses.
inline fn distance(comptime room: Room, loop: *Loop, state: *State) Next {
    // RFC 7932 §5: symbols below 128 reuse the last distance, and no distance code follows.
    if (state.command.last_distance) {
        _ = commands.resolve_distance(state, state.last_distances[0], false) catch return .stop;
        return .go_on;
    }
    const blocks = commands.blocks_of(state, .distance);
    const id = context.distance_id(state.command.copy_len);
    const tree = state.distance_context_map[@as(usize, blocks.type_current) * constants.distance_contexts_count + id];
    const symbol = state.distance_codes[tree].decode_whole(loop.buffer);
    const code: u32 = symbol.value;
    const extra_bits = commands.distance_extra_bits(state, code);
    const extra: u32 = @intCast(low_bits(loop.buffer >> @intCast(symbol.len), extra_bits));
    const value = commands.distance_of(state, code, extra) catch return .stop;
    const reach: u32 = @intCast(@min(state.window_distance_max, state_module.produced(state)));
    if (value > reach) {
        const len = words.word_straight(room, loop, state, value - reach - 1) orelse return .stop;
        take_distance(loop, blocks, symbol.len + extra_bits);
        loop.wrote(len);
        produce(state, len);
        state.phase = commands.after_copy(state);
        return .go_on;
    }
    // RFC 7932 §4: the distance code 0 does not push its distance to the ring of last distances.
    _ = commands.resolve_distance(state, value, code != 0) catch return .stop;
    take_distance(loop, blocks, symbol.len + extra_bits);
    return .go_on;
}

/// Takes a distance's bits, and the distance from its block.
inline fn take_distance(loop: *Loop, blocks: *state_module.Blocks, bit_count: u32) void {
    loop.take(bit_count);
    if (builtin.is_test) loop.decoded += 1;
    commands.take_element(blocks);
}

/// Up to `chunk_len_max` octets of a back-reference: from this call's output, or from the window
/// for those before it. Below the margin, a copy within the output whose chunks the room lacks goes
/// an octet at a time, as with S4 off, and a copy the room lacks returns to the checked path.
inline fn copy(comptime claims: Claims, comptime room: Room, loop: *Loop, state: *State, window: anytype) Next {
    const len = @min(state.command.copy_left, constants.chunk_len_max);
    const back = state.command.distance;
    // Decision 32: the room of the copy's octets, and of its chunks.
    if (room == .each_write and loop.room() < len) return .stop;
    const chunks = room == .margin or loop.room() >= copies.stored_len_max(claims.chunk_copies, len);
    if (back <= loop.written) {
        if (chunks) copies.within(claims.chunk_copies, loop.output, loop.written, back, len) else copies.within(false, loop.output, loop.written, back, len);
    } else {
        copies.from_window(window, loop.output, loop.written, loop.start, back, len);
    }
    loop.wrote(len);
    produce(state, len);
    state.command.copy_left -= len;
    if (state.command.copy_left == 0) state.phase = commands.after_copy(state);
    return .go_on;
}
