//! The module graph of docs/design.md §3: one module per codec, one for the checksums, and one for
//! the streaming contract every codec shares. A module can `@import` only what this file gives it,
//! so the dependency direction is enforced by the build and not by review (CLAUDE.md, Layout).
//!
//! Every module here is library code and is exported by name with `b.addModule`, so a dependent
//! reaches it with `dependency.module("gzip")` (decision 6). Nothing here imports a package: the
//! oracles, the corpora and pepegrillo are requested by build.zig for `tools/` and `bench/` alone,
//! after the point a dependent's build stops (decisions 7 and 8).
//!
//! The wrappers build on the raw codec and never the reverse: `zlib` and `gzip` receive `deflate`,
//! and `deflate` receives neither. `tools/graph_check.zig` compiles fixtures that show `deflate`
//! cannot import them, and the `module-graph` rule of tools/lint keeps this file equal to design
//! §3's table.
const std = @import("std");

/// Each module's root is the file named after its directory (`src/gzip/gzip.zig`), which lists the
/// module's API as `pub const` declarations and imports every file that has tests.
pub const Modules = struct {
    /// The streaming contract every codec shares: the status a call ends with, the counts it
    /// reports, and the checked reader and writer (decision 11). Imports nothing.
    codec: *std.Build.Module,
    /// CRC-32 (RFC 1952 §8), Adler-32 (RFC 1950 §9) and XXH64 (RFC 8878 §3.1.1). Imports nothing.
    checksum: *std.Build.Module,
    /// The raw DEFLATE format of RFC 1951.
    deflate: *std.Build.Module,
    /// The zlib container of RFC 1950 around a DEFLATE stream, with its Adler-32. HTTP's
    /// `deflate` content coding is this format (RFC 9110 §8.4.1.2).
    zlib: *std.Build.Module,
    /// The gzip container of RFC 1952 around a DEFLATE stream, with its CRC-32.
    gzip: *std.Build.Module,
    /// Zstandard, RFC 8878 as RFC 9659 updates it.
    zstd: *std.Build.Module,
    /// Brotli, RFC 7932.
    brotli: *std.Build.Module,
};

pub fn add(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) Modules {
    const codec = library(b, "codec", target, optimize);
    const checksum = library(b, "checksum", target, optimize);

    const deflate = library(b, "deflate", target, optimize);
    deflate.addImport("codec", codec);

    const zlib = library(b, "zlib", target, optimize);
    zlib.addImport("codec", codec);
    zlib.addImport("checksum", checksum);
    zlib.addImport("deflate", deflate);

    const gzip = library(b, "gzip", target, optimize);
    gzip.addImport("codec", codec);
    gzip.addImport("checksum", checksum);
    gzip.addImport("deflate", deflate);

    const zstd = library(b, "zstd", target, optimize);
    zstd.addImport("codec", codec);
    zstd.addImport("checksum", checksum);

    const brotli = library(b, "brotli", target, optimize);
    brotli.addImport("codec", codec);

    return .{
        .codec = codec,
        .checksum = checksum,
        .deflate = deflate,
        .zlib = zlib,
        .gzip = gzip,
        .zstd = zstd,
        .brotli = brotli,
    };
}

/// A library module, exported by name so a dependent can import it (decision 6).
fn library(
    b: *std.Build,
    comptime name: []const u8,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) *std.Build.Module {
    return b.addModule(name, .{
        .root_source_file = b.path("src/" ++ name ++ "/" ++ name ++ ".zig"),
        .target = target,
        .optimize = optimize,
    });
}
