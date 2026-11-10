//! base64: RFC 4648's base 64 encoding (§4) and its URL and filename safe alphabet (§5), an encoder
//! and a decoder (decision 68, design §3).
//!
//! The decoder takes either alphabet in one pass and says which one a text used. It refuses a text
//! that mixes them, any octet outside them, and any final quantum whose unused bits are not zero, so
//! each octet string has one text that decodes to it.

pub const constants = @import("constants.zig");

const alphabet = @import("alphabet.zig");
pub const Alphabet = alphabet.Alphabet;

const encoder = @import("encoder.zig");
pub const Encoder = encoder.Encoder;
pub const EncoderOptions = encoder.EncoderOptions;
pub const EncoderClaims = encoder.Claims;

const decoder = @import("decoder.zig");
pub const Decoder = decoder.Decoder;
pub const DecoderOptions = decoder.DecoderOptions;
pub const DecoderClaims = decoder.Claims;
pub const Accept = decoder.Accept;
pub const Padding = decoder.Padding;
pub const Piece = decoder.Piece;
pub const Error = decoder.Error;
pub const refusal = decoder.refusal;

test {
    _ = constants;
    _ = alphabet;
    _ = encoder;
    _ = decoder;
    _ = @import("fast.zig");
    _ = @import("base64_test.zig");
    _ = @import("base64_fuzz_test.zig");
}
