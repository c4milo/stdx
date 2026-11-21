//! Patterns and texts a seed draws, for the tests that hold one way to an answer against another
//! (decision 15). Every pattern is one the grammar takes: a test that reads them never skips one.
const std = @import("std");
const codec = @import("codec");
const Generator = codec.testing.split.Generator;

pub const pattern_len_max = 96;
pub const text_len_max = 24;

/// The atoms a pattern is made of: characters, classes and assertions.
const atoms = [_][]const u8{
    "a",                   "b",            "c",    "a",     "b",       "A",   "1",    "_",       " ",
    "\xC3\xA9",            "\xE6\x97\xA5", "-",    "\\.",   "\\n",     ".",   "[ab]", "[^a]",    "[a-c]",
    "[^b-c1]",             "\\d",          "\\w",  "\\s",   "\\D",     "\\W", "\\S",  "[\\dab]", "[^\\w]",
    "[\xC3\xA9-\xC3\xBC]", "[a\\-c]",      "[-a]", "\\x61", "\\x{e9}", "^",   "$",    "\\b",     "\\B",
    "\\A",                 "\\z",
};

const quantifiers = [_][]const u8{ "*", "+", "?", "*?", "+?", "??", "{2}", "{0,2}", "{1,3}", "{2,}", "{1,2}?", "{0}", "{3,}?" };

const group_openers = [_][]const u8{ "(", "(", "(?:", "(?s:" };

const flags = [_][]const u8{ "(?s)", "(?m)", "(?U)", "(?ms)", "(?-s)" };

const text_alphabet = [_][]const u8{ "a", "b", "c", "a", "b", "A", "B", "1", "_", " ", "\n", "\xC3\xA9", "\xE6\x97\xA5", "-", "." };

/// The deepest a generated pattern nests its groups, and the capture groups it holds at most.
pub const depth_max = 3;
pub const groups_max = 6;

/// The room a pattern keeps for the parentheses that close its open groups.
const closers_len = depth_max;

/// The longest piece a pattern is built from.
const piece_len_max = 8;

const Writer = struct {
    buffer: []u8,
    len: usize = 0,

    fn fits(writer: *const Writer, piece: []const u8, reserve: usize) bool {
        return writer.len + piece.len + reserve <= writer.buffer.len;
    }

    fn add(writer: *Writer, piece: []const u8) void {
        @memcpy(writer.buffer[writer.len..][0..piece.len], piece);
        writer.len += piece.len;
    }
};

fn pick(generator: *Generator, pieces: []const []const u8) []const u8 {
    return pieces[@intCast(generator.below(pieces.len))];
}

/// What a pattern under construction may take next.
const State = struct {
    depth: u32 = 0,
    groups: u32 = 0,
    /// True when the last piece is one a quantifier may follow.
    repeatable: bool = false,
};

const Choice = enum { atom, quantifier, open, close, alternative, flag };

/// The share of each choice, in parts of `shares`: the roll under which the choice is taken.
const shares = 100;
const atom_under = 50;
const quantifier_under = 68;
const open_under = 78;
const close_under = 88;
const alternative_under = 96;

/// The pieces a pattern or a text is made of at most.
const pieces_max = 12;

fn choose(generator: *Generator, state: State) Choice {
    const roll = generator.below(shares);
    if (roll < atom_under) return .atom;
    if (roll < quantifier_under) return if (state.repeatable) .quantifier else .atom;
    if (roll < open_under) return if (state.depth < depth_max and state.groups < groups_max) .open else .atom;
    if (roll < close_under) return if (state.depth > 0) .close else .atom;
    if (roll < alternative_under) return .alternative;
    return .flag;
}

/// A pattern of at most `pattern_len_max` octets, which `compile` takes.
pub fn pattern(generator: *Generator, buffer: *[pattern_len_max]u8) []const u8 {
    var writer: Writer = .{ .buffer = buffer };
    var state: State = .{};
    const pieces = generator.below(pieces_max);
    for (0..pieces) |_| {
        if (!writer.fits("", piece_len_max + closers_len)) break;
        switch (choose(generator, state)) {
            .atom => writer.add(pick(generator, &atoms)),
            .quantifier => writer.add(pick(generator, &quantifiers)),
            .open => {
                const opener = pick(generator, &group_openers);
                writer.add(opener);
                state.depth += 1;
                if (opener.len == 1) state.groups += 1;
            },
            .close => {
                writer.add(")");
                state.depth -= 1;
            },
            .alternative => writer.add("|"),
            .flag => writer.add(pick(generator, &flags)),
        }
        state.repeatable = switch (writer.buffer[writer.len - 1]) {
            '(', '|', ':', '*', '+', '?', '}' => false,
            ')' => !is_flag_end(writer.buffer[0..writer.len]),
            else => true,
        };
    }
    for (0..state.depth) |_| writer.add(")");
    return writer.buffer[0..writer.len];
}

/// True when the pattern so far ends with a group of flags, such as `(?s)`, which no quantifier
/// follows.
fn is_flag_end(sofar: []const u8) bool {
    for (flags) |flag| {
        if (std.mem.endsWith(u8, sofar, flag)) return true;
    }
    return false;
}

/// A text of at most `text_len_max` octets, of the characters the atoms name.
pub fn text(generator: *Generator, buffer: *[text_len_max]u8) []const u8 {
    var writer: Writer = .{ .buffer = buffer };
    const pieces = generator.below(pieces_max);
    for (0..pieces) |_| {
        const piece = pick(generator, &text_alphabet);
        if (!writer.fits(piece, 0)) break;
        writer.add(piece);
    }
    return writer.buffer[0..writer.len];
}

const testing = std.testing;
const compiler = @import("compile.zig");
const Instruction = @import("program.zig").Instruction;

test "every generated pattern compiles, and most hold a quantifier, a group or an alternative" {
    var storage: [4096]Instruction = undefined;
    var buffer: [pattern_len_max]u8 = undefined;
    var generator = Generator.init(0xC0FFEE);
    var structured: u32 = 0;
    const patterns = 2000;
    for (0..patterns) |_| {
        const generated = pattern(&generator, &buffer);
        const program = try compiler.compile(generated, .{}, &storage);
        try testing.expect(program.group_count <= groups_max + 1);
        if (std.mem.indexOfAny(u8, generated, "*+?{(|") != null) structured += 1;
    }
    try testing.expect(structured > patterns / 2);
}
