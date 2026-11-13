//! `TextReader.next`'s property (decision 69): it gives each token as the streaming call on the
//! checked path gives it. `next` takes claim J10's loop in place and claim J8's straight line
//! itself, with no pass through `Decoder.decode`, so a `TextReader` and a decoder on the checked
//! path read the same texts, and after every token the kind, the octets and the error must agree.
//! The reader's queue takes tokens ahead (decision 76), so its state and the octets it consumed
//! must agree at each text's end and at each error, where its queue is empty.
//! A storage shorter than a token's octets shows `next` steps aside for `error.NoSpaceLeft`.
//! `next_text` takes a text's start where it needs no verdict, so the texts hold starts of both
//! kinds, in a text and in a sequence, and a sequence's texts are read one after another.
//!
//! A token's octets lie in the input, among the octets the reader consumed, past the octets of
//! the token before them, or at the storage's start (decisions 74 and 76). A copy of a reader reads on as the original would, and the original reads
//! on after it as if the copy had never read.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const claims = @import("../claims.zig");
const Framing = @import("../framing.zig").Framing;
const decoder_file = @import("decoder.zig");
const Decoder = decoder_file.Decoder;
const TextReader = @import("text_reader.zig").TextReader;
const expect_same_state = @import("decoder_fast_test.zig").expect_same_state;

/// The longest text a test reads, and the most octets a token writes.
const input_len_max = 256;
const content_len_max = 1024;

/// The seeded corruptions, and the octets each may change.
const seeded_cases = 1500;
const flips_max = 4;

/// The checked path alone: neither claim J8's straight line nor claim J10's loop.
const checked: claims.Claims = .{ .decoder_fast_path = false, .decoder_token_loop = false };

/// Texts of every token the straight line takes, and of the cases it leaves to the checked path.
pub const texts = [_][]const u8{
    "{\"a\":[1,-0,2.5e-3,true,false,null,\"x\",{},[]],\"b\":{\"c\":\"\"}}",
    "{\n  \"version\": \"47\",\n  \"list\": [\n    10,\n    -2.25E+2\n  ]\n}\n",
    "{\"time\":1234.567,\"name\":\"transport:packet_sent\",\"data\":{\"dcid\":\"00ff\",\"fin\":false}}",
    "[\"caf\xc3\xa9\",\"tab\\t\",\"\\u00e9\\uD834\\uDD1E\",0,00,1.,-,tru,nul]",
    "[[[[[[[[[[[[[[[[1]]]]]]]]]]]]]]]]",
    " 42 ",
    "\"lone\"",
    // A byte order mark, whole and cut, which the checked path refuses (RFC 8259 §8.1).
    "\xef\xbb\xbf[1]",
    "\xef[1]",
    "",
};

/// Sequences (RFC 7464): texts after one record separator and after several, a text with none, a
/// separator with no text after it, and a byte order mark after the separator.
pub const sequences = [_][]const u8{
    "\x1e{\"n\":1}\n\x1e\x1e[2]\n\x1e\"three\"\n\x1e4\n",
    "\x1e\x1e\x1e7\n",
    "\x1etrue ",
    "7\n",
    "\x1e1\n\x1e",
    "\x1e\xef\xbb\xbf1\n",
    "\x1e \"caf\xc3\xa9\"\n\x1e{\"a\":\"\\n\"}\n",
};

/// The octets a flip writes, weighted toward the ones the grammar turns on.
pub const flip_octets = "{}[]:,\"\\ \t\n\x1e0-.eEtfnu\x00\x1f\x80\xc3\xef\xff";

/// The kind and the octets of the token the checked path's call gave, as `next` gives them.
fn expected_item(progress: decoder_file.Progress, octets: []const u8) TextReader.Item {
    return switch (progress.kind.?) {
        .begin_object => .begin_object,
        .end_object => .end_object,
        .begin_array => .begin_array,
        .end_array => .end_array,
        .name => .{ .name = octets },
        .string => .{ .string = octets },
        .number => .{ .number = octets },
        .true => .true,
        .false => .false,
        .null => .null,
    };
}

/// A name's, a string's or a number's octets, and none of any other token.
fn octets_of(got: TextReader.Item) []const u8 {
    return switch (got) {
        .name, .string, .number => |octets| octets,
        else => "",
    };
}

/// Requires a token's octets to lie in the input, past `after.*`, the end of the octets of the
/// token before them there, and among the octets the reader consumed; or at the start of the
/// storage (decisions 74 and 76). Moves `after.*` past octets in the input.
pub fn expect_placed(reader: *const TextReader, after: *usize, got: TextReader.Item) !void {
    const octets = octets_of(got);
    if (octets.len == 0) return;
    const start = @intFromPtr(octets.ptr);
    const input = @intFromPtr(reader.input.ptr);
    if (start >= input and start < input + reader.input.len) {
        try testing.expect(start >= input + after.*);
        try testing.expect(start + octets.len <= input + reader.consumed_len());
        after.* = start + octets.len - input;
    } else {
        try testing.expectEqual(@intFromPtr(reader.storage.ptr), start);
    }
}

pub fn expect_same_item(expected: TextReader.Item, got: TextReader.Item) !void {
    try testing.expectEqual(std.meta.activeTag(expected), std.meta.activeTag(got));
    switch (expected) {
        .name => |octets| try testing.expectEqualSlices(u8, octets, got.name),
        .string => |octets| try testing.expectEqualSlices(u8, octets, got.string),
        .number => |octets| try testing.expectEqualSlices(u8, octets, got.number),
        else => {},
    }
}

/// Reads the texts of `input` through `next_text` and `next`, and through the checked path's
/// call, each with `room_len` octets of storage, and requires both to agree after every token
/// and on how many texts `input` holds.
fn expect_next(framing: Framing, input: []const u8, room_len: usize) !void {
    var storage: [content_len_max]u8 = undefined;
    var reader = TextReader.init(input, storage[0..room_len], framing, codec.Features.detect());
    var reference: Decoder = undefined;
    var consumed: usize = 0;
    // A text takes an octet at least, so `input` holds no more texts than octets, and one call
    // more finds none.
    for (0..input.len + 1) |index| {
        const more = if (framing == .text) index == 0 else consumed < input.len;
        try testing.expectEqual(more, reader.next_text());
        if (!more) return;
        reference.init(framing, codec.Features.detect());
        if (!try expect_text(&reader, &reference, input, &consumed, room_len)) return;
    }
    return error.TestNoProgress;
}

/// Reads one text through `next` and through `reference`, from `consumed.*`. Returns true when
/// both read it to its end, and false when both stopped at the same error.
fn expect_text(reader: *TextReader, reference: *Decoder, input: []const u8, consumed: *usize, room_len: usize) !bool {
    var reference_storage: [content_len_max]u8 = undefined;
    // A call after `error.NoSpaceLeft` goes on inside the token the storage cut, as the streaming
    // call does: `next` must leave it to that call, so the test makes one such call too.
    var room_errors: usize = 0;
    const calls_max = codec.constants.driver_calls_floor + codec.constants.driver_calls_per_octet_max * (input.len + content_len_max);
    var after: usize = consumed.*;
    for (0..calls_max) |_| {
        const result = reader.next();
        const progress = reference.decode_with(checked, input[consumed.*..], reference_storage[0..room_len], .last) catch |err| {
            try testing.expectError(err, result);
            try expect_same_state(&reader.decoder, reference);
            return false;
        };
        consumed.* += progress.consumed;
        switch (progress.status) {
            .needs_input => {
                try testing.expectError(error.Truncated, result);
                return false;
            },
            .needs_room => {
                try testing.expectError(error.NoSpaceLeft, result);
                try expect_same_state(&reader.decoder, reference);
                room_errors += 1;
                if (room_errors == room_errors_max) return false;
            },
            .done => {
                try testing.expectEqual(null, try result);
                try testing.expectEqual(consumed.*, reader.consumed_len());
                try expect_same_state(&reader.decoder, reference);
                return true;
            },
            .token => {
                const got = (try result) orelse return error.TestUnexpectedResult;
                try expect_same_item(expected_item(progress, reference_storage[0..progress.written]), got);
                try expect_placed(reader, &after, got);
            },
        }
    }
    return error.TestNoProgress;
}

/// Requires the property of `input` with all the storage, and with rooms `seed` draws from 0 to 8
/// octets, which cut its names, strings and numbers.
fn check(framing: Framing, input: []const u8, seed: u64) !void {
    try expect_next(framing, input, content_len_max);
    var generator = codec.testing.split.Generator.init(seed);
    for (0..short_rooms) |_| try expect_next(framing, input, generator.below(short_room_len_max + 1));
    try expect_next(framing, input, block_room_len);
}

/// The calls that end in `error.NoSpaceLeft` a read makes before it stops.
const room_errors_max = 2;

/// The shorter storages each text is read into, and the longest of them.
const short_rooms = 3;
const short_room_len_max = 8;

/// A storage longer than one block of 16 and shorter than two, which cuts a string the queue's
/// loop reads in its second block (decision 76).
const block_room_len = 20;

test "next gives each token of the texts as the checked path does" {
    for (texts, 0..) |text, index| try check(.text, text, index);
}

test "next gives each token of a sequence's texts as the checked path does (RFC 7464 §2.1)" {
    for (sequences, 0..) |sequence, index| try check(.sequence, sequence, index);
    // A text's octets read as a sequence, and a sequence's as a text: each start is refused.
    for (texts, 0..) |text, index| try check(.sequence, text, index);
    for (sequences, 0..) |sequence, index| try check(.text, sequence, index);
}

/// A start `next_text` takes, with the octets it consumes, or one it leaves to the checked path.
const Start = struct { framing: Framing, input: []const u8, taken: bool, consumed: usize = 0 };

test "next_text takes a text's start where it needs no verdict, and leaves every other start" {
    const starts = [_]Start{
        .{ .framing = .text, .input = "[1]", .taken = true },
        .{ .framing = .text, .input = " 7", .taken = true },
        .{ .framing = .sequence, .input = "\x1e7\n", .taken = true, .consumed = 1 },
        .{ .framing = .sequence, .input = "\x1e\x1e\x1e7\n", .taken = true, .consumed = 3 },
        // No octet, and RFC 8259 §8.1's byte order mark.
        .{ .framing = .text, .input = "", .taken = false },
        .{ .framing = .text, .input = "\xef\xbb\xbf1", .taken = false },
        // RFC 7464 §2.1: no record separator, no text after one, and a mark after one.
        .{ .framing = .sequence, .input = "7\n", .taken = false },
        .{ .framing = .sequence, .input = "\x1e", .taken = false },
        .{ .framing = .sequence, .input = "\x1e\xef\xbb\xbf1\n", .taken = false },
    };
    var storage: [short_room_len_max]u8 = undefined;
    for (starts) |start| {
        var reader = TextReader.init(start.input, &storage, start.framing, codec.Features.detect());
        try testing.expect(reader.next_text());
        try testing.expectEqual(start.taken, reader.decoder.stage == .tokens);
        try testing.expectEqual(start.consumed, reader.consumed_len());
    }
}

/// An octet a test fills a storage with, to show `next` wrote none of it.
const unwritten = 0xaa;

test "next leaves a name, a string or a number in the input where the text holds it as it is" {
    // The first three texts hold no escape and no non-ASCII octet.
    for (texts[0..3]) |text| {
        var storage: [content_len_max]u8 = @splat(unwritten);
        var reader = TextReader.init(text, &storage, .text, codec.Features.detect());
        try testing.expect(reader.next_text());
        var placed: usize = 0;
        for (0..text.len) |_| {
            const octets = octets_of(try reader.next() orelse break);
            if (octets.len == 0) continue;
            try testing.expect(@intFromPtr(octets.ptr) >= @intFromPtr(text.ptr));
            try testing.expect(@intFromPtr(octets.ptr) + octets.len <= @intFromPtr(text.ptr) + text.len);
            placed += 1;
        }
        try testing.expect(placed > 0);
        try testing.expect(std.mem.allEqual(u8, &storage, unwritten));
    }
    // An escape changes a string's octets, so they go into the storage.
    var storage: [content_len_max]u8 = undefined;
    var reader = TextReader.init("[\"tab\\t\"]", &storage, .text, codec.Features.detect());
    try testing.expect(reader.next_text());
    try testing.expectEqual(.begin_array, std.meta.activeTag((try reader.next()).?));
    const changed = (try reader.next()).?.string;
    try testing.expectEqualStrings("tab\t", changed);
    try testing.expectEqual(@intFromPtr(&storage), @intFromPtr(changed.ptr));
}

/// What one call of `next` gave, kept past the next call: a token's kind and octets, a text's end,
/// or an error.
const Entry = struct {
    result: TextReader.Error!?decoder_file.Kind,
    octets: [entry_octets_max]u8 = undefined,
    len: usize = 0,
};

/// The most octets of one token an entry keeps, and the most entries one read keeps.
const entry_octets_max = 32;
const entries_max = 64;

/// Reads to the current text's end or to an error, and returns how many entries it kept.
fn read_on(reader: *TextReader, entries: *[entries_max]Entry) usize {
    for (entries, 1..) |*entry, count| {
        const result = reader.next();
        const got = result catch |err| {
            entry.* = .{ .result = err };
            return count;
        };
        const item = got orelse {
            entry.* = .{ .result = null };
            return count;
        };
        const octets = octets_of(item);
        entry.* = .{ .result = std.meta.activeTag(item), .len = octets.len };
        @memcpy(entry.octets[0..octets.len], octets);
    }
    return entries.len;
}

fn expect_entries(expected: []const Entry, got: []const Entry) !void {
    try testing.expectEqual(expected.len, got.len);
    for (expected, got) |want, have| {
        try testing.expectEqual(want.result, have.result);
        try testing.expectEqualSlices(u8, want.octets[0..want.len], have.octets[0..have.len]);
    }
}

/// Requires a copy of a reader that stands `ahead` tokens into `text` to read the rest of it as
/// `expected` holds, and the original to read the same after the copy did.
fn expect_copy_reads_ahead(text: []const u8, ahead: usize, expected: []const Entry) !void {
    var storage: [content_len_max]u8 = undefined;
    var reader = TextReader.init(text, &storage, .text, codec.Features.detect());
    try testing.expect(reader.next_text());
    var got: [entries_max]Entry = undefined;
    for (0..ahead) |_| _ = try reader.next();
    var copy = reader;
    try expect_entries(expected[ahead..], got[0..read_on(&copy, &got)]);
    try expect_entries(expected[ahead..], got[0..read_on(&reader, &got)]);
    try testing.expectEqual(copy.consumed_len(), reader.consumed_len());
}

test "a copy of a reader reads ahead, and the original reads on as if the copy had not" {
    for (texts) |text| {
        var storage: [content_len_max]u8 = undefined;
        var whole = TextReader.init(text, &storage, .text, codec.Features.detect());
        try testing.expect(whole.next_text());
        var expected: [entries_max]Entry = undefined;
        const count = read_on(&whole, &expected);
        for (0..count) |ahead| try expect_copy_reads_ahead(text, ahead, expected[0..count]);
    }
}

test "every seeded corruption of the texts reads alike through next and the checked path" {
    var input: [input_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.testing.split.Generator.init(seed);
        const framing: Framing = if (generator.below(2) == 0) .text else .sequence;
        const text = if (framing == .text) texts[generator.below(texts.len)] else sequences[generator.below(sequences.len)];
        @memcpy(input[0..text.len], text);
        for (0..generator.below(flips_max + 1)) |_| {
            if (text.len > 0) input[generator.below(text.len)] = flip_octets[generator.below(flip_octets.len)];
        }
        const len = if (generator.below(2) == 0) text.len else generator.below(text.len + 1);
        try check(framing, input[0..len], generator.next());
    }
}

test "fuzz next against the checked path" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &texts });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    const framing: Framing = if (smith.value(u64) & 1 == 1) .sequence else .text;
    try check(framing, input[0..input_len], smith.value(u64));
}
