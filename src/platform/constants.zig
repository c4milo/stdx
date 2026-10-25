//! The bits and names the `platform` module reads (decision 40): CPUID's as the Intel and AMD
//! manuals number them, Linux's arm64 hardware capability word's as the kernel numbers it, and
//! macOS's sysctl names as the system spells them.

/// The CPUID leaf whose ECX holds the feature bits `probe` reads on x86-64.
pub const cpuid_leaf_features: u32 = 1;

/// The CPUID leaf of the structured extended features; its subleaf 0 EAX gives the last subleaf.
pub const cpuid_leaf_extended: u32 = 7;

/// CPUID leaf 1, ECX bit 1: PCLMULQDQ, the carry-less multiply of two 64-bit values.
pub const ecx_pclmulqdq: u32 = 1 << 1;

/// CPUID leaf 1, ECX bit 9: SSSE3, the supplemental SSE3 instructions.
pub const ecx_ssse3: u32 = 1 << 9;

/// CPUID leaf 1, ECX bit 19: SSE4.1.
pub const ecx_sse4_1: u32 = 1 << 19;

/// CPUID leaf 1, ECX bit 25: AES-NI, the AES round instructions.
pub const ecx_aes: u32 = 1 << 25;

/// CPUID leaf 1, ECX bit 27: OSXSAVE, the system's XSAVE enabled, so XGETBV may run.
pub const ecx_osxsave: u32 = 1 << 27;

/// CPUID leaf 1, ECX bit 28: AVX.
pub const ecx_avx: u32 = 1 << 28;

/// XCR0's bits 1 and 2: the system saves the SSE and AVX register state, so the YMM registers that
/// the SHA-512 instructions take are usable.
pub const xcr0_sse_avx: u64 = 1 << 1 | 1 << 2;

/// CPUID leaf 7, subleaf 0, EBX bit 29: SHA, the SHA-1 and SHA-256 instructions.
pub const leaf_7_ebx_sha: u32 = 1 << 29;

/// CPUID leaf 7, subleaf 1, EAX bit 0: SHA512, the SHA-512 instructions.
pub const leaf_7_1_eax_sha512: u32 = 1 << 0;

/// Linux's arm64 AT_HWCAP word, bit 3: HWCAP_AES, the AES instructions.
pub const hwcap_aes: usize = 1 << 3;

/// AT_HWCAP bit 4: HWCAP_PMULL, PMULL's carry-less multiply of two 64-bit values.
pub const hwcap_pmull: usize = 1 << 4;

/// AT_HWCAP bit 6: HWCAP_SHA2, the SHA-256 instructions.
pub const hwcap_sha2: usize = 1 << 6;

/// AT_HWCAP bit 17: HWCAP_SHA3, the SHA-3 instructions (EOR3, RAX1, XAR, BCAX).
pub const hwcap_sha3: usize = 1 << 17;

/// AT_HWCAP bit 21: HWCAP_SHA512, the SHA-512 instructions.
pub const hwcap_sha512: usize = 1 << 21;

/// AT_HWCAP bit 24: HWCAP_DIT, Arm's FEAT_DIT.
pub const hwcap_dit: usize = 1 << 24;

/// The sysctl names macOS gives the features on aarch64. Each holds a 32-bit integer: 1 when
/// the CPU has the feature, 0 when it lacks it. A release older than the name has no value for it.
pub const sysctl_aes = "hw.optional.arm.FEAT_AES";
pub const sysctl_pmull = "hw.optional.arm.FEAT_PMULL";
pub const sysctl_dit = "hw.optional.arm.FEAT_DIT";
pub const sysctl_sha256 = "hw.optional.arm.FEAT_SHA256";
pub const sysctl_sha512 = "hw.optional.arm.FEAT_SHA512";
pub const sysctl_sha3 = "hw.optional.arm.FEAT_SHA3";
