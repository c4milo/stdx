//! loadchain: the latency of a dependent chain of L1 loads through a 2048-entry table of u32, as
//! the fast path's literal lookups take it, indexed three ways: a scaled register (`table[index]`,
//! `ldr w, [x, x, lsl #2]` / `mov r, [r + r*4]`), a byte offset kept in the chain (`ldr w, [x, x]`
//! / `mov r, [r + r]`), and the byte offset with the entry's low bits masked first, as a lookup
//! masks the bit buffer. Prints nanoseconds per load for each.
const std = @import("std");

const len = 2048;
const rounds = 50_000_000;

fn scaled(table: *const [len]u32) u32 {
    var index: u32 = 0;
    for (0..rounds) |_| index = table[index];
    return index;
}

fn byte_offset(table: *const [len]u32) u32 {
    const octets: [*]const u8 = @ptrCast(table);
    var offset: u32 = 0;
    for (0..rounds) |_| offset = @as(*align(1) const u32, @ptrCast(octets + offset)).*;
    return offset;
}

fn masked_scaled(table: *const [len]u32) u32 {
    var bits: u32 = 0;
    for (0..rounds) |_| bits = table[bits & (len - 1)];
    return bits;
}

fn masked_byte_offset(table: *const [len]u32) u32 {
    const octets: [*]const u8 = @ptrCast(table);
    var bits: u32 = 0;
    for (0..rounds) |_| bits = @as(*align(1) const u32, @ptrCast(octets + (bits & ((len - 1) << 2)))).*;
    return bits;
}

fn time(io: std.Io, comptime f: fn (*const [len]u32) u32, table: *const [len]u32) f64 {
    var best: f64 = 1e18;
    for (0..5) |_| {
        const start = std.Io.Timestamp.now(io, .awake);
        std.mem.doNotOptimizeAway(f(table));
        const ns: f64 = @floatFromInt(start.durationTo(std.Io.Timestamp.now(io, .awake)).nanoseconds);
        best = @min(best, ns / rounds);
    }
    return best;
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    // One cycle through every entry in a shuffled order, so each load's address depends on the
    // load before it. The byte-offset tables hold the same permutation as offsets.
    var order: [len]u32 = undefined;
    for (&order, 0..) |*o, i| o.* = @intCast(i);
    var generator = std.Random.DefaultPrng.init(7);
    generator.random().shuffle(u32, order[1..]);
    var table: [len]u32 = undefined;
    var offsets: [len]u32 = undefined;
    for (0..len) |i| {
        table[order[i]] = order[(i + 1) % len];
        offsets[order[i]] = order[(i + 1) % len] * 4;
    }
    var buffer: [256]u8 = undefined;
    var stdout = std.Io.File.stdout().writerStreaming(io, &buffer);
    const out = &stdout.interface;
    try out.print("scaled index        {d:.3} ns/load\n", .{time(io, scaled, &table)});
    try out.print("byte offset         {d:.3} ns/load\n", .{time(io, byte_offset, &offsets)});
    try out.print("masked, scaled      {d:.3} ns/load\n", .{time(io, masked_scaled, &table)});
    try out.print("masked, byte offset {d:.3} ns/load\n", .{time(io, masked_byte_offset, &offsets)});
    try out.flush();
}
