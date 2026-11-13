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

/// How a candidate calls its codec: many tokens a call, as every claim's candidate does; one, the
/// candidate decision 33 is measured against; one through `TextWriter`'s methods and
/// `TextReader.next`, as a caller that writes or reads a text a value at a time does (decision 69);
/// or, for a decode alone, the reader's queued tokens a slice a call through
/// `TextReader.next_items` (decision 79).
pub const Calls = enum { batch, one_token, methods, items };

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
    if (calls == .methods) {
        for (workload.texts) |text| decode_methods(workload.framing, text, room, &tally);
        return tally;
    }
    if (calls == .items) {
        for (workload.texts) |text| decode_items(workload.framing, text, room, &tally);
        return tally;
    }
    // One decoder for every text, as a caller keeps one: declared for each, a safe build filled
    // all of its octets for each text before `init` wrote them.
    var decoder: json.Decoder = undefined;
    for (workload.texts) |text| {
        decoder.init(workload.framing, room.features);
        if (calls == .batch) decode_batches(claims, &decoder, text, room, &tally) else decode_tokens(claims, &decoder, text, room.output, &tally);
    }
    return tally;
}

/// One text, or one text of a sequence with its separators, through `TextReader.next`.
inline fn decode_methods(framing: json.Framing, text: []const u8, room: DecodeRoom, tally: *abi.Tally) void {
    var reader = json.TextReader.init(text, room.output, framing, room.features);
    while (reader.next_text()) {
        for (0..text.len + 1) |_| {
            const item = (reader.next() catch unreachable) orelse break;
            switch (item) {
                .begin_object => baselines.count_token(tally, .begin_object, 0),
                .end_object => baselines.count_token(tally, .end_object, 0),
                .begin_array => baselines.count_token(tally, .begin_array, 0),
                .end_array => baselines.count_token(tally, .end_array, 0),
                .name => |octets| baselines.count_token(tally, .name, octets.len),
                .string => |octets| baselines.count_token(tally, .string, octets.len),
                .number => |octets| baselines.count_token(tally, .number, octets.len),
                .true => baselines.count_token(tally, .true, 0),
                .false => baselines.count_token(tally, .false, 0),
                .null => baselines.count_token(tally, .null, 0),
            }
        } else unreachable;
    }
    std.debug.assert(reader.consumed_len() == text.len);
}

/// One text, or one text of a sequence with its separators, through `TextReader.next_items`: a
/// slice of tokens a call, and a loop over each slice.
inline fn decode_items(framing: json.Framing, text: []const u8, room: DecodeRoom, tally: *abi.Tally) void {
    var reader = json.TextReader.init(text, room.output, framing, room.features);
    // `next_text` inline by name: with a second caller left to the compiler, `decode_methods`
    // paid a call a text that main's program does not.
    while (@call(.always_inline, json.TextReader.next_text, .{&reader})) {
        // A call hands out a token at least, and a text holds no more tokens than octets.
        for (0..text.len + 1) |_| {
            const items = (reader.next_items() catch unreachable) orelse break;
            for (items) |*item| count_item(tally, item);
        } else unreachable;
    }
    std.debug.assert(reader.consumed_len() == text.len);
}

/// Counts one token a reader handed out.
inline fn count_item(tally: *abi.Tally, item: *const json.TextReader.Item) void {
    switch (item.*) {
        .begin_object => baselines.count_token(tally, .begin_object, 0),
        .end_object => baselines.count_token(tally, .end_object, 0),
        .begin_array => baselines.count_token(tally, .begin_array, 0),
        .end_array => baselines.count_token(tally, .end_array, 0),
        .name => |octets| baselines.count_token(tally, .name, octets.len),
        .string => |octets| baselines.count_token(tally, .string, octets.len),
        .number => |octets| baselines.count_token(tally, .number, octets.len),
        .true => baselines.count_token(tally, .true, 0),
        .false => baselines.count_token(tally, .false, 0),
        .null => baselines.count_token(tally, .null, 0),
    }
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
    // A decode alone takes a slice of tokens a call.
    comptime std.debug.assert(calls != .items);
    if (calls == .methods) {
        var written: usize = 0;
        for (workload.items) |items| written += encode_methods(workload.framing, items, output[written..], features);
        return written;
    }
    return encode_calls(claims, calls == .batch, workload, output, features);
}

/// `encode` through the encoder's own calls: a text a batch, or a token a call.
inline fn encode_calls(comptime claims: json.Claims, comptime batches: bool, workload: *const Workload, output: []u8, features: codec.Features) usize {
    var written: usize = 0;
    // One encoder for every text, as `decode` keeps one decoder.
    var encoder: json.Encoder = undefined;
    for (workload.items) |items| {
        encoder.init(workload.framing, features);
        if (batches) {
            const batch = @call(.always_inline, json.Encoder.encode_batch_with, .{ &encoder, claims, items, output[written..] }) catch unreachable;
            std.debug.assert(batch.status == .done and batch.items == items.len);
            written += batch.written;
        } else for (items) |item| {
            const progress = @call(.always_inline, json.Encoder.encode_with, .{ &encoder, claims, item.token, item.octets, output[written..] }) catch unreachable;
            written += progress.written;
        }
        std.debug.assert(encoder.is_done());
    }
    return written;
}

/// One text through `TextWriter`'s methods, as a caller that knows its members writes it: a
/// member's name with its value in one `member_*` call (decision 78), and every other token
/// through the method its token names.
inline fn encode_methods(framing: json.Framing, items: []const workloads.Item, output: []u8, features: codec.Features) usize {
    var text = json.TextWriter.init(output, framing, features);
    var index: usize = 0;
    // Each pass writes an item at least.
    for (0..items.len) |_| {
        if (index == items.len) break;
        const item = items[index];
        index += 1;
        if (item.token == .name and index < items.len) {
            write_member(&text, item.octets, items[index]);
            index += 1;
        } else {
            write_token(&text, item);
        }
    }
    return text.written().len;
}

/// A member's name and its value, through the value's `member_*` method.
inline fn write_member(text: *json.TextWriter, name_octets: []const u8, item: workloads.Item) void {
    (switch (item.token) {
        .begin_object => text.member_begin_object(name_octets),
        .begin_array => text.member_begin_array(name_octets),
        .string => text.member_string(name_octets, item.octets),
        .hex => text.member_hex(name_octets, item.octets),
        .number => text.member_number(name_octets, item.octets),
        .unsigned => |value| text.member_unsigned(name_octets, value),
        .signed => |value| text.member_signed(name_octets, value),
        .decimal => |value| text.member_decimal(name_octets, value),
        .boolean => |value| text.member_boolean(name_octets, value),
        .null => text.member_null(name_octets),
        // RFC 8259 §4: a value follows a member's name.
        .name, .end_object, .end_array => unreachable,
    }) catch unreachable;
}

/// One token, through the method its token names.
inline fn write_token(text: *json.TextWriter, item: workloads.Item) void {
    (switch (item.token) {
        .begin_object => text.begin_object(),
        .end_object => text.end_object(),
        .begin_array => text.begin_array(),
        .end_array => text.end_array(),
        .name => text.name(item.octets),
        .string => text.string(item.octets),
        .hex => text.hex(item.octets),
        .number => text.number(item.octets),
        .unsigned => |value| text.unsigned(value),
        .signed => |value| text.signed(value),
        .decimal => |value| text.decimal(value),
        .boolean => |value| text.boolean(value),
        .null => text.null_literal(),
    }) catch unreachable;
}
