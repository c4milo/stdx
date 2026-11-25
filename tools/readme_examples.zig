//! readme_examples: holds the READMEs' Zig code to the program `zig build readme-check` builds and
//! runs, `tools/consumer/`. Every ```zig block of README.md, and of the README in each module's
//! folder, must be an excerpt of `tools/consumer/build.zig` or `tools/consumer/main.zig`: each of
//! its lines, blank lines aside, is a line of that file, word for word and in the same order.
//! Indentation is not compared, because a block can show two lines of a function without the
//! function around them. A block may leave lines out, and it may not add one. So a README can
//! shorten a program that works, and it cannot show code that no longer compiles or no longer does
//! what the program checks.
//!
//! The README is an index (decision 88): it links the README of each module's folder, and each
//! module that the module `stdx` names has one. The tests below hold both.
//!
//! The build gives the test each file as an anonymous import, so a change to any of them runs the
//! test again. `build/readme.zig` names the same files.
const std = @import("std");

/// One file the test reads: its path in the tree, and its text.
const Document = struct { name: []const u8, text: []const u8 };

const readme: Document = .{ .name = "README.md", .text = @embedFile("README.md") };

/// The README of each module's folder, by the path that the README links.
const module_readmes = [_]Document{
    embedded("src/base64/README.md"),
    embedded("src/brotli/README.md"),
    embedded("src/checksum/README.md"),
    embedded("src/codec/README.md"),
    embedded("src/deflate/README.md"),
    embedded("src/gzip/README.md"),
    embedded("src/json/README.md"),
    embedded("src/platform/README.md"),
    embedded("src/regex/README.md"),
    embedded("src/unicode/README.md"),
    embedded("src/utf8/README.md"),
    embedded("src/zlib/README.md"),
    embedded("src/zstd/README.md"),
};

/// The root of the module `stdx`, which names each module that a program imports through it.
const stdx_root = @embedFile("src/stdx/stdx.zig");

fn embedded(comptime name: []const u8) Document {
    return .{ .name = name, .text = @embedFile(name) };
}

/// The files a block of the README may be an excerpt of.
const programs = [_]Document{
    .{ .name = "tools/consumer/build.zig", .text = @embedFile("tools/consumer/build.zig") },
    .{ .name = "tools/consumer/main.zig", .text = @embedFile("tools/consumer/main.zig") },
};

/// The Zig blocks the README holds at least: the lines of `build.zig` and one example. A README
/// that lost them, or a fence this test no longer finds, would check nothing and pass.
const readme_blocks_min = 2;

/// The Zig blocks the README of a module's folder holds at least: one example.
const module_blocks_min = 1;

/// The modules the module `stdx` names at least. A reader of its root that found no import would
/// check no module and pass.
const stdx_modules_min = 12;

/// The longest path of a README, and the longest link to one.
const path_len_max = 64;

const import_open = "@import(\"";
const comment_open = "//";
const zig_standard_library = "std";

const fence_open = "```zig\n";
const fence_close = "```";

/// True when every line of `block` that is not blank is a line of `program`, in the same order,
/// once the spaces around each line are set aside.
fn is_excerpt(block: []const u8, program: []const u8) bool {
    var lines = std.mem.splitScalar(u8, program, '\n');
    var wanted = std.mem.splitScalar(u8, block, '\n');
    next_wanted: while (wanted.next()) |line| {
        const text = std.mem.trim(u8, line, " ");
        if (text.len == 0) continue;
        while (lines.next()) |candidate| {
            if (std.mem.eql(u8, std.mem.trim(u8, candidate, " "), text)) continue :next_wanted;
        }
        return false;
    }
    return true;
}

/// The name of the program `block` is an excerpt of, or null when it is an excerpt of none.
fn source_of(block: []const u8) ?[]const u8 {
    for (programs) |program| {
        if (is_excerpt(block, program.text)) return program.name;
    }
    return null;
}

/// The length of the block that starts at `text`: the offset of the line feed before its closing
/// fence, which is the first line that holds the fence alone, whatever its indentation.
fn block_len(text: []const u8) ?usize {
    var offset: usize = 0;
    var lines = std.mem.splitScalar(u8, text, '\n');
    while (lines.next()) |line| {
        if (std.mem.eql(u8, std.mem.trim(u8, line, " "), fence_close)) return offset -| 1;
        offset += line.len + 1;
    }
    return null;
}

/// What a document's Zig blocks gave: how many it holds, and the first that is an excerpt of no
/// program, if one is.
const Report = struct { checked: u32, foreign: ?[]const u8 };

/// Checks every Zig block of `document`, up to the first that is an excerpt of no program.
fn check_document(document: Document) error{UnclosedBlock}!Report {
    var report: Report = .{ .checked = 0, .foreign = null };
    var rest = document.text;
    while (std.mem.indexOf(u8, rest, fence_open)) |open| {
        const start = open + fence_open.len;
        const len = block_len(rest[start..]) orelse return error.UnclosedBlock;
        const block = rest[start .. start + len];
        if (source_of(block) == null) {
            report.foreign = block;
            return report;
        }
        report.checked += 1;
        rest = rest[start + len ..];
    }
    return report;
}

/// Requires every Zig block of `checked` to be an excerpt of a program, and `blocks_min` of them
/// at least. Returns how many it holds.
fn expect_excerpts(checked: Document, blocks_min: u32) !u32 {
    const report = try check_document(checked);
    if (report.foreign) |block| {
        std.debug.print("{s}: this block is not an excerpt of tools/consumer/:\n{s}\n", .{ checked.name, block });
        return error.BlockMatchesNoProgram;
    }
    try std.testing.expect(report.checked >= blocks_min);
    return report.checked;
}

/// The name of the module that the first `@import` of `text` names, and the text after it, or
/// null where `text` holds no import.
fn next_import(text: []const u8) ?struct { name: []const u8, rest: []const u8 } {
    const open = std.mem.indexOf(u8, text, import_open) orelse return null;
    const start = open + import_open.len;
    const len = std.mem.indexOfScalar(u8, text[start..], '"') orelse return null;
    return .{ .name = text[start .. start + len], .rest = text[start + len ..] };
}

/// True when `module_readmes` holds the README of the folder `src/<module>`.
fn has_readme(module: []const u8) bool {
    var buffer: [path_len_max]u8 = undefined;
    const path = std.fmt.bufPrint(&buffer, "src/{s}/README.md", .{module}) catch return false;
    for (module_readmes) |module_readme| {
        if (std.mem.eql(u8, module_readme.name, path)) return true;
    }
    return false;
}

test "every Zig block of each README is an excerpt of the program that builds and runs" {
    var blocks = try expect_excerpts(readme, readme_blocks_min);
    for (module_readmes) |module_readme| blocks += try expect_excerpts(module_readme, module_blocks_min);
    // A loop that read no module's README would pass each of them.
    try std.testing.expect(blocks >= readme_blocks_min + module_readmes.len * module_blocks_min);
}

test "the README links the README of each module's folder" {
    for (module_readmes) |module_readme| {
        var buffer: [path_len_max]u8 = undefined;
        const link = try std.fmt.bufPrint(&buffer, "]({s})", .{module_readme.name});
        if (std.mem.indexOf(u8, readme.text, link) == null) {
            std.debug.print("{s} holds no link to {s}\n", .{ readme.name, module_readme.name });
            return error.ReadmeLinksNoModule;
        }
    }
}

test "each module that the module stdx names has a README in its folder" {
    var modules: u32 = 0;
    var lines = std.mem.splitScalar(u8, stdx_root, '\n');
    while (lines.next()) |line| {
        // A comment's example imports no module.
        if (std.mem.startsWith(u8, std.mem.trim(u8, line, " "), comment_open)) continue;
        const import = next_import(line) orelse continue;
        if (std.mem.eql(u8, import.name, zig_standard_library)) continue;
        modules += 1;
        if (!has_readme(import.name)) {
            std.debug.print("src/{s}/ holds no README that this check reads\n", .{import.name});
            return error.ModuleHasNoReadme;
        }
    }
    try std.testing.expect(modules >= stdx_modules_min);
}

test "an import's name is read from between its quotes, one import after another" {
    const first = next_import("const a = @import(\"gzip\"); const b = @import(\"std\");").?;
    try std.testing.expectEqualStrings("gzip", first.name);
    try std.testing.expectEqualStrings("std", next_import(first.rest).?.name);
    try std.testing.expect(next_import(next_import(first.rest).?.rest) == null);
    try std.testing.expect(has_readme("gzip"));
    try std.testing.expect(!has_readme("gzi"));
    try std.testing.expect(!has_readme("no_such_module"));
}

test "an excerpt keeps the order of its lines and adds none" {
    const program = "a\nb\nc\nd\n";
    try std.testing.expect(is_excerpt("a\n\nc", program));
    try std.testing.expect(is_excerpt("b\nd", program));
    try std.testing.expect(!is_excerpt("c\na", program));
    try std.testing.expect(!is_excerpt("a\ne", program));
    // A line matches whole: the start of a line is not that line.
    try std.testing.expect(!is_excerpt("a\nx", "a\nxy\n"));
    // Indentation is set aside.
    try std.testing.expect(is_excerpt("  b\nc", "a\n    b\n c\n"));
}

test "a block that is no excerpt, or one with no closing fence, fails the document" {
    const added: Document = .{ .name = "added", .text = "text\n```zig\nconst added = 1;\n```\n" };
    try std.testing.expectEqualStrings("const added = 1;", (try check_document(added)).foreign.?);
    const unclosed: Document = .{ .name = "unclosed", .text = "```zig\nconst std = @import(\"std\");\n" };
    try std.testing.expectError(error.UnclosedBlock, check_document(unclosed));
    const shown: Document = .{ .name = "shown", .text = "```zig\nconst std = @import(\"std\");\n```\n" };
    const report = try check_document(shown);
    try std.testing.expectEqual(@as(u32, 1), report.checked);
    try std.testing.expectEqual(@as(?[]const u8, null), report.foreign);
}
