//! Decision 27's claims for the `json` module's vector paths, decision 30's for their widths, and
//! decision 31's for its fast paths, each switchable at comptime, so the benchmark can time the
//! encoder and the decoder with one claim off against all on (decision 21). A claim that does not
//! win by more than the noise leaves with its code. `encode` and `decode` take every vector claim
//! on where the target's vector registers hold `constants.vector_len` octets
//! (`constants.vectors`), and the other claims on every target; the tests, the fuzzer and the
//! benchmark switch them.

const std = @import("std");
const builtin = @import("builtin");
const constants = @import("constants.zig");

pub const Claims = struct {
    /// J1: the encoder finds the run of a name's or a string's octets that need no escape a vector
    /// at a time. Off, it takes them an octet at a time.
    encoder_string_vectors: bool = constants.vectors,
    /// J2: the encoder writes the digits of a hex string a vector of octets at a time.
    hex_vectors: bool = constants.vectors,
    /// J3: the decoder finds the run of a name's or a string's octets up to the next quotation mark,
    /// reverse solidus, control character or non-ASCII octet a vector at a time.
    decoder_string_vectors: bool = constants.vectors,
    /// J5: where J1's or J3's run stops at a non-ASCII octet, UTF-8 is validated a vector at a
    /// time, so the run goes on past non-ASCII characters. Off, each non-ASCII character takes the
    /// scalar validation of `utf8.zig`. It starts only there, past the escapes and the delimiters,
    /// so text of ASCII runs what it runs with J5 off.
    ///
    /// J4, whitespace skipped a vector at a time, left with its code (decision 27, design §8 step
    /// 16): the runs that measured it carried a fault of the benchmark's, and none shows it faster.
    utf8_vectors: bool = constants.vectors,
    /// J7: the vector paths of J1, J2 and J3 take AVX2's 32 octets on x86-64 when the caller's CPU
    /// features allow it, in a variant object of their own (decision 30, wide.zig). Off, they take
    /// 16 octets whatever the features. J5's stays at 16.
    wide_vectors: bool = true,
    /// J8: the decoder takes the next token in one straight line when the input holds all of it and
    /// the output has room for its octets (decision 31). Off, every token takes the checked path.
    decoder_fast_path: bool = true,
    /// J10: a batch takes its tokens in decision 16's JSON decoder token loop, straight from the
    /// input slice into the output slice (decision 33, decoder_loop.zig). Off, each takes the path
    /// one token a call takes.
    decoder_token_loop: bool = true,
    /// J12: J10's loop takes two `\u` escapes that follow each other at once, their reverse solidi
    /// and `u`s checked in one word and their eight hexadecimal digits turned into two code units in
    /// another. Off, it takes each escape alone, a digit at a time.
    decoder_escape_words: bool = true,
    /// J9: the encoder writes a token in one straight line when the call's input holds all of it
    /// and the output has room for every octet it writes (decision 31). Off, every token takes the
    /// checked path.
    encoder_fast_path: bool = true,
    /// J11: a batch writes its items in decision 16's JSON encoder token loop, straight into the
    /// output slice (decision 33, encoder_loop.zig). Off, each takes the path one token a call
    /// takes.
    encoder_token_loop: bool = true,
    /// Claim J11's loop keeps Zig's runtime safety checks, as the rest of a ReleaseSafe build does.
    /// A caller may set it false in the claims it passes `Encoder.encode_batch_with`: that call
    /// site then runs every function of encoder_loop.zig and encoder_loop_string.zig with the
    /// checks off, which encoded CLDR's texts and qlog's records 5% to 9% faster on the N2 and the
    /// EPYC 9V45 (decision 35). A test build and a Debug build keep the checks whatever it says.
    /// The caller's choice, and not a claim: every A/B keeps it true.
    encoder_token_loop_runtime_safety: bool = true,
};

/// Whether a build keeps runtime safety on whatever a caller chose: a test build, the fuzzer's
/// included, and a Debug build do (decision 35). A function whose checks the caller may turn off
/// starts with `@setRuntimeSafety(claims.encoder_token_loop_runtime_safety or
/// runtime_safety_kept)`: a field and a constant, which cost the compiler no call at each of the
/// loop's inlined functions.
pub const runtime_safety_kept = runtime_safety_kept_in(builtin.is_test, builtin.mode);

fn runtime_safety_kept_in(is_test: bool, mode: std.builtin.OptimizeMode) bool {
    return is_test or mode == .Debug;
}

test "runtime safety stays on unless the caller turns it off, and in a test or a Debug build" {
    try std.testing.expect((Claims{}).encoder_token_loop_runtime_safety);
    try std.testing.expect(runtime_safety_kept);
    try std.testing.expect(!runtime_safety_kept_in(false, .ReleaseSafe));
    try std.testing.expect(runtime_safety_kept_in(true, .ReleaseSafe));
    try std.testing.expect(runtime_safety_kept_in(false, .Debug));
}

/// Every claim off: the scalar and checked paths alone, the reference every vector path and each
/// fast path must match.
pub const scalar: Claims = .{
    .encoder_string_vectors = false,
    .hex_vectors = false,
    .decoder_string_vectors = false,
    .utf8_vectors = false,
    .wide_vectors = false,
    .decoder_fast_path = false,
    .decoder_token_loop = false,
    .encoder_fast_path = false,
    .encoder_token_loop = false,
    .decoder_escape_words = false,
};

/// Every claim on, whatever the target: what the tests run beside `scalar`.
pub const vector: Claims = .{
    .encoder_string_vectors = true,
    .hex_vectors = true,
    .decoder_string_vectors = true,
    .utf8_vectors = true,
    .wide_vectors = true,
    .decoder_fast_path = true,
    .decoder_token_loop = true,
    .encoder_fast_path = true,
    .encoder_token_loop = true,
    .decoder_escape_words = true,
};

/// Each claim off in turn, the A/Bs the benchmark runs.
pub const each_off = [_]Claims{
    .{ .encoder_string_vectors = false },
    .{ .hex_vectors = false },
    .{ .decoder_string_vectors = false },
    .{ .utf8_vectors = false },
    .{ .wide_vectors = false },
    .{ .decoder_fast_path = false },
    .{ .encoder_fast_path = false },
    .{ .decoder_token_loop = false },
    .{ .encoder_token_loop = false },
    .{ .decoder_escape_words = false },
};

/// The claim each entry of `each_off` switches off, as decisions 27, 30 and 31 number them.
pub const each_off_names = [each_off.len][]const u8{
    "J1 encoder string vectors",
    "J2 hex vectors",
    "J3 decoder string vectors",
    "J5 UTF-8 vectors",
    "J7 wide vectors",
    "J8 decoder fast path",
    "J9 encoder fast path",
    "J10 decoder token loop",
    "J11 encoder token loop",
    "J12 decoder escape words",
};
