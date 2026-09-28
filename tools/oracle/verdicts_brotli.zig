//! The verdict entries of decision 15 for the brotli decoder, whose one oracle is Google's brotli:
//! every case where the two give an input different verdicts, with the RFC section that decides it
//! and the decision behind stdx's choice. tools/oracle/verdicts.zig exports these, and its rules for
//! an entry hold here too.

const std = @import("std");
const Kind = @import("verdicts.zig").Kind;

/// What the brotli check knows about an input: its octets, and how many of them Google's decoder
/// took.
pub const BrotliFacts = struct {
    input: []const u8,
    oracle_consumed: usize = 0,
};

pub const BrotliEntry = struct {
    shape: []const u8,
    /// Whether an input has the shape.
    holds: *const fn (facts: BrotliFacts) bool,
    stdx: Kind,
    /// The name of stdx's error, when it refused.
    stdx_error: []const u8 = "",
    google: Kind,
    rfc: []const u8,
    decision: []const u8,
};

pub const entries = [_]BrotliEntry{
    .{
        .shape = "a complex prefix code's code lengths sum past 32768, and Google's decoder takes the " ++
            "whole input and asks for more",
        .holds = oracle_took_everything,
        .stdx = .refused,
        .stdx_error = "OverSubscribedCode",
        .google = .incomplete,
        .rfc = "RFC 7932 §3.5: the sum of 32768 >> code length over the non-zero code lengths must equal " ++
            "32768; once the sum passes it, no continuation of the stream conforms",
        .decision = "decision 15: stdx refuses a stream as soon as no continuation can conform; Google's " ++
            "decoder reads on and asks for input the stream does not have",
    },
};

fn oracle_took_everything(facts: BrotliFacts) bool {
    return facts.oracle_consumed == facts.input.len;
}

/// The index in `entries` of the entry that allows the disagreement, if one does.
pub fn find(facts: BrotliFacts, stdx: Kind, stdx_error: []const u8, google: Kind) ?usize {
    for (entries, 0..) |entry, index| {
        if (entry.stdx != stdx or entry.google != google) continue;
        if (!std.mem.eql(u8, entry.stdx_error, stdx_error)) continue;
        if (!entry.holds(facts)) continue;
        return index;
    }
    return null;
}

test "the over-subscribed code entry holds where Google's decoder took the whole input" {
    const input = "\x00\x01\x02";
    try std.testing.expect(find(.{ .input = input, .oracle_consumed = 3 }, .refused, "OverSubscribedCode", .incomplete) != null);
    try std.testing.expect(find(.{ .input = input, .oracle_consumed = 2 }, .refused, "OverSubscribedCode", .incomplete) == null);
    try std.testing.expect(find(.{ .input = input, .oracle_consumed = 3 }, .refused, "IncompleteCode", .incomplete) == null);
}

test "every brotli entry cites an RFC section and a decision" {
    for (entries) |entry| {
        try std.testing.expect(std.mem.indexOf(u8, entry.rfc, "RFC ") != null);
        try std.testing.expect(std.mem.indexOf(u8, entry.rfc, "§") != null);
        try std.testing.expect(entry.decision.len > 0);
        try std.testing.expect((entry.stdx == .refused) == (entry.stdx_error.len > 0));
    }
}
