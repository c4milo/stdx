//! Tests for the module-graph rule: one fixture per shape its header names. The comparison is
//! driven directly, with both files in memory, so the fixtures are string constants.

const std = @import("std");
const Allocator = std.mem.Allocator;
const Ast = std.zig.Ast;
const testing = std.testing;
const pepegrillo = @import("pepegrillo");
const harness = pepegrillo.lint.harness;
const report = pepegrillo.lint.report;
const module_graph = @import("module_graph.zig");

const passing_build: [:0]const u8 =
    \\pub fn add(b: *std.Build) Modules {
    \\    const platform = library(b, "platform", target, optimize);
    \\    const codec = library(b, "codec", target, optimize);
    \\    codec.addImport("platform", platform);
    \\    const checksum = library(b, "hash", target, optimize);
    \\    const deflate = library(b, "deflate", target, optimize);
    \\    deflate.addImport("codec", codec);
    \\    deflate.addImport("platform", platform);
    \\    const zlib = library(b, "zlib", target, optimize);
    \\    zlib.addImport("codec", codec);
    \\    zlib.addImport("hash", checksum);
    \\    zlib.addImport("deflate", deflate);
    \\    zlib.addImport("platform", platform);
    \\    const gzip = library(b, "gzip", target, optimize);
    \\    gzip.addImport("codec", codec);
    \\    gzip.addImport("hash", checksum);
    \\    gzip.addImport("deflate", deflate);
    \\    gzip.addImport("platform", platform);
    \\    const zstd = library(b, "zstd", target, optimize);
    \\    zstd.addImport("codec", codec);
    \\    zstd.addImport("hash", checksum);
    \\    zstd.addImport("platform", platform);
    \\    const brotli = library(b, "brotli", target, optimize);
    \\    brotli.addImport("codec", codec);
    \\    brotli.addImport("platform", platform);
    \\    const base64 = library(b, "base64", target, optimize);
    \\    base64.addImport("codec", codec);
    \\    base64.addImport("platform", platform);
    \\    const utf8 = library(b, "utf8", target, optimize);
    \\    const unicode = library(b, "unicode", target, optimize);
    \\    unicode.addImport("utf8", utf8);
    \\    const json = library(b, "json", target, optimize);
    \\    json.addImport("codec", codec);
    \\    json.addImport("base64", base64);
    \\    json.addImport("utf8", utf8);
    \\    json.addImport("platform", platform);
    \\    const regex = library(b, "regex", target, optimize);
    \\    regex.addImport("codec", codec);
    \\    regex.addImport("utf8", utf8);
    \\    regex.addImport("unicode", unicode);
    \\    regex.addImport("platform", platform);
    \\    const crypto = library(b, "crypto", target, optimize);
    \\    crypto.addImport("chapulin", chapulin);
    \\    const stdx = library(b, "stdx", target, optimize);
    \\    stdx.addImport("codec", codec);
    \\    stdx.addImport("hash", checksum);
    \\    stdx.addImport("deflate", deflate);
    \\    stdx.addImport("zlib", zlib);
    \\    stdx.addImport("gzip", gzip);
    \\    stdx.addImport("zstd", zstd);
    \\    stdx.addImport("brotli", brotli);
    \\    stdx.addImport("utf8", utf8);
    \\    stdx.addImport("unicode", unicode);
    \\    stdx.addImport("json", json);
    \\    stdx.addImport("base64", base64);
    \\    stdx.addImport("platform", platform);
    \\    stdx.addImport("regex", regex);
    \\    stdx.addImport("stdx_options", stdx_options);
    \\    stdx.addImport("crypto", crypto);
    \\}
;

const passing_check: [:0]const u8 =
    \\const deflate_imports = [_]Import{
    \\    .{ .name = "codec", .root = "codec/codec.zig", .imports = &.{"platform"} },
    \\    .{ .name = "platform", .root = "platform/platform.zig" },
    \\};
    \\const forbidden = [_][]const u8{ "hash", "zlib", "gzip", "zstd", "brotli", "json" };
;

/// Runs the comparison over two in-memory sources and returns the findings sorted.
fn compare_sources(
    arena: Allocator,
    build_source: [:0]const u8,
    check_source: [:0]const u8,
) ![]const report.Finding {
    var build_tree = try Ast.parse(arena, build_source, .zig);
    try testing.expectEqual(0, build_tree.errors.len);
    var check_tree = try Ast.parse(arena, check_source, .zig);
    try testing.expectEqual(0, check_tree.errors.len);
    var findings: report.Findings = .{ .arena = arena };
    try module_graph.compare(
        arena,
        &findings,
        .{ .path = module_graph.build_modules_path, .tree = &build_tree },
        .{ .path = module_graph.graph_check_path, .tree = &check_tree },
    );
    findings.sort();
    return findings.items.items;
}

/// `passing_build` with one line replaced, so each fixture states only what it changes.
fn build_with(arena: Allocator, old: []const u8, new: []const u8) ![:0]const u8 {
    const replaced = try std.mem.replaceOwned(u8, arena, passing_build, old, new);
    return arena.dupeZ(u8, replaced);
}

test "module-graph passes the graph design §3 states" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try compare_sources(arena_state.allocator(), passing_build, passing_check);
    try harness.expect_messages(findings, &.{});
}

test "module-graph flags a wrapper the build gives deflate, in the build and in the check" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const build = try build_with(
        arena,
        "    deflate.addImport(\"codec\", codec);\n",
        "    deflate.addImport(\"codec\", codec);\n    deflate.addImport(\"gzip\", gzip);\n",
    );
    const findings = try compare_sources(arena, build, passing_check);
    try harness.expect_messages(findings, &.{
        "deflate receives \"gzip\", which design §3 does not give it (invariant 14)",
        "deflate_imports lacks \"gzip\", which build/modules.zig gives deflate",
    });
    try testing.expectEqualStrings(module_graph.build_modules_path, findings[0].path);
    try testing.expectEqual(8, findings[0].line);
    try testing.expectEqualStrings(module_graph.graph_check_path, findings[1].path);
}

test "module-graph flags an edge design §3 gives and the build does not add" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const build = try build_with(arena, "    zstd.addImport(\"hash\", checksum);\n", "");
    const findings = try compare_sources(arena, build, passing_check);
    try harness.expect_messages(findings, &.{
        "zstd does not receive \"hash\", which design §3 gives it",
    });
    try testing.expectEqual(1, findings[0].line);
}

test "module-graph flags a module design §3 does not name, and one the build does not create" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const build = try build_with(
        arena,
        "    const checksum = library(b, \"hash\", target, optimize);\n",
        "    const oracle = library(b, \"oracle\", target, optimize);\n",
    );
    const findings = try compare_sources(arena, build, passing_check);
    try harness.expect_messages(findings, &.{
        "design §3 names \"hash\", which build/modules.zig does not create",
        "build/modules.zig creates \"oracle\", which design §3 does not name (invariant 14)",
    });
}

test "module-graph flags an edge whose receiver is no library module" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const build = try build_with(
        arena,
        "    brotli.addImport(\"codec\", codec);\n",
        "    brotli.addImport(\"codec\", codec);\n    bench.addImport(\"zlib\", zlib);\n",
    );
    const findings = try compare_sources(arena, build, passing_check);
    try harness.expect_messages(findings, &.{
        "bench is not a library module; build/modules.zig holds the library graph alone" ++
            " (invariant 14)",
    });
}

test "module-graph flags a check list that drifts from the build" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try compare_sources(arena_state.allocator(), passing_build,
        \\const deflate_imports = [_]Import{
        \\    .{ .name = "codec", .root = "codec/codec.zig" },
        \\    .{ .name = "platform", .root = "platform/platform.zig" },
        \\    .{ .name = "hash", .root = "hash/hash.zig" },
        \\};
    );
    try harness.expect_messages(findings, &.{
        "deflate_imports names \"hash\", which build/modules.zig does not give deflate",
    });
    try testing.expectEqual(4, findings[0].line);
}

test "module-graph flags a check with no deflate_imports list at all" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try compare_sources(arena_state.allocator(), passing_build,
        \\const forbidden = [_][]const u8{ "zlib", "gzip" };
    );
    try harness.expect_messages(findings, &.{
        "tools/graph_check.zig declares no deflate_imports list;" ++
            " the check cannot state the graph it proves (invariant 14)",
    });
}

test "module-graph reads the created modules and the edges of every receiver" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    var tree = try Ast.parse(arena, passing_build, .zig);
    const calls = try module_graph.collect_calls(arena, &tree);
    try testing.expectEqual(15, calls.modules.len);
    try testing.expectEqual(43, calls.edges.len);
    try testing.expectEqualStrings("codec", calls.edges[0].module);
    try testing.expectEqualStrings("platform", calls.edges[0].name);
    try testing.expectEqual(4, calls.edges[0].line);
    try testing.expectEqualStrings("brotli", calls.edges[14].module);
    try testing.expectEqual(24, calls.edges[14].line);
}

test "module-graph finds the check beside build/modules.zig, whatever the walk's prefix was" {
    var buffer: [64]u8 = undefined;
    try testing.expectEqualStrings(
        "tools/graph_check.zig",
        try module_graph.check_path_beside(&buffer, "build/modules.zig"),
    );
    try testing.expectEqualStrings(
        "./tools/graph_check.zig",
        try module_graph.check_path_beside(&buffer, "./build/modules.zig"),
    );
}

test "module-graph runs on build/modules.zig and on nothing else" {
    try testing.expect(module_graph.applies("build/modules.zig"));
    try testing.expect(module_graph.applies("./build/modules.zig"));
    try testing.expect(!module_graph.applies("build/lint.zig"));
    try testing.expect(!module_graph.applies("src/compress/deflate/deflate.zig"));
    try testing.expect(!module_graph.applies("tools/graph_check.zig"));
}

test "the expected graph is design §3's table" {
    // Written out rather than read from `expected_graph`, so an edge dropped from it fails here.
    const table = [_][2][]const u8{
        .{ "codec", "platform" },
        .{ "deflate", "codec" },
        .{ "deflate", "platform" },
        .{ "zlib", "codec" },
        .{ "zlib", "hash" },
        .{ "zlib", "deflate" },
        .{ "zlib", "platform" },
        .{ "gzip", "codec" },
        .{ "gzip", "hash" },
        .{ "gzip", "deflate" },
        .{ "gzip", "platform" },
        .{ "zstd", "codec" },
        .{ "zstd", "hash" },
        .{ "zstd", "platform" },
        .{ "brotli", "codec" },
        .{ "brotli", "platform" },
        .{ "json", "codec" },
        .{ "json", "base64" },
        .{ "json", "utf8" },
        .{ "json", "platform" },
        .{ "base64", "codec" },
        .{ "base64", "platform" },
        .{ "regex", "codec" },
        .{ "regex", "utf8" },
        .{ "regex", "unicode" },
        .{ "regex", "platform" },
        .{ "unicode", "utf8" },
        .{ "stdx", "codec" },
        .{ "stdx", "hash" },
        .{ "stdx", "deflate" },
        .{ "stdx", "zlib" },
        .{ "stdx", "gzip" },
        .{ "stdx", "zstd" },
        .{ "stdx", "brotli" },
        .{ "stdx", "utf8" },
        .{ "stdx", "unicode" },
        .{ "stdx", "json" },
        .{ "stdx", "base64" },
        .{ "stdx", "platform" },
        .{ "stdx", "regex" },
        .{ "stdx", "stdx_options" },
        .{ "stdx", "crypto" },
        .{ "crypto", "chapulin" },
    };
    var edge_count: usize = 0;
    for (module_graph.expected_graph) |module| edge_count += module.imports.len;
    try testing.expectEqual(table.len, edge_count);
    try testing.expectEqual(15, module_graph.expected_graph.len);
    for (table) |edge| try testing.expect(expected_edge(edge[0], edge[1]));
}

test "platform imports nothing, and only the modules whose calls take CpuFeatures import it" {
    // Decisions 21 and 40 as amended on 2026-11-24: a codec imports `platform` for the type
    // `CpuFeatures`, and the cpu-probe rule, not the graph, keeps the probe out of its reach. A
    // module that takes no CPU features does not import it, and no module imports the root.
    const takes_features = [_][]const u8{ "codec", "deflate", "zlib", "gzip", "zstd", "brotli", "json", "base64", "regex", "stdx" };
    for (module_graph.expected_graph) |module| {
        if (std.mem.eql(u8, module.name, "platform")) try testing.expectEqual(0, module.imports.len);
        try testing.expect(!expected_edge(module.name, "stdx"));
        var takes = false;
        for (takes_features) |name| takes = takes or std.mem.eql(u8, name, module.name);
        try testing.expectEqual(takes, expected_edge(module.name, "platform"));
    }
    try testing.expect(expected_module("platform"));
}

fn expected_module(module_name: []const u8) bool {
    for (module_graph.expected_graph) |module| {
        if (std.mem.eql(u8, module.name, module_name)) return true;
    }
    return false;
}

fn expected_edge(module_name: []const u8, import: []const u8) bool {
    for (module_graph.expected_graph) |module| {
        if (!std.mem.eql(u8, module.name, module_name)) continue;
        for (module.imports) |candidate| {
            if (std.mem.eql(u8, candidate, import)) return true;
        }
    }
    return false;
}
