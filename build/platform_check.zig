//! `zig build platform-check`: decision 40's check. tools/platform_check.zig requires
//! `platform.probe()` to give the answers the host reports through /proc/cpuinfo on Linux and
//! `sysctl` on macOS. `zig build test` runs it, so it runs on every CI runner (decision 19).
//!
//! The check builds `platform` for the generic CPU of the host's architecture, so every answer it
//! compares comes from the host's source and none from what the build target guarantees. On Linux
//! it builds the check twice, without libc and with it: the probe reads the auxiliary vector
//! through Zig's `getauxval` in one and libc's in the other.
const std = @import("std");
const modules = @import("modules.zig");

/// The check's step, and the step that runs the tool's own tests.
pub const Steps = struct { check: *std.Build.Step, tests: *std.Build.Step };

pub fn add(b: *std.Build) Steps {
    const check = b.step("platform-check", "Require the platform module's answers to equal the host's");
    const host = b.graph.host.result;
    const target = b.resolveTargetQuery(.{
        .cpu_arch = host.cpu.arch,
        .cpu_model = .{ .explicit = std.Target.Cpu.Model.generic(host.cpu.arch) },
        .os_tag = host.os.tag,
        .abi = host.abi,
    });
    const libc_choices: []const bool = if (host.os.tag == .linux) &.{ false, true } else &.{false};
    for (libc_choices) |link_libc| {
        const tool = b.addExecutable(.{
            .name = if (link_libc) "platform_check_libc" else "platform_check",
            .root_module = tool_module(b, target, link_libc),
        });
        check.dependOn(&b.addRunArtifact(tool).step);
    }
    const tests = b.addTest(.{ .name = "platform_check", .root_module = tool_module(b, target, false) });
    return .{ .check = check, .tests = &b.addRunArtifact(tests).step };
}

/// The check's root module, with `platform` from the library graph built for `target`.
fn tool_module(b: *std.Build, target: std.Build.ResolvedTarget, link_libc: bool) *std.Build.Module {
    const graph = modules.add(b, .{ .target = target, .optimize = .Debug, .visibility = .private });
    // Unset rather than false: macOS links libc whatever a module asks.
    const libc: ?bool = if (link_libc) true else null;
    graph.platform.link_libc = libc;
    const module = b.createModule(.{
        .root_source_file = b.path("tools/platform_check.zig"),
        .target = target,
        .optimize = .Debug,
        .link_libc = libc,
    });
    module.addImport("platform", graph.platform);
    return module;
}
