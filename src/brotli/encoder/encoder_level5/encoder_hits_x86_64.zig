//! Level 5's search of a bucket's hits in x86-64 assembly (decision 66, part 6): the port of
//! `encoder_hits_aarch64.zig`, as decision 54 ported DEFLATE's loop, with the same API.
//!
//! It takes an x86-64 target built by LLVM: Zig's own x86-64 backend rejects Intel syntax. It
//! needs no instruction past the x86-64 baseline: `rep bsf` takes the newest hit and counts the
//! agreed octets, and `bsr` gives the distance's log2. x86-64 has fewer registers than aarch64, so
//! the values the loop does not change stay in the search, read by address, and the compare at
//! the best length starts at a least distance, which one compare tests.
//!
//! Its reads go by address, without Zig's bounds checks, as the aarch64 loop's do.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const assembly = @import("encoder_hits_assembly.zig");
const buckets_module = @import("encoder_buckets.zig");

const Buckets = buckets_module.Buckets;
const ways = buckets_module.ways;

/// Whether the assembly searches the hits: an x86-64 target built by LLVM.
pub const takes = builtin.cpu.arch == .x86_64 and builtin.zig_backend == .stage2_llvm;

/// The search's values, which `consider`'s text reads by address at these offsets. A candidate is
/// its position less `low`, the lowest position in reach.
pub const Search = extern struct {
    /// The window from `low`.
    window: [*]const u8,
    here: u64,
    cost: u64,
    /// `position - low`: a candidate in reach lies below it, and its distance is the reach less it.
    reach: u64,
    /// The entry of `low` with the slot's check: an entry less it is the candidate.
    base: u64,
    entries: [*]const u32,
    /// The bucket's ring's next way plus 15: the way written `step` inserts before the last is
    /// `newest - step`, modulo 16.
    newest: u64,
    /// The hits left, bit `step` for the way written `step` inserts before the last.
    order: u64,
    /// The best saving plus `cost_bias`, and its candidate.
    saves: i64,
    candidate: u64,
    /// The compare at the best length: the window from `low + at`, the 8 octets from `at` at the
    /// position, and the least distance whose candidate the compare may refuse; `none` for none.
    tail_window: [*]const u8,
    tail: u64,
    tail_from: u64,
};

/// What `consider` returns when no hit is left.
pub const none = std.math.maxInt(u64);

comptime {
    // The offsets the text reads.
    assert(@offsetOf(Search, "here") == 8 and @offsetOf(Search, "newest") == 6 * 8);
    assert(@offsetOf(Search, "tail_window") == 10 * 8 and @offsetOf(Search, "tail_from") == 12 * 8);
}

/// The search of `slot`'s hits at `position`, as `encoder_hits_aarch64.begin` makes it.
pub inline fn begin(buckets: *const Buckets, slot: buckets_module.Slot, window: [*]const u8, position: usize, low: usize, here: u64, cost: u32, saves: i64, candidate: usize) ?Search {
    const hits = buckets.hits(slot);
    // Many positions of a row of literals have no hit, and then the setup costs more than the scan.
    if (hits == 0) return null;
    const next: u64 = buckets.next_of(slot);
    return .{
        .window = window + low,
        .here = here,
        .cost = cost,
        .reach = position - low,
        .base = buckets.entry_at(slot.check, low),
        .entries = &buckets.entries[slot.bucket],
        .newest = next + ways - 1,
        .order = std.math.rotl(u16, @bitReverse(hits), next),
        .saves = saves + assembly.cost_bias,
        .candidate = candidate -% low,
        .tail_window = undefined,
        .tail = undefined,
        .tail_from = none,
    };
}

/// Sets the compare at the best length, or none for a `clz_max` of -1. A distance has at most
/// `clz_max` leading zeros from 2^(63 - clz_max) up.
pub inline fn set_compare(search: *Search, tail_window: [*]const u8, tail: u64, clz_max: i64) void {
    const top = @bitSizeOf(u64) - 1;
    search.tail_window = tail_window;
    search.tail = tail;
    search.tail_from = if (clz_max < 0) none else if (clz_max >= top) 0 else @as(u64, 1) << @intCast(top - clz_max);
}

/// Whether a compare at the best length is set.
pub inline fn compares(search: *const Search) bool {
    return search.tail_from != none;
}

/// Considers the hits `search.order` names, the newest first, until one agrees on all 8 octets:
/// returns it, for the caller to measure, or `none` when no hit is left.
pub inline fn consider(search: *Search) u64 {
    return asm volatile (consider_text
        : [pending] "={rcx}" (-> u64),
        : [search] "{rdi}" (search),
        : .{ .memory = true, .cc = true, .rax = true, .rbx = true, .rdx = true, .rsi = true, .r8 = true, .r9 = true, .r10 = true, .r12 = true });
}

/// `consider` while no compare at the best length is set.
pub inline fn consider_first(search: *Search) u64 {
    return asm volatile (consider_first_text
        : [pending] "={rcx}" (-> u64),
        : [search] "{rdi}" (search),
        : .{ .memory = true, .cc = true, .rax = true, .rbx = true, .rdx = true, .rsi = true, .r8 = true, .r9 = true, .r10 = true, .r12 = true });
}

/// rdi the search, rsi the window from `low`, r8 the bucket's entries, r9 the hits in order, r10
/// the newest way plus 16 less 1, rbx the best saving plus `cost_bias`, r12 its candidate; rcx the
/// candidate to measure, rdx its distance. The search holds the rest, at the offsets of `Search`'s
/// fields.
///
/// `rep bsf` counts trailing zeros of a value that is not 0: a CPU with BMI1 runs it as `tzcnt`,
/// and any other as `bsf`, which gives the same count. `bsf` and `bsr` alone take microcode on
/// AMD's cores before Zen 4, so the loop takes each hit with `rep bsf` and clears it with an
/// `and`, a chain of 2 cycles a hit.
const pick =
    \\    .intel_syntax noprefix
    \\    mov rsi, qword ptr [rdi]
    \\    mov r8, qword ptr [rdi + 40]
    \\    mov r10, qword ptr [rdi + 48]
    \\    mov r9, qword ptr [rdi + 56]
    \\    mov rbx, qword ptr [rdi + 64]
    \\    mov r12, qword ptr [rdi + 72]
    \\    test r9d, r9d
    \\    jz 8f
    \\1:
    // The newest hit's way, and the hit cleared.
    \\    rep bsf ecx, r9d
    \\    lea eax, [r9 - 1]
    \\    and r9d, eax
    \\    mov eax, r10d
    \\    sub eax, ecx
    \\    and eax, 15
    // The candidate: an entry with another check, below `low` or past the position wraps past
    // the reach.
    \\    mov ecx, dword ptr [r8 + rax*4]
    \\    sub ecx, dword ptr [rdi + 32]
    \\    cmp ecx, dword ptr [rdi + 24]
    \\    jae 3f
    \\    mov rdx, qword ptr [rdi + 24]
    \\    sub rdx, rcx
    \\
;

/// A candidate no nearer than the best saves more only when it is longer: 8 octets that differ up
/// to the best length refuse it. A best that a shorter match took since saves more, so the compare
/// still refuses only what saves no more.
const compare =
    \\    cmp rdx, qword ptr [rdi + 96]
    \\    jb 2f
    \\    mov rax, qword ptr [rdi + 80]
    \\    mov rax, qword ptr [rax + rcx]
    \\    cmp rax, qword ptr [rdi + 88]
    \\    jne 3f
    \\
;

/// All 8 octets agree: the caller measures the candidate. Fewer than the first 4: a collision.
/// Else the saving plus `cost_bias`, agreed octets at a literal's cost and 8 for each leading zero
/// of the distance, and the best saving wins, the first of equal savings staying.
const weigh =
    \\2:
    \\    mov rax, qword ptr [rsi + rcx]
    \\    xor rax, qword ptr [rdi + 8]
    \\    jz 9f
    \\    test eax, eax
    \\    jnz 3f
    \\    rep bsf rax, rax
    \\    shr eax, 3
    \\    imul rax, qword ptr [rdi + 16]
    \\    bsr rdx, rdx
    \\    xor edx, 63
    \\    lea rax, [rax + rdx*8]
    \\    cmp rax, rbx
    \\    cmovg rbx, rax
    \\    cmovg r12, rcx
    \\3:
    \\    test r9d, r9d
    \\    jnz 1b
    \\8:
    \\    mov rcx, -1
    \\9:
    \\    mov qword ptr [rdi + 56], r9
    \\    mov qword ptr [rdi + 64], rbx
    \\    mov qword ptr [rdi + 72], r12
    \\    .att_syntax prefix
;

const consider_text = pick ++ compare ++ weigh;
const consider_first_text = pick ++ weigh;

/// The lazy step's probe of a bucket's hits, which `probe`'s text reads by address at these
/// offsets: the hits in way order, each admitted by `Floor`'s compare. A candidate is its position
/// less `low`.
pub const Probe = extern struct {
    /// The window from `low` and the floor's offset, and from one octet before it.
    tail_window: [*]const u8,
    shorter_window: [*]const u8,
    reach: u64,
    /// The entry of `low` with the slot's check: an entry less it is the candidate.
    base: u64,
    entries: [*]const u32,
    /// The hits left, bit w for way w.
    order: u64,
    /// The floor: the 4 octets at its offset, and nearer than `near`, the 4 octets one before.
    near: u64,
    tail: u64,
    shorter_tail: u64,
};

comptime {
    assert(@offsetOf(Probe, "order") == 5 * 8 and @offsetOf(Probe, "shorter_tail") == 8 * 8);
}

/// The probe of `slot`'s hits at `position`, as `begin` finds them, or none when the bucket has
/// none. `at`, `tail`, `near` and `shorter_tail` are the floor's.
pub inline fn probe_begin(buckets: *const Buckets, slot: buckets_module.Slot, window: [*]const u8, position: usize, low: usize, at: usize, tail: u32, near: usize, shorter_tail: u32) ?Probe {
    const hits = buckets.hits(slot);
    if (hits == 0) return null;
    return .{
        .tail_window = window + low + at,
        .shorter_window = window + low + at - 1,
        .reach = position - low,
        .base = buckets.entry_at(slot.check, low),
        .entries = &buckets.entries[slot.bucket],
        .order = hits,
        .near = near,
        .tail = tail,
        .shorter_tail = shorter_tail,
    };
}

/// Takes the hits `probe.order` names, the lowest way first, until the floor admits one: returns
/// it, for the caller to measure, or `none` when no hit is left.
pub inline fn probe(search: *Probe) u64 {
    return asm volatile (probe_text
        : [pending] "={rcx}" (-> u64),
        : [search] "{rdi}" (search),
        : .{ .memory = true, .cc = true, .rax = true, .rdx = true, .rsi = true, .r8 = true, .r9 = true, .r10 = true });
}

/// rdi the probe, rsi and r10 the floor's two windows, r8 the bucket's entries, r9 the hits; rcx
/// the candidate to measure. The probe holds the rest, at the offsets of `Probe`'s fields.
const probe_text =
    \\    .intel_syntax noprefix
    \\    mov rsi, qword ptr [rdi]
    \\    mov r10, qword ptr [rdi + 8]
    \\    mov r8, qword ptr [rdi + 32]
    \\    mov r9, qword ptr [rdi + 40]
    \\    test r9d, r9d
    \\    jz 8f
    \\1:
    // The lowest way's hit, and the hit cleared.
    \\    rep bsf ecx, r9d
    \\    lea eax, [r9 - 1]
    \\    and r9d, eax
    // The candidate: an entry with another check, below `low` or past the position wraps past
    // the reach.
    \\    mov ecx, dword ptr [r8 + rcx*4]
    \\    sub ecx, dword ptr [rdi + 24]
    \\    cmp ecx, dword ptr [rdi + 16]
    \\    jae 3f
    // The floor: the 4 octets that end at the held match's length, or, for a candidate nearer
    // than `near`, the 4 octets one before.
    \\    mov eax, dword ptr [rsi + rcx]
    \\    cmp eax, dword ptr [rdi + 56]
    \\    je 9f
    \\    mov rdx, qword ptr [rdi + 16]
    \\    sub rdx, rcx
    \\    cmp rdx, qword ptr [rdi + 48]
    \\    jae 3f
    \\    mov eax, dword ptr [r10 + rcx]
    \\    cmp eax, dword ptr [rdi + 64]
    \\    je 9f
    \\3:
    \\    test r9d, r9d
    \\    jnz 1b
    \\8:
    \\    mov rcx, -1
    \\9:
    \\    mov qword ptr [rdi + 40], r9
    \\    .att_syntax prefix
;
