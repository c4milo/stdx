//! Adler-32 by Arm's UDOT: the aarch64 variant object of decision 21 compiled with the DotProd
//! extension whatever the module's target, and called only when `Features.dotprod` is set. The
//! path is adler32_dot.zig's; UDOT multiplies sixteen octets by sixteen weights and adds each group
//! of four products into a 32-bit lane.

const std = @import("std");
const constants = @import("../constants.zig");
const adler32_scalar = @import("../adler32_scalar.zig");
const adler32_dot = @import("adler32_dot.zig");

/// The octets of one NEON register.
const register_len = 16;

const Octets = @Vector(register_len, u8);
const Lanes = @Vector(register_len / @sizeOf(u32), u32);

const Dot = struct {
    pub const register_len = 16;
    /// UDOT by ones adds four octets into each lane.
    pub const lane_octets = @sizeOf(u32);
    pub const signed_weights = false;
    pub const weight_max = std.math.maxInt(u8);

    pub fn weighted(accumulator: Lanes, octets: Octets, weights: Octets) Lanes {
        return asm ("udot %[out].4s, %[octets].16b, %[weights].16b"
            : [out] "=w" (-> Lanes),
            : [accumulator] "0" (accumulator),
              [octets] "w" (octets),
              [weights] "w" (weights),
        );
    }

    pub fn sums(accumulator: Lanes, octets: Octets) Lanes {
        return weighted(accumulator, octets, @splat(1));
    }
};

const Short = adler32_dot.Kernel(Dot, constants.adler32_udot_registers_short, adler32_scalar);
const Kernel = adler32_dot.Kernel(Dot, constants.adler32_dot_block_len / register_len, Short);

/// The Adler-32 value after `len` octets from `adler`. An input shorter than a block of `Kernel`
/// goes straight to `Short`, so its call saves none of the registers `Kernel` holds.
export fn stdx_checksum_adler32_udot(adler: u32, octets_pointer: [*]const u8, len: usize) callconv(.c) u32 {
    const octets = octets_pointer[0..len];
    if (len < Kernel.block_len) return Short.update(adler, octets);
    return long(adler, octets);
}

noinline fn long(adler: u32, octets: []const u8) u32 {
    return Kernel.update(adler, octets);
}
