//! A compiled pattern: instructions that read one octet at a time (decision 86).
//!
//! A program is Thompson's automaton in Pike's instruction form. A scalar value past U+007F is a
//! sequence of octet ranges, so one program runs on octets and no matcher decodes UTF-8. Every
//! instruction names its targets, so a fragment of a program stands anywhere in it.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");

/// What one instruction does.
pub const Kind = enum(u8) {
    /// Take one octet from `lo` to `hi`, both included, then go to `out`.
    range,
    /// Go to `out` first and to `arg` second: `out` is the choice a match prefers.
    split,
    /// Write the position into slot `arg`, then go to `out`.
    save,
    /// Go to `out` when the assertion `look` holds at the position.
    look,
    /// Go to `out`.
    jump,
    /// The pattern matched.
    match,
    /// No octet passes.
    fail,
};

/// What the octet on one side of a position is to an assertion.
pub const Context = enum(u8) {
    /// No octet: the text starts or ends here.
    edge,
    line_feed,
    /// An ASCII letter, a digit or a low line.
    word,
    other,

    pub fn of(octet: u8) Context {
        return switch (octet) {
            constants.line_feed => .line_feed,
            '0'...'9', 'A'...'Z', 'a'...'z', '_' => .word,
            else => .other,
        };
    }
};

/// An assertion about a position, in the order a matcher reads the text. `behind` is the octet a
/// matcher read last and `ahead` the octet it reads next, so one set serves the forward program and
/// the reverse one: `^` is `behind_text` forward and `ahead_text` in reverse.
pub const Look = enum(u8) {
    behind_text,
    ahead_text,
    behind_line,
    ahead_line,
    word_boundary,
    not_word_boundary,

    pub fn holds(look: Look, behind: Context, ahead: Context) bool {
        return switch (look) {
            .behind_text => behind == .edge,
            .ahead_text => ahead == .edge,
            .behind_line => behind == .edge or behind == .line_feed,
            .ahead_line => ahead == .edge or ahead == .line_feed,
            .word_boundary => (behind == .word) != (ahead == .word),
            .not_word_boundary => (behind == .word) == (ahead == .word),
        };
    }

    /// True when the assertion reads the octet ahead, so a matcher cannot judge it before that
    /// octet or the end of the text is known.
    pub fn reads_ahead(look: Look) bool {
        return switch (look) {
            .behind_text, .behind_line => false,
            .ahead_text, .ahead_line, .word_boundary, .not_word_boundary => true,
        };
    }

    /// The same assertion for a matcher that reads the text in the other direction.
    pub fn reversed(look: Look) Look {
        return switch (look) {
            .behind_text => .ahead_text,
            .ahead_text => .behind_text,
            .behind_line => .ahead_line,
            .ahead_line => .behind_line,
            .word_boundary => .word_boundary,
            .not_word_boundary => .not_word_boundary,
        };
    }
};

/// One instruction. Its size is 12 octets and its alignment 4, so a thousand instructions take
/// 12 kB.
pub const Instruction = extern struct {
    /// The instruction that follows, for every kind but `match` and `fail`.
    out: u32 = 0,
    /// A split's second target, or a save's slot.
    arg: u32 = 0,
    kind: Kind,
    /// A range's first and last octet.
    lo: u8 = 0,
    hi: u8 = 0,
    look: Look = .behind_text,

    pub fn takes(instruction: Instruction, octet: u8) bool {
        assert(instruction.kind == .range);
        return instruction.lo <= octet and octet <= instruction.hi;
    }
};

/// An entry that names no program.
pub const no_entry = std.math.maxInt(u32);

/// A named capture group, as `(?P<year>` names one: its group and its name, which `compile`
/// copies, so a program's names do not hold the pattern.
pub const GroupName = struct {
    group: u32,
    len: u8,
    octets: [constants.group_name_len_max]u8,

    pub fn name(group_name: *const GroupName) []const u8 {
        return group_name.octets[0..group_name.len];
    }
};

/// A compiled pattern. It holds a slice of the storage the caller gave `compile`, so it lives as
/// long as that storage, and any number of matchers on any threads may read it.
pub const Program = struct {
    /// The forward program, then the reverse program when the options asked for one.
    instructions: []const Instruction,
    /// The instructions of the forward program, which come first.
    forward_len: u32,
    /// Where the forward program starts. It writes slots 0 and 1 around the whole match.
    forward: u32,
    /// Where the reverse program starts, or `no_entry`. It matches each match read backward and
    /// writes no slot.
    reverse: u32,
    /// The capture groups, the whole match counted as group 0.
    group_count: u32,
    /// True when an assertion reads the octet ahead of a position.
    reads_ahead: bool,
    /// True when the program holds any assertion.
    has_looks: bool,
    /// The class of each octet: two octets of one class take every program to the same state.
    classes: [constants.octet_values]u8,
    /// The classes `classes` names.
    class_count: u16,
    /// The names of the named groups, in the order they open, where the caller gave `compile`
    /// storage for them in `Options.names`, and empty where it gave none.
    names: []const GroupName,

    pub fn slot_count(program: *const Program) u32 {
        return program.group_count * constants.group_slots;
    }

    /// The group a name names, or null where no group holds it or the program keeps no names.
    pub fn group_index(program: *const Program, group_name: []const u8) ?u32 {
        assert(program.names.len <= constants.group_names_max);
        for (program.names) |*named| {
            if (std.mem.eql(u8, named.name(), group_name)) return named.group;
        }
        return null;
    }
};

comptime {
    assert(@sizeOf(Instruction) == 3 * @sizeOf(u32));
    assert(@alignOf(Instruction) == @alignOf(u32));
    assert(std.meta.fields(Context).len == constants.context_count);
}

const testing = std.testing;

test "Context names the line feed, the word characters and the rest" {
    try testing.expectEqual(Context.line_feed, Context.of('\n'));
    for ("09AZaz_") |octet| try testing.expectEqual(Context.word, Context.of(octet));
    for ("/:@[`{ \r\x00\x80\xff") |octet| try testing.expectEqual(Context.other, Context.of(octet));
}

test "each assertion holds on its side of a position alone" {
    try testing.expect(Look.behind_text.holds(.edge, .word));
    try testing.expect(!Look.behind_text.holds(.line_feed, .edge));
    try testing.expect(Look.ahead_text.holds(.word, .edge));
    try testing.expect(!Look.ahead_text.holds(.edge, .line_feed));
    try testing.expect(Look.behind_line.holds(.line_feed, .other));
    try testing.expect(Look.behind_line.holds(.edge, .other));
    try testing.expect(!Look.behind_line.holds(.other, .line_feed));
    try testing.expect(Look.ahead_line.holds(.other, .line_feed));
    try testing.expect(Look.ahead_line.holds(.other, .edge));
    try testing.expect(!Look.ahead_line.holds(.line_feed, .other));
}

test "a word boundary lies between a word character and anything else" {
    const sides = [_]Context{ .edge, .line_feed, .word, .other };
    for (sides) |behind| {
        for (sides) |ahead| {
            const boundary = (behind == .word) != (ahead == .word);
            try testing.expectEqual(boundary, Look.word_boundary.holds(behind, ahead));
            try testing.expectEqual(!boundary, Look.not_word_boundary.holds(behind, ahead));
        }
    }
}

test "reversing an assertion twice gives it back, and swaps the side it reads" {
    const looks = [_]Look{ .behind_text, .ahead_text, .behind_line, .ahead_line, .word_boundary, .not_word_boundary };
    const sides = [_]Context{ .edge, .line_feed, .word, .other };
    for (looks) |look| {
        try testing.expectEqual(look, look.reversed().reversed());
        for (sides) |behind| {
            for (sides) |ahead| {
                try testing.expectEqual(look.holds(behind, ahead), look.reversed().holds(ahead, behind));
            }
        }
    }
}
