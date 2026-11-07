//! The tests of decision 63's loops, on the target's own: the assembly and the Zig parse, on copies
//! of one matcher and one meta-block's commands, write the same commands, counts, last distances
//! and table entries, over seeded windows whose blocks lie before the reach and past it. The inputs
//! repeat earlier octets at distances the ring holds and at new ones, with literal runs and copies
//! of every length, those past the length tables among them.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const encoder = @import("../encoder.zig");
const encoder_commands = @import("../encoder_commands.zig");
const encoder_parse = @import("encoder_parse.zig");
const aarch64 = @import("encoder_parse_aarch64.zig");
const x86_64 = @import("encoder_parse_x86_64.zig");

const test_window_bits = constants.encoder_window_bits_min;
const level = encoder.Encoder(.{ .level = 1, .window_bits = test_window_bits }).finder_level;
const Matcher = codec.match_finder.Matcher(level);

/// Two meta-blocks: the first before the reach, the second past it.
const block_len = constants.encoder_meta_block_len_max;
const blocks = 2;
const window_len = block_len * blocks;

/// The seeds, and the pieces of an input: a run of literals or a copy, each up to `piece_len_max`
/// octets, which passes the length tables' 128; one copy in `ring_odds` reuses a recent distance.
const seeds = 6;
const piece_len_max = 300;
const copy_len_min = 4;
const ring_odds = 3;
const recent_distances = 4;
/// The octets a literal draws from: few, so short matches recur by chance too.
const literal_values = 6;

/// Literal costs in eighths of a bit, besides the first meta-block's 64: at 26, a match of 4
/// octets 2 or 3 back costs what its literals do, 104, which the cost rule refuses; at 24 and 40,
/// other lengths and distances tie.
const tie_cost = 26;
const cheap_cost = 24;
const dear_cost = 40;
const literal_costs = [_]u32{ constants.encoder_literal_cost_initial, tie_cost, cheap_cost, dear_cost };

/// State that outlives one test's stack frame. The `guard_octets` before the window are readable,
/// so a step back or a candidate before the window's start reads them, not another variable; the
/// last of them equals the octet a match at the window's start would step back onto.
const guard_octets = 16;
threadlocal var guarded: [guard_octets + window_len]u8 = undefined;
fn window() *[window_len]u8 {
    return guarded[guard_octets..];
}
/// The assembly's and the Zig parse's.
const sides = 2;
threadlocal var matchers: [sides]Matcher = undefined;
threadlocal var commands: [sides]encoder_commands.Commands = undefined;

test "the assembly writes the commands, counts and entries of the Zig parse" {
    if (comptime !aarch64.takes(level) and !x86_64.takes(level)) return error.SkipZigTest;
    for (0..seeds) |seed| {
        for (literal_costs) |cost| try expect_equal(seed, cost);
    }
}

fn expect_equal(seed: u64, literal_cost: u32) !void {
    var generator = codec.split.Generator.init(seed);
    fill(&generator);
    for (&matchers) |*matcher| matcher.init();
    for (&commands) |*each| each.init();
    for (0..blocks) |block| {
        const start = block * block_len;
        for (&commands) |*each| {
            each.reset();
            each.literal_cost = literal_cost;
        }
        encoder_parse.parse(level, true, &matchers[0], window(), start, start + block_len, &commands[0]);
        encoder_parse.parse_zig(level, true, &matchers[1], window(), start, start + block_len, &commands[1]);
        try expect_same(&commands[0], &commands[1]);
        try testing.expectEqualSlices(u8, std.mem.asBytes(&matchers[1]), std.mem.asBytes(&matchers[0]));
    }
}

test "no position names an octet before the window, where its range is empty" {
    if (comptime !aarch64.takes(level) and !x86_64.takes(level)) return error.SkipZigTest;
    // One octet throughout, before the window too, and every entry naming the octet just before
    // it: a candidate before the window, or the ring's first distances at the stream's first
    // positions, would find a match. The range of each position refuses them.
    @memset(&guarded, constant_octet);
    for (&matchers) |*matcher| {
        matcher.init();
        @memset(&matcher.short, matcher.base -% 1);
        @memset(&matcher.long, matcher.base -% 1);
    }
    for (&commands) |*each| each.init();
    for (&commands) |*each| each.reset();
    encoder_parse.parse(level, true, &matchers[0], window(), 0, block_len, &commands[0]);
    encoder_parse.parse_zig(level, true, &matchers[1], window(), 0, block_len, &commands[1]);
    try expect_same(&commands[0], &commands[1]);
    try testing.expectEqualSlices(u8, std.mem.asBytes(&matchers[1]), std.mem.asBytes(&matchers[0]));
}

/// The octet of the test above.
const constant_octet = 'a';

fn expect_same(got: *const encoder_commands.Commands, want: *const encoder_commands.Commands) !void {
    try testing.expectEqual(want.count, got.count);
    try testing.expectEqualSlices(u8, std.mem.sliceAsBytes(want.commands[0..want.count]), std.mem.sliceAsBytes(got.commands[0..got.count]));
    try testing.expectEqualSlices(u16, &want.literal_counts, &got.literal_counts);
    try testing.expectEqualSlices(u16, &want.command_counts, &got.command_counts);
    try testing.expectEqualSlices(u16, &want.distance_counts, &got.distance_counts);
    try testing.expectEqualSlices(u32, &want.last_distances, &got.last_distances);
    try testing.expectEqual(want.literals_len, got.literals_len);
    try testing.expectEqual(want.inserted, got.inserted);
}

/// Fills the window with runs of literals and copies of earlier octets.
fn fill(generator: *codec.split.Generator) void {
    var distances = [_]usize{1} ** recent_distances;
    var at: usize = 0;
    for (0..window_len) |_| {
        if (at == window_len) break;
        const len = @min(generator.between(1, piece_len_max), window_len - at);
        if (at < piece_len_max or generator.between(0, 1) == 0) {
            for (window()[at..][0..len]) |*octet| octet.* = @intCast(generator.between(0, literal_values - 1));
        } else {
            copy(at, @max(len, copy_len_min), next_distance(generator, &distances, at));
        }
        at = @min(window_len, at + @max(len, copy_len_min));
    }
    // The window's first octets again a little later, after a literal: the match there steps back
    // to the window's start, where the octet before it agrees too.
    @memcpy(window()[guard_at..][0..guard_len], window()[0..guard_len]);
    guarded[guard_octets - 1] = window()[guard_at - 1];
}

/// A copy's distance: one of the recent ones at `ring_odds`, else a new one, which joins them.
fn next_distance(generator: *codec.split.Generator, distances: *[recent_distances]usize, at: usize) usize {
    const reuse = generator.between(0, ring_odds - 1) == 0;
    const distance = if (reuse) distances[generator.between(0, recent_distances - 1)] else generator.between(1, at);
    std.mem.copyBackwards(usize, distances[1..], distances[0 .. recent_distances - 1]);
    distances[0] = distance;
    return distance;
}

/// `len` octets at `at` from `distance` back, as far as the window holds them.
fn copy(at: usize, len: usize, distance: usize) void {
    for (0..len) |index| {
        if (at + index == window_len) break;
        window()[at + index] = window()[at + index - distance];
    }
}

/// Where the window's first `guard_len` octets repeat.
const guard_at = piece_len_max + 1;
const guard_len = 64;
