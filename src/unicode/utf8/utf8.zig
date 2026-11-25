//! utf8: RFC 3629's UTF-8, for the modules that read or write characters (decision 86, design §3).
//!
//! - `Validator` checks a text one octet at a time, and keeps a character that two calls split.
//!   `spec/lean/Stdx/Utf8.lean` proves it against RFC 3629 §4's syntax (decision 28).
//! - `character_len` gives the octets of the one character that starts a slice.
//! - `encoded_len`, `encode` and `encoded` write a code point as octets, and `decode` reads the
//!   code point of one checked character (RFC 3629 §3).
//!
//! The module imports nothing. `json` checks its strings with it and writes its `\u` escapes, and
//! `regex` reads a pattern's characters and writes the octets its programs take.
//!
//! ```zig
//! var validator: utf8.Validator = .{};
//! for (piece) |octet| {
//!     if (!validator.accept(octet)) return error.InvalidUtf8;
//! }
//! // At the text's end: validator.between_characters() says no character is cut.
//! ```

pub const constants = @import("constants.zig");

const validator = @import("validator.zig");
/// Where a check of UTF-8 stands between octets: `accept` takes the next octet, and
/// `between_characters` says whether a character is whole.
pub const Validator = validator.Validator;
/// The octets of the character that starts a slice, when the slice holds all of it and it is
/// UTF-8, or null.
pub const character_len = validator.character_len;

const encoding = @import("encoding.zig");
/// The octets of a code point's UTF-8 (RFC 3629 §3).
pub const encoded_len = encoding.encoded_len;
/// Writes a code point's UTF-8 into a slice of `encoded_len` octets.
pub const encode = encoding.encode;
/// A code point's UTF-8 as an array of a length the caller knows at compile time.
pub const encoded = encoding.encoded;
/// The code point of one whole character that the caller checked.
pub const decode = encoding.decode;

test {
    _ = constants;
    _ = validator;
    _ = encoding;
}
