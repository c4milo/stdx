//! The module graph of docs/design.md §3: one module per codec, one for the checksums, one for JSON
//! (decision 27), one for regular expressions, one for the UTF-8 both read and one for Unicode's
//! tables (decision 86), one for the streaming contract every codec shares, and one that probes the
//! CPU once when a program starts (decision 40). A module can `@import` only what this file gives
//! it, so the dependency direction is enforced by the build and not by review (CLAUDE.md, Layout).
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
const variants = @import("variants.zig");

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
    /// UTF-8, RFC 3629: the validator decision 28 proved, and the octets of one code point
    /// (decision 86). Imports nothing.
    utf8: *std.Build.Module,
    /// Unicode 17.0.0's general categories, scripts and simple case folding, with `utf8` beside them
    /// as the namespace `std.unicode` is (decisions 6 and 86 as amended).
    unicode: *std.Build.Module,
    /// JSON, RFC 8259, and JSON text sequences, RFC 7464 (decision 27).
    json: *std.Build.Module,
    /// Base 64, RFC 4648 §4 and §5 (decision 68).
    base64: *std.Build.Module,
    /// What the CPU a program runs on offers, probed once when the program starts: the one module
    /// that may make a syscall (decision 40). Imports nothing, and no module imports it.
    platform: *std.Build.Module,
    /// Regular expressions that match in linear time, RFC 9485's grammar and RE2's additions
    /// (decision 86).
    regex: *std.Build.Module,
    /// Every module above, grouped by category as `std` groups its own (decision 6 as amended).
    stdx: *std.Build.Module,
};

/// Whether a graph's modules are exported by name. build.zig exports the graph a dependent imports;
/// the differential checks and the benchmarks build their own copy for the host, in ReleaseSafe,
/// which nothing outside this build can reach.
pub const Visibility = enum { exported, private };

/// The build settings of one graph.
pub const Settings = struct {
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    visibility: Visibility,
};

pub fn add(b: *std.Build, settings: Settings) Modules {
    const codec = library(b, "codec", settings);
    const checksum = library(b, "checksum", settings);
    variants.add_levels(b, checksum, "checksum", settings.target, settings.optimize, &variants.checksum_levels);

    const deflate = library(b, "deflate", settings);
    deflate.addImport("codec", codec);

    const zlib = library(b, "zlib", settings);
    zlib.addImport("codec", codec);
    zlib.addImport("checksum", checksum);
    zlib.addImport("deflate", deflate);

    const gzip = library(b, "gzip", settings);
    gzip.addImport("codec", codec);
    gzip.addImport("checksum", checksum);
    gzip.addImport("deflate", deflate);

    const zstd = library(b, "zstd", settings);
    zstd.addImport("codec", codec);
    zstd.addImport("checksum", checksum);

    const brotli = library(b, "brotli", settings);
    brotli.addImport("codec", codec);

    const base64 = library(b, "base64", settings);
    base64.addImport("codec", codec);
    // Decision 68's AVX2 kernels: the nibble tables through vpshufb, and the encoder's shuffles.
    variants.add_levels(b, base64, "base64", settings.target, settings.optimize, &variants.base64_levels);

    const utf8 = library(b, "utf8", settings);

    const unicode = library(b, "unicode", settings);
    // `unicode.utf8`, so a program finds UTF-8 under `stdx.unicode` (decision 6 as amended).
    unicode.addImport("utf8", utf8);

    const json = library(b, "json", settings);
    json.addImport("codec", codec);
    // `TextWriter.base64`'s letters (decision 73).
    json.addImport("base64", base64);
    // The check of a string's UTF-8, and the octets of a `\u` escape (decision 86).
    json.addImport("utf8", utf8);
    // Claim J7's kernels: AVX2's and AVX-512's widths of the scans (decision 30).
    variants.add_levels(b, json, "json", settings.target, settings.optimize, &variants.json_levels);

    const platform = library(b, "platform", settings);

    const regex = library(b, "regex", settings);
    // The checked reader a pattern is read through, and the classes of a refusal (decision 11).
    regex.addImport("codec", codec);
    // A pattern's characters, and the octets a program takes for each (decision 86).
    regex.addImport("utf8", utf8);
    variants.add_levels(b, regex, "regex", settings.target, settings.optimize, &variants.regex_levels);

    // The root a program imports, which names each module under its category (decision 6 as
    // amended). No codec imports it, nor `platform` through it.
    const stdx = library(b, "stdx", settings);
    stdx.addImport("codec", codec);
    stdx.addImport("checksum", checksum);
    stdx.addImport("deflate", deflate);
    stdx.addImport("zlib", zlib);
    stdx.addImport("gzip", gzip);
    stdx.addImport("zstd", zstd);
    stdx.addImport("brotli", brotli);
    stdx.addImport("utf8", utf8);
    stdx.addImport("unicode", unicode);
    stdx.addImport("json", json);
    stdx.addImport("base64", base64);
    stdx.addImport("platform", platform);
    stdx.addImport("regex", regex);

    return .{
        .codec = codec,
        .checksum = checksum,
        .deflate = deflate,
        .zlib = zlib,
        .gzip = gzip,
        .zstd = zstd,
        .brotli = brotli,
        .utf8 = utf8,
        .unicode = unicode,
        .json = json,
        .base64 = base64,
        .platform = platform,
        .regex = regex,
        .stdx = stdx,
    };
}

/// A library module, exported by name so a dependent can import it (decision 6), or private to
/// this build.
fn library(b: *std.Build, comptime name: []const u8, settings: Settings) *std.Build.Module {
    const options: std.Build.Module.CreateOptions = .{
        .root_source_file = b.path("src/" ++ name ++ "/" ++ name ++ ".zig"),
        .target = settings.target,
        .optimize = settings.optimize,
    };
    return switch (settings.visibility) {
        .exported => b.addModule(name, options),
        .private => b.createModule(options),
    };
}
