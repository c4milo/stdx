//! CRC-32 on aarch64: the variant object of decision 21, compiled with the CRC and PMULL extensions
//! whatever the module's target, and called only when `Features` has `crc32`, and `pmull` for the
//! folding path.
//!
//! Arm's CRC32 instructions use gzip's polynomial, in the reflected order of RFC 1952 §8, so each
//! advances the register as crc32_table.update_register does, eight octets or one at a time. The
//! folding path is crc32_fold.zig's over PMULL, with the CRC32 instructions for the last lane and
//! the tail.

const std = @import("std");
const constants = @import("../constants.zig");
const crc32_fold = @import("crc32_fold.zig");
const Lane = crc32_fold.Lane;

/// The octets one CRC32X instruction takes.
const word_len = @sizeOf(u64);

fn crc32_word(register: u32, word: u64) u32 {
    return asm ("crc32x %[out:w], %[register:w], %[word:x]"
        : [out] "=r" (-> u32),
        : [register] "r" (register),
          [word] "r" (word),
    );
}

fn crc32_octet(register: u32, octet: u8) u32 {
    return asm ("crc32b %[out:w], %[register:w], %[octet:w]"
        : [out] "=r" (-> u32),
        : [register] "r" (register),
          [octet] "r" (@as(u32, octet)),
    );
}

/// The register after the octets by the CRC32 instructions alone.
fn update_crc32(register: u32, octets: []const u8) u32 {
    var value = register;
    var position: usize = 0;
    while (octets.len - position >= word_len) : (position += word_len) {
        value = crc32_word(value, std.mem.readInt(u64, octets[position..][0..word_len], .little));
    }
    for (octets[position..]) |octet| value = crc32_octet(value, octet);
    return value;
}

const Multiply = struct {
    pub fn first_halves(lane: Lane, by: Lane) Lane {
        return asm ("pmull %[out].1q, %[lane].1d, %[by].1d"
            : [out] "=w" (-> Lane),
            : [lane] "w" (lane),
              [by] "w" (by),
        );
    }

    pub fn last_halves(lane: Lane, by: Lane) Lane {
        return asm ("pmull2 %[out].1q, %[lane].2d, %[by].2d"
            : [out] "=w" (-> Lane),
            : [lane] "w" (lane),
              [by] "w" (by),
        );
    }
};

/// Folding over `crc32_lanes_pmull` lanes, handing an input too short for it to folding over
/// fewer lanes, and one too short for that to the CRC32 instructions.
const ShortFolding = crc32_fold.Folding(Multiply, constants.crc32_lanes_pmull_short, update_crc32);
const Folding = crc32_fold.Folding(Multiply, constants.crc32_lanes_pmull, ShortFolding.update);

/// The CRC register after `len` octets from `register`, by the CRC32 instructions.
export fn stdx_checksum_crc32_armv8(register: u32, octets_pointer: [*]const u8, len: usize) callconv(.c) u32 {
    return update_crc32(register, octets_pointer[0..len]);
}

/// The combined path: in each block, PMULL folds the first region while three chains of CRC32
/// instructions take the three regions after it, so the vector and the integer units work at once.
/// Each chain starts from a zero register, and the four registers combine by `shift`. A block takes
/// `iterations` steps: one fold of `crc32_lanes_pmull` lanes, and `stream_step_len` octets on each
/// chain. `Next` takes what is left after the last whole block.
fn Combined(comptime iterations: usize, comptime stream_step_len: usize, comptime Next: type) type {
    return struct {
        const fold_len = iterations * Folding.step_len;
        const stream_len = iterations * stream_step_len;
        const block_len = fold_len + constants.crc32_streams * stream_len;

        comptime {
            std.debug.assert(stream_step_len % word_len == 0);
        }

        /// The register after one block, from `register`. Kept out of line: inlined, its registers
        /// and its stack frame cost every short call, which never reaches it, a third of its speed.
        noinline fn block_update(register: u32, block: *const [block_len]u8) u32 {
            var lanes = Folding.start(register, block[0..Folding.step_len]);
            var streams: [constants.crc32_streams]u32 = @splat(0);
            for (0..iterations) |iteration| {
                if (iteration > 0) Folding.fold_step(&lanes, block[iteration * Folding.step_len ..][0..Folding.step_len]);
                step_streams(&streams, block, iteration);
            }
            // The folded region's register moves past the three chains' regions, and each chain's
            // register past the regions after its own.
            var result = shift(Folding.finish_lanes(lanes, &.{}), constants.crc32_streams * stream_len);
            inline for (streams, 0..) |stream, index| {
                result ^= shift(stream, (constants.crc32_streams - 1 - index) * stream_len);
            }
            return result;
        }

        /// Advances each chain over its octets of step `iteration`.
        inline fn step_streams(streams: *[constants.crc32_streams]u32, block: *const [block_len]u8, iteration: usize) void {
            inline for (streams, 0..) |*stream, index| {
                const at = fold_len + index * stream_len + iteration * stream_step_len;
                inline for (0..stream_step_len / word_len) |word| {
                    const octets = block[at + word * word_len ..][0..word_len];
                    stream.* = crc32_word(stream.*, std.mem.readInt(u64, octets, .little));
                }
            }
        }

        pub fn update(register: u32, octets: []const u8) u32 {
            var value = register;
            var position: usize = 0;
            while (octets.len - position >= block_len) : (position += block_len) {
                value = block_update(value, octets[position..][0..block_len]);
            }
            return Next.update(value, octets[position..]);
        }
    };
}

/// The powers of x that the product in `shift` carries beyond the shift itself: the reflected
/// carry-less product of two 32-bit values stands for their product times x, and CRC32X of a zero
/// register multiplies its word by x^32.
const product_offset_bits = @bitSizeOf(u32) + 1;

/// The register `register` becomes over `octets` zero octets: register · x^(8·octets) mod P, by
/// one carry-less multiplication by x^(8·octets − 33) mod P and one CRC32X.
fn shift(register: u32, comptime octets: usize) u32 {
    // The last chain's region ends the block.
    if (octets == 0) return register;
    const factor: u64 = comptime @bitReverse(crc32_fold.x_power_mod(octets * @bitSizeOf(u8) - product_offset_bits));
    const product = Multiply.first_halves(.{ register, 0 }, .{ factor, 0 });
    return crc32_word(0, product[0]);
}

/// Short blocks, for inputs of a few kilobytes, then folding.
const CombinedShort = Combined(
    constants.crc32_combined_short_iterations,
    constants.crc32_combined_short_stream_step_len,
    Folding,
);

/// Long blocks, whose combining costs less per octet, then short blocks.
const CombinedLong = Combined(
    constants.crc32_combined_long_iterations,
    constants.crc32_combined_long_stream_step_len,
    CombinedShort,
);

/// The CRC register after `len` octets from `register`: long combined blocks, short ones, folding
/// with PMULL over eight lanes and then four, and the CRC32 instructions.
export fn stdx_checksum_crc32_pmull(register: u32, octets_pointer: [*]const u8, len: usize) callconv(.c) u32 {
    return CombinedLong.update(register, octets_pointer[0..len]);
}
