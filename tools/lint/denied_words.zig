//! denied-words: no stdx source names a consumer (CLAUDE.md, Non-negotiables; decision 1;
//! invariant 15). stdx is a library of codecs that any project may take. A consumer's name in the
//! source would be the first step to a decision that only makes sense inside that consumer.
//!
//! Over every `.zig` file in the tree but this one, the rule reports, in any case, each whole-word
//! occurrence of a name in `consumer_names`. This file spells the names it denies, so it is left
//! out. The design documents may name a consumer: they say who asked for what, and the code must
//! not depend on it.
//!
//! The list holds the projects of the same owner that consume stdx or sit next to one that does:
//! the first consumer, its HTTP/1.1 module, and the projects around it.
//!
//! The rule is pepegrillo's `denied_words` (decision 7). This file holds stdx's configuration of
//! it and the fixtures that pin that configuration.

const std = @import("std");
const pepegrillo = @import("pepegrillo");
const lint = pepegrillo.lint;
const denied_words = lint.rules.denied_words;

/// The names no stdx source spells.
const consumer_names = [_][]const u8{ "colibri", "h11", "stompy", "chapulin", "cocuyo" };

/// The configuration: every `.zig` file but this one, which spells the names.
pub const config: denied_words.Config = .{
    .scope = .{
        .extensions = &.{lint.paths.zig_extension},
        .exclude_paths = &.{"tools/lint/denied_words.zig"},
    },
    .words = &consumer_names,
    .word_label = "a consumer's name (decision 1, invariant 15):",
};

const Rule = denied_words.Rule(config);
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

test "denied-words flags every consumer's name, in any case" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/gzip/gzip.zig",
        \\// Colibri's h11 decodes gzip with this.
        \\// STOMPY, chapulin and cocuyo too.
    );
    const label = "a consumer's name (decision 1, invariant 15): ";
    try harness.expect_messages(findings, &.{
        label ++ "\"Colibri\"",
        label ++ "\"h11\"",
        label ++ "\"STOMPY\"",
        label ++ "\"chapulin\"",
        label ++ "\"cocuyo\"",
    });
}

test "denied-words passes a name that holds a denied word inside a longer one" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/gzip/gzip.zig",
        \\const h110 = 110;
        \\const colibri_window = 1;
        \\// HTTP/1.1 transfer codings.
    );
    try harness.expect_messages(findings, &.{});
}

test "denied-words reads every .zig file but its own list" {
    try testing.expect(config.scope.applies("src/gzip/gzip.zig"));
    try testing.expect(config.scope.applies("build/modules.zig"));
    try testing.expect(config.scope.applies("build.zig"));
    try testing.expect(config.scope.applies("tools/graph_check.zig"));
    try testing.expect(!config.scope.applies("tools/lint/denied_words.zig"));
    try testing.expect(!config.scope.applies("docs/design.md"));
}
