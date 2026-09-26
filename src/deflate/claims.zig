//! Decision 14's claims for the DEFLATE decoder's fast path, each switchable at comptime, so the
//! benchmark can time the decoder with one claim off against the decoder with all on (design §8
//! step 7). A claim that does not win by more than the noise leaves with its code. `decode` takes
//! every claim on; only the benchmark and the tests switch one off.

const constants = @import("constants.zig");

pub const Claims = struct {
    /// S1: the bit buffer refilled with one 8-octet load and no loop. Off, the fast path takes an
    /// octet at a time, as the checked path does.
    word_refill: bool = true,
    /// S2: the widths of the literal/length and distance tables. The A/B narrows them to
    /// `narrow_literal_length_table_bits` and `narrow_distance_table_bits`, and a longer code then
    /// takes the canonical decode.
    literal_length_table_bits: u4 = constants.literal_length_table_bits,
    distance_table_bits: u4 = constants.distance_table_bits,
    /// S4: match copies of 8 or 16 octets at a time. Off, a match is copied an octet at a time.
    chunk_copies: bool = true,
    /// S5: the window takes the call's last 32 KiB once. Off, it takes every octet the fast path
    /// wrote, as decoding into the window and copying out would.
    window_once: bool = true,
    /// S7: the fixed codes' tables built at comptime. Off, they are built for each fixed block.
    comptime_fixed_tables: bool = true,
};

/// Each claim off in turn, the A/Bs design §8 step 7 runs.
pub const each_off = [_]Claims{
    .{ .word_refill = false },
    .{ .literal_length_table_bits = constants.narrow_literal_length_table_bits, .distance_table_bits = constants.narrow_distance_table_bits },
    .{ .chunk_copies = false },
    .{ .window_once = false },
    .{ .comptime_fixed_tables = false },
};

/// The claim each entry of `each_off` switches off, as decision 14 numbers it.
pub const each_off_names = [each_off.len][]const u8{
    "S1 word refill",
    "S2 11- and 8-bit tables",
    "S4 chunk copies",
    "S5 one window copy",
    "S7 comptime fixed tables",
};
