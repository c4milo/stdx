//! The brotli fast path's straight-line command (decision 16): a command's phases in one call, its
//! values in locals, where the chain of phases in decoder_fast.zig would go back through its
//! dispatch between them. It takes an insert-and-copy symbol whose block is not spent, its extra
//! bits, its literals when one run of their block takes them all, and a distance that names a
//! back-reference within the call's output, of a copy of one chunk at most, or a dictionary word
//! (RFC 7932 §8, §9.3, §10). `straight_from` goes on with a command an earlier chain left at its
//! extra bits, its literals or its distance.
//!
//! Anything else it leaves where the chain goes on: a block switch before its symbol, its literals
//! or its distance, a copy from the window or of more than a chunk. It leaves the state as the
//! phases would have at that point, and returns the phase's link, or `stop` before a refusal, with
//! the bits of the step the checked path takes again unused.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const context = @import("../../context.zig");
const Claims = @import("../../claims.zig").Claims;
const state_module = @import("../decoder_state.zig");
const commands = @import("../decoder_commands.zig");
const copies = @import("decoder_fast_copy.zig");
const literal_runs = @import("decoder_fast_literals.zig");
const words = @import("decoder_fast_word.zig");
const fast = @import("decoder_fast.zig");
const State = state_module.State;
const Loop = fast.Loop;
const Link = fast.Link;

/// The most bits a distance takes: its code and its extra bits.
const distance_bits_max = constants.code_len_max + constants.distance_extra_bits_max;

/// The straight-line command from the phase the state stands at: its symbol, or where an earlier
/// chain left it, its extra bits, its literals or its distance. For a phase the chain takes, its
/// link. The caller has checked the margins and refilled the buffer.
pub inline fn straight_from(comptime claims: Claims, comptime room: fast.Room, loop: *Loop, literal_tables: *fast.LiteralTables, state: *State) Link {
    return switch (state.phase) {
        .command => straight_command(claims, room, loop, literal_tables, state),
        .command_extra => straight_extra_bits(claims, room, loop, literal_tables, state, commands.command_code_of(state.command.insert_code, state.command.copy_code)),
        .literal => straight_literals(claims, room, loop, literal_tables, state),
        .distance => straight_distance(claims, room, loop, state),
        else => fast.link_of(state.phase),
    };
}

/// A command whose insert-and-copy symbol's block is not spent, from its symbol on. The caller has
/// checked the margins and refilled the buffer.
pub inline fn straight_command(comptime claims: Claims, comptime room: fast.Room, loop: *Loop, literal_tables: *fast.LiteralTables, state: *State) Link {
    const blocks = commands.blocks_of(state, .insert_copy);
    if (commands.needs_switch(state, .insert_copy)) return .command;
    const symbol = loop.decode(&state.insert_copy_codes[blocks.type_current]);
    commands.take_element(blocks);
    const code = commands.command_codes[symbol];
    state.command.insert_code = code.insert_code;
    state.command.copy_code = code.copy_code;
    state.command.last_distance = symbol < constants.insert_copy_last_distance_symbols;
    if (code.extra_bits > loop.count) {
        state.phase = .command_extra;
        return .go_on;
    }
    return straight_extra_bits(claims, room, loop, literal_tables, state, code);
}

/// The command's extra bits (RFC 7932 §5), which the buffer holds, then its literals or its
/// distance.
inline fn straight_extra_bits(comptime claims: Claims, comptime room: fast.Room, loop: *Loop, literal_tables: *fast.LiteralTables, state: *State, code: commands.CommandCode) Link {
    const extra = fast.low_bits(loop.buffer, code.extra_bits);
    const insert_len = code.insert_base + @as(u32, @intCast(fast.low_bits(extra, code.insert_extra_bits)));
    // RFC 7932 §9.3: literals that would exceed MLEN; the checked path refuses them.
    if (insert_len > state.meta_block_left) {
        state.phase = .command_extra;
        return .stop;
    }
    loop.take(code.extra_bits);
    state.command.insert_left = insert_len;
    state.command.copy_len = code.copy_base + @as(u32, @intCast(extra >> code.insert_extra_bits));
    if (insert_len > 0) {
        state.phase = .literal;
        // The extra bits can leave the buffer short of a literal's code with the input's margin gone
        // behind them, and a run starts only with one or the other (`literals`): the checked path
        // takes the literals.
        if (loop.count < constants.code_len_max and !loop.has_input_margin()) return .stop;
        return straight_literals(claims, room, loop, literal_tables, state);
    }
    // A command starts only while the meta-block has octets left, so no literal ends it here.
    assert(state.meta_block_left > 0);
    state.phase = .distance;
    return straight_distance(claims, room, loop, state);
}

/// The command's literals when one run of the current block takes them all, then its distance and
/// copy as for a command of no literals; otherwise the link of the phase the literals stop at.
inline fn straight_literals(comptime claims: Claims, comptime room: fast.Room, loop: *Loop, literal_tables: *fast.LiteralTables, state: *State) Link {
    if (commands.needs_switch(state, .literal)) return .literal;
    if (room == .each_write and loop.room() == 0) return .stop;
    literal_runs.literals(claims, room, loop, literal_tables, state);
    if (state.phase != .distance) return .go_on;
    const link = fast.to_distance(claims, room, loop);
    if (link != .distance) return link;
    return straight_distance(claims, room, loop, state);
}

/// The command's distance, and its copy when both are the common case; otherwise the link of the
/// phase the command stands at.
inline fn straight_distance(comptime claims: Claims, comptime room: fast.Room, loop: *Loop, state: *State) Link {
    if (loop.count < distance_bits_max) {
        if (!loop.has_input_margin()) return .go_on;
        fast.refill(claims, loop);
    }
    const found = distance_of(loop, state) orelse return .distance;
    const reach: u32 = @intCast(@min(state.window_distance_max, state_module.produced(state)));
    // RFC 7932 §4: a distance past the octets the reference can reach names a dictionary word.
    if (found.value > reach) return straight_word(room, loop, state, found, found.value - reach - 1);
    // A copy from the window or of more than a chunk, which the copy phase takes.
    if (found.value > loop.written or state.command.copy_len > constants.chunk_len_max) return .distance;
    // RFC 7932 §9.3: a copy length that would exceed MLEN; the checked path refuses it.
    if (state.command.copy_len > state.meta_block_left) return .stop;
    // Decision 32: below the margin, the room the copy's chunks store into; with less, the copy
    // phase takes the copy.
    if (room == .each_write and loop.room() < copies.stored_len_max(claims.chunk_copies, state.command.copy_len)) return .distance;
    // A distance code takes its element of the block even when it takes no bits.
    if (!state.command.last_distance) {
        loop.take(found.bit_count);
        if (builtin.is_test) loop.decoded += 1;
        commands.take_element(commands.blocks_of(state, .distance));
    }
    // RFC 7932 §4: the distance code 0 and the last distance a symbol below 128 reuses do not push
    // their distance to the ring of last distances.
    if (found.push) {
        std.mem.copyBackwards(u32, state.last_distances[1..], state.last_distances[0 .. state.last_distances.len - 1]);
        state.last_distances[0] = found.value;
    }
    const len = state.command.copy_len;
    copies.within(claims.chunk_copies, loop.output, loop.written, found.value, len);
    loop.wrote(len);
    fast.produce(state, len);
    state.phase = commands.after_copy(state);
    return .go_on;
}

/// The dictionary word `word_id` names (RFC 7932 §8), transformed straight into the output, which
/// ends the command; `stop` for a word the room lacks or a reference the checked path refuses.
inline fn straight_word(comptime room: fast.Room, loop: *Loop, state: *State, found: Found, word_id: u32) Link {
    const len = words.word_straight(room, loop, state, word_id) orelse return .stop;
    // A distance code takes its element of the block; the last distance a symbol below 128 reuses
    // takes no bits and no element (RFC 7932 §5).
    if (!state.command.last_distance) {
        loop.take(found.bit_count);
        if (builtin.is_test) loop.decoded += 1;
        commands.take_element(commands.blocks_of(state, .distance));
    }
    loop.wrote(len);
    fast.produce(state, len);
    state.phase = commands.after_copy(state);
    return .go_on;
}

/// A distance, the bits its code and extra bits take, and whether it goes into the ring.
const Found = struct { value: u32, bit_count: u32, push: bool };

/// The command's distance from the buffer, its bits not yet taken (RFC 7932 §4): the last distance
/// for a symbol below 128, or a distance code of the tree its block type and copy length pick.
/// Null for a distance whose block is spent, or which resolves to zero or less, both of which the
/// distance phase takes.
inline fn distance_of(loop: *const Loop, state: *State) ?Found {
    // RFC 7932 §5: symbols below 128 reuse the last distance, and no distance code follows.
    if (state.command.last_distance) return .{ .value = state.last_distances[0], .bit_count = 0, .push = false };
    const blocks = commands.blocks_of(state, .distance);
    if (commands.needs_switch(state, .distance)) return null;
    const id = context.distance_id(state.command.copy_len);
    const tree = state.distance_context_map[@as(usize, blocks.type_current) * constants.distance_contexts_count + id];
    const symbol = state.distance_codes[tree].decode_whole(loop.buffer);
    const code: u32 = symbol.value;
    const extra_bits = commands.distance_extra_bits(state, code);
    const extra: u32 = @intCast(fast.low_bits(loop.buffer >> @intCast(symbol.len), extra_bits));
    const value = commands.distance_of(state, code, extra) catch return null;
    return .{ .value = value, .bit_count = symbol.len + extra_bits, .push = code != 0 };
}
