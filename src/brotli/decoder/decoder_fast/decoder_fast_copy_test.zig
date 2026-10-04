//! The fast path's copies (decision 16, S4): a copy of each kind, at a distance its steps do not
//! divide, from octets that repeat only at that distance, decoded into every room up to two margins
//! past its end, so that the loop takes it in the rooms that hold its margin, with octets past the
//! room that nothing may write.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const decoder_module = @import("../decoder.zig");
const fast = @import("decoder_fast.zig");
const constants = @import("../../constants.zig");
const test_stream = @import("../test_stream.zig");
const Stream = test_stream.Stream;

const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });
const test_window_bits = 16;

/// NPOSTFIX 3 and NDIRECT's high bits 13: 104 direct codes, 16 to 119, the distances 1 to 104
/// (RFC 7932 §4), and the alphabet they give.
const postfix_three = 3;
const direct_high_thirteen = 13;
const direct_codes_first = constants.distance_short_codes_count - 1;
const distance_alphabet_len = constants.distance_short_codes_count + (direct_high_thirteen << postfix_three) + (constants.distance_code_groups << postfix_three);

/// A copy's length, and the insert-and-copy symbol and copy code that give it: insert code 0, in the
/// cell of insert codes 0 to 7 and copy codes 16 to 23 (RFC 7932 §5), a command of no literals
/// whose copy takes a distance code.
const Copy = struct { len: u16, symbol: u16, code: u8 };

/// The octets the pattern takes: each differs from those within `distance_max` of it.
const pattern_step = 37;
const pattern_start = 11;
const pattern_modulus = 251;

/// The rooms past the copy's end, and past the room an octet no pattern holds, each over two
/// margins, more than a command writes.
const sentinel = 0xff;
const margins = 2;
const past_len = margins * fast.output_margin;

const distance_max = 100;
const copy_len_max = 961;

fn pattern_octet(index: usize) u8 {
    return @intCast((index * pattern_step + pattern_start) % pattern_modulus);
}

/// The stream: an uncompressed `distance` octets of the pattern, then a meta-block of one command,
/// the copy from `distance` back.
fn copy_stream(stream: *Stream, distance: u8, copy: Copy) void {
    var pattern: [distance_max]u8 = undefined;
    for (pattern[0..distance], 0..) |*octet, index| octet.* = pattern_octet(index);
    stream.window_bits_16();
    stream.uncompressed(pattern[0..distance]);
    stream.meta_block(true, copy.len);
    stream.simple_header(postfix_three, direct_high_thirteen, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{0}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{copy.symbol}, false);
    stream.simple_code(distance_alphabet_len, &.{direct_codes_first + distance}, false);
    const code = constants.copy_length_codes[copy.code];
    stream.put(copy.len - code.base, code.extra_bits);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (test_stream.trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

/// A command alike its neighbours: its literals and its copy, with the insert-and-copy symbol and
/// the codes that give them (RFC 7932 §5).
const Command = struct { insert_len: u16, insert_code: u8, copy_len: u16, copy_code: u8, symbol: u16 };

/// The literal every command inserts, which the pattern does not hold.
const literal = 0xfe;

/// The commands of a stream: `count` of `first`, or of `first` and `other` in turn, `first`'s symbol
/// the lower; with `switches`, each an insert-and-copy block of its own.
const Commands = struct { first: Command, other: ?Command = null, count: u32, switches: bool = false };

/// The command at `index`.
fn command_at(commands: Commands, index: usize) Command {
    const other = commands.other orelse return commands.first;
    return if (index % turns == 0) commands.first else other;
}

/// The commands that take turns where a stream has an `other`.
const turns = 2;

/// The stream: an uncompressed `distance` octets of the pattern, then a meta-block of the commands,
/// each one's literals and its copy from `distance` back. The literals and the distances have one
/// code each, of no bits, and the commands one, or two of 1 bit, so a command takes its symbol's
/// bit, where there are two, and its extra bits: the insert's, then the copy's. With `switches`,
/// each command is an insert-and-copy block of its own, of two block types alike, so that a block
/// switch stands before every command but the first (RFC 7932 §6).
fn commands_stream(stream: *Stream, distance: u8, commands: Commands) void {
    var pattern: [distance_max]u8 = undefined;
    for (pattern[0..distance], 0..) |*octet, index| octet.* = pattern_octet(index);
    var len: u32 = 0;
    for (0..commands.count) |index| len += @as(u32, command_at(commands, index).insert_len) + command_at(commands, index).copy_len;
    stream.window_bits_16();
    stream.uncompressed(pattern[0..distance]);
    stream.meta_block(true, len);
    if (commands.switches) switching_header(stream) else stream.simple_header(postfix_three, direct_high_thirteen, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{literal}, false);
    command_codes(stream, commands);
    stream.simple_code(distance_alphabet_len, &.{direct_codes_first + distance}, false);
    for (0..commands.count) |index| {
        const command = command_at(commands, index);
        // A block switch: its type's code and its count's take no bits, the count's extra bits 2.
        if (commands.switches and index > 0) stream.put(0, constants.block_count_codes[0].extra_bits);
        if (commands.other != null) stream.put_code(@intCast(index % turns), 1);
        const insert = constants.insert_length_codes[command.insert_code];
        const copy = constants.copy_length_codes[command.copy_code];
        stream.put(command.insert_len - insert.base, insert.extra_bits);
        stream.put(command.copy_len - copy.base, copy.extra_bits);
    }
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (test_stream.trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

/// The insert-and-copy codes: one of `first`'s symbol, or of both symbols, the lower first; with
/// `switches`, the same again for the second block type.
fn command_codes(stream: *Stream, commands: Commands) void {
    for (0..if (commands.switches) constants.block_switch_types_min else 1) |_| {
        if (commands.other) |other| {
            std.debug.assert(commands.first.symbol < other.symbol);
            stream.simple_code(constants.insert_copy_alphabet_len, &.{ commands.first.symbol, other.symbol }, false);
        } else stream.simple_code(constants.insert_copy_alphabet_len, &.{commands.first.symbol}, false);
    }
}

/// The header of `commands_stream` with NBLTYPESI 2 (RFC 7932 §6, §9.2): the block type code of
/// the symbol 1, the next type, the count code of the symbol 0, whose 2 extra bits give 1 to 4,
/// and the first block's count, 1; one block type in the other categories, and one tree a map.
fn switching_header(stream: *Stream) void {
    stream.count(1);
    stream.count(constants.block_switch_types_min);
    stream.simple_code(constants.block_switch_types_min + constants.block_type_symbol_offset, &.{1}, false);
    stream.simple_code(constants.block_count_alphabet_len, &.{0}, false);
    stream.put(0, constants.block_count_codes[0].extra_bits);
    stream.count(1);
    stream.put(postfix_three, constants.postfix_field_bits);
    stream.put(direct_high_thirteen, constants.direct_field_bits);
    stream.put(0, constants.context_mode_bits);
    stream.count(1);
    stream.count(1);
}

/// What `commands_stream` decodes to, into `expected`: the octets it takes.
fn commands_expected(expected: []u8, distance: u8, commands: Commands) usize {
    for (expected[0..distance], 0..) |*octet, index| octet.* = pattern_octet(index);
    var len: usize = distance;
    for (0..commands.count) |index| {
        const command = command_at(commands, index);
        @memset(expected[len..][0..command.insert_len], literal);
        len += command.insert_len;
        for (0..command.copy_len) |_| {
            expected[len] = expected[len - distance];
            len += 1;
        }
    }
    return len;
}

/// Decodes the commands into every room up to two margins past their end, each room followed by
/// octets that nothing may write: the loop starts with the margin's room and goes on with less,
/// the room as the octets left.
fn check_commands_rooms(distance: u8, commands: Commands) !void {
    for ([_]?Command{ commands.first, commands.other }) |maybe| {
        const command = maybe orelse continue;
        const insert = constants.insert_length_codes[command.insert_code];
        const copy = constants.copy_length_codes[command.copy_code];
        try testing.expect(command.insert_len >= insert.base and command.insert_len - insert.base < @as(u32, 1) << @intCast(insert.extra_bits));
        try testing.expect(command.copy_len >= copy.base and command.copy_len - copy.base < @as(u32, 1) << @intCast(copy.extra_bits));
    }
    var stream: Stream = .{};
    commands_stream(&stream, distance, commands);
    var expected: [commands_len_max]u8 = undefined;
    const len = commands_expected(&expected, distance, commands);
    try check_expected_rooms(stream.written(), expected[0..len]);
}
const commands_len_max = 4096;

fn check_rooms(distance: u8, copy: Copy) !void {
    var stream: Stream = .{};
    copy_stream(&stream, distance, copy);
    try check_stream_rooms(stream.written(), distance, distance + copy.len);
}

/// Decodes `input`, `len` octets of the pattern repeated every `distance`, into every room up to two
/// margins past its end, each followed by octets that nothing may write.
fn check_stream_rooms(input: []const u8, distance: u8, len: usize) !void {
    var expected: [distance_max + copy_len_max]u8 = undefined;
    for (expected[0..len], 0..) |*octet, index| octet.* = pattern_octet(index % distance);
    try check_expected_rooms(input, expected[0..len]);
}

/// Decodes `input` into every room up to two margins past `expected`'s end: the octets the room
/// holds, and nothing past it.
fn check_expected_rooms(input: []const u8, expected: []const u8) !void {
    var output: [commands_len_max + past_len + past_len]u8 = undefined;
    for (0..expected.len + past_len + 1) |room| {
        @memset(&output, sentinel);
        var decoder: Decoder = undefined;
        decoder.init(codec.Features.detect());
        const progress = try decoder.decode(input, output[0..room]);
        const written = @min(room, expected.len);
        try testing.expectEqual(written, progress.written);
        try testing.expectEqualSlices(u8, expected[0..written], output[0..written]);
        for (output[room..]) |octet| try testing.expectEqual(sentinel, octet);
        if (room >= expected.len) try testing.expectEqual(.done, progress.status);
    }
}

test "commands near the room's end write nothing past any room, the room as the octets left" {
    comptime std.debug.assert(distance_max + copy_len_max <= commands_len_max);
    // Symbol 168, 5 literals and a copy of 2: the literals move the copy's two chunks.
    const literals_and_copy: Command = .{ .insert_len = 5, .insert_code = 5, .copy_len = 2, .copy_code = 0, .symbol = 168 };
    const streams = [_]Commands{
        // Symbol 128, no literals and a copy of 2: at a distance of chunks it stores two chunks
        // whatever its length, the most past its length.
        .{ .first = .{ .insert_len = 0, .insert_code = 0, .copy_len = 2, .copy_code = 0, .symbol = 128 }, .count = 200 },
        // Symbol 384, no literals and a copy of 100, copy code 16: chunks past the two.
        .{ .first = .{ .insert_len = 0, .insert_code = 0, .copy_len = 100, .copy_code = 16, .symbol = 384 }, .count = 9 },
        .{ .first = literals_and_copy, .count = 120 },
        // Symbol 456, 300 literals, insert code 17, and a copy of 2: the literals take two runs,
        // and the second may pass a room that held the margin when the command started.
        .{ .first = .{ .insert_len = 300, .insert_code = 17, .copy_len = 2, .copy_code = 0, .symbol = 456 }, .count = 6 },
        // Symbol 587, 250 literals and a copy of 20, copy code 11: one run, which may leave the
        // copy's two chunks less room than they store into.
        .{ .first = .{ .insert_len = 250, .insert_code = 17, .copy_len = 20, .copy_code = 11, .symbol = 587 }, .count = 6 },
        // In turn with symbol 387, no literals and a copy of 250, copy code 19, which may leave
        // less room than the two chunks: the command after it is Zig's.
        .{ .first = literals_and_copy, .other = .{ .insert_len = 0, .insert_code = 0, .copy_len = 250, .copy_code = 19, .symbol = 387 }, .count = 12 },
    };
    for (streams) |commands| try check_commands_rooms(distance_max, commands);
}

test "a block switch below the margin leaves its command to the room's checks, at every room" {
    // Symbol 288, 40 literals, insert code 12, and a copy of 2: after a block switch the loop
    // left below the margin, the literals may pass the room.
    const command: Command = .{ .insert_len = 40, .insert_code = 12, .copy_len = 2, .copy_code = 0, .symbol = 288 };
    try check_commands_rooms(distance_max, .{ .first = command, .count = switching_commands, .switches = true });
}
const switching_commands = 12;

test "a copy of each kind writes its octets into every room, and nothing past it" {
    // A distance for each kind of copy: an octet at a time, a fill, words of 8, and chunks of 16 at
    // three distances.
    const distances = [_]u8{ 5, 1, 12, 20, 40, 100 };
    // A copy within a chunk, of copy code 18 (134 and 6 extra bits), and one past it, of copy code
    // 21 (582 and 9 extra bits): each a whole number of chunks and an octet, so that the last
    // chunk stores the most past the copy's end.
    const copies = [_]Copy{ .{ .len = 193, .symbol = 386, .code = 18 }, .{ .len = copy_len_max, .symbol = 389, .code = 21 } };
    for (distances) |distance| {
        for (copies) |copy| try check_rooms(distance, copy);
    }
}
