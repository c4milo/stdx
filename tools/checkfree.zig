//! checkfree: stdx's configuration of pepegrillo's `checkfree` engine (decisions 7 and 51). The
//! engine counts the safety check sites each SIMD kernel of decision 21 reaches, in the assembly
//! of its ReleaseSafe variant object, and requires the counts tools/checkfree_sites.zig pins.
//!
//! Usage: `checkfree [--record] <file.s>...`. `zig build checkfree-check` passes the files.

const std = @import("std");
const pepegrillo = @import("pepegrillo");
const sites = @import("checkfree_sites.zig");

const config: pepegrillo.checkfree.Config = .{
    .pins = &sites.pins,
    .prefix = "stdx_",
    .table = "tools/checkfree_sites.zig",
};

pub fn main(init: std.process.Init) !void {
    return pepegrillo.checkfree.main(init, config);
}

test "the pins pass the engine's check of a configuration" {
    try std.testing.expectEqual(null, pepegrillo.checkfree.check_config(config));
}
