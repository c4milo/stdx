//! Decision 16's fast path for the brotli decoder and the claims within it, each switchable at
//! comptime, so the benchmark can time the decoder with one claim off against the decoder with all
//! on (design §8 step 12). A claim that does not win by more than the noise leaves with its code.
//! The decoder takes every claim on; only the benchmark and the tests switch one off. `loop_checks`
//! runs the other way: on for safety, its A/B prices what the checks cost.

pub const Claims = struct {
    /// As S1 for DEFLATE: the fast path refills its 64-bit bit buffer with one 8-octet load and no
    /// loop. Off, it takes an octet at a time, as the checked path does.
    word_refill: bool = true,
    /// S4, which decision 16 names for brotli's match copy: a copy moves 16 or 8 octets at a time,
    /// overrunning into the room the margin leaves. Off, it moves an octet at a time.
    chunk_copies: bool = true,
    /// As S5 for DEFLATE and Z6 for Zstandard: the window takes a call's octets once, when the call
    /// ends, and none when the call ends the stream; history in between is read from the output.
    /// Off, each octet goes into the window as the checked path writes it, and the fast path's when
    /// it returns.
    window_once: bool = true,
    /// Zig's safety checks in the command loop of decision 16. Off, the loop's functions run with
    /// `@setRuntimeSafety(false)`: the exception decision 16 admits only after an A/B on the
    /// runners and the owner's ruling, which this claim measures (design §8 step 12); the tests and
    /// the fuzzer compare that setting with the checked path too. The decoder takes it on.
    loop_checks: bool = true,
};

/// Each claim off in turn, the A/Bs design §8 step 12 runs.
pub const each_off = [_]Claims{
    .{ .word_refill = false },
    .{ .chunk_copies = false },
    .{ .window_once = false },
    .{ .loop_checks = false },
};

/// The claim each entry of `each_off` switches off, as decision 14 numbers it.
pub const each_off_names = [each_off.len][]const u8{
    "S1 word refill",
    "S4 chunk copies",
    "S5 window once",
    "loop checks",
};

/// The paths a decoder takes: the fast path of decision 16 while its margins hold, and the claims
/// within it. The tests and the fuzzer build both settings and compare them.
pub const Paths = struct {
    fast_paths: bool = true,
    claims: Claims = .{},
};
