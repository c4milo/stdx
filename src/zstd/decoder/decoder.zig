//! The Zstandard decoder (RFC 8878, as RFC 9659 updates it): one frame per `done`, a Zstandard
//! frame or a skippable one, its blocks raw, repeated or compressed, and its Content_Checksum.
//!
//! `Decoder(.{ .window_len_max = ... })` holds a window of that many octets, a power of two; the
//! default, 2^23, is RFC 9659 §3's for HTTP (decision 12). A frame that asks for more is refused
//! as `error.WindowTooLarge`. A compressed block decodes whole, as its streams are read backward:
//! from the call's input when it holds the block (Z5), or gathered into the state first. Its
//! sequences run as the output has room, so work per call stays linear in what the call reads and
//! writes (invariant 17). A block the output cannot take moves into the state. A frame's offsets
//! reach only octets it wrote (invariant 10). The octets after a frame stay in the input; the
//! caller decodes the next frame from them, as `decode_all` does (decision 11, RFC 8878 §3.1).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const checksum = @import("checksum");
const constants = @import("../constants.zig");
const frame = @import("../frame.zig");
const block = @import("../block.zig");
const huffman = @import("../huffman.zig");
const sequences = @import("../sequences.zig");
const work_module = @import("../work.zig");
const Paths = @import("../claims.zig").Paths;
const Work = work_module.Work;

pub const DecoderOptions = struct {
    /// The largest Window_Size the decoder takes, a power of two: 2^23, RFC 9659 §3's for HTTP, or
    /// more for a caller outside HTTP (decision 12).
    window_len_max: usize = constants.http_window_len,
    /// The fast paths of decision 16 and the claims within them; the tests and the benchmark
    /// switch them.
    paths: Paths = .{},
};

/// Every way a stream breaks RFC 8878.
pub const Corrupt = frame.Corrupt || block.Error || error{
    InvalidMagic,
    ReservedBlockType,
    BlockTooLong,
    ContentSizeMismatch,
    ChecksumMismatch,
};

/// Every valid feature the decoder refuses: a window past its limit, and a dictionary.
pub const Unsupported = frame.Unsupported;

pub const Error = Corrupt || Unsupported;

/// The class of every error `decode` returns (decision 11).
pub fn refusal(err: Error) codec.Refusal {
    inline for (@typeInfo(Unsupported).error_set orelse &.{}) |unsupported| {
        if (err == @field(anyerror, unsupported.name)) return .unsupported;
    }
    return .corrupt;
}

/// Where a stream stands.
pub const Phase = enum(u8) {
    magic,
    frame_header,
    skippable_size,
    skippable_data,
    block_header,
    raw_block,
    repeated_octet,
    repeated_block,
    gather,
    execute,
    checksum,
    done,
    refused,
};

/// Block_Type (RFC 8878 §3.1.1.2.2, Table 10).
pub const BlockType = enum(u2) { raw = 0, repeated = 1, compressed = 2, reserved = 3 };

/// The octets a frame takes at least: a skippable frame's magic and size.
pub const frame_len_min = constants.magic_len + constants.skippable_size_len;

pub fn Decoder(comptime options: DecoderOptions) type {
    comptime assert(std.math.isPowerOfTwo(options.window_len_max) and options.window_len_max >= constants.block_len_max);
    const Window = codec.Window(options.window_len_max);
    return struct {
        const Self = @This();

        window: Window,
        /// A compressed block, gathered whole (decision 12) when the call's input does not hold it,
        /// and its literals.
        block_octets: [constants.block_len_max]u8,
        literals_buffer: [constants.block_len_max]u8,
        huffman_table: huffman.Table,
        tables: sequences.Tables,
        run: block.Run,
        /// A fixed-length part the calls so far have read of: a magic number, a header, a size.
        field: codec.Field(constants.frame_header_len_max),
        phase: Phase,
        /// The frame: its header, Block_Maximum_Size, the octets decoded, the Repeated_Offsets,
        /// whether a Huffman tree was read, and the checksum over its octets.
        header: frame.Header,
        block_len_max: u32,
        frame_len: u64,
        repeats: [constants.repeated_offsets_initial.len]u32,
        huffman_valid: bool,
        hash: checksum.Xxh64,
        hash_path: checksum.Xxh64Path,
        /// The block: whether it is the frame's last, its Block_Size, the octets of it still to
        /// read or write, and a repeated block's octet.
        last_block: bool,
        block_len: u32,
        block_left: u32,
        repeated: u8,
        /// A skippable frame's octets still to skip.
        skip_left: u32,
        /// Invariant 17's count since `init`, in a test build.
        work: Work,
        /// The call's output before these indices is in the window, and in the checksum.
        synced: usize,
        hashed: usize,

        comptime {
            assert(@sizeOf(Self) <= options.window_len_max + constants.decoder_state_extra_len);
        }

        /// Starts a stream. Writes no octet of the window (decision 11).
        pub fn init(self: *Self, features: codec.Features) void {
            self.hash_path = checksum.Xxh64Path.fastest(checksum.Features.from(features));
            self.work = work_module.zero;
            self.start();
        }

        fn start(self: *Self) void {
            self.phase = .magic;
            self.field.init();
        }

        /// Decodes as much of `input` into `output` as both allow, up to the end of one frame
        /// (decision 11).
        pub fn decode(self: *Self, input: []const u8, output: []u8) Error!codec.Progress {
            codec.check_entry(input, output);
            // A call after `done` or after a refusal, without `init`, is a programmer error.
            assert(self.phase != .done and self.phase != .refused);
            var reader = codec.Reader.init(input);
            var written: usize = 0;
            self.synced = 0;
            self.hashed = 0;
            const status = run(options, self, &reader, output, &written) catch |err| {
                self.phase = .refused;
                return err;
            };
            // The next call reads this call's octets from the window, unless the frame ended. A call
            // that wrote octets is inside a frame's blocks, so its window and header are set.
            if (self.phase != .done and written > 0) {
                phases.hash_output(options, self, output[0..written]);
                self.window.append(output[self.synced..written]);
            }
            const progress: codec.Progress = .{ .consumed = reader.consumed(), .written = written, .status = status };
            codec.check_progress(input.len, output.len, progress);
            return progress;
        }

        /// Decodes every frame of `input`, one after another (RFC 8878 §3.1), from a decoder `init`
        /// started. The input ending inside a frame is `error.Truncated`, and the output filling
        /// first is `error.NoSpaceLeft`.
        pub fn decode_all(self: *Self, input: []const u8, output: []u8) (Error || codec.Incomplete)!codec.Whole {
            var total: codec.Whole = .{ .consumed = 0, .written = 0 };
            // Each frame takes at least `frame_len_min` octets, so this many calls end the input.
            for (0..input.len / frame_len_min + 1) |_| {
                const one = try codec.whole(try self.decode(input[total.consumed..], output[total.written..]));
                total.consumed += one.consumed;
                total.written += one.written;
                if (total.consumed == input.len) return total;
                self.start();
            }
            unreachable;
        }
    };
}

/// Takes steps until one needs what the call does not have, or the frame ends.
fn run(comptime options: DecoderOptions, self: *Decoder(options), reader: *codec.Reader, output: []u8, written: *usize) Error!codec.Status {
    // Each step reads or writes an octet, or moves to another phase, at most a few times per part.
    const steps_max = constants.decoder_steps_per_octet * (reader.remaining_len() + output.len) + constants.decoder_steps_floor;
    for (0..steps_max) |_| {
        if (try step(options, self, reader, output, written)) |status| return status;
    }
    unreachable;
}

/// One step. Returns the status that ends the call, or null to go on.
fn step(comptime options: DecoderOptions, self: *Decoder(options), reader: *codec.Reader, output: []u8, written: *usize) Error!?codec.Status {
    return switch (self.phase) {
        .magic => read_magic(options, self, reader),
        .frame_header => read_frame_header(options, self, reader),
        .skippable_size => read_skippable_size(options, self, reader),
        .skippable_data => skip(options, self, reader),
        .block_header => read_block_header(options, self, reader),
        .raw_block => copy_raw(options, self, reader, output, written),
        .repeated_octet => read_repeated_octet(options, self, reader),
        .repeated_block => write_repeated(options, self, output, written),
        .gather => gather(options, self, reader, output, written),
        .execute => execute(options, self, output, written),
        .checksum => read_checksum(options, self, reader),
        .done, .refused => unreachable,
    };
}

test {
    _ = @import("decoder_phases.zig");
    _ = @import("decoder_test.zig");
    _ = @import("decoder_fuzz_test.zig");
    _ = @import("decoder_work_test.zig");
}

const phases = @import("decoder_phases.zig");
const read_magic = phases.read_magic;
const read_frame_header = phases.read_frame_header;
const read_skippable_size = phases.read_skippable_size;
const skip = phases.skip;
const read_block_header = phases.read_block_header;
const copy_raw = phases.copy_raw;
const read_repeated_octet = phases.read_repeated_octet;
const write_repeated = phases.write_repeated;
const gather = phases.gather;
const execute = phases.execute;
const read_checksum = phases.read_checksum;
