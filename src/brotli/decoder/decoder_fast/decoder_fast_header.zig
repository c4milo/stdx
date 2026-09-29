//! The brotli header's phases in one loop, a fast path of decision 16 during design §8 step 12:
//! from the phase the decoder stands at, each phase of the meta-block's header runs its checked
//! function, `header.read_phase`, right after the one before, with no step of the decoder between
//! them; and while the input's margin holds, the reader takes whole octets a word at a time before
//! each phase, where the checked reader takes one octet at a time. The first phase that is not the
//! header's, and every status that ends the call, return to the step. Every field is read, checked
//! and applied by the checked path's own function, so the loop refuses what the checked path
//! refuses and leaves the state as its steps would.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const state_module = @import("../decoder_state.zig");
const header = @import("../decoder_header.zig");
const lengths = @import("decoder_fast_lengths.zig");
const State = state_module.State;
const Error = state_module.Error;

/// The header's phases from the one the state stands at, until one that is not the header's, or a
/// status that ends the call, which it returns.
pub fn read_header(state: *State, bits: *codec.BitReader) Error!?codec.Status {
    assert(header.is_header_phase(state.phase));
    // As the decoder's steps: every phase takes a bit, or follows one that does.
    const units = @bitSizeOf(u8) * bits.reader.remaining_len() + bits.bits.count;
    const phases_max = constants.decoder_steps_per_unit * units + constants.decoder_steps_floor;
    for (0..phases_max) |_| {
        if (!header.is_header_phase(state.phase)) return null;
        top_up(bits);
        if (try header.read_phase(true, state, bits)) |status| return status;
    }
    unreachable;
}

/// Fills the reader's buffer to 56 bits at least with whole octets of one 8-octet load while the
/// input's margin holds and the buffer holds fewer, so that a phase's `ensure` reads no octet.
fn top_up(bits: *codec.BitReader) void {
    if (bits.bits.count >= header_bits_min) return;
    var local = lengths.Bits.of(bits);
    if (local.refill_whole()) local.hand_back(bits);
}

/// The bits a phase finds in the buffer while the margin holds: those of the longest field or code
/// with its extra bits, RLEMAX's code and a map's run of zeros among them.
const header_bits_min = @bitSizeOf(u64) - @bitSizeOf(u8);

comptime {
    // The longest `ensure` of a header phase: a block count's code and its extra bits, and a map
    // value's code and its run's extra bits.
    assert(constants.code_len_max + constants.distance_extra_bits_max <= header_bits_min);
    assert(constants.code_len_max + constants.run_length_codes_max <= header_bits_min);
}
