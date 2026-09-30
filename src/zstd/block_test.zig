//! Tests for a compressed block's execution: a block written by hand, with raw literals and
//! sequences under RLE_Mode tables, decoded whole and in output pieces of every small size, and the
//! offsets and literals lengths a block refuses.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const block = @import("block.zig");
const huffman = @import("huffman.zig");
const sequences = @import("sequences.zig");
const work_module = @import("work.zig");
const BitWriter = @import("test_writer.zig").BitWriter;
const sequences_x86_64 = @import("fast_sequences/fast_sequences_x86_64.zig");

/// A window of one Block_Maximum_Size, enough for these blocks.
const window_len = constants.block_len_max;
const Window = codec.Window(window_len);

/// The Offset_Value extra bits of offset code 2, which the written blocks use.
const offset_extra_bits = 2;

/// What a block decodes with: its tables, buffers and the frame's history.
const Fixture = struct {
    window: Window = undefined,
    table: huffman.Table = undefined,
    table_valid: bool = false,
    buffer: [constants.block_len_max]u8 = undefined,
    tables: sequences.Tables = undefined,
    repeats: [constants.repeated_offsets_initial.len]u32 = constants.repeated_offsets_initial,
    /// The output before this index is in the window: none, as every piece of a test's block
    /// stays in one output.
    synced: usize = 0,
    frame_len: u64 = 0,
    /// Window_Size and Block_Maximum_Size, which a test may set below the octets a block decodes.
    window_len: u64 = window_len,
    block_len_max: u32 = constants.block_len_max,
    work: work_module.Work = work_module.zero,

    fn start(self: *Fixture) void {
        self.window.init();
        self.tables.init();
    }

    fn context(self: *Fixture, octets: []const u8) block.Context {
        return .{
            .block = octets,
            .literals_buffer = &self.buffer,
            .huffman = .{ .table = &self.table, .table_valid = &self.table_valid, .buffer = &self.buffer, .assembly = sequences_x86_64.runs(codec.Features.detect()) },
            .tables = &self.tables,
            .repeats = &self.repeats,
            .block_len_max = self.block_len_max,
            .window_len = self.window_len,
            .work = &self.work,
            .assembly = sequences_x86_64.runs(codec.Features.detect()),
        };
    }
};

/// A block of `head`, its literals section and sequences header, then a stream of one sequence
/// per Offset_Value extra in `extras`, each of `offset_extra_bits` bits.
fn written_block(head: []const u8, extras: []const u8, octets: []u8) []const u8 {
    @memcpy(octets[0..head.len], head);
    var writer: BitWriter = .{};
    // The first sequence's bits are read first, so written last.
    var index = extras.len;
    while (index > 0) {
        index -= 1;
        writer.put(extras[index], offset_extra_bits);
    }
    const stream = writer.finish();
    @memcpy(octets[head.len..][0..stream.len], stream);
    return octets[0 .. head.len + stream.len];
}

fn decode(fixture: *Fixture, octets: []const u8, output: []u8, piece_len: usize) ![]const u8 {
    var run: block.Run = undefined;
    try block.prepare(.{}, &run, fixture.context(octets));
    var written: usize = 0;
    for (0..output.len + 1) |_| {
        const room = @min(piece_len, output.len - written);
        var sink: block.Sink(Window) = .{ .output = output[0 .. written + room], .written = written, .window = &fixture.window, .synced = &fixture.synced, .frame_len = &fixture.frame_len, .window_each = false };
        const ended = try block.execute(.{}, Window, &run, fixture.context(octets), &sink);
        written = sink.written;
        if (ended) return output[0..written];
    }
    return error.TestUnexpectedResult;
}

test "a block's sequences copy literals and matches, whole and in pieces of any size" {
    // Literals length code 3 is 3 literals; offset code 2 is Offset_Value 4 plus 2 bits; match
    // length code 1 is 4. Offset_Value 6 is offset 3, and 4 is offset 1.
    // Raw literals "abcdefgh", 2 sequences, RLE_Mode for all three codes: 3, 2 and 1.
    const head = [_]u8{ 8 << 3, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 2, 1 << 6 | 1 << 4 | 1 << 2, 3, 2, 1 };
    var octets: [64]u8 = undefined;
    const written = written_block(&head, &.{ 2, 0 }, &octets);
    for (1..8) |piece_len| {
        var fixture: Fixture = .{};
        fixture.start();
        var output: [32]u8 = undefined;
        try testing.expectEqualStrings("abcabcadefffffgh", try decode(&fixture, written, &output, piece_len));
        try testing.expectEqual(16, fixture.frame_len);
        try testing.expectEqualSlices(u32, &.{ 1, 3, 1 }, &fixture.repeats);
    }
}

test "a block's repeated literals fill its literal runs, whole and in pieces of any size" {
    // Repeated literals in the two-octet form: Literals_Block_Type 1, Size_Format 1, and a
    // Regenerated_Size of 100 from bit 4, then the octet 'z'. The first test's two sequences take
    // 6 literals and copy two matches of 4; the checked path copies the other 94 literals after
    // them, in one fill when the output holds them.
    const literals_len = 100;
    const head = [_]u8{ (literals_len << 4 | 1 << 2 | 1) & 0xff, literals_len >> 4, 'z', 2, 1 << 6 | 1 << 4 | 1 << 2, 3, 2, 1 };
    var octets: [64]u8 = undefined;
    const written = written_block(&head, &.{ 2, 0 }, &octets);
    const decoded: [literals_len + 4 + 4]u8 = @splat('z');
    for ([_]usize{ 1, 2, 3, 5, 7, 16, decoded.len }) |piece_len| {
        var fixture: Fixture = .{};
        fixture.start();
        var output: [2 * decoded.len]u8 = @splat(0);
        try testing.expectEqualSlices(u8, &decoded, try decode(&fixture, written, &output, piece_len));
    }
}

test "an offset past the frame's first octet and literals past the section are refused" {
    var octets: [64]u8 = undefined;
    var fixture: Fixture = .{};
    fixture.start();
    var output: [32]u8 = undefined;
    // Offset_Value 7 is offset 4, where 3 literals were decoded.
    const one = [_]u8{ 8 << 3, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 1, 1 << 6 | 1 << 4 | 1 << 2, 3, 2, 1 };
    try testing.expectError(error.OffsetTooFar, decode(&fixture, written_block(&one, &.{3}, &octets), &output, 32));
    // Literals length code 15 is 15 literals, where the section holds 8.
    const long = [_]u8{ 8 << 3, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 1, 1 << 6 | 1 << 4 | 1 << 2, 15, 2, 1 };
    fixture = .{};
    fixture.start();
    try testing.expectError(error.LiteralsOverrun, decode(&fixture, written_block(&long, &.{2}, &octets), &output, 32));
}

test "an offset equal to Window_Size is accepted, and one past it refused, within reach" {
    // Two sequences of 3 literals and a match of 4: offset 3 (Offset_Value 6), then offset 4
    // (Offset_Value 7), which reaches back into the 10 octets decoded by then. Window_Size is set
    // below the block's octets so that it, and not the window's reach, decides (decision 22).
    const head = [_]u8{ 8 << 3, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 2, 1 << 6 | 1 << 4 | 1 << 2, 3, 2, 1 };
    var octets: [64]u8 = undefined;
    const written = written_block(&head, &.{ 2, 3 }, &octets);
    var output: [32]u8 = undefined;
    var fixture: Fixture = .{ .window_len = 4 };
    fixture.start();
    try testing.expectEqualStrings("abcabcadefadefgh", try decode(&fixture, written, &output, 32));
    fixture = .{ .window_len = 3 };
    fixture.start();
    try testing.expectError(error.OffsetTooFar, decode(&fixture, written, &output, 32));
}

test "a block past Block_Maximum_Size, and octets after a section of no sequences, are refused" {
    // The block of the first test decodes to 16 octets.
    const head = [_]u8{ 8 << 3, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 2, 1 << 6 | 1 << 4 | 1 << 2, 3, 2, 1 };
    var octets: [64]u8 = undefined;
    const written = written_block(&head, &.{ 2, 0 }, &octets);
    var output: [32]u8 = undefined;
    var fixture: Fixture = .{ .block_len_max = 16 };
    fixture.start();
    try testing.expectEqualStrings("abcabcadefffffgh", try decode(&fixture, written, &output, 32));
    fixture = .{ .block_len_max = 15 };
    fixture.start();
    try testing.expectError(error.BlockTooLong, decode(&fixture, written, &output, 32));
    // Number_of_Sequences 0, then an octet more.
    fixture = .{};
    fixture.start();
    var run: block.Run = undefined;
    try block.prepare(.{}, &run, fixture.context(&.{ 1 << 3, 'a', 0 }));
    try testing.expectError(error.SequencesStreamInvalid, block.prepare(.{}, &run, fixture.context(&.{ 1 << 3, 'a', 0, 0 })));
}
