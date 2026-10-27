//! The tests of the match finder: a block's sequences, executed as RFC 8878 §3.1.1.4 executes
//! them with the decoder's `resolve_offset`, give the block back.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const sequences_module = @import("../sequences.zig");
const encoder_match = @import("encoder_match.zig");
const encoder_sequences = @import("encoder_sequences.zig");
const encoder_repeat = @import("encoder_repeat.zig");

/// Levels with small tables, so the tables fill and collide: one table, and two.
const window_log = constants.encoder_window_log_min;
const short_hash_log = 12;
const long_hash_log = 13;
const levels = [_]encoder_match.Level{
    .{ .window_log = window_log, .short_hash_log = short_hash_log, .short_hash_len = constants.short_hash_len, .long_hash_log = 0 },
    .{ .window_log = window_log, .short_hash_log = short_hash_log, .short_hash_len = constants.short_hash_len, .long_hash_log = long_hash_log },
};

/// The test's window: three blocks, so history passes the levels' window.
const blocks = 3;
const window_len = blocks * constants.block_len_max;

/// One octet in `noise_odds` is noise; the rest are words.
const noise_odds = 10;

/// State that outlives one test's stack frame.
threadlocal var window: [window_len]u8 = undefined;
threadlocal var output: [window_len]u8 = undefined;
threadlocal var literals: [constants.block_len_max]u8 = undefined;
threadlocal var sequences: encoder_sequences.Sequences = undefined;

/// Fills `octets` with text-like runs: words from a small set, with seeded noise.
fn fill(generator: *codec.split.Generator, octets: []u8) void {
    const words = [_][]const u8{ "octet ", "window ", "stream ", "the ", "of ", "match ", "zstd ", "frame " };
    var at: usize = 0;
    for (0..octets.len) |_| {
        if (at == octets.len) break;
        if (generator.below(noise_odds) == 0) {
            octets[at] = @truncate(generator.next());
            at += 1;
            continue;
        }
        const word = words[generator.below(words.len)];
        const len = @min(word.len, octets.len - at);
        @memcpy(octets[at..][0..len], word[0..len]);
        at += len;
    }
}

/// Executes `sequences` and the literals after them from `start`, as a decoder would.
fn execute(start: usize, repeats: *encoder_repeat.Repeats, literals_used: []const u8) !usize {
    var at = start;
    var literal: usize = 0;
    for (0..sequences.count) |index| {
        const literals_len = sequences.literals_lens[index];
        @memcpy(output[at..][0..literals_len], literals_used[literal..][0..literals_len]);
        literal += literals_len;
        at += literals_len;
        const offset = try sequences_module.resolve_offset(repeats, sequences.offset_values[index], literals_len);
        for (0..sequences.match_lens[index]) |_| {
            output[at] = output[at - offset];
            at += 1;
        }
    }
    const rest = literals_used.len - literal;
    @memcpy(output[at..][0..rest], literals_used[literal..]);
    return at + rest;
}

test "a block's sequences and literals execute back into the block, at both levels" {
    inline for (levels) |level| {
        var generator = codec.split.Generator.init(9);
        const Matcher = encoder_match.Matcher(level);
        var matcher: Matcher = undefined;
        matcher.init();
        fill(&generator, &window);
        var encoder_repeats: encoder_repeat.Repeats = constants.repeated_offsets_initial;
        var decoder_repeats: encoder_repeat.Repeats = constants.repeated_offsets_initial;
        @memcpy(output[0..1], window[0..1]);
        var start: usize = 0;
        for (0..6) |_| {
            const len = generator.between(0, constants.block_len_max);
            const end = @min(start + len, window.len);
            sequences.count = 0;
            var block: encoder_match.Block = .{ .sequences = &sequences, .literals = &literals, .literals_len = 0, .repeats = &encoder_repeats };
            matcher.parse(&window, start, end, &block);
            const executed = try execute(start, &decoder_repeats, literals[0..block.literals_len]);
            try testing.expectEqual(end, executed);
            try testing.expectEqualSlices(u8, window[start..end], output[start..end]);
            try testing.expectEqualSlices(u32, &encoder_repeats, &decoder_repeats);
            for (sequences.offset_values[0..sequences.count], sequences.literals_lens[0..sequences.count]) |value, literals_len| {
                _ = literals_len;
                try testing.expect(value < (@as(u32, 1) << level.window_log) + constants.repeat_offset_values);
            }
            start = end;
        }
        // Text repeats, so most octets go into matches.
        try testing.expect(sequences.count > 0);
    }
}
