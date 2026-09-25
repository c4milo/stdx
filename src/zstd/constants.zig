//! The limits RFC 8878 and RFC 9659 fix for Zstandard.
const std = @import("std");

/// The Window_Size every decoder of the `zstd` content coding must support, and the most an
/// encoder of it may require (RFC 9659 §3). The RFC writes "8 MB". Decision 12 reads it as 2^23
/// octets for a decoder, which covers both readings of "MB", 10^6 octets and 2^20.
pub const http_window_len: u64 = 8 * 1024 * 1024;

/// The most octets one block holds, compressed or decompressed: Block_Maximum_Size is the smaller
/// of Window_Size and 128 KB (RFC 8878 §3.1.1.2.4).
pub const block_len_max: usize = 128 * 1024;

comptime {
    std.debug.assert(std.math.isPowerOfTwo(http_window_len));
    std.debug.assert(block_len_max <= http_window_len);
}
