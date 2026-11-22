//! Claim R5 (decision 86): the literals one of which every match starts with, as in
//! `Abraham|Isaac|Jacob|Joseph`, and the search for the next place of one.
//!
//! A forward program that starts with an alternation splits into branches. Where each branch
//! starts with a literal, every match starts with one of them, and no match starts where none
//! stands. `LiteralSet.of` keeps each literal's first `len` octets, the length of the shortest,
//! so that every literal's first and last octets stand at one distance. Where the target has
//! NEON's TBL, or AVX2's VPSHUFB in the variant object, `find` takes Teddy (literal_teddy.zig),
//! whose step costs the same for two literals as for eight. Elsewhere it compares the text with
//! each literal's first and last octets, `skip_lanes` octets a step, as claim R2 does for one,
//! which needs SSE2 alone. Either compares each literal whole where its first octets stand.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const Program = program_file.Program;
const literal_file = @import("literal.zig");
const literal_teddy = @import("literal_teddy.zig");

/// The octets of a block, whatever the width of a step.
const block_len = constants.literal_steps * constants.skip_lanes;
const BlockMask = std.meta.Int(.unsigned, block_len);

/// The branches of a split.
const split_branches = 2;

extern fn stdx_regex_literal_set_find_x86_64_avx2(set: *const LiteralSet, haystack: [*]const u8, haystack_len: usize, from: usize) callconv(.c) usize;

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
    /// Teddy's tables of the literals, which `of` builds.
    teddy: literal_teddy.Tables = undefined,
    /// Each literal's length, at most `literal_len_max`.
    lens: [constants.literal_set_max]u8 = undefined,
    /// True when each literal is its whole branch: a match is then the first place where a
    /// literal stands whole, and there the first literal of the set that does (`find_exact`).
    exact: bool = false,

    /// The literals of the alternation that `program` starts with, or null where a branch starts
    /// with no literal, where the branches are more than `literal_set_max`, or where the shortest
    /// literal is under `literal_prefix_len_min`.
    pub fn of(program: *const Program) ?LiteralSet {
        var set: LiteralSet = .{ .octets = undefined, .count = 0, .len = constants.literal_len_max, .exact = true };
        var stack: [constants.literal_set_max]u32 = undefined;
        stack[0] = program.forward;
        var stack_len: usize = 1;
        // Each turn takes one branch, or splits one in two. A set has at most `literal_set_max`
        // branches, so it has at most one split fewer.
        for (0..split_branches * constants.literal_set_max) |_| {
            if (stack_len == 0) break;
            stack_len -= 1;
            const entry = past_saves(program, stack[stack_len]);
            const instruction = program.instructions[entry];
            // A split of a letter's two cases is two branches too, each with one case.
            if (instruction.kind == .split) {
                if (set.count + stack_len + split_branches > constants.literal_set_max) return null;
                stack[stack_len] = instruction.arg;
                stack[stack_len + 1] = instruction.out;
                stack_len += split_branches;
                continue;
            }
            const literal = literal_file.branch_of(program, entry) orelse return null;
            @memcpy(set.octets[set.count][0..literal.len], literal.slice());
            set.lens[set.count] = literal.len;
            set.exact = set.exact and literal.exact;
            set.len = @min(set.len, literal.len);
            set.count += 1;
        }
        // The bound on the branches bounds the turns: at most `literal_set_max` branches and
        // one split fewer.
        assert(stack_len == 0);
        if (set.count < constants.literal_set_count_min or set.len < constants.literal_prefix_len_min) return null;
        set.teddy = .of(&set);
        return set;
    }

    /// The first offset at or after `from` where a literal of the set stands, or null.
    pub fn find(set: *const LiteralSet, haystack: []const u8, from: usize) ?usize {
        // A set calls the variant object from `from`. `Literal.find` searches one block inline
        // first, but a set's 16-lane compares cost more than the call: on a Xeon, sets whose
        // places stand close together ran 1.01 to 1.23 times as fast with no inline block.
        if (literal_file.has_kernels and set.wide) return set.find_far(haystack, from);
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
            if (haystack.len - index >= len and std.mem.eql(u8, haystack[index..][0..len], octets[0..len])) return len;
        }
        return null;
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
            if (set.count >= constants.teddy_count_min) return literal_teddy.find(width, set, haystack, from, end);
        }
        return switch (set.count) {
            inline constants.literal_set_count_min...constants.literal_set_max => |count| set.find_of(width, count, haystack, from, end),
            else => unreachable,
        };
    }

    /// The first place of a literal of the set that starts at or after `from` and before `end`,
    /// where the haystack holds the set's `len` octets from each such place.
    fn find_of(set: *const LiteralSet, comptime width: usize, comptime count: usize, haystack: []const u8, from: usize, end: usize) ?usize {
        const last = set.len - 1;
        const Search = Lanes(width, count);
        var wanted: Search.Wanted = undefined;
        inline for (0..count) |literal| {
            wanted.firsts[literal] = @splat(set.octets[literal][0]);
            wanted.lasts[literal] = @splat(set.octets[literal][last]);
        }
        var index = from;
        // A block reads `block_len` octets from `index` and as many from `index + last`, whose
        // last is `end + block_len - 2 + last`, under the haystack's length.
        while (end - index >= block_len) : (index += block_len) {
            const firsts = haystack[index..][0..block_len];
            const lasts = haystack[index + last ..][0..block_len];
            if (!Search.any_candidate(firsts, lasts, &wanted)) continue;
            var mask = Search.candidates(firsts, lasts, &wanted);
            // Each set bit is one place to compare, at most `block_len` of them.
            while (mask != 0) : (mask &= mask - 1) {
                const candidate = index + @ctz(mask);
                if (set.stands_at(haystack, candidate)) return candidate;
            }
        }
        for (index..end) |candidate| {
            if (set.stands_at(haystack, candidate)) return candidate;
        }
        return null;
    }

    /// True when a literal of the set stands whole at `index`: at most `literal_set_max`
    /// compares of `len` octets.
    pub fn stands_at(set: *const LiteralSet, haystack: []const u8, index: usize) bool {
        const text = haystack[index..][0..set.len];
        for (set.octets[0..set.count]) |*octets| {
            if (std.mem.eql(u8, text, octets[0..set.len])) return true;
        }
        return false;
    }

    /// True when a literal whose bit `bits` holds stands whole at `index`: a compare of `len`
    /// octets for each bit, as Teddy's tables give them (literal_teddy.zig).
    pub fn stands_among(set: *const LiteralSet, bits: u8, haystack: []const u8, index: usize) bool {
        const text = haystack[index..][0..set.len];
        var left = bits;
        // Each set bit is one literal, at most `literal_set_max` of them.
        while (left != 0) : (left &= left - 1) {
            if (std.mem.eql(u8, text, set.octets[@ctz(left)][0..set.len])) return true;
        }
        return false;
    }
};

/// A match of an exact set: the octets from `start` to `end`.
pub const Place = struct { start: usize, end: usize };

/// Follows saves and jumps from `entry`, which take no octet: each instruction once.
fn past_saves(program: *const Program, entry: u32) u32 {
    var index = entry;
    for (0..program.instructions.len) |_| {
        const instruction = program.instructions[index];
        if (instruction.kind != .save and instruction.kind != .jump) return index;
        index = instruction.out;
    }
    return index;
}

/// The search's steps for a vector of `width` octets and a set of `count` literals.
fn Lanes(comptime width: usize, comptime count: usize) type {
    comptime assert(block_len % width == 0);
    return struct {
        const Vector = @Vector(width, u8);
        const Mask = std.meta.Int(.unsigned, width);
        const steps = block_len / width;

        /// Each literal's first and last octets, in every lane.
        const Wanted = struct { firsts: [count]Vector, lasts: [count]Vector };

        /// True when some place of a block holds some literal's first octet in `firsts` and its
        /// last octet at the same place in `lasts`.
        inline fn any_candidate(firsts: *const [block_len]u8, lasts: *const [block_len]u8, wanted: *const Wanted) bool {
            const all: Vector = @splat(constants.octet_max);
            const none: Vector = @splat(0);
            var any = none;
            inline for (0..steps) |step| {
                const at = step * width;
                const first: Vector = firsts[at..][0..width].*;
                const last: Vector = lasts[at..][0..width].*;
                inline for (0..count) |literal| {
                    const first_here = @select(u8, first == wanted.firsts[literal], all, none);
                    const last_here = @select(u8, last == wanted.lasts[literal], all, none);
                    any |= first_here & last_here;
                }
            }
            return @reduce(.Or, any) != 0;
        }

        /// A bit for each place of a block where some literal's first and last octets stand.
        inline fn candidates(firsts: *const [block_len]u8, lasts: *const [block_len]u8, wanted: *const Wanted) BlockMask {
            var mask: BlockMask = 0;
            inline for (0..steps) |step| {
                const at = step * width;
                const first: Vector = firsts[at..][0..width].*;
                const last: Vector = lasts[at..][0..width].*;
                var step_mask: Mask = 0;
                inline for (0..count) |literal| {
                    const both = @select(bool, first == wanted.firsts[literal], last == wanted.lasts[literal], @as(@Vector(width, bool), @splat(false)));
                    step_mask |= @as(Mask, @bitCast(both));
                }
                mask |= @as(BlockMask, step_mask) << at;
            }
            return mask;
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
        .{ .pattern = "(?:ab|cd)+x", .count = 2, .len = 2 },
        // Each branch's literal goes on past the group: `abh`, `cdh` and `efgh`.
        .{ .pattern = "(ab|cd|efg)h", .count = 3, .len = 3 },
        .{ .pattern = "a1|b2|c3|d4|e5|f6|g7|h8", .count = 8, .len = 2 },
    };
    for (counts) |case| {
        const one = (try set_of(case.pattern)) orelse return error.TestExpectedSet;
        try testing.expectEqual(case.count, one.count);
        try testing.expectEqual(case.len, one.len);
    }
}

test "of gives no set where a branch starts with no literal, or too short a one, or too many" {
    const none = [_][]const u8{
        "ab|c",    "a|b", "ab|cd|",                     "(?i)ab|cd", "(?:ab|cd)*x", "ab|[cd]e", "\\bab|cd",
        "Pharaoh", "ab",  "a1|b2|c3|d4|e5|f6|g7|h8|i9",
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

/// The octets of a test's text: the literals' octets and one that no literal holds.
const test_text_octets = test_letters ++ "d";
const test_len_choices = 3;

/// A set of `count` literals of two to four octets.
fn random_set(generator: *Generator, count: usize) LiteralSet {
    const len = constants.literal_prefix_len_min + generator.below(test_len_choices);
    var set: LiteralSet = .{ .octets = undefined, .count = @intCast(count), .len = @intCast(len) };
    for (set.octets[0..count]) |*octets| {
        for (octets[0..set.len]) |*octet| octet.* = test_letters[generator.below(test_letters.len)];
    }
    set.teddy = .of(&set);
    return set;
}

/// Requires `find` to give `expected` at `skip_lanes` octets a step, and at `avx2_lanes` where
/// the host has AVX2.
fn expect_find(set: *LiteralSet, avx2: bool, haystack: []const u8, from: usize, expected: ?usize) !void {
    set.wide = false;
    try testing.expectEqual(expected, set.find(haystack, from));
    if (!avx2) return;
    set.wide = true;
    try testing.expectEqual(expected, set.find(haystack, from));
}

/// The blocks of a test's text, and a part of one, so that a search runs blocks and then the
/// octets one at a time.
const test_blocks = 2;
const test_haystack_len = test_blocks * block_len + constants.skip_lanes + constants.literal_len_max;

test "find gives the first place of a literal of the set from every offset, as a plain search does" {
    var generator = Generator.init(0x5E75);
    var haystack: [test_haystack_len]u8 = undefined;
    // Detection runs CPUID, which a virtual machine traps, so the test asks once.
    const avx2 = literal_file.has_kernels and codec.Features.detect().avx2;
    for (2..constants.literal_set_max + 1) |count| {
        for (0..32) |_| {
            var set = random_set(&generator, count);
            for (&haystack) |*octet| octet.* = test_text_octets[generator.below(test_text_octets.len)];
            const len = generator.below(haystack.len + 1);
            for (0..len + 1) |from| try expect_find(&set, avx2, haystack[0..len], from, find_plain(&set, haystack[0..len], from));
        }
    }
}
