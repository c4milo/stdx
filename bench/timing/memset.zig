//! A `memset` of the benchmark program's own, which the linker takes in place of compiler_rt's.
//! Zig 0.16's stores one octet at a time, and on Linux it serves every `memset` call in a program,
//! glibc linked or not: stdx's and the baselines' C code alike (pepegrillo's
//! `docs/performance/performance_zig.md`, "Copies and fills"). macOS links libSystem's, and Zig's
//! next release writes vector stores, so the export is kept to Linux and Zig 0.16 and goes with the
//! upgrade. It lives in the benchmarks' timing module, which every benchmark program imports, and
//! never in the library: a library that exports `memset` collides with its caller's.

const std = @import("std");
const builtin = @import("builtin");

comptime {
    const zig_0_16 = builtin.zig_version.major == 0 and builtin.zig_version.minor == 16;
    if (builtin.os.tag == .linux and zig_0_16) @export(&memset, .{ .name = "memset" });
}

/// The octets one store sets.
const vector_len = 32;

fn memset(dest: ?[*]u8, value: u8, len: usize) callconv(.c) ?[*]u8 {
    @setRuntimeSafety(false);
    const octets = dest orelse return dest;
    const splat: @Vector(vector_len, u8) = @splat(value);
    if (len < vector_len) {
        for (0..len) |index| {
            octets[index] = value;
            // The barrier in each loop keeps the compiler from turning the loop back into a call
            // to `memset`, which is this function.
            std.mem.doNotOptimizeAway(octets);
        }
        return dest;
    }
    for (0..len / vector_len) |store| {
        octets[store * vector_len ..][0..vector_len].* = splat;
        std.mem.doNotOptimizeAway(octets);
    }
    // The last store overlaps the one before it when the length is not a whole number of stores.
    octets[len - vector_len ..][0..vector_len].* = splat;
    return dest;
}
