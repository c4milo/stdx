//! The text of the loop of `decoder_fast_aarch64.zig`, in the pieces its `template` joins: the
//! prologue, a command and its literals here, its distance, its copy, a dictionary word and the
//! exits in decoder_fast_aarch64_template_distance.zig, with the refill and the lookup both use.
//!
//! Registers: x0 the machine; x1 the input's next octet and x2 the last place an 8-octet load may
//! start; x3 the output's next octet, x4 the last place a command may start and x5 the call's first
//! octet; x6 the bit buffer and w7 its count; x8 the insert-and-copy table of the current block
//! type; x9 the distance tables; x10 the literal tables of the current block type, one pointer per
//! context; x11 the distance context map's row of the current block type; w12 the meta-block's
//! octets left; w15, w16 and w17 the elements left in the insert-and-copy, literal and distance
//! blocks; x19 and x20 the ring of last distances, two 32-bit distances each, the last in the low
//! half of x19; w21 p1 and w22 p2. x13, x14, x23 and x25 to x28 hold each command's values: x24 its
//! packed code with bit 63 set when it reuses the last distance, x27 its copy length and x28 its
//! literals left, both kept in the machine while its literals run; in a run of the entries' mode,
//! w23 holds p1's part of the next context ID and w25 p2's.
//!
//! Each of the buffer's 64 bits is the stream's: a refill ORs the next 8 octets in above the count
//! and takes the whole octets that fit (S1), and a command uses at most 56 bits between refills.
//!
//! The numbered labels: 1 a command, 10 its symbol, 11 its extra bits, 20 its literals, 21 to 27
//! and 70 to 72 their runs, 30 to 36 its distance, 40 the last distance reused, 41 the copy and 42
//! to 45 and 60 to 63 the copy's kinds, 37 and 46 to 48 a dictionary word, 80 to 91 the exits, 99
//! the machine stored back. The common path falls through: the refills that need the slack checked
//! (12, 28, 29, 32 and 73), the room of a copy of more than a chunk (38, back at 39) and the second
//! level of each lookup (50 to 53 and 58, back at 54 to 57 and 59) stand after the word, in `cold`,
//! each reached by a branch the common path leaves untaken and ending in one back.
//!
//! The accesses (decision 24), each with the check that bounds it:
//! - The refill's 8-octet load at the input's next octet: the slack check before every refill,
//!   `x1 <= x2`, the last place an 8-octet load may start.
//! - A root entry, at a table's first 256 entries: every table holds a root (`prefix.Table`); a
//!   second-level entry, at the root entry's value plus an index below 1 << `second_bits`: the build
//!   wrote that level inside the table (`fill_end`).
//! - A packed command code, at the insert-and-copy symbol: the symbol is below the alphabet, 704.
//! - The distance context map's row, at an id 0 to 3; a distance table, at a tree the map names,
//!   which the header checked below NTREESD; a literal table, at a context ID the luts give, below
//!   64 (`context`); a lut, at p1 or p2, an octet; a short code, at a code below 16; a coded
//!   distance's entry, at its code less 16 and NDIRECT, below 48 << NPOSTFIX, since a code's table
//!   holds symbols of its alphabet alone.
//! - A copy's loads, from `distance` octets before the output's next: the distance is at most the
//!   octets this call wrote (`x3 - x5`), so every load reads this call's output; a chunk's load reads
//!   octets written before it, since each kind of copy needs a distance of its chunk at least.
//! - p1 and p2 after a copy, the last two octets of its source, `distance` before the copy's last
//!   two: at or past the source's first octet, since a copy writes 2 at least, and before the copy's
//!   end. After a word, one and two octets before the output's next, which the word's octets gate.
//! - A literal's store, and a copy's or a word's, past the output's next octet: a command starts
//!   with the margin's room, `x3 <= x4`; its literals write at most 256; its copy starts only with
//!   the room checked again after them, writes at most 256 and overruns by a chunk at most, or, for
//!   a copy of more than 256, only where its octets and its overrun end inside the output; a word
//!   writes at most the margin (asserted); the machine's fields sit at fixed offsets.

const std = @import("std");

/// One 8-octet refill (S1) with `scratch` free: the buffer holds fewer than 64 bits, and the slack
/// holds.
pub fn refill(comptime scratch: []const u8) []const u8 {
    return std.fmt.comptimePrint(
        \\    ldr {[s]s}, [x1]
        \\    lsl {[s]s}, {[s]s}, x7
        \\    orr x6, x6, {[s]s}
        \\    mov {[w]s}, #63
        \\    sub {[w]s}, {[w]s}, w7
        \\    add x1, x1, {[s]s}, lsr #3
        \\    and w7, w7, #7
        \\    add w7, w7, #{{[refill_bits]}}
    , .{ .s = scratch, .w = w_of(scratch) });
}

/// The symbol the buffer starts with, from `table`, into `entry`: its value in the low 16 bits and
/// its length in the next 8 (`prefix.Entry`), through `second_level` when the root entry links one
/// (RFC 7932 §3.2), which comes back to `back`. `t1` and `t2` are scratch.
pub fn lookup(comptime table: []const u8, comptime entry: []const u8, comptime t1: []const u8, comptime t2: []const u8, comptime second: []const u8, comptime back: []const u8) []const u8 {
    return std.fmt.comptimePrint(
        \\    and {[t1]s}, x6, #0xff
        \\    ldr {[entry_w]s}, [{[table]s}, {[t1]s}, lsl #2]
        \\    lsr {[t2_w]s}, {[entry_w]s}, #24
        \\    cbnz {[t2_w]s}, {[second]s}f
        \\{[back]s}:
        \\
    , .{ .table = table, .entry_w = w_of(entry), .t1 = t1, .t2_w = w_of(t2), .second = second, .back = back });
}

/// The second level of a `lookup` with the same registers and labels, out of the common path's way:
/// the root entry's value names the level and `t2` holds its bits (`prefix.Table`); the entry it
/// finds takes the root's bits into its length.
pub fn second_level(comptime table: []const u8, comptime entry: []const u8, comptime t1: []const u8, comptime t2: []const u8, comptime second: []const u8, comptime back: []const u8) []const u8 {
    return std.fmt.comptimePrint(
        \\{[second]s}:
        \\    mov {[t1]s}, #-1
        \\    lsl {[t1]s}, {[t1]s}, {[t2]s}
        \\    lsr {[t2]s}, x6, #8
        \\    bic {[t2]s}, {[t2]s}, {[t1]s}
        \\    and {[entry_w]s}, {[entry_w]s}, #0xffff
        \\    add {[t2]s}, {[t2]s}, {[entry]s}
        \\    ldr {[entry_w]s}, [{[table]s}, {[t2]s}, lsl #2]
        \\    add {[entry_w]s}, {[entry_w]s}, #{{[root_bits_at_len]}}
        \\    b {[back]s}b
    , .{ .table = table, .entry = entry, .entry_w = w_of(entry), .t1 = t1, .t2 = t2, .second = second, .back = back });
}

/// The 32-bit name of a register: `x14` gives `w14`.
fn w_of(comptime register: []const u8) []const u8 {
    return "w" ++ register[1..];
}

/// The prologue: the machine's fields into their registers.
pub const prologue =
    \\    ldp x1, x2, [x0, #{[input]}]
    \\    ldp x3, x4, [x0, #{[output]}]
    \\    ldr x5, [x0, #{[output_base]}]
    \\    ldp x6, x7, [x0, #{[buffer]}]
    \\    ldp x8, x9, [x0, #{[ic_table]}]
    \\    ldp x10, x11, [x0, #{[lit_tables]}]
    \\    ldr x12, [x0, #{[meta_block_left]}]
    \\    ldp x15, x16, [x0, #{[ic_count]}]
    \\    ldr x17, [x0, #{[dist_count]}]
    \\    ldp x19, x20, [x0, #{[ring01]}]
    \\    ldp x21, x22, [x0, #{[p1]}]
    \\    // The loop starts a fetch line of its own, wherever the code before it ends.
    \\    .p2align 6
;

/// A command: the margins, the refill, its block, its symbol (RFC 7932 §5) and its extra bits.
pub const command =
    \\1:
    \\    // Decision 16's margins: the room of a chain, and the 8 octets of a refill.
    \\    cmp x3, x4
    \\    ccmp x1, x2, #2, ls
    \\    b.hi 80f
    \\    cmp w7, #{[refill_bits]}
    \\    b.hs 10f
++ "\n" ++ refill("x13") ++
    \\
    \\10:
    \\    // RFC 7932 §9.3: a spent block takes a block switch first, in Zig.
    \\    cbz x15, 81f
++ "\n" ++ lookup("x8", "x13", "x14", "x23", "50", "54") ++
    \\    ubfx w14, w13, #16, #8
    \\    lsr x6, x6, x14
    \\    sub w7, w7, w14
    \\    sub x15, x15, #1
    \\    and w13, w13, #0xffff
    \\    // The symbol's codes, packed, the top bit set for a symbol below 128, which reuses the
    \\    // last distance (RFC 7932 §5).
    \\    ldr x24, [x0, #{[command_codes]}]
    \\    ldr x24, [x24, x13, lsl #3]
    \\    {[count_symbol]s}
    \\    // The extra bits (RFC 7932 §5), after a second refill (12) when the buffer holds fewer.
    \\    ubfx x26, x24, #{[extra_bits_at]}, #8
    \\    cmp w26, w7
    \\    b.hi 12f
    \\11:
    \\    mov x27, #-1
    \\    lsl x27, x27, x26
    \\    bic x27, x6, x27
    \\    ubfx x13, x24, #{[insert_extra_bits_at]}, #8
    \\    mov x14, #-1
    \\    lsl x14, x14, x13
    \\    bic x14, x27, x14
    \\    and w28, w24, #0xffff
    \\    add w28, w28, w14
    \\    // RFC 7932 §9.3: literals that would exceed MLEN; the checked path refuses them.
    \\    cmp w28, w12
    \\    b.hi 83f
    \\    lsr x6, x6, x26
    \\    sub w7, w7, w26
    \\    lsr x27, x27, x13
    \\    ubfx w14, w24, #{[copy_base_at]}, #16
    \\    add w27, w27, w14
    \\    cbz w28, 30f
;

/// The command's literals (RFC 7932 §7.1, §7.3): a run of at most a chunk of its block, each with
/// the table its context picks, the buffer refilled while the slack holds.
pub const literals =
    \\20:
    \\    // A run starts with a code's bits in the buffer or the slack to refill; the checked path
    \\    // takes the literals otherwise. A spent block takes a block switch first, in Zig.
    \\    cmp w7, #{[code_len_max]}
    \\    ccmp x1, x2, #0, lo
    \\    b.hi 84f
    \\    cbz x16, 85f
    \\    mov w13, #{[chunk_len_max]}
    \\    cmp w28, w13
    \\    csel w13, w28, w13, lo
    \\    cmp x16, x13
    \\    csel x13, x16, x13, lo
    \\    stp x27, x28, [x0, #{[copy_len]}]
    \\    str x13, [x0, #{[batch]}]
    \\    ldr x23, [x0, #{[run_kind]}]
    \\    cbz x23, 25f
    \\    ldp x25, x26, [x0, #{[lut_p1]}]
    \\    cmp x23, #{[kind_entry_parts]}
    \\    b.eq 70f
    \\21:
    \\    // A refill (28) when the buffer holds fewer than a code's bits.
    \\    cmp w7, #{[code_len_max]}
    \\    b.lo 28f
    \\22:
    \\    // The context ID from p1 and p2 (RFC 7932 §7.1), its table, and the literal.
    \\    ldrb w14, [x25, x21]
    \\    ldrb w23, [x26, x22]
    \\    orr w14, w14, w23
    \\    ldr x23, [x10, x14, lsl #3]
++ "\n" ++ lookup("x23", "x27", "x14", "x28", "51", "55") ++
    \\    ubfx w14, w27, #16, #8
    \\    lsr x6, x6, x14
    \\    sub w7, w7, w14
    \\    mov w22, w21
    \\    and w21, w27, #0xff
    \\    strb w21, [x3], #1
    \\    {[count_literal]s}
    \\    subs w13, w13, #1
    \\    b.ne 21b
    \\    b 23f
    \\70:
    \\    // The entries' mode: p1's part of the next context ID comes from the entry of the literal
    \\    // before it (`context.literal_entry_value`), so no load stands between a literal and its
    \\    // successor's table; p2's part from the lut, off that path. The first takes both from
    \\    // the luts.
    \\    ldrb w23, [x25, x21]
    \\    ldrb w25, [x26, x22]
    \\71:
    \\    cmp w7, #{[code_len_max]}
    \\    b.lo 73f
    \\72:
    \\    orr w23, w23, w25
    \\    ldr x23, [x10, x23, lsl #3]
++ "\n" ++ lookup("x23", "x27", "x14", "x28", "58", "59") ++
    \\    ubfx w14, w27, #16, #8
    \\    lsr x6, x6, x14
    \\    sub w7, w7, w14
    \\    ldrb w25, [x26, x21]
    \\    ubfx w23, w27, #{[entry_p1_part_shift]}, #{[context_id_bits]}
    \\    mov w22, w21
    \\    and w21, w27, #0xff
    \\    strb w21, [x3], #1
    \\    {[count_literal]s}
    \\    subs w13, w13, #1
    \\    b.ne 71b
    \\    b 23f
    \\25:
    \\    // One tree for every context: the first table, and no context ID.
    \\    ldr x23, [x10]
    \\26:
    \\    cmp w7, #{[code_len_max]}
    \\    b.lo 29f
    \\27:
++ "\n" ++ lookup("x23", "x27", "x14", "x28", "53", "57") ++
    \\    ubfx w14, w27, #16, #8
    \\    lsr x6, x6, x14
    \\    sub w7, w7, w14
    \\    mov w22, w21
    \\    and w21, w27, #0xff
    \\    strb w21, [x3], #1
    \\    {[count_literal]s}
    \\    subs w13, w13, #1
    \\    b.ne 26b
    \\23:
    \\    // The run's octets: off the block, the insert and the meta-block. Literals left take the
    \\    // next run while the room's margin holds.
    \\    ldr x14, [x0, #{[batch]}]
    \\    sub w14, w14, w13
    \\    ldp x27, x28, [x0, #{[copy_len]}]
    \\    sub x16, x16, x14
    \\    sub w28, w28, w14
    \\    sub w12, w12, w14
    \\    cbz w28, 24f
    \\    cmp x3, x4
    \\    b.hi 87f
    \\    b 20b
    \\24:
    \\    cbz w12, 88f
    \\    cmp x3, x4
    \\    b.hi 89f
;
