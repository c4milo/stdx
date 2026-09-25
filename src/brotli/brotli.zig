//! brotli: RFC 7932, decoder and encoder (docs/design.md §3). RFC 9841's large windows, shared
//! dictionaries and framing format are out of version one (decision 13).
//!
//! Design §8 step 12 writes the decoder, and step 14 the encoder. What is here are the limits RFC
//! 7932 fixes.

pub const constants = @import("constants.zig");

test {
    _ = constants;
}
