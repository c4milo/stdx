//! The tests of the value decoder: a text into each shape, the same value under any split of the
//! input, the defaults and nulls of fields no member names, each refusal, and seeded values that
//! encode and decode back.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const Decimal = @import("../format.zig").Decimal;
const Piece = @import("../framing.zig").Piece;
const value_decoder = @import("value_decoder.zig");
const value_encoder = @import("value_encoder.zig");

test "a text decodes into a value of every shape, whole and under any split of the input" {
    const Color = enum { red, green };
    const Point = struct { x: i32, y: i32 };
    const Record = struct {
        name: []const u8,
        count: u16,
        ratio: Decimal,
        active: bool,
        color: Color,
        nickname: ?[]const u8,
        origin: ?Point,
        corners: [2]Point,
        flags: [3]bool,
        limit: u8 = 9,
    };
    // Members in another order than the fields, and a field no member names.
    const text =
        \\ {"name":"café \"x\"","count":7,"ratio":-1.25,"active":true,"color":"green",
    ++
        \\ "nickname":null,"origin":{"y":4,"x":-3},"corners":[{"x":0,"y":1},{"x":2,"y":3}],
    ++
        \\ "flags":[true,false,true]}
    ;
    const check = struct {
        fn record(value: *const Record) !void {
            try testing.expectEqualStrings("caf\u{e9} \"x\"", value.name);
            try testing.expectEqual(7, value.count);
            try testing.expectEqual(Decimal{ .negative = true, .integer = 1, .fraction = 25, .fraction_digits = 2 }, value.ratio);
            try testing.expect(value.active);
            try testing.expectEqual(Color.green, value.color);
            try testing.expectEqual(null, value.nickname);
            try testing.expectEqual(Point{ .x = -3, .y = 4 }, value.origin.?);
            try testing.expectEqual(Point{ .x = 2, .y = 3 }, value.corners[1]);
            try testing.expectEqual([3]bool{ true, false, true }, value.flags);
            try testing.expectEqual(9, value.limit);
        }
    };
    var storage: [128]u8 = undefined;
    const whole = try value_decoder.decode_value(Record, text, &storage, .text, codec.Features.none());
    try check.record(&whole);
    var generator = codec.split.Generator.init(62);
    for (0..200) |_| {
        var state: value_decoder.ValueDecoder(Record) = undefined;
        state.init(.text, codec.Features.none());
        var record: Record = undefined;
        var consumed: usize = 0;
        for (0..text.len + 1) |_| {
            const end = @min(consumed + @as(usize, @intCast(generator.between(0, 7))), text.len);
            const piece: Piece = if (end == text.len) .last else .more;
            const progress = try state.decode(text[consumed..end], &storage, piece, &record);
            consumed += progress.consumed;
            if (progress.status == .done) break;
            try testing.expectEqual(codec.Status.needs_input, progress.status);
        }
        try check.record(&record);
    }
}

test "a scalar decodes at the top" {
    var storage: [8]u8 = undefined;
    try testing.expectEqual(5, try value_decoder.decode_value(u8, " 5 ", &storage, .text, codec.Features.none()));
    try testing.expectEqual(null, try value_decoder.decode_value(?bool, "null", &storage, .text, codec.Features.none()));
}

test "a field no member names takes its default, or null when optional" {
    const Settings = struct { level: u8 = 3, label: ?[]const u8, on: bool };
    var storage: [16]u8 = undefined;
    const settings = try value_decoder.decode_value(Settings, "{\"on\":false}", &storage, .text, codec.Features.none());
    try testing.expectEqual(3, settings.level);
    try testing.expectEqual(null, settings.label);
    try testing.expect(!settings.on);
}

/// Room for every refusal's strings but the one string longer than it.
const refusal_storage_len = 16;

fn expect_refused(comptime T: type, expected: anyerror, input: []const u8) !void {
    var storage: [refusal_storage_len]u8 = undefined;
    try testing.expectError(expected, value_decoder.decode_value(T, input, &storage, .text, codec.Features.none()));
}

test "each text the type cannot hold is refused with its own error" {
    const Point = struct { x: i32, y: i32 };
    try expect_refused(Point, error.UnknownField, "{\"x\":1,\"z\":2,\"y\":3}");
    try expect_refused(Point, error.DuplicateField, "{\"x\":1,\"x\":2,\"y\":3}");
    try expect_refused(Point, error.MissingField, "{\"x\":1}");
    try expect_refused(Point, error.TypeMismatch, "{\"x\":true,\"y\":3}");
    try expect_refused(Point, error.TypeMismatch, "[1,2]");
    try expect_refused(Point, error.TypeMismatch, "{\"x\":[1],\"y\":3}");
    try expect_refused([2]u8, error.ArrayLength, "[1]");
    try expect_refused([2]u8, error.ArrayLength, "[1,2,3]");
    try expect_refused(enum { red, green }, error.UnknownEnumName, "\"blue\"");
    try expect_refused(u8, error.NumberOutOfRange, "300");
    try expect_refused(?u8, error.TypeMismatch, "\"5\"");
    try expect_refused(bool, error.TypeMismatch, "1");
    try expect_refused([]const u8, error.NoSpaceLeft, "\"" ++ "a" ** 40 ++ "\"");
    try expect_refused(Point, error.Truncated, "{\"x\":1");
    // The token decoder's own refusals pass through.
    try expect_refused(Point, error.ExpectedName, "{\"x\":1,}");
}

test "seeded values encode and decode back" {
    const Point = struct { x: i32, y: i32 };
    const Record = struct {
        name: []const u8,
        count: u16,
        ratio: Decimal,
        active: bool,
        nickname: ?[]const u8,
        origin: ?Point,
        corners: [2]Point,
    };
    const words = [_][]const u8{ "", "a", "\u{e9}t\u{e9}", "tab\there", "quote\"", "\\" };
    var generator = codec.split.Generator.init(63);
    for (0..300) |_| {
        const record: Record = .{
            .name = words[generator.below(words.len)],
            .count = @truncate(generator.next()),
            .ratio = .{ .negative = generator.below(2) == 0, .integer = generator.next(), .fraction = generator.below(1000), .fraction_digits = 3 },
            .active = generator.below(2) == 0,
            .nickname = if (generator.below(2) == 0) null else words[generator.below(words.len)],
            .origin = if (generator.below(2) == 0) null else .{ .x = @bitCast(@as(u32, @truncate(generator.next()))), .y = 0 },
            .corners = .{ .{ .x = -1, .y = 1 }, .{ .x = @bitCast(@as(u32, @truncate(generator.next()))), .y = 2 } },
        };
        var output: [256]u8 = undefined;
        const encoded = try value_encoder.encode_value(Record, &record, &output, .text, codec.Features.none());
        var storage: [64]u8 = undefined;
        const decoded = try value_decoder.decode_value(Record, encoded, &storage, .text, codec.Features.none());
        var again: [256]u8 = undefined;
        try testing.expectEqualStrings(encoded, try value_encoder.encode_value(Record, &decoded, &again, .text, codec.Features.none()));
    }
}
