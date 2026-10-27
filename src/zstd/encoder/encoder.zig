//! The Zstandard encoder (RFC 8878; design §8 step 13): levels 1 and 3 of decision 13, with the
//! windows and tables decision 12 gives them. It streams one frame through the call of decision
//! 11.
//!
//! The encoder keeps a window of input: the history its matches reach, then the octets not yet
//! encoded. It ends a block of Block_Maximum_Size, 128 KiB, once input past it arrives; a flush
//! ends a block at the input's end, and a finish ends the last. So where a block ends depends on
//! the input and its flush points alone, never on how the caller split them across calls
//! (invariant 5). A block goes into the encoder's own buffer, as its Block_Header states its size
//! (decision 12), and leaves it as the caller's output has room.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const checksum = @import("checksum");
const constants = @import("../constants.zig");
const encoder_block = @import("encoder_block.zig");
const encoder_literals = @import("encoder_literals.zig");
const encoder_match = @import("encoder_match.zig");
const encoder_repeat = @import("encoder_repeat.zig");
const encoder_sequences = @import("encoder_sequences.zig");

pub const EncoderOptions = struct {
    /// 1 or 3 (decision 13).
    level: u4 = 3,
    /// Log2 of the window; null takes the level's, 19 at level 1 and 21 at level 3 (decision 12).
    /// A caller whose messages are small may take less, down to a block's 17.
    window_log: ?u5 = null,
    /// Whether the frame ends with its Content_Checksum (RFC 8878 §3.1.1).
    checksum: bool = false,
};

/// The match finder of each level (decision 12): one table at level 1, two at level 3.
fn level_of(comptime options: EncoderOptions) encoder_match.Level {
    var chosen: encoder_match.Level = for (constants.encoder_levels) |level| {
        if (level.number == options.level) break .{ .window_log = level.window_log, .short_hash_log = level.short_hash_log, .short_hash_len = constants.short_hash_len, .long_hash_log = level.long_hash_log };
    } else @compileError("the Zstandard encoder has levels 1 and 3 (decision 13)");
    if (options.window_log) |window_log| chosen.window_log = window_log;
    // A window of a block at least, and one an HTTP decoder takes: at most 8,000,000 octets
    // (RFC 9659 §3, decision 12).
    assert(chosen.window_log >= constants.encoder_window_log_min and chosen.window_log <= constants.encoder_window_log_max);
    return chosen;
}

pub fn Encoder(comptime options: EncoderOptions) type {
    const level = comptime level_of(options);
    return struct {
        const Self = @This();
        pub const window_log = level.window_log;
        pub const checksum_enabled = options.checksum;
        /// The history a match reaches, and a block not yet encoded.
        const window_capacity = (@as(usize, 1) << window_log) + constants.block_len_max;

        window: [window_capacity]u8,
        matcher: encoder_match.Matcher(level),
        sequences: encoder_sequences.Sequences,
        codes: encoder_sequences.Codes,
        literals: [constants.block_len_max]u8,
        tables: encoder_sequences.State,
        literals_scratch: encoder_literals.Scratch,
        /// The frame's header, a block and the checksum, as they wait for the caller's room.
        out: [constants.magic_len + constants.frame_header_len_max + constants.block_header_len + constants.block_len_max + constants.checksum_len]u8,
        out_start: usize,
        out_end: usize,
        /// The window's octets up to `encoded_end` are in blocks; those up to `filled_end` are
        /// input.
        encoded_end: usize,
        filled_end: usize,
        repeats: encoder_repeat.Repeats,
        header_written: bool,
        /// Whether a call passed `finish`, whether the last block is in `out`, and whether a call
        /// returned `done`.
        finishing: bool,
        last_written: bool,
        done: bool,
        digest: if (options.checksum) checksum.Xxh64 else void,

        /// Starts a frame, with the caller's CPU features (decision 21). Writes no octet of the
        /// window (decision 11).
        pub fn init(self: *Self, features: codec.Features) void {
            self.matcher.init();
            self.tables.init();
            self.out_start = 0;
            self.out_end = 0;
            self.encoded_end = 0;
            self.filled_end = 0;
            self.repeats = constants.repeated_offsets_initial;
            self.header_written = false;
            self.finishing = false;
            self.last_written = false;
            self.done = false;
            if (options.checksum) self.digest = checksum.Xxh64.init(checksum.Xxh64Path.fastest(checksum.Features.from(features)), 0);
        }

        /// Encodes as much of `input` into `output` as both allow (decision 11).
        pub fn encode(self: *Self, input: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
            return encode_call(self, input, output, flush);
        }

        /// Encodes all of `input` as one frame in one call (decision 11).
        pub fn encode_all(self: *Self, input: []const u8, output: []u8) error{NoSpaceLeft}!usize {
            const progress = self.encode(input, output, .finish);
            return switch (progress.status) {
                .done => progress.written,
                .needs_room => error.NoSpaceLeft,
                // `finish` takes all the input it is given.
                .needs_input => unreachable,
            };
        }

        /// The most octets `encode_all` writes for `input_len` octets: the magic number, the
        /// largest Frame_Header, every block raw with its Block_Header, and the checksum.
        pub fn encoded_len_max(input_len: usize) usize {
            const blocks = @max(1, std.math.divCeil(usize, input_len, constants.block_len_max) catch unreachable);
            return constants.magic_len + constants.frame_header_len_max + blocks * constants.block_header_len + input_len + constants.checksum_len;
        }
    };
}

fn encode_call(self: anytype, input: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
    codec.check_entry(input, output);
    // A call after `done` without `init`, or a call without `finish` after one with it, is a
    // programmer error (decision 11).
    assert(!self.done);
    assert(!self.finishing or flush == .finish);
    if (flush == .finish) self.finishing = true;
    var writer = codec.Writer.init(output);
    var consumed: usize = 0;
    const status = run(self, input, &writer, &consumed, flush);
    const progress: codec.Progress = .{ .consumed = consumed, .written = writer.position, .status = status };
    codec.check_progress(input.len, output.len, progress);
    return progress;
}

fn run(self: anytype, input: []const u8, writer: *codec.Writer, consumed: *usize, flush: codec.Flush) codec.Status {
    // Each round writes waiting octets, or takes input and ends a block: a block of input
    // takes two rounds, and the end of the input two more.
    const rounds_max = constants.encoder_rounds_per_block * (input.len / constants.block_len_max) + constants.encoder_rounds_extra;
    for (0..rounds_max) |_| {
        if (self.out_start < self.out_end) {
            self.out_start += writer.write_partial(self.out[self.out_start..self.out_end]);
            if (self.out_start < self.out_end) return .needs_room;
        }
        if (self.last_written) {
            self.done = true;
            return .done;
        }
        consumed.* += take(self, input[consumed.*..]);
        const pending = self.filled_end - self.encoded_end;
        if (consumed.* < input.len) {
            // Input past a full block: the block is not the last.
            assert(pending == constants.block_len_max);
            encoder_block.write(self, false);
            continue;
        }
        switch (flush) {
            .none => return .needs_input,
            .flush => {
                if (pending == 0) return .needs_input;
                encoder_block.write(self, false);
            },
            .finish => {
                encoder_block.write(self, true);
                self.last_written = true;
            },
        }
    }
    unreachable;
}

/// Copies as much of `input` into the window as the block not yet encoded has room for,
/// sliding the window first when it is full. Returns the octets taken.
fn take(self: anytype, input: []const u8) usize {
    if (self.encoded_end + constants.block_len_max > self.window.len) slide(self);
    const room = self.encoded_end + constants.block_len_max - self.filled_end;
    const len = @min(room, input.len);
    @memcpy(self.window[self.filled_end..][0..len], input[0..len]);
    self.filled_end += len;
    return len;
}

/// Moves the window's last `window_len` octets of history to its start.
fn slide(self: anytype) void {
    const window_len = self.window.len - constants.block_len_max;
    assert(self.encoded_end > window_len);
    const shift = self.encoded_end - window_len;
    const kept = self.filled_end - shift;
    std.mem.copyForwards(u8, self.window[0..kept], self.window[shift..self.filled_end]);
    self.encoded_end -= shift;
    self.filled_end -= shift;
    self.matcher.slide(@intCast(shift));
}

test {
    _ = @import("encoder_test.zig");
}
