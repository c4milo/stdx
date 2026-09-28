//! The brotli decoder (RFC 7932; decisions 11, 12 and 16). Its checked path reads every bit through
//! `codec.BitReader`, writes every octet through `codec.Writer`, and reads every back-reference
//! through `codec.Window`, one step at a time. Before a step of a command, while decision 16's
//! margins hold, the fast path of decoder_fast/decoder_fast.zig decodes as many commands as they allow.
//!
//! A step reads one whole field, one code or one symbol with its extra bits, or writes one octet.
//! A step that lacks bits leaves them in the state, and the call returns `needs_input` having taken
//! every octet of its input; a step that must write with no room left returns `needs_room`. A step
//! takes its bits only once all of them are present, so the state never holds half of a field.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const state_module = @import("decoder_state.zig");
const stream = @import("decoder_stream.zig");
const header = @import("decoder_header.zig");
const prefix_reader = @import("decoder_prefix.zig");
const commands = @import("decoder_commands.zig");
const fast = @import("decoder_fast/decoder_fast.zig");
const Output = @import("decoder_output.zig").Output;
const Paths = @import("../claims.zig").Paths;
const State = state_module.State;

pub const Corrupt = state_module.Corrupt;
pub const Unsupported = state_module.Unsupported;
pub const Error = state_module.Error;

/// The class of every error `decode` returns (decision 11).
pub fn refusal(err: Error) codec.Refusal {
    inline for (@typeInfo(Unsupported).error_set orelse &.{}) |unsupported| {
        if (err == @field(anyerror, unsupported.name)) return .unsupported;
    }
    return .corrupt;
}

pub const DecoderOptions = struct {
    /// The largest WBITS the instance decodes (decision 12): 24, the default, decodes every stream
    /// RFC 7932 allows (§1.4, §9.1); a smaller value takes a smaller window and refuses larger
    /// streams with `error.WindowTooLarge`.
    window_bits_max: u5 = constants.window_bits_max,
    /// The fast path of decision 16 and the claims within it; the tests and the benchmark switch
    /// them.
    paths: Paths = .{},
};

pub fn Decoder(comptime options: DecoderOptions) type {
    comptime assert(options.window_bits_max >= constants.window_bits_min);
    comptime assert(options.window_bits_max <= constants.window_bits_max);
    const Window = codec.Window(@as(usize, 1) << options.window_bits_max);
    return struct {
        const Self = @This();

        window: Window,
        state: State,

        comptime {
            // Decision 12: the window of 1 << `window_bits_max` octets and the state, pinned.
            assert(@sizeOf(Self) == (@as(usize, 1) << options.window_bits_max) + constants.decoder_state_len + @sizeOf(state_module.Work));
        }

        /// Starts a stream. Writes no octet of the window and no table (decision 11).
        pub fn init(self: *Self, features: codec.Features) void {
            _ = features;
            self.window.init();
            const state = &self.state;
            state.bits = .{};
            state.phase = .stream_header;
            state.produced = 0;
            state.last_meta_block = false;
            state.meta_block_left = 0;
            // RFC 7932 §7.1: p1 and p2 start as zero; §4: the last distances start as 4, 11, 15, 16.
            state.p1 = 0;
            state.p2 = 0;
            state.last_distances = constants.last_distances_initial;
            state.work = state_module.work_zero;
        }

        /// Decodes as much of `input` into `output` as both allow (decision 11).
        pub fn decode(self: *Self, input: []const u8, output: []u8) Error!codec.Progress {
            codec.check_entry(input, output);
            // A call after `done` or after a refusal, without `init`, is a programmer error.
            assert(self.state.phase != .done and self.state.phase != .refused);
            var bits = codec.BitReader.init(input, self.state.bits);
            var writer = codec.Writer.init(output);
            var out: Output(Window, options.paths.claims) = .{ .writer = &writer, .window = &self.window };
            const status = run(options, &self.state, &bits, &out, input.len, output.len) catch |err| {
                self.state.phase = .refused;
                return err;
            };
            // The window takes the call's octets once, and none when the stream is done (the
            // window-once claim).
            if (options.paths.claims.window_once and status != .done) self.window.append(writer.written());
            // Decision 11's read-ahead rule: hand back the whole octets not used, unless the call
            // ends for want of input, when every octet it holds belongs to the step it could not
            // finish.
            if (status != .needs_input) bits.unread_whole_octets();
            self.state.bits = bits.finish();
            const progress: codec.Progress = .{ .consumed = bits.consumed(), .written = writer.written().len, .status = status };
            codec.check_progress(input.len, output.len, progress);
            return progress;
        }

        /// Decodes a whole stream in one call (decision 11). The input ending before the stream
        /// does is `error.Truncated`, and the output filling first is `error.NoSpaceLeft`. Octets
        /// after the stream stay the caller's: `consumed` says where it ended.
        pub fn decode_all(self: *Self, input: []const u8, output: []u8) (Error || codec.Incomplete)!codec.Whole {
            return codec.whole(try self.decode(input, output));
        }
    };
}

/// The instance every `br` coding needs: RFC 7932 §1.4 and §9.1 require a decoder to accept WBITS
/// up to 24 (decision 12).
pub const HttpDecoder = Decoder(.{});

fn run(comptime options: DecoderOptions, state: *State, bits: *codec.BitReader, out: anytype, input_len: usize, output_len: usize) Error!codec.Status {
    const units = @bitSizeOf(u8) * input_len + codec.constants.bit_buffer_bits + output_len;
    const steps_max = constants.decoder_steps_per_unit * units + constants.decoder_steps_floor;
    for (0..steps_max) |_| {
        if (try step(options, state, bits, out)) |status| return status;
    }
    // Every step takes a bit or writes an octet, or is one of a few that follow one that does.
    unreachable;
}

/// One step, and the status that ends the call, or null to go on. A step of a command first lets
/// the fast path decode what its margins allow.
fn step(comptime options: DecoderOptions, state: *State, bits: *codec.BitReader, out: anytype) Error!?codec.Status {
    if (options.paths.fast_paths and fast.takes(state.phase) and fast.has_margin(state.phase, bits, out.writer)) {
        fast.run(options.paths.claims, state, out.window, bits, out.writer);
    }
    return switch (state.phase) {
        .stream_header => try stream.read_stream_header(state, bits, options.window_bits_max),
        .meta_block_header => stream.read_meta_block_header(state, bits),
        .metadata_header => try stream.read_metadata_header(state, bits),
        .metadata_skip => try stream.skip_metadata(state, bits),
        .meta_block_len => try stream.read_meta_block_len(state, bits),
        .uncompressed_flag => stream.read_uncompressed_flag(state, bits),
        .uncompressed_copy => try stream.copy_uncompressed(state, bits, out),
        .block_types_count => header.read_block_types_count(state, bits),
        .first_block_count => header.read_first_block_count(state, bits),
        .distance_parameters => header.read_distance_parameters(state, bits),
        .context_modes => header.read_context_modes(state, bits),
        .trees_count => header.read_trees_count(state, bits),
        .map_run_length => header.read_map_run_length(state, bits),
        .map_values => try header.read_map_values(state, bits),
        .map_inverse_transform => try header.read_map_inverse_transform(state, bits),
        .prefix_kind => prefix_reader.read_kind(state, bits),
        .simple_count => prefix_reader.read_simple_count(state, bits),
        .simple_symbols => try prefix_reader.read_simple_symbols(state, bits),
        .code_length_code => try prefix_reader.read_code_length_code(state, bits),
        .code_lengths => try prefix_reader.read_code_lengths(state, bits),
        .command => commands.read_command(state, bits),
        .command_extra => try commands.read_command_extra(state, bits),
        .block_type => commands.read_block_type(state, bits),
        .block_count => commands.read_block_count(state, bits),
        .literal => commands.read_literals(state, bits, out),
        .distance => try commands.read_distance(state, bits),
        .copy => commands.copy_match(state, out),
        .dictionary_copy => commands.copy_word(state, out),
        .meta_block_end => stream.end_meta_block(state),
        .stream_end => try stream.end_stream(state, bits),
        .done, .refused => unreachable,
    };
}

test {
    _ = @import("decoder_test.zig");
}

test {
    _ = @import("decoder_refusal_test.zig");
}

test {
    _ = @import("decoder_blocks_test.zig");
}

test {
    _ = @import("decoder_fuzz_test.zig");
}

test {
    _ = @import("decoder_work_test.zig");
}

test {
    _ = @import("decoder_fast/decoder_fast_test.zig");
}

test {
    _ = @import("decoder_fast/decoder_fast_command_test.zig");
}

test {
    _ = @import("decoder_fast/decoder_fast_literals_test.zig");
}

test {
    _ = @import("decoder_fast/decoder_fast_copy.zig");
}
