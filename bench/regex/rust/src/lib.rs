//! bench-regex's Rust baseline: the `regex` crate's `bytes::Regex`, behind a C ABI. A pattern is
//! compiled once into a handle, and each call takes one whole haystack, or a batch of texts with
//! a line feed after each, so that a call's own cost is small beside its work.

use regex::bytes::Regex;

/// Compiles `len` octets of pattern. Returns a handle, or null when the crate refuses the pattern.
#[no_mangle]
pub unsafe extern "C" fn rust_regex_new(pattern: *const u8, len: usize) -> *mut Regex {
    let pattern = std::slice::from_raw_parts(pattern, len);
    let Ok(pattern) = std::str::from_utf8(pattern) else {
        return std::ptr::null_mut();
    };
    match Regex::new(pattern) {
        Ok(regex) => Box::into_raw(Box::new(regex)),
        Err(_) => std::ptr::null_mut(),
    }
}

/// Frees a handle of `rust_regex_new`.
#[no_mangle]
pub unsafe extern "C" fn rust_regex_free(regex: *mut Regex) {
    if !regex.is_null() {
        drop(Box::from_raw(regex));
    }
}

/// Counts the matches of the pattern in `len` octets of haystack, none inside another.
#[no_mangle]
pub unsafe extern "C" fn rust_regex_count(regex: *const Regex, haystack: *const u8, len: usize) -> usize {
    let haystack = std::slice::from_raw_parts(haystack, len);
    (*regex).find_iter(haystack).count()
}

/// Counts the texts the pattern matches, of the texts in `len` octets, a line feed after each.
#[no_mangle]
pub unsafe extern "C" fn rust_regex_matching(regex: *const Regex, texts: *const u8, len: usize) -> usize {
    let texts = std::slice::from_raw_parts(texts, len);
    let regex = &*regex;
    texts.split_inclusive(|&octet| octet == b'\n').filter(|text| regex.is_match(&text[..text.len() - 1])).count()
}

/// Sums the start and the end of each group of the first match in each text, of the texts in
/// `len` octets, a line feed after each. A group that took no part adds nothing.
#[no_mangle]
pub unsafe extern "C" fn rust_regex_groups(regex: *const Regex, texts: *const u8, len: usize) -> usize {
    let texts = std::slice::from_raw_parts(texts, len);
    let regex = &*regex;
    let mut locations = regex.capture_locations();
    let mut sum = 0usize;
    for text in texts.split_inclusive(|&octet| octet == b'\n') {
        if regex.captures_read(&mut locations, &text[..text.len() - 1]).is_some() {
            for group in 0..locations.len() {
                if let Some((start, end)) = locations.get(group) {
                    sum += start + end;
                }
            }
        }
    }
    sum
}
