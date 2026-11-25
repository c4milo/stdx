//! The text of the writer of `encoder_write_x86_64.zig`, in the pieces its `template` joins, in
//! Intel syntax: the port of `encoder_write_aarch64_template.zig`, whose comment describes the
//! writer and whose labels this text keeps.
//!
//! Registers: rdi the writer's state; rax the bit buffer and r11 its count, below 8 between puts;
//! rdx the output's next octet; r8 the next command and rbx the command. A shift by a count in a
//! register takes it in cl, so rcx holds each shift's count; r9, r10, r14, r15, rsi, rbp, r12 and
//! r13 hold each step's values. In the literals, rsi points at the next one, r12 and r13 hold the
//! literal code's codes and lengths, r14 counts the command's literals left and r15 the chunk's.
//! The commands' end, the octets written so far, the meta-block's length, the output's end and
//! the codes stay in the state, which the text reads in place; the caller's rbp waits there too.
//!
//! The text writes the numbers the layouts fix, which `encoder_write_assembly.zig` asserts.

/// One put (`Bits.put` in `encoder_write.zig`): the `count` bits of `value` above the buffer's
/// count, the buffer stored whole, its whole octets counted written, and the bits below an octet
/// kept. It takes `value` and rcx as its temporaries.
pub fn put(comptime value: []const u8, comptime count: []const u8) []const u8 {
    return "    mov ecx, r11d\n" ++
        "    shl " ++ value ++ ", cl\n" ++
        "    or rax, " ++ value ++ "\n" ++
        "    add r11, " ++ count ++ "\n" ++
        "    mov qword ptr [rdx], rax\n" ++
        "    mov ecx, r11d\n" ++
        "    shr ecx, 3\n" ++
        "    add rdx, rcx\n" ++
        "    shl ecx, 3\n" ++
        "    shr rax, cl\n" ++
        "    and r11d, 7\n";
}

/// The room test (`Bits.check`) of the bits in r9: the output must hold the buffer's octets,
/// those of the bits, and a whole store. rbp is its temporary.
pub const check =
    \\    add r9, r11
    \\    shr r9, 3
    \\    add r9, {[store_len]}
    \\    mov rbp, qword ptr [rdi + {[room_end]}]
    \\    sub rbp, rdx
    \\    cmp rbp, r9
    \\    jb 80f
;

/// The prologue: the caller's rbp kept, and the state.
pub const prologue =
    \\    .intel_syntax noprefix
    \\    mov qword ptr [rdi + {[saved_frame]}], rbp
    \\    mov r8, qword ptr [rdi + {[commands]}]
    \\    mov rax, qword ptr [rdi + {[buffer]}]
    \\    mov r11, qword ptr [rdi + {[count]}]
    \\    mov rdx, qword ptr [rdi + {[room]}]
    \\    .p2align 6
;

/// A command and the room for its symbol and lengths.
pub const command_head =
    \\1:
    \\    cmp r8, qword ptr [rdi + {[commands_end]}]
    \\    jae 90f
    \\    mov rbx, qword ptr [r8]
    \\    add r8, 8
    \\    mov r9d, {[command_bits_max]}
;

/// The symbol's code, and the insert's and the copy's extra bits, in one put where they fit 56
/// bits: rsi the head, ecx its length, r12 the copy's extra bits and r13 their count.
pub const command_lengths =
    \\    mov r9, rbx
    \\    shr r9, 32
    \\    and r9d, {[symbol_mask]}
    \\    lea r15, [r9 + r9*2]
    \\    add r15, r15
    \\    add r15, qword ptr [rdi + {[symbol_lengths]}]
    \\    mov r10, qword ptr [rdi + {[command_lengths]}]
    \\    movzx ecx, byte ptr [r10 + r9]
    \\    mov r10, qword ptr [rdi + {[command_codes]}]
    \\    movzx esi, word ptr [r10 + r9*2]
    \\    movzx r14d, bx
    \\    movzx r10d, word ptr [r15]
    \\    sub r14, r10
    \\    mov r12, rbx
    \\    shr r12, 16
    \\    movzx r12d, r12w
    \\    movzx r10d, word ptr [r15 + 2]
    \\    sub r12, r10
    \\    movzx r10d, byte ptr [r15 + 4]
    \\    movzx r13d, byte ptr [r15 + 5]
    \\    shl r14, cl
    \\    or rsi, r14
    \\    add ecx, r10d
    \\    lea r14d, [rcx + r13]
    \\    cmp r14d, {[put_bits_max]}
    \\    ja 20f
    \\    shl r12, cl
    \\    or rsi, r12
;

/// The literals: the octets written so far move past them, then a chunk of up to 64 at a time,
/// each after its room test.
pub const literals_start =
    \\30:
    \\    movzx r14d, bx
    \\    mov rsi, qword ptr [rdi + {[input]}]
    \\    add rsi, qword ptr [rdi + {[produced]}]
    \\    add qword ptr [rdi + {[produced]}], r14
    \\    mov r12, qword ptr [rdi + {[literal_codes]}]
    \\    mov r13, qword ptr [rdi + {[literal_lengths]}]
    \\31:
    \\    test r14, r14
    \\    jz 40f
    \\    mov r15d, {[chunk_len]}
    \\    cmp r14, r15
    \\    cmovb r15, r14
    \\    sub r14, r15
    \\    mov r9, r15
    \\    shl r9, 4
    \\    sub r9, r15
    \\    add r9, {[command_bits_max]}
;

/// A group of 3 literals: r9 their codes, r10 the bits.
pub const literals_group =
    \\32:
    \\    cmp r15, 3
    \\    jb 34f
    \\    movzx r9d, byte ptr [rsi]
    \\    movzx ecx, byte ptr [r13 + r9]
    \\    movzx r9d, word ptr [r12 + r9*2]
    \\    movzx r10d, byte ptr [rsi + 1]
    \\    movzx ebp, word ptr [r12 + r10*2]
    \\    shl rbp, cl
    \\    or r9, rbp
    \\    movzx r10d, byte ptr [r13 + r10]
    \\    add ecx, r10d
    \\    movzx r10d, byte ptr [rsi + 2]
    \\    movzx ebp, word ptr [r12 + r10*2]
    \\    shl rbp, cl
    \\    or r9, rbp
    \\    movzx r10d, byte ptr [r13 + r10]
    \\    add ecx, r10d
    \\    add rsi, 3
    \\    mov r10, rcx
;

/// The last 1 or 2 literals of a chunk in one put, where they take bits.
pub const literals_rest =
    \\    sub r15, 3
    \\    jmp 32b
    \\34:
    \\    test r15, r15
    \\    jz 31b
    \\    movzx r9d, byte ptr [rsi]
    \\    movzx r10d, byte ptr [r13 + r9]
    \\    movzx r9d, word ptr [r12 + r9*2]
    \\    add rsi, 1
    \\    cmp r15, 2
    \\    jb 35f
    \\    mov ecx, r10d
    \\    movzx r15d, byte ptr [rsi]
    \\    movzx ebp, word ptr [r12 + r15*2]
    \\    shl rbp, cl
    \\    or r9, rbp
    \\    movzx r15d, byte ptr [r13 + r15]
    \\    add r10d, r15d
    \\    add rsi, 1
    \\35:
    \\    xor r15d, r15d
    \\    test r10, r10
    \\    jz 31b
;

/// After the literals: the meta-block's end, else the copy, and the distance where the symbol
/// does not leave it out.
pub const distance =
    \\40:
    \\    mov r9, qword ptr [rdi + {[produced]}]
    \\    cmp r9, qword ptr [rdi + {[input_len]}]
    \\    je 90f
    \\    mov r10, rbx
    \\    shr r10, 16
    \\    movzx r10d, r10w
    \\    add r9, r10
    \\    mov qword ptr [rdi + {[produced]}], r9
    \\    mov r9, rbx
    \\    shr r9, 32
    \\    and r9d, {[symbol_mask]}
    \\    cmp r9d, {[last_distance_symbols]}
    \\    jb 1b
    \\    mov r9, rbx
    \\    shr r9, {[code_at]}
    \\    and r9d, {[code_mask]}
    \\    mov r10, qword ptr [rdi + {[distance_lengths]}]
    \\    movzx ecx, byte ptr [r10 + r9]
    \\    mov r10, qword ptr [rdi + {[distance_codes]}]
    \\    movzx ebp, word ptr [r10 + r9*2]
    \\    mov r10, qword ptr [rdi + {[distance_extra_bits]}]
    \\    movzx r10d, byte ptr [r10 + r9]
    \\    mov r9, rbx
    \\    shr r9, 48
    \\    shl r9, cl
    \\    or rbp, r9
    \\    add r10, rcx
;

/// An output with no room, then the state stored back and the caller's rbp.
pub const exit =
    \\80:
    \\    mov qword ptr [rdi + {[failed]}], 1
    \\90:
    \\    mov qword ptr [rdi + {[buffer]}], rax
    \\    mov qword ptr [rdi + {[count]}], r11
    \\    mov qword ptr [rdi + {[room]}], rdx
    \\    mov rbp, qword ptr [rdi + {[saved_frame]}]
    \\    .att_syntax prefix
;
