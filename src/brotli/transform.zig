//! RFC 7932's word transformations (§8, Appendix B), claim B1 of decision 14: 121 of them, each a
//! prefix, an elementary transform of the base word, and a suffix. tools/brotli_tables.zig writes
//! the table into rfc_tables.zig from the RFC, and this file pins it to the length and CRC-32
//! Appendix B states.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const rfc_tables = @import("rfc_tables.zig");

/// The 21 elementary transforms of RFC 7932 §8, in the order of the values Appendix B gives them:
/// Identity 0, FermentFirst 1, FermentAll 2, OmitFirst1 to OmitFirst9 3 to 11, and OmitLast1 to
/// OmitLast9 12 to 20.
pub const Kind = enum(u8) {
    identity,
    ferment_first,
    ferment_all,
    omit_first_1,
    omit_first_2,
    omit_first_3,
    omit_first_4,
    omit_first_5,
    omit_first_6,
    omit_first_7,
    omit_first_8,
    omit_first_9,
    omit_last_1,
    omit_last_2,
    omit_last_3,
    omit_last_4,
    omit_last_5,
    omit_last_6,
    omit_last_7,
    omit_last_8,
    omit_last_9,

    /// The octets an OmitFirstk or OmitLastk drops, k; 0 for the other transforms.
    fn omitted_len(kind: Kind) usize {
        const value = @intFromEnum(kind);
        if (value >= @intFromEnum(Kind.omit_last_1)) return value - @intFromEnum(Kind.omit_last_1) + 1;
        if (value >= @intFromEnum(Kind.omit_first_1)) return value - @intFromEnum(Kind.omit_first_1) + 1;
        return 0;
    }
};

/// One word transformation: transform_i(word) = prefix_i + T_i(word) + suffix_i (RFC 7932 §8).
pub const Transform = struct {
    prefix: []const u8,
    kind: Kind,
    suffix: []const u8,
};

/// The transformations in the order of their IDs.
pub const table: [constants.transforms_count]Transform = rfc_tables.transforms;

comptime {
    @setEvalBranchQuota(100_000);
    const serialized = serialize();
    // RFC 7932 Appendix B: the serialized transformations are 648 octets with CRC-32 0x3d965f81.
    assert(serialized.len == constants.transforms_serialized_len);
    assert(std.hash.Crc32.hash(&serialized) == constants.transforms_crc32);
    // RFC 7932 §8: a transformation adds at most 13 octets to a base word.
    var added_max: usize = 0;
    for (table) |transform| added_max = @max(added_max, transform.prefix.len + transform.suffix.len);
    assert(added_max == constants.transform_added_len_max);
}

/// The octets RFC 7932 Appendix B checks: each prefix and a zero, the elementary transform's value,
/// and each suffix and a zero, for every transformation in turn.
fn serialize() [constants.transforms_serialized_len]u8 {
    var octets: [constants.transforms_serialized_len]u8 = undefined;
    var len: usize = 0;
    for (table) |transform| {
        for ([_][]const u8{ transform.prefix, &.{0}, &.{@intFromEnum(transform.kind)}, transform.suffix, &.{0} }) |part| {
            @memcpy(octets[len..][0..part.len], part);
            len += part.len;
        }
    }
    assert(len == octets.len);
    return octets;
}

/// Writes transformation `id` of `word` into `output` (RFC 7932 §8): its prefix, the word with its
/// elementary transform applied, and its suffix. Returns the octets written. The caller has
/// checked the ID and the word's length against the stream.
pub fn apply(id: usize, word: []const u8, output: *[constants.transformed_word_len_max]u8) usize {
    assert(id < constants.transforms_count);
    assert(word.len >= constants.word_len_min and word.len <= constants.word_len_max);
    const transform = table[id];
    var len: usize = 0;
    @memcpy(output[len..][0..transform.prefix.len], transform.prefix);
    len += transform.prefix.len;
    const body = elementary(transform.kind, word);
    @memcpy(output[len..][0..body.len], body);
    ferment_body(transform.kind, output[len..][0..body.len]);
    len += body.len;
    @memcpy(output[len..][0..transform.suffix.len], transform.suffix);
    len += transform.suffix.len;
    assert(len <= word.len + constants.transform_added_len_max);
    return len;
}

/// The octets of `word` an elementary transform keeps.
fn elementary(kind: Kind, word: []const u8) []const u8 {
    const body = body_of(kind, word.len);
    return word[body.start..][0..body.len];
}

/// Where the octets an elementary transform keeps start in a word of `word_len`, and how many
/// (RFC 7932 §8): OmitFirstk keeps the last length - k octets and OmitLastk the first length - k,
/// or none when the word is shorter than k.
const Body = struct { start: usize, len: usize };

fn body_of(kind: Kind, word_len: usize) Body {
    const omitted = kind.omitted_len();
    if (omitted == 0) return .{ .start = 0, .len = word_len };
    if (word_len < omitted) return .{ .start = 0, .len = 0 };
    if (@intFromEnum(kind) >= @intFromEnum(Kind.omit_last_1)) return .{ .start = 0, .len = word_len - omitted };
    return .{ .start = omitted, .len = word_len - omitted };
}

/// The octets `apply_wide` moves in one copy: a prefix or a suffix, padded to `affix_copy_len`, and
/// a word's body with the octets after it, `body_copy_len`.
pub const affix_copy_len = 16;
pub const body_copy_len = 32;

/// The most octets an elementary transform omits: OmitFirst9 and OmitLast9.
const omitted_len_max = Kind.omit_last_9.omitted_len();

/// What `apply_wide` reads from a word's first octet in DICT, the most an omitted head and a body's
/// copy take; and the room it writes into, the longest prefix and a body's copy, or the longest
/// prefix and body and a suffix's copy.
pub const wide_input_len = omitted_len_max + body_copy_len;
pub const wide_output_len = 64;

/// Each transformation's prefix and suffix padded with zeros to `affix_copy_len`.
const Wide = struct {
    prefix: [affix_copy_len]u8,
    suffix: [affix_copy_len]u8,
    prefix_len: u8,
    suffix_len: u8,
    kind: Kind,
};

const wide_table: [constants.transforms_count]Wide = wide: {
    var wides: [constants.transforms_count]Wide = undefined;
    for (&wides, table) |*wide, transform| {
        wide.* = .{ .prefix = @splat(0), .suffix = @splat(0), .prefix_len = transform.prefix.len, .suffix_len = transform.suffix.len, .kind = transform.kind };
        @memcpy(wide.prefix[0..transform.prefix.len], transform.prefix);
        @memcpy(wide.suffix[0..transform.suffix.len], transform.suffix);
    }
    break :wide wides;
};

comptime {
    for (table) |transform| {
        assert(transform.prefix.len <= affix_copy_len and transform.suffix.len <= affix_copy_len);
        assert(transform.prefix.len + body_copy_len <= wide_output_len);
        assert(transform.prefix.len + constants.word_len_max + affix_copy_len <= wide_output_len);
    }
}

/// As `apply`, with the prefix, the body and the suffix each moved in one copy of fixed length, for
/// the fast path, whose margin holds the room past the word (decision 16). `head` is DICT from the
/// word's first octet, and the word is `word_len` octets of it.
pub fn apply_wide(id: usize, head: *const [wide_input_len]u8, word_len: usize, output: *[wide_output_len]u8) usize {
    assert(id < constants.transforms_count);
    assert(word_len >= constants.word_len_min and word_len <= constants.word_len_max);
    const wide = wide_table[id];
    output[0..affix_copy_len].* = wide.prefix;
    const body = body_of(wide.kind, word_len);
    output[wide.prefix_len..][0..body_copy_len].* = head[body.start..][0..body_copy_len].*;
    ferment_body(wide.kind, output[wide.prefix_len..][0..body.len]);
    const suffix_start = wide.prefix_len + body.len;
    output[suffix_start..][0..affix_copy_len].* = wide.suffix;
    return suffix_start + wide.suffix_len;
}

/// FermentFirst and FermentAll of RFC 7932 §8, in place.
fn ferment_body(kind: Kind, word: []u8) void {
    switch (kind) {
        .ferment_first => if (word.len > 0) {
            _ = ferment(word, 0);
        },
        .ferment_all => {
            // Each Ferment steps over 1 to 3 octets, so a word takes at most its length of steps.
            var position: usize = 0;
            for (0..word.len) |_| {
                if (position >= word.len) break;
                position += ferment(word, position);
            }
        },
        else => {},
    }
}

/// Ferment of RFC 7932 §8: changes the case of the character at `position` as its UTF-8 lead octet
/// classes it, and returns how many octets the character takes. A character of two or three octets
/// changes in its last octet, when the word holds it.
fn ferment(word: []u8, position: usize) usize {
    const lead = word[position];
    if (lead < constants.ferment_two_octets_min) {
        if (lead >= 'a' and lead <= 'z') word[position] ^= constants.ferment_case_xor;
        return 1;
    }
    const two_octets = lead < constants.ferment_three_octets_min;
    const len: usize = if (two_octets) constants.ferment_two_octets_len else constants.ferment_three_octets_len;
    const last = position + len - 1;
    if (last < word.len) word[last] ^= if (two_octets) constants.ferment_case_xor else constants.ferment_third_octet_xor;
    return len;
}

// Tests.

const testing = std.testing;

fn expect_transformed(expected: []const u8, id: usize, word: []const u8) !void {
    var output: [constants.transformed_word_len_max]u8 = undefined;
    const len = apply(id, word, &output);
    try testing.expectEqualStrings(expected, output[0..len]);
}

test "each kind of transformation, by the IDs Appendix B gives them" {
    try expect_transformed("time", 0, "time");
    try expect_transformed(" time ", 2, "time");
    try expect_transformed("ime", 3, "time");
    try expect_transformed("Time ", 4, "time");
    try expect_transformed("tim", 12, "time");
    try expect_transformed("TIME", 44, "time");
    try expect_transformed("timing ", 49, "time");
    try expect_transformed("", 54, "time");
    try expect_transformed(" the time of the ", 73, "time");
    try expect_transformed("\xc2\xa0time", 102, "time");
    try expect_transformed(" TIME=\"", 110, "time");
}

test "Ferment follows UTF-8 lead octets, and never writes past the word" {
    // é is c3 a9, and FermentFirst makes it É, c3 89; a three-octet character's third octet is
    // XORed with 5.
    try expect_transformed("\xc3\x89t\xc3\xa9", 9, "\xc3\xa9t\xc3\xa9");
    try expect_transformed("\xc3\x89T\xc3\x89", 44, "\xc3\xa9t\xc3\xa9");
    try expect_transformed("\xe0\xa4\xaf\xe0\xa4\xaf", 44, "\xe0\xa4\xaa\xe0\xa4\xaa");
    // A lead octet at the end of the word has no octet after it to change.
    try expect_transformed("TI\xe0\xa4", 44, "ti\xe0\xa4");
}

test "the longest transformation of the longest word fits the output" {
    var longest: usize = 0;
    const word = "a" ** constants.word_len_max;
    for (0..constants.transforms_count) |id| {
        var output: [constants.transformed_word_len_max]u8 = undefined;
        longest = @max(longest, apply(id, word, &output));
    }
    try testing.expectEqual(constants.transformed_word_len_max, longest);
}

test "a wide transformation writes what the exact one writes, for every ID and word length" {
    for (constants.word_len_min..constants.word_len_max + 1) |len| {
        // The word, then octets past it, as DICT holds a word and the words after it.
        var head: [wide_input_len]u8 = undefined;
        for (&head, 0..) |*octet, index| octet.* = "\xc3\xa9tAb-z\xe0\xa4\xaaqr"[index % 13];
        for (0..constants.transforms_count) |id| {
            var exact: [constants.transformed_word_len_max]u8 = undefined;
            const exact_len = apply(id, head[0..len], &exact);
            var wide: [wide_output_len]u8 = undefined;
            const wide_len = apply_wide(id, &head, len, &wide);
            try testing.expectEqualSlices(u8, exact[0..exact_len], wide[0..wide_len]);
        }
    }
}
