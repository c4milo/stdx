//! The brotli fast path's dictionary words (decision 16, RFC 7932 §8): a word a distance names,
//! transformed straight into the output, and the rest of a word the checked path started, each
//! checking below the margin the room it stores into (decision 32).

const std = @import("std");
const constants = @import("../../constants.zig");
const Claims = @import("../../claims.zig").Claims;
const state_module = @import("../decoder_state.zig");
const commands = @import("../decoder_commands.zig");
const dictionary = @import("../../dictionary.zig");
const transform = @import("../../transform.zig");
const fast = @import("decoder_fast.zig");
const State = state_module.State;
const Loop = fast.Loop;
const Room = fast.Room;
const Next = fast.Next;

/// The dictionary word a reference past the window names (RFC 7932 §8), transformed straight into
/// the output past what the loop wrote, and its length; null, having taken nothing, for a reference
/// the checked path refuses or a room too short for the transform. The wide transform stores
/// `wide_output_len` octets whatever the word's length, and a word near DICT's end, whose head DICT
/// does not hold, takes the exact one, which stores at most `transformed_word_len_max`.
pub inline fn word_straight(comptime claims: Claims, comptime room: Room, loop: *Loop, state: *const State, word_id: u32) ?usize {
    @setRuntimeSafety(claims.loop_checks);
    const reference = commands.word_reference(state, word_id) catch return null;
    const offset = dictionary.word_offset(reference.len, reference.index);
    const wide = offset + transform.wide_input_len <= dictionary.data.len;
    // Decision 32: below the margin, the room the transform stores into.
    if (room == .each_write and loop.room(claims.loop_checks) < @as(usize, if (wide) transform.wide_output_len else constants.transformed_word_len_max)) return null;
    const len = if (wide)
        transform.apply_wide(reference.transform_id, dictionary.data[offset..][0..transform.wide_input_len], reference.len, loop.output[loop.written..][0..transform.wide_output_len])
    else
        transform.apply(reference.transform_id, dictionary.word(reference.len, reference.index), loop.output[loop.written..][0..constants.transformed_word_len_max]);
    // RFC 7932 §9.3: a dictionary word that would exceed MLEN; the checked path refuses it.
    if (len > state.meta_block_left) return null;
    return len;
}

/// The rest of a dictionary word, transformed (RFC 7932 §8): at most `transformed_word_len_max`
/// octets; or `stop` when the output's room is short of them.
pub inline fn word(comptime claims: Claims, comptime room: Room, loop: *Loop, state: *State) Next {
    @setRuntimeSafety(claims.loop_checks);
    const octets = state.word[state.word_written..state.word_len];
    // Decision 32: below the margin, the word's rest.
    if (room == .each_write and loop.room(claims.loop_checks) < octets.len) return .stop;
    @memcpy(loop.output[loop.written..][0..octets.len], octets);
    loop.wrote(claims.loop_checks, octets.len);
    fast.produce(claims.loop_checks, state, octets.len);
    state.word_written = state.word_len;
    state.phase = commands.after_copy(state);
    return .go_on;
}
