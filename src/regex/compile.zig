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
const syntax = @import("syntax.zig");
const atom = @import("syntax_atom.zig");
const Builder = fragment.Builder;
const Instruction = program_file.Instruction;
const Program = program_file.Program;

pub const Options = struct {
    /// The flags the pattern starts under. A `(?i)` and its like change them from inside.
    flags: atom.Flags = .{},
    /// Whether the storage holds the reverse program too. A streaming `Matcher` reads the forward
    /// program alone; a `Searcher` needs both.
    reverse: bool = true,
};

/// One direction of a program: its entry and the capture groups its pattern holds.
const Pass = struct {
    entry: u32,
    group_count: u32,
};

fn pass(builder: *Builder, pattern: []const u8, flags: atom.Flags, direction: fragment.Direction) errors.Error!Pass {
    builder.direction = direction;
    var parser = syntax.Parser.init(pattern, flags, builder);
    const whole = try builder.capture(try parser.parse(), 0);
    const end = try builder.emit(.{ .kind = .match });
    builder.patch(whole.holes, end);
    return .{ .entry = whole.entry, .group_count = parser.group_count };
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
    const forward = try pass(&builder, pattern, options.flags, .forward);
    const forward_len = builder.len;
    var reverse_entry: u32 = program_file.no_entry;
    if (options.reverse) {
        const reverse = try pass(&builder, pattern, options.flags, .reverse);
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
    };
}

/// Compiles a pattern the build knows. The program's storage is as long as the program and
/// lives in the binary, and a pattern `compile` refuses is a compile error that names the
/// refusal.
pub inline fn compile_comptime(comptime pattern: []const u8, comptime options: Options) Program {
    return comptime frozen: {
        @setEvalBranchQuota(constants.comptime_branch_quota);
        var storage: [constants.comptime_instructions_max]Instruction = undefined;
        const draft = compile(pattern, options, &storage) catch |err| {
            @compileError("regex: " ++ @errorName(err) ++ " in the pattern \"" ++ pattern ++ "\"");
        };
        const instructions: [draft.instructions.len]Instruction = storage[0..draft.instructions.len].*;
        var program = draft;
        program.instructions = &instructions;
        break :frozen program;
    };
}

test {
    _ = @import("compile_test.zig");
}
