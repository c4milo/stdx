//! The brotli decoder's fast path (decision 16): the command loop decision 16's table names, with
//! its match copy (S4).
//!
//! The loop runs while at least `input_slack` octets of input and `output_slack` octets of output
//! room remain, checked at the top of each iteration. An iteration refills a 64-bit bit buffer with
//! one 8-octet little-endian load (as S1 for DEFLATE) and takes one of the checked path's command
//! phases: a block switch, an insert-and-copy symbol and its extra bits, up to `chunk_len_max`
//! literals, a distance, or up to `chunk_len_max` octets of a copy or of a dictionary word. It
//! decodes with the meta-block's lookup tables (claim B3), writes straight into the caller's
//! output, copies in chunks that overrun into the margin (S4), and reads history from the output
//! and, before the call's output, from the window, which takes what the loop wrote when it returns.
//!
//! It decodes only what is valid: before a length past the meta-block, a distance RFC 7932 refuses
//! or a dictionary reference that names no word, it stops with the phase's bits unused, and the
//! checked path takes the phase again and refuses it. So both paths write the same octets and give
//! the same verdict on every input (decision 16).

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const context = @import("../context.zig");
const Claims = @import("../claims.zig").Claims;
const state_module = @import("decoder_state.zig");
const commands = @import("decoder_commands.zig");
const copies = @import("decoder_fast_copy.zig");
const State = state_module.State;
const Category = state_module.Category;
const Phase = state_module.Phase;

/// Decision 16's margins: the input a refill reads, and the output an iteration may write, as
/// decision 16's table sets it for brotli: `chunk_len_max` and a chunk past it. A copy's last
/// chunk may overrun the copy, but `chunk_len_max` is a whole number of chunks, so an iteration
/// writes at most `chunk_len_max`, and the chunk past it is spare.
pub const input_slack = @sizeOf(u64);
pub const output_slack = constants.chunk_len_max + constants.copy_chunk_len;

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

/// Whether the margins hold for the input and the room left.
pub fn has_margin(bits: *const codec.BitReader, writer: *const codec.Writer) bool {
    return bits.reader.octets.len - bits.reader.position >= input_slack and writer.room_len() >= output_slack;
}

/// What a phase says: go on, or stop for the checked path.
const Next = enum { go_on, stop };

/// The octets before a literal that its context reads, p1 and p2 (RFC 7932 §7.1).
const context_octets = 2;

/// The loop's state: the bit buffer and input position taken from the checked reader, the output
/// position taken from the checked writer, and the two octets a literal's context reads.
const Loop = struct {
    input: []const u8,
    position: usize,
    buffer: u64,
    count: u32,
    output: []u8,
    written: usize,
    /// Where the output stood when the loop started: the window holds every octet before it.
    start: usize,
    p1: u8,
    p2: u8,
    /// Invariant 17's count of the symbols the loop decoded, which a test build keeps.
    decoded: usize = 0,

    inline fn has_input_margin(self: *const Loop) bool {
        return self.input.len - self.position >= input_slack;
    }

    inline fn has_margin(self: *const Loop) bool {
        return self.has_input_margin() and self.output.len - self.written >= output_slack;
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

    inline fn take(self: *Loop, bit_count: u32) void {
        self.buffer >>= @intCast(bit_count);
        self.count -= bit_count;
    }

    /// The symbol of `table`'s code the buffer starts with, its bits taken.
    inline fn decode(self: *Loop, table: anytype) u16 {
        const symbol = table.decode_whole(self.buffer);
        self.take(symbol.len);
        if (builtin.is_test) self.decoded += 1;
        return symbol.value;
    }

    /// Moves past `len` octets written, and keeps the last two as p1 and p2 (RFC 7932 §7.1).
    inline fn wrote(self: *Loop, len: usize) void {
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

inline fn low_bits(value: u64, bit_count: u32) u64 {
    return value & ((@as(u64, 1) << @intCast(bit_count)) - 1);
}

/// Refills with one 8-octet load (as S1), or with the claim off, an octet at a time.
inline fn refill(comptime claims: Claims, loop: *Loop) void {
    if (claims.word_refill) loop.refill_word() else loop.refill_octets();
}

/// Decodes command phases from `bits` into `writer` while the margins hold, until a phase the
/// checked path takes, and hands the bit buffer, the input position, the output position and the
/// context's octets back. The window takes the octets the loop wrote.
pub noinline fn run(comptime claims: Claims, state: *State, window: anytype, bits: *codec.BitReader, writer: *codec.Writer) void {
    var loop: Loop = .{
        .input = bits.reader.octets,
        .position = bits.reader.position,
        .buffer = bits.bits.buffer,
        .count = bits.bits.count,
        .output = writer.octets,
        .written = writer.position,
        .start = writer.position,
        .p1 = state.p1,
        .p2 = state.p2,
    };
    assert(loop.count <= @bitSizeOf(u64));
    decode_phases(claims, &loop, state, window);
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
    window.append(loop.output[loop.start..loop.written]);
}

/// The loop itself.
fn decode_phases(comptime claims: Claims, loop: *Loop, state: *State, window: anytype) void {
    // Each phase takes a bit or writes an octet, or is one of the few phases of a command that
    // lead to one that does, as the checked path's steps are.
    const units = @bitSizeOf(u8) * (loop.input.len - loop.position) + @bitSizeOf(u64) + (loop.output.len - loop.written);
    const iterations_max = constants.decoder_steps_per_unit * units + constants.decoder_steps_floor;
    for (0..iterations_max) |_| {
        if (!loop.has_margin()) return;
        // The state may bring a full buffer of 64 bits; every later refill finds 63 or fewer.
        if (loop.count < refill_bits) refill(claims, loop);
        const next: Next = switch (state.phase) {
            .command => command(loop, state),
            .command_extra => command_extra(loop, state),
            .literal => literals(claims, loop, state),
            .distance => distance(loop, state),
            .copy => copy(claims, loop, state, window),
            .dictionary_copy => word(loop, state),
            else => .stop,
        };
        if (next == .stop) return;
    }
    unreachable;
}

/// A block switch's type and count (RFC 7932 §6), both codes and the count's extra bits at once:
/// `phase_bits_max`, which a refill leaves.
fn block_switch(loop: *Loop, state: *State, category: Category) Next {
    assert(loop.count >= phase_bits_max);
    const blocks = commands.blocks_of(state, category);
    commands.switch_type(blocks, loop.decode(&blocks.type_code));
    const code = constants.block_count_codes[loop.decode(&blocks.count_code)];
    blocks.count_left = code.base + @as(u32, @intCast(low_bits(loop.buffer, code.extra_bits)));
    loop.take(code.extra_bits);
    return .go_on;
}

/// An insert-and-copy symbol (RFC 7932 §5), and its extra bits when the buffer holds them.
fn command(loop: *Loop, state: *State) Next {
    if (commands.needs_switch(state, .insert_copy)) return block_switch(loop, state, .insert_copy);
    const blocks = commands.blocks_of(state, .insert_copy);
    const symbol = loop.decode(&state.insert_copy_codes[blocks.type_current]);
    commands.take_element(blocks);
    commands.set_command_codes(&state.command, symbol);
    state.phase = .command_extra;
    if (command_extra_bits(state) > loop.count) return .go_on;
    return command_extra(loop, state);
}

fn command_extra_bits(state: *const State) u32 {
    return @as(u32, constants.insert_length_codes[state.command.insert_code].extra_bits) + constants.copy_length_codes[state.command.copy_code].extra_bits;
}

/// The insert and copy lengths' extra bits (RFC 7932 §5).
fn command_extra(loop: *Loop, state: *State) Next {
    const insert = constants.insert_length_codes[state.command.insert_code];
    const copy_code = constants.copy_length_codes[state.command.copy_code];
    const extra = low_bits(loop.buffer, command_extra_bits(state));
    const insert_len = insert.base + @as(u32, @intCast(low_bits(extra, insert.extra_bits)));
    // RFC 7932 §9.3: literals that would exceed MLEN; the checked path refuses them.
    if (insert_len > state.meta_block_left) return .stop;
    loop.take(command_extra_bits(state));
    state.command.insert_left = insert_len;
    state.command.copy_len = copy_code.base + @as(u32, @intCast(extra >> insert.extra_bits));
    state.phase = if (insert_len > 0) .literal else commands.after_literals(state);
    return .go_on;
}

/// Up to `chunk_len_max` literals of the current block, each with the tree its context picks (RFC
/// 7932 §7.1, §7.3), refilling while the input's margin holds.
fn literals(comptime claims: Claims, loop: *Loop, state: *State) Next {
    assert(state.command.insert_left > 0);
    if (commands.needs_switch(state, .literal)) return block_switch(loop, state, .literal);
    const blocks = commands.blocks_of(state, .literal);
    const block_type = blocks.type_current;
    const row = state.literal_context_map[@as(usize, block_type) * constants.literal_contexts_count ..][0..constants.literal_contexts_count];
    const batch = @min(state.command.insert_left, blocks.count_left, constants.chunk_len_max);
    const written = switch (state.context_modes[block_type]) {
        inline else => |mode| literal_run(claims, mode, loop, state, row, batch),
    };
    assert(written >= 1);
    if (blocks.types_count >= constants.block_switch_types_min) blocks.count_left -= written;
    state.command.insert_left -= written;
    produce(state, written);
    if (state.command.insert_left == 0) state.phase = commands.after_literals(state);
    return .go_on;
}

/// Writes up to `batch` literals under one context mode, and returns how many. The first finds the
/// bits a refill left; each later one refills first when the input's margin allows it.
inline fn literal_run(comptime claims: Claims, comptime mode: context.Mode, loop: *Loop, state: *const State, row: *const [constants.literal_contexts_count]u8, batch: u32) u32 {
    for (0..batch) |index| {
        if (loop.count < constants.code_len_max) {
            if (!loop.has_input_margin()) return @intCast(index);
            refill(claims, loop);
        }
        const tree = row[context.literal_id(mode, loop.p1, loop.p2)];
        const literal: u8 = @intCast(loop.decode(&state.literal_codes[tree]));
        loop.output[loop.written] = literal;
        loop.written += 1;
        loop.p2 = loop.p1;
        loop.p1 = literal;
    }
    return batch;
}

/// Counts `len` octets of the meta-block as produced.
fn produce(state: *State, len: usize) void {
    assert(len <= state.meta_block_left);
    state.meta_block_left -= @intCast(len);
    state.produced += len;
}

/// The command's distance (RFC 7932 §4), resolved to a back-reference or a dictionary word before
/// its bits are taken, so that the checked path takes again one it refuses.
fn distance(loop: *Loop, state: *State) Next {
    // RFC 7932 §5: symbols below 128 reuse the last distance, and no distance code follows.
    if (state.command.last_distance) {
        _ = commands.resolve_distance(state, state.last_distances[0], false) catch return .stop;
        return .go_on;
    }
    if (commands.needs_switch(state, .distance)) return block_switch(loop, state, .distance);
    const blocks = commands.blocks_of(state, .distance);
    const id = context.distance_id(state.command.copy_len);
    const tree = state.distance_context_map[@as(usize, blocks.type_current) * constants.distance_contexts_count + id];
    const symbol = state.distance_codes[tree].decode_whole(loop.buffer);
    const code: u32 = symbol.value;
    const extra_bits = commands.distance_extra_bits(state, code);
    const extra: u32 = @intCast(low_bits(loop.buffer >> @intCast(symbol.len), extra_bits));
    const value = commands.distance_of(state, code, extra) catch return .stop;
    // RFC 7932 §4: the distance code 0 does not push its distance to the ring of last distances.
    _ = commands.resolve_distance(state, value, code != 0) catch return .stop;
    loop.take(symbol.len + extra_bits);
    if (builtin.is_test) loop.decoded += 1;
    commands.take_element(blocks);
    return .go_on;
}

/// Up to `chunk_len_max` octets of a back-reference: from this call's output, or from the window
/// for those before it.
fn copy(comptime claims: Claims, loop: *Loop, state: *State, window: anytype) Next {
    const len = @min(state.command.copy_left, constants.chunk_len_max);
    const back = state.command.distance;
    if (back <= loop.written) {
        copies.within(claims.chunk_copies, loop.output, loop.written, back, len);
    } else {
        copies.from_window(window, loop.output, loop.written, loop.start, back, len);
    }
    loop.wrote(len);
    produce(state, len);
    state.command.copy_left -= len;
    if (state.command.copy_left == 0) state.phase = commands.after_copy(state);
    return .go_on;
}

/// The rest of a dictionary word, transformed (RFC 7932 §8): at most `transformed_word_len_max`
/// octets.
fn word(loop: *Loop, state: *State) Next {
    const octets = state.word[state.word_written..state.word_len];
    @memcpy(loop.output[loop.written..][0..octets.len], octets);
    loop.wrote(octets.len);
    produce(state, octets.len);
    state.word_written = state.word_len;
    state.phase = commands.after_copy(state);
    return .go_on;
}
