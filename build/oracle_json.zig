//! `zig build bench-json -Doracles`'s program: bench/json/json.zig, with the baselines of decision
//! 27 in bench/json/baselines/. Split from build/oracle.zig, which wires it into its step.
const std = @import("std");
const modules = @import("modules.zig");
const oracle_corpus = @import("oracle_corpus.zig");
const toolchains = @import("oracle_toolchains.zig");

/// `bench/json/json.zig` over the corpus files and CLDR's JSON texts: the json module's vector paths
/// against its scalar ones (decision 27), built as the other benchmarks build stdx.
pub fn add_bench_json(b: *std.Build, timing: *std.Build.Module, graph: modules.Modules, baseline: std.Build.ResolvedTarget) ?*std.Build.Step.Compile {
    const module = b.createModule(.{
        .root_source_file = b.path("bench/json/json.zig"),
        .target = baseline,
        .optimize = .ReleaseSafe,
        .link_libcpp = builds_cpp(b),
    });
    module.addImport("timing", timing);
    module.addImport("json", graph.json);
    module.addImport("codec", graph.codec);
    // The baselines of decision 27: simdjson and yyjson from C and C++, and Zig's std.json, each
    // built ReleaseFast for the architecture's baseline CPU, as the codecs' baselines are
    // (decision 75).
    const abi = b.createModule(.{ .root_source_file = b.path("bench/json/baselines/baselines_abi.zig") });
    const std_json = b.createModule(.{
        .root_source_file = b.path("bench/json/baselines/baselines_std.zig"),
        .target = baseline,
        .optimize = .ReleaseFast,
    });
    std_json.addImport("abi", abi);
    module.addImport("abi", abi);
    module.addImport("std_json_baseline", std_json);
    // The baselines of decision 69: serde_json, built by cargo, and Go's jsontext, built by go. A
    // host without one of them takes its absent bindings, and bench-json reports it as not built.
    const has_cargo = toolchains.has(b, "cargo");
    const has_go = toolchains.has(b, "go");
    module.linkLibrary(add_json_baselines(b, has_cargo, has_go) orelse return null);
    if (has_cargo) module.addObjectFile(toolchains.cargo_archive(b, "bench/json/rust", "libstdx_bench_json_rust.a", &.{"src/lib.rs"}));
    if (has_go) module.addObjectFile(toolchains.go_archive(b, "bench/json/go", "go_jsontext.a", &.{ "jsontext.go", "go.mod" }));
    if (has_cargo or has_go) toolchains.link_runtimes(module, baseline);
    const program = b.addExecutable(.{ .name = "bench_json", .root_module = module });
    b.installArtifact(program);
    return program;
}

/// What a run of bench-json does: time every candidate, or count the hardware counters per token.
pub const Mode = enum { time, profile };

/// A run of bench-json over the corpus files and CLDR's JSON texts.
pub fn run(b: *std.Build, program: *std.Build.Step.Compile, corpus: oracle_corpus.Corpus, mode: Mode) *std.Build.Step.Run {
    const program_run = b.addRunArtifact(program);
    program_run.has_side_effects = true;
    if (mode == .profile) program_run.addArg("--profile");
    oracle_corpus.add_args(b, program_run, corpus);
    program_run.addPrefixedDirectoryArg("cldr=", corpus.cldr_supplemental);
    return program_run;
}

/// simdjson, yyjson and simdutf, bench-json's C and C++ baselines, with their bindings in
/// bench/json/baselines/. simdjson and simdutf build from their sources, whose main file includes
/// the rest.
fn add_json_baselines(b: *std.Build, has_cargo: bool, has_go: bool) ?*std.Build.Step.Compile {
    const simdjson = b.lazyDependency("simdjson", .{}) orelse return null;
    const yyjson = b.lazyDependency("yyjson", .{}) orelse return null;
    const simdutf = b.lazyDependency("simdutf", .{}) orelse return null;
    const library = b.addLibrary(.{
        .name = "json_baselines",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = baseline_target(b),
            .optimize = .ReleaseFast,
            .link_libc = true,
            .link_libcpp = builds_cpp(b),
        }),
    });
    const root = library.root_module;
    root.addIncludePath(b.path("bench/json/baselines"));
    if (builds_cpp(b)) {
        root.addIncludePath(simdjson.path("include"));
        root.addIncludePath(simdjson.path("src"));
        const flags = &simdjson_flags;
        root.addCSourceFile(.{ .file = simdjson.path("src/simdjson.cpp"), .flags = flags });
        root.addCSourceFile(.{ .file = b.path("bench/json/baselines/baselines_simdjson.cpp"), .flags = flags });
        // simdutf, the UTF-8 check's baseline (decision 38), from its sources as simdjson.
        root.addIncludePath(simdutf.path("include"));
        root.addIncludePath(simdutf.path("src"));
        const utf8_flags = &simdutf_flags;
        root.addCSourceFile(.{ .file = simdutf.path("src/simdutf.cpp"), .flags = utf8_flags });
        root.addCSourceFile(.{ .file = b.path("bench/json/baselines/baselines_simdutf.cpp"), .flags = utf8_flags });
    } else {
        root.addCSourceFile(.{ .file = b.path("bench/json/baselines/baselines_simdjson_absent.c") });
        root.addCSourceFile(.{ .file = b.path("bench/json/baselines/baselines_simdutf_absent.c") });
    }
    root.addIncludePath(yyjson.path("src"));
    root.addCSourceFile(.{ .file = yyjson.path("src/yyjson.c") });
    root.addCSourceFile(.{ .file = b.path("bench/json/baselines/baselines_yyjson.c") });
    if (!has_cargo) root.addCSourceFile(.{ .file = b.path("bench/json/baselines/baselines_serde_absent.c") });
    if (!has_go) root.addCSourceFile(.{ .file = b.path("bench/json/baselines/baselines_go_absent.c") });
    return library;
}

/// Whether the host builds C++: Zig 0.16.0 does not build its libc++ for macOS 26, where
/// `INFINITY` is undeclared in libcxx's random.cpp. There simdjson's bindings are absent, and
/// bench-json reports simdjson as not built; its numbers come from the Linux runners (decision 10).
fn builds_cpp(b: *std.Build) bool {
    return b.graph.host.result.os.tag != .macos;
}

/// The architecture's baseline CPU for the C and C++ baselines (decision 75), as build/baselines.zig
/// builds libdeflate and zlib-ng. simdjson and simdutf pick their kernel at run time, so neither
/// needs the host's CPU model. On x86-64 the target adds LLVM's `evex512`, which names no
/// instruction: without it Clang does not compile their AVX-512 kernels.
fn baseline_target(b: *std.Build) std.Build.ResolvedTarget {
    var query: std.Target.Query = .{ .cpu_model = .baseline };
    if (b.graph.host.result.cpu.arch == .x86_64) query.cpu_features_add.addFeatureSet(std.Target.x86.featureSet(&.{.evex512}));
    return b.resolveTargetQuery(query);
}

/// simdjson's flags: C++20, which its string builder's `view` needs; error codes in place of
/// exceptions; and NDEBUG, which its doc/performance.md asks of a release build.
const simdjson_flags = [_][]const u8{ "-std=c++20", "-DSIMDJSON_EXCEPTIONS=0", "-DNDEBUG" };

/// simdutf's flags: C++17, which it needs, and NDEBUG for a release build.
const simdutf_flags = [_][]const u8{ "-std=c++17", "-DNDEBUG" };
