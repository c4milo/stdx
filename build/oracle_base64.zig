//! bench-base64 (decision 68): base 64 against Zig's std.base64. It links no oracle, but it times
//! with bench/timing/timing.zig, which the oracle build gives, so it runs with `-Doracles` as every
//! benchmark does.
const std = @import("std");
const modules = @import("modules.zig");

pub fn add(b: *std.Build, step: *std.Build.Step, timing: *std.Build.Module, graph: modules.Modules, baseline: std.Build.ResolvedTarget) void {
    const module = b.createModule(.{
        .root_source_file = b.path("bench/base64/base64.zig"),
        .target = baseline,
        .optimize = .ReleaseSafe,
    });
    module.addImport("timing", timing);
    module.addImport("codec", graph.codec);
    module.addImport("base64", graph.base64);
    const program = b.addExecutable(.{ .name = "bench_base64", .root_module = module });
    b.installArtifact(program);
    const run = b.addRunArtifact(program);
    run.has_side_effects = true;
    step.dependOn(&run.step);
}
