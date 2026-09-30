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
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const fill = @import("prefix_fill.zig");

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

/// A run of symbols whose codes have one length: `count` symbols from `first`, and the next run of
/// that length, or `constants.range_none`.
pub const Range = struct { first: u16, count: u16, next: u16 };

/// The runs of equal code lengths a complex code's reading appends, one list per length in symbol
/// order: RFC 7932 §3.2's canonical order, by length and then by symbol, with no sort after the
/// reading. A run that continues its length's last run joins it.
pub const Ranges = struct {
    heads: [constants.code_len_max + 1]u16,
    tails: [constants.code_len_max + 1]u16,
    ranges: [constants.code_ranges_max]Range,
    count: u16,

    /// Empties every list.
    pub fn reset(self: *Ranges) void {
        self.heads = @splat(constants.range_none);
        self.count = 0;
    }

    /// Appends `count` symbols from `first`, each with a code of `len` bits, after the length's runs.
    /// Inline, so that the reading loop keeps its own fields in registers across the append.
    pub inline fn append(self: *Ranges, len: u8, first: u16, count: u16) void {
        assert(len >= 1 and len <= constants.code_len_max and count >= 1);
        // A run and the runs' count stay within the alphabet, which the reading bounds, so the sums
        // below wrap never and take no check.
        if (self.heads[len] != constants.range_none) {
            const tail = &self.ranges[self.tails[len]];
            if (tail.first +% tail.count == first) {
                tail.count +%= count;
                return;
            }
        }
        // Each code length symbol gives at least one length, so the alphabet bounds the runs.
        assert(self.count < constants.code_ranges_max);
        self.ranges[self.count] = .{ .first = first, .count = count, .next = constants.range_none };
        if (self.heads[len] == constants.range_none) self.heads[len] = self.count else self.ranges[self.tails[len]].next = self.count;
        self.tails[len] = self.count;
        self.count +%= 1;
    }
};

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
        /// Its lengths come as an array, so the buffer of their canonical order takes as many
        /// entries as there are symbols: a safe build fills a buffer it declares with 0xAA.
        pub fn build(self: *Self, lengths: anytype) usize {
            const counts = counts_of(lengths);
            var buffer: [lengths.len]Coded = undefined;
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
            return fill.fill_canonical(root_bits, value_of, &self.entries, sorted, counts);
        }

        /// The code of a simple code of two to four symbols (RFC 7932 §3.4), `symbols` in the order
        /// the stream gave them. Returns the entries written: the root.
        pub fn build_simple(self: *Self, symbols: []const u16, tree_select: bool) usize {
            return self.build_simple_valued(symbols, tree_select, symbol_itself);
        }

        /// As `build_simple`, each symbol entry holding `value_of(symbol)`.
        pub fn build_simple_valued(self: *Self, symbols: []const u16, tree_select: bool, comptime value_of: fn (u16) u16) usize {
            return fill.fill_simple(root_bits, value_of, &self.entries, symbols, tree_select);
        }

        /// As `build_sorted`, from the runs of equal lengths the reading appended (`Ranges`).
        pub fn build_ranged(self: *Self, ranges: *const Ranges, counts: *const Counts) usize {
            return self.build_ranged_valued(ranges, counts, symbol_itself);
        }

        /// As `build_ranged`, each symbol entry holding `value_of(symbol)`.
        pub fn build_ranged_valued(self: *Self, ranges: *const Ranges, counts: *const Counts, comptime value_of: fn (u16) u16) usize {
            return fill.fill_ranged(root_bits, value_of, &self.entries, ranges, counts);
        }

        /// The canonical code of `lengths` (RFC 7932 §3.2), every length at most `root_bits`, which
        /// the root holds whole: each code is written once at every root entry whose low bits are
        /// its bits as the stream holds them, so no entry is copied and no second level is linked.
        /// `counts` counts the lengths, as the reading counted them. The caller has checked that
        /// they form a complete code. Returns the entries written: the whole root.
        pub fn build_within_root(self: *Self, lengths: []const u8, counts: *const Counts) usize {
            // RFC 7932 §3.2: a length's codes are consecutive in symbol order, and its first code is
            // the code after the shorter lengths' last, doubled.
            var next_code: [root_bits + 1]u32 = undefined;
            var code: u32 = 0;
            for (1..root_bits + 1) |len| {
                next_code[len] = code;
                code = (code + counts[len]) << 1;
            }
            // A complete code takes every value of its longest length, so the doubling ends here.
            assert(code == @as(u32, 1) << (root_bits + 1));
            const root: *[1 << root_bits]Entry = self.entries[0 .. 1 << root_bits];
            for (lengths, 0..) |len, symbol| {
                if (len == 0) continue;
                fill.write_within_root(root_bits, root, reversed(next_code[len], len), len, fill.symbol_entry(@intCast(symbol), len));
                next_code[len] += 1;
            }
            return 1 << root_bits;
        }

        /// The symbol whose code starts `bits`, least significant bit first, of which `available`
        /// are present.
        pub fn decode(self: *const Self, bits: u64, available: u7) Decoded {
            const whole = look_up(root_bits, true, &self.entries, bits);
            if (whole.len > available) return .needs_bits;
            return .{ .symbol = .{ .value = whole.value, .len = @intCast(whole.len) } };
        }

        /// The symbol whose code starts `bits`, which hold a longest code's bits at least: the fast
        /// path's lookup, whose margin keeps the buffer that full (decision 16).
        pub inline fn decode_whole(self: *const Self, comptime checks: bool, bits: u64) WholeSymbol {
            return look_up(root_bits, checks, &self.entries, bits);
        }

        /// As `decode_whole`, from the root alone: for a table that `build_within_root` or
        /// `build_single` wrote, whose codes all fit the root, so no entry links a second level.
        pub inline fn decode_root(self: *const Self, bits: u64) WholeSymbol {
            const entry = self.entries[@as(std.meta.Int(.unsigned, root_bits), @truncate(bits))];
            return .{ .value = entry.value, .len = entry.len };
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
    var end: u16 = 0;
    for (1..constants.code_len_max + 1) |len| {
        end += counts[len];
        assert(next[len] == end);
    }
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

/// The symbol of the code `bits` start with, and its length: a root entry's, or the entry of its
/// second level that the bits after the root's pick. Bits past the stream's end read as zeros, so a
/// symbol longer than the bits present is one the caller asks more bits for. The build writes no
/// second level wider than `code_len_max`, so its width truncates to a shift's type unchecked.
inline fn look_up(comptime root_bits: u5, comptime checks: bool, entries: anytype, bits: u64) WholeSymbol {
    @setRuntimeSafety(checks);
    const root = entries[@intCast(bits & ((1 << root_bits) - 1))];
    if (root.second_bits == 0) return .{ .value = root.value, .len = root.len };
    const second_index = (bits >> root_bits) & ((@as(u64, 1) << @as(u6, @truncate(root.second_bits))) - 1);
    const entry = entries[root.value + @as(usize, @intCast(second_index))];
    return .{ .value = entry.value, .len = root_bits + entry.len };
}

/// The low `len` bits of `code` in reverse order: a code as the stream holds it. Every caller's code
/// is a root's, or a second level's past the root, 8 bits at most. aarch64 reverses bits with one
/// instruction, RBIT; x86-64 has none, and takes 15, so there the code takes its octet's entry in
/// `reversed_octets`.
pub fn reversed(code: u32, len: u8) u32 {
    if (len == 0) return 0;
    if (comptime builtin.cpu.arch.isAARCH64()) return @bitReverse(code) >> @intCast(@bitSizeOf(u32) - @as(u32, len));
    assert(len <= @bitSizeOf(u8));
    return reversed_octets[@as(u8, @truncate(code))] >> @intCast(@bitSizeOf(u8) - len);
}

/// Each octet with its bits in reverse order, for a CPU without RBIT.
pub const reversed_octets: [1 << @bitSizeOf(u8)]u8 = table: {
    var table: [1 << @bitSizeOf(u8)]u8 = undefined;
    for (&table, 0..) |*out, octet| out.* = @bitReverse(@as(u8, octet));
    break :table table;
};

comptime {
    // A root and the part of a code past it each fit an octet, which `reversed_octets` reverses.
    assert(constants.table_root_bits <= @bitSizeOf(u8) and constants.code_len_max - constants.table_root_bits <= @bitSizeOf(u8));
}

/// A code length of the code length code, and the bits its fixed code takes (RFC 7932 §3.5).
pub const CodeLengthCodeLength = struct { value: u8, len: u7 };

/// The fixed code of RFC 7932 §3.5 as a table of its longest code's bits, least significant first:
/// each entry the code length whose code those bits start with, and its code's length. The code is
/// complete, so every 4 bits start exactly one of its codes.
const code_length_code_length_table = table: {
    var entries: [1 << constants.code_length_code_length_bits_max]CodeLengthCodeLength = undefined;
    for (&entries, 0..) |*entry, bits| {
        var matches = 0;
        for (constants.code_length_code_length_codes, 0..) |code, value| {
            if (bits & ((1 << code.len) - 1) != code.code) continue;
            entry.* = .{ .value = value, .len = code.len };
            matches += 1;
        }
        assert(matches == 1);
    }
    break :table entries;
};

/// The code length the fixed code of RFC 7932 §3.5 gives the bits, least significant first, or null
/// when fewer than its code's bits are present. The bits past those present are zeros, so the code
/// the table names for them matches the stream whenever its bits are all present.
pub fn decode_code_length_code_length(bits: u64, available: u7) ?CodeLengthCodeLength {
    const entry = code_length_code_length_table[@as(u4, @truncate(bits))];
    if (entry.len > available) return null;
    return entry;
}

/// The code length the fixed code of RFC 7932 §3.5 gives the bits, least significant first, of which
/// its longest code's are present: the fast path's lookup, whose margin keeps them present.
pub inline fn decode_code_length_code_length_whole(bits: u64) CodeLengthCodeLength {
    return code_length_code_length_table[@as(u4, @truncate(bits))];
}

test {
    _ = @import("prefix_test.zig");
}
