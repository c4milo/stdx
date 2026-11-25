//! Level 1's parse in aarch64 assembly (decision 63, which amends decision 16 for this loop): the
//! positions of a meta-block probed in codec's match finder's tables, each match stepped back,
//! measured and weighed, and recorded as a command with its counts, as `parse_zig` does. It writes
//! the commands, counts and table entries the Zig parse writes.
//!
//! It takes level 1 on an aarch64 target built by LLVM; every other target runs the Zig parse. A
//! command whose insert or copy length passes the length tables leaves the text: Zig records it
//! and its table entries, and the text starts again after it.
//!
//! Its reads and writes go by address, without Zig's bounds checks. Every position it probes lies
//! below the search's end, 8 octets before the block's end, so each read of 8 octets stays in the
//! block; a hash's top 14 bits keep each entry inside its table; a command copies 4 octets or
//! more, so the count stays below the commands' room; and an octet or a symbol indexes its counts.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const encoder_commands = @import("../encoder_commands.zig");
const assembly = @import("encoder_parse_assembly.zig");
const loop_text = @import("encoder_parse_aarch64_template.zig");

const finder = codec.match_finder;
const State = assembly.State;

/// Whether the assembly takes the parse: an aarch64 target built by LLVM, which places the
/// assembly's registers, and level 1's tables, whose hashes the text writes.
pub fn takes(comptime level: finder.Level) bool {
    return assembly.fits(level) and builtin.cpu.arch == .aarch64 and builtin.zig_backend == .stage2_llvm;
}

/// `encoder_parse.parse` for a level that `takes`.
pub fn parse(comptime level: finder.Level, comptime safety: bool, matcher: *finder.Matcher(level), window: []const u8, start: usize, end: usize, commands: *encoder_commands.Commands) void {
    comptime assert(takes(level));
    assembly.parse(level, safety, execute, matcher, window, start, end, commands);
}

/// Parses the positions `State` describes, and stores the state back.
noinline fn execute(state: *State) void {
    asm volatile (template
        :
        : [state] "{x0}" (state),
        : .{
          .memory = true,
          .nzcv = true,
          .x1 = true,
          .x2 = true,
          .x3 = true,
          .x4 = true,
          .x5 = true,
          .x6 = true,
          .x7 = true,
          .x8 = true,
          .x9 = true,
          .x10 = true,
          .x11 = true,
          .x12 = true,
          .x13 = true,
          .x14 = true,
          .x15 = true,
          .x16 = true,
          .x17 = true,
          .x19 = true,
          .x20 = true,
          .x21 = true,
          .x22 = true,
          .x23 = true,
          .x24 = true,
          .x25 = true,
          .x26 = true,
          .x27 = true,
          .x28 = true,
        });
}

/// The near copy runs until the position passes the reach, then the far copy to the search's end.
const template = assembly.fill(loop_text.prologue ++ "\n" ++ near ++ far ++ loop_text.exit ++ "\n", assembly.arguments);
const match_text = loop_text.extend ++ "\n" ++ loop_text.command ++ "\n" ++ loop_text.record ++ "\n";
const near = loop_text.position ++ "\n" ++ loop_text.tables ++ "\n" ++ match_text;
const far = loop_text.position_far ++ "\n" ++ loop_text.tables_far ++ "\n" ++ match_text;
