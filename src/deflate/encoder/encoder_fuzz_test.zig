//! The encoder's round trip, over inputs the fuzzer or a seed draws: at every level, any input,
//! with the flush points the draw gives, encoded under a seeded split decodes through stdx's
//! decoder to the input, and a second split gives the same octets (decision 15; invariant 5).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const decoder = @import("../decoder/decoder.zig");
const encoder_module = @import("encoder.zig");

/// The largest input one case takes, and the most flush points it draws.
const input_len_max = 4096;
const flush_points_max = 4;

/// The octets each flush may add: an empty stored block and the header of the block it cut short.
const flush_overhead_len_max = 16;

/// The seeded cases each normal test run takes.
const seeded_cases = 200;

fn check_level(comptime level: u4, input: []const u8, points: []const usize, seed: u64) !void {
    const Encoder = encoder_module.Encoder(.{ .level = level });
    const step = struct {
        fn call(state: *Encoder, piece: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
            return state.encode(piece, output, flush);
        }
    }.call;
    var states: [codec.split.state_slots]Encoder = undefined;
    var first: [Encoder.encoded_len_max(input_len_max) + flush_points_max * flush_overhead_len_max]u8 = undefined;
    states[0].init(.{});
    const outcome = try codec.split.drive_encoder(Encoder, &states, step, input, &first, points, seed);
    try testing.expectEqual(.done, outcome.status);
    try testing.expectEqual(input.len, outcome.consumed);
    var second: [first.len]u8 = undefined;
    states[0].init(.{});
    const again = try codec.split.drive_encoder(Encoder, &states, step, input, &second, points, seed +% 1);
    try testing.expectEqualSlices(u8, first[0..outcome.written], second[0..again.written]);
    var decoded: [input_len_max]u8 = undefined;
    var state: decoder.Decoder = undefined;
    decoder.init(&state, codec.Features.detect());
    const whole = try decoder.decode_all(&state, first[0..outcome.written], &decoded);
    try testing.expectEqual(outcome.written, whole.consumed);
    try testing.expectEqualSlices(u8, input, decoded[0..whole.written]);
}

fn check_round_trip(input: []const u8, points: []const usize, seed: u64) !void {
    inline for (constants.encoder_levels) |level| try check_level(level, input, points, seed);
}

/// Seeded flush points before the input's end, ascending.
fn draw_points(generator: *codec.split.Generator, input_len: usize, points: *[flush_points_max]usize) []const usize {
    if (input_len == 0) return points[0..0];
    const count = generator.below(flush_points_max + 1);
    for (points[0..count]) |*point| point.* = generator.below(input_len);
    std.mem.sort(usize, points[0..count], {}, std.sort.asc(usize));
    return points[0..count];
}

test "every seeded input round-trips at every level, and splits agree" {
    var input: [input_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        const len = generator.below(input_len_max + 1);
        // A small alphabet makes matches; a wide one makes literals.
        const alphabet = 1 + generator.below(256);
        for (input[0..len]) |*octet| octet.* = @intCast(generator.below(alphabet));
        var points: [flush_points_max]usize = undefined;
        try check_round_trip(input[0..len], draw_points(&generator, len, &points), generator.next());
    }
}

test "fuzz the encoder's round trip" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "", "a", "abcabcabcabcabcabcabc", "\x00" ** 300 } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    var generator = codec.split.Generator.init(smith.value(u64));
    var points: [flush_points_max]usize = undefined;
    try check_round_trip(input[0..input_len], draw_points(&generator, input_len, &points), generator.next());
}
