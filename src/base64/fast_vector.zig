//! The vector steps of base64's fast paths (decision 68): 24 octets to 32 letters, and 32 letters
//! to 24 octets, in Zig's portable vectors, so one source serves every CPU. A letter's value comes
//! from compares against the alphabet's ranges, not from a table, so each step is a fixed sequence
//! of vector instructions. fast.zig calls them on whole blocks inside its slices.

const std = @import("std");
const builtin = @import("builtin");
const constants = @import("constants.zig");
const Alphabet = @import("alphabet.zig").Alphabet;

/// The letters of one decoding step, and the octets of one encoding step.
pub const block_letters = 32;
pub const block_octets = block_letters / constants.quantum_letters * constants.group_octets;

/// The groups, and the quanta, of one step: each one 32-bit lane.
const lanes = block_letters / constants.quantum_letters;

const Letters = @Vector(block_letters, u8);
const Words = @Vector(lanes, u32);

comptime {
    std.debug.assert(lanes * @sizeOf(u32) == block_letters);
}

/// The letters of RFC 4648 §4's Table 1 and §5's Table 2, as ranges: each first letter, how many
/// follow it, and the value of the first.
const upper_first: u8 = 'A';
const lower_first: u8 = 'a';
const digit_first: u8 = '0';
const letters_in_case: u8 = 26;
const digits: u8 = 10;
const lower_value: u8 = letters_in_case;
const digit_value: u8 = lower_value + letters_in_case;

/// The letters after the digits: values 62 and 63 (RFC 4648 §4, Table 1).
const last_count = constants.alphabet_len - digit_value - digits;
const value_62: u8 = digit_value + digits;
const value_63: u8 = value_62 + 1;

comptime {
    std.debug.assert(value_63 == constants.alphabet_len - 1);
}

/// The two letters of values 62 and 63 in each alphabet (RFC 4648 §4, §5).
fn last_letters(comptime alphabet: Alphabet) [last_count]u8 {
    return switch (alphabet) {
        .standard => .{ '+', '/' },
        .url_safe => .{ '-', '_' },
    };
}

/// The 24 bits of each group of three octets of `octets`, one group a lane, most significant
/// octet first (RFC 4648 §4).
fn groups(octets: *const [block_octets]u8) Words {
    const source: @Vector(block_octets, u8) = octets.*;
    // Each lane's four octets, in the host's order of a u32's octets: the group's three, most
    // significant first, and a zero above them.
    const order = comptime blk: {
        var mask: [block_letters]i32 = undefined;
        for (0..lanes) |lane| {
            for (0..@sizeOf(u32)) |place| {
                const significance = switch (builtin.cpu.arch.endian()) {
                    .little => place,
                    .big => @sizeOf(u32) - 1 - place,
                };
                // Significance 0 is the group's last octet; significance 3 holds no octet.
                mask[lane * @sizeOf(u32) + place] = if (significance == constants.group_octets)
                    ~@as(i32, 0)
                else
                    @intCast(lane * constants.group_octets + constants.group_octets - 1 - significance);
            }
        }
        break :blk mask;
    };
    const zero: @Vector(1, u8) = @splat(0);
    return @bitCast(@shuffle(u8, source, zero, order));
}

/// Encodes 24 octets into 32 letters of `alphabet`.
pub fn encode_block(comptime alphabet: Alphabet, octets: *const [block_octets]u8, letters: *[block_letters]u8) void {
    const bits = groups(octets);
    const sextet_mask: Words = @splat(constants.alphabet_len - 1);
    // Each lane's four 6-bit values, first letter in the lane's lowest octet's place of memory.
    var sextets: Words = @splat(0);
    inline for (0..constants.quantum_letters) |index| {
        const value = (bits >> @splat(@as(u5, (constants.quantum_letters - 1 - index) * constants.letter_bits))) & sextet_mask;
        const place = switch (builtin.cpu.arch.endian()) {
            .little => index,
            .big => constants.quantum_letters - 1 - index,
        };
        sextets |= value << @splat(@as(u5, @intCast(place * constants.octet_bits)));
    }
    const values: Letters = @bitCast(sextets);
    letters.* = letters_of(alphabet, values);
}

/// Each value's letter: its range's first letter plus its distance into the range.
fn letters_of(comptime alphabet: Alphabet, values: Letters) Letters {
    const last = last_letters(alphabet);
    const below_lower = values < @as(Letters, @splat(lower_value));
    const below_digit = values < @as(Letters, @splat(digit_value));
    const below_62 = values < @as(Letters, @splat(value_62));
    const is_62 = values == @as(Letters, @splat(value_62));
    var offset: Letters = @splat(last[1] -% value_63);
    offset = @select(u8, is_62, @as(Letters, @splat(last[0] -% value_62)), offset);
    offset = @select(u8, below_62, @as(Letters, @splat(digit_first -% digit_value)), offset);
    offset = @select(u8, below_digit, @as(Letters, @splat(lower_first -% lower_value)), offset);
    offset = @select(u8, below_lower, @as(Letters, @splat(upper_first)), offset);
    return values +% offset;
}

/// Decodes 32 letters into the first 24 octets of `room`, when every letter is one `alphabet`
/// holds, or one both alphabets share when `alphabet` is null. It stores all 32 octets of `room`,
/// so the store is whole vectors: the caller reports the first 24 written, and the 8 after them
/// are scratch (decision 11). Returns false, having written nothing, otherwise.
pub fn decode_block(comptime alphabet: ?Alphabet, letters: *const [block_letters]u8, room: *[block_letters]u8) bool {
    const values = values_of(alphabet, letters.*) orelse return false;
    const words: Words = @bitCast(values);
    const byte_mask: Words = @splat(std.math.maxInt(u8));
    var bits: Words = @splat(0);
    inline for (0..constants.quantum_letters) |index| {
        const place = switch (builtin.cpu.arch.endian()) {
            .little => index,
            .big => constants.quantum_letters - 1 - index,
        };
        const value = (words >> @splat(@as(u5, @intCast(place * constants.octet_bits)))) & byte_mask;
        bits |= value << @splat(@as(u5, (constants.quantum_letters - 1 - index) * constants.letter_bits));
    }
    const source: Letters = @bitCast(bits);
    const order = comptime blk: {
        // The 24 octets first, then 8 of no use, so the shuffle fills a whole vector.
        var mask: [block_letters]i32 = @splat(0);
        for (0..lanes) |lane| {
            for (0..constants.group_octets) |index| {
                // Octet `index` of a group is the lane's bits of significance 2 - index.
                const significance = constants.group_octets - 1 - index;
                const place = switch (builtin.cpu.arch.endian()) {
                    .little => significance,
                    .big => @sizeOf(u32) - 1 - significance,
                };
                mask[lane * constants.group_octets + index] = @intCast(lane * @sizeOf(u32) + place);
            }
        }
        break :blk mask;
    };
    const unused: @Vector(1, u8) = @splat(0);
    room.* = @shuffle(u8, source, unused, order);
    return true;
}

/// The offset of an octet in no range: it lifts an octet below 128 to 128 or more, so its value
/// shows it is no letter.
const refused_offset: u8 = 1 << (constants.octet_bits - 1);

/// Each letter's 6-bit value, or null when one is no letter the alphabet holds.
fn values_of(comptime alphabet: ?Alphabet, letters: Letters) ?Letters {
    const upper = letters -% @as(Letters, @splat(upper_first)) < @as(Letters, @splat(letters_in_case));
    const lower = letters -% @as(Letters, @splat(lower_first)) < @as(Letters, @splat(letters_in_case));
    const digit = letters -% @as(Letters, @splat(digit_first)) < @as(Letters, @splat(digits));
    var offset: Letters = @splat(refused_offset);
    offset = @select(u8, digit, @as(Letters, @splat(digit_value -% digit_first)), offset);
    offset = @select(u8, upper, @as(Letters, @splat(@as(u8, 0) -% upper_first)), offset);
    offset = @select(u8, lower, @as(Letters, @splat(lower_value -% lower_first)), offset);
    if (alphabet) |known| {
        const last = comptime last_letters(known);
        offset = @select(u8, letters == @as(Letters, @splat(last[0])), @as(Letters, @splat(value_62 -% last[0])), offset);
        offset = @select(u8, letters == @as(Letters, @splat(last[1])), @as(Letters, @splat(value_63 -% last[1])), offset);
    }
    const values = letters +% offset;
    // A letter's value is below 64. An octet in no range lands at 128 or more when it is below
    // 128, and keeps its high bit in `letters` when it is not.
    const check = values | (letters & @as(Letters, @splat(refused_offset)));
    if (@reduce(.Max, check) >= constants.alphabet_len) return null;
    return values;
}

test "a block takes every letter of its alphabet, and the shared letters with none named" {
    const letters = @import("alphabet.zig");
    inline for (.{ Alphabet.standard, Alphabet.url_safe }) |alphabet| {
        const all = letters.letters(alphabet);
        for (0..constants.alphabet_len / block_letters) |half| {
            const block = all[half * block_letters ..][0..block_letters];
            var room: [block_letters]u8 = undefined;
            try std.testing.expect(decode_block(alphabet, block, &room));
            var back: [block_letters]u8 = undefined;
            encode_block(alphabet, room[0..block_octets], &back);
            try std.testing.expectEqualSlices(u8, block, &back);
        }
        // The first half holds no letter of values 62 and 63, so it needs no alphabet.
        var room: [block_letters]u8 = undefined;
        try std.testing.expect(decode_block(null, all[0..block_letters], &room));
        try std.testing.expect(!decode_block(null, all[block_letters..][0..block_letters], &room));
    }
}
