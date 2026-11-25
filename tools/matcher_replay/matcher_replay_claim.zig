//! The claim that a searcher took for a program by the places of a literal, as a `claim` line
//! of a dump names it (decision 86, design §8 part 22r).
//!
//! A searcher goes to a literal's places by claim R4, for a literal that ends every match, or
//! by claim R14, for a literal inside every match. It takes a literal after it judged a rule
//! from the program: claim R4's first rule at `init`, and its two other rules and claim R14
//! after its searches were given enough text. `held` reads what a searcher holds, and `Taker`
//! has a searcher judge each rule for a program.
//!
//! The Lean side decides each rule for the literal from the program (spec/lean/Stdx/Regex/
//! Rules.lean, RulesSeparator.lean and RulesInner.lean). A rule holds for every text or for
//! none, so a literal that fails there is a wrong choice for some text.
const std = @import("std");
const regex = @import("regex");
const platform = @import("platform");

/// The rule that a searcher took a literal by.
pub const Rule = enum {
    /// Claim R4's first rule, which a new searcher judges.
    first,
    /// Claim R4's second rule or its third, which a searcher judges after its searches were
    /// given enough text.
    wide,
    /// Claim R14's rule, which a searcher judges then too.
    inner,
    /// The window's rule (src/regex/dfa/dfa_window.zig), which a searcher judges then too.
    window,

    /// The word of a claim line for the rule.
    pub fn word(rule: Rule) []const u8 {
        return switch (rule) {
            .first => "suffix",
            .wide => "suffix-wide",
            .inner => "inner",
            .window => "window",
        };
    }

    /// The rule that a claim line's word names.
    pub fn of_word(named: []const u8) ?Rule {
        inline for (std.meta.fields(Rule)) |field| {
            const rule: Rule = @enumFromInt(field.value);
            if (std.mem.eql(u8, named, rule.word())) return rule;
        }
        return null;
    }
};

/// A literal that a searcher took, and the rule it took it by.
pub const Claim = struct {
    rule: Rule,
    /// The literal's bytes, in the text's order.
    literal: []const u8,
    /// The places that take a letter in either case: bit `i` for place `i` (`Literal.folds`).
    /// Such a place holds the lower-case letter.
    folds: u64 = 0,
    /// For claim R14 and the window, the instruction where the reverse program stands after the
    /// literal, from which it reads the part of a match before the literal. Zero for claim R4.
    before: u32 = 0,
    /// For the window, the most bytes of a match before the literal. Zero for the others.
    lead: u32 = 0,

    pub fn same(claim: Claim, other: Claim) bool {
        return claim.rule == other.rule and claim.before == other.before and claim.lead == other.lead and claim.folds == other.folds and std.mem.eql(u8, claim.literal, other.literal);
    }
};

/// The claim that a searcher holds, or null where it holds none.
pub fn held(searcher: *const regex.Searcher) ?Claim {
    if (searcher.suffix) |*literal| {
        return .{ .rule = if (searcher.suffix_wide) .wide else .first, .literal = literal.slice(), .folds = literal.folds };
    }
    if (searcher.inner) |*literal| {
        return .{ .rule = .inner, .literal = literal.slice(), .folds = literal.folds, .before = searcher.reverse.second_entry };
    }
    const window = &(searcher.forward.window orelse return null);
    return .{ .rule = .window, .literal = window.literal.slice(), .folds = window.literal.folds, .before = window.before, .lead = window.lead };
}

/// A searcher with its memory, which says what claim a searcher takes for a program.
pub const Taker = struct {
    memory: []u64,
    /// A text long enough that a searcher which read it has judged each rule that waits.
    judging_text: []u8,
    features: platform.CpuFeatures,
    searcher: regex.Searcher = undefined,

    /// A taker for programs of at most `instructions_max` instructions and `slots_max` capture
    /// slots. A searcher waits for `claim_text_per_instruction` bytes for each instruction of
    /// its reverse program (decision 86, the claims that wait).
    pub fn init(arena: std.mem.Allocator, instructions_max: u32, slots_max: u32) !Taker {
        const judging_text = try arena.alloc(u8, @as(usize, regex.constants.claim_text_per_instruction) * instructions_max);
        @memset(judging_text, 0);
        return .{
            .memory = try arena.alloc(u64, regex.Searcher.memory_len(instructions_max, slots_max, regex.constants.cache_words_default)),
            .judging_text = judging_text,
            .features = platform.CpuFeatures.detect(),
        };
    }

    /// The claim that a searcher takes for `program`. A new searcher has judged claim R4's
    /// first rule alone. Where it took no literal by it, the searcher reads the long text, and
    /// then holds the literal of a rule that waited. The literal holds until the next call.
    pub fn claim(taker: *Taker, program: *const regex.Program) ?Claim {
        const memory_len = regex.Searcher.memory_len(program.forward_len, program.slot_count(), regex.constants.cache_words_default);
        taker.searcher.init(program, &.{ .features = taker.features }, taker.memory[0..memory_len]);
        if (held(&taker.searcher)) |taken| return taken;
        _ = taker.searcher.is_match(taker.judging_text);
        return held(&taker.searcher);
    }
};

const testing = std.testing;
const test_instructions_max = 256;
const test_slots_max = 32;

fn expect_claim(taker: *Taker, storage: []regex.Instruction, pattern: []const u8, rule: Rule, literal: []const u8) !Claim {
    const program = try regex.compile(pattern, .{}, storage);
    const taken = taker.claim(&program) orelse return error.TestExpectedEqual;
    try testing.expectEqual(rule, taken.rule);
    try testing.expectEqualStrings(literal, taken.literal);
    return taken;
}

fn expect_none(taker: *Taker, storage: []regex.Instruction, pattern: []const u8) !void {
    const program = try regex.compile(pattern, .{}, storage);
    try testing.expect(taker.claim(&program) == null);
}

test "a taker names the literal that a searcher took for claim R4, and the rule" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    var taker = try Taker.init(arena.allocator(), test_instructions_max, test_slots_max);
    const storage = try arena.allocator().alloc(regex.Instruction, test_instructions_max);
    // No digit is the literal's first byte, so the first rule holds, and a new searcher took
    // the literal.
    const first = try expect_claim(&taker, storage, "[0-9]+ab", .first, "ab");
    try testing.expectEqual(@as(u32, 0), first.before);
    // No rule holds for `[a-c]+ab`: the part before takes `a`, takes more than one count of
    // bytes, and ends with no separator.
    try expect_none(&taker, storage, "[a-c]+ab");
    // The second rule: the part before takes one byte, which may be the literal's first.
    _ = try expect_claim(&taker, storage, "[a-z]shing", .wide, "shing");
    // The third rule: the part before ends with a space or more, and holds none before them.
    // The literal starts with the one space that every match holds before `Holmes`.
    _ = try expect_claim(&taker, storage, "[A-Za-z]+ +Holmes", .wide, " Holmes");
    // A literal whose places fold: bit `i` for place `i`.
    const folded = try expect_claim(&taker, storage, "[0-9]+(?i:ab)", .first, "ab");
    try testing.expectEqual(@as(u64, 0b11), folded.folds);
    const first_folds = try expect_claim(&taker, storage, "[0-9]+(?i:a)bc", .first, "abc");
    try testing.expectEqual(@as(u64, 0b001), first_folds.folds);
    try testing.expectEqual(@as(u64, 0), first.folds);
}

test "a taker names the literal that a searcher took for claim R14, and where the reverse program stands after it" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    var taker = try Taker.init(arena.allocator(), test_instructions_max, test_slots_max);
    const storage = try arena.allocator().alloc(regex.Instruction, test_instructions_max);
    // No letter is `@`, so claim R4's first rule holds for the part before it.
    const apart = try expect_claim(&taker, storage, "[a-z]+@[a-z]+", .inner, "@");
    // The reverse DFA's second entry is an instruction of the reverse program.
    const program = taker.searcher.matcher.program;
    try testing.expect(apart.before >= program.forward_len and apart.before < program.instructions.len);
    try testing.expectEqual(taker.searcher.reverse.second_entry, apart.before);
    // The second rule: the part before takes one byte, which may be the literal's first.
    _ = try expect_claim(&taker, storage, "[a-c]ab[a-c]+", .inner, "ab");
    // The third rule, past the literal's first run: the space is the separator.
    _ = try expect_claim(&taker, storage, "[a-c]+ +ab[a-c]+", .inner, " ab");
    // No rule holds for the part before `ab`, which takes `a` and more than one count of bytes.
    try expect_none(&taker, storage, "[a-c]+ab[a-c]+");
    // A literal with a place that folds. Its last byte folds in no case: the reverse program
    // takes that byte at one instruction, which every match passes.
    const folded = try expect_claim(&taker, storage, "[0-9]+(?i:a)b[0-9]+", .inner, "ab");
    try testing.expectEqual(@as(u64, 0b01), folded.folds);
    try testing.expectEqual(@as(u64, 0), apart.folds);
    // A new searcher holds no literal of claim R14: the claim waits.
    const waiting = try regex.compile("[a-z]+@[a-z]+", .{}, storage);
    taker.searcher.init(&waiting, &.{ .features = taker.features }, taker.memory);
    try testing.expect(held(&taker.searcher) == null);
}

test "a claim line's word names its rule" {
    inline for (std.meta.fields(Rule)) |field| {
        const rule: Rule = @enumFromInt(field.value);
        try testing.expectEqual(rule, Rule.of_word(rule.word()).?);
    }
    try testing.expect(Rule.of_word("prefix") == null);
    const claim: Claim = .{ .rule = .inner, .literal = "ab", .before = 7 };
    try testing.expect(claim.same(.{ .rule = .inner, .literal = "ab", .before = 7 }));
    try testing.expect(!claim.same(.{ .rule = .wide, .literal = "ab", .before = 7 }));
    try testing.expect(!claim.same(.{ .rule = .inner, .literal = "ab", .before = 8 }));
    try testing.expect(!claim.same(.{ .rule = .inner, .literal = "aa", .before = 7 }));
    try testing.expect(!claim.same(.{ .rule = .inner, .literal = "ab", .before = 7, .folds = 1 }));
    try testing.expect(!claim.same(.{ .rule = .inner, .literal = "ab", .before = 7, .lead = 3 }));
}

test "a taker names the literal and the bound of a window" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    var taker = try Taker.init(arena.allocator(), test_instructions_max, test_slots_max);
    const storage = try arena.allocator().alloc(regex.Instruction, test_instructions_max);
    // The part before `ab` may hold `a`, so no rule of claim R14 holds, and it takes three bytes
    // at most.
    const window = try expect_claim(&taker, storage, "[a-c]{0,3}ab[a-c]*", .window, "ab");
    try testing.expectEqual(@as(u32, 3), window.lead);
    const program = taker.searcher.matcher.program;
    try testing.expect(window.before >= program.forward_len and window.before < program.instructions.len);
    // No bound: no window.
    try expect_none(&taker, storage, "[a-c]*ab[a-c]*");
}
