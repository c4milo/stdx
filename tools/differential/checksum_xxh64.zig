//! differential-checksum's XXH64 part (design §8 step 10, decision 18). A Zstandard frame carries
//! only the low 32 bits of XXH64 with seed 0, its Content_Checksum (RFC 8878 §3.1.1). libzstd also
//! exports its copy of xxHash's XXH64, which gives all 64 bits from any seed. For every corpus
//! file, and every XXH64 path of stdx's this CPU runs:
//! - at every length from 0 to `Limits.len_max`, at an offset the file's seed draws, the path's
//!   `xxh64` against the Content_Checksum of libzstd's frame of those octets, and against all 64
//!   bits of libzstd's XXH64 from seed 0 and from a seed the file's seed draws;
//! - the whole file, the same way;
//! - the path's state fed the whole file in the pieces a seeded split draws, against its `xxh64` of
//!   the whole file, all 64 bits.

const std = @import("std");
const builtin = @import("builtin");
const oracle = @import("oracle");
const codec = @import("codec");
const checksum = @import("checksum");

/// The XXH64 seed of a Zstandard frame's Content_Checksum (RFC 8878 §3.1.1).
const zstd_seed = 0;

/// XXH64 of octets from a seed, as the check calls it: stdx's `xxh64` by a path, or a wrong one in
/// a test.
pub const Hash = *const fn (u64, []const u8) u64;

/// One XXH64 path of stdx's: its name, its one call, and the path its state takes.
pub const Candidate = struct {
    name: []const u8,
    hash: Hash,
    path: checksum.Xxh64Path,
};

/// The candidate of `path`.
pub fn candidate(comptime path: checksum.Xxh64Path) Candidate {
    const Call = struct {
        fn hash(seed: u64, octets: []const u8) u64 {
            return checksum.xxh64(path, seed, octets);
        }
    };
    return .{ .name = "stdx " ++ @tagName(path), .hash = Call.hash, .path = path };
}

/// The bounds the whole checksum check shares.
pub const Limits = struct {
    /// The longest piece checked at every length.
    len_max: usize,
    /// The most pieces one seeded split cuts a file into.
    split_calls_max: usize,
};

pub const Counts = struct {
    compared: usize = 0,
    failures: usize = 0,
};

/// Every comparison of one file by one candidate. `frame` holds at least
/// `oracle.zstd_bound(input.len)` octets.
pub fn check_file(by: Candidate, frame: []u8, name: []const u8, input: []const u8, limits: Limits, seed: u64) Counts {
    std.debug.assert(frame.len >= oracle.zstd_bound(input.len));
    var counts: Counts = .{};
    var generator = codec.split.Generator.init(seed);
    for (0..@min(input.len, limits.len_max) + 1) |len| {
        const offset: usize = @intCast(generator.below(input.len - len + 1));
        const case: Case = .{ .file = name, .offset = offset, .len = len };
        compare_with_libzstd(by, frame, &counts, case, input[offset..][0..len]);
        compare_all_bits(by, &counts, case, zstd_seed, input[offset..][0..len]);
        compare_all_bits(by, &counts, case, generator.next(), input[offset..][0..len]);
    }
    compare_with_libzstd(by, frame, &counts, .{ .file = name, .offset = 0, .len = input.len }, input);
    compare_split(by, &counts, name, input, limits, seed);
    return counts;
}

/// Where a compared piece lies.
const Case = struct {
    file: []const u8,
    offset: usize,
    len: usize,
};

/// The low 32 bits of the candidate's hash over `octets` against libzstd's Content_Checksum.
fn compare_with_libzstd(by: Candidate, frame: []u8, counts: *Counts, case: Case, octets: []const u8) void {
    counts.compared += 1;
    const wanted = oracle.zstd_content_checksum(octets, frame);
    const got: u32 = @truncate(by.hash(zstd_seed, octets));
    if (wanted == got) return;
    counts.failures += 1;
    // The tests break the hash on purpose, and count its failures rather than print them.
    if (builtin.is_test) return;
    std.debug.print("differential-checksum FAILED: {s}: XXH64 by {s}, offset {d} length {d}: low 32 bits " ++
        "0x{x:0>8}, libzstd's Content_Checksum {?x}\n", .{ case.file, by.name, case.offset, case.len, got, wanted });
}

/// Every bit of the candidate's hash over `octets` from `seed` against libzstd's XXH64.
fn compare_all_bits(by: Candidate, counts: *Counts, case: Case, seed: u64, octets: []const u8) void {
    counts.compared += 1;
    const wanted = oracle.zstd_xxh64(seed, octets);
    const got = by.hash(seed, octets);
    if (wanted == got) return;
    counts.failures += 1;
    if (builtin.is_test) return;
    std.debug.print("differential-checksum FAILED: {s}: XXH64 by {s} from seed 0x{x:0>16}, offset {d} length {d}: " ++
        "0x{x:0>16}, libzstd's XXH64 0x{x:0>16}\n", .{ case.file, by.name, seed, case.offset, case.len, got, wanted });
}

/// The candidate's state fed `input` in seeded pieces, against its hash of the whole input.
fn compare_split(by: Candidate, counts: *Counts, name: []const u8, input: []const u8, limits: Limits, seed: u64) void {
    var schedule = codec.split.Schedule.init(seed);
    var state = checksum.Xxh64.init(by.path, zstd_seed);
    var position: usize = 0;
    for (0..limits.split_calls_max) |_| {
        if (position == input.len) break;
        const piece_len = schedule.piece_len(input.len - position);
        state.update(input[position..][0..piece_len]);
        position += piece_len;
    }
    counts.compared += 1;
    const wanted = by.hash(zstd_seed, input);
    if (position == input.len and state.final() == wanted) return;
    counts.failures += 1;
    if (builtin.is_test) return;
    std.debug.print("differential-checksum FAILED: {s}: XXH64 by {s}'s state under a split: 0x{x:0>16}, one call " ++
        "gives 0x{x:0>16}\n", .{ name, by.name, state.final(), wanted });
}

// Tests. They check the check: that it compares what it says, and that a wrong XXH64 fails it.

const testing = std.testing;

/// The limits of the tests: short, so libzstd's frames stay quick.
const test_limits: Limits = .{ .len_max = 300, .split_calls_max = 1 << 16 };

fn sample(octets: []u8) void {
    for (octets, 0..) |*octet, index| octet.* = @truncate(index *% 2654435761 >> 13);
}

test "stdx and libzstd agree over a sample, and every length is compared" {
    var input: [test_limits.len_max + 100]u8 = undefined;
    sample(&input);
    var frame: [test_limits.len_max + 1024]u8 = undefined;
    const counts = check_file(candidate(.scalar), &frame, "sample", &input, test_limits, 1);
    try testing.expectEqual(0, counts.failures);
    // Every length three ways, then the whole input, then the split.
    try testing.expectEqual(3 * (test_limits.len_max + 1) + 2, counts.compared);
}

fn wrong_hash(seed: u64, octets: []const u8) u64 {
    const right = checksum.xxh64(.scalar, seed, octets);
    return if (octets.len == test_limits.len_max / 2) right ^ 1 else right;
}

fn wrong_high_bits(seed: u64, octets: []const u8) u64 {
    return checksum.xxh64(.scalar, seed, octets) ^ (1 << 63);
}

test "an XXH64 wrong at one length fails the check, and wrong high bits fail the split" {
    var input: [test_limits.len_max + 100]u8 = undefined;
    sample(&input);
    var frame: [test_limits.len_max + 1024]u8 = undefined;
    // Wrong at one length: the frame and both seeds of libzstd's XXH64 see it.
    const wrong: Candidate = .{ .name = "wrong", .hash = wrong_hash, .path = .scalar };
    try testing.expectEqual(3, check_file(wrong, &frame, "sample", &input, test_limits, 1).failures);
    // A frame carries only the low 32 bits; libzstd's XXH64 and the split compare all 64.
    const high: Candidate = .{ .name = "wrong high bits", .hash = wrong_high_bits, .path = .scalar };
    try testing.expectEqual(2 * (test_limits.len_max + 1) + 1, check_file(high, &frame, "sample", &input, test_limits, 1).failures);
}
