//! bench-base64's Rust baseline: the `base64` crate's standard engine, with pad characters,
//! behind a C ABI. Each call encodes or decodes one whole text into the caller's buffer.

use base64::engine::general_purpose::STANDARD;
use base64::Engine;

/// Encodes `len` octets at `input` into `output`, which holds `room` octets. Returns the letters
/// written, or `usize::MAX` when they do not fit.
#[no_mangle]
pub unsafe extern "C" fn rust_base64_encode(input: *const u8, len: usize, output: *mut u8, room: usize) -> usize {
    let input = std::slice::from_raw_parts(input, len);
    let output = std::slice::from_raw_parts_mut(output, room);
    STANDARD.encode_slice(input, output).unwrap_or(usize::MAX)
}

/// Decodes `len` letters at `text` into `output`, which holds `room` octets. Returns the octets
/// written, or `usize::MAX` when the text is refused or does not fit.
#[no_mangle]
pub unsafe extern "C" fn rust_base64_decode(text: *const u8, len: usize, output: *mut u8, room: usize) -> usize {
    let text = std::slice::from_raw_parts(text, len);
    let output = std::slice::from_raw_parts_mut(output, room);
    STANDARD.decode_slice(text, output).unwrap_or(usize::MAX)
}
