//! The baselines of decision 8 that are not also oracles, libdeflate and zlib-ng, compiled for
//! `bench/` only (CLAUDE.md, Layout). Each is built as its own build system would build it for the
//! host, with its run-time CPU dispatch and every SIMD level of the host's architecture, so each
//! runs its fastest code on the runner. Nobody working on stdx reads their implementations
//! (decision 9); this file names their sources and the flags their CMake files give them.
//!
//! zlib-ng is built in its native mode, not zlib-compatible, so its public calls are `zng_`
//! functions that do not collide with the oracle's zlib in one program.
const std = @import("std");

/// libdeflate's library sources. The architecture files hold their own guards.
const libdeflate_sources = [_][]const u8{
    "lib/adler32.c",            "lib/crc32.c",            "lib/deflate_compress.c",
    "lib/deflate_decompress.c", "lib/gzip_compress.c",    "lib/gzip_decompress.c",
    "lib/utils.c",              "lib/zlib_compress.c",    "lib/zlib_decompress.c",
    "lib/arm/cpu_features.c",   "lib/x86/cpu_features.c",
};

/// zlib-ng's sources on every architecture: its CMake file's ZLIB_SRCS without the gz* layer,
/// with CRC-32 by Chorba and run-time CPU detection, as its defaults build it.
const zlib_ng_sources = [_][]const u8{
    "adler32.c",      "compress.c",                    "crc32.c",              "crc32_braid_comb.c", "deflate.c",
    "deflate_fast.c", "deflate_huff.c",                "deflate_medium.c",     "deflate_quick.c",    "deflate_rle.c",
    "deflate_slow.c", "deflate_stored.c",              "functable.c",          "infback.c",          "inflate.c",
    "inftrees.c",     "insert_string.c",               "insert_string_roll.c", "trees.c",            "uncompr.c",
    "zutil.c",        "arch/generic/crc32_chorba_c.c", "cpu_features.c",
};

/// The generic functions an x86-64 build keeps as fallbacks; SSE2 serves the rest.
const zlib_ng_x86_64_fallbacks = [_][]const u8{
    "arch/generic/adler32_c.c",     "arch/generic/adler32_fold_c.c",
    "arch/generic/crc32_braid_c.c", "arch/generic/crc32_fold_c.c",
};

/// Every generic function, which an aarch64 build keeps.
const zlib_ng_all_fallbacks = zlib_ng_x86_64_fallbacks ++ [_][]const u8{
    "arch/generic/chunkset_c.c", "arch/generic/compare256_c.c", "arch/generic/slide_hash_c.c",
};

/// One group of zlib-ng's architecture sources and the flags its CMake file compiles them with.
const Group = struct { files: []const []const u8, flags: []const []const u8 = &.{} };

const avx512_flags = [_][]const u8{ "-mavx512f", "-mavx512dq", "-mavx512bw", "-mavx512vl", "-mbmi2" };

const zlib_ng_x86_64_groups = [_]Group{
    .{ .files = &.{"arch/x86/x86_features.c"}, .flags = &.{"-mxsave"} },
    .{ .files = &.{ "arch/x86/chunkset_sse2.c", "arch/x86/chorba_sse2.c", "arch/x86/compare256_sse2.c", "arch/x86/slide_hash_sse2.c" } },
    .{ .files = &.{ "arch/x86/adler32_ssse3.c", "arch/x86/chunkset_ssse3.c" }, .flags = &.{"-mssse3"} },
    .{ .files = &.{"arch/x86/chorba_sse41.c"}, .flags = &.{"-msse4.1"} },
    .{ .files = &.{"arch/x86/adler32_sse42.c"}, .flags = &.{"-msse4.2"} },
    .{ .files = &.{"arch/x86/crc32_pclmulqdq.c"}, .flags = &.{ "-msse4.2", "-mpclmul" } },
    .{
        .files = &.{ "arch/x86/slide_hash_avx2.c", "arch/x86/chunkset_avx2.c", "arch/x86/compare256_avx2.c", "arch/x86/adler32_avx2.c" },
        .flags = &.{ "-mavx2", "-mbmi2" },
    },
    .{ .files = &.{ "arch/x86/adler32_avx512.c", "arch/x86/chunkset_avx512.c", "arch/x86/compare256_avx512.c" }, .flags = &avx512_flags },
    .{ .files = &.{"arch/x86/adler32_avx512_vnni.c"}, .flags = &(avx512_flags ++ [_][]const u8{"-mavx512vnni"}) },
    .{ .files = &.{"arch/x86/crc32_vpclmulqdq.c"}, .flags = &(avx512_flags ++ [_][]const u8{ "-mpclmul", "-mvpclmulqdq" }) },
};

const zlib_ng_x86_64_macros = [_][]const u8{
    "X86_FEATURES",       "X86_HAVE_XSAVE_INTRIN", "X86_SSE2", "X86_SSSE3",  "X86_SSE41",
    "X86_SSE42",          "X86_PCLMULQDQ_CRC",     "X86_AVX2", "X86_AVX512", "X86_AVX512VNNI",
    "X86_VPCLMULQDQ_CRC", "HAVE_CPUID_GNU",
};

const zlib_ng_aarch64_groups = [_]Group{
    .{ .files = &.{"arch/arm/arm_features.c"} },
    .{ .files = &.{"arch/arm/crc32_armv8.c"}, .flags = &.{"-mcrc"} },
    .{ .files = &.{ "arch/arm/adler32_neon.c", "arch/arm/chunkset_neon.c", "arch/arm/compare256_neon.c", "arch/arm/slide_hash_neon.c" } },
};

const zlib_ng_aarch64_macros = [_][]const u8{
    "ARM_FEATURES",       "ARM_CRC32", "ARM_CRC32_INTRIN", "HAVE_ARM_ACLE_H", "ARM_NEON", "ARM_NEON_HASLD4",
    "WITH_ALL_FALLBACKS",
};

/// The macros zlib-ng's CMake file defines on a GCC-compatible compiler, on every architecture.
const zlib_ng_common_macros = [_][]const u8{
    "WITH_OPTIM",       "HAVE_UNISTD_H",      "HAVE_ATTRIBUTE_ALIGNED", "HAVE_BUILTIN_ASSUME_ALIGNED",
    "HAVE_BUILTIN_CTZ", "HAVE_BUILTIN_CTZLL", "HAVE_VISIBILITY_HIDDEN", "HAVE_VISIBILITY_INTERNAL",
};

/// A static library of libdeflate and zlib-ng for the host, with `bench/baselines/baselines.c`
/// over their public calls. Null until the packages are fetched.
pub fn add_library(b: *std.Build) ?*std.Build.Step.Compile {
    const libdeflate = b.lazyDependency("libdeflate", .{}) orelse return null;
    const zlib_ng = b.lazyDependency("zlib_ng", .{}) orelse return null;
    const library = b.addLibrary(.{
        .name = "baselines_c",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = b.graph.host,
            .optimize = .ReleaseFast,
            .link_libc = true,
        }),
    });
    const module = library.root_module;
    module.addIncludePath(libdeflate.path(""));
    module.addCSourceFiles(.{ .root = libdeflate.path(""), .files = &libdeflate_sources });

    // CMake writes zlib-ng's three public headers from templates. With HAVE_UNISTD_H defined and
    // no symbol prefix, each template is already the header, so the build copies it.
    const headers = b.addWriteFiles();
    _ = headers.addCopyFile(zlib_ng.path("zconf-ng.h.in"), "zconf-ng.h");
    _ = headers.addCopyFile(zlib_ng.path("zlib-ng.h.in"), "zlib-ng.h");
    _ = headers.addCopyFile(zlib_ng.path("zlib_name_mangling.h.empty"), "zlib_name_mangling-ng.h");
    module.addIncludePath(headers.getDirectory());
    module.addIncludePath(zlib_ng.path(""));
    for (zlib_ng_common_macros) |name| module.addCMacro(name, "1");
    module.addCSourceFiles(.{ .root = zlib_ng.path(""), .files = &zlib_ng_sources });
    const host = b.graph.host.result;
    switch (host.cpu.arch) {
        .x86_64 => {
            for (zlib_ng_x86_64_macros) |name| module.addCMacro(name, "1");
            module.addCSourceFiles(.{ .root = zlib_ng.path(""), .files = &zlib_ng_x86_64_fallbacks });
            for (zlib_ng_x86_64_groups) |group| {
                module.addCSourceFiles(.{ .root = zlib_ng.path(""), .files = group.files, .flags = group.flags });
            }
        },
        .aarch64 => {
            for (zlib_ng_aarch64_macros) |name| module.addCMacro(name, "1");
            if (host.os.tag == .linux) {
                module.addCMacro("HAVE_SYS_AUXV_H", "1");
                module.addCMacro("ARM_AUXV_HAS_CRC32", "1");
            }
            module.addCSourceFiles(.{ .root = zlib_ng.path(""), .files = &zlib_ng_all_fallbacks });
            for (zlib_ng_aarch64_groups) |group| {
                module.addCSourceFiles(.{ .root = zlib_ng.path(""), .files = group.files, .flags = group.flags });
            }
        },
        else => {
            module.addCMacro("WITH_ALL_FALLBACKS", "1");
            module.addCSourceFiles(.{ .root = zlib_ng.path(""), .files = &zlib_ng_all_fallbacks });
        },
    }
    module.addCSourceFile(.{ .file = b.path("bench/baselines/baselines.c") });
    return library;
}
