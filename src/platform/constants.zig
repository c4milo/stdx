//! The bits and names the `platform` module reads (decision 40): CPUID's as the Intel and AMD
//! manuals number them, Linux's arm64 hardware capability words' as the kernel numbers them,
//! MIDR_EL1's fields as Arm's Architecture Reference Manual places them, and macOS's sysctl names
//! as the system spells them.

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
/// the SHA-512 instructions, AVX2, VAES and VPCLMULQDQ take are usable.
pub const xcr0_sse_avx: u64 = 1 << 1 | 1 << 2;

/// CPUID leaf 7, subleaf 0, EBX bit 5: AVX2.
pub const leaf_7_ebx_avx2: u32 = 1 << 5;

/// CPUID leaf 7, subleaf 0, EBX bit 29: SHA, the SHA-1 and SHA-256 instructions.
pub const leaf_7_ebx_sha: u32 = 1 << 29;

/// CPUID leaf 7, subleaf 0, ECX bit 9: VAES, the AES round instructions on YMM registers.
pub const leaf_7_ecx_vaes: u32 = 1 << 9;

/// CPUID leaf 7, subleaf 0, ECX bit 10: VPCLMULQDQ, the carry-less multiply on YMM registers.
pub const leaf_7_ecx_vpclmulqdq: u32 = 1 << 10;

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

/// AT_HWCAP bit 11: HWCAP_CPUID. Linux emulates a read of MIDR_EL1 by user code, and returns the
/// value of the core the read ran on, as sections 2 and 4 of the kernel's
/// Documentation/arch/arm64/cpu-feature-registers.rst state. Without the bit, the read raises
/// SIGILL.
pub const hwcap_cpuid: usize = 1 << 11;

/// Linux's arm64 AT_HWCAP2 word, bit 1: HWCAP2_SVE2, Arm's FEAT_SVE2.
pub const hwcap2_sve2: usize = 1 << 1;

/// The place of each MIDR_EL1 field, from bit 0: Implementer is bits 31 to 24, Variant 23 to 20,
/// Architecture 19 to 16, PartNum 15 to 4 and Revision 3 to 0. Each field's width is its type's in
/// `Midr`.
pub const midr_implementer_shift: u6 = 24;
pub const midr_variant_shift: u6 = 20;
pub const midr_architecture_shift: u6 = 16;
pub const midr_part_shift: u6 = 4;
pub const midr_revision_shift: u6 = 0;

/// The sysctl names macOS gives the features on aarch64. Each holds a 32-bit integer: 1 when
/// the CPU has the feature, 0 when it lacks it. A release older than the name has no value for it.
pub const sysctl_aes = "hw.optional.arm.FEAT_AES";
pub const sysctl_pmull = "hw.optional.arm.FEAT_PMULL";
pub const sysctl_dit = "hw.optional.arm.FEAT_DIT";
pub const sysctl_sha256 = "hw.optional.arm.FEAT_SHA256";
pub const sysctl_sha512 = "hw.optional.arm.FEAT_SHA512";
pub const sysctl_sha3 = "hw.optional.arm.FEAT_SHA3";
pub const sysctl_sve2 = "hw.optional.arm.FEAT_SVE2";

/// PSTATE.DIT's place in the value of the DIT register that `mrs` reads and `msr` writes: bit 24,
/// as Arm's A64 reference states for the register DIT. Every other bit reads as 0, and a write
/// ignores it.
pub const dit_bit: u64 = 1 << 24;
