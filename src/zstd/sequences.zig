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

/// A sequence table's cell: the code's value before its extra bits, from RFC 8878 §3.1.1.3.2.1.1's
/// tables (for an offset code, 2^code), the next state's bits, the code's extra bits (for an offset
/// code, the code), both counts together, and the next state's baseline (§4.1). One load gives all
/// a sequence reads of a code: the fields pack into 64 bits, the first least significant, whatever
/// the host's octet order. The baseline comes last, so one shift of the cell gives it alone.
pub const Cell = packed struct(u64) {
    base: u32,
    bits: u8,
    extra_bits: u8,
    /// `extra_bits` and `bits` together: the bits a sequence reads for this code.
    total: u7,
    /// Below the table's 2^9 cells at most.
    baseline: u9,
};

/// The cell an FSE table's entry gives for `code`.
fn cell_of_entry(comptime code: Code, entry: fse.Entry) Cell {
    const base: u32, const extra_bits: u8 = switch (code) {
        .literals_length => .{ constants.literals_length_baselines[entry.symbol], constants.literals_length_extra_bits[entry.symbol] },
        .match_length => .{ constants.match_length_baselines[entry.symbol], constants.match_length_extra_bits[entry.symbol] },
        .offset => .{ @as(u32, 1) << @intCast(entry.symbol), entry.symbol },
    };
    return .{ .base = base, .extra_bits = extra_bits, .bits = entry.bits, .total = @intCast(extra_bits + entry.bits), .baseline = @intCast(entry.baseline) };
}

/// A code's largest accuracy log (RFC 8878 §3.1.1.3.2.1).
fn log_max_of(comptime code: Code) u4 {
    return switch (code) {
        .literals_length => constants.literals_length_accuracy_log_max,
        .offset => constants.offset_accuracy_log_max,
        .match_length => constants.match_length_accuracy_log_max,
    };
}

/// The function that makes a code's cell for a symbol, with no bits and a Baseline of 0.
fn maker(comptime code: Code) fn (u8) Cell {
    return struct {
        fn make(symbol: u8) Cell {
            return cell_of_entry(code, .{ .symbol = symbol, .bits = 0, .baseline = 0 });
        }
    }.make;
}

/// The cells of a code's FSE table.
fn derive(comptime code: Code, table: *const fse.Table(log_max_of(code)), cells: []Cell) void {
    for (table.entries(), cells[0..table.entries().len]) |entry, *cell| cell.* = cell_of_entry(code, entry);
}

/// The cells of a code's default table, at comptime (decision 14, Z3).
fn default_cells(comptime code: Code, comptime table: fse.Table(log_max_of(code))) [table.entries().len]Cell {
    @setEvalBranchQuota(default_cells_eval_quota);
    var cells: [table.entries().len]Cell = undefined;
    derive(code, &table, &cells);
    return cells;
}

/// The comptime branches deriving the default tables' cells take.
const default_cells_eval_quota = 10_000;

/// The tables of the three codes, kept across blocks for Repeat_Mode (RFC 8878 §3.1.1.3.2.1). Each
/// table's cells fill the start of its array, a default distribution's copied from its comptime
/// table (decision 14, Z3), so a state indexes the array whatever mode chose the table.
pub const Tables = struct {
    literals_length: [1 << constants.literals_length_accuracy_log_max]Cell,
    offset: [1 << constants.offset_accuracy_log_max]Cell,
    match_length: [1 << constants.match_length_accuracy_log_max]Cell,
    /// The accuracy logs of the tables in `literals_length`, `offset` and `match_length`.
    accuracy_logs: [codes.len]u4,
    /// Whether a block with sequences set the tables, which Repeat_Mode needs.
    valid: bool,
    /// Invariant 17's count for the tables built since the block took it last.
    work: Work,

    pub fn init(self: *Tables) void {
        self.valid = false;
        self.work = work_module.zero;
    }

    pub fn cells(self: *const Tables, code: Code) []const Cell {
        const len = @as(usize, 1) << self.accuracy_logs[slot(code)];
        return switch (code) {
            .literals_length => self.literals_length[0..len],
            .offset => self.offset[0..len],
            .match_length => self.match_length[0..len],
        };
    }

    /// Builds a code's table from `distribution` straight into its cells.
    fn take(self: *Tables, comptime code: Code, distribution: *const fse.Distribution) Error!void {
        const work = try fse.build_cells(Cell, maker(code), self.cells_of(code), distribution);
        self.accuracy_logs[slot(code)] = distribution.accuracy_log;
        work_module.add(&self.work, work_module.of(work));
    }

    /// Takes a code's RLE_Mode table: one state, which decodes `symbol` and reads no bits (RFC
    /// 8878 §3.1.1.3.2.1).
    fn take_repeated(self: *Tables, comptime code: Code, symbol: u8) void {
        self.cells_of(code)[0] = cell_of_entry(code, .{ .symbol = symbol, .bits = 0, .baseline = 0 });
        self.accuracy_logs[slot(code)] = 0;
        work_module.add(&self.work, work_module.of(1));
    }

    /// Every cell a code's table may fill.
    fn cells_of(self: *Tables, comptime code: Code) []Cell {
        return switch (code) {
            .literals_length => &self.literals_length,
            .offset => &self.offset,
            .match_length => &self.match_length,
        };
    }

    /// Takes a code's default table, whose cells comptime built (RFC 8878 §3.1.1.3.2.2).
    fn take_default(self: *Tables, code: Code) void {
        switch (code) {
            .literals_length => self.literals_length[0..default_literals_length.len].* = default_literals_length,
            .offset => self.offset[0..default_offset.len].* = default_offset,
            .match_length => self.match_length[0..default_match_length.len].* = default_match_length,
        }
        self.accuracy_logs[slot(code)] = switch (code) {
            .literals_length => constants.literals_length_default_accuracy_log,
            .offset => constants.offset_default_accuracy_log,
            .match_length => constants.match_length_default_accuracy_log,
        };
    }

    fn accuracy_log(self: *const Tables, code: Code) u6 {
        return self.accuracy_logs[slot(code)];
    }
};

/// The default distributions' tables (RFC 8878 §3.1.1.3.2.2), built at comptime (decision 14, Z3).
const default_literals_length = default_cells(.literals_length, fse.default_table(constants.literals_length_accuracy_log_max, constants.literals_length_default_accuracy_log, &constants.literals_length_default));
const default_offset = default_cells(.offset, fse.default_table(constants.offset_accuracy_log_max, constants.offset_default_accuracy_log, &constants.offset_default));
const default_match_length = default_cells(.match_length, fse.default_table(constants.match_length_accuracy_log_max, constants.match_length_default_accuracy_log, &constants.match_length_default));

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
    switch (mode) {
        .predefined => tables.take_default(code),
        .repeat => {
            // RFC 8878 §3.1.1.3.2.1: Repeat_Mode with no earlier table in the frame is corruption.
            if (!tables.valid) return error.RepeatWithoutTable;
        },
        .repeated_symbol => {
            // RFC 8878 §3.1.1.3.2.1: RLE_Mode's description is the one symbol.
            if (octets.len == 0) return error.SequencesTruncated;
            try build_repeated(tables, code, octets[0]);
            return 1;
        },
        .compressed => return read_distribution(tables, code, octets),
    }
    return 0;
}

fn build_repeated(tables: *Tables, code: Code, symbol: u8) Error!void {
    // RFC 8878 §3.1.1.3.2.1.1: the symbol is a code of the alphabet.
    if (symbol >= symbol_limit(code)) return error.RepeatSymbolInvalid;
    switch (code) {
        inline else => |known| tables.take_repeated(known, symbol),
    }
}

fn read_distribution(tables: *Tables, code: Code, octets: []const u8) Error!usize {
    var distribution: fse.Distribution = undefined;
    const read = switch (code) {
        .literals_length => try fse.read_distribution(octets, constants.literals_length_symbols, constants.literals_length_accuracy_log_max, &distribution),
        .offset => try fse.read_distribution(octets, constants.offset_symbols, constants.offset_accuracy_log_max, &distribution),
        .match_length => try fse.read_distribution(octets, constants.match_length_symbols, constants.match_length_accuracy_log_max, &distribution),
    };
    switch (code) {
        inline else => |known| try tables.take(known, &distribution),
    }
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
    const offset_value = offset.base + @as(u32, @intCast(reader.read(@intCast(offset.extra_bits))));
    const match_len = match_length.base + @as(u32, @intCast(reader.read(@intCast(match_length.extra_bits))));
    const literals_len = literals_length.base + @as(u32, @intCast(reader.read(@intCast(literals_length.extra_bits))));
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
fn cell_of(tables: *const Tables, code: Code, state: u16) Cell {
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
