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

/// A symbol as the fast path takes it, its length an octet wide: a field of 7 bits in a returned
/// struct sends the length through memory on every symbol.
pub const WholeSymbol = struct { value: u16, len: u8 };

/// What a lookup found in the bits it was given.
pub const Decoded = union(enum) {
    symbol: Symbol,
    /// The bits end before a code does.
    needs_bits,
};

/// The number of codes of each length, 1 to 15; `counts[0]` is unused.
pub const Counts = [constants.code_len_max + 1]u16;

/// A symbol and the length of its code, as the build takes them: in canonical order.
pub const Coded = struct { symbol: u16, len: u8 };

/// The octets of code lengths the canonical sort tests for zero at once.
const lengths_chunk_len = 16;

/// A symbol entry's value in a table built with `build` or `build_single`: the symbol.
fn symbol_itself(symbol: u16) u16 {
    return symbol;
}

pub fn Table(comptime entries_len: usize, comptime root_bits: u5) type {
    comptime assert(entries_len >= 1 << root_bits);
    return struct {
        const Self = @This();

        entries: [entries_len]Entry,

        /// The code of one symbol, which takes no bits (RFC 7932 §3.4, NSYM = 1; §3.5): every root
        /// entry names it. Returns the entries written.
        pub fn build_single(self: *Self, symbol: u16) usize {
            return self.build_single_valued(symbol, symbol_itself);
        }

        /// As `build_single`, the entries holding `value_of(symbol)`: the symbol, and bits above it
        /// that the decoder reads with it.
        pub fn build_single_valued(self: *Self, symbol: u16, comptime value_of: fn (u16) u16) usize {
            @memset(self.entries[0 .. 1 << root_bits], .{ .value = value_of(symbol), .len = 0, .second_bits = 0 });
            return 1 << root_bits;
        }

        /// The canonical code the lengths define, one per symbol, 0 for a symbol with no code (RFC
        /// 7932 §3.2). The caller has checked that they form a complete code of two symbols or more.
        /// Returns the entries written: each entry of the root and of the second levels once.
        pub fn build(self: *Self, lengths: []const u8) usize {
            const counts = counts_of(lengths);
            var buffer: [constants.insert_copy_alphabet_len]Coded = undefined;
            return self.build_sorted(sort_canonical(lengths, &counts, &buffer), &counts);
        }

        /// As `build`, from the symbols with a code in canonical order (`sort_canonical`) and the
        /// count of each length.
        pub fn build_sorted(self: *Self, sorted: []const Coded, counts: *const Counts) usize {
            return self.build_sorted_valued(sorted, counts, symbol_itself);
        }

        /// As `build_sorted`, each symbol entry holding `value_of(symbol)`. A link's value stays the
        /// place of its second level.
        pub fn build_sorted_valued(self: *Self, sorted: []const Coded, counts: *const Counts, comptime value_of: fn (u16) u16) usize {
            return fill_canonical(root_bits, value_of, &self.entries, sorted, counts);
        }

        /// The symbol whose code starts `bits`, least significant bit first, of which `available`
        /// are present.
        pub fn decode(self: *const Self, bits: u64, available: u7) Decoded {
            const whole = look_up(root_bits, &self.entries, bits);
            if (whole.len > available) return .needs_bits;
            return .{ .symbol = .{ .value = whole.value, .len = @intCast(whole.len) } };
        }

        /// The symbol whose code starts `bits`, which hold a longest code's bits at least: the fast
        /// path's lookup, whose margin keeps the buffer that full (decision 16).
        pub inline fn decode_whole(self: *const Self, bits: u64) WholeSymbol {
            return look_up(root_bits, &self.entries, bits);
        }
    };
}

/// The symbols of `lengths` with a code, in canonical order: by length, then by symbol (RFC 7932
/// §3.2), each placed after the codes of shorter lengths that `counts` counts. A chunk of lengths
/// that are all zero is passed over whole.
pub fn sort_canonical(lengths: []const u8, counts: *const Counts, sorted: []Coded) []const Coded {
    var next: Counts = undefined;
    var total: u16 = 0;
    for (1..constants.code_len_max + 1) |len| {
        next[len] = total;
        total += counts[len];
    }
    assert(total <= sorted.len);
    const chunks = lengths.len / lengths_chunk_len;
    for (0..chunks) |chunk| {
        const first = chunk * lengths_chunk_len;
        const octets: @Vector(lengths_chunk_len, u8) = lengths[first..][0..lengths_chunk_len].*;
        if (@reduce(.Or, octets) != 0) place(lengths[first..][0..lengths_chunk_len], first, &next, sorted);
    }
    place(lengths[chunks * lengths_chunk_len ..], chunks * lengths_chunk_len, &next, sorted);
    // The counts count the lengths: each length's codes end where the next length's begin.
    assert(next[constants.code_len_max] == total);
    return sorted[0..total];
}

/// Places each symbol with a code among `lengths`, the first being `first`, after the codes
/// placed before it of its length.
fn place(lengths: []const u8, first: usize, next: *Counts, sorted: []Coded) void {
    for (lengths, first..) |len, symbol| {
        if (len == 0) continue;
        sorted[next[len]] = .{ .symbol = @intCast(symbol), .len = len };
        next[len] += 1;
    }
}

/// The number of codes of each length among `lengths`: per length, a sum over chunks of lengths
/// compared at once, so no count waits for the one before it. A chunk of zeros is passed over.
pub fn counts_of(lengths: []const u8) Counts {
    const Chunk = @Vector(lengths_chunk_len, u8);
    const Sums = @Vector(lengths_chunk_len, u16);
    var sums: [constants.code_len_max + 1]Chunk = @splat(@splat(0));
    const chunks = lengths.len / lengths_chunk_len;
    // A lane counts one per chunk, so no lane's sum passes the chunks of the largest alphabet.
    comptime assert(constants.insert_copy_alphabet_len / lengths_chunk_len <= std.math.maxInt(u8));
    for (0..chunks) |chunk| {
        const octets: Chunk = lengths[chunk * lengths_chunk_len ..][0..lengths_chunk_len].*;
        if (@reduce(.Or, octets) == 0) continue;
        inline for (1..constants.code_len_max + 1) |len| {
            sums[len] += @select(u8, octets == @as(Chunk, @splat(len)), @as(Chunk, @splat(1)), @as(Chunk, @splat(0)));
        }
    }
    var counts: Counts = @splat(0);
    for (1..constants.code_len_max + 1) |len| counts[len] = @reduce(.Add, @as(Sums, sums[len]));
    for (lengths[chunks * lengths_chunk_len ..]) |len| {
        assert(len <= constants.code_len_max);
        if (len != 0) counts[len] += 1;
    }
    return counts;
}

/// Writes the table of the canonical code whose symbols `sorted` holds in canonical order, and
/// returns the entries it takes: the root, and behind it a second level for each root entry whose
/// codes are longer. The codes take consecutive values in that order (RFC 7932 §3.2), so the
/// codes of one root entry come together, the longest last.
fn fill_canonical(comptime root_bits: u5, comptime value_of: fn (u16) u16, entries: []Entry, sorted: []const Coded, counts: *const Counts) usize {
    const len_max = sorted[sorted.len - 1].len;
    var remaining = counts.*;
    var code: u32 = 0;
    var code_len: u8 = 0;
    var table_len: usize = 1 << root_bits;
    // No root entry has this index, so the first longer code links a second level.
    var linked_root: u32 = 1 << root_bits;
    for (sorted) |coded| {
        assert(coded.len >= code_len and coded.len <= constants.code_len_max);
        code <<= @intCast(coded.len - code_len);
        code_len = coded.len;
        const value = value_of(coded.symbol);
        if (coded.len <= root_bits) {
            fill_root(root_bits, entries, value, code, coded.len);
        } else {
            const root = reversed(code >> @intCast(coded.len - root_bits), root_bits);
            if (root != linked_root) {
                const second_bits = second_level_bits(root_bits, coded.len, len_max, &remaining);
                entries[root] = .{ .value = @intCast(table_len), .len = root_bits, .second_bits = second_bits };
                table_len += @as(usize, 1) << @intCast(second_bits);
                linked_root = root;
            }
            fill_second(root_bits, entries, value, code, coded.len);
        }
        remaining[coded.len] -= 1;
        code += 1;
    }
    // The reader checked the sums of RFC 7932 §3.5: the codes take every value.
    assert(code == @as(u32, 1) << @intCast(code_len));
    // tools/brotli_table_budget.zig: no code of the alphabet takes more.
    assert(table_len <= entries.len);
    return table_len;
}

/// The bits of the second level of the root entry whose first code, `len` bits long, comes next:
/// as many as its longest code takes past the root. The codes still to come fill the root entry's
/// values in order, each value at one length becoming two at the next, so its longest code is at
/// the length where they run out.
fn second_level_bits(comptime root_bits: u5, len: u8, len_max: u8, remaining: *const Counts) u8 {
    var bits = len - root_bits;
    var left: i32 = @as(i32, 1) << @intCast(bits);
    for (len..len_max) |longer| {
        left -= remaining[longer];
        if (left <= 0) break;
        bits += 1;
        left <<= 1;
    }
    assert(bits <= constants.code_len_max - root_bits);
    return bits;
}

/// A code of `len` bits up to the root's fills every root entry whose low `len` bits are its bits
/// as the stream holds them.
fn fill_root(comptime root_bits: u5, entries: []Entry, value: u16, code: u32, len: u8) void {
    const low = reversed(code, len);
    for (0..@as(usize, 1) << @intCast(root_bits - len)) |high| {
        entries[low | high << @intCast(len)] = .{ .value = value, .len = len, .second_bits = 0 };
    }
}

/// A longer code fills every entry of its root entry's second level whose low bits are the bits it
/// takes past the root.
fn fill_second(comptime root_bits: u5, entries: []Entry, value: u16, code: u32, len: u8) void {
    const link = entries[reversed(code >> @intCast(len - root_bits), root_bits)];
    assert(link.second_bits > 0);
    const rest_len = len - root_bits;
    const low = reversed(code & ((@as(u32, 1) << @intCast(rest_len)) - 1), rest_len);
    for (0..@as(usize, 1) << @intCast(link.second_bits - rest_len)) |high| {
        entries[link.value + (low | high << @intCast(rest_len))] = .{ .value = value, .len = rest_len, .second_bits = 0 };
    }
}

/// The symbol of the code `bits` start with, and its length: a root entry's, or the entry of its
/// second level that the bits after the root's pick. Bits past the stream's end read as zeros, so a
/// symbol longer than the bits present is one the caller asks more bits for. The build writes no
/// second level wider than `code_len_max`, so its width truncates to a shift's type unchecked.
inline fn look_up(comptime root_bits: u5, entries: anytype, bits: u64) WholeSymbol {
    const root = entries[@intCast(bits & ((1 << root_bits) - 1))];
    if (root.second_bits == 0) return .{ .value = root.value, .len = root.len };
    const second_index = (bits >> root_bits) & ((@as(u64, 1) << @as(u6, @truncate(root.second_bits))) - 1);
    const entry = entries[root.value + @as(usize, @intCast(second_index))];
    return .{ .value = entry.value, .len = root_bits + entry.len };
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
