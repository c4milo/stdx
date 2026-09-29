//! Many tokens a call (decision 33): `Encoder.encode_batch` writes a list of items, each a token
//! with its octets as `encode` takes them, until the list ends, the output is full, or the text
//! ends. Each item takes the path `encode` takes, claim J9's fast path first, so a batch writes the
//! octets one token a call writes (invariant 5); what the batch saves is the call each token paid
//! for.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const Claims = @import("../claims.zig").Claims;
const encoder_file = @import("encoder.zig");
const Encoder = encoder_file.Encoder;
const Error = encoder_file.Error;
const Token = encoder_file.Token;
const token_loop = @import("encoder_loop.zig");

/// One token and its octets, as one call of `encode` takes them.
pub const Item = struct {
    token: Token,
    octets: []const u8 = "",
};

/// What a batch did.
pub const Batch = struct {
    /// The items written whole, from the first.
    items: usize,
    /// Octets of `items[items].octets` taken, when the output filled inside that item: the next
    /// call passes the rest of them, in that item.
    consumed: usize,
    /// Octets of the output written, from its start.
    written: usize,
    /// `needs_input` when every item is written and the text goes on, `needs_room` when the output
    /// is full inside `items[items]`, and `done` when an item ended the text.
    status: codec.Status,
};

/// `Encoder.encode_batch`, with the claims the tests and the benchmark switch (claims.zig).
pub fn encode_batch_with(encoder: *Encoder, comptime claims: Claims, items: []const Item, output: []u8) Error!Batch {
    // A call after `done` or after an error, without `init`, is a programmer error, as is a batch
    // with no item to write.
    assert(encoder.part != .done and encoder.part != .refused);
    assert(items.len > 0);
    var writer = codec.Writer.init(output);
    var written_items: usize = 0;
    var consumed: usize = 0;
    // Each pass writes an item at least, or ends the batch.
    const status: codec.Status = for (0..items.len) |_| {
        const ended = pass(encoder, claims, items, output, &written_items, &consumed, &writer) catch |err| {
            encoder.part = .refused;
            return err;
        };
        if (ended) |batch_status| break batch_status;
    } else .needs_input;
    const batch: Batch = .{ .items = written_items, .consumed = consumed, .written = writer.position, .status = status };
    check_batch(items, output.len, batch);
    return batch;
}

/// Writes the items from `written_items` on: the token loop's first (claim J11), then one through
/// `Encoder.run`. Returns the batch's status when the pass ends it, and null when it wrote an item
/// and the batch goes on.
inline fn pass(
    encoder: *Encoder,
    comptime claims: Claims,
    items: []const Item,
    output: []u8,
    written_items: *usize,
    consumed: *usize,
    writer: *codec.Writer,
) Error!?codec.Status {
    if (claims.encoder_token_loop and encoder.part == .between_tokens) {
        var written = writer.position;
        written_items.* += token_loop.take(encoder, claims, items[written_items.*..], output, &written);
        writer.position = written;
        if (encoder.part == .done) return .done;
        if (written_items.* == items.len) return .needs_input;
    }
    const item = items[written_items.*];
    codec.check_entry(item.octets, output);
    assert(item.octets.len == 0 or encoder_file.takes_input(item.token));
    var reader = codec.Reader.init(item.octets);
    switch (try encoder.run(claims, item.token, &reader, writer)) {
        .needs_input => {
            written_items.* += 1;
            return if (written_items.* == items.len) .needs_input else null;
        },
        .needs_room => {
            consumed.* = reader.consumed();
            return .needs_room;
        },
        .done => {
            written_items.* += 1;
            return .done;
        },
    }
}

/// The checks every batch makes at its exit: invariant 7 for the counts, with `needs_room` only
/// on a full output, inside an item whose octets the call took no more of than it holds.
fn check_batch(items: []const Item, output_len: usize, batch: Batch) void {
    assert(batch.written <= output_len and batch.items <= items.len);
    switch (batch.status) {
        .needs_input => assert(batch.items == items.len and batch.consumed == 0),
        .needs_room => assert(batch.written == output_len and batch.items < items.len and batch.consumed <= items[batch.items].octets.len),
        .done => assert(batch.items > 0 and batch.consumed == 0),
    }
}
