//! The text of the loop of `decoder_fast_x86_64.zig`, continued from
//! decoder_fast_x86_64_template.zig: a command's distance, its copy, a dictionary word, the blocks
//! the common path passes over and the exits. The registers and the labels are as that file names
//! them.

const std = @import("std");
const text = @import("decoder_fast_x86_64_template.zig");
const refill = text.refill;
const lookup = text.lookup;
const second_level = text.second_level;

/// The command's distance (RFC 7932 §4): the last distance for a symbol below 128, or the code of
/// the tree its block type and copy length pick, its extra bits and the distance they give; then
/// the checks, the bits taken and the ring's push.
pub const distance =
    \\30:
    \\    // A refill (32) when the buffer holds fewer than a distance's bits.
    \\    cmp r9d, {[distance_bits_max]}
    \\    jb 32f
    \\31:
    \\    test r13, r13
    \\    js 40f
    \\    // RFC 7932 §9.3: a spent block takes a block switch first, in Zig.
    \\    cmp qword ptr [rdi + {[dist_count]}], 0
    \\    je 90f
    \\    // The distance context (RFC 7932 §7.3): the copy length, 2 to 5 and above, less 2.
    \\    mov eax, {[distance_context_last_copy_len]}
    \\    cmp r14d, eax
    \\    cmovb eax, r14d
    \\    sub eax, {[distance_context_copy_len_min]}
    \\    mov rcx, qword ptr [rdi + {[dist_map_row]}]
    \\    movzx eax, byte ptr [rcx + rax]
    \\    imul eax, eax, {[distance_table_size]}
    \\    add rax, qword ptr [rdi + {[dist_tables]}]
++ "\n" ++ lookup("rax", "rcx", "52", "56") ++
    \\    movzx ebx, cl
    \\    shr ecx, {[entry_value_at]}
    \\    // The extra bits (RFC 7932 §4): none below 16 + NDIRECT, 1 + ((dcode - NDIRECT - 16) >>
    \\    // (NPOSTFIX + 1)) after them.
    \\    xor eax, eax
    \\    cmp ecx, dword ptr [rdi + {[direct_end]}]
    \\    jb 33f
    \\    mov eax, ecx
    \\    sub eax, dword ptr [rdi + {[direct_end]}]
    \\    mov r11d, dword ptr [rdi + {[postfix_shift]}]
    \\    shrx eax, eax, r11d
    \\    inc eax
    \\33:
    \\    shrx r15, r8, rbx
    \\    bzhi r15, r15, rax
    \\    add ebx, eax
    \\    cmp ecx, {[distance_short_codes_count]}
    \\    jae 34f
    \\    // A short code (RFC 7932 §4): a last distance and a delta; one that resolves to zero or
    \\    // less should be rejected as invalid, which the checked path does.
    \\    mov r11, qword ptr [rdi + {[short_codes]}]
    \\    mov r11, qword ptr [r11 + rcx*8]
    \\    mov eax, r11d
    \\    and eax, 3
    \\    mov r15d, dword ptr [rdi + {[ring01]} + rax*4]
    \\    mov eax, r11d
    \\    shl eax, 16
    \\    sar eax, 24
    \\    add r15d, eax
    \\    cmp r15d, 1
    \\    jl 90f
    \\    jmp 36f
    \\34:
    \\    cmp ecx, dword ptr [rdi + {[direct_end]}]
    \\    jae 35f
    \\    // A direct code (RFC 7932 §4): the distances 1 to NDIRECT.
    \\    lea r15d, [rcx - {[direct_code_offset]}]
    \\    jmp 36f
    \\35:
    \\    // A coded distance (RFC 7932 §4): offset ((2 + (hcode & 1)) << ndistbits) - 4, then
    \\    // ((offset + dextra) << NPOSTFIX) + lcode + NDIRECT + 1.
    \\    mov r12d, dword ptr [rdi + {[postfix_bits]}]
    \\    mov r11d, ecx
    \\    sub r11d, dword ptr [rdi + {[direct_end]}]
    \\    shrx ecx, r11d, r12d
    \\    and ecx, 1
    \\    add ecx, {[coded_distance_base]}
    \\    shlx ecx, ecx, eax
    \\    sub ecx, {[coded_distance_bias]}
    \\    add ecx, r15d
    \\    shlx ecx, ecx, r12d
    \\    bzhi r11d, r11d, r12d
    \\    add ecx, r11d
    \\    add ecx, dword ptr [rdi + {[direct_count]}]
    \\    lea r15d, [rcx + 1]
    \\    mov ecx, 1
    \\36:
    \\    // A distance past this call's output or past the window (35): a dictionary word or the
    \\    // window.
    \\    mov rax, rdx
    \\    sub rax, qword ptr [rdi + {[output_base]}]
    \\    cmp r15, rax
    \\    ja 35f
    \\    cmp r15, qword ptr [rdi + {[window_distance_max]}]
    \\    ja 35f
    \\    cmp r14d, {[chunk_len_max]}
    \\    ja 90f
    \\    // RFC 7932 §9.3: a copy length that would exceed MLEN; the checked path refuses it.
    \\    cmp r14d, r10d
    \\    ja 91f
    \\    shrx r8, r8, rbx
    \\    sub r9b, bl
    \\    dec qword ptr [rdi + {[dist_count]}]
    \\    {[count_distance]s}
    \\    // RFC 7932 §4: the distance code 0 stays out of the ring of last distances.
    \\    test ecx, ecx
    \\    jz 41f
    \\    movdqu xmm0, xmmword ptr [rdi + {[ring01]}]
    \\    pslldq xmm0, 4
    \\    movd xmm1, r15d
    \\    por xmm0, xmm1
    \\    movdqu xmmword ptr [rdi + {[ring01]}], xmm0
    \\    jmp 41f
    \\40:
    \\    // The last distance reused (RFC 7932 §5): no bits, no element, no push.
    \\    mov r15d, dword ptr [rdi + {[ring01]}]
    \\    // A distance past this call's output (35); the ring's distances are within the window.
    \\    mov rax, rdx
    \\    sub rax, qword ptr [rdi + {[output_base]}]
    \\    cmp r15, rax
    \\    ja 35f
    \\    cmp r14d, {[chunk_len_max]}
    \\    ja 90f
    \\    cmp r14d, r10d
    \\    ja 91f
;

/// The copy (S4, RFC 7932 §10): chunks of 16 where the distance holds one, of 8 where it holds one,
/// a fill for a distance of 1, and an octet at a time below 8; each reads octets written before it,
/// and the margin's room holds the last chunk's overrun. Then p1, p2, the meta-block's octets, and
/// the next command.
pub const copy =
    \\41:
    \\    mov rax, rdx
    \\    sub rax, r15
    \\    cmp r15, {[chunk]}
    \\    jb 60f
    \\    movdqu xmm0, xmmword ptr [rax]
    \\    movdqu xmmword ptr [rdx], xmm0
    \\    movdqu xmm1, xmmword ptr [rax + {[chunk]}]
    \\    movdqu xmmword ptr [rdx + {[chunk]}], xmm1
    \\    cmp r14d, {[pair]}
    \\    jbe 45f
    \\    mov ecx, {[pair]}
    \\42:
    \\    movdqu xmm0, xmmword ptr [rax + rcx]
    \\    movdqu xmmword ptr [rdx + rcx], xmm0
    \\    add ecx, {[chunk]}
    \\    cmp ecx, r14d
    \\    jb 42b
    \\    jmp 45f
    \\60:
    \\    cmp r15, {[word]}
    \\    jb 61f
    \\    mov rcx, qword ptr [rax]
    \\    mov qword ptr [rdx], rcx
    \\    mov rcx, qword ptr [rax + {[word]}]
    \\    mov qword ptr [rdx + {[word]}], rcx
    \\    cmp r14d, {[chunk]}
    \\    jbe 45f
    \\    mov ecx, {[chunk]}
    \\43:
    \\    mov r11, qword ptr [rax + rcx]
    \\    mov qword ptr [rdx + rcx], r11
    \\    add ecx, {[word]}
    \\    cmp ecx, r14d
    \\    jb 43b
    \\    jmp 45f
    \\61:
    \\    cmp r15, 1
    \\    jne 62f
    \\    movzx ecx, byte ptr [rax]
    \\    movd xmm0, ecx
    \\    pxor xmm1, xmm1
    \\    pshufb xmm0, xmm1
    \\    xor ecx, ecx
    \\44:
    \\    movdqu xmmword ptr [rdx + rcx], xmm0
    \\    add ecx, {[chunk]}
    \\    cmp ecx, r14d
    \\    jb 44b
    \\    jmp 45f
    \\62:
    \\    xor ecx, ecx
    \\63:
    \\    movzx r11d, byte ptr [rax + rcx]
    \\    mov byte ptr [rdx + rcx], r11b
    \\    inc ecx
    \\    cmp ecx, r14d
    \\    jb 63b
    \\45:
    \\    add rdx, r14
    \\    movzx eax, byte ptr [rdx - 1]
    \\    mov qword ptr [rdi + {[p1]}], rax
    \\    movzx eax, byte ptr [rdx - 2]
    \\    mov qword ptr [rdi + {[p2]}], rax
    \\    sub r10d, r14d
    \\    jz 88f
    \\    jmp 1b
;

/// A dictionary word (RFC 7932 §8): `write_word`, in Zig, transforms it into the output, with the
/// loop's changing registers stored before the call and loaded back after it, on a stack aligned to
/// 16 below the red zone; a reference it refuses, or a word past MLEN, goes to the checked path
/// with the bits unused. Then the word's octets, and the distance's bits and element unless the last
/// distance was reused.
pub const word =
    \\37:
    \\    sub r15, rax
    \\    dec r15
    \\    mov qword ptr [rdi + {[input]}], rsi
    \\    mov qword ptr [rdi + {[output]}], rdx
    \\    mov qword ptr [rdi + {[buffer]}], r8
    \\    mov qword ptr [rdi + {[count]}], r9
    \\    mov qword ptr [rdi + {[meta_block_left]}], r10
    \\    mov r12, rdi
    \\    mov rdi, rdx
    \\    mov rsi, r14
    \\    mov rdx, r15
    \\    mov ecx, r10d
    \\    mov r15, rsp
    \\    sub rsp, 128
    \\    and rsp, -16
    \\    call qword ptr [r12 + {[write_word]}]
    \\    mov rsp, r15
    \\    mov rdi, r12
    \\    mov rsi, qword ptr [rdi + {[input]}]
    \\    mov rdx, qword ptr [rdi + {[output]}]
    \\    mov r8, qword ptr [rdi + {[buffer]}]
    \\    mov r9, qword ptr [rdi + {[count]}]
    \\    mov r10, qword ptr [rdi + {[meta_block_left]}]
    \\    cmp rax, -1
    \\    je 91f
    \\    add rdx, rax
    \\    sub r10d, eax
    \\    // p1 and p2 as `wrote` keeps them: both from the output past two octets, p1 alone past one.
    \\    test rax, rax
    \\    jz 46f
    \\    cmp rax, 1
    \\    je 47f
    \\    movzx ecx, byte ptr [rdx - 1]
    \\    mov qword ptr [rdi + {[p1]}], rcx
    \\    movzx ecx, byte ptr [rdx - 2]
    \\    mov qword ptr [rdi + {[p2]}], rcx
    \\    jmp 46f
    \\47:
    \\    mov rcx, qword ptr [rdi + {[p1]}]
    \\    mov qword ptr [rdi + {[p2]}], rcx
    \\    movzx ecx, byte ptr [rdx - 1]
    \\    mov qword ptr [rdi + {[p1]}], rcx
    \\46:
    \\    test r13, r13
    \\    js 48f
    \\    shrx r8, r8, rbx
    \\    sub r9b, bl
    \\    dec qword ptr [rdi + {[dist_count]}]
    \\    {[count_distance]s}
    \\48:
    \\    test r10d, r10d
    \\    jz 88f
    \\    jmp 1b
;

/// The blocks the common path passes over, each entered by a branch it leaves untaken and ending in
/// a branch back: the refills that need the input's slack checked, for a command's extra bits (12),
/// a run's literal (28, 29 and 73) and a distance (32), the second level of each lookup (50 to 53
/// and 58), and a distance past this call's output or the window (35).
pub const cold =
    \\12:
    \\    cmp rsi, qword ptr [rdi + {[input_limit]}]
    \\    ja 82f
++ "\n" ++ refill("rax") ++
    \\    jmp 11b
    \\28:
    \\    cmp rsi, qword ptr [rdi + {[input_limit]}]
    \\    ja 86f
++ "\n" ++ refill("rax") ++
    \\    jmp 22b
    \\29:
    \\    cmp rsi, qword ptr [rdi + {[input_limit]}]
    \\    ja 86f
++ "\n" ++ refill("r10") ++
    \\    jmp 27b
    \\73:
    \\    cmp rsi, qword ptr [rdi + {[input_limit]}]
    \\    ja 86f
++ "\n" ++ refill("rax") ++
    \\    jmp 72b
    \\32:
    \\    cmp rsi, qword ptr [rdi + {[input_limit]}]
    \\    ja 89f
++ "\n" ++ refill("rax") ++
    \\    jmp 31b
++ "\n" ++ second_level("rax", "rcx", "rbx", "50", "54") ++
    second_level("rax", "rcx", "r10", "51", "55") ++
    second_level("rax", "rcx", "rbx", "52", "56") ++
    second_level("rax", "rcx", "r10", "53", "57") ++
    second_level("rax", "rcx", "r14", "58", "59") ++
    \\35:
    \\    // A distance past the octets the reference can reach names a dictionary word (RFC 7932
    \\    // §4), which a call into Zig takes; one within them reads the window, in Zig.
    \\    mov rax, qword ptr [rdi + {[produced_offset]}]
    \\    add rax, rdx
    \\    mov r11, qword ptr [rdi + {[window_distance_max]}]
    \\    cmp rax, r11
    \\    cmovae rax, r11
    \\    cmp r15, rax
    \\    ja 37b
    \\    jmp 90f
;

/// The exits: the link in rax and the phase in rcx, the command's values where a command is in
/// progress, then the machine stored back and the link returned.
pub const exits =
    \\80:
    \\    xor r13d, r13d
    \\    xor r14d, r14d
    \\    xor r15d, r15d
    \\    mov eax, {[link_go_on]}
    \\    mov ecx, {[phase_command]}
    \\    jmp 99f
    \\81:
    \\    xor r13d, r13d
    \\    xor r14d, r14d
    \\    xor r15d, r15d
    \\    mov eax, {[link_command]}
    \\    mov ecx, {[phase_command]}
    \\    jmp 99f
    \\82:
    \\    xor r14d, r14d
    \\    xor r15d, r15d
    \\    mov eax, {[link_go_on]}
    \\    mov ecx, {[phase_command_extra]}
    \\    jmp 99f
    \\83:
    \\    xor r14d, r14d
    \\    xor r15d, r15d
    \\    mov eax, {[link_stop]}
    \\    mov ecx, {[phase_command_extra]}
    \\    jmp 99f
    \\84:
    \\    mov eax, {[link_stop]}
    \\    mov ecx, {[phase_literal]}
    \\    jmp 99f
    \\85:
    \\    mov eax, {[link_literal]}
    \\    mov ecx, {[phase_literal]}
    \\    jmp 99f
    \\86:
    \\    // The run's octets so far, as at 23.
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
    \\87:
    \\    mov eax, {[link_go_on]}
    \\    mov ecx, {[phase_literal]}
    \\    jmp 99f
    \\88:
    \\    // No literals left, where r15 held the distance or, past a word, the stack.
    \\    xor r15d, r15d
    \\    mov eax, {[link_stop]}
    \\    mov ecx, {[phase_meta_block_end]}
    \\    jmp 99f
    \\89:
    \\    mov eax, {[link_go_on]}
    \\    mov ecx, {[phase_distance]}
    \\    jmp 99f
    \\90:
    \\    // The command's literals are all written: none left.
    \\    xor r15d, r15d
    \\    mov eax, {[link_distance]}
    \\    mov ecx, {[phase_distance]}
    \\    jmp 99f
    \\91:
    \\    xor r15d, r15d
    \\    mov eax, {[link_stop]}
    \\    mov ecx, {[phase_distance]}
    \\99:
    \\    mov qword ptr [rdi + {[input]}], rsi
    \\    mov qword ptr [rdi + {[output]}], rdx
    \\    mov qword ptr [rdi + {[buffer]}], r8
    \\    mov qword ptr [rdi + {[count]}], r9
    \\    mov qword ptr [rdi + {[meta_block_left]}], r10
    \\    mov qword ptr [rdi + {[phase]}], rcx
    \\    rorx rcx, r13, {[insert_code_at]}
    \\    movzx ecx, cl
    \\    mov qword ptr [rdi + {[insert_code]}], rcx
    \\    rorx rcx, r13, {[copy_code_at]}
    \\    and ecx, {[copy_code_mask]}
    \\    mov qword ptr [rdi + {[copy_code]}], rcx
    \\    mov rcx, r13
    \\    shr rcx, 63
    \\    mov qword ptr [rdi + {[last_distance]}], rcx
    \\    mov qword ptr [rdi + {[copy_len]}], r14
    \\    mov qword ptr [rdi + {[insert_left]}], r15
    \\    .att_syntax prefix
;
