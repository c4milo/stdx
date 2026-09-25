//! checksum: the three checks the formats carry (docs/design.md §3).
//!
//! - CRC-32, the gzip member's check (RFC 1952 §2.3.1, with sample code in §8).
//! - Adler-32, the zlib stream's check (RFC 1950 §2.2, with sample code in §9).
//! - XXH64, whose low 32 bits are a zstd frame's Content_Checksum (RFC 8878 §3.1.1).
//!
//! Each lands with the first codec that needs it (design §8). The module imports nothing.
//!
//! Each check has several paths, and the caller picks one per stream with `fastest`, from the
//! `Features` it copied out of its `codec.Features` (decision 21):
//!
//! ```zig
//! const path = checksum.Crc32Path.fastest(.{
//!     .pclmul = features.pclmul,
//!     .crc32 = features.crc32,
//!     .pmull = features.pmull,
//! });
//! crc = checksum.crc32(path, crc, written);
//! ```

const crc32_module = @import("crc32.zig");
const adler32_module = @import("adler32.zig");

pub const constants = @import("constants.zig");
pub const Features = @import("features.zig").Features;

pub const Crc32Path = crc32_module.Crc32Path;
/// RFC 1952 §8's update_crc, by a path: the CRC-32 after the octets, from the CRC-32 before them.
pub const crc32 = crc32_module.update;

pub const Adler32Path = adler32_module.Adler32Path;
/// RFC 1950 §9's update_adler32, by a path: the Adler-32 after the octets, from the Adler-32
/// before them.
pub const adler32 = adler32_module.update;

test {
    _ = crc32_module;
    _ = adler32_module;
    _ = @import("crc32_table.zig");
}
