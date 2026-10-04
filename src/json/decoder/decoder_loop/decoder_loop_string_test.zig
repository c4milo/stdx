//! Tests of the string loop's `\u` escapes (decoder_loop_string.zig): claim J12's words against
//! the escape read a digit at a time.

const std = @import("std");
const testing = std.testing;
const constants = @import("../../constants.zig");
const loop_string = @import("decoder_loop_string.zig");

const letter_escape_len = loop_string.letter_escape_len;
const unicode_escape_len = loop_string.unicode_escape_len;
const pair_escape_len = loop_string.pair_escape_len;
const escape_digits_bits = loop_string.escape_digits_bits;
const code_unit = loop_string.code_unit;
const code_unit_pair = loop_string.code_unit_pair;
const code_unit_word = loop_string.code_unit_word;

/// The case of each escape's digits in a pair `pair_text` writes.
const Case = enum { lower, upper, upper_first, upper_second };

/// Two `\u` escapes of `first` and `second`, their digits in `case`.
fn pair_text(first: u16, second: u16, case: Case) [pair_escape_len]u8 {
    var text: [pair_escape_len]u8 = undefined;
    _ = std.fmt.bufPrint(text[0..unicode_escape_len], "\\u{x:0>4}", .{first}) catch unreachable;
    _ = std.fmt.bufPrint(text[unicode_escape_len..], "\\u{x:0>4}", .{second}) catch unreachable;
    const first_digits = text[letter_escape_len..unicode_escape_len];
    const second_digits = text[unicode_escape_len + letter_escape_len ..];
    if (case == .upper or case == .upper_first) _ = std.ascii.upperString(first_digits, first_digits);
    if (case == .upper or case == .upper_second) _ = std.ascii.upperString(second_digits, second_digits);
    return text;
}

/// Requires `code_unit_pair` to give what `code_unit` gives each escape of `text`, or null where it
/// gives null for either.
fn expect_pair_as_single(text: *const [pair_escape_len]u8) !void {
    const first = code_unit(text, 0);
    const second = code_unit(text, unicode_escape_len);
    const pair = code_unit_pair(text);
    if (first == null or second == null) return testing.expectEqual(null, pair);
    try testing.expectEqual(first.?, @as(u16, @truncate(pair.?)));
    try testing.expectEqual(second.?, @as(u16, @truncate(pair.? >> escape_digits_bits)));
}

test "code_unit_pair reads every code unit as code_unit does, in each case, first and second" {
    for (0..std.math.maxInt(u16) + 1) |unit| {
        const partner: u16 = @truncate(unit *% 40503 +% 11);
        for (std.enums.values(Case)) |case| {
            try expect_pair_as_single(&pair_text(@intCast(unit), partner, case));
            try expect_pair_as_single(&pair_text(partner, @intCast(unit), case));
        }
    }
}

test "code_unit_pair refuses a pair with any octet an escape cannot hold where it stands" {
    const valid = pair_text(0x0430, 0x4e2f, .lower);
    for (0..pair_escape_len) |position| {
        for (0..std.math.maxInt(u8) + 1) |octet| {
            var text = valid;
            text[position] = @intCast(octet);
            try expect_pair_as_single(&text);
        }
    }
}

/// Requires `code_unit_word` to give what `code_unit` gives the escape that starts `text`.
fn expect_word_as_single(text: *const [constants.word_len]u8) !void {
    try testing.expectEqual(code_unit(text, 0), code_unit_word(text));
}

test "code_unit_word reads every code unit as code_unit does, in either case, whatever follows" {
    for (0..std.math.maxInt(u16) + 1) |unit| {
        for (std.enums.values(Case)) |case| {
            const pair = pair_text(@intCast(unit), @truncate(unit *% 7), case);
            try expect_word_as_single(pair[0..constants.word_len]);
            var text = pair[0..constants.word_len].*;
            text[unicode_escape_len] = '"';
            try expect_word_as_single(&text);
        }
    }
}

test "code_unit_word refuses an escape with any octet it cannot hold where it stands" {
    const valid = pair_text(0x0430, 0x4e2f, .lower);
    for (0..unicode_escape_len) |position| {
        for (0..std.math.maxInt(u8) + 1) |octet| {
            var text = valid[0..constants.word_len].*;
            text[position] = @intCast(octet);
            try expect_word_as_single(&text);
        }
    }
}
