//! What stdx's own tests, tools and benchmarks use of `deflate`, as `std.testing` holds what
//! std's tests use. None of it is part of the API (decision 64).

const decoder = @import("decoder/decoder.zig");

/// A bit writer that builds DEFLATE streams for tests, this module's and its containers'.
pub const Stream = @import("test_stream.zig").Stream;
/// How a decode took each symbol, which `decode_counting` adds to: S2's test (decision 14).
pub const Lookups = decoder.Lookups;
pub const decode_counting = decoder.decode_counting;

test {
    _ = @import("test_stream.zig");
}
