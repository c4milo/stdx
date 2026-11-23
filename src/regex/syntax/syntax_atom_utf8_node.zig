//! One node of a class's automaton as instructions (decision 86 as amended).
//!
//! A `ranges` takes an octet of one of the ranges after it, which it finds by halving, so its
//! ranges go in ascending order and stand apart. A node of the forward automaton holds such
//! transitions: two sequences that share the octets before a node take apart octets there. It is
//! written as a `ranges` and its ranges, and a matcher reading the class keeps one thread for it.
//!
//! A node of the reverse automaton need not: `[D0][80-8F]` and `[D1][80-BF]` both end in
//! continuation octets, and read back from their last octets the root takes `80-8F` toward `D0`
//! and `80-BF` toward `D1`. Such a node is written as its ranges joined by splits. Rust's regex
//! crate keeps such a node too, by default; its range trie, which cuts the ranges apart, is an
//! option it leaves off (regex-automata 0.4.19, `Config::shrink`). Cut apart, the reverse
//! automaton of `\p{L}` took 8,765 instructions in place of about 2,600.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const fragment = @import("../fragment.zig");
const program = @import("../program.zig");
const Builder = fragment.Builder;
const Holes = fragment.Holes;
const Instruction = program.Instruction;

/// The target of a transition that leaves the class: a hole of the class's fragment.
pub const exit = std.math.maxInt(u32);

pub const Transition = struct { lo: u8, hi: u8, next: u32 };

/// True when each transition starts after the one before it ends.
pub fn apart(node: []const Transition) bool {
    for (node[1..], node[0 .. node.len - 1]) |transition, before| {
        if (before.hi >= transition.lo) return false;
    }
    return true;
}

/// Writes a node of apart transitions: a `ranges` where it holds more than one, then one range
/// for each, to its target or to a hole of the class joined to `holes`. Gives its entry.
pub fn write_apart(builder: *Builder, holes: *Holes, node: []const Transition) fragment.Error!u32 {
    assert(node.len > 0 and apart(node));
    // `program.step_ranges` reads `arg` members, each a range, and asserts neither.
    assert(node.len <= constants.octet_values);
    const first = builder.len;
    if (node.len > 1) _ = try builder.emit(.{ .kind = .ranges, .arg = @intCast(node.len) });
    for (node) |transition| _ = try write_range(builder, holes, transition);
    return first;
}

/// Writes a node whose transitions may overlap: its ranges, then the splits that join them, the
/// last first, so that the entry is the last instruction written. Gives its entry.
pub fn write_split(builder: *Builder, holes: *Holes, node: []const Transition) fragment.Error!u32 {
    assert(node.len > 0);
    const first = builder.len;
    for (node) |transition| _ = try write_range(builder, holes, transition);
    var entry = builder.len - 1;
    for (1..node.len) |back| {
        const index: u32 = @intCast(node.len - 1 - back);
        entry = try builder.emit(.{ .kind = .split, .out = first + index, .arg = entry });
    }
    return entry;
}

/// One range to its target, or to a hole of the class joined to `holes`.
fn write_range(builder: *Builder, holes: *Holes, transition: Transition) fragment.Error!u32 {
    if (transition.next != exit) return builder.emit(.{ .kind = .range, .lo = transition.lo, .hi = transition.hi, .out = transition.next });
    const piece = try builder.range(transition.lo, transition.hi);
    holes.* = builder.join(holes.*, piece.holes);
    return piece.entry;
}

const testing = std.testing;

/// The instructions a test's nodes take at most.
const test_storage_len = 16;

test "a node of apart transitions is a ranges, then its ranges" {
    var storage: [test_storage_len]Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .forward };
    var holes: Holes = .{};
    const target = try builder.emit(.{ .kind = .fail });
    const node = [_]Transition{
        .{ .lo = 'a', .hi = 'c', .next = target },
        .{ .lo = constants.continuation_min, .hi = constants.continuation_max, .next = exit },
    };
    const entry = try write_apart(&builder, &holes, &node);
    try testing.expectEqual(program.Kind.ranges, storage[entry].kind);
    try testing.expectEqual(@as(u32, 2), storage[entry].arg);
    try testing.expectEqual(target, program.step(builder.instructions[0..builder.len], entry, 'b').?);
    try testing.expect(program.step(builder.instructions[0..builder.len], entry, 'd') == null);
    try testing.expect(!holes.is_empty());
    // A node of one transition is its range.
    const one = try write_apart(&builder, &holes, node[0..1]);
    try testing.expectEqual(program.Kind.range, storage[one].kind);
}

test "a node of transitions that overlap is its ranges joined by splits" {
    var storage: [test_storage_len]Instruction = undefined;
    var builder: Builder = .{ .instructions = &storage, .direction = .reverse };
    var holes: Holes = .{};
    const toward_d0 = try builder.emit(.{ .kind = .fail });
    const toward_d1 = try builder.emit(.{ .kind = .fail });
    const node = [_]Transition{
        .{ .lo = 0x80, .hi = 0x8F, .next = toward_d0 },
        .{ .lo = 0x80, .hi = 0xBF, .next = toward_d1 },
    };
    try testing.expect(!apart(&node));
    // Two ranges that share one octet overlap too.
    try testing.expect(!apart(&.{ .{ .lo = 'a', .hi = 'c', .next = exit }, .{ .lo = 'c', .hi = 'e', .next = exit } }));
    try testing.expect(apart(&.{ .{ .lo = 'a', .hi = 'c', .next = exit }, .{ .lo = 'd', .hi = 'e', .next = exit } }));
    const entry = try write_split(&builder, &holes, &node);
    const split = storage[entry];
    try testing.expectEqual(program.Kind.split, split.kind);
    try testing.expectEqual(toward_d0, storage[split.out].out);
    try testing.expectEqual(toward_d1, storage[split.arg].out);
    try testing.expect(apart(node[0..1]));
}
