//! The variant objects of decision 21: each SIMD path compiled once per feature level, for a CPU
//! with that level's features, and linked into its library module. Zig 0.16 cannot compile one
//! function for more CPU features than its module's target, so a level is an object of its own.
//!
//! A module's variants root is `src/<module>/variants.zig`, which reads its level from the
//! `variant_level` option and exports that level's kernels alone. A caller's `codec.Features`
//! decides at run time which kernels the module calls.
const std = @import("std");

/// The feature levels, as `src/<module>/variants.zig` names them.
pub const Level = enum { x86_64_ssse3, x86_64_pclmul, x86_64_avx2, x86_64_vpclmul, x86_64_avx512, x86_64_avx512_vnni, aarch64_crc_pmull, aarch64_dotprod };

/// The levels the json module builds: claim J7's AVX2, and AVX-512 for decision 39's check alone.
pub const json_levels = [_]Level{ .x86_64_avx2, .x86_64_avx512 };

/// The levels of base64's variant object (decision 68): its decoding step takes AVX2's `vpshufb`.
pub const base64_levels = [_]Level{.x86_64_avx2};

/// The levels of regex's variant object (decision 86): claims R2 and R5 search 32 octets a step
/// with AVX2, and claim R5 takes Teddy's PSHUFB at 16 octets with SSSE3 alone.
pub const regex_levels = [_]Level{ .x86_64_ssse3, .x86_64_avx2 };

/// The levels of the checksum module's variant objects: every level but SSSE3's, which no
/// checksum kernel takes alone.
pub const checksum_levels = [_]Level{
    .x86_64_pclmul,      .x86_64_avx2,       .x86_64_vpclmul,  .x86_64_avx512,
    .x86_64_avx512_vnni, .aarch64_crc_pmull, .aarch64_dotprod,
};

/// The levels of this architecture, which `add_levels` builds where a module wants them.
pub fn levels_of(arch: std.Target.Cpu.Arch) []const Level {
    return switch (arch) {
        .x86_64 => &.{ .x86_64_ssse3, .x86_64_pclmul, .x86_64_avx2, .x86_64_vpclmul, .x86_64_avx512, .x86_64_avx512_vnni },
        .aarch64 => &.{ .aarch64_crc_pmull, .aarch64_dotprod },
        else => &.{},
    };
}

/// The target of one level: the module's target with the level's features added.
fn level_target(b: *std.Build, target: std.Build.ResolvedTarget, level: Level) std.Build.ResolvedTarget {
    var query = target.query;
    switch (level) {
        // A CPU with SSSE3 and no AVX: the baseline and SSSE3 alone, whatever the module's CPU,
        // so that the object holds no instruction of AVX, and the tests on any host run PSHUFB.
        .x86_64_ssse3 => {
            query.cpu_model = .baseline;
            query.cpu_features_add = std.Target.x86.featureSet(&.{.ssse3});
            query.cpu_features_sub = .empty;
        },
        .x86_64_pclmul => query.cpu_features_add = std.Target.x86.featureSet(&.{ .pclmul, .sse4_1 }),
        .x86_64_avx2 => query.cpu_features_add = std.Target.x86.featureSet(&.{ .avx2, .bmi2, .fma, .pclmul, .sse4_1 }),
        .x86_64_vpclmul => query.cpu_features_add = std.Target.x86.featureSet(&.{ .avx2, .pclmul, .sse4_1, .vpclmulqdq }),
        .x86_64_avx512 => query.cpu_features_add = std.Target.x86.featureSet(&.{
            .avx2,    .avx512f, .avx512bw, .avx512dq,   .avx512vl,
            .evex512, .bmi2,    .pclmul,   .vpclmulqdq, .sse4_1,
        }),
        .x86_64_avx512_vnni => query.cpu_features_add = std.Target.x86.featureSet(&.{
            .avx2, .avx512f, .avx512bw, .avx512dq, .avx512vl, .avx512vnni, .evex512, .bmi2,
        }),
        .aarch64_crc_pmull => query.cpu_features_add = std.Target.aarch64.featureSet(&.{ .crc, .aes }),
        .aarch64_dotprod => query.cpu_features_add = std.Target.aarch64.featureSet(&.{.dotprod}),
    }
    return b.resolveTargetQuery(query);
}

/// Compiles `src/<name>/variants.zig` once for each level of `wanted` that the target's
/// architecture has, and links each object into `module`: a module whose kernels need few levels
/// builds no empty object for the others.
pub fn add_levels(
    b: *std.Build,
    module: *std.Build.Module,
    comptime name: []const u8,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    wanted: []const Level,
) void {
    for (levels_of(target.result.cpu.arch)) |level| {
        if (std.mem.indexOfScalar(Level, wanted, level) == null) continue;
        module.addObject(object(b, name, target, optimize, level));
    }
}

/// Gives a variant object's root the library modules its kernels import, each built for the
/// level's target as the object is. `json`'s kernels check UTF-8 with the `utf8` module, and
/// `regex`'s constants name UTF-8's limits from it (decision 86). The other modules' kernels
/// import none.
fn add_imports(
    b: *std.Build,
    root: *std.Build.Module,
    comptime name: []const u8,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) void {
    if (!comptime (std.mem.eql(u8, name, "json") or std.mem.eql(u8, name, "regex"))) return;
    root.addImport("utf8", b.createModule(.{
        .root_source_file = b.path("src/utf8/utf8.zig"),
        .target = target,
        .optimize = optimize,
    }));
}

/// The object of one level: `src/<name>/variants.zig` compiled for the level's target.
pub fn object(
    b: *std.Build,
    comptime name: []const u8,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    level: Level,
) *std.Build.Step.Compile {
    const options = b.addOptions();
    options.addOption(Level, "level", level);
    const root = b.createModule(.{
        .root_source_file = b.path("src/" ++ name ++ "/variants.zig"),
        .target = level_target(b, target, level),
        .optimize = optimize,
    });
    root.addOptions("variant_level", options);
    add_imports(b, root, name, level_target(b, target, level), optimize);
    // LLVM, in every mode: Zig's own x86-64 backend, which Debug builds use on Linux, cannot
    // place a 512-bit operand of inline assembly.
    return b.addObject(.{
        .name = b.fmt("{s}_{t}", .{ name, level }),
        .root_module = root,
        .use_llvm = true,
    });
}
