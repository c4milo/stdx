//! A quantifier applied to its operand (decision 86): `*`, `+`, `?` and the range quantifier of
//! RFC 9485 §3, each greedy or lazy.
//!
//! A program holds no counter, so a range quantifier repeats its operand's block: `x{2,4}` is
//! `xx(x(x)?)?`. The copies cost instructions, which is why `repeat_max` bounds a count and the
//! product of nested counts.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const fragment = @import("fragment.zig");
const Builder = fragment.Builder;
const Fragment = fragment.Fragment;
const Greed = fragment.Greed;

pub const Error = fragment.Error || error{RepeatTooLarge};

/// The fewest and the most times an operand repeats. `max` is null where no count bounds it.
pub const Counts = struct {
    min: u32,
    max: ?u32,
};

/// The operand's block, handed out once for each time the operand stands in the program. Every
/// piece but the last is a copy, so the block stays whole, with its holes open, while copies are
/// made from it.
const Pieces = struct {
    builder: *Builder,
    operand: Fragment,
    end: u32,
    remaining: u32,

    fn take(pieces: *Pieces) fragment.Error!Fragment {
        assert(pieces.remaining > 0);
        pieces.remaining -= 1;
        if (pieces.remaining == 0) return pieces.operand;
        return pieces.builder.copy(pieces.operand, pieces.end);
    }
};

/// The operand repeated as `counts` asks. The operand must be the last fragment built.
pub fn apply(builder: *Builder, operand: Fragment, counts: Counts, greed: Greed) Error!Fragment {
    assert(counts.min <= constants.repeat_max);
    assert(counts.max == null or (counts.max.? >= counts.min and counts.max.? <= constants.repeat_max));
    const pieces_count = @max(counts.max orelse counts.min, 1);
    const weight = operand.weight * pieces_count;
    // RFC 9485 §8: an implementation may limit range quantifiers in composability, such as
    // (a{2,4}){2,4}, and in range. The product of nested counts stays at or under `repeat_max`.
    if (weight > constants.repeat_max) return error.RepeatTooLarge;
    if (counts.max == 0) {
        builder.truncate(operand.begin);
        return builder.empty();
    }
    var pieces: Pieces = .{ .builder = builder, .operand = operand, .end = builder.len, .remaining = pieces_count };
    var whole = try optional_tail(&pieces, counts, greed);
    const required = if (counts.max == null and counts.min > 0) counts.min - 1 else counts.min;
    for (0..required) |_| {
        const piece = try pieces.take();
        whole = if (whole) |rest| builder.cat(piece, rest) else piece;
    }
    assert(pieces.remaining == 0);
    var repeated = whole.?;
    repeated.begin = operand.begin;
    repeated.weight = weight;
    return repeated;
}

/// The part of a repetition past its required pieces: nested optional pieces up to a bound, or a
/// loop where no count bounds it.
fn optional_tail(pieces: *Pieces, counts: Counts, greed: Greed) fragment.Error!?Fragment {
    const builder = pieces.builder;
    const bound = counts.max orelse {
        const piece = try pieces.take();
        return if (counts.min == 0) try builder.star(piece, greed) else try builder.plus(piece, greed);
    };
    var tail: ?Fragment = null;
    for (counts.min..bound) |_| {
        const piece = try pieces.take();
        tail = try builder.quest(if (tail) |rest| builder.cat(piece, rest) else piece, greed);
    }
    return tail;
}

const testing = std.testing;
const program = @import("program.zig");
const storage_len = 64;

fn count_kind(instructions: []const program.Instruction, kind: program.Kind) u32 {
    var count: u32 = 0;
    for (instructions) |instruction| {
        if (instruction.kind == kind) count += 1;
    }
    return count;
}

fn build(storage: []program.Instruction, counts: Counts) !struct { builder: Builder, repeated: Fragment } {
    var builder: Builder = .{ .instructions = storage, .direction = .forward };
    const operand = try builder.range('a', 'a');
    const repeated = try apply(&builder, operand, counts, .greedy);
    return .{ .builder = builder, .repeated = repeated };
}

test "a range quantifier holds its operand once for each count, and a split for each optional one" {
    var storage: [storage_len]program.Instruction = undefined;
    const exact = try build(&storage, .{ .min = 3, .max = 3 });
    try testing.expectEqual(@as(u32, 3), count_kind(storage[0..exact.builder.len], .range));
    try testing.expectEqual(@as(u32, 0), count_kind(storage[0..exact.builder.len], .split));
    try testing.expect(!exact.repeated.nullable);
    const bounded = try build(&storage, .{ .min = 2, .max = 5 });
    try testing.expectEqual(@as(u32, 5), count_kind(storage[0..bounded.builder.len], .range));
    try testing.expectEqual(@as(u32, 3), count_kind(storage[0..bounded.builder.len], .split));
    const optional = try build(&storage, .{ .min = 0, .max = 2 });
    try testing.expectEqual(@as(u32, 2), count_kind(storage[0..optional.builder.len], .range));
    try testing.expect(optional.repeated.nullable);
}

test "a quantifier with no upper count loops on its last piece" {
    var storage: [storage_len]program.Instruction = undefined;
    const star = try build(&storage, .{ .min = 0, .max = null });
    try testing.expectEqual(@as(u32, 1), count_kind(storage[0..star.builder.len], .range));
    try testing.expect(star.repeated.nullable);
    const plus = try build(&storage, .{ .min = 1, .max = null });
    try testing.expectEqual(@as(u32, 1), count_kind(storage[0..plus.builder.len], .range));
    try testing.expect(!plus.repeated.nullable);
    const three = try build(&storage, .{ .min = 3, .max = null });
    try testing.expectEqual(@as(u32, 3), count_kind(storage[0..three.builder.len], .range));
    try testing.expectEqual(@as(u32, 1), count_kind(storage[0..three.builder.len], .split));
}

test "a count of zero leaves the empty string in the operand's place" {
    var storage: [storage_len]program.Instruction = undefined;
    const none = try build(&storage, .{ .min = 0, .max = 0 });
    try testing.expectEqual(@as(u32, 1), none.builder.len);
    try testing.expectEqual(program.Kind.jump, storage[0].kind);
    try testing.expect(none.repeated.nullable);
}

test "the product of nested counts stops at repeat_max" {
    var storage: [2048]program.Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    const operand = try builder.range('a', 'a');
    const ten = try apply(&builder, operand, .{ .min = 10, .max = 10 }, .greedy);
    try testing.expectEqual(@as(u32, 10), ten.weight);
    const thousand = try apply(&builder, ten, .{ .min = 0, .max = 100 }, .greedy);
    try testing.expectEqual(@as(u32, constants.repeat_max), thousand.weight);
    try testing.expectError(error.RepeatTooLarge, apply(&builder, thousand, .{ .min = 2, .max = 2 }, .greedy));
    try testing.expectError(error.RepeatTooLarge, apply(&builder, thousand, .{ .min = 2, .max = null }, .greedy));
    // A loop with no count repeats no block, so it adds nothing to the product.
    const looped = try apply(&builder, thousand, .{ .min = 0, .max = null }, .greedy);
    try testing.expectEqual(@as(u32, constants.repeat_max), looped.weight);
}

test "a repetition that does not fit its storage is refused whole" {
    var storage: [storage_len]program.Instruction = undefined;
    var builder: Builder = .{ .instructions = storage[0..8], .direction = .forward };
    const operand = try builder.range('a', 'a');
    try testing.expectError(error.NoSpaceLeft, apply(&builder, operand, .{ .min = 9, .max = 9 }, .greedy));
}
