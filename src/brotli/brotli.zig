//! brotli: RFC 7932, decoder and encoder (docs/design.md §3). RFC 9841's large windows, shared
//! dictionaries and framing format are out of version one (decision 13, proposed).
//!
//! No codec code is written until the owner rules on decisions 11 to 17. What is here are the
//! limits RFC 7932 fixes.

pub const constants = @import("constants.zig");

test {
    _ = constants;
}
