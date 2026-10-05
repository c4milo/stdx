//! Tests for the DEFLATE tail loop's refill by words and its copies in chunks (decision 16;
//! decision 14, S15). A stream of literals and of matches, at each kind of distance and around
//! each count of chunks, must decode to the same octets into every room up to its length and from
//! every input length: with the claim on, with it off, and on the checked path alone.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const test_stream = @import("../test_stream.zig");
const deflate = @import("../decoder/decoder.zig");
const fast = @import("fast.zig");
const fast_step = @import("fast_step.zig");

/// The most octets the test's stream decodes to.
const output_len_max = 4096;

/// The literals before the first match: more than the farthest distance below.
const history_len = 110;

const chunk = constants.copy_chunk_len;
const word = constants.copy_word_len;

/// A distance past the period of the first literals, and one that repeats three octets.
const far_distance = 100;
const near_distance = 3;

/// The matches' distances, the farthest first, so that each copies octets that differ: the far
/// one; a chunk and one shorter, which copy by chunks and by words; a word and one shorter, which
/// copy by words and octet by octet; and the near one and 1, which repeat (fast_copy.zig).
const distances = [_]u16{ far_distance, chunk, chunk - 1, word, word - 1, near_distance, 1 };

/// The shortest match (RFC 1951 §3.2.5), the chunks a copy writes whatever the length
/// (fast_copy.zig), and one chunk more.
const shortest = 3;
const first_chunks = 2;
const more_chunks = 3;

/// The matches' lengths: the shortest, and those around one word, one chunk, the chunks a copy
/// writes first, and one chunk more.
const lengths = [_]u16{
    shortest,                 word,                    word + 1,
    chunk - 1,                chunk,                   chunk + 1,
    first_chunks * chunk - 1, first_chunks * chunk,    first_chunks * chunk + 1,
    more_chunks * chunk,      more_chunks * chunk + 1,
};

/// The distances of the two longest matches: a chunk, and 1.
const longest_distances = [_]u16{ chunk, 1 };

/// The counts of literals between two matches: one, then two, in turn.
const literal_counts = 2;

/// A stream of one fixed block, with the octets it decodes to.
const Fixture = struct {
    stream: test_stream.Stream = .{},
    expected: [output_len_max]u8 = undefined,
    expected_len: usize = 0,

    fn literal(self: *Fixture, octet: u8) void {
        self.stream.fixed_literal(octet);
        self.expected[self.expected_len] = octet;
        self.expected_len += 1;
    }

    fn pair(self: *Fixture, len: u16, distance: u16) void {
        self.stream.fixed_pair(len, distance);
        for (0..len) |_| {
            self.expected[self.expected_len] = self.expected[self.expected_len - distance];
            self.expected_len += 1;
        }
    }

    /// Literals, then a match of each length at each distance, with one literal or two between
    /// them, so the matches start at every place of a chunk, then the two longest matches.
    fn init() Fixture {
        var fixture: Fixture = .{};
        fixture.stream.block_header(true, .fixed);
        for (0..history_len) |index| fixture.literal(letter(index));
        var count: usize = 0;
        for (distances) |distance| {
            for (lengths) |len| {
                fixture.pair(len, distance);
                count += 1;
                for (0..1 + count % literal_counts) |index| fixture.literal(letter(count + index));
            }
        }
        for (longest_distances) |distance| {
            fixture.pair(constants.match_len_max, distance);
            fixture.literal(letter(distance));
        }
        fixture.stream.fixed_literal(constants.end_of_block);
        return fixture;
    }

    fn output(self: *const Fixture) []const u8 {
        return self.expected[0..self.expected_len];
    }
};

/// A letter that differs from the ones a distance below a chunk back, so a copy from a wrong
/// place shows.
fn letter(index: usize) u8 {
    const letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456";
    return letters[index % letters.len];
}

const tail_off: deflate.Options = .{ .claims = .{ .wide_tail = false } };
const checked: deflate.Options = .{ .fast_paths = false };

/// Requires the stream to decode to the fixture's octets in two calls: the first takes
/// `input[0..cut]` and writes into `room` octets, and the second takes what is left of both.
fn expect_decodes(comptime options: deflate.Options, fixture: *const Fixture, input: []const u8, cut: usize, room: usize) !void {
    const expected = fixture.output();
    var decoder: deflate.Decoder = undefined;
    deflate.init(&decoder, codec.Features.detect());
    var output: [output_len_max]u8 = undefined;
    @memset(&output, 0);
    const first = try deflate.decode_with(options, &decoder, input[0..cut], output[0..room]);
    try testing.expectEqualSlices(u8, expected[0..first.written], output[0..first.written]);
    if (first.status == .done) {
        try testing.expectEqual(expected.len, first.written);
        return;
    }
    const second = try deflate.decode_with(options, &decoder, input[first.consumed..], output[first.written..expected.len]);
    try testing.expectEqual(codec.Status.done, second.status);
    try testing.expectEqual(input.len, first.consumed + second.consumed);
    try testing.expectEqualSlices(u8, expected, output[0 .. first.written + second.written]);
}

test "the tail decodes into every room up to the stream's length" {
    const fixture = Fixture.init();
    const input = fixture.stream.slice();
    for (0..fixture.expected_len + 1) |room| {
        inline for (.{ deflate.Options{}, tail_off, checked }) |options| {
            try expect_decodes(options, &fixture, input, input.len, room);
        }
    }
}

test "the tail decodes from every input length, into a buffer of the stream's length" {
    const fixture = Fixture.init();
    const input = fixture.stream.slice();
    for (0..input.len + 1) |cut| {
        inline for (.{ deflate.Options{}, tail_off, checked }) |options| {
            try expect_decodes(options, &fixture, input, cut, fixture.expected_len);
        }
    }
}

test "the tail decodes from every input length into a room shorter than the margin" {
    // The first call's room ends inside the tail's reach of the stream's start, so the tail runs
    // with input left at every length the input may have.
    const fixture = Fixture.init();
    const input = fixture.stream.slice();
    const room = history_len + constants.match_len_max;
    for (0..input.len + 1) |cut| {
        inline for (.{ deflate.Options{}, tail_off }) |options| {
            try expect_decodes(options, &fixture, input, cut, room);
        }
    }
}

/// A room shorter than the wide loop's margin, so a call into it runs the tail from its first
/// symbol.
const short_room = 100;

test "the tail starts from the bits a call cut short left, at every input length" {
    // The first call takes the input up to the cut and keeps what it could not use, up to a full
    // buffer of 64 bits. The second gives the rest and a room shorter than the margin, so the
    // tail starts with that buffer and a word of input to load.
    const fixture = Fixture.init();
    const input = fixture.stream.slice();
    const expected = fixture.output();
    for (0..input.len + 1) |cut| {
        inline for (.{ deflate.Options{}, tail_off }) |options| {
            var decoder: deflate.Decoder = undefined;
            deflate.init(&decoder, codec.Features.detect());
            var output: [output_len_max]u8 = undefined;
            var consumed: usize = 0;
            var written: usize = 0;
            const first = try deflate.decode_with(options, &decoder, input[0..cut], output[0..expected.len]);
            consumed += first.consumed;
            written += first.written;
            var status = first.status;
            // Each call writes an octet at least, or ends the stream.
            for (0..expected.len + 1) |_| {
                if (status == .done) break;
                const room = @min(short_room, expected.len - written);
                const next = try deflate.decode_with(options, &decoder, input[consumed..], output[written..][0..room]);
                consumed += next.consumed;
                written += next.written;
                status = next.status;
            }
            try testing.expectEqual(codec.Status.done, status);
            try testing.expectEqual(input.len, consumed);
            try testing.expectEqualSlices(u8, expected, output[0..written]);
        }
    }
}

/// What the output holds before a decode, to show the octets a call did not write.
const untouched = 0xa5;

test "with its chunks off, the tail writes nothing past the octets it decodes" {
    // A call into a room shorter than the margin runs the tail and the checked path alone, and
    // when its input ends first, room is left past its last octet. With S15 off, or S4, a match
    // copies octet by octet, so no octet of that room changes.
    const fixture = Fixture.init();
    const input = fixture.stream.slice();
    const chunks_off: deflate.Options = .{ .claims = .{ .chunk_copies = false } };
    const room = fast.output_slack - 1;
    for (0..input.len + 1) |cut| {
        inline for (.{ tail_off, chunks_off, checked }) |options| {
            var decoder: deflate.Decoder = undefined;
            deflate.init(&decoder, codec.Features.detect());
            var output: [output_len_max]u8 = @splat(untouched);
            const first = try deflate.decode_with(options, &decoder, input[0..cut], output[0..room]);
            try testing.expectEqualSlices(u8, fixture.expected[0..first.written], output[0..first.written]);
            try testing.expect(std.mem.allEqual(u8, output[first.written..], untouched));
        }
    }
}

test "a buffer that holds 57 bits or more takes no word" {
    // The word refill loads into a buffer of 63 bits at most (fast.zig, `refill`), and a call may
    // hand the tail a buffer of 64.
    var input: [2 * fast.input_slack]u8 = undefined;
    for (&input, 0..) |*octet, index| octet.* = @intCast(index + 1);
    var output: [1]u8 = undefined;
    inline for (.{ @bitSizeOf(u64), fast.refill_bits + 1 }) |count| {
        var loop: fast.Loop = .{
            .input = &input,
            .rest = &input,
            .buffer = 0,
            .count = count,
            .output = &output,
            .written = 0,
            .literal_length_entries = undefined,
            .literal_length_mask = 0,
            .distance_entries = undefined,
            .distance_mask = 0,
            .distance_max = 0,
            .lengths_resolved = false,
        };
        fast_step.refill_tail(.{}, &loop);
        try testing.expectEqual(@as(u64, 0), loop.buffer);
        try testing.expectEqual(input.len, loop.rest.len);
        try testing.expectEqual(@as(u32, count), loop.count);
    }
}
