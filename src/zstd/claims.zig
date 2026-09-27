//! Decision 14's claims for the Zstandard decoder's fast paths, each switchable at comptime, so the
//! benchmark can time the decoder with one claim off against the decoder with all on (design §8
//! step 11). A claim that does not win by more than the noise leaves with its code. The decoder
//! takes every claim on; only the benchmark and the tests switch one off.

pub const Claims = struct {
    /// Z4: literals and matches copied 16 octets at a time, overrunning into the room the margin
    /// leaves. Off, the fast path copies exactly, with `@memcpy` and octet by octet.
    chunk_copies: bool = true,
};

/// Each claim off in turn, the A/Bs design §8 step 11 runs.
pub const each_off = [_]Claims{
    .{ .chunk_copies = false },
};

/// The claim each entry of `each_off` switches off, as decision 14 numbers it.
pub const each_off_names = [each_off.len][]const u8{
    "Z4 chunk copies",
};

/// The paths a decoder takes: the fast paths of decision 16 while their margins hold, and the
/// claims within them. The tests and the fuzzer build both settings and compare them.
pub const Paths = struct {
    fast_paths: bool = true,
    claims: Claims = .{},
};
