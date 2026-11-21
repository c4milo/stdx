//! The atoms of a pattern, as fragments (decision 86): one scalar value, `.`, and a set of scalar
//! values written as alternatives of octet ranges.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const errors = @import("errors.zig");
const fragment = @import("fragment.zig");
const utf8 = @import("utf8");
const utf8_ranges = @import("utf8_ranges.zig");
const Builder = fragment.Builder;
const Fragment = fragment.Fragment;
const ScalarSet = @import("scalar_set.zig").ScalarSet;

/// The flags of RE2's syntax that stdx takes, which `(?i)`, `(?m)`, `(?s)` and `(?U)` set.
pub const Flags = struct {
    /// `(?i)`: an ASCII letter matches both of its cases.
    case_insensitive: bool = false,
    /// `(?m)`: `^` and `$` match at each line's start and end, not at the text's alone.
    multi_line: bool = false,
    /// `(?s)`: `.` matches a line feed too.
    dot_matches_line_feed: bool = false,
    /// `(?U)`: a quantifier is lazy, and greedy with a `?` after it.
    swap_greed: bool = false,
};

/// The octet ranges of one sequence, each after the one before it.
fn sequence(builder: *Builder, ranges: []const utf8_ranges.OctetRange) fragment.Error!Fragment {
    assert(ranges.len > 0 and ranges.len <= constants.utf8_len_max);
    var whole = try builder.range(ranges[0].lo, ranges[0].hi);
    for (ranges[1..]) |range| whole = builder.cat(whole, try builder.range(range.lo, range.hi));
    return whole;
}

/// Every scalar value of ranges that are in order and apart: one alternative for each sequence
/// of octet ranges. No two alternatives take the same octets, so their order chooses nothing.
fn scalar_ranges(builder: *Builder, scalars: []const utf8_ranges.ScalarRange) fragment.Error!Fragment {
    var whole: ?Fragment = null;
    for (scalars) |range| {
        var splitter = utf8_ranges.Splitter.init(range.lo, range.hi);
        while (splitter.next()) |octets| {
            const piece = try sequence(builder, octets.ranges[0..octets.len]);
            whole = if (whole) |sofar| try builder.alternate(sofar, piece) else piece;
        }
    }
    return whole orelse builder.fail();
}

/// Every scalar value of a normalized set.
pub fn class(builder: *Builder, set: *const ScalarSet) fragment.Error!Fragment {
    return scalar_ranges(builder, set.slice());
}

fn is_ascii_letter(scalar: u32) bool {
    return switch (scalar) {
        'A'...'Z', 'a'...'z' => true,
        else => false,
    };
}

/// One scalar value, as its UTF-8. Under `(?i)` an ASCII letter is its two cases.
pub fn literal(builder: *Builder, flags: Flags, scalar: u32) errors.Error!Fragment {
    assert(scalar <= constants.scalar_max and !utf8_ranges.is_surrogate(scalar));
    if (flags.case_insensitive) {
        // RFC 9485 §3 gives a regexp no case-insensitive form: `(?i)` is RE2's, and stdx folds
        // the ASCII letters alone until design §8 adds Unicode's tables (decision 86).
        if (scalar > constants.one_octet_max) return error.UnsupportedCaseFolding;
        if (is_ascii_letter(scalar)) {
            const lower: u8 = @as(u8, @intCast(scalar)) | constants.ascii_case_bit;
            const upper = lower ^ constants.ascii_case_bit;
            return builder.alternate(try builder.range(upper, upper), try builder.range(lower, lower));
        }
    }
    var octets: [constants.utf8_len_max]u8 = undefined;
    const len = utf8.encoded_len(@intCast(scalar));
    utf8.encode(@intCast(scalar), octets[0..len]);
    var whole = try builder.range(octets[0], octets[0]);
    for (octets[1..len]) |octet| whole = builder.cat(whole, try builder.range(octet, octet));
    return whole;
}

/// What a `.` holds: any scalar value but a line feed, and any at all under `(?s)`.
const dot_ranges = [_]utf8_ranges.ScalarRange{
    .{ .lo = 0, .hi = constants.line_feed - 1 },
    .{ .lo = constants.line_feed + 1, .hi = constants.scalar_max },
};
const every_scalar = [_]utf8_ranges.ScalarRange{.{ .lo = 0, .hi = constants.scalar_max }};

pub fn dot(builder: *Builder, flags: Flags) errors.Error!Fragment {
    return scalar_ranges(builder, if (flags.dot_matches_line_feed) &every_scalar else &dot_ranges);
}

const testing = std.testing;
const program = @import("program.zig");
const storage_len = 96;

test "a literal past U+007F is one range for each octet of its UTF-8, in the program's order" {
    var storage: [storage_len]program.Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    const euro = try literal(&builder, .{}, 0x20AC);
    try testing.expectEqual(@as(u32, 3), builder.len);
    try testing.expectEqual(@as(u8, 0xE2), storage[euro.entry].lo);
    try testing.expectEqual(@as(u8, 0x82), storage[storage[euro.entry].out].lo);
    var reverse: Builder = .{ .instructions = &storage, .direction = .reverse };
    const back = try literal(&reverse, .{}, 0x20AC);
    try testing.expectEqual(@as(u8, 0xAC), storage[back.entry].lo);
    try testing.expectEqual(@as(u8, 0x82), storage[storage[back.entry].out].lo);
}

test "a letter under (?i) takes both cases, and any other ASCII character itself alone" {
    var storage: [storage_len]program.Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    _ = try literal(&builder, .{ .case_insensitive = true }, 'k');
    try testing.expectEqual(@as(u32, 3), builder.len);
    try testing.expectEqual(@as(u8, 'K'), storage[0].lo);
    try testing.expectEqual(@as(u8, 'k'), storage[1].lo);
    try testing.expectEqual(program.Kind.split, storage[2].kind);
    builder.truncate(0);
    _ = try literal(&builder, .{ .case_insensitive = true }, '@');
    _ = try literal(&builder, .{ .case_insensitive = true }, '[');
    try testing.expectEqual(@as(u32, 2), builder.len);
    try testing.expectError(error.UnsupportedCaseFolding, literal(&builder, .{ .case_insensitive = true }, 0xE9));
    try testing.expectError(error.UnsupportedCaseFolding, literal(&builder, .{ .case_insensitive = true }, 0x80));
}

fn first_octets(storage: []const program.Instruction, entry: u32, octet: u8) bool {
    // Follows the splits from `entry` and reads each alternative's first range.
    var stack: [storage_len]u32 = undefined;
    var len: u32 = 1;
    stack[0] = entry;
    var taken = false;
    for (0..storage_len) |_| {
        if (len == 0) break;
        len -= 1;
        const instruction = storage[stack[len]];
        if (instruction.kind == .range) taken = taken or instruction.takes(octet);
        if (instruction.kind != .split) continue;
        stack[len] = instruction.out;
        stack[len + 1] = instruction.arg;
        len += 1;
        len += 1;
    }
    return taken;
}

test "a dot starts with any octet that starts a scalar value, but a line feed" {
    var storage: [storage_len]program.Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    const any = try dot(&builder, .{});
    try testing.expect(first_octets(&storage, any.entry, 'a'));
    try testing.expect(first_octets(&storage, any.entry, 0x00));
    try testing.expect(first_octets(&storage, any.entry, 0xC2));
    try testing.expect(first_octets(&storage, any.entry, 0xF4));
    try testing.expect(!first_octets(&storage, any.entry, '\n'));
    try testing.expect(!first_octets(&storage, any.entry, 0x80));
    try testing.expect(!first_octets(&storage, any.entry, 0xC1));
    try testing.expect(!first_octets(&storage, any.entry, 0xF5));
    builder.truncate(0);
    const all = try dot(&builder, .{ .dot_matches_line_feed = true });
    try testing.expect(first_octets(&storage, all.entry, '\n'));
}

test "a set of no scalar value is an instruction no octet passes" {
    var storage: [storage_len]program.Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    var set: ScalarSet = .{};
    const none = try class(&builder, &set);
    try testing.expectEqual(program.Kind.fail, storage[none.entry].kind);
    try testing.expect(none.holes.is_empty());
    try set.add(constants.surrogate_min, constants.surrogate_max);
    const surrogates = try class(&builder, &set);
    try testing.expectEqual(program.Kind.fail, storage[surrogates.entry].kind);
}
