//! CRC-32 by Arm's CRC32 instructions: the aarch64 variant object of decision 21, compiled with
//! the CRC extension whatever the module's target, and called only when `Features.crc32` is set.
//! The instructions' polynomial is gzip's, in the reflected order of RFC 1952 §8, so each one
//! advances the register as crc32_table.update_register does, eight octets or one at a time.

const std = @import("std");

/// The octets one CRC32X instruction takes.
const word_len = @sizeOf(u64);

fn crc32_word(register: u32, word: u64) u32 {
    return asm ("crc32x %[out:w], %[register:w], %[word:x]"
        : [out] "=r" (-> u32),
        : [register] "r" (register),
          [word] "r" (word),
    );
}

fn crc32_octet(register: u32, octet: u8) u32 {
    return asm ("crc32b %[out:w], %[register:w], %[octet:w]"
        : [out] "=r" (-> u32),
        : [register] "r" (register),
          [octet] "r" (@as(u32, octet)),
    );
}

/// The CRC register after `len` octets from `register`, as crc32_table.update_register gives it.
export fn stdx_checksum_crc32_armv8(register: u32, octets_pointer: [*]const u8, len: usize) callconv(.c) u32 {
    const octets = octets_pointer[0..len];
    var value = register;
    var position: usize = 0;
    while (len - position >= word_len) : (position += word_len) {
        value = crc32_word(value, std.mem.readInt(u64, octets[position..][0..word_len], .little));
    }
    for (octets[position..]) |octet| value = crc32_octet(value, octet);
    return value;
}
