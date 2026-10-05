//! Claim J14's blocks (encoder_loop_escapes.zig): their tables against RFC 8259 §7, a block with
//! every octet in every lane, and seeded strings against an escape of one octet at a time.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const claims = @import("../../claims.zig");
const escapes = @import("encoder_loop_escapes.zig");
const loop_string = @import("encoder_loop_string.zig");

const width = escapes.width;
const input_len = escapes.input_len;
const room_len = escapes.room_len;

/// The claims the blocks run under: every claim on, and with the loop's runtime safety off at
/// the caller's choice, which a test build runs with the checks on (decision 35).
const claims_run = [_]claims.Claims{ claims.vector, without_runtime_safety(claims.vector) };

fn without_runtime_safety(base: claims.Claims) claims.Claims {
    var changed = base;
    changed.encoder_token_loop_runtime_safety = false;
    return changed;
}

/// The characters a string escapes by a letter, and each one's letter (RFC 8259 §7). A string
/// may escape a solidus the same way, and the encoder carries it as it is.
const Letter = struct { character: u8, letter: u8 };
const letters = [_]Letter{
    .{ .character = '"', .letter = '"' },
    .{ .character = '\\', .letter = '\\' },
    .{ .character = '\x08', .letter = 'b' },
    .{ .character = '\x0c', .letter = 'f' },
    .{ .character = '\n', .letter = 'n' },
    .{ .character = '\r', .letter = 'r' },
    .{ .character = '\t', .letter = 't' },
};

/// The octets of a letter's escape (RFC 8259 §7).
const letter_escape_len = 2;

fn letter_of(octet: u8) ?u8 {
    for (letters) |pair| {
        if (pair.character == octet) return pair.letter;
    }
    return null;
}

/// Whether the blocks take `octet`: a character a letter escapes, or plain ASCII.
fn taken(octet: u8) bool {
    return letter_of(octet) != null or (octet >= constants.unescaped_min and octet < constants.non_ascii_min);
}

/// What `escapes.take` must take of `input` and write into `room`, an octet at a time: whole
/// blocks of octets it takes, while the input holds `input_len` octets and the room `room_len`.
fn model_take(input: []const u8, room: []u8) escapes.Took {
    var at: usize = 0;
    var written: usize = 0;
    while (input.len - at >= input_len and room.len - written >= room_len) {
        const block = input[at..][0..width];
        for (block) |octet| {
            if (!taken(octet)) return .{ .input_len = at, .output_len = written };
        }
        for (block) |octet| {
            if (letter_of(octet)) |letter| {
                room[written..][0..letter_escape_len].* = .{ '\\', letter };
                written += letter_escape_len;
            } else {
                room[written] = octet;
                written += 1;
            }
        }
        at += width;
    }
    return .{ .input_len = at, .output_len = written };
}

test "the letters' tables hold the seven characters RFC 8259 §7 escapes by a letter, and no other octet" {
    var count: usize = 0;
    for (0..std.math.maxInt(u8) + 1) |value| {
        const octet: u8 = @intCast(value);
        const slot = escapes.slot_of(octet);
        try testing.expect(slot < width);
        const matched = escapes.character_by_slot[slot] == octet;
        try testing.expectEqual(letter_of(octet) != null, matched);
        try testing.expectEqual(letter_of(octet) != null, escapes.letter_escapes(octet));
        if (letter_of(octet)) |letter| {
            try testing.expectEqual(letter, octet ^ escapes.difference_by_slot[slot]);
            try testing.expectEqual(letter, escapes.letter_of(octet));
            count += 1;
        }
    }
    try testing.expectEqual(letters.len, count);
    // No two of them share a slot, so each slot's two entries are one character's.
    for (letters, 0..) |pair, index| {
        for (letters[index + 1 ..]) |other| try testing.expect(escapes.slot_of(pair.character) != escapes.slot_of(other.character));
    }
    // A slot with no character differs by nothing.
    var slots_used: usize = 0;
    for (escapes.difference_by_slot, 0..) |difference, slot| {
        const used = for (letters) |pair| {
            if (escapes.slot_of(pair.character) == slot) break true;
        } else false;
        if (!used) try testing.expectEqual(0, difference);
        slots_used += @intFromBool(used);
    }
    try testing.expectEqual(letters.len, slots_used);
}

test "a half's table writes a reverse solidus's lane before each lane of its set, and counts both" {
    for (escapes.written_lanes, escapes.written_counts, 0..) |lanes, count, set| {
        var expected: [width]u8 = @splat(0);
        var at: usize = 0;
        for (0..width / 2) |lane| {
            if (set >> @intCast(lane) & 1 != 0) {
                expected[at] = width / 2;
                at += 1;
            }
            expected[at] = @intCast(lane);
            at += 1;
        }
        try testing.expectEqual(at, count);
        try testing.expectEqualSlices(u8, &expected, &lanes);
    }
}

test "the blocks take a block with any octet in any lane as the model does" {
    if (comptime !escapes.available) return error.SkipZigTest;
    inline for (claims_run) |run| {
        for (0..width) |lane| {
            for (0..std.math.maxInt(u8) + 1) |value| {
                var input: [input_len]u8 = @splat('a');
                input[lane] = @intCast(value);
                var room: [room_len]u8 = undefined;
                var expected: [room_len]u8 = undefined;
                const model = model_take(&input, &expected);
                try testing.expectEqual(if (taken(input[lane])) width else 0, model.input_len);
                const took = escapes.take(run, &input, &room);
                try testing.expectEqual(model, took);
                try testing.expectEqualSlices(u8, expected[0..model.output_len], room[0..took.output_len]);
            }
        }
    }
}

test "the blocks take a block of sixteen escapes, and of every one, two and three lanes escaped" {
    if (comptime !escapes.available) return error.SkipZigTest;
    for (letters) |pair| {
        var input: [input_len]u8 = @splat('a');
        input[0..width].* = @splat(pair.character);
        var room: [room_len]u8 = undefined;
        const took = escapes.take(claims.vector, &input, &room);
        try testing.expectEqual(escapes.Took{ .input_len = width, .output_len = letter_escape_len * width }, took);
        for (0..width) |lane| try testing.expectEqualSlices(u8, &.{ '\\', pair.letter }, room[letter_escape_len * lane ..][0..letter_escape_len]);
    }
    // One and two stops take the path of a few stops where a build has it, and three the lookup.
    for (0..width) |first| {
        for (first..width) |second| {
            for (second..width) |third| {
                var input: [input_len]u8 = ("0123456789abcdef" ** (input_len / width)).*;
                input[first] = '"';
                input[second] = '\n';
                input[third] = '\\';
                var room: [room_len]u8 = undefined;
                var expected: [room_len]u8 = undefined;
                const model = model_take(&input, &expected);
                try testing.expectEqual(width, model.input_len);
                const took = escapes.take(claims.vector, &input, &room);
                try testing.expectEqual(model, took);
                try testing.expectEqualSlices(u8, expected[0..model.output_len], room[0..took.output_len]);
            }
        }
    }
}

test "the blocks take nothing short of the input or the room a block reaches into, and write nothing past the room" {
    if (comptime !escapes.available) return error.SkipZigTest;
    const guard = 0xa5;
    const input = "\"line\n" ** 8;
    for (0..input.len + 1) |len| {
        for ([_]usize{ 0, 1, room_len - 1, room_len, room_len + 1, 2 * room_len - 1, 2 * room_len, 3 * room_len }) |room_given| {
            var storage: [5 * room_len]u8 = @splat(guard);
            const room = storage[room_len..][0..room_given];
            var expected: [3 * room_len]u8 = undefined;
            const model = model_take(input[0..len], expected[0..room_given]);
            const took = escapes.take(claims.vector, input[0..len], room);
            try testing.expectEqual(model, took);
            try testing.expectEqualSlices(u8, expected[0..model.output_len], room[0..took.output_len]);
            if (len < input_len or room_given < room_len) try testing.expectEqual(escapes.Took{ .input_len = 0, .output_len = 0 }, took);
            for (storage[0..room_len]) |octet| try testing.expectEqual(guard, octet);
            for (storage[room_len + room_given ..]) |octet| try testing.expectEqual(guard, octet);
        }
    }
}

/// The seeded strings, and the longest one.
const seeded_cases = 2000;
const string_blocks_max = 12;
const string_len_max = string_blocks_max * width;

/// The octets a seeded string draws from: plain ASCII and the letters' characters often, and
/// seldom an octet the blocks do not take.
const alphabet_taken = "abcdefghij 0123456789/\x7f" ++ "\"\"\\\\\n\n\r\t\x08\x0c";
const alphabet = alphabet_taken ++ "\x00\x1f\x0b\x80\xc3\xff";
const alphabet_taken_len = alphabet_taken.len;

test "seeded strings of plain ASCII, escapes and octets the blocks leave, in seeded rooms, as the model takes them" {
    if (comptime !escapes.available) return error.SkipZigTest;
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        var input: [string_len_max]u8 = undefined;
        const len: usize = @intCast(generator.below(string_len_max + 1));
        // One string in four draws an octet the blocks leave, one octet in thirty-two.
        const leaves = generator.below(4) == 0;
        for (input[0..len]) |*octet| {
            const whole = leaves and generator.below(32) == 0;
            octet.* = alphabet[@intCast(generator.below(if (whole) alphabet.len else alphabet_taken_len))];
        }
        var room: [2 * string_len_max + room_len]u8 = undefined;
        var expected: [2 * string_len_max + room_len]u8 = undefined;
        const room_given: usize = @intCast(generator.below(room.len + 1));
        const model = model_take(input[0..len], expected[0..room_given]);
        inline for (claims_run) |run| {
            const took = escapes.take(run, input[0..len], room[0..room_given]);
            try testing.expectEqual(model, took);
            try testing.expectEqualSlices(u8, expected[0..model.output_len], room[0..took.output_len]);
        }
    }
}

/// A string the blocks take whole: a quotation mark, four letters and a line feed, again and
/// again, for four of the stretches blocks that took nothing wait.
const dense_line = "\"line\n";
const dense_stretches = 4;
const dense_len = dense_stretches * constants.escape_look_len_min;
const dense = (dense_line ** (dense_len / dense_line.len + 1))[0..dense_len];

const Walk = @import("../../string_walk.zig").Walk;

/// What the hand-off took of `input` with `room` for it: the octets the walk moved past, and the
/// octets it wrote for them.
fn handed(hand: *loop_string.Hand, input: []const u8, room: []u8) escapes.Took {
    var walk: Walk = .{ .input = input, .output = room };
    hand.take(claims.vector, &walk);
    return .{ .input_len = input.len - walk.input.len, .output_len = room.len - walk.output.len };
}

/// What the hand-off takes when it gives the blocks nothing.
const none: escapes.Took = .{ .input_len = 0, .output_len = 0 };

test "the hand-off gives the blocks a string after an ASCII run, and none after a run with a longer character" {
    if (comptime !escapes.available) return error.SkipZigTest;
    var room: [letter_escape_len * dense_len]u8 = undefined;
    var expected: [letter_escape_len * dense_len]u8 = undefined;
    var hand: loop_string.Hand = .{};
    // The walk moves past what the blocks took, and its room past what they wrote.
    const model = model_take(dense, &expected);
    try testing.expect(model.input_len >= dense_len - input_len);
    try testing.expectEqual(model, handed(&hand, dense, &room));
    try testing.expectEqualSlices(u8, expected[0..model.output_len], room[0..model.output_len]);
    hand.ascii = false;
    try testing.expectEqual(none, handed(&hand, dense, &room));
    hand.ascii = true;
    try testing.expectEqual(model, handed(&hand, dense, &room));
}

test "blocks that took nothing wait until the walk has taken a stretch more" {
    if (comptime !escapes.available) return error.SkipZigTest;
    var input: [dense_len]u8 = dense.*;
    input[0] = 0;
    var room: [letter_escape_len * dense_len]u8 = undefined;
    var hand: loop_string.Hand = .{};
    try testing.expectEqual(none, handed(&hand, &input, &room));
    // From the octet after U+0000 the blocks would take the rest, and do not try within a stretch.
    for ([_]usize{ 1, constants.escape_look_len_min - 1 }) |walked| {
        try testing.expectEqual(none, handed(&hand, input[walked..], &room));
    }
    const later = handed(&hand, input[constants.escape_look_len_min..], &room);
    try testing.expect(later.input_len >= dense_len - constants.escape_look_len_min - input_len);
    // Blocks that took some octets wait for nothing.
    try testing.expectEqual(later, handed(&hand, input[constants.escape_look_len_min..], &room));
}

test "the hand-off gives the blocks nothing short of the input or the room a block reaches into, and waits for nothing then" {
    if (comptime !escapes.available) return error.SkipZigTest;
    var room: [letter_escape_len * dense_len]u8 = undefined;
    var hand: loop_string.Hand = .{};
    try testing.expectEqual(none, handed(&hand, dense[0 .. input_len - 1], &room));
    try testing.expectEqual(none, handed(&hand, dense, room[0 .. room_len - 1]));
    try testing.expectEqual(width, handed(&hand, dense[0..input_len], room[0..room_len]).input_len);
    try testing.expect(handed(&hand, dense, &room).input_len >= dense_len - input_len);
}

test "the blocks take a string where claim J14 is on and the build has their lookup, and nowhere else" {
    const off = comptime off: {
        var changed = claims.vector;
        changed.encoder_escape_blocks = false;
        break :off changed;
    };
    try testing.expectEqual(escapes.available, comptime loop_string.has_blocks(claims.vector));
    try testing.expect(!comptime loop_string.has_blocks(off));
    try testing.expect(!comptime loop_string.has_blocks(claims.scalar));
}
