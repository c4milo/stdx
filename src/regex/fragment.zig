//! A program under construction (decision 86): fragments that end in holes, joined by patching.
//!
//! A fragment is a block of instructions with one entry and a list of holes: targets not yet
//! known. Thompson's construction joins two fragments by writing one's entry into the other's
//! holes. A hole keeps the link to its fragment's next hole in the target itself, so a list of
//! holes takes no memory of its own.
//!
//! Every instruction names its targets, so a block stands anywhere in the program. `copy` makes a
//! second block from a first, which is how a range quantifier repeats its operand.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program = @import("program.zig");
const Instruction = program.Instruction;
const Look = program.Look;

/// A list of holes, by its first and its last. A hole is named by twice its instruction's index,
/// plus one when the hole is the instruction's `arg`.
pub const Holes = struct {
    head: u32 = constants.hole_none,
    tail: u32 = constants.hole_none,

    pub fn is_empty(holes: Holes) bool {
        return holes.head == constants.hole_none;
    }
};

/// The order a program reads its text in. The reverse program matches each match read from its
/// last octet to its first.
pub const Direction = enum { forward, reverse };

pub const Fragment = struct {
    /// The first instruction of the block. While the fragment is the last one built, its block
    /// runs from here to the program's end.
    begin: u32,
    entry: u32,
    holes: Holes,
    /// True when the fragment matches the empty string.
    nullable: bool,
    /// The product of the counts of the range quantifiers nested in the fragment.
    weight: u32,
};

/// Whether a quantifier takes its operand first, or the text after it.
pub const Greed = enum { greedy, lazy };

pub const Error = error{NoSpaceLeft};

pub const Builder = struct {
    instructions: []Instruction,
    len: u32 = 0,
    direction: Direction,

    pub fn emit(builder: *Builder, instruction: Instruction) Error!u32 {
        if (builder.len == builder.instructions.len) return error.NoSpaceLeft;
        assert(builder.len < constants.instructions_max);
        builder.instructions[builder.len] = instruction;
        builder.len += 1;
        return builder.len - 1;
    }

    fn target(builder: *Builder, hole: u32) *u32 {
        const instruction = &builder.instructions[hole >> 1];
        return if (hole & 1 == 0) &instruction.out else &instruction.arg;
    }

    /// Makes the `out` of the instruction at `index` a hole, and gives the list that holds it.
    fn open_out(builder: *Builder, index: u32) Holes {
        builder.instructions[index].out = constants.hole_flag | constants.hole_none;
        return .{ .head = index << 1, .tail = index << 1 };
    }

    fn open_arg(builder: *Builder, index: u32) Holes {
        builder.instructions[index].arg = constants.hole_flag | constants.hole_none;
        return .{ .head = (index << 1) | 1, .tail = (index << 1) | 1 };
    }

    /// One list that holds the holes of both.
    pub fn join(builder: *Builder, first: Holes, second: Holes) Holes {
        if (first.is_empty()) return second;
        if (second.is_empty()) return first;
        const link = builder.target(first.tail);
        assert(link.* == constants.hole_flag | constants.hole_none);
        link.* = constants.hole_flag | second.head;
        return .{ .head = first.head, .tail = second.tail };
    }

    /// Writes `entry` into every hole of the list.
    pub fn patch(builder: *Builder, holes: Holes, entry: u32) void {
        assert(entry < builder.len);
        var hole = holes.head;
        var patched: u32 = 0;
        while (hole != constants.hole_none) : (patched += 1) {
            assert(patched < constants.targets_per_instruction * builder.len);
            const link = builder.target(hole);
            assert(link.* & constants.hole_flag != 0);
            hole = link.* & constants.hole_none;
            link.* = entry;
        }
    }

    fn single(builder: *Builder, instruction: Instruction, nullable: bool) Error!Fragment {
        const index = try builder.emit(instruction);
        return .{ .begin = index, .entry = index, .holes = builder.open_out(index), .nullable = nullable, .weight = 1 };
    }

    /// One octet from `lo` to `hi`.
    pub fn range(builder: *Builder, lo: u8, hi: u8) Error!Fragment {
        assert(lo <= hi);
        return builder.single(.{ .kind = .range, .lo = lo, .hi = hi }, false);
    }

    /// The empty string.
    pub fn empty(builder: *Builder) Error!Fragment {
        return builder.single(.{ .kind = .jump }, true);
    }

    /// An assertion, as the pattern reads it: the builder turns it around for a reverse program.
    pub fn look(builder: *Builder, forward: Look) Error!Fragment {
        const facing = if (builder.direction == .forward) forward else forward.reversed();
        return builder.single(.{ .kind = .look, .look = facing }, true);
    }

    /// No string at all.
    pub fn fail(builder: *Builder) Error!Fragment {
        const index = try builder.emit(.{ .kind = .fail });
        return .{ .begin = index, .entry = index, .holes = .{}, .nullable = false, .weight = 1 };
    }

    /// `first` then `second`, in the pattern's order.
    pub fn cat(builder: *Builder, first: Fragment, second: Fragment) Fragment {
        const head = if (builder.direction == .forward) first else second;
        const rest = if (builder.direction == .forward) second else first;
        builder.patch(head.holes, rest.entry);
        return .{
            .begin = @min(first.begin, second.begin),
            .entry = head.entry,
            .holes = rest.holes,
            .nullable = first.nullable and second.nullable,
            .weight = @max(first.weight, second.weight),
        };
    }

    /// `first` or `second`, and `first` when both match.
    pub fn alternate(builder: *Builder, first: Fragment, second: Fragment) Error!Fragment {
        const index = try builder.emit(.{ .kind = .split, .out = first.entry, .arg = second.entry });
        return .{
            .begin = @min(first.begin, second.begin),
            .entry = index,
            .holes = builder.join(first.holes, second.holes),
            .nullable = first.nullable or second.nullable,
            .weight = @max(first.weight, second.weight),
        };
    }

    /// A split that prefers `branch`, whose second target `set_second` writes once the pattern's
    /// next alternative is known.
    pub fn alternative(builder: *Builder, branch: u32) Error!u32 {
        return builder.emit(.{ .kind = .split, .out = branch, .arg = branch });
    }

    pub fn set_second(builder: *Builder, split: u32, entry: u32) void {
        assert(builder.instructions[split].kind == .split and entry < builder.len);
        builder.instructions[split].arg = entry;
    }

    /// A split that enters `body` or leaves through a hole, in the order `greed` asks.
    fn choice(builder: *Builder, body: u32, greed: Greed) Error!struct { index: u32, leave: Holes } {
        const index = try builder.emit(.{ .kind = .split, .out = body, .arg = body });
        const leave = if (greed == .greedy) builder.open_arg(index) else builder.open_out(index);
        return .{ .index = index, .leave = leave };
    }

    /// `operand` once or not at all.
    pub fn quest(builder: *Builder, operand: Fragment, greed: Greed) Error!Fragment {
        const split = try builder.choice(operand.entry, greed);
        return .{
            .begin = operand.begin,
            .entry = split.index,
            .holes = builder.join(operand.holes, split.leave),
            .nullable = true,
            .weight = operand.weight,
        };
    }

    /// `operand` once or more.
    pub fn plus(builder: *Builder, operand: Fragment, greed: Greed) Error!Fragment {
        const split = try builder.choice(operand.entry, greed);
        builder.patch(operand.holes, split.index);
        return .{
            .begin = operand.begin,
            .entry = operand.entry,
            .holes = split.leave,
            .nullable = operand.nullable,
            .weight = operand.weight,
        };
    }

    /// `operand` any number of times. An operand that matches the empty string is built as
    /// `(operand+)?`: a loop entered at its split would prefer one more empty pass to the text
    /// after the loop, which is not the order a backtracking matcher takes. RE2 and Go's regexp
    /// build it the same way.
    pub fn star(builder: *Builder, operand: Fragment, greed: Greed) Error!Fragment {
        if (operand.nullable) return builder.quest(try builder.plus(operand, greed), greed);
        const split = try builder.choice(operand.entry, greed);
        builder.patch(operand.holes, split.index);
        return .{
            .begin = operand.begin,
            .entry = split.index,
            .holes = split.leave,
            .nullable = true,
            .weight = operand.weight,
        };
    }

    /// `operand` as capture group `group`. A reverse program writes no slot.
    pub fn capture(builder: *Builder, operand: Fragment, group: u32) Error!Fragment {
        if (builder.direction == .reverse) return operand;
        assert(group < constants.groups_max);
        const open = try builder.emit(.{ .kind = .save, .arg = group * constants.group_slots, .out = operand.entry });
        const close = try builder.emit(.{ .kind = .save, .arg = group * constants.group_slots + 1 });
        builder.patch(operand.holes, close);
        return .{
            .begin = operand.begin,
            .entry = open,
            .holes = builder.open_out(close),
            .nullable = operand.nullable,
            .weight = operand.weight,
        };
    }

    /// A second block equal to the block from `fragment.begin` to `end`, at the program's end.
    /// The first block must hold the fragment whole, with every hole still open.
    pub fn copy(builder: *Builder, fragment: Fragment, end: u32) Error!Fragment {
        assert(fragment.begin < end and end <= builder.len);
        const shift = builder.len - fragment.begin;
        if (end - fragment.begin > builder.instructions.len - builder.len) return error.NoSpaceLeft;
        for (fragment.begin..end) |index| {
            var instruction = builder.instructions[index];
            const block: Block = .{ .begin = fragment.begin, .end = end, .shift = shift };
            if (has_out(instruction.kind)) instruction.out = block.moved(instruction.out);
            if (instruction.kind == .split) instruction.arg = block.moved(instruction.arg);
            _ = try builder.emit(instruction);
        }
        return .{
            .begin = fragment.begin + shift,
            .entry = fragment.entry + shift,
            .holes = .{ .head = moved_hole(fragment.holes.head, shift), .tail = moved_hole(fragment.holes.tail, shift) },
            .nullable = fragment.nullable,
            .weight = fragment.weight,
        };
    }

    /// Forgets every instruction from `begin` on.
    pub fn truncate(builder: *Builder, begin: u32) void {
        assert(begin <= builder.len);
        builder.len = begin;
    }
};

fn has_out(kind: program.Kind) bool {
    return switch (kind) {
        .range, .split, .save, .look, .jump => true,
        // A node's count of ranges is no target, and its ranges follow it.
        .ranges, .match, .fail => false,
    };
}

fn moved_hole(hole: u32, shift: u32) u32 {
    if (hole == constants.hole_none) return hole;
    return hole + constants.targets_per_instruction * shift;
}

/// A block that `copy` moves by `shift` instructions.
const Block = struct {
    begin: u32,
    end: u32,
    shift: u32,

    /// A target of the first block, as the second block holds it: a link to a hole of the block,
    /// or an instruction of the block.
    fn moved(block: Block, value: u32) u32 {
        if (value & constants.hole_flag != 0) {
            return constants.hole_flag | moved_hole(value & constants.hole_none, block.shift);
        }
        assert(block.begin <= value and value < block.end);
        return value + block.shift;
    }
};

const testing = std.testing;
const storage_len = 64;

fn test_builder(storage: *[storage_len]Instruction, direction: Direction) Builder {
    return .{ .instructions = storage, .direction = direction };
}

test "cat writes the second entry into the first fragment's holes, forward" {
    var storage: [storage_len]Instruction = undefined;
    var builder = test_builder(&storage, .forward);
    const first = try builder.range('a', 'a');
    const second = try builder.range('b', 'b');
    const both = builder.cat(first, second);
    try testing.expectEqual(first.entry, both.entry);
    try testing.expectEqual(second.entry, storage[first.entry].out);
    try testing.expectEqual(second.holes.head, both.holes.head);
    try testing.expect(!both.nullable);
}

test "cat links the second fragment to the first in a reverse program" {
    var storage: [storage_len]Instruction = undefined;
    var builder = test_builder(&storage, .reverse);
    const first = try builder.range('a', 'a');
    const second = try builder.range('b', 'b');
    const both = builder.cat(first, second);
    try testing.expectEqual(second.entry, both.entry);
    try testing.expectEqual(first.entry, storage[second.entry].out);
    try testing.expectEqual(first.holes.head, both.holes.head);
}

test "a greedy split prefers its operand and a lazy one the way out" {
    var storage: [storage_len]Instruction = undefined;
    var builder = test_builder(&storage, .forward);
    const greedy = try builder.quest(try builder.range('a', 'a'), .greedy);
    try testing.expectEqual(@as(u32, 0), storage[greedy.entry].out);
    try testing.expect(storage[greedy.entry].arg & constants.hole_flag != 0);
    const lazy = try builder.quest(try builder.range('b', 'b'), .lazy);
    try testing.expectEqual(@as(u32, 2), storage[lazy.entry].arg);
    try testing.expect(storage[lazy.entry].out & constants.hole_flag != 0);
    try testing.expect(greedy.nullable and lazy.nullable);
}

test "patch fills every hole of a joined list" {
    var storage: [storage_len]Instruction = undefined;
    var builder = test_builder(&storage, .forward);
    const either = try builder.alternate(try builder.range('a', 'a'), try builder.range('b', 'b'));
    const optional = try builder.quest(either, .greedy);
    const end = try builder.emit(.{ .kind = .match });
    builder.patch(optional.holes, end);
    for (storage[0..builder.len]) |instruction| {
        if (has_out(instruction.kind)) try testing.expect(instruction.out < builder.len);
        if (instruction.kind == .split) try testing.expect(instruction.arg < builder.len);
    }
    try testing.expectEqual(end, storage[0].out);
    try testing.expectEqual(end, storage[1].out);
    try testing.expectEqual(end, storage[optional.entry].arg);
}

test "star of an operand that matches the empty string is the operand once or more, or nothing" {
    var storage: [storage_len]Instruction = undefined;
    var builder = test_builder(&storage, .forward);
    const inner = try builder.star(try builder.range('a', 'a'), .greedy);
    try testing.expect(inner.nullable);
    const before = builder.len;
    const outer = try builder.star(inner, .greedy);
    // Two splits: the loop's, which the operand's holes return to, and the choice around it.
    try testing.expectEqual(before + 2, builder.len);
    try testing.expectEqual(before + 1, outer.entry);
    try testing.expectEqual(inner.entry, storage[outer.entry].out);
    try testing.expectEqual(before, storage[inner.entry].arg);
}

test "copy moves a block's targets and its holes, and leaves the first block as it was" {
    var storage: [storage_len]Instruction = undefined;
    var builder = test_builder(&storage, .forward);
    _ = try builder.range('x', 'x');
    const either = try builder.alternate(try builder.range('a', 'a'), try builder.range('b', 'b'));
    const end = builder.len;
    var first: [storage_len]Instruction = undefined;
    @memcpy(first[0..end], storage[0..end]);
    const second = try builder.copy(either, end);
    try testing.expectEqualSlices(u8, std.mem.sliceAsBytes(first[0..end]), std.mem.sliceAsBytes(storage[0..end]));
    try testing.expectEqual(end, second.begin);
    try testing.expectEqual(either.entry + 3, second.entry);
    try testing.expectEqual(second.begin, storage[second.entry].out);
    try testing.expectEqual(second.begin + 1, storage[second.entry].arg);
    // The second block's holes are its own: patching them leaves the first block's open.
    const done = try builder.emit(.{ .kind = .match });
    builder.patch(second.holes, done);
    try testing.expectEqual(done, storage[second.begin].out);
    try testing.expectEqual(done, storage[second.begin + 1].out);
    try testing.expect(storage[either.begin].out & constants.hole_flag != 0);
    try testing.expect(storage[either.begin + 1].out & constants.hole_flag != 0);
}

test "emit and copy refuse a program past its storage" {
    var storage: [storage_len]Instruction = undefined;
    var builder: Builder = .{ .instructions = storage[0..3], .direction = .forward };
    const either = try builder.alternate(try builder.range('a', 'a'), try builder.range('b', 'b'));
    try testing.expectError(error.NoSpaceLeft, builder.copy(either, builder.len));
    try testing.expectEqual(@as(u32, 3), builder.len);
    try testing.expectError(error.NoSpaceLeft, builder.emit(.{ .kind = .match }));
}

test "capture writes the two slots of its group around the operand, and nothing in reverse" {
    var storage: [storage_len]Instruction = undefined;
    var builder = test_builder(&storage, .forward);
    const group = try builder.capture(try builder.range('a', 'a'), 3);
    try testing.expectEqual(program.Kind.save, storage[group.entry].kind);
    try testing.expectEqual(@as(u32, 6), storage[group.entry].arg);
    try testing.expectEqual(@as(u32, 7), storage[storage[0].out].arg);
    var reverse = test_builder(&storage, .reverse);
    const plain = try reverse.capture(try reverse.range('a', 'a'), 3);
    try testing.expectEqual(@as(u32, 1), reverse.len);
    try testing.expectEqual(@as(u32, 0), plain.entry);
}
