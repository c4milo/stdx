//! The bits and names the `platform` module reads (decision 40): CPUID's as the Intel and AMD
//! manuals number them, Linux's arm64 hardware capability word's as the kernel numbers it, and
//! macOS's sysctl names as the system spells them.

/// The CPUID leaf whose ECX holds the feature bits `probe` reads on x86-64.
pub const cpuid_leaf_features: u32 = 1;

/// CPUID leaf 1, ECX bit 1: PCLMULQDQ, the carry-less multiply of two 64-bit values.
pub const ecx_pclmulqdq: u32 = 1 << 1;

/// CPUID leaf 1, ECX bit 25: AES-NI, the AES round instructions.
pub const ecx_aes: u32 = 1 << 25;

/// Linux's arm64 AT_HWCAP word, bit 3: HWCAP_AES, the AES instructions.
pub const hwcap_aes: usize = 1 << 3;

/// AT_HWCAP bit 4: HWCAP_PMULL, PMULL's carry-less multiply of two 64-bit values.
pub const hwcap_pmull: usize = 1 << 4;

/// AT_HWCAP bit 24: HWCAP_DIT, Arm's FEAT_DIT.
pub const hwcap_dit: usize = 1 << 24;

/// The sysctl names macOS gives the three features on aarch64. Each holds a 32-bit integer: 1 when
/// the CPU has the feature, 0 when it lacks it. A release older than the name has no value for it.
pub const sysctl_aes = "hw.optional.arm.FEAT_AES";
pub const sysctl_pmull = "hw.optional.arm.FEAT_PMULL";
pub const sysctl_dit = "hw.optional.arm.FEAT_DIT";
