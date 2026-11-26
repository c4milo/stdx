//! The literal that every match of a pattern starts with, and the search for it (decision 86,
//! claim R2).
//!
//! A forward program that starts with instructions that each take one octet holds a literal that
//! every match starts with: no match can start where the literal does not stand. `Literal.of`
//! reads it from the program, and `find` gives the next place where it stands. The forward DFA's
//! skip goes there from the state that waits for a match to start, so the DFA reads no octet
//! between two places of the literal. A pattern that is its literal and nothing else needs no DFA:
//! each place of the literal is a match.
//!
//! `find` compares the literal's octets at two offsets, `first_at` and `last_at`, with
//! `skip_lanes` octets a step, as Muła describes for a vector substring search ("SIMD-friendly
//! algorithms for substring searching", 2016), and compares the whole literal where both stand at
//! their distance. Muła compares the first and last octets. `prepare` takes the two whose kinds
//! rank rarest (literal_rank.zig), so that `Шерлок`'s search compares the continuation octets of
//! `Ш` and `к`, not the lead octet 0xD0 that starts half of Cyrillic's letters. Two octets at a
//! distance stand together far less often than one octet alone does, so a step leaves few places
//! to compare. A comparison reads at most `literal_len_max` octets and each step moves on, so a
//! search stays linear in the text.
//!
//! A place of the literal may take an ASCII letter in either case, as `(?i)` compiles it: a split
//! between two instructions whose octets differ in `case_bit` alone. The literal keeps the lower
//! case and a bit in `folds`, and each compare at that place ORs `case_bit` into the text's octet
//! first. SSE2 and NEON do that with one instruction a vector.
const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const Program = program_file.Program;
const literal_find = @import("literal_find.zig");
const literal_rank = @import("literal_rank.zig");
const literal_compare = @import("literal_compare.zig");
const literal_common = @import("literal_common.zig");

/// Whether this target has the AVX2 variant object's searches (variants.zig): x86-64 alone
/// builds it.
pub const has_kernels = builtin.cpu.arch == .x86_64;

/// What the variant object's searches give where the text holds no place.
pub const no_place = std.math.maxInt(usize);

/// The places a search with `wide` set judges before it calls the variant object: one block of
/// `literal_steps` steps.
pub const near_len = constants.literal_steps * constants.skip_lanes;

extern fn stdx_regex_literal_find_x86_64_avx2(literal: *const Literal, haystack: [*]const u8, haystack_len: usize, from: usize) callconv(.c) usize;
extern fn stdx_regex_literal_find_places_x86_64_avx2(literal: *const Literal, haystack: [*]const u8, haystack_len: usize, from: usize, places: [*]usize, places_len: usize) callconv(.c) usize;
extern fn stdx_regex_literal_find_counting_x86_64_avx2(literal: *const Literal, haystack: [*]const u8, haystack_len: usize, from: usize, misses: *usize) callconv(.c) usize;

/// A bit for each place of a literal.
pub const Folds = std.meta.Int(.unsigned, constants.literal_len_max);

/// An extern struct, so that the variant object, built for other CPU features, reads the same
/// fields at the same offsets.
pub const Literal = extern struct {
    octets: [constants.literal_len_max]u8,
    len: u8,
    /// True when the literal is the whole pattern: a match is one place of the literal.
    exact: bool,
    /// True when `find` searches `avx2_lanes` octets a step, in the variant object: the caller's
    /// `platform.CpuFeatures` name AVX2, and `has_kernels` holds.
    wide: bool = false,
    /// A bit for each place that takes its octet in either case: `octets` holds the lower case.
    folds: Folds = 0,
    /// What a compare ORs into the text's octet at each place: `case_bit` where the place folds,
    /// and zero elsewhere, as `prepare` writes it from `folds`.
    fold_octets: [constants.literal_len_max]u8 = @splat(0),
    /// The two offsets below `len` whose octets the search compares, as `prepare` writes them.
    first_at: u8 = 0,
    last_at: u8 = 0,
    /// The offset whose octet a search compares too once its candidates missed
    /// `literal_third_misses` times, or `first_at` where the literal holds no third.
    third_at: u8 = 0,

    /// The literal every match of `program` starts with, or null where it has none that pays: a
    /// literal shorter than `literal_prefix_len_min` that more of the pattern follows. With
    /// `through_looks` the walk goes through assertions, which take no octet, so the literal
    /// stands where a match starts, and the match is the literal only where no assertion stood.
    /// With `through_looks`, a pattern with more than one way to start gives the literal that
    /// each way starts with (literal_common.zig).
    pub fn of(program: *const Program, through_looks: bool) ?Literal {
        const found = walk(program.instructions, program.forward, through_looks, constants.literal_len_max);
        var literal = found.literal;
        // A program with no assertion has claim R5's set of literals for its ways.
        if (through_looks and !found.reached_match and literal.len < constants.literal_prefix_len_min) {
            literal = literal_common.of(program.instructions, program.forward) orelse return null;
        }
        if (literal.len == 0) return null;
        if (!literal.exact and literal.len < constants.literal_prefix_len_min) return null;
        literal.prepare();
        return literal;
    }

    /// Writes `first_at` and `last_at`: the two offsets whose octets rank rarest by their kind,
    /// or the one octet of a literal of one.
    pub fn prepare(literal: *Literal) void {
        assert(literal.len >= 1 and literal.len <= constants.literal_len_max);
        for (&literal.fold_octets, 0..) |*fold, place| fold.* = if (place < literal.len) literal.fold_at(place) else 0;
        if (literal.len == 1) {
            literal.first_at = 0;
            literal.last_at = 0;
            literal.third_at = 0;
            return;
        }
        var past: usize = 0;
        for (literal.slice()) |octet| past += @intFromBool(octet > constants.one_octet_max);
        const past_ascii = literal_rank.mostly(past, literal.len);
        var ranks: [constants.literal_len_max]u8 = undefined;
        for (ranks[0..literal.len], literal.slice()) |*one, octet| one.* = @intFromEnum(literal_rank.rank(octet, past_ascii));
        const pair = literal_rank.rarest_pair(ranks[0..literal.len]);
        literal.first_at = pair.first;
        literal.last_at = pair.last;
        literal.third_at = literal_rank.third(literal.len, pair);
    }

    /// Claim R4: the literal every match ends with, read from the reverse program, and the
    /// instruction where the reverse program goes on to the part of a match before it. Null
    /// where the reverse program starts with no octet, or where it is all literal: claim R2 or
    /// R3 then holds the pattern.
    pub fn suffix_of(program: *const Program) ?Suffix {
        assert(program.reverse != program_file.no_entry);
        var suffix = chain(program, program.reverse, true) orelse return null;
        suffix.literal.prepare();
        return suffix;
    }

    /// Claim R14: the literal that the reverse program takes from `entry`, an instruction that
    /// takes one byte, and the instruction where the program goes on to the part of a match
    /// before the literal. Null where the literal is the start of every match. The literal is
    /// not ready for a search: a caller that keeps it calls `prepare`, since a program holds
    /// many such instructions and keeps one literal at most.
    pub fn chain_of(program: *const Program, entry: u32) ?Suffix {
        assert(program.reverse != program_file.no_entry and entry >= program.forward_len);
        return chain(program, entry, false);
    }

    /// The literal that the reverse program takes from `entry`, in the order of the text, not
    /// yet ready for a search.
    fn chain(program: *const Program, entry: u32, through_looks: bool) ?Suffix {
        var found = walk(program.instructions, entry, through_looks, constants.literal_len_max);
        if (found.literal.len == 0 or found.reached_match) return null;
        std.mem.reverse(u8, found.literal.octets[0..found.literal.len]);
        // The places' bits follow their octets: bit i goes to bit len - 1 - i.
        const unused: std.math.Log2Int(Folds) = @intCast(constants.literal_len_max - found.literal.len);
        found.literal.folds = @bitReverse(found.literal.folds) >> unused;
        found.literal.exact = false;
        const run = found.literal.first_run();
        return .{ .literal = found.literal, .before = found.stop, .run = run, .entry = entry, .through_looks = through_looks };
    }

    /// The count of the literal's first bytes that are its first byte, where the literal goes
    /// on past them. Zero where the literal is that byte alone.
    fn first_run(literal: *const Literal) u32 {
        var run: u32 = 0;
        for (literal.slice()) |octet| {
            if (octet != literal.octets[0]) break;
            run += 1;
        }
        return if (run == literal.len) 0 else run;
    }

    pub fn push(literal: *Literal, octet: u8, fold: bool) void {
        assert(literal.len < constants.literal_len_max);
        literal.octets[literal.len] = octet;
        if (fold) literal.folds |= @as(Folds, 1) << @intCast(literal.len);
        literal.len += 1;
    }

    pub fn slice(literal: *const Literal) []const u8 {
        return literal.octets[0..literal.len];
    }

    /// What a compare ORs into the text's octet at `place`: `case_bit` where the place folds.
    pub fn fold_at(literal: *const Literal, place: usize) u8 {
        return if (literal.folds >> @intCast(place) & 1 != 0) constants.case_bit else 0;
    }

    /// The first offset at or after `from` where the literal stands whole in `haystack`, or null.
    pub fn find(literal: *const Literal, haystack: []const u8, from: usize) ?usize {
        if (literal.len == 1 and literal.folds == 0) {
            const near = @min(haystack.len, from + constants.octet_near_len);
            if (literal_find.find_octet(constants.skip_lanes, haystack, from, near, literal.octets[0])) |offset| return offset;
            if (near == haystack.len) return null;
            if (has_kernels and literal.wide) return find_far(literal, haystack, near);
            return literal_find.find(constants.skip_lanes, literal, haystack, near, {});
        }
        if (has_kernels and literal.wide) {
            // The variant object's search is a call no compiler inlines. A place within a block
            // of `from`, as in a text where the literal is common, is found without a call.
            const near = @min(haystack.len, from + near_len);
            if (literal_find.find_before(constants.skip_lanes, literal, haystack, from, near, {})) |offset| return offset;
            return find_far(literal, haystack, near);
        }
        return literal_find.find(constants.skip_lanes, literal, haystack, from, {});
    }

    /// True where `find_places` serves a search from `from` in a text of `haystack_len` octets:
    /// with `wide`, for a literal of two octets or more and more than `near_len` octets left. A
    /// literal of one octet, or a text with fewer left, finds its place with no call.
    pub fn takes_places(literal: *const Literal, haystack_len: usize, from: usize) bool {
        return has_kernels and literal.wide and literal.len > 1 and haystack_len - from > near_len;
    }

    /// The places of the literal from `from` on, none inside another, written to `places` in
    /// order: each search starts where the place before it ends. Gives their count, under
    /// `places.len` only where the text holds no more. One call of the variant object finds them
    /// all: a call for each place cost `Matches` more time than its instructions.
    pub noinline fn find_places(literal: *const Literal, haystack: []const u8, from: usize, places: []usize) usize {
        assert(literal.takes_places(haystack.len, from) and places.len != 0);
        const count = stdx_regex_literal_find_places_x86_64_avx2(literal, haystack.ptr, haystack.len, from, places.ptr, places.len);
        assert(count <= places.len);
        return count;
    }

    /// `find` for a search that keeps an account, claim R14's or claim R4's: each candidate that
    /// held no place adds one to `misses`, a compare of the literal whole that a plain scan does
    /// not pay. A literal of one octet has no such candidate.
    pub fn find_counting(literal: *const Literal, haystack: []const u8, from: usize, misses: *usize) ?usize {
        if (literal.len == 1) return literal.find(haystack, from);
        if (has_kernels and literal.wide) {
            const near = @min(haystack.len, from + near_len);
            if (literal_find.find_before(constants.skip_lanes, literal, haystack, from, near, misses)) |offset| return offset;
            return find_far_counting(literal, haystack, near, misses);
        }
        return literal_find.find(constants.skip_lanes, literal, haystack, from, misses);
    }

    /// The variant object's search from `near`, out of line, so that `find` stays small enough
    /// for its callers to inline.
    noinline fn find_far(literal: *const Literal, haystack: []const u8, near: usize) ?usize {
        if (haystack.len - near < literal.len) return null;
        const found = stdx_regex_literal_find_x86_64_avx2(literal, haystack.ptr, haystack.len, near);
        return if (found == no_place) null else found;
    }

    /// `find_far` for `find_counting`.
    noinline fn find_far_counting(literal: *const Literal, haystack: []const u8, near: usize, misses: *usize) ?usize {
        if (haystack.len - near < literal.len) return null;
        const found = stdx_regex_literal_find_counting_x86_64_avx2(literal, haystack.ptr, haystack.len, near, misses);
        return if (found == no_place) null else found;
    }

    /// True when the literal stands whole at `index`, which leaves room for it.
    pub fn stands_at(literal: *const Literal, haystack: []const u8, index: usize) bool {
        return literal_compare.folded(haystack[index..][0..literal.len], &literal.octets, &literal.fold_octets);
    }
};

/// A literal every match ends with, and the first instruction of the reverse program after it.
pub const Suffix = struct {
    literal: Literal,
    before: u32,
    /// The count of the literal's first bytes that are one byte, where the literal goes on past
    /// them: one for ` x`, which `[ab]+ +x` ends with. Zero where the literal is one byte alone.
    run: u32,
    /// Where the walk that read the literal started, and whether it passed assertions.
    entry: u32,
    through_looks: bool,

    /// The instruction of the reverse program that takes the last byte of the literal's first
    /// run. The reverse program takes the run's bytes from there, and then goes to `before`.
    /// A second walk finds it: a searcher asks for few literals' and reads many.
    pub fn run_entry(suffix: *const Suffix, instructions: []const program_file.Instruction) u32 {
        assert(suffix.run != 0 and suffix.run < suffix.literal.len);
        // The walk takes the literal's last byte first, and stops at the instruction that takes
        // the first byte of the run.
        return walk(instructions, suffix.entry, suffix.through_looks, suffix.literal.len - suffix.run).stop;
    }
};

/// What a walk of a program found: the octets its instructions take one after another from
/// `entry`, and the instruction where it stopped.
const Walk = struct {
    literal: Literal,
    stop: u32,
    reached_match: bool,
};

/// Follows `out` from `entry` through saves, jumps and, with `through_looks`, assertions, and
/// keeps the octet of each instruction that takes one octet alone, up to `len_max`. It stops at
/// the first instruction that takes an octet past them, or more than one octet.
fn walk(instructions: []const program_file.Instruction, entry: u32, through_looks: bool, len_max: usize) Walk {
    assert(len_max <= constants.literal_len_max);
    var literal: Literal = .{ .octets = undefined, .len = 0, .exact = false };
    var passed_look = false;
    var index = entry;
    // Each instruction is read once: the walk follows `out`, and past a split that `case_pair`
    // takes, its two instructions' one `out`.
    for (0..instructions.len) |_| {
        const instruction = instructions[index];
        var next = instruction.out;
        switch (instruction.kind) {
            .save, .jump => {},
            .range => {
                if (instruction.lo != instruction.hi or literal.len == len_max) break;
                literal.push(instruction.lo, false);
            },
            .split => {
                if (literal.len == len_max) break;
                const pair = case_pair(instructions, instruction) orelse break;
                literal.push(pair.octet, true);
                next = pair.out;
            },
            .match => {
                literal.exact = !passed_look;
                return .{ .literal = literal, .stop = index, .reached_match = true };
            },
            // A node of a class takes more than one octet.
            .ranges => break,
            .look => {
                if (!through_looks) break;
                passed_look = true;
            },
            .fail => break,
        }
        index = next;
    }
    return .{ .literal = literal, .stop = index, .reached_match = false };
}

/// The lower case and the next instruction of a split whose two branches each take one octet,
/// the two differing in `case_bit` alone and leading to one instruction: `(?i)`'s ASCII letter.
fn case_pair(instructions: []const program_file.Instruction, split: program_file.Instruction) ?struct { octet: u8, out: u32 } {
    const one = instructions[split.out];
    const other = instructions[split.arg];
    if (one.kind != .range or other.kind != .range or one.out != other.out) return null;
    if (one.lo != one.hi or other.lo != other.hi) return null;
    if (one.lo ^ other.lo != constants.case_bit) return null;
    return .{ .octet = one.lo | constants.case_bit, .out = one.out };
}

test {
    _ = @import("literal_test.zig");
}
