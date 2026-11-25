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
const encoder_write = @import("encoder_write/encoder_write.zig");

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
pub fn write_compressed(comptime safety: bool, writer: *codec.BitWriter, input: []const u8, commands: anytype, codes: *Codes, last: bool) Error!void {
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
    try encoder_write.write_commands(safety, writer, input, commands, codes);
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
pub fn write_header(writer: *codec.BitWriter, len: usize, last: bool, uncompressed: bool) Error!void {
    try put(writer, @intFromBool(last), 1);
    if (last) try put(writer, 0, 1);
    try put(writer, constants.encoder_length_nibbles - constants.nibbles_min, constants.nibbles_field_bits);
    try put(writer, len - 1, constants.encoder_length_nibbles * constants.nibble_bits);
    if (!last) try put(writer, @intFromBool(uncompressed), 1);
}

pub fn build_codes(commands: anytype, codes: *Codes) void {
    // A code needs a symbol; a meta-block of no literals or no distances codes one it never uses.
    var literal_counts = commands.literal_counts;
    var distance_counts = commands.distance_counts;
    if (commands.literals_len == 0) literal_counts[0] = 1;
    distance_counts[0] += 1;
    encoder_prefix.build(constants.literal_alphabet_len, &literal_counts, &codes.literal);
    encoder_prefix.build(constants.insert_copy_alphabet_len, &commands.command_counts, &codes.command);
    encoder_prefix.build(constants.encoder_distance_alphabet_len, &distance_counts, &codes.distance);
}

fn put(writer: *codec.BitWriter, value: u64, count: u7) Error!void {
    if (!writer.make_room(count)) return error.NoSpaceLeft;
    writer.put(value, count);
}
