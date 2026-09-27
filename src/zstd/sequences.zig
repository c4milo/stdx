//! A compressed block's Sequences_Section (RFC 8878 §3.1.1.3.2): its header, the three FSE tables
//! its modes choose, and its sequences, decoded one at a time from a backward stream, with the
//! Repeated_Offsets they use and update (§3.1.1.5).
//!
//! The decoder keeps a sequence stream's place as numbers, not as a reader over the block, so a
//! block's sequences can run across calls and the state holds no pointer (invariant 12).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("constants.zig");
const fse = @import("fse.zig");
const work_module = @import("work.zig");
const Work = work_module.Work;

/// The three codes a sequence has, in the order the Symbol_Compression_Modes byte names them.
pub const Code = enum(u2) { literals_length, offset, match_length };
const codes = std.enums.values(Code);

/// A code's place in the arrays of three the section keeps.
pub fn slot(code: Code) usize {
    return @intFromEnum(code);
}

/// Where a code's table comes from: a default distribution's comptime table, or the state's own.
pub const Source = enum(u8) { default, built };

/// The tables of the three codes, kept across blocks for Repeat_Mode (RFC 8878 §3.1.1.3.2.1).
pub const Tables = struct {
    literals_length: fse.Table(constants.literals_length_accuracy_log_max),
    offset: fse.Table(constants.offset_accuracy_log_max),
    match_length: fse.Table(constants.match_length_accuracy_log_max),
    sources: [codes.len]Source,
    /// Whether a block with sequences set the tables, which Repeat_Mode needs.
    valid: bool,
    /// Invariant 17's count for the tables built since the block took it last.
    work: Work,

    pub fn init(self: *Tables) void {
        self.valid = false;
        self.work = work_module.zero;
    }

    pub fn cells(self: *const Tables, code: Code) []const fse.Entry {
        return switch (code) {
            .literals_length => if (self.sources[slot(code)] == .default) default_literals_length.entries() else self.literals_length.entries(),
            .offset => if (self.sources[slot(code)] == .default) default_offset.entries() else self.offset.entries(),
            .match_length => if (self.sources[slot(code)] == .default) default_match_length.entries() else self.match_length.entries(),
        };
    }

    /// The count of the last build of a code's own table.
    fn built_work(self: *const Tables, code: Code) Work {
        return switch (code) {
            .literals_length => self.literals_length.work,
            .offset => self.offset.work,
            .match_length => self.match_length.work,
        };
    }

    fn accuracy_log(self: *const Tables, code: Code) u6 {
        return std.math.log2_int(usize, self.cells(code).len);
    }
};

/// The default distributions' tables (RFC 8878 §3.1.1.3.2.2), built at comptime (decision 14, Z3).
const default_literals_length = fse.default_table(constants.literals_length_accuracy_log_max, constants.literals_length_default_accuracy_log, &constants.literals_length_default);
const default_offset = fse.default_table(constants.offset_accuracy_log_max, constants.offset_default_accuracy_log, &constants.offset_default);
const default_match_length = fse.default_table(constants.match_length_accuracy_log_max, constants.match_length_default_accuracy_log, &constants.match_length_default);

/// Every way a Sequences_Section breaks RFC 8878 §3.1.1.3.2.
pub const Error = fse.Error || error{
    SequencesTruncated,
    SequencesModesReserved,
    RepeatWithoutTable,
    RepeatSymbolInvalid,
    SequencesStreamInvalid,
    OffsetZero,
};

/// Compression_Mode (RFC 8878 §3.1.1.3.2.1, Table 15).
const Mode = enum(u2) { predefined = 0, repeated_symbol = 1, compressed = 2, repeat = 3 };

/// A section's header: its sequences, and the octets before its stream.
pub const Header = struct {
    count: u32,
    header_len: u32,
};

/// Reads the Sequences_Section_Header and the tables its modes choose into `tables` (RFC 8878
/// §3.1.1.3.2.1). With no sequences, the tables stay as they were.
pub fn read_header(section: []const u8, tables: *Tables) Error!Header {
    var reader = codec.Reader.init(section);
    const count = try read_count(&reader);
    if (count == 0) return .{ .count = 0, .header_len = @intCast(reader.consumed()) };
    // RFC 8878 §3.1.1.3.2.1: Symbol_Compression_Modes follows Number_of_Sequences.
    const modes = reader.read_octet() catch return error.SequencesTruncated;
    // RFC 8878 §3.1.1.3.2.1: the Reserved field must be all zeroes.
    if (modes & constants.modes_reserved_mask != 0) return error.SequencesModesReserved;
    const shifts = [codes.len]u3{ constants.literals_length_mode_shift, constants.offset_mode_shift, constants.match_length_mode_shift };
    for (codes, shifts) |code, shift| {
        const mode: Mode = @enumFromInt((modes >> shift) & constants.mode_mask);
        const rest = reader.take_partial(reader.remaining_len());
        const used = try read_table(rest, code, mode, tables);
        reader.unread(rest.len - used);
    }
    tables.valid = true;
    return .{ .count = count, .header_len = @intCast(reader.consumed()) };
}

/// Number_of_Sequences: one octet below 128, two below 255, and three from 255 (RFC 8878
/// §3.1.1.3.2.1).
fn read_count(reader: *codec.Reader) Error!u32 {
    // RFC 8878 §3.1.1.3.2.1: a section starts with Number_of_Sequences.
    const first = reader.read_octet() catch return error.SequencesTruncated;
    if (first <= constants.sequences_one_octet_max) return first;
    if (first <= constants.sequences_two_octet_max) {
        // RFC 8878 §3.1.1.3.2.1: a first octet of 128 to 254 takes a second.
        const second = reader.read_octet() catch return error.SequencesTruncated;
        return (@as(u32, first - constants.sequences_two_octet_base) << @bitSizeOf(u8)) + second;
    }
    // RFC 8878 §3.1.1.3.2.1: a first octet of 255 takes two more, least significant first.
    const rest = reader.read_int(u16, .little) catch return error.SequencesTruncated;
    return @as(u32, rest) + constants.sequences_long_offset;
}

/// The table one mode chooses for one code. Returns the octets its description takes.
fn read_table(octets: []const u8, code: Code, mode: Mode, tables: *Tables) Error!usize {
    const index = @intFromEnum(code);
    switch (mode) {
        .predefined => tables.sources[index] = .default,
        .repeat => {
            // RFC 8878 §3.1.1.3.2.1: Repeat_Mode with no earlier table in the frame is corruption.
            if (!tables.valid) return error.RepeatWithoutTable;
        },
        .repeated_symbol => {
            // RFC 8878 §3.1.1.3.2.1: RLE_Mode's description is the one symbol.
            if (octets.len == 0) return error.SequencesTruncated;
            try build_repeated(tables, code, octets[0]);
            tables.sources[index] = .built;
            return 1;
        },
        .compressed => {
            const read = try read_distribution(tables, code, octets);
            tables.sources[index] = .built;
            return read;
        },
    }
    return 0;
}

fn build_repeated(tables: *Tables, code: Code, symbol: u8) Error!void {
    // RFC 8878 §3.1.1.3.2.1.1: the symbol is a code of the alphabet.
    if (symbol >= symbol_limit(code)) return error.RepeatSymbolInvalid;
    switch (code) {
        .literals_length => fse.build_rle(constants.literals_length_accuracy_log_max, &tables.literals_length, symbol),
        .offset => fse.build_rle(constants.offset_accuracy_log_max, &tables.offset, symbol),
        .match_length => fse.build_rle(constants.match_length_accuracy_log_max, &tables.match_length, symbol),
    }
    work_module.add(&tables.work, tables.built_work(code));
}

fn read_distribution(tables: *Tables, code: Code, octets: []const u8) Error!usize {
    var distribution: fse.Distribution = undefined;
    const read = switch (code) {
        .literals_length => try fse.read_distribution(octets, constants.literals_length_symbols, constants.literals_length_accuracy_log_max, &distribution),
        .offset => try fse.read_distribution(octets, constants.offset_symbols, constants.offset_accuracy_log_max, &distribution),
        .match_length => try fse.read_distribution(octets, constants.match_length_symbols, constants.match_length_accuracy_log_max, &distribution),
    };
    switch (code) {
        .literals_length => try fse.build(constants.literals_length_accuracy_log_max, &tables.literals_length, &distribution),
        .offset => try fse.build(constants.offset_accuracy_log_max, &tables.offset, &distribution),
        .match_length => try fse.build(constants.match_length_accuracy_log_max, &tables.match_length, &distribution),
    }
    work_module.add(&tables.work, tables.built_work(code));
    return read;
}

fn symbol_limit(code: Code) u16 {
    return switch (code) {
        .literals_length => constants.literals_length_symbols,
        .offset => constants.offset_symbols,
        .match_length => constants.match_length_symbols,
    };
}

/// One sequence: its literals length, Offset_Value and match length (RFC 8878 §3.1.1.4).
pub const Sequence = struct {
    literals_len: u32,
    offset_value: u32,
    match_len: u32,
};

/// A section's stream as far as its sequences have been decoded: the reading position within the
/// stream, the three states, and the sequences left.
pub const Stream = struct {
    position: usize,
    overflowed: bool,
    states: [codes.len]u16,
    left: u32,

    fn reader(self: *const Stream, octets: []const u8) codec.BackwardBitReader {
        return .{ .octets = octets, .position = self.position, .overflowed = self.overflowed };
    }

    fn keep(self: *Stream, from: *const codec.BackwardBitReader) void {
        self.position = from.position;
        self.overflowed = from.overflowed;
    }
};

/// Starts the stream `octets`, which holds `count` sequences, by reading its initial states:
/// literals length, offset, then match length (RFC 8878 §3.1.1.3.2.1.2).
pub fn start(octets: []const u8, tables: *const Tables, count: u32) Error!Stream {
    assert(count > 0);
    // RFC 8878 §3.1.1.3.2.1.2: the stream's last octet holds its final 1 bit.
    var reader = codec.BackwardBitReader.init(octets) orelse return error.SequencesStreamInvalid;
    var stream: Stream = .{ .position = 0, .overflowed = false, .states = undefined, .left = count };
    for (codes, &stream.states) |code, *state| state.* = @intCast(reader.read(tables.accuracy_log(code)));
    // RFC 8878 §3.1.1.3.2.1.2: the initial states are inside the stream.
    if (reader.overflowed) return error.SequencesStreamInvalid;
    stream.keep(&reader);
    return stream;
}

/// Decodes the next sequence: offset bits, match length bits, literals length bits, then, unless
/// it is the last, the states of literals length, match length and offset. After the last, the
/// stream must be read to its first bit exactly (RFC 8878 §3.1.1.3.2.1.2).
pub fn next(stream: *Stream, octets: []const u8, tables: *const Tables) Error!Sequence {
    assert(stream.left > 0);
    var reader = stream.reader(octets);
    const literals_length = cell_of(tables, .literals_length, stream.states[slot(.literals_length)]);
    const offset = cell_of(tables, .offset, stream.states[slot(.offset)]);
    const match_length = cell_of(tables, .match_length, stream.states[slot(.match_length)]);
    const offset_code: u5 = @intCast(offset.symbol);
    const offset_value = (@as(u32, 1) << offset_code) + @as(u32, @intCast(reader.read(offset_code)));
    const match_len = constants.match_length_baselines[match_length.symbol] + @as(u32, @intCast(reader.read(constants.match_length_extra_bits[match_length.symbol])));
    const literals_len = constants.literals_length_baselines[literals_length.symbol] + @as(u32, @intCast(reader.read(constants.literals_length_extra_bits[literals_length.symbol])));
    stream.left -= 1;
    if (stream.left > 0) {
        stream.states[slot(.literals_length)] = @intCast(literals_length.baseline + reader.read(@intCast(literals_length.bits)));
        stream.states[slot(.match_length)] = @intCast(match_length.baseline + reader.read(@intCast(match_length.bits)));
        stream.states[slot(.offset)] = @intCast(offset.baseline + reader.read(@intCast(offset.bits)));
    }
    // RFC 8878 §3.1.1.3.2.1.2: a stream that ends before its sequences do, or holds bits after the
    // last, is corrupt.
    if (reader.overflowed or (stream.left == 0 and !reader.finished())) return error.SequencesStreamInvalid;
    stream.keep(&reader);
    return .{ .literals_len = literals_len, .offset_value = offset_value, .match_len = match_len };
}

/// The cell of `state` in a code's table, which a state its table's widths gave never passes.
fn cell_of(tables: *const Tables, code: Code, state: u16) fse.Entry {
    const cells = tables.cells(code);
    assert(state < cells.len);
    return cells[state];
}

/// The offset a sequence's Offset_Value names, updating the Repeated_Offsets (RFC 8878 §3.1.1.5).
/// Above 3, it is Offset_Value - 3; from 1 to 3 it names a Repeated_Offset, shifted by one when
/// the literals length is 0, where 3 then names Repeated_Offset1 - 1.
pub fn resolve_offset(repeats: *[constants.repeated_offsets_initial.len]u32, offset_value: u32, literals_len: u32) Error!u32 {
    assert(offset_value > 0);
    // The three are copied out first: an aggregate assigned in place would read an element it
    // already overwrote.
    const first, const second, const third = repeats.*;
    if (offset_value > constants.repeat_offset_values) {
        const offset = offset_value - constants.repeat_offset_values;
        repeats.* = .{ offset, first, second };
        return offset;
    }
    const index = offset_value - 1 + @intFromBool(literals_len == 0);
    const candidates = [_]u32{ first, second, third, first -% 1 };
    const offset = candidates[index];
    // Invariant 10: an offset of 0 names no decoded octet, which RFC 8878 §3.1.1.4 does not
    // name; stdx refuses it as corrupt (decision 15).
    if (offset == 0) return error.OffsetZero;
    switch (index) {
        0 => {},
        1 => repeats.* = .{ offset, first, third },
        else => repeats.* = .{ offset, first, second },
    }
    return offset;
}

test {
    _ = @import("sequences_test.zig");
}
