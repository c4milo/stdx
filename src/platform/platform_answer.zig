//! How a probe turns what a source reports into an `Answer`. platform.zig, platform_x86.zig and
//! platform_linux.zig call these, and the module's root does not export them.

const platform = @import("platform.zig");
const Answer = platform.Answer;
const Cpu = platform.Cpu;

/// The answers of a source that gives none.
pub const unanswered: Cpu = .{ .aes_clmul = .not_known, .dit = .not_known, .sha256 = .not_known, .sha512 = .not_known, .sha3 = .not_known, .sve2 = .not_known, .ssse3 = .not_known, .sse4_1 = .not_known, .avx2 = .not_known, .vaes = .not_known, .midr = null };

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
