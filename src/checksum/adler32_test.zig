//! Tests for Adler-32. The property: every path this CPU can run gives the Adler-32 that RFC 1950
//! §9's sample code gives, reducing modulo 65521 after every octet, at every length up to a few
//! vector blocks, at every alignment, split in two anywhere, and over runs of 0xff long enough to
//! reach RFC 1950 §8.2's bound on octets between reductions. The fuzz test checks it over inputs
//! Zig's fuzzer draws.

const std = @import("std");
const testing = std.testing;
const constants = @import("constants.zig");
const adler32 = @import("adler32.zig");
const adler32_vector = @import("adler32_vector.zig");
const Adler32Path = adler32.Adler32Path;
const Features = @import("features.zig").Features;

/// The longest input the seeded tests take at every length and alignment: several blocks of the
/// widest vector path and a tail.
const len_max = 300;

/// The alignments the seeded tests start at.
const offsets = 32;

/// The largest input the fuzz test takes.
const fuzz_input_len_max = 1024;

/// The octets the seeded tests read: a fixed, irregular sequence.
const sample: [len_max + offsets]u8 = sample_octets();

/// Multiplier and increment of the sequence `sample` holds: Knuth's MMIX linear congruential
/// generator, whose high octets vary.
const sample_multiplier: u64 = 6364136223846793005;
const sample_increment: u64 = 1442695040888963407;
const sample_shift = @bitSizeOf(u64) - @bitSizeOf(u8);

fn sample_octets() [len_max + offsets]u8 {
    var octets: [len_max + offsets]u8 = undefined;
    var value: u64 = 0;
    for (&octets) |*octet| {
        value = value *% sample_multiplier +% sample_increment;
        octet.* = @intCast(value >> sample_shift);
    }
    return octets;
}

/// RFC 1950 §9's update_adler32, reducing after every octet.
fn reference(adler: u32, octets: []const u8) u32 {
    var s1: u32 = adler & std.math.maxInt(u16);
    var s2: u32 = adler >> @bitSizeOf(u16);
    for (octets) |octet| {
        s1 = (s1 + octet) % constants.adler32_base;
        s2 = (s2 + s1) % constants.adler32_base;
    }
    return (s2 << @bitSizeOf(u16)) + s1;
}

/// True when this CPU runs `path`, as the build target guarantees.
fn runs_here(path: Adler32Path) bool {
    return path.runs_on(Features.target());
}

/// The largest start a caller may pass: both sums one below the modulus.
const start_max: u32 = ((constants.adler32_base - 1) << @bitSizeOf(u16)) | (constants.adler32_base - 1);

test "the check values of every path: 0x11e60398 for \"Wikipedia\", 1 for nothing" {
    for (std.enums.values(Adler32Path)) |path| {
        if (!runs_here(path)) continue;
        try testing.expectEqual(0x11e60398, adler32.update(path, constants.adler32_initial, "Wikipedia"));
        try testing.expectEqual(1, adler32.update(path, constants.adler32_initial, ""));
    }
    try testing.expectEqual(0x11e60398, reference(constants.adler32_initial, "Wikipedia"));
}

test "every path equals the reference at every length and alignment" {
    for (std.enums.values(Adler32Path)) |path| {
        if (!runs_here(path)) continue;
        for (0..offsets) |offset| {
            for (0..len_max + 1) |len| {
                const octets = sample[offset..][0..len];
                const start: u32 = if (offset % 2 == 0) constants.adler32_initial else start_max;
                try testing.expectEqual(reference(start, octets), adler32.update(path, start, octets));
            }
        }
    }
}

test "every path gives the same value however the input is split in two" {
    const octets = sample[0..len_max];
    const whole = reference(constants.adler32_initial, octets);
    for (std.enums.values(Adler32Path)) |path| {
        if (!runs_here(path)) continue;
        for (0..octets.len + 1) |cut| {
            const first = adler32.update(path, constants.adler32_initial, octets[0..cut]);
            try testing.expectEqual(whole, adler32.update(path, first, octets[cut..]));
        }
    }
}

test "every path holds RFC 1950 section 8.2's bound over runs of 0xff from the largest start" {
    const ones: [3 * constants.adler32_deferral_len + 64]u8 = @splat(0xff);
    const lengths = [_]usize{
        constants.adler32_deferral_len - 1,     constants.adler32_deferral_len,
        constants.adler32_deferral_len + 1,     2 * constants.adler32_deferral_len + 31,
        3 * constants.adler32_deferral_len + 1, ones.len,
    };
    for (std.enums.values(Adler32Path)) |path| {
        if (!runs_here(path)) continue;
        for (lengths) |len| {
            try testing.expectEqual(reference(start_max, ones[0..len]), adler32.update(path, start_max, ones[0..len]));
        }
    }
}

test "the vector path equals the reference at every width a variant uses, on any CPU" {
    // The AVX2 and AVX-512 objects run this code at 64 and 128 octets, which a CPU without them
    // cannot call there.
    inline for (.{ 16, 32, 64, 128 }) |lanes| {
        for (0..offsets) |offset| {
            for (0..len_max + 1) |len| {
                const octets = sample[offset..][0..len];
                try testing.expectEqual(reference(start_max, octets), adler32_vector.update(lanes, start_max, octets));
            }
        }
        const ones: [2 * constants.adler32_deferral_len + lanes + 1]u8 = @splat(0xff);
        try testing.expectEqual(reference(start_max, &ones), adler32_vector.update(lanes, start_max, &ones));
    }
}

test "fastest picks the path the features allow on this architecture" {
    const arch = @import("builtin").cpu.arch;
    try testing.expectEqual(.vector, Adler32Path.fastest(.{}));
    try testing.expectEqual(.vector, Adler32Path.fastest(.{ .pclmul = true, .crc32 = true }));
    const avx2: Adler32Path = if (arch == .x86_64) .avx2 else .vector;
    try testing.expectEqual(avx2, Adler32Path.fastest(.{ .avx2 = true }));
    const avx512: Adler32Path = if (arch == .x86_64) .avx512 else .vector;
    try testing.expectEqual(avx512, Adler32Path.fastest(.{ .avx2 = true, .avx512 = true }));
    try testing.expectEqual(arch == .x86_64, Adler32Path.avx2.built());
    try testing.expectEqual(arch == .x86_64, Adler32Path.avx512.built());
}

test "the tests run every path the target's CPU model has" {
    // A path the target has but these tests skip would pass untested.
    const cpu = @import("builtin").cpu;
    if (cpu.arch == .x86_64 and std.Target.x86.featureSetHas(cpu.features, .avx2)) {
        try testing.expect(runs_here(.avx2));
    }
    if (cpu.arch == .x86_64 and std.Target.x86.featureSetHasAll(cpu.features, .{ .avx512f, .avx512bw, .avx512vl })) {
        try testing.expect(runs_here(.avx512));
    }
    try testing.expect(runs_here(.scalar) and runs_here(.vector));
}

test "fuzz every path against the scalar path" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "", "Wikipedia", &sample } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [fuzz_input_len_max]u8 = undefined;
    const octets = input[0..smith.slice(&input)];
    const cut = smith.valueRangeAtMost(u16, 0, @intCast(octets.len));
    const s1 = smith.valueRangeAtMost(u32, 0, constants.adler32_base - 1);
    const s2 = smith.valueRangeAtMost(u32, 0, constants.adler32_base - 1);
    const start = (s2 << @bitSizeOf(u16)) | s1;
    const whole = adler32.update(.scalar, start, octets);
    for (std.enums.values(Adler32Path)) |path| {
        if (!runs_here(path)) continue;
        try testing.expectEqual(whole, adler32.update(path, start, octets));
        const first = adler32.update(path, start, octets[0..cut]);
        try testing.expectEqual(whole, adler32.update(path, first, octets[cut..]));
    }
}
