//! The `oracle` module of design §8 step 2: the C of zlib, Wuffs, libzstd and Google's brotli,
//! and the bindings of tools/oracle/ over it, for build/oracle.zig.
const std = @import("std");

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

/// The `oracle` module: tools/oracle/oracle.zig over zlib, Wuffs, libzstd and Google's brotli. The
/// C is built ReleaseFast: it is the oracles' code, not stdx's, and it runs over hundreds of
/// megabytes. It is built for the architecture's baseline CPU, as the benchmarks build stdx and
/// build/baselines.zig the other baselines (decision 75): each library's own build gives it that
/// CPU's instructions, and those it finds at run time, as Wuffs and libzstd find theirs. Null until
/// the packages are fetched.
pub fn add(b: *std.Build) ?*std.Build.Module {
    const zlib = b.lazyDependency("madler_zlib", .{}) orelse return null;
    const wuffs = b.lazyDependency("wuffs", .{}) orelse return null;
    const zstd = b.lazyDependency("libzstd", .{}) orelse return null;
    const brotli = b.lazyDependency("google_brotli", .{}) orelse return null;
    const library = b.addLibrary(.{
        .name = "oracle_c",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = b.resolveTargetQuery(.{ .cpu_model = .baseline }),
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
    const module = b.createModule(.{
        .root_source_file = b.path("tools/oracle/oracle.zig"),
        .target = b.graph.host,
        .optimize = .Debug,
    });
    module.link_libc = true;
    module.linkLibrary(library);
    return module;
}
