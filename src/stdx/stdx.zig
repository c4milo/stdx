//! stdx: Zig's standard library, extended. It groups its modules by what they do, as `std`
//! groups its own: `std.compress` and `stdx.compress`, `std.hash` and `stdx.hash`,
//! `std.unicode` and `stdx.unicode` (decision 6 as amended on 2026-11-22).
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
pub const hash = @import("checksum");

/// Unicode: UTF-8 (RFC 3629), which `json` and `regex` read through.
pub const unicode = struct {
    pub const utf8 = @import("utf8");
};

/// JSON (RFC 8259) and JSON text sequences (RFC 7464).
pub const json = @import("json");

/// Base 64 (RFC 4648 §4 and §5).
pub const base64 = @import("base64");

/// Regular expressions matched in time linear in the text: RFC 9485's grammar and RE2's forms
/// (decision 86).
pub const regex = @import("regex");

/// What the CPU a program runs on offers, probed once when the program starts, and the `memset`
/// a program exports (decisions 40 and 41). No module of stdx imports it but this root.
pub const platform = @import("platform");

/// What every codec shares: the checked reader and writer, the CPU features a caller detects
/// once, and a streaming call's statuses (decision 11).
pub const codec = @import("codec");

const std = @import("std");

test "each category names its modules" {
    const categories = .{ compress, unicode };
    inline for (categories) |category| {
        try std.testing.expect(@typeInfo(category).@"struct".decls.len > 0);
    }
    try std.testing.expect(@hasDecl(compress.gzip, "Decoder"));
    try std.testing.expect(@hasDecl(hash, "crc32"));
    try std.testing.expect(@hasDecl(unicode.utf8, "Validator"));
    try std.testing.expect(@hasDecl(regex, "Searcher"));
}
