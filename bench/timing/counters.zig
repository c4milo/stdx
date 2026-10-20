//! Hardware counters through Linux's perf_event_open, in user space only: cycles, instructions,
//! branches and branch misses around the code a benchmark counts (bench-profile). A host that is
//! not Linux has none, which `available` says at comptime, and a Linux host may refuse them, which
//! `Counters.open` says.

const std = @import("std");
const builtin = @import("builtin");
const linux = std.os.linux;

/// Whether this host can have the counters at all.
pub const available = builtin.os.tag == .linux;

/// The counters, as perf_event_open numbers them, and where each stands in `Counters.stop`'s
/// counts.
pub const events = [_]linux.PERF.COUNT.HW{ .CPU_CYCLES, .INSTRUCTIONS, .BRANCH_INSTRUCTIONS, .BRANCH_MISSES, .STALLED_CYCLES_FRONTEND, .STALLED_CYCLES_BACKEND, .CPU_CYCLES };
pub const cycles = 0;
pub const instructions = 1;
pub const branches = 2;
pub const branch_misses = 3;
// PROBE, never lands: stalls and L1 data read misses for level 1's encoders (2026-10-20). The
// last event is read as a cache event, not as cycles.
pub const stalled_frontend = 4;
pub const stalled_backend = 5;
pub const l1d_read_misses = 6;

pub const Counters = struct {
    fds: [events.len]i32,

    /// Opens every counter for this thread, disabled, in user space alone.
    pub fn open() error{Unavailable}!Counters {
        var counters: Counters = undefined;
        for (events, &counters.fds, 0..) |event, *fd, index| {
            const cache = index == l1d_read_misses;
            var attr: linux.perf_event_attr = .{
                .type = if (cache) .HW_CACHE else .HARDWARE,
                // L1D, read, miss: 0 | 0 << 8 | 1 << 16.
                .config = if (cache) 1 << 16 else @intFromEnum(event),
                // The times enabled and running, so a count the kernel multiplexed scales back.
                .read_format = 1 | 2,
                .flags = .{ .disabled = true, .exclude_kernel = true, .exclude_hv = true },
            };
            const result = linux.perf_event_open(&attr, 0, -1, -1, linux.PERF.FLAG.FD_CLOEXEC);
            if (linux.errno(result) != .SUCCESS) {
                std.debug.print("counters: perf_event_open for {t}: {t}\n", .{ event, linux.errno(result) });
                return error.Unavailable;
            }
            fd.* = @intCast(result);
        }
        return counters;
    }

    pub fn start(self: *const Counters) void {
        for (self.fds) |fd| _ = linux.ioctl(fd, linux.PERF.EVENT_IOC.RESET, 0);
        for (self.fds) |fd| _ = linux.ioctl(fd, linux.PERF.EVENT_IOC.ENABLE, 0);
    }

    pub fn stop(self: *const Counters) [events.len]u64 {
        for (self.fds) |fd| _ = linux.ioctl(fd, linux.PERF.EVENT_IOC.DISABLE, 0);
        var counts: [events.len]u64 = undefined;
        for (self.fds, &counts) |fd, *count| {
            var octets: [3 * @sizeOf(u64)]u8 = undefined;
            // The kernel writes each count in the host's order: the value, the time enabled, the
            // time running.
            if (linux.read(fd, &octets, octets.len) != octets.len) {
                count.* = 0;
                continue;
            }
            const endian = builtin.cpu.arch.endian();
            const value = std.mem.readInt(u64, octets[0..8], endian);
            const enabled = std.mem.readInt(u64, octets[8..16], endian);
            const running = std.mem.readInt(u64, octets[16..24], endian);
            count.* = if (running == 0) 0 else if (running >= enabled) value else @intFromFloat(@as(f64, @floatFromInt(value)) * @as(f64, @floatFromInt(enabled)) / @as(f64, @floatFromInt(running)));
            if (running < enabled) std.debug.print("counters: an event ran {d} of {d} ns, scaled\n", .{ running, enabled });
        }
        return counts;
    }
};
