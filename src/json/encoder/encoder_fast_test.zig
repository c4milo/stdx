//! Claim J9's property (decision 30): the fast path writes a token as the checked path writes it,
//! or leaves the call to the checked path. Two encoders, one with the fast path on and one with it
//! off, encode the same tokens with the same pieces of input and output, and every call must give
//! the same progress, octets and error, and leave the same state. Whole calls take the fast path's
//! common case; seeded splits cut tokens and outputs at every octet, where it must step aside.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const claims = @import("../claims.zig");
const Framing = @import("../framing.zig").Framing;
const encoder_file = @import("encoder.zig");
const Encoder = encoder_file.Encoder;
const Token = encoder_file.Token;
const encoder_fast = @import("encoder_fast.zig");
const encoder_test = @import("encoder_test.zig");
const Item = encoder_test.Item;
const with = encoder_test.with;
const round_trip = @import("../round_trip_test.zig");

/// The most octets a list of tokens writes.
const text_len_max = 8192;

/// The seeded lists, and the splits each is encoded under.
const seeded_cases = 400;
const split_seeds = 4;

/// Two claims that differ in J9 alone.
const Pair = struct { fast: claims.Claims, checked: claims.Claims };

/// The pairs compared: J9 on and off with every other claim on, then with every other claim off.
const pairs = [_]Pair{
    .{ .fast = claims.vector, .checked = with_fast_path(claims.vector, false) },
    .{ .fast = with_fast_path(claims.scalar, true), .checked = claims.scalar },
};

fn with_fast_path(base: claims.Claims, on: bool) claims.Claims {
    var changed = base;
    changed.encoder_fast_path = on;
    return changed;
}

/// Tokens the fast path leaves to the checked path: escapes, non-ASCII octets, and refusals.
const escapes = [_]Item{ .{ .token = .begin_array }, with(.string, "tab\t\"quoted\"\\"), with(.string, "caf\xc3\xa9"), .{ .token = .end_array } };
const bad_utf8 = [_]Item{ .{ .token = .begin_array }, with(.string, "ok"), with(.string, "\xc3("), .{ .token = .end_array } };
const bad_number = [_]Item{ .{ .token = .begin_array }, with(.number, "1"), with(.number, "01"), .{ .token = .end_array } };
const lone_number = [_]Item{with(.number, "-0.5")};

/// Requires two encoders to agree in every field a later call reads. The octets of `pending`
/// past `pending_len` are never read.
fn expect_same_state(fast: *const Encoder, checked: *const Encoder) !void {
    try testing.expect(fast.containers.eql(checked.containers));
    inline for (@typeInfo(Encoder).@"struct".fields) |field| {
        const skipped = comptime std.mem.eql(u8, field.name, "containers") or std.mem.eql(u8, field.name, "pending");
        if (!skipped) try testing.expectEqual(@field(checked, field.name), @field(fast, field.name));
    }
    try testing.expectEqualSlices(u8, checked.pending[0..checked.pending_len], fast.pending[0..fast.pending_len]);
}

/// Where a lockstep encode stands.
const Lockstep = struct {
    fast: Encoder,
    checked: Encoder,
    fast_output: [text_len_max]u8 = undefined,
    checked_output: [text_len_max]u8 = undefined,
    written: usize = 0,

    /// Makes one call on each encoder with the same pieces. Returns the progress, or null once both
    /// refused alike.
    fn call(self: *Lockstep, comptime pair: Pair, value: Token, input: []const u8, room_len: usize) !?codec.Progress {
        const fast_room = self.fast_output[self.written..][0..room_len];
        const checked_room = self.checked_output[self.written..][0..room_len];
        const fast_result = self.fast.encode_with(pair.fast, value, input, fast_room);
        const checked_progress = self.checked.encode_with(pair.checked, value, input, checked_room) catch |err| {
            try testing.expectError(err, fast_result);
            return null;
        };
        const fast_progress = try fast_result;
        try testing.expectEqual(checked_progress, fast_progress);
        try testing.expectEqualSlices(u8, checked_room[0..checked_progress.written], fast_room[0..fast_progress.written]);
        try expect_same_state(&self.fast, &self.checked);
        self.written += checked_progress.written;
        return checked_progress;
    }

    /// The room of the next call: all that is left when `split` is false, and else the piece
    /// `schedule` draws.
    fn next_room_len(self: *const Lockstep, schedule: *codec.split.Schedule, split: bool) usize {
        const room_left = text_len_max - self.written;
        return if (split) schedule.piece_len(room_left) else room_left;
    }

    /// Encodes one item's token in the pieces `schedule` draws, or whole when `split` is false.
    /// Returns false once the text ended or both refused.
    fn item_call(self: *Lockstep, comptime pair: Pair, schedule: *codec.split.Schedule, split: bool, item: Item) !bool {
        var consumed: usize = 0;
        const calls_max = codec.constants.driver_calls_floor + codec.constants.driver_calls_per_octet_max * (item.octets.len + text_len_max);
        for (0..calls_max) |_| {
            const left = item.octets.len - consumed;
            const input_len = if (split) schedule.piece_len(left) else left;
            const last = consumed + input_len == item.octets.len;
            const token_piece = encoder_test.piece_token(item.token, last);
            const progress = try self.call(pair, token_piece, item.octets[consumed..][0..input_len], self.next_room_len(schedule, split)) orelse return false;
            consumed += progress.consumed;
            switch (progress.status) {
                .done => return false,
                .needs_input => if (last) return true,
                .needs_room => if (self.written == text_len_max) return error.TestOutputFull,
            }
        }
        return error.TestNoProgress;
    }
};

/// Encodes `items` in lockstep, whole when `seed` is null and else under its split.
fn expect_lockstep(comptime pair: Pair, framing: Framing, items: []const Item, seed: ?u64) !void {
    var lockstep: Lockstep = .{ .fast = undefined, .checked = undefined };
    lockstep.fast.init(framing, codec.Features.detect());
    lockstep.checked.init(framing, codec.Features.detect());
    var schedule = codec.split.Schedule.init(seed orelse 0);
    for (items) |item| {
        if (!try lockstep.item_call(pair, &schedule, seed != null, item)) return;
    }
}

/// Requires the lockstep property of `items` in both framings, whole and under `split_seeds`
/// splits drawn from `seed`.
fn check(items: []const Item, seed: u64) !void {
    inline for (pairs) |pair| {
        for ([_]Framing{ .text, .sequence }) |framing| {
            try expect_lockstep(pair, framing, items, null);
            for (0..split_seeds) |index| try expect_lockstep(pair, framing, items, seed +% index);
        }
    }
}

test "the fast path writes every token of a record, as the checked path does, whole and split" {
    // A record of the qlog-shaped log bench-json times, which the fast path writes whole.
    const record = [_]Item{
        .{ .token = .begin_object },
        with(.name, "time"),
        .{ .token = .{ .decimal = .{ .integer = 1234, .fraction = 567, .fraction_digits = 3 } } },
        with(.name, "name"),
        with(.string, "transport:packet_sent"),
        with(.name, "data"),
        .{ .token = .begin_object },
        with(.name, "dcid"),
        with(.hex, "\x00\xff\x10"),
        with(.name, "packet_number"),
        .{ .token = .{ .unsigned = 42 } },
        with(.name, "delta"),
        .{ .token = .{ .signed = -7 } },
        with(.name, "fin"),
        .{ .token = .{ .boolean = false } },
        with(.name, "gap"),
        .{ .token = .null },
        with(.name, "list"),
        .{ .token = .begin_array },
        with(.number, "2.5e-3"),
        .{ .token = .begin_array },
        .{ .token = .end_array },
        .{ .token = .end_array },
        .{ .token = .end_object },
        .{ .token = .end_object },
    };
    try check(&record, 0);
    for ([_]Framing{ .text, .sequence }) |framing| try testing.expectEqual(record.len, try tokens_written_fast(framing, &record));
}

test "the fast path leaves escapes, non-ASCII octets and refusals to the checked path" {
    for ([_][]const Item{ &escapes, &bad_utf8, &bad_number, &lone_number }, 0..) |items, index| try check(items, index);
    // Of `escapes`, the array's two ends alone.
    for ([_]Framing{ .text, .sequence }) |framing| try testing.expectEqual(2, try tokens_written_fast(framing, &escapes));
}

/// Encodes `items` whole with every claim on, and returns how many of its tokens the fast path
/// wrote: before each call, a copy of the encoder tries it.
fn tokens_written_fast(framing: Framing, items: []const Item) !usize {
    var encoder: Encoder = undefined;
    encoder.init(framing, codec.Features.detect());
    var output: [text_len_max]u8 = undefined;
    var written: usize = 0;
    var taken: usize = 0;
    for (items) |item| {
        var copy = encoder;
        var reader = codec.Reader.init(item.octets);
        var writer = codec.Writer.init(output[written..]);
        if (encoder_fast.token(&copy, claims.vector, item.token, &reader, &writer) != null) taken += 1;
        written += (try encoder.encode_with(claims.vector, item.token, item.octets, output[written..])).written;
    }
    return taken;
}

test "the fast path steps aside at the depth limit, where the checked path refuses" {
    const items: [constants.depth_max + 1]Item = @splat(.{ .token = .begin_array });
    try check(&items, 0);
}

test "a token that fills the output exactly is written, and one octet more is not" {
    const cases = [_]struct { item: Item, room: usize, taken: bool }{
        .{ .item = with(.string, "abc"), .room = 5, .taken = true },
        .{ .item = with(.string, "abc"), .room = 4, .taken = false },
        .{ .item = with(.hex, "\x01\x02"), .room = 6, .taken = true },
        .{ .item = with(.hex, "\x01\x02"), .room = 5, .taken = false },
        .{ .item = .{ .token = .{ .unsigned = 12345 } }, .room = 5, .taken = true },
        .{ .item = .{ .token = .{ .unsigned = 12345 } }, .room = 4, .taken = false },
    };
    for (cases) |case| {
        var encoder: Encoder = undefined;
        encoder.init(.text, codec.Features.detect());
        const before = encoder;
        var output: [text_len_max]u8 = undefined;
        var reader = codec.Reader.init(case.item.octets);
        var writer = codec.Writer.init(output[0..case.room]);
        const status = encoder_fast.token(&encoder, claims.vector, case.item.token, &reader, &writer);
        try testing.expectEqual(case.taken, status != null);
        try testing.expectEqual(if (case.taken) case.room else 0, writer.position);
        if (!case.taken) try expect_same_state(&encoder, &before);
    }
}

test "seeded lists of tokens encode alike with the fast path on and off" {
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        var program: round_trip.Program = .{};
        round_trip.Draw.value(&generator, &program, 0);
        try check(program.items[0..program.count], generator.next());
    }
}

test "fuzz the encoder's fast path against its checked path" {
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
