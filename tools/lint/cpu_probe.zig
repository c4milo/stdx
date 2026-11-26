//! cpu-probe: no library code reads the CPU (decisions 21 and 40 as amended on 2026-11-24;
//! invariant 14). A program calls `platform.CpuFeatures.detect()` once, when it starts, and passes
//! what it gives down its stack. stdx keeps no copy (invariant 4), and no codec path detects:
//! CPUID on a virtual machine is an exit to its hypervisor (decision 21).
//!
//! The codecs import `platform` for the type `CpuFeatures`, which each `init` takes, so the module
//! graph no longer keeps the probe out of their reach. This rule does. Over every `.zig` file
//! under `src/` but `src/platform/`, it flags:
//! - a chain that names `platform.CpuFeatures.detect`, called or not;
//! - a chain that names `platform.set_data_independent_timing`, which sets the calling thread's
//!   mode (decision 40 as amended on 2026-11-25). A library call runs on a thread it did not
//!   start, so only the program sets the mode. Library code may read it with
//!   `platform.data_independent_timing`: `stdx.crypto` reads it at each call, to state the
//!   timing of the thread that runs chapulin's code (decision 87 as amended on 2026-11-26);
//! - the same chain through a file-level alias, such as `const CpuFeatures = platform.CpuFeatures;`
//!   and then `CpuFeatures.detect()`;
//! - a call of any function named `detect`, whatever its receiver. No function of stdx's but
//!   `CpuFeatures.detect` has that name, so the rule needs no type to read the call.
//!
//! The walk reads a chain that starts with a name, and no chain that starts with
//! `@import("platform")` written in place. So the rule also requires each `@import("platform")`
//! to be the value of a declaration named `platform`, as `const platform = @import("platform");`.
//! Then every reference through the module starts with `platform`, or with a file-level alias the
//! walk resolves.
//!
//! A test may call both, where it reads the host's CPU to reach each path the host has. The rule
//! reads no file whose stem ends in `_test` or holds `_test_`, and it reads every other file with
//! its top-level `test` blocks blanked, byte for byte, so a finding keeps its line and its
//! column. A function outside a `test` block is library code to the rule, even when only a test
//! calls it.
//!
//! What the rule cannot see: a name another file exports, a name a function declares for the
//! module, as `const module = platform;` inside a function body, and a `test` block inside a
//! container. The first two are pepegrillo's limits of `forbidden_references`: the walk resolves
//! the aliases at the top level of a file alone. The rule reads the last one as library code, so
//! it fails closed.
//!
//! The rule is pepegrillo's `forbidden_references` (decision 7). This file holds stdx's
//! configuration of it, the pass that leaves the tests out, and the fixtures that pin both.

const std = @import("std");
const Allocator = std.mem.Allocator;
const Ast = std.zig.Ast;
const pepegrillo = @import("pepegrillo");
const lint = pepegrillo.lint;
const forbidden_references = lint.rules.forbidden_references;

/// A chain that starts with one of these at a dot boundary is a finding: the detection of the
/// CPU's features, and the set of a thread's mode.
const forbidden_prefixes = [_][]const u8{
    "platform.CpuFeatures.detect",
    "platform.set_data_independent_timing",
};

/// A call whose callee ends with one of these is a finding, whatever the receiver.
const forbidden_callees = [_][]const u8{"detect"};

/// The one directory under `src/` that reads the CPU: the `platform` module (decision 40).
const platform_directory = "src/platform";

/// A file whose stem ends in this segment, or holds it before a `_`, holds tests alone.
const test_stem_segment = "_test";

/// The byte a blanked test's bytes become. A line break stays, so every line keeps its number.
const blank = ' ';

/// The module whose import must carry its own name, and the name.
const platform_module = "platform";

/// What the rule reports for an import of `platform` under another name or in place.
const import_message = "import platform as `const platform = @import(\"platform\");`," ++
    " so each call through it is a name the rule reads (invariant 14)";

/// The configuration. It reads every file under `src/` but `platform`'s and the test files.
pub const config: forbidden_references.Config = .{
    .name = "cpu-probe",
    .scope = .{
        .extensions = &.{lint.paths.zig_extension},
        .include_directories = &.{"src"},
        .exclude_directories = &.{platform_directory},
        .exclude_stem_segment = test_stem_segment,
    },
    .prefixes = &forbidden_prefixes,
    .callee_names = &forbidden_callees,
    .resolve_file_aliases = true,
    .reason = "a program reads the CPU once and passes it in (decisions 21 and 40, invariant 14)",
};

const Rule = forbidden_references.Rule(config);
pub const name = Rule.name;

/// Reads the file with its tests blanked, under `config`.
pub fn check(context: *lint.report.Context, file: *const lint.report.File) !void {
    if (!config.scope.applies(file.path)) return;
    const tree = file.tree orelse return;
    const source = try without_tests(context.arena, file.source, tree);
    var library_tree = try Ast.parse(context.arena, source, .zig);
    defer library_tree.deinit(context.arena);
    if (library_tree.errors.len != 0) {
        const message = "the file does not parse with its tests left out";
        return context.findings.add(file.path, 1, 1, name, message, .{});
    }
    try check_imports(context, file.path, &library_tree);
    try Rule.check(context, &.{ .path = file.path, .source = source, .tree = &library_tree });
}

/// Reports each `@import("platform")` that is not the value of a declaration named `platform`.
fn check_imports(context: *lint.report.Context, path: []const u8, tree: *const Ast) !void {
    // An import spells four tokens: `@import`, `(`, `"platform"` and `)`.
    const import_tokens = 4;
    if (tree.tokens.len < import_tokens) return;
    for (0..tree.tokens.len - import_tokens + 1) |index| {
        const token: Ast.TokenIndex = @intCast(index);
        if (!is_platform_import(tree, token)) continue;
        if (is_named_declaration(tree, token)) continue;
        const location = tree.tokenLocation(0, token);
        try context.findings.add(path, location.line + 1, location.column + 1, name, import_message, .{});
    }
}

/// True when the tokens from `token` spell `@import("platform")`.
fn is_platform_import(tree: *const Ast, token: Ast.TokenIndex) bool {
    if (tree.tokenTag(token) != .builtin) return false;
    if (!std.mem.eql(u8, tree.tokenSlice(token), "@import")) return false;
    if (tree.tokenTag(token + 1) != .l_paren or tree.tokenTag(token + 3) != .r_paren) return false;
    if (tree.tokenTag(token + 2) != .string_literal) return false;
    return std.mem.eql(u8, tree.tokenSlice(token + 2), "\"" ++ platform_module ++ "\"");
}

/// True when the import at `token` is the whole value of `const platform = @import(...);`.
fn is_named_declaration(tree: *const Ast, token: Ast.TokenIndex) bool {
    // `const`, the name and `=` come before the import, and `;` comes after its four tokens.
    const declaration_tokens = 3;
    if (token < declaration_tokens) return false;
    if (tree.tokenTag(token - 3) != .keyword_const or tree.tokenTag(token - 1) != .equal) return false;
    if (tree.tokenTag(token + 4) != .semicolon) return false;
    return std.mem.eql(u8, tree.tokenSlice(token - 2), platform_module);
}

/// A copy of `source` with every top-level `test` declaration blanked. Zig takes no doc comment
/// on a test, so the declaration starts at its `test` keyword.
pub fn without_tests(arena: Allocator, source: [:0]const u8, tree: *const Ast) ![:0]const u8 {
    const blanked = try arena.dupeZ(u8, source);
    for (tree.rootDecls()) |declaration| {
        if (tree.nodeTag(declaration) != .test_decl) continue;
        const last = tree.lastToken(declaration);
        const start = tree.tokenStart(tree.firstToken(declaration));
        const end = tree.tokenStart(last) + tree.tokenSlice(last).len;
        std.debug.assert(start < end and end <= blanked.len);
        for (blanked[start..end]) |*byte| {
            if (byte.* != '\n') byte.* = blank;
        }
    }
    return blanked;
}

// Tests. Each fixture pins one shape from the header.

const testing = std.testing;
const harness = lint.harness;

const reason = "a program reads the CPU once and passes it in (decisions 21 and 40, invariant 14)";

fn findings_of(
    arena: std.mem.Allocator,
    path: []const u8,
    source: [:0]const u8,
) ![]const lint.report.Finding {
    return harness.run(arena, @This(), path, source);
}

/// A codec that reads the CPU in its own code: the detection, as written and through names.
const reading_fixture: [:0]const u8 =
    \\const platform = @import("platform");
    \\const CpuFeatures = platform.CpuFeatures;
    \\const detect_cpu = platform.CpuFeatures.detect;
    \\
    \\pub fn init(self: *Decoder) void {
    \\    self.features = platform.CpuFeatures.detect();
    \\    self.again = CpuFeatures.detect();
    \\    self.through_value = self.kind.detect();
    \\}
;

test "cpu-probe flags the detection, as written and through a name" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/compress/deflate/decoder.zig", reading_fixture);
    try harness.expect_messages(findings, &.{
        "reference to platform.CpuFeatures.detect: " ++ reason,
        "reference to platform.CpuFeatures.detect: " ++ reason,
        "reference to platform.CpuFeatures.detect through CpuFeatures: " ++ reason,
        "reference to self.kind.detect: " ++ reason,
    });
    try testing.expectEqual(3, findings[0].line);
    try testing.expectEqual(6, findings[1].line);
    try testing.expectEqual(8, findings[3].line);
}

/// A library call that reads and sets the calling thread's mode, as written and through a name.
const timing_fixture: [:0]const u8 =
    \\const platform = @import("platform");
    \\const set_timing = platform.set_data_independent_timing;
    \\const read_timing = platform.data_independent_timing;
    \\
    \\pub fn statement(features: platform.CpuFeatures) bool {
    \\    const read = platform.data_independent_timing(features) and read_timing(features);
    \\    _ = platform.set_data_independent_timing(features, true);
    \\    return set_timing(features, read);
    \\}
;

test "cpu-probe flags the set of the thread's mode, and passes its read" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/crypto/crypto_init.zig", timing_fixture);
    try harness.expect_messages(findings, &.{
        "reference to platform.set_data_independent_timing: " ++ reason,
        "reference to platform.set_data_independent_timing: " ++ reason,
        "reference to platform.set_data_independent_timing through set_timing: " ++ reason,
    });
    try testing.expectEqual(2, findings[0].line);
    try testing.expectEqual(7, findings[1].line);
    try testing.expectEqual(8, findings[2].line);
}

/// A codec that takes the features its caller passed, names the type, and has a `probe` of its own.
const passing_fixture: [:0]const u8 =
    \\const platform = @import("platform");
    \\const three_module = @import("encoder_match_three.zig");
    \\
    \\pub fn init(self: *Encoder, features: platform.CpuFeatures) void {
    \\    self.features = features.intersect(platform.CpuFeatures.target());
    \\    self.none = platform.CpuFeatures.none();
    \\    self.probed = three_module.probe(self.window, self.position);
    \\}
;

test "cpu-probe passes a codec that takes its features, and its own probe" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/compress/deflate/encoder.zig", passing_fixture);
    try harness.expect_messages(findings, &.{});
}

/// The detection in a test block, then in library code below it.
const test_block_fixture: [:0]const u8 =
    \\const platform = @import("platform");
    \\
    \\// Reaches each path the host has.
    \\test "the loop takes every path the host has" {
    \\    var decoder: Decoder = undefined;
    \\    decoder.init(platform.CpuFeatures.detect());
    \\    _ = platform.CpuFeatures.target();
    \\}
    \\
    \\fn helper() platform.CpuFeatures {
    \\    return platform.CpuFeatures.detect();
    \\}
;

test "cpu-probe leaves out a test block, and keeps the line of the code below it" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/compress/brotli/decoder/lengths.zig", test_block_fixture);
    try harness.expect_messages(findings, &.{"reference to platform.CpuFeatures.detect: " ++ reason});
    try testing.expectEqual(11, findings[0].line);
    try testing.expectEqual(12, findings[0].column);
}

test "cpu-probe blanks a test byte for byte, and nothing else" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    var tree = try Ast.parse(arena, test_block_fixture, .zig);
    const blanked = try without_tests(arena, test_block_fixture, &tree);
    try testing.expectEqual(test_block_fixture.len, blanked.len);
    try testing.expectEqual(std.mem.count(u8, test_block_fixture, "\n"), std.mem.count(u8, blanked, "\n"));
    try testing.expect(std.mem.indexOf(u8, blanked, "test") == null);
    try testing.expectEqual(1, std.mem.count(u8, blanked, "Reaches"));
    try testing.expectEqual(1, std.mem.count(u8, blanked, "detect"));
    try testing.expect(std.mem.startsWith(u8, blanked, "const platform = @import(\"platform\");\n\n"));
}

/// `platform` imported in place, under another name, and inside an expression, beside the one
/// shape the rule reads, which a test block may break.
const import_fixture: [:0]const u8 =
    \\const platform = @import("platform");
    \\pub const exported = struct {
    \\    const platform = @import("platform");
    \\};
    \\const cpu = @import("platform");
    \\const Features = @import("platform").CpuFeatures;
    \\
    \\fn read() void {
    \\    _ = @import("platform").CpuFeatures.detect();
    \\}
    \\
    \\test "a test may write it in place" {
    \\    _ = @import("platform").CpuFeatures.detect();
    \\}
;

test "cpu-probe requires each import of platform to be named platform" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/compress/gzip/decoder.zig", import_fixture);
    try harness.expect_messages(findings, &.{ import_message, import_message, import_message });
    try testing.expectEqual(5, findings[0].line);
    try testing.expectEqual(13, findings[0].column);
    try testing.expectEqual(6, findings[1].line);
    try testing.expectEqual(9, findings[2].line);
    try testing.expectEqual(9, findings[2].column);
    // A file the rule does not read may write it any way.
    try harness.expect_messages(try findings_of(arena_state.allocator(), "src/platform/platform.zig", import_fixture), &.{});
}

test "cpu-probe reads src/ but platform and the test files, and nothing outside src/" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    for ([_][]const u8{ "src/encoding/json/json.zig", "./src/codec/io_reader.zig", "src/regex/literal.zig" }) |path| {
        try testing.expect(config.scope.applies(path));
        try testing.expectEqual(4, (try findings_of(arena, path, reading_fixture)).len);
    }
    const left_out = [_][]const u8{
        "src/platform/platform.zig",
        "src/platform/platform_cpu_features.zig",
        "src/compress/deflate/decoder/decoder_test.zig",
        "src/compress/zstd/decoder/decoder_fuzz_test.zig",
        "src/encoding/json/decoder/decoder_test_support.zig",
        "tools/differential/checksum.zig",
        "bench/deflate/deflate.zig",
    };
    for (left_out) |path| {
        try testing.expect(!config.scope.applies(path));
        try harness.expect_messages(try findings_of(arena, path, reading_fixture), &.{});
    }
}
