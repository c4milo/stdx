//! What bench-json's baselines and stdx share across the C ABI (decision 27): a decode's tally,
//! which every candidate must give alike before any is timed, and a token of a text to encode.
//! `baselines.h` declares the same layout for C and C++.

/// What a decode of a text found: the work every candidate does, counted the same way.
pub const Tally = extern struct {
    /// Objects and arrays.
    containers: u64 = 0,
    /// Names and strings.
    strings: u64 = 0,
    /// The octets of every name and string, unescaped into UTF-8.
    string_len: u64 = 0,
    numbers: u64 = 0,
    /// `true`, `false` and `null`.
    literals: u64 = 0,
};

/// A token's kind, as `baselines.h` numbers it.
pub const Kind = enum(u8) {
    begin_object,
    end_object,
    begin_array,
    end_array,
    name,
    string,
    /// A hex string: two lowercase digits for each octet of `octets`.
    hex,
    /// A number's text, in `octets`.
    number,
    unsigned,
    signed,
    /// A fixed-point decimal: `integer`, `fraction` and `fraction_digits`, negative or not.
    decimal,
    false,
    true,
    null,
};

/// One token of a text to encode.
pub const Token = extern struct {
    kind: Kind,
    fraction_digits: u8 = 0,
    negative: bool = false,
    /// Whether a number's text is an integer that `integer` holds, with `negative` its sign.
    integral: bool = false,
    octets: [*]const u8 = "",
    len: usize = 0,
    /// An unsigned value, a signed one's two's complement bits, a decimal's integer part, or an
    /// integral number's magnitude.
    integer: u64 = 0,
    fraction: u64 = 0,
    /// A number's or a decimal's value, for a baseline that writes numbers from values.
    real: f64 = 0,
};
