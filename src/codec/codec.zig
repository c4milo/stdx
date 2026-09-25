//! codec: the streaming contract every codec in stdx shares (docs/design.md §3).
//!
//! Decision 11 proposes what this module holds: the status a call ends with (`needs_input`,
//! `needs_room`, `done`), the counts a call reports, the flush modes an encoder takes, and the
//! checked reader, writer and bit readers every codec parses and writes through. It also proposes
//! that this module exist at all, beside the six the owner named. Nothing is written here until
//! the owner rules on it.
//!
//! The module imports nothing.
