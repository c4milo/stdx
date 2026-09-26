//! The instructions the checksum paths use, which the caller reads from its `codec.Features` and
//! passes in: the checksum module imports nothing (design §3), so it names the eight fields it
//! reads rather than import the type. Decision 21 has the rest.

const std = @import("std");
const builtin = @import("builtin");

/// The fields of `codec.Features` the checksum paths read, spelled the same.
pub const Features = struct {
    /// x86-64: PCLMULQDQ, with SSE4.1.
    pclmul: bool = false,
    /// x86-64: AVX2, with the operating system saving the YMM registers.
    avx2: bool = false,
    /// x86-64: VPCLMULQDQ, carry-less multiplication of every lane of a YMM register.
    vpclmul: bool = false,
    /// x86-64: AVX-512 F, BW and VL, with the operating system saving the ZMM registers.
    avx512: bool = false,
    /// x86-64: AVX512_VNNI's VPDPBUSD.
    vnni: bool = false,
    /// aarch64: the CRC32 instructions.
    crc32: bool = false,
    /// aarch64: PMULL, polynomial multiplication of 64-bit lanes.
    pmull: bool = false,
    /// aarch64: UDOT, dot products of octets.
    dotprod: bool = false,

    /// The instructions the build target guarantees, which a test may run without detection.
    pub fn target() Features {
        const cpu = builtin.cpu;
        return comptime switch (cpu.arch) {
            .x86_64 => .{
                .pclmul = std.Target.x86.featureSetHasAll(cpu.features, .{ .pclmul, .sse4_1 }),
                .avx2 = std.Target.x86.featureSetHas(cpu.features, .avx2),
                .vpclmul = std.Target.x86.featureSetHas(cpu.features, .vpclmulqdq),
                .avx512 = std.Target.x86.featureSetHasAll(cpu.features, .{ .avx512f, .avx512bw, .avx512vl }),
                .vnni = std.Target.x86.featureSetHas(cpu.features, .avx512vnni),
            },
            .aarch64 => .{
                .crc32 = std.Target.aarch64.featureSetHas(cpu.features, .crc),
                .pmull = std.Target.aarch64.featureSetHas(cpu.features, .aes),
                .dotprod = std.Target.aarch64.featureSetHas(cpu.features, .dotprod),
            },
            else => .{},
        };
    }

    /// These fields of `features`, a `codec.Features` or any struct that spells them the same.
    pub fn from(features: anytype) Features {
        var result: Features = .{};
        inline for (@typeInfo(Features).@"struct".fields) |field| {
            @field(result, field.name) = @field(features, field.name);
        }
        return result;
    }
};

test "from copies every field it names, and nothing else" {
    const Wider = struct {
        pclmul: bool = true,
        avx2: bool = false,
        vpclmul: bool = true,
        avx512: bool = false,
        vnni: bool = true,
        crc32: bool = false,
        pmull: bool = true,
        dotprod: bool = false,
        other: bool = true,
    };
    const features = Features.from(Wider{});
    try std.testing.expectEqual(Features{ .pclmul = true, .vpclmul = true, .vnni = true, .pmull = true }, features);
    const flipped = Features.from(Wider{ .pclmul = false, .avx2 = true, .vpclmul = false, .avx512 = true, .vnni = false, .crc32 = true, .pmull = false, .dotprod = true });
    try std.testing.expectEqual(Features{ .avx2 = true, .avx512 = true, .crc32 = true, .dotprod = true }, flipped);
}
