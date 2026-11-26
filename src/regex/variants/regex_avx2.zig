//! Claims R2 and R5's searches compiled for x86-64 with AVX2 (decision 86): `avx2_lanes` octets a
//! step, where the library's own build takes `skip_lanes`. Each is exported under a name that
//! carries the level, and the module calls it only when the caller's features name AVX2. Claim
//! R2's search is exported twice: as it is, and counting its misses for claims R14 and R4.

const constants = @import("../constants.zig");
const literal_file = @import("../literal.zig");
const Literal = literal_file.Literal;
const literal_find = @import("../literal_find.zig");
const literal_set = @import("../literal_set.zig");
const LiteralSet = literal_set.LiteralSet;
const level = @import("variant_level").level;

fn find_literal(literal: *const Literal, haystack: [*]const u8, haystack_len: usize, from: usize) callconv(.c) usize {
    return literal_find.find(constants.avx2_lanes, literal, haystack[0..haystack_len], from, {}) orelse literal_file.no_place;
}

fn find_literal_counting(literal: *const Literal, haystack: [*]const u8, haystack_len: usize, from: usize, misses: *usize) callconv(.c) usize {
    return literal_find.find(constants.avx2_lanes, literal, haystack[0..haystack_len], from, misses) orelse literal_file.no_place;
}

fn find_literal_set(set: *const LiteralSet, haystack: [*]const u8, haystack_len: usize, from: usize) callconv(.c) usize {
    return set.find_by(constants.avx2_lanes, haystack[0..haystack_len], from) orelse literal_file.no_place;
}

comptime {
    const suffix = @tagName(level);
    @export(&find_literal, .{ .name = "stdx_regex_literal_find_" ++ suffix });
    @export(&find_literal_counting, .{ .name = "stdx_regex_literal_find_counting_" ++ suffix });
    @export(&find_literal_set, .{ .name = "stdx_regex_literal_set_find_" ++ suffix });
}
