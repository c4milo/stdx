//! bench-profile: hardware counters for each gzip decoder over the corpora, where the host exposes
//! them: cycles, instructions and branch misses per decoded octet, counted around the decoding
//! alone through Linux's perf_event_open, in user space only. It shows where the fast path of
//! design §8 step 7 spends its cycles against the baselines, and it answers whether a hosted runner
//! exposes the counters, which docs/costs.md leaves open (decision 20). A host without them gets a
//! line that says so, and the program exits 0.
//!
//! The streams are bench-deflate's: zlib's gzip at level 6. Each decoder decodes each file's
//! stream until it has written at least `decoded_len_min` octets, after one decode checked against
//! the file.
//!
//! Usage: `bench_profile <name>=<path>...`. It prints a Markdown table to standard output.

const std = @import("std");
const builtin = @import("builtin");
const linux = std.os.linux;
const oracle = @import("oracle");
const codec = @import("codec");
const gzip = @import("gzip");
const baselines = @import("baselines");

/// The zlib level of the streams, bench-deflate's.
const encode_level: c_int = 6;

/// The octets each decoder writes per file, at least, over as many decodes as that takes.
const decoded_len_min = 16 * 1024 * 1024;

/// The counters, as perf_event_open numbers them.
const events = [_]linux.PERF.COUNT.HW{ .CPU_CYCLES, .INSTRUCTIONS, .BRANCH_INSTRUCTIONS, .BRANCH_MISSES };

const Counters = struct {
    fds: [events.len]i32,

    /// Opens every counter for this thread, disabled, in user space alone.
    fn open() error{Unavailable}!Counters {
        var counters: Counters = undefined;
        for (events, &counters.fds) |event, *fd| {
            var attr: linux.perf_event_attr = .{
                .type = .HARDWARE,
                .config = @intFromEnum(event),
                .flags = .{ .disabled = true, .exclude_kernel = true, .exclude_hv = true },
            };
            const result = linux.perf_event_open(&attr, 0, -1, -1, linux.PERF.FLAG.FD_CLOEXEC);
            if (linux.errno(result) != .SUCCESS) {
                std.debug.print("bench-profile: perf_event_open for {t}: {t}\n", .{ event, linux.errno(result) });
                return error.Unavailable;
            }
            fd.* = @intCast(result);
        }
        return counters;
    }

    fn start(self: *const Counters) void {
        for (self.fds) |fd| _ = linux.ioctl(fd, linux.PERF.EVENT_IOC.RESET, 0);
        for (self.fds) |fd| _ = linux.ioctl(fd, linux.PERF.EVENT_IOC.ENABLE, 0);
    }

    fn stop(self: *const Counters) [events.len]u64 {
        for (self.fds) |fd| _ = linux.ioctl(fd, linux.PERF.EVENT_IOC.DISABLE, 0);
        var counts: [events.len]u64 = undefined;
        for (self.fds, &counts) |fd, *count| {
            var octets: [@sizeOf(u64)]u8 = undefined;
            count.* = if (linux.read(fd, &octets, octets.len) == octets.len) std.mem.readInt(u64, &octets, .little) else 0;
        }
        return counts;
    }
};

/// What a decoder needs besides the stream: stdx's state, and the features it picks paths by.
const Context = struct {
    decoder: *gzip.Decoder,
    features: codec.Features,
};

const Candidate = struct {
    name: []const u8,
    /// One decode of the whole stream into `output`. Returns whether it wrote all of it.
    decode: *const fn (context: Context, stream: []const u8, output: []u8) bool,
};

fn decode_zlib(_: Context, stream: []const u8, output: []u8) bool {
    const result = oracle.zlib_decode(.gzip, stream, output);
    return result.verdict == .ok and result.written == output.len;
}

fn decode_zlib_ng(_: Context, stream: []const u8, output: []u8) bool {
    return baselines.zlib_ng_gzip_decode(stream, output) == output.len;
}

fn decode_libdeflate(_: Context, stream: []const u8, output: []u8) bool {
    return baselines.libdeflate_gzip_decode(stream, output) == output.len;
}

fn decode_wuffs(_: Context, stream: []const u8, output: []u8) bool {
    const result = oracle.wuffs_decode(.gzip, stream, output);
    return result.verdict == .ok and result.written == output.len;
}

fn decode_stdx(context: Context, stream: []const u8, output: []u8) bool {
    gzip.init(context.decoder, context.features);
    const progress = gzip.decode(context.decoder, stream, output) catch return false;
    return progress.status == .done and progress.written == output.len;
}

const candidates = [_]Candidate{
    .{ .name = "zlib", .decode = decode_zlib },
    .{ .name = "zlib-ng", .decode = decode_zlib_ng },
    .{ .name = "libdeflate", .decode = decode_libdeflate },
    .{ .name = "Wuffs", .decode = decode_wuffs },
    .{ .name = "stdx", .decode = decode_stdx },
};

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const io = init.io;
    const args = try init.minimal.args.toSlice(arena);
    var stdout_buffer: [4096]u8 = undefined;
    var stdout = std.Io.File.stdout().writerStreaming(io, &stdout_buffer);
    const out = &stdout.interface;
    if (comptime builtin.os.tag != .linux) {
        try out.print("Hardware counters are read through Linux's perf_event_open; this host is not Linux.\n", .{});
        try out.flush();
        return;
    }
    const counters = Counters.open() catch {
        try out.print("Hardware counters are unavailable on this host: perf_event_open refused them.\n", .{});
        try out.flush();
        return;
    };
    const context: Context = .{ .decoder = try arena.create(gzip.Decoder), .features = codec.Features.detect() };
    try out.print("| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |\n", .{});
    try out.print("|---|---|---|---|---|---|---|\n", .{});
    for (args[1..]) |argument| {
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse return error.UsageNameEqualsPath;
        const input = try std.Io.Dir.cwd().readFileAlloc(io, argument[split + 1 ..], arena, .unlimited);
        const encoded = try arena.alloc(u8, oracle.zlib_bound(.gzip, input.len));
        const encoding: oracle.Encoding = .{ .container = .gzip, .level = encode_level, .strategy = .default };
        const stream = encoded[0..oracle.zlib_encode(encoding, input, encoded).written];
        const output = try arena.alloc(u8, input.len);
        const rounds = @max(1, decoded_len_min / @max(1, input.len));
        for (candidates) |candidate| {
            if (!candidate.decode(context, stream, output) or !std.mem.eql(u8, input, output)) return error.CandidateDisagrees;
            counters.start();
            for (0..rounds) |_| std.mem.doNotOptimizeAway(candidate.decode(context, stream, output));
            const counts = counters.stop();
            const octets: f64 = @floatFromInt(rounds * input.len);
            const cycles: f64 = @floatFromInt(counts[0]);
            const instructions: f64 = @floatFromInt(counts[1]);
            const misses: f64 = @floatFromInt(counts[3]);
            try out.print("| {s} | {d} | {s} | {d:.2} | {d:.2} | {d:.2} | {d:.2} |\n", .{
                argument[0..split],     input.len,             candidate.name,
                cycles / octets,        instructions / octets, instructions / @max(1, cycles),
                misses / octets * 1024,
            });
        }
    }
    try out.flush();
}
