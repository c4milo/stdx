//! The brotli fast path's literal runs (decision 16): the literals of a command's insert, each with
//! the tree its context picks (RFC 7932 §7.1, §7.3), in one loop per context mode, with the loop's
//! state of decoder_fast.zig. A literal takes its table in one load, from the tables of its block
//! type's contexts, and its context ID from the entry of the literal before it
//! (`context.literal_entry_value`). A block type whose contexts all take one tree needs no context
//! ID, and its literals take that tree's table.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const context = @import("../../context.zig");
const Claims = @import("../../claims.zig").Claims;
const state_module = @import("../decoder_state.zig");
const commands = @import("../decoder_commands.zig");
const prefix_reader = @import("../decoder_prefix.zig");
const fast = @import("decoder_fast.zig");
const State = state_module.State;
const Phase = state_module.Phase;
const Loop = fast.Loop;
const refill = fast.refill;
const produce = fast.produce;

pub const LiteralTable = @TypeOf(@as(State, undefined).literal_codes[0]);

/// The literal table of each context of the literal block type `block_type`, looked up once for
/// each block type the loop meets, so that a literal takes its table in one load, and whether every
/// context takes the same tree. It stays apart from `Loop`, whose fields the compiler keeps in
/// registers only while no array indexed at run time lies among them.
pub const LiteralTables = struct {
    tables: [constants.literal_contexts_count]*const LiteralTable = undefined,
    block_type: ?u8 = null,
    one_tree: bool = false,
};

const Tables = [constants.literal_contexts_count]*const LiteralTable;

/// Up to `chunk_len_max` literals of the current block, each with the tree its context picks (RFC
/// 7932 §7.1, §7.3), refilling while the input's margin holds; and the phase after the command's
/// last literal, into `phase`. The caller has checked that the buffer holds a code's bits or that
/// the margin holds, so the run writes at least one literal.
pub inline fn literals(comptime claims: Claims, comptime room: fast.Room, loop: *Loop, literal_tables: *LiteralTables, state: *State, phase: *Phase) void {
    @setRuntimeSafety(!claims.unchecked_loop);
    assert(state.command.insert_left > 0);
    assert(loop.count >= constants.code_len_max or loop.has_input_margin(!claims.unchecked_loop));
    const blocks = commands.blocks_of(state, .literal);
    const block_type = blocks.type_current;
    if (literal_tables.block_type != block_type) look_up_literal_tables(literal_tables, state, block_type);
    // 32 bits wide: a 9-bit variable, as `chunk_len_max` would make it, goes through memory.
    var batch: u32 = @min(state.command.insert_left, blocks.count_left, constants.chunk_len_max);
    // Decision 32: below the margin, the batch fits the room, which the caller has checked holds an
    // octet; above it, the margin holds a whole batch.
    if (room == .each_write and loop.room(!claims.unchecked_loop) < batch) batch = @intCast(loop.room(!claims.unchecked_loop));
    assert(batch >= 1);
    const written = run(claims, loop, literal_tables, state.context_modes[block_type], prefix_reader.literal_entry_mode(state), batch);
    assert(written >= 1);
    loop.wrote(!claims.unchecked_loop, written);
    if (blocks.types_count >= constants.block_switch_types_min) blocks.count_left -= written;
    state.command.insert_left -= written;
    produce(!claims.unchecked_loop, state, written);
    if (state.command.insert_left == 0) phase.* = commands.after_literals(state);
}

/// The literal table of each context of `block_type`, from its row of the literal context map (RFC
/// 7932 §7.3), and whether the row names one tree.
pub fn look_up_literal_tables(literal_tables: *LiteralTables, state: *const State, block_type: u8) void {
    const row = state.literal_context_map[@as(usize, block_type) * constants.literal_contexts_count ..][0..constants.literal_contexts_count];
    for (&literal_tables.tables, row) |*table, tree| table.* = &state.literal_codes[tree];
    literal_tables.block_type = block_type;
    literal_tables.one_tree = names_one_tree(row);
}

/// Whether a row of the literal context map names the same tree for every context.
fn names_one_tree(row: *const [constants.literal_contexts_count]u8) bool {
    for (row[1..]) |tree| {
        if (tree != row[0]) return false;
    }
    return true;
}

/// How a block type's literals take their tables: of the one tree its contexts take, with the
/// context parts the entries hold, or with the context IDs of the block type's own mode.
const RunKind = enum { one_tree, entry_parts, own_mode };

/// The entries' parts serve a block type of the mode they were built for alone.
fn run_kind(one_tree: bool, mode: context.Mode, entry_mode: context.Mode) RunKind {
    if (one_tree) return .one_tree;
    if (mode == entry_mode) return .entry_parts;
    return .own_mode;
}

/// Writes up to `batch` literals past the loop's output as `run_kind` picks, and returns how many.
inline fn run(comptime claims: Claims, loop: *Loop, literal_tables: *const LiteralTables, mode: context.Mode, entry_mode: context.Mode, batch: u32) u32 {
    @setRuntimeSafety(!claims.unchecked_loop);
    return switch (run_kind(literal_tables.one_tree, mode, entry_mode)) {
        .one_tree => one_tree_run(claims, loop, literal_tables.tables[0], batch),
        .entry_parts => switch (mode) {
            inline else => |known| entry_run(claims, known, loop, &literal_tables.tables, batch),
        },
        .own_mode => switch (mode) {
            inline else => |known| literal_run(claims, known, loop, &literal_tables.tables, batch),
        },
    };
}

/// Whether the buffer holds the bits of a literal's code, after a refill when it needs one and the
/// input's margin holds.
inline fn has_code_bits(comptime claims: Claims, loop: *Loop) bool {
    @setRuntimeSafety(!claims.unchecked_loop);
    if (loop.count >= constants.code_len_max) return true;
    if (!loop.has_input_margin(!claims.unchecked_loop)) return false;
    refill(claims, loop);
    return true;
}

/// Literals of one table, which every context of the block type takes. A table's value holds the
/// literal in its low octet.
inline fn one_tree_run(comptime claims: Claims, loop: *Loop, table: *const LiteralTable, batch: u32) u32 {
    @setRuntimeSafety(!claims.unchecked_loop);
    const out = loop.output[loop.written..][0..batch];
    for (out, 0..) |*octet, index| {
        if (!has_code_bits(claims, loop)) return @intCast(index);
        octet.* = @truncate(loop.decode(!claims.unchecked_loop, table));
    }
    return batch;
}

/// Literals of the mode the tables' entries were built for: the context ID is p1's part, which the
/// entry of the literal before holds above it, OR p2's part (RFC 7932 §7.1), so the next ID takes
/// no load of a Lut. The parts stay 32 bits wide until the index: a 6-bit variable carried from
/// one literal to the next goes through memory.
inline fn entry_run(comptime claims: Claims, comptime mode: context.Mode, loop: *Loop, tables: *const Tables, batch: u32) u32 {
    @setRuntimeSafety(!claims.unchecked_loop);
    var p1 = loop.p1;
    var p1_part: u32 = context.p1_part(mode, loop.p1);
    var p2_part: u32 = context.p2_part(mode, loop.p2);
    const out = loop.output[loop.written..][0..batch];
    for (out, 0..) |*octet, index| {
        if (!has_code_bits(claims, loop)) return @intCast(index);
        const value = loop.decode(!claims.unchecked_loop, tables[@as(u6, @truncate(p1_part | p2_part))]);
        const literal: u8 = @truncate(value);
        octet.* = literal;
        p2_part = context.p2_part(mode, p1);
        p1_part = value >> context.entry_p1_part_shift;
        p1 = literal;
    }
    return batch;
}

/// Literals of a mode other than the entries': each context ID from p1 and p2 (RFC 7932 §7.1).
inline fn literal_run(comptime claims: Claims, comptime mode: context.Mode, loop: *Loop, tables: *const Tables, batch: u32) u32 {
    @setRuntimeSafety(!claims.unchecked_loop);
    var p1 = loop.p1;
    var p2 = loop.p2;
    const out = loop.output[loop.written..][0..batch];
    for (out, 0..) |*octet, index| {
        if (!has_code_bits(claims, loop)) return @intCast(index);
        const literal: u8 = @truncate(loop.decode(!claims.unchecked_loop, tables[context.literal_id(mode, p1, p2)]));
        octet.* = literal;
        p2 = p1;
        p1 = literal;
    }
    return batch;
}

test "a row names one tree only when every context takes the first's" {
    const testing = std.testing;
    var row: [constants.literal_contexts_count]u8 = @splat(7);
    try testing.expect(names_one_tree(&row));
    for ([_]usize{ 0, 1, row.len / 2, row.len - 1 }) |place| {
        row[place] = 8;
        try testing.expect(!names_one_tree(&row));
        row[place] = 7;
    }
}

test "one tree takes its run in any mode, the entries' mode their parts, another mode its own IDs" {
    const testing = std.testing;
    try testing.expectEqual(.one_tree, run_kind(true, .utf8, .signed));
    try testing.expectEqual(.one_tree, run_kind(true, .utf8, .utf8));
    try testing.expectEqual(.entry_parts, run_kind(false, .signed, .signed));
    try testing.expectEqual(.own_mode, run_kind(false, .msb6, .lsb6));
}
