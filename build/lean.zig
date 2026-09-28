//! `zig build lean [-- write]`: pepegrillo's lake runner over the Lean proofs in spec/lean/, then
//! the check that the vector files the Zig tests replay are what the proved machines give
//! (decision 28). It is not part of `zig build test`: it needs lake, from elan or a Lean release,
//! which tools/ci.sh looks for.
const std = @import("std");

pub fn add(b: *std.Build, tool: *std.Build.Module) void {
    const program = b.addExecutable(.{ .name = "lean", .root_module = tool });
    const run = b.addRunArtifact(program);
    if (b.args) |arguments| run.addArgs(arguments);
    run.setCwd(b.path("."));
    run.has_side_effects = true;
    const step = b.step("lean", "Build the Lean proofs in spec/lean/ and check the vectors they give");
    step.dependOn(&run.step);
}
