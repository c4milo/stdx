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
    /// S11: a length and its distance's code in one literal/length entry, when both fit its index,
    /// so one lookup decodes both. Off, each takes its own table's lookup. It needs S12.
    combined_entries: bool = true,
    /// S12: a length's extra bits in its literal/length entry, when the code and the extra bits fit
    /// the table, so the fast path reads none for most matches. Off, every table builds plain.
    resolved_lengths: bool = true,
    /// S13: a dynamic block's code lengths read by a loop of their own, the code length code by
    /// one lookup in a table. Off, the checked steps read every length, a bit of its code at a
    /// time.
    code_lengths_loop: bool = true,
    /// S14: a dynamic block's two codes built from what the read of its lengths counted and
    /// listed, so a build passes over the symbols with a code alone. Off, each build passes
    /// over every length twice.
    tallied_codes: bool = true,
    /// S15: the tail loop refills with one 8-octet load while 8 octets of input remain, and copies
    /// a match in chunks while the room holds what the copy stores (decision 16). Off, it takes
    /// and copies an octet at a time. The refill needs S1, and the copy S4.
    wide_tail: bool = true,
};

/// Each claim off in turn, the A/Bs design §8 step 7 runs.
pub const each_off = [_]Claims{
    .{ .word_refill = false },
    .{ .literal_length_table_bits = constants.narrow_literal_length_table_bits, .distance_table_bits = constants.narrow_distance_table_bits },
    .{ .chunk_copies = false },
    .{ .window_once = false },
    .{ .comptime_fixed_tables = false },
    .{ .combined_entries = false },
    .{ .resolved_lengths = false },
    .{ .code_lengths_loop = false },
    .{ .tallied_codes = false },
    .{ .wide_tail = false },
};

/// The claim each entry of `each_off` switches off, as decision 14 numbers it.
pub const each_off_names = [each_off.len][]const u8{
    "S1 word refill",
    "S2 11- and 8-bit tables",
    "S4 chunk copies",
    "S5 one window copy",
    "S7 comptime fixed tables",
    "S11 combined entries",
    "S12 resolved lengths",
    "S13 code lengths' loop",
    "S14 tallied codes",
    "S15 tail's words and chunks",
};
