//! The text of the loop of `encoder_match_lazy_x86_64.zig`, in the pieces its `template` joins, in
//! Intel syntax: the port of `encoder_match_lazy_aarch64_template.zig`, whose comment describes
//! the loop and whose labels this text keeps.
//!
//! Registers: rdi the loop's state; rsi the window and r9 the chain; r8 the block's symbols
//! added, which a register holds so that no symbol waits on the last one's store; rdx the
//! position; r11d the position's 4 octets; r12 the waiting match, its distance in bits 0 to 15,
//! its length in 16 to 31 and whether it waits in bit 32, which a register holds so that no
//! position waits on the last one's stores; ecx that length, while a position tests it. The walk keeps r14
//! its next link, r15 the links it may still read, rbx its floor, rcx its shift and eax the 4
//! octets that decide a candidate. r10, r13 and rbp hold each step's values; the caller's rbp
//! waits in the state. The heads, read where a step needs them, the match found, the reach's
//! edge, the walk's offset
//! and tail, the candidate and the match's distance stay in the state, which the loop reads in
//! place.
//!
//! IMUL by an immediate takes the hash's multiplier, BSR a distance's bit length less one, and
//! BSF the first octet of a word that differs. The text writes the numbers the layouts fix, which
//! `encoder_match_lazy_x86_64.zig` asserts: a chain slot's mask of 0x7fff, entries of 2 octets in
//! the heads, the chain and the counts, symbols of 4 octets, and a `Symbol`'s distance at bit 8
//! and its code at bit 24.

/// The prologue: the caller's rbp kept, and the state.
pub const prologue =
    \\    .intel_syntax noprefix
    \\    mov qword ptr [rdi + {[saved_frame]}], rbp
    \\    mov rsi, qword ptr [rdi + {[window]}]
    \\    mov r9, qword ptr [rdi + {[chain]}]
    \\    mov rdx, qword ptr [rdi + {[position]}]
    \\    mov r8, qword ptr [rdi + {[count]}]
    \\    mov r12, qword ptr [rdi + {[previous_distance]}]
    \\    mov r10, qword ptr [rdi + {[previous_len]}]
    \\    shl r10, 16
    \\    or r12, r10
    \\    mov r10, qword ptr [rdi + {[waiting]}]
    \\    shl r10, 32
    \\    or r12, r10
    \\    .p2align 6
;

/// A position: the loop's bounds, the position joined to its chain, and the lowest position its
/// candidates may lie at.
pub const position =
    \\1:
    \\    cmp rdx, qword ptr [rdi + {[end]}]
    \\    jae 90f
    \\    cmp r8, {[symbols_max]}
    \\    jae 90f
    \\    mov r11d, dword ptr [rsi + rdx]
    \\    imul eax, r11d, {[multiplier]}
    \\    shr eax, {[hash_shift]}
    \\    mov r13, qword ptr [rdi + {[heads]}]
    \\    movzx r14d, word ptr [r13 + rax*2]
    \\    mov ebp, edx
    \\    and ebp, 0x7fff
    \\    mov word ptr [r9 + rbp*2], r14w
    \\    mov word ptr [r13 + rax*2], dx
    \\    lea r10, [rdx - {[distance_max]}]
    \\    mov eax, 1
    \\    cmp rdx, {[distance_max]}
    \\    cmovbe r10, rax
    \\    mov rcx, r12
    \\    shr rcx, 16
    \\    and ecx, 0xffff
;

/// Whether the position searches, as the aarch64 text decides it, with one branch for the short
/// chain where the aarch64 text has two: Zig's form on x86-64 (`short_chain_misses`), whose
/// branches cost there as much as the walks they save. The first candidate read is the nearest in
/// reach, or the position itself; the second the one after it in reach, or the first again; the
/// walk runs where the nearest is in reach and one of the two holds the position's octets, or
/// where a third lies in reach. A position that searches nothing finds no match, so its lazy step
/// needs no compare: a waiting match is taken, else the waiting position's literal is added and a
/// literal waits, with no match found stored and read back.
pub const skips =
    \\    bt r12, 32
    \\    jnc 30f
    \\    cmp ecx, {[lazy_len]}
    \\    jae 20f
    \\30:
    \\    test ecx, ecx
    \\    jnz 10f
    \\    mov rbp, rdx
    \\    cmp r14, r10
    \\    cmovae rbp, r14
    \\    xor eax, eax
    \\    cmp dword ptr [rsi + rbp], r11d
    \\    sete al
    \\    mov r13d, ebp
    \\    and r13d, 0x7fff
    \\    movzx r13d, word ptr [r9 + r13*2]
    \\    cmp r13, r10
    \\    cmovae rbp, r13
    \\    cmp dword ptr [rsi + rbp], r11d
    \\    sete r13b
    \\    or al, r13b
    \\    and ebp, 0x7fff
    \\    movzx ebp, word ptr [r9 + rbp*2]
    \\    cmp r14, r10
    \\    setae r13b
    \\    and al, r13b
    \\    cmp rbp, r10
    \\    setae r13b
    \\    or al, r13b
    \\    jnz 10f
    \\20:
    \\    bt r12, 32
    \\    jnc 62f
    \\    cmp ecx, {[match_len_taken_min]}
    \\    jb 63f
    \\    mov ebp, ecx
    \\    jmp 70f
    \\63:
    \\    movzx ebp, byte ptr [rsi + rdx - 1]
    \\    mov r10, qword ptr [rdi + {[symbols]}]
    \\    mov dword ptr [r10 + r8*4], ebp
    \\    inc r8
    \\    mov r10, qword ptr [rdi + {[literal_length_counts]}]
    \\    inc word ptr [r10 + rbp*2]
    \\62:
    \\    xor r12d, r12d
    \\    bts r12, 32
    \\    inc rdx
    \\    jmp 1b
;

/// The search's start: none found, the budget, and the position's own chain.
pub const search =
    \\10:
    \\    mov qword ptr [rdi + {[found_len]}], 0
    \\    mov qword ptr [rdi + {[found_distance]}], 0
    \\    mov r15d, {[candidates_max]}
    \\    mov eax, {[cut_candidates_max]}
    \\    cmp ecx, {[cut_len]}
    \\    cmovae r15, rax
    \\    mov rbx, r10
    \\    mov qword ptr [rdi + {[lowest]}], r10
    \\    mov qword ptr [rdi + {[offset]}], 0
    \\    mov qword ptr [rdi + {[tail]}], 0
    \\    xor ecx, ecx
    \\    mov eax, r11d
;

/// A link, as the aarch64 text walks it, at a 16-octet boundary.
pub const link =
    \\    .p2align 4
    \\40:
    \\    test r15, r15
    \\    jz 49f
    \\    cmp r14, rbx
    \\    jb 49f
    \\    mov rbp, r14
    \\    mov r13d, r14d
    \\    and r13d, 0x7fff
    \\    movzx r14d, word ptr [r9 + r13*2]
    \\    dec r15
    \\    lea r13, [rbp + rcx]
    \\    cmp dword ptr [rsi + r13], eax
    \\    jne 40b
    \\    sub rbp, qword ptr [rdi + {[offset]}]
    \\    cmp dword ptr [rsi + rbp], r11d
    \\    jne 40b
    \\    mov qword ptr [rdi + {[candidate]}], rbp
    \\    lea r10, [rsi + rbp]
    \\    lea r13, [rsi + rdx]
    \\    lea rbp, [r13 + {[words_len]}]
    \\    mov qword ptr [rdi + {[compare_end]}], rbp
;

/// The match's compare, 8 octets a pass, at the candidate (r10) and at the position (r13), up to
/// the end of its whole words, which the state keeps: a loop and not 32 copies, as Zig's
/// `match_len` is, so that the walk's code stays small.
pub const compare_word =
    \\50:
    \\    mov rbp, qword ptr [r10]
    \\    xor rbp, qword ptr [r13]
    \\    jnz 56f
    \\    add r10, 8
    \\    add r13, 8
    \\    cmp r13, qword ptr [rdi + {[compare_end]}]
    \\    jb 50b
;

/// The compare's last octets, past its whole words, and the length it finds, in r10.
pub const compare_end =
    \\    movzx ebp, byte ptr [r10]
    \\    cmp bpl, byte ptr [r13]
    \\    jne 57f
    \\    movzx ebp, byte ptr [r10 + 1]
    \\    cmp bpl, byte ptr [r13 + 1]
    \\    mov r10d, {[words_len_plus_one]}
    \\    jne 58f
    \\    inc r10
    \\    jmp 58f
    \\56:
    \\    bsf rbp, rbp
    \\    shr ebp, 3
    \\    sub r10, rsi
    \\    sub r10, qword ptr [rdi + {[candidate]}]
    \\    add r10, rbp
    \\    jmp 58f
    \\57:
    \\    mov r10d, {[words_len]}
;

/// The match's length, and what a longer one moves, as the aarch64 text moves it.
pub const longer =
    \\58:
    \\    cmp r10, qword ptr [rdi + {[found_len]}]
    \\    jbe 40b
    \\    mov qword ptr [rdi + {[found_len]}], r10
    \\    mov rbp, rdx
    \\    sub rbp, qword ptr [rdi + {[candidate]}]
    \\    mov qword ptr [rdi + {[found_distance]}], rbp
    \\    cmp r10, {[nice_len]}
    \\    jae 49f
    \\    cmp r14, rbx
    \\    jb 49f
    \\    mov rbp, rdx
    \\    mov r13d, 0
    \\    sub rbp, r10
    \\    cmovb rbp, r13
    \\    mov r13, qword ptr [rdi + {[candidate]}]
    \\    cmp r13, rbp
    \\    cmovb rbp, r13
    \\    cmp rbp, qword ptr [rdi + {[lowest]}]
    \\    jbe 49f
    \\    lea r13, [r10 - {[tail_back]}]
    \\    mov qword ptr [rdi + {[tail]}], r13
    \\    lea r10, [rdx + r13]
    \\    mov eax, dword ptr [rsi + r10]
    \\    mov r10, r14
    \\    sub r10, qword ptr [rdi + {[offset]}]
    \\    mov r13, qword ptr [rdi + {[candidate]}]
    \\    sub r13, r10
    \\    imul r13, r13, {[move_candidates_min]}
    \\    mov r10, qword ptr [rdi + {[candidate]}]
    \\    sub r10, qword ptr [rdi + {[lowest]}]
    \\    cmp r13, r10
    \\    ja 45f
    \\    add rbp, qword ptr [rdi + {[tail]}]
    \\    imul r10d, eax, {[multiplier]}
    \\    shr r10d, {[hash_shift]}
    \\    mov r13, qword ptr [rdi + {[heads]}]
    \\    movzx r10d, word ptr [r13 + r10*2]
;

/// One skip of a move: the budget less one, at 0 at least.
pub const skip =
    \\    cmp r10, rbp
    \\    jb 44f
    \\    and r10d, 0x7fff
    \\    movzx r10d, word ptr [r9 + r10*2]
    \\    sub r15, 1
    \\    adc r15, 0
;

/// The move's test, the walk's new floor and shift, and the walk's end.
pub const moved =
    \\44:
    \\    cmp r10, rbp
    \\    jae 45f
    \\    mov r13, r10
    \\    add r13, qword ptr [rdi + {[offset]}]
    \\    mov rbp, r14
    \\    add rbp, qword ptr [rdi + {[tail]}]
    \\    cmp r13, rbp
    \\    jae 45f
    \\    mov r14, r10
    \\    mov r13, qword ptr [rdi + {[tail]}]
    \\    mov qword ptr [rdi + {[offset]}], r13
    \\45:
    \\    mov rbx, qword ptr [rdi + {[lowest]}]
    \\    add rbx, qword ptr [rdi + {[offset]}]
    \\    mov rcx, qword ptr [rdi + {[tail]}]
    \\    sub rcx, qword ptr [rdi + {[offset]}]
    \\    jmp 40b
;

/// The lazy step, by decision 52's compare: a bit length less one on each side changes no
/// difference.
pub const decide =
    \\49:
    \\    bt r12, 32
    \\    jnc 60f
    \\    mov rbp, r12
    \\    shr rbp, 16
    \\    and ebp, 0xffff
    \\    cmp rbp, {[match_len_taken_min]}
    \\    jb 60f
    \\    mov r10, qword ptr [rdi + {[found_len]}]
    \\    cmp r10, rbp
    \\    jb 70f
    \\    bsr r13, qword ptr [rdi + {[found_distance]}]
    \\    lea rax, [r10*4]
    \\    sub rax, r13
    \\    movzx r13d, r12w
    \\    bsr r13, r13
    \\    lea r10, [rbp*4 + {[margin]}]
    \\    sub r10, r13
    \\    cmp rax, r10
    \\    jle 70f
    \\60:
    \\    bt r12, 32
    \\    jnc 61f
    \\    movzx ebp, byte ptr [rsi + rdx - 1]
    \\    mov r10, qword ptr [rdi + {[symbols]}]
    \\    mov dword ptr [r10 + r8*4], ebp
    \\    inc r8
    \\    mov r10, qword ptr [rdi + {[literal_length_counts]}]
    \\    inc word ptr [r10 + rbp*2]
    \\61:
    \\    mov r12, qword ptr [rdi + {[found_len]}]
    \\    shl r12, 16
    \\    or r12, qword ptr [rdi + {[found_distance]}]
    \\    bts r12, 32
    \\    inc rdx
    \\    jmp 1b
;

/// A waiting match taken, as the aarch64 text takes it.
pub const take =
    \\70:
    \\    lea r13, [rdx - 1]
    \\    add r13, rbp
    \\    lea rbp, [rdx + 1]
    \\    mov r15, qword ptr [rdi + {[heads]}]
    \\71:
    \\    cmp rbp, r13
    \\    jae 72f
    \\    mov eax, dword ptr [rsi + rbp]
    \\    imul eax, eax, {[multiplier]}
    \\    shr eax, {[hash_shift]}
    \\    movzx r10d, word ptr [r15 + rax*2]
    \\    mov r11d, ebp
    \\    and r11d, 0x7fff
    \\    mov word ptr [r9 + r11*2], r10w
    \\    mov word ptr [r15 + rax*2], bp
    \\    inc rbp
    \\    jmp 71b
    \\72:
    \\    movzx eax, r12w
    \\    lea r10, [rax - 1]
    \\    mov r11, r10
    \\    shr r11, {[far_shift]}
    \\    mov rbp, qword ptr [rdi + {[near_codes]}]
    \\    add rbp, r10
    \\    mov r15, qword ptr [rdi + {[far_codes]}]
    \\    add r15, r11
    \\    cmp rax, {[near_distances]}
    \\    cmova rbp, r15
    \\    movzx ebp, byte ptr [rbp]
    \\    mov r10, r12
    \\    shr r10, 16
    \\    and r10d, 0xffff
    \\    sub r10, {[match_len_min]}
    \\    mov r11, rax
    \\    shl r11, {[distance_at]}
    \\    or r11, r10
    \\    mov r15, rbp
    \\    shl r15, {[code_at]}
    \\    or r11, r15
    \\    mov r15, qword ptr [rdi + {[symbols]}]
    \\    mov dword ptr [r15 + r8*4], r11d
    \\    inc r8
    \\    mov r15, qword ptr [rdi + {[length_codes]}]
    \\    movzx r10d, byte ptr [r15 + r10]
    \\    add r10, {[first_length_symbol]}
    \\    mov r15, qword ptr [rdi + {[literal_length_counts]}]
    \\    inc word ptr [r15 + r10*2]
    \\    mov r15, qword ptr [rdi + {[distance_counts]}]
    \\    inc word ptr [r15 + rbp*2]
    \\    mov rdx, r13
    \\    xor r12d, r12d
    \\    jmp 1b
;

/// The position stored back, and the caller's rbp.
pub const exit =
    \\90:
    \\    mov qword ptr [rdi + {[position]}], rdx
    \\    mov qword ptr [rdi + {[count]}], r8
    \\    movzx r10d, r12w
    \\    mov qword ptr [rdi + {[previous_distance]}], r10
    \\    mov r10, r12
    \\    shr r10, 16
    \\    and r10d, 0xffff
    \\    mov qword ptr [rdi + {[previous_len]}], r10
    \\    mov r10, r12
    \\    shr r10, 32
    \\    mov qword ptr [rdi + {[waiting]}], r10
    \\    mov rbp, qword ptr [rdi + {[saved_frame]}]
    \\    .att_syntax prefix
;
