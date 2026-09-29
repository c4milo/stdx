//! `zig build bench-json -Doracles`'s program: bench/json/json.zig, with the baselines of decision
//! 27 in bench/json/baselines/. Split from build/oracle.zig, which wires it into its step.
const std = @import("std");
const modules = @import("modules.zig");
const oracle_corpus = @import("oracle_corpus.zig");

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
    // built for the host in ReleaseFast, as the codecs' baselines are.
    const abi = b.createModule(.{ .root_source_file = b.path("bench/json/baselines/baselines_abi.zig") });
    const std_json = b.createModule(.{
        .root_source_file = b.path("bench/json/baselines/baselines_std.zig"),
        .target = b.graph.host,
        .optimize = .ReleaseFast,
    });
    std_json.addImport("abi", abi);
    module.addImport("abi", abi);
    module.addImport("std_json_baseline", std_json);
    module.linkLibrary(add_json_baselines(b) orelse return null);
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
fn add_json_baselines(b: *std.Build) ?*std.Build.Step.Compile {
    const simdjson = b.lazyDependency("simdjson", .{}) orelse return null;
    const yyjson = b.lazyDependency("yyjson", .{}) orelse return null;
    const simdutf = b.lazyDependency("simdutf", .{}) orelse return null;
    const library = b.addLibrary(.{
        .name = "json_baselines",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = b.graph.host,
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
        const flags = simdjson_flags(b);
        root.addCSourceFile(.{ .file = simdjson.path("src/simdjson.cpp"), .flags = flags });
        root.addCSourceFile(.{ .file = b.path("bench/json/baselines/baselines_simdjson.cpp"), .flags = flags });
        // simdutf, the UTF-8 check's baseline (decision 38), from its sources as simdjson.
        root.addIncludePath(simdutf.path("include"));
        root.addIncludePath(simdutf.path("src"));
        const utf8_flags = simdutf_flags(b);
        root.addCSourceFile(.{ .file = simdutf.path("src/simdutf.cpp"), .flags = utf8_flags });
        root.addCSourceFile(.{ .file = b.path("bench/json/baselines/baselines_simdutf.cpp"), .flags = utf8_flags });
    } else {
        root.addCSourceFile(.{ .file = b.path("bench/json/baselines/baselines_simdjson_absent.c") });
        root.addCSourceFile(.{ .file = b.path("bench/json/baselines/baselines_simdutf_absent.c") });
    }
    root.addIncludePath(yyjson.path("src"));
    root.addCSourceFile(.{ .file = yyjson.path("src/yyjson.c") });
    root.addCSourceFile(.{ .file = b.path("bench/json/baselines/baselines_yyjson.c") });
    return library;
}

/// Whether the host builds C++: Zig 0.16.0 does not build its libc++ for macOS 26, where
/// `INFINITY` is undeclared in libcxx's random.cpp. There simdjson's bindings are absent, and
/// bench-json reports simdjson as not built; its numbers come from the Linux runners (decision 10).
fn builds_cpp(b: *std.Build) bool {
    return b.graph.host.result.os.tag != .macos;
}

/// simdjson's flags: C++20, which its string builder's `view` needs; error codes in place of
/// exceptions; and NDEBUG, which its doc/performance.md asks of a release build. An x86-64 host
/// without 512-bit vectors (LLVM's `evex512`) cannot compile simdjson's AVX-512 kernel, and
/// simdjson could never pick it there, so the build leaves it out the way its
/// doc/implementation-selection.md shows. `-mevex512` compiled it on some runners, and one runner's
/// clang refused that flag as deprecated.
fn simdjson_flags(b: *std.Build) []const []const u8 {
    return if (without_avx512(b)) &simdjson_flags_without_avx512 else &simdjson_flags_common;
}

const simdjson_flags_common = [_][]const u8{ "-std=c++20", "-DSIMDJSON_EXCEPTIONS=0", "-DNDEBUG" };
const simdjson_flags_without_avx512 = simdjson_flags_common ++ [_][]const u8{"-DSIMDJSON_IMPLEMENTATION_ICELAKE=0"};

/// simdutf's flags: C++17, which it needs, and NDEBUG for a release build. Its AVX-512 kernel is
/// guarded as simdjson's is, and left out on an x86-64 host without `evex512` for the same reason.
fn simdutf_flags(b: *std.Build) []const []const u8 {
    return if (without_avx512(b)) &simdutf_flags_without_avx512 else &simdutf_flags_common;
}

const simdutf_flags_common = [_][]const u8{ "-std=c++17", "-DNDEBUG" };
const simdutf_flags_without_avx512 = simdutf_flags_common ++ [_][]const u8{"-DSIMDUTF_IMPLEMENTATION_ICELAKE=0"};

/// Whether the host is an x86-64 CPU without 512-bit vectors, where LLVM compiles no AVX-512 kernel.
fn without_avx512(b: *std.Build) bool {
    const cpu = b.graph.host.result.cpu;
    return cpu.arch == .x86_64 and !std.Target.x86.featureSetHas(cpu.features, .evex512);
}
