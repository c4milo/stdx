//! `TextReader.next_items` hands out the tokens `next` hands out (decision 79). Two readers read
//! the same input, one a token a call and one a slice a call, each with a storage of its own. They
//! must give the same tokens in the same order, stop at the same error, find the same texts and
//! consume the same octets. A slice holds a token at least, and each token's octets lie where
//! decisions 74 and 76 place them.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const Framing = @import("../framing.zig").Framing;
const TextReader = @import("text_reader.zig").TextReader;
const reader_test = @import("text_reader_test.zig");

/// The longest text a test reads, and the most octets a token writes.
const input_len_max = 256;
const content_len_max = 1024;

/// The seeded corruptions, and the octets each may change.
const seeded_cases = 1500;
const flips_max = 4;

/// The shorter storages each text is read into: every length that cuts a short token, one that
/// cuts a string in the queue's second block of 16, and one that cuts a string past two blocks.
const short_room_len_max = 8;
const block_room_len = 20;
const long_room_len = 40;

/// Reads one text through `one.next` and through `many.next_items`. Returns true when both read
/// it to its end, and false when both stopped at the same error.
fn expect_text(one: *TextReader, many: *TextReader, input_len: usize) !bool {
    var after: usize = many.consumed_len();
    // A call hands out a token at least, or ends the text. A text holds no more tokens than
    // octets, so one call more than its octets reaches its end.
    for (0..input_len + 1) |_| {
        const items = many.next_items() catch |err| {
            try testing.expectError(err, one.next());
            return false;
        } orelse {
            try testing.expectEqual(null, try one.next());
            try testing.expectEqual(one.consumed_len(), many.consumed_len());
            return true;
        };
        try testing.expect(items.len > 0);
        for (items) |got| {
            const expected = (try one.next()) orelse return error.TestUnexpectedResult;
            try reader_test.expect_same_item(expected, got);
            try reader_test.expect_placed(many, &after, got);
        }
    }
    return error.TestNoProgress;
}

/// Reads the texts of `input` both ways, each with `room_len` octets of storage.
fn expect_items(framing: Framing, input: []const u8, room_len: usize) !void {
    var storage: [content_len_max]u8 = undefined;
    var items_storage: [content_len_max]u8 = undefined;
    var one = TextReader.init(input, storage[0..room_len], framing, codec.Features.detect());
    var many = TextReader.init(input, items_storage[0..room_len], framing, codec.Features.detect());
    // A text takes an octet at least, so one call more than the input's octets finds none.
    for (0..input.len + 1) |_| {
        const more = one.next_text();
        try testing.expectEqual(more, many.next_text());
        if (!more) return;
        if (!try expect_text(&one, &many, input.len)) return;
    }
    return error.TestNoProgress;
}

/// Requires the property of `input` with all the storage and with each shorter one.
fn check(framing: Framing, input: []const u8) !void {
    try expect_items(framing, input, content_len_max);
    for (0..short_room_len_max + 1) |room_len| try expect_items(framing, input, room_len);
    try expect_items(framing, input, block_room_len);
    try expect_items(framing, input, long_room_len);
}

test "next_items gives the tokens next gives, of the texts and of the sequences" {
    for (reader_test.texts) |text| {
        try check(.text, text);
        try check(.sequence, text);
    }
    for (reader_test.sequences) |sequence| {
        try check(.sequence, sequence);
        try check(.text, sequence);
    }
}

test "next_items hands out a queue of several tokens in one slice, then null" {
    var storage: [content_len_max]u8 = undefined;
    var reader = TextReader.init("[1,2,3]", &storage, .text, codec.Features.detect());
    try testing.expect(reader.next_text());
    const items = (try reader.next_items()).?;
    try testing.expectEqual(5, items.len);
    try testing.expectEqualStrings("3", items[3].number);
    try testing.expectEqual(null, try reader.next_items());
    try testing.expect(!reader.next_text());
}

test "next_items hands out what next left in the queue, and hands it out once" {
    var storage: [content_len_max]u8 = undefined;
    var reader = TextReader.init("[1,2,3]", &storage, .text, codec.Features.detect());
    try testing.expect(reader.next_text());
    try testing.expectEqual(.begin_array, std.meta.activeTag((try reader.next()).?));
    const items = (try reader.next_items()).?;
    try testing.expectEqual(4, items.len);
    try testing.expectEqualStrings("1", items[0].number);
    try testing.expectEqual(null, try reader.next_items());
}

test "next reads on after next_items handed out a token the queue's loop left" {
    var storage: [content_len_max]u8 = undefined;
    // The escape leaves the first string to the checked path, whose octets go to the storage.
    var reader = TextReader.init("[\"\\n\",7]", &storage, .text, codec.Features.detect());
    try testing.expect(reader.next_text());
    try testing.expectEqual(.begin_array, std.meta.activeTag((try reader.next_items()).?[0]));
    const left = (try reader.next_items()).?;
    try testing.expectEqual(1, left.len);
    try testing.expectEqualStrings("\n", left[0].string);
    try testing.expectEqual(@intFromPtr(&storage), @intFromPtr(left[0].string.ptr));
    // A copy made now holds no token of the storage to hand out again.
    var copy = reader;
    try testing.expectEqualStrings("7", (try copy.next()).?.number);
    try testing.expectEqualStrings("7", (try reader.next()).?.number);
    try testing.expectEqual(.end_array, std.meta.activeTag((try reader.next_items()).?[0]));
    try testing.expectEqual(null, try reader.next_items());
}

test "every seeded corruption of the texts reads alike through next and next_items" {
    var input: [input_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.testing.split.Generator.init(seed);
        const framing: Framing = if (generator.below(2) == 0) .text else .sequence;
        const text = if (framing == .text) reader_test.texts[generator.below(reader_test.texts.len)] else reader_test.sequences[generator.below(reader_test.sequences.len)];
        @memcpy(input[0..text.len], text);
        for (0..generator.below(flips_max + 1)) |_| {
            if (text.len > 0) input[generator.below(text.len)] = reader_test.flip_octets[generator.below(reader_test.flip_octets.len)];
        }
        const len = if (generator.below(2) == 0) text.len else generator.below(text.len + 1);
        try check(framing, input[0..len]);
    }
}

test "fuzz next_items against next" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &reader_test.texts });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    const framing: Framing = if (smith.value(u64) & 1 == 1) .sequence else .text;
    try check(framing, input[0..input_len]);
}
