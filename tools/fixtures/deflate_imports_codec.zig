//! The positive control for tools/graph_check.zig. `codec` IS in `deflate`'s import set, so this
//! MUST compile. A check that only required failures would pass on a mistyped path or a broken
//! invocation; this is what makes the failures mean what they say.
comptime {
    _ = @import("codec");
}
