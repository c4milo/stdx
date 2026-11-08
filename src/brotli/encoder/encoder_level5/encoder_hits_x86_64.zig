//! Level 5's weighing of a bucket's hits in x86-64 assembly (decision 64, part 5): the port of
//! `encoder_hits_aarch64.zig`, as decision 54 ported DEFLATE's loop. It writes the pick and the
//! list of long candidates the Zig loop writes.
//!
//! It takes an x86-64 target built by LLVM: Zig's own x86-64 backend rejects Intel syntax. It
//! needs no instruction past the x86-64 baseline: `bsf`, with a `cmovz` for 8 octets that all
//! agree, counts the agreed octets, and `bsr` the offset's log2. x86-64 has fewer registers than
//! aarch64, so the values the loop does not change stay in the state, read by address.
//!
//! Its reads go by address, without Zig's bounds checks, as the aarch64 loop's do.

const std = @import("std");
const builtin = @import("builtin");
const assembly = @import("encoder_hits_assembly.zig");

/// Whether the assembly weighs the hits: an x86-64 target built by LLVM.
pub const takes = builtin.cpu.arch == .x86_64 and builtin.zig_backend == .stage2_llvm;

pub const State = assembly.State;

/// Weighs the hits `state` names and stores the pick back.
pub inline fn weigh(state: *State) void {
    asm volatile (text
        :
        : [state] "{rdi}" (state),
        : .{ .memory = true, .cc = true, .rax = true, .rbx = true, .rcx = true, .rdx = true, .rsi = true, .r8 = true, .r9 = true, .r10 = true, .r11 = true, .r12 = true });
}

/// rdi the state, rsi the window, r8 the bucket's entries, r9 the hits, rbx the best saving, r12
/// its candidate, r10 the long list, r11 its count; the state holds the rest, at the offsets of
/// `State`'s fields.
const text = std.fmt.comptimePrint(
    \\    .intel_syntax noprefix
    \\    mov rsi, qword ptr [rdi]
    \\    mov r8, qword ptr [rdi + 56]
    \\    mov r9, qword ptr [rdi + 64]
    \\    mov rbx, qword ptr [rdi + 72]
    \\    mov r12, qword ptr [rdi + 80]
    \\    mov r10, qword ptr [rdi + 88]
    \\    mov r11, qword ptr [rdi + 96]
    \\    test r9d, r9d
    \\    jz 2f
    \\1:
    // The lowest hit's way, and the hit cleared.
    \\    bsf ecx, r9d
    \\    lea edx, [r9 - 1]
    \\    and r9d, edx
    // The entry's position: an entry of an earlier stream wraps past the reach.
    \\    mov ecx, dword ptr [r8 + rcx*4]
    \\    sub ecx, dword ptr [rdi + 48]
    \\    mov edx, ecx
    \\    sub edx, dword ptr [rdi + 32]
    \\    cmp edx, dword ptr [rdi + 40]
    \\    jae 3f
    // The octets that agree within the first 8: 8 when the difference is 0.
    \\    mov rax, qword ptr [rsi + rcx]
    \\    xor rax, qword ptr [rdi + 8]
    \\    mov edx, {[all_bits]d}
    \\    bsf rax, rax
    \\    cmovz rax, rdx
    \\    shr eax, 3
    \\    cmp eax, {[min_len]d}
    \\    jb 3f
    // A candidate that agrees on all 8 goes on the long list.
    \\    mov qword ptr [r10 + r11*8], rcx
    \\    xor edx, edx
    \\    cmp eax, {[read_len]d}
    \\    sete dl
    \\    add r11, rdx
    // The saving: agreed octets at a literal's cost, less the match's cost and its offset's log2.
    \\    imul rax, qword ptr [rdi + 16]
    \\    mov rdx, qword ptr [rdi + 24]
    \\    sub rdx, rcx
    \\    bsr rdx, rdx
    \\    shl rdx, 3
    \\    sub rax, rdx
    \\    sub rax, {[match_cost]d}
    // The best saving wins, and the first of equal savings stays.
    \\    cmp rax, rbx
    \\    cmovg rbx, rax
    \\    cmovg r12, rcx
    \\3:
    \\    test r9d, r9d
    \\    jnz 1b
    \\2:
    \\    mov qword ptr [rdi + 72], rbx
    \\    mov qword ptr [rdi + 80], r12
    \\    mov qword ptr [rdi + 96], r11
    \\    .att_syntax prefix
, .{ .all_bits = @bitSizeOf(u64), .min_len = assembly.min_len, .read_len = assembly.read_len, .match_cost = constants.encoder_match_cost_base });

const constants = @import("../../constants.zig");
