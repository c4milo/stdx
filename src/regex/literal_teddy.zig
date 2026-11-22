//! Claim R5's search by Teddy (decision 86), from Hyperscan (Wang and others, NSDI 2019).
//!
//! Each literal of a set takes one bit of an octet. Two tables of `nibbles` entries for the
//! literals' first octet hold, for each value of a nibble, the bits of the literals whose first
//! octet has that nibble, and two more do the same for their last octet. The lookup of a text
//! octet's low nibble ANDed with the lookup of its high nibble gives the bits of the literals
//! whose octet it is. The AND of the first octet's bits and the last octet's, at the literals'
//! distance, gives the literals whose two octets stand at a place: the places that
//! `literal_set.zig`'s compares find. A step costs four lookups, whatever the literals' count,
//! where the compares cost two for each literal, so `find_by` takes Teddy for sets of
//! `teddy_count_min` literals or more.
//!
//! The lookups take NEON's TBL in the library's own build for aarch64. On x86-64 they take
//! AVX2's VPSHUFB at 32 lanes in one variant object, and SSSE3's PSHUFB at 16 in another
//! (variants.zig). The baseline of x86-64, SSE2, has no lookup, so its own build keeps the
//! compares.
const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const LiteralSet = @import("literal_set.zig").LiteralSet;

/// The octets of a block, whatever the width of a step, as `literal_set.zig`'s blocks.
const block_len = constants.literal_steps * constants.skip_lanes;

/// An extern struct, as `LiteralSet` is, which holds it.
pub const Tables = extern struct {
    /// The bits of the literals by the low nibble and by the high nibble of their first octet.
    first_low: [constants.nibbles]u8,
    first_high: [constants.nibbles]u8,
    /// The same for their last octet, the set's `len - 1`th.
    last_low: [constants.nibbles]u8,
    last_high: [constants.nibbles]u8,

    /// The tables of the set's `count` literals, each `len` octets long.
    pub fn of(set: *const LiteralSet) Tables {
        assert(set.count <= constants.literal_set_max);
        assert(set.len >= constants.literal_prefix_len_min);
        var tables: Tables = .{ .first_low = @splat(0), .first_high = @splat(0), .last_low = @splat(0), .last_high = @splat(0) };
        for (set.octets[0..set.count], 0..) |*octets, literal| {
            const bit = @as(u8, 1) << @intCast(literal);
            const first = octets[0];
            const last = octets[set.len - 1];
            tables.first_low[first & constants.nibble_mask] |= bit;
            tables.first_high[first >> constants.nibble_bits] |= bit;
            tables.last_low[last & constants.nibble_mask] |= bit;
            tables.last_high[last >> constants.nibble_bits] |= bit;
        }
        return tables;
    }
};

/// Whether a search of `width` octets a step can take Teddy on the build's target: TBL on
/// aarch64 at `skip_lanes`, VPSHUFB at `avx2_lanes` in the variant object built with AVX2, and
/// PSHUFB at `skip_lanes` in one built with SSSE3.
pub fn runs(comptime width: usize) bool {
    return switch (builtin.cpu.arch) {
        .aarch64 => width == constants.skip_lanes,
        .x86_64 => switch (width) {
            constants.avx2_lanes => x86_has(.avx2),
            constants.skip_lanes => x86_has(.ssse3),
            else => false,
        },
        else => false,
    };
}

fn x86_has(comptime feature: std.Target.x86.Feature) bool {
    return std.Target.x86.featureSetHas(builtin.cpu.features, feature);
}

/// The first place of a literal of the set that starts at or after `from` and before `end`,
/// where the haystack holds the set's `len` octets from each such place.
pub fn find(comptime width: usize, set: *const LiteralSet, haystack: []const u8, from: usize, end: usize) ?usize {
    comptime assert(runs(width));
    assert(end <= haystack.len - set.len + 1);
    const Search = Steps(width);
    const lookups: Search.Lookups = .of(&set.teddy);
    const last = set.len - 1;
    var index = from;
    // A block reads `block_len` octets from `index` and as many from `index + last`, whose last
    // is `end + block_len - 2 + last`, under the haystack's length.
    while (end - index >= block_len) : (index += block_len) {
        const firsts = haystack[index..][0..block_len];
        const lasts = haystack[index + last ..][0..block_len];
        var bits: [Search.steps]Search.Vector = undefined;
        if (!Search.any(firsts, lasts, &lookups, &bits)) continue;
        if (Search.first(set, haystack, index, &bits)) |place| return place;
    }
    for (index..end) |candidate| {
        if (set.stands_at(haystack, candidate)) return candidate;
    }
    return null;
}

/// The steps of a block for a vector of `width` octets.
fn Steps(comptime width: usize) type {
    comptime assert(block_len % width == 0 and width % constants.nibbles == 0);
    return struct {
        const Vector = @Vector(width, u8);
        const Mask = std.meta.Int(.unsigned, width);
        const steps = block_len / width;

        /// The tables as vectors, each 16 entries repeated for each 16 lanes, as VPSHUFB looks
        /// each 16 lanes up in their own entries.
        const Lookups = struct {
            first_low: Vector,
            first_high: Vector,
            last_low: Vector,
            last_high: Vector,

            fn of(tables: *const Tables) Lookups {
                return .{
                    .first_low = repeated(&tables.first_low),
                    .first_high = repeated(&tables.first_high),
                    .last_low = repeated(&tables.last_low),
                    .last_high = repeated(&tables.last_high),
                };
            }
        };

        fn repeated(entries: *const [constants.nibbles]u8) Vector {
            var lanes: [width]u8 = undefined;
            inline for (0..width / constants.nibbles) |part| lanes[part * constants.nibbles ..][0..constants.nibbles].* = entries.*;
            return lanes;
        }

        /// The bits of the literals whose octet `octets` holds in each lane, by two tables.
        inline fn bits_of(octets: Vector, low: Vector, high: Vector) Vector {
            const low_mask: Vector = @splat(constants.nibble_mask);
            const shift: @Vector(width, u3) = @splat(constants.nibble_bits);
            return lookup(width, low, octets & low_mask) & lookup(width, high, octets >> shift);
        }

        /// Writes each step's bits of the literals whose first octet stands at a place in
        /// `firsts` and whose last octet stands at the same place in `lasts`, and gives whether
        /// any place holds one.
        inline fn any(firsts: *const [block_len]u8, lasts: *const [block_len]u8, lookups: *const Lookups, bits: *[steps]Vector) bool {
            var all: Vector = @splat(0);
            inline for (0..steps) |step| {
                const first_octets: Vector = firsts[step * width ..][0..width].*;
                const last_octets: Vector = lasts[step * width ..][0..width].*;
                const first_bits = bits_of(first_octets, lookups.first_low, lookups.first_high);
                bits[step] = first_bits & bits_of(last_octets, lookups.last_low, lookups.last_high);
                all |= bits[step];
            }
            return @reduce(.Or, all) != 0;
        }

        /// The first place of the block from `index` where a literal whose bit `bits` holds
        /// stands whole.
        fn first(set: *const LiteralSet, haystack: []const u8, index: usize, bits: *const [steps]Vector) ?usize {
            const none: Vector = @splat(0);
            inline for (0..steps) |step| {
                const lanes: [width]u8 = bits[step];
                var places: Mask = @bitCast(bits[step] != none);
                // Each set bit is one place, at most `width` of them.
                while (places != 0) : (places &= places - 1) {
                    const lane = @ctz(places);
                    const place = index + step * width + lane;
                    if (set.stands_among(lanes[lane], haystack, place)) return place;
                }
            }
            return null;
        }
    };
}

/// Each lane of `indices`, a nibble, looked up in `table`: NEON's TBL at 16 lanes, AVX2's VPSHUFB
/// at 32, which looks each 16 lanes up in their own 16 entries, or SSSE3's PSHUFB at 16, which
/// writes its result over the table's register. Register operands only, as decision 16 admits.
inline fn lookup(comptime width: usize, table: @Vector(width, u8), indices: @Vector(width, u8)) @Vector(width, u8) {
    comptime assert(runs(width));
    return switch (builtin.cpu.arch) {
        .aarch64 => asm ("tbl %[result].16b, {%[table].16b}, %[indices].16b"
            : [result] "=w" (-> @Vector(width, u8)),
            : [table] "w" (table),
              [indices] "w" (indices),
        ),
        .x86_64 => if (comptime x86_has(.avx)) asm ("vpshufb %[indices], %[table], %[result]"
            : [result] "=x" (-> @Vector(width, u8)),
            : [table] "x" (table),
              [indices] "x" (indices),
        ) else asm ("pshufb %[indices], %[result]"
            : [result] "=x" (-> @Vector(width, u8)),
            : [table] "0" (table),
              [indices] "x" (indices),
        ),
        else => unreachable,
    };
}

const testing = std.testing;

test "of gives each literal its bit in the tables of its first and its last octet, and no others" {
    var set: LiteralSet = .{ .octets = undefined, .count = 2, .len = 4 };
    // `a` and `A` share their low nibble, 1, and differ in their high one, 6 and 4.
    set.octets[0][0..4].* = "abcd".*;
    set.octets[1][0..4].* = "Abce".*;
    const tables: Tables = .of(&set);
    try testing.expectEqual(@as(u8, 0b11), tables.first_low['a' & constants.nibble_mask]);
    try testing.expectEqual(@as(u8, 0b01), tables.first_high['a' >> constants.nibble_bits]);
    try testing.expectEqual(@as(u8, 0b10), tables.first_high['A' >> constants.nibble_bits]);
    try testing.expectEqual(@as(u8, 0b01), tables.last_low['d' & constants.nibble_mask]);
    try testing.expectEqual(@as(u8, 0b10), tables.last_low['e' & constants.nibble_mask]);
    try testing.expectEqual(@as(u8, 0b11), tables.last_high['d' >> constants.nibble_bits]);
    // The middle octets, `b` and `c`, take no table: the whole compare judges them.
    try testing.expectEqual(@as(u8, 0), tables.first_low['b' & constants.nibble_mask]);
    try testing.expectEqual(@as(u8, 0), tables.last_low['c' & constants.nibble_mask]);
}
