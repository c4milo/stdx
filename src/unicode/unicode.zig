//! unicode: Unicode 17.0.0's general categories, scripts and simple case folding, and UTF-8 beside
//! them, for the modules that read characters (decision 86 as amended, design §3).
//!
//! - `property` gives the ranges of the property a name names: a General_Category value, a group
//!   of them, a Script, or Any, ASCII or Assigned (UTS #18 RL1.2).
//! - `simple_fold` gives the next code point of a code point's case orbit, and `images` the next
//!   code points of a range's, for a match without case (UTS #18 RL1.5).
//! - `utf8` is RFC 3629's UTF-8, the module of its own name.
//!
//! tools/unicode/unicode_tables.zig writes the tables, unicode_tables.zig, from the data files of
//! tools/unicode/ucd/, and `zig build test` fails when the file differs from what they give.
//!
//! ```zig
//! const greek = unicode.property("Greek").?;
//! // greek[0] is .{ .lo = 0x370, .hi = 0x373 }.
//! const next = unicode.simple_fold('k'); // U+212A KELVIN SIGN
//! ```

pub const constants = @import("constants.zig");

/// RFC 3629's UTF-8.
pub const utf8 = @import("utf8");

const tables = @import("unicode_tables.zig");
/// The version of the Unicode Character Database the tables come from: "17.0.0".
pub const version = tables.version;

const entries = @import("entries.zig");
/// The first and the last code point of a range.
pub const Range = entries.Range;

const property_file = @import("property.zig");
/// The ranges of the property a name names, in order and apart, or null.
pub const property = property_file.property;

const fold = @import("fold.zig");
/// The next code point of a code point's case orbit.
pub const simple_fold = fold.simple_fold;
/// The ranges of the next code points of a range's code points, one a call.
pub const images = fold.images;
pub const Images = fold.Images;

test {
    _ = constants;
    _ = property_file;
    _ = fold;
}

test "the module names what its header lists" {
    const std = @import("std");
    try std.testing.expectEqualStrings("17.0.0", version);
    try std.testing.expectEqual(@as(u32, 0x370), property("Greek").?[0].lo);
    try std.testing.expectEqual(@as(u32, 0x212A), simple_fold('k'));
    try std.testing.expect(@hasDecl(utf8, "Validator"));
}
