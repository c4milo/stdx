//! gzip: the container of RFC 1952 around a DEFLATE stream, with its CRC-32 and its length
//! (docs/design.md §3). HTTP's `gzip` content coding and transfer coding name this format
//! (RFC 9110 §8.4.1.3).
//!
//! No codec code is written until the owner rules on decisions 11 to 17.
