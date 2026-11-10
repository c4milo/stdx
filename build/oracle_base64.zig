//! bench-base64 (decision 68): base 64 against Rust's `base64` crate, the one connect-rust's Buffa
//! uses, Go's encoding/base64, which Go's protojson uses, and Zig's std.base64. cargo builds the
//! Rust crate and go the Go package, each from its pinned sources under bench/base64/
//! (oracle_toolchains.zig), and the benchmark links both. Like every baseline, they build only
//! with `-Doracles`, and only on a host with cargo and go on its path.
const std = @import("std");
const modules = @import("modules.zig");
const toolchains = @import("oracle_toolchains.zig");

/// What the step says on a host without both toolchains.
const missing_message = "bench-base64 builds its baselines with cargo and go; put both on the path";

pub fn add(b: *std.Build, step: *std.Build.Step, timing: *std.Build.Module, graph: modules.Modules, baseline: std.Build.ResolvedTarget) void {
    // A host without cargo or go builds every other program, and this step says what it lacks.
    if (!toolchains.has(b, "cargo") or !toolchains.has(b, "go")) {
        step.dependOn(&b.addFail(missing_message).step);
        return;
    }
    const module = b.createModule(.{
        .root_source_file = b.path("bench/base64/base64.zig"),
        .target = baseline,
        .optimize = .ReleaseSafe,
    });
    module.addImport("timing", timing);
    module.addImport("codec", graph.codec);
    module.addImport("base64", graph.base64);
    module.addObjectFile(toolchains.cargo_archive(b, "bench/base64/rust", "libstdx_bench_base64_rust.a", &.{"src/lib.rs"}));
    module.addObjectFile(toolchains.go_archive(b, "bench/base64/go", "go_base64.a", &.{ "base64.go", "go.mod" }));
    toolchains.link_runtimes(module, baseline);
    const program = b.addExecutable(.{ .name = "bench_base64", .root_module = module });
    b.installArtifact(program);
    const run = b.addRunArtifact(program);
    run.has_side_effects = true;
    step.dependOn(&run.step);
}
