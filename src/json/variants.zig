//! The root of the json module's variant object (decisions 21, 30 and 36). The build compiles this
//! file for the one x86-64 level claim J7 takes, AVX2, for a CPU with its features and with
//! `@import("variant_level").level` naming it, and links the object into the json module.
//!
//! The module calls a level's scans only when the caller's `codec.Features` name the level
//! (wide.zig).

const level = @import("variant_level").level;

comptime {
    switch (level) {
        .x86_64_avx2 => {
            _ = @import("variants/scan_wide.zig");
            _ = @import("variants/string_walk_blocks.zig");
        },
        else => {},
    }
}
