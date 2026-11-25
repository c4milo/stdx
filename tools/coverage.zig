//! The line coverage of stdx's modules (`zig build coverage`, build/coverage.zig). pepegrillo's
//! coverage engine runs each module's unit tests under kcov, then prints the share of each
//! module's lines that the tests ran, and the total. The `coverage` job of
//! .github/workflows/main.yml publishes the total as the README's badge.
//!
//! Run: `coverage <test program>...`, from the repository's root, on Linux with kcov 43.

const std = @import("std");
const pepegrillo = @import("pepegrillo");

/// The library's modules, one directory each, as build/modules.zig declares them. `src/unicode`
/// holds the `utf8` module's directory, and the engine refuses a directory inside another, as a
/// line would count twice, so `src/unicode` counts both modules' lines.
const directories = [_][]const u8{
    "src/codec",
    "src/hash",
    "src/compress/deflate",
    "src/compress/zlib",
    "src/compress/gzip",
    "src/compress/zstd",
    "src/compress/brotli",
    "src/encoding/json",
    "src/encoding/base64",
    "src/platform",
    "src/regex",
    "src/unicode",
    "src/stdx",
};

pub fn main(init: std.process.Init) !void {
    return pepegrillo.coverage.main(init, .{ .directories = &directories });
}
