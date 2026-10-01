//! The encoder's block writer: it writes a planned block into the caller's output through the
//! checked bit writer, a code at a time, and stops when the output fills, keeping the phase and
//! index it reached, so the next call's room goes on from there (decision 11). It keeps no copy of
//! its output (decision 12): only the bits of a partly written octet wait in the state.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const block_module = @import("encoder_block.zig");
const Block = block_module.Block;
const Plan = block_module.Plan;

/// The parts of a block, in the order RFC 1951 §3.2 writes them.
const Phase = enum(u8) {
    /// BFINAL and BTYPE (§3.2.3).
    header,
    /// HLIT, HDIST and HCLEN (§3.2.7).
    counts,
    /// The code length code's lengths, 3 bits each, in `code_length_order` (§3.2.7).
    code_length_lengths,
    /// The code lengths, as code length symbols and their extra bits (§3.2.7).
    items,
    /// The literals and pairs (§3.2.5).
    symbols,
    end_of_block,
    /// A stored block's pad to the octet, LEN and NLEN (§3.2.4).
    stored_header,
    /// A stored block's octets.
    stored_octets,
    done,
};

pub const Emit = struct {
    phase: Phase = .done,
    /// The next item, symbol or stored octet of the phase.
    index: u32 = 0,
    /// The bits written of the block so far, which end equal to its plan's price (E3).
    bits: u64 = 0,

    pub fn start(self: *Emit) void {
        assert(self.phase == .done);
        self.* = .{ .phase = .header, .index = 0, .bits = 0 };
    }

    pub fn active(self: *const Emit) bool {
        return self.phase != .done;
    }
};

/// The phases a block passes through, at most.
const phases_max = @typeInfo(Phase).@"enum".fields.len;

/// Writes as much of the planned block as the output takes. Returns true when all of it is in the
/// bit writer, and false when the output filled first; the next call goes on from there.
pub fn write(emit: *Emit, plan: *const Plan, block: *const Block, window: []const u8, writer: *codec.BitWriter) bool {
    for (0..phases_max) |_| {
        const whole = switch (emit.phase) {
            .header => write_header(emit, plan, writer),
            .counts => write_counts(emit, plan, writer),
            .code_length_lengths => write_code_length_lengths(emit, plan, writer),
            .items => write_items(emit, plan, writer),
            .symbols => write_symbols(emit, plan, block, writer),
            .end_of_block => write_code(emit, plan, constants.end_of_block, writer),
            .stored_header => write_stored_header(emit, plan, block, writer),
            .stored_octets => write_stored_octets(emit, plan, block, window, writer),
            .done => {
                // Decision 14, E3: the block cost what its plan priced it at, to the bit.
                assert(emit.bits == plan.bits);
                return true;
            },
        };
        if (!whole) return false;
        emit.phase = next_phase(emit.phase, plan.kind);
        emit.index = 0;
    }
    unreachable;
}

fn next_phase(phase: Phase, kind: constants.BlockType) Phase {
    return switch (phase) {
        .header => switch (kind) {
            .stored => .stored_header,
            .fixed => .symbols,
            .dynamic => .counts,
            .reserved => unreachable,
        },
        .counts => .code_length_lengths,
        .code_length_lengths => .items,
        .items => .symbols,
        .symbols => .end_of_block,
        .end_of_block, .stored_octets => .done,
        .stored_header => .stored_octets,
        .done => unreachable,
    };
}

/// Puts `count` bits, and counts them.
inline fn put(emit: *Emit, writer: *codec.BitWriter, value: u64, count: u7) void {
    writer.put(value, count);
    emit.bits += count;
}

fn write_header(emit: *Emit, plan: *const Plan, writer: *codec.BitWriter) bool {
    if (!writer.make_room(constants.final_bits + constants.type_bits)) return false;
    // RFC 1951 §3.2.3: BFINAL, then BTYPE.
    put(emit, writer, @intFromBool(plan.final), constants.final_bits);
    put(emit, writer, @intFromEnum(plan.kind), constants.type_bits);
    return true;
}

fn write_counts(emit: *Emit, plan: *const Plan, writer: *codec.BitWriter) bool {
    if (!writer.make_room(constants.hlit_bits + constants.hdist_bits + constants.hclen_bits)) return false;
    // RFC 1951 §3.2.7: HLIT, HDIST and HCLEN, each less its base.
    put(emit, writer, plan.literal_length_count - constants.hlit_base, constants.hlit_bits);
    put(emit, writer, plan.distance_count - constants.hdist_base, constants.hdist_bits);
    put(emit, writer, plan.code_length_count - constants.hclen_base, constants.hclen_bits);
    return true;
}

fn write_code_length_lengths(emit: *Emit, plan: *const Plan, writer: *codec.BitWriter) bool {
    for (emit.index..plan.code_length_count) |index| {
        if (!writer.make_room(constants.code_length_code_bits)) return false;
        put(emit, writer, plan.code_length_lengths[constants.code_length_order[index]], constants.code_length_code_bits);
        emit.index += 1;
    }
    return true;
}

fn write_items(emit: *Emit, plan: *const Plan, writer: *codec.BitWriter) bool {
    for (plan.items[emit.index..plan.item_count]) |item| {
        const extra_bits: u7 = if (item.symbol >= constants.repeat_previous) constants.repeat_extra_bits[item.symbol - constants.repeat_previous] else 0;
        if (!writer.make_room(@as(u7, @intCast(plan.code_length_lengths[item.symbol])) + extra_bits)) return false;
        put(emit, writer, plan.code_length_codes[item.symbol], @intCast(plan.code_length_lengths[item.symbol]));
        put(emit, writer, item.extra, extra_bits);
        emit.index += 1;
    }
    return true;
}

fn write_symbols(emit: *Emit, plan: *const Plan, block: *const Block, writer: *codec.BitWriter) bool {
    write_symbols_stored(emit, plan, block, writer);
    // The rest, an octet at a time, as the output fills.
    for (block.symbols[emit.index..block.symbol_count]) |symbol| {
        if (!writer.make_room(constants.pair_bits_max)) return false;
        if (symbol.distance == 0) {
            put_code(emit, plan, symbol.value, writer);
        } else {
            emit.bits += put_pair(plan, symbol, writer);
        }
        emit.index += 1;
    }
    return true;
}

/// Writes symbols while the output has room for a store: each symbol's codes go into the buffer
/// and one store follows, a pair's 48 bits at most on the 7 a store leaves (decision 14, E5). The
/// loop runs on a copy of the bit writer, so its buffer, count and position stay in registers
/// through the loop, and the bits it wrote are counted once at the end. A function of its own:
/// inline in `write`, the code tables' and the symbols' addresses went to the stack, and each
/// literal loaded them back.
noinline fn write_symbols_stored(emit: *Emit, plan: *const Plan, block: *const Block, writer: *codec.BitWriter) void {
    const store_len = codec.BitWriter.store_len;
    // The first store drops the whole octets a header left, a full buffer included, so the loop
    // starts with under 8 bits and every store in it moves under 8 octets.
    if (!writer.has_store_room()) return;
    writer.store();
    const octets = writer.writer.octets;
    var position = writer.writer.position;
    var buffer = writer.bits.buffer;
    var count: usize = writer.bits.count;
    assert(count < @bitSizeOf(u8));
    const start_position = position;
    const start_count = count;
    var index = emit.index;
    const symbols = block.symbols[0..block.symbol_count];
    // Each pass puts one symbol, at most 48 bits on at most 7, or two literals, at most 30, then
    // stores the buffer whole, its whole octets counting as written (`BitWriter.store`). A second
    // literal saves a store and the shifts after it.
    while (index < symbols.len) {
        if (position + store_len > octets.len) break;
        const symbol = symbols[index];
        index += 1;
        if (symbol.distance == 0) {
            put_literal(plan, symbol.value, &buffer, &count);
            if (index < symbols.len and symbols[index].distance == 0) {
                put_literal(plan, symbols[index].value, &buffer, &count);
                index += 1;
            }
        } else {
            const length = plan.length_entries[block_module.length_code_of(symbol.value)];
            buffer |= entry_bits(length, @as(usize, symbol.value) + constants.match_len_min) << @intCast(count);
            count += length.code_bits + length.extra_bits;
            const distance = plan.distance_entries[symbol.distance_code];
            buffer |= entry_bits(distance, symbol.distance) << @intCast(count);
            count += distance.code_bits + distance.extra_bits;
        }
        assert(count <= constants.pair_bits_max + @bitSizeOf(u8) - 1);
        std.mem.writeInt(u64, octets[position..][0..store_len], buffer, .little);
        const whole = count / @bitSizeOf(u8);
        position += whole;
        buffer >>= @intCast(whole * @bitSizeOf(u8));
        count %= @bitSizeOf(u8);
    }
    writer.writer.position = position;
    writer.bits.buffer = buffer;
    writer.bits.count = @intCast(count);
    emit.bits += (position - start_position) * @bitSizeOf(u8) + count - start_count;
    emit.index = index;
}

/// Puts the code of the literal `value` above the `count` bits of `buffer`.
inline fn put_literal(plan: *const Plan, value: u8, buffer: *u64, count: *usize) void {
    assert(count.* < @bitSizeOf(u64) - constants.code_len_max);
    buffer.* |= @as(u64, plan.literal_length_codes[value]) << @intCast(count.*);
    count.* += plan.literal_length_lengths[value];
}

comptime {
    // Two literals' codes on the bits a store leaves fit the bits a pair's do.
    assert(2 * constants.code_len_max <= constants.pair_bits_max);
}

/// The code of `entry` and, above it, `value` less the entry's base in its extra bits: the bits
/// one put of the entry holds.
inline fn entry_bits(entry: block_module.CodeEntry, value: usize) u64 {
    assert(entry.code_bits != 0 and value >= entry.base);
    const extra = value - entry.base;
    assert(extra >> @intCast(entry.extra_bits) == 0);
    return entry.code | @as(u64, extra) << @intCast(entry.code_bits);
}

fn write_code(emit: *Emit, plan: *const Plan, symbol: u16, writer: *codec.BitWriter) bool {
    if (!writer.make_room(@intCast(plan.literal_length_lengths[symbol]))) return false;
    put_code(emit, plan, symbol, writer);
    return true;
}

inline fn put_code(emit: *Emit, plan: *const Plan, symbol: u16, writer: *codec.BitWriter) void {
    assert(plan.literal_length_lengths[symbol] != 0);
    put(emit, writer, plan.literal_length_codes[symbol], @intCast(plan.literal_length_lengths[symbol]));
}

/// A length's code and extra bits, then its distance's (RFC 1951 §3.2.5), each in one put from its
/// code's entry. Returns the bits put.
inline fn put_pair(plan: *const Plan, symbol: block_module.Symbol, writer: *codec.BitWriter) u7 {
    const len = @as(usize, symbol.value) + constants.match_len_min;
    const length_bits = put_entry(writer, plan.length_entries[block_module.length_code_of(symbol.value)], len);
    const distance_bits = put_entry(writer, plan.distance_entries[symbol.distance_code], symbol.distance);
    return length_bits + distance_bits;
}

/// One put of `entry_bits`. Returns the bits put.
inline fn put_entry(writer: *codec.BitWriter, entry: block_module.CodeEntry, value: usize) u7 {
    const count: u7 = @intCast(entry.code_bits + entry.extra_bits);
    writer.put(entry_bits(entry, value), count);
    return count;
}

fn write_stored_header(emit: *Emit, plan: *const Plan, block: *const Block, writer: *codec.BitWriter) bool {
    const len = stored_len(plan, block);
    const pad = writer.bits_to_octet();
    if (!writer.make_room(pad + constants.stored_header_bits)) return false;
    // RFC 1951 §3.2.4: the bits to the octet boundary, then LEN and NLEN, NLEN LEN's complement.
    put(emit, writer, 0, pad);
    put(emit, writer, len, constants.stored_len_bits);
    put(emit, writer, ~len, constants.stored_len_bits);
    return true;
}

fn write_stored_octets(emit: *Emit, plan: *const Plan, block: *const Block, window: []const u8, writer: *codec.BitWriter) bool {
    // The header ended on an octet boundary, so the buffer holds whole octets, which go first.
    if (!writer.drain() or writer.bits.count != 0) return false;
    const octets = window[block.input_start..][0..stored_len(plan, block)];
    const written = writer.writer.write_partial(octets[emit.index..]);
    emit.index += @intCast(written);
    emit.bits += written * @bitSizeOf(u8);
    return emit.index == octets.len;
}

/// A stored block's octets: the block's input, none for a flush's empty block (RFC 1951 §3.2.4).
fn stored_len(plan: *const Plan, block: *const Block) u16 {
    assert(plan.kind == .stored);
    return @intCast(block.input_len);
}
