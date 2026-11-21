//! The verdict entries of `zig build differential-regex` (decisions 15 and 86): every case where
//! stdx and an oracle do not give a pattern and a text the same answer, with the reason and the
//! decision behind stdx's choice. A difference that no entry matches fails the check, and adding
//! an entry is a change to a check, so it carries its mutation results.
//!
//! An entry matches a difference by its oracle and by `holds`, which reads the facts the check
//! gathered about the case. `shape` says in prose what `holds` checks.

const std = @import("std");

/// The oracles of the check: Go's regexp over generated cases, and RE2 through its two test logs.
pub const Oracle = enum { go, re2 };

/// What the check knows about a case whose answers differ.
pub const Facts = struct {
    oracle: Oracle,
    pattern: []const u8,
    text: []const u8,
    /// The name of stdx's error when it refused the pattern, or nothing when it compiled.
    stdx_error: []const u8 = "",
    /// Whether the oracle refused the pattern.
    oracle_refused: bool = false,
    /// The start and the end of the oracle's whole match, when it found one.
    oracle_match: ?[2]usize = null,
    /// RE2's logs alone: whether Go's regexp gives the pattern and the text the answer stdx
    /// gives.
    go_agrees_with_stdx: bool = false,
};

pub const Entry = struct {
    oracle: Oracle,
    shape: []const u8,
    /// Whether a case has the shape.
    holds: *const fn (facts: Facts) bool,
    reason: []const u8,
    decision: []const u8,
};

pub const entries = [_]Entry{
    .{
        .oracle = .go,
        .shape = "stdx refuses `(?i)` over a scalar value past U+007F, written as UTF-8 or as an " ++
            "escape, which Go's regexp folds",
        .holds = folds_past_ascii,
        .reason = "RFC 9485 §3 gives a regexp no case-insensitive form. `(?i)` is RE2's.",
        .decision = "86: stdx folds the ASCII letters alone until design §8 step 22 adds Unicode's tables",
    },
    .{
        .oracle = .re2,
        .shape = "stdx refuses `\\C`, one octet of any value",
        .holds = holds_any_octet,
        .reason = "RFC 9485 §3 holds no `\\C`. It takes an octet that is no character.",
        .decision = "86: no match cuts a scalar value in two, so `\\C` stays refused",
    },
    .{
        .oracle = .re2,
        .shape = "stdx refuses `\\p` or `\\P`, a Unicode property",
        .holds = holds_property,
        .reason = "RFC 9485 §3 requires `\\p{...}`, which needs Unicode's tables.",
        .decision = "86: the tables are design §8 step 22's part 22e",
    },
    .{
        .oracle = .re2,
        .shape = "RE2's match starts or ends between the octets of one scalar value, and Go's " ++
            "regexp gives stdx's answer",
        .holds = oracle_cuts_a_character,
        .reason = "RE2 judges `\\B` at every octet. Go's regexp judges it between characters " ++
            "alone, and Go's tests leave these cases out.",
        .decision = "86: no match starts before a continuation octet",
    },
};

/// The octets from 0x80 to 0xBF continue a character of UTF-8 (RFC 3629 §3).
const continuation_min = 0x80;
const continuation_max = 0xBF;

fn is_continuation(octet: u8) bool {
    return octet >= continuation_min and octet <= continuation_max;
}

/// True when the pattern may name a scalar value past U+007F: by its UTF-8, by a `\x` escape, or
/// by an octal escape, a reverse solidus before a digit.
fn names_past_ascii(pattern: []const u8) bool {
    for (pattern, 0..) |octet, index| {
        if (octet >= continuation_min) return true;
        if (octet != '\\' or index + 1 == pattern.len) continue;
        if (pattern[index + 1] == 'x' or std.ascii.isDigit(pattern[index + 1])) return true;
    }
    return false;
}

/// True when the pattern sets the flag `i` in a `(?` group: an `i` between the `(?` and the `)`
/// or the `:` that ends the flags.
fn sets_case_flag(pattern: []const u8) bool {
    var rest = pattern;
    while (std.mem.indexOf(u8, rest, "(?")) |start| {
        rest = rest[start + 2 ..];
        const end = std.mem.indexOfAny(u8, rest, "):") orelse rest.len;
        const clear = std.mem.indexOfScalar(u8, rest[0..end], '-') orelse end;
        if (std.mem.indexOfScalar(u8, rest[0..clear], 'i') != null) return true;
    }
    return false;
}

fn folds_past_ascii(facts: Facts) bool {
    if (!std.mem.eql(u8, facts.stdx_error, "UnsupportedCaseFolding") or facts.oracle_refused) return false;
    return sets_case_flag(facts.pattern) and names_past_ascii(facts.pattern);
}

fn holds_any_octet(facts: Facts) bool {
    return std.mem.eql(u8, facts.stdx_error, "InvalidEscape") and std.mem.indexOf(u8, facts.pattern, "\\C") != null;
}

fn holds_property(facts: Facts) bool {
    if (!std.mem.eql(u8, facts.stdx_error, "UnsupportedProperty")) return false;
    return std.mem.indexOf(u8, facts.pattern, "\\p") != null or std.mem.indexOf(u8, facts.pattern, "\\P") != null;
}

fn oracle_cuts_a_character(facts: Facts) bool {
    const match = facts.oracle_match orelse return false;
    if (facts.stdx_error.len != 0 or !facts.go_agrees_with_stdx) return false;
    for (match) |offset| {
        if (offset < facts.text.len and is_continuation(facts.text[offset])) return true;
    }
    return false;
}

/// The index of the entry that allows a difference, or null when none does.
pub fn find(facts: Facts) ?usize {
    for (entries, 0..) |entry, index| {
        if (entry.oracle == facts.oracle and entry.holds(facts)) return index;
    }
    return null;
}

const testing = std.testing;

fn expect_entry(shape_start: []const u8, facts: Facts) !void {
    const index = find(facts) orelse return error.TestExpectedAnEntry;
    try testing.expect(std.mem.startsWith(u8, entries[index].shape, shape_start));
    try testing.expectEqual(facts.oracle, entries[index].oracle);
}

test "a refusal of (?i) past ASCII is allowed only where the pattern sets the flag over such a value" {
    try expect_entry("stdx refuses `(?i)`", .{ .oracle = .go, .pattern = "(?i)\xC3\xA9", .text = "", .stdx_error = "UnsupportedCaseFolding" });
    try expect_entry("stdx refuses `(?i)`", .{ .oracle = .go, .pattern = "a(?s-m:(?i:\xC3\xA9))", .text = "", .stdx_error = "UnsupportedCaseFolding" });
    // RE2's logs hold no such pattern, so no entry allows one there.
    try testing.expectEqual(@as(?usize, null), find(.{ .oracle = .re2, .pattern = "(?i)\xC3\xA9", .text = "", .stdx_error = "UnsupportedCaseFolding" }));
    try expect_entry("stdx refuses `(?i)`", .{ .oracle = .go, .pattern = "(?si-m)\xC3\xA9", .text = "", .stdx_error = "UnsupportedCaseFolding" });
    try expect_entry("stdx refuses `(?i)`", .{ .oracle = .go, .pattern = "(?i)\\x{e9}", .text = "", .stdx_error = "UnsupportedCaseFolding" });
    try expect_entry("stdx refuses `(?i)`", .{ .oracle = .go, .pattern = "(?i:\\601)", .text = "", .stdx_error = "UnsupportedCaseFolding" });
    // Another error, no flag, a cleared flag alone, no value past ASCII, and a pattern the oracle
    // refuses too.
    try testing.expectEqual(@as(?usize, null), find(.{ .oracle = .go, .pattern = "(?i)\xC3\xA9", .text = "", .stdx_error = "InvalidEscape" }));
    try testing.expectEqual(@as(?usize, null), find(.{ .oracle = .go, .pattern = "i\xC3\xA9", .text = "", .stdx_error = "UnsupportedCaseFolding" }));
    try testing.expectEqual(@as(?usize, null), find(.{ .oracle = .go, .pattern = "(?-i)\xC3\xA9", .text = "", .stdx_error = "UnsupportedCaseFolding" }));
    try testing.expectEqual(@as(?usize, null), find(.{ .oracle = .go, .pattern = "(?i)e", .text = "", .stdx_error = "UnsupportedCaseFolding" }));
    try testing.expectEqual(@as(?usize, null), find(.{ .oracle = .go, .pattern = "(?i)\xC3\xA9", .text = "", .stdx_error = "UnsupportedCaseFolding", .oracle_refused = true }));
}

test "a difference of two matches has no entry for Go's regexp" {
    try testing.expectEqual(@as(?usize, null), find(.{ .oracle = .go, .pattern = "A(?i)b|a", .text = "a" }));
    try testing.expectEqual(@as(?usize, null), find(.{ .oracle = .go, .pattern = "\\B", .text = "\xC3\xA9", .oracle_match = .{ 1, 1 }, .go_agrees_with_stdx = true }));
}

test "a refusal of \\C or of a property is allowed for RE2's logs, by its error and its pattern" {
    try expect_entry("stdx refuses `\\C`", .{ .oracle = .re2, .pattern = "a\\C*", .text = "", .stdx_error = "InvalidEscape" });
    try expect_entry("stdx refuses `\\p`", .{ .oracle = .re2, .pattern = "\\pN+", .text = "", .stdx_error = "UnsupportedProperty" });
    try expect_entry("stdx refuses `\\p`", .{ .oracle = .re2, .pattern = "\\P{Lu}", .text = "", .stdx_error = "UnsupportedProperty" });
    try testing.expectEqual(@as(?usize, null), find(.{ .oracle = .re2, .pattern = "a\\Q", .text = "", .stdx_error = "InvalidEscape" }));
    try testing.expectEqual(@as(?usize, null), find(.{ .oracle = .re2, .pattern = "a\\C*", .text = "", .stdx_error = "MissingOperand" }));
    try testing.expectEqual(@as(?usize, null), find(.{ .oracle = .go, .pattern = "a\\C*", .text = "", .stdx_error = "InvalidEscape" }));
    try testing.expectEqual(@as(?usize, null), find(.{ .oracle = .re2, .pattern = "p", .text = "", .stdx_error = "UnsupportedProperty" }));
}

test "RE2's match inside a character is allowed only where Go gives stdx's answer" {
    const inside: Facts = .{ .oracle = .re2, .pattern = "\\B", .text = "\xC3\xA9", .oracle_match = .{ 1, 1 }, .go_agrees_with_stdx = true };
    try expect_entry("RE2's match starts or ends between", inside);
    var end_inside = inside;
    end_inside.oracle_match = .{ 0, 1 };
    try expect_entry("RE2's match starts or ends between", end_inside);
    var go_differs = inside;
    go_differs.go_agrees_with_stdx = false;
    try testing.expectEqual(@as(?usize, null), find(go_differs));
    var between = inside;
    between.oracle_match = .{ 2, 2 };
    try testing.expectEqual(@as(?usize, null), find(between));
    var at_start = inside;
    at_start.oracle_match = .{ 0, 0 };
    try testing.expectEqual(@as(?usize, null), find(at_start));
    var no_match = inside;
    no_match.oracle_match = null;
    try testing.expectEqual(@as(?usize, null), find(no_match));
}
