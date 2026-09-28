//! Decision 16's fast path for the brotli decoder and the claims within it, each switchable at
//! comptime, so the benchmark can time the decoder with one claim off against the decoder with all
//! on (design §8 step 12). A claim that does not win by more than the noise leaves with its code.
//! The decoder takes every claim on; only the benchmark and the tests switch one off.

pub const Claims = struct {
    /// As S1 for DEFLATE: the fast path refills its 64-bit bit buffer with one 8-octet load and no
    /// loop. Off, it takes an octet at a time, as the checked path does.
    word_refill: bool = true,
    /// S4, which decision 16 names for brotli's match copy: a copy moves 16 or 8 octets at a time,
    /// overrunning into the room the margin leaves. Off, it moves an octet at a time.
    chunk_copies: bool = true,
};

/// Each claim off in turn, the A/Bs design §8 step 12 runs.
pub const each_off = [_]Claims{
    .{ .word_refill = false },
    .{ .chunk_copies = false },
};

/// The claim each entry of `each_off` switches off, as decision 14 numbers it.
pub const each_off_names = [each_off.len][]const u8{
    "S1 word refill",
    "S4 chunk copies",
};

/// The paths a decoder takes: the fast path of decision 16 while its margins hold, and the claims
/// within it. The tests and the fuzzer build both settings and compare them.
pub const Paths = struct {
    fast_paths: bool = true,
    claims: Claims = .{},
};
