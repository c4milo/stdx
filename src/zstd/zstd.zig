//! zstd: Zstandard, RFC 8878 as RFC 9659 updates it, decoder and encoder (docs/design.md §3).
//!
//! Design §8 step 11 writes the decoder, and step 13 the encoder. What is here are the limits RFC
//! 8878 and RFC 9659 fix.

pub const constants = @import("constants.zig");

test {
    _ = constants;
}
