//! The text of the loop of `encoder_parse_aarch64.zig`, in the pieces its `template` joins.
//!
//! Registers: x0 the loop's state; x1 the window, x2 the short table, x3 the long table, w4 the
//! tables' base; x5 the position, x6 the anchor, x7 the block's end, x8 the search's end, x9 the
//! window's reach; x10 a literal's cost; x11 the commands, x12 their count; x13 the hash's
//! multiplier; x14 the literal counts; x15 the literals the commands inserted; w16, w17, w19 and
//! w20 the last distances, the last first. x21 to x28 hold each step's values: at label 40, x24 is
//! the match's position and x25 its candidate.
//!
//! The text writes the numbers the layouts fix, which `encoder_parse_aarch64.zig` asserts: table
//! entries of 4 octets (a shift of 2), counts and symbols of 2 (a shift of 1), commands of 8 (a
//! shift of 3), the hashes' shifts, and a command's fields at bits 0, 16, 32 and 48.
//!
//! The numbered labels: 1 a position, 3 the long table, 4 the short table, 6 a short match taken,
//! 8 a miss, 40 a match stepped back, 42 its length, 46 its cost, 47 its literals counted, 50 its
//! distance code, 56 its symbol, 60 the command recorded, 66 the positions it covers, 80 a command
//! for Zig, 90 the state stored back.

/// The prologue: the state.
pub const prologue =
    \\    ldp x1, x2, [x0, #{[window]}]
    \\    ldp x3, x4, [x0, #{[long]}]
    \\    ldp x5, x6, [x0, #{[position]}]
    \\    ldp x7, x8, [x0, #{[end]}]
    \\    ldp x9, x10, [x0, #{[reach]}]
    \\    ldp x11, x12, [x0, #{[commands]}]
    \\    ldp x14, x15, [x0, #{[literal_counts]}]
    \\    ldp w16, w17, [x0, #{[ring]}]
    \\    ldp w19, w20, [x0, #{[ring_back]}]
    \\    movz x13, #{[multiplier_0]}
    \\    movk x13, #{[multiplier_1]}, lsl #16
    \\    movk x13, #{[multiplier_2]}, lsl #32
    \\    movk x13, #{[multiplier_3]}, lsl #48
    \\    .p2align 6
;

/// A position: the search's end, its 8 octets, its entry and the range of its candidates, both
/// tables read and written, then the last distance after a literal.
pub const position =
    \\1:
    \\    cmp x5, x8
    \\    b.hs 90f
    \\    cmp x5, x9
    \\    b.hi 100f
    \\    ldr x21, [x1, x5]
    \\    add w22, w4, w5
    \\    subs x23, x5, #1
    \\    csel x23, xzr, x23, lo
    \\    lsl x24, x21, #{[short_shift]}
    \\    mul x24, x24, x13
    \\    lsr x24, x24, #{[hash_shift]}
    \\    mul x25, x21, x13
    \\    lsr x25, x25, #{[hash_shift]}
    \\    ldr w26, [x2, x24, lsl #2]
    \\    ldr w27, [x3, x25, lsl #2]
    \\    str w22, [x2, x24, lsl #2]
    \\    str w22, [x3, x25, lsl #2]
    \\    cmp x5, x6
    \\    b.eq 3f
    \\    sub w24, w16, #1
    \\    cmp w24, w23
    \\    b.hs 3f
    \\    sub x25, x5, x16
    \\    ldr w24, [x1, x25]
    \\    cmp w24, w21
    \\    b.ne 3f
    \\    mov x24, x5
    \\    b 40f
;

/// The far copy's position: past the reach, every range ends at it, so the limit is x9 and the
/// last distance always lies in range (`encoder_parse_aarch64.zig` asserts it). Its labels repeat
/// the near copy's, and each branch reaches the nearest, inside its own copy.
pub const position_far =
    \\100:
    \\1:
    \\    cmp x5, x8
    \\    b.hs 90f
    \\    ldr x21, [x1, x5]
    \\    add w22, w4, w5
    \\    lsl x24, x21, #{[short_shift]}
    \\    mul x24, x24, x13
    \\    lsr x24, x24, #{[hash_shift]}
    \\    mul x25, x21, x13
    \\    lsr x25, x25, #{[hash_shift]}
    \\    ldr w26, [x2, x24, lsl #2]
    \\    ldr w27, [x3, x25, lsl #2]
    \\    str w22, [x2, x24, lsl #2]
    \\    str w22, [x3, x25, lsl #2]
    \\    cmp x5, x6
    \\    b.eq 3f
    \\    sub x25, x5, x16
    \\    ldr w24, [x1, x25]
    \\    cmp w24, w21
    \\    b.ne 3f
    \\    mov x24, x5
    \\    b 40f
;

/// The long table's candidate, then the short table's, then the long table's at the next position
/// after a short match: a distance from 1 to the range's limit, and its octets compared.
pub const tables =
    \\3:
    \\    sub w24, w22, w27
    \\    sub w28, w24, #1
    \\    cmp w28, w23
    \\    b.hs 4f
    \\    sub x25, x5, x24
    \\    ldr x28, [x1, x25]
    \\    cmp x28, x21
    \\    b.ne 4f
    \\    mov x24, x5
    \\    b 40f
    \\4:
    \\    sub w24, w22, w26
    \\    sub w28, w24, #1
    \\    cmp w28, w23
    \\    b.hs 8f
    \\    sub x25, x5, x24
    \\    ldr w28, [x1, x25]
    \\    cmp w28, w21
    \\    b.ne 8f
    \\    add x24, x5, #{[read_after]}
    \\    cmp x24, x7
    \\    b.hi 6f
    \\    add x26, x5, #1
    \\    ldr x27, [x1, x26]
    \\    mul x28, x27, x13
    \\    lsr x28, x28, #{[hash_shift]}
    \\    cmp x26, x9
    \\    csel x23, x9, x5, hi
    \\    ldr w21, [x3, x28, lsl #2]
    \\    add w22, w22, #1
    \\    str w22, [x3, x28, lsl #2]
    \\    sub w24, w22, w21
    \\    sub w21, w24, #1
    \\    cmp w21, w23
    \\    b.hs 6f
    \\    sub x21, x26, x24
    \\    ldr x28, [x1, x21]
    \\    cmp x28, x27
    \\    b.ne 6f
    \\    mov x24, x26
    \\    mov x25, x21
    \\    b 40f
    \\6:
    \\    mov x24, x5
    \\    b 40f
    \\8:
    \\    sub x24, x5, x6
    \\    add x5, x5, x24, lsr #{[skip_log]}
    \\    add x5, x5, #1
    \\    b 1b
;

/// The far copy's tables: the limit is x9, the reach, at the next position too.
pub const tables_far =
    \\3:
    \\    sub w24, w22, w27
    \\    sub w28, w24, #1
    \\    cmp w28, w9
    \\    b.hs 4f
    \\    sub x25, x5, x24
    \\    ldr x28, [x1, x25]
    \\    cmp x28, x21
    \\    b.ne 4f
    \\    mov x24, x5
    \\    b 40f
    \\4:
    \\    sub w24, w22, w26
    \\    sub w28, w24, #1
    \\    cmp w28, w9
    \\    b.hs 8f
    \\    sub x25, x5, x24
    \\    ldr w28, [x1, x25]
    \\    cmp w28, w21
    \\    b.ne 8f
    \\    add x24, x5, #{[read_after]}
    \\    cmp x24, x7
    \\    b.hi 6f
    \\    add x26, x5, #1
    \\    ldr x27, [x1, x26]
    \\    mul x28, x27, x13
    \\    lsr x28, x28, #{[hash_shift]}
    \\    ldr w21, [x3, x28, lsl #2]
    \\    add w22, w22, #1
    \\    str w22, [x3, x28, lsl #2]
    \\    sub w24, w22, w21
    \\    sub w21, w24, #1
    \\    cmp w21, w9
    \\    b.hs 6f
    \\    sub x21, x26, x24
    \\    ldr x28, [x1, x21]
    \\    cmp x28, x27
    \\    b.ne 6f
    \\    mov x24, x26
    \\    mov x25, x21
    \\    b 40f
    \\6:
    \\    mov x24, x5
    \\    b 40f
    \\8:
    \\    sub x24, x5, x6
    \\    add x5, x5, x24, lsr #{[skip_log]}
    \\    add x5, x5, #1
    \\    b 1b
;

/// The match stepped back over the literals while the octets before both agree, its length to the
/// block's end, 8 octets a compare, and its cost against its literals'.
pub const extend =
    \\40:
    \\    cmp x24, x6
    \\    b.ls 42f
    \\    cbz x25, 42f
    \\    sub x26, x24, #1
    \\    ldrb w27, [x1, x26]
    \\    sub x28, x25, #1
    \\    ldrb w28, [x1, x28]
    \\    cmp w27, w28
    \\    b.ne 42f
    \\    mov x24, x26
    \\    sub x25, x25, #1
    \\    b 40b
    \\42:
    \\    sub x26, x7, x24
    \\    mov x27, #0
    \\43:
    \\    sub x28, x26, x27
    \\    cmp x28, #8
    \\    b.lo 45f
    \\    add x22, x25, x27
    \\    ldr x22, [x1, x22]
    \\    add x23, x24, x27
    \\    ldr x23, [x1, x23]
    \\    eor x22, x22, x23
    \\    cbnz x22, 44f
    \\    add x27, x27, #8
    \\    b 43b
    \\44:
    \\    rbit x22, x22
    \\    clz x22, x22
    \\    add x27, x27, x22, lsr #3
    \\    b 46f
    \\45:
    \\    cmp x27, x26
    \\    b.hs 46f
    \\    add x22, x25, x27
    \\    ldrb w22, [x1, x22]
    \\    add x23, x24, x27
    \\    ldrb w23, [x1, x23]
    \\    cmp w22, w23
    \\    b.ne 46f
    \\    add x27, x27, #1
    \\    b 45b
    \\46:
    \\    sub x26, x24, x25
    \\    clz x22, x26
    \\    mov x23, #63
    \\    sub x22, x23, x22
    \\    lsl x22, x22, #{[eighths_shift]}
    \\    add x22, x22, #{[match_cost_base]}
    \\    mul x23, x27, x10
    \\    cmp x23, x22
    \\    b.ls 8b
    \\    sub x28, x24, x6
    \\    cmp x28, #{[length_table_len]}
    \\    b.hs 80f
    \\    cmp x27, #{[length_table_len]}
    \\    b.hs 80f
;

/// The command: its literals counted, its distance's code, the ring of last distances moved, its
/// symbol, its record and its counts. x28 holds the insert's length, x27 the copy's, x26 the
/// distance.
pub const command =
    \\    add x21, x1, x6
    \\    add x23, x1, x24
    \\    cmp x21, x23
    \\    b.hs 48f
    \\47:
    \\    ldrb w22, [x21], #1
    \\    ldrh w25, [x14, x22, lsl #1]
    \\    add w25, w25, #1
    \\    strh w25, [x14, x22, lsl #1]
    \\    cmp x21, x23
    \\    b.lo 47b
    \\48:
    \\    add x15, x15, x28
    \\    mov x22, #0
    \\    mov x21, #0
    \\    cmp w26, w16
    \\    b.eq 56f
    \\    mov x21, #1
    \\    cmp w26, w17
    \\    b.eq 52f
    \\    mov x21, #2
    \\    cmp w26, w19
    \\    b.eq 52f
    \\    mov x21, #3
    \\    cmp w26, w20
    \\    b.eq 52f
    \\50:
    \\    add w23, w26, #{[distance_offset]}
    \\    clz w25, w23
    \\    mov w21, #30
    \\    sub w21, w21, w25
    \\    lsr w25, w23, w21
    \\    and w25, w25, #1
    \\    add w22, w25, #{[distance_prefix_base]}
    \\    lsl w22, w22, w21
    \\    sub w22, w23, w22
    \\    lsl w21, w21, #1
    \\    add w21, w21, w25
    \\    add w21, w21, #{[code_from_bits]}
    \\52:
    \\    mov w20, w19
    \\    mov w19, w17
    \\    mov w17, w16
    \\    mov w16, w26
    \\56:
    \\    cmp x21, #0
    \\    cset x25, eq
    \\    cmp x28, #{[small_insert_len]}
    \\    b.hs 57f
    \\    cmp x27, #{[small_copy_len]}
    \\    b.hs 57f
    \\    ldr x23, [x0, #{[small_symbols]}]
    \\    lsl x26, x25, #{[small_last_shift]}
    \\    add x26, x26, x28, lsl #{[small_insert_shift]}
    \\    add x26, x26, x27
    \\    ldrh w26, [x23, x26, lsl #1]
    \\    b 60f
    \\57:
    \\    ldp x23, x26, [x0, #{[insert_codes]}]
    \\    ldrb w23, [x23, x28]
    \\    ldrb w26, [x26, x27]
    \\    mov x24, #{[codes_count]}
    \\    madd x23, x25, x24, x23
    \\    madd x26, x23, x24, x26
    \\    ldr x23, [x0, #{[insert_copy_symbols]}]
    \\    ldrh w26, [x23, x26, lsl #1]
;

/// The record, its counts, the positions the match covers in both tables, and the next position.
/// x24 holds the match's position again, from x5 and x28.
pub const record =
    \\60:
    \\    add x24, x6, x28
    \\    orr x23, x28, x27, lsl #16
    \\    orr x25, x26, x21, lsl #{[symbol_bits]}
    \\    orr x23, x23, x25, lsl #32
    \\    orr x23, x23, x22, lsl #48
    \\    str x23, [x11, x12, lsl #3]
    \\    add x12, x12, #1
    \\    ldp x23, x25, [x0, #{[command_counts]}]
    \\    ldrh w22, [x23, x26, lsl #1]
    \\    add w22, w22, #1
    \\    strh w22, [x23, x26, lsl #1]
    \\    cmp x26, #{[last_distance_symbols]}
    \\    b.lo 62f
    \\    ldrh w22, [x25, x21, lsl #1]
    \\    add w22, w22, #1
    \\    strh w22, [x25, x21, lsl #1]
    \\62:
    \\    add x6, x24, x27
    \\    mov x5, x6
    \\    add x21, x24, #{[insert_skip]}
    \\    cmp x6, x8
    \\    csel x22, x6, x8, lo
    \\    add x23, x21, #{[insert_tail]}
    \\    cmp x22, x23
    \\    b.lo 1b
    \\    sub x22, x22, #{[insert_tail]}
    \\66:
    \\    ldr x23, [x1, x21]
    \\    add w24, w4, w21
    \\    lsl x25, x23, #{[short_shift]}
    \\    mul x25, x25, x13
    \\    lsr x25, x25, #{[hash_shift]}
    \\    str w24, [x2, x25, lsl #2]
    \\    mul x25, x23, x13
    \\    lsr x25, x25, #{[hash_shift]}
    \\    str w24, [x3, x25, lsl #2]
    \\    add x21, x21, #{[insert_step]}
    \\    cmp x21, x22
    \\    b.ls 66b
    \\    ldr x23, [x1, x22]
    \\    add w24, w4, w22
    \\    lsl x25, x23, #{[short_shift]}
    \\    mul x25, x25, x13
    \\    lsr x25, x25, #{[hash_shift]}
    \\    str w24, [x2, x25, lsl #2]
    \\    mul x25, x23, x13
    \\    lsr x25, x25, #{[hash_shift]}
    \\    str w24, [x3, x25, lsl #2]
    \\    b 1b
;

/// A command the text leaves to Zig, whose lengths pass its tables, then the state stored back.
pub const exit =
    \\80:
    \\    mov x21, #1
    \\    stp x24, x27, [x0, #{[found_position]}]
    \\    stp x26, x21, [x0, #{[found_offset]}]
    \\90:
    \\    stp x5, x6, [x0, #{[position]}]
    \\    str x12, [x0, #{[count]}]
    \\    str x15, [x0, #{[inserted]}]
    \\    stp w16, w17, [x0, #{[ring]}]
    \\    stp w19, w20, [x0, #{[ring_back]}]
;
