//! The claims of a searcher that find a match from a place of the text, or judge a text by its
//! length (decision 86): R4, R12, R13 and R14. A searcher reads one flag for them all,
//! `by_claim`, so a searcher with none of them keeps the plain search of `find_by_dfa`.
//!
//! Claim R4's second and third rules, claim R13 and claim R14 judge a pattern by walks of its
//! program, which cost more than the rest of `init` (design §8 part 22q). So `init` judges
//! none of them. They wait until the searcher's searches were given
//! `claim_text_per_instruction` bytes of text for each instruction of the reverse program, so a
//! searcher that reads little never pays for the walks. Until then the plain search answers,
//! and gives the same answers.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const program_file = @import("../program.zig");
const Program = program_file.Program;
const Literal = @import("../literal.zig").Literal;
const Span = @import("../matcher.zig").Span;
const dfa_suffix = @import("../dfa/dfa_suffix.zig");
const dfa_inner = @import("../dfa/dfa_inner.zig");
const dfa_length = @import("../dfa/dfa_length.zig");
const dfa_window = @import("../dfa/dfa_window.zig");
const dfa_window_set = @import("../dfa/dfa_window_set.zig");
const searcher_file = @import("searcher.zig");
const Searcher = searcher_file.Searcher;
const Outcome = searcher_file.Outcome;
const searcher_edge = @import("searcher_edge.zig");
const searcher_inner = @import("searcher_inner.zig");
const searcher_account = @import("searcher_account.zig");
const Account = searcher_account.Account;
const Found = searcher_account.Found;
const Dfa = @import("../dfa/dfa.zig").Dfa;

/// The claims a searcher has not judged yet.
pub const Deferred = struct {
    /// Claim R4's second and third rules, for a pattern that ends with a literal.
    suffix: bool = false,
    /// Claim R14.
    inner: bool = false,
    /// The window (dfa_window.zig).
    window: bool = false,
    /// Claim R13, for a pattern that starts at the text's start and ends at its end.
    length: bool = false,

    pub fn any(deferred: Deferred) bool {
        return deferred.suffix or deferred.inner or deferred.window or deferred.length;
    }
};

/// Readies the claims of this file for a searcher whose DFAs `init` made.
pub fn ready(searcher: *Searcher, program: *const Program, claims: searcher_file.Claims) void {
    const both_ready = searcher.forward_ready and searcher.reverse_ready;
    // A pattern that starts at the text's start reads few bytes forward.
    const at_text_end = searcher_edge.ends_at_text_end(program);
    searcher.at_end = claims.text_end and both_ready and !searcher.at_text and at_text_end;
    searcher.len_least = 0;
    searcher.len_span = std.math.maxInt(usize);
    searcher.suffix = null;
    searcher.suffix_wide = false;
    searcher.inner = null;
    searcher.account = .{};
    searcher.deferred = .{ .length = claims.length and searcher.forward_ready and searcher.at_text and at_text_end };
    // A literal that starts every match is the better way to its places, and so is a search
    // from the text's end. A pattern that starts at the text's start reads few bytes forward.
    const by_place = claims.start_skip and both_ready and searcher.forward.literal == null and !searcher.at_end and !searcher.at_text;
    if (by_place and claims.suffix) ready_suffix(searcher, program);
    // Claim R14 is for a pattern that no other claim finds the matches of.
    searcher.deferred.inner = by_place and claims.inner and searcher.suffix == null and searcher.forward.literals == null;
    // The window takes claim R1's skip, which a program with an assertion has none of.
    searcher.deferred.window = by_place and claims.window and searcher.suffix == null and searcher.forward.literals == null and searcher.forward.may_skip;
    searcher.deferred_left = (program.instructions.len - program.forward_len) * constants.claim_text_per_instruction;
    searcher.by_claim = flag(searcher);
}

/// Claim R4 at `init`: the first rule, which one walk judges. The second rule and the third
/// wait, where the pattern ends with a literal that they may take.
fn ready_suffix(searcher: *Searcher, program: *const Program) void {
    const suffix = Literal.suffix_of(program) orelse return;
    if (dfa_suffix.holds(&searcher.reverse, &suffix, .first)) {
        searcher.suffix = suffix.literal;
        searcher.suffix.?.wide = searcher.forward.config.wide;
        return;
    }
    // Beside a set of literals, which claim R5 goes to, the first rule alone takes a suffix.
    searcher.deferred.suffix = searcher.forward.literals == null and suffix.literal.len >= constants.literal_prefix_len_min;
}

/// Judges the claims that waited, and leaves none waiting. The walks take the DFAs' lists,
/// which no scan holds between two searches.
pub fn judge(searcher: *Searcher) void {
    const program = &searcher.matcher.program;
    if (searcher.deferred.suffix) {
        // `init` refused the first rule, so a suffix taken here is the second's or the third's.
        searcher.suffix = dfa_suffix.suffix_of(&searcher.reverse, program, .all);
        searcher.suffix_wide = searcher.suffix != null;
        if (searcher.suffix) |*suffix| suffix.wide = searcher.forward.config.wide;
    }
    if (searcher.deferred.inner and searcher.suffix == null) {
        if (dfa_inner.inner_of(&searcher.reverse, program)) |inner| {
            searcher.inner = inner.literal;
            searcher.inner.?.wide = searcher.forward.config.wide;
            // The reverse DFA's second start reads the part of a match before the literal.
            searcher.reverse.second_entry = inner.before;
        }
    }
    if (searcher.deferred.window and searcher.suffix == null and searcher.inner == null) {
        // One literal first: its search costs less than a set's.
        if (dfa_inner.window_of(&searcher.reverse, program)) |window| {
            dfa_window.take(&searcher.forward, window, null);
        } else if (dfa_window_set.window_set_of(&searcher.reverse, program)) |found| {
            dfa_window.take(&searcher.forward, found.window, found.literals);
        }
    }
    if (searcher.deferred.length) {
        if (dfa_length.of(&searcher.forward)) |lengths| {
            searcher.len_least = lengths.least;
            searcher.len_span = lengths.most - lengths.least;
        }
    }
    searcher.deferred = .{};
    searcher.by_claim = flag(searcher);
}

/// `Searcher.by_claim` for the searcher's claims as they stand.
fn flag(searcher: *const Searcher) bool {
    const whole_text = searcher.len_span != std.math.maxInt(usize);
    return searcher.at_end or searcher.suffix != null or searcher.inner != null or whole_text or searcher.deferred.any();
}

/// Counts `len` bytes of text that a search is given toward the claims that wait, and judges
/// them once the searches were given enough.
fn count_text(searcher: *Searcher, len: usize) void {
    assert(searcher.deferred.any());
    if (len < searcher.deferred_left) {
        searcher.deferred_left -= len;
        return;
    }
    judge(searcher);
}

/// `Searcher.find` for a searcher with a claim of this file. Out of line, so that the search of
/// a searcher with none stays as small as it was before these claims.
pub noinline fn find_span(searcher: *Searcher, haystack: []const u8, from: usize) ?Span {
    var span: Span = undefined;
    // A `return` for each outcome, as in `Searcher.find`.
    switch (find(searcher, haystack, from, &span)) {
        .match => return span,
        .none => return null,
        .unknown => {},
    }
    return searcher.find_by_matcher(haystack, from);
}

/// `Searcher.find_by_dfa` for a searcher with a claim of this file, as `captures` takes it: the
/// outcome, and the match's span in `span`.
pub noinline fn find_outcome(searcher: *Searcher, haystack: []const u8, from: usize, span: *Span) Outcome {
    return find(searcher, haystack, from, span);
}

/// The match as a claim of this file finds it, written to `span`, or `unknown` where a DFA is
/// not ready or gave up. The text the search is given counts toward the claims that wait, and
/// they are judged before the search reads it. A search that covered little of a long text
/// counts it whole: a pattern of empty matches covers no byte, and reads them all.
inline fn find(searcher: *Searcher, haystack: []const u8, from: usize, span: *Span) Outcome {
    if (searcher.deferred.any()) count_text(searcher, haystack.len - from);
    return find_by_claim(searcher, haystack, from, span);
}

inline fn find_by_claim(searcher: *Searcher, haystack: []const u8, from: usize, span: *Span) Outcome {
    if (searcher.excludes(haystack.len)) return .none;
    if (!searcher.forward_ready or !searcher.reverse_ready) return .unknown;
    if (searcher.give_ups >= constants.dfa_give_ups_max) return .unknown;
    if (searcher.at_end) return find_from_end(searcher, haystack, from, span);
    if (searcher.inner != null or searcher.suffix_wide) return find_by_account(searcher, haystack, from, span);
    if (searcher.suffix) |*suffix| return find_by_suffix(searcher, suffix, haystack, from, span);
    return searcher.find_by_dfa(haystack, from, span);
}

/// `Searcher.is_match` for a searcher with a claim that goes to a place, or with one that
/// waits. Null where the searcher's forward scan answers: no claim goes to a place, or a DFA
/// gave up.
pub noinline fn is_match(searcher: *Searcher, haystack: []const u8) ?bool {
    // A searcher that holds claim R13's lengths holds no claim that this call serves, and
    // `Searcher.is_match` answers it with no call.
    assert(searcher.len_span == std.math.maxInt(usize));
    if (searcher.deferred.any()) count_text(searcher, haystack.len);
    if (!searcher.at_end and searcher.suffix == null and searcher.inner == null) return null;
    var span: Span = undefined;
    return switch (find_by_claim(searcher, haystack, 0, &span)) {
        .match => true,
        .none => false,
        .unknown => null,
    };
}

/// Claim R12. Every match ends at the text's end, and the reverse DFA reads back from there to
/// the least start of a match at or after `from`. That is the start of the match a forward
/// search finds first, since no match ends elsewhere.
inline fn find_from_end(searcher: *Searcher, haystack: []const u8, from: usize, span: *Span) Outcome {
    switch (searcher.reverse.scan_reverse(haystack, from, haystack.len)) {
        .gave_up => return searcher.gave_up(),
        .none => return .none,
        .found => |start| {
            span.* = .{ .start = start, .end = haystack.len };
            return .match;
        },
    }
}

/// Claim R4: the first match at or after `from`, found from the places of the suffix in turn.
/// At the first place from which the reverse DFA reads back to a match's start, the match ends
/// with the place's suffix (dfa_suffix.zig).
inline fn find_by_suffix(searcher: *Searcher, suffix: *const Literal, haystack: []const u8, from: usize, span: *Span) Outcome {
    var index = from;
    // Each turn goes on from one byte past the place before, so the turns are at most the bytes
    // from `from` and one.
    for (0..haystack.len - from + 1) |_| {
        const place = suffix.find(haystack, index) orelse return .none;
        const end = place + suffix.len;
        switch (searcher.reverse.scan_reverse(haystack, from, end)) {
            .none => index = place + 1,
            .gave_up => return searcher.gave_up(),
            .found => |start| {
                // A program of UTF-8 takes whole sequences, so a match starts at no
                // continuation byte.
                assert(searcher.matcher.program.encoding.may_start_at(haystack[start]));
                span.* = .{ .start = start, .end = end };
                return .match;
            },
        }
    }
    return .none;
}

/// Claim R4 under its second rule or its third: `find_by_suffix`, with the searcher's account
/// of what the places cost (searcher_account.zig). A search pays for its start and for each
/// place, and leaves the places once it has lost more than the account holds.
fn find_wide_suffix(account: *Account, reverse: *Dfa, suffix: *const Literal, haystack: []const u8, from: usize) Found {
    assert(!account.dropped);
    if (account.rest != 0) return .plain;
    var paid: usize = constants.account_place_bytes;
    var index = from;
    // Each turn goes on from one byte past the place before, so the turns are at most the bytes
    // from `from` and one.
    for (0..haystack.len - from + 1) |_| {
        const place = suffix.find(haystack, index) orelse break;
        paid += constants.account_place_bytes;
        if (account.overdrawn(place - from, paid)) {
            account.settle(0, paid);
            return .plain;
        }
        const end = place + suffix.len;
        switch (reverse.scan_reverse(haystack, from, end)) {
            .none => index = place + 1,
            .gave_up => return .gave_up,
            .found => |start| {
                account.settle(end - from, paid);
                return .{ .answer = .{ .start = start, .end = end } };
            },
        }
    }
    account.settle(haystack.len - from, paid);
    return .{ .answer = null };
}

/// The first match at or after `from` by the claim that keeps an account: claim R14, from the
/// places of its literal (searcher_inner.zig), or claim R4 under its second rule or its third.
/// The two DFAs' search answers where the claim rests or left its places. Out of line: the
/// other claims' searches stay small.
noinline fn find_by_account(searcher: *Searcher, haystack: []const u8, from: usize, span: *Span) Outcome {
    const found = if (searcher.inner) |*inner|
        searcher_inner.find(&searcher.account, &searcher.forward, &searcher.reverse, inner, haystack, from)
    else
        find_wide_suffix(&searcher.account, &searcher.reverse, &searcher.suffix.?, haystack, from);
    // The claim lost after its longest rest: the searcher takes the plain search from now on.
    if (searcher.account.dropped) {
        searcher.inner = null;
        searcher.suffix = null;
        searcher.suffix_wide = false;
        searcher.by_claim = flag(searcher);
    }
    switch (found) {
        .answer => |answer| {
            span.* = answer orelse return .none;
            return .match;
        },
        .gave_up => return searcher.gave_up(),
        .plain => {},
    }
    const outcome = searcher.find_by_dfa(haystack, from, span);
    // The text that search covered counts toward the rest: to the match's end, or to the
    // text's end where it holds no match.
    switch (outcome) {
        .match => searcher.account.pass(@as(usize, @intCast(span.end)) - from),
        .none => searcher.account.pass(haystack.len - from),
        .unknown => {},
    }
    return outcome;
}
