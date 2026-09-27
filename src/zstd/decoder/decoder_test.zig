//! Tests for the Zstandard decoder over frames written by hand: raw, repeated and compressed
//! blocks, a checksum, a skippable frame before a Zstandard one, every split of input and output
//! the seeded driver draws, and each refusal. libzstd's frames meet the decoder in the
//! differential check (design §8 step 11).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const checksum = @import("checksum");
const constants = @import("../constants.zig");
const decoder_module = @import("decoder.zig");
const huffman = @import("../huffman.zig");
const BitWriter = @import("../test_writer.zig").BitWriter;
const StreamWriter = @import("../test_writer.zig").StreamWriter;

/// A decoder small enough for a test's stack: a window of one Block_Maximum_Size.
pub const Decoder = decoder_module.Decoder(.{ .window_len_max = constants.block_len_max });

/// The octets a written frame takes at most.
const frame_capacity = 32768;

/// Block_Type (RFC 8878 §3.1.1.2.2).
pub const raw_type = 0;
const repeated_type = 1;
pub const compressed_type = 2;
const reserved_type = 3;

/// The Offset_Value extra bits of offset code 2, which the compressed block uses.
const offset_extra_bits = 2;

/// Frame_Header_Descriptor with Frame_Content_Size_Flag 2: a 4-octet Frame_Content_Size.
pub const four_octet_content_size: u8 = 0x80;

/// Literals_Block_Type of a Huffman-coded section with its tree, and of one without (RFC 8878
/// §3.1.1.3.1.1), and the bits before Regenerated_Size in a header of Size_Format 0.
const compressed_literals = 2;
const treeless_literals = 3;
const literals_kind_and_format_bits = 4;

/// The octet an output starts as, which no frame of these tests writes.
const sentinel = 0xee;

/// Appends octets to a frame under construction.
pub const FrameWriter = struct {
    octets: [frame_capacity]u8 = undefined,
    len: usize = 0,

    pub fn put(self: *FrameWriter, octets: []const u8) void {
        @memcpy(self.octets[self.len..][0..octets.len], octets);
        self.len += octets.len;
    }

    pub fn put_int(self: *FrameWriter, comptime T: type, value: T) void {
        var octets: [@bitSizeOf(T) / @bitSizeOf(u8)]u8 = undefined;
        std.mem.writeInt(T, &octets, value, .little);
        self.put(&octets);
    }

    /// Magic_Number, then a single-segment header with a 1-octet Frame_Content_Size.
    fn frame_header(self: *FrameWriter, content_len: u8, with_checksum: bool) void {
        self.put_int(u32, constants.frame_magic);
        const checksum_bit = if (with_checksum) constants.descriptor_checksum else 0;
        self.put(&.{ constants.descriptor_single_segment | checksum_bit, content_len });
    }

    /// A Block_Header: Last_Block, Block_Type, Block_Size.
    pub fn block_header(self: *FrameWriter, last: bool, block_type: u2, size: u21) void {
        self.put_int(u24, @intFromBool(last) | @as(u24, block_type) << constants.block_type_shift | @as(u24, size) << constants.block_size_shift);
    }

    /// Magic_Number, then a header with a Window_Descriptor of 1 KiB and a 4-octet
    /// Frame_Content_Size: 6 octets after the magic.
    pub fn long_frame_header(self: *FrameWriter, content_len: u32) void {
        self.put_int(u32, constants.frame_magic);
        self.put(&.{ four_octet_content_size, 0 });
        self.put_int(u32, content_len);
    }

    pub fn written(self: *const FrameWriter) []const u8 {
        return self.octets[0..self.len];
    }
};

/// A compressed block's content: `head`, its literals section and sequences header, then a stream
/// of one sequence per Offset_Value extra in `extras`, each of `extra_bits` bits.
fn compressed_content(content: *FrameWriter, head: []const u8, extras: []const u8, extra_bits: usize) void {
    content.put(head);
    var bits: BitWriter = .{};
    var index = extras.len;
    while (index > 0) {
        index -= 1;
        bits.put(extras[index], extra_bits);
    }
    content.put(bits.finish());
}

/// A frame of a raw block "raw-", a repeated block "xxxx", and the compressed block `content`,
/// which decodes to `compressed_text`, with the frame's checksum.
fn three_block_frame(writer: *FrameWriter, content: []const u8, text: []const u8) void {
    const raw = "raw-";
    const repeated = "xxxx";
    writer.frame_header(@intCast(text.len), true);
    writer.block_header(false, raw_type, raw.len);
    writer.put(raw);
    writer.block_header(false, repeated_type, repeated.len);
    writer.put(repeated[0..1]);
    writer.block_header(true, compressed_type, @intCast(content.len));
    writer.put(content);
    writer.put_int(u32, @truncate(checksum.xxh64(.scalar, 0, text)));
}

/// The frame most tests decode, and what it decodes to. Raw literals "abcdefgh", two sequences
/// under RLE_Mode tables of literals length code 3 (3 literals), offset code 2 (Offset_Value 4
/// plus 2 bits) and match length code 1 (4): offsets 3 and 1, as in block_test.zig.
pub fn standard_frame(writer: *FrameWriter) []const u8 {
    // 0x40: raw literals, 8 of them; 0x02: two sequences; 0x54: RLE_Mode for all three codes, whose
    // symbols 3, 2 and 1 follow. The sequences' Offset_Value extras are 2 and 0.
    const head = "\x40abcdefgh\x02\x54\x03\x02\x01";
    var content: FrameWriter = .{};
    compressed_content(&content, head, "\x02\x00", offset_extra_bits);
    const text = "raw-xxxxabcabcadefffffgh";
    three_block_frame(writer, content.written(), text);
    return text;
}

test "a frame of raw, repeated and compressed blocks decodes, with its checksum" {
    var writer: FrameWriter = .{};
    const text = standard_frame(&writer);
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var output: [64]u8 = undefined;
    const whole = try decoder.decode_all(writer.written(), &output);
    try testing.expectEqual(writer.len, whole.consumed);
    try testing.expectEqualStrings(text, output[0..whole.written]);
}

fn step(decoder: *Decoder, input: []const u8, output: []u8) decoder_module.Error!codec.Progress {
    return decoder.decode(input, output);
}

test "every split of input and output gives the same octets, the state moved between calls" {
    var writer: FrameWriter = .{};
    const text = standard_frame(&writer);
    for (0..64) |seed| {
        var states: [codec.split.state_slots]Decoder = undefined;
        states[0].init(.{});
        var output: [64]u8 = undefined;
        const outcome = try codec.split.drive(Decoder, &states, step, writer.written(), &output, seed);
        try testing.expectEqual(.done, outcome.status);
        try testing.expectEqualStrings(text, output[0..outcome.written]);
    }
}

test "a skippable frame before a Zstandard frame is skipped, and ends as a frame" {
    var writer: FrameWriter = .{};
    writer.put_int(u32, constants.skippable_magic_first + 7);
    writer.put_int(u32, 5);
    writer.put("hello");
    writer.frame_header(3, false);
    writer.block_header(true, raw_type, 3);
    writer.put("abc");
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var output: [16]u8 = undefined;
    const first = try decoder.decode(writer.written(), &output);
    try testing.expectEqual(codec.Progress{ .consumed = 13, .written = 0, .status = .done }, first);
    decoder.init(.{});
    const whole = try decoder.decode_all(writer.written(), &output);
    try testing.expectEqualStrings("abc", output[0..whole.written]);
}

test "a bad magic, a reserved block type, a checksum and a content size that disagree are refused" {
    var decoder: Decoder = undefined;
    var output: [64]u8 = undefined;
    decoder.init(.{});
    try testing.expectError(error.InvalidMagic, decoder.decode(&.{ 0x28, 0xb5, 0x2f, 0xfe }, &output));
    var reserved: FrameWriter = .{};
    reserved.frame_header(0, false);
    reserved.block_header(true, reserved_type, 0);
    decoder.init(.{});
    try testing.expectError(error.ReservedBlockType, decoder.decode(reserved.written(), &output));
    var bad_checksum: FrameWriter = .{};
    _ = standard_frame(&bad_checksum);
    bad_checksum.octets[bad_checksum.len - 1] ^= 1;
    decoder.init(.{});
    try testing.expectError(error.ChecksumMismatch, decoder.decode_all(bad_checksum.written(), &output));
    // Frame_Content_Size 4 for a raw block of 3.
    var short: FrameWriter = .{};
    short.frame_header(4, false);
    short.block_header(true, raw_type, 3);
    short.put("abc");
    decoder.init(.{});
    try testing.expectError(error.ContentSizeMismatch, decoder.decode(short.written(), &output));
    // A raw block of 5 past a single segment of 4: Block_Maximum_Size is the window, 4.
    var long: FrameWriter = .{};
    long.frame_header(4, false);
    long.block_header(true, raw_type, 5);
    long.put("abcde");
    decoder.init(.{});
    try testing.expectError(error.BlockTooLong, decoder.decode(long.written(), &output));
    try testing.expectEqual(.corrupt, decoder_module.refusal(error.BlockTooLong));
    try testing.expectEqual(.unsupported, decoder_module.refusal(error.WindowTooLarge));
}

test "a cut frame asks for more input, and a full output for more room" {
    var writer: FrameWriter = .{};
    _ = standard_frame(&writer);
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var output: [64]u8 = undefined;
    try testing.expectError(error.Truncated, decoder.decode_all(writer.written()[0 .. writer.len - 1], &output));
    decoder.init(.{});
    try testing.expectError(error.NoSpaceLeft, decoder.decode_all(writer.written(), output[0..10]));
}

test "a block the input holds whole decodes from it, and moves into the state when the output fills (Z5)" {
    var writer: FrameWriter = .{};
    const text = standard_frame(&writer);
    var decoder: Decoder = undefined;
    var output: [64]u8 = undefined;
    // The input ends where the compressed block does, and the checksum comes in the next call.
    const block_end = writer.len - constants.checksum_len;
    decoder.init(.{});
    @memset(&decoder.block_octets, sentinel);
    const blocks = try decoder.decode(writer.written()[0..block_end], &output);
    try testing.expectEqual(codec.Progress{ .consumed = block_end, .written = text.len, .status = .needs_input }, blocks);
    try testing.expect(std.mem.allEqual(u8, &decoder.block_octets, sentinel));
    try testing.expectEqual(.done, (try decoder.decode(writer.written()[block_end..], output[text.len..])).status);
    try testing.expectEqualStrings(text, output[0..text.len]);
    // Room for the raw and repeated blocks and 2 octets of the compressed one: the call takes the
    // block, and the next resumes it from the state with the checksum alone as input.
    decoder.init(.{});
    @memset(&decoder.block_octets, sentinel);
    const first = try decoder.decode(writer.written(), output[0..10]);
    try testing.expectEqual(codec.Progress{ .consumed = block_end, .written = 10, .status = .needs_room }, first);
    const rest = try decoder.decode(writer.written()[block_end..], output[first.written..]);
    try testing.expectEqual(.done, rest.status);
    try testing.expectEqualStrings(text, output[0 .. first.written + rest.written]);
    // With Z5 off, the state gathers the block.
    var gathering: decoder_module.Decoder(.{ .window_len_max = constants.block_len_max, .paths = .{ .claims = .{ .block_in_input = false } } }) = undefined;
    gathering.init(.{});
    @memset(&gathering.block_octets, sentinel);
    _ = try gathering.decode_all(writer.written(), &output);
    try testing.expect(!std.mem.allEqual(u8, &gathering.block_octets, sentinel));
}

test "a magic below the skippable range is refused, and a cut skippable frame asks for more" {
    var decoder: Decoder = undefined;
    var output: [16]u8 = undefined;
    var below: FrameWriter = .{};
    below.put_int(u32, constants.skippable_magic_first - 1);
    decoder.init(.{});
    try testing.expectError(error.InvalidMagic, decoder.decode(below.written(), &output));
    // Octets that start a Magic_Number wait for the rest; others are refused at once.
    for ([_][]const u8{ "\x28", "\x28\xb5\x2f", "\x5f", "\x53\x2a\x4d" }) |start| {
        decoder.init(.{});
        try testing.expectEqual(codec.Progress{ .consumed = start.len, .written = 0, .status = .needs_input }, try decoder.decode(start, &output));
    }
    for ([_][]const u8{ "\x72", "\x28\xb4", "\x60", "\x5f\x2a\x4c" }) |start| {
        decoder.init(.{});
        try testing.expectError(error.InvalidMagic, decoder.decode(start, &output));
    }
    // After a frame, one octet no Magic_Number starts with.
    var trailing: FrameWriter = .{};
    trailing.frame_header(3, false);
    trailing.block_header(true, raw_type, 3);
    trailing.put("abc\x72");
    decoder.init(.{});
    try testing.expectError(error.InvalidMagic, decoder.decode_all(trailing.written(), &output));
    var cut: FrameWriter = .{};
    cut.put_int(u32, constants.skippable_magic_first);
    cut.put_int(u32, 5);
    cut.put("hel");
    decoder.init(.{});
    try testing.expectEqual(codec.Progress{ .consumed = 11, .written = 0, .status = .needs_input }, try decoder.decode(cut.written(), &output));
}

test "a header fed one octet a call resumes, and a block past Frame_Content_Size is refused at once" {
    var writer: FrameWriter = .{};
    writer.long_frame_header(3);
    writer.block_header(true, raw_type, 3);
    writer.put("abc");
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var output: [16]u8 = undefined;
    var written: usize = 0;
    for (0..writer.len) |index| {
        const progress = try decoder.decode(writer.written()[index..][0..1], output[written..]);
        try testing.expectEqual(1, progress.consumed);
        written += progress.written;
    }
    try testing.expectEqualStrings("abc", output[0..written]);
    // Frame_Content_Size 3, and a first block of 5 that is not the last: refused before the input
    // for the next block arrives.
    var long: FrameWriter = .{};
    long.long_frame_header(3);
    long.block_header(false, raw_type, 5);
    long.put("abcde");
    decoder.init(.{});
    try testing.expectError(error.ContentSizeMismatch, decoder.decode(long.written(), &output));
}

/// RFC 8878 Table 24's tree, as literals_test.zig reads it: Number_of_Symbols 5 after
/// huffman_direct_symbols_offset, then literals 0 to 4 weighing 4, 3, 2, 0 and 1; 5 weighs 1.
pub const table_24_tree = "\x84\x43\x20\x10";

/// The literals of the marker frame's Huffman-coded section.
pub const marker_literals = "\x00\x01\x01\x05\x02\x04\x00\x00\x02\x05\x01";

/// The raw block the marker frame starts with, which the window then holds.
const marker = "MARKMARK";

/// The match length of match length code 1, which every sequence here uses.
const match_len = 4;

/// A literals section of one Huffman-coded stream, Size_Format 0: Literals_Block_Type, then
/// Regenerated_Size and Compressed_Size in 10 bits each (RFC 8878 §3.1.1.3.1.1), `tree` (none for
/// a treeless section) and `stream`.
fn huffman_literals(content: *FrameWriter, kind: u2, tree: []const u8, stream: []const u8) void {
    const size_bits = constants.literals_compressed_size_bits[0];
    const compressed_len: u24 = @intCast(tree.len + stream.len);
    const regenerated_len: u24 = marker_literals.len;
    content.put_int(u24, kind | regenerated_len << literals_kind_and_format_bits | compressed_len << (literals_kind_and_format_bits + size_bits));
    content.put(tree);
    content.put(stream);
}

/// A frame that leaves set every state a frame may carry: the marker in the window, a Huffman
/// tree, RLE_Mode sequence tables, and Repeated_Offsets of 3, 1 and 4.
pub fn marker_frame(writer: *FrameWriter, stream: []const u8) void {
    var content: FrameWriter = .{};
    huffman_literals(&content, compressed_literals, table_24_tree, stream);
    // One sequence of RLE_Mode codes: 3 literals, Offset_Value 6 (offset 3), match length 4.
    compressed_content(&content, "\x01\x54\x03\x02\x01", "\x02", offset_extra_bits);
    writer.long_frame_header(marker.len + marker_literals.len + match_len);
    writer.block_header(false, raw_type, marker.len);
    writer.put(marker);
    writer.block_header(true, compressed_type, @intCast(content.len));
    writer.put(content.written());
}

/// The frames that follow the marker frame, each needing a state the marker frame left set.
const Follower = enum { reach, offset_zero, repeat_mode, treeless };

/// Writes the frame `follower`, and returns the refusal it must meet.
fn follower_frame(writer: *FrameWriter, follower: Follower, stream: []const u8) anyerror {
    var content: FrameWriter = .{};
    // The raw literals "ab", then a sequence of RLE_Mode codes: literals length code 0, the
    // offset code, and match length code 1.
    var content_len: u32 = "ab".len + match_len;
    switch (follower) {
        // Offset code 2 and Offset_Value 7, offset 4: before the frame's first octet.
        .reach => compressed_content(&content, "\x10ab\x01\x54\x00\x02\x01", "\x03", offset_extra_bits),
        // Offset code 1 and Offset_Value 3 with no literals: Repeated_Offset1 - 1, which is 0 from
        // the initial 1 (RFC 8878 §3.1.1.5).
        .offset_zero => compressed_content(&content, "\x10ab\x01\x54\x00\x01\x01", "\x01", 1),
        // Repeat_Mode for all three codes in the frame's first block.
        .repeat_mode => compressed_content(&content, "\x10ab\x01\xfc", "", 0),
        // A treeless section in the frame's first block, then no sequences.
        .treeless => {
            huffman_literals(&content, treeless_literals, "", stream);
            content.put("\x00");
            content_len = marker_literals.len;
        },
    }
    // A Window_Descriptor, since Block_Maximum_Size is Window_Size (RFC 8878 §3.1.1.2.4).
    writer.long_frame_header(content_len);
    writer.block_header(true, compressed_type, @intCast(content.len));
    writer.put(content.written());
    return switch (follower) {
        .reach => error.OffsetTooFar,
        .offset_zero => error.OffsetZero,
        .repeat_mode => error.RepeatWithoutTable,
        .treeless => error.TreelessWithoutTree,
    };
}

test "no frame reads the octets, tree, tables or offsets of the frame before it (invariant 10)" {
    var tree: huffman.Table = undefined;
    _ = try huffman.read_tree(table_24_tree, &tree);
    var stream_writer: StreamWriter = .{};
    const stream = stream_writer.write(&tree, marker_literals);
    var first: FrameWriter = .{};
    marker_frame(&first, stream);
    var decoder: Decoder = undefined;
    var output: [64]u8 = undefined;
    for (std.enums.values(Follower)) |follower| {
        var second: FrameWriter = .{};
        const refusal = follower_frame(&second, follower, stream);
        // A decoder whose window holds the marker, started again with `init`.
        decoder.init(.{});
        const marked = try decoder.decode_all(first.written(), &output);
        try testing.expect(std.mem.indexOf(u8, output[0..marked.written], marker) != null);
        decoder.init(.{});
        @memset(&output, sentinel);
        try testing.expectError(refusal, decoder.decode(second.written(), &output));
        try testing.expect(std.mem.allEqual(u8, &output, sentinel));
        // Both frames in one input: the second frame meets the same refusal.
        var both: FrameWriter = .{};
        both.put(first.written());
        both.put(second.written());
        decoder.init(.{});
        @memset(&output, sentinel);
        try testing.expectError(refusal, decoder.decode_all(both.written(), &output));
        try testing.expect(std.mem.allEqual(u8, output[marked.written..], sentinel));
    }
}
