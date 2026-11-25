//! The text of the loop of `fast_sequences_x86_64.zig`, in the pieces its `template` joins, in Intel
//! syntax.
//!
//! Registers: rdi the loop's state; r11 the literals length cells, which the offset and match
//! length cells follow at fixed distances; r8, r9 and r10 the states of literals length, offset and
//! match length; r14 the position less the 57 bits a load needs before it, negative when the load
//! has not them; r15 the output. rax holds the stream's bits, rdx the bits below the next field,
//! rcx a field's width, rbx the Offset_Value and then the distance, r12 the match length, r13 the
//! literals length, and rsi the repeat's number. The rest of the state stays in `Loop`, which the
//! checks read in place.
//!
//! The numbered labels: 1 a sequence, 2 a repeated offset and 3 the checks where branches take the
//! offset, 4 more literals, 5 the match, 6 a distance below a chunk, 7 more of the match, 8 the
//! next sequence, 9 the state stored back.

/// The prologue, and a sequence's fields.
pub const decode =
    \\    .intel_syntax noprefix
    \\    mov r11, qword ptr [rdi + {[literals_length]}]
    \\    mov r15, qword ptr [rdi + {[output]}]
    \\    mov r14, qword ptr [rdi + {[position]}]
    \\    sub r14, {[read_min]}
    \\    mov r8, qword ptr [rdi + {[literals_length_state]}]
    \\    mov r9, qword ptr [rdi + {[offset_state]}]
    \\    mov r10, qword ptr [rdi + {[match_length_state]}]
    \\    cmp qword ptr [rdi + {[left]}], 0
    \\    je 9f
    \\    // The loop starts a fetch line of its own, wherever the code before it ends.
    \\    .p2align 6
    \\1:
    \\    // The load's bits before the position.
    \\    test r14, r14
    \\    js 9f
    \\    // The 8 octets whose last holds the position's bit, least significant first, shifted so
    \\    // that bit leads (RFC 8878 §4.1): 57 bits of the stream at least.
    \\    mov rcx, r14
    \\    shr rcx, 3
    \\    mov rax, qword ptr [rdi + {[stream]}]
    \\    mov rax, qword ptr [rax + rcx]
    \\    mov ecx, r14d
    \\    not ecx
    \\    and ecx, 7
    \\    shlx rax, rax, rcx
    \\    // RFC 8878 §3.1.1.3.2.1.2: the offset, match length and literals length bits, each from
    \\    // the top of what the fields before it leave, plus its cell's base. A field of `width`
    \\    // bits: the bits below it shifted out and those above it cleared, so a field of none is
    \\    // 0. A state is below its table's length, so its cell is inside the table (RFC 8878 §4.1).
    \\    mov edx, {[word_bits]}
    \\    movzx ecx, byte ptr [r11 + r9*8 + {[offset_cells]} + {[extra_at]}]
    \\    sub edx, ecx
    \\    shrx rbx, rax, rdx
    \\    bzhi rbx, rbx, rcx
    \\    add ebx, dword ptr [r11 + r9*8 + {[offset_cells]}]
    \\    movzx ecx, byte ptr [r11 + r10*8 + {[match_length_cells]} + {[extra_at]}]
    \\    sub edx, ecx
    \\    shrx r12, rax, rdx
    \\    bzhi r12, r12, rcx
    \\    add r12d, dword ptr [r11 + r10*8 + {[match_length_cells]}]
    \\    movzx ecx, byte ptr [r11 + r8*8 + {[extra_at]}]
    \\    sub edx, ecx
    \\    shrx r13, rax, rdx
    \\    bzhi r13, r13, rcx
    \\    add r13d, dword ptr [r11 + r8*8]
;

/// A new offset by one branch, and a repeat by the branches of `repeats_by_branches`.
pub const offsets_by_branches =
    \\    // rbx Offset_Value, r12 the match length, r13 the literals length. An Offset_Value above
    \\    // 3 is a new offset (RFC 8878 §3.1.1.5), and the repeats become it, the first and the
    \\    // second: rbx the distance, and rsi 3, which moves the repeats as a third repeat does.
    \\    cmp rbx, {[repeat_values]}
    \\    jbe 2f
    \\    sub rbx, {[repeat_values]}
    \\    mov esi, {[repeat_values]}
    \\3:
;

/// Every offset by selects, with no branch to mispredict on a block that mixes new and repeated
/// offsets.
pub const offsets_by_selects =
    \\    // rbx Offset_Value, r12 the match length, r13 the literals length (RFC 8878 §3.1.1.5).
    \\    // An Offset_Value above 3 is a new offset, Offset_Value less 3. One of 1 to 3 names a
    \\    // repeat, the next one when the literals length is 0, and the fourth is the first less
    \\    // one: rsi the repeat's number from 1, above 3 for a new offset; rbx the distance. The
    \\    // compare sets the carry for a literals length of 0.
    \\    cmp r13, 1
    \\    mov rsi, rbx
    \\    adc rsi, 0
    \\    mov rcx, qword ptr [rdi + {[repeat_first]}]
    \\    dec rcx
    \\    sub rbx, {[repeat_values]}
    \\    cmovbe rbx, rcx
    \\    cmp rsi, 3
    \\    cmove rbx, qword ptr [rdi + {[repeat_third]}]
    \\    cmp rsi, 2
    \\    cmove rbx, qword ptr [rdi + {[repeat_second]}]
    \\    cmovb rbx, qword ptr [rdi + {[repeat_first]}]
;

/// The checks of the checked path, up to the window's.
pub const checks =
    \\    // The checks of the checked path, each a branch out of the loop: the load held the bits
    \\    // read, 57 at least, so cl, the bits it holds below the last field, is 7 or more (a
    \\    // sequence of more goes to `step`); the literals are there; the block's size holds; the
    \\    // output holds the sequence's octets and the overrun of its copies; the offset is within
    \\    // Window_Size, and not 0 (invariant 10); and the match reads the call's own output, where
    \\    // a match reaching the window goes to `step`.
    \\    mov ecx, edx
    \\    sub cl, byte ptr [r11 + r8*8 + {[bits_at]}]
    \\    sub cl, byte ptr [r11 + r10*8 + {[match_length_cells]} + {[bits_at]}]
    \\    sub cl, byte ptr [r11 + r9*8 + {[offset_cells]} + {[bits_at]}]
    \\    cmp cl, {[bits_left_min]}
    \\    jl 9f
    \\    cmp r13, qword ptr [rdi + {[literals_room]}]
    \\    ja 9f
    \\    cmp r12, qword ptr [rdi + {[promised_room]}]
    \\    ja 9f
    \\    lea rcx, [r15 + r13]
    \\    add rcx, r12
    \\    cmp rcx, qword ptr [rdi + {[output_limit]}]
    \\    ja 9f
    \\    cmp rbx, qword ptr [rdi + {[window_len]}]
    \\    ja 9f
;

/// The window's check where branches took the offset: a repeat of 0 left the loop there. The
/// distance is compared with the octets the call wrote before the match, so no address wraps.
pub const window_by_branches =
    \\    lea rcx, [r15 + r13]
    \\    sub rcx, qword ptr [rdi + {[synced]}]
    \\    cmp rbx, rcx
    \\    ja 9f
;

/// The window's check where selects took the offset, with the check of an offset of 0.
pub const window_by_selects =
    \\    test rbx, rbx
    \\    jz 9f
    \\    lea rcx, [r15 + r13]
    \\    sub rcx, qword ptr [rdi + {[synced]}]
    \\    cmp rbx, rcx
    \\    ja 9f
;

/// The sequence taken: its repeats, its next states, its literals and its match.
pub const copies =
    \\    // The sequence is taken. The repeats (RFC 8878 §3.1.1.5): the third and the second from
    \\    // the repeats before, then the first, the distance.
    \\    cmp rsi, 2
    \\    mov rcx, qword ptr [rdi + {[repeat_second]}]
    \\    cmovbe rcx, qword ptr [rdi + {[repeat_third]}]
    \\    mov qword ptr [rdi + {[repeat_third]}], rcx
    \\    mov rcx, qword ptr [rdi + {[repeat_first]}]
    \\    cmovb rcx, qword ptr [rdi + {[repeat_second]}]
    \\    mov qword ptr [rdi + {[repeat_second]}], rcx
    \\    mov qword ptr [rdi + {[repeat_first]}], rbx
    \\    // The next states of literals length, match length and offset (RFC 8878 §3.1.1.3.2.1.2):
    \\    // each the next field plus its cell's baseline.
    \\    movzx ecx, byte ptr [r11 + r8*8 + {[bits_at]}]
    \\    sub edx, ecx
    \\    shrx rsi, rax, rdx
    \\    bzhi rsi, rsi, rcx
    \\    movzx ecx, word ptr [r11 + r8*8 + {[baseline_at]}]
    \\    lea r8, [rsi + rcx]
    \\    movzx ecx, byte ptr [r11 + r10*8 + {[match_length_cells]} + {[bits_at]}]
    \\    sub edx, ecx
    \\    shrx rsi, rax, rdx
    \\    bzhi rsi, rsi, rcx
    \\    movzx ecx, word ptr [r11 + r10*8 + {[match_length_cells]} + {[baseline_at]}]
    \\    lea r10, [rsi + rcx]
    \\    movzx ecx, byte ptr [r11 + r9*8 + {[offset_cells]} + {[bits_at]}]
    \\    sub edx, ecx
    \\    shrx rsi, rax, rdx
    \\    bzhi rsi, rsi, rcx
    \\    movzx ecx, word ptr [r11 + r9*8 + {[offset_cells]} + {[baseline_at]}]
    \\    lea r9, [rsi + rcx]
    \\    // The position less the bits read, which the word's bits below the fields leave.
    \\    lea r14, [r14 + rdx - {[word_bits]}]
    \\    sub qword ptr [rdi + {[literals_room]}], r13
    \\    sub qword ptr [rdi + {[promised_room]}], r12
    \\    // Its literals, two chunks, then the rest.
    \\    mov rcx, qword ptr [rdi + {[literals]}]
    \\    movdqu xmm0, xmmword ptr [rcx]
    \\    movdqu xmm1, xmmword ptr [rcx + {[chunk]}]
    \\    movdqu xmmword ptr [r15], xmm0
    \\    movdqu xmmword ptr [r15 + {[chunk]}], xmm1
    \\    lea rax, [rcx + r13]
    \\    mov qword ptr [rdi + {[literals]}], rax
    \\    cmp r13, {[pair]}
    \\    ja 4f
    \\5:
    \\    // Its match, from rsi to r15: a chunk when the distance allows one, then the rest.
    \\    add r15, r13
    \\    mov rsi, r15
    \\    sub rsi, rbx
    \\    cmp rbx, {[chunk]}
    \\    jb 6f
    \\    movdqu xmm0, xmmword ptr [rsi]
    \\    movdqu xmmword ptr [r15], xmm0
    \\    cmp r12, {[chunk]}
    \\    ja 7f
    \\8:
    \\    add r15, r12
    \\    dec qword ptr [rdi + {[left]}]
    \\    jnz 1b
    \\    jmp 9f
;

/// A repeat by branches, for `offsets_by_branches`.
pub const repeats_by_branches =
    \\2:
    \\    // Offset_Value 1 to 3 names a repeat, the next when the literals length is 0, and the
    \\    // fourth is the first less one (RFC 8878 §3.1.1.5). rsi the repeat's number from 1.
    \\    cmp r13, 1
    \\    mov rsi, rbx
    \\    adc rsi, 0
    \\    cmp rsi, 2
    \\    jae 10f
    \\    // The first.
    \\    mov rbx, qword ptr [rdi + {[repeat_first]}]
    \\    test rbx, rbx
    \\    jz 9f
    \\    jmp 3b
    \\10:
    \\    jne 11f
    \\    // The second.
    \\    mov rbx, qword ptr [rdi + {[repeat_second]}]
    \\    test rbx, rbx
    \\    jz 9f
    \\    jmp 3b
    \\11:
    \\    // The third, or the first less one.
    \\    mov rbx, qword ptr [rdi + {[repeat_first]}]
    \\    dec rbx
    \\    cmp rsi, 3
    \\    cmove rbx, qword ptr [rdi + {[repeat_third]}]
    \\    test rbx, rbx
    \\    jz 9f
    \\    jmp 3b
;

/// The rest of long literals and matches, and the state stored back.
pub const tail =
    \\4:
    \\    // The literals past the first two chunks, two at a time, rcx still the first literal.
    \\    lea rsi, [rcx + {[pair]}]
    \\    lea rdx, [r15 + {[pair]}]
    \\    lea rax, [r15 + r13]
    \\    .p2align 4
    \\12:
    \\    movdqu xmm0, xmmword ptr [rsi]
    \\    movdqu xmm1, xmmword ptr [rsi + {[chunk]}]
    \\    movdqu xmmword ptr [rdx], xmm0
    \\    movdqu xmmword ptr [rdx + {[chunk]}], xmm1
    \\    add rsi, {[pair]}
    \\    add rdx, {[pair]}
    \\    cmp rdx, rax
    \\    jb 12b
    \\    jmp 5b
    \\7:
    \\    // The match past its first chunk: two chunks at a time where the distance holds two, and
    \\    // one at a time below; each reads octets written before.
    \\    lea rax, [r15 + r12]
    \\    lea rdx, [r15 + {[chunk]}]
    \\    add rsi, {[chunk]}
    \\    cmp rbx, {[pair]}
    \\    jb 15f
    \\    .p2align 4
    \\13:
    \\    movdqu xmm0, xmmword ptr [rsi]
    \\    movdqu xmm1, xmmword ptr [rsi + {[chunk]}]
    \\    movdqu xmmword ptr [rdx], xmm0
    \\    movdqu xmmword ptr [rdx + {[chunk]}], xmm1
    \\    add rsi, {[pair]}
    \\    add rdx, {[pair]}
    \\    cmp rdx, rax
    \\    jb 13b
    \\    jmp 8b
    \\    .p2align 4
    \\15:
    \\    movdqu xmm0, xmmword ptr [rsi]
    \\    movdqu xmmword ptr [rdx], xmm0
    \\    add rsi, {[chunk]}
    \\    add rdx, {[chunk]}
    \\    cmp rdx, rax
    \\    jb 15b
    \\    jmp 8b
    \\6:
    \\    // Below a chunk: the first chunk is the distance's octets repeated, which one shuffle
    \\    // gives from them, each octet's index its place modulo the distance; past it the octets
    \\    // repeat every multiple of the distance, so the rest go a chunk at a time from the least
    \\    // multiple at least a chunk back, in rcx. The load reads the chunk from the source,
    \\    // inside the output, whose octets past the distance the indices do not take.
    \\    mov rcx, rbx
    \\    shl rcx, {[chunk_shift]}
    \\    add rcx, qword ptr [rdi + {[patterns]}]
    \\    movdqu xmm1, xmmword ptr [rcx]
    \\    movdqu xmm0, xmmword ptr [rsi]
    \\    pshufb xmm0, xmm1
    \\    movdqu xmmword ptr [r15], xmm0
    \\    cmp r12, {[chunk]}
    \\    jbe 8b
    \\    mov rcx, rbx
    \\17:
    \\    cmp rcx, {[chunk]}
    \\    jae 18f
    \\    add rcx, rbx
    \\    jmp 17b
    \\18:
    \\    mov rdx, r15
    \\    sub rdx, rcx
    \\    mov eax, {[chunk]}
    \\19:
    \\    movdqu xmm0, xmmword ptr [rdx + rax]
    \\    movdqu xmmword ptr [r15 + rax], xmm0
    \\    add rax, {[chunk]}
    \\    cmp rax, r12
    \\    jb 19b
    \\    jmp 8b
    \\9:
    \\    mov qword ptr [rdi + {[output]}], r15
    \\    add r14, {[read_min]}
    \\    mov qword ptr [rdi + {[position]}], r14
    \\    mov qword ptr [rdi + {[literals_length_state]}], r8
    \\    mov qword ptr [rdi + {[offset_state]}], r9
    \\    mov qword ptr [rdi + {[match_length_state]}], r10
    \\    mov rax, qword ptr [rdi + {[count]}]
    \\    sub rax, qword ptr [rdi + {[left]}]
    \\    .att_syntax prefix
;
