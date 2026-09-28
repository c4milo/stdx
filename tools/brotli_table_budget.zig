//! brotli_table_budget: the most entries a two-level lookup table of one prefix code can take, for
//! each alphabet of RFC 7932 §3.3 (decision 12, claim B3).
//!
//! The table: a root of 1 << `root_bits` entries, indexed by a code's first `root_bits` bits, and for
//! each root entry whose codes are longer, a second-level table of 1 << (longest - `root_bits`)
//! entries, where longest is the longest code that starts with the entry's bits. How big the second
//! levels get depends on the code, so decision 12 sizes each table for the worst code of its
//! alphabet.
//!
//! A canonical code (RFC 7932 §3.2) gives shorter codes lower values, so a code's lengths never fall
//! from one value to the next, and the codes of one root entry end with its longest. Reading the
//! lengths from 1 up, the values not yet taken at length l are the last `free` of that length. Those
//! of the first root entry not yet closed are `free` modulo the values a root entry spans at length
//! l, and each entry after it spans that many. Giving length l `count` codes takes the first `count`
//! values, closes every root entry they reach the end of, and leaves the rest to split at length
//! l + 1, where each value not taken becomes two. A root entry that closes at length l has longest
//! code l, so a second level of 1 << (l - `root_bits`) entries. The worst code is the choice of
//! counts, one per length, that closes the most second-level entries and still leaves every value
//! taken at the longest length, with no more codes than the alphabet has symbols.
//!
//! Usage: `brotli_table_budget [--check]`. It prints each alphabet's worst table for root widths 6
//! to 11; with `--check`, it computes them for brotli's `table_root_bits` and exits 1 when one
//! differs from the budget constants.zig pins.

const std = @import("std");
const brotli = @import("brotli");

const constants = brotli.constants;

/// The longest code of RFC 7932 §3.5.
pub const code_len_max = constants.code_len_max;

/// Each alphabet of RFC 7932 §3.3 at its largest, and the budget constants.zig pins for its table:
/// literals, insert-and-copy lengths, distances with NPOSTFIX 3 and NDIRECT 120, block types of 256
/// block types, block counts, and a context map of 256 trees and RLEMAX 16.
pub const alphabets = [_]struct { name: []const u8, len: u16, pinned: u32 }{
    .{ .name = "literal", .len = constants.literal_alphabet_len, .pinned = constants.literal_table_len_max },
    .{ .name = "insert-and-copy", .len = constants.insert_copy_alphabet_len, .pinned = constants.insert_copy_table_len_max },
    .{ .name = "distance", .len = constants.distance_alphabet_len_max, .pinned = constants.distance_table_len_max },
    .{ .name = "block type", .len = constants.block_type_alphabet_len_max, .pinned = constants.block_type_table_len_max },
    .{ .name = "block count", .len = constants.block_count_alphabet_len, .pinned = constants.block_count_table_len_max },
    .{ .name = "context map", .len = constants.context_map_alphabet_len_max, .pinned = constants.context_map_table_len_max },
};

/// The search over counts: `values[l][s][f]`, the most second-level entries lengths l and up can close
/// with `s` codes left to place and `f` values free at length l, or `infeasible`.
const Search = struct {
    root_bits: u5,
    len_max: u5,
    symbols_max: u16,
    values: []i32,

    const unknown: i32 = -1;
    const infeasible: i32 = -2;

    fn index(search: *const Search, len: u5, symbols: u32, free: u32) usize {
        const width = @as(usize, search.symbols_max) + 1;
        return (@as(usize, len) * width + symbols) * width + free;
    }

    /// The second-level entries closed by `count` codes of length `len` among `free` free values.
    fn closed(search: *const Search, len: u5, free: u32, count: u32) u32 {
        if (len <= search.root_bits or count == 0) return 0;
        const span = @as(u32, 1) << (len - search.root_bits);
        const first = if (free % span == 0) span else free % span;
        if (count < first) return 0;
        return (1 + (count - first) / span) * span;
    }

    fn best(search: *Search, len: u5, symbols: u32, free: u32) i32 {
        if (free == 0) return if (symbols == 0) 0 else infeasible;
        if (len > search.len_max) return infeasible;
        // Every free value needs a code, and one value at length l takes at most 1 << (max - l).
        if (symbols < free or symbols > @as(u64, free) << (search.len_max - len)) return infeasible;
        const at = search.index(len, symbols, free);
        if (search.values[at] != unknown) return search.values[at];
        var result: i32 = infeasible;
        const count_min = if (2 * free > symbols) 2 * free - symbols else 0;
        var count = count_min;
        while (count <= @min(free, symbols)) : (count += 1) {
            const rest = search.best(len + 1, symbols - count, 2 * (free - count));
            if (rest == infeasible) continue;
            result = @max(result, rest + @as(i32, @intCast(search.closed(len, free, count))));
        }
        search.values[at] = result;
        return result;
    }
};

/// The most entries a two-level table takes over any complete canonical code of 2 to
/// `alphabet_len` symbols with lengths up to `len_max`: the root and the worst second levels.
pub fn table_len_max(allocator: std.mem.Allocator, alphabet_len: u16, root_bits: u5, len_max: u5) !u32 {
    std.debug.assert(alphabet_len >= 2);
    const width = @as(usize, alphabet_len) + 1;
    const values = try allocator.alloc(i32, (@as(usize, len_max) + 2) * width * width);
    defer allocator.free(values);
    @memset(values, Search.unknown);
    var search: Search = .{ .root_bits = root_bits, .len_max = len_max, .symbols_max = alphabet_len, .values = values };
    var worst: i32 = 0;
    for (2..@as(usize, alphabet_len) + 1) |symbols| worst = @max(worst, search.best(1, @intCast(symbols), 2));
    return (@as(u32, 1) << root_bits) + @as(u32, @intCast(worst));
}

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    if (args.len == 2 and std.mem.eql(u8, args[1], "--check")) return check(gpa);
    std.debug.print("{s:>16}", .{"root bits"});
    for (6..12) |root_bits| std.debug.print("{d:>8}", .{root_bits});
    std.debug.print("\n", .{});
    for (alphabets) |alphabet| {
        std.debug.print("{s:>16}", .{alphabet.name});
        for (6..12) |root_bits| std.debug.print("{d:>8}", .{try table_len_max(gpa, alphabet.len, @intCast(root_bits), code_len_max)});
        std.debug.print("\n", .{});
    }
}

/// Exits 1 when a pinned budget is not the worst table the search finds.
fn check(gpa: std.mem.Allocator) !void {
    var differs = false;
    for (alphabets) |alphabet| {
        const worst = try table_len_max(gpa, alphabet.len, constants.table_root_bits, code_len_max);
        if (worst == alphabet.pinned) continue;
        std.debug.print("brotli_table_budget: the {s} table's worst is {d} entries, and constants.zig pins {d}\n", .{ alphabet.name, worst, alphabet.pinned });
        differs = true;
    }
    if (differs) std.process.exit(1);
}

// Tests.

const testing = std.testing;

/// The table a code of these counts per length takes, built value by value: every root entry and,
/// for each root entry with longer codes, 1 << (its longest - root) second-level entries.
fn table_len_of(counts: []const u32, root_bits: u5, len_max: u5) u32 {
    // The longest code that starts in each root entry, over the values of `len_max` bits in order.
    var longest: [1 << 8]u5 = @splat(0);
    var value: u32 = 0;
    for (counts, 1..) |count, len| {
        for (0..count) |_| {
            const root = value >> (len_max - root_bits);
            longest[root] = @max(longest[root], @as(u5, @intCast(len)));
            value += @as(u32, 1) << @intCast(len_max - len);
        }
    }
    var total: u32 = @as(u32, 1) << root_bits;
    for (longest[0 .. @as(usize, 1) << root_bits]) |len| {
        if (len > root_bits) total += @as(u32, 1) << (len - root_bits);
    }
    return total;
}

/// The worst table over every complete code of up to `symbols_max` symbols with lengths up to
/// `len_max`, by trying every count at every length.
fn brute_force(counts: []u32, len: u5, free: u32, symbols_left: u32, root_bits: u5, len_max: u5) u32 {
    if (free == 0) return table_len_of(counts[0 .. len - 1], root_bits, len_max);
    if (len > len_max) return 0;
    var worst: u32 = 0;
    for (0..@min(free, symbols_left) + 1) |count| {
        counts[len - 1] = @intCast(count);
        worst = @max(worst, brute_force(counts, len + 1, 2 * (free - @as(u32, @intCast(count))), symbols_left - @as(u32, @intCast(count)), root_bits, len_max));
    }
    counts[len - 1] = 0;
    return worst;
}

test "the search finds the worst table that trying every code finds" {
    for ([_]struct { symbols: u16, root_bits: u5, len_max: u5 }{
        .{ .symbols = 6, .root_bits = 2, .len_max = 5 },
        .{ .symbols = 9, .root_bits = 3, .len_max = 6 },
        .{ .symbols = 12, .root_bits = 3, .len_max = 7 },
        .{ .symbols = 14, .root_bits = 4, .len_max = 8 },
    }) |case| {
        var counts: [16]u32 = @splat(0);
        const expected = brute_force(&counts, 1, 2, case.symbols, case.root_bits, case.len_max);
        try testing.expectEqual(expected, try table_len_max(testing.allocator, case.symbols, case.root_bits, case.len_max));
    }
}

test "a table whose root spans every code has no second level" {
    try testing.expectEqual(1 << 8, try table_len_max(testing.allocator, 18, 8, 5));
}
