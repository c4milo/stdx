//! Level 1's writer in aarch64 assembly (decision 63's amendment): each command's symbol with its
//! insert and copy extra bits, its literals 3 a put, and its distance, as `write_zig` puts them,
//! into the same octets, with the same bit buffer and count left behind.
//!
//! It takes an aarch64 target built by LLVM; every other target runs the Zig writer. Its stores
//! go by address, without Zig's bounds checks: before each command and each chunk of 64 literals
//! it tests the output's room for every bit they can take and one whole store, as `Bits.check`
//! does, and stops where the room runs out, which Zig then reports. Its loads read the meta-block
//! below its length, the commands below their count, and the codes' arrays by a symbol or octet.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const encoder_commands = @import("../encoder_commands.zig");
const parse_assembly = @import("../encoder_parse/encoder_parse_assembly.zig");
const assembly = @import("encoder_write_assembly.zig");
const loop_text = @import("encoder_write_aarch64_template.zig");

const Error = error{NoSpaceLeft};
const State = assembly.State;

/// Whether the assembly takes the writer: an aarch64 target built by LLVM.
pub const takes = builtin.cpu.arch == .aarch64 and builtin.zig_backend == .stage2_llvm;

/// `write_commands` where the assembly `takes`.
pub fn write(writer: *codec.BitWriter, input: []const u8, commands: *const encoder_commands.Commands, codes: anytype) Error!void {
    comptime assert(takes);
    return assembly.write(execute, writer, input, commands, codes);
}

/// Writes the commands `State` describes, and stores the state back.
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

const put = loop_text.put;

/// The text: a command's head, its lengths in one put or two, its literals, its distance.
const template = parse_assembly.fill(loop_text.prologue ++ "\n" ++
    loop_text.command_head ++ "\n" ++ loop_text.check ++ "\n" ++ loop_text.command_lengths ++ "\n" ++
    put("x21", "x24") ++ "    b 30f\n20:\n" ++ put("x21", "x28") ++ put("x23", "x25") ++
    loop_text.literals_start ++ "\n" ++ loop_text.check ++ "\n" ++ loop_text.literals_group ++ "\n" ++
    put("x24", "x20") ++ loop_text.literals_rest ++ "\n" ++ put("x24", "x20") ++ "    b 31b\n" ++
    loop_text.distance ++ "\n" ++ put("x23", "x24") ++ "    b 1b\n" ++ loop_text.exit ++ "\n", assembly.arguments);
