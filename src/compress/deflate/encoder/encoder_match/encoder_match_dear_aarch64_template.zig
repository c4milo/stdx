//! The text of the loop of `encoder_match_dear_aarch64.zig`: the dear blocks' lazy loop (decision
//! 59), in pieces its `template` joins. The search, its links, its compare and its moves are
//! `encoder_match_lazy_aarch64_template.zig`'s, with the registers that file names; the pieces
//! here are the dear blocks' own.
//!
//! Registers as that file's, and beside them: x6 the 3-octet table's candidate through `find`.
//! The table's head, its counts and the table's 3-octet match stay in the state.
//!
//! The numbered labels: 1 a position, 20 a position that searches nothing, 32 the probe of the
//! table's candidate, 49 the walk's end, 51 the lazy step, 60 the waiting position's literal, 70 a
//! match taken, 71 a position it covers, 73 after the 3-octet match's count, 90 the state stored
//! back. The search's labels are the other file's.

/// A position: the loop's bounds, the position joined to its chain and to the 3-octet table, and
/// the lowest position its candidates may lie at. x27 keeps the chain's nearest candidate, and x6
/// the table's.
pub const position =
    \\1:
    \\    ldr x8, [x0, #{[end]}]
    \\    cmp x7, x8
    \\    b.hs 90f
    \\    cmp x9, #{[symbols_max_high]}, lsl #12
    \\    b.hs 90f
    \\    ldr w15, [x1, x7]
    \\    mul w26, w15, w13
    \\    lsr w6, w26, #{[hash_shift]}
    \\    ldrh w27, [x2, x6, lsl #1]
    \\    and x28, x7, #0x7fff
    \\    strh w27, [x3, x28, lsl #1]
    \\    strh w7, [x2, x6, lsl #1]
    \\    lsr w26, w26, #{[three_shift]}
    \\    and w26, w26, #{[three_mask]}
    \\    ldr x28, [x0, #{[three_heads]}]
    \\    ldrh w6, [x28, x26, lsl #1]
    \\    strh w7, [x28, x26, lsl #1]
    \\    mov x26, #{[distance_max]}
    \\    sub x28, x7, x26
    \\    cmp x7, x26
    \\    csinc x14, x28, xzr, hi
;

/// Whether the position searches (`find`): after a match of 4 octets or more, unless it is
/// `lazy_len` long; else where the table's candidate holds the position's 4 octets in reach, or
/// the chain's nearest does (`nearest_holds`). The table's 3-octet match goes to the state, for
/// a position after a literal that finds no match (`probe`).
pub const find =
    \\    cmp x10, #{[match_len_min]}
    \\    b.ls 32f
    \\    cmp x10, #{[lazy_len]}
    \\    b.hs 20f
    \\    b 10f
    \\32:
    \\    ldr w26, [x1, x6]
    \\    eor w26, w26, w15
    \\    sub x28, x7, x6
    \\    sub x28, x28, #1
    \\    lsl w25, w26, #8
    \\    cmp w25, #0
    \\    cset w25, eq
    \\    mov x24, #{[three_distance_max]}
    \\    cmp x28, x24
    \\    cset w24, lo
    \\    and w25, w25, w24
    \\    add x24, x28, #1
    \\    mov x23, #{[match_len_min]}
    \\    cmp w25, #0
    \\    csel x23, x23, xzr, ne
    \\    csel x24, x24, xzr, ne
    \\    stp x23, x24, [x0, #{[three_len]}]
    \\    cmp w26, #0
    \\    cset w26, eq
    \\    cmp x6, #0
    \\    cset w23, ne
    \\    and w26, w26, w23
    \\    mov x23, #{[distance_max]}
    \\    cmp x28, x23
    \\    cset w23, lo
    \\    and w26, w26, w23
    \\    ldr w23, [x1, x27]
    \\    cmp w23, w15
    \\    cset w23, eq
    \\    cmp x27, x14
    \\    cset w24, hs
    \\    and w23, w23, w24
    \\    orr w26, w26, w23
    \\    cbnz w26, 10f
    \\20:
    \\    mov x16, #0
    \\    mov x17, #0
    \\    b 49f
;

/// The lazy step (`decide`): the table's 3-octet match where no match is found and none waits;
/// the waiting match taken where it scores at least the match found (`outscores`, decision 36's
/// score: the length less a penalty of 0 to 3 by the distance's bounds); else the waiting
/// position's literal and the match found waiting.
pub const decide =
    \\49:
    \\    orr x26, x16, x10
    \\    cbnz x26, 51f
    \\    ldp x16, x17, [x0, #{[three_len]}]
    \\51:
    \\    cbz x12, 60f
    \\    cmp x10, #{[match_len_min]}
    \\    b.lo 60f
    \\    cbz x16, 70f
    \\    cmp x11, #{[bound_near]}
    \\    cset x26, hs
    \\    cmp x11, #{[bound_middle]}
    \\    cinc x26, x26, hs
    \\    cmp x11, #{[bound_far]}
    \\    cinc x26, x26, hs
    \\    sub x26, x10, x26
    \\    cmp x17, #{[bound_near]}
    \\    cset x27, hs
    \\    cmp x17, #{[bound_middle]}
    \\    cinc x27, x27, hs
    \\    cmp x17, #{[bound_far]}
    \\    cinc x27, x27, hs
    \\    sub x27, x16, x27
    \\    cmp x26, x27
    \\    b.ge 70f
    \\60:
    \\    cbz x12, 61f
    \\    sub x26, x7, #1
    \\    ldrb w26, [x1, x26]
    \\    str w26, [x4, x9, lsl #2]
    \\    add x9, x9, #1
    \\    ldrh w27, [x5, x26, lsl #1]
    \\    add w27, w27, #1
    \\    strh w27, [x5, x26, lsl #1]
    \\61:
    \\    mov x10, x16
    \\    mov x11, x17
    \\    mov x12, #1
    \\    add x7, x7, #1
    \\    b 1b
;

/// A waiting match taken (`take_waiting`): the positions it covers joined to their chains and to
/// the table, a 3-octet match counted for the table's verdict (`Three.tally`), its pair and its
/// counts added, and the position moved past it.
pub const take =
    \\70:
    \\    add x26, x7, #1
    \\    sub x6, x7, #1
    \\    add x6, x6, x10
    \\    ldr x23, [x0, #{[three_heads]}]
    \\71:
    \\    cmp x26, x6
    \\    b.hs 72f
    \\    ldr w15, [x1, x26]
    \\    mul w15, w15, w13
    \\    lsr w24, w15, #{[hash_shift]}
    \\    ldrh w28, [x2, x24, lsl #1]
    \\    and x27, x26, #0x7fff
    \\    strh w28, [x3, x27, lsl #1]
    \\    strh w26, [x2, x24, lsl #1]
    \\    lsr w24, w15, #{[three_shift]}
    \\    and w24, w24, #{[three_mask]}
    \\    strh w26, [x23, x24, lsl #1]
    \\    add x26, x26, #1
    \\    b 71b
    \\72:
    \\    ldp x27, x28, [x0, #{[near_codes]}]
    \\    sub x15, x11, #1
    \\    lsr x16, x15, #{[far_shift]}
    \\    add x27, x27, x15
    \\    add x28, x28, x16
    \\    cmp x11, #{[near_distances]}
    \\    csel x27, x27, x28, ls
    \\    ldrb w15, [x27]
    \\    cmp x10, #{[match_len_min]}
    \\    b.ne 73f
    \\    sub x26, x7, #1
    \\    ldr x24, [x0, #{[three_octets]}]
    \\    ldrb w25, [x1, x26]
    \\    ldrh w27, [x24, x25, lsl #1]
    \\    add w27, w27, #1
    \\    strh w27, [x24, x25, lsl #1]
    \\    ldrb w25, [x1, x7]
    \\    ldrh w27, [x24, x25, lsl #1]
    \\    add w27, w27, #1
    \\    strh w27, [x24, x25, lsl #1]
    \\    add x26, x7, #1
    \\    ldrb w25, [x1, x26]
    \\    ldrh w27, [x24, x25, lsl #1]
    \\    add w27, w27, #1
    \\    strh w27, [x24, x25, lsl #1]
    \\    ldr x24, [x0, #{[three_distances]}]
    \\    ldrh w27, [x24, x15, lsl #1]
    \\    add w27, w27, #1
    \\    strh w27, [x24, x15, lsl #1]
    \\73:
    \\    sub x16, x10, #{[match_len_min]}
    \\    orr x17, x16, x11, lsl #{[distance_at]}
    \\    orr x17, x17, x15, lsl #{[code_at]}
    \\    str w17, [x4, x9, lsl #2]
    \\    add x9, x9, #1
    \\    ldp x27, x28, [x0, #{[length_codes]}]
    \\    ldrb w16, [x27, x16]
    \\    add x16, x16, #{[first_length_symbol]}
    \\    ldrh w17, [x5, x16, lsl #1]
    \\    add w17, w17, #1
    \\    strh w17, [x5, x16, lsl #1]
    \\    ldrh w17, [x28, x15, lsl #1]
    \\    add w17, w17, #1
    \\    strh w17, [x28, x15, lsl #1]
    \\    mov x7, x6
    \\    mov x10, #0
    \\    mov x11, #0
    \\    mov x12, #0
    \\    b 1b
;
