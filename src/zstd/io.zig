//! The Zstandard decoder behind Zig's `std.Io.Reader` interface, and the encoder behind its
//! `std.Io.Writer` (decision 56): HTTP's `zstd` coding (RFC 9659 §3). `codec.IoReader` and
//! `codec.IoWriter` say how each keeps its state when its source or its destination fails.

const codec = @import("codec");
const constants = @import("constants.zig");
const decoder = @import("decoder/decoder.zig");
const encoder = @import("encoder/encoder.zig");

/// The decoder of every frame of the coded octets, one after another, skippable frames among them
/// (RFC 8878 §3.1), with a window of at most `options.window_len_max` octets.
pub fn IoReader(comptime options: decoder.DecoderOptions) type {
    const Decoder = decoder.Decoder(options);
    return codec.IoReader(Decoder, decoder.Error, .{
        .init = Decoder.init,
        .decode = Decoder.decode,
        .after_done = .restart,
    });
}

/// The reader of the `zstd` content coding: a window of 2^23 octets (RFC 9659 §3, decision 12).
pub const HttpIoReader = IoReader(.{});

/// The encoder of one Zstandard frame at `options`. It holds back at most one block of input
/// between calls.
pub fn IoWriter(comptime options: encoder.EncoderOptions) type {
    return codec.IoWriter(encoder.Encoder(options), constants.block_len_max);
}

test {
    _ = @import("io_test.zig");
}
