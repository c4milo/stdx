//! The regex module's two steps that take an oracle (decision 86).
//!
//! `zig build differential-regex -Doracles`: the module against Go's regexp over generated
//! patterns, and against RE2's own test logs (`tools/differential/regex.zig`).
//! - go builds the oracle as a c-archive from tools/oracle/go_regexp/, by the Go release its
//!   go.mod names (oracle_toolchains.zig). A host without go on its path builds every other
//!   program, and this step says what it lacks.
//! - RE2's `make log` writes what RE2 answers on its search tests and its exhaustive tests, and
//!   Go's repository keeps both logs. tools/corpus/fetch.sh fetches them at the tag below and
//!   refuses a file whose SHA-256 is not the pinned one, as it does for a corpus file (decision
//!   15).
//!
//! `zig build bench-regex -Doracles`: the module's speed beside Rust's `regex` crate, Go's regexp
//! and two libraries in Zig, zig-regex and mvzr (`bench/regex/regex.zig`). cargo builds the Rust
//! crate and go the Go package, each from its pinned sources under bench/regex/, and the two Zig
//! libraries are lazy packages of build.zig.zon. Each is built ReleaseFast, or in its release
//! form, for the architecture's baseline CPU (decision 75).
//!
//! The check's own parts need no oracle: `zig build test` runs their tests (`add_tests`).
const std = @import("std");
const modules = @import("modules.zig");
const toolchains = @import("oracle_toolchains.zig");
const oracle_corpus = @import("oracle_corpus.zig");

/// Where Go's repository keeps RE2's logs, at the tag of the release that go.mod names for the
/// oracle.
const logs_url = "https://raw.githubusercontent.com/golang/go/go1.27.4/src/regexp/testdata/";

/// Each log, in the order the check takes them, with its SHA-256.
const logs = [_]struct { name: []const u8, sha256: []const u8 }{
    .{ .name = "re2-search.txt", .sha256 = "b6876d87b65a31a3d909f58f7100d9f7b501dfd4c79c3e6a73c50868de434c9d" },
    .{ .name = "re2-exhaustive.txt.bz2", .sha256 = "f1253bff45157cd2a71d7729e11a19ad8ae15efdc0af00fe0939289e6e1a4ec8" },
};

/// What the step says on a host without go.
const missing_message = "differential-regex builds its oracle with go; put go on the path";

/// The files of the check and of the benchmark that hold tests and need no oracle, each with the
/// modules it imports.
/// The program's root imports the Go oracle's bindings, and its tests call none of them, so they
/// link with no archive.
const tested = [_]struct { root: []const u8, codec: bool = false, regex: bool = false, program: bool = false }{
    .{ .root = "tools/oracle/verdicts_regex.zig" },
    .{ .root = "tools/differential/regex.zig", .codec = true, .regex = true, .program = true },
    // The benchmark's workloads: its patterns and the short texts it generates.
    .{ .root = "bench/regex/regex_cases.zig", .codec = true },
};

/// What the benchmark says on a host without both toolchains.
const bench_missing_message = "bench-regex builds its baselines with cargo and go; put both on the path";

/// The module's two steps.
pub const Steps = struct { check: *std.Build.Step, bench: *std.Build.Step };

pub fn steps(b: *std.Build) Steps {
    return .{
        .check = b.step("differential-regex", "Require the regex module to agree with Go's regexp and RE2's test logs (-Doracles)"),
        .bench = b.step("bench-regex", "Time the regex module beside Rust's regex, Go's regexp, zig-regex and mvzr (-Doracles)"),
    };
}

/// What both steps build on: the library for the architecture's baseline CPU, ReleaseSafe, as
/// every check and benchmark builds it (build/oracle.zig), the timing module, and the corpus.
pub const Inputs = struct {
    graph: modules.Modules,
    baseline: std.Build.ResolvedTarget,
    timing: *std.Build.Module,
    corpus: oracle_corpus.Corpus,
};

pub fn add(b: *std.Build, regex_steps: Steps, inputs: Inputs) void {
    add_check(b, regex_steps.check, inputs);
    add_bench(b, regex_steps.bench, inputs);
}

fn add_bench(b: *std.Build, step: *std.Build.Step, inputs: Inputs) void {
    if (!toolchains.has(b, "cargo") or !toolchains.has(b, "go")) {
        step.dependOn(&b.addFail(bench_missing_message).step);
        return;
    }
    const zig_regex = b.lazyDependency("zig_regex", .{}) orelse return;
    const mvzr = b.lazyDependency("mvzr", .{}) orelse return;
    const module = b.createModule(.{
        .root_source_file = b.path("bench/regex/regex.zig"),
        .target = inputs.baseline,
        .optimize = .ReleaseSafe,
    });
    module.addImport("timing", inputs.timing);
    module.addImport("codec", inputs.graph.codec);
    module.addImport("regex", inputs.graph.regex);
    module.addImport("zig_regex", baseline_module(b, zig_regex.path("src/regex.zig"), inputs.baseline));
    module.addImport("mvzr", baseline_module(b, mvzr.path("src/mvzr.zig"), inputs.baseline));
    module.addObjectFile(toolchains.cargo_archive(b, "bench/regex/rust", "libstdx_bench_regex_rust.a", &.{"src/lib.rs"}));
    module.addObjectFile(toolchains.go_archive(b, "bench/regex/go", "go_regex.a", &.{ "regexp.go", "go.mod" }));
    toolchains.link_runtimes(module, inputs.baseline);
    const program = b.addExecutable(.{ .name = "bench_regex", .root_module = module });
    b.installArtifact(program);
    const run = b.addRunArtifact(program);
    oracle_corpus.add_args(b, run, inputs.corpus);
    run.has_side_effects = true;
    step.dependOn(&run.step);
}

/// A baseline library in Zig: ReleaseFast, for the architecture's baseline CPU (decision 75).
fn baseline_module(b: *std.Build, root: std.Build.LazyPath, baseline: std.Build.ResolvedTarget) *std.Build.Module {
    return b.createModule(.{ .root_source_file = root, .target = baseline, .optimize = .ReleaseFast });
}

fn add_check(b: *std.Build, step: *std.Build.Step, inputs: Inputs) void {
    if (!toolchains.has(b, "go")) {
        step.dependOn(&b.addFail(missing_message).step);
        return;
    }
    const baseline = inputs.baseline;
    const graph = inputs.graph;
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

/// The tests of the check's own parts: the verdict entries, and the program with the generator of
/// patterns, the reader of RE2's logs and stdx's side of the check. They run on the host in
/// Debug, as every tool's tests do, over a library graph of their own.
pub fn add_tests(b: *std.Build) *std.Build.Step {
    const step = b.step("test-differential-regex", "Run the tests of differential-regex's own parts, which need no oracle");
    const graph = modules.add(b, .{ .target = b.graph.host, .optimize = .Debug, .visibility = .private });
    for (tested) |entry| {
        const module = host_module(b, entry.root);
        if (entry.codec) module.addImport("codec", graph.codec);
        if (entry.regex) module.addImport("regex", graph.regex);
        if (entry.program) {
            module.addImport("oracle_regexp", host_module(b, "tools/oracle/oracle_regexp.zig"));
            module.addImport("verdicts", host_module(b, "tools/oracle/verdicts_regex.zig"));
        }
        const tests = b.addTest(.{ .name = std.fs.path.stem(entry.root), .root_module = module });
        step.dependOn(&b.addRunArtifact(tests).step);
    }
    return step;
}

/// A module compiled for the build host in Debug, as every tool's tests are.
fn host_module(b: *std.Build, root: []const u8) *std.Build.Module {
    return b.createModule(.{
        .root_source_file = b.path(root),
        .target = b.graph.host,
        .optimize = .Debug,
    });
}
