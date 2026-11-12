# Draft: decision 66, level 5's parse

This is a draft entry for `docs/decisions.md`, for the owner to rule on. The owner chose a faster
parse design for level 5 on 2026-11-08, after run 42459556791. A design entry comes before the
code.

## Why

Level 5 must be at least as fast as Google's quality 5 on every row, on each runner. Run
42459556791 measured the split (c853df6) and the dictionary words (ec658f7) against 97650f6:

| Runner | Speed against q5, median | Size against q5, median |
|---|---|---|
| Neoverse N2 | 0.77 before, 0.63 now | 0.970 before, 0.992 now |
| EPYC 7763 | 0.67 before, 0.59 now | 0.970 before, 0.992 now |

The speed was below the bar before the two forms. So the parse needs a new design, not a smaller
cost for each form.

## What the parse costs

Callgrind counted both encoders on aarch64, quality 5 at WBITS 22 and level 5 at ec658f7. These
are instructions per octet of input:

| File | q5 | Level 5 | Level 5 over q5 |
|---|---|---|---|
| alice29.txt | 203 | 241 | 1.19 |
| kennedy.xls | 164 | 332 | 2.02 |
| x-ray | 238 | 304 | 1.28 |

On alice29.txt, q5 mispredicts 1.6 branches an octet and level 5 mispredicts 3.15. At about
15 cycles each, the extra 1.55 misses cost about 23 cycles an octet. That is why level 5 runs at
0.57 of q5's speed on text with only 1.19 times its instructions.

The misses of level 5 on alice29.txt, by line, in misses per octet:

| Line | Misses |
|---|---|
| `consider`: `saves <= 0` | 0.62 |
| `consider`: the held match's last octet | 0.59 |
| `best`: the loop over the bucket's hits | 0.34 |
| `encoder_words.find`: its reference loop and compare | 0.69 |
| `match_len`: the exit of the 8-octet loop | 0.19 |

On kennedy.xls the parse alone takes about 234 instructions per octet. A bucket there holds up to
16 true matches, and `consider` measures each one to its end. `match_len`'s assertion runs on each
call, 13.5 instructions per octet.

## Proposal

Each part below is measured alone against the commit before it, by callgrind counts and by a
runner pair, as decision 20 asks. A part stays only where it moves the rows it aims at and
loses no row.

1. **Weigh the candidates without a branch each.** For each hit of the bucket, compute the agreed
   octets of the first 8 from one XOR and a count of trailing zeros, and the saving from that
   length and the distance, with no branch. Keep the best by a select. Measure past 8 octets only
   for the best, and for a candidate whose first 8 octets all agree. The aim is the 1.5 misses
   per octet of `consider` and the hits loop.
2. **Stop the scan at a long match.** When a candidate agrees on `nice_len` octets, the scan
   stops. An earlier test with `nice_len` 64 cost text 1% to 3% of instructions, and gained
   nothing there. This part aims at kennedy.xls and runs, so its length is measured on them, and
   on text to show text loses nothing.
3. **Search words only where they can win.** Try the dictionary only when the window's best
   match is shorter than a word could be. Hold each bucket's 4-octet keys beside its references,
   so a collision costs one compare of 4 lanes and no read of the dictionary. The aim is the
   0.69 misses per octet of `find`.
4. **Take the assertions out of the inner loops.** Assert the arguments once for each position,
   not once for each candidate. Decision 17 keeps assertions on in production. This part moves
   them; it removes none.
5. **Assembly, last.** As decision 63 did for level 1, write the hot loop in assembly when parts
   1 to 4 stop gaining. That needs an entry of its own.

The split (c853df6) keeps its own cost work: a sampled check that skips literals of one kind,
and no second code build when the gate keeps the split.

## What would show the design wrong

- Part 1 fails if a branch-free weighing costs more instructions than the branches save cycles.
  The runner pair, not the M1, judges that.
- Part 3 fails if any row grows. The word search exists for size.
- If all four parts leave level 5 below 0.9 of q5's speed on text, the parse needs assembly or
  a different finder, and this entry goes back to the owner.

## Alternatives

- **Cut each form's cost alone.** Refused: level 5 was at 0.77 of q5 on the N2 before the forms.
- **Fewer candidates, 8 ways.** Refused for now: the buckets were ruled at 16 ways on
  2026-11-07, and fewer ways lose matches. Measure it only if parts 1 and 2 leave kennedy.xls
  slow.
- **Read q5's source.** Refused: rule 5 of CLAUDE.md. Its binary is profiled by function name
  alone.

## Results of parts 1 to 4 (2026-11-08)

| Part | Result |
|---|---|
| 1, branch-free weighing | Refused by its pair, run 42488693259: N2 0.931, EPYC 0.938. Its N2 profile, run 42493740257, halves the real misses (dickens 2.79 to 1.56 an octet) but adds 30 to 70 instructions an octet. |
| 2, `nice_len` | No effect at 16, 24 and 32. kennedy.xls's cost is many real short candidates, not long ones. |
| 3, gated word search | Not built yet. |
| 4, assertions once a position | Landed as 728a244: N2 1.008, EPYC 1.005 (run 42494076157). |

## Part 5, the candidate loop in assembly

The owner chose this part on 2026-11-08. Part 1's idea is right, and its Zig form is too heavy: LLVM
spills the pick to the stack and turns selects into branches unless they are hidden. A loop
written by hand weighs one hit in about 22 instructions, not part 1's 45 to 60:
- `rbit` and `clz` for the next way;
- the entry's load, and the base's subtraction;
- one compare for the reach, and a `csel` to a safe candidate;
- the 8-octet load, `eor`, `rbit`, `clz` and a shift for the agreed octets;
- a `csel` for the length;
- `clz` of the offset for its extra bits;
- `madd` for the saving;
- a compare, two `csel`, and the store and `cinc` of the long list.

**The choice of match, the same on every host (invariant 5).** The assembly and a Zig reference
make one choice. The reference runs on any CPU without the assembly, and the tests hold the two
equal:
1. Each last distance whose first 4 octets agree, then each of the bucket's hits, the lowest way
   first, is weighed by the octets it agrees on within the first 8. Fewer than 4 weigh nothing.
2. The best saving wins, and the first of equal savings stays.
3. Then each candidate that agreed on all 8 octets is measured to its end, the last distances
   first, and wins only by a greater saving.

This changes level 5's output from today's parse, whose filter on the held match's last octet is
not a choice by saving. On alice29.txt it gives 52,702 octets against 52,733.

**x86-64 until its own loop.** The reference is plain Zig with branches, and x86-64 runs it. Its
speed there is measured in the pair; an x86-64 loop follows, as decision 54 did for DEFLATE.

**The checks,** as decision 63's: the assembly against the reference over seeded windows and
buckets, mutations of the template, the Rosetta and self-hosted tests, and pairs on both runners.

**Alternatives.**
- Keep today's choice in the assembly: it needs a branch for each candidate, which is the cost.
- Vector weighing of 16 hits at once: NEON has no gather, so 16 scalar loads remain.

## Results since part 5 (2026-11-10)

Each pair is read against quality 5 in the same job, as `ab5c.py` reads it: a raw ratio between
two programs of one job also carries the machine's drift, up to 10% on the EPYC.

| Commit | Change | N2 | x86-64 |
|---|---|---|---|
| 14b0ae5 | Words only where the window has no match | 1.069 | 1.031 |
| 2635a9e, 5feb5ee | Lazy margin of 48 eighths at a last distance | 0.997, 0.993 | 1.009, 1.007 |
| e5b6292 | Lazy probe: only candidates that can save more | 1.125 | 1.145 |
| 55e71d5 | aarch64 loop takes its values in registers | 1.011 | no x86-64 change |

Level 5's speed against quality 5, median of 39 rows: 0.93 on the N2, 0.86 on the EPYC 9V45. Its
size is 0.992 of quality 5's, with kennedy.xls at 1.076 after the margin.

## What the gap is now

bench-profile at e5b6292 (run 42837966229, N2), per input octet, medians of 39 rows:

| Measure | Quality 5 | Level 5 |
|---|---|---|
| Instructions | 1.00 | 0.97 |
| Instructions a cycle | 2.47 | 2.16 |
| Branch misses | 0.75 | 0.84 |

A cache simulation of the N2's first two levels shows level 5 with fewer misses than quality 5 on
alice29.txt and as many on ptt5. So the gap is neither the count of instructions, nor
mispredicts, nor cache misses: it is instructions that wait on one another. On sao, a row of few
matches, both run at 2.48 instructions a cycle. The rows behind are rows of many matches:

| Row | Cycles over quality 5 | Instructions over quality 5 |
|---|---|---|
| kennedy.xls | 1.54 | 1.34 |
| ptt5 | 1.34 | 1.11 |
| nci | 1.32 | 1.17 |
| json-1m | 1.32 | 1.07 |
| webster | 1.27 | 1.07 |

## Part 6, the position loop in assembly

The owner chose this part on 2026-11-08. Each match now runs through Zig functions that pass
their values through memory, and LLVM spills around them:
- `Pick` and its two lists of long candidates, in memory;
- `measure_long`, `match_len` and `saving` for each long candidate;
- the lazy step's `probe`, and a `Found` it returns through memory;
- `step_back`, then `commands.add`;
- the inserts of the positions a match covers: on ptt5 and nci about 14 instructions an octet,
  a hash, a ring slot and three stores each.

The proposal: one aarch64 loop takes a meta-block's positions from the parse's start to its end, as
decision 63's loop does for level 1. It keeps the pick, the long candidates and the held match in
registers. It leaves the text for what stays rare and stays in Zig:
- a dictionary word, searched only where the window has no match;
- a command whose lengths pass the length tables.

It makes the choice the Zig reference makes, octet for octet, and the tests hold the two equal over
seeded windows, as for part 5.

**Order.** Each step is paired alone, and stays only where its pair shows it:
1. The covered inserts and `step_back`, after a match.
2. The long candidates' measure and the saving.
3. The lazy probe.
4. The search of each position, which takes in part 5's hits loop.

**x86-64** keeps the Zig loop with part 5's hits loop until the aarch64 loop is whole, then takes a
port, as decision 54 did for DEFLATE.

**What would show it wrong.** If steps 1 and 2 leave kennedy.xls, ptt5 and nci within 2% of their
cycles today, the wait is not in the match's path, and this part goes back to the owner.

**Alternatives.**
- More Zig forms of the same path: three forms of part 1 showed LLVM turning selects into branches
  and spilling the pick; the Zig reference stays as the checked path.
- The floor-only probe, about 4% faster on text: refused by the owner on 2026-11-10, as it costs
  six rows 0.2% to 0.5% of size.

## The cycle profile (2026-11-10)

Runs [42898076724](https://github.com/c4milo/stdx/actions/runs/42898076724) and
[42900443479](https://github.com/c4milo/stdx/actions/runs/42900443479) sampled level 5 at 55e71d5 and
quality 5 on the N2, by instruction, with `perf record`. `cyclephases.py` sorts each sample into a
phase by its inline frames, and prices the phase in cycles an octet:

| Row | Phase | Level 5 | Quality 5 | Difference |
|---|---|---|---|---|
| ptt5 | Search | 23.79 | 17.10 | 6.69 |
| ptt5 | Covered inserts | 5.99 | 4.31 | 1.68 |
| kennedy.xls | Search | 54.31 | 33.82 | 20.49 |
| kennedy.xls | Covered inserts | 3.80 | 5.11 | -1.31 |
| nci | Search | 29.02 | 20.60 | 8.42 |
| nci | Covered inserts | 7.15 | 7.42 | -0.27 |
| alice29.txt | Search | 68.18 | 57.65 | 10.53 |
| webster | Search | 75.21 | 59.35 | 15.86 |
| json-1m | Search | 31.95 | 19.80 | 12.15 |

The covered inserts cost what quality 5's cost, and the commands and the block cost the same or
less. The gap is the search. In it, the samples land after loads, not after work:
- the first use of a bucket entry, which waits on the load of the bucket's checks;
- the check row's compare;
- the window's octets at a candidate, in the probe's floor and in the measure.

So step 1 of part 6 has little to win: assembly for the covered inserts saves at most one of their
15 instructions an insert, and they do not wait more than quality 5's.

## Part 6's order after the profile (the owner, 2026-11-10)

The owner chose to move part 6 to the search first. Each step keeps the octets, and is paired
alone against the commit before it:
1. A prefetch of the bucket at the hash, so the loads of the checks and of the entries overlap.
   Landed as 3a5db9a. Run 42900276140 against 55e71d5, quality 5 as the control: N2 median +5.2%,
   no row below 0.99; EPYC 7763 +4.2%. Level 5's median speed against quality 5 went from 0.958 to
   1.005 on the N2, and from 0.798 to 0.831 on the EPYC 7763.
2. A compare before each long candidate's measure: when a match as long as the best's saves no
   more at the candidate's distance, 8 octets that differ up to that length skip the measure.
   Landed as fc3a732. Run 42918251005 against 3a5db9a: kennedy.xls +4.3% on the N2 and +1.4% on
   the EPYC 9V74, read raw; the medians flat. Forms that compare only after a best of 16 or 32
   octets lost kennedy's gain (runs 42925474212 and 42925480391).
3. A prefetch of the next position's bucket from the search and the probe, and of the bucket at a
   match's end before its inserts. Landed as eb5a8c5. Run 42925745497 against 3a5db9a: N2 median
   +4.3%, Xeon 8573C +0.5%; grammar.lsp and xargs.1, of 4 KiB, below 0.99.
4. The first search's hits: a second profile (run 42921781675, at 1440c0f) and quality 5's search
   split by call site show the lazy probe costs what quality 5's lazy search costs. What is left
   is the first search at each position, about 8 cycles an octet more on kennedy.xls and 2 on
   ptt5, nci and json-1m. The hits loop weighs each hit in full, where quality 5 first compares
   the octet at its best length.

The covered inserts and `step_back` stay in Zig: they cost what quality 5's inserts cost.

### The single pass, refuted (2026-11-11)

The owner approved a prototype of quality 5's form: one pass, each long hit measured as it is
weighed, after a compare at the best length, the newest hit first. It ran in Zig, without part
5's assembly loop. Sizes against eb5a8c5: 32 of 38 rows smaller, by up to 0.17%; sum 0.34%
larger. Pairs against eb5a8c5, quality 5 as the control:
- newest first, run 42952829398: N2 median -4.2%, Xeon 8573C -0.9%;
- way order, run 42952832203: N2 -3.9%, EPYC 9V74 -3.1%.

The text rows lost up to 13% without the assembly loop. kennedy.xls lost 3.1% on the N2 with 3%
fewer instructions. So the two passes are not kennedy's gap, and assembly for one pass would not
close it.

### One pass, best length first (2026-11-11)

The owner then ruled the form quality 5 searches with: compare at the best length before a hit's
first octets are read. It landed with an assembly loop for each architecture:
- The hits go newest first. A hit refused by the compare at the best length costs one read.
- A hit that agrees on all 8 octets goes back to Zig, which measures it to its end and enters the
  loop again with the hits left.
- The compare refuses only a candidate that cannot save more. A best that a shorter match took
  since saves more, so the loop keeps the old compare.
- On aarch64 the values stay in registers. A search with no compare set runs a loop without the
  compare's three registers. The hits form a mask of 4 bits a way, which one `ror` orders.
- On x86-64 the values stay in memory, as part 5's loop kept them. `bsr` and `btr` take the
  newest hit, and the compare starts at a least distance.
- The bench begins each round with `start`, so most hits are the last round's entries. For a
  stream's first 256 KiB (`reach_compare_len`), one compare of the bucket's 16 entries against
  the reach drops them before the loop.

Sizes against eb5a8c5: 32 of 38 rows smaller, by up to 0.17%; 5 rows larger, sum by 0.34%, nci
by 0.06%, xml by 0.05%, ptt5 by 0.02% and json-1k by 0.01%; 0.02% smaller in all. The choice
changes where two candidates save the same, as the order of the hits changed.

Pairs against eb5a8c5, read raw, quality 5's column as the control:

| Run | Commit | N2 median | x86-64 | x86-64 median | Rows below 0.99 |
|---|---|---|---|---|---|
| 42997706787 | 3fd81e2 | +8.6% | EPYC 7763 (Zig loop) | +8.9% | N2 mr 0.988; 7763 none |
| 42998542892 | f6f63f1 | +6.1% | EPYC 7763 | +9.7% | N2 cp.html 0.988; 7763 none |
| 43007061251 | f6f63f1 | +7.8% | EPYC 9V74 | +5.5% | 9V74 E.coli 0.960, mr 0.961, sao 0.984, x-ray 0.989 |
| 43007073325 | f6f63f1 | +7.8% | EPYC 7763 | +9.3% | 7763 E.coli 0.982 |

kennedy.xls gains 20% on the N2 and 23% on the EPYC 7763; the HTTP bodies of 1 KiB and 16 KiB
gain 8% to 15% on the N2 and 16% to 21% on the EPYC 7763.

Forms that failed, each paired against eb5a8c5:
- The first assembly loop, 4 instructions a hit more than part 5's (run 42977247294): kennedy
  +17%, but 14 text and small rows of the N2 lost 1.6% to 4.5%.
- The compare against the reach on every search (run 42990110547): the small rows gained 7% to
  15%, but x-ray, sao, ooffice and big text lost 2% to 4% on the N2, where the stream's own
  entries hold most ways.
- Without the prefetch of the ring's next way (run 42989676876): the same within the spread. The
  prefetch stays, as every pair above measured it.
- The one-pass Zig loop on x86-64 (runs 42986897610, 42989673058): text rows lost 3% to 5% on the
  EPYC 9V74 and the Xeon 8370C, against part 5's assembly loop.

Mutations, each run against the tests of encoder_lazy_test.zig and encoder_buckets.zig, all
CAUGHT:
- The aarch64 loop, 7: the range check removed, the compare inverted or always taken, the
  collision check and the measure of 8 agreeing octets removed, the later of equal savings kept,
  and the oldest hit first.
- The x86-64 loop, 6: the same, but the order.
- The Zig wrapper, 4: a short best's length not taken again, a bound one leading zero looser, the
  later of equal savings kept, and a compare set for a best that runs to the end.
- The bucket masks, 2: an entry at the position taken as in reach, and the nibbles shifted 3.
- The compare in `Pick.consider`, fc3a732's 5, against the one-pass reference.

Three needed tests of their own: a near collision of 3 octets and an entry at the position, which
both loops must refuse; the masks at each edge of the reach; and the compare at the stream's end.

### The x86-64 gap (2026-11-11)

The owner chose x86-64's gap to quality 5 next. A sampling run built each encoder for the
baseline CPU and for the runner's, and timed all four over 12 rows (runs 43045086687 and
43049011582, an EPYC 7763 and the N2; the second timed each row at two round counts, since a new
process ran quality 5's first round up to 26% slower than the benchmark does). It showed two things.

**The build's CPU.** The benchmarks built stdx, libdeflate and zlib-ng for the baseline CPU, and
the oracles, Google's brotli among them, for the runner's. On the EPYC 7763 the host build gave
quality 5 a median 5.4%, from 1% to 11% by row, and stdx 1.5%; on the N2 it gave nothing. Level 5
against quality 5 there, at the median of the 12 rows: 0.881 as built, 0.923 with both at
baseline. Quality 5's gain is `lzcnt` where it makes its commands: 4.7 ns an octet at baseline and
2.4 with the host's instructions, on plrabn12.txt. The owner ruled on 2026-11-11 that every
baseline library is built for the baseline CPU; a decision of its own records it.

**The search's loop.** With both at baseline, the gap left is the search: dickens 26.5 ns an
octet against 18.7, mr 21.1 against 14.9, webster 18.9 against 13.2. Level 5's other phases cost
less than quality 5's on every row split but x-ray, whose block costs 11.2 against 6.1. Inside
the search, the x86-64 loop cost plrabn12.txt 10.7 ns an octet against 5.1 for the aarch64 loop
on the N2. `bsr` and `bsf` take microcode on AMD cores before Zen 4, and the samples pile up after
each; the `bsr` to `btr` chain that took a hit also held back the next candidate's load.

Landed: the loop takes the newest hit with `rep bsf`, which a CPU with BMI1 runs as `tzcnt` and
any other as `bsf`, and clears it with an `and`. Same octets. Against 554b48a on an EPYC 9V74
(runs 43050555633 and 43060826234): median +7.3% and +4.5% raw, +4.2% and +3.6% with quality 5 as
the control, E.coli +13%, and level 5's median against quality 5 from 0.97 to 1.03. Mutations of
the loop, 7 of 7 CAUGHT.

Refuted: the distance's log2 from a float's exponent, in place of the last `bsr`. Paired alone
against the landed loop, it gave nothing on the CPU it was for: median 1.000 raw and 1.008 with
quality 5 as the control on an EPYC 7763 (run 43073213845), and 0.989 raw and 1.001 on an EPYC
9V74 (run 43073226142). With the landed loop it had run +6.1% against 554b48a on an EPYC 7763 (run
43060838806), so that gain is the landed loop's. The `bsr` that weighs a candidate stays.

### The search on the rows that trail quality 5 (2026-11-12)

A sampling run (43156192035) split the gap on kennedy.xls, ptt5 and json-1m, with both encoders
built for the baseline CPU. The search was most of it, and inside the search the lazy probe cost
about 2.4 ns an octet on kennedy.xls, as much as the first search. The owner chose the probe first.

- Landed (d74ff34): the probe through an assembly loop on each architecture, in way order, each hit
  admitted by `Floor`'s compare and measured in Zig; early in a stream, the reach filter. Same
  octets; callgrind on aarch64: kennedy.xls -4.0%, json-1m -3.7%, alice29.txt -4.0%, ptt5 -1.9%,
  dickens -4.4%. Mutations of both loops: 9 of 9 CAUGHT.
- Refuted: each position's slot kept in the buckets for the next search. On aarch64 it added 6.8
  instructions an octet on kennedy.xls and saved 0.4 in the hash: the check and the two stores,
  and LLVM's code around the buckets, which the parse now wrote through memory.

### kennedy.xls's block (2026-11-12)

After the probe, kennedy.xls's block cost about 1.2 ns an octet more than quality 5's on both CPUs.
Most of that is the literal split: `cheapest` about 0.47 ns an octet, `rebuild_costs` with
`log2_small` about 0.4, and `add_chunk` with `price_counts` about 0.3. The owner chose the block.

- Landed: each type keeps its total, its whole, its whole for a full chunk of 32 literals, and a
  copy of its counts from its last rebuild. A rebuild compares the counts with the copy, 16 at a
  time, and writes the terms of the symbols that differ. `cheapest` prices a literal as its type's
  whole less its term, and only a meta-block's last chunk, which can be shorter, multiplies. A new
  type starts with a copy of zeros, because `clear_group` zeroed its terms and a count of zero has
  a term of zero. Same octets; callgrind on aarch64 against d74ff34: kennedy.xls -3.3%, E.coli
  -2.9%, ptt5 -1.7%, json-1m -1.4%, alice29.txt -0.8%. Mutations: 20 of 21 CAUGHT; the one left
  makes every chunk multiply, which gives the same price.
- Refuted: a mask of the symbols each type's counts changed, marked at each literal (37ee877). It
  cost 5 instructions a literal, more than the rebuild saved where the literals take few symbols.
  Against c3a4a67 (runs 43225303725 and 43225317219), kennedy.xls ran 2.5% and 2.7% faster on the
  N2 and 4.1% faster on an EPYC 7763, but E.coli ran 8.1% and 8.0% slower on the N2.
