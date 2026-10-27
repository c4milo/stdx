//! A compressed block's Sequences_Section (RFC 8878 §3.1.1.3.2): each sequence's three codes and
//! their extra bits (§3.1.1.3.2.1.1); for each code, the mode that prices its codes lowest; and
//! the bitstream, written so that a decoder reads it backward (§3.1.1.3.2.1.2).
//!
//! A mode is RLE when one code occurs. Otherwise it is the cheapest of the default table, the
//! table of the last compressed block (Repeat_Mode), and a table of the block's own counts with
//! its description. A block's choices count as the last only once the block goes out compressed,
//! as RFC 8878 §3.1.1.3.2.1 reads Repeat_Mode from "the previous Compressed_Block".

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const fse = @import("../fse.zig");
const encoder_fse = @import("encoder_fse.zig");

pub const Error = encoder_fse.Error;

/// A block's sequences, as the match finder records them.
pub const Sequences = struct {
    literals_lens: [constants.block_sequences_max]u32,
    match_lens: [constants.block_sequences_max]u32,
    offset_values: [constants.block_sequences_max]u32,
    count: usize,
};

/// The three codes of each sequence, and their extra bits' values, which a block computes once.
pub const Codes = struct {
    literals_length: [constants.block_sequences_max]u8,
    match_length: [constants.block_sequences_max]u8,
    offset: [constants.block_sequences_max]u8,
};

/// Compression_Mode (RFC 8878 §3.1.1.3.2.1, Table 15).
pub const Mode = enum(u2) { predefined = 0, rle = 1, compressed = 2, repeat = 3 };

/// The three code types, in the order the section header and the tables name them.
const Kind = enum { literals_length, offset, match_length };

/// The table state of one code type: the slot of the last compressed block's table, and the slot
/// a block builds its own in.
fn CodeState(comptime log_max: u4, comptime symbol_limit: usize, comptime default_log: u4, comptime default: []const i16) type {
    return struct {
        const Self = @This();
        pub const Table = encoder_fse.EncodeTable(log_max, symbol_limit);

        /// The default distribution's table, built at comptime (RFC 8878 §3.1.1.3.2.2).
        pub const default_table: Table = blk: {
            @setEvalBranchQuota(constants.default_encode_table_eval_quota);
            var distribution: fse.Distribution = .{ .probabilities = undefined, .symbol_count = default.len, .accuracy_log = default_log };
            @memcpy(distribution.probabilities[0..default.len], default);
            var scratch: fse.Table(log_max) = undefined;
            var built: Table = undefined;
            built.build(&distribution, &scratch);
            break :blk built;
        };

        tables: [table_slots]Table,
        /// What the last compressed block used: a mode other than `repeat`, its slot for
        /// `compressed`, its symbol for `rle`. Null before the frame's first.
        last_mode: ?Mode,
        last_slot: u1,
        last_symbol: u8,
        /// This block's choice, which `commit` makes the last.
        mode: Mode,
        symbol: u8,
        distribution: fse.Distribution,
        scratch: fse.Table(log_max),

        pub fn init(self: *Self) void {
            self.last_mode = null;
            self.last_slot = 0;
        }

        /// The table the block's codes encode through, or null for RLE.
        fn chosen_table(self: *const Self) ?*const Table {
            return switch (self.mode) {
                .rle => null,
                .predefined => &default_table,
                .compressed => &self.tables[~self.last_slot],
                .repeat => self.last_table(),
            };
        }

        /// The last compressed block's table, when it had one rather than RLE.
        fn last_table(self: *const Self) ?*const Table {
            const last = self.last_mode orelse return null;
            return switch (last) {
                .rle => null,
                .predefined => &default_table,
                .compressed => &self.tables[self.last_slot],
                .repeat => unreachable,
            };
        }

        /// Picks the mode that prices `counts` lowest, building the block's own table into the
        /// slot the last block does not hold.
        fn choose(self: *Self, counts: []const u32, total: u32) void {
            choose_mode(log_max, self, counts, total);
        }

        /// Makes this block's choice the last, once the block went out compressed with sequences.
        pub fn commit(self: *Self) void {
            commit_mode(self);
        }

        fn write_description(self: *const Self, writer: *codec.Writer) Error!void {
            return write_mode_description(self, writer);
        }
    };
}

fn choose_mode(comptime log_max: u4, self: anytype, counts: []const u32, total: u32) void {
    var present: usize = 0;
    var only: u8 = 0;
    for (counts, 0..) |count, symbol| {
        if (count == 0) continue;
        present += 1;
        only = @intCast(symbol);
    }
    assert(present > 0);
    if (present == 1) {
        const repeats = self.last_mode == .rle and self.last_symbol == only;
        self.mode = if (repeats) .repeat else .rle;
        self.symbol = only;
        return;
    }
    const default_table = &@TypeOf(self.*).default_table;
    var best_mode: Mode = .predefined;
    var best = default_table.cost(counts) orelse std.math.maxInt(u64);
    if (self.last_table()) |previous| {
        const cost = previous.cost(counts) orelse std.math.maxInt(u64);
        if (cost < best) {
            best = cost;
            best_mode = .repeat;
        }
    }
    encoder_fse.normalize(counts, total, encoder_fse.accuracy_log_for(total, present, log_max), &self.distribution);
    const own = &self.tables[~self.last_slot];
    own.build(&self.distribution, &self.scratch);
    const description_bits = description_len(&self.distribution) * @bitSizeOf(u8) * constants.cost_fraction;
    if (own.cost(counts).? + description_bits < best) best_mode = .compressed;
    self.mode = best_mode;
}

fn commit_mode(self: anytype) void {
    switch (self.mode) {
        .repeat => {},
        .compressed => {
            self.last_mode = .compressed;
            self.last_slot = ~self.last_slot;
        },
        .rle => {
            self.last_mode = .rle;
            self.last_symbol = self.symbol;
        },
        .predefined => self.last_mode = .predefined,
    }
}

/// Writes the mode's table description: a symbol for RLE, a distribution for a table of the
/// block's own, nothing else (RFC 8878 §3.1.1.3.2.1).
fn write_mode_description(self: anytype, writer: *codec.Writer) Error!void {
    switch (self.mode) {
        .rle => try writer.write_octet(self.symbol),
        .compressed => {
            var bits = codec.BitWriter.init(writer.octets[writer.position..], .{});
            try encoder_fse.write_distribution(&bits, &self.distribution);
            if (!bits.drain()) return error.NoSpaceLeft;
            writer.position += bits.writer.position;
        },
        .predefined, .repeat => {},
    }
}

/// A code type's tables: the last compressed block's, and the one a block builds.
const table_slots = 2;

/// The octets `distribution`'s description takes, written into a scratch buffer.
fn description_len(distribution: *const fse.Distribution) usize {
    var octets: [constants.fse_description_len_max]u8 = undefined;
    var writer = codec.BitWriter.init(&octets, .{});
    encoder_fse.write_distribution(&writer, distribution) catch unreachable;
    assert(writer.drain());
    return writer.writer.position;
}

pub const LiteralsLengthState = CodeState(constants.literals_length_accuracy_log_max, constants.literals_length_symbols, constants.literals_length_default_accuracy_log, &constants.literals_length_default);
pub const MatchLengthState = CodeState(constants.match_length_accuracy_log_max, constants.match_length_symbols, constants.match_length_default_accuracy_log, &constants.match_length_default);
pub const OffsetState = CodeState(constants.offset_accuracy_log_max, constants.offset_symbols, constants.offset_default_accuracy_log, &constants.offset_default);

/// The table state of all three code types, which lives for a frame.
pub const State = struct {
    literals_length: LiteralsLengthState,
    offset: OffsetState,
    match_length: MatchLengthState,

    pub fn init(self: *State) void {
        self.literals_length.init();
        self.offset.init();
        self.match_length.init();
    }

    /// Makes the block's choices the last, once it went out compressed with sequences.
    pub fn commit(self: *State) void {
        self.literals_length.commit();
        self.offset.commit();
        self.match_length.commit();
    }
};

/// The literals length code of `length` (RFC 8878 §3.1.1.3.2.1.1, Table 16).
pub fn literals_length_code(length: u32) u8 {
    if (length < literals_length_codes.len) return literals_length_codes[length];
    return @as(u8, std.math.log2_int(u32, length)) + constants.literals_length_log_code_offset;
}

/// The match length code of `length`, 3 or more (RFC 8878 §3.1.1.3.2.1.1, Table 17).
pub fn match_length_code(length: u32) u8 {
    assert(length >= constants.match_length_baselines[0]);
    const base = length - constants.match_length_baselines[0];
    if (base < match_length_codes.len) return match_length_codes[base];
    return @as(u8, std.math.log2_int(u32, base)) + constants.match_length_log_code_offset;
}

/// The offset code of `value`: the bits above its highest (RFC 8878 §3.1.1.3.2.1.1).
pub fn offset_code(value: u32) u8 {
    assert(value > 0);
    return std.math.log2_int(u32, value);
}

/// The codes of the lengths below where Table 16's and 17's codes follow the length's highest bit.
const literals_length_codes = codes_below(constants.literals_length_log_code_min, &constants.literals_length_baselines, 0);
const match_length_codes = codes_below(constants.match_length_log_code_min, &constants.match_length_baselines, constants.match_length_baselines[0]);

fn codes_below(comptime limit: usize, comptime baselines: []const u32, comptime first: u32) [limit]u8 {
    @setEvalBranchQuota(constants.default_encode_table_eval_quota);
    var codes: [limit]u8 = undefined;
    var code: u8 = 0;
    for (&codes, 0..) |*entry, base| {
        if (code + 1 < baselines.len and base + first >= baselines[code + 1]) code += 1;
        entry.* = code;
    }
    return codes;
}

comptime {
    // Past the tables, each code's baseline is a power of two above the first length.
    assert(constants.literals_length_baselines[constants.literals_length_log_code_offset + 6] == 64);
    assert(constants.match_length_baselines[constants.match_length_log_code_offset + 7] - constants.match_length_baselines[0] == 128);
}

/// Writes the Sequences_Section of `sequences` (RFC 8878 §3.1.1.3.2): the header, the tables'
/// descriptions, and the bitstream. Sets each code type's choice, for `State.commit`.
pub fn write_section(writer: *codec.Writer, sequences: *const Sequences, codes: *Codes, state: *State) Error!void {
    const count = sequences.count;
    try write_count(writer, count);
    if (count == 0) return;
    var literals_length_counts: [constants.literals_length_symbols]u32 = @splat(0);
    var match_length_counts: [constants.match_length_symbols]u32 = @splat(0);
    var offset_counts: [constants.offset_symbols]u32 = @splat(0);
    for (0..count) |index| {
        const literals_length = literals_length_code(sequences.literals_lens[index]);
        const match_length = match_length_code(sequences.match_lens[index]);
        const offset = offset_code(sequences.offset_values[index]);
        codes.literals_length[index] = literals_length;
        codes.match_length[index] = match_length;
        codes.offset[index] = offset;
        literals_length_counts[literals_length] += 1;
        match_length_counts[match_length] += 1;
        offset_counts[offset] += 1;
    }
    const total: u32 = @intCast(count);
    state.literals_length.choose(&literals_length_counts, total);
    state.offset.choose(&offset_counts, total);
    state.match_length.choose(&match_length_counts, total);
    // RFC 8878 §3.1.1.3.2.1, Table 14: the modes, the reserved bits 0.
    const modes = @as(u8, @intFromEnum(state.literals_length.mode)) << constants.literals_length_mode_shift |
        @as(u8, @intFromEnum(state.offset.mode)) << constants.offset_mode_shift |
        @as(u8, @intFromEnum(state.match_length.mode)) << constants.match_length_mode_shift;
    try writer.write_octet(modes);
    try state.literals_length.write_description(writer);
    try state.offset.write_description(writer);
    try state.match_length.write_description(writer);
    var bits = codec.BitWriter.init(writer.octets[writer.position..], .{});
    try write_bitstream(&bits, sequences, codes, state);
    writer.position += bits.writer.position;
}

/// Number_of_Sequences in one to three octets (RFC 8878 §3.1.1.3.2.1).
fn write_count(writer: *codec.Writer, count: usize) Error!void {
    if (count <= constants.sequences_one_octet_max) return writer.write_octet(@intCast(count));
    if (count < constants.sequences_long_offset) {
        try writer.write_octet(@intCast((count >> @bitSizeOf(u8)) + constants.sequences_two_octet_base));
        return writer.write_octet(@truncate(count));
    }
    try writer.write_octet(constants.sequences_three_octet_mark);
    try writer.write_int(u16, @intCast(count - constants.sequences_long_offset), .little);
}

/// One code type's encoder state while the bitstream is written: its table, or null for RLE,
/// whose states read no bits.
fn Encoding(comptime Table: type) type {
    return struct {
        table: ?*const Table,
        state: u32,

        fn start(table: ?*const Table, symbol: u8) @This() {
            return .{ .table = table, .state = if (table) |t| t.first_state(symbol) else 0 };
        }

        fn step(self: *@This(), writer: *codec.BitWriter, symbol: u8) Error!void {
            const t = self.table orelse return;
            const bits = t.step(&self.state, symbol);
            try put(writer, bits.value, bits.count);
        }

        /// `step` after a store, which left room for it (`constants.sequence_stored_room_min`).
        inline fn step_stored(self: *@This(), writer: *codec.BitWriter, symbol: u8) void {
            const t = self.table orelse return;
            const bits = t.step(&self.state, symbol);
            writer.put(bits.value, bits.count);
        }

        fn finish(self: *const @This(), writer: *codec.BitWriter) Error!void {
            const t = self.table orelse return;
            try put(writer, t.final_value(self.state), t.accuracy_log);
        }
    };
}

/// The bitstream: the last sequence first, each one's extra bits in the reverse of the order the
/// decoder reads them, and the state updates between sequences reversed too; then the three
/// starting states, Match_Length_State first, as the decoder reads Literals_Length_State first
/// (RFC 8878 §3.1.1.3.2.1.2).
fn write_bitstream(writer: *codec.BitWriter, sequences: *const Sequences, codes: *const Codes, state: *const State) Error!void {
    const count = sequences.count;
    const last = count - 1;
    var literals_length = Encoding(LiteralsLengthState.Table).start(state.literals_length.chosen_table(), codes.literals_length[last]);
    var offset = Encoding(OffsetState.Table).start(state.offset.chosen_table(), codes.offset[last]);
    var match_length = Encoding(MatchLengthState.Table).start(state.match_length.chosen_table(), codes.match_length[last]);
    try write_extra(writer, sequences, codes, last);
    var index = last;
    for (0..last) |_| {
        index -= 1;
        if (writer.writer.room_len() >= constants.sequence_stored_room_min) {
            writer.store();
            offset.step_stored(writer, codes.offset[index]);
            match_length.step_stored(writer, codes.match_length[index]);
            literals_length.step_stored(writer, codes.literals_length[index]);
            write_extra_stored(writer, sequences, codes, index);
            continue;
        }
        try offset.step(writer, codes.offset[index]);
        try match_length.step(writer, codes.match_length[index]);
        try literals_length.step(writer, codes.literals_length[index]);
        try write_extra(writer, sequences, codes, index);
    }
    try match_length.finish(writer);
    try offset.finish(writer);
    try literals_length.finish(writer);
    try put(writer, 1, 1);
    try put(writer, 0, writer.bits_to_octet());
    if (!writer.drain()) return error.NoSpaceLeft;
}

/// One sequence's extra bits, Literals_Length's first, as the decoder reads Offset's first.
fn write_extra(writer: *codec.BitWriter, sequences: *const Sequences, codes: *const Codes, index: usize) Error!void {
    const literals_length = codes.literals_length[index];
    try put(writer, sequences.literals_lens[index] - constants.literals_length_baselines[literals_length], constants.literals_length_extra_bits[literals_length]);
    const match_length = codes.match_length[index];
    try put(writer, sequences.match_lens[index] - constants.match_length_baselines[match_length], constants.match_length_extra_bits[match_length]);
    const offset = codes.offset[index];
    const offset_value = sequences.offset_values[index];
    try put(writer, offset_value - (@as(u32, 1) << @intCast(offset)), @intCast(offset));
}

/// One sequence's extra bits, as `write_extra` orders them, with a store between Literals_Length's
/// and Match_Length's (decision 14, E5). The caller stored before the state updates, and had room
/// for both stores (`constants.sequence_stored_room_min`).
fn write_extra_stored(writer: *codec.BitWriter, sequences: *const Sequences, codes: *const Codes, index: usize) void {
    const literals_length = codes.literals_length[index];
    writer.put(sequences.literals_lens[index] - constants.literals_length_baselines[literals_length], constants.literals_length_extra_bits[literals_length]);
    writer.store();
    const match_length = codes.match_length[index];
    writer.put(sequences.match_lens[index] - constants.match_length_baselines[match_length], constants.match_length_extra_bits[match_length]);
    const offset = codes.offset[index];
    writer.put(sequences.offset_values[index] - (@as(u32, 1) << @intCast(offset)), @intCast(offset));
}

fn put(writer: *codec.BitWriter, value: u64, count: u7) Error!void {
    if (!writer.make_room(count)) return error.NoSpaceLeft;
    writer.put(value, count);
}

test {
    _ = @import("encoder_sequences_test.zig");
}
