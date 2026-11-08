//! The brotli decoder behind Zig's `std.Io.Reader` interface (decision 56): HTTP's `br` coding
//! (RFC 7932). `codec.IoReader` says how it keeps its state when its source fails. The
//! encoder's `std.Io.Writer` waits for the encoder, design §8 step 14.

const codec = @import("codec");
const decoder = @import("decoder/decoder.zig");

/// The decoder of one brotli stream, with a window of at most 2^`options.window_bits_max` octets.
/// Octets after the stream's last meta-block are refused as `error.TrailingOctets`.
pub fn IoReader(comptime options: decoder.DecoderOptions) type {
    return codec.IoReader(decoder.Decoder(options), decoder.Error, .refuse);
}

/// The reader of the `br` content coding: WBITS up to 24 (RFC 7932 §9.1, decision 12).
pub const HttpIoReader = IoReader(.{});

test {
    _ = @import("io_test.zig");
}
