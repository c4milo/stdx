//! The fast path's step for every symbol: a code longer than the table, a literal, the end of the
//! block, and a match from anywhere in the history, from a length's entry and its distance's, or
//! from a combined entry. The common loop of fast.zig leaves these to it out of line, and the tail
//! loop takes every symbol through it. Split from fast.zig.

const builtin = @import("builtin");
const constants = @import("constants.zig");
const lookup = @import("lookup.zig");
const fast = @import("fast.zig");
const fast_copy = @import("fast_copy.zig");
const options_module = @import("options.zig");
const Options = options_module.Options;
const How = options_module.How;
const Loop = fast.Loop;
const Mode = fast.Mode;
const Next = fast.Next;

/// Decodes one symbol, whose table entry is `first`, with its distance when it is a length, and
/// handles every case. Returns why the loop stops, or `go_on`.
pub inline fn step(comptime mode: Mode, comptime options: Options, loop: *Loop, codes: fast.Codes, history: fast.History, first: lookup.Entry) Next {
    var entry = first;
    var how: How = .table;
    if (entry.other == .long) {
        entry = lookup.resolve_literal_length(codes.literal_length_code, loop.buffer) orelse return .checked;
        how = .canonical;
    }
    if (entry.literal) {
        if (mode == .tail and loop.room() == 0) return .margin;
        if (options.count_lookups) fast.count_symbol(loop, how);
        loop.output[loop.written] = @truncate(entry.value);
        loop.written += 1;
        loop.consume_entry(entry);
        return .go_on;
    }
    if (entry.combined) return copy_combined_pair(mode, options, loop, history, entry);
    if (entry.direct) return copy_pair(mode, options, loop, codes, history, entry, how);
    if (entry.other != .end_of_block) return .checked;
    if (options.count_lookups) fast.count_symbol(loop, how);
    loop.consume_entry(entry);
    return .end_of_block;
}

/// The tail: a symbol at a time, while the input holds a whole pair's bits.
pub inline fn decode_tail(comptime options: Options, loop: *Loop, codes: fast.Codes, history: fast.History) fast.End {
    // Each iteration consumes at least a bit, or ends the loop.
    const iterations_max = @bitSizeOf(u8) * loop.rest.len + @bitSizeOf(u64) + 1;
    for (0..iterations_max) |_| {
        loop.refill_exact();
        // Near the input's end, the checked path decodes what is left, and asks for more.
        if (loop.count < constants.pair_bits_max) return .checked;
        const next = step(.tail, options, loop, codes, history, loop.look_up());
        if (next != .go_on) return next.end();
    }
    unreachable;
}

/// A decoded length/distance pair, and the bit buffer past both.
const Pair = struct {
    len: u64,
    distance: u64,
    /// The buffer past the pair's bits, and how many they are.
    after: u64,
    used_bits: u32,
    length_how: How,
    distance_how: How,
};

/// Reads a length's extra bits and its distance, and copies the match, or stops before using any
/// bit of the pair when the checked path must see it.
inline fn copy_pair(comptime mode: Mode, comptime options: Options, loop: *Loop, codes: fast.Codes, history: fast.History, length: lookup.Entry, how: How) Next {
    const len = fast.length_of(loop.buffer, length, loop.lengths_resolved) orelse return .checked;
    const after_length = fast.past(loop.buffer, length);
    var distance_entry = loop.look_up_distance(after_length);
    var distance_how: How = .table;
    if (!distance_entry.direct) {
        distance_entry = lookup.resolve_distance(codes.distance_code, distance_entry, after_length) orelse return .checked;
        distance_how = .canonical;
    }
    return copy_decoded(mode, options, loop, history, .{
        .len = len,
        .distance = distance_entry.value + fast.extra_value(after_length, distance_entry),
        .after = fast.past(after_length, distance_entry),
        .used_bits = @as(u32, length.used_bits) + distance_entry.used_bits,
        .length_how = how,
        .distance_how = distance_how,
    });
}

/// Copies the match a combined entry decodes, with its distance's extra bits after the entry's.
inline fn copy_combined_pair(comptime mode: Mode, comptime options: Options, loop: *Loop, history: fast.History, entry: lookup.Entry) Next {
    return copy_decoded(mode, options, loop, history, .{
        .len = entry.combined_length(),
        .distance = fast.combined_distance(loop.buffer, entry),
        .after = fast.past(loop.buffer, entry),
        .used_bits = entry.used_bits,
        .length_how = .table,
        .distance_how = .table,
    });
}

/// Copies a decoded pair's match from anywhere in the history, and uses the pair's bits, or stops
/// before using them: at a margin in the tail, or for a distance the checked path refuses.
inline fn copy_decoded(comptime mode: Mode, comptime options: Options, loop: *Loop, history: fast.History, pair: Pair) Next {
    // The tail copies a match whole or leaves it to the checked path, which copies what fits.
    if (mode == .tail and loop.room() < pair.len) return .margin;
    const window: fast_copy.Window = .{ .window = history.window, .synced = history.synced, .distance_max = history.distance_max };
    const chunked = mode == .wide and options.claims.chunk_copies;
    if (!fast_copy.copy_match(chunked, loop.output, loop.written, window, @intCast(pair.distance), @intCast(pair.len))) return .checked;
    loop.buffer = pair.after;
    loop.count -= pair.used_bits;
    loop.written += @intCast(pair.len);
    if (builtin.is_test) loop.decoded += constants.decodes_per_step_max;
    if (options.count_lookups) {
        fast.count_symbol(loop, pair.length_how);
        fast.count_symbol(loop, pair.distance_how);
    }
    return .go_on;
}
