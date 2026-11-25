//! `zig build readme-check`: the READMEs' code, shown to work. It builds `tools/consumer/`, a
//! project of its own that depends on this tree the way the README says, with a nested `zig build`,
//! and runs the program it built, which exits 0 when each example gives its answer. Then it
//! requires every Zig block of the README, and of the README in each module's folder, to be an
//! excerpt of that project's files. It requires the README to link each of those, and each
//! module that the module `stdx` names to have one (`tools/readme_examples.zig`, decision 88).
//! `zig build test` runs it.
//!
//! The nested build takes an empty package folder of its own through `--system`. The consumer
//! needs no package, and without it Zig copies every package of stdx's manifest, some 340 MB, into
//! `tools/consumer/zig-pkg`, which the lint would read.
const std = @import("std");

/// Every file `tools/readme_examples.zig` reads: the README, the README of each module's folder,
/// the root of the module `stdx`, and the files that a block is an excerpt of.
const excerpted_files = [_][]const u8{
    "README.md",
    "src/encoding/base64/README.md",
    "src/compress/brotli/README.md",
    "src/hash/README.md",
    "src/codec/README.md",
    "src/compress/deflate/README.md",
    "src/compress/gzip/README.md",
    "src/encoding/json/README.md",
    "src/platform/README.md",
    "src/regex/README.md",
    "src/unicode/README.md",
    "src/unicode/utf8/README.md",
    "src/compress/zlib/README.md",
    "src/compress/zstd/README.md",
    "src/stdx/stdx.zig",
    "tools/consumer/build.zig",
    "tools/consumer/main.zig",
};

pub fn add(b: *std.Build) *std.Build.Step {
    const check = b.step("readme-check", "Build and run the README's examples, and hold its Zig blocks to them");
    check.dependOn(add_consumer(b));
    check.dependOn(add_excerpts(b));
    return check;
}

/// The README's install and examples, followed as a dependent would follow them.
fn add_consumer(b: *std.Build) *std.Build.Step {
    const build = b.addSystemCommand(&.{ b.graph.zig_exe, "build", "--build-file" });
    build.addFileArg(b.path("tools/consumer/build.zig"));
    build.addArg("--system");
    _ = build.addOutputDirectoryArg("consumer-packages");
    build.addArg("--cache-dir");
    _ = build.addOutputDirectoryArg("consumer-cache");
    build.addArg("--prefix");
    const prefix = build.addOutputDirectoryArg("consumer");
    // The nested build reads the whole tree, which no list of inputs here names.
    build.has_side_effects = true;
    const run = std.Build.Step.Run.create(b, "run the README's examples");
    run.addFileArg(prefix.path(b, "bin/consumer"));
    run.has_side_effects = true;
    return &run.step;
}

/// The test that holds the README's blocks to the consumer's files.
fn add_excerpts(b: *std.Build) *std.Build.Step {
    const tests = b.addTest(.{
        .name = "readme_examples",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tools/readme_examples.zig"),
            .target = b.graph.host,
            .optimize = .Debug,
        }),
    });
    for (excerpted_files) |path| {
        tests.root_module.addAnonymousImport(path, .{ .root_source_file = b.path(path) });
    }
    return &b.addRunArtifact(tests).step;
}
