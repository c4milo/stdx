//! `zig build test-avx512`: every module's tests built by LLVM in Debug for an x86-64 CPU with
//! AVX-512, and not run, since the host may lack the instructions.
//!
//! A caller may build stdx in Debug for such a CPU. There LLVM keeps a vector of bool in AVX-512's
//! mask registers, and its Debug build cannot pass one across a call: it stops with "Cannot emit
//! physreg copy instruction", as it did for the json module in CI run 36377079320. Only a build
//! for an AVX-512 CPU shows it, and the hosted x86-64 runners draw one only now and then, so this
//! step names the CPU.
const std = @import("std");
const modules = @import("modules.zig");

pub fn add(b: *std.Build) *std.Build.Step {
    const step = b.step(
        "test-avx512",
        "Build every module's tests in Debug for an x86-64 CPU with AVX-512, without running them",
    );
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .x86_64,
        .os_tag = .linux,
        .cpu_model = .{ .explicit = &std.Target.x86.cpu.x86_64_v4 },
    });
    const graph = modules.add(b, .{ .target = target, .optimize = .Debug, .visibility = .private });
    inline for (@typeInfo(modules.Modules).@"struct".fields) |field| {
        const tests = b.addTest(.{
            .name = field.name ++ "-avx512",
            .root_module = @field(graph, field.name),
            .use_llvm = true,
        });
        // A test binary nothing runs is not emitted, and LLVM's code generation, where the crash
        // is, runs only for one that is.
        _ = tests.getEmittedBin();
        step.dependOn(&tests.step);
    }
    return step;
}
