//! `zig build coverage`: the share of each module's lines that its unit tests run, counted by
//! kcov through pepegrillo's coverage engine (tools/coverage.zig).
//!
//! kcov reads the line table the compiler writes, so the step builds every module's tests in
//! Debug with LLVM: Zig's own x86-64 backend writes an incomplete table. kcov finds the sources
//! at the paths the compiler saw, so the engine runs in the repository's root. kcov runs on Linux
//! alone; on another host the engine says it found no kcov and the step fails.
const std = @import("std");
const modules = @import("modules.zig");

pub fn add(b: *std.Build, tool: *std.Build.Module) *std.Build.Step {
    const step = b.step("coverage", "Run every module's tests under kcov, and print each module's line coverage (Linux)");
    const graph = modules.add(b, .{ .target = b.graph.host, .optimize = .Debug, .visibility = .private });
    const run = b.addRunArtifact(b.addExecutable(.{ .name = "coverage", .root_module = tool }));
    run.setCwd(b.path("."));
    // kcov's runs are the output, and the engine writes them under zig-out/coverage itself.
    run.has_side_effects = true;
    inline for (@typeInfo(modules.Modules).@"struct".fields) |field| {
        // `crypto` is optional, and this graph asks for no chapulin (decision 87).
        if (comptime field.type != *std.Build.Module) continue;
        run.addArtifactArg(b.addTest(.{
            .name = field.name ++ "-coverage",
            .root_module = @field(graph, field.name),
            .use_llvm = true,
        }));
    }
    step.dependOn(&run.step);
    return step;
}
