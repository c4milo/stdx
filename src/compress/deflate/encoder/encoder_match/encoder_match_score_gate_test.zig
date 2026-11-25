//! Tests of the gate of decision 72 (`score.Gate`): when a block's lazy steps hold matches, from
//! the held matches the blocks before it decided.

const std = @import("std");
const testing = std.testing;
const constants = @import("../../constants.zig");
const score = @import("encoder_match_score.zig");

/// Counts `holds` held matches into `gate`, `wins` of them won over.
fn count(gate: *score.Gate, holds: u32, wins: u32) void {
    for (0..holds) |index| gate.count(index < wins);
}

test "the gate holds nothing in a stream's first block, and then stops after a block of too few wins" {
    var gate: score.Gate = undefined;
    gate.start();
    try testing.expect(!gate.live);
    gate.end_block();
    try testing.expect(gate.live);
    const holds = 2 * constants.second_holds_min * constants.second_win_divisor;
    const enough = holds / constants.second_win_divisor;
    // One win in `second_win_divisor` keeps the holds, and one win fewer stops them.
    count(&gate, holds, enough);
    gate.end_block();
    try testing.expect(gate.live);
    var wait: u32 = 1;
    for (0..constants.second_wait_max) |_| {
        count(&gate, holds, enough - 1);
        gate.end_block();
        // The blocks of the wait hold nothing, and the block after them holds again.
        for (0..wait) |_| {
            try testing.expect(!gate.live);
            gate.end_block();
        }
        try testing.expect(gate.live);
        wait = @min(wait * constants.second_wait_growth, constants.second_wait_max);
    }
    // A block of enough wins sets the next wait back to one block.
    count(&gate, holds, enough);
    gate.end_block();
    count(&gate, holds, 0);
    gate.end_block();
    try testing.expect(!gate.live);
    gate.end_block();
    try testing.expect(gate.live);
}

test "a block that held fewer matches than second_holds_min leaves the gate as it is" {
    var gate: score.Gate = undefined;
    gate.start();
    gate.end_block();
    count(&gate, constants.second_holds_min - 1, 0);
    gate.end_block();
    try testing.expect(gate.live);
    count(&gate, constants.second_holds_min, 0);
    gate.end_block();
    try testing.expect(!gate.live);
}

test "a block stops its holds at once when its first second_check_holds lost too few" {
    var gate: score.Gate = undefined;
    gate.start();
    gate.end_block();
    const enough = constants.second_check_holds / constants.second_win_divisor;
    // One win too few: the holds go on until the check, and stop there.
    count(&gate, constants.second_check_holds - 1, enough - 1);
    try testing.expect(gate.live);
    gate.count(false);
    try testing.expect(!gate.live);
    // The block's end counts it as a block of too few wins: the next block holds nothing.
    gate.end_block();
    try testing.expect(!gate.live);
    gate.end_block();
    try testing.expect(gate.live);
    // With enough wins the check lets the holds go on.
    count(&gate, constants.second_check_holds, enough);
    try testing.expect(gate.live);
}

test "a block after one that lost too few stops its holds after second_retry_check_holds" {
    var gate: score.Gate = undefined;
    gate.start();
    gate.end_block();
    count(&gate, constants.second_check_holds, 0);
    gate.end_block();
    gate.end_block();
    try testing.expect(gate.live);
    const enough = constants.second_retry_check_holds / constants.second_win_divisor;
    count(&gate, constants.second_retry_check_holds - 1, enough - 1);
    try testing.expect(gate.live);
    gate.count(false);
    try testing.expect(!gate.live);
}
