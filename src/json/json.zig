//! json: JSON texts (RFC 8259) and JSON text sequences (RFC 7464), an encoder and a decoder with no
//! heap and no I/O (decision 27, docs/design.md §3).
//!
//! - `Encoder` writes a text from tokens, one call a token or several, placing the separators and
//!   escaping strings (RFC 8259 §7). `TextWriter` is its whole-buffer helper.
//! - `Decoder` reads a text one token a call, and writes each name's and string's octets,
//!   unescaped, and each number's text into the caller's output. `TextReader` is its whole-buffer
//!   helper.
//! - `Framing` chooses one text or a text of a sequence (RFC 7464).
//! - `claims` switches the vector paths of decision 27 for the tests and the benchmark.

pub const constants = @import("constants.zig");
pub const claims = @import("claims.zig");
pub const Claims = claims.Claims;
pub const Framing = @import("framing.zig").Framing;
pub const Decimal = @import("format.zig").Decimal;

const encoder = @import("encoder/encoder.zig");
pub const Encoder = encoder.Encoder;
pub const Token = encoder.Token;
pub const Piece = encoder.Piece;
pub const EncodeError = encoder.Error;
pub const TextWriter = @import("encoder/text_writer.zig").TextWriter;

const decoder = @import("decoder/decoder.zig");
pub const Decoder = decoder.Decoder;
pub const Kind = decoder.Kind;
pub const Status = decoder.Status;
pub const Progress = decoder.Progress;
pub const Corrupt = decoder.Corrupt;
pub const Unsupported = decoder.Unsupported;
pub const DecodeError = decoder.Error;
pub const refusal = decoder.refusal;
const text_reader = @import("decoder/text_reader.zig");
pub const TextReader = text_reader.TextReader;
pub const Item = text_reader.Item;

test {
    _ = constants;
    _ = claims;
    _ = @import("utf8.zig");
    _ = @import("scan.zig");
    _ = @import("wide.zig");
    _ = @import("number.zig");
    _ = @import("containers.zig");
    _ = @import("format.zig");
    _ = encoder;
    _ = @import("encoder/text_writer.zig");
    _ = decoder;
    _ = text_reader;
    _ = @import("round_trip_test.zig");
}
