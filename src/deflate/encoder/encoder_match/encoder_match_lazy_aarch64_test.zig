//! The tests of `encoder_match_lazy_aarch64.zig` and `encoder_match_lazy_x86_64.zig` (decision 53): the assembly and the Zig loop, run
//! on two copies of one matcher and one block, leave every field of the copies equal. On a target
//! the assembly does not take, the tests are skipped.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const Block = @import("../encoder_block.zig").Block;
const match = @import("encoder_match.zig");
const builtin = @import("builtin");
/// The assembly of this build's architecture.
const lazy = if (builtin.cpu.arch == .x86_64) @import("encoder_match_lazy_x86_64.zig") else @import("encoder_match_lazy_aarch64.zig");
const level_number = @import("encoder_match_lazy_aarch64.zig").level_number;

const level = constants.level(level_number);
const Matcher = match.Matcher(level);

/// Whether this build runs the assembly.
const runs = lazy.takes(level, false);

/// Runs the Zig loop and the assembly from `matcher` and `block`, and requires the same state of
/// both copies after them.
fn expect_same(matcher: *const Matcher, block: *const Block) !void {
    var zig_matcher = matcher.*;
    var zig_block = block.*;
    match.advance_lazy_zig(level, false, &zig_matcher, &zig_block, {});
    var asm_matcher = matcher.*;
    var asm_block = block.*;
    lazy.advance(level, &asm_matcher, &asm_block);
    try testing.expectEqual(zig_matcher.position, asm_matcher.position);
    try testing.expectEqual(zig_matcher.previous, asm_matcher.previous);
    try testing.expectEqual(zig_matcher.waiting, asm_matcher.waiting);
    try testing.expectEqualSlices(u16, &zig_matcher.heads, &asm_matcher.heads);
    try testing.expectEqualSlices(u16, &zig_matcher.chain, &asm_matcher.chain);
    try testing.expectEqual(zig_block.symbol_count, asm_block.symbol_count);
    try testing.expectEqual(zig_block.input_len, asm_block.input_len);
    const count = zig_block.symbol_count;
    try testing.expectEqualSlices(u8, std.mem.sliceAsBytes(zig_block.symbols[0..count]), std.mem.sliceAsBytes(asm_block.symbols[0..count]));
    try testing.expectEqualSlices(u16, &zig_block.literal_length_counts, &asm_block.literal_length_counts);
    try testing.expectEqualSlices(u16, &zig_block.distance_counts, &asm_block.distance_counts);
}

/// The kinds of seeded input: letters drawn from an alphabet, and text whose runs copy earlier
/// octets, from a distance of 1 to past the reach and up to past `match_len_max` long.
const Kind = union(enum) { letters: u64, copies: u64 };

/// How far the longest run a copy takes passes `match_len_max`, so a match reaches that length.
const copy_overrun = 64;
const copy_len_max = constants.match_len_max + copy_overrun;

/// One position in this many starts a copy.
const copy_odds = 2;

/// Fills `window` with seeded octets of `kind`.
fn fill(window: []u8, kind: Kind, seed: u64) void {
    var generator = codec.split.Generator.init(seed);
    switch (kind) {
        .letters => |letters| for (window) |*octet| {
            octet.* = @intCast(generator.below(letters));
        },
        .copies => |letters| {
            var at: usize = 0;
            while (at < window.len) {
                const copies = at > 0 and generator.below(copy_odds) == 0;
                if (!copies) {
                    window[at] = @intCast(generator.below(letters));
                    at += 1;
                    continue;
                }
                const distance = 1 + generator.below(@min(at, constants.window_len));
                const len = @min(1 + generator.below(copy_len_max), window.len - at);
                for (0..len) |index| window[at + index] = window[at + index - distance];
                at += len;
            }
        },
    }
}

/// A matcher whose window holds `input`, started as a stream starts, and an empty block.
fn start(matcher: *Matcher, block: *Block, input: []const u8) void {
    matcher.init();
    @memset(&matcher.chain, 0);
    std.debug.assert(matcher.fill(input) == input.len);
    block.reset(0);
}

/// The alphabets of the seeded inputs: 2 letters, whose chains run long; 4, DNA's; 16; 26,
/// English's; and every octet, whose chains run short.
const letters_two = 2;
const letters_four = 4;
const letters_sixteen = 16;
const letters_english = 26;
const letters_all = std.math.maxInt(u8) + 1;

/// The kinds the seeded test takes, each at several seeds.
const kinds = [_]Kind{
    .{ .letters = letters_two }, .{ .letters = letters_four },   .{ .letters = letters_sixteen }, .{ .letters = letters_all },
    .{ .copies = letters_four }, .{ .copies = letters_english }, .{ .copies = letters_all },
};
const seeds_per_kind = 3;

/// The octets of the seeded inputs: a whole window's.
const input_len = constants.encoder_window_len;

test "the assembly leaves a seeded stream's matcher and block as the Zig loop does" {
    if (comptime runs) {
        var input: [input_len]u8 = undefined;
        var matcher: Matcher = undefined;
        var block: Block = undefined;
        for (kinds) |kind| {
            for (0..seeds_per_kind) |seed| {
                fill(&input, kind, seed);
                start(&matcher, &block, &input);
                try expect_same(&matcher, &block);
            }
        }
    } else return error.SkipZigTest;
}

/// The points a stream stops at before the seeded test of stopped streams starts both loops: from
/// early, where few chains are long, to late, one every `stop_step` octets.
const stop_first = 1000;
const stop_step = 1500;
const stop_count = 40;

test "the assembly continues a stream the Zig loop stopped, a waiting match's included" {
    if (comptime runs) {
        var input: [input_len]u8 = undefined;
        var matcher: Matcher = undefined;
        var block: Block = undefined;
        var waited: usize = 0;
        for (kinds) |kind| {
            fill(&input, kind, 7);
            for (0..stop_count) |index| {
                const point = stop_first + index * stop_step;
                start(&matcher, &block, &input);
                // The Zig loop decides the positions up to the point's lookahead.
                matcher.filled = point;
                match.advance_lazy_zig(level, false, &matcher, &block, {});
                matcher.filled = input.len;
                waited += @intFromBool(matcher.waiting and matcher.previous.len != 0);
                try expect_same(&matcher, &block);
            }
        }
        // A match waits at more of the points than there are kinds: 17 of the 280 on 2026-10-25.
        try testing.expect(waited > kinds.len);
    } else return error.SkipZigTest;
}

/// The symbols a nearly full block has room for: 1 to `rooms_few`, and `room_most`.
const rooms_few = 3;
const room_most = 100;

test "the assembly stops at a full block as the Zig loop does" {
    if (comptime runs) {
        var input: [input_len]u8 = undefined;
        var matcher: Matcher = undefined;
        var block: Block = undefined;
        for ([_]Kind{ .{ .letters = letters_all }, .{ .copies = letters_english } }) |kind| {
            fill(&input, kind, 11);
            for ([_]u16{ 1, rooms_few - 1, rooms_few, room_most }) |room| {
                start(&matcher, &block, &input);
                block.symbol_count = constants.block_symbols_max - room;
                try expect_same(&matcher, &block);
            }
        }
    } else return error.SkipZigTest;
}

test "fuzz the assembly against the Zig loop" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "", "abcabcabcabcabcabcabc", "\x00" ** 600 } });
}

/// The octets of a fuzzed input at most: a window's, so the loop reaches its end.
const fuzz_input_len_max = constants.encoder_window_len;

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    if (comptime runs) {
        var input: [fuzz_input_len_max]u8 = undefined;
        const len = smith.slice(&input);
        var matcher: Matcher = undefined;
        var block: Block = undefined;
        start(&matcher, &block, input[0..len]);
        try expect_same(&matcher, &block);
    }
}

/// The windows of input the encoder test of decision 54 takes, so that the window slides.
const encoder_windows = 3;

test "level 6 writes the same octets with the x86-64 loop chosen and without it" {
    // On x86-64 the two encoders run the assembly and the Zig loop; elsewhere the flag chooses
    // nothing, and the two are the same encoder (decision 54).
    const Encoder = @import("../encoder.zig").Encoder(.{ .level = level_number });
    const stream_len = encoder_windows * constants.window_len;
    var input: [stream_len]u8 = undefined;
    var encoder: Encoder = undefined;
    var chosen: [Encoder.encoded_len_max(stream_len)]u8 = undefined;
    var plain: [chosen.len]u8 = undefined;
    for ([_]Kind{ .{ .letters = letters_all }, .{ .copies = letters_english }, .{ .copies = letters_four } }) |kind| {
        fill(&input, kind, 13);
        encoder.init(.{ .lazy_loop_fast = true });
        const chosen_len = try encoder.encode_all(&input, &chosen);
        encoder.init(.{});
        const plain_len = try encoder.encode_all(&input, &plain);
        try testing.expectEqualSlices(u8, plain[0..plain_len], chosen[0..chosen_len]);
    }
}

/// A pattern the test of the reach's edge copies, which seeded octets around it do not hold.
const edge_pattern = "FARTHEST CANDIDATE 0123456789 QXZJ";

test "the assembly finds a candidate at encoder_distance_max, and none one octet farther" {
    if (comptime runs) {
        var input: [input_len]u8 = undefined;
        var matcher: Matcher = undefined;
        var block: Block = undefined;
        const first = 1;
        for ([_]usize{ 0, 1 }) |farther| {
            // Two letters code in few symbols, so the block holds every position to the copy.
            fill(&input, .{ .letters = letters_two }, 17);
            const copy = first + constants.encoder_distance_max + farther;
            @memcpy(input[first..][0..edge_pattern.len], edge_pattern);
            @memcpy(input[copy..][0..edge_pattern.len], edge_pattern);
            start(&matcher, &block, &input);
            try expect_same(&matcher, &block);
        }
    } else return error.SkipZigTest;
}
