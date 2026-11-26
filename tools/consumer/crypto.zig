//! The example of `src/crypto/README.md`, as a program that depends on stdx with `.crypto = true`:
//! build.zig beside it holds the line. `zig build readme-check` builds and runs it with the
//! consumer's other program, and requires each Zig block of that README to be an excerpt of this
//! file or of build.zig. It exits 0 when the digest is RFC 6234's.
const std = @import("std");
const stdx = @import("stdx");

/// The SHA-256 of "abc", RFC 6234 §8.5's first test.
const abc_digest = "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad";

/// A random source over the operating system's entropy. Each draw calls `io.randomSecure`, which
/// is thread-safe, keeps no state that a fork copies, and has no weaker fallback. A draw that fails
/// halts the program, so no session runs on bytes the system did not give.
const SecureRandom = struct {
    io: std.Io,

    fn fill(pointer: *anyopaque, bytes: []u8) void {
        const self: *SecureRandom = @ptrCast(@alignCast(pointer));
        self.io.randomSecure(bytes) catch |err| std.debug.panic("no entropy: {t}", .{err});
    }

    fn random(self: *SecureRandom) std.Random {
        return .{ .ptr = self, .fillFn = fill };
    }
};

pub fn main(init: std.process.Init) !void {
    // The random source of every session and signature: the operating system's entropy.
    var secure: SecureRandom = .{ .io = init.io };
    // The CPU features the program detects once, for its codecs and for stdx.crypto alike.
    const features = stdx.platform.CpuFeatures.detect();
    // PSTATE.DIT on this thread, where the core has FEAT_DIT. Elsewhere the call changes nothing.
    _ = stdx.platform.set_data_independent_timing(features, true);
    const crypto = stdx.crypto.init(features, secure.random());

    var digest: [stdx.crypto.hash.sha256_len]u8 = undefined;
    try crypto.hash.sha256(&digest, "abc");
    const hex = std.fmt.bytesToHex(digest, .lower);
    if (!std.mem.eql(u8, &hex, abc_digest)) return error.WrongDigest;
}
