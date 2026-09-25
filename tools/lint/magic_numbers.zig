//! magic-numbers: every limit is named in a constant and never written inline (CLAUDE.md,
//! Non-negotiables).
//!
//! Over every `.zig` file under `src/`, the rule reports an integer literal greater than 1 unless
//! it is the whole value of a `const` declaration or a container field, which names it. `test` and
//! `comptime` blocks are not read: a test states the numbers it checks, and a layout assert checks
//! a number rather than using one as a limit. A fuzz property function is not a `test` block, so
//! its input size is named at file level.
//!
//! `constants.zig` is not read, because it is where the names live. A table generated from an RFC,
//! such as RFC 1951 §3.2.6's fixed code lengths or RFC 7932 Appendix A's dictionary, will join the
//! exclusions in the commit that adds its generator, named file by file.
//!
//! The width of an octet is `@bitSizeOf(u8)`, never 8, so a shift by a whole octet names what it
//! shifts by.
//!
//! The rule is pepegrillo's `magic_numbers` (decision 7). This file holds stdx's configuration of
//! it and the fixtures that pin that configuration.

const std = @import("std");
const pepegrillo = @import("pepegrillo");
const lint = pepegrillo.lint;
const magic_numbers = lint.rules.magic_numbers;

/// The configuration: `.zig` files under `src/`, but for each module's `constants.zig`.
pub const config: magic_numbers.Config = .{
    .scope = .{
        .extensions = &.{lint.paths.zig_extension},
        .include_directories = &.{"src"},
        .exclude_basenames = &.{"constants.zig"},
    },
};

const Rule = magic_numbers.Rule(config);
pub const name = Rule.name;
pub const check = Rule.check;

// Tests. Each fixture pins one shape from the header.

const testing = std.testing;
const harness = lint.harness;

fn expect_findings(path: []const u8, source: [:0]const u8, expected: []const []const u8) !void {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try harness.run(arena_state.allocator(), Rule, path, source);
    try harness.expect_messages(findings, expected);
}

const failing_fixture: [:0]const u8 =
    \\pub fn read_length(octets: []const u8) u32 {
    \\    var value: u32 = 0;
    \\    for (octets) |octet| value = (value << 8) | octet;
    \\    var buffer: [258]u8 = @splat(0);
    \\    _ = &buffer;
    \\    return value;
    \\}
;

test "magic-numbers passes named constants, the octet width, tests and comptime asserts" {
    try expect_findings("src/deflate/stored.zig",
        \\const length_bits = 2;
        \\const fuzz_input_len_max = 32;
        \\pub fn read_length(octets: []const u8) u32 {
        \\    var value: u32 = 0;
        \\    for (octets) |octet| value = (value << @bitSizeOf(u8)) | octet;
        \\    var buffer: [fuzz_input_len_max]u8 = @splat(0);
        \\    _ = &buffer;
        \\    comptime std.debug.assert(length_bits * 4 == 8);
        \\    return value + 1;
        \\}
        \\test "eight" {
        \\    try std.testing.expectEqual(8, read_length(&.{ 0, 8 }));
        \\}
    , &.{});
}

test "magic-numbers flags an inline shift width and an inline array length" {
    try expect_findings("src/deflate/stored.zig", failing_fixture, &.{
        "integer literal 8",
        "integer literal 258",
    });
}

test "magic-numbers reads src/ but not its constants" {
    try expect_findings("src/zstd/zstd.zig", failing_fixture, &.{
        "integer literal 8",
        "integer literal 258",
    });
    try expect_findings("src/deflate/constants.zig", failing_fixture, &.{});
    try expect_findings("src/zstd/constants.zig", failing_fixture, &.{});
    try expect_findings("tools/graph_check.zig", failing_fixture, &.{});
    try expect_findings("build/modules.zig", failing_fixture, &.{});
}
