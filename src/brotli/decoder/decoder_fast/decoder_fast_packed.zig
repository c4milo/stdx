//! The tables the aarch64 loop of `decoder_fast_aarch64.zig` reads, packed at comptime from RFC
//! 7932's: each insert-and-copy symbol's codes, the short distance codes, the parts p1 and p2 give a
//! context ID, and the extra bits and base of each coded distance code for each NPOSTFIX.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const context = @import("../../context.zig");
const commands = @import("../decoder_commands.zig");
const state_module = @import("../decoder_state.zig");
const prefix = @import("../../prefix.zig");

/// Where a command's packed codes hold each value: the first insert length in the low 16 bits, then
/// the first copy length, the insert length's extra bits, both lengths' extra bits, the insert code
/// and the copy code, and in the top bit whether the symbol reuses the last distance.
pub const copy_base_at = 16;
pub const insert_extra_bits_at = 32;
pub const extra_bits_at = 40;
pub const insert_code_at = 48;
pub const copy_code_at = 56;
pub const last_distance_at = @bitSizeOf(u64) - 1;
/// The copy code's bits: its octet less the top bit.
pub const copy_code_bits = last_distance_at - copy_code_at;

/// The evaluation the packed tables take at comptime.
const packed_tables_quota = 20_000;

/// Each insert-and-copy symbol's codes (RFC 7932 §5), packed for one load; a symbol below 128
/// reuses the last distance.
pub const command_codes: [constants.insert_copy_alphabet_len]u64 = codes: {
    @setEvalBranchQuota(packed_tables_quota);
    var table: [constants.insert_copy_alphabet_len]u64 = undefined;
    for (&table, commands.command_codes, 0..) |*out, code, symbol| {
        assert(code.insert_base < 1 << copy_base_at and code.copy_base < 1 << copy_base_at);
        assert(code.copy_code < 1 << copy_code_bits);
        const last_distance: u64 = @intFromBool(symbol < constants.insert_copy_last_distance_symbols);
        out.* = code.insert_base | @as(u64, code.copy_base) << copy_base_at | @as(u64, code.insert_extra_bits) << insert_extra_bits_at |
            @as(u64, code.extra_bits) << extra_bits_at | @as(u64, code.insert_code) << insert_code_at | @as(u64, code.copy_code) << copy_code_at |
            last_distance << last_distance_at;
    }
    break :codes table;
};

/// Where a short distance code's delta sits in its packed form, as a signed octet; the last distance
/// it takes sits in the low bits (RFC 7932 §4).
pub const short_delta_at = 8;

pub const short_codes: [constants.distance_short_codes_count]u64 = codes: {
    var table: [constants.distance_short_codes_count]u64 = undefined;
    for (&table, constants.distance_short_codes) |*out, code| {
        out.* = @as(u64, code.last) | @as(u64, @as(u8, @bitCast(@as(i8, code.delta)))) << short_delta_at;
    }
    break :codes table;
};

/// The parts p1 and p2 give a context ID in each mode (RFC 7932 §7.1), one table per part.
pub const context_luts: [@typeInfo(context.Mode).@"enum".fields.len][context_parts][constants.lut_len]u8 = luts: {
    @setEvalBranchQuota(packed_tables_quota);
    var luts: [@typeInfo(context.Mode).@"enum".fields.len][context_parts][constants.lut_len]u8 = undefined;
    for (std.enums.values(context.Mode)) |mode| {
        for (0..constants.lut_len) |value| {
            luts[@intFromEnum(mode)][0][value] = context.p1_part(mode, @intCast(value));
            luts[@intFromEnum(mode)][1][value] = context.p2_part(mode, @intCast(value));
        }
    }
    break :luts luts;
};

/// The parts of a context ID: p1's and p2's (RFC 7932 §7.1).
pub const context_parts = 2;

/// A coded distance code's entry: its extra bits in the low octet, and above them the part of its
/// distance that NDIRECT and the extra bits leave, ((offset << NPOSTFIX) + lcode) (RFC 7932 §4),
/// so that the distance is the base, the extra bits shifted by NPOSTFIX, NDIRECT and 1. Indexed by
/// the code less 16 and NDIRECT, from `coded_distances_first[NPOSTFIX]`.
pub const coded_distance_base_at = @bitSizeOf(u8);

/// Where each NPOSTFIX's entries start: 48 << NPOSTFIX each (RFC 7932 §4).
pub const coded_distances_first: [constants.postfix_bits_max + 1]usize = first: {
    var first: [constants.postfix_bits_max + 1]usize = undefined;
    var at: usize = 0;
    for (&first, 0..) |*out, postfix_bits| {
        out.* = at;
        at += constants.distance_code_groups << postfix_bits;
    }
    break :first first;
};
const coded_distances_len = coded_distances_first[constants.postfix_bits_max] + (constants.distance_code_groups << constants.postfix_bits_max);

pub const coded_distances: [coded_distances_len]u64 = entries: {
    @setEvalBranchQuota(packed_tables_quota);
    var entries: [coded_distances_len]u64 = undefined;
    for (coded_distances_first, 0..) |first, postfix_bits| {
        for (0..constants.distance_code_groups << postfix_bits) |index| {
            const extra_bits = 1 + (index >> (postfix_bits + 1));
            const high = index >> postfix_bits;
            const low = index & ((1 << postfix_bits) - 1);
            const offset = ((constants.coded_distance_base + (high & 1)) << extra_bits) - constants.coded_distance_bias;
            assert(extra_bits <= constants.distance_extra_bits_max);
            entries[first + index] = @as(u64, (offset << postfix_bits) + low) << coded_distance_base_at | extra_bits;
        }
    }
    break :entries entries;
};

test "the packed command codes hold each symbol's codes, and whether it reuses the last distance" {
    const testing = std.testing;
    for (command_codes, commands.command_codes, 0..) |word, code, symbol| {
        try testing.expectEqual(code.insert_base, @as(u32, @truncate(word & std.math.maxInt(u16))));
        try testing.expectEqual(code.copy_base, @as(u32, @truncate((word >> copy_base_at) & std.math.maxInt(u16))));
        try testing.expectEqual(code.insert_extra_bits, @as(u5, @truncate(word >> insert_extra_bits_at)));
        try testing.expectEqual(code.extra_bits, @as(u6, @truncate(word >> extra_bits_at)));
        try testing.expectEqual(code.insert_code, @as(u8, @truncate(word >> insert_code_at)));
        try testing.expectEqual(code.copy_code, @as(u8, @truncate((word >> copy_code_at) & ((1 << copy_code_bits) - 1))));
        try testing.expectEqual(symbol < constants.insert_copy_last_distance_symbols, word >> last_distance_at == 1);
    }
}

test "the packed short codes hold each code's last distance and delta" {
    const testing = std.testing;
    for (short_codes, constants.distance_short_codes) |word, code| {
        try testing.expectEqual(code.last, @as(u2, @truncate(word)));
        try testing.expectEqual(code.delta, @as(i3, @intCast(@as(i8, @bitCast(@as(u8, @truncate(word >> short_delta_at)))))));
    }
}

test "the context luts give each mode's context ID" {
    const testing = std.testing;
    for (std.enums.values(context.Mode)) |mode| {
        for (0..constants.lut_len) |p1| {
            for ([_]usize{ 0, 1, 100, 200, 255 }) |p2| {
                const id = context_luts[@intFromEnum(mode)][0][p1] | context_luts[@intFromEnum(mode)][1][p2];
                try testing.expectEqual(context.literal_id(mode, @intCast(p1), @intCast(p2)), @as(u6, @intCast(id)));
            }
        }
    }
}

test "each coded distance code's entry gives the checked path's extra bits and distance" {
    const testing = std.testing;
    var state: state_module.State = undefined;
    for (0..constants.postfix_bits_max + 1) |postfix_bits| {
        for ([_]u8{ 0, 1, 8, constants.direct_count_max }) |direct_high| {
            state.postfix_bits = @intCast(postfix_bits);
            state.direct_count = @intCast(@min(direct_high << @intCast(postfix_bits), constants.direct_count_max));
            const first = constants.distance_short_codes_count + @as(u32, state.direct_count);
            for (0..@as(usize, constants.distance_code_groups) << @intCast(postfix_bits)) |index| {
                const entry = coded_distances[coded_distances_first[postfix_bits] + index];
                const code: u32 = first + @as(u32, @intCast(index));
                const extra_bits = commands.distance_extra_bits(&state, code);
                try testing.expectEqual(@as(u64, extra_bits), entry & std.math.maxInt(u8));
                const mask = (@as(u32, 1) << extra_bits) - 1;
                for ([_]u32{ 0, 1, mask >> 1, mask }) |extra| {
                    const base = entry >> coded_distance_base_at;
                    const distance = base + (@as(u64, extra & mask) << @intCast(postfix_bits)) + state.direct_count + 1;
                    try testing.expectEqual(@as(u64, try commands.distance_of(&state, code, extra & mask)), distance);
                }
            }
        }
    }
}

/// The table of the distance code each distance context takes under a distance block type (RFC
/// 7932 §7.3), which the header read below NTREESD: one pointer a context, so that a loop takes a
/// distance's table with one load.
pub fn distance_context_tables(state: *const state_module.State, block_type: usize) [constants.distance_contexts_count][*]const prefix.Entry {
    var tables: [constants.distance_contexts_count][*]const prefix.Entry = undefined;
    const row = state.distance_context_map[block_type * constants.distance_contexts_count ..][0..constants.distance_contexts_count];
    for (&tables, row) |*table, tree| table.* = &state.distance_codes[tree].entries;
    return tables;
}
