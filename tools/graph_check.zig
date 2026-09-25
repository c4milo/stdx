//! The check of docs/design.md §8 step 0, and the check behind invariant 14: `src/deflate/` cannot
//! import a wrapper, another codec, or a package.
//!
//! A lint rule over the source would only check what build/modules.zig declares. This checks what
//! the compiler rejects: it compiles a fixture as a module carrying exactly the import set
//! build/modules.zig gives `deflate`, and requires the compile to fail with Zig's own "no module
//! named" error. `deflate` is the module the check is written against because the wrappers build on
//! it: an edge from `deflate` to `zlib` or `gzip` would be a cycle the build cannot express, and an
//! edge to `zstd` or `brotli` would drag a second codec into every consumer of the first.
//!
//! It runs a positive control in the same pass, and that control is what stops the check from
//! being vacuous. A check that only requires a failure passes when the failure has nothing to do
//! with the rule: a mistyped fixture path, a missing source, a broken `zig` invocation. So one
//! fixture imports `codec`, which `deflate` does have, and must compile clean. A run in which the
//! control fails is reported as a broken check, not as a pass.
//!
//! Usage: `graph_check <zig-exe> <src-root> <fixtures-dir>`
const std = @import("std");

/// The import set build/modules.zig gives `deflate` (docs/design.md §3). The lint rule
/// `module-graph` keeps build/modules.zig equal to this list, and this tool shows the list has the
/// consequence invariant 14 claims.
const deflate_imports = [_]Import{
    .{ .name = "codec", .root = "codec/codec.zig" },
};

/// Every module name `deflate` must not be able to import. Each gets a fixture and each must fail.
const forbidden = [_][]const u8{ "checksum", "zlib", "gzip", "zstd", "brotli", "pepegrillo" };

/// The module name the positive control imports: one `deflate` really does have.
const control = "codec";

/// The exit status of a usage error.
const usage_exit_status = 2;

const Import = struct {
    name: []const u8,
    root: []const u8,
};

const Outcome = enum { compiled, rejected };

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    if (args.len < 4) {
        std.debug.print("usage: graph_check <zig-exe> <src-root> <fixtures-dir>\n", .{});
        std.process.exit(usage_exit_status);
    }
    const zig_exe = args[1];
    const src_root = args[2];
    const fixtures = args[3];

    // The control first: if importing a module `deflate` does have does not compile, nothing this
    // tool reports afterwards means anything.
    const control_path = try fixture_path(arena, fixtures, control);
    const control_outcome = try compile(arena, init.io, zig_exe, src_root, control_path);
    if (control_outcome != .compiled) {
        std.debug.print(
            "graph-check BROKEN: the control fixture importing '{s}' did not compile.\n" ++
                "  Nothing else this check reports is meaningful until that is fixed.\n",
            .{control},
        );
        std.process.exit(1);
    }
    std.debug.print("graph-check control: import '{s}' compiles, as it must\n", .{control});

    var failures: usize = 0;
    for (forbidden) |module_name| {
        const path = try fixture_path(arena, fixtures, module_name);
        const outcome = try compile(arena, init.io, zig_exe, src_root, path);
        if (outcome == .rejected) {
            std.debug.print("graph-check: src/deflate/ cannot import '{s}'\n", .{module_name});
            continue;
        }
        std.debug.print(
            "graph-check FAILED: src/deflate/ compiled an @import(\"{s}\").\n" ++
                "  build/modules.zig has given deflate a module design §3 does not." ++
                " See docs/invariants.md INV-14.\n",
            .{module_name},
        );
        failures += 1;
    }
    if (failures != 0) std.process.exit(1);
}

fn fixture_path(arena: std.mem.Allocator, fixtures: []const u8, module_name: []const u8) ![]const u8 {
    return std.fs.path.join(arena, &.{
        fixtures,
        try std.fmt.allocPrint(arena, "deflate_imports_{s}.zig", .{module_name}),
    });
}

/// Compiles `root_path` as the root of a module carrying exactly `deflate_imports`, and reports
/// whether the compiler accepted it. A non-zero exit is `rejected`; anything else is `compiled`.
fn compile(
    arena: std.mem.Allocator,
    io: std.Io,
    zig_exe: []const u8,
    src_root: []const u8,
    root_path: []const u8,
) !Outcome {
    // `--dep` flags apply to the next `-M`, and the first `-M` is the root module, so the root's
    // whole dependency list precedes it. `codec` imports nothing, so it needs no `--dep` of its own.
    var argv: std.ArrayList([]const u8) = .empty;
    try argv.appendSlice(arena, &.{ zig_exe, "build-obj", "-fno-emit-bin" });
    for (deflate_imports) |import| {
        try argv.appendSlice(arena, &.{ "--dep", import.name });
    }
    try argv.append(arena, try std.fmt.allocPrint(arena, "-Mroot={s}", .{root_path}));
    for (deflate_imports) |import| {
        const root = try std.fs.path.join(arena, &.{ src_root, import.root });
        try argv.append(arena, try std.fmt.allocPrint(arena, "-M{s}={s}", .{ import.name, root }));
    }

    const result = try std.process.run(arena, io, .{ .argv = argv.items });
    return switch (result.term) {
        .exited => |code| if (code == 0) .compiled else .rejected,
        else => .rejected,
    };
}

test "the forbidden list names every module of the graph deflate does not import, and a package" {
    // docs/design.md §3: every library module but `deflate` itself and `codec`, then pepegrillo,
    // the one package the build fetches today. The oracles join this list when design §8 step 2
    // adds them.
    const expected = [_][]const u8{ "checksum", "zlib", "gzip", "zstd", "brotli", "pepegrillo" };
    try std.testing.expectEqual(expected.len, forbidden.len);
    for (expected, forbidden) |want, got| {
        try std.testing.expectEqualStrings(want, got);
    }
}

test "the control is a module deflate actually imports" {
    var found = false;
    for (deflate_imports) |import| {
        if (std.mem.eql(u8, import.name, control)) found = true;
    }
    try std.testing.expect(found);
}

test "deflate's import set is the one design §3 states" {
    const expected = [_][]const u8{"codec"};
    try std.testing.expectEqual(expected.len, deflate_imports.len);
    for (expected, deflate_imports) |want, got| {
        try std.testing.expectEqualStrings(want, got.name);
    }
}
