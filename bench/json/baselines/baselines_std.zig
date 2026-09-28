//! Zig's std.json, of Zig 0.16.0, as a bench-json baseline (decision 27), through its public
//! declarations alone. Decoding runs `Scanner` over each whole text and takes every token with
//! `nextAllocMax`, which unescapes a string that holds an escape into an arena reset for each text.
//! Encoding writes the tokens with `Stringify` into the caller's buffer. The benchmark builds this
//! module in ReleaseFast for the host, as it builds the C baselines.

const std = @import("std");
const abi = @import("abi");

/// Decodes one text into `tally`, with `arena` reset first.
pub fn decode(arena: *std.heap.ArenaAllocator, text: []const u8, tally: *abi.Tally) !void {
    _ = arena.reset(.retain_capacity);
    const allocator = arena.allocator();
    var scanner = std.json.Scanner.initCompleteInput(allocator, text);
    defer scanner.deinit();
    // Each token takes at least one octet of the text, and the last is the end of the document.
    for (0..text.len + 1) |_| {
        switch (try scanner.nextAllocMax(allocator, .alloc_if_needed, text.len)) {
            .object_begin, .array_begin => tally.containers += 1,
            .object_end, .array_end => {},
            .true, .false, .null => tally.literals += 1,
            .number, .allocated_number => tally.numbers += 1,
            .string => |string| count_string(tally, string.len),
            .allocated_string => |string| count_string(tally, string.len),
            .end_of_document => return,
            else => return error.PartialToken,
        }
    }
    return error.TooManyTokens;
}

fn count_string(tally: *abi.Tally, len: usize) void {
    tally.strings += 1;
    tally.string_len += len;
}

/// Encodes `tokens` into `output`, and returns the octets written. `scratch` holds a hex string's
/// digits or a decimal's text.
pub fn encode(tokens: []const abi.Token, output: []u8, scratch: []u8) !usize {
    var writer: std.Io.Writer = .fixed(output);
    var json: std.json.Stringify = .{ .writer = &writer };
    for (tokens) |*token| try write(&json, token, scratch);
    return writer.end;
}

fn write(json: *std.json.Stringify, token: *const abi.Token, scratch: []u8) !void {
    const octets = token.octets[0..token.len];
    switch (token.kind) {
        .begin_object => try json.beginObject(),
        .end_object => try json.endObject(),
        .begin_array => try json.beginArray(),
        .end_array => try json.endArray(),
        .name => try json.objectField(octets),
        .string => try json.write(octets),
        .hex => try json.write(hex(octets, scratch)),
        .number => try json.print("{s}", .{octets}),
        .unsigned => try json.write(token.integer),
        .signed => try json.write(@as(i64, @bitCast(token.integer))),
        .decimal => try json.print("{s}", .{decimal(token, scratch)}),
        .false => try json.write(false),
        .true => try json.write(true),
        .null => try json.write(null),
    }
}

fn hex(octets: []const u8, scratch: []u8) []const u8 {
    const digits = "0123456789abcdef";
    for (octets, 0..) |octet, index| {
        scratch[2 * index] = digits[octet >> 4];
        scratch[2 * index + 1] = digits[octet & 15];
    }
    return scratch[0 .. 2 * octets.len];
}

fn decimal(token: *const abi.Token, scratch: []u8) []const u8 {
    var writer: std.Io.Writer = .fixed(scratch);
    const sign: []const u8 = if (token.negative) "-" else "";
    writer.print("{s}{d}.", .{ sign, token.integer }) catch unreachable;
    const start = writer.end;
    var fraction = token.fraction;
    for (0..token.fraction_digits) |index| {
        scratch[start + token.fraction_digits - 1 - index] = '0' + @as(u8, @intCast(fraction % 10));
        fraction /= 10;
    }
    return scratch[0 .. start + token.fraction_digits];
}
