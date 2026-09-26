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
pub const limit_window = decoder.limit_window;
pub const decode = decoder.decode;
pub const decode_with = decoder.decode_with;
pub const Options = decoder.Options;
pub const claims = @import("claims.zig");
pub const Claims = claims.Claims;
pub const refusal = decoder.refusal;

/// A bit writer that builds DEFLATE streams for tests, this module's and its containers'.
pub const TestStream = @import("test_stream.zig").Stream;

test {
    _ = constants;
    _ = @import("huffman.zig");
    _ = @import("lookup.zig");
    _ = decoder;
    _ = @import("test_stream.zig");
}
