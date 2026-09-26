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

/// What a table entry stands for.
pub const Kind = enum(u3) { literal, end_of_block, length, distance, long, invalid };

pub const Entry = packed struct(u32) {
    /// The bits the code takes, when it fits the table.
    code_bits: u4,
    /// The extra bits after the code, for a length or a distance (RFC 1951 §3.2.5).
    extra_bits: u4,
    kind: Kind,
    padding: u5 = 0,
    /// A literal's octet, or a length's or distance's base.
    value: u16,

    const invalid: Entry = .{ .code_bits = 0, .extra_bits = 0, .kind = .invalid, .value = 0 };
    const long: Entry = .{ .code_bits = 0, .extra_bits = 0, .kind = .long, .value = 0 };
};

/// The entry for a literal/length symbol whose code takes `code_bits`.
pub fn literal_length_entry(symbol: u16, code_bits: u4) Entry {
    if (symbol < constants.end_of_block) return .{ .code_bits = code_bits, .extra_bits = 0, .kind = .literal, .value = symbol };
    if (symbol == constants.end_of_block) return .{ .code_bits = code_bits, .extra_bits = 0, .kind = .end_of_block, .value = 0 };
    if (symbol >= constants.literal_length_used) return Entry.invalid;
    const index = symbol - constants.first_length_symbol;
    return .{
        .code_bits = code_bits,
        .extra_bits = @intCast(constants.length_extra_bits[index]),
        .kind = .length,
        .value = constants.length_base[index],
    };
}

/// The entry for a distance symbol whose code takes `code_bits`.
pub fn distance_entry(symbol: u16, code_bits: u4) Entry {
    if (symbol >= constants.distance_used) return Entry.invalid;
    return .{
        .code_bits = code_bits,
        .extra_bits = @intCast(constants.distance_extra_bits[symbol]),
        .kind = .distance,
        .value = constants.distance_base[symbol],
    };
}

/// A table for an alphabet whose codes the table takes up to `bits_max` bits of.
pub fn Table(comptime bits_max: u4, comptime entry_of: fn (u16, u4) Entry) type {
    return struct {
        const Self = @This();

        entries: [1 << bits_max]Entry,
        /// The bits this block's table is indexed by: its longest code, up to `bits_max`.
        bits: u4,

        /// Builds the table of the code the lengths define (RFC 1951 §3.2.2), which the caller has
        /// checked is a code the decoder accepts. Returns the entries it wrote.
        pub fn build(self: *Self, lengths: []const u8) usize {
            return build_table(&self.entries, &self.bits, bits_max, lengths, entry_of);
        }

        /// The entry the next bits of the stream select.
        pub fn lookup(self: *const Self, bits: u64) Entry {
            return self.entries[@intCast(bits & ((@as(u64, 1) << self.bits) - 1))];
        }
    };
}

fn build_table(entries: []Entry, table_bits: *u4, bits_max: u4, lengths: []const u8, entry_of: fn (u16, u4) Entry) usize {
    var counts: [constants.code_len_max + 1]u16 = @splat(0);
    for (lengths) |len| counts[len] += 1;
    counts[0] = 0;
    const bits = @max(1, @min(bits_max, longest(counts)));
    table_bits.* = bits;
    const size = @as(usize, 1) << bits;
    // Every entry is written once by a complete code; an incomplete one leaves some unused.
    var written: usize = 0;
    if (!complete(counts)) {
        @memset(entries[0..size], Entry.invalid);
        written += size;
    }
    var next_code = first_codes(counts);
    for (lengths, 0..) |len, symbol| {
        if (len == 0) continue;
        const code = next_code[len];
        next_code[len] += 1;
        const entry = entry_of(@intCast(symbol), @intCast(len));
        written += place(entries[0..size], bits, entry, @intCast(len), code);
    }
    return written;
}

/// The longest code's length.
fn longest(counts: [constants.code_len_max + 1]u16) u4 {
    var len: u4 = 0;
    for (counts, 0..) |count, index| {
        if (count > 0) len = @intCast(index);
    }
    return len;
}

/// Writes the entries of one symbol's code into a table of `bits`, and returns how many.
fn place(entries: []Entry, bits: u4, entry: Entry, len: u4, code: u16) usize {
    if (len > bits) {
        // The first `bits` bits of the code, as the stream gives them, name its prefix.
        entries[reversed(code >> (len - bits), bits)] = Entry.long;
        return 1;
    }
    const step = @as(usize, 1) << len;
    var index: usize = reversed(code, len);
    const count = entries.len >> len;
    for (0..count) |_| {
        entries[index] = entry;
        index += step;
    }
    return count;
}

pub const LiteralLengthTable = Table(constants.literal_length_table_bits, literal_length_entry);
pub const DistanceTable = Table(constants.distance_table_bits, distance_entry);

/// Whether the counts fill the code space: no value unused (RFC 1951 §3.2.2).
fn complete(counts: [constants.code_len_max + 1]u16) bool {
    var left: i32 = 1;
    for (counts[1..]) |count| left = (left << 1) - count;
    return left == 0;
}

/// The first code of each length: RFC 1951 §3.2.2's step 2.
fn first_codes(counts: [constants.code_len_max + 1]u16) [constants.code_len_max + 1]u16 {
    var next_code: [constants.code_len_max + 1]u16 = @splat(0);
    var code: u16 = 0;
    for (1..constants.code_len_max + 1) |len| {
        code = (code + counts[len - 1]) << 1;
        next_code[len] = code;
    }
    return next_code;
}

/// A code of `len` bits, most significant first, as the stream packs it: least significant first
/// (RFC 1951 §3.1.1).
fn reversed(code: u16, len: u4) usize {
    assert(len >= 1);
    return @bitReverse(code) >> @intCast(@bitSizeOf(u16) - @as(u5, len));
}

/// The tables of the fixed codes (RFC 1951 §3.2.6), built once at comptime (decision 14, S7).
pub const fixed_literal_length: LiteralLengthTable = fixed: {
    @setEvalBranchQuota(fixed_build_quota);
    var table: LiteralLengthTable = undefined;
    _ = table.build(&constants.fixed_literal_length_lengths);
    break :fixed table;
};
pub const fixed_distance: DistanceTable = fixed: {
    @setEvalBranchQuota(fixed_build_quota);
    var table: DistanceTable = undefined;
    _ = table.build(&constants.fixed_distance_lengths);
    break :fixed table;
};

/// The comptime branches building a fixed table takes: a few per entry.
const fixed_build_quota = 100_000;

test {
    _ = @import("lookup_test.zig");
}
