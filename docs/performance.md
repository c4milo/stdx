# Performance work in stdx

The method every performance change follows is pepegrillo's `docs/performance.md`: `zig build guide`
installs it, at the commit `build.zig.zon` pins, to `zig-out/docs/performance-method.md` (its
[copy on GitHub](https://github.com/c4milo/pepegrillo/blob/main/docs/performance.md) is the current
one); read it first. This appendix is what that method leaves to the project:
stdx's instruments, its admission rule, its baselines, its costs, and the pitfalls it has paid for.
CLAUDE.md's Performance section states the rules; decisions 10, 14, 16, 17, 20, 23, 24, 29, 32 and
45 hold the rulings, and [costs.md](costs.md) the prices.

## The instruments

- The filter is the owner's M1 Pro. `/usr/bin/time -l` over a harness that decodes a stream a
  fixed number of times gives the instructions retired, which survive noise and other processes;
  its cycles count only when the machine runs nothing else. macOS publishes no number (decision
  10).
- The judge is GitHub's hosted runners (decision 20): the `bench` workflow, whose `base` input
  measures the base and the change in one job on one VM and one CPU. The aarch64 runner is a
  Neoverse-N2 or a V3; the x86-64 runner draws an EPYC 7763, 9V45, 9V74 or a Xeon from run to run,
  so a comparison holds inside a job and never across two runs.
- The admission rule (decision 20, amended 2026-09-28, 2026-09-29, 2026-09-30, 2026-10-03 and
  2026-10-04): a file wins or loses when it moves past the larger of its own spread and 1% in
  every job; a change stays when it wins somewhere and no file loses. Two paired runs a change,
  compared with each job's base report. A move is placement, neither a win nor a loss, when the
  bench program built at both commits runs that file on code identical apart from its addresses,
  when callgrind counts the functions that differ at under 1% of the file's instructions, or
  when a null build of the change, which holds its code behind a test that never holds, moves
  the row as far on the same CPU model. A move is the branch predictor's, neither a win nor a
  loss, when the runner's counters put it in branch misses and the change altered no branch the
  file runs. A ratio's fall is the baseline's, not the change's, when stdx's own speed on that
  file stays within its spread in every job while the baseline's moved. A change whose code no
  corpus file runs wins on a probe's inputs, which a branch that never lands adds beside the
  corpus. Decision 20 says how to prove each.
- Every speed states the stream's compression beside it, as `bench-brotli`, `bench-deflate` and
  `bench-zstd` print it.
- A row codes a corpus file whole, but for the 1 KiB and 16 KiB HTTP bodies: those it codes as
  the slices of their 1 MiB payload, one stream a slice, one after another, each from a state
  started anew (decision 45, `bench/timing/inputs.zig`). A branch predictor learns one input that
  a row repeats, the shorter the input the more, and a row of slices meets each slice once a
  round. Each table names the files of 256 KiB or less that a row still repeats; read their rows
  as an input the predictor has learned.
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
| five files 1.3% to 5% slower at level 1 on an EPYC 7763 in both runs, on fewer instructions and loops that are main's | the functions before the encoder's loops changed size, and each loop started 16 or 32 octets from where main starts it in its 64-octet line | start a codec's hot functions on a line before judging a change to it (`hot_function_alignment`, design §8 step 9) |
| a pair's losses that no count of instructions explains | zlib, zlib-ng and libdeflate, whose code the change does not touch, ran up to 32 files slower in both runs of the same jobs, by the same rule | apply the admission rule to the baselines' columns first; a pair resolves no move smaller than theirs |
| a 16 KiB file 9% to 20% slower on the M1 at level 1 in one harness and level in another, on fewer instructions | each harness repeats one input, which the branch predictor learns: one slice of 16 KiB repeated takes 5.2 cycles an octet, 64 slices in rotation 8.7 on fewer instructions | time a small input as many slices in rotation; one input repeated measures what the predictor remembers |
| the same slices 5% to 61% slower in rotation than with each repeated, for every candidate, on the same instructions | the runners' branch predictors learn an input a row repeats: in rotation the N2 takes 1.1 to 15.8 times the misses, about 16 cycles each, and copies of one slice at other addresses run as fast as the slice | a small HTTP body is slices in rotation (decision 45, `bench/timing/inputs.zig`); read the row of a file a table marks as an input the predictor has learned |
| stdx's decoder at 1.24 to 1.40 of libdeflate's speed on a 64 KiB text repeated, and at 1.03 to 1.12 in rotation | a repeated input teaches the predictor more of stdx's branches than of libdeflate's: 56 misses a KiB repeated and 95 in rotation on the N2, against 69 and 83; the learning shrinks with length and is under 3% from 1 MiB up | rank no candidate on a row that repeats one file of 256 KiB or less; to ask whether an input is learned, time it repeated, as copies, and in rotation (design §8 step 9) |
| a store for each item of a header refused for costing the M1 23% on a 16 KiB file | the header's writer takes under 5% of that encode: the harness repeated one input, and the change moved what the predictor had learned | re-measure a refusal that rests on one repeated small input, on slices in rotation, before building on it (design §8 step 9) |
| a text 18% slower on the N2 on fewer instructions, its block loop unchanged | the branch predictor took the build's branches worse: 1.7 misses a line of bible.txt where one more branch before the loop took 0.9 | count the row's branch misses at both commits with `bench_json --profile` before reading its speed; the loop's place and padding do not move it (decision 20, amended 2026-10-04) |
| four instructions at each stop of a string's blocks, in strings with no `\u` escape | a rarer loop inlined beside the walk's kept eight constants in registers the block loop takes, and LLVM set them again at each of its exits | call the rarer loop out of line (`unicode_call`, design §8 step 18) |
| the token loop 1.6 instructions a token slower from a cheaper compare in a scan it inlines | the compare changed the register allocation of the loop that inlines it | count each caller that inlines a changed helper; keep the old form where a caller loses (`scan.plain_stops`) |
| a ruling asked for on a list of losing rows that missed two sets | the list came from reading the pair's text rows; hex strings and qlog's records were down in both jobs too | apply the admission rule to every row and every candidate of both pairs by script before asking |
| prose 4% to 11% slower on an EPYC 9V74, its loop's source unchanged and its count on aarch64 the same | a checked subtraction at each of a function's five ends kept its operands in registers for the panics, and the loop's count of its passes went to the stack around the hot loop | report what the loop already holds, cast unchecked, and check in the caller; read which register the object spills around the hot loop (design §8 step 18) |
| each token 1.15 instructions slower after a function the token loop calls became short | LLVM inlined it into the loop | `@call(.never_inline, ...)` at the loop's call site; compare the loop's function with main's after each change to what it calls |
| 9 instructions a call in a short function that only passes a result on | a stack guard: a Zig `inline` function that returns an optional struct from several places, or a local whose address a callee takes, leaves a copy on the stack | return two words in registers, and return once for each outcome |
| every string of a long text sent down the path for long strings | the function is given the rest of the input, whose length is not the string's | tell a long string only once its first stretch has not closed it |
| main's CI red in `zig build test-self-hosted` on two runners, after a change to vector code that `zig build test` passed | code every build compiles named a kernel that needs a lookup; LLVM assembles VPSHUFB for a CPU without it, and Zig's own x86-64 backend refuses | before a push of vector code run `zig build test-self-hosted` and `zig build test-avx512`, which `zig build test` leaves out; test a kernel's `available` at compile time wherever shared code names it (design §8 step 18) |
| 5% to 12% fewer instructions on the files of few matches, and the same time | the path's time was branch misses that wait on dependent loads: a hash chain holds no candidate, one or two about equally often, and a walk tests each in turn | count mispredicted branches by line beside instructions before cutting (callgrind's `--branch-sim=yes`, the runners' counters); read what the tests need with no branch and test once |
| E.coli 11% slower on the N2 on 5% fewer instructions, in a walk loop written over | LLVM joined the loop's two ends, a count and a compare of a loaded value, into one branch, so the miss that ends the walk waited on the load | keep the loop the runners have passed and put new code before it; read a rewritten loop's branches in the built code |
| text 1% to 6% slower after code was added beside a loop whose source did not change | a 16-bit value in the new code shared the loop's first value, and LLVM's type promotion on aarch64 then left the loop's value 16 bits wide, extended on each pass | write code that shares a hot loop's value in index-wide integers; compare the loop's instructions with main's on both targets after each change near it |
| 22 rows 1% to 4% slower on the N2 after code was added to a function whose loops did not change | the loops moved about 100 octets on their 64-octet lines; a build that held the new code and never ran it lost 0.5% to 2% on the same rows | pair a null build of the change with the base, and read the change's rows beside it (decision 20, amended 2026-10-04) |
| a branch-free read with one test more kept none of its gain on x86-64 | LLVM built the test's `and` of two compares as two branches there, the first the branch the read was written to remove, and moved seven registers round and back about the next load | count instructions for x86-64 under emulation before a pair; keep a form one architecture pays for behind a named comptime constant |
| a mispredict count a quarter higher on a line whose instructions did not change | callgrind's branch model keeps one table by address, and two branches shared an entry once the code moved | read its counts by line, and trust a line's count only where the line's code changed |
| a name of 1 to 3 octets took 14 to 39 instructions to scan | the scalar scan tests each octet against four bounds, with a branch each | a table of 256 entries, one load an octet, over the three loads that cover 1 to 3 octets (design §8 step 18) |
| a string's octets loaded twice, and its length tested twice | the scan and the copy were two calls, each choosing its moves by the length | copy as the scan loads: store the halves the scan compares, and write again where the scan finds a stop |
| 35 instructions to check 4 to 7 octets as one block | LLVM built a vector of two loaded halves and 8 constant lanes a lane at a time | compare the two halves as a block of 8 lanes |
| 14 instructions to assert that two slices share no octet | sums checked for overflow, and the output's bounds loaded from the stack at each | subtractions that wrap, each compared with the other slice's length |
| a bound checked at each store around a string | each store indexed the output left, whose length LLVM could not relate to the room's test | sum the string's lengths once, take one slice of that length, and store at offsets inside it |
| x86-64 builds alone failed with "evaluation exceeded 1000 backwards branches" | a loop whose steps are all inline passed comptime's default quota once more steps were added, on the target that instantiates most | `@setEvalBranchQuota` from a named constant in the loop's function; build for x86-64 before a push |
| a block path 10% slower than the walk on a text with one escape a line, on fewer instructions, on the N2 alone | the path runs 28 vector instructions a block, and the N2 has two pipes for them | count a block's vector instructions, not its instructions; take one or two stops with stores of general registers and a second load of the octets after the stop (design §8 step 18, claim J14) |
| a text at 0.45 of its speed with a block path added | the path was tried after every escape and took nothing: a run of an octet it does not take | after a try that takes nothing, wait until the slower path has taken a stretch |
| a block path tried where the last run was not ASCII | the test read the walk's state after the first of two escapes had reset it | keep the verdict of the last run the walk took, which an escape that follows another leaves alone |
| one loop at 2,692, 2,702, 3,082 and 3,191 MB/s in four builds on the N2 | where the build put it; its head's place in a 64-octet line did not say which build was fast | start the loop's function on a line, and state the range across builds beside the pair's ratio |
| a mutation NOT CAUGHT because a second path writes the same octets | the walk wrote again what the blocks had written when it was not moved past them | put the move inside the function a test calls, and require the move there |
| a block loop of 56 instructions a pass where 35 do the work | each block's slices were checked on their own, three tests a block | take a pass's octets as two arrays of the pass's length, each checked once |
| a scan of nine vector instructions a block of 16 on the N2 | a compare for each range of octets and one for each of two marks, then two instructions to move the lanes into a word | read the octets as signed, so one compare finds both ranges; find two octets by their distance from the octet between them; fold a pass's blocks by their least before the compare |
| fourteen strings 18% to 69% slower to encode on an EPYC 9V45 in one job, on a kernel identical at both commits | the kernel's twin for a caller with the loop's checks off, at another address of the same program, encoded them at main's speed: the kernel branches on each block of 16 octets, each row repeats one input, and the CPU predicted the branch at one address and not at the other | read the "J11 loop unchecked" column beside the row, and prove the kernel identical apart from its address, before a string row on an EPYC 9V45 or 9V74 counts as a loss or a gain (design §8 step 18) |
| a 3% loss on four small rows of an EPYC 7763 that a later change, which touches none of their code, took back | the function that holds the loop grew, and x86-64 kept one more of its counters in memory | pair a stack of changes to one function with main as one, beside each change's own pair |
| six mutations of an AVX2 kernel's call NOT CAUGHT by the x86-64 tests on a Mac | Rosetta runs AVX2 and names it to a program only when `ROSETTA_ADVERTISE_AVX=1` is set, so `Features.detect()` named none and no test reached a kernel of the variant object | set it for every x86-64 test and mutation run under Rosetta |
| the input's address stored to the stack and loaded again at every name on x86-64, in a loop whose every token waits for it | a string's content was taken as a slice of its own, one octet into the input: its start and its length were two values more for the loop to keep | move the input from the one slice it is already in; count the loop's loads from the stack and its stores a token, from callgrind's counts by instruction (`--dump-instr=yes`) |
| a loop's mispredictions cut by 79% and its cycles up by 46% on the N2 | the form with no branch made each pass's start wait for the pass before it, its load, its digits' test and the mask, where a predicted branch moved the input by a constant and let passes overlap | before a branch leaves a loop, see what the next pass's start then waits for; read the N2's counters for the probe (`bench-profile`) before pairing it |
| a block loop with no branch on its octets at one speed on every text, below main's on 10 texts of an EPYC 9V74 | it paid the lookup for every pair of blocks, 58 instructions for 32 octets, where a pair of plain ASCII needs 17 behind a branch; the branch costs only where the CPU mispredicts it: the form with no branch ran seven texts faster than the form with the branch on an EPYC 7763, and one on the 9V74 | keep the cheap path for the common block behind one branch a wider pass, and pair each form on two CPU models before choosing: which form wins follows the predictor (design §8 step 18) |
| texts that never reach a new loop 1% to 9% slower on an EPYC 7763 in every job, and as slow after the loop was moved out of the function that holds theirs | that function was compiled anew around the loop's call, and stands elsewhere: a null build, the same function with the new loop's work undone, moved the same rows as far | pair a null build before chasing a cost in code the slowed rows do not run; it prices the rows as placement, and does not tell the function's new form from its new place (decision 20, amended 2026-10-04; design §8 step 18) |
| two string rows 9% to 23% slower in all four jobs of an EPYC 9V45, between two programs with the same stdx code | the baselines' objects differed between the programs, so stdx's functions may have stood elsewhere; single runs on that CPU spread up to 61% | on an EPYC 9V45 read a change from four jobs of one draw and require a row to move in all four; a program that changes a baseline alone prices what the rest moves (design §8 step 18) |

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
