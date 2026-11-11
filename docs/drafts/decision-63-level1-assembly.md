63. **Level 1's parse and its commands run in assembly.** Proposed on 2026-11-06, after the owner
    chose "Assembly hot loop" the same day. It amends decision 16 for one loop, as decision 53
    does for DEFLATE. The bar is decision 62's: on every row and each runner, level 1 at least as
    fast as Google's quality 1, and no larger.

    **Where level 1 stands, at 7854aa0.** Runs
    [42273631823](https://github.com/c4milo/stdx/actions/runs/42273631823) and
    [42290772548](https://github.com/c4milo/stdx/actions/runs/42290772548):
    - Speed against Google q1, median: 0.83 on the N2, 0.70 on the EPYC 7763. Rows at or above
      Google: 4 of 39 on the N2 (E.coli, shuffled dickens-1m, kennedy.xls, sao), 2 on the 7763.
    - Size: every row smaller than Google's but shuffled dickens-1m, at 0.9996 of its ratio.

    **What the N2's counters say,** per input octet:

    | Row | stdx cycles | Google cycles | stdx instructions | Google instructions | stdx misses a KiB | Google misses a KiB |
    |---|---|---|---|---|---|---|
    | dickens | 23.44 | 17.80 | 51.94 | 30.10 | 409 | 264 |
    | x-ray | 14.54 | 13.89 | 43.27 | 21.01 | 93 | 13 |
    | mozilla | 14.21 | 12.85 | 38.53 | 24.98 | 219 | 154 |
    | html-1m | 11.31 | 8.79 | 26.20 | 15.08 | 233 | 150 |
    | html-1kx1024 | 41.02 | 32.13 | 112.15 | 62.34 | 712 | 883 |

    stdx runs 1.5 to 2 times Google's instructions at 2.2 to 3.0 instructions a cycle, against
    Google's 1.5 to 2.0. Text rows also miss 1.5 times as many branches. A fit over the rows gives
    about a quarter cycle an instruction and 25 cycles a miss on the N2.

    **Where the instructions go,** callgrind on aarch64, per input octet:

    | Row | Total | Parse | Command records | Writer | Prefix codes and their descriptions |
    |---|---|---|---|---|---|
    | dickens | 51.9 | 22.1 | 12.2 | 10.5 | under 2 |
    | x-ray | 43.3 | 17.7 | 8.3 | 10.8 | under 2 |
    | html-1m | 26.2 | 9.6 | 6.4 | 4.9 | about 2 |
    | html-1kx1024 | 111.4 | 19.9 | 6.1 | 7.3 | about 66 |

    **Why Zig stops here.**
    - f070f02's loop of its own and a writer in registers gained 8.6% to 10.8% at the median.
    - 3f85319 cut 1.7% to 11% of the instructions on aarch64. On the N2, x-ray ran 9% faster but
      dickens did not move; on x86-64, LLVM made the command record a call, which 7854aa0 undid.
      Together: 1.012 on the N2 and 0.994 on the EPYC 7763 at the median.
    - Forms that lost or gave nothing: a backward compare of 8 octets at once (0.96 on both
      runners), the store after every put (0.996 and 0.964), a vector test of the last distances,
      short paths in `match_len` and `insert`, literals counted a probe at a time.
    - Each Zig form moves LLVM's choices of inlining and registers on one architecture or the
      other, so a cut on aarch64 can lose on x86-64.

    **What the assembly can give, and what it cannot.**
    - A probe that misses takes about 40 instructions in LLVM's code, and a command about 230
      over the parse, the record and the writer. Decision 53's loop cut 11% to 17% of DEFLATE
      level 6's instructions. At a cut of 25% of the loop's 45 instructions on dickens, the fit
      gives about 20.6 cycles an octet: 0.86 of Google's speed, from 0.76.
    - The loop alone does not reach the bar on text rows. Their branch misses cost about 3.5
      cycles an octet over Google's. The assembly can lay its branches out by hand, but the
      gain from that is not known before it is measured.
    - The 1 KiB and 16 KiB rows spend most of their instructions on the prefix codes: building
      three codes a meta-block and writing their descriptions. That is Zig work outside this
      loop, and the next entry's subject.

    **The rule.**
    - The loop is `parse_range` in `encoder_parse.zig` with `find`, `extend`, `insert`, the
      commands' `takes` and `add`, and the record's symbol and counts, inline. aarch64 first,
      then x86-64, each in its own file. The Zig loop stays the reference and the fallback.
    - It does what the Zig loop does, in the same order of effect, and writes the same commands
      and counts: the same octets out.
    - Its caller computes the bounds once a call: the block's end, the search's end and the room
      of the commands. Its loads read only the window below the block's end and its padding, the
      two tables and the symbol tables; its stores write only the two tables, the commands below
      their room, the three count arrays and the last distances.
    - `parse` calls it where a comptime test holds: the target, a `builtin.zig_backend` of
      `stage2_llvm`, level 1. Elsewhere it runs the Zig loop, so `test-self-hosted` runs that.
    - The template takes every limit, offset and table from `constants.zig` and the types'
      layouts, and comptime asserts pin each one. Each loop stops at a named bound.
    - Decision 17 holds: no assertion inside the assembly. The caller asserts the bounds at entry
      and, at exit, that the position moved forward to the block's end and the count is within the
      room.

    **The checks.** As decision 53's: an equality test of both loops on copies of one matcher and
    one block, over seeded windows, each exit and branch reached; a fuzz test; the recorded hashes
    of differential-brotli-encode in ReleaseSafe and Debug; the mutations of each compare;
    `test-self-hosted` and `test-avx512`.

    **The measurement that admits it.** Under decision 20, pairs against the branch's base on
    each runner: the median faster past 2%, and no row slower past the larger of its spread and 1%
    in both jobs, unless decision 20's placement amendments exempt it. The M1 times it row by row
    before the owner rules on landing.

    **What the aarch64 loop gave.** At 4697958 against 501dbd9 (run
    [42316480328](https://github.com/c4milo/stdx/actions/runs/42316480328)):
    - Neoverse N2: 1.083 at the median, every row faster, from 1.024 (html-1kx1024) to 1.139
      (dickens). Against Google q1, 0.957 at the median, from 0.886; 18 rows at or above it, from
      13. The first form (4b2f59e, run 42306488899) gave 1.066.
    - The x86-64 job, an EPYC 9V74, runs the Zig loop: every row within 1.3%.
    - Callgrind, aarch64, instructions an octet: alice29 48.24 to 43.38, dickens 51.54 to 46.13,
      x-ray 42.91 to 39.63.
    - Output: every stream's octets are 501dbd9's; differential-brotli-encode passes with the
      recorded hashes in ReleaseSafe and Debug.
    - Mutations: 19 CAUGHT, 2 NOT CAUGHT and equivalent (a length's last word read by octets, an
      insert at the tail's own position).
    - Rows still below Google on the N2: ptt5 0.76, sum 0.81, nci 0.84, the text rows 0.87 to
      0.95, html-1m and json-1m 0.89, the 16 KiB rows 0.95.

    **What the x86-64 loop gave.** At 787971f against 501dbd9 (run
    [42331436674](https://github.com/c4milo/stdx/actions/runs/42331436674)):
    - Xeon 8573C: 1.072 at the median, every row faster, from 1.003 (shuffled dickens-1m) to 1.130
      (plrabn12.txt). Against Google q1, 0.779 at the median, from 0.728; 10 rows at or above it.
    - Neoverse N2, the aarch64 loop: 1.083 at the median, every row faster; 0.950 of Google.
    - Callgrind, x86-64, instructions an octet: alice29 62.85 to 52.47, dickens 63.72 to 53.43,
      x-ray 51.11 to 43.78.
    - Mutations, x86-64 under Rosetta: 21 CAUGHT, 1 equivalent.

    **What it risks.** A wrong bound reads or writes outside the encoder's state with no panic.
    The equality test, the fuzz test, the differential check and the mutations stand against it.

    **Amendment: the writer.** Proposed on 2026-11-06, after the owner chose "Writer in assembly"
    the same day. It adds a second loop to this entry: `write_commands` in `encoder_write.zig`,
    which puts each command's symbol and extra bits, its literals and its distance into the
    meta-block's output.

    **Why.** The N2's counters at 787971f (run
    [42336839586](https://github.com/c4milo/stdx/actions/runs/42336839586)): on the rows still
    below Google q1, stdx runs 1.4 to 1.7 times its instructions. Callgrind on dickens gives the
    writer 10.5 instructions an octet on aarch64 and 14.0 on x86-64, where LLVM keeps 53 of its
    388 instructions as loads and stores of spilled registers (34 of 284 on aarch64).

    **The rule.** As for the parse loop, with these differences:
    - The writer's loop runs as assembly, aarch64 then x86-64, each in its own file under
      `encoder/encoder_write/`; the Zig writer stays the reference and the fallback.
    - It writes the octets the Zig writer writes, and leaves the bit buffer, its count and the
      output's position as the Zig writer leaves them.
    - Its caller passes the output's room. The text tests the room once a command and once a chunk
      of 64 literals, as the Zig writer does, and returns to Zig where the room runs out, which
      then writes the meta-block uncompressed.
    - Its loads read only the meta-block's octets, the commands below their count and the three
      codes' arrays; its stores write only the output below its room.
    - The checks: an equality test of both writers over the commands of seeded windows, with
      outputs too short at each command's place; the differential hashes; mutations of each
      compare and each shift.

    **What it risks.** A store past the output's room. The room test before each command and
    each chunk, the equality test with short outputs, and the mutations stand against it.

    **What the writers gave.** At 7adeb2b (the series 8e50d50, 17f3789, dd121ef, 20ef1c9 and its
    last commit) against 787971f, run
    [42356786532](https://github.com/c4milo/stdx/actions/runs/42356786532):
    - Neoverse N2: 1.034 at the median, from 0.996 (E.coli) to 1.094 (kennedy.xls). Against Google
      q1, 0.994 at the median, from 0.957; 19 rows at or above it.
    - EPYC 7763: 1.043 at the median, from 0.976 (cp.html, a repeated 24 KiB file) to 1.107.
      Against Google q1, 0.790, from 0.761.
    - The first aarch64 writer ran shuffled dickens-1m and E.coli 4% to 5% slower at fewer
      instructions; the N2's counters showed fewer instructions a cycle (3.76 to 3.47). A put that
      shifts before it adds, and loads at fixed offsets, as LLVM's loop does, brought them back.
    - Callgrind, instructions an octet: aarch64 dickens 46.13 to about 43, x86-64 dickens 53.43 to
      50.25. Same octets; mutations: aarch64 19 CAUGHT and 3 equivalent, x86-64 14 CAUGHT.

    The alternatives refused:
    - More Zig forms: the last five lost on at least one runner or moved nothing.
    - Fewer probes for speed, with the size margin: removing the last distance cost css-1m 27% of
      its ratio, and a 6-octet short hash took x-ray past Google's size.
