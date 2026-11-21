//! The patterns and the texts `zig build differential-regex` draws from a seed (decision 86).
//!
//! A pattern is an alternation of concatenations of pieces, nested to `depth_max`: literals,
//! classes, assertions, flags and groups, each form of the syntax decision 86 takes, some with a
//! quantifier. A text is a few characters of the same alphabet, all of it UTF-8.

const std = @import("std");
const Generator = @import("codec").testing.split.Generator;

/// The octets a generated pattern holds at most. A longer one is marked and left out.
pub const pattern_len_max = 2048;

/// The most characters a text holds, and the octets of the longest character of `text_pieces`.
const text_characters_max = 20;
const text_piece_len_max = 3;
pub const text_len_max = text_characters_max * text_piece_len_max;

/// The groups a pattern nests at most.
const depth_max = 3;

const literals = [_][]const u8{ "a", "b", "c", "a", "b", "A", "B", "1", "_", " ", "\xC3\xA9", "\xE6\x97\xA5", "-", "\\.", "\\n" };
const classes = [_][]const u8{
    ".",             "[ab]",                "[^a]",          "[a-c]",         "[^b-c1]",              "\\d",
    "\\w",           "\\s",                 "\\D",           "\\W",           "\\S",                  "[\\dab]",
    "[^\\w]",        "[\xC3\xA9-\xC3\xBC]", "[a\\-c]",       "[-a]",          "[a-]",                 "\\x61",
    "\\x{e9}",       "[[:alpha:]]",         "[[:^digit:]1]", "[^[:space:]a]", "[[:upper:][:punct:]]", "[[:word:]-]",
    "[[:xdigit:]_]", "[[:^alnum:]]",        "[]a]",          "[^]a]",         "[]-a]",                "[a-b-c]",
    "[\\d-b]",       "[+--]",               "[a-c-]",        "\\141",         "\\0",                  "\\60",
    "[\\101-\\103]", "\\x{0000061}",
};
const assertions = [_][]const u8{ "^", "$", "\\b", "\\B", "\\A", "\\z" };
const flags = [_][]const u8{ "(?i)", "(?s)", "(?m)", "(?U)", "(?i-s)", "(?ms)", "(?-i)" };
const quantifiers = [_][]const u8{ "*", "+", "?", "*?", "+?", "??", "{2}", "{0,2}", "{1,3}", "{2,}", "{1,2}?", "{0}", "{3,}?" };
const text_pieces = [_][]const u8{ "a", "b", "c", "a", "b", "A", "B", "1", "_", " ", "\n", "\xC3\xA9", "\xE6\x97\xA5", "-", "." };

/// How many pieces a concatenation holds, alternatives an alternation, and characters a text: one
/// entry is drawn, so a count that stands twice comes twice as often.
const piece_counts = [_]usize{ 0, 1, 1, 2, 2, 3, 4 };
const alternative_counts = [_]usize{ 1, 1, 1, 2, 2, 3 };
const text_counts = [_]usize{ 0, 1, 2, 3, 4, 5, 6, 8, 12, text_characters_max };

/// Out of a hundred draws: an atom is a literal below the first, a class below the second, an
/// assertion below the third, a flag below the fourth, and a group from there on. A piece that
/// may take a quantifier takes one below `quantifier_percent`.
const percent = 100;
const literal_percent = 40;
const class_percent = 58;
const assertion_percent = 66;
const flag_percent = 70;
const quantifier_percent = 35;

/// Out of ten groups: six capture, three do not, and one sets `(?i:`.
const group_kinds = 10;
const capture_kinds = 6;
const non_capture_kinds = 9;

/// One pattern as it grows.
pub const Buffer = struct {
    octets: [pattern_len_max]u8 = undefined,
    len: usize = 0,
    /// True when the pattern passed `pattern_len_max`, and is not whole.
    overflowed: bool = false,

    fn append(buffer: *Buffer, text: []const u8) void {
        if (text.len > pattern_len_max - buffer.len) {
            buffer.overflowed = true;
            return;
        }
        @memcpy(buffer.octets[buffer.len..][0..text.len], text);
        buffer.len += text.len;
    }

    pub fn slice(buffer: *const Buffer) []const u8 {
        return buffer.octets[0..buffer.len];
    }
};

/// One case: a pattern and a text.
pub const Case = struct {
    pattern: Buffer = .{},
    text: [text_len_max]u8 = undefined,
    text_len: usize = 0,

    /// True when the pattern did not fit, and the case holds no whole pattern.
    pub fn overflowed(case: *const Case) bool {
        return case.pattern.overflowed;
    }

    fn write(case: *Case, text: []const u8) void {
        case.pattern.append(text);
    }

    fn pick(case: *Case, generator: *Generator, comptime list: []const []const u8) void {
        case.write(list[generator.below(list.len)]);
    }
};

/// What a quantifier may follow.
const Atom = enum {
    /// A character, an assertion or a group: a quantifier may follow.
    operand,
    /// `(?i)` and its like, and `(?i:...)`: the generator gives these no quantifier.
    flagged,
};

fn group(case: *Case, generator: *Generator, depth: usize) Atom {
    const kind = generator.below(group_kinds);
    case.write(if (kind < capture_kinds) "(" else if (kind < non_capture_kinds) "(?:" else "(?i:");
    alternation(case, generator, depth - 1);
    case.write(")");
    return if (kind < non_capture_kinds) .operand else .flagged;
}

fn atom(case: *Case, generator: *Generator, depth: usize) Atom {
    const roll = generator.below(percent);
    if (roll < literal_percent or (roll >= flag_percent and depth == 0)) {
        case.pick(generator, &literals);
    } else if (roll < class_percent) {
        case.pick(generator, &classes);
    } else if (roll < assertion_percent) {
        case.pick(generator, &assertions);
    } else if (roll < flag_percent) {
        case.pick(generator, &flags);
        return .flagged;
    } else {
        return group(case, generator, depth);
    }
    return .operand;
}

fn concatenation(case: *Case, generator: *Generator, depth: usize) void {
    for (0..piece_counts[generator.below(piece_counts.len)]) |_| {
        const quantified = atom(case, generator, depth) == .operand and generator.below(percent) < quantifier_percent;
        if (quantified) case.pick(generator, &quantifiers);
    }
}

fn alternation(case: *Case, generator: *Generator, depth: usize) void {
    for (0..alternative_counts[generator.below(alternative_counts.len)]) |index| {
        if (index > 0) case.write("|");
        concatenation(case, generator, depth);
    }
}

/// Draws the next case of a seed's sequence.
pub fn next(generator: *Generator, case: *Case) void {
    case.* = .{};
    alternation(case, generator, depth_max);
    for (0..text_counts[generator.below(text_counts.len)]) |_| {
        const piece = text_pieces[generator.below(text_pieces.len)];
        @memcpy(case.text[case.text_len..][0..piece.len], piece);
        case.text_len += piece.len;
    }
}

const testing = std.testing;

test "a seed gives the same cases each time, and another seed gives others" {
    var first = Generator.init(1);
    var again = Generator.init(1);
    var other = Generator.init(2);
    var a: Case = .{};
    var b: Case = .{};
    var c: Case = .{};
    var differ: usize = 0;
    for (0..64) |_| {
        next(&first, &a);
        next(&again, &b);
        next(&other, &c);
        try testing.expectEqualStrings(a.pattern.slice(), b.pattern.slice());
        try testing.expectEqualStrings(a.text[0..a.text_len], b.text[0..b.text_len]);
        if (!std.mem.eql(u8, a.pattern.slice(), c.pattern.slice())) differ += 1;
    }
    try testing.expect(differ > 32);
}

test "a case holds a pattern of the syntax's forms and a text of UTF-8" {
    var generator = Generator.init(7);
    var case: Case = .{};
    var alternations: usize = 0;
    var groups: usize = 0;
    for (0..256) |_| {
        next(&generator, &case);
        try testing.expect(!case.overflowed());
        if (std.mem.indexOfScalar(u8, case.pattern.slice(), '|') != null) alternations += 1;
        if (std.mem.indexOfScalar(u8, case.pattern.slice(), '(') != null) groups += 1;
        try testing.expect(std.unicode.utf8ValidateSlice(case.text[0..case.text_len]));
        try testing.expect(case.text_len <= text_len_max);
    }
    try testing.expect(alternations > 32);
    try testing.expect(groups > 32);
}

/// Marks each entry of a list that a pattern holds.
fn mark(comptime list: []const []const u8, seen: *[list.len]bool, pattern: []const u8) void {
    for (list, seen) |entry, *was| {
        if (std.mem.indexOf(u8, pattern, entry) != null) was.* = true;
    }
}

test "the cases of a seed hold every literal, class, assertion, flag and quantifier" {
    var generator = Generator.init(11);
    var case: Case = .{};
    var seen_literals: [literals.len]bool = @splat(false);
    var seen_classes: [classes.len]bool = @splat(false);
    var seen_assertions: [assertions.len]bool = @splat(false);
    var seen_flags: [flags.len]bool = @splat(false);
    var seen_quantifiers: [quantifiers.len]bool = @splat(false);
    for (0..4096) |_| {
        next(&generator, &case);
        mark(&literals, &seen_literals, case.pattern.slice());
        mark(&classes, &seen_classes, case.pattern.slice());
        mark(&assertions, &seen_assertions, case.pattern.slice());
        mark(&flags, &seen_flags, case.pattern.slice());
        mark(&quantifiers, &seen_quantifiers, case.pattern.slice());
    }
    // A space, a line feed's escape and a character of three octets stand in no other list.
    for (seen_literals ++ seen_classes ++ seen_assertions ++ seen_flags ++ seen_quantifiers) |was| try testing.expect(was);
}

test "a pattern past the buffer is marked and holds no octet past it" {
    var buffer: Buffer = .{};
    for (0..pattern_len_max / "(?:)".len) |_| buffer.append("(?:)");
    try testing.expect(!buffer.overflowed);
    try testing.expectEqual(pattern_len_max, buffer.len);
    buffer.append("a");
    try testing.expect(buffer.overflowed);
    try testing.expectEqual(pattern_len_max, buffer.len);
}
