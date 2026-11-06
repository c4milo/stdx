//! A meta-block of level 1 (decision 62, RFC 7932 §9.2, §9.3): one block type of each category, no
//! context modeling, NPOSTFIX and NDIRECT 0, and one prefix code each for the literals, the
//! insert-and-copy symbols and the distances, built from the meta-block's own counts.
//!
//! A meta-block that codes to no fewer octets than its input goes out uncompressed. RFC 7932 §9.2
//! gives ISUNCOMPRESSED to a meta-block that is not the last, so an uncompressed one is never the
//! stream's last: an empty last meta-block follows it.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const encoder_prefix = @import("encoder_prefix.zig");
const encoder_commands = @import("encoder_commands.zig");

pub const Error = encoder_prefix.Error;

const LiteralCode = encoder_prefix.Code(constants.literal_alphabet_len);
const CommandCode = encoder_prefix.Code(constants.insert_copy_alphabet_len);
const DistanceCode = encoder_prefix.Code(constants.encoder_distance_alphabet_len);

/// The codes a meta-block builds.
pub const Codes = struct {
    literal: LiteralCode,
    command: CommandCode,
    distance: DistanceCode,
};

/// Writes the commands of `input`, a meta-block's octets, as a compressed meta-block; `last` sets
/// ISLAST. The caller compares what it wrote with `input`'s length.
pub fn write_compressed(writer: *codec.BitWriter, input: []const u8, commands: *const encoder_commands.Commands, codes: *Codes, last: bool) Error!void {
    assert(input.len > 0 and input.len <= constants.encoder_meta_block_len_max);
    build_codes(commands, codes);
    try write_header(writer, input.len, last, false);
    // RFC 7932 §9.2: NBLTYPESL, NBLTYPESI and NBLTYPESD of 1 take one 0 bit each; then NPOSTFIX
    // and NDIRECT 0, one context mode, and NTREESL and NTREESD of 1.
    try put(writer, 0, constants.encoder_count_one_bits * constants.block_categories);
    try put(writer, 0, constants.postfix_field_bits + constants.direct_field_bits);
    try put(writer, 0, constants.context_mode_bits);
    try put(writer, 0, constants.encoder_count_one_bits * constants.encoder_tree_counts);
    try encoder_prefix.write(constants.literal_alphabet_len, writer, &codes.literal, constants.literal_alphabet_bits);
    try encoder_prefix.write(constants.insert_copy_alphabet_len, writer, &codes.command, constants.insert_copy_alphabet_bits);
    try encoder_prefix.write(constants.encoder_distance_alphabet_len, writer, &codes.distance, constants.encoder_distance_alphabet_bits);
    try write_commands(writer, input, commands, codes);
}

/// Writes `input` as an uncompressed meta-block, which is never the last (RFC 7932 §9.2).
pub fn write_uncompressed(writer: *codec.BitWriter, input: []const u8) Error!void {
    assert(input.len > 0 and input.len <= constants.encoder_meta_block_len_max);
    try write_header(writer, input.len, false, true);
    // RFC 7932 §9.2: the bits to the octet boundary are zeros, and the octets follow.
    try put(writer, 0, writer.bits_to_octet());
    if (!writer.drain()) return error.NoSpaceLeft;
    try writer.writer.write_all(input);
}

/// The empty last meta-block: ISLAST and ISLASTEMPTY, then zeros to the octet's end (RFC 7932
/// §9.2).
pub fn write_empty_last(writer: *codec.BitWriter) Error!void {
    try put(writer, constants.encoder_last_empty_flags, constants.last_flags_bits);
    try put(writer, 0, writer.bits_to_octet());
}

/// An empty metadata meta-block, which brings the stream to an octet boundary for a flush: MNIBBLES
/// 0, the reserved bit, MSKIPBYTES 0, and zeros to the octet's end (RFC 7932 §9.2).
pub fn write_flush(writer: *codec.BitWriter) Error!void {
    try put(writer, 0, 1);
    try put(writer, constants.nibbles_metadata_code, constants.nibbles_field_bits);
    try put(writer, 0, 1 + constants.skip_bytes_field_bits);
    try put(writer, 0, writer.bits_to_octet());
}

/// ISLAST, ISLASTEMPTY for a last one, MNIBBLES, MLEN - 1, and ISUNCOMPRESSED for one that is not
/// the last (RFC 7932 §9.2). MLEN - 1 of a meta-block of 65,536 octets or fewer takes 4 nibbles.
fn write_header(writer: *codec.BitWriter, len: usize, last: bool, uncompressed: bool) Error!void {
    try put(writer, @intFromBool(last), 1);
    if (last) try put(writer, 0, 1);
    try put(writer, constants.encoder_length_nibbles - constants.nibbles_min, constants.nibbles_field_bits);
    try put(writer, len - 1, constants.encoder_length_nibbles * constants.nibble_bits);
    if (!last) try put(writer, @intFromBool(uncompressed), 1);
}

fn build_codes(commands: *const encoder_commands.Commands, codes: *Codes) void {
    // A code needs a symbol; a meta-block of no literals or no distances codes one it never uses.
    var literal_counts = commands.literal_counts;
    var distance_counts = commands.distance_counts;
    if (commands.literals_len == 0) literal_counts[0] = 1;
    distance_counts[0] += 1;
    encoder_prefix.build(constants.literal_alphabet_len, &literal_counts, &codes.literal);
    encoder_prefix.build(constants.insert_copy_alphabet_len, &commands.command_counts, &codes.command);
    encoder_prefix.build(constants.encoder_distance_alphabet_len, &distance_counts, &codes.distance);
}

/// The commands in order: each one's symbol, its extra bits, its literals from `input`, and its
/// distance where the symbol does not leave it out and the meta-block does not end at its
/// literals. It checks the room once a command and once a chunk of literals, then puts each code
/// with no check of its own, and writes the bit buffer's octets eight at a time.
fn write_commands(writer: *codec.BitWriter, input: []const u8, commands: *const encoder_commands.Commands, codes: *const Codes) Error!void {
    var produced: usize = 0;
    for (commands.commands[0..commands.count]) |command| {
        const coded = encoder_commands.coded_of(command);
        try check_room(writer, constants.encoder_command_bits_max);
        put_lengths(writer, &codes.command, coded);
        try write_literals(writer, input[produced..][0..command.insert_len], &codes.literal);
        produced += command.insert_len;
        if (produced == input.len) break;
        produced += command.copy_len;
        if (coded.symbol < constants.insert_copy_last_distance_symbols) continue;
        // A distance's code and extra bits are 15 + 23 bits at most, which one put takes.
        const distance_len: u7 = @intCast(codes.distance.lengths[command.distance_code]);
        put_bits(writer, codes.distance.codes[command.distance_code] | @as(u64, coded.distance_extra) << @intCast(distance_len), distance_len + coded.distance_extra_bits);
    }
    assert(produced == input.len);
}

/// A command's symbol and its insert and copy extra bits: one put when they fit the bit buffer after
/// a store, as they do for all but the longest lengths, else three.
fn put_lengths(writer: *codec.BitWriter, code: *const CommandCode, coded: encoder_commands.Coded) void {
    const symbol_len: u7 = @intCast(code.lengths[coded.symbol]);
    const total = symbol_len + @as(u7, coded.insert_extra_bits) + coded.copy_extra_bits;
    if (total <= codec.constants.ensure_bits_max) {
        const value = code.codes[coded.symbol] | @as(u64, coded.insert_extra) << @intCast(symbol_len) | @as(u64, coded.copy_extra) << @intCast(symbol_len + coded.insert_extra_bits);
        return put_bits(writer, value, total);
    }
    put_bits(writer, code.codes[coded.symbol], symbol_len);
    put_bits(writer, coded.insert_extra, coded.insert_extra_bits);
    put_bits(writer, coded.copy_extra, coded.copy_extra_bits);
}

/// The literals, a chunk at a time. Each check leaves room for a command's other codes after the
/// chunk, so the distance after the last chunk needs none.
fn write_literals(writer: *codec.BitWriter, literals: []const u8, code: *const LiteralCode) Error!void {
    var rest = literals;
    for (0..std.math.divCeil(usize, literals.len, constants.encoder_literal_chunk_len) catch unreachable) |_| {
        const chunk = rest[0..@min(rest.len, constants.encoder_literal_chunk_len)];
        try check_room(writer, chunk.len * constants.code_len_max + constants.encoder_command_bits_max);
        // Two literals a put: their codes together are 30 bits at most.
        for (0..chunk.len / constants.encoder_literals_per_put) |pair| {
            const first = chunk[constants.encoder_literals_per_put * pair];
            const second = chunk[constants.encoder_literals_per_put * pair + 1];
            const first_len: u7 = @intCast(code.lengths[first]);
            put_bits(writer, @as(u64, code.codes[first]) | @as(u64, code.codes[second]) << @intCast(first_len), first_len + @as(u7, @intCast(code.lengths[second])));
        }
        if (chunk.len % constants.encoder_literals_per_put == 1) put_code(constants.literal_alphabet_len, writer, code, chunk[chunk.len - 1]);
        rest = rest[chunk.len..];
    }
}

comptime {
    assert(constants.encoder_literals_per_put * constants.code_len_max <= codec.constants.ensure_bits_max);
    // A distance's code and its extra bits, below WBITS 24's, in one put.
    assert(constants.code_len_max + constants.window_bits_max - 1 <= codec.constants.ensure_bits_max);
}

/// Fails when the output has no room for `bits` more bits beyond those the buffer holds, and for
/// one store past them. A meta-block that fails goes out uncompressed.
fn check_room(writer: *const codec.BitWriter, bits: usize) Error!void {
    const octets = (writer.bits.count + bits) / @bitSizeOf(u8) + codec.BitWriter.store_len;
    if (writer.writer.room_len() < octets) return error.NoSpaceLeft;
}

inline fn put_code(comptime n: usize, writer: *codec.BitWriter, code: *const encoder_prefix.Code(n), symbol: usize) void {
    put_bits(writer, code.codes[symbol], @intCast(code.lengths[symbol]));
}

/// Puts `count` bits, writing the buffer's whole octets first when it has no room. `check_room`
/// made room for the store.
inline fn put_bits(writer: *codec.BitWriter, value: u64, count: u7) void {
    if (!writer.has_room(count)) writer.store();
    writer.put(value, count);
}

fn put(writer: *codec.BitWriter, value: u64, count: u7) Error!void {
    if (!writer.make_room(count)) return error.NoSpaceLeft;
    writer.put(value, count);
}
