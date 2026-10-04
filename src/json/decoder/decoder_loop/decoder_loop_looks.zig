//! Claim J13's hand-off (decision 27): which of a long string's octets the walk of
//! decoder_loop_string.zig takes, which stops at each escape, and which the blocks of
//! decoder_loop_escapes.zig take, which gain only where escapes come close together.
//!
//! The walk takes the string a stretch at a time. After each stretch, `Looks` compares the octets
//! the stretch held with the octets written for them, which the walk reports anyway: where the
//! escapes dropped enough of them, the blocks take the string on, until they meet an octet they
//! do not take or blocks with no escape. The walk's own loop holds no count for this: one there
//! cost every string with escapes 2% to 6% on the N2 (design §8 step 18).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const wide = @import("../../wide.zig");
const Claims = @import("../../claims.zig").Claims;
const loop_string = @import("decoder_loop_string.zig");
const escape_blocks = @import("decoder_loop_escapes.zig");
const Copied = loop_string.Copied;
const Walked = loop_string.Walked;
const Left = escape_blocks.Left;

comptime {
    // A stretch a look cuts is longer than the longest escape, so a walk that takes nothing of
    // it was refused by the octet it starts with.
    assert(constants.escape_look_len_min > loop_string.pair_escape_len);
}

/// Whether claim J13's blocks take a string's dense escapes: where the claim is on and this
/// compilation has their lookup.
pub fn has_blocks(comptime claims: Claims) bool {
    return claims.decoder_escape_blocks and escape_blocks.available;
}

/// Whether the escapes of the stretch the walk last took came close enough together for the
/// blocks: of its `input_len` octets the escapes dropped one in every
/// `constants.escape_dense_octets_max` or more. A letter's escape drops one octet, and a `\u`
/// escape three to five, which the blocks do not take: `Looks` then waits longer.
pub inline fn dense(input_len: usize, output_len: usize) bool {
    assert(output_len <= input_len);
    return (input_len - output_len) * constants.escape_dense_octets_max >= input_len;
}

/// How long a stretch the walk takes before the next look at how close together a string's
/// escapes come.
pub const Looks = struct {
    len: usize = constants.escape_look_len_first,

    /// Looks at the stretch the walk took, `input_len` octets written as `output_len`: where its
    /// escapes came close together the blocks take the string on from `left`.
    ///
    /// Where they take `constants.escape_useful_len_min` octets or more, the next stretch is
    /// short: the string is likely dense past the octet that stopped them. Where they take
    /// fewer, the handover cost more than it gave, and the next stretch is twice as long, as it
    /// is after a stretch whose escapes came far apart: a text of `\u` escapes looks dense at
    /// every look and holds nothing for the blocks.
    pub fn look(self: *Looks, left: *Left, input_len: usize, output_len: usize) void {
        if (dense(input_len, output_len)) {
            const before_len = left.input.len;
            escape_blocks.take(left, left.input);
            if (before_len - left.input.len >= constants.escape_useful_len_min) {
                self.len = constants.escape_look_len_min;
                return;
            }
        }
        self.len = @min(self.len + self.len, constants.escape_look_len_max);
    }
};

/// `copy_rest` past its first stretch, the first `looks.len` octets of `rest`, which the walk
/// took as `first`. Before each stretch after it, `looks` looks at the last one, and where its
/// escapes came close together the blocks take the string on.
///
/// A stretch ends where its length says, so it may cut an escape or a character, which the walk
/// then stops at: the next stretch starts there. A stop further from the stretch's end than the
/// longest escape reaches is one of the octet itself, and the checked path's to name.
pub noinline fn copy(comptime claims: Claims, level: wide.Level, rest: []const u8, room: []u8, first: Walked, looks: *Looks) ?Copied {
    var left: Left = .{ .input = rest, .output = room };
    var stretch_len = @min(rest.len, looks.len);
    var walked = first;
    // Each pass takes at least one octet, or returns: a stretch the walk takes nothing of is
    // the input's last, or longer than `pair_escape_len`.
    for (0..rest.len + 1) |_| {
        const last = stretch_len == left.input.len;
        const took = walked.copied(left.input[0..stretch_len], left.output);
        left = .{ .input = left.input[took.input_len..], .output = left.output[took.output_len..] };
        if (walked.closed) return .{ .input_len = rest.len - left.input.len, .output_len = room.len - left.output.len };
        // The input ends inside the string, or the walk stopped at what no cut made.
        if (last or stretch_len - took.input_len >= loop_string.pair_escape_len) return null;
        looks.look(&left, took.input_len, took.output_len);
        stretch_len = @min(left.input.len, looks.len);
        walked = loop_string.walk_out_of_line(claims, level, left.input[0..stretch_len], left.output);
    }
    unreachable;
}
