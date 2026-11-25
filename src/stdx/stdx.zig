//! stdx: Zig's standard library, extended. It groups its modules by what they do, as `std`
//! groups its own: `std.compress` and `stdx.compress`, `std.hash` and `stdx.hash`,
//! `std.unicode` and `stdx.unicode` (decision 6 as amended on 2026-11-22). `stdx.encoding` holds
//! JSON and base 64, as Go's `encoding` does (decision 6 as amended on 2026-11-25).
//!
//! ```zig
//! const stdx = @import("stdx");
//! var decoder: stdx.compress.gzip.Decoder = undefined;
//! const crc = stdx.hash.crc32(.table, 0, "octets");
//! ```
//!
//! Each name below is a module of its own, which the build gives this root, so a codec still
//! reaches no module that the graph of design §3 does not give it. Every module is also exported
//! under its own name, so a program may import one alone.

/// Compression, each with an encoder and a decoder: DEFLATE (RFC 1951) with its zlib (RFC 1950)
/// and gzip (RFC 1952) containers, Zstandard (RFC 8878) and brotli (RFC 7932).
pub const compress = struct {
    pub const deflate = @import("deflate");
    pub const zlib = @import("zlib");
    pub const gzip = @import("gzip");
    pub const zstd = @import("zstd");
    pub const brotli = @import("brotli");
};

/// Checksums: CRC-32 (RFC 1952 §8), Adler-32 (RFC 1950 §9) and XXH64 (RFC 8878 §3.1.1), each on
/// the fastest path the caller's CPU runs.
pub const hash = @import("hash");

/// Unicode: the general categories, scripts and simple case folding of Unicode 17.0.0, and UTF-8
/// (RFC 3629) as `stdx.unicode.utf8`, which `json` and `regex` read through.
pub const unicode = @import("unicode");

/// Encodings of data as text: JSON (RFC 8259) with JSON text sequences (RFC 7464), and base 64
/// (RFC 4648 §4 and §5). Go groups its own the same way, in `encoding/` (decision 6 as amended on
/// 2026-11-25).
pub const encoding = struct {
    pub const json = @import("json");
    pub const base64 = @import("base64");
};

/// Regular expressions matched in time linear in the text: RFC 9485's grammar and RE2's forms
/// (decision 86).
pub const regex = @import("regex");

/// What the CPU a program runs on offers, read once when the program starts: `probe`'s answers,
/// and `CpuFeatures`, which a program passes to each codec's `init`. It also holds the `memset` a
/// program exports (decisions 21, 40 and 41). The codecs name `CpuFeatures`. Outside `platform`,
/// only a test of stdx calls `probe` or `CpuFeatures.detect` (invariant 14).
pub const platform = @import("platform");

/// What every codec shares: the checked reader and writer, and a streaming call's statuses
/// (decision 11).
pub const codec = @import("codec");

const std = @import("std");

test "each category names its modules" {
    const categories = .{ compress, encoding, unicode };
    inline for (categories) |category| {
        try std.testing.expect(@typeInfo(category).@"struct".decls.len > 0);
    }
    try std.testing.expect(@hasDecl(compress.gzip, "Decoder"));
    try std.testing.expect(@hasDecl(encoding.json, "TextReader"));
    try std.testing.expect(@hasDecl(encoding.base64, "Encoder"));
    try std.testing.expect(@hasDecl(hash, "crc32"));
    try std.testing.expect(@hasDecl(unicode.utf8, "Validator"));
    try std.testing.expect(@hasDecl(unicode, "property"));
    try std.testing.expect(@hasDecl(regex, "Searcher"));
    try std.testing.expect(@hasDecl(platform, "CpuFeatures"));
    try std.testing.expect(!@hasDecl(codec, "Features"));
}
