//! Level 1's parse in x86-64 assembly (decision 63): the port of `encoder_parse_aarch64.zig`, whose
//! comment describes the loop, its bounds and what it reads and writes. Its text keeps the ends,
//! the reach, the multiplier, the last distances and the commands' pointers in the state, as
//! x86-64 has fewer registers.
//!
//! It takes level 1 on an x86-64 target built by LLVM: Zig's own x86-64 backend rejects Intel
//! syntax, and every other target runs the Zig parse.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const codec = @import("codec");
const encoder_commands = @import("../encoder_commands.zig");
const assembly = @import("encoder_parse_assembly.zig");
const loop_text = @import("encoder_parse_x86_64_template.zig");

const finder = codec.match_finder;
const State = assembly.State;

/// Whether the assembly takes the parse: an x86-64 target built by LLVM, and level 1's tables.
pub fn takes(comptime level: finder.Level) bool {
    return assembly.fits(level) and builtin.cpu.arch == .x86_64 and builtin.zig_backend == .stage2_llvm;
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
        : [state] "{rdi}" (state),
        : .{
          .memory = true,
          .cc = true,
          .rax = true,
          .rbx = true,
          .rcx = true,
          .rdx = true,
          .rsi = true,
          .r8 = true,
          .r9 = true,
          .r10 = true,
          .r11 = true,
          .r12 = true,
          .r13 = true,
          .r14 = true,
          .r15 = true,
        });
}

/// The near copy runs until the position passes the reach, then the far copy to the search's end.
const template = assembly.fill(loop_text.prologue ++ "\n" ++ near ++ far ++ loop_text.exit ++ "\n", assembly.arguments);
const match_text = loop_text.extend ++ "\n" ++ loop_text.command ++ "\n" ++ loop_text.record ++ "\n";
const near = loop_text.position ++ "\n" ++ loop_text.probe ++ "\n" ++ loop_text.repeat_range ++ "\n" ++
    loop_text.tables("r12", loop_text.next_limit_near) ++ "\n" ++ match_text;
const far = loop_text.position_far ++ "\n" ++ loop_text.probe ++ "\n" ++
    loop_text.tables("qword ptr [rdi + {[reach]}]", loop_text.next_limit_far) ++ "\n" ++ match_text;
