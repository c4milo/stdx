//! Fills of octets that never reach Zig's own `memset`. Zig 0.16's compiler runtime defines
//! `memset` one octet at a time and exports it weak and hidden, so on Linux a program's own copy
//! serves every `@memset` that LLVM does not expand inline, glibc linked or not: a clear of 32 KiB
//! took 33,500 cycles on a Neoverse N2 (design §8 step 9, 2026-09-29). A Darwin program calls
//! libSystem's `memset` instead, which zeroes a cache line an instruction and took 1,200 cycles on
//! an M1, so there `fill` is `@memset`.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");

const Vector = @Vector(constants.fill_vector_len, u8);

/// The octets one pass of `fill` stores before its barrier.
const pass_len = constants.fill_vector_len * constants.fill_pass_vectors;

/// Sets every octet of `octets` to `value`: libSystem's `memset` on Darwin, and `fill_vectors`
/// everywhere else.
pub fn fill(octets: []u8, value: u8) void {
    if (comptime builtin.os.tag.isDarwin()) {
        @memset(octets, value);
        return;
    }
    fill_vectors(octets, value);
}

/// Sets every octet of `octets` to `value`, `pass_len` octets a pass. A barrier after each pass
/// keeps LLVM from turning the loop back into a `memset` call. A length that is not a whole number
/// of passes ends with a pass that overlaps the one before it; a length under one pass is set an
/// octet at a time, behind the same barrier.
pub fn fill_vectors(octets: []u8, value: u8) void {
    const splat: Vector = @splat(value);
    if (octets.len < pass_len) {
        for (octets) |*octet| {
            octet.* = value;
            std.mem.doNotOptimizeAway(octet);
        }
        return;
    }
    for (0..octets.len / pass_len) |pass| store_pass(octets[pass * pass_len ..][0..pass_len], splat);
    if (octets.len % pass_len != 0) store_pass(octets[octets.len - pass_len ..][0..pass_len], splat);
}

inline fn store_pass(pass: *[pass_len]u8, splat: Vector) void {
    inline for (0..constants.fill_pass_vectors) |vector| {
        pass[vector * constants.fill_vector_len ..][0..constants.fill_vector_len].* = splat;
    }
    // The pass's address, handed to an empty assembly block that clobbers memory: the stores
    // before it cannot merge with the next pass's into one `memset`.
    std.mem.doNotOptimizeAway(pass);
}

comptime {
    assert(std.math.isPowerOfTwo(pass_len));
}

// Tests.

const testing = std.testing;

test "fill_vectors sets every octet of every length at every offset, and no octet outside" {
    const guard = 0x5a;
    const lengths_max = 3 * pass_len + 1;
    const offsets = pass_len;
    var buffer: [offsets + lengths_max + 1]u8 = undefined;
    for (0..offsets) |offset| {
        for (0..lengths_max) |len| {
            @memset(&buffer, guard);
            fill_vectors(buffer[offset..][0..len], 0x3c);
            for (buffer, 0..) |octet, index| {
                const inside = index >= offset and index < offset + len;
                try testing.expectEqual(@as(u8, if (inside) 0x3c else guard), octet);
            }
        }
    }
}

test "fill sets the octets it is given" {
    var buffer: [3 * pass_len]u8 = @splat(1);
    fill(buffer[1 .. buffer.len - 1], 0);
    try testing.expectEqual(1, buffer[0]);
    try testing.expectEqual(1, buffer[buffer.len - 1]);
    for (buffer[1 .. buffer.len - 1]) |octet| try testing.expectEqual(0, octet);
}
