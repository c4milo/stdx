//! The brotli fast path's straight command loop in x86-64 assembly (decision 23's brotli extension,
//! its x86-64 port of 2026-09-30): the port of `decoder_fast_aarch64.zig`, whose comment describes
//! what it takes, what it leaves to the chain and the checked path, and what keeps its reads and
//! writes in bounds. It runs where LLVM assembles it, on a CPU with BMI2 and SSSE3, which `init`
//! finds in the caller's `codec.Features`; x86-64's 14 registers hold less than aarch64's, so more of
//! the loop's state stays in the machine, which the loop reads in place.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const codec = @import("codec");
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
const loop_text = @import("decoder_fast_x86_64_template.zig");
const rest_text = @import("decoder_fast_x86_64_template_distance.zig");
const packed_tables = @import("decoder_fast_packed.zig");
const State = state_module.State;
const Phase = state_module.Phase;
const Loop = fast.Loop;
const Link = fast.Link;

/// Whether the compiler assembles the loop: LLVM does, and Zig's own x86-64 backend, the Debug
/// default there, takes none of its directives, so a build through it keeps the Zig loop.
pub const assembles = builtin.zig_backend == .stage2_llvm;

/// Whether a CPU with `features` runs the loop: an x86-64 CPU with BMI2 and SSSE3.
pub fn runs(features: codec.Features) bool {
    return builtin.cpu.arch == .x86_64 and features.bmi2;
}

/// `runs` as the state keeps it: a bool on an x86-64 target, and nothing on another.
pub fn flag(features: codec.Features) @FieldType(State, "assembly") {
    return if (builtin.cpu.arch == .x86_64) runs(features) else {};
}

/// Whether the loop takes the straight loop where the CPU runs it: an x86-64 target whose compiler
/// assembles it, the margin's room mode, and the unchecked loop, the word refill and the chunk
/// copies on.
pub fn takes(comptime claims: Claims, comptime room: fast.Room) bool {
    return assembles and builtin.cpu.arch == .x86_64 and room == .margin and claims.unchecked_loop and claims.word_refill and claims.chunk_copies;
}

/// The loop's state, as the assembly reads and writes it: every field 8 octets, at the offsets
/// `template` names, the ring's two fields adjacent so one vector moves the ring.
const Machine = extern struct {
    /// The input's next octet, and the last place an 8-octet load may start.
    input: [*]const u8,
    input_limit: [*]const u8,
    /// The output's next octet, the last place a command starts with the margin's room, which the
    /// loop sets to all ones once it takes the room as the octets left, and the call's first octet.
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
    /// How the literal block type's runs take their tables (`literal_runs.RunKind`).
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
    /// first: four in a row, as the loop's vector moves them.
    ring01: u64,
    ring23: u64,
    p1: u64,
    p2: u64,
    /// NPOSTFIX, NPOSTFIX + 1, NDIRECT and 16 + NDIRECT, where the first coded distance code starts.
    postfix_bits: u64,
    postfix_shift: u64,
    direct_count: u64,
    direct_end: u64,
    command_codes: *const [constants.insert_copy_alphabet_len]u64,
    short_codes: *const [constants.distance_short_codes_count]u64,
    /// The function that transforms a dictionary word into the output (`write_word`).
    write_word: *const fn ([*]u8, u64, u64, u64) callconv(word_convention) u64,
    /// Where the loop stopped: the phase and the command's values, as the state keeps them.
    phase: u64 = 0,
    insert_code: u64 = 0,
    copy_code: u64 = 0,
    last_distance: u64 = 0,
    copy_len: u64 = 0,
    insert_left: u64 = 0,
    /// A literal run's length, and the command's packed code, kept while the run goes.
    batch: u64 = 0,
    packed_code: u64 = 0,
    /// The symbols decoded, which a test build counts (invariant 17).
    decoded: u64 = 0,
    /// The current distance block type's table for each distance context (RFC 7932 §7.3).
    dist_context_tables: [constants.distance_contexts_count][*]const prefix.Entry,
    /// The last place a dictionary word's transform may start: `transform.wide_output_len` before
    /// the output's end.
    word_limit: [*]const u8,
    /// The meta-block's octets left less the room's, which the loop takes off them where the room
    /// is the shorter, and its exit adds back.
    budget_delta: u64 = 0,
};

/// Runs the straight loop from a command's start as `fast.straight_loop` does, for a caller that
/// checked `takes` and that the CPU runs the loop, and stands at `.command` with the room's margin
/// held and the buffer refilled: until a margin, or a phase the chain or the checked path takes,
/// with the loop, the state and the phase as the Zig phases would leave them. Returns the link the
/// loop goes on with. Inline: a call that took the loop's address would keep the Zig loop's fields
/// in memory for its whole frame.
pub inline fn straight_commands(loop: *Loop, literal_tables: *fast.LiteralTables, state: *State, phase: *Phase) Link {
    assert(phase.* == .command and state.assembly);
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
        .dist_context_tables = packed_tables.distance_context_tables(state, dist_blocks.type_current),
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
        .postfix_bits = state.postfix_bits,
        .postfix_shift = @as(u64, state.postfix_bits) + 1,
        .direct_count = state.direct_count,
        .direct_end = @as(u64, state.direct_count) + constants.distance_short_codes_count,
        .command_codes = &packed_tables.command_codes,
        .short_codes = &packed_tables.short_codes,
        .write_word = &write_word,
        .word_limit = loop.output.ptr + (loop.output.len - transform.wide_output_len),
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

/// Decodes commands until a margin or a phase for Zig, as `Machine` describes; returns the link.
/// `write_word` may change any register System V lets a callee change, the vector ones included.
noinline fn execute(machine: *Machine) u64 {
    return asm volatile (template
        : [link] "={rax}" (-> u64),
        : [machine] "{rdi}" (machine),
        : .{
          .memory = true,
          .cc = true,
          .rbx = true,
          .rcx = true,
          .rdx = true,
          .rsi = true,
          .r8 = true,
          .r9 = true,
          .r10 = true,
          .r11 = true,
          .r12 = true,
          .r13 = true,
          .r14 = true,
          .r15 = true,
          .xmm0 = true,
          .xmm1 = true,
          .xmm2 = true,
          .xmm3 = true,
          .xmm4 = true,
          .xmm5 = true,
          .xmm6 = true,
          .xmm7 = true,
          .xmm8 = true,
          .xmm9 = true,
          .xmm10 = true,
          .xmm11 = true,
          .xmm12 = true,
          .xmm13 = true,
          .xmm14 = true,
          .xmm15 = true,
        });
}

/// A dictionary word (RFC 7932 §8) transformed into `output` for the loop, which calls this with
/// the word's length, the reference past the reach less 1 and the meta-block's octets left: the
/// octets written, or `word_refused` for a reference the checked path refuses or a word past MLEN.
/// The wide transform stores `transform.wide_output_len` octets whatever the word's length, inside
/// the margin's room.
fn write_word(output: [*]u8, len: u64, word_id: u64, meta_block_left: u64) callconv(word_convention) u64 {
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

/// The convention the loop calls `write_word` by: System V's on every x86-64 OS, whose registers
/// the text passes the arguments in; C's elsewhere, where the loop never runs.
const word_convention: std.builtin.CallingConvention = if (builtin.cpu.arch == .x86_64) .{ .x86_64_sysv = .{} } else .c;

/// What `write_word` returns for a word it leaves to the checked path, which the loop tests as -1.
const word_refused = std.math.maxInt(u64);

comptime {
    // One vector moves the ring's four distances, last first.
    assert(@offsetOf(Machine, "ring23") == @offsetOf(Machine, "ring01") + @sizeOf(u64));
    // An entry: its length in the low 8 bits, its second level's bits in the next 8, its value in
    // the top 16, 4 octets in all; a table's pointer 8; a short code's last distance in its low 2
    // bits and its delta in the octet after.
    assert(@sizeOf(prefix.Entry) == @sizeOf(u32) and @offsetOf(prefix.Entry, "len") == 0);
    assert(@offsetOf(prefix.Entry, "second_bits") == @sizeOf(u8) and @offsetOf(prefix.Entry, "value") == @sizeOf(u16));
    assert(@sizeOf(*const literal_runs.LiteralTable) == @sizeOf(u64));
    assert(constants.distance_short_codes_count == 16 and packed_tables.short_delta_at == 8);
    // The numbers the text writes (decoder_fast_x86_64_template.zig): a buffer of 64 bits refilled
    // to 56, a root of 8 bits, 16-bit values, a copy of 16-octet chunks or 8-octet words, and a
    // context ID that takes 63 at most.
    assert(@bitSizeOf(u64) == 64 and fast.refill_bits == 56 and constants.table_root_bits == 8);
    assert(constants.copy_chunk_len == @sizeOf(u128) and constants.copy_word_len == @sizeOf(u64));
    assert(constants.literal_contexts_count == 64 and constants.code_len_max == 15);
    // The run of one tree is the kind the text tests for zero.
    assert(@intFromEnum(literal_runs.RunKind.one_tree) == 0);
    assert(constants.distance_extra_bits_max + constants.code_len_max <= fast.refill_bits);
    // A command's extra bits fit the packed octet, as do the two codes.
    assert(constants.insert_length_codes.len <= std.math.maxInt(u8) and constants.copy_length_codes.len <= std.math.maxInt(u8));
    // The chain's phases and links, as the text names them.
    assert(@intFromEnum(Link.go_on) < std.math.maxInt(u8) and @intFromEnum(Phase.meta_block_end) < std.math.maxInt(u8));
    // A distance's tree table, whose size the text multiplies by.
    assert(@sizeOf(@TypeOf(@as(State, undefined).distance_codes[0])) == constants.distance_table_len_max * @sizeOf(prefix.Entry));
    assert(constants.distance_context_copy_len_min == 2 and constants.distance_context_last_copy_len == 5);
    // A word's transform stores inside the margin's room.
    assert(transform.wide_output_len <= fast.output_margin and constants.transformed_word_len_max <= fast.output_margin);
    // The reserve holds the chunks a copy stores whatever its length, inside the margin.
    assert(fast.copy_store_reserve == chunks_unconditional * constants.copy_chunk_len and fast.copy_store_reserve <= fast.output_margin);
}

/// The loop's text, each piece printed with the offsets and constants it names: a format takes 32
/// arguments at most.
const template = std.fmt.comptimePrint(loop_text.prologue, .{
    .input = @offsetOf(Machine, "input"),
    .output = @offsetOf(Machine, "output"),
    .buffer = @offsetOf(Machine, "buffer"),
    .count = @offsetOf(Machine, "count"),
    .meta_block_left = @offsetOf(Machine, "meta_block_left"),
    .p1 = @offsetOf(Machine, "p1"),
    .p2 = @offsetOf(Machine, "p2"),
}) ++ "\n" ++ std.fmt.comptimePrint(loop_text.command, .{
    .entry_second_mask = entry_second_mask,
    .entry_value_at = entry_value_at,
    .output_limit = @offsetOf(Machine, "output_limit"),
    .input_limit = @offsetOf(Machine, "input_limit"),
    .refill_bits = fast.refill_bits,
    .ic_count = @offsetOf(Machine, "ic_count"),
    .ic_table = @offsetOf(Machine, "ic_table"),
    .command_codes = @offsetOf(Machine, "command_codes"),
    .last_distance_symbols = constants.insert_copy_last_distance_symbols,
    .count_symbol = counts.symbol,
    .extra_bits_at = packed_tables.extra_bits_at,
    .insert_extra_bits_at = packed_tables.insert_extra_bits_at,
    .copy_base_at = packed_tables.copy_base_at,
}) ++ "\n" ++ std.fmt.comptimePrint(loop_text.literals, .{
    .entry_second_mask = entry_second_mask,
    .entry_value_at = entry_value_at,
    .code_len_max = constants.code_len_max,
    .input_limit = @offsetOf(Machine, "input_limit"),
    .output_limit = @offsetOf(Machine, "output_limit"),
    .lit_count = @offsetOf(Machine, "lit_count"),
    .chunk_len_max = constants.chunk_len_max,
    .copy_len = @offsetOf(Machine, "copy_len"),
    .insert_left = @offsetOf(Machine, "insert_left"),
    .batch = @offsetOf(Machine, "batch"),
    .meta_block_left = @offsetOf(Machine, "meta_block_left"),
    .packed_code = @offsetOf(Machine, "packed_code"),
    .p1 = @offsetOf(Machine, "p1"),
    .p2 = @offsetOf(Machine, "p2"),
    .lit_tables = @offsetOf(Machine, "lit_tables"),
    .run_kind = @offsetOf(Machine, "run_kind"),
    .lut_p1 = @offsetOf(Machine, "lut_p1"),
    .lut_p2 = @offsetOf(Machine, "lut_p2"),
    .kind_entry_parts = @intFromEnum(literal_runs.RunKind.entry_parts),
    .entry_p1_part_shift = context.entry_p1_part_shift,
    .count_literal = counts.symbol,
}) ++ "\n" ++ std.fmt.comptimePrint(rest_text.distance, .{
    .entry_second_mask = entry_second_mask,
    .entry_value_at = entry_value_at,
    .distance_bits_max = constants.code_len_max + constants.distance_extra_bits_max,
    .dist_count = @offsetOf(Machine, "dist_count"),
    .distance_context_at = packed_tables.distance_context_at,
    .distance_context_mask = (1 << packed_tables.distance_context_bits) - 1,
    .dist_context_tables = @offsetOf(Machine, "dist_context_tables"),
    .direct_end = @offsetOf(Machine, "direct_end"),
    .postfix_shift = @offsetOf(Machine, "postfix_shift"),
    .distance_short_codes_count = constants.distance_short_codes_count,
    .short_codes = @offsetOf(Machine, "short_codes"),
    .ring01 = @offsetOf(Machine, "ring01"),
    .direct_code_offset = constants.distance_short_codes_count - 1,
    .postfix_bits = @offsetOf(Machine, "postfix_bits"),
    .coded_distance_base = constants.coded_distance_base,
    .coded_distance_bias = constants.coded_distance_bias,
    .direct_count = @offsetOf(Machine, "direct_count"),
    .produced_offset = @offsetOf(Machine, "produced_offset"),
    .window_distance_max = @offsetOf(Machine, "window_distance_max"),
    .output_base = @offsetOf(Machine, "output_base"),
    .chunk_len_max = constants.chunk_len_max,
    .count_distance = counts.distance,
}) ++ "\n" ++ std.fmt.comptimePrint(rest_text.copy, .{
    .chunk = constants.copy_chunk_len,
    .pair = constants.copy_chunk_len * chunks_unconditional,
    .word = constants.copy_word_len,
    .p1 = @offsetOf(Machine, "p1"),
    .p2 = @offsetOf(Machine, "p2"),
}) ++ "\n" ++ std.fmt.comptimePrint(rest_text.word, .{
    .input = @offsetOf(Machine, "input"),
    .output = @offsetOf(Machine, "output"),
    .buffer = @offsetOf(Machine, "buffer"),
    .count = @offsetOf(Machine, "count"),
    .meta_block_left = @offsetOf(Machine, "meta_block_left"),
    .write_word = @offsetOf(Machine, "write_word"),
    .p1 = @offsetOf(Machine, "p1"),
    .p2 = @offsetOf(Machine, "p2"),
    .dist_count = @offsetOf(Machine, "dist_count"),
    .count_distance = counts.distance,
}) ++ "\n" ++ std.fmt.comptimePrint(rest_text.cold, .{
    .entry_second_at = @bitOffsetOf(prefix.Entry, "second_bits"),
    .input_limit = @offsetOf(Machine, "input_limit"),
    .word_limit = @offsetOf(Machine, "word_limit"),
    .output_limit = @offsetOf(Machine, "output_limit"),
    .margin_less_reserve = fast.output_margin - fast.copy_store_reserve,
    .budget_delta = @offsetOf(Machine, "budget_delta"),
    .root_bits = constants.table_root_bits,
    .root_bits_at_len = root_bits_at_len,
}) ++ "\n" ++ std.fmt.comptimePrint(rest_text.exits, .{
    .budget_delta = @offsetOf(Machine, "budget_delta"),
    .output_limit = @offsetOf(Machine, "output_limit"),
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
    .insert_left = @offsetOf(Machine, "insert_left"),
    .meta_block_left = @offsetOf(Machine, "meta_block_left"),
    .packed_code = @offsetOf(Machine, "packed_code"),
    .p1 = @offsetOf(Machine, "p1"),
    .p2 = @offsetOf(Machine, "p2"),
    .lit_count = @offsetOf(Machine, "lit_count"),
    .input = @offsetOf(Machine, "input"),
    .output = @offsetOf(Machine, "output"),
    .buffer = @offsetOf(Machine, "buffer"),
    .count = @offsetOf(Machine, "count"),
    .phase = @offsetOf(Machine, "phase"),
    .insert_code_at = packed_tables.insert_code_at,
    .insert_code = @offsetOf(Machine, "insert_code"),
    .copy_code_at = packed_tables.copy_code_at,
    .copy_code_mask = (1 << packed_tables.copy_code_bits) - 1,
    .copy_code = @offsetOf(Machine, "copy_code"),
    .last_distance = @offsetOf(Machine, "last_distance"),
}) ++ "\n";

/// A root's bits placed at an entry's length, which a second-level entry adds to its own.
const root_bits_at_len = @as(u32, constants.table_root_bits) << @bitOffsetOf(prefix.Entry, "len");
/// An entry's second level's bits, in place, and where its value starts.
const entry_second_mask = @as(u32, std.math.maxInt(u8)) << @bitOffsetOf(prefix.Entry, "second_bits");
const entry_value_at = @bitOffsetOf(prefix.Entry, "value");

/// The instructions that count symbols in a test build, and nothing in another.
const counts = if (builtin.is_test) .{
    .symbol = std.fmt.comptimePrint("inc qword ptr [rdi + {d}]", .{@offsetOf(Machine, "decoded")}),
    .distance = std.fmt.comptimePrint("inc qword ptr [rdi + {d}]", .{@offsetOf(Machine, "decoded")}),
} else .{ .symbol = "", .distance = "" };

/// The chunks a copy writes before it looks at the length, as `decoder_fast_copy.zig` writes them.
const chunks_unconditional = 2;

test "the loop runs only on an x86-64 CPU with BMI2 and SSSE3" {
    try std.testing.expect(!runs(.{}));
    try std.testing.expectEqual(builtin.cpu.arch == .x86_64, runs(.{ .bmi2 = true }));
}
