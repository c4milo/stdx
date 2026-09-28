//! The text of the loop of `fast_x86_64.zig`, in the pieces its `template` joins, in Intel syntax:
//! the port of `fast_aarch64_template.zig`, whose comment describes the loop.
//!
//! Registers: rdi the loop's state; rsi the input's next octet; rdx the output's next octet; r8 the
//! bit buffer and r9d its count, in its low octet; r10 the literal/length table and r11 its index's
//! bits; r12d the next symbol's entry; r13 and r14d the buffer and its count past a match, r15 the
//! match's length, rax its distance and rbx its source; rcx each symbol's values. The limits, the
//! distance table, the distance codes and the repeats stay in the state, which the loop reads in
//! place.
//!
//! BMI2's SHRX and SHLX shift by a register's low six bits, which an entry's used bits are, and
//! BZHI keeps the bits below its index, an entry's low octet; RORX brings a field of an entry to
//! its low bits without changing the entry; SSSE3's PSHUFB repeats a short distance's octets.
//!
//! The text writes the numbers the entry's layout fixes, which `fast_x86_64.zig` asserts: a code's
//! bits in 4 bits (15), a distance symbol in 5 (31), a distance code's mask above its 16 bits of
//! base, and a chunk of 16 octets (a shift of 4). The numbered labels are those of the aarch64 text.

/// The prologue: the state, a refill, and the first symbol's entry.
pub const prologue =
    \\    .intel_syntax noprefix
    \\    mov rsi, qword ptr [rdi + {[input]}]
    \\    mov rdx, qword ptr [rdi + {[output]}]
    \\    mov r8, qword ptr [rdi + {[buffer]}]
    \\    mov r9, qword ptr [rdi + {[count]}]
    \\    mov r10, qword ptr [rdi + {[literal_length_entries]}]
    \\    mov r11, qword ptr [rdi + {[literal_length_bits]}]
    \\    // A buffer of fewer than 64 bits takes the next 8 octets above its count (S1), so each of
    \\    // its 64 bits is the stream's; a full one is the stream's already.
    \\    cmp r9, 64
    \\    jae 20f
    \\    mov rax, qword ptr [rsi]
    \\    shlx rax, rax, r9
    \\    or r8, rax
    \\    movzx eax, r9b
    \\    xor eax, 63
    \\    shr eax, 3
    \\    add rsi, rax
    \\    or r9d, {[refill_bits]}
    \\20:
    \\    bzhi rax, r8, r11
    \\    mov r12d, dword ptr [r10 + rax*4]
    \\    // The loop starts a fetch line of its own, wherever the code before it ends.
    \\    .p2align 6
;

/// An iteration's margins and its symbol's kind. Each iteration writes an octet at least, so the
/// output margin ends the loop.
pub const iteration =
    \\1:
    \\    // Decision 16's margins: the 8 octets of the refill, and the room of a longest match and
    \\    // its last chunk's overrun.
    \\    cmp rsi, qword ptr [rdi + {[input_limit]}]
    \\    ja 80f
    \\    cmp rdx, qword ptr [rdi + {[output_limit]}]
    \\    ja 80f
    \\    test r12d, {[literal_bit]}
    \\    jz 3f
;

/// A literal (RFC 1951 §3.2.5): its octet written and its bits used.
pub const literal =
    \\    shrx r8, r8, r12
    \\    sub r9d, r12d
    \\    shr r12d, {[value_at]}
    \\    mov byte ptr [rdx], r12b
    \\    inc rdx
    \\    {[count_literal]s}
;

/// The lookup after each literal of a run but the last; anything but a literal ends the run.
pub const literal_next =
    \\    bzhi rax, r8, r11
    \\    mov r12d, dword ptr [r10 + rax*4]
    \\    test r12d, {[literal_bit]}
    \\    jz 5f
;

/// The refill of r8 and r9d from the input.
const refill =
    \\    mov rax, qword ptr [rsi]
    \\    shlx rax, rax, r9
    \\    or r8, rax
    \\    movzx eax, r9b
    \\    xor eax, 63
    \\    shr eax, 3
    \\    add rsi, rax
    \\    or r9d, {[refill_bits]}
;

/// After the last literal of a run, the refill comes before the lookup; after a shorter run, the
/// refill alone.
pub const literal_last = refill ++
    \\
    \\    bzhi rax, r8, r11
    \\    mov r12d, dword ptr [r10 + rax*4]
    \\    jmp 1b
    \\5:
    \\
++ refill ++
    \\
    \\    jmp 1b
;

/// A match from a combined entry (S11), and its checks.
pub const combined =
    \\3:
    \\    test r12d, {[combined_bit]}
    \\    jz 4f
    \\    // The distance: its symbol's base plus the extra bits after the entry's codes (RFC 1951
    \\    // §3.2.5), where the entry's code bits say they start.
    \\    rorx eax, r12d, {[distance_symbol_at]}
    \\    and eax, 31
    \\    mov rcx, qword ptr [rdi + {[distance_codes]}]
    \\    mov eax, dword ptr [rcx + rax*4]
    \\    rorx ecx, r12d, {[code_bits_at]}
    \\    and ecx, 15
    \\    shrx rcx, r8, rcx
    \\    mov ebx, eax
    \\    shr ebx, 16
    \\    and rcx, rbx
    \\    movzx eax, ax
    \\    add rax, rcx
    \\    rorx r15d, r12d, {[value_at]}
    \\    and r15d, {[combined_length_mask]}
    \\    shrx r13, r8, r12
    \\    mov r14d, r9d
    \\    sub r14d, r12d
    \\    // The checks: the match reads this call's output (invariant 10), no farther than the
    \\    // stream's window, and two chunks back at least.
    \\    mov rbx, rdx
    \\    sub rbx, rax
    \\    jb 70f
    \\    cmp rbx, qword ptr [rdi + {[output_start]}]
    \\    jb 70f
    \\    cmp rax, qword ptr [rdi + {[distance_max]}]
    \\    ja 70f
    \\    cmp rax, {[pair_below]}
    \\    jbe 70f
;

/// The match's copy, where the distance is two chunks at least, and the next symbol, a literal
/// after the match taking its octet before the refill.
pub const copy =
    \\6:
    \\    movdqu xmm0, xmmword ptr [rbx]
    \\    movdqu xmm1, xmmword ptr [rbx + {[chunk]}]
    \\    movdqu xmmword ptr [rdx], xmm0
    \\    movdqu xmmword ptr [rdx + {[chunk]}], xmm1
    \\    movdqu xmm2, xmmword ptr [rbx + {[third_chunk_at]}]
    \\    movdqu xmmword ptr [rdx + {[third_chunk_at]}], xmm2
    \\    cmp r15, {[chunks_len]}
    \\    ja 75f
    \\7:
    \\    add rdx, r15
    \\    {[count_match]s}
    \\    bzhi rax, r13, r11
    \\    mov r12d, dword ptr [r10 + rax*4]
    \\    test r12d, {[literal_bit]}
    \\    jz 8f
    \\    shrx r13, r13, r12
    \\    sub r14d, r12d
    \\    shr r12d, {[value_at]}
    \\    mov byte ptr [rdx], r12b
    \\    inc rdx
    \\    {[count_literal]s}
    \\    bzhi rax, r13, r11
    \\    mov r12d, dword ptr [r10 + rax*4]
    \\8:
    \\    mov r8, r13
    \\    mov rax, qword ptr [rsi]
    \\    shlx rax, rax, r14
    \\    or r8, rax
    \\    movzx eax, r14b
    \\    xor eax, 63
    \\    shr eax, 3
    \\    add rsi, rax
    \\    or r14d, {[refill_bits]}
    \\    mov r9, r14
    \\    jmp 1b
;

/// A match from a length's own entry and its distance's.
pub const plain =
    \\4:
    \\    // A length: its value, or its base and the extra bits after its code (RFC 1951 §3.2.5).
    \\    // Any other entry, and a distance's code longer than its table, go to `decode_rare`.
    \\    test r12d, {[direct_bit]}
    \\    jz 90f
    \\    shrx r13, r8, r12
    \\    mov rcx, qword ptr [rdi + {[distance_bits]}]
    \\    bzhi rax, r13, rcx
    \\    mov rcx, qword ptr [rdi + {[distance_entries]}]
    \\    mov r14d, dword ptr [rcx + rax*4]
    \\    bzhi r15, r8, r12
    \\    rorx ecx, r12d, {[code_bits_at]}
    \\    and ecx, 15
    \\    shrx r15, r15, rcx
    \\    rorx ecx, r12d, {[value_at]}
    \\    movzx ecx, cx
    \\    add r15, rcx
    \\    test r14d, {[direct_bit]}
    \\    jz 90f
    \\    bzhi rax, r13, r14
    \\    rorx ecx, r14d, {[code_bits_at]}
    \\    and ecx, 15
    \\    shrx rax, rax, rcx
    \\    rorx ecx, r14d, {[value_at]}
    \\    movzx ecx, cx
    \\    add rax, rcx
    \\    shrx r13, r13, r14
    \\    mov ecx, r9d
    \\    sub ecx, r12d
    \\    sub ecx, r14d
    \\    mov r14d, ecx
    \\    // RFC 1951 §3.2.5: 258 has code 285 alone, so 258 from a base and extra bits goes to the
    \\    // checked path, which refuses it.
    \\    test r12d, {[extra_bit]}
    \\    jz 41f
    \\    cmp r15, {[match_len_max]}
    \\    je 90f
    \\41:
    \\    mov rbx, rdx
    \\    sub rbx, rax
    \\    jb 70f
    \\    cmp rbx, qword ptr [rdi + {[output_start]}]
    \\    jb 70f
    \\    cmp rax, qword ptr [rdi + {[distance_max]}]
    \\    ja 70f
    \\    cmp rax, {[pair_below]}
    \\    ja 6b
;

/// A match's other cases: the window, a distance past the stream's window, a distance below two
/// chunks, and the rest of a long match.
pub const other_cases =
    \\70:
    \\    mov rbx, rdx
    \\    sub rbx, rax
    \\    jb 90f
    \\    cmp rbx, qword ptr [rdi + {[output_start]}]
    \\    jb 90f
    \\    cmp rax, qword ptr [rdi + {[distance_max]}]
    \\    ja 90f
    \\    cmp rax, {[chunk]}
    \\    jb 73f
    \\    // A distance of a chunk to two: a chunk at a time, each reading octets written before it.
    \\    movdqu xmm0, xmmword ptr [rbx]
    \\    movdqu xmmword ptr [rdx], xmm0
    \\    movdqu xmm0, xmmword ptr [rbx + {[chunk]}]
    \\    movdqu xmmword ptr [rdx + {[chunk]}], xmm0
    \\    movdqu xmm0, xmmword ptr [rbx + {[third_chunk_at]}]
    \\    movdqu xmmword ptr [rdx + {[third_chunk_at]}], xmm0
    \\    cmp r15, {[chunks_len]}
    \\    jbe 7b
    \\    lea rcx, [rbx + {[chunks_len]}]
    \\    lea rax, [rdx + {[chunks_len]}]
    \\    lea rbx, [rdx + r15]
    \\74:
    \\    movdqu xmm0, xmmword ptr [rcx]
    \\    movdqu xmmword ptr [rax], xmm0
    \\    add rcx, {[chunk]}
    \\    add rax, {[chunk]}
    \\    cmp rax, rbx
    \\    jb 74b
    \\    jmp 7b
    \\73:
    \\    // A distance below a chunk, the match overlapping itself (RFC 1951 §3.2.3): the first chunk
    \\    // is the distance's octets repeated, from the chunk before the target, which one shuffle
    \\    // arranges; the rest repeats it where the distance divides a chunk, and otherwise goes a
    \\    // chunk at a time from the least multiple of the distance a chunk back at least. With less
    \\    // than a chunk of this call's output before the target, it goes to `decode_rare`.
    \\    lea rcx, [rdx - {[chunk]}]
    \\    cmp rcx, qword ptr [rdi + {[output_start]}]
    \\    jb 90f
    \\    mov rcx, qword ptr [rdi + {[repeats]}]
    \\    mov rbx, rax
    \\    shl rbx, 4
    \\    movdqu xmm1, xmmword ptr [rcx + rbx]
    \\    movdqu xmm0, xmmword ptr [rdx - {[chunk]}]
    \\    pshufb xmm0, xmm1
    \\    movdqu xmmword ptr [rdx], xmm0
    \\    cmp r15, {[chunk]}
    \\    jbe 7b
    \\    movzx ebx, byte ptr [rcx + rax + {[steps]}]
    \\    cmp ebx, {[chunk]}
    \\    jne 77f
    \\    lea rcx, [rdx + {[chunk]}]
    \\    lea rax, [rdx + r15]
    \\78:
    \\    movdqu xmmword ptr [rcx], xmm0
    \\    movdqu xmmword ptr [rcx + {[chunk]}], xmm0
    \\    add rcx, {[pair]}
    \\    cmp rcx, rax
    \\    jb 78b
    \\    jmp 7b
    \\77:
    \\    mov rcx, rdx
    \\    sub rcx, rbx
    \\    mov eax, {[chunk]}
    \\72:
    \\    movdqu xmm0, xmmword ptr [rcx + rax]
    \\    movdqu xmmword ptr [rdx + rax], xmm0
    \\    add rax, {[chunk]}
    \\    cmp rax, r15
    \\    jb 72b
    \\    jmp 7b
    \\75:
    \\    // The rest of a match past its first three chunks, two chunks at a time.
    \\    lea rcx, [rbx + {[chunks_len]}]
    \\    lea rax, [rdx + {[chunks_len]}]
    \\    lea rbx, [rdx + r15]
    \\76:
    \\    movdqu xmm0, xmmword ptr [rcx]
    \\    movdqu xmm1, xmmword ptr [rcx + {[chunk]}]
    \\    movdqu xmmword ptr [rax], xmm0
    \\    movdqu xmmword ptr [rax + {[chunk]}], xmm1
    \\    add rcx, {[pair]}
    \\    add rax, {[pair]}
    \\    cmp rax, rbx
    \\    jb 76b
    \\    jmp 7b
;

/// The exits, with the state stored back and why the loop stopped in rax.
pub const exits =
    \\80:
    \\    xor eax, eax
    \\    jmp 99f
    \\90:
    \\    mov eax, 1
    \\99:
    \\    mov qword ptr [rdi + {[input]}], rsi
    \\    mov qword ptr [rdi + {[output]}], rdx
    \\    mov qword ptr [rdi + {[buffer]}], r8
    \\    movzx r9d, r9b
    \\    mov qword ptr [rdi + {[count]}], r9
    \\    .att_syntax prefix
;
