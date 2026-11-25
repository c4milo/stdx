//! How the encoder and the decoder delimit texts: one JSON text (RFC 8259 §2), or a JSON text
//! sequence (RFC 7464); and how a caller says where the octets of a token or of a text end.

/// Whether a call's input holds the last of its octets: the encoder's name, string, hex string or
/// number, or the decoder's text. A text says where it ends only when its value is an object, an
/// array or a string, so the decoder learns the rest from the caller (decision 27).
pub const Piece = enum {
    /// More octets follow in a later call.
    more,
    /// The call's input holds the last of them.
    last,
};

/// How a text is delimited.
pub const Framing = enum {
    /// One JSON text, `ws value ws` (RFC 8259 §2). The decoder learns where it ends from the
    /// caller, since a number or trailing whitespace can go on in the next call.
    text,
    /// One text of a JSON text sequence (RFC 7464): the encoder writes RS, the text and LF
    /// (§2.2), and the decoder reads one or more RS, then the octets up to the next RS as a text
    /// (§2.1).
    sequence,
};
