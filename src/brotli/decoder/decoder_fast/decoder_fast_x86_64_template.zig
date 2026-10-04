//! The text of the loop of `decoder_fast_x86_64.zig`, in Intel syntax, in the pieces its `template`
//! joins: the prologue, a command and its literals here, its distance, its copy, a dictionary word,
//! the blocks the common path passes over and the exits in
//! decoder_fast_x86_64_template_distance.zig. It is the port of decoder_fast_aarch64_template.zig,
//! whose comment describes what the loop takes; x86-64's 14 registers hold less of it.
//!
//! Registers: rdi the machine; rsi the input's next octet and rdx the output's; r8 the bit buffer
//! and r9 its count, which never passes 64 and so changes as its low octet; r10 the meta-block's
//! octets left, or the room's where the room is shorter (97). Between literal runs, r13 holds the
//! command's packed code with bit 63 set when it reuses the last distance, r14 its copy length and
//! r15 its literals left, and then its distance. From a copy's or a word's end, through the next
//! command's symbol and its literal runs, r11 and r12 hold p1 and p2; the distance and the copy
//! take them as scratch, with p1 and p2 in the machine. In a run, r13 holds the literal tables of
//! the block type, r14 and r15 the parts of a context ID p1 and p2 give (or p1's part itself, in
//! the entries' mode), rbx the literals left in the run, and r10 is free, the run keeping the
//! command's packed code and values and the meta-block's octets in the machine. rax, rcx and rbx
//! are otherwise free. The limits, the tables but the literal ones, the blocks' elements left, the
//! ring of last distances and the distance parameters stay in the machine, which the loop reads in
//! place.
//!
//! BMI2's SHRX shifts by a register's low six bits, which an entry's length is, in its low octet;
//! BZHI keeps the bits below an index, which a root entry's second bits are after RORX brings them
//! to the low octet. SSSE3's PSHUFB repeats an octet for a distance of 1.
//!
//! The numbered labels are those of the aarch64 text, and 65 the run's start past its checks, 70 to
//! 73 the run of the entries' mode, 58 and 59 its second level. The common path falls through: the
//! refills that need the slack checked (12, 28, 29, 32 and 73), each lookup's second level (50 to
//! 53 and 58, back at 54 to 57 and 59), a word's room (93) and the room taken as the octets left
//! where the margin is gone (94, 95 and 97, with 98) stand after the word, in `cold`.
//!
//! The accesses (decision 24), each with the check that bounds it:
//! - The refill's 8-octet load at the input's next octet: the slack check before every refill, rsi
//!   at most `input_limit`, the last place an 8-octet load may start.
//! - A root entry, at a table's first 256 entries: every table holds a root (`prefix.Table`); a
//!   second-level entry, at the root entry's value plus an index below 1 << `second_bits`: the build
//!   wrote that level inside the table (`fill_end`).
//! - A packed command code, at the insert-and-copy symbol: the symbol is below the alphabet, 704.
//! - A distance context's table pointer, at a context 0 to 3 of the command's packed code, each the
//!   table of a tree the map names, which the header checked below NTREESD; a literal table, at a context ID the luts give, below
//!   64 (`context`); a lut, at p1 or p2, an octet; a short code, at a code below 16; the ring, at a
//!   short code's last distance, 0 to 3.
//! - A copy's loads, from `distance` octets before the output's next: the distance is at most the
//!   octets this call wrote (rdx less `output_base`), so every load reads this call's output; a
//!   chunk's load reads octets written before it, since each kind of copy needs a distance of its
//!   chunk at least.
//! - p1 and p2 after a copy, the last two octets of its source, `distance` before the copy's last
//!   two: at or past the source's first octet, since a copy writes 2 at least, and before the copy's
//!   end. After a word, one and two octets before the output's next, which the word's octets gate.
//! - A literal's store, and a copy's or a word's, past the output's next octet: with the margin's
//!   room, rdx at most `output_limit`, a command's literals write at most 256; its copy starts only
//!   with the room checked again after them, writes at most 256 and overruns by a chunk at most.
//!   With less room, r10 holds at most the room's octets less `copy_store_reserve`, the two chunks
//!   that hold the most a copy stores past its length, so the checks of the literals and of the
//!   copy against r10 (RFC 7932 §9.3) keep both inside the output. A word starts only where the
//!   `transform.wide_output_len` octets its transform takes end inside the output (93); the
//!   machine's fields sit at fixed offsets.
//! - The call into `write_word`, on a stack aligned to 16 below the red zone, with the loop's values
//!   stored first and loaded again after.

const std = @import("std");

/// One 8-octet refill (S1) with `scratch` free: the buffer holds fewer than 56 bits, and the slack
/// holds.
pub fn refill(comptime scratch: []const u8) []const u8 {
    return std.fmt.comptimePrint(
        \\    shlx {[s]s}, qword ptr [rsi], r9
        \\    or r8, {[s]s}
        \\    movzx {[d]s}, r9b
        \\    xor {[d]s}, 63
        \\    shr {[d]s}, 3
        \\    add rsi, {[s]s}
        \\    or r9d, 56
        \\
    , .{ .s = scratch, .d = dword_of(scratch) });
}

/// The entry of the symbol the buffer starts with, from `table`, into `entry`: its length in the low
/// 8 bits, its second level's bits in the next 8 and its value in the top 16 (`prefix.Entry`),
/// through `second` when the root entry links a second level (RFC 7932 §3.2), which comes back to
/// `back`. `entry` takes the index first.
pub fn lookup(comptime table: []const u8, comptime entry: []const u8, comptime second: []const u8, comptime back: []const u8) []const u8 {
    return std.fmt.comptimePrint(
        \\    movzx {[e]s}, r8b
        \\    mov {[e]s}, dword ptr [{[table]s} + {[entry]s}*4]
        \\    test {[e]s}, {{[entry_second_mask]}}
        \\    jnz {[second]s}f
        \\{[back]s}:
        \\
    , .{ .table = table, .entry = entry, .e = dword_of(entry), .second = second, .back = back });
}

/// The second level of a `lookup` with the same registers and labels, out of the common path's way,
/// `scratch` free: the bits past the root's 8, as many as the root entry's second bits, index the
/// level its value starts (`prefix.Table`); the entry found takes the root's bits into its length.
/// RORX brings the second bits to the entry's low octet, BZHI's index, and the value above them.
pub fn second_level(comptime table: []const u8, comptime entry: []const u8, comptime scratch: []const u8, comptime second: []const u8, comptime back: []const u8) []const u8 {
    return std.fmt.comptimePrint(
        \\{[second]s}:
        \\    rorx {[x]s}, r8, {{[root_bits]}}
        \\    rorx {[e]s}, {[e]s}, {{[entry_second_at]}}
        \\    bzhi {[x]s}, {[x]s}, {[entry]s}
        \\    shr {[e]s}, 8
        \\    movzx {[e]s}, {[e_w]s}
        \\    add {[x]s}, {[entry]s}
        \\    mov {[e]s}, dword ptr [{[table]s} + {[x]s}*4]
        \\    add {[e]s}, {{[root_bits_at_len]}}
        \\    jmp {[back]s}b
        \\
    , .{ .table = table, .entry = entry, .e = dword_of(entry), .e_w = word_of(entry), .x = scratch, .second = second, .back = back });
}

/// The 32-bit name of a 64-bit register: `rax` gives `eax`, `r10` gives `r10d`.
pub fn dword_of(comptime register: []const u8) []const u8 {
    if (register[1] >= '0' and register[1] <= '9') return register ++ "d";
    return "e" ++ register[1..];
}

/// The 16-bit name of a 64-bit register: `rcx` gives `cx`, `r10` gives `r10w`.
pub fn word_of(comptime register: []const u8) []const u8 {
    if (register[1] >= '0' and register[1] <= '9') return register ++ "w";
    return register[1..];
}

/// The prologue: the machine's fields into their registers.
pub const prologue =
    \\    .intel_syntax noprefix
    \\    mov rsi, qword ptr [rdi + {[input]}]
    \\    mov rdx, qword ptr [rdi + {[output]}]
    \\    mov r8, qword ptr [rdi + {[buffer]}]
    \\    mov r9, qword ptr [rdi + {[count]}]
    \\    mov r10, qword ptr [rdi + {[meta_block_left]}]
    \\    mov r11, qword ptr [rdi + {[p1]}]
    \\    mov r12, qword ptr [rdi + {[p2]}]
    \\    // The loop starts a fetch line of its own, wherever the code before it ends.
    \\    .p2align 6
;

/// A command: the margins, the refill, its block, its symbol (RFC 7932 §5) and its extra bits.
pub const command =
    \\1:
    \\    // Decision 16's margins: the room of a chain, and the 8 octets of a refill. With less room
    \\    // the loop goes on with the room as the octets left (97).
    \\    cmp rdx, qword ptr [rdi + {[output_limit]}]
    \\    ja 97f
    \\    cmp rsi, qword ptr [rdi + {[input_limit]}]
    \\    ja 80f
    \\    cmp r9d, {[refill_bits]}
    \\    jae 10f
++ "\n" ++ refill("rax") ++
    \\10:
    \\    // RFC 7932 §9.3: a spent block takes a block switch first, in Zig.
    \\    cmp qword ptr [rdi + {[ic_count]}], 0
    \\    je 81f
    \\    mov rax, qword ptr [rdi + {[ic_table]}]
++ "\n" ++ lookup("rax", "rcx", "50", "54") ++
    \\    shrx r8, r8, rcx
    \\    sub r9b, cl
    \\    dec qword ptr [rdi + {[ic_count]}]
    \\    shr ecx, {[entry_value_at]}
    \\    // The symbol's codes, packed; a symbol below 128 reuses the last distance (RFC 7932 §5).
    \\    mov r13, qword ptr [rdi + {[command_codes]}]
    \\    mov r13, qword ptr [r13 + rcx*8]
    \\    cmp ecx, {[last_distance_symbols]}
    \\    sbb ebx, ebx
    \\    shl rbx, 63
    \\    or r13, rbx
    \\    {[count_symbol]s}
    \\    // The extra bits (RFC 7932 §5), after a second refill (12) when the buffer holds fewer.
    \\    rorx rbx, r13, {[extra_bits_at]}
    \\    movzx ebx, bl
    \\    cmp ebx, r9d
    \\    ja 12f
    \\11:
    \\    bzhi rcx, r8, rbx
    \\    rorx rax, r13, {[insert_extra_bits_at]}
    \\    movzx eax, al
    \\    bzhi r15, rcx, rax
    \\    movzx r14d, r13w
    \\    add r15d, r14d
    \\    // RFC 7932 §9.3: literals that would exceed MLEN; the checked path refuses them.
    \\    cmp r15d, r10d
    \\    ja 83f
    \\    shrx r8, r8, rbx
    \\    sub r9b, bl
    \\    shrx r14, rcx, rax
    \\    rorx rcx, r13, {[copy_base_at]}
    \\    movzx ecx, cx
    \\    add r14d, ecx
    \\    test r15d, r15d
    \\    jz 30f
;

/// The command's literals (RFC 7932 §7.1, §7.3): runs of at most a chunk of its block, each literal
/// with the table its context picks, the buffer refilled while the slack holds.
pub const literals =
    \\20:
    \\    // A run starts with a code's bits in the buffer or the slack to refill; the checked path
    \\    // takes the literals otherwise. A spent block takes a block switch first, in Zig.
    \\    cmp r9d, {[code_len_max]}
    \\    jae 65f
    \\    cmp rsi, qword ptr [rdi + {[input_limit]}]
    \\    ja 84f
    \\65:
    \\    cmp qword ptr [rdi + {[lit_count]}], 0
    \\    je 85f
    \\    mov ebx, {[chunk_len_max]}
    \\    cmp r15d, ebx
    \\    cmovb ebx, r15d
    \\    mov rax, qword ptr [rdi + {[lit_count]}]
    \\    cmp rax, rbx
    \\    cmovb rbx, rax
    \\    mov qword ptr [rdi + {[copy_len]}], r14
    \\    mov qword ptr [rdi + {[insert_left]}], r15
    \\    mov qword ptr [rdi + {[batch]}], rbx
    \\    mov qword ptr [rdi + {[meta_block_left]}], r10
    \\    mov qword ptr [rdi + {[packed_code]}], r13
    \\    // The two loads this text took here, as no-operations: a run's speed moves with its address.
    \\    .byte 0x0f, 0x1f, 0x80, 0x00, 0x00, 0x00, 0x00
    \\    .byte 0x0f, 0x1f, 0x80, 0x00, 0x00, 0x00, 0x00
    \\    mov r13, qword ptr [rdi + {[lit_tables]}]
    \\    mov rax, qword ptr [rdi + {[run_kind]}]
    \\    test rax, rax
    \\    jz 25f
    \\    mov r15, qword ptr [rdi + {[lut_p2]}]
    \\    cmp rax, {[kind_entry_parts]}
    \\    je 70f
    \\    mov r14, qword ptr [rdi + {[lut_p1]}]
    \\21:
    \\    cmp r9d, {[code_len_max]}
    \\    jb 28f
    \\22:
    \\    // The context ID from p1 and p2 (RFC 7932 §7.1), its table, and the literal.
    \\    movzx eax, byte ptr [r14 + r11]
    \\    movzx r10d, byte ptr [r15 + r12]
    \\    or eax, r10d
    \\    mov rax, qword ptr [r13 + rax*8]
++ "\n" ++ lookup("rax", "rcx", "51", "55") ++
    \\    shrx r8, r8, rcx
    \\    sub r9b, cl
    \\    mov r12d, r11d
    \\    shr ecx, {[entry_value_at]}
    \\    movzx r11d, cl
    \\    mov byte ptr [rdx], cl
    \\    inc rdx
    \\    {[count_literal]s}
    \\    dec ebx
    \\    jnz 21b
    \\    jmp 23f
    \\70:
    \\    // The entries' mode: p1's part of the next context ID comes from the entry of the literal
    \\    // before it (`context.literal_entry_value`), so no load stands between a literal and its
    \\    // successor's table; p2's part from the lut, off that path. The first takes both from
    \\    // the luts.
    \\    mov r14, qword ptr [rdi + {[lut_p1]}]
    \\    movzx r14d, byte ptr [r14 + r11]
    \\    movzx r10d, byte ptr [r15 + r12]
    \\71:
    \\    cmp r9d, {[code_len_max]}
    \\    jb 73f
    \\72:
    \\    mov eax, r14d
    \\    or eax, r10d
    \\    mov rax, qword ptr [r13 + rax*8]
++ "\n" ++ lookup("rax", "rcx", "58", "59") ++
    \\    shrx r8, r8, rcx
    \\    sub r9b, cl
    \\    movzx r10d, byte ptr [r15 + r11]
    \\    shr ecx, {[entry_value_at]}
    \\    mov r14d, ecx
    \\    shr r14d, {[entry_p1_part_shift]}
    \\    mov r12d, r11d
    \\    movzx r11d, cl
    \\    mov byte ptr [rdx], cl
    \\    inc rdx
    \\    {[count_literal]s}
    \\    dec ebx
    \\    jnz 71b
    \\    jmp 23f
    \\25:
    \\    // One tree for every context: the first table, and no context ID.
    \\    mov rax, qword ptr [r13]
    \\26:
    \\    cmp r9d, {[code_len_max]}
    \\    jb 29f
    \\27:
++ "\n" ++ lookup("rax", "rcx", "53", "57") ++
    \\    shrx r8, r8, rcx
    \\    sub r9b, cl
    \\    mov r12d, r11d
    \\    shr ecx, {[entry_value_at]}
    \\    movzx r11d, cl
    \\    mov byte ptr [rdx], cl
    \\    inc rdx
    \\    {[count_literal]s}
    \\    dec ebx
    \\    jnz 26b
    \\23:
    \\    // The run's octets: off the block, the insert and the meta-block. Literals left take the
    \\    // next run while the room's margin holds, or the room as the octets left (94); so does
    \\    // the copy (95).
    \\    mov rax, qword ptr [rdi + {[batch]}]
    \\    sub eax, ebx
    \\    mov r14, qword ptr [rdi + {[copy_len]}]
    \\    mov r15, qword ptr [rdi + {[insert_left]}]
    \\    mov r10, qword ptr [rdi + {[meta_block_left]}]
    \\    mov r13, qword ptr [rdi + {[packed_code]}]
    \\    mov qword ptr [rdi + {[p1]}], r11
    \\    mov qword ptr [rdi + {[p2]}], r12
    \\    sub qword ptr [rdi + {[lit_count]}], rax
    \\    sub r15d, eax
    \\    sub r10d, eax
    \\    test r15d, r15d
    \\    jz 24f
    \\    cmp rdx, qword ptr [rdi + {[output_limit]}]
    \\    ja 94f
    \\    jmp 20b
    \\24:
    \\    test r10d, r10d
    \\    jz 98f
    \\    cmp rdx, qword ptr [rdi + {[output_limit]}]
    \\    ja 95f
;
