//! The walk over a string's octets that the token loops of claims J10 and J11 take past its plain
//! ASCII: blocks of 16 copied as they are checked (claims J3 and J5), and the runs of a string's
//! scans where fewer than 16 octets of input or room are left. Each loop then takes the octet that
//! stopped the walk: the decoder a string's escape or its closing quotation mark, the encoder an
//! octet a string must escape. Checked a run at a time, a text whose lines end in escapes restarted
//! its run at each, and the UTF-8 check took under half of its time (design §8 step 18).
//!
//! It keeps what is left of the input and the output as slices, and moves past what it takes, so
//! the compiler knows their lengths: indices into them cost each access a check (decision 17).

const std = @import("std");
const constants = @import("constants.zig");
const scan = @import("scan.zig");
const wide = @import("wide.zig");
const Claims = @import("claims.zig").Claims;

/// How `Walk.take_blocks` stopped: at an octet that stops the run, which starts the input; short of
/// a block, where `Walk.take_run` goes on; or at an octet UTF-8 rules out.
pub const Stop = enum(u8) { octet, short, ruled_out };

/// `Walk.take_blocks` compiled into the AVX2 variant object (variants/string_walk_blocks.zig),
/// where the UTF-8 check takes decision 37's lookup, VPSHUFB, which the baseline target lacks.
extern fn stdx_json_take_blocks_x86_64_avx2(walk: *Walk, input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) callconv(.c) u8;

pub const Walk = struct {
    input: []const u8,
    output: []u8,
    /// The block before the input's first octet, for a character that crosses into it, and
    /// whether it is all ASCII. At the start and after an octet the loop took, none crosses.
    previous: @Vector(constants.vector_len, u8) = @splat(0),
    previous_ascii: bool = true,

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
            if (scan.string_stop(self.previous, block, self.previous_ascii)) |stop| {
                if (stop >= scan.ruled_out) return .ruled_out;
                self.input = self.input[stop..];
                self.output = self.output[stop..];
                return .octet;
            }
            self.previous = block;
            self.previous_ascii = scan.is_ascii(block);
            self.input = self.input[constants.vector_len..];
            self.output = self.output[constants.vector_len..];
        }
        if (!self.previous_ascii) {
            const taken_len = input.len - self.input.len;
            const cut_len = scan.cut_character_len(input[0..taken_len]);
            self.input = input[taken_len - cut_len ..];
            self.output = output[output.len - self.output.len - cut_len ..];
            self.took_octet();
        }
        return .short;
    }

    /// Takes the octets a string carries as they are, up to the octet that stops them: in blocks of
    /// 16 while the input and the output hold one (claim J5), and past them, or with J5 off, by the
    /// run's scans. Returns false at an octet UTF-8 rules out. `input` and `output` are the slices
    /// the walk started with.
    pub inline fn take_to_stop(self: *Walk, comptime claims: Claims, level: wide.Level, input: []const u8, output: []u8) bool {
        const stop: Stop = if (claims.utf8_vectors) self.take_blocks_at(level, input, output) else .short;
        switch (stop) {
            .ruled_out => return false,
            .short => self.take_run(claims, level),
            .octet => {},
        }
        return true;
    }

    /// `take_blocks`, in the variant object of `level` on x86-64 when the first block holds a
    /// non-ASCII octet: there the UTF-8 check is decision 37's lookup. A first block of ASCII, and
    /// every target without the object, take the blocks here: a call at each escape of a text of
    /// escapes and ASCII would cost what the lookup saves.
    inline fn take_blocks_at(self: *Walk, level: wide.Level, input: []const u8, output: []u8) Stop {
        if (comptime !wide.has_kernels) return self.take_blocks(input, output);
        if (level == .target or self.input.len < constants.vector_len or scan.is_ascii(self.input[0..constants.vector_len].*)) return self.take_blocks(input, output);
        return switch (level) {
            .avx2 => @enumFromInt(stdx_json_take_blocks_x86_64_avx2(self, input.ptr, input.len, output.ptr, output.len)),
            .target => unreachable,
        };
    }

    /// Takes the run of octets a string carries as they are, where fewer than 16 octets of input
    /// or of room are left: plain ASCII at `level`'s width (claim J7), and past a non-ASCII octet,
    /// whole UTF-8 characters too (claim J5).
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

    inline fn took_octet(self: *Walk) void {
        self.previous = @splat(0);
        self.previous_ascii = true;
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
