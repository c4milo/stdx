//! The tests of literal.zig (decision 86): the literal a program starts with or ends with, and
//! the search for a literal's places.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const literal_file = @import("literal.zig");
const Literal = literal_file.Literal;
const Folds = literal_file.Folds;
const has_kernels = literal_file.has_kernels;

const testing = std.testing;
const compiler = @import("compile.zig");
const codec = @import("codec");
const platform = @import("platform");
const Generator = codec.testing.split.Generator;

/// The instructions a test's pattern takes at most, its forward and its reverse program:
/// `[^u-z]{13}` takes some hundreds.
const test_storage_len = 4096;

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
    const none = [_][]const u8{ "", "(?i)p+", "ab|ac", "a*b", "[ab]c", "\\bab", "^ab", "a+", "f[op]", ".a", "[Pq]h", "(?:Pa|pb)", "[A-Ca-c]x" };
    for (none) |pattern| {
        if (try literal_of(pattern) != null) return error.TestUnexpectedLiteral;
    }
}

test "of reads a letter in either case as one place that folds" {
    const cases = [_]struct { pattern: []const u8, octets: []const u8, folds: Folds, exact: bool }{
        .{ .pattern = "(?i)pharaoh", .octets = "pharaoh", .folds = 0x7F, .exact = true },
        .{ .pattern = "(?i)Ph", .octets = "ph", .folds = 0b11, .exact = true },
        .{ .pattern = "(?i:p)h", .octets = "ph", .folds = 0b01, .exact = true },
        .{ .pattern = "(?i)p1", .octets = "p1", .folds = 0b01, .exact = true },
        // Two octets that differ in `case_bit` alone fold, letters or not.
        .{ .pattern = "[@`]x", .octets = "`x", .folds = 0b01, .exact = true },
        .{ .pattern = "(?i)ph+", .octets = "ph", .folds = 0b11, .exact = false },
    };
    for (cases) |case| {
        const literal = (try literal_of(case.pattern)) orelse return error.TestExpectedLiteral;
        try testing.expectEqualStrings(case.octets, literal.slice());
        try testing.expectEqual(case.folds, literal.folds);
        try testing.expectEqual(case.exact, literal.exact);
    }
    // A suffix's places keep their bits in the order of the text.
    const suffix = (try suffix_of_pattern("[ab]+(?i:x)y")) orelse return error.TestExpectedLiteral;
    try testing.expectEqualStrings("xy", suffix.slice());
    try testing.expectEqual(@as(Folds, 0b01), suffix.folds);
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

fn suffix_of_pattern(pattern: []const u8) !?Literal {
    var storage: [test_storage_len]program_file.Instruction = undefined;
    const program = try compiler.compile(pattern, .{}, &storage);
    const suffix = Literal.suffix_of(&program) orelse return null;
    return suffix.literal;
}

test "suffix_of reads the literal every match ends with, in the order of the text" {
    const cases = [_]struct { pattern: []const u8, octets: []const u8 }{
        .{ .pattern = "[0-9][0-9,]* km", .octets = " km" },
        .{ .pattern = "(?m)^[A-Z][a-z]+:", .octets = ":" },
        .{ .pattern = "[a-q][^u-z]{13}x", .octets = "x" },
        .{ .pattern = "[ab]+(xy)\\b", .octets = "xy" },
        .{ .pattern = "[ab]+\xC3\xA9", .octets = "\xC3\xA9" },
        // A suffix whose first octet the part before it takes too: claim R4 refuses it later.
        .{ .pattern = "x+", .octets = "x" },
    };
    for (cases) |case| {
        const literal = (try suffix_of_pattern(case.pattern)) orelse return error.TestExpectedLiteral;
        try testing.expectEqualStrings(case.octets, literal.slice());
        try testing.expect(!literal.exact);
    }
    // No literal ends every match, or the whole pattern is one.
    const none = [_][]const u8{ "ab|cb", "x[ab]", "[ab]+", "a*", "Pharaoh", "\\bab\\b" };
    for (none) |pattern| {
        if (try suffix_of_pattern(pattern) != null) return error.TestUnexpectedLiteral;
    }
}

/// The octets of a test's text: two blocks of `literal_wide_steps`, one of `literal_steps` and a
/// part of one, so that a search runs each kind of block and the octets one at a time.
const test_wide_blocks = 2;
const test_haystack_len = (test_wide_blocks * constants.literal_wide_steps + constants.literal_steps + 1) * constants.skip_lanes + constants.literal_len_max;

/// True when a host with `features` runs the variant object's search, which the tests then hold to
/// the plain search too. Detection runs CPUID, which a virtual machine traps, so a test detects
/// once and passes what it found.
fn test_has_avx2(features: platform.CpuFeatures) bool {
    return has_kernels and features.avx2;
}

/// Requires `find` to give `expected` at `skip_lanes` octets a step, and at `avx2_lanes` where
/// the host has AVX2.
fn expect_find(literal: *Literal, avx2: bool, haystack: []const u8, from: usize, expected: ?usize) !void {
    literal.wide = false;
    try testing.expectEqual(expected, literal.find(haystack, from));
    if (!avx2) return;
    literal.wide = true;
    try testing.expectEqual(expected, literal.find(haystack, from));
}

/// The first place of `needle` at or after `from`, one offset at a time: what `find` must give.
fn find_plain(haystack: []const u8, needle: []const u8, from: usize) ?usize {
    return std.mem.indexOfPos(u8, haystack, from, needle);
}

/// The first place at or after `from` where `literal` stands, its folded places in either case,
/// one offset at a time: what `find` must give.
fn find_folded_plain(literal: *const Literal, haystack: []const u8, from: usize) ?usize {
    if (haystack.len < literal.len or from > haystack.len - literal.len) return null;
    for (from..haystack.len - literal.len + 1) |index| {
        var stands = true;
        for (literal.slice(), 0..) |wanted, place| stands = stands and haystack[index + place] | literal.fold_at(place) == wanted;
        if (stands) return index;
    }
    return null;
}

test "find gives the first place of a literal that folds from every offset, as a plain search does" {
    var generator = Generator.init(0xF01D);
    var haystack: [test_haystack_len]u8 = undefined;
    const avx2 = test_has_avx2(platform.CpuFeatures.detect());
    const needles = [_][]const u8{ "a", "ab", "aba", "abcab", "aa", "b" ** constants.literal_len_max, "a@b", "ab@c@" };
    for (needles) |needle| {
        var literal: Literal = .{ .octets = undefined, .len = @intCast(needle.len), .exact = true };
        @memcpy(literal.octets[0..needle.len], needle);
        for (0..64) |_| {
            // Each place folds or not, and the text holds both cases, `@` and its fold, and one
            // octet more.
            literal.folds = @truncate(generator.next());
            for (literal.octets[0..needle.len], 0..) |*octet, place| octet.* = needle[place] | literal.fold_at(place);
            literal.prepare();
            for (&haystack) |*octet| octet.* = "abcABC@`\xFF"[generator.below(9)];
            const len = generator.below(haystack.len + 1);
            for (0..len + 1) |from| {
                try expect_find(&literal, avx2, haystack[0..len], from, find_folded_plain(&literal, haystack[0..len], from));
            }
        }
    }
}

test "find gives the first place of the literal from every offset, as a plain search gives it" {
    var generator = Generator.init(0x117E);
    var haystack: [test_haystack_len]u8 = undefined;
    const avx2 = test_has_avx2(platform.CpuFeatures.detect());
    // Needles whose compared octets are their ends, and needles whose rarest octets stand inside:
    // capitals among lowercase letters, and Cyrillic's continuation octets.
    const needles = [_][]const u8{ "a", "ab", "aba", "abcab", "aa", "aaa", "b" ** constants.literal_len_max, "a\xFFb", "abXcdYe", "\xd0\xa8\xd0\xb5\xd1\x80" };
    for (needles) |needle| {
        var literal: Literal = .{ .octets = undefined, .len = @intCast(needle.len), .exact = true };
        @memcpy(literal.octets[0..needle.len], needle);
        literal.prepare();
        for (0..64) |_| {
            // Octets of the needle and one more, so that its compared octets stand together often
            // where the whole needle does not, and the needle whole at one place.
            for (&haystack) |*octet| {
                const pick = generator.below(needle.len + 1);
                octet.* = if (pick == needle.len) constants.octet_max else needle[pick];
            }
            const place = generator.below(haystack.len - needle.len + 1);
            @memcpy(haystack[place..][0..needle.len], needle);
            const len = generator.below(haystack.len + 1);
            for (0..len + 1) |from| {
                try expect_find(&literal, avx2, haystack[0..len], from, find_plain(haystack[0..len], needle, from));
            }
        }
    }
}

test "of and suffix_of write the offsets of the rarest octets" {
    const prefix = (try literal_of("abXcdYe\\w")) orelse return error.TestExpectedLiteral;
    try testing.expectEqual(@as(u8, 2), prefix.first_at);
    try testing.expectEqual(@as(u8, 5), prefix.last_at);
    var storage: [test_storage_len]program_file.Instruction = undefined;
    const program = try compiler.compile("\\w+abXcdYe", .{}, &storage);
    const suffix = Literal.suffix_of(&program) orelse return error.TestExpectedLiteral;
    try testing.expectEqualStrings("abXcdYe", suffix.literal.slice());
    try testing.expectEqual(@as(u8, 2), suffix.literal.first_at);
    try testing.expectEqual(@as(u8, 5), suffix.literal.last_at);
}

test "prepare takes the offsets of the rarest octets, and the ends where all rank alike" {
    const cases = [_]struct { needle: []const u8, first: u8, last: u8 }{
        .{ .needle = "a", .first = 0, .last = 0 },
        .{ .needle = "abcab", .first = 0, .last = 4 },
        .{ .needle = "abXcdYe", .first = 2, .last = 5 },
        // `Шер`: lead octets at 0, 2 and 4, continuations at 1, 3 and 5.
        .{ .needle = "\xd0\xa8\xd0\xb5\xd1\x80", .first = 1, .last = 5 },
    };
    for (cases) |case| {
        var literal: Literal = .{ .octets = undefined, .len = @intCast(case.needle.len), .exact = true };
        @memcpy(literal.octets[0..case.needle.len], case.needle);
        literal.prepare();
        try testing.expectEqual(case.first, literal.first_at);
        try testing.expectEqual(case.last, literal.last_at);
    }
}
