//! harness <level> <input file> <slice octets, 0 for the whole file> <rounds>
//!
//! Encodes the file, or its slices in rotation one stream a slice, with stdx's brotli encoder,
//! as bench-brotli's level 1 table codes a row: the state is placed once, started once with `init`,
//! reached through a pointer and begun for each stream with `start` (decision 60). Prints the
//! octets written and read over all rounds. Run it under callgrind in a Linux container (cg.sh).
//! A fifth argument, `hash`, also prints a Wyhash of every stream written, to compare two trees.
//! Kept outside the scratchpad, which macOS prunes.
const std = @import("std");
const brotli = @import("brotli");

comptime {
    _ = @import("memset");
}

fn Run(comptime level: u4) type {
    return struct {
        const Encoder = brotli.Encoder(.{ .level = level });

        fn encode(state: *Encoder, input: []const u8, output: []u8) !usize {
            state.start();
            return try state.encode_all(input, output);
        }

        fn all(arena: std.mem.Allocator, input: []const u8, slice_len: usize, rounds: usize, hasher: ?*std.hash.Wyhash) ![2]usize {
            const state = try arena.create(Encoder);
            state.init();
            const output = try arena.alloc(u8, Encoder.encoded_len_max(slice_len));
            var written: usize = 0;
            var read: usize = 0;
            for (0..rounds) |_| {
                var start: usize = 0;
                while (start + slice_len <= input.len) : (start += slice_len) {
                    const len = try @call(.never_inline, encode, .{ state, input[start..][0..slice_len], output });
                    if (hasher) |h| h.update(output[0..len]);
                    written += len;
                    read += slice_len;
                }
            }
            return .{ written, read };
        }
    };
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const io = init.io;
    const args = try init.minimal.args.toSlice(arena);
    const level = try std.fmt.parseInt(u4, args[1], 10);
    const input = try std.Io.Dir.cwd().readFileAlloc(io, args[2], arena, .unlimited);
    const slice_arg = try std.fmt.parseInt(usize, args[3], 10);
    const slice_len = if (slice_arg == 0) input.len else slice_arg;
    const rounds = try std.fmt.parseInt(usize, args[4], 10);
    var wyhash = std.hash.Wyhash.init(0);
    const hasher: ?*std.hash.Wyhash = if (args.len > 5) &wyhash else null;
    const counts = switch (level) {
        1 => try Run(1).all(arena, input, slice_len, rounds, hasher),
        5 => try Run(5).all(arena, input, slice_len, rounds, hasher),
        else => return error.Level,
    };
    var buffer: [256]u8 = undefined;
    var stdout = std.Io.File.stdout().writerStreaming(io, &buffer);
    try stdout.interface.print("{d} octets out of {d} in\n", .{ counts[0], counts[1] });
    if (hasher) |h| try stdout.interface.print("hash {x:0>16}\n", .{h.final()});
    try stdout.interface.flush();
}
