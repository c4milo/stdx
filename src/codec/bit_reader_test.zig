//! Tests for the bit reader. The property: reading a sequence of bit widths through `BitReader`,
//! over input split across calls as a seed or the fuzzer draws, with the state's `Bits` carried
//! between calls and whole unused octets handed back at the end of some calls, gives the values a
//! reference reads bit by bit from the whole input (RFC 1951 §3.1.1). The fuzz test checks the same
//! property over inputs Zig's fuzzer draws.

const std = @import("std");
const testing = std.testing;
const constants = @import("constants.zig");
const split = @import("split.zig");
const BitReader = @import("bit_reader.zig").BitReader;
const Bits = @import("bit_reader.zig").Bits;

/// The largest input and the most widths one case draws.
const input_len_max = 64;
const widths_max = 32;

/// Calls one case may make: generous for any schedule, and small enough to stop a reader that
/// never finishes.
const calls_max = constants.driver_calls_floor + constants.driver_calls_per_octet_max * input_len_max;

/// The value of `count` bits starting at bit `offset` of `input`, read one bit at a time: bit `i`
/// is bit `i % 8` of octet `i / 8`, least significant first (RFC 1951 §3.1.1).
fn reference(input: []const u8, offset: usize, count: u7) u64 {
    var value: u64 = 0;
    for (0..count) |index| {
        const bit_index = offset + index;
        const bit = (input[bit_index / @bitSizeOf(u8)] >> @intCast(bit_index % @bitSizeOf(u8))) & 1;
        value |= @as(u64, bit) << @intCast(index);
    }
    return value;
}

/// One case: an input, the widths to read, and the seed of the split.
const Case = struct {
    input: []const u8,
    widths: []const u7,
    seed: u64,
};

/// Reads `case.widths` through `BitReader` under the case's split, and checks every value against
/// the reference. Returns the number of widths read, which is every width the input holds.
fn check_case(case: Case) !usize {
    var schedule = split.Schedule.init(case.seed);
    var bits: Bits = .{};
    var position: usize = 0;
    var index: usize = 0;
    var offset: usize = 0;
    for (0..calls_max) |_| {
        const start = position;
        const piece = case.input[start..][0..schedule.piece_len(case.input.len - start)];
        var reader = BitReader.init(piece, bits);
        while (index < case.widths.len) : (index += 1) {
            const value = reader.read(case.widths[index]) orelse break;
            try testing.expectEqual(reference(case.input, offset, case.widths[index]), value);
            offset += case.widths[index];
        }
        const stopped_for_input = index < case.widths.len;
        // Decision 11: a call that does not end for want of input hands back its unused octets.
        // A call that does may, and the schedule decides, so both paths are read.
        if (!stopped_for_input or schedule.move_state()) reader.unread_whole_octets();
        position += reader.consumed();
        bits = reader.finish();
        try testing.expect(position <= case.input.len);
        if (!stopped_for_input) return index;
        // Short of bits with the whole rest of the input given: the input holds no more widths.
        if (piece.len == case.input.len - start) return index;
    }
    return error.TestNoProgress;
}

/// The number of widths the whole input holds, from the first.
fn widths_held(input: []const u8, widths: []const u7) usize {
    var total: usize = 0;
    for (widths, 0..) |width, index| {
        total += width;
        if (total > input.len * @bitSizeOf(u8)) return index;
    }
    return widths.len;
}

/// A case drawn from a seed.
fn seeded_case(seed: u64, input: *[input_len_max]u8, widths: *[widths_max]u7) Case {
    var generator = split.Generator.init(seed);
    const input_len = generator.below(input_len_max + 1);
    for (input[0..input_len]) |*octet| octet.* = @truncate(generator.next());
    const widths_len = generator.below(widths_max + 1);
    for (widths[0..widths_len]) |*width| width.* = @intCast(generator.between(1, constants.ensure_bits_max));
    return .{ .input = input[0..input_len], .widths = widths[0..widths_len], .seed = generator.next() };
}

test "every seeded case reads the reference's values, as many as the input holds" {
    var input: [input_len_max]u8 = undefined;
    var widths: [widths_max]u7 = undefined;
    for (0..2000) |seed| {
        const case = seeded_case(seed, &input, &widths);
        try testing.expectEqual(widths_held(case.input, case.widths), try check_case(case));
    }
}

test "fuzz the bit reader against the reference" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "", "\x00", "\xff\x01\x80\x7f" } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    var widths: [widths_max]u7 = undefined;
    var widths_len: usize = 0;
    while (widths_len < widths_max and !smith.eos()) : (widths_len += 1) {
        widths[widths_len] = smith.valueRangeAtMost(u7, 1, constants.ensure_bits_max);
    }
    const case: Case = .{ .input = input[0..input_len], .widths = widths[0..widths_len], .seed = smith.value(u64) };
    try testing.expectEqual(widths_held(case.input, case.widths), try check_case(case));
}

test "ensure keeps the octets it took when the input runs out" {
    var reader = BitReader.init(&.{0xab}, .{});
    try testing.expect(!reader.ensure(9));
    try testing.expectEqual(1, reader.consumed());
    const kept = reader.finish();
    try testing.expectEqual(8, kept.count);
    var next = BitReader.init(&.{0x01}, kept);
    try testing.expectEqual(0x1ab, next.read(9).?);
}

test "align_to_octet drops the rest of the octet being read" {
    var reader = BitReader.init(&.{ 0xff, 0x5a }, .{});
    try testing.expectEqual(0x7, reader.read(3).?);
    reader.align_to_octet();
    try testing.expectEqual(0x5a, reader.read(8).?);
}

test "unread_whole_octets hands back this call's unused octets, and keeps an earlier call's" {
    var first = BitReader.init(&.{0x0f}, .{});
    try testing.expect(first.ensure(8));
    const carried = first.finish();
    var reader = BitReader.init(&.{ 0x11, 0x22, 0x33 }, carried);
    try testing.expectEqual(0xf, reader.read(4).?);
    try testing.expect(reader.ensure(28));
    try testing.expectEqual(3, reader.consumed());
    reader.unread_whole_octets();
    // 4 bits of the carried octet are left; the three octets of this call were not used, so all
    // three go back, and the 4 bits stay.
    try testing.expectEqual(0, reader.consumed());
    try testing.expectEqual(4, reader.finish().count);
}
