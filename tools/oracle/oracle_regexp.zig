//! The Go oracle of `zig build differential-regex` (decision 86): Go's regexp and Go's bzip2
//! decoder, from the c-archive of tools/oracle/go_regexp/. Go's regexp holds RE2's syntax and its
//! leftmost-first matches. It reads an octet that is not UTF-8 as U+FFFD, where RE2 and stdx match
//! no such octet, so the check gives it texts of UTF-8 alone.

const std = @import("std");

extern fn go_regexp_find(slot: usize, pattern: [*]const u8, pattern_len: usize, text: [*]const u8, text_len: usize, offsets: [*]c_longlong, room: usize) c_longlong;
extern fn go_bzip2_decode(input: [*]const u8, len: usize, output: [*]u8, room: usize) c_longlong;

/// What go_regexp_find returns where it returns no count of groups.
const find_refused = -1;
const find_groups_too_many = -2;

/// What Go's regexp makes of a pattern and a text.
pub const Found = union(enum) {
    /// Go refuses the pattern.
    refused,
    /// The pattern matches nowhere in the text.
    none,
    /// The groups of the leftmost-first match, the whole match first: their count. Each has a
    /// start and an end in the caller's `offsets`, -1 twice where a group took no part.
    groups: usize,
    /// The match has more groups than the caller's room holds.
    groups_too_many,
};

/// The callers `find` serves at once, each with a slot of its own.
pub const slots_max = 64;

/// Go's leftmost-first match of `pattern` in `text`, its offsets written into `offsets`, two for
/// each group. `slot` names the caller: Go keeps the pattern it compiled last for each slot, and
/// no two threads call with one slot.
pub fn find(slot: usize, pattern: []const u8, text: []const u8, offsets: []i64) Found {
    std.debug.assert(slot < slots_max);
    const room = offsets.len / 2;
    const groups = go_regexp_find(slot, pattern.ptr, pattern.len, text.ptr, text.len, @ptrCast(offsets.ptr), room);
    return switch (groups) {
        find_refused => .refused,
        find_groups_too_many => .groups_too_many,
        0 => .none,
        else => .{ .groups = @intCast(groups) },
    };
}

/// The octets of a bzip2 stream, written into `output`, or null when Go refuses the stream or it
/// does not fit.
pub fn bzip2_decode(input: []const u8, output: []u8) ?[]u8 {
    const written = go_bzip2_decode(input.ptr, input.len, output.ptr, output.len);
    if (written < 0) return null;
    return output[0..@intCast(written)];
}

comptime {
    std.debug.assert(@sizeOf(c_longlong) == @sizeOf(i64));
}
