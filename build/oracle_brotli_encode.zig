//! The `differential-brotli-encode` step of build/oracle.zig: design §8 step 14's check of the
//! brotli encoder through Google's decoder and stdx's (tools/differential/brotli_encode.zig).
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
        .root_source_file = b.path("tools/differential/brotli_encode.zig"),
        .target = inputs.baseline,
        .optimize = .ReleaseSafe,
    });
    module.addImport("oracle", inputs.oracle);
    module.addImport("corpus", inputs.corpus_names);
    module.addImport("codec", inputs.graph.codec);
    module.addImport("brotli", inputs.graph.brotli);
    const check = b.addExecutable(.{ .name = "differential_brotli_encode", .root_module = module });
    const run = b.addRunArtifact(check);
    run.has_side_effects = true;
    if (b.args) |args| run.addArgs(args);
    oracle_corpus.add_args(b, run, inputs.corpus);
    step.dependOn(&run.step);
}
