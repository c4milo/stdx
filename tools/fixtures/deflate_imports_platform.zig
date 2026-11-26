//! A positive control for tools/graph_check.zig. `platform` IS in `deflate`'s import set, for the
//! type `CpuFeatures` that each codec's `init` takes (decisions 21 and 40 as amended on
//! 2026-11-24), so this MUST compile. The `cpu-probe` lint rule, not the graph, keeps a codec from
//! calling `platform.CpuFeatures.detect` (invariant 14).
comptime {
    _ = @import("platform").CpuFeatures;
}
