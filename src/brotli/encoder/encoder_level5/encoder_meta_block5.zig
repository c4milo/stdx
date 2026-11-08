//! A meta-block of level 5 (decision 62, RFC 7932 §9.2): the literals in the blocks of
//! encoder_split.zig, each block type with a prefix code of its own, and one block type of
//! insert-and-copy lengths and of distances, with NPOSTFIX and NDIRECT 0.
//!
//! The literal context map gives each block type's 64 contexts its own tree, so the context mode
//! does not change a literal's code, and each type takes LSB6. With the inverse move-to-front
//! transform the map is a value and a run of zeros a type (RFC 7932 §7.3).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const encoder_prefix = @import("../encoder_prefix.zig");
const encoder_meta_block = @import("../encoder_meta_block.zig");
const encoder_commands = @import("../encoder_commands.zig");
const encoder_write = @import("../encoder_write/encoder_write.zig");
const encoder_split = @import("encoder_split.zig");
const context = @import("../../context.zig");

pub const Error = encoder_prefix.Error;

const types_max = encoder_split.types_max;
const run_codes = constants.encoder_level5.map_run_length_codes;
const LiteralCode = encoder_prefix.Code(constants.literal_alphabet_len);
const CommandCode = encoder_prefix.Code(constants.insert_copy_alphabet_len);
const DistanceCode = encoder_prefix.Code(constants.encoder_distance_alphabet_len);
const TypeCode = encoder_prefix.Code(constants.block_type_alphabet_len_max);
const CountCode = encoder_prefix.Code(constants.block_count_alphabet_len);
const MapCode = encoder_prefix.Code(constants.trees_max + run_codes);

/// The codes a meta-block builds, its literal blocks and their switches.
pub const Codes = struct {
    literals: [types_max]LiteralCode,
    /// The code of all the literals, which a split must take fewer bits than.
    one: LiteralCode,
    command: CommandCode,
    distance: DistanceCode,
    block_type: TypeCode,
    block_count: CountCode,
    map: MapCode,
    split: encoder_split.Split,
    switch_values: [encoder_split.chunks_max]u64,
    switch_lens: [encoder_split.chunks_max]u8,
};

/// Writes the commands of `input`, the meta-block of `window[start..]`, as a compressed
/// meta-block; `last` sets ISLAST.
pub fn write_compressed(comptime safety: bool, writer: *codec.BitWriter, window: []const u8, start: usize, input: []const u8, commands: anytype, codes: *Codes, last: bool) Error!void {
    assert(input.len > 0 and input.len <= constants.encoder_meta_block_len_max);
    encoder_split.split(safety, &codes.split, window, start, commands);
    build_codes(commands, codes);
    const types_count = codes.split.types_count;
    try encoder_meta_block.write_header(writer, input.len, last, false);
    try write_count(writer, types_count);
    if (types_count >= constants.block_switch_types_min) try write_switch_codes(writer, codes);
    // RFC 7932 §9.2: NBLTYPESI and NBLTYPESD of 1, then NPOSTFIX and NDIRECT 0.
    try put(writer, 0, constants.encoder_count_one_bits * (constants.block_categories - 1));
    try put(writer, 0, constants.postfix_field_bits + constants.direct_field_bits);
    for (0..types_count) |_| try put(writer, @intFromEnum(context.Mode.lsb6), constants.context_mode_bits);
    try write_count(writer, types_count);
    if (types_count >= constants.context_map_trees_min) try write_map(writer, &codes.map, types_count);
    // NTREESD of 1.
    try put(writer, 0, constants.encoder_count_one_bits);
    for (codes.literals[0..types_count]) |*code| try encoder_prefix.write(constants.literal_alphabet_len, writer, code, constants.literal_alphabet_bits);
    try encoder_prefix.write(constants.insert_copy_alphabet_len, writer, &codes.command, constants.insert_copy_alphabet_bits);
    try encoder_prefix.write(constants.encoder_distance_alphabet_len, writer, &codes.distance, constants.encoder_distance_alphabet_bits);
    const blocks: encoder_write.Blocks = .{
        .types = &codes.split.block_types,
        .lens = &codes.split.block_lens,
        .switch_values = &codes.switch_values,
        .switch_lens = &codes.switch_lens,
        .count = codes.split.blocks_count,
    };
    try encoder_write.write_split(safety, writer, input, commands, codes, &blocks);
}

/// Sets the parse's literal cost from this meta-block's literals: the mean length of its code
/// when it has one block type, else their entropy under one code. The mean over the blocks' codes
/// is lower than what the octets a match covers cost, and with it the parse took 23% more
/// literals on kennedy.xls, for 21% more octets.
pub fn weigh_literals(commands: anytype, codes: *const Codes) void {
    if (commands.literals_len == 0) return;
    if (codes.split.types_count == 1) return commands.weigh_literals(&codes.literals[0].lengths);
    const len: u32 = @intCast(commands.literals_len);
    const whole = encoder_split.log2_scaled(len);
    var bits: u64 = 0;
    for (commands.literal_counts) |count| {
        if (count > 0) bits += @as(u64, count) * (whole - encoder_split.log2_scaled(count));
    }
    commands.literal_cost = @intCast((bits * encoder_commands.eighths >> constants.encoder_level5.split_cost_shift) / len);
}

fn build_codes(commands: anytype, codes: *Codes) void {
    const split = &codes.split;
    build_literal_codes(codes);
    if (split.types_count >= constants.block_switch_types_min) {
        build_switches(codes);
        build_map(&codes.map, split.types_count);
        // The split stays only where it takes fewer bits than one code of every literal.
        encoder_prefix.build(constants.literal_alphabet_len, &commands.literal_counts, &codes.one);
        const one = encoder_prefix.description_bits(constants.literal_alphabet_len, &codes.one, constants.literal_alphabet_bits) + literal_bits(&commands.literal_counts, &codes.one);
        if (split_bits(codes) >= one) {
            encoder_split.make_one(split, &commands.literal_counts);
            build_literal_codes(codes);
        }
    }
    var distance_counts = commands.distance_counts;
    distance_counts[0] += 1;
    encoder_prefix.build(constants.insert_copy_alphabet_len, &commands.command_counts, &codes.command);
    encoder_prefix.build(constants.encoder_distance_alphabet_len, &distance_counts, &codes.distance);
}

fn build_literal_codes(codes: *Codes) void {
    const split = &codes.split;
    for (split.counts[0..split.types_count], codes.literals[0..split.types_count]) |*counts, *code| {
        // A code needs a symbol; a meta-block of no literals codes one it never uses.
        if (split.literals_len == 0) counts[0] = 1;
        encoder_prefix.build(constants.literal_alphabet_len, counts, code);
    }
}

fn literal_bits(counts: *const [constants.literal_alphabet_len]u16, code: *const LiteralCode) u64 {
    var bits: u64 = 0;
    for (counts, code.lengths) |count, len| bits += @as(u64, count) * len;
    return bits;
}

/// The bits the split's literals take past one code's header fields: each type's code and
/// literals, the switch codes, the switches and the context map, priced as `write_map` writes it.
fn split_bits(codes: *const Codes) u64 {
    const split = &codes.split;
    var bits: u64 = 0;
    for (split.counts[0..split.types_count], codes.literals[0..split.types_count]) |*counts, *code| {
        bits += encoder_prefix.description_bits(constants.literal_alphabet_len, code, constants.literal_alphabet_bits) + literal_bits(counts, code) + constants.context_mode_bits;
    }
    for (codes.switch_lens[1..split.blocks_count]) |len| bits += len;
    bits += encoder_prefix.description_bits(constants.block_type_alphabet_len_max, &codes.block_type, type_alphabet_bits(split.types_count));
    bits += encoder_prefix.description_bits(constants.block_count_alphabet_len, &codes.block_count, count_alphabet_bits);
    bits += encoder_prefix.description_bits(constants.trees_max + run_codes, &codes.map, map_alphabet_bits(split.types_count));
    // The map's symbols: type 0's run code and its extra bits, then each later type's value, and
    // its run code with its extra bits.
    const map = &codes.map;
    bits += map.lengths[run_codes] + run_codes;
    for (1..split.types_count) |type_index| bits += map.lengths[run_codes + type_index] + map.lengths[run_codes - 1] + run_codes - 1;
    return bits;
}

fn type_alphabet_bits(types_count: usize) u4 {
    return @intCast(std.math.log2_int_ceil(usize, types_count + constants.block_type_symbol_offset));
}

fn map_alphabet_bits(types_count: usize) u4 {
    return @intCast(std.math.log2_int_ceil(usize, types_count + run_codes));
}

/// The block type code and block count code of the blocks' switches (RFC 7932 §6), and each
/// switch's bits for the writer. The first block's count is in the header and its type is 0.
fn build_switches(codes: *Codes) void {
    const split = &codes.split;
    var type_counts: [constants.block_type_alphabet_len_max]u16 = @splat(0);
    var count_counts: [constants.block_count_alphabet_len]u16 = @splat(0);
    var symbols: Symbols = .{ .types_count = split.types_count };
    count_counts[count_symbol(split.block_lens[0])] += 1;
    for (1..split.blocks_count) |index| {
        type_counts[symbols.next(split.block_types[index])] += 1;
        count_counts[count_symbol(split.block_lens[index])] += 1;
    }
    encoder_prefix.build(constants.block_type_alphabet_len_max, &type_counts, &codes.block_type);
    encoder_prefix.build(constants.block_count_alphabet_len, &count_counts, &codes.block_count);
    symbols = .{ .types_count = split.types_count };
    for (1..split.blocks_count) |index| {
        const type_symbol = symbols.next(split.block_types[index]);
        const len = split.block_lens[index];
        const count = count_symbol(len);
        const type_len = codes.block_type.lengths[type_symbol];
        const count_len = codes.block_count.lengths[count];
        const extra_bits = constants.block_count_codes[count].extra_bits;
        const extra = len - constants.block_count_codes[count].base;
        codes.switch_values[index] = codes.block_type.codes[type_symbol] | @as(u64, codes.block_count.codes[count]) << @intCast(type_len) | @as(u64, extra) << @intCast(type_len + count_len);
        codes.switch_lens[index] = @intCast(type_len + count_len + extra_bits);
    }
}

/// The block type codes of a category's switches (RFC 7932 §6): 0 for the type before the current
/// one, 1 for the current one plus one, else the type plus 2.
const Symbols = struct {
    types_count: usize,
    previous: usize = 1,
    current: usize = 0,

    fn next(self: *Symbols, type_index: usize) usize {
        const symbol = if (type_index == self.previous) 0 else if (type_index == (self.current + 1) % self.types_count) 1 else type_index + constants.block_type_symbol_offset;
        self.previous = self.current;
        self.current = type_index;
        return symbol;
    }
};

/// The block count code whose range holds `len` (RFC 7932 §6).
fn count_symbol(len: u32) usize {
    assert(len >= constants.block_count_codes[0].base);
    var symbol: usize = 0;
    for (constants.block_count_codes, 0..) |code, index| {
        if (code.base <= len) symbol = index;
    }
    return symbol;
}

/// The block type code and block count code, and the first block's count.
fn write_switch_codes(writer: *codec.BitWriter, codes: *const Codes) Error!void {
    try encoder_prefix.write(constants.block_type_alphabet_len_max, writer, &codes.block_type, type_alphabet_bits(codes.split.types_count));
    try encoder_prefix.write(constants.block_count_alphabet_len, writer, &codes.block_count, count_alphabet_bits);
    const len = codes.split.block_lens[0];
    const count = count_symbol(len);
    try put(writer, codes.block_count.codes[count], @intCast(codes.block_count.lengths[count]));
    try put(writer, len - constants.block_count_codes[count].base, constants.block_count_codes[count].extra_bits);
}

/// ALPHABET_BITS of the block count code's 26 symbols (RFC 7932 §3.4).
const count_alphabet_bits = std.math.log2_int_ceil(usize, constants.block_count_alphabet_len);

/// The literal context map, each type's 64 entries its own tree (RFC 7932 §7.3): RLEMAX, the code,
/// then after inverse move-to-front type 0's 64 zeros and each later type's value and 63 zeros.
fn write_map(writer: *codec.BitWriter, map: *const MapCode, types_count: usize) Error!void {
    try put(writer, (run_codes - 1) << 1 | 1, 1 + constants.run_length_field_bits);
    try encoder_prefix.write(constants.trees_max + run_codes, writer, map, map_alphabet_bits(types_count));
    // A type's zeros: 64 after type 0's start, 63 after each later type's value.
    const contexts = constants.literal_contexts_count;
    try put_symbol(writer, map, run_codes, contexts - (1 << run_codes), run_codes);
    for (1..types_count) |type_index| {
        try put_symbol(writer, map, run_codes + type_index, 0, 0);
        try put_symbol(writer, map, run_codes - 1, contexts - 1 - (1 << (run_codes - 1)), run_codes - 1);
    }
    // IMTF.
    try put(writer, 1, 1);
}

/// The code of the context map's symbols: type 0's run of 64 zeros, each later type's value, and
/// its run of 63.
fn build_map(map: *MapCode, types_count: usize) void {
    var counts: [constants.trees_max + run_codes]u16 = @splat(0);
    counts[run_codes] = 1;
    counts[run_codes - 1] = @intCast(types_count - 1);
    for (1..types_count) |type_index| counts[run_codes + type_index] = 1;
    encoder_prefix.build(constants.trees_max + run_codes, &counts, map);
}

fn put_symbol(writer: *codec.BitWriter, code: *const MapCode, symbol: usize, extra: u64, extra_bits: u7) Error!void {
    try put(writer, code.codes[symbol], @intCast(code.lengths[symbol]));
    try put(writer, extra, extra_bits);
}

/// NBLTYPESx or NTREESx (RFC 7932 §9.2): a 0 bit for 1; otherwise 1, three bits n, and n bits of
/// the count less 1 less 2^n.
fn write_count(writer: *codec.BitWriter, count: usize) Error!void {
    assert(count >= 1 and count <= types_max);
    if (count == 1) return put(writer, 0, 1);
    const top: u3 = @intCast(std.math.log2_int(usize, count - 1));
    try put(writer, 1 | @as(u64, top) << 1, 1 + constants.count_field_bits);
    try put(writer, count - 1 - (@as(usize, 1) << top), top);
}

fn put(writer: *codec.BitWriter, value: u64, count: u7) Error!void {
    if (!writer.make_room(count)) return error.NoSpaceLeft;
    writer.put(value, count);
}

const testing = std.testing;

test "a block count takes the code whose range holds it" {
    for (constants.block_count_codes, 0..) |code, index| {
        try testing.expectEqual(index, count_symbol(code.base));
        const last = code.base + (@as(u32, 1) << code.extra_bits) - 1;
        try testing.expectEqual(index, count_symbol(last));
    }
}

test "block type codes name the previous type, the next one with its wrap, or the type" {
    var symbols: Symbols = .{ .types_count = 3 };
    const offset = constants.block_type_symbol_offset;
    // From the current type 0 and the previous 1: type 1 is both, and the previous comes first.
    try testing.expectEqual(0, symbols.next(1));
    // From 1: type 2 is the next one; then from 2, type 0 wraps as the next one.
    try testing.expectEqual(1, symbols.next(2));
    try testing.expectEqual(1, symbols.next(0));
    // From 0 with the previous 2: type 1 is the next one, then 1 again by its number.
    try testing.expectEqual(1, symbols.next(1));
    try testing.expectEqual(offset + 1, symbols.next(1));
}
