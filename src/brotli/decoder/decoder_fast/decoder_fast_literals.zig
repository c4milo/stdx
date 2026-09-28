//! The brotli fast path's literal runs (decision 16): the literals of a command's insert, each with
//! the tree its context picks (RFC 7932 §7.1, §7.3), in one loop per context mode, with the loop's
//! state of decoder_fast.zig. A literal takes its table in one load, from the tables of its block
//! type's contexts, and in UTF8 mode its context from the entry of the literal before it.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const context = @import("../../context.zig");
const Claims = @import("../../claims.zig").Claims;
const state_module = @import("../decoder_state.zig");
const commands = @import("../decoder_commands.zig");
const fast = @import("decoder_fast.zig");
const State = state_module.State;
const Loop = fast.Loop;
const refill = fast.refill;
const produce = fast.produce;

pub const LiteralTable = @TypeOf(@as(State, undefined).literal_codes[0]);

/// The literal table of each context of the literal block type `block_type`, looked up once for
/// each block type the loop meets, so that a literal takes its table in one load. It stays apart
/// from `Loop`, whose fields the compiler keeps in registers only while no array indexed at run
/// time lies among them.
pub const LiteralTables = struct {
    tables: [constants.literal_contexts_count]*const LiteralTable = undefined,
    block_type: ?u8 = null,
};

/// Up to `chunk_len_max` literals of the current block, each with the tree its context picks (RFC
/// 7932 §7.1, §7.3), refilling while the input's margin holds; and the phase after the command's
/// last literal.
pub inline fn literals(comptime claims: Claims, loop: *Loop, literal_tables: *LiteralTables, state: *State) void {
    assert(state.command.insert_left > 0);
    const blocks = commands.blocks_of(state, .literal);
    const block_type = blocks.type_current;
    if (literal_tables.block_type != block_type) look_up_literal_tables(literal_tables, state, block_type);
    const batch = @min(state.command.insert_left, blocks.count_left, constants.chunk_len_max);
    const written = switch (state.context_modes[block_type]) {
        inline else => |mode| literal_run(claims, mode, loop, &literal_tables.tables, batch),
    };
    assert(written >= 1);
    if (blocks.types_count >= constants.block_switch_types_min) blocks.count_left -= written;
    state.command.insert_left -= written;
    produce(state, written);
    if (state.command.insert_left == 0) state.phase = commands.after_literals(state);
}

/// The literal table of each context of `block_type`, from its row of the literal context map (RFC
/// 7932 §7.3).
fn look_up_literal_tables(literal_tables: *LiteralTables, state: *const State, block_type: u8) void {
    const row = state.literal_context_map[@as(usize, block_type) * constants.literal_contexts_count ..][0..constants.literal_contexts_count];
    for (&literal_tables.tables, row) |*table, tree| table.* = &state.literal_codes[tree];
    literal_tables.block_type = block_type;
}

/// Writes up to `batch` literals under one context mode, and returns how many. The first finds the
/// bits a refill left; each later one refills first when the input's margin allows it. A literal
/// table's value holds the literal in its low octet.
inline fn literal_run(comptime claims: Claims, comptime mode: context.Mode, loop: *Loop, tables: *const [constants.literal_contexts_count]*const LiteralTable, batch: u32) u32 {
    if (mode == .utf8) return utf8_run(claims, loop, tables, batch);
    const out = loop.output[loop.written..][0..batch];
    for (out, 0..) |*octet, index| {
        if (loop.count < constants.code_len_max) {
            if (!loop.has_input_margin()) {
                loop.written += index;
                return @intCast(index);
            }
            refill(claims, loop);
        }
        const literal: u8 = @truncate(loop.decode(tables[context.literal_id(mode, loop.p1, loop.p2)]));
        octet.* = literal;
        loop.p2 = loop.p1;
        loop.p1 = literal;
    }
    loop.written += batch;
    return batch;
}

/// As `literal_run`, in UTF8 mode: the context ID is Lut0 of p1 and Lut1 of p2 (RFC 7932 §7.1),
/// which each literal's entry holds above it (`context.literal_entry_value`), so the next ID comes
/// from the entry with no Lut load.
inline fn utf8_run(comptime claims: Claims, loop: *Loop, tables: *const [constants.literal_contexts_count]*const LiteralTable, batch: u32) u32 {
    const lut0_mask = (1 << constants.literal_context_bits) - 1;
    // The Lut values of p1, as an entry holds them above its literal, and Lut1 of p2.
    var p1_luts: u8 = context.lut0[loop.p1] | context.lut1[loop.p1] << (context.entry_lut1_shift - context.entry_lut0_shift);
    var p2_lut1: u8 = context.lut1[loop.p2];
    const out = loop.output[loop.written..][0..batch];
    for (out, 0..) |*octet, index| {
        if (loop.count < constants.code_len_max) {
            if (!loop.has_input_margin()) {
                loop.written += index;
                return @intCast(index);
            }
            refill(claims, loop);
        }
        const value = loop.decode(tables[(p1_luts & lut0_mask) | p2_lut1]);
        const literal: u8 = @truncate(value);
        octet.* = literal;
        p2_lut1 = p1_luts >> (context.entry_lut1_shift - context.entry_lut0_shift);
        p1_luts = @truncate(value >> context.entry_lut0_shift);
        loop.p2 = loop.p1;
        loop.p1 = literal;
    }
    loop.written += batch;
    return batch;
}
