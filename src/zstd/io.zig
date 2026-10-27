//! The Zstandard decoder behind Zig's `std.Io.Reader` interface (decision 56): HTTP's `zstd`
//! coding (RFC 9659 §3). `codec.IoReader` says how it keeps its state when its source fails. The
//! encoder's `std.Io.Writer` waits for the encoder, design §8 step 13.

const codec = @import("codec");
const decoder = @import("decoder/decoder.zig");

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

test {
    _ = @import("io_test.zig");
}
