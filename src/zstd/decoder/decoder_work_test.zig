//! Invariant 17's check for the Zstandard decoder, on decision 15's worst cases:
//!
//! - tiny blocks that each build a Huffman tree of 11 bits and all three sequence tables at their
//!   largest accuracy logs, for one literal and one sequence;
//! - blocks as full of sequences as Block_Maximum_Size allows, none of which reads a bit;
//! - literals of one bit each;
//! - the largest block: every table, and Block_Maximum_Size of literals and a match, its last octet
//!   arriving in a call with no room.
//!
//! The decoder's count of table cells filled and symbols decoded is what each frame asks for, and
//! stays within `constants.work_per_octet_max` per octet consumed, `constants.work_per_written_max`
//! per octet written and `constants.work_per_call_max` per call.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const fse = @import("../fse.zig");
const huffman = @import("../huffman.zig");
const test_writer = @import("../test_writer.zig");
const decoder_test = @import("decoder_test.zig");
const Decoder = decoder_test.Decoder;
const FrameWriter = decoder_test.FrameWriter;

/// The tiny blocks of the first worst case, the blocks of the second and the literals of the third.
const tiny_blocks = 48;
const free_blocks = 8;
const one_bit_literals = 1000;

/// The octets the first and third worst cases decode to at most.
const output_len_max = 1024;

/// Literals_Block_Type of a Huffman-coded section with its tree, and the bits before
/// Regenerated_Size in a header of Size_Format 0 (RFC 8878 §3.1.1.3.1.1).
const compressed_literals = 2;
const literals_kind_and_format_bits = 4;

/// A literals section header of Size_Format 0: Literals_Block_Type, then Regenerated_Size and
/// Compressed_Size in 10 bits each (RFC 8878 §3.1.1.3.1.1).
fn literals_header(content: *FrameWriter, len: u24, compressed_len: u24) void {
    const size_bits = constants.literals_compressed_size_bits[0];
    content.put_int(u24, compressed_literals | len << literals_kind_and_format_bits | compressed_len << (literals_kind_and_format_bits + size_bits));
}

/// Huffman_Tree_Description with weights written directly (RFC 8878 §4.2.1.1): Number_of_Symbols
/// 11 after huffman_direct_symbols_offset, then literals 0 to 10 weighing 11 down to 1; literal
/// 11's weight of 1 is deduced, so Max_Number_of_Bits is 11 and literal 0 takes one bit.
const deep_tree = "\x8a\xba\x98\x76\x54\x32\x10";

/// The deep tree's weights, the deduced one included, and its count: its cells and its weights.
const deep_tree_weights = 12;
const deep_tree_work = (1 << constants.huffman_bits_max) + deep_tree_weights;

/// Each tiny block's sequence tables hold two symbols, and the block writes a literal and a match.
const table_symbols = 2;
const tiny_block_output_len = 1 + constants.match_length_baselines[0];

/// A distribution of two symbols over 2^`accuracy_log` cells, the first given `first` of them.
fn two_symbols(accuracy_log: u4, first: i16) fse.Distribution {
    var distribution: fse.Distribution = .{ .probabilities = undefined, .symbol_count = table_symbols, .accuracy_log = accuracy_log };
    distribution.probabilities[0] = first;
    distribution.probabilities[1] = (@as(i16, 1) << accuracy_log) - first;
    return distribution;
}

/// The largest accuracy logs of the sequence tables, in the order a Sequences_Section describes
/// them: literals length, offset, match length.
const literals_length_log = constants.literals_length_accuracy_log_max;
const offset_log = constants.offset_accuracy_log_max;
const match_length_log = constants.match_length_accuracy_log_max;

/// The three sequence tables' descriptions at their largest accuracy logs. Offset code 0 and match
/// length code 0 take all cells but one; literals length code 0 takes `literals_length_first`.
fn put_tables(content: *FrameWriter, literals_length_first: i16) void {
    const distributions = [_]fse.Distribution{
        two_symbols(literals_length_log, literals_length_first),
        two_symbols(offset_log, (1 << offset_log) - 1),
        two_symbols(match_length_log, (1 << match_length_log) - 1),
    };
    for (distributions) |distribution| {
        var description: test_writer.DescriptionWriter = .{};
        description.write(&distribution);
        content.put(description.octets[0 .. std.math.divCeil(usize, description.bits_written, @bitSizeOf(u8)) catch unreachable]);
    }
}

/// One sequence's stream: initial states `literals_length_state`, 0 and 0, read literals length,
/// offset, match length, so written in reverse, and no other bits.
fn put_states(content: *FrameWriter, literals_length_state: u64) void {
    var bits: test_writer.BitWriter = .{};
    bits.put(0, match_length_log);
    bits.put(0, offset_log);
    bits.put(literals_length_state, literals_length_log);
    content.put(bits.finish());
}

/// The count of the three sequence tables.
const tables_work = constants.table_work_max(literals_length_log, table_symbols) +
    constants.table_work_max(offset_log, table_symbols) + constants.table_work_max(match_length_log, table_symbols);

/// A tiny block: the deep tree and literal 0, then one sequence under three FSE_Compressed_Mode
/// tables at their largest accuracy logs. Literals length code 0 takes 1 cell and code 1 the rest;
/// offset code 0 and match length code 0 take all cells but one. The initial states 1, 0 and 0
/// give literals length 1, Offset_Value 1 (offset 1) and match length 3.
fn tiny_block(frame: *FrameWriter, last: bool, tree: *const huffman.Table) void {
    var content: FrameWriter = .{};
    var stream_writer: test_writer.StreamWriter = .{};
    const stream = stream_writer.write(tree, "\x00");
    literals_header(&content, 1, @intCast(deep_tree.len + stream.len));
    content.put(deep_tree);
    content.put(stream);
    // Number_of_Sequences 1; FSE_Compressed_Mode for all three codes.
    content.put("\x01\xa8");
    put_tables(&content, 1);
    put_states(&content, 1);
    frame.block_header(last, decoder_test.compressed_type, @intCast(content.len));
    frame.put(content.written());
}

/// The count of a tiny block: the tree, one literal, the three tables and one sequence.
const tiny_block_work = deep_tree_work + 1 + tables_work + 1;

/// The first worst case, and its count.
fn tiny_blocks_frame(frame: *FrameWriter) !u64 {
    var tree: huffman.Table = undefined;
    _ = try huffman.read_tree(deep_tree, &tree);
    frame.long_frame_header(tiny_block_output_len * tiny_blocks);
    for (0..tiny_blocks) |index| tiny_block(frame, index == tiny_blocks - 1, &tree);
    return tiny_blocks * tiny_block_work;
}

/// A window of Block_Maximum_Size, 2^17 (Exponent 7), which the second and fourth worst cases fill
/// with each block.
const window_exponent_largest = 7;
const window_largest: u8 = window_exponent_largest << constants.window_exponent_shift;

/// Magic_Number, then a header with the largest window and a 4-octet Frame_Content_Size.
fn largest_window_header(frame: *FrameWriter, content_len: u32) void {
    frame.put_int(u32, constants.frame_magic);
    frame.put(&.{ decoder_test.four_octet_content_size, window_largest });
    frame.put_int(u32, content_len);
}

/// The history the second and fourth worst cases' sequences copy from, in a raw block of its own.
const history = "abcd";

/// The sequences of each block of the second worst case, each copying a match of 3, and the codes
/// each sequence has.
const free_sequences = constants.block_len_max / constants.match_length_baselines[0];
const sequence_codes = 3;

/// The second worst case: blocks of no literals and `free_sequences` sequences under RLE_Mode tables
/// of literals length code 0, offset code 0 and match length code 0, none of which reads a bit.
/// Each is Offset_Value 1 with no literals, so Repeated_Offset2, 4 then 1 in turn. Returns its count:
/// per block, three one-cell tables and a decode per sequence.
fn free_blocks_frame(frame: *FrameWriter) u64 {
    var content: FrameWriter = .{};
    // No literals; Number_of_Sequences in three octets, 255 and then the count less 0x7F00 (RFC 8878
    // §3.1.1.3.2.1).
    content.put("\x00\xff");
    content.put_int(u16, free_sequences - constants.sequences_long_offset);
    // RLE_Mode for all three codes, each symbol 0, and a stream of its final bit alone.
    content.put("\x54\x00\x00\x00\x01");
    largest_window_header(frame, history.len + free_blocks * constants.match_length_baselines[0] * free_sequences);
    frame.block_header(false, decoder_test.raw_type, history.len);
    frame.put(history);
    for (0..free_blocks) |index| {
        frame.block_header(index == free_blocks - 1, decoder_test.compressed_type, @intCast(content.len));
        frame.put(content.written());
    }
    return free_blocks * (sequence_codes + free_sequences);
}

/// The third worst case's tree: Number_of_Symbols 1 after huffman_direct_symbols_offset, literal 0
/// weighing 1, and literal 1's weight of 1 deduced. Its count: two cells and two weights.
const one_bit_tree = "\x80\x10";
const one_bit_tree_work = 4;

/// The third worst case: a stream of `one_bit_literals` literals of one bit each, and no sequences.
/// Returns its count: the tree and a decode per literal.
fn one_bit_frame(frame: *FrameWriter) !u64 {
    var table: huffman.Table = undefined;
    _ = try huffman.read_tree(one_bit_tree, &table);
    var literals: [one_bit_literals]u8 = undefined;
    for (&literals, 0..) |*literal, index| literal.* = @intCast(index & 1);
    var stream_writer: test_writer.StreamWriter = .{};
    const stream = stream_writer.write(&table, &literals);
    var content: FrameWriter = .{};
    literals_header(&content, one_bit_literals, @intCast(one_bit_tree.len + stream.len));
    content.put(one_bit_tree);
    content.put(stream);
    content.put("\x00");
    frame.long_frame_header(one_bit_literals);
    frame.block_header(true, decoder_test.compressed_type, @intCast(content.len));
    frame.put(content.written());
    return one_bit_tree_work + one_bit_literals;
}

/// The fourth worst case's literals: Block_Maximum_Size but its match, all literal 0, which the deep
/// tree codes in one bit, in four streams of Size_Format 3, whose sizes take 18 bits each (RFC 8878
/// §3.1.1.3.1.1).
const largest_literals = constants.block_len_max - constants.match_length_baselines[0];
const largest_format = 3;

/// The octets the largest block's streams take at most: a bit per literal, and an octet for each
/// stream's final bit and one for its partial octet.
const stream_end_len_max = 2;
const largest_streams_capacity = largest_literals / @bitSizeOf(u8) + stream_end_len_max * constants.literal_streams;

/// A stream of `count` literals 0, each the one-bit code 1, then the final 1 bit, written forward.
fn ones_stream(buffer: []u8, count: usize) []const u8 {
    const bits = count + 1;
    const full = bits / @bitSizeOf(u8);
    const rest: u3 = @intCast(bits % @bitSizeOf(u8));
    @memset(buffer[0..full], std.math.maxInt(u8));
    if (rest == 0) return buffer[0..full];
    buffer[full] = (@as(u8, 1) << rest) - 1;
    return buffer[0 .. full + 1];
}

/// The fourth worst case: after `history`, the largest block, which builds every table and decodes
/// `largest_literals` literals, then one sequence under tables at their largest accuracy logs whose
/// initial states 0, 0 and 0 give literals length 0, Offset_Value 1 (Repeated_Offset2, 4) and match
/// length 3. Each stream holds (Regenerated_Size + 3) / 4 literals but the last, after a Jump_Table
/// of the first three streams' sizes (RFC 8878 §3.1.1.3.1.6). Returns its count.
fn largest_frame(frame: *FrameWriter) u64 {
    var streams_buffer: [largest_streams_capacity]u8 = undefined;
    const quarter = (largest_literals + constants.literal_streams - 1) / constants.literal_streams;
    var streams: [constants.literal_streams][]const u8 = undefined;
    var streams_len: usize = 0;
    for (&streams, 0..) |*stream, index| {
        stream.* = ones_stream(streams_buffer[streams_len..], @min(quarter, largest_literals - index * quarter));
        streams_len += stream.len;
    }
    var content: FrameWriter = .{};
    const size_bits = constants.literals_compressed_size_bits[largest_format];
    const compressed_len: u40 = @intCast(deep_tree.len + constants.jump_table_len + streams_len);
    content.put_int(u40, compressed_literals | largest_format << constants.literals_size_format_shift |
        @as(u40, largest_literals) << literals_kind_and_format_bits | compressed_len << (literals_kind_and_format_bits + size_bits));
    content.put(deep_tree);
    for (streams[0 .. constants.literal_streams - 1]) |stream| content.put_int(u16, @intCast(stream.len));
    content.put(streams_buffer[0..streams_len]);
    content.put("\x01\xa8");
    put_tables(&content, (1 << literals_length_log) - 1);
    put_states(&content, 0);
    largest_window_header(frame, history.len + constants.block_len_max);
    frame.block_header(false, decoder_test.raw_type, history.len);
    frame.put(history);
    frame.block_header(true, decoder_test.compressed_type, @intCast(content.len));
    frame.put(content.written());
    return deep_tree_work + largest_literals + tables_work + 1;
}

fn expect_bounded(work: u64, consumed: usize, written: usize) !void {
    try testing.expect(work <= constants.work_per_octet_max * consumed + constants.work_per_written_max * written + constants.work_per_call_max);
}

/// Decodes `frame` in one call, and requires the count it asks for, within the bound.
fn expect_whole(frame: []const u8, work: u64) !void {
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var output: [output_len_max]u8 = undefined;
    const progress = try decoder.decode(frame, &output);
    try testing.expectEqual(.done, progress.status);
    try testing.expectEqual(frame.len, progress.consumed);
    try testing.expectEqual(work, decoder.work);
    try expect_bounded(decoder.work, progress.consumed, progress.written);
}

test "tiny blocks that each build every table cost the count they ask for, within the bound" {
    var frame: FrameWriter = .{};
    const work = try tiny_blocks_frame(&frame);
    try expect_whole(frame.written(), work);
}

test "the tiny blocks an octet at a time cost the same, and at most the bound per call" {
    var frame: FrameWriter = .{};
    const work = try tiny_blocks_frame(&frame);
    const input = frame.written();
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var output: [output_len_max]u8 = undefined;
    var consumed: usize = 0;
    var written: usize = 0;
    for (0..input.len + output.len) |_| {
        const before = decoder.work;
        const progress = try decoder.decode(input[consumed..@min(consumed + 1, input.len)], output[written..]);
        try expect_bounded(decoder.work - before, progress.consumed, progress.written);
        consumed += progress.consumed;
        written += progress.written;
        if (progress.status == .done) break;
    } else return error.TestUnexpectedResult;
    try testing.expectEqual(input.len, consumed);
    try testing.expectEqual(tiny_block_output_len * tiny_blocks, written);
    // A block's tables and literals wait until its last octet arrives, so no call repeats them.
    try testing.expectEqual(work, decoder.work);
}

test "blocks of sequences that read no bits cost one each, within the bound per octet written" {
    var frame: FrameWriter = .{};
    const work = free_blocks_frame(&frame);
    const input = frame.written();
    var decoder: Decoder = undefined;
    decoder.init(.{});
    // One block's room, used again by each call.
    var output: [constants.block_len_max]u8 = undefined;
    var consumed: usize = 0;
    var written: usize = 0;
    for (0..free_blocks + 2) |_| {
        const before = decoder.work;
        const progress = try decoder.decode(input[consumed..], &output);
        try expect_bounded(decoder.work - before, progress.consumed, progress.written);
        consumed += progress.consumed;
        written += progress.written;
        if (progress.status == .done) break;
    } else return error.TestUnexpectedResult;
    try testing.expectEqual(input.len, consumed);
    try testing.expectEqual(work, decoder.work);
    // Over the whole frame the sequences cost what its octets written allow, and one call's worth.
    try expect_bounded(decoder.work, consumed, written);
}

test "literals of one bit cost one each, within the bound per octet consumed" {
    var frame: FrameWriter = .{};
    const work = try one_bit_frame(&frame);
    try expect_whole(frame.written(), work);
}

test "the largest block, its last octet with no room, costs at most the bound per call" {
    var frame: FrameWriter = .{};
    const work = largest_frame(&frame);
    const input = frame.written();
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var output: [history.len + constants.block_len_max]u8 = undefined;
    const first = try decoder.decode(input[0 .. input.len - 1], &output);
    try testing.expectEqual(codec.Progress{ .consumed = input.len - 1, .written = history.len, .status = .needs_input }, first);
    try testing.expectEqual(0, decoder.work);
    // The last octet, and no room: the call builds every table and decodes every literal.
    const last = try decoder.decode(input[input.len - 1 ..], output[history.len..][0..0]);
    try testing.expectEqual(codec.Progress{ .consumed = 1, .written = 0, .status = .needs_room }, last);
    try testing.expectEqual(work, decoder.work);
    try expect_bounded(decoder.work, last.consumed, last.written);
    const rest = try decoder.decode("", output[history.len..]);
    try testing.expectEqual(codec.Progress{ .consumed = 0, .written = constants.block_len_max, .status = .done }, rest);
    try testing.expectEqual(work, decoder.work);
}
