//! The text of the loop of `fast_sequences_aarch64.zig`, in the pieces its `template` joins.
//!
//! Registers: x0 the loop's state; x1 the stream; x2, x3 and x4 the literals length, offset and
//! match length cells; x5 the bits the sequence reads; x7 the output; x8 the literals; x9 the
//! literals room; x10 the promised room; x11 the position less the 57 bits a load needs before it,
//! negative when the load has not them; x12 the sequences left; x13, x14 and x15 the repeats;
//! x16, x17 and x19 the states of literals length, offset and match length. x6 and x20 to x28 and
//! x30 hold each sequence's values.
//!
//! The numbered labels: 1 a sequence, 2 a repeated offset and 3 the checks where branches take the
//! offset, 4 more literals, 5 the match, 6 a distance below a chunk, 7 more of the match, 8 the
//! next sequence, 9 the state stored back.

/// The prologue, and a sequence's fields and next states.
pub const decode =
    \\    ldp x1, x2, [x0, #{[stream]}]
    \\    ldp x3, x4, [x0, #{[offset]}]
    \\    ldr x7, [x0, #{[output]}]
    \\    ldr x8, [x0, #{[literals]}]
    \\    ldp x9, x10, [x0, #{[literals_room]}]
    \\    ldr x11, [x0, #{[position]}]
    \\    sub x11, x11, #{[read_min]}
    \\    ldr x12, [x0, #{[count]}]
    \\    ldp x13, x14, [x0, #{[repeats]}]
    \\    ldr x15, [x0, #{[repeat3]}]
    \\    ldp x16, x17, [x0, #{[states]}]
    \\    ldr x19, [x0, #{[state3]}]
    \\    cbz x12, 9f
    \\    // The loop starts a fetch line of its own, wherever the code before it ends.
    \\    .p2align 6
    \\1:
    \\    // The load's bits before the position.
    \\    tbnz x11, #63, 9f
    \\    // The cells of the three states. A state is below its table's length: its cell's
    \\    // baseline and the bits it read (RFC 8878 §4.1).
    \\    ldr x20, [x2, x16, lsl #3]
    \\    ldr x21, [x3, x17, lsl #3]
    \\    ldr x22, [x4, x19, lsl #3]
    \\    // The 8 octets whose last holds the position's bit, least significant first, shifted so
    \\    // that bit leads (RFC 8878 §4.1): 57 bits of the stream at least.
    \\    lsr x24, x11, #3
    \\    ldr x24, [x1, x24]
    \\    mvn x25, x11
    \\    and x25, x25, #7
    \\    lsl x24, x24, x25
    \\    // RFC 8878 §3.1.1.3.2.1.2: the offset, match length and literals length bits, then the
    \\    // states of literals length, match length and offset, each from the top of what the
    \\    // fields before it leave. A field of `count` bits: shifted past the bits before it, by
    \\    // one, then by 63 - `count`, so a field of none is 0. x25 counts the bits before it.
    \\    ubfx x25, x21, #{[extra_at]}, #8
    \\    lsr x26, x24, #1
    \\    mvn x27, x25
    \\    lsr x26, x26, x27
    \\    add x26, x26, w21, uxtw
    \\    ubfx x27, x22, #{[extra_at]}, #8
    \\    lsl x28, x24, x25
    \\    lsr x28, x28, #1
    \\    add x25, x25, x27
    \\    mvn x27, x27
    \\    lsr x28, x28, x27
    \\    add x28, x28, w22, uxtw
    \\    ubfx x27, x20, #{[extra_at]}, #8
    \\    lsl x30, x24, x25
    \\    lsr x30, x30, #1
    \\    add x25, x25, x27
    \\    mvn x27, x27
    \\    lsr x30, x30, x27
    \\    add x30, x30, w20, uxtw
    \\    // The next states: each field plus its cell's baseline, the cell's top 16 bits, shifted
    \\    // down as soon as the cell arrives, so the add that waits on the field is a plain one.
    \\    ubfx x27, x20, #{[bits_at]}, #8
    \\    lsr x20, x20, #{[baseline_at]}
    \\    lsl x6, x24, x25
    \\    lsr x6, x6, #1
    \\    add x25, x25, x27
    \\    mvn x27, x27
    \\    lsr x6, x6, x27
    \\    add x20, x6, x20
    \\    ubfx x27, x22, #{[bits_at]}, #8
    \\    lsr x22, x22, #{[baseline_at]}
    \\    lsl x6, x24, x25
    \\    lsr x6, x6, #1
    \\    add x25, x25, x27
    \\    mvn x27, x27
    \\    lsr x6, x6, x27
    \\    add x22, x6, x22
    \\    ubfx x27, x21, #{[bits_at]}, #8
    \\    lsr x21, x21, #{[baseline_at]}
    \\    lsl x6, x24, x25
    \\    lsr x6, x6, #1
    \\    add x5, x25, x27
    \\    mvn x27, x27
    \\    lsr x6, x6, x27
    \\    add x21, x6, x21
;

/// A new offset by one branch, and a repeat by the branches of `repeats_by_branches`.
pub const offsets_by_branches =
    \\    // x26 Offset_Value, x28 the match length, x30 the literals length. An Offset_Value above
    \\    // 3 is a new offset (RFC 8878 §3.1.1.5), and the repeats become it, the first and the
    \\    // second: x26 the distance, x24 and x27 the second and third repeats after it.
    \\    cmp x26, #{[repeat_values]}
    \\    b.ls 2f
    \\    sub x26, x26, #{[repeat_values]}
    \\    mov x24, x13
    \\    mov x27, x14
    \\3:
;

/// Every offset by selects, with no branch to mispredict on a block that mixes new and repeated
/// offsets.
pub const offsets_by_selects =
    \\    // x26 Offset_Value, x28 the match length, x30 the literals length (RFC 8878 §3.1.1.5).
    \\    // An Offset_Value above 3 is a new offset, Offset_Value less 3. One of 1 to 3 names a
    \\    // repeat, the next one when the literals length is 0, and the fourth is the first less
    \\    // one: x6 the repeat's number from 1, above 3 for a new offset; x26 the distance; x24 and
    \\    // x27 the second and third repeats after it.
    \\    cmp x30, #0
    \\    cinc x6, x26, eq
    \\    sub x24, x13, #1
    \\    subs x26, x26, #{[repeat_values]}
    \\    csel x26, x24, x26, ls
    \\    cmp x6, #3
    \\    csel x26, x15, x26, eq
    \\    cmp x6, #2
    \\    csel x26, x14, x26, eq
    \\    csel x26, x13, x26, lo
    \\    csel x27, x15, x14, ls
    \\    csel x24, x14, x13, lo
;

/// The checks of the checked path, up to the window's.
pub const checks =
    \\    // The checks of the checked path, in one branch: the load held the bits read, 57 at least
    \\    // (a sequence of more goes to `step`); the literals are there; the block's size holds; the
    \\    // output holds the sequence's octets and the overrun of its copies; the offset is within
    \\    // Window_Size, and not 0 (invariant 10); and the match reads the call's own output, x25
    \\    // its source, where a match reaching the window goes to `step`. x23 the match's target.
    \\    add x23, x7, x30
    \\    add x25, x23, x28
    \\    ldr x6, [x0, #{[output_limit]}]
    \\    cmp x5, #{[read_min]}
    \\    ccmp x30, x9, #2, ls
    \\    ccmp x28, x10, #2, ls
    \\    ccmp x25, x6, #2, ls
    \\    ldr x6, [x0, #{[window_len]}]
    \\    ccmp x26, x6, #2, ls
;

/// The window's check where branches took the offset: a repeat of 0 left the loop there.
pub const window_by_branches =
    \\    sub x25, x23, x26
    \\    ldr x6, [x0, #{[synced]}]
    \\    ccmp x6, x25, #2, ls
    \\    b.hi 9f
;

/// The window's check where selects took the offset, with the check of an offset of 0, after which
/// a check passes on `ne` rather than `ls`.
pub const window_by_selects =
    \\    ccmp x26, #0, #4, ls
    \\    sub x25, x23, x26
    \\    ldr x6, [x0, #{[synced]}]
    \\    ccmp x6, x25, #2, ne
    \\    b.hi 9f
;

/// The sequence taken: its state, its literals and its match.
pub const copies =
    \\    // The sequence is taken.
    \\    sub x11, x11, x5
    \\    sub x9, x9, x30
    \\    sub x10, x10, x28
    \\    mov x16, x20
    \\    mov x17, x21
    \\    mov x19, x22
    \\    mov x15, x27
    \\    mov x14, x24
    \\    mov x13, x26
    \\    // Its literals, two chunks, then the rest.
    \\    ldp q0, q1, [x8]
    \\    stp q0, q1, [x7]
    \\    cmp x30, #{[pair]}
    \\    b.hi 4f
    \\5:
    \\    // Its match, from x25: a chunk when the distance allows one, then the rest.
    \\    add x8, x8, x30
    \\    cmp x26, #{[chunk]}
    \\    b.lo 6f
    \\    ldr q0, [x25]
    \\    str q0, [x23]
    \\    cmp x28, #{[chunk]}
    \\    b.hi 7f
    \\8:
    \\    add x7, x23, x28
    \\    subs x12, x12, #1
    \\    b.ne 1b
    \\    b 9f
;

/// A repeat by branches, for `offsets_by_branches`.
pub const repeats_by_branches =
    \\2:
    \\    // Offset_Value 1 to 3 names a repeat, the next when the literals length is 0, and the
    \\    // fourth is the first less one (RFC 8878 §3.1.1.5). x6 the repeat's number from 1.
    \\    cmp x30, #0
    \\    cinc x6, x26, eq
    \\    cmp x6, #2
    \\    b.hs 10f
    \\    // The first: the repeats stay.
    \\    mov x26, x13
    \\    mov x24, x14
    \\    mov x27, x15
    \\    cbz x26, 9f
    \\    b 3b
    \\10:
    \\    b.ne 11f
    \\    // The second: it and the first swap.
    \\    mov x26, x14
    \\    mov x24, x13
    \\    mov x27, x15
    \\    cbz x26, 9f
    \\    b 3b
    \\11:
    \\    // The third, or the first less one: it, the first and the second.
    \\    sub x26, x13, #1
    \\    cmp x6, #3
    \\    csel x26, x15, x26, eq
    \\    mov x24, x13
    \\    mov x27, x14
    \\    cbz x26, 9f
    \\    b 3b
;

/// The rest of long literals and matches, and the state stored back.
pub const tail =
    \\4:
    \\    // The literals past the first two chunks, two at a time.
    \\    add x24, x8, #{[pair]}
    \\    add x27, x7, #{[pair]}
    \\    add x6, x7, x30
    \\    .p2align 4
    \\12:
    \\    ldp q0, q1, [x24], #{[pair]}
    \\    stp q0, q1, [x27], #{[pair]}
    \\    cmp x27, x6
    \\    b.lo 12b
    \\    b 5b
    \\7:
    \\    // The match past its first chunk: two chunks at a time where the distance holds two, and
    \\    // one at a time below; each reads octets written before.
    \\    add x24, x25, #{[chunk]}
    \\    add x27, x23, #{[chunk]}
    \\    add x20, x23, x28
    \\    cmp x26, #{[pair]}
    \\    b.lo 15f
    \\    .p2align 4
    \\13:
    \\    ldp q0, q1, [x24], #{[pair]}
    \\    stp q0, q1, [x27], #{[pair]}
    \\    cmp x27, x20
    \\    b.lo 13b
    \\    b 8b
    \\    .p2align 4
    \\15:
    \\    ldr q0, [x24], #{[chunk]}
    \\    str q0, [x27], #{[chunk]}
    \\    cmp x27, x20
    \\    b.lo 15b
    \\    b 8b
    \\6:
    \\    // Below a chunk: the first chunk is the distance's octets repeated, which one table
    \\    // lookup gives from them, each octet's index its place modulo the distance; past it the
    \\    // octets repeat every multiple of the distance, so the rest go a chunk at a time from the
    \\    // least multiple at least a chunk back, in x27. The load reads the chunk from the source,
    \\    // inside the output, whose octets past the distance the indices do not take.
    \\    ldr x6, [x0, #{[patterns]}]
    \\    add x6, x6, x26, lsl #{[chunk_shift]}
    \\    ldr q1, [x6]
    \\    ldr q0, [x25]
    \\    tbl v0.16b, {{v0.16b}}, v1.16b
    \\    str q0, [x23]
    \\    cmp x28, #{[chunk]}
    \\    b.ls 8b
    \\    mov x27, x26
    \\17:
    \\    cmp x27, #{[chunk]}
    \\    b.hs 18f
    \\    add x27, x27, x26
    \\    b 17b
    \\18:
    \\    sub x6, x23, x27
    \\    mov x24, #{[chunk]}
    \\19:
    \\    ldr q0, [x6, x24]
    \\    str q0, [x23, x24]
    \\    add x24, x24, #{[chunk]}
    \\    cmp x24, x28
    \\    b.lo 19b
    \\    b 8b
    \\9:
    \\    str x7, [x0, #{[output]}]
    \\    str x8, [x0, #{[literals]}]
    \\    stp x9, x10, [x0, #{[literals_room]}]
    \\    add x11, x11, #{[read_min]}
    \\    str x11, [x0, #{[position]}]
    \\    ldr x6, [x0, #{[count]}]
    \\    sub x6, x6, x12
    \\    stp x13, x14, [x0, #{[repeats]}]
    \\    str x15, [x0, #{[repeat3]}]
    \\    stp x16, x17, [x0, #{[states]}]
    \\    str x19, [x0, #{[state3]}]
    \\    mov x0, x6
;
