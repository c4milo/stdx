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
//! form, for the architecture's baseline CPU (decision 75). Its held-out set reads rebar's files,
//! which tools/corpus/fetch.sh fetches at a pinned commit. `-- --held-out` times that set alone.
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

/// rebar, the regex benchmark whose two sets bench-regex times (decision 86 as amended), at the
/// commit bench/regex/regex_rebar.zig was written from. tools/corpus/fetch.sh fetches each file
/// the sets read and refuses one whose SHA-256 is not the pinned one.
const rebar_url = "https://raw.githubusercontent.com/BurntSushi/rebar/463d00f31887e84c38467805b9e3122c314b9521/benchmarks/";

/// The sets' haystacks and pattern files, by their paths under rebar's `benchmarks/`.
const rebar_files = [_]struct { path: []const u8, sha256: []const u8 }{
    .{ .path = "haystacks/bstr-ext-slice-65993b58.txt", .sha256 = "3fba7273b2cb5c231d5175962ee69c82653e1f2772cad6355948837dc10b43fd" },
    .{ .path = "haystacks/cloud-flare-redos.txt", .sha256 = "2950cee4e38166459d4314a6e61929d2e7b9edc32cd50f029e79ac549c783a1d" },
    .{ .path = "haystacks/imported/leipzig-3200.txt", .sha256 = "f2aa28234e7a8212c9e009fa9c67d1960d2d063d076765de46b0faed5fe44ad8" },
    .{ .path = "haystacks/imported/lh3lh3-reb-howto.txt", .sha256 = "531b74b821c3d365cfb32380e5fa0d75affb295926e14865589855bd6c26052f" },
    .{ .path = "haystacks/imported/mariomka.txt", .sha256 = "7b7f70c9ca999b2bede85b7ed8e37c9193edced196f4aed29651e37ef4f8e979" },
    .{ .path = "haystacks/imported/regex-redux-100000.fasta", .sha256 = "2907f3fb66fea247549c0f26b5b5d5cd1940a055574b72dad344283e1eb0fd10" },
    .{ .path = "haystacks/imported/rsc/1K.txt", .sha256 = "f6fe24d5a17312fb00dd88e9539ce5db203c014b8b87beb2d1d81684cdf1d3df" },
    .{ .path = "haystacks/imported/rsc/1MB.txt", .sha256 = "5cc77f81d39a96455fe9d6727bf3feebd2cb0a69d7e3f299cac763ff3fd3b447" },
    .{ .path = "haystacks/imported/rsc/32.txt", .sha256 = "84f5d95df42415ffec0d3a260f2f7f3950d126ff9ae7eab20584927584693a75" },
    .{ .path = "haystacks/imported/rsc/32K.txt", .sha256 = "a382af162278c386e11f65b05b25099fbbff250fb47b0775548f9b7f137d5ce6" },
    .{ .path = "haystacks/imported/rsc/anchored-literal-long.txt", .sha256 = "5f4eff6dbc548f3db5ee2ac0bfcf6dce1300092f8de8a7317afe5b606401cc39" },
    .{ .path = "haystacks/imported/rsc/long-needle1.txt", .sha256 = "4d068a75dba5a8f2d129558c1c8c95558a0387a16bce02447862d83103b82faa" },
    .{ .path = "haystacks/imported/rsc/long-needle2.txt", .sha256 = "911a051c2796a6aaeb233d8870597564cec03656b26479b9529b9fe1e11dd4f5" },
    .{ .path = "haystacks/lines-with-invalid-utf8.txt", .sha256 = "17dc472dca4c1602cca5a7f25a30added1117253e60cbbcdd51ef3e204530a89" },
    .{ .path = "haystacks/opensubtitles/en-huge.txt", .sha256 = "07ff024bdc05f6c2b4bc0b5b768a332a18a616261fcbd16b41e953df1c7fa7ff" },
    .{ .path = "haystacks/opensubtitles/en-medium.txt", .sha256 = "d1da7bb695f9807deaa21306ee0c132f09d92d92c13d07219792c6765480f90c" },
    .{ .path = "haystacks/opensubtitles/en-sampled.txt", .sha256 = "0d40805f6d02c8fe02bd75945b98911891f707e8ecb939e018446858065d76ea" },
    .{ .path = "haystacks/opensubtitles/en-tiny.txt", .sha256 = "fb3fa0f377a15f21b5e3658b4b791e38d7a6015e808dc17666652beba7de7eae" },
    .{ .path = "haystacks/opensubtitles/ru-huge.txt", .sha256 = "40d93a4618e69e81c063902106c243759f1bb08b48bdf593a288c386b0d9fe0c" },
    .{ .path = "haystacks/opensubtitles/ru-medium.txt", .sha256 = "d266a0858e828a9e725d89a947f56507cb63fba2d4b45847dc232a0b7ca95a4e" },
    .{ .path = "haystacks/opensubtitles/ru-sampled.txt", .sha256 = "7ffddb21336a1bfb4a9e2df4bb77eea0305c0010a57c5d3c56e0dfead9e80a90" },
    .{ .path = "haystacks/opensubtitles/zh-sampled.txt", .sha256 = "f129e81928c58ecbba0ccbb63b36679355345248df057d1e9ded670d6e9c964b" },
    .{ .path = "haystacks/rust-src-tools-3b0d4813.txt", .sha256 = "7d43cc8dfd053b083b809bd7ce7d4a074f2fd24a6b7ec38908b3966f3324fa36" },
    .{ .path = "haystacks/sherlock.txt", .sha256 = "242ec73a70f0a03dcbe007e32038e7deeaee004aaec9a09a07fa322743440fa8" },
    .{ .path = "haystacks/unicode/allcodepoints.txt", .sha256 = "e0a7693f7362e88827c15e772e55b3490bd983f90711df7f3ef36c2b1ef6847e" },
    .{ .path = "haystacks/wild/UnicodeData-15.0.0.txt", .sha256 = "806e9aed65037197f1ec85e12be6e8cd870fc5608b4de0fffd990f689f376a73" },
    .{ .path = "haystacks/wild/cpython-226484e4.py", .sha256 = "1aaf33e0e5d90f0b350c5e04c3817c6c12b9e1ee0cecf2433c8ee6a7bae176d2" },
    .{ .path = "haystacks/wild/parol-veryl.vl", .sha256 = "adf5fcdfb6071e5470b77a45b33826ccf6a0cb8709e5157697d5a9838a4e0b81" },
    .{ .path = "haystacks/wild/rg-13.0.0-x86_64-pc-windows-msvc.bin", .sha256 = "ab5595a4f7a6b918cece0e7e22ebc883ead6163948571419a1dd5cd3c7f37972" },
    .{ .path = "haystacks/wild/rg-13.0.0-x86_64-unknown-linux-musl.bin", .sha256 = "4ef156371199b3ddac1bf584e0e52b1828279af82e4ea864b4d9c816adb5db40" },
    .{ .path = "haystacks/wild/unstructured-to-json.log", .sha256 = "3afccfa634a74ce4045267ac5486f900d73fe5b58a96ba70b659249cf6f64be7" },
    .{ .path = "regexes/dictionary/english/length-10.txt", .sha256 = "3a335fd5d8c2fd4ab5c01e5f0635697efdbf7fd07544ff7da6e093b780cfa59a" },
    .{ .path = "regexes/dictionary/english/length-15.txt", .sha256 = "8e5c78a5b7db76cfd0bca99157cdb7088b379aee9aa34508de0cc9cb42c274e7" },
    .{ .path = "regexes/reported/i787-keywords.txt", .sha256 = "4f85e910d767ae251fcac285a1c4a5ebf030df6b87b4d9d25853ceba9bd3df51" },
    .{ .path = "regexes/wild/bibleref.txt", .sha256 = "adb897ec9ec7e6f892d9f35d1de294f380d34b46b853e2f9f950ff8c23b8c2d6" },
    .{ .path = "regexes/wild/date.txt", .sha256 = "0d223554e54ce6bfb34bbb3aa510a4a0941a3856882c64b0d971cc6b10f893bf" },
    .{ .path = "regexes/wild/parol-veryl.txt", .sha256 = "0ba9358c2787da1696c4f98ab393c979fe5ece5dac75934eb1553b1d8e04fb93" },
    .{ .path = "regexes/wild/ucd-parse.txt", .sha256 = "3f1c1df738d353947bd3f10bf34234305a024a2bcd46abaee6ba5d0d6f6d6788" },
    .{ .path = "regexes/wild/unstructured-to-json.txt", .sha256 = "7b2a622c8e436ada0c357e61c773de8d05adb59ed12475aeb50643d2ad8cd894" },
    .{ .path = "regexes/wild/url.txt", .sha256 = "b42a35cadcffd7bbd7198ac80f20dfc026b3e4e1994bdff5bdc52e72c828545a" },
};

/// What the step says on a host without go.
const missing_message = "differential-regex builds its oracle with go; put go on the path";

/// The files of the check and of the benchmark that hold tests and need no oracle, each with the
/// modules it imports.
/// The program's root imports the Go oracle's bindings, and its tests call none of them, so they
/// link with no archive.
const tested = [_]struct { root: []const u8, codec: bool = false, regex: bool = false, program: bool = false, timing: bool = false }{
    .{ .root = "tools/oracle/verdicts_regex.zig" },
    .{ .root = "tools/differential/regex.zig", .codec = true, .regex = true, .program = true },
    // The benchmark's workloads: its patterns and the short texts it generates.
    .{ .root = "bench/regex/regex_cases.zig", .codec = true },
    // The held-out set's line split, its UTF-8 repair and its line ranges.
    .{ .root = "bench/regex/regex_engines_rebar.zig", .codec = true, .regex = true },
    .{ .root = "bench/regex/regex_held_out.zig", .codec = true, .regex = true, .timing = true },
    // The order a row times its candidates in.
    .{ .root = "bench/regex/regex_table.zig", .codec = true, .regex = true, .timing = true },
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
    for (rebar_files) |file| {
        const fetch = b.addSystemCommand(&.{ "bash", "tools/corpus/fetch.sh", b.fmt("{s}{s}", .{ rebar_url, file.path }), file.sha256 });
        fetch.addFileInput(b.path("tools/corpus/fetch.sh"));
        run.addPrefixedFileArg(b.fmt("rebar/{s}=", .{file.path}), fetch.addOutputFileArg(std.fs.path.basename(file.path)));
    }
    if (b.args) |args| run.addArgs(args);
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
    const timing = host_module(b, "bench/timing/timing.zig");
    timing.addImport("platform", graph.platform);
    for (tested) |entry| {
        const module = host_module(b, entry.root);
        if (entry.codec) module.addImport("codec", graph.codec);
        if (entry.regex) module.addImport("regex", graph.regex);
        if (entry.timing) module.addImport("timing", timing);
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
