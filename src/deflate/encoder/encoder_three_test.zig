//! Tests of the encoder over input whose literals are dear and that repeats 3 octets at a time:
//! the lazy levels take matches of 3 octets there (`encoder_match/encoder_match_three.zig`).
//! Their output is recorded, is the same under every split and across flushes, decodes to the
//! input, and leaves nothing in a state that the next stream could read.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const encoder_module = @import("encoder.zig");
const encoder_test = @import("encoder_test.zig");

const levels = constants.encoder_levels;

/// The input: strings of 3 octets drawn from a seeded list of this many, each followed by an
/// octet drawn evenly, over 120 KiB, past a slide of the window. A string recurs every 2,000 octets or so
/// and the octet after it differs, so the input holds matches of 3 octets and few longer.
const triples = 512;
const triple_len = constants.match_len_min;
const slot_len = triple_len + 1;
const input_len = 122_880;

fn fill_triples(input: []u8, seed: u64) void {
    var generator = codec.split.Generator.init(seed);
    var list: [triples][triple_len]u8 = undefined;
    for (&list) |*triple| {
        for (triple) |*octet| octet.* = @truncate(generator.next());
    }
    @memset(input, 0);
    for (0..input.len / slot_len) |slot| {
        const at = slot * slot_len;
        @memcpy(input[at..][0..triple_len], &list[generator.below(triples)]);
        input[at + triple_len] = @truncate(generator.next());
    }
}

test "each level's output for seeded strings of 3 octets is the one recorded here" {
    // Any change to what the encoder decides changes these; a change meant to must record new ones.
    const recorded = [_]struct { usize, u64 }{
        .{ 121220, 0x5b8fc7c9a688244c },
        .{ 96537, 0x6c968229afa49f6a },
        .{ 96537, 0x6c968229afa49f6a },
    };
    var input: [input_len]u8 = undefined;
    fill_triples(&input, 23);
    var output: [input.len + 1024]u8 = undefined;
    var greedy_len: usize = 0;
    inline for (levels, recorded) |level, expected| {
        const written = try encoder_test.encode_whole(level, &input, &output);
        try testing.expectEqual(expected[0], written);
        try testing.expectEqual(expected[1], std.hash.Wyhash.hash(0, output[0..written]));
        try encoder_test.expect_decodes_to(output[0..written], &input);
        // Level 1 takes no match of 3 octets, and the lazy levels' matches save a fifth of its
        // output. The two find the same matches here, where no longer one is to be found.
        if (comptime !constants.level(level).three) greedy_len = written;
        if (comptime constants.level(level).three) try testing.expect(written * 5 < greedy_len * 4);
    }
}

fn Step(comptime level: u4) type {
    return struct {
        const Encoder = encoder_module.Encoder(.{ .level = level });
        fn step(state: *Encoder, input: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
            return state.encode(input, output, flush);
        }
    };
}

/// The seeds of the splits each test drives.
const split_seeds = 4;

test "every split gives the same octets where the table of 3 octets slides with the window" {
    var input: [input_len]u8 = undefined;
    fill_triples(&input, 29);
    var whole: [input.len + 1024]u8 = undefined;
    var split: [whole.len]u8 = undefined;
    inline for (levels) |level| {
        const S = Step(level);
        const whole_len = try encoder_test.encode_whole(level, &input, &whole);
        for (0..split_seeds) |seed| {
            var states: [codec.split.state_slots]S.Encoder = undefined;
            states[0].init(.{});
            const outcome = try codec.split.drive_encoder(S.Encoder, &states, S.step, &input, &split, &.{}, seed);
            try testing.expectEqual(.done, outcome.status);
            try testing.expectEqualSlices(u8, whole[0..whole_len], split[0..outcome.written]);
        }
    }
}

test "a flush among matches of 3 octets leaves the output so far decoding, and splits agree" {
    var input: [input_len]u8 = undefined;
    fill_triples(&input, 31);
    // Points past the first blocks, where the matches are on: one a string's first octet, the
    // next its second, and one after a slide of the window.
    const points = [_]usize{ 40_000, 40_001, 40_001, 90_002 };
    inline for (levels) |level| {
        const S = Step(level);
        var state: S.Encoder = undefined;
        state.init(.{});
        var output: [input.len + 1024]u8 = undefined;
        var written: usize = 0;
        var consumed: usize = 0;
        for (points) |point| {
            const progress = state.encode(input[consumed..point], output[written..], .flush);
            try testing.expectEqual(.needs_input, progress.status);
            consumed += progress.consumed;
            written += progress.written;
            try encoder_test.expect_prefix_decodes(output[0..written], input[0..point]);
        }
        const last = state.encode(input[consumed..], output[written..], .finish);
        try testing.expectEqual(.done, last.status);
        written += last.written;
        try encoder_test.expect_decodes_to(output[0..written], &input);
        for (0..split_seeds) |seed| {
            var states: [codec.split.state_slots]S.Encoder = undefined;
            states[0].init(.{});
            var split: [output.len]u8 = undefined;
            const outcome = try codec.split.drive_encoder(S.Encoder, &states, S.step, &input, &split, &points, seed);
            try testing.expectEqualSlices(u8, output[0..written], split[0..outcome.written]);
        }
    }
}

test "a state that took matches of 3 octets encodes the next stream as a fresh one does" {
    var first: [input_len]u8 = undefined;
    fill_triples(&first, 37);
    // The next stream holds dear literals too, and other strings.
    var second: [input_len / 2]u8 = undefined;
    fill_triples(&second, 41);
    var output: [first.len + 1024]u8 = undefined;
    var fresh: [second.len + 1024]u8 = undefined;
    inline for (levels) |level| {
        const Encoder = encoder_module.Encoder(.{ .level = level });
        var state: Encoder = undefined;
        state.init(.{});
        _ = try state.encode_all(&first, &output);
        state.init(.{});
        const again = try state.encode_all(&second, &output);
        const fresh_len = try encoder_test.encode_whole(level, &second, &fresh);
        try testing.expectEqualSlices(u8, fresh[0..fresh_len], output[0..again]);
    }
}
