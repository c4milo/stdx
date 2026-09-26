//! deflate: the raw DEFLATE format of RFC 1951, decoder and encoder (docs/design.md §3).
//!
//! The decoder is design §8's first codec step and stdx issue 1
//! (https://github.com/c4milo/stdx/issues/1), design §8 steps 5 and 7; step 9 writes the encoder.
//! The decoder here is the checked path of step 5.

pub const constants = @import("constants.zig");

const decoder = @import("decoder.zig");
pub const Decoder = decoder.Decoder;
pub const Corrupt = decoder.Corrupt;
pub const Unsupported = decoder.Unsupported;
pub const Error = decoder.Error;
pub const init = decoder.init;
pub const decode = decoder.decode;
pub const refusal = decoder.refusal;

test {
    _ = constants;
    _ = @import("huffman.zig");
    _ = decoder;
}
