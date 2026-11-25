//! regex: regular expressions that match in time linear in the text, in memory the caller gives
//! (decision 86, design §3).
//!
//! `compile` reads a pattern into a `Program`: RFC 9485's grammar, with the anchors, the capture
//! groups, the lazy quantifiers and the flags of RE2's syntax, and none of the forms that need a
//! backtracking matcher. A program holds no pointer but the caller's storage, and any number of
//! matchers read it at once.

pub const constants = @import("constants.zig");

const program = @import("program.zig");
pub const Program = program.Program;
pub const Instruction = program.Instruction;
pub const Kind = program.Kind;
pub const Look = program.Look;
pub const Context = program.Context;
pub const Encoding = program.Encoding;

const compiler = @import("compile.zig");
pub const compile = compiler.compile;
pub const compile_comptime = compiler.compile_comptime;
pub const Options = compiler.Options;
pub const Flags = @import("syntax/syntax_atom.zig").Flags;

const matcher = @import("matcher.zig");
pub const Matcher = matcher.Matcher;
pub const MatcherOptions = matcher.Options;
pub const Captures = matcher.Captures;
pub const Piece = matcher.Piece;
pub const Status = matcher.Status;
pub const Step = matcher.Step;
pub const Span = matcher.Span;

const searcher = @import("searcher/searcher.zig");
pub const GroupName = program.GroupName;
pub const Searcher = searcher.Searcher;
pub const SearcherClaims = searcher.Claims;
pub const SearcherOptions = searcher.Options;
pub const Matches = searcher.Matches;
pub const SearcherGroups = searcher.Groups;

const errors = @import("errors.zig");
pub const Error = errors.Error;
pub const Corrupt = errors.Corrupt;
pub const Unsupported = errors.Unsupported;
pub const refusal = errors.refusal;

test {
    _ = constants;
    _ = program;
    _ = compiler;
    _ = errors;
    _ = matcher;
    _ = @import("sparse_set.zig");
    _ = @import("dfa/dfa.zig");
    _ = @import("dfa/dfa_record.zig");
    _ = @import("literal.zig");
    _ = @import("literal_common.zig");
    _ = @import("literal_set.zig");
    _ = @import("literal_set_paths.zig");
    _ = @import("literal_set_fingerprint.zig");
    _ = @import("literal_rank.zig");
    _ = @import("literal_teddy.zig");
    _ = @import("lane_places.zig");
    _ = @import("literal_compare.zig");
    _ = @import("literal_set_lanes.zig");
    _ = @import("one_pass.zig");
    _ = @import("one_pass_table.zig");
    _ = @import("backtrack.zig");
    _ = @import("literal_trie.zig");
    _ = @import("dfa/dfa_literal.zig");
    _ = @import("dfa/dfa_reverse.zig");
    _ = @import("dfa/dfa_run.zig");
    _ = searcher;
    _ = @import("generate_test.zig");
    _ = @import("fuzz_test.zig");
    _ = @import("matcher_work_test.zig");
    _ = @import("fragment.zig");
    _ = @import("repeat.zig");
    _ = @import("utf8_ranges.zig");
    _ = @import("utf8_vectors_test.zig");
    _ = @import("matcher_vectors_test.zig");
    _ = @import("scalar_set.zig");
    _ = @import("octet_classes.zig");
    _ = @import("syntax/syntax.zig");
    _ = @import("syntax/syntax_atom.zig");
    _ = @import("syntax/syntax_atom_utf8.zig");
    _ = @import("syntax/syntax_atom_utf8_node.zig");
    _ = @import("syntax/syntax_atom_ranges.zig");
    _ = @import("syntax/syntax_class.zig");
    _ = @import("syntax/syntax_escape.zig");
    _ = @import("syntax/syntax_posix.zig");
    _ = @import("syntax/syntax_property.zig");
}
