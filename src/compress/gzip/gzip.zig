//! gzip: the container of RFC 1952 around a DEFLATE stream, with its CRC-32 and its length
//! (docs/design.md §3). HTTP's `gzip` content coding and transfer coding name this format
//! (RFC 9110 §8.4.1.3).
//!
//! Design §8 step 6 writes the decoder, and step 9 the encoder.

const deflate = @import("deflate");

pub const constants = @import("constants.zig");

const decoder = @import("decoder.zig");
pub const Decoder = decoder.Decoder;
pub const Corrupt = decoder.Corrupt;
pub const Unsupported = decoder.Unsupported;
pub const Error = decoder.Error;
pub const refusal = decoder.refusal;

const encoder = @import("encoder.zig");
pub const Encoder = encoder.Encoder;
/// The level and the safety option of the encoder, as `deflate` takes them. The container adds
/// none.
pub const EncoderOptions = deflate.EncoderOptions;

const io = @import("io.zig");
pub const IoReader = io.IoReader;
pub const IoWriter = io.IoWriter;

test {
    _ = io;
    _ = constants;
    _ = decoder;
    _ = encoder;
}
