//! The reading of a pattern that `literal_trie.zig` takes as a trie (decision 86 as amended):
//! whether it is an alternation of literals and nothing else, each alone or in `(?:` and `)`,
//! and each literal's octets once its escapes are read. It reads each character as the parser
//! does, so the two take the same patterns.
const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const utf8 = @import("utf8");
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const utf8_ranges = @import("utf8_ranges.zig");
const Instruction = program_file.Instruction;

/// A literal's octets in the storage past the program: its first `key_octets` octets in the
/// order the trie reads them, the most significant first, where they start, how many, and the
/// literal's place in the pattern. Two literals whose keys differ sort by their keys alone.
pub const Entry = extern struct { key: u64 align(@alignOf(Instruction)), offset: u32, len: u32, index: u32 };

/// The octets an entry's key holds.
const key_octets = @sizeOf(u64);

/// True when the pattern holds more than `literal_set_max` of `|`: a cheap test before the scan.
pub fn may_be_alternation(pattern: []const u8) bool {
    var bars: usize = 0;
    for (pattern) |octet| bars += @intFromBool(octet == '|');
    return bars >= constants.literal_set_max;
}

/// The literals of an alternation, and their octets in all, once each escape is read.
pub const Shape = struct { count: u32, octets_len: u32, depth: u32 };

/// The shape of the pattern where it is literals, each alone or in `(?:` and `)`, joined by `|`,
/// with no empty one. Null where it is anything else.
pub fn scan(pattern: []const u8) ?Shape {
    var reader = codec.Reader.init(pattern);
    var shape: Shape = .{ .count = 0, .octets_len = 0, .depth = 0 };
    // Each turn reads one literal and the `|` after it, so the turns are at most the octets.
    for (0..pattern.len + 1) |_| {
        const len = literal_len(&reader) orelse return null;
        if (len == 0) return null;
        shape.count += 1;
        shape.octets_len += len;
        shape.depth = @max(shape.depth, len);
        const next = utf8_ranges.take_scalar(&reader) catch return null;
        if (next == null) return shape;
        if (next.? != '|') return null;
    }
    return null;
}

/// The octets of the literal the reader stands at, once its escapes are read, with the reader
/// past it and before the `|` or the end after it. Null where it is no literal.
fn literal_len(reader: *codec.Reader) ?u32 {
    const grouped = starts_group(reader);
    var len: u32 = 0;
    // Each turn reads one character, at most the pattern's.
    for (0..reader.octets.len + 1) |_| {
        switch (next_character(reader, grouped)) {
            .end => return len,
            .invalid => return null,
            .scalar => |scalar| len += @intCast(utf8.encoded_len(@intCast(scalar))),
        }
    }
    return null;
}

/// What the next character of a literal is: a scalar the literal holds, its end, or no literal.
const Character = union(enum) { scalar: u32, end, invalid };

/// Reads the next character of a literal, which `grouped` says starts with `(?:`. At its end, the
/// reader stands before the `|` after it, or past the `)` that closes its group.
fn next_character(reader: *codec.Reader, grouped: bool) Character {
    const before = reader.position;
    const scalar = take_scalar(reader) catch return .invalid;
    if (scalar == null) return if (grouped) .invalid else .end;
    return judge(reader, scalar.?, grouped, before);
}

/// The next scalar value of the pattern, as `utf8_ranges.take_scalar` reads it: an octet under
/// 0x80 is a scalar value of its own, and needs no decoder.
fn take_scalar(reader: *codec.Reader) utf8_ranges.DecodeError!?u32 {
    const ahead = reader.take_partial(1);
    if (ahead.len == 0) return null;
    if (ahead[0] <= constants.one_octet_max) return ahead[0];
    reader.unread(1);
    return utf8_ranges.take_scalar(reader);
}

fn judge(reader: *codec.Reader, scalar: u32, grouped: bool, before: usize) Character {
    if (scalar == '|') {
        reader.position = before;
        return if (grouped) .invalid else .end;
    }
    if (scalar == ')') return if (grouped) .end else .invalid;
    return .{ .scalar = literal_of(reader, scalar) orelse return .invalid };
}

/// Reads a `(?:` the reader stands at. True where it did.
fn starts_group(reader: *codec.Reader) bool {
    const opener = "(?:";
    const ahead = reader.take_partial(opener.len);
    if (std.mem.eql(u8, ahead, opener)) return true;
    reader.unread(ahead.len);
    return false;
}

/// The scalar a character of a literal stands for: itself, or after a `\` the punctuation that
/// follows it, as the parser reads both. Null for any other character of the syntax.
fn literal_of(reader: *codec.Reader, scalar: u32) ?u32 {
    switch (scalar) {
        '(', ')', '|', '*', '+', '?', '{', '[', '.', '^', '$', ']', '}' => return null,
        '\\' => {
            const escaped = (utf8_ranges.take_scalar(reader) catch return null) orelse return null;
            return switch (escaped) {
                '!'...'/', ':'...'@', '['...'`', '{'...'~' => escaped,
                else => null,
            };
        },
        else => return scalar,
    }
}

/// Reads each literal of the pattern again into `octets`, and its place into its entry.
pub fn write_literals(pattern: []const u8, octets: []u8, entries: []Entry, reverse: bool) void {
    var reader = codec.Reader.init(pattern);
    var writer = codec.Writer.init(octets);
    for (entries, 0..) |*entry, index| {
        const offset = writer.written().len;
        write_literal(&reader, &writer);
        const literal = writer.written()[offset..];
        entry.* = .{ .key = key_of(literal, reverse), .offset = @intCast(offset), .len = @intCast(literal.len), .index = @intCast(index) };
        // The `|` before the next literal.
        if (index + 1 < entries.len) assert((utf8_ranges.take_scalar(&reader) catch unreachable).? == '|');
    }
    assert(writer.written().len == octets.len);
}

/// Writes the octets of the literal the reader stands at, which `scan` read as one before, and
/// which `scan` measured for the writer.
fn write_literal(reader: *codec.Reader, writer: *codec.Writer) void {
    const grouped = starts_group(reader);
    // Each turn reads one character, at most the pattern's.
    for (0..reader.octets.len + 1) |_| {
        switch (next_character(reader, grouped)) {
            .end => return,
            .invalid => unreachable,
            .scalar => |scalar| {
                var octets: [constants.utf8_len_max]u8 = undefined;
                const len = utf8.encoded_len(@intCast(scalar));
                utf8.encode(@intCast(scalar), octets[0..len]);
                writer.write_all(octets[0..len]) catch unreachable;
            },
        }
    }
    unreachable;
}

/// A literal's first `key_octets` octets in reading order, the first the most significant, and
/// zero past its last.
fn key_of(literal: []const u8, reverse: bool) u64 {
    var key: u64 = 0;
    for (0..key_octets) |place| {
        const octet: u64 = if (place >= literal.len) 0 else if (reverse) literal[literal.len - 1 - place] else literal[place];
        key = key << @bitSizeOf(u8) | octet;
    }
    return key;
}
