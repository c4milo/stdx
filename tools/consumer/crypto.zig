//! The example of `src/crypto/README.md`, as a program that depends on stdx with `.crypto = true`:
//! build.zig beside it holds the line. `zig build readme-check` builds and runs it with the
//! consumer's other program, and requires each Zig block of that README to be an excerpt of this
//! file or of build.zig. It exits 0 when the digest is RFC 6234's.
const std = @import("std");
const stdx = @import("stdx");

/// The SHA-256 of "abc", RFC 6234 §8.5's first test.
const abc_digest = "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad";

pub fn main(init: std.process.Init) !void {
    // A random source a program seeds once from the operating system's entropy.
    var seed: [std.Random.DefaultCsprng.secret_seed_length]u8 = undefined;
    try init.io.randomSecure(&seed);
    var csprng: std.Random.DefaultCsprng = .init(seed);
    // The CPU features the program detects once, for its codecs and for stdx.crypto alike.
    const features = stdx.platform.CpuFeatures.detect();
    // Data-independent timing on this thread where a program can set it: arm64 with FEAT_DIT.
    // On x86-64 only the operating system sets DOITM, so this program states nothing there.
    const set = stdx.platform.set_data_independent_timing(features, true);
    const timing: stdx.crypto.Timing = if (set) .data_independent else .not_stated;
    const crypto = stdx.crypto.init(.{
        .features = features,
        .timing = timing,
        .random = csprng.random(),
    });

    var digest: [stdx.crypto.hash.sha256_len]u8 = undefined;
    try stdx.crypto.hash.sha256(crypto.cpu, &digest, "abc");
    const hex = std.fmt.bytesToHex(digest, .lower);
    if (!std.mem.eql(u8, &hex, abc_digest)) return error.WrongDigest;
}
