//! The walk over a string's octets that the token loops of claims J10 and J11 take past its plain
//! ASCII: blocks of 16 copied as they are checked (claims J3 and J5), 32 past a run's ASCII in the
//! decoder's walk in the AVX2 variant object (string_walk_wide.zig), and the runs of a string's
//! scans where fewer octets of input or room than a block's are left. Each loop then takes the
//! octet that stopped the walk: the decoder a string's escape or its closing quotation mark, the
//! encoder an octet a string must escape. Checked a run at a time, a text whose lines end in
//! escapes restarted its run at each, and the UTF-8 check took under half of its time (design §8
//! step 18).
//!
//! It keeps what is left of the input and the output as slices, and moves past what it takes, so
//! the compiler knows their lengths: indices into them cost each access a check (decision 17).

const std = @import("std");
const builtin = @import("builtin");
const constants = @import("constants.zig");
const scan = @import("scan.zig");
const wide = @import("wide.zig");
const wide_walk = @import("string_walk_wide.zig");
const Claims = @import("claims.zig").Claims;

/// How `Walk.take_blocks` stopped: at an octet that stops the run, which starts the input; short of
/// a block, where `Walk.take_run` goes on; or at an octet UTF-8 rules out.
pub const Stop = enum { octet, short, ruled_out };

// Whether the walk takes a run's ASCII blocks in a loop of their own, `take_ascii`, before the
// blocks the UTF-8 check judges, is each caller's choice, `two_loops` of `take_to_stop`. aarch64's
// registers hold both loops' state, and the second loop gained 5% to 7% on non-ASCII text and on
// ASCII text with escapes there. On x86-64, 16 registers of each kind, the two loops spilled the
// encoder's state to the stack, and one loop, with `scan.string_stop` asking the ASCII question
// inside it, encoded bible.txt at 1.56 times the speed; the decoder's walk decoded the text files 3%
// to 12% faster with two loops on both x86-64 CPUs drawn (design §8 step 18).

pub const Walk = struct {
    input: []const u8,
    output: []u8,
    /// The block before the input's first octet, for a character that crosses into it, and
    /// whether every block since the last octet the loop took was ASCII, so that none crosses. At
    /// the start and after an octet the loop took, none crosses.
    previous: @Vector(constants.vector_len, u8) = @splat(0),
    ascii_so_far: bool = true,

    /// Where `take_ascii` stopped: at an octet to escape, which starts the input; at an octet from
    /// 0x80 up, which starts the input, with the ASCII test off for the UTF-8 walk to go on from
    /// it; or short of a block on either side.
    const AsciiStop = enum { octet, non_ascii, short };

    /// Takes plain ASCII a block at a time while the input and the output hold one: each block
    /// stored as it is, then classified once into a word of the lanes that end the run, one
    /// transfer from a vector to a word where a test for ASCII and a test for a stop paid two. A
    /// block with no stop is taken by a stride the word does not decide, so the next block's
    /// address waits on no transfer and the loop runs at the vectors' pace (design §8 step 18).
    inline fn take_ascii(self: *Walk, input_len: usize) AsciiStop {
        for (0..input_len / constants.vector_len + 1) |_| {
            if (self.input.len < constants.vector_len or self.output.len < constants.vector_len) return .short;
            const block: @Vector(constants.vector_len, u8) = self.input[0..constants.vector_len].*;
            self.output[0..constants.vector_len].* = block;
            const stops = scan.ascii_stops(block);
            if (stops == 0) {
                self.advance(constants.vector_len);
                continue;
            }
            self.advance(scan.word_first(stops));
            if (self.input[0] < constants.non_ascii_min) return .octet;
            self.ascii_so_far = false;
            return .non_ascii;
        }
        unreachable;
    }

    inline fn advance(self: *Walk, len: usize) void {
        self.input = self.input[len..];
        self.output = self.output[len..];
    }

    /// Copies blocks of 16 while the input and the output hold one, each as it is checked, up to
    /// the first octet that stops the run: an octet a string must escape, or one UTF-8 rules out
    /// there (RFC 8259 §7, RFC 3629 §4). Short of a block, it steps back to the start of a
    /// character the last block cut, which `take_run` then takes whole. `input` and `output` are
    /// the slices the walk started with.
    pub inline fn take_blocks(self: *Walk, input: []const u8, output: []u8) Stop {
        for (0..input.len / constants.vector_len) |_| {
            if (self.input.len < constants.vector_len or self.output.len < constants.vector_len) break;
            const block: @Vector(constants.vector_len, u8) = self.input[0..constants.vector_len].*;
            self.output[0..constants.vector_len].* = block;
            if (scan.string_stop(self.previous, block, self.input[0..constants.vector_len], &self.ascii_so_far)) |stop| {
                if (stop >= scan.ruled_out) return .ruled_out;
                self.input = self.input[stop..];
                self.output = self.output[stop..];
                return .octet;
            }
            self.previous = block;
            self.input = self.input[constants.vector_len..];
            self.output = self.output[constants.vector_len..];
        }
        if (!self.ascii_so_far) {
            const taken_len = input.len - self.input.len;
            const cut_len = scan.cut_character_len(input[0..taken_len]);
            self.input = input[taken_len - cut_len ..];
            self.output = output[output.len - self.output.len - cut_len ..];
            self.took_octet();
        }
        return .short;
    }

    /// Takes the octets a string carries as they are, up to the octet that stops them: in blocks
    /// while the input and the output hold one (claim J5), and past them, or with J5 off, by the
    /// run's scans. Returns false at an octet UTF-8 rules out. `input` and `output` are the slices
    /// the walk started with. `block_len` is the octets of a block past a run's ASCII: 16, or
    /// `wide_walk.block_len` in the AVX2 variant object, whose caller names it
    /// (string_walk_wide.zig).
    pub inline fn take_to_stop(self: *Walk, comptime claims: Claims, comptime two_loops: bool, comptime block_len: usize, level: wide.Level, input: []const u8, output: []u8) bool {
        comptime std.debug.assert(block_len == constants.vector_len or block_len == wide_walk.block_len);
        // A run that starts with a non-ASCII octet goes straight to the UTF-8 walk.
        if (claims.utf8_vectors and self.ascii_so_far and self.input.len > 0 and self.input[0] >= constants.non_ascii_min) self.ascii_so_far = false;
        if (claims.utf8_vectors and self.ascii_so_far and two_loops) {
            switch (self.take_ascii(input.len)) {
                .octet => return true,
                .short => {
                    self.take_run(claims, level);
                    return true;
                },
                .non_ascii => {},
            }
        }
        const stop: Stop = if (!claims.utf8_vectors) .short else if (block_len == constants.vector_len) self.take_blocks(input, output) else self.take_wide_blocks();
        switch (stop) {
            .ruled_out => return false,
            .short => self.take_run(claims, level),
            .octet => {},
        }
        return true;
    }

    /// `wide_walk.take_blocks`, with the walk moved past what it took.
    inline fn take_wide_blocks(self: *Walk) Stop {
        std.debug.assert(!self.ascii_so_far);
        const taken = wide_walk.take_blocks(self.input, self.output);
        self.advance(taken.len);
        if (taken.stop == .short) self.took_octet();
        return taken.stop;
    }

    /// Takes the run of octets a string carries as they are, where fewer octets of input or of
    /// room than a block's are left: plain ASCII at `level`'s width (claim J7), and past a
    /// non-ASCII octet, whole UTF-8 characters too (claim J5).
    pub inline fn take_run(self: *Walk, comptime claims: Claims, level: wide.Level) void {
        const window = self.input[0..@min(self.input.len, self.output.len)];
        const run_len = run_of(claims, level, window);
        scan.copy(self.output[0..run_len], window[0..run_len]);
        self.input = self.input[run_len..];
        self.output = self.output[run_len..];
    }

    /// Moves past `input_len` octets of input the loop took, all ASCII, and the `output_len` it
    /// wrote for them. No character of the input then crosses into what is left of it.
    pub inline fn take(self: *Walk, input_len: usize, output_len: usize) void {
        self.input = self.input[input_len..];
        self.output = self.output[output_len..];
        self.took_octet();
    }

    pub inline fn took_octet(self: *Walk) void {
        self.previous = @splat(0);
        self.ascii_so_far = true;
    }
};

/// The run of octets a string carries as they are that starts `window`: plain ASCII at `level`'s
/// width (claim J7), and past a non-ASCII octet, whole UTF-8 characters too (claim J5).
pub inline fn run_of(comptime claims: Claims, level: wide.Level, window: []const u8) usize {
    const plain_len = wide.plain_len(level.with(claims), window);
    if (plain_len == window.len or window[plain_len] < constants.non_ascii_min) return plain_len;
    const rest = window[plain_len..];
    return plain_len + if (claims.utf8_vectors) scan.content_len_vector(constants.vector_len, rest) else scan.content_len_scalar(rest);
}
