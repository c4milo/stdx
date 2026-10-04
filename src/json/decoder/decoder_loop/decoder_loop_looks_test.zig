//! Tests of claim J13's hand-off (decoder_loop_looks.zig): its looks, and the strings
//! `copy_rest` takes with the claim on against the walk that stops at each escape, which is
//! `copy_rest` with the claim off.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const wide = @import("../../wide.zig");
const loop_string = @import("decoder_loop_string.zig");
const looking = @import("decoder_loop_looks.zig");
const escapes = @import("decoder_loop_escapes.zig");
const seeded = @import("decoder_loop_escapes_test.zig");

const width = constants.vector_len;
const text_len_max = seeded.text_len_max;
const padding_len = seeded.padding_len;
const room_len_max = text_len_max + padding_len;
const first_len = constants.escape_look_len_first;
const min_len = constants.escape_look_len_min;

test "a stretch is dense where its escapes dropped an octet in every count the constant names" {
    const max = constants.escape_dense_octets_max;
    for ([_]usize{ min_len, first_len, constants.escape_look_len_max }) |len| {
        const dropped = len / max;
        try testing.expect(looking.dense(dropped * max, dropped * max - dropped));
        try testing.expect(looking.dense(len, 0));
        try testing.expect(!looking.dense(dropped * max + 1, dropped * max + 1 - dropped));
        try testing.expect(!looking.dense(len, len));
    }
}

test "the walk's stretches grow twice as long after a look that hands nothing useful over" {
    var output: [text_len_max]u8 = undefined;
    const plain = "a" ** constants.escape_look_len_max;
    var looks: looking.Looks = .{};
    try testing.expectEqual(first_len, looks.len);
    // A stretch with no escape: sparse, so the next is twice as long, up to the limit.
    var left: escapes.Left = .{ .input = plain, .output = &output };
    looks.look(&left, looks.len, looks.len);
    try testing.expectEqual(first_len + first_len, looks.len);
    try testing.expectEqual(plain.len, left.input.len);
    for (0..@bitSizeOf(usize)) |_| looks.look(&left, looks.len, looks.len);
    try testing.expectEqual(constants.escape_look_len_max, looks.len);
    try testing.expectEqual(plain.len, left.input.len);
}

/// Six octets with two letters' escapes, and with a gap of plain octets after them, eight.
const close = "k\\\"v\\n";
const close_with_gap = close ++ "ab";

test "the walk's next stretch is the shortest after blocks that took the constant's octets" {
    if (comptime !escapes.available) return error.SkipZigTest;
    var output: [text_len_max]u8 = undefined;
    // A dense stretch behind, and ahead a text the blocks take whole blocks of: past the
    // constant, and then short of it.
    const long = close_with_gap ** (constants.escape_useful_len_min / close_with_gap.len + 1) ++ "\"";
    var looks: looking.Looks = .{ .len = constants.escape_look_len_max };
    var left: escapes.Left = .{ .input = long, .output = &output };
    looks.look(&left, constants.escape_dense_octets_max, constants.escape_dense_octets_max - 1);
    try testing.expect(long.len - left.input.len >= constants.escape_useful_len_min);
    try testing.expectEqual(min_len, looks.len);
    const short = close_with_gap ++ close_with_gap ++ "\"";
    left = .{ .input = short, .output = &output };
    looks.look(&left, constants.escape_dense_octets_max, constants.escape_dense_octets_max - 1);
    try testing.expectEqual(min_len + min_len, looks.len);
}

fn level_here() wide.Level {
    return wide.Level.of(codec.Features.detect());
}

/// Requires a string's rest to be copied alike with claim J13 on and off, into `room_len` octets:
/// the same octets taken and written, or the string left to the checked path by both.
fn expect_same_copy(rest: []const u8, room_len: usize) !void {
    var blocks_room: [room_len_max]u8 = undefined;
    var walk_room: [room_len_max]u8 = undefined;
    const by_blocks = loop_string.copy_rest_at(.{}, level_here(), rest, blocks_room[0..room_len]);
    const by_walk = loop_string.copy_rest_at(.{ .decoder_escape_blocks = false }, level_here(), rest, walk_room[0..room_len]);
    try testing.expectEqual(by_walk, by_blocks);
    if (by_walk) |copied| try testing.expectEqualSlices(u8, walk_room[0..copied.output_len], blocks_room[0..copied.output_len]);
}

/// Requires `expect_same_copy` of `rest` with room to spare, and where the walk takes the string,
/// with each room from one octet short of what it wrote to a block more. Returns whether the walk
/// took the string.
fn expect_same_copies(rest: []const u8) !bool {
    try expect_same_copy(rest, rest.len + padding_len);
    var room: [room_len_max]u8 = undefined;
    const copied = loop_string.copy_rest_at(.{ .decoder_escape_blocks = false }, level_here(), rest, &room) orelse return false;
    for (copied.output_len -| 1..copied.output_len + width + 1) |room_len| try expect_same_copy(rest, room_len);
    return true;
}

/// What follows a string in a text: its closing quotation mark, a comma and a number.
const tail = "\",1]" ++ " " ** padding_len;

test "a string's rest is copied alike with the blocks and with the walk that stops at each escape" {
    var text: [text_len_max]u8 = undefined;
    for (0..seeded.seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        const len = seeded.seeded_text(&generator, seeded.mix_of(seed), &text);
        @memcpy(text[len..][0..tail.len], tail);
        // The string whole with what follows it, then cut where the seed says.
        _ = try expect_same_copies(text[0 .. len + tail.len]);
        _ = try expect_same_copies(text[0..generator.below(len + tail.len + 1)]);
    }
}

/// What a stretch's end may cut: each kind of escape, a surrogate pair's two, and a character
/// of each length UTF-8 has past one octet (RFC 8259 §7, RFC 3629 §3).
const units = [_][]const u8{ "\\n", "\\u0041", "\\u00e9", "\\uD83D\\uDE00", "\xc3\xa9", "\xe2\x82\xac", "\xf0\x9f\x98\x80" };

/// What the walk refuses wherever it stands: an escape of no letter, a control character, a high
/// surrogate no low one follows, an octet UTF-8 rules out, and a digit that is none.
const refusals = [_][]const u8{ "\\q", "\x01", "\\uD83Dx", "\\uD83D\\u0041", "\x80", "\\u00G1" };

/// Writes `unit` and the tail into `text` so that `offset` octets of the unit lie before `end`,
/// and returns the text's length.
fn place(text: *[text_len_max]u8, end: usize, offset: usize, unit: []const u8) usize {
    const start = end - offset;
    @memcpy(text[start..][0..unit.len], unit);
    @memcpy(text[start + unit.len ..][0..tail.len], tail);
    return start + unit.len + tail.len;
}

test "a stretch that ends inside an escape or a character goes on from where that starts" {
    var text: [text_len_max]u8 = @splat('a');
    // The first stretch's end, and the end of the second, twice as long: no escape came before.
    for ([_]usize{ first_len, first_len + first_len + first_len }) |end| {
        for (units) |unit| {
            for (0..unit.len + 1) |offset| {
                const len = place(&text, end, offset, unit);
                try testing.expect(try expect_same_copies(text[0..len]));
                @memset(text[end - offset .. len], 'a');
            }
        }
    }
}

test "a string the walk refuses near a stretch's end is left to the checked path" {
    var text: [text_len_max]u8 = @splat('a');
    for (refusals) |refusal| {
        // From a refusal the stretch cuts, to one further before its end than the longest escape.
        for (0..loop_string.pair_escape_len + refusal.len + 1) |offset| {
            const len = place(&text, first_len, offset, refusal);
            try testing.expect(!try expect_same_copies(text[0..len]));
            @memset(text[first_len - offset .. len], 'a');
        }
    }
}

test "a string the walk refuses far from a stretch's end is left to the checked path at once" {
    // A control character past the first stretch, and after it more input than the longest
    // stretch holds: no stretch that starts at it is the input's last, so only the distance from
    // the stretch's end tells this stop from one a cut made.
    const far = "a" ** (first_len + width) ++ "\x01" ++ "a" ** (constants.escape_look_len_max + first_len);
    var blocks_room: [room_len_max]u8 = undefined;
    try testing.expectEqual(null, loop_string.copy_rest_at(.{}, level_here(), far, &blocks_room));
    try testing.expectEqual(null, loop_string.copy_rest_at(.{ .decoder_escape_blocks = false }, level_here(), far, &blocks_room));
}

test "a string the input ends inside, at a stretch's end and beside it, is left to the checked path" {
    const plain = "a" ** (first_len + first_len);
    const dense = close ** (first_len / close.len + first_len / close.len);
    inline for (.{ plain, dense }) |text| {
        for (first_len - width..first_len + width + 1) |len| try testing.expect(!try expect_same_copies(text[0..len]));
        try testing.expect(!try expect_same_copies(text));
    }
}

/// The length of looks no look has set: `copy_rest_looking` sets them once the walk took a
/// string's first stretch without its closing quotation mark.
const unset_len = 0;

/// Copies `rest` as `copy_rest` does with claim J13 on, requires what the walk alone copies, and
/// returns the looks it left.
fn looks_after(rest: []const u8) !looking.Looks {
    var room: [room_len_max]u8 = undefined;
    var looks: looking.Looks = .{ .len = unset_len };
    const copied = loop_string.copy_rest_looking(.{}, level_here(), rest, &room, &looks);
    var walk_room: [room_len_max]u8 = undefined;
    const by_walk = loop_string.copy_rest(.{ .decoder_escape_blocks = false }, level_here(), rest, &walk_room);
    try testing.expectEqual(by_walk, copied);
    if (by_walk) |walked| try testing.expectEqualSlices(u8, walk_room[0..walked.output_len], room[0..walked.output_len]);
    return looks;
}

test "a long string of close escapes goes to the blocks, and one of far escapes stays with the walk" {
    if (comptime !escapes.available) return error.SkipZigTest;
    // Close: the first look hands the string over, and the blocks take it to its end, so the
    // next stretch, which holds the closing quotation mark alone, is the shortest.
    const near = close ** (first_len / close.len + first_len / close.len) ++ tail;
    try testing.expectEqual(min_len, (try looks_after(near)).len);
    // Far: a line of 64 octets at a time. The first look leaves the string to the walk, whose
    // second stretch, twice as long, reaches its end.
    const far = ("a" ** (constants.kernel_alignment - 2) ++ "\\n") ** (first_len / constants.kernel_alignment + 1) ++ tail;
    try testing.expectEqual(first_len + first_len, (try looks_after(far)).len);
    // Shorter than the first stretch, however close its escapes: no look, and no looks set.
    const brief = close ** (first_len / close.len - 1) ++ tail;
    try testing.expectEqual(unset_len, (try looks_after(brief)).len);
}

test "a stretch after the blocks that ends inside an escape or a character goes on from it" {
    if (comptime !escapes.available) return error.SkipZigTest;
    // Close escapes past the first stretch, which the blocks take up to a character they do not
    // take. The walk's next stretch, the shortest, ends inside `unit`; the look after it finds
    // its escapes far apart, and the stretch after that, twice as long, reaches the string's end.
    const dense = close ** (first_len / close.len + first_len / close.len / 2) ++ "\xc3\xa9";
    var text: [text_len_max]u8 = @splat('a');
    @memcpy(text[0..dense.len], dense);
    for (units) |unit| {
        for (0..unit.len + 1) |offset| {
            const len = place(&text, dense.len - 2 + min_len, offset, unit);
            try testing.expectEqual(min_len + min_len, (try looks_after(text[0..len])).len);
            @memset(text[dense.len..len], 'a');
        }
    }
}
