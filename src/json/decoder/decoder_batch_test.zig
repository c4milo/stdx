//! Tests for many tokens a call (decision 33): `decode_batch` gives the tokens, octets and verdict
//! one token a call gives, with every count of slots, whole and under seeded splits of the input
//! and the output that move the state between calls (invariants 5 and 12).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const framing_file = @import("../framing.zig");
const Framing = framing_file.Framing;
const Piece = framing_file.Piece;
const decoder_file = @import("decoder.zig");
const Decoder = decoder_file.Decoder;
const Slot = Decoder.Slot;
const decoder_test = @import("decoder_test.zig");
const Transcript = decoder_test.Transcript;
const Verdict = decoder_test.Verdict;

/// The largest input one case takes, the room one call has at most, and the most octets one token
/// holds.
const input_len_max = 1024;
const output_len_max = 2048;
const content_len_max = 4096;

/// The most slots a batch has. Each input is decoded with one slot a call, as one token a call, with
/// as many as its seed draws, and with this many.
const slots_max = 64;

/// The seeded cases, the octets each flips at most, and the splits each is decoded under.
const seeded_cases = 800;
const flips_max = 4;
const split_seeds = 3;

/// Texts of every kind of token, with escapes, non-ASCII octets, long strings and a sequence.
const texts = [_][]const u8{
    "{\"a\":[1,-0,2.5e-3,true,false,null,\"x\",{},[]],\"b\":{\"c\":\"\"}}",
    "{\n  \"version\": \"47\",\n  \"list\": [\n    10,\n    -2.25E+2\n  ]\n}\n",
    "\x1e{\"time\":1234.567,\"name\":\"transport:packet_sent\",\"data\":{\"dcid\":\"00ff\",\"fin\":false}}\n\x1e[1,2]\n",
    "[\"caf\xc3\xa9\",\"tab\\t\",\"\\u00e9\\uD834\\uDD1E\",\"a long string that runs past two blocks of sixteen octets\"]",
    "[[[[[[[[[[[[[[[[1]]]]]]]]]]]]]]]]",
    " 42 ",
    "\"lone\"",
};

/// The octets a flip writes, weighted toward the ones the grammar turns on.
const flip_octets = "{}[]:,\"\\ \t\n\x1e0-.eEtfnu\x00\x1f\x80\xc3\xff";

/// Where a batched decode stands: the input it has given, and the octets of a token that goes on
/// in the next call.
const BatchDrive = struct {
    input: []const u8,
    transcript: *Transcript,
    consumed: usize = 0,
    open: [content_len_max]u8 = undefined,
    open_len: usize = 0,
    output: [output_len_max]u8 = undefined,

    /// Makes one call with `input_len` octets of input and `room_len` of room. Returns the verdict
    /// once there is one.
    fn call(self: *BatchDrive, decoder: *Decoder, slots: []Slot, input_len: usize, room_len: usize) !?Verdict {
        const input = self.input[self.consumed..][0..input_len];
        const piece: Piece = if (self.consumed + input_len == self.input.len) .last else .more;
        const batch = decoder.decode_batch(input, self.output[0..room_len], piece, slots) catch |err| return .{ .refused = err };
        self.consumed += batch.consumed;
        for (slots[0..batch.filled]) |slot| {
            const octets = self.output[slot.start..][0..slot.len];
            if (self.open_len + octets.len > self.open.len) return error.TestContentFull;
            @memcpy(self.open[self.open_len..][0..octets.len], octets);
            self.open_len += octets.len;
            if (slot.ended) {
                self.transcript.add(slot.kind, self.open[0..self.open_len]);
                self.open_len = 0;
            }
        }
        return switch (batch.status) {
            .done => .done,
            .needs_input => if (piece == .last) .truncated else null,
            .needs_room, .needs_slots => null,
        };
    }
};

/// Decodes `input` in batches of `slots`, whole when `seed` is null and else in the pieces its
/// schedule draws, with the state moved to the other slot at drawn calls.
fn decode_batches(framing: Framing, input: []const u8, slots: []Slot, seed: ?u64, transcript: *Transcript) !Verdict {
    var drive: BatchDrive = .{ .input = input, .transcript = transcript };
    var states: [codec.split.state_slots]Decoder = undefined;
    states[0].init(framing, codec.Features.detect());
    var slot: usize = 0;
    var schedule = codec.split.Schedule.init(seed orelse 0);
    const calls_max = codec.constants.driver_calls_floor + codec.constants.driver_calls_per_octet_max * (input.len + content_len_max);
    for (0..calls_max) |call| {
        const left = input.len - drive.consumed;
        const input_len = if (seed == null) left else schedule.piece_len(left);
        const room_len = if (seed == null) output_len_max else schedule.piece_len(output_len_max);
        if (seed != null and call > 0 and schedule.move_state()) slot = move(&states, slot);
        if (try drive.call(&states[slot], slots, input_len, room_len)) |verdict| return verdict;
    }
    return error.TestNoProgress;
}

fn move(states: *[codec.split.state_slots]Decoder, slot: usize) usize {
    const other = 1 - slot;
    states[other] = states[slot];
    @memset(std.mem.asBytes(&states[slot]), codec.constants.moved_state_fill);
    return other;
}

/// Requires every count of slots to give what one token a call gives for `input`, in both
/// framings, whole and under `split_seeds` splits drawn from `seed`.
fn check(input: []const u8, seed: u64) !void {
    var storage: [slots_max]Slot = undefined;
    for ([_]Framing{ .text, .sequence }) |framing| {
        var expected: Transcript = .{};
        const verdict = decoder_test.decode_whole(.{}, framing, input, &expected);
        for ([_]usize{ 1, 1 + seed % slots_max, slots_max }) |count| {
            for (0..split_seeds + 1) |index| {
                var transcript: Transcript = .{};
                const split: ?u64 = if (index == 0) null else seed +% index;
                try testing.expectEqual(verdict, try decode_batches(framing, input, storage[0..count], split, &transcript));
                try expect_transcript(verdict, count, expected.slice(), transcript.slice());
            }
        }
    }
}

/// Requires a batched transcript to be one token a call's. A refused text fails the batch that
/// meets the refusal, whose tokens are not reported (decision 33): so the batched transcript is a
/// start of one token a call's, and all of it with one slot a call.
fn expect_transcript(verdict: Verdict, count: usize, expected: []const u8, found: []const u8) !void {
    if (verdict == .refused and count > 1) {
        try testing.expect(std.mem.startsWith(u8, expected, found));
    } else {
        try testing.expectEqualStrings(expected, found);
    }
}

test "a batch of every size decodes each text as one token a call does, whole and split" {
    for (texts, 0..) |text, index| try check(text, index);
}

test "a batch fills its slots in order and stops at the text's end, the input's and the slots'" {
    var decoder: Decoder = undefined;
    decoder.init(.text, codec.Features.detect());
    var output: [output_len_max]u8 = undefined;
    var slots: [3]Slot = undefined;
    const text = "[\"ab\",12,true,\"cd\"]";
    var batch = try decoder.decode_batch(text, &output, .last, &slots);
    // `[`, "ab" and 12 take the first 8 octets: the comma after 12 ends it, and stays unread.
    try testing.expectEqual(Decoder.Batch{ .consumed = 8, .written = 4, .filled = 3, .status = .needs_slots }, batch);
    try testing.expectEqualStrings("ab", output[slots[1].start..][0..slots[1].len]);
    try testing.expectEqualStrings("12", output[slots[2].start..][0..slots[2].len]);
    batch = try decoder.decode_batch(text[8..], &output, .last, &slots);
    try testing.expectEqual(Decoder.Batch{ .consumed = 11, .written = 2, .filled = 3, .status = .needs_slots }, batch);
    try testing.expectEqual(decoder_file.Kind.true, slots[0].kind);
    batch = try decoder.decode_batch(text[19..], &output, .last, &slots);
    try testing.expectEqual(Decoder.Batch{ .consumed = 0, .written = 0, .filled = 0, .status = .done }, batch);
}

test "a batch that runs out of room inside a string ends on a slot that did not end" {
    var decoder: Decoder = undefined;
    decoder.init(.text, codec.Features.detect());
    var output: [3]u8 = undefined;
    var slots: [4]Slot = undefined;
    const text = "[\"abcde\"]";
    const batch = try decoder.decode_batch(text, &output, .last, &slots);
    try testing.expectEqual(.needs_room, batch.status);
    try testing.expectEqual(2, batch.filled);
    try testing.expect(!slots[1].ended);
    try testing.expectEqualStrings("abc", output[slots[1].start..][0..slots[1].len]);
}

test "a batch that meets a refusal fails, and leaves the decoder refused" {
    var decoder: Decoder = undefined;
    decoder.init(.text, codec.Features.detect());
    var output: [output_len_max]u8 = undefined;
    var slots: [4]Slot = undefined;
    try testing.expectError(error.ExpectedValueSeparator, decoder.decode_batch("[1 2]", &output, .last, &slots));
    try testing.expectEqual(.refused, decoder.stage);
}

test "every seeded corruption of the texts decodes alike in batches" {
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

test "fuzz batches against one token a call" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &texts });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    try check(input[0..input_len], smith.value(u64));
}
