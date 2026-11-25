//! The program of a replayed case: the one its listed instructions make, or the one its
//! pattern compiles to, which must be the one listed (decision 86, design §8 part 22h).
const std = @import("std");
const regex = @import("regex");
const replay_dump = @import("matcher_replay_dump.zig");
const Instruction = regex.Instruction;

/// The program that listed instructions make: a forward program alone, whose one group is the
/// whole match. Only the matcher runs it: a DFA needs the classes `compile` finds.
pub fn of_listed(listed: []const Instruction, forward: u32, encoding: regex.Encoding) regex.Program {
    return .{
        .instructions = listed,
        .forward_len = @intCast(listed.len),
        .forward_nodes = @intCast(listed.len),
        .reverse_nodes = 0,
        .forward = forward,
        .reverse = replay_dump.no_entry,
        .group_count = 1,
        .reads_ahead = true,
        .has_looks = true,
        .encoding = encoding,
        .classes = @splat(0),
        .class_count = 1,
        .names = &.{},
    };
}

/// Requires a compiled program to be the one a file lists: its two entries, its groups' slots
/// where the file names them, and each instruction. The proved answers are answers of those
/// lines.
pub fn expect_listed(program: *const regex.Program, listed: []const Instruction, forward: u32, reverse: u32, slots: ?u32) !void {
    if (program.forward != forward or program.reverse != reverse) return error.ProgramDiffers;
    if (slots) |named| {
        if (program.slot_count() != named) return error.ProgramDiffers;
    }
    if (program.instructions.len != listed.len) return error.ProgramDiffers;
    for (program.instructions, listed) |made, named| {
        var made_line: [replay_dump.line_len_max]u8 = undefined;
        var named_line: [replay_dump.line_len_max]u8 = undefined;
        if (!std.mem.eql(u8, try replay_dump.line_of(&made_line, made), try replay_dump.line_of(&named_line, named))) return error.ProgramDiffers;
    }
}
