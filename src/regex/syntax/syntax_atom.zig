//! The atoms of a pattern, as fragments (decision 86): one scalar value, `.`, and a set of scalar
//! values written as alternatives of octet ranges. In UTF-8 each scalar value is its sequence of
//! bytes. In bytes `.`, a class and an escape take one byte each, and a byte past 0x7F has no
//! case.
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
const utf8_compact = @import("syntax_atom_utf8.zig");
const ranges_node = @import("syntax_atom_ranges.zig");
const Encoding = @import("../program.zig").Encoding;

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

/// Every scalar value of ranges that are in order and apart: one automaton for a class of many
/// ranges past U+007F (syntax_atom_utf8.zig), one `ranges` node where the sequences' first ranges
/// stand apart (syntax_atom_ranges.zig), or one alternative for each sequence of octet ranges. No
/// two alternatives take the same octets, so their order chooses nothing.
fn scalar_ranges(builder: *Builder, scalars: []const utf8_ranges.ScalarRange) fragment.Error!Fragment {
    if (scalars.len >= constants.utf8_compact_ranges_min and scalars[scalars.len - 1].hi > constants.one_octet_max) {
        if (try utf8_compact.class(builder, scalars)) |whole| return whole;
    }
    if (try ranges_node.node(builder, scalars)) |whole| return whole;
    return alternatives(builder, scalars);
}

/// One alternative for each sequence of octet ranges, and one range of octets for the scalar
/// values of one octet each.
pub fn alternatives(builder: *Builder, scalars: []const utf8_ranges.ScalarRange) fragment.Error!Fragment {
    var whole: ?Fragment = null;
    for (scalars) |range| {
        if (range.hi <= constants.one_octet_max) {
            // One octet for each scalar value: the one range of octets the split would give.
            const piece = try builder.range(@intCast(range.lo), @intCast(range.hi));
            whole = if (whole) |sofar| try builder.alternate(sofar, piece) else piece;
            continue;
        }
        var splitter = utf8_ranges.Splitter.init(range.lo, range.hi);
        while (splitter.next()) |octets| {
            const piece = try sequence(builder, octets.ranges[0..octets.len]);
            whole = if (whole) |sofar| try builder.alternate(sofar, piece) else piece;
        }
    }
    return whole orelse builder.fail();
}

/// Every scalar value of a normalized set, and in bytes every byte it holds.
pub fn class(builder: *Builder, encoding: Encoding, set: *const ScalarSet) fragment.Error!Fragment {
    if (encoding == .bytes) return octet_ranges(builder, set.slice());
    return scalar_ranges(builder, set.slice());
}

/// The bytes of ranges that are in order and apart (`Encoding.bytes`): one `ranges` node, or one
/// alternative for each range. A set that goes on past 0xFF, as a negated one does, ends there.
fn octet_ranges(builder: *Builder, scalars: []const utf8_ranges.ScalarRange) fragment.Error!Fragment {
    var octets: [constants.octet_ranges_max]utf8_ranges.OctetRange = undefined;
    var len: usize = 0;
    for (scalars) |range| {
        if (range.lo > constants.octet_max) break;
        // Ranges apart hold at most one range for each two bytes.
        assert(len < octets.len);
        octets[len] = .{ .lo = @intCast(range.lo), .hi = @intCast(@min(range.hi, constants.octet_max)) };
        len += 1;
    }
    if (try ranges_node.octets(builder, octets[0..len])) |whole| return whole;
    var whole: ?Fragment = null;
    for (octets[0..len]) |range| {
        const piece = try builder.range(range.lo, range.hi);
        whole = if (whole) |sofar| try builder.alternate(sofar, piece) else piece;
    }
    return whole orelse builder.fail();
}

/// One character of the pattern, as its UTF-8. Under `(?i)` it is each scalar value of its case
/// orbit, in ascending order: `k` is `K`, `k` and the Kelvin sign. RFC 9485 §3 gives a regexp no
/// case-insensitive form, so `(?i)` is RE2's, with UTS #18 RL1.5's simple case folding. In bytes
/// an ASCII character is the byte that `octet` writes, and any other has no case.
pub fn literal(builder: *Builder, flags: Flags, encoding: Encoding, scalar: u32) errors.Error!Fragment {
    assert(scalar <= constants.scalar_max and !utf8_ranges.is_surrogate(scalar));
    if (encoding == .bytes and scalar <= constants.one_octet_max) return octet(builder, flags, @intCast(scalar));
    if (flags.case_insensitive and encoding == .utf8) {
        if (try folded_orbit(builder, scalar)) |whole| return whole;
    }
    var octets: [constants.utf8_len_max]u8 = undefined;
    const len = utf8.encoded_len(@intCast(scalar));
    utf8.encode(@intCast(scalar), octets[0..len]);
    var whole = try builder.range(octets[0], octets[0]);
    for (octets[1..len]) |value| whole = builder.cat(whole, try builder.range(value, value));
    return whole;
}

/// A scalar value under `(?i)` in UTF-8, as each member of its case orbit in ascending order, or
/// null where the orbit holds the value alone.
fn folded_orbit(builder: *Builder, scalar: u32) fragment.Error!?Fragment {
    if (scalar <= constants.one_octet_max) {
        const orbit = &ascii_orbits[scalar];
        if (orbit.len == 0) return null;
        if (orbit.one_octet()) return try one_octet_orbit(builder, orbit.slice());
        return try scalar_ranges(builder, orbit.slice());
    }
    if (unicode.simple_fold(scalar) == scalar) return null;
    const orbit = orbit_of(scalar);
    return try scalar_ranges(builder, orbit.slice());
}

/// One byte in bytes (`Encoding.bytes`): an ASCII character, or an escape such as `\xE9`. Under
/// `(?i)` an ASCII letter is both its cases, the capital first, and a byte past 0x7F has no case.
pub fn octet(builder: *Builder, flags: Flags, value: u8) fragment.Error!Fragment {
    if (!flags.case_insensitive or !std.ascii.isAlphabetic(value)) return builder.range(value, value);
    const capital = std.ascii.toUpper(value);
    const small = std.ascii.toLower(value);
    const cases = [_]utf8_ranges.ScalarRange{ .{ .lo = capital, .hi = capital }, .{ .lo = small, .hi = small } };
    return octet_ranges(builder, &cases);
}

/// A case orbit's members in ascending order, as ranges: adjacent ones, such as Ā and ā, U+0100
/// and U+0101, are one range.
const Orbit = struct {
    ranges: [unicode.constants.orbit_len_max]utf8_ranges.ScalarRange,
    len: u8,

    fn slice(orbit: *const Orbit) []const utf8_ranges.ScalarRange {
        return orbit.ranges[0..orbit.len];
    }

    /// True when each member is one octet of UTF-8, as each member of `a`'s orbit is.
    fn one_octet(orbit: *const Orbit) bool {
        assert(orbit.len > 0);
        return orbit.ranges[orbit.len - 1].hi <= constants.one_octet_max;
    }
};

/// An orbit of members of one octet each, as `scalar_ranges` writes it, with no fragment to
/// test for each range.
fn one_octet_orbit(builder: *Builder, ranges: []const utf8_ranges.ScalarRange) fragment.Error!Fragment {
    var whole = try builder.range(@intCast(ranges[0].lo), @intCast(ranges[0].hi));
    for (ranges[1..]) |range| whole = try builder.alternate(whole, try builder.range(@intCast(range.lo), @intCast(range.hi)));
    return whole;
}

/// The orbit of `scalar`, which holds two members or more.
fn orbit_of(scalar: u32) Orbit {
    var orbit: Orbit = .{ .ranges = @splat(.{ .lo = scalar, .hi = scalar }), .len = 0 };
    var count: usize = 0;
    var current = scalar;
    // `simple_fold` walks the orbit in ascending order, from its last member back to its first.
    while (count < orbit.ranges.len) : (count += 1) {
        orbit.ranges[count] = .{ .lo = current, .hi = current };
        current = unicode.simple_fold(current);
        if (current == scalar) break;
    }
    assert(current == scalar and count >= 1);
    const members = orbit.ranges[0 .. count + 1];
    std.mem.sort(utf8_ranges.ScalarRange, members, {}, lower_first);
    var last: usize = 0;
    for (members[1..]) |member| {
        if (member.lo == members[last].hi + 1) {
            members[last].hi = member.hi;
            continue;
        }
        last += 1;
        members[last] = member;
    }
    orbit.len = @intCast(last + 1);
    return orbit;
}

/// The branches the compiler takes to read the folding tables for each ASCII character.
const ascii_orbits_branch_quota = 100_000;

/// The orbit of each ASCII character, which `literal` takes under `(?i)` with no search of the
/// folding tables. A character alone in its orbit has a length of 0.
const ascii_orbits = orbits: {
    @setEvalBranchQuota(ascii_orbits_branch_quota);
    var orbits: [constants.one_octet_max + 1]Orbit = undefined;
    for (&orbits, 0..) |*orbit, scalar| {
        const alone: Orbit = .{ .ranges = @splat(.{ .lo = scalar, .hi = scalar }), .len = 0 };
        orbit.* = if (unicode.simple_fold(scalar) == scalar) alone else orbit_of(scalar);
    }
    break :orbits orbits;
};

fn lower_first(_: void, left: utf8_ranges.ScalarRange, right: utf8_ranges.ScalarRange) bool {
    return left.lo < right.lo;
}

/// What a `.` holds: any scalar value but a line feed, and any at all under `(?s)`. In bytes
/// these hold any byte but a line feed, and any byte.
const dot_ranges = [_]utf8_ranges.ScalarRange{
    .{ .lo = 0, .hi = constants.line_feed - 1 },
    .{ .lo = constants.line_feed + 1, .hi = constants.scalar_max },
};
const every_scalar = [_]utf8_ranges.ScalarRange{.{ .lo = 0, .hi = constants.scalar_max }};

pub fn dot(builder: *Builder, flags: Flags, encoding: Encoding) errors.Error!Fragment {
    const ranges: []const utf8_ranges.ScalarRange = if (flags.dot_matches_line_feed) &every_scalar else &dot_ranges;
    if (encoding == .bytes) return octet_ranges(builder, ranges);
    return scalar_ranges(builder, ranges);
}

const testing = std.testing;
const program = @import("../program.zig");
const storage_len = 96;

test "a literal past U+007F is one range for each octet of its UTF-8, in the program's order" {
    var storage: [storage_len]program.Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    const euro = try literal(&builder, .{}, .utf8, 0x20AC);
    try testing.expectEqual(@as(u32, 3), builder.len);
    try testing.expectEqual(@as(u8, 0xE2), storage[euro.entry].lo);
    try testing.expectEqual(@as(u8, 0x82), storage[storage[euro.entry].out].lo);
    var reverse: Builder = .{ .instructions = &storage, .direction = .reverse };
    const back = try literal(&reverse, .{}, .utf8, 0x20AC);
    try testing.expectEqual(@as(u8, 0xAC), storage[back.entry].lo);
    try testing.expectEqual(@as(u8, 0x82), storage[storage[back.entry].out].lo);
}

test "a letter under (?i) takes its case orbit, and any other character itself alone" {
    var storage: [storage_len]program.Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    _ = try literal(&builder, .{ .case_insensitive = true }, .utf8, 'b');
    try testing.expectEqual(@as(u32, 3), builder.len);
    try testing.expectEqual(@as(u8, 'B'), storage[0].lo);
    try testing.expectEqual(@as(u8, 'b'), storage[1].lo);
    try testing.expectEqual(program.Kind.split, storage[2].kind);
    builder.truncate(0);
    _ = try literal(&builder, .{ .case_insensitive = true }, .utf8, '@');
    _ = try literal(&builder, .{ .case_insensitive = true }, .utf8, '[');
    _ = try literal(&builder, .{ .case_insensitive = true }, .utf8, 0x80);
    try testing.expectEqual(@as(u32, 4), builder.len);
    builder.truncate(0);
    // k's orbit holds the Kelvin sign, U+212A, whose UTF-8 starts with 0xE2.
    const k = try literal(&builder, .{ .case_insensitive = true }, .utf8, 'K');
    for ([_]u8{ 'K', 'k', 0xE2 }) |value| try testing.expect(first_octets(&storage, k.entry, value));
    builder.truncate(0);
    // Ā and ā are adjacent: one sequence of two octet ranges, and no split.
    builder.truncate(0);
    _ = try literal(&builder, .{ .case_insensitive = true }, .utf8, 0x100);
    try testing.expectEqual(@as(u32, 2), builder.len);
    builder.truncate(0);
    // É and é both start with 0xC3: the orbit is the two of them.
    const e = try literal(&builder, .{ .case_insensitive = true }, .utf8, 0xC9);
    try testing.expect(first_octets(&storage, e.entry, 0xC3) and !first_octets(&storage, e.entry, 'e'));
}

/// The program of `scalars` with every range split, as `scalar_ranges` wrote it before it took a
/// range of one octet a scalar value in one instruction.
fn split_ranges(builder: *Builder, scalars: []const utf8_ranges.ScalarRange) fragment.Error!Fragment {
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

test "a range of one octet a scalar value writes the program its split writes" {
    var storage: [storage_len]program.Instruction = undefined;
    var split_storage: [storage_len]program.Instruction = undefined;
    const sets = [_][]const utf8_ranges.ScalarRange{
        &.{.{ .lo = 0, .hi = constants.one_octet_max }},
        &.{ .{ .lo = 'A', .hi = 'Z' }, .{ .lo = 'a', .hi = 'z' } },
        &.{.{ .lo = 0x7F, .hi = 0x80 }},
        &.{ .{ .lo = 'k', .hi = 'k' }, .{ .lo = 0x212A, .hi = 0x212A } },
    };
    for (sets) |scalars| {
        var builder: Builder = .{ .instructions = &storage, .direction = .forward };
        var split: Builder = .{ .instructions = &split_storage, .direction = .forward };
        _ = try scalar_ranges(&builder, scalars);
        _ = try split_ranges(&split, scalars);
        try testing.expectEqualSlices(program.Instruction, split_storage[0..split.len], storage[0..builder.len]);
    }
}

test "each ASCII character under (?i) writes the program of its class folded by the tables" {
    var storage: [storage_len]program.Instruction = undefined;
    var folded_storage: [storage_len]program.Instruction = undefined;
    var set_storage: [constants.class_ranges_max]utf8_ranges.ScalarRange = undefined;
    for (0..constants.one_octet_max + 1) |scalar| {
        var builder: Builder = .{ .instructions = &storage, .direction = .forward };
        _ = try literal(&builder, .{ .case_insensitive = true }, .utf8, @intCast(scalar));
        // A second reading of the orbit: `unicode.images`, which a class folds by.
        var set = ScalarSet.init(&set_storage);
        try set.add_folded(@intCast(scalar), @intCast(scalar), true);
        var folded: Builder = .{ .instructions = &folded_storage, .direction = .forward };
        _ = try class(&folded, .utf8, &set);
        try testing.expectEqualSlices(program.Instruction, folded_storage[0..folded.len], storage[0..builder.len]);
    }
}

fn first_octets(storage: []const program.Instruction, entry: u32, value: u8) bool {
    // Follows the splits from `entry` and reads each alternative's first range.
    var stack: [storage_len]u32 = undefined;
    var len: u32 = 1;
    stack[0] = entry;
    var taken = false;
    for (0..storage_len) |_| {
        if (len == 0) break;
        len -= 1;
        const instruction = storage[stack[len]];
        if (instruction.kind == .range) taken = taken or instruction.takes(value);
        if (instruction.kind == .ranges) taken = taken or program.step(storage, stack[len], value) != null;
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
    const any = try dot(&builder, .{}, .utf8);
    try testing.expect(first_octets(&storage, any.entry, 'a'));
    try testing.expect(first_octets(&storage, any.entry, 0x00));
    try testing.expect(first_octets(&storage, any.entry, 0xC2));
    try testing.expect(first_octets(&storage, any.entry, 0xF4));
    try testing.expect(!first_octets(&storage, any.entry, '\n'));
    try testing.expect(!first_octets(&storage, any.entry, 0x80));
    try testing.expect(!first_octets(&storage, any.entry, 0xC1));
    try testing.expect(!first_octets(&storage, any.entry, 0xF5));
    builder.truncate(0);
    const all = try dot(&builder, .{ .dot_matches_line_feed = true }, .utf8);
    try testing.expect(first_octets(&storage, all.entry, '\n'));
}

test "a set of no scalar value is an instruction no octet passes" {
    var storage: [storage_len]program.Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    var set_storage: [constants.class_ranges_max]utf8_ranges.ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    const none = try class(&builder, .utf8, &set);
    try testing.expectEqual(program.Kind.fail, storage[none.entry].kind);
    try testing.expect(none.holes.is_empty());
    try set.add(constants.surrogate_min, constants.surrogate_max);
    const surrogates = try class(&builder, .utf8, &set);
    try testing.expectEqual(program.Kind.fail, storage[surrogates.entry].kind);
}

test "in bytes an atom takes one byte of any value, and a byte past 0x7F has no case" {
    var storage: [storage_len]program.Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    const any = try dot(&builder, .{}, .bytes);
    for ("a\x00\x80\xBF\xC0\xFF") |value| try testing.expect(first_octets(&storage, any.entry, value));
    try testing.expect(!first_octets(&storage, any.entry, '\n'));
    const all = try dot(&builder, .{ .dot_matches_line_feed = true }, .bytes);
    try testing.expect(first_octets(&storage, all.entry, '\n'));
    // An escape such as `\xE9` is one byte, with no case under `(?i)`.
    builder.truncate(0);
    _ = try octet(&builder, .{ .case_insensitive = true }, 0xE9);
    try testing.expectEqual(@as(u32, 1), builder.len);
    try testing.expectEqual(@as(u8, 0xE9), storage[0].lo);
    // A character past U+007F is its UTF-8, with no case: `é` is 0xC3 and 0xA9 alone.
    builder.truncate(0);
    const e = try literal(&builder, .{ .case_insensitive = true }, .bytes, 0xE9);
    try testing.expectEqual(@as(u32, 2), builder.len);
    try testing.expect(first_octets(&storage, e.entry, 0xC3) and !first_octets(&storage, e.entry, 0xE9));
    // k's orbit holds the Kelvin sign, U+212A, which has no case in bytes: `K` and `k` alone.
    builder.truncate(0);
    const k = try literal(&builder, .{ .case_insensitive = true }, .bytes, 'k');
    try testing.expectEqual(@as(u32, 3), builder.len);
    try testing.expect(first_octets(&storage, k.entry, 'K') and !first_octets(&storage, k.entry, 0xE2));
}
