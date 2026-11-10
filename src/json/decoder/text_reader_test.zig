//! `TextReader.next`'s property (decision 69): it gives each token as the streaming call on the
//! checked path gives it. `next` takes claim J8's straight line itself, with no pass through
//! `Decoder.decode`, so a `TextReader` and a decoder on the checked path read the same texts, and
//! after every token the kind, the octets, the error, the octets consumed and the state must agree.
//! A storage shorter than a token's octets shows `next` steps aside for `error.NoSpaceLeft`.

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
const texts = [_][]const u8{
    "{\"a\":[1,-0,2.5e-3,true,false,null,\"x\",{},[]],\"b\":{\"c\":\"\"}}",
    "{\n  \"version\": \"47\",\n  \"list\": [\n    10,\n    -2.25E+2\n  ]\n}\n",
    "{\"time\":1234.567,\"name\":\"transport:packet_sent\",\"data\":{\"dcid\":\"00ff\",\"fin\":false}}",
    "[\"caf\xc3\xa9\",\"tab\\t\",\"\\u00e9\\uD834\\uDD1E\",0,00,1.,-,tru,nul]",
    "[[[[[[[[[[[[[[[[1]]]]]]]]]]]]]]]]",
    " 42 ",
    "\"lone\"",
};

/// The octets a flip writes, weighted toward the ones the grammar turns on.
const flip_octets = "{}[]:,\"\\ \t\n\x1e0-.eEtfnu\x00\x1f\x80\xc3\xff";

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

fn expect_same_item(expected: TextReader.Item, got: TextReader.Item) !void {
    try testing.expectEqual(std.meta.activeTag(expected), std.meta.activeTag(got));
    switch (expected) {
        .name => |octets| try testing.expectEqualSlices(u8, octets, got.name),
        .string => |octets| try testing.expectEqualSlices(u8, octets, got.string),
        .number => |octets| try testing.expectEqualSlices(u8, octets, got.number),
        else => {},
    }
}

/// Reads the one text of `input` through `next` and through the checked path's call, each with
/// `room_len` octets of storage, and requires both to agree after every token.
fn expect_next(input: []const u8, room_len: usize) !void {
    var storage: [content_len_max]u8 = undefined;
    var reference_storage: [content_len_max]u8 = undefined;
    var reader = TextReader.init(input, storage[0..room_len], .text, codec.Features.detect());
    try testing.expect(reader.next_text());
    var reference: Decoder = undefined;
    reference.init(.text, codec.Features.detect());
    var consumed: usize = 0;
    // A call after `error.NoSpaceLeft` goes on inside the token the storage cut, as the streaming
    // call does: `next` must leave it to that call, so the test makes one such call too.
    var room_errors: usize = 0;
    const calls_max = codec.constants.driver_calls_floor + codec.constants.driver_calls_per_octet_max * (input.len + content_len_max);
    for (0..calls_max) |_| {
        const result = reader.next();
        const progress = reference.decode_with(checked, input[consumed..], reference_storage[0..room_len], .last) catch |err| {
            return testing.expectError(err, result);
        };
        consumed += progress.consumed;
        switch (progress.status) {
            .needs_input => return testing.expectError(error.Truncated, result),
            .needs_room => {
                try testing.expectError(error.NoSpaceLeft, result);
                try expect_same_state(&reader.decoder, &reference);
                room_errors += 1;
                if (room_errors == room_errors_max) return;
            },
            .done => {
                try testing.expectEqual(null, try result);
                try testing.expectEqual(consumed, reader.consumed_len());
                return;
            },
            .token => {
                const got = (try result) orelse return error.TestUnexpectedResult;
                try expect_same_item(expected_item(progress, reference_storage[0..progress.written]), got);
                try testing.expectEqual(consumed, reader.consumed_len());
                try expect_same_state(&reader.decoder, &reference);
            },
        }
    }
    return error.TestNoProgress;
}

/// Requires the property of `input` with all the storage, and with rooms `seed` draws from 0 to 8
/// octets, which cut its names, strings and numbers.
fn check(input: []const u8, seed: u64) !void {
    try expect_next(input, content_len_max);
    var generator = codec.testing.split.Generator.init(seed);
    for (0..short_rooms) |_| try expect_next(input, generator.below(short_room_len_max + 1));
}

/// The calls that end in `error.NoSpaceLeft` a read makes before it stops.
const room_errors_max = 2;

/// The shorter storages each text is read into, and the longest of them.
const short_rooms = 3;
const short_room_len_max = 8;

test "next gives each token of the texts as the checked path does" {
    for (texts, 0..) |text, index| try check(text, index);
}

test "every seeded corruption of the texts reads alike through next and the checked path" {
    var input: [input_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.testing.split.Generator.init(seed);
        const text = texts[generator.below(texts.len)];
        @memcpy(input[0..text.len], text);
        for (0..generator.below(flips_max + 1)) |_| {
            input[generator.below(text.len)] = flip_octets[generator.below(flip_octets.len)];
        }
        const len = if (generator.below(2) == 0) text.len else generator.below(text.len + 1);
        try check(input[0..len], generator.next());
    }
}

test "fuzz next against the checked path" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &texts });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    try check(input[0..input_len], smith.value(u64));
}
