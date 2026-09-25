//! The baselines of decision 8 that are not also oracles, libdeflate and zlib-ng, compiled for
//! `bench/` only (CLAUDE.md, Layout). Each is built as its own build system would build it, with its
//! run-time CPU dispatch and every SIMD level of the host's architecture, so each runs its fastest
//! code on the runner; and for the architecture's baseline CPU, as the benchmarks build stdx. Nobody working on stdx reads their implementations
//! (decision 9); this file names their sources and the flags their CMake files give them.
//!
//! zlib-ng is built in its native mode, not zlib-compatible, so its public calls are `zng_`
//! functions that do not collide with the oracle's zlib in one program. Its CMake file compiles
//! each group of SIMD sources with flags that add the group's instructions. Zig passes the target's
//! whole feature list to Clang, which overrides such flags, so each group is instead a library of
//! its own, compiled for the host with the group's features added, as stdx's variant objects are
//! (build/variants.zig).
const std = @import("std");
const x86 = std.Target.x86;
const aarch64 = std.Target.aarch64;

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
    "adler32.c",       "compress.c",                    "crc32.c",        "crc32_braid_comb.c",
    "deflate.c",       "deflate_fast.c",                "deflate_huff.c", "deflate_medium.c",
    "deflate_quick.c", "deflate_rle.c",                 "deflate_slow.c", "deflate_stored.c",
    "functable.c",     "infback.c",                     "inflate.c",      "inftrees.c",
    "insert_string.c", "insert_string_roll.c",          "trees.c",        "uncompr.c",
    "zutil.c",         "arch/generic/crc32_chorba_c.c", "cpu_features.c",
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

/// One group of zlib-ng's architecture sources and the instructions its CMake flags add.
const Group = struct { files: []const []const u8, features: std.Target.Cpu.Feature.Set = .empty };

/// `evex512` gives the AVX-512 features their 512-bit registers in Clang 18 and later.
const avx512 = [_]x86.Feature{ .avx512f, .avx512dq, .avx512bw, .avx512vl, .bmi2, .evex512 };

const zlib_ng_x86_64_groups = [_]Group{
    .{ .files = &.{"arch/x86/x86_features.c"}, .features = x86.featureSet(&.{.xsave}) },
    .{ .files = &.{ "arch/x86/chunkset_sse2.c", "arch/x86/chorba_sse2.c", "arch/x86/compare256_sse2.c", "arch/x86/slide_hash_sse2.c" } },
    .{ .files = &.{ "arch/x86/adler32_ssse3.c", "arch/x86/chunkset_ssse3.c" }, .features = x86.featureSet(&.{.ssse3}) },
    .{ .files = &.{"arch/x86/chorba_sse41.c"}, .features = x86.featureSet(&.{.sse4_1}) },
    .{ .files = &.{"arch/x86/adler32_sse42.c"}, .features = x86.featureSet(&.{.sse4_2}) },
    .{ .files = &.{"arch/x86/crc32_pclmulqdq.c"}, .features = x86.featureSet(&.{ .sse4_2, .pclmul }) },
    .{
        .files = &.{ "arch/x86/slide_hash_avx2.c", "arch/x86/chunkset_avx2.c", "arch/x86/compare256_avx2.c", "arch/x86/adler32_avx2.c" },
        .features = x86.featureSet(&.{ .avx2, .bmi2 }),
    },
    .{
        .files = &.{ "arch/x86/adler32_avx512.c", "arch/x86/chunkset_avx512.c", "arch/x86/compare256_avx512.c" },
        .features = x86.featureSet(&avx512),
    },
    .{ .files = &.{"arch/x86/adler32_avx512_vnni.c"}, .features = x86.featureSet(&(avx512 ++ [_]x86.Feature{.avx512vnni})) },
    .{
        .files = &.{"arch/x86/crc32_vpclmulqdq.c"},
        .features = x86.featureSet(&(avx512 ++ [_]x86.Feature{ .pclmul, .vpclmulqdq })),
    },
};

const zlib_ng_x86_64_macros = [_][]const u8{
    "X86_FEATURES",       "X86_HAVE_XSAVE_INTRIN", "X86_SSE2", "X86_SSSE3",  "X86_SSE41",
    "X86_SSE42",          "X86_PCLMULQDQ_CRC",     "X86_AVX2", "X86_AVX512", "X86_AVX512VNNI",
    "X86_VPCLMULQDQ_CRC", "HAVE_CPUID_GNU",
};

const zlib_ng_aarch64_groups = [_]Group{
    .{ .files = &.{"arch/arm/arm_features.c"} },
    .{ .files = &.{"arch/arm/crc32_armv8.c"}, .features = aarch64.featureSet(&.{.crc}) },
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

/// The host's architecture at its baseline CPU, with `features` added. Each library picks its SIMD
/// code at run time, as stdx does, so neither needs the host's CPU model; and on a CPU with AVX10,
/// Clang's own headers cannot inline the AVX-512 VL intrinsics both libraries call (their SSE2
/// helpers then lack the `no-evex512` mark), which fails the build on the runners that have one.
fn host_with(b: *std.Build, features: std.Target.Cpu.Feature.Set) std.Build.ResolvedTarget {
    var query: std.Target.Query = .{ .cpu_model = .baseline };
    query.cpu_features_add.addFeatureSet(features);
    return b.resolveTargetQuery(query);
}

/// A module of C for the host with `features` added, built as the baselines' own builds build them.
fn c_module(b: *std.Build, features: std.Target.Cpu.Feature.Set) *std.Build.Module {
    return b.createModule(.{ .target = host_with(b, features), .optimize = .ReleaseFast, .link_libc = true });
}

/// zlib-ng's include paths and macros, which every one of its objects compiles with.
const ZlibNg = struct {
    package: *std.Build.Dependency,
    headers: std.Build.LazyPath,

    fn configure(self: ZlibNg, module: *std.Build.Module) void {
        module.addIncludePath(self.headers);
        module.addIncludePath(self.package.path(""));
        for (zlib_ng_common_macros) |name| module.addCMacro(name, "1");
        const host = module.resolved_target.?.result;
        switch (host.cpu.arch) {
            .x86_64 => for (zlib_ng_x86_64_macros) |name| module.addCMacro(name, "1"),
            .aarch64 => {
                for (zlib_ng_aarch64_macros) |name| module.addCMacro(name, "1");
                if (host.os.tag == .linux) {
                    module.addCMacro("HAVE_SYS_AUXV_H", "1");
                    module.addCMacro("ARM_AUXV_HAS_CRC32", "1");
                }
            },
            else => module.addCMacro("WITH_ALL_FALLBACKS", "1"),
        }
    }

    /// The sources on no architecture's list of groups.
    fn add_common(self: ZlibNg, module: *std.Build.Module, fallbacks: []const []const u8) void {
        module.addCSourceFiles(.{ .root = self.package.path(""), .files = &zlib_ng_sources });
        module.addCSourceFiles(.{ .root = self.package.path(""), .files = fallbacks });
    }

    /// Each group as a static library of its own, linked into `module`.
    fn link_groups(self: ZlibNg, b: *std.Build, module: *std.Build.Module, groups: []const Group) void {
        for (groups, 0..) |group, index| {
            const group_module = c_module(b, group.features);
            self.configure(group_module);
            group_module.addCSourceFiles(.{ .root = self.package.path(""), .files = group.files });
            const name = b.fmt("zlib_ng_group_{d}", .{index});
            module.linkLibrary(b.addLibrary(.{ .name = name, .linkage = .static, .root_module = group_module }));
        }
    }
};

/// Links libdeflate and zlib-ng, built for the host, into `consumer`, with
/// `bench/baselines/baselines.c` over their public calls. False until the packages are fetched.
pub fn link(b: *std.Build, consumer: *std.Build.Module) bool {
    const libdeflate = b.lazyDependency("libdeflate", .{}) orelse return false;
    const zlib_ng_package = b.lazyDependency("zlib_ng", .{}) orelse return false;
    const arch = b.graph.host.result.cpu.arch;
    // libdeflate marks its AVX-512 functions with target attributes instead, which need the
    // `evex512` feature in the target on a host CPU without AVX-512.
    const evex512 = if (arch == .x86_64) x86.featureSet(&.{.evex512}) else std.Target.Cpu.Feature.Set.empty;
    const library = b.addLibrary(.{ .name = "baselines_c", .linkage = .static, .root_module = c_module(b, evex512) });
    const module = library.root_module;
    module.addIncludePath(libdeflate.path(""));
    module.addCSourceFiles(.{ .root = libdeflate.path(""), .files = &libdeflate_sources });

    // CMake writes zlib-ng's three public headers from templates. With HAVE_UNISTD_H defined and
    // no symbol prefix, each template is already the header, so the build copies it.
    const headers = b.addWriteFiles();
    _ = headers.addCopyFile(zlib_ng_package.path("zconf-ng.h.in"), "zconf-ng.h");
    _ = headers.addCopyFile(zlib_ng_package.path("zlib-ng.h.in"), "zlib-ng.h");
    _ = headers.addCopyFile(zlib_ng_package.path("zlib_name_mangling.h.empty"), "zlib_name_mangling-ng.h");
    const zlib_ng: ZlibNg = .{ .package = zlib_ng_package, .headers = headers.getDirectory() };
    zlib_ng.configure(module);
    switch (arch) {
        .x86_64 => {
            zlib_ng.add_common(module, &zlib_ng_x86_64_fallbacks);
            zlib_ng.link_groups(b, consumer, &zlib_ng_x86_64_groups);
        },
        .aarch64 => {
            zlib_ng.add_common(module, &zlib_ng_all_fallbacks);
            zlib_ng.link_groups(b, consumer, &zlib_ng_aarch64_groups);
        },
        else => zlib_ng.add_common(module, &zlib_ng_all_fallbacks),
    }
    module.addCSourceFile(.{ .file = b.path("bench/baselines/baselines.c") });
    consumer.link_libc = true;
    consumer.linkLibrary(library);
    return true;
}
