//! The decoder over streams Google's brotli command-line tool wrote, committed in fixtures/, and
//! over short streams written by hand for the refusals of RFC 7932 §9.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const decoder_module = @import("decoder.zig");
const claims = @import("../claims.zig");

/// The instance the tests take: a window of 2^18 octets, small enough for two on a test's stack.
const test_window_bits = 18;
const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });

/// The inputs the fixtures encode, rebuilt here.
const Plain = enum { empty, hello, text, random, wave };

const random_len = 4096;
const wave_len = 8192;
/// The wave: octet i is i * 37 / 64 + i % 7, as the script that wrote the fixtures made it.
const wave_slope = 37;
const wave_slope_divisor = 64;
const wave_ripple = 7;
const output_len_max = wave_len;

/// The input a fixture encodes. `random` is SplitMix64's low octets from seed 0, and `wave` octets
/// whose high bits follow a slow ramp, both as the script that wrote the fixtures made them.
fn plain_of(plain: Plain, buffer: *[output_len_max]u8) []const u8 {
    switch (plain) {
        .empty => return "",
        .hello => return "hello",
        .text => return @embedFile("../fixtures/text.txt"),
        .random => {
            var generator = codec.split.Generator.init(0);
            for (buffer[0..random_len]) |*octet| octet.* = @truncate(generator.next());
            return buffer[0..random_len];
        },
        .wave => {
            for (buffer[0..wave_len], 0..) |*octet, index| octet.* = @truncate(index * wave_slope / wave_slope_divisor + index % wave_ripple);
            return buffer[0..wave_len];
        },
    }
}

const Fixture = struct { stream: []const u8, plain: Plain };

/// Every fixture whose window the test instance holds.
const fixtures = [_]Fixture{
    .{ .stream = @embedFile("../fixtures/empty-q11-w16.br"), .plain = .empty },
    .{ .stream = @embedFile("../fixtures/hello-q0-w16.br"), .plain = .hello },
    .{ .stream = @embedFile("../fixtures/hello-q11-w16.br"), .plain = .hello },
    .{ .stream = @embedFile("../fixtures/hello-comment.br"), .plain = .hello },
    .{ .stream = @embedFile("../fixtures/text-q0-w16.br"), .plain = .text },
    .{ .stream = @embedFile("../fixtures/text-q5-w16.br"), .plain = .text },
    .{ .stream = @embedFile("../fixtures/text-q9-w18.br"), .plain = .text },
    .{ .stream = @embedFile("../fixtures/text-q11-w10.br"), .plain = .text },
    .{ .stream = @embedFile("../fixtures/random-q11-w16.br"), .plain = .random },
    .{ .stream = @embedFile("../fixtures/wave-q5-w16.br"), .plain = .wave },
    .{ .stream = @embedFile("../fixtures/wave-q11-w16.br"), .plain = .wave },
};

/// The checked path alone (decision 16).
const CheckedDecoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits, .paths = .{ .fast_paths = false } });

/// The zero octets after a fixture, so that the fast path's input margin holds at its last
/// commands (decision 16).
const padding_len = 16;

/// Decodes `fixture` whole with a `Tested` decoder, in a frame of its own, and requires its input:
/// as it is, and with `padding_len` zero octets after it, which stay in the input.
noinline fn expect_fixture(comptime Tested: type, fixture: Fixture) !void {
    var expected_buffer: [output_len_max]u8 = undefined;
    const expected = plain_of(fixture.plain, &expected_buffer);
    var padded: [output_len_max + padding_len]u8 = undefined;
    @memcpy(padded[0..fixture.stream.len], fixture.stream);
    @memset(padded[fixture.stream.len..][0..padding_len], 0);
    for ([_][]const u8{ fixture.stream, padded[0 .. fixture.stream.len + padding_len] }) |input| {
        var decoder: Tested = undefined;
        decoder.init(.{});
        var output: [output_len_max]u8 = undefined;
        const whole = try decoder.decode_all(input, &output);
        try testing.expectEqual(fixture.stream.len, whole.consumed);
        try testing.expectEqualSlices(u8, expected, output[0..whole.written]);
    }
}

test "every fixture decodes whole to its input, on every path and with each claim off" {
    for (fixtures) |fixture| {
        try expect_fixture(Decoder, fixture);
        try expect_fixture(CheckedDecoder, fixture);
        inline for (claims.each_off) |off| try expect_fixture(ClaimOff(off), fixture);
    }
}

/// The fast path with the claim `off` switches off.
fn ClaimOff(comptime off: claims.Claims) type {
    return decoder_module.Decoder(.{ .window_bits_max = test_window_bits, .paths = .{ .claims = off } });
}

/// The splits each fixture decodes under.
const split_seeds = 8;

/// Decodes `fixture` under every seed's split with a `Tested` decoder, in a frame of its own, the
/// state moved between calls, and requires its input.
noinline fn expect_splits(comptime Tested: type, fixture: Fixture) !void {
    const step = struct {
        fn step(decoder: *Tested, input: []const u8, output: []u8) decoder_module.Error!codec.Progress {
            return decoder.decode(input, output);
        }
    }.step;
    var expected_buffer: [output_len_max]u8 = undefined;
    const expected = plain_of(fixture.plain, &expected_buffer);
    for (0..split_seeds) |seed| {
        var states: [codec.split.state_slots]Tested = undefined;
        states[0].init(.{});
        var output: [output_len_max]u8 = undefined;
        const outcome = try codec.split.drive(Tested, &states, step, fixture.stream, output[0..expected.len], seed);
        try testing.expectEqual(.done, outcome.status);
        try testing.expectEqual(fixture.stream.len, outcome.consumed);
        try testing.expectEqualSlices(u8, expected, output[0..outcome.written]);
    }
}

test "every split of input and output gives the same octets, the state moved between calls" {
    for (fixtures) |fixture| {
        try expect_splits(Decoder, fixture);
        inline for (claims.each_off) |off| try expect_splits(ClaimOff(off), fixture);
    }
}

test "a stream cut short asks for more input, at every length" {
    const fixture = fixtures[5];
    var output: [output_len_max]u8 = undefined;
    for (0..fixture.stream.len) |len| {
        var decoder: Decoder = undefined;
        decoder.init(.{});
        try testing.expectError(error.Truncated, decoder.decode_all(fixture.stream[0..len], &output));
    }
}

test "octets after the stream stay in the input" {
    // A step may take octets past the stream into its bits before it knows it needs them; the call
    // that ends the stream hands them back (decision 11).
    for (fixtures) |fixture| {
        var input: [output_len_max + 3]u8 = undefined;
        @memcpy(input[0..fixture.stream.len], fixture.stream);
        @memcpy(input[fixture.stream.len..][0..3], "xyz");
        var decoder: Decoder = undefined;
        decoder.init(.{});
        var output: [output_len_max]u8 = undefined;
        const progress = try decoder.decode(input[0 .. fixture.stream.len + 3], &output);
        try testing.expectEqual(.done, progress.status);
        try testing.expectEqual(fixture.stream.len, progress.consumed);
    }
}

fn expect_refused(expected: decoder_module.Error, stream: []const u8) !void {
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var output: [output_len_max]u8 = undefined;
    try testing.expectError(expected, decoder.decode_all(stream, &output));
}

test "the refusals of the stream and meta-block headers" {
    // RFC 9841 §6's large-window signature, and a window past the instance's.
    try expect_refused(error.LargeWindow, @embedFile("../fixtures/hello-large-window.br"));
    try expect_refused(error.WindowTooLarge, @embedFile("../fixtures/text-q11-w22.br"));
    try expect_refused(error.WindowTooLarge, @embedFile("../fixtures/text-q11-w24.br"));
    // WBITS 0010001 followed by a 1 bit: invalid, and no large window's signature.
    try expect_refused(error.InvalidWindowBits, &.{0x91});
    // WBITS 16, ISLAST, ISLASTEMPTY, and a padding bit set.
    try expect_refused(error.NonZeroPadding, &.{0x0e});
    // WBITS 16, a metadata meta-block whose reserved bit is set.
    try expect_refused(error.ReservedBitSet, &.{0x1c});
    // MSKIPBYTES 2 whose last octet is zero.
    try expect_refused(error.NonMinimalLength, &.{ 0xcc, 0x02, 0x00 });
    // MNIBBLES 5 whose last nibble is zero.
    try expect_refused(error.NonMinimalLength, &.{ 0x14, 0x00, 0x00 });
    // An uncompressed meta-block of one octet whose ignored bits are not zero.
    try expect_refused(error.NonZeroPadding, &.{ 0x00, 0x00, 0x30, 'x' });
    // Metadata of MSKIPLEN 1 whose fill bit is set.
    try expect_refused(error.NonZeroPadding, &.{ 0x2c, 0x80, 'm', 0x03 });
}

test "metadata decodes to nothing" {
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var output: [4]u8 = undefined;
    const whole = try decoder.decode_all(&.{ 0x2c, 0x00, 'm', 0x03 }, &output);
    try testing.expectEqual(4, whole.consumed);
    try testing.expectEqual(0, whole.written);
}

test "an uncompressed meta-block of one octet, and the smallest stream" {
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var output: [4]u8 = undefined;
    const whole = try decoder.decode_all(&.{ 0x00, 0x00, 0x10, 'x', 0x03 }, &output);
    try testing.expectEqualStrings("x", output[0..whole.written]);
    decoder.init(.{});
    try testing.expectEqual(0, (try decoder.decode_all(&.{0x06}, &output)).written);
}

test "the two classes of refusal" {
    try testing.expectEqual(.unsupported, decoder_module.refusal(error.LargeWindow));
    try testing.expectEqual(.unsupported, decoder_module.refusal(error.WindowTooLarge));
    try testing.expectEqual(.corrupt, decoder_module.refusal(error.InvalidDistance));
    try testing.expectEqual(.corrupt, decoder_module.refusal(error.NonZeroPadding));
}
