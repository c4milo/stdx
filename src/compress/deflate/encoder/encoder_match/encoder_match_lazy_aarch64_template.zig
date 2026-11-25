//! The text of the loop of `encoder_match_lazy_aarch64.zig`, in the pieces its `template` joins.
//!
//! Registers: x0 the loop's state; x1 the window, x2 the heads, x3 the chain, x4 the block's
//! symbols and x5 its literal/length counts; x7 the position; x8 the end of the positions, read
//! again at each one; x9 the symbols added; x10 and x11 the waiting match's length and distance,
//! and x12 whether it waits; w13 the hash's multiplier; x14 the lowest position a candidate may lie
//! at; x15 the position's 4 octets; x16 and x17 the match found. The walk keeps x19 its next link,
//! x20 the links it may still read, x21 its floor, x22 its chain's offset, x23 its shift, w24 the
//! 4 octets that decide a candidate and x25 where they start. x6 and x26 to x28 hold each step's
//! values, and the match's compare uses x8 too.
//!
//! The text writes the numbers the layouts fix, which `encoder_match_lazy_aarch64.zig` asserts:
//! a chain slot's mask of 0x7fff, entries of 2 octets in the heads, the chain and the counts (a
//! shift of 1), symbols of 4 octets (a shift of 2), and a `Symbol`'s distance at bit 8 and its
//! code at bit 24.
//!
//! The numbered labels: 1 a position, 10 the search, 20 a position that searches nothing, 30
//! after the waiting match's test, 40 a link of the walk, 44 after a move's skips, 45 after a
//! move, 49 the walk's end, 56 a match's first word that differs, 57 a match that ends after its
//! whole words, 58 the match's length found, 60 the waiting match's position as a literal, 70 a match taken,
//! 71 a position it covers, 90 the state stored back.

/// The prologue: the state.
pub const prologue =
    \\    ldp x1, x2, [x0, #{[window]}]
    \\    ldp x3, x4, [x0, #{[chain]}]
    \\    ldr x5, [x0, #{[literal_length_counts]}]
    \\    ldp x7, x9, [x0, #{[position]}]
    \\    ldp x10, x11, [x0, #{[previous_len]}]
    \\    ldr x12, [x0, #{[waiting]}]
    \\    movz w13, #{[multiplier_low]}
    \\    movk w13, #{[multiplier_high]}, lsl #16
    \\    .p2align 6
;

/// A position: the loop's bounds, the position joined to its chain, and the lowest position its
/// candidates may lie at.
pub const position =
    \\1:
    \\    ldr x8, [x0, #{[end]}]
    \\    cmp x7, x8
    \\    b.hs 90f
    \\    cmp x9, #{[symbols_max_high]}, lsl #12
    \\    b.hs 90f
    \\    ldr w15, [x1, x7]
    \\    mul w26, w15, w13
    \\    lsr w26, w26, #{[hash_shift]}
    \\    ldrh w27, [x2, x26, lsl #1]
    \\    and x28, x7, #0x7fff
    \\    strh w27, [x3, x28, lsl #1]
    \\    strh w7, [x2, x26, lsl #1]
    \\    mov x26, #{[distance_max]}
    \\    sub x6, x7, x26
    \\    cmp x7, x26
    \\    csinc x14, x6, xzr, hi
;

/// Whether the position searches: a waiting match of `lazy_len` is taken with no search, a
/// position after a match found searches, and a position after a literal searches unless its short
/// chain misses, as Zig's aarch64 form reads it (`short_chain_misses`): the nearest candidate in
/// reach, or the position itself, on one branch where it holds the position's 4 octets; then the
/// one after it in reach, or the first again, and the walk runs where the nearest is in reach and
/// either holds them, or where a third lies in reach, on one more branch.
pub const skips =
    \\    cbz x12, 30f
    \\    cmp x10, #{[lazy_len]}
    \\    b.hs 20f
    \\30:
    \\    cbnz x10, 10f
    \\    cmp x27, x14
    \\    csel x6, x27, x7, hs
    \\    cset w28, hs
    \\    ldr w26, [x1, x6]
    \\    cmp w26, w15
    \\    cset w25, eq
    \\    and w26, w28, w25
    \\    cbnz w26, 10f
    \\    and x26, x6, #0x7fff
    \\    ldrh w26, [x3, x26, lsl #1]
    \\    cmp x26, x14
    \\    csel x6, x26, x6, hs
    \\    ldr w26, [x1, x6]
    \\    cmp w26, w15
    \\    cset w26, eq
    \\    orr w25, w25, w26
    \\    and x26, x6, #0x7fff
    \\    ldrh w26, [x3, x26, lsl #1]
    \\    and w25, w25, w28
    \\    cmp x26, x14
    \\    cset w26, hs
    \\    orr w25, w25, w26
    \\    cbnz w25, 10f
    \\20:
    \\    mov x16, #0
    \\    mov x17, #0
    \\    b 49f
;

/// The search's start: none found, the budget, and the position's own chain.
pub const search =
    \\10:
    \\    mov x16, #0
    \\    mov x17, #0
    \\    mov x20, #{[candidates_max]}
    \\    mov x26, #{[cut_candidates_max]}
    \\    cmp x10, #{[cut_len]}
    \\    csel x20, x26, x20, hs
    \\    mov x19, x27
    \\    mov x21, x14
    \\    mov x22, #0
    \\    mov x23, #0
    \\    mov w24, w15
    \\    mov x25, #0
;

/// A link: the walk ends at its budget, at a chain's end or out of reach; a candidate whose
/// deciding octets differ, or whose first 4 do, is passed.
pub const link =
    \\40:
    \\    cbz x20, 49f
    \\    cmp x19, x21
    \\    b.lo 49f
    \\    mov x26, x19
    \\    and x28, x26, #0x7fff
    \\    ldrh w19, [x3, x28, lsl #1]
    \\    sub x20, x20, #1
    \\    add x28, x26, x23
    \\    ldr w28, [x1, x28]
    \\    cmp w28, w24
    \\    b.ne 40b
    \\    sub x26, x26, x22
    \\    ldr w28, [x1, x26]
    \\    cmp w28, w15
    \\    b.ne 40b
    \\    add x6, x1, x26
    \\    add x8, x1, x7
;

/// One 8-octet word of the match's compare, at the candidate (x6) and at the position (x8).
pub const compare_word =
    \\    ldr x27, [x6], #8
    \\    ldr x28, [x8], #8
    \\    eor x27, x27, x28
    \\    cbnz x27, 56f
;

/// The compare's last octets, past its whole words, and the length it finds.
pub const compare_end =
    \\    ldrb w27, [x6]
    \\    ldrb w28, [x8]
    \\    cmp w27, w28
    \\    b.ne 57f
    \\    ldrb w27, [x6, #1]
    \\    ldrb w28, [x8, #1]
    \\    mov x6, #{[words_len_plus_one]}
    \\    cmp w27, w28
    \\    cinc x6, x6, eq
    \\    b 58f
    \\56:
    \\    rbit x27, x27
    \\    clz x27, x27
    \\    sub x6, x6, x1
    \\    sub x6, x6, x26
    \\    sub x6, x6, #8
    \\    add x6, x6, x27, lsr #3
    \\    b 58f
    \\57:
    \\    mov x6, #{[words_len]}
;

/// The match's length, and what a longer one moves: a match of `nice_len` or `match_len_max`
/// ends the walk, the walk's own chain ended or the candidates passed end it, and else the tail
/// decides the candidates left, on the tail's chain where fewer remain there.
pub const longer =
    \\58:
    \\    cmp x6, x16
    \\    b.ls 40b
    \\    mov x16, x6
    \\    sub x17, x7, x26
    \\    cmp x6, #{[nice_len]}
    \\    b.hs 49f
    \\    cmp x19, x21
    \\    b.lo 49f
    \\    subs x28, x7, x16
    \\    csel x28, xzr, x28, lo
    \\    cmp x26, x28
    \\    csel x28, x26, x28, lo
    \\    cmp x28, x14
    \\    b.ls 49f
    \\    sub x25, x16, #{[tail_back]}
    \\    add x6, x7, x25
    \\    ldr w24, [x1, x6]
    \\    sub x6, x19, x22
    \\    sub x6, x26, x6
    \\    mov x27, #{[move_candidates_min]}
    \\    mul x6, x6, x27
    \\    sub x27, x26, x14
    \\    cmp x6, x27
    \\    b.hi 45f
    \\    add x28, x28, x25
    \\    mul w6, w24, w13
    \\    lsr w6, w6, #{[hash_shift]}
    \\    ldrh w6, [x2, x6, lsl #1]
;

/// One skip of a move: a link of the tail's chain whose candidate the walk has passed, which the
/// walk's budget pays for.
pub const skip =
    \\    cmp x6, x28
    \\    b.lo 44f
    \\    and x26, x6, #0x7fff
    \\    ldrh w6, [x3, x26, lsl #1]
    \\    subs x20, x20, #1
    \\    csel x20, xzr, x20, lo
;

/// The move's test, the walk's new floor and shift, and the walk's end.
pub const moved =
    \\44:
    \\    cmp x6, x28
    \\    b.hs 45f
    \\    add x26, x6, x22
    \\    add x27, x19, x25
    \\    cmp x26, x27
    \\    b.hs 45f
    \\    mov x19, x6
    \\    mov x22, x25
    \\45:
    \\    add x21, x14, x22
    \\    sub x23, x25, x22
    \\    b 40b
;

/// The lazy step: the waiting match taken unless the match found scores more by decision 52's
/// compare, else the waiting position's literal and the match found waiting.
pub const decide =
    \\49:
    \\    cbz x12, 60f
    \\    cmp x10, #{[match_len_taken_min]}
    \\    b.lo 60f
    \\    cmp x16, x10
    \\    b.lo 70f
    \\    clz x26, x17
    \\    clz x27, x11
    \\    add x26, x26, x16, lsl #{[weight_shift]}
    \\    add x27, x27, x10, lsl #{[weight_shift]}
    \\    add x27, x27, #{[margin]}
    \\    cmp x26, x27
    \\    b.ls 70f
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

/// A waiting match taken: the positions it covers joined to their chains, its pair and its counts
/// added, and the position moved past it.
pub const take =
    \\70:
    \\    add x26, x7, #1
    \\    sub x6, x7, #1
    \\    add x6, x6, x10
    \\71:
    \\    cmp x26, x6
    \\    b.hs 72f
    \\    ldr w15, [x1, x26]
    \\    mul w15, w15, w13
    \\    lsr w15, w15, #{[hash_shift]}
    \\    ldrh w28, [x2, x15, lsl #1]
    \\    and x27, x26, #0x7fff
    \\    strh w28, [x3, x27, lsl #1]
    \\    strh w26, [x2, x15, lsl #1]
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

/// The state stored back.
pub const exit =
    \\90:
    \\    stp x7, x9, [x0, #{[position]}]
    \\    stp x10, x11, [x0, #{[previous_len]}]
    \\    str x12, [x0, #{[waiting]}]
;
