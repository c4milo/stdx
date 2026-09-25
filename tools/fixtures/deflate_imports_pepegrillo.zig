//! Check fixture for tools/graph_check.zig. Compiled as the root of a module carrying exactly the
//! import set build/modules.zig gives `deflate`. The compile MUST fail, because no library module
//! receives a package. pepegrillo, the oracles and the corpora are for `tools/` and `bench/` alone
//! (decisions 7 and 8, invariant 14).
//!
//! The import sits in a `comptime` block on purpose. Zig analyses lazily, so an unreferenced `const
//! x = @import("pepegrillo");` compiles clean and the check would pass while proving nothing.
comptime {
    _ = @import("pepegrillo");
}
