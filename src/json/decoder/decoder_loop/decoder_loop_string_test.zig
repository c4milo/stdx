//! Tests of the string loop (decoder_loop_string.zig): claim J12's words against the escape read
//! a digit at a time, the text of escapes its loop takes, and where `copy_rest` ends.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const wide = @import("../../wide.zig");
const loop_string = @import("decoder_loop_string.zig");
const Copied = loop_string.Copied;

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

/// What `unicode_text` takes from the start of `text`, and the characters it writes.
fn expect_text(text: []const u8, input_len: usize, characters: []const u8) !void {
    var room: [constants.kernel_alignment]u8 = undefined;
    const taken = loop_string.unicode_text(text, &room, .{ .input_len = 0, .output_len = 0 });
    try testing.expectEqual(input_len, taken.input_len);
    try testing.expectEqualStrings(characters, room[0..taken.output_len]);
}

test "the \\u text takes a letter's escape between two \\u escapes, and stops at one of no letter" {
    // Both `\u` escapes, the line feed between them, and the space; the quotation mark stops it.
    try expect_text("\\u0430\\n\\u0431 \"", "\\u0430\\n\\u0431 ".len, "\u{430}\n\u{431} ");
    inline for (constants.escape_letters, constants.escaped_characters) |letter, character| {
        const text = "\\u0041\\" ++ [_]u8{letter} ++ "\\u0042 \"";
        try expect_text(text, text.len - 1, "A" ++ [_]u8{character} ++ "B ");
    }
    try expect_text("\\u0430\\q\\u0431 \"", unicode_escape_len, "\u{430}");
    try expect_text("\\u0430\\u\\u0431 \"", unicode_escape_len, "\u{430}");
}

/// The longest room a case here gives `copy_rest`: every ASCII octet's, and a line more.
const room_len_max = constants.non_ascii_min + constants.kernel_alignment;

/// What `copy_rest` takes of `rest` into a room of `room_len` octets, with every claim on.
fn copied_of(rest: []const u8, room_len: usize) ?Copied {
    var room: [room_len_max]u8 = undefined;
    return loop_string.copy_rest_at(.{}, wide.Level.of(codec.Features.detect()), rest, room[0..room_len]);
}

test "copy_rest takes a string up to a closing quotation mark that is the input's last octet" {
    try testing.expectEqual(Copied{ .input_len = 2, .output_len = 1 }, copied_of("\\n\"", constants.vector_len));
    try testing.expectEqual(Copied{ .input_len = 4, .output_len = 2 }, copied_of("\\r\\n\"", constants.vector_len));
}

test "copy_rest leaves a string the input ends inside to the checked path" {
    try testing.expectEqual(null, copied_of("\\n", constants.vector_len));
    try testing.expectEqual(null, copied_of("\\n\\", constants.vector_len));
    try testing.expectEqual(null, copied_of("\\nab", constants.vector_len));
    // A `\u` escape and a reverse solidus the input ends with, and two escapes claim J12 takes as
    // a pair, which the input ends with.
    try testing.expectEqual(null, copied_of("\\u0041\\", constants.vector_len));
    try testing.expectEqual(null, copied_of("\\u0041\\u0042\\", constants.vector_len));
    try testing.expectEqual(null, copied_of("\\u0041\\u0042", constants.vector_len));
}

test "copy_rest leaves a string whose room ends inside a run of \\u escapes to the checked path" {
    // The escape's character and four octets after it fill the room; a fifth has none.
    try testing.expectEqual(Copied{ .input_len = 10, .output_len = 5 }, copied_of("\\u0041bcde\"", 5));
    try testing.expectEqual(null, copied_of("\\u0041bcdef\"", 5));
}

test "copy_rest takes every plain ASCII octet in its blocks, from the space to U+007F" {
    // Past an escape, every octet a string carries as it is, in blocks of 16: the space is the
    // first of them and U+007F the last (RFC 8259 §7).
    comptime var plain: []const u8 = "";
    comptime for (constants.unescaped_min..constants.non_ascii_min) |octet| {
        if (octet != constants.quotation_mark and octet != constants.reverse_solidus) plain = plain ++ [_]u8{octet};
    };
    const rest = "\\n" ++ plain ++ "\"" ++ " " ** constants.vector_len;
    try testing.expectEqual(Copied{ .input_len = 2 + plain.len, .output_len = 1 + plain.len }, copied_of(rest, room_len_max));
}
