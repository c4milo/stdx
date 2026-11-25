//! `matcher_replay <vector file>`: the Lean model of the matcher, held to `Matcher.find` and to
//! `Searcher.find` on programs a seed draws (decision 86, design §8 part 22h).
//!
//! A vector file holds programs, texts and the answer that
//! spec/lean/Stdx/Regex/MatcherAnswer.lean proves for each search. It comes from one of two
//! places, and `tools/matcher_model_check.sh` runs both with a new seed:
//!
//! - `lake exe vectors --random <seed> <count>` draws programs as instructions. This program
//!   builds each one and requires `Matcher.find` to give the answer.
//! - `matcher_replay dump <seed> <count> <file>` writes the programs `compile` gives the
//!   patterns a seed draws (matcher_replay_dump.zig), and `lake exe vectors --answers <file>`
//!   answers each search. This program compiles each pattern again, requires the program the
//!   file lists, and requires the answer of `Matcher.find` and of four searchers: one with
//!   every claim, one with none, one with every claim that read a long text first, and one
//!   with every claim and the least cache its DFAs start with. A search from 0 also holds
//!   each searcher's `is_match`. A `claim` line holds the literal that a searcher took for
//!   claim R4 or claim R14, and the Lean side judged the rule it names: the first searcher
//!   must hold a literal of claim R4's first rule, and the third searcher, after its long
//!   text, a literal of any rule (matcher_replay/matcher_replay_claim.zig). A line that
//!   begins `differs` says a check of the Lean side failed, and fails the replay.
//!
//! It exits 1 at the first line that fails, and names the line.
//! src/regex/matcher_vectors_test.zig replays the committed file of one seed as a unit test.
const std = @import("std");
const regex = @import("regex");
const platform = @import("platform");
const replay_dump = @import("matcher_replay/matcher_replay_dump.zig");
const matcher_replay_claim = @import("matcher_replay/matcher_replay_claim.zig");
const Claim = matcher_replay_claim.Claim;
const Instruction = regex.Instruction;
const Matcher = regex.Matcher;
const Searcher = regex.Searcher;

const radix = 10;
const hexadecimal = 16;

/// The longest pattern a file names (tools/differential/regex_generate.zig).
const pattern_len_max = 2048;

/// The slots of the whole match, which is all a replay of instructions reads.
const span_slots = 2;

/// The searchers a compiled pattern's searches run: one with every claim, one with none, one
/// with every claim that read `long_read_len` bytes before its first search, and one with
/// every claim and a small cache.
pub const searcher_count = 4;

/// The searcher with a small cache. Its cache holds the least words, of the powers of two
/// from `small_cache_shift_min`, at which both its DFAs start. Such a cache fills on a long
/// text, the DFA clears it, and a DFA that clears it too often gives up, so the searcher
/// runs the matcher.
pub const small_cache_searcher = 3;
const small_cache_shift_min = 4;
const small_cache_shift_max = std.math.log2_int(usize, regex.constants.cache_words_default);

/// The searcher that reads a long text first. A searcher keeps state from one search to the
/// next: its DFAs' caches, and what a claim learned of the texts. So an answer is held for a
/// new searcher and for one that is not new.
pub const long_read_searcher = 2;

/// The bytes of that text: `claim_text_per_instruction` for each instruction a program may
/// hold. A searcher judges some of its claims only after its searches were given that many
/// bytes for each instruction of its reverse program (decision 86, the claims that wait). So
/// the third searcher has judged each claim after this text.
pub const long_read_len = regex.constants.claim_text_per_instruction * replay_dump.instructions_max;

/// What the long text repeats where the case's text is empty.
const long_read_filler = "ab c\n";

const Tokens = std.mem.TokenIterator(u8, .scalar);

fn take(tokens: *Tokens) ![]const u8 {
    return tokens.next() orelse error.VectorShort;
}

fn number(comptime T: type, tokens: *Tokens) !T {
    return std.fmt.parseInt(T, try take(tokens), radix);
}

/// One instruction of a file: its kind was read, and its fields follow in the order
/// `Vectors.lean` writes them.
fn instruction_of(kind: regex.Kind, tokens: *Tokens) !Instruction {
    var instruction: Instruction = .{ .kind = kind };
    switch (kind) {
        .range => {
            instruction.lo = try number(u8, tokens);
            instruction.hi = try number(u8, tokens);
            instruction.out = try number(u32, tokens);
        },
        .ranges => instruction.arg = try number(u32, tokens),
        .split => {
            instruction.out = try number(u32, tokens);
            instruction.arg = try number(u32, tokens);
        },
        .save => {
            instruction.arg = try number(u32, tokens);
            instruction.out = try number(u32, tokens);
        },
        .look => {
            instruction.look = std.meta.stringToEnum(regex.Look, try take(tokens)) orelse return error.VectorLook;
            instruction.out = try number(u32, tokens);
        },
        .jump => instruction.out = try number(u32, tokens),
        .match, .fail => {},
    }
    return instruction;
}

/// Every claim of a searcher turned off: the DFAs and the matcher alone.
pub fn no_claims() regex.SearcherClaims {
    var claims: regex.SearcherClaims = .{};
    inline for (std.meta.fields(regex.SearcherClaims)) |field| @field(claims, field.name) = false;
    return claims;
}

/// The span a `find` line names, or null for `none`.
const Expected = ?struct { start: u64, end: u64 };

pub fn same(found: ?regex.Span, expected: Expected) bool {
    const span = found orelse return expected == null;
    const wanted = expected orelse return false;
    return span.start == wanted.start and span.end == wanted.end;
}

/// A file's programs and their searches, taken one line at a time. A replay stays where it is:
/// its searchers point at its program.
pub const Replay = struct {
    /// The instructions of the program's lines, and how many its `program` line names.
    listed: []Instruction,
    listed_len: u32 = 0,
    listed_named: u32 = 0,
    encoding: regex.Encoding = .utf8,
    forward: u32 = 0,
    reverse: u32 = replay_dump.no_entry,
    /// The pattern a `pattern` line named for the program that follows it.
    pattern: [pattern_len_max]u8 = undefined,
    pattern_len: usize = 0,
    pattern_pending: bool = false,
    /// Whether the program's lines came from a pattern, which the replay compiles again.
    compiled: bool = false,
    /// Whether the matcher and the searchers hold the program of the lines read.
    ready: bool = false,
    storage: []Instruction,
    program: regex.Program = undefined,
    text: [replay_dump.long_text_len_max]u8 = undefined,
    text_len: usize = 0,
    matcher: Matcher = undefined,
    matcher_memory: []u64,
    searchers: [searcher_count]Searcher = undefined,
    searcher_memory: [searcher_count][]u64,
    /// The text the third searcher reads before its first search: the case's text, repeated.
    long_text: []u8,
    features: platform.CpuFeatures,
    programs: usize = 0,
    patterns: usize = 0,
    finds: usize = 0,
    searcher_finds: usize = 0,
    long_reads: usize = 0,
    is_matches: usize = 0,
    /// The program's `claim` line: its literal, its rule and, for claim R14, the instruction
    /// where the reverse program stands after the literal. Then the lines of the file so far.
    claim: [regex.constants.literal_len_max]u8 = undefined,
    claim_len: ?usize = null,
    claim_rule: matcher_replay_claim.Rule = .first,
    claim_before: u32 = 0,
    claims: usize = 0,
    /// The searches that the searcher which read a long text ran from the places of claim
    /// R14's literal: it held the literal, and its account was not at rest.
    finds_by_inner: usize = 0,
    /// The words of the small cache that the fourth searcher's DFAs started with.
    small_cache_words: usize = 0,
    /// The searches that the searcher with a small cache answered after a DFA of its cleared
    /// its cache, and after one gave up.
    finds_after_clear: usize = 0,
    finds_after_give_up: usize = 0,

    pub fn init(arena: std.mem.Allocator) !Replay {
        const count = replay_dump.instructions_max;
        var replay: Replay = .{
            .listed = try arena.alloc(Instruction, count),
            .storage = try arena.alloc(Instruction, count),
            .matcher_memory = try arena.alloc(u64, Matcher.memory_len(count, replay_dump.slots_max)),
            .searcher_memory = undefined,
            .long_text = try arena.alloc(u8, long_read_len),
            .features = platform.CpuFeatures.detect(),
        };
        const words = Searcher.memory_len(count, replay_dump.slots_max, regex.constants.cache_words_default);
        for (&replay.searcher_memory) |*memory| memory.* = try arena.alloc(u64, words);
        return replay;
    }

    fn feed(replay: *Replay, line: []const u8) !void {
        var tokens = std.mem.tokenizeScalar(u8, line, ' ');
        const word = try take(&tokens);
        if (std.mem.eql(u8, word, "pattern")) return replay.set_pattern(try take(&tokens));
        if (std.mem.eql(u8, word, "program")) return replay.begin(&tokens);
        if (std.mem.eql(u8, word, "claim")) return replay.set_claim(&tokens);
        if (std.mem.eql(u8, word, "text")) return replay.set_text(&tokens);
        if (std.mem.eql(u8, word, "find")) return replay.expect_find(&tokens);
        if (std.mem.eql(u8, word, "differs")) return error.ModelCheckFailed;
        const kind = std.meta.stringToEnum(regex.Kind, word) orelse return error.VectorWord;
        if (replay.listed_len == replay.listed.len) return error.VectorProgramLong;
        replay.listed[replay.listed_len] = try instruction_of(kind, &tokens);
        replay.listed_len += 1;
    }

    /// A pattern's bytes from two hexadecimal digits each, or from `-` for the empty pattern.
    fn set_pattern(replay: *Replay, digits: []const u8) !void {
        const pattern = if (std.mem.eql(u8, digits, "-")) "" else digits;
        if (pattern.len % 2 != 0 or pattern.len / 2 > pattern_len_max) return error.VectorPattern;
        replay.pattern_len = pattern.len / 2;
        for (replay.pattern[0..replay.pattern_len], 0..) |*byte, index| {
            byte.* = try std.fmt.parseInt(u8, pattern[2 * index ..][0..2], hexadecimal);
        }
        replay.pattern_pending = true;
        replay.patterns += 1;
    }

    fn begin(replay: *Replay, tokens: *Tokens) !void {
        replay.encoding = std.meta.stringToEnum(regex.Encoding, try take(tokens)) orelse return error.VectorEncoding;
        replay.listed_named = try number(u32, tokens);
        replay.forward = try number(u32, tokens);
        const reverse = try take(tokens);
        replay.reverse = if (std.mem.eql(u8, reverse, "none")) replay_dump.no_entry else try std.fmt.parseInt(u32, reverse, radix);
        replay.compiled = replay.pattern_pending;
        replay.pattern_pending = false;
        replay.ready = false;
        replay.listed_len = 0;
        replay.claim_len = null;
        replay.programs += 1;
    }

    /// A `claim` line: the literal that a searcher took for the program, under the word of the
    /// rule it took it by. The Lean side judged that rule for the literal.
    fn set_claim(replay: *Replay, tokens: *Tokens) !void {
        replay.claim_rule = matcher_replay_claim.Rule.of_word(try take(tokens)) orelse return error.VectorClaim;
        replay.claim_before = if (replay.claim_rule == .inner) try number(u32, tokens) else 0;
        const len = try number(usize, tokens);
        if (len == 0 or len > replay.claim.len) return error.VectorClaim;
        for (replay.claim[0..len]) |*byte| byte.* = try number(u8, tokens);
        replay.claim_len = len;
        replay.claims += 1;
    }

    /// The claim of the file's `claim` line, where the searcher at this point must hold it: a
    /// new searcher holds a literal of claim R4's first rule alone, and a searcher that read
    /// the long text holds a literal of any rule.
    fn claimed(replay: *const Replay, judged: bool) ?Claim {
        const len = replay.claim_len orelse return null;
        if (!judged and replay.claim_rule != .first) return null;
        return .{ .rule = replay.claim_rule, .literal = replay.claim[0..len], .before = replay.claim_before };
    }

    /// Requires a searcher to hold the claim that the file names at this point, and none where
    /// the file names none: the literal, its rule and, for claim R14, the reverse DFA's second
    /// entry. So what the Lean side judged is what this build's searcher takes.
    fn expect_claim(replay: *const Replay, searcher: *const Searcher, judged: bool) !void {
        const named = replay.claimed(judged);
        const held = matcher_replay_claim.held(searcher) orelse return if (named == null) {} else error.ClaimDiffers;
        if (!held.same(named orelse return error.ClaimDiffers)) return error.ClaimDiffers;
    }

    /// The program the listed instructions make: a forward program alone, whose one group is
    /// the whole match. Only the matcher runs it: a DFA needs the classes `compile` finds.
    fn listed_program(replay: *const Replay) regex.Program {
        return .{
            .instructions = replay.listed[0..replay.listed_len],
            .forward_len = replay.listed_len,
            .forward_nodes = replay.listed_len,
            .reverse_nodes = 0,
            .forward = replay.forward,
            .reverse = replay_dump.no_entry,
            .group_count = 1,
            .reads_ahead = true,
            .has_looks = true,
            .encoding = replay.encoding,
            .classes = @splat(0),
            .class_count = 1,
            .names = &.{},
        };
    }

    /// Compiles the pattern again, and requires the program the file lists: the proved answers
    /// are answers of those lines.
    fn compile_listed(replay: *Replay) !void {
        const pattern = replay.pattern[0..replay.pattern_len];
        replay.program = regex.compile(pattern, .{ .encoding = replay.encoding }, replay.storage) catch return error.PatternRefused;
        const program = &replay.program;
        if (program.forward != replay.forward or program.reverse != replay.reverse) return error.ProgramDiffers;
        if (program.instructions.len != replay.listed_len) return error.ProgramDiffers;
        for (program.instructions, replay.listed[0..replay.listed_len]) |made, listed| {
            var made_line: [replay_dump.line_len_max]u8 = undefined;
            var listed_line: [replay_dump.line_len_max]u8 = undefined;
            if (!std.mem.eql(u8, try replay_dump.line_of(&made_line, made), try replay_dump.line_of(&listed_line, listed))) return error.ProgramDiffers;
        }
    }

    /// Readies the matcher, and for a compiled pattern the searchers, for the lines read.
    fn make_ready(replay: *Replay) !void {
        if (replay.listed_len != replay.listed_named or replay.forward >= replay.listed_len) return error.VectorProgram;
        replay.ready = true;
        if (!replay.compiled) {
            replay.program = replay.listed_program();
            return replay.matcher.init(&replay.program, .{ .captures = .span }, replay.matcher_memory);
        }
        try replay.compile_listed();
        const program = &replay.program;
        if (program.slot_count() > replay_dump.slots_max) return error.VectorProgramLong;
        replay.matcher.init(program, .{ .captures = .span }, replay.matcher_memory);
        const claims = [searcher_count]regex.SearcherClaims{ .{}, no_claims(), .{}, .{} };
        const words = Searcher.memory_len(program.forward_len, program.slot_count(), regex.constants.cache_words_default);
        for (&replay.searchers, replay.searcher_memory, claims) |*searcher, memory, claim| {
            searcher.init(program, &.{ .features = replay.features, .claims = claim }, memory[0..words]);
        }
        try replay.expect_claim(&replay.searchers[0], false);
        replay.read_long_text();
        try replay.expect_claim(&replay.searchers[long_read_searcher], true);
        replay.shrink_cache();
    }

    /// Readies the fourth searcher again with the least cache at which both its DFAs start.
    fn shrink_cache(replay: *Replay) void {
        const program = &replay.program;
        const searcher = &replay.searchers[small_cache_searcher];
        const memory = replay.searcher_memory[small_cache_searcher];
        for (small_cache_shift_min..small_cache_shift_max + 1) |shift| {
            replay.small_cache_words = @as(usize, 1) << @intCast(shift);
            const words = Searcher.memory_len(program.forward_len, program.slot_count(), replay.small_cache_words);
            searcher.init(program, &.{ .features = replay.features }, memory[0..words]);
            if (searcher.forward_ready and searcher.reverse_ready) return;
        }
    }

    /// Has the third searcher read the case's text, repeated to `long_read_len` bytes: once for
    /// `is_match` and once for `find`. No proved answer holds these two.
    fn read_long_text(replay: *Replay) void {
        const text: []const u8 = if (replay.text_len == 0) long_read_filler else replay.text[0..replay.text_len];
        for (replay.long_text, 0..) |*byte, index| byte.* = text[index % text.len];
        const searcher = &replay.searchers[long_read_searcher];
        _ = searcher.is_match(replay.long_text);
        _ = searcher.find(replay.long_text, 0);
        replay.long_reads += 1;
    }

    fn set_text(replay: *Replay, tokens: *Tokens) !void {
        replay.text_len = try number(usize, tokens);
        if (replay.text_len > replay.text.len) return error.VectorTextLong;
        for (replay.text[0..replay.text_len]) |*byte| byte.* = try number(u8, tokens);
        if (!replay.ready) try replay.make_ready();
    }

    fn expect_find(replay: *Replay, tokens: *Tokens) !void {
        if (!replay.ready) return error.VectorOrder;
        const low = try number(usize, tokens);
        if (low > replay.text_len) return error.VectorOffset;
        const first = try take(tokens);
        const expected: Expected = if (std.mem.eql(u8, first, "none")) null else .{
            .start = try std.fmt.parseInt(u64, first, radix),
            .end = try number(u64, tokens),
        };
        const text = replay.text[0..replay.text_len];
        replay.finds += 1;
        try expect_matcher(replay.matcher.find(text, low), expected);
        if (!replay.compiled) return;
        const causes = [searcher_count]anyerror{ error.SearcherDiffers, error.SearcherWithNoClaimDiffers, error.SearcherAfterLongReadDiffers, error.SearcherWithSmallCacheDiffers };
        const long_read = &replay.searchers[long_read_searcher];
        replay.finds_by_inner += @intFromBool(long_read.inner != null and long_read.account.rest == 0);
        for (&replay.searchers, causes) |*searcher, cause| {
            replay.searcher_finds += 1;
            if (!same(searcher.find(text, low), expected)) return cause;
        }
        const small = &replay.searchers[small_cache_searcher];
        const cleared = small.forward_ready and small.reverse_ready and small.forward.cache.clears + small.reverse.cache.clears > 0;
        replay.finds_after_clear += @intFromBool(cleared);
        replay.finds_after_give_up += @intFromBool(small.give_ups > 0);
        // A text holds a match exactly where a search from its start finds one.
        if (low != 0) return;
        for (&replay.searchers) |*searcher| {
            replay.is_matches += 1;
            if (searcher.is_match(text) != (expected != null)) return error.IsMatchDiffers;
        }
    }
};

/// What the matcher gave against the proved answer, each difference with a cause of its own.
fn expect_matcher(found: ?regex.Span, expected: Expected) !void {
    const wanted = expected orelse return if (found == null) {} else error.MatchUnexpected;
    const span = found orelse return error.MatchMissing;
    if (span.start != wanted.start) return error.StartDiffers;
    if (span.end != wanted.end) return error.EndDiffers;
}

const Failure = struct { number: usize, line: []const u8, cause: anyerror };

/// Replays every line of a file's text. Gives the line that failed, with its number, or null.
pub fn replay_text(replay: *Replay, text: []const u8) ?Failure {
    var lines = std.mem.tokenizeScalar(u8, text, '\n');
    var line_number: usize = 0;
    while (lines.next()) |line| {
        line_number += 1;
        if (line[0] == '#') continue;
        replay.feed(line) catch |cause| return .{ .number = line_number, .line = line, .cause = cause };
    }
    return null;
}

fn usage() noreturn {
    std.debug.print("usage: matcher_replay <vector file> | matcher_replay dump <seed> <count> <file>\n", .{});
    std.process.exit(2);
}

/// `matcher_replay dump <seed> <count> <file>`.
fn write_dump(init: std.process.Init, arena: std.mem.Allocator, args: []const []const u8) !void {
    const seed = std.fmt.parseInt(u64, args[0], radix) catch usage();
    const count = std.fmt.parseInt(usize, args[1], radix) catch usage();
    const text = try replay_dump.dump(arena, seed, count);
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = text });
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    const dump_arguments = 5;
    if (args.len == dump_arguments and std.mem.eql(u8, args[1], "dump")) return write_dump(init, arena, args[2..]);
    if (args.len != 2) usage();
    const text = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], arena, .unlimited);
    var replay = try Replay.init(arena);
    if (replay_text(&replay, text)) |failed| {
        std.debug.print("matcher_replay: {s}, line {d}: `{s}`: {s}\n", .{ args[1], failed.number, failed.line, @errorName(failed.cause) });
        if (replay.compiled) std.debug.print("matcher_replay: the pattern is \"{f}\", read as {s}\n", .{ std.zig.fmtString(replay.pattern[0..replay.pattern_len]), @tagName(replay.encoding) });
        std.process.exit(1);
    }
    std.debug.print("matcher_replay: {d} programs, {d} of them compiled from a pattern, {d} searches, each the proved answer; with a small cache, {d} after a DFA cleared it and {d} after one gave up; {d} from the places of claim R14's literal\n", .{ replay.programs, replay.patterns, replay.finds, replay.finds_after_clear, replay.finds_after_give_up, replay.finds_by_inner });
}

test {
    _ = @import("matcher_replay/matcher_replay_test.zig");
    _ = replay_dump;
    _ = matcher_replay_claim;
}
