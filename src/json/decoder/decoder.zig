//! The decoder: a pull reader over one JSON text (RFC 8259 §2 to §7), or one text of a sequence
//! (RFC 7464 §2.1). Each call returns at most one token, and writes the octets of a name or a
//! string, unescaped, and of a number, as its text, into the caller's output.
//!
//! It follows RFC 8259's grammar strictly and fails closed where the RFC lets a parser choose
//! (decision 15): a byte order mark, a lone surrogate, and a text deeper than `depth_max` are
//! refused. It reports every member of an object, duplicates included, in order (RFC 8259 §4).
//! Its state is a plain value (invariant 12), and a call's work is bounded by the octets it
//! consumes and writes (invariant 17). Between tokens, a call tries claim J8's fast path first
//! (decoder_fast.zig), and takes the checked path below for every case the fast path leaves.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const scan = @import("../scan.zig");
const number_grammar = @import("../number.zig");
const Claims = @import("../claims.zig").Claims;
const framing_file = @import("../framing.zig");
const Framing = framing_file.Framing;
const Piece = framing_file.Piece;
const Utf8 = @import("../utf8.zig").Utf8;
const Containers = @import("../containers.zig").Containers;
const wide = @import("../wide.zig");
const strings = @import("decoder_string.zig");
const values = @import("decoder_value.zig");
const fast = @import("decoder_fast.zig");
const batch = @import("decoder_batch.zig");

/// A token of RFC 8259's grammar (§2): the four structural characters a caller sees, a member's
/// name, a string, a number, and the three literal names.
pub const Kind = enum(u8) { begin_object, end_object, begin_array, end_array, name, string, number, true, false, null };

/// How a call ended.
pub const Status = enum {
    /// The call took all of its input and the text is not finished. With `Piece.last`, the text
    /// ended before its value did.
    needs_input,
    /// The output is full, inside a name, a string or a number whose octets go on.
    needs_room,
    /// A token ended: `Progress.kind` names it.
    token,
    /// The text ended, and every rule it carries passed.
    done,
};

/// What a call did.
pub const Progress = struct {
    /// Octets of the input taken. The caller never presents them again.
    consumed: usize,
    /// Octets of the output that hold a name's, a string's or a number's octets, from its start.
    written: usize,
    status: Status,
    /// The token that ended (`token`), or the name, string or number whose octets the call wrote
    /// before it ran out of input or room. Null otherwise.
    kind: ?Kind,
};

/// Every way a text breaks RFC 8259, or a sequence's text breaks RFC 7464.
pub const Corrupt = error{
    ByteOrderMark,
    ExpectedValue,
    InvalidLiteral,
    InvalidNumber,
    ControlCharacterInString,
    InvalidEscape,
    InvalidUtf8,
    ExpectedName,
    ExpectedNameSeparator,
    ExpectedValueSeparator,
    TrailingOctets,
    MissingRecordSeparator,
    IncompleteText,
    UndelimitedValue,
};

/// Every text RFC 8259 allows that the decoder refuses: one deeper than `depth_max` (§9), and a
/// string holding a surrogate no other completes, which UTF-8 cannot hold (§8.2).
pub const Unsupported = error{ DepthTooLarge, LoneSurrogate };

pub const Error = Corrupt || Unsupported;

/// The class of every error `decode` returns (decision 11).
pub fn refusal(err: Error) codec.Refusal {
    inline for (@typeInfo(Unsupported).error_set orelse &.{}) |unsupported| {
        if (err == @field(anyerror, unsupported.name)) return .unsupported;
    }
    return .corrupt;
}

/// What the grammar allows next (RFC 8259 §2 to §5).
pub const Expect = enum(u8) {
    /// A value: the text's, or after a name separator, or after a value separator in an array.
    value,
    /// After `[`: a value, or `]`.
    value_or_end_array,
    /// After `{`: a name, or `}`.
    name_or_end_object,
    /// After a value separator in an object: a name.
    name,
    /// After a name: a name separator.
    name_separator,
    /// After a value inside a container: a value separator, or the container's end.
    separator_or_end,
    /// After the text's value: whitespace, then the end.
    end_of_text,
};

/// Where the text stands before its tokens, and after them.
const Stage = enum(u8) {
    /// A sequence's text, before and among the record separators that start it (RFC 7464 §2.1).
    record_separators,
    /// Before the text's first octet, where a byte order mark would be (RFC 8259 §8.1).
    byte_order_mark,
    tokens,
    done,
    refused,
};

/// The token whose octets a call is in the middle of.
pub const Open = enum(u8) { none, name, string, number, true, false, null };

/// Where a string's escape stands (RFC 8259 §7).
pub const Escape = enum(u8) {
    none,
    /// After the reverse solidus.
    reverse_solidus,
    /// Among the four hexadecimal digits of a `\u` escape.
    unicode,
    /// After a `\u` escape of a high surrogate: its low surrogate's reverse solidus comes next.
    high_surrogate,
    /// After that reverse solidus: the `u` comes next.
    high_surrogate_reverse_solidus,
};

pub const Decoder = struct {
    /// The kind of each open container.
    containers: Containers,
    depth: u16,
    expect: Expect,
    framing: Framing,
    stage: Stage,
    open: Open,
    /// Octets of the byte order mark read so far, or of a literal name.
    matched: u8,
    /// Whether whitespace followed the text's value, which a sequence requires after a number or
    /// a literal name (RFC 7464 §2.4).
    value_delimited: bool,
    escape: Escape,
    /// The hexadecimal digits of the `\u` escape read so far, and their value.
    escape_digits: u8,
    code_unit: u16,
    /// The high surrogate a low one must follow, while `escape` says so.
    high_surrogate: u16,
    /// Where the validation of a string's octets stands (RFC 3629 §4).
    utf8: Utf8,
    /// Where a number stands in RFC 8259 §6's grammar.
    number: number_grammar.Number,
    /// The UTF-8 of an escaped character that the output had no room for: `pending[written..len]`.
    pending: [constants.utf8_len_max]u8,
    pending_len: u8,
    pending_written: u8,
    /// The widest vector the caller's CPU features allow the vector paths (claim J7).
    level: wide.Level,

    /// Starts a text, with the CPU features the caller detected once or took from the build
    /// target (`codec.Features`). `init` again after `done` or after an error.
    pub fn init(self: *Decoder, framing: Framing, features: codec.Features) void {
        self.* = .{
            .containers = .empty,
            .depth = 0,
            .expect = .value,
            .framing = framing,
            .stage = if (framing == .sequence) .record_separators else .byte_order_mark,
            .open = .none,
            .matched = 0,
            .value_delimited = false,
            .escape = .none,
            .escape_digits = 0,
            .code_unit = 0,
            .high_surrogate = 0,
            .utf8 = .{},
            .number = .{},
            .pending = undefined,
            .pending_len = 0,
            .pending_written = 0,
            .level = .of(features),
        };
    }

    /// Decodes the text's next token from `input`, writing a name's, a string's or a number's
    /// octets into `output`. `piece` says whether `input` holds the last of the text's octets: a
    /// number, or whitespace after the text's value, can go on in the next call until it does.
    pub fn decode(self: *Decoder, input: []const u8, output: []u8, piece: Piece) Error!Progress {
        return self.decode_with(.{}, input, output, piece);
    }

    /// `decode`, with the claims the tests and the benchmark switch (claims.zig).
    pub fn decode_with(self: *Decoder, comptime claims: Claims, input: []const u8, output: []u8, piece: Piece) Error!Progress {
        codec.check_entry(input, output);
        // A call after `done` or after an error, without `init`, is a programmer error.
        assert(self.stage != .done and self.stage != .refused);
        var reader = codec.Reader.init(input);
        var writer = codec.Writer.init(output);
        const outcome = self.run(claims, &reader, &writer, piece) catch |err| {
            self.stage = .refused;
            return err;
        };
        const progress: Progress = .{ .consumed = reader.consumed(), .written = writer.position, .status = outcome.status, .kind = outcome.kind };
        check_progress(input.len, output.len, progress);
        return progress;
    }

    /// Many tokens a call (decision 33): `decode`'s tokens one after another into `slots`, with
    /// their octets one after another in `output`.
    pub const Slot = batch.Slot;
    pub const Batch = batch.Batch;
    pub fn decode_batch(self: *Decoder, input: []const u8, output: []u8, piece: Piece, slots: []Slot) Error!Batch {
        return batch.decode_batch_with(self, .{}, input, output, piece, slots);
    }
    pub const decode_batch_with = batch.decode_batch_with;

    /// True when the text has ended.
    pub fn is_done(self: *const Decoder) bool {
        return self.stage == .done;
    }

    /// The call's loop, inline in `decode_with`, its one caller. Out of line, as LLVM left it in
    /// the benchmark's build with every claim on, where it had a second caller, each token paid a
    /// call of its own.
    pub inline fn run(self: *Decoder, comptime claims: Claims, reader: *codec.Reader, writer: *codec.Writer, piece: Piece) Error!Outcome {
        if (self.open != .none) return self.continue_token(claims, reader, writer, piece);
        if (claims.decoder_fast_path and self.stage == .tokens) {
            if (fast.token(self, claims, reader, writer)) |outcome| return outcome;
        }
        for (0..constants.decoder_steps_max) |_| {
            if (try self.step(claims, reader, writer, piece)) |outcome| return outcome;
        }
        // A step returns, or passes the record separators, the byte order mark's check or one
        // separator, each at most once between two tokens.
        unreachable;
    }

    /// Takes the octets between tokens up to the next separator or token. Returns the call's
    /// outcome, or null when it passed a separator and the next step goes on.
    fn step(self: *Decoder, comptime claims: Claims, reader: *codec.Reader, writer: *codec.Writer, piece: Piece) Error!?Outcome {
        switch (self.stage) {
            .record_separators => return self.record_separators(reader, piece),
            .byte_order_mark => return self.byte_order_mark(reader, piece),
            .tokens => {},
            .done, .refused => unreachable,
        }
        const whitespace = skip_whitespace(reader);
        if (whitespace > 0 and self.expect == .end_of_text) self.value_delimited = true;
        const octet = reader.read_octet() catch return try self.end_of_input(piece);
        if (self.framing == .sequence and octet == constants.record_separator) {
            reader.unread(1);
            return try self.text_ended_by_separator();
        }
        // RFC 8259 §2: a text is whitespace, one value and whitespace.
        if (self.expect == .end_of_text) return error.TrailingOctets;
        return switch (self.expect) {
            .value => try self.value(claims, octet, reader, writer, piece),
            .value_or_end_array => if (octet == constants.end_array) self.end_container(.end_array) else try self.value(claims, octet, reader, writer, piece),
            .name_or_end_object => if (octet == constants.end_object) self.end_container(.end_object) else try self.name(claims, octet, reader, writer, piece),
            .name => try self.name(claims, octet, reader, writer, piece),
            .name_separator => try self.name_separator(octet),
            .separator_or_end => try self.separator_or_end(octet),
            .end_of_text => unreachable,
        };
    }

    /// Takes the record separators that start a sequence's text (RFC 7464 §2.1): at least one, and
    /// any after it, which denote no text between them.
    fn record_separators(self: *Decoder, reader: *codec.Reader, piece: Piece) Error!?Outcome {
        for (0..reader.remaining_len()) |_| {
            const octet = reader.read_octet() catch unreachable;
            if (octet == constants.record_separator) {
                self.matched = 1;
                continue;
            }
            reader.unread(1);
            // RFC 7464 §2.1: every text of a sequence is preceded by a record separator.
            if (self.matched == 0) return error.MissingRecordSeparator;
            self.matched = 0;
            self.stage = .byte_order_mark;
            return null;
        }
        return try self.end_of_input(piece);
    }

    /// Refuses a text that starts with a byte order mark (RFC 8259 §8.1), which no JSON text holds.
    fn byte_order_mark(self: *Decoder, reader: *codec.Reader, piece: Piece) Error!?Outcome {
        for (self.matched..constants.byte_order_mark.len) |index| {
            const octet = reader.read_octet() catch {
                // RFC 8259 §3: at the text's end, octets taken as a byte order mark's start no value.
                if (piece == .last and self.matched > 0) return error.ExpectedValue;
                return try self.end_of_input(piece);
            };
            if (octet == constants.byte_order_mark[index]) {
                self.matched += 1;
                continue;
            }
            reader.unread(1);
            // RFC 8259 §3: the octets taken as a byte order mark's start a value.
            if (self.matched > 0) return error.ExpectedValue;
            self.stage = .tokens;
            return null;
        }
        // RFC 8259 §8.1: implementations must not add a byte order mark, and the decoder refuses
        // one rather than ignore it (decision 15).
        return error.ByteOrderMark;
    }

    /// The outcome when the input holds no more octets between tokens.
    fn end_of_input(self: *Decoder, piece: Piece) Error!Outcome {
        if (piece == .more or self.stage != .tokens or self.expect != .end_of_text) return .{ .status = .needs_input, .kind = null };
        // RFC 7464 §2.4: a sequence's number or literal name must be followed by whitespace, or it
        // may have been cut.
        if (self.framing == .sequence and !self.value_delimited) return error.UndelimitedValue;
        self.stage = .done;
        return .{ .status = .done, .kind = null };
    }

    /// The outcome when a record separator ends a sequence's text (RFC 7464 §2.1).
    fn text_ended_by_separator(self: *Decoder) Error!Outcome {
        // RFC 7464 §2.1: the octets before the next record separator are the text, whole.
        if (self.expect != .end_of_text) return error.IncompleteText;
        // RFC 7464 §2.4: a number or literal name must be followed by whitespace.
        if (!self.value_delimited) return error.UndelimitedValue;
        self.stage = .done;
        return .{ .status = .done, .kind = null };
    }

    /// Starts the value `octet` begins (RFC 8259 §3).
    fn value(self: *Decoder, comptime claims: Claims, octet: u8, reader: *codec.Reader, writer: *codec.Writer, piece: Piece) Error!Outcome {
        switch (octet) {
            constants.begin_object, constants.begin_array => return self.begin_container(octet),
            constants.quotation_mark => return self.start_token(claims, .string, reader, writer, piece),
            constants.literal_true[0] => return self.start_token(claims, .true, reader, writer, piece),
            constants.literal_false[0] => return self.start_token(claims, .false, reader, writer, piece),
            constants.literal_null[0] => return self.start_token(claims, .null, reader, writer, piece),
            else => {},
        }
        // RFC 8259 §3: a value is an object, an array, a number, a string or a literal name.
        if (!number_grammar.starts_number(octet)) return error.ExpectedValue;
        reader.unread(1);
        return self.start_token(claims, .number, reader, writer, piece);
    }

    fn name(self: *Decoder, comptime claims: Claims, octet: u8, reader: *codec.Reader, writer: *codec.Writer, piece: Piece) Error!Outcome {
        // RFC 8259 §4: a member starts with its name, a string.
        if (octet != constants.quotation_mark) return error.ExpectedName;
        return self.start_token(claims, .name, reader, writer, piece);
    }

    fn name_separator(self: *Decoder, octet: u8) Error!?Outcome {
        // RFC 8259 §4: a single colon comes after each name.
        if (octet != constants.name_separator) return error.ExpectedNameSeparator;
        self.expect = .value;
        return null;
    }

    fn separator_or_end(self: *Decoder, octet: u8) Error!?Outcome {
        const in_object = self.containers.is_object(self.depth - 1);
        if (octet == constants.value_separator) {
            self.expect = if (in_object) .name else .value;
            return null;
        }
        if (octet == constants.end_object and in_object) return self.end_container(.end_object);
        if (octet == constants.end_array and !in_object) return self.end_container(.end_array);
        // RFC 8259 §4, §5: a comma or the container's own end follows each value in it.
        return error.ExpectedValueSeparator;
    }

    pub fn begin_container(self: *Decoder, octet: u8) Error!Outcome {
        // RFC 8259 §9: an implementation may limit the depth of nesting.
        if (self.depth == constants.depth_max) return error.DepthTooLarge;
        const object = octet == constants.begin_object;
        self.containers.set(self.depth, object);
        self.depth += 1;
        self.expect = if (object) .name_or_end_object else .value_or_end_array;
        return .{ .status = .token, .kind = if (object) .begin_object else .begin_array };
    }

    pub fn end_container(self: *Decoder, kind: Kind) Outcome {
        assert(self.depth > 0 and self.containers.is_object(self.depth - 1) == (kind == .end_object));
        self.depth -= 1;
        self.value_ended(kind);
        return .{ .status = .token, .kind = kind };
    }

    fn start_token(self: *Decoder, comptime claims: Claims, open: Open, reader: *codec.Reader, writer: *codec.Writer, piece: Piece) Error!Outcome {
        assert(self.open == .none and self.escape == .none and self.pending_len == 0);
        self.open = open;
        self.matched = 1;
        self.utf8 = .{};
        self.number = .{};
        return self.continue_token(claims, reader, writer, piece);
    }

    fn continue_token(self: *Decoder, comptime claims: Claims, reader: *codec.Reader, writer: *codec.Writer, piece: Piece) Error!Outcome {
        return switch (self.open) {
            .name, .string => strings.content(claims, self, reader, writer),
            .number => values.number(self, reader, writer, piece),
            .true, .false, .null => values.literal(self, reader),
            .none => unreachable,
        };
    }

    /// Moves the grammar past a value of `kind` that just ended.
    pub fn value_ended(self: *Decoder, kind: Kind) void {
        self.open = .none;
        if (self.depth > 0) {
            self.expect = .separator_or_end;
            return;
        }
        self.expect = .end_of_text;
        self.value_delimited = switch (kind) {
            .number, .true, .false, .null => false,
            else => true,
        };
    }

    /// Moves the grammar past a name that just ended.
    pub fn name_ended(self: *Decoder) void {
        self.open = .none;
        self.expect = .name_separator;
    }
};

/// A call's status and the token it names.
pub const Outcome = struct { status: Status, kind: ?Kind };

/// The kind of the token `open` names.
pub fn kind_of(open: Open) Kind {
    return switch (open) {
        .name => .name,
        .string => .string,
        .number => .number,
        .true => .true,
        .false => .false,
        .null => .null,
        .none => unreachable,
    };
}

/// Takes the whitespace at the reader's position (RFC 8259 §2), and returns how much. Between the
/// tokens of a compact text there is none, which the first octet shows without the scan.
pub inline fn skip_whitespace(reader: *codec.Reader) usize {
    const window = reader.take_partial(reader.remaining_len());
    reader.unread(window.len);
    if (window.len == 0 or !scan.is_whitespace(window[0])) return 0;
    const len = scan.whitespace_len_scalar(window);
    _ = reader.take(len) catch unreachable;
    return len;
}

/// The checks every call makes at its exit: invariant 7 for the counts, and a status the kind
/// agrees with.
fn check_progress(input_len: usize, output_len: usize, progress: Progress) void {
    const status: codec.Status = switch (progress.status) {
        .needs_input => .needs_input,
        .needs_room => .needs_room,
        .token, .done => .done,
    };
    codec.check_progress(input_len, output_len, .{ .consumed = progress.consumed, .written = progress.written, .status = status });
    switch (progress.status) {
        .token => assert(progress.kind != null),
        .done => assert(progress.kind == null and progress.written == 0),
        .needs_room => assert(progress.kind == .name or progress.kind == .string or progress.kind == .number),
        .needs_input => {},
    }
}

test {
    _ = strings;
    _ = values;
    _ = fast;
    _ = @import("decoder_fast_test.zig");
    _ = batch;
    _ = @import("decoder_batch_test.zig");
    _ = @import("decoder_loop/decoder_loop.zig");
    _ = @import("decoder_loop/decoder_loop_string_test.zig");
    _ = @import("decoder_loop/decoder_loop_test.zig");
    _ = @import("decoder_test.zig");
    _ = @import("decoder_refusal_test.zig");
    _ = @import("decoder_fuzz_test.zig");
    _ = @import("decoder_reference_test.zig");
}
