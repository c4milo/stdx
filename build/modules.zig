//! The module graph of docs/design.md §3: one module per codec, one for the checksums, one for JSON
//! (decision 27), one for regular expressions, one for the UTF-8 both read and one for Unicode's
//! tables (decision 86), one for the streaming contract every codec shares, and one that reads the
//! CPU once when a program starts (decision 40). A module can `@import` only what this file gives
//! it, so the dependency direction is enforced by the build and not by review (CLAUDE.md, Layout).
//!
//! `platform` imports nothing, and every module whose calls take the CPU features a caller detected
//! imports it for the type `platform.CpuFeatures` (decisions 21 and 40 as amended on 2026-11-24).
//! No library code calls its `probe` or `CpuFeatures.detect`; the `cpu-probe` rule of tools/lint
//! holds that, since the graph no longer can (invariant 14).
//!
//! Every module here is library code. The package exports one of them, `stdx`, which names the
//! others under their categories, so a dependent imports `dependency.module("stdx")` and reaches
//! `stdx.compress.gzip` (decision 6 as amended on 2026-11-25). The other modules are this build's
//! own, so the graph below still holds each codec to its imports. Nothing here imports a package: the
//! oracles, the corpora and pepegrillo are requested by build.zig for `tools/` and `bench/` alone,
//! after the point a dependent's build stops (decisions 7 and 8).
//!
//! The wrappers build on the raw codec and never the reverse: `zlib` and `gzip` receive `deflate`,
//! and `deflate` receives neither. `tools/graph_check.zig` compiles fixtures that show `deflate`
//! cannot import them, and the `module-graph` rule of tools/lint keeps this file equal to design
//! §3's table.
const std = @import("std");
const variants = @import("variants.zig");

/// Each module's root is the file named after its directory (`src/compress/gzip/gzip.zig`), which
/// lists the module's API as `pub const` declarations and imports every file that has tests. A
/// module's directory sits under its category's, as `std` groups its own (decision 6 as amended).
pub const Modules = struct {
    /// The streaming contract every codec shares: the status a call ends with, the counts it
    /// reports, and the checked reader and writer (decision 11). Imports `platform` alone.
    codec: *std.Build.Module,
    /// CRC-32 (RFC 1952 §8), Adler-32 (RFC 1950 §9) and XXH64 (RFC 8878 §3.1.1). Imports nothing.
    /// It is also exported as `checksum`, its name before the move (decision 6 as amended).
    hash: *std.Build.Module,
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
    /// What the CPU a program runs on offers, read once when the program starts, and the type
    /// `CpuFeatures` the codecs take: the one module that may make a syscall (decision 40).
    /// Imports nothing.
    platform: *std.Build.Module,
    /// Regular expressions that match in linear time, RFC 9485's grammar and RE2's additions
    /// (decision 86).
    regex: *std.Build.Module,
    /// chapulin's cryptography, through its Zig module (decision 87): null unless the build passed
    /// `.crypto = true`.
    crypto: ?*std.Build.Module,
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
    /// chapulin's module, which build/crypto.zig asks for, or null for a graph with no `crypto`.
    chapulin: ?*std.Build.Module = null,
};

pub fn add(b: *std.Build, settings: Settings) Modules {
    // `CpuFeatures`, which every codec's `init` takes (decision 21 as amended on 2026-11-24).
    const platform = library(b, "platform", "platform", settings);

    const codec = library(b, "codec", "codec", settings);
    // The type `IoReader.init` and `IoWriter.init` take and hand to their codec (decision 56).
    codec.addImport("platform", platform);
    const hash = library(b, "hash", "hash", settings);
    variants.add_levels(b, hash, "hash", settings.target, settings.optimize, &variants.checksum_levels);

    const deflate = library(b, "deflate", "compress/deflate", settings);
    deflate.addImport("codec", codec);
    deflate.addImport("platform", platform);

    const zlib = library(b, "zlib", "compress/zlib", settings);
    zlib.addImport("codec", codec);
    zlib.addImport("hash", hash);
    zlib.addImport("deflate", deflate);
    zlib.addImport("platform", platform);

    const gzip = library(b, "gzip", "compress/gzip", settings);
    gzip.addImport("codec", codec);
    gzip.addImport("hash", hash);
    gzip.addImport("deflate", deflate);
    gzip.addImport("platform", platform);

    const zstd = library(b, "zstd", "compress/zstd", settings);
    zstd.addImport("codec", codec);
    zstd.addImport("hash", hash);
    zstd.addImport("platform", platform);

    const brotli = library(b, "brotli", "compress/brotli", settings);
    brotli.addImport("codec", codec);
    brotli.addImport("platform", platform);

    const base64 = library(b, "base64", "encoding/base64", settings);
    base64.addImport("codec", codec);
    base64.addImport("platform", platform);
    // Decision 68's AVX2 kernels: the nibble tables through vpshufb, and the encoder's shuffles.
    variants.add_levels(b, base64, "encoding/base64", settings.target, settings.optimize, &variants.base64_levels);

    const utf8 = library(b, "utf8", "unicode/utf8", settings);

    const unicode = library(b, "unicode", "unicode", settings);
    // `unicode.utf8`, so a program finds UTF-8 under `stdx.unicode` (decision 6 as amended).
    unicode.addImport("utf8", utf8);

    const json = library(b, "json", "encoding/json", settings);
    json.addImport("codec", codec);
    // `TextWriter.base64`'s letters (decision 73).
    json.addImport("base64", base64);
    // The check of a string's UTF-8, and the octets of a `\u` escape (decision 86).
    json.addImport("utf8", utf8);
    json.addImport("platform", platform);
    // Claim J7's kernels: AVX2's and AVX-512's widths of the scans (decision 30).
    variants.add_levels(b, json, "encoding/json", settings.target, settings.optimize, &variants.json_levels);

    const regex = library(b, "regex", "regex", settings);
    // The checked reader a pattern is read through, and the classes of a refusal (decision 11).
    regex.addImport("codec", codec);
    // A pattern's characters, and the octets a program takes for each (decision 86).
    regex.addImport("utf8", utf8);
    // The properties `\p{...}` names, and the case orbits `(?i)` folds by (decision 86 as amended).
    regex.addImport("unicode", unicode);
    regex.addImport("platform", platform);
    variants.add_levels(b, regex, "regex", settings.target, settings.optimize, &variants.regex_levels);

    // chapulin's cryptography (decision 87). No other module imports it, and no codec reaches it.
    const crypto: ?*std.Build.Module = if (settings.chapulin) |chapulin| crypto_module(b, settings, chapulin) else null;

    // The root a program imports, which names each module under its category (decision 6 as
    // amended). No codec imports it.
    const stdx = library(b, "stdx", "stdx", settings);
    const stdx_options = b.addOptions();
    stdx_options.addOption(bool, "crypto", crypto != null);
    // Whether the root names `crypto`, or a compile error that names the option.
    stdx.addImport("stdx_options", stdx_options.createModule());
    if (crypto) |module| stdx.addImport("crypto", module);
    stdx.addImport("codec", codec);
    stdx.addImport("hash", hash);
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
        .hash = hash,
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
        .crypto = crypto,
        .stdx = stdx,
    };
}

/// The module `crypto`: chapulin's Zig module under stdx's names (decision 87).
fn crypto_module(b: *std.Build, settings: Settings, chapulin: *std.Build.Module) *std.Build.Module {
    const crypto = library(b, "crypto", "crypto", settings);
    crypto.addImport("chapulin", chapulin);
    return crypto;
}

/// The one module the package exports (decision 6 as amended on 2026-11-25).
const exported_module = "stdx";

/// A library module. The package exports `stdx` alone, and every other module is this build's own.
/// `directory` is its folder under `src/`, which its category's folder holds.
fn library(b: *std.Build, comptime name: []const u8, comptime directory: []const u8, settings: Settings) *std.Build.Module {
    comptime std.debug.assert(std.mem.endsWith(u8, directory, name));
    const options: std.Build.Module.CreateOptions = .{
        .root_source_file = b.path("src/" ++ directory ++ "/" ++ name ++ ".zig"),
        .target = settings.target,
        .optimize = settings.optimize,
    };
    const exported = settings.visibility == .exported and comptime std.mem.eql(u8, name, exported_module);
    if (!exported) return b.createModule(options);
    const module = b.addModule(name, options);
    // A second export would let a dependent import a module past `stdx` again.
    std.debug.assert(b.modules.count() == 1 and b.modules.get(exported_module) == module);
    return module;
}
