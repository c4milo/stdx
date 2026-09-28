//! bench-json's codec loops: a candidate's decode and encode of every text of a workload, many
//! tokens a call (decision 33) or one token a call, which json.zig times and json_profile.zig
//! counts. Each candidate's loop calls its codec inline, so every candidate's loop takes the same
//! shape: LLVM inlines a codec by how many callers it has, and a candidate whose codec had a second
//! caller once paid a call a token that the others did not (bench run 36411317000).

const std = @import("std");
const json = @import("json");
const codec = @import("codec");
const abi = @import("abi");
const workloads = @import("json_workloads.zig");
const baselines = @import("baselines/baselines.zig");
const Workload = workloads.Workload;

/// The slots one decoded batch fills: 32 octets each, so a batch's stay in the L1 cache.
pub const batch_slots = 256;

/// How a candidate calls its codec: many tokens a call, as every claim's candidate does, or one,
/// the candidate decision 33 is measured against.
pub const Calls = enum { batch, one_token };

/// What a decode needs besides the workload: the output its tokens' octets go to, the slots a
/// batch fills, and the caller's features.
pub const DecodeRoom = struct {
    output: []u8,
    slots: []json.Decoder.Slot,
    features: codec.Features,
};

/// The longest text of `workload`: the output a batch needs, since a text's tokens hold no more
/// octets than it does.
pub fn text_len_max(workload: *const Workload) usize {
    var len_max: usize = 1;
    for (workload.texts) |text| len_max = @max(len_max, text.len);
    return len_max;
}

/// A decode of every text of a workload by a candidate.
pub fn Decode(comptime claims: json.Claims, comptime calls: Calls) type {
    return struct {
        const Self = @This();
        workload: *const Workload,
        room: DecodeRoom,

        pub fn run_once(context: *const anyopaque) void {
            const self: *const Self = @ptrCast(@alignCast(context));
            std.mem.doNotOptimizeAway(decode(claims, calls, self.workload, self.room));
        }
    };
}

/// Decodes every text of `workload` and returns the tally of its tokens.
pub fn decode(comptime claims: json.Claims, comptime calls: Calls, workload: *const Workload, room: DecodeRoom) abi.Tally {
    var tally: abi.Tally = .{};
    for (workload.texts) |text| {
        var decoder: json.Decoder = undefined;
        decoder.init(workload.framing, room.features);
        switch (calls) {
            .batch => decode_batches(claims, &decoder, text, room, &tally),
            .one_token => decode_tokens(claims, &decoder, text, room.output, &tally),
        }
    }
    return tally;
}

inline fn decode_batches(comptime claims: json.Claims, decoder: *json.Decoder, text: []const u8, room: DecodeRoom, tally: *abi.Tally) void {
    var consumed: usize = 0;
    for (0..text.len + 1) |_| {
        const batch = @call(.always_inline, json.Decoder.decode_batch_with, .{ decoder, claims, text[consumed..], room.output, .last, room.slots }) catch unreachable;
        consumed += batch.consumed;
        for (room.slots[0..batch.filled]) |slot| baselines.count_token(tally, slot.kind, slot.len);
        switch (batch.status) {
            .needs_slots => {},
            .done => break,
            .needs_input, .needs_room => unreachable,
        }
    } else unreachable;
    std.debug.assert(consumed == text.len);
}

inline fn decode_tokens(comptime claims: json.Claims, decoder: *json.Decoder, text: []const u8, output: []u8, tally: *abi.Tally) void {
    var consumed: usize = 0;
    for (0..text.len + 2) |_| {
        const progress = @call(.always_inline, json.Decoder.decode_with, .{ decoder, claims, text[consumed..], output, .last }) catch unreachable;
        consumed += progress.consumed;
        switch (progress.status) {
            .token => baselines.count_token(tally, progress.kind.?, progress.written),
            .done => break,
            .needs_input, .needs_room => unreachable,
        }
    } else unreachable;
    std.debug.assert(consumed == text.len);
}

/// Decodes every text of `workload` in batches and returns a hash of its tokens, so candidates
/// compare before any is timed.
pub fn tokens_hash(comptime claims: json.Claims, workload: *const Workload, room: DecodeRoom) u64 {
    var hash = std.hash.Wyhash.init(0);
    for (workload.texts) |text| {
        var decoder: json.Decoder = undefined;
        decoder.init(workload.framing, room.features);
        var consumed: usize = 0;
        for (0..text.len + 1) |_| {
            const batch = @call(.always_inline, json.Decoder.decode_batch_with, .{ &decoder, claims, text[consumed..], room.output, .last, room.slots }) catch unreachable;
            consumed += batch.consumed;
            for (room.slots[0..batch.filled]) |slot| {
                std.debug.assert(slot.ended);
                hash.update(&.{@intFromEnum(slot.kind)});
                hash.update(room.output[slot.start..][0..slot.len]);
            }
            if (batch.status == .done) break;
        } else unreachable;
    }
    return hash.final();
}

/// An encode of every text of a workload by a candidate.
pub fn Encode(comptime claims: json.Claims, comptime calls: Calls) type {
    return struct {
        const Self = @This();
        workload: *const Workload,
        output: []u8,
        features: codec.Features,

        pub fn run_once(context: *const anyopaque) void {
            const self: *const Self = @ptrCast(@alignCast(context));
            std.mem.doNotOptimizeAway(encode(claims, calls, self.workload, self.output, self.features));
        }
    };
}

/// Encodes every text of `workload` into `output`, a text a batch or a token a call, and returns
/// how many octets it wrote.
pub fn encode(comptime claims: json.Claims, comptime calls: Calls, workload: *const Workload, output: []u8, features: codec.Features) usize {
    var written: usize = 0;
    for (workload.items) |items| {
        var encoder: json.Encoder = undefined;
        encoder.init(workload.framing, features);
        switch (calls) {
            .batch => {
                const batch = @call(.always_inline, json.Encoder.encode_batch_with, .{ &encoder, claims, items, output[written..] }) catch unreachable;
                std.debug.assert(batch.status == .done and batch.items == items.len);
                written += batch.written;
            },
            .one_token => for (items) |item| {
                const progress = @call(.always_inline, json.Encoder.encode_with, .{ &encoder, claims, item.token, item.octets, output[written..] }) catch unreachable;
                written += progress.written;
            },
        }
        std.debug.assert(encoder.is_done());
    }
    return written;
}
