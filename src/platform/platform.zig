//! platform: what the CPU a program runs on offers, read once when the program starts
//! (decision 40, design §3).
//!
//! `CpuFeatures.detect()` gives a `CpuFeatures`: the booleans a codec's fast paths read and the
//! instructions `stdx.crypto` runs. A program calls it once, at start, and passes the value to each
//! codec's `init` and to `crypto.init` (decisions 21 and 40 as amended, platform_cpu_features.zig).
//! It is the one CPU type a program names, and it holds every answer the removed `probe` gave
//! (decision 40 as amended on 2026-11-26).
//!
//! stdx keeps no copy of it (invariant 4). The codecs import this module for the type
//! `CpuFeatures` alone. Outside it, only a test under `src/` calls `CpuFeatures.detect`, and the
//! `cpu-probe` lint rule holds that (decisions 21 and 40 as amended on 2026-11-24, invariant 14).
//!
//! Detection makes no syscall (invariant 2). On x86-64 it runs CPUID and XGETBV. On aarch64 Linux
//! it reads the AT_HWCAP and AT_HWCAP2 words through `getauxval`, which reads the auxiliary vector
//! the kernel wrote into the process's memory at start, and MIDR_EL1 with `mrs` where AT_HWCAP has
//! HWCAP_CPUID: Linux traps that read and emulates it. Every aarch64 Mac is an Apple M-series
//! part, whose features detection states. Elsewhere detection gives the build target's features.
//!
//! Detection only reads. It changes no CPU state, and sets no PSTATE.DIT. A program that wants the
//! mode calls `set_data_independent_timing` on each thread, and `data_independent_timing` reads
//! it: one instruction each on arm64, and no syscall (platform_timing.zig).
//!
//! The module imports nothing, so a codec that imports it reaches no other module through it.
//!
//! The module also holds `memset`, a vector `memset` that a program exports from its root on Linux
//! under Zig 0.16, where `memset_applies` holds (platform_memset.zig, decision 41 as amended).
//! Each call to `memset` in the program then runs it: from stdx's modules and from its C code.

pub const constants = @import("constants.zig");
const memset_file = @import("platform_memset.zig");
const cpu_features_file = @import("platform_cpu_features.zig");
const timing_file = @import("platform_timing.zig");
const midr_file = @import("platform_midr.zig");

/// The CPU features a codec's SIMD paths and `stdx.crypto` may use: a program calls
/// `CpuFeatures.detect()` once and passes the value to each codec's `init` and to `crypto.init`
/// (decisions 21 and 40 as amended on 2026-11-25).
pub const CpuFeatures = cpu_features_file.CpuFeatures;
/// The fields of an aarch64 core's MIDR_EL1, which `CpuFeatures.midr` holds where the system lets
/// a program read it (decision 40 as amended on 2026-11-19 and on 2026-11-26).
pub const Midr = midr_file.Midr;

/// Whether the calling thread's timing is data-independent: its PSTATE.DIT on arm64, and false
/// elsewhere (decision 40 as amended on 2026-11-25).
pub const data_independent_timing = timing_file.data_independent_timing;
/// Sets or clears the calling thread's PSTATE.DIT on arm64, and returns false where it cannot.
pub const set_data_independent_timing = timing_file.set_data_independent_timing;

/// A vector `memset`, which a program exports as `memset` where `memset_applies` holds.
pub const memset = memset_file.memset;
/// True on Linux under Zig 0.16, where a program exports `memset`.
pub const memset_applies = memset_file.applies;

test {
    _ = memset_file;
    _ = cpu_features_file;
    _ = timing_file;
    _ = midr_file;
}
