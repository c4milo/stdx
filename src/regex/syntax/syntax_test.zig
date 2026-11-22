//! The parser's refusals: each error of errors.zig, for each form of pattern that draws it.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const compiler = @import("../compile.zig");
const errors = @import("../errors.zig");
const Instruction = @import("../program.zig").Instruction;

const storage_len = 16384;

fn compile(pattern: []const u8) errors.Error!void {
    var storage: [storage_len]Instruction = undefined;
    _ = try compiler.compile(pattern, .{}, &storage);
}

fn expect_refused(expected: errors.Refused, patterns: []const []const u8) !void {
    for (patterns) |pattern| try testing.expectError(expected, compile(pattern));
}

fn expect_taken(patterns: []const []const u8) !void {
    for (patterns) |pattern| try compile(pattern);
}

test "a pattern that is not UTF-8 is refused" {
    try expect_refused(error.InvalidUtf8, &.{ "\xFF", "a\xC3", "a\xC3(", "\xED\xA0\x80", "[\x80]", "\\\xFF" });
}

test "a parenthesis with no partner is refused" {
    try expect_refused(error.UnmatchedParenthesis, &.{ ")", "a)", "(a))", "a|)" });
    try expect_refused(error.MissingParenthesis, &.{ "(", "(a", "(?:a", "((a)", "(?i", "(?", "(?i-", "(a|b" });
}

test "a class that neither RFC 9485 §3 nor RE2 holds is refused" {
    try expect_refused(error.MissingBracket, &.{ "[a", "[a-", "[^", "[", "[\\]", "[]", "[^]", "a[]b", "[[:alpha:]" });
    try expect_refused(error.InvalidClass, &.{ "[[]", "[[:letter:]]", "[a[]", "[[:alpha]]" });
    try expect_refused(error.InvalidClassRange, &.{ "[z-a]", "[a-\\d]", "[a--]", "[a-[:digit:]]" });
    try expect_taken(&.{ "[a-a]", "[\\[]", "[\\]]", "[-]", "[a-]", "[-a]", "[\\d-]", "[^-]", "[*+?.|(){}]" });
    try expect_taken(&.{ "[]]", "[]a]", "[^]a]", "[a-c-e]", "[--a]", "[\\d-z]", "[[:alpha:]]", "[[:^digit:][:space:]_]" });
}

test "a quantifier with no operand, or after a quantifier, is refused" {
    try expect_refused(error.MissingOperand, &.{ "*", "+a", "?", "{2}", "a|*", "(*)", "(?:+)", "(?i)*", "|?" });
    try expect_refused(error.NestedQuantifier, &.{ "a**", "a+*", "a{2}{3}", "a?+", "a*??", "a{2}*", "(a)+?+" });
    try expect_taken(&.{ "a*", "a*?", "(a*)*", "(?:a+)+", "^*", "\\b+", "$?", "(a)?", "[a]{2}", "\\d{2,}?" });
}

test "a brace that starts no range quantifier is refused" {
    try expect_refused(error.InvalidQuantifier, &.{ "a{", "a{}", "a{,2}", "a{2", "a{2,3", "a{3,2}", "a{x}", "a{2 }", "a{-1}", "a{2,x}", "a{2;3}" });
    try expect_taken(&.{ "a{0}", "a{1000}", "a{0,1000}", "a{1000,}", "a{007}", "a{1,1}" });
}

test "a count past repeat_max, alone or as a product, is refused" {
    try expect_refused(error.RepeatTooLarge, &.{ "a{1001}", "a{0,1001}", "a{1001,}", "a{2,1001}", "a{99999999999999999999}" });
    try expect_refused(error.RepeatTooLarge, &.{ "(a{10}){101}", "((a{10}){10}){11}", "(a{1000}){2}", "(a{2}){501}", "(?:a{0,500}){3,}" });
    try expect_taken(&.{ "(a{10}){100}", "((a{10}){10}){10}", "(a{1000})*", "(a{1000})+", "(a{500}){1,2}", "(a{1000}){0}" });
}

test "an escape that names nothing is refused" {
    try expect_refused(error.InvalidEscape, &.{ "\\", "a\\", "\\q", "\\Q", "\\E", "\\C", "\\Z", "\\G", "\\xg1", "\\x4", "\\x{}", "\\x{41", "[\\b]", "[\\A]", "\\\xC3\xA9", "\\ " });
    try expect_refused(error.InvalidScalarValue, &.{ "\\x{110000}", "\\x{D800}", "\\x{DFFF}", "[\\x{FFFFFF}]" });
    try expect_taken(&.{ "\\_", "\\-", "\\]", "\\}", "\\{", "\\|", "\\x00", "\\x{0}", "\\x{10FFFF}", "\\a\\f\\v\\n\\r\\t" });
    try expect_taken(&.{ "\\0", "\\060", "\\141", "\\01", "\\018", "\\608", "[\\101-\\132]", "\\x{00000061}" });
}

test "a group that starts with a question mark and names no form is refused" {
    try expect_refused(error.InvalidGroup, &.{ "(?x)", "(?i-)", "(?)", "(?-)", "(?i--s)", "(?-i-s)", "(?>a)", "(?#c)", "(?ix)", "(?i x)", "(?-:a)" });
    try expect_taken(&.{ "(?i)", "(?-i)", "(?imsU)", "(?i-s)", "(?i-s:a)", "(?-U:a)", "(?:)", "(?s:.)", "(?i)(?m)" });
}

test "a closing bracket or brace with nothing to close is refused" {
    try expect_refused(error.UnescapedCharacter, &.{ "]", "a}", "}", "a]b", "(])" });
}

test "the forms no program of this module holds are refused as unsupported" {
    try expect_refused(error.UnsupportedBackreference, &.{ "(a)\\1", "\\9", "[\\1]", "\\8", "\\1a", "(a)\\1$" });
    try expect_refused(error.UnsupportedLookaround, &.{ "(?=a)", "(?!a)", "(?<=a)", "(?<!a)" });
    try expect_refused(error.UnsupportedProperty, &.{ "\\pL", "\\p{Greek}", "\\PL", "[\\p{L}]" });
    try expect_refused(error.UnsupportedCaseFolding, &.{ "(?i)\xC3\xA9", "(?i)[\xC3\xA9]", "(?i:a\xE2\x82\xAC)", "(?i)\\x{e9}", "(?i)[a-\\x{ff}]" });
    try expect_taken(&.{ "(?i)a(?-i)\xC3\xA9", "(?i)[^a]", "(?i)\\W", "(?i).", "(?i)1", "(?i:a)\xE2\x82\xAC" });
}

test "a named group compiles as a group, and a name that breaks RE2's rules is refused" {
    try expect_taken(&.{ "(?P<n>a)", "(?<n>a)", "(?P<year>\\d{4})-(?<month>\\d{2})", "(?<a>x)(?<b>y)", "(?<_9>x)", "(?<n>(?<m>x))" });
    try expect_refused(error.InvalidGroupName, &.{ "(?P<>a)", "(?<>a)", "(?P<a-b>c)", "(?<a b>c)", "(?P<a", "(?<a", "(?P<\xC3\xA9>a)" });
    try expect_refused(error.DuplicateGroupName, &.{ "(?P<a>x)(?P<a>y)", "(?<a>x)|(?P<a>y)", "(?<n>(?<n>x))" });
    // `(?P=name)` matches what the named group matched.
    try expect_refused(error.UnsupportedBackreference, &.{"(?P=n)"});
    try expect_refused(error.InvalidGroup, &.{ "(?P>n)", "(?Pn)", "(?P" });
}

test "groups nest to depth_max and no deeper" {
    var pattern: [2 * (constants.depth_max + 1)]u8 = undefined;
    @memset(pattern[0 .. constants.depth_max + 1], '(');
    @memset(pattern[constants.depth_max + 1 ..], ')');
    try compile(pattern[1 .. pattern.len - 1]);
    try testing.expectError(error.DepthTooLarge, compile(&pattern));
    // The depth is the groups open at once, whatever their kind and whatever came before.
    try compile("()" ** (constants.depth_max + 1));
    var mixed: [3 * (constants.depth_max + 1)]u8 = undefined;
    for (0..constants.depth_max + 1) |index| @memcpy(mixed[3 * index ..][0..3], "(?:");
    try testing.expectError(error.DepthTooLarge, compile(&mixed));
    try testing.expectError(error.MissingParenthesis, compile(mixed[3..]));
}

test "a pattern holds groups_max capture groups and no more" {
    const explicit = constants.groups_max - 1;
    var pattern: [2 * (explicit + 1)]u8 = undefined;
    for (0..explicit + 1) |index| @memcpy(pattern[2 * index ..][0..2], "()");
    var storage: [4 * constants.groups_max]Instruction = undefined;
    const program = try compiler.compile(pattern[0 .. 2 * explicit], .{ .reverse = false }, &storage);
    try testing.expectEqual(@as(u32, constants.groups_max), program.group_count);
    try testing.expectError(error.GroupsTooMany, compiler.compile(&pattern, .{ .reverse = false }, &storage));
}

test "every refusal has its class" {
    try testing.expectEqual(codec.Refusal.corrupt, errors.refusal(error.NestedQuantifier));
    try testing.expectEqual(codec.Refusal.corrupt, errors.refusal(error.InvalidClass));
    try testing.expectEqual(codec.Refusal.unsupported, errors.refusal(error.DepthTooLarge));
    try testing.expectEqual(codec.Refusal.unsupported, errors.refusal(error.ClassTooLarge));
    try testing.expectEqual(codec.Refusal.unsupported, errors.refusal(error.GroupsTooMany));
    try testing.expectEqual(codec.Refusal.unsupported, errors.refusal(error.UnsupportedBackreference));
    try testing.expectEqual(codec.Refusal.unsupported, errors.refusal(error.UnsupportedCaseFolding));
    try testing.expectEqual(codec.Refusal.unsupported, errors.refusal(error.UnsupportedProperty));
}
