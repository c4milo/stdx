//! Claim J15's property for `TextWriter`'s methods (decision 69): each method writes its token as
//! the checked path writes it. A `TextWriter` and an encoder on the checked path take the same
//! tokens into the same room, and after every token the octets, the error and the state must
//! agree. A room with every octet the text needs takes the token loop's step, and a shorter one
//! shows the method steps aside for the checked path's `error.NoSpaceLeft`.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const base64 = @import("base64");
const claims = @import("../claims.zig");
const Framing = @import("../framing.zig").Framing;
const encoder_file = @import("encoder.zig");
const Encoder = encoder_file.Encoder;
const TextWriter = @import("text_writer.zig").TextWriter;
const encoder_test = @import("encoder_test.zig");
const Item = encoder_test.Item;
const with = encoder_test.with;
const expect_same_state = @import("encoder_fast_test.zig").expect_same_state;
const round_trip = @import("../round_trip_test.zig");

/// The most octets a list of tokens writes.
const text_len_max = 8192;

/// The seeded lists, and the shorter rooms each is written into.
const seeded_cases = 300;
const short_rooms = 3;

/// The checked path alone: neither claim J15's step nor claim J9's fast path, which J15 replaces.
const checked: claims.Claims = .{ .encoder_token_entry = false, .encoder_fast_path = false, .encoder_token_loop = false };

/// Calls the method of `text` that writes `item`, whose token holds all of its octets.
fn call(text: *TextWriter, item: Item) TextWriter.Error!void {
    return switch (item.token) {
        .begin_object => text.begin_object(),
        .end_object => text.end_object(),
        .begin_array => text.begin_array(),
        .end_array => text.end_array(),
        .name => text.name(item.octets),
        .string => text.string(item.octets),
        .hex => text.hex(item.octets),
        .number => text.number(item.octets),
        .unsigned => |value| text.unsigned(value),
        .signed => |value| text.signed(value),
        .decimal => |value| text.decimal(value),
        .boolean => |value| text.boolean(value),
        .null => text.null_literal(),
    };
}

/// Writes `items` through the methods and through the checked path, each into `room_len` octets,
/// and requires both to agree after every token. Returns the octets a text that ended wrote, or
/// null when both stopped at the same error.
fn expect_methods(framing: Framing, items: []const Item, room_len: usize) !?usize {
    var output: [text_len_max]u8 = undefined;
    var reference_output: [text_len_max]u8 = undefined;
    var text = TextWriter.init(output[0..room_len], framing, codec.Features.detect());
    var reference: Encoder = undefined;
    reference.init(framing, codec.Features.detect());
    var written: usize = 0;
    for (items) |item| {
        const result = call(&text, item);
        const progress = reference.encode_with(checked, item.token, item.octets, reference_output[written..room_len]) catch |err| {
            try testing.expectError(err, result);
            return null;
        };
        written += progress.written;
        try testing.expectEqualSlices(u8, reference_output[0..written], output[0..text.len]);
        if (progress.status == .needs_room) {
            try testing.expectError(error.NoSpaceLeft, result);
            return null;
        }
        try result;
        try expect_same_state(&text.encoder, &reference);
        if (progress.status == .done) return written;
    }
    return written;
}

/// Requires the property of `items` in both framings: with all the room, and with `short_rooms`
/// rooms that `seed` draws below the text's length.
fn check(items: []const Item, seed: u64) !void {
    var generator = codec.testing.split.Generator.init(seed);
    for ([_]Framing{ .text, .sequence }) |framing| {
        const whole = try expect_methods(framing, items, text_len_max) orelse continue;
        for (0..short_rooms) |_| {
            if (whole == 0) break;
            _ = try expect_methods(framing, items, generator.below(whole));
        }
    }
}

test "each method writes its token as the checked path does, and a record whole" {
    const record = [_]Item{
        .{ .token = .begin_object },
        with(.name, "time"),
        .{ .token = .{ .decimal = .{ .integer = 1234, .fraction = 567, .fraction_digits = 3 } } },
        with(.name, "name"),
        with(.string, "transport:packet_sent"),
        with(.name, "data"),
        .{ .token = .begin_object },
        with(.name, "dcid"),
        with(.hex, "\x00\xff\x10"),
        with(.name, "packet_number"),
        .{ .token = .{ .unsigned = 42 } },
        with(.name, "delta"),
        .{ .token = .{ .signed = -7 } },
        with(.name, "fin"),
        .{ .token = .{ .boolean = false } },
        with(.name, "gap"),
        .{ .token = .null },
        with(.name, "list"),
        .{ .token = .begin_array },
        with(.number, "2.5e-3"),
        with(.string, "tab\t\"quoted\"\\ and caf\xc3\xa9"),
        .{ .token = .begin_array },
        .{ .token = .end_array },
        .{ .token = .end_array },
        .{ .token = .end_object },
        .{ .token = .end_object },
    };
    try check(&record, 0);
    // Every room shorter than the text ends in `error.NoSpaceLeft`, with the checked path's octets.
    const whole = (try expect_methods(.text, &record, text_len_max)).?;
    for (0..whole) |room_len| try testing.expectEqual(null, try expect_methods(.text, &record, room_len));
}

test "each method leaves a refusal to the checked path, which names it" {
    const bad_utf8 = [_]Item{ .{ .token = .begin_array }, with(.string, "ok"), with(.string, "\xc3(") };
    const bad_number = [_]Item{ .{ .token = .begin_array }, with(.number, "1"), with(.number, "01") };
    for ([_][]const Item{ &bad_utf8, &bad_number }, 0..) |items, index| try check(items, index);
    var output: [text_len_max]u8 = undefined;
    var text = TextWriter.init(&output, .text, codec.Features.detect());
    try text.begin_array();
    try testing.expectError(error.InvalidUtf8, text.string("\xc3("));
}

test "seeded lists of tokens write alike through the methods and the checked path" {
    for (0..seeded_cases) |seed| {
        var generator = codec.testing.split.Generator.init(seed);
        var program: round_trip.Program = .{};
        round_trip.Draw.value(&generator, &program, 0);
        try check(program.items[0..program.count], generator.next());
    }
}

test "fuzz TextWriter's methods against the checked path" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "", "\x00\x00\x00\x00", "\x00\x00\x00\x01\x00\x00\x00\x05" } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var octets: [round_trip.storage_len_max]u8 = undefined;
    const len = smith.slice(&octets);
    var choices: round_trip.Choices = .{ .octets = octets[0..len] };
    var program: round_trip.Program = .{};
    round_trip.Draw.value(&choices, &program, 0);
    try check(program.items[0..program.count], smith.value(u64));
}

/// A token of a lockstep run, or a base 64 value: `octets` through `TextWriter.base64`, and their
/// letters as a string through the checked path (decision 73).
const Step = struct { item: Item, base64: bool = false };

/// The longest base 64 value the tests write, and its letters.
const base64_octets_max = 160;
const base64_letters_max = base64.Encoder.encoded_len(base64_octets_max, true);

/// The letters of `octets` from the base64 module's encoder, which RFC 4648 §10's vectors check.
fn letters_of(octets: []const u8, buffer: *[base64_letters_max]u8) []const u8 {
    var encoder: base64.Encoder = undefined;
    encoder.init(.{}, codec.Features.detect());
    return buffer[0 .. encoder.encode_all(octets, buffer) catch unreachable];
}

/// `expect_methods` over `steps`, a base 64 value's step through `TextWriter.base64`.
fn expect_steps(framing: Framing, steps: []const Step, room_len: usize) !?usize {
    var output: [text_len_max]u8 = undefined;
    var reference_output: [text_len_max]u8 = undefined;
    var letters_buffer: [base64_letters_max]u8 = undefined;
    var text = TextWriter.init(output[0..room_len], framing, codec.Features.detect());
    var reference: Encoder = undefined;
    reference.init(framing, codec.Features.detect());
    var written: usize = 0;
    for (steps) |step| {
        const result = if (step.base64) text.base64(step.item.octets) else call(&text, step.item);
        const octets = if (step.base64) letters_of(step.item.octets, &letters_buffer) else step.item.octets;
        const progress = reference.encode_with(checked, step.item.token, octets, reference_output[written..room_len]) catch |err| {
            try testing.expectError(err, result);
            return null;
        };
        written += progress.written;
        try testing.expectEqualSlices(u8, reference_output[0..written], output[0..text.len]);
        if (progress.status == .needs_room) {
            try testing.expectError(error.NoSpaceLeft, result);
            return null;
        }
        try result;
        try expect_same_state(&text.encoder, &reference);
        if (progress.status == .done) return written;
    }
    return written;
}

test "base64 writes RFC 4648 §10's letters, its last quantum padded" {
    const vectors = [_][2][]const u8{
        .{ "", "\"\"" },
        .{ "f", "\"Zg==\"" },
        .{ "fo", "\"Zm8=\"" },
        .{ "foo", "\"Zm9v\"" },
        .{ "foob", "\"Zm9vYg==\"" },
        .{ "fooba", "\"Zm9vYmE=\"" },
        .{ "foobar", "\"Zm9vYmFy\"" },
    };
    var output: [text_len_max]u8 = undefined;
    for (vectors) |vector| {
        var text = TextWriter.init(&output, .text, codec.Features.detect());
        try text.base64(vector[0]);
        try testing.expectEqualStrings(vector[1], text.written());
    }
}

test "base64 writes the string the checked path writes for its letters, in every room" {
    var octets: [base64_octets_max]u8 = undefined;
    var generator = codec.testing.split.Generator.init(0);
    for (&octets) |*octet| octet.* = @intCast(generator.below(std.math.maxInt(u8) + 1));
    // Every length below a few groups, and lengths past a piece of the fallback, whose pieces
    // then join.
    const lengths = [_]usize{ 0, 1, 2, 3, 4, 5, 44, 45, 46, 90, 91, base64_octets_max };
    for (lengths) |len| {
        const value: Step = .{ .item = with(.string, octets[0..len]), .base64 = true };
        const steps = [_]Step{
            .{ .item = .{ .token = .begin_object } },
            .{ .item = with(.name, "data") },
            value,
            .{ .item = with(.name, "list") },
            .{ .item = .{ .token = .begin_array } },
            value,
            value,
            .{ .item = .{ .token = .end_array } },
            .{ .item = .{ .token = .end_object } },
        };
        for ([_]Framing{ .text, .sequence }) |framing| {
            const whole = (try expect_steps(framing, &steps, text_len_max)).?;
            for (0..whole) |room_len| try testing.expectEqual(null, try expect_steps(framing, &steps, room_len));
            // A value that is the whole text.
            _ = (try expect_steps(framing, &.{value}, text_len_max)).?;
        }
    }
}
