//! deflate: the raw DEFLATE format of RFC 1951, decoder and encoder (docs/design.md §3).
//!
//! The decoder is design §8's first codec step and stdx issue 1
//! (https://github.com/c4milo/stdx/issues/1). No codec code is written until the owner rules on
//! decisions 11 to 17. What is here are the limits RFC 1951 fixes.

pub const constants = @import("constants.zig");

test {
    _ = constants;
}
