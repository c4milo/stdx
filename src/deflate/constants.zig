//! The limits RFC 1951 fixes for every DEFLATE stream.
const std = @import("std");

/// The farthest a back-reference reaches, and so the history a decoder keeps: a distance is drawn
/// from 1 to 32,768 (RFC 1951 §3.2.5). A compliant decoder accepts the whole range (§3.3).
pub const window_len: usize = 32768;

/// The longest match a length code expresses (RFC 1951 §3.2.5).
pub const match_len_max: usize = 258;

comptime {
    std.debug.assert(std.math.isPowerOfTwo(window_len));
    std.debug.assert(match_len_max < window_len);
}
