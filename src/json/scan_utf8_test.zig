//! Tests of scan_utf8.zig's `valid`, the check over a whole buffer (decision 38), and of
//! `cut_character_len`, beside the file: scan_utf8.zig holds the check, its tables and their tests,
//! and would pass 500 lines with these.

const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const utf8 = @import("utf8.zig");
const scan_utf8 = @import("scan_utf8.zig");
const wide = @import("wide.zig");
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

/// The longest input the fuzzer gives the check: every boundary the widest copy crosses.
const fuzz_input_len_max = placed_buffer_len(constants.avx512_vector_len);

test "fuzz valid against the machine" {
    try testing.fuzz({}, fuzz_valid, .{ .corpus = &.{ "", "a" ** constants.utf8_group_len, "\xe2\x82\xac", "a" ** (constants.utf8_group_len - 2) ++ "\xe2\x82" ++ "b" ** constants.utf8_group_len, "\x00" ** (constants.utf8_group_len - 1) ++ "\x80" } });
}

fn fuzz_valid(_: void, smith: *testing.Smith) anyerror!void {
    var input: [fuzz_input_len_max]u8 = undefined;
    const octets = input[0..smith.slice(&input)];
    const expected = valid_scalar(octets);
    try testing.expectEqual(expected, valid(octets));
    try testing.expectEqual(expected, scan_utf8.valid_by(constants.avx2_vector_len, .compares, octets));
    try testing.expectEqual(expected, scan_utf8.valid_by(constants.avx512_vector_len, .compares, octets));
    for (levels_run()) |level| try testing.expectEqual(expected, wide.is_utf8(level, octets));
}

// The wider copies (decision 39): a sequence on every lane of a buffer that crosses every boundary a
// width has, by the compares on every target, by the lookup where LLVM builds it for this CPU, and
// through the variant object's copies at every level this CPU runs.

/// Characters and faults a wider check must meet on every lane: whole characters of each length at
/// the edges of their ranges, and each fault RFC 3629 §4 names, cut ones included.
const placed_sequences = [_][]const u8{
    "\xc2\x80",         "\xdf\xbf",         "\xe0\xa0\x80",     "\xed\x9f\xbf",         "\xee\x80\x80",
    "\xef\xbf\xbf",     "\xf0\x90\x80\x80", "\xf4\x8f\xbf\xbf", "\xc3\xa9\xe2\x82\xac", "\x80",
    "\xbf",             "\xc0\xaf",         "\xc1\xbf",         "\xe0\x9f\xbf",         "\xed\xa0\x80",
    "\xf0\x8f\xbf\xbf", "\xf4\x90\x80\x80", "\xf5\x80\x80\x80", "\xff",                 "\xc3",
    "\xe2\x82",         "\xf0\x9f\x98",     "\xc3\xa9\xa9",     "\xe2\x82\xac\x80",     "\xc3\xc3",
};

/// The groups a placed buffer holds at its width.
const placed_groups = 2;

/// Groups at `width`, a block of it, a block of 16 and a character's octets: every boundary the
/// check crosses at that width, from a group to a group, to a block, to 16 lanes and to the machine.
fn placed_buffer_len(comptime width: usize) usize {
    return placed_groups * constants.utf8_group_blocks * width + width + constants.vector_len + constants.utf8_len_max;
}

/// Requires `judge.valid` to judge each of `placed_sequences` at every offset of a buffer of
/// letters as the machine does, the buffer whole and cut after the sequence.
fn expect_placed(comptime width: usize, judge: anytype) !void {
    var buffer: [placed_buffer_len(width)]u8 = undefined;
    for (placed_sequences) |sequence| for (0..buffer.len - sequence.len + 1) |offset| {
        buffer = @splat('a');
        @memcpy(buffer[offset..][0..sequence.len], sequence);
        for ([_]usize{ offset + sequence.len, buffer.len }) |len| try testing.expectEqual(valid_scalar(buffer[0..len]), judge.valid(buffer[0..len]));
    };
}

fn By(comptime width: usize, comptime form: scan_utf8.Form) type {
    return struct {
        fn valid(_: @This(), octets: []const u8) bool {
            return scan_utf8.valid_by(width, form, octets);
        }
    };
}

const AtLevel = struct {
    level: wide.CheckLevel,

    fn valid(self: AtLevel, octets: []const u8) bool {
        return wide.is_utf8(self.level, octets);
    }
};

/// Every level of the check this CPU runs, the widest its features name and those below it.
fn levels_run() []const wide.CheckLevel {
    const levels = comptime std.enums.values(wide.CheckLevel);
    return levels[0 .. @intFromEnum(wide.CheckLevel.of(codec.Features.detect())) + 1];
}

test "valid_by judges a sequence on every lane at 32 and 64 lanes as the machine does, by the compares" {
    try expect_placed(constants.avx2_vector_len, By(constants.avx2_vector_len, .compares){});
    try expect_placed(constants.avx512_vector_len, By(constants.avx512_vector_len, .compares){});
}

test "valid_by's lookup at 32 and 64 lanes judges as the machine does, where LLVM builds it for this CPU" {
    // Zig's own x86-64 backend cannot place the wider lookup's operands (`scan_utf8.Form`).
    if (comptime builtin.cpu.arch == .x86_64 and builtin.zig_backend == .stage2_llvm) {
        const features = builtin.cpu.features;
        if (comptime std.Target.x86.featureSetHas(features, .avx2)) try expect_placed(constants.avx2_vector_len, By(constants.avx2_vector_len, .lookup){});
        if (comptime std.Target.x86.featureSetHas(features, .avx512bw)) try expect_placed(constants.avx512_vector_len, By(constants.avx512_vector_len, .lookup){});
    } else return error.SkipZigTest;
}

/// Requires `judge.valid` to judge each of `placed_sequences` as the machine does in a buffer that
/// starts at every offset from a 64-octet line, the sequence around the first octet a wider copy's
/// aligned loads start on and around the end of the unaligned block before it.
fn expect_placed_at_offsets(comptime width: usize, judge: anytype) !void {
    var storage: [constants.avx512_vector_len + placed_buffer_len(width)]u8 align(constants.avx512_vector_len) = undefined;
    for (0..constants.avx512_vector_len) |line_offset| {
        const buffer = storage[line_offset..][0..placed_buffer_len(width)];
        const head_len = (width - line_offset % width) % width;
        for ([_]usize{ head_len, width }) |edge| try expect_around(judge, buffer, edge);
    }
}

/// Requires `judge.valid` to judge each of `placed_sequences` at every place around `edge` in
/// `buffer`, a buffer of letters, as the machine does.
fn expect_around(judge: anytype, buffer: []u8, edge: usize) !void {
    for (placed_sequences) |sequence| for (0..aligned_edge_before + aligned_edge_after) |step| {
        if (edge + step < aligned_edge_before) continue;
        const offset = edge + step - aligned_edge_before;
        if (offset + sequence.len > buffer.len) continue;
        @memset(buffer, 'a');
        @memcpy(buffer[offset..][0..sequence.len], sequence);
        try testing.expectEqual(valid_scalar(buffer), judge.valid(buffer));
    };
}

/// The places a sequence takes around an edge: from this many octets before it to as many after.
const aligned_edge_before = 5;
const aligned_edge_after = 5;

test "valid_by at 32 and 64 lanes judges as the machine does wherever the buffer starts on a line" {
    try expect_placed_at_offsets(constants.avx2_vector_len, By(constants.avx2_vector_len, .compares){});
    try expect_placed_at_offsets(constants.avx512_vector_len, By(constants.avx512_vector_len, .compares){});
    for (levels_run()) |level| try expect_placed_at_offsets(constants.avx512_vector_len, AtLevel{ .level = level });
}

test "is_utf8 judges a sequence on every lane as the machine does at every level this CPU runs" {
    for (levels_run()) |level| try expect_placed(constants.avx512_vector_len, AtLevel{ .level = level });
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
