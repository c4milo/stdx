//! The tests of the value encoder: the text of each shape, the same text under any split of the
//! output, and the refusal of a string that is not UTF-8.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const Decimal = @import("../format.zig").Decimal;
const value_encoder = @import("value_encoder.zig");

test "a value of every shape encodes to its text, whole and under any split of the output" {
    // Every shape, nested.
    const Color = enum { red, green };
    const Point = struct { x: i32, y: i32 };
    const Record = struct {
        name: []const u8,
        count: u16,
        ratio: Decimal,
        active: bool,
        color: Color,
        nickname: ?[]const u8,
        origin: Point,
        corners: [2]Point,
        tags: []const []const u8,
        empty: struct {},
    };

    const record: Record = .{
        .name = "caf\u{e9} \"x\"",
        .count = 7,
        .ratio = .{ .negative = true, .integer = 1, .fraction = 25, .fraction_digits = 2 },
        .active = true,
        .color = .green,
        .nickname = null,
        .origin = .{ .x = -3, .y = 4 },
        .corners = .{ .{ .x = 0, .y = 1 }, .{ .x = 2, .y = 3 } },
        .tags = &.{ "a", "bc" },
        .empty = .{},
    };

    const record_text =
        \\{"name":"café \"x\"","count":7,"ratio":-1.25,"active":true,"color":"green","nickname":null,
    ++
        \\"origin":{"x":-3,"y":4},"corners":[{"x":0,"y":1},{"x":2,"y":3}],"tags":["a","bc"],"empty":{}}
    ;

    var output: [256]u8 = undefined;
    const text = try value_encoder.encode_value(Record, &record, &output, .text, codec.Features.none());
    try testing.expectEqualStrings(record_text, text);
    try testing.expectError(error.NoSpaceLeft, value_encoder.encode_value(Record, &record, output[0..10], .text, codec.Features.none()));
    var generator = codec.split.Generator.init(61);
    for (0..200) |_| {
        var state: value_encoder.ValueEncoder(Record) = undefined;
        state.init(.text, codec.Features.none());
        var written: usize = 0;
        for (0..output.len) |_| {
            const end = @min(written + @as(usize, @intCast(generator.between(0, 9))), output.len);
            const progress = try state.encode(&record, output[written..end]);
            written += progress.written;
            if (progress.status == .done) break;
            try testing.expectEqual(codec.Status.needs_room, progress.status);
        }
        try testing.expectEqualStrings(record_text, output[0..written]);
    }
}

test "a scalar and an array encode at the top" {
    var output: [32]u8 = undefined;
    try testing.expectEqualStrings("42", try value_encoder.encode_value(u8, &42, &output, .text, codec.Features.none()));
    const list = [_]bool{ true, false };
    try testing.expectEqualStrings("[true,false]", try value_encoder.encode_value([2]bool, &list, &output, .text, codec.Features.none()));
}

test "a string that is not UTF-8 is refused" {
    var output: [64]u8 = undefined;
    const Named = struct { name: []const u8 };
    try testing.expectError(error.InvalidUtf8, value_encoder.encode_value(Named, &.{ .name = "\xff" }, &output, .text, codec.Features.none()));
}

test "a sequence's text has its record separator and line feed" {
    var output: [64]u8 = undefined;
    const Point = struct { x: i32, y: i32 };
    const point: Point = .{ .x = 1, .y = 2 };
    try testing.expectEqualStrings("\x1e{\"x\":1,\"y\":2}\n", try value_encoder.encode_value(Point, &point, &output, .sequence, codec.Features.none()));
}
