//! The brotli encoder (RFC 7932; design §8 step 14, decision 62): level 1, against Google's
//! quality 1, with the window decision 12 gives it. It streams one stream through the call of
//! decision 11.
//!
//! The encoder keeps a window of input: the history its matches reach, then the octets not yet
//! encoded. It ends a meta-block of `constants.encoder_meta_block_len_max` octets once input past
//! it arrives; a flush ends a meta-block at the input's end and brings the stream to an octet
//! boundary, and a finish ends the last. So where a meta-block ends depends on the input and its
//! flush points alone, never on how the caller split them across calls (invariant 5). A meta-block
//! goes into the encoder's own buffer and leaves it as the caller's output has room.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const encoder_commands = @import("encoder_commands.zig");
const encoder_meta_block = @import("encoder_meta_block.zig");
const encoder_stream = @import("encoder_stream.zig");
const encoder_buckets = @import("encoder_level5/encoder_buckets.zig");

pub const EncoderOptions = struct {
    /// 1 or 5 (decision 62).
    level: u4 = 1,
    /// WBITS; null takes the level's, 18 at level 1 and 22 at level 5 (decision 62). A caller whose
    /// messages are small may take less, down to a meta-block's 16; level 1 takes 18 at most, and
    /// level 5 22.
    window_bits: ?u5 = null,
    /// Decision 16, ruled on 2026-11-05: the parse, the commands' records and the meta-block's
    /// writer run without Zig's checks. Off, the checks return; the tests and the benchmark take
    /// both settings, and the checked one is the reference.
    unchecked_loops: bool = true,
    /// The owner's ruling of 2026-11-06: level 1 parses in one loop of its own
    /// (encoder_parse.zig). Off, it parses through codec's match finder, the reference, which
    /// writes the same octets; the tests take both.
    lean_parse: bool = true,
};

/// The match finder of each level (decision 62): at level 1 a short table and a long one of 2^14
/// entries each, whose reach ends where the window of RFC 7932 §9.1 does.
fn level_of(comptime options: EncoderOptions) codec.match_finder.Level {
    assert(options.level == 1);
    const window_bits = options.window_bits orelse constants.encoder_level1_window_bits;
    // Level 1's commands hold a distance's extra bits in 16 bits, which WBITS 18 bounds.
    assert(window_bits >= constants.encoder_window_bits_min and window_bits <= constants.encoder_level1_window_bits);
    return .{
        .window_log = window_bits,
        .short_hash_log = constants.encoder_level1_hash_log,
        .short_hash_len = constants.encoder_level1_hash_len,
        .long_hash_log = constants.encoder_level1_long_hash_log,
        .reach_max = (@as(u32, 1) << window_bits) - constants.window_len_gap,
        .runtime_safety = !options.unchecked_loops,
    };
}

/// WBITS of level 5, whose commands hold a distance's extra bits in 32 bits.
fn level5_window_bits(comptime options: EncoderOptions) u5 {
    const window_bits = options.window_bits orelse constants.encoder_level5.window_bits;
    assert(window_bits >= constants.encoder_window_bits_min and window_bits <= constants.encoder_level5.window_bits);
    return window_bits;
}

pub fn Encoder(comptime options: EncoderOptions) type {
    if (options.level != 1 and options.level != constants.encoder_level5.number) @compileError("the brotli encoder has levels 1 and 5 (decision 62)");
    const five = options.level == constants.encoder_level5.number;
    return struct {
        const Self = @This();
        /// Level 5: buckets, a lazy parse, and commands that reach WBITS 22 (decision 62).
        pub const level_five = five;
        pub const window_bits: u5 = if (five) level5_window_bits(options) else level_of(options).window_log;
        /// The farthest a match reaches back: the window less RFC 7932 §9.1's gap.
        pub const reach_len = (@as(usize, 1) << window_bits) - constants.window_len_gap;
        /// Whether the parse and the meta-block's writer keep Zig's checks (decision 16).
        pub const runtime_safety = !options.unchecked_loops;
        /// The match finder's level, and whether the parse runs in level 1's own loop.
        pub const finder_level = if (five) {} else level_of(options);
        pub const lean_parse = options.lean_parse;
        /// The history a match reaches, and a meta-block not yet encoded.
        const window_capacity = (@as(usize, 1) << window_bits) + constants.encoder_meta_block_len_max;

        window: [window_capacity]u8,
        matcher: if (five) encoder_buckets.Buckets else codec.match_finder.Matcher(level_of(options)),
        commands: if (five) encoder_commands.WideCommands else encoder_commands.Commands,
        codes: encoder_meta_block.Codes,
        /// The stream header and a meta-block, as they wait for the caller's room.
        out: [constants.encoder_out_len]u8,
        out_start: usize,
        out_end: usize,
        /// The bits after the last whole octet written, which the next meta-block continues.
        bits: codec.Bits,
        /// The window's octets up to `encoded_end` are in meta-blocks; those up to `filled_end`
        /// are input.
        encoded_end: usize,
        filled_end: usize,
        header_written: bool,
        /// Whether a call passed `finish`, whether the last meta-block is in `out`, and whether a
        /// call returned `done`.
        finishing: bool,
        last_written: bool,
        done: bool,

        /// Starts a stream and clears the match finder's tables. Writes no octet of the window
        /// (decision 11).
        pub fn init(self: *Self) void {
            self.matcher.init();
            self.begin_stream();
        }

        /// Starts the next stream of an encoder `init` started. It clears no table, so it costs a
        /// constant where `init` costs the tables (decision 60).
        pub fn start(self: *Self) void {
            self.matcher.start();
            self.begin_stream();
        }

        fn begin_stream(self: *Self) void {
            self.commands.init();
            self.out_start = 0;
            self.out_end = 0;
            self.bits = .{};
            self.encoded_end = 0;
            self.filled_end = 0;
            self.header_written = false;
            self.finishing = false;
            self.last_written = false;
            self.done = false;
        }

        /// Encodes as much of `input` into `output` as both allow (decision 11).
        pub fn encode(self: *Self, input: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
            return encode_call(self, input, output, flush);
        }

        /// Encodes all of `input` as one stream in one call (decision 11).
        pub fn encode_all(self: *Self, input: []const u8, output: []u8) error{NoSpaceLeft}!usize {
            const progress = self.encode(input, output, .finish);
            return switch (progress.status) {
                .done => progress.written,
                .needs_room => error.NoSpaceLeft,
                // `finish` takes all the input it is given.
                .needs_input => unreachable,
            };
        }

        /// The most octets `encode_all` writes for `input_len` octets: the stream header, every
        /// meta-block uncompressed with its header, and the empty last meta-block.
        pub fn encoded_len_max(input_len: usize) usize {
            const blocks = @max(1, std.math.divCeil(usize, input_len, constants.encoder_meta_block_len_max) catch unreachable);
            return constants.encoder_stream_header_len_max + blocks * constants.encoder_uncompressed_overhead + input_len + constants.encoder_last_len;
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
    // Each round writes waiting octets, or takes input and ends a meta-block: a meta-block of
    // input takes two rounds, and the end of the input two more.
    const rounds_max = constants.encoder_rounds_per_block * (input.len / constants.encoder_meta_block_len_max) + constants.encoder_rounds_extra;
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
            // Input past a full meta-block: the meta-block is not the last.
            assert(pending == constants.encoder_meta_block_len_max);
            encoder_stream.write(self, .more);
            continue;
        }
        if (!end_input(self, flush, pending)) return .needs_input;
    }
    unreachable;
}

/// Ends the meta-block at the input's end as `flush` asks. Returns whether it wrote one.
fn end_input(self: anytype, flush: codec.Flush, pending: usize) bool {
    switch (flush) {
        .none => return false,
        .flush => {
            if (pending == 0) {
                // Bits wait only after a meta-block that more input followed: a flush or a
                // stream's start leaves none.
                assert(self.bits.count == 0);
                return false;
            }
            encoder_stream.write(self, .flush);
        },
        .finish => {
            encoder_stream.write(self, .last);
            self.last_written = true;
        },
    }
    return true;
}

/// Copies as much of `input` into the window as the meta-block not yet encoded has room for,
/// sliding the window first when it is full. Returns the octets taken.
fn take(self: anytype, input: []const u8) usize {
    if (self.encoded_end + constants.encoder_meta_block_len_max > self.window.len) slide(self);
    const room = self.encoded_end + constants.encoder_meta_block_len_max - self.filled_end;
    const len = @min(room, input.len);
    @memcpy(self.window[self.filled_end..][0..len], input[0..len]);
    self.filled_end += len;
    return len;
}

/// Moves the window's last `window_len` octets of history to its start.
fn slide(self: anytype) void {
    const window_len = self.window.len - constants.encoder_meta_block_len_max;
    assert(self.encoded_end > window_len);
    const shift = self.encoded_end - window_len;
    const kept = self.filled_end - shift;
    @memmove(self.window[0..kept], self.window[shift..self.filled_end]);
    self.encoded_end -= shift;
    self.filled_end -= shift;
    self.matcher.slide(@intCast(shift));
}

test {
    _ = @import("encoder_test.zig");
}

test {
    _ = @import("encoder_level5/encoder_level5_test.zig");
    _ = @import("encoder_level5/encoder_buckets.zig");
}
