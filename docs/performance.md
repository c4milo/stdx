# Performance work

How every performance change in stdx is chosen, made, proved and recorded. CLAUDE.md's Performance
section states the rules; this document is the method behind them, for anyone, person or agent, who
touches a hot path. The discipline is Abseil's, applied to this tree: [the index](https://abseil.io/fast/),
starting with [Performance Hints](https://abseil.io/fast/hints.html). Where a step below follows one
of its episodes, the episode is linked. Decisions 10, 14, 16, 17, 20, 23, 24, 29 and 32 hold the
rulings the method rests on, and [costs.md](costs.md) the prices.

Every change walks six steps, in order: measure the gap, attribute the cost, choose the lever, build
with the hardware in mind, prove it, land it. Skipping one has cost this project days.

## 1. Measure the gap first

Two instruments, with different jobs.

- The M1 Pro is the local filter. `/usr/bin/time -l` reports the instructions a process retired,
  which survive noise and other processes; divide by the repetitions. Its cycles count only when the
  machine runs nothing else: a decode measured beside another harness read 183k cycles, and 110k
  alone. macOS publishes no number (decision 10).
- GitHub's hosted runners are the judge (decision 20). The `bench` workflow's `base` input measures
  the base and the change in one job, on one VM and one CPU; the x86-64 runner draws a different CPU
  each run, so a comparison holds inside a job and never across two runs.
- The rule that admits a change (decision 20, amended 2026-09-28): a file wins or loses when it moves
  past the larger of its own spread and 1% in every job; a change stays when it wins somewhere and no
  file loses. Report the losses first, and the compression of every stream beside its speed.
- A number is the median of five runs with its spread, every candidate interleaved in one harness
  with pinned versions ([#39](https://abseil.io/fast/39), [#75](https://abseil.io/fast/75),
  [#88](https://abseil.io/fast/88)).
- Compare designs per unit of work, not per second ([#7](https://abseil.io/fast/7)): instructions
  per command, per literal, per symbol.

## 2. Attribute the cost

- Profile in three layers: by function, with a PC sampler; by inlined source line, with
  `llvm-symbolizer --inlining` over a dSYM; by instruction, with `llvm-objdump -d` and the sample
  counts. Look where the cost is, not where a tool shines its light
  ([#74](https://abseil.io/fast/74)).
- Split the whole into the parts the code does not split: a harness that decodes into a room of 0
  octets measures a header alone; a counter of commands, literals and words per stream turns totals
  into per-unit costs.
- Compare the baseline part by part: sample its binary by function names (`sample` on macOS) to
  split its time. Never read its source (CLAUDE.md, non-negotiable 5).
- Name the binding resource before cutting anything: instructions, when IPC is high and the
  instruction ratio matches the time ratio; a latency chain, when a cut of instructions measures
  flat (the code-lengths loop: one lookup waiting on the previous symbol's shift); branches, from
  `bench-profile`'s mispredicts per KiB, which the N2 pays 4 ns each; memory, at 130 to 160 ns a
  miss, which needs the counters before anyone believes it ([#53](https://abseil.io/fast/53),
  [#62](https://abseil.io/fast/62)).
- Estimate before building ([#90](https://abseil.io/fast/90)): units times the cost per unit, from
  costs.md, is a change's ceiling. A ceiling under 3% is no branch, unless a ruling asks for it.

## 3. Choose the lever

- Structural costs first: a sort per code, a call per symbol, a libc call per 4-octet copy, a frame
  that spills the loop's registers, an exit from a loop per unit of work. Each names the cost it
  removes ([#72](https://abseil.io/fast/72)).
- One tradeoff at a time ([#79](https://abseil.io/fast/79)): one change per `perf-*` branch,
  measured alone.
- A change that measures flat leaves, however well it reads (CLAUDE.md;
  [#9](https://abseil.io/fast/9)); a claim that does not beat the noise leaves with its code
  (decision 16).
- The routes, in order: the checked path stays the reference; a fast path under decision 16's
  margins; runtime safety off only where a ruling names the loop (decision 16's exception); assembly
  only where the Zig compiler has stopped gaining on the runners, with the decision entry written
  first (decisions 23 and 29) and decision 24's access table in the loop's file.

## 4. Build it with the hardware in mind

**Registers.**

- The loop's state lives in the locals of a `noinline` function of its own; the rare paths live in
  other functions, so the compiler keeps the hot registers for the loop.
- Any function that takes the loop's address is `inline`. An out-of-line callee that takes it puts
  the whole loop in memory: `iterations_max` cost 54% in cycles that way, and the assembly loop's
  wrapper 40% on the all-literal files.
- Read the loop's disassembly: a load or store through `sp` inside it is a spill.
- In assembly, allot every register and write the plan in the file's header. Pack what does not fit
  (two 32-bit distances in one register); spill what a phase does not need to the loop's struct,
  once per phase.

**Branches.**

- Fold two checks into one branch where the hardware offers it (`ccmp`); pick with `csel` instead
  of branching for a minimum or a choice.
- Keep data-dependent branches few and stable within a stream. The N2 pays 4 ns per mispredict, the
  EPYC 6.4; a 1 KiB body's header lost more to mispredicts than to its instructions.
- Align a loop's top to a fetch line (`.p2align 6`).

**Memory.**

- Tables that fit L1: two-level lookups with a root of 1 KiB, entries of 4 octets, the smallest
  integer that holds a value, a pointer array in place of a multiply for a table's address
  ([#83](https://abseil.io/fast/83)).
- The fields one loop touches sit together, hot scalars before tables; an indexed array in place of
  a pointer chain.
- The streams are sequential; leave them to the hardware prefetcher. A back-reference into a large
  window misses, at a cost the format dictates.
- A copy moves 16-octet chunks and overruns into the room the margin holds, in place of an exact
  loop. Where a copy overlaps its source, move a width the distance holds (8 octets for distances 8
  to 15, a fill for 1), so no load waits on the store before it.
- Unaligned 8- and 16-octet loads cost nothing to speak of on both targets. Aligning a table costs
  padding inside a named limit, so it is priced and asked for first.
- No per-octet work across the caller's boundary, and no window write per octet: the window takes a
  call's octets once.

**Batching.**

- One call takes everything the buffers hold; one pass of a loop takes as many units as its margins
  allow.
- Literals go in runs with one bookkeeping per run; a refill loads 8 octets per 7 taken; a copy
  stores two chunks before it looks at its length; a lookup goes out before the refill it can
  overlap ([hints](https://abseil.io/fast/hints.html)).
- A latency chain shortens only with fewer dependent steps, or two chains overlapped; fewer
  instructions do nothing for it.

**Seeing what a profile cannot.** `llvm-mca` over a loop's text gives its dependency chains and its
throughput per iteration ([#99](https://abseil.io/fast/99)); `bench-profile` gives cycles,
instructions and mispredicts per octet on the runners, beside the baseline's.

## 5. Prove it

Every fast path writes the octets the checked path writes, on every input (decision 16). Four
proofs, cheapest first, all before a branch is pushed:

1. A first-differing-octet harness: decode a stream with the change and with the reference (the
   checked path, or the Zig loop for an assembly one), print both outcomes and the first octet that
   differs. Run it on the fixtures and on every kind of body.
2. The module's tests, at every input length and every room, the state moved between calls
   (`zig build test-<module>`).
3. The differential check against the oracle over the corpora, corruptions included
   (`zig build differential-<codec> -Doracles`). It caught a flag bit the tests could not.
4. The fuzzer, a short pass (`tools/fuzz.sh 20K <report> <module>`).

Then prove the tests: break each check the change adds, one at a time, and require a test to fail.
A `NOT CAUGHT` is a missing test, written before the commit. Two masks to expect: a run's last units
decoded by the reference path inside the margin, which hides a fault in the loop's tail; and an
effect a later step overwrites, such as p1 and p2 after a copy.

Check the files that do not share the hot path the change touched: the all-literal streams
(E.coli, the shuffled dickens-1m) for a command loop, the 1 KiB bodies for the header, the largest
windows for copies.

## 6. Land it

- One change per `perf-<codec>-<what>` branch, pushed and benchmarked without asking, and deleted
  once its numbers are recorded.
- The commit body names the cost removed, the M1 numbers, and each mutation's verdict.
- Two paired runs; the comparison inside each job; the runs recorded in design §8 and their
  reports under `bench/results/`; main takes the change only when the rule admits it.
- Never push a performance change unmeasured, and never chain a push after a step that can stop
  halfway.

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
