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
const lengths_fast = @import("decoder_fast/decoder_fast_lengths.zig");
const State = state_module.State;
const Target = state_module.Target;
const Error = state_module.Error;
const count_work = state_module.count_work;

/// Starts reading the prefix code `target` names, over an alphabet of `alphabet_len` symbols.
pub fn start(state: *State, target: Target, alphabet_len: u16) void {
    assert(alphabet_len >= 1 and alphabet_len <= constants.insert_copy_alphabet_len);
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
    state.reading.counts = @splat(0);
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

/// A simple code's symbols, and its tree-select bit after four (RFC 7932 §3.4), until the code is
/// whole or the input runs out.
pub fn read_simple_symbols(state: *State, bits: *codec.BitReader) align(constants.hot_function_alignment) Error!?codec.Status {
    for (0..constants.simple_symbols_max + 1) |_| {
        if (try read_simple_symbol(state, bits)) |status| return status;
        if (state.phase != .simple_symbols) return null;
    }
    unreachable;
}

/// One symbol of a simple code, or its tree-select bit after four (RFC 7932 §3.4).
fn read_simple_symbol(state: *State, bits: *codec.BitReader) Error!?codec.Status {
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
fn build_simple(state: *State, tree_select: bool) align(constants.hot_function_alignment) void {
    const reading = &state.reading;
    const symbols = reading.simple_symbols[0..reading.simple_count];
    if (symbols.len == 1) return finish_code(state, .{ .single = symbols[0] });
    const lengths = if (tree_select) &constants.simple_code_lengths_tree_select else constants.simple_code_lengths[symbols.len - constants.code_symbols_min];
    var sorted: [constants.simple_symbols_max]prefix.Coded = undefined;
    var counts: prefix.Counts = @splat(0);
    for (sorted[0..symbols.len], symbols, lengths) |*coded, symbol, len| {
        coded.* = .{ .symbol = symbol, .len = len };
        counts[len] += 1;
    }
    std.mem.sort(prefix.Coded, sorted[0..symbols.len], {}, canonical_before);
    finish_code(state, .{ .sorted = .{ .symbols = sorted[0..symbols.len], .counts = &counts } });
}

/// Whether `a` comes before `b` in canonical order: by length, then by symbol (RFC 7932 §3.2).
fn canonical_before(_: void, a: prefix.Coded, b: prefix.Coded) bool {
    return a.len < b.len or (a.len == b.len and a.symbol < b.symbol);
}

/// The code lengths of the code length code, in the order of RFC 7932 §3.5, until their sum of
/// 32 >> length reaches 32 or all 18 are read, or the input runs out. Each is a code of the fixed
/// code §3.5 gives; the loop of decoder_fast_lengths.zig reads them while the input's margin holds,
/// and the checked step reads the rest.
pub fn read_code_length_code(comptime fast_paths: bool, state: *State, bits: *codec.BitReader) align(constants.hot_function_alignment) Error!?codec.Status {
    // Each step reads one length, so the alphabet ends the loop, with one iteration more for the
    // checks after its last length.
    for (0..constants.code_length_alphabet_len + 1) |_| {
        if (fast_paths) lengths_fast.read_code_length_code(state, bits);
        if (try settle_code_length_code(state)) return null;
        try read_code_length_code_length(state, bits) orelse return .needs_input;
    }
    unreachable;
}

/// The checks after each length of the code length code: whether its lengths have ended, and the
/// code is built or refused.
pub fn settle_code_length_code(state: *State) Error!bool {
    const reading = &state.reading;
    // A sum that reaches 32 or passes it ends the lengths, as does the alphabet's end.
    if (reading.space > 0 and reading.index < constants.code_length_alphabet_len) return false;
    try build_code_length_code(state);
    return true;
}

/// One code length of the code length code through the checked reader; null while its bits are not
/// all present.
pub fn read_code_length_code_length(state: *State, bits: *codec.BitReader) Error!?void {
    _ = bits.ensure(constants.code_length_code_length_bits_max);
    const available = @min(bits.bits.count, codec.constants.ensure_bits_max);
    const decoded = prefix.decode_code_length_code_length(bits.peek(available), available) orelse return null;
    bits.consume(decoded.len);
    set_code_length_code_length(state, decoded.value);
}

/// A code length of the code length code for the next symbol of the order of RFC 7932 §3.5. Inline,
/// so that the loop of decoder_fast_lengths.zig keeps the reading's fields in registers.
pub inline fn set_code_length_code_length(state: *State, len: u8) void {
    const reading = &state.reading;
    assert(reading.index < constants.code_length_alphabet_len);
    const symbol = constants.code_length_code_order[reading.index];
    state.lengths[symbol] = len;
    reading.index += 1;
    count_work(state, 1);
    if (len == 0) return;
    reading.counts[len] += 1;
    reading.space -= @as(i32, constants.code_length_code_space) >> @intCast(len);
    reading.nonzero_count += 1;
}

/// The code length code, once its lengths are read, and the start of the code lengths.
fn build_code_length_code(state: *State) Error!void {
    const reading = &state.reading;
    const lengths = state.lengths[0..constants.code_length_alphabet_len];
    // RFC 7932 §3.5: the sum of 32 >> code length must equal 32.
    if (reading.space < 0) return error.OverSubscribedCodeLengthCode;
    if (reading.space == 0) {
        count_work(state, state.code_length_code.build_within_root(lengths, &reading.counts));
    } else if (reading.nonzero_count == 1) {
        // RFC 7932 §3.5: one non-zero code length gives a code of one symbol, of no bits.
        count_work(state, state.code_length_code.build_single(@intCast(std.mem.indexOfNone(u8, lengths, &.{0}).?)));
    } else {
        // RFC 7932 §3.5: the sum of 32 >> code length must equal 32.
        return error.IncompleteCodeLengthCode;
    }
    reading.index = 0;
    reading.counts = @splat(0);
    reading.ranges.reset();
    reading.space = constants.code_lengths_space;
    reading.previous_len = constants.previous_len_initial;
    reading.repeat_symbol = 0;
    reading.repeat_count = 0;
    state.phase = .code_lengths;
}

/// Code lengths of the alphabet's symbols, until their sum of 32768 >> length reaches 32768 (RFC
/// 7932 §3.5) or the input runs out.
pub fn read_code_lengths(comptime fast_paths: bool, state: *State, bits: *codec.BitReader) align(constants.hot_function_alignment) Error!?codec.Status {
    // Each code length symbol gives at least one length, so the alphabet ends the loop, with one
    // iteration more for the checks after its last symbol.
    for (0..state.reading.alphabet_len + 1) |_| {
        if (fast_paths) lengths_fast.read(state, bits);
        if (try settle(state)) return null;
        try read_code_length(state, bits) orelse return .needs_input;
    }
    unreachable;
}

/// The checks after each length: whether the code is whole, and built, or refused.
pub fn settle(state: *State) Error!bool {
    const reading = &state.reading;
    // RFC 7932 §3.5: the sum of 32768 >> code length must equal 32768.
    if (reading.space < 0) return error.OverSubscribedCode;
    if (reading.space == 0) {
        finish(state, null);
        return true;
    }
    // RFC 7932 §3.5: the sum of 32768 >> code length must equal 32768.
    if (reading.index == reading.alphabet_len) return error.IncompleteCode;
    return false;
}

/// One code length symbol and its extra bits through the checked reader, and the lengths it gives;
/// null while they are not all present.
pub fn read_code_length(state: *State, bits: *codec.BitReader) Error!?void {
    _ = bits.ensure(constants.code_length_code_len_max + constants.repeat_zero_extra_bits);
    const available = @min(bits.bits.count, codec.constants.ensure_bits_max);
    const buffer = bits.peek(available);
    const decoded = switch (state.code_length_code.decode(buffer, available)) {
        .symbol => |symbol| symbol,
        .needs_bits => return null,
    };
    const symbol: u8 = @intCast(decoded.value);
    const extra_bits = repeat_extra_bits(symbol);
    if (decoded.len + extra_bits > available) return null;
    const extra: u32 = @intCast((buffer >> @intCast(decoded.len)) & ((@as(u64, 1) << @intCast(extra_bits)) - 1));
    bits.consume(decoded.len + extra_bits);
    count_work(state, 1);
    if (symbol < constants.repeat_previous_symbol) {
        set_length(state, symbol);
    } else {
        const repeat = repeat_of(&state.reading, symbol, extra);
        // RFC 7932 §3.5: a repeat that would give more lengths than the alphabet has symbols should
        // be rejected as invalid.
        if (state.reading.index + repeat.added > state.reading.alphabet_len) return error.RepeatPastEnd;
        apply_repeat(state, symbol, repeat);
    }
}

/// The extra bits a code length symbol takes: 2 for a repeat of the previous length, 3 for a repeat
/// of zero (RFC 7932 §3.5), none for a length.
pub fn repeat_extra_bits(symbol: u8) u7 {
    return switch (symbol) {
        constants.repeat_previous_symbol => constants.repeat_previous_extra_bits,
        constants.repeat_zero_symbol => constants.repeat_zero_extra_bits,
        else => 0,
    };
}

/// A code length of 0 to 15 for the next symbol.
pub inline fn set_length(state: *State, len: u8) void {
    set_length_of(&state.reading, &state.reading.ranges, &state.reading.counts, len);
}

/// As `set_length`, on `tally`: the reading, or the copy of its `index`, `alphabet_len`, `space`,
/// `previous_len`, `repeat_symbol` and `repeat_count` that the loop of decoder_fast_lengths.zig
/// holds in registers and writes back once. The runs and the counts stay the reading's. Inline,
/// with `apply_repeat_of`, so that a copy's fields stay in registers across the call.
pub inline fn set_length_of(tally: anytype, ranges: *prefix.Ranges, counts: *prefix.Counts, len: u8) void {
    assert(tally.index < tally.alphabet_len);
    const symbol = tally.index;
    tally.index += 1;
    tally.repeat_symbol = 0;
    if (len == 0) return;
    ranges.append(len, symbol, 1);
    counts[len] += 1;
    tally.previous_len = len;
    tally.space -= @as(i32, constants.code_lengths_space) >> @intCast(len);
}

/// What code 16 or 17 gives (RFC 7932 §3.5): 3 or more copies of the previous non-zero length, or
/// of zero. The same code right after itself makes the count (factor * (count - 2)) + its own, the
/// factor 4 or 8; `added` is what the count adds to the lengths the earlier code gave.
pub const Repeat = struct { count: u32, added: u32, len: u8 };

/// The repeat a code 16 or 17 gives after the lengths `tally` has read, as `set_length_of` takes it.
pub inline fn repeat_of(tally: anytype, symbol: u8, extra: u32) Repeat {
    const zeros = symbol == constants.repeat_zero_symbol;
    const extra_bits: u5 = if (zeros) constants.repeat_zero_extra_bits else constants.repeat_previous_extra_bits;
    const factor: u32 = @as(u32, 1) << extra_bits;
    const earlier: u32 = if (tally.repeat_symbol == symbol) tally.repeat_count else 0;
    const count: u32 = if (earlier == 0) constants.repeat_len_min + extra else factor * (earlier - constants.repeat_count_offset) + constants.repeat_len_min + extra;
    return .{ .count = count, .added = count - earlier, .len = if (zeros) 0 else tally.previous_len };
}

/// Writes a repeat's lengths, which the caller has checked fit the alphabet.
pub inline fn apply_repeat(state: *State, symbol: u8, repeat: Repeat) void {
    count_work(state, repeat.added);
    apply_repeat_of(&state.reading, &state.reading.ranges, &state.reading.counts, symbol, repeat);
}

/// As `apply_repeat`, on `tally`, as `set_length_of` takes it.
pub inline fn apply_repeat_of(tally: anytype, ranges: *prefix.Ranges, counts: *prefix.Counts, symbol: u8, repeat: Repeat) void {
    assert(tally.index + repeat.added <= tally.alphabet_len);
    const first = tally.index;
    tally.index += @intCast(repeat.added);
    tally.repeat_symbol = symbol;
    tally.repeat_count = repeat.count;
    if (repeat.len == 0) return;
    ranges.append(repeat.len, first, @intCast(repeat.added));
    counts[repeat.len] += @intCast(repeat.added);
    tally.space -= @intCast(repeat.added * (@as(u32, constants.code_lengths_space) >> @intCast(repeat.len)));
}

/// A code read, as its table takes it: one symbol, whose code takes no bits, or the symbols with a
/// code in canonical order and the count of each length.
const Code = union(enum) {
    single: u16,
    sorted: struct { symbols: []const prefix.Coded, counts: *const prefix.Counts },
    ranged: struct { ranges: *const prefix.Ranges, counts: *const prefix.Counts },
};

/// Builds the complex code whose runs of lengths the reading appended, or the code of one symbol
/// when `single` holds it, and moves the header on.
fn finish(state: *State, single: ?u16) void {
    if (single) |symbol| return finish_code(state, .{ .single = symbol });
    finish_code(state, .{ .ranged = .{ .ranges = &state.reading.ranges, .counts = &state.reading.counts } });
}

/// Builds `code` into the place the reading's target names, and moves the header on.
fn finish_code(state: *State, code: Code) align(constants.hot_function_alignment) void {
    const entries = switch (state.reading.target) {
        .block_type => |category| build(&state.blocks[@intFromEnum(category)].type_code, code),
        .block_count => |category| build(&state.blocks[@intFromEnum(category)].count_code, code),
        .map => build(&state.map_code, code),
        .literal => |index| build_literal(&state.literal_codes[index], code, literal_entry_mode(state)),
        .insert_copy => |index| build(&state.insert_copy_codes[index], code),
        .distance => |index| build(&state.distance_codes[index], code),
    };
    count_work(state, entries);
    header.after_code(state);
}

/// Builds the table, and returns the entries it wrote.
fn build(table: anytype, code: Code) usize {
    return switch (code) {
        .single => |symbol| table.build_single(symbol),
        .sorted => |sorted| table.build_sorted(sorted.symbols, sorted.counts),
        .ranged => |ranged| table.build_ranged(ranged.ranges, ranged.counts),
    };
}

/// The mode whose `context.p1_part` the literal tables' entries hold: the first literal block
/// type's, read before the trees (RFC 7932 §9.2).
pub fn literal_entry_mode(state: *const State) context.Mode {
    return state.context_modes[0];
}

/// Builds a literal table whose entries hold each literal's part of the next context ID in `mode`
/// (`context.literal_entry_value`), and returns the entries it wrote.
fn build_literal(table: anytype, code: Code, mode: context.Mode) usize {
    return switch (mode) {
        inline else => |entry_mode| switch (code) {
            .single => |symbol| table.build_single_valued(symbol, context.literal_entry_value(entry_mode)),
            .sorted => |sorted| table.build_sorted_valued(sorted.symbols, sorted.counts, context.literal_entry_value(entry_mode)),
            .ranged => |ranged| table.build_ranged_valued(ranged.ranges, ranged.counts, context.literal_entry_value(entry_mode)),
        },
    };
}

// Tests.
