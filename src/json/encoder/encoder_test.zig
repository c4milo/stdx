//! Tests for the encoder: every token in every place RFC 8259's grammar allows it, each escape of
//! RFC 8259 §7, each refusal, the framing of RFC 7464 §2.2, and the same octets under every split
//! of the input and the output a seed draws, with the state moved between calls (invariants 5 and
//! 12), and under every claim switched off (decision 21).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const claims = @import("../claims.zig");
const encoder_file = @import("encoder.zig");
const Encoder = encoder_file.Encoder;
const Token = encoder_file.Token;
const Piece = encoder_file.Piece;
const TextWriter = @import("text_writer.zig").TextWriter;
const Framing = @import("../framing.zig").Framing;

/// The most octets a test's text takes.
const text_len_max = 4096;

/// The seeds each list of tokens is encoded under.
const split_seeds = 300;

/// One token and all of its octets.
pub const Item = struct {
    token: Token,
    octets: []const u8 = "",
};

/// A token that takes octets, as the last piece.
pub fn with(comptime kind: std.meta.Tag(Token), octets: []const u8) Item {
    return .{ .token = @unionInit(Token, @tagName(kind), .last), .octets = octets };
}

/// Encodes `items` one call each, with all the room left, under `claims_used`.
pub fn encode_whole(comptime claims_used: claims.Claims, framing: Framing, items: []const Item, output: []u8) !usize {
    var encoder: Encoder = undefined;
    encoder.init(framing);
    var written: usize = 0;
    for (items, 0..) |item, index| {
        const progress = try encoder.encode_with(claims_used, item.token, item.octets, output[written..]);
        written += progress.written;
        try testing.expectEqual(item.octets.len, progress.consumed);
        const expected: codec.Status = if (index + 1 == items.len) .done else .needs_input;
        try testing.expectEqual(expected, progress.status);
    }
    return written;
}

/// Encodes `items` with the input of each token and the output cut into the pieces `seed` draws,
/// the state moved to the other slot before the second call and at drawn calls after it, and
/// returns the octets written or the first error.
pub fn encode_split(framing: Framing, items: []const Item, output: []u8, seed: u64) !usize {
    var drive: EncodeDrive = .{ .schedule = codec.split.Schedule.init(seed), .output = output };
    drive.states[0].init(framing);
    for (items) |item| {
        if (try drive.token(item)) return drive.written;
    }
    return drive.written;
}

/// Where a split encode stands: the states it moves between, and the output it has written.
const EncodeDrive = struct {
    schedule: codec.split.Schedule,
    output: []u8,
    states: [codec.split.state_slots]Encoder = undefined,
    slot: usize = 0,
    calls: usize = 0,
    written: usize = 0,

    /// Encodes one token in the pieces the schedule draws. Returns whether it ended the text.
    fn token(self: *EncodeDrive, item: Item) !bool {
        var consumed: usize = 0;
        const calls_max = codec.constants.driver_calls_floor + codec.constants.driver_calls_per_octet_max * (item.octets.len + self.output.len);
        for (0..calls_max) |_| {
            if (self.calls == 1 or (self.calls > 1 and self.schedule.move_state())) self.slot = move(&self.states, self.slot);
            self.calls += 1;
            const input = item.octets[consumed..][0..self.schedule.piece_len(item.octets.len - consumed)];
            const last = consumed + input.len == item.octets.len;
            const room = self.output[self.written..][0..self.schedule.piece_len(self.output.len - self.written)];
            const progress = try self.states[self.slot].encode(piece_token(item.token, last), input, room);
            consumed += progress.consumed;
            self.written += progress.written;
            switch (progress.status) {
                .done => return true,
                // With the last piece, `needs_input` says the token is written.
                .needs_input => if (last) return false,
                .needs_room => if (self.written == self.output.len) return error.TestOutputFull,
            }
        }
        return error.TestNoProgress;
    }
};

/// `token` with its piece set to `last` or `more`.
fn piece_token(token: Token, last: bool) Token {
    const piece: Piece = if (last) .last else .more;
    return switch (token) {
        .name => .{ .name = piece },
        .string => .{ .string = piece },
        .hex => .{ .hex = piece },
        .number => .{ .number = piece },
        else => token,
    };
}

fn move(states: *[codec.split.state_slots]Encoder, slot: usize) usize {
    const other = 1 - slot;
    states[other] = states[slot];
    @memset(std.mem.asBytes(&states[slot]), codec.constants.moved_state_fill);
    return other;
}

/// Requires `items` to encode to `expected` in one call a token, with every claim on and off, and
/// under every seed's split.
pub fn expect_encodes(framing: Framing, items: []const Item, expected: []const u8) !void {
    var output: [text_len_max]u8 = undefined;
    const whole_len = try encode_whole(.{}, framing, items, &output);
    try testing.expectEqualStrings(expected, output[0..whole_len]);
    try testing.expectEqualStrings(expected, output[0..try encode_whole(claims.scalar, framing, items, &output)]);
    try testing.expectEqualStrings(expected, output[0..try encode_whole(claims.vector, framing, items, &output)]);
    for (0..split_seeds) |seed| {
        var split_output: [text_len_max]u8 = undefined;
        const split_len = try encode_split(framing, items, split_output[0..expected.len], seed);
        try testing.expectEqualStrings(expected, split_output[0..split_len]);
    }
}

/// Requires `items` to be refused with `expected`, in one call a token and under every split.
fn expect_refused(items: []const Item, expected: encoder_file.Error) !void {
    var output: [text_len_max]u8 = undefined;
    try testing.expectError(expected, encode_whole(.{}, .text, items, &output));
    try testing.expectError(expected, encode_whole(claims.scalar, .text, items, &output));
    for (0..split_seeds) |seed| {
        try testing.expectError(expected, encode_split(.text, items, &output, seed));
    }
}

test "an object and an array place every separator (RFC 8259 §4, §5)" {
    try expect_encodes(.text, &.{
        .{ .token = .begin_object },
        with(.name, "a"),
        .{ .token = .{ .unsigned = 1 } },
        with(.name, "list"),
        .{ .token = .begin_array },
        .{ .token = .{ .signed = -2 } },
        .{ .token = .{ .boolean = true } },
        .{ .token = .null },
        .{ .token = .begin_object },
        .{ .token = .end_object },
        .{ .token = .begin_array },
        .{ .token = .end_array },
        with(.string, "end"),
        .{ .token = .end_array },
        with(.name, ""),
        .{ .token = .{ .boolean = false } },
        .{ .token = .end_object },
    }, "{\"a\":1,\"list\":[-2,true,null,{},[],\"end\"],\"\":false}");
}

test "a text may be any value (RFC 8259 §2)" {
    try expect_encodes(.text, &.{with(.string, "Hello world!")}, "\"Hello world!\"");
    try expect_encodes(.text, &.{.{ .token = .{ .unsigned = 42 } }}, "42");
    try expect_encodes(.text, &.{.{ .token = .{ .boolean = true } }}, "true");
    try expect_encodes(.text, &.{.{ .token = .null }}, "null");
    try expect_encodes(.text, &.{ .{ .token = .begin_array }, .{ .token = .end_array } }, "[]");
    try expect_encodes(.text, &.{with(.number, "-1.5e+10")}, "-1.5e+10");
    try expect_encodes(.text, &.{.{ .token = .{ .decimal = .{ .integer = 1234, .fraction = 567, .fraction_digits = 3 } } }}, "1234.567");
}

test "a string escapes what RFC 8259 §7 requires and nothing else" {
    try expect_encodes(.text, &.{with(.string, "\"\\/\x08\x0c\n\r\t")}, "\"\\\"\\\\/\\b\\f\\n\\r\\t\"");
    try expect_encodes(.text, &.{with(.string, "\x00\x01\x1e\x1f\x20\x7f")}, "\"\\u0000\\u0001\\u001e\\u001f \x7f\"");
    try expect_encodes(.text, &.{with(.string, "caf\xc3\xa9 \xe2\x82\xac \xf0\x9d\x84\x9e")}, "\"caf\xc3\xa9 \xe2\x82\xac \xf0\x9d\x84\x9e\"");
    try expect_encodes(.text, &.{ .{ .token = .begin_object }, with(.name, "a\"b"), .{ .token = .null }, .{ .token = .end_object } }, "{\"a\\\"b\":null}");
}

test "a string of every octet below U+0080 escapes exactly the ones RFC 8259 §7 names" {
    var octets: [0x80]u8 = undefined;
    for (&octets, 0..) |*octet, value| octet.* = @intCast(value);
    var expected: [text_len_max]u8 = undefined;
    var len: usize = 0;
    expected[len] = '"';
    len += 1;
    for (octets) |octet| {
        const escape: []const u8 = switch (octet) {
            '"' => "\\\"",
            '\\' => "\\\\",
            0x08 => "\\b",
            0x0c => "\\f",
            '\n' => "\\n",
            '\r' => "\\r",
            '\t' => "\\t",
            else => "",
        };
        if (escape.len > 0) {
            @memcpy(expected[len..][0..escape.len], escape);
            len += escape.len;
        } else if (octet < 0x20) {
            const hex = "0123456789abcdef";
            @memcpy(expected[len..][0..6], &[6]u8{ '\\', 'u', '0', '0', hex[octet >> 4], hex[octet & 0xf] });
            len += 6;
        } else {
            expected[len] = octet;
            len += 1;
        }
    }
    expected[len] = '"';
    len += 1;
    try expect_encodes(.text, &.{with(.string, &octets)}, expected[0..len]);
}

test "a hex string holds two lowercase digits an octet" {
    try expect_encodes(.text, &.{with(.hex, "")}, "\"\"");
    try expect_encodes(.text, &.{with(.hex, "\x00\x01\xab\xff")}, "\"0001abff\"");
    var octets: [0x100]u8 = undefined;
    var expected: [2 + 2 * 0x100]u8 = undefined;
    expected[0] = '"';
    for (&octets, 0..) |*octet, value| {
        octet.* = @intCast(value);
        _ = std.fmt.bufPrint(expected[1 + 2 * value ..][0..2], "{x:0>2}", .{value}) catch unreachable;
    }
    expected[expected.len - 1] = '"';
    try expect_encodes(.text, &.{with(.hex, &octets)}, &expected);
}

test "a sequence's text is a record separator, the text and a line feed (RFC 7464 §2.2)" {
    try expect_encodes(.sequence, &.{ .{ .token = .begin_object }, with(.name, "n"), .{ .token = .{ .unsigned = 7 } }, .{ .token = .end_object } }, "\x1e{\"n\":7}\n");
    try expect_encodes(.sequence, &.{.{ .token = .{ .unsigned = 7 } }}, "\x1e7\n");
    try expect_encodes(.sequence, &.{with(.string, "")}, "\x1e\"\"\n");
}

test "a name or a string that is not UTF-8 is refused (RFC 8259 §8.1, RFC 3629 §4)" {
    const invalid = [_][]const u8{ "\x80", "a\xc0\x80", "\xc1\xbf", "\xed\xa0\x80", "\xf4\x90\x80\x80", "\xf5", "\xe2\x82", "\xe2\x82a", "\xff", "\xf0\x8f\xbf\xbf", "\xe0\x9f\xbf", "\xc3\xc3\xa9\xa9" };
    for (invalid) |octets| {
        try expect_refused(&.{with(.string, octets)}, error.InvalidUtf8);
        try expect_refused(&.{ .{ .token = .begin_object }, with(.name, octets) }, error.InvalidUtf8);
    }
}

test "a number's text that is not one number is refused (RFC 8259 §6)" {
    const invalid = [_][]const u8{ "", "-", "01", "1.", ".5", "1e", "+1", "1 ", "1,2", "NaN", "0x1" };
    for (invalid) |text| try expect_refused(&.{with(.number, text)}, error.InvalidNumber);
}

test "an object or an array past depth_max is refused, and depth_max is written (RFC 8259 §9)" {
    var output: [text_len_max]u8 = undefined;
    var encoder: Encoder = undefined;
    encoder.init(.text);
    for (0..constants.depth_max) |_| _ = try encoder.encode(.begin_array, "", &output);
    try testing.expectError(error.DepthTooLarge, encoder.encode(.begin_array, "", &output));
    encoder.init(.text);
    for (0..constants.depth_max - 1) |_| _ = try encoder.encode(.begin_array, "", &output);
    _ = try encoder.encode(.begin_object, "", &output);
    _ = try encoder.encode(.{ .name = .last }, "n", &output);
    try testing.expectError(error.DepthTooLarge, encoder.encode(.begin_object, "", &output));
}

test "a whole-buffer text fails without writing past the buffer at every shorter length" {
    const expected = "{\"time\":1234.567,\"name\":\"transport:packet_sent\",\"data\":{\"raw\":\"00ff\",\"length\":1200}}";
    var buffer: [expected.len + 16]u8 = undefined;
    const Record = struct {
        fn write(text: *TextWriter) !void {
            try text.begin_object();
            try text.name("time");
            try text.decimal(.{ .integer = 1234, .fraction = 567, .fraction_digits = 3 });
            try text.name("name");
            try text.string("transport:packet_sent");
            try text.name("data");
            try text.begin_object();
            try text.name("raw");
            try text.hex("\x00\xff");
            try text.name("length");
            try text.unsigned(1200);
            try text.end_object();
            try text.end_object();
        }
    };
    for (0..expected.len + 1) |len| {
        @memset(&buffer, 0xaa);
        var text = TextWriter.init(buffer[0..len], .text);
        const result = Record.write(&text);
        if (len < expected.len) {
            try testing.expectError(error.NoSpaceLeft, result);
        } else {
            try result;
            try testing.expectEqualStrings(expected, text.written());
        }
        for (buffer[len..]) |octet| try testing.expectEqual(0xaa, octet);
    }
}
