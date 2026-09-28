//! Tests for scan.zig: each vector path returns what its scalar path returns, on every input the
//! tests draw and the fuzzer finds, at the codecs' `vector_len` of 16 octets a block, and at 32 and
//! 64, AVX2's and AVX-512's (decision 21). So does each of wide.zig's scans at every level of claim
//! J7 this CPU runs, which on x86-64 calls the kernels of the variant objects (decision 29). The
//! scalar paths are the reference (decision 16), and `utf8.zig`'s tests hold the UTF-8 they use to
//! RFC 3629 §4.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const scan = @import("scan.zig");
const wide = @import("wide.zig");

/// The widths every vector path runs at: the codecs' `vector_len`, SSE2's and NEON's, then AVX2's
/// and AVX-512's.
const width_128_bits = 16;
const width_256_bits = 32;
const width_512_bits = 64;
const widths = [_]usize{ constants.vector_len, width_256_bits, width_512_bits };

/// The longest input a case draws: several blocks at the widest width.
const input_len_max = 300;

/// The seeded cases the tests draw.
const seeded_cases = 3000;

/// Requires every vector path to return what its scalar path returns for `input`, at every width,
/// and the hexadecimal paths at every room from none to two digits per octet.
fn expect_same(input: []const u8) !void {
    inline for (widths) |width| {
        try testing.expectEqual(scan.plain_len_scalar(input), scan.plain_len_vector(width, input));
        try testing.expectEqual(scan.content_len_scalar(input), scan.content_len_vector(width, input));
    }
    for (levels_run()) |level| {
        try testing.expectEqual(scan.plain_len_scalar(input), wide.plain_len(level, input));
        try testing.expectEqual(scan.content_len_scalar(input), wide.content_len(level, input));
    }
    try expect_same_hex(input);
}

/// The levels of claim J7 this CPU runs: the target's, and each wider one its features allow.
fn levels_run() []const wide.Level {
    const levels = comptime std.enums.values(wide.Level);
    return levels[0 .. @intFromEnum(wide.Level.of(codec.Features.detect())) + 1];
}

fn expect_same_hex(input: []const u8) !void {
    var scalar_output: [constants.hex_digits_per_octet * input_len_max]u8 = undefined;
    var vector_output: [constants.hex_digits_per_octet * input_len_max]u8 = undefined;
    const rooms = [_]usize{ 0, 1, input.len, constants.hex_digits_per_octet * input.len - @min(input.len, 1), constants.hex_digits_per_octet * input.len };
    inline for (widths) |width| {
        for (rooms) |room| {
            const scalar_len = scan.hex_len_scalar(input, scalar_output[0..room]);
            const vector_len = scan.hex_len_vector(width, input, vector_output[0..room]);
            try testing.expectEqual(scalar_len, vector_len);
            const digits_len = constants.hex_digits_per_octet * scalar_len;
            try testing.expectEqualSlices(u8, scalar_output[0..digits_len], vector_output[0..digits_len]);
        }
    }
    for (levels_run()) |level| {
        for (rooms) |room| {
            const scalar_len = scan.hex_len_scalar(input, scalar_output[0..room]);
            try testing.expectEqual(scalar_len, wide.hex_len(level, input, vector_output[0..room]));
            const digits_len = constants.hex_digits_per_octet * scalar_len;
            try testing.expectEqualSlices(u8, scalar_output[0..digits_len], vector_output[0..digits_len]);
        }
    }
}

/// Draws inputs of mostly UTF-8 text, with octets a string must escape and octets drawn at random
/// among it: each character's kind by the weights below.
const Draw = struct {
    const Kind = enum { letter, whitespace, escaped, character, any_octet };
    const letter_weight = 8;
    const whitespace_weight = 2;
    const escaped_weight = 1;
    const character_weight = 7;
    const any_octet_weight = 2;
    const weights = [_]u64{ letter_weight, whitespace_weight, escaped_weight, character_weight, any_octet_weight };
    const whitespace = " \t\n\r";

    fn input(generator: *codec.split.Generator, buffer: []u8) usize {
        var len: usize = 0;
        for (0..buffer.len) |_| {
            var octets: [constants.utf8_len_max]u8 = undefined;
            const drawn = character(generator, kind(generator), &octets);
            if (len + drawn.len > buffer.len) break;
            @memcpy(buffer[len..][0..drawn.len], drawn);
            len += drawn.len;
        }
        return len;
    }

    fn kind(generator: *codec.split.Generator) Kind {
        var total: u64 = 0;
        for (weights) |weight| total += weight;
        var draw = generator.below(total);
        for (weights, 0..) |weight, index| {
            if (draw < weight) return @enumFromInt(index);
            draw -= weight;
        }
        unreachable;
    }

    fn character(generator: *codec.split.Generator, drawn: Kind, octets: *[constants.utf8_len_max]u8) []const u8 {
        octets[0] = switch (drawn) {
            .letter => @intCast(generator.between(constants.unescaped_min, constants.non_ascii_min - 1)),
            .whitespace => whitespace[generator.below(whitespace.len)],
            .escaped => @intCast(generator.below(constants.unescaped_min)),
            .any_octet => @intCast(generator.below(std.math.maxInt(u8) + 1)),
            .character => {
                var code_point: u21 = @intCast(generator.between(constants.non_ascii_min, constants.code_point_max));
                if (code_point >= constants.high_surrogate_min and code_point <= constants.surrogate_max) code_point = constants.three_octets_max;
                return octets[0 .. std.unicode.utf8Encode(code_point, octets) catch unreachable];
            },
        };
        return octets[0..1];
    }
};

test "the vector paths return what the scalar paths return on drawn inputs, whole and cut" {
    var buffer: [input_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        const len = Draw.input(&generator, &buffer);
        try expect_same(buffer[0..len]);
        try expect_same(buffer[0..generator.below(len + 1)]);
        try expect_same(buffer[generator.below(len + 1)..len]);
    }
}

test "every sequence of four octets at UTF-8's edges, across a block's end, scans alike" {
    const edges = [_]u8{ 0x00, 0x1f, 0x20, 0x22, 0x5c, 0x7f, 0x80, 0x8f, 0x90, 0x9f, 0xa0, 0xbf, 0xc0, 0xc1, 0xc2, 0xdf, 0xe0, 0xe1, 0xed, 0xef, 0xf0, 0xf3, 0xf4, 0xf5 };
    var buffer: [2 * width_128_bits]u8 = @splat('a');
    for ([_]usize{ 13, 14, 15, 16 }) |offset| {
        for (edges) |a| for (edges) |b| for (edges) |c| for (edges) |d| {
            buffer[offset..][0..4].* = .{ a, b, c, d };
            try testing.expectEqual(scan.content_len_scalar(&buffer), scan.content_len_vector(width_128_bits, &buffer));
            try testing.expectEqual(scan.plain_len_scalar(&buffer), scan.plain_len_vector(width_128_bits, &buffer));
        };
        buffer[offset..][0..4].* = "aaaa".*;
    }
}

test "the scans stop where RFC 8259 §7 and RFC 3629 §4 stop a string's run" {
    try testing.expectEqual(5, scan.plain_len_scalar("plain\"rest"));
    try testing.expectEqual(3, scan.plain_len_scalar("abc\\n"));
    try testing.expectEqual(2, scan.plain_len_scalar("ab\x1f"));
    try testing.expectEqual(3, scan.plain_len_scalar("ab\x7f\xc3\xa9"));
    try testing.expectEqual(5, scan.content_len_scalar("ab\x7f\xc3\xa9\""));
    try testing.expectEqual(2, scan.content_len_scalar("ab\xc3"));
    try testing.expectEqual(2, scan.content_len_scalar("ab\xed\xa0\x80"));
    try testing.expectEqual(4, scan.whitespace_len_scalar(" \t\r\n{"));
    var digits: [7]u8 = undefined;
    try testing.expectEqual(3, scan.hex_len_scalar("\x00\xab\xff\x10", &digits));
    try testing.expectEqualStrings("00abff", digits[0..6]);
}

test "a run of every length up to four blocks scans alike, ending on each kind of octet" {
    var buffer: [4 * width_512_bits + constants.utf8_len_max]u8 = undefined;
    const endings = [_][]const u8{ "\"", "\\", "\x00", "\xc3\xa9", "\xe2\x82", "\xff", " ", "{" };
    for (0..4 * width_512_bits) |len| {
        for (endings) |ending| {
            @memset(buffer[0..len], 'a');
            @memcpy(buffer[len..][0..ending.len], ending);
            try expect_same(buffer[0..@min(len + ending.len, input_len_max)]);
            @memset(buffer[0..len], ' ');
            try expect_same(buffer[0..@min(len + ending.len, input_len_max)]);
            for (0..len / 3) |index| buffer[3 * index ..][0..3].* = "\xe2\x82\xac".*;
            try expect_same(buffer[0..@min(len + ending.len, input_len_max)]);
        }
    }
}

test "fuzz the vector paths against the scalar paths" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "", "\"", "\xe2\x82\xac\"", "  \n\t{" } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const len = smith.slice(&input);
    try expect_same(input[0..len]);
}
