//! zstd: Zstandard, RFC 8878 as RFC 9659 updates it, decoder and encoder (docs/design.md §3).
//!
//! No codec code is written until the owner rules on decisions 11 to 17. What is here are the
//! limits RFC 8878 and RFC 9659 fix.

pub const constants = @import("constants.zig");

test {
    _ = constants;
}
