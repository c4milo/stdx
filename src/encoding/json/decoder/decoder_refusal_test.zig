//! Tests for every refusal of the decoder: each error value, from texts that break the rule it
//! cites, with the same verdict one token a call, under every seed's split, and with every claim off
//! (decision 21), and the class `refusal` gives it (decision 11).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const decoder_file = @import("decoder.zig");
const Framing = @import("../framing.zig").Framing;
const decoder_test = @import("decoder_test.zig");

fn expect_refused(framing: Framing, inputs: []const []const u8, expected: decoder_file.Error, class: codec.Refusal) !void {
    for (inputs) |input| {
        const verdict = try decoder_test.expect_consistent(framing, input, decoder_test.split_seeds);
        try testing.expectEqual(decoder_test.Verdict{ .refused = expected }, verdict);
    }
    try testing.expectEqual(class, decoder_file.refusal(expected));
}

test "a byte order mark is refused (RFC 8259 §8.1), and what only starts like one is no value" {
    try expect_refused(.text, &.{ "\xef\xbb\xbf{}", "\xef\xbb\xbf" }, error.ByteOrderMark, .corrupt);
    try expect_refused(.sequence, &.{"\x1e\xef\xbb\xbf1\n"}, error.ByteOrderMark, .corrupt);
    try expect_refused(.text, &.{ "\xef", "\xef\xbb", "\xef\xbbx", "\xefx" }, error.ExpectedValue, .corrupt);
}

test "an octet that starts no value is refused where a value must be (RFC 8259 §3)" {
    try expect_refused(.text, &.{ "x", "+1", ".5", "True", "NULL", "'a'", "[,]", "[1,]", "{\"a\":}", "{\"a\":,}", "\xc3\xa9", "\x00", "]", "}", "," }, error.ExpectedValue, .corrupt);
}

test "a literal name with a letter that is not its own is refused (RFC 8259 §3)" {
    try expect_refused(.text, &.{ "tru ", "trUe", "falsE", "nul1", "nil", "[tru]" }, error.InvalidLiteral, .corrupt);
}

test "a number RFC 8259 §6's grammar does not hold is refused" {
    try expect_refused(.text, &.{ "01", "-01", "00", "- 1", "-a", "1.e5", "[1.]", "[-]", "1.5e+e", "0.x", "[1e]", "[1e+]" }, error.InvalidNumber, .corrupt);
}

test "a control character in a string is refused (RFC 8259 §7)" {
    try expect_refused(.text, &.{ "\"a\x01\"", "\"\n\"", "\"\x00\"", "\"\x1f\"", "[\"\t\"]", "\"\x1e\"" }, error.ControlCharacterInString, .corrupt);
}

test "an escape RFC 8259 §7 does not list is refused" {
    try expect_refused(.text, &.{ "\"\\x\"", "\"\\U0041\"", "\"\\u12G4\"", "\"\\u004\"", "\"\\'\"", "\"\\ \"", "\"\\u\"" }, error.InvalidEscape, .corrupt);
}

test "octets that are not UTF-8 are refused in a string (RFC 8259 §8.1, RFC 3629 §4)" {
    try expect_refused(.text, &.{
        "\"\xc3\x28\"",    "\"\xc3\"",           "\"\xed\xa0\x80\"", "\"\xff\"",
        "\"\xc0\x80\"",    "\"\xe0\x9f\xbf\"",   "\"\x80\"",         "\"\xf4\x90\x80\x80\"",
        "\"\xe2\x82\\n\"", "\"\xf0\x9d\x84\x22", "{\"\xfe\":1}",     "\"\xc3\xc3\xa9\xa9\"",
    }, error.InvalidUtf8, .corrupt);
}

test "a member that does not start with a name is refused (RFC 8259 §4)" {
    try expect_refused(.text, &.{ "{1:2}", "{\"a\":1,}", "{,}", "{\"a\":1,2}", "{null:1}", "{'a':1}" }, error.ExpectedName, .corrupt);
}

test "a name without its colon is refused (RFC 8259 §4)" {
    try expect_refused(.text, &.{ "{\"a\" 1}", "{\"a\",1}", "{\"a\"}", "{\"a\"=1}" }, error.ExpectedNameSeparator, .corrupt);
}

test "a value not followed by a comma or its container's end is refused (RFC 8259 §4, §5)" {
    try expect_refused(.text, &.{ "[1 2]", "[1}", "{\"a\":1]", "[\"a\" \"b\"]", "{\"a\":1 \"b\":2}", "[[]}", "[true false]", "[1:2]" }, error.ExpectedValueSeparator, .corrupt);
}

test "octets after the text's value are refused (RFC 8259 §2)" {
    try expect_refused(.text, &.{ "{} x", "1 2", "\"a\"\"b\"", "[]]", "{}}", "null,", "truex", "0 0", "1x", "[] \x1e" }, error.TrailingOctets, .corrupt);
}

test "a text past depth_max is refused (RFC 8259 §9), and one at it decodes" {
    var input: [2 * constants.depth_max + 2]u8 = undefined;
    @memset(input[0..constants.depth_max], '[');
    @memset(input[constants.depth_max..][0..constants.depth_max], ']');
    try testing.expectEqual(decoder_test.Verdict.done, try decoder_test.expect_consistent(.text, input[0 .. 2 * constants.depth_max], 4));
    @memset(input[0 .. constants.depth_max + 1], '[');
    try expect_refused(.text, &.{input[0 .. constants.depth_max + 1]}, error.DepthTooLarge, .unsupported);
    @memset(input[constants.depth_max - 1 ..][0..1], '{');
    @memcpy(input[constants.depth_max..][0..5], "\"a\":{");
    try expect_refused(.text, &.{input[0 .. constants.depth_max + 5]}, error.DepthTooLarge, .unsupported);
}

test "a surrogate no other completes is refused (RFC 8259 §8.2)" {
    try expect_refused(.text, &.{
        "\"\\uD834\"",    "\"\\uDD1E\"",        "\"\\uD834\\u0041\"", "\"\\uD834x\"",
        "\"\\uD834\\n\"", "\"\\uD834\\uD834\"", "\"\\uDFFF\\uD800\"", "\"\\udbff\\ue000\"",
        "\"a\\uDC00\"",
    }, error.LoneSurrogate, .unsupported);
}

test "a sequence's text not preceded by a record separator is refused (RFC 7464 §2.1)" {
    try expect_refused(.sequence, &.{ "{}", " \x1e{}", "1\n" }, error.MissingRecordSeparator, .corrupt);
}

test "a record separator inside a sequence's text is refused as the text's end (RFC 7464 §2.1)" {
    try expect_refused(.sequence, &.{ "\x1e{\x1e", "\x1e\"ab\x1e", "\x1etr\x1e", "\x1e \x1e1\n", "\x1e[1,\x1e", "\x1e{\"a\"\x1e" }, error.IncompleteText, .corrupt);
}

test "a sequence's number or literal name with no whitespace after it is refused (RFC 7464 §2.4)" {
    try expect_refused(.sequence, &.{ "\x1e123\x1e", "\x1etrue", "\x1e123", "\x1enull\x1e{}\n", "\x1e-0" }, error.UndelimitedValue, .corrupt);
}

test "a text the input ends inside is truncated, not refused" {
    const cut = [_][]const u8{ "", " ", "fals", "-", "1.", "1e", "1e+", "\"\\\"", "\"\\u00", "\"\\uD834", "\"\\uD834\\", "\"\xe2\x82", "[", "{\"a\"", "{\"a\":", "[1,", "\xef\xbb\xbf"[0..0] };
    for (cut) |input| {
        try testing.expectEqual(decoder_test.Verdict.truncated, try decoder_test.expect_consistent(.text, input, decoder_test.split_seeds));
    }
    const sequence_cut = [_][]const u8{ "", "\x1e", "\x1e\x1e", "\x1e ", "\x1e[" };
    for (sequence_cut) |input| {
        try testing.expectEqual(decoder_test.Verdict.truncated, try decoder_test.expect_consistent(.sequence, input, decoder_test.split_seeds));
    }
}

test "each refusal class covers every error: two unsupported, the rest corrupt" {
    var unsupported: usize = 0;
    inline for (@typeInfo(decoder_file.Error).error_set.?) |err| {
        if (decoder_file.refusal(@field(anyerror, err.name)) == .unsupported) unsupported += 1;
    }
    try testing.expectEqual(2, unsupported);
}
