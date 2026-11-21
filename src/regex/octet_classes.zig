//! The classes of the 256 octets for one program (decision 86): two octets of one class pass the
//! same ranges and read the same to every assertion, so a table of a matcher's states needs one
//! column for each class, not one for each octet.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program = @import("program.zig");
const Instruction = program.Instruction;

pub const Classes = struct {
    of: [constants.octet_values]u8,
    count: u16,
};

/// The octets where a new class starts.
const Starts = struct {
    at: [constants.octet_values + 1]bool = @splat(false),

    fn cut(starts: *Starts, lo: u8, hi: u8) void {
        starts.at[lo] = true;
        starts.at[@as(u32, hi) + 1] = true;
    }
};

/// The classes of a program's octets. `has_looks` says the program holds an assertion, which
/// tells a line feed and the word characters from the other octets. The continuation octets of
/// UTF-8 are classes of their own, because no match starts before one.
pub fn compute(instructions: []const Instruction, has_looks: bool) Classes {
    var starts: Starts = .{};
    starts.cut(constants.continuation_min, constants.continuation_max);
    for (instructions) |instruction| {
        if (instruction.kind == .range) starts.cut(instruction.lo, instruction.hi);
    }
    if (has_looks) {
        starts.cut(constants.line_feed, constants.line_feed);
        starts.cut('0', '9');
        starts.cut('A', 'Z');
        starts.cut('_', '_');
        starts.cut('a', 'z');
    }
    var classes: Classes = .{ .of = undefined, .count = 1 };
    for (&classes.of, 0..) |*class, octet| {
        if (octet != 0 and starts.at[octet]) classes.count += 1;
        class.* = @intCast(classes.count - 1);
    }
    assert(classes.count <= constants.octet_values);
    return classes;
}

const testing = std.testing;

test "octets that every range takes or refuses together share a class" {
    const instructions = [_]Instruction{
        .{ .kind = .range, .lo = 'a', .hi = 'f' },
        .{ .kind = .range, .lo = 'c', .hi = 'c' },
        .{ .kind = .match },
    };
    const classes = compute(&instructions, false);
    // Below a, a to b, c, d to f, above f to 7F, the continuation octets, C0 and above.
    try testing.expectEqual(@as(u16, 7), classes.count);
    try testing.expectEqual(classes.of[0], classes.of['a' - 1]);
    try testing.expectEqual(classes.of['a'], classes.of['b']);
    try testing.expect(classes.of['b'] != classes.of['c']);
    try testing.expect(classes.of['c'] != classes.of['d']);
    try testing.expectEqual(classes.of['d'], classes.of['f']);
    try testing.expectEqual(classes.of['g'], classes.of[constants.one_octet_max]);
    try testing.expect(classes.of[constants.continuation_min] != classes.of[constants.one_octet_max]);
    try testing.expectEqual(classes.of[constants.continuation_min], classes.of[constants.continuation_max]);
    try testing.expect(classes.of[constants.continuation_max] != classes.of[constants.octet_max]);
    for (classes.of[0 .. constants.octet_values - 1], classes.of[1..]) |class, next| {
        try testing.expect(next == class or next == class + 1);
    }
}

test "a program with no range has the three classes the continuation octets cut" {
    try testing.expectEqual(@as(u16, 3), compute(&.{.{ .kind = .match }}, false).count);
    const every = compute(&.{.{ .kind = .range, .lo = 0, .hi = constants.octet_max }}, false);
    try testing.expectEqual(@as(u16, 3), every.count);
}

test "a program with an assertion tells the line feed and the word characters apart" {
    const classes = compute(&.{.{ .kind = .match }}, true);
    try testing.expect(classes.of['\n'] != classes.of['\n' - 1]);
    try testing.expect(classes.of['\n'] != classes.of['\n' + 1]);
    for ([_]u8{ '0', 'A', '_', 'a' }) |first| try testing.expect(classes.of[first] != classes.of[first - 1]);
    for ([_]u8{ '9', 'Z', '_', 'z' }) |last| try testing.expect(classes.of[last] != classes.of[last + 1]);
    for (0..constants.octet_values) |octet| {
        for (0..constants.octet_values) |other| {
            if (classes.of[octet] != classes.of[other]) continue;
            try testing.expectEqual(program.Context.of(@intCast(octet)), program.Context.of(@intCast(other)));
        }
    }
}

test "a range for each octet gives each octet its own class" {
    var instructions: [constants.octet_values]Instruction = undefined;
    for (&instructions, 0..) |*instruction, octet| {
        instruction.* = .{ .kind = .range, .lo = @intCast(octet), .hi = @intCast(octet) };
    }
    const classes = compute(&instructions, false);
    try testing.expectEqual(@as(u16, constants.octet_values), classes.count);
    for (classes.of, 0..) |class, octet| try testing.expectEqual(octet, class);
}
