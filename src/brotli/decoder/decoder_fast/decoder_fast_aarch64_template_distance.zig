//! The text of the loop of `decoder_fast_aarch64.zig`, continued from decoder_fast_aarch64_template.zig:
//! a command's distance, its copy, a dictionary word, the blocks the common path passes over and the
//! exits. The registers and the labels are as that file names them.

const std = @import("std");
const text = @import("decoder_fast_aarch64_template.zig");
const refill = text.refill;
const lookup = text.lookup;
const second_level = text.second_level;
const constants = @import("../../constants.zig");
const fast = @import("decoder_fast.zig");

/// The most octets a copy's stores reach past its end: a chunk less one, its last chunk's.
const copy_overrun_max = constants.copy_chunk_len - 1;

/// The room of a copy of more than a chunk, from `at` back to `back` with x13 free: the loop takes
/// it where its octets and its overrun end inside the output, `x3 + len + overrun <= x4 + margin`;
/// Zig takes it otherwise.
fn long_copy_room(comptime at: []const u8, comptime back: []const u8) []const u8 {
    return std.fmt.comptimePrint(
        \\{[at]s}:
        \\    add x13, x3, x27
        \\    sub x13, x13, #{[slack]d}
        \\    cmp x13, x4
        \\    b.hi 90f
        \\    b {[back]s}b
    , .{ .at = at, .back = back, .slack = fast.output_margin - copy_overrun_max });
}

comptime {
    // The ring's distances are within the smallest window: its first four (RFC 7932 §4), and every
    // later one a copy's, which 36 takes only within the window.
    for (constants.last_distances_initial) |ring_distance| {
        std.debug.assert(ring_distance <= (1 << constants.window_bits_min) - constants.window_len_gap);
    }
    // A symbol below 128 reuses the last distance (RFC 7932 §5), at label 40, with a copy code
    // below 16 from its cell, 69 octets at most, so that path takes no check of the copy's length.
    for (constants.insert_copy_cells[0 .. constants.insert_copy_last_distance_symbols >> constants.insert_copy_cell_bits]) |cell| {
        const code = constants.copy_length_codes[cell.copy + (1 << constants.insert_copy_code_bits) - 1];
        std.debug.assert(code.base + (1 << code.extra_bits) - 1 <= constants.chunk_len_max);
    }
}

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
    \\    // The distance context (RFC 7932 §7.3): the copy length, 2 to 5 and above, which indexes
    \\    // its table's pointer.
    \\    mov w13, #{[distance_context_last_copy_len]}
    \\    cmp w27, w13
    \\    csel w13, w27, w13, lo
    \\    ldr x13, [x11, x13, lsl #3]
++ "\n" ++ lookup("x13", "x23", "x14", "x28", "52", "56") ++
    \\    lsr w14, w23, #{[entry_value_at]}
    \\    and w23, w23, #0xff
    \\    lsr x26, x6, x23
    \\    mov w25, #0
    \\    // A short code (33) or a direct one (34), of no extra bits (RFC 7932 §4).
    \\    cmp w14, #{[distance_short_codes_count]}
    \\    b.lo 33f
    \\    ldp x28, x13, [x0, #{[coded_first]}]
    \\    subs w28, w14, w28
    \\    b.lo 34f
    \\    // A coded distance (RFC 7932 §4): its extra bits and base from its entry; the distance is
    \\    // the base, the extra bits shifted by NPOSTFIX, NDIRECT and 1.
    \\    ldr x13, [x13, x28, lsl #3]
    \\    ubfx x25, x13, #0, #{[coded_distance_base_at]}
    \\    mov x14, #-1
    \\    lsl x14, x14, x25
    \\    bic x26, x26, x14
    \\    ldp x14, x28, [x0, #{[postfix_bits]}]
    \\    lsl x26, x26, x14
    \\    add x26, x26, x13, lsr #{[coded_distance_base_at]}
    \\    add x26, x26, x28
    \\    mov w14, #1
    \\36:
    \\    add w23, w23, w25
    \\    // A distance past this call's output or past the window (35): a dictionary word or the
    \\    // window.
    \\    ldr x28, [x0, #{[window_distance_max]}]
    \\    sub x13, x3, x5
    \\    cmp x26, x13
    \\    ccmp x26, x28, #2, ls
    \\    b.hi 35f
    \\    // A copy of more than a chunk (38) where the room holds it.
    \\    cmp w27, #{[chunk_len_max]}
    \\    b.hi 38f
    \\39:
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
    \\33:
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
    \\    b 36b
    \\34:
    \\    // A direct code (RFC 7932 §4): the distances 1 to NDIRECT.
    \\    sub w26, w14, #{[direct_code_offset]}
    \\    b 36b
    \\40:
    \\    // The last distance reused (RFC 7932 §5): no bits, no element, no push.
    \\    and x26, x19, #0xffffffff
    \\    // A distance past this call's output (35); the ring's distances are within the window
    \\    // (asserted).
    \\    sub x13, x3, x5
    \\    cmp x26, x13
    \\    b.hi 35f
    \\    // The copy, of 69 octets at most (asserted), needs no room past the margin's.
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
    \\    ldp x8, x10, [x0, #{[ic_table]}]
    \\    add x11, x0, #{[dist_context_tables_by_len]}
    \\    ldr x12, [x0, #{[meta_block_left]}]
    \\    ldp x15, x16, [x0, #{[ic_count]}]
    \\    ldr x17, [x0, #{[dist_count]}]
    \\    ldr x30, [x0, #{[command_codes]}]
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
/// a run's literal (28, 29 and 73) and a distance (32), the room of a copy of more than a chunk
/// (38), a distance past this call's output or the window (35), the second level of each lookup
/// (50 to 53 and 58), a word's room (93), and the room taken as the octets left (94, 95, 97, 98).
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
++ "\n" ++ long_copy_room("38", "39") ++
    \\
    \\35:
    \\    // A distance past the octets the reference can reach names a dictionary word (RFC 7932
    \\    // §4), which the word's call takes; one within them reads the window, in Zig.
    \\    ldp x13, x28, [x0, #{[produced_offset]}]
    \\    add x13, x13, x3
    \\    cmp x13, x28
    \\    csel x13, x13, x28, lo
    \\    cmp x26, x13
    \\    b.hi 93f
    \\    b 90f
++ "\n" ++ second_level("x8", "x13", "x14", "x23", "50", "54") ++
    "\n" ++ second_level("x23", "x27", "x14", "x28", "51", "55") ++
    "\n" ++ second_level("x13", "x23", "x14", "x28", "52", "56") ++
    "\n" ++ second_level("x23", "x27", "x14", "x28", "53", "57") ++
    "\n" ++ second_level("x23", "x27", "x14", "x28", "58", "59") ++
    \\
    \\93:
    \\    // A word's transform takes `transform.wide_output_len` octets of room whatever the word's
    \\    // length: past the room, Zig takes the word (90), its distance's bits unused.
    \\    ldr x14, [x0, #{[word_limit]}]
    \\    cmp x3, x14
    \\    b.hi 90f
    \\    b 37b
    \\97:
    \\    // The input's slack gone: Zig takes the command (80).
    \\    cmp x1, x2
    \\    b.hi 80f
    \\    // Less than the margin's room (decisions 16 and 32). The loop goes on with the room's
    \\    // octets, less the two chunks a copy may store past its length, as the octets left
    \\    // where the meta-block has more: the checks of RFC 7932 §9.3 then keep a command's
    \\    // literals and its copy inside the output. x4 holds all ones from here, in the machine
    \\    // too, and the machine the octets taken off, which the exit adds back (99). No room past
    \\    // the two chunks: Zig takes the command (80).
    \\    add x13, x4, #{[margin_less_reserve]}
    \\    subs x13, x13, x3
    \\    b.ls 80f
    \\    mov x4, #-1
    \\    str x4, [x0, #{[output_limit]}]
    \\    cmp x13, x12
    \\    b.hs 1b
    \\    sub x14, x12, x13
    \\    mov x12, x13
    \\    str x14, [x0, #{[budget_delta]}]
    \\    b 1b
    \\94:
    \\    // The same after a run that left literals, which go on where the octets left hold them;
    \\    // Zig takes the others (87).
    \\    add x13, x4, #{[margin_less_reserve]}
    \\    subs x13, x13, x3
    \\    b.ls 87f
    \\    mov x4, #-1
    \\    str x4, [x0, #{[output_limit]}]
    \\    cmp x13, x12
    \\    b.hs 96f
    \\    sub x14, x12, x13
    \\    mov x12, x13
    \\    str x14, [x0, #{[budget_delta]}]
    \\96:
    \\    cmp w28, w12
    \\    b.hi 87f
    \\    b 20b
    \\95:
    \\    // The same after the literals: the distance checks the copy against the octets left.
    \\    // No room past the two chunks: Zig takes the distance (89).
    \\    add x13, x4, #{[margin_less_reserve]}
    \\    subs x13, x13, x3
    \\    b.ls 89f
    \\    mov x4, #-1
    \\    str x4, [x0, #{[output_limit]}]
    \\    cmp x13, x12
    \\    b.hs 30b
    \\    sub x14, x12, x13
    \\    mov x12, x13
    \\    str x14, [x0, #{[budget_delta]}]
    \\    b 30b
    \\98:
    \\    // No octet left after the literals: the meta-block's (88), or the room's, which leaves
    \\    // the distance to Zig (89).
    \\    ldr x13, [x0, #{[budget_delta]}]
    \\    cbz x13, 88f
    \\    b 89f
;

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
    \\    // No octet left: the room's, which leaves the next command to Zig (80), or the
    \\    // meta-block's.
    \\    ldr x13, [x0, #{[budget_delta]}]
    \\    cbnz x13, 80b
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
    \\    // Where the room was the octets left (97), the meta-block's come back, and Zig, whose
    \\    // chain checks no room where the margin held, goes on from the phase alone.
    \\    ldr x23, [x0, #{[output_limit]}]
    \\    cmn x23, #1
    \\    b.ne 79f
    \\    ldr x23, [x0, #{[budget_delta]}]
    \\    add x12, x12, x23
    \\    cmp x13, #{[link_stop]}
    \\    b.eq 79f
    \\    mov x13, #{[link_go_on]}
    \\79:
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
