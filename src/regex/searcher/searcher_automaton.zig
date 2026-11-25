//! Claim R15 in the searcher: where the DFAs cannot answer a trie's search, the automaton of Aho
//! and Corasick answers it in their cache's words, in the matcher's place (aho_corasick.zig).
//!
//! The DFAs cannot answer where one did not start, as a dictionary's reverse DFA does not in the
//! default cache, or once they gave up for good. The searcher then builds the automaton, at most
//! once. Its words were the DFAs', so it turns both DFAs off for good.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const matcher_file = @import("../matcher.zig");
const Span = matcher_file.Span;
const searcher_file = @import("searcher.zig");
const Searcher = searcher_file.Searcher;
const Outcome = searcher_file.Outcome;
const aho_corasick_build = @import("../aho_corasick_build.zig");

/// True where the automaton answers the searcher's search, which the DFAs cannot answer. It
/// builds the automaton the first time, where the claim is on and no claim waits: a claim that
/// waits judges itself with the DFAs' lists, which the automaton's words hold once it is built.
pub fn ready(searcher: *Searcher) bool {
    switch (searcher.trie.state) {
        .ready => return true,
        .refused => return false,
        .waiting => {
            // A DFA gave up once and may answer the next search: the matcher answers this one.
            if (searcher.forward_ready and searcher.reverse_ready and searcher.give_ups < constants.dfa_give_ups_max) return false;
            if (searcher.deferred.any()) return false;
            if (!searcher.claims_automaton or !aho_corasick_build.build(&searcher.trie, &searcher.matcher.program)) {
                searcher.trie.state = .refused;
                return false;
            }
            searcher.trie.state = .ready;
            searcher.forward_ready = false;
            searcher.reverse_ready = false;
            searcher.give_ups = constants.dfa_give_ups_max;
            return true;
        },
    }
}

/// `Searcher.find_by_dfa` where the DFAs cannot answer: the automaton's answer where it has one,
/// and `unknown` where the matcher answers.
pub noinline fn find_outcome(searcher: *Searcher, haystack: []const u8, from: usize, span: *Span) Outcome {
    if (!ready(searcher)) return .unknown;
    span.* = searcher.trie.find(haystack, from) orelse return .none;
    return .match;
}
