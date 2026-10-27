//! The tests of the Sequences_Section, each read back through the decoder's `read_header`, `start`
//! and `next`, with one encoder state and one decoder table set across blocks, so that
//! Repeat_Mode carries from block to block.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const sequences_module = @import("../sequences.zig");
const encoder_sequences = @import("encoder_sequences.zig");

const Sequences = encoder_sequences.Sequences;

/// Sequences a seeded generator draws in one of four shapes: short lengths and near offsets, one
/// code alone, long lengths and far offsets, and a mix.
fn draw(generator: *codec.split.Generator, drawn: *Sequences, count: usize) void {
    const shape: Shape = @enumFromInt(generator.below(@typeInfo(Shape).@"enum".fields.len));
    for (0..count) |index| {
        if (shape == .one_code) {
            drawn.literals_lens[index] = one_code.literals_len;
            drawn.match_lens[index] = one_code.match_len;
            drawn.offset_values[index] = one_code.offset_value;
            continue;
        }
        const far = shape == .far or (shape == .mixed and generator.below(far_odds) == 0);
        const range = if (far) far_range else near_range;
        drawn.literals_lens[index] = @intCast(generator.below(range.literals_len));
        drawn.match_lens[index] = @intCast(constants.match_length_baselines[0] + generator.below(range.match_len));
        drawn.offset_values[index] = @intCast(1 + generator.below(range.offset_value));
    }
    drawn.count = count;
}

const Shape = enum { near, one_code, far, mixed };

/// The sequence `one_code` repeats, and the ranges near and far sequences draw from: a mixed
/// block draws one far in `far_odds`.
const Lengths = struct { literals_len: u32, match_len: u32, offset_value: u32 };
const one_code: Lengths = .{ .literals_len = one_literals_len, .match_len = one_match_len, .offset_value = 1 };
const near_range: Lengths = .{ .literals_len = near_literals_len, .match_len = near_match_len, .offset_value = near_offset_value };
const far_range: Lengths = .{ .literals_len = far_len, .match_len = far_len, .offset_value = far_offset_value };
const one_literals_len = 5;
const one_match_len = 8;
const near_literals_len = 20;
const near_match_len = 40;
const near_offset_value = 300;
const far_len = 70_000;
const far_offset_value = 4_194_304;
const far_odds = 4;

/// Room for a section of the most sequences, far ones.
const section_len_max = 524_288;

/// State that outlives one test's stack frame: a block's sequences and codes are large.
threadlocal var sequences: Sequences = undefined;
threadlocal var codes: encoder_sequences.Codes = undefined;
threadlocal var state: encoder_sequences.State = undefined;
threadlocal var tables: sequences_module.Tables = undefined;
threadlocal var octets: [section_len_max]u8 = undefined;

test "a written section's sequences read back through the decoder, block after block" {
    var generator = codec.split.Generator.init(6);
    state.init();
    tables.init();
    for (0..60) |_| {
        const count = switch (generator.below(5)) {
            0 => 0,
            1 => 1,
            2 => generator.between(1, 10),
            3 => generator.between(100, 3000),
            else => generator.between(1, 300),
        };
        draw(&generator, &sequences, count);
        var writer = codec.Writer.init(&octets);
        try encoder_sequences.write_section(&writer, &sequences, &codes, &state);
        if (count > 0) state.commit();
        const section = writer.written();
        const header = try sequences_module.read_header(section, &tables);
        try testing.expectEqual(count, header.count);
        if (count == 0) {
            try testing.expectEqual(section.len, header.header_len);
            continue;
        }
        const stream_octets = section[header.header_len..];
        var stream = try sequences_module.start(stream_octets, &tables, header.count);
        for (0..count) |index| {
            const sequence = try sequences_module.next(&stream, stream_octets, &tables);
            try testing.expectEqual(sequences.literals_lens[index], sequence.literals_len);
            try testing.expectEqual(sequences.match_lens[index], sequence.match_len);
            try testing.expectEqual(sequences.offset_values[index], sequence.offset_value);
        }
    }
}

test "each length takes the code whose baseline and extra bits hold it" {
    for (0..131_072) |length| {
        const code = encoder_sequences.literals_length_code(@intCast(length));
        const base = constants.literals_length_baselines[code];
        try testing.expect(length >= base and length - base < @as(u32, 1) << constants.literals_length_extra_bits[code]);
    }
    for (3..131_075) |length| {
        const code = encoder_sequences.match_length_code(@intCast(length));
        const base = constants.match_length_baselines[code];
        try testing.expect(length >= base and length - base < @as(u32, 1) << constants.match_length_extra_bits[code]);
    }
}

test "Number_of_Sequences takes one, two or three octets" {
    for ([_]usize{ 0, 1, 127, 128, 0x7EFF, 0x7F00, 43_000 }) |count| {
        sequences.count = count;
        for (0..count) |index| {
            sequences.literals_lens[index] = 0;
            sequences.match_lens[index] = 3;
            sequences.offset_values[index] = 4;
        }
        state.init();
        tables.init();
        var writer = codec.Writer.init(&octets);
        try encoder_sequences.write_section(&writer, &sequences, &codes, &state);
        const header = try sequences_module.read_header(writer.written(), &tables);
        try testing.expectEqual(count, header.count);
    }
}
