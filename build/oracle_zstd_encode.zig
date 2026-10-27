//! The `differential-zstd-encode` step of build/oracle.zig: design §8 step 13's check of the
//! Zstandard encoder through libzstd's decoder and stdx's (tools/differential/zstd_encode.zig).
//! It takes stdx from the graph `differential-encode` builds, so `-Dencode-optimize` sets the mode
//! of both (invariant 5).

const std = @import("std");
const modules = @import("modules.zig");
const oracle_corpus = @import("oracle_corpus.zig");

/// What the check needs from build/oracle.zig.
pub const Inputs = struct {
    oracle: *std.Build.Module,
    corpus_names: *std.Build.Module,
    corpus: oracle_corpus.Corpus,
    baseline: std.Build.ResolvedTarget,
    graph: modules.Modules,
};

pub fn add(b: *std.Build, step: *std.Build.Step, inputs: Inputs) void {
    const module = b.createModule(.{
        .root_source_file = b.path("tools/differential/zstd_encode.zig"),
        .target = inputs.baseline,
        .optimize = .ReleaseSafe,
    });
    module.addImport("oracle", inputs.oracle);
    module.addImport("corpus", inputs.corpus_names);
    module.addImport("codec", inputs.graph.codec);
    module.addImport("zstd", inputs.graph.zstd);
    const check = b.addExecutable(.{ .name = "differential_zstd_encode", .root_module = module });
    const run = b.addRunArtifact(check);
    run.has_side_effects = true;
    if (b.args) |args| run.addArgs(args);
    oracle_corpus.add_args(b, run, inputs.corpus);
    step.dependOn(&run.step);
}
