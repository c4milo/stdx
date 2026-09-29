//! Many tokens a call (decision 33): `Decoder.decode_batch` decodes tokens one after another into
//! slots the caller owns, and writes the octets of its names, strings and numbers one after another
//! into the call's output. Each token takes the path `decode` takes, claim J8's fast path first, so
//! a batch gives the tokens, octets and verdicts one token a call gives (invariant 5); what the batch
//! saves is the call each token paid for.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const Claims = @import("../claims.zig").Claims;
const Piece = @import("../framing.zig").Piece;
const decoder_file = @import("decoder.zig");
const Decoder = decoder_file.Decoder;
const Error = decoder_file.Error;
const Kind = decoder_file.Kind;
const token_loop = @import("decoder_loop.zig");

/// One token of a batch.
pub const Slot = struct {
    kind: Kind,
    /// False for a call's last slot when the call ended inside a name, a string or a number: the
    /// next call's first slot holds the rest of its octets.
    ended: bool,
    /// The token's octets are `output[start..][0..len]`. A structural character and a literal name
    /// have none.
    start: usize,
    len: usize,
};

/// How a batch ended.
pub const Status = enum {
    /// The call took all of its input and the text is not finished. With `Piece.last`, the text
    /// ended before its value did.
    needs_input,
    /// The output is full, inside a name, a string or a number whose octets go on.
    needs_room,
    /// Every slot is filled, and the text goes on.
    needs_slots,
    /// The text ended, and every rule it carries passed.
    done,
};

/// What a batch did.
pub const Batch = struct {
    /// Octets of the input taken. The caller never presents them again.
    consumed: usize,
    /// Octets of the output that hold the tokens' octets, from its start.
    written: usize,
    /// The slots filled, from the first.
    filled: usize,
    status: Status,
};

/// `Decoder.decode_batch`, with the claims the tests and the benchmark switch (claims.zig).
pub fn decode_batch_with(decoder: *Decoder, comptime claims: Claims, input: []const u8, output: []u8, piece: Piece, slots: []Slot) Error!Batch {
    codec.check_entry(input, output);
    // A call after `done` or after an error, without `init`, is a programmer error, as is a batch
    // with no slot to fill.
    assert(decoder.stage != .done and decoder.stage != .refused);
    assert(slots.len > 0);
    var reader = codec.Reader.init(input);
    var writer = codec.Writer.init(output);
    var filled: usize = 0;
    // Each pass fills a slot at least, or ends the batch.
    const status: Status = for (0..slots.len) |_| {
        const ended = pass(decoder, claims, input, output, piece, slots, &filled, &reader, &writer) catch |err| {
            decoder.stage = .refused;
            return err;
        };
        if (ended) |batch_status| break batch_status;
    } else .needs_slots;
    const batch: Batch = .{ .consumed = reader.consumed(), .written = writer.position, .filled = filled, .status = status };
    check_batch(input.len, output.len, slots, batch);
    return batch;
}

/// Fills the slots from `filled` on: the token loop's tokens first (claim J10), then one token
/// through `Decoder.run`. Returns the batch's status when the pass ends it, and null when it filled
/// a slot and the batch goes on.
inline fn pass(
    decoder: *Decoder,
    comptime claims: Claims,
    input: []const u8,
    output: []u8,
    piece: Piece,
    slots: []Slot,
    filled: *usize,
    reader: *codec.Reader,
    writer: *codec.Writer,
) Error!?Status {
    if (claims.decoder_token_loop and decoder.open == .none) {
        var cursor: token_loop.Cursor = .{ .consumed = reader.consumed(), .written = writer.position };
        filled.* += token_loop.take(decoder, claims, input, output, piece, &cursor, slots[filled.*..]);
        reader.position = cursor.consumed;
        writer.position = cursor.written;
        if (decoder.stage == .done) return .done;
        if (filled.* == slots.len) return .needs_slots;
    }
    const start = writer.position;
    const outcome = try decoder.run(claims, reader, writer, piece);
    if (outcome.kind) |kind| {
        slots[filled.*] = .{ .kind = kind, .ended = outcome.status == .token, .start = start, .len = writer.position - start };
        filled.* += 1;
    }
    return switch (outcome.status) {
        .token => if (filled.* == slots.len) .needs_slots else null,
        .needs_input => .needs_input,
        .needs_room => .needs_room,
        .done => .done,
    };
}

/// The checks every batch makes at its exit: invariant 7 for the counts; a token that did not end
/// only in the last slot, of a batch that ran out of input or room; and slots that hold the
/// output's octets in order, with none between them.
fn check_batch(input_len: usize, output_len: usize, slots: []const Slot, batch: Batch) void {
    const status: codec.Status = switch (batch.status) {
        .needs_input => .needs_input,
        .needs_room => .needs_room,
        .needs_slots, .done => .done,
    };
    codec.check_progress(input_len, output_len, .{ .consumed = batch.consumed, .written = batch.written, .status = status });
    assert(batch.filled <= slots.len and (batch.status != .needs_slots or batch.filled == slots.len));
    const ran_out = batch.status == .needs_input or batch.status == .needs_room;
    assert(batch.status != .needs_room or (batch.filled > 0 and !slots[batch.filled - 1].ended));
    var end: usize = 0;
    for (slots[0..batch.filled], 1..) |slot, filled| {
        assert(slot.start == end and (slot.ended or (ran_out and filled == batch.filled)));
        end += slot.len;
    }
    assert(end == batch.written);
}
