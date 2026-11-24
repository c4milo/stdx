//! `zig build matcher-replay`: the program that holds `Matcher.find` to the Lean model on a file
//! of vectors it reads when it runs (tools/matcher_replay.zig, decision 86, design §8 part
//! 22h). `tools/matcher_model_check.sh` has Lean write such a file for a new seed, and runs the
//! program on it. `zig build test` runs the program's own tests.
const std = @import("std");
const modules = @import("modules.zig");

/// The step that runs the program's own tests.
pub fn add(b: *std.Build) *std.Build.Step {
    const graph = modules.add(b, .{ .target = b.graph.host, .optimize = .Debug, .visibility = .private });
    const module = b.createModule(.{
        .root_source_file = b.path("tools/matcher_replay.zig"),
        .target = b.graph.host,
        .optimize = .Debug,
    });
    module.addImport("regex", graph.regex);
    const tool = b.addExecutable(.{ .name = "matcher_replay", .root_module = module });
    const install = b.addInstallArtifact(tool, .{});
    b.step("matcher-replay", "Build the program that replays matcher vectors against Matcher.find").dependOn(&install.step);
    const tests = b.addTest(.{ .name = "matcher_replay", .root_module = module });
    return &b.addRunArtifact(tests).step;
}
