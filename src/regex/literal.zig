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
//! `find` compares the literal's octets at two offsets, `first_at` and `last_at`, with
//! `skip_lanes` octets a step, as Muła describes for a vector substring search ("SIMD-friendly
//! algorithms for substring searching", 2016), and compares the whole literal where both stand at
//! their distance. Muła compares the first and last octets. `prepare` takes the two whose kinds
//! rank rarest (literal_rank.zig), so that `Шерлок`'s search compares the continuation octets of
//! `Ш` and `к`, not the lead octet 0xD0 that starts half of Cyrillic's letters. Two octets at a
//! distance stand together far less often than one octet alone does, so a step leaves few places
//! to compare. A comparison reads at most `literal_len_max` octets and each step moves on, so a
//! search stays linear in the text.
//!
//! A place of the literal may take an ASCII letter in either case, as `(?i)` compiles it: a split
//! between two instructions whose octets differ in `case_bit` alone. The literal keeps the lower
//! case and a bit in `folds`, and each compare at that place ORs `case_bit` into the text's octet
//! first. SSE2 and NEON do that with one instruction a vector.
const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const Program = program_file.Program;
const literal_find = @import("literal_find.zig");
const literal_rank = @import("literal_rank.zig");
const literal_compare = @import("literal_compare.zig");

/// Whether this target has the AVX2 variant object's searches (variants.zig): x86-64 alone
/// builds it.
pub const has_kernels = builtin.cpu.arch == .x86_64;

/// What the variant object's searches give where the text holds no place.
pub const no_place = std.math.maxInt(usize);

/// The places a search with `wide` set judges before it calls the variant object: one block of
/// `literal_steps` steps.
pub const near_len = constants.literal_steps * constants.skip_lanes;

extern fn stdx_regex_literal_find_x86_64_avx2(literal: *const Literal, haystack: [*]const u8, haystack_len: usize, from: usize) callconv(.c) usize;

/// A bit for each place of a literal.
pub const Folds = std.meta.Int(.unsigned, constants.literal_len_max);

/// An extern struct, so that the variant object, built for other CPU features, reads the same
/// fields at the same offsets.
pub const Literal = extern struct {
    octets: [constants.literal_len_max]u8,
    len: u8,
    /// True when the literal is the whole pattern: a match is one place of the literal.
    exact: bool,
    /// True when `find` searches `avx2_lanes` octets a step, in the variant object: the caller's
    /// `platform.CpuFeatures` name AVX2, and `has_kernels` holds.
    wide: bool = false,
    /// A bit for each place that takes its octet in either case: `octets` holds the lower case.
    folds: Folds = 0,
    /// What a compare ORs into the text's octet at each place: `case_bit` where the place folds,
    /// and zero elsewhere, as `prepare` writes it from `folds`.
    fold_octets: [constants.literal_len_max]u8 = @splat(0),
    /// The two offsets below `len` whose octets the search compares, as `prepare` writes them.
    first_at: u8 = 0,
    last_at: u8 = 0,

    /// The literal every match of `program` starts with, or null where it has none that pays: a
    /// literal shorter than `literal_prefix_len_min` that more of the pattern follows. With
    /// `through_looks` the walk goes through assertions, which take no octet, so the literal
    /// stands where a match starts, and the match is the literal only where no assertion stood.
    pub fn of(program: *const Program, through_looks: bool) ?Literal {
        const found = walk(program, program.forward, through_looks);
        var literal = found.literal;
        if (literal.len == 0) return null;
        if (!literal.exact and literal.len < constants.literal_prefix_len_min) return null;
        literal.prepare();
        return literal;
    }

    /// Writes `first_at` and `last_at`: the two offsets whose octets rank rarest by their kind,
    /// or the one octet of a literal of one.
    pub fn prepare(literal: *Literal) void {
        assert(literal.len >= 1 and literal.len <= constants.literal_len_max);
        for (&literal.fold_octets, 0..) |*fold, place| fold.* = if (place < literal.len) literal.fold_at(place) else 0;
        if (literal.len == 1) {
            literal.first_at = 0;
            literal.last_at = 0;
            return;
        }
        var past: usize = 0;
        for (literal.slice()) |octet| past += @intFromBool(octet > constants.one_octet_max);
        const past_ascii = literal_rank.mostly(past, literal.len);
        var ranks: [constants.literal_len_max]u8 = undefined;
        for (ranks[0..literal.len], literal.slice()) |*one, octet| one.* = @intFromEnum(literal_rank.rank(octet, past_ascii));
        const pair = literal_rank.rarest_pair(ranks[0..literal.len]);
        literal.first_at = pair.first;
        literal.last_at = pair.last;
    }

    /// Claim R4: the literal every match ends with, read from the reverse program, and the
    /// instruction where the reverse program goes on to the part of a match before it. Null
    /// where the reverse program starts with no octet, or where it is all literal: claim R2 or
    /// R3 then holds the pattern.
    pub fn suffix_of(program: *const Program) ?Suffix {
        assert(program.reverse != program_file.no_entry);
        var found = walk(program, program.reverse, true);
        if (found.literal.len == 0 or found.reached_match) return null;
        std.mem.reverse(u8, found.literal.octets[0..found.literal.len]);
        // The places' bits follow their octets: bit i goes to bit len - 1 - i.
        const unused: std.math.Log2Int(Folds) = @intCast(constants.literal_len_max - found.literal.len);
        found.literal.folds = @bitReverse(found.literal.folds) >> unused;
        found.literal.exact = false;
        found.literal.prepare();
        return .{ .literal = found.literal, .before = found.stop };
    }

    fn push(literal: *Literal, octet: u8, fold: bool) void {
        assert(literal.len < constants.literal_len_max);
        literal.octets[literal.len] = octet;
        if (fold) literal.folds |= @as(Folds, 1) << @intCast(literal.len);
        literal.len += 1;
    }

    pub fn slice(literal: *const Literal) []const u8 {
        return literal.octets[0..literal.len];
    }

    /// What a compare ORs into the text's octet at `place`: `case_bit` where the place folds.
    pub fn fold_at(literal: *const Literal, place: usize) u8 {
        return if (literal.folds >> @intCast(place) & 1 != 0) constants.case_bit else 0;
    }

    /// The first offset at or after `from` where the literal stands whole in `haystack`, or null.
    pub fn find(literal: *const Literal, haystack: []const u8, from: usize) ?usize {
        if (has_kernels and literal.wide) {
            // The variant object's search is a call no compiler inlines. A place within a block
            // of `from`, as in a text where the literal is common, is found without a call.
            const near = @min(haystack.len, from + near_len);
            if (literal_find.find_before(constants.skip_lanes, literal, haystack, from, near)) |offset| return offset;
            return find_far(literal, haystack, near);
        }
        return literal_find.find(constants.skip_lanes, literal, haystack, from);
    }

    /// The variant object's search from `near`, out of line, so that `find` stays small enough
    /// for its callers to inline.
    noinline fn find_far(literal: *const Literal, haystack: []const u8, near: usize) ?usize {
        if (haystack.len - near < literal.len) return null;
        const found = stdx_regex_literal_find_x86_64_avx2(literal, haystack.ptr, haystack.len, near);
        return if (found == no_place) null else found;
    }

    /// True when the literal stands whole at `index`, which leaves room for it.
    pub fn stands_at(literal: *const Literal, haystack: []const u8, index: usize) bool {
        return literal_compare.folded(haystack[index..][0..literal.len], &literal.octets, &literal.fold_octets);
    }
};

/// A literal every match ends with, and the first instruction of the reverse program after it.
pub const Suffix = struct { literal: Literal, before: u32 };

/// What a walk of a program found: the octets its instructions take one after another from
/// `entry`, and the instruction where it stopped.
const Walk = struct {
    literal: Literal,
    stop: u32,
    reached_match: bool,
};

/// Follows `out` from `entry` through saves, jumps and, with `through_looks`, assertions, and
/// keeps the octet of each instruction that takes one octet alone, up to `literal_len_max`.
fn walk(program: *const Program, entry: u32, through_looks: bool) Walk {
    var literal: Literal = .{ .octets = undefined, .len = 0, .exact = false };
    var passed_look = false;
    var index = entry;
    // Each instruction is read once: the walk follows `out`, and past a split that `case_pair`
    // takes, its two instructions' one `out`.
    for (0..program.instructions.len) |_| {
        const instruction = program.instructions[index];
        var next = instruction.out;
        switch (instruction.kind) {
            .save, .jump => {},
            .range => {
                if (instruction.lo != instruction.hi or literal.len == constants.literal_len_max) break;
                literal.push(instruction.lo, false);
            },
            .split => {
                if (literal.len == constants.literal_len_max) break;
                const pair = case_pair(program, instruction) orelse break;
                literal.push(pair.octet, true);
                next = pair.out;
            },
            .match => {
                literal.exact = !passed_look;
                return .{ .literal = literal, .stop = index, .reached_match = true };
            },
            // A node of a class takes more than one octet.
            .ranges => break,
            .look => {
                if (!through_looks) break;
                passed_look = true;
            },
            .fail => break,
        }
        index = next;
    }
    return .{ .literal = literal, .stop = index, .reached_match = false };
}

/// The lower case and the next instruction of a split whose two branches each take one octet,
/// the two differing in `case_bit` alone and leading to one instruction: `(?i)`'s ASCII letter.
fn case_pair(program: *const Program, split: program_file.Instruction) ?struct { octet: u8, out: u32 } {
    const one = program.instructions[split.out];
    const other = program.instructions[split.arg];
    if (one.kind != .range or other.kind != .range or one.out != other.out) return null;
    if (one.lo != one.hi or other.lo != other.hi) return null;
    if (one.lo ^ other.lo != constants.case_bit) return null;
    return .{ .octet = one.lo | constants.case_bit, .out = one.out };
}

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
