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
const Builder = fragment.Builder;
const Instruction = program_file.Instruction;
const Program = program_file.Program;
const GroupName = program_file.GroupName;

pub const Options = struct {
    /// The flags the pattern starts under. A `(?i)` and its like change them from inside.
    flags: atom.Flags = .{},
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
};

/// Reads the pattern into the builder in one direction, and keeps its names in `names`. The
/// forward pass checks the names. The reverse pass reads the same pattern and checks none, and a
/// pattern with no `(?` holds no name, so neither pays for the parser's table of names.
fn pass(builder: *Builder, pattern: []const u8, flags: atom.Flags, direction: fragment.Direction, names: []GroupName) errors.Error!Pass {
    if (direction == .forward and may_name(pattern)) {
        var read: syntax_name.Names = .{};
        return pass_with(builder, pattern, flags, direction, .{ .read = &read, .kept = names });
    }
    return pass_with(builder, pattern, flags, direction, .{ .read = null, .kept = &.{} });
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

fn pass_with(builder: *Builder, pattern: []const u8, flags: atom.Flags, direction: fragment.Direction, keep: Keep) errors.Error!Pass {
    builder.direction = direction;
    var parser = syntax.Parser.init(pattern, flags, builder);
    parser.names = keep.read;
    const whole = try builder.capture(try parser.parse(), 0);
    const end = try builder.emit(.{ .kind = .match });
    builder.patch(whole.holes, end);
    const read = keep.read orelse return .{ .entry = whole.entry, .group_count = parser.group_count, .names = &.{} };
    return .{ .entry = whole.entry, .group_count = parser.group_count, .names = try keep_names(keep.kept, read, pattern) };
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
    const forward = try pass(&builder, pattern, options.flags, .forward, options.names);
    const forward_len = builder.len;
    var reverse_entry: u32 = program_file.no_entry;
    if (options.reverse) {
        const reverse = try pass(&builder, pattern, options.flags, .reverse, &.{});
        assert(reverse.group_count == forward.group_count);
        reverse_entry = reverse.entry;
    }
    const instructions = storage[0..builder.len];
    const looks = Looks.of(instructions[0..forward_len]);
    const classes = octet_classes.compute(instructions, looks.any);
    return .{
        .instructions = instructions,
        .forward_len = forward_len,
        .forward = forward.entry,
        .reverse = reverse_entry,
        .group_count = forward.group_count,
        .reads_ahead = looks.ahead,
        .has_looks = looks.any,
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

test {
    _ = @import("compile_test.zig");
}
