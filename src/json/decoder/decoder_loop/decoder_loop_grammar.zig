//! Claim J10's walk of the grammar (RFC 8259 §2 to §5): the tokens `fill` takes one after another
//! into a batch's slots, through decoder_loop.zig's `Loop`. It reads as the grammar does, a value
//! and then what follows each value, so the state between two tokens is the place in its loops and
//! no token tests it. Where it stops, at a token it does not take, the end of the input or the
//! batch's last slot, it names the grammar's state there, with nothing to put back.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const number_grammar = @import("../../number.zig");
const Claims = @import("../../claims.zig").Claims;
const decoder_file = @import("../decoder.zig");
const Expect = decoder_file.Expect;
const Kind = decoder_file.Kind;
const Slot = @import("../decoder_batch.zig").Slot;
const token_loop = @import("decoder_loop.zig");
const Loop = token_loop.Loop;
const copy = @import("decoder_loop_copy.zig");

/// Where a step of `tokens` came to: a value's first octet, with a slot found for the value;
/// the end of a value, a scalar's or a container's; or the token the loop does not take, with the
/// grammar's state there in `Run.stop`.
const Step = enum { value, ended, stop };

/// What `value` took: a scalar, whole; an object's or an array's start; or nothing, with the
/// grammar's state in `Run.stop`.
const Value = enum { ended, object, array, stop };

/// What `tokens` keeps from one step to the next.
const Run = struct {
    /// The next slot to fill, the end of the slots, and the slot the walk began at. A token writes
    /// its slot only where `has_slot` found one left, which `put` asserts. As an index into the
    /// slots with the slot's address beside it, they took four of the loop's values where these
    /// take two: 2 to 3 instructions a token more on aarch64 (design §8 step 18).
    slot: [*]Slot,
    slots_end: [*]Slot,
    first: [*]Slot,
    /// The first octet of the value or of the name a step goes on from.
    octet: u8 = undefined,
    /// Whether the value at hand is an array's first element, whose state also takes the array's
    /// end.
    first_element: bool = false,
    /// The grammar's state where the loop stopped.
    stop: Expect = undefined,

    /// Whether a slot is left for the next token.
    inline fn has_slot(run: *const Run) bool {
        return run.slot != run.slots_end;
    }

    /// Writes the next slot for a token of `kind` whose octets are `output[start..][0..len]`, and
    /// moves past it.
    inline fn put(run: *Run, kind: Kind, start: usize, len: usize) void {
        assert(run.has_slot());
        run.slot[0] = .{ .kind = kind, .ended = true, .start = start, .len = len };
        run.slot += 1;
    }

    /// Stops the loop in `expect`.
    inline fn stopped(run: *Run, expect: Expect) Step {
        run.stop = expect;
        return .stop;
    }

    /// Stops the loop at a value it does not take, an array's `first` element or another.
    inline fn stopped_value(run: *Run, first: bool) Value {
        run.stop = if (first) .value_or_end_array else .value;
        return .stop;
    }
};

/// Fills `slots` from `first` on, where a slot is left, and returns the slots filled, up to the
/// token that stopped it, with `expect` the grammar's state there and nothing to put back.
pub inline fn fill(loop: *Loop, comptime claims: Claims, slots: []Slot, first: usize, output: []const u8) usize {
    assert(first < slots.len);
    var run: Run = .{ .slot = slots.ptr + first, .slots_end = slots.ptr + slots.len, .first = slots.ptr + first };
    loop.expect = tokens(loop, claims, &run, output);
    return run.slot - slots.ptr;
}

/// Takes tokens until one it does not take, and returns the grammar's state there. It reads as
/// the grammar does (RFC 8259 §2 to §5): a value, then what follows a value, in two loops, so
/// the state between two tokens is the place in the loops, and no token tests it. With a function
/// a state that returned the next state to one switch, qlog's records and CLDR's texts took 16 to
/// 21 instructions a token more (design §8 step 18).
inline fn tokens(loop: *Loop, comptime claims: Claims, run: *Run, output: []const u8) Expect {
    switch (enter(loop, claims, run, output)) {
        .stop => return run.stop,
        .value => {},
        .ended => if (!after_values(loop, claims, run, output)) return run.stop,
    }
    // Each pass takes a value, a token at least, into the slot the pass before found for it:
    // the slots bound the loop.
    while (run.has_slot()) {
        switch (value(loop, claims, run, output)) {
            .stop => return run.stop,
            .ended => {},
            .object => switch (object_first(loop, claims, run, output)) {
                .stop => return run.stop,
                .value => continue,
                .ended => {},
            },
            .array => switch (array_first(loop, run, output)) {
                .stop => return run.stop,
                .value => continue,
                .ended => {},
            },
        }
        if (!after_values(loop, claims, run, output)) return run.stop;
    }
    unreachable;
}

/// Goes on from the state the loop begins in, to a value's first octet or to a value's end.
inline fn enter(loop: *Loop, comptime claims: Claims, run: *Run, output: []const u8) Step {
    return switch (loop.expect) {
        .value => value_first(loop, run),
        .value_or_end_array => array_first(loop, run, output),
        .name_or_end_object => object_first(loop, claims, run, output),
        .name => name_next(loop, claims, run, output),
        .name_separator => name_separator(loop, run),
        .separator_or_end => .ended,
        .end_of_text => run.stopped(.end_of_text),
    };
}

/// A value's first octet, where the text begins or the batch does.
inline fn value_first(loop: *Loop, run: *Run) Step {
    run.octet = loop.next_octet() orelse return run.stopped(.value);
    return .value;
}

/// After `[`: the array's first element, or `]` (RFC 8259 §5).
inline fn array_first(loop: *Loop, run: *Run, output: []const u8) Step {
    if (!run.has_slot()) return run.stopped(.value_or_end_array);
    run.octet = loop.next_octet() orelse return run.stopped(.value_or_end_array);
    if (run.octet == constants.end_array) return close(loop, run, .end_array, output);
    run.first_element = true;
    return .value;
}

/// After `{`: the object's first member, up to its value, or `}` (RFC 8259 §4).
inline fn object_first(loop: *Loop, comptime claims: Claims, run: *Run, output: []const u8) Step {
    if (!run.has_slot()) return run.stopped(.name_or_end_object);
    run.octet = loop.next_octet() orelse return run.stopped(.name_or_end_object);
    if (run.octet == constants.end_object) return close(loop, run, .end_object, output);
    return member(loop, claims, run, output, .name_or_end_object);
}

/// A value, from its first octet (RFC 8259 §3): a scalar, taken whole, or a container's start.
inline fn value(loop: *Loop, comptime claims: Claims, run: *Run, output: []const u8) Value {
    const first = run.first_element;
    run.first_element = false;
    switch (run.octet) {
        constants.quotation_mark => {
            const start = loop.written(output);
            const len = copy.string(loop, claims, .string) orelse return run.stopped_value(first);
            run.put(.string, start, len);
            return .ended;
        },
        constants.begin_object => return open(loop, run, true, output, first),
        constants.begin_array => return open(loop, run, false, output, first),
        constants.literal_true[0] => return literal_value(loop, run, .true, constants.literal_true, output, first),
        constants.literal_false[0] => return literal_value(loop, run, .false, constants.literal_false, output, first),
        constants.literal_null[0] => return literal_value(loop, run, .null, constants.literal_null, output, first),
        else => {
            if (!number_grammar.starts_number(run.octet)) return run.stopped_value(first);
            const start = loop.written(output);
            const len = loop.number() orelse return run.stopped_value(first);
            run.put(.number, start, len);
            return .ended;
        },
    }
}

/// An object's or an array's start, as a value.
inline fn open(loop: *Loop, run: *Run, comptime object: bool, output: []const u8, first: bool) Value {
    if (!loop.begin(object)) return run.stopped_value(first);
    run.put(if (object) .begin_object else .begin_array, loop.written(output), 0);
    return if (object) .object else .array;
}

/// The literal name `text`, a value of `kind`.
inline fn literal_value(loop: *Loop, run: *Run, comptime kind: Kind, comptime text: []const u8, output: []const u8, first: bool) Value {
    if (!loop.literal(text)) return run.stopped_value(first);
    run.put(kind, loop.written(output), 0);
    return .ended;
}

/// After a value: the ends of the containers it closes, then a value separator and, in an
/// object, the next member's name and name separator, or the text's end at depth 0, as
/// `Decoder.value_ended` finds it. True at the next value's first octet, and false where the
/// loop stops. Each pass closes a container: the depth bounds the loop.
inline fn after_values(loop: *Loop, comptime claims: Claims, run: *Run, output: []const u8) bool {
    while (loop.depth > 0) {
        switch (after_value(loop, claims, run, output)) {
            .stop => return false,
            .ended => {},
            .value => return true,
        }
    }
    // The text's value just ended, in a slot this walk filled.
    assert(run.slot != run.first);
    loop.decoder.value_delimited = token_loop.is_delimited((run.slot - 1)[0].kind);
    run.stop = .end_of_text;
    return false;
}

/// After one value in a container: the container's end, or its next member or element (RFC
/// 8259 §4, §5).
inline fn after_value(loop: *Loop, comptime claims: Claims, run: *Run, output: []const u8) Step {
    if (!run.has_slot()) return run.stopped(.separator_or_end);
    return if (loop.in_object) after_member(loop, claims, run, output) else after_element(loop, run, output);
}

/// After a member's value: a value separator and the next member, up to its value, or `}`.
inline fn after_member(loop: *Loop, comptime claims: Claims, run: *Run, output: []const u8) Step {
    if (loop.separator_pair(constants.value_separator)) |octet| {
        run.octet = octet;
    } else {
        const octet = loop.next_octet() orelse return run.stopped(.separator_or_end);
        if (octet == constants.end_object) return close(loop, run, .end_object, output);
        if (octet != constants.value_separator) return run.stopped(.separator_or_end);
        loop.in = loop.in[1..];
        run.octet = loop.next_octet() orelse return run.stopped(.name);
    }
    return member(loop, claims, run, output, .name);
}

/// After an element: a value separator and the next element's first octet, or `]`.
inline fn after_element(loop: *Loop, run: *Run, output: []const u8) Step {
    if (loop.separator_pair(constants.value_separator)) |octet| {
        run.octet = octet;
        return .value;
    }
    const octet = loop.next_octet() orelse return run.stopped(.separator_or_end);
    if (octet == constants.end_array) return close(loop, run, .end_array, output);
    if (octet != constants.value_separator) return run.stopped(.separator_or_end);
    loop.in = loop.in[1..];
    run.octet = loop.next_octet() orelse return run.stopped(.value);
    return .value;
}

/// A member past its value separator, with a slot found: its name's first octet, past
/// whitespace, and the member up to its value.
inline fn name_next(loop: *Loop, comptime claims: Claims, run: *Run, output: []const u8) Step {
    run.octet = loop.next_octet() orelse return run.stopped(.name);
    return member(loop, claims, run, output, .name);
}

/// A member, from its name's first octet up to its value's (RFC 8259 §4). Where it takes no
/// name, the loop stops in `at`.
inline fn member(loop: *Loop, comptime claims: Claims, run: *Run, output: []const u8, comptime at: Expect) Step {
    if (run.octet != constants.quotation_mark) return run.stopped(at);
    const start = loop.written(output);
    const len = copy.string(loop, claims, .name) orelse return run.stopped(at);
    run.put(.name, start, len);
    return name_separator(loop, run);
}

/// After a name: a slot for the member's value, its name separator, and the value's first
/// octet (RFC 8259 §4).
inline fn name_separator(loop: *Loop, run: *Run) Step {
    if (!run.has_slot()) return run.stopped(.name_separator);
    if (loop.separator_pair(constants.name_separator)) |octet| {
        run.octet = octet;
        return .value;
    }
    const octet = loop.next_octet() orelse return run.stopped(.name_separator);
    if (octet != constants.name_separator) return run.stopped(.name_separator);
    loop.in = loop.in[1..];
    run.octet = loop.next_octet() orelse return run.stopped(.value);
    return .value;
}

/// A container's end, a token of `kind`.
inline fn close(loop: *Loop, run: *Run, comptime kind: Kind, output: []const u8) Step {
    loop.end(kind);
    run.put(kind, loop.written(output), 0);
    return .ended;
}
