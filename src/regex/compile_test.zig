//! `compile`'s tests: what a program holds, that it stands whole in its storage, and that the
//! storage a pattern takes is all it writes.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const compiler = @import("compile.zig");
const generate = @import("generate_test.zig");
const program_file = @import("program.zig");
const Instruction = program_file.Instruction;
const Program = program_file.Program;

const storage_len = 4096;

test "a program holds its forward half, then its reverse half, each ending in match" {
    var storage: [storage_len]Instruction = undefined;
    const program = try compiler.compile("abc", .{}, &storage);
    // Three ranges, the two slots of the whole match and `match`; then three ranges and `match`.
    try testing.expectEqual(@as(u32, 6), program.forward_len);
    try testing.expectEqual(@as(usize, 10), program.instructions.len);
    try testing.expectEqual(program_file.Kind.save, program.instructions[program.forward].kind);
    try testing.expectEqual(program_file.Kind.match, program.instructions[program.forward_len - 1].kind);
    try testing.expectEqual(program_file.Kind.match, program.instructions[program.instructions.len - 1].kind);
    // The reverse half starts with the pattern's last octet.
    try testing.expect(program.reverse >= program.forward_len);
    try testing.expectEqual(@as(u8, 'c'), program.instructions[program.reverse].lo);
    try testing.expectEqual(@as(u32, 1), program.group_count);
    try testing.expectEqual(@as(u32, constants.group_slots), program.slot_count());
}

test "a program compiled with no reverse half holds the forward half alone" {
    var storage: [storage_len]Instruction = undefined;
    const program = try compiler.compile("(a)(b)", .{ .reverse = false }, &storage);
    try testing.expectEqual(program.forward_len, program.instructions.len);
    try testing.expectEqual(program_file.no_entry, program.reverse);
    try testing.expectEqual(@as(u32, 3), program.group_count);
}

test "a program says whether it holds an assertion, and one that reads the octet ahead" {
    var storage: [storage_len]Instruction = undefined;
    const Expected = struct { pattern: []const u8, has_looks: bool, reads_ahead: bool };
    const expected = [_]Expected{
        .{ .pattern = "a.b", .has_looks = false, .reads_ahead = false },
        .{ .pattern = "^a", .has_looks = true, .reads_ahead = false },
        .{ .pattern = "\\Aa", .has_looks = true, .reads_ahead = false },
        .{ .pattern = "(?m)^a", .has_looks = true, .reads_ahead = false },
        .{ .pattern = "a$", .has_looks = true, .reads_ahead = true },
        .{ .pattern = "a\\z", .has_looks = true, .reads_ahead = true },
        .{ .pattern = "(?m)a$", .has_looks = true, .reads_ahead = true },
        .{ .pattern = "\\ba", .has_looks = true, .reads_ahead = true },
        .{ .pattern = "a\\B", .has_looks = true, .reads_ahead = true },
    };
    for (expected) |entry| {
        const program = try compiler.compile(entry.pattern, .{}, &storage);
        try testing.expectEqual(entry.has_looks, program.has_looks);
        try testing.expectEqual(entry.reads_ahead, program.reads_ahead);
    }
}

test "the options' flags are the flags a pattern starts under" {
    var storage: [storage_len]Instruction = undefined;
    // `k`'s orbit is `K`, `k` and the Kelvin sign: three sequences, one node, `K` its first range.
    const folded = try compiler.compile("k", .{ .flags = .{ .case_insensitive = true } }, &storage);
    try testing.expectEqual(program_file.Kind.ranges, folded.instructions[0].kind);
    try testing.expectEqual(@as(u8, 'K'), folded.instructions[1].lo);
    const lines = try compiler.compile("^", .{ .flags = .{ .multi_line = true } }, &storage);
    try testing.expectEqual(program_file.Look.behind_line, lines.instructions[0].look);
    const plain = try compiler.compile("^", .{}, &storage);
    try testing.expectEqual(program_file.Look.behind_text, plain.instructions[0].look);
}

/// True when the instruction's kind goes on to `out`. A `ranges` goes on from its ranges.
fn has_out(kind: program_file.Kind) bool {
    return kind != .match and kind != .fail and kind != .ranges;
}

/// Every target of each half names an instruction of that half, and no hole is left open.
fn expect_whole(program: *const Program) !void {
    const len: u32 = @intCast(program.instructions.len);
    for (program.instructions[0..program.forward_len]) |instruction| {
        try expect_targets(instruction, 0, program.forward_len);
        if (instruction.kind == .save) try testing.expect(instruction.arg < program.slot_count());
    }
    for (program.instructions[program.forward_len..]) |instruction| {
        try expect_targets(instruction, program.forward_len, len);
        try testing.expect(instruction.kind != .save);
    }
    try testing.expect(program.forward < program.forward_len);
    try testing.expect(program.reverse >= program.forward_len and program.reverse < len);
}

fn expect_targets(instruction: Instruction, first: u32, end: u32) !void {
    if (has_out(instruction.kind)) try testing.expect(instruction.out >= first and instruction.out < end);
    if (instruction.kind == .split) try testing.expect(instruction.arg >= first and instruction.arg < end);
    if (instruction.kind == .ranges) try testing.expect(instruction.arg > 1 and instruction.arg <= constants.octet_values);
}

test "every target of a program names an instruction of its own half, for generated patterns" {
    var storage: [storage_len]Instruction = undefined;
    var buffer: [generate.pattern_len_max]u8 = undefined;
    var generator = codec.testing.split.Generator.init(0xB10C);
    for (0..1500) |_| {
        const program = try compiler.compile(generate.pattern(&generator, &buffer), .{}, &storage);
        try expect_whole(&program);
    }
}

test "compile takes exactly the storage a pattern needs, and writes no instruction past it" {
    const patterns = [_][]const u8{ "abc", "(a|b)*c{2,4}", "[^a]+\\b", "", "x{0}", "(?i)k|(?-i:\xE2\x82\xAC)" };
    var storage: [storage_len]Instruction = undefined;
    for (patterns) |pattern| {
        const needed = (try compiler.compile(pattern, .{}, &storage)).instructions.len;
        const guard: Instruction = .{ .kind = .fail, .out = 0xA5A5, .arg = 0x5A5A, .lo = 7, .hi = 9 };
        @memset(&storage, guard);
        const program = try compiler.compile(pattern, .{}, storage[0..needed]);
        try testing.expectEqual(needed, program.instructions.len);
        for (storage[needed..]) |instruction| try testing.expectEqual(guard, instruction);
        try testing.expectError(error.NoSpaceLeft, compiler.compile(pattern, .{}, storage[0 .. needed - 1]));
        try testing.expectError(error.NoSpaceLeft, compiler.compile(pattern, .{}, storage[0..0]));
    }
}

/// Requires each half of `program` to number its nodes from 0 in order, as many as the half's
/// count, and to give each range a `ranges` node holds no number.
fn expect_numbered(program: *const Program) !void {
    const halves = [_]struct { instructions: []const Instruction, nodes: u32 }{
        .{ .instructions = program.instructions[0..program.forward_len], .nodes = program.forward_nodes },
        .{ .instructions = program.instructions[program.forward_len..], .nodes = program.reverse_nodes },
    };
    for (halves) |half| {
        var next: u32 = 0;
        var members: u32 = 0;
        for (half.instructions) |instruction| {
            if (members > 0) {
                try testing.expectEqual(program_file.no_node, instruction.node);
                members -= 1;
                continue;
            }
            try testing.expectEqual(next, instruction.node);
            next += 1;
            if (instruction.kind == .ranges) members = instruction.arg;
        }
        try testing.expectEqual(half.nodes, next);
    }
}

test "each half of a program numbers its nodes from 0, and a node's ranges hold no number" {
    var storage: [storage_len]Instruction = undefined;
    const patterns = [_][]const u8{ "[ac-eg]+x", "(a|b)\\w{2}", "\\p{Greek}+", "foo|bar|baz" };
    var members: usize = 0;
    for (patterns) |pattern| {
        const program = try compiler.compile(pattern, .{}, &storage);
        try expect_numbered(&program);
        members += program.instructions.len - program.forward_nodes - program.reverse_nodes;
    }
    // The patterns' classes hold ranges after their nodes, so the rule for them is tried.
    try testing.expect(members > 0);
}

test "a pattern compiles to the same program each time" {
    var first: [storage_len]Instruction = undefined;
    var second: [storage_len]Instruction = undefined;
    @memset(&second, .{ .kind = .fail, .out = 0xFFFF });
    var buffer: [generate.pattern_len_max]u8 = undefined;
    var generator = codec.testing.split.Generator.init(0xD37);
    for (0..300) |_| {
        const pattern = generate.pattern(&generator, &buffer);
        const one = try compiler.compile(pattern, .{}, &first);
        const two = try compiler.compile(pattern, .{}, &second);
        try testing.expectEqualSlices(u8, std.mem.sliceAsBytes(one.instructions), std.mem.sliceAsBytes(two.instructions));
        try testing.expectEqualSlices(u8, &one.classes, &two.classes);
        try testing.expectEqual(one.class_count, two.class_count);
    }
}

test "a range quantifier costs its operand once for each count, so a nested one costs the product" {
    var storage: [1 << 15]Instruction = undefined;
    const one = try compiler.compile("ab", .{ .reverse = false }, &storage);
    const ten = try compiler.compile("(?:ab){10}", .{ .reverse = false }, &storage);
    const thousand = try compiler.compile("(?:(?:ab){10}){100}", .{ .reverse = false }, &storage);
    // Three instructions close a program: the whole match's two slots and `match`.
    const overhead = 3;
    try testing.expectEqual(10 * (one.instructions.len - overhead), ten.instructions.len - overhead);
    try testing.expectEqual(1000 * (one.instructions.len - overhead), thousand.instructions.len - overhead);
    try testing.expectError(error.NoSpaceLeft, compiler.compile("(?:(?:ab){10}){100}", .{ .reverse = false }, storage[0..1000]));
}

const matcher_file = @import("matcher.zig");

test "compile_comptime gives the program compile gives, in storage of the program's own length" {
    const program = compiler.compile_comptime("(a|b)+c{2,3}\\b|\xC3\xA9", .{});
    var storage: [storage_len]Instruction = undefined;
    const expected = try compiler.compile("(a|b)+c{2,3}\\b|\xC3\xA9", .{}, &storage);
    try testing.expectEqualSlices(u8, std.mem.sliceAsBytes(expected.instructions), std.mem.sliceAsBytes(program.instructions));
    try testing.expectEqual(expected.forward, program.forward);
    try testing.expectEqual(expected.reverse, program.reverse);
    try testing.expectEqual(expected.group_count, program.group_count);
    try testing.expectEqualSlices(u8, &expected.classes, &program.classes);
    // The sizes a matcher takes are known to the compiler too.
    var memory: [matcher_file.Matcher.memory_len(program.forward_len, program.group_count * constants.group_slots)]u64 = undefined;
    var matcher: matcher_file.Matcher = undefined;
    matcher.init(&program, .{ .captures = .groups }, &memory);
    try testing.expectEqual(@as(?matcher_file.Span, .{ .start = 1, .end = 5 }), matcher.find("xabcc ", 0));
    try testing.expectEqual(@as(?matcher_file.Span, .{ .start = 2, .end = 3 }), matcher.group(1));
}

const GroupName = program_file.GroupName;

/// A pattern of two named groups, and the same pattern with plain groups.
const named_pattern = "(?P<year>\\d{4})-(?:x)?(?<month>\\d{2})";
const plain_pattern = "(\\d{4})-(?:x)?(\\d{2})";

test "compile keeps each name in the caller's storage, and a named group compiles as a group" {
    var storage: [storage_len]Instruction = undefined;
    var names: [named_groups + 1]GroupName = undefined;
    const program = try compiler.compile(named_pattern, .{ .names = &names }, &storage);
    try testing.expectEqual(@as(usize, named_groups), program.names.len);
    try testing.expectEqualStrings("year", program.names[0].name());
    try testing.expectEqual(@as(?u32, 1), program.group_index("year"));
    try testing.expectEqual(@as(?u32, 2), program.group_index("month"));
    try testing.expectEqual(@as(?u32, null), program.group_index("day"));
    try testing.expectEqual(@as(?u32, null), program.group_index("yea"));
    var plain_storage: [storage_len]Instruction = undefined;
    const plain = try compiler.compile(plain_pattern, .{}, &plain_storage);
    try testing.expectEqualSlices(u8, std.mem.sliceAsBytes(plain.instructions), std.mem.sliceAsBytes(program.instructions));
    try testing.expectEqual(plain.group_count, program.group_count);
    // Too little storage is refused as for instructions; none keeps no names.
    var one: [named_groups - 1]GroupName = undefined;
    try testing.expectError(error.NoSpaceLeft, compiler.compile(named_pattern, .{ .names = &one }, &storage));
    const unkept = try compiler.compile(named_pattern, .{}, &storage);
    try testing.expectEqual(@as(usize, 0), unkept.names.len);
    try testing.expectEqual(@as(?u32, null), unkept.group_index("year"));
}

/// The named groups of `named_pattern`.
const named_groups = 2;

test "compile_comptime keeps every name in the binary" {
    const program = compiler.compile_comptime(named_pattern, .{});
    try testing.expectEqual(@as(usize, named_groups), program.names.len);
    try testing.expectEqual(@as(?u32, 2), program.group_index("month"));
}
