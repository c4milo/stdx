//! brotli's prefix codes (RFC 7932 §3) as two-level lookup tables, built once per meta-block for
//! every tree (claim B3), and the fixed code §3.5 gives the lengths of the code length code.
//!
//! A table's root has 1 << `root_bits` entries, indexed by a code's first bits as the stream holds
//! them: the first bit least significant (§1.5.1), since a code is packed most significant bit
//! first. A root entry whose codes are longer links to a second level of 1 << (longest -
//! `root_bits`) entries, indexed by the bits after the root's. RFC 7932 §3.2 gives each length's
//! codes consecutive values in symbol order, shorter codes first, and tools/brotli_table_budget.zig
//! computes the most entries any code of an alphabet takes, which constants.zig pins (decision 12).
//!
//! Every code a stream may define is complete, or has one symbol whose code takes no bits (§3.4,
//! §3.5): the decoder's reader checks the lengths against the RFC's sums before it builds a table,
//! so a build only asserts, and a lookup always finds a symbol once it has the bits.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");

/// One entry of a table.
pub const Entry = extern struct {
    /// The symbol; for a root entry that links to a second level, where that level starts.
    value: u16,
    /// The bits the entry's code takes at its level: its whole length in the root, the length past
    /// the root's bits in a second level. A link's is the root's bits.
    len: u8,
    /// A link's second level takes this many bits; 0 for a symbol.
    second_bits: u8,
};

/// A symbol, and the length of its code in bits: 0 for a code of one symbol.
pub const Symbol = struct { value: u16, len: u7 };

/// What a lookup found in the bits it was given.
pub const Decoded = union(enum) {
    symbol: Symbol,
    /// The bits end before a code does.
    needs_bits,
};

/// The number of codes of each length, 1 to 15; `counts[0]` is unused.
const Counts = [constants.code_len_max + 1]u16;

pub fn Table(comptime entries_len: usize, comptime root_bits: u5) type {
    comptime assert(entries_len >= 1 << root_bits);
    return struct {
        const Self = @This();

        entries: [entries_len]Entry,

        /// The code of one symbol, which takes no bits (RFC 7932 §3.4, NSYM = 1; §3.5): every root
        /// entry names it. Returns the entries written.
        pub fn build_single(self: *Self, symbol: u16) usize {
            @memset(self.entries[0 .. 1 << root_bits], .{ .value = symbol, .len = 0, .second_bits = 0 });
            return 1 << root_bits;
        }

        /// The canonical code the lengths define, one per symbol, 0 for a symbol with no code (RFC
        /// 7932 §3.2). The caller has checked that they form a complete code of two symbols or more.
        /// Returns the entries written: each entry of the root and of the second levels once.
        pub fn build(self: *Self, lengths: []const u8) usize {
            return build_entries(root_bits, &self.entries, lengths);
        }

        /// The symbol whose code starts `bits`, least significant bit first, of which `available`
        /// are present.
        pub fn decode(self: *const Self, bits: u64, available: u7) Decoded {
            const symbol = look_up(root_bits, &self.entries, bits);
            if (symbol.len > available) return .needs_bits;
            return .{ .symbol = symbol };
        }

        /// The symbol whose code starts `bits`, which hold a longest code's bits at least: the fast
        /// path's lookup, whose margin keeps the buffer that full (decision 16).
        pub fn decode_whole(self: *const Self, bits: u64) Symbol {
            return look_up(root_bits, &self.entries, bits);
        }
    };
}

fn build_entries(comptime root_bits: u5, entries: []Entry, lengths: []const u8) usize {
    const first_codes = first_codes_of(lengths);
    const table_len = link_second_levels(root_bits, entries, lengths, first_codes);
    var next = first_codes;
    for (lengths, 0..) |len, symbol| {
        if (len == 0) continue;
        const code = next[len];
        next[len] += 1;
        if (len <= root_bits) fill_root(root_bits, entries, @intCast(symbol), code, len) else fill_second(root_bits, entries, @intCast(symbol), code, len);
    }
    return table_len;
}

/// Writes a link in each root entry whose codes are longer than the root, to a second level as wide
/// as the longest of them, placed one after another behind the root. Returns the entries the table
/// takes.
fn link_second_levels(comptime root_bits: u5, entries: []Entry, lengths: []const u8, first_codes: [constants.code_len_max + 1]u32) usize {
    var longest: [1 << root_bits]u8 = @splat(0);
    var next = first_codes;
    for (lengths) |len| {
        if (len <= root_bits) continue;
        const code = next[len];
        next[len] += 1;
        const root = reversed(code >> @intCast(len - root_bits), root_bits);
        longest[root] = @max(longest[root], len);
    }
    var table_len: usize = 1 << root_bits;
    for (longest, 0..) |len, root| {
        if (len == 0) continue;
        const second_bits = len - root_bits;
        entries[root] = .{ .value = @intCast(table_len), .len = root_bits, .second_bits = second_bits };
        table_len += @as(usize, 1) << @intCast(second_bits);
    }
    // tools/brotli_table_budget.zig: no code of the alphabet takes more.
    assert(table_len <= entries.len);
    return table_len;
}

/// A code of `len` bits up to the root's fills every root entry whose low `len` bits are its bits
/// as the stream holds them.
fn fill_root(comptime root_bits: u5, entries: []Entry, symbol: u16, code: u32, len: u8) void {
    const low = reversed(code, len);
    for (0..@as(usize, 1) << @intCast(root_bits - len)) |high| {
        entries[low | high << @intCast(len)] = .{ .value = symbol, .len = len, .second_bits = 0 };
    }
}

/// A longer code fills every entry of its root entry's second level whose low bits are the bits it
/// takes past the root.
fn fill_second(comptime root_bits: u5, entries: []Entry, symbol: u16, code: u32, len: u8) void {
    const link = entries[reversed(code >> @intCast(len - root_bits), root_bits)];
    assert(link.second_bits > 0);
    const rest_len = len - root_bits;
    const low = reversed(code & ((@as(u32, 1) << @intCast(rest_len)) - 1), rest_len);
    for (0..@as(usize, 1) << @intCast(link.second_bits - rest_len)) |high| {
        entries[link.value + (low | high << @intCast(rest_len))] = .{ .value = symbol, .len = rest_len, .second_bits = 0 };
    }
}

/// The symbol of the code `bits` start with, and its length: a root entry's, or the entry of its
/// second level that the bits after the root's pick. Bits past the stream's end read as zeros, so a
/// symbol longer than the bits present is one the caller asks more bits for.
inline fn look_up(comptime root_bits: u5, entries: anytype, bits: u64) Symbol {
    const root = entries[@intCast(bits & ((1 << root_bits) - 1))];
    if (root.second_bits == 0) return .{ .value = root.value, .len = @intCast(root.len) };
    const second_index = (bits >> root_bits) & ((@as(u64, 1) << @intCast(root.second_bits)) - 1);
    const entry = entries[root.value + @as(usize, @intCast(second_index))];
    return .{ .value = entry.value, .len = @intCast(root_bits + entry.len) };
}

/// The first code of each length (RFC 7932 §3.2): after the codes of every shorter length, doubled
/// per bit.
fn first_codes_of(lengths: []const u8) [constants.code_len_max + 1]u32 {
    var counts: Counts = @splat(0);
    for (lengths) |len| {
        assert(len <= constants.code_len_max);
        counts[len] += 1;
    }
    counts[0] = 0;
    var first_codes: [constants.code_len_max + 1]u32 = @splat(0);
    var code: u32 = 0;
    var used: u32 = 0;
    for (1..constants.code_len_max + 1) |len| {
        code = (code + counts[len - 1]) << 1;
        first_codes[len] = code;
        used += @as(u32, counts[len]) << @intCast(constants.code_len_max - len);
    }
    // The reader checked the sums of RFC 7932 §3.5: the codes take every value.
    assert(used == 1 << constants.code_len_max);
    return first_codes;
}

/// The low `len` bits of `code` in reverse order: a code as the stream holds it.
fn reversed(code: u32, len: u8) u32 {
    if (len == 0) return 0;
    return @bitReverse(code) >> @intCast(@bitSizeOf(u32) - @as(u32, len));
}

/// A code length of the code length code, and the bits its fixed code takes (RFC 7932 §3.5).
pub const CodeLengthCodeLength = struct { value: u8, len: u7 };

/// The code length the fixed code of RFC 7932 §3.5 gives the bits, least significant first, or null
/// when fewer than its code's bits are present. The code is a prefix code, so at most one of its
/// codes matches the bits present.
pub fn decode_code_length_code_length(bits: u64, available: u7) ?CodeLengthCodeLength {
    for (constants.code_length_code_length_codes, 0..) |code, value| {
        if (code.len > available) continue;
        if (bits & ((@as(u64, 1) << code.len) - 1) == code.code) return .{ .value = @intCast(value), .len = code.len };
    }
    return null;
}

test {
    _ = @import("prefix_test.zig");
}
