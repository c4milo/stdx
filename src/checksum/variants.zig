//! The root of the checksum module's variant objects (decision 21). The build compiles this file
//! once per feature level, each time for a CPU with that level's features and with
//! `@import("variant_level").level` naming the level, and links each object into the checksum
//! module. Each object exports its level's kernels alone, so no two define the same symbol.
//!
//! The module calls a kernel only when the caller's `Features` say the CPU has its level.

const level = @import("variant_level").level;

comptime {
    switch (level) {
        .x86_64_pclmul => _ = @import("variants/crc32_pclmul.zig"),
        .x86_64_vpclmul => _ = @import("variants/crc32_vpclmul.zig"),
        .x86_64_avx512 => {
            _ = @import("variants/crc32_avx512.zig");
            _ = @import("variants/adler32_avx512.zig");
        },
        .x86_64_avx2 => _ = @import("variants/adler32_avx2.zig"),
        .aarch64_crc_pmull => _ = @import("variants/crc32_armv8.zig"),
    }
}
