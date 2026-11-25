//! An empty object or array, `{}` or `[]`, in one step of the token loop (decision 82). RFC 8259
//! §4 and §5 let an object hold no member and an array no element. The grammar takes such a value
//! where it takes any value, and the container closes before any token comes into it, so the step
//! opens no container: it writes the two octets as the literal path writes `null`. Through
//! `begin_object` and `end_object` it took two steps, and a dependent's tree message, 341 objects
//! of which 256 are empty, took 28% more instructions an encode on aarch64.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const claims_file = @import("../../claims.zig");
const Claims = claims_file.Claims;
const runtime_safety_kept = claims_file.runtime_safety_kept;
const Encoder = @import("../encoder.zig").Encoder;
const Item = @import("../encoder_batch.zig").Item;
const Loop = @import("encoder_loop.zig").Loop;

/// The octets of an empty object and of an empty array.
pub const empty_object = [_]u8{ constants.begin_object, constants.end_object };
pub const empty_array = [_]u8{ constants.begin_array, constants.end_array };

/// Writes `octets`, an empty container's two, as one value into `output` from `written` on, moves
/// `written` past them and returns true. Where they do not go whole, or the container would pass
/// the depth limit, it returns false with the encoder as it was, for the checked path to take the
/// container's opening and its end.
pub inline fn take_empty(encoder: *Encoder, comptime claims: Claims, comptime octets: []const u8, output: []u8, written: *usize) bool {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    @setEvalBranchQuota(constants.token_loop_branch_quota);
    comptime assert(std.mem.eql(u8, octets, &empty_object) or std.mem.eql(u8, octets, &empty_array));
    assert(encoder.part == .between_tokens and encoder.pending_len == 0);
    assert(written.* <= output.len);
    var loop: Loop = .{ .encoder = encoder, .output = output, .rest = output[written.*..], .position = encoder.position, .depth = encoder.depth, .sequence = encoder.framing == .sequence };
    // The checked path refuses a container past the depth limit, empty or not.
    if (loop.depth == constants.depth_max) return false;
    // A value that takes no octets of the caller's, at the places any value goes.
    const entry: Item = .{ .token = .null };
    if (!loop.text_at(claims, .null, octets, &entry)) return false;
    loop.write_back_of(claims);
    written.* = output.len - loop.rest.len;
    return true;
}
