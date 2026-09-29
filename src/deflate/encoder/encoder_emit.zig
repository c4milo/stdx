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
fn put(emit: *Emit, writer: *codec.BitWriter, value: u64, count: u7) void {
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
    // While the output has room for a store, each symbol's codes go into the buffer and one store
    // follows: a pair's 48 bits at most on the 7 a store leaves (decision 14, E5). The first store
    // drops the whole octets a header left, so the first symbol has room.
    if (writer.has_store_room()) writer.store();
    while (emit.index < block.symbol_count and writer.has_store_room()) {
        const symbol = block.symbols[emit.index];
        if (symbol.distance == 0) {
            put_code(emit, plan, symbol.value, writer);
        } else {
            put_pair(emit, plan, symbol, writer);
        }
        writer.store();
        emit.index += 1;
    }
    // The rest, an octet at a time, as the output fills.
    for (block.symbols[emit.index..block.symbol_count]) |symbol| {
        if (!writer.make_room(constants.pair_bits_max)) return false;
        if (symbol.distance == 0) {
            put_code(emit, plan, symbol.value, writer);
        } else {
            put_pair(emit, plan, symbol, writer);
        }
        emit.index += 1;
    }
    return true;
}

fn write_code(emit: *Emit, plan: *const Plan, symbol: u16, writer: *codec.BitWriter) bool {
    if (!writer.make_room(@intCast(plan.literal_length_lengths[symbol]))) return false;
    put_code(emit, plan, symbol, writer);
    return true;
}

fn put_code(emit: *Emit, plan: *const Plan, symbol: u16, writer: *codec.BitWriter) void {
    assert(plan.literal_length_lengths[symbol] != 0);
    put(emit, writer, plan.literal_length_codes[symbol], @intCast(plan.literal_length_lengths[symbol]));
}

/// A length's code and extra bits, then its distance's (RFC 1951 §3.2.5), each in one put from its
/// code's entry.
fn put_pair(emit: *Emit, plan: *const Plan, symbol: block_module.Symbol, writer: *codec.BitWriter) void {
    const len = @as(usize, symbol.value) + constants.match_len_min;
    put_entry(emit, writer, plan.length_entries[block_module.length_code(len)], len);
    put_entry(emit, writer, plan.distance_entries[block_module.distance_code(symbol.distance)], symbol.distance);
}

/// The code of `entry` and, above it, `value` less the entry's base in its extra bits.
fn put_entry(emit: *Emit, writer: *codec.BitWriter, entry: block_module.CodeEntry, value: usize) void {
    assert(entry.code_bits != 0 and value >= entry.base);
    const extra = value - entry.base;
    assert(extra >> @intCast(entry.extra_bits) == 0);
    put(emit, writer, entry.code | @as(u64, extra) << @intCast(entry.code_bits), @intCast(entry.code_bits + entry.extra_bits));
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
