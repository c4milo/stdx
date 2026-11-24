//! What a searcher reads of a program that holds the text's start or its end (claims R11, R12
//! and R13, decision 86): whether every match starts at the text's start, and whether every
//! match ends at its end.
const program_file = @import("../program.zig");
const Program = program_file.Program;

/// True when every match starts at the text's start: the forward program asserts it before it
/// takes a byte or splits.
pub fn starts_at_text_start(program: *const Program) bool {
    return opens_at_text_edge(program, program.forward);
}

/// True when every match ends at the text's end. The reverse program reads a match backward, so
/// it then asserts that no byte stands behind it, before it takes a byte or splits. False
/// for a program with no reverse half.
pub fn ends_at_text_end(program: *const Program) bool {
    return program.reverse != program_file.no_entry and opens_at_text_edge(program, program.reverse);
}

/// True when the program at `entry` asserts `behind_text` before it takes a byte or splits.
fn opens_at_text_edge(program: *const Program, entry: u32) bool {
    var index = entry;
    // The walk follows `out`, and reads each instruction once.
    for (0..program.instructions.len) |_| {
        const instruction = program.instructions[index];
        switch (instruction.kind) {
            .save, .jump => index = instruction.out,
            .look => {
                if (instruction.look == .behind_text) return true;
                index = instruction.out;
            },
            else => return false,
        }
    }
    return false;
}
