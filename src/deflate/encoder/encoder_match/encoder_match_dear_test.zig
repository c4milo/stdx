//! Tests of `encoder_match_dear.zig`: what the steps of a block that takes 3-octet matches decide,
//! over inputs of octets that do not repeat but where a scene plants a repeat. Each scene runs
//! with input enough after it that the loop of the positions with the whole lookahead decides
//! it, and again with little after it, where the steps of a stream's last positions do.

const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const block_module = @import("../encoder_block.zig");
const Block = block_module.Block;
const Symbol = block_module.Symbol;
const match = @import("encoder_match.zig");
const Matcher = match.Matcher;
const Three = @import("encoder_match_three.zig").Three;
const nearest_holds = @import("encoder_match_dear.zig").nearest_holds;

/// The levels that take 3-octet matches, the lazy ones: level 6, whose searches run inline over
/// a padded window, and level 9. A scene runs at each.
const lazy_levels = levels: {
    var list: []const u4 = &.{};
    for (constants.encoder_levels) |number| {
        if (constants.level(number).three) list = list ++ &[_]u4{number};
    }
    break :levels list[0..list.len].*;
};

/// The level whose `lazy_len` a waiting match can reach.
const short_level_number = 6;

/// The octets of a scene, and what follows it: more than the lookahead after them all, so the
/// loop decides the scene, or a few octets after its last plant, so the last positions' steps
/// do.
const scene_len = 1_200;
const tail_slack = 64;
const tail_long = constants.lookahead_min + tail_slack;
const tail_short = 8;
const tails = [_]usize{ tail_long, tail_short };
const input_len_max = scene_len + tail_long;

/// The most pairs a scene's block holds.
const pairs_max = 8;

/// The seed of the scenes' octets.
const octets_seed = 41;

/// One repeat a scene plants: `text` at `at`, a copy of the octets `distance` before it, which
/// the scene plants too.
const Plant = struct { at: usize, text: []const u8, distance: usize };

/// Octets a scene writes as they are, after its plants.
const Raw = struct { at: usize, text: []const u8 };

/// Fills `input` with seeded octets, plants each repeat, source first, and writes each raw text.
/// Octets after a planted text are flipped where they would lengthen the repeat.
fn build(input: []u8, plants: []const Plant, raws: []const Raw) void {
    var generator = codec.split.Generator.init(octets_seed);
    for (input) |*octet| octet.* = @truncate(generator.next());
    for (plants) |plant| {
        @memcpy(input[plant.at - plant.distance ..][0..plant.text.len], plant.text);
        @memcpy(input[plant.at..][0..plant.text.len], plant.text);
        const after = plant.at + plant.text.len;
        if (input[after] == input[after - plant.distance]) input[after] ^= std.math.maxInt(u8);
    }
    for (raws) |raw| @memcpy(input[raw.at..][0..raw.text.len], raw.text);
}

/// The octets a scene uses with each tail: all of them and the long tail, or up to its last
/// plant and the short one.
fn used_len(plants: []const Plant, tail: usize) usize {
    if (tail == tail_long) return scene_len + tail_long;
    var end: usize = scene_len / scene_parts;
    for (plants) |plant| end = @max(end, plant.at + plant.text.len);
    return end + tail;
}

/// A scene with no plant still holds this share of `scene_len` under the short tail.
const scene_parts = 4;

/// How many positions of `input` hold 3 octets that an earlier position holds too.
fn repeats(input: []const u8) usize {
    var count: usize = 0;
    for (constants.match_len_min..input.len - constants.match_len_min + 1) |later| {
        for (0..later) |earlier| {
            if (std.mem.eql(u8, input[earlier..][0..constants.match_len_min], input[later..][0..constants.match_len_min])) {
                count += 1;
                break;
            }
        }
    }
    return count;
}

/// What the steps decide over `input`: the block's symbols, with `three` live from the start
/// over a table of zeros.
fn decide(comptime level_number: u4, input: []const u8, block: *Block, three: *Three) !void {
    const level = comptime constants.level(level_number);
    var matcher: Matcher(level) = undefined;
    matcher.init();
    try testing.expectEqual(input.len, matcher.fill(input));
    three.start();
    three.live = true;
    @memset(&three.heads, 0);
    block.reset(0);
    matcher.advance_dear(block, true, three);
    try testing.expect(matcher.settle(block));
    try testing.expectEqual(input.len, block.input_len);
}

/// The block's pairs, in order: the octet each starts at, its length and its distance.
const Pair = struct { at: usize, len: usize, distance: usize };

fn pairs_of(block: *const Block, buffer: []Pair) []Pair {
    var count: usize = 0;
    var at: usize = 0;
    for (block.symbols[0..block.symbol_count]) |symbol| {
        if (symbol.distance == 0) {
            at += 1;
            continue;
        }
        const len = @as(usize, symbol.value) + constants.match_len_min;
        buffer[count] = .{ .at = at, .len = len, .distance = symbol.distance };
        count += 1;
        at += len;
    }
    return buffer[0..count];
}

/// Runs a scene at both lazy levels and with both tails, and requires the block's pairs to be
/// `expected`, every other octet a literal.
fn expect_pairs(plants: []const Plant, planted_repeats: usize, expected: []const Pair) !void {
    try expect_scene(plants, &.{}, planted_repeats, expected);
}

fn expect_scene(plants: []const Plant, raws: []const Raw, planted_repeats: usize, expected: []const Pair) !void {
    inline for (lazy_levels) |level_number| {
        for (tails) |tail| {
            var input: [input_len_max]u8 = undefined;
            build(&input, plants, raws);
            const used = input[0..used_len(plants, tail)];
            // The scene's octets hold the repeats it plants and no other.
            try testing.expectEqual(planted_repeats, repeats(used));
            var block: Block = undefined;
            var three: Three = undefined;
            try decide(level_number, used, &block, &three);
            var buffer: [pairs_max]Pair = undefined;
            try testing.expectEqualSlices(Pair, expected, pairs_of(&block, &buffer));
        }
    }
}

test "octets that do not repeat are all literals" {
    try expect_pairs(&.{}, 0, &.{});
}

test "a repeat of 3 octets is a match where no longer one starts" {
    try expect_pairs(&.{.{ .at = 700, .text = "abc", .distance = 100 }}, 1, &.{.{ .at = 700, .len = 3, .distance = 100 }});
}

test "a repeat of 4 octets is the search's match, as in any block" {
    // The 3 octets from 701 repeat too.
    try expect_pairs(&.{.{ .at = 700, .text = "abcd", .distance = 100 }}, 2, &.{.{ .at = 700, .len = 4, .distance = 100 }});
}

test "a 3-octet match gives way to a longer match at the next position that scores more" {
    // "abc" 100 back, and from the next octet "bcdefg" 300 back: 6 octets less a penalty of 1
    // score more than 3 less 1.
    const plants = [_]Plant{
        .{ .at = 701, .text = "bcdefg", .distance = 300 },
        .{ .at = 700, .text = "abc", .distance = 100 },
    };
    // The repeats: "abc", and the 4 strings of 3 octets in "bcdefg".
    try expect_pairs(&plants, 5, &.{.{ .at = 701, .len = 6, .distance = 300 }});
}

test "a 3-octet match is kept over a match at the next position that scores no more" {
    // "abc" 20 back scores 3; "bcde" 600 back, from the next octet, scores 4 less a penalty of 2.
    const plants = [_]Plant{
        .{ .at = 701, .text = "bcde", .distance = 600 },
        .{ .at = 700, .text = "abc", .distance = 20 },
    };
    try expect_pairs(&plants, 3, &.{.{ .at = 700, .len = 3, .distance = 20 }});
}

test "a 3-octet match that waits is taken, whatever 3 octets the next position repeats" {
    // "abc" 100 back scores 2. From the next octet "bcQ" repeats 10 back, which would score 3:
    // while a 3-octet match waits the table gives no other.
    const plants = [_]Plant{
        .{ .at = 701, .text = "bcQ", .distance = 10 },
        .{ .at = 700, .text = "abc", .distance = 100 },
    };
    try expect_pairs(&plants, 2, &.{.{ .at = 700, .len = 3, .distance = 100 }});
}

/// 4 octets with the 15-bit hash of "abcd", and 4 with that of "xyzQ": a chain names them as it
/// names the text. And 3 octets with the 3-octet table's hash of "abc".
const abcd_twin = "\x80\x80\xa7\xa8";
const xyzq_twin = "\x80\x87\x85\x8c";
const abc_twin = "\x80\x95\x8d";

test "the twins hold the hashes of the texts they stand for" {
    inline for (lazy_levels) |level_number| {
        const level = comptime constants.level(level_number);
        const hash = match.hash_of_word;
        try testing.expectEqual(hash(level, std.mem.readInt(u32, "abcd", .little)), hash(level, std.mem.readInt(u32, abcd_twin, .little)));
        try testing.expectEqual(hash(level, std.mem.readInt(u32, "xyzQ", .little)), hash(level, std.mem.readInt(u32, xyzq_twin, .little)));
    }
    var three: Three = undefined;
    @memset(&three.heads, 0);
    _ = three.insert(true, std.mem.readInt(u32, abc_twin ++ "?", .little), 1);
    try testing.expectEqual(@as(u16, 1), three.insert(true, std.mem.readInt(u32, "abc?", .little), 2));
}

test "the table's candidate starts a search where the chain's nearest candidate holds other octets" {
    // "abcd" repeats 100 back, and a twin of its hash stands between: the chain names the twin
    // first, and the table names the repeat.
    const plants = [_]Plant{.{ .at = 700, .text = "abcd", .distance = 100 }};
    try expect_scene(&plants, &.{.{ .at = 650, .text = abcd_twin }}, 2, &.{.{ .at = 700, .len = 4, .distance = 100 }});
}

test "the chain's nearest candidate starts a search where the table names other octets" {
    // "abcd" repeats 100 back, and a twin of the table's hash of "abc" stands between: the
    // table names the twin, and the chain names the repeat.
    const plants = [_]Plant{.{ .at = 700, .text = "abcd", .distance = 100 }};
    try expect_scene(&plants, &.{.{ .at = 650, .text = abc_twin }}, 2, &.{.{ .at = 700, .len = 4, .distance = 100 }});
}

test "after a match of 4 octets the next position searches its whole chain" {
    // "wxyz" repeats 50 back, where 'A' follows it. From the next octet "xyzQRSTU" repeats 300
    // back, behind a twin of the hash of "xyzQ" on the chain, while the table names the "xyz" of
    // 50 back: neither candidate holds the 4 octets, and the search finds the 8.
    const plants = [_]Plant{
        .{ .at = 701, .text = "xyzQRSTU", .distance = 300 },
        .{ .at = 700, .text = "wxyz", .distance = 50 },
    };
    const raws = [_]Raw{ .{ .at = 500, .text = xyzq_twin }, .{ .at = 654, .text = "A" } };
    // The repeats: the 7 strings of 3 octets from 700, and "xyz" at 651, a 3-octet match too.
    const expected = [_]Pair{ .{ .at = 651, .len = 3, .distance = 250 }, .{ .at = 701, .len = 8, .distance = 300 } };
    try expect_scene(&plants, &raws, 8, &expected);
}

/// The scene of `lazy_len`: a phrase of octets that repeat nowhere else, `waiting_rest` longer
/// than the match that waits at its start, and before it, apart, the phrase from its second
/// octet and its first octets, as `encoder_limits_test.zig` builds it for the other blocks.
const waiting_rest = 3;
const waiting_gap = 8;
const waiting_at = 400;

/// The pairs of the scene at a level, the phrase's first `waiting_len` octets waiting at
/// `waiting_at`.
fn waiting_pairs(comptime level_number: u4, waiting_len: usize, buffer: []Pair) ![]Pair {
    var input: [input_len_max]u8 = undefined;
    build(&input, &.{}, &.{});
    const phrase_len = waiting_len + waiting_rest;
    var phrase: [constants.match_len_max]u8 = undefined;
    @memcpy(phrase[0..phrase_len], input[waiting_at..][0..phrase_len]);
    const first = waiting_at - waiting_gap - waiting_len;
    const second = first - waiting_gap - (phrase_len - 1);
    @memcpy(input[first..][0..waiting_len], phrase[0..waiting_len]);
    @memcpy(input[second..][0 .. phrase_len - 1], phrase[1..phrase_len]);
    var block: Block = undefined;
    var three: Three = undefined;
    try decide(level_number, &input, &block, &three);
    return pairs_of(&block, buffer);
}

/// The first of `pairs` that starts at `at` or one octet after it.
fn pair_near(pairs: []const Pair, at: usize) ?Pair {
    for (pairs) |pair| {
        if (pair.at == at or pair.at == at + 1) return pair;
    }
    return null;
}

test "a match of lazy_len octets is taken with no search at the next position, and one shorter is not" {
    // Level 6 takes a waiting match of 32 octets at once. Behind one of 31 it searches the next
    // position, which holds 33. The phrase's last 3 octets are a match of their own after the
    // first, and part of the second.
    if (comptime !constants.level(short_level_number).three) return error.SkipZigTest;
    var buffer: [pairs_max]Pair = undefined;
    const long = try waiting_pairs(short_level_number, 32, &buffer);
    try testing.expectEqual(Pair{ .at = waiting_at, .len = 32, .distance = 40 }, pair_near(long, waiting_at).?);
    const short = try waiting_pairs(short_level_number, 31, &buffer);
    try testing.expectEqual(Pair{ .at = waiting_at + 1, .len = 33, .distance = 81 }, pair_near(short, waiting_at).?);
}

test "the positions a 3-octet match covers join the table and the chains" {
    // "abc" at 700 is a match, and "XYZ" follows it. The 3 octets from 701, inside the match,
    // repeat at 800, where the table names 701. The 4 from 702 repeat at 900, where the chain
    // names 702. The last plant keeps its octets, so the match is planted last.
    const plants = [_]Plant{
        .{ .at = 900, .text = "cXYZ", .distance = 198 },
        .{ .at = 800, .text = "bcX", .distance = 99 },
        .{ .at = 700, .text = "abc", .distance = 100 },
    };
    const expected = [_]Pair{
        .{ .at = 700, .len = 3, .distance = 100 },
        .{ .at = 800, .len = 3, .distance = 99 },
        .{ .at = 900, .len = 4, .distance = 198 },
    };
    // The repeats: "abc", "bcX", and "cXY" and "XYZ" of the 4 octets.
    try expect_pairs(&plants, 4, &expected);
}

test "each 3-octet match taken is counted for the table's verdict, and no longer match is" {
    const plants = [_]Plant{
        .{ .at = 500, .text = "abc", .distance = 100 },
        .{ .at = 600, .text = "abd", .distance = 50 },
        .{ .at = 750, .text = "wxyz", .distance = 60 },
    };
    var input: [input_len_max]u8 = undefined;
    build(&input, &plants, &.{});
    inline for (lazy_levels) |level_number| {
        var block: Block = undefined;
        var three: Three = undefined;
        try decide(level_number, &input, &block, &three);
        var buffer: [pairs_max]Pair = undefined;
        try testing.expectEqual(@as(usize, 3), pairs_of(&block, &buffer).len);
        var counted: u32 = 0;
        for (three.octets) |count| counted += count;
        try testing.expectEqual(@as(u32, 2 * constants.match_len_min), counted);
        try testing.expectEqual(@as(u16, 2), three.octets['a']);
        try testing.expectEqual(@as(u16, 2), three.octets['b']);
        try testing.expectEqual(@as(u16, 1), three.octets['c']);
        try testing.expectEqual(@as(u16, 1), three.octets['d']);
        try testing.expectEqual(@as(u16, 1), three.distances[block_module.distance_code(true, 100)]);
        try testing.expectEqual(@as(u16, 1), three.distances[block_module.distance_code(true, 50)]);
        var distances: u32 = 0;
        for (three.distances) |count| distances += count;
        try testing.expectEqual(@as(u32, 2), distances);
    }
}

/// The scene of the reach: its octets, under this value, and the planted text's, above it, so
/// the text repeats nowhere else.
const reach_octets = 128;
const reach_text = "\xc8\xc9\xca".*;
const reach_before = 2_000;
const reach_position = constants.three_distance_max + reach_before;

/// How many of the block's pairs start at the octet `position`: 1 or none.
fn pairs_at(block: *const Block, position: usize) usize {
    var buffer: [constants.block_symbols_max]Pair = undefined;
    var count: usize = 0;
    for (pairs_of(block, &buffer)) |pair| count += @intFromBool(pair.at == position);
    return count;
}

/// The scene of the reach at one level: a window's worth of octets with one repeat of 3,
/// `distance` back from `reach_position`. Returns whether a pair starts there.
fn reach_taken(comptime level_number: u4, distance: usize) !bool {
    var input: [reach_position + tail_long]u8 = undefined;
    var generator = codec.split.Generator.init(octets_seed);
    for (&input) |*octet| octet.* = @intCast(generator.below(reach_octets));
    @memcpy(input[reach_position - distance ..][0..reach_text.len], &reach_text);
    @memcpy(input[reach_position..][0..reach_text.len], &reach_text);
    // The octets after the two differ, so the repeat holds 3 octets and no more.
    input[reach_position - distance + reach_text.len] = 0;
    input[reach_position + reach_text.len] = 1;
    var block: Block = undefined;
    var three: Three = undefined;
    try decide(level_number, &input, &block, &three);
    return pairs_at(&block, reach_position) == 1;
}

test "a 3-octet match reaches 8,191 octets back and no farther" {
    inline for (lazy_levels) |level_number| {
        try testing.expect(try reach_taken(level_number, 8_191));
        try testing.expect(!try reach_taken(level_number, 8_192));
        try testing.expect(try reach_taken(level_number, 1_000));
    }
}

/// Whether the chain's nearest candidate holds a position's octets, `distance` back and holding
/// `held`, in a window of zeros whose position holds "abcd".
fn nearest_at(comptime level_number: u4, position: usize, distance: usize, held: *const [constants.hash_len]u8) bool {
    const level = comptime constants.level(level_number);
    var matcher: Matcher(level) = undefined;
    matcher.init();
    @memset(&matcher.window, 0);
    @memset(&matcher.chain, 0);
    @memcpy(matcher.window[position..][0..constants.hash_len], "abcd");
    @memcpy(matcher.window[position - distance ..][0..constants.hash_len], held);
    matcher.chain[match.slot(position)] = @intCast(position - distance);
    return nearest_holds(level, &matcher, position, std.mem.readInt(u32, "abcd", .little));
}

test "the chain's nearest candidate holds a position's octets within a match's reach, position 0 never" {
    const position = 40_000;
    inline for (lazy_levels) |level_number| {
        try testing.expect(nearest_at(level_number, position, 1, "abcd"));
        try testing.expect(nearest_at(level_number, position, constants.encoder_distance_max, "abcd"));
        try testing.expect(!nearest_at(level_number, position, constants.encoder_distance_max + 1, "abcd"));
        try testing.expect(!nearest_at(level_number, position, 1, "abcX"));
        try testing.expect(!nearest_at(level_number, position, 1, "Xbcd"));
        try testing.expect(nearest_at(level_number, 100, 99, "abcd"));
        try testing.expect(!nearest_at(level_number, 100, 100, "abcd"));
    }
}
