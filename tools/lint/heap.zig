//! heap: stdx is zero heap (CLAUDE.md, Non-negotiables; decision 3; invariant 1). The caller owns
//! every state, window, table and hash chain, stdx exposes their sizes as comptime constants, and
//! nothing under `src/` obtains memory.
//!
//! Over every `.zig` file under `src/`, the rule makes two checks:
//!   1. a chain that starts with one of `forbidden_prefixes` at a dot boundary: `std.heap`, such
//!      as `std.heap.page_allocator` or `std.heap.ArenaAllocator`, and the allocators of
//!      `std.testing`. Naming one means a file has an allocator of its own, and a test is no
//!      exception: a test that needs scratch memory declares a fixed array;
//!   2. a parameter whose type names `Allocator`, on any function. No name is exempt, `init`
//!      included. The type is matched by segment, so `std.mem.Allocator`, `mem.Allocator` and a
//!      bare `Allocator` all match, and so do the wrapped forms `?Allocator`, `*const Allocator`
//!      and `[]const Allocator`, because the whole type expression is searched.
//!
//! What the rule cannot see: a parameter declared `anytype` carries no type expression, so an
//! allocator passed as `anytype` is invisible to check 2. A field or a local typed `Allocator` is
//! not read either, but it has to be filled from somewhere, and the three places a file under
//! `src/` could get an allocator from are `std.heap`, `std.testing` and a parameter, which the two
//! checks cover.
//!
//! The rule is pepegrillo's `forbidden_references` (decision 7). This file holds stdx's
//! configuration of it and the fixtures that pin that configuration.

const std = @import("std");
const pepegrillo = @import("pepegrillo");
const lint = pepegrillo.lint;
const forbidden_references = lint.rules.forbidden_references;

/// Every chain that names an allocator a file did not receive. `std.testing` is listed member by
/// member, because the rest of it is what every test uses.
const forbidden_prefixes = [_][]const u8{
    "std.heap",
    "std.testing.allocator",
    "std.testing.allocator_instance",
    "std.testing.failing_allocator",
    "std.testing.FailingAllocator",
};

/// The configuration. It reads `src/` alone: developer tooling under `tools/` allocates freely,
/// and nothing under `tools/` is linked into the library. A parameter type holding the segment
/// `Allocator` is an allocator, and the reason is printed after every finding.
pub const config: forbidden_references.Config = .{
    .name = "heap",
    .scope = .{ .extensions = &.{lint.paths.zig_extension}, .include_directories = &.{"src"} },
    .prefixes = &forbidden_prefixes,
    .parameter_check = .{ .type_segment = "Allocator", .description = "an allocator parameter" },
    .reason = "stdx is zero heap (decision 3, invariant 1)",
};

const Rule = forbidden_references.Rule(config);
pub const name = Rule.name;
pub const check = Rule.check;

// Tests. Each fixture pins one shape from the header.

const testing = std.testing;
const harness = lint.harness;

const reason = "stdx is zero heap (decision 3, invariant 1)";

fn findings_of(
    arena: std.mem.Allocator,
    path: []const u8,
    source: [:0]const u8,
) ![]const lint.report.Finding {
    return harness.run(arena, Rule, path, source);
}

const passing_fixture: [:0]const u8 =
    \\const std = @import("std");
    \\const constants = @import("constants.zig");
    \\
    \\pub const Decoder = struct {
    \\    window: [constants.window_len]u8,
    \\
    \\    pub fn init(self: *Decoder) void {
    \\        self.* = .{ .window = undefined };
    \\    }
    \\};
    \\
    \\pub const decoder_len = @sizeOf(Decoder);
    \\
    \\test "a test declares its scratch memory" {
    \\    var scratch: [64]u8 = @splat(0);
    \\    try std.testing.expectEqual(0, scratch[0]);
    \\}
;

const failing_fixture: [:0]const u8 =
    \\const std = @import("std");
    \\
    \\const arena_type = std.heap.ArenaAllocator;
    \\
    \\pub fn decode(allocator: std.mem.Allocator, input: []const u8) !usize {
    \\    _ = allocator;
    \\    return input.len;
    \\}
;

test "heap passes a file whose storage the caller owns" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/deflate/deflate.zig", passing_fixture);
    try harness.expect_messages(findings, &.{});
}

test "heap flags std.heap and an allocator parameter" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/deflate/deflate.zig", failing_fixture);
    try harness.expect_messages(findings, &.{
        "reference to std.heap.ArenaAllocator: " ++ reason,
        "decode takes an allocator parameter: " ++ reason,
    });
    try testing.expectEqual(3, findings[0].line);
    try testing.expectEqual(5, findings[1].line);
}

test "heap flags an init that takes an allocator, because no name is exempt" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/zstd/zstd.zig",
        \\pub const Decoder = struct {
        \\    pub fn init(allocator: std.mem.Allocator, window_len: usize) !Decoder {
        \\        return .{ .window = try allocator.alloc(u8, window_len) };
        \\    }
        \\};
    );
    try harness.expect_messages(findings, &.{"init takes an allocator parameter: " ++ reason});
    try testing.expectEqual(2, findings[0].line);
}

test "heap flags a test that reaches for an allocator of std.testing" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/checksum/crc32.zig",
        \\test "crc" {
        \\    const one = std.testing.allocator;
        \\    const two = std.testing.failing_allocator;
        \\    var three = std.testing.FailingAllocator.init(one, .{});
        \\    const four = std.testing.allocator_instance;
        \\    try std.testing.expect(true);
        \\}
    );
    try harness.expect_messages(findings, &.{
        "reference to std.testing.allocator: " ++ reason,
        "reference to std.testing.failing_allocator: " ++ reason,
        "reference to std.testing.FailingAllocator.init: " ++ reason,
        "reference to std.testing.allocator_instance: " ++ reason,
    });
}

test "heap finds an allocator wrapped in a pointer, an optional or a slice" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/codec/codec.zig",
        \\fn one(allocator: *const std.mem.Allocator) void {}
        \\fn two(allocator: ?Allocator) void {}
        \\fn three(allocators: []const mem.Allocator) void {}
    );
    try harness.expect_messages(findings, &.{
        "one takes an allocator parameter: " ++ reason,
        "two takes an allocator parameter: " ++ reason,
        "three takes an allocator parameter: " ++ reason,
    });
}

test "heap does not flag a parameter whose type merely resembles the word" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/codec/codec.zig",
        \\fn one(allocation: Allocations) void {}
        \\fn two(bytes: []u8, count: u32) void {}
        \\const heap_limit = constants.std_heap_bytes;
    );
    try harness.expect_messages(findings, &.{});
}

test "heap names an anonymous function type when a prototype has no name" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/brotli/brotli.zig",
        \\pub const Table = struct {
        \\    grow: *const fn (allocator: Allocator) void,
        \\};
    );
    try harness.expect_messages(findings, &.{
        "an anonymous function type takes an allocator parameter: " ++ reason,
    });
}

test "heap reads src/ alone" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    try testing.expect(config.scope.applies("src/deflate/deflate.zig"));
    try testing.expect(config.scope.applies("./src/gzip/header.zig"));
    try testing.expect(!config.scope.applies("tools/lint/main.zig"));
    try testing.expect(!config.scope.applies("build/modules.zig"));
    try testing.expect(!config.scope.applies("docs/design.md"));
    try harness.expect_messages(try findings_of(arena, "tools/lint/heap.zig", failing_fixture), &.{});
}
