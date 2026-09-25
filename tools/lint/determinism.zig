//! determinism: no source reads a clock or randomness (CLAUDE.md, Non-negotiables; decision 5;
//! invariant 3). An encoder's output is a pure function of its input and its parameters, and a
//! decoder's output and verdict are a pure function of its input, byte-identical across hosts and
//! build modes. That holds only while no code under `src/` reads the time or draws a random number.
//!
//! Over every `.zig` file under `src/`, the rule flags a chain that starts with `std.time`,
//! `std.Random` or `std.crypto.random` at a dot boundary. `std.time` is flagged whole, its unit
//! constants included: a codec has no use for a duration.
//!
//! What the rule cannot see: a pointer value turned into an integer, or uninitialised memory read.
//! Neither is a name in `std`. Invariant 10 covers the second for history reads, and invariant
//! 5's check covers what escapes both: the hashes of every encoder's output, committed and compared
//! across hosts and build modes from the first encoder on (docs/design.md §8).
//!
//! The rule is pepegrillo's `forbidden_references` (decision 7). This file holds stdx's
//! configuration of it and the fixtures that pin that configuration.

const std = @import("std");
const pepegrillo = @import("pepegrillo");
const lint = pepegrillo.lint;
const forbidden_references = lint.rules.forbidden_references;

/// A chain that starts with one of these at a dot boundary is a finding: the clock, the general
/// pseudo-random generator, and the system entropy source.
const forbidden_prefixes = [_][]const u8{ "std.time", "std.Random", "std.crypto.random" };

/// The configuration. It reads every file under `src/`.
pub const config: forbidden_references.Config = .{
    .name = "determinism",
    .scope = .{ .extensions = &.{lint.paths.zig_extension}, .include_directories = &.{"src"} },
    .prefixes = &forbidden_prefixes,
    .reason = "a codec reads no clock and no randomness (decision 5, invariant 3)",
};

const Rule = forbidden_references.Rule(config);
pub const name = Rule.name;
pub const check = Rule.check;

// Tests. Each fixture pins one shape from the header.

const testing = std.testing;
const harness = lint.harness;

const reason = "a codec reads no clock and no randomness (decision 5, invariant 3)";

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
    \\/// The hash of four input octets, the same on every host.
    \\pub fn hash(octets: u32) u32 {
    \\    return (octets *% constants.hash_multiplier) >> constants.hash_shift;
    \\}
;

const failing_fixture: [:0]const u8 =
    \\const std = @import("std");
    \\
    \\pub fn seed(self: *Encoder) void {
    \\    self.started_ns = std.time.nanoTimestamp();
    \\    self.budget_ns = 3 * std.time.ns_per_ms;
    \\    self.salt = std.crypto.random.int(u64);
    \\    var generator = std.Random.DefaultPrng.init(0);
    \\    self.jitter = generator.random().int(u8);
    \\}
;

test "determinism passes a file that computes from its input alone" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/deflate/match.zig", passing_fixture);
    try harness.expect_messages(findings, &.{});
}

test "determinism flags the clock, the unit constants, the PRNG and the entropy source" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/deflate/match.zig", failing_fixture);
    try harness.expect_messages(findings, &.{
        "reference to std.time.nanoTimestamp: " ++ reason,
        "reference to std.time.ns_per_ms: " ++ reason,
        "reference to std.crypto.random.int: " ++ reason,
        "reference to std.Random.DefaultPrng.init: " ++ reason,
    });
    try testing.expectEqual(4, findings[0].line);
    try testing.expectEqual(7, findings[3].line);
}

test "determinism does not flag a name that merely resembles one on the list" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/zstd/zstd.zig",
        \\const timeout = constants.times_max;
        \\const hash = std.crypto.hash.sha2.Sha256;
        \\const times = self.repeat_times;
    );
    try harness.expect_messages(findings, &.{});
}

test "determinism reads src/ alone" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    try testing.expect(config.scope.applies("src/zstd/zstd.zig"));
    try testing.expect(!config.scope.applies("tools/lint/main.zig"));
    try testing.expect(!config.scope.applies("docs/design.md"));
    try harness.expect_messages(try findings_of(arena, "tools/graph_check.zig", failing_fixture), &.{});
}
