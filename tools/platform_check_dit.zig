//! The part of decision 40's check that a hidden FEAT_DIT needs. A hypervisor may hide FEAT_DIT
//! from /proc/cpuinfo on a core that implements it, and detection then reports the feature by the
//! core's MIDR (src/platform/platform_midr.zig). /proc/cpuinfo cannot confirm that answer, so the
//! check runs the mode's own instructions instead. It sets PSTATE.DIT on this thread and on a new
//! one, gives up the core between the write and the read, reads the bit back, and clears it. A core
//! without FEAT_DIT stops the check with SIGILL, and a bit that does not hold fails it.
const std = @import("std");
const platform = @import("platform");

const CpuFeatures = platform.CpuFeatures;

/// The times a thread gives up its core between setting the bit and reading it again, so that the
/// kernel can run other threads on the core and then restore this thread's PSTATE.
const yields_max: u32 = 1000;

/// The FEAT_DIT the check compares detection's with: the report's, or, where the report covers
/// the field and lacks the feature while detection has it, the answer of `mode_holds`. The check
/// passes `holds`, and a test a stand-in. `ModeFails` means detection reports a feature whose mode
/// does not hold.
pub fn reported_dit(
    report_covers: bool,
    report_has: bool,
    detected: CpuFeatures,
    mode_holds: *const fn (CpuFeatures) bool,
) error{ModeFails}!bool {
    if (!report_covers or report_has or !detected.dit) return report_has;
    if (!mode_holds(detected)) return error.ModeFails;
    return true;
}

/// Whether PSTATE.DIT sets, holds across `yields_max` yields and clears, on this thread and on a
/// new one, for a CPU with `features`.
pub fn holds(features: CpuFeatures) bool {
    if (!passed(round_on_thread(features))) return false;
    var held = false;
    const thread = std.Thread.spawn(.{}, holds_on_new_thread, .{ features, &held }) catch return false;
    thread.join();
    return held;
}

fn holds_on_new_thread(features: CpuFeatures, held: *bool) void {
    held.* = passed(round_on_thread(features));
}

/// What one thread's round read: the bit before it, after the set and the yields, and after the
/// clear. A set or a clear that the system refuses reads as the bit not moved.
const Round = struct { before: bool, kept: bool, cleared: bool };

/// Whether a round shows the mode working: off at first, on after the yields, and off again.
fn passed(round: Round) bool {
    return !round.before and round.kept and !round.cleared;
}

/// One thread's round: read, set, yield, read, clear, read. `set_data_independent_timing` asserts
/// that each write reads back at once, and the round asks that the set bit outlast the yields too.
fn round_on_thread(features: CpuFeatures) Round {
    const before = platform.data_independent_timing(features);
    if (!platform.set_data_independent_timing(features, true)) return .{ .before = before, .kept = false, .cleared = false };
    for (0..yields_max) |_| std.Thread.yield() catch {};
    const kept = platform.data_independent_timing(features);
    _ = platform.set_data_independent_timing(features, false);
    return .{ .before = before, .kept = kept, .cleared = platform.data_independent_timing(features) };
}

const testing = std.testing;

fn always(features: CpuFeatures) bool {
    _ = features;
    return true;
}

fn never(features: CpuFeatures) bool {
    _ = features;
    return false;
}

test "the report's FEAT_DIT stands, unless it lacks the feature where detection has it" {
    const with_dit: CpuFeatures = .{ .dit = true };
    try testing.expectEqual(true, try reported_dit(true, true, with_dit, never));
    try testing.expectEqual(false, try reported_dit(true, false, .{}, always));
    try testing.expectEqual(false, try reported_dit(false, false, with_dit, always));
    // A hidden feature: the mode's own instructions decide.
    try testing.expectEqual(true, try reported_dit(true, false, with_dit, always));
    try testing.expectError(error.ModeFails, reported_dit(true, false, with_dit, never));
}

test "a round passes only when the bit starts off, outlasts the yields, and clears" {
    try testing.expect(passed(.{ .before = false, .kept = true, .cleared = false }));
    try testing.expect(!passed(.{ .before = true, .kept = true, .cleared = false }));
    try testing.expect(!passed(.{ .before = false, .kept = false, .cleared = false }));
    try testing.expect(!passed(.{ .before = false, .kept = true, .cleared = true }));
}

test "a CPU with no FEAT_DIT holds no mode, and this host's answers where it has the feature" {
    try testing.expect(!holds(.{}));
    const detected = CpuFeatures.detect();
    if (!detected.dit) return error.SkipZigTest;
    try testing.expect(holds(detected));
}
