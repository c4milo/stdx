//! A reader of RE2's test logs, for `zig build differential-regex` (decision 86).
//!
//! RE2's `make log` writes what RE2 answers on its search tests and its exhaustive tests. Go's
//! tree keeps both logs, and its `regexp/exec_test.go` says how a log reads:
//!
//! - A line `strings` starts a list of texts, one a line, each quoted as Go quotes a string.
//! - A line `regexps` starts a list of patterns. A quoted line is a pattern, and the lines after
//!   it are RE2's answers, one for each text of the list, in order.
//! - An answer holds four results with `;` between them: the match of the whole text and the
//!   match anywhere in it, each leftmost-first, then the same two leftmost-longest.
//! - A result is `-` for no match, or each group's `start-end` with a space between, and `-` for
//!   a group that took no part.
//! - A `#` starts a comment, and any other line names a group of tests.

const std = @import("std");
const Answer = @import("regex_answer.zig").Answer;
const groups_max = @import("regex_answer.zig").groups_max;

pub const Error = error{ InvalidLog, OutOfMemory };

/// The results of one answer.
const results_per_answer = 4;

/// The digits of each escape of a quoted string, and the bases they are written in.
const hex_escape_digits = 2;
const short_unicode_digits = 4;
const long_unicode_digits = 8;
const octal_escape_digits = 3;
const hex_base = 16;
const octal_base = 8;
const decimal_base = 10;

/// One pattern over one text, with RE2's two leftmost-first results as the log spells them.
pub const Case = struct {
    pattern: []const u8,
    text: []const u8,
    /// The match of the whole text: the pattern between `\A(?:` and `)\z`.
    whole: []const u8,
    /// The match anywhere in the text.
    anywhere: []const u8,
    /// True for the first text of a pattern: a caller compiles the pattern then.
    first_of_pattern: bool,
};

pub const Reader = struct {
    /// Holds the texts of the list in progress and the pattern in progress.
    arena: std.heap.ArenaAllocator,
    lines: std.mem.SplitIterator(u8, .scalar),
    texts: std.ArrayList([]const u8) = .empty,
    pattern: ?[]const u8 = null,
    /// The text the next answer is for.
    index: usize = 0,
    in_texts: bool = false,

    pub fn init(allocator: std.mem.Allocator, log: []const u8) Reader {
        return .{ .arena = .init(allocator), .lines = std.mem.splitScalar(u8, log, '\n') };
    }

    pub fn deinit(reader: *Reader) void {
        reader.arena.deinit();
    }

    /// The next case, or null at the log's end.
    pub fn next(reader: *Reader) Error!?Case {
        while (reader.lines.next()) |line| {
            if (try reader.take_line(line)) |case| return case;
        }
        return null;
    }

    fn take_line(reader: *Reader, line: []const u8) Error!?Case {
        if (line.len == 0 or line[0] == '#') return null;
        if (std.mem.eql(u8, line, "strings")) return reader.start_texts();
        if (std.mem.eql(u8, line, "regexps")) {
            reader.in_texts = false;
            return null;
        }
        if (line[0] == '"') return reader.take_quoted(line);
        if (reader.pattern != null and (line[0] == '-' or std.ascii.isDigit(line[0]))) return try reader.take_answer(line);
        // The name of a group of tests, such as `Regexp.SearchTests`.
        reader.pattern = null;
        return null;
    }

    fn start_texts(reader: *Reader) ?Case {
        _ = reader.arena.reset(.retain_capacity);
        reader.texts = .empty;
        reader.pattern = null;
        reader.in_texts = true;
        return null;
    }

    fn take_quoted(reader: *Reader, line: []const u8) Error!?Case {
        const allocator = reader.arena.allocator();
        const octets = try unquote(allocator, line);
        if (reader.in_texts) {
            try reader.texts.append(allocator, octets);
        } else {
            reader.pattern = octets;
            reader.index = 0;
        }
        return null;
    }

    fn take_answer(reader: *Reader, line: []const u8) Error!Case {
        if (reader.index >= reader.texts.items.len) return error.InvalidLog;
        var results: [results_per_answer][]const u8 = undefined;
        var fields = std.mem.splitScalar(u8, line, ';');
        for (&results) |*result| result.* = fields.next() orelse return error.InvalidLog;
        if (fields.next() != null) return error.InvalidLog;
        defer reader.index += 1;
        return .{
            .pattern = reader.pattern.?,
            .text = reader.texts.items[reader.index],
            .whole = results[0],
            .anywhere = results[1],
            .first_of_pattern = reader.index == 0,
        };
    }
};

/// RE2's result as an answer: no match, or the groups of a match.
pub fn parse_result(result: []const u8) Error!Answer {
    if (std.mem.eql(u8, result, "-")) return .{ .kind = .none };
    var answer: Answer = .{ .kind = .match };
    var groups = std.mem.splitScalar(u8, result, ' ');
    while (groups.next()) |group| : (answer.groups += 1) {
        if (answer.groups == groups_max) return error.InvalidLog;
        const offsets = try parse_group(group);
        answer.offsets[2 * answer.groups] = offsets[0];
        answer.offsets[2 * answer.groups + 1] = offsets[1];
    }
    return answer;
}

fn parse_group(group: []const u8) Error![2]i64 {
    if (std.mem.eql(u8, group, "-")) return .{ -1, -1 };
    const dash = std.mem.indexOfScalar(u8, group, '-') orelse return error.InvalidLog;
    const start = std.fmt.parseInt(i64, group[0..dash], decimal_base) catch return error.InvalidLog;
    const end = std.fmt.parseInt(i64, group[dash + 1 ..], decimal_base) catch return error.InvalidLog;
    return .{ start, end };
}

/// The octets of a string as Go's `strconv.Quote` writes it, quotation marks included.
fn unquote(allocator: std.mem.Allocator, quoted: []const u8) Error![]const u8 {
    if (quoted.len < 2 or quoted[0] != '"' or quoted[quoted.len - 1] != '"') return error.InvalidLog;
    var rest = quoted[1 .. quoted.len - 1];
    var out: std.ArrayList(u8) = .empty;
    try out.ensureTotalCapacity(allocator, rest.len);
    while (rest.len > 0) {
        if (rest[0] != '\\') {
            out.appendAssumeCapacity(rest[0]);
            rest = rest[1..];
            continue;
        }
        if (rest.len < 2) return error.InvalidLog;
        rest = try unescape(&out, rest[1..]);
    }
    return out.items;
}

/// Writes the octets of one escape, whose letter starts `rest`, and gives what follows it. No
/// escape writes more octets than it takes, so the room of the quoted text holds them.
fn unescape(out: *std.ArrayList(u8), rest: []const u8) Error![]const u8 {
    const simple: ?u8 = switch (rest[0]) {
        'a' => 0x07,
        'b' => 0x08,
        'f' => 0x0C,
        'n' => '\n',
        'r' => '\r',
        't' => '\t',
        'v' => 0x0B,
        '\\', '"', '\'' => rest[0],
        else => null,
    };
    if (simple) |octet| {
        out.appendAssumeCapacity(octet);
        return rest[1..];
    }
    return switch (rest[0]) {
        'x' => numbered(out, rest[1..], hex_escape_digits, hex_base, .octet),
        'u' => numbered(out, rest[1..], short_unicode_digits, hex_base, .character),
        'U' => numbered(out, rest[1..], long_unicode_digits, hex_base, .character),
        '0'...'7' => numbered(out, rest, octal_escape_digits, octal_base, .octet),
        else => error.InvalidLog,
    };
}

/// An escape that holds a number of `digits` digits: one octet, or one character as UTF-8.
fn numbered(out: *std.ArrayList(u8), rest: []const u8, digits: usize, base: u8, what: enum { octet, character }) Error![]const u8 {
    if (rest.len < digits) return error.InvalidLog;
    const value = std.fmt.parseInt(u21, rest[0..digits], base) catch return error.InvalidLog;
    switch (what) {
        .octet => out.appendAssumeCapacity(std.math.cast(u8, value) orelse return error.InvalidLog),
        .character => {
            var octets: [4]u8 = undefined;
            const len = std.unicode.utf8Encode(value, &octets) catch return error.InvalidLog;
            out.appendSliceAssumeCapacity(octets[0..len]);
        },
    }
    return rest[digits..];
}

const testing = std.testing;

test "unquote reads each escape Go's strconv.Quote writes" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    try testing.expectEqualStrings("", try unquote(allocator, "\"\""));
    try testing.expectEqualStrings("a\\b\"c", try unquote(allocator, "\"a\\\\b\\\"c\""));
    try testing.expectEqualStrings("\x07\x08\x0C\n\r\t\x0B'", try unquote(allocator, "\"\\a\\b\\f\\n\\r\\t\\v\\'\""));
    try testing.expectEqualStrings("\xFF\x00z", try unquote(allocator, "\"\\xff\\x00z\""));
    try testing.expectEqualStrings("\xC3\xA9\xF0\x9F\x98\x80", try unquote(allocator, "\"\\u00e9\\U0001f600\""));
    try testing.expectEqualStrings("A\x00", try unquote(allocator, "\"\\101\\000\""));
    try testing.expectError(error.InvalidLog, unquote(allocator, "\"a"));
    try testing.expectError(error.InvalidLog, unquote(allocator, "a\""));
    try testing.expectError(error.InvalidLog, unquote(allocator, "\"\\q\""));
    try testing.expectError(error.InvalidLog, unquote(allocator, "\"\\x1\""));
    try testing.expectError(error.InvalidLog, unquote(allocator, "\"\\\""));
}

test "parse_result reads no match, and the groups of a match with one that took no part" {
    try testing.expectEqual(Answer.Kind.none, (try parse_result("-")).kind);
    const found = try parse_result("0-12 - 3-4");
    try testing.expectEqual(Answer.Kind.match, found.kind);
    try testing.expectEqualSlices(i64, &.{ 0, 12, -1, -1, 3, 4 }, found.offsets[0 .. 2 * found.groups]);
    try testing.expectError(error.InvalidLog, parse_result("0"));
    try testing.expectError(error.InvalidLog, parse_result("a-1"));
    try testing.expectError(error.InvalidLog, parse_result(""));
}

const sample_log =
    \\# RE2 basic search tests built by make log
    \\Regexp.SearchTests
    \\strings
    \\""
    \\"zy\x00a"
    \\regexps
    \\"a"
    \\-;-;-;-
    \\-;3-4;-;3-4
    \\"^(?:a)$"
    \\-;-;-;-
    \\-;-;-;-
    \\strings
    \\"b"
    \\regexps
    \\"(b)|c"
    \\0-1 0-1;0-1 0-1;0-1 0-1;0-1 0-1
;

test "Reader gives each pattern over each text of its list, with RE2's two leftmost-first results" {
    var reader = Reader.init(testing.allocator, sample_log);
    defer reader.deinit();
    const expected = [_]struct { []const u8, []const u8, []const u8, []const u8, bool }{
        .{ "a", "", "-", "-", true },
        .{ "a", "zy\x00a", "-", "3-4", false },
        .{ "^(?:a)$", "", "-", "-", true },
        .{ "^(?:a)$", "zy\x00a", "-", "-", false },
        .{ "(b)|c", "b", "0-1 0-1", "0-1 0-1", true },
    };
    for (expected) |want| {
        const case = (try reader.next()).?;
        try testing.expectEqualStrings(want[0], case.pattern);
        try testing.expectEqualStrings(want[1], case.text);
        try testing.expectEqualStrings(want[2], case.whole);
        try testing.expectEqualStrings(want[3], case.anywhere);
        try testing.expectEqual(want[4], case.first_of_pattern);
    }
    try testing.expectEqual(@as(?Case, null), try reader.next());
}

test "Reader refuses an answer with no text left, and one that holds no four results" {
    var extra = Reader.init(testing.allocator, "strings\n\"a\"\nregexps\n\"a\"\n-;-;-;-\n-;-;-;-\n");
    defer extra.deinit();
    _ = (try extra.next()).?;
    try testing.expectError(error.InvalidLog, extra.next());
    var short = Reader.init(testing.allocator, "strings\n\"a\"\nregexps\n\"a\"\n-;-;-\n");
    defer short.deinit();
    try testing.expectError(error.InvalidLog, short.next());
}
