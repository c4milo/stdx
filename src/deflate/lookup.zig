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

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const huffman = @import("huffman.zig");

/// What a table entry stands for.
pub const Kind = enum(u3) {
    literal,
    end_of_block,
    length,
    distance,
    long,
    invalid,
};

pub const Entry = packed struct(u32) {
    /// The bits the symbol takes: its code's, and for a length or a distance, its extra bits'
    /// after the code (RFC 1951 §3.2.5). With `reserved` it fills the entry's low octet, so the
    /// fast path shifts its bit buffer by the whole entry: a 64-bit shift uses only the low six
    /// bits of its amount.
    used_bits: u5,
    reserved: u3 = 0,
    /// The bits the code alone takes, when it fits the table.
    code_bits: u4,
    kind: Kind,
    /// Set on an entry the canonical decode built, for a code longer than the table, so S2's
    /// count tells it from a table's (options.zig).
    canonical: bool = false,
    /// A literal's octet, or a length's or distance's base.
    value: u16,

    const invalid: Entry = .{ .used_bits = 0, .code_bits = 0, .kind = .invalid, .value = 0 };
    const long: Entry = .{ .used_bits = 0, .code_bits = 0, .kind = .long, .value = 0 };

    /// The entry with a code of `code_bits`, and `extra_bits` after it.
    fn coded(kind: Kind, value: u16, code_bits: u4, extra_bits: u4) Entry {
        return .{ .used_bits = @as(u5, code_bits) + extra_bits, .code_bits = code_bits, .kind = kind, .value = value };
    }
};

comptime {
    // A length's or a distance's code and extra bits fit `used_bits`, codes up to 15 bits long.
    assert(constants.code_len_max + std.mem.max(u7, &constants.distance_extra_bits) <= std.math.maxInt(u5));
    assert(constants.code_len_max + std.mem.max(u7, &constants.length_extra_bits) <= std.math.maxInt(u5));
}

/// The entry for a literal/length symbol whose code takes `code_bits`.
pub fn literal_length_entry(symbol: u16, code_bits: u4) Entry {
    if (symbol < constants.end_of_block) return Entry.coded(.literal, symbol, code_bits, 0);
    if (symbol == constants.end_of_block) return Entry.coded(.end_of_block, 0, code_bits, 0);
    if (symbol >= constants.literal_length_used) return Entry.invalid;
    const index = symbol - constants.first_length_symbol;
    return Entry.coded(.length, constants.length_base[index], code_bits, @intCast(constants.length_extra_bits[index]));
}

/// The entry for a distance symbol whose code takes `code_bits`.
pub fn distance_entry(symbol: u16, code_bits: u4) Entry {
    if (symbol >= constants.distance_used) return Entry.invalid;
    return Entry.coded(.distance, constants.distance_base[symbol], code_bits, @intCast(constants.distance_extra_bits[symbol]));
}

/// A table for an alphabet whose codes the table takes up to `bits_max` bits of.
pub fn Table(comptime bits_max: u4, comptime entry_of: fn (u16, u4) Entry) type {
    return struct {
        const Self = @This();

        entries: [1 << bits_max]Entry,
        /// The bits this block's table is indexed by: its longest code, up to `bits_max`.
        bits: u4,

        /// An index into `entries`: its type holds every index and no other, so indexing by it
        /// needs no bounds check.
        pub const Index = std.meta.Int(.unsigned, bits_max);

        /// Builds the table of the canonical code huffman.zig built from a block's lengths, which
        /// the decoder accepts: its `counts` of each length and its `symbols` in code order (RFC
        /// 1951 §3.2.2). Returns the entries it wrote.
        pub fn build(self: *Self, counts: *const Counts, symbols: []const u16) usize {
            return self.build_shaped(bits_max, counts, symbols);
        }

        /// `build`, at most `width` bits wide, for S2's A/B (claims.zig).
        pub fn build_shaped(self: *Self, comptime width: u4, counts: *const Counts, symbols: []const u16) usize {
            comptime assert(width <= bits_max);
            const written = build_table(&self.entries, &self.bits, width, counts, symbols, entry_of);
            // Invariant 17: the build stays within the bound its count is priced at.
            assert(written <= constants.table_build_work_max(width, symbols.len));
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

/// Places the codes of each length in a table of that length's size, from the shortest, and
/// doubles the table before the next length, so each code is written once and each doubling is a
/// copy. The table starts as two unused values, which each doubling copies on, so an incomplete
/// code leaves them invalid.
fn build_table(entries: []Entry, table_bits: *u4, bits_max: u4, counts: *const Counts, symbols: []const u16, entry_of: fn (u16, u4) Entry) usize {
    assert(counts[0] == 0);
    const bits = @max(1, @min(bits_max, longest(counts.*)));
    table_bits.* = bits;
    @memset(entries[0..first_table_len], Entry.invalid);
    var written: usize = first_table_len;
    var code: u16 = 0;
    var placed: u16 = 0;
    for (1..constants.code_len_max + 1) |len| {
        // RFC 1951 §3.2.2, step 2: the first code of this length.
        code = (code + counts[len - 1]) << 1;
        const of_length = symbols[placed..][0..counts[len]];
        if (len > 1 and len <= bits) {
            const half = @as(usize, 1) << @intCast(len - 1);
            @memcpy(entries[half..][0..half], entries[0..half]);
            written += half;
        }
        written += place_codes(entries, bits, of_length, @intCast(len), code, entry_of);
        placed += counts[len];
    }
    return written;
}

/// Writes the entries of the codes of one length, `first_code` and on, one entry each: in the
/// table of that length's size, or as a long code's prefix in the whole table.
fn place_codes(entries: []Entry, bits: u4, symbols: []const u16, len: u4, first_code: u16, entry_of: fn (u16, u4) Entry) usize {
    for (symbols, 0..) |symbol, index| {
        const code: u16 = @intCast(first_code + index);
        if (len <= bits) {
            entries[reversed(code, len)] = entry_of(symbol, len);
        } else {
            // The first `bits` bits of the code, as the stream gives them, name its prefix.
            entries[reversed(code >> (len - bits), bits)] = Entry.long;
        }
    }
    return symbols.len;
}

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
            _ = table.build_shaped(literal_length_width, &huffman.fixed_literal_length.counts, &huffman.fixed_literal_length.symbols);
            break :fixed table;
        };
        pub const distance: DistanceTable = fixed: {
            @setEvalBranchQuota(fixed_build_quota);
            var table: DistanceTable = undefined;
            _ = table.build_shaped(distance_width, &huffman.fixed_distance.counts, &huffman.fixed_distance.symbols);
            break :fixed table;
        };
    };
}

/// The comptime branches building a fixed table takes: a few per entry.
const fixed_build_quota = 100_000;

test {
    _ = @import("lookup_test.zig");
}
