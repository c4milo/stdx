//! RFC 7932's static dictionary (§8, Appendix A), claim B1 of decision 14: the DICT array as
//! dictionary.bin, which tools/brotli_tables.zig writes from the RFC's hexadecimal, and the word
//! counts and offsets of each length.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const rfc_tables = @import("rfc_tables.zig");

/// DICT (RFC 7932 §8): the base words, those of each length together, shortest first.
pub const data: *const [constants.dictionary_len]u8 = @embedFile("dictionary.bin");

/// NDBITS (RFC 7932 §8): log2 of the number of words of each length, 0 to 24.
pub const bits: [constants.word_len_max + 1]u5 = rfc_tables.dictionary_bits;

/// DOFFSET (RFC 7932 §8): where the words of each length start in DICT.
pub const offsets: [constants.word_len_max + 1]u32 = offsets_of();

fn offsets_of() [constants.word_len_max + 1]u32 {
    var starts: [constants.word_len_max + 1]u32 = undefined;
    starts[0] = 0;
    for (1..starts.len) |length| starts[length] = starts[length - 1] + @as(u32, @intCast(length - 1)) * word_count(length - 1);
    return starts;
}

comptime {
    // DICTSIZE (RFC 7932 §8): the longest words end where DICT does.
    assert(offsets[constants.word_len_max] + constants.word_len_max * word_count(constants.word_len_max) == data.len);
}

/// NWORDS (RFC 7932 §8): how many words have `length` octets; none below the shortest.
pub fn word_count(length: usize) u32 {
    assert(length <= constants.word_len_max);
    if (length < constants.word_len_min) return 0;
    return @as(u32, 1) << bits[length];
}

/// The base word of `length` octets at `index` (RFC 7932 §8): DICT from offset(length, index), for
/// `length` octets. The caller has checked the length and reduced the index modulo `word_count`.
pub fn word(length: usize, index: u32) []const u8 {
    return data[word_offset(length, index)..][0..length];
}

/// offset(length, index) of RFC 7932 §8: where the word starts in DICT.
pub fn word_offset(length: usize, index: u32) usize {
    assert(length >= constants.word_len_min and length <= constants.word_len_max);
    assert(index < word_count(length));
    return offsets[length] + index * length;
}

// Tests.

const testing = std.testing;

test "DICT is Appendix A's 122,784 octets with CRC-32 0x5136cb04" {
    // At comptime, and in a test: the CRC-32 of 122,784 octets adds about 5 s to a build, which
    // only a test build pays. Every build still checks DICTSIZE above.
    comptime {
        @setEvalBranchQuota(100_000_000);
        assert(std.hash.Crc32.hash(data) == constants.dictionary_crc32);
    }
}

test "DOFFSET follows the recursion of RFC 7932 §8" {
    try testing.expectEqual(0, offsets[constants.word_len_min]);
    try testing.expectEqual(4 * 1024, offsets[5]);
    try testing.expectEqual(4 * 1024 + 5 * 1024, offsets[6]);
    try testing.expectEqual(constants.dictionary_len - 24 * 32, offsets[constants.word_len_max]);
    try testing.expectEqual(0, word_count(constants.word_len_min - 1));
    try testing.expectEqual(32, word_count(constants.word_len_max));
}

test "words of each length start where DOFFSET says" {
    try testing.expectEqualStrings("time", word(4, 0));
    try testing.expectEqualStrings("down", word(4, 1));
    const last_four = word(4, word_count(4) - 1);
    try testing.expectEqual(data[offsets[5] - 4 ..][0..4], last_four[0..4]);
    try testing.expectEqualStrings(data[offsets[5]..][0..5], word(5, 0));
    try testing.expectEqualStrings(data[constants.dictionary_len - 24 ..], word(24, word_count(24) - 1));
}
