//! The literal that every match of a pattern starts with, and the search for it (decision 86,
//! claim R2).
//!
//! A forward program that starts with instructions that each take one octet holds a literal that
//! every match starts with: no match can start where the literal does not stand. `Literal.of`
//! reads it from the program, and `find` gives the next place where it stands. The forward DFA's
//! skip goes there from the state that waits for a match to start, so the DFA reads no octet
//! between two places of the literal. A pattern that is its literal and nothing else needs no DFA:
//! each place of the literal is a match.
//!
//! `find` compares the literal's first and last octets with `skip_lanes` octets a step, as Muła
//! describes for a vector substring search ("SIMD-friendly algorithms for substring searching",
//! 2016), and compares the whole literal where both stand at their distance. Two octets at a
//! distance stand together far less often than one octet alone does, so a step leaves few places
//! to compare. A comparison reads at most `literal_len_max` octets and each step moves on, so a
//! search stays linear in the text.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const Program = program_file.Program;

const Lanes = @Vector(constants.skip_lanes, u8);
const Mask = std.meta.Int(.unsigned, constants.skip_lanes);
const BlockMask = std.meta.Int(.unsigned, block_len);

pub const Literal = struct {
    octets: [constants.literal_len_max]u8,
    len: u8,
    /// True when the literal is the whole pattern: a match is one place of the literal.
    exact: bool,

    /// The literal every match of `program` starts with, or null where it has none that pays: a
    /// literal shorter than `literal_prefix_len_min` that more of the pattern follows. With
    /// `through_looks` the walk goes through assertions, which take no octet, so the literal
    /// stands where a match starts, and the match is the literal only where no assertion stood.
    pub fn of(program: *const Program, through_looks: bool) ?Literal {
        var literal: Literal = .{ .octets = undefined, .len = 0, .exact = false };
        var passed_look = false;
        var index = program.forward;
        // Each instruction is read once: the walk follows `out` and stops at a split.
        for (0..program.forward_len) |_| {
            const instruction = program.instructions[index];
            switch (instruction.kind) {
                .save, .jump => index = instruction.out,
                .range => {
                    if (instruction.lo != instruction.hi or literal.len == constants.literal_len_max) break;
                    literal.octets[literal.len] = instruction.lo;
                    literal.len += 1;
                    index = instruction.out;
                },
                .match => {
                    literal.exact = !passed_look;
                    break;
                },
                .look => {
                    if (!through_looks) break;
                    passed_look = true;
                    index = instruction.out;
                },
                .split, .fail => break,
            }
        }
        if (literal.len == 0) return null;
        if (!literal.exact and literal.len < constants.literal_prefix_len_min) return null;
        return literal;
    }

    pub fn slice(literal: *const Literal) []const u8 {
        return literal.octets[0..literal.len];
    }

    /// The first offset at or after `from` where the literal stands whole in `haystack`, or null.
    pub fn find(literal: *const Literal, haystack: []const u8, from: usize) ?usize {
        assert(from <= haystack.len);
        assert(literal.len >= 1);
        if (haystack.len - from < literal.len) return null;
        // A place of the literal starts before `end`.
        const end = haystack.len - literal.len + 1;
        const after = literal.by_lanes(haystack, from, end);
        if (after.found) |offset| return offset;
        for (after.index..end) |index| {
            if (haystack[index] == literal.octets[0] and literal.stands_at(haystack, index)) return index;
        }
        return null;
    }

    fn stands_at(literal: *const Literal, haystack: []const u8, index: usize) bool {
        return std.mem.eql(u8, haystack[index..][0..literal.len], literal.slice());
    }

    /// The first place of the literal that a whole block of `literal_steps` steps holds, or the
    /// offset of the first block that does not fit before `end`. A block tests all its steps
    /// before it looks for a place in one, so a block with no candidate costs one branch.
    fn by_lanes(literal: *const Literal, haystack: []const u8, from: usize, end: usize) struct { found: ?usize, index: usize } {
        const last = literal.len - 1;
        const first_octets: Lanes = @splat(literal.octets[0]);
        const last_octets: Lanes = @splat(literal.octets[last]);
        var index = from;
        // A block reads `block_len` octets from `index` and as many from `index + last`, whose
        // last is `end + block_len - 2 + last`, under the haystack's length.
        while (end - index >= block_len) : (index += block_len) {
            const firsts = haystack[index..][0..block_len];
            const lasts = haystack[index + last ..][0..block_len];
            var mask = candidates(firsts, lasts, first_octets, last_octets);
            // Each set bit is one place to compare, at most `block_len` of them.
            while (mask != 0) : (mask &= mask - 1) {
                const candidate = index + @ctz(mask);
                if (literal.stands_at(haystack, candidate)) return .{ .found = candidate, .index = index };
            }
        }
        return .{ .found = null, .index = index };
    }
};

const block_len = constants.literal_steps * constants.skip_lanes;

/// A bit for each place of a block where the first octet stands in `firsts` and the last octet
/// at the same place in `lasts`, the block read from the literal's last octet on.
inline fn candidates(firsts: *const [block_len]u8, lasts: *const [block_len]u8, first_octets: Lanes, last_octets: Lanes) BlockMask {
    var mask: BlockMask = 0;
    inline for (0..constants.literal_steps) |step| {
        const at = step * constants.skip_lanes;
        const first: Lanes = firsts[at..][0..constants.skip_lanes].*;
        const last: Lanes = lasts[at..][0..constants.skip_lanes].*;
        const both = @select(bool, first == first_octets, last == last_octets, @as(@Vector(constants.skip_lanes, bool), @splat(false)));
        const step_mask: Mask = @bitCast(both);
        mask |= @as(BlockMask, step_mask) << at;
    }
    return mask;
}

const testing = std.testing;
const compiler = @import("compile.zig");
const Generator = @import("codec").testing.split.Generator;

/// The instructions a test's pattern takes at most.
const test_storage_len = 256;

fn literal_of(pattern: []const u8) !?Literal {
    var storage: [test_storage_len]program_file.Instruction = undefined;
    const program = try compiler.compile(pattern, .{}, &storage);
    return Literal.of(&program, false);
}

fn literal_through_looks(pattern: []const u8) !?Literal {
    var storage: [test_storage_len]program_file.Instruction = undefined;
    const program = try compiler.compile(pattern, .{}, &storage);
    return Literal.of(&program, true);
}

fn expect_literal(pattern: []const u8, octets: []const u8, exact: bool) !void {
    const literal = (try literal_of(pattern)) orelse return error.TestExpectedLiteral;
    try testing.expectEqualStrings(octets, literal.slice());
    try testing.expectEqual(exact, literal.exact);
}

test "of reads the literal every match starts with, and says whether the pattern is no more" {
    try expect_literal("Pharaoh", "Pharaoh", true);
    try expect_literal("(Pharaoh)", "Pharaoh", true);
    try expect_literal("a", "a", true);
    try expect_literal("\xC3\xA9t\xC3\xA9", "\xC3\xA9t\xC3\xA9", true);
    try expect_literal("href=\"[^\"]*\"", "href=\"", false);
    try expect_literal("fo+", "fo", false);
    try expect_literal("(Ph)a+", "Pha", false);
    try expect_literal("Ph(?:a|o)", "Ph", false);
    // A class of one octet is that octet.
    try expect_literal("f[o]", "fo", true);
    // A literal past the longest one kept: its first octets, and more of the pattern follows.
    try expect_literal("x" ** (constants.literal_len_max + 1), "x" ** constants.literal_len_max, false);
    try expect_literal("x" ** constants.literal_len_max, "x" ** constants.literal_len_max, true);
}

test "of gives no literal where a match may start otherwise, or where one octet starts it" {
    const none = [_][]const u8{ "", "(?i)ph", "ab|ac", "a*b", "[ab]c", "\\bab", "^ab", "a+", "f[op]", ".a" };
    for (none) |pattern| {
        if (try literal_of(pattern) != null) return error.TestUnexpectedLiteral;
    }
}

test "through assertions, of reads the literal after them, and no pattern with one is its literal" {
    const cases = [_]struct { pattern: []const u8, octets: []const u8 }{
        .{ .pattern = "\\bPharaoh\\b", .octets = "Pharaoh" },
        .{ .pattern = "(?m)^ab", .octets = "ab" },
        .{ .pattern = "\\Bab", .octets = "ab" },
        .{ .pattern = "a\\bb", .octets = "ab" },
        .{ .pattern = "ab$", .octets = "ab" },
    };
    for (cases) |case| {
        const literal = (try literal_through_looks(case.pattern)) orelse return error.TestExpectedLiteral;
        try testing.expectEqualStrings(case.octets, literal.slice());
        try testing.expect(!literal.exact);
    }
    // With no assertion the walk is the same.
    const plain = (try literal_through_looks("Pharaoh")) orelse return error.TestExpectedLiteral;
    try testing.expect(plain.exact);
    try testing.expect(try literal_through_looks("\\b(?:ab|ac)") == null);
    try testing.expect(try literal_through_looks("\\ba") == null);
}

/// The first place of `needle` at or after `from`, one offset at a time: what `find` must give.
fn find_plain(haystack: []const u8, needle: []const u8, from: usize) ?usize {
    return std.mem.indexOfPos(u8, haystack, from, needle);
}

test "find gives the first place of the literal from every offset, as a plain search gives it" {
    var generator = Generator.init(0x117E);
    var haystack: [3 * constants.skip_lanes + constants.literal_len_max]u8 = undefined;
    const needles = [_][]const u8{ "a", "ab", "aba", "abcab", "aa", "aaa", "b" ** constants.literal_len_max, "a\xFFb" };
    for (needles) |needle| {
        var literal: Literal = .{ .octets = undefined, .len = @intCast(needle.len), .exact = true };
        @memcpy(literal.octets[0..needle.len], needle);
        for (0..64) |_| {
            // Octets of the needle and one more, so that the first and last octets stand together
            // often where the whole needle does not.
            for (&haystack) |*octet| octet.* = "abc\xFF"[generator.below(4)];
            const len = generator.below(haystack.len + 1);
            for (0..len + 1) |from| {
                try testing.expectEqual(find_plain(haystack[0..len], needle, from), literal.find(haystack[0..len], from));
            }
        }
    }
}
