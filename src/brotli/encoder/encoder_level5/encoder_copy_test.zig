//! The tests of level 5's copies of 2 and 3 octets at the last distance (`last_copy`; decision
//! 66, output size): where they save more than their literals cost, and how the parse codes one.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const encoder_commands = @import("../encoder_commands.zig");
const buckets_module = @import("encoder_buckets.zig");
const encoder_lazy = @import("encoder_lazy.zig");

const Buckets = buckets_module.Buckets;
const last_copy = encoder_lazy.last_copy;
const saving = encoder_lazy.saving;
const copy_len_min = encoder_lazy.copy_len_min;
const min_len = encoder_lazy.min_len;

test "a copy at the last distance takes the 2 or 3 octets that agree where they save" {
    try @call(.never_inline, expect_last_copy, .{});
}

fn expect_last_copy() !void {
    var commands: encoder_commands.WideCommands = undefined;
    var window: [copy_window_len]u8 = undefined;
    commands.init();
    commands.last_distances[0] = copy_distance;
    const cost = constants.encoder_literal_cost_initial;
    // 1 to 5 octets agree: fewer than 2 give no copy, and more than 3 give 3, as `best` weighs the
    // rest.
    for (0..min_len + 2) |agreed| {
        seed_window(&window);
        agree(&window, agreed);
        const found = last_copy(true, &window, copy_position, copy_window_len, &commands);
        if (agreed < copy_len_min) {
            try testing.expectEqual(null, found);
            continue;
        }
        const len = @min(agreed, min_len - 1);
        try testing.expectEqual(copy_position, found.?.position);
        try testing.expectEqual(len, found.?.len);
        try testing.expectEqual(copy_distance, found.?.offset);
        try testing.expectEqual(saving(len, copy_distance, true, cost), found.?.saves);
    }
    // At 5 bits a literal, 2 octets save less than a command costs, and 3 more.
    commands.literal_cost = cheap_literal_cost;
    seed_window(&window);
    agree(&window, copy_len_min);
    try testing.expectEqual(null, last_copy(true, &window, copy_position, copy_window_len, &commands));
    agree(&window, min_len - 1);
    try testing.expectEqual(min_len - 1, last_copy(true, &window, copy_position, copy_window_len, &commands).?.len);
    // A reach one octet short, and a distance to position 0, name no copy.
    try testing.expectEqual(null, last_copy(true, &window, copy_position, copy_distance - 1, &commands));
    commands.last_distances[0] = copy_position;
    @memcpy(window[copy_position..][0..copy_len_min], window[0..copy_len_min]);
    try testing.expectEqual(null, last_copy(true, &window, copy_position, copy_window_len, &commands));
}

test "the parse codes a copy of 2 octets at the last distance where no match is found" {
    try @call(.never_inline, expect_parsed_copy, .{});
}

/// A match of `match_len` octets `copy_distance` back sets the last distance; then, after
/// `gap_len` literals, 2 octets agree at that distance and the third does not.
fn expect_parsed_copy() !void {
    var buckets: Buckets = undefined;
    var commands: encoder_commands.WideCommands = undefined;
    var window: [copy_window_len]u8 = undefined;
    seed_window(&window);
    const match_at = copy_position - gap_len - match_len;
    @memcpy(window[match_at..][0..match_len], window[match_at - copy_distance ..][0..match_len]);
    agree(&window, copy_len_min);
    buckets.init();
    commands.init();
    encoder_lazy.parse(true, &buckets, &window, 0, window.len, window.len, &commands);
    // The command whose copy starts at `copy_position`.
    var position: usize = 0;
    for (commands.commands[0..commands.count]) |command| {
        position += command.insert_len;
        if (position == copy_position) {
            try testing.expectEqual(copy_len_min, command.copy_len);
            try testing.expectEqual(0, command.distance_code());
            return;
        }
        position += encoder_commands.written_of(command);
    }
    return error.TestExpectedCopy;
}

/// The `agreed` octets at `copy_position` copy those `copy_distance` back, and the next differs.
fn agree(window: []u8, agreed: usize) void {
    const source = copy_position - copy_distance;
    @memcpy(window[copy_position..][0..agreed], window[source..][0..agreed]);
    window[copy_position + agreed] = ~window[source + agreed];
}

/// Seeded octets: none of 2 or more agree by chance at the last distance.
fn seed_window(window: []u8) void {
    var generator = codec.testing.split.Generator.init(copy_window_len);
    for (window) |*octet| octet.* = @truncate(generator.next());
}

const copy_window_len = 4096;
const copy_position = 3000;
const copy_distance = 700;
const match_len = 32;
const gap_len = 5;
/// 5 bits a literal, in eighths.
const cheap_literal_cost = 40;
