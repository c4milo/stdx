# stdx rules

stdx is a library of compression codecs, written from the RFCs: DEFLATE with its zlib and gzip
containers, Zstandard and brotli, each with an encoder and a decoder. Home:
github.com/c4milo/stdx. It aims to match or beat zlib, zlib-ng, libdeflate, libzstd, Google's
brotli and Wuffs on the workloads it measures, with no heap and no I/O.

It is a standalone library. colibri is its first consumer: colibri's h11 decodes HTTP/1.1's `gzip`
and `deflate` transfer codings with it. Other projects want the encoders and decoders for the HTTP
content codings `gzip`, `deflate`, `br` and `zstd` (RFC 9110 §8.4). stdx must never depend on
colibri, must never name a consumer in its source, and must never take a decision that only makes
sense inside one consumer. What a consumer needs informs what stdx measures; it does not shape
stdx's API.

## Read before changing behaviour

- `docs/design.md`: the module graph, the streaming contract, and the numbered build plan. Each
  step names the check that proves it. Cite sections by number in commits and comments ("§8 step
  5").
- `docs/decisions.md`: numbered decisions, each with the alternatives it beat. An entry marked
  **owner** waits on a ruling and is not settled.
- `docs/invariants.md`: numbered invariants, each with the check that proves it.
- `docs/costs.md`: the measured costs every performance claim is priced against.

All four record decisions with the alternatives they beat. If you are about to do something a
document rejected, say so and stop. Do not reverse it in code.

## Non-negotiables

The architecture depends on every rule in this section.

1. **No I/O.** A codec reads octets the caller already has and writes into storage the caller
   owns. It opens no file or socket, starts no thread, and makes no syscall. `tools/lint/io.zig`
   enforces it over `src/`.
2. **No heap.** No `Allocator` anywhere in `src/`, tests included. The caller owns every state,
   window, table and hash chain, and places it where it chooses. Each size is a comptime constant
   the codec exports, per codec and per encoder level. `tools/lint/heap.zig` enforces it.
3. **Streaming, and able to resume.** Every call takes whatever input the caller has and writes
   what fits. It ends by saying whether it needs more input, needs more room, or is done, and the
   next call resumes where it stopped. Work per call is bounded by the octets it consumed and
   wrote. A whole-buffer helper is built on the streaming call, never the reverse.
4. **Deterministic.** No clock, no PRNG, no pointer value and no uninitialised memory in any
   output. An encoder's output is a pure function of its input and its parameters, byte-identical
   across hosts, build modes, and the way the caller split the input and output across calls.
   `tools/lint/determinism.zig` enforces the first two.
5. **The RFCs, never another implementation's source.** The copies to read are in `docs/rfcs/`,
   unmodified from rfc-editor.org, with `docs/rfcs/SHA256SUMS` to show they stay that way. Other
   implementations are test oracles and benchmark baselines only. They are compiled in `tools/`
   and `bench/` and never into the library, and nobody working on stdx reads their source.
6. **Every RFC rule cited by section, in the code.** A check that exists because an RFC demands it
   carries the RFC and the section in a comment on the line that does the checking, so a reader
   can go from any refusal to the sentence that requires it. Cite the RFC that states the rule:
   the `zstd` window limit for HTTP is RFC 9659 §3, not RFC 8878. `tools/lint/rfc_citation.zig`
   enforces the presence of a citation.
7. **TigerStyle.** Every loop and queue bounded. Every limit named in the module's
   `constants.zig`, with a doc comment, and never written inline. Assertions stay on in
   production, about two per function, covering positive and negative space, for programmer error
   only (decision 17). Hostile input returns an error value and fails closed; no input reaches an
   assertion.
8. **One module per codec, plus the checksums.** Each is exported by name with `b.addModule`, so a
   dependent reaches it with `dependency.module("gzip")` (decision 6). The library keeps no
   process-wide mutable state, so a dependent may run codecs on as many threads as it likes.
9. **Invariants are code.** Every numbered invariant in `docs/invariants.md` names the check that
   proves it: a comptime assert, a runtime assertion, a lint rule or a seeded check.

## Tests are proved by mutation

A test must fail when the code it covers is broken. When you add a check, break it on purpose and
confirm a test fails. Report the result as `CAUGHT` or `NOT CAUGHT` per mutation, in the commit
body or in the step's entry in design §8. A `NOT CAUGHT` means a test is missing; write it.

## Conventions

- Zig 0.16. One library, no binary; the tools and the benchmarks are the only executables.
- Names spell words out: `window_len`, not `wlen`. No vowel-dropping. Vocabulary the RFCs use
  stays as they spell it (`BTYPE`, `HLIT`, `FDICT`, `Window_Size`, `WBITS`), in doc comments and
  citations; Zig names are snake_case (`window_size`). One-letter names only for loop indices.
  `_len` always counts octets, and a count of bits says `_bits`.
- Settled terms: **codec** for one format's encoder and decoder; **container** for zlib and gzip,
  which wrap a DEFLATE stream; **stream** for the octets of one coded message; **window** for the
  history a back-reference can reach; **caller** for the code that owns the state and the
  buffers. Say **octet**, not byte, in prose.
- Functions stay at cognitive complexity 15 or less, scored by `tools/cognitive_complexity.zig`.
  `test` blocks are scored under the same limit. Split the function; never raise the threshold.
- A hand-written source file stays at or under 500 lines, its tests included, enforced by
  `tools/lint/file_length.zig`. Split the file rather than raise the limit, and name every piece
  after the file it came from: `zstd.zig` becomes `zstd_frame.zig`, `zstd_block.zig`, and so on,
  keeping the original name as the entry point.
- Four or more files sharing a prefix move into a subdirectory named for it, the pieces keeping
  their full names: `src/zstd/block/block_header.zig`.
- All parsing goes through the checked reader and all output through the checked writer of the
  `codec` module. A hot loop may leave them only where decision 16 allows it, and only with the
  measurement that decision asks for. Never assume host endianness. DEFLATE and brotli pack bits
  least significant first (RFC 1951 §3.1.1, RFC 7932 §1.5.1); zlib stores every multi-octet number
  most significant octet first (RFC 1950 §2.1); gzip and Zstandard store them least significant
  first (RFC 1952 §2.1, RFC 8878 §3.1.1). Name the order at every read.
- Operational errors (input that ended before the stream did, an output with no room) are
  statuses in the streaming call and error values in the whole-buffer helpers. Refusals of input
  are error values, distinct per cause, so a caller can tell a corrupt stream from a feature stdx
  refuses. Assertions are for programmer error only, placed at contract points, never where input
  can reach them.
- Write all prose in active voice with plain words, following Google's Technical Writing One and
  Two: short sentences with one idea each, terms defined before use, lists for list-like content,
  strong verbs, no rhetorical flourishes or metaphors.
- Name what literally happens. Before an abstract word, ask what literally happens and write that.
- One name per thing, and it is the name in the code. Never invent prose shorthand for something
  a field or constant already names.
- Every GitHub issue reference carries its full URL (`https://github.com/c4milo/stdx/issues/1`),
  never the bare hash-and-number form. Markdown may keep the short form as the link label; Zig and
  shell comments spell the URL out.
- Every Markdown file is GitHub-flavored Markdown and must render on GitHub as written: real list
  markers only (no bare `3b.` lines), pipes inside a table cell escaped as `\|`, fenced code blocks
  with a language, no definition lists, no LaTeX. `tools/lint/markdown.zig` checks what it can.

### Commits

- A commit message is a Conventional Commit: `type(scope)!: description`, with the scope and the
  `!` optional. The type is one of `feat`, `fix`, `docs`, `test`, `refactor`, `perf`, `build`,
  `ci`, `chore`. A scope holds lowercase letters and hyphens. Scopes track the module graph:
  `codec`, `checksum`, `deflate`, `zlib`, `gzip`, `zstd`, `brotli`, and `bench` and `oracle` for
  the benchmarks and the differential checks. A scope outside that set is a warning.
- The description is imperative, starts with a lowercase letter, and ends without a period. The
  subject line stays at or under 72 columns.
- Exactly one blank line separates the body from the subject. A body line stays at or under 100
  columns, and the body stays at or under 3 paragraphs and 100 words. The diff shows the what, so
  the body says why. Reasoning that outlives the commit belongs in `docs/`.
- Stage by explicit path. Never `git add -A` and never `git add .`
- No `Co-Authored-By` trailer.
- Sign every commit. If signing fails, stop and ask the owner; never commit unsigned.
- Mutation results belong in the body when a commit adds or changes a check.

## Layout

- `build.zig` stays short: build options and the module graph. Helpers belong in `build/`.
- `src/<module>/` is one Zig module, declared in `build/modules.zig` with its imports listed. A
  module can only `@import` what the build gives it, so the dependency direction is enforced by
  the build and not by review. The graph is design §3; `tools/lint/module_graph.zig` pins it and
  `zig build graph-check` proves the compiler holds it.
- Each module owns its `constants.zig`. A comptime assert stays with the constant it pins.
- Tests belong in the file they test, or in `<file>_test.zig` beside it when the file would pass
  500 lines. Fixtures belong beside the module that reads them.
- `tools/` is developer tooling, run by `zig build` and never linked into the library. Its rule
  implementations come from pepegrillo, a lazy Zig package pinned by hash (decision 7). The
  differential checks and their oracles live here (decision 8).
- `tools/oracle/` holds the oracle bindings (`oracle.c`, `oracle.zig`), the RFCs' sample code
  (`rfc_samples.c`) and the oracles' self-test. `tools/differential/` holds the differential
  checks of stdx against them, and `tools/corpus/` the corpus fetcher, the corpus's names and the
  tool that cuts the HTTP payloads.
- `bench/` holds the benchmarks, their scripts and their committed results. The baselines are
  compiled here and in `tools/`, and nowhere else. `bench/costs/` measures docs/costs.md.
- `.github/workflows/` runs `tools/ci.sh` on each push (decision 19) and the costs on request
  (decision 20). A new check joins `tools/ci.sh`, never a workflow file.
- `docs/` is the design set. `docs/rfcs/` holds the RFCs.

## Performance

stdx runs inside other people's hot paths, so cost is part of the design and not a later pass.
The discipline is [Abseil's performance hints](https://abseil.io/fast/hints.html), applied to this
tree. Decision 14 holds the claims and design §8 the steps that measure them.

- **Measure; do not assume.** A performance claim carries a number, the command that produced it
  and the run it came from. Numbers come from GitHub's hosted Linux runners alone, x86-64 and
  aarch64, and a result is a ratio against a baseline inside one job (decision 20); macOS
  publishes no number (decision 10).
- **Know the order of magnitude before optimizing.** `docs/costs.md` holds the measured cost of an
  L1 hit, a cache miss, a branch mispredict, a copy of 64 octets and of 32 KiB, and a 64-bit bit
  buffer refill. Say which of them a change moves, and by how much.
- **Report honestly.** The median of five runs with the spread, every candidate in the same
  harness in the same run with pinned versions, and the runs where stdx loses.
- **Cross the caller's boundary in bulk.** One call decodes as much as the caller's buffers hold.
  A per-octet entry point is a per-octet cost.
- **The hot path allocates nothing and initialises nothing it will not read.** Starting a stream
  costs a constant, not a clear of the window.
- **Lay out structs for the cache.** Keep the fields one loop touches together, use the smallest
  integer that holds the value, and index a fixed array rather than follow a pointer.
- **Fast path first, slow path in its own function.** The checked path is the reference, and a
  fast path must produce the same octets as the checked path on every input (decision 16).
- **Precompute what cannot change.** Fixed Huffman tables, default distributions and the brotli
  dictionary are comptime data, generated from the RFC and checked against it.
- **A rewrite that only reads better is not a performance change.** Name the cost it removes.

## Ask before

- Changing a named limit.
- Adding a dependency. The library has none and imports no package. The ruled exceptions, none of
  which the library imports:
  - pepegrillo, the tooling `tools/` builds on (decision 7);
  - the oracles and baselines of `tools/` and `bench/` (decision 8): zlib and Wuffs, added at
    design §8 step 2, and libzstd, Google's brotli, zlib-ng and libdeflate, each added in the
    commit that first uses it;
  - the corpora of decision 15: Silesia, Canterbury and its large corpus, three.js, Bootstrap and
    CLDR as lazy packages, and the WHATWG HTML Standard's page, which `tools/corpus/fetch.sh`
    fetches and checks against a pinned SHA-256 because Zig fetches archives only.
  Every one is a lazy package pinned by hash, or a file pinned by SHA-256, and `build/oracle.zig`
  requests them only when a build passes `-Doracles`.
- Weakening an assertion or an invariant to make a test pass.
- Adding a module or an edge to the module graph.
- Leaving the checked reader or writer in a hot loop anywhere decision 16 does not name.
- Implementing anything decision 13 leaves out of version one.

## Commands

Change this section when a step adds or renames a command.

- Build: `zig build`. `-Drelease` builds ReleaseSafe; ReleaseFast and ReleaseSmall are not
  offered, because assertions stay on in production.
- Lint: `zig build lint`: cognitive complexity over `build.zig`, `bench`, `build`, `src` and `tools`, then
  the `tools/lint` rules: heap, io, determinism, unbounded-loop, relative-import, global-state,
  denied-words (no consumer's name in any `.zig` file), module-graph, markdown, file-length,
  magic-numbers, rfc-citation and input-index (no slice or index bound read from the input outside
  the checked reader and writer, decision 16). Every rule `tools/lint/main.zig` registers runs, and a canary
  tree in `build/lint.zig` proves it.
- Test: `zig build test`: the lint, then every module's unit tests, the tools' own tests,
  `graph-check` and `hook-check`. `zig build test-<module>` runs one module's tests with nothing
  else in the graph, which is what a mutation is measured against.
- Module graph: `zig build graph-check` compiles fixtures that import a wrapper, another codec, a
  package or the oracle bindings from inside `src/deflate/`, and requires each compile to fail.
- Oracles: `zig build oracle-selftest -Doracles` requires zlib and Wuffs to decode every stream
  zlib encodes from the corpora, at every level and strategy in all three containers, to the same
  octets. `zig build test-oracle -Doracles` runs the tests of the bindings and the self-test. The
  first build with `-Doracles` fetches about 260 MB of oracles and corpora; without the option,
  these steps fail and say so.
- Differential checks: `zig build differential-checksum -Doracles` requires every CRC-32 and
  Adler-32 path this CPU runs to equal the RFCs' sample code, zlib and Wuffs over every corpus
  file, at every length from 0 to 4096 at seeded offsets and starts, and whole under a seeded
  split. It builds stdx for the architecture's baseline CPU, so each SIMD path runs because
  detection found its instructions.
  `zig build differential-deflate -Doracles` requires stdx, zlib and Wuffs to decode the same
  octets from the raw DEFLATE, zlib and gzip streams zlib encodes from every corpus file: every
  level and strategy, with seeded window bits, memory levels and flush points, stdx under a seeded
  split. It then corrupts streams of each file's first 4 KiB, the containers' fields included,
  and requires stdx's verdict to equal both oracles' or to match an entry of
  `tools/oracle/verdicts.zig`.
- Corpora: `zig build corpus -Doracles` cuts the HTTP payloads into 1 KiB, 16 KiB and 1 MiB and
  installs every corpus file under `zig-out/corpus/`.
- Fuzzing: `tools/fuzz.sh <runs> [report.md]` runs Zig's fuzzer over every module that holds a
  `std.testing.fuzz` test, for `<runs>` runs each (`20K`, `2M`), and refuses to run when its list
  of modules misses one. It builds ReleaseSafe: Zig 0.16.0's test runner does not compile in fuzz
  mode in Debug. `tools/ci.sh` runs a short pass on every push, and the `fuzz` workflow a long one
  every night on both runners, keeping each runner's corpus between runs (decision 20).
- Costs: `zig build costs` prints docs/costs.md's rows for this host, built ReleaseFast.
  `bench/run.sh <report.md> costs` pins it to one core on Linux and records the run.
- DEFLATE benchmark: `zig build bench-deflate -Doracles` times the gzip decoders of zlib, zlib-ng,
  libdeflate, Wuffs and stdx, stdx's raw DEFLATE decoder with and without its fast path, each claim
  of decision 14 off against all on, and zlib's encoder at levels 1, 6 and 9, over every corpus file: every candidate interleaved in one
  run, the median of five runs with the spread. A second program then repeats the raw A/B with
  stdx built ReleaseFast, decision 17's measure of what the safety checks cost. `bench/run.sh <report.md> bench-deflate -Doracles`
  pins and records it. The `bench` workflow runs either benchmark on both hosted runners when a
  person asks (decision 20). stdx's encoder joins the candidates in design §8 step 9. Each
  published report is committed under `bench/results/`, as the workflow wrote it.
- Profile: `zig build bench-profile -Doracles` counts cycles, instructions and branch misses per
  decoded octet for each gzip decoder over every corpus file, through Linux's perf_event_open,
  and says so where the host exposes no counters. The `bench` workflow's `profile` option runs it
  on both hosted runners, after allowing a process to count its own events.
- Checksum benchmark: `zig build bench-checksum -Doracles` times every CRC-32 and Adler-32 path
  this CPU runs against zlib, Wuffs, libdeflate and zlib-ng, from 64 octets to 1 MiB, with the
  timing of `bench/timing/timing.zig`. `bench/run.sh <report.md> bench-checksum -Doracles` pins
  and records it, and the `bench` workflow offers it.
- CI: `tools/ci.sh [report.md]` runs every check above that needs no fixed machine and writes the
  report; `.github/workflows/main.yml` runs it on each push to main, on x86-64 and aarch64
  (decision 19). `tools/install_zig.sh` installs Zig 0.16.0 there, checked against a pinned
  SHA-256.
- Format: `zig fmt --check build.zig bench build src tools`, or `zig build fmt`.
- Commit messages: `zig build hooks` once after cloning points `core.hooksPath` at `.githooks`;
  `zig build lint-commits` checks `origin/main..HEAD`; `zig build install-commit-lint` installs the
  linter the hook runs. `.githooks/pre-push` is a copy of pepegrillo's `hooks/pre-push`, and
  `zig build test` fails when the two differ.
- RFCs: `cd docs/rfcs && shasum -a 256 -c SHA256SUMS`.
- Linux: Zig 0.16 fails to fetch a zip package on a machine whose global cache has no `tmp`
  directory. `tools/install_zig.sh` creates it; on a fresh Linux machine without that script, run
  `mkdir -p ~/.cache/zig/tmp` before the first `-Doracles` build.
- Packages: `tools/fetch_packages.sh` fetches every package, lazy ones included, retrying with
  growing pauses; `tools/ci.sh` and `bench/run.sh` run it first, because the corpus hosts drop
  connections and answer 500 now and then.
- Tooling: the first build on a machine fetches pepegrillo. A bump is `zig fetch
  --save=pepegrillo git+https://github.com/c4milo/pepegrillo#<commit>`; confirm `.lazy = true`
  survives it and copy the new hook. `zig build --fork=<pepegrillo checkout>` builds against a
  local pepegrillo instead of the pinned commit.

## Where the work stands

Progress is not tracked here. Open work, what comes next, and what is owed by whom are GitHub
issues at `https://github.com/c4milo/stdx/issues`. A check met is recorded once, in its step's
entry in design §8, with what was run, on what, and what it printed. Rulings are numbered in
docs/decisions.md. This file holds rules only.
