//! The workloads of bench-regex (decision 86): the patterns, and the short texts a pattern
//! validates.
//!
//! Every pattern spells its classes out, as `[0-9]` and `[A-Za-z]`, and holds no `\d`, `\w` or
//! `\b`. Rust's regex reads those three as Unicode's by default, where RE2, Go's regexp and stdx
//! read ASCII's, so a pattern with one would give the engines different work.

const std = @import("std");
const Generator = @import("codec").testing.split.Generator;

/// A pattern searched for in a haystack of the corpus.
pub const Search = struct {
    name: []const u8,
    pattern: []const u8,
    /// The corpus file whose first `haystack_len_max` octets are the haystack.
    file: []const u8,
};

/// The octets of a haystack: the first MiB of its file.
pub const haystack_len_max = 1 << 20;

/// English prose, the start of the Canterbury corpus's King James Bible, which is ASCII, and
/// markup, a MiB of the WHATWG HTML Standard, which is UTF-8. The engines differ on octets that
/// are not UTF-8, so no haystack holds one.
const prose = "canterbury-large/bible.txt";
const markup = "http/html-1m";

pub const searches = [_]Search{
    .{ .name = "prose: a word", .pattern = "Pharaoh", .file = prose },
    .{ .name = "prose: a word that is not there", .pattern = "Sherlock", .file = prose },
    .{ .name = "prose: one of four words", .pattern = "Abraham|Isaac|Jacob|Joseph", .file = prose },
    .{ .name = "prose: a word in any case", .pattern = "(?i)pharaoh", .file = prose },
    .{ .name = "prose: a word between two words", .pattern = "the [a-z]+ of", .file = prose },
    .{ .name = "prose: two capitalized words", .pattern = "[A-Z][a-z]+ [A-Z][a-z]+", .file = prose },
    .{ .name = "prose: a word that ends in ing", .pattern = "[a-z]+ing", .file = prose },
    .{ .name = "prose: a word in capitals", .pattern = "[A-Z][A-Z][A-Z]+", .file = prose },
    .{ .name = "markup: an href attribute", .pattern = "href=\"[^\"]*\"", .file = markup },
    .{ .name = "markup: a heading's start tag", .pattern = "<h[1-6][^>]*>", .file = markup },
    .{ .name = "markup: a number", .pattern = "[0-9]+", .file = markup },
};

/// A pattern that validates a whole short text, as a field's rule does, with what its texts are
/// made of.
pub const Validation = struct {
    name: []const u8,
    pattern: []const u8,
    kind: Kind,

    pub const Kind = enum { email, uuid, ipv4, date_time, field_path };
};

pub const validations = [_]Validation{
    .{ .name = "an email address", .pattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", .kind = .email },
    .{ .name = "a UUID", .pattern = "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", .kind = .uuid },
    .{ .name = "an IPv4 address", .pattern = "^([0-9]{1,3}\\.){3}[0-9]{1,3}$", .kind = .ipv4 },
    .{ .name = "a date and time", .pattern = "^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$", .kind = .date_time },
    .{ .name = "a field path", .pattern = "^[a-z_][a-z0-9_]*(\\.[a-z_][a-z0-9_]*)*$", .kind = .field_path },
};

/// The date and time pattern with a group around each of its six numbers.
pub const groups_validation: Validation = .{
    .name = "a date and time, six groups",
    .pattern = "^([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2}):([0-9]{2}):([0-9]{2})Z$",
    .kind = .date_time,
};

/// The texts of one validation: half of them valid, and half with one octet changed.
pub const texts_per_validation = 1024;

/// The octets of the longest text, its line feed included.
pub const text_len_max = 64;

const lower = "abcdefghijklmnopqrstuvwxyz";
const digits = "0123456789";
const hex = "0123456789abcdef";

/// One text as it grows.
const Text = struct {
    octets: [text_len_max]u8 = undefined,
    len: usize = 0,

    fn add(text: *Text, octet: u8) void {
        text.octets[text.len] = octet;
        text.len += 1;
    }

    fn word(text: *Text, generator: *Generator, alphabet: []const u8, len_min: usize, len_max: usize) void {
        const len = len_min + generator.below(len_max - len_min + 1);
        for (0..len) |_| text.add(alphabet[generator.below(alphabet.len)]);
    }
};

fn email(text: *Text, generator: *Generator) void {
    text.word(generator, lower, 3, 10);
    text.add('.');
    text.word(generator, lower, 2, 8);
    text.add('@');
    text.word(generator, lower, 3, 10);
    text.add('.');
    text.word(generator, lower, 2, 3);
}

fn uuid(text: *Text, generator: *Generator) void {
    for ([_]usize{ 8, 4, 4, 4, 12 }, 0..) |len, index| {
        if (index > 0) text.add('-');
        text.word(generator, hex, len, len);
    }
}

fn ipv4(text: *Text, generator: *Generator) void {
    for (0..4) |index| {
        if (index > 0) text.add('.');
        text.word(generator, digits, 1, 3);
    }
}

fn date_time(text: *Text, generator: *Generator) void {
    for ([_]usize{ 4, 2, 2, 2, 2, 2 }, "--T::Z") |len, after| {
        text.word(generator, digits, len, len);
        text.add(after);
    }
}

fn field_path(text: *Text, generator: *Generator) void {
    for (0..1 + generator.below(4)) |index| {
        if (index > 0) text.add('.');
        text.word(generator, lower, 1, 1);
        text.word(generator, lower ++ digits ++ "_", 2, 9);
    }
}

/// Writes the texts of a validation, a line feed after each, and gives how many are valid. Every
/// second text has one octet changed to a space, which no pattern of `validations` takes.
pub fn write_texts(kind: Validation.Kind, seed: u64, out: *std.ArrayList(u8), allocator: std.mem.Allocator) !usize {
    var generator = Generator.init(seed);
    var valid: usize = 0;
    for (0..texts_per_validation) |index| {
        var text: Text = .{};
        switch (kind) {
            .email => email(&text, &generator),
            .uuid => uuid(&text, &generator),
            .ipv4 => ipv4(&text, &generator),
            .date_time => date_time(&text, &generator),
            .field_path => field_path(&text, &generator),
        }
        if (index % 2 == 1) {
            text.octets[generator.below(text.len)] = ' ';
        } else {
            valid += 1;
        }
        text.add('\n');
        try out.appendSlice(allocator, text.octets[0..text.len]);
    }
    return valid;
}

const testing = std.testing;

test "write_texts gives the texts of each kind, half of them with a space" {
    for (std.enums.values(Validation.Kind)) |kind| {
        var out: std.ArrayList(u8) = .empty;
        defer out.deinit(testing.allocator);
        const valid = try write_texts(kind, 1, &out, testing.allocator);
        try testing.expectEqual(texts_per_validation / 2, valid);
        try testing.expectEqual(texts_per_validation, std.mem.count(u8, out.items, "\n"));
        var with_space: usize = 0;
        var lines = std.mem.splitScalar(u8, out.items[0 .. out.items.len - 1], '\n');
        while (lines.next()) |line| {
            try testing.expect(line.len > 0 and line.len < text_len_max);
            if (std.mem.indexOfScalar(u8, line, ' ') != null) with_space += 1;
        }
        try testing.expectEqual(texts_per_validation / 2, with_space);
    }
}

test "a seed gives the same texts each time" {
    var first: std.ArrayList(u8) = .empty;
    defer first.deinit(testing.allocator);
    var again: std.ArrayList(u8) = .empty;
    defer again.deinit(testing.allocator);
    _ = try write_texts(.email, 7, &first, testing.allocator);
    _ = try write_texts(.email, 7, &again, testing.allocator);
    try testing.expectEqualStrings(first.items, again.items);
}
