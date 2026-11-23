//! Claim R5 (decision 86): the literals one of which every match starts with, as in
//! `Abraham|Isaac|Jacob|Joseph`, and the search for the next place of one.
//!
//! `LiteralSet.of` reads the literals from the paths of the forward program
//! (literal_set_paths.zig). Every match starts with one of them, and no match starts where none
//! stands. The set keeps each literal's first `len` octets, the length of the shortest, so that
//! every literal's octets at two offsets, `first_at` and `last_at`, stand at one distance.
//! `prepare` chooses the offsets and Teddy's buckets (literal_set_fingerprint.zig). Where the
//! target has NEON's TBL, or AVX2's VPSHUFB in the variant object, `find` takes Teddy
//! (literal_teddy.zig), whose step costs the same for two literals as for eight. Elsewhere it
//! compares the text with each literal's two octets, `skip_lanes` octets a step, as claim R2 does
//! for one, which needs SSE2 alone. Either compares each literal whole where its two octets
//! stand.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const Program = program_file.Program;
const literal_file = @import("literal.zig");
const literal_teddy = @import("literal_teddy.zig");
const lane_places = @import("lane_places.zig");
const literal_compare = @import("literal_compare.zig");

/// The octets of a literal's head: one word.
pub const head_len = @sizeOf(u64);

/// The octets of a block, whatever the width of a step.
const block_len = constants.literal_steps * constants.skip_lanes;

extern fn stdx_regex_literal_set_find_x86_64_avx2(set: *const LiteralSet, haystack: [*]const u8, haystack_len: usize, from: usize) callconv(.c) usize;
extern fn stdx_regex_literal_set_find_x86_64_ssse3(set: *const LiteralSet, haystack: [*]const u8, haystack_len: usize, from: usize) callconv(.c) usize;

/// An extern struct, so that the variant object, built for other CPU features, reads the same
/// fields at the same offsets.
pub const LiteralSet = extern struct {
    /// Each literal's first `len` octets.
    octets: [constants.literal_set_max][constants.literal_len_max]u8,
    count: u8,
    len: u8,
    /// True when `find` searches `avx2_lanes` octets a step, in the variant object, as
    /// `Literal.wide` says.
    wide: bool = false,
    /// True when `find` takes Teddy in the variant object of SSSE3, at `skip_lanes` octets a
    /// step: the caller's `codec.Features` name SSSE3 and not AVX2.
    ssse3: bool = false,
    /// Teddy's tables of the literals, which `of` builds.
    teddy: literal_teddy.Tables = undefined,
    /// Each literal's length, at most `literal_len_max`.
    lens: [constants.literal_set_max]u8 = undefined,
    /// True when each literal is its whole branch: a match is then the first place where a
    /// literal stands whole, and there the first literal of the set that does (`find_exact`).
    exact: bool = false,
    /// The two offsets below `len` whose octets Teddy's tables and the compares take, the rarest
    /// by their kind (literal_set_fingerprint.zig).
    first_at: u8 = 0,
    last_at: u8 = 0,
    /// The literals by bucket: Teddy's bucket `b` holds `order[bucket_starts[b]..][0..n]`, with
    /// `n` the next start less its own.
    order: [constants.literal_set_max]u8 = undefined,
    bucket_starts: [constants.teddy_buckets + 1]u8 = undefined,
    /// The first `head_len` octets of each literal of `order`, or its `len` where fewer, as one
    /// little-endian word, so that a compare of a place costs one compare of words for each
    /// literal, and a bucket's words stand together.
    heads: [constants.literal_set_max]u64 = undefined,
    /// The bits of a word that the set's first `len` octets fill.
    head_mask: u64 = undefined,
    /// A table of the heads: each slot holds one more than the place in `heads` of a literal
    /// whose head hashes to it or to a slot before it, or zero. `prepare` fills it.
    slots: [constants.literal_set_slots]u8 = undefined,

    /// The literals one of which every match of `program` starts with (literal_set_paths.zig).
    pub const of = @import("literal_set_paths.zig").of;

    /// Writes the offsets, the buckets and Teddy's tables of the set's literals.
    pub const prepare = @import("literal_set_fingerprint.zig").prepare;

    /// The first offset at or after `from` where a literal of the set stands, or null.
    pub fn find(set: *const LiteralSet, haystack: []const u8, from: usize) ?usize {
        // A set calls the variant object from `from`. `Literal.find` searches one block inline
        // first, but a set's 16-lane compares cost more than the call: on a Xeon, sets whose
        // places stand close together ran 1.01 to 1.23 times as fast with no inline block.
        if (literal_file.has_kernels and set.wide) return set.find_far(haystack, from);
        // Below `teddy_count_min` literals the library's own compares are the faster way.
        if (literal_file.has_kernels and set.ssse3 and set.count >= constants.teddy_count_min) return set.find_ssse3(haystack, from);
        return set.find_by(constants.skip_lanes, haystack, from);
    }

    /// Where `exact` holds: the first place at or after `from` where a literal stands whole, and
    /// the end of the first literal of the set that stands there. The set keeps the alternation's
    /// order, the first branch first, so this is the match RE2's leftmost-first rule picks.
    pub fn find_exact(set: *const LiteralSet, haystack: []const u8, from: usize) ?Place {
        assert(set.exact);
        assert(from <= haystack.len);
        var at = from;
        // Each turn passes one place where the set's first `len` octets stand, so the turns are at
        // most the octets from `from`.
        while (at <= haystack.len) {
            const start = set.find(haystack, at) orelse return null;
            if (set.whole_at(haystack, start)) |len| return .{ .start = start, .end = start + len };
            at = start + 1;
        }
        return null;
    }

    /// The length of the first literal of the set that stands whole at `index`, or null.
    fn whole_at(set: *const LiteralSet, haystack: []const u8, index: usize) ?usize {
        for (set.octets[0..set.count], set.lens[0..set.count]) |*octets, len| {
            if (haystack.len - index >= len and literal_compare.equal(haystack[index..][0..len], octets[0..len])) return len;
        }
        return null;
    }

    /// Teddy in the variant object of SSSE3, from `from`, out of line as `find_far` is.
    noinline fn find_ssse3(set: *const LiteralSet, haystack: []const u8, from: usize) ?usize {
        if (haystack.len - from < set.len) return null;
        const found = stdx_regex_literal_set_find_x86_64_ssse3(set, haystack.ptr, haystack.len, from);
        return if (found == literal_file.no_place) null else found;
    }

    /// The variant object's search from `from`, out of line, as `Literal.find_far` is.
    noinline fn find_far(set: *const LiteralSet, haystack: []const u8, from: usize) ?usize {
        if (haystack.len - from < set.len) return null;
        const found = stdx_regex_literal_set_find_x86_64_avx2(set, haystack.ptr, haystack.len, from);
        return if (found == literal_file.no_place) null else found;
    }

    /// `find`, `width` octets a step: `skip_lanes`, or `avx2_lanes` in the variant object.
    pub fn find_by(set: *const LiteralSet, comptime width: usize, haystack: []const u8, from: usize) ?usize {
        assert(from <= haystack.len);
        assert(set.count >= constants.literal_set_count_min and set.count <= constants.literal_set_max);
        if (haystack.len - from < set.len) return null;
        // A place of a literal starts before `end`.
        const end = haystack.len - set.len + 1;
        assert(end > from);
        if (comptime literal_teddy.runs(width)) {
            if (set.count >= constants.teddy_count_min) {
                if (end - from < block_len) return literal_teddy.find_short(width, set, haystack, from, end);
                return literal_teddy.find(width, set, haystack, from, end);
            }
        }
        // Past `literal_compare_max` literals the compares cost more than one offset at a time.
        if (set.count > constants.literal_compare_max) return set.find_scalar(haystack, from, end);
        return switch (set.count) {
            inline constants.literal_set_count_min...constants.literal_compare_max => |count| set.find_of(width, count, haystack, from, end),
            else => unreachable,
        };
    }

    /// The first place of a literal of the set that starts at or after `from` and before `end`,
    /// where the haystack holds the set's `len` octets from each such place.
    fn find_of(set: *const LiteralSet, comptime width: usize, comptime count: usize, haystack: []const u8, from: usize, end: usize) ?usize {
        const first = set.first_at;
        const last = set.last_at;
        const Search = Lanes(width, count);
        var wanted: Search.Wanted = undefined;
        inline for (0..count) |literal| {
            wanted.firsts[literal] = @splat(set.octets[literal][first]);
            wanted.lasts[literal] = @splat(set.octets[literal][last]);
        }
        var index = from;
        // A block reads `block_len` octets from `index + first` and as many from `index + last`,
        // whose last is `end + block_len - 2 + last`, under the haystack's length.
        while (end - index >= block_len) : (index += block_len) {
            const firsts = haystack[index + first ..][0..block_len];
            const lasts = haystack[index + last ..][0..block_len];
            if (Search.any_candidate(firsts, lasts, &wanted)) {
                // As in claim R2's loop (literal_find.zig): the wanted octets stay in registers.
                @branchHint(.unlikely);
                if (Search.first_stands(set, firsts, lasts, &wanted, haystack, index)) |place| return place;
            }
        }
        return set.find_scalar(haystack, index, end);
    }

    /// The first place at or after `from` and before `end` where a literal of the set stands,
    /// one offset at a time. Teddy's tables give, in four lookups, the buckets whose literals'
    /// two octets may stand there, so an offset where none does costs no compare. A target with
    /// Teddy searches a text shorter than a block by one block of copies instead
    /// (`literal_teddy.find_short`).
    pub fn find_scalar(set: *const LiteralSet, haystack: []const u8, from: usize, end: usize) ?usize {
        assert(end <= haystack.len - set.len + 1);
        for (from..end) |candidate| {
            const bits = set.teddy.bits_at(haystack[candidate + set.first_at], haystack[candidate + set.last_at]);
            if (bits != 0 and set.stands_among(bits, haystack, candidate)) return candidate;
        }
        return null;
    }

    /// True when a literal of the set stands whole at `index`, where Teddy's tables give the
    /// buckets of `bits`: the literal's bucket is one of them.
    pub fn stands_among(set: *const LiteralSet, bits: u8, haystack: []const u8, index: usize) bool {
        const place = set.place_at(haystack, index) orelse return false;
        assert(bits >> set.bucket_of(place) & 1 != 0);
        return true;
    }

    /// True when a literal of the set stands whole at `index`.
    pub fn stands_at(set: *const LiteralSet, haystack: []const u8, index: usize) bool {
        return set.place_at(haystack, index) != null;
    }

    /// The place in `heads` of a literal that stands whole at `index`, or null. The text's head
    /// finds the slots of the literals that share its hash, about one, and each that shares the
    /// head compares its tail.
    inline fn place_at(set: *const LiteralSet, haystack: []const u8, index: usize) ?usize {
        const head = set.head_at(haystack, index);
        var slot = slot_of(head);
        // The table is at most half full, so a probe meets an empty slot within `count` turns.
        for (0..constants.literal_set_slots) |_| {
            const entry = set.slots[slot];
            if (entry == 0) return null;
            const place = entry - 1;
            if (set.heads[place] == head and set.tail_at(set.order[place], haystack, index)) return place;
            slot = (slot + 1) & (constants.literal_set_slots - 1);
        }
        return null;
    }

    /// The bucket that holds the literal at `place` of `order`.
    fn bucket_of(set: *const LiteralSet, place: usize) u3 {
        assert(place < set.count);
        for (0..constants.teddy_buckets) |bucket| {
            if (place < set.bucket_starts[bucket + 1]) return @intCast(bucket);
        }
        unreachable;
    }

    /// The text's first `head_len` octets from `index`, or its `len` where fewer, in the order
    /// of `heads`. The haystack holds the set's `len` octets from `index`.
    inline fn head_at(set: *const LiteralSet, haystack: []const u8, index: usize) u64 {
        if (haystack.len - index >= head_len) return std.mem.readInt(u64, haystack[index..][0..head_len], .little) & set.head_mask;
        var head: u64 = 0;
        for (haystack[index..][0..set.len], 0..) |octet, place| head |= @as(u64, octet) << @intCast(place * @bitSizeOf(u8));
        return head;
    }

    /// True when the octets of `literal` past its head stand at `index` past the text's head.
    inline fn tail_at(set: *const LiteralSet, literal: usize, haystack: []const u8, index: usize) bool {
        if (set.len <= head_len) return true;
        return literal_compare.equal(haystack[index + head_len ..][0 .. set.len - head_len], set.octets[literal][head_len..set.len]);
    }
};

/// Knuth's multiplier for a hash of a word: 2^64 divided by the golden ratio, odd.
const head_hash = 0x9E37_79B9_7F4A_7C15;

/// The shift that keeps the top bits of a product, as many as name a slot.
const head_shift: u6 = @bitSizeOf(u64) - std.math.log2(constants.literal_set_slots);

/// The slot a head hashes to: the top bits of its product with `head_hash`.
pub fn slot_of(head: u64) usize {
    return @intCast((head *% head_hash) >> head_shift);
}

/// A match of an exact set: the octets from `start` to `end`.
pub const Place = struct { start: usize, end: usize };

/// The search's steps for a vector of `width` octets and a set of `count` literals.
fn Lanes(comptime width: usize, comptime count: usize) type {
    comptime assert(block_len % width == 0);
    return struct {
        const Vector = @Vector(width, u8);
        const Step = lane_places.Places(width);
        const steps = block_len / width;

        /// Each literal's octets at `first_at` and `last_at`, in every lane.
        const Wanted = struct { firsts: [count]Vector, lasts: [count]Vector };

        /// All ones in each lane of the step at `at` where some literal's octet at `first_at`
        /// stands in `firsts` and its octet at `last_at` at the same place in `lasts`.
        inline fn both_lanes(firsts: *const [block_len]u8, lasts: *const [block_len]u8, comptime at: usize, wanted: *const Wanted) Vector {
            const all: Vector = @splat(constants.octet_max);
            const none: Vector = @splat(0);
            const first: Vector = firsts[at..][0..width].*;
            const last: Vector = lasts[at..][0..width].*;
            var both = none;
            inline for (0..count) |literal| {
                const first_here = @select(u8, first == wanted.firsts[literal], all, none);
                const last_here = @select(u8, last == wanted.lasts[literal], all, none);
                both |= first_here & last_here;
            }
            return both;
        }

        /// True when some place of a block holds some literal's octet at `first_at` in `firsts`
        /// and its octet at `last_at` at the same place in `lasts`.
        inline fn any_candidate(firsts: *const [block_len]u8, lasts: *const [block_len]u8, wanted: *const Wanted) bool {
            var any: Vector = @splat(0);
            inline for (0..steps) |step| any |= both_lanes(firsts, lasts, step * width, wanted);
            return Step.any(any);
        }

        /// The first place of the block from `index` where a literal of the set stands whole,
        /// among those where some literal's two octets stand, a step's places a word each.
        inline fn first_stands(set: *const LiteralSet, firsts: *const [block_len]u8, lasts: *const [block_len]u8, wanted: *const Wanted, haystack: []const u8, index: usize) ?usize {
            var masks: [steps]Step.Mask = undefined;
            inline for (&masks, 0..) |*mask, step| mask.* = Step.of(both_lanes(firsts, lasts, step * width, wanted));
            for (masks, 0..) |step_mask, step| {
                var mask = step_mask;
                // Each set bit is one place to compare, at most `width` of them.
                while (mask != 0) : (mask &= mask - 1) {
                    const candidate = index + step * width + Step.first(mask);
                    if (set.stands_at(haystack, candidate)) return candidate;
                }
            }
            return null;
        }
    };
}

const testing = std.testing;
const compiler = @import("compile.zig");
const codec = @import("codec");
const Generator = codec.testing.split.Generator;

/// The instructions a test's pattern takes at most, its forward and its reverse program.
const test_storage_len = 1024;

fn set_of(pattern: []const u8) !?LiteralSet {
    var storage: [test_storage_len]program_file.Instruction = undefined;
    const program = try compiler.compile(pattern, .{}, &storage);
    return LiteralSet.of(&program);
}

test "of reads the literal each branch of an alternation starts with, cut to the shortest" {
    const set = (try set_of("Abraham|Isaac|Jacob|Joseph")) orelse return error.TestExpectedSet;
    try testing.expectEqual(@as(u8, 4), set.count);
    try testing.expectEqual(@as(u8, 5), set.len);
    var found: [4][]const u8 = undefined;
    for (&found, set.octets[0..set.count]) |*one, *octets| one.* = octets[0..set.len];
    for ([_][]const u8{ "Abrah", "Isaac", "Jacob", "Josep" }) |wanted| {
        var has = false;
        for (found) |one| has = has or std.mem.eql(u8, one, wanted);
        try testing.expect(has);
    }
    const counts = [_]struct { pattern: []const u8, count: u8, len: u8 }{
        .{ .pattern = "ab|cd", .count = 2, .len = 2 },
        // The loop forks each path into `ab`, `cd` and `x` at 2, 4 and 6 octets, and ends it at
        // `literal_fork_len_max`: 2 paths of 3 octets, 4 of 5, 8 of 7 and 16 of 8, 30 in all.
        .{ .pattern = "(?:ab|cd)+x", .count = 30, .len = 3 },
        // Each branch's literal goes on past the group: `abh`, `cdh` and `efgh`.
        .{ .pattern = "(ab|cd|efg)h", .count = 3, .len = 3 },
        .{ .pattern = "a1|b2|c3|d4|e5|f6|g7|h8", .count = 8, .len = 2 },
        .{ .pattern = "a1|b2|c3|d4|e5|f6|g7|h8|i9", .count = 9, .len = 2 },
        // Each letter's case forms fork the paths: two for each of `a` to `d`.
        .{ .pattern = "(?i)ab|cd", .count = 8, .len = 2 },
        // `s` has three case forms, the long s among them, whose UTF-8 is two octets. A sixth
        // octet would fork 40 paths into 80, past `literal_set_max`, so each keeps five: 32 of
        // `S` and `s` to `sherl`, and 8 of the long s to `sher`.
        .{ .pattern = "(?i)sherlock", .count = 40, .len = 5 },
        // The third letters would fork the 36 paths of two letters into 72, past
        // `literal_set_max`, so the paths keep two octets each.
        .{ .pattern = "(?i)abc|def|ghi|jlm|nop|qrt|uvw|xyz|bcd", .count = 36, .len = 2 },
    };
    for (counts) |case| {
        const one = (try set_of(case.pattern)) orelse return error.TestExpectedSet;
        try testing.expectEqual(case.count, one.count);
        try testing.expectEqual(case.len, one.len);
    }
}

test "of gives no set where a branch starts with no literal, or too short a one, or one alone" {
    const none = [_][]const u8{
        "ab|c", "a|b", "ab|cd|", "(?:ab|cd)*x", "ab|[cd]e", "\\bab|cd", "Pharaoh", "ab",
    };
    for (none) |pattern| {
        if (try set_of(pattern) != null) return error.TestUnexpectedSet;
    }
}

/// The first place at or after `from` where a literal of `set` stands, one offset at a time.
fn find_plain(set: *const LiteralSet, haystack: []const u8, from: usize) ?usize {
    if (haystack.len < set.len or from > haystack.len - set.len) return null;
    for (from..haystack.len - set.len + 1) |index| {
        for (set.octets[0..set.count]) |*octets| {
            if (std.mem.eql(u8, haystack[index..][0..set.len], octets[0..set.len])) return index;
        }
    }
    return null;
}

/// The octets of a test's literals, and the lengths past the shortest they take: few, so that
/// pairs often stand where no literal does. `a`, `q` and 0xE1 differ in their high nibble alone,
/// and `a` and `b` in their low one, so Teddy needs both of its lookups.
const test_letters = "abq\xe1";

/// The octet of a test's text that no literal holds.
const test_absent = 'd';

/// The octets of a test's text: the literals' octets and one that no literal holds.
const test_text_octets = test_letters ++ .{test_absent};

/// The octets past a head that a test's longest literals hold, so that some sets compare a tail.
const test_tail_len_max = 4;

/// The lengths a test's set takes: `literal_prefix_len_min` octets to `test_tail_len_max` past a
/// head.
const test_len_choices = head_len + test_tail_len_max - constants.literal_prefix_len_min + 1;

/// The literals a test writes into its text, some of them with one octet made `test_absent`, so
/// that a long literal stands whole at some places and all but one octet at others.
const test_plants = 4;

/// One plant in this many loses an octet.
const test_misses_one_in = 2;

/// A set of `count` literals of `literal_prefix_len_min` to `head_len + test_tail_len_max` octets.
fn random_set(generator: *Generator, count: usize) LiteralSet {
    const len = constants.literal_prefix_len_min + generator.below(test_len_choices);
    var set: LiteralSet = .{ .octets = undefined, .count = @intCast(count), .len = @intCast(len) };
    for (set.octets[0..count]) |*octets| {
        for (octets[0..set.len]) |*octet| octet.* = test_letters[generator.below(test_letters.len)];
    }
    set.prepare();
    return set;
}

/// The searches a host runs beside the library's own: SSSE3's Teddy and AVX2's 32 lanes.
const Kernels = struct { ssse3: bool, avx2: bool };

/// Requires `find` to give `expected` at `skip_lanes` octets a step, and in each variant object
/// the host has.
fn expect_find(set: *LiteralSet, kernels: Kernels, haystack: []const u8, from: usize, expected: ?usize) !void {
    set.wide = false;
    set.ssse3 = false;
    try testing.expectEqual(expected, set.find(haystack, from));
    if (kernels.ssse3) {
        set.ssse3 = true;
        try testing.expectEqual(expected, set.find(haystack, from));
        set.ssse3 = false;
    }
    if (!kernels.avx2) return;
    set.wide = true;
    try testing.expectEqual(expected, set.find(haystack, from));
}

/// Writes `test_plants` literals of the set at places of the text a seed draws, one in
/// `test_misses_one_in` of them with one octet made `test_absent`.
fn plant(generator: *Generator, set: *const LiteralSet, haystack: []u8) void {
    for (0..test_plants) |_| {
        const place = generator.below(haystack.len - set.len + 1);
        const text = haystack[place..][0..set.len];
        @memcpy(text, set.octets[generator.below(set.count)][0..set.len]);
        if (generator.below(test_misses_one_in) == 0) text[generator.below(set.len)] = test_absent;
    }
}

/// The blocks of a test's text, and a part of one, so that a search runs blocks and then the
/// octets one at a time.
const test_blocks = 2;
const test_haystack_len = test_blocks * block_len + constants.skip_lanes + constants.literal_len_max;

test "find gives the first place of a literal of the set from every offset, as a plain search does" {
    var generator = Generator.init(0x5E75);
    var haystack: [test_haystack_len]u8 = undefined;
    // Detection runs CPUID, which a virtual machine traps, so the test asks once.
    const features = codec.Features.detect();
    const kernels: Kernels = .{
        .ssse3 = literal_file.has_kernels and features.ssse3,
        .avx2 = literal_file.has_kernels and features.avx2,
    };
    for (2..constants.literal_set_max + 1) |count| {
        for (0..32) |_| {
            var set = random_set(&generator, count);
            for (&haystack) |*octet| octet.* = test_text_octets[generator.below(test_text_octets.len)];
            plant(&generator, &set, &haystack);
            const len = generator.below(haystack.len + 1);
            for (0..len + 1) |from| try expect_find(&set, kernels, haystack[0..len], from, find_plain(&set, haystack[0..len], from));
        }
    }
}

test "a short text gives no place whose literal would end past it, where the literals end in 0" {
    // Teddy's short search holds zero past the text's end, the last octet of each literal here.
    var set: LiteralSet = .{ .octets = undefined, .count = 4, .len = 2 };
    for (set.octets[0..set.count], "xyzw") |*octets, first| {
        octets[0] = first;
        octets[1] = 0;
    }
    set.prepare();
    const features = codec.Features.detect();
    const kernels: Kernels = .{
        .ssse3 = literal_file.has_kernels and features.ssse3,
        .avx2 = literal_file.has_kernels and features.avx2,
    };
    const texts = [_][]const u8{ "abx", "aaaaaaaaaaaaaaaaaaaay", "w\x00", "abw\x00x", "x\x00" ++ "a" ** 40 ++ "z" };
    for (texts) |text| {
        for (0..text.len + 1) |from| try expect_find(&set, kernels, text, from, find_plain(&set, text, from));
    }
}
