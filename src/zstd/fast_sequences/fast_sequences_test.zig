//! Tests for the sequence execution fast path: seeded frames whose blocks hold enough sequences for
//! the fast loop to take most of them, under FSE_Compressed_Mode tables whose states read bits.
//! The generator picks each sequence's states and bits from what the tables allow, so it knows
//! every value the stream holds. Valid frames must decode alike on the fast and checked paths,
//! whole and split, with the same count of work; frames built to break one rule inside the fast
//! loop's reach must meet the checked path's refusal. The fuzz test corrupts them too.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const fse = @import("../fse.zig");
const sequences = @import("../sequences.zig");
const test_writer = @import("../test_writer.zig");
const decoder_module = @import("../decoder/decoder.zig");
const block = @import("../block.zig");
const work_module = @import("../work.zig");
const aarch64 = @import("fast_sequences_aarch64.zig");
const decoder_test = @import("../decoder/decoder_test.zig");
const FrameWriter = decoder_test.FrameWriter;

/// The most sequences a seeded block holds, and the three codes each has.
const sequences_max = 100;
const codes = 3;

/// The fields a sequence's stream holds at most: three extras and three next states.
const fields_per_sequence = 6;

/// The accuracy log of the three tables: 32 cells, 16 for each of two symbols, so each state reads
/// one bit for the next.
const accuracy_log = 5;
const table_symbols = 2;
const symbol_cells = (1 << accuracy_log) / table_symbols;

/// The shape of a seeded frame: its history, its sequences' codes, its window, and what breaks.
pub const Shape = struct {
    /// Octets before the compressed block, in raw blocks of at most Block_Maximum_Size.
    history_len: usize = 128,
    sequences: usize = sequences_max,
    /// Each table's two symbols. The defaults give literals lengths 1 and 2; Offset_Value 32 and 64
    /// plus 5 and 6 bits, offsets 29 to 124, which the history covers; match lengths 3 and 4.
    literals_length_symbols: *const [table_symbols]u8 = "\x01\x02",
    offset_symbols: *const [table_symbols]u8 = "\x05\x06",
    match_length_symbols: *const [table_symbols]u8 = "\x00\x01",
    /// The cells of the first offset symbol; the second takes the rest.
    offset_first_cells: i16 = symbol_cells,
    /// Window_Descriptor's Exponent: 16 KiB by default.
    window_exponent: u5 = 4,
    /// The literals the section holds, when not the ones the sequences take.
    literals_len: ?usize = null,
    /// The sequences Number_of_Sequences declares, when more than the stream holds.
    declared: ?usize = null,
    /// The first sequence's codes and offset bits, when forced.
    first: ?First = null,
};

/// The first sequence's literals length code, offset code, and the bits of its Offset_Value.
pub const First = struct {
    literals_length_symbol: u8,
    offset_symbol: u8,
    offset_bits: u64,
};

/// A table of `symbols`, the first holding `first_cells` of the 32 cells and the second the rest.
fn distribution_of(symbols: *const [table_symbols]u8, first_cells: i16) fse.Distribution {
    var distribution: fse.Distribution = .{ .probabilities = @splat(0), .symbol_count = symbols[table_symbols - 1] + 1, .accuracy_log = accuracy_log };
    distribution.probabilities[symbols[0]] = first_cells;
    distribution.probabilities[symbols[1]] = (1 << accuracy_log) - first_cells;
    return distribution;
}

/// The values a sequence stream holds in the order they are read, each with its bits, and the
/// literals and octets its sequences take.
const Fields = struct {
    values: [codes + fields_per_sequence * sequences_max]struct { u64, u6 } = undefined,
    len: usize = 0,
    literals_len: usize = 0,
    decoded_len: usize = 0,

    fn put(self: *Fields, value: u64, bits: u6) void {
        self.values[self.len] = .{ value, bits };
        self.len += 1;
    }
};

const Tables = [codes]fse.Table(accuracy_log);

fn cell_of(tables: *const Tables, states: [codes]u16, code: sequences.Code) fse.Entry {
    return tables[sequences.slot(code)].entries()[states[sequences.slot(code)]];
}

/// A state of `table` whose cell decodes `symbol`.
fn state_of(table: *const fse.Table(accuracy_log), symbol: u8) u16 {
    for (table.entries(), 0..) |cell, state| {
        if (cell.symbol == symbol) return @intCast(state);
    }
    unreachable;
}

/// The initial states: forced for the first sequence's codes, or drawn.
fn initial_states(generator: *codec.split.Generator, tables: *const Tables, first: ?First) [codes]u16 {
    var states: [codes]u16 = undefined;
    for (&states, tables) |*state, *table| state.* = @intCast(generator.below(table.entries().len));
    if (first) |forced| {
        states[sequences.slot(.literals_length)] = state_of(&tables[sequences.slot(.literals_length)], forced.literals_length_symbol);
        states[sequences.slot(.offset)] = state_of(&tables[sequences.slot(.offset)], forced.offset_symbol);
    }
    return states;
}

/// A sequence's extras: the offset's, forced for the first sequence, then the match length's and
/// the literals length's, each drawn, in RFC 8878 §3.1.1.3.2.1.2's order.
fn put_extras(generator: *codec.split.Generator, fields: *Fields, cells: [codes]fse.Entry, forced_bits: ?u64) void {
    const offset_code = cells[sequences.slot(.offset)].symbol;
    fields.put(forced_bits orelse generator.below(@as(u64, 1) << @intCast(offset_code)), @intCast(offset_code));
    const match_length = cells[sequences.slot(.match_length)].symbol;
    const match_bits = generator.below(@as(u64, 1) << constants.match_length_extra_bits[match_length]);
    fields.put(match_bits, constants.match_length_extra_bits[match_length]);
    const literals_length = cells[sequences.slot(.literals_length)].symbol;
    const literals_bits = generator.below(@as(u64, 1) << constants.literals_length_extra_bits[literals_length]);
    fields.put(literals_bits, constants.literals_length_extra_bits[literals_length]);
    const literals_len = constants.literals_length_baselines[literals_length] + literals_bits;
    fields.literals_len += literals_len;
    fields.decoded_len += literals_len + constants.match_length_baselines[match_length] + match_bits;
}

fn seeded_fields(generator: *codec.split.Generator, tables: *const Tables, shape: Shape) Fields {
    var fields: Fields = .{};
    var states = initial_states(generator, tables, shape.first);
    // Initial states: literals length, offset, match length.
    for (states) |state| fields.put(state, accuracy_log);
    for (0..shape.sequences) |index| {
        const cells = [codes]fse.Entry{ cell_of(tables, states, .literals_length), cell_of(tables, states, .offset), cell_of(tables, states, .match_length) };
        const forced_bits = if (index == 0 and shape.first != null) shape.first.?.offset_bits else null;
        put_extras(generator, &fields, cells, forced_bits);
        if (index == shape.sequences - 1) break;
        // Next states: literals length, match length, offset.
        for ([_]sequences.Code{ .literals_length, .match_length, .offset }) |code| {
            const cell = cell_of(tables, states, code);
            const bits = generator.below(@as(u64, 1) << @intCast(cell.bits));
            fields.put(bits, @intCast(cell.bits));
            states[sequences.slot(code)] = @intCast(cell.baseline + bits);
        }
    }
    return fields;
}

/// Raw literals of Size_Format 01, whose size takes 12 bits over two octets, and of Size_Format
/// 11, 20 bits over three (RFC 8878 §3.1.1.3.1.1): the low 4 bits after the kind and format first.
const raw_two_octet_format: u8 = 0b0100;
const raw_three_octet_format: u8 = 0b1100;
const size_low_bits = 4;
const size_low_mask = (1 << size_low_bits) - 1;
const two_octet_size_bits = 12;
const two_octet_size_max = 1 << two_octet_size_bits;

fn raw_literals_header(content: *FrameWriter, len: usize) void {
    const low: u8 = @intCast(len & size_low_mask);
    if (len < two_octet_size_max) return content.put(&.{ low << size_low_bits | raw_two_octet_format, @intCast(len >> size_low_bits) });
    content.put(&.{ low << size_low_bits | raw_three_octet_format, @truncate(len >> size_low_bits), @intCast(len >> (size_low_bits + @bitSizeOf(u8))) });
}

/// Symbol_Compression_Modes with FSE_Compressed_Mode for all three codes.
const compressed_modes: u8 = 0xa8;

/// A seeded frame of `shape`: raw blocks of history, then a compressed block of raw literals and
/// the sequences. Returns the octets it decodes to, when every rule holds.
pub fn seeded_frame(frame: *FrameWriter, seed: u64, shape: Shape) !usize {
    var generator = codec.split.Generator.init(seed);
    const distributions = [_]fse.Distribution{ distribution_of(shape.literals_length_symbols, symbol_cells), distribution_of(shape.offset_symbols, shape.offset_first_cells), distribution_of(shape.match_length_symbols, symbol_cells) };
    var tables: Tables = undefined;
    for (&tables, distributions) |*table, distribution| try fse.build(accuracy_log, table, &distribution);
    const fields = seeded_fields(&generator, &tables, shape);
    var bits: test_writer.BitWriter = .{};
    var index = fields.len;
    while (index > 0) {
        index -= 1;
        bits.put(fields.values[index][0], fields.values[index][1]);
    }
    var content: FrameWriter = .{};
    const literals_len = shape.literals_len orelse fields.literals_len;
    raw_literals_header(&content, literals_len);
    for (0..literals_len) |_| content.put(&.{@truncate(generator.next())});
    content.put(&.{ @intCast(shape.declared orelse shape.sequences), compressed_modes });
    for (distributions) |distribution| {
        var description: test_writer.DescriptionWriter = .{};
        description.write(&distribution);
        content.put(description.octets[0 .. std.math.divCeil(usize, description.bits_written, @bitSizeOf(u8)) catch unreachable]);
    }
    content.put(bits.finish());
    frame.put_int(u32, constants.frame_magic);
    frame.put(&.{ 0, @as(u8, shape.window_exponent) << constants.window_exponent_shift });
    const block_len_max = @min(@as(usize, 1) << (constants.window_log_min + shape.window_exponent), constants.block_len_max);
    var history_left = shape.history_len;
    while (history_left > 0) {
        const len = @min(history_left, block_len_max);
        frame.block_header(false, decoder_test.raw_type, @intCast(len));
        for (0..len) |_| frame.put(&.{@truncate(generator.next())});
        history_left -= len;
    }
    frame.block_header(true, decoder_test.compressed_type, @intCast(content.len));
    frame.put(content.written());
    return shape.history_len + fields.decoded_len + (literals_len - @min(literals_len, fields.literals_len));
}

const Decoder = decoder_test.Decoder;
const CheckedDecoder = decoder_module.Decoder(.{ .window_len_max = constants.block_len_max, .paths = .{ .fast_paths = false } });
/// The fast path with Z4's chunk copies off, which copies exactly.
const ExactDecoder = decoder_module.Decoder(.{ .window_len_max = constants.block_len_max, .paths = .{ .claims = .{ .chunk_copies = false } } });

/// The octets the largest seeded frame decodes to at most.
const output_capacity = 65536;

fn step(decoder: *Decoder, input: []const u8, output: []u8) decoder_module.Error!codec.Progress {
    return decoder.decode(input, output);
}

/// Decodes a valid seeded frame on the fast path whole and split and on the checked path, and
/// requires the octets it decodes to, the same on each, and the same count of work. The whole
/// decode takes no CPU feature, and the split one the CPU's, so where the CPU runs the assembly,
/// the Zig loop and the assembly both meet the checked path (decision 23).
fn expect_alike(shape: Shape, seed: u64) !void {
    var frame: FrameWriter = .{};
    const decoded_len = try seeded_frame(&frame, seed, shape);
    var output: [output_capacity]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(.{});
    const fast = try decoder.decode(frame.written(), &output);
    try testing.expectEqual(codec.Progress{ .consumed = frame.len, .written = decoded_len, .status = .done }, fast);
    var checked_output: [output_capacity]u8 = undefined;
    var checked: CheckedDecoder = undefined;
    checked.init(.{});
    try testing.expectEqual(fast, try checked.decode(frame.written(), &checked_output));
    try testing.expectEqualSlices(u8, checked_output[0..decoded_len], output[0..decoded_len]);
    try testing.expectEqual(checked.work, decoder.work);
    var split_output: [output_capacity]u8 = undefined;
    var states: [codec.split.state_slots]Decoder = undefined;
    states[0].init(codec.Features.detect());
    const outcome = try codec.split.drive(Decoder, &states, step, frame.written(), &split_output, seed);
    try testing.expectEqual(.done, outcome.status);
    try testing.expectEqualSlices(u8, output[0..decoded_len], split_output[0..outcome.written]);
}

/// Decodes a valid seeded frame with Z4's chunk copies off and on the checked path, and requires the
/// octets it decodes to on both.
fn expect_exact_alike(shape: Shape, seed: u64) !void {
    var frame: FrameWriter = .{};
    const decoded_len = try seeded_frame(&frame, seed, shape);
    var output: [output_capacity]u8 = undefined;
    var exact: ExactDecoder = undefined;
    exact.init(.{});
    try testing.expectEqual(codec.Progress{ .consumed = frame.len, .written = decoded_len, .status = .done }, try exact.decode(frame.written(), &output));
    var checked_output: [output_capacity]u8 = undefined;
    var checked: CheckedDecoder = undefined;
    checked.init(.{});
    _ = try checked.decode(frame.written(), &checked_output);
    try testing.expectEqualSlices(u8, checked_output[0..decoded_len], output[0..decoded_len]);
}

/// Decodes a seeded frame built to break a rule on both paths, and requires `refusal` of each after
/// the same count of work, so the fast loop took no sequence past the one refused: without CPU
/// features and with the CPU's, which run the assembly where the CPU does.
fn expect_refused(shape: Shape, seed: u64, refusal: anyerror) !void {
    var frame: FrameWriter = .{};
    _ = try seeded_frame(&frame, seed, shape);
    var output: [output_capacity]u8 = undefined;
    var checked: CheckedDecoder = undefined;
    checked.init(.{});
    try testing.expectError(refusal, checked.decode(frame.written(), &output));
    for ([_]codec.Features{ .{}, codec.Features.detect() }) |features| {
        var decoder: Decoder = undefined;
        decoder.init(features);
        try testing.expectError(refusal, decoder.decode(frame.written(), &output));
        try testing.expectEqual(checked.work, decoder.work);
    }
}

/// Decodes a seeded frame that may break a rule on both paths, and requires the same verdict, the
/// same octets when it is valid, and the same count of work: without CPU features and with the
/// CPU's, which run the assembly where the CPU does.
fn expect_same(shape: Shape, seed: u64) !void {
    var frame: FrameWriter = .{};
    _ = try seeded_frame(&frame, seed, shape);
    var checked_output: [output_capacity]u8 = undefined;
    var checked: CheckedDecoder = undefined;
    checked.init(.{});
    const slow = checked.decode(frame.written(), &checked_output);
    for ([_]codec.Features{ .{}, codec.Features.detect() }) |features| {
        var output: [output_capacity]u8 = undefined;
        var decoder: Decoder = undefined;
        decoder.init(features);
        const fast = decoder.decode(frame.written(), &output);
        try testing.expectEqual(slow, fast);
        try testing.expectEqual(checked.work, decoder.work);
        const progress = fast catch continue;
        try testing.expectEqualSlices(u8, checked_output[0..progress.written], output[0..progress.written]);
    }
}

/// Offsets 5 to 28 (Offset_Value 8 and 16 plus 3 and 4 bits), under a chunk's 16 octets and past it.
const short_offsets: Shape = .{ .offset_symbols = "\x03\x04" };

/// Literal runs of 128 to 511 and matches of 131 to 514, past `chunk_len_max`, in a window of 64
/// KiB (Exponent 6) that holds the block of `long_run_sequences`.
const long_run_sequences = 40;
const window_exponent_64k = 6;
const long_runs: Shape = .{ .sequences = long_run_sequences, .literals_length_symbols = "\x1a\x1b", .match_length_symbols = "\x2b\x2c", .window_exponent = window_exponent_64k };

/// Matches of 131 to 514 at offsets 5 to 28, so a chunk copies what an earlier chunk just wrote.
const long_short_matches: Shape = .{ .offset_symbols = "\x03\x04", .match_length_symbols = "\x2b\x2c", .window_exponent = window_exponent_64k };

/// Matches of 131 to 514 at offsets 1 to 4 (Offset_Value 4 plus 2 bits) and 5 to 12: a quarter of
/// the first code's matches repeat the octet before them, which Z4's exact copies fill.
const offset_one_matches: Shape = .{ .offset_symbols = "\x02\x03", .match_length_symbols = "\x2b\x2c", .window_exponent = window_exponent_64k };

/// Offset code 1, Offset_Value 2 or 3, a Repeated_Offset, beside new offsets of code 5; with
/// literals lengths 0 and 1, so the shift a literals length of 0 gives (RFC 8878 §3.1.1.5) comes
/// too, and Repeated_Offset1 - 1 may be 0. Half the offset cells name a repeat, so the assembly
/// takes the offsets by selects.
const repeated_offsets: Shape = .{ .literals_length_symbols = "\x00\x01", .offset_symbols = "\x01\x05" };
/// Offset code 0, Offset_Value 1: the first repeat, or the second after no literals.
const first_repeats: Shape = .{ .literals_length_symbols = "\x00\x01", .offset_symbols = "\x00\x05" };
/// Both again with 2 of 32 offset cells a repeat's, 16 of every 256, too few for selects: the
/// assembly branches.
const rare_repeat_cells = 2;
const rare_repeated_offsets: Shape = .{ .literals_length_symbols = "\x00\x01", .offset_symbols = "\x01\x05", .offset_first_cells = rare_repeat_cells };
const rare_first_repeats: Shape = .{ .literals_length_symbols = "\x00\x01", .offset_symbols = "\x00\x05", .offset_first_cells = rare_repeat_cells };

comptime {
    const scale = constants.offset_accuracy_log_max - accuracy_log;
    std.debug.assert(rare_repeat_cells << scale < constants.offset_selects_cells_min);
    std.debug.assert(symbol_cells << scale >= constants.offset_selects_cells_min);
}

test "seeded blocks decode alike on the fast and checked paths, whole and split" {
    for (0..32) |seed| {
        try expect_alike(.{}, seed);
        try expect_alike(short_offsets, seed);
        try expect_alike(long_runs, seed);
        try expect_alike(long_short_matches, seed);
        try expect_same(repeated_offsets, seed);
        try expect_alike(first_repeats, seed);
        try expect_same(rare_repeated_offsets, seed);
        try expect_alike(rare_first_repeats, seed);
    }
}

test "matches at offsets 1 to 12 decode alike with chunk copies on and off and on the checked path" {
    for (0..32) |seed| {
        try expect_alike(offset_one_matches, seed);
        try expect_exact_alike(offset_one_matches, seed);
    }
}

test "literals that run out, and offsets past Window_Size, are refused inside the fast loop's reach" {
    // Ten literals for sequences that take one or two each.
    try expect_refused(.{ .literals_len = 10 }, 1, error.LiteralsOverrun);
    // A window of 1 KiB after 2 KiB of history: the first offset, Offset_Value 2048 (offset 2045),
    // is within reach but past Window_Size.
    const far: Shape = .{ .history_len = 2048, .offset_symbols = "\x0a\x0b", .window_exponent = 0, .first = .{ .literals_length_symbol = 1, .offset_symbol = 11, .offset_bits = 0 } };
    try expect_refused(far, 2, error.OffsetTooFar);
    // Five sequences more than the stream holds: the stream ends before them (RFC 8878
    // §3.1.1.3.2.1.2), and no path takes a sequence past its end.
    try expect_refused(.{ .declared = sequences_max + 5 }, 5, error.SequencesStreamInvalid);
    // Matches of 131 to 514 in a block of 1 KiB at most: past Block_Maximum_Size in a few sequences.
    try expect_refused(.{ .match_length_symbols = "\x2b\x2c", .window_exponent = 0 }, 4, error.BlockTooLong);
}

test "a first offset reaching the frame's first octet is taken, and one past it refused" {
    // Offsets 1 to 12 (Offset_Value 4 and 8 plus 2 and 3 bits). The first sequence takes one
    // literal and Offset_Value 15, offset 12: 11 octets of history and the literal reach it.
    const first: First = .{ .literals_length_symbol = 1, .offset_symbol = 3, .offset_bits = 7 };
    try expect_alike(.{ .history_len = 11, .offset_symbols = "\x02\x03", .first = first }, 3);
    try expect_refused(.{ .history_len = 10, .offset_symbols = "\x02\x03", .first = first }, 3, error.OffsetTooFar);
}

/// Symbol_Compression_Modes with RLE_Mode for all three codes, whose tables read no state bits.
const repeated_symbol_modes: u8 = 0x54;

test "a block whose literal source is shorter than a chunk decodes on the checked path alike" {
    // 64 octets of history, then a block of no literals and 12 sequences under RLE_Mode tables:
    // literals length code 0, offset code 5, match length code 0. Each sequence reads only its 5
    // offset bits, Offset_Value 32 to 63, offsets 29 to 60; the 60 bits let the fast loop start,
    // and its literal source, the section after the literals header, takes 13 octets.
    const sequence_count = 12;
    const offset_code = 5;
    var generator = codec.split.Generator.init(9);
    var bits: test_writer.BitWriter = .{};
    for (0..sequence_count) |_| bits.put(generator.below(1 << offset_code), offset_code);
    var content: FrameWriter = .{};
    raw_literals_header(&content, 0);
    content.put(&.{ sequence_count, repeated_symbol_modes, 0, offset_code, 0 });
    content.put(bits.finish());
    try testing.expect(content.len - 2 < constants.copy_chunk_len);
    var frame: FrameWriter = .{};
    frame.put_int(u32, constants.frame_magic);
    frame.put(&.{ 0, @as(u8, 4) << constants.window_exponent_shift });
    const history_len = 64;
    frame.block_header(false, decoder_test.raw_type, history_len);
    for (0..history_len) |_| frame.put(&.{@truncate(generator.next())});
    frame.block_header(true, decoder_test.compressed_type, @intCast(content.len));
    frame.put(content.written());
    var output: [output_capacity]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(.{});
    const fast = try decoder.decode(frame.written(), &output);
    const match_len_min = constants.match_length_baselines[0];
    try testing.expectEqual(codec.Progress{ .consumed = frame.len, .written = history_len + sequence_count * match_len_min, .status = .done }, fast);
    var checked_output: [output_capacity]u8 = undefined;
    var checked: CheckedDecoder = undefined;
    checked.init(.{});
    try testing.expectEqual(fast, try checked.decode(frame.written(), &checked_output));
    try testing.expectEqualSlices(u8, checked_output[0..fast.written], output[0..fast.written]);
}

test "an output below Window_Size takes no step of the aarch64 loop, whose check of the source would wrap" {
    if (comptime !aarch64.takes(true, .{})) return error.SkipZigTest;
    // RLE_Mode for all three codes: literals length code 1, one literal; offset code 20, an
    // Offset_Value of 2^20 and 20 bits more; match length code 0, 3 octets. No state reads a bit.
    const offset_code = 20;
    var tables: sequences.Tables = undefined;
    tables.init();
    const sequence_count = 2;
    _ = try sequences.read_header(&.{ sequence_count, 1 << 6 | 1 << 4 | 1 << 2, 1, offset_code, 0 }, &tables);
    // Both offsets' bits, read first, then bits the loop never reads, so a load holds 57.
    var writer: test_writer.BitWriter = .{};
    writer.put(0, constants.fast_read_position_min);
    for (0..sequence_count) |_| writer.put(0, offset_code);
    const stream = writer.finish();
    var run: block.Run = undefined;
    run.section = .{ .source = .buffer, .len = constants.block_len_max, .offset = 0, .octet = 0, .section_len = 0 };
    run.literals_used = 0;
    run.promised_len = 0;
    run.stream = .{ .position = codec.BackwardBitReader.init(stream).?.position, .overflowed = false, .states = @splat(0), .left = sequence_count };
    var repeats = constants.repeated_offsets_initial;
    var work = work_module.zero;
    var empty: [0]u8 = .{};
    const context: block.Context = .{ .block = &empty, .literals_buffer = &empty, .huffman = undefined, .tables = &tables, .repeats = &repeats, .block_len_max = constants.block_len_max, .window_len = constants.http_window_len, .work = &work, .assembly = false };
    // An output at an address below Window_Size and below the offset, which the loop must not
    // write: a check of the source's address would wrap and let the match through.
    const low_address = 0x10000;
    var synced: usize = 0;
    var frame_len: u64 = 0;
    var window: void = {};
    var sink: block.Sink(void) = .{ .output = @as([*]u8, @ptrFromInt(low_address))[0..constants.http_window_len], .written = 0, .window = &window, .synced = &synced, .frame_len = &frame_len, .window_each = false };
    const literals: [aarch64.copy_overrun_len + 1]u8 = @splat(0);
    aarch64.run_loop(void, &run, context, stream, &tables, &sink, &literals);
    try testing.expectEqual(sequence_count, run.stream.left);
    try testing.expectEqual(0, sink.written);
}
