//! checksum: the three checks the formats carry (docs/design.md §3).
//!
//! - CRC-32, the gzip member's check (RFC 1952 §2.3.1, with sample code in §8).
//! - Adler-32, the zlib stream's check (RFC 1950 §2.2, with sample code in §9).
//! - XXH64, whose low 32 bits are a zstd frame's Content_Checksum (RFC 8878 §3.1.1).
//!
//! Each lands with the first codec that needs it (design §8). The module imports nothing.
