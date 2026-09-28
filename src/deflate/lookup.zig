//! The lookup tables of the fast path (decision 14, S2): a block's literal/length and distance
//! codes as tables indexed by the next bits of the stream, least significant bit first, so most
//! symbols take one lookup. An entry carries what the symbol means: a literal, the end of the
//! block, or a length's or distance's base and extra bits (RFC 1951 §3.2.5).
//!
//! A table is as wide as the block's longest code, up to its alphabet's `bits_max`. A code longer
//! than the table marks its prefix's entry `long`, and the fast path decodes that symbol with the
//! canonical code of huffman.zig; such codes are rare by construction, since each is less likely
//! than 1 in 2^`bits_max`. A value no code names, and the symbols RFC 1951 §3.2.6 says never occur,
//! are `invalid`: the fast path leaves them to the checked path, which refuses them.
//!
//! The literal/length table also takes a length's extra bits into its entries when the length's
//! code and extra bits fit the table: each value of the extra bits then has an entry of its own,
//! which holds the whole length, so the fast path reads no extra bits for it.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const huffman = @import("huffman.zig");

/// What an entry that decodes no symbol of its own stands for.
pub const Other = enum(u2) {
    /// The entry decodes a symbol, which one of its flags names.
    none,
    /// The end of the block: literal/length symbol 256 (RFC 1951 §3.2.5).
    end_of_block,
    /// A code longer than the table, which the canonical code decodes.
    long,
    /// A value no code names, or a symbol RFC 1951 §3.2.6 says never occurs.
    invalid,
};

pub const Entry = packed struct(u32) {
    /// The bits the entry takes: its code's, and for a length or a distance, its extra bits'
    /// after the code (RFC 1951 §3.2.5). With `zero` it makes the entry's low six bits, the
    /// amount a 64-bit shift takes, so the fast path shifts its bit buffer by the whole entry.
    used_bits: u5,
    zero: u1 = 0,
    /// What the entry stands for when no flag below is set.
    other: Other = .none,
    /// The bits before the extra bits `value` still needs: the code's, or all of `used_bits`
    /// when the table took the extra bits into `value`.
    code_bits: u4 = 0,
    /// A literal, whose octet `value` holds. Each kind the fast path tests is one bit.
    literal: bool = false,
    /// A length in the literal/length table, or a distance in the distance table.
    direct: bool = false,
    /// `value` is a base, and the extra bits after the code add to it; clear, it is the whole
    /// value.
    extra: bool = false,
    /// A length and the code of its distance, in the literal/length table: `value` holds the
    /// length and the distance's symbol, `code_bits` the bits before the distance's extra bits,
    /// and `used_bits` the bits of all four.
    combined: bool = false,
    /// A literal's octet, a length or a distance, a length's or a distance's base, or for a
    /// combined entry a length and a distance symbol.
    value: u16 = 0,

    /// A combined entry's length.
    pub fn combined_length(self: Entry) u16 {
        return self.value & ((1 << combined_length_bits) - 1);
    }

    /// A combined entry's distance symbol.
    pub fn combined_distance_symbol(self: Entry) u5 {
        return @truncate(self.value >> combined_length_bits);
    }

    pub const invalid: Entry = .{ .used_bits = 0, .other = .invalid };

    /// The entry of the prefix of codes longer than a table of `bits`: the prefix, most
    /// significant bit first, as RFC 1951 §3.2.2 counts a code's value, and `bits`, so a decoder
    /// goes on from the prefix. It uses no bits itself.
    pub fn long(prefix: u16, bits: u4) Entry {
        assert(prefix >> bits == 0);
        return .{ .used_bits = 0, .other = .long, .code_bits = bits, .value = prefix };
    }

    /// The entry of a length or a distance with a code of `code_bits`, and `extra_bits` after it.
    fn coded(value: u16, code_bits: u4, extra_bits: u4) Entry {
        return .{
            .used_bits = @as(u5, code_bits) + extra_bits,
            .code_bits = code_bits,
            .direct = true,
            .extra = extra_bits > 0,
            .value = value,
        };
    }
};

/// The bits of a combined entry's `value` that hold its length, below its distance symbol.
pub const combined_length_bits = std.math.log2_int_ceil(u16, constants.match_len_max + 1);

comptime {
    assert(combined_length_bits + @bitSizeOf(u5) <= @bitSizeOf(u16));
    // A length's or a distance's code and extra bits fit `used_bits`, codes up to 15 bits long.
    assert(constants.code_len_max + std.mem.max(u7, &constants.distance_extra_bits) <= std.math.maxInt(u5));
    assert(constants.code_len_max + std.mem.max(u7, &constants.length_extra_bits) <= std.math.maxInt(u5));
}

/// The entry for a literal/length symbol whose code takes `code_bits`.
pub fn literal_length_entry(symbol: u16, code_bits: u4) Entry {
    if (symbol < constants.end_of_block) return .{ .used_bits = code_bits, .code_bits = code_bits, .literal = true, .value = symbol };
    if (symbol == constants.end_of_block) return .{ .used_bits = code_bits, .code_bits = code_bits, .other = .end_of_block };
    if (symbol >= constants.literal_length_used) return Entry.invalid;
    const index = symbol - constants.first_length_symbol;
    return Entry.coded(constants.length_base[index], code_bits, @intCast(constants.length_extra_bits[index]));
}

/// Each length symbol's entry for a code of no bits, from symbol 257 (RFC 1951 §3.2.5): a decoder
/// that decodes a length from a code longer than the table adds the code's bits to the entry's
/// bits and to its code's bits.
pub const length_entries: [constants.length_base.len]Entry = entries: {
    var entries: [constants.length_base.len]Entry = undefined;
    for (&entries, 0..) |*entry, index| entry.* = literal_length_entry(constants.first_length_symbol + index, 0);
    break :entries entries;
};

/// The entry for length symbol `symbol`, whose code takes `code_bits`, followed by the extra bits
/// `extra`: the whole length, and the bits of both.
pub fn resolved_length_entry(symbol: u16, code_bits: u4, extra: u16) Entry {
    const index = symbol - constants.first_length_symbol;
    const extra_bits: u4 = @intCast(constants.length_extra_bits[index]);
    assert(extra >> extra_bits == 0);
    const len = constants.length_base[index] + extra;
    // RFC 1951 §3.2.5: code 284 stands for lengths 227 - 257; 258 has code 285 alone.
    if (len == constants.match_len_max and symbol != constants.last_length_symbol) return Entry.invalid;
    const used_bits: u5 = @as(u5, code_bits) + extra_bits;
    return .{ .used_bits = used_bits, .code_bits = @intCast(used_bits), .direct = true, .value = len };
}

/// The entry for a length whose extra bits a table resolved, `length`, and the code of its
/// distance, `distance`, whose symbol is `symbol`: the bits of both, and the length and the symbol
/// in the value.
pub fn combined_entry(length: Entry, distance: Entry, symbol: u5) Entry {
    assert(length.direct and !length.extra and distance.direct);
    return .{
        .used_bits = length.used_bits + distance.used_bits,
        .code_bits = @intCast(length.used_bits + @as(u5, distance.code_bits)),
        .combined = true,
        .value = length.value | @as(u16, symbol) << combined_length_bits,
    };
}

/// The distance symbol whose base is `base` (RFC 1951 §3.2.5): the first four stand for 1 to 4,
/// then each pair of symbols starts at the next power of two and at one and a half times it,
/// counting from a distance of 1.
pub fn distance_symbol(base: u16) u5 {
    assert(base >= 1);
    const from_one = base - 1;
    if (from_one < constants.distance_codes_plain) return @intCast(from_one);
    const high: u4 = @intCast(std.math.log2_int(u16, from_one));
    const half: u1 = @truncate(from_one >> (high - 1));
    return @intCast(constants.distance_codes_per_extra_bits * @as(u5, high) + half);
}

comptime {
    for (constants.distance_base, 0..) |base, symbol| assert(distance_symbol(base) == symbol);
}

/// The entry for a distance symbol whose code takes `code_bits`.
pub fn distance_entry(symbol: u16, code_bits: u4) Entry {
    if (symbol >= constants.distance_used) return Entry.invalid;
    return Entry.coded(constants.distance_base[symbol], code_bits, @intCast(constants.distance_extra_bits[symbol]));
}

/// A table for an alphabet whose codes the table takes up to `bits_max` bits of.
/// The codes of one length longer than a table (RFC 1951 §3.2.2): the first's value, how many
/// there are, and the first's place among the code's symbols. A decoder that has read a long
/// code's prefix, most significant bit first, goes on from it a length at a time.
pub const LongCodes = packed struct(u64) { first: u16, count: u16, index: u16, zero: u16 = 0 };

pub fn Table(comptime bits_max: u4, comptime entry_of: fn (u16, u4) Entry) type {
    return struct {
        const Self = @This();

        entries: [len]Entry,
        /// The bits this block's table is indexed by: its longest code, up to `bits_max`.
        bits: u4,
        /// Whether the build resolved the lengths' extra bits (`build`).
        resolved: bool,
        /// The codes of each length longer than `bits`, which the build writes for those lengths
        /// alone; the others are unused.
        long_codes: [constants.code_len_max + 1]LongCodes,

        /// The entries of the widest table.
        pub const len = 1 << bits_max;

        /// An index into `entries`: its type holds every index and no other, so indexing by it
        /// needs no bounds check.
        pub const Index = std.meta.Int(.unsigned, bits_max);

        /// Builds the table of the canonical code huffman.zig built from a block's lengths, which
        /// the decoder accepts: its `counts` of each length and its `symbols` in code order (RFC
        /// 1951 §3.2.2). When it `resolves` lengths, each length whose code and extra bits fit the
        /// table gets an entry for each value of its extra bits. Returns the entries it wrote.
        pub fn build(self: *Self, counts: *const Counts, symbols: []const u16, resolves: bool) usize {
            return self.build_shaped(bits_max, counts, symbols, resolves);
        }

        /// `build`, at most `width` bits wide, for S2's A/B (claims.zig).
        pub fn build_shaped(self: *Self, comptime width: u4, counts: *const Counts, symbols: []const u16, resolves: bool) usize {
            comptime assert(width <= bits_max);
            const written = build_table(&self.entries, &self.bits, &self.long_codes, width, counts, symbols, entry_of, resolves);
            self.resolved = resolves;
            // Invariant 17: the build stays within the bound its count is priced at.
            const resolved_max = if (resolves) constants.resolved_length_entries_max else 0;
            assert(written <= constants.table_build_work_max(width, symbols.len) + resolved_max);
            return written;
        }

        /// The entry the next bits of the stream select.
        pub fn lookup(self: *const Self, bits: u64) Entry {
            return self.entries[@intCast(bits & ((@as(u64, 1) << self.bits) - 1))];
        }

        /// The mask that keeps the bits this block's table is indexed by.
        pub fn mask(self: *const Self) Index {
            assert(self.bits <= bits_max);
            return @intCast((@as(u32, 1) << self.bits) - 1);
        }
    };
}

/// The number of codes of each length, 0 to 15, as huffman.zig counts them: none of length 0.
pub const Counts = [constants.code_len_max + 1]u16;

/// The entries of the table a build starts from: one bit's.
const first_table_len = 2;

/// Where each length's codes start: the first code, and the place of its first symbol in the
/// code-ordered symbols (RFC 1951 §3.2.2, step 2); and the code lengths whose codes include a
/// length symbol, one bit each, which the extra bits of lengths are resolved for.
const Starts = struct {
    codes: Counts,
    symbols: Counts,
    with_lengths: u16 = 0,
};

/// Places the codes of each length in a table of that length's size, from the shortest, and
/// doubles the table before the next length, so each code is written once and each doubling is a
/// copy. The table starts as two unused values, which each doubling copies on, so an incomplete
/// code leaves them invalid. When it `resolves` lengths, each length whose code and extra bits fit
/// the table gets an entry for each value of its extra bits, at the width they take.
fn build_table(entries: []Entry, table_bits: *u4, long_codes: *[constants.code_len_max + 1]LongCodes, bits_max: u4, counts: *const Counts, symbols: []const u16, entry_of: fn (u16, u4) Entry, resolves: bool) usize {
    assert(counts[0] == 0);
    const bits = @max(1, @min(bits_max, longest(counts.*)));
    table_bits.* = bits;
    @memset(entries[0..first_table_len], Entry.invalid);
    var written: usize = first_table_len;
    var starts: Starts = .{ .codes = @splat(0), .symbols = @splat(0) };
    var code: u16 = 0;
    var placed: u16 = 0;
    for (1..constants.code_len_max + 1) |len| {
        // RFC 1951 §3.2.2, step 2: the first code of this length.
        code = (code + counts[len - 1]) << 1;
        starts.codes[len] = code;
        starts.symbols[len] = placed;
        if (len > bits) long_codes[len] = .{ .first = code, .count = counts[len], .index = placed };
        const of_length = symbols[placed..][0..counts[len]];
        // Length symbols sort after every other of their code length.
        if (of_length.len > 0 and of_length[of_length.len - 1] >= constants.first_length_symbol) starts.with_lengths |= @as(u16, 1) << @intCast(len);
        if (len > 1 and len <= bits) {
            const half = @as(usize, 1) << @intCast(len - 1);
            @memcpy(entries[half..][0..half], entries[0..half]);
            written += half;
        }
        written += place_codes(entries, bits, of_length, @intCast(len), code, entry_of);
        if (resolves and len <= bits) written += resolve_lengths(entries, @intCast(len), counts, symbols, &starts);
        placed += counts[len];
    }
    return written;
}

/// Writes the entries of the codes of one length, `first_code` and on, one entry each: in the
/// table of that length's size, or as a long code's prefix in the whole table.
fn place_codes(entries: []Entry, bits: u4, symbols: []const u16, len: u4, first_code: u16, entry_of: fn (u16, u4) Entry) usize {
    if (len > bits) return place_prefixes(entries, bits, symbols.len, len, first_code);
    for (symbols, 0..) |symbol, index| {
        const code: u16 = @intCast(first_code + index);
        entries[reversed(code, len)] = entry_of(symbol, len);
    }
    return symbols.len;
}

/// Writes the entry of each prefix the `count` codes of `len` bits, `first_code` and on, share:
/// their first `bits` bits, as the stream gives them, name it. Consecutive codes share a prefix,
/// which is written once. Returns the codes, the most it writes.
fn place_prefixes(entries: []Entry, bits: u4, count: usize, len: u4, first_code: u16) usize {
    const shift: u4 = len - bits;
    const long_bits: u32 = @bitCast(Entry.long(0, bits));
    var last: ?u16 = null;
    for (0..count) |index| {
        const prefix: u16 = @intCast((first_code + index) >> shift);
        if (last == prefix) continue;
        last = prefix;
        entries[reversed(prefix, bits)] = @bitCast(long_bits | @as(u32, prefix) << @bitOffsetOf(Entry, "value"));
    }
    return count;
}

/// Writes, now that the table is `level` bits wide, an entry for each value of the extra bits of
/// the lengths whose code and extra bits take `level` bits: the value's bits follow the code's in
/// the index. Returns the entries it wrote.
fn resolve_lengths(entries: []Entry, level: u4, counts: *const Counts, symbols: []const u16, starts: *const Starts) usize {
    var written: usize = 0;
    for (1..length_extra_bits_max + 1) |extra_bits| {
        if (extra_bits >= level) break;
        const code_bits: u4 = @intCast(level - extra_bits);
        if (starts.with_lengths & @as(u16, 1) << code_bits == 0) continue;
        const group = symbols[starts.symbols[code_bits]..][0..counts[code_bits]];
        written += resolve_group(entries, group, code_bits, starts.codes[code_bits], @intCast(extra_bits));
    }
    return written;
}

/// `resolve_lengths` for the codes of `code_bits`, `first_code` and on, whose lengths take
/// `extra_bits`. Length symbols sort after every other in their group, so a scan from the group's
/// end meets them alone.
fn resolve_group(entries: []Entry, group: []const u16, code_bits: u4, first_code: u16, extra_bits: u4) usize {
    var written: usize = 0;
    for (0..group.len) |from_end| {
        const index = group.len - 1 - from_end;
        const symbol = group[index];
        if (symbol < constants.first_length_symbol) break;
        if (symbol >= constants.literal_length_used) continue;
        if (constants.length_extra_bits[symbol - constants.first_length_symbol] != extra_bits) continue;
        const prefix = reversed(@intCast(first_code + index), code_bits);
        for (0..@as(usize, 1) << extra_bits) |extra| {
            entries[prefix | extra << code_bits] = resolved_length_entry(symbol, code_bits, @intCast(extra));
        }
        written += @as(usize, 1) << extra_bits;
    }
    return written;
}

/// The most extra bits a length code takes (RFC 1951 §3.2.5).
const length_extra_bits_max = std.mem.max(u7, &constants.length_extra_bits);

/// The longest code's length.
fn longest(counts: [constants.code_len_max + 1]u16) u4 {
    var len: u4 = 0;
    for (counts, 0..) |count, index| {
        if (count > 0) len = @intCast(index);
    }
    return len;
}

pub const LiteralLengthTable = Table(constants.literal_length_table_bits, literal_length_entry);
pub const DistanceTable = Table(constants.distance_table_bits, distance_entry);

/// Combines each entry of `literal_length`, built with its lengths resolved, whose length leaves room in its index for the
/// whole code of the next bits' distance with that distance's entry in `distance`, so a lookup
/// decodes the length and the distance's code at once. The distance's extra bits stay in the
/// stream after its code. Returns the entries it read or wrote.
pub fn combine(literal_length: *LiteralLengthTable, distance: *const DistanceTable) usize {
    const bits = literal_length.bits;
    const entries = literal_length.entries[0 .. @as(usize, 1) << bits];
    for (entries, 0..) |*entry, index| {
        if (!entry.direct or entry.extra or entry.used_bits >= bits) continue;
        // The index's bits past the length's start the distance's code, and those past the index
        // are unknown: the distance's entry stands whatever they are when its code fits.
        const next = distance.lookup(index >> @intCast(entry.used_bits));
        if (!next.direct or entry.used_bits + next.code_bits > bits) continue;
        entry.* = combined_entry(entry.*, next, distance_symbol(next.value));
    }
    return constants.combine_work_max(bits);
}

/// The entry of a literal/length code longer than the table, decoded with the canonical code from
/// `buffer`, or null for the checked path: a value no code names.
pub fn resolve_literal_length(code: *const huffman.Code(constants.literal_length_alphabet_len), buffer: u64) ?Entry {
    return switch (code.decode(buffer, constants.code_len_max)) {
        .symbol => |symbol| literal_length_entry(symbol.value, @intCast(symbol.len)),
        .needs_bits, .invalid => null,
    };
}

/// The distance entry of a table entry that is not a distance's: a long code's, decoded with the
/// canonical code from `buffer`, or null for the checked path.
pub fn resolve_distance(code: *const huffman.Code(constants.distance_alphabet_len), entry: Entry, buffer: u64) ?Entry {
    if (entry.other != .long) return null;
    const resolved = switch (code.decode(buffer, constants.code_len_max)) {
        .symbol => |symbol| distance_entry(symbol.value, @intCast(symbol.len)),
        .needs_bits, .invalid => return null,
    };
    // RFC 1951 §3.2.6: distance codes 30 and 31 never occur; the checked path refuses them.
    if (!resolved.direct) return null;
    return resolved;
}

/// A code of `len` bits, most significant first, as the stream packs it: least significant first
/// (RFC 1951 §3.1.1).
fn reversed(code: u16, len: u4) usize {
    assert(len >= 1);
    return @bitReverse(code) >> @intCast(@bitSizeOf(u16) - @as(u5, len));
}

/// The tables of the fixed codes (RFC 1951 §3.2.6), built once at comptime (decision 14, S7).
pub const fixed_literal_length = Fixed(constants.literal_length_table_bits, constants.distance_table_bits).literal_length;
pub const fixed_distance = Fixed(constants.literal_length_table_bits, constants.distance_table_bits).distance;

/// The fixed codes' tables in the shape `build_shaped` gives: as wide as `literal_length_width` and
/// `distance_width` allow.
pub fn Fixed(comptime literal_length_width: u4, comptime distance_width: u4) type {
    return struct {
        pub const literal_length: LiteralLengthTable = fixed: {
            @setEvalBranchQuota(fixed_build_quota);
            var table: LiteralLengthTable = undefined;
            _ = table.build_shaped(literal_length_width, &huffman.fixed_literal_length.counts, &huffman.fixed_literal_length.symbols, true);
            break :fixed table;
        };
        pub const distance: DistanceTable = fixed: {
            @setEvalBranchQuota(fixed_build_quota);
            var table: DistanceTable = undefined;
            _ = table.build_shaped(distance_width, &huffman.fixed_distance.counts, &huffman.fixed_distance.symbols, false);
            break :fixed table;
        };
    };
}

/// The comptime branches building a fixed table takes: a few per entry.
const fixed_build_quota = 100_000;

test {
    _ = @import("lookup_test.zig");
}
