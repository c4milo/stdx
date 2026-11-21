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

const compiler = @import("compile.zig");
pub const compile = compiler.compile;
pub const compile_comptime = compiler.compile_comptime;
pub const Options = compiler.Options;
pub const Flags = @import("syntax_atom.zig").Flags;

const matcher = @import("matcher.zig");
pub const Matcher = matcher.Matcher;
pub const MatcherOptions = matcher.Options;
pub const Captures = matcher.Captures;
pub const Piece = matcher.Piece;
pub const Status = matcher.Status;
pub const Step = matcher.Step;
pub const Span = matcher.Span;

const searcher = @import("searcher.zig");
pub const Searcher = searcher.Searcher;
pub const Matches = searcher.Matches;

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
    _ = @import("dfa.zig");
    _ = searcher;
    _ = @import("generate_test.zig");
    _ = @import("fuzz_test.zig");
    _ = @import("matcher_work_test.zig");
    _ = @import("fragment.zig");
    _ = @import("repeat.zig");
    _ = @import("utf8_ranges.zig");
    _ = @import("utf8_vectors_test.zig");
    _ = @import("scalar_set.zig");
    _ = @import("octet_classes.zig");
    _ = @import("syntax.zig");
    _ = @import("syntax_atom.zig");
    _ = @import("syntax_class.zig");
    _ = @import("syntax_escape.zig");
    _ = @import("syntax_posix.zig");
}
