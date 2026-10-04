# Performance work in stdx

The method every performance change follows is pepegrillo's `docs/performance.md`: `zig build guide`
installs it, at the commit `build.zig.zon` pins, to `zig-out/docs/performance-method.md` (its
[copy on GitHub](https://github.com/c4milo/pepegrillo/blob/main/docs/performance.md) is the current
one); read it first. This appendix is what that method leaves to the project:
stdx's instruments, its admission rule, its baselines, its costs, and the pitfalls it has paid for.
CLAUDE.md's Performance section states the rules; decisions 10, 14, 16, 17, 20, 23, 24, 29 and 32
hold the rulings, and [costs.md](costs.md) the prices.

## The instruments

- The filter is the owner's M1 Pro. `/usr/bin/time -l` over a harness that decodes a stream a
  fixed number of times gives the instructions retired, which survive noise and other processes;
  its cycles count only when the machine runs nothing else. macOS publishes no number (decision
  10).
- The judge is GitHub's hosted runners (decision 20): the `bench` workflow, whose `base` input
  measures the base and the change in one job on one VM and one CPU. The aarch64 runner is a
  Neoverse-N2 or a V3; the x86-64 runner draws an EPYC 7763, 9V45, 9V74 or a Xeon from run to run,
  so a comparison holds inside a job and never across two runs.
- The admission rule (decision 20, amended 2026-09-28, 2026-09-29 and 2026-09-30): a file wins or
  loses when it moves past the larger of its own spread and 1% in every job; a change stays when it
  wins somewhere and no file loses. Two paired runs a change, compared with each job's base report.
  A move is placement, neither a win nor a loss, when the bench program built at both commits runs
  that file on code identical apart from its addresses; and a ratio's fall is the baseline's, not
  the change's, when stdx's own speed on that file stays within its spread in every job while the
  baseline's moved. A change whose code no corpus file runs wins on a probe's inputs, which a
  branch that never lands adds beside the corpus. Decision 20 says how to prove each.
- Every speed states the stream's compression beside it, as `bench-brotli`, `bench-deflate` and
  `bench-zstd` print it.
- `bench-profile` gives cycles, instructions and branch misses per octet on the runners, beside
  each baseline's; the M1 sampler and `llvm-symbolizer --inlining` over a dSYM give the layers
  below that.

## The baselines

zlib, zlib-ng, libdeflate, Wuffs, libzstd and Google's brotli, compiled into `tools/` and `bench/`
only (decision 8). To split a baseline's time, sample its binary by function names; never read its
source (CLAUDE.md, non-negotiable 5). Its encoder, built from its public API, makes the streams the
M1 harnesses decode.

## What the codecs add to the method

- The checked path is the reference; a fast path runs only inside decision 16's margins (an input
  slack of 8 octets per refill, an output margin of a chunk and a vector past it), and decision 32
  keeps a mode that checks each write below the margin.
- Assertions stay on in production (decision 17); one loop runs without them, decision 16's ruled
  exception, held by a claim so the benchmark prices the checks.
- Tables are two-level lookups with an 8-bit root of 1 KiB and entries of 4 octets, built once per
  meta-block or block; a literal block type's tables sit in a pointer array per context.
- The window takes a call's octets once, at the call's end (the window-once claim); copies move
  16-octet chunks with two stored before the length is looked at, an 8-octet width for distances 8
  to 15, a fill for a distance of 1.
- Assembly loops follow decisions 23, 24 and 29: a struct of 8-octet fields, the text in templates
  with named offsets, the Zig loop kept as the reference and for every other target, the access
  table in the loop's file.
- The N2 pays 4 ns a mispredict against the M1's smaller price: a change worth 17% of the M1's
  header cycles was worth 31 to 44% on the N2's 1 KiB bodies.

## The proofs

1. A first-differing-octet harness: decode a stream with the change and with the reference (the
   checked path, or the Zig loop for an assembly one); print both outcomes and the first octet that
   differs. Run it on the fixtures and on the 1 KiB, 16 KiB and 1 MiB bodies of the HTTP corpus.
2. `zig build test-<module>`: every input length, every room, the state moved between calls.
3. `zig build differential-<codec> -Doracles`: the oracle over the corpora, corruptions included;
   it caught a flag bit the tests could not.
4. `tools/fuzz.sh 20K <report> <module>`.

Check the files that do not share the hot path the change touched: E.coli and the shuffled
dickens-1m for a command loop, the 1 KiB bodies for the header, the largest windows for copies.

## Pitfalls this tree has paid for

| Symptom | Cause | Rule |
|---|---|---|
| M1 cycles 40% apart between two runs of one binary | another harness ran beside it | count instructions; measure cycles alone |
| a cut of instructions measures flat | the loop is latency-bound | shorten the chain, not the count |
| +40% on the N2 from a change worth 17% of M1 cycles | branch misses, which the N2 pays more for | judge on the runners; price mispredicts |
| −40% on the all-literal files beside a +14% median | an out-of-line call took the loop's address; a loop exited per run | `inline`; the next run inside the loop; check those files |
| a refusal read a code past its table | a flag bit shared an octet with a field | the differential's corruptions; extract a field by its width |
| a mutation not caught | its effect masked by the reference's tail or a later step | a test that observes the effect where it lives |
| two x86-64 runs disagree | different CPUs | pair inside one job with `base` |
| a dispatch ran on the old tip | a `;` or a heredoc broke the `&&` chain before the push | write the file first; join every step with `&&` |
| a 16-octet block loop at 0.1 of a baseline with the same operation count | LLVM split each block's load into a load of 13 lanes and three of one lane, for the shuffles that read a block's low lanes | grep the loop's disassembly for lane loads; pass the loaded register through an empty `asm` before the shuffles (`scan_utf8.loaded`) |
| two x86-64 draws agree against the M-series host on a loop's shape | the encoder's and the decoder's loops want different shapes, and one setting served both | measure each loop's shape apart; a shape is per caller, not per architecture (design §8 step 18) |
| level 6 encoding 20% slower with the same state | the encoder's state at a comptime-known address, and a harness that lied until it allocated once and passed a pointer | hold a state behind a pointer, in the harness too |
| a chain walk 1.4 to 1.6 times slower than its inline form | the walk kept in a struct whose step was a call | the step inline |
| −2.4% on a one-tree literal file on the N2 beside +6% on the M1 | three taken branches per literal in the hand-written loop, where LLVM's layout takes two | the common path falls through; refills and second levels out of line |
| ten x86-64 files lose 4 to 7% with x86-64's code byte-identical | the baseline's own speed drifted between the job's two phases | diff the target's disassembly; judge a change on the target it touches |
| the N2 counts 57k instructions for a decode the M1 counts at 47.6k | outside Darwin, Zig 0.16's compiler_rt memset takes an octet at a time, and a safe build's clear of a 520-octet local went through it on every entry | list the `memset` relocations of a Linux object before trusting the M1's counts |
| a third of the header's instructions looked like a fifth of its time | store loops run near 5 instructions a cycle on the M1 | count a part's instructions by leaving it out, or by repeating it when it is idempotent |
| a distance-1 fill made of inline stores cost x86-64 3 to 8% on command-heavy files | it changed the register allocation of the whole straight loop | diff the whole function's disassembly for each target, not the lines changed |
| text files 4% slower and 15% faster in both N2 jobs, with every claim on, their walk's instructions unchanged | a function placed before the walk shrank by 52 octets, and every function after it moved | cross-build the bench at both commits and diff its functions; judge a change on the target it touches (design §8 step 18) |
| the 64-lane UTF-8 check at 55 GB/s on 16 files and 163 on one, simdutf the reverse | each buffer's offset from a 64-octet line: a 64-octet load that crosses one cost two thirds of the speed on a Xeon 8370C | start wide loads on a line of their width; time each offset (bench-json's sweep) |
| a kernel's rows 21% to 38% slower on an EPYC 9V45 with its instructions unchanged | the variant object's text was 16-octet aligned, so every change to the module's own code moved its kernels within their lines | start each kernel and each loop's function on a 64-octet line (`kernel_alignment`) |
| the placement proof finds the shared timing loop changed | one caller passed it a slice whose length was known only at run time, and LLVM kept a check it had proved away | give every call of a shared harness a fixed length |
| a 32 KiB clear at 33,500 cycles on the N2 and 1,200 on the M1 | Zig 0.16's compiler runtime defines `memset` an octet at a time; on Linux it serves every `@memset` LLVM leaves as a call and every large `undefined` local of a safe build, while macOS links libSystem's | the program exports a vector `memset` of its own, as `bench/timing/memset.zig` does (decision 41); no large `undefined` scratch in a per-call path; look for `memset` relocations in a Linux build's `objdump -dr` (design §8 step 9) |
| the baselines' fills slow in the benchmarks on Linux alone | the C code of libdeflate, zlib, Google's brotli and the rest called the same octet-at-a-time `memset` in stdx's benchmark programs | `bench/timing/memset.zig`, which every benchmark program imports through `timing`, exports a vector `memset` on Linux under Zig 0.16; take a base with it in place before comparing a change |
| a flag added to the decoder's state moved two lookup tables from 16-aligned offsets to 2 mod 16 | Zig reorders a plain struct's fields when one is added | declare a new field last, void where no code reads it, and diff every field's offset against main |
| a fill whose A/B could show nothing on any corpus file | libzstd writes no repeated block for any corpus file at level 3 | count how often the corpus runs the changed code before measuring; a probe of inputs that run it (design §8 step 11) |
| two mutation runs over different mutations failed the same tests in step | copies of the tree compiled by `zig test` with the same flags shared a cache and took each other's binaries | give every tree its own `--cache-dir` |
| the x86-64 small bodies 2.0 to 2.9 µs a decode behind Google's decoder, whatever their size | the benchmark ran `codec.Features.detect()` for each decode: three CPUIDs, each a virtual machine's exit to its hypervisor | detect once, as a caller does; read a gap that stays the same in µs a decode as a cost of each call |
| a token loop 16 to 21 instructions a token slower with each state in a function of its own | the functions returned the next state to one switch, and the join of every state's values cost register moves and constants built again | write the grammar as loops, so the state is the place in the code; a labeled switch with a jump a transition is as fast, and the complexity lint counts each jump (design §8 step 18) |
| 8 instructions to find a slot on x86-64 where 3 do | a pointer assigned only where a test passed became a conditional move of a value kept on the stack | take the address before the test, and assert the test before each write |
| a row 2% slower in both N2 jobs with its instructions unchanged | the function that holds the row's time is identical and sits at a new address | count the file's instructions at both commits with callgrind (decision 20, amended 2026-10-03) |

## Commands

```bash
zig build bench-<codec> -Doracles
zig build bench-profile -Doracles
gh workflow run bench.yml --ref <branch> -f benchmark=<codec> -f base=<main tip>
/usr/bin/time -l ./harness <stream> <len> <repetitions>
zig build test-<module>
zig build differential-<codec> -Doracles
tools/fuzz.sh 20K report.md <module>
```
