//! The root of the json module's variant objects (decisions 21 and 30). The build compiles this
//! file once for each x86-64 level claim J7 takes, each time for a CPU with that level's features
//! and with `@import("variant_level").level` naming the level, and links each object into the json
//! module. Each exports its level's scans alone, so no two define the same symbol.
//!
//! The module calls a level's scans only when the caller's `codec.Features` name the level
//! (wide.zig).

const level = @import("variant_level").level;

comptime {
    switch (level) {
        .x86_64_avx2, .x86_64_avx512 => _ = @import("variants/scan_wide.zig"),
        else => {},
    }
}
