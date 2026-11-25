//! The literal that a searcher's forward DFA goes to, as a `prefix` line of a dump names it
//! (decision 86, claims R2 and R3, design §8 part 22q).
//!
//! A forward DFA goes to the places of a literal that every match starts with. `Literal.of`
//! reads that literal from the program: from the instructions that follow one another, or, for a
//! program with an assertion and more than one way to start, from the first bytes of each way
//! (src/regex/literal_common.zig). `held` reads what a searcher holds.
//!
//! The Lean side decides from the program that every match starts with the literal
//! (spec/lean/Stdx/Regex/RulesPrefix.lean). The rule holds for every text or for none, so a
//! literal that fails there is a wrong choice for some text.
const std = @import("std");
const regex = @import("regex");
const platform = @import("platform");

/// A literal that every match starts with.
pub const Prefix = struct {
    /// The literal's bytes. A place that folds holds the lower-case letter.
    literal: []const u8,
    /// The places that take a letter in either case: bit `i` for place `i` (`Literal.folds`).
    folds: u64 = 0,

    pub fn same(prefix: Prefix, other: Prefix) bool {
        return prefix.folds == other.folds and std.mem.eql(u8, prefix.literal, other.literal);
    }
};

/// The literal that a searcher's forward DFA goes to, or null where it goes to none.
pub fn held(searcher: *const regex.Searcher) ?Prefix {
    const literal = &(searcher.forward.literal orelse return null);
    return .{ .literal = literal.slice(), .folds = literal.folds };
}

/// The literal of a program's `prefix` line, which a replay keeps until the program's searches.
pub const Named = struct {
    octets: [regex.constants.literal_len_max]u8 = undefined,
    len: ?usize = null,
    folds: u64 = 0,
    /// The `prefix` lines read.
    lines: usize = 0,

    /// Forgets the line, for the next program.
    pub fn clear(named: *Named) void {
        named.len = null;
        named.folds = 0;
    }

    /// A `prefix` line after its first word: the literal's length, its bytes, and after the
    /// word `folds` the bits of the places that fold.
    pub fn set(named: *Named, tokens: *std.mem.TokenIterator(u8, .scalar)) !void {
        const len = try number(usize, tokens);
        if (len == 0 or len > named.octets.len) return error.VectorPrefix;
        for (named.octets[0..len]) |*byte| byte.* = try number(u8, tokens);
        named.folds = 0;
        if (tokens.next()) |word| {
            if (!std.mem.eql(u8, word, "folds")) return error.VectorPrefix;
            named.folds = try number(u64, tokens);
        }
        if (tokens.next() != null) return error.VectorPrefix;
        named.len = len;
        named.lines += 1;
    }

    /// Requires a searcher's forward DFA to go to the literal that the file names, and to none
    /// where the file names none. So what the Lean side judged is what this build's searcher
    /// takes.
    pub fn expect(named: *const Named, searcher: *const regex.Searcher) !void {
        const taken = held(searcher) orelse return if (named.len == null) {} else error.PrefixDiffers;
        const len = named.len orelse return error.PrefixDiffers;
        if (!taken.same(.{ .literal = named.octets[0..len], .folds = named.folds })) return error.PrefixDiffers;
    }
};

fn number(comptime T: type, tokens: *std.mem.TokenIterator(u8, .scalar)) !T {
    return std.fmt.parseInt(T, tokens.next() orelse return error.VectorPrefix, 10) catch error.VectorPrefix;
}

const testing = std.testing;
const test_instructions_max = 256;
const test_slots_max = 8;

/// A searcher for a test's pattern, with its storage.
const Fixture = struct {
    storage: [test_instructions_max]regex.Instruction = undefined,
    memory: []u64,
    program: regex.Program = undefined,
    searcher: regex.Searcher = undefined,

    fn init(arena: std.mem.Allocator) !Fixture {
        return .{ .memory = try arena.alloc(u64, regex.Searcher.memory_len(test_instructions_max, test_slots_max, regex.constants.cache_words_default)) };
    }

    fn take(fixture: *Fixture, pattern: []const u8) !void {
        fixture.program = try regex.compile(pattern, .{}, &fixture.storage);
        fixture.searcher.init(&fixture.program, &.{ .features = platform.CpuFeatures.detect() }, fixture.memory);
    }
};

fn named_of(line: []const u8) !Named {
    var named: Named = .{};
    var tokens = std.mem.tokenizeScalar(u8, line, ' ');
    try named.set(&tokens);
    return named;
}

test "held reads the literal that a forward DFA goes to, and the places that fold" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    var fixture = try Fixture.init(arena.allocator());
    try fixture.take("ab[0-9]+");
    try testing.expectEqualStrings("ab", held(&fixture.searcher).?.literal);
    try testing.expectEqual(@as(u64, 0), held(&fixture.searcher).?.folds);
    // More than one way to start, with an assertion: the first bytes of each way.
    try fixture.take("(?m)^abc|abd$");
    try testing.expectEqualStrings("ab", held(&fixture.searcher).?.literal);
    try fixture.take("\\b(?i:a)bc|abd");
    try testing.expectEqual(@as(u64, 0b01), held(&fixture.searcher).?.folds);
    // No literal starts every match.
    try fixture.take("[0-9]+ab");
    try testing.expect(held(&fixture.searcher) == null);
    try fixture.take("\\bab|cd");
    try testing.expect(held(&fixture.searcher) == null);
}

test "a searcher is held to the literal of a prefix line, and to none with no line" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    var fixture = try Fixture.init(arena.allocator());
    try fixture.take("(?m)^abc|abd$");
    try (try named_of("2 97 98")).expect(&fixture.searcher);
    try testing.expectError(error.PrefixDiffers, (try named_of("2 97 99")).expect(&fixture.searcher));
    try testing.expectError(error.PrefixDiffers, (try named_of("1 97")).expect(&fixture.searcher));
    try testing.expectError(error.PrefixDiffers, (try named_of("2 97 98 folds 1")).expect(&fixture.searcher));
    try testing.expectError(error.PrefixDiffers, (Named{}).expect(&fixture.searcher));
    // A searcher with no literal, and a line that names one.
    try fixture.take("[0-9]+ab");
    try (Named{}).expect(&fixture.searcher);
    try testing.expectError(error.PrefixDiffers, (try named_of("2 97 98")).expect(&fixture.searcher));
    // A place that folds.
    try fixture.take("\\b(?i:a)bc|abd");
    try (try named_of("2 97 98 folds 1")).expect(&fixture.searcher);
    try testing.expectError(error.PrefixDiffers, (try named_of("2 97 98")).expect(&fixture.searcher));
}

test "a prefix line holds a length, as many bytes, and the folds alone after them" {
    const named = try named_of("3 97 98 99 folds 5");
    try testing.expectEqual(@as(?usize, 3), named.len);
    try testing.expectEqual(@as(u64, 5), named.folds);
    try testing.expectEqual(@as(usize, 1), named.lines);
    try testing.expectError(error.VectorPrefix, named_of("0"));
    try testing.expectError(error.VectorPrefix, named_of("3 97 98"));
    try testing.expectError(error.VectorPrefix, named_of("2 97 98 99"));
    try testing.expectError(error.VectorPrefix, named_of("2 97 98 folds"));
    try testing.expectError(error.VectorPrefix, named_of("2 97 98 folds 1 2"));
    try testing.expectError(error.VectorPrefix, named_of("2 97 x"));
    var cleared = named;
    cleared.clear();
    try testing.expect(cleared.len == null and cleared.folds == 0 and cleared.lines == 1);
}
