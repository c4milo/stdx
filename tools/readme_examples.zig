//! readme_examples: holds the README's Zig code to the program `zig build readme-check` builds and
//! runs, `tools/consumer/`. Every ```zig block of README.md must be an excerpt of
//! `tools/consumer/build.zig` or `tools/consumer/main.zig`: each of its lines, blank lines aside, is
//! a line of that file, word for word and in the same order. Indentation is not compared, because a
//! block can show two lines of a function without the function around them. A block may leave
//! lines out, and it may not add one. So the README can shorten a program that works, and it cannot
//! show code that no longer compiles or no longer does what the program checks.
//!
//! The build gives the test each file as an anonymous import, so a change to any of them runs the
//! test again.
const std = @import("std");

/// One file the test reads: its path in the tree, and its text.
const Document = struct { name: []const u8, text: []const u8 };

const readme: Document = .{ .name = "README.md", .text = @embedFile("README.md") };

/// The files a block of the README may be an excerpt of.
const programs = [_]Document{
    .{ .name = "tools/consumer/build.zig", .text = @embedFile("tools/consumer/build.zig") },
    .{ .name = "tools/consumer/main.zig", .text = @embedFile("tools/consumer/main.zig") },
};

/// The Zig blocks the README holds at least: the lines of `build.zig`, the gzip example and the
/// regex example. A README that lost them, or a fence this test no longer finds, would check
/// nothing and pass.
const readme_blocks_min = 3;

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

test "every Zig block of the README is an excerpt of the program that builds and runs" {
    const report = try check_document(readme);
    if (report.foreign) |block| {
        std.debug.print("{s}: this block is not an excerpt of tools/consumer/:\n{s}\n", .{ readme.name, block });
        return error.BlockMatchesNoProgram;
    }
    try std.testing.expect(report.checked >= readme_blocks_min);
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
