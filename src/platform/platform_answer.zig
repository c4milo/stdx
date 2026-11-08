//! How a probe turns what a source reports into an `Answer`. platform.zig and platform_x86.zig
//! call these, and the module's root does not export them.

const Answer = @import("platform.zig").Answer;

/// `yes` when the source reports the feature, `no` when it reports its absence.
pub fn answer(present: bool) Answer {
    return if (present) .yes else .no;
}

/// The answer for two features taken together: `no` when either is absent, `yes` when both are
/// present, and `not_known` otherwise.
pub fn both(first: Answer, second: Answer) Answer {
    if (first == .no or second == .no) return .no;
    if (first == .yes and second == .yes) return .yes;
    return .not_known;
}
