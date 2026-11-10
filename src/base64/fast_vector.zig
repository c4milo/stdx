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
    if (nibble_path) return decode_block_by_nibbles(alphabet, letters, room);
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

/// The nibble tables of one alphabet mode, for a lookup of 16 entries by each octet's high or low
/// four bits (`tbl` on aarch64): an octet is no letter when `by_low[low] & by_high[high]` is not
/// zero, and a letter's value is the octet plus `offsets[high | marked]`, where `marked` is 8 for
/// the one letter whose high nibble it shares with letters of another offset.
const NibbleTables = struct {
    by_low: Nibbles,
    by_high: Nibbles,
    offsets: Nibbles,
    marked: u8,
};

const Nibbles = @Vector(nibble_values, u8);

/// The values of four bits, and the index bit `marked` sets: one above any letter's high nibble.
const nibble_values = 16;

/// The 16-octet halves of one block, each one register.
const halves_per_block = block_letters / nibble_values;

/// The two tables `validity_tables` gives, by low nibble and by high.
const validity_count = 2;

/// The letters, and the 6-bit groups, one lane of `Pairs` holds.
const letters_per_pair = 2;
const nibble_bits = 4;
const marked_bit: u8 = 1 << (nibble_bits - 1);

fn nibble_tables(comptime alphabet: ?Alphabet) NibbleTables {
    comptime {
        const letters = @import("alphabet.zig").letters(alphabet orelse .standard);
        const taken = if (alphabet == null) letters[0..value_62] else letters[0..];
        const marked: u8 = if (alphabet) |known| last_letters(known)[1] else 0;
        const validity = validity_tables(low_sets(taken));
        return .{ .by_low = validity[0], .by_high = validity[1], .offsets = offset_table(taken, marked), .marked = marked };
    }
}

/// Each high nibble's low nibbles that are letters, as a 16-bit set.
fn low_sets(comptime taken: []const u8) [nibble_values]u16 {
    var sets: [nibble_values]u16 = @splat(0);
    for (taken) |letter| sets[letter >> nibble_bits] |= @as(u16, 1) << @intCast(letter % nibble_values);
    return sets;
}

/// The tables by low and by high nibble: one bit for each distinct set of `sets`, which a high
/// nibble's entry holds and each low nibble outside that set holds too.
fn validity_tables(comptime sets: [nibble_values]u16) [validity_count][nibble_values]u8 {
    var distinct: [constants.octet_bits]u16 = undefined;
    var distinct_len: usize = 0;
    var by_low: [nibble_values]u8 = @splat(0);
    var by_high: [nibble_values]u8 = @splat(0);
    for (sets, 0..) |set, high| {
        const bit = std.mem.indexOfScalar(u16, distinct[0..distinct_len], set) orelse blk: {
            std.debug.assert(distinct_len < constants.octet_bits);
            distinct[distinct_len] = set;
            distinct_len += 1;
            break :blk distinct_len - 1;
        };
        by_high[high] = @as(u8, 1) << @intCast(bit);
        for (0..nibble_values) |low| {
            if (set & (@as(u16, 1) << @intCast(low)) == 0) by_low[low] |= @as(u8, 1) << @intCast(bit);
        }
    }
    return .{ by_low, by_high };
}

/// The offset of each index: a letter's value less the letter, the same for every letter that
/// shares an index.
fn offset_table(comptime taken: []const u8, comptime marked: u8) [nibble_values]u8 {
    var offsets: [nibble_values]u8 = @splat(0);
    var filled: [nibble_values]bool = @splat(false);
    for (taken, 0..) |letter, value| {
        const index = (letter >> nibble_bits) | (if (letter == marked and marked != 0) marked_bit else 0);
        const offset = @as(u8, @intCast(value)) -% letter;
        std.debug.assert(!filled[index] or offsets[index] == offset);
        offsets[index] = offset;
        filled[index] = true;
    }
    return offsets;
}

/// Whether this build decodes through the nibble tables: aarch64, whose NEON `tbl` is in its
/// baseline, and x86-64 built with AVX2, whose `vpshufb` looks up 16 entries in each 16-octet lane.
/// The x86-64 variant object of decision 21 is such a build (variants.zig).
const has_avx2 = builtin.cpu.arch == .x86_64 and std.Target.x86.featureSetHas(builtin.cpu.features, .avx2);
pub const nibble_path = builtin.cpu.arch == .aarch64 or has_avx2;

/// The entry of `table` that each octet of `index` names, each 16 octets looking up the same 16
/// entries.
fn lookup(table: Nibbles, index: Letters) Letters {
    if (has_avx2) {
        const both: Letters = std.simd.join(table, table);
        return asm ("vpshufb %[index], %[table], %[out]"
            : [out] "=x" (-> Letters),
            : [table] "x" (both),
              [index] "x" (index),
        );
    }
    const halves: [halves_per_block]Nibbles = @bitCast(index);
    var result: [halves_per_block]Nibbles = undefined;
    inline for (halves, &result) |half, *entry| entry.* = asm ("tbl %[out].16b, {%[table].16b}, %[index].16b"
        : [out] "=w" (-> Nibbles),
        : [table] "w" (table),
          [index] "w" (half),
    );
    return @bitCast(result);
}

/// Each 16 octets of `data` in the order `order` names, an index of 16 or more giving 0.
fn reorder(data: Letters, order: Nibbles) Letters {
    if (has_avx2) {
        const both: Letters = std.simd.join(order, order);
        return asm ("vpshufb %[index], %[table], %[out]"
            : [out] "=x" (-> Letters),
            : [table] "x" (data),
              [index] "x" (both),
        );
    }
    const halves: [halves_per_block]Nibbles = @bitCast(data);
    var result: [halves_per_block]Nibbles = undefined;
    inline for (halves, &result) |half, *entry| entry.* = asm ("tbl %[out].16b, {%[table].16b}, %[index].16b"
        : [out] "=w" (-> Nibbles),
        : [table] "w" (half),
          [index] "w" (order),
    );
    return @bitCast(result);
}

/// Each letter's 6-bit value through the nibble tables, or null when one is no letter the mode
/// takes: three lookups each 16 letters.
fn values_by_nibbles(comptime alphabet: ?Alphabet, letters: Letters) ?Letters {
    const tables = comptime nibble_tables(alphabet);
    const high = letters >> @splat(nibble_bits);
    const low = letters & @as(Letters, @splat(nibble_values - 1));
    const refused = lookup(tables.by_low, low) & lookup(tables.by_high, high);
    var index = high;
    if (tables.marked != 0) {
        index |= @select(u8, letters == @as(Letters, @splat(tables.marked)), @as(Letters, @splat(marked_bit)), @as(Letters, @splat(0)));
    }
    if (@reduce(.Or, refused) != 0) return null;
    return letters +% lookup(tables.offsets, index);
}

/// The octets of a group of four lanes, in a 16-octet half: three from each lane, most
/// significant first, then four of no use (`tbl` gives 0 for an index past 15).
const half_order: Nibbles = blk: {
    var order: [nibble_values]u8 = @splat(nibble_values);
    for (0..nibble_values / @sizeOf(u32)) |lane| {
        for (0..constants.group_octets) |index| {
            order[lane * constants.group_octets + index] = @intCast(lane * @sizeOf(u32) + constants.group_octets - 1 - index);
        }
    }
    break :blk order;
};

/// `decode_block` on aarch64, which is little-endian: the nibble tables give the values, two
/// letters join in each 16-bit lane and two pairs in each 32-bit lane, and one lookup a half puts
/// each lane's three octets in order. The second half's store overwrites the first's spare four.
fn decode_block_by_nibbles(comptime alphabet: ?Alphabet, letters: *const [block_letters]u8, room: *[block_letters]u8) bool {
    comptime std.debug.assert(builtin.cpu.arch.endian() == .little);
    const values = values_by_nibbles(alphabet, letters.*) orelse return false;
    const Pairs = @Vector(block_letters / letters_per_pair, u16);
    const pairs: Pairs = @bitCast(values);
    // The first letter of a pair is the low octet of its lane, and holds the high six bits.
    const joined = (pairs & @as(Pairs, @splat(constants.alphabet_len - 1))) << @splat(constants.letter_bits) | pairs >> @splat(constants.octet_bits);
    const quads: Words = @bitCast(joined);
    const pair_bits = letters_per_pair * constants.letter_bits;
    const pair_mask: Words = @splat((1 << pair_bits) - 1);
    const bits = (quads & pair_mask) << @splat(pair_bits) | quads >> @splat(@bitSizeOf(u16));
    const ordered: [halves_per_block]Nibbles = @bitCast(reorder(@bitCast(bits), half_order));
    const half_octets = nibble_values / @sizeOf(u32) * constants.group_octets;
    room[0..nibble_values].* = ordered[0];
    room[half_octets..][0..nibble_values].* = ordered[1];
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

test "a block refuses each octet its mode does not take, at every place" {
    const table = @import("alphabet.zig");
    inline for (.{ @as(?Alphabet, null), @as(?Alphabet, .standard), @as(?Alphabet, .url_safe) }) |mode| {
        const base = table.letters(mode orelse .standard)[0..block_letters];
        for (0..std.math.maxInt(u8) + 1) |octet| {
            const entry = table.table[octet];
            const flags = entry & table.flags_mask;
            const takes = entry != table.not_a_letter and
                (flags == 0 or (mode != null and flags == table.only_flag(mode.?)));
            if (takes) continue;
            for (0..block_letters) |place| {
                var block: [block_letters]u8 = base.*;
                block[place] = @intCast(octet);
                var room: [block_letters]u8 = undefined;
                try std.testing.expect(!decode_block(mode, &block, &room));
            }
        }
    }
}
