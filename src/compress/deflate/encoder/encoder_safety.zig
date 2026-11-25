//! Decision 49: the encoder's loops keep Zig's runtime safety checks unless the caller turns them
//! off at compile time, with `EncoderOptions.runtime_safety`. The functions that may run without
//! them are the match finder's, the block's appender and its code lookups, and the block
//! writer's. Each says so itself, with the level or the flag it takes: Zig applies
//! `@setRuntimeSafety` to the function that calls it, and a function it calls, inline or not,
//! keeps its own. Every other function of the module keeps its checks, and `std.debug.assert`
//! keeps its own.

const std = @import("std");
const builtin = @import("builtin");

/// Whether a build keeps the checks whatever a caller chose: a test build, the fuzzer's included,
/// and a Debug build do. `Encoder` joins it with the caller's choice once, in its level's
/// `runtime_safety`, and a function the choice reaches starts with
/// `@setRuntimeSafety(level.runtime_safety)`, or with the flag a caller copied from the level.
pub const kept = kept_in(builtin.is_test, builtin.mode);

fn kept_in(is_test: bool, mode: std.builtin.OptimizeMode) bool {
    return is_test or mode == .Debug;
}

test "runtime safety stays on in a test build and in a Debug build, whatever the caller chose" {
    try std.testing.expect(kept);
    try std.testing.expect(!kept_in(false, .ReleaseSafe));
    try std.testing.expect(kept_in(true, .ReleaseSafe));
    try std.testing.expect(kept_in(false, .Debug));
}

/// How a function starts where decision 49 lets a caller turn its runtime safety checks off: with
/// its level's field, or with the flag a caller copied from it.
const statement_start = "@setRuntimeSafety(";
const statements = [_][]const u8{ "@setRuntimeSafety(level.runtime_safety);", "@setRuntimeSafety(runtime_safety);" };

/// The statements of `source`, each required to be one of `statements`.
fn count_statements(source: []const u8) !usize {
    var count: usize = 0;
    var rest = source;
    for (0..source.len) |_| {
        const at = std.mem.indexOf(u8, rest, statement_start) orelse break;
        var known = false;
        for (statements) |statement| known = known or std.mem.startsWith(u8, rest[at..], statement);
        try std.testing.expect(known);
        count += 1;
        rest = rest[at + statement_start.len ..];
    }
    return count;
}

test "the encoder's loops leave their runtime safety checks only by their level's choice, and no other file does" {
    const chosen = [_][]const u8{
        @embedFile("encoder_match/encoder_match.zig"),      @embedFile("encoder_match/encoder_match_greedy.zig"),
        @embedFile("encoder_match/encoder_match_walk.zig"), @embedFile("encoder_match/encoder_match_walk_tail.zig"),
        @embedFile("encoder_match/encoder_match_dear.zig"), @embedFile("encoder_match/encoder_match_three.zig"),
        @embedFile("encoder_block.zig"),                    @embedFile("encoder_emit.zig"),
    };
    for (chosen) |source| try std.testing.expect(try count_statements(source) > 0);
    // The rest of the encoder, the prices among it, and the decoder with its fast path keep every
    // check.
    const checked = [_][]const u8{
        @embedFile("encoder.zig"),              @embedFile("encoder_code.zig"),
        @embedFile("encoder_code_runs.zig"),    @embedFile("encoder_split.zig"),
        @embedFile("encoder_split_price.zig"),  @embedFile("encoder_match/encoder_match_cost.zig"),
        @embedFile("../decoder/decoder.zig"),   @embedFile("../decoder/decoder_header.zig"),
        @embedFile("../fast/fast.zig"),         @embedFile("../fast/fast_copy.zig"),
        @embedFile("../fast/fast_lengths.zig"), @embedFile("../fast/fast_step.zig"),
        @embedFile("../huffman.zig"),
    };
    for (checked) |source| try std.testing.expect(std.mem.indexOf(u8, source, statement_start) == null);
}
