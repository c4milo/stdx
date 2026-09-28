//! brotli: RFC 7932, decoder and encoder (docs/design.md §3). RFC 9841's large windows, shared
//! dictionaries and framing format are out of version one (decision 13).
//!
//! Design §8 step 12 writes the decoder, and step 14 the encoder. What is here are the limits RFC
//! 7932 fixes, its static dictionary and word transformations (claim B1), and its context
//! lookup tables (claim B2).

pub const constants = @import("constants.zig");
pub const dictionary = @import("dictionary.zig");
pub const transform = @import("transform.zig");
pub const context = @import("context.zig");
pub const prefix = @import("prefix.zig");
pub const claims = @import("claims.zig");

const decoder = @import("decoder/decoder.zig");
pub const Decoder = decoder.Decoder;
pub const DecoderOptions = decoder.DecoderOptions;
pub const HttpDecoder = decoder.HttpDecoder;
pub const Corrupt = decoder.Corrupt;
pub const Unsupported = decoder.Unsupported;
pub const Error = decoder.Error;
pub const refusal = decoder.refusal;

test {
    _ = constants;
    _ = dictionary;
    _ = transform;
    _ = context;
    _ = prefix;
    _ = claims;
    _ = decoder;
}
