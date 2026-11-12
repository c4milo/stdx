//! A member's name and its value in one step of claim J11's loop, for `TextWriter`'s `member_*`
//! methods (decision 78): the name's step and the value's in one loop, with one write-back. After
//! a name the grammar's position is known, so the compiler folds the value's test for a separator.
//! A file of its own beside encoder_loop.zig, whose length it would pass.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const format = @import("../../format.zig");
const claims_file = @import("../../claims.zig");
const Claims = claims_file.Claims;
const runtime_safety_kept = claims_file.runtime_safety_kept;
const encoder_file = @import("../encoder.zig");
const Encoder = encoder_file.Encoder;
const Kind = encoder_file.Kind;
const Item = @import("../encoder_batch.zig").Item;
const Loop = @import("encoder_loop.zig").Loop;

/// Writes a member's `name` and its `value`, a token of `kind`, whole at `output[written..]`,
/// moves `written` past both and returns true. Where either does not go whole, it returns false
/// with the encoder as it was, and the checked path takes both: an output without the room, a
/// container past the depth limit, and every refusal. The octets it wrote past `written` are then
/// no part of the text.
pub inline fn take_member(encoder: *Encoder, comptime claims: Claims, comptime kind: Kind, name: *const Item, value: *const Item, output: []u8, written: *usize) bool {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    @setEvalBranchQuota(constants.token_loop_branch_quota);
    // A member's value is a value (RFC 8259 §4): no name, and no container's end.
    comptime assert(kind != .name and kind != .end_object and kind != .end_array);
    assert(encoder.part == .between_tokens and encoder.pending_len == 0);
    assert(written.* <= output.len and std.meta.activeTag(value.token) == kind);
    var loop: Loop = .{ .encoder = encoder, .output = output, .rest = output[written.*..], .position = encoder.position, .depth = encoder.depth, .sequence = encoder.framing == .sequence };
    var buffer: format.Buffer = undefined;
    if (!loop.item_of(claims, .name, name, &buffer)) return false;
    if (!loop.item_of(claims, kind, value, &buffer)) return false;
    loop.write_back_of(claims);
    written.* = output.len - loop.rest.len;
    return true;
}
