//! bench-regex's Rust baseline: the `regex` crate's `bytes::Regex`, behind a C ABI. A pattern is
//! compiled once into a handle, and each call takes one whole haystack, or a batch of texts and
//! the offset where each ends, so that a call's own cost is small beside its work.

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

/// Finds the matches of the pattern in `len` octets of haystack, none inside another. Returns their
/// count, and writes the sum of each match's start and end to `offsets`. Taking both ends keeps
/// the crate from the search that `find_iter().count()` runs, which finds each match's end alone.
#[no_mangle]
pub unsafe extern "C" fn rust_regex_find_all(regex: *const Regex, haystack: *const u8, len: usize, offsets: *mut u64) -> usize {
    let haystack = std::slice::from_raw_parts(haystack, len);
    let mut count = 0usize;
    let mut sum = 0u64;
    for found in (*regex).find_iter(haystack) {
        count += 1;
        sum += (found.start() + found.end()) as u64;
    }
    *offsets = sum;
    count
}

/// The texts of a batch: `ends.len()` texts, one after another in `octets`, each ending at its
/// offset of `ends`.
struct Texts<'a> {
    octets: &'a [u8],
    ends: &'a [u32],
    index: usize,
    start: usize,
}

impl<'a> Iterator for Texts<'a> {
    type Item = &'a [u8];

    fn next(&mut self) -> Option<&'a [u8]> {
        let end = *self.ends.get(self.index)? as usize;
        let text = &self.octets[self.start..end];
        self.start = end;
        self.index += 1;
        Some(text)
    }
}

unsafe fn texts<'a>(octets: *const u8, ends: *const u32, count: usize) -> Texts<'a> {
    let ends = std::slice::from_raw_parts(ends, count);
    let len = ends.last().map_or(0, |&end| end as usize);
    Texts { octets: std::slice::from_raw_parts(octets, len), ends, index: 0, start: 0 }
}

/// Counts the texts of a batch that the pattern matches.
#[no_mangle]
pub unsafe extern "C" fn rust_regex_matching(regex: *const Regex, octets: *const u8, ends: *const u32, count: usize) -> usize {
    let regex = &*regex;
    texts(octets, ends, count).filter(|text| regex.is_match(text)).count()
}

/// Sums the start and the end of each group of the first match in each text of a batch. A group
/// that took no part adds nothing.
#[no_mangle]
pub unsafe extern "C" fn rust_regex_groups(regex: *const Regex, octets: *const u8, ends: *const u32, count: usize) -> usize {
    let regex = &*regex;
    let mut locations = regex.capture_locations();
    let mut sum = 0usize;
    for text in texts(octets, ends, count) {
        if regex.captures_read(&mut locations, text).is_some() {
            for group in 0..locations.len() {
                if let Some((start, end)) = locations.get(group) {
                    sum += start + end;
                }
            }
        }
    }
    sum
}
