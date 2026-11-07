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
const assembly = @import("../encoder_parse/encoder_parse_assembly.zig");
const loop_text = @import("encoder_write_aarch64_template.zig");

const Error = error{NoSpaceLeft};
const Command = encoder_commands.Command;

/// Whether the assembly takes the writer: an aarch64 target built by LLVM.
pub const takes = builtin.cpu.arch == .aarch64 and builtin.zig_backend == .stage2_llvm;

/// The writer's state, as the assembly reads and writes it: every field 8 octets, at the offsets
/// `arguments` names.
const State = extern struct {
    commands: [*]const Command,
    commands_end: [*]const Command,
    input: [*]const u8,
    /// The meta-block's octets the commands so far cover.
    produced: u64,
    input_len: u64,
    buffer: u64,
    count: u64,
    room: [*]u8,
    room_end: [*]u8,
    literal_codes: [*]const u16,
    literal_lengths: [*]const u8,
    command_codes: [*]const u16,
    command_lengths: [*]const u8,
    symbol_lengths: [*]const encoder_commands.SymbolLengths,
    distance_codes: [*]const u16,
    distance_lengths: [*]const u8,
    distance_extra_bits: [*]const u8,
    /// 1 where the output's room ran out.
    failed: u64,
};

/// `write_commands` where the assembly `takes`.
pub fn write(writer: *codec.BitWriter, input: []const u8, commands: *const encoder_commands.Commands, codes: anytype) Error!void {
    comptime assert(takes);
    // The first store drops the whole octets the header left, so the text starts below 8 bits.
    if (!writer.has_store_room()) return error.NoSpaceLeft;
    writer.store();
    const octets = writer.writer.octets;
    var state: State = .{
        .commands = &commands.commands,
        .commands_end = commands.commands[commands.count..].ptr,
        .input = input.ptr,
        .produced = 0,
        .input_len = input.len,
        .buffer = writer.bits.buffer,
        .count = writer.bits.count,
        .room = octets[writer.writer.position..].ptr,
        .room_end = octets[octets.len..].ptr,
        .literal_codes = &codes.literal.codes,
        .literal_lengths = &codes.literal.lengths,
        .command_codes = &codes.command.codes,
        .command_lengths = &codes.command.lengths,
        .symbol_lengths = &encoder_commands.symbol_lengths,
        .distance_codes = &codes.distance.codes,
        .distance_lengths = &codes.distance.lengths,
        .distance_extra_bits = &encoder_commands.distance_extra_bits,
        .failed = 0,
    };
    assert(state.count < @bitSizeOf(u8));
    execute(&state);
    if (state.failed == 1) return error.NoSpaceLeft;
    assert(state.produced == input.len and state.count < @bitSizeOf(u8));
    writer.writer.position = state.room - octets.ptr;
    assert(writer.writer.position <= octets.len);
    writer.bits = .{ .buffer = state.buffer, .count = @intCast(state.count) };
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
const template = assembly.fill(loop_text.prologue ++ "\n" ++
    loop_text.command_head ++ "\n" ++ loop_text.check ++ "\n" ++ loop_text.command_lengths ++ "\n" ++
    put("x21", "x24") ++ "    b 30f\n20:\n" ++ put("x21", "x28") ++ put("x23", "x25") ++
    loop_text.literals_start ++ "\n" ++ loop_text.check ++ "\n" ++ loop_text.literals_group ++ "\n" ++
    put("x24", "x20") ++ loop_text.literals_rest ++ "\n" ++ put("x24", "x20") ++ "    b 31b\n" ++
    loop_text.distance ++ "\n" ++ put("x23", "x24") ++ "    b 1b\n" ++ loop_text.exit ++ "\n", arguments);

const arguments = .{
    .commands = @offsetOf(State, "commands"),
    .input = @offsetOf(State, "input"),
    .input_len = @offsetOf(State, "input_len"),
    .count = @offsetOf(State, "count"),
    .room_end = @offsetOf(State, "room_end"),
    .literal_lengths = @offsetOf(State, "literal_lengths"),
    .command_lengths = @offsetOf(State, "command_lengths"),
    .distance_codes = @offsetOf(State, "distance_codes"),
    .distance_extra_bits = @offsetOf(State, "distance_extra_bits"),
    .failed = @offsetOf(State, "failed"),
    .produced = @offsetOf(State, "produced"),
    .buffer = @offsetOf(State, "buffer"),
    .room = @offsetOf(State, "room"),
    .store_len = codec.BitWriter.store_len,
    .command_bits_max = constants.encoder_command_bits_max,
    .symbol_bits = encoder_commands.symbol_bits,
    .put_bits_max = constants.encoder_put_bits_max,
    .chunk_len = constants.encoder_literal_chunk_len,
    .last_distance_symbols = constants.insert_copy_last_distance_symbols,
    .code_at = @bitSizeOf(u32) + encoder_commands.symbol_bits,
    .code_bits = @bitSizeOf(u16) - encoder_commands.symbol_bits,
};

comptime {
    // The fields `ldp` loads and `stp` stores in pairs are adjacent.
    for ([_][2][]const u8{
        .{ "commands", "commands_end" },          .{ "input", "produced" },                  .{ "input_len", "buffer" },
        .{ "count", "room" },                     .{ "room_end", "literal_codes" },          .{ "literal_lengths", "command_codes" },
        .{ "command_lengths", "symbol_lengths" }, .{ "distance_codes", "distance_lengths" },
    }) |pair| assert(@offsetOf(State, pair[1]) == @offsetOf(State, pair[0]) + @sizeOf(u64));
    // Symbol lengths of 6 octets: the bases at 0 and 2, the extra bits at 4 and 5.
    const Lengths = encoder_commands.SymbolLengths;
    assert(@sizeOf(Lengths) == 6 and @offsetOf(Lengths, "copy_base") == 2);
    assert(@offsetOf(Lengths, "insert_extra_bits") == 4 and @offsetOf(Lengths, "copy_extra_bits") == 5);
    // A command's fields at bits 0, 16, 32 and 48, the code above the symbol's 10 bits.
    assert(@offsetOf(Command, "copy_len") == 2 and @offsetOf(Command, "symbol_and_code") == 4 and @offsetOf(Command, "distance_extra") == 6);
    // A distance's code and extra bits fit one put, and so do 3 literals.
    assert(constants.code_len_max + constants.window_bits_max - 1 <= constants.encoder_put_bits_max);
    assert(constants.encoder_literals_per_put == 3 and 3 * constants.code_len_max <= constants.encoder_put_bits_max);
    // The chunk's room: 15 bits a literal, a shift by 4 less one.
    assert(constants.code_len_max == 15);
}
