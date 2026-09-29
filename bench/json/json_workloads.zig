//! The inputs bench-json times: JSON texts to decode, and the tokens of texts to encode.
//!
//! - The CLDR supplemental files of decision 15's corpus, each a whole JSON text, pretty-printed:
//!   names, short strings, numbers and whitespace.
//! - A log of qlog-shaped records as a JSON text sequence (RFC 7464): the records a QUIC stack
//!   writes, with fixed-point times, hex strings and nested objects, drawn from a fixed seed.
//! - Each text file of the corpus, up to 1 MiB and as far as it is UTF-8, as one string: a long
//!   run the string scans of claims J1, J3 and J5 take.
//! - dickens's first MiB with its letters written as Cyrillic and CJK characters: UTF-8 of two
//!   and three octets, claim J5's input. Decoded a second time with each of those characters
//!   written as a `\u` escape, as Python's json.dumps writes them by default: the UTF-8 the
//!   decoder writes for an escape.
//! - Each corpus file's first 256 KiB as a hex string: claim J2's input.
//!
//! Every text is written, and every CLDR text read, by stdx with every path scalar, the reference,
//! so no workload depends on the paths it times.

const std = @import("std");
const json = @import("json");
const codec = @import("codec");

/// One token and all of its octets, as the encoder's batches take them (decision 33).
pub const Item = json.Encoder.Item;

/// A workload: the texts to decode, and the tokens that encode to them.
pub const Workload = struct {
    name: []const u8,
    framing: json.Framing,
    /// Each encoded text, and the octets of all of them.
    texts: []const []const u8,
    octets: usize,
    /// Each text's tokens.
    items: []const []const Item,
    /// The longest name, string or number a text holds, which the decoder's output must fit.
    content_len_max: usize,
    /// Whether the texts are not the tokens' encoding, and the workload is decoded only: stdx's
    /// encoder writes no `\u` escape for a character it can write as it is (RFC 8259 §7).
    decode_only: bool = false,
};

/// A corpus file: its name and octets.
pub const File = struct {
    name: []const u8,
    octets: []const u8,
};

/// The longest string or hex input taken from one corpus file.
const string_len_max = 1 << 20;
const hex_len_max = 256 << 10;

/// A file becomes a string workload when this much of it, at least, is UTF-8.
const string_len_min = 64 << 10;

/// The claims the workloads are built with. J1 and J3 off turn J5 off with them, so every path is
/// scalar or checked, as with every claim off; but no candidate takes this value, so building the
/// workloads gives no candidate's codec a second caller, which would change how LLVM inlines it
/// (`encode` in json.zig).
pub const setup_claims: json.Claims = .{
    .encoder_string_vectors = false,
    .hex_vectors = false,
    .decoder_string_vectors = false,
    .utf8_vectors = true,
    .wide_vectors = false,
    .decoder_fast_path = false,
    .decoder_token_loop = false,
    .encoder_fast_path = false,
    .encoder_token_loop = false,
};

/// The qlog-shaped records the log holds, and the seed they are drawn from.
const qlog_records = 6000;
const qlog_seed = 0x71_6c_6f_67;

/// The tokens of each CLDR file, as the decoder reads them: the encoder's input for that file.
pub fn cldr(arena: std.mem.Allocator, files: []const File) !Workload {
    var texts: std.ArrayList([]const Item) = .empty;
    var content_len_max: usize = 0;
    for (files) |file| {
        const items = try tokens_of(arena, file.octets, &content_len_max);
        try texts.append(arena, items);
    }
    const name = try std.fmt.allocPrint(arena, "CLDR supplemental, {d} texts", .{files.len});
    return finish(arena, name, .text, try texts.toOwnedSlice(arena), content_len_max);
}

fn tokens_of(arena: std.mem.Allocator, text: []const u8, content_len_max: *usize) ![]const Item {
    const storage = try arena.alloc(u8, text.len);
    var decoder: json.Decoder = undefined;
    decoder.init(.text, codec.Features.detect());
    var items: std.ArrayList(Item) = .empty;
    var consumed: usize = 0;
    // A call takes at least one octet or ends the text, and the last call finds its end.
    for (0..text.len + 1) |_| {
        const progress = try decoder.decode_with(setup_claims, text[consumed..], storage, .last);
        consumed += progress.consumed;
        switch (progress.status) {
            .token => {
                const item = try item_of(arena, progress.kind.?, storage[0..progress.written]);
                content_len_max.* = @max(content_len_max.*, item.octets.len);
                try items.append(arena, item);
            },
            .done => return items.toOwnedSlice(arena),
            .needs_input, .needs_room => return error.Truncated,
        }
    }
    unreachable;
}

/// A decoded token as the encoder's input, with a copy of its octets.
fn item_of(arena: std.mem.Allocator, kind: json.Kind, octets: []const u8) !Item {
    return switch (kind) {
        .begin_object => .{ .token = .begin_object },
        .end_object => .{ .token = .end_object },
        .begin_array => .{ .token = .begin_array },
        .end_array => .{ .token = .end_array },
        .name => .{ .token = .{ .name = .last }, .octets = try arena.dupe(u8, octets) },
        .string => .{ .token = .{ .string = .last }, .octets = try arena.dupe(u8, octets) },
        .number => .{ .token = .{ .number = .last }, .octets = try arena.dupe(u8, octets) },
        .true => .{ .token = .{ .boolean = true } },
        .false => .{ .token = .{ .boolean = false } },
        .null => .{ .token = .null },
    };
}

/// A log of qlog-shaped records, each a text of a sequence.
pub fn qlog(arena: std.mem.Allocator) !Workload {
    var random = std.Random.SplitMix64.init(qlog_seed);
    var texts: std.ArrayList([]const Item) = .empty;
    var time_us: u64 = 0;
    for (0..qlog_records) |_| {
        time_us += random.next() % 5000;
        try texts.append(arena, try record(arena, &random, time_us));
    }
    return finish(arena, "qlog records, JSON text sequence", .sequence, try texts.toOwnedSlice(arena), 64);
}

fn record(arena: std.mem.Allocator, random: *std.Random.SplitMix64, time_us: u64) ![]const Item {
    const connection_id = try arena.alloc(u8, 8);
    std.mem.writeInt(u64, connection_id[0..8], random.next(), .little);
    const sent = random.next() % 2 == 0;
    const items = [_]Item{
        .{ .token = .begin_object },
        .{ .token = .{ .name = .last }, .octets = "time" },
        .{ .token = .{ .decimal = .{ .integer = time_us / 1000, .fraction = time_us % 1000, .fraction_digits = 3 } } },
        .{ .token = .{ .name = .last }, .octets = "name" },
        .{ .token = .{ .string = .last }, .octets = if (sent) "transport:packet_sent" else "transport:packet_received" },
        .{ .token = .{ .name = .last }, .octets = "data" },
        .{ .token = .begin_object },
        .{ .token = .{ .name = .last }, .octets = "header" },
        .{ .token = .begin_object },
        .{ .token = .{ .name = .last }, .octets = "packet_type" },
        .{ .token = .{ .string = .last }, .octets = "1RTT" },
        .{ .token = .{ .name = .last }, .octets = "packet_number" },
        .{ .token = .{ .unsigned = random.next() % 100_000 } },
        .{ .token = .{ .name = .last }, .octets = "dcid" },
        .{ .token = .{ .hex = .last }, .octets = connection_id },
        .{ .token = .end_object },
        .{ .token = .{ .name = .last }, .octets = "raw" },
        .{ .token = .begin_object },
        .{ .token = .{ .name = .last }, .octets = "length" },
        .{ .token = .{ .unsigned = 1200 + random.next() % 52 } },
        .{ .token = .end_object },
        .{ .token = .{ .name = .last }, .octets = "frames" },
        .{ .token = .begin_array },
        .{ .token = .begin_object },
        .{ .token = .{ .name = .last }, .octets = "frame_type" },
        .{ .token = .{ .string = .last }, .octets = "stream" },
        .{ .token = .{ .name = .last }, .octets = "stream_id" },
        .{ .token = .{ .unsigned = 4 * (random.next() % 64) } },
        .{ .token = .{ .name = .last }, .octets = "offset" },
        .{ .token = .{ .unsigned = random.next() % (1 << 30) } },
        .{ .token = .{ .name = .last }, .octets = "fin" },
        .{ .token = .{ .boolean = random.next() % 16 == 0 } },
        .{ .token = .end_object },
        .{ .token = .end_array },
        .{ .token = .end_object },
        .{ .token = .end_object },
    };
    return arena.dupe(Item, &items);
}

/// Each corpus file as far as it is UTF-8, up to 1 MiB, as one string, when that is 64 KiB or
/// more.
pub fn strings(arena: std.mem.Allocator, files: []const File) ![]const Workload {
    var workloads: std.ArrayList(Workload) = .empty;
    for (files) |file| {
        const octets = utf8_prefix(file.octets[0..@min(file.octets.len, string_len_max)]);
        if (octets.len < string_len_min) continue;
        try workloads.append(arena, try one_token(arena, try std.fmt.allocPrint(arena, "string: {s}", .{file.name}), .{ .token = .{ .string = .last }, .octets = octets }));
    }
    return workloads.toOwnedSlice(arena);
}

/// The longest prefix of `octets` that is whole UTF-8 characters.
fn utf8_prefix(octets: []const u8) []const u8 {
    var index: usize = 0;
    while (index < octets.len) {
        const len = std.unicode.utf8ByteSequenceLength(octets[index]) catch break;
        if (index + len > octets.len) break;
        _ = std.unicode.utf8Decode(octets[index..][0..len]) catch break;
        index += len;
    }
    return octets[0..index];
}

/// dickens's first MiB with each letter written as a Cyrillic letter and each digit as a CJK
/// character: UTF-8 of two and three octets among ASCII spaces and punctuation.
pub fn non_ascii(arena: std.mem.Allocator, dickens: []const u8) !Workload {
    const source = dickens[0..@min(dickens.len, string_len_max)];
    var octets: std.ArrayList(u8) = .empty;
    for (source) |octet| {
        var buffer: [4]u8 = undefined;
        const code_point: u21 = switch (octet) {
            'a'...'z' => 0x0430 + @as(u21, octet - 'a'),
            'A'...'Z' => 0x0410 + @as(u21, octet - 'A'),
            '0'...'9' => 0x4e00 + @as(u21, octet - '0'),
            else => octet,
        };
        const len = std.unicode.utf8Encode(code_point, &buffer) catch unreachable;
        try octets.appendSlice(arena, buffer[0..len]);
    }
    return one_token(arena, "string: dickens as Cyrillic and CJK", .{ .token = .{ .string = .last }, .octets = octets.items });
}

/// `raw`, the non-ASCII text, with each character of two octets or more written as a `\u` escape of
/// four lowercase digits, or two for a character past U+FFFF (RFC 8259 §7), decoded only.
pub fn non_ascii_escaped(arena: std.mem.Allocator, raw: *const Workload) !Workload {
    var escaped: std.ArrayList(u8) = .empty;
    const text = raw.texts[0];
    var index: usize = 0;
    while (index < text.len) {
        const len = std.unicode.utf8ByteSequenceLength(text[index]) catch unreachable;
        const code_point = std.unicode.utf8Decode(text[index..][0..len]) catch unreachable;
        index += len;
        if (len == 1) {
            try escaped.append(arena, text[index - 1]);
            continue;
        }
        var units: [2]u16 = undefined;
        const units_len: usize = if (code_point < 0x10000) 1 else 2;
        if (units_len == 1) units[0] = @intCast(code_point) else units = .{ @intCast(0xd800 + ((code_point - 0x10000) >> 10)), @intCast(0xdc00 + ((code_point - 0x10000) & 0x3ff)) };
        for (units[0..units_len]) |unit| try escaped.print(arena, "\\u{x:0>4}", .{unit});
    }
    const texts = try arena.alloc([]const u8, 1);
    texts[0] = escaped.items;
    return .{ .name = "string: dickens as Cyrillic and CJK, as \\u escapes", .framing = raw.framing, .texts = texts, .octets = escaped.items.len, .items = raw.items, .content_len_max = raw.content_len_max, .decode_only = true };
}

/// Each corpus file's first 256 KiB as a hex string.
pub fn hex(arena: std.mem.Allocator, files: []const File) ![]const Workload {
    var workloads: std.ArrayList(Workload) = .empty;
    for (files) |file| {
        const octets = file.octets[0..@min(file.octets.len, hex_len_max)];
        try workloads.append(arena, try one_token(arena, try std.fmt.allocPrint(arena, "hex: {s}", .{file.name}), .{ .token = .{ .hex = .last }, .octets = octets }));
    }
    return workloads.toOwnedSlice(arena);
}

fn one_token(arena: std.mem.Allocator, name: []const u8, item: Item) !Workload {
    const texts = try arena.alloc([]const Item, 1);
    texts[0] = try arena.dupe(Item, &.{item});
    // A hex string's digits are twice its octets, and a string's content is at most its octets.
    return finish(arena, name, .text, texts, json.constants.hex_digits_per_octet * item.octets.len);
}

/// The workload whose texts are `texts`' tokens, encoded with every claim off.
fn finish(arena: std.mem.Allocator, name: []const u8, framing: json.Framing, items: []const []const Item, content_len_max: usize) !Workload {
    const texts = try arena.alloc([]const u8, items.len);
    var octets: usize = 0;
    for (items, texts) |text_items, *text| {
        const buffer = try arena.alloc(u8, encoded_len_max(text_items));
        text.* = buffer[0..try encode_scalar(framing, text_items, buffer)];
        octets += text.len;
    }
    return .{ .name = name, .framing = framing, .texts = texts, .octets = octets, .items = items, .content_len_max = content_len_max };
}

/// More room than the tokens of one text can take: six octets for each octet of their input, the
/// longest escape, and a number's longest text and its separators for each token.
pub fn encoded_len_max(items: []const Item) usize {
    var len: usize = 0;
    for (items) |item| len += 6 * item.octets.len + json.constants.pending_len_max + 4;
    return len;
}

fn encode_scalar(framing: json.Framing, items: []const Item, output: []u8) !usize {
    var encoder: json.Encoder = undefined;
    encoder.init(framing, codec.Features.detect());
    var written: usize = 0;
    for (items) |item| {
        const progress = try encoder.encode_with(setup_claims, item.token, item.octets, output[written..]);
        written += progress.written;
        std.debug.assert(progress.status != .needs_room and progress.consumed == item.octets.len);
    }
    std.debug.assert(encoder.is_done());
    return written;
}
