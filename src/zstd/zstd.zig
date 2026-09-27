//! zstd: Zstandard, RFC 8878 as RFC 9659 updates it, decoder and encoder (docs/design.md §3).
//!
//! Design §8 step 11 writes the decoder, and step 13 the encoder.

pub const constants = @import("constants.zig");
/// Decision 14's claims, and the paths a decoder takes (decision 16).
pub const claims = @import("claims.zig");

const decoder = @import("decoder/decoder.zig");
pub const DecoderOptions = decoder.DecoderOptions;
pub const Decoder = decoder.Decoder;
/// The decoder of the `zstd` content coding: a window of 2^23 octets (RFC 9659 §3, decision 12).
pub const HttpDecoder = Decoder(.{});
pub const Corrupt = decoder.Corrupt;
pub const Unsupported = decoder.Unsupported;
pub const Error = decoder.Error;
pub const refusal = decoder.refusal;

test {
    _ = constants;
    _ = @import("fse.zig");
    _ = @import("huffman.zig");
    _ = @import("literals.zig");
    _ = @import("sequences.zig");
    _ = @import("frame.zig");
    _ = @import("block.zig");
    _ = @import("work.zig");
    _ = @import("fast_sequences.zig");
    _ = decoder;
}
