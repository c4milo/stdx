//! Tests for the split driver, over a toy codec: one octet N, then N octets, then the stream ends.

const std = @import("std");
const testing = std.testing;
const split = @import("split.zig");
const Progress = @import("status.zig").Progress;
const Reader = @import("reader.zig").Reader;
const Writer = @import("writer.zig").Writer;

/// The toy decoder's state. It reads nothing ahead, so a call's counts are exact.
const Toy = struct {
    header_read: bool = false,
    remaining: u8 = 0,
};

fn toy_step(toy: *Toy, input: []const u8, output: []u8) !Progress {
    var reader = Reader.init(input);
    var writer = Writer.init(output);
    if (!toy.header_read) {
        toy.remaining = reader.read_octet() catch return .{ .consumed = 0, .written = 0, .status = .needs_input };
        toy.header_read = true;
    }
    // At most `toy.remaining` octets, 255 at most, so the loop is bounded by the header's octet.
    for (0..toy.remaining) |_| {
        if (writer.room_len() == 0) return .{ .consumed = reader.consumed(), .written = writer.position, .status = .needs_room };
        const octet = reader.read_octet() catch {
            return .{ .consumed = reader.consumed(), .written = writer.position, .status = .needs_input };
        };
        writer.write_octet(octet) catch unreachable;
        toy.remaining -= 1;
    }
    return .{ .consumed = reader.consumed(), .written = writer.position, .status = .done };
}

/// The toy with a defect invariant 12 names: it counts down through a pointer into itself, which a
/// move leaves pointing at the old slot.
const PointerToy = struct {
    header_read: bool = false,
    remaining: u8 = 0,
    counter: *u8 = undefined,
};

fn pointer_toy_step(toy: *PointerToy, input: []const u8, output: []u8) !Progress {
    var reader = Reader.init(input);
    var writer = Writer.init(output);
    if (!toy.header_read) {
        toy.remaining = reader.read_octet() catch return .{ .consumed = 0, .written = 0, .status = .needs_input };
        toy.counter = &toy.remaining;
        toy.header_read = true;
    }
    for (0..toy.counter.*) |_| {
        if (writer.room_len() == 0) return .{ .consumed = reader.consumed(), .written = writer.position, .status = .needs_room };
        const octet = reader.read_octet() catch {
            return .{ .consumed = reader.consumed(), .written = writer.position, .status = .needs_input };
        };
        writer.write_octet(octet) catch unreachable;
        toy.counter.* -= 1;
    }
    return .{ .consumed = reader.consumed(), .written = writer.position, .status = .done };
}

/// A toy stream of `len` body octets, and the octets that follow it.
fn toy_stream(buffer: []u8, len: u8, trailing: []const u8) []const u8 {
    buffer[0] = len;
    for (buffer[1..][0..len], 0..) |*octet, index| octet.* = @truncate(index);
    @memcpy(buffer[1 + len ..][0..trailing.len], trailing);
    return buffer[0 .. 1 + len + trailing.len];
}

test "every seed decodes the toy stream to its body and stops at its end" {
    var buffer: [300]u8 = undefined;
    const stream = toy_stream(&buffer, 200, "after");
    for (0..500) |seed| {
        var states: [2]Toy = .{ .{}, .{} };
        var output: [256]u8 = undefined;
        const outcome = try split.drive(Toy, &states, toy_step, stream, &output, seed);
        try testing.expectEqual(.done, outcome.status);
        try testing.expectEqual(201, outcome.consumed);
        try testing.expectEqualSlices(u8, stream[1..201], output[0..outcome.written]);
    }
}

test "a cut stream ends needing input, and a small output ends needing room" {
    var buffer: [300]u8 = undefined;
    const stream = toy_stream(&buffer, 100, "");
    for (0..100) |seed| {
        var states: [2]Toy = .{ .{}, .{} };
        var output: [256]u8 = undefined;
        const cut = try split.drive(Toy, &states, toy_step, stream[0..50], &output, seed);
        try testing.expectEqual(.needs_input, cut.status);
        try testing.expectEqual(50, cut.consumed);

        states = .{ .{}, .{} };
        const small = try split.drive(Toy, &states, toy_step, stream, output[0..30], seed);
        try testing.expectEqual(.needs_room, small.status);
        try testing.expectEqual(30, small.written);
    }
}

test "the driver catches a state that points into itself" {
    var buffer: [300]u8 = undefined;
    const stream = toy_stream(&buffer, 200, "");
    var caught: usize = 0;
    for (0..100) |seed| {
        var states: [2]PointerToy = .{ .{}, .{} };
        var output: [256]u8 = undefined;
        const outcome = split.drive(PointerToy, &states, pointer_toy_step, stream, &output, seed) catch {
            caught += 1;
            continue;
        };
        const right = outcome.status == .done and outcome.written == 200;
        if (!right) caught += 1;
    }
    // A seed that decodes the stream in one call, or reads the header only after the forced move
    // and then draws no other, leaves nothing to move mid-stream, and lets the defect pass. The
    // seeds are fixed, so the count is exact: 77 of these 100 catch it.
    try testing.expectEqual(77, caught);
}

test "a seed replays its schedule, and another seed draws another" {
    var first = split.Schedule.init(0xc0ffee);
    var again = split.Schedule.init(0xc0ffee);
    var other = split.Schedule.init(0xc0ffef);
    var differs = false;
    for (0..1000) |_| {
        const len = first.piece_len(100_000);
        try testing.expectEqual(len, again.piece_len(100_000));
        try testing.expectEqual(first.move_state(), again.move_state());
        if (other.piece_len(100_000) != len) differs = true;
        _ = other.move_state();
    }
    try testing.expect(differs);
}

test "the schedule draws every piece kind, within its bounds" {
    var schedule = split.Schedule.init(1);
    var seen = [_]bool{false} ** 5;
    for (0..10_000) |_| {
        const len = schedule.piece_len(100_000);
        const kind: usize = if (len == 0) 0 else if (len == 1) 1 else if (len <= 16) 2 else if (len <= 4096) 3 else 4;
        seen[kind] = true;
        try testing.expect(len <= 4096 or len == 100_000);
        try testing.expect(schedule.piece_len(3) <= 3);
    }
    for (seen) |kind_seen| try testing.expect(kind_seen);
}

test "the generator gives the published SplitMix64 values for seed 0" {
    var generator = split.Generator.init(0);
    try testing.expectEqual(0xe220a8397b1dcdaf, generator.next());
    try testing.expectEqual(0x6e789e6aa1b965f4, generator.next());
    try testing.expectEqual(0x06c45d188009454f, generator.next());
}
