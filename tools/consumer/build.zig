//! A project of its own that depends on stdx the way the README says, with this tree as the
//! dependency. `zig build readme-check` builds it with a nested `zig build` and runs the program
//! it builds, so the README's two `build.zig` lines are shown to work, and not only to parse.
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const exe = b.addExecutable(.{
        .name = "consumer",
        .root_module = b.createModule(.{ .root_source_file = b.path("main.zig"), .target = target }),
    });
    const stdx = b.dependency("stdx", .{ .target = target, .release = true });
    exe.root_module.addImport("stdx", stdx.module("stdx"));
    b.installArtifact(exe);
}
