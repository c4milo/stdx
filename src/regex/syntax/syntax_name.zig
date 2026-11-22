//! The names of capture groups (decision 86): RE2's `(?P<name>re)` and `(?<name>re)`. A name holds
//! letters, digits and `_` alone, as Go's regexp takes it, and names one group: RE2 and Go's
//! regexp refuse a pattern that gives two groups one name. A named group captures as `(re)` does.
const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const errors = @import("../errors.zig");
const Error = errors.Error;

/// A named group the parser has read: the group, and where its name stands in the pattern.
pub const Named = struct { group: u32, start: u32, len: u8 };

/// Where a name stands in the pattern.
pub const Span = struct { start: usize, len: usize };

/// The names a pattern holds so far, in the order their groups open.
pub const Names = struct {
    entries: [constants.group_names_max]Named = undefined,
    len: u32 = 0,

    /// Adds the name `pattern[span.start..][0..span.len]` of `group`.
    pub fn add(names: *Names, pattern: []const u8, group: u32, span: Span) Error!void {
        assert(span.len >= 1 and span.len <= constants.group_name_len_max);
        const name = pattern[span.start..][0..span.len];
        for (names.entries[0..names.len]) |entry| {
            // RFC 9485 §3 holds no named group; RE2 and Go's regexp refuse a name two groups hold.
            if (std.mem.eql(u8, pattern[entry.start..][0..entry.len], name)) return error.DuplicateGroupName;
        }
        // RFC 9485 §8: a bound on what a regexp costs.
        if (names.len == constants.group_names_max) return error.GroupNamesTooMany;
        names.entries[names.len] = .{ .group = group, .start = @intCast(span.start), .len = @intCast(span.len) };
        names.len += 1;
    }

    pub fn slice(names: *const Names) []const Named {
        return names.entries[0..names.len];
    }
};

/// Reads a name and its `>`, after the `<` the reader just took.
pub fn take(reader: *codec.Reader) Error!Span {
    const start = reader.consumed();
    // A name ends at its `>`, at most `group_name_len_max` octets on.
    for (0..constants.group_name_len_max + 1) |len| {
        // RFC 9485 §3 holds no named group; RE2 closes each name with `>`.
        const octet = reader.take_octet() catch return error.InvalidGroupName;
        if (octet == '>') {
            // RFC 9485 §3 holds no named group; RE2 and Go's regexp refuse an empty name.
            if (len == 0) return error.InvalidGroupName;
            return .{ .start = start, .len = len };
        }
        // RFC 9485 §3 holds no named group; Go's regexp takes a name of letters, digits and `_`.
        if (!std.ascii.isAlphanumeric(octet) and octet != '_') return error.InvalidGroupName;
    }
    // RFC 9485 §8: a bound on what a regexp costs.
    return error.GroupNameTooLong;
}

const testing = std.testing;

/// The octets of each name the limit's test makes: three digits.
const test_name_len = 3;

fn take_text(text: []const u8) Error!Span {
    var reader = codec.Reader.init(text);
    return take(&reader);
}

test "take reads a name of letters, digits and _ to its >, and refuses any other" {
    try testing.expectEqual(Span{ .start = 0, .len = 4 }, try take_text("year>"));
    try testing.expectEqual(Span{ .start = 0, .len = 7 }, try take_text("user_id>x"));
    try testing.expectEqual(Span{ .start = 0, .len = 1 }, try take_text("9>"));
    for ([_][]const u8{ ">", "a-b>", "a b>", "na\xC3\xAFve>", "year", "" }) |text| {
        try testing.expectError(error.InvalidGroupName, take_text(text));
    }
    const longest = "n" ** constants.group_name_len_max;
    try testing.expectEqual(Span{ .start = 0, .len = longest.len }, try take_text(longest ++ ">"));
    try testing.expectError(error.GroupNameTooLong, take_text(longest ++ "n>"));
}

test "add refuses a name an earlier group holds, and more than group_names_max names" {
    const pattern = "ab";
    var names: Names = .{};
    try names.add(pattern, 1, .{ .start = 0, .len = 1 });
    try names.add(pattern, 2, .{ .start = 0, .len = 2 });
    try testing.expectError(error.DuplicateGroupName, names.add(pattern, 3, .{ .start = 0, .len = 1 }));
    try testing.expectEqual(@as(usize, 2), names.slice().len);
    // Names of three digits each, one more than the limit.
    var digits: [(constants.group_names_max + 1) * test_name_len]u8 = undefined;
    for (0..constants.group_names_max + 1) |index| {
        _ = std.fmt.bufPrint(digits[index * test_name_len ..][0..test_name_len], "{d:0>3}", .{index}) catch unreachable;
    }
    var full: Names = .{};
    for (0..constants.group_names_max) |index| {
        try full.add(&digits, @intCast(index + 1), .{ .start = index * test_name_len, .len = test_name_len });
    }
    const last = constants.group_names_max * test_name_len;
    try testing.expectError(error.GroupNamesTooMany, full.add(&digits, constants.group_names_max + 1, .{ .start = last, .len = test_name_len }));
}
