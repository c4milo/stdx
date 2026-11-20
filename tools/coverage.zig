//! The line coverage of stdx's modules (`zig build coverage`, build/coverage.zig). pepegrillo's
//! coverage engine runs each module's unit tests under kcov, then prints the share of each
//! module's lines that the tests ran, and the total. The `coverage` job of
//! .github/workflows/main.yml publishes the total as the README's badge.
//!
//! Run: `coverage <test program>...`, from the repository's root, on Linux with kcov 43.

const std = @import("std");
const pepegrillo = @import("pepegrillo");

/// The library's modules, one directory each, as build/modules.zig declares them.
const directories = [_][]const u8{
    "src/codec",
    "src/checksum",
    "src/deflate",
    "src/zlib",
    "src/gzip",
    "src/zstd",
    "src/brotli",
    "src/json",
    "src/base64",
    "src/platform",
};

pub fn main(init: std.process.Init) !void {
    return pepegrillo.coverage.main(init, .{ .directories = &directories });
}
