//! The stream's header and each meta-block's (RFC 7932 §9.1, §9.2): WBITS, ISLAST, MNIBBLES, MLEN
//! and ISUNCOMPRESSED; metadata, which the decoder skips; uncompressed meta-blocks; and the padding
//! after the last meta-block.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const state_module = @import("decoder_state.zig");
const State = state_module.State;
const Error = state_module.Error;

/// WBITS as its code gives it (RFC 7932 §9.1), and the bits the code takes.
const WindowBits = struct { value: u5, len: u7 };

/// WBITS (RFC 7932 §9.1), refused past `window_bits_max` (decision 12).
pub fn read_stream_header(state: *State, bits: *codec.BitReader, window_bits_max: u5) Error!?codec.Status {
    const window_bits = try window_bits_of(bits) orelse return .needs_input;
    // Decision 12: a window past the instance's is refused; RFC 7932 §12 advises the check.
    if (window_bits.value > window_bits_max) return error.WindowTooLarge;
    bits.consume(window_bits.len);
    state.window_distance_max = (@as(u32, 1) << window_bits.value) - constants.window_len_gap;
    state.phase = .meta_block_header;
    return null;
}

/// The WBITS code's value, or null while its bits are not all present.
fn window_bits_of(bits: *codec.BitReader) Error!?WindowBits {
    if (!bits.ensure(1)) return null;
    if (bits.peek(1) == 0) return .{ .value = constants.window_bits_short, .len = 1 };
    const medium_len = 1 + constants.window_bits_field_bits;
    if (!bits.ensure(medium_len)) return null;
    const medium = bits.peek(medium_len) >> 1;
    if (medium != 0) return .{ .value = @intCast(constants.window_bits_medium_base + medium), .len = medium_len };
    const long_len = medium_len + constants.window_bits_field_bits;
    if (!bits.ensure(long_len)) return null;
    const long = bits.peek(long_len) >> medium_len;
    if (long == 0) return .{ .value = constants.window_bits_medium_base, .len = long_len };
    if (long == constants.window_bits_large_signature_m) {
        if (!bits.ensure(long_len + 1)) return null;
        // RFC 9841 §6: 00010001, the pattern RFC 7932 §9.1 calls invalid and a 0 bit, starts a
        // large window's signature, which version one refuses (decision 13).
        if (bits.peek(long_len + 1) >> long_len == 0) return error.LargeWindow;
        // RFC 7932 §9.1: bit pattern 0010001 is invalid.
        return error.InvalidWindowBits;
    }
    return .{ .value = @intCast(constants.window_bits_long_base + long), .len = long_len };
}

/// ISLAST, ISLASTEMPTY and MNIBBLES (RFC 7932 §9.2).
pub fn read_meta_block_header(state: *State, bits: *codec.BitReader) ?codec.Status {
    if (!bits.ensure(1)) return .needs_input;
    const last = bits.peek(1) == 1;
    if (last) {
        if (!bits.ensure(constants.last_flags_bits)) return .needs_input;
        // ISLASTEMPTY: the stream ends here.
        if (bits.peek(constants.last_flags_bits) >> 1 == 1) {
            bits.consume(constants.last_flags_bits);
            state.last_meta_block = true;
            state.phase = .stream_end;
            return null;
        }
    }
    const flags_len: u7 = if (last) constants.last_flags_bits else 1;
    if (!bits.ensure(flags_len + constants.nibbles_field_bits)) return .needs_input;
    const nibbles_code = bits.peek(flags_len + constants.nibbles_field_bits) >> @intCast(flags_len);
    bits.consume(flags_len + constants.nibbles_field_bits);
    state.last_meta_block = last;
    if (nibbles_code == constants.nibbles_metadata_code) {
        state.phase = .metadata_header;
        return null;
    }
    state.nibbles = @intCast(nibbles_code + constants.nibbles_min);
    state.phase = .meta_block_len;
    return null;
}

/// An empty meta-block's reserved bit, MSKIPBYTES and MSKIPLEN - 1 (RFC 7932 §9.2).
pub fn read_metadata_header(state: *State, bits: *codec.BitReader) Error!?codec.Status {
    const fixed_len = 1 + constants.skip_bytes_field_bits;
    if (!bits.ensure(fixed_len)) return .needs_input;
    // RFC 7932 §9.2: the reserved bit must be zero.
    if (bits.peek(1) != 0) return error.ReservedBitSet;
    const skip_bytes: u7 = @intCast(bits.peek(fixed_len) >> 1);
    const len_bits = skip_bytes * @bitSizeOf(u8);
    if (!bits.ensure(fixed_len + len_bits)) return .needs_input;
    const skip_len_less_one = bits.peek(fixed_len + len_bits) >> fixed_len;
    // RFC 7932 §9.2: MSKIPLEN - 1 in more than one octet whose last octet is zero should be
    // rejected as invalid.
    if (skip_bytes > 1 and skip_len_less_one >> @intCast(len_bits - @bitSizeOf(u8)) == 0) return error.NonMinimalLength;
    bits.consume(fixed_len + len_bits);
    state.raw_left = if (skip_bytes == 0) 0 else @intCast(skip_len_less_one + 1);
    state.phase = .metadata_skip;
    return null;
}

/// Drops the fill bits before metadata, and skips its octets (RFC 7932 §9.2): they are no part of
/// the output or the window.
pub fn skip_metadata(state: *State, bits: *codec.BitReader) Error!?codec.Status {
    // RFC 7932 §9.2: the fill bits up to the next octet boundary must be all zeros.
    if (!drop_fill_bits(bits)) return error.NonZeroPadding;
    if (state.raw_left == 0) {
        state.phase = if (state.last_meta_block) .stream_end else .meta_block_header;
        return null;
    }
    if (bits.bits.count > 0) {
        bits.consume(@bitSizeOf(u8));
        state.raw_left -= 1;
        return null;
    }
    const skipped = bits.reader.take_partial(state.raw_left);
    if (skipped.len == 0) return .needs_input;
    state.raw_left -= @intCast(skipped.len);
    return null;
}

/// MLEN - 1, in MNIBBLES nibbles (RFC 7932 §9.2).
pub fn read_meta_block_len(state: *State, bits: *codec.BitReader) Error!?codec.Status {
    const len_bits: u7 = @intCast(state.nibbles * constants.nibble_bits);
    if (!bits.ensure(len_bits)) return .needs_input;
    const len_less_one = bits.peek(len_bits);
    // RFC 7932 §9.2: MLEN - 1 in more than four nibbles whose last nibble is zero should be
    // rejected as invalid.
    if (state.nibbles > constants.nibbles_min and len_less_one >> @intCast(len_bits - constants.nibble_bits) == 0) return error.NonMinimalLength;
    bits.consume(len_bits);
    state.meta_block_left = @intCast(len_less_one + 1);
    assert(state.meta_block_left <= constants.meta_block_len_max);
    // ISUNCOMPRESSED is present only when ISLAST is not set.
    state.phase = if (state.last_meta_block) .block_types_count else .uncompressed_flag;
    state.category = .literal;
    return null;
}

/// ISUNCOMPRESSED (RFC 7932 §9.2).
pub fn read_uncompressed_flag(state: *State, bits: *codec.BitReader) ?codec.Status {
    if (!bits.ensure(1)) return .needs_input;
    if (bits.read(1).? == 1) {
        state.phase = .uncompressed_copy;
        return null;
    }
    state.phase = .block_types_count;
    state.category = .literal;
    return null;
}

/// Copies an uncompressed meta-block's MLEN octets after dropping the bits up to the next octet
/// boundary (RFC 7932 §9.2): those the bit buffer holds one at a time, then from the input.
pub fn copy_uncompressed(state: *State, bits: *codec.BitReader, out: anytype) Error!?codec.Status {
    // RFC 7932 §9.2: the ignored bits up to the next octet boundary must be zeros.
    if (!drop_fill_bits(bits)) return error.NonZeroPadding;
    if (state.meta_block_left == 0) {
        state.phase = .meta_block_end;
        return null;
    }
    if (!out.has_room()) return .needs_room;
    if (bits.bits.count > 0) {
        out.emit(state, @intCast(bits.read(@bitSizeOf(u8)).?));
        return null;
    }
    const octets = bits.reader.take_partial(@min(state.meta_block_left, out.writer.room_len()));
    if (octets.len == 0) return .needs_input;
    for (octets) |octet| out.emit(state, octet);
    return null;
}

/// The end of a meta-block: the stream's end after the last one (RFC 7932 §9.2, ISLAST).
pub fn end_meta_block(state: *State) ?codec.Status {
    assert(state.meta_block_left == 0);
    state.phase = if (state.last_meta_block) .stream_end else .meta_block_header;
    return null;
}

/// The stream's end: the bits left in its last octet must be zeros (RFC 7932 §9.2, §9.3).
pub fn end_stream(state: *State, bits: *codec.BitReader) Error!?codec.Status {
    // RFC 7932 §9.2 and §9.3: the unused bits in the last octet must be zeros.
    if (!drop_fill_bits(bits)) return error.NonZeroPadding;
    state.phase = .done;
    return .done;
}

/// Drops the bits up to the next octet boundary, and says whether they were all zeros. After a
/// call that ran out of input, it drops nothing.
fn drop_fill_bits(bits: *codec.BitReader) bool {
    const fill: u7 = bits.bits.count % @bitSizeOf(u8);
    if (bits.peek(fill) != 0) return false;
    bits.consume(fill);
    return true;
}
