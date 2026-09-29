//! The brotli fast path's chain of phases (decision 16): what the straight loop of decoder_fast.zig
//! leaves, each phase an inline function: a block switch before a command's symbol, its literals
//! or its distance, a command's extra bits after a refill, literals past their block, a distance
//! whose copy comes from the window or runs past a chunk, and the rest of a dictionary word the
//! checked path started. The loop's state stays in `run`'s frame here; the chains are rare.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const context = @import("../../context.zig");
const Claims = @import("../../claims.zig").Claims;
const state_module = @import("../decoder_state.zig");
const commands = @import("../decoder_commands.zig");
const copies = @import("decoder_fast_copy.zig");
const words = @import("decoder_fast_word.zig");
const literal_runs = @import("decoder_fast_literals.zig");
const fast = @import("decoder_fast.zig");
const State = state_module.State;
const Category = state_module.Category;
const Loop = fast.Loop;
const Link = fast.Link;
const Next = fast.Next;
const Room = fast.Room;
const LiteralTables = fast.LiteralTables;

/// The most links one chain takes: a command's symbol after its block switch, its extra bits, its
/// literals, its distance and its copy, and the end.
const links_per_chain_max = 8;

/// One chain of the phases of a command in a row from `first`, the link the straight loop handed
/// on, each an inline function. The chain checks the margins again only where a phase may lack
/// them: after a block switch, before a distance's block switch, and before a distance that
/// literals or the command's extra bits preceded. It ends with a copy or a word, where its phase
/// leaves the command for the next iteration, or at a phase the checked path takes. A chain at a
/// copy or at the rest of a word reads no input. Each write checks its own room (decision 32).
pub inline fn take(comptime claims: Claims, comptime room: Room, first: Link, loop: *Loop, literal_tables: *LiteralTables, state: *State, window: anytype) Next {
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
        return if (fast.ready(claims, loop)) .command else .stop;
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
    if (state.phase == .distance and !fast.ready(claims, loop)) return .stop;
    return fast.link_of(state.phase);
}

/// A run of literals, after a refill the command's extra bits may have left it, or a block switch
/// the next iteration goes on from; then the distance once the margins hold for it.
inline fn on_literal(comptime claims: Claims, comptime room: Room, loop: *Loop, literal_tables: *LiteralTables, state: *State) Link {
    if (loop.count < fast.phase_bits_max and !fast.ready(claims, loop)) return .stop;
    if (commands.needs_switch(state, .literal)) {
        block_switch(loop, state, .literal);
        return .go_on;
    }
    if (room == .each_write and loop.room() == 0) return .stop;
    literal_runs.literals(claims, room, loop, literal_tables, state, &state.phase);
    if (state.phase != .distance) return .go_on;
    return fast.to_distance(claims, room, loop);
}

/// The command's distance, after its block switch when its block is spent; then its copy, or a
/// word the checked path started. A word the distance wrote straight into the output ends the
/// command and the chain.
inline fn on_distance(comptime claims: Claims, comptime room: Room, loop: *Loop, state: *State) Link {
    if (!state.command.last_distance and commands.needs_switch(state, .distance)) {
        // After the straight-line command's extra bits, a block switch may need a refill.
        if (loop.count < fast.phase_bits_max and !fast.ready(claims, loop)) return .stop;
        block_switch(loop, state, .distance);
        if (!fast.ready(claims, loop)) return .stop;
    }
    if (distance(room, loop, state) == .stop) return .stop;
    return switch (state.phase) {
        .copy, .dictionary_copy => fast.link_of(state.phase),
        else => .go_on,
    };
}

inline fn on_copy(comptime claims: Claims, comptime room: Room, loop: *Loop, state: *State, window: anytype) Link {
    return if (copy(claims, room, loop, state, window) == .stop) .stop else .go_on;
}

inline fn on_word(comptime room: Room, loop: *Loop, state: *State) Link {
    return if (words.word(room, loop, state) == .stop) .stop else .go_on;
}

/// A block switch's type and count (RFC 7932 §6), both codes and the count's extra bits at once:
/// `fast.phase_bits_max`, which a refill leaves.
inline fn block_switch(loop: *Loop, state: *State, category: Category) void {
    assert(loop.count >= fast.phase_bits_max);
    const blocks = commands.blocks_of(state, category);
    commands.switch_type(blocks, loop.decode(&blocks.type_code));
    const code = constants.block_count_codes[loop.decode(&blocks.count_code)];
    blocks.count_left = code.base + @as(u32, @intCast(fast.low_bits(loop.buffer, code.extra_bits)));
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
    const extra = fast.low_bits(loop.buffer, code.extra_bits);
    const insert_len = code.insert_base + @as(u32, @intCast(fast.low_bits(extra, code.insert_extra_bits)));
    // RFC 7932 §9.3: literals that would exceed MLEN; the checked path refuses them.
    if (insert_len > state.meta_block_left) return .stop;
    loop.take(code.extra_bits);
    state.command.insert_left = insert_len;
    state.command.copy_len = code.copy_base + @as(u32, @intCast(extra >> code.insert_extra_bits));
    state.phase = if (insert_len > 0) .literal else commands.after_literals(state);
    return .go_on;
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
    const extra: u32 = @intCast(fast.low_bits(loop.buffer >> @intCast(symbol.len), extra_bits));
    const value = commands.distance_of(state, code, extra) catch return .stop;
    const reach: u32 = @intCast(@min(state.window_distance_max, state_module.produced(state)));
    if (value > reach) {
        const len = words.word_straight(room, loop, state, value - reach - 1) orelse return .stop;
        take_distance(loop, blocks, symbol.len + extra_bits);
        loop.wrote(len);
        fast.produce(state, len);
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
/// for those before it. Below the margin, a copy the room lacks returns to the checked path.
inline fn copy(comptime claims: Claims, comptime room: Room, loop: *Loop, state: *State, window: anytype) Next {
    const len = @min(state.command.copy_left, constants.chunk_len_max);
    const back = state.command.distance;
    if (back <= loop.written) return fast.copy_within_output(claims, room, loop, state, &state.phase);
    // Decision 32: the room of the copy's octets.
    if (room == .each_write and loop.room() < len) return .stop;
    copies.from_window(window, loop.output, loop.written, loop.start, back, len);
    fast.copied(loop, state, &state.phase, len);
    return .go_on;
}
