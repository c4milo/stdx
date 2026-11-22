//! Claim R5's Teddy compiled for x86-64 with SSSE3 (decision 86): PSHUFB's lookups at
//! `skip_lanes` octets a step, which the library's own build for SSE2 has no instruction for.
//! The module calls it only when the caller's features name SSSE3 and not AVX2, whose object
//! searches 32 octets a step.

const constants = @import("../constants.zig");
const literal_file = @import("../literal.zig");
const literal_set = @import("../literal_set.zig");
const LiteralSet = literal_set.LiteralSet;
const level = @import("variant_level").level;

fn find_literal_set(set: *const LiteralSet, haystack: [*]const u8, haystack_len: usize, from: usize) callconv(.c) usize {
    return set.find_by(constants.skip_lanes, haystack[0..haystack_len], from) orelse literal_file.no_place;
}

comptime {
    @export(&find_literal_set, .{ .name = "stdx_regex_literal_set_find_" ++ @tagName(level) });
}
