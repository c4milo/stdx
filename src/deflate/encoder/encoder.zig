//! The DEFLATE encoder (RFC 1951), one type per level of decision 13, chosen at comptime (decision
//! 14, E2): `Encoder(.{ .level = 1 })`, 6 or 9.
//!
//! A call copies input into the window, decides its positions into the block, and writes each
//! finished block into the caller's output, resuming wherever the output filled (decision 11). A
//! block ends when it holds `block_symbols_max` symbols, at a flush and at the end. Level 1 ends
//! it at every slide of the window too, so its input is always in the window. A lazy level checks
//! the block's newest symbols (decision 44): the block ends before them when they code in fewer
//! bits in a block of their own, and at a slide only when it does not code for less than its
//! stored form. A block's plan takes the cheapest of its stored, fixed and dynamic forms (E3); a
//! block that crossed a slide no longer has its stored form, its first octets gone from the
//! window. A flush ends the block and adds an empty stored block, so a decoder can produce every
//! octet taken so far; `finish` makes the last block final and pads the stream to an octet.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const block_module = @import("encoder_block.zig");
const emit_module = @import("encoder_emit.zig");
const split_module = @import("encoder_split.zig");
const Matcher = @import("encoder_match/encoder_match.zig").Matcher;
const cost = @import("encoder_match/encoder_match_cost.zig");

pub const EncoderOptions = struct {
    /// 1, 6 or 9 (decision 13).
    level: u4 = 6,
};

/// Where a stream stands after its blocks.
const Stage = enum(u8) { encoding, final_padding, done };

pub fn Encoder(comptime options: EncoderOptions) type {
    const level = constants.level(options.level);
    return struct {
        const Self = @This();

        matcher: Matcher(level),
        /// The prices of decision 42, at a lazy level, outside the match finder, so the finder's
        /// fields stay where its loop reads them.
        prices: if (level.chains) cost.Prices else void,
        block: block_module.Block,
        plan: block_module.Plan,
        emit: emit_module.Emit,
        /// The bits of a partly written octet (decision 11).
        bits: codec.Bits,
        stage: Stage,
        /// Whether the block being written is the last, and whether a flush's empty stored block
        /// waits to be written after it.
        emitting_final: bool,
        marker_owed: bool,
        /// The input taken since `init`, and how much of it a flush has ended.
        taken: u64,
        flushed: u64,
        /// Where the block's checks stand, at a level that checks its blocks (decision 44).
        split: if (level.block_checks) split_module.Split else void,
        /// Whether a call has passed `finish`.
        finishing: bool,

        comptime {
            assert(@sizeOf(Self) <= level.state_budget_len);
        }

        /// Starts a stream. `features` is the caller's, as for every codec (decision 21).
        pub fn init(self: *Self, features: codec.Features) void {
            _ = features;
            self.matcher.init();
            if (level.chains) self.prices.start();
            start_block(options, self, 0);
            self.emit = .{};
            self.bits = .{};
            self.stage = .encoding;
            self.emitting_final = false;
            self.marker_owed = false;
            self.taken = 0;
            self.flushed = 0;
            self.finishing = false;
        }

        /// Encodes as much of `input` into `output` as both allow (decision 11).
        pub fn encode(self: *Self, input: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
            return encode_call(options, self, input, output, flush);
        }

        /// Encodes all of `input` as one stream in one call (decision 11). Returns the octets
        /// written, or `error.NoSpaceLeft` when `output` holds less than the stream.
        pub fn encode_all(self: *Self, input: []const u8, output: []u8) error{NoSpaceLeft}!usize {
            const progress = self.encode(input, output, .finish);
            return switch (progress.status) {
                .done => progress.written,
                .needs_room => error.NoSpaceLeft,
                // `finish` takes all the input it is given.
                .needs_input => unreachable,
            };
        }

        /// The most octets `encode_all` writes for `input_len` octets: every block costs at most
        /// its input stored, with a stored block's header (E3), and the stream's last octet.
        pub fn encoded_len_max(input_len: usize) usize {
            return encoded_len_bound(level.block_checks, input_len);
        }
    };
}

fn encode_call(comptime options: EncoderOptions, self: *Encoder(options), input: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
    codec.check_entry(input, output);
    // A call after `done` without `init`, or a call without `finish` after one with it, is a
    // programmer error (decision 11).
    assert(self.stage != .done);
    assert(!self.finishing or flush == .finish);
    if (flush == .finish) self.finishing = true;
    var writer = codec.BitWriter.init(output, self.bits);
    var consumed: usize = 0;
    const status = run(options, self, input, flush, &writer, &consumed);
    self.bits = writer.bits;
    const progress: codec.Progress = .{ .consumed = consumed, .written = writer.writer.position, .status = status };
    codec.check_progress(input.len, output.len, progress);
    return progress;
}

fn run(comptime options: EncoderOptions, self: *Encoder(options), input: []const u8, flush: codec.Flush, writer: *codec.BitWriter, consumed: *usize) align(constants.hot_function_alignment) codec.Status {
    const steps_max = constants.encoder_steps_per_octet * (input.len + writer.writer.octets.len) + constants.encoder_steps_floor;
    for (0..steps_max) |_| {
        if (self.emit.active()) {
            if (!emit_module.write(&self.emit, &self.plan, &self.block, self.matcher.window[0..constants.encoder_window_len], writer)) return .needs_room;
            written(options, self, writer);
            continue;
        }
        switch (self.stage) {
            .encoding => {},
            .final_padding => return pad(options, self, writer),
            .done => unreachable,
        }
        if (self.marker_owed) {
            self.marker_owed = false;
            block_module.plan_empty_stored(@intCast(writer.bits.count % @bitSizeOf(u8)), &self.plan);
            self.emit.start();
            continue;
        }
        if (step(options, self, input, flush, writer, consumed)) |status| return status;
    }
    // Each step writes, takes input, decides positions, or ends a block, and a call's blocks are
    // bounded by its input and the window it holds.
    unreachable;
}

/// One step of encoding: take input, slide, decide positions, or end a block. Returns the status
/// that ends the call, or null to go on.
fn step(comptime options: EncoderOptions, self: *Encoder(options), input: []const u8, flush: codec.Flush, writer: *codec.BitWriter, consumed: *usize) ?codec.Status {
    const taken = self.matcher.fill(input[consumed.*..]);
    consumed.* += taken;
    self.taken += taken;
    // The window slides only to take more input. Were a call with no input left to slide, a flush
    // or `finish` given in an empty call after the window filled would end a block where one call
    // carrying the same flush does not (invariant 5).
    if (self.matcher.must_slide() and consumed.* < input.len) return slide(options, self, writer);
    const ending = flush != .none and consumed.* == input.len;
    advance(options, self, ending);
    if (self.block.full()) return end_block(options, self, false, writer);
    if (comptime checks(options)) {
        if (self.block.at_check()) return check(options, self, writer);
    }
    if (consumed.* < input.len) {
        // The window filled: the next step slides it and takes more.
        assert(self.matcher.must_slide());
        return null;
    }
    if (!ending) return .needs_input;
    if (!self.matcher.settle(&self.block)) return end_block(options, self, false, writer);
    if (flush == .finish) return end_last(options, self, writer);
    return flush_point(options, self, writer);
}

/// Whether the level checks its blocks (decision 44).
fn checks(comptime options: EncoderOptions) bool {
    return constants.level(options.level).block_checks;
}

/// Slides the window to take more input. At a level that checks its blocks, a block goes on across
/// the slide when it prices below its stored form, its symbols so far coded from here on
/// (decision 44); else it ends here.
fn slide(comptime options: EncoderOptions, self: *Encoder(options), writer: *const codec.BitWriter) ?codec.Status {
    const kept = self.block.symbol_count > 0;
    if (kept) {
        if (comptime !checks(options)) return end_block(options, self, false, writer);
        // Newest symbols that code in fewer bits apart meet the slide in a block of their own.
        if (cut_newest(options, self)) return end_block(options, self, false, writer);
        if (!crosses(options, self, writer)) return end_block(options, self, false, writer);
        split_module.commit(&self.block, &self.split);
    }
    self.matcher.slide();
    // The block's octets after the slide start where the window's next undecided octet does.
    if (kept) self.block.input_start = self.matcher.pending_start() else start_block(options, self, self.matcher.pending_start());
    return null;
}

/// Whether the block prices below its stored form: by its fixed code, or failing that by its plan.
fn crosses(comptime options: EncoderOptions, self: *Encoder(options), writer: *const codec.BitWriter) bool {
    const bit_position: u3 = @intCast(writer.bits.count % @bitSizeOf(u8));
    if (block_module.fixed_beats_stored(&self.block, bit_position)) return true;
    block_module.plan(&self.block, false, bit_position, &self.plan);
    return self.plan.kind != .stored;
}

/// The check of the block's newest symbols: the block ends before them when they code in fewer
/// bits in a block of their own, and else they join it until the next check (decision 44).
fn check(comptime options: EncoderOptions, self: *Encoder(options), writer: *const codec.BitWriter) ?codec.Status {
    if (!split_module.splits(&self.block, &self.split)) {
        split_module.begin_chunk(&self.block, &self.split);
        return null;
    }
    split_module.cut_at_chunk(&self.block, &self.split);
    return end_block(options, self, false, writer);
}

/// Ends the block before its newest symbols, since its last check, when they code in fewer bits in
/// a block of their own, and holds them back to start the next block. Returns whether it did
/// (decision 44).
fn cut_newest(comptime options: EncoderOptions, self: *Encoder(options)) bool {
    if (comptime !checks(options)) return false;
    if (self.block.symbol_count == self.split.chunk_start or !split_module.splits(&self.block, &self.split)) return false;
    split_module.cut_at_chunk(&self.block, &self.split);
    return true;
}

/// Ends the last block, before its newest symbols when they code in fewer bits apart: the next
/// step then ends those as the last block.
fn end_last(comptime options: EncoderOptions, self: *Encoder(options), writer: *const codec.BitWriter) ?codec.Status {
    if (cut_newest(options, self)) return end_block(options, self, false, writer);
    return end_block(options, self, true, writer);
}

/// After a block is written: the next starts with the symbols it held back, or where its input
/// ends, or the stream pads.
fn written(comptime options: EncoderOptions, self: *Encoder(options), writer: *const codec.BitWriter) void {
    if (comptime checks(options)) {
        if (self.split.carried_count > 0) {
            // A block that held symbols back was not the last.
            assert(!self.emitting_final);
            return carry(options, self, writer);
        }
    }
    start_block(options, self, self.matcher.pending_start());
    if (self.emitting_final) self.stage = .final_padding;
}

/// Starts an empty block at `input_start`, with no check behind it.
fn start_block(comptime options: EncoderOptions, self: *Encoder(options), input_start: usize) void {
    self.block.reset(input_start);
    if (comptime checks(options)) split_module.start(&self.block, &self.split);
}

/// Starts the next block with the symbols a cut held back. When a flush's empty stored block is
/// owed, they end their block at once, as the flush asks for every symbol so far before it.
fn carry(comptime options: EncoderOptions, self: *Encoder(options), writer: *const codec.BitWriter) void {
    split_module.carry(&self.block, &self.split);
    if (self.marker_owed) _ = end_block(options, self, false, writer);
}

/// Decides positions into the block, priced in a block after one with cheap literals (decision
/// 42).
inline fn advance(comptime options: EncoderOptions, self: *Encoder(options), ending: bool) void {
    if (comptime constants.level(options.level).chains) {
        if (self.prices.cheap) return self.matcher.advance_priced(&self.block, ending, &self.prices.costs);
    }
    self.matcher.advance(&self.block, ending);
}

/// A flush ends the block and adds an empty stored block, once for each point in the input.
fn flush_point(comptime options: EncoderOptions, self: *Encoder(options), writer: *codec.BitWriter) ?codec.Status {
    if (self.taken == self.flushed and self.block.symbol_count == 0) return .needs_input;
    self.flushed = self.taken;
    self.marker_owed = true;
    if (self.block.symbol_count > 0) {
        _ = cut_newest(options, self);
        return end_block(options, self, false, writer);
    }
    return null;
}

/// Plans the block and starts writing it. Returns null, for the call to go on.
fn end_block(comptime options: EncoderOptions, self: *Encoder(options), final: bool, writer: *const codec.BitWriter) ?codec.Status {
    const bit_position: u3 = @intCast(writer.bits.count % @bitSizeOf(u8));
    block_module.plan(&self.block, final, bit_position, &self.plan);
    const cut = ends_at_slide(options, self, bit_position);
    // A block that crossed a slide is never stored: its first octets left the window.
    if (comptime checks(options)) assert(self.plan.kind != .stored or self.split.slid_count == 0);
    const last = final and !cut;
    // The next block's prices come from this one's codes; the last has no block after it.
    if (comptime constants.level(options.level).chains) {
        if (!last) self.prices.update(&self.plan, &self.block.literal_length_counts);
    }
    self.emitting_final = last;
    self.emit.start();
    return null;
}

/// When the planned block crossed a slide of the window and its plan is the stored form, ends it
/// at its last slide instead and plans that, and returns true: the octets before the slide left
/// the window, so those symbols go out alone, coded, as the slide found them cheaper so, and the
/// rest waits for the next block (decision 44).
fn ends_at_slide(comptime options: EncoderOptions, self: *Encoder(options), bit_position: u3) bool {
    if (comptime !checks(options)) return false;
    if (self.plan.kind != .stored or self.split.slid_count == 0) return false;
    if (self.split.carried_count > 0) split_module.uncut(&self.block, &self.split);
    split_module.cut_at_slide(&self.block, &self.split);
    block_module.plan(&self.block, false, bit_position, &self.plan);
    // A stored block's octets are all in the window.
    assert(self.plan.kind != .stored);
    return true;
}

/// Pads the last octet with zeros and writes it (RFC 1951 §3.2.3 ends the stream there).
fn pad(comptime options: EncoderOptions, self: *Encoder(options), writer: *codec.BitWriter) codec.Status {
    if (!writer.make_room(writer.bits_to_octet())) return .needs_room;
    writer.put(0, writer.bits_to_octet());
    if (!writer.drain()) return .needs_room;
    assert(writer.bits.count == 0);
    self.stage = .done;
    return .done;
}

/// The blocks the bound adds to those the input's length counts: the block before the first slide,
/// and the last.
const blocks_beyond = 2;

/// The blocks of fewer than `block_chunk_symbols` symbols a slide of the window accounts for, at
/// most (decision 44): one that ends at it; one that crossed it and ends where it crossed, cut
/// there by a check or by its stored form's price; and one that starts with the symbols such an
/// end held back and ends at its first check. A block that starts after any other end holds a
/// check's symbols or more before a check can end it.
const blocks_per_slide = 3;

/// `encoded_len_max`. At a level that checks its blocks, a block holds `block_chunk_symbols`
/// symbols or more, each taking an octet or more, but those a slide of the window accounts for,
/// every `window_len` octets after the first `encoder_window_len`, and the last. At a level that
/// does not, a block ends at `block_symbols_max` symbols, at a slide, or at the end. Each costs at
/// most its octets stored and a stored header (E3, decision 44).
fn encoded_len_bound(comptime checked: bool, input_len: usize) usize {
    const slides = input_len / constants.window_len;
    const blocks = if (checked) input_len / constants.block_chunk_symbols + blocks_per_slide * slides + blocks_beyond else input_len / constants.block_symbols_max + slides + blocks_beyond;
    const header_bits = constants.final_bits + constants.type_bits + @bitSizeOf(u8) - 1 + constants.stored_header_bits;
    return input_len + (blocks * header_bits + @bitSizeOf(u8) - 1) / @bitSizeOf(u8) + 1;
}

test {
    _ = @import("encoder_test.zig");
    _ = @import("encoder_split_price.zig");
    _ = @import("encoder_split_test.zig");
    _ = @import("encoder_fuzz_test.zig");
}
