//! Check fixture for tools/graph_check.zig. Compiled as the root of a module carrying exactly the
//! import set build/modules.zig gives `deflate`. The compile MUST fail, because raw DEFLATE carries
//! no checksum. Its wrappers do, so `checksum` is theirs and not `deflate`'s (docs/design.md §3,
//! invariant 14).
//!
//! The import sits in a `comptime` block on purpose. Zig analyses lazily, so an unreferenced `const
//! x = @import("checksum");` compiles clean and the check would pass while proving nothing.
comptime {
    _ = @import("checksum");
}
