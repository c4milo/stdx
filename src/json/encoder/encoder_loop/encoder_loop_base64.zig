//! `TextWriter.base64`'s step (decision 73): a string of RFC 4648 §4's base 64 letters, its last
//! quantum padded, which the base64 module's encoder writes straight into the output, inside the
//! quotation marks and separators claim J11's loop writes for a string. A file of its own beside
//! encoder_loop.zig, whose length it would pass.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const base64 = @import("base64");
const constants = @import("../../constants.zig");
const wide = @import("../../wide.zig");
const claims_file = @import("../../claims.zig");
const Claims = claims_file.Claims;
const runtime_safety_kept = claims_file.runtime_safety_kept;
const Encoder = @import("../encoder.zig").Encoder;
const encoder_loop = @import("encoder_loop.zig");
const Loop = encoder_loop.Loop;

/// The CPU features the base 64 encoder starts with: AVX2 where the JSON encoder's level is. Both
/// take their wide path on x86-64 alone, and only with the caller's AVX2 (wide.zig, and the
/// base64 module's encoder), so the level says all the base 64 encoder reads.
pub fn features_of(level: wide.Level) codec.Features {
    return .{ .avx2 = level == .avx2 };
}

/// Writes `octets` as one whole string of base 64 letters at `output[written..]` and moves
/// `written` past it, when the output has room for all of it, and returns true; else writes
/// nothing, changes nothing and returns false. The encoder then stands after a string, as the
/// checked path leaves it after a string of these letters.
pub inline fn take_letters(encoder: *Encoder, comptime claims: Claims, octets: []const u8, output: []u8, written: *usize) bool {
    @setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);
    assert(encoder.part == .between_tokens and encoder.pending_len == 0);
    assert(written.* <= output.len and !encoder_loop.overlap(octets, output));
    var loop: Loop = .{ .encoder = encoder, .output = output, .rest = output[written.*..], .position = encoder.position, .depth = encoder.depth, .sequence = encoder.framing == .sequence };
    const letters_len = base64.Encoder.encoded_len(octets.len, true);
    const frame = loop.frame_of(claims, .string);
    const body = loop.open_body(claims, frame, 1 + letters_len + 1) orelse return false;
    body[0] = constants.quotation_mark;
    assert(letters_whole(encoder.level, octets, body[1..][0..letters_len]) == letters_len);
    body[body.len - 1] = constants.quotation_mark;
    loop.close(claims, .string, frame.ends_text);
    loop.write_back_of(claims);
    written.* = output.len - loop.rest.len;
    return true;
}

/// The letters of `octets` into `room`, which holds them all. Out of line: a value of base 64 pays
/// one call, and the method's step stays small.
noinline fn letters_whole(level: wide.Level, octets: []const u8, room: []u8) usize {
    var encoder: base64.Encoder = undefined;
    encoder.init(.{}, features_of(level));
    return encoder.encode_all(octets, room) catch unreachable;
}

comptime {
    // A piece of `TextWriter.base64` holds whole groups, so no piece but the last holds a pad.
    assert(constants.base64_piece_octets % base64.constants.group_octets == 0);
    assert(constants.base64_piece_letters == base64.Encoder.encoded_len(constants.base64_piece_octets, true));
}

test "take_letters writes a whole value where the room holds it, and nothing where it does not" {
    const testing = std.testing;
    var encoder: Encoder = undefined;
    encoder.init(.text, codec.Features.detect());
    var output: [constants.base64_piece_letters]u8 = @splat(0);
    var written: usize = 0;
    // "foo" is `"Zm9v"`, six octets: five leave it, and its state and the output as they were.
    try testing.expect(!take_letters(&encoder, .{}, "foo", output[0 .. "\"Zm9v\"".len - 1], &written));
    try testing.expectEqual(0, written);
    try testing.expectEqual(.between_tokens, encoder.part);
    try testing.expectEqual(0, output[0]);
    try testing.expect(take_letters(&encoder, .{}, "foo", &output, &written));
    try testing.expectEqualStrings("\"Zm9v\"", output[0..written]);
    try testing.expectEqual(.done, encoder.part);
}
