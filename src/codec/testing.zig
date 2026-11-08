//! What stdx's own tests, tools and benchmarks use of `codec`, as `std.testing` holds what std's
//! tests use. None of it is part of the API (decision 64).

/// The seeded split driver every codec's tests run their streams under (decision 15).
pub const split = @import("split.zig");
/// The source and the destination the `std.Io` tests give octets and room to in parts.
pub const io_parts = @import("io_parts.zig");

test {
    _ = split;
    _ = io_parts;
}
