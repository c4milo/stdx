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
    \\    const codec = library(b, "codec", target, optimize);
    \\    const checksum = library(b, "checksum", target, optimize);
    \\    const deflate = library(b, "deflate", target, optimize);
    \\    deflate.addImport("codec", codec);
    \\    const zlib = library(b, "zlib", target, optimize);
    \\    zlib.addImport("codec", codec);
    \\    zlib.addImport("checksum", checksum);
    \\    zlib.addImport("deflate", deflate);
    \\    const gzip = library(b, "gzip", target, optimize);
    \\    gzip.addImport("codec", codec);
    \\    gzip.addImport("checksum", checksum);
    \\    gzip.addImport("deflate", deflate);
    \\    const zstd = library(b, "zstd", target, optimize);
    \\    zstd.addImport("codec", codec);
    \\    zstd.addImport("checksum", checksum);
    \\    const brotli = library(b, "brotli", target, optimize);
    \\    brotli.addImport("codec", codec);
    \\}
;

const passing_check: [:0]const u8 =
    \\const deflate_imports = [_]Import{
    \\    .{ .name = "codec", .root = "codec/codec.zig" },
    \\};
    \\const forbidden = [_][]const u8{ "checksum", "zlib", "gzip", "zstd", "brotli" };
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
    try testing.expectEqual(6, findings[0].line);
    try testing.expectEqualStrings(module_graph.graph_check_path, findings[1].path);
}

test "module-graph flags an edge design §3 gives and the build does not add" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const build = try build_with(arena, "    zstd.addImport(\"checksum\", checksum);\n", "");
    const findings = try compare_sources(arena, build, passing_check);
    try harness.expect_messages(findings, &.{
        "zstd does not receive \"checksum\", which design §3 gives it",
    });
    try testing.expectEqual(1, findings[0].line);
}

test "module-graph flags a module design §3 does not name, and one the build does not create" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const build = try build_with(
        arena,
        "    const checksum = library(b, \"checksum\", target, optimize);\n",
        "    const oracle = library(b, \"oracle\", target, optimize);\n",
    );
    const findings = try compare_sources(arena, build, passing_check);
    try harness.expect_messages(findings, &.{
        "design §3 names \"checksum\", which build/modules.zig does not create",
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
        \\    .{ .name = "checksum", .root = "checksum/checksum.zig" },
        \\};
    );
    try harness.expect_messages(findings, &.{
        "deflate_imports names \"checksum\", which build/modules.zig does not give deflate",
    });
    try testing.expectEqual(3, findings[0].line);
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
    try testing.expectEqual(7, calls.modules.len);
    try testing.expectEqual(10, calls.edges.len);
    try testing.expectEqualStrings("deflate", calls.edges[0].module);
    try testing.expectEqualStrings("codec", calls.edges[0].name);
    try testing.expectEqualStrings("brotli", calls.edges[9].module);
    try testing.expectEqual(18, calls.edges[9].line);
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
    try testing.expect(!module_graph.applies("src/deflate/deflate.zig"));
    try testing.expect(!module_graph.applies("tools/graph_check.zig"));
}

test "the expected graph is design §3's table" {
    // Written out rather than read from `expected_graph`, so an edge dropped from it fails here.
    const table = [_][2][]const u8{
        .{ "deflate", "codec" },
        .{ "zlib", "codec" },
        .{ "zlib", "checksum" },
        .{ "zlib", "deflate" },
        .{ "gzip", "codec" },
        .{ "gzip", "checksum" },
        .{ "gzip", "deflate" },
        .{ "zstd", "codec" },
        .{ "zstd", "checksum" },
        .{ "brotli", "codec" },
    };
    var edge_count: usize = 0;
    for (module_graph.expected_graph) |module| edge_count += module.imports.len;
    try testing.expectEqual(table.len, edge_count);
    try testing.expectEqual(7, module_graph.expected_graph.len);
    for (table) |edge| try testing.expect(expected_edge(edge[0], edge[1]));
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
