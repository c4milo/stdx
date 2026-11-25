//! The text of the loop of `fast_aarch64.zig`, in the pieces its `template` joins.
//!
//! Registers: x0 the loop's state; x1 the input's next octet and x2 the last place an 8-octet load
//! may start; x3 the output's next octet, x4 the last place an iteration may start and x5 the
//! call's first octet; x6 the bit buffer and w7 its count, in its low octet; x8 and x9 the
//! literal/length table and its index mask; x10 and x11 the distance table and its mask; x12 the
//! farthest distance; x13 each distance symbol's base and mask; x14 the next symbol's entry; x22
//! the bits of a count that count whole octets, x23 all ones and x24 the longest match; x25 the
//! symbols decoded, in a test build. x15 to x17, x19 to x21 and x26 to x28 hold each symbol's
//! values.
//!
//! Each of the buffer's 64 bits is the stream's: a refill ORs the next 8 octets in above the
//! count, and an iteration uses 55 bits at most, so each lookup reads bits of the stream. A symbol
//! subtracts its whole entry from the count, whose low octet the entry's low octet, its bits,
//! keeps exact.
//!
//! The text writes the numbers the hardware and the entry's layout fix, which `fast_aarch64.zig`
//! asserts: a buffer of 64 bits, whose count's bits 3 to 5 (0x38) count its whole octets and whose
//! low octet (0xff) holds the count; entries of 4 octets (a shift of 2); a distance symbol of 5
//! bits; and 0 and 1 for `fast.Stop`'s margin and rare.
//!
//! The numbered labels: 1 an iteration, 3 a match, 4 a length's own entry, 5 the refill after
//! literals, 51 the refill before the lookup after a run's last literal, 6 the match's copy, 7 the
//! next symbol, 8 the refill after a match, 70 and 71 a match's
//! other cases, the last a distance below a chunk, 72, 74, 76, 77 and 78 the rest of a match, 94
//! to 97 a literal/length code longer than the table, 80 and 90 the exits, 99 the state stored
//! back.

/// The prologue: the state, a refill, and the first symbol's entry.
pub const prologue =
    \\    ldp x1, x2, [x0, #{[input]}]
    \\    ldp x3, x4, [x0, #{[output]}]
    \\    ldr x5, [x0, #{[output_start]}]
    \\    ldp x6, x7, [x0, #{[buffer]}]
    \\    ldp x8, x9, [x0, #{[literal_length_entries]}]
    \\    ldp x10, x11, [x0, #{[distance_entries]}]
    \\    ldp x12, x13, [x0, #{[distance_max]}]
    \\    mov x22, #0x38
    \\    mov x23, #-1
    \\    mov x24, #{[match_len_max]}
    \\    {[load_decoded]s}
    \\    // A buffer of fewer than 64 bits takes the next 8 octets above its count (S1), so each of
    \\    // its 64 bits is the stream's; a full one is the stream's already.
    \\    cmp x7, #64
    \\    b.hs 20f
    \\    ldr x16, [x1]
    \\    lsl x16, x16, x7
    \\    orr x6, x6, x16
    \\    bic x16, x22, x7
    \\    add x1, x1, x16, lsr #3
    \\    orr w7, w7, #{[refill_bits]}
    \\20:
    \\    and x16, x6, x9
    \\    ldr w14, [x8, x16, lsl #2]
    \\    // The loop starts a fetch line of its own, wherever the code before it ends.
    \\    .p2align 6
;

/// An iteration's margins and its symbol's kind. Each iteration writes an octet at least, so the
/// output margin ends the loop.
pub const iteration =
    \\1:
    \\    // Decision 16's margins: the 8 octets of the refill, and the room of a longest match and
    \\    // its last chunk's overrun.
    \\    cmp x1, x2
    \\    ccmp x3, x4, #2, ls
    \\    b.hi 80f
    \\    tbz w14, #{[literal_at]}, 3f
;

/// A literal (RFC 1951 §3.2.5): its octet written and its bits used.
pub const literal =
    \\    lsr x6, x6, x14
    \\    sub w7, w7, w14
    \\    lsr w16, w14, #{[value_at]}
    \\    strb w16, [x3], #1
    \\    {[count_literal]s}
;

/// The lookup after each literal of a run but the last, whose bits are the stream's, the run
/// having used 44 at most; anything but a literal ends the run.
pub const literal_next =
    \\    and x17, x6, x9
    \\    ldr w14, [x8, x17, lsl #2]
    \\    tbz w14, #{[literal_at]}, 5f
;

/// After the last literal of a run, the lookup reads the buffer before the refill when it holds a
/// whole index, so it need not wait for the refill: the buffer holds as many of the stream's bits
/// as its count at least, and a count of 11 holds the widest index. With fewer, the refill comes
/// first. After a shorter run, the refill alone.
pub const literal_last =
    \\    and x17, x6, x9
    \\    ldr w14, [x8, x17, lsl #2]
    \\    and w16, w7, #0xff
    \\    cmp w16, #11
    \\    b.lo 51f
    \\    ldr x16, [x1]
    \\    lsl x16, x16, x7
    \\    orr x6, x6, x16
    \\    bic x16, x22, x7
    \\    add x1, x1, x16, lsr #3
    \\    orr w7, w7, #{[refill_bits]}
    \\    b 1b
    \\51:
    \\    ldr x16, [x1]
    \\    lsl x16, x16, x7
    \\    orr x6, x6, x16
    \\    bic x16, x22, x7
    \\    add x1, x1, x16, lsr #3
    \\    orr w7, w7, #{[refill_bits]}
    \\    and x17, x6, x9
    \\    ldr w14, [x8, x17, lsl #2]
    \\    b 1b
    \\5:
    \\    ldr x16, [x1]
    \\    lsl x16, x16, x7
    \\    orr x6, x6, x16
    \\    bic x16, x22, x7
    \\    add x1, x1, x16, lsr #3
    \\    orr w7, w7, #{[refill_bits]}
    \\    b 1b
;

/// A match from a combined entry (S11), and its checks.
pub const combined =
    \\3:
    \\    tbz w14, #{[combined_at]}, 4f
    \\    // A length and its distance's code in one entry: the distance is its symbol's base plus
    \\    // the extra bits after the entry's codes (RFC 1951 §3.2.5), where the entry's code bits
    \\    // say they start. x15 the length, x19 the distance, x26 and w27 the buffer and its count
    \\    // past the match's bits.
    \\    ubfx x16, x14, #{[distance_symbol_at]}, #5
    \\    ubfx x17, x14, #{[code_bits_at]}, #4
    \\    ldr w16, [x13, x16, lsl #2]
    \\    lsr x17, x6, x17
    \\    ubfx x15, x14, #{[value_at]}, #{[combined_length_bits]}
    \\    and x17, x17, x16, lsr #{[mask_at]}
    \\    add x19, x17, w16, uxth
    \\    lsr x26, x6, x14
    \\    sub w27, w7, w14
    \\    // The checks, in one branch: the match reads this call's output (invariant 10), no
    \\    // farther than the stream's window, and a chunk back at least. x20 its source.
    \\    subs x20, x3, x19
    \\    ccmp x20, x5, #0, hs
    \\    ccmp x19, x12, #2, hs
    \\    ccmp x19, #{[chunk]}, #0, ls
    \\    b.lo 70f
;

/// The match's copy, where the distance is a chunk at least, and the next symbol.
pub const copy =
    \\6:
    \\    // Three chunks, which cover most matches, then the rest. The distance is a chunk at
    \\    // least, so each chunk reads octets written before it, and the margin's room holds the
    \\    // last one's overrun.
    \\    ldr q0, [x20]
    \\    str q0, [x3]
    \\    ldr q1, [x20, #{[chunk]}]
    \\    str q1, [x3, #{[chunk]}]
    \\    ldr q2, [x20, #{[third_chunk_at]}]
    \\    str q2, [x3, #{[third_chunk_at]}]
    \\    cmp x15, #{[chunks_len]}
    \\    b.hi 75f
    \\7:
    \\    // The match is taken: its octets, and the next symbol's entry from the bits it left. A
    \\    // literal after it takes its octet before the refill: the match used 37 bits at most and
    \\    // the literal 11, so the lookup after it reads bits below 59, the stream's.
    \\    add x3, x3, x15
    \\    {[count_match]s}
    \\    and x17, x26, x9
    \\    ldr w14, [x8, x17, lsl #2]
    \\    tbz w14, #{[literal_at]}, 8f
    \\    lsr x26, x26, x14
    \\    sub w27, w27, w14
    \\    lsr w16, w14, #{[value_at]}
    \\    strb w16, [x3], #1
    \\    {[count_literal]s}
    \\    and x17, x26, x9
    \\    ldr w14, [x8, x17, lsl #2]
    \\8:
    \\    ldr x16, [x1]
    \\    lsl x16, x16, x27
    \\    orr x6, x26, x16
    \\    bic x16, x22, x27
    \\    add x1, x1, x16, lsr #3
    \\    orr w7, w27, #{[refill_bits]}
    \\    b 1b
;

/// A match from a length's own entry and its distance's.
pub const plain =
    \\4:
    \\    // A length: its value, or its base and the extra bits after its code (RFC 1951 §3.2.5).
    \\    // A code longer than the table goes on at 94; any other entry, and a distance's code
    \\    // longer than its table, go to `decode_rare`. x17 the buffer past the length's bits, x21
    \\    // the distance's entry.
    \\    tbz w14, #{[direct_at]}, 94f
    \\    lsr x17, x6, x14
    \\    and x16, x17, x11
    \\    ldr w21, [x10, x16, lsl #2]
    \\    lsl x16, x23, x14
    \\    bic x16, x6, x16
    \\    ubfx x15, x14, #{[code_bits_at]}, #4
    \\    lsr x16, x16, x15
    \\    add x15, x16, x14, lsr #{[value_at]}
    \\    tbz w21, #{[direct_at]}, 90f
    \\    lsl x16, x23, x21
    \\    bic x16, x17, x16
    \\    ubfx x19, x21, #{[code_bits_at]}, #4
    \\    lsr x16, x16, x19
    \\    add x19, x16, x21, lsr #{[value_at]}
    \\    lsr x26, x17, x21
    \\    sub w27, w7, w14
    \\    sub w27, w27, w21
    \\    // RFC 1951 §3.2.5: 258 has code 285 alone, so 258 from a base and extra bits goes to the
    \\    // checked path, which refuses it. x28 the length when its entry takes extra bits.
    \\    sbfx x28, x14, #{[extra_at]}, #1
    \\    and x28, x28, x15
    \\    subs x20, x3, x19
    \\    ccmp x20, x5, #0, hs
    \\    ccmp x19, x12, #2, hs
    \\    ccmp x28, x24, #4, ls
    \\    ccmp x19, #{[chunk]}, #0, ne
    \\    b.hs 6b
;

/// A match's other cases: a length of 258 from extra bits, the window, a distance past the
/// stream's window, and a distance below a chunk, the last case left once the others are not;
/// then the rest of a long match.
pub const other_cases =
    \\71:
    \\    cmp x28, x24
    \\    b.eq 90f
    \\70:
    \\    subs x20, x3, x19
    \\    ccmp x20, x5, #0, hs
    \\    ccmp x19, x12, #2, hs
    \\    b.hi 90f
    \\    // A distance below a chunk, the match overlapping itself (RFC 1951 §3.2.3). Its first chunk
    \\    // is the distance's octets repeated, from the chunk before the target, which one table
    \\    // lookup arranges; past it the octets repeat every multiple of the distance, so the rest
    \\    // go a chunk at a time from the least multiple a chunk back at least. With less than a
    \\    // chunk of this call's output before the target, it goes to `decode_rare`.
    \\    sub x16, x3, #{[chunk]}
    \\    cmp x16, x5
    \\    b.lo 90f
    \\    ldr x17, [x0, #{[repeats]}]
    \\    add x16, x17, x19, lsl #4
    \\    ldr q1, [x16]
    \\    ldur q0, [x3, #-{[chunk]}]
    \\    tbl v0.16b, {{v0.16b}}, v1.16b
    \\    str q0, [x3]
    \\    cmp x15, #{[chunk]}
    \\    b.ls 7b
    \\    add x16, x17, x19
    \\    ldrb w16, [x16, #{[steps]}]
    \\    mov x21, #{[chunk]}
    \\    cmp x16, x21
    \\    b.ne 77f
    \\    // A distance that divides a chunk repeats the first chunk whole: two copies at a time, the
    \\    // last ending inside the margin's room.
    \\    add x20, x3, #{[chunk]}
    \\    add x21, x3, x15
    \\78:
    \\    stp q0, q0, [x20], #{[pair]}
    \\    cmp x20, x21
    \\    b.lo 78b
    \\    b 7b
    \\77:
    \\    sub x20, x3, x16
    \\72:
    \\    ldr q0, [x20, x21]
    \\    str q0, [x3, x21]
    \\    add x21, x21, #{[chunk]}
    \\    cmp x21, x15
    \\    b.lo 72b
    \\    b 7b
    \\75:
    \\    // The rest of a match past its first three chunks: two chunks at a time where the
    \\    // distance holds two, so each pair reads octets written before it, and one at a time
    \\    // below.
    \\    add x16, x20, #{[chunks_len]}
    \\    add x17, x3, #{[chunks_len]}
    \\    add x21, x3, x15
    \\    cmp x19, #{[pair]}
    \\    b.lo 74f
    \\76:
    \\    ldp q0, q1, [x16], #{[pair]}
    \\    stp q0, q1, [x17], #{[pair]}
    \\    cmp x17, x21
    \\    b.lo 76b
    \\    b 7b
    \\74:
    \\    ldr q0, [x16], #{[chunk]}
    \\    str q0, [x17], #{[chunk]}
    \\    cmp x17, x21
    \\    b.lo 74b
    \\    b 7b
;

/// A literal/length code longer than the table, which the loop goes on decoding from its prefix.
pub const long_code =
    \\94:
    \\    // A code longer than the table (RFC 1951 §3.2.2): the entry holds its first bits, most
    \\    // significant first, and the table's width, how many they are; each bit after them doubles
    \\    // the value and adds itself, until the value falls among the codes of the length read so
    \\    // far. x15 the length read, x16 the value, x28 each length's codes. The other entries that
    \\    // come here, the block's end and a value the checked path refuses, set bit 6, the low bit
    \\    // of `other`, and go to `decode_rare`.
    \\    tbnz w14, #6, 90f
    \\    ubfx x15, x14, #{[code_bits_at]}, #4
    \\    lsr w16, w14, #{[value_at]}
    \\    ldr x28, [x0, #{[long_codes]}]
    \\95:
    \\    lsr x19, x6, x15
    \\    and x19, x19, #1
    \\    orr w16, w19, w16, lsl #1
    \\    add x15, x15, #1
    \\    ldr x20, [x28, x15, lsl #3]
    \\    sub w21, w16, w20, uxth
    \\    ubfx x19, x20, #16, #16
    \\    cmp w21, w19
    \\    b.lo 96f
    \\    cmp x15, #15
    \\    b.lo 95b
    \\    b 90f
    \\96:
    \\    ubfx x20, x20, #32, #16
    \\    add w21, w21, w20
    \\    ldr x17, [x0, #{[literal_length_symbols]}]
    \\    ldrh w21, [x17, x21, lsl #1]
    \\    cmp w21, #256
    \\    b.lo 97f
    \\    // A length (RFC 1951 §3.2.5): its entry for a code of no bits, with the code's bits added
    \\    // to its bits and to its code's, taken as the table's entries are. The block's end wraps
    \\    // past the lengths, and it and 286 and 287, which never occur (RFC 1951 §3.2.6), go to
    \\    // `decode_rare`.
    \\    sub w21, w21, #257
    \\    cmp w21, #29
    \\    b.hs 90f
    \\    ldr x19, [x0, #{[length_entries]}]
    \\    ldr w14, [x19, x21, lsl #2]
    \\    add w14, w14, w15
    \\    add w14, w14, w15, lsl #8
    \\    b 4b
    \\97:
    \\    // A literal: its octet, its bits, and a refill before the next lookup.
    \\    strb w21, [x3], #1
    \\    lsr x6, x6, x15
    \\    sub w7, w7, w15
    \\    {[count_literal]s}
    \\    ldr x16, [x1]
    \\    lsl x16, x16, x7
    \\    orr x6, x6, x16
    \\    bic x16, x22, x7
    \\    add x1, x1, x16, lsr #3
    \\    orr w7, w7, #{[refill_bits]}
    \\    and x17, x6, x9
    \\    ldr w14, [x8, x17, lsl #2]
    \\    b 1b
;

/// The exits, with the state stored back and why the loop stopped in x0.
pub const exits =
    \\80:
    \\    mov x16, #0
    \\    b 99f
    \\90:
    \\    mov x16, #1
    \\99:
    \\    str x1, [x0, #{[input]}]
    \\    str x3, [x0, #{[output]}]
    \\    and x7, x7, #0xff
    \\    stp x6, x7, [x0, #{[buffer]}]
    \\    {[store_decoded]s}
    \\    mov x0, x16
;
