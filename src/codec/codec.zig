//! codec: the streaming contract every codec in stdx shares (decision 11, design §3).
//!
//! - `Status`, `Progress`, `Flush` and `Refusal`: how a call ends, what it did, what an encoder's
//!   caller says about its input, and the two classes of refusal.
//! - `check_entry` and `check_progress`: the assertions every call makes at its entry and its exit
//!   (invariants 7 and 8), over `overlap` and `violation`, which name what they check.
//! - `Reader`, `Writer` and `BitReader`: the checked paths every codec parses and writes through
//!   (decision 16).
//! - `Window`: the history a decoder's back-references reach, which reads only octets written
//!   since `init` (invariant 10).
//! - `split`: the seeded split driver every codec's tests run their streams under (decision 15).
//! - `Features`: the CPU features a codec's SIMD paths may use, which the caller detects once and
//!   passes to each codec's `init` (decision 21).
//!
//! The module imports nothing.

const status = @import("status.zig");

pub const constants = @import("constants.zig");
pub const Status = status.Status;
pub const Progress = status.Progress;
pub const Flush = status.Flush;
pub const Refusal = status.Refusal;
pub const Violation = status.Violation;
pub const overlap = status.overlap;
pub const violation = status.violation;
pub const check_entry = status.check_entry;
pub const check_progress = status.check_progress;
pub const Reader = @import("reader.zig").Reader;
pub const Writer = @import("writer.zig").Writer;
pub const BitReader = @import("bit_reader.zig").BitReader;
pub const Bits = @import("bit_reader.zig").Bits;
pub const Window = @import("window.zig").Window;
pub const split = @import("split.zig");
pub const Features = @import("features.zig").Features;

test {
    _ = status;
    _ = constants;
    _ = @import("reader.zig");
    _ = @import("writer.zig");
    _ = @import("bit_reader.zig");
    _ = split;
    _ = @import("window.zig");
    _ = @import("features.zig");
}
