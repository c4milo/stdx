//! The text of the loop of `encoder_parse_x86_64.zig`, in the pieces its `template` joins, in Intel
//! syntax: the port of `encoder_parse_aarch64_template.zig`, whose comment describes the loop and
//! whose labels this text keeps.
//!
//! Registers: rdi the loop's state; rsi the window, r9 the short table, r10 the long table, r11d
//! the tables' base; rdx the position, r8 the anchor; r12 the range's limit before the reach. At
//! label 40, r14 is the match's position and rcx its candidate; from 46, rax its length, rbx its
//! distance and r15 its insert's length. rax, rbx, rcx, rbp, r12 to r15 hold each step's values;
//! the caller's rbp waits in the state. The ends, the reach, the multiplier, the last distances,
//! the commands, their counts and the tables the symbol reads stay in the state, which the loop
//! reads in place.
//!
//! BSR takes a distance's bit length less one and BSF the first octet of a word that differs;
//! both see a value that is not zero. A shift by a count in a register takes it in cl. The text
//! writes the numbers the layouts fix, which `encoder_parse_x86_64.zig` asserts.

/// The prologue: the caller's rbp kept, and the state.
pub const prologue =
    \\    .intel_syntax noprefix
    \\    mov qword ptr [rdi + {[saved_frame]}], rbp
    \\    mov rsi, qword ptr [rdi + {[window]}]
    \\    mov r9, qword ptr [rdi + {[short]}]
    \\    mov r10, qword ptr [rdi + {[long]}]
    \\    mov r11, qword ptr [rdi + {[base]}]
    \\    mov rdx, qword ptr [rdi + {[position]}]
    \\    mov r8, qword ptr [rdi + {[anchor]}]
    \\    .p2align 6
;

/// A position before the reach: its limit is the position less one, and 0 at position 0.
pub const position =
    \\1:
    \\    cmp rdx, qword ptr [rdi + {[search_end]}]
    \\    jae 90f
    \\    cmp rdx, qword ptr [rdi + {[reach]}]
    \\    ja 100f
    \\    lea r12, [rdx - 1]
    \\    test rdx, rdx
    \\    cmovz r12, rdx
;

/// A position past the reach: the limit is the reach, read in place.
pub const position_far =
    \\100:
    \\1:
    \\    cmp rdx, qword ptr [rdi + {[search_end]}]
    \\    jae 90f
;

/// The position's 8 octets, its entry, and both tables read and written.
pub const probe =
    \\    mov rax, qword ptr [rsi + rdx]
    \\    lea ebx, [r11 + rdx]
    \\    mov rcx, rax
    \\    shl rcx, {[short_shift]}
    \\    imul rcx, qword ptr [rdi + {[multiplier]}]
    \\    shr rcx, {[hash_shift]}
    \\    mov r14, rax
    \\    imul r14, qword ptr [rdi + {[multiplier]}]
    \\    shr r14, {[hash_shift]}
    \\    mov r15d, dword ptr [r9 + rcx*4]
    \\    mov ebp, dword ptr [r10 + r14*4]
    \\    mov dword ptr [r9 + rcx*4], ebx
    \\    mov dword ptr [r10 + r14*4], ebx
    \\    cmp rdx, r8
    \\    je 3f
    \\    mov ecx, dword ptr [rdi + {[ring]}]
;

/// The last distance's range test, before the reach alone.
pub const repeat_range =
    \\    lea r14d, [rcx - 1]
    \\    cmp r14, r12
    \\    jae 3f
;

/// The last distance's 4 octets, then the long table's candidate, then the short table's. `{limit}`
/// is r12 before the reach and the reach in place past it.
pub fn tables(comptime limit: []const u8, comptime next_limit: []const u8) []const u8 {
    return
    \\    mov r14, rdx
    \\    sub r14, rcx
    \\    cmp eax, dword ptr [rsi + r14]
    \\    jne 3f
    \\    mov rcx, r14
    \\    mov r14, rdx
    \\    jmp 40f
    \\3:
    \\    mov ecx, ebx
    \\    sub ecx, ebp
    \\    lea r14d, [rcx - 1]
    \\    cmp r14,
    ++ limit ++
        \\
        \\    jae 4f
        \\    mov r14, rdx
        \\    sub r14, rcx
        \\    cmp rax, qword ptr [rsi + r14]
        \\    jne 4f
        \\    mov rcx, r14
        \\    mov r14, rdx
        \\    jmp 40f
        \\4:
        \\    mov ecx, ebx
        \\    sub ecx, r15d
        \\    lea r14d, [rcx - 1]
        \\    cmp r14,
    ++ limit ++
        \\
        \\    jae 8f
        \\    mov r14, rdx
        \\    sub r14, rcx
        \\    cmp eax, dword ptr [rsi + r14]
        \\    jne 8f
        \\    mov r15, r14
        \\    lea rcx, [rdx + {[read_after]}]
        \\    cmp rcx, qword ptr [rdi + {[end]}]
        \\    ja 6f
        \\    mov rax, qword ptr [rsi + rdx + 1]
        \\    mov rcx, rax
        \\    imul rcx, qword ptr [rdi + {[multiplier]}]
        \\    shr rcx, {[hash_shift]}
        \\    mov ebp, dword ptr [r10 + rcx*4]
        \\    inc ebx
        \\    mov dword ptr [r10 + rcx*4], ebx
        \\    mov ecx, ebx
        \\    sub ecx, ebp
        \\    lea r14d, [rcx - 1]
        \\
    ++ next_limit ++
        \\
        \\    jae 6f
        \\    lea r14, [rdx + 1]
        \\    sub r14, rcx
        \\    cmp rax, qword ptr [rsi + r14]
        \\    jne 6f
        \\    mov rcx, r14
        \\    lea r14, [rdx + 1]
        \\    jmp 40f
        \\6:
        \\    mov rcx, r15
        \\    mov r14, rdx
        \\    jmp 40f
        \\8:
        \\    mov rax, rdx
        \\    sub rax, r8
        \\    shr rax, {[skip_log]}
        \\    lea rdx, [rdx + rax + 1]
        \\    jmp 1b
    ;
}

/// The next position's limit before the reach: the reach once it passes it, else the position.
pub const next_limit_near =
    \\    lea r12, [rdx + 1]
    \\    cmp r12, qword ptr [rdi + {[reach]}]
    \\    mov r12, rdx
    \\    cmova r12, qword ptr [rdi + {[reach]}]
    \\    cmp r14, r12
;

/// The next position's limit past the reach.
pub const next_limit_far =
    \\    cmp r14, qword ptr [rdi + {[reach]}]
;

/// The match stepped back, its length, 8 octets a compare, its cost against its literals', and
/// the lengths the tables take.
pub const extend =
    \\40:
    \\    cmp r14, r8
    \\    jbe 42f
    \\    test rcx, rcx
    \\    jz 42f
    \\    movzx eax, byte ptr [rsi + r14 - 1]
    \\    cmp al, byte ptr [rsi + rcx - 1]
    \\    jne 42f
    \\    dec r14
    \\    dec rcx
    \\    jmp 40b
    \\42:
    \\    mov rbx, qword ptr [rdi + {[end]}]
    \\    sub rbx, r14
    \\    xor eax, eax
    \\    lea r15, [rsi + rcx]
    \\    lea rbp, [rsi + r14]
    \\43:
    \\    mov r12, rbx
    \\    sub r12, rax
    \\    cmp r12, 8
    \\    jb 45f
    \\    mov r12, qword ptr [r15 + rax]
    \\    xor r12, qword ptr [rbp + rax]
    \\    jnz 44f
    \\    add rax, 8
    \\    jmp 43b
    \\44:
    \\    bsf r12, r12
    \\    shr r12, 3
    \\    add rax, r12
    \\    jmp 46f
    \\45:
    \\    cmp rax, rbx
    \\    jae 46f
    \\    movzx r12d, byte ptr [r15 + rax]
    \\    cmp r12b, byte ptr [rbp + rax]
    \\    jne 46f
    \\    inc rax
    \\    jmp 45b
    \\46:
    \\    mov rbx, r14
    \\    sub rbx, rcx
    \\    bsr r12, rbx
    \\    lea r12, [r12*{[eighths]} + {[match_cost_base]}]
    \\    mov r15, rax
    \\    imul r15, qword ptr [rdi + {[literal_cost]}]
    \\    cmp r15, r12
    \\    jbe 8b
    \\    mov r15, r14
    \\    sub r15, r8
    \\    cmp r15, {[length_table_len]}
    \\    jae 80f
    \\    cmp rax, {[length_table_len]}
    \\    jae 80f
;

/// The command: its literals counted, its distance's code in r13 and extra in rbp, the ring moved,
/// and its symbol in rcx.
pub const command =
    \\    lea rcx, [rsi + r8]
    \\    lea rbp, [rsi + r14]
    \\    mov r12, qword ptr [rdi + {[literal_counts]}]
    \\    cmp rcx, rbp
    \\    jae 48f
    \\47:
    \\    movzx r13d, byte ptr [rcx]
    \\    inc word ptr [r12 + r13*2]
    \\    inc rcx
    \\    cmp rcx, rbp
    \\    jb 47b
    \\48:
    \\    add qword ptr [rdi + {[inserted]}], r15
    \\    xor ebp, ebp
    \\    xor r13d, r13d
    \\    cmp ebx, dword ptr [rdi + {[ring]}]
    \\    je 56f
    \\    mov r13d, 1
    \\    cmp ebx, dword ptr [rdi + {[ring_1]}]
    \\    je 52f
    \\    mov r13d, 2
    \\    cmp ebx, dword ptr [rdi + {[ring_2]}]
    \\    je 52f
    \\    mov r13d, 3
    \\    cmp ebx, dword ptr [rdi + {[ring_3]}]
    \\    je 52f
    \\50:
    \\    lea r12d, [rbx + {[distance_offset]}]
    \\    bsr ecx, r12d
    \\    dec ecx
    \\    mov ebp, r12d
    \\    shr ebp, cl
    \\    and ebp, 1
    \\    lea r13d, [rbp + {[distance_prefix_base]}]
    \\    shl r13d, cl
    \\    sub r12d, r13d
    \\    lea r13d, [rcx*2 + rbp + {[code_from_bits]}]
    \\    mov ebp, r12d
    \\52:
    \\    mov ecx, dword ptr [rdi + {[ring_2]}]
    \\    mov dword ptr [rdi + {[ring_3]}], ecx
    \\    mov ecx, dword ptr [rdi + {[ring_1]}]
    \\    mov dword ptr [rdi + {[ring_2]}], ecx
    \\    mov ecx, dword ptr [rdi + {[ring]}]
    \\    mov dword ptr [rdi + {[ring_1]}], ecx
    \\    mov dword ptr [rdi + {[ring]}], ebx
    \\56:
    \\    xor ecx, ecx
    \\    test r13d, r13d
    \\    sete cl
    \\    cmp r15, {[small_insert_len]}
    \\    jae 57f
    \\    cmp rax, {[small_copy_len]}
    \\    jae 57f
    \\    shl ecx, {[small_last_shift]}
    \\    mov r12, r15
    \\    shl r12, {[small_insert_shift]}
    \\    add rcx, r12
    \\    add rcx, rax
    \\    mov r12, qword ptr [rdi + {[small_symbols]}]
    \\    movzx ecx, word ptr [r12 + rcx*2]
    \\    jmp 60f
    \\57:
    \\    mov r12, qword ptr [rdi + {[insert_codes]}]
    \\    movzx r12d, byte ptr [r12 + r15]
    \\    imul rcx, rcx, {[codes_count]}
    \\    add rcx, r12
    \\    imul rcx, rcx, {[codes_count]}
    \\    mov r12, qword ptr [rdi + {[copy_codes]}]
    \\    movzx r12d, byte ptr [r12 + rax]
    \\    add rcx, r12
    \\    mov r12, qword ptr [rdi + {[insert_copy_symbols]}]
    \\    movzx ecx, word ptr [r12 + rcx*2]
;

/// The record, its counts, the positions the match covers in both tables, and the next position.
pub const record =
    \\60:
    \\    mov r12, r13
    \\    shl r12, {[symbol_bits]}
    \\    or r12, rcx
    \\    shl r12, 32
    \\    mov rbx, rax
    \\    shl rbx, 16
    \\    or rbx, r15
    \\    or r12, rbx
    \\    shl rbp, 48
    \\    or r12, rbp
    \\    mov rbx, qword ptr [rdi + {[commands]}]
    \\    mov rbp, qword ptr [rdi + {[count]}]
    \\    mov qword ptr [rbx + rbp*8], r12
    \\    inc qword ptr [rdi + {[count]}]
    \\    mov rbx, qword ptr [rdi + {[command_counts]}]
    \\    inc word ptr [rbx + rcx*2]
    \\    cmp ecx, {[last_distance_symbols]}
    \\    jb 62f
    \\    mov rbx, qword ptr [rdi + {[distance_counts]}]
    \\    inc word ptr [rbx + r13*2]
    \\62:
    \\    lea r8, [r14 + rax]
    \\    mov rdx, r8
    \\    lea rcx, [r14 + {[insert_skip]}]
    \\    mov rbx, qword ptr [rdi + {[search_end]}]
    \\    cmp r8, rbx
    \\    cmovb rbx, r8
    \\    lea r12, [rcx + {[insert_tail]}]
    \\    cmp rbx, r12
    \\    jb 1b
    \\    sub rbx, {[insert_tail]}
    \\66:
    \\    mov rax, qword ptr [rsi + rcx]
    \\    lea ebp, [r11 + rcx]
    \\    mov r12, rax
    \\    shl r12, {[short_shift]}
    \\    imul r12, qword ptr [rdi + {[multiplier]}]
    \\    shr r12, {[hash_shift]}
    \\    mov dword ptr [r9 + r12*4], ebp
    \\    imul rax, qword ptr [rdi + {[multiplier]}]
    \\    shr rax, {[hash_shift]}
    \\    mov dword ptr [r10 + rax*4], ebp
    \\    add rcx, {[insert_step]}
    \\    cmp rcx, rbx
    \\    jbe 66b
    \\    mov rax, qword ptr [rsi + rbx]
    \\    lea ebp, [r11 + rbx]
    \\    mov r12, rax
    \\    shl r12, {[short_shift]}
    \\    imul r12, qword ptr [rdi + {[multiplier]}]
    \\    shr r12, {[hash_shift]}
    \\    mov dword ptr [r9 + r12*4], ebp
    \\    imul rax, qword ptr [rdi + {[multiplier]}]
    \\    shr rax, {[hash_shift]}
    \\    mov dword ptr [r10 + rax*4], ebp
    \\    jmp 1b
;

/// A command the text leaves to Zig, then the state stored back and the caller's rbp.
pub const exit =
    \\80:
    \\    mov qword ptr [rdi + {[found_position]}], r14
    \\    mov qword ptr [rdi + {[found_len]}], rax
    \\    mov qword ptr [rdi + {[found_offset]}], rbx
    \\    mov qword ptr [rdi + {[pending]}], 1
    \\90:
    \\    mov qword ptr [rdi + {[position]}], rdx
    \\    mov qword ptr [rdi + {[anchor]}], r8
    \\    mov rbp, qword ptr [rdi + {[saved_frame]}]
    \\    .att_syntax prefix
;
