//! XXH64, whose low 32 bits are a Zstandard frame's Content_Checksum with seed 0 (RFC 8878
//! §3.1.1). RFC 8878 gives no algorithm, so decision 18 reads xxHash's specification,
//! docs/specs/xxhash_spec.md; each function cites the step of its "XXH64 Algorithm Description"
//! that it follows.
//!
//! `Xxh64` is the state of a hash fed in pieces: `init` with a path and a seed, `update` with each
//! piece, and `final` for the value, which leaves the state as it was. `xxh64` hashes one buffer
//! through the same state. Every multi-octet read takes the least significant octet first, as the
//! specification's "Operation notations" require. Every path gives the same value; the scalar path
//! is the one the others are tested against (decision 21).

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const Features = @import("features.zig").Features;

const prime_1 = constants.xxh64_prime_1;
const prime_2 = constants.xxh64_prime_2;
const prime_3 = constants.xxh64_prime_3;
const prime_4 = constants.xxh64_prime_4;
const prime_5 = constants.xxh64_prime_5;
const stripe_len = constants.xxh64_stripe_len;
const lane_len = constants.xxh64_lane_len;
const word_len = constants.xxh64_word_len;

pub const Xxh64Path = enum {
    /// The four accumulators in general registers, on every target.
    scalar,
    /// The four accumulators in one 256-bit register, from the x86-64 AVX-512 variant object.
    avx512,

    /// The fastest path a CPU with `features` runs in this build. The AVX-512 path is the faster
    /// only where VPMULLQ is: 1.27 times the scalar path on an AMD EPYC 9V74 runner, and 0.47 times
    /// on an Intel Xeon 6973P-C (design §8 step 10).
    pub fn fastest(features: Features) Xxh64Path {
        return if (Xxh64Path.avx512.runs_on(features) and features.vpmullq_fast) .avx512 else .scalar;
    }

    /// True when a CPU with `features` runs the path in this build.
    pub fn runs_on(path: Xxh64Path, features: Features) bool {
        return path.built() and switch (path) {
            .scalar => true,
            .avx512 => features.avx512,
        };
    }

    /// True when this build holds the path's code: only an x86-64 build links the AVX-512 object.
    pub fn built(path: Xxh64Path) bool {
        return switch (path) {
            .scalar => true,
            .avx512 => builtin.cpu.arch == .x86_64,
        };
    }
};

// The kernel of the AVX-512 variant object, which build/variants.zig links into an x86-64 build.
extern fn stdx_checksum_xxh64_avx512(accumulators: *[constants.xxh64_lanes]u64, octets: [*]const u8, stripes: usize) callconv(.c) void;

pub const Xxh64 = struct {
    /// Step 1's four accumulators, one for each lane of a stripe.
    accumulators: [constants.xxh64_lanes]u64,
    /// The octets given since `init`, which Step 4 adds, and the seed Step 1 started from.
    total_len: u64,
    seed: u64,
    /// The octets of a stripe not yet whole, and how many there are.
    partial: [stripe_len]u8,
    partial_len: u8,
    /// The path Step 2 takes. The caller has checked that the CPU has its instructions.
    path: Xxh64Path,

    /// Starts a hash from `seed` (Step 1), whose stripes take `path`.
    pub fn init(path: Xxh64Path, seed: u64) Xxh64 {
        assert(path.built());
        return .{
            .path = path,
            .accumulators = .{ seed +% prime_1 +% prime_2, seed +% prime_2, seed, seed -% prime_1 },
            .total_len = 0,
            .seed = seed,
            .partial = @splat(0),
            .partial_len = 0,
        };
    }

    /// Adds `octets` to the hash: every stripe they complete goes through Step 2, and the octets
    /// of a stripe not yet whole wait in the state.
    pub fn update(self: *Xxh64, octets: []const u8) void {
        assert(self.partial_len < stripe_len);
        self.total_len +%= octets.len;
        var rest = octets;
        if (self.partial_len > 0) {
            const taken = @min(rest.len, stripe_len - self.partial_len);
            @memcpy(self.partial[self.partial_len..][0..taken], rest[0..taken]);
            self.partial_len += @intCast(taken);
            rest = rest[taken..];
            if (self.partial_len < stripe_len) return;
            process_stripes(self.path, &self.accumulators, &self.partial);
        }
        const whole_len = rest.len - rest.len % stripe_len;
        process_stripes(self.path, &self.accumulators, rest[0..whole_len]);
        @memcpy(self.partial[0 .. rest.len - whole_len], rest[whole_len..]);
        self.partial_len = @intCast(rest.len - whole_len);
    }

    /// The hash of every octet given since `init` (Steps 3 to 7). The octets waiting in the state
    /// are the remaining input of Step 5, as every whole stripe has gone through Step 2.
    pub fn final(self: *const Xxh64) u64 {
        assert(self.partial_len < stripe_len);
        assert(self.total_len % stripe_len == self.partial_len);
        // Step 1's special case: an input shorter than a stripe takes one accumulator.
        const start = if (self.total_len >= stripe_len) converge(self.accumulators) else self.seed +% prime_5;
        // Step 4.
        const with_len = start +% self.total_len;
        return avalanche(consume_remaining(with_len, self.partial[0..self.partial_len]));
    }
};

/// The XXH64 of `octets` from `seed`, by `path`.
pub fn xxh64(path: Xxh64Path, seed: u64, octets: []const u8) u64 {
    var state = Xxh64.init(path, seed);
    state.update(octets);
    return state.final();
}

/// Step 2 over whole stripes, by `path`.
fn process_stripes(path: Xxh64Path, accumulators: *[constants.xxh64_lanes]u64, octets: []const u8) void {
    assert(octets.len % stripe_len == 0);
    if (octets.len == 0) return;
    switch (path) {
        .scalar => process_stripes_scalar(accumulators, octets),
        .avx512 => if (octets.len < constants.xxh64_avx512_len_min) process_stripes_scalar(accumulators, octets) else process_stripes_avx512(accumulators, octets),
    }
}

fn process_stripes_avx512(accumulators: *[constants.xxh64_lanes]u64, octets: []const u8) void {
    if (builtin.cpu.arch != .x86_64) unreachable;
    stdx_checksum_xxh64_avx512(accumulators, octets.ptr, octets.len / stripe_len);
}

/// Step 2 over whole stripes in general registers: each lane goes through a round with its
/// accumulator.
fn process_stripes_scalar(accumulators: *[constants.xxh64_lanes]u64, octets: []const u8) void {
    var lanes = accumulators.*;
    for (0..octets.len / stripe_len) |index| {
        const stripe = octets[index * stripe_len ..][0..stripe_len];
        inline for (&lanes, 0..) |*accumulator, lane| {
            accumulator.* = round(accumulator.*, read_lane(stripe[lane * lane_len ..][0..lane_len]));
        }
    }
    accumulators.* = lanes;
}

/// A lane's 64-bit value, least significant octet first (Step 2).
fn read_lane(octets: *const [lane_len]u8) u64 {
    return std.mem.readInt(u64, octets, .little);
}

/// Step 2's round.
fn round(accumulator: u64, lane: u64) u64 {
    return std.math.rotl(u64, accumulator +% lane *% prime_2, constants.xxh64_round_rotation) *% prime_1;
}

/// Step 3: the four accumulators merged into one.
fn converge(accumulators: [constants.xxh64_lanes]u64) u64 {
    var accumulator: u64 = 0;
    for (accumulators, constants.xxh64_convergence_rotations) |lane, rotation| {
        accumulator +%= std.math.rotl(u64, lane, rotation);
    }
    for (accumulators) |lane| accumulator = merge_accumulator(accumulator, lane);
    return accumulator;
}

/// Step 3's mergeAccumulator.
fn merge_accumulator(accumulator: u64, lane: u64) u64 {
    return ((accumulator ^ round(0, lane)) *% prime_1) +% prime_4;
}

/// Step 5: the octets after the last whole stripe, a lane, then a 32-bit word, then an octet at a
/// time, each read least significant octet first.
fn consume_remaining(start: u64, remaining: []const u8) u64 {
    assert(remaining.len < stripe_len);
    var accumulator = start;
    var rest = remaining;
    for (0..stripe_len / lane_len) |_| {
        if (rest.len < lane_len) break;
        const lane = std.mem.readInt(u64, rest[0..lane_len], .little);
        accumulator = std.math.rotl(u64, accumulator ^ round(0, lane), constants.xxh64_lane_rotation) *% prime_1 +% prime_4;
        rest = rest[lane_len..];
    }
    if (rest.len >= word_len) {
        const word: u64 = std.mem.readInt(u32, rest[0..word_len], .little);
        accumulator = std.math.rotl(u64, accumulator ^ (word *% prime_1), constants.xxh64_word_rotation) *% prime_2 +% prime_3;
        rest = rest[word_len..];
    }
    assert(rest.len < word_len);
    for (rest) |octet| {
        accumulator = std.math.rotl(u64, accumulator ^ (@as(u64, octet) *% prime_5), constants.xxh64_octet_rotation) *% prime_1;
    }
    return accumulator;
}

/// Step 6's final mix.
fn avalanche(start: u64) u64 {
    var accumulator = start;
    for (constants.xxh64_avalanche_shifts, constants.xxh64_avalanche_primes) |shift, prime| {
        accumulator ^= accumulator >> shift;
        accumulator *%= prime;
    }
    return accumulator ^ accumulator >> constants.xxh64_avalanche_last_shift;
}

test {
    _ = @import("xxh64_test.zig");
}
