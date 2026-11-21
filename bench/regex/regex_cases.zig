//! The workloads of bench-regex (decision 86): the patterns, the haystack the benchmark makes,
//! and the short texts a pattern validates.
//!
//! Every pattern spells its classes out, as `[0-9]` and `[A-Za-z]`, and holds no `\d` or `\w`.
//! Rust's regex reads those as Unicode's by default, where RE2, Go's regexp and stdx read
//! ASCII's, so a pattern with one would give the engines different work. A pattern with `\b`
//! names the form Rust takes for the ASCII word boundary (`Search.rust`).

const std = @import("std");
const Generator = @import("codec").testing.split.Generator;

/// A pattern searched for in a haystack.
pub const Search = struct {
    /// The row's name: the group of its pattern, a colon, and what the pattern finds. The chart
    /// draws a panel for each group.
    name: []const u8,
    pattern: []const u8,
    /// The corpus file whose first `haystack_len_max` octets are the haystack, or `scripts`.
    file: []const u8,
    /// The pattern as Rust's regex takes it, where it is not `pattern`.
    rust: ?[]const u8 = null,
};

/// The octets of a haystack: the first MiB of its file.
pub const haystack_len_max = 1 << 20;

/// English prose, the start of the Canterbury corpus's King James Bible; markup, a MiB of the
/// WHATWG HTML Standard; and a second text, the start of the CIA World Factbook of 1992. The
/// engines differ on octets that are not UTF-8, so no haystack holds one. No constant of claim
/// R1 was chosen with the second text or with `scripts` (design §8 step 22, part 22c).
const prose = "canterbury-large/bible.txt";
const markup = "http/html-1m";
const second = "canterbury-large/world192.txt";

/// The haystack `write_scripts` makes: no corpus file holds a text of many scripts.
pub const scripts = "generated: words in four scripts";

pub const searches = [_]Search{
    // A literal to find: an engine may search for the literal's octets before its automaton runs.
    .{ .name = "literal: a word", .pattern = "Pharaoh", .file = prose },
    .{ .name = "literal: a word that is not there", .pattern = "Sherlock", .file = prose },
    .{ .name = "literal: one of four words", .pattern = "Abraham|Isaac|Jacob|Joseph", .file = prose },
    .{ .name = "literal: a word in any case", .pattern = "(?i)pharaoh", .file = prose },
    .{ .name = "literal: an href attribute", .pattern = "href=\"[^\"]*\"", .file = markup },
    .{ .name = "literal: a word, second text", .pattern = "Population", .file = second },
    // A class to start with: no literal leads to a match.
    .{ .name = "class: two capitalized words", .pattern = "[A-Z][a-z]+ [A-Z][a-z]+", .file = prose },
    .{ .name = "class: a word that ends in ing", .pattern = "[a-z]+ing", .file = prose },
    .{ .name = "class: a word in capitals", .pattern = "[A-Z][A-Z][A-Z]+", .file = prose },
    .{ .name = "class: a number", .pattern = "[0-9]+", .file = markup },
    .{ .name = "class: a distance, second text", .pattern = "[0-9][0-9,]* km", .file = second },
    // The other shapes: a literal with a class inside or after it, an assertion, a pattern whose
    // DFA has more states than a cache holds, and a class past ASCII.
    .{ .name = "other: a word between two words", .pattern = "the [a-z]+ of", .file = prose },
    .{ .name = "other: a heading's start tag", .pattern = "<h[1-6][^>]*>", .file = markup },
    .{ .name = "other: a whole word", .pattern = "\\bPharaoh\\b", .file = prose, .rust = "(?-u:\\b)Pharaoh(?-u:\\b)" },
    .{ .name = "other: a line's first word, second text", .pattern = "(?m)^[A-Z][a-z]+:", .file = second },
    .{ .name = "other: fourteen octets before an x", .pattern = "[a-q][^u-z]{13}x", .file = prose },
    .{ .name = "other: a Greek word", .pattern = "[\u{3b1}-\u{3c9}]+", .file = scripts },
};

/// The scripts of `scripts`: the first letter of each, and its count of letters. Latin, Greek,
/// Cyrillic and CJK ideographs take one, two, two and three octets a letter in UTF-8.
const alphabets = [_]struct { first: u21, count: u21 }{
    .{ .first = 'a', .count = 26 },
    .{ .first = 0x3b1, .count = 25 },
    .{ .first = 0x430, .count = 32 },
    .{ .first = 0x4e00, .count = 2048 },
};

/// The letters of a word of `scripts`, and the words of a line.
const script_word_len_min = 2;
const script_word_len_max = 9;
const script_line_words = 12;

/// The octets of the longest word, and its space.
const script_word_octets_max = script_word_len_max * 3 + 1;

/// Fills `out` with words in four scripts, a space or a line feed after each, as far as whole
/// words fit, and gives the octets written. A seed gives the same text each time.
pub fn write_scripts(seed: u64, out: []u8) usize {
    var generator = Generator.init(seed);
    var len: usize = 0;
    var words: usize = 0;
    while (out.len - len >= script_word_octets_max) : (words += 1) {
        const alphabet = alphabets[generator.below(alphabets.len)];
        const letters = script_word_len_min + generator.below(script_word_len_max - script_word_len_min + 1);
        for (0..letters) |_| {
            const letter: u21 = alphabet.first + @as(u21, @intCast(generator.below(alphabet.count)));
            len += std.unicode.utf8Encode(letter, out[len..]) catch unreachable;
        }
        out[len] = if (words % script_line_words == script_line_words - 1) '\n' else ' ';
        len += 1;
    }
    return len;
}

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

/// The texts of one validation, each one made anew: about half of them valid, and the others
/// with one octet changed. A batch holds 1.3 to 2.4 MB, so a run does not repeat a text that the
/// branch predictor has learned (decision 45).
pub const texts_per_validation = 1 << 16;

/// The octets of the longest text.
pub const text_len_max = 64;

/// The texts of one validation, one after another with nothing between them, and the offset
/// where each ends. A candidate takes each text by two offsets, so no candidate looks for where
/// a text ends while the clock runs.
pub const Batch = struct {
    octets: std.ArrayList(u8) = .empty,
    ends: std.ArrayList(u32) = .empty,
    /// The texts with no octet changed.
    valid: usize = 0,

    pub fn deinit(batch: *Batch, allocator: std.mem.Allocator) void {
        batch.octets.deinit(allocator);
        batch.ends.deinit(allocator);
    }

    /// The text at `index`.
    pub fn text(batch: *const Batch, index: usize) []const u8 {
        const start = if (index == 0) 0 else batch.ends.items[index - 1];
        return batch.octets.items[start..batch.ends.items[index]];
    }
};

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

/// Writes the texts of a validation into `batch`. A text in two, as the seed chooses, has one
/// octet changed to a space, which no pattern of `validations` takes.
pub fn write_texts(kind: Validation.Kind, seed: u64, batch: *Batch, allocator: std.mem.Allocator) !void {
    var generator = Generator.init(seed);
    for (0..texts_per_validation) |_| {
        var text: Text = .{};
        switch (kind) {
            .email => email(&text, &generator),
            .uuid => uuid(&text, &generator),
            .ipv4 => ipv4(&text, &generator),
            .date_time => date_time(&text, &generator),
            .field_path => field_path(&text, &generator),
        }
        if (generator.below(2) == 0) {
            text.octets[generator.below(text.len)] = ' ';
        } else {
            batch.valid += 1;
        }
        try batch.octets.appendSlice(allocator, text.octets[0..text.len]);
        try batch.ends.append(allocator, @intCast(batch.octets.items.len));
    }
}

const testing = std.testing;

test "write_texts gives the texts of each kind, a space in each text that is not valid" {
    for (std.enums.values(Validation.Kind)) |kind| {
        var batch: Batch = .{};
        defer batch.deinit(testing.allocator);
        try write_texts(kind, 1, &batch, testing.allocator);
        try testing.expectEqual(texts_per_validation, batch.ends.items.len);
        try testing.expectEqual(batch.octets.items.len, batch.ends.items[texts_per_validation - 1]);
        var with_space: usize = 0;
        for (0..texts_per_validation) |index| {
            const text = batch.text(index);
            try testing.expect(text.len > 0 and text.len <= text_len_max);
            if (std.mem.indexOfScalar(u8, text, ' ') != null) with_space += 1;
        }
        try testing.expectEqual(texts_per_validation, batch.valid + with_space);
        // About half are valid, in no fixed turn: the seed chooses each.
        try testing.expect(batch.valid > texts_per_validation / 2 - texts_per_validation / 16);
        try testing.expect(batch.valid < texts_per_validation / 2 + texts_per_validation / 16);
        var same_as_next: usize = 0;
        for (1..texts_per_validation) |index| {
            const before = std.mem.indexOfScalar(u8, batch.text(index - 1), ' ') == null;
            same_as_next += @intFromBool(before == (std.mem.indexOfScalar(u8, batch.text(index), ' ') == null));
        }
        try testing.expect(same_as_next > texts_per_validation / 4);
    }
}

test "a seed gives the same texts each time" {
    var first: Batch = .{};
    defer first.deinit(testing.allocator);
    var again: Batch = .{};
    defer again.deinit(testing.allocator);
    try write_texts(.email, 7, &first, testing.allocator);
    try write_texts(.email, 7, &again, testing.allocator);
    try testing.expectEqualStrings(first.octets.items, again.octets.items);
    try testing.expectEqualSlices(u32, first.ends.items, again.ends.items);
}

test "write_scripts gives whole words of UTF-8 in four scripts, the same for a seed" {
    var first: [4096]u8 = undefined;
    var again: [4096]u8 = undefined;
    const len = write_scripts(3, &first);
    try testing.expectEqual(len, write_scripts(3, &again));
    try testing.expectEqualStrings(first[0..len], again[0..len]);
    try testing.expect(first.len - len < script_word_octets_max);
    try testing.expect(std.unicode.utf8ValidateSlice(first[0..len]));
    try testing.expect(first[len - 1] == ' ' or first[len - 1] == '\n');
    // A letter of each length that UTF-8 gives these scripts.
    var lens = [_]usize{0} ** 5;
    var view = std.unicode.Utf8View.initUnchecked(first[0..len]).iterator();
    while (view.nextCodepointSlice()) |letter| lens[letter.len] += 1;
    try testing.expect(lens[1] > 0 and lens[2] > 0 and lens[3] > 0 and lens[4] == 0);
}
