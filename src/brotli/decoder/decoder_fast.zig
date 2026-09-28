//! The brotli decoder's fast path (decision 16): the command loop decision 16's table names, with
//! its match copy (S4).
//!
//! The loop runs while at least `input_slack` octets of input and `output_slack` octets of output
//! room remain, checked at the top of each iteration. An iteration refills a 64-bit bit buffer with
//! one 8-octet little-endian load (as S1 for DEFLATE) and takes a chain of the checked path's
//! command phases, each an inline function, so that the loop's state stays in registers: a block
//! switch, an insert-and-copy symbol and its extra bits, up to `chunk_len_max` literals, a
//! distance, and up to `chunk_len_max` octets of a copy or of a dictionary word. It decodes with
//! the meta-block's lookup tables (claim B3), writes straight into the caller's output, copies in
//! chunks that overrun into the margin (S4), and reads history from the output and, before the
//! octets the output holds, from the window, which takes the call's octets when the call ends (the
//! window-once claim).
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

const LiteralTable = @TypeOf(@as(State, undefined).literal_codes[0]);

/// The literal table of each context of the literal block type `block_type`, looked up once for
/// each block type the loop meets, so that a literal takes its table in one load. It stays apart
/// from `Loop`, whose fields the compiler keeps in registers only while no array indexed at run
/// time lies among them.
const LiteralTables = struct {
    tables: [constants.literal_contexts_count]*const LiteralTable = undefined,
    block_type: ?u8 = null,
};

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
    /// Where the window's octets end in the output: at the call's first octet with the window-once
    /// claim, and where the loop started without it.
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

    /// Takes `bit_count` bits, at most `phase_bits_max`, so the shift truncates unchecked; the
    /// count's subtraction checks it.
    inline fn take(self: *Loop, bit_count: u32) void {
        self.buffer >>= @as(u6, @truncate(bit_count));
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
/// context's octets back. Without the window-once claim, the window takes the octets the loop
/// wrote.
pub noinline fn run(comptime claims: Claims, state: *State, window: anytype, bits: *codec.BitReader, writer: *codec.Writer) void {
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
    decode_phases(claims, &loop, &literal_tables, state, window);
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

/// The loop itself: iterations of chains of phases, each chain one iteration of this bounded
/// loop.
inline fn decode_phases(comptime claims: Claims, loop: *Loop, literal_tables: *LiteralTables, state: *State, window: anytype) void {
    // Each chain takes a bit or writes an octet, or is one of the few chains of a command that lead
    // to one that does, as the checked path's steps are.
    const units = @bitSizeOf(u8) * (loop.input.len - loop.position) + @bitSizeOf(u64) + (loop.output.len - loop.written);
    const iterations_max = constants.decoder_steps_per_unit * units + constants.decoder_steps_floor;
    for (0..iterations_max) |_| {
        if (decode_chain(claims, loop, literal_tables, state, window) == .stop) return;
    }
    unreachable;
}

/// Where a chain goes after one of its phases: on to another phase of the same command, to the
/// loop's next iteration, or back to the checked path.
const Link = enum { command, command_extra, literal, distance, copy, dictionary_copy, go_on, stop };

/// The most links one chain takes: a command's symbol after its block switch, its extra bits, its
/// literals, its distance and its copy, and the end.
const links_per_chain_max = 8;

/// The link a phase starts a chain with: its own, for the command phases the fast path takes.
fn link_of(phase: Phase) Link {
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

/// One chain: the phases of a command in a row, each an inline function, so that the loop's state
/// stays in registers. A chain starts once the margins hold and the buffer is refilled, and checks
/// them again only where a phase may lack them: after a block switch, and before a distance that
/// literals or the command's extra bits preceded. A chain ends with a copy or a word, where its
/// phase leaves the command for the next iteration, or at a phase the checked path takes.
inline fn decode_chain(comptime claims: Claims, loop: *Loop, literal_tables: *LiteralTables, state: *State, window: anytype) Next {
    if (!ready(claims, loop)) return .stop;
    var link = link_of(state.phase);
    for (0..links_per_chain_max) |_| {
        link = switch (link) {
            .command => on_command(claims, loop, state),
            .command_extra => on_command_extra(claims, loop, state),
            .literal => on_literal(claims, loop, literal_tables, state),
            .distance => on_distance(claims, loop, state),
            .copy => on_copy(claims, loop, state, window),
            .dictionary_copy => on_word(loop, state),
            .go_on => return .go_on,
            .stop => return .stop,
        };
    }
    unreachable;
}

/// An insert-and-copy symbol, after its block switch when its block is spent.
inline fn on_command(comptime claims: Claims, loop: *Loop, state: *State) Link {
    if (commands.needs_switch(state, .insert_copy)) {
        block_switch(loop, state, .insert_copy);
        return if (ready(claims, loop)) .command else .stop;
    }
    command(loop, state);
    if (command_extra_bits(state) > loop.count) return .go_on;
    return .command_extra;
}

/// The command's extra bits, then its literals, or its distance once the margins hold for it.
inline fn on_command_extra(comptime claims: Claims, loop: *Loop, state: *State) Link {
    if (command_extra(loop, state) == .stop) return .stop;
    if (state.phase == .distance and !ready(claims, loop)) return .stop;
    return link_of(state.phase);
}

/// A run of literals, after a refill the command's extra bits may have left it, or a block switch
/// the next iteration goes on from; then the distance once the margins hold for it.
inline fn on_literal(comptime claims: Claims, loop: *Loop, literal_tables: *LiteralTables, state: *State) Link {
    if (loop.count < phase_bits_max and !ready(claims, loop)) return .stop;
    if (commands.needs_switch(state, .literal)) {
        block_switch(loop, state, .literal);
        return .go_on;
    }
    literals(claims, loop, literal_tables, state);
    if (state.phase != .distance) return .go_on;
    return if (ready(claims, loop)) .distance else .stop;
}

/// The command's distance, after its block switch when its block is spent; then its copy or word.
inline fn on_distance(comptime claims: Claims, loop: *Loop, state: *State) Link {
    if (!state.command.last_distance and commands.needs_switch(state, .distance)) {
        block_switch(loop, state, .distance);
        if (!ready(claims, loop)) return .stop;
    }
    if (distance(loop, state) == .stop) return .stop;
    return link_of(state.phase);
}

inline fn on_copy(comptime claims: Claims, loop: *Loop, state: *State, window: anytype) Link {
    copy(claims, loop, state, window);
    return .go_on;
}

inline fn on_word(loop: *Loop, state: *State) Link {
    word(loop, state);
    return .go_on;
}

/// Whether the margins hold for another phase, and when they do, a buffer refilled to at least
/// `refill_bits`: the state may bring a full buffer of 64 bits, and every later refill finds 63
/// or fewer.
inline fn ready(comptime claims: Claims, loop: *Loop) bool {
    if (!loop.has_margin()) return false;
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

/// An insert-and-copy symbol (RFC 7932 §5).
inline fn command(loop: *Loop, state: *State) void {
    const blocks = commands.blocks_of(state, .insert_copy);
    const symbol = loop.decode(&state.insert_copy_codes[blocks.type_current]);
    commands.take_element(blocks);
    commands.set_command_codes(&state.command, symbol);
    state.phase = .command_extra;
}

fn command_extra_bits(state: *const State) u32 {
    return @as(u32, constants.insert_length_codes[state.command.insert_code].extra_bits) + constants.copy_length_codes[state.command.copy_code].extra_bits;
}

/// The insert and copy lengths' extra bits (RFC 7932 §5), and the phase after them.
inline fn command_extra(loop: *Loop, state: *State) Next {
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
/// 7932 §7.1, §7.3), refilling while the input's margin holds; and the phase after the command's
/// last literal.
inline fn literals(comptime claims: Claims, loop: *Loop, literal_tables: *LiteralTables, state: *State) void {
    assert(state.command.insert_left > 0);
    const blocks = commands.blocks_of(state, .literal);
    const block_type = blocks.type_current;
    if (literal_tables.block_type != block_type) look_up_literal_tables(literal_tables, state, block_type);
    const batch = @min(state.command.insert_left, blocks.count_left, constants.chunk_len_max);
    const written = switch (state.context_modes[block_type]) {
        inline else => |mode| literal_run(claims, mode, loop, &literal_tables.tables, batch),
    };
    assert(written >= 1);
    if (blocks.types_count >= constants.block_switch_types_min) blocks.count_left -= written;
    state.command.insert_left -= written;
    produce(state, written);
    if (state.command.insert_left == 0) state.phase = commands.after_literals(state);
}

/// The literal table of each context of `block_type`, from its row of the literal context map (RFC
/// 7932 §7.3).
fn look_up_literal_tables(literal_tables: *LiteralTables, state: *const State, block_type: u8) void {
    const row = state.literal_context_map[@as(usize, block_type) * constants.literal_contexts_count ..][0..constants.literal_contexts_count];
    for (&literal_tables.tables, row) |*table, tree| table.* = &state.literal_codes[tree];
    literal_tables.block_type = block_type;
}

/// Writes up to `batch` literals under one context mode, and returns how many. The first finds the
/// bits a refill left; each later one refills first when the input's margin allows it. A literal
/// table holds symbols below 256, so a symbol truncates to its octet unchecked.
inline fn literal_run(comptime claims: Claims, comptime mode: context.Mode, loop: *Loop, tables: *const [constants.literal_contexts_count]*const LiteralTable, batch: u32) u32 {
    const out = loop.output[loop.written..][0..batch];
    for (out, 0..) |*octet, index| {
        if (loop.count < constants.code_len_max) {
            if (!loop.has_input_margin()) {
                loop.written += index;
                return @intCast(index);
            }
            refill(claims, loop);
        }
        const literal: u8 = @truncate(loop.decode(tables[context.literal_id(mode, loop.p1, loop.p2)]));
        octet.* = literal;
        loop.p2 = loop.p1;
        loop.p1 = literal;
    }
    loop.written += batch;
    return batch;
}

/// Counts `len` octets of the meta-block as produced.
inline fn produce(state: *State, len: usize) void {
    assert(len <= state.meta_block_left);
    state.meta_block_left -= @intCast(len);
    state.produced += len;
}

/// The command's distance (RFC 7932 §4), resolved to a back-reference or a dictionary word before
/// its bits are taken, so that the checked path takes again one it refuses.
inline fn distance(loop: *Loop, state: *State) Next {
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
    // RFC 7932 §4: the distance code 0 does not push its distance to the ring of last distances.
    _ = commands.resolve_distance(state, value, code != 0) catch return .stop;
    loop.take(symbol.len + extra_bits);
    if (builtin.is_test) loop.decoded += 1;
    commands.take_element(blocks);
    return .go_on;
}

/// Up to `chunk_len_max` octets of a back-reference: from this call's output, or from the window
/// for those before it.
inline fn copy(comptime claims: Claims, loop: *Loop, state: *State, window: anytype) void {
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
}

/// The rest of a dictionary word, transformed (RFC 7932 §8): at most `transformed_word_len_max`
/// octets.
inline fn word(loop: *Loop, state: *State) void {
    const octets = state.word[state.word_written..state.word_len];
    @memcpy(loop.output[loop.written..][0..octets.len], octets);
    loop.wrote(octets.len);
    produce(state, octets.len);
    state.word_written = state.word_len;
    state.phase = commands.after_copy(state);
}
