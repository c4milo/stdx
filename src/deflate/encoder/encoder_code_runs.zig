//! The run-length coding of a dynamic block's code lengths with symbols 16, 17 and 18 (RFC 1951
//! §3.2.7): a run of zeros as 17 or 18, a run of one length as the length and 16, and the rest one
//! symbol each. One pass finds each run's end and writes its items, counting each symbol as it
//! goes, so the code length code is built from the counts without a pass over the items.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");

/// One symbol of the code length alphabet, and the value of its extra bits (RFC 1951 §3.2.7).
pub const Item = struct {
    symbol: u8,
    extra: u8 = 0,
};

/// The most items a dynamic header's code lengths take: one for each length.
pub const items_max = constants.literal_length_used + constants.distance_used;

/// How often each code length symbol occurs among a header's items.
pub const Counts = [constants.code_length_alphabet_len]u16;

/// The shortest run a repeat symbol takes (RFC 1951 §3.2.7): 3, for symbols 16 and 17.
const repeat_run_min = @min(constants.repeat_count_min[0], constants.repeat_count_min[constants.repeat_zero_short - constants.repeat_previous]);

/// The lengths one compare of `run_lengths` takes.
const scan_vector_len = 16;

/// A value no code length takes, which ends the last run.
const no_length = std.math.maxInt(u8);

/// The compares `run_lengths` makes at most: one for each `scan_vector_len` lengths.
const scans_max = items_max / scan_vector_len + 1;

comptime {
    assert(no_length > constants.code_len_max);
}

/// Writes `first` and then `second` as one sequence of code length symbols (RFC 1951 §3.2.7), and
/// sets `counts` to how often each symbol occurs among them. A run may cross from `first` into
/// `second`, as §3.2.7 lets it cross from the literal and length lengths into the distance
/// lengths. Returns how many items.
///
/// One compare of `scan_vector_len` lengths with the `scan_vector_len` after them marks where runs
/// end, so a long run costs a compare and no step a length: Zig 0.16 turns no loop into vector
/// code, so the vectors are written out.
pub fn run_lengths(first: []const u8, second: []const u8, items: *[items_max]Item, counts: *Counts) usize {
    const total = first.len + second.len;
    assert(total > 0 and total <= items_max);
    // Both tables as one sequence, and after them a value no length takes, so that the last run
    // ends where the sequence does and no compare reads past the array.
    var lengths: [items_max + 1 + scan_vector_len]u8 = undefined;
    @memcpy(lengths[0..first.len], first);
    @memcpy(lengths[first.len..total], second);
    @memset(lengths[total..][0 .. 1 + scan_vector_len], no_length);
    counts.* = @splat(0);
    const Lengths = @Vector(scan_vector_len, u8);
    var count: usize = 0;
    var run_start: usize = 0;
    var base: usize = 0;
    for (0..scans_max) |_| {
        if (base >= total) break;
        const here: Lengths = lengths[base..][0..scan_vector_len].*;
        const after: Lengths = lengths[base + 1 ..][0..scan_vector_len].*;
        // A bit for each length that the next one differs from: a run's last.
        var ends: std.meta.Int(.unsigned, scan_vector_len) = @bitCast(here != after);
        for (0..scan_vector_len) |_| {
            if (ends == 0) break;
            const end = base + @ctz(ends);
            ends &= ends - 1;
            count += run_items(lengths[end], end + 1 - run_start, items[count..], counts);
            run_start = end + 1;
        }
        base += scan_vector_len;
    }
    assert(run_start == total);
    return count;
}

/// Writes a run of `run` lengths `len` as items, counts their symbols, and returns how many.
inline fn run_items(len: u8, run: usize, items: []Item, counts: *Counts) usize {
    // Most runs are too short for a repeat: each length is its own item.
    if (run < repeat_run_min) {
        for (items[0..run]) |*item| item.* = .{ .symbol = len };
        counts[len] += @intCast(run);
        return run;
    }
    return repeat_items(len, run, items, counts);
}

/// `run_items` for a run a repeat symbol may take.
fn repeat_items(len: u8, run: usize, items: []Item, counts: *Counts) align(constants.hot_function_alignment) usize {
    var left = run;
    var count: usize = 0;
    if (len != 0) {
        // Symbol 16 repeats the length before it, so the run's first length is its own item.
        items[0] = .{ .symbol = len };
        counts[len] += 1;
        left -= 1;
        count = 1;
    }
    for (0..run) |_| {
        const repeat = repeat_for(len, left) orelse break;
        const kind = repeat - constants.repeat_previous;
        const taken = @min(left, constants.repeat_count_max[kind]);
        items[count] = .{ .symbol = repeat, .extra = @intCast(taken - constants.repeat_count_min[kind]) };
        counts[repeat] += 1;
        count += 1;
        left -= taken;
    }
    for (items[count..][0..left]) |*item| item.* = .{ .symbol = len };
    counts[len] += @intCast(left);
    return count + left;
}

/// The repeat symbol for `left` more lengths `len`, or null when too few are left for one
/// (RFC 1951 §3.2.7).
fn repeat_for(len: u8, left: usize) ?u8 {
    if (len != 0) return if (left >= constants.repeat_count_min[0]) constants.repeat_previous else null;
    const long = constants.repeat_zero_long - constants.repeat_previous;
    const short = constants.repeat_zero_short - constants.repeat_previous;
    if (left >= constants.repeat_count_min[long]) return constants.repeat_zero_long;
    if (left >= constants.repeat_count_min[short]) return constants.repeat_zero_short;
    return null;
}
