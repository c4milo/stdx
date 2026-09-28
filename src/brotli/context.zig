//! Context modeling (RFC 7932 §7.1, §7.2), claim B2 of decision 14: the context ID of a literal from
//! the two octets before it, and of a distance from its command's copy length. Lut0, Lut1 and Lut2
//! are comptime data that tools/brotli_tables.zig writes into rfc_tables.zig from the RFC, and this
//! file pins each to the length and CRC-32 §7.1 states.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const rfc_tables = @import("rfc_tables.zig");

pub const lut0: [constants.lut_len]u8 = rfc_tables.lut0;
pub const lut1: [constants.lut_len]u8 = rfc_tables.lut1;
pub const lut2: [constants.lut_len]u8 = rfc_tables.lut2;

comptime {
    @setEvalBranchQuota(100_000);
    // RFC 7932 §7.1 gives each table's CRC-32 as a sequence of octets.
    assert(std.hash.Crc32.hash(&lut0) == constants.lut0_crc32);
    assert(std.hash.Crc32.hash(&lut1) == constants.lut1_crc32);
    assert(std.hash.Crc32.hash(&lut2) == constants.lut2_crc32);
}

/// The context modes of a literal block type, as RFC 7932 §7.1 numbers them: LSB6 0, MSB6 1, UTF8 2
/// and Signed 3.
pub const Mode = enum(u2) { lsb6, msb6, utf8, signed };

/// The context ID of the next literal (RFC 7932 §7.1): p1 is the last octet the stream produced and
/// p2 the one before it. Every ID the tables give is below 64 (the comptime block below), so it
/// truncates to its type unchecked.
pub fn literal_id(mode: Mode, p1: u8, p2: u8) u6 {
    return switch (mode) {
        .lsb6 => @truncate(p1),
        .msb6 => @intCast(p1 >> constants.msb6_shift),
        .utf8 => @truncate(lut0[p1] | lut1[p2]),
        .signed => @truncate(@as(u8, lut2[p1]) << constants.signed_shift | lut2[p2]),
    };
}

/// A literal's part of the next literal's context ID, where it is p1 (RFC 7932 §7.1). In every
/// mode the ID is p1's part OR p2's part (`p2_part`).
pub fn p1_part(comptime mode: Mode, literal: u8) u6 {
    return switch (mode) {
        .lsb6 => @truncate(literal),
        .msb6 => @intCast(literal >> constants.msb6_shift),
        .utf8 => @truncate(lut0[literal]),
        .signed => @truncate(@as(u8, lut2[literal]) << constants.signed_shift),
    };
}

/// A literal's part of the context ID of the literal after the next, where it is p2 (RFC 7932
/// §7.1): none in LSB6 and MSB6.
pub fn p2_part(comptime mode: Mode, literal: u8) u6 {
    return switch (mode) {
        .lsb6, .msb6 => 0,
        .utf8 => @truncate(lut1[literal]),
        .signed => @truncate(lut2[literal]),
    };
}

/// Where a literal table's entry value holds the literal's `p1_part`: above the literal's octet.
pub const entry_p1_part_shift = @bitSizeOf(u8);

/// The entry value of a literal table built for block types of `mode`: the literal in its low
/// octet, and above it the literal's `p1_part`. The decoder reads the part with the literal, so no
/// load stands between a literal and the next one's table.
pub fn literal_entry_value(comptime mode: Mode) fn (u16) u16 {
    return struct {
        fn value(literal: u16) u16 {
            assert(literal < constants.lut_len);
            return literal | @as(u16, p1_part(mode, @intCast(literal))) << entry_p1_part_shift;
        }
    }.value;
}

comptime {
    @setEvalBranchQuota(10_000);
    // UTF8's and Signed's IDs, from any p1 and p2, stay below 64 (RFC 7932 §7.1).
    for (lut0) |value| assert(value < constants.literal_contexts_count);
    for (lut1) |value| assert(value < constants.literal_contexts_count);
    for (lut2) |value| assert(value < 1 << constants.signed_shift);
}

/// The context ID of a distance (RFC 7932 §7.2): 0, 1 and 2 for copy lengths 2, 3 and 4, and 3 for
/// any longer copy. A copy length is at least 2 (RFC 7932 §5).
pub fn distance_id(copy_len: u32) u2 {
    assert(copy_len >= constants.distance_context_copy_len_min);
    if (copy_len >= constants.distance_context_last_copy_len) return constants.distance_contexts_count - 1;
    return @intCast(copy_len - constants.distance_context_copy_len_min);
}

// Tests.

const testing = std.testing;

test "each mode's context ID, as RFC 7932 §7.1 computes it" {
    try testing.expectEqual(0x3f, literal_id(.lsb6, 0xff, 0));
    try testing.expectEqual(0x01, literal_id(.lsb6, 0x41, 0xff));
    try testing.expectEqual(0x10, literal_id(.msb6, 0x40, 0xff));
    try testing.expectEqual(0x3f, literal_id(.msb6, 0xff, 0));
    // UTF8: Lut0 gives a lower-case vowel 56 and consonant 60, and Lut1 a space 0 and a lower-case
    // letter 3.
    try testing.expectEqual(56, literal_id(.utf8, 'a', ' '));
    try testing.expectEqual(60 | 3, literal_id(.utf8, 'b', 'a'));
    // Signed: Lut2 is 0 at 0 and 7 at 255.
    try testing.expectEqual(0, literal_id(.signed, 0, 0));
    try testing.expectEqual(63, literal_id(.signed, 0xff, 0xff));
    try testing.expectEqual(7 << 3 | 1, literal_id(.signed, 0xff, 1));
}

test "every mode's ID is p1's part OR p2's part" {
    for (0..constants.lut_len) |p1| {
        for (0..constants.lut_len) |p2| {
            inline for (@typeInfo(Mode).@"enum".fields) |field| {
                const mode = @field(Mode, field.name);
                const parts = p1_part(mode, @intCast(p1)) | p2_part(mode, @intCast(p2));
                try testing.expectEqual(literal_id(mode, @intCast(p1), @intCast(p2)), parts);
            }
        }
    }
}

test "a literal table's entry value holds the literal, and its part of the next ID above it" {
    inline for (@typeInfo(Mode).@"enum".fields) |field| {
        const mode = @field(Mode, field.name);
        for (0..constants.lut_len) |literal| {
            const value = literal_entry_value(mode)(@intCast(literal));
            try testing.expectEqual(literal, value & 0xff);
            try testing.expectEqual(p1_part(mode, @intCast(literal)), value >> entry_p1_part_shift);
        }
    }
}

test "every pair of octets gives every mode an ID below 64" {
    for (0..constants.lut_len) |p1| {
        for (0..constants.lut_len) |p2| {
            inline for (@typeInfo(Mode).@"enum".fields) |field| {
                const id = literal_id(@field(Mode, field.name), @intCast(p1), @intCast(p2));
                try testing.expect(id < constants.literal_contexts_count);
            }
        }
    }
}

test "a distance's context ID follows its copy length" {
    try testing.expectEqual(0, distance_id(2));
    try testing.expectEqual(1, distance_id(3));
    try testing.expectEqual(2, distance_id(4));
    try testing.expectEqual(3, distance_id(5));
    try testing.expectEqual(3, distance_id(16_779_333));
}
