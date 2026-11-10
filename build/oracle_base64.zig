//! bench-base64 (decision 68): base 64 against Rust's `base64` crate, the one connect-rust's Buffa
//! pins, Go's encoding/base64, which Go's protojson uses, and Zig's std.base64. cargo builds the
//! Rust crate as a static library and go builds the Go package as a c-archive, each from its
//! pinned sources under bench/base64/, and the benchmark links both. Like every baseline, they
//! build only with `-Doracles`, and only on a host with cargo and go on its path.
const std = @import("std");
const modules = @import("modules.zig");

/// What the step says on a host without both toolchains.
const missing_message = "bench-base64 builds its baselines with cargo and go; put both on the path";

pub fn add(b: *std.Build, step: *std.Build.Step, timing: *std.Build.Module, graph: modules.Modules, baseline: std.Build.ResolvedTarget) void {
    // A host without cargo or go builds every other program, and this step says what it lacks.
    const has_cargo = if (b.findProgram(&.{"cargo"}, &.{})) |_| true else |_| false;
    const has_go = if (b.findProgram(&.{"go"}, &.{})) |_| true else |_| false;
    if (!has_cargo or !has_go) {
        step.dependOn(&b.addFail(missing_message).step);
        return;
    }
    const module = b.createModule(.{
        .root_source_file = b.path("bench/base64/base64.zig"),
        .target = baseline,
        .optimize = .ReleaseSafe,
        .link_libc = true,
    });
    module.addImport("timing", timing);
    module.addImport("codec", graph.codec);
    module.addImport("base64", graph.base64);
    module.addObjectFile(rust_archive(b));
    module.addObjectFile(go_archive(b));
    if (baseline.result.os.tag == .macos) {
        // Go's runtime on macOS calls into these frameworks.
        module.linkFramework("CoreFoundation", .{});
        module.linkFramework("Security", .{});
    } else {
        module.linkSystemLibrary("pthread", .{});
        module.linkSystemLibrary("dl", .{});
        module.linkSystemLibrary("m", .{});
        // Rust's standard library, which the crate's archive holds, unwinds through libgcc_s.
        module.linkSystemLibrary("gcc_s", .{});
    }
    const program = b.addExecutable(.{ .name = "bench_base64", .root_module = module });
    b.installArtifact(program);
    const run = b.addRunArtifact(program);
    run.has_side_effects = true;
    step.dependOn(&run.step);
}

/// The Rust crate's static library, built in release with its Cargo.lock as it stands.
fn rust_archive(b: *std.Build) std.Build.LazyPath {
    const cargo = b.addSystemCommand(&.{ "cargo", "build", "--release", "--locked", "--manifest-path" });
    cargo.addFileArg(b.path("bench/base64/rust/Cargo.toml"));
    const target_dir = cargo.addPrefixedOutputDirectoryArg("--target-dir=", "cargo-target");
    cargo.addFileInput(b.path("bench/base64/rust/src/lib.rs"));
    cargo.addFileInput(b.path("bench/base64/rust/Cargo.lock"));
    return target_dir.path(b, "release/libstdx_bench_base64_rust.a");
}

/// The Go package's c-archive.
fn go_archive(b: *std.Build) std.Build.LazyPath {
    const go = b.addSystemCommand(&.{ "go", "build", "-buildmode=c-archive", "-trimpath", "-o" });
    go.setCwd(b.path("bench/base64/go"));
    go.setEnvironmentVariable("CGO_ENABLED", "1");
    const archive = go.addOutputFileArg("go_base64.a");
    go.addFileInput(b.path("bench/base64/go/base64.go"));
    go.addFileInput(b.path("bench/base64/go/go.mod"));
    return archive;
}
