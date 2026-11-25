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
const dfa_wait = @import("../dfa/dfa_wait.zig");
const one_pass = @import("../one_pass.zig");
const backtrack = @import("../backtrack.zig");
const codec = @import("codec");
const platform = @import("platform");
const literal_file = @import("../literal.zig");
const searcher_edge = @import("searcher_edge.zig");
const searcher_account = @import("searcher_account.zig");
const searcher_claim = @import("searcher_claim.zig");

/// The words of the caches' memory in one word of a searcher's memory.
const cache_words_per_word = @sizeOf(u64) / @sizeOf(u32);

/// What a faster way found: a match, whose span the caller keeps beside this, that the text
/// holds none, or nothing, where the matcher answers. An answer that held its span came back
/// through memory where the ways joined: stored as two words and read as one, which no CPU
/// forwards, at 12 to 35 percent of a short search (design §8 part 22q).
pub const Outcome = enum { match, none, unknown };

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
    /// R11: where every match starts at the text's start, the forward DFA waits for no match. It
    /// starts one at the scan's first byte and stops at the first byte that no thread takes.
    text_start: bool = true,
    /// R12: where every match ends at the text's end, and not every match starts at its start,
    /// the searcher reads back from the text's end to the match's start, and scans no text
    /// forward.
    text_end: bool = true,
    /// R13: where every match starts at the text's start and ends at its end, a text shorter
    /// than the pattern's least match, or longer than its greatest, holds no match, and the
    /// searcher reads none of it. A walk of the program finds both lengths (dfa_length.zig).
    length: bool = true,
    /// R14: where every match holds a literal after a part that claim R4's rules hold for, and
    /// no other claim finds its matches, the searcher goes to the literal's places. It reads
    /// back from each to the match's start, and forward from there to its end
    /// (searcher_inner.zig). Only with `start_skip`.
    inner: bool = true,
    /// The window: where every match holds a literal at most `window_lead_max` bytes after its
    /// start, and no claim from R2 to R5 or R14 holds, the forward DFA's state that waits goes
    /// to that many bytes before the literal's next place (dfa_window.zig). Only with
    /// `start_skip`, and judged with R14.
    window: bool = true,
};

/// What `Searcher.init` takes beside the program and the memory: one way to start a searcher, as
/// decision 30 rules for json's types.
pub const Options = struct {
    /// The CPU features the caller detected once with `platform.CpuFeatures.detect()`, or
    /// `platform.CpuFeatures.target()`. Where they name AVX2, claims R2 and R5 search `avx2_lanes`
    /// octets a step.
    features: platform.CpuFeatures,
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
fn wide_of(features: platform.CpuFeatures) bool {
    return literal_file.has_kernels and features.avx2;
}

/// Whether claim R5 takes Teddy in the variant object of SSSE3: on x86-64 with SSSE3 and no
/// AVX2, whose object searches wider.
fn ssse3_of(features: platform.CpuFeatures) bool {
    return literal_file.has_kernels and features.ssse3 and !features.avx2;
}

/// Judges claim R6 for the matcher's program, with the matcher's lists.
fn judge_one_pass(matcher: *Matcher) OnePass {
    if (!one_pass.check(matcher)) return .no;
    return if (searcher_edge.starts_at_text_start(&matcher.program)) .at_text else .yes;
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
    /// Claim R14: the literal every match holds in its middle, where the search starts from it.
    inner: ?Literal,
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
    /// Claim R12: true where every match ends at the text's end and the search reads back from
    /// there.
    at_end: bool,
    /// Claim R13: the least length of a match that is the whole text, and the greatest less the
    /// least, once the searcher judged the claim. A searcher with no such lengths holds zero and
    /// the greatest `usize`, which no text's length is outside.
    len_least: usize,
    len_span: usize,
    /// True where claim R4's second rule or its third took `suffix`: such a search keeps the
    /// account below, and the first rule's does not.
    suffix_wide: bool,
    /// The account of the claim that may lose by its places: claim R14, or claim R4 where
    /// `suffix_wide` holds (searcher_account.zig).
    account: searcher_account.Account,
    /// Claims R4 and R14 where the searcher has not judged them yet, and the bytes of text its
    /// searches still cover before it does (searcher_claim.zig).
    deferred: searcher_claim.Deferred,
    deferred_left: usize,
    /// True where a claim of searcher_claim.zig finds the match or waits: `at_end`, `suffix`,
    /// `inner`, claim R13's lengths or `deferred`. A search reads this one flag for them all.
    by_claim: bool,
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
        searcher.at_text = searcher_edge.starts_at_text_start(program);
        // Claim R11: an anchored scan waits for no match, so it takes no skip and no stay.
        const waits = !(claims.text_start and searcher.at_text);
        const skip = claims.start_skip and waits;
        searcher.forward_ready = searcher.forward.init(
            program,
            .{ .entry = program.forward, .kind = .first, .anchored = !waits, .skip = skip, .literal = skip and claims.literal, .literal_set = skip and claims.literal_set, .wide = wide_of(features), .ssse3 = ssse3_of(features), .pairs = claims.pairs, .stays = claims.stays and waits },
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
        searcher_claim.ready(searcher, program, claims);
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

    /// Claim R13: true when a text of `len` bytes holds no match, by its length alone. One
    /// compare: a length under the least wraps past every span.
    pub inline fn excludes(searcher: *const Searcher, len: usize) bool {
        return len -% searcher.len_least > searcher.len_span;
    }

    /// True when the haystack holds a match.
    pub fn is_match(searcher: *Searcher, haystack: []const u8) bool {
        if (searcher.exact) |*literal| return literal.find(haystack, 0) != null;
        if (searcher.exact_set) return searcher.forward.literals.?.find_exact(haystack, 0) != null;
        if (searcher.by_claim) {
            if (searcher.is_match_by_claim(haystack)) |matched| return matched;
        }
        if (searcher.forward_ready and searcher.give_ups < constants.dfa_give_ups_max) {
            const scan = if (dfa_wait.has_literal(&searcher.forward))
                searcher.scan_from_literal(haystack) orelse return false
            else
                searcher.forward.scan_forward(haystack, 0, true);
            switch (scan) {
                .gave_up => searcher.give_ups += 1,
                .none => return false,
                .found => return true,
            }
        }
        searcher.matcher.configure(.{ .captures = .none });
        searcher.matcher.start(null, 0);
        return searcher.matcher.search(haystack, .last).status == .match;
    }

    /// `is_match` for a searcher with a claim of searcher_claim.zig, or null where the forward
    /// scan of `is_match` answers. A searcher that holds claim R13's lengths holds no other
    /// claim of that file, and none that waits, so it calls nothing there.
    inline fn is_match_by_claim(searcher: *Searcher, haystack: []const u8) ?bool {
        if (searcher.excludes(haystack.len)) return false;
        if (searcher.len_span != std.math.maxInt(usize)) return null;
        return searcher_claim.is_match(searcher, haystack);
    }

    /// `is_match`'s forward scan for a DFA with claim R2's literal or R5's set: a text that holds
    /// none of them holds no match, and gets null with no scan to set up. Out of line, so that
    /// `is_match` keeps its scan from 0, a constant its inlined start folds: with this scan inline
    /// too, a grep of short lines with no literal ran 5% to 9% slower on the N2.
    noinline fn scan_from_literal(searcher: *Searcher, haystack: []const u8) ?dfa_file.Scan {
        const from = dfa_wait.first_start(&searcher.forward, haystack, 0) orelse return null;
        return searcher.forward.scan_forward(haystack, from, true);
    }

    /// The first match at or after `from`, or null. To find the match after one, search from its
    /// end, or one scalar value past it where the match is empty.
    pub fn find(searcher: *Searcher, haystack: []const u8, from: usize) ?Span {
        assert(from <= haystack.len);
        // A claim's search returns by itself, and joins no other answer (`Outcome`).
        if (searcher.by_claim) return searcher_claim.find_span(searcher, haystack, from);
        var span: Span = undefined;
        // A `return` for each outcome: each writes the result where the caller reads it.
        switch (searcher.find_by_dfa(haystack, from, &span)) {
            .match => return span,
            .none => return null,
            .unknown => {},
        }
        return searcher.find_by_matcher(haystack, from);
    }

    /// The first match at or after `from` as the matcher finds it, where no faster way did.
    pub fn find_by_matcher(searcher: *Searcher, haystack: []const u8, from: usize) ?Span {
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
        // As in `find`, a claim's answer joins no other.
        var span: Span = undefined;
        if (searcher.by_claim) {
            const outcome = searcher_claim.find_outcome(searcher, haystack, from, &span);
            return searcher.captures_of(outcome, span, haystack, from);
        }
        return searcher.captures_of(searcher.find_by_dfa(haystack, from, &span), span, haystack, from);
    }

    /// `captures` once a faster way gave its outcome, and the match's span where it found one.
    inline fn captures_of(searcher: *Searcher, outcome: Outcome, span: Span, haystack: []const u8, from: usize) ?Groups {
        var anchor = from;
        var anchored = false;
        if (outcome == .none) return null;
        if (outcome == .match) {
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

    /// The match as the two DFAs find it, written to `span`, or `unknown` when the searcher has
    /// no DFA for the search or one gave up. Inline, as `find` and `captures` held it before
    /// searcher_claim.zig: in a function of its own, its skip took 7% more instructions (design
    /// §8 part 22q). That file's claims call it where they leave a search to the two DFAs.
    pub inline fn find_by_dfa(searcher: *Searcher, haystack: []const u8, from: usize, span: *Span) Outcome {
        if (searcher.exact) |*literal| {
            const start = literal.find(haystack, from) orelse return .none;
            span.* = .{ .start = start, .end = start + literal.len };
            return .match;
        }
        if (searcher.exact_set) {
            const place = searcher.forward.literals.?.find_exact(haystack, from) orelse return .none;
            span.* = .{ .start = place.start, .end = place.end };
            return .match;
        }
        if (!searcher.forward_ready or !searcher.reverse_ready) return .unknown;
        if (searcher.give_ups >= constants.dfa_give_ups_max) return .unknown;
        const end = switch (searcher.forward.scan_forward(haystack, from, false)) {
            .gave_up => return searcher.gave_up(),
            .none => return .none,
            .found => |offset| offset,
        };
        // `^` holds at the text's start alone, so a match found from `from` starts there.
        const start = if (searcher.at_text) from else switch (searcher.reverse.scan_reverse(haystack, from, end)) {
            .gave_up => return searcher.gave_up(),
            // The forward program matched text that ends at `end`, so the reverse program matches
            // it read backward.
            .none => unreachable,
            .found => |offset| offset,
        };
        span.* = .{ .start = start, .end = end };
        return .match;
    }

    /// Counts a search in which a DFA gave up, which the matcher answers.
    pub inline fn gave_up(searcher: *Searcher) Outcome {
        searcher.give_ups += 1;
        return .unknown;
    }
};

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
    _ = @import("searcher_bytes_test.zig");
    _ = @import("searcher_matches.zig");
    _ = @import("searcher_edge_test.zig");
    _ = @import("searcher_inner_test.zig");
    _ = @import("searcher_second_test.zig");
    _ = @import("searcher_window_test.zig");
    _ = @import("searcher_claim_test.zig");
    _ = @import("searcher_account.zig");
}
