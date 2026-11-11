//! Tests of the match a lazy step holds (decision 72, `encoder_match_score.zig`): what level 9
//! decides at the second position after a match, that a block which takes 3-octet matches holds
//! none and decides one held before it, that the gate stops the holds, and that level 6 holds no
//! match. The scenes are `encoder_match_dear_test.zig`'s: octets that do not repeat, where a scene
//! plants its repeats, run with input enough after them that the loop decides them, and again
//! with little, where the last positions' steps do.

const std = @import("std");
const testing = std.testing;
const constants = @import("../../constants.zig");
const block_module = @import("../encoder_block.zig");
const Block = block_module.Block;
const match = @import("encoder_match.zig");
const Matcher = match.Matcher;
const Match = match.Match;
const score = @import("encoder_match_score.zig");
const Three = @import("encoder_match_three.zig").Three;
const scenes = @import("encoder_match_dear_test.zig");
const Plant = scenes.Plant;
const Pair = scenes.Pair;

/// The level that holds a match, and the lazy level that holds none.
const holding = 9;
const plain = 6;

comptime {
    std.debug.assert(constants.level(holding).second and !constants.level(plain).second);
}

/// What the steps of a block of no special kind decide over `input`, the gate as `live` says.
fn decide_plain(comptime level_number: u4, input: []const u8, block: *Block, live: bool) !void {
    const level = comptime constants.level(level_number);
    var matcher: Matcher(level) = undefined;
    matcher.init();
    if (level.second) matcher.gate.live = live;
    try testing.expectEqual(input.len, matcher.fill(input));
    block.reset(0);
    matcher.advance(block, true);
    try testing.expect(matcher.settle(block));
    try testing.expectEqual(input.len, block.input_len);
}

/// Which steps decide a scene: those of a block of no special kind, with the gate live or not,
/// or those of a block that takes 3-octet matches.
const Steps = enum { live, stopped, dear };

/// Runs a scene at `level_number` with both tails and requires the block's pairs to be `expected`.
fn expect_pairs(comptime level_number: u4, steps: Steps, plants: []const Plant, expected: []const Pair) !void {
    for (scenes.tails) |tail| {
        var input: [scenes.input_len_max]u8 = undefined;
        scenes.build(&input, plants, &.{});
        const used = input[0..scenes.used_len(plants, tail)];
        var block: Block = undefined;
        var buffer: [scenes.pairs_max]Pair = undefined;
        if (steps == .dear) {
            var three: Three = undefined;
            try scenes.decide(level_number, used, &block, &three);
        } else {
            try decide_plain(level_number, used, &block, steps == .live);
        }
        try testing.expectEqualSlices(Pair, expected, scenes.pairs_of(&block, &buffer));
    }
}

/// A scene: "abcdefgh" at `held_at` repeats `held_distance` back, and from two positions on a
/// longer text of `second_len` octets, which starts with its "cdefgh", repeats `second_distance`
/// back. The second plant keeps its octets. The text `held_distance` back holds "cdefgh" too,
/// after the longer text's first copy: a match of 6.
const held_text = "abcdefgh";
const shared_text = "cdefgh";
const second_text = shared_text ++ "XYZWQRST";
const held_at = 700;
const held_distance = 100;
const second_distance = 300;
const held_pair: Pair = .{ .at = held_at, .len = held_text.len, .distance = held_distance };
const first_pair: Pair = .{ .at = held_at - held_distance + score.held_back, .len = shared_text.len, .distance = second_distance - held_distance };

/// The scene's plants: the longer text, then the held one.
const scene_plants = 2;

fn second_scene(comptime second_len: usize) [scene_plants]Plant {
    return .{
        .{ .at = held_at + score.held_back, .text = second_text[0..second_len], .distance = second_distance },
        .{ .at = held_at, .text = held_text, .distance = held_distance },
    };
}

/// What a step that holds no match decides over the whole scene: the match of 8, then the 8
/// octets of the longer text after it.
const unheld = [_]Pair{ first_pair, held_pair, .{ .at = held_at + held_text.len, .len = second_text.len - shared_text.len, .distance = second_distance } };

test "a held match gives way to a longer match two positions on, and two literals go before it" {
    // The match of 8 holds against the 7 octets that repeat from 701. From 702, 14 octets repeat:
    // 4 bits for each of 6 octets more, less 2 for the distance's bit length, pass the margin.
    const plants = second_scene(second_text.len);
    try expect_pairs(holding, .live, &plants, &.{ first_pair, .{ .at = 702, .len = 14, .distance = 300 } });
}

test "a held match is taken unless the match two positions on scores more than 6 bits past it" {
    // The held match scores 4 * 8 less 7, the bit length of 100. A match 300 back loses 9. With
    // 10 octets it scores 6 more, which does not pass the margin, and with 11 it scores 10 more.
    const even = second_scene(10);
    try expect_pairs(holding, .live, &even, &.{ first_pair, held_pair, .{ .at = 708, .len = 4, .distance = 300 } });
    const past = second_scene(11);
    try expect_pairs(holding, .live, &past, &.{ first_pair, .{ .at = 702, .len = 11, .distance = 300 } });
}

test "a step holds no match at level 6, behind a stopped gate, or in a block of 3-octet matches" {
    const plants = second_scene(second_text.len);
    try expect_pairs(plain, .live, &plants, &unheld);
    try expect_pairs(plain, .dear, &plants, &unheld);
    try expect_pairs(holding, .stopped, &plants, &unheld);
    try expect_pairs(holding, .dear, &plants, &unheld);
}

/// The symbols the scene's block holds when the step decides the match at `held_at`: a literal
/// for each octet before it, less the 5 that the match of 6 covers beyond its own symbol.
const symbols_before: u16 = held_at - (first_pair.len - 1);

test "a block with room for one symbol before its limit holds no match" {
    // With room for two symbols the step holds the match of 8, and the two literals before the
    // longer match fill the block to its limit. With room for one it takes the match of 8.
    const plants = second_scene(second_text.len);
    var input: [scenes.input_len_max]u8 = undefined;
    scenes.build(&input, &plants, &.{});
    const level = comptime constants.level(holding);
    for ([_]u16{ 1, 2 }) |room| {
        var matcher: Matcher(level) = undefined;
        matcher.init();
        matcher.gate.live = true;
        try testing.expectEqual(input.len, matcher.fill(&input));
        var block: Block = undefined;
        block.reset(0);
        block.limit = symbols_before + room;
        matcher.advance(&block, false);
        try testing.expectEqual(block.limit, block.symbol_count);
        const last = block.symbols[block.symbol_count - 1];
        if (room == 1) {
            try testing.expectEqual(@as(u16, held_pair.distance), last.distance);
            try testing.expectEqual(@as(u8, held_pair.len - constants.match_len_min), last.value);
        } else {
            try testing.expectEqual(@as(u16, 0), last.distance);
            try testing.expectEqual(@as(u8, 'b'), last.value);
            try testing.expectEqual(@as(u8, 'a'), block.symbols[block.symbol_count - 2].value);
        }
    }
}

/// The octets the last positions' steps see after the scene's plants.
const short_tail = 8;

test "a block that takes 3-octet matches decides the match the block before it held" {
    // The loop of a plain block decides the positions up to 701, where it holds the match of 8:
    // position 702 has no lookahead yet. The steps of a block of 3-octet matches go on from
    // there, their loop with the whole input and their last positions' steps with little of it.
    const level = comptime constants.level(holding);
    inline for (.{ second_text.len, 10 }, .{ &[_]Pair{ first_pair, .{ .at = 702, .len = 14, .distance = 300 } }, &[_]Pair{ first_pair, held_pair, .{ .at = 708, .len = 4, .distance = 300 } } }) |second_len, expected| {
        const plants = second_scene(second_len);
        for ([_]bool{ true, false }) |whole| {
            var input: [scenes.input_len_max]u8 = undefined;
            scenes.build(&input, &plants, &.{});
            var matcher: Matcher(level) = undefined;
            matcher.init();
            matcher.gate.live = true;
            const shown = held_at + 1 + constants.lookahead_min;
            try testing.expectEqual(shown, matcher.fill(input[0..shown]));
            var block: Block = undefined;
            block.reset(0);
            matcher.advance(&block, false);
            try testing.expect(matcher.held and matcher.waiting);
            try testing.expectEqual(@as(usize, held_at + 2), matcher.position);
            // No symbol covers the held match's octets yet.
            try testing.expectEqual(@as(usize, held_at), matcher.pending_start());
            try testing.expectEqual(Match{ .len = held_pair.len, .distance = held_pair.distance }, matcher.previous);
            // The rest of the input, or an input that ends soon after the plants.
            if (whole) {
                try testing.expectEqual(input.len - shown, matcher.fill(input[shown..]));
            } else {
                matcher.filled = held_at + 2 + second_len + short_tail;
            }
            var three: Three = undefined;
            three.start();
            three.live = true;
            @memset(&three.heads, 0);
            matcher.advance_dear(&block, true, &three);
            try testing.expect(matcher.settle(&block));
            try testing.expectEqual(matcher.filled, block.input_len);
            try expect_symbols_give(input[0..matcher.filled], &block);
            var buffer: [scenes.pairs_max]Pair = undefined;
            try testing.expectEqualSlices(Pair, expected, scenes.pairs_of(&block, &buffer));
            // The held match is counted once, as a win or not.
            try testing.expectEqual(@as(u32, @intFromBool(second_len == second_text.len)), matcher.gate.wins);
        }
    }
}

/// Requires the block's symbols to give back `input`: each literal its octet, and each pair the
/// octets its distance back.
fn expect_symbols_give(input: []const u8, block: *const Block) !void {
    var at: usize = 0;
    for (block.symbols[0..block.symbol_count]) |symbol| {
        if (symbol.distance == 0) {
            try testing.expectEqual(input[at], symbol.value);
            at += 1;
            continue;
        }
        const len = @as(usize, symbol.value) + constants.match_len_min;
        for (at..at + len) |index| try testing.expectEqual(input[index - symbol.distance], input[index]);
        at += len;
    }
    try testing.expectEqual(input.len, at);
}

test "a held match is counted once, as a win or not, in the loop and in the last positions' steps" {
    // With the long tail the loop decides the match held at the scene's start, and with the
    // short one the last positions' steps do. Only the match at `held_at` loses to the second
    // position's, and only in the scene of the longer text.
    const level = comptime constants.level(holding);
    inline for (.{ second_text.len, 10 }) |second_len| {
        const plants = second_scene(second_len);
        for (scenes.tails) |tail| {
            var input: [scenes.input_len_max]u8 = undefined;
            scenes.build(&input, &plants, &.{});
            const used = input[0..scenes.used_len(&plants, tail)];
            var matcher: Matcher(level) = undefined;
            matcher.init();
            matcher.gate.live = true;
            try testing.expectEqual(used.len, matcher.fill(used));
            var block: Block = undefined;
            block.reset(0);
            matcher.advance(&block, true);
            try testing.expect(matcher.settle(&block));
            try expect_symbols_give(used, &block);
            try testing.expect(matcher.gate.holds > matcher.gate.wins);
            try testing.expectEqual(@as(u32, @intFromBool(second_len == second_text.len)), matcher.gate.wins);
        }
    }
}

test "a block that holds no match compares as the level did before, and one that holds compares by bits" {
    // "abcd" at 700 repeats 40 back, and from the next octet "bcde" repeats 10 back. By score, 4
    // less a penalty of 1 loses to 4 less none. By bits, 16 less 6 is not passed by 16 less 4 by
    // more than 2: the waiting match stays.
    const plants = [_]Plant{
        .{ .at = held_at + 1, .text = near_text, .distance = near_distance },
        .{ .at = held_at, .text = far_text, .distance = far_distance },
    };
    try expect_pairs(holding, .stopped, &plants, &.{.{ .at = held_at + 1, .len = near_text.len, .distance = near_distance }});
    try expect_pairs(holding, .live, &plants, &.{.{ .at = held_at, .len = far_text.len, .distance = far_distance }});
}

/// The scene of the compare: "abcd" far back, and from its second octet "bcde" near.
const far_text = "abcd";
const far_distance = 40;
const near_text = "bcde";
const near_distance = 10;

comptime {
    std.debug.assert(far_text.len == near_text.len);
}

/// A match of 8 octets, taken just before `round_limit`: the first round ends after it, with no
/// match waiting.
const early_plant: Plant = .{ .at = round_limit - early_text.len, .text = early_text, .distance = early_distance };
const early_text = "JKLMNOPQ";
const early_distance = 50;

/// A block limit that ends the scene's first round after the early match, and its second just
/// after the step holds the match at `held_at`, two symbols below the limit: the third round starts
/// with that match held.
const round_limit = 690;

test "a round that starts with a match held shows the positions the held match leaves room for" {
    const plants = [_]Plant{early_plant} ++ second_scene(second_text.len);
    var input: [scenes.input_len_max]u8 = undefined;
    scenes.build(&input, &plants, &.{});
    const level = comptime constants.level(holding);
    var matcher: Matcher(level) = undefined;
    matcher.init();
    matcher.gate.live = true;
    try testing.expectEqual(input.len, matcher.fill(&input));
    var block: Block = undefined;
    block.reset(0);
    block.limit = round_limit;
    matcher.advance(&block, false);
    // The two literals before the longer match fill the block to its limit, and the longer match
    // waits: the block covers every octet before it.
    try testing.expectEqual(block.limit, block.symbol_count);
    try testing.expectEqual(@as(u8, 'b'), block.symbols[block.symbol_count - 1].value);
    try testing.expectEqual(@as(u8, 'a'), block.symbols[block.symbol_count - 2].value);
    try testing.expectEqual(matcher.pending_start(), block.input_len);
    try testing.expectEqual(@as(usize, held_at + score.held_back), block.input_len);
    try expect_symbols_give(input[0..block.input_len], &block);
}

/// Sets `gate` one held match short of its check, with no win, so the first held match it counts
/// stops the block's holds.
fn stop_at_next(gate: *align(1) score.Gate) void {
    gate.live = true;
    gate.holds = constants.second_check_holds - 1;
    gate.wins = 0;
}

/// What the steps of a plain block decide over `input`, the gate one held match short of
/// stopping.
fn decide_stopping(input: []const u8, block: *Block) !void {
    const level = comptime constants.level(holding);
    var matcher: Matcher(level) = undefined;
    matcher.init();
    stop_at_next(&matcher.gate);
    try testing.expectEqual(input.len, matcher.fill(input));
    block.reset(0);
    matcher.advance(block, true);
    try testing.expect(matcher.settle(block));
    try testing.expect(!matcher.gate.live);
}

/// Runs a scene with both tails through `decide_stopping`, and requires its pairs.
fn expect_stopping(plants: []const Plant, expected: []const Pair) !void {
    for (scenes.tails) |tail| {
        var input: [scenes.input_len_max]u8 = undefined;
        scenes.build(&input, plants, &.{});
        const used = input[0..scenes.used_len(plants, tail)];
        var block: Block = undefined;
        try decide_stopping(used, &block);
        try expect_symbols_give(used, &block);
        var buffer: [scenes.pairs_max]Pair = undefined;
        try testing.expectEqualSlices(Pair, expected, scenes.pairs_of(&block, &buffer));
    }
}

test "a block whose gate stops holds no more matches" {
    // The match of 6 is held, and its verdict stops the gate: the match of 8 is not held.
    const plants = second_scene(second_text.len);
    try expect_stopping(&plants, &unheld);
}

/// A match of 8 octets well before the scene of `compare_plants`, whose held verdict stops the
/// gate.
const stopping_plant: Plant = .{ .at = stopping_at, .text = early_text, .distance = early_distance };
const stopping_at = 300;
const compare_plants = [_]Plant{
    stopping_plant,
    .{ .at = held_at + 1, .text = near_text, .distance = near_distance },
    .{ .at = held_at, .text = far_text, .distance = far_distance },
};

test "a block whose gate stops compares as the level did before" {
    // Behind a live gate "abcd" 40 back stays over "bcde" 10 back, by bits. Once the gate stops,
    // the score drops it.
    try expect_stopping(&compare_plants, &.{
        .{ .at = stopping_plant.at, .len = early_text.len, .distance = early_distance },
        .{ .at = held_at + 1, .len = near_text.len, .distance = near_distance },
    });
}

/// A repeat of the longer text's first 10 octets, whose nearest copy starts at the second
/// position: it is found there only when that position joined the chains.
const repeat_plant: Plant = .{ .at = repeat_at, .text = second_text[0..repeat_len], .distance = repeat_at - (held_at + score.held_back) };
const repeat_at = 900;
const repeat_len = 10;

test "a held match decided before a block's loop joins its position to the chains" {
    // The steps of a plain block that holds no match, or of a block of 3-octet matches, decide
    // the match held at `held_at`. The repeat at 900 then finds the second position.
    const level = comptime constants.level(holding);
    const plants = [_]Plant{repeat_plant} ++ second_scene(second_text.len);
    for ([_]bool{ false, true }) |dear| {
        var input: [scenes.input_len_max]u8 = undefined;
        scenes.build(&input, &plants, &.{});
        var matcher: Matcher(level) = undefined;
        matcher.init();
        matcher.gate.live = true;
        const shown = held_at + 1 + constants.lookahead_min;
        try testing.expectEqual(shown, matcher.fill(input[0..shown]));
        var block: Block = undefined;
        block.reset(0);
        matcher.advance(&block, false);
        try testing.expect(matcher.held);
        try testing.expectEqual(input.len - shown, matcher.fill(input[shown..]));
        matcher.gate.live = false;
        if (dear) {
            var three: Three = undefined;
            three.start();
            three.live = true;
            @memset(&three.heads, 0);
            matcher.advance_dear(&block, true, &three);
        } else {
            matcher.advance(&block, true);
        }
        try testing.expect(matcher.settle(&block));
        try expect_symbols_give(&input, &block);
        var buffer: [scenes.pairs_max]Pair = undefined;
        const pairs = scenes.pairs_of(&block, &buffer);
        try testing.expectEqual(Pair{ .at = repeat_plant.at, .len = repeat_len, .distance = repeat_plant.distance }, pairs[pairs.len - 1]);
    }
}

test "a block of 3-octet matches that starts with a match held shows the positions it leaves room for" {
    // The plain block holds the match at `held_at`. The block of 3-octet matches after it has
    // room for two symbols: the two literals before the longer match, which then waits.
    const level = comptime constants.level(holding);
    const plants = second_scene(second_text.len);
    var input: [scenes.input_len_max]u8 = undefined;
    scenes.build(&input, &plants, &.{});
    var matcher: Matcher(level) = undefined;
    matcher.init();
    matcher.gate.live = true;
    const shown = held_at + 1 + constants.lookahead_min;
    try testing.expectEqual(shown, matcher.fill(input[0..shown]));
    var block: Block = undefined;
    block.reset(0);
    matcher.advance(&block, false);
    try testing.expect(matcher.held);
    try testing.expectEqual(input.len - shown, matcher.fill(input[shown..]));
    block.limit = block.symbol_count + score.held_symbols_max;
    var three: Three = undefined;
    three.start();
    three.live = true;
    @memset(&three.heads, 0);
    matcher.advance_dear(&block, false, &three);
    try testing.expectEqual(block.limit, block.symbol_count);
    try testing.expectEqual(@as(u8, 'b'), block.symbols[block.symbol_count - 1].value);
    try testing.expectEqual(matcher.pending_start(), block.input_len);
    try expect_symbols_give(input[0..block.input_len], &block);
}

/// The compare's scene well after the second scene's held match, with octets of its own.
const later_compare_at = 900;
const later_far_text = "mnop";
const later_near_text = "nopq";
const later_compare_plants = [_]Plant{
    .{ .at = later_compare_at + 1, .text = later_near_text, .distance = near_distance },
    .{ .at = later_compare_at, .text = later_far_text, .distance = far_distance },
};

test "a round that starts with a match held behind a stopped gate holds no more and compares by score" {
    // The plain block holds the match at `held_at` and its gate then stops. The round that
    // decides it holds no match after it: at the compare's scene the score drops "mnop" 40 back.
    const level = comptime constants.level(holding);
    const plants = later_compare_plants ++ second_scene(second_text.len);
    var input: [scenes.input_len_max]u8 = undefined;
    scenes.build(&input, &plants, &.{});
    var matcher: Matcher(level) = undefined;
    matcher.init();
    matcher.gate.live = true;
    const shown = held_at + 1 + constants.lookahead_min;
    try testing.expectEqual(shown, matcher.fill(input[0..shown]));
    var block: Block = undefined;
    block.reset(0);
    matcher.advance(&block, false);
    try testing.expect(matcher.held);
    try testing.expectEqual(input.len - shown, matcher.fill(input[shown..]));
    matcher.gate.live = false;
    matcher.advance(&block, true);
    try testing.expect(matcher.settle(&block));
    try expect_symbols_give(&input, &block);
    var buffer: [scenes.pairs_max]Pair = undefined;
    const pairs = scenes.pairs_of(&block, &buffer);
    try testing.expectEqual(Pair{ .at = later_compare_at + 1, .len = later_near_text.len, .distance = near_distance }, pairs[pairs.len - 1]);
}
