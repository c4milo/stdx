//! A meta-block's commands (RFC 7932 §9.3, §10), a step at a time: a block switch when a category's
//! block runs out (§6), an insert-and-copy length (§5), each literal with its context (§7), a
//! distance (§4), and the copy: from the window, or a static dictionary word (§8).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const context = @import("../context.zig");
const dictionary = @import("../dictionary.zig");
const transform = @import("../transform.zig");
const state_module = @import("decoder_state.zig");
const header = @import("decoder_header.zig");
const State = state_module.State;
const Phase = state_module.Phase;
const Category = state_module.Category;
const Error = state_module.Error;
const count_work = state_module.count_work;

pub fn blocks_of(state: *State, category: Category) *state_module.Blocks {
    return &state.blocks[@intFromEnum(category)];
}

/// Whether the next element of `category` needs a block switch first (RFC 7932 §9.3): its block is
/// spent and it has two block types or more.
pub fn needs_switch(state: *State, category: Category) bool {
    const blocks = blocks_of(state, category);
    if (blocks.count_left > 0) return false;
    // `take_element` spends no count of a category of one block type.
    assert(blocks.types_count >= constants.block_switch_types_min);
    return true;
}

/// Takes one element of the current block. RFC 7932 §9.3 reads a block switch only in a category
/// of two block types or more, so the count of one block type, which §10 starts at 16,777,216,
/// stays: commands whose dictionary words transform to nothing write no octet, and more of them
/// than that fit one meta-block.
pub fn take_element(blocks: *state_module.Blocks) void {
    if (blocks.types_count >= constants.block_switch_types_min) blocks.count_left -= 1;
}

fn start_switch(state: *State, category: Category, after: Phase) ?codec.Status {
    state.category = category;
    state.after_switch = after;
    state.phase = .block_type;
    return null;
}

/// A block type code, which starts a block switch.
pub fn read_block_type(state: *State, bits: *codec.BitReader) ?codec.Status {
    const blocks = blocks_of(state, state.category);
    const symbol = decode_symbol(bits, &blocks.type_code) orelse return .needs_input;
    count_work(state, 1);
    switch_type(blocks, symbol);
    state.phase = .block_count;
    return null;
}

/// Makes current the block type a block type code names (RFC 7932 §6): 0 is the previous block
/// type, 1 the current one plus one, wrapping to 0, and 2 to 257 the block types 0 to 255.
pub fn switch_type(blocks: *state_module.Blocks, symbol: u16) void {
    const block_type: u8 = switch (symbol) {
        0 => blocks.type_previous,
        1 => @intCast((@as(u16, blocks.type_current) + 1) % blocks.types_count),
        else => @intCast(symbol - constants.block_type_symbol_offset),
    };
    assert(block_type < blocks.types_count);
    blocks.type_previous = blocks.type_current;
    blocks.type_current = block_type;
}

/// The block count that follows a block type code (RFC 7932 §6).
pub fn read_block_count(state: *State, bits: *codec.BitReader) ?codec.Status {
    blocks_of(state, state.category).count_left = header.read_block_count(state, state.category, bits) orelse return .needs_input;
    count_work(state, 1);
    state.phase = state.after_switch;
    return null;
}

/// A symbol of `code`, its bits taken, or null while they are not all present.
fn decode_symbol(bits: *codec.BitReader, code: anytype) ?u16 {
    _ = bits.ensure(constants.code_len_max);
    const available = @min(bits.bits.count, codec.constants.ensure_bits_max);
    return switch (code.decode(bits.peek(available), available)) {
        .symbol => |symbol| {
            bits.consume(symbol.len);
            return symbol.value;
        },
        .needs_bits => null,
    };
}

/// An insert-and-copy length symbol (RFC 7932 §5): the insert length code and the copy length code
/// its cell and bits give, and whether the command reuses the last distance.
pub fn read_command(state: *State, bits: *codec.BitReader) ?codec.Status {
    if (needs_switch(state, .insert_copy)) return start_switch(state, .insert_copy, .command);
    const blocks = blocks_of(state, .insert_copy);
    const symbol = decode_symbol(bits, &state.insert_copy_codes[blocks.type_current]) orelse return .needs_input;
    count_work(state, 1);
    take_element(blocks);
    set_command_codes(&state.command, symbol);
    state.phase = .command_extra;
    return null;
}

/// The insert length code and copy length code an insert-and-copy symbol gives (RFC 7932 §5): its
/// cell of 64 names the first of each, and its bits 3 to 5 and 0 to 2 add to them.
pub fn set_command_codes(command: *state_module.Command, symbol: u16) void {
    assert(symbol < constants.insert_copy_alphabet_len);
    const cell = constants.insert_copy_cells[symbol >> constants.insert_copy_cell_bits];
    const code_mask = (1 << constants.insert_copy_code_bits) - 1;
    command.insert_code = cell.insert + @as(u8, @intCast((symbol >> constants.insert_copy_code_bits) & code_mask));
    command.copy_code = cell.copy + @as(u8, @intCast(symbol & code_mask));
    command.last_distance = symbol < constants.insert_copy_last_distance_symbols;
}

/// The insert and copy lengths' extra bits, together (RFC 7932 §5).
pub fn read_command_extra(state: *State, bits: *codec.BitReader) Error!?codec.Status {
    const insert = constants.insert_length_codes[state.command.insert_code];
    const copy = constants.copy_length_codes[state.command.copy_code];
    const extra_bits: u7 = @as(u7, insert.extra_bits) + copy.extra_bits;
    if (!bits.ensure(extra_bits)) return .needs_input;
    const extra = bits.peek(extra_bits);
    const insert_len = insert.base + @as(u32, @intCast(extra & low_mask(insert.extra_bits)));
    // RFC 7932 §9.3: literals that would exceed MLEN should be rejected as invalid.
    if (insert_len > state.meta_block_left) return error.LengthPastMetaBlock;
    bits.consume(extra_bits);
    state.command.insert_left = insert_len;
    state.command.copy_len = copy.base + @as(u32, @intCast((extra >> insert.extra_bits) & low_mask(copy.extra_bits)));
    state.phase = if (insert_len > 0) .literal else after_literals(state);
    return null;
}

fn low_mask(count: u5) u64 {
    return (@as(u64, 1) << count) - 1;
}

/// After the literals, the distance and copy; none when the literals end the meta-block, whose last
/// command's copy length is then ignored (RFC 7932 §9.3).
pub fn after_literals(state: *const State) Phase {
    return if (state.meta_block_left == 0) .meta_block_end else .distance;
}

/// One literal, with the literal prefix code its block type and context pick (RFC 7932 §7.1, §7.3).
pub fn read_literal(state: *State, bits: *codec.BitReader, out: anytype) ?codec.Status {
    assert(state.command.insert_left > 0);
    if (needs_switch(state, .literal)) return start_switch(state, .literal, .literal);
    if (!out.has_room()) return .needs_room;
    const blocks = blocks_of(state, .literal);
    const block_type = blocks.type_current;
    const id = context.literal_id(state.context_modes[block_type], state.p1, state.p2);
    const tree = state.literal_context_map[@as(usize, block_type) * constants.literal_contexts_count + id];
    const literal = decode_symbol(bits, &state.literal_codes[tree]) orelse return .needs_input;
    count_work(state, 1);
    take_element(blocks);
    state.command.insert_left -= 1;
    out.emit(state, @intCast(literal));
    if (state.command.insert_left == 0) state.phase = after_literals(state);
    return null;
}

/// The command's distance (RFC 7932 §4): the last distance, which the insert-and-copy symbol may
/// imply, or a distance code with the prefix code its block type and copy length pick, and its
/// extra bits.
pub fn read_distance(state: *State, bits: *codec.BitReader) Error!?codec.Status {
    // RFC 7932 §5: symbols below 128 reuse the last distance, and no distance code follows.
    if (state.command.last_distance) return try resolve_distance(state, state.last_distances[0], false);
    if (needs_switch(state, .distance)) return start_switch(state, .distance, .distance);
    const blocks = blocks_of(state, .distance);
    const id = context.distance_id(state.command.copy_len);
    const tree = state.distance_context_map[@as(usize, blocks.type_current) * constants.distance_contexts_count + id];
    _ = bits.ensure(constants.code_len_max + constants.distance_extra_bits_max);
    const available = @min(bits.bits.count, codec.constants.ensure_bits_max);
    const buffer = bits.peek(available);
    const decoded = switch (state.distance_codes[tree].decode(buffer, available)) {
        .symbol => |symbol| symbol,
        .needs_bits => return .needs_input,
    };
    const code: u32 = decoded.value;
    const extra_bits = distance_extra_bits(state, code);
    if (decoded.len + extra_bits > available) return .needs_input;
    const extra: u32 = @intCast((buffer >> @intCast(decoded.len)) & low_mask(extra_bits));
    const distance = try distance_of(state, code, extra);
    bits.consume(decoded.len + extra_bits);
    count_work(state, 1);
    take_element(blocks);
    // RFC 7932 §4: the distance code 0 does not push its distance to the ring of last distances.
    return try resolve_distance(state, distance, code != 0);
}

/// The extra bits of a distance code: none for the 16 short codes and the NDIRECT direct ones,
/// 1 + ((dcode - NDIRECT - 16) >> (NPOSTFIX + 1)) after them (RFC 7932 §4).
pub inline fn distance_extra_bits(state: *const State, code: u32) u5 {
    const first_coded = constants.distance_short_codes_count + @as(u32, state.direct_count);
    if (code < first_coded) return 0;
    return @intCast(1 + ((code - first_coded) >> (@as(u5, state.postfix_bits) + 1)));
}

/// The backward distance a distance code and its extra bits give (RFC 7932 §4).
pub inline fn distance_of(state: *const State, code: u32, extra: u32) Error!u32 {
    if (code < constants.distance_short_codes_count) {
        const short = constants.distance_short_codes[code];
        const distance = @as(i64, state.last_distances[short.last]) + short.delta;
        // RFC 7932 §4: a special distance symbol that resolves to zero or less should be rejected
        // as invalid.
        if (distance <= 0) return error.InvalidDistance;
        return @intCast(distance);
    }
    const first_coded = constants.distance_short_codes_count + @as(u32, state.direct_count);
    // Direct codes 16 to 15 + NDIRECT are the distances 1 to NDIRECT.
    if (code < first_coded) return code - (constants.distance_short_codes_count - 1);
    const postfix_bits: u5 = state.postfix_bits;
    const extra_bits = distance_extra_bits(state, code);
    const high = (code - first_coded) >> postfix_bits;
    const low = (code - first_coded) & ((@as(u32, 1) << postfix_bits) - 1);
    const offset = ((constants.coded_distance_base + (high & 1)) << extra_bits) - constants.coded_distance_bias;
    return ((offset + extra) << postfix_bits) + low + state.direct_count + 1;
}

/// A distance within the window and the octets produced is a back-reference; one past them names a
/// static dictionary word (RFC 7932 §8).
pub inline fn resolve_distance(state: *State, distance: u32, push: bool) Error!?codec.Status {
    const reach: u32 = @intCast(@min(state.window_distance_max, state.produced));
    if (distance > reach) {
        try start_word(state, distance - reach - 1);
        state.phase = .dictionary_copy;
        return null;
    }
    // RFC 7932 §9.3: a copy length that would exceed MLEN should be rejected as invalid.
    if (state.command.copy_len > state.meta_block_left) return error.LengthPastMetaBlock;
    // RFC 7932 §4: distances of dictionary words, and the code 0's, stay out of the ring.
    if (push) {
        std.mem.copyBackwards(u32, state.last_distances[1..], state.last_distances[0 .. state.last_distances.len - 1]);
        state.last_distances[0] = distance;
    }
    state.command.distance = distance;
    state.command.copy_left = state.command.copy_len;
    state.phase = .copy;
    return null;
}

/// The static dictionary word a reference past the window names, transformed (RFC 7932 §8).
fn start_word(state: *State, word_id: u32) Error!void {
    const reference = try word_reference(state, word_id);
    state.word_len = @intCast(transform.apply(reference.transform_id, dictionary.word(reference.len, reference.index), &state.word));
    // RFC 7932 §9.3: a dictionary word that would exceed MLEN should be rejected as invalid.
    if (state.word_len > state.meta_block_left) return error.LengthPastMetaBlock;
    state.word_written = 0;
}

/// A static dictionary reference: the base word's length and index, and the transformation.
pub const WordReference = struct { len: u32, index: u32, transform_id: u32 };

/// The word a reference past the window names, from the command's copy length and the distance
/// past the window, less 1 (RFC 7932 §8).
pub inline fn word_reference(state: *const State, word_id: u32) Error!WordReference {
    const len = state.command.copy_len;
    // RFC 7932 §8: a copy length below 4 or above 24 should be rejected as invalid.
    if (len < constants.word_len_min or len > constants.word_len_max) return error.InvalidDictionaryReference;
    const index = word_id & (dictionary.word_count(len) - 1);
    const transform_id = word_id >> dictionary.bits[len];
    // RFC 7932 §8: a transform_id greater than 120 should be rejected as invalid.
    if (transform_id >= constants.transforms_count) return error.InvalidDictionaryReference;
    return .{ .len = len, .index = index, .transform_id = transform_id };
}

/// One octet of a back-reference, from `distance` back in the window (RFC 7932 §10): the copy may
/// overlap the octets it writes.
pub fn copy_match(state: *State, out: anytype) ?codec.Status {
    if (state.command.copy_left == 0) {
        state.phase = after_copy(state);
        return null;
    }
    if (!out.has_room()) return .needs_room;
    out.emit(state, out.back(state.command.distance));
    state.command.copy_left -= 1;
    return null;
}

/// One octet of a dictionary word.
pub fn copy_word(state: *State, out: anytype) ?codec.Status {
    if (state.word_written == state.word_len) {
        state.phase = after_copy(state);
        return null;
    }
    if (!out.has_room()) return .needs_room;
    out.emit(state, state.word[state.word_written]);
    state.word_written += 1;
    return null;
}

pub fn after_copy(state: *const State) Phase {
    return if (state.meta_block_left == 0) .meta_block_end else .command;
}
