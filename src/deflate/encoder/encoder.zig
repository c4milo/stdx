//! The DEFLATE encoder (RFC 1951), one type per level of decision 13, chosen at comptime (decision
//! 14, E2): `Encoder(.{ .level = 1 })`, 6 or 9.
//!
//! A call copies input into the window, decides its positions into the block, and writes each
//! finished block into the caller's output, resuming wherever the output filled (decision 11). A
//! block ends when it holds `block_symbols_max` symbols, before the window slides, at a flush and
//! at the end, so its input is always in the window and its stored form always a choice (E3). A
//! flush ends the block and adds an empty stored block, so a decoder can produce every octet taken
//! so far; `finish` makes the last block final and pads the stream to an octet.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const block_module = @import("encoder_block.zig");
const emit_module = @import("encoder_emit.zig");
const Matcher = @import("encoder_match.zig").Matcher;

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
        /// Whether a call has passed `finish`.
        finishing: bool,

        comptime {
            assert(@sizeOf(Self) <= level.state_budget_len);
        }

        /// Starts a stream. `features` is the caller's, as for every codec (decision 21).
        pub fn init(self: *Self, features: codec.Features) void {
            _ = features;
            self.matcher.init();
            self.block.reset(0);
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
            return encoded_len_bound(input_len);
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

fn run(comptime options: EncoderOptions, self: *Encoder(options), input: []const u8, flush: codec.Flush, writer: *codec.BitWriter, consumed: *usize) codec.Status {
    const steps_max = constants.encoder_steps_per_octet * (input.len + writer.writer.octets.len) + constants.encoder_steps_floor;
    for (0..steps_max) |_| {
        if (self.emit.active()) {
            if (!emit_module.write(&self.emit, &self.plan, &self.block, &self.matcher.window, writer)) return .needs_room;
            // The block is written: the next starts where its input ends, or the stream pads.
            self.block.reset(self.matcher.pending_start());
            if (self.emitting_final) self.stage = .final_padding;
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
    if (self.matcher.must_slide()) {
        if (self.block.symbol_count > 0) return end_block(options, self, false, writer);
        self.matcher.slide();
        self.block.reset(self.matcher.pending_start());
        return null;
    }
    const ending = flush != .none and consumed.* == input.len;
    self.matcher.advance(&self.block, ending);
    if (self.block.full()) return end_block(options, self, false, writer);
    if (consumed.* < input.len) {
        // The window filled: the next step slides it and takes more.
        assert(self.matcher.must_slide());
        return null;
    }
    if (!ending) return .needs_input;
    if (!self.matcher.settle(&self.block)) return end_block(options, self, false, writer);
    if (flush == .finish) return end_block(options, self, true, writer);
    return flush_point(options, self, writer);
}

/// A flush ends the block and adds an empty stored block, once for each point in the input.
fn flush_point(comptime options: EncoderOptions, self: *Encoder(options), writer: *codec.BitWriter) ?codec.Status {
    if (self.taken == self.flushed and self.block.symbol_count == 0) return .needs_input;
    self.flushed = self.taken;
    self.marker_owed = true;
    if (self.block.symbol_count > 0) return end_block(options, self, false, writer);
    return null;
}

/// Plans the block and starts writing it. Returns null, for the call to go on.
fn end_block(comptime options: EncoderOptions, self: *Encoder(options), final: bool, writer: *const codec.BitWriter) ?codec.Status {
    block_module.plan(&self.block, final, @intCast(writer.bits.count % @bitSizeOf(u8)), &self.plan);
    self.emitting_final = final;
    self.emit.start();
    return null;
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

/// `encoded_len_max`, the same at every level: a block ends at `block_symbols_max` symbols, each
/// taking an octet or more, or at a slide of the window, every `window_len` octets after the first
/// `encoder_window_len`, or at the end; each costs at most its octets stored and a stored header.
fn encoded_len_bound(input_len: usize) usize {
    const blocks = input_len / constants.block_symbols_max + input_len / constants.window_len + blocks_beyond;
    const header_bits = constants.final_bits + constants.type_bits + @bitSizeOf(u8) - 1 + constants.stored_header_bits;
    return input_len + (blocks * header_bits + @bitSizeOf(u8) - 1) / @bitSizeOf(u8) + 1;
}

test {
    _ = @import("encoder_test.zig");
}
