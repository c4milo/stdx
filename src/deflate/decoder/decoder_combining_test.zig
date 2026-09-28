//! Tests for S11 (decision 14): the literal/length entries that hold a length and its
//! distance's code, which the decoder builds for a dynamic block once the stream has shown itself
//! long, and which a decode that sets `combine_bits_min` to none builds for every dynamic block.
//! Split from decoder_dynamic_test.zig, whose blocks they build.

const constants = @import("../constants.zig");
const decoder_test = @import("decoder_test.zig");
const Stream = decoder_test.Stream;
const Dynamic = @import("decoder_dynamic_test.zig").Dynamic;

/// A symbol and the length of its code.
const SymbolLength = struct { u16, u8 };

/// A block with HLIT + 257 of `literal_count` and HDIST + 1 of `distance_count`, whose codes give
/// each symbol of `literal_lengths` and `distance_lengths` its length, and every other none.
fn block_of(literal_count: u16, distance_count: u16, literal_lengths: []const SymbolLength, distance_lengths: []const SymbolLength) Dynamic {
    var block: Dynamic = .{ .literal_count = literal_count, .distance_count = distance_count };
    for (literal_lengths) |length| block.literal_lengths[length[0]] = length[1];
    for (distance_lengths) |length| block.distance_lengths[length[0]] = length[1];
    return block;
}

test "S11: a length and its distance's code decode in one lookup, near and far" {
    // The longest literal/length code takes 12 bits, so the table is 11 bits wide, and lengths 3,
    // 11 - 12 and 19 - 22 (codes 257, 265 and 269) take 3, 3 and 4 bits, short enough to combine
    // with the distances' codes: 1, 5 - 6 and 65 - 96 (codes 0, 4 and 12) in 2 bits, and 9 - 12
    // and 33 - 48 (codes 6 and 10) in 3. Both codes are complete.
    const literal_lengths = [_]SymbolLength{
        .{ 'a', 2 }, .{ 'b', 2 },  .{ 257, 3 },  .{ 265, 3 },                     .{ 269, 4 },  .{ 'c', 4 },
        .{ 'd', 5 }, .{ 'e', 5 },  .{ 'f', 5 },  .{ 'g', 6 },                     .{ 'h', 7 },  .{ 'i', 8 },
        .{ 'j', 9 }, .{ 'k', 10 }, .{ 'l', 11 }, .{ constants.end_of_block, 12 }, .{ 'm', 12 },
    };
    const distance_lengths = [_]SymbolLength{ .{ 0, 2 }, .{ 4, 2 }, .{ 12, 2 }, .{ 6, 3 }, .{ 10, 3 } };
    const block = block_of(270, 13, &literal_lengths, &distance_lengths);
    // A history, then pairs far enough back for the common loop's chunk copies, and less than a
    // word back for the step out of line.
    const history_len = 96;
    const pairs = [_]struct { u16, u16 }{
        .{ 3, 1 },  .{ 12, 40 }, .{ 20, 6 },  .{ 22, 96 }, .{ 11, 33 },
        .{ 19, 5 }, .{ 21, 65 }, .{ 12, 10 }, .{ 12, 48 }, .{ 20, 9 },
    };
    var stream: Stream = .{};
    block.header(&stream, true);
    var expected: [history_len + pairs.len * constants.match_len_max]u8 = undefined;
    for (expected[0..history_len], 0..) |*octet, index| {
        octet.* = "abcdefghijklm"[index % 13];
        block.literal(&stream, octet.*);
    }
    var len: usize = history_len;
    for (pairs) |pair| {
        block.pair(&stream, pair[0], pair[1]);
        for (0..pair[0]) |_| {
            expected[len] = expected[len - pair[1]];
            len += 1;
        }
    }
    block.literal(&stream, constants.end_of_block);
    try decoder_test.expect_decodes(stream.slice(), expected[0..len]);
}

test "RFC 1951 section 3.2.5: code 284 with extra bits 31 is refused where the table holds its extra bits" {
    // Code 284 takes 3 bits, so its 5 extra bits fit the table with it, which the 12-bit codes
    // make 11 bits wide. The literal/length code is complete.
    const literal_lengths = [_]SymbolLength{
        .{ 'a', 2 }, .{ 'b', 2 },  .{ 257, 3 },  .{ 284, 3 },                     .{ 269, 4 },  .{ 'c', 4 },
        .{ 'd', 5 }, .{ 'e', 5 },  .{ 'f', 5 },  .{ 'g', 6 },                     .{ 'h', 7 },  .{ 'i', 8 },
        .{ 'j', 9 }, .{ 'k', 10 }, .{ 'l', 11 }, .{ constants.end_of_block, 12 }, .{ 'm', 12 },
    };
    const distance_lengths = [_]SymbolLength{ .{ 0, 1 }, .{ 1, 1 } };
    const block = block_of(constants.literal_length_used, 2, &literal_lengths, &distance_lengths);
    var stream: Stream = .{};
    block.header(&stream, true);
    for ("abab") |octet| block.literal(&stream, octet);
    block.literal(&stream, 284);
    stream.bits(31, 5);
    block.distance(&stream, 0);
    block.literal(&stream, constants.end_of_block);
    try decoder_test.expect_refused(stream.slice(), error.InvalidLength);
}
