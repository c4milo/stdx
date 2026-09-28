//! Tests for the decoder: RFC 8259 §13's examples, every escape of §7, and the same tokens and
//! verdict whether a text is decoded one token a call, under every seed's split of the input and
//! the output with the state moved between calls (invariants 5 and 12), or with every claim off
//! (decision 21). The refusals are in decoder_refusal_test.zig and the fuzz tests in
//! decoder_fuzz_test.zig, over the helpers here.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const claims = @import("../claims.zig");
const decoder_file = @import("decoder.zig");
const Decoder = decoder_file.Decoder;
const Kind = decoder_file.Kind;
const Framing = @import("../framing.zig").Framing;
const Piece = @import("../framing.zig").Piece;
const text_reader = @import("text_reader.zig");

/// The most octets a transcript holds, and a token's octets.
const transcript_len_max = 65536;
const content_len_max = 4096;

/// The calls one token a call takes beyond one an octet: a number the text's end ends, and `done`.
const whole_calls_extra = 2;

/// The seeds each text is decoded under.
pub const split_seeds = 200;

/// The tokens a decode gave, each as its kind's name, a space, its octets and a line feed, which
/// reads well in a failed test.
pub const Transcript = struct {
    octets: [transcript_len_max]u8 = undefined,
    len: usize = 0,

    pub fn add(self: *Transcript, kind: Kind, content: []const u8) void {
        for ([_][]const u8{ @tagName(kind), " ", content, "\n" }) |part| {
            @memcpy(self.octets[self.len..][0..part.len], part);
            self.len += part.len;
        }
    }

    pub fn slice(self: *const Transcript) []const u8 {
        return self.octets[0..self.len];
    }
};

/// How a decode ended.
pub const Verdict = union(enum) {
    done,
    /// The input ended before the text did.
    truncated,
    refused: decoder_file.Error,
};

/// Decodes `input` one token a call, all of it the text's last piece, under `claims_used`.
pub fn decode_whole(comptime claims_used: claims.Claims, framing: Framing, input: []const u8, transcript: *Transcript) Verdict {
    var decoder: Decoder = undefined;
    decoder.init(framing);
    var output: [content_len_max]u8 = undefined;
    var consumed: usize = 0;
    for (0..input.len + whole_calls_extra) |_| {
        const progress = decoder.decode_with(claims_used, input[consumed..], &output, .last) catch |err| return .{ .refused = err };
        consumed += progress.consumed;
        switch (progress.status) {
            .token => transcript.add(progress.kind.?, output[0..progress.written]),
            .done => return .done,
            .needs_input => return .truncated,
            .needs_room => unreachable,
        }
    }
    unreachable;
}

/// Decodes `input` with the input and the output cut into the pieces `seed` draws, and the state
/// moved to the other slot before the second call and at drawn calls after it.
pub fn decode_split(framing: Framing, input: []const u8, seed: u64, transcript: *Transcript) !Verdict {
    var schedule = codec.split.Schedule.init(seed);
    var states: [codec.split.state_slots]Decoder = undefined;
    states[0].init(framing);
    var slot: usize = 0;
    var drive: SplitDrive = .{ .input = input, .transcript = transcript };
    const calls_max = codec.constants.driver_calls_floor + codec.constants.driver_calls_per_octet_max * (input.len + content_len_max);
    for (0..calls_max) |call| {
        if (call == 1 or (call > 1 and schedule.move_state())) slot = move(&states, slot);
        if (try drive.call(&states[slot], &schedule)) |verdict| return verdict;
    }
    return error.TestNoProgress;
}

/// Where a split decode stands: the input it has given, and the octets of the token in progress.
const SplitDrive = struct {
    input: []const u8,
    transcript: *Transcript,
    consumed: usize = 0,
    content: [content_len_max]u8 = undefined,
    content_len: usize = 0,

    /// Makes one call with the pieces `schedule` draws. Returns the verdict once there is one.
    fn call(self: *SplitDrive, decoder: *Decoder, schedule: *codec.split.Schedule) !?Verdict {
        const input = self.input[self.consumed..][0..schedule.piece_len(self.input.len - self.consumed)];
        const piece: Piece = if (self.consumed + input.len == self.input.len) .last else .more;
        const room = self.content[self.content_len..][0..schedule.piece_len(self.content.len - self.content_len)];
        const progress = decoder.decode(input, room, piece) catch |err| return .{ .refused = err };
        self.consumed += progress.consumed;
        self.content_len += progress.written;
        switch (progress.status) {
            .token => {
                self.transcript.add(progress.kind.?, self.content[0..self.content_len]);
                self.content_len = 0;
            },
            .done => return .done,
            .needs_input => if (piece == .last) return .truncated,
            .needs_room => if (self.content_len == self.content.len) return error.TestContentFull,
        }
        return null;
    }
};

fn move(states: *[codec.split.state_slots]Decoder, slot: usize) usize {
    const other = 1 - slot;
    states[other] = states[slot];
    @memset(std.mem.asBytes(&states[slot]), codec.constants.moved_state_fill);
    return other;
}

/// Requires `input` to give the same tokens and verdict one token a call with the default claims,
/// with every claim off and every claim on, and under every seed's split. Returns the verdict.
pub fn expect_consistent(framing: Framing, input: []const u8, seeds: usize) !Verdict {
    var expected: Transcript = .{};
    const verdict = decode_whole(.{}, framing, input, &expected);
    inline for (.{ claims.scalar, claims.vector }) |claims_used| {
        var transcript: Transcript = .{};
        try testing.expectEqual(verdict, decode_whole(claims_used, framing, input, &transcript));
        try testing.expectEqualStrings(expected.slice(), transcript.slice());
    }
    for (0..seeds) |seed| {
        var transcript: Transcript = .{};
        try testing.expectEqual(verdict, try decode_split(framing, input, seed, &transcript));
        try testing.expectEqualStrings(expected.slice(), transcript.slice());
    }
    return verdict;
}

/// Requires `input` to decode, every way, to the tokens `expected` lists.
pub fn expect_tokens(framing: Framing, input: []const u8, expected: []const u8) !void {
    var transcript: Transcript = .{};
    try testing.expectEqual(Verdict.done, decode_whole(.{}, framing, input, &transcript));
    try testing.expectEqualStrings(expected, transcript.slice());
    try testing.expectEqual(Verdict.done, try expect_consistent(framing, input, split_seeds));
}

test "RFC 8259 §13's object decodes to its tokens" {
    try expect_tokens(
        .text,
        \\{
        \\  "Image": {
        \\      "Width":  800,
        \\      "Height": 600,
        \\      "Title":  "View from 15th Floor",
        \\      "Thumbnail": {
        \\          "Url":    "http://www.example.com/image/481989943",
        \\          "Height": 125,
        \\          "Width":  100
        \\      },
        \\      "Animated" : false,
        \\      "IDs": [116, 943, 234, 38793]
        \\    }
        \\}
    ,
        "begin_object \nname Image\nbegin_object \nname Width\nnumber 800\nname Height\nnumber 600\n" ++
            "name Title\nstring View from 15th Floor\nname Thumbnail\nbegin_object \nname Url\n" ++
            "string http://www.example.com/image/481989943\nname Height\nnumber 125\nname Width\n" ++
            "number 100\nend_object \nname Animated\nfalse \nname IDs\nbegin_array \nnumber 116\n" ++
            "number 943\nnumber 234\nnumber 38793\nend_array \nend_object \nend_object \n",
    );
}

test "RFC 8259 §13's array of two objects decodes to its tokens" {
    try expect_tokens(
        .text,
        \\[
        \\  {
        \\     "precision": "zip",
        \\     "Latitude":  37.7668,
        \\     "Longitude": -122.3959,
        \\     "Address":   "",
        \\     "City":      "SAN FRANCISCO",
        \\     "State":     "CA",
        \\     "Zip":       "94107",
        \\     "Country":   "US"
        \\  },
        \\  {
        \\     "precision": "zip",
        \\     "Latitude":  37.371991,
        \\     "Longitude": -122.026020,
        \\     "Address":   "",
        \\     "City":      "SUNNYVALE",
        \\     "State":     "CA",
        \\     "Zip":       "94085",
        \\     "Country":   "US"
        \\  }
        \\]
    ,
        "begin_array \nbegin_object \nname precision\nstring zip\nname Latitude\nnumber 37.7668\n" ++
            "name Longitude\nnumber -122.3959\nname Address\nstring \nname City\nstring SAN FRANCISCO\n" ++
            "name State\nstring CA\nname Zip\nstring 94107\nname Country\nstring US\nend_object \n" ++
            "begin_object \nname precision\nstring zip\nname Latitude\nnumber 37.371991\n" ++
            "name Longitude\nnumber -122.026020\nname Address\nstring \nname City\nstring SUNNYVALE\n" ++
            "name State\nstring CA\nname Zip\nstring 94085\nname Country\nstring US\nend_object \n" ++
            "end_array \n",
    );
}

test "RFC 8259 §13's texts of values alone decode, with whitespace around them" {
    try expect_tokens(.text, "\"Hello world!\"", "string Hello world!\n");
    try expect_tokens(.text, "42", "number 42\n");
    try expect_tokens(.text, "true", "true \n");
    try expect_tokens(.text, " \t\r\nnull \t\r\n", "null \n");
    try expect_tokens(.text, "-0.5e-7 ", "number -0.5e-7\n");
    try expect_tokens(.text, "[]", "begin_array \nend_array \n");
    try expect_tokens(.text, "{ }", "begin_object \nend_object \n");
    try expect_tokens(.text, "[[[]],{\"\":[]}]", "begin_array \nbegin_array \nbegin_array \nend_array \nend_array \nbegin_object \nname \nbegin_array \nend_array \nend_object \nend_array \n");
}

test "every escape of RFC 8259 §7 decodes to the character it names, in UTF-8" {
    try expect_tokens(.text, "\"\\\"\\\\\\/\\b\\f\\n\\r\\t\"", "string \"\\/\x08\x0c\n\r\t\n");
    try expect_tokens(.text, "\"\\u0041\\u00e9\\u00E9\\u20AC\\u0000\"", "string A\xc3\xa9\xc3\xa9\xe2\x82\xac\x00\n");
    try expect_tokens(.text, "\"\\uD834\\uDD1E \\ud834\\udd1e\"", "string \xf0\x9d\x84\x9e \xf0\x9d\x84\x9e\n");
    try expect_tokens(.text, "\"\\uDBFF\\uDFFF\\uD800\\uDC00\"", "string \xf4\x8f\xbf\xbf\xf0\x90\x80\x80\n");
    try expect_tokens(.text, "\"caf\xc3\xa9 \xe2\x82\xac \xf0\x9d\x84\x9e \x7f\"", "string caf\xc3\xa9 \xe2\x82\xac \xf0\x9d\x84\x9e \x7f\n");
}

test "an object reports every member, duplicate names included (RFC 8259 §4)" {
    try expect_tokens(.text, "{\"a\":1,\"a\":2}", "begin_object \nname a\nnumber 1\nname a\nnumber 2\nend_object \n");
}

test "a sequence's texts decode one at a time (RFC 7464 §2.1)" {
    try expect_tokens(.sequence, "\x1e{\"n\":7}\n", "begin_object \nname n\nnumber 7\nend_object \n");
    try expect_tokens(.sequence, "\x1e\x1e\x1e7\n", "number 7\n");
    try expect_tokens(.sequence, "\x1e\"s\"", "string s\n");
    try expect_tokens(.sequence, "\x1etrue ", "true \n");
    var storage: [16]u8 = undefined;
    const log = "\x1e{\"n\":1}\n\x1e\x1e[2]\n\x1e\"three\"\n\x1e4\n";
    var reader = text_reader.TextReader.init(log, &storage, .sequence);
    var texts: usize = 0;
    var tokens: usize = 0;
    while (reader.next_text()) : (texts += 1) {
        while (try reader.next()) |_| tokens += 1;
    }
    try testing.expectEqual(4, texts);
    try testing.expectEqual(4 + 3 + 1 + 1, tokens);
    try testing.expectEqual(log.len, reader.consumed_len());
}

test "the whole-buffer reader gives each token's octets, and says when a text or its storage ends" {
    var storage: [8]u8 = undefined;
    var reader = text_reader.TextReader.init("{\"key\":[\"value\",-1.5]}", &storage, .text);
    try testing.expect(reader.next_text());
    try testing.expectEqual(.begin_object, try reader.next());
    try testing.expectEqualStrings("key", (try reader.next()).?.name);
    try testing.expectEqual(.begin_array, try reader.next());
    try testing.expectEqualStrings("value", (try reader.next()).?.string);
    try testing.expectEqualStrings("-1.5", (try reader.next()).?.number);
    try testing.expectEqual(.end_array, try reader.next());
    try testing.expectEqual(.end_object, try reader.next());
    try testing.expectEqual(null, try reader.next());
    try testing.expect(!reader.next_text());

    reader = text_reader.TextReader.init("[\"longer than eight\"]", &storage, .text);
    try testing.expect(reader.next_text());
    try testing.expectEqual(.begin_array, try reader.next());
    try testing.expectError(error.NoSpaceLeft, reader.next());

    reader = text_reader.TextReader.init("{\"a\":", &storage, .text);
    try testing.expect(reader.next_text());
    try testing.expectEqual(.begin_object, try reader.next());
    try testing.expectEqualStrings("a", (try reader.next()).?.name);
    try testing.expectError(error.Truncated, reader.next());
}

test "every cut of a text before its end is truncated, and the whole text is done" {
    const text = "{\"a\":[1,true,\"x\\u00e9\",{}],\"b\":null} ";
    // Every cut before the closing bracket; with it, the text is whole, and the space after it
    // is whitespace the text may end with.
    for (0..text.len - 1) |len| {
        var transcript: Transcript = .{};
        const verdict = decode_whole(.{}, .text, text[0..len], &transcript);
        try testing.expectEqual(Verdict.truncated, verdict);
        _ = try expect_consistent(.text, text[0..len], 20);
    }
    try testing.expectEqual(Verdict.done, try expect_consistent(.text, text[0 .. text.len - 1], split_seeds));
    try testing.expectEqual(Verdict.done, try expect_consistent(.text, text, split_seeds));
}

test "a number at the end of the input ends there only when the input is the text's last" {
    var decoder: Decoder = undefined;
    decoder.init(.text);
    var output: [8]u8 = undefined;
    var progress = try decoder.decode("12", &output, .more);
    try testing.expectEqual(.needs_input, progress.status);
    try testing.expectEqual(.number, progress.kind.?);
    try testing.expectEqualStrings("12", output[0..progress.written]);
    progress = try decoder.decode("3", &output, .more);
    try testing.expectEqualStrings("3", output[0..progress.written]);
    progress = try decoder.decode("", &output, .last);
    try testing.expectEqual(.token, progress.status);
    try testing.expectEqual(.number, progress.kind.?);
    progress = try decoder.decode("", &output, .last);
    try testing.expectEqual(.done, progress.status);
}
