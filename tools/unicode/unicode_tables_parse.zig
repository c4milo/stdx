//! unicode_tables_parse: the data lines of the Unicode Character Database's files, and the sets of
//! code points they give, for tools/unicode/unicode_tables.zig.
//!
//! A data line holds fields that semicolons separate, and spaces around a field do not count (UAX
//! #44 §4.2.1). The first field of a line of code points is one code point, four to six hexadecimal
//! digits, or a range "X..Y" (UAX #44 §4.2.2 and §4.2.3). A `#` starts a comment, which runs to the
//! end of the line (UAX #44 §4.2.4). The first line of each file names the file and its version, as
//! `# Scripts-17.0.0.txt`.

const std = @import("std");

/// The version of the Unicode Character Database the tables come from.
pub const version = "17.0.0";

/// The largest code point: the codespace runs from 0 to 10FFFF.
pub const code_point_max: u32 = 0x10FFFF;

/// The most fields a data line of the four files holds: a binary property's line of
/// PropertyValueAliases.txt holds five, as `AHex; N ; No ; F ; False`.
pub const fields_max = 5;

/// The fewest and the most hexadecimal digits of a code point (UAX #44 §4.2.2).
const digits_min = 4;
const digits_max = 6;

pub const Error = error{ VersionWrong, LineInvalid, OutOfMemory };

/// The first and the last code point of a range.
pub const Range = struct { lo: u32, hi: u32 };

/// Requires the file's first line to name the file `stem` at `version`.
pub fn check_version(text: []const u8, stem: []const u8) Error!void {
    const end = std.mem.indexOfScalar(u8, text, '\n') orelse return error.VersionWrong;
    const first = std.mem.trimEnd(u8, text[0..end], "\r");
    const prefix = "# ";
    const suffix = "-" ++ version ++ ".txt";
    if (!std.mem.startsWith(u8, first, prefix) or !std.mem.endsWith(u8, first, suffix)) return error.VersionWrong;
    if (!std.mem.eql(u8, first[prefix.len .. first.len - suffix.len], stem)) return error.VersionWrong;
}

/// The data lines of a file, each split into its fields, past comments and empty lines.
pub const Lines = struct {
    lines: std.mem.SplitIterator(u8, .scalar),
    fields: [fields_max][]const u8 = undefined,

    pub fn init(text: []const u8) Lines {
        return .{ .lines = std.mem.splitScalar(u8, text, '\n') };
    }

    /// The fields of the next data line, each with its spaces trimmed.
    pub fn next(lines: *Lines) Error!?[]const []const u8 {
        while (lines.lines.next()) |line| {
            const data = line[0 .. std.mem.indexOfScalar(u8, line, '#') orelse line.len];
            if (std.mem.trim(u8, data, " \t\r").len == 0) continue;
            var count: usize = 0;
            var fields = std.mem.splitScalar(u8, data, ';');
            while (fields.next()) |field| : (count += 1) {
                if (count == fields_max) return error.LineInvalid;
                lines.fields[count] = std.mem.trim(u8, field, " \t\r");
            }
            return lines.fields[0..count];
        }
        return null;
    }
};

/// The code points of a first field: `X` or `X..Y`.
pub fn code_points(field: []const u8) Error!Range {
    const dots = std.mem.indexOf(u8, field, "..");
    const lo = try code_point(field[0 .. dots orelse field.len]);
    const hi = if (dots) |at| try code_point(field[at + 2 ..]) else lo;
    if (hi < lo) return error.LineInvalid;
    return .{ .lo = lo, .hi = hi };
}

fn code_point(digits: []const u8) Error!u32 {
    if (digits.len < digits_min or digits.len > digits_max) return error.LineInvalid;
    const value = std.fmt.parseInt(u32, digits, 16) catch return error.LineInvalid;
    if (value > code_point_max) return error.LineInvalid;
    return value;
}

/// The code points of each value of a file whose lines map code points to a value in their second
/// field, as Scripts.txt and DerivedGeneralCategory.txt do. Each value's ranges are normalized.
pub fn values(arena: std.mem.Allocator, text: []const u8) Error!std.StringArrayHashMapUnmanaged([]Range) {
    var lists: std.StringArrayHashMapUnmanaged(std.ArrayList(Range)) = .empty;
    var lines: Lines = .init(text);
    while (try lines.next()) |fields| {
        if (fields.len != 2) return error.LineInvalid;
        const entry = try lists.getOrPut(arena, fields[1]);
        if (!entry.found_existing) entry.value_ptr.* = .empty;
        try entry.value_ptr.append(arena, try code_points(fields[0]));
    }
    var sets: std.StringArrayHashMapUnmanaged([]Range) = .empty;
    for (lists.keys(), lists.values()) |name, *list| try sets.put(arena, name, normalize(list.items));
    return sets;
}

/// Orders the ranges and joins those that overlap or touch, in place.
pub fn normalize(ranges: []Range) []Range {
    if (ranges.len == 0) return ranges;
    std.mem.sort(Range, ranges, {}, lower_first);
    var last: usize = 0;
    for (ranges[1..]) |range| {
        if (range.lo <= ranges[last].hi + 1) {
            ranges[last].hi = @max(ranges[last].hi, range.hi);
            continue;
        }
        last += 1;
        ranges[last] = range;
    }
    return ranges[0 .. last + 1];
}

fn lower_first(_: void, left: Range, right: Range) bool {
    return left.lo < right.lo;
}

/// Every code point of each set, as one normalized set.
pub fn union_of(arena: std.mem.Allocator, sets: []const []const Range) Error![]Range {
    var all: std.ArrayList(Range) = .empty;
    for (sets) |set| try all.appendSlice(arena, set);
    return normalize(all.items);
}

/// Every code point a normalized set does not hold.
pub fn complement(arena: std.mem.Allocator, set: []const Range) Error![]Range {
    var rest: std.ArrayList(Range) = .empty;
    var uncovered: u32 = 0;
    for (set) |range| {
        if (range.lo > uncovered) try rest.append(arena, .{ .lo = uncovered, .hi = range.lo - 1 });
        uncovered = range.hi + 1;
    }
    if (uncovered <= code_point_max) try rest.append(arena, .{ .lo = uncovered, .hi = code_point_max });
    return rest.items;
}

// Tests.

const testing = std.testing;

test "check_version takes the file's own first line and refuses another file or version" {
    try check_version("# Scripts-17.0.0.txt\n# Date: 2025\n", "Scripts");
    try check_version("# Scripts-17.0.0.txt\r\n", "Scripts");
    try testing.expectError(error.VersionWrong, check_version("# Scripts-16.0.0.txt\n", "Scripts"));
    try testing.expectError(error.VersionWrong, check_version("# CaseFolding-17.0.0.txt\n", "Scripts"));
    try testing.expectError(error.VersionWrong, check_version("Scripts-17.0.0.txt\n", "Scripts"));
    try testing.expectError(error.VersionWrong, check_version("# Scripts-17.0.0.txt", "Scripts"));
}

test "lines skips comments and empty lines and trims each field" {
    var lines: Lines = .init("# header\n\n0041..005A    ; Lu # LATIN\n  \t\ngc ; Cc ; Control ; cntrl\n");
    const first = (try lines.next()).?;
    try testing.expectEqual(2, first.len);
    try testing.expectEqualStrings("0041..005A", first[0]);
    try testing.expectEqualStrings("Lu", first[1]);
    const second = (try lines.next()).?;
    try testing.expectEqual(4, second.len);
    try testing.expectEqualStrings("cntrl", second[3]);
    try testing.expectEqual(null, try lines.next());
    var long: Lines = .init("a;b;c;d;e;f\n");
    try testing.expectError(error.LineInvalid, long.next());
}

test "code_points reads one code point or a range, of four to six digits, within the codespace" {
    try testing.expectEqual(Range{ .lo = 0x41, .hi = 0x41 }, try code_points("0041"));
    try testing.expectEqual(Range{ .lo = 0x41, .hi = 0x5A }, try code_points("0041..005A"));
    try testing.expectEqual(Range{ .lo = 0x10000, .hi = 0x10FFFF }, try code_points("10000..10FFFF"));
    try testing.expectError(error.LineInvalid, code_points("041"));
    try testing.expectError(error.LineInvalid, code_points("0010000"));
    try testing.expectError(error.LineInvalid, code_points("110000"));
    try testing.expectError(error.LineInvalid, code_points("005A..0041"));
    try testing.expectError(error.LineInvalid, code_points("00G1"));
}

test "values groups each value's code points and normalizes them" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const text = "0061..007A ; Ll\n0041..005A ; Lu\n00DF ; Ll\n00B5 ; Ll\n0030 ; Nd\n";
    const sets = try values(arena_state.allocator(), text);
    try testing.expectEqual(3, sets.count());
    const lower = sets.get("Ll").?;
    try testing.expectEqualSlices(Range, &.{ .{ .lo = 0x61, .hi = 0x7A }, .{ .lo = 0xB5, .hi = 0xB5 }, .{ .lo = 0xDF, .hi = 0xDF } }, lower);
    try testing.expectError(error.LineInvalid, values(arena_state.allocator(), "0041 ; Lu ; extra\n"));
}

test "normalize joins overlapping and touching ranges and keeps a gap" {
    var ranges = [_]Range{ .{ .lo = 10, .hi = 12 }, .{ .lo = 1, .hi = 3 }, .{ .lo = 4, .hi = 5 }, .{ .lo = 11, .hi = 20 }, .{ .lo = 22, .hi = 22 } };
    try testing.expectEqualSlices(Range, &.{ .{ .lo = 1, .hi = 5 }, .{ .lo = 10, .hi = 20 }, .{ .lo = 22, .hi = 22 } }, normalize(&ranges));
}

test "union_of and complement give the code points of their sets" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const left = [_]Range{.{ .lo = 0, .hi = 9 }};
    const right = [_]Range{ .{ .lo = 10, .hi = 10 }, .{ .lo = 20, .hi = 30 } };
    const both = try union_of(arena, &.{ &left, &right });
    try testing.expectEqualSlices(Range, &.{ .{ .lo = 0, .hi = 10 }, .{ .lo = 20, .hi = 30 } }, both);
    try testing.expectEqualSlices(Range, &.{ .{ .lo = 11, .hi = 19 }, .{ .lo = 31, .hi = code_point_max } }, try complement(arena, both));
    const all = [_]Range{.{ .lo = 0, .hi = code_point_max }};
    try testing.expectEqual(0, (try complement(arena, &all)).len);
    try testing.expectEqualSlices(Range, &all, try complement(arena, &.{}));
}
