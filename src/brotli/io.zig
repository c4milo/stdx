//! The brotli decoder behind Zig's `std.Io.Reader` interface, and the encoder behind its
//! `std.Io.Writer` (decision 56): HTTP's `br` coding (RFC 7932). `codec.IoReader` and
//! `codec.IoWriter` say how each keeps its state when its source or its destination fails.

const codec = @import("codec");
const decoder = @import("decoder/decoder.zig");
const encoder = @import("encoder/encoder.zig");

/// The decoder of one brotli stream, with a window of at most 2^`options.window_bits_max` octets.
/// Octets after the stream's last meta-block are refused as `error.TrailingOctets`.
pub fn IoReader(comptime options: decoder.DecoderOptions) type {
    return codec.IoReader(decoder.Decoder(options), decoder.Error, .refuse);
}

/// The reader of the `br` content coding: WBITS up to 24 (RFC 7932 §9.1, decision 12).
pub const HttpIoReader = IoReader(.{});

/// The encoder of one brotli stream at `options`. It holds back at most its window's slack of
/// input between calls: a meta-block at level 1, and 1 MiB at level 5.
pub fn IoWriter(comptime options: encoder.EncoderOptions) type {
    const Encoder = encoder.Encoder(options);
    return codec.IoWriter(Encoder, Encoder.slack_len);
}

test {
    _ = @import("io_test.zig");
}
