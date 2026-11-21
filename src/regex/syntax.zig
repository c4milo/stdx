//! A pattern read into a program (decision 86): RFC 9485 §3's grammar, with the anchors, the
//! groups, the lazy quantifiers and the flags that stdx adds from RE2's syntax.
//!
//! The parser builds no tree. It keeps one frame for each open group, and a frame holds at most
//! two fragments not yet joined: a quantifier applies to the last one alone, and that one is
//! always the last block of the program, which is what `repeat.apply` copies. A frame's
//! alternatives join as they close. The parser never recurses, and `depth_max` bounds its frames.
const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("constants.zig");
const errors = @import("errors.zig");
const escape = @import("syntax_escape.zig");
const class = @import("syntax_class.zig");
const atom = @import("syntax_atom.zig");
const repeat = @import("repeat.zig");
const utf8_ranges = @import("utf8_ranges.zig");
const fragment = @import("fragment.zig");
const Builder = fragment.Builder;
const Fragment = fragment.Fragment;
const Holes = fragment.Holes;
const Greed = fragment.Greed;
const Flags = atom.Flags;
const Error = errors.Error;

/// The group of a frame that captures nothing.
const no_group = std.math.maxInt(u32);

/// The alternatives of a frame that have closed: `a|b|` while the frame reads its next one.
const Alternation = struct {
    /// The first split, where the alternation starts.
    entry: u32,
    /// The last split, whose second target is the alternative the frame is reading.
    last: u32,
    begin: u32,
    holes: Holes,
    nullable: bool,
    weight: u32,
};

const Frame = struct {
    /// The flags to restore when the frame closes.
    flags: Flags,
    group: u32,
    pending: [constants.pending_max]Fragment = undefined,
    pending_len: u32 = 0,
    /// True when the last pending fragment has its quantifier.
    quantified: bool = false,
    alternation: ?Alternation = null,
};

pub const Parser = struct {
    reader: codec.Reader,
    builder: *Builder,
    flags: Flags,
    frames: [constants.depth_max + 1]Frame = undefined,
    depth: u32 = 0,
    /// The capture groups so far, the whole match counted.
    group_count: u32 = 1,

    pub fn init(pattern: []const u8, flags: Flags, builder: *Builder) Parser {
        return .{ .reader = codec.Reader.init(pattern), .builder = builder, .flags = flags };
    }

    /// The whole pattern as one fragment, at the end of the builder's program.
    pub fn parse(parser: *Parser) Error!Fragment {
        parser.frames[0] = .{ .flags = parser.flags, .group = no_group };
        while (try utf8_ranges.take_scalar(&parser.reader)) |scalar| try parser.step(scalar);
        // RFC 9485 §3: atom = "(" i-regexp ")", so each group closes before the pattern ends.
        if (parser.depth != 0) return error.MissingParenthesis;
        return parser.close_frame();
    }

    fn top(parser: *Parser) *Frame {
        assert(parser.depth <= constants.depth_max);
        return &parser.frames[parser.depth];
    }

    fn step(parser: *Parser, scalar: u32) Error!void {
        switch (scalar) {
            '(' => try parser.open_group(),
            ')' => try parser.close_group(),
            '|' => try parser.close_alternative(),
            '*', '+', '?', '{' => try parser.quantifier(scalar),
            '[' => {
                const set = try class.take(&parser.reader, parser.flags);
                parser.push(try atom.class(parser.builder, &set));
            },
            '.' => parser.push(try atom.dot(parser.builder, parser.flags)),
            '^' => parser.push(try parser.builder.look(if (parser.flags.multi_line) .behind_line else .behind_text)),
            '$' => parser.push(try parser.builder.look(if (parser.flags.multi_line) .ahead_line else .ahead_text)),
            '\\' => try parser.escaped(),
            // RFC 9485 §3: NormalChar holds neither "]" nor "}", so each stands for itself only
            // after a "\".
            ']', '}' => return error.UnescapedCharacter,
            else => parser.push(try atom.literal(parser.builder, parser.flags, scalar)),
        }
    }

    fn escaped(parser: *Parser) Error!void {
        switch (try escape.take(&parser.reader)) {
            .scalar => |scalar| parser.push(try atom.literal(parser.builder, parser.flags, scalar)),
            .look => |look| parser.push(try parser.builder.look(look)),
            .class => |perl| {
                var set: @import("scalar_set.zig").ScalarSet = .{};
                try perl.add_to(&set);
                set.normalize();
                parser.push(try atom.class(parser.builder, &set));
            },
        }
    }

    /// Adds an atom to the frame. With two already pending, no quantifier can reach the first, so
    /// the two join.
    fn push(parser: *Parser, piece: Fragment) void {
        const frame = parser.top();
        if (frame.pending_len == constants.pending_max) {
            frame.pending[0] = parser.builder.cat(frame.pending[0], frame.pending[1]);
            frame.pending_len = 1;
        }
        frame.pending[frame.pending_len] = piece;
        frame.pending_len += 1;
        frame.quantified = false;
    }

    /// The atoms the frame holds, joined: one alternative.
    fn branch(parser: *Parser) fragment.Error!Fragment {
        const frame = parser.top();
        defer frame.pending_len = 0;
        return switch (frame.pending_len) {
            0 => parser.builder.empty(),
            1 => frame.pending[0],
            else => parser.builder.cat(frame.pending[0], frame.pending[1]),
        };
    }

    /// A `|`: the alternative before it closes, behind a split that prefers it.
    fn close_alternative(parser: *Parser) Error!void {
        const closed = try parser.branch();
        const split = try parser.builder.alternative(closed.entry);
        const frame = parser.top();
        if (frame.alternation) |*alternation| {
            parser.builder.set_second(alternation.last, split);
            alternation.last = split;
            alternation.holes = parser.builder.join(alternation.holes, closed.holes);
            alternation.nullable = alternation.nullable or closed.nullable;
            alternation.weight = @max(alternation.weight, closed.weight);
        } else {
            frame.alternation = .{
                .entry = split,
                .last = split,
                .begin = closed.begin,
                .holes = closed.holes,
                .nullable = closed.nullable,
                .weight = closed.weight,
            };
        }
    }

    /// Everything the frame read, as one fragment: its alternatives, inside its capture group.
    fn close_frame(parser: *Parser) fragment.Error!Fragment {
        var whole = try parser.branch();
        const frame = parser.top();
        if (frame.alternation) |alternation| {
            parser.builder.set_second(alternation.last, whole.entry);
            whole = .{
                .begin = @min(alternation.begin, whole.begin),
                .entry = alternation.entry,
                .holes = parser.builder.join(alternation.holes, whole.holes),
                .nullable = alternation.nullable or whole.nullable,
                .weight = @max(alternation.weight, whole.weight),
            };
        }
        if (frame.group != no_group) whole = try parser.builder.capture(whole, frame.group);
        return whole;
    }

    fn open_frame(parser: *Parser, inner: Flags, group: u32) Error!void {
        // RFC 9485 §8: an implementation that takes a regexp from an untrusted source bounds what
        // it costs. Groups nest to `depth_max` frames.
        if (parser.depth == constants.depth_max) return error.DepthTooLarge;
        parser.depth += 1;
        parser.frames[parser.depth] = .{ .flags = parser.flags, .group = group };
        parser.flags = inner;
    }

    fn open_group(parser: *Parser) Error!void {
        if (escape.take_if(&parser.reader, '?')) return parser.open_modified();
        // RFC 9485 §8: a bound on what a regexp costs. Each group takes two slots in every thread
        // of a matcher.
        if (parser.group_count == constants.groups_max) return error.GroupsTooMany;
        parser.group_count += 1;
        try parser.open_frame(parser.flags, parser.group_count - 1);
    }

    /// A group that starts `(?`: one that captures nothing, or flags.
    fn open_modified(parser: *Parser) Error!void {
        // RFC 9485 §3: atom = "(" i-regexp ")", so a pattern does not end inside a group.
        const octet = parser.reader.take_octet() catch return error.MissingParenthesis;
        switch (octet) {
            ':' => try parser.open_frame(parser.flags, no_group),
            // RFC 9485 §1: a regexp has no lookahead. No program of this module's kind holds one.
            '=', '!' => return error.UnsupportedLookaround,
            '<' => {
                // RFC 9485 §1: no lookahead, and no lookbehind either.
                if (escape.peek_is(&parser.reader, '=') or escape.peek_is(&parser.reader, '!')) return error.UnsupportedLookaround;
                // RFC 9485 §1: a regexp has no capture group, and a named one is a later step.
                return error.UnsupportedGroupName;
            },
            // RFC 9485 §1: as above, for RE2's older spelling `(?P<name>`.
            'P' => return error.UnsupportedGroupName,
            else => {
                parser.reader.unread(1);
                try parser.open_flags();
            },
        }
    }

    /// `(?flags)`, which sets flags to the end of the open group, or `(?flags:`, which opens a
    /// group with them. A `-` clears the flags after it.
    fn open_flags(parser: *Parser) Error!void {
        var flags = parser.flags;
        var value = true;
        var named = false;
        while (parser.reader.take_octet()) |octet| {
            if (set_flag(&flags, octet, value)) {
                named = true;
            } else if (octet == '-' and value) {
                value = false;
                named = false;
            } else {
                return parser.close_flags(flags, octet, named);
            }
        } else |_| {}
        // RFC 9485 §3: atom = "(" i-regexp ")", so a pattern does not end inside a group.
        return error.MissingParenthesis;
    }

    /// The octet that ends a group's flags: `)` sets them, and `:` opens a group with them.
    fn close_flags(parser: *Parser, flags: Flags, octet: u8, named: bool) Error!void {
        // RFC 9485 §3 holds no such group: it is RE2's, which names a flag of i, m, s and U
        // before ":" or ")", and after its one "-".
        if (!named or (octet != ':' and octet != ')')) return error.InvalidGroup;
        if (octet == ':') return parser.open_frame(flags, no_group);
        parser.flags = flags;
    }

    fn close_group(parser: *Parser) Error!void {
        // RFC 9485 §3: atom = "(" i-regexp ")", so a ")" closes a group that a "(" opened.
        if (parser.depth == 0) return error.UnmatchedParenthesis;
        const whole = try parser.close_frame();
        parser.flags = parser.top().flags;
        parser.depth -= 1;
        parser.push(whole);
    }

    fn quantifier(parser: *Parser, scalar: u32) Error!void {
        const frame = parser.top();
        // RFC 9485 §3: piece = atom [ quantifier ], so a quantifier follows an atom.
        if (frame.pending_len == 0) return error.MissingOperand;
        // RFC 9485 §3: piece = atom [ quantifier ], so an atom takes one quantifier.
        if (frame.quantified) return error.NestedQuantifier;
        const times = try parser.counts(scalar);
        var greed: Greed = if (escape.take_if(&parser.reader, '?')) .lazy else .greedy;
        if (parser.flags.swap_greed) greed = if (greed == .lazy) .greedy else .lazy;
        const operand = &frame.pending[frame.pending_len - 1];
        operand.* = try repeat.apply(parser.builder, operand.*, times, greed);
        frame.quantified = true;
    }

    fn counts(parser: *Parser, scalar: u32) Error!repeat.Counts {
        switch (scalar) {
            '*' => return .{ .min = 0, .max = null },
            '+' => return .{ .min = 1, .max = null },
            '?' => return .{ .min = 0, .max = 1 },
            else => assert(scalar == '{'),
        }
        const min = try parser.count();
        var max: ?u32 = min;
        if (escape.take_if(&parser.reader, ',')) {
            max = if (escape.peek_is(&parser.reader, '}')) null else try parser.count();
        }
        // RFC 9485 §3: range-quantifier = "{" QuantExact [ "," [ QuantExact ] ] "}".
        if (!escape.take_if(&parser.reader, '}')) return error.InvalidQuantifier;
        // RFC 9485 §4: a regexp means what XSD says, where the first count is at most the second.
        if (max != null and max.? < min) return error.InvalidQuantifier;
        return .{ .min = min, .max = max };
    }

    /// One count of a range quantifier: decimal digits.
    fn count(parser: *Parser) Error!u32 {
        var value: u32 = 0;
        var digits: u32 = 0;
        while (decimal_digit(&parser.reader)) |digit| : (digits += 1) {
            value = @min(value * constants.decimal_base + digit, constants.repeat_max + 1);
        }
        // RFC 9485 §3: QuantExact = 1*%x30-39, one digit or more.
        if (digits == 0) return error.InvalidQuantifier;
        // RFC 9485 §8: an implementation may limit range quantifiers in range, such as
        // a{20,200000}. A count stays at or under `repeat_max`.
        if (value > constants.repeat_max) return error.RepeatTooLarge;
        return value;
    }
};

fn decimal_digit(reader: *codec.Reader) ?u32 {
    const octet = reader.take_octet() catch return null;
    if (octet >= '0' and octet <= '9') return octet - '0';
    reader.unread(1);
    return null;
}

/// Sets the flag an octet names. False when the octet names none.
fn set_flag(flags: *Flags, octet: u8, value: bool) bool {
    switch (octet) {
        'i' => flags.case_insensitive = value,
        'm' => flags.multi_line = value,
        's' => flags.dot_matches_line_feed = value,
        'U' => flags.swap_greed = value,
        else => return false,
    }
    return true;
}

test {
    _ = @import("syntax_test.zig");
}
