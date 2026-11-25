//! Claim J11's strings of more than 16 octets (decision 16's JSON encoder token loop): a string's
//! octets go where its content goes as its run of plain ASCII is scanned (claims J1 and J7), each
//! loaded once, as encoder_loop.zig's `copy_plain_short` takes a shorter string's. Scanned and
//! then copied, a megabyte of plain ASCII came through the cache twice (design §8 step 18).
//!
//! The loop takes a string of up to 32 octets where it stands, as its first and its last 16. A
//! longer one goes out of line past its first 16, to plain_copy.zig's blocks. A string that holds
//! a stop is left to encoder_loop_string.zig's walk, which writes it again from its start.
//!
//! Each function reads and writes the slices it is given, whose bounds Zig checks (ReleaseSafe),
//! as scan.zig's scans do: they keep their checks when a caller turns the token loop's off
//! (decision 35).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const scan = @import("../../scan.zig");
const wide = @import("../../wide.zig");
const plain_copy = @import("../../plain_copy.zig");

const Block = scan.Block;

/// The octets of a string the loop takes where it stands, as two blocks of 16 that overlap.
const inline_blocks = 2;
pub const inline_len_max = inline_blocks * constants.vector_len;

/// Copies `source`, of more than 16 octets, into `destination`, of the same length, and returns
/// the run of plain ASCII that starts it, which is `scan.plain_len_scalar`'s. It copies that run
/// at the least: past it, `destination` holds octets of `source` or what it held.
pub inline fn copy_plain(level: wide.Level, destination: []u8, source: []const u8) usize {
    const first_len = constants.vector_len;
    const len = source.len;
    assert(len > first_len);
    assert(destination.len == len);
    if (len > inline_len_max) {
        if (plain_copy.copy_block(first_len, destination[0..first_len], source[0..first_len])) |lane| return lane;
        return plain_copy.copy_from(level, destination, source, first_len);
    }
    // Up to 32 octets: the first 16 and the last 16 cover them, and overlap.
    const last = len - first_len;
    const first: Block(first_len) = source[0..first_len].*;
    const end: Block(first_len) = source[last..][0..first_len].*;
    destination[0..first_len].* = first;
    destination[last..][0..first_len].* = end;
    const first_stops = plain_copy.block_stops(first_len, first);
    const end_stops = plain_copy.block_stops(first_len, end);
    if (!scan.any(first_len, first_stops | end_stops)) return len;
    if (scan.any(first_len, first_stops)) return scan.first_lane(first_len, first_stops);
    return last + scan.first_lane(first_len, end_stops);
}
