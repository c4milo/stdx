//! io: stdx owns no I/O (CLAUDE.md, Non-negotiables; decision 2; invariant 2). A codec reads
//! octets the caller already has and writes into storage the caller owns. It opens no file or
//! socket, starts no thread, and makes no syscall.
//!
//! Over every `.zig` file under `src/`, the rule flags a chain that starts with one of
//! `forbidden_prefixes` at a dot boundary: the syscall surface (`std.posix`, `std.os`, `std.c`),
//! the filesystem, the network, threads, the `std.Io` interface every blocking call takes, the
//! process table, and the two ways to write to standard error, `std.log` and `std.debug.print`.
//! `std.debug.assert` stays allowed: it is on the list of neither.
//!
//! The rule reads what a file names, not what it reaches. A module that received another module
//! from build/modules.zig can call through it, and this rule cannot see where that call ends up.
//! The module graph bounds that, and no library module receives a package (invariant 14).
//!
//! The rule is pepegrillo's `forbidden_references` (decision 7). This file holds stdx's
//! configuration of it and the fixtures that pin that configuration.

const std = @import("std");
const pepegrillo = @import("pepegrillo");
const lint = pepegrillo.lint;
const forbidden_references = lint.rules.forbidden_references;

/// A chain that starts with one of these at a dot boundary is a finding. Each names a way to
/// reach the host.
const forbidden_prefixes = [_][]const u8{
    "std.posix",
    "std.os",
    "std.c",
    "std.fs",
    "std.net",
    "std.Thread",
    "std.Io",
    "std.process",
    "std.log",
    "std.debug.print",
};

/// The one call under a forbidden prefix that reaches no host: `std.os.linux.getauxval` reads the
/// auxiliary vector the kernel wrote into the process's memory at start, with no syscall.
/// `codec.Features.detect` reads the CPU's features from it on aarch64 Linux (decision 21).
const exceptions = [_]forbidden_references.Exception{
    .{ .prefix = "std.os.linux", .last_segment_prefixes = &.{"getauxval"} },
};

/// The configuration. It reads every file under `src/`: stdx has no test-only endpoint, so no
/// directory is exempt.
pub const config: forbidden_references.Config = .{
    .name = "io",
    .scope = .{ .extensions = &.{lint.paths.zig_extension}, .include_directories = &.{"src"} },
    .prefixes = &forbidden_prefixes,
    .exceptions = &exceptions,
    .reason = "stdx owns no I/O (decision 2, invariant 2)",
};

const Rule = forbidden_references.Rule(config);
pub const name = Rule.name;
pub const check = Rule.check;

// Tests. Each fixture pins one shape from the header.

const testing = std.testing;
const harness = lint.harness;

const reason = "stdx owns no I/O (decision 2, invariant 2)";

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
    \\
    \\/// Reads a stored block's length out of octets the caller has already read.
    \\pub fn read_length(input: []const u8) !u16 {
    \\    if (input.len < 2) return error.Truncated;
    \\    std.debug.assert(input.len >= 2);
    \\    return std.mem.readInt(u16, input[0..2], .little);
    \\}
;

const failing_fixture: [:0]const u8 =
    \\const std = @import("std");
    \\
    \\pub fn decode_file(path: []const u8) !void {
    \\    const file = try std.fs.cwd().openFile(path, .{});
    \\    const thread = try std.Thread.spawn(.{}, run, .{file});
    \\    thread.join();
    \\    std.debug.print("done\n", .{});
    \\}
;

test "io passes a file that decodes octets the caller read" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/deflate/stored.zig", passing_fixture);
    try harness.expect_messages(findings, &.{});
}

test "io flags the filesystem, a thread and a print" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/deflate/stored.zig", failing_fixture);
    try harness.expect_messages(findings, &.{
        "reference to std.fs.cwd: " ++ reason,
        "reference to std.Thread.spawn: " ++ reason,
        "reference to std.debug.print: " ++ reason,
    });
    try testing.expectEqual(4, findings[0].line);
}

test "io flags every prefix on its list, in a parameter type as well as a body" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/zstd/zstd.zig",
        \\fn send(socket: std.posix.socket_t, file: std.fs.File, count: u32) void {}
        \\const reader = std.Io.Reader;
        \\const argv = std.process.args;
        \\const listener = std.net.Server;
        \\const worker = std.Thread;
        \\const system = std.os.linux;
        \\const libc = std.c.write;
        \\const logger = std.log.scoped;
    );
    try harness.expect_messages(findings, &.{
        "reference to std.posix.socket_t: " ++ reason,
        "reference to std.fs.File: " ++ reason,
        "reference to std.Io.Reader: " ++ reason,
        "reference to std.process.args: " ++ reason,
        "reference to std.net.Server: " ++ reason,
        "reference to std.Thread: " ++ reason,
        "reference to std.os.linux: " ++ reason,
        "reference to std.c.write: " ++ reason,
        "reference to std.log.scoped: " ++ reason,
    });
}

test "io allows getauxval, which reads memory, and nothing else under std.os" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/codec/features.zig",
        \\const word = std.os.linux.getauxval(std.elf.AT_HWCAP);
        \\const pid = std.os.linux.getpid();
    );
    try harness.expect_messages(findings, &.{"reference to std.os.linux.getpid: " ++ reason});
}

test "io does not flag a name that merely starts with the same letters" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/zstd/zstd.zig",
        \\const bytes = constants.std_posix_bytes;
        \\const hash = std.crypto.hash.sha2.Sha256;
        \\const order = std.mem.readInt(u32, bytes[0..4], .big);
        \\const check = std.debug.assert;
    );
    try harness.expect_messages(findings, &.{});
}

test "io reads src/ and nothing outside it" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    try testing.expect(config.scope.applies("src/zstd/zstd.zig"));
    try testing.expect(config.scope.applies("./src/codec/deep/reader.zig"));
    try testing.expect(!config.scope.applies("tools/lint/main.zig"));
    try testing.expect(!config.scope.applies("build/modules.zig"));
    try harness.expect_messages(try findings_of(arena, "tools/graph_check.zig", failing_fixture), &.{});
}
