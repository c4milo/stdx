//! The literal that every way of a pattern starts with, where the pattern has more than one way
//! to start (decision 86, claim R3).
//!
//! `Literal.walk` follows one instruction after another, so it stops at an alternation.
//! `(?m)^Sherlock Holmes|Sherlock Holmes$` has two ways to start, each with instructions of its
//! own, and both read `Sherlock Holmes`. This walk keeps the instructions that take a byte at
//! one place of the literal, one for each way: a level. The place holds the one byte that every
//! instruction of the level takes, or a letter in either case where they take its two cases.
//! The next level holds the instructions that those lead to. The walk stops at the first level
//! whose instructions take other bytes, at `match`, and at a level of more than
//! `literal_ways_max` instructions.
//!
//! The walk goes through assertions, which take no byte. The literal then stands where a match
//! starts, and the forward DFA judges each assertion at the literal's place (dfa_literal.zig).
//! A program with no assertion has claim R5's set of literals in this walk's place.
//!
//! spec/lean/Stdx/Regex/RulesPrefix.lean decides the same rule from a program, and proves that
//! the search from such a literal's places gives the matcher's answer.
//! tools/matcher_model_check.sh holds each literal that a searcher goes to by this walk to that
//! rule.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const Instruction = program_file.Instruction;
const literal_file = @import("literal.zig");
const Literal = literal_file.Literal;

/// The instructions of one level, in the order the walk met them.
const Level = struct {
    items: [constants.literal_ways_max]u32 = undefined,
    len: u8 = 0,

    /// Adds an instruction where the level lacks it. False where the level is full.
    fn add(level: *Level, index: u32) bool {
        assert(level.len <= constants.literal_ways_max);
        for (level.slice()) |item| {
            if (item == index) return true;
        }
        if (level.len == constants.literal_ways_max) return false;
        level.items[level.len] = index;
        level.len += 1;
        return true;
    }

    fn slice(level: *const Level) []const u32 {
        return level.items[0..level.len];
    }
};

/// One place of the literal: its byte, in the lower case where the place folds.
const Place = struct { octet: u8, fold: bool };

/// The instructions that the walk has yet to read at one level.
const Pending = struct {
    items: [constants.literal_ways_free_max]u32 = undefined,
    len: usize = 0,

    /// False where the walk holds as many instructions as it may.
    fn push(pending: *Pending, index: u32) bool {
        if (pending.len == pending.items.len) return false;
        pending.items[pending.len] = index;
        pending.len += 1;
        return true;
    }
};

/// The literal that every path from `entry` to `match` starts with, read through assertions, or
/// null where it is shorter than `literal_prefix_len_min`. The literal is not ready for a
/// search: its caller calls `prepare`.
pub fn of(instructions: []const Instruction, entry: u32) ?Literal {
    assert(entry < instructions.len);
    var literal: Literal = .{ .octets = undefined, .len = 0, .exact = false };
    var seeds: Level = .{};
    _ = seeds.add(entry);
    for (0..constants.literal_len_max) |_| {
        const takers = level_of(instructions, &seeds) orelse break;
        const place = place_of(instructions, &takers) orelse break;
        literal.push(place.octet, place.fold);
        seeds = .{};
        for (takers.slice()) |taker| {
            // A level's instructions lead to as many instructions as the level holds, at most.
            const added = seeds.add(instructions[taker].out);
            assert(added);
        }
    }
    if (literal.len < constants.literal_prefix_len_min) return null;
    assert(!literal.exact);
    return literal;
}

/// The instructions that take one byte each, which `seeds` lead to with no byte. Null where a
/// seed leads to `match`, to a class or to `fail`, and where the level or the walk holds more
/// instructions than it may.
fn level_of(instructions: []const Instruction, seeds: *const Level) ?Level {
    assert(seeds.len >= 1);
    var takers: Level = .{};
    var pending: Pending = .{};
    comptime assert(constants.literal_ways_max <= constants.literal_ways_free_max);
    for (seeds.slice()) |seed| {
        const pushed = pending.push(seed);
        assert(pushed);
    }
    // A turn reads one instruction. The count of turns bounds a loop of instructions that take
    // no byte, such as the one of `(?:a*)*`.
    for (0..constants.literal_ways_free_max) |_| {
        if (pending.len == 0) return takers;
        pending.len -= 1;
        if (!read(instructions, pending.items[pending.len], &pending, &takers)) return null;
    }
    return if (pending.len == 0) takers else null;
}

/// Reads the instruction at `index`: an instruction that takes no byte adds the instructions it
/// leads to, and one that takes one byte joins the level. False where the walk stops.
fn read(instructions: []const Instruction, index: u32, pending: *Pending, takers: *Level) bool {
    assert(index < instructions.len);
    const instruction = instructions[index];
    return switch (instruction.kind) {
        .save, .jump, .look => pending.push(instruction.out),
        // The preferred branch is read first. The order changes no literal.
        .split => pending.push(instruction.arg) and pending.push(instruction.out),
        .range => instruction.lo == instruction.hi and takers.add(index),
        .ranges, .match, .fail => false,
    };
}

/// The byte that every instruction of a level takes, or the lower case of a letter where each
/// takes one of its two cases. Null where the instructions take other bytes.
fn place_of(instructions: []const Instruction, takers: *const Level) ?Place {
    assert(takers.len >= 1);
    const first = instructions[takers.items[0]].lo;
    var fold = false;
    for (takers.slice()) |taker| {
        const octet = instructions[taker].lo;
        assert(instructions[taker].kind == .range and octet == instructions[taker].hi);
        if (octet == first) continue;
        if (octet ^ first != constants.case_bit) return null;
        fold = true;
    }
    return .{ .octet = if (fold) first | constants.case_bit else first, .fold = fold };
}

const testing = std.testing;
const compiler = @import("compile.zig");

/// The instructions a test's pattern takes at most, its forward and its reverse program.
const test_storage_len = 1024;

fn common_of(pattern: []const u8) !?Literal {
    var storage: [test_storage_len]Instruction = undefined;
    const program = try compiler.compile(pattern, .{}, &storage);
    return of(program.instructions, program.forward);
}

fn expect_common(pattern: []const u8, octets: []const u8, folds: literal_file.Folds) !void {
    const literal = (try common_of(pattern)) orelse return error.TestExpectedLiteral;
    try testing.expectEqualStrings(octets, literal.slice());
    try testing.expectEqual(folds, literal.folds);
    try testing.expect(!literal.exact);
}

test "of reads the literal that every way of a pattern starts with, through assertions" {
    // Two ways, each with an assertion: before the literal, and after it.
    try expect_common("(?m)^Sherlock Holmes|Sherlock Holmes$", "Sherlock Holmes", 0);
    try expect_common("\\bab|ab\\b", "ab", 0);
    // The ways part after the literal.
    try expect_common("\\babc|abd", "ab", 0);
    try expect_common("\\bab[0-9]|ab[a-z]+", "ab", 0);
    // Three ways, and a way that is a loop: the literal ends where one way may end.
    try expect_common("\\bab|abc|abd", "ab", 0);
    try expect_common("\\b(?:ab)+|ab$", "ab", 0);
    // A way's group saves take no byte.
    try expect_common("\\b(ab)c|(a)(b)d", "ab", 0);
}

test "of keeps a letter in either case where the ways take its two cases" {
    // One way takes either case, and the other the lower case: the place folds.
    try expect_common("\\b(?i:a)bc|abd", "ab", 0b01);
    try expect_common("\\b(?i:ab)|ab\\b", "ab", 0b11);
    // The two cases, one from each way.
    try expect_common("\\bAb|ab\\b", "ab", 0b01);
    // Two bytes that differ in more than the case stop the literal.
    try testing.expect((try common_of("\\bab|cb")) == null);
    try expect_common("\\bab1|ab2", "ab", 0);
}

test "of reads no literal where a way starts with another byte, a class or nothing" {
    try testing.expect((try common_of("\\bab|cd")) == null);
    try testing.expect((try common_of("\\b[ab]c|[ab]d")) == null);
    try testing.expect((try common_of("\\bab|")) == null);
    try testing.expect((try common_of("\\b(?:ab)*c")) == null);
    // One byte is claim R1's, not a literal's.
    try testing.expect((try common_of("\\bab|ac")) == null);
    // A loop of instructions that take no byte ends the walk.
    try testing.expect((try common_of("\\b(?:a*)*b")) == null);
}

test "of reads no literal past the ways that a level holds" {
    // Eight ways fill a level, and nine pass it.
    try expect_common("\\bab|ab|ab|ab|ab|ab|ab|ab", "ab", 0);
    try testing.expect((try common_of("\\bab|ab|ab|ab|ab|ab|ab|ab|ab")) == null);
    comptime assert(constants.literal_ways_max == 8);
}

test "of keeps the first bytes of a literal longer than a literal may be" {
    const long = "a" ** (constants.literal_len_max + 4);
    const literal = (try common_of("\\b" ++ long ++ "|" ++ long ++ "\\b")).?;
    try testing.expectEqual(@as(usize, constants.literal_len_max), literal.len);
}
