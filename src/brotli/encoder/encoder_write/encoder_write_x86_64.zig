//! Level 1's writer in x86-64 assembly (decision 63's amendment): the port of
//! `encoder_write_aarch64.zig`, whose comment describes the writer, its room tests and what it
//! reads and writes. Its text keeps the commands' end, the octets written so far and the codes in
//! the state, as x86-64 has fewer registers.
//!
//! It takes an x86-64 target built by LLVM: Zig's own x86-64 backend rejects Intel syntax, and
//! every other target runs the Zig writer.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const codec = @import("codec");
const encoder_commands = @import("../encoder_commands.zig");
const parse_assembly = @import("../encoder_parse/encoder_parse_assembly.zig");
const assembly = @import("encoder_write_assembly.zig");
const loop_text = @import("encoder_write_x86_64_template.zig");

const Error = error{NoSpaceLeft};
const State = assembly.State;

/// Whether the assembly takes the writer: an x86-64 target built by LLVM.
pub const takes = builtin.cpu.arch == .x86_64 and builtin.zig_backend == .stage2_llvm;

/// `write_commands` where the assembly `takes`.
pub fn write(writer: *codec.BitWriter, input: []const u8, commands: *const encoder_commands.Commands, codes: anytype) Error!void {
    comptime assert(takes);
    return assembly.write(execute, writer, input, commands, codes);
}

/// Writes the commands `State` describes, and stores the state back.
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

const put = loop_text.put;

/// The text: a command's head, its lengths in one put or two, its literals, its distance.
const template = parse_assembly.fill(loop_text.prologue ++ "\n" ++
    loop_text.command_head ++ "\n" ++ loop_text.check ++ "\n" ++ loop_text.command_lengths ++ "\n" ++
    put("rsi", "r14") ++ "    jmp 30f\n20:\n    mov r9, rcx\n" ++ put("rsi", "r9") ++ put("r12", "r13") ++
    loop_text.literals_start ++ "\n" ++ loop_text.check ++ "\n" ++ loop_text.literals_group ++ "\n" ++
    put("r9", "r10") ++ loop_text.literals_rest ++ "\n" ++ put("r9", "r10") ++ "    jmp 31b\n" ++
    loop_text.distance ++ "\n" ++ put("rbp", "r10") ++ "    jmp 1b\n" ++ loop_text.exit ++ "\n", assembly.arguments);
