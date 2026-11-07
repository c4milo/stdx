//! The tests of decision 63's writers, on the target's own: the assembly and the Zig writer, given
//! one meta-block's commands and codes, agree on whether the output's room runs out, and where it
//! does not, on the octets, the output's position and the bits left in the buffer. The commands
//! come from seeded meta-blocks; the outputs run from too short for a command to room for all.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const encoder = @import("../encoder.zig");
const encoder_commands = @import("../encoder_commands.zig");
const encoder_meta_block = @import("../encoder_meta_block.zig");
const encoder_parse = @import("../encoder_parse/encoder_parse.zig");
const encoder_write = @import("encoder_write.zig");
const aarch64 = @import("encoder_write_aarch64.zig");
const x86_64 = @import("encoder_write_x86_64.zig");

const level = encoder.Encoder(.{ .level = 1, .window_bits = constants.encoder_window_bits_min }).finder_level;

/// The seeded meta-blocks, the octets they draw from, and the output sizes tried: every
/// `room_step`th from the least that holds a store to `encoder_out_len`.
const seeds = 8;
const block_len = 4096;
/// The long meta-block: a command of an insert and a copy with 24 extra bits each, beside random
/// commands of many symbols, so its symbol's code is long enough that the three pass one put.
const long_len = constants.encoder_meta_block_len_max;
const long_insert = 23_000;
const long_copy = 2_200;
const long_room_step = 4093;
/// The sizes, every one, that end inside the long insert's chunks of 64 literals.
const long_room_fine = 4000;
const random_insert_max = 40;
const random_copy_max = 40;
const literal_values = 24;
const copy_len_max = 40;
const room_step = 37;
/// The bits the header left, which the writer's first store takes: none, a few below an octet,
/// the most below one, and more than one.
const few_bits = 3;
const most_bits = 7;
const over_octet_bits = 13;
const start_bits = [_]u7{ 0, few_bits, most_bits, over_octet_bits };
/// The assembly's and the Zig writer's.
const sides = 2;

threadlocal var window: [long_len]u8 = undefined;
threadlocal var matcher: codec.match_finder.Matcher(level) = undefined;
threadlocal var commands: encoder_commands.Commands = undefined;
threadlocal var codes: encoder_meta_block.Codes = undefined;
threadlocal var outputs: [sides][constants.encoder_out_len]u8 = undefined;

test "the assembly writes the octets, position and bits of the Zig writer, or runs out with it" {
    if (comptime !aarch64.takes and !x86_64.takes) return error.SkipZigTest;
    // The first seed tries every output size, so a room test's place shows; the rest a few.
    for (0..seeds) |seed| {
        fill(seed);
        matcher.init();
        commands.init();
        commands.reset();
        encoder_parse.parse(level, true, &matcher, &window, 0, block_len, &commands);
        try expect_block(block_len, if (seed == 0) 1 else room_step, constants.encoder_out_len);
    }
    // The writer reads only the inserts' octets, so the commands need not copy what they name.
    var generator = codec.split.Generator.init(seeds);
    for (&window) |*octet| octet.* = @truncate(generator.next());
    commands.init();
    commands.reset();
    commands.add(true, &window, 0, long_insert, long_copy, long_insert);
    var at: usize = long_insert + long_copy;
    for (0..long_len) |_| {
        if (at + random_insert_max + random_copy_max > long_len) break;
        const position = at + generator.between(0, random_insert_max);
        const copy = generator.between(constants.copy_length_codes[0].base, random_copy_max);
        commands.add(true, &window, at, position, copy, generator.between(1, position));
        at = position + copy;
    }
    commands.add_literals(true, window[at..long_len]);
    try expect_block(long_len, long_room_step, constants.encoder_out_len);
    try expect_block(long_len, 1, long_room_fine);
}

fn expect_block(len: usize, step: usize, room_max: usize) !void {
    if (commands.inserted < commands.literals_len) commands.close();
    encoder_meta_block.build_codes(&commands, &codes);
    for (start_bits) |bits| try expect_rooms(window[0..len], bits, step, room_max);
}

fn expect_rooms(input: []const u8, start: u7, step: usize, room_max: usize) !void {
    var room: usize = codec.BitWriter.store_len;
    for (0..room_max) |_| {
        if (room > room_max) break;
        var writers: [sides]codec.BitWriter = undefined;
        for (&writers, &outputs) |*writer, *output| {
            writer.* = codec.BitWriter.init(output[0..room], .{});
            writer.put(0, start);
        }
        const got = encoder_write.write_commands(true, &writers[0], input, &commands, &codes);
        const want = encoder_write.write_zig(true, &writers[1], input, &commands, &codes);
        if (want) |_| {
            try got;
            try testing.expectEqual(writers[1].writer.position, writers[0].writer.position);
            try testing.expectEqualSlices(u8, outputs[1][0..writers[1].writer.position], outputs[0][0..writers[0].writer.position]);
            try testing.expectEqual(writers[1].bits.buffer, writers[0].bits.buffer);
            try testing.expectEqual(writers[1].bits.count, writers[0].bits.count);
        } else |err| try testing.expectError(err, got);
        room += step;
    }
}

/// A meta-block of literals from a small alphabet and copies of earlier octets.
fn fill(seed: u64) void {
    var generator = codec.split.Generator.init(seed);
    var at: usize = 0;
    for (0..block_len) |_| {
        if (at == block_len) break;
        const len = @min(generator.between(1, copy_len_max), block_len - at);
        const copy = at > copy_len_max and generator.between(0, 1) == 0;
        const distance = if (copy) generator.between(1, at) else 0;
        for (window[at..][0..len], at..) |*octet, index| {
            octet.* = if (copy) window[index - distance] else @intCast(generator.between(0, literal_values - 1));
        }
        at += len;
    }
}
