//! Tests for the Sequences_Section: RFC 8878 Table 18's Repeated_Offsets as errata 6442 and 8085
//! correct them, each form of Number_of_Sequences, the header's refusals, and sequences decoded
//! from a stream written by hand with RLE_Mode tables, whose states read no bits.

const std = @import("std");
const testing = std.testing;
const constants = @import("constants.zig");
const fse = @import("fse.zig");
const sequences = @import("sequences.zig");
const test_writer = @import("test_writer.zig");
const BitWriter = test_writer.BitWriter;

test "Repeated_Offsets follow Table 18, with the rows errata 6442 and 8085 correct" {
    var repeats = constants.repeated_offsets_initial;
    // Offset_Value, literals length, then the resolved offset and Repeated_Offset1 to 3 after it.
    const rows = [_]struct { u32, u32, u32, [3]u32 }{
        .{ 1114, 11, 1111, .{ 1111, 1, 4 } },
        .{ 1, 22, 1111, .{ 1111, 1, 4 } },
        .{ 2225, 22, 2222, .{ 2222, 1111, 1 } },
        .{ 1114, 111, 1111, .{ 1111, 2222, 1111 } },
        .{ 3336, 33, 3333, .{ 3333, 1111, 2222 } },
        .{ 2, 22, 1111, .{ 1111, 3333, 2222 } },
        .{ 3, 33, 2222, .{ 2222, 1111, 3333 } },
        // Erratum 6442: an Offset_Value of 3, not 1, with a literals length of 0.
        .{ 3, 0, 2221, .{ 2221, 2222, 1111 } },
        // Erratum 8085: Repeated_Offset3 is 1111, as §3.1.1.5's text gives, not 3333.
        .{ 1, 0, 2222, .{ 2222, 2221, 1111 } },
    };
    for (rows) |row| {
        const offset_value, const literals_len, const offset, const after = row;
        try testing.expectEqual(offset, try sequences.resolve_offset(&repeats, offset_value, literals_len));
        try testing.expectEqualSlices(u32, &after, &repeats);
    }
}

test "an Offset_Value of 3 with no literals refuses Repeated_Offset1 - 1 when it is 0" {
    var repeats = constants.repeated_offsets_initial;
    try testing.expectError(error.OffsetZero, sequences.resolve_offset(&repeats, 3, 0));
}

test "Number_of_Sequences takes one, two or three octets" {
    var tables: sequences.Tables = undefined;
    tables.init();
    try testing.expectEqual(sequences.Header{ .count = 0, .header_len = 1 }, try sequences.read_header(&.{0}, &tables));
    // All three modes Predefined_Mode: the header ends after the modes byte.
    try testing.expectEqual(sequences.Header{ .count = 127, .header_len = 2 }, try sequences.read_header(&.{ 127, 0 }, &tables));
    try testing.expectEqual(sequences.Header{ .count = (130 - 128) * 256 + 7, .header_len = 3 }, try sequences.read_header(&.{ 130, 7, 0 }, &tables));
    try testing.expectEqual(sequences.Header{ .count = (254 - 128) * 256 + 7, .header_len = 3 }, try sequences.read_header(&.{ 254, 7, 0 }, &tables));
    try testing.expectEqual(sequences.Header{ .count = 0x1234 + 0x7F00, .header_len = 4 }, try sequences.read_header(&.{ 255, 0x34, 0x12, 0 }, &tables));
}

test "reserved mode bits, Repeat_Mode first in a frame, an RLE symbol past its alphabet, and a cut header are refused" {
    var tables: sequences.Tables = undefined;
    tables.init();
    try testing.expectError(error.SequencesModesReserved, sequences.read_header(&.{ 1, 0x01 }, &tables));
    try testing.expectError(error.RepeatWithoutTable, sequences.read_header(&.{ 1, 3 << 6 }, &tables));
    // RLE_Mode for literals length codes with symbol 36, past code 35.
    try testing.expectError(error.RepeatSymbolInvalid, sequences.read_header(&.{ 1, 1 << 6, 36 }, &tables));
    try testing.expectError(error.SequencesTruncated, sequences.read_header(&.{ 1, 1 << 6 }, &tables));
    try testing.expectError(error.SequencesTruncated, sequences.read_header(&.{255}, &tables));
}

test "sequences decode from RLE_Mode tables, and bits past the last are refused" {
    // RLE_Mode for all three: literals length code 17 (18 + 1 bit), offset code 5 (32 + 5 bits),
    // match length code 33 (37 + 1 bit).
    var tables: sequences.Tables = undefined;
    tables.init();
    const section = [_]u8{ 3, 1 << 6 | 1 << 4 | 1 << 2, 17, 5, 33 };
    const header = try sequences.read_header(&section, &tables);
    try testing.expectEqual(sequences.Header{ .count = 3, .header_len = 5 }, header);
    const wanted = [_]sequences.Sequence{
        .{ .literals_len = 18, .offset_value = 32 + 7, .match_len = 38 },
        .{ .literals_len = 19, .offset_value = 32 + 31, .match_len = 37 },
        .{ .literals_len = 18, .offset_value = 32, .match_len = 38 },
    };
    // The first sequence decoded is written last: each writes literals, match, then offset bits.
    var writer: BitWriter = .{};
    var index: usize = wanted.len;
    while (index > 0) {
        index -= 1;
        writer.put(wanted[index].literals_len - 18, 1);
        writer.put(wanted[index].match_len - 37, 1);
        writer.put(wanted[index].offset_value - 32, 5);
    }
    const stream_octets = writer.finish();
    var stream = try sequences.start(stream_octets, &tables, header.count);
    for (wanted) |sequence| try testing.expectEqual(sequence, try sequences.next(&stream, stream_octets, &tables));
    // One bit more before the stream's first: the last sequence leaves it unread.
    var longer: BitWriter = .{};
    longer.put(0, 1);
    index = wanted.len;
    while (index > 0) {
        index -= 1;
        longer.put(wanted[index].literals_len - 18, 1);
        longer.put(wanted[index].match_len - 37, 1);
        longer.put(wanted[index].offset_value - 32, 5);
    }
    const longer_octets = longer.finish();
    stream = try sequences.start(longer_octets, &tables, header.count);
    _ = try sequences.next(&stream, longer_octets, &tables);
    _ = try sequences.next(&stream, longer_octets, &tables);
    try testing.expectError(error.SequencesStreamInvalid, sequences.next(&stream, longer_octets, &tables));
}

fn expect_sequences(octets: []const u8, tables: *const sequences.Tables, wanted: []const sequences.Sequence) !void {
    var stream = try sequences.start(octets, tables, @intCast(wanted.len));
    for (wanted) |sequence| try testing.expectEqual(sequence, try sequences.next(&stream, octets, tables));
}

test "sequences decode from the predefined tables, and Repeat_Mode keeps the block's before" {
    // Two sequences under the predefined tables, whose states read bits (RFC 8878 Appendix A, as
    // erratum 6441 corrects it). Initial states: literals length 2 (code 1, next from 32 plus 5
    // bits), offset 5 (code 3, next from 0 plus 5 bits) and match length 3 (code 3, next from 0
    // plus 5 bits). The first sequence moves them to 32 + 11 = 43 (code 0), 1 (code 6) and 3.
    const wanted = [_]sequences.Sequence{
        .{ .literals_len = 1, .offset_value = 8 + 5, .match_len = 6 },
        .{ .literals_len = 0, .offset_value = 64 + 33, .match_len = 6 },
    };
    // The values in the order they are read, each with its bits: the initial states, the first
    // sequence's offset bits, the next states of literals length, match length and offset, then
    // the second sequence's offset bits. They are written in reverse.
    const read_order = [_]struct { u64, usize }{ .{ 2, 6 }, .{ 5, 5 }, .{ 3, 6 }, .{ 5, 3 }, .{ 11, 5 }, .{ 3, 5 }, .{ 1, 5 }, .{ 33, 6 } };
    var writer: BitWriter = .{};
    var index: usize = read_order.len;
    while (index > 0) {
        index -= 1;
        writer.put(read_order[index][0], read_order[index][1]);
    }
    const octets = writer.finish();
    var tables: sequences.Tables = undefined;
    tables.init();
    // RLE_Mode first, so Predefined_Mode has to replace the tables it built.
    _ = try sequences.read_header(&.{ 1, 1 << 6 | 1 << 4 | 1 << 2, 17, 5, 33 }, &tables);
    try testing.expectEqual(sequences.Header{ .count = 2, .header_len = 2 }, try sequences.read_header(&.{ 2, 0 }, &tables));
    try expect_sequences(octets, &tables, &wanted);
    // Repeat_Mode for all three codes: the next block decodes with the same tables.
    try testing.expectEqual(sequences.Header{ .count = 2, .header_len = 2 }, try sequences.read_header(&.{ 2, 3 << 6 | 3 << 4 | 3 << 2 }, &tables));
    try expect_sequences(octets, &tables, &wanted);
}

test "an FSE_Compressed_Mode table replaces a predefined one" {
    var tables: sequences.Tables = undefined;
    tables.init();
    _ = try sequences.read_header(&.{ 1, 0 }, &tables);
    // Literals length codes 0 and 1 at 16 of 32 each: Accuracy_Log 5 (0 in 4 bits), then 17 in 5
    // bits and 31 in 5, by Table 20 (RFC 8878 §4.1.1). State 0 is code 0.
    try testing.expectEqual(sequences.Header{ .count = 1, .header_len = 4 }, try sequences.read_header(&.{ 1, 2 << 6, 0x10, 0x3f }, &tables));
    // Initial states of 5, 5 and 6 bits, all 0, then no extra bits: offset code 0 is Offset_Value
    // 1 and match length code 0 is 3. The predefined literals length table would read 6 bits.
    try expect_sequences(&.{ 0x00, 0x00, 0x01 }, &tables, &.{.{ .literals_len = 0, .offset_value = 1, .match_len = 3 }});
}

test "a stream that ends before its initial states or its sequences is refused" {
    var tables: sequences.Tables = undefined;
    tables.init();
    _ = try sequences.read_header(&.{ 1, 1 << 6 | 1 << 4 | 1 << 2, 17, 5, 33 }, &tables);
    _ = try sequences.read_header(&.{ 1, 0 }, &tables);
    // The predefined tables' initial states take 17 bits; the stream holds none.
    try testing.expectError(error.SequencesStreamInvalid, sequences.start(&.{0x01}, &tables, 1));
    // RLE_Mode tables read no state bits, and each sequence 7 extra bits: three sequences, bits for
    // one.
    _ = try sequences.read_header(&.{ 3, 1 << 6 | 1 << 4 | 1 << 2, 17, 5, 33 }, &tables);
    var writer: BitWriter = .{};
    writer.put(0, 7);
    const octets = writer.finish();
    var stream = try sequences.start(octets, &tables, 3);
    _ = try sequences.next(&stream, octets, &tables);
    try testing.expectError(error.SequencesStreamInvalid, sequences.next(&stream, octets, &tables));
}

test "the offset table counts its cells whose code names a Repeated_Offset, in every mode" {
    var tables: sequences.Tables = undefined;
    tables.init();
    // Predefined_Mode: codes 0 and 1 hold a cell each of 32, 16 of 256 (RFC 8878 §3.1.1.3.2.2).
    _ = try sequences.read_header(&.{ 1, 0 }, &tables);
    try testing.expectEqual(2, tables.offset_repeat_cells);
    try testing.expectEqual(16, tables.offset_repeat_share());
    // RLE_Mode for offsets alone: code 1 names a repeat in the one cell, code 2 in none, and
    // Repeat_Mode keeps the count.
    _ = try sequences.read_header(&.{ 1, 1 << 4, 1 }, &tables);
    try testing.expectEqual(1 << constants.offset_accuracy_log_max, tables.offset_repeat_share());
    _ = try sequences.read_header(&.{ 1, 1 << 4, 2 }, &tables);
    try testing.expectEqual(0, tables.offset_repeat_share());
    _ = try sequences.read_header(&.{ 1, 3 << 4 }, &tables);
    try testing.expectEqual(0, tables.offset_repeat_share());
    // FSE_Compressed_Mode: code 0 at 3 of 32, code 1 "less than 1", one cell, and code 2 the rest.
    var distribution: fse.Distribution = .{ .probabilities = @splat(0), .symbol_count = 3, .accuracy_log = constants.offset_default_accuracy_log };
    distribution.probabilities[0..3].* = .{ 3, -1, 28 };
    var description: test_writer.DescriptionWriter = .{};
    description.write(&distribution);
    var section: [2 + description.octets.len]u8 = undefined;
    const description_len = std.math.divCeil(usize, description.bits_written, @bitSizeOf(u8)) catch unreachable;
    section[0..2].* = .{ 1, 2 << 4 };
    @memcpy(section[2..][0..description_len], description.octets[0..description_len]);
    _ = try sequences.read_header(section[0 .. 2 + description_len], &tables);
    try testing.expectEqual(4, tables.offset_repeat_cells);
    try testing.expectEqual(32, tables.offset_repeat_share());
}
