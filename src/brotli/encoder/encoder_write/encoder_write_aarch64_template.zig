//! The text of the writer of `encoder_write_aarch64.zig`, in the pieces its `template` joins.
//!
//! Registers: x0 the writer's state; x1 the next command and x2 the commands' end; x3 the
//! meta-block's octets, x4 those written so far and x5 their count; x6 the bit buffer, x7 its
//! count, below 8 between puts; x8 the output's next octet and x9 its end. x10 and x11 hold the
//! literal code's codes and lengths, x12 and x13 the command code's, x14 the symbols' lengths, x15
//! and x16 the distance code's codes and lengths, and x17 the distance codes' extra bits. x19
//! holds the command; x20 to x28 each step's values. In the literals, x22 points at the next one,
//! x26 counts those of the command left and x27 those of the chunk.
//!
//! The text writes the numbers the layouts fix, which `encoder_write_aarch64.zig` asserts: codes
//! of 2 octets (a shift of 1), lengths of 1, symbol lengths of 6 octets, commands of 8 with their
//! fields at bits 0, 16, 32 and 42, and 48.
//!
//! The numbered labels: 1 a command, 20 its lengths in two puts, 30 its literals, 31 a chunk, 32 a
//! group of 3 literals, 33 the last 1 or 2, 36 the chunk's end, 40 its distance, 80 an output
//! with no room, 90 the state stored back.

/// One put (`Bits.put` in `encoder_write.zig`): the `count` bits of `value` above the buffer's
/// count, the buffer stored whole, its whole octets counted written, and the bits below an octet
/// kept. It takes `value` and `count` as its temporaries.
pub fn put(comptime value: []const u8, comptime count: []const u8) []const u8 {
    return "    lsl " ++ value ++ ", " ++ value ++ ", x7\n" ++
        "    orr x6, x6, " ++ value ++ "\n" ++
        "    add x7, x7, " ++ count ++ "\n" ++
        "    str x6, [x8]\n" ++
        "    add x8, x8, x7, lsr #3\n" ++
        "    and " ++ count ++ ", x7, #{[whole_bits_mask]}\n" ++
        "    lsr x6, x6, " ++ count ++ "\n" ++
        "    and x7, x7, #7\n";
}

/// The room test (`Bits.check`): the output must hold the buffer's octets, those of `bits` more
/// bits, and a whole store. x20 holds the bits; x21 is its temporary.
pub const check =
    \\    add x20, x20, x7
    \\    lsr x20, x20, #3
    \\    add x20, x20, #{[store_len]}
    \\    sub x21, x9, x8
    \\    cmp x21, x20
    \\    b.lo 80f
;

/// The prologue: the state.
pub const prologue =
    \\    ldp x1, x2, [x0, #{[commands]}]
    \\    ldp x3, x4, [x0, #{[input]}]
    \\    ldp x5, x6, [x0, #{[input_len]}]
    \\    ldp x7, x8, [x0, #{[count]}]
    \\    ldp x9, x10, [x0, #{[room_end]}]
    \\    ldp x11, x12, [x0, #{[literal_lengths]}]
    \\    ldp x13, x14, [x0, #{[command_lengths]}]
    \\    ldp x15, x16, [x0, #{[distance_codes]}]
    \\    ldr x17, [x0, #{[distance_extra_bits]}]
    \\    .p2align 6
;

/// A command: the room for its symbol and lengths, then its symbol's code, and the insert's and
/// the copy's extra bits, in one put where they fit 56 bits, else two.
pub const command_head =
    \\1:
    \\    cmp x1, x2
    \\    b.hs 90f
    \\    ldr x19, [x1], #8
    \\    mov x20, #{[command_bits_max]}
;

pub const command_lengths =
    \\    ubfx x20, x19, #32, #{[symbol_bits]}
    \\    add x21, x20, x20, lsl #1
    \\    add x21, x14, x21, lsl #1
    \\    ldrh w22, [x21]
    \\    ldrh w23, [x21, #2]
    \\    ldrb w24, [x21, #4]
    \\    ldrb w25, [x21, #5]
    \\    and x26, x19, #0xffff
    \\    sub x22, x26, x22
    \\    ubfx x27, x19, #16, #16
    \\    sub x23, x27, x23
    \\    ldrb w28, [x13, x20]
    \\    ldrh w21, [x12, x20, lsl #1]
    \\    lsl x22, x22, x28
    \\    orr x21, x21, x22
    \\    add x28, x28, x24
    \\    add x24, x28, x25
    \\    cmp x24, #{[put_bits_max]}
    \\    b.hi 20f
    \\    lsl x23, x23, x28
    \\    orr x21, x21, x23
;

/// The literals: the octets written so far move past them, then a chunk of up to 64 at a time,
/// each after its room test, 3 a put and the last 1 or 2 in one.
pub const literals_start =
    \\30:
    \\    add x22, x3, x4
    \\    add x4, x4, x26
    \\31:
    \\    cbz x26, 40f
    \\    mov x27, #{[chunk_len]}
    \\    cmp x26, x27
    \\    csel x27, x26, x27, lo
    \\    sub x26, x26, x27
    \\    lsl x20, x27, #4
    \\    sub x20, x20, x27
    \\    add x20, x20, #{[command_bits_max]}
;

/// A chunk's groups of 3 literals, counted first, each in one put: x21 counts them, x27 keeps the
/// last 1 or 2.
pub const literals_group =
    \\    mov w21, #{[third_multiplier]}
    \\    mul w21, w27, w21
    \\    lsr w21, w21, #{[third_shift]}
    \\    add x23, x21, x21, lsl #1
    \\    sub x27, x27, x23
    \\    cbz x21, 33f
    \\    .p2align 4
    \\32:
    \\    ldrb w20, [x22], #1
    \\    ldrh w24, [x10, x20, lsl #1]
    \\    ldrb w20, [x11, x20]
    \\    ldrb w23, [x22], #1
    \\    ldrh w25, [x10, x23, lsl #1]
    \\    ldrb w23, [x11, x23]
    \\    lsl x25, x25, x20
    \\    orr x24, x24, x25
    \\    add x20, x20, x23
    \\    ldrb w23, [x22], #1
    \\    ldrh w25, [x10, x23, lsl #1]
    \\    ldrb w23, [x11, x23]
    \\    lsl x25, x25, x20
    \\    orr x24, x24, x25
    \\    add x20, x20, x23
;

/// The group loop's end, then the last 1 or 2 literals of a chunk in one put, where they take
/// bits.
pub const literals_rest =
    \\    subs x21, x21, #1
    \\    b.ne 32b
    \\33:
    \\    cbz x27, 31b
    \\    ldrb w20, [x22], #1
    \\    ldrh w24, [x10, x20, lsl #1]
    \\    ldrb w20, [x11, x20]
    \\    cmp x27, #2
    \\    b.lo 35f
    \\    ldrb w21, [x22], #1
    \\    ldrh w25, [x10, x21, lsl #1]
    \\    ldrb w21, [x11, x21]
    \\    lsl x25, x25, x20
    \\    orr x24, x24, x25
    \\    add x20, x20, x21
    \\35:
    \\    cbz x20, 31b
;

/// After the literals: the meta-block's end, else the copy, and the distance where the symbol
/// does not leave it out.
pub const distance =
    \\40:
    \\    cmp x4, x5
    \\    b.eq 90f
    \\    ubfx x20, x19, #16, #16
    \\    add x4, x4, x20
    \\    ubfx x20, x19, #32, #{[symbol_bits]}
    \\    cmp x20, #{[last_distance_symbols]}
    \\    b.lo 1b
    \\    ubfx x20, x19, #{[code_at]}, #{[code_bits]}
    \\    ldrb w21, [x16, x20]
    \\    ldrh w23, [x15, x20, lsl #1]
    \\    ldrb w24, [x17, x20]
    \\    lsr x25, x19, #48
    \\    lsl x25, x25, x21
    \\    orr x23, x23, x25
    \\    add x24, x24, x21
;

/// An output with no room, then the state stored back.
pub const exit =
    \\80:
    \\    mov x20, #1
    \\    str x20, [x0, #{[failed]}]
    \\90:
    \\    str x4, [x0, #{[produced]}]
    \\    stp x6, x7, [x0, #{[buffer]}]
    \\    str x8, [x0, #{[room]}]
;
