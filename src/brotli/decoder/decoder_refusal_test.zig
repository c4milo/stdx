//! Compressed meta-blocks written by hand, each for one refusal of RFC 7932 or for the decoding it
//! guards. Most codes have one symbol, so a command's symbols take no bits and the stream holds only
//! the fields under test.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const decoder_module = @import("decoder.zig");
const constants = @import("../constants.zig");
const test_stream = @import("test_stream.zig");
const Stream = test_stream.Stream;

const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });
const CheckedDecoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits, .paths = .{ .fast_paths = false } });
const test_window_bits = 16;
const output_len_max = 64;

/// The zero octets after each stream, so that the fast path's input margin holds at its last
/// commands, and the fast path meets the refusals there (decision 16).
const padding_len = 16;

/// Decodes `input` whole with a `Tested` decoder, in a frame of its own.
noinline fn decode_with(comptime Tested: type, input: []const u8, output: *[output_len_max]u8) (decoder_module.Error || codec.Incomplete)!codec.Whole {
    var decoder: Tested = undefined;
    decoder.init(.{});
    return decoder.decode_all(input, output);
}

/// Decodes `stream`, padded, with the fast path and with the checked path alone, and requires the
/// same verdict and octets of both. Returns the octets.
fn decode(stream: []const u8, output: *[output_len_max]u8) ![]const u8 {
    var padded: [test_stream.capacity + padding_len]u8 = undefined;
    @memcpy(padded[0..stream.len], stream);
    @memset(padded[stream.len..][0..padding_len], 0);
    const input = padded[0 .. stream.len + padding_len];
    var checked_output: [output_len_max]u8 = undefined;
    const checked = decode_with(CheckedDecoder, input, &checked_output);
    const fast = decode_with(Decoder, input, output);
    const whole = checked catch |err| {
        try testing.expectError(err, fast);
        return err;
    };
    try testing.expectEqual(whole, try fast);
    try testing.expectEqual(stream.len, whole.consumed);
    try testing.expectEqualSlices(u8, checked_output[0..whole.written], output[0..whole.written]);
    return output[0..whole.written];
}

fn expect_refused(expected: decoder_module.Error, stream: []const u8) !void {
    var output: [output_len_max]u8 = undefined;
    try testing.expectError(expected, decode(stream, &output));
}

/// A last meta-block of MLEN `len`: WBITS 16, one block type and one tree of each kind, NPOSTFIX 0
/// and NDIRECT `direct_high`, the literal code of one symbol 'a', and the insert-and-copy code of
/// the one symbol `command`.
fn start(stream: *Stream, len: u32, direct_high: u4, command: u16) void {
    stream.window_bits_16();
    stream.meta_block(true, len);
    stream.simple_header(0, direct_high, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{'a'}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{command}, false);
}

// Insert-and-copy symbols from 128, which take an explicit distance: 128, the insert length code
// shifted to bits 3 to 5, and the copy length code in bits 0 to 2 (RFC 7932 §5).
/// 128 + (1 << 3) + 0: insert 1, copy 2.
const insert_1_copy_2 = 136;
/// 128 + (1 << 3) + 1: insert 1, copy 3.
const insert_1_copy_3 = 137;
/// 128 + (1 << 3) + 2: insert 1, copy 4.
const insert_1_copy_4 = 138;
/// 128 + (2 << 3) + 0: insert 2, copy 2.
const insert_2_copy_2 = 144;

test "the insert-and-copy symbols the tests take" {
    try testing.expectEqual(128 + (1 << 3) + 0, insert_1_copy_2);
    try testing.expectEqual(128 + (1 << 3) + 1, insert_1_copy_3);
    try testing.expectEqual(128 + (1 << 3) + 2, insert_1_copy_4);
    try testing.expectEqual(128 + (2 << 3) + 0, insert_2_copy_2);
}

test "literals and a copy of the distance a coded distance gives" {
    var stream: Stream = .{};
    start(&stream, 3, 0, insert_1_copy_2);
    // Distance code 16 with NDIRECT 0: 1 extra bit, and distance 1 + that bit (RFC 7932 §4).
    stream.simple_code(64, &.{16}, false);
    stream.put(0, 1);
    var output: [output_len_max]u8 = undefined;
    try testing.expectEqualStrings("aaa", try decode(stream.written(), &output));
}

test "a distance past the octets produced names a dictionary word" {
    var stream: Stream = .{};
    start(&stream, 5, 2, insert_1_copy_4);
    // Direct code 17 with NDIRECT 2 is distance 2: past the one octet produced, so word 0 of length
    // 4, "time", with transform 0 (RFC 7932 §8).
    stream.simple_code(66, &.{17}, false);
    var output: [output_len_max]u8 = undefined;
    try testing.expectEqualStrings("atime", try decode(stream.written(), &output));
}

test "a distance one past the window names a dictionary word, whatever the octets produced" {
    var stream: Stream = .{};
    stream.window_bits_10();
    const produced = [_]u8{'a'} ** 1010;
    stream.uncompressed(&produced);
    stream.meta_block(true, 4);
    stream.simple_header(0, 0, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{'a'}, false);
    // 128 + (0 << 3) + 2: insert 0, copy 4.
    stream.simple_code(constants.insert_copy_alphabet_len, &.{130}, false);
    // Code 31 takes 8 extra bits and gives 765 and up: 244 gives 1009, one past the window of
    // (1 << 10) - 16 = 1008, so word 0 of length 4.
    stream.simple_code(64, &.{31}, false);
    stream.put(244, 8);
    var output: [1024 + 16]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(.{});
    const whole = try decoder.decode_all(stream.written(), &output);
    try testing.expectEqualSlices(u8, &produced, output[0..produced.len]);
    try testing.expectEqualStrings("time", output[produced.len..whole.written]);
}

test "a short distance code that resolves to zero or less is refused" {
    var stream: Stream = .{};
    start(&stream, 10, 1, insert_1_copy_2);
    // Codes 6 (the last distance - 2) and 16 (distance 1, with NDIRECT 1) take a bit each.
    stream.simple_code(65, &.{ 6, 16 }, false);
    stream.put_code(1, 1);
    stream.put_code(0, 1);
    try expect_refused(error.InvalidDistance, stream.written());
}

test "literals, a copy or a dictionary word past MLEN are refused" {
    var insert: Stream = .{};
    start(&insert, 1, 0, insert_2_copy_2);
    insert.simple_code(64, &.{16}, false);
    try expect_refused(error.LengthPastMetaBlock, insert.written());
    var copy: Stream = .{};
    start(&copy, 3, 0, insert_1_copy_3);
    copy.simple_code(64, &.{16}, false);
    copy.put(0, 1);
    try expect_refused(error.LengthPastMetaBlock, copy.written());
    var word: Stream = .{};
    start(&word, 4, 2, insert_1_copy_4);
    word.simple_code(66, &.{17}, false);
    try expect_refused(error.LengthPastMetaBlock, word.written());
}

test "a dictionary reference of a short length or a transform past 120 is refused" {
    var short: Stream = .{};
    start(&short, 10, 2, insert_1_copy_2);
    short.simple_code(66, &.{17}, false);
    try expect_refused(error.InvalidDictionaryReference, short.written());
    // Code 46 with NPOSTFIX and NDIRECT 0 takes 16 extra bits and gives 131069 and up: word 131067
    // of length 4 is transform 127.
    var transformed: Stream = .{};
    start(&transformed, 10, 0, insert_1_copy_4);
    transformed.simple_code(64, &.{46}, false);
    transformed.put(0, 16);
    try expect_refused(error.InvalidDictionaryReference, transformed.written());
}

test "a simple code's symbol past its alphabet, or given twice, is refused" {
    var past: Stream = .{};
    past.window_bits_16();
    past.meta_block(true, 1);
    past.simple_header(0, 0, 0);
    past.simple_code(256, &.{'a'}, false);
    past.simple_code(704, &.{1000}, false);
    try expect_refused(error.InvalidSymbol, past.written());
    var twice: Stream = .{};
    twice.window_bits_16();
    twice.meta_block(true, 1);
    twice.simple_header(0, 0, 0);
    twice.simple_code(256, &.{ 'a', 'a' }, false);
    try expect_refused(error.DuplicateSymbol, twice.written());
}

fn literal_code_start(stream: *Stream) void {
    stream.window_bits_16();
    stream.meta_block(true, 1);
    stream.simple_header(0, 0, 0);
}

test "a code length code that over-subscribes or has no length is refused" {
    var over: Stream = .{};
    literal_code_start(&over);
    // Lengths 2, 1 and 1 for code length symbols 1, 2 and 3: 8 + 16 + 16 is past 32.
    over.complex_code(0, &.{ 2, 1, 1 }, &.{});
    try expect_refused(error.OverSubscribedCodeLengthCode, over.written());
    var none: Stream = .{};
    literal_code_start(&none);
    none.complex_code(0, &(.{0} ** 18), &.{});
    try expect_refused(error.IncompleteCodeLengthCode, none.written());
}

test "code lengths that over-subscribe, fall short, or repeat past the alphabet are refused" {
    // Code length symbols 1 and 2, one bit each.
    var over: Stream = .{};
    literal_code_start(&over);
    over.complex_code(0, &.{ 1, 1 }, &.{ .{ .symbol = 2 }, .{ .symbol = 1 }, .{ .symbol = 1 } });
    try expect_refused(error.OverSubscribedCode, over.written());
    // Code length symbols 1 and 17, one bit each: one length of 1, then 255 zeros in three 17s.
    const one_and_zeros = [_]u8{ 1, 0, 0, 0, 0, 0, 1 };
    var short: Stream = .{};
    literal_code_start(&short);
    short.complex_code(0, &one_and_zeros, &.{ .{ .symbol = 1 }, .{ .symbol = 17, .extra = 2 }, .{ .symbol = 17, .extra = 6 }, .{ .symbol = 17, .extra = 4 } });
    try expect_refused(error.IncompleteCode, short.written());
    var past: Stream = .{};
    literal_code_start(&past);
    past.complex_code(0, &one_and_zeros, &.{ .{ .symbol = 1 }, .{ .symbol = 17, .extra = 7 }, .{ .symbol = 17, .extra = 7 }, .{ .symbol = 17, .extra = 7 } });
    try expect_refused(error.RepeatPastEnd, past.written());
}

test "a run past the context map, or a map that misses a tree, is refused" {
    const Map = struct {
        /// A meta-block whose literal context map has two trees, RLEMAX 6 and a code of the one
        /// symbol 6: a run of 64 zeros and `extra`.
        fn of_one_run(stream: *Stream, extra: u6) void {
            stream.window_bits_16();
            stream.meta_block(true, 1);
            for (0..3) |_| stream.count(1);
            stream.put(0, 2 + 4);
            stream.put(0, 2);
            stream.count(2);
            stream.put(1, 1);
            stream.put(6 - 1, 4);
            stream.simple_code(2 + 6, &.{6}, false);
            stream.put(extra, 6);
        }
    };
    const map_of_one_run = Map.of_one_run;
    var past: Stream = .{};
    map_of_one_run(&past, 1);
    try expect_refused(error.RepeatPastEnd, past.written());
    var missing: Stream = .{};
    map_of_one_run(&missing, 0);
    missing.put(0, 1);
    try expect_refused(error.InvalidContextMap, missing.written());
}
