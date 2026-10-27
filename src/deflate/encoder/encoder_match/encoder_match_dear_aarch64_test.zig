//! Tests of `encoder_match_dear_aarch64.zig`: the assembly and the Zig loop of the dear blocks, run
//! on copies of one matcher, one block and one 3-octet table, must leave the copies the same
//! (decision 59).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const Block = @import("../encoder_block.zig").Block;
const match = @import("encoder_match.zig");
const dear = @import("encoder_match_dear.zig");
const dear_aarch64 = @import("encoder_match_dear_aarch64.zig");
const Three = @import("encoder_match_three.zig").Three;

const level = constants.level(dear_aarch64.level_number);
const Matcher = match.Matcher(level);

/// Whether the assembly runs here; elsewhere each test skips.
const runs = dear_aarch64.takes(level);

/// Runs the Zig loop and the assembly from `matcher`, `block` and `three`, and requires the same
/// state of all three copies after them.
fn expect_same(matcher: *const Matcher, block: *const Block, three: *const Three) !void {
    var zig_matcher = matcher.*;
    var zig_block = block.*;
    var zig_three = three.*;
    dear.advance_lazy_zig(level, &zig_matcher, &zig_block, &zig_three);
    var asm_matcher = matcher.*;
    var asm_block = block.*;
    var asm_three = three.*;
    dear_aarch64.advance(level, &asm_matcher, &asm_block, &asm_three);
    try testing.expectEqual(zig_matcher.position, asm_matcher.position);
    try testing.expectEqual(zig_matcher.previous, asm_matcher.previous);
    try testing.expectEqual(zig_matcher.waiting, asm_matcher.waiting);
    try testing.expectEqualSlices(u16, &zig_matcher.heads, &asm_matcher.heads);
    try testing.expectEqualSlices(u16, &zig_matcher.chain, &asm_matcher.chain);
    try testing.expectEqualSlices(u16, &zig_three.heads, &asm_three.heads);
    try testing.expectEqualSlices(u16, &zig_three.octets, &asm_three.octets);
    try testing.expectEqualSlices(u16, &zig_three.distances, &asm_three.distances);
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

/// A matcher whose window holds `input`, started as a stream starts, an empty block, and a live
/// 3-octet table.
fn start(matcher: *Matcher, block: *Block, three: *Three, input: []const u8) void {
    matcher.init();
    @memset(&matcher.chain, 0);
    std.debug.assert(matcher.fill(input) == input.len);
    block.reset(0);
    three.start();
    three.live = true;
    @memset(&three.heads, 0);
}

test "the dear assembly leaves a seeded stream's matcher, block and table as the Zig loop does" {
    if (comptime runs) {
        var input: [input_len]u8 = undefined;
        var matcher: Matcher = undefined;
        var block: Block = undefined;
        var three: Three = undefined;
        for (kinds) |kind| {
            for (0..seeds_per_kind) |seed| {
                fill(&input, kind, seed);
                start(&matcher, &block, &three, &input);
                try expect_same(&matcher, &block, &three);
            }
        }
    } else return error.SkipZigTest;
}

/// The points a stream stops at before the seeded test of stopped streams starts both loops: from
/// early, where few chains are long, to late, one every `stop_step` octets.
const stop_first = 1000;
const stop_step = 1500;
const stop_count = 40;

test "the dear assembly continues a stream the Zig loop stopped, a waiting match's included" {
    if (comptime runs) {
        var input: [input_len]u8 = undefined;
        var matcher: Matcher = undefined;
        var block: Block = undefined;
        var three: Three = undefined;
        var waited_three: usize = 0;
        for (kinds) |kind| {
            fill(&input, kind, 7);
            for (0..stop_count) |index| {
                const point = stop_first + index * stop_step;
                start(&matcher, &block, &three, &input);
                matcher.filled = point;
                dear.advance_lazy_zig(level, &matcher, &block, &three);
                matcher.filled = input.len;
                waited_three += @intFromBool(matcher.waiting and matcher.previous.len == constants.match_len_min);
                try expect_same(&matcher, &block, &three);
            }
        }
        // A match of 3 octets waits at some points.
        try testing.expect(waited_three > 0);
    } else return error.SkipZigTest;
}

/// The symbols a nearly full block has room for: 1 to `rooms_few`, and `room_most`.
const rooms_few = 3;
const room_most = 100;

test "the dear assembly stops at a full block as the Zig loop does" {
    if (comptime runs) {
        var input: [input_len]u8 = undefined;
        var matcher: Matcher = undefined;
        var block: Block = undefined;
        var three: Three = undefined;
        for ([_]Kind{ .{ .letters = letters_all }, .{ .copies = letters_english } }) |kind| {
            fill(&input, kind, 11);
            for ([_]u16{ 1, rooms_few - 1, rooms_few, room_most }) |room| {
                start(&matcher, &block, &three, &input);
                block.symbol_count = constants.block_symbols_max - room;
                try expect_same(&matcher, &block, &three);
            }
        }
    } else return error.SkipZigTest;
}

test "fuzz the dear assembly against the Zig loop" {
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
        var three: Three = undefined;
        start(&matcher, &block, &three, input[0..len]);
        try expect_same(&matcher, &block, &three);
    }
}

/// The octets the test of the reach's edge copies, which its two seeded letters never hold.
const edge_pattern = "FARTHEST CANDIDATE 0123456789";
/// How far before the copy that test puts the pattern's first 3 octets with a fourth that
/// differs: the 3-octet table's nearest candidate, which holds 3 of the copy's octets and not 4.
const edge_partial_back = 100;

test "the dear assembly searches where only the chain's nearest candidate at the reach's edge holds 4 octets" {
    if (comptime runs) {
        var input: [input_len]u8 = undefined;
        var matcher: Matcher = undefined;
        var block: Block = undefined;
        var three: Three = undefined;
        const first = 1;
        // Two letters code in few symbols, so the block holds every position to the copy.
        fill(&input, .{ .letters = letters_two }, 19);
        const copy = first + constants.encoder_distance_max;
        @memcpy(input[first..][0..edge_pattern.len], edge_pattern);
        @memcpy(input[copy..][0..edge_pattern.len], edge_pattern);
        @memcpy(input[copy - edge_partial_back ..][0..constants.match_len_min], edge_pattern[0..constants.match_len_min]);
        input[copy - edge_partial_back + constants.match_len_min] = 'Z';
        start(&matcher, &block, &three, &input);
        try expect_same(&matcher, &block, &three);
    } else return error.SkipZigTest;
}
