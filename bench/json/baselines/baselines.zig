//! bench-json's baselines (decision 27, ruled by the owner on 2026-09-28): simdjson 4.6.11, yyjson
//! 0.13.0 and Zig 0.16.0's std.json, timed in the same interleaved run as the claims' candidates,
//! so stdx with every claim on is the same build in both comparisons.
//!
//! Each baseline does the work stdx's decoder and encoder do, through its documented API:
//! - decoding visits every value of each text, unescapes every name and string, checks every
//!   number, literal and the text's end, and counts what it found into a `Tally`;
//! - encoding writes each text from its tokens into memory, escaping what RFC 8259 §7 requires,
//!   with a hex string's digits and a decimal's text formatted the way a caller of that library
//!   would, since none of them has either.
//!
//! Before anything is timed, each baseline's decoding must count what stdx's counts, and each
//! baseline's text must decode, through stdx, to what stdx's own text decodes to. The C and C++
//! baselines are built for the host in ReleaseFast, as the codecs' baselines are, and simdjson picks
//! its kernel at run time; std.json is built for the host in ReleaseFast; stdx is built for the
//! architecture's baseline CPU in ReleaseSafe (decisions 17 and 21).

const std = @import("std");
const json = @import("json");
const codec = @import("codec");
const timing = @import("timing");
const abi = @import("abi");
const std_json = @import("std_json_baseline");
const workloads = @import("../json_workloads.zig");
const Workload = workloads.Workload;

pub const names = [_][]const u8{ "simdjson", "yyjson", "std.json" };
pub const count = names.len;

extern fn stdx_bench_simdjson_built() c_int;
extern fn stdx_bench_simdjson_parser_new() ?*anyopaque;
extern fn stdx_bench_simdjson_parser_free(parser: *anyopaque) void;
extern fn stdx_bench_simdjson_padding() usize;
extern fn stdx_bench_simdjson_decode(parser: *anyopaque, text: [*]const u8, len: usize, capacity: usize, tally: *abi.Tally) c_int;
extern fn stdx_bench_simdjson_builder_new(capacity: usize) ?*anyopaque;
extern fn stdx_bench_simdjson_builder_free(builder: *anyopaque) void;
extern fn stdx_bench_simdjson_encode(builder: *anyopaque, tokens: [*]const abi.Token, len: usize, scratch: [*]u8) usize;
extern fn stdx_bench_simdjson_copy(builder: *anyopaque, out: [*]u8, out_len: usize) usize;
extern fn stdx_bench_yyjson_read_pool_len(text_len: usize) usize;
extern fn stdx_bench_yyjson_decode(text: [*]const u8, len: usize, pool: [*]u8, pool_len: usize, tally: *abi.Tally) c_int;
extern fn stdx_bench_yyjson_encode(tokens: [*]const abi.Token, len: usize, out: [*]u8, out_len: usize, pool: [*]u8, pool_len: usize, scratch: [*]u8) usize;

/// The room yyjson's document builder takes per token and per octet of the tokens, beyond its
/// fixed start: generous, as its API documents no bound for a document it builds.
const pool_per_token = 64;
const pool_per_octet = 4;
const pool_fixed = 1 << 16;

/// The baselines' output room, as a multiple of what stdx's encoder can write: yyjson's writer
/// needs 16 octets and six per octet of a string beyond the text it writes (doc/API.md), and a hex
/// string's digits are twice its octets.
const output_per_stdx_octet = 2;

/// A workload's inputs in each baseline's form, made before anything is timed.
pub const Prepared = struct {
    /// Each text without a sequence's record separator, which no baseline reads (RFC 7464 §2.1).
    texts: []const []const u8,
    /// Each text again, followed by the padding simdjson reads past a text's end.
    padded: []const []const u8,
    padding: usize,
    tokens: []const []const abi.Token,
    /// yyjson's pool: its whole memory for reading the longest text, or for building one.
    pool: []u8,
    /// A hex string's digits or a decimal's text, for each encoder.
    scratch: []u8,
    output: []u8,
    /// Null where simdjson is not built (`built`).
    simdjson_parser: ?*anyopaque,
    simdjson_builder: ?*anyopaque,
    std_arena: *std.heap.ArenaAllocator,

    pub fn deinit(self: *Prepared) void {
        if (self.simdjson_parser) |parser| stdx_bench_simdjson_parser_free(parser);
        if (self.simdjson_builder) |builder| stdx_bench_simdjson_builder_free(builder);
        self.std_arena.deinit();
    }
};

/// Which baselines this host builds: all of them but simdjson on macOS, where Zig 0.16.0 builds no
/// libc++ (build/oracle.zig). An absent one is timed as nothing and reported as not built.
pub fn built() [count]bool {
    return .{ stdx_bench_simdjson_built() != 0, true, true };
}

/// Makes the baselines' inputs for `workload` in `arena`, which the caller frees after timing it.
pub fn prepare(arena: std.mem.Allocator, workload: *const Workload) !Prepared {
    const padding = stdx_bench_simdjson_padding();
    const texts = try arena.alloc([]const u8, workload.texts.len);
    const padded = try arena.alloc([]const u8, workload.texts.len);
    var text_len_max: usize = 0;
    for (workload.texts, texts, padded) |text, *plain, *copy| {
        plain.* = if (workload.framing == .sequence) text[1..] else text;
        const buffer = try arena.alloc(u8, plain.len + padding);
        @memcpy(buffer[0..plain.len], plain.*);
        @memset(buffer[plain.len..], ' ');
        copy.* = buffer[0..plain.len];
        text_len_max = @max(text_len_max, plain.len);
    }
    const tokens = try arena.alloc([]const abi.Token, workload.items.len);
    var build_pool_max: usize = 0;
    var octets_max: usize = 0;
    var output_max: usize = 0;
    for (workload.items, tokens) |items, *converted| {
        converted.* = try tokens_of(arena, items);
        var octets: usize = 0;
        for (items) |item| octets = @max(octets, item.octets.len);
        octets_max = @max(octets_max, octets);
        build_pool_max = @max(build_pool_max, pool_fixed + pool_per_token * items.len + pool_per_octet * workloads.encoded_len_max(items));
        output_max = @max(output_max, output_per_stdx_octet * workloads.encoded_len_max(items) + pool_fixed);
    }
    const std_arena = try arena.create(std.heap.ArenaAllocator);
    std_arena.* = .init(std.heap.page_allocator);
    return .{
        .texts = texts,
        .padded = padded,
        .padding = padding,
        .tokens = tokens,
        .pool = try arena.alloc(u8, @max(stdx_bench_yyjson_read_pool_len(text_len_max), build_pool_max)),
        .scratch = try arena.alloc(u8, 2 * octets_max + pool_fixed),
        .output = try arena.alloc(u8, output_max),
        .simdjson_parser = if (built()[0]) stdx_bench_simdjson_parser_new() orelse return error.OutOfMemory else null,
        .simdjson_builder = if (built()[0]) stdx_bench_simdjson_builder_new(output_max) orelse return error.OutOfMemory else null,
        .std_arena = std_arena,
    };
}

fn tokens_of(arena: std.mem.Allocator, items: []const workloads.Item) ![]const abi.Token {
    const tokens = try arena.alloc(abi.Token, items.len);
    for (items, tokens) |item, *token| token.* = token_of(item);
    return tokens;
}

fn token_of(item: workloads.Item) abi.Token {
    const octets: abi.Token = .{ .kind = .string, .octets = item.octets.ptr, .len = item.octets.len };
    return switch (item.token) {
        .begin_object => .{ .kind = .begin_object },
        .end_object => .{ .kind = .end_object },
        .begin_array => .{ .kind = .begin_array },
        .end_array => .{ .kind = .end_array },
        .name => with_kind(octets, .name),
        .string => octets,
        .hex => with_kind(octets, .hex),
        .number => number_of(with_kind(octets, .number), item.octets),
        .unsigned => |value| .{ .kind = .unsigned, .integer = value },
        .signed => |value| .{ .kind = .signed, .integer = @bitCast(value) },
        .decimal => |value| decimal_of(value),
        .boolean => |value| .{ .kind = if (value) .true else .false },
        .null => .{ .kind = .null },
    };
}

fn with_kind(token: abi.Token, kind: abi.Kind) abi.Token {
    var changed = token;
    changed.kind = kind;
    return changed;
}

/// A number's value beside its text, for yyjson, which builds numbers from values.
fn number_of(token: abi.Token, text: []const u8) abi.Token {
    var number = token;
    number.real = std.fmt.parseFloat(f64, text) catch 0;
    const negative = text.len > 0 and text[0] == '-';
    const magnitude = std.fmt.parseInt(u64, text[@intFromBool(negative)..], 10) catch return number;
    if (negative and magnitude > std.math.maxInt(i64)) return number;
    number.integral = true;
    number.negative = negative;
    number.integer = magnitude;
    return number;
}

fn decimal_of(value: json.Decimal) abi.Token {
    const scale = std.math.pow(f64, 10, @floatFromInt(value.fraction_digits));
    const magnitude = @as(f64, @floatFromInt(value.integer)) + @as(f64, @floatFromInt(value.fraction)) / scale;
    return .{
        .kind = .decimal,
        .fraction_digits = value.fraction_digits,
        .negative = value.negative,
        .integer = value.integer,
        .fraction = value.fraction,
        .real = if (value.negative) -magnitude else magnitude,
    };
}

fn decode_simdjson(prepared: *const Prepared) !abi.Tally {
    var tally: abi.Tally = .{};
    for (prepared.padded) |text| {
        if (stdx_bench_simdjson_decode(prepared.simdjson_parser.?, text.ptr, text.len, text.len + prepared.padding, &tally) != 0) return error.BaselineRefused;
    }
    return tally;
}

fn decode_yyjson(prepared: *const Prepared) !abi.Tally {
    var tally: abi.Tally = .{};
    for (prepared.texts) |text| {
        if (stdx_bench_yyjson_decode(text.ptr, text.len, prepared.pool.ptr, prepared.pool.len, &tally) != 0) return error.BaselineRefused;
    }
    return tally;
}

fn decode_std(prepared: *const Prepared) !abi.Tally {
    var tally: abi.Tally = .{};
    for (prepared.texts) |text| try std_json.decode(prepared.std_arena, text, &tally);
    return tally;
}

const decoders = [count]*const fn (*const Prepared) anyerror!abi.Tally{ decode_simdjson, decode_yyjson, decode_std };

fn Timed(comptime decoder: *const fn (*const Prepared) anyerror!abi.Tally) type {
    return struct {
        fn run_once(context: *const anyopaque) void {
            const prepared: *const Prepared = @ptrCast(@alignCast(context));
            std.mem.doNotOptimizeAway(decoder(prepared) catch unreachable);
        }
    };
}

/// An operation for a baseline this host does not build: it times nothing.
fn absent_run_once(context: *const anyopaque) void {
    _ = context;
}

/// The decoders' operations, each checked to count `reference`, stdx's tally, first.
pub fn decode_operations(prepared: *const Prepared, reference: abi.Tally) ![count]timing.Operation {
    var operations: [count]timing.Operation = undefined;
    inline for (decoders, &operations, built()) |decoder, *operation, is_built| {
        operation.* = .{ .context = prepared, .run_once = absent_run_once };
        if (is_built) {
            if (!std.meta.eql(try decoder(prepared), reference)) return error.BaselineDiffers;
            operation.run_once = Timed(decoder).run_once;
        }
    }
    return operations;
}

fn encode_simdjson(prepared: *const Prepared, index: usize) usize {
    const tokens = prepared.tokens[index];
    return stdx_bench_simdjson_encode(prepared.simdjson_builder.?, tokens.ptr, tokens.len, prepared.scratch.ptr);
}

fn encode_yyjson(prepared: *const Prepared, index: usize) usize {
    const tokens = prepared.tokens[index];
    return stdx_bench_yyjson_encode(tokens.ptr, tokens.len, prepared.output.ptr, prepared.output.len, prepared.pool.ptr, prepared.pool.len, prepared.scratch.ptr);
}

fn encode_std(prepared: *const Prepared, index: usize) usize {
    return std_json.encode(prepared.tokens[index], prepared.output, prepared.scratch) catch 0;
}

const encoders = [count]*const fn (*const Prepared, usize) usize{ encode_simdjson, encode_yyjson, encode_std };

fn Encoded(comptime encoder: *const fn (*const Prepared, usize) usize) type {
    return struct {
        fn run_once(context: *const anyopaque) void {
            const prepared: *const Prepared = @ptrCast(@alignCast(context));
            var written: usize = 0;
            for (0..prepared.tokens.len) |index| written += encoder(prepared, index);
            std.mem.doNotOptimizeAway(written);
        }
    };
}

/// The encoders' operations, each checked first: every text it writes must decode, through stdx,
/// to the tally stdx's own text of those tokens decodes to.
pub fn encode_operations(prepared: *const Prepared, workload: *const Workload, storage: []u8) ![count]timing.Operation {
    var operations: [count]timing.Operation = undefined;
    inline for (encoders, &operations, built(), 0..) |encoder, *operation, is_built, which| {
        operation.* = .{ .context = prepared, .run_once = absent_run_once };
        if (is_built) {
            for (workload.texts, 0..) |text, index| try check_encoded(prepared, workload, storage, text, which, encoder(prepared, index));
            operation.run_once = Encoded(encoder).run_once;
        }
    }
    return operations;
}

/// Requires the text baseline `which` just wrote, `written` octets, to decode through stdx to what
/// `text`, stdx's own text of the same tokens, decodes to.
fn check_encoded(prepared: *const Prepared, workload: *const Workload, storage: []u8, text: []const u8, which: usize, written: usize) !void {
    if (written == 0) return error.BaselineRefused;
    const baseline_text = if (which == 0)
        prepared.output[0..stdx_bench_simdjson_copy(prepared.simdjson_builder.?, prepared.output.ptr, prepared.output.len)]
    else
        prepared.output[0..written];
    const expected = try tally_of(text, workload.framing, storage);
    if (!std.meta.eql(try tally_of(baseline_text, .text, storage), expected)) return error.BaselineDiffers;
}

/// What stdx's decoder counts in `text`, with the workloads' claims (json_workloads.zig).
fn tally_of(text: []const u8, framing: json.Framing, storage: []u8) !abi.Tally {
    var decoder: json.Decoder = undefined;
    decoder.init(framing, codec.Features.detect());
    var tally: abi.Tally = .{};
    var consumed: usize = 0;
    for (0..text.len + 1) |_| {
        const progress = try decoder.decode_with(workloads.setup_claims, text[consumed..], storage, .last);
        consumed += progress.consumed;
        switch (progress.status) {
            .token => count_token(&tally, progress.kind.?, progress.written),
            .done => return tally,
            .needs_input, .needs_room => return error.Truncated,
        }
    }
    return error.TooManyTokens;
}

/// Adds one token of stdx's decoder to `tally`.
pub fn count_token(tally: *abi.Tally, kind: json.Kind, written: usize) void {
    switch (kind) {
        .begin_object, .begin_array => tally.containers += 1,
        .end_object, .end_array => {},
        .name, .string => {
            tally.strings += 1;
            tally.string_len += written;
        },
        .number => tally.numbers += 1,
        .true, .false, .null => tally.literals += 1,
    }
}

/// One workload's throughput: stdx's with one candidate's claims, and each baseline's, in MB/s with
/// their spreads.
pub const Row = struct {
    name: []const u8,
    octets: usize,
    median: [1 + count]f64,
    spread: [1 + count]f64,
};

/// One table of rows beside the baselines: its title, what its octets are, and the side its losses
/// name.
pub const Side = struct { title: []const u8, octets_are: []const u8, side: []const u8, rows: []const Row };

/// Prints each side's table and the workloads where a baseline ran faster than stdx.
pub fn report(out: *std.Io.Writer, sides: []const Side) !void {
    try out.print("\n## Against the baselines\n\n", .{});
    try out.print("stdx with every claim on, timed beside simdjson 4.6.11, yyjson 0.13.0 and Zig 0.16.0's std.json in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe; the baselines for this host in ReleaseFast, and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.\n", .{});
    for (sides) |side| try table(out, side.title, side.octets_are, side.rows);
    try out.print("\n## Losses to the baselines\n\nEach workload where a baseline ran faster than stdx by more than the noise floor of decision 20.\n\n", .{});
    var none = true;
    for (sides) |side| {
        for (side.rows) |row| {
            if (try report_losses(out, side.side, row)) none = false;
        }
    }
    if (none) try out.print("None.\n", .{});
}

/// Prints each baseline that ran faster than stdx over `row`, and returns whether one did.
fn report_losses(out: *std.Io.Writer, side: []const u8, row: Row) !bool {
    var any = false;
    for (names, built(), 1..) |baseline, is_built, index| {
        if (!is_built) continue;
        const ratio = row.median[0] / row.median[index];
        if (ratio >= 1 - @max(0.05, @max(row.spread[0], row.spread[index]))) continue;
        any = true;
        try out.print("- {s}, {s}: stdx runs at {d:.3} of {s}.\n", .{ row.name, side, ratio, baseline });
    }
    return any;
}

fn table(out: *std.Io.Writer, title: []const u8, octets_are: []const u8, rows: []const Row) !void {
    try out.print("\n## {s}\n\n{s}\n\n| Workload | Octets | stdx, MB/s |", .{ title, octets_are });
    for (names) |name| try out.print(" {s}, MB/s |", .{name});
    for (names) |name| try out.print(" stdx / {s} |", .{name});
    try out.print("\n|---|---|---|", .{});
    for (0..2 * count) |_| try out.print("---|", .{});
    try out.print("\n", .{});
    for (rows) |row| try table_row(out, row);
}

fn table_row(out: *std.Io.Writer, row: Row) !void {
    const is_built = [_]bool{true} ++ built();
    try out.print("| {s} | {d} |", .{ row.name, row.octets });
    for (row.median, row.spread, is_built) |median, spread, present| {
        if (present) try out.print(" {d:.1} ± {d:.1}% |", .{ median, spread * 100 }) else try out.print(" not built |", .{});
    }
    for (1..1 + count) |index| {
        if (is_built[index]) try out.print(" {d:.3} |", .{row.median[0] / row.median[index]}) else try out.print(" not built |", .{});
    }
    try out.print("\n", .{});
}
