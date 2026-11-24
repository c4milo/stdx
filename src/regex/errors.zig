//! Every way `compile` refuses a pattern (decision 86).
const std = @import("std");
const codec = @import("codec");

/// The pattern breaks the syntax: RFC 9485 §3's grammar with the forms decision 86 adds, or RFC
/// 3629's UTF-8.
pub const Corrupt = error{
    /// The pattern is not UTF-8.
    InvalidUtf8,
    /// A `)` with no group open.
    UnmatchedParenthesis,
    /// A group with no `)`.
    MissingParenthesis,
    /// A class with no `]`.
    MissingBracket,
    /// A class that holds a `[` which starts none of RE2's named classes, such as `[:alpha:]`.
    InvalidClass,
    /// A range of a class whose ends are out of order, or not two characters.
    InvalidClassRange,
    /// A quantifier with nothing before it to repeat.
    MissingOperand,
    /// A quantifier after a quantifier.
    NestedQuantifier,
    /// A `{` that starts no range quantifier, or one whose counts are out of order.
    InvalidQuantifier,
    /// A reverse solidus before a character that it gives no meaning.
    InvalidEscape,
    /// A `\x` escape that names no Unicode scalar value.
    InvalidScalarValue,
    /// A `\p` or a `\P` that names no property of Unicode 17.0.0, or whose `{` has no `}`.
    InvalidProperty,
    /// A `(?` that starts no group stdx knows.
    InvalidGroup,
    /// A `(?P<` or a `(?<` whose name is empty, holds a character that is not a letter, a digit
    /// or `_`, or has no `>`.
    InvalidGroupName,
    /// A name that two groups hold.
    DuplicateGroupName,
    /// A `]` or a `}` with no reverse solidus before it and nothing to close.
    UnescapedCharacter,
};

/// The pattern uses a form stdx refuses, or passes a limit of `constants`.
pub const Unsupported = error{
    /// A count past `repeat_max`, or nested counts whose product passes it.
    RepeatTooLarge,
    /// Groups nested past `depth_max`.
    DepthTooLarge,
    /// A class of more ranges than `class_ranges_max`.
    ClassTooLarge,
    /// More capture groups than `groups_max`.
    GroupsTooMany,
    /// `\1` to `\9` with no octal digit after it: no automaton of a fixed size matches a
    /// backreference.
    UnsupportedBackreference,
    /// `(?=`, `(?!`, `(?<=` or `(?<!`.
    UnsupportedLookaround,
    /// A group's name longer than `group_name_len_max`.
    GroupNameTooLong,
    /// More named groups than `group_names_max`.
    GroupNamesTooMany,
    /// Under `Encoding.bytes`, where an escape names one byte and a byte past 0x7F has no
    /// class: an escape past `\xFF`, `\p` or `\P`, or a character past U+007F in a class.
    UnsupportedUnicode,
};

/// Every error `compile` returns. `NoSpaceLeft` says the program does not fit the storage the
/// caller gave: an operational error, and no refusal of the pattern.
pub const Error = Corrupt || Unsupported || error{NoSpaceLeft};

/// Every refusal of a pattern.
pub const Refused = Corrupt || Unsupported;

/// The class of a refusal (decision 11).
pub fn refusal(err: Refused) codec.Refusal {
    inline for (@typeInfo(Unsupported).error_set orelse &.{}) |unsupported| {
        if (err == @field(anyerror, unsupported.name)) return .unsupported;
    }
    return .corrupt;
}

const testing = std.testing;

test "refusal names a limit and a refused form unsupported, and a broken pattern corrupt" {
    try testing.expectEqual(codec.Refusal.unsupported, refusal(error.RepeatTooLarge));
    try testing.expectEqual(codec.Refusal.unsupported, refusal(error.UnsupportedLookaround));
    try testing.expectEqual(codec.Refusal.unsupported, refusal(error.GroupNamesTooMany));
    try testing.expectEqual(codec.Refusal.corrupt, refusal(error.DuplicateGroupName));
    try testing.expectEqual(codec.Refusal.corrupt, refusal(error.InvalidUtf8));
    try testing.expectEqual(codec.Refusal.corrupt, refusal(error.MissingParenthesis));
    try testing.expectEqual(codec.Refusal.corrupt, refusal(error.UnescapedCharacter));
}
