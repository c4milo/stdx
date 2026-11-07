//! The commands of a level 1 meta-block, written (RFC 7932 §9.3): each command's insert-and-copy
//! symbol with its extra bits, its literals, and its distance where the symbol does not leave it
//! out. A piece of encoder_meta_block.zig.
//!
//! The loop works on a copy of the bit writer, as DEFLATE's encoder does (decision 14, E5): the
//! buffer, its count and the room left stay in registers. Each put adds at most
//! `constants.encoder_put_bits_max` bits on the fewer than 8 a store leaves, and a store follows
//! it, so no put tests the buffer. The room is checked once a command and once a chunk of
//! literals; a meta-block that runs out goes out uncompressed.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const encoder_commands = @import("../encoder_commands.zig");
const encoder_prefix = @import("../encoder_prefix.zig");
const aarch64 = @import("encoder_write_aarch64.zig");

pub const Error = encoder_prefix.Error;

const store_len = codec.BitWriter.store_len;

/// The writer's state in the loop: the buffer and its count, and the output's room.
const Bits = struct {
    buffer: u64,
    count: usize,
    room: []u8,

    /// Puts `count` bits, `constants.encoder_put_bits_max` at most, then stores the buffer whole:
    /// its whole octets count as written, and fewer than 8 bits stay.
    inline fn put(self: *Bits, comptime safety: bool, value: u64, count: usize) void {
        @setRuntimeSafety(safety);
        self.buffer |= value << @intCast(self.count);
        self.count += count;
        std.mem.writeInt(u64, self.room[0..store_len], self.buffer, .little);
        const whole = self.count / @bitSizeOf(u8);
        self.room = self.room[whole..];
        self.buffer >>= @intCast(whole * @bitSizeOf(u8));
        self.count %= @bitSizeOf(u8);
    }

    /// Fails when the room cannot take `bits` more bits and the store after them.
    inline fn check(self: *const Bits, comptime safety: bool, bits: usize) Error!void {
        @setRuntimeSafety(safety);
        if (self.room.len < (self.count + bits) / @bitSizeOf(u8) + store_len) return error.NoSpaceLeft;
    }
};

comptime {
    // Three literals of the longest code in one put; a distance's code and extra bits, below WBITS
    // 24's, in one put; and a put on the fewer than 8 bits a store leaves fits the buffer.
    assert(constants.encoder_literals_per_put * constants.code_len_max <= constants.encoder_put_bits_max);
    assert(constants.code_len_max + constants.window_bits_max - 1 <= constants.encoder_put_bits_max);
    assert(@bitSizeOf(u8) - 1 + constants.encoder_put_bits_max <= codec.constants.bit_buffer_bits);
}

/// Writes the commands of `input`, a meta-block's octets, through `codes` into `writer`: through
/// the assembly of decision 63 where it takes the target, else through Zig.
pub noinline fn write_commands(comptime safety: bool, writer: *codec.BitWriter, input: []const u8, commands: *const encoder_commands.Commands, codes: anytype) Error!void {
    if (comptime aarch64.takes) return aarch64.write(writer, input, commands, codes);
    return write_zig(safety, writer, input, commands, codes);
}

/// `write_commands` in Zig: the reference the assembly writes the octets of.
pub fn write_zig(comptime safety: bool, writer: *codec.BitWriter, input: []const u8, commands: *const encoder_commands.Commands, codes: anytype) Error!void {
    @setRuntimeSafety(safety);
    // The first store drops the whole octets the header left, so the loop starts below 8 bits.
    if (!writer.has_store_room()) return error.NoSpaceLeft;
    writer.store();
    const octets = writer.writer.octets;
    var bits: Bits = .{ .buffer = writer.bits.buffer, .count = writer.bits.count, .room = octets[writer.writer.position..] };
    var produced: usize = 0;
    for (commands.commands[0..commands.count]) |command| {
        const coded = encoder_commands.coded_of(safety, command);
        try bits.check(safety, constants.encoder_command_bits_max);
        put_lengths(safety, &bits, &codes.command, coded);
        try put_literals(safety, &bits, input[produced..][0..command.insert_len], &codes.literal);
        produced += command.insert_len;
        if (produced == input.len) break;
        produced += command.copy_len;
        if (coded.symbol < constants.insert_copy_last_distance_symbols) continue;
        const code = command.distance_code();
        const code_len: u7 = @intCast(codes.distance.lengths[code]);
        bits.put(safety, codes.distance.codes[code] | @as(u64, coded.distance_extra) << @intCast(code_len), code_len + coded.distance_extra_bits);
    }
    assert(produced == input.len);
    writer.writer.position = octets.len - bits.room.len;
    writer.bits = .{ .buffer = bits.buffer, .count = @intCast(bits.count) };
}

/// A command's symbol and its insert and copy extra bits: one put when they fit one, as they do
/// for all but the longest lengths, else two.
inline fn put_lengths(comptime safety: bool, bits: *Bits, code: anytype, coded: encoder_commands.Coded) void {
    @setRuntimeSafety(safety);
    const symbol_len: usize = code.lengths[coded.symbol];
    const head = code.codes[coded.symbol] | @as(u64, coded.insert_extra) << @intCast(symbol_len);
    const head_len = symbol_len + coded.insert_extra_bits;
    if (head_len + coded.copy_extra_bits <= constants.encoder_put_bits_max) {
        return bits.put(safety, head | @as(u64, coded.copy_extra) << @intCast(head_len), head_len + coded.copy_extra_bits);
    }
    bits.put(safety, head, head_len);
    bits.put(safety, coded.copy_extra, coded.copy_extra_bits);
}

/// The literals, `constants.encoder_literals_per_put` a put, a chunk at a time. Each check leaves
/// room for a command's other codes after the chunk, so the distance after the last chunk needs
/// none.
inline fn put_literals(comptime safety: bool, bits: *Bits, literals: []const u8, code: anytype) Error!void {
    @setRuntimeSafety(safety);
    const per_put = constants.encoder_literals_per_put;
    var rest = literals;
    for (0..std.math.divCeil(usize, literals.len, constants.encoder_literal_chunk_len) catch unreachable) |_| {
        const chunk = rest[0..@min(rest.len, constants.encoder_literal_chunk_len)];
        try bits.check(safety, chunk.len * constants.code_len_max + constants.encoder_command_bits_max);
        const whole = chunk.len / per_put;
        for (0..whole) |index| {
            const group = chunk[index * per_put ..][0..per_put];
            var value: u64 = 0;
            var count: usize = 0;
            inline for (group) |octet| {
                value |= @as(u64, code.codes[octet]) << @intCast(count);
                count += code.lengths[octet];
            }
            bits.put(safety, value, count);
        }
        var value: u64 = 0;
        var count: usize = 0;
        for (chunk[whole * per_put ..]) |octet| {
            value |= @as(u64, code.codes[octet]) << @intCast(count);
            count += code.lengths[octet];
        }
        if (count > 0) bits.put(safety, value, count);
        rest = rest[chunk.len..];
    }
}

test {
    _ = @import("encoder_write_assembly_test.zig");
}
