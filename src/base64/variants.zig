//! The root of the base64 module's variant object (decisions 21 and 68). The build compiles this
//! file for x86-64 with AVX2, with `@import("variant_level").level` naming the level, and links the
//! object into the module. The module calls its kernels only when the caller's `codec.Features`
//! name AVX2 (fast.zig).

const level = @import("variant_level").level;

comptime {
    switch (level) {
        .x86_64_avx2 => _ = @import("variants/base64_avx2.zig"),
        else => {},
    }
}
