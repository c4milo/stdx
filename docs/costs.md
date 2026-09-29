# Costs

Every speed claim in decision 14 names the cost it removes, and this table is what the claim is
priced against. Know the order of magnitude before optimizing: a change says which of these it
moves, and by how much.

Design §8 step 2 filled the table with `bench/costs/`, from one run on each of GitHub's hosted Linux
runners (decision 20): [run 36180336051](https://github.com/c4milo/stdx/actions/runs/36180336051), recorded below. macOS publishes no
number (decision 10). Each cell is the median of five runs, with the spread, in nanoseconds, and in
cycles from `perf stat` where the runner exposes the counters.

A hosted runner is a shared virtual machine, so these numbers set orders of magnitude, not exact
prices: a claim is proved by an A/B inside one job, never by comparing a number here with a number
from another run.

## The runs

| Field | x86-64 | aarch64 |
|---|---|---|
| Runner label | `ubuntu-24.04` | `ubuntu-24.04-arm` |
| Image version | 20260920.314.1 | 20260920.129.1 |
| CPU model, from `/proc/cpuinfo` | AMD EPYC 9V74 80-Core Processor | Neoverse-N2 |
| Virtual CPUs | 4 | 4 |
| Kernel | 6.17.0-1022-azure | 6.17.0-1022-azure |
| Zig version and build mode | 0.16.0, ReleaseFast | 0.16.0, ReleaseFast |
| Run URL | [36180336051](https://github.com/c4milo/stdx/actions/runs/36180336051) | [36180336051](https://github.com/c4milo/stdx/actions/runs/36180336051) |
| Date | 2026-09-25 | 2026-09-25 |

## The costs

| Cost | What stdx does that pays it | x86-64, ns | aarch64, ns | Cycles, where available | Spread | Claims priced against it |
|---|---|---|---|---|---|---|
| An L1 hit | A Huffman or FSE table lookup that fits in L1 | 1.36 | 1.18 | not measured | 0.6% / 0.1% | S2, Z1 |
| A cache miss to main memory | A back-reference into history that left the cache; a match-finder probe into a large hash table | 130.90 | 162.90 | not measured | 0.7% / 11.7% | S10, E1 |
| A branch mispredict | The literal-or-match branch per symbol; a data-dependent loop exit | 6.43 | 4.03 | not measured | 7.0% / 4.0% | S2, S3, E2 |
| A predicted branch | A bounds check, an overflow check or an assertion that holds | below resolution | below resolution | not measured | far above 100% | Decision 17 |
| A copy of 64 octets | A match copy of typical length | 1.09 | 1.89 | not measured | 0.1% / 13.3% | S4, Z4 |
| A copy of 32 KiB | The window update at the end of a call; a window clear at the start of a stream | 567.62 | 392.83 | not measured | 0.2% / 5.2% | S5, S6 |
| A 64-bit bit-buffer refill | One unaligned 8-octet load, a shift and an or, and the count of octets taken, with the consume of 7 to 22 bits that follows it | 2.71 | 3.19 | not measured | 2.0% / 0.3% | S1 |
| A 32-octet vector compare | Two 32-octet loads, a compare, and a count of the equal octets before the first difference | 0.62 | 2.35 | not measured | 0.2% / 0.1% | E1, decision 21 |

The spread column gives x86-64 first, then aarch64. Cycles are not measured: the program reads
no performance counter, and whether a hosted runner exposes them is untested.

What the table says for the claims that price against it:

- A predicted branch is below what the loop can resolve on both runners: a spread far above 100% on
  a median near zero. Decision 17's assertion count is priced at zero per predicted branch until a
  finer measurement shows otherwise.
- The 32-octet vector compare costs four times as much on aarch64 as on x86-64. It turns a compare
  into a bit mask, which x86-64 does in one instruction and NEON, 128 bits wide, cannot. A SIMD path
  of decision 21 that uses the idiom must use NEON's own way to reach a mask on aarch64, and prove
  it there, not assume the x86-64 number.
- A mispredict costs about five L1 hits on x86-64 and three on aarch64, so claim S2, which removes
  a data-dependent branch per symbol, is priced at the larger of the two.

## How each row is measured

Each row is a microbenchmark in `bench/costs/costs.zig`, run by `bench/run.sh` on one core
the job pins with `taskset`, with one untimed run first. It is built ReleaseFast: each row measures
one machine operation, and a bounds check in the measured loop would add its own cost to every row.
The library is never built this way (decision 17); this program is a measuring device.

- **An L1 hit.** A chain of dependent loads that cycles through a 16 KiB array in a shuffled order,
  so each load waits for the one before. The time per load.
- **A cache miss to main memory.** The same chain over 1 GiB, one node per 64-octet cache line,
  so almost every load misses every cache level and most miss the TLB too.
- **A branch mispredict.** A loop that branches on a bit from a precomputed random table, against
  the same loop over a table of all zeros. Each side of the branch is a call the compiler cannot
  inline, so it cannot turn the branch into a conditional move. Half the random branches
  mispredict, so the row is twice the difference per iteration.
- **A predicted branch.** The all-zeros loop above, against the same loop with the branch turned
  into arithmetic on the same load. The difference per iteration. It is near zero, and a spread
  far above 100% says the loop cannot resolve it; the row records that rather than a number.
- **A copy of 64 octets and of 32 KiB.** `@memcpy` between two L1-resident buffers, for 64 octets,
  and between two buffers in L2 for 32 KiB. The time per copy.
- **A 64-bit bit-buffer refill.** The refill of decision 14's claim S1, over an L1-resident input,
  followed by a consume of 7 to 22 bits so the refill cannot be removed. The time per refill.
- **A 32-octet vector compare.** Two `@Vector(32, u8)` loads from L1-resident buffers, a compare,
  and the count of trailing equal octets from the compare's bit mask: the inner step of claim E1.
  The time per compare.

## The package cache

The workflows keep `zig-pkg`, the directory where Zig 0.16 keeps this project's packages, as an
entry in GitHub's cache, and each job restores the entry before it builds: three jobs a push to
main, two a benchmark, and three a fuzzed module each night. A job pays for the entry's size in
that restore, and in the save when it keeps a new entry. Each time below is one restore or one save
in one job, from the runs named, so the times set orders of magnitude and are not medians.

| Entry | Octets | Restore, a job | Save, a job that keeps one | Runs |
|---|---|---|---|---|
| The packages, an archive of each and Zig's compiled outputs, kept until 9534130 | 204,815,274 | 2.0 to 5.1 s on Linux, 5.0 to 8.0 s on macOS | 6.2 s | [36565276760](https://github.com/c4milo/stdx/actions/runs/36565276760), [36565282366](https://github.com/c4milo/stdx/actions/runs/36565282366), [36567702696](https://github.com/c4milo/stdx/actions/runs/36567702696), [36571176757](https://github.com/c4milo/stdx/actions/runs/36571176757), [36577140779](https://github.com/c4milo/stdx/actions/runs/36577140779), [36584556859](https://github.com/c4milo/stdx/actions/runs/36584556859) |
| The packages alone, kept from 9534130 on | 88,753,417 | 1.1 to 3.1 s on Linux, 1.8 s on macOS | 2.9 s | [36584556859](https://github.com/c4milo/stdx/actions/runs/36584556859), [36584933603](https://github.com/c4milo/stdx/actions/runs/36584933603) |

What the table says:

- Run [36584556859](https://github.com/c4milo/stdx/actions/runs/36584556859) cut the old entry
  down to the packages alone, so the other 116,061,857 octets were archives and compiled outputs.
  Zig keeps a compressed archive of each package it downloads, which the entry's own compression
  cannot shrink, so the archives took about as many octets as the packages: 94,227,690, in the
  entry that run [36577144676](https://github.com/c4milo/stdx/actions/runs/36577144676) kept
  without them. The compiled outputs took 21,017,868, in the entry that run
  [36580899149](https://github.com/c4milo/stdx/actions/runs/36580899149) kept without either.
- Zig's compiled outputs saved no time the runs show. The old entry held those of the macOS job of
  run [36542471492](https://github.com/c4milo/stdx/actions/runs/36542471492), which no Linux job
  can use. On macOS, `tools/ci.sh` took 882 to 1,351 s in the seven runs that restored them
  (36548236900, 36555993436, 36561133973, 36565285273, 36567702696, 36571176757 and 36572588991),
  and 900 to 1,234 s in the five that did not (36524746680, 36542471492, 36580895157, 36584556859
  and 36584933603).
- When the entry holds every package, the fetch step, `tools/ci.sh`'s fetch check and its package
  prune check each take a second or less.

The sizes are the cache service's, from the `Cache Size` line of a restore. A restore's time runs
from the start of its step to the log line that reports the restore, and covers the download and
the unpacking; a save's time covers the packing and the upload the same way. The times of
`tools/ci.sh` are its step's start and end, from GitHub's jobs API.
