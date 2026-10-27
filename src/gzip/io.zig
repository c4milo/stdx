//! The gzip decoder behind Zig's `std.Io.Reader` interface, and the encoder behind its
//! `std.Io.Writer` (decision 56): HTTP's `gzip` coding (RFC 9110 §8.4.1.3). `codec.IoReader` and
//! `codec.IoWriter` say how each keeps its state when its source or its destination fails.

const codec = @import("codec");
const deflate = @import("deflate");
const decoder = @import("decoder.zig");
const encoder = @import("encoder.zig");

/// The decoder of every member of a gzip file, one after another (RFC 1952 §2.2). Octets after a
/// member that do not start another fail that member's header check, as in `decode_all`.
pub const IoReader = codec.IoReader(decoder.Decoder, decoder.Error, .{
    .init = decoder.init,
    .decode = decoder.decode,
    .after_done = .restart,
});

/// The encoder of one gzip member at `options`. It holds back at most the DEFLATE encoder's window
/// of input between calls.
pub fn IoWriter(comptime options: deflate.EncoderOptions) type {
    return codec.IoWriter(encoder.Encoder(options), deflate.constants.encoder_window_len);
}

test {
    _ = @import("io_test.zig");
}
