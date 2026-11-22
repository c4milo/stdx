//! The atoms of a pattern, as fragments (decision 86): one scalar value, `.`, and a set of scalar
//! values written as alternatives of octet ranges.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const errors = @import("../errors.zig");
const fragment = @import("../fragment.zig");
const utf8 = @import("utf8");
const utf8_ranges = @import("../utf8_ranges.zig");
const Builder = fragment.Builder;
const Fragment = fragment.Fragment;
const ScalarSet = @import("../scalar_set.zig").ScalarSet;
const unicode = @import("unicode");

/// The flags of RE2's syntax that stdx takes, which `(?i)`, `(?m)`, `(?s)` and `(?U)` set.
pub const Flags = struct {
    /// `(?i)`: a character matches each character of its case orbit (UTS #18 RL1.5).
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

/// One scalar value, as its UTF-8. Under `(?i)` it is each scalar value of its case orbit, in
/// ascending order: `k` is `K`, `k` and the Kelvin sign. RFC 9485 §3 gives a regexp no
/// case-insensitive form, so `(?i)` is RE2's, with UTS #18 RL1.5's simple case folding.
pub fn literal(builder: *Builder, flags: Flags, scalar: u32) errors.Error!Fragment {
    assert(scalar <= constants.scalar_max and !utf8_ranges.is_surrogate(scalar));
    if (flags.case_insensitive and unicode.simple_fold(scalar) != scalar) return orbit(builder, scalar);
    var octets: [constants.utf8_len_max]u8 = undefined;
    const len = utf8.encoded_len(@intCast(scalar));
    utf8.encode(@intCast(scalar), octets[0..len]);
    var whole = try builder.range(octets[0], octets[0]);
    for (octets[1..len]) |octet| whole = builder.cat(whole, try builder.range(octet, octet));
    return whole;
}

/// Each scalar value of `scalar`'s case orbit in ascending order, one alternative for each run of
/// adjacent ones: Ā and ā, U+0100 and U+0101, are one range.
fn orbit(builder: *Builder, scalar: u32) errors.Error!Fragment {
    var members: [unicode.constants.orbit_len_max]utf8_ranges.ScalarRange = undefined;
    var count: usize = 0;
    var current = scalar;
    // `simple_fold` walks the orbit in ascending order, from its last member back to its first.
    while (count < members.len) : (count += 1) {
        members[count] = .{ .lo = current, .hi = current };
        current = unicode.simple_fold(current);
        if (current == scalar) break;
    }
    assert(current == scalar and count >= 1);
    const orbit_len = count + 1;
    std.mem.sort(utf8_ranges.ScalarRange, members[0..orbit_len], {}, lower_first);
    var last: usize = 0;
    for (members[1..orbit_len]) |member| {
        if (member.lo == members[last].hi + 1) {
            members[last].hi = member.hi;
            continue;
        }
        last += 1;
        members[last] = member;
    }
    return scalar_ranges(builder, members[0 .. last + 1]);
}

fn lower_first(_: void, left: utf8_ranges.ScalarRange, right: utf8_ranges.ScalarRange) bool {
    return left.lo < right.lo;
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
const program = @import("../program.zig");
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

test "a letter under (?i) takes its case orbit, and any other character itself alone" {
    var storage: [storage_len]program.Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    _ = try literal(&builder, .{ .case_insensitive = true }, 'b');
    try testing.expectEqual(@as(u32, 3), builder.len);
    try testing.expectEqual(@as(u8, 'B'), storage[0].lo);
    try testing.expectEqual(@as(u8, 'b'), storage[1].lo);
    try testing.expectEqual(program.Kind.split, storage[2].kind);
    builder.truncate(0);
    _ = try literal(&builder, .{ .case_insensitive = true }, '@');
    _ = try literal(&builder, .{ .case_insensitive = true }, '[');
    _ = try literal(&builder, .{ .case_insensitive = true }, 0x80);
    try testing.expectEqual(@as(u32, 4), builder.len);
    builder.truncate(0);
    // k's orbit holds the Kelvin sign, U+212A, whose UTF-8 starts with 0xE2.
    const k = try literal(&builder, .{ .case_insensitive = true }, 'K');
    for ([_]u8{ 'K', 'k', 0xE2 }) |octet| try testing.expect(first_octets(&storage, k.entry, octet));
    builder.truncate(0);
    // Ā and ā are adjacent: one sequence of two octet ranges, and no split.
    builder.truncate(0);
    _ = try literal(&builder, .{ .case_insensitive = true }, 0x100);
    try testing.expectEqual(@as(u32, 2), builder.len);
    builder.truncate(0);
    // É and é both start with 0xC3: the orbit is the two of them.
    const e = try literal(&builder, .{ .case_insensitive = true }, 0xC9);
    try testing.expect(first_octets(&storage, e.entry, 0xC3) and !first_octets(&storage, e.entry, 'e'));
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
