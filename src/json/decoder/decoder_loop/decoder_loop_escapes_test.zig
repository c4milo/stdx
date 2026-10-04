//! Tests of claim J13's blocks (decoder_loop_escapes.zig): its tables against the letters of RFC
//! 8259 §7, and its loop against a model that takes an octet at a time. The seeded texts here are
//! also the ones decoder_loop_looks_test.zig copies with the claim on and off.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const Walk = @import("../../string_walk.zig").Walk;
const escapes = @import("decoder_loop_escapes.zig");

const width = constants.vector_len;

/// The octets of a letter's escape, the plain octets after a text's body, a block and more, and the
/// longest text a case builds.
const letter_escape_len = escapes.letter_escape_len;
pub const padding_len = width + width;
pub const text_len_max = 16384;

/// The lanes a case's first stop or escape stands at: every lane of two blocks, and the first of a
/// third.
const offsets = padding_len + 1;

test "each escape letter has a slot of its own, with its letter and the difference to its character" {
    var taken: [width]bool = @splat(false);
    for (constants.escape_letters, constants.escaped_characters) |letter, character| {
        const slot = escapes.slot_of(letter);
        try testing.expect(!taken[slot]);
        taken[slot] = true;
        try testing.expectEqual(character, letter ^ escapes.difference_by_slot[slot]);
    }
    // The lookup names an octet a letter when it equals its slot's letter: the seven letters
    // alone, with the reverse solidus left to `take_solidus`.
    for (0..std.math.maxInt(u8) + 1) |octet| {
        const is_letter = std.mem.indexOfScalar(u8, constants.escape_letters, @intCast(octet)) != null;
        const named = escapes.letter_by_slot[escapes.slot_of(@intCast(octet))] == octet;
        try testing.expectEqual(is_letter and octet != constants.reverse_solidus, named);
    }
}

test "each set of lanes to leave out of a half keeps the other lanes, in order" {
    for (escapes.kept_lanes, escapes.kept_counts, 0..) |lanes, count, left_out| {
        var kept: usize = 0;
        for (0..lanes.len) |lane| {
            if (left_out >> @intCast(lane) & 1 != 0) continue;
            try testing.expectEqual(lane, lanes[kept]);
            kept += 1;
        }
        try testing.expectEqual(kept, count);
    }
}

/// What a walk took of a text: its octets, and the octets written for them.
const Taken = struct { consumed: usize, written: usize };

/// What the blocks take of `text`, an octet at a time: plain ASCII and the escapes of a letter
/// (RFC 8259 §7), up to the first octet that is neither.
fn model(text: []const u8, output: []u8) Taken {
    var taken: Taken = .{ .consumed = 0, .written = 0 };
    while (taken.consumed < text.len) {
        const octet = text[taken.consumed];
        if (octet == constants.reverse_solidus) {
            if (taken.consumed + 1 == text.len) break;
            const letter = std.mem.indexOfScalar(u8, constants.escape_letters, text[taken.consumed + 1]) orelse break;
            output[taken.written] = constants.escaped_characters[letter];
            taken.consumed += letter_escape_len;
        } else {
            if (octet == constants.quotation_mark or octet < constants.unescaped_min or octet >= constants.non_ascii_min) break;
            output[taken.written] = octet;
            taken.consumed += 1;
        }
        taken.written += 1;
    }
    return taken;
}

/// Requires the blocks to take `body`, with plain octets after it, up to the stop the model finds
/// inside it, however many blocks with no reverse solidus come before it.
fn expect_as_model(body: []const u8) !void {
    var text: [text_len_max]u8 = undefined;
    @memcpy(text[0..body.len], body);
    @memset(text[body.len..][0..padding_len], 'z');
    const input = text[0 .. body.len + padding_len];
    var expected: [text_len_max]u8 = undefined;
    const taken = model(input, &expected);
    try testing.expect(taken.consumed < body.len);
    var output: [text_len_max]u8 = undefined;
    var walk: Walk = .{ .input = input, .output = &output };
    escapes.take_blocks(&walk, input, std.math.maxInt(usize));
    try testing.expectEqual(taken.consumed, input.len - walk.input.len);
    try testing.expectEqualSlices(u8, expected[0..taken.written], output[0 .. output.len - walk.output.len]);
}

/// Requires `expect_as_model` of `middle` after each count of plain octets up to `offsets`, with a
/// quotation mark after it.
fn expect_at_every_lane(comptime middle: []const u8) !void {
    inline for (0..offsets) |offset| {
        try expect_as_model("a" ** offset ++ middle ++ "\"");
    }
}

test "the blocks take each letter's escape at every lane, up to the quotation mark after it" {
    if (comptime !escapes.available) return error.SkipZigTest;
    inline for (constants.escape_letters) |letter| {
        try expect_at_every_lane("\\" ++ [_]u8{letter} ++ "bc");
    }
}

test "the blocks take escaped reverse solidi, alone and in runs, at every lane" {
    if (comptime !escapes.available) return error.SkipZigTest;
    try expect_at_every_lane("\\\\");
    try expect_at_every_lane("\\\\n");
    try expect_at_every_lane("\\\\\\n");
    try expect_at_every_lane("\\\\\\\\");
    try expect_at_every_lane("\\\\\\\"x\\\\\\\\\\/");
}

test "the blocks stop at the reverse solidus of an escape they do not take, at every lane" {
    if (comptime !escapes.available) return error.SkipZigTest;
    try expect_at_every_lane("\\n\\u0041");
    try expect_at_every_lane("\\q");
    try expect_at_every_lane("\\t\\\x01");
    try expect_at_every_lane("\\\xc3\xa9");
    try expect_at_every_lane("\\\\\\u00e9");
}

test "the blocks stop at a control character, a quotation mark and a non-ASCII octet, at every lane" {
    if (comptime !escapes.available) return error.SkipZigTest;
    try expect_at_every_lane("");
    try expect_at_every_lane("\\n");
    try expect_at_every_lane("\x01");
    try expect_at_every_lane("\\n\x1f");
    try expect_at_every_lane("\\\"\xc3\xa9");
    try expect_at_every_lane("\x7f\\/\x80");
}

test "the blocks take two escapes at every lane and every gap between them" {
    if (comptime !escapes.available) return error.SkipZigTest;
    inline for (0..width + 1) |gap| {
        try expect_at_every_lane("\\n" ++ "b" ** gap ++ "\\t");
    }
}

/// The pieces a seeded text is made of: plain ASCII and each letter's escape, which the blocks
/// take; then the escapes and the characters the walk takes and the blocks do not; then the octets
/// that end a string or that the checked path refuses.
const fragments = [_][]const u8{
    "a",         "bc",      " ",       "0123456789abcdef", "\x7f",     "\\\"",         "\\\\",
    "\\/",       "\\b",     "\\f",     "\\n",              "\\r",      "\\t",          "\\n\\n",
    "\\\"a\\\"", "\\u0041", "\\u00e9", "\\uD83D\\uDE00",   "\xc3\xa9", "\xe2\x82\xac", "\xf0\x9f\x98\x80",
    "\\q",       "\\",      "\x01",    "\x1f",             "\x80",     "\"",
};

/// The fragments the blocks take, and the fragments the walk takes: the first of the rest ends a
/// string or is refused.
const plain_fragments = 15;
const walked_fragments = 21;
/// The fragment of 16 plain octets, which puts two escapes far apart.
const far_fragment = 3;

/// The seeded cases, and the two quotation marks after a text: a reverse solidus that ends the
/// text escapes the first.
pub const seeded_cases = 4000;
const ends = "\"\"";

/// The texts a seed draws. `any`: a few fragments, one in eight of any kind. `dense`: many more,
/// of the ones that keep the escapes close together. `long`: enough of those to pass the first
/// stretch the walk takes (`constants.escape_look_len_first`), so that `copy_rest` hands the
/// string to the blocks, with a fragment the blocks hand back at now and then.
pub const Mix = enum { any, dense, long };

/// How a mix draws: its count of fragments; of `share` draws, one of any fragment and `walked` of
/// a fragment the walk alone takes, the others of the fragments the blocks take; and whether the
/// far fragment is left out.
const Rule = struct { count_min: usize = 0, count_max: usize, share: usize, walked: usize = 0, close: bool };

/// The fragments a text of each mix holds at most, and for a long one at least; of how many draws
/// one is of any fragment; and of a long text's draws, how many are of a fragment the walk alone
/// takes.
const any_fragments_max = 48;
const any_share = 8;
const dense_fragments_max = 400;
const dense_share = 256;
const long_fragments_min = 2400;
const long_fragments_max = 5000;
const long_share = 4096;
const long_walked = 64;

/// The octets of a fragment the blocks take, at least, on average.
const fragment_len_mean_min = 2;

comptime {
    // A long text passes the first stretch the walk takes, and fits the longest text.
    std.debug.assert(long_fragments_min * fragment_len_mean_min > constants.escape_look_len_first);
    std.debug.assert(long_fragments_max * (fragment_len_mean_min + 1) < text_len_max);
}

fn rule_of(mix: Mix) Rule {
    return switch (mix) {
        .any => .{ .count_max = any_fragments_max, .share = any_share, .close = false },
        .dense => .{ .count_max = dense_fragments_max, .share = dense_share, .close = true },
        .long => .{ .count_min = long_fragments_min, .count_max = long_fragments_max, .share = long_share, .walked = long_walked, .close = true },
    };
}

/// Every fourth seed draws a dense text, and one seed in 32 a long one.
pub fn mix_of(seed: usize) Mix {
    if (seed % long_seed_period == 1) return .long;
    return if (seed % dense_seed_period == 0) .dense else .any;
}
const dense_seed_period = 4;
const long_seed_period = 32;

/// The octets a caller writes after a seeded text, at most.
const reserved_len = 64;

fn drawn(generator: *codec.split.Generator, rule: Rule) usize {
    const kind = generator.below(rule.share);
    if (kind == 0) return generator.below(fragments.len);
    if (kind <= rule.walked) return plain_fragments + generator.below(walked_fragments - plain_fragments);
    const index = generator.below(plain_fragments);
    return if (rule.close and index == far_fragment) 0 else index;
}

/// Fills `text` with the fragments `mix` draws from the seed, and returns its length.
pub fn seeded_text(generator: *codec.split.Generator, mix: Mix, text: *[text_len_max]u8) usize {
    const rule = rule_of(mix);
    var len: usize = 0;
    for (0..rule.count_min + generator.below(rule.count_max - rule.count_min + 1)) |_| {
        const fragment = fragments[drawn(generator, rule)];
        if (len + fragment.len > text_len_max - reserved_len) break;
        @memcpy(text[len..][0..fragment.len], fragment);
        len += fragment.len;
    }
    return len;
}

test "the blocks take seeded texts of plain ASCII, escapes and stops as the model takes them" {
    if (comptime !escapes.available) return error.SkipZigTest;
    var text: [text_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        const len = seeded_text(&generator, mix_of(seed), &text);
        // Two quotation marks: a reverse solidus that ends the text escapes the first.
        text[len..][0..ends.len].* = ends.*;
        try expect_as_model(text[0 .. len + ends.len]);
    }
}

test "the blocks leave an escape that a block's last lane starts to the walk, where no block follows" {
    if (comptime !escapes.available) return error.SkipZigTest;
    const input = "a" ** (width - 1) ++ "\\n\"";
    var output: [text_len_max]u8 = undefined;
    var left: escapes.Left = .{ .input = input, .output = &output };
    escapes.take(&left, input);
    try testing.expectEqualStrings("\\n\"", left.input);
    try testing.expectEqual(width - 1, output.len - left.output.len);
    try testing.expectEqualStrings(input[0 .. width - 1], output[0 .. width - 1]);
}

test "the blocks stop at a quotation mark that is the input's last octet, after an escape" {
    if (comptime !escapes.available) return error.SkipZigTest;
    const input = "\\n" ++ "a" ** (width - letter_escape_len - 1) ++ "\"";
    var output: [text_len_max]u8 = undefined;
    var left: escapes.Left = .{ .input = input, .output = &output };
    escapes.take(&left, input);
    try testing.expectEqualStrings("\"", left.input);
    try testing.expectEqualStrings("\n" ++ "a" ** (width - letter_escape_len - 1), output[0 .. output.len - left.output.len]);
}

test "the blocks take nothing where the input or the room holds less than a block" {
    if (comptime !escapes.available) return error.SkipZigTest;
    const input = "a\\nb" ** width;
    var output: [text_len_max]u8 = undefined;
    const cases = [_]struct { input_len: usize, room_len: usize }{
        .{ .input_len = width - 1, .room_len = text_len_max },
        .{ .input_len = input.len, .room_len = width - 1 },
    };
    for (cases) |case| {
        var left: escapes.Left = .{ .input = input[0..case.input_len], .output = output[0..case.room_len] };
        escapes.take(&left, input[0..case.input_len]);
        try testing.expectEqual(case.input_len, left.input.len);
        try testing.expectEqual(case.room_len, left.output.len);
    }
}

test "the blocks hand a string back after the blocks with no reverse solidus the constant names" {
    if (comptime !escapes.available) return error.SkipZigTest;
    const quiet = constants.escape_quiet_blocks_max;
    // A block with an escape, then plain blocks: one fewer than the constant, an escape's block,
    // and then more than the constant.
    const dense = "\\n" ++ "a" ** (width - letter_escape_len);
    const input = dense ++ "b" ** (width * (quiet - 1)) ++ dense ++ "c" ** (width * (quiet + 1)) ++ "\"";
    var output: [text_len_max]u8 = undefined;
    var left: escapes.Left = .{ .input = input, .output = &output };
    escapes.take(&left, input);
    // It stops once `quiet` blocks of c went by, with one block of c and the quotation mark left.
    try testing.expectEqualStrings("c" ** width ++ "\"", left.input);
    const written = output[0 .. output.len - left.output.len];
    try testing.expectEqualStrings("\n" ++ "a" ** (width - letter_escape_len) ++ "b" ** (width * (quiet - 1)) ++ "\n" ++ "a" ** (width - letter_escape_len) ++ "c" ** (width * quiet), written);
}
