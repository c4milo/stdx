//! `TextWriter.empty_object` and `empty_array` against the checked path (decision 82): one call
//! writes the octets, the error and the state that the checked path writes for the container's
//! opening and its end, at every place a value goes, in both framings and in every room.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const claims = @import("../claims.zig");
const constants = @import("../constants.zig");
const Framing = @import("../framing.zig").Framing;
const Encoder = @import("encoder.zig").Encoder;
const TextWriter = @import("text_writer.zig").TextWriter;
const encoder_test = @import("encoder_test.zig");
const Item = encoder_test.Item;
const with = encoder_test.with;
const expect_same_state = @import("encoder_fast_test.zig").expect_same_state;
const call = @import("text_writer_test.zig").call;
const round_trip = @import("../round_trip_test.zig");

/// The most octets a list of tokens writes.
const text_len_max = 8192;

/// The seeded lists, and the shorter rooms each is written into.
const seeded_cases = 300;
const short_rooms = 3;

/// The checked path alone.
const checked: claims.Claims = .{ .encoder_token_entry = false, .encoder_fast_path = false, .encoder_token_loop = false };

/// The tokens of an empty container: its opening and its end.
const pair_len = 2;

/// The tokens at the start of `items` that one call writes: an empty container's opening and its
/// end, or one token.
fn group_len(items: []const Item) usize {
    if (items.len < pair_len) return 1;
    const object = items[0].token == .begin_object and items[1].token == .end_object;
    const array = items[0].token == .begin_array and items[1].token == .end_array;
    return if (object or array) pair_len else 1;
}

/// Writes `group` through one call of `text`: an empty container through its own method.
fn call_group(text: *TextWriter, group: []const Item) TextWriter.Error!void {
    if (group.len == 1) return call(text, group[0]);
    return if (group[0].token == .begin_object) text.empty_object() else text.empty_array();
}

/// How the checked path took a group's tokens.
const Verdict = enum { took, done, needs_room };

fn encode_group(reference: *Encoder, group: []const Item, output: []u8, written: *usize) !Verdict {
    var verdict: Verdict = .took;
    for (group) |item| {
        const progress = try reference.encode_with(checked, item.token, item.octets, output[written.*..]);
        written.* += progress.written;
        if (progress.status == .needs_room) return .needs_room;
        if (progress.status == .done) verdict = .done;
    }
    return verdict;
}

/// `expect_same_state`, with the container stack compared below the depth alone. Bit `d` stands
/// for the container at depth `d + 1`, and a later call writes that bit before any call reads
/// it, so an empty container in one call writes none.
fn expect_same_reading(text: *const Encoder, reference: *const Encoder) !void {
    for (0..reference.depth) |index| try testing.expectEqual(reference.containers.is_object(index), text.containers.is_object(index));
    var masked = reference.*;
    masked.containers = text.containers;
    try expect_same_state(text, &masked);
}

/// Writes `items` through the methods, each empty container in one call, and through the checked
/// path, each into `room_len` octets, and requires both to agree after every call. Returns the
/// octets a text that ended wrote, or null when both stopped at the same error.
fn expect_empty(framing: Framing, items: []const Item, room_len: usize) !?usize {
    var output: [text_len_max]u8 = undefined;
    var reference_output: [text_len_max]u8 = undefined;
    var text = TextWriter.init(output[0..room_len], framing, codec.Features.detect());
    var reference: Encoder = undefined;
    reference.init(framing, codec.Features.detect());
    var written: usize = 0;
    var index: usize = 0;
    for (0..items.len) |_| {
        if (index == items.len) break;
        const group = items[index..][0..group_len(items[index..])];
        index += group.len;
        const result = call_group(&text, group);
        const verdict = encode_group(&reference, group, reference_output[0..room_len], &written) catch |err| {
            try testing.expectError(err, result);
            return null;
        };
        try testing.expectEqualSlices(u8, reference_output[0..written], output[0..text.len]);
        if (verdict == .needs_room) {
            try testing.expectError(error.NoSpaceLeft, result);
            return null;
        }
        try result;
        try expect_same_reading(&text.encoder, &reference);
        if (verdict == .done) return written;
    }
    return written;
}

/// Requires the property of `items` in both framings: with all the room, and with `short_rooms`
/// rooms that `seed` draws below the text's length.
fn check(items: []const Item, seed: u64) !void {
    var generator = codec.testing.split.Generator.init(seed);
    for ([_]Framing{ .text, .sequence }) |framing| {
        const whole = try expect_empty(framing, items, text_len_max) orelse continue;
        for (0..short_rooms) |_| {
            if (whole == 0) break;
            _ = try expect_empty(framing, items, generator.below(whole));
        }
    }
}

const begin_object: Item = .{ .token = .begin_object };
const end_object: Item = .{ .token = .end_object };
const begin_array: Item = .{ .token = .begin_array };
const end_array: Item = .{ .token = .end_array };

test "an empty container in one call writes what its opening and its end write, at every place" {
    const texts = [_][]const Item{
        &.{ begin_object, end_object },
        &.{ begin_array, end_array },
        &.{ begin_array, begin_object, end_object, begin_array, end_array, begin_object, end_object, end_array },
        &.{ begin_object, with(.name, "a"), begin_object, end_object, with(.name, "b"), begin_array, end_array, end_object },
        &.{ begin_array, begin_array, begin_array, end_array, end_array, with(.string, "x"), begin_object, end_object, end_array },
    };
    for (texts, 0..) |items, seed| {
        try check(items, seed);
        // Every room shorter than the text ends in `error.NoSpaceLeft`, with the checked path's octets.
        const whole = (try expect_empty(.text, items, text_len_max)).?;
        for (0..whole) |room_len| try testing.expectEqual(null, try expect_empty(.text, items, room_len));
    }
}

test "an empty container at the depth limit is refused as its opening is" {
    var output: [3 * constants.depth_max]u8 = undefined;
    inline for (.{ "empty_object", "empty_array" }) |method| {
        var text = TextWriter.init(&output, .text, codec.Features.detect());
        for (0..constants.depth_max) |_| try text.begin_array();
        var reference = TextWriter.init(&output, .text, codec.Features.detect());
        for (0..constants.depth_max) |_| try reference.begin_array();
        const opened = if (comptime std.mem.eql(u8, method, "empty_object")) reference.begin_object() else reference.begin_array();
        if (opened) |_| return error.TestUnexpectedResult else |refusal| try testing.expectError(refusal, @field(TextWriter, method)(&text));
    }
}

test "seeded lists of tokens write alike with each empty container in one call" {
    for (0..seeded_cases) |seed| {
        var generator = codec.testing.split.Generator.init(seed);
        var program: round_trip.Program = .{};
        round_trip.Draw.value(&generator, &program, 0);
        try check(program.items[0..program.count], generator.next());
    }
}

test "fuzz TextWriter's empty containers against the checked path" {
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
