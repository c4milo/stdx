//! The DEFLATE decoder behind Zig's `std.Io.Reader` interface, and the encoder behind its
//! `std.Io.Writer` (decision 56). `codec.IoReader` and `codec.IoWriter` say how each keeps its
//! state when its source or its destination fails.

const codec = @import("codec");
const constants = @import("constants.zig");
const decoder = @import("decoder/decoder.zig");
const encoder = @import("encoder/encoder.zig");

/// The decoder of one raw DEFLATE stream. Octets after the stream's last block are refused as
/// `error.TrailingOctets`.
pub const IoReader = codec.IoReader(decoder.Decoder, decoder.Error, .{
    .init = decoder.init,
    .decode = decoder.decode,
    .after_done = .refuse,
});

/// The encoder of one raw DEFLATE stream at `options`. It holds back at most its window of input
/// between calls.
pub fn IoWriter(comptime options: encoder.EncoderOptions) type {
    return codec.IoWriter(encoder.Encoder(options), constants.encoder_window_len);
}

test {
    _ = @import("io_test.zig");
}
