//! `zig build test-self-hosted`: every module's unit tests, built by Zig's own x86-64 backend.
//!
//! Zig 0.16 builds Debug on x86-64 Linux with that backend, so a caller's default build there
//! compiles stdx with it, while build.zig builds the unit tests with LLVM (decision 23). The step
//! builds the tests for x86-64 Linux on any host, for the host's CPU where the host is x86-64 Linux,
//! and runs them only there: on any other host the binaries are foreign, and the step shows they
//! compile.
const std = @import("std");
const modules = @import("modules.zig");

pub fn add(b: *std.Build) *std.Build.Step {
    const step = b.step(
        "test-self-hosted",
        "Build every module's tests with Zig's own x86-64 backend, and run them on x86-64 Linux",
    );
    const host = b.graph.host.result;
    const target = if (host.cpu.arch == .x86_64 and host.os.tag == .linux)
        b.graph.host
    else
        b.resolveTargetQuery(.{ .cpu_arch = .x86_64, .os_tag = .linux });
    const graph = modules.add(b, .{ .target = target, .optimize = .Debug, .visibility = .private });
    inline for (@typeInfo(modules.Modules).@"struct".fields) |field| {
        const tests = b.addTest(.{
            .name = field.name ++ "-self-hosted",
            .root_module = @field(graph, field.name),
            .use_llvm = false,
        });
        const run = b.addRunArtifact(tests);
        // A host that cannot run an x86-64 Linux binary builds the tests and skips the run.
        run.skip_foreign_checks = true;
        step.dependOn(&run.step);
    }
    return step;
}
