//! The bits the `platform` module reads (decision 40): CPUID's as the Intel and AMD manuals
//! number them, Linux's arm64 hardware capability words' as the kernel numbers them, and the DIT
//! register's as Arm's A64 reference places it.

/// CPUID leaf 1, ECX bit 25: AES-NI, the AES round instructions.
pub const ecx_aes: u32 = 1 << 25;

/// CPUID leaf 7, subleaf 0, EBX bit 29: SHA, the SHA-1 and SHA-256 instructions.
pub const leaf_7_ebx_sha: u32 = 1 << 29;

/// CPUID leaf 7, subleaf 0, ECX bit 9: VAES, the AES round instructions on YMM registers.
pub const leaf_7_ecx_vaes: u32 = 1 << 9;

/// CPUID leaf 7, subleaf 1, EAX bit 0: SHA512, the SHA-512 instructions.
pub const leaf_7_1_eax_sha512: u32 = 1 << 0;

/// Linux's arm64 AT_HWCAP word, bit 3: HWCAP_AES, the AES instructions.
pub const hwcap_aes: usize = 1 << 3;

/// AT_HWCAP bit 6: HWCAP_SHA2, the SHA-256 instructions.
pub const hwcap_sha2: usize = 1 << 6;

/// AT_HWCAP bit 17: HWCAP_SHA3, the SHA-3 instructions (EOR3, RAX1, XAR, BCAX).
pub const hwcap_sha3: usize = 1 << 17;

/// AT_HWCAP bit 21: HWCAP_SHA512, the SHA-512 instructions.
pub const hwcap_sha512: usize = 1 << 21;

/// AT_HWCAP bit 24: HWCAP_DIT, Arm's FEAT_DIT.
pub const hwcap_dit: usize = 1 << 24;

/// Linux's arm64 AT_HWCAP2 word, bit 1: HWCAP2_SVE2, Arm's FEAT_SVE2.
pub const hwcap2_sve2: usize = 1 << 1;

/// PSTATE.DIT's place in the value of the DIT register that `mrs` reads and `msr` writes: bit 24,
/// as Arm's A64 reference states for the register DIT. Every other bit reads as 0, and a write
/// ignores it.
pub const dit_bit: u64 = 1 << 24;
