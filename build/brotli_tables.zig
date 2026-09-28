//! RFC 7932's appendices as the brotli module's data (design §8 step 12, claim B1).
//! `zig build brotli-tables` writes src/brotli/dictionary.bin and src/brotli/rfc_tables.zig
//! from docs/rfcs/rfc7932.txt with tools/brotli_tables.zig, and `zig build brotli-tables-check`,
//! part of `zig build test`, requires the committed files to equal what the tool writes.
const std = @import("std");

const rfc = "docs/rfcs/rfc7932.txt";
const dictionary = "src/brotli/dictionary.bin";
const rfc_tables = "src/brotli/rfc_tables.zig";

pub fn add(b: *std.Build, tool_module: *std.Build.Module) *std.Build.Step {
    const tool = b.addExecutable(.{ .name = "brotli_tables", .root_module = tool_module });

    const write = b.addRunArtifact(tool);
    write.addFileArg(b.path(rfc));
    write.addArgs(&.{ b.pathFromRoot(dictionary), b.pathFromRoot(rfc_tables) });
    write.has_side_effects = true;
    b.step("brotli-tables", "Write brotli's dictionary and transformations from RFC 7932").dependOn(&write.step);

    const check = b.addRunArtifact(tool);
    check.addArg("--check");
    check.addFileArg(b.path(rfc));
    check.addFileArg(b.path(dictionary));
    check.addFileArg(b.path(rfc_tables));
    const step = b.step(
        "brotli-tables-check",
        "Require brotli's dictionary and transformations to equal what RFC 7932 gives",
    );
    step.dependOn(&check.step);
    return step;
}
