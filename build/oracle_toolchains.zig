//! cargo and go, for the baselines written in Rust and Go: bench-base64's (decision 68) and
//! bench-json's (decision 69). cargo builds a crate as a static library, and go builds a package
//! as a c-archive, each from its pinned sources under `bench/`, and a benchmark links the result.
//! A host without one of them builds every other program: `has` tells a benchmark what to leave
//! out.
const std = @import("std");

/// Whether `program` is on the host's path.
pub fn has(b: *std.Build, program: []const u8) bool {
    _ = b.findProgram(&.{program}, &.{}) catch return false;
    return true;
}

/// The static library `archive` of the crate in `directory`, built in release with its Cargo.lock
/// as it stands. `sources` are the crate's files beside its manifest, which the build watches.
pub fn cargo_archive(b: *std.Build, directory: []const u8, archive: []const u8, sources: []const []const u8) std.Build.LazyPath {
    const cargo = b.addSystemCommand(&.{ "cargo", "build", "--release", "--locked", "--manifest-path" });
    cargo.addFileArg(b.path(b.pathJoin(&.{ directory, "Cargo.toml" })));
    const target_dir = cargo.addPrefixedOutputDirectoryArg("--target-dir=", "cargo-target");
    cargo.addFileInput(b.path(b.pathJoin(&.{ directory, "Cargo.lock" })));
    for (sources) |source| cargo.addFileInput(b.path(b.pathJoin(&.{ directory, source })));
    return target_dir.path(b, b.pathJoin(&.{ "release", archive }));
}

/// The c-archive of the Go package in `directory`. `sources` are the package's files, which the
/// build watches.
pub fn go_archive(b: *std.Build, directory: []const u8, archive: []const u8, sources: []const []const u8) std.Build.LazyPath {
    const go = b.addSystemCommand(&.{ "go", "build", "-buildmode=c-archive", "-trimpath", "-o" });
    go.setCwd(b.path(directory));
    go.setEnvironmentVariable("CGO_ENABLED", "1");
    const output = go.addOutputFileArg(archive);
    for (sources) |source| go.addFileInput(b.path(b.pathJoin(&.{ directory, source })));
    return output;
}

/// Links what the archives' runtimes call on `target`: the frameworks Go's runtime takes on macOS,
/// and elsewhere the system libraries Go's and Rust's take, libgcc_s for Rust's unwinder among
/// them.
pub fn link_runtimes(module: *std.Build.Module, target: std.Build.ResolvedTarget) void {
    module.link_libc = true;
    if (target.result.os.tag == .macos) {
        module.linkFramework("CoreFoundation", .{});
        module.linkFramework("Security", .{});
        return;
    }
    for ([_][]const u8{ "pthread", "dl", "m", "gcc_s" }) |library| module.linkSystemLibrary(library, .{});
}
