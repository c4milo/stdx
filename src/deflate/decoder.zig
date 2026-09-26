//! The DEFLATE decoder's checked path (RFC 1951; decisions 11 and 16): every bit read through
//! `codec.BitReader`, every octet written through `codec.Writer`, and every back-reference read
//! through `codec.Window`, one step at a time.
//!
//! A step reads one header field, one symbol with its extra bits, one length/distance pair, or
//! copies one octet. A step that lacks bits leaves the ones it has in the state and the call returns
//! `needs_input`, having taken every octet of its input; a step that must write with no room left
//! returns `needs_room`. A length/distance pair is read whole or not at all, so the state never
//! holds half of one.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("constants.zig");
const huffman = @import("huffman.zig");
const lookup = @import("lookup.zig");
const fast = @import("fast.zig");

/// Every way a stream breaks RFC 1951.
pub const Corrupt = error{
    InvalidBlockType,
    StoredLengthMismatch,
    TooManyLiteralLengthCodes,
    OverSubscribedCode,
    IncompleteCode,
    MissingEndOfBlock,
    RepeatWithoutLength,
    RepeatPastEnd,
    InvalidCode,
    InvalidLiteralLength,
    InvalidLength,
    InvalidDistance,
    DistanceTooFar,
};

/// Every valid feature the decoder refuses: none. A raw DEFLATE stream carries no option.
pub const Unsupported = error{};

pub const Error = Corrupt || Unsupported;

/// The class of every error `decode` returns (decision 11).
pub fn refusal(err: Error) codec.Refusal {
    inline for (@typeInfo(Unsupported).error_set orelse &.{}) |unsupported| {
        if (err == @field(anyerror, unsupported.name)) return .unsupported;
    }
    return .corrupt;
}

const Phase = enum(u8) {
    block_header,
    stored_header,
    stored_copy,
    table_counts,
    code_length_code,
    code_lengths,
    symbols,
    copy,
    done,
    refused,
};

pub const Decoder = struct {
    window: codec.Window(constants.window_len),
    bits: codec.Bits,
    phase: Phase,
    /// BFINAL of the block being read (RFC 1951 §3.2.3).
    last_block: bool,
    /// The block's symbols take RFC 1951 §3.2.6's fixed codes, not its own.
    fixed_codes: bool,
    /// Octets of a stored block not yet copied.
    stored_left: u16,
    /// The octets a length/distance pair has left to copy, and how far back.
    copy_len: u16,
    copy_distance: u16,
    /// The farthest distance the stream may take: the window, or the smaller window a container
    /// declares (`limit_window`).
    distance_max: u16,
    /// A dynamic block's HLIT + 257, HDIST + 1 and HCLEN + 4 (RFC 1951 §3.2.7), and how many of
    /// its code lengths have been read.
    literal_length_count: u16,
    distance_count: u16,
    code_length_count: u16,
    header_index: u16,
    lengths: [constants.literal_length_alphabet_len + constants.distance_alphabet_len]u8,
    code_length_code: huffman.Code(constants.code_length_alphabet_len),
    literal_length_code: huffman.Code(constants.literal_length_alphabet_len),
    distance_code: huffman.Code(constants.distance_alphabet_len),
    /// The dynamic block's codes as the fast path's lookup tables (decision 14, S2).
    literal_length_table: lookup.LiteralLengthTable,
    distance_table: lookup.DistanceTable,
    /// The caller's CPU features (decision 21), which the fast path of design §8 step 7 reads.
    features: codec.Features,
    /// Invariant 17's count, which test builds alone keep: the table entries the decoder has
    /// touched and the symbols it has decoded since `init`, one per entry and one per decode, and
    /// at most `constants.build_work_max` per code built.
    work: huffman.Work,
};

comptime {
    assert(@sizeOf(Decoder) <= constants.window_len + constants.decoder_state_budget_len);
}

/// Starts a stream. Writes no octet of the window (decision 11).
pub fn init(decoder: *Decoder, features: codec.Features) void {
    decoder.window.init();
    decoder.bits = .{};
    decoder.phase = .block_header;
    decoder.last_block = false;
    decoder.fixed_codes = false;
    decoder.stored_left = 0;
    decoder.copy_len = 0;
    decoder.copy_distance = 0;
    decoder.distance_max = constants.window_len;
    decoder.features = features;
    decoder.work = huffman.work_zero;
}

/// Refuses distances past `window_len`, the window a container declares for the stream (decision
/// 12). The caller calls it after `init` and before the first `decode`.
pub fn limit_window(decoder: *Decoder, window_len: usize) void {
    assert(std.math.isPowerOfTwo(window_len));
    assert(window_len <= constants.window_len);
    assert(decoder.phase == .block_header and decoder.window.reach() == 0);
    decoder.distance_max = @intCast(window_len);
}

/// Adds to invariant 17's count, in a test build.
fn count_work(decoder: *Decoder, work: usize) void {
    if (builtin.is_test) decoder.work += work;
}

/// What a decode may use. Tests and the fuzzer build both settings and compare them (decision 16).
pub const Options = struct {
    /// The fast path of decision 16, for the symbols of a block while the margins hold.
    fast_paths: bool = true,
};

/// Decodes as much of `input` into `output` as both allow (decision 11).
pub fn decode(decoder: *Decoder, input: []const u8, output: []u8) Error!codec.Progress {
    return decode_with(.{}, decoder, input, output);
}

/// `decode`, with the paths `options` names.
pub fn decode_with(comptime options: Options, decoder: *Decoder, input: []const u8, output: []u8) Error!codec.Progress {
    codec.check_entry(input, output);
    // A call after `done` or after a refusal, without `init`, is a programmer error (decision 11).
    assert(decoder.phase != .done and decoder.phase != .refused);
    var bits = codec.BitReader.init(input, decoder.bits);
    var writer = codec.Writer.init(output);
    const status = run(options, decoder, &bits, &writer, input.len, output.len) catch |err| {
        decoder.phase = .refused;
        return err;
    };
    // Decision 11's read-ahead rule: hand back the whole octets not used, unless the call ends for
    // want of input, when every octet it holds belongs to the step it could not finish.
    if (status != .needs_input) bits.unread_whole_octets();
    decoder.bits = bits.finish();
    const progress: codec.Progress = .{ .consumed = bits.consumed(), .written = writer.written().len, .status = status };
    codec.check_progress(input.len, output.len, progress);
    return progress;
}

fn run(comptime options: Options, decoder: *Decoder, bits: *codec.BitReader, writer: *codec.Writer, input_len: usize, output_len: usize) Error!codec.Status {
    const units = @bitSizeOf(u8) * input_len + codec.constants.bit_buffer_bits + output_len;
    const steps_max = constants.steps_per_unit * units + constants.steps_floor;
    for (0..steps_max) |_| {
        if (try step(options, decoder, bits, writer)) |status| return status;
    }
    // Every step takes a bit or writes an octet, or is followed by one that does.
    unreachable;
}

/// One step, and the status that ends the call, or null to go on.
fn step(comptime options: Options, decoder: *Decoder, bits: *codec.BitReader, writer: *codec.Writer) Error!?codec.Status {
    return switch (decoder.phase) {
        .block_header => try read_block_header(decoder, bits),
        .stored_header => try read_stored_header(decoder, bits),
        .stored_copy => copy_stored(decoder, bits, writer),
        .table_counts => try read_table_counts(decoder, bits),
        .code_length_code => try read_code_length_code(decoder, bits),
        .code_lengths => try read_code_lengths(decoder, bits),
        .symbols => if (options.fast_paths) try read_symbols_fast(decoder, bits, writer) else try read_symbol(decoder, bits, writer),
        .copy => copy_match(decoder, writer),
        .done, .refused => unreachable,
    };
}

/// The end of a block: the stream's end after its last block (RFC 1951 §3.2.3, BFINAL).
fn end_block(decoder: *Decoder) ?codec.Status {
    if (decoder.last_block) {
        decoder.phase = .done;
        return .done;
    }
    decoder.phase = .block_header;
    return null;
}

fn emit(decoder: *Decoder, writer: *codec.Writer, octet: u8) void {
    assert(writer.room_len() > 0);
    writer.write_octet(octet) catch unreachable;
    decoder.window.push(octet);
}

fn read_block_header(decoder: *Decoder, bits: *codec.BitReader) Error!?codec.Status {
    if (!bits.ensure(constants.final_bits + constants.type_bits)) return .needs_input;
    decoder.last_block = bits.read(constants.final_bits).? == 1;
    const block_type: constants.BlockType = @enumFromInt(bits.read(constants.type_bits).?);
    switch (block_type) {
        .stored => decoder.phase = .stored_header,
        .fixed => {
            decoder.fixed_codes = true;
            decoder.phase = .symbols;
        },
        .dynamic => {
            decoder.fixed_codes = false;
            decoder.phase = .table_counts;
        },
        // RFC 1951 §3.2.3: BTYPE 11 is reserved (error).
        .reserved => return error.InvalidBlockType,
    }
    return null;
}

fn read_stored_header(decoder: *Decoder, bits: *codec.BitReader) Error!?codec.Status {
    // RFC 1951 §3.2.4: the bits up to the next octet boundary are ignored. Aligning again after a
    // call that ran out of input drops nothing.
    bits.align_to_octet();
    if (!bits.ensure(constants.stored_header_bits)) return .needs_input;
    const len: u16 = @intCast(bits.read(constants.stored_len_bits).?);
    const len_complement: u16 = @intCast(bits.read(constants.stored_len_bits).?);
    // RFC 1951 §3.2.4: NLEN is the one's complement of LEN.
    if (len_complement != ~len) return error.StoredLengthMismatch;
    decoder.stored_left = len;
    decoder.phase = .stored_copy;
    return null;
}

fn copy_stored(decoder: *Decoder, bits: *codec.BitReader, writer: *codec.Writer) ?codec.Status {
    if (decoder.stored_left == 0) return end_block(decoder);
    if (writer.room_len() == 0) return .needs_room;
    const octet = bits.read(@bitSizeOf(u8)) orelse return .needs_input;
    emit(decoder, writer, @intCast(octet));
    decoder.stored_left -= 1;
    return null;
}

fn read_table_counts(decoder: *Decoder, bits: *codec.BitReader) Error!?codec.Status {
    if (!bits.ensure(constants.hlit_bits + constants.hdist_bits + constants.hclen_bits)) return .needs_input;
    const literal_length_count = constants.hlit_base + @as(u16, @intCast(bits.read(constants.hlit_bits).?));
    decoder.distance_count = constants.hdist_base + @as(u16, @intCast(bits.read(constants.hdist_bits).?));
    decoder.code_length_count = constants.hclen_base + @as(u16, @intCast(bits.read(constants.hclen_bits).?));
    // RFC 1951 §3.2.7: HLIT gives 257 - 286 literal/length codes.
    if (literal_length_count > constants.literal_length_used) return error.TooManyLiteralLengthCodes;
    decoder.literal_length_count = literal_length_count;
    decoder.lengths = @splat(0);
    count_work(decoder, decoder.lengths.len);
    decoder.header_index = 0;
    decoder.phase = .code_length_code;
    return null;
}

/// Reads one 3-bit code length of the code length alphabet, or builds that code after the last.
fn read_code_length_code(decoder: *Decoder, bits: *codec.BitReader) Error!?codec.Status {
    if (decoder.header_index == decoder.code_length_count) {
        try decoder.code_length_code.build(decoder.lengths[0..constants.code_length_alphabet_len], .complete, &decoder.work);
        decoder.header_index = 0;
        decoder.phase = .code_lengths;
        return null;
    }
    const len = bits.read(constants.code_length_code_bits) orelse return .needs_input;
    decoder.lengths[constants.code_length_order[decoder.header_index]] = @intCast(len);
    count_work(decoder, 1);
    decoder.header_index += 1;
    return null;
}

/// Reads one code length symbol, with a repeat's extra bits, or builds the block's codes after the
/// last length.
fn read_code_lengths(decoder: *Decoder, bits: *codec.BitReader) Error!?codec.Status {
    const total = decoder.literal_length_count + decoder.distance_count;
    if (decoder.header_index == total) {
        try build_block_codes(decoder);
        decoder.phase = .symbols;
        return null;
    }
    _ = bits.ensure(constants.code_length_symbol_bits_max);
    const available = @min(bits.bits.count, codec.constants.ensure_bits_max);
    const buffer = bits.peek(available);
    const decoded = decoder.code_length_code.decode(buffer, available);
    count_work(decoder, 1);
    const symbol = switch (decoded) {
        .symbol => |symbol| symbol,
        .needs_bits => return .needs_input,
        // A complete code has no unused value; the code length code is built complete.
        .invalid => unreachable,
    };
    const repeat = try code_length_repeat(decoder, symbol.value, buffer >> @intCast(symbol.len), available - symbol.len) orelse return .needs_input;
    // RFC 1951 §3.2.7: all code lengths form one sequence of HLIT + HDIST + 258 values, which a
    // repeat may cross but not pass.
    if (decoder.header_index + repeat.count > total) return error.RepeatPastEnd;
    fill_lengths(&decoder.lengths, decoder.header_index, repeat.count, repeat.len);
    count_work(decoder, repeat.count);
    decoder.header_index += repeat.count;
    bits.consume(symbol.len + repeat.extra_bits);
    return null;
}

const Repeat = struct { len: u8, count: u16, extra_bits: u7 };

/// The code lengths one code length symbol stands for, or null when its extra bits are not all
/// present (RFC 1951 §3.2.7).
fn code_length_repeat(decoder: *const Decoder, symbol: u16, extra: u64, available: u7) Error!?Repeat {
    if (symbol < constants.repeat_previous) return .{ .len = @intCast(symbol), .count = 1, .extra_bits = 0 };
    const kind = symbol - constants.repeat_previous;
    const extra_bits = constants.repeat_extra_bits[kind];
    if (extra_bits > available) return null;
    const count = constants.repeat_count_min[kind] + @as(u16, @intCast(extra & low_bits(extra_bits)));
    if (symbol != constants.repeat_previous) return .{ .len = 0, .count = count, .extra_bits = extra_bits };
    // RFC 1951 §3.2.7: 16 copies the previous code length, and the first has none.
    if (decoder.header_index == 0) return error.RepeatWithoutLength;
    return .{ .len = decoder.lengths[decoder.header_index - 1], .count = count, .extra_bits = extra_bits };
}

fn fill_lengths(lengths: []u8, start: usize, count: usize, len: u8) void {
    assert(start + count <= lengths.len);
    @memset(lengths[start..][0..count], len);
}

/// Builds a dynamic block's literal/length and distance codes from the lengths just read.
fn build_block_codes(decoder: *Decoder) Error!void {
    const literal_lengths = decoder.lengths[0..decoder.literal_length_count];
    // RFC 1951 §3.2.7: every block ends with symbol 256, so its code must have a length.
    if (literal_lengths[constants.end_of_block] == 0) return error.MissingEndOfBlock;
    try decoder.literal_length_code.build(literal_lengths, .complete, &decoder.work);
    const distance_lengths = decoder.lengths[decoder.literal_length_count..][0..decoder.distance_count];
    try decoder.distance_code.build(distance_lengths, .distance, &decoder.work);
    count_work(decoder, decoder.literal_length_table.build(literal_lengths));
    count_work(decoder, decoder.distance_table.build(distance_lengths));
}

/// Runs the fast path while its margins hold, then reads one symbol through the checked path.
fn read_symbols_fast(decoder: *Decoder, bits: *codec.BitReader, writer: *codec.Writer) Error!?codec.Status {
    const codes: fast.Codes = .{
        .literal_length_table = if (decoder.fixed_codes) &lookup.fixed_literal_length else &decoder.literal_length_table,
        .distance_table = if (decoder.fixed_codes) &lookup.fixed_distance else &decoder.distance_table,
        .literal_length_code = block_literal_length_code(decoder),
        .distance_code = block_distance_code(decoder),
    };
    const history: fast.History = .{ .window = &decoder.window, .distance_max = decoder.distance_max, .work = &decoder.work };
    return switch (fast.run(codes, history, bits, writer)) {
        .end_of_block => end_block(decoder),
        .margin, .checked => read_symbol(decoder, bits, writer),
    };
}

fn block_literal_length_code(decoder: *const Decoder) *const huffman.Code(constants.literal_length_alphabet_len) {
    return if (decoder.fixed_codes) &huffman.fixed_literal_length else &decoder.literal_length_code;
}

fn block_distance_code(decoder: *const Decoder) *const huffman.Code(constants.distance_alphabet_len) {
    return if (decoder.fixed_codes) &huffman.fixed_distance else &decoder.distance_code;
}

/// Reads one literal/length symbol, and a length's distance with it.
fn read_symbol(decoder: *Decoder, bits: *codec.BitReader, writer: *codec.Writer) Error!?codec.Status {
    _ = bits.ensure(constants.pair_bits_max);
    const available = @min(bits.bits.count, codec.constants.ensure_bits_max);
    const buffer = bits.peek(available);
    count_work(decoder, 1);
    const symbol = switch (block_literal_length_code(decoder).decode(buffer, available)) {
        .symbol => |symbol| symbol,
        .needs_bits => return .needs_input,
        // RFC 1951 §3.2.7: a value no code of the block's code names.
        .invalid => return error.InvalidCode,
    };
    if (symbol.value < constants.end_of_block) {
        if (writer.room_len() == 0) return .needs_room;
        bits.consume(symbol.len);
        emit(decoder, writer, @intCast(symbol.value));
        return null;
    }
    if (symbol.value == constants.end_of_block) {
        bits.consume(symbol.len);
        return end_block(decoder);
    }
    count_work(decoder, 1);
    const pair = try read_pair(symbol.value, buffer >> @intCast(symbol.len), available - symbol.len, block_distance_code(decoder)) orelse return .needs_input;
    // RFC 1951 §3.2.3: a distance cannot refer past the beginning of the output stream. This stream
    // began at `init`, so the window's octets from before it are out of reach (invariant 10).
    if (pair.distance > decoder.window.reach()) return error.DistanceTooFar;
    // RFC 1950 §2.2: CINFO gives the window the encoder used, and decision 12 refuses a distance
    // past it, on which the RFC states no rule.
    if (pair.distance > decoder.distance_max) return error.DistanceTooFar;
    bits.consume(symbol.len + pair.bits);
    decoder.copy_len = pair.len;
    decoder.copy_distance = pair.distance;
    decoder.phase = .copy;
    return null;
}

const Pair = struct { len: u16, distance: u16, bits: u7 };

/// The length and distance a length symbol starts, from the bits after its code, or null when they
/// are not all present (RFC 1951 §3.2.5).
fn read_pair(symbol: u16, buffer: u64, available: u7, distances: *const huffman.Code(constants.distance_alphabet_len)) Error!?Pair {
    // RFC 1951 §3.2.6: literal/length values 286 - 287 never occur.
    if (symbol >= constants.literal_length_used) return error.InvalidLiteralLength;
    const index = symbol - constants.first_length_symbol;
    var used = constants.length_extra_bits[index];
    if (used > available) return null;
    const length_extra: u16 = @intCast(buffer & low_bits(used));
    const len = constants.length_base[index] + length_extra;
    // RFC 1951 §3.2.5: code 284 stands for lengths 227 - 257; 258 has code 285 alone.
    if (len == constants.match_len_max and symbol != constants.last_length_symbol) return error.InvalidLength;
    const decoded = distances.decode(buffer >> @intCast(used), available - used);
    const distance_symbol = switch (decoded) {
        .symbol => |distance_symbol| distance_symbol,
        .needs_bits => return null,
        // RFC 1951 §3.2.7: a value no distance code names, as in a block with no distance codes.
        .invalid => return error.InvalidCode,
    };
    // RFC 1951 §3.2.6: distance codes 30 - 31 never occur.
    if (distance_symbol.value >= constants.distance_used) return error.InvalidDistance;
    used += distance_symbol.len;
    const distance_extra_bits = constants.distance_extra_bits[distance_symbol.value];
    if (used + distance_extra_bits > available) return null;
    const distance_extra: u16 = @intCast((buffer >> @intCast(used)) & low_bits(distance_extra_bits));
    used += distance_extra_bits;
    return .{ .len = len, .distance = constants.distance_base[distance_symbol.value] + distance_extra, .bits = used };
}

/// Copies one octet of a length/distance pair.
fn copy_match(decoder: *Decoder, writer: *codec.Writer) ?codec.Status {
    if (decoder.copy_len == 0) {
        decoder.phase = .symbols;
        return null;
    }
    if (writer.room_len() == 0) return .needs_room;
    emit(decoder, writer, decoder.window.back(decoder.copy_distance));
    decoder.copy_len -= 1;
    return null;
}

fn low_bits(count: u7) u64 {
    assert(count < @bitSizeOf(u64));
    return (@as(u64, 1) << @intCast(count)) - 1;
}

test {
    _ = @import("decoder_test.zig");
}
