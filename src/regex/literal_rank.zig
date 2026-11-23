//! The rank of an octet by its kind, and the two offsets of a literal whose octets rank rarest
//! (decision 86 as amended). Claim R2 compares a literal's octets at the two offsets, and claim
//! R5 the octets of each literal of a set at two offsets shared by the set.
//!
//! The library holds no table of how often each octet stands in a text, so it ranks an octet by
//! its kind. Literals mostly past ASCII are of a script such as Cyrillic, and so is their text.
//! There a UTF-8 continuation octet is the rarest, since the script's letters share 64 of them,
//! and a lead octet the commonest: 0xD0 and 0xD1 start every Cyrillic letter. In the text of any
//! other literals, every octet past ASCII is the rarest, as the long s of `(?i)sherlock` is in
//! English. A capital, a digit or a mark is rarer than a lowercase letter or a space. Of two
//! offsets whose ranks sum the least, the widest apart wins, so an English word keeps its first
//! and last octets.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");

/// How often an octet stands in a text, the rarest first.
pub const Rank = enum(u8) { rarest, rare, common, commonest };

/// The rank of `octet` in a text of a script past ASCII where `past_ascii` holds, and of ASCII
/// otherwise.
pub fn rank(octet: u8, past_ascii: bool) Rank {
    if (octet > constants.one_octet_max) {
        if (!past_ascii or octet <= constants.continuation_max) return .rarest;
        return .commonest;
    }
    if (octet == ' ' or (octet >= 'a' and octet <= 'z')) return .common;
    return .rare;
}

/// True when more than half of `past` octets out of `octets` are past ASCII.
pub fn mostly(past: usize, octets: usize) bool {
    assert(past <= octets);
    return past > octets - past;
}

/// Two offsets of a literal, the first before the last.
pub const Offsets = struct { first: u8, last: u8 };

/// The two offsets below `ranks.len` whose ranks sum the least, the widest apart where sums tie.
/// `ranks` holds each offset's rank, as `@intFromEnum` gives it.
pub fn rarest_pair(ranks: []const u8) Offsets {
    assert(ranks.len >= constants.literal_prefix_len_min and ranks.len <= constants.literal_len_max);
    var best: Offsets = .{ .first = 0, .last = @intCast(ranks.len - 1) };
    for (0..ranks.len) |first| {
        for (first + 1..ranks.len) |last| {
            const pair: Offsets = .{ .first = @intCast(first), .last = @intCast(last) };
            if (better(ranks, pair, best)) best = pair;
        }
    }
    assert(best.first < best.last and best.last < ranks.len);
    return best;
}

fn better(ranks: []const u8, pair: Offsets, best: Offsets) bool {
    const sum = ranks[pair.first] + ranks[pair.last];
    const best_sum = ranks[best.first] + ranks[best.last];
    return sum < best_sum or (sum == best_sum and pair.last - pair.first > best.last - best.first);
}

const testing = std.testing;

test "rank puts continuation octets first in a text past ASCII, and every such octet in ASCII" {
    for ([_]bool{ false, true }) |past_ascii| {
        try testing.expectEqual(Rank.rarest, rank(0x80, past_ascii));
        try testing.expectEqual(Rank.rarest, rank(0xBF, past_ascii));
        try testing.expectEqual(Rank.rare, rank('A', past_ascii));
        try testing.expectEqual(Rank.rare, rank('Z', past_ascii));
        try testing.expectEqual(Rank.rare, rank('7', past_ascii));
        try testing.expectEqual(Rank.rare, rank('`', past_ascii));
        try testing.expectEqual(Rank.rare, rank('{', past_ascii));
        try testing.expectEqual(Rank.rare, rank(0x7F, past_ascii));
        try testing.expectEqual(Rank.common, rank('a', past_ascii));
        try testing.expectEqual(Rank.common, rank('z', past_ascii));
        try testing.expectEqual(Rank.common, rank(' ', past_ascii));
    }
    try testing.expectEqual(Rank.commonest, rank(0xC0, true));
    try testing.expectEqual(Rank.commonest, rank(0xFF, true));
    try testing.expectEqual(Rank.rarest, rank(0xC0, false));
    try testing.expectEqual(Rank.rarest, rank(0xFF, false));
}

test "mostly holds past half alone" {
    try testing.expect(!mostly(0, 4));
    try testing.expect(!mostly(2, 4));
    try testing.expect(mostly(3, 4));
    try testing.expect(mostly(4, 4));
}

test "rarest_pair takes the least sum, the widest apart where sums tie" {
    const cases = [_]struct { ranks: []const u8, first: u8, last: u8 }{
        .{ .ranks = &.{ 2, 2, 2, 2 }, .first = 0, .last = 3 },
        .{ .ranks = &.{ 2, 1, 2, 2 }, .first = 1, .last = 3 },
        .{ .ranks = &.{ 3, 0, 3, 0, 3 }, .first = 1, .last = 3 },
        .{ .ranks = &.{ 0, 3, 3, 0 }, .first = 0, .last = 3 },
        .{ .ranks = &.{ 2, 0 }, .first = 0, .last = 1 },
    };
    for (cases) |case| {
        const pair = rarest_pair(case.ranks);
        try testing.expectEqual(case.first, pair.first);
        try testing.expectEqual(case.last, pair.last);
    }
}
