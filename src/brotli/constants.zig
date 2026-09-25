//! The limits RFC 7932 fixes for a brotli stream.
const std = @import("std");

/// The largest WBITS a stream header may carry (RFC 7932 §9.1).
pub const window_bits_max: u6 = 24;

/// The farthest a non-dictionary back-reference reaches: (1 << WBITS) - 16 (RFC 7932 §9.1).
pub const window_len_max: usize = (1 << window_bits_max) - 16;

comptime {
    std.debug.assert(window_len_max == 16 * 1024 * 1024 - 16);
}
