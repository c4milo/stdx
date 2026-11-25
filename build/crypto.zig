//! The chapulin module behind `stdx.crypto` (decision 87, design §8 step 23). stdx is the one
//! place that asks chapulin for its module, so a program that links stdx links one chapulin.
//!
//! A dependent opts in with the build option `crypto`. Without it, the package fetches no chapulin
//! and compiles no C: chapulin is a lazy dependency, and `stdx.crypto` names the option in a
//! compile error. stdx's own build turns the option on, so its tests cover the module.
const std = @import("std");

/// The two options a dependent passes to stdx's dependency.
pub const Options = struct {
    /// Fetch chapulin and give the module `stdx` its `crypto`.
    enabled: bool,
    /// chapulin's `KEYLOG=on`: each session hands its traffic secrets to `ch_keylog`, which the
    /// program defines. For a program's tests that read a capture, never for a program that ships.
    keylog: bool,
};

/// Reads the two options once. stdx's own build turns `crypto` on, and a dependent's is off
/// unless it passes `.crypto = true`.
pub fn options(b: *std.Build) Options {
    const own_build = b.pkg_hash.len == 0;
    return .{
        .enabled = b.option(bool, "crypto", "Give stdx.crypto, chapulin's module (decision 87)") orelse own_build,
        .keylog = b.option(bool, "crypto_keylog", "Build chapulin with KEYLOG=on, for tests that read a capture") orelse false,
    };
}

/// chapulin's `SUITE`, `KEYLOG` and on-or-off values, spelled as its build spells them.
const Suite = enum { chacha, aesgcm };
const Setting = enum { on, off };

/// chapulin's module of `TRANSPORT=nonblocking` (chapulin's decision 245): the TCP object as `tcp`
/// and the QUIC object as `quic`, one configuration, and the one definition of `ch_assert_fail`.
/// Null when the dependent did not opt in, or while Zig has not fetched chapulin yet.
/// - `RAND=session`: each session draws from the `std.Random` its caller passes, never from the
///   operating system (non-negotiable 4 of each library that runs a session).
/// - `ROLE=both TRUST=webpki`: a client and a server, and the one client trust mode that compiles
///   ALPN in, which HTTP/2 over TLS needs (RFC 9113 §3.1).
/// - `EXPORTER=on` and `TX_RECORD=16384`, a record of TLS's largest plaintext (RFC 9846 §5.1), and
///   `DNSSEC`, `JWS` and `SCRAM` on a host target, reach the TCP object alone.
/// - `SUITE=aesgcm` on a host target, which adds RFC 9846 §9.1's mandatory
///   TLS_AES_128_GCM_SHA256. chapulin refuses it over its software AES, so another target takes
///   `SUITE=chacha`.
pub fn chapulin(b: *std.Build, target: std.Build.ResolvedTarget, wanted: Options) ?*std.Build.Module {
    if (!wanted.enabled) return null;
    const dependency = b.lazyDependency("chapulin", .{
        .target = target,
        .RAND = .session,
        .TRANSPORT = .nonblocking,
        .ROLE = .both,
        .TRUST = .webpki,
        .EXPORTER = .on,
        .SUITE = if (host_object(target)) Suite.aesgcm else Suite.chacha,
        .TX_RECORD = "16384",
        .KEYLOG = if (wanted.keylog) Setting.on else Setting.off,
        .DNSSEC = host_setting(target),
        .JWS = host_setting(target),
        .SCRAM = host_setting(target),
    }) orelse return null;
    return dependency.module("chapulin");
}

/// `on` in a host object, and `off` in a device object, which chapulin refuses each of them in.
fn host_setting(target: std.Build.ResolvedTarget) Setting {
    return if (host_object(target)) .on else .off;
}

/// chapulin's host test (its build's `hostTarget`): a little-endian arm64 target with NEON, or an
/// x86-64 target with SSE2, which every such CPU has. A host object holds every fast path beside
/// the portable code, and each session picks among them from the CPU its caller describes.
pub fn host_object(target: std.Build.ResolvedTarget) bool {
    const cpu = target.result.cpu;
    return switch (cpu.arch) {
        .aarch64 => std.Target.aarch64.featureSetHas(cpu.features, .neon),
        .x86_64 => std.Target.x86.featureSetHas(cpu.features, .sse2),
        else => false,
    };
}
