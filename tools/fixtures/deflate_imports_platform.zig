//! Check fixture for tools/graph_check.zig. Compiled as the root of a module carrying exactly the
//! import set build/modules.zig gives `deflate`. The compile MUST fail, because no module imports
//! `platform`, the one module that may make a syscall (docs/design.md §3, decision 40, invariant 14).
//!
//! The import sits in a `comptime` block on purpose. Zig analyses lazily, so an unreferenced `const
//! x = @import("platform");` compiles clean and the check would pass while proving nothing.
comptime {
    _ = @import("platform");
}
