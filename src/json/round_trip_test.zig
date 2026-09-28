//! The encoder and the decoder against each other: a list of tokens a seed or the fuzzer draws,
//! grammar-valid at every depth, with strings of every escape and of characters of one to four
//! octets, hex strings, number texts, integers, decimals and literal names. It must encode to the
//! same octets under every split (invariant 5), be a text the reference parser accepts, and decode
//! to the same tokens, whole and under every split (decision 15).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const format = @import("format.zig");
const scan = @import("scan.zig");
const Framing = @import("framing.zig").Framing;
const Kind = @import("decoder/decoder.zig").Kind;
const encoder_test = @import("encoder/encoder_test.zig");
const Item = encoder_test.Item;
const decoder_test = @import("decoder/decoder_test.zig");
const reference = @import("decoder/decoder_reference_test.zig");

/// The most tokens and octets one list holds, and the longest text it encodes to.
const items_max = 96;
const storage_len_max = 2048;
const text_len_max = 8192;

/// The seeded lists each normal test run takes, and the splits each is encoded and decoded under.
const seeded_cases = 400;
const case_seeds = 4;

/// Choices drawn from the fuzzer's octets, so its mutations steer the list: four octets a choice,
/// and zeros once they run out.
const Choices = struct {
    octets: []const u8,
    position: usize = 0,

    pub fn below(self: *Choices, bound: u64) u64 {
        var value: u64 = 0;
        for (0..@sizeOf(u32)) |_| {
            const octet: u64 = if (self.position < self.octets.len) self.octets[self.position] else 0;
            self.position += 1;
            value = (value << @bitSizeOf(u8)) | octet;
        }
        return value % bound;
    }
};

/// A list of tokens, the octets they take, and the tokens the decoder must give back.
const Program = struct {
    items: [items_max]Item = undefined,
    count: usize = 0,
    storage: [storage_len_max]u8 = undefined,
    storage_len: usize = 0,
    expected: decoder_test.Transcript = .{},

    fn add(self: *Program, item: Item, kind: Kind, content: []const u8) void {
        self.items[self.count] = item;
        self.count += 1;
        self.expected.add(kind, content);
    }

    /// Room for `len` more octets and one more token, beside the closing tokens of the `depth`
    /// containers open.
    fn fits(self: *const Program, len: usize, depth: usize) bool {
        return self.storage_len + len <= self.storage.len and self.count + 1 + depth < self.items.len;
    }

    fn reserve(self: *Program, len: usize) []u8 {
        const octets = self.storage[self.storage_len..][0..len];
        self.storage_len += len;
        return octets;
    }

    fn copy(self: *Program, octets: []const u8) []const u8 {
        const kept = self.reserve(octets.len);
        @memcpy(kept, octets);
        return kept;
    }
};

/// Encodes `program` whole and under splits, requires the reference parser to accept the text and
/// the decoder to give back the program's tokens, whole and under splits.
fn check(framing: Framing, program: *const Program, seed: u64) !void {
    const items = program.items[0..program.count];
    var text: [text_len_max]u8 = undefined;
    const text_len = try encoder_test.encode_whole(.{}, framing, items, &text);
    for (0..case_seeds) |index| {
        var split_text: [text_len_max]u8 = undefined;
        const split_len = try encoder_test.encode_split(framing, items, split_text[0..text_len], seed +% index);
        try testing.expectEqualStrings(text[0..text_len], split_text[0..split_len]);
    }
    var judged: decoder_test.Transcript = .{};
    try testing.expectEqual(decoder_test.Verdict.done, reference.judge(framing, text[0..text_len], &judged));
    try testing.expectEqualStrings(program.expected.slice(), judged.slice());
    var transcript: decoder_test.Transcript = .{};
    try testing.expectEqual(decoder_test.Verdict.done, decoder_test.decode_whole(.{}, framing, text[0..text_len], &transcript));
    try testing.expectEqualStrings(program.expected.slice(), transcript.slice());
    try testing.expectEqual(decoder_test.Verdict.done, try decoder_test.expect_consistent(framing, text[0..text_len], case_seeds));
}

/// Draws a list of tokens from any source with a `below(bound)`: a seed's generator or the fuzzer's
/// choices.
const Draw = struct {
    const depth_limit = 6;
    const container_len_max = 5;
    const string_len_max = 12;
    const integer_digits_max = 5;
    const fraction_digits_max = 6;
    const exponent_digits_max = 4;
    /// The tokens a container's closing takes, beside the next value: its own, and its parent's.
    const closing_room = 2;
    /// The octets one scalar value takes at most.
    const scalar_room = string_len_max * (constants.utf8_len_max + constants.hex_digits_per_octet) + constants.number_text_len_max;

    const Value = enum { object, array, string, hex, number_text, unsigned, signed, decimal, true, false, null };
    const Character = enum { control, escaped, ascii, two_octets, three_octets, four_octets };
    const escaped = "\"\\/";
    const exponent_marks = "eE";
    const signs = "+-";
    /// The sides of a draw that says yes or no.
    const coin_sides = 2;

    fn coin(source: anytype) bool {
        return source.below(coin_sides) == 0;
    }

    fn pick(comptime T: type, source: anytype) T {
        return @enumFromInt(source.below(std.enums.values(T).len));
    }

    fn value(source: anytype, program: *Program, depth: usize) void {
        const kind = pick(Value, source);
        switch (kind) {
            .object, .array => if (depth < depth_limit and program.fits(0, depth + closing_room)) return container(source, program, depth, kind == .object),
            .true => return program.add(.{ .token = .{ .boolean = true } }, .true, ""),
            .false => return program.add(.{ .token = .{ .boolean = false } }, .false, ""),
            .null => {},
            else => if (program.fits(scalar_room, depth)) return scalar(source, program, kind),
        }
        program.add(.{ .token = .null }, .null, "");
    }

    fn container(source: anytype, program: *Program, depth: usize, object: bool) void {
        program.add(.{ .token = if (object) .begin_object else .begin_array }, if (object) .begin_object else .begin_array, "");
        for (0..source.below(container_len_max + 1)) |_| {
            if (!program.fits(scalar_room, depth + closing_room)) break;
            if (object) {
                const name = string(source, program);
                program.add(.{ .token = .{ .name = .last }, .octets = name }, .name, name);
            }
            value(source, program, depth + 1);
        }
        program.add(.{ .token = if (object) .end_object else .end_array }, if (object) .end_object else .end_array, "");
    }

    fn scalar(source: anytype, program: *Program, kind: Value) void {
        switch (kind) {
            .string => {
                const octets = string(source, program);
                program.add(.{ .token = .{ .string = .last }, .octets = octets }, .string, octets);
            },
            .hex => {
                const octets = program.reserve(source.below(string_len_max));
                for (octets) |*octet| octet.* = @intCast(source.below(std.math.maxInt(u8) + 1));
                const digits = program.reserve(constants.hex_digits_per_octet * octets.len);
                _ = scan.hex_len_scalar(octets, digits);
                program.add(.{ .token = .{ .hex = .last }, .octets = octets }, .string, digits);
            },
            .number_text => {
                const text = number(source, program);
                program.add(.{ .token = .{ .number = .last }, .octets = text }, .number, text);
            },
            else => integer(source, program, kind),
        }
    }

    fn integer(source: anytype, program: *Program, kind: Value) void {
        var buffer: format.Buffer = undefined;
        const drawn = (source.below(std.math.maxInt(u32) + 1) << @bitSizeOf(u32)) | source.below(std.math.maxInt(u32) + 1);
        switch (kind) {
            .unsigned => {
                const unsigned = drawn >> @intCast(source.below(@bitSizeOf(u64)));
                program.add(.{ .token = .{ .unsigned = unsigned } }, .number, program.copy(format.unsigned(&buffer, unsigned)));
            },
            .signed => {
                const signed: i64 = @bitCast(drawn);
                program.add(.{ .token = .{ .signed = signed } }, .number, program.copy(format.signed(&buffer, signed)));
            },
            else => {
                const digits: u5 = @intCast(1 + source.below(constants.fraction_digits_max));
                const decimal: format.Decimal = .{
                    .negative = drawn & 1 == 0,
                    .integer = drawn / constants.decimal_base,
                    .fraction = drawn % std.math.pow(u64, constants.decimal_base, digits),
                    .fraction_digits = digits,
                };
                program.add(.{ .token = .{ .decimal = decimal } }, .number, program.copy(format.decimal(&buffer, decimal)));
            },
        }
    }

    /// Characters of every kind: ASCII with the octets RFC 8259 §7 escapes weighted up, and
    /// characters of two, three and four octets, never a surrogate.
    fn string(source: anytype, program: *Program) []const u8 {
        const start = program.storage_len;
        for (0..source.below(string_len_max)) |_| {
            var octets: [constants.utf8_len_max]u8 = undefined;
            const len = std.unicode.utf8Encode(code_point(source), &octets) catch unreachable;
            _ = program.copy(octets[0..len]);
        }
        return program.storage[start..program.storage_len];
    }

    fn code_point(source: anytype) u21 {
        return switch (pick(Character, source)) {
            .control => @intCast(source.below(constants.unescaped_min)),
            .escaped => escaped[source.below(escaped.len)],
            .ascii => @intCast(constants.unescaped_min + source.below(constants.non_ascii_min - constants.unescaped_min)),
            .two_octets => @intCast(constants.non_ascii_min + source.below(constants.two_octets_max + 1 - constants.non_ascii_min)),
            .three_octets => @intCast(constants.surrogate_max + 1 + source.below(constants.three_octets_max - constants.surrogate_max)),
            .four_octets => @intCast(constants.supplementary_min + source.below(constants.code_point_max + 1 - constants.supplementary_min)),
        };
    }

    /// A number's text of RFC 8259 §6: a minus sign or none, an integer part, a fraction or none,
    /// and an exponent or none.
    fn number(source: anytype, program: *Program) []const u8 {
        const start = program.storage_len;
        if (coin(source)) _ = program.copy("-");
        if (coin(source)) _ = program.copy("0") else {
            _ = program.copy(&.{@intCast('1' + source.below(constants.decimal_base - 1))});
            digit_run(source, program, integer_digits_max);
        }
        if (coin(source)) {
            _ = program.copy(".");
            digit_run(source, program, fraction_digits_max);
        }
        if (coin(source)) {
            _ = program.copy(&.{exponent_marks[source.below(exponent_marks.len)]});
            if (coin(source)) _ = program.copy(&.{signs[source.below(signs.len)]});
            digit_run(source, program, exponent_digits_max);
        }
        return program.storage[start..program.storage_len];
    }

    /// One digit or more, at most `len_max`.
    fn digit_run(source: anytype, program: *Program, len_max: u64) void {
        for (0..1 + source.below(len_max)) |_| _ = program.copy(&.{@intCast(constants.zero + source.below(constants.decimal_base))});
    }
};

test "seeded lists of tokens encode, and decode back, alike every way" {
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        var program: Program = .{};
        Draw.value(&generator, &program, 0);
        try check(if (seed % 2 == 0) .text else .sequence, &program, generator.next());
    }
}

test "fuzz the encoder and the decoder against each other and the reference parser" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "", "\x00\x00\x00\x00", "\x00\x00\x00\x01\x00\x00\x00\x05" } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var octets: [storage_len_max]u8 = undefined;
    const len = smith.slice(&octets);
    var choices: Choices = .{ .octets = octets[0..len] };
    var program: Program = .{};
    Draw.value(&choices, &program, 0);
    try check(if (Draw.coin(&choices)) .text else .sequence, &program, smith.value(u64));
}
