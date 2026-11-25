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
//! `@import("block/block_header.zig")` and, from `src/compress/zstd/block/block_header.zig`,
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

/// The configuration of the rule over the folder `root`, whose children are each a module. It
/// reads `root` and flags a path that resolves outside the importing file's module under it, or
/// starts with `/`.
fn config_under(comptime root: []const u8) relative_import.Config {
    return .{
        .scope = .{ .extensions = &.{lint.paths.zig_extension}, .include_directories = &.{root} },
        .mode = .leaves_subsystem,
        .source_root = root,
        .message = "@import(\"{[path]s}\") reaches out of the module by path;" ++
            " import the module name build/modules.zig declares",
    };
}

/// The rule over `src/`, whose children are a module each, or a category's folder.
pub const config = config_under("src");

const Rule = relative_import.Rule(config);
pub const name = Rule.name;

/// The folders that hold a category's modules, each a module of its own (decision 6 as amended).
/// The rule over `src/` alone would read `src/compress/` as one module, and pass a gzip file that
/// reaches into `deflate` by path. pepegrillo's rule reads a root of one segment, so a file of a
/// category is checked under the root of the category's folder, by its path from the parent of
/// that folder: `src/compress/gzip/gzip.zig` as `compress/gzip/gzip.zig`. `src/unicode/` is the
/// `unicode` module and holds `utf8`, so `utf8` is read as a module under the root `unicode`.
const categories = .{
    .{ "src/compress/", relative_import.Rule(config_under("compress")) },
    .{ "src/encoding/", relative_import.Rule(config_under("encoding")) },
    .{ "src/unicode/utf8/", relative_import.Rule(config_under("unicode")) },
};

/// The part of a source path that comes before its category's folder.
const source_prefix = "src/";

pub fn check(context: *lint.report.Context, file: *const lint.report.File) !void {
    inline for (categories) |category| {
        if (std.mem.indexOf(u8, file.path, category[0])) |start| {
            return check_category(category[1], context, file, start + source_prefix.len);
        }
    }
    return Rule.check(context, file);
}

/// Checks `file` under a category's rule, by its path from `cut`, then gives each new finding the
/// file's whole path back.
fn check_category(comptime CategoryRule: type, context: *lint.report.Context, file: *const lint.report.File, cut: usize) !void {
    std.debug.assert(cut < file.path.len);
    const first = context.findings.items.items.len;
    const within: lint.report.File = .{ .path = file.path[cut..], .source = file.source, .tree = file.tree };
    try CategoryRule.check(context, &within);
    for (context.findings.items.items[first..]) |*finding| finding.path = file.path;
}

// Tests. Each fixture pins one shape from the header.

const testing = std.testing;
const harness = lint.harness;

const suffix = " reaches out of the module by path; import the module name build/modules.zig declares";

fn findings_of(
    arena: std.mem.Allocator,
    path: []const u8,
    source: [:0]const u8,
) ![]const lint.report.Finding {
    // This file's `check`, which picks the rule of the importing file's category.
    return harness.run(arena, @This(), path, source);
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
    const findings = try findings_of(arena_state.allocator(), "src/compress/gzip/gzip.zig", passing_fixture);
    try harness.expect_messages(findings, &.{});
}

test "relative-import flags a parent path and an absolute path" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/compress/gzip/gzip.zig", failing_fixture);
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
    const findings = try findings_of(arena_state.allocator(), "src/compress/zlib/zlib.zig",
        \\const Decoder = @import("../deflate/decoder/decoder.zig").Decoder;
        \\fn read() void {
        \\    const adler = @import("../checksum/adler32.zig").Adler32;
        \\    _ = adler;
        \\}
    );
    try harness.expect_messages(findings, &.{
        "@import(\"../deflate/decoder/decoder.zig\")" ++ suffix,
        "@import(\"../checksum/adler32.zig\")" ++ suffix,
    });
    try testing.expectEqual(3, findings[1].line);
}

test "relative-import does not read other builtins or a computed name" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/compress/zstd/zstd.zig",
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
    try testing.expect(config.scope.applies("src/compress/zstd/block/block_header.zig"));
    try testing.expect(!config.scope.applies("tools/lint/main.zig"));
    try testing.expect(!config.scope.applies("build/modules.zig"));
    try harness.expect_messages(try findings_of(arena, "tools/graph_check.zig", failing_fixture), &.{});
}

test "relative-import resolves a path: a subdirectory file may reach its module's root directory" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    // Both paths resolve inside `src/compress/zstd/`, the module of the importing file, so neither is a
    // finding: the rule resolves the `../` segment rather than refusing it.
    const findings = try findings_of(arena_state.allocator(), "src/compress/zstd/block/block_header.zig",
        \\const constants = @import("../constants.zig");
        \\const frame = @import("sequences/../frame.zig");
    );
    try harness.expect_messages(findings, &.{});
}

test "relative-import flags a subdirectory file that climbs into another module" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/compress/zstd/block/block_header.zig",
        \\const reader = @import("../../codec/reader.zig");
        \\const constants = @import("../constants.zig");
    );
    try harness.expect_messages(findings, &.{"@import(\"../../codec/reader.zig\")" ++ suffix});
    try testing.expectEqual(1, findings[0].line);
}

test "relative-import reads each category's folder as a folder of modules" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    // `json` reaching `base64` by path, under `src/encoding/`. The finding names the file's whole
    // path, not the path the category's rule read.
    const json_findings = try findings_of(arena, "src/encoding/json/json.zig",
        \\const base64 = @import("../base64/base64.zig");
    );
    try harness.expect_messages(json_findings, &.{"@import(\"../base64/base64.zig\")" ++ suffix});
    try testing.expectEqualStrings("src/encoding/json/json.zig", json_findings[0].path);
    // `utf8` reaching a file of `unicode`, the folder that holds it.
    try harness.expect_messages(try findings_of(arena, "src/unicode/utf8/utf8.zig",
        \\const fold = @import("../fold.zig");
    ), &.{"@import(\"../fold.zig\")" ++ suffix});
    // A module's own file, under its category's folder, passes.
    try harness.expect_messages(try findings_of(arena, "src/encoding/json/text_reader.zig",
        \\const constants = @import("constants.zig");
    ), &.{});
}
