//! Tests for many tokens a call (decision 33): `encode_batch` writes the octets one token a call
//! writes, or fails as it fails, with every count of items a call, whole and under seeded splits of
//! the output that move the state between calls (invariants 5 and 12).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const Framing = @import("../framing.zig").Framing;
const encoder_file = @import("encoder.zig");
const Encoder = encoder_file.Encoder;
const encoder_test = @import("encoder_test.zig");
const with = encoder_test.with;
const round_trip = @import("../round_trip_test.zig");
const TextWriter = @import("text_writer.zig").TextWriter;

/// The most octets a list of tokens writes, and the most items it holds.
const text_len_max = 8192;
const items_max = 128;

/// The seeded lists, and the splits each is encoded under.
const seeded_cases = 300;
const split_seeds = 3;

/// Where a batched encode stands: the next item, the octets of it already taken, and the output
/// written.
const EncodeDrive = struct {
    items: []const encoder_test.Item,
    output: []u8,
    call_items: [items_max]Encoder.Item = undefined,
    index: usize = 0,
    taken: usize = 0,
    written: usize = 0,

    /// Makes one call with `count` items and `room_len` octets of room. Returns true once the text
    /// ended.
    fn call(self: *EncodeDrive, encoder: *Encoder, count: usize, room_len: usize) !bool {
        for (self.call_items[0..count], self.items[self.index..][0..count]) |*call_item, item| call_item.* = .{ .token = item.token, .octets = item.octets };
        self.call_items[0].octets = self.call_items[0].octets[self.taken..];
        const batch = try encoder.encode_batch(self.call_items[0..count], self.output[self.written..][0..room_len]);
        self.written += batch.written;
        if (batch.status == .done) return true;
        if (batch.items > 0) self.taken = 0;
        self.index += batch.items;
        self.taken += batch.consumed;
        if (self.index == self.items.len) return error.TestTextNotEnded;
        return false;
    }
};

/// Encodes `items` in batches, all of the rest a call with all the room left when `seed` is null,
/// and else as many items and as much room as its schedule draws, with the state moved to the
/// other slot at drawn calls. Returns the octets written.
fn encode_batches(framing: Framing, items: []const encoder_test.Item, output: []u8, seed: ?u64) !usize {
    var drive: EncodeDrive = .{ .items = items, .output = output };
    var states: [codec.split.state_slots]Encoder = undefined;
    states[0].init(framing, codec.Features.detect());
    var slot: usize = 0;
    var schedule = codec.split.Schedule.init(seed orelse 0);
    const calls_max = codec.constants.driver_calls_floor + codec.constants.driver_calls_per_octet_max * output.len;
    for (0..calls_max) |call| {
        const left = items.len - drive.index;
        const count = if (seed == null) left else @max(1, schedule.piece_len(left));
        const room_len = if (seed == null) output.len - drive.written else schedule.piece_len(output.len - drive.written);
        if (seed != null and call > 0 and schedule.move_state()) slot = move(&states, slot);
        if (try drive.call(&states[slot], count, room_len)) return drive.written;
    }
    return error.TestNoProgress;
}

fn move(states: *[codec.split.state_slots]Encoder, slot: usize) usize {
    const other = 1 - slot;
    states[other] = states[slot];
    @memset(std.mem.asBytes(&states[slot]), codec.constants.moved_state_fill);
    return other;
}

/// Requires batches to write what one token a call writes for `items`, or to fail as it fails, in
/// both framings, whole and under `split_seeds` splits drawn from `seed`.
fn check(items: []const encoder_test.Item, seed: u64) !void {
    for ([_]Framing{ .text, .sequence }) |framing| {
        var expected: [text_len_max]u8 = undefined;
        var output: [text_len_max]u8 = undefined;
        const expected_len = encoder_test.encode_whole(.{}, framing, items, &expected) catch |err| {
            try testing.expectError(err, encode_batches(framing, items, &output, null));
            continue;
        };
        for (0..split_seeds + 1) |index| {
            const split: ?u64 = if (index == 0) null else seed +% index;
            const len = try encode_batches(framing, items, output[0..expected_len], split);
            try testing.expectEqualStrings(expected[0..expected_len], output[0..len]);
        }
    }
}

test "batches write a record, and every list with escapes and refusals, as one token a call does" {
    const lists = [_][]const encoder_test.Item{
        &.{ .{ .token = .begin_object }, with(.name, "time"), .{ .token = .{ .decimal = .{ .integer = 1234, .fraction = 567, .fraction_digits = 3 } } }, with(.name, "dcid"), with(.hex, "\x00\xff\x10"), with(.name, "fin"), .{ .token = .{ .boolean = false } }, .{ .token = .end_object } },
        &.{ .{ .token = .begin_array }, with(.string, "tab\t\"quoted\"\\"), with(.string, "caf\xc3\xa9"), with(.number, "2.5e-3"), .{ .token = .null }, .{ .token = .end_array } },
        &.{ .{ .token = .begin_array }, with(.string, "ok"), with(.string, "\xc3("), .{ .token = .end_array } },
        &.{ .{ .token = .begin_array }, with(.number, "1"), with(.number, "01"), .{ .token = .end_array } },
        &.{with(.number, "-0.5")},
    };
    for (lists, 0..) |items, seed| try check(items, seed);
}

test "a batch that fills the output stops inside its item, and the next takes the rest" {
    var encoder: Encoder = undefined;
    encoder.init(.text, codec.Features.detect());
    var output: [16]u8 = undefined;
    const items = [_]Encoder.Item{ .{ .token = .begin_array }, .{ .token = .{ .string = .last }, .octets = "abcdef" }, .{ .token = .end_array } };
    var batch = try encoder.encode_batch(&items, output[0..5]);
    try testing.expectEqual(Encoder.Batch{ .items = 1, .consumed = 3, .written = 5, .status = .needs_room }, batch);
    const rest = [_]Encoder.Item{ .{ .token = .{ .string = .last }, .octets = "def" }, .{ .token = .end_array } };
    batch = try encoder.encode_batch(&rest, output[5..]);
    try testing.expectEqual(Encoder.Batch{ .items = 2, .consumed = 0, .written = 5, .status = .done }, batch);
    try testing.expectEqualStrings("[\"abcdef\"]", output[0..10]);
}

test "a batch that meets a refusal fails, and leaves the encoder refused" {
    var encoder: Encoder = undefined;
    encoder.init(.text, codec.Features.detect());
    var output: [16]u8 = undefined;
    const items = [_]Encoder.Item{ .{ .token = .begin_array }, .{ .token = .{ .number = .last }, .octets = "01" } };
    try testing.expectError(error.InvalidNumber, encoder.encode_batch(&items, &output));
    try testing.expectEqual(.refused, encoder.part);
}

test "TextWriter's write_items writes a record as its one-token calls do, or fails whole" {
    const items = [_]Encoder.Item{ .{ .token = .begin_object }, .{ .token = .{ .name = .last }, .octets = "n" }, .{ .token = .{ .unsigned = 42 } }, .{ .token = .end_object } };
    var buffer: [text_len_max]u8 = undefined;
    var text = TextWriter.init(&buffer, .sequence, codec.Features.detect());
    try text.write_items(&items);
    try testing.expectEqualStrings("\x1e{\"n\":42}\n", text.written());
    var short = TextWriter.init(buffer[0..4], .sequence, codec.Features.detect());
    try testing.expectError(error.NoSpaceLeft, short.write_items(&items));
}

test "seeded lists of tokens encode alike in batches" {
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        var program: round_trip.Program = .{};
        round_trip.Draw.value(&generator, &program, 0);
        try check(program.items[0..program.count], generator.next());
    }
}

test "fuzz batches against one token a call" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "", "\x00\x00\x00\x00", "\x00\x00\x00\x01\x00\x00\x00\x05" } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var octets: [round_trip.storage_len_max]u8 = undefined;
    const len = smith.slice(&octets);
    var choices: round_trip.Choices = .{ .octets = octets[0..len] };
    var program: round_trip.Program = .{};
    round_trip.Draw.value(&choices, &program, 0);
    try check(program.items[0..program.count], smith.value(u64));
}
