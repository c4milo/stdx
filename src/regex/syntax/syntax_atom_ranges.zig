//! A class of few ranges as one `ranges` node (decision 86 as amended): the first octet ranges of
//! its UTF-8 sequences, when they stand apart, each going on to the rest of its sequence.
//!
//! The sequences of a class arrive in ascending order of their scalar values, so their first
//! ranges ascend too. They stand apart unless two sequences share a lead octet, as `[а-яё]` does,
//! where `я` and `ё` both start with 0xD1: such a class keeps one alternative for each sequence.
//! Read back, a sequence starts from its last octet, a continuation octet that many sequences
//! share, so a reverse program takes a node only for a class of single octets, as `[A-Za-z_]`.
//! A matcher reading the class then keeps one thread at its node, where the alternatives keep one
//! for each sequence: `[^ ]` holds ten.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const fragment = @import("../fragment.zig");
const utf8_ranges = @import("../utf8_ranges.zig");
const Builder = fragment.Builder;
const Fragment = fragment.Fragment;
const Holes = fragment.Holes;
const ScalarRange = utf8_ranges.ScalarRange;
const Sequence = utf8_ranges.Sequence;

/// The fewest sequences a node holds. Two keep their split, whose two threads a node would save
/// one of: claim R2 reads such a split as a letter in either case, as `(?i)a` writes it.
const node_sequences_min = 3;

/// The sequences of a class's scalar values, in ascending order.
const Sequences = struct {
    scalars: []const ScalarRange,
    index: usize = 0,
    splitter: ?utf8_ranges.Splitter = null,

    fn next(sequences: *Sequences) ?Sequence {
        // Each turn gives a sequence or moves to the next scalar range.
        for (0..sequences.scalars.len + 1) |_| {
            if (sequences.splitter) |*splitter| {
                if (splitter.next()) |sequence| return sequence;
                sequences.splitter = null;
            }
            if (sequences.index == sequences.scalars.len) return null;
            const range = sequences.scalars[sequences.index];
            sequences.index += 1;
            if (range.hi > constants.one_octet_max) {
                sequences.splitter = .init(range.lo, range.hi);
                continue;
            }
            var sequence: Sequence = .{ .ranges = undefined, .len = 1 };
            sequence.ranges[0] = .{ .lo = @intCast(range.lo), .hi = @intCast(range.hi) };
            return sequence;
        }
        return null;
    }
};

/// The class as a `ranges` node, or null where its sequences' first ranges do not stand apart,
/// where it holds fewer than `node_sequences_min` sequences or more than one for each octet, or,
/// read back, where a sequence holds more than one octet.
pub fn node(builder: *Builder, scalars: []const ScalarRange) fragment.Error!?Fragment {
    // Three refusals that need no sequence: an empty class; read back, a value past U+007F, a
    // sequence of more than one octet; and one range of single octets, one sequence.
    if (scalars.len == 0) return null;
    const past_ascii = scalars[scalars.len - 1].hi > constants.one_octet_max;
    if (builder.direction == .reverse and past_ascii) return null;
    if (scalars.len == 1 and !past_ascii) return null;
    var sequences: [constants.octet_values]Sequence = undefined;
    const count = gather(builder.direction, scalars, &sequences) orelse return null;
    if (count < node_sequences_min) return null;
    const gathered = sequences[0..count];
    // `program.step_ranges` reads `arg` members, each a range, and asserts neither.
    assert(count >= 1 and count <= constants.octet_values);
    const head = try builder.emit(.{ .kind = .ranges, .arg = @intCast(count) });
    var holes: Holes = .{};
    // A sequence of one range leaves the class through a hole. A longer one's range goes on to
    // the rest of its sequence, which the second loop writes after the node's ranges.
    for (gathered) |sequence| {
        const first = sequence.ranges[0];
        if (sequence.len > 1) {
            _ = try builder.emit(.{ .kind = .range, .lo = first.lo, .hi = first.hi });
            continue;
        }
        holes = builder.join(holes, (try builder.range(first.lo, first.hi)).holes);
    }
    for (gathered, head + 1..) |sequence, member| {
        if (sequence.len == 1) continue;
        const rest = try rest_of(builder, sequence.ranges[1..sequence.len]);
        builder.instructions[member].out = rest.entry;
        holes = builder.join(holes, rest.holes);
    }
    return .{ .begin = head, .entry = head, .holes = holes, .nullable = false, .weight = 1 };
}

/// A class of octets as one `ranges` node (`Encoding.bytes`). Each member is one octet, so the
/// ranges stand apart as the set's do, and a reverse program takes the node too. Null where
/// the class holds fewer than `node_sequences_min` ranges.
pub fn octets(builder: *Builder, ranges: []const utf8_ranges.OctetRange) fragment.Error!?Fragment {
    if (ranges.len < node_sequences_min) return null;
    // `program.step_ranges` reads `arg` members, each a range, and asserts neither.
    assert(ranges.len <= constants.octet_ranges_max);
    const head = try builder.emit(.{ .kind = .ranges, .arg = @intCast(ranges.len) });
    var holes: Holes = .{};
    for (ranges, 0..) |range, index| {
        assert(index == 0 or range.lo > ranges[index - 1].hi);
        holes = builder.join(holes, (try builder.range(range.lo, range.hi)).holes);
    }
    return .{ .begin = head, .entry = head, .holes = holes, .nullable = false, .weight = 1 };
}

/// Writes the class's sequences into `gathered` and gives their count, or null where their first
/// ranges do not stand apart, where they are more than `gathered` holds, or, read back, where
/// one holds more than one octet.
fn gather(direction: fragment.Direction, scalars: []const ScalarRange, gathered: *[constants.octet_values]Sequence) ?usize {
    var sequences: Sequences = .{ .scalars = scalars };
    // Each turn takes one sequence, and a node holds one range for each octet at most.
    for (gathered, 0..) |*slot, count| {
        const sequence = sequences.next() orelse return count;
        if (direction == .reverse and sequence.len > 1) return null;
        if (count > 0 and sequence.ranges[0].lo <= gathered[count - 1].ranges[0].hi) return null;
        slot.* = sequence;
    }
    return if (sequences.next() == null) gathered.len else null;
}

/// The ranges after a sequence's first, in order.
fn rest_of(builder: *Builder, ranges: []const utf8_ranges.OctetRange) fragment.Error!Fragment {
    assert(ranges.len > 0 and builder.direction == .forward);
    var whole = try builder.range(ranges[0].lo, ranges[0].hi);
    for (ranges[1..]) |range| whole = builder.cat(whole, try builder.range(range.lo, range.hi));
    return whole;
}

const testing = std.testing;
const program = @import("../program.zig");

/// The instructions a test's class takes at most.
const test_storage_len = 128;

test "a class whose sequences start apart is one node, each range going on to its sequence" {
    var storage: [test_storage_len]program.Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    // Every scalar value but a space: ten sequences, each with its own first range.
    const scalars = [_]ScalarRange{ .{ .lo = 0, .hi = ' ' - 1 }, .{ .lo = ' ' + 1, .hi = constants.scalar_max } };
    const whole = (try node(&builder, &scalars)) orelse return error.TestExpectedNode;
    const written = storage[0..builder.len];
    try testing.expectEqual(program.Kind.ranges, written[whole.entry].kind);
    try testing.expect(program.step(written, whole.entry, ' ') == null);
    try testing.expect(program.step(written, whole.entry, 'a').? & constants.hole_flag != 0);
    // `é` is 0xC3 0xA9: the lead octet goes to a range of continuations, which leaves the class.
    const after_lead = program.step(written, whole.entry, 0xC3).?;
    try testing.expect(after_lead & constants.hole_flag == 0);
    try testing.expect(program.step(written, after_lead, 0xA9).? & constants.hole_flag != 0);
    try testing.expect(program.step(written, whole.entry, 0x80) == null);
}

test "a class whose sequences share a lead octet, or of fewer than three sequences, is no node" {
    var storage: [test_storage_len]program.Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    // `а` to `я` and `ё`: U+0430 to U+044F, and U+0451, whose sequences share 0xD1.
    const shared = [_]ScalarRange{ .{ .lo = 0x430, .hi = 0x44F }, .{ .lo = 0x451, .hi = 0x451 } };
    try testing.expect(try node(&builder, &shared) == null);
    const one = [_]ScalarRange{.{ .lo = 'a', .hi = 'z' }};
    try testing.expect(try node(&builder, &one) == null);
    const two = [_]ScalarRange{ .{ .lo = 'A', .hi = 'A' }, .{ .lo = 'a', .hi = 'a' } };
    try testing.expect(try node(&builder, &two) == null);
    try testing.expectEqual(@as(u32, 0), builder.len);
}

test "read back, a class of single octets is a node, and one of longer sequences is none" {
    var storage: [test_storage_len]program.Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .reverse };
    const word = [_]ScalarRange{ .{ .lo = 'A', .hi = 'Z' }, .{ .lo = '_', .hi = '_' }, .{ .lo = 'a', .hi = 'z' } };
    const whole = (try node(&builder, &word)) orelse return error.TestExpectedNode;
    try testing.expectEqual(@as(u32, 3), storage[whole.entry].arg);
    const wide = [_]ScalarRange{ .{ .lo = 'a', .hi = 'z' }, .{ .lo = 0xE9, .hi = 0xE9 } };
    try testing.expect(try node(&builder, &wide) == null);
}

test "a class of octets is one node in both directions, and two ranges keep their split" {
    var storage: [test_storage_len]program.Instruction = undefined;
    const ranges = [_]utf8_ranges.OctetRange{ .{ .lo = 'a', .hi = 'z' }, .{ .lo = 0x80, .hi = 0xBF }, .{ .lo = 0xFF, .hi = 0xFF } };
    for ([_]fragment.Direction{ .forward, .reverse }) |direction| {
        var builder: Builder = .{ .instructions = &storage, .direction = direction };
        const whole = (try octets(&builder, &ranges)) orelse return error.TestExpectedNode;
        const written = storage[0..builder.len];
        try testing.expectEqual(program.Kind.ranges, written[whole.entry].kind);
        for ("a\x80\xBF\xFF") |octet| try testing.expect(program.step(written, whole.entry, octet).? & constants.hole_flag != 0);
        for ("`\x7F\xC0\xFE") |octet| try testing.expect(program.step(written, whole.entry, octet) == null);
    }
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    const two = [_]utf8_ranges.OctetRange{ .{ .lo = 'A', .hi = 'A' }, .{ .lo = 'a', .hi = 'a' } };
    try testing.expect(try octets(&builder, &two) == null);
    try testing.expectEqual(@as(u32, 0), builder.len);
}
