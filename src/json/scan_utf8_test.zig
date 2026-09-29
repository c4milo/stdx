//! Tests of scan_utf8.zig's `valid`, the check over a whole buffer (decision 38), and of
//! `cut_character_len`, beside the file: scan_utf8.zig holds the check, its tables and their tests,
//! and would pass 500 lines with these.

const std = @import("std");
const testing = std.testing;
const constants = @import("constants.zig");
const utf8 = @import("utf8.zig");
const scan_utf8 = @import("scan_utf8.zig");
const valid = scan_utf8.valid;
const cut_character_len = scan_utf8.cut_character_len;

/// The edge octets of RFC 3629 §4's ranges, with one inside each, as scan_utf8.zig lists them.
const edge_octets = "\x00\x41\x7f\x80\x9f\xa0\xbf\xc0\xc1\xc2\xdf\xe0\xe1\xec\xed\xee\xef\xf0\xf1\xf3\xf4\xf5\xf7\xf8\xff";
const sequence_len = 3;

/// `valid` an octet at a time, the reference: utf8.zig's machine over the whole buffer.
fn valid_scalar(octets: []const u8) bool {
    var machine: utf8.Utf8 = .{};
    for (octets) |octet| {
        if (!machine.accept(octet)) return false;
    }
    return machine.between_characters();
}

/// Buffers of letters with an edge sequence at each offset across two groups and a block, and at
/// the end: a sequence takes each group through the ASCII test or the lookups, and through the cut
/// the block before an ASCII group leaves.
const valid_buffer_groups = 2;
const valid_buffer_blocks = valid_buffer_groups * constants.utf8_group_blocks + 1;
const valid_buffer_len = valid_buffer_blocks * constants.vector_len + 1;

test "valid judges a buffer as the machine does, with a sequence at every offset" {
    var buffer: [valid_buffer_len]u8 = undefined;
    for (0..valid_buffer_len - sequence_len + 1) |offset| for (edge_octets) |first| for (edge_octets) |second| for (edge_octets) |third| {
        buffer = @splat('a');
        buffer[offset..][0..sequence_len].* = .{ first, second, third };
        for ([_]usize{ offset + sequence_len, valid_buffer_len }) |len| try testing.expectEqual(valid_scalar(buffer[0..len]), valid(buffer[0..len]));
    };
}

test "valid takes whole characters that blocks cut, and refuses a cut one at the end" {
    try testing.expect(valid(""));
    try testing.expect(valid("a" ** 15 ++ "\xe2\x82\xac" ++ "b" ** 14));
    try testing.expect(valid("\xf0\x9f\x98\x80" ** 5));
    try testing.expect(!valid("a" ** 16 ++ "\xe2\x82"));
    try testing.expect(!valid("a" ** 15 ++ "\xe2\x82"));
    try testing.expect(!valid("\x80"));
    try testing.expect(!valid("a" ** 17 ++ "\xc0\xaf"));
}

test "valid takes a group of ASCII in one test, and finds the character the block before it cut" {
    const group = "a" ** constants.utf8_group_len;
    try testing.expect(valid(group ** 3));
    try testing.expect(valid(group ** 2 ++ "b"));
    try testing.expect(valid("a" ** (constants.utf8_group_len - 3) ++ "\xe2\x82\xac" ++ group));
    try testing.expect(valid("a" ** (constants.utf8_group_len - 1) ++ "\xc3\xa9" ++ group));
    try testing.expect(!valid("a" ** (constants.utf8_group_len - 2) ++ "\xe2\x82" ++ group));
    try testing.expect(!valid("a" ** (constants.utf8_group_len - 1) ++ "\xf0" ++ group));
    try testing.expect(!valid("a" ** (constants.utf8_group_len - 1) ++ "\x80" ++ group));
    try testing.expect(!valid(group ++ "\x80"));
    try testing.expect(!valid(group ++ "a" ** (constants.vector_len - 1) ++ "\xc3"));
    try testing.expect(!valid(group ** 2 ++ "\xed\xa0\x80" ++ group));
    // The one octet from 0x80 up in a group of NUL octets: the ORed group is exactly 0x80.
    try testing.expect(!valid("\x00" ** (constants.utf8_group_len - 1) ++ "\x80" ++ group));
    // A continuation octet after an ASCII group, whose block before ended with a whole character:
    // judged against the ASCII group's last block, not the character's.
    try testing.expect(!valid("a" ** (constants.utf8_group_len - 3) ++ "\xe2\x82\xac" ++ group ++ "\x80" ++ "a" ** (constants.utf8_group_len - 1)));
}

/// The longest input the fuzzer gives `valid`: four groups, and a tail of a cut character.
const fuzz_input_groups = 4;
const fuzz_input_len_max = fuzz_input_groups * constants.utf8_group_len + constants.utf8_len_max;

test "fuzz valid against the machine" {
    try testing.fuzz({}, fuzz_valid, .{ .corpus = &.{ "", "a" ** constants.utf8_group_len, "\xe2\x82\xac", "a" ** (constants.utf8_group_len - 2) ++ "\xe2\x82" ++ "b" ** constants.utf8_group_len, "\x00" ** (constants.utf8_group_len - 1) ++ "\x80" } });
}

fn fuzz_valid(_: void, smith: *testing.Smith) anyerror!void {
    var input: [fuzz_input_len_max]u8 = undefined;
    const len = smith.slice(&input);
    try testing.expectEqual(valid_scalar(input[0..len]), valid(input[0..len]));
}

test "cut_character_len takes a cut character's first octets and nothing of a whole one" {
    try testing.expectEqual(0, cut_character_len("abc"));
    try testing.expectEqual(0, cut_character_len("caf\xc3\xa9"));
    try testing.expectEqual(1, cut_character_len("caf\xc3"));
    try testing.expectEqual(2, cut_character_len("a\xe2\x82"));
    try testing.expectEqual(1, cut_character_len("a\xe2"));
    try testing.expectEqual(3, cut_character_len("\xf0\x9f\x98"));
    try testing.expectEqual(0, cut_character_len("\xf0\x9f\x98\x80"));
    try testing.expectEqual(0, cut_character_len("\x80\x80\x80\x80"));
}
