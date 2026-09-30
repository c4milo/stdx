//! The fills of prefix.zig's tables: a canonical code (RFC 7932 §3.2) written into a table's root
//! and second levels, from its symbols in canonical order or from the runs of equal lengths the
//! reading appended.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const prefix = @import("prefix.zig");
const Entry = prefix.Entry;
const Coded = prefix.Coded;
const Counts = prefix.Counts;
const Ranges = prefix.Ranges;
const reversed = prefix.reversed;
const reversed_octets = prefix.reversed_octets;

/// Writes the table of the canonical code whose symbols `sorted` holds in canonical order, and
/// returns the entries it takes: the root, and behind it a second level for each root entry whose
/// codes are longer. The codes take consecutive values in that order (RFC 7932 §3.2), so the
/// codes of one root entry come together, the longest last.
///
/// A code of `len` bits up to the root's names every root entry whose low `len` bits are its bits
/// as the stream holds them. The build writes it once among the first 1 << `len` entries, having
/// copied the entries written before it to fill them (`double_root`), so each copy repeats every
/// shorter code; the root is whole once it is copied to its full width. Before the first code no
/// entry is written, so the first width needs no copy.
pub fn fill_canonical(comptime root_bits: u5, comptime value_of: fn (u16) u16, entries: []Entry, sorted: []const Coded, counts: *const Counts) usize {
    var fill = Fill.start(root_bits, sorted[0].len, sorted[sorted.len - 1].len, counts);
    for (sorted) |coded| fill_symbol(root_bits, value_of, entries, &fill, coded.symbol, coded.len);
    return fill_end(root_bits, entries, &fill);
}

/// Writes the table of the canonical code whose symbols `ranges` holds as runs per length, as
/// `fill_canonical` writes it from the sorted symbols: each length's runs in symbol order, the
/// lengths in order. The codes up to the root's length take one loop per length, the root doubled
/// once before it and each code one store (`fill_root_runs`); the longer ones take `fill_symbol`.
pub fn fill_ranged(comptime root_bits: u5, comptime value_of: fn (u16) u16, entries: []Entry, ranges: *const Ranges, counts: *const Counts) usize {
    const len_max = longest_len(counts);
    var fill = Fill.start(root_bits, shortest_len(counts), len_max, counts);
    for (1..@min(len_max, root_bits) + 1) |len| {
        if (counts[len] == 0) continue;
        fill.filled = double_root(root_bits, entries, fill.filled, @intCast(len));
        fill.code <<= @intCast(len - fill.code_len);
        fill.code_len = @intCast(len);
        fill.code = fill_root_runs(root_bits, value_of, entries, ranges, @intCast(len), fill.code);
    }
    for (root_bits + 1..constants.code_len_max + 1) |len| {
        if (len > len_max) break;
        var next = ranges.heads[len];
        // Each run holds a symbol at least, so a length's runs end within the alphabet.
        for (0..constants.code_ranges_max) |_| {
            if (next == constants.range_none) break;
            const range = ranges.ranges[next];
            for (range.first..range.first + range.count) |symbol| fill_symbol(root_bits, value_of, entries, &fill, @intCast(symbol), @intCast(len));
            next = range.next;
        }
    }
    return fill_end(root_bits, entries, &fill);
}

/// Writes the codes of `len` bits, at most the root's, of each run of that length in order, the
/// first taking `code`, once each among the root's first 1 << `len` entries, which the caller has
/// doubled to that width; returns the code after the last.
inline fn fill_root_runs(comptime root_bits: u5, comptime value_of: fn (u16) u16, entries: []Entry, ranges: *const Ranges, len: u8, first_code: u32) u32 {
    assert(len >= 1 and len <= root_bits);
    const Index = std.meta.Int(.unsigned, root_bits);
    const root: *[1 << root_bits]Entry = entries[0 .. 1 << root_bits];
    const shift: u5 = @intCast(@bitSizeOf(u32) - @as(u32, len));
    // aarch64 reverses a code's bits with one instruction, RBIT; x86-64 has none, and takes 15.
    const by_table = comptime !builtin.cpu.arch.isAARCH64() and root_bits <= @bitSizeOf(u8);
    var code = first_code;
    var next = ranges.heads[len];
    // Each run holds a symbol at least, so a length's runs end within the alphabet.
    for (0..constants.code_ranges_max) |_| {
        if (next == constants.range_none) break;
        const range = ranges.ranges[next];
        // A complete code gives a length no more codes than its width holds, so each code's
        // reversed bits index the root's first 1 << `len` entries, and the run's symbols and codes
        // stay below 1 << 16 without a check per symbol.
        assert(code + range.count <= @as(u32, 1) << @intCast(len));
        assert(@as(u32, range.first) + range.count <= constants.insert_copy_alphabet_len);
        var symbol = range.first;
        for (0..range.count) |_| {
            const index: Index = if (by_table) @intCast(reversed_root(code, len)) else @truncate(@bitReverse(code) >> shift);
            root[index] = symbol_entry(value_of(symbol), len);
            code +%= 1;
            symbol +%= 1;
        }
        next = range.next;
    }
    return code;
}

/// The root entry a code of `len` bits, at most 8, names first: its bits reversed, as the stream
/// holds them, from its octet's entry in `reversed_octets`, which the octet indexes unchecked. The
/// caller holds `code` below 1 << `len`, once for each run.
inline fn reversed_root(code: u32, len: u8) u8 {
    return reversed_octets[@as(u8, @truncate(code))] >> @intCast(@bitSizeOf(u8) - len);
}

/// The entry of a symbol's code of `len` bits, which links no second level, as one value, so that
/// it takes one store.
inline fn symbol_entry(value: u16, len: u8) Entry {
    const word: u32 = @bitCast(Entry{ .value = value, .len = len, .second_bits = 0 });
    return @bitCast(word);
}

/// The shortest length with a code among `counts`: the reader gives a complete code of two symbols
/// or more, so one exists.
fn shortest_len(counts: *const Counts) u8 {
    for (1..constants.code_len_max + 1) |len| {
        if (counts[len] > 0) return @intCast(len);
    }
    unreachable;
}

/// The longest length with a code among `counts`.
fn longest_len(counts: *const Counts) u8 {
    var len: usize = constants.code_len_max;
    for (0..constants.code_len_max) |_| {
        if (counts[len] > 0) return @intCast(len);
        len -= 1;
    }
    unreachable;
}

/// A canonical fill in progress: the next code and its length, the entries the table takes so far,
/// how many root entries are written, the root entry that last linked a second level, and the codes
/// of each length still to come.
const Fill = struct {
    code: u32 = 0,
    code_len: u8 = 0,
    table_len: usize,
    filled: usize,
    linked_root: u32,
    remaining: Counts,
    len_max: u8,

    /// A fill before its first code, of `first_len` bits; `len_max` is the longest code's length.
    fn start(comptime root_bits: u5, first_len: u8, len_max: u8, counts: *const Counts) Fill {
        return .{
            .table_len = 1 << root_bits,
            .filled = @as(usize, 1) << @intCast(@min(first_len, root_bits)),
            // No root entry has this index, so the first longer code links a second level.
            .linked_root = 1 << root_bits,
            .remaining = counts.*,
            .len_max = len_max,
        };
    }
};

/// Writes the entries of the next code, `len` bits long, for `symbol`: what the fills do per symbol.
inline fn fill_symbol(comptime root_bits: u5, comptime value_of: fn (u16) u16, entries: []Entry, fill: *Fill, symbol: u16, len: u8) void {
    assert(len >= fill.code_len and len <= constants.code_len_max);
    fill.code <<= @intCast(len - fill.code_len);
    fill.code_len = len;
    const value = value_of(symbol);
    if (len <= root_bits) {
        fill.filled = double_root(root_bits, entries, fill.filled, len);
        entries[reversed(fill.code, len)] = .{ .value = value, .len = len, .second_bits = 0 };
    } else {
        fill.filled = double_root(root_bits, entries, fill.filled, root_bits);
        const root = reversed(fill.code >> @intCast(len - root_bits), root_bits);
        if (root != fill.linked_root) {
            const second_bits = second_level_bits(root_bits, len, fill.len_max, &fill.remaining);
            entries[root] = .{ .value = @intCast(fill.table_len), .len = root_bits, .second_bits = second_bits };
            fill.table_len += @as(usize, 1) << @intCast(second_bits);
            fill.linked_root = root;
        }
        fill_second(root_bits, entries, value, fill.code, len);
        // Only `second_level_bits` reads the codes still to come, and only past the root.
        fill.remaining[len] -= 1;
    }
    fill.code += 1;
}

/// Ends a fill: the root copied to its full width, and the code's completeness and the table's
/// budget asserted. Returns the entries the table takes.
fn fill_end(comptime root_bits: u5, entries: []Entry, fill: *const Fill) usize {
    assert(std.math.isPowerOfTwo(fill.filled));
    _ = double_root(root_bits, entries, fill.filled, root_bits);
    // The reader checked the sums of RFC 7932 §3.5: the codes take every value.
    assert(fill.code == @as(u32, 1) << @intCast(fill.code_len));
    // tools/brotli_table_budget.zig: no code of the alphabet takes more.
    assert(fill.table_len <= entries.len);
    return fill.table_len;
}

/// The bits of the second level of the root entry whose first code, `len` bits long, comes next:
/// as many as its longest code takes past the root. The codes still to come fill the root entry's
/// values in order, each value at one length becoming two at the next, so its longest code is at
/// the length where they run out.
inline fn second_level_bits(comptime root_bits: u5, len: u8, len_max: u8, remaining: *const Counts) u8 {
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

/// Copies the `filled` first entries of the root after themselves until they are 1 << `len`, and
/// returns how many there are: the codes among them, each shorter than `len` bits, then name every
/// entry their bits name. Inline, with `second_level_bits`, so that a fill's fields stay in
/// registers: a call that takes the fill's address puts them on the stack for every symbol.
inline fn double_root(comptime root_bits: u5, entries: []Entry, filled: usize, len: u8) usize {
    assert(len <= root_bits);
    var width = filled;
    for (0..root_bits) |_| {
        if (width >= @as(usize, 1) << @intCast(len)) break;
        copy_root(entries, width);
        width <<= 1;
    }
    return width;
}

/// The widths a doubling copies with fixed loads and stores: 1 to `root_copy_inline_max` entries.
const root_copy_inline_shifts = std.math.log2_int(usize, constants.root_copy_inline_max) + 1;

/// Copies the `width` first entries of the root after themselves: with loads and stores of a fixed
/// width up to `root_copy_inline_max` entries, and past it in blocks of that width, with no call.
inline fn copy_root(entries: []Entry, width: usize) void {
    assert(std.math.isPowerOfTwo(width));
    if (width > constants.root_copy_inline_max) {
        const block = constants.root_copy_inline_max;
        const source = entries[0..width];
        const target = entries[width..][0..width];
        for (0..width / block) |index| target[index * block ..][0..block].* = source[index * block ..][0..block].*;
        return;
    }
    inline for (0..root_copy_inline_shifts) |shift| {
        const fixed = @as(usize, 1) << shift;
        if (width == fixed) return @memcpy(entries[fixed..][0..fixed], entries[0..fixed]);
    }
    unreachable;
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
