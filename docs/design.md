# stdx design

This document holds the module graph, the streaming contract, the named limits and the numbered
build plan. [decisions.md](decisions.md) holds why each choice beat its alternatives, and
[invariants.md](invariants.md) what no change may break. Cite sections by number: "design §8 step
5".

The owner ruled on decisions 11 to 19 on 2026-09-25, so this document states the design as
ruled. Where it depends on a decision, it names the decision.

## 1. Thesis and scope

stdx is compression codecs written from the RFCs, with no heap and no I/O, that a project places
wherever its memory lives and drives from whatever I/O model it has. Version one holds DEFLATE with
its zlib and gzip containers, Zstandard and brotli, each with an encoder and a decoder (decision 1),
in the order decision 13 proposes.

The aim is to match or beat zlib, zlib-ng, libdeflate, libzstd, Google's brotli and Wuffs on the
workloads stdx measures: the corpora of decision 15, measured the way decision 10 fixes. Decision 14
states where stdx expects to win, where to match, and where to lose, and every report shows all
three.

Out of scope are the items decision 13 lists: RFC 9841's extensions, dictionaries of every kind,
threads, and formats that are not the four HTTP codings.

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

The wrappers build on `deflate`, and `deflate` never reaches them. No codec reaches another codec.
No library module receives a package: pepegrillo, the oracles and the corpora are requested by
`build.zig` for `tools/` and `bench/` only, after the point a dependent's build stops.

Outside the library, and never imported by it:

- `tools/`: the lint rules, the complexity scorer, the commit linter, the graph check, and, from
  step 2, the differential checks of `tools/oracle/`.
- `bench/`: the benchmarks, from step 2.

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
  Standard, whose size allows a 1 MiB cut; the four proposed oracles are ruled in; and decision 19
  adds CI. Every document that said a decision was pending was changed in the same commit, and
  `zig build test` passed after it.

- **Step 2: oracles, corpora, costs and CI.** zlib and Wuffs as lazy packages pinned by hash, built
  in `tools/` and `bench/` only (decision 8), the others joining at the steps that use them; Silesia, Canterbury and the HTTP payloads as lazy packages
  pinned by hash, with the tool that cuts the 1 KiB, 16 KiB and 1 MiB pieces (decision 15);
  `bench/costs/` (docs/costs.md); `tools/ci.sh` and the workflow of decision 19; and the owner's
  Linux machine, written down in docs/costs.md.
  **Check:**
  - `zig build oracle-selftest`: zlib and Wuffs decode every stream zlib encodes from the corpora,
    at every level and strategy in all three containers, to the same octets. Two oracles that
    disagree on valid input would make every later verdict meaningless.
  - The graph check forbids `deflate` the oracle modules too.
  - `docs/costs.md` is filled on the Linux machine, with the machine written down.
  - The workflow's first run passes, and its report matches a run of `tools/ci.sh` by hand.

- **Step 3: `codec`.** The status, counts and flush modes; the checked reader and writer; the
  least-significant-bit-first bit reader of RFC 1951 §3.1.1 with its checked refill; the seeded
  split driver every codec's tests use; the `input-index` lint rule of decision 16.
  **Check:** unit tests for every refusal of the reader and writer; the split driver's schedules
  replay from their seed; the new lint rule's fixtures and its canary line; mutations.

- **Step 4: `checksum`, CRC-32 and Adler-32.** From RFC 1952 §8 and RFC 1950 §9.
  **Check:** equal to the sample code in those appendices, compiled in `tools/` as an oracle, and to
  zlib's `crc32` and `adler32`, over the corpora at every length from 0 to 4096 and at seeded
  offsets and splits; the vector paths of decision 14's claim S9 equal the table path under the
  fuzzer; mutations. The throughput against every ruled baseline goes into this entry.

- **Step 5: the DEFLATE decoder, checked path.** Stored, fixed and dynamic blocks (RFC 1951 §3.2),
  through `codec`'s reader and writer alone.
  **Check:** decision 15 against zlib and Wuffs, raw DEFLATE: identical output under seeded splits,
  corruption verdicts with every disagreement recorded, the state copied mid-stream, the
  worst-case count of invariant 17; fuzzing on Linux with the time it ran recorded; mutations.

- **Step 6: the zlib and gzip decoders.** RFC 1950 and RFC 1952 around step 5's decoder, with
  multi-member gzip.
  **Check:** as step 5, over all three containers, with the verdict entries for RFC 1950 §2.3 and
  RFC 1952 §2.3.1.2 that decision 15 lists; `done` never before the trailer is checked (invariant
  11); mutations.

- **Step 7: the DEFLATE decoder, fast path.** Claims S1 to S8 and S10 of decision 14, each under
  decision 16's rules.
  **Check:**
  - The fast path writes what the checked path writes, under the fuzzer and over the corpora.
  - Each claim's A/B on the Linux machine; a claim that does not beat the noise is removed with its
    code.
  - Decision 17's measurement of the safety checks' cost.
  - The benchmark against zlib, zlib-ng, libdeflate and Wuffs: median of
    five with spread, the losses included.

- **Step 8: stdx issue 1 closes.** The whole-buffer helpers of decision 11, and each item of
  https://github.com/c4milo/stdx/issues/1 checked off with its evidence.
  **Check:** issue 1's list, each item pointing at the entry of step 4, 5, 6 or 7 that proves it.
  colibri may then pin the commit (colibri's design §8 step 14).

- **Step 9: the DEFLATE encoder.** Levels 1, 6 and 9 (decisions 12 and 13), in all three
  containers, with `Flush.flush` and `encoded_len_max`.
  **Check:** decision 15 for encoders: every output decodes to its input through zlib, Wuffs and
  stdx; the output is the same under every split, and its hashes match across hosts and modes
  (invariant 5); `encoded_len_max` holds; the ratio and speed per level against zlib, zlib-ng and
  libdeflate; mutations.

- **Step 10: XXH64.** From xxHash's specification document, copied into `docs/specs/` with its
  SHA-256 (decision 18).
  **Check:** the ruled specification's test values; equal to libzstd's checksums through the
  oracle; throughput; mutations.

- **Step 11: the Zstandard decoder.** The checked path, then the fast path (claims Z1 to Z5), with
  libzstd as the oracle.
  **Check:** decision 15 against libzstd; windows of exactly 2^23 accepted and above it refused in
  the HTTP instance; skippable and multiple frames; the verified errata of docs/rfcs/README.md;
  then the fast path's equality, A/Bs and benchmark as step 7; mutations.

- **Step 12: the brotli decoder.** The static dictionary generated from RFC 7932 Appendix A and the
  transforms from Appendix B; the checked path, then the fast path (claims B1 to B3), with Google's
  brotli as the oracle.
  **Check:** the dictionary's length and CRC-32, 122,784 octets and 0x5136cb04, pinned by a
  comptime assert; the exact table budget of decision 12 computed and pinned; decision 15 against
  Google's brotli; the large-window signature refused as `error.LargeWindow`; then as step 7;
  mutations.

- **Step 13: the Zstandard encoder.** Levels 1 and 3.
  **Check:** as step 9, through libzstd and stdx's decoder, with no frame requiring a window over
  8,000,000 octets at the HTTP levels (decision 12).

- **Step 14: the brotli encoder.** Levels 1 and 5, after a decision record of its own on levels and
  memory.
  **Check:** as step 9, through Google's brotli and stdx's decoder.

- **Step 15: the published benchmark.** Every codec, every ruled baseline, every corpus, on the
  Linux machine, and the README's tables generated from the results rather than written beside them.
  **Check:** decision 10's method, with the machine written down and the losses included.

Steps 3 to 8 are stdx issue 1, the decoder colibri waits on. Steps 9 to 14 complete version one.

## 9. Performance

Decision 10 fixes the method before the first measurement, so the numbers cannot be shaped
afterwards. Decision 14 lists the claims and the cost each removes, priced against
[costs.md](costs.md). Decision 16 says where a hot loop may leave the checked reader and writer, and
decision 17 what the safety checks cost. Every claim is measured against a correct checked path,
and one that does not beat the noise is removed.

## 10. Open questions for the owner

1. The Linux machine for costs, benchmarks and fuzzing (decisions 10 and 19): the owner will name
   it, and step 2 needs it.

## 11. Risks

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
