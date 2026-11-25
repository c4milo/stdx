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
    const crypto = stdx.crypto.init(.{
        .probe = stdx.platform.probe(),
        .timing = .not_stated,
        .random = csprng.random(),
    });
    _ = crypto;

    var digest: [stdx.crypto.scram.sha256_len]u8 = undefined;
    stdx.crypto.scram.sha256(&digest, "abc");
    const hex = std.fmt.bytesToHex(digest, .lower);
    if (!std.mem.eql(u8, &hex, abc_digest)) return error.WrongDigest;
}
