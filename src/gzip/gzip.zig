//! gzip: the container of RFC 1952 around a DEFLATE stream, with its CRC-32 and its length
//! (docs/design.md §3). HTTP's `gzip` content coding and transfer coding name this format
//! (RFC 9110 §8.4.1.3).
//!
//! Design §8 step 6 writes the decoder, and step 9 the encoder.

pub const constants = @import("constants.zig");

const decoder = @import("decoder.zig");
pub const Decoder = decoder.Decoder;
pub const Corrupt = decoder.Corrupt;
pub const Unsupported = decoder.Unsupported;
pub const Error = decoder.Error;
pub const init = decoder.init;
pub const decode = decoder.decode;
pub const decode_all = decoder.decode_all;
pub const refusal = decoder.refusal;

test {
    _ = constants;
    _ = decoder;
}
