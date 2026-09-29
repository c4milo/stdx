//! The encoder: one JSON text (RFC 8259 §2 to §7), or one text of a sequence (RFC 7464 §2.2), from
//! the tokens a caller passes in order, one token per call or across several.
//!
//! The encoder places the separators, so a caller passes values, names and the ends of objects and
//! arrays. It writes no insignificant whitespace, so its output is a pure function of the tokens,
//! their input and the framing, whatever the output room of each call (invariant 5). What a call
//! cannot write, it holds in `pending` for the next: a token's opening, an escape, a pair of hex
//! digits, a number, or a token's closing.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const format = @import("../format.zig");
const Claims = @import("../claims.zig").Claims;
const framing_file = @import("../framing.zig");
const Framing = framing_file.Framing;
const Utf8 = @import("../utf8.zig").Utf8;
const Number = @import("../number.zig").Number;
const wide = @import("../wide.zig");
const content = @import("encoder_content.zig");
const fast = @import("encoder_fast.zig");
const batch = @import("encoder_batch.zig");

/// Whether the octets of a name, a string, a hex string or a number end with a call's input.
pub const Piece = framing_file.Piece;

/// One token of the text, in the order RFC 8259's grammar puts it (§2 to §5).
pub const Token = union(enum) {
    begin_object,
    end_object,
    begin_array,
    end_array,
    /// A member's name (RFC 8259 §4): a string of the call's input, which must be UTF-8.
    name: Piece,
    /// A string (RFC 8259 §7) of the call's input, which must be UTF-8.
    string: Piece,
    /// A string of two lowercase hexadecimal digits for each octet of the call's input, the more
    /// significant first.
    hex: Piece,
    /// A number (RFC 8259 §6) whose text is the call's input.
    number: Piece,
    unsigned: u64,
    signed: i64,
    /// A fixed-point decimal, written with its fraction's digits.
    decimal: format.Decimal,
    /// The literal name `true` or `false` (RFC 8259 §3).
    boolean: bool,
    /// The literal name `null` (RFC 8259 §3).
    null,
};

/// The kind of a token, with no value.
pub const Kind = std.meta.Tag(Token);

/// Every way a caller's input breaks RFC 8259, and the one limit the encoder sets.
pub const Error = error{
    /// A name or a string holds octets that are not UTF-8 (RFC 8259 §8.1, RFC 3629 §4).
    InvalidUtf8,
    /// A number's text is not one number of RFC 8259 §6's grammar.
    InvalidNumber,
    /// An object or an array opened past `constants.depth_max` levels (RFC 8259 §9).
    DepthTooLarge,
};

/// Where the next token goes in RFC 8259's grammar.
pub const Position = enum(u8) {
    /// Before the text's value.
    text_start,
    /// After `{`: a name, or `}`.
    object_first,
    /// After a member's value: a value separator and a name, or `}`.
    object_next,
    /// After a name: the member's value.
    member_value,
    /// After `[`: a value, or `]`.
    array_first,
    /// After an element: a value separator and a value, or `]`.
    array_next,
    /// After the text's value: no token.
    text_end,
};

/// The part of the token in progress that a call writes next.
const Part = enum(u8) { between_tokens, opening, content, closing, done, refused };

pub const Encoder = struct {
    /// Bit `d` holds when the container at depth `d + 1` is an object, and is clear for an array.
    containers: std.StaticBitSet(constants.depth_max),
    depth: u16,
    position: Position,
    framing: Framing,
    part: Part,
    /// The token in progress, while `part` is `opening`, `content` or `closing`.
    kind: Kind,
    /// Whether the token in progress ends the text.
    ends_text: bool,
    /// Octets a call has to write before any other: `pending[written..len]`.
    pending: [constants.pending_len_max]u8,
    pending_len: u8,
    pending_written: u8,
    /// Where the validation of a name's or a string's octets stands (RFC 3629 §4).
    utf8: Utf8,
    /// Where a number's text stands in RFC 8259 §6's grammar.
    number: Number,
    /// The widest vector the caller's CPU features allow the vector paths (claim J7).
    level: wide.Level,

    /// Starts a text, with the CPU features the caller detected once or took from the build
    /// target (`codec.Features`). `init` again after `done` or after an error.
    pub fn init(self: *Encoder, framing: Framing, features: codec.Features) void {
        self.* = .{
            .containers = .initEmpty(),
            .depth = 0,
            .position = .text_start,
            .framing = framing,
            .part = .between_tokens,
            .kind = .null,
            .ends_text = false,
            .pending = undefined,
            .pending_len = 0,
            .pending_written = 0,
            .utf8 = .{},
            .number = .{},
            .level = .of(features),
        };
    }

    /// Writes as much of `token` into `output` as fits, with the octets `input` holds of a name, a
    /// string, a hex string or a number (decision 11). The status is:
    /// - `needs_input` when the token is written, or all of `input` is taken and the token goes on
    ///   in the next call's (`Piece.more`), and the text is not finished;
    /// - `needs_room` when `output` is full first: call again with the same token and the input
    ///   not consumed;
    /// - `done` when the token ended the text.
    ///
    /// Tokens come in the order RFC 8259's grammar allows, and a token that takes no octets comes
    /// with an empty `input`: anything else is a programmer error that an assertion catches.
    pub fn encode(self: *Encoder, token: Token, input: []const u8, output: []u8) Error!codec.Progress {
        return self.encode_with(.{}, token, input, output);
    }

    /// `encode`, with the claims the tests and the benchmark switch (claims.zig).
    pub fn encode_with(self: *Encoder, comptime claims: Claims, token: Token, input: []const u8, output: []u8) Error!codec.Progress {
        codec.check_entry(input, output);
        // A call after `done` or after an error, without `init`, is a programmer error.
        assert(self.part != .done and self.part != .refused);
        assert(input.len == 0 or takes_input(token));
        var reader = codec.Reader.init(input);
        var writer = codec.Writer.init(output);
        const status = self.run(claims, token, &reader, &writer) catch |err| {
            self.part = .refused;
            return err;
        };
        const progress: codec.Progress = .{ .consumed = reader.consumed(), .written = writer.position, .status = status };
        codec.check_progress(input.len, output.len, progress);
        return progress;
    }

    /// Many tokens a call (decision 33): `encode`'s tokens one after another, from a list of items.
    pub const Item = batch.Item;
    pub const Batch = batch.Batch;
    pub fn encode_batch(self: *Encoder, items: []const Item, output: []u8) Error!Batch {
        return batch.encode_batch_with(self, .{}, items, output);
    }
    pub const encode_batch_with = batch.encode_batch_with;

    /// True when the text has ended.
    pub fn is_done(self: *const Encoder) bool {
        return self.part == .done;
    }

    /// The call's loop, inline in `encode_with`, its one caller. Out of line, as LLVM left it in
    /// the benchmark's build with every claim off, where it had a second caller, each token paid a
    /// call of its own.
    pub inline fn run(self: *Encoder, comptime claims: Claims, token: Token, reader: *codec.Reader, writer: *codec.Writer) Error!codec.Status {
        if (try self.start(claims, token, reader, writer)) |status| return status;
        for (0..constants.token_parts) |_| {
            if (!self.write_pending(writer)) return .needs_room;
            switch (self.part) {
                .opening => if (takes_input(token)) {
                    self.part = .content;
                } else self.close(),
                .content => {
                    if (try content.write(claims, self, piece_of(token), reader, writer)) |status| return status;
                    self.close();
                },
                .closing => return self.finish(),
                .between_tokens, .done, .refused => unreachable,
            }
        }
        // The closing ends every token, and a call reaches it within the parts it passes.
        unreachable;
    }

    /// Starts a call. Between tokens, it writes `token` whole on claim J9's fast path, and returns
    /// the status, or opens the token for `run`'s loop. Inside one, the token goes on.
    inline fn start(self: *Encoder, comptime claims: Claims, token: Token, reader: *codec.Reader, writer: *codec.Writer) Error!?codec.Status {
        if (self.part != .between_tokens) {
            assert(self.kind == std.meta.activeTag(token));
            return null;
        }
        if (claims.encoder_fast_path) {
            if (fast.token(self, claims, token, reader, writer)) |status| return status;
        }
        try self.open(token);
        return null;
    }

    /// Starts `token`: checks where it goes, moves the grammar past it, and holds its opening.
    fn open(self: *Encoder, token: Token) Error!void {
        const kind = std.meta.activeTag(token);
        assert(allowed(self.position, kind));
        const opening_depth = self.depth;
        if (kind == .begin_object or kind == .begin_array) {
            // RFC 8259 §9: an implementation may limit the depth of nesting.
            if (self.depth == constants.depth_max) return error.DepthTooLarge;
        }
        if (self.framing == .sequence and self.position == .text_start) self.hold(&.{constants.record_separator});
        if (self.position == .object_next or self.position == .array_next) {
            if (kind != .end_object and kind != .end_array) self.hold(&.{constants.value_separator});
        }
        self.hold_opening(token);
        self.advance(kind);
        assert(self.depth <= opening_depth + 1);
        self.kind = kind;
        self.ends_text = self.position == .text_end;
        self.utf8 = .{};
        self.number = .{};
        self.part = .opening;
    }

    /// Holds the octets that start `token`: a structural character, a quotation mark, or the whole
    /// text of a number or a literal name.
    fn hold_opening(self: *Encoder, token: Token) void {
        var buffer: format.Buffer = undefined;
        switch (token) {
            .begin_object => self.hold(&.{constants.begin_object}),
            .end_object => self.hold(&.{constants.end_object}),
            .begin_array => self.hold(&.{constants.begin_array}),
            .end_array => self.hold(&.{constants.end_array}),
            .name, .string, .hex => self.hold(&.{constants.quotation_mark}),
            .number => {},
            .unsigned => |value| self.hold(format.unsigned(&buffer, value)),
            .signed => |value| self.hold(format.signed(&buffer, value)),
            .decimal => |value| self.hold(format.decimal(&buffer, value)),
            .boolean => |value| self.hold(if (value) constants.literal_true else constants.literal_false),
            .null => self.hold(constants.literal_null),
        }
    }

    /// Moves the grammar past a token of `kind`, which `allowed` let through.
    pub fn advance(self: *Encoder, kind: Kind) void {
        switch (kind) {
            .begin_object, .begin_array => {
                self.containers.setValue(self.depth, kind == .begin_object);
                self.depth += 1;
                self.position = if (kind == .begin_object) .object_first else .array_first;
            },
            .end_object, .end_array => {
                assert(self.depth > 0 and self.containers.isSet(self.depth - 1) == (kind == .end_object));
                self.depth -= 1;
                self.after_value();
            },
            .name => self.position = .member_value,
            else => self.after_value(),
        }
    }

    /// The position after a value: the end of the text at depth 0, and else the container's next.
    fn after_value(self: *Encoder) void {
        if (self.depth == 0) {
            self.position = .text_end;
        } else {
            self.position = if (self.containers.isSet(self.depth - 1)) .object_next else .array_next;
        }
    }

    /// Holds the octets that end the token in progress: a name's quotation mark and name
    /// separator, a string's quotation mark, and the line feed after a sequence's text (RFC 7464
    /// §2.2).
    pub fn close(self: *Encoder) void {
        switch (self.kind) {
            .name => self.hold(&.{ constants.quotation_mark, constants.name_separator }),
            .string, .hex => self.hold(&.{constants.quotation_mark}),
            else => {},
        }
        if (self.ends_text and self.framing == .sequence) self.hold(&.{constants.line_feed});
        self.part = .closing;
    }

    fn finish(self: *Encoder) codec.Status {
        assert(self.pending_len == 0);
        if (self.ends_text) {
            self.part = .done;
            return .done;
        }
        self.part = .between_tokens;
        return .needs_input;
    }

    /// Adds `octets` to what the next call writes first.
    pub fn hold(self: *Encoder, octets: []const u8) void {
        assert(self.pending_len + octets.len <= self.pending.len);
        @memcpy(self.pending[self.pending_len..][0..octets.len], octets);
        self.pending_len += @intCast(octets.len);
    }

    /// Writes what `output` takes of the held octets. Returns whether all of them are written.
    pub fn write_pending(self: *Encoder, writer: *codec.Writer) bool {
        assert(self.pending_written <= self.pending_len);
        self.pending_written += @intCast(writer.write_partial(self.pending[self.pending_written..self.pending_len]));
        if (self.pending_written < self.pending_len) return false;
        self.pending_len = 0;
        self.pending_written = 0;
        return true;
    }
};

/// True when a token of `kind` may come at `position` (RFC 8259 §2 to §5).
pub fn allowed(position: Position, kind: Kind) bool {
    return switch (position) {
        .text_start, .member_value => is_value(kind),
        .object_first, .object_next => kind == .name or kind == .end_object,
        .array_first, .array_next => is_value(kind) or kind == .end_array,
        .text_end => false,
    };
}

/// True for a token that starts a value (RFC 8259 §3).
fn is_value(kind: Kind) bool {
    return switch (kind) {
        .end_object, .end_array, .name => false,
        else => true,
    };
}

/// True for a token whose octets come in the call's input.
pub fn takes_input(token: Token) bool {
    return switch (token) {
        .name, .string, .hex, .number => true,
        else => false,
    };
}

fn piece_of(token: Token) Piece {
    return switch (token) {
        .name, .string, .hex, .number => |piece| piece,
        else => unreachable,
    };
}

test {
    _ = content;
    _ = fast;
    _ = batch;
    _ = @import("encoder_test.zig");
    _ = @import("encoder_batch_test.zig");
    _ = @import("encoder_loop.zig");
    _ = @import("encoder_loop_test.zig");
    _ = @import("encoder_fast_test.zig");
}
