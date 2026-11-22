//! A `memset` of vector stores, which a program exports as its own (decision 41 as amended on
//! 2026-11-22).
//!
//! Zig 0.16's compiler runtime defines `memset` one octet at a time. On Linux that copy serves
//! every `memset` in a program, glibc linked or not: each `@memset` whose length is known only at
//! run time, the fill of a large `undefined` local in a safe build, and the C code the program
//! links. stdx's modules call `@memset` and never export `memset`, since a library that exports it
//! collides with its caller's. The program owns the symbol, and exports this one from its root:
//!
//!     comptime {
//!         if (platform.memset_applies) @export(&platform.memset, .{ .name = "memset" });
//!     }
//!
//! `memset_applies` holds on Linux under Zig 0.16 alone: macOS links libSystem's `memset`, and
//! Zig's next release stores vectors, so the export goes with the upgrade.
const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;

/// The minor release of Zig 0 whose compiler runtime fills one octet at a time.
const octet_fill_zig_minor = 16;

/// True where a program exports `memset`: Linux, under Zig 0.16.
pub const applies = builtin.os.tag == .linux and
    builtin.zig_version.major == 0 and builtin.zig_version.minor == octet_fill_zig_minor;

/// The octets one store writes.
const vector_len = 32;

comptime {
    assert(std.math.isPowerOfTwo(vector_len));
}

/// C's `memset`: `len` octets of the low octet of `value` from `destination`, which it returns.
/// The barrier in each loop keeps the compiler from turning the loop into a call to `memset`,
/// which is this function.
pub fn memset(destination: ?[*]u8, value: c_int, len: usize) callconv(.c) ?[*]u8 {
    @setRuntimeSafety(false);
    const octets = destination orelse return destination;
    const octet: u8 = @truncate(@as(c_uint, @bitCast(value)));
    if (len < vector_len) {
        for (0..len) |index| {
            octets[index] = octet;
            std.mem.doNotOptimizeAway(octets);
        }
        return destination;
    }
    const fill: @Vector(vector_len, u8) = @splat(octet);
    for (0..len / vector_len) |store| {
        octets[store * vector_len ..][0..vector_len].* = fill;
        std.mem.doNotOptimizeAway(octets);
    }
    // The last store overlaps the one before it where the length is not a whole number of stores.
    octets[len - vector_len ..][0..vector_len].* = fill;
    return destination;
}

const testing = std.testing;

/// The octets of the test's buffer, the guard octets around each fill, and the octet they hold.
const test_buffer_len = 300;
const test_guard_len = 3;
const test_guard = 0x5A;

/// Fills `len` octets of a guarded buffer from `start`, and requires the fill and the guards.
fn expect_fill(buffer: *[test_buffer_len]u8, start: usize, value: c_int, len: usize) !void {
    @memset(buffer, test_guard);
    try testing.expectEqual(@as(?[*]u8, buffer[start..].ptr), memset(buffer[start..].ptr, value, len));
    const octet: u8 = @truncate(@as(c_uint, @bitCast(value)));
    for (buffer[start..][0..len]) |written| try testing.expectEqual(octet, written);
    for (buffer[0..start]) |kept| try testing.expectEqual(@as(u8, test_guard), kept);
    for (buffer[start + len ..]) |kept| try testing.expectEqual(@as(u8, test_guard), kept);
}

test "memset writes each octet of the length at every offset, and no octet around them" {
    var buffer: [test_buffer_len]u8 = undefined;
    const fills = [_]c_int{ 0, 0xFF, 0x1A7 };
    for (fills) |value| {
        for (0..2 * vector_len) |offset| {
            for (0..test_buffer_len - offset - 2 * test_guard_len) |len| {
                try expect_fill(&buffer, offset + test_guard_len, value, len);
            }
        }
    }
}

test "memset of a null destination writes nothing and gives it back" {
    try testing.expectEqual(@as(?[*]u8, null), memset(null, 0, vector_len));
}
