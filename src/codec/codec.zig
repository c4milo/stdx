//! codec: the streaming contract every codec in stdx shares (docs/design.md §3).
//!
//! Decision 11 rules what this module holds: the status a call ends with (`needs_input`,
//! `needs_room`, `done`), the counts a call reports, the flush modes an encoder takes, the two
//! classes of refusal, and the checked reader, writer and bit readers every codec parses and
//! writes through. Design §8 step 3 writes it.
//!
//! The module imports nothing.
