//! The oracles and the corpora of design §8 step 2, wired for `tools/` and `bench/` only.
//!
//! - `zig build oracle-selftest -Doracles` runs `tools/oracle/selftest.zig` over every corpus file:
//!   zlib and Wuffs must decode every stream zlib encodes, at every level and strategy in all three
//!   containers, to the same octets.
//! - `zig build corpus -Doracles` cuts the HTTP-shaped payloads into their three sizes, shuffles
//!   dickens's first MiB, and installs them, with every other corpus file, under `zig-out/corpus/`
//!   (build/oracle_corpus.zig).
//! - `zig build test-oracle -Doracles` runs the tests of the oracle bindings and the self-test.
//! - `zig build bench-deflate -Doracles` times DEFLATE decoding and encoding over the corpora
//!   (`bench/deflate/deflate.zig`), and on an x86-64 host with x86-64-v3's instructions, decoding
//!   again with stdx built for x86-64-v3 (decision 34).
//! - `zig build bench-checksum -Doracles` times CRC-32 and Adler-32 against zlib, Wuffs,
//!   libdeflate and zlib-ng (`bench/checksum/checksum.zig`).
//! - `zig build bench-zstd -Doracles` times Zstandard decoding against libzstd over the corpora
//!   (`bench/zstd/zstd.zig`).
//! - `zig build bench-brotli -Doracles` times brotli decoding against Google's brotli over the
//!   corpora (`bench/brotli/brotli.zig`).
//! - `zig build bench-profile -Doracles` counts cycles, instructions and branch misses per gzip
//!   and Zstandard decoder, where the host exposes the counters (`bench/profile/profile.zig`), and
//!   then per JSON token (`bench/json/json_profile.zig`).
//! - `zig build bench-json -Doracles` times the json module's vector paths against its scalar ones
//!   and beside simdjson, yyjson and Zig's std.json, over CLDR's JSON texts and texts made from the
//!   corpus (`bench/json/json.zig`, build/oracle_json.zig).
//! - `zig build differential-deflate -Doracles` requires the DEFLATE, zlib and gzip decoders to
//!   agree with zlib and Wuffs over the corpora, and on seeded corruptions
//!   (`tools/differential/deflate.zig`).
//! - `zig build differential-brotli -Doracles` requires the brotli decoder to agree with Google's
//!   brotli over the corpora, and on seeded corruptions (`tools/differential/brotli.zig`).
//! - `zig build differential-checksum -Doracles` requires stdx's CRC-32 and Adler-32 to equal the
//!   RFCs' sample code, zlib and Wuffs over the corpora (`tools/differential/checksum.zig`).
//!
//! The oracles and the corpora are lazy packages (decisions 8 and 15), fetched only when a build
//! passes `-Doracles`, so `zig build test` on a fresh clone downloads none of their 260 MB. A step
//! run without the option fails and says so. None of this reaches a library module: the modules
//! are built in build/modules.zig, and `zig build graph-check` shows `deflate` cannot import
//! `oracle` (invariant 14).
const std = @import("std");
const modules = @import("modules.zig");
const baselines = @import("baselines.zig");
const oracle_corpus = @import("oracle_corpus.zig");
const oracle_json = @import("oracle_json.zig");

/// The zlib sources the oracle compiles: the library without its gz* file layer, which would need
/// the host's file I/O.
const zlib_sources = [_][]const u8{
    "adler32.c", "compress.c", "crc32.c", "deflate.c", "infback.c", "inffast.c",
    "inflate.c", "inftrees.c", "trees.c", "uncompr.c", "zutil.c",
};

/// The libzstd sources the oracle compiles, as libzstd's lib/README.md describes a modular build:
/// lib/common, lib/compress and lib/decompress, without the dictionary builder or the legacy
/// formats (design §8 step 10).
const zstd_sources = [_][]const u8{
    "common/debug.c",                    "common/entropy_common.c",            "common/error_private.c",
    "common/fse_decompress.c",           "common/pool.c",                      "common/threading.c",
    "common/xxhash.c",                   "common/zstd_common.c",               "compress/fse_compress.c",
    "compress/hist.c",                   "compress/huf_compress.c",            "compress/zstd_compress.c",
    "compress/zstd_compress_literals.c", "compress/zstd_compress_sequences.c", "compress/zstd_compress_superblock.c",
    "compress/zstd_double_fast.c",       "compress/zstd_fast.c",               "compress/zstd_lazy.c",
    "compress/zstd_ldm.c",               "compress/zstd_opt.c",                "compress/zstd_preSplit.c",
    "compress/zstdmt_compress.c",        "decompress/huf_decompress.c",        "decompress/zstd_ddict.c",
    "decompress/zstd_decompress.c",      "decompress/zstd_decompress_block.c",
};

/// The C files of Google's brotli the oracle compiles: its common, decoder and encoder files, by the
/// names its c/ directory lists, without its one C++ file (design §8 step 12).
const brotli_sources = [_][]const u8{
    "common/constants.c",               "common/context.c",             "common/dictionary.c",
    "common/platform.c",                "common/shared_dictionary.c",   "common/transform.c",
    "dec/bit_reader.c",                 "dec/decode.c",                 "dec/huffman.c",
    "dec/prefix.c",                     "dec/state.c",                  "dec/static_init.c",
    "enc/backward_references.c",        "enc/backward_references_hq.c", "enc/bit_cost.c",
    "enc/block_splitter.c",             "enc/brotli_bit_stream.c",      "enc/cluster.c",
    "enc/command.c",                    "enc/compound_dictionary.c",    "enc/compress_fragment.c",
    "enc/compress_fragment_two_pass.c", "enc/dictionary_hash.c",        "enc/encode.c",
    "enc/encoder_dict.c",               "enc/entropy_encode.c",         "enc/fast_log.c",
    "enc/histogram.c",                  "enc/literal_cost.c",           "enc/memory.c",
    "enc/metablock.c",                  "enc/static_dict.c",            "enc/static_dict_lut.c",
    "enc/static_init.c",                "enc/utf8_util.c",
};

/// The assembly of libzstd's Huffman decoding loops, which x86-64 builds link.
const zstd_x86_64_assembly = "decompress/huf_decompress_amd64.S";

/// libzstd without its legacy formats, whose sources the oracle leaves out (lib/README.md).
const zstd_flags = [_][]const u8{"-DZSTD_LEGACY_SUPPORT=0"};

/// The directory of the Wuffs package that holds `wuffs-v0.4.c`.
const wuffs_directory = "release/c";

/// The message a step prints when the build was not given `-Doracles`.
const disabled_message = "pass -Doracles: the oracles and the corpora are lazy packages this build " ++
    "fetches only when asked (decisions 8 and 15)";

pub const Options = struct {
    /// Whether the build was given `-Doracles`.
    enabled: bool,
    /// The mode differential-encode builds stdx in: the encoders' output must be the same in every
    /// mode (invariant 5).
    encode_optimize: std.builtin.OptimizeMode,
};

pub fn add(b: *std.Build, options: Options) void {
    const selftest_step = b.step("oracle-selftest", "Require zlib and Wuffs to agree over the corpora (-Doracles)");
    const corpus_step = b.step("corpus", "Cut the HTTP payloads, shuffle dickens and install every corpus file (-Doracles)");
    const test_step = b.step("test-oracle", "Run the tests of the oracle bindings and the self-test (-Doracles)");
    const bench_step = b.step("bench-deflate", "Time DEFLATE decoding and encoding over the corpora (-Doracles)");
    const checksum_step = b.step("differential-checksum", "Require CRC-32 and Adler-32 to equal the oracles (-Doracles)");
    const deflate_step = b.step("differential-deflate", "Require the DEFLATE decoder to agree with the oracles (-Doracles)");
    const encode_step = b.step("differential-encode", "Require the encoders' output to decode through the oracles (-Doracles)");
    const zstd_step = b.step("differential-zstd", "Require the Zstandard decoder to agree with libzstd (-Doracles)");
    const brotli_step = b.step("differential-brotli", "Require the brotli decoder to agree with Google's brotli (-Doracles)");
    const bench_zstd_step = b.step("bench-zstd", "Time Zstandard decoding against libzstd over the corpora (-Doracles)");
    const bench_brotli_step = b.step("bench-brotli", "Time brotli decoding against Google's brotli over the corpora (-Doracles)");
    const bench_checksum_step = b.step("bench-checksum", "Time CRC-32 and Adler-32 against the baselines (-Doracles)");
    const profile_step = b.step("bench-profile", "Count cycles, instructions and branch misses per gzip and Zstandard decoder, and per json token (-Doracles)");
    const bench_json_step = b.step("bench-json", "Time the json module's vector paths against its scalar ones (-Doracles)");
    const steps = .{ selftest_step, corpus_step, test_step, bench_step, checksum_step, bench_checksum_step, deflate_step, encode_step, zstd_step, brotli_step, bench_zstd_step, bench_brotli_step, profile_step, bench_json_step };
    if (!options.enabled) {
        const fail = b.addFail(disabled_message);
        inline for (steps) |step| step.dependOn(&fail.step);
        return;
    }
    const oracle = add_oracle_module(b) orelse return;
    // The timing loop runs between every repetition, so it is built as the benchmarks are.
    const timing = b.createModule(.{
        .root_source_file = b.path("bench/timing/timing.zig"),
        .target = b.graph.host,
        .optimize = .ReleaseSafe,
    });
    const corpus_names = host_module(b, "tools/corpus/corpus.zig");
    // The library as a caller shipping one binary for every CPU of an architecture runs it: built
    // for the architecture's baseline, so each SIMD path runs because detection found its
    // instructions and not because the target promised them (decision 21); ReleaseSafe (decision
    // 17); exported to nobody.
    const baseline = b.resolveTargetQuery(.{ .cpu_model = .baseline });
    const graph = modules.add(b, .{ .target = baseline, .optimize = .ReleaseSafe, .visibility = .private });
    // The shuffle draws its order from the codec module's generator, so it is built as the checks are.
    const shuffle_module = b.createModule(.{
        .root_source_file = b.path("tools/corpus/shuffle.zig"),
        .target = baseline,
        .optimize = .ReleaseSafe,
    });
    shuffle_module.addImport("codec", graph.codec);
    const corpus = oracle_corpus.add(b, .{
        .cut = host_module(b, "tools/corpus/cut.zig"),
        .shuffle = shuffle_module,
    }) orelse return;

    const selftest_module = host_module(b, "tools/oracle/selftest.zig");
    selftest_module.addImport("oracle", oracle);
    selftest_module.addImport("corpus", corpus_names);
    const selftest = b.addExecutable(.{ .name = "oracle_selftest", .root_module = selftest_module });
    const run = b.addRunArtifact(selftest);
    oracle_corpus.add_args(b, run, corpus);
    selftest_step.dependOn(&run.step);

    const inputs: BenchInputs = .{ .oracle = oracle, .timing = timing, .corpus = corpus, .baseline = baseline };
    const bench_module = deflate_bench_module(b, inputs, graph, baseline, .release_safe);
    const bench_run = run_program(b, inputs, "bench_deflate", bench_module);
    bench_step.dependOn(&bench_run.step);
    // Decision 17's measurement: the same A/B with stdx built ReleaseFast, a measuring device
    // only, run after the benchmark on the same host. The two graphs share source files, which one
    // compilation cannot hold twice, so it is a program of its own.
    const release_fast_graph = modules.add(b, .{ .target = baseline, .optimize = .ReleaseFast, .visibility = .private });
    const release_fast_module = deflate_bench_module(b, inputs, release_fast_graph, baseline, .release_fast);
    const release_fast_run = run_program(b, inputs, "bench_deflate_release_fast", release_fast_module);
    release_fast_run.step.dependOn(&bench_run.step);
    bench_step.dependOn(&release_fast_run.step);

    const install = b.addInstallDirectory(.{
        .source_dir = corpus.pieces,
        .install_dir = .prefix,
        .install_subdir = "corpus",
    });
    corpus_step.dependOn(&install.step);

    const checksum_module = b.createModule(.{
        .root_source_file = b.path("tools/differential/checksum.zig"),
        .target = baseline,
        .optimize = .ReleaseSafe,
    });
    checksum_module.addImport("oracle", oracle);
    checksum_module.addImport("corpus", corpus_names);
    checksum_module.addImport("codec", graph.codec);
    checksum_module.addImport("checksum", graph.checksum);
    checksum_module.addOptions("host_features", host_features(b));
    const checksum_check = b.addExecutable(.{ .name = "differential_checksum", .root_module = checksum_module });
    const checksum_run = b.addRunArtifact(checksum_check);
    oracle_corpus.add_args(b, checksum_run, corpus);
    checksum_step.dependOn(&checksum_run.step);

    const verdicts = host_module(b, "tools/oracle/verdicts.zig");
    const deflate_module = b.createModule(.{
        .root_source_file = b.path("tools/differential/deflate.zig"),
        .target = baseline,
        .optimize = .ReleaseSafe,
    });
    deflate_module.addImport("oracle", oracle);
    deflate_module.addImport("corpus", corpus_names);
    deflate_module.addImport("codec", graph.codec);
    deflate_module.addImport("deflate", graph.deflate);
    deflate_module.addImport("zlib", graph.zlib);
    deflate_module.addImport("gzip", graph.gzip);
    deflate_module.addImport("verdicts", verdicts);
    const deflate_check = b.addExecutable(.{ .name = "differential_deflate", .root_module = deflate_module });
    const deflate_run = b.addRunArtifact(deflate_check);
    oracle_corpus.add_args(b, deflate_run, corpus);
    deflate_step.dependOn(&deflate_run.step);

    const encode_module = b.createModule(.{
        .root_source_file = b.path("tools/differential/encode.zig"),
        .target = baseline,
        .optimize = .ReleaseSafe,
    });
    const encode_graph = if (options.encode_optimize == .ReleaseSafe) graph else modules.add(b, .{ .target = baseline, .optimize = options.encode_optimize, .visibility = .private });
    encode_module.addImport("oracle", oracle);
    encode_module.addImport("corpus", corpus_names);
    encode_module.addImport("codec", encode_graph.codec);
    encode_module.addImport("deflate", encode_graph.deflate);
    encode_module.addImport("zlib", encode_graph.zlib);
    encode_module.addImport("gzip", encode_graph.gzip);
    const encode_check = b.addExecutable(.{ .name = "differential_encode", .root_module = encode_module });
    const encode_run = b.addRunArtifact(encode_check);
    encode_run.has_side_effects = true;
    if (b.args) |args| encode_run.addArgs(args);
    oracle_corpus.add_args(b, encode_run, corpus);
    encode_step.dependOn(&encode_run.step);

    const zstd_module = b.createModule(.{
        .root_source_file = b.path("tools/differential/zstd.zig"),
        .target = baseline,
        .optimize = .ReleaseSafe,
    });
    zstd_module.addImport("oracle", oracle);
    zstd_module.addImport("corpus", corpus_names);
    zstd_module.addImport("codec", graph.codec);
    zstd_module.addImport("zstd", graph.zstd);
    zstd_module.addImport("verdicts", verdicts);
    const zstd_check = b.addExecutable(.{ .name = "differential_zstd", .root_module = zstd_module });
    const zstd_run = b.addRunArtifact(zstd_check);
    zstd_run.has_side_effects = true;
    oracle_corpus.add_args(b, zstd_run, corpus);
    zstd_step.dependOn(&zstd_run.step);

    const brotli_module = b.createModule(.{
        .root_source_file = b.path("tools/differential/brotli.zig"),
        .target = baseline,
        .optimize = .ReleaseSafe,
    });
    brotli_module.addImport("oracle", oracle);
    brotli_module.addImport("corpus", corpus_names);
    brotli_module.addImport("codec", graph.codec);
    brotli_module.addImport("brotli", graph.brotli);
    brotli_module.addImport("verdicts", verdicts);
    const brotli_check = b.addExecutable(.{ .name = "differential_brotli", .root_module = brotli_module });
    const brotli_run = b.addRunArtifact(brotli_check);
    brotli_run.has_side_effects = true;
    oracle_corpus.add_args(b, brotli_run, corpus);
    brotli_step.dependOn(&brotli_run.step);

    // Decision 17's measurement for each decoder, after its benchmark: stdx built ReleaseFast.
    inline for (.{ .{ bench_zstd_step, zstd_bench }, .{ bench_brotli_step, brotli_bench } }) |decoder_bench| {
        const safe_run = add_bench_decoder(b, inputs, graph, false, decoder_bench[1]);
        const fast_run = add_bench_decoder(b, inputs, release_fast_graph, true, decoder_bench[1]);
        fast_run.step.dependOn(&safe_run.step);
        decoder_bench[0].dependOn(&fast_run.step);
    }

    const baselines_module = host_module(b, "bench/baselines/baselines.zig");
    if (!baselines.link(b, baselines_module)) return;
    bench_module.addImport("baselines", baselines_module);
    // Decision 34: on an x86-64 host with x86-64-v3's instructions, the decoding table again with
    // stdx built for x86-64-v3, after the two programs above.
    if (x86_64_v3_host(b)) {
        const v3 = b.resolveTargetQuery(.{ .cpu_model = .{ .explicit = &std.Target.x86.cpu.x86_64_v3 } });
        const v3_graph = modules.add(b, .{ .target = v3, .optimize = .ReleaseSafe, .visibility = .private });
        const v3_module = deflate_bench_module(b, inputs, v3_graph, v3, .x86_64_v3);
        v3_module.addImport("baselines", baselines_module);
        const v3_run = run_program(b, inputs, "bench_deflate_x86_64_v3", v3_module);
        v3_run.step.dependOn(&release_fast_run.step);
        bench_step.dependOn(&v3_run.step);
    }
    const profile_module = b.createModule(.{
        .root_source_file = b.path("bench/profile/profile.zig"),
        .target = baseline,
        .optimize = .ReleaseSafe,
    });
    profile_module.addImport("oracle", oracle);
    profile_module.addImport("codec", graph.codec);
    profile_module.addImport("gzip", graph.gzip);
    profile_module.addImport("deflate", graph.deflate);
    profile_module.addImport("zstd", graph.zstd);
    profile_module.addImport("baselines", baselines_module);
    profile_module.addImport("timing", timing);
    const profile = b.addExecutable(.{ .name = "bench_profile", .root_module = profile_module });
    b.installArtifact(profile);
    const profile_run = b.addRunArtifact(profile);
    profile_run.has_side_effects = true;
    oracle_corpus.add_args(b, profile_run, corpus);
    profile_step.dependOn(&profile_run.step);
    const bench_checksum_module = b.createModule(.{
        .root_source_file = b.path("bench/checksum/checksum.zig"),
        .target = baseline,
        .optimize = .ReleaseSafe,
    });
    bench_checksum_module.addImport("timing", timing);
    bench_checksum_module.addImport("oracle", oracle);
    bench_checksum_module.addImport("baselines", baselines_module);
    bench_checksum_module.addImport("codec", graph.codec);
    bench_checksum_module.addImport("checksum", graph.checksum);
    const bench_checksum = b.addExecutable(.{ .name = "bench_checksum", .root_module = bench_checksum_module });
    b.installArtifact(bench_checksum);
    const bench_checksum_run = b.addRunArtifact(bench_checksum);
    bench_checksum_run.has_side_effects = true;
    bench_checksum_step.dependOn(&bench_checksum_run.step);

    if (oracle_json.add_bench_json(b, timing, graph, baseline)) |bench_json| {
        bench_json_step.dependOn(&oracle_json.run(b, bench_json, corpus, .time).step);
        // After the decoders' counters, so the two programs neither share the core nor mix their
        // tables.
        const json_profile = oracle_json.run(b, bench_json, corpus, .profile);
        json_profile.step.dependOn(&profile_run.step);
        profile_step.dependOn(&json_profile.step);
    }

    const tested = .{ oracle, corpus_names, shuffle_module, timing, baselines_module, selftest_module, bench_module, checksum_module, verdicts, deflate_module, encode_module, zstd_module, brotli_module, profile_module };
    inline for (tested) |module| {
        const tests = b.addTest(.{ .root_module = module });
        test_step.dependOn(&b.addRunArtifact(tests).step);
    }
}

/// What each decoder benchmark program is built from.
const BenchInputs = struct {
    oracle: *std.Build.Module,
    timing: *std.Build.Module,
    corpus: oracle_corpus.Corpus,
    baseline: std.Build.ResolvedTarget,
};

/// A decoder benchmark: its program's source, the name it installs as, and the codec module it
/// times, by its name in the module graph.
const DecoderBench = struct { source: []const u8, name: []const u8, codec: []const u8 };
const zstd_bench: DecoderBench = .{ .source = "bench/zstd/zstd.zig", .name = "bench_zstd", .codec = "zstd" };
const brotli_bench: DecoderBench = .{ .source = "bench/brotli/brotli.zig", .name = "bench_brotli", .codec = "brotli" };

/// `bench`'s program over the corpora, against the library `graph` holds: ReleaseSafe, or
/// ReleaseFast for decision 17's measurement, where the root is ReleaseFast too, since Zig 0.16
/// takes runtime safety from the root module for every module the program imports.
fn add_bench_decoder(b: *std.Build, inputs: BenchInputs, graph: modules.Modules, release_fast: bool, comptime bench: DecoderBench) *std.Build.Step.Run {
    const module = b.createModule(.{
        .root_source_file = b.path(bench.source),
        .target = inputs.baseline,
        .optimize = if (release_fast) .ReleaseFast else .ReleaseSafe,
    });
    module.addImport("oracle", inputs.oracle);
    module.addImport("timing", inputs.timing);
    module.addImport("codec", graph.codec);
    module.addImport(bench.codec, @field(graph, bench.codec));
    module.addOptions("bench_options", bench_options(b, if (release_fast) .release_fast else .release_safe));
    return run_program(b, inputs, if (release_fast) bench.name ++ "_release_fast" else bench.name, module);
}

/// bench/deflate/deflate.zig over the library `graph` holds, built for `target`: ReleaseSafe, or
/// ReleaseFast for decision 17's measurement, where the root is ReleaseFast too, since Zig 0.16
/// takes runtime safety from the root module for every module the program imports.
fn deflate_bench_module(b: *std.Build, inputs: BenchInputs, graph: modules.Modules, target: std.Build.ResolvedTarget, mode: BenchMode) *std.Build.Module {
    const module = b.createModule(.{
        .root_source_file = b.path("bench/deflate/deflate.zig"),
        .target = target,
        .optimize = if (mode == .release_fast) .ReleaseFast else .ReleaseSafe,
    });
    module.addImport("oracle", inputs.oracle);
    module.addImport("timing", inputs.timing);
    inline for (.{ "codec", "deflate", "gzip", "checksum" }) |name| module.addImport(name, @field(graph, name));
    module.addOptions("bench_options", bench_options(b, mode));
    return module;
}

/// A benchmark program named `name`, installed, and run over the corpora.
fn run_program(b: *std.Build, inputs: BenchInputs, name: []const u8, module: *std.Build.Module) *std.Build.Step.Run {
    const program = b.addExecutable(.{ .name = name, .root_module = module });
    b.installArtifact(program);
    const run = b.addRunArtifact(program);
    run.has_side_effects = true;
    oracle_corpus.add_args(b, run, inputs.corpus);
    return run;
}

/// What a benchmark program measures: stdx as a caller builds it, decision 17's ReleaseFast
/// measuring device, or DEFLATE decoding with stdx built for x86-64-v3 (decision 34).
const BenchMode = enum { release_safe, release_fast, x86_64_v3 };

/// A benchmark program's options: its mode, as one flag each.
fn bench_options(b: *std.Build, mode: BenchMode) *std.Build.Step.Options {
    const options = b.addOptions();
    options.addOption(bool, "release_fast", mode == .release_fast);
    options.addOption(bool, "x86_64_v3", mode == .x86_64_v3);
    return options;
}

/// Whether the build host runs x86-64-v3's instructions, which `bench_deflate_x86_64_v3` needs: the
/// level's instruction sets alone, since Zig's model of the level also names tuning features a
/// CPU's detection need not report.
fn x86_64_v3_host(b: *std.Build) bool {
    const cpu = b.graph.host.result.cpu;
    return cpu.arch == .x86_64 and std.Target.x86.featureSetHasAll(cpu.features, .{
        .avx2, .bmi, .bmi2, .f16c, .fma, .lzcnt, .movbe, .xsave, .cx16, .popcnt, .sahf, .sse4_2, .ssse3,
    });
}

/// The SIMD features Zig's own detection finds on the build host, which runs the checks: the
/// oracle for `codec.Features.detect()`, which the checks require to find at least as many.
fn host_features(b: *std.Build) *std.Build.Step.Options {
    const cpu = b.graph.host.result.cpu;
    const x86 = std.Target.x86;
    const aarch64 = std.Target.aarch64;
    const is_x86_64 = cpu.arch == .x86_64;
    const is_aarch64 = cpu.arch == .aarch64;
    const options = b.addOptions();
    options.addOption(bool, "pclmul", is_x86_64 and x86.featureSetHasAll(cpu.features, .{ .pclmul, .sse4_1 }));
    options.addOption(bool, "avx2", is_x86_64 and x86.featureSetHas(cpu.features, .avx2));
    options.addOption(bool, "vpclmul", is_x86_64 and x86.featureSetHasAll(cpu.features, .{ .vpclmulqdq, .avx2 }));
    options.addOption(bool, "avx512", is_x86_64 and x86.featureSetHasAll(cpu.features, .{ .avx512f, .avx512bw, .avx512dq, .avx512vl }));
    options.addOption(bool, "vnni", is_x86_64 and x86.featureSetHas(cpu.features, .avx512vnni));
    options.addOption(bool, "vpmullq_fast", is_x86_64 and x86.featureSetHasAll(cpu.features, .{ .avx512f, .avx512bw, .avx512dq, .avx512vl }) and
        std.mem.startsWith(u8, cpu.model.name, "znver"));
    options.addOption(bool, "crc32", is_aarch64 and aarch64.featureSetHas(cpu.features, .crc));
    options.addOption(bool, "pmull", is_aarch64 and aarch64.featureSetHas(cpu.features, .aes));
    options.addOption(bool, "dotprod", is_aarch64 and aarch64.featureSetHas(cpu.features, .dotprod));
    return options;
}

/// The `oracle` module: tools/oracle/oracle.zig over zlib, Wuffs and libzstd, compiled for the
/// host. The C is built ReleaseFast: it is the oracles' code, not stdx's, and it runs over hundreds
/// of megabytes. Null until the packages are fetched.
fn add_oracle_module(b: *std.Build) ?*std.Build.Module {
    const zlib = b.lazyDependency("madler_zlib", .{}) orelse return null;
    const wuffs = b.lazyDependency("wuffs", .{}) orelse return null;
    const zstd = b.lazyDependency("libzstd", .{}) orelse return null;
    const brotli = b.lazyDependency("google_brotli", .{}) orelse return null;
    const library = b.addLibrary(.{
        .name = "oracle_c",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = b.graph.host,
            .optimize = .ReleaseFast,
            .link_libc = true,
        }),
    });
    library.root_module.addIncludePath(zlib.path(""));
    library.root_module.addIncludePath(wuffs.path(wuffs_directory));
    library.root_module.addCSourceFiles(.{ .root = zlib.path(""), .files = &zlib_sources });
    library.root_module.addIncludePath(zstd.path("lib"));
    library.root_module.addCSourceFiles(.{ .root = zstd.path("lib"), .files = &zstd_sources, .flags = &zstd_flags });
    if (b.graph.host.result.cpu.arch == .x86_64) {
        library.root_module.addAssemblyFile(zstd.path(b.pathJoin(&.{ "lib", zstd_x86_64_assembly })));
    }
    library.root_module.addCSourceFile(.{ .file = b.path("tools/oracle/oracle.c") });
    library.root_module.addCSourceFile(.{ .file = b.path("tools/oracle/oracle_zstd.c") });
    library.root_module.addIncludePath(brotli.path("c/include"));
    library.root_module.addCSourceFiles(.{ .root = brotli.path("c"), .files = &brotli_sources });
    library.root_module.addCSourceFile(.{ .file = b.path("tools/oracle/oracle_brotli.c") });
    library.root_module.addCSourceFile(.{ .file = b.path("tools/oracle/rfc_samples.c") });
    const module = host_module(b, "tools/oracle/oracle.zig");
    module.link_libc = true;
    module.linkLibrary(library);
    return module;
}

/// A module compiled for the build host in Debug: every tool.
fn host_module(b: *std.Build, root_source_file: []const u8) *std.Build.Module {
    return b.createModule(.{
        .root_source_file = b.path(root_source_file),
        .target = b.graph.host,
        .optimize = .Debug,
    });
}
