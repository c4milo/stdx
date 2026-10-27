//! The zlib decoder behind Zig's `std.Io.Reader` interface, and the encoder behind its
//! `std.Io.Writer` (decision 56): HTTP's `deflate` coding (RFC 9110 §8.4.1.2). `codec.IoReader`
//! and `codec.IoWriter` say how each keeps its state when its source or its destination fails.

const codec = @import("codec");
const deflate = @import("deflate");
const decoder = @import("decoder.zig");
const encoder = @import("encoder.zig");

/// The decoder of one zlib stream. Octets after its ADLER32 are refused as
/// `error.TrailingOctets`.
pub const IoReader = codec.IoReader(decoder.Decoder, decoder.Error, .{
    .init = decoder.init,
    .decode = decoder.decode,
    .after_done = .refuse,
});

/// The encoder of one zlib stream at `options`. It holds back at most the DEFLATE encoder's window
/// of input between calls.
pub fn IoWriter(comptime options: deflate.EncoderOptions) type {
    return codec.IoWriter(encoder.Encoder(options), deflate.constants.encoder_window_len);
}

test {
    _ = @import("io_test.zig");
}
