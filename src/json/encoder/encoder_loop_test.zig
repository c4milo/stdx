//! Claim J11's property: in a batch, the token loop writes items as `Encoder.run` writes them, or
//! leaves them to it. Two encoders, one with the loop on and one with it off, encode the same items
//! in batches with the same counts of items and the same room, and every batch must give the same
//! counts, octets and error, and leave the same state.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const claims = @import("../claims.zig");
const Framing = @import("../framing.zig").Framing;
const encoder_file = @import("encoder.zig");
const Encoder = encoder_file.Encoder;
const encoder_test = @import("encoder_test.zig");
const encoder_fast_test = @import("encoder_fast_test.zig");
const with = encoder_test.with;
const round_trip = @import("../round_trip_test.zig");
const token_loop = @import("encoder_loop.zig");

/// The most octets a list writes, and the most items it holds.
const text_len_max = 8192;
const items_max = 1100;

/// The seeded lists, and the splits each is encoded under.
const seeded_cases = 300;
const split_seeds = 3;

/// Two claims that differ in J11 alone.
const Pair = struct { looped: claims.Claims, checked: claims.Claims };

/// The pairs compared: J11 on and off with every other claim on, then with every other claim off,
/// and J11's loop as a caller that turns its runtime safety checks off compiles it, which a test
/// build runs with the checks on (decision 35).
const pairs = [_]Pair{
    .{ .looped = claims.vector, .checked = with_loop(claims.vector, false) },
    .{ .looped = with_loop(claims.scalar, true), .checked = claims.scalar },
    .{ .looped = without_runtime_safety(claims.vector), .checked = with_loop(claims.vector, false) },
};

fn without_runtime_safety(base: claims.Claims) claims.Claims {
    var changed = base;
    changed.encoder_token_loop_runtime_safety = false;
    return changed;
}

fn with_loop(base: claims.Claims, on: bool) claims.Claims {
    var changed = base;
    changed.encoder_token_loop = on;
    return changed;
}

/// Where a lockstep encode stands.
const Lockstep = struct {
    looped: Encoder,
    checked: Encoder,
    looped_output: [text_len_max]u8 = undefined,
    checked_output: [text_len_max]u8 = undefined,
    call_items: [items_max]Encoder.Item = undefined,
    index: usize = 0,
    taken: usize = 0,
    written: usize = 0,

    /// Makes one batch on each encoder with `count` items and `room_len` octets of room. Returns
    /// true once the text ended or both refused.
    fn call(self: *Lockstep, comptime pair: Pair, items: []const encoder_test.Item, count: usize, room_len: usize) !bool {
        for (self.call_items[0..count], items[self.index..][0..count]) |*call_item, item| call_item.* = .{ .token = item.token, .octets = item.octets };
        self.call_items[0].octets = self.call_items[0].octets[self.taken..];
        const looped = self.looped.encode_batch_with(pair.looped, self.call_items[0..count], self.looped_output[self.written..][0..room_len]);
        const checked = self.checked.encode_batch_with(pair.checked, self.call_items[0..count], self.checked_output[self.written..][0..room_len]) catch |err| {
            try testing.expectError(err, looped);
            return true;
        };
        const looped_batch = try looped;
        try testing.expectEqual(checked, looped_batch);
        try testing.expectEqualSlices(u8, self.checked_output[self.written..][0..checked.written], self.looped_output[self.written..][0..looped_batch.written]);
        try encoder_fast_test.expect_same_state(&self.looped, &self.checked);
        self.written += checked.written;
        if (checked.status == .done) return true;
        if (checked.items > 0) self.taken = 0;
        self.index += checked.items;
        self.taken += checked.consumed;
        if (self.index == items.len) return error.TestTextNotEnded;
        return false;
    }
};

/// Encodes `items` in lockstep, all of the rest a call with all the room left when `seed` is null,
/// and else as many items and as much room as its schedule draws.
fn expect_lockstep(comptime pair: Pair, framing: Framing, items: []const encoder_test.Item, seed: ?u64) !void {
    var lockstep: Lockstep = .{ .looped = undefined, .checked = undefined };
    lockstep.looped.init(framing, codec.Features.detect());
    lockstep.checked.init(framing, codec.Features.detect());
    var schedule = codec.split.Schedule.init(seed orelse 0);
    const calls_max = codec.constants.driver_calls_floor + codec.constants.driver_calls_per_octet_max * text_len_max;
    for (0..calls_max) |_| {
        const left = items.len - lockstep.index;
        const count = if (seed == null) left else @max(1, schedule.piece_len(left));
        const room_left = text_len_max - lockstep.written;
        const room_len = if (seed == null) room_left else schedule.piece_len(room_left);
        if (try lockstep.call(pair, items, count, room_len)) return;
    }
    return error.TestNoProgress;
}

/// Requires the lockstep property of `items` in both framings, whole and under `split_seeds`
/// splits drawn from `seed`.
fn check(items: []const encoder_test.Item, seed: u64) !void {
    inline for (pairs) |pair| {
        for ([_]Framing{ .text, .sequence }) |framing| {
            try expect_lockstep(pair, framing, items, null);
            for (0..split_seeds) |index| try expect_lockstep(pair, framing, items, seed +% index);
        }
    }
}

test "the loop writes a record, and lists with escapes and refusals, as the checked path does" {
    const lists = [_][]const encoder_test.Item{
        &.{ .{ .token = .begin_object }, with(.name, "time"), .{ .token = .{ .decimal = .{ .integer = 1234, .fraction = 567, .fraction_digits = 3 } } }, with(.name, "a name longer than sixteen"), with(.string, "transport:packet_sent"), with(.name, "dcid"), with(.hex, "\x00\xff\x10"), with(.name, "n"), .{ .token = .{ .signed = -7 } }, with(.name, "fin"), .{ .token = .{ .boolean = false } }, with(.name, "x"), .{ .token = .null }, with(.name, "abc"), with(.number, "2.5e-3"), .{ .token = .end_object } },
        &.{ .{ .token = .begin_array }, with(.string, "tab\t\"quoted\"\\"), with(.string, "caf\xc3\xa9"), with(.number, "2.5e-3"), .{ .token = .null }, .{ .token = .end_array } },
        &.{ .{ .token = .begin_array }, with(.string, "ok"), with(.string, "\xc3("), .{ .token = .end_array } },
        &.{ .{ .token = .begin_array }, with(.number, "1"), with(.number, "01"), .{ .token = .end_array } },
        &.{with(.number, "-0.5")},
        // A string, a hex string and a number whose octets come in two items each.
        &.{ .{ .token = .begin_array }, .{ .token = .{ .string = .more }, .octets = "ab" }, with(.string, "cd"), .{ .token = .{ .hex = .more }, .octets = "\x01" }, with(.hex, "\x02"), .{ .token = .{ .number = .more }, .octets = "12" }, with(.number, ".5"), .{ .token = .end_array } },
    };
    for (lists, 0..) |items, seed| try check(items, seed);
}

test "the loop writes every item of a record in one call, into an output of just its octets" {
    const items = [_]Encoder.Item{ .{ .token = .begin_object }, .{ .token = .{ .name = .last }, .octets = "ab" }, .{ .token = .{ .unsigned = 42 } }, .{ .token = .{ .name = .last }, .octets = "list" }, .{ .token = .begin_array }, .{ .token = .{ .boolean = true } }, .{ .token = .end_array }, .{ .token = .end_object } };
    for ([_]Framing{ .text, .sequence }) |framing| {
        var encoder: Encoder = undefined;
        encoder.init(framing, codec.Features.detect());
        const expected = if (framing == .text) "{\"ab\":42,\"list\":[true]}" else "\x1e{\"ab\":42,\"list\":[true]}\n";
        // An output of exactly the record's octets, so the room each item takes is exact too.
        var output: [text_len_max]u8 = undefined;
        var written: usize = 0;
        try testing.expectEqual(items.len, token_loop.take(&encoder, claims.vector, &items, output[0..expected.len], &written));
        try testing.expectEqualStrings(expected, output[0..written]);
        try testing.expect(encoder.is_done());
    }
}

test "the loop writes strings with every escape and with UTF-8 itself, none left to the checked path" {
    const items = [_]Encoder.Item{
        .{ .token = .begin_array },
        .{ .token = .{ .string = .last }, .octets = "a\"b\\c/d\x08\x0c\n\r\t\x00\x1f\x7f" },
        .{ .token = .{ .string = .last }, .octets = "caf\xc3\xa9 \xe2\x82\xac \xf0\x9f\x98\x80" },
        .{ .token = .end_array },
    };
    var encoder: Encoder = undefined;
    encoder.init(.text, codec.Features.detect());
    const expected = "[\"a\\\"b\\\\c/d\\b\\f\\n\\r\\t\\u0000\\u001f\x7f\",\"caf\xc3\xa9 \xe2\x82\xac \xf0\x9f\x98\x80\"]";
    var output: [text_len_max]u8 = undefined;
    var written: usize = 0;
    try testing.expectEqual(items.len, token_loop.take(&encoder, claims.vector, &items, output[0..expected.len], &written));
    try testing.expectEqualStrings(expected, output[0..written]);
    try testing.expect(encoder.is_done());
}

test "the loop writes a string whose ASCII past an escape fills a block before UTF-8 inside the next, none left" {
    const content = "\n0123456789abcdefghij\xc3\xa9\xe2\x82\xac0123456789abcdef";
    const items = [_]Encoder.Item{.{ .token = .{ .string = .last }, .octets = content }};
    var encoder: Encoder = undefined;
    encoder.init(.text, codec.Features.detect());
    const expected = "\"\\n0123456789abcdefghij\xc3\xa9\xe2\x82\xac0123456789abcdef\"";
    var output: [text_len_max]u8 = undefined;
    var written: usize = 0;
    try testing.expectEqual(items.len, token_loop.take(&encoder, claims.vector, &items, output[0..expected.len], &written));
    try testing.expectEqualStrings(expected, output[0..written]);
}

test "the loop writes a string whose blocks of 16 cut characters, none left to the checked path" {
    // Ten characters of three octets and a quotation mark: the first block of 16 ends inside the
    // sixth, and the octets left are fewer than a block, which the walk then takes from that
    // character's start.
    const content = "\xe2\x82\xac" ** 10 ++ "\"";
    const items = [_]Encoder.Item{.{ .token = .{ .string = .last }, .octets = content }};
    var encoder: Encoder = undefined;
    encoder.init(.text, codec.Features.detect());
    const expected = "\"" ++ "\xe2\x82\xac" ** 10 ++ "\\\"\"";
    var output: [text_len_max]u8 = undefined;
    var written: usize = 0;
    try testing.expectEqual(items.len, token_loop.take(&encoder, claims.vector, &items, output[0..expected.len], &written));
    try testing.expectEqualStrings(expected, output[0..written]);
}

/// Strings whose octets UTF-8 rules out where a block of 16 ends or starts (RFC 3629 §4).
const cut_characters_ruled_out = [_][]const u8{
    // The first block ends inside the fifth character. The second holds its last octet, then a
    // quotation mark the loop escapes, then a continuation octet no character's first octet
    // precedes.
    "\xe2\x82\xac\xe2\x82\xac\xe2\x82\xac\xe2\x82\xac" ++ "ab\xe2\x82\xaccdef\"\x80" ++ "\xe2\x82\xac\xe2\x82\xac\xe2\x82\xac\xe2\x82\xac\xe2\x82\xac",
    // The first block ends with a character's first octet, and the second is all ASCII, or starts
    // with a quotation mark the loop escapes.
    "\xc3\xa90123456789abc\xe2" ++ "0123456789abcdef",
    "\xc3\xa90123456789abc\xe2" ++ "\"0123456789abcde",
    // Past an escape, a block of ASCII and then a continuation octet with no first octet.
    "\n0123456789abcdefghij\x80",
};

test "the loop leaves to the checked path the characters that blocks of 16 cut and UTF-8 rules out" {
    for (cut_characters_ruled_out) |content| {
        const items = [_]Encoder.Item{.{ .token = .{ .string = .last }, .octets = content }};
        var encoder: Encoder = undefined;
        encoder.init(.text, codec.Features.detect());
        var output: [text_len_max]u8 = undefined;
        var written: usize = 0;
        try testing.expectEqual(0, token_loop.take(&encoder, claims.vector, &items, &output, &written));
        try testing.expectError(error.InvalidUtf8, encoder.encode_batch(&items, &output));
    }
}

/// How a function starts where decision 35 lets a caller turn its runtime safety checks off: with
/// the caller's field, which a test build and a Debug build override.
const runtime_safety_call = "@setRuntimeSafety(claims.encoder_token_loop_runtime_safety or runtime_safety_kept);";
const runtime_safety_start = "@setRuntimeSafety(";

test "the loop turns its runtime safety checks off only where the caller chose it, and the decoder never" {
    for ([_][]const u8{ @embedFile("encoder_loop.zig"), @embedFile("encoder_loop_string.zig") }) |source| {
        var calls: usize = 0;
        var rest = source;
        for (0..source.len) |_| {
            const at = std.mem.indexOf(u8, rest, runtime_safety_start) orelse break;
            try testing.expect(std.mem.startsWith(u8, rest[at..], runtime_safety_call));
            calls += 1;
            rest = rest[at + runtime_safety_start.len ..];
        }
        try testing.expect(calls > 0);
    }
    // The decoder's loop keeps every check (decision 35).
    for ([_][]const u8{ @embedFile("../decoder/decoder_loop/decoder_loop.zig"), @embedFile("../decoder/decoder_loop/decoder_loop_string.zig"), @embedFile("../string_walk.zig") }) |source| {
        try testing.expect(std.mem.indexOf(u8, source, runtime_safety_start) == null);
    }
}

test "the loop steps aside at the depth limit, where the checked path refuses" {
    const items: [constants.depth_max + 1]encoder_test.Item = @splat(.{ .token = .begin_array });
    try check(&items, 0);
}

test "seeded lists of tokens encode alike with the loop on and off" {
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        var program: round_trip.Program = .{};
        round_trip.Draw.value(&generator, &program, 0);
        try check(program.items[0..program.count], generator.next());
    }
}

test "fuzz the encoder's token loop against its checked path" {
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
