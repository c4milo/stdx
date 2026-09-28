# stdx design

This document holds the module graph, the streaming contract, the named limits and the numbered
build plan. [decisions.md](decisions.md) holds why each choice beat its alternatives, and
[invariants.md](invariants.md) what no change may break. Cite sections by number: "design §8 step
5".

The owner ruled on decisions 11 to 20 on 2026-09-25, so this document states the design as
ruled. Where it depends on a decision, it names the decision. Decision 27, ruled on 2026-09-28,
adds the `json` module.

## 1. Thesis and scope

stdx is compression codecs written from the RFCs, with no heap and no I/O, that a project places
wherever its memory lives and drives from whatever I/O model it has. Version one holds DEFLATE with
its zlib and gzip containers, Zstandard and brotli, each with an encoder and a decoder (decision 1),
in the order decision 13 proposes.

The aim is to match or beat zlib, zlib-ng, libdeflate, libzstd, Google's brotli and Wuffs on the
workloads stdx measures: the corpora of decision 15, measured the way decision 10 fixes. Decision 14
states where stdx expects to win, where to match, and where to lose, and every report shows all
three.

Beside the codecs, stdx holds a JSON encoder and decoder, RFC 8259 and RFC 7464's text sequences,
under the same rules (decision 27).

Out of scope are the items decision 13 lists: RFC 9841's extensions, dictionaries of every kind,
threads, and formats that are not the four HTTP codings, but for JSON (decision 27).

## 2. The formats

- **DEFLATE (RFC 1951).** LZ77 over a 32 KiB window and Huffman coding, in blocks that are stored,
  fixed-coded or dynamically coded (§3.2.3). Bits are packed least significant first (§3.1.1).
- **zlib (RFC 1950).** A two-octet header (CMF, FLG) around a DEFLATE stream, and an Adler-32 of
  the decoded data (§2.2). Every multi-octet number is stored most significant octet first (§2.1). HTTP's `deflate` coding is this format
  (RFC 9110 §8.4.1.2).
- **gzip (RFC 1952).** A series of members (§2.2), each a header with optional fields, a DEFLATE
  stream, and a trailer with the CRC-32 and the length modulo 2^32 of the decoded data (§2.3).
- **Zstandard (RFC 8878, updated by RFC 9659).** A series of frames (§3). A frame is a header, blocks
  of at most 128 KiB (§3.1.1.2.4) that are raw, run-length or compressed, and an optional checksum.
  A compressed block holds Huffman-coded literals and FSE-coded sequences, both read backward
  (§3.1.1.3). For HTTP, a decoder must support a window of 8 MB (RFC 9659 §3).
- **brotli (RFC 7932).** A header with the window size (§9.1), then meta-blocks with up to 256
  prefix codes per category, context modeling for literals (§7), and references into a static
  dictionary of 122,784 octets (Appendix A) with 121 transforms (Appendix B).
- **JSON (RFC 8259, RFC 7464).** A text is whitespace, one value and whitespace (§2): an object, an
  array, a number, a string or a literal name, nested to any depth. It must be UTF-8 (§8.1, RFC 3629),
  and it does not mark its own end. A text sequence puts a record separator before each text and a
  line feed after it (RFC 7464 §2.2).

## 3. Module graph

`build/modules.zig` builds this graph and nothing else, and exports every module by name (decision
6). `tools/lint/module_graph.zig` holds the same table and fails the lint when the two differ, and
`zig build graph-check` shows the compiler refuses an import the table does not give (invariant
14).

| Module | Holds | Imports | RFCs |
|---|---|---|---|
| `codec` | The status, counts and flush modes of every call; the checked reader, writer and bit readers (decision 11) | nothing | none |
| `checksum` | CRC-32, Adler-32, XXH64 | nothing | 1952 §8, 1950 §9, 8878 §3.1.1 |
| `deflate` | Raw DEFLATE, decoder and encoder | `codec` | 1951 |
| `zlib` | The zlib container | `codec`, `checksum`, `deflate` | 1950 |
| `gzip` | The gzip container | `codec`, `checksum`, `deflate` | 1952 |
| `zstd` | Zstandard | `codec`, `checksum` | 8878, 9659 |
| `brotli` | brotli | `codec` | 7932 |
| `json` | JSON's encoder and decoder, and its text sequences (decision 27) | `codec` | 8259, 7464, 3629 |

The wrappers build on `deflate`, and `deflate` never reaches them. No codec reaches another codec,
and none reaches `json`.
No library module receives a package: pepegrillo, the oracles and the corpora are requested by
`build.zig` for `tools/` and `bench/` only, after the point a dependent's build stops.

Outside the library, and never imported by it:

- `tools/`: the lint rules, the complexity scorer, the commit linter, the graph check, the oracle
  bindings and their self-test in `tools/oracle/`, and the corpus tools in `tools/corpus/`. The
  `oracle` module links zlib and Wuffs, and `zig build graph-check` shows `deflate` cannot import
  it.
- `bench/`: the benchmarks; `bench/costs/` measures docs/costs.md.

## 4. The streaming contract

Decision 11 proposes the call. In short, every decoder and encoder is a struct the caller places,
started with `init`, and driven by one call that takes the input the caller has and the room it
has, and returns what it consumed, what it wrote, and one of three statuses. A caller's loop, for
a gzip body that arrives in pieces:

```zig
var decoder: gzip.Decoder = undefined;
gzip.init(&decoder);
while (true) {
    const piece = try receive(); // the caller's I/O, not stdx's
    var input = piece;
    while (true) {
        const progress = try gzip.decode(&decoder, input, room());
        deliver(progress.written); // output[0..written] is decoded data
        input = input[progress.consumed..];
        switch (progress.status) {
            .needs_room => continue,
            .needs_input => break,
            .done => return finish(input), // input holds whatever followed the stream
        }
    }
}
```

The rules the loop relies on are invariants 7, 8 and 11: `needs_input` means all input was taken,
`needs_room` means the output is full, every call makes progress or says why not, and `done` comes
after the checksum.

## 5. What the caller places

Every size is a comptime constant (decision 3), and decision 12 proposes each one. The caller
chooses where the memory lives. Two consequences follow for callers:

- A decoder whose format lets the stream choose the window, Zstandard and brotli, holds the largest
  window its instance accepts. The HTTP instance of the Zstandard decoder holds 8 MiB; the default
  brotli decoder holds 16 MiB. `init` writes no window octet, so a caller that maps the window lazily
  commits only the pages a stream writes.
- A stream that asks for more than the instance holds is refused with `error.WindowTooLarge`.

## 6. Named limits

Each limit is a constant in its module's `constants.zig`, with a doc comment and a comptime assert
where one can pin it. The ones that exist today are fixed by the RFCs:

| Constant | Value | Source |
|---|---|---|
| `deflate.constants.window_len` | 32,768 | RFC 1951 §3.2.5, §3.3 |
| `deflate.constants.match_len_max` | 258 | RFC 1951 §3.2.5 |
| `zstd.constants.http_window_len` | 2^23 | RFC 9659 §3, read as decision 12 proposes |
| `zstd.constants.block_len_max` | 131,072 | RFC 8878 §3.1.1.2.4 |
| `brotli.constants.window_bits_max` | 24 | RFC 7932 §9.1 |
| `brotli.constants.window_len_max` | 2^24 - 16 | RFC 7932 §9.1 |
| `json.constants.depth_max` | 1,024 | RFC 8259 §9 lets a parser limit nesting (decision 27) |

Limits that land with their steps: each fast path's `input_slack` and
`output_slack` (decision 16), the table widths of decision 14, and each encoder level's window and
table sizes (decision 12).

## 7. Checks

Decision 15 proposes the checks: decoders against the oracles over the corpora under seeded
splits, encoders round-tripped through the reference decoders, seeded corruptions judged against
the RFC when oracles disagree, fuzzing with Zig's fuzzer, the worst-case count of invariant 17, and
mutations for every check.

## 8. Build plan

Each step names the check that proves it. **A step with no check is not a step.** Reading the RFC
is not evidence. Every step that adds a check reports its mutations as `CAUGHT` or `NOT CAUGHT`,
and a `NOT CAUGHT` blocks the step. Progress is tracked in the issues at
https://github.com/c4milo/stdx/issues; this section records only what each check printed.

The order after step 8 is decision 13's proposal. If the owner keeps the original order, steps 9
to 12 are reordered and nothing else changes.

- **Step 0: scaffolding.** `build.zig` with the module graph of §3 and every module exported by
  name; the pepegrillo tools configured as colibri configures them in `build/lint.zig`,
  `tools/lint/` and `.githooks/`; the graph check; `CLAUDE.md` and the design set; the RFCs with
  their checksums.
  **Check:** `zig build lint` and `zig build test` pass; the canary tree draws every rule; `zig
  build graph-check` refuses every forbidden import from `src/deflate/` and compiles the control;
  and every mutation of the step's configuration is caught.

  **Check passed, 2026-09-25.** Zig 0.16.0 on macOS 26.6, arm64, pepegrillo `6fcb273`.
  - `zig build test` exits 0. The complexity score reads 149 functions, the highest at 11 against
    the limit of 15. The twelve `tools/lint` rules run clean over `build.zig`, `CLAUDE.md`,
    `README.md`, `build/`, `src/`, `tools/` and `docs/`, and the canary run draws all twelve.
  - `zig build graph-check` prints the control line and six refusals: `checksum`, `zlib`, `gzip`,
    `zstd`, `brotli` and `pepegrillo`.
  - `shasum -a 256 -c docs/rfcs/SHA256SUMS` passes for all seven RFCs, and RFC 1950, 1951 and 1952
    have the sums colibri recorded.
  - 29 mutations, each applied, run against the narrowest step that can catch it, and reverted.
    All 29 CAUGHT:
    - heap: `std.heap` dropped from the forbidden prefixes; the `Allocator` parameter check dropped;
    - io: `std.debug.print` dropped; `std.os` dropped;
    - determinism: `std.crypto.random` dropped;
    - global-state: the scope moved off `src/`;
    - denied-words: `h11` dropped; its own list no longer excluded;
    - module-graph: zstd's `checksum` edge dropped from the table; absent edges never reported;
      the check's list never compared;
    - `build/modules.zig`: `deflate` given `checksum`, caught by the lint in `zig build test`;
    - graph check: `zstd` dropped from the forbidden list; `checksum` added to `deflate`'s import
      set, caught when the fixture compiled;
    - rfc-citation: `WindowTooLarge` made operational; a citation above the statement ignored;
    - canary: the consumer's name removed, caught by `zig build lint`; the global-state rule
      unregistered from the driver, caught the same way;
    - commit lint: scopes admit digits; the `oracle` scope dropped;
    - markdown: a fence's language not required;
    - file-length: `bench/` left out;
    - magic-numbers: `constants.zig` read;
    - unbounded-loop: length reads not checked;
    - hook: `.githooks/pre-push` edited, caught by `zig build hook-check`;
    - constants: `deflate.constants.window_len` at 32,767; `zstd.constants.http_window_len` at
      8,000,000; `zstd.constants.block_len_max` at 16 MiB; `brotli.constants.window_bits_max` at
      23. Each fails its module's comptime assert.

- **Step 1: the decision records, ruled.** The owner rules on decisions 11 to 18.
  **Check:** each of those entries carries the owner's ruling and date in place of **owner**, and
  this document, invariants.md and CLAUDE.md agree with the rulings. *No code.*

  **Check passed, 2026-09-25.** The owner reviewed decisions 11 to 18 one by one and accepted each
  proposal. The review changed two things and added one: the HTML payload is the WHATWG HTML
  Standard, whose size allows a 1 MiB cut; the four proposed oracles are ruled in; decision 19
  adds CI; and decision 20 runs costs, benchmarks and fuzzing on GitHub's hosted Linux runners. Every document that said a decision was pending was changed in the same commit, and
  `zig build test` passed after it.

- **Step 2: oracles, corpora, costs and CI.** zlib and Wuffs as lazy packages pinned by hash, built
  in `tools/` and `bench/` only (decision 8), the others joining at the steps that use them;
  Silesia, Canterbury and the HTTP payloads as lazy packages pinned by hash, with the tool that
  cuts the 1 KiB, 16 KiB and 1 MiB pieces (decision 15);
  `bench/costs/` (docs/costs.md); `tools/ci.sh` and the workflow of decision 19; and the costs
  job on the hosted runners of decision 20. The fuzzing job lands with step 3, which writes the
  first code there is to fuzz.
  **Check:**
  - `zig build oracle-selftest`: zlib and Wuffs decode every stream zlib encodes from the corpora,
    at every level and strategy in all three containers, to the same octets. Two oracles that
    disagree on valid input would make every later verdict meaningless.
  - The graph check forbids `deflate` the oracle modules too.
  - `docs/costs.md` is filled from one named run on each runner of decision 20, with the run
    recorded.
  - The workflow's first run passes, and its report matches a run of `tools/ci.sh` by hand.

  **Check passed, 2026-09-25**, on GitHub's hosted runners of decision 20, `ubuntu-24.04` (AMD EPYC
  9V74) and `ubuntu-24.04-arm` (Neoverse-N2), and by hand on macOS 26.6 arm64. zlib 1.3.2 and
  Wuffs `wuffs-v0.4.c` at `google/wuffs-mirror-release-c` commit `7411f48`.
  - `zig build oracle-selftest -Doracles`, in CI run
    [36179844058](https://github.com/c4milo/stdx/actions/runs/36179844058) on both runners and by
    hand: `oracle-selftest: 38 files, 5745 streams, 4089798186 octets decoded twice each, 0 failed`.
    The 38 files are Silesia's 12, Canterbury's 11 and its large corpus's 3, and the 12 HTTP pieces.
    It took 152 s on aarch64 and 180 s on x86-64.
  - `zig build graph-check` prints the control line and seven refusals, the oracle bindings among
    them.
  - docs/costs.md is filled from costs run
    [36180336051](https://github.com/c4milo/stdx/actions/runs/36180336051), with each runner
    recorded.
  - The workflow's first run, [36179116730](https://github.com/c4milo/stdx/actions/runs/36179116730),
    failed on two defects the step introduced: the new packages were not lazy, so plain `zig build
    test` fetched 260 MB; and Zig 0.16 on Linux does not create its cache's `tmp` directory before
    it fetches a zip, which Silesia is. An Ubuntu 24.04 container reproduced the second and
    confirmed the fix, now in `tools/install_zig.sh`. The same container showed a corpus host
    dropping a connection once, so `tools/ci.sh` fetches every package first, with three attempts.
    The second run passed, and its report lists the checks a run of `tools/ci.sh` by hand passed.
  - The first costs run lost its run record: Zig 0.16's file writer is positional, so the table was
    written over the header `bench/costs/run.sh` had put in the same file. `costs` now writes
    stdout as a stream.
  - Two rulings changed while the step ran: the owner chose GitHub's hosted runners (decision 20)
    and SIMD wherever it measurably helps (decision 21). The step's sources differ from decision
    15's words in two places: three.js now splits into `three.core.js` and `three.module.js`, and
    the pair a page loads is used; and no CLDR file reaches 1 MiB, so cldr-core's supplemental JSON
    files are joined in path order.
  - 18 mutations of the step's checks, all CAUGHT in the end:
    - the bindings: gzip passed to zlib as zlib; Wuffs decoding raw DEFLATE as zlib; zlib's data
      error read as success; Wuffs's full output read as a cut input;
    - the self-test: the octets written ignored; a differing octet ignored; Wuffs never called; the
      matrix down to the default strategy; long files never run whole; a corpus set of the wrong
      length accepted, NOT CAUGHT at first, since a set with one name added slipped through, and
      caught once that test was written; a corpus file dropped from the build;
    - the cut tool: the 1 MiB piece cut at 1,000,000 octets; an octet skipped between repeats;
    - the fetch script: the hash never compared; a refused download left behind;
    - the graph check: the oracle dropped from the forbidden list;
    - the costs: the median taken as the fastest run; each chain node linked two ahead. A first
      mutation there, a plain shuffle for Sattolo's, survived because the chain is one cycle for
      any shuffle; the comment that claimed otherwise was wrong and was corrected.
  - `tools/ci.sh`'s own failure path was checked by hand: an unformatted file made it exit 1 and
    report the format check as FAIL.
  - The fuzzing job moved to step 3, which writes the first code there is to fuzz.

- **Step 3: `codec`.** The status, counts and flush modes; the checked reader and writer; the
  least-significant-bit-first bit reader of RFC 1951 §3.1.1 with its checked refill; the seeded
  split driver every codec's tests use; the `input-index` lint rule of decision 16; and the
  fuzzing workflow of decision 20, with the bit reader as its first target.
  **Check:** unit tests for every refusal of the reader and writer; the split driver's schedules
  replay from their seed; the new lint rule's fixtures and its canary line; the fuzzing workflow's
  first run on both runners, with its length and findings recorded; mutations.

  **Check passed, 2026-09-25.** Zig 0.16.0 on macOS 26.6 arm64 by hand, and on both hosted runners.
  - `zig build test` passes, and `zig build test-codec` runs 25 tests. Among them, the bit reader
    reads every width of 2,000 seeded cases as a bit-by-bit reference reads it, under a seeded
    split, with the state's bits carried between calls and unused octets handed back; and the
    split driver decodes a toy codec's stream under 500 seeds.
  - The split driver replays a seed's schedule exactly, draws every piece kind, and gives
    SplitMix64's published values for seed 0.
  - `input-index` joins the lint: 6 fixture tests, and the canary tree draws it.
  - The fuzz workflow's first run,
    [36182962073](https://github.com/c4milo/stdx/actions/runs/36182962073): 2,000,038 runs on
    aarch64 and 2,000,034 on x86-64 of the bit reader's fuzz test, no failure, in about 95 s each.
    CI run [36182947786](https://github.com/c4milo/stdx/actions/runs/36182947786) passed on both
    runners with the new short fuzz pass of 20,000 runs.
  - Zig 0.16.0's test runner does not compile in fuzz mode in Debug, so `tools/fuzz.sh` builds
    ReleaseSafe.
  - Two findings changed the code:
    - Invariant 8 follows from invariant 7. A test for its separate violation found no input that
      reaches it, and the dead case was removed.
    - The split driver moved the state too rarely to catch a state that points into itself: 46
      of 100 seeds at one move in eight calls. It now always moves before the second call, and
      77 of 100 seeds of the toy with that defect fail; the test pins the exact count. The rest
      finish in one call, or read the header only after that move.
  - 20 mutations, all CAUGHT:
    - the reader reading past its end in `take` and in `read_octet`; the writer writing past its
      end in `write_all`, and `write_partial` writing all of its input;
    - the bit reader counting an octet as 7 bits, `align_to_octet` dropping nothing,
      `unread_whole_octets` handing back an earlier call's octets, and its mask one bit too wide;
    - the split driver cutting a piece longer than what is left, ending on `needs_input` with
      input left, not overwriting a moved state's old slot, not forcing the move before the
      second call, and a changed generator increment;
    - `violation` allowing `needs_input` with input left, and `overlap` reading adjacent slices as
      overlapping;
    - `input-index` not following `BitReader`, reading the bit reader's own file, and reading a
      slice's length as input-derived; the canary losing its input-index line; `tools/fuzz.sh`
      losing `codec` from its list.

- **Step 4: `checksum`, CRC-32 and Adler-32.** From RFC 1952 §8 and RFC 1950 §9.
  **Check:** equal to the sample code in those appendices, compiled in `tools/` as an oracle, and to
  zlib's `crc32` and `adler32`, over the corpora at every length from 0 to 4096 and at seeded
  offsets and splits; the vector paths of decision 14's claim S9 equal the table path under the
  fuzzer; mutations. The throughput against every ruled baseline goes into this entry.

  **Check passed, 2026-09-26.** Zig 0.16.0 on macOS 26.6 arm64 by hand, and on both hosted runners.
  - The paths. CRC-32: slice-by-8 tables; carry-less folding with PCLMULQDQ over 4 lanes, and with
    VPCLMULQDQ over 256-bit and 512-bit registers; PMULL over 8 lanes beside three chains of Arm's
    CRC32 instructions; and those instructions alone. Adler-32: the scalar path with RFC 1950
    §8.2's deferred reduction, a vector path of 16-bit columns on every target, and dot products
    by UDOT, VPMADDUBSW and VPDPBUSD. Each SIMD path is an object of one of seven feature levels,
    picked at run time by `Crc32Path.fastest` and `Adler32Path.fastest` from
    `codec.Features.detect()` (decision 21, whose last paragraph records what this step found).
  - `zig build differential-checksum -Doracles` passed on both runners in CI run
    [36203101618](https://github.com/c4milo/stdx/actions/runs/36203101618): 2,575,022 values on
    each, 0 failed. Every path this CPU runs equals RFC 1952 §8's update_crc and RFC 1950 §9's
    update_adler32, compiled from the RFCs, and zlib and Wuffs, at every length from 0 to 4096 at
    seeded offsets and starts, and whole under a seeded split. The check builds stdx for the
    baseline CPU, so each SIMD path runs because detection found its instructions, and it fails
    when detection misses a feature Zig's own detection finds on the host.
  - The unit tests hold every path to bit-by-bit references at every length and alignment, under
    splits, over runs of 0xff at RFC 1950 §8.2's bound, and under a fuzz test per check. A
    carry-less multiplication and a dot product written in plain Zig run the folding at every
    register width, and the dot-product path in every object's shape, on any CPU.
  - Where each path ran on hardware: every aarch64 path on the Neoverse N2 runner and an M-series
    Mac; PCLMULQDQ, VPCLMULQDQ and AVX2 on the AMD EPYC 7763 CI runners; AVX-512 and VNNI in
    benchmark runs on an AMD EPYC 9V74, an Intel Xeon 8573C and an Intel Xeon 8370C, which refuse
    to time candidates whose values differ. No CI test run has landed on an AVX-512 runner yet.
  - Throughput: stdx's fastest path over the fastest of zlib, Wuffs, libdeflate and zlib-ng, above
    1 when stdx is faster, from run
    [36203101031](https://github.com/c4milo/stdx/actions/runs/36203101031), whose reports are in
    `bench/results/`:

    | Runner, check | 64 octets | 1 KiB | 16 KiB | 1 MiB |
    |---|---|---|---|---|
    | Neoverse N2, CRC-32 | 0.66 | 1.17 | 1.68 | 1.31 |
    | Neoverse N2, Adler-32 | 0.68 | 0.96 | 1.31 | 1.25 |
    | AMD EPYC 9V74, CRC-32 | 0.68 | 0.85 | 0.99 | 0.99 |
    | AMD EPYC 9V74, Adler-32 | 0.54 | 0.74 | 1.03 | 0.94 |

    Other x86-64 CPUs, from earlier commits: the AMD EPYC 7763 of run
    [36202144918](https://github.com/c4milo/stdx/actions/runs/36202144918), 0.82, 0.98, 0.99 and
    1.00 for CRC-32 and 0.53, 0.83, 1.06 and 1.08 for Adler-32; the Intel Xeon 8370C of run
    [36202696538](https://github.com/c4milo/stdx/actions/runs/36202696538), 0.65, 1.63, 1.11 and
    1.05 for CRC-32, and 0.42, 0.61, 0.98 and 0.73 for Adler-32 before the two sets of VNNI
    accumulators of d273c5c.
  - The losses: every input of 64 octets, and Adler-32 at 1 KiB on x86-64. There the fixed cost of
    a call, its setup, horizontal sums and reduction, is a few nanoseconds against a few
    nanoseconds of work. Short-input code of its own is open work, not part of this step:
    [issue 10](https://github.com/c4milo/stdx/issues/10).
  - Findings that changed the code:
    - Zig's `getauxval` reads a vector only Zig's start code fills, so detection found nothing in a
      program that links libc; it now reads libc's there.
    - ReleaseSafe's check of each vector addition and of each lane's bounds cost more than the
      work. Where a comptime assert proves no lane overflows, the additions wrap, and a folding
      step checks its bounds once.
    - On Intel, PCLMULQDQ's legacy encoding after a write to a YMM register ran at 0.8 GB/s; the
      AVX objects use the VEX encoding.
    - EOR3 made folding slower on the N2 runner and no faster on the Mac, so SHA3 is no level.
    - On the N2 runner every baseline sat near one CRC32X per cycle, and folding alone near 19
      GB/s. Running three CRC32 chains beside the folding, combined by multiplying by x^(8n) mod P,
      reached 1.68 times the best baseline.
    - On the N2 runner at 1 MiB, dot products took Adler-32 from 0.64 of libdeflate to 1.02, and
      weights that count across a whole block, not within each register, from 1.02 to 1.25.
    - The baselines: Zig hands Clang the target's whole feature list, which overrides zlib-ng's
      per-file flags, so each of its SIMD groups is a library built for its own features; and a
      runner with AVX10 cannot compile either library for its own CPU model, so both build for the
      baseline CPU, as the benchmarks build stdx.
  - Mutations are listed in each commit's body. All are CAUGHT but those that change speed alone,
    which no test can see: the registers of a block, the lanes of a short fold, a combined block's
    chain step, a length threshold and one loop that the folding after it covers. Three NOT CAUGHT
    showed a missing test, and each was written: the differential check's offsets, the benchmark's
    doubling batches, and VNNI read from the wrong CPUID bit.

- **Step 5: the DEFLATE decoder, checked path.** Stored, fixed and dynamic blocks (RFC 1951 §3.2),
  through `codec`'s reader and writer alone.
  **Check:** decision 15 against zlib and Wuffs, raw DEFLATE: identical output under seeded splits,
  corruption verdicts with every disagreement recorded, the state copied mid-stream, the
  worst-case count of invariant 17; fuzzing on Linux with the time it ran recorded; mutations.

  **Check passed, 2026-09-26.** Zig 0.16.0 on macOS 26.6 arm64 by hand, and on both hosted runners.
  - The decoder reads stored, fixed and dynamic blocks one step at a time, through
    `codec.BitReader`, `codec.Writer` and `codec.Window`, and reads each length/distance pair whole
    or not at all (047e77f).
  - `zig build differential-deflate -Doracles` passed on both runners in CI run
    [36210615367](https://github.com/c4milo/stdx/actions/runs/36210615367), with the same counts
    on each. 1,923 streams of 552,651,591 octets decode to the same octets through stdx, zlib and
    Wuffs, 0 failed. stdx decodes each under a seeded split that copies the state to another slot
    between calls (invariant 12). The streams are zlib's encodings of each corpus file's first 256
    KiB at every level and strategy, with seeded window bits, memory levels and up to 8 flush
    points of every kind, and of each longer file whole at level 6.
  - The corruptions: 544,582 inputs, each a cut, flipped bits or appended octets in one of seven
    encodings of each file's first 4 KiB, or BTYPE 11, HLIT or HDIST set at its edge. Every verdict
    agrees but four, which `tools/oracle/verdicts.zig` records. They are canterbury/ptt5 streams
    whose HDIST declares 31 or 32 distance codes. RFC 1951 §3.2.7 allows HDIST up to 32, and §3.3
    requires a decoder to accept every conforming stream, so stdx reads on until its input ends;
    zlib and Wuffs refuse at the third octet. The entry matches by the input's shape as well as by
    the verdicts.
  - Invariant 17: test builds count the table entries the decoder touches and the symbols it
    decodes. The bound spreads a dynamic block's table work over the 32 bits the smallest one
    takes: 485 per octet consumed, plus 3,882 per call. Minimal dynamic blocks measure 151 per
    octet, and a block of one-bit literals 11. `zig build test` holds the count exact and within
    the bound, for a stream decoded whole and an octet per call (c175412).
  - Fuzzing: the `fuzz` workflow's run
    [36210625816](https://github.com/c4milo/stdx/actions/runs/36210625816) ran the deflate
    module's split property 2,002,177 times in 108 s on x86-64 and 2,001,726 times in 113 s on
    aarch64, with no failure. `tools/ci.sh` runs 20,000 on every push.
  - Findings that changed the code:
    - A flipped bit in a canterbury-large/E.coli stream: after a distance value that no code
      names, stdx waited for input until fifteen bits were present, where zlib and Wuffs refuse. A
      decode now reports the value invalid as soon as no longer code remains (4511413).
    - The Wuffs binding marked its input closed, so a cut stream counted as refused, not
      incomplete, and 529,965 corruptions disagreed. The binding now leaves its input open, as a
      streaming caller's is.
    - The binding's check that flush points ascend went NOT CAUGHT in C, where a missing check
      reads past the input and fails on the next check anyway. It is now a Zig error that its test
      catches.
  - Mutations are listed in each commit's body, all CAUGHT: 20 in 047e77f, 3 in 4511413, 9 in
    c175412 and 15 in 068927a.

- **Step 6: the zlib and gzip decoders.** RFC 1950 and RFC 1952 around step 5's decoder, with
  multi-member gzip.
  **Check:** as step 5, over all three containers, with the verdict entries for RFC 1950 §2.3 and
  RFC 1952 §2.3.1.2 that decision 15 lists; `done` never before the trailer is checked (invariant
  11); mutations.

  **Check passed, 2026-09-26.** Zig 0.16.0 on macOS 26.6 arm64 by hand, and on both hosted runners.
  - The decoders: zlib (fddeead) and gzip (c3fd932) around step 5's decoder. `codec.Field` reads a
    header or trailer field split anywhere (6e2e5cb). `checksum.Features.from` picks each
    checksum path from the caller's `codec.Features` (bff6c14), and `deflate.limit_window` holds
    a stream to the window CINFO declares (ba7cd14).
  - `zig build differential-deflate -Doracles` passed on both runners in CI run
    [36214438697](https://github.com/c4milo/stdx/actions/runs/36214438697), with the same counts
    on each. Step 5's matrix and corruptions now run over raw DEFLATE, zlib and gzip: 5,769
    streams of 1,657,954,773 octets, 0 failed. The containers' own fields are corrupted too, and
    a rewrite that stays valid must decode. Of 1,659,548 corruptions, 0 failed and 2,690
    disagreements match an entry of `tools/oracle/verdicts.zig`:
    - 2,128: a CRC16 that does not match, which Wuffs skips, as decision 15 foresaw.
    - 541: a CINFO below the window the encoder used. Decision 12 asked step 6 to record the
      oracles' verdicts: zlib and Wuffs both decode the distances past the declared window, and
      stdx refuses them.
    - 14: a CRC32 that does not match, with the input ending before ISIZE. stdx and zlib refuse
      as soon as CRC32 is in, and Wuffs waits for ISIZE.
    - 5: HDIST 31 or 32, now in any block of any container, matched by where stdx stopped.
    - 2: a reserved FLG bit with FEXTRA, which Wuffs skips past before it refuses.
  - Invariant 11: zlib's and gzip's decoders assert at `done` that the trailer matched, and the
    unit tests cut every stream at every octet and flip every trailer octet.
  - Fuzzing: the `fuzz` workflow's run
    [36214438762](https://github.com/c4milo/stdx/actions/runs/36214438762), no failure: zlib's
    split property 2,001,680 times in 80 s on x86-64 and 2,001,123 times in 99 s on aarch64, and
    gzip's 2,000,193 times in 58 s and 2,000,220 times in 79 s.
  - The baseline: the `bench` workflow's run
    [36214460469](https://github.com/c4milo/stdx/actions/runs/36214460469), whose reports are in
    `bench/results/`, times stdx's gzip decoder on its checked path alone. It decodes at 0.10 to
    0.33 of zlib's speed on the AMD EPYC 7763 runner and 0.08 to 0.37 on the Neoverse N2, and at
    0.05 to 0.31 of Wuffs's. Step 7's fast path is priced against it.
  - Findings that changed the code:
    - A corrupted member whose DEFLATE stream ended with fewer than eight octets after it: zlib
      refused the wrong CRC32 as soon as its four octets were in, while stdx waited for ISIZE.
      gzip now compares CRC32 first (2db9fcf).
    - The HDIST entry matched only a first block. A flipped BFINAL made a zlib stream's ADLER32
      read as a dynamic block header with HDIST 31, so entries now match on where stdx's decoder
      stopped, which the differential check reads from its state.
  - Mutations are listed in each commit's body, all CAUGHT: 5 in 6e2e5cb, 1 in bff6c14, 4 in
    ba7cd14, 14 in fddeead, 19 in c3fd932, 2 in 2db9fcf and 16 in 1c396cd. One NOT CAUGHT showed
    a missing test and it was written: nothing copied from past 16 KiB of history until a test
    copied from the whole window.

- **Step 7: the DEFLATE decoder, fast path.** Claims S1 to S8 and S10 of decision 14, each under
  decision 16's rules.
  **Check:**
  - The fast path writes what the checked path writes, under the fuzzer and over the corpora.
  - Each claim's A/B on the Linux runners; a claim that does not beat the noise is removed with its
    code.
  - Decision 17's measurement of the safety checks' cost.
  - The benchmark against zlib, zlib-ng, libdeflate and Wuffs: median of
    five with spread, the losses included.

  **Check passed, 2026-09-26.** Zig 0.16.0 on macOS 26.6 arm64 by hand, and on both hosted
  runners.
  - The fast path: `fast.zig` decodes a block's symbols while decision 16's margins hold, 8 octets
    of input and 274 of output, and a tail loop decodes what the margins leave out (f2373f6,
    225077a). It refills a 64-bit buffer with one 8-octet load (S1), looks each code up in
    `lookup.zig`'s tables of 11 and 8 bits (S2), copies a match 16 or 8 octets at a time (S4), and
    writes into the caller's output, which the window takes once per call (S5). The tables build
    by doubling (d0be894). Commits 656975b to 1e1239f cut the work per match, each with its
    `bench-profile` run on the N2 in its body.
  - Equality: CI run [36251966448](https://github.com/c4milo/stdx/actions/runs/36251966448) passed
    `differential-deflate` on both runners at 6988cf5, with the same counts on each: 5,769
    streams of 1,657,954,773 octets and 1,659,548 corruptions, 0 failed, and 2,690 disagreements
    that step 6's five verdict entries match. The `fuzz` workflow's run
    [36251966069](https://github.com/c4milo/stdx/actions/runs/36251966069) ran deflate's split
    property 2,003,687 times on x86-64 and 2,003,783 on aarch64, and gzip's and zlib's about 2
    million times each, with no failure. The unit
    tests and the fuzzer also decode with each claim off and require the octets that all on
    writes (8e72bb7).
  - Each claim's A/B, from `bench-deflate` run
    [36251111348](https://github.com/c4milo/stdx/actions/runs/36251111348), whose reports are in
    `bench/results/`. The medians are over the 38 corpus files, of the throughput with the claim
    off over the throughput with all on. The counts are the files where on beats off, and off
    beats on, by more than the larger of the two spreads.

    | Claim | Median, N2 | Median, EPYC 7763 | On beats off, N2 and EPYC | Off beats on, N2 and EPYC | Verdict |
    |---|---|---|---|---|---|
    | S1 | 0.84 | 0.82 | 38 and 34 | 0 and 1 | Kept |
    | S2, against tables of 9 and 6 bits | 0.92 | 0.91 | 34 and 35 | 0 and 1 | Kept |
    | S3, in run [36225220197](https://github.com/c4milo/stdx/actions/runs/36225220197) | 1.00 | 1.00 | 6 and 4 | 14 and 10 | Removed (89316d9) |
    | S4 | 0.65 | 0.68 | 38 and 35 | 0 and 1 | Kept |
    | S5 | 0.98 | 0.99 | 25 and 18 | 3 and 1 | Kept |
    | S7, over zlib's fixed strategy | 0.99 | 0.99 | 19 and 25 | 0 and 0 | Kept |
    | S10, in calls of 64 KiB | 0.99 | 1.00 | 26 and 8 | 0 and 2 | Kept: a tie on the EPYC, see decision 14 |

    - S7: zlib at level 6 writes no fixed block for any of the HTTP corpus's bodies, so S7's A/B
      over those streams times nothing. Over zlib's fixed strategy, building the fixed tables for
      each block makes the 1 KiB bodies run at 0.72 to 0.82 of the speed with S7 on the N2, and
      0.62 to 0.75 on the EPYC.
    - S6: on the N2, stdx decodes the 1 KiB bodies at 1.31 to 1.43 of zlib's speed, 1.44 to 1.82
      of libdeflate's, 1.01 to 1.08 of Wuffs's and 0.65 to 0.82 of zlib-ng's. On the EPYC, at
      1.07 to 1.13 of zlib's, 0.99 to 1.14 of libdeflate's, 0.98 to 1.06 of Wuffs's and 0.64 to
      0.83 of zlib-ng's. The libdeflate baseline allocates its decompressor for each stream, which
      is its reset (`bench/baselines/baselines.c`).
    - S8: invariant 17's test holds 48 minimal dynamic blocks at 151.9 units of work per octet
      consumed, within the bound of 1,141, which 093e387 tightened to one write an entry and one
      a code. Tables as wide as their alphabets would write 2,304 entries a block, 195 more per
      octet.
    - S2's count: `bench-profile` run
      [36253767681](https://github.com/c4milo/stdx/actions/runs/36253767681) decodes each corpus
      file's stream with `decode_counting` (69d5d68, d4244bf), with the same counts on both
      runners. Of 68,359,294 symbols, 99.75% take one lookup, 0.25% the canonical code after a
      lookup, and 148 the checked path. The median file takes 99.68% by one lookup, and the
      lowest, the 1 KiB JSON body, 98.16%: its other symbols go to the checked path at the
      input's end, where the margins no longer hold. The count asks for a test build, and no
      test build reads the corpora, so the benchmark counts in its ReleaseSafe build.
    - S9 is step 4's.
    - The candidates, checked on 2026-09-28 after step 16 found its own benchmark's fault. LLVM
      inlines a function by how many callers it has, so a candidate that shares a function with
      other code can compile unlike the rest. Each benchmark was built as the runners build it,
      for each architecture's baseline CPU, and `llvm-nm` and `llvm-objdump` listed what each
      candidate's `run_once` calls out of line. Here the paths A/B's checked candidate took all
      on's claims, so the two shared the functions over the claims that read a block's header,
      copy a stored block and read the code lengths, and LLVM kept those out of line in both,
      where each claim candidate inlined its own. The gzip decoder and S10's decodes reach all
      on's entry through `deflate.decode`, so LLVM kept that entry out of line too. Since 91238df
      the checked candidate turns off S1 and S4, which only the fast path reads, and every
      candidate's entry stays out of line. All on's `run` is then the same size as S1's, S2's
      and S4's on both architectures.
    - Those calls, a few for each block and one for each decode, changed no verdict. Between
      `bench-deflate` runs
      [36440477042](https://github.com/c4milo/stdx/actions/runs/36440477042) at eb0f0c7 and
      [36440501312](https://github.com/c4milo/stdx/actions/runs/36440501312) at 94a5098, every
      candidate's speed on the N2 moves by less than 2% at the median, each claim's median by at
      most 0.03 (S4's, from 0.65 to 0.62), and no file's ratio by more than 0.05. The checked
      candidate runs 1% faster, and the fast path at 11.51 times its speed, from 11.66.
    - On the EPYC 7763, which both runs drew, all on, S2, S5 and S7 ran about 5% faster, and S1,
      S4 and the baselines did not. Those four run one fast loop: LLVM folds their loops into one
      function, whose code the change leaves as it was but whose place in the program it moves.
      So that place, not the fix, most likely moved them. S1's median fell from 0.82 to 0.80 and
      S4's from 0.69 to 0.64 with it: on x86-64, where a claim's loop lands can move its A/B by
      about decision 20's 5% floor.
  - Decision 17: the same program built ReleaseFast runs the fast path at a median of 1.012 of its
    ReleaseSafe speed on the N2 (1.003 to 1.094) and 0.997 on the EPYC (0.981 to 1.067). The
    safety checks cost about 1%.
    - Correction, found in step 11: that program kept stdx's safety checks. Zig 0.16 takes runtime
      safety from the root module for every module a program imports, and the program's root was
      ReleaseSafe, so the run timed ReleaseSafe against itself. The root is ReleaseFast since
      then, and the measurement is owed again.
  - The benchmark, gzip at level 6, in the same run: stdx decodes at a median of 1.53 of zlib's
    speed on the N2 and 1.54 on the EPYC, 0.96 and 0.80 of zlib-ng's, 0.69 and 0.66 of
    libdeflate's, and 1.04 and 1.02 of Wuffs's. Of the 38 files, it is faster than zlib on 38 and
    32, than Wuffs on 29 and 20, than libdeflate on 7 and 3, and than zlib-ng on 7 and 0. The
    fast path runs at a median of 11.68 and 9.29 times the checked path's speed.
  - Findings that changed the code:
    - Timing on the Mac disagreed with the N2 in both directions, so the N2's `bench-profile`
      judged every change. The bodies of 656975b to 1e1239f compare stdx's cycles across jobs.
      As ratios to libdeflate's cycles within each job, as decision 20 asks, each step holds to
      within 0.01 but one: 4a8d599's is 1.003, within the noise, and not the 0.996 its body
      gives.
    - The largest cuts shortened the chain of loads each match waits on, not the instructions.
      Looking the next symbol up before the refill (26b5257) took 6% of the cycles with 2% more
      instructions.
    - Compiled beside the claims' variants, the fast loop called `copy_within` for each match
      instead of inlining it, and stdx fell 9% while no baseline moved (runs
      [36249745834](https://github.com/c4milo/stdx/actions/runs/36249745834) and
      [36250438836](https://github.com/c4milo/stdx/actions/runs/36250438836)). The copies are
      inline now (6988cf5).
    - Measured on the N2 and not kept: the refill's word read where the input margin is checked
      (2.8% more cycles, run [36224683434](https://github.com/c4milo/stdx/actions/runs/36224683434)),
      and a literal's two octets written with no branch (0.999, run
      [36224455737](https://github.com/c4milo/stdx/actions/runs/36224455737)).
    - S4's repeated pattern for distances under 8 is not written: of zlib's level-6 matches, 3%
      of x-ray's and 0.06% of dickens's take such a distance.
  - Mutations are listed in each commit's body. Each NOT CAUGHT is an equivalent mutant, with its
    reason in the body, and each other gap found a test that was then written.

  **[Issue 13](https://github.com/c4milo/stdx/issues/13), checked on 2026-09-28.** The issue asked
  the decoder to beat libdeflate's on the hosted runners: a median above 1.00 of its speed over the
  39 files, gzip at zlib level 6, on x86-64 and on aarch64, with every file where stdx loses named.
  Zig 0.16.0 on macOS 26.6 arm64 by hand, and on the hosted runners.
  - At dac6cd9, run [36478169575](https://github.com/c4milo/stdx/actions/runs/36478169575). The
    x86-64 runner draws AMD or Intel CPUs at random, so the Intel rows come from a temporary
    workflow, on a branch that never lands, whose twelve jobs time decoding on each Intel CPU they
    draw (run [36478163045](https://github.com/c4milo/stdx/actions/runs/36478163045), two
    attempts):

    | Runner | CPU | stdx / libdeflate, median | Faster on |
    |---|---|---|---|
    | ubuntu-24.04-arm | Neoverse-N2 | 1.101 | 26 of 39 |
    | ubuntu-24.04 | AMD EPYC 9V74 | 1.028 | 23 |
    | ubuntu-24.04 | Intel Xeon 6973P-C, three jobs | 1.021, 1.010 and 1.008 | 21, 21 and 20 |
    | ubuntu-24.04 | Intel Xeon Platinum 8573C, two jobs | 1.005 and 1.014 | 21 and 21 |

  - Where stdx loses, below 1.00 of libdeflate's speed:
    - N2: mozilla 0.90, nci 0.90, ooffice 0.91, sao 0.92, osdb 0.94, ptt5 0.94, samba 0.95,
      dickens-1m 0.96, xml 0.99 and html-1m 0.99; json-1m, webster and css-1m round to 1.00.
    - EPYC 9V74: nci 0.89, html-1m 0.90, xml, osdb and json-1m 0.93, mozilla 0.94, samba 0.95,
      html-16k 0.95, sao, js-1m and ooffice 0.96, js-16k 0.97, cp.html and webster 0.98, css-16k
      and world192.txt 0.99.
    - The Intel CPUs, 18 files each in the first attempt's three jobs: the 1 MiB HTTP bodies (css-1m 0.82 to 0.88, html-1m 0.83 to
      0.85, json-1m 0.87 to 0.91, js-1m 0.86 to 0.93), ptt5 0.84 to 0.86, nci 0.84 to 0.89, xml,
      osdb, mozilla, samba, ooffice and sao 0.91 to 0.98, three of the 16 KiB bodies and cp.html
      0.94 to 0.98, and world192.txt, webster or dickens-1m.
  - How it got there, from main at fbcaf44, where stdx ran at 0.66 of libdeflate on an EPYC 7763
    and 0.70 on the N2 (run [36372046166](https://github.com/c4milo/stdx/actions/runs/36372046166)):
    - The Zig loop (590d804 to 040164c): rare symbols out of line, each iteration's input and room
      from its margins, S12, S11, and every length's extra bits from a plain table. It stopped
      gaining at 0.84 and 0.87 (run
      [36380031615](https://github.com/c4milo/stdx/actions/runs/36380031615)).
    - Decision 29, the common loop in assembly: on aarch64 1.03 of libdeflate at once (f1fab96, run
      [36410699223](https://github.com/c4milo/stdx/actions/runs/36410699223)), 1.04 with the
      copies' refinements; on x86-64 0.96 on an EPYC 7763 (70f9e2d) and 0.997 on a 9V74 (2ea5d64,
      run [36440157054](https://github.com/c4milo/stdx/actions/runs/36440157054)), but 0.92 to
      0.98 on Intel CPUs.
    - Codes longer than the table decoded in the assembly, not out of line (f989436): 1.048 on
      the N2, 1.017 on the 9V74, 0.983 on an Intel 8573C (runs
      [36474114480](https://github.com/c4milo/stdx/actions/runs/36474114480) and
      [36474115093](https://github.com/c4milo/stdx/actions/runs/36474115093)).
    - The combination visiting only the pairs it joins (dac6cd9): the table above.
  - Findings:
    - On the Intel CPUs the decoder spent the most outside its loop. At f989436, a cpu-clock
      profile on an 8573C over six files gave stdx, its checksum aside, 2.3% of the samples outside
      the loop, 14% of the loop's own; libdeflate's table build took 0.4%, 2% of its loop's. On
      the M1, one more combination per block cost 2 to 4% of a text decode, and one more table
      build up to 2%: the combination read and branched on each of the table's 2048 entries, in an
      order no predictor follows. Visiting the pairs alone took the Intel medians from 0.95 to
      0.98 up to 1.005 to 1.021.
    - The N2's counters put stdx's branch misses above libdeflate's on every large file, and S11
      made most of them: with it off, stdx missed at most 13% more often than libdeflate, in the
      same job, on all but reymont, mozilla, x-ray, ooffice and sum, 16 to 54% (run
      [36411201317](https://github.com/c4milo/stdx/actions/runs/36411201317)). Sampled by branch
      misses on the hosted N2, the samples land where the cycles' land (run
      [36474987316](https://github.com/c4milo/stdx/actions/runs/36474987316)), so the virtualized
      counters name no branch.
    - Jobs on the same Intel model differ by up to 3% at the median, so an Intel row is one draw,
      and a change is judged on the N2's counters and on the M1 first.
  - Measured and not kept: the Zig code built for x86-64 v3, which gained 1 to 4% on the small
    bodies (run [36424194918](https://github.com/c4milo/stdx/actions/runs/36424194918)); plain
    tables for blocks whose matches mostly would not combine, which removed the misses and none of
    the cycles (runs [36412089015](https://github.com/c4milo/stdx/actions/runs/36412089015) and
    [36412091480](https://github.com/c4milo/stdx/actions/runs/36412091480)); one chunk for a match
    of 16 octets or fewer, and a match's first chunks loaded in halves, both inside the noise on
    the Intel CPUs (run [36463520495](https://github.com/c4milo/stdx/actions/runs/36463520495) and
    the temporary workflow's next); a lookup table for the code length code, 5 to 7% slower on the
    M1's 1 KiB bodies, whose repeated headers the predictor learns, and no faster on the large
    files; and four refinements of the combination, each inside the noise on the M1.
  - Decision 17: the ReleaseFast build runs the fast path at a median of 1.022 of ReleaseSafe's
    speed on the N2 and 1.017 on the 9V74.
  - Mutations are listed in each commit's body. NOT CAUGHT, each changing no output: the check
    that a chunk of the call's output precedes a short distance's target, on both architectures,
    whose removal reads octets before the output that the table lookup then drops, which only a
    guard page would show and no test can place (non-negotiable 1); and in the combination, the
    bound at which no distance code fits and the stop after a code length's lengths, which only
    skip work.

- **Step 8: stdx issue 1 closes.** The whole-buffer helpers of decision 11, and each item of
  https://github.com/c4milo/stdx/issues/1 checked off with its evidence.
  **Check:** issue 1's list, each item pointing at the entry of step 4, 5, 6 or 7 that proves it.
  colibri may then pin the commit (colibri's design §8 step 14).

  **Check passed, 2026-09-26.** Zig 0.16.0 on macOS 26.6 arm64 by hand, and on both hosted
  runners.
  - The whole-buffer helpers of decision 11. `codec.whole` turns a call's progress into a
    `codec.Whole`, or into `error.Truncated` for `needs_input` and `error.NoSpaceLeft` for
    `needs_room` (561a174). `decode_all` makes one call for raw DEFLATE and zlib (c564381,
    6d4136e). For gzip it calls `init` after each member and goes on while input remains, and the
    20 octets of the shortest member bound its loop (ff5b8e1). `encode_all` and
    `encoded_len_max` come with the encoders, from step 9.
  - `differential-deflate` decodes each stream through `decode_all` as well (3a52743), and passed
    on both runners in CI run
    [36255493108](https://github.com/c4milo/stdx/actions/runs/36255493108): 5,769 streams and
    1,659,548 corruptions, 0 failed, and 2,690 disagreements that step 6's verdict entries match.
  - [Issue 1](https://github.com/c4milo/stdx/issues/1)'s list, each item with the entry that
    proves it:
    - stdx, zlib and Wuffs decode the same octets, from zlib's streams at every level and strategy
      in all three containers, stdx in pieces a seed draws: steps 5 and 6, and the run above.
    - Seeded corruptions: stdx refuses every input zlib refuses, but for one shape. A dynamic
      block's header whose HDIST declares 31 or 32 distance codes, which RFC 1951 §3.2.7 allows,
      zlib refuses at once, and stdx reads on (step 5). Where zlib and Wuffs disagree, a verdict
      entry records the RFC section: the CRC16 of FHCRC (RFC 1952 §2.3.1), and a CRC32 or a
      reserved FLG bit that Wuffs reads past (step 6).
    - The throughput against zlib and Wuffs on Linux, and against zlib-ng and libdeflate: step 7.
    - Fuzzing and mutations: every step's entry, and the `fuzz` workflow's run
      [36251966069](https://github.com/c4milo/stdx/actions/runs/36251966069) at 6988cf5.
    - zlib and Wuffs as lazy packages pinned by hash, compiled in `tools/` and `bench/` alone:
      step 2 ([issue 2](https://github.com/c4milo/stdx/issues/2)).
  - Mutations are listed in each commit's body.

- **Step 9: the DEFLATE encoder.** Levels 1, 6 and 9 (decisions 12 and 13), in all three
  containers, with `Flush.flush` and `encoded_len_max`.
  **Check:** decision 15 for encoders: every output decodes to its input through zlib, Wuffs and
  stdx; the output is the same under every split, and its hashes match across hosts and modes
  (invariant 5); `encoded_len_max` holds; the ratio and speed per level against zlib, zlib-ng and
  libdeflate; mutations.

  **Check passed, 2026-09-26.** Zig 0.16.0 on macOS 26.6 arm64 by hand, and on both hosted
  runners.
  - The encoder is `deflate.Encoder(.{ .level = 1 })`, 6 or 9, one type per level (E2), with
    `init`, `encode`, `encode_all` and `encoded_len_max` (1d28c05). zlib's encoder (aec08d6) and
    gzip's (b01b6da) wrap it. `codec` gained the bit writer and the encoders' split driver
    (9232063).
    - A block ends at `block_symbols_max` symbols, before the window slides, at a flush and at the
      end. Its input is then still in the window, so each block takes the cheapest of stored,
      fixed and dynamic, priced to the bit (E3).
    - Level 1 takes the first candidate's match. Levels 6 and 9 try 128 and 4,096 candidates and
      defer each match by one position when the next one finds a longer match. Candidates come
      from a hash of 4 octets, and match lengths from compares of 8 octets (E1).
    - Code lengths come from Huffman's tree, and from package-merge when a length passes the
      limit (10b90db).
    - `init` clears the hash heads, 32 KiB at level 1 and 64 KiB at levels 6 and 9, as the owner's
      amendment of decision 11 on 2026-09-26 allows.
  - Decision 15 for encoders: `differential-encode` (d7b1605) passed on both runners in CI run
    [36262709219](https://github.com/c4milo/stdx/actions/runs/36262709219) at 10b90db: 38 files,
    798 checks, 0 failed. A check encodes a corpus file whole as raw DEFLATE, or its first 256 KiB
    in a container, at one level. The output must fit
    `encoded_len_max`, decode to its input through stdx, zlib and Wuffs, and have the SHA-256
    recorded in `tools/differential/encode_hashes.zig`, which was recorded on macOS in
    ReleaseSafe. The same list held on macOS with `-Dencode-optimize=Debug`, 798 checks, 0 failed.
  - Splits and flushes: seeded flush points and two seeded splits must give the same octets, in
    `differential-encode` and in the fuzz test (03444f0). The fuzz test's short pass ran 41,636
    cases on macOS, and 41,607 and 41,558 on the runners in the CI run above, with no failure.
  - Ratio and speed: bench run
    [36262707708](https://github.com/c4milo/stdx/actions/runs/36262707708) at 10b90db, whose
    reports are `bench/results/2026-09-26-deflate-encoder-*.md`. Each cell is stdx over the
    baseline at the same level: the geometric mean over the 38 corpus files, then the least and
    the greatest. Speed ran on an AMD EPYC 7763 and a Neoverse-N2. The ratios are the same on both
    hosts, as the output is.

    | Level | stdx over | zlib | zlib-ng | libdeflate |
    |---|---|---|---|---|
    | 1 | Speed, x86-64 | 1.04 (0.82 to 1.43) | 0.56 (0.37 to 1.91) | 0.50 (0.32 to 0.76) |
    | 1 | Speed, aarch64 | 1.00 (0.81 to 1.23) | 0.67 (0.41 to 2.65) | 0.47 (0.36 to 0.61) |
    | 1 | Ratio | 0.97 (0.89 to 1.04) | 1.21 (1.06 to 1.51) | 0.91 (0.82 to 0.99) |
    | 6 | Speed, x86-64 | 0.98 (0.51 to 1.56) | 0.51 (0.13 to 1.45) | 0.39 (0.14 to 0.57) |
    | 6 | Speed, aarch64 | 0.89 (0.44 to 1.36) | 0.51 (0.12 to 1.79) | 0.36 (0.16 to 0.48) |
    | 6 | Ratio | 1.01 (0.97 to 1.11) | 1.01 (0.98 to 1.08) | 0.99 (0.93 to 1.02) |
    | 9 | Speed, x86-64 | 1.17 (0.50 to 3.92) | 0.71 (0.16 to 2.61) | 0.58 (0.08 to 1.74) |
    | 9 | Speed, aarch64 | 1.05 (0.45 to 3.88) | 0.70 (0.14 to 2.70) | 0.51 (0.07 to 1.51) |
    | 9 | Ratio | 1.00 (0.97 to 1.03) | 1.00 (0.95 to 1.04) | 0.98 (0.90 to 1.01) |

    - On the four 1 KiB payloads stdx runs at 1.04 and 1.13 of zlib's speed at level 1, and 0.82
      to 0.84 at levels 6 and 9. Before 10b90db, bench run
      [36260140557](https://github.com/c4milo/stdx/actions/runs/36260140557) gave 0.63 to 0.76:
      package-merge ran for every block, and a stream of 1 KiB is one block.
    - stdx loses on speed to zlib-ng and libdeflate at every level. At level 6 it runs at 0.44
      to 0.59 of zlib on kennedy.xls, json-16k and json-1m. The search does not grow there: on
      json-1m level 6 tries 3.1 candidates per input octet, against 2.9 on html-1m and 5.8 on
      dickens's first MiB, counted on macOS. Where the time goes is not measured.
    - Level 1's ratio is 0.889 of zlib's on E.coli, and 0.924 on x-ray and reymont. stdx hashes 4
      octets, so it finds no match of 3, the shortest RFC 1951 §3.2.5 allows. How much of the
      difference that accounts for is not measured.
  - Mutations are listed in each commit's body. One is NOT CAUGHT: `encoded_len_max` without its
    term for the window's slides. A slide adds a block only when a match carries the position past
    the slide's threshold, and the block holding that match then prices below its stored form. A
    seeded search of 180 inputs of 400 KiB, random octets with a match across each threshold, came
    no closer than 13 octets under the bound without the term. The term stays until a proof
    removes it.
  - After the check, level 6 on JSON, 2026-09-26. A profile of level 6 over json-1m, on macOS, put
    48% of the samples in `match_len` and 38% in the search around it. Of the candidates level 6
    tries on json-1m, html-1m, dickens's first MiB and kennedy.xls, 88% to 96% differ from the
    current position at the octet where the match found so far stops, so they cannot win, yet
    each paid a full compare.
    - 533b36a compares the 4 octets that end there before `match_len`, and changes no output.
      Comparing one octet instead slowed E.coli at level 6 to 0.79 of its speed on the N2, in
      bench run [36266160954](https://github.com/c4milo/stdx/actions/runs/36266160954): with four
      letters, a quarter of candidates passed it, and its branch mispredicted. Bench run
      [36267745579](https://github.com/c4milo/stdx/actions/runs/36267745579) on the N2, stdx over
      zlib, the geometric mean over the corpus: level 6 from 0.89 to 1.04, level 9 from 1.05 to
      1.28, level 1 unchanged, and no file slower.
    - 7aa0098 cuts the lazy step's search to a quarter of `candidates_max` once the waiting match is
      8 octets or longer, as the owner ruled on 2026-09-26. The counts below are the encoder's
      decisions, the same on every host.

      | File | Level 6 candidates per octet | Level 6 ratio | Level 9 candidates per octet | Level 9 ratio |
      |---|---|---|---|---|
      | json-1m | 3.10 to 2.01 | 8.464 to 8.433 | 18.18 to 15.91 | 8.660, unchanged |
      | kennedy.xls | 10.67 to 3.98 | 5.106 to 5.078 | 146.36 to 75.12 | 5.117, unchanged |
      | ptt5 | 1.74 to 1.27 | 9.332 to 9.311 | 47.94 to 20.32 | 9.896 to 9.867 |
      | html-1m | 2.94 to 2.35 | 5.939 to 5.936 | 4.50, unchanged | 5.960, unchanged |
      | dickens's first MiB | 5.78 to 5.18 | 2.696 to 2.695 | 7.60, unchanged | 2.700, unchanged |

      Bench run [36267746852](https://github.com/c4milo/stdx/actions/runs/36267746852) on the N2,
      against 10b90db's run: level 6 at 1.15 of zlib from 0.89, level 9 at 1.38 from 1.05, and
      level 6 on json-1m at 0.89 from 0.53, on json-16k at 0.98 from 0.49, on kennedy.xls at 1.23
      from 0.44. Its x86-64 job ran on an EPYC 9V45, not the EPYC 7763 of 10b90db's run, so its
      numbers are not compared. The reports are
      `bench/results/2026-09-26-deflate-encoder-search-*.md`.
    - A review of these two commits found a break of invariant 5 from 1d28c05. A caller that gave
      the octets filling the window with `none`, then flushed or finished in an empty call, got a
      block boundary one call does not make: the empty call slid the window, and a slide ends the
      block. 283fbb8 slides the window only to take more input. The split driver now holds back a
      flush or `finish` to an empty call, and differential-encode's 256 KiB prefixes, which end as
      the window fills, fail without the fix.
  - Open: E4 and E5 are not written, and E1's and E2's A/Bs have not run. Level 1, which neither
    change touches, ran at 0.47 to 0.67 of libdeflate's and zlib-ng's speed in 10b90db's run.

- **Step 10: XXH64.** From xxHash's specification document, copied into `docs/specs/` with its
  SHA-256 (decision 18).
  **Check:** the ruled specification's test values; equal to libzstd's checksums through the
  oracle; throughput; mutations.

  **Check passed, 2026-09-26, but for the test values, which the specification does not give.**
  Zig 0.16.0 on macOS 26.6 arm64 by hand, and on both hosted runners.
  - The specification is xxHash's `doc/xxhash_spec.md`, version 0.2.0, copied unmodified into
    `docs/specs/` from the commit that last changed it, d66a9cb, whose octets release v0.8.4 also
    holds. Its SHA-256 is in `docs/specs/SHA256SUMS`, and CI checks the copy as it checks the
    RFCs (c0fcbee).
  - The document gives no test values. In their place:
    - libzstd 1.5.7 joins as decision 8's Zstandard oracle (4a4c3b4), built from lib/common,
      lib/compress and lib/decompress as its lib/README.md describes, and called through zstd.h.
      A frame's last 4 octets are XXH64's low 32 bits with seed 0 (RFC 8878 §3.1.1).
    - `differential-checksum` (b165971) requires those bits of every XXH64 path this CPU runs to
      equal libzstd's at every length from 0 to 4096 and over every corpus file, and each path's
      state under a seeded split to give all 64 bits of one call. CI run
      [36272807058](https://github.com/c4milo/stdx/actions/runs/36272807058) at bcc93db:
      3,719,586 values on x86-64, with the scalar and AVX-512 paths, and 2,718,121 on aarch64, 0
      failed.
    - The unit tests (06889b9) compare every path with a direct reading of the steps at every
      length below five stripes, split in two anywhere, from four seeds, and pin ten values
      recorded after libzstd agreed.
  - XXH64 (06889b9) is a state fed in pieces, `Xxh64`, and one call, `xxh64`, by an `Xxh64Path`.
  - Throughput, bench-checksum (051b5e4), each path beside stdx's fastest CRC-32 path in one run,
    GB/s at 1 MiB, from the runs of bcc93db:

    | CPU | Scalar | AVX-512 | Path `fastest` takes | CRC-32 |
    |---|---|---|---|---|
    | AMD EPYC 9V74 | 14.55 | 18.56 | AVX-512, 1.28 times scalar | 57.45 |
    | Intel Xeon 8370C | 13.86 | 6.53 | scalar | 52.29 |
    | AMD EPYC 7763 | 12.77 | none | scalar | 25.31 |
    | Neoverse N2 | 18.17 | none | scalar | 34.57 |

    The runs are [36272819388](https://github.com/c4milo/stdx/actions/runs/36272819388), the EPYC
    9V74 and the N2, and [36272808606](https://github.com/c4milo/stdx/actions/runs/36272808606),
    the Xeon 8370C, whose reports are `bench/results/2026-09-26-checksum-xxh64-*.md`, and
    [36272823050](https://github.com/c4milo/stdx/actions/runs/36272823050) for the EPYC 7763.
  - SIMD, as the owner asked on 2026-09-26. XXH64 has four accumulators, each a chain in which a
    stripe waits for the one before, so a vector holds the same four chains and shortens a stripe
    only where its multiply is faster than the scalar multiplier's throughput:
    - The AVX-512 path (06889b9) runs a stripe in VPMULLQ, VPADDQ, VPROLQ and VPMULLQ. On AMD's
      Zen 4, VPMULLQ takes 3 cycles, so a stripe takes about 5 against the scalar path's 8
      multiplies, and it measured 1.26 to 1.28 times from 16 KiB. Intel builds VPMULLQ from three
      32-bit multiplies in about 15 cycles, so a stripe takes about 17: it measured 0.47 on a Xeon
      8370C and on a Xeon 6973P-C, in run
      [36272137694](https://github.com/c4milo/stdx/actions/runs/36272137694).
    - The owner ruled that the path is chosen by the vendor (decision 21, amended):
      `codec.Features.vpmullq_fast` reads CPUID's vendor string (122f36d), and `fastest` takes
      the path on AMD alone, for 1 KiB of stripes or more (bcc93db). At 64 octets it had run at
      0.51 of scalar, in run [36271867725](https://github.com/c4milo/stdx/actions/runs/36271867725),
      as its accumulators cross into a vector register and back.
    - `avx512` now requires DQ, as the AVX-512 objects are compiled for it (c09f954).
    - NEON has no multiply of 64-bit lanes, so aarch64 stays scalar.
  - Mutations are listed in each commit's body. NOT CAUGHT, each changing no output: the 1 KiB
    floor moved; `fastest` ignoring `vpmullq_fast` on aarch64, where the path is not built.
  - After the check, 2026-09-26. libzstd's library exports its copy of xxHash's XXH64, which
    zstd.h does not declare; its binding's test checks it against the frame's checksum.
    - `differential-checksum` now compares all 64 bits of every path with it at every length,
      from seed 0 and from a drawn seed (1960901): 3,004,167 values on macOS, 0 failed.
    - bench-checksum times it as XXH64's baseline (d5ed087). `xxh64` then ran at 0.66 of it over
      64 octets on the N2 and 0.70 on an EPYC 7763, in run
      [36274183552](https://github.com/c4milo/stdx/actions/runs/36274183552): the call went
      through the streaming state's stripe buffer. It now runs the steps over the buffer where it
      lies (e79284e), and in run
      [36274191626](https://github.com/c4milo/stdx/actions/runs/36274191626) the scalar path runs
      at 0.87 and 0.92 of libzstd over 64 octets, 0.98 and 0.99 over 1 KiB, and 1.00 from 16 KiB.
  - 2026-09-27, under decision 23: LLVM fused each lane's multiply by PRIME64_2 into the add to its
    accumulator, so a multiply-add's latency sat on the accumulator's chain, 7 cycles a round on
    the owner's M1 Pro. The `aarch64` path runs Step 2 in assembly with the product first, so the
    chain is an add, a rotate and a multiply. On a Neoverse N2 runner it ran at 0.84 of the scalar
    path at 64 octets, 0.93 at 1 KiB, 0.98 at 16 KiB and 1.00 at 1 MiB, in run
    [36346717594](https://github.com/c4milo/stdx/actions/runs/36346717594): on that core the
    chain through MADD's addend ran no slower than without it. By decision 21's rule, `fastest`
    takes the path only where `codec.Features.madd_addend_slow` holds, which detection sets on
    every aarch64 Mac.

- **Step 11: the Zstandard decoder.** The checked path, then the fast path (claims Z1 to Z5), with
  libzstd as the oracle.
  **Check:** decision 15 against libzstd; windows of exactly 2^23 accepted and above it refused in
  the HTTP instance; skippable and multiple frames; the verified errata of docs/rfcs/README.md;
  then the fast path's equality, A/Bs and benchmark as step 7; mutations.

  **Check passed, 2026-09-27, and Z2's verdict on 2026-09-28.** Zig 0.16.0 on macOS 26.6 arm64 by
  hand, under Rosetta 2 for x86-64, and on the hosted runners, at 3a45936, and Z2's verdict at
  2182b94.
  - The decoder: the checked path (9623b2a to e592538), then the fast path's claims: Z4 (d1021ae),
    Z1 (82b75e1), Z6, a call's octets moved into the window once (233b8b4), Z5 (1c5ef93) and Z2
    (3ae12b4). Z3's default tables build at comptime, and no switch turns them off. Under decision
    23, the sequence loop and the four-stream literal loops run in aarch64 assembly (69e81ed,
    e108311) and, where the CPU has BMI2, in x86-64 assembly (9e52f53, d91e01c).
  - Decision 15 against libzstd: CI run
    [36353188252](https://github.com/c4milo/stdx/actions/runs/36353188252) passed
    `differential-zstd` on both runners, with the same counts on each: 38 files and 669 frames, 0
    failed; 173,953 corrupted inputs, 0 failed, of which the verdict entries allow 86. Of those, 35
    are windows past 2^23 in frames whose Frame_Content_Size is at most 2^23, and 51 are
    Huffman-coded streams not read to their first bit in frames without Content_Checksum. The same
    run passed the unit tests and a short fuzz pass on both runners.
  - Windows: `frame.zig`'s header test accepts a window of exactly 2^23 in the HTTP instance and
    refuses one past it, and `block_test.zig` accepts an offset equal to Window_Size and refuses one
    past it (decision 22).
    The differential check decodes frames with window logs 10, 17 and 23.
  - Frames: `decoder_test.zig` skips a skippable frame before a Zstandard frame, and the
    differential check decodes two frames with a skippable frame between them.
  - Errata: `fse_test.zig` checks the default tables without 6441's duplicate rows,
    `sequences_test.zig` checks Table 18's rows as 6442 and 8085 correct them, and
    `huffman_test.zig` checks the bitstream 8195 corrects. `literals.zig` refuses four streams in
    fewer than 6 octets, as 7297 reads Stream4_Size.
  - Equality: the unit tests, the fuzz test and the differential check require the fast path to
    decode what the checked path decodes. On x86-64 they decode both with the assembly and
    without it.
  - Each claim's A/B, from `bench-zstd` run
    [36353187127](https://github.com/c4milo/stdx/actions/runs/36353187127) on an AMD EPYC 7763 and
    a Neoverse N2, and run [36354787750](https://github.com/c4milo/stdx/actions/runs/36354787750) on
    Intel Xeons. Each cell is the median over the 38 corpus files of the throughput with the claim
    off over the throughput with all on, then the files where on beats off and off beats on by
    more than the spread.

    | Claim | EPYC 7763 | N2 | Xeon 8573C | Xeon 8370C | Verdict |
    |---|---|---|---|---|---|
    | Z1 | 0.85; 36 and 1 | 0.85; 36 and 0 | 0.81; 33 and 0 | 0.84; 38 and 0 | Kept |
    | Z2 | 1.00; 6 and 8 | 1.00; 2 and 3 | 1.00; 0 and 0 | 1.00; 4 and 7 | Kept, on the shuffled text below |
    | Z4 | 0.56; 38 and 0 | 0.62; 38 and 0 | 0.56; 38 and 0 | 0.54; 38 and 0 | Kept |
    | Z5 | 0.99; 21 and 0 | 0.99; 34 and 0 | 0.99; 1 and 0 | 0.99; 26 and 2 | Kept |
    | Z6 | 0.40; 38 and 0 | 0.43; 38 and 0 | 0.43; 38 and 0 | 0.41; 38 and 0 | Kept |

    - Z2 decodes two literals a lookup. Over these 38 files it ties on every runner: at level 3,
      matches cover most of each file, so literals take little of the time. The owner kept it for
      text that compresses poorly, as long as it costs nothing elsewhere, and decision 25 added
      that text to the corpora: `shuffled/dickens-1m`, whose literals Z2 decodes in pairs.
    - In `bench-zstd` run [36361895217](https://github.com/c4milo/stdx/actions/runs/36361895217)
      at 2182b94, Z2 off runs `shuffled/dickens-1m` at 0.86 of all on, on the EPYC 7763 (±0.1%)
      and on the N2 (±0.3%), beyond decision 20's 5% floor on both. Over the other 38 files its
      median stays 1.00, and no file runs faster with it off by more than 3%. stdx decodes the
      shuffled text at 1.14 of libzstd's speed on the EPYC 7763 and 1.03 on the N2.
    - The runs above timed all on beside a candidate that shared one of its functions, found as
      step 7's note on its candidates describes. With Z1 off, `decode_each` set Z1 on for each
      stream, which gave all on's claims, so all on's `fast_literals.decode` of one stream had a
      second caller. LLVM kept it out of line in all on, where Z2, Z4 and Z6 inlined their own,
      so all on paid a call for each block whose literals take one stream. Since 94a5098 each
      stream decodes under Z1's own claims, and all on's `block.prepare` compiles to the same
      code as Z4's and Z6's on both architectures.
    - That call changed no verdict. Between `bench-zstd` runs
      [36440484969](https://github.com/c4milo/stdx/actions/runs/36440484969) at eb0f0c7 and
      [36440509396](https://github.com/c4milo/stdx/actions/runs/36440509396) at 94a5098, each
      claim's median on the N2 stays the same, and no file's ratio moves by more than 0.03. The
      x86-64 runner drew a Xeon 8573C for the first run and an EPYC 9V74 for the second, so its
      two reports cannot be compared.
  - Decision 17: built ReleaseFast, stdx runs at a median of 1.00 of its ReleaseSafe speed on the
    EPYC 7763 (0.88 to 1.05), 1.02 on the N2 (0.98 to 1.09), and 0.99 to 1.02 on the Xeons, each
    as a ratio of the two builds' ratios to libzstd in one run.
  - The benchmark: libzstd at level 3 encodes each file, and libzstd's decoder keeps its context
    across decodes. stdx's throughput over libzstd's, over the 38 files:

    | CPU | Run | Median | Range | Faster | Slower |
    |---|---|---|---|---|---|
    | AMD EPYC 7763 | 36353187127 | 1.19 | 1.00 to 1.32 | 37 | 0 |
    | Intel Xeon 6973P-C | 36354787750 | 1.13 | 0.98 to 1.34 | 36 | 1 |
    | Intel Xeon Platinum 8573C | 36354787750 | 1.17 | 0.97 to 1.34 | 37 | 1 |
    | Intel Xeon Platinum 8370C | 36354787750 | 1.15 | 0.92 to 1.33 | 34 | 3 |
    | Neoverse N2 | 36353187127 | 1.01 | 0.92 to 1.16 | 21 | 15 |

    - The losses: css-1m on the 6973P-C and the 8573C (0.98 and 0.97; a second 8573C job gave
      1.01, and a median of 1.15, faster on all 38), the 1 KiB HTTP bodies on the 8370C (0.92 to
      0.95), and 15 files on the N2, down to nci at 0.92.
    - The fast path runs at a median of 3.91 to 4.19 times the checked path's speed.
    - The x86-64 runner drew only AMD CPUs for the `bench` workflow that day, so a one-off workflow
      on a branch of its own ran `bench/run.sh` in 24 jobs and kept the reports of those on Intel
      CPUs. Its commit, 637ee9a, is 3a45936 with that workflow's file alone.
  - Findings that changed the code:
    - ReleaseSafe fills an `undefined` local with 0xaa. `assign_baselines`'s 512-octet array took
      3 to 6% of the 1 KiB bodies' time on x86-64 through a memset call (3a45936). A sampling
      profile found it, as perf's software clock works on a runner whose VM exposes no hardware
      counter.
    - The M1 Pro and the N2 disagree: XXH64's aarch64 path ran at 1.28 times the scalar path's
      speed on the M1 and 0.84 to 1.00 on the N2, so it runs on Apple's cores alone (efeecd1).
    - Zig 0.16 builds Debug on x86-64 Linux with its own backend, whose inline assembler refuses
      the x86-64 loops' text. The loops run only where LLVM compiles them, and the unit tests
      compile with LLVM (9e52f53).
  - Mutations are listed in each commit's body.

- **Step 12: the brotli decoder.** The static dictionary generated from RFC 7932 Appendix A and the
  transforms from Appendix B; the checked path, then the fast path (claims B1 to B3), with Google's
  brotli as the oracle.
  **Check:** the dictionary's length and CRC-32, 122,784 octets and 0x5136cb04, pinned by a
  comptime assert; the exact table budget of decision 12 computed and pinned; decision 15 against
  Google's brotli; the large-window signature refused as `error.LargeWindow`; then as step 7;
  mutations.

  **The benchmark's candidates, 2026-09-28**, checked as step 7's note on its candidates
  describes, before this step's check. The checked candidate took all on's claims, so the two
  shared the checked path's functions over `Output`, and LLVM kept `read_literal`, `copy_match`
  and `copy_uncompressed` out of line in both, where S1, S4 and S5 inlined their own. All on paid
  a call for each octet the checked path writes: the last 272 of every stream. Since 496ec5c the
  checked candidate turns off S1 and S4, which only the fast path reads. `bench-brotli` runs at
  eb0f0c7 and at 94a5098, compared on the same CPU:
  - On the N2, runs [36440493352](https://github.com/c4milo/stdx/actions/runs/36440493352),
    [36443953184](https://github.com/c4milo/stdx/actions/runs/36443953184) and
    [36443972510](https://github.com/c4milo/stdx/actions/runs/36443972510) before, and
    [36443962138](https://github.com/c4milo/stdx/actions/runs/36443962138) and
    [36443982242](https://github.com/c4milo/stdx/actions/runs/36443982242) after: all on decodes
    the 1 KiB bodies 1 to 2% faster, and each claim's ratio on them falls by up to 0.02. An A/B
    run before 496ec5c favours a claim off by that much on those bodies.
  - On the N2, an EPYC 7763 (36443953184 before, 36440517055 after) and a Xeon 8573C (36443972510
    before, 36443962138 and 36443982242 after), no claim's median moves by more than 0.01, and
    the checked candidate's own functions make the fast path's ratio to it fall by 3 to 5%.
  - The aarch64 runner drew a Neoverse V3 for run
    [36440517055](https://github.com/c4milo/stdx/actions/runs/36440517055), whose aarch64 report
    cannot be compared with the N2's.

- **Step 13: the Zstandard encoder.** Levels 1 and 3.
  **Check:** as step 9, through libzstd and stdx's decoder, with no frame requiring a window over
  8,000,000 octets at the HTTP levels (decision 12).

- **Step 14: the brotli encoder.** Levels 1 and 5, after a decision record of its own on levels and
  memory.
  **Check:** as step 9, through Google's brotli and stdx's decoder.

- **Step 15: the published benchmark.** Every codec, every ruled baseline, every corpus, on the
  Linux runners of decision 20, and the README's tables generated from the results rather than
  written beside them.
  **Check:** decision 10's method as decision 20 amends it, with each run recorded and the losses
  included.

- **Step 16: the `json` module (decision 27).** RFC 8259's encoder and decoder, RFC 7464's text
  sequences, and the vector paths of claims J1 to J5. The owner asked for it on 2026-09-28; it runs
  beside steps 12 to 15 and waits on none of them.
  **Check:**
  - RFC 8259 §13's examples decode to their tokens, and every escape of §7 to its character.
  - Every refusal has a test of its own, with the class `refusal` gives it.
  - An independent parser in the tests, written from RFC 8259 §2 to §7 and RFC 7464 §2.1 and §2.4,
    gives the decoder's verdict and tokens on every seeded and fuzzed input.
  - Seeded and fuzzed lists of tokens encode to texts that parser accepts, and decode back to the
    same tokens.
  - Every text gives the same octets, tokens and verdict one token a call, under seeded splits of
    the input and the output with the state moved between calls (invariants 5 and 12), and with
    every claim off; every vector path returns what its scalar path returns.
  - The fuzzer on every runner of decision 26, with its runs recorded.
  - Each claim's A/B on both runners of decision 20, and a claim that does not beat the noise
    removed with its code.
  - Mutations.

  **Check passed, 2026-09-28.** Zig 0.16.0 on macOS 26.6 arm64 by hand, under Rosetta 2 and in an
  amd64 container for x86-64, and on the hosted runners. A run names the commit it ran at on the
  json branch, which was then rebased onto main: there dff16c4 is 0aeb7eb, f62ca98 is 4721a9f and
  4048c30 is f8dbbae.
  - The module: the encoder, the decoder and their tests (0729376), and the benchmark (e8863df).
    The measurements below then removed J4, moved where J3 and J5 start, pinned the vectors' width
    and fixed the benchmark, each in a commit of its own.
  - RFC 8259 §13: `decoder_test.zig` decodes the object and the array of two objects to their
    tokens, and the texts of a value alone with whitespace around them. Every escape of §7
    decodes to the character it names, in UTF-8.
  - Refusals: `decoder_refusal_test.zig` holds a test for each of the decoder's 16 errors, which
    checks the class `refusal` gives it, and `encoder_test.zig` one for each of the encoder's 3.
    Each case runs whole and under every split seed.
  - The independent parser: `decoder_reference_test.zig` holds a recursive-descent parser written
    from RFC 8259 §2 to §7 and RFC 7464 §2.1 and §2.4. The decoder gives its verdict and its tokens
    on RFC 8259's texts, on hand-picked edges, on 4,000 seeded inputs near the grammar and far
    from it, and on every input the fuzzer draws.
  - Round trips: `round_trip_test.zig` draws 400 seeded lists of tokens, and the fuzzer draws
    more. Each list encodes to the same text whole and under 4 seeded splits; the parser accepts
    the text with the list's tokens; and the decoder decodes it to them whole, under 4 seeded
    splits and with every claim off.
  - Splits and claims: the decoder's tests decode each text with every claim on and off, and under
    200 seeded splits of the input and the output with the state moved between calls; the
    encoder's tests encode each list with every claim on and off, and under 300.
    `decoder_fuzz_test.zig` corrupts 1,500 seeded texts in up to four octets each and requires the
    same verdict every way. `scan_test.zig` requires each vector path to return what its scalar
    path returns at 16, 32 and 64 octets a block, on 3,000 seeded inputs, on every sequence of
    four octets at UTF-8's edges across a block's end, and on every input the fuzzer draws.
  - The fuzzer, on each runner of decision 26, with no failure. Each run ran each of the module's
    four fuzz tests the same number of times:
    - run [36379252480](https://github.com/c4milo/stdx/actions/runs/36379252480) at 4048c30, 10
      million times each: 40,017,010 runs on macOS arm64, 40,017,395 on x86-64 and 40,018,472 on
      aarch64;
    - run [36411321827](https://github.com/c4milo/stdx/actions/runs/36411321827) at f62ca98, 2
      million times each: 8,001,744 runs on macOS arm64, 8,002,493 on x86-64 and 8,002,821 on
      aarch64.
  - Each claim's A/B, from `bench-json` run
    [36413165907](https://github.com/c4milo/stdx/actions/runs/36413165907) at dff16c4, on a
    Neoverse N2 and an Intel Xeon Platinum 8370C. Each cell is the throughput with the claim off
    over the throughput with every claim on: the median over the workloads the claim acts on, then
    the workloads where on beats off and where off beats on by more than the larger of decision
    20's 5% floor and the spread with every claim on.

    | Claim | Workloads | N2 | Xeon 8370C | Verdict |
    |---|---|---|---|---|
    | J1 | Encoding the 20 other than hex strings | 0.243; 20 and 0 | 0.191; 20 and 0 | Kept |
    | J2 | Encoding the 39 hex strings | 0.179; 39 and 0 | 0.182; 39 and 0 | Kept |
    | J3 | Decoding all 59 | 0.032; 59 and 0 | 0.026; 59 and 0 | Kept |
    | J5, encoder | Encoding the 20 other than hex strings | 0.990; 1 and 0 | 0.984; 2 and 0 | Kept |
    | J5, decoder | Decoding the 20 other than hex strings | 1.000; 1 and 0 | 1.003; 1 and 0 | Kept |
    | J4 | Decoding | Removed before this run | Removed before this run | Removed |

    - J5 acts on the text of Cyrillic and CJK characters alone. There, J5 off runs at 0.191 of all
      on decoding and 0.160 encoding on the N2, and at 0.166 and 0.154 on the Xeon: J5 makes it 5
      to 6.5 times as fast. On every other workload it is within the noise, CLDR's texts and qlog's
      records included.
    - Two wins fall outside a claim's reach, and are noise: J2 encoding the samba string, which
      holds no hex string, at 0.872 on the N2, and J5 decoding webster's hex string, which holds no
      non-ASCII octet, at 0.925 on the Xeon.
    - No claim loses on any workload on either runner, and the report lists no loss.
    - With every claim on, the decoder reads CLDR's texts at 196 MB/s on the N2 and 205 on the
      Xeon, qlog's records at 136 and 149, and hex strings at a median of 4.9 and 5.7 GB/s. The
      encoder writes CLDR's texts at 229 and 217 MB/s, qlog's records at 200 and 196, and hex
      strings at a median of 15.5 and 15.9 GB/s. Every claim off, the scalar paths run CLDR's
      texts at 0.556 and 0.512 of those speeds decoding, and at 0.666 and 0.597 encoding.
    - Every run before this one carried the benchmark's fault below: runs
      [36377081260](https://github.com/c4milo/stdx/actions/runs/36377081260) to
      [36411317000](https://github.com/c4milo/stdx/actions/runs/36411317000). Their ratios on
      the long strings, the non-ASCII text and the hex strings hold, as each of those workloads is
      one token; on CLDR's texts and qlog's records they do not.
  - Findings that changed the code, each a finding of decision 27:
    - The benchmark measured a call of its own on two candidates (0aeb7eb), and `run` is inline in
      both entries (1bf5e05). In run 36411317000, on the N2, the decoder with J5 off ran CLDR's
      texts at 1.177 of all on, where J5 changes nothing, and 0.994 once the fault was gone; the
      encoder with every claim off ran them at 0.494 of all on, and 0.666 once it was gone.
    - J4 left with its code (c65a59d), on runs that carried that fault.
    - J5 starts at a non-ASCII octet past the encoder's escapes and the decoder's delimiters, and J3
      only after an ASCII octet (83507a5, eab2fca). J5 left the decoder on the fault's numbers
      (cbea12b) and came back (4721a9f).
    - The vectors hold 16 octets on every target (c7f0172).
    - No vector of bool crosses a call, and `zig build test-avx512` builds for an AVX-512 CPU
      (1677ec9, f8dbbae).
  - Mutations: the 53 below, on the first commit, and those in the body of each commit after it.

  **After the check, 2026-09-28**, the owner's two further rulings, at ad14324:
  - The baselines of decision 27. `bench-json` run
    [36439380850](https://github.com/c4milo/stdx/actions/runs/36439380850) at e468bb5, which main
    holds as bf8f7fd, timed simdjson, yyjson and Zig's std.json beside stdx with every claim on,
    on a Neoverse N2 and an AMD EPYC 9V74. Each cell is stdx's throughput over the baseline's, on
    the N2 and then on the EPYC; below 1, stdx is slower.

    | Workload | Side | simdjson | yyjson | std.json |
    |---|---|---|---|---|
    | CLDR's texts | Decoding | 0.167, 0.151 | 0.151, 0.161 | 0.504, 0.531 |
    | qlog's records | Decoding | 0.140, 0.155 | 0.149, 0.131 | 0.485, 0.461 |
    | dickens as a string | Decoding | 0.546, 0.355 | 0.379, 0.394 | 2.553, 3.851 |
    | E.coli as a string | Decoding | 2.288, 1.018 | 2.243, 3.165 | 7.620, 14.224 |
    | Cyrillic and CJK | Decoding | 0.379, 0.181 | 0.716, 1.091 | 1.746, 2.695 |
    | dickens as hex | Decoding | 2.328, 1.047 | 2.281, 3.315 | 14.594, 28.020 |
    | CLDR's texts | Encoding | 0.199, 0.213 | 0.217, 0.220 | 0.531, 0.587 |
    | qlog's records | Encoding | 0.196, 0.214 | 0.248, 0.254 | 0.508, 0.534 |
    | dickens as a string | Encoding | 0.409, 0.361 | 0.409, 0.398 | 2.578, 3.709 |
    | E.coli as a string | Encoding | 0.884, 1.205 | 1.929, 3.115 | 4.957, 7.879 |
    | Cyrillic and CJK | Encoding | 0.259, 0.200 | 1.157, 1.638 | 1.953, 2.661 |
    | dickens as hex | Encoding | 10.802, 11.519 | 14.590, 16.719 | 31.874, 45.828 |

    - On texts of short tokens, CLDR's and qlog's, stdx runs at a sixth or a seventh of simdjson's
      and yyjson's speed, and at about half of std.json's, both ways. Each call of stdx's decoder
      returns one token, and the octets between strings are taken one at a time, so both costs
      grow with the tokens.
    - On long strings the vector runs pay. stdx decodes a string with no escape, E.coli, at least
      as fast as all three, and writes hex strings 11 to 46 times as fast, as none of them has a hex
      string.
    - The reports list every workload where a baseline wins, in bench/results/.
  - The proofs of decision 28. `zig build lean` built spec/lean/ on macOS 26.6 arm64, where every
    theorem rests on Lean's standard axioms alone, and found src/json/utf8_vectors.txt and
    number_vectors.txt, 2,048 steps and 2,313 lines, to be what the proved machines give;
    `zig build test` replays them against `Utf8` and `Number`. Mutations, each applied and
    reverted:
    - Zig, against `zig build test-json`: F4 followed by any continuation octet; a refused octet
      that moves the state; a digit after a lone zero ending the number; a sign taken after an
      exponent's digit; a vector line flipped to refused. Each CAUGHT, the four that change the
      machines by the replay tests alone.
    - Lean, against `lake build`: the machine taking F4 then 80 to 9F; the grammar taking E0 then
      80 to BF; the machine taking a digit after a lone zero; the grammar's exponent without a
      digit. Each fails the build.

  **Mutations, 2026-09-28**, each applied, run against `zig build test-json` and reverted: 53, all
  CAUGHT. Nine at first did not compile, as a local or a parameter they left unused; each was
  written again so it compiled, and each was then CAUGHT.
  - The encoder: a string's octet not checked as UTF-8; a string ending inside a character; a
    number text's octet not checked; a number text ending unwhole; the depth limit one past
    `depth_max`; the two-character escapes written as `\u00` and two digits; no value separator
    after a member; no record separator before a sequence's text, and no line feed after it; held
    octets written all or none; a hex pair's low digit first; the quotation mark not escaped;
    `TextWriter` taking a full output for success.
  - The numbers: a fraction not padded with zeros; a negative integer without its minus; a plus
    sign starting a number; a digit after a lone zero read as the number's end.
  - The decoder: octets after the text accepted; no record separator required; a byte order mark
    read as nothing; an undelimited number or literal name accepted at the input's end, and before
    a record separator; a text a record separator cuts taken as done; whitespace after the value
    never recorded; an octet that starts no value read as a number; a member without a name; a name
    without its colon; an array closed by a curly bracket; the depth limit one past `depth_max`; a
    literal name's letters not compared; an octet no number takes read as the number's end; a
    number at the text's end left waiting; a string's octet not checked as UTF-8; a control
    character in a string accepted; a record separator in a string read as a control character; an
    escape letter RFC 8259 §7 does not list taken as itself; a hex digit of any letter; a high
    surrogate followed by anything, and paired with any code unit; a lone low surrogate accepted; an
    escaped character left in `pending`.
  - The vector paths: the plain run missing a reverse solidus; the UTF-8 check letting a surrogate
    through, and an overlong form of four octets; a cut character not handed back to the scalar
    path; a block after a non-ASCII one taken as whole; the whitespace run missing a carriage
    return; the hex letters one too high; NEON's lanes read three bits apart.
  - UTF-8: C0 and C1 taken as first octets; E0 and F4 followed by any continuation octet.
  - `TextReader`: a sequence ending after its first text.

- **Step 17: the `json` decoder's structural index, and the module's vector paths picked at run
  time (decision 30).** The owner ruled both on 2026-09-28, after step 16's baselines.
  **Check:**
  - A profile first: cycles, instructions and branch misses per token and per octet for stdx's
    decoder and encoder, and for simdjson's and yyjson's, on the N2, through `bench-profile`.
  - The calls and switches each token passes through, cut where the profile finds them, each cut
    measured by the same counters, before the index.
  - The index's vector path returns what its scalar path returns on every input the tests draw and
    the fuzzer finds, at 16, 32 and 64 octets a block, across a block's end and a call's. Dropped
    with J6, which the owner ruled out after the profile (decision 30).
  - The decoder gives the same tokens and verdicts with J6 on and off, whole, under seeded splits
    and through the fuzzer, and the reference parser's verdicts still hold. Dropped with J6.
  - Every level's kernels return what the 16-octet ones return, with the tests passing the
    features of every level the CPU runs.
  - J7's A/B on both runners of decision 20, and the baselines again.
  - Mutations.

  A run names the commit it ran at on the json branch, which was then rebased onto main: there
  f6f3e1f is 0023649, d8e68c3 is a67bdaa, 305af14 is 9b80395 and c31ad99 is 74254cc.

  **The profile, 2026-09-28.** `bench-profile` run
  [36472497642](https://github.com/c4milo/stdx/actions/runs/36472497642) at f6f3e1f, on a
  Neoverse N2; the x86-64 runner, an AMD EPYC 7763, refused perf_event_open. Per token, with every
  claim on:

  | Workload | Side | stdx, cycles | stdx, instructions | simdjson, cycles | simdjson, instructions | yyjson, cycles | yyjson, instructions |
  |---|---|---|---|---|---|---|---|
  | CLDR | decoding | 169.8 | 601.5 | 31.1 | 109.0 | 27.9 | 107.1 |
  | qlog | decoding | 187.6 | 623.6 | 29.6 | 108.7 | 28.4 | 106.7 |
  | CLDR | encoding | 129.9 | 598.7 | 25.1 | 102.1 | 27.1 | 105.4 |
  | qlog | encoding | 120.1 | 541.2 | 22.4 | 100.1 | 28.3 | 117.7 |

  - stdx runs as many instructions a cycle as the baselines, 3.3 to 4.6, and misses a branch 0.3
    to 0.6 times a token: at docs/costs.md's 4.03 ns a mispredict on the N2, 2% to 4% of a token's
    time. It loses on the instructions a token takes, five to six times theirs.
  - perf sampled the same program at 20 kHz on the N2, in run
    [36473532959](https://github.com/c4milo/stdx/actions/runs/36473532959) of the branch
    `exp-json-perf`, which is never merged. qlog's decoding spent its time in `Decoder.step` 24%,
    the benchmark's loop with `decode_with` inline 19%, `Number.accept`, called once a digit, 9%,
    `continue_token` 6%, `plain_len_vector` 6%, `content` 5%, `decoder_value.number` 5%,
    `copy_run` 4%, `separator_or_end` 4%, `skip_whitespace` 4%, `value` 3% and `write_pending`
    3%. CLDR's took the same shape. qlog's encoding spent 51% in its loop with `encode_with`
    inline, 22% in `Encoder.open` and 11% in `memcpy`, called for copies of a few octets.
  - The scans the index would replace, of whitespace, strings and numbers, take about a quarter of
    qlog's decoding time, and decision 30 keeps their checks. The rest is the calls and switches
    each token passes through. So the step cuts those first, and builds the index where the
    profile then finds the scans.

  **J8, 2026-09-28.** The fast path of decision 31, in `decoder_fast.zig`.
  `decoder_fast_test.zig` requires the same progress, octets, error and state after every call
  with J8 on and off:
  - over its texts and 1,500 seeded corruptions of them, and over every input the fuzzer draws;
  - in both framings, whole and under 4 seeded splits of the input and the output;
  - beside every other claim on, and beside every other claim off.

  It also requires the fast path to take every token of three texts but the first, and a number
  and a string that fill the output exactly. Mutations, each against `zig build test-json`:
  - CAUGHT, each of 17:
    - a string's closing octet unchecked, and its window one octet past the room;
    - a number that fills the output left to the checked path;
    - `ended_in` counting the octet that ends the number, and taking a number the input cuts;
    - a value separator in an object expecting a value, and a name separator unchecked;
    - an object's end closing an array, and no depth limit;
    - a literal name's later letters unchecked, and a name taken as a string;
    - `matched` one short, and `number` not set;
    - a token taken after the text's value;
    - whitespace's first octet tested inverted;
    - the fast path tried before the text's tokens, and a fallback keeping the octets it read.
  - NOT CAUGHT: the reset of the UTF-8 check. It changed nothing, since the check stands at `.{}`
    between tokens, so an assertion of that replaced it.

  J8's counters, from `bench-profile` run
  [36476811910](https://github.com/c4milo/stdx/actions/runs/36476811910) at d8e68c3 on the N2, per
  token with every claim on: qlog's decoding fell from 187.6 cycles and 623.6 instructions to 99.1
  and 344.8, and CLDR's from 169.8 and 601.5 to 84.2 and 307.3. simdjson and yyjson stayed at 27 to
  31 cycles and 107 to 109 instructions.

  **J9, 2026-09-28.** The encoder's fast path of decision 31, in `encoder_fast.zig`.
  `encoder_fast_test.zig` requires the same progress, octets, error and state after every call
  with J9 on and off:
  - over a qlog-shaped record, lists with escapes, non-ASCII octets and refusals, a list past the
    depth limit, 400 seeded lists of the round trip's tokens, and every list the fuzzer draws;
  - in both framings, whole and under 4 seeded splits of the input and the output;
  - beside every other claim on, and beside every other claim off.

  It also requires the fast path to write every token of the record, none of the escaped or
  non-ASCII strings, and a string, a hex string and a number that fill the output exactly.
  Mutations, each against `zig build test-json`, every one CAUGHT:
  - a string that needs escapes written as it is, and one whose octets go on written whole;
  - a hex string whose octets go on written whole, and its digits counted once an octet;
  - a number's text unchecked, and `whole_number` taking a number that is not whole;
  - no depth limit;
  - a value separator before a container's end, a record separator before every token, and a line
    feed after every token;
  - the outermost container's end not ending the text, and the text never done;
  - a token that fills the output left to the checked path, and one an octet longer than the room
    written;
  - a name closed without its separator, and a token's opening not written;
  - `number` not set.

  The reset of the UTF-8 check left for an assertion, as J8's did.

  **The fast paths inline, 2026-09-28.** perf on the N2 in run
  [36478303937](https://github.com/c4milo/stdx/actions/runs/36478303937) of the branch
  `exp-json-perf-2`, at 305af14 with J8 and J9, found the benchmark's build calling what the probes
  inlined. Decoding qlog, 35% of the time was in `next_token`, 17% in `value` and 4% in
  `container_end`; about 10% was in the number machine's table, stepped once a digit. Encoding,
  15% was in `Encoder.advance` and 9% in `memcpy`, copying a token's one or two octets of opening
  and closing. Both fast paths are now inline throughout. The encoder writes those octets one at a
  time, and a number's scans take a run of digits without stepping the machine where a digit
  leaves its state as it is. Mutations, each against `zig build test-json`:
  - CAUGHT: a lone zero's state and the start state taking a run of digits; an exponent's digits
    left to the machine, which the test of `loops_on_digits` against the table catches; a digit run
    an octet long; `whole_number` taking a number that is not whole.
  - CAUGHT, J9's reshaped writes: a name closed as a string, a token's opening not written, a
    formatted number's text not written, and a name's closing counted as a string's. The other
    J9 mutations above ran again, and each was CAUGHT.

  **J7, 2026-09-28.** `wide.zig` picks each scan's width from the level `init` keeps:
  - AVX-512's 64 octets or AVX2's 32 on x86-64, in the variant objects `variants.zig` builds for
    those two levels alone;
  - the module's own 16 octets everywhere else.

  A run no longer than the level's width stays inline at 16 octets. A name's or a string's run
  reaches the kernel only past its first 16 octets, so a short one pays no call.
  - `scan_test.zig` requires each scan at every level this CPU runs to return what the scalar path
    returns, on its seeded inputs, and `wide.zig`'s tests pin the level the features pick.
  - The AVX2 kernels ran under Rosetta 2 with `-Dtarget=x86_64-macos -Dcpu=x86_64_v3`, whose
    features `detect()` adds. The AVX-512 kernels run on the x86-64 runners that have AVX-512.

  bench-json run [36480120596](https://github.com/c4milo/stdx/actions/runs/36480120596), at c31ad99
  before J7, found one loss on the N2: E.coli, a string of plain ASCII alone, encoded 14.5% faster
  with J9 off, as the fast path's scan of its 1 MiB ran inside the encoder's loop. So a run past its
  first 16 octets now leaves its caller at every level, for a function of its own.

  Mutations, the kernels' under Rosetta, every one CAUGHT:
  - the AVX2 string, UTF-8 and hex kernels each one octet short;
  - a stop in the last lane of the first block passed on;
  - the rest's run counted from the string's start;
  - a long run's rest one octet short at the target's level;
  - AVX-512's features picking AVX2;
  - J7 off keeping the wide level.

  **J7 measured, 2026-09-28.** bench-json run
  [36483083861](https://github.com/c4milo/stdx/actions/runs/36483083861) at 2252816, on a Neoverse
  N2 and an AMD EPYC 9V74 with AVX-512. On the N2, where J7 picks no kernel, every J7 column stayed
  within 1% of all on. On the EPYC, with J7 off:
  - runs of plain ASCII and hex strings ran at 0.69 to 0.77 of all on, decoding and encoding: E.coli
    as a string, and every hex string;
  - text of Cyrillic and CJK characters ran at 1.58 of all on decoding and 1.57 encoding, and
    English text encoded at 1.05 to 1.08: J7's losses.

  So J5's UTF-8 scan left J7, and a run now takes 16 octets a block for its first 64
  (`constants.wide_run_len_min`) before a kernel takes the rest (decision 30). The E.coli loss of
  run 36480120596 is gone: J9 off ran at 1.000 of all on. Mutations, every one CAUGHT, the kernels'
  under Rosetta:
  - a stop in the head's last lane passed to the kernel, which a new test of a stop at every octet
    of a long input catches;
  - the kernel's run counted from the head's start;
  - a short rest sent to the head's slice.

  **The API, 2026-09-28.** `Decoder.init`, `Encoder.init`, `TextWriter.init` and `TextReader.init`
  take the caller's `codec.Features` last, and each state keeps them (decision 30). The kernels of
  J7's wider levels come after. `round_trip_test.zig` requires `none()`, `target()` and `detect()`
  to give the same octets and tokens, as invariant 5 now states.

Steps 3 to 8 are stdx issue 1, the decoder colibri waits on. Steps 9 to 14 complete version one.

## 9. Performance

Decision 10 fixes the method before the first measurement, so the numbers cannot be shaped
afterwards. Decision 14 lists the claims and the cost each removes, priced against
[costs.md](costs.md). Decision 16 says where a hot loop may leave the checked reader and writer, and
decision 17 what the safety checks cost. Every claim is measured against a correct checked path,
and one that does not beat the noise is removed.

## 10. Open questions for the owner

Decisions 11 to 20 are ruled. Decisions 27 and 28 leave one question each to the owner:

- A dependency for the `json` module's checks: a conformance corpus such as JSONTestSuite, or an
  oracle. Until one is ruled in, an independent parser in the tests is the decoder's judge. The
  benchmark's baselines, simdjson, yyjson and Zig's std.json, were ruled in on 2026-09-28.
- A proof in Lean that the vector UTF-8 check of claim J5 agrees with the scalar one on every
  window of four octets. Decision 28 proves the scalar machines against their RFCs, and leaves
  this one.

## 11. Risks

- **Hosted runners are noisy.** They are shared virtual machines whose CPU model can change between
  runs (decision 20). A gain smaller than the spread a job measures cannot be shown, and a claim
  that cannot be shown is removed.
- **Safety checks in ReleaseSafe may cost more than decision 17 expects.** A wide access pays one
  bounds check, but the compiler may not merge the checks a loop repeats. Step 7 measures it before
  any claim is made, and decision 17 says what happens above 5%.
- **Zig's fuzzer is young.** It runs on Linux, and its behavior may change between Zig releases.
  The seeded corruptions of decision 15 run without it, deterministically, on every host.
- **brotli's static memory is large.** About 19 MiB per decoder, fixed. A caller with less can
  build a smaller instance, which refuses streams with a larger window.
- **A corpus host can disappear.** The Silesia archive is served from one university host. The Zig
  cache keeps a fetched package, and a mirror would need a ruling.
- **Wuffs v0.4 is an alpha** (colibri's decision 89). Its verdicts can change between commits; the
  pin by hash holds them still.
- **Encoders at their strongest levels will likely lose** to libzstd, Google's brotli and
  libdeflate's level 12, and decision 14 says so in advance.
- **A benchmark that decodes one small payload many times lets the branch predictor learn its
  branches.** On the M1 Pro, a 16 KiB payload decoded again and again mispredicts less than
  payloads that differ on each decode. Step 11 measured it on the Zstandard sequence loop, which
  takes a block's offsets by selects rather than branches when the block's offset table names a
  repeat in at least 20 of every 256 cells: json-16k decoded alone ran 2% slower by selects, and
  json-1m cut into 64 distinct frames of 16 KiB ran 5.7% faster. The loop keeps the rule that
  serves distinct payloads, and gives up about 2% on json-16k for it.
