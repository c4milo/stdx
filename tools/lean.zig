//! stdx's Lean proofs (decision 28), built by pepegrillo's lake runner. The project is spec/lean/.
//! After the proofs build, the vector files the proved machines give are checked against the
//! committed ones under src/json/, which the Zig unit tests replay against the Zig machines.
//!
//! Run: `zig build lean`, or `zig build lean -- write` to rewrite the vector files.

const std = @import("std");
const pepegrillo = @import("pepegrillo");

/// The Lean project, from the repository's root. It pins its release in `lean-toolchain`.
const directory = "spec/lean";
/// The directory of the vector files, from the Lean project, where lake runs.
const vector_directory = "../../src/json";

const proofs: pepegrillo.lean.Config = .{ .directory = directory };
const check_vectors: pepegrillo.lean.Config = .{
    .directory = directory,
    .lake_arguments = &.{ "exe", "vectors", "--check", vector_directory },
};
const write_vectors: pepegrillo.lean.Config = .{
    .directory = directory,
    .lake_arguments = &.{ "exe", "vectors", "--write", vector_directory },
};

const exit_usage: u8 = 2;

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const arguments = try init.minimal.args.toSlice(arena);
    const write = arguments.len == 2 and std.mem.eql(u8, arguments[1], "write");
    if (arguments.len > 2 or (arguments.len == 2 and !write)) {
        std.debug.print("usage: lean [write]\n", .{});
        std.process.exit(exit_usage);
    }
    var error_buffer: [std.heap.page_size_min]u8 = undefined;
    var errors = std.Io.File.stderr().writerStreaming(init.io, &error_buffer);
    defer errors.interface.flush() catch {};
    const built = try pepegrillo.lean.run(arena, init.io, init.environ_map, proofs, &errors.interface);
    if (built != 0) std.process.exit(built);
    const vectors = if (write)
        try pepegrillo.lean.run(arena, init.io, init.environ_map, write_vectors, &errors.interface)
    else
        try pepegrillo.lean.run(arena, init.io, init.environ_map, check_vectors, &errors.interface);
    errors.interface.flush() catch {};
    std.process.exit(vectors);
}
