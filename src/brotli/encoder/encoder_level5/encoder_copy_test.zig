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
const best = encoder_lazy.best;
const saving = encoder_lazy.saving;
const copy_len_min = encoder_lazy.copy_len_min;
const min_len = encoder_lazy.min_len;

test "a search finds a copy at the last distance of the 2 or 3 octets that agree where they save" {
    try @call(.never_inline, expect_last_copy, .{});
}

/// Seeded octets with no match: the search's one candidate is the copy at the last distance.
fn expect_last_copy() !void {
    var buckets: Buckets = undefined;
    var commands: encoder_commands.WideCommands = undefined;
    var window: [copy_window_len]u8 = undefined;
    commands.init();
    commands.last_distances[0] = copy_distance;
    const cost = constants.encoder_literal_cost_initial;
    // 0 to 3 octets agree: fewer than 2 give no copy.
    for (0..min_len) |agreed| {
        seed_window(&window);
        agree(&window, copy_position, copy_distance, agreed);
        buckets.init();
        const found = best(true, &buckets, &window, copy_position, window.len, window.len, &commands);
        if (agreed < copy_len_min) {
            try testing.expectEqual(null, found);
            continue;
        }
        try testing.expectEqual(copy_position, found.?.position);
        try testing.expectEqual(agreed, found.?.len);
        try testing.expectEqual(copy_distance, found.?.offset);
        try testing.expectEqual(saving(agreed, copy_distance, true, cost), found.?.saves);
    }
    // At 5 bits a literal, 2 octets save less than a command costs, and 3 more.
    commands.literal_cost = cheap_literal_cost;
    seed_window(&window);
    agree(&window, copy_position, copy_distance, copy_len_min);
    buckets.init();
    try testing.expectEqual(null, best(true, &buckets, &window, copy_position, window.len, window.len, &commands));
    agree(&window, copy_position, copy_distance, min_len - 1);
    buckets.init();
    try testing.expectEqual(min_len - 1, best(true, &buckets, &window, copy_position, window.len, window.len, &commands).?.len);
    // A reach one octet short, and a distance to position 0, name no copy.
    buckets.init();
    try testing.expectEqual(null, best(true, &buckets, &window, copy_position, window.len, copy_distance - 1, &commands));
    commands.last_distances[0] = copy_position;
    @memcpy(window[copy_position..][0..copy_len_min], window[0..copy_len_min]);
    buckets.init();
    try testing.expectEqual(null, best(true, &buckets, &window, copy_position, window.len, window.len, &commands));
}

test "the parse codes a copy of 2 octets at the last distance where no match is found" {
    try @call(.never_inline, expect_parsed_copy, .{});
}

/// A match of `match_len` octets `parse_distance` back sets the last distance; then, after
/// `gap_len` literals, 2 octets agree at that distance and the third does not. All of it lies in
/// the first 2^`skip_log` octets, where the parse searches every position. The copy's second
/// position joins the buckets, so the 8 octets from it found again `repeat_back` octets later
/// are a match.
fn expect_parsed_copy() !void {
    var buckets: Buckets = undefined;
    var commands: encoder_commands.WideCommands = undefined;
    var window: [copy_window_len]u8 = undefined;
    seed_window(&window);
    @memcpy(window[parse_match_at..][0..match_len], window[parse_match_at - parse_distance ..][0..match_len]);
    agree(&window, parse_copy_at, parse_distance, copy_len_min);
    const covered = parse_copy_at + 1;
    @memcpy(window[covered + repeat_back ..][0..repeat_len], window[covered..][0..repeat_len]);
    buckets.init();
    commands.init();
    encoder_lazy.parse(true, &buckets, &window, 0, window.len, window.len, &commands);
    // The command whose copy starts at `parse_copy_at`, and the repeat of the covered position.
    var position: usize = 0;
    var copied = false;
    var repeated = false;
    for (commands.commands[0..commands.count]) |command| {
        position += command.insert_len;
        if (position == parse_copy_at) {
            try testing.expectEqual(copy_len_min, command.copy_len);
            try testing.expectEqual(0, command.distance_code());
            copied = true;
        }
        if (position == covered + repeat_back) {
            try testing.expect(command.copy_len >= repeat_len);
            repeated = true;
        }
        position += encoder_commands.written_of(command);
    }
    try testing.expect(copied and repeated);
}

/// The `agreed` octets at `position` copy those `distance` back, and the next differs.
fn agree(window: []u8, position: usize, distance: usize, agreed: usize) void {
    const source = position - distance;
    @memcpy(window[position..][0..agreed], window[source..][0..agreed]);
    window[position + agreed] = ~window[source + agreed];
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
const parse_distance = 90;
const parse_match_at = 100;
const parse_copy_at = parse_match_at + match_len + gap_len;
/// The 8 octets from the copy's second position, found again this far on.
const repeat_back = 60;
const repeat_len = 8;

comptime {
    std.debug.assert(parse_copy_at + 1 + repeat_back + repeat_len < 1 << constants.encoder_level5.skip_log);
}
/// 5 bits a literal, in eighths.
const cheap_literal_cost = 40;
