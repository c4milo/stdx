//! `compile`: a pattern into a program, in storage the caller gives (decision 86).
//!
//! The pattern is read once for the forward program, which writes the capture slots, and once more
//! for the reverse program when the options ask for it. The reverse program takes each match from
//! its last octet to its first, and a `Searcher` reads it to find where a match starts.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const errors = @import("errors.zig");
const fragment = @import("fragment.zig");
const octet_classes = @import("octet_classes.zig");
const program_file = @import("program.zig");
const syntax = @import("syntax/syntax.zig");
const syntax_name = @import("syntax/syntax_name.zig");
const atom = @import("syntax/syntax_atom.zig");
const literal_trie = @import("literal_trie.zig");
const Builder = fragment.Builder;
const Instruction = program_file.Instruction;
const Program = program_file.Program;
const GroupName = program_file.GroupName;
const ScalarRange = @import("utf8_ranges.zig").ScalarRange;

pub const Options = struct {
    /// The flags the pattern starts under. A `(?i)` and its like change them from inside.
    flags: atom.Flags = .{},
    /// How the program reads the text: as UTF-8, or as bytes, where `.` takes any byte but a
    /// line feed, UTF-8 or not.
    encoding: program_file.Encoding = .utf8,
    /// Whether the storage holds the reverse program too. A streaming `Matcher` reads the forward
    /// program alone; a `Searcher` needs both.
    reverse: bool = true,
    /// Storage the caller owns for the names of the named groups, which `Program.names` then
    /// holds a slice of. With none, the names are checked and not kept.
    names: []GroupName = &.{},
};

/// One direction of a program: its entry, the capture groups its pattern holds, and the names
/// it kept.
const Pass = struct {
    entry: u32,
    group_count: u32,
    names: []const GroupName,
    /// The fewest bytes a match takes, as the fragments count it.
    least: u16,
};

/// Reads the pattern into the builder in one direction, and keeps its names in `names`. The
/// forward pass checks the names. The reverse pass reads the same pattern and checks none, and a
/// pattern with no `(?` holds no name, so neither pays for the parser's table of names.
fn pass(builder: *Builder, pattern: []const u8, start: syntax.Start, direction: fragment.Direction, names: []GroupName, classes: bool) errors.Error!Pass {
    if (try trie_pass(builder, pattern, start.flags, direction)) |done| return done;
    if (direction == .forward and may_name(pattern)) {
        var read: syntax_name.Names = .{};
        return pass_with(builder, pattern, start, direction, .{ .read = &read, .kept = names }, classes);
    }
    return pass_with(builder, pattern, start, direction, .{ .read = null, .kept = &.{} }, classes);
}

/// The pass of a pattern that is an alternation of literals and nothing else, as a trie
/// (literal_trie.zig), or null where the pattern is anything else. It holds no group of its own.
/// A literal's bytes are its UTF-8 in either encoding, so one trie serves both.
fn trie_pass(builder: *Builder, pattern: []const u8, flags: atom.Flags, direction: fragment.Direction) errors.Error!?Pass {
    builder.direction = direction;
    const body = (try literal_trie.alternation(builder, pattern, flags.case_insensitive)) orelse return null;
    const whole = try builder.capture(body, 0);
    const end = try builder.emit(.{ .kind = .match });
    builder.patch(whole.holes, end);
    return .{ .entry = whole.entry, .group_count = 1, .names = &.{}, .least = whole.least };
}

/// True when the pattern holds `(?`, which a named group starts with. `std.mem.indexOf` would
/// build a table of 256 skips for each call, so this finds each `(` and reads the octet after it.
fn may_name(pattern: []const u8) bool {
    var at: usize = 0;
    // Each turn passes one `(`, so the turns are at most the pattern's octets.
    while (std.mem.indexOfScalarPos(u8, pattern, at, '(')) |open| {
        if (open + 1 < pattern.len and pattern[open + 1] == '?') return true;
        at = open + 1;
    }
    return false;
}

/// Where a pass keeps names: the parser's table, and the caller's storage.
const Keep = struct { read: ?*syntax_name.Names, kept: []GroupName };

/// Reads the pattern in the set its classes need. ReleaseSafe writes each octet of a set it
/// declares, so a pass declares none where `classes` says the pattern holds no `[` and no `\`,
/// which start every class, and `class_ranges_small` ranges for another. A class past them reads
/// the pattern again, from the builder's state before the pass, in a set of `class_ranges_max`.
fn pass_with(builder: *Builder, pattern: []const u8, start: syntax.Start, direction: fragment.Direction, keep: Keep, classes: bool) errors.Error!Pass {
    // A pattern with no class adds no range, so the empty set refuses none of its classes.
    if (!classes) return pass_in(builder, pattern, start, direction, keep, &.{});
    const begin = builder.len;
    if (pass_small(builder, pattern, start, direction, keep)) |done| return done else |err| if (err != error.ClassTooLarge) return err;
    builder.truncate(begin);
    if (keep.read) |read| read.len = 0;
    return pass_large(builder, pattern, start, direction, keep);
}

/// True when the pattern holds a `[` or a `\`. `std.mem.indexOfScalar` would set up a vector
/// loop for each of the two, which costs a short pattern more than its octets do.
fn may_hold_class(pattern: []const u8) bool {
    for (pattern) |octet| {
        if (octet == '[' or octet == '\\') return true;
    }
    return false;
}

fn pass_small(builder: *Builder, pattern: []const u8, start: syntax.Start, direction: fragment.Direction, keep: Keep) errors.Error!Pass {
    var ranges: [constants.class_ranges_small]ScalarRange = undefined;
    return pass_in(builder, pattern, start, direction, keep, &ranges);
}

/// A pass in a set of `class_ranges_max` ranges, whose 16 KiB take a frame of their own.
noinline fn pass_large(builder: *Builder, pattern: []const u8, start: syntax.Start, direction: fragment.Direction, keep: Keep) errors.Error!Pass {
    var ranges: [constants.class_ranges_max]ScalarRange = undefined;
    return pass_in(builder, pattern, start, direction, keep, &ranges);
}

fn pass_in(builder: *Builder, pattern: []const u8, start: syntax.Start, direction: fragment.Direction, keep: Keep, ranges: []ScalarRange) errors.Error!Pass {
    builder.direction = direction;
    var parser = syntax.Parser.init(pattern, start, builder, ranges);
    parser.names = keep.read;
    const whole = try builder.capture(try parser.parse(), 0);
    const end = try builder.emit(.{ .kind = .match });
    builder.patch(whole.holes, end);
    const read = keep.read orelse return .{ .entry = whole.entry, .group_count = parser.group_count, .names = &.{}, .least = whole.least };
    return .{ .entry = whole.entry, .group_count = parser.group_count, .names = try keep_names(keep.kept, read, pattern), .least = whole.least };
}

/// Copies the names the parser read into `names`: none where the caller gave no storage, and
/// `error.NoSpaceLeft` where it gave too little, as for instructions.
fn keep_names(names: []GroupName, parsed: *const syntax_name.Names, pattern: []const u8) errors.Error![]const GroupName {
    if (names.len == 0) return &.{};
    const read = parsed.slice();
    if (names.len < read.len) return error.NoSpaceLeft;
    for (names[0..read.len], read) |*kept, named| {
        kept.* = .{ .group = named.group, .len = named.len, .octets = @splat(0) };
        @memcpy(kept.octets[0..named.len], pattern[named.start..][0..named.len]);
    }
    return names[0..read.len];
}

/// What a program's assertions ask of a matcher.
const Looks = struct {
    any: bool = false,
    ahead: bool = false,

    fn of(instructions: []const Instruction) Looks {
        var looks: Looks = .{};
        for (instructions) |instruction| {
            if (instruction.kind != .look) continue;
            looks.any = true;
            looks.ahead = looks.ahead or instruction.look.reads_ahead();
        }
        return looks;
    }
};

/// Compiles `pattern` into `storage` and gives the program, which holds a slice of `storage`.
/// `error.NoSpaceLeft` says the storage is too small for the pattern.
pub fn compile(pattern: []const u8, options: Options, storage: []Instruction) errors.Error!Program {
    var builder: Builder = .{
        .instructions = storage[0..@min(storage.len, constants.instructions_max)],
        .direction = .forward,
    };
    const holds_class = may_hold_class(pattern);
    const start: syntax.Start = .{ .flags = options.flags, .encoding = options.encoding };
    const forward = try pass(&builder, pattern, start, .forward, options.names, holds_class);
    const forward_len = builder.len;
    const forward_held = builder.held;
    var reverse_entry: u32 = program_file.no_entry;
    if (options.reverse) {
        const reverse = try pass(&builder, pattern, start, .reverse, &.{}, holds_class);
        assert(reverse.group_count == forward.group_count);
        reverse_entry = reverse.entry;
    }
    const instructions = storage[0..builder.len];
    const looks = Looks.of(instructions[0..forward_len]);
    const classes = octet_classes.compute(instructions, looks.any);
    return .{
        .instructions = instructions,
        .forward_len = forward_len,
        .forward_nodes = forward_len - forward_held,
        .reverse_nodes = (builder.len - forward_len) - (builder.held - forward_held),
        .forward = forward.entry,
        .reverse = reverse_entry,
        .len_min = forward.least,
        .group_count = forward.group_count,
        .reads_ahead = looks.ahead,
        .has_looks = looks.any,
        .encoding = options.encoding,
        .classes = classes.of,
        .class_count = classes.count,
        .names = forward.names,
    };
}

/// Compiles a pattern the build knows. The program's storage is as long as the program and
/// lives in the binary, with every name of its named groups, whatever `options.names` holds, and
/// a pattern `compile` refuses is a compile error that names the refusal.
pub inline fn compile_comptime(comptime pattern: []const u8, comptime options: Options) Program {
    return comptime frozen: {
        @setEvalBranchQuota(constants.comptime_branch_quota);
        var storage: [constants.comptime_instructions_max]Instruction = undefined;
        var names: [constants.group_names_max]GroupName = undefined;
        var with_names = options;
        with_names.names = &names;
        const draft = compile(pattern, with_names, &storage) catch |err| {
            @compileError("regex: " ++ @errorName(err) ++ " in the pattern \"" ++ pattern ++ "\"");
        };
        const instructions: [draft.instructions.len]Instruction = storage[0..draft.instructions.len].*;
        const kept: [draft.names.len]GroupName = names[0..draft.names.len].*;
        var program = draft;
        program.instructions = &instructions;
        program.names = &kept;
        break :frozen program;
    };
}

const testing = std.testing;
const test_storage_len = 1024;

test "a pattern may hold a class where it holds a [ or a \\" {
    try testing.expect(!may_hold_class("Sherlock (Holmes)?"));
    try testing.expect(may_hold_class("a[b]"));
    try testing.expect(may_hold_class("a\\d"));
}

/// The first code point of `wide_class`, and the step from each to the next: one code point
/// apart, so no two join.
const wide_class_first = 0x100;
const wide_class_step = 2;

/// A named group, then a class of `count` code points apart from U+0100 on, negated or not.
fn wide_class(text: []u8, count: usize, negated: bool) []const u8 {
    const head = if (negated) "(?P<first>a)[^" else "(?P<first>a)[";
    @memcpy(text[0..head.len], head);
    var len = head.len;
    for (0..count) |index| {
        const code_point: u21 = @intCast(wide_class_first + wide_class_step * index);
        len += std.unicode.utf8Encode(code_point, text[len..]) catch unreachable;
    }
    text[len] = ']';
    return text[0 .. len + 1];
}

/// Reads `pattern` after one instruction, with `pass_with` or in a set of `class_ranges_max`
/// ranges, and requires the pass to keep the group's name.
fn read_after_one(storage: []Instruction, pattern: []const u8, large: bool) !Builder {
    var builder: Builder = .{ .instructions = storage, .direction = .forward };
    _ = try builder.emit(.{ .kind = .fail });
    var read: syntax_name.Names = .{};
    var kept: [1]GroupName = undefined;
    const keep: Keep = .{ .read = &read, .kept = &kept };
    const done = try if (large) pass_large(&builder, pattern, .{}, .forward, keep) else pass_with(&builder, pattern, .{}, .forward, keep, true);
    try testing.expectEqualStrings("first", done.names[0].name());
    return builder;
}

/// Requires `pass_with` to write the program a pass in a set of `class_ranges_max` ranges writes.
fn expect_as_large(pattern: []const u8) !void {
    var storage: [test_storage_len]Instruction = undefined;
    var large_storage: [test_storage_len]Instruction = undefined;
    const builder = try read_after_one(&storage, pattern, false);
    const large = try read_after_one(&large_storage, pattern, true);
    try testing.expectEqualSlices(Instruction, large_storage[0..large.len], storage[0..builder.len]);
}

test "a class past the small set reads the pattern again, as a pass in the large set reads it" {
    var text: [test_storage_len]u8 = undefined;
    // One range past the small set, and a negation that passes it.
    try expect_as_large(wide_class(&text, constants.class_ranges_small + 1, false));
    try expect_as_large(wide_class(&text, constants.class_ranges_small, true));
    // A class that fits, read as the large set reads it.
    try expect_as_large(wide_class(&text, 1, true));
}

test {
    _ = @import("compile_test.zig");
}
