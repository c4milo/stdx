//! `TextWriter`'s `member_*` methods (decision 78): each writes a member's name and its value as
//! the checked path writes the name and then the value. A `TextWriter` takes each name with the
//! value after it in one call, and an encoder on the checked path takes the two tokens. After
//! each member the octets, the error and the state must agree. A room with every octet the text
//! needs takes the token loop's step, and a shorter one shows the method steps aside for the
//! checked path's `error.NoSpaceLeft`.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const base64 = @import("base64");
const constants = @import("../constants.zig");
const claims = @import("../claims.zig");
const Framing = @import("../framing.zig").Framing;
const encoder_file = @import("encoder.zig");
const Encoder = encoder_file.Encoder;
const TextWriter = @import("text_writer.zig").TextWriter;
const loop_member = @import("encoder_loop/encoder_loop_member.zig");
const encoder_test = @import("encoder_test.zig");
const Item = encoder_test.Item;
const with = encoder_test.with;
const expect_same_state = @import("encoder_fast_test.zig").expect_same_state;
const call = @import("text_writer_test.zig").call;
const round_trip = @import("../round_trip_test.zig");

/// The most octets a list of tokens writes.
const text_len_max = 8192;

/// The seeded lists, and the shorter rooms each is written into.
const seeded_cases = 300;
const short_rooms = 3;

/// The checked path alone: neither claim J15's step nor claim J9's fast path.
const checked: claims.Claims = .{ .encoder_token_entry = false, .encoder_fast_path = false, .encoder_token_loop = false };

/// A member's value: a token, or the octets of a base 64 value, which the checked path takes as a
/// string of their letters (decision 73).
const Value = struct { item: Item, base64: bool = false };

/// The longest base 64 value the tests write, and its letters.
const base64_octets_max = 160;
const base64_letters_max = base64.Encoder.encoded_len(base64_octets_max, true);

/// Calls the `member_*` method of `text` for `name` and `value`.
fn call_member(text: *TextWriter, name: Item, value: Value) TextWriter.Error!void {
    if (value.base64) return text.member_base64(name.octets, value.item.octets);
    return switch (value.item.token) {
        .begin_object => text.member_begin_object(name.octets),
        .begin_array => text.member_begin_array(name.octets),
        .string => text.member_string(name.octets, value.item.octets),
        .hex => text.member_hex(name.octets, value.item.octets),
        .number => text.member_number(name.octets, value.item.octets),
        .unsigned => |number| text.member_unsigned(name.octets, number),
        .signed => |number| text.member_signed(name.octets, number),
        .decimal => |number| text.member_decimal(name.octets, number),
        .boolean => |truth| text.member_boolean(name.octets, truth),
        .null => text.member_null(name.octets),
        .name, .end_object, .end_array => unreachable,
    };
}

/// Where a lockstep run of members stands.
const Lockstep = struct {
    text: TextWriter,
    reference: Encoder,
    output: [text_len_max]u8 = undefined,
    reference_output: [text_len_max]u8 = undefined,
    letters: [base64_letters_max]u8 = undefined,
    room_len: usize,
    written: usize = 0,

    /// One token through the checked path, which must agree with `result`, the method's. Returns
    /// false once both stopped at the same error, or at `error.NoSpaceLeft`.
    fn reference_token(self: *Lockstep, item: Item, result: TextWriter.Error!void) !bool {
        const progress = self.reference.encode_with(checked, item.token, item.octets, self.reference_output[self.written..self.room_len]) catch |err| {
            try testing.expectError(err, result);
            try self.expect_same_octets();
            return false;
        };
        self.written += progress.written;
        if (progress.status == .needs_room) {
            try testing.expectError(error.NoSpaceLeft, result);
            try self.expect_same_octets();
            return false;
        }
        return true;
    }

    fn expect_same_octets(self: *const Lockstep) !void {
        try testing.expectEqualSlices(u8, self.reference_output[0..self.written], self.output[0..self.text.len]);
    }

    /// A member through its method, and its name and its value through the checked path.
    fn member(self: *Lockstep, name: Item, value: Value) !bool {
        const result = call_member(&self.text, name, value);
        if (!try self.reference_token(name, result)) return false;
        var item = value.item;
        if (value.base64) {
            var letters: base64.Encoder = undefined;
            letters.init(.{}, codec.Features.detect());
            item.octets = self.letters[0 .. letters.encode_all(value.item.octets, &self.letters) catch unreachable];
        }
        if (!try self.reference_token(item, result)) return false;
        try result;
        try self.expect_same_octets();
        try expect_same_state(&self.text.encoder, &self.reference);
        return true;
    }

    /// A token that is no member's, through its own method.
    fn token(self: *Lockstep, item: Item) !bool {
        const result = call(&self.text, item);
        if (!try self.reference_token(item, result)) return false;
        try result;
        try self.expect_same_octets();
        try expect_same_state(&self.text.encoder, &self.reference);
        return true;
    }
};

/// Writes `values` into `room_len` octets, each name with the value after it through a `member_*`
/// method, and the same tokens through the checked path. Returns the octets written, or null
/// when both stopped at the same error.
fn expect_members(framing: Framing, values: []const Value, room_len: usize) !?usize {
    var lockstep: Lockstep = .{ .text = undefined, .reference = undefined, .room_len = room_len };
    lockstep.text = TextWriter.init(lockstep.output[0..room_len], framing, codec.Features.detect());
    lockstep.reference.init(framing, codec.Features.detect());
    var index: usize = 0;
    for (0..values.len) |_| {
        if (index >= values.len) break;
        const value = values[index];
        const pairs = value.item.token == .name and index + 1 < values.len;
        const went_on = if (pairs) try lockstep.member(value.item, values[index + 1]) else try lockstep.token(value.item);
        if (!went_on) return null;
        index += 1 + @as(usize, @intFromBool(pairs));
    }
    return lockstep.written;
}

/// `expect_members` in both framings: with all the room, and with `short_rooms` rooms that `seed`
/// draws below the text's length.
fn check(values: []const Value, seed: u64) !void {
    var generator = codec.testing.split.Generator.init(seed);
    for ([_]Framing{ .text, .sequence }) |framing| {
        const whole = try expect_members(framing, values, text_len_max) orelse continue;
        for (0..short_rooms) |_| {
            if (whole == 0) break;
            _ = try expect_members(framing, values, generator.below(whole));
        }
    }
}

fn values_of(comptime items: []const Item) [items.len]Value {
    var values: [items.len]Value = undefined;
    for (items, &values) |item, *value| value.* = .{ .item = item };
    return values;
}

test "each member method writes its name and its value as the checked path does, in every room" {
    // An object with a member of every kind of value, names and strings that need escapes, and
    // names and strings past the 16 octets the loop copies at once.
    const record = values_of(&.{
        .{ .token = .begin_object },
        with(.name, "object"),
        .{ .token = .begin_object },
        with(.name, "string"),
        with(.string, "plain"),
        with(.name, "escaped \"name\""),
        with(.string, "tab\t\"quoted\"\\ and caf\xc3\xa9"),
        with(.name, "a name past sixteen octets"),
        with(.string, "a string past sixteen octets, and past thirty-two of them"),
        with(.name, "hex"),
        with(.hex, "\x00\xff\x10"),
        with(.name, "number"),
        with(.number, "2.5e-3"),
        with(.name, "unsigned"),
        .{ .token = .{ .unsigned = 42 } },
        with(.name, "signed"),
        .{ .token = .{ .signed = -7 } },
        with(.name, "decimal"),
        .{ .token = .{ .decimal = .{ .integer = 1234, .fraction = 567, .fraction_digits = 3 } } },
        with(.name, "true"),
        .{ .token = .{ .boolean = true } },
        with(.name, "false"),
        .{ .token = .{ .boolean = false } },
        with(.name, "null"),
        .{ .token = .null },
        with(.name, "array"),
        .{ .token = .begin_array },
        .{ .token = .{ .unsigned = 1 } },
        .{ .token = .end_array },
        with(.name, "empty"),
        .{ .token = .begin_object },
        .{ .token = .end_object },
        .{ .token = .end_object },
        .{ .token = .end_object },
    });
    try check(&record, 0);
    for ([_]Framing{ .text, .sequence }) |framing| {
        const whole = (try expect_members(framing, &record, text_len_max)).?;
        // Every room shorter than the text ends in `error.NoSpaceLeft`, with the checked path's
        // octets.
        for (0..whole) |room_len| try testing.expectEqual(null, try expect_members(framing, &record, room_len));
    }
    // The step takes each of its members whole, and leaves one that is an octet too long.
    try testing.expectEqual(14, try expect_steps_taken(&record));
}

test "the member methods write the text RFC 8259 §4 gives a small object" {
    var output: [text_len_max]u8 = undefined;
    var text = TextWriter.init(&output, .text, codec.Features.detect());
    try text.begin_object();
    try text.member_unsigned("a", 1);
    try text.member_begin_array("b");
    try text.boolean(true);
    try text.end_array();
    try text.member_begin_object("c");
    try text.member_null("d");
    try text.member_base64("e", "foobar");
    try text.end_object();
    try text.end_object();
    try testing.expectEqualStrings("{\"a\":1,\"b\":[true],\"c\":{\"d\":null,\"e\":\"Zm9vYmFy\"}}", text.written());
}

/// The step's verdict for the member `name` and `value` in `room`, from a copy of `encoder`.
fn take(encoder: *const Encoder, name: Item, value: Item, room: []u8, end: *usize) !bool {
    var copy = encoder.*;
    const name_item: Encoder.Item = .{ .token = name.token, .octets = name.octets };
    const value_item: Encoder.Item = .{ .token = value.token, .octets = value.octets };
    const taken = switch (std.meta.activeTag(value.token)) {
        .name, .end_object, .end_array => unreachable,
        inline else => |kind| loop_member.take_member(&copy, claims.vector, kind, &name_item, &value_item, room, end),
    };
    // A member the step leaves changes nothing.
    if (!taken) try expect_same_state(&copy, encoder);
    return taken;
}

/// Requires the step to take each member of `values` whole with all the room, and to leave it
/// with one octet less. Returns the members.
fn expect_steps_taken(values: []const Value) !usize {
    var encoder: Encoder = undefined;
    encoder.init(.text, codec.Features.detect());
    var output: [text_len_max]u8 = undefined;
    var room: [text_len_max]u8 = undefined;
    var written: usize = 0;
    var members: usize = 0;
    for (values, 0..) |value, index| {
        if (value.item.token == .name) {
            var end: usize = 0;
            try testing.expect(try take(&encoder, value.item, values[index + 1].item, &room, &end));
            var short_end: usize = 0;
            try testing.expect(!try take(&encoder, value.item, values[index + 1].item, room[0 .. end - 1], &short_end));
            try testing.expectEqual(0, short_end);
            members += 1;
        }
        written += (try encoder.encode_with(checked, value.item.token, value.item.octets, output[written..])).written;
    }
    return members;
}

test "a member past the depth limit, and one the grammar's rules refuse, take the checked path's error" {
    var output: [text_len_max]u8 = undefined;
    var text = TextWriter.init(&output, .text, codec.Features.detect());
    try text.begin_object();
    // RFC 8259 §9: an implementation may limit the depth of nesting.
    for (1..constants.depth_max) |_| try text.member_begin_object("a");
    try testing.expectError(error.DepthTooLarge, text.member_begin_object("a"));
    const refused = [_][]const Value{
        &values_of(&.{ .{ .token = .begin_object }, with(.name, "ok"), with(.string, "\xc3(") }),
        &values_of(&.{ .{ .token = .begin_object }, with(.name, "\xc3("), with(.string, "ok") }),
        &values_of(&.{ .{ .token = .begin_object }, with(.name, "n"), with(.number, "01") }),
    };
    for (refused, 0..) |values, index| try check(values, index);
}

test "member_base64 writes the string the checked path writes for its letters, in every room" {
    var octets: [base64_octets_max]u8 = undefined;
    var generator = codec.testing.split.Generator.init(0);
    for (&octets) |*octet| octet.* = @intCast(generator.below(std.math.maxInt(u8) + 1));
    for ([_]usize{ 0, 1, 2, 3, 44, 45, 46, 91, base64_octets_max }) |len| {
        const values = [_]Value{
            .{ .item = .{ .token = .begin_object } },
            .{ .item = with(.name, "data") },
            .{ .item = with(.string, octets[0..len]), .base64 = true },
            .{ .item = with(.name, "more \"data\"") },
            .{ .item = with(.string, octets[0..len]), .base64 = true },
            .{ .item = .{ .token = .end_object } },
        };
        for ([_]Framing{ .text, .sequence }) |framing| {
            const whole = (try expect_members(framing, &values, text_len_max)).?;
            for (0..whole) |room_len| try testing.expectEqual(null, try expect_members(framing, &values, room_len));
        }
    }
}

/// A seeded program's items as values.
fn program_values(program: *const round_trip.Program, values: []Value) []const Value {
    for (program.items[0..program.count], values[0..program.count]) |item, *value| value.* = .{ .item = item };
    return values[0..program.count];
}

test "seeded lists of tokens write alike through the member methods and the checked path" {
    var values: [round_trip.items_max]Value = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.testing.split.Generator.init(seed);
        var program: round_trip.Program = .{};
        round_trip.Draw.value(&generator, &program, 0);
        try check(program_values(&program, &values), generator.next());
    }
}

test "fuzz TextWriter's member methods against the checked path" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "", "\x00\x00\x00\x00", "\x00\x00\x00\x01\x00\x00\x00\x05" } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var octets: [round_trip.storage_len_max]u8 = undefined;
    const len = smith.slice(&octets);
    var choices: round_trip.Choices = .{ .octets = octets[0..len] };
    var program: round_trip.Program = .{};
    round_trip.Draw.value(&choices, &program, 0);
    var values: [round_trip.items_max]Value = undefined;
    try check(program_values(&program, &values), smith.value(u64));
}
