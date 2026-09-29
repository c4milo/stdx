//! Claim J10's property: in a batch, the token loop takes tokens as `Decoder.run` takes them, or
//! leaves them to it. Two decoders, one with the loop on and one with it off, decode the same input
//! in batches with the same pieces of input and output, and every batch must give the same counts,
//! slots, octets and error, and leave the same state.

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
const Slot = Decoder.Slot;
const token_loop = @import("decoder_loop.zig");
const decoder_fast_test = @import("decoder_fast_test.zig");

/// The largest input one case takes, the room one batch has at most, and the most slots.
const input_len_max = 1024;
const output_len_max = 2048;
const slots_max = 32;

/// The seeded cases, the octets each flips at most, and the splits each is decoded under.
const seeded_cases = 800;
const flips_max = 4;
const split_seeds = 3;

/// Two claims that differ in J10 alone.
const Pair = struct { looped: claims.Claims, checked: claims.Claims };

/// The pairs compared: J10 on and off with every other claim on, then with every other claim off.
const pairs = [_]Pair{
    .{ .looped = claims.vector, .checked = with_loop(claims.vector, false) },
    .{ .looped = with_loop(claims.scalar, true), .checked = claims.scalar },
};

fn with_loop(base: claims.Claims, on: bool) claims.Claims {
    var changed = base;
    changed.decoder_token_loop = on;
    return changed;
}

/// Texts of every token the loop takes, of the cases it leaves, and of long strings.
const texts = [_][]const u8{
    "{\"a\":[1,-0,2.5e-3,true,false,null,\"x\",{},[]],\"b\":{\"c\":\"\"}}                ",
    "{\n  \"version\": \"47\",\n  \"list\": [\n    10,\n    -2.25E+2\n  ]\n}\n",
    "\x1e{\"time\":1234.567,\"name\":\"transport:packet_sent\",\"data\":{\"dcid\":\"00ff\",\"fin\":false}}\n\x1e[1,2]\n",
    "[\"caf\xc3\xa9\",\"tab\\t\",\"\\u00e9\\uD834\\uDD1E\",\"a long string that runs past two blocks of sixteen octets\",0,00,1.,-,tru,nul]",
    "[[[[[[[[[[[[[[[[1]]]]]]]]]]]]]]]]",
    " 42 ",
    // A byte order mark, which the checked path refuses, as a text's start and after a record
    // separator; two record separators; and whitespace before a sequence's next text.
    "\xef\xbb\xbf[1]",
    "\x1e\xef\xbb\xbf[1]\n",
    "\x1e\x1e[true] \n\x1e",
    // Escapes and UTF-8 the loop takes past a string's plain run, and escapes it leaves to the
    // checked path to refuse: a lone low surrogate, a high one no low one follows, a letter that
    // starts no escape, a digit that is none, and an escape the input cuts.
    "[\"a\\\"b\\\\c\\/d\\b\\f\\n\\r\\t\",\"\\u0041\\u00e9\\u20ac\\uD83D\\uDE00\",\"caf\xc3\xa9 \xe2\x82\xac\\n\"]",
    "[\"a\\uDC00\"]",
    "[\"a\\uD834\\u0041\"]",
    "[\"a\\q\"]",
    "[\"a\\u12G4\"]",
    "[\"a\\u00",
    // A block that cuts a character, and in the next block, past the character's last octet, an
    // escape and then a continuation octet that no character's first octet precedes, which UTF-8
    // rules out (RFC 3629 §4).
    "[\"" ++ "\xe2\x82\xac\xe2\x82\xac\xe2\x82\xac\xe2\x82\xac" ++ "ab\xe2\x82\xaccdef\\n\x80" ++ "\xe2\x82\xac\xe2\x82\xac\xe2\x82\xac\xe2\x82\xac\xe2\x82\xac" ++ "\"]",
    // A block that ends with a character's first octet, and a next block all ASCII.
    "[\"\xc3\xa90123456789abc\xe2" ++ "0123456789abcdef" ++ "\"]",
    // Strings past the 64 octets a block at a time, one ending near the input's end.
    "[\"0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789\",\"0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef\"]",
};

/// The text of `texts` whose strings hold every escape the loop takes, and UTF-8.
const escaped_text = 9;

/// The octets a flip writes, weighted toward the ones the grammar turns on.
const flip_octets = "{}[]:,\"\\ \t\n\x1e0-.eEtfnu\x00\x1f\x80\xc3\xff";

/// Where a lockstep decode stands.
const Lockstep = struct {
    looped: Decoder,
    checked: Decoder,
    looped_output: [output_len_max]u8 = undefined,
    checked_output: [output_len_max]u8 = undefined,
    looped_slots: [slots_max]Slot = undefined,
    checked_slots: [slots_max]Slot = undefined,
    consumed: usize = 0,

    /// Makes one batch on each decoder with the same pieces. Returns true once the decode ended.
    fn call(self: *Lockstep, comptime pair: Pair, input: []const u8, input_len: usize, room_len: usize, count: usize) !bool {
        const piece_octets = input[self.consumed..][0..input_len];
        const piece: Piece = if (self.consumed + input_len == input.len) .last else .more;
        const looped = self.looped.decode_batch_with(pair.looped, piece_octets, self.looped_output[0..room_len], piece, self.looped_slots[0..count]);
        const checked = self.checked.decode_batch_with(pair.checked, piece_octets, self.checked_output[0..room_len], piece, self.checked_slots[0..count]) catch |err| {
            try testing.expectError(err, looped);
            return true;
        };
        const looped_batch = try looped;
        try testing.expectEqual(checked, looped_batch);
        try testing.expectEqualSlices(Slot, self.checked_slots[0..checked.filled], self.looped_slots[0..looped_batch.filled]);
        try testing.expectEqualSlices(u8, self.checked_output[0..checked.written], self.looped_output[0..looped_batch.written]);
        try decoder_fast_test.expect_same_state(&self.looped, &self.checked);
        self.consumed += checked.consumed;
        return checked.status == .done or (checked.status == .needs_input and piece == .last);
    }
};

/// Decodes `input` in lockstep, whole when `seed` is null and else under its split, with as many
/// slots a batch as the seed draws.
fn expect_lockstep(comptime pair: Pair, framing: Framing, input: []const u8, seed: ?u64) !void {
    var lockstep: Lockstep = .{ .looped = undefined, .checked = undefined };
    lockstep.looped.init(framing, codec.Features.detect());
    lockstep.checked.init(framing, codec.Features.detect());
    var schedule = codec.split.Schedule.init(seed orelse 0);
    const count = if (seed) |value| 1 + value % slots_max else slots_max;
    const calls_max = codec.constants.driver_calls_floor + codec.constants.driver_calls_per_octet_max * (input.len + output_len_max);
    for (0..calls_max) |_| {
        const left = input.len - lockstep.consumed;
        const input_len = if (seed == null) left else schedule.piece_len(left);
        const room_len = if (seed == null) output_len_max else schedule.piece_len(output_len_max);
        if (try lockstep.call(pair, input, input_len, room_len, count)) return;
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

test "the loop takes each token of the texts as the checked path does, whole and split" {
    for (texts, 0..) |text, index| try check(text, index);
}

test "the loop takes a text whole, from its record separator to its end, with none of its tokens left" {
    for ([_]Framing{ .text, .sequence }) |framing| {
        var decoder: Decoder = undefined;
        decoder.init(framing, codec.Features.detect());
        var output: [output_len_max]u8 = undefined;
        var slots: [slots_max]Slot = undefined;
        // 21 tokens, with 16 octets after the last string, and whitespace after the text.
        const text = if (framing == .text) texts[0] else "\x1e" ++ texts[0];
        var cursor: token_loop.Cursor = .{ .consumed = 0, .written = 0 };
        try testing.expectEqual(21, token_loop.take(&decoder, claims.vector, text, &output, .last, &cursor, &slots));
        try testing.expectEqualStrings("a", output[slots[1].start..][0..slots[1].len]);
        try testing.expectEqual(text.len, cursor.consumed);
        try testing.expect(decoder.is_done());
    }
}

/// Short texts whose value whitespace follows, of every kind the text's end treats apart.
const ended_texts = [_][]const u8{ "\x1e42 \n", "\x1etrue\t\n", " 42 ", "[1] \n", "\x1e\x1e{} \x1e", "\x1e\"a\"\r\n\x1e" };

test "short texts cut in two at every octet decode alike with the loop on and off" {
    for (ended_texts) |text| {
        for (0..text.len + 1) |split| try check_split(text, split);
    }
}

/// Requires the lockstep property of `input` in both framings, its first piece ending at `split`
/// and the rest following in calls of all the input left.
fn check_split(input: []const u8, split: usize) !void {
    inline for (pairs) |pair| {
        for ([_]Framing{ .text, .sequence }) |framing| {
            var lockstep: Lockstep = .{ .looped = undefined, .checked = undefined };
            lockstep.looped.init(framing, codec.Features.detect());
            lockstep.checked.init(framing, codec.Features.detect());
            var ended = try lockstep.call(pair, input, split, output_len_max, slots_max);
            for (0..input.len + 1) |_| {
                if (ended) break;
                ended = try lockstep.call(pair, input, input.len - lockstep.consumed, output_len_max, slots_max);
            } else return error.TestNoProgress;
        }
    }
}

test "the loop takes strings with every escape it names and with UTF-8, none left to the checked path" {
    var decoder: Decoder = undefined;
    decoder.init(.text, codec.Features.detect());
    var output: [output_len_max]u8 = undefined;
    var slots: [slots_max]Slot = undefined;
    // Four tokens and the text's end: `[`, the two strings, `]`.
    const text = texts[escaped_text];
    var cursor: token_loop.Cursor = .{ .consumed = 0, .written = 0 };
    try testing.expectEqual(5, token_loop.take(&decoder, claims.vector, text, &output, .last, &cursor, &slots));
    try testing.expectEqualStrings("a\"b\\c/d\x08\x0c\n\r\t", output[slots[1].start..][0..slots[1].len]);
    try testing.expectEqualStrings("A\xc3\xa9\xe2\x82\xac\xf0\x9f\x98\x80", output[slots[2].start..][0..slots[2].len]);
    try testing.expect(decoder.is_done());
}

test "the loop takes a string whose blocks of 16 cut characters, none left to the checked path" {
    // Ten characters of three octets: the first block of 16 ends inside the sixth, and the octets
    // left are fewer than a block, which the walk then takes from that character's start.
    const content = "\xe2\x82\xac" ** 10;
    const text = "[\"" ++ content ++ "\"]";
    var decoder: Decoder = undefined;
    decoder.init(.text, codec.Features.detect());
    var output: [output_len_max]u8 = undefined;
    var slots: [slots_max]Slot = undefined;
    var cursor: token_loop.Cursor = .{ .consumed = 0, .written = 0 };
    try testing.expectEqual(3, token_loop.take(&decoder, claims.vector, text, &output, .last, &cursor, &slots));
    try testing.expectEqualStrings(content, output[slots[1].start..][0..slots[1].len]);
    try testing.expect(decoder.is_done());
}

test "a long string that fills the output exactly is taken, and one octet more is not" {
    const content = "0123456789abcdef" ** 6 ++ "0123";
    const text = "[\"" ++ content ++ "\"," ++ " " ** 16 ++ "0]";
    const cases = [_]struct { room: usize, taken: usize }{ .{ .room = content.len, .taken = 1 }, .{ .room = content.len - 1, .taken = 0 } };
    for (cases) |case| {
        var decoder: Decoder = undefined;
        decoder.init(.text, codec.Features.detect());
        var output: [output_len_max]u8 = undefined;
        var slots: [slots_max]Slot = undefined;
        const first = try decoder.decode(text, &output, .last);
        var cursor: token_loop.Cursor = .{ .consumed = first.consumed, .written = 0 };
        try testing.expectEqual(case.taken, token_loop.take(&decoder, claims.vector, text, output[0..case.room], .last, &cursor, &slots));
        if (case.taken == 1) try testing.expectEqualStrings(content, output[0..cursor.written]);
    }
}

test "the loop steps aside at the depth limit, where the checked path refuses" {
    var input: [constants.depth_max + 2]u8 = undefined;
    @memset(&input, constants.begin_array);
    try check(&input, 0);
}

test "every seeded corruption of the texts decodes alike with the loop on and off" {
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

test "fuzz the token loop against the checked path" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &texts });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    try check(input[0..input_len], smith.value(u64));
}
