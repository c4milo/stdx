//! `Searcher`: matches in a text that is all in one slice (decision 86).
//!
//! A searcher answers as `Matcher` answers, and takes a faster way to the answer where it has one.
//! A lazy DFA over the forward program reads the text once and says where the match ends. A lazy
//! DFA over the reverse program reads back from there and says where it starts. Only a caller who
//! asks for the capture groups pays for the matcher's slots, and only over the match. This is the
//! order of work Cox describes for RE2.
//!
//! Each DFA lives in a cache of a fixed size and gives up when the cache thrashes (dfa.zig). The
//! searcher then runs the matcher, so a search's worst case stays the matcher's: time linear in
//! the text.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const program_file = @import("../program.zig");
const Program = program_file.Program;
const matcher_file = @import("../matcher.zig");
const Matcher = matcher_file.Matcher;
const Span = matcher_file.Span;
const dfa_file = @import("../dfa/dfa.zig");
const Dfa = dfa_file.Dfa;
const Literal = literal_file.Literal;
const dfa_suffix = @import("../dfa/dfa_suffix.zig");
const dfa_wait = @import("../dfa/dfa_wait.zig");
const one_pass = @import("../one_pass.zig");
const backtrack = @import("../backtrack.zig");
const codec = @import("codec");
const literal_file = @import("../literal.zig");
const is_continuation = @import("../utf8_ranges.zig").is_continuation;

/// The words of the caches' memory in one word of a searcher's memory.
const cache_words_per_word = @sizeOf(u64) / @sizeOf(u32);

/// What a faster way found: the match, or that the text holds none.
const Answer = struct { span: ?Span };

/// The claims of a searcher, each a faster way that must give the answer the plain way gives.
/// A caller turns one off to measure it, or to rule it out.
pub const Claims = struct {
    /// R1: a forward DFA that waits for a match to start skips to the next octet that can start
    /// one, `skip_lanes` octets a step. It rests where the texts hold such octets too close
    /// together for a skip to pay, and tries again later.
    start_skip: bool = true,
    /// R2: where every match starts with a literal of two octets or more, that skip goes to the
    /// next place of the literal, found with its first and last octets `skip_lanes` places a
    /// step. Where the pattern is that literal and nothing else, the searcher reads no DFA: a
    /// place of the literal is a match. Only with `start_skip`.
    literal: bool = true,
    /// R4: where no literal starts every match and one ends every match, the searcher goes to
    /// the literal's next place and reads back from it to the match's start. Only with
    /// `start_skip`, and only where no part of a match before the literal takes its first octet.
    suffix: bool = true,
    /// R5: where an alternation's branches each start with a literal, and no one literal starts
    /// every match, the skip goes to the next place of one of them. Only with `start_skip`.
    literal_set: bool = true,
    /// R6: where the forward program is one-pass, `captures` follows one thread from the match's
    /// start, in place of the matcher's threads (one_pass.zig).
    one_pass: bool = true,
    /// R7: where the forward program has at most `pair_classes_max` classes of octets, a forward
    /// scan with no skip takes two octets for one read of the cache (dfa_pairs.zig).
    pairs: bool = true,
    /// R8: where the DFAs found a match's span and the program is not one-pass, `captures`
    /// follows one path at a time over the span, each instruction at each offset once, in place
    /// of the matcher's threads (backtrack.zig).
    backtrack: bool = true,
    /// R9: where a forward scan reads an octet over which its state stays where it is, it goes
    /// past the run of such octets, `skip_lanes` octets a step (dfa_stay.zig). It rests for a
    /// state whose runs are too short for a skip to pay.
    stays: bool = true,
    /// R10: `Matches.count` finds the end of each match by the forward DFA alone, and reads no
    /// match back to its start. Rust's crate counts its matches the same way.
    count_ends: bool = true,
};

/// What `Searcher.init` takes beside the program and the memory: one way to start a searcher, as
/// decision 30 rules for json's types.
pub const Options = struct {
    /// The CPU features the caller detected once with `codec.Features.detect()`, or
    /// `codec.Features.target()`. Where they name AVX2, claims R2 and R5 search `avx2_lanes`
    /// octets a step.
    features: codec.Features,
    /// Every claim, unless the tests or the benchmark turn one off, as a codec's options do.
    claims: Claims = .{},
};

/// What a searcher knows of claim R6 for its program.
const OnePass = enum {
    /// Not judged yet. A judgment walks a closure from each instruction that takes an octet, which
    /// costs more than the rest of `init` for a pattern with groups (design §8 part 22c).
    unknown,
    /// Two paths may take one octet, or the claim is off: the matcher finds the groups.
    no,
    /// One thread from the match's start finds the groups.
    yes,
    /// One thread finds the groups, and every match starts at the text's start, so it needs no
    /// DFA either.
    at_text,
};

/// Whether claims R2 and R5 search in the variant object of x86-64's AVX2.
fn wide_of(features: codec.Features) bool {
    return literal_file.has_kernels and features.avx2;
}

/// Whether claim R5 takes Teddy in the variant object of SSSE3: on x86-64 with SSSE3 and no
/// AVX2, whose object searches wider.
fn ssse3_of(features: codec.Features) bool {
    return literal_file.has_kernels and features.ssse3 and !features.avx2;
}

/// Judges claim R6 for the matcher's program, with the matcher's lists.
fn judge_one_pass(matcher: *Matcher) OnePass {
    if (!one_pass.check(matcher)) return .no;
    return if (starts_at_text_start(&matcher.program)) .at_text else .yes;
}

/// The words of a cache of `cache_len` words that the forward DFA takes, where the program has a
/// reverse half. Each DFA takes its least, and the two divide the rest: the forward DFA takes
/// `dfa_forward_parts` of `dfa_cache_parts`, and the reverse DFA the rest (decision 86, the
/// owner's ruling of 2026-11-23). Where the two leasts do not fit, no division starts both DFAs.
/// A search needs both, and `is_match` runs the forward DFA alone, so it takes the whole cache.
fn forward_part(program: *const Program, cache_len: usize) usize {
    const forward_least = Dfa.memory_len_min(program, program.forward);
    const reverse_least = Dfa.memory_len_min(program, program.reverse);
    if (forward_least + reverse_least > cache_len) return cache_len;
    const spare = cache_len - forward_least - reverse_least;
    const forward_len = forward_least + spare / constants.dfa_cache_parts * constants.dfa_forward_parts;
    assert(cache_len - forward_len >= reverse_least);
    return forward_len;
}

pub const Groups = @import("searcher_groups.zig").Groups;

pub const Searcher = struct {
    matcher: Matcher,
    forward: Dfa,
    reverse: Dfa,
    /// True when each DFA's cache has room for `dfa_states_min` states.
    forward_ready: bool,
    reverse_ready: bool,
    /// The searches in which a DFA gave up.
    give_ups: u32,
    /// Claim R2: the pattern, where it is a literal and nothing else.
    exact: ?Literal,
    /// Claim R5: true where the pattern is an alternation of literals and nothing else, so that
    /// the forward DFA's literal set gives each match and no DFA runs.
    exact_set: bool,
    /// Claim R4: the literal every match ends with, where the search starts from it.
    suffix: ?Literal,
    /// Claim R6: whether one thread finds the groups. Only `captures` reads it, so `init` leaves
    /// it `unknown`, and the first `captures` judges it.
    one_pass: OnePass,
    /// Claim R8: whether `captures` takes the backtracker over a span the DFAs found.
    backtrack: bool,
    /// Claim R10: whether a count finds the end of each match by the forward DFA alone.
    count_ends: bool,
    /// True where every match starts at the text's start, so the forward DFA's match starts at
    /// `from` and no reverse scan runs, as Rust's crate runs none for an anchored search.
    at_text: bool,
    /// The slots of the whole match, where it is a program's one group and the DFAs found it.
    whole: [constants.group_slots]u64,

    /// The words of memory a searcher takes for a program of `forward_len` forward instructions
    /// and `slots_len` slots, with `cache_words` words for its two caches. A cache too small for a
    /// DFA costs speed and no answer.
    pub fn memory_len(forward_len: u32, slots_len: u32, cache_words: usize) usize {
        return Matcher.memory_len(forward_len, slots_len) + cache_words;
    }

    /// Readies a searcher for `program`, with the options the caller passes. The memory is the
    /// searcher's until the caller is done with it, and holds at least `memory_len` words with no
    /// cache. `init` copies the options and keeps no pointer to them.
    pub fn init(searcher: *Searcher, program: *const Program, options: *const Options, memory: []u64) void {
        const claims = options.claims;
        const features = options.features;
        const matcher_len = Matcher.memory_len(program.forward_len, program.slot_count());
        assert(memory.len >= matcher_len);
        searcher.matcher.init(program, .{ .captures = .groups }, memory[0..matcher_len]);
        const cache: []u32 = std.mem.bytesAsSlice(u32, std.mem.sliceAsBytes(memory[matcher_len..]));
        const has_reverse = program.reverse != program_file.no_entry;
        const forward_len = if (has_reverse) forward_part(program, cache.len) else cache.len;
        searcher.forward_ready = searcher.forward.init(
            program,
            .{ .entry = program.forward, .kind = .first, .anchored = false, .skip = claims.start_skip, .literal = claims.start_skip and claims.literal, .literal_set = claims.start_skip and claims.literal_set, .wide = wide_of(features), .ssse3 = ssse3_of(features), .pairs = claims.pairs, .stays = claims.stays },
            cache[0..forward_len],
        );
        searcher.reverse_ready = has_reverse and searcher.reverse.init(
            program,
            .{ .entry = program.reverse, .kind = .longest, .anchored = true },
            cache[forward_len..],
        );
        searcher.give_ups = 0;
        searcher.init_claims(program, claims);
    }

    /// Readies the claims that read what the DFAs and the matcher found at `init`.
    fn init_claims(searcher: *Searcher, program: *const Program, claims: Claims) void {
        searcher.init_exact();
        // A program of no group but the whole match needs no thread: the DFAs give its span.
        searcher.one_pass = if (claims.one_pass and program.group_count > 1) .unknown else .no;
        searcher.backtrack = claims.backtrack;
        searcher.count_ends = claims.count_ends;
        searcher.at_text = starts_at_text_start(program);
        searcher.suffix = null;
        const suffix_on = claims.start_skip and claims.suffix and searcher.forward_ready and searcher.reverse_ready;
        // A literal that starts every match is the better way, and a pattern that starts at the
        // text's start reads few octets forward.
        if (suffix_on and searcher.forward.literal == null and !searcher.at_text) {
            searcher.suffix = dfa_suffix.suffix_of(&searcher.reverse, program);
            if (searcher.suffix) |*suffix| suffix.wide = searcher.forward.config.wide;
        }
    }

    /// Readies claims R2 and R5 where the pattern is a literal or a set of literals and nothing
    /// else, so that the forward DFA's literals give each match.
    fn init_exact(searcher: *Searcher) void {
        searcher.exact = null;
        searcher.exact_set = false;
        // A DFA that `init` refused holds no literal. Without a cache the matcher answers alone.
        if (!searcher.forward_ready) return;
        if (searcher.forward.literal) |literal| searcher.exact = if (literal.exact) literal else null;
        if (searcher.forward.literals) |set| searcher.exact_set = set.exact;
    }

    /// True when the haystack holds a match.
    pub fn is_match(searcher: *Searcher, haystack: []const u8) bool {
        if (searcher.exact) |*literal| return literal.find(haystack, 0) != null;
        if (searcher.exact_set) return searcher.forward.literals.?.find_exact(haystack, 0) != null;
        if (searcher.suffix != null) {
            if (searcher.find_by_dfa(haystack, 0)) |answer| return answer.span != null;
        } else if (searcher.forward_ready and searcher.give_ups < constants.dfa_give_ups_max) {
            // A text that holds no literal of claim R2 or R5 holds no match, with no scan to set up.
            const from = dfa_wait.first_start(&searcher.forward, haystack, 0) orelse return false;
            switch (searcher.forward.scan_forward(haystack, from, true)) {
                .gave_up => searcher.give_ups += 1,
                .none => return false,
                .found => return true,
            }
        }
        searcher.matcher.configure(.{ .captures = .none });
        searcher.matcher.start(null, 0);
        return searcher.matcher.search(haystack, .last).status == .match;
    }

    /// The first match at or after `from`, or null. To find the match after one, search from its
    /// end, or one scalar value past it where the match is empty.
    pub fn find(searcher: *Searcher, haystack: []const u8, from: usize) ?Span {
        assert(from <= haystack.len);
        if (searcher.find_by_dfa(haystack, from)) |answer| return answer.span;
        searcher.matcher.configure(.{ .captures = .span });
        return searcher.matcher.find(haystack, from);
    }

    /// The first match at or after `from`, with the span of each capture group: the whole match
    /// first, and null for a group that took no part in the match. Null where the haystack holds
    /// no match. The groups hold until the searcher's next search.
    pub fn captures(searcher: *Searcher, haystack: []const u8, from: usize) ?Groups {
        assert(from <= haystack.len);
        if (searcher.one_pass == .unknown) searcher.one_pass = judge_one_pass(&searcher.matcher);
        if (searcher.one_pass == .at_text) return searcher.captures_at_start(haystack, from);
        var anchor = from;
        var anchored = false;
        if (searcher.find_by_dfa(haystack, from)) |answer| {
            const span = answer.span orelse return null;
            // A program of no group but the whole match: the DFAs gave every group.
            if (searcher.matcher.program.group_count == 1) {
                searcher.whole = .{ span.start, span.end };
                return .{ .slots = &searcher.whole };
            }
            anchor = @intCast(span.start);
            anchored = true;
            searcher.matcher.configure(.{ .captures = .groups, .anchored = true });
            if (searcher.groups_in_span(haystack, anchor, @intCast(span.end)) != null) return searcher.matched_groups();
        }
        searcher.matcher.configure(.{ .captures = .groups, .anchored = anchored });
        if (searcher.matcher.find(haystack, anchor) == null) {
            assert(!anchored);
            return null;
        }
        return searcher.matched_groups();
    }

    /// The groups of the matcher's match, in its slots.
    fn matched_groups(searcher: *const Searcher) Groups {
        assert(searcher.matcher.finished and searcher.matcher.matched);
        const slots = searcher.matcher.best();
        assert(slots.len == @as(usize, searcher.matcher.program.group_count) * constants.group_slots);
        return .{ .slots = slots };
    }

    /// The groups of the match from `start` to `end`, which the DFAs found, by one thread where
    /// the program is one-pass (claim R6), or by the backtracker (claim R8). Null where neither
    /// applies, or the backtracker's tables are too small: the matcher then finds them.
    fn groups_in_span(searcher: *Searcher, haystack: []const u8, start: usize, end: usize) ?Span {
        if (searcher.one_pass == .yes) return one_pass.find(&searcher.matcher, haystack, start);
        if (searcher.backtrack) return backtrack.find(&searcher.matcher, haystack, start, end);
        return null;
    }

    /// Claim R6 for a program whose every match starts at the text's start: a match starts at
    /// `from` or nowhere, so one thread from there finds it and its groups, with no DFA.
    fn captures_at_start(searcher: *Searcher, haystack: []const u8, from: usize) ?Groups {
        searcher.matcher.configure(.{ .captures = .groups, .anchored = true });
        if (one_pass.find(&searcher.matcher, haystack, from) == null) return null;
        return searcher.matched_groups();
    }

    /// The match as the two DFAs find it, or null when the searcher has no DFA for the search or
    /// one gave up.
    fn find_by_dfa(searcher: *Searcher, haystack: []const u8, from: usize) ?Answer {
        if (searcher.exact) |*literal| {
            const start = literal.find(haystack, from) orelse return .{ .span = null };
            return .{ .span = .{ .start = start, .end = start + literal.len } };
        }
        if (searcher.exact_set) {
            const place = searcher.forward.literals.?.find_exact(haystack, from) orelse return .{ .span = null };
            return .{ .span = .{ .start = place.start, .end = place.end } };
        }
        if (!searcher.forward_ready or !searcher.reverse_ready) return null;
        if (searcher.give_ups >= constants.dfa_give_ups_max) return null;
        if (searcher.suffix) |*suffix| return searcher.find_by_suffix(suffix, haystack, from);
        const end = switch (searcher.forward.scan_forward(haystack, from, false)) {
            .gave_up => return searcher.gave_up(),
            .none => return .{ .span = null },
            .found => |offset| offset,
        };
        // `^` holds at the text's start alone, so a match found from `from` starts there.
        if (searcher.at_text) return .{ .span = .{ .start = from, .end = end } };
        const start = switch (searcher.reverse.scan_reverse(haystack, from, end)) {
            .gave_up => return searcher.gave_up(),
            // The forward program matched text that ends at `end`, so the reverse program matches
            // it read backward.
            .none => unreachable,
            .found => |offset| offset,
        };
        return .{ .span = .{ .start = start, .end = end } };
    }

    fn gave_up(searcher: *Searcher) ?Answer {
        searcher.give_ups += 1;
        return null;
    }

    /// Claim R4: the first match at or after `from`, found from the places of the suffix in
    /// turn. At the first place from which the reverse DFA reads back to a match's start, the
    /// match ends with the place's suffix (dfa_suffix.zig).
    /// Out of line, so that `find_by_dfa` stays small enough for its caller to inline.
    noinline fn find_by_suffix(searcher: *Searcher, suffix: *const Literal, haystack: []const u8, from: usize) ?Answer {
        var index = from;
        // Each turn goes on from one octet past the place before, so the turns are at most the
        // octets from `from` and one.
        for (0..haystack.len - from + 1) |_| {
            const place = suffix.find(haystack, index) orelse return .{ .span = null };
            const end = place + suffix.len;
            switch (searcher.reverse.scan_reverse(haystack, from, end)) {
                .none => index = place + 1,
                .gave_up => return searcher.gave_up(),
                .found => |start| {
                    // The program takes whole UTF-8 sequences, so a match starts at no
                    // continuation octet.
                    assert(!is_continuation(haystack[start]));
                    return .{ .span = .{ .start = start, .end = end } };
                },
            }
        }
        return .{ .span = null };
    }
};

/// True when every match starts at the text's start: the forward program asserts it before it
/// takes an octet or splits.
fn starts_at_text_start(program: *const Program) bool {
    var index = program.forward;
    // The walk follows `out`, and reads each instruction once.
    for (0..program.forward_len) |_| {
        const instruction = program.instructions[index];
        switch (instruction.kind) {
            .save, .jump => index = instruction.out,
            .look => {
                if (instruction.look == .behind_text) return true;
                index = instruction.out;
            },
            else => return false,
        }
    }
    return false;
}

pub const Matches = @import("searcher_matches.zig").Matches;

test {
    _ = @import("searcher_test.zig");
    _ = @import("searcher_skip_test.zig");
    _ = @import("searcher_literal_test.zig");
    _ = @import("searcher_suffix_test.zig");
    _ = @import("searcher_one_pass_test.zig");
    _ = @import("searcher_wide_test.zig");
    _ = @import("searcher_pairs_test.zig");
    _ = @import("searcher_stay_test.zig");
    _ = @import("searcher_count_test.zig");
    _ = @import("searcher_groups_test.zig");
    _ = @import("searcher_run_test.zig");
    _ = @import("searcher_matches.zig");
}
