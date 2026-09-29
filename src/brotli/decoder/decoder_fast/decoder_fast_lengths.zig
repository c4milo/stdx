//! The brotli header's fast path for a complex code's code lengths (RFC 7932 §3.5), an experiment
//! under decision 16 during design §8 step 12. The symbols of the code length code, each with its
//! extra bits, come from a 64-bit buffer refilled by whole words while at least `input_slack`
//! octets of input remain, and each is applied through the checked path's own functions. The loop
//! leaves the reader and the state where the checked steps would, and the checked path finishes
//! the code: the checks after its last symbol, and every refusal.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const state_module = @import("../decoder_state.zig");
const prefix_reader = @import("../decoder_prefix.zig");
const fast = @import("decoder_fast.zig");
const State = state_module.State;
const count_work = state_module.count_work;

/// The most bits one symbol takes: a code of the code length code and a repeat's extra bits.
const symbol_bits_max = constants.code_length_code_len_max + constants.repeat_zero_extra_bits;

/// The bits a refill adds: the seven whole octets that fit above fewer than eight bits.
const refill_bits = @bitSizeOf(u64) - @bitSizeOf(u8);

comptime {
    assert(symbol_bits_max <= @bitSizeOf(u8));
}

/// The reader's state in locals: the input, the position of the next octet, and the bits taken from
/// the octets before it, least significant bit first (RFC 7932 §1.5.1).
const Bits = struct {
    input: []const u8,
    position: usize,
    buffer: u64,
    count: u32,

    /// Whether the buffer holds a symbol's bits, after a refill when it holds fewer than eight and
    /// the input's margin holds: one 8-octet load, of which seven whole octets fit. The bits above
    /// `count` repeat the input's next octet, which the next load writes again unchanged.
    inline fn has_symbol_bits(self: *Bits) bool {
        if (self.count >= @bitSizeOf(u8)) return true;
        if (self.input.len - self.position < fast.input_slack) return false;
        const loaded = std.mem.readInt(u64, self.input[self.position..][0..@sizeOf(u64)], .little);
        self.buffer |= loaded << @intCast(self.count);
        self.position += refill_bits / @bitSizeOf(u8);
        self.count += refill_bits;
        return true;
    }

    /// Takes `bit_count` bits, at most `symbol_bits_max`.
    inline fn take(self: *Bits, bit_count: u32) void {
        assert(bit_count <= symbol_bits_max and bit_count <= self.count);
        self.buffer >>= @intCast(bit_count);
        self.count -= bit_count;
    }
};

/// Reads code length symbols while the input's margin holds and the code goes on, applying each as
/// the checked path does, and hands the reader back. A repeat that would pass the alphabet's end
/// stays unread, for the checked path to refuse.
pub fn read(state: *State, bits: *codec.BitReader) void {
    const reading = &state.reading;
    var local: Bits = .{
        .input = bits.reader.octets,
        .position = bits.reader.position,
        .buffer = bits.bits.buffer,
        .count = bits.bits.count,
    };
    assert(local.count <= @bitSizeOf(u64));
    // Each symbol gives at least one length, so the alphabet ends the loop.
    for (0..reading.alphabet_len) |_| {
        if (reading.space <= 0 or reading.index >= reading.alphabet_len) break;
        if (!local.has_symbol_bits()) break;
        const decoded = state.code_length_code.decode_whole(true, local.buffer);
        const symbol: u8 = @intCast(decoded.value);
        const extra_bits = prefix_reader.repeat_extra_bits(symbol);
        const extra: u32 = @intCast((local.buffer >> @intCast(decoded.len)) & ((@as(u64, 1) << @intCast(extra_bits)) - 1));
        if (symbol < constants.repeat_previous_symbol) {
            local.take(decoded.len);
            prefix_reader.set_length(state, symbol);
        } else {
            const repeat = prefix_reader.repeat_of(reading, symbol, extra);
            // RFC 7932 §3.5: a repeat that would give more lengths than the alphabet has symbols
            // should be rejected as invalid; the checked path refuses it.
            if (reading.index + repeat.added > reading.alphabet_len) break;
            local.take(decoded.len + extra_bits);
            prefix_reader.apply_repeat(state, symbol, repeat);
        }
        count_work(state, 1);
    }
    assert(local.position <= local.input.len);
    // Hand the reader back as the checked reader keeps it: no bit above `count` set.
    bits.bits = .{
        .buffer = if (local.count >= @bitSizeOf(u64)) local.buffer else fast.low_bits(local.buffer, local.count),
        .count = @intCast(local.count),
    };
    bits.reader.position = local.position;
}

// Tests.

const testing = std.testing;
const decoder_module = @import("../decoder.zig");
const test_stream = @import("../test_stream.zig");
const Stream = test_stream.Stream;
const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });
const test_window_bits = 16;

/// Zero octets after the stream, two margins, so that the loop's margin holds to the code's end.
const padding_margins = 2;
const padding_len = padding_margins * fast.input_slack;

/// A literal code of 64 symbols of 6 bits, after 10 zeros and around 5 more, whose code lengths take
/// 74 bits, so that the loop refills: the code length code gives 6 one bit, and 16 and 17 two bits
/// each, in the code length code order (RFC 7932 §3.5).
const repeat_code_len = 2;
const len_code_len = 1;
const code_length_lengths = [_]u8{ 0, 0, 0, 0, 0, 0, repeat_code_len, len_code_len, repeat_code_len };
const coded_len = 6;
/// The repeat symbols among the code lengths: the leading zeros, the repeat and the middle zeros.
const repeat_symbols = 3;
const leading_zeros_extra = 7;
const sixes_before_repeat = 40;
const repeat_extra = 1;
const middle_zeros_extra = 2;
const sixes_after_zeros = 20;
const code_lengths = code_lengths: {
    var symbols: [sixes_before_repeat + sixes_after_zeros + repeat_symbols]test_stream.LengthSymbol = undefined;
    var count: usize = 0;
    symbols[count] = .{ .symbol = constants.repeat_zero_symbol, .extra = leading_zeros_extra };
    count += 1;
    for (0..sixes_before_repeat) |_| {
        symbols[count] = .{ .symbol = coded_len };
        count += 1;
    }
    symbols[count] = .{ .symbol = constants.repeat_previous_symbol, .extra = repeat_extra };
    count += 1;
    symbols[count] = .{ .symbol = constants.repeat_zero_symbol, .extra = middle_zeros_extra };
    count += 1;
    for (0..sixes_after_zeros) |_| {
        symbols[count] = .{ .symbol = coded_len };
        count += 1;
    }
    assert(count == symbols.len);
    break :code_lengths symbols;
};

/// The stream up to the literal code's code lengths, padded.
fn code_lengths_stream(padded: *[test_stream.capacity + padding_len]u8) []const u8 {
    var stream: Stream = .{};
    stream.window_bits_16();
    stream.meta_block(true, 1);
    stream.simple_header(0, 0, 0);
    stream.complex_code(0, &code_length_lengths, &code_lengths);
    const written = stream.written();
    @memcpy(padded[0..written.len], written);
    @memset(padded[written.len..][0..padding_len], 0);
    return padded[0 .. written.len + padding_len];
}

/// The bit a reader stands at, counted from the input's first octet: the loop takes whole octets
/// ahead of the bits it consumes, so it stands where the checked reader does only in bits.
fn bit_position(bits: *const codec.BitReader) i64 {
    return @as(i64, @intCast(bits.reader.position)) * @bitSizeOf(u8) - bits.bits.count;
}

const Outcome = enum { whole, needs_input };

/// The checked steps from the state's point until the code is whole or the input ends, as
/// `read_code_lengths` takes them after the loop.
fn finish_checked(state: *State, bits: *codec.BitReader) !Outcome {
    for (0..state.reading.alphabet_len + 1) |_| {
        if (try prefix_reader.settle(state)) return .whole;
        (try prefix_reader.read_code_length(state, bits)) orelse return .needs_input;
    }
    unreachable;
}

test "the loop leaves the state and the reader where the checked steps leave them, at every input" {
    var padded: [test_stream.capacity + padding_len]u8 = undefined;
    const input = code_lengths_stream(&padded);
    // An octet at a time, until the code length code is built and the code lengths begin.
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var fed: usize = 0;
    var output: [1]u8 = undefined;
    for (0..input.len) |_| {
        if (decoder.state.phase == .code_lengths) break;
        const progress = try decoder.decode(input[fed .. fed + 1], &output);
        try testing.expectEqual(.needs_input, progress.status);
        fed += 1;
    }
    try testing.expectEqual(.code_lengths, decoder.state.phase);
    const rest = input[fed..];
    var refilled = false;
    for (0..rest.len + 1) |available| {
        var fast_state: State = decoder.state;
        var checked_state: State = decoder.state;
        var fast_reader = codec.BitReader.init(rest[0..available], decoder.state.bits);
        var checked_reader = codec.BitReader.init(rest[0..available], decoder.state.bits);
        read(&fast_state, &fast_reader);
        if (fast_reader.reader.position > 0) refilled = true;
        const fast_outcome = try finish_checked(&fast_state, &fast_reader);
        const checked_outcome = try finish_checked(&checked_state, &checked_reader);
        try testing.expectEqual(checked_outcome, fast_outcome);
        try testing.expectEqual(bit_position(&checked_reader), bit_position(&fast_reader));
        try testing.expectEqual(checked_state.reading, fast_state.reading);
        try testing.expectEqual(checked_state.phase, fast_state.phase);
        try testing.expectEqual(checked_state.work, fast_state.work);
    }
    try testing.expect(refilled);
}
