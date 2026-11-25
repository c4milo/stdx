//! deflate: the raw DEFLATE format of RFC 1951, decoder and encoder (docs/design.md §3).
//!
//! The decoder is design §8's first codec step and stdx issue 1
//! (https://github.com/c4milo/stdx/issues/1), design §8 steps 5 and 7; step 9 writes the encoder.
//! The decoder here is the checked path of step 5.

pub const constants = @import("constants.zig");

const decoder = @import("decoder/decoder.zig");
pub const Decoder = decoder.Decoder;
pub const Corrupt = decoder.Corrupt;
pub const Unsupported = decoder.Unsupported;
pub const Error = decoder.Error;
pub const DecodePaths = decoder.DecodePaths;
pub const claims = @import("claims.zig");
pub const Claims = claims.Claims;
pub const refusal = decoder.refusal;

const encoder = @import("encoder/encoder.zig");
pub const Encoder = encoder.Encoder;
pub const EncoderOptions = encoder.EncoderOptions;

const io = @import("io.zig");
pub const IoReader = io.IoReader;
pub const IoWriter = io.IoWriter;

/// What stdx's own tests, tools and benchmarks use, and no part of the API (decision 64).
pub const testing = @import("testing.zig");

test {
    _ = io;
    _ = constants;
    _ = @import("huffman.zig");
    _ = @import("lookup.zig");
    _ = @import("fast/fast.zig");
    _ = decoder;
    _ = testing;
    _ = @import("encoder/encoder_code.zig");
    _ = @import("encoder/encoder_block.zig");
    _ = @import("encoder/encoder_match/encoder_match_cost.zig");
    _ = encoder;
}
