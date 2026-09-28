//! Decision 27's claims for the `json` module's vector paths, each switchable at comptime, so the
//! benchmark can time the encoder and the decoder with one claim off against all on (decision 21).
//! A claim that does not win by more than the noise leaves with its code. `encode` and `decode`
//! take every claim on where the target has vector registers; the tests, the fuzzer and the
//! benchmark switch them.

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
    /// J4: the decoder skips whitespace a vector at a time.
    whitespace_vectors: bool = constants.vectors,
    /// J5: in the runs J1 and J3 find, UTF-8 is validated a vector at a time, so a run goes on past
    /// non-ASCII characters. Off, each non-ASCII character takes the scalar validation of
    /// `utf8.zig`.
    utf8_vectors: bool = constants.vectors,
};

/// Every claim off: the scalar paths alone, the reference every vector path must match.
pub const scalar: Claims = .{
    .encoder_string_vectors = false,
    .hex_vectors = false,
    .decoder_string_vectors = false,
    .whitespace_vectors = false,
    .utf8_vectors = false,
};

/// Every claim on, whatever the target: what the tests run beside `scalar`.
pub const vector: Claims = .{
    .encoder_string_vectors = true,
    .hex_vectors = true,
    .decoder_string_vectors = true,
    .whitespace_vectors = true,
    .utf8_vectors = true,
};

/// Each claim off in turn, the A/Bs the benchmark runs.
pub const each_off = [_]Claims{
    .{ .encoder_string_vectors = false },
    .{ .hex_vectors = false },
    .{ .decoder_string_vectors = false },
    .{ .whitespace_vectors = false },
    .{ .utf8_vectors = false },
};

/// The claim each entry of `each_off` switches off, as decision 27 numbers it.
pub const each_off_names = [each_off.len][]const u8{
    "J1 encoder string vectors",
    "J2 hex vectors",
    "J3 decoder string vectors",
    "J4 whitespace vectors",
    "J5 UTF-8 vectors",
};
