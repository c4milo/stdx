//! `zig build checkfree-check`: the variant objects of decision 21, built ReleaseSafe for Linux on
//! x86-64 and aarch64, as assembly that tools/checkfree.zig reads. The tool, pepegrillo's
//! `checkfree` engine, counts the safety check sites each exported kernel reaches and requires the
//! counts tools/checkfree_sites.zig pins (decision 51).
const std = @import("std");
const variants = @import("variants.zig");

/// The architectures whose kernels the check reads.
const architectures = [_]std.Target.Cpu.Arch{ .x86_64, .aarch64 };

pub fn add(b: *std.Build, tool_module: *std.Build.Module) *std.Build.Step {
    const tool = b.addExecutable(.{ .name = "checkfree", .root_module = tool_module });
    const run = b.addRunArtifact(tool);
    if (b.args) |args| run.addArgs(args);
    for (architectures) |arch| {
        const target = b.resolveTargetQuery(.{ .cpu_arch = arch, .os_tag = .linux });
        add_levels(b, run, "checksum", target, variants.levels_of(arch));
        add_levels(b, run, "json", target, &variants.json_levels);
    }
    const step = b.step(
        "checkfree-check",
        "Require each SIMD kernel's safety check sites to equal the counts the tool pins",
    );
    step.dependOn(&run.step);
    return step;
}

/// Adds the assembly of each level of `wanted` the target's architecture has, ReleaseSafe as a
/// caller builds stdx (CLAUDE.md, Non-negotiables).
fn add_levels(
    b: *std.Build,
    run: *std.Build.Step.Run,
    comptime name: []const u8,
    target: std.Build.ResolvedTarget,
    wanted: []const variants.Level,
) void {
    for (variants.levels_of(target.result.cpu.arch)) |level| {
        if (std.mem.indexOfScalar(variants.Level, wanted, level) == null) continue;
        run.addFileArg(variants.object(b, name, target, .ReleaseSafe, level).getEmittedAsm());
    }
}
