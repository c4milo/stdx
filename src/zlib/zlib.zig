//! zlib: the container of RFC 1950 around a DEFLATE stream, with its Adler-32 (docs/design.md §3).
//! HTTP's `deflate` content coding and transfer coding name this format (RFC 9110 §8.4.1.2).
//!
//! No codec code is written until the owner rules on decisions 11 to 17.
