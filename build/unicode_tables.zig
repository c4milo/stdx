//! Unicode 17.0.0's tables as the unicode module's data (design §8 part 22e). `zig build
//! unicode-tables` writes src/unicode/unicode_tables.zig from the data files of tools/unicode/ucd/
//! with tools/unicode/unicode_tables.zig, and `zig build unicode-tables-check`, part of `zig build
//! test`, requires the committed file to equal what the tool writes.
const std = @import("std");

/// The data files, in the order the tool reads them.
const data_files = [_][]const u8{
    "tools/unicode/ucd/CaseFolding.txt",
    "tools/unicode/ucd/DerivedGeneralCategory.txt",
    "tools/unicode/ucd/PropertyValueAliases.txt",
    "tools/unicode/ucd/Scripts.txt",
};
const tables = "src/unicode/unicode_tables.zig";

pub fn add(b: *std.Build, tool_module: *std.Build.Module) *std.Build.Step {
    const tool = b.addExecutable(.{ .name = "unicode_tables", .root_module = tool_module });

    const write = b.addRunArtifact(tool);
    for (data_files) |file| write.addFileArg(b.path(file));
    write.addArg(b.pathFromRoot(tables));
    write.has_side_effects = true;
    b.step("unicode-tables", "Write the unicode module's tables from Unicode 17.0.0's data files").dependOn(&write.step);

    const check = b.addRunArtifact(tool);
    check.addArg("--check");
    for (data_files) |file| check.addFileArg(b.path(file));
    check.addFileArg(b.path(tables));
    const step = b.step(
        "unicode-tables-check",
        "Require the unicode module's tables to equal what Unicode 17.0.0's data files give",
    );
    step.dependOn(&check.step);
    return step;
}
