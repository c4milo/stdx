//! The unicode module's named limits (CLAUDE.md, Non-negotiables). Each one's test pins it to the
//! tables, so a new version of the Unicode Character Database that moves one fails it.

const utf8 = @import("utf8");

/// The largest code point: the codespace runs from 0 to 10FFFF, the last one UTF-8 writes (RFC
/// 3629 §3).
pub const code_point_max = utf8.constants.code_point_max;

/// The longest name `property` compares, after it drops the space, `_` and `-`: the Script
/// Inscriptional_Parthian, of 21 letters. A longer name names no property, so the lookup reads it
/// into storage of this length.
pub const property_name_len_max = 21;

/// The most code points one case orbit of the simple case folding holds. Three orbits hold four:
/// one of them is θ, ϑ, Θ and ϴ, which fold to θ. A caller that adds the next code point of each
/// code point of a set `orbit_len_max - 1` times holds each whole orbit.
pub const orbit_len_max = 4;
