//! Decision 14's claims for the Zstandard decoder's fast paths, each switchable at comptime, so the
//! benchmark can time the decoder with one claim off against the decoder with all on (design §8
//! step 11). A claim that does not win by more than the noise leaves with its code. The decoder
//! takes every claim on; only the benchmark and the tests switch one off.

pub const Claims = struct {
    /// Z1: the four Huffman-coded literal streams decoded in one loop, a load of each in turn. Off,
    /// the fast path decodes one stream after another.
    interleaved_streams: bool = true,
    /// Z2: a long section's literals decoded in pairs, a lookup giving the literals two codes that
    /// fit the table's width take together. Off, one literal a lookup.
    pairs: bool = true,
    /// Z4: literals and matches copied 16 octets at a time, overrunning into the room the margin
    /// leaves. Off, the fast path copies exactly: with `@memcpy`, with `codec.fill` for a run of
    /// one octet, and octet by octet.
    chunk_copies: bool = true,
    /// Z5: a compressed block the call's input holds whole decodes from the input, and moves into
    /// the state only when the output fills before the block ends. Off, every compressed block is
    /// copied into the state before it decodes.
    block_in_input: bool = true,
    /// Z6, as S5 for DEFLATE: the window takes a call's octets once, when the call ends, and none
    /// when the call ends the frame; history in between is read from the output. Off, each piece
    /// moves into the window as it is written.
    window_once: bool = true,
};

/// Each claim off in turn, the A/Bs design §8 step 11 runs.
pub const each_off = [_]Claims{
    .{ .interleaved_streams = false },
    .{ .pairs = false },
    .{ .chunk_copies = false },
    .{ .block_in_input = false },
    .{ .window_once = false },
};

/// The claim each entry of `each_off` switches off, as decision 14 numbers it.
pub const each_off_names = [each_off.len][]const u8{
    "Z1 interleaved streams",
    "Z2 pairs",
    "Z4 chunk copies",
    "Z5 block in input",
    "Z6 window once",
};

/// The paths a decoder takes: the fast paths of decision 16 while their margins hold, and the
/// claims within them. The tests and the fuzzer build both settings and compare them.
pub const Paths = struct {
    fast_paths: bool = true,
    claims: Claims = .{},
};
