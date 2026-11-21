//! `zig build differential-regex -Doracles` (decision 86): the regex module against Go's regexp
//! over generated patterns, and against RE2's own test logs (`tools/differential/regex.zig`).
//!
//! - go builds the oracle as a c-archive from tools/oracle/go_regexp/, by the Go release its
//!   go.mod names (oracle_toolchains.zig). A host without go on its path builds every other
//!   program, and this step says what it lacks.
//! - RE2's `make log` writes what RE2 answers on its search tests and its exhaustive tests, and
//!   Go's repository keeps both logs. tools/corpus/fetch.sh fetches them at the tag below and
//!   refuses a file whose SHA-256 is not the pinned one, as it does for a corpus file (decision
//!   15).
//!
//! The check's own parts need no oracle: `zig build test` runs their tests (`add_tests`).
const std = @import("std");
const modules = @import("modules.zig");
const toolchains = @import("oracle_toolchains.zig");

/// Where Go's repository keeps RE2's logs, at the tag of the release they were read from.
const logs_url = "https://raw.githubusercontent.com/golang/go/go1.24.7/src/regexp/testdata/";

/// Each log, in the order the check takes them, with its SHA-256.
const logs = [_]struct { name: []const u8, sha256: []const u8 }{
    .{ .name = "re2-search.txt", .sha256 = "b6876d87b65a31a3d909f58f7100d9f7b501dfd4c79c3e6a73c50868de434c9d" },
    .{ .name = "re2-exhaustive.txt.bz2", .sha256 = "f1253bff45157cd2a71d7729e11a19ad8ae15efdc0af00fe0939289e6e1a4ec8" },
};

/// What the step says on a host without go.
const missing_message = "differential-regex builds its oracle with go; put go on the path";

/// The files of the check that hold tests and need no oracle, each with the library modules it
/// imports.
const tested = [_]struct { root: []const u8, codec: bool = false, regex: bool = false }{
    .{ .root = "tools/oracle/verdicts_regex.zig" },
    .{ .root = "tools/differential/regex_generate.zig", .codec = true },
    .{ .root = "tools/differential/regex_re2_log.zig", .regex = true },
};

pub fn add(b: *std.Build, step: *std.Build.Step) void {
    if (!toolchains.has(b, "go")) {
        step.dependOn(&b.addFail(missing_message).step);
        return;
    }
    // The library as the other differential checks build it: for the architecture's baseline CPU,
    // ReleaseSafe, exported to nobody (build/oracle.zig).
    const baseline = b.resolveTargetQuery(.{ .cpu_model = .baseline });
    const graph = modules.add(b, .{ .target = baseline, .optimize = .ReleaseSafe, .visibility = .private });
    const oracle = b.createModule(.{
        .root_source_file = b.path("tools/oracle/oracle_regexp.zig"),
        .target = baseline,
        .optimize = .ReleaseSafe,
    });
    oracle.addObjectFile(toolchains.go_archive(b, "tools/oracle/go_regexp", "go_regexp.a", &.{ "regexp.go", "go.mod" }));
    toolchains.link_runtimes(oracle, baseline);
    const module = b.createModule(.{
        .root_source_file = b.path("tools/differential/regex.zig"),
        .target = baseline,
        .optimize = .ReleaseSafe,
    });
    module.addImport("codec", graph.codec);
    module.addImport("regex", graph.regex);
    module.addImport("oracle_regexp", oracle);
    module.addImport("verdicts", b.createModule(.{
        .root_source_file = b.path("tools/oracle/verdicts_regex.zig"),
        .target = baseline,
        .optimize = .ReleaseSafe,
    }));
    const program = b.addExecutable(.{ .name = "differential_regex", .root_module = module });
    const run = b.addRunArtifact(program);
    for (logs) |log| {
        const fetch = b.addSystemCommand(&.{ "bash", "tools/corpus/fetch.sh", b.fmt("{s}{s}", .{ logs_url, log.name }), log.sha256 });
        fetch.addFileInput(b.path("tools/corpus/fetch.sh"));
        run.addFileArg(fetch.addOutputFileArg(log.name));
    }
    run.has_side_effects = true;
    step.dependOn(&run.step);
}

/// The tests of the check's own parts: the verdict entries, the generator of patterns and the
/// reader of RE2's logs, with stdx's side of the check. They run on the host in Debug, as every
/// tool's tests do, over a library graph of their own.
pub fn add_tests(b: *std.Build) *std.Build.Step {
    const step = b.step("test-differential-regex", "Run the tests of differential-regex's own parts, which need no oracle");
    const graph = modules.add(b, .{ .target = b.graph.host, .optimize = .Debug, .visibility = .private });
    for (tested) |entry| {
        const module = b.createModule(.{
            .root_source_file = b.path(entry.root),
            .target = b.graph.host,
            .optimize = .Debug,
        });
        if (entry.codec) module.addImport("codec", graph.codec);
        if (entry.regex) module.addImport("regex", graph.regex);
        const tests = b.addTest(.{ .name = std.fs.path.stem(entry.root), .root_module = module });
        step.dependOn(&b.addRunArtifact(tests).step);
    }
    return step;
}
