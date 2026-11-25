//! The brotli header's fast path for a context map's values (RFC 7932 §7.3), under decision 16
//! during design §8 step 12. Each symbol of the map's code, with a run's extra bits, comes from a
//! 64-bit buffer refilled by whole words while at least `input_slack` octets of input remain, and
//! is applied as `header.read_map_value` applies it; the index stays in a register and a run of
//! zeros takes `header.fill_zeros`. The loop leaves the reader and the state where the checked
//! steps would, and the checked path finishes the map: its symbols past the margin, and every
//! refusal.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const state_module = @import("../decoder_state.zig");
const fast = @import("decoder_fast.zig");
const lengths = @import("decoder_fast_lengths.zig");
const header = @import("../decoder_header.zig");
const State = state_module.State;
const count_work = state_module.count_work;

/// The most bits one symbol takes: a code of the map's code and a run's extra bits.
const symbol_bits_max = constants.code_len_max + constants.run_length_codes_max;

comptime {
    // A whole-word refill leaves at least a symbol's bits.
    assert(symbol_bits_max <= fast.refill_bits);
}

/// Reads the values of the map whose `entries` the state's reading stands in, while the input's
/// margin holds and the map goes on, and hands the reader back. A run of zeros past the map's end
/// stays unread, for the checked path to refuse.
pub fn read(state: *State, bits: *codec.BitReader, entries: []u8) void {
    const reading = &state.map_reading;
    assert(reading.index <= entries.len);
    const run_length_codes = reading.run_length_codes;
    var index: u32 = reading.index;
    var local = lengths.Bits.of(bits);
    // Each symbol gives at least one entry, so the map's length ends the loop.
    for (0..entries.len) |_| {
        if (index >= entries.len) break;
        if (local.count < symbol_bits_max and !local.refill_whole()) break;
        const decoded = state.map_code.decode_whole(false, local.buffer);
        if (decoded.value == 0 or decoded.value > run_length_codes) {
            take(&local, decoded.len);
            count_work(state, 1);
            // RLEMAX + n is the value n; 0 is the value 0.
            entries[index] = @intCast(if (decoded.value == 0) 0 else decoded.value - run_length_codes);
            index += 1;
            continue;
        }
        // A run of zeros, (1 << n) + n extra bits long.
        const extra_bits: u5 = @intCast(decoded.value);
        const extra: u32 = @intCast((local.buffer >> @intCast(decoded.len)) & ((@as(u64, 1) << extra_bits) - 1));
        const run = (@as(u32, 1) << extra_bits) + extra;
        // RFC 7932 §7.3: a run past the size of the context map should be rejected as invalid; the
        // checked path refuses it.
        if (index + run > entries.len) break;
        take(&local, decoded.len + extra_bits);
        header.fill_zeros(entries, index, run);
        count_work(state, 1 + run);
        index += run;
    }
    reading.index = index;
    local.hand_back(bits);
}

/// Takes `bit_count` bits, at most a symbol's.
inline fn take(local: *lengths.Bits, bit_count: u32) void {
    assert(bit_count <= symbol_bits_max and bit_count <= local.count);
    local.buffer >>= @intCast(bit_count);
    local.count -= bit_count;
}

// Tests.

const testing = std.testing;
const decoder_module = @import("../decoder.zig");
const test_stream = @import("../test_stream.zig");
const Stream = test_stream.Stream;
const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });
const test_window_bits = 16;

/// Zero octets after the stream, two margins, so that the loop's margin holds to the map's end.
const padding_margins = 2;
const padding_len = padding_margins * fast.input_slack;

/// Four literal block types, whose map takes 256 values, and three trees, RLEMAX 2 (RFC 7932 §7.3):
/// the map's code gives the symbols 0, a run of 4 to 7 zeros, and the values 1 and 2, 2 bits each.
const map_block_types = 4;
const map_trees = 3;
const map_run_length_codes = 2;
const run_symbol = 2;
const one_symbol = map_run_length_codes + 1;
const two_symbol = one_symbol + 1;
const map_symbols = [_]u16{ 0, run_symbol, one_symbol, two_symbol };
const map_code_bits = 2;
/// The symbols' codes, in their order (RFC 7932 §3.4).
const zero_code = 0;
const run_code = 1;
const one_code = 2;
const two_code = 3;
/// Each round: the values 1 and 2, a run of 5 zeros, and the value 0: 8 entries in 10 bits.
const round_len = 8;
const run_extra = 1;

/// The stream up to the literal context map's values and all of them, padded, the last run
/// `last_extra` long past its 4.
fn map_stream(padded: *[test_stream.capacity + padding_len]u8, last_extra: u2) []const u8 {
    var stream: Stream = .{};
    stream.window_bits_16();
    stream.meta_block(true, 1);
    // NBLTYPESL 4: the block type code of symbol 1, the count code of symbol 0 and its 2 extra bits.
    stream.count(map_block_types);
    stream.simple_code(map_block_types + constants.block_type_symbol_offset, &.{1}, false);
    stream.simple_code(constants.block_count_alphabet_len, &.{0}, false);
    stream.put(0, constants.block_count_codes[0].extra_bits);
    stream.count(1);
    stream.count(1);
    stream.put(0, constants.postfix_field_bits);
    stream.put(0, constants.direct_field_bits);
    for (0..map_block_types) |_| stream.put(0, constants.context_mode_bits);
    stream.count(map_trees);
    // RLEMAX 2: a 1, then RLEMAX - 1 in 4 bits.
    stream.put(1, 1);
    stream.put(map_run_length_codes - 1, constants.run_length_field_bits);
    stream.simple_code(map_trees + map_run_length_codes, &map_symbols, false);
    const rounds = map_block_types * constants.literal_contexts_count / round_len;
    for (0..rounds) |round| {
        stream.put_code(one_code, map_code_bits);
        stream.put_code(two_code, map_code_bits);
        // A run's symbol n takes n extra bits.
        stream.put_code(run_code, map_code_bits);
        stream.put(if (round + 1 == rounds) last_extra else run_extra, run_symbol);
        stream.put_code(zero_code, map_code_bits);
    }
    const written = stream.written();
    @memcpy(padded[0..written.len], written);
    @memset(padded[written.len..][0..padding_len], 0);
    return padded[0 .. written.len + padding_len];
}

/// Decodes `input` an octet at a time until the decoder stands at the map's values, and returns
/// how many octets that took.
fn feed_until_values(decoder: *Decoder, input: []const u8) !usize {
    var fed: usize = 0;
    var output: [1]u8 = undefined;
    for (0..input.len) |_| {
        if (decoder.state.phase == .map_values) break;
        const progress = try decoder.decode(input[fed .. fed + 1], &output);
        try testing.expectEqual(.needs_input, progress.status);
        fed += 1;
    }
    try testing.expectEqual(.map_values, decoder.state.phase);
    return fed;
}

/// The bit a reader stands at, counted from the input's first octet.
fn bit_position(bits: *const codec.BitReader) i64 {
    return @as(i64, @intCast(bits.reader.position)) * @bitSizeOf(u8) - bits.bits.count;
}

test "the map's loop leaves the state and the reader where the checked steps leave them, at every input" {
    var padded: [test_stream.capacity + padding_len]u8 = undefined;
    const input = map_stream(&padded, run_extra);
    var decoder: Decoder = undefined;
    decoder.init(.{});
    const rest = input[try feed_until_values(&decoder, input)..];
    var refilled = false;
    for (0..rest.len + 1) |available| {
        var fast_state: State = decoder.state;
        var checked_state: State = decoder.state;
        var fast_reader = codec.BitReader.init(rest[0..available], decoder.state.bits);
        var checked_reader = codec.BitReader.init(rest[0..available], decoder.state.bits);
        read(&fast_state, &fast_reader, fast_state.literal_context_map[0 .. map_block_types * constants.literal_contexts_count]);
        if (fast_reader.reader.position > 0) refilled = true;
        try testing.expectEqual(try header.read_map_values(false, &checked_state, &checked_reader), try header.read_map_values(false, &fast_state, &fast_reader));
        try testing.expectEqual(bit_position(&checked_reader), bit_position(&fast_reader));
        try testing.expectEqual(checked_state.map_reading, fast_state.map_reading);
        try testing.expectEqualSlices(u8, &checked_state.literal_context_map, &fast_state.literal_context_map);
        try testing.expectEqual(checked_state.phase, fast_state.phase);
        try testing.expectEqual(checked_state.work, fast_state.work);
    }
    try testing.expect(refilled);
}

test "a run past the map's end stays for the checked path to refuse" {
    var padded: [test_stream.capacity + padding_len]u8 = undefined;
    // The last run of 5 becomes 7, two entries past the map's 256.
    const last_extra = 3;
    const input = map_stream(&padded, last_extra);
    var decoder: Decoder = undefined;
    decoder.init(.{});
    const rest = input[try feed_until_values(&decoder, input)..];
    var reader = codec.BitReader.init(rest, decoder.state.bits);
    read(&decoder.state, &reader, decoder.state.literal_context_map[0 .. map_block_types * constants.literal_contexts_count]);
    try testing.expect(decoder.state.map_reading.index < map_block_types * constants.literal_contexts_count);
    try testing.expectError(error.RepeatPastEnd, header.read_map_values(false, &decoder.state, &reader));
}
