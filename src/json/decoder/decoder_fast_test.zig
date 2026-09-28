//! Claim J8's property (decision 30): the fast path takes a token as the checked path takes it, or
//! leaves the call to the checked path. Two decoders, one with the fast path on and one with it
//! off, decode the same input with the same pieces of input and output, and every call must give
//! the same progress, octets and error, and leave the same state. Whole calls take the fast path's
//! common case; seeded splits cut tokens and outputs at every octet, where it must step aside.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const claims = @import("../claims.zig");
const framing_file = @import("../framing.zig");
const Framing = framing_file.Framing;
const Piece = framing_file.Piece;
const decoder_file = @import("decoder.zig");
const Decoder = decoder_file.Decoder;
const decoder_fast = @import("decoder_fast.zig");

/// The largest input one case takes, and the room one call has at most.
const input_len_max = 1024;
const content_len_max = 1024;

/// The seeded cases, the octets each flips at most, and the splits each is decoded under.
const seeded_cases = 1500;
const flips_max = 4;
const split_seeds = 4;

/// Two claims that differ in J8 alone.
const Pair = struct { fast: claims.Claims, checked: claims.Claims };

/// The pairs compared: J8 on and off with every other claim on, then with every other claim off.
const pairs = [_]Pair{
    .{ .fast = claims.vector, .checked = with_fast_path(claims.vector, false) },
    .{ .fast = with_fast_path(claims.scalar, true), .checked = claims.scalar },
};

fn with_fast_path(base: claims.Claims, on: bool) claims.Claims {
    var changed = base;
    changed.decoder_fast_path = on;
    return changed;
}

/// Texts of every token the fast path takes, and of the cases it leaves to the checked path.
const texts = [_][]const u8{
    "{\"a\":[1,-0,2.5e-3,true,false,null,\"x\",{},[]],\"b\":{\"c\":\"\"}}",
    "{\n  \"version\": \"47\",\n  \"list\": [\n    10,\n    -2.25E+2\n  ]\n}\n",
    "\x1e{\"time\":1234.567,\"name\":\"transport:packet_sent\",\"data\":{\"dcid\":\"00ff\",\"fin\":false}}\n",
    "[\"caf\xc3\xa9\",\"tab\\t\",\"\\u00e9\\uD834\\uDD1E\",0,00,1.,-,tru,nul]",
    "[[[[[[[[[[[[[[[[1]]]]]]]]]]]]]]]]",
    " 42 ",
    "\"lone\"",
};

/// The octets a flip writes, weighted toward the ones the grammar turns on.
const flip_octets = "{}[]:,\"\\ \t\n\x1e0-.eEtfnu\x00\x1f\x80\xc3\xff";

/// Requires two decoders to agree in every field a later call reads. The octets of `pending`
/// past `pending_len` are never read.
fn expect_same_state(fast: *const Decoder, checked: *const Decoder) !void {
    try testing.expect(fast.containers.eql(checked.containers));
    inline for (@typeInfo(Decoder).@"struct".fields) |field| {
        const skipped = comptime std.mem.eql(u8, field.name, "containers") or std.mem.eql(u8, field.name, "pending");
        if (!skipped) try testing.expectEqual(@field(checked, field.name), @field(fast, field.name));
    }
    try testing.expectEqualSlices(u8, checked.pending[0..checked.pending_len], fast.pending[0..fast.pending_len]);
}

/// Where a lockstep decode stands.
const Lockstep = struct {
    fast: Decoder,
    checked: Decoder,
    fast_output: [content_len_max]u8 = undefined,
    checked_output: [content_len_max]u8 = undefined,
    consumed: usize = 0,

    /// Makes one call on each decoder with the same pieces. Returns true once the decode ended.
    fn call(self: *Lockstep, comptime pair: Pair, input: []const u8, input_len: usize, room_len: usize) !bool {
        const piece_octets = input[self.consumed..][0..input_len];
        const piece: Piece = if (self.consumed + input_len == input.len) .last else .more;
        const fast_result = self.fast.decode_with(pair.fast, piece_octets, self.fast_output[0..room_len], piece);
        const checked_progress = self.checked.decode_with(pair.checked, piece_octets, self.checked_output[0..room_len], piece) catch |err| {
            try testing.expectError(err, fast_result);
            return true;
        };
        const fast_progress = try fast_result;
        try testing.expectEqual(checked_progress, fast_progress);
        try testing.expectEqualSlices(u8, self.checked_output[0..checked_progress.written], self.fast_output[0..fast_progress.written]);
        try expect_same_state(&self.fast, &self.checked);
        self.consumed += checked_progress.consumed;
        return checked_progress.status == .done or (checked_progress.status == .needs_input and piece == .last);
    }
};

/// Decodes `input` in lockstep, whole when `seed` is null and else under its split.
fn expect_lockstep(comptime pair: Pair, framing: Framing, input: []const u8, seed: ?u64) !void {
    var lockstep: Lockstep = .{ .fast = undefined, .checked = undefined };
    lockstep.fast.init(framing, codec.Features.detect());
    lockstep.checked.init(framing, codec.Features.detect());
    var schedule = codec.split.Schedule.init(seed orelse 0);
    const calls_max = codec.constants.driver_calls_floor + codec.constants.driver_calls_per_octet_max * (input.len + content_len_max);
    for (0..calls_max) |_| {
        const left = input.len - lockstep.consumed;
        const input_len = if (seed == null) left else schedule.piece_len(left);
        const room_len = if (seed == null) content_len_max else schedule.piece_len(content_len_max);
        if (try lockstep.call(pair, input, input_len, room_len)) return;
    }
    return error.TestNoProgress;
}

/// Requires the lockstep property of `input` in both framings, whole and under `split_seeds`
/// splits drawn from `seed`.
fn check(input: []const u8, seed: u64) !void {
    inline for (pairs) |pair| {
        for ([_]Framing{ .text, .sequence }) |framing| {
            try expect_lockstep(pair, framing, input, null);
            for (0..split_seeds) |index| try expect_lockstep(pair, framing, input, seed +% index);
        }
    }
}

test "the fast path takes each token of the texts as the checked path does, whole and split" {
    for (texts, 0..) |text, index| try check(text, index);
}

/// Decodes `text` whole with every claim on, and returns how many of its tokens the fast path
/// took: before each call between tokens, a copy of the decoder tries it.
fn tokens_taken_fast(framing: Framing, text: []const u8) !usize {
    var decoder: Decoder = undefined;
    decoder.init(framing, codec.Features.detect());
    var output: [content_len_max]u8 = undefined;
    var consumed: usize = 0;
    var taken: usize = 0;
    for (0..text.len + 1) |_| {
        if (decoder.stage == .tokens and decoder.open == .none) {
            var copy = decoder;
            var reader = codec.Reader.init(text[consumed..]);
            var writer = codec.Writer.init(&output);
            if (decoder_fast.token(&copy, claims.vector, &reader, &writer) != null) taken += 1;
        }
        const progress = try decoder.decode_with(claims.vector, text[consumed..], &output, .last);
        consumed += progress.consumed;
        if (progress.status == .done) return taken;
    }
    return error.TestNoProgress;
}

test "the fast path takes every token of a text but its first, which follows the text's start" {
    // 21 tokens: every structural character, a name, a string, each literal name and numbers.
    try testing.expectEqual(20, try tokens_taken_fast(.text, texts[0]));
    // 9 tokens, with whitespace before and after each.
    try testing.expectEqual(8, try tokens_taken_fast(.text, texts[1]));
    // 13 tokens, the first after a record separator.
    try testing.expectEqual(12, try tokens_taken_fast(.sequence, texts[2]));
}

test "the fast path steps aside at the depth limit, where the checked path refuses" {
    var input: [constants.depth_max + 2]u8 = undefined;
    @memset(&input, constants.begin_array);
    try check(&input, 0);
}

test "a number and a string that fill the output exactly are taken, and one octet more is not" {
    const cases = [_]struct { text: []const u8, room: usize, taken: bool }{
        .{ .text = "12345,", .room = 5, .taken = true },
        .{ .text = "12345,", .room = 4, .taken = false },
        .{ .text = "\"abcde\",", .room = 5, .taken = true },
        .{ .text = "\"abcde\",", .room = 4, .taken = false },
    };
    for (cases) |case| {
        var decoder: Decoder = undefined;
        decoder.init(.text, codec.Features.detect());
        var output: [content_len_max]u8 = undefined;
        _ = try decoder.decode_with(claims.scalar, "[", &output, .more);
        const before = decoder;
        var reader = codec.Reader.init(case.text);
        var writer = codec.Writer.init(output[0..case.room]);
        const outcome = decoder_fast.token(&decoder, claims.vector, &reader, &writer);
        try testing.expectEqual(case.taken, outcome != null);
        // A token taken leaves the comma that follows it; one left consumes and changes nothing.
        try testing.expectEqual(if (case.taken) case.text.len - 1 else 0, reader.consumed());
        if (!case.taken) try expect_same_state(&decoder, &before);
    }
}

test "every seeded corruption of the texts decodes alike with the fast path on and off" {
    var input: [input_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        const text = texts[generator.below(texts.len)];
        @memcpy(input[0..text.len], text);
        for (0..generator.below(flips_max + 1)) |_| {
            input[generator.below(text.len)] = flip_octets[generator.below(flip_octets.len)];
        }
        const len = if (generator.below(2) == 0) text.len else generator.below(text.len + 1);
        try check(input[0..len], generator.next());
    }
}

test "fuzz the fast path against the checked path" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &texts });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    try check(input[0..input_len], smith.value(u64));
}
