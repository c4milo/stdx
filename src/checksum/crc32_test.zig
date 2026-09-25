//! Tests for CRC-32. The property: every path this CPU can run gives the CRC-32 a bit-by-bit
//! reference gives, from the definition in RFC 1952 §2.3.1 and §8, at every length up to a few
//! folds, at every alignment, and split in two anywhere. The fuzz test checks it over inputs Zig's
//! fuzzer draws. On a CPU whose target lacks the instructions of a path, that path is tested by
//! the differential check in `tools/`, which detects the CPU's features at run time.

const std = @import("std");
const testing = std.testing;
const constants = @import("constants.zig");
const crc32 = @import("crc32.zig");
const crc32_table = @import("crc32_table.zig");
const Crc32Path = crc32.Crc32Path;
const Features = @import("features.zig").Features;

/// The folds of 64 octets the seeded tests reach past: several, so the folding loop repeats.
const folds_checked = 4;

/// The longest input the seeded tests take at every length and alignment: past `folds_checked`
/// folds, a lane and a tail, so the folding path's every branch runs.
const len_max = folds_checked * constants.crc32_fold_len + constants.crc32_lane_len + constants.crc32_slice_len;

/// The alignments the seeded tests start at: one of each within a lane.
const offsets = constants.crc32_lane_len;

/// The largest input the fuzz test takes.
const fuzz_input_len_max = 1024;

/// The octets the seeded tests read: a fixed, irregular sequence.
const sample: [len_max + offsets]u8 = sample_octets();

fn sample_octets() [len_max + offsets]u8 {
    var octets: [len_max + offsets]u8 = undefined;
    var value: u32 = constants.crc32_polynomial;
    for (&octets) |*octet| {
        // A step of RFC 1952 §8's register, which cycles through every nonzero value.
        value = if (value & 1 != 0) constants.crc32_polynomial_reflected ^ (value >> 1) else value >> 1;
        octet.* = @truncate(value);
    }
    return octets;
}

/// The CRC-32 of the octets after `crc`, one bit at a time: RFC 1952 §2.3.1's definition, with the
/// reflected polynomial of §8 and the conditioning on entry and on exit.
fn reference(crc: u32, octets: []const u8) u32 {
    var register = crc ^ constants.crc32_conditioning;
    for (octets) |octet| {
        register ^= octet;
        for (0..@bitSizeOf(u8)) |_| {
            const low = register & 1;
            register >>= 1;
            if (low != 0) register ^= constants.crc32_polynomial_reflected;
        }
    }
    return register ^ constants.crc32_conditioning;
}

/// True when this CPU runs `path`, as the build target guarantees.
fn runs_here(path: Crc32Path) bool {
    return path.runs_on(Features.target());
}

test "the check value of every path: 0xcbf43926 for \"123456789\", 0 for nothing" {
    for (std.enums.values(Crc32Path)) |path| {
        if (!runs_here(path)) continue;
        try testing.expectEqual(0xcbf43926, crc32.update(path, 0, "123456789"));
        try testing.expectEqual(0, crc32.update(path, 0, ""));
        try testing.expectEqual(0xcbf43926, reference(0, "123456789"));
    }
}

test "the first table is RFC 1952 section 8's crc_table" {
    try testing.expectEqual(0, crc32_table.tables[0][0]);
    try testing.expectEqual(0x77073096, crc32_table.tables[0][1]);
    try testing.expectEqual(constants.crc32_polynomial_reflected, crc32_table.tables[0][128]);
    try testing.expectEqual(0x2d02ef8d, crc32_table.tables[0][255]);
}

test "every path equals the reference at every length and alignment" {
    for (std.enums.values(Crc32Path)) |path| {
        if (!runs_here(path)) continue;
        for (0..offsets) |offset| {
            for (0..len_max + 1) |len| {
                const octets = sample[offset..][0..len];
                const start: u32 = @truncate(offset *% 0x9e3779b9);
                try testing.expectEqual(reference(start, octets), crc32.update(path, start, octets));
            }
        }
    }
}

test "every path gives the same value however the input is split in two" {
    const octets = sample[0..len_max];
    const whole = reference(0, octets);
    for (std.enums.values(Crc32Path)) |path| {
        if (!runs_here(path)) continue;
        for (0..octets.len + 1) |cut| {
            const first = crc32.update(path, 0, octets[0..cut]);
            try testing.expectEqual(whole, crc32.update(path, first, octets[cut..]));
        }
    }
}

test "fastest picks the path the features allow on this architecture" {
    const arch = @import("builtin").cpu.arch;
    try testing.expectEqual(.table, Crc32Path.fastest(.{}));
    try testing.expectEqual(.table, Crc32Path.fastest(.{ .avx2 = true }));
    const pclmul: Crc32Path = if (arch == .x86_64) .pclmul else .table;
    try testing.expectEqual(pclmul, Crc32Path.fastest(.{ .pclmul = true, .avx2 = true }));
    const armv8: Crc32Path = if (arch == .aarch64) .armv8 else .table;
    try testing.expectEqual(armv8, Crc32Path.fastest(.{ .crc32 = true }));
    for (std.enums.values(Crc32Path)) |path| {
        try testing.expectEqual(path == .table or path == pclmul or path == armv8, path.built());
    }
}

test "the tests run every path the target's CPU model has" {
    // A path the target has but these tests skip would pass untested.
    const cpu = @import("builtin").cpu;
    switch (cpu.arch) {
        .x86_64 => if (std.Target.x86.featureSetHasAll(cpu.features, .{ .pclmul, .sse4_1 })) {
            try testing.expect(runs_here(.pclmul));
        },
        .aarch64 => if (std.Target.aarch64.featureSetHas(cpu.features, .crc)) {
            try testing.expect(runs_here(.armv8));
        },
        else => {},
    }
}

test "fuzz every path against the table path" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "", "123456789", &sample } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [fuzz_input_len_max]u8 = undefined;
    const octets = input[0..smith.slice(&input)];
    const cut = smith.valueRangeAtMost(u16, 0, @intCast(octets.len));
    const start = smith.value(u32);
    const whole = crc32.update(.table, start, octets);
    for (std.enums.values(Crc32Path)) |path| {
        if (!runs_here(path)) continue;
        try testing.expectEqual(whole, crc32.update(path, start, octets));
        const first = crc32.update(path, start, octets[0..cut]);
        try testing.expectEqual(whole, crc32.update(path, first, octets[cut..]));
    }
}
