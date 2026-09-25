//! The variant objects of decision 21: each SIMD path compiled once per feature level, for a CPU
//! with that level's features, and linked into its library module. Zig 0.16 cannot compile one
//! function for more CPU features than its module's target, so a level is an object of its own.
//!
//! A module's variants root is `src/<module>/variants.zig`, which reads its level from the
//! `variant_level` option and exports that level's kernels alone. A caller's `codec.Features`
//! decides at run time which kernels the module calls.
const std = @import("std");

/// The feature levels, as `src/<module>/variants.zig` names them.
pub const Level = enum { x86_64_pclmul, x86_64_avx2, x86_64_vpclmul, x86_64_avx512, aarch64_crc_pmull, aarch64_dotprod };

/// The levels built for a target of this architecture.
fn levels_of(arch: std.Target.Cpu.Arch) []const Level {
    return switch (arch) {
        .x86_64 => &.{ .x86_64_pclmul, .x86_64_avx2, .x86_64_vpclmul, .x86_64_avx512 },
        .aarch64 => &.{ .aarch64_crc_pmull, .aarch64_dotprod },
        else => &.{},
    };
}

/// The target of one level: the module's target with the level's features added.
fn level_target(b: *std.Build, target: std.Build.ResolvedTarget, level: Level) std.Build.ResolvedTarget {
    var query = target.query;
    switch (level) {
        .x86_64_pclmul => query.cpu_features_add = std.Target.x86.featureSet(&.{ .pclmul, .sse4_1 }),
        .x86_64_avx2 => query.cpu_features_add = std.Target.x86.featureSet(&.{ .avx2, .bmi2, .fma, .pclmul, .sse4_1 }),
        .x86_64_vpclmul => query.cpu_features_add = std.Target.x86.featureSet(&.{ .avx2, .pclmul, .sse4_1, .vpclmulqdq }),
        .x86_64_avx512 => query.cpu_features_add = std.Target.x86.featureSet(&.{
            .avx2,    .avx512f, .avx512bw, .avx512dq,   .avx512vl,
            .evex512, .bmi2,    .pclmul,   .vpclmulqdq, .sse4_1,
        }),
        .aarch64_crc_pmull => query.cpu_features_add = std.Target.aarch64.featureSet(&.{ .crc, .aes }),
        .aarch64_dotprod => query.cpu_features_add = std.Target.aarch64.featureSet(&.{.dotprod}),
    }
    return b.resolveTargetQuery(query);
}

/// Compiles `src/<name>/variants.zig` once per level of the target's architecture and links each
/// object into `module`.
pub fn add(
    b: *std.Build,
    module: *std.Build.Module,
    comptime name: []const u8,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) void {
    for (levels_of(target.result.cpu.arch)) |level| {
        const options = b.addOptions();
        options.addOption(Level, "level", level);
        const root = b.createModule(.{
            .root_source_file = b.path("src/" ++ name ++ "/variants.zig"),
            .target = level_target(b, target, level),
            .optimize = optimize,
        });
        root.addOptions("variant_level", options);
        // LLVM, in every mode: Zig's own x86-64 backend, which Debug builds use on Linux, cannot
        // place a 512-bit operand of inline assembly.
        const object = b.addObject(.{
            .name = b.fmt("{s}_{t}", .{ name, level }),
            .root_module = root,
            .use_llvm = true,
        });
        module.addObject(object);
    }
}
