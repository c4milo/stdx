//! The rest of a compressed meta-block's header (RFC 7932 §9.2): each category's block types and the
//! codes of its block switches, NPOSTFIX and NDIRECT, the literal context modes, the two context
//! maps (§7.3), and the order its prefix codes come in.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const context = @import("../context.zig");
const state_module = @import("decoder_state.zig");
const prefix_reader = @import("decoder_prefix.zig");
const stream = @import("decoder_stream.zig");
const map_fast = @import("decoder_fast/decoder_fast_map.zig");
const State = state_module.State;
const Phase = state_module.Phase;
const Category = state_module.Category;
const Map = state_module.Map;
const Error = state_module.Error;
const count_work = state_module.count_work;

/// Whether `read_phase` takes a phase: each phase of a compressed meta-block's header (RFC 7932
/// §9.2) from ISLAST to its last prefix code, all of which read input and write no output.
pub fn is_header_phase(phase: Phase) bool {
    return switch (phase) {
        .meta_block_header, .meta_block_len, .uncompressed_flag, .block_types_count, .first_block_count, .distance_parameters, .context_modes, .trees_count, .map_run_length, .map_values, .map_inverse_transform, .prefix_kind, .simple_count, .simple_symbols, .code_length_code, .code_lengths => true,
        else => false,
    };
}

/// One phase of a meta-block's header, by the function that reads it, and the status that ends
/// the call, or null to go on.
pub fn read_phase(comptime fast_paths: bool, state: *State, bits: *codec.BitReader) align(constants.hot_function_alignment) Error!?codec.Status {
    assert(is_header_phase(state.phase));
    return switch (state.phase) {
        inline .meta_block_header, .meta_block_len, .uncompressed_flag, .block_types_count, .first_block_count, .distance_parameters, .context_modes, .trees_count, .map_run_length, .map_values, .map_inverse_transform, .prefix_kind, .simple_count, .simple_symbols, .code_length_code, .code_lengths => |phase| read_phase_of(phase, fast_paths, state, bits),
        else => unreachable,
    };
}

/// The header's phase `phase`, which the state stands at, by the function that reads it, and the
/// status that ends the call, or null to go on.
pub inline fn read_phase_of(comptime phase: Phase, comptime fast_paths: bool, state: *State, bits: *codec.BitReader) Error!?codec.Status {
    return switch (phase) {
        .meta_block_header => stream.read_meta_block_header(state, bits),
        .meta_block_len => try stream.read_meta_block_len(state, bits),
        .uncompressed_flag => stream.read_uncompressed_flag(state, bits),
        .block_types_count => read_block_types_count(state, bits),
        .first_block_count => read_first_block_count(state, bits),
        .distance_parameters => read_distance_parameters(state, bits),
        .context_modes => read_context_modes(state, bits),
        .trees_count => read_trees_count(state, bits),
        .map_run_length => read_map_run_length(state, bits),
        .map_values => try read_map_values(fast_paths, state, bits),
        .map_inverse_transform => try read_map_inverse_transform(state, bits),
        .prefix_kind => prefix_reader.read_kind(state, bits),
        .simple_count => prefix_reader.read_simple_count(state, bits),
        .simple_symbols => try prefix_reader.read_simple_symbols(state, bits),
        .code_length_code => try prefix_reader.read_code_length_code(fast_paths, state, bits),
        .code_lengths => try prefix_reader.read_code_lengths(fast_paths, state, bits),
        else => comptime unreachable,
    };
}

/// NBLTYPESx or NTREESx, 1 to 256, from its code (RFC 7932 §9.2): a 0 bit is 1; otherwise three bits
/// n and n more bits x give (1 << n) + 1 + x. Null while its bits are not all present.
fn read_count(bits: *codec.BitReader) ?u16 {
    if (!bits.ensure(1)) return null;
    if (bits.peek(1) == 0) {
        bits.consume(1);
        return 1;
    }
    const field_len = 1 + constants.count_field_bits;
    if (!bits.ensure(field_len)) return null;
    const extra_bits: u7 = @intCast(bits.peek(field_len) >> 1);
    if (!bits.ensure(field_len + extra_bits)) return null;
    const extra: u16 = @intCast(bits.peek(field_len + extra_bits) >> field_len);
    bits.consume(field_len + extra_bits);
    return (@as(u16, 1) << @intCast(extra_bits)) + 1 + extra;
}

/// NBLTYPES of the category the header has reached (RFC 7932 §9.2), and the codes of its block
/// switches when it has two block types or more.
pub fn read_block_types_count(state: *State, bits: *codec.BitReader) ?codec.Status {
    const count = read_count(bits) orelse return .needs_input;
    const blocks = &state.blocks[@intFromEnum(state.category)];
    blocks.types_count = count;
    // RFC 7932 §6: the previous and current block types start as 1 and 0.
    blocks.type_current = 0;
    blocks.type_previous = 1;
    if (count == 1) {
        // RFC 7932 §10: one block type's count starts at 16,777,216, which no element spends
        // (§9.3, `take_element`).
        blocks.count_left = constants.block_count_single_type;
        next_category(state);
        return null;
    }
    prefix_reader.start(state, .{ .block_type = state.category }, count + constants.block_type_symbol_offset);
    return null;
}

fn next_category(state: *State) void {
    if (state.category == .distance) {
        state.phase = .distance_parameters;
        return;
    }
    state.category = @enumFromInt(@intFromEnum(state.category) + 1);
    state.phase = .block_types_count;
}

/// A block count: its code with the category's count code, and its extra bits (RFC 7932 §6). Null
/// while its bits are not all present.
pub fn read_block_count(state: *const State, category: Category, bits: *codec.BitReader) ?u32 {
    _ = bits.ensure(constants.code_len_max + constants.distance_extra_bits_max);
    const available = @min(bits.bits.count, codec.constants.ensure_bits_max);
    const buffer = bits.peek(available);
    const decoded = switch (state.blocks[@intFromEnum(category)].count_code.decode(buffer, available)) {
        .symbol => |symbol| symbol,
        .needs_bits => return null,
    };
    const code = block_count_code(decoded.value);
    if (decoded.len + code.extra_bits > available) return null;
    const extra: u32 = @intCast((buffer >> @intCast(decoded.len)) & ((@as(u64, 1) << code.extra_bits) - 1));
    bits.consume(decoded.len + code.extra_bits);
    return code.base + extra;
}

/// A block count code's first count and extra bits (RFC 7932 §6).
fn block_count_code(symbol: u16) constants.LengthCode {
    assert(symbol < constants.block_count_alphabet_len);
    return constants.block_count_codes[symbol];
}

/// The first block count of a category with two block types or more (RFC 7932 §9.2).
pub fn read_first_block_count(state: *State, bits: *codec.BitReader) ?codec.Status {
    const count = read_block_count(state, state.category, bits) orelse return .needs_input;
    count_work(state, 1);
    state.blocks[@intFromEnum(state.category)].count_left = count;
    next_category(state);
    return null;
}

/// NPOSTFIX and the four most significant bits of NDIRECT (RFC 7932 §9.2), and the distance
/// alphabet they give (RFC 7932 §4).
pub fn read_distance_parameters(state: *State, bits: *codec.BitReader) ?codec.Status {
    const len = constants.postfix_field_bits + constants.direct_field_bits;
    if (!bits.ensure(len)) return .needs_input;
    const value = bits.read(len).?;
    state.postfix_bits = @intCast(value & ((1 << constants.postfix_field_bits) - 1));
    state.direct_count = @intCast((value >> constants.postfix_field_bits) << state.postfix_bits);
    assert(state.direct_count <= constants.direct_count_max);
    state.distance_alphabet_len = constants.distance_short_codes_count + state.direct_count + (@as(u16, constants.distance_code_groups) << state.postfix_bits);
    state.modes_read = 0;
    state.phase = .context_modes;
    return null;
}

/// The context mode of each literal block type, 2 bits each (RFC 7932 §9.2).
pub fn read_context_modes(state: *State, bits: *codec.BitReader) ?codec.Status {
    const types_count = state.blocks[@intFromEnum(Category.literal)].types_count;
    if (state.modes_read < types_count) {
        if (!bits.ensure(constants.context_mode_bits)) return .needs_input;
        state.context_modes[state.modes_read] = @enumFromInt(bits.read(constants.context_mode_bits).?);
        state.modes_read += 1;
        if (state.modes_read < types_count) return null;
    }
    state.map_reading.map = .literal;
    state.phase = .trees_count;
    return null;
}

/// The entries of a context map: 64 per literal block type, 4 per distance block type (RFC 7932
/// §7.3).
fn map_len(state: *const State, map: Map) u32 {
    return switch (map) {
        .literal => constants.literal_contexts_count * @as(u32, state.blocks[@intFromEnum(Category.literal)].types_count),
        .distance => constants.distance_contexts_count * @as(u32, state.blocks[@intFromEnum(Category.distance)].types_count),
    };
}

fn map_entries(state: *State, map: Map) []u8 {
    const len = map_len(state, map);
    return switch (map) {
        .literal => state.literal_context_map[0..len],
        .distance => state.distance_context_map[0..len],
    };
}

/// NTREESL or NTREESD (RFC 7932 §9.2): a context map follows when it is 2 or more; with one tree,
/// every entry of the map is 0.
pub fn read_trees_count(state: *State, bits: *codec.BitReader) ?codec.Status {
    const map = state.map_reading.map;
    const count = read_count(bits) orelse return .needs_input;
    state.trees_counts[@intFromEnum(map)] = count;
    if (count >= constants.context_map_trees_min) {
        state.phase = .map_run_length;
        return null;
    }
    @memset(map_entries(state, map), 0);
    count_work(state, map_len(state, map));
    after_map(state);
    return null;
}

/// RLEMAX (RFC 7932 §7.3): a 0 bit is 0; otherwise four more bits give RLEMAX - 1.
pub fn read_map_run_length(state: *State, bits: *codec.BitReader) ?codec.Status {
    if (!bits.ensure(1)) return .needs_input;
    var run_length_codes: u8 = 0;
    if (bits.peek(1) == 1) {
        const len = 1 + constants.run_length_field_bits;
        if (!bits.ensure(len)) return .needs_input;
        run_length_codes = @intCast((bits.peek(len) >> 1) + 1);
        bits.consume(len);
    } else {
        bits.consume(1);
    }
    state.map_reading.run_length_codes = run_length_codes;
    state.map_reading.index = 0;
    const trees_count = state.trees_counts[@intFromEnum(state.map_reading.map)];
    prefix_reader.start(state, .{ .map = state.map_reading.map }, trees_count + run_length_codes);
    return null;
}

/// Context map values (RFC 7932 §7.3), until the map is whole or the input runs out.
pub fn read_map_values(comptime fast_paths: bool, state: *State, bits: *codec.BitReader) align(constants.hot_function_alignment) Error!?codec.Status {
    const len = map_len(state, state.map_reading.map);
    // Each symbol gives at least one entry, so the map's length ends the loop.
    for (0..len + 1) |_| {
        if (fast_paths) map_fast.read(state, bits, map_entries(state, state.map_reading.map));
        if (state.map_reading.index == len) {
            state.phase = .map_inverse_transform;
            return null;
        }
        try read_map_value(state, bits, len) orelse return .needs_input;
    }
    unreachable;
}

/// One symbol of the map's code and its extra bits: a value, or a run of zeros (RFC 7932 §7.3); null
/// while they are not all present.
fn read_map_value(state: *State, bits: *codec.BitReader, len: u32) Error!?void {
    const reading = &state.map_reading;
    _ = bits.ensure(constants.code_len_max + constants.run_length_codes_max);
    const available = @min(bits.bits.count, codec.constants.ensure_bits_max);
    const buffer = bits.peek(available);
    const decoded = switch (state.map_code.decode(buffer, available)) {
        .symbol => |symbol| symbol,
        .needs_bits => return null,
    };
    const entries = map_entries(state, reading.map);
    if (decoded.value == 0 or decoded.value > reading.run_length_codes) {
        bits.consume(decoded.len);
        count_work(state, 1);
        // RLEMAX + n is the value n; 0 is the value 0.
        entries[reading.index] = @intCast(if (decoded.value == 0) 0 else decoded.value - reading.run_length_codes);
        reading.index += 1;
        return;
    }
    // A run of zeros, (1 << n) + n extra bits long.
    const extra_bits: u7 = @intCast(decoded.value);
    if (decoded.len + extra_bits > available) return null;
    const run: u32 = (@as(u32, 1) << @intCast(extra_bits)) + @as(u32, @intCast((buffer >> @intCast(decoded.len)) & ((@as(u64, 1) << @intCast(extra_bits)) - 1)));
    // RFC 7932 §7.3: a run past the size of the context map should be rejected as invalid.
    if (reading.index + run > len) return error.RepeatPastEnd;
    bits.consume(decoded.len + extra_bits);
    fill_zeros(entries, reading.index, run);
    count_work(state, 1 + run);
    reading.index += run;
}

/// Writes `count` zeros from `start`, which the caller has checked against the map's length.
pub fn fill_zeros(entries: []u8, start: u32, count: u32) void {
    assert(start + count <= entries.len);
    @memset(entries[start..][0..count], 0);
}

/// The IMTF bit, and the inverse move-to-front transform it asks for (RFC 7932 §7.3); then the map
/// must hold every tree index below NTREES.
pub fn read_map_inverse_transform(state: *State, bits: *codec.BitReader) Error!?codec.Status {
    if (!bits.ensure(1)) return .needs_input;
    const map = state.map_reading.map;
    const entries = map_entries(state, map);
    if (bits.read(1).? == 1) count_work(state, inverse_move_to_front(entries));
    const trees_count = state.trees_counts[@intFromEnum(map)];
    var seen: [constants.trees_max]bool = @splat(false);
    for (entries) |entry| {
        assert(entry < trees_count);
        seen[entry] = true;
    }
    count_work(state, entries.len);
    // RFC 7932 §7.3: the different values in the context map must be the interval 0 to NTREES - 1.
    for (seen[0..trees_count]) |value_seen| if (!value_seen) return error.InvalidContextMap;
    after_map(state);
    return null;
}

/// The move-to-front list the inverse transform starts from: each value at its own place (RFC 7932
/// §7.3). A copy of it costs no fill of a list declared undefined.
const identity_order = order: {
    var order: [constants.trees_max]u8 = undefined;
    for (&order, 0..) |*value, index| value.* = index;
    break :order order;
};

/// InverseMoveToFrontTransform of RFC 7932 §7.3. Returns the entries of its list it wrote: for each
/// map entry, the values it moves down and the one it moves to the front.
fn inverse_move_to_front(entries: []u8) usize {
    var order = identity_order;
    var written: usize = 0;
    for (entries) |*entry| {
        const index = entry.*;
        const value = order[index];
        entry.* = value;
        // Invariant 17's count alone reads it.
        if (builtin.is_test) written += @as(usize, index) + 1;
        // The value at the front moves nothing; one below `move_to_front_vector_len` moves the
        // values before it up by one in a single vector shift, the rest of the vector kept.
        if (index == 0) continue;
        if (index < constants.move_to_front_vector_len) {
            const Chunk = @Vector(constants.move_to_front_vector_len, u8);
            const head: Chunk = order[0..constants.move_to_front_vector_len].*;
            const moved = std.simd.shiftElementsRight(head, 1, value);
            const lanes = std.simd.iota(u8, constants.move_to_front_vector_len);
            order[0..constants.move_to_front_vector_len].* = @select(u8, lanes <= @as(Chunk, @splat(index)), moved, head);
            continue;
        }
        std.mem.copyBackwards(u8, order[1 .. @as(usize, index) + 1], order[0..index]);
        order[0] = value;
    }
    return written;
}

/// After the literal context map, the distance one; after both, the prefix codes.
fn after_map(state: *State) void {
    if (state.map_reading.map == .literal) {
        state.map_reading.map = .distance;
        state.phase = .trees_count;
        return;
    }
    prefix_reader.start(state, .{ .literal = 0 }, constants.literal_alphabet_len);
}

/// Where the header goes once a prefix code is built (RFC 7932 §9.2): each category's block type
/// code, then its count code; a context map's code, then its values; NTREESL literal codes, then
/// NBLTYPESI insert-and-copy codes, then NTREESD distance codes, then the meta-block's commands.
pub fn after_code(state: *State) void {
    switch (state.reading.target) {
        .block_type => |category| prefix_reader.start(state, .{ .block_count = category }, constants.block_count_alphabet_len),
        .block_count => state.phase = .first_block_count,
        .map => state.phase = .map_values,
        .literal => |index| if (index + 1 < state.trees_counts[@intFromEnum(Map.literal)]) {
            prefix_reader.start(state, .{ .literal = index + 1 }, constants.literal_alphabet_len);
        } else {
            prefix_reader.start(state, .{ .insert_copy = 0 }, constants.insert_copy_alphabet_len);
        },
        .insert_copy => |index| if (index + 1 < state.blocks[@intFromEnum(Category.insert_copy)].types_count) {
            prefix_reader.start(state, .{ .insert_copy = index + 1 }, constants.insert_copy_alphabet_len);
        } else {
            prefix_reader.start(state, .{ .distance = 0 }, state.distance_alphabet_len);
        },
        .distance => |index| if (index + 1 < state.trees_counts[@intFromEnum(Map.distance)]) {
            prefix_reader.start(state, .{ .distance = index + 1 }, state.distance_alphabet_len);
        } else {
            state.phase = .command;
        },
    }
}
