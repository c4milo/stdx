//! What a benchmark's row codes (decision 45).
//!
//! A row's input is a corpus file taken whole, or, for a small HTTP body, the slices of its 1 MiB
//! payload: a file named `<kind>-1k` or `<kind>-16k` is timed as the slices of its length of
//! `<kind>-1m`. One repetition of a row codes every part of its input once, in order, each as a
//! stream of its own from a state started anew. A CPU's branch predictor learns one small file
//! that a row repeats; it meets each slice once a round, and learns none.
//!
//! - `of` gives the rows' inputs for the corpus files a program was given.
//! - `Rotation` is a candidate over an input, as the timing takes it; `operation` places one.
//! - `streams` encodes one stream a part, for the decoders; `expect_decodes` checks a decoder
//!   over them, and `decoder_operation` checks one and places it.
//! - `note` prints what a table's rows are, beneath its heading; `note_text` prints the same
//!   within a paragraph the caller writes.

const std = @import("std");
const timing = @import("timing.zig");

/// A corpus file, by the name the build gives it.
pub const File = struct {
    name: []const u8,
    octets: []const u8,
};

/// What the name of a payload ends with, and what the names of its small bodies end with: the
/// pieces tools/corpus/cut.zig cuts (decision 15).
const payload_suffix = "-1m";
const small_suffixes = [_][]const u8{ "-1k", "-16k" };

/// A table marks a file that a row takes whole and repeats as one the branch predictor learns
/// when the file holds this many octets or fewer (decision 45). The learning shrinks with length
/// and has no edge: in rotation, slices of 64 KiB decode at 0.57 to 0.97 of their repeated speed,
/// slices of 256 KiB at 0.75 to 0.99, and slices of 1 MiB at 0.98 or more. The corpus holds no
/// file between 152 and 427 KiB.
pub const learned_len_max = 256 * 1024;

/// One row's input: the parts a candidate codes one at a time.
pub const Input = struct {
    /// The row's name in a table: the file's, followed by `x` and the count of slices when the
    /// parts are slices.
    name: []const u8,
    /// One part for a file taken whole; for a small body, the slices of its payload, in the
    /// payload's order. Every part holds `part_len` octets.
    parts: []const []const u8,
    part_len: usize,

    /// The octets of every part together, which throughput counts.
    pub fn len(self: Input) usize {
        return self.parts.len * self.part_len;
    }

    /// Whether the row repeats one file that a table marks as learned by the branch predictor.
    pub fn is_learned(self: Input) bool {
        return self.parts.len == 1 and self.part_len <= learned_len_max;
    }
};

/// The rows' inputs for `files`, in the files' order: a small body becomes the slices of its
/// payload, and every other file is taken whole.
pub fn of(arena: std.mem.Allocator, files: []const File) ![]const Input {
    const inputs = try arena.alloc(Input, files.len);
    for (files, inputs) |file, *input| {
        input.* = if (payload_of(files, file)) |payload| try sliced(arena, file, payload) else try whole(arena, file);
    }
    return inputs;
}

/// The payload among `files` that `file` is a small body of: the file whose name is `file`'s with
/// `payload_suffix` in place of a small suffix. Null for any other file, and for a small body
/// given without its payload, which is then taken whole.
fn payload_of(files: []const File, file: File) ?File {
    for (small_suffixes) |suffix| {
        if (!std.mem.endsWith(u8, file.name, suffix)) continue;
        const stem = file.name[0 .. file.name.len - suffix.len];
        for (files) |other| {
            if (other.name.len != stem.len + payload_suffix.len) continue;
            if (std.mem.startsWith(u8, other.name, stem) and std.mem.endsWith(u8, other.name, payload_suffix)) return other;
        }
    }
    return null;
}

fn whole(arena: std.mem.Allocator, file: File) !Input {
    const parts = try arena.alloc([]const u8, 1);
    parts[0] = file.octets;
    return .{ .name = file.name, .parts = parts, .part_len = file.octets.len };
}

/// `payload` cut into slices of `small`'s length. The small body must be the payload's first
/// slice, as tools/corpus/cut.zig cuts it, and the payload must hold a whole number of slices.
fn sliced(arena: std.mem.Allocator, small: File, payload: File) !Input {
    const slice_len = small.octets.len;
    if (slice_len == 0 or payload.octets.len % slice_len != 0) return error.PayloadIsNotWholeSlices;
    if (!std.mem.startsWith(u8, payload.octets, small.octets)) return error.SmallBodyIsNotItsPayloadsStart;
    const parts = try arena.alloc([]const u8, payload.octets.len / slice_len);
    for (parts, 0..) |*part, index| part.* = payload.octets[index * slice_len ..][0..slice_len];
    const name = try std.fmt.allocPrint(arena, "{s}x{d}", .{ small.name, parts.len });
    return .{ .name = name, .parts = parts, .part_len = slice_len };
}

/// The octets `parts` hold together.
pub fn total_len(parts: []const []const u8) usize {
    var total: usize = 0;
    for (parts) |part| total += part.len;
    return total;
}

/// A candidate over a row's input. One repetition has the candidate code every one of `inputs`
/// once, in order: the input's parts for an encoder, each part's stream for a decoder.
///
/// `Candidate.run(self, input)` is one coding from a state started anew; it returns the octets it
/// wrote, or null when it failed. Each call is out of line: every candidate, stdx's and a
/// baseline's alike, pays one call a part, and LLVM compiles a candidate's codec the same whether
/// or not the check before the timing calls `run` too.
pub fn Rotation(comptime Candidate: type) type {
    return struct {
        const Self = @This();

        candidate: Candidate,
        inputs: []const []const u8,

        pub fn run_once(context: *const anyopaque) void {
            const self: *const Self = @ptrCast(@alignCast(context));
            for (self.inputs) |input| {
                const written = @call(.never_inline, Candidate.run, .{ &self.candidate, input });
                std.debug.assert(written != null);
            }
        }
    };
}

/// `candidate` placed over `inputs`, for `timing.time_interleaved`.
pub fn operation(arena: std.mem.Allocator, candidate: anytype, inputs: []const []const u8) !timing.Operation {
    const Placed = Rotation(@TypeOf(candidate));
    const placed = try arena.create(Placed);
    placed.* = .{ .candidate = candidate, .inputs = inputs };
    return .{ .context = placed, .run_once = Placed.run_once };
}

/// One stream a part of `input`, each encoded once by `encoder`, whose `bound(part_len)` is the
/// most octets a part's stream takes and whose `encode(part, room)` returns the octets it wrote,
/// or null. The streams lie one after another in storage of their own.
pub fn streams(arena: std.mem.Allocator, input: Input, encoder: anytype) ![]const []const u8 {
    const bound = encoder.bound(input.part_len);
    const storage = try arena.alloc(u8, bound * input.parts.len);
    const result = try arena.alloc([]const u8, input.parts.len);
    var used: usize = 0;
    for (input.parts, result) |part, *stream| {
        const written = encoder.encode(part, storage[used..][0..bound]) orelse return error.EncodeFailed;
        stream.* = storage[used..][0..written];
        used += written;
    }
    return result;
}

/// `coded` octets as a percentage of `input`'s: the compression a row is coded at.
pub fn compressed_percent(coded: usize, input: Input) f64 {
    return 100 * @as(f64, @floatFromInt(coded)) / @as(f64, @floatFromInt(input.len()));
}

/// Requires `decoder` to decode each of `coded` to the matching part of `input`, into its
/// `output`: every decoder's check before any is timed.
pub fn expect_decodes(decoder: anytype, coded: []const []const u8, input: Input) !void {
    std.debug.assert(coded.len == input.parts.len);
    for (coded, input.parts) |stream, part| {
        const written = decoder.run(stream) orelse return error.CandidateFailed;
        if (!std.mem.eql(u8, part, decoder.output[0..written])) return error.CandidatesDisagree;
    }
}

/// `decoder` checked over `coded` against `input`, then placed for timing.
pub fn decoder_operation(arena: std.mem.Allocator, decoder: anytype, coded: []const []const u8, input: Input) !timing.Operation {
    try expect_decodes(decoder, coded, input);
    return operation(arena, decoder, coded);
}

/// Prints, beneath a table's heading, what the table's rows are, as a paragraph of its own:
/// `note_text`, or nothing when it says nothing.
pub fn note(out: *std.Io.Writer, inputs: []const Input) !void {
    const noted = Noted.of(inputs);
    if (noted.slices == 0 and noted.learned == 0) return;
    try note_text(out, inputs);
    try out.print("\n\n", .{});
}

/// How many of a table's rows the note speaks of: those of slices, and those that repeat one
/// file the branch predictor learns.
const Noted = struct {
    slices: usize = 0,
    learned: usize = 0,

    fn of(inputs: []const Input) Noted {
        var noted: Noted = .{};
        for (inputs) |input| {
            if (input.parts.len > 1) noted.slices += 1;
            if (input.is_learned()) noted.learned += 1;
        }
        return noted;
    }
};

/// Prints what a table's rows are: which code slices in rotation, and which repeat one file of
/// `learned_len_max` octets or less. Prints nothing when `inputs` hold neither.
pub fn note_text(out: *std.Io.Writer, inputs: []const Input) !void {
    const noted = Noted.of(inputs);
    if (noted.slices != 0) {
        try out.print("A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45).", .{});
    }
    if (noted.learned == 0) return;
    try out.print("{s}A row that repeats one file of {d} KiB or less measures an input the branch predictor has learned, the shorter the file the more:", .{ if (noted.slices != 0) " " else "", learned_len_max / 1024 });
    var named: usize = 0;
    for (inputs) |input| {
        if (!input.is_learned()) continue;
        try out.print("{s} {s}", .{ if (named == 0) "" else ",", input.name });
        named += 1;
    }
    try out.print(".", .{});
}

// Tests.

const testing = std.testing;

/// `len` octets of which no two slices are alike.
fn test_octets(comptime len: usize) [len]u8 {
    var octets: [len]u8 = undefined;
    for (&octets, 0..) |*octet, index| octet.* = @truncate(index *% 2654435761 >> 7);
    return octets;
}

test "a small body becomes the slices of its payload, and every other file is taken whole" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const payload = test_octets(64);
    const files = [_]File{
        .{ .name = "text/alice", .octets = "alice" },
        .{ .name = "http/html-1k", .octets = payload[0..4] },
        .{ .name = "http/html-16k", .octets = payload[0..16] },
        .{ .name = "http/html-1m", .octets = &payload },
        .{ .name = "http/json-1k", .octets = "json" },
    };
    const inputs = try of(arena_state.allocator(), &files);
    try testing.expectEqual(files.len, inputs.len);
    // A file with no small suffix, the payload itself, and a small body with no payload beside it.
    for ([_]usize{ 0, 3, 4 }) |index| {
        try testing.expectEqualStrings(files[index].name, inputs[index].name);
        try testing.expectEqual(1, inputs[index].parts.len);
        try testing.expectEqualStrings(files[index].octets, inputs[index].parts[0]);
        try testing.expectEqual(files[index].octets.len, inputs[index].len());
    }
    try testing.expectEqualStrings("http/html-1kx16", inputs[1].name);
    try testing.expectEqualStrings("http/html-16kx4", inputs[2].name);
    for ([_]usize{ 1, 2 }) |index| {
        const input = inputs[index];
        try testing.expectEqual(files[index].octets.len, input.part_len);
        try testing.expectEqual(payload.len, input.len());
        // The slices are the payload, in its order, with nothing left out.
        for (input.parts, 0..) |part, part_index| {
            try testing.expectEqualStrings(payload[part_index * input.part_len ..][0..input.part_len], part);
        }
    }
}

test "a small body that is not its payload's start, or whose length does not divide it, is refused" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const payload = test_octets(64);
    var other = payload;
    other[3] ^= 1;
    const not_the_start = [_]File{ .{ .name = "a-1k", .octets = other[0..4] }, .{ .name = "a-1m", .octets = &payload } };
    try testing.expectError(error.SmallBodyIsNotItsPayloadsStart, of(arena_state.allocator(), &not_the_start));
    const not_whole = [_]File{ .{ .name = "a-16k", .octets = payload[0..5] }, .{ .name = "a-1m", .octets = &payload } };
    try testing.expectError(error.PayloadIsNotWholeSlices, of(arena_state.allocator(), &not_whole));
    const empty = [_]File{ .{ .name = "a-1k", .octets = "" }, .{ .name = "a-1m", .octets = &payload } };
    try testing.expectError(error.PayloadIsNotWholeSlices, of(arena_state.allocator(), &empty));
}

test "a payload is the file whose whole name is the small body's with the payload's suffix" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const payload = test_octets(64);
    // `a-b-1m` starts as `a-1k` does and ends as a payload does, and is not `a-1m`.
    const files = [_]File{ .{ .name = "a-1k", .octets = payload[0..4] }, .{ .name = "a-b-1m", .octets = &payload } };
    const inputs = try of(arena_state.allocator(), &files);
    try testing.expectEqualStrings("a-1k", inputs[0].name);
    try testing.expectEqual(1, inputs[0].parts.len);
    try testing.expectEqual(4, inputs[0].len());
}

/// A candidate that records what it was given: each input's first octet, in order.
const Recorder = struct {
    seen: *std.ArrayList(u8),
    fail_on: ?u8 = null,

    pub fn run(self: *const Recorder, input: []const u8) ?usize {
        if (self.fail_on == input[0]) return null;
        self.seen.appendAssumeCapacity(input[0]);
        return input.len;
    }
};

test "one repetition of a rotation codes every input once, in order" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    var seen: std.ArrayList(u8) = try .initCapacity(arena_state.allocator(), 16);
    const inputs = [_][]const u8{ "a1", "b2", "c3" };
    const placed = try operation(arena_state.allocator(), Recorder{ .seen = &seen }, &inputs);
    placed.run_once(placed.context);
    try testing.expectEqualStrings("abc", seen.items);
    placed.run_once(placed.context);
    try testing.expectEqualStrings("abcabc", seen.items);
}

/// An encoder that writes a part twice over, in less than its bound, and a decoder that takes
/// that back.
const Doubling = struct {
    output: []u8,
    corrupt: bool = false,
    /// The first octet of a part the encoder refuses.
    refuses: ?u8 = null,

    pub fn bound(_: Doubling, part_len: usize) usize {
        return 2 * part_len + 3;
    }

    pub fn encode(self: Doubling, part: []const u8, room: []u8) ?usize {
        if (self.refuses == part[0]) return null;
        @memcpy(room[0..part.len], part);
        @memcpy(room[part.len..][0..part.len], part);
        return 2 * part.len;
    }

    pub fn run(self: *const Doubling, stream: []const u8) ?usize {
        if (stream.len % 2 != 0) return null;
        @memcpy(self.output[0 .. stream.len / 2], stream[0 .. stream.len / 2]);
        if (self.corrupt) self.output[0] ^= 1;
        return stream.len / 2;
    }
};

test "streams holds one stream a part, in order, and expect_decodes takes each back to its part" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const payload = test_octets(64);
    const files = [_]File{ .{ .name = "a-16k", .octets = payload[0..16] }, .{ .name = "a-1m", .octets = &payload } };
    const input = (try of(arena, &files))[0];
    var output: [16]u8 = undefined;
    const codec: Doubling = .{ .output = &output };
    const coded = try streams(arena, input, codec);
    try testing.expectEqual(4, coded.len);
    try testing.expectEqual(2 * payload.len, total_len(coded));
    try testing.expectEqual(200, compressed_percent(total_len(coded), input));
    for (coded, input.parts, 0..) |stream, part, index| {
        try testing.expectEqualStrings(part, stream[0..part.len]);
        try testing.expectEqualStrings(part, stream[part.len..]);
        // Each stream starts where the one before it ends.
        if (index != 0) try testing.expectEqual(coded[index - 1].ptr + coded[index - 1].len, stream.ptr);
    }
    try expect_decodes(codec, coded, input);
    try testing.expectError(error.CandidatesDisagree, expect_decodes(Doubling{ .output = &output, .corrupt = true }, coded, input));
    // A decoder that writes a part's first octets alone disagrees too.
    try testing.expectError(error.CandidatesDisagree, expect_decodes(codec, &.{ coded[0][0..8], coded[1], coded[2], coded[3] }, input));
    try testing.expectError(error.CandidateFailed, expect_decodes(codec, &.{ coded[0][0..7], coded[1], coded[2], coded[3] }, input));
    // So does one whose last stream alone decodes to another part.
    try testing.expectError(error.CandidatesDisagree, expect_decodes(codec, &.{ coded[0], coded[1], coded[2], coded[0] }, input));
    // An encoder that refuses one part gives no streams.
    try testing.expectError(error.EncodeFailed, streams(arena, input, Doubling{ .output = &output, .refuses = input.parts[2][0] }));
}

test "decoder_operation checks a decoder before it places it" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const payload = test_octets(64);
    const files = [_]File{ .{ .name = "a-16k", .octets = payload[0..16] }, .{ .name = "a-1m", .octets = &payload } };
    const input = (try of(arena, &files))[0];
    var output: [16]u8 = undefined;
    const coded = try streams(arena, input, Doubling{ .output = &output });
    try testing.expectError(error.CandidatesDisagree, decoder_operation(arena, Doubling{ .output = &output, .corrupt = true }, coded, input));
    const placed = try decoder_operation(arena, Doubling{ .output = &output }, coded, input);
    // One repetition decodes every stream, the last of them last.
    output = @splat(0);
    placed.run_once(placed.context);
    try testing.expectEqualStrings(input.parts[input.parts.len - 1], &output);
}

test "a file taken whole is learned up to learned_len_max octets, and slices never are" {
    const at = [_][]const u8{&@as([learned_len_max]u8, @splat(0))};
    const past = [_][]const u8{&@as([learned_len_max + 1]u8, @splat(0))};
    try testing.expect((Input{ .name = "at", .parts = &at, .part_len = learned_len_max }).is_learned());
    try testing.expect(!(Input{ .name = "past", .parts = &past, .part_len = learned_len_max + 1 }).is_learned());
    const slices = [_][]const u8{ "ab", "cd" };
    try testing.expect(!(Input{ .name = "slices", .parts = &slices, .part_len = 2 }).is_learned());
}

test "the note names the rows of slices and each learned file, and says nothing for neither" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const large: [learned_len_max + 1]u8 = @splat(0);
    const payload = test_octets(64);
    const files = [_]File{
        .{ .name = "large", .octets = &large },
        .{ .name = "small/one", .octets = "one" },
        .{ .name = "a-1k", .octets = payload[0..4] },
        .{ .name = "a-1m", .octets = &payload },
        .{ .name = "small/two", .octets = "two" },
    };
    const inputs = try of(arena, &files);
    var buffer: [1024]u8 = undefined;
    var writer: std.Io.Writer = .fixed(&buffer);
    // Neither kind of row: no note.
    try note(&writer, inputs[0..1]);
    try testing.expectEqualStrings("", writer.buffered());
    // Slices alone.
    try note(&writer, inputs[2..3]);
    try testing.expect(std.mem.indexOf(u8, writer.buffered(), "`<file>x<count>`") != null);
    try testing.expect(std.mem.indexOf(u8, writer.buffered(), "learned") == null);
    try testing.expect(std.mem.endsWith(u8, writer.buffered(), "(decision 45).\n\n"));
    // Both, with every learned file named in the rows' order. `a-1m` holds 64 octets here, so it
    // is a learned file too.
    writer = .fixed(&buffer);
    try note(&writer, inputs);
    try testing.expect(std.mem.indexOf(u8, writer.buffered(), "`<file>x<count>`") != null);
    try testing.expect(std.mem.indexOf(u8, writer.buffered(), "(decision 45). A row that repeats one file") != null);
    try testing.expect(std.mem.endsWith(u8, writer.buffered(), "of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: small/one, a-1m, small/two.\n\n"));
    // Learned files alone.
    writer = .fixed(&buffer);
    try note(&writer, inputs[1..2]);
    try testing.expect(std.mem.startsWith(u8, writer.buffered(), "A row that repeats one file"));
    try testing.expect(std.mem.endsWith(u8, writer.buffered(), ": small/one.\n\n"));
}
