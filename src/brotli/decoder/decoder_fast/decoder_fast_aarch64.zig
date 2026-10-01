//! The brotli fast path's straight command loop in aarch64 assembly (decision 23's brotli
//! extension, which amends decision 16 for this loop): `straight_loop` with its state in registers
//! the assembly allots, taking the commands the Zig straight path takes and writing the same octets.
//!
//! It takes the margin's room mode with the unchecked loop, the word refill and the chunk copies on;
//! the Zig loop takes every other setting, and every other target. Like the Zig loop, it checks
//! decision 16's margins before each command, and leaves what the straight path leaves to the
//! chain but a copy of more than a chunk whose stores the room holds: a block switch, a dictionary
//! word, a copy from the window, and a value the checked path refuses, with the state as the phases
//! would have it and the bits of the phase the chain takes again unused.
//!
//! Its reads and writes go by address, without Zig's bounds checks. The margins keep a refill's load
//! inside the input and a command's stores inside the output; a root's index and an entry's
//! `second_bits` keep a lookup inside its table; the context IDs, below 64, and the maps' rows keep
//! a table's pointer inside the tables; and the checks of each copy keep its loads inside the octets
//! this call wrote.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const context = @import("../../context.zig");
const prefix = @import("../../prefix.zig");
const Claims = @import("../../claims.zig").Claims;
const state_module = @import("../decoder_state.zig");
const commands = @import("../decoder_commands.zig");
const prefix_reader = @import("../decoder_prefix.zig");
const literal_runs = @import("decoder_fast_literals.zig");
const dictionary = @import("../../dictionary.zig");
const transform = @import("../../transform.zig");
const fast = @import("decoder_fast.zig");
const loop_text = @import("decoder_fast_aarch64_template.zig");
const rest_text = @import("decoder_fast_aarch64_template_distance.zig");
const packed_tables = @import("decoder_fast_packed.zig");
const State = state_module.State;
const Phase = state_module.Phase;
const Loop = fast.Loop;
const Link = fast.Link;

/// Whether the assembly takes the straight loop: an aarch64 target, the margin's room mode, and the
/// unchecked loop, the word refill and the chunk copies on.
pub fn takes(comptime claims: Claims, comptime room: fast.Room) bool {
    return builtin.cpu.arch == .aarch64 and room == .margin and claims.unchecked_loop and claims.word_refill and claims.chunk_copies;
}

/// The loop's state, as the assembly reads and writes it: every field 8 octets, at the offsets
/// `template_arguments` names, the pairs an `ldp` or `stp` moves adjacent.
const Machine = extern struct {
    /// The input's next octet, and the last place an 8-octet load may start.
    input: [*]const u8,
    input_limit: [*]const u8,
    /// The output's next octet, the last place a command may start, and the call's first octet.
    output: [*]u8,
    output_limit: [*]const u8,
    output_base: [*]const u8,
    buffer: u64,
    count: u64,
    /// The current insert-and-copy block type's table, and the distance tables.
    ic_table: [*]const prefix.Entry,
    dist_tables: [*]const u8,
    /// The current literal block type's table for each context, and the current distance block
    /// type's row of the distance context map.
    lit_tables: [*]const *const literal_runs.LiteralTable,
    dist_map_row: [*]const u8,
    /// The parts of a context ID that p1 and p2 give in the literal block type's mode.
    lut_p1: [*]const u8,
    lut_p2: [*]const u8,
    /// How the literal block type's runs take their tables (`literal_runs.RunKind`): the first
    /// table with no context ID, p1's part from the entries, or both parts from the luts.
    run_kind: u64,
    meta_block_left: u64,
    /// The octets produced less the address of the output's next octet, so that the address added
    /// gives the octets produced; and the farthest a back-reference reaches.
    produced_offset: u64,
    window_distance_max: u64,
    /// The elements left in each category's block; for a category of one block type, a count no
    /// call reaches, since RFC 7932 §9.3 reads no block switch there.
    ic_count: u64,
    lit_count: u64,
    dist_count: u64,
    /// The ring of last distances, two 32-bit distances a field, the last in the low half of the
    /// first.
    ring01: u64,
    ring23: u64,
    p1: u64,
    p2: u64,
    /// The distance codes past the direct ones (RFC 7932 §4): the first, 16 + NDIRECT, and its
    /// NPOSTFIX's entries in `packed_tables.coded_distances`; then NPOSTFIX and NDIRECT + 1, which
    /// a coded distance adds.
    coded_first: u64,
    coded_distances: [*]const u64,
    postfix_bits: u64,
    direct_plus_one: u64,
    command_codes: *const [constants.insert_copy_alphabet_len]u64,
    short_codes: *const [constants.distance_short_codes_count]u64,
    /// The function that transforms a dictionary word into the output (`write_word`).
    write_word: *const fn ([*]u8, u64, u64, u64) callconv(.c) u64,
    /// Where the loop stopped: the phase and the command's values, as the state keeps them.
    phase: u64,
    insert_code: u64,
    copy_code: u64,
    last_distance: u64,
    copy_len: u64,
    insert_left: u64,
    /// A literal run's length, kept while the run goes.
    batch: u64,
    /// The symbols decoded, which a test build counts (invariant 17).
    decoded: u64,
};

/// Runs the straight loop from a command's start as `fast.straight_loop` does, for a caller that
/// checked `takes` and stands at `.command` with the room's margin held and the buffer refilled (the
/// refill may have taken the input's slack, which the loop checks again before each command): until
/// a margin, or a phase the chain or the checked path takes, with the loop, the state and the phase
/// as the Zig phases would leave them. Returns the link the loop goes on with. Inline: a call that
/// took the loop's address would keep the Zig loop's fields in memory for its whole frame.
pub inline fn straight_commands(loop: *Loop, literal_tables: *fast.LiteralTables, state: *State, phase: *Phase) Link {
    assert(phase.* == .command);
    assert(loop.count >= fast.refill_bits and loop.room(true) >= fast.output_margin);
    assert(loop.count <= @bitSizeOf(u64));
    const ic_blocks = commands.blocks_of(state, .insert_copy);
    const lit_blocks = commands.blocks_of(state, .literal);
    const dist_blocks = commands.blocks_of(state, .distance);
    if (literal_tables.block_type != lit_blocks.type_current) literal_runs.look_up_literal_tables(literal_tables, state, lit_blocks.type_current);
    const ring = &state.last_distances;
    const mode = state.context_modes[lit_blocks.type_current];
    const luts = &packed_tables.context_luts[@intFromEnum(mode)];
    var machine: Machine = .{
        .input = loop.input.ptr + loop.position,
        .input_limit = loop.input.ptr + (loop.input.len - fast.input_slack),
        .output = loop.output.ptr + loop.written,
        .output_limit = loop.output.ptr + (loop.output.len - fast.output_margin),
        .output_base = loop.output.ptr,
        .buffer = loop.buffer,
        .count = loop.count,
        .ic_table = &state.insert_copy_codes[ic_blocks.type_current].entries,
        .dist_tables = @ptrCast(&state.distance_codes),
        .lit_tables = &literal_tables.tables,
        .dist_map_row = state.distance_context_map[@as(usize, dist_blocks.type_current) * constants.distance_contexts_count ..].ptr,
        .lut_p1 = &luts[0],
        .lut_p2 = &luts[1],
        .run_kind = @intFromEnum(literal_runs.run_kind(literal_tables.one_tree, mode, prefix_reader.literal_entry_mode(state))),
        .meta_block_left = state.meta_block_left,
        .produced_offset = state_module.produced(state) -% @intFromPtr(loop.output.ptr + loop.written),
        .window_distance_max = state.window_distance_max,
        .ic_count = count_of(ic_blocks),
        .lit_count = count_of(lit_blocks),
        .dist_count = count_of(dist_blocks),
        .ring01 = @as(u64, ring[0]) | @as(u64, ring[1]) << ring_half_bits,
        .ring23 = @as(u64, ring[ring_per_field]) | @as(u64, ring[ring_per_field + 1]) << ring_half_bits,
        .p1 = loop.p1,
        .p2 = loop.p2,
        .coded_first = constants.distance_short_codes_count + @as(u64, state.direct_count),
        .coded_distances = packed_tables.coded_distances[packed_tables.coded_distances_first[state.postfix_bits]..].ptr,
        .postfix_bits = state.postfix_bits,
        .direct_plus_one = @as(u64, state.direct_count) + 1,
        .command_codes = &packed_tables.command_codes,
        .short_codes = &packed_tables.short_codes,
        .write_word = &write_word,
        .phase = 0,
        .insert_code = 0,
        .copy_code = 0,
        .last_distance = 0,
        .copy_len = 0,
        .insert_left = 0,
        .batch = 0,
        .decoded = 0,
    };
    const link: Link = @enumFromInt(execute(&machine));
    loop.position = @intFromPtr(machine.input) - @intFromPtr(loop.input.ptr);
    loop.written = @intFromPtr(machine.output) - @intFromPtr(loop.output.ptr);
    assert(loop.position <= loop.input.len and loop.written <= loop.output.len);
    loop.buffer = machine.buffer;
    loop.count = @intCast(machine.count);
    loop.p1 = @intCast(machine.p1);
    loop.p2 = @intCast(machine.p2);
    if (builtin.is_test) loop.decoded += machine.decoded;
    state.meta_block_left = @intCast(machine.meta_block_left);
    set_count(ic_blocks, machine.ic_count);
    set_count(lit_blocks, machine.lit_count);
    set_count(dist_blocks, machine.dist_count);
    state.last_distances = .{ @truncate(machine.ring01), @truncate(machine.ring01 >> ring_half_bits), @truncate(machine.ring23), @truncate(machine.ring23 >> ring_half_bits) };
    state.command.insert_code = @intCast(machine.insert_code);
    state.command.copy_code = @intCast(machine.copy_code);
    state.command.last_distance = machine.last_distance != 0;
    state.command.insert_left = @intCast(machine.insert_left);
    state.command.copy_len = @intCast(machine.copy_len);
    phase.* = @enumFromInt(machine.phase);
    return link;
}

/// The bits one distance of the ring takes in its field, and the distances a field holds.
const ring_half_bits = @bitSizeOf(u32);
const ring_per_field = 2;

/// A count of elements no call reaches: the loop takes at most one element per bit of input.
const single_type_count: u64 = 1 << single_type_count_bits;
const single_type_count_bits = 62;

/// A block's elements left as the loop counts them: the state's for two block types or more; for
/// one, `single_type_count`, since the loop takes one per element without RFC 7932 §9.3's guard.
fn count_of(blocks: *const state_module.Blocks) u64 {
    return if (blocks.types_count >= constants.block_switch_types_min) blocks.count_left else single_type_count;
}

/// Writes a block's elements left back, for a category of two block types or more.
fn set_count(blocks: *state_module.Blocks, count: u64) void {
    if (blocks.types_count >= constants.block_switch_types_min) blocks.count_left = @intCast(count);
}

/// Decodes commands until a margin or a phase for Zig, as `Machine` describes, and returns the link.
noinline fn execute(machine: *Machine) u64 {
    return asm volatile (template
        : [link] "={x0}" (-> u64),
        : [machine] "{x0}" (machine),
        : .{
          .memory = true,
          .nzcv = true,
          .v0 = true,
          .v1 = true,
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
          .x30 = true,
        });
}

/// A dictionary word (RFC 7932 §8) transformed into `output` for the loop, which calls this with
/// the word's length, the reference past the reach less 1 and the meta-block's octets left: the
/// octets written, or `word_refused` for a reference the checked path refuses or a word past MLEN.
/// The wide transform stores `transform.wide_output_len` octets whatever the word's length, inside
/// the margin's room.
fn write_word(output: [*]u8, len: u64, word_id: u64, meta_block_left: u64) callconv(.c) u64 {
    @setRuntimeSafety(false);
    const reference = commands.word_reference_of(@intCast(len), @intCast(word_id)) catch return word_refused;
    const offset = dictionary.word_offset(reference.len, reference.index);
    const wide = offset + transform.wide_input_len <= dictionary.data.len;
    const written = if (wide)
        transform.apply_wide(reference.transform_id, dictionary.data[offset..][0..transform.wide_input_len], reference.len, output[0..transform.wide_output_len])
    else
        transform.apply(reference.transform_id, dictionary.word(reference.len, reference.index), output[0..constants.transformed_word_len_max]);
    // RFC 7932 §9.3: a dictionary word that would exceed MLEN; the checked path refuses it.
    if (written > meta_block_left) return word_refused;
    return written;
}

/// What `write_word` returns for a word the loop must leave to the checked path: no length.
const word_refused = std.math.maxInt(u64);

comptime {
    // The fields `ldp` and `stp` move in pairs are adjacent.
    assert(@offsetOf(Machine, "input_limit") == @offsetOf(Machine, "input") + @sizeOf(u64));
    assert(@offsetOf(Machine, "output_limit") == @offsetOf(Machine, "output") + @sizeOf(u64));
    assert(@offsetOf(Machine, "count") == @offsetOf(Machine, "buffer") + @sizeOf(u64));
    assert(@offsetOf(Machine, "dist_tables") == @offsetOf(Machine, "ic_table") + @sizeOf(u64));
    assert(@offsetOf(Machine, "dist_map_row") == @offsetOf(Machine, "lit_tables") + @sizeOf(u64));
    assert(@offsetOf(Machine, "lut_p2") == @offsetOf(Machine, "lut_p1") + @sizeOf(u64));
    assert(@offsetOf(Machine, "window_distance_max") == @offsetOf(Machine, "produced_offset") + @sizeOf(u64));
    assert(@offsetOf(Machine, "lit_count") == @offsetOf(Machine, "ic_count") + @sizeOf(u64));
    assert(@offsetOf(Machine, "ring23") == @offsetOf(Machine, "ring01") + @sizeOf(u64));
    assert(@offsetOf(Machine, "p2") == @offsetOf(Machine, "p1") + @sizeOf(u64));
    assert(@offsetOf(Machine, "copy_code") == @offsetOf(Machine, "insert_code") + @sizeOf(u64));
    assert(@offsetOf(Machine, "insert_left") == @offsetOf(Machine, "copy_len") + @sizeOf(u64));
    assert(@offsetOf(Machine, "coded_distances") == @offsetOf(Machine, "coded_first") + @sizeOf(u64));
    assert(@offsetOf(Machine, "direct_plus_one") == @offsetOf(Machine, "postfix_bits") + @sizeOf(u64));
    // An entry: its length in the low 8 bits, its second level's bits in the next 8, its value in
    // the top 16, 4 octets in all; a table's pointer 8.
    assert(@sizeOf(prefix.Entry) == @sizeOf(u32) and @offsetOf(prefix.Entry, "len") == 0);
    assert(@offsetOf(prefix.Entry, "second_bits") == @sizeOf(u8) and @offsetOf(prefix.Entry, "value") == @sizeOf(u16));
    assert(@sizeOf(*const literal_runs.LiteralTable) == @sizeOf(u64));
    // The numbers the text writes (decoder_fast_aarch64_template.zig): a buffer of 64 bits refilled
    // to 56, a root of 8 bits, 16-bit values, a copy of 16-octet chunks or 8-octet words, and a
    // context ID that takes 63 at most.
    assert(@bitSizeOf(u64) == 64 and fast.refill_bits == 56 and constants.table_root_bits == 8);
    assert(constants.copy_chunk_len == @sizeOf(u128) and constants.copy_word_len == @sizeOf(u64));
    assert(constants.literal_contexts_count == 64 and constants.code_len_max == 15);
    // The run of one tree is the kind the text tests for zero.
    assert(@intFromEnum(literal_runs.RunKind.one_tree) == 0);
    assert(constants.distance_extra_bits_max + constants.code_len_max <= fast.refill_bits);
    assert(std.math.maxInt(u8) >= fast.refill_bits);
    // A command's extra bits fit the packed octet, as do the two codes.
    assert(constants.insert_length_codes.len <= std.math.maxInt(u8) and constants.copy_length_codes.len <= std.math.maxInt(u8));
    // The chain's phases and links, as the text names them.
    assert(@intFromEnum(Link.go_on) < std.math.maxInt(u8) and @intFromEnum(Phase.meta_block_end) < std.math.maxInt(u8));
    // A distance's tree table, whose size the text multiplies by.
    assert(@sizeOf(@TypeOf(@as(State, undefined).distance_codes[0])) == constants.distance_table_len_max * @sizeOf(prefix.Entry));
    assert(constants.distance_context_copy_len_min == 2 and constants.distance_context_last_copy_len == 5);
    // A word's transform stores inside the margin's room.
    assert(transform.wide_output_len <= fast.output_margin and constants.transformed_word_len_max <= fast.output_margin);
}

/// The loop's text, each piece printed with the offsets and constants it names.
const template = std.fmt.comptimePrint(loop_text.prologue, .{
    .input = @offsetOf(Machine, "input"),
    .output = @offsetOf(Machine, "output"),
    .output_base = @offsetOf(Machine, "output_base"),
    .buffer = @offsetOf(Machine, "buffer"),
    .ic_table = @offsetOf(Machine, "ic_table"),
    .lit_tables = @offsetOf(Machine, "lit_tables"),
    .meta_block_left = @offsetOf(Machine, "meta_block_left"),
    .ic_count = @offsetOf(Machine, "ic_count"),
    .dist_count = @offsetOf(Machine, "dist_count"),
    .ring01 = @offsetOf(Machine, "ring01"),
    .p1 = @offsetOf(Machine, "p1"),
    .command_codes = @offsetOf(Machine, "command_codes"),
}) ++ "\n" ++ std.fmt.comptimePrint(loop_text.command, .{
    .entry_second_at = entry_second_at,
    .entry_value_at = entry_value_at,
    .refill_bits = fast.refill_bits,
    .count_symbol = counts.symbol,
    .extra_bits_at = packed_tables.extra_bits_at,
    .insert_extra_bits_at = packed_tables.insert_extra_bits_at,
    .copy_base_at = packed_tables.copy_base_at,
}) ++ "\n" ++ std.fmt.comptimePrint(loop_text.literals, .{
    .entry_second_at = entry_second_at,
    .entry_value_at = entry_value_at,
    .code_len_max = constants.code_len_max,
    .chunk_len_max = constants.chunk_len_max,
    .copy_len = @offsetOf(Machine, "copy_len"),
    .batch = @offsetOf(Machine, "batch"),
    .lut_p1 = @offsetOf(Machine, "lut_p1"),
    .run_kind = @offsetOf(Machine, "run_kind"),
    .kind_entry_parts = @intFromEnum(literal_runs.RunKind.entry_parts),
    .entry_p1_part_shift = entry_value_at + context.entry_p1_part_shift,
    .context_id_bits = std.math.log2_int(u64, constants.literal_contexts_count),
    .count_literal = counts.symbol,
}) ++ "\n" ++ std.fmt.comptimePrint(rest_text.distance, .{
    .entry_second_at = entry_second_at,
    .entry_value_at = entry_value_at,
    .distance_bits_max = constants.code_len_max + constants.distance_extra_bits_max,
    .distance_context_last_copy_len = constants.distance_context_last_copy_len,
    .distance_context_copy_len_min = constants.distance_context_copy_len_min,
    .distance_table_size = @sizeOf(@TypeOf(@as(State, undefined).distance_codes[0])),
    .coded_first = @offsetOf(Machine, "coded_first"),
    .distance_short_codes_count = constants.distance_short_codes_count,
    .postfix_bits = @offsetOf(Machine, "postfix_bits"),
    .short_codes = @offsetOf(Machine, "short_codes"),
    .direct_code_offset = constants.distance_short_codes_count - 1,
    .coded_distance_base_at = packed_tables.coded_distance_base_at,
    .window_distance_max = @offsetOf(Machine, "window_distance_max"),
    .chunk_len_max = constants.chunk_len_max,
    .count_distance = counts.distance,
}) ++ "\n" ++ std.fmt.comptimePrint(rest_text.copy, .{
    .chunk = constants.copy_chunk_len,
    .pair = constants.copy_chunk_len * chunks_unconditional,
    .word = constants.copy_word_len,
}) ++ "\n" ++ std.fmt.comptimePrint(rest_text.word, .{
    .input = @offsetOf(Machine, "input"),
    .output = @offsetOf(Machine, "output"),
    .buffer = @offsetOf(Machine, "buffer"),
    .meta_block_left = @offsetOf(Machine, "meta_block_left"),
    .ic_count = @offsetOf(Machine, "ic_count"),
    .dist_count = @offsetOf(Machine, "dist_count"),
    .write_word = @offsetOf(Machine, "write_word"),
    .output_base = @offsetOf(Machine, "output_base"),
    .ic_table = @offsetOf(Machine, "ic_table"),
    .lit_tables = @offsetOf(Machine, "lit_tables"),
    .command_codes = @offsetOf(Machine, "command_codes"),
    .count_distance = counts.distance,
}) ++ "\n" ++ std.fmt.comptimePrint(rest_text.cold, .{ .refill_bits = fast.refill_bits, .root_bits_at_len = root_bits_at_len, .produced_offset = @offsetOf(Machine, "produced_offset"), .entry_value_at = entry_value_at }) ++ "\n" ++ std.fmt.comptimePrint(rest_text.exits, .{
    .link_go_on = @intFromEnum(Link.go_on),
    .link_command = @intFromEnum(Link.command),
    .link_literal = @intFromEnum(Link.literal),
    .link_distance = @intFromEnum(Link.distance),
    .link_stop = @intFromEnum(Link.stop),
    .phase_command = @intFromEnum(Phase.command),
    .phase_command_extra = @intFromEnum(Phase.command_extra),
    .phase_literal = @intFromEnum(Phase.literal),
    .phase_distance = @intFromEnum(Phase.distance),
    .phase_meta_block_end = @intFromEnum(Phase.meta_block_end),
    .batch = @offsetOf(Machine, "batch"),
    .copy_len = @offsetOf(Machine, "copy_len"),
    .input = @offsetOf(Machine, "input"),
    .output = @offsetOf(Machine, "output"),
    .buffer = @offsetOf(Machine, "buffer"),
    .meta_block_left = @offsetOf(Machine, "meta_block_left"),
    .ic_count = @offsetOf(Machine, "ic_count"),
    .dist_count = @offsetOf(Machine, "dist_count"),
    .ring01 = @offsetOf(Machine, "ring01"),
    .p1 = @offsetOf(Machine, "p1"),
    .phase = @offsetOf(Machine, "phase"),
    .insert_code_at = packed_tables.insert_code_at,
    .copy_code_at = packed_tables.copy_code_at,
    .copy_code_bits = packed_tables.copy_code_bits,
    .insert_code = @offsetOf(Machine, "insert_code"),
    .last_distance = @offsetOf(Machine, "last_distance"),
}) ++ "\n";

/// A root's bits placed at an entry's length, which a second-level entry adds to its own.
const root_bits_at_len = @as(u32, constants.table_root_bits) << @bitOffsetOf(prefix.Entry, "len");
/// Where an entry's second level's bits and its value start.
const entry_second_at = @bitOffsetOf(prefix.Entry, "second_bits");
const entry_value_at = @bitOffsetOf(prefix.Entry, "value");

/// The instructions that count symbols in a test build, and nothing in another: the command's and a
/// literal's with x14 free, a distance's with x23.
const counts = if (builtin.is_test) .{
    .symbol = std.fmt.comptimePrint("ldr x14, [x0, #{d}]\n    add x14, x14, #1\n    str x14, [x0, #{d}]", .{ @offsetOf(Machine, "decoded"), @offsetOf(Machine, "decoded") }),
    .distance = std.fmt.comptimePrint("ldr x23, [x0, #{d}]\n    add x23, x23, #1\n    str x23, [x0, #{d}]", .{ @offsetOf(Machine, "decoded"), @offsetOf(Machine, "decoded") }),
} else .{ .symbol = "", .distance = "" };

/// The chunks a copy writes before it looks at the length, as `decoder_fast_copy.zig` writes them.
const chunks_unconditional = 2;
