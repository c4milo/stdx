//! The variant objects of decision 21: each SIMD path compiled once per feature level, for a CPU
//! with that level's features, and linked into its library module. Zig 0.16 cannot compile one
//! function for more CPU features than its module's target, so a level is an object of its own.
//!
//! A module's variants root is `src/<module>/variants.zig`, which reads its level from the
//! `variant_level` option and exports that level's kernels alone. A caller's `codec.Features`
//! decides at run time which kernels the module calls.
const std = @import("std");

/// The feature levels, as `src/<module>/variants.zig` names them.
pub const Level = enum { x86_64_pclmul, x86_64_avx2, aarch64_crc_pmull };

/// The levels built for a target of this architecture.
fn levels_of(arch: std.Target.Cpu.Arch) []const Level {
    return switch (arch) {
        .x86_64 => &.{ .x86_64_pclmul, .x86_64_avx2 },
        .aarch64 => &.{.aarch64_crc_pmull},
        else => &.{},
    };
}

/// The target of one level: the module's target with the level's features added.
fn level_target(b: *std.Build, target: std.Build.ResolvedTarget, level: Level) std.Build.ResolvedTarget {
    var query = target.query;
    switch (level) {
        .x86_64_pclmul => query.cpu_features_add = std.Target.x86.featureSet(&.{ .pclmul, .sse4_1 }),
        .x86_64_avx2 => query.cpu_features_add = std.Target.x86.featureSet(&.{ .avx2, .bmi2, .fma, .pclmul, .sse4_1 }),
        .aarch64_crc_pmull => query.cpu_features_add = std.Target.aarch64.featureSet(&.{ .crc, .aes }),
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
        const object = b.addObject(.{ .name = b.fmt("{s}_{t}", .{ name, level }), .root_module = root });
        module.addObject(object);
    }
}
