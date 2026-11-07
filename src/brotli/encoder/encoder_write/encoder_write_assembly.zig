//! What level 1's writers in assembly share (decision 63's amendment): the state their texts read
//! and write, the Zig call around a text, the offsets and constants the texts name, and the
//! comptime asserts that pin the layouts they assume.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const encoder_commands = @import("../encoder_commands.zig");

const Error = error{NoSpaceLeft};
const Command = encoder_commands.Command;

/// The writer's state, as the assembly reads and writes it: every field 8 octets, at the offsets
/// `arguments` names.
pub const State = extern struct {
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
    /// The caller's frame pointer, which x86-64's text keeps in place.
    saved_frame: u64,
};

/// `write_commands` through `execute`, an architecture's text.
pub fn write(comptime execute: fn (*State) void, writer: *codec.BitWriter, input: []const u8, commands: *const encoder_commands.Commands, codes: anytype) Error!void {
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
        .saved_frame = 0,
    };
    assert(state.count < @bitSizeOf(u8));
    execute(&state);
    if (state.failed == 1) return error.NoSpaceLeft;
    assert(state.produced == input.len and state.count < @bitSizeOf(u8));
    writer.writer.position = state.room - octets.ptr;
    assert(writer.writer.position <= octets.len);
    writer.bits = .{ .buffer = state.buffer, .count = @intCast(state.count) };
}

/// The offsets and constants the texts name.
pub const arguments = .{
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
    .commands_end = @offsetOf(State, "commands_end"),
    .literal_codes = @offsetOf(State, "literal_codes"),
    .command_codes = @offsetOf(State, "command_codes"),
    .symbol_lengths = @offsetOf(State, "symbol_lengths"),
    .distance_lengths = @offsetOf(State, "distance_lengths"),
    .saved_frame = @offsetOf(State, "saved_frame"),
    .store_len = codec.BitWriter.store_len,
    .command_bits_max = constants.encoder_command_bits_max,
    .symbol_bits = encoder_commands.symbol_bits,
    .put_bits_max = constants.encoder_put_bits_max,
    .chunk_len = constants.encoder_literal_chunk_len,
    .last_distance_symbols = constants.insert_copy_last_distance_symbols,
    .code_at = @bitSizeOf(u32) + encoder_commands.symbol_bits,
    .code_bits = @bitSizeOf(u16) - encoder_commands.symbol_bits,
    .symbol_mask = std.math.maxInt(u10),
    .code_mask = std.math.maxInt(u6),
};

comptime {
    // The fields aarch64's `ldp` loads and `stp` stores in pairs are adjacent.
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

test {
    _ = @import("encoder_write_assembly_test.zig");
}
