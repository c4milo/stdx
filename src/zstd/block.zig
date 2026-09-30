//! A compressed block's decoding (RFC 8878 §3.1.1.3, §3.1.1.4): reading its literals and
//! sequences sections from the whole block, then executing its sequences into the caller's
//! output as the output has room, resuming in the next call where the room ran out.
//!
//! Executing a sequence copies its literals, then its match from the history: the window, then
//! the call's own output, which the decoder moves into the window and the checksum when the call
//! ends (Z6). A match reaches only octets this frame wrote (invariant 10) and no further than
//! Window_Size (RFC 8878 §3.1.1.4).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const checksum = @import("checksum");
const constants = @import("constants.zig");
const literals = @import("literals.zig");
const sequences = @import("sequences.zig");
const work_module = @import("work.zig");
const Work = work_module.Work;
const fast_sequences = @import("fast_sequences/fast_sequences.zig");
const Paths = @import("claims.zig").Paths;

/// Every way a compressed block breaks RFC 8878 §3.1.1.3 and §3.1.1.4.
pub const Error = literals.Error || sequences.Error || error{
    LiteralsOverrun,
    BlockTooLong,
    OffsetTooFar,
};

/// A compressed block as far as its execution has gone.
pub const Run = struct {
    section: literals.Section,
    /// The literals copied so far.
    literals_used: u32,
    /// The sequence stream's place in the block, and its decoding.
    stream_offset: u32,
    stream_len: u32,
    stream: sequences.Stream,
    /// The sequence being executed: its literals and match octets still to copy, and its offset.
    literals_left: u32,
    match_left: u32,
    offset: u32,
    /// Octets the block has promised so far: its literals, and every match decoded.
    promised_len: u32,
};

/// What the block's octets go into: the caller's output, the frame's window, and the frame's count
/// of octets decoded. The history an offset reaches is the window, then the call's output from
/// `synced` on, which the window takes when the call ends (Z6) or, with `window_each`, at each
/// commit.
pub fn Sink(comptime Window: type) type {
    return struct {
        output: []u8,
        written: usize,
        window: *Window,
        /// The call's output before this index is in the window.
        synced: *usize,
        frame_len: *u64,
        window_each: bool,

        pub fn room(self: *const @This()) usize {
            return self.output.len - self.written;
        }

        /// Records the `len` octets just placed at `written`.
        pub fn commit(self: *@This(), len: usize) void {
            self.written += len;
            self.frame_len.* += len;
            if (self.window_each) self.sync();
        }

        /// Moves the call's output from `synced` to `written` into the window.
        pub fn sync(self: *@This()) void {
            assert(self.synced.* <= self.written);
            self.window.append(self.output[self.synced.*..self.written]);
            self.synced.* = self.written;
        }

        /// The octets written since the frame's first that the window and the call's output hold.
        pub fn reach(self: *const @This()) usize {
            return self.window.reach() + (self.written - self.synced.*);
        }

        /// Copies into `into` the octets from `distance` before `written`: from the window what
        /// lies before `synced`, and from the output the rest. `into` is no longer than `distance`,
        /// and the caller refused every distance past `reach()` (invariant 10).
        pub fn copy_back(self: *const @This(), distance: usize, into: []u8) void {
            assert(distance <= self.reach() and into.len <= distance);
            const own_len = self.written - self.synced.*;
            var copied: usize = 0;
            if (distance > own_len) {
                copied = @min(into.len, distance - own_len);
                self.window.copy_back(distance - own_len, into[0..copied]);
            }
            if (copied == into.len) return;
            // The rest starts at `synced` or after: the window gave what lies before it.
            const source = self.written + copied - distance;
            @memcpy(into[copied..], self.output[source..][0 .. into.len - copied]);
        }
    };
}

/// Where a block's literals may be read, and the tables its sections use.
pub const Context = struct {
    block: []const u8,
    literals_buffer: []u8,
    huffman: literals.Tables,
    tables: *sequences.Tables,
    repeats: *[constants.repeated_offsets_initial.len]u32,
    /// Block_Maximum_Size and Window_Size of the frame (RFC 8878 §3.1.1.2.4, §3.1.1.1.2).
    block_len_max: u32,
    window_len: u64,
    /// Invariant 17's count for the frame's decoder.
    work: *Work,
    /// Whether the CPU runs the x86-64 assembly of the fast paths (decision 23).
    assembly: bool,
};

/// Reads the block's literals section and sequences header, and starts its sequences (RFC 8878
/// §3.1.1.3).
pub fn prepare(comptime paths: Paths, run: *Run, context: Context) Error!void {
    run.section = try literals.read_with(paths, context.block, context.block_len_max, context.huffman);
    var reader = codec.Reader.init(context.block);
    _ = reader.take(run.section.section_len) catch unreachable;
    const sequences_octets = reader.take(reader.remaining_len()) catch unreachable;
    const header = try sequences.read_header(sequences_octets, context.tables);
    work_module.add(context.work, run.section.work);
    work_module.add(context.work, context.tables.work);
    context.tables.work = work_module.zero;
    run.literals_used = 0;
    run.literals_left = 0;
    run.match_left = 0;
    run.offset = 0;
    run.promised_len = run.section.len;
    run.stream_offset = run.section.section_len + header.header_len;
    run.stream_len = @intCast(sequences_octets.len - header.header_len);
    if (header.count == 0) {
        // RFC 8878 §3.1.1.3.2.1: with no sequences the section ends after its first octet.
        if (run.stream_len != 0) return error.SequencesStreamInvalid;
        run.stream = .{ .position = 0, .overflowed = false, .states = undefined, .left = 0 };
        return;
    }
    run.stream = try sequences.start(stream_octets(run, context.block), context.tables, header.count);
}

fn stream_octets(run: *const Run, block: []const u8) []const u8 {
    assert(run.stream_offset + run.stream_len <= block.len);
    return block[run.stream_offset..][0..run.stream_len];
}

/// Executes the block into `sink` until it ends, returning true, or the output fills first,
/// returning false (RFC 8878 §3.1.1.4). The fast path of `paths` goes first, and the checked path
/// takes over where it stops.
pub fn execute(comptime paths: Paths, comptime Window: type, run: *Run, context: Context, sink: *Sink(Window)) Error!bool {
    if (paths.fast_paths) fast_sequences.execute(Window, paths.claims, run, context, sink);
    return execute_checked(Window, run, context, sink);
}

/// The checked path of `execute`.
fn execute_checked(comptime Window: type, run: *Run, context: Context, sink: *Sink(Window)) Error!bool {
    // Each pass copies at least one octet, decodes a sequence, or ends the block; a block holds at
    // most Block_Maximum_Size octets and as many sequences.
    for (0..constants.block_execute_passes_max) |_| {
        if (run.literals_left > 0) {
            copy_literals(Window, run, context, sink);
            if (run.literals_left > 0) return false;
        }
        if (run.match_left > 0) {
            try copy_match(Window, run, sink);
            if (run.match_left > 0) return false;
            continue;
        }
        if (run.stream.left > 0) {
            try next_sequence(run, context);
            continue;
        }
        if (run.literals_used == run.section.len) return true;
        // RFC 8878 §3.1.1.3.2: literals left after the last sequence end the block.
        run.literals_left = run.section.len - run.literals_used;
    }
    unreachable;
}

/// Decodes the next sequence and checks it against the block (RFC 8878 §3.1.1.3.2.1.2, §3.1.1.5).
fn next_sequence(run: *Run, context: Context) Error!void {
    const sequence = try sequences.next(&run.stream, stream_octets(run, context.block), context.tables);
    work_module.add(context.work, work_module.of(1));
    // RFC 8878 §3.1.1.4: a sequence copies literals the literals section holds.
    if (sequence.literals_len > run.section.len - run.literals_used) return error.LiteralsOverrun;
    run.promised_len +|= sequence.match_len;
    // RFC 8878 §3.1.1.2.4: Block_Maximum_Size bounds a block's decompressed size.
    if (run.promised_len > context.block_len_max) return error.BlockTooLong;
    run.offset = try sequences.resolve_offset(context.repeats, sequence.offset_value, sequence.literals_len);
    run.literals_left = sequence.literals_len;
    run.match_left = sequence.match_len;
    // Decision 22 accepts an offset equal to Window_Size, which libzstd writes, where
    // RFC 8878 §3.1.1.4 asks for an offset smaller than Window_Size.
    if (run.offset > context.window_len) return error.OffsetTooFar;
}

/// Copies as many of the sequence's literals as the output has room for.
fn copy_literals(comptime Window: type, run: *Run, context: Context, sink: *Sink(Window)) void {
    const len: u32 = @intCast(@min(run.literals_left, sink.room()));
    const into = sink.output[sink.written..][0..len];
    switch (run.section.source) {
        .block => @memcpy(into, literal_octets(context.block, run.section.offset + run.literals_used, len)),
        .buffer => @memcpy(into, literal_octets(context.literals_buffer, run.literals_used, len)),
        // `codec.fill`, not `@memset`, and out of line as `memset` was (see `write_repeated`).
        .repeated => @call(.never_inline, codec.fill, .{ into, run.section.octet }),
    }
    sink.commit(len);
    run.literals_used += len;
    run.literals_left -= len;
}

fn literal_octets(octets: []const u8, start: u32, len: u32) []const u8 {
    assert(start + len <= octets.len);
    return octets[start..][0..len];
}

/// Copies as much of the sequence's match as the output has room for, from `offset` back, at
/// most `offset` octets at a time so every octet copied was written before (RFC 8878 §3.1.1.4).
fn copy_match(comptime Window: type, run: *Run, sink: *Sink(Window)) Error!void {
    // Invariant 10, RFC 8878 §3.1.1.3: an offset reaches no octet before the frame's first.
    if (run.offset > sink.reach()) return error.OffsetTooFar;
    for (0..run.match_left) |_| {
        const len: u32 = @intCast(@min(run.match_left, sink.room(), run.offset));
        if (len == 0) return;
        sink.copy_back(run.offset, sink.output[sink.written..][0..len]);
        sink.commit(len);
        run.match_left -= len;
    }
}

test {
    _ = @import("block_test.zig");
}
