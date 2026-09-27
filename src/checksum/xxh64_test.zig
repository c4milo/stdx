//! Tests for XXH64. The property: however the input is split across `update` calls, the state
//! gives the value that a direct reading of the specification's steps gives over the whole input,
//! at every length up to several stripes, from seeds that wrap Step 1's sums. The specification
//! gives no test values; `zig build differential-checksum -Doracles` compares the low 32 bits with
//! libzstd's Content_Checksum over the corpora (design §8 step 10). The fuzz test checks the
//! property over inputs and splits Zig's fuzzer draws.

const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const constants = @import("constants.zig");
const xxh64_module = @import("xxh64.zig");
const Xxh64 = xxh64_module.Xxh64;
const Xxh64Path = xxh64_module.Xxh64Path;
const Features = @import("features.zig").Features;

/// Every path this build's target runs without detection.
const paths = target_paths();

fn target_paths() []const Xxh64Path {
    comptime var found: []const Xxh64Path = &.{};
    inline for (comptime std.enums.values(Xxh64Path)) |path| {
        if (comptime path.runs_on(Features.target())) found = found ++ .{path};
    }
    return found;
}

const stripe_len = constants.xxh64_stripe_len;
const lane_len = constants.xxh64_lane_len;
const word_len = constants.xxh64_word_len;

/// The stripes the seeded tests reach past, and so the longest input they take at every length and
/// every split: every remainder of Step 5 after each count of whole stripes.
const stripes_checked = 4;
const len_max = (stripes_checked + 1) * stripe_len - 1;

/// The seeds: 0, which Zstandard uses; 1; one with the top bit set; and the largest, with which
/// Step 1's sums wrap.
const seeds = [_]u64{ 0, 1, top_bit | 1, std.math.maxInt(u64) };
const top_bit: u64 = 1 << (@bitSizeOf(u64) - 1);

/// The largest input the fuzz test takes, and the most pieces it splits one into.
const fuzz_input_len_max = 4096;
const fuzz_pieces_max = 8;

/// The octets the seeded tests read: a fixed, irregular sequence.
const sample: [len_max]u8 = sample_octets();

fn sample_octets() [len_max]u8 {
    var octets: [len_max]u8 = undefined;
    var value: u64 = constants.xxh64_prime_5;
    for (&octets) |*octet| {
        value = value *% constants.xxh64_prime_1 +% constants.xxh64_prime_2;
        octet.* = @truncate(value >> (@bitSizeOf(u64) - @bitSizeOf(u8)));
    }
    return octets;
}

/// XXH64 read straight from the specification's steps, over one buffer at once.
fn reference(seed: u64, input: []const u8) u64 {
    var offset: usize = 0;
    var accumulator: u64 = seed +% constants.xxh64_prime_5;
    if (input.len >= stripe_len) {
        // Step 1, then Step 2 over every whole stripe, then Step 3.
        var lanes = [constants.xxh64_lanes]u64{
            seed +% constants.xxh64_prime_1 +% constants.xxh64_prime_2,
            seed +% constants.xxh64_prime_2,
            seed,
            seed -% constants.xxh64_prime_1,
        };
        for (0..input.len / stripe_len) |_| {
            for (&lanes) |*lane| {
                lane.* = reference_round(lane.*, std.mem.readInt(u64, input[offset..][0..lane_len], .little));
                offset += lane_len;
            }
        }
        accumulator = 0;
        for (lanes, constants.xxh64_convergence_rotations) |lane, rotation| accumulator +%= std.math.rotl(u64, lane, rotation);
        for (lanes) |lane| accumulator = ((accumulator ^ reference_round(0, lane)) *% constants.xxh64_prime_1) +% constants.xxh64_prime_4;
    }
    // Step 4.
    accumulator +%= input.len;
    return reference_tail(accumulator, input[offset..]);
}

/// Steps 5 and 6 of `reference`.
fn reference_tail(start: u64, remaining: []const u8) u64 {
    var accumulator = start;
    var offset: usize = 0;
    for (0..remaining.len / lane_len) |_| {
        const lane = std.mem.readInt(u64, remaining[offset..][0..lane_len], .little);
        accumulator ^= reference_round(0, lane);
        accumulator = std.math.rotl(u64, accumulator, constants.xxh64_lane_rotation) *% constants.xxh64_prime_1 +% constants.xxh64_prime_4;
        offset += lane_len;
    }
    if (remaining.len - offset >= word_len) {
        const word: u64 = std.mem.readInt(u32, remaining[offset..][0..word_len], .little);
        accumulator ^= word *% constants.xxh64_prime_1;
        accumulator = std.math.rotl(u64, accumulator, constants.xxh64_word_rotation) *% constants.xxh64_prime_2 +% constants.xxh64_prime_3;
        offset += word_len;
    }
    for (remaining[offset..]) |octet| {
        accumulator ^= @as(u64, octet) *% constants.xxh64_prime_5;
        accumulator = std.math.rotl(u64, accumulator, constants.xxh64_octet_rotation) *% constants.xxh64_prime_1;
    }
    accumulator ^= accumulator >> constants.xxh64_avalanche_shifts[0];
    accumulator *%= constants.xxh64_avalanche_primes[0];
    accumulator ^= accumulator >> constants.xxh64_avalanche_shifts[1];
    accumulator *%= constants.xxh64_avalanche_primes[1];
    return accumulator ^ accumulator >> constants.xxh64_avalanche_last_shift;
}

fn reference_round(accumulator: u64, lane: u64) u64 {
    const sum = accumulator +% lane *% constants.xxh64_prime_2;
    return std.math.rotl(u64, sum, constants.xxh64_round_rotation) *% constants.xxh64_prime_1;
}

test "one call gives the specification's value at every length, from every seed, by every path" {
    for (paths) |path| {
        for (seeds) |seed| {
            for (0..len_max + 1) |len| {
                try testing.expectEqual(reference(seed, sample[0..len]), xxh64_module.xxh64(path, seed, sample[0..len]));
            }
        }
    }
}

test "two calls split anywhere give the value of one, by every path" {
    for (paths) |path| try expect_splits_agree(path);
}

fn expect_splits_agree(path: Xxh64Path) !void {
    for (seeds) |seed| {
        for (0..len_max + 1) |len| {
            for (0..len + 1) |split| {
                var state = Xxh64.init(path, seed);
                state.update(sample[0..split]);
                state.update(sample[split..len]);
                try testing.expectEqual(reference(seed, sample[0..len]), state.final());
            }
        }
    }
}

test "every path gives the specification's value where the AVX-512 path takes its stripes" {
    // Around `xxh64_avx512_len_min` and past it, from each remainder of a stripe, split in two.
    var long: [long_len]u8 = undefined;
    for (&long, 0..) |*octet, index| octet.* = sample[index % sample.len] ^ @as(u8, @truncate(index / sample.len));
    for (paths) |path| {
        for (0..stripe_len) |remainder| {
            for ([_]usize{ constants.xxh64_avx512_len_min - stripe_len, constants.xxh64_avx512_len_min, long_len - stripe_len }) |start| {
                const len = start + remainder;
                try testing.expectEqual(reference(seeds[2], long[0..len]), xxh64_module.xxh64(path, seeds[2], long[0..len]));
                var state = Xxh64.init(path, seeds[2]);
                state.update(long[0 .. len / 2]);
                state.update(long[len / 2 .. len]);
                try testing.expectEqual(reference(seeds[2], long[0..len]), state.final());
            }
        }
    }
}

/// The longest input the test of long runs takes: a few times the AVX-512 path's shortest run.
const long_len = long_runs * constants.xxh64_avx512_len_min;
const long_runs = 4;

test "fastest takes the AVX-512 path only where VPMULLQ is fast, and the aarch64 path on aarch64" {
    const intel: Features = .{ .avx512 = true };
    const amd: Features = .{ .avx512 = true, .vpmullq_fast = true };
    const general: Xxh64Path = if (builtin.cpu.arch == .aarch64) .aarch64 else .scalar;
    try testing.expectEqual(general, Xxh64Path.fastest(intel));
    try testing.expectEqual(if (Xxh64Path.avx512.built()) Xxh64Path.avx512 else general, Xxh64Path.fastest(amd));
    try testing.expectEqual(general, Xxh64Path.fastest(.{ .vpmullq_fast = true }));
    // The path chosen runs on the CPU it was chosen for, so the tests above take it.
    for ([_]Features{ intel, amd, .{ .vpmullq_fast = true }, .{} }) |features| try testing.expect(Xxh64Path.fastest(features).runs_on(features));
}

test "final leaves the state as it was, so the hash goes on" {
    var state = Xxh64.init(.scalar, seeds[1]);
    for (0..len_max + 1) |len| {
        try testing.expectEqual(reference(seeds[1], sample[0..len]), state.final());
        if (len < len_max) state.update(sample[len..][0..1]);
    }
}

test "fuzz the state split in pieces against the specification's value" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "", "a", "abcdefghijklmnopqrstuvwxyz0123456789", "\x00" ** 100 } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [fuzz_input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    const seed = smith.value(u64);
    var state = Xxh64.init(paths[smith.index(paths.len)], seed);
    var given: usize = 0;
    for (0..fuzz_pieces_max) |_| {
        const piece_len = @min(input_len - given, smith.value(u16));
        state.update(input[given..][0..piece_len]);
        given += piece_len;
    }
    state.update(input[given..input_len]);
    try testing.expectEqual(reference(seed, input[0..input_len]), state.final());
}

test "each value recorded here is the one computed" {
    // Recorded from this implementation after `zig build differential-checksum -Doracles` found
    // the low 32 bits of every length from 0 to 4096 of every corpus file equal to libzstd's
    // Content_Checksum. XXH64 is a specification's function, so a change here is a bug.
    const recorded = [_]struct { usize, u64, u64 }{
        .{ 0, seeds[0], 0xef46db3751d8e999 },
        .{ 0, seeds[3], 0x298f4c84b24f5380 },
        .{ 1, seeds[0], 0x48588d5d61ab69f7 },
        .{ 4, seeds[3], 0xb4d3afdead2e1845 },
        .{ 8, seeds[0], 0x782ce8caafd4cd70 },
        .{ 31, seeds[3], 0xd73fc62dcfce536d },
        .{ 32, seeds[0], 0xa8b4aa7ee2ff25b1 },
        .{ 33, seeds[3], 0xf03d871b8598dc2a },
        .{ len_max, seeds[0], 0xdabff0503028c19e },
        .{ len_max, seeds[3], 0x7c03757e4b254f29 },
    };
    for (paths) |path| {
        for (recorded) |entry| try testing.expectEqual(entry[2], xxh64_module.xxh64(path, entry[1], sample[0..entry[0]]));
    }
}
