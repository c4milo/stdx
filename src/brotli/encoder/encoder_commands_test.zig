//! The tests of encoder_commands.zig: the ring's short codes, the weighing of a match and the
//! literal cost.

const std = @import("std");
const constants = @import("../constants.zig");
const encoder_commands = @import("encoder_commands.zig");
const Commands = encoder_commands.Commands;
const WideCommands = encoder_commands.WideCommands;
const coded_of = encoder_commands.coded_of;

test "a distance the ring holds takes its short code, and code 0 moves no distance" {
    // RFC 7932 §4: the ring starts 4, 11, 15, 16. Distance 4 is code 0 and stays; 15 is code 2 and
    // goes first; 100 takes code 25, as 103 is 0b1100111, and goes first.
    var commands: Commands = undefined;
    commands.init();
    const window = [_]u8{0} ** 64;
    commands.add(true, &window, 0, 0, 4, 4);
    try std.testing.expectEqualSlices(u32, &constants.last_distances_initial, &commands.last_distances);
    commands.add(true, &window, 4, 8, 4, 15);
    commands.add(true, &window, 12, 12, 4, 100);
    try std.testing.expectEqualSlices(u32, &.{ 100, 15, 4, 11 }, &commands.last_distances);
    const codes = [_]u8{ commands.commands[0].distance_code(), commands.commands[1].distance_code(), commands.commands[2].distance_code() };
    try std.testing.expectEqualSlices(u8, &.{ 0, 2, 25 }, &codes);
    // RFC 7932 §5: no insert and a copy of 4 with distance code 0 is symbol 2, of the cell that
    // leaves the distance out; 4 inserted and 4 copied with another code is 128 + 34.
    try std.testing.expectEqual(2, coded_of(true, commands.commands[0]).symbol);
    try std.testing.expectEqual(162, coded_of(true, commands.commands[1]).symbol);
    try std.testing.expectEqual(1, commands.command_counts[2]);
    try std.testing.expectEqual(0, commands.distance_counts[0]);
    try std.testing.expectEqual(1, commands.distance_counts[2]);
    try std.testing.expectEqual(1, commands.distance_counts[25]);
    const extra = coded_of(true, commands.commands[2]);
    try std.testing.expectEqual(5, extra.distance_extra_bits);
    try std.testing.expectEqual(103 - 96, extra.distance_extra);
}

test "a match is taken when the literals it replaces cost more than it" {
    // At 2 bits a literal, a match 1000 back costs 12 bits and 9 of distance, 168 eighths: 10
    // literals save 160 and 11 save 176.
    var commands: Commands = undefined;
    commands.init();
    commands.literal_cost = 16;
    try std.testing.expect(!commands.takes(true, 10, 1000));
    try std.testing.expect(commands.takes(true, 11, 1000));
    // Nearer, a shorter match pays: 1 back costs 96 eighths, which 7 literals pass.
    try std.testing.expect(!commands.takes(true, 6, 1));
    try std.testing.expect(commands.takes(true, 7, 1));
}

test "a literal's cost is the mean length of the code its meta-block built" {
    var commands: Commands = undefined;
    commands.init();
    try std.testing.expectEqual(constants.encoder_literal_cost_initial, commands.literal_cost);
    // The last octet value too, which the weighing's last group of lanes holds.
    const window = "aaab\xff\xff\xff\xff";
    commands.add_literals(true, window);
    var lengths: [constants.literal_alphabet_len]u8 = @splat(0);
    lengths['a'] = 1;
    lengths['b'] = 3;
    lengths[0xff] = 5;
    commands.weigh_literals(&lengths);
    // Three literals of 1 bit, one of 3 and four of 5: 26 bits over 8, 26 eighths.
    try std.testing.expectEqual(26, commands.literal_cost);
}

test "level 5's commands take a code of 4 to 15 and keep the code with extra bits until the end" {
    try @call(.never_inline, expect_near_codes, .{});
}

/// After a match 100 back, one 102 back takes code 7, the last distance plus 2, with no extra bits,
/// and keeps the code it takes otherwise, 25 with 5 extra bits as 105 is 0b1101001, in its field of
/// extra bits; both distances join the ring (RFC 7932 §4). Level 1's commands take code 25.
fn expect_near_codes() !void {
    const window = [_]u8{0} ** 256;
    var wide: WideCommands = undefined;
    wide.init();
    wide.add(true, &window, 0, 120, 4, 100);
    wide.add(true, &window, 124, 124, 4, 102);
    try std.testing.expectEqual(7, wide.commands[1].distance_code());
    try std.testing.expectEqual(25 << constants.encoder_level5.near_fallback_shift | (105 - 96), wide.commands[1].distance_extra);
    try std.testing.expectEqual(1, wide.near.total);
    try std.testing.expectEqual(1, wide.near.counts[25]);
    try std.testing.expectEqual(5, wide.near.extra_bits);
    try std.testing.expectEqual(1, wide.distance_counts[7]);
    try std.testing.expectEqualSlices(u32, &.{ 102, 100, 4, 11 }, &wide.last_distances);
    var narrow: Commands = undefined;
    narrow.init();
    narrow.add(true, &window, 0, 120, 4, 100);
    narrow.add(true, &window, 124, 124, 4, 102);
    try std.testing.expectEqual(25, narrow.commands[1].distance_code());
    try std.testing.expectEqual(105 - 96, narrow.commands[1].distance_extra);
    // A meta-block's reset empties the tally; the ring stays.
    wide.reset();
    try std.testing.expectEqual(0, wide.near.total);
    try std.testing.expectEqual(0, wide.near.counts[25]);
    try std.testing.expectEqualSlices(u32, &.{ 102, 100, 4, 11 }, &wide.last_distances);
}
