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
//! `src/platform/` is the one exception (decision 40). A program calls its probe once, when it
//! starts, and no codec path runs it, so it may make the one syscall it needs: macOS's
//! `sysctlbyname`. The rule reads that directory under a configuration of its own, which allows
//! that call beside `getauxval` and refuses every other chain the list names, so the probe still
//! opens no file, starts no thread and prints nothing. No other module can reach the probe: the
//! module graph gives none of them `platform` (invariant 14).
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

/// The one call under a forbidden prefix that reaches no host: `getauxval` reads the auxiliary
/// vector the kernel wrote into the process's memory at start, with no syscall. Zig's reader,
/// `std.os.linux.getauxval`, and libc's, `std.c.getauxval`, read the same memory; a program that
/// links libc has only libc's filled. `codec.Features.detect` and `platform.probe` read the CPU's
/// features from it on aarch64 Linux (decisions 21 and 40).
const exceptions = [_]forbidden_references.Exception{
    .{ .prefix = "std.os.linux", .last_segment_prefixes = &.{"getauxval"} },
    .{ .prefix = "std.c", .last_segment_prefixes = &.{"getauxval"} },
};

/// The one directory under `src/` that may make a syscall: the `platform` module (decision 40).
const platform_directory = "src/platform";

/// The calls `platform` may make beside `getauxval`: `sysctlbyname`, libc's reader of a macOS
/// sysctl value, which is a syscall.
const platform_exceptions = exceptions ++ [_]forbidden_references.Exception{
    .{ .prefix = "std.c", .last_segment_prefixes = &.{"sysctlbyname"} },
};

/// The configuration of every module but `platform`. It reads every other file under `src/`:
/// stdx has no test-only endpoint, so no other directory is exempt.
pub const config: forbidden_references.Config = .{
    .name = "io",
    .scope = .{
        .extensions = &.{lint.paths.zig_extension},
        .include_directories = &.{"src"},
        .exclude_directories = &.{platform_directory},
    },
    .prefixes = &forbidden_prefixes,
    .exceptions = &exceptions,
    .reason = "stdx owns no I/O (decision 2, invariant 2)",
};

/// The configuration of `platform`: the same list, with `sysctlbyname` allowed.
pub const platform_config: forbidden_references.Config = .{
    .name = config.name,
    .scope = .{ .extensions = &.{lint.paths.zig_extension}, .include_directories = &.{platform_directory} },
    .prefixes = &forbidden_prefixes,
    .exceptions = &platform_exceptions,
    .reason = "platform reads the CPU and nothing else (decision 40, invariant 2)",
};

const Rule = forbidden_references.Rule(config);
const PlatformRule = forbidden_references.Rule(platform_config);
pub const name = Rule.name;

/// Both configurations, under the one name. Their scopes do not overlap, so each file is read
/// under one of them.
pub fn check(context: *lint.report.Context, file: lint.report.File) !void {
    try Rule.check(context, file);
    try PlatformRule.check(context, file);
}

// Tests. Each fixture pins one shape from the header.

const testing = std.testing;
const harness = lint.harness;

const module_graph = @import("module_graph.zig");

const reason = "stdx owns no I/O (decision 2, invariant 2)";
const platform_reason = "platform reads the CPU and nothing else (decision 40, invariant 2)";

fn findings_of(
    arena: std.mem.Allocator,
    path: []const u8,
    source: [:0]const u8,
) ![]const lint.report.Finding {
    return harness.run(arena, @This(), path, source);
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

test "io allows getauxval, which reads memory, and nothing else under std.os or std.c" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const findings = try findings_of(arena_state.allocator(), "src/codec/features.zig",
        \\const word = std.os.linux.getauxval(std.elf.AT_HWCAP);
        \\const libc_word = std.c.getauxval(std.elf.AT_HWCAP);
        \\const pid = std.os.linux.getpid();
        \\const libc_pid = std.c.getpid();
    );
    try harness.expect_messages(findings, &.{
        "reference to std.os.linux.getpid: " ++ reason,
        "reference to std.c.getpid: " ++ reason,
    });
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

/// A syscall, then the reader of the auxiliary vector, then a file, a libc call, a print and a
/// thread: what the probe of `platform` might be tempted to reach.
const syscall_fixture: [:0]const u8 =
    \\const found = std.c.sysctlbyname("hw.optional.arm.FEAT_AES", &value, &value_len, null, 0);
    \\const word = std.os.linux.getauxval(std.elf.AT_HWCAP);
    \\const info = try std.fs.cwd().openFile("/proc/cpuinfo", .{});
    \\const descriptor = std.c.open("/proc/cpuinfo", 0);
    \\const shown = std.debug.print("{}\n", .{value});
    \\const worker = std.Thread.spawn;
;

test "io refuses sysctlbyname in every module but platform" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    var modules_read: usize = 0;
    for (module_graph.expected_graph) |module| {
        if (std.mem.eql(u8, module.name, "platform")) continue;
        const path = try std.fmt.allocPrint(arena, "src/{s}/{s}.zig", .{ module.name, module.name });
        try harness.expect_messages(try findings_of(arena, path, syscall_fixture), &.{
            "reference to std.c.sysctlbyname: " ++ reason,
            "reference to std.fs.cwd: " ++ reason,
            "reference to std.c.open: " ++ reason,
            "reference to std.debug.print: " ++ reason,
            "reference to std.Thread.spawn: " ++ reason,
        });
        modules_read += 1;
    }
    try testing.expectEqual(module_graph.expected_graph.len - 1, modules_read);
    // A file named for the platform outside its directory is another module's.
    const outside = try findings_of(arena, "src/json/platform.zig", syscall_fixture);
    try testing.expectEqualStrings("reference to std.c.sysctlbyname: " ++ reason, outside[0].message);
}

test "io allows platform sysctlbyname and getauxval, and refuses everything else there" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    for ([_][]const u8{ "src/platform/platform.zig", "./src/platform/deep/cpu.zig" }) |path| {
        try harness.expect_messages(try findings_of(arena, path, syscall_fixture), &.{
            "reference to std.fs.cwd: " ++ platform_reason,
            "reference to std.c.open: " ++ platform_reason,
            "reference to std.debug.print: " ++ platform_reason,
            "reference to std.Thread.spawn: " ++ platform_reason,
        });
    }
    try testing.expect(!config.scope.applies("src/platform/platform.zig"));
    try testing.expect(platform_config.scope.applies("src/platform/platform.zig"));
    try testing.expect(!platform_config.scope.applies("src/codec/features.zig"));
}
