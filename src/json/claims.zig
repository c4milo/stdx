//! Decision 27's claims for the `json` module's vector paths, and decision 30's for its fast paths,
//! each switchable at comptime, so the benchmark can time the encoder and the decoder with one
//! claim off against all on (decision 21). A claim that does not win by more than the noise leaves
//! with its code. `encode` and `decode` take every vector claim on where the target's vector
//! registers hold `constants.vector_len` octets (`constants.vectors`), and the fast paths on every
//! target; the tests, the fuzzer and the benchmark switch them.

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
    /// J8: the decoder takes the next token in one straight line when the input holds all of it and
    /// the output has room for its octets (decision 30). Off, every token takes the checked path.
    decoder_fast_path: bool = true,
    /// J9: the encoder writes a token in one straight line when the call's input holds all of it
    /// and the output has room for every octet it writes (decision 30). Off, every token takes the
    /// checked path.
    encoder_fast_path: bool = true,
};

/// Every claim off: the scalar and checked paths alone, the reference every vector path and each
/// fast path must match.
pub const scalar: Claims = .{
    .encoder_string_vectors = false,
    .hex_vectors = false,
    .decoder_string_vectors = false,
    .utf8_vectors = false,
    .decoder_fast_path = false,
    .encoder_fast_path = false,
};

/// Every claim on, whatever the target: what the tests run beside `scalar`.
pub const vector: Claims = .{
    .encoder_string_vectors = true,
    .hex_vectors = true,
    .decoder_string_vectors = true,
    .utf8_vectors = true,
    .decoder_fast_path = true,
    .encoder_fast_path = true,
};

/// Each claim off in turn, the A/Bs the benchmark runs.
pub const each_off = [_]Claims{
    .{ .encoder_string_vectors = false },
    .{ .hex_vectors = false },
    .{ .decoder_string_vectors = false },
    .{ .utf8_vectors = false },
    .{ .decoder_fast_path = false },
    .{ .encoder_fast_path = false },
};

/// The claim each entry of `each_off` switches off, as decisions 27 and 30 number them.
pub const each_off_names = [each_off.len][]const u8{
    "J1 encoder string vectors",
    "J2 hex vectors",
    "J3 decoder string vectors",
    "J5 UTF-8 vectors",
    "J8 decoder fast path",
    "J9 encoder fast path",
};
