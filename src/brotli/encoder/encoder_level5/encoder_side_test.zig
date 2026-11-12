//! The tests of the side table in level 5's search (decision 66, the finder's forms): a match of 4
//! octets the buckets' hash of 5 octets misses, and the bucket's match kept where it gives one.

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
const min_len = encoder_lazy.min_len;

test "a search finds a match of 4 octets through the side table" {
    try @call(.never_inline, expect_short_match, .{});
}

/// Seeded octets, and 4 of them from `short_source` again at `short_position`, the fifth
/// different: the bucket of 5 octets names no candidate there, and the side table names the source
/// while the reach holds it.
fn expect_short_match() !void {
    var buckets: Buckets = undefined;
    var commands: encoder_commands.WideCommands = undefined;
    var window: [side_window_len]u8 = undefined;
    seed_window(&window);
    @memcpy(window[short_position..][0..min_len], window[short_source..][0..min_len]);
    window[short_position + min_len] = ~window[short_source + min_len];
    commands.init();
    const source = Buckets.slot_of(true, &window, short_source);
    const here = Buckets.slot_of(true, &window, short_position);
    try testing.expect(source.bucket != here.bucket or source.check != here.check);
    // A reach one octet short of the source names no candidate.
    buckets.init();
    buckets.insert(true, &window, short_source);
    try testing.expectEqual(null, best(true, &buckets, &window, short_position, window.len, short_position - short_source - 1, &commands));
    buckets.init();
    buckets.insert(true, &window, short_source);
    const found = best(true, &buckets, &window, short_position, window.len, window.len, &commands).?;
    try testing.expectEqual(short_position, found.position);
    try testing.expectEqual(min_len, found.len);
    try testing.expectEqual(short_position - short_source, found.offset);
    try testing.expectEqual(saving(min_len, short_position - short_source, false, constants.encoder_literal_cost_initial), found.saves);
    try testing.expectEqual(0, found.word_len);
}

test "a search keeps the bucket's match where the side table's candidate saves more" {
    try @call(.never_inline, expect_bucket_kept, .{});
}

/// 5 octets from `far_source` again at `kept_position`, and 4 of them `near_back` octets before
/// it, the fifth different. The near 4 save more than the far 5, and the side table names the
/// near ones. The search weighs the side table only where the bucket gives no match, so it must
/// give the far 5.
fn expect_bucket_kept() !void {
    var buckets: Buckets = undefined;
    var commands: encoder_commands.WideCommands = undefined;
    var window: [side_window_len]u8 = undefined;
    seed_window(&window);
    const hash_len = constants.encoder_level5.hash_len;
    const near_source = kept_position - near_back;
    @memcpy(window[kept_position..][0..hash_len], window[far_source..][0..hash_len]);
    window[kept_position + hash_len] = ~window[far_source + hash_len];
    @memcpy(window[near_source..][0..min_len], window[far_source..][0..min_len]);
    window[near_source + min_len] = ~window[far_source + min_len];
    const cost = constants.encoder_literal_cost_initial;
    const far_saves = saving(hash_len, kept_position - far_source, false, cost);
    try testing.expect(far_saves > 0 and saving(min_len, near_back, false, cost) > far_saves);
    buckets.init();
    commands.init();
    buckets.insert(true, &window, far_source);
    buckets.insert(true, &window, near_source);
    const here = Buckets.slot_of(true, &window, kept_position);
    try testing.expectEqual(near_source, buckets.side_candidate(here, 1, kept_position));
    const found = best(true, &buckets, &window, kept_position, window.len, window.len, &commands).?;
    try testing.expectEqual(hash_len, found.len);
    try testing.expectEqual(kept_position - far_source, found.offset);
    try testing.expectEqual(far_saves, found.saves);
}

/// Seeded octets: no 4 of them repeat by chance where the tests search.
fn seed_window(window: []u8) void {
    var generator = codec.testing.split.Generator.init(side_window_len);
    for (window) |*octet| octet.* = @truncate(generator.next());
}

const side_window_len = 8192;
const short_source = 1000;
const short_position = 3000;
/// A match 4096 octets back, whose distance takes 12 bits, against one 8 octets back, which
/// takes 3: the 9 bits between them are more than the one literal the near match lacks saves.
const far_source = 2000;
const far_back = 4096;
const kept_position = far_source + far_back;
const near_back = 8;
