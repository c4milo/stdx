//! The README's examples, as a program that depends on stdx the way the README says: build.zig
//! beside it holds the README's two lines. `zig build readme-check` builds it with a nested `zig
//! build` and runs it, and requires every Zig block of the README to be an excerpt of this file or
//! of build.zig (`tools/readme_examples.zig`). It exits 0 when each example gives its answer.
const std = @import("std");
const stdx = @import("stdx");

/// The text the gzip example encodes and decodes again.
const text = "stdx decodes what it encodes, octet for octet.\n";

/// The log the regex example searches.
const log =
    \\12:00:01 E1001 disk full
    \\12:00:02 ok
    \\12:00:03 E2002 retried, then E2003
    \\
;

/// The error codes in `log`.
const log_codes = 3;

/// The instructions a pattern of the regex example may take.
const instructions_len = 256;

/// Decodes the gzip file `body` into `output`, and returns the decoded octets.
fn gunzip(features: stdx.platform.CpuFeatures, body: []const u8, output: []u8) ![]u8 {
    var decoder: stdx.compress.gzip.Decoder = undefined; // about 44 KiB
    decoder.init(features);
    const whole = try decoder.decode_all(body, output);
    return output[0..whole.written];
}

/// Counts the matches of `pattern` in `haystack`. The program gives the searcher its memory: 4 MiB
/// of it is the default cache, and a smaller cache costs speed, never an answer.
fn count_matches(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures, pattern: []const u8, haystack: []const u8) !u64 {
    var storage: [instructions_len]stdx.regex.Instruction = undefined;
    const program = try stdx.regex.compile(pattern, .{}, &storage);
    const cache_words = stdx.regex.constants.cache_words_default;
    const memory = try gpa.alloc(u64, stdx.regex.Searcher.memory_len(program.forward_len, program.slot_count(), cache_words));
    defer gpa.free(memory);
    var searcher: stdx.regex.Searcher = undefined;
    searcher.init(&program, &.{ .features = features }, memory);
    var matches: stdx.regex.Matches = .{ .searcher = &searcher, .haystack = haystack };
    return matches.count();
}

pub fn main(init: std.process.Init) !void {
    const features = stdx.platform.CpuFeatures.detect();
    const Encoder = stdx.compress.gzip.Encoder(.{});
    const encoder = try init.gpa.create(Encoder);
    defer init.gpa.destroy(encoder);
    encoder.init(features);
    var body: [Encoder.encoded_len_max(text.len)]u8 = undefined;
    const body_len = try encoder.encode_all(text, &body);
    var output: [text.len]u8 = undefined;
    const decoded = try gunzip(features, body[0..body_len], &output);
    if (!std.mem.eql(u8, decoded, text)) return error.GunzipGaveOtherOctets;
    const codes = try count_matches(init.gpa, features, "E[0-9]{4}", log);
    if (codes != log_codes) return error.CountDiffers;
}
