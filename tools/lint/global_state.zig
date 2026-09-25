//! global-state: the library keeps no process-wide mutable state (invariant 4). A dependent runs
//! its own codec instances on its own threads, so a container-level `var` under `src/` would be one
//! copy that every thread reads and writes. Tables stdx computes once are `const`, built at
//! comptime; state a codec changes lives in the struct the caller owns.
//!
//! Over every `.zig` file under `src/`, the rule reads every `var` that is a member of a container:
//! the file's top level, or a `struct`, `union`, `enum` or `opaque`, including one declared inside
//! a function or a `test` block. It reports a `var` that is not `threadlocal`. A `threadlocal` var
//! passes the rule, but it is state all the same, and CLAUDE.md asks the owner before one lands.
//!
//! The rule is pepegrillo's `global_state` (decision 7). This file holds stdx's configuration of it
//! and the fixtures that pin that configuration.

const std = @import("std");
const pepegrillo = @import("pepegrillo");
const lint = pepegrillo.lint;
const global_state = lint.rules.global_state;

/// The configuration: every `.zig` file under `src/`.
pub const config: global_state.Config = .{
    .scope = .{ .extensions = &.{lint.paths.zig_extension}, .include_directories = &.{"src"} },
};

const Rule = global_state.Rule(config);
pub const name = Rule.name;
pub const check = Rule.check;

// Tests. Each fixture pins one shape from the header.

const testing = std.testing;
const harness = lint.harness;

fn findings_of(
    arena: std.mem.Allocator,
    path: []const u8,
    source: [:0]const u8,
) ![]const lint.report.Finding {
    return harness.run(arena, Rule, path, source);
}

const failing_fixture: [:0]const u8 =
    \\const std = @import("std");
    \\var tables_built: bool = false;
    \\pub const Decoder = struct {
    \\    var instances: u32 = 0;
    \\    window: [32]u8,
    \\};
;

test "global-state flags a var at the top level and inside a struct" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/deflate/deflate.zig", failing_fixture);
    try harness.expect_messages(findings, &.{
        "var tables_built is state every thread shares: make it threadlocal, or hand it in",
        "var instances is state every thread shares: make it threadlocal, or hand it in",
    });
    try testing.expectEqual(2, findings[0].line);
    try testing.expectEqual(4, findings[1].line);
}

test "global-state passes a comptime table and state the caller owns" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/deflate/deflate.zig",
        \\const fixed_table = build_fixed_table();
        \\pub const Decoder = struct {
        \\    window: [32]u8,
        \\    pub fn init(self: *Decoder) void {
        \\        var index: u32 = 0;
        \\        _ = &index;
        \\        self.* = undefined;
        \\    }
        \\};
    );
    try harness.expect_messages(findings, &.{});
}

test "global-state reads src/ alone" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    try testing.expect(config.scope.applies("src/zstd/zstd.zig"));
    try testing.expect(!config.scope.applies("tools/lint/main.zig"));
    try testing.expect(!config.scope.applies("build/modules.zig"));
    try harness.expect_messages(try findings_of(arena, "tools/graph_check.zig", failing_fixture), &.{});
}
