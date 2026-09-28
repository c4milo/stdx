//! Reading one prefix code (RFC 7932 §3.4, §3.5), a step at a time: its kind, then a simple code's
//! symbols, or a complex code's code length code and then its code lengths. When the code is whole
//! it is built into the place its target names, and the header goes on (decoder_header.zig).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const context = @import("../context.zig");
const prefix = @import("../prefix.zig");
const state_module = @import("decoder_state.zig");
const header = @import("decoder_header.zig");
const State = state_module.State;
const Target = state_module.Target;
const Error = state_module.Error;
const count_work = state_module.count_work;

/// Starts reading the prefix code `target` names, over an alphabet of `alphabet_len` symbols.
pub fn start(state: *State, target: Target, alphabet_len: u16) void {
    assert(alphabet_len >= 1 and alphabet_len <= state.lengths.len);
    state.reading.target = target;
    state.reading.alphabet_len = alphabet_len;
    state.phase = .prefix_kind;
}

/// The code's first 2 bits: 1 for a simple code, otherwise HSKIP (RFC 7932 §3.4, §3.5).
pub fn read_kind(state: *State, bits: *codec.BitReader) ?codec.Status {
    if (!bits.ensure(constants.prefix_kind_bits)) return .needs_input;
    const kind: u16 = @intCast(bits.read(constants.prefix_kind_bits).?);
    if (kind == constants.prefix_kind_simple) {
        state.phase = .simple_count;
        return null;
    }
    // HSKIP: the code lengths skipped, of the first code length symbols in order, are zero.
    state.reading.index = kind;
    state.reading.space = constants.code_length_code_space;
    state.reading.nonzero_count = 0;
    @memset(state.lengths[0..constants.code_length_alphabet_len], 0);
    count_work(state, constants.code_length_alphabet_len);
    state.phase = .code_length_code;
    return null;
}

/// NSYM - 1 of a simple code (RFC 7932 §3.4).
pub fn read_simple_count(state: *State, bits: *codec.BitReader) ?codec.Status {
    if (!bits.ensure(constants.simple_count_bits)) return .needs_input;
    state.reading.simple_count = @intCast(bits.read(constants.simple_count_bits).? + 1);
    state.reading.simple_read = 0;
    state.phase = .simple_symbols;
    return null;
}

/// ALPHABET_BITS: the fewest bits that hold every symbol of the alphabet (RFC 7932 §3.4).
fn alphabet_bits(alphabet_len: u16) u7 {
    return if (alphabet_len <= 1) 0 else std.math.log2_int_ceil(u16, alphabet_len);
}

/// One symbol of a simple code, or its tree-select bit after four (RFC 7932 §3.4).
pub fn read_simple_symbol(state: *State, bits: *codec.BitReader) Error!?codec.Status {
    const reading = &state.reading;
    if (reading.simple_read == reading.simple_count) {
        assert(reading.simple_count == constants.simple_symbols_max);
        if (!bits.ensure(1)) return .needs_input;
        build_simple(state, bits.read(1).? == 1);
        return null;
    }
    const symbol_bits = alphabet_bits(reading.alphabet_len);
    if (!bits.ensure(symbol_bits)) return .needs_input;
    const symbol: u16 = @intCast(bits.peek(symbol_bits));
    // RFC 7932 §3.4: a symbol not below the alphabet size should be rejected as invalid.
    if (symbol >= reading.alphabet_len) return error.InvalidSymbol;
    // RFC 7932 §3.4: a symbol identical to a previous one should be rejected as invalid.
    for (reading.simple_symbols[0..reading.simple_read]) |earlier| if (earlier == symbol) return error.DuplicateSymbol;
    bits.consume(symbol_bits);
    reading.simple_symbols[reading.simple_read] = symbol;
    reading.simple_read += 1;
    count_work(state, 1);
    if (reading.simple_read == reading.simple_count and reading.simple_count < constants.simple_symbols_max) build_simple(state, false);
    return null;
}

/// A simple code's lengths, in the order its symbols came (RFC 7932 §3.4): one symbol takes no
/// bits; two take 1 each; three take 1, 2 and 2; four take 2 each, or 1, 2, 3 and 3 when the
/// tree-select bit is set. The canonical build gives codes of one length in symbol order.
fn build_simple(state: *State, tree_select: bool) void {
    const reading = &state.reading;
    const symbols = reading.simple_symbols[0..reading.simple_count];
    if (symbols.len == 1) return finish(state, symbols[0]);
    const lengths = if (tree_select) &constants.simple_code_lengths_tree_select else constants.simple_code_lengths[symbols.len - constants.code_symbols_min];
    @memset(state.lengths[0..reading.alphabet_len], 0);
    count_work(state, reading.alphabet_len);
    for (symbols, lengths) |symbol, len| state.lengths[symbol] = len;
    finish(state, null);
}

/// One code length of the code length code, in the order of RFC 7932 §3.5, until their sum of
/// 32 >> length reaches 32, or all 18 are read.
pub fn read_code_length_code(state: *State, bits: *codec.BitReader) Error!?codec.Status {
    const reading = &state.reading;
    _ = bits.ensure(constants.code_length_code_length_bits_max);
    const decoded = prefix.decode_code_length_code_length(bits.peek(@min(bits.bits.count, codec.constants.ensure_bits_max)), @min(bits.bits.count, codec.constants.ensure_bits_max)) orelse return .needs_input;
    bits.consume(decoded.len);
    count_work(state, 1);
    const symbol = constants.code_length_code_order[reading.index];
    state.lengths[symbol] = decoded.value;
    reading.index += 1;
    if (decoded.value != 0) {
        reading.space -= @as(i32, constants.code_length_code_space) >> @intCast(decoded.value);
        reading.nonzero_count += 1;
    }
    // A sum that reaches 32 or passes it ends the lengths, as does the alphabet's end.
    if (reading.space > 0 and reading.index < constants.code_length_alphabet_len) return null;
    try build_code_length_code(state);
    return null;
}

/// The code length code, once its lengths are read, and the start of the code lengths.
fn build_code_length_code(state: *State) Error!void {
    const reading = &state.reading;
    const lengths = state.lengths[0..constants.code_length_alphabet_len];
    // RFC 7932 §3.5: the sum of 32 >> code length must equal 32.
    if (reading.space < 0) return error.OverSubscribedCodeLengthCode;
    if (reading.space == 0) {
        count_work(state, state.code_length_code.build(lengths));
    } else if (reading.nonzero_count == 1) {
        // RFC 7932 §3.5: one non-zero code length gives a code of one symbol, of no bits.
        count_work(state, state.code_length_code.build_single(@intCast(std.mem.indexOfNone(u8, lengths, &.{0}).?)));
    } else {
        // RFC 7932 §3.5: the sum of 32 >> code length must equal 32.
        return error.IncompleteCodeLengthCode;
    }
    @memset(state.lengths[0..reading.alphabet_len], 0);
    count_work(state, reading.alphabet_len);
    reading.index = 0;
    reading.space = constants.code_lengths_space;
    reading.previous_len = constants.previous_len_initial;
    reading.repeat_symbol = 0;
    reading.repeat_count = 0;
    state.phase = .code_lengths;
}

/// Code lengths of the alphabet's symbols, until their sum of 32768 >> length reaches 32768 (RFC
/// 7932 §3.5): at least one that takes bits, or every one a code of no bits gives in a row.
pub fn read_code_lengths(state: *State, bits: *codec.BitReader) Error!?codec.Status {
    // A code length of no bits gives at least one length, so the alphabet ends the loop.
    for (0..state.reading.alphabet_len) |_| {
        const taken = try read_code_length(state, bits) orelse return .needs_input;
        if (state.phase != .code_lengths or taken > 0) return null;
    }
    unreachable;
}

/// One code length symbol and its extra bits, and the lengths it gives; the bits it took, or null
/// while they are not all present.
fn read_code_length(state: *State, bits: *codec.BitReader) Error!?u7 {
    const reading = &state.reading;
    _ = bits.ensure(constants.code_length_code_len_max + constants.repeat_zero_extra_bits);
    const available = @min(bits.bits.count, codec.constants.ensure_bits_max);
    const buffer = bits.peek(available);
    const decoded = switch (state.code_length_code.decode(buffer, available)) {
        .symbol => |symbol| symbol,
        .needs_bits => return null,
    };
    const symbol: u8 = @intCast(decoded.value);
    const extra_bits: u7 = switch (symbol) {
        constants.repeat_previous_symbol => constants.repeat_previous_extra_bits,
        constants.repeat_zero_symbol => constants.repeat_zero_extra_bits,
        else => 0,
    };
    if (decoded.len + extra_bits > available) return null;
    const extra: u32 = @intCast((buffer >> @intCast(decoded.len)) & ((@as(u64, 1) << @intCast(extra_bits)) - 1));
    bits.consume(decoded.len + extra_bits);
    count_work(state, 1);
    if (symbol < constants.repeat_previous_symbol) {
        set_length(state, symbol);
    } else {
        try repeat_length(state, symbol, extra);
    }
    // RFC 7932 §3.5: the sum of 32768 >> code length must equal 32768.
    if (reading.space < 0) return error.OverSubscribedCode;
    if (reading.space == 0) {
        finish(state, null);
    } else if (reading.index == reading.alphabet_len) {
        // RFC 7932 §3.5: the sum of 32768 >> code length must equal 32768.
        return error.IncompleteCode;
    }
    return decoded.len + extra_bits;
}

/// A code length of 0 to 15 for the next symbol.
fn set_length(state: *State, len: u8) void {
    const reading = &state.reading;
    assert(reading.index < reading.alphabet_len);
    state.lengths[reading.index] = len;
    reading.index += 1;
    reading.repeat_symbol = 0;
    if (len == 0) return;
    reading.previous_len = len;
    reading.space -= @as(i32, constants.code_lengths_space) >> @intCast(len);
}

/// Code 16 or 17 (RFC 7932 §3.5): 3 or more copies of the previous non-zero length, or of zero. The
/// same code right after itself makes the count (factor * (count - 2)) + its own, the factor 4 or 8.
fn repeat_length(state: *State, symbol: u8, extra: u32) Error!void {
    const reading = &state.reading;
    const zeros = symbol == constants.repeat_zero_symbol;
    const extra_bits: u5 = if (zeros) constants.repeat_zero_extra_bits else constants.repeat_previous_extra_bits;
    const factor: u32 = @as(u32, 1) << extra_bits;
    const earlier: u32 = if (reading.repeat_symbol == symbol) reading.repeat_count else 0;
    const count: u32 = if (earlier == 0) constants.repeat_len_min + extra else factor * (earlier - constants.repeat_count_offset) + constants.repeat_len_min + extra;
    const added = count - earlier;
    // RFC 7932 §3.5: a repeat that would give more lengths than the alphabet has symbols should be
    // rejected as invalid.
    if (reading.index + added > reading.alphabet_len) return error.RepeatPastEnd;
    const len: u8 = if (zeros) 0 else reading.previous_len;
    @memset(state.lengths[reading.index..][0..added], len);
    count_work(state, added);
    reading.index += @intCast(added);
    reading.repeat_symbol = symbol;
    reading.repeat_count = count;
    if (len != 0) reading.space -= @intCast(added * (@as(u32, constants.code_lengths_space) >> @intCast(len)));
}

/// Builds the code read into the place its target names, and moves the header on: a code of one
/// symbol when `single` holds it, otherwise the code `state.lengths` defines.
fn finish(state: *State, single: ?u16) void {
    const lengths = state.lengths[0..state.reading.alphabet_len];
    const entries = switch (state.reading.target) {
        .block_type => |category| build(&state.blocks[@intFromEnum(category)].type_code, lengths, single),
        .block_count => |category| build(&state.blocks[@intFromEnum(category)].count_code, lengths, single),
        .map => build(&state.map_code, lengths, single),
        .literal => |index| build_literal(&state.literal_codes[index], lengths, single, literal_entry_mode(state)),
        .insert_copy => |index| build(&state.insert_copy_codes[index], lengths, single),
        .distance => |index| build(&state.distance_codes[index], lengths, single),
    };
    count_work(state, entries);
    header.after_code(state);
}

/// Builds the table, and returns the entries it wrote.
fn build(code: anytype, lengths: []const u8, single: ?u16) usize {
    return if (single) |symbol| code.build_single(symbol) else code.build(lengths);
}

/// The mode whose `context.p1_part` the literal tables' entries hold: the first literal block
/// type's, read before the trees (RFC 7932 §9.2).
pub fn literal_entry_mode(state: *const State) context.Mode {
    return state.context_modes[0];
}

/// Builds a literal table whose entries hold each literal's part of the next context ID in `mode`
/// (`context.literal_entry_value`), and returns the entries it wrote.
fn build_literal(code: anytype, lengths: []const u8, single: ?u16, mode: context.Mode) usize {
    return switch (mode) {
        inline else => |entry_mode| if (single) |symbol|
            code.build_single_valued(symbol, context.literal_entry_value(entry_mode))
        else
            code.build_valued(lengths, context.literal_entry_value(entry_mode)),
    };
}
