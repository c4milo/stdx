# Costs

Every speed claim in decision 14 names the cost it removes, and this table is what the claim is
priced against. Know the order of magnitude before optimizing: a change says which of these it
moves, and by how much.

Nothing here is measured yet. Design §8 step 2 fills the table with `bench/costs/`, from one run on
each of GitHub's hosted Linux runners (decision 20), and records each run below. macOS publishes no
number (decision 10). Each cell is the median of five runs, with the spread, in nanoseconds, and in
cycles from `perf stat` where the runner exposes the counters.

A hosted runner is a shared virtual machine, so these numbers set orders of magnitude, not exact
prices: a claim is proved by an A/B inside one job, never by comparing a number here with a number
from another run.

## The runs

| Field | x86-64 | aarch64 |
|---|---|---|
| Runner label | `ubuntu-24.04` | `ubuntu-24.04-arm` |
| Image version | | |
| CPU model, from `/proc/cpuinfo` | | |
| Virtual CPUs | | |
| Kernel | | |
| Zig version and build mode | | |
| Run URL | | |
| Date | | |

## The costs

| Cost | What stdx does that pays it | x86-64, ns | aarch64, ns | Cycles, where available | Spread | Claims priced against it |
|---|---|---|---|---|---|---|
| An L1 hit | A Huffman or FSE table lookup that fits in L1 | | | | | S2, Z1 |
| A cache miss to main memory | A back-reference into history that left the cache; a match-finder probe into a large hash table | | | | | S10, E1 |
| A branch mispredict | The literal-or-match branch per symbol; a data-dependent loop exit | | | | | S2, S3, E2 |
| A predicted branch | A bounds check, an overflow check or an assertion that holds | | | | | Decision 17 |
| A copy of 64 octets | A match copy of typical length | | | | | S4, Z4 |
| A copy of 32 KiB | The window update at the end of a call; a window clear at the start of a stream | | | | | S5, S6 |
| A 64-bit bit-buffer refill | One unaligned 8-octet load, a shift and an or, and the count of octets taken, with the consume of 7 to 22 bits that follows it | | | | | S1 |
| A 32-octet vector compare | Two 32-octet loads, a compare, and a count of the equal octets before the first difference | | | | | E1, decision 21 |

## How each row is measured

Each row is a microbenchmark in `bench/costs/costs.zig`, run by `bench/costs/run.sh` on one core
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
