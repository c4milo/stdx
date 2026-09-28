//! An independent judge of the decoder: a recursive-descent parser written from RFC 8259 §2 to §7
//! and RFC 7464 §2.1 and §2.4 as their grammars read, with none of the decoder's code but the UTF-8
//! of `utf8.zig`, which that file's tests hold to RFC 3629 §4. Over every input the tests and the
//! fuzzer draw, the decoder's verdict must equal the parser's, and for a whole text so must every
//! token (decision 15: fuzzing without a judge finds crashes and misses a decoder that accepts what
//! it should refuse).
//!
//! The parser has the whole input at once, and reads it as the text's last octets. Its verdicts:
//! - done: the input is a text;
//! - truncated: the input ends inside what could still become a text;
//! - refused: no octets after the input could make it a text.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const utf8 = @import("../utf8.zig");
const Framing = @import("../framing.zig").Framing;
const decoder_test = @import("decoder_test.zig");
const Transcript = decoder_test.Transcript;
const Verdict = decoder_test.Verdict;

/// The largest input one case takes.
const input_len_max = 1024;

/// The seeded cases each normal test run takes.
const seeded_cases = 4000;

/// The most octets one token's content takes in the parser.
const content_len_max = 1024;

const Failure = error{ TestRefused, TestTruncated };

/// The values RFC 8259 §7 gives its escapes, spelled out apart from the decoder's constants.
const backspace = 0x08;
const form_feed = 0x0c;
const unit_digits = 4;
const hex_radix = 16;
const high_surrogates_first = 0xd800;
const low_surrogates_first = 0xdc00;
const low_surrogates_last = 0xdfff;
const pairs_first = 0x10000;
const bits_per_surrogate = 10;
const utf8_octets_max = 4;

const Parser = struct {
    input: []const u8,
    position: usize = 0,
    depth: usize = 0,
    transcript: *Transcript,
    /// Whether the text's value was a number or a literal name, which RFC 7464 §2.4 asks whitespace
    /// to follow.
    undelimited_value: bool = false,

    fn peek(self: *const Parser) Failure!u8 {
        if (self.position == self.input.len) return error.TestTruncated;
        return self.input[self.position];
    }

    fn take(self: *Parser) Failure!u8 {
        const octet = try self.peek();
        self.position += 1;
        return octet;
    }

    fn expect(self: *Parser, octet: u8) Failure!void {
        if (try self.take() != octet) return error.TestRefused;
    }

    /// ws = *( %x20 / %x09 / %x0A / %x0D ); returns the octets it took.
    fn whitespace(self: *Parser) usize {
        const start = self.position;
        while (self.position < self.input.len) : (self.position += 1) {
            switch (self.input[self.position]) {
                ' ', '\t', '\n', '\r' => {},
                else => break,
            }
        }
        return self.position - start;
    }

    /// JSON-text = ws value ws. The whole input must be the text.
    fn text(self: *Parser) Failure!void {
        if (std.mem.startsWith(u8, self.input, constants.byte_order_mark)) return error.TestRefused;
        _ = self.whitespace();
        try self.value();
        _ = self.whitespace();
        if (self.position != self.input.len) return error.TestRefused;
    }

    /// value = false / null / true / object / array / number / string
    fn value(self: *Parser) Failure!void {
        self.undelimited_value = false;
        switch (try self.peek()) {
            '{' => try self.object(),
            '[' => try self.array(),
            '"' => try self.string(.string),
            't' => try self.literal("true", .true),
            'f' => try self.literal("false", .false),
            'n' => try self.literal("null", .null),
            '-', '0'...'9' => try self.number(),
            else => return error.TestRefused,
        }
    }

    fn literal(self: *Parser, word: []const u8, kind: @import("decoder.zig").Kind) Failure!void {
        for (word) |letter| try self.expect(letter);
        self.transcript.add(kind, "");
        self.undelimited_value = true;
    }

    fn open(self: *Parser) Failure!void {
        self.position += 1;
        self.depth += 1;
        if (self.depth > constants.depth_max) return error.TestRefused;
    }

    /// object = begin-object [ member *( value-separator member ) ] end-object
    fn object(self: *Parser) Failure!void {
        try self.open();
        self.transcript.add(.begin_object, "");
        _ = self.whitespace();
        if (try self.peek() == '}') return self.close(.end_object);
        // Each member takes octets, so no more members than octets remain.
        for (0..self.input.len - self.position) |_| {
            _ = self.whitespace();
            if (try self.peek() != '"') return error.TestRefused;
            try self.string(.name);
            _ = self.whitespace();
            try self.expect(':');
            _ = self.whitespace();
            try self.value();
            _ = self.whitespace();
            switch (try self.take()) {
                ',' => continue,
                '}' => {
                    self.position -= 1;
                    return self.close(.end_object);
                },
                else => return error.TestRefused,
            }
        }
        return error.TestTruncated;
    }

    /// array = begin-array [ value *( value-separator value ) ] end-array
    fn array(self: *Parser) Failure!void {
        try self.open();
        self.transcript.add(.begin_array, "");
        _ = self.whitespace();
        if (try self.peek() == ']') return self.close(.end_array);
        // Each element takes octets, so no more elements than octets remain.
        for (0..self.input.len - self.position) |_| {
            _ = self.whitespace();
            try self.value();
            _ = self.whitespace();
            switch (try self.take()) {
                ',' => continue,
                ']' => {
                    self.position -= 1;
                    return self.close(.end_array);
                },
                else => return error.TestRefused,
            }
        }
        return error.TestTruncated;
    }

    fn close(self: *Parser, kind: @import("decoder.zig").Kind) void {
        self.position += 1;
        self.depth -= 1;
        self.transcript.add(kind, "");
        self.undelimited_value = false;
    }

    /// number = [ minus ] int [ frac ] [ exp ], read greedily; the text's end ends it.
    fn number(self: *Parser) Failure!void {
        const start = self.position;
        if (try self.peek() == '-') self.position += 1;
        try self.integer();
        if (self.next_is(".")) {
            self.position += 1;
            try self.digits();
        }
        if (self.next_is("eE")) {
            self.position += 1;
            if (self.next_is("+-")) self.position += 1;
            try self.digits();
        }
        self.transcript.add(.number, self.input[start..self.position]);
        self.undelimited_value = true;
    }

    /// int = zero / ( digit1-9 *DIGIT )
    fn integer(self: *Parser) Failure!void {
        const first = try self.take();
        if (!std.ascii.isDigit(first)) return error.TestRefused;
        if (first != '0') return self.more_digits();
        if (self.next_is("0123456789")) return error.TestRefused;
    }

    /// 1*DIGIT
    fn digits(self: *Parser) Failure!void {
        if (!std.ascii.isDigit(try self.take())) return error.TestRefused;
        self.more_digits();
    }

    fn more_digits(self: *Parser) void {
        while (self.next_is("0123456789")) self.position += 1;
    }

    /// True when the input holds another octet and it is one of `octets`.
    fn next_is(self: *const Parser, octets: []const u8) bool {
        return self.position < self.input.len and std.mem.indexOfScalar(u8, octets, self.input[self.position]) != null;
    }

    /// string = quotation-mark *char quotation-mark, unescaped into UTF-8.
    fn string(self: *Parser, kind: @import("decoder.zig").Kind) Failure!void {
        var content: [content_len_max]u8 = undefined;
        var len: usize = 0;
        try self.expect('"');
        // Each character takes octets, so no more characters than octets remain.
        for (0..self.input.len - self.position + 1) |_| {
            const octet = try self.peek();
            if (octet == '"') break;
            if (octet < ' ') return error.TestRefused;
            if (octet == '\\') {
                self.position += 1;
                len += try self.escape(content[len..]);
                continue;
            }
            const character_len = try self.character();
            @memcpy(content[len..][0..character_len], self.input[self.position..][0..character_len]);
            len += character_len;
            self.position += character_len;
        } else return error.TestTruncated;
        self.position += 1;
        self.transcript.add(kind, content[0..len]);
    }

    /// The octets of the UTF-8 character at the position. A character the input cuts, whose octets
    /// are right as far as they go, is truncated; any other that is not UTF-8 is refused.
    fn character(self: *Parser) Failure!usize {
        const rest = self.input[self.position..];
        if (utf8.character_len(rest)) |len| return len;
        var validation: utf8.Utf8 = .{};
        for (rest) |octet| {
            if (!validation.accept(octet)) return error.TestRefused;
        }
        return error.TestTruncated;
    }

    fn escape(self: *Parser, content: []u8) Failure!usize {
        const letter = try self.take();
        const named: u8 = switch (letter) {
            '"' => '"',
            '\\' => '\\',
            '/' => '/',
            'b' => backspace,
            'f' => form_feed,
            'n' => '\n',
            'r' => '\r',
            't' => '\t',
            'u' => return self.unicode(content),
            else => return error.TestRefused,
        };
        content[0] = named;
        return 1;
    }

    fn unicode(self: *Parser, content: []u8) Failure!usize {
        const unit = try self.code_unit();
        if (unit >= low_surrogates_first and unit <= low_surrogates_last) return error.TestRefused;
        var code_point: u21 = unit;
        if (unit >= high_surrogates_first and unit < low_surrogates_first) {
            try self.expect('\\');
            try self.expect('u');
            const low = try self.code_unit();
            if (low < low_surrogates_first or low > low_surrogates_last) return error.TestRefused;
            code_point = pairs_first + (@as(u21, unit - high_surrogates_first) << bits_per_surrogate) + (low - low_surrogates_first);
        }
        var octets: [utf8_octets_max]u8 = undefined;
        const len = std.unicode.utf8Encode(code_point, &octets) catch return error.TestRefused;
        @memcpy(content[0..len], octets[0..len]);
        return len;
    }

    fn code_unit(self: *Parser) Failure!u16 {
        var unit: u16 = 0;
        for (0..unit_digits) |_| {
            const digit = std.fmt.charToDigit(try self.take(), hex_radix) catch return error.TestRefused;
            unit = unit * hex_radix + digit;
        }
        return unit;
    }
};

/// The parser's verdict on `input`, and its tokens.
pub fn judge(framing: Framing, input: []const u8, transcript: *Transcript) Verdict {
    return switch (framing) {
        .text => judge_text(input, transcript),
        .sequence => judge_sequence(input, transcript),
    };
}

fn judge_text(input: []const u8, transcript: *Transcript) Verdict {
    var parser: Parser = .{ .input = input, .transcript = transcript };
    parser.text() catch |failure| return switch (failure) {
        error.TestRefused => .{ .refused = error.ExpectedValue },
        error.TestTruncated => .truncated,
    };
    return .done;
}

/// A sequence's first text (RFC 7464 §2.1): one or more record separators, then the octets up to
/// the next one or the input's end, which must be a text; a number or a literal name must have
/// whitespace after it (§2.4).
fn judge_sequence(input: []const u8, transcript: *Transcript) Verdict {
    if (input.len == 0) return .truncated;
    if (input[0] != constants.record_separator) return .{ .refused = error.ExpectedValue };
    var start: usize = 0;
    while (start < input.len and input[start] == constants.record_separator) start += 1;
    const end = std.mem.indexOfScalarPos(u8, input, start, constants.record_separator) orelse input.len;
    const ended_by_separator = end < input.len;
    const verdict = judge_element(input[start..end], transcript);
    // RFC 7464 §2.1: a record separator ends the text, so a text it cuts is refused, not truncated.
    if (verdict == .truncated and ended_by_separator) return .{ .refused = error.ExpectedValue };
    return verdict;
}

/// The octets of one text of a sequence, up to the next record separator or the input's end.
fn judge_element(element: []const u8, transcript: *Transcript) Verdict {
    if (element.len == 0) return .truncated;
    var parser: Parser = .{ .input = element, .transcript = transcript };
    if (std.mem.startsWith(u8, element, constants.byte_order_mark)) return .{ .refused = error.ExpectedValue };
    _ = parser.whitespace();
    parser.value() catch |failure| return switch (failure) {
        error.TestRefused => .{ .refused = error.ExpectedValue },
        error.TestTruncated => .truncated,
    };
    const trailing = parser.whitespace();
    if (parser.position != element.len) return .{ .refused = error.ExpectedValue };
    // RFC 7464 §2.4: a number or a literal name must have whitespace after it.
    if (parser.undelimited_value and trailing == 0) return .{ .refused = error.ExpectedValue };
    return .done;
}

/// Requires the decoder's verdict on `input` to be the parser's, and for a whole text its tokens.
fn expect_judged(framing: Framing, input: []const u8) !void {
    var expected: Transcript = .{};
    var transcript: Transcript = .{};
    const reference = judge(framing, input, &expected);
    const verdict = decoder_test.decode_whole(.{}, framing, input, &transcript);
    const same = switch (reference) {
        .done => verdict == .done,
        .truncated => verdict == .truncated,
        .refused => verdict == .refused,
    };
    if (!same) return error.TestVerdictsDiffer;
    if (reference == .done) try testing.expectEqualStrings(expected.slice(), transcript.slice());
}

test "the decoder's verdict is the parser's on every text the RFC gives and on hand-picked edges" {
    const inputs = [_][]const u8{
        "{\"a\":[1,2,{\"b\":null}],\"c\":\"\\u00e9\\uD834\\uDD1E\"}", "  []  ",       "\"\"",           "0",      "-0.0e-0",
        "1.5E+10",                                                    "01",           "1.",             "1e",     "\"\\uD834\"",
        "\"\\uD834",                                                  "\"\\uDD1E",    "{",              "{\"a\"", "[1,]",
        "tru",                                                        "truex",        "\xef\xbb\xbf{}", "\xef",   "\"a\x7fb\"",
        "\"\xf4\x8f\xbf\xbf\"",                                       "\"\xf4\x90\"",
    };
    for (inputs) |input| try expect_judged(.text, input);
    const sequences = [_][]const u8{ "\x1e{}\n", "\x1e1\n", "\x1e1", "\x1e1\x1e", "\x1e\x1e[]", "{}", "", "\x1e", "\x1e \x1e", "\x1e\"a\x1e" };
    for (sequences) |input| try expect_judged(.sequence, input);
}

test "the decoder's verdict is the parser's on seeded inputs near and far from the grammar" {
    var input: [input_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        const len = draw_jsonish(&generator, &input);
        try expect_judged(.text, input[0..len]);
        try expect_judged(.sequence, input[0..len]);
        const cut = generator.below(len + 1);
        try expect_judged(.text, input[0..cut]);
        try expect_judged(.sequence, input[0..cut]);
    }
}

/// Octets drawn from the grammar's alphabet, in runs that often form its tokens.
fn draw_jsonish(generator: *codec.split.Generator, buffer: []u8) usize {
    const pieces = [_][]const u8{
        "{",  "}",  "[",       "]",   ":",       ",",    " ",     "\n",   "\"",       "\"a\"",        "\"\\n\"", "\"\\u00e9\"", "\"\\uD834\\uDD1E\"", "\\",
        "0",  "-1", "2.5",     "1e9", "-0.0E-1", "true", "false", "null", "\xc3\xa9", "\xe2\x82\xac", "\x1e",    "\x00",        "\xff",               "\"\\uD834\"",
        "01", "tr", "{\"k\":", "[1,",
    };
    var len: usize = 0;
    const count = generator.below(pieces.len + pieces.len);
    for (0..count) |_| {
        const piece = pieces[generator.below(pieces.len)];
        if (len + piece.len > buffer.len) break;
        @memcpy(buffer[len..][0..piece.len], piece);
        len += piece.len;
    }
    return len;
}

test "fuzz the decoder against the parser" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "{\"a\":[1,\"b\",null,true]}", "\x1e{\"n\":1}\n", "\"\\uD834\\uDD1E\"", "-0.5e-3" } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const len = smith.slice(&input);
    try expect_judged(.text, input[0..len]);
    try expect_judged(.sequence, input[0..len]);
}
