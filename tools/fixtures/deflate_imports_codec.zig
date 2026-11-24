//! A positive control for tools/graph_check.zig. `codec` IS in `deflate`'s import set, so this
//! MUST compile. A check that only required failures would pass on a mistyped path or a broken
//! invocation; this is what makes the failures mean what they say.
//!
//! It lays out a `codec.IoReader`, whose field of `platform.CpuFeatures` makes the compile read
//! `codec`'s own import of `platform`. A compile that did not give `codec` that import fails here.
comptime {
    _ = @sizeOf(@import("codec").IoReader(struct {}, error{}, .refuse));
}
