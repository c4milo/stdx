//! Claim J10's loop in place, as `TextReader`'s queue takes it (decision 76): it takes each token
//! as `decoder_file.run` takes it from the same state, a name's, a string's and a number's octets
//! left in the input, and stops at a token it leaves. Into the output, the loop may take a name or
//! a string the loop in place leaves, as it writes the escapes and UTF-8 it holds, but no other
//! token. Past the token the loop in place left, the checked path takes one token, and the loop
//! goes on, to the text's end.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const claims = @import("../../claims.zig");
const Framing = @import("../../framing.zig").Framing;
const decoder_file = @import("../decoder.zig");
const Decoder = decoder_file.Decoder;
const Slot = Decoder.Slot;
const Item = @import("../decoder_batch.zig").Item;
const token_loop = @import("decoder_loop.zig");
const loop_test = @import("decoder_loop_test.zig");
const expect_same_state = @import("../decoder_fast_test.zig").expect_same_state;

/// The room a token's octets have at most, the slots a call fills at most, and the longest of the
/// short rooms, which cut names, strings and numbers.
const room_len_max = 2048;
const slots_max = 16;
const short_room_len_max = 8;

/// A room longer than one block of 16 and shorter than two, which cuts a string the loop in place
/// reads in its second block.
const block_room_len = 20;

/// A room past two blocks of 16 and shorter than the texts' long strings, which cuts a string the
/// loop in place takes outside its walk.
const long_room_len = 40;

/// The seeded corruptions, and the octets each flips at most.
const seeded_cases = 800;
const flips_max = 4;

/// The checked path alone, which takes one token a call.
const checked: claims.Claims = .{ .decoder_fast_path = false, .decoder_token_loop = false };

/// The loop in place with every other claim on, and with every other claim off.
const bases = [_]claims.Claims{ claims.vector, with_loop(claims.scalar) };

fn with_loop(base: claims.Claims) claims.Claims {
    var changed = base;
    changed.decoder_token_loop = true;
    return changed;
}

fn in_place(base: claims.Claims) claims.Claims {
    var changed = base;
    changed.decoder_loop_in_place = true;
    return changed;
}

/// Where a text read through the loop in place stands, beside a decoder on the checked path that
/// reads the same text one token a call.
const Placed = struct {
    decoder: Decoder,
    reference: Decoder,
    input: []const u8,
    consumed: usize = 0,
    reference_consumed: usize = 0,
    room_len: usize,
    count: usize,

    /// One call of the loop in place, held to the checked path and to the loop into the output.
    /// Returns false once the text ended or a token it left stops the read.
    fn call(self: *Placed, comptime base: claims.Claims) !bool {
        if (self.decoder.stage == .done or self.decoder.stage == .refused) return false;
        const before = self.decoder;
        var items: [slots_max]Item = undefined;
        var room: [room_len_max]u8 = undefined;
        var cursor: token_loop.Cursor = .{ .consumed = self.consumed, .written = 0 };
        const filled = token_loop.take_in_place(&self.decoder, in_place(base), self.input, room[0..self.room_len], .last, &cursor, items[0..self.count]);
        try testing.expectEqual(0, cursor.written);
        for (items[0..filled]) |item| try self.expect_reference_token(item);
        try self.expect_stop_at_string(base, &before, filled);
        self.consumed = cursor.consumed;
        if (self.decoder.stage == .done) {
            var writer = codec.Writer.init(room[0..self.room_len]);
            var reader = codec.Reader.init(self.input[self.reference_consumed..]);
            try testing.expectEqual(decoder_file.Status.done, (try decoder_file.run(&self.reference, checked, &reader, &writer, .last)).status);
            self.reference_consumed += reader.consumed();
            try self.expect_same_place();
            return false;
        }
        return self.take_left();
    }

    /// Requires the reference's next token to be `item`, kind for kind and octet for octet, its
    /// octets in the input.
    fn expect_reference_token(self: *Placed, item: Item) !void {
        var room: [room_len_max]u8 = undefined;
        var reader = codec.Reader.init(self.input[self.reference_consumed..]);
        var writer = codec.Writer.init(room[0..self.room_len]);
        const outcome = try decoder_file.run(&self.reference, checked, &reader, &writer, .last);
        self.reference_consumed += reader.consumed();
        try testing.expectEqual(decoder_file.Status.token, outcome.status);
        try testing.expectEqual(outcome.kind.?, std.meta.activeTag(item));
        switch (item) {
            .name, .string, .number => |octets| {
                try testing.expectEqualSlices(u8, room[0..writer.position], octets);
                if (octets.len > 0) try expect_within(self.input, octets);
            },
            else => {},
        }
    }

    /// Requires the loop into the output, from `before`, to take no token past the loop in place's
    /// last but a name or a string.
    fn expect_stop_at_string(self: *const Placed, comptime base: claims.Claims, before: *const Decoder, filled: usize) !void {
        if (filled == self.count or self.decoder.stage == .done) return;
        var written = before.*;
        var slots: [slots_max]Slot = undefined;
        var output: [room_len_max]u8 = undefined;
        var cursor: token_loop.Cursor = .{ .consumed = self.consumed, .written = 0 };
        const written_filled = token_loop.take(&written, base, self.input, output[0..self.room_len], .last, &cursor, slots[0..self.count]);
        if (written_filled <= filled) return;
        try testing.expect(slots[filled].kind == .name or slots[filled].kind == .string);
    }

    /// Takes the token the loop left through the checked path, and the reference's next token,
    /// which must agree in kind, octets, error, state and place. Returns false where the read
    /// stops.
    fn take_left(self: *Placed) !bool {
        var room: [room_len_max]u8 = undefined;
        var reference_room: [room_len_max]u8 = undefined;
        var reader = codec.Reader.init(self.input[self.consumed..]);
        var reference_reader = codec.Reader.init(self.input[self.reference_consumed..]);
        var writer = codec.Writer.init(room[0..self.room_len]);
        var reference_writer = codec.Writer.init(reference_room[0..self.room_len]);
        const result = decoder_file.run(&self.decoder, checked, &reader, &writer, .last);
        const expected = decoder_file.run(&self.reference, checked, &reference_reader, &reference_writer, .last) catch |err| {
            try testing.expectError(err, result);
            return false;
        };
        const outcome = try result;
        try testing.expectEqual(expected, outcome);
        try testing.expectEqualSlices(u8, reference_room[0..reference_writer.position], room[0..writer.position]);
        self.consumed += reader.consumed();
        self.reference_consumed += reference_reader.consumed();
        try self.expect_same_place();
        return outcome.status == .token and self.decoder.open == .none;
    }

    /// Requires the loop's decoder and the reference to stand at one place in one state.
    fn expect_same_place(self: *const Placed) !void {
        try testing.expectEqual(self.reference_consumed, self.consumed);
        try expect_same_state(&self.decoder, &self.reference);
    }
};

/// Requires `octets` to lie inside `outer`.
fn expect_within(outer: []const u8, octets: []const u8) !void {
    try testing.expect(@intFromPtr(octets.ptr) >= @intFromPtr(outer.ptr));
    try testing.expect(@intFromPtr(octets.ptr) + octets.len <= @intFromPtr(outer.ptr) + outer.len);
}

/// Reads `input` through the loop in place with `room_len` octets of room and `count` slots a
/// call, to the text's end or the first token the checked path leaves unfinished.
fn expect_in_place(comptime base: claims.Claims, framing: Framing, input: []const u8, room_len: usize, count: usize) !void {
    var placed: Placed = .{ .decoder = undefined, .reference = undefined, .input = input, .room_len = room_len, .count = count };
    placed.decoder.init(framing, codec.Features.detect());
    placed.reference.init(framing, codec.Features.detect());
    for (0..input.len + 1) |_| {
        if (!try placed.call(base)) return;
    }
    return error.TestNoProgress;
}

/// Requires the property of `input` in both framings, with all the room and `slots_max` slots,
/// and with a short room and fewer slots that `seed` draws.
fn check(input: []const u8, seed: u64) !void {
    inline for (bases) |base| {
        for ([_]Framing{ .text, .sequence }) |framing| {
            try expect_in_place(base, framing, input, room_len_max, slots_max);
            try expect_in_place(base, framing, input, seed % (short_room_len_max + 1), 1 + seed % slots_max);
            try expect_in_place(base, framing, input, block_room_len, slots_max);
            try expect_in_place(base, framing, input, long_room_len, slots_max);
        }
    }
}

test "the loop in place takes each token of the texts as the checked path does" {
    for (loop_test.texts, 0..) |text, index| try check(text, index);
}

test "the loop in place leaves a text's names, strings and numbers in the input, and takes its end" {
    var decoder: Decoder = undefined;
    decoder.init(.sequence, codec.Features.detect());
    const text = "\x1e{\"time\":1234.567,\"name\":\"transport:packet_sent\",\"fin\":false}\n";
    var room: [room_len_max]u8 = @splat(0xaa);
    var items: [slots_max]Item = undefined;
    var cursor: token_loop.Cursor = .{ .consumed = 0, .written = 0 };
    // `{`, three names, three values and `}`.
    try testing.expectEqual(8, token_loop.take_in_place(&decoder, in_place(claims.vector), text, &room, .last, &cursor, &items));
    try testing.expectEqualStrings("1234.567", items[2].number);
    try testing.expectEqualStrings("transport:packet_sent", items[4].string);
    try expect_within(text, items[4].string);
    try testing.expect(decoder.is_done());
    try testing.expectEqual(text.len, cursor.consumed);
    try testing.expect(std.mem.allEqual(u8, &room, 0xaa));
}

test "the loop in place stops at a string of UTF-8 and at one with an escape" {
    inline for (bases) |base| {
        for ([_][]const u8{ "[\"ok\",\"caf\xc3\xa9\"]", "[\"ok\",\"tab\\t\"]" }) |text| {
            var decoder: Decoder = undefined;
            decoder.init(.text, codec.Features.detect());
            var room: [room_len_max]u8 = @splat(0xaa);
            var items: [slots_max]Item = undefined;
            var cursor: token_loop.Cursor = .{ .consumed = 0, .written = 0 };
            // `[` and the first string, up to the second, which the checked path writes.
            try testing.expectEqual(2, token_loop.take_in_place(&decoder, in_place(base), text, &room, .last, &cursor, &items));
            try testing.expectEqualStrings("ok", items[1].string);
            try testing.expect(std.mem.allEqual(u8, &room, 0xaa));
        }
    }
}

test "every seeded corruption of the texts reads alike through the loop in place and the checked path" {
    var input: [room_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.testing.split.Generator.init(seed);
        const text = loop_test.texts[generator.below(loop_test.texts.len)];
        @memcpy(input[0..text.len], text);
        for (0..generator.below(flips_max + 1)) |_| {
            input[generator.below(text.len)] = loop_test.flip_octets[generator.below(loop_test.flip_octets.len)];
        }
        const len = if (generator.below(2) == 0) text.len else generator.below(text.len + 1);
        try check(input[0..len], generator.next());
    }
}

test "fuzz the loop in place against the checked path" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &loop_test.texts });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [room_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    try check(input[0..input_len], smith.value(u64));
}
