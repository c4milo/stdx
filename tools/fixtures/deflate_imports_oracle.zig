//! Check fixture for tools/graph_check.zig. Compiled as the root of a module carrying exactly the
//! import set build/modules.zig gives `deflate`. The compile MUST fail, because no library module
//! receives an oracle. The oracle bindings of tools/oracle/ link zlib and Wuffs, and only tools and
//! benchmarks may import them (decision 8, invariant 14).
//!
//! The import sits in a `comptime` block on purpose. Zig analyses lazily, so an unreferenced `const
//! x = @import("oracle");` compiles clean and the check would pass while proving nothing.
comptime {
    _ = @import("oracle");
}
