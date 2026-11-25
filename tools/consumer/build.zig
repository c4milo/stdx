//! A project of its own that depends on stdx the way the README says, with this tree as the
//! dependency. `zig build readme-check` builds it with a nested `zig build` and runs the program
//! it builds, so the README's two `build.zig` lines are shown to work, and not only to parse.
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const exe = b.addExecutable(.{
        .name = "consumer",
        .root_module = b.createModule(.{ .root_source_file = b.path("main.zig"), .target = target }),
    });
    const stdx = b.dependency("stdx", .{ .target = target, .release = true });
    exe.root_module.addImport("stdx", stdx.module("stdx"));
    b.installArtifact(exe);

    // `stdx.crypto` (src/crypto/README.md): a program of its own, so the README's lines above stay
    // the ones a program with no cryptography writes, and fetch no chapulin.
    const crypto_exe = b.addExecutable(.{
        .name = "consumer-crypto",
        .root_module = b.createModule(.{ .root_source_file = b.path("crypto.zig"), .target = target }),
    });
    const stdx_crypto = b.dependency("stdx", .{ .target = target, .release = true, .crypto = true });
    crypto_exe.root_module.addImport("stdx", stdx_crypto.module("stdx"));
    b.installArtifact(crypto_exe);
}
