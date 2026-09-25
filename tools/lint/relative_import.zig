//! relative-import: a module reaches another module by the name build/modules.zig gives it, never
//! by a path (CLAUDE.md, Layout). A module can `@import` only what the build hands it, so the
//! dependency direction is enforced by the build and not by review, and an `@import` that climbs
//! out of its own directory reaches past the build and takes that away.
//!
//! Over every `.zig` file under `src/`, the rule resolves each `@import` path against the directory
//! of the importing file and flags one that names a file outside that file's module, which is the
//! child of `src/` the file sits in. It also flags an `@import` of an absolute path, which names a
//! machine rather than a tree. A file reaching a sibling, a subdirectory, or its module's root
//! directory from a subdirectory is untouched: `@import("huffman.zig")`,
//! `@import("block/block_header.zig")` and, from `src/zstd/block/block_header.zig`,
//! `@import("../constants.zig")` all stay inside the module build/modules.zig named.
//!
//! The rule reads the literal string only. `@import(module_name)` with a computed name is
//! invisible to it, as is `@embedFile`, which the rule ignores on purpose: a fixture lives beside
//! the module that reads it and is not a module edge.
//!
//! The rule is pepegrillo's `relative_import` (decision 7). This file holds stdx's configuration
//! of it and the fixtures that pin that configuration.

const std = @import("std");
const pepegrillo = @import("pepegrillo");
const lint = pepegrillo.lint;
const relative_import = lint.rules.relative_import;

/// The configuration. It reads `src/` and flags a path that resolves outside the importing file's
/// module under `src/`, or starts with `/`.
pub const config: relative_import.Config = .{
    .scope = .{ .extensions = &.{lint.paths.zig_extension}, .include_directories = &.{"src"} },
    .mode = .leaves_subsystem,
    .message = "@import(\"{[path]s}\") reaches out of the module by path;" ++
        " import the module name build/modules.zig declares",
};

const Rule = relative_import.Rule(config);
pub const name = Rule.name;
pub const check = Rule.check;

// Tests. Each fixture pins one shape from the header.

const testing = std.testing;
const harness = lint.harness;

const suffix = " reaches out of the module by path; import the module name build/modules.zig declares";

fn findings_of(
    arena: std.mem.Allocator,
    path: []const u8,
    source: [:0]const u8,
) ![]const lint.report.Finding {
    return harness.run(arena, Rule, path, source);
}

const passing_fixture: [:0]const u8 =
    \\const std = @import("std");
    \\const codec = @import("codec");
    \\const deflate = @import("deflate");
    \\const constants = @import("constants.zig");
    \\const header = @import("block/block_header.zig");
    \\const fixture = @embedFile("../fixtures/empty.gz");
;

const failing_fixture: [:0]const u8 =
    \\const deflate = @import("../deflate/deflate.zig");
    \\const codec = @import("../../src/codec/codec.zig");
    \\const pinned = @import("/Users/someone/stdx/src/codec/codec.zig");
;

test "relative-import passes module names, siblings and subdirectories" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/gzip/gzip.zig", passing_fixture);
    try harness.expect_messages(findings, &.{});
}

test "relative-import flags a parent path and an absolute path" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/gzip/gzip.zig", failing_fixture);
    try harness.expect_messages(findings, &.{
        "@import(\"../deflate/deflate.zig\")" ++ suffix,
        "@import(\"../../src/codec/codec.zig\")" ++ suffix,
        "@import(\"/Users/someone/stdx/src/codec/codec.zig\")" ++ suffix,
    });
    try testing.expectEqual(1, findings[0].line);
}

test "relative-import flags an @import nested inside an expression" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/zlib/zlib.zig",
        \\const Decoder = @import("../deflate/decoder.zig").Decoder;
        \\fn read() void {
        \\    const adler = @import("../checksum/adler32.zig").Adler32;
        \\    _ = adler;
        \\}
    );
    try harness.expect_messages(findings, &.{
        "@import(\"../deflate/decoder.zig\")" ++ suffix,
        "@import(\"../checksum/adler32.zig\")" ++ suffix,
    });
    try testing.expectEqual(3, findings[1].line);
}

test "relative-import does not read other builtins or a computed name" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/zstd/zstd.zig",
        \\const bytes = @embedFile("../fixture.bin");
        \\const module = @import(module_name);
        \\const number = @as(u32, 1);
    );
    try harness.expect_messages(findings, &.{});
}

test "relative-import reads src/ alone" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    try testing.expect(config.scope.applies("src/zstd/block/block_header.zig"));
    try testing.expect(!config.scope.applies("tools/lint/main.zig"));
    try testing.expect(!config.scope.applies("build/modules.zig"));
    try harness.expect_messages(try findings_of(arena, "tools/graph_check.zig", failing_fixture), &.{});
}

test "relative-import resolves a path: a subdirectory file may reach its module's root directory" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    // Both paths resolve inside `src/zstd/`, the module of the importing file, so neither is a
    // finding: the rule resolves the `../` segment rather than refusing it.
    const findings = try findings_of(arena_state.allocator(), "src/zstd/block/block_header.zig",
        \\const constants = @import("../constants.zig");
        \\const frame = @import("sequences/../frame.zig");
    );
    try harness.expect_messages(findings, &.{});
}

test "relative-import flags a subdirectory file that climbs into another module" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/zstd/block/block_header.zig",
        \\const reader = @import("../../codec/reader.zig");
        \\const constants = @import("../constants.zig");
    );
    try harness.expect_messages(findings, &.{"@import(\"../../codec/reader.zig\")" ++ suffix});
    try testing.expectEqual(1, findings[0].line);
}
