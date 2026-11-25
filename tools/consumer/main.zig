//! The READMEs' examples, as a program that depends on stdx the way the README says: build.zig
//! beside it holds the README's two lines. `zig build readme-check` builds it with a nested `zig
//! build` and runs it, and requires every Zig block of the README and of each module's README to
//! be an excerpt of this file or of build.zig (`tools/readme_examples.zig`). It exits 0 when each
//! example gives its answer.
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
    var decoder: stdx.compress.gzip.Decoder = undefined; // about 43 KiB
    decoder.init(features);
    const whole = try decoder.decode_all(body, output);
    return output[0..whole.written];
}

/// Decodes the gzip file that arrives as `pieces` into `output`, and returns the decoded bytes.
/// Each call takes the input and the room that the program has, and says what it needs next.
fn gunzip_pieces(features: stdx.platform.CpuFeatures, pieces: []const []const u8, output: []u8) ![]u8 {
    var decoder: stdx.compress.gzip.Decoder = undefined;
    decoder.init(features);
    var written: usize = 0;
    for (pieces) |piece| {
        const progress = try decoder.decode(piece, output[written..]);
        written += progress.written;
        switch (progress.status) {
            .needs_input => {},
            .needs_room => return error.NoSpaceLeft,
            .done => return output[0..written],
        }
    }
    return error.Truncated;
}

/// Decodes the zlib stream `body`, which HTTP names `deflate`, into `output`.
fn inflate(features: stdx.platform.CpuFeatures, body: []const u8, output: []u8) ![]u8 {
    var decoder: stdx.compress.zlib.Decoder = undefined; // about 43 KiB
    decoder.init(features);
    const whole = try decoder.decode_all(body, output);
    return output[0..whole.written];
}

/// Encodes `input` as one raw DEFLATE stream at level 9 into `output`, and returns the stream.
fn deflate_smallest(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures, input: []const u8, output: []u8) ![]u8 {
    const Encoder = stdx.compress.deflate.Encoder(.{ .level = 9 });
    const encoder = try gpa.create(Encoder); // about 293 KiB
    defer gpa.destroy(encoder);
    encoder.init(features);
    const len = try encoder.encode_all(input, output);
    return output[0..len];
}

/// Encodes `input` as one Zstandard frame at level 3, with its checksum, into `output`.
fn zstd_frame(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures, input: []const u8, output: []u8) ![]u8 {
    const Encoder = stdx.compress.zstd.Encoder(.{ .level = 3, .checksum = true });
    const encoder = try gpa.create(Encoder); // about 3.8 MiB
    defer gpa.destroy(encoder);
    encoder.init(features);
    const len = try encoder.encode_all(input, output);
    return output[0..len];
}

/// Decodes the Zstandard frames of `body` into `output`, within the window that HTTP allows.
fn unzstd(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures, body: []const u8, output: []u8) ![]u8 {
    const decoder = try gpa.create(stdx.compress.zstd.HttpDecoder); // about 8.3 MiB, its window included
    defer gpa.destroy(decoder);
    decoder.init(features);
    const whole = try decoder.decode_all(body, output);
    return output[0..whole.written];
}

/// Encodes `input` as one brotli stream at level 1 into `output`, and returns the stream.
fn brotli_stream(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures, input: []const u8, output: []u8) ![]u8 {
    const Encoder = stdx.compress.brotli.Encoder(.{});
    const encoder = try gpa.create(Encoder); // about 650 KiB
    defer gpa.destroy(encoder);
    encoder.init(features);
    const len = try encoder.encode_all(input, output);
    return output[0..len];
}

/// Decodes the brotli stream `body` into `output`, at any window that RFC 7932 allows.
fn unbrotli(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures, body: []const u8, output: []u8) ![]u8 {
    const decoder = try gpa.create(stdx.compress.brotli.HttpDecoder); // about 18.6 MiB, its window included
    defer gpa.destroy(decoder);
    decoder.init(features);
    const whole = try decoder.decode_all(body, output);
    return output[0..whole.written];
}

/// The CRC-32 of `bytes`, by the fastest path that the CPU runs.
fn crc32_of(features: stdx.platform.CpuFeatures, bytes: []const u8) u32 {
    const path = stdx.hash.Crc32Path.fastest(stdx.hash.Features.from(features));
    return stdx.hash.crc32(path, 0, bytes);
}

/// Writes `bytes` as base 64 into `output`, and returns the text.
fn base64_text(features: stdx.platform.CpuFeatures, bytes: []const u8, output: []u8) ![]u8 {
    var encoder: stdx.base64.Encoder = undefined;
    encoder.init(.{}, features);
    const len = try encoder.encode_all(bytes, output);
    return output[0..len];
}

/// Decodes the base 64 `letters` into `output`, in either alphabet, and returns the bytes.
fn base64_bytes(features: stdx.platform.CpuFeatures, letters: []const u8, output: []u8) ![]u8 {
    var decoder: stdx.base64.Decoder = undefined;
    decoder.init(.{}, features);
    const len = try decoder.decode_all(letters, output);
    return output[0..len];
}

/// Writes the JSON text `{"code":<code>,"message":"<message>"}` into `output`, and returns it.
fn write_event(features: stdx.platform.CpuFeatures, code: u64, message: []const u8, output: []u8) ![]const u8 {
    var writer = stdx.json.TextWriter.init(output, .text, features);
    try writer.begin_object();
    try writer.member_unsigned("code", code);
    try writer.member_string("message", message);
    try writer.end_object();
    return writer.written();
}

/// The string that the first member `name` with a string for its value holds in the JSON text
/// `json`, or null. `storage` takes the bytes of a string that the text escapes.
fn string_member(features: stdx.platform.CpuFeatures, json: []const u8, name: []const u8, storage: []u8) !?[]const u8 {
    var reader = stdx.json.TextReader.init(json, storage, .text, features);
    if (!reader.next_text()) return null;
    var named = false;
    while (try reader.next()) |item| {
        switch (item) {
            .name => |bytes| named = std.mem.eql(u8, bytes, name),
            .string => |bytes| if (named) return bytes,
            else => named = false,
        }
    }
    return null;
}

/// True when `bytes` is UTF-8 whole.
fn is_utf8(bytes: []const u8) bool {
    var validator: stdx.unicode.utf8.Validator = .{};
    for (bytes) |byte| {
        if (!validator.accept(byte)) return false;
    }
    return validator.between_characters();
}

/// True when the code point `scalar` has the property `name`, such as the script "Greek".
fn has_property(name: []const u8, scalar: u32) bool {
    const ranges = stdx.unicode.property(name) orelse return false;
    for (ranges) |range| {
        if (scalar >= range.lo and scalar <= range.hi) return true;
    }
    return false;
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

/// The text that the first capture group of `pattern` took in its first match in `haystack`, or
/// null where no match holds the group.
fn first_group(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures, pattern: []const u8, haystack: []const u8) !?[]const u8 {
    var storage: [instructions_len]stdx.regex.Instruction = undefined;
    const program = try stdx.regex.compile(pattern, .{}, &storage);
    const cache_words = stdx.regex.constants.cache_words_default;
    const memory = try gpa.alloc(u64, stdx.regex.Searcher.memory_len(program.forward_len, program.slot_count(), cache_words));
    defer gpa.free(memory);
    var searcher: stdx.regex.Searcher = undefined;
    searcher.init(&program, &.{ .features = features }, memory);
    const groups = searcher.captures(haystack, 0) orelse return null;
    const span = groups.get(1) orelse return null;
    return haystack[@intCast(span.start)..@intCast(span.end)];
}

/// The CRC-32 of "123456789", the check value of the CRC-32 that RFC 1952 §8 gives.
const crc32_of_digits = 0xCBF43926;

/// A code point of the Greek script, one of the Latin script before it, and one of the Han script
/// after it.
const greek_alpha = 0x3B1;
const latin_a = 0x61;
const han_one = 0x4E00;

/// A byte that starts no character of UTF-8, and the first byte alone of a character of two
/// (RFC 3629 §4).
const not_utf8 = [_]u8{0xFF};
const cut_character = [_]u8{0xC3};

/// A JSON text whose member `message` holds an array, and no string.
const event_with_array = "{\"message\":[1,\"x\"]}";

/// The code the JSON example writes, and the first byte of the gzip example's second piece.
const event_code = 1001;
const piece_split = 7;

/// The room each JSON and base 64 example writes into.
const small_room_len = 128;

fn check_deflate(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures) !void {
    const Gzip = stdx.compress.gzip.Encoder(.{});
    const gzip = try gpa.create(Gzip);
    defer gpa.destroy(gzip);
    gzip.init(features);
    var body: [Gzip.encoded_len_max(text.len)]u8 = undefined;
    const body_len = try gzip.encode_all(text, &body);
    var output: [text.len]u8 = undefined;
    const decoded = try gunzip(features, body[0..body_len], &output);
    if (!std.mem.eql(u8, decoded, text)) return error.GunzipGaveOtherOctets;
    const pieces = [_][]const u8{ body[0..piece_split], body[piece_split..body_len] };
    if (!std.mem.eql(u8, try gunzip_pieces(features, &pieces, &output), text)) return error.PiecesGaveOtherBytes;

    const Zlib = stdx.compress.zlib.Encoder(.{});
    const zlib = try gpa.create(Zlib);
    defer gpa.destroy(zlib);
    zlib.init(features);
    var stream: [Zlib.encoded_len_max(text.len)]u8 = undefined;
    const stream_len = try zlib.encode_all(text, &stream);
    if (!std.mem.eql(u8, try inflate(features, stream[0..stream_len], &output), text)) return error.InflateGaveOtherBytes;

    var raw: [stdx.compress.deflate.Encoder(.{ .level = 9 }).encoded_len_max(text.len)]u8 = undefined;
    const smallest = try deflate_smallest(gpa, features, text, &raw);
    var decoder: stdx.compress.deflate.Decoder = undefined;
    decoder.init(features);
    const whole = try decoder.decode_all(smallest, &output);
    if (!std.mem.eql(u8, output[0..whole.written], text)) return error.DeflateGaveOtherBytes;
}

fn check_zstd_and_brotli(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures) !void {
    var output: [text.len]u8 = undefined;
    var frame: [stdx.compress.zstd.Encoder(.{ .level = 3, .checksum = true }).encoded_len_max(text.len)]u8 = undefined;
    const zstd = try zstd_frame(gpa, features, text, &frame);
    if (!std.mem.eql(u8, try unzstd(gpa, features, zstd, &output), text)) return error.ZstdGaveOtherBytes;
    var stream: [stdx.compress.brotli.Encoder(.{}).encoded_len_max(text.len)]u8 = undefined;
    const brotli = try brotli_stream(gpa, features, text, &stream);
    if (!std.mem.eql(u8, try unbrotli(gpa, features, brotli, &output), text)) return error.BrotliGaveOtherBytes;
}

fn check_data(features: stdx.platform.CpuFeatures) !void {
    if (crc32_of(features, "123456789") != crc32_of_digits) return error.Crc32Differs;
    var letters: [small_room_len]u8 = undefined;
    var bytes: [small_room_len]u8 = undefined;
    const encoded = try base64_text(features, text, &letters);
    if (!std.mem.eql(u8, try base64_bytes(features, encoded, &bytes), text)) return error.Base64GaveOtherBytes;
    var room: [small_room_len]u8 = undefined;
    const event = try write_event(features, event_code, "disk full", &room);
    if (!std.mem.eql(u8, event, "{\"code\":1001,\"message\":\"disk full\"}")) return error.JsonTextDiffers;
    const message = try string_member(features, event, "message", &bytes) orelse return error.JsonHoldsNoMessage;
    if (!std.mem.eql(u8, message, "disk full")) return error.JsonMessageDiffers;
    if (try string_member(features, event_with_array, "message", &bytes) != null) return error.JsonGaveAnArraysString;
}

fn check_text(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures) !void {
    if (!is_utf8(text) or is_utf8(&not_utf8) or is_utf8(&cut_character)) return error.Utf8VerdictDiffers;
    if (!has_property("Greek", greek_alpha)) return error.ScriptDiffers;
    if (has_property("Greek", latin_a) or has_property("Greek", han_one)) return error.ScriptDiffers;
    if (has_property("NoSuchScript", greek_alpha)) return error.ScriptDiffers;
    const codes = try count_matches(gpa, features, "E[0-9]{4}", log);
    if (codes != log_codes) return error.CountDiffers;
    const code = try first_group(gpa, features, "E([0-9]{4})", log) orelse return error.NoGroup;
    if (!std.mem.eql(u8, code, "1001")) return error.GroupDiffers;
}

pub fn main(init: std.process.Init) !void {
    const features = stdx.platform.CpuFeatures.detect();
    try check_deflate(init.gpa, features);
    try check_zstd_and_brotli(init.gpa, features);
    try check_data(features);
    try check_text(init.gpa, features);
}
