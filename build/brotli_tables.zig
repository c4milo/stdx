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

/// `zig build brotli-table-budget-check`, part of `zig build test`: tools/brotli_table_budget.zig
/// computes each lookup table's worst size and requires it to equal the budget constants.zig pins
/// (decision 12), and its own tests check its search against trying every code. `brotli` is the
/// library's brotli module built for this host, whose constants it reads.
pub fn add_budget_check(b: *std.Build, brotli: *std.Build.Module) *std.Build.Step {
    const module = b.createModule(.{
        .root_source_file = b.path("tools/brotli_table_budget.zig"),
        .target = b.graph.host,
        .optimize = .ReleaseFast,
    });
    module.addImport("brotli", brotli);
    const tool = b.addExecutable(.{ .name = "brotli_table_budget", .root_module = module });
    const run = b.addRunArtifact(tool);
    run.addArg("--check");
    const step = b.step(
        "brotli-table-budget-check",
        "Require brotli's pinned table budgets to equal the worst tables the tool finds",
    );
    step.dependOn(&run.step);
    step.dependOn(&b.addRunArtifact(b.addTest(.{ .root_module = module })).step);
    return step;
}
