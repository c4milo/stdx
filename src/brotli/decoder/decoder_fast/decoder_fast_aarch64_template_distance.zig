//! The text of the loop of `decoder_fast_aarch64.zig`, continued from decoder_fast_aarch64_template.zig:
//! a command's distance, its copy, a dictionary word, the blocks the common path passes over and the
//! exits. The registers and the labels are as that file names them.

const std = @import("std");
const text = @import("decoder_fast_aarch64_template.zig");
const refill = text.refill;
const lookup = text.lookup;
const second_level = text.second_level;

/// The command's distance (RFC 7932 §4): the last distance for a symbol below 128, or the code of
/// the tree its block type and copy length pick, its extra bits and the distance they give.
pub const distance =
    \\30:
    \\    // A refill (32) when the buffer holds fewer than a distance's bits.
    \\    cmp w7, #{[distance_bits_max]}
    \\    b.lo 32f
    \\31:
    \\    tbnz x24, #63, 40f
    \\    // RFC 7932 §9.3: a spent block takes a block switch first, in Zig.
    \\    cbz x17, 90f
    \\    // The distance context (RFC 7932 §7.3): the copy length, 2 to 5 and above, less 2.
    \\    mov w13, #{[distance_context_last_copy_len]}
    \\    cmp w27, w13
    \\    csel w13, w27, w13, lo
    \\    sub w13, w13, #{[distance_context_copy_len_min]}
    \\    ldrb w13, [x11, x13]
    \\    mov w14, #{[distance_table_size]}
    \\    mul x13, x13, x14
    \\    add x13, x9, x13
++ "\n" ++ lookup("x13", "x23", "x14", "x28", "52", "56") ++
    \\    and w14, w23, #0xffff
    \\    ubfx w23, w23, #16, #8
    \\    // The extra bits (RFC 7932 §4): none below 16 + NDIRECT, 1 + ((dcode - NDIRECT - 16) >>
    \\    // (NPOSTFIX + 1)) after them.
    \\    ldr x28, [x0, #{[direct_count]}]
    \\    add w28, w28, #{[distance_short_codes_count]}
    \\    mov w25, #0
    \\    cmp w14, w28
    \\    b.lo 33f
    \\    sub w25, w14, w28
    \\    ldr x26, [x0, #{[postfix_bits]}]
    \\    add w26, w26, #1
    \\    lsr w25, w25, w26
    \\    add w25, w25, #1
    \\33:
    \\    lsr x26, x6, x23
    \\    mov x13, #-1
    \\    lsl x13, x13, x25
    \\    bic x26, x26, x13
    \\    cmp w14, #{[distance_short_codes_count]}
    \\    b.hs 34f
    \\    // A short code (RFC 7932 §4): a last distance and a delta; one that resolves to zero or
    \\    // less should be rejected as invalid, which the checked path does.
    \\    ldr x13, [x0, #{[short_codes]}]
    \\    ldr x13, [x13, x14, lsl #3]
    \\    and x28, x13, #3
    \\    sbfx x13, x13, #8, #8
    \\    cmp x28, #2
    \\    csel x26, x20, x19, hs
    \\    tst x28, #1
    \\    lsr x28, x26, #32
    \\    csel x26, x28, x26, ne
    \\    and x26, x26, #0xffffffff
    \\    add x26, x26, x13
    \\    cmp x26, #1
    \\    b.lt 90f
    \\    b 36f
    \\34:
    \\    cmp w14, w28
    \\    b.hs 35f
    \\    // A direct code (RFC 7932 §4): the distances 1 to NDIRECT.
    \\    sub w26, w14, #{[direct_code_offset]}
    \\    b 36f
    \\35:
    \\    // A coded distance (RFC 7932 §4).
    \\    ldr x13, [x0, #{[postfix_bits]}]
    \\    sub w28, w14, w28
    \\    lsr x14, x28, x13
    \\    and x14, x14, #1
    \\    add x14, x14, #{[coded_distance_base]}
    \\    lsl x14, x14, x25
    \\    sub x14, x14, #{[coded_distance_bias]}
    \\    add x14, x14, x26
    \\    lsl x14, x14, x13
    \\    mov x26, #-1
    \\    lsl x26, x26, x13
    \\    bic x28, x28, x26
    \\    add x14, x14, x28
    \\    ldr x26, [x0, #{[direct_count]}]
    \\    add x14, x14, x26
    \\    add x26, x14, #1
    \\    mov w14, #1
    \\36:
    \\    add w23, w23, w25
    \\    // A distance past the octets the reference can reach names a dictionary word (RFC 7932
    \\    // §4), which Zig takes; one past this call's output reads the window, in Zig too.
    \\    ldp x13, x28, [x0, #{[produced_offset]}]
    \\    add x13, x13, x3
    \\    cmp x13, x28
    \\    csel x13, x13, x28, lo
    \\    cmp x26, x13
    \\    b.hi 37f
    \\    sub x13, x3, x5
    \\    cmp x26, x13
    \\    b.hi 90f
    \\    cmp w27, #{[chunk_len_max]}
    \\    b.hi 90f
    \\    // RFC 7932 §9.3: a copy length that would exceed MLEN; the checked path refuses it.
    \\    cmp w27, w12
    \\    b.hi 91f
    \\    lsr x6, x6, x23
    \\    sub w7, w7, w23
    \\    sub x17, x17, #1
    \\    {[count_distance]s}
    \\    // RFC 7932 §4: the distance code 0 stays out of the ring of last distances.
    \\    cbz w14, 41f
    \\    extr x20, x20, x19, #32
    \\    orr x19, x26, x19, lsl #32
    \\    b 41f
    \\40:
    \\    // The last distance reused (RFC 7932 §5): no bits, no element, no push.
    \\    and x26, x19, #0xffffffff
    \\    ldp x13, x28, [x0, #{[produced_offset]}]
    \\    add x13, x13, x3
    \\    cmp x13, x28
    \\    csel x13, x13, x28, lo
    \\    cmp x26, x13
    \\    b.hi 37f
    \\    sub x13, x3, x5
    \\    cmp x26, x13
    \\    b.hi 90f
    \\    cmp w27, #{[chunk_len_max]}
    \\    b.hi 90f
    \\    cmp w27, w12
    \\    b.hi 91f
;

/// The copy (S4, RFC 7932 §10): chunks of 16 where the distance holds one, of 8 where it holds one,
/// a fill for a distance of 1, and an octet at a time below 8; each reads octets written before it,
/// and the margin's room holds the last chunk's overrun. Then p1 and p2, the meta-block's octets,
/// and the next command.
pub const copy =
    \\41:
    \\    sub x13, x3, x26
    \\    cmp x26, #{[chunk]}
    \\    b.lo 60f
    \\    ldr q0, [x13]
    \\    str q0, [x3]
    \\    ldr q1, [x13, #{[chunk]}]
    \\    str q1, [x3, #{[chunk]}]
    \\    cmp w27, #{[pair]}
    \\    b.ls 45f
    \\    mov x14, #{[pair]}
    \\42:
    \\    ldr q0, [x13, x14]
    \\    str q0, [x3, x14]
    \\    add x14, x14, #{[chunk]}
    \\    cmp x14, x27
    \\    b.lo 42b
    \\    b 45f
    \\60:
    \\    cmp x26, #{[word]}
    \\    b.lo 61f
    \\    ldr x14, [x13]
    \\    str x14, [x3]
    \\    ldr x14, [x13, #{[word]}]
    \\    str x14, [x3, #{[word]}]
    \\    cmp w27, #{[chunk]}
    \\    b.ls 45f
    \\    mov x14, #{[chunk]}
    \\43:
    \\    ldr x23, [x13, x14]
    \\    str x23, [x3, x14]
    \\    add x14, x14, #{[word]}
    \\    cmp x14, x27
    \\    b.lo 43b
    \\    b 45f
    \\61:
    \\    cmp x26, #1
    \\    b.ne 62f
    \\    ldrb w14, [x13]
    \\    dup v0.16b, w14
    \\    mov x14, #0
    \\44:
    \\    str q0, [x3, x14]
    \\    add x14, x14, #{[chunk]}
    \\    cmp x14, x27
    \\    b.lo 44b
    \\    b 45f
    \\62:
    \\    mov x14, #0
    \\63:
    \\    ldrb w23, [x13, x14]
    \\    strb w23, [x3, x14]
    \\    add x14, x14, #1
    \\    cmp x14, x27
    \\    b.lo 63b
    \\45:
    \\    // p1 and p2 from the source's last two octets: each octet a copy writes equals the one
    \\    // `distance` before it, and where the distance is at least the length, the source's octets
    \\    // were written before the copy, so that neither load waits for the copy's stores.
    \\    add x13, x13, x27
    \\    add x3, x3, x27
    \\    ldurb w21, [x13, #-1]
    \\    ldurb w22, [x13, #-2]
    \\    sub w12, w12, w27
    \\    cbz w12, 88f
    \\    b 1b
;

/// A dictionary word (RFC 7932 §8): `write_word`, in Zig, transforms it into the output, with the
/// loop's changing registers stored before the call and every register loaded back after it; a
/// reference it refuses, or a word past MLEN, goes to the checked path with the bits unused. Then
/// the word's octets, and the distance's bits and element unless the last distance was reused.
pub const word =
    \\37:
    \\    sub x2, x26, x13
    \\    sub x2, x2, #1
    \\    str x1, [x0, #{[input]}]
    \\    str x3, [x0, #{[output]}]
    \\    stp x6, x7, [x0, #{[buffer]}]
    \\    str x12, [x0, #{[meta_block_left]}]
    \\    stp x15, x16, [x0, #{[ic_count]}]
    \\    str x17, [x0, #{[dist_count]}]
    \\    mov x25, x0
    \\    ldr x16, [x0, #{[write_word]}]
    \\    mov x0, x3
    \\    mov x1, x27
    \\    mov x3, x12
    \\    blr x16
    \\    mov x13, x0
    \\    mov x0, x25
    \\    ldp x1, x2, [x0, #{[input]}]
    \\    ldp x3, x4, [x0, #{[output]}]
    \\    ldr x5, [x0, #{[output_base]}]
    \\    ldp x6, x7, [x0, #{[buffer]}]
    \\    ldp x8, x9, [x0, #{[ic_table]}]
    \\    ldp x10, x11, [x0, #{[lit_tables]}]
    \\    ldr x12, [x0, #{[meta_block_left]}]
    \\    ldp x15, x16, [x0, #{[ic_count]}]
    \\    ldr x17, [x0, #{[dist_count]}]
    \\    cmn x13, #1
    \\    b.eq 91f
    \\    add x3, x3, x13
    \\    sub w12, w12, w13
    \\    // p1 and p2 as `wrote` keeps them: both from the output past two octets, p1 alone past one.
    \\    cbz x13, 46f
    \\    cmp x13, #1
    \\    b.eq 47f
    \\    ldurb w21, [x3, #-1]
    \\    ldurb w22, [x3, #-2]
    \\    b 46f
    \\47:
    \\    mov w22, w21
    \\    ldurb w21, [x3, #-1]
    \\46:
    \\    tbnz x24, #63, 48f
    \\    lsr x6, x6, x23
    \\    sub w7, w7, w23
    \\    sub x17, x17, #1
    \\    {[count_distance]s}
    \\48:
    \\    cbz w12, 88f
    \\    b 1b
;

/// The blocks the common path passes over, each entered by a branch it leaves untaken and ending in
/// a branch back: the refills that need the input's slack checked, for a command's extra bits (12),
/// a run's literal (28, 29 and 73) and a distance (32), and the second level of each lookup (50 to
/// 53 and 58).
pub const cold =
    \\12:
    \\    cmp x1, x2
    \\    b.hi 82f
++ "\n" ++ refill("x13") ++
    \\
    \\    b 11b
    \\28:
    \\    cmp x1, x2
    \\    b.hi 86f
++ "\n" ++ refill("x14") ++
    \\
    \\    b 22b
    \\29:
    \\    cmp x1, x2
    \\    b.hi 86f
++ "\n" ++ refill("x14") ++
    \\
    \\    b 27b
    \\32:
    \\    cmp x1, x2
    \\    b.hi 89f
++ "\n" ++ refill("x13") ++
    \\
    \\    b 31b
    \\73:
    \\    cmp x1, x2
    \\    b.hi 86f
++ "\n" ++ refill("x14") ++
    \\
    \\    b 72b
++ "\n" ++ second_level("x8", "x13", "x14", "x23", "50", "54") ++
    "\n" ++ second_level("x23", "x27", "x14", "x28", "51", "55") ++
    "\n" ++ second_level("x13", "x23", "x14", "x28", "52", "56") ++
    "\n" ++ second_level("x23", "x27", "x14", "x28", "53", "57") ++
    "\n" ++ second_level("x23", "x27", "x14", "x28", "58", "59");

/// The exits: the link in x13 and the phase in x14, the command's values where a command is in
/// progress, then the machine stored back and the link returned.
pub const exits =
    \\80:
    \\    mov x24, #0
    \\    mov x27, #0
    \\    mov x28, #0
    \\    mov x13, #{[link_go_on]}
    \\    mov x14, #{[phase_command]}
    \\    b 99f
    \\81:
    \\    mov x24, #0
    \\    mov x27, #0
    \\    mov x28, #0
    \\    mov x13, #{[link_command]}
    \\    mov x14, #{[phase_command]}
    \\    b 99f
    \\82:
    \\    mov x27, #0
    \\    mov x28, #0
    \\    mov x13, #{[link_go_on]}
    \\    mov x14, #{[phase_command_extra]}
    \\    b 99f
    \\83:
    \\    mov x27, #0
    \\    mov x28, #0
    \\    mov x13, #{[link_stop]}
    \\    mov x14, #{[phase_command_extra]}
    \\    b 99f
    \\84:
    \\    mov x13, #{[link_stop]}
    \\    mov x14, #{[phase_literal]}
    \\    b 99f
    \\85:
    \\    mov x13, #{[link_literal]}
    \\    mov x14, #{[phase_literal]}
    \\    b 99f
    \\86:
    \\    // The run's octets so far, as at 23.
    \\    ldr x14, [x0, #{[batch]}]
    \\    sub w14, w14, w13
    \\    ldp x27, x28, [x0, #{[copy_len]}]
    \\    sub x16, x16, x14
    \\    sub w28, w28, w14
    \\    sub w12, w12, w14
    \\87:
    \\    mov x13, #{[link_go_on]}
    \\    mov x14, #{[phase_literal]}
    \\    b 99f
    \\88:
    \\    mov x13, #{[link_stop]}
    \\    mov x14, #{[phase_meta_block_end]}
    \\    b 99f
    \\89:
    \\    mov x13, #{[link_go_on]}
    \\    mov x14, #{[phase_distance]}
    \\    b 99f
    \\90:
    \\    mov x13, #{[link_distance]}
    \\    mov x14, #{[phase_distance]}
    \\    b 99f
    \\91:
    \\    mov x13, #{[link_stop]}
    \\    mov x14, #{[phase_distance]}
    \\99:
    \\    str x1, [x0, #{[input]}]
    \\    str x3, [x0, #{[output]}]
    \\    stp x6, x7, [x0, #{[buffer]}]
    \\    str x12, [x0, #{[meta_block_left]}]
    \\    stp x15, x16, [x0, #{[ic_count]}]
    \\    str x17, [x0, #{[dist_count]}]
    \\    stp x19, x20, [x0, #{[ring01]}]
    \\    stp x21, x22, [x0, #{[p1]}]
    \\    str x14, [x0, #{[phase]}]
    \\    ubfx x23, x24, #{[insert_code_at]}, #8
    \\    ubfx x25, x24, #{[copy_code_at]}, #{[copy_code_bits]}
    \\    lsr x26, x24, #63
    \\    stp x23, x25, [x0, #{[insert_code]}]
    \\    str x26, [x0, #{[last_distance]}]
    \\    stp x27, x28, [x0, #{[copy_len]}]
    \\    mov x0, x13
;
