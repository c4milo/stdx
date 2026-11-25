# Contributing

stdx holds a high bar because it runs inside other programs' hot paths and reads octets that
nobody trusts. This page is the contributor's summary. [CLAUDE.md](CLAUDE.md) holds the full
rules, and a change follows them whoever writes it.

## Before you start

Read the documents a change must not contradict:

- [`docs/design.md`](docs/design.md): the module graph, the streaming contract, and the numbered
  build plan. Cite its sections by number, for example "§8 step 5".
- [`docs/decisions.md`](docs/decisions.md): every numbered decision, with the alternatives it
  beat. If a change would do something a decision rejected, raise it in an issue first.
- [`docs/invariants.md`](docs/invariants.md): the numbered invariants, each with the check that
  proves it.
- [`docs/costs.md`](docs/costs.md) and [`docs/performance.md`](docs/performance.md): the measured
  costs and the method that every performance change follows.

Open work and what comes next are [GitHub issues](https://github.com/c4milo/stdx/issues).

## Setup

stdx needs Zig 0.16.0 to build and test. After you clone it:

```bash
zig build hooks
zig build test
```

`zig build hooks` points git at `.githooks`, which checks commit messages before a push. `zig
build test` runs the lint first, then every module's tests and the tools' own tests. The first
build fetches pepegrillo, the package the tooling builds on.

Some checks need more:

- The differential checks and the benchmarks need `-Doracles`. The first build with it fetches
  about 265 MB: the other implementations and the corpora.
- `bench-json` and `bench-base64` need cargo and go, for their Rust and Go baselines.
- `zig build lean` needs lake, from elan or `tools/install_lean.sh`.

`tools/ci.sh` runs every check that needs no fixed machine, as CI does.

## The rules a change keeps

- **No I/O and no heap.** A codec makes no system call and holds no `Allocator`, tests included.
  The caller owns every state and buffer, and each size is a comptime constant. The lint refuses
  both.
- **Streaming, and able to resume.** Every call takes whatever input the caller has and writes
  what fits, and the next call resumes where it stopped. A whole-buffer helper is built on the
  streaming call, never the reverse.
- **Deterministic.** No clock, no random source and no pointer value reaches an output. An
  encoder writes the same octets on every host, in every build mode, and for every split of its
  input and output.
- **Every limit is named.** A limit lives in its module's `constants.zig`, never inline. Every
  loop is bounded.
- **Every RFC rule is cited.** A check that exists because an RFC requires it carries the RFC and
  the section in a comment on the line that makes it. Read the copies in
  [`docs/rfcs/`](docs/rfcs). Other implementations are test oracles and benchmark baselines.
  Their source may be read for its methods, and none of it is copied (decision 67).
- **Hostile input fails closed.** A corrupt stream returns an error value, with one value for
  each cause. Assertions are for programmer error, at contract points, and stay on in production.
- **Parsing goes through the checked reader**, and output through the checked writer. A hot loop
  leaves them only where decision 16 allows it, with the measurement it asks for.
- **Small pieces.** A function scores at most 15 on cognitive complexity, and a source file stays
  at or under 500 lines, tests included. Split rather than raise a limit.
- **Plain names.** Names spell words out, and the RFCs' own terms keep the RFCs' spelling. Prose
  says octet, not byte.
- **No consumer's name.** stdx never names a program that uses it, in its source or its
  documents.

## Tests are proved by mutation

A test must fail when the code it covers is broken. When you add or change a check, break it on
purpose and confirm a test fails. Report each mutation as `CAUGHT` or `NOT CAUGHT` in the commit
body or in the step's entry in `docs/design.md` §8. A `NOT CAUGHT` means a test is missing, so
write it.

## Performance claims

A performance claim carries a number, the command that produced it, and the run it came from.
Numbers come from GitHub's hosted Linux runners, x86-64 and aarch64. A result is a ratio against
a baseline in one job, the median of five runs with the spread (decision 20). Report the rows
where stdx loses too.

## Commits

Commits are [Conventional Commits](https://www.conventionalcommits.org/):
`type(scope): description`.

- The type is one of `feat`, `fix`, `docs`, `test`, `refactor`, `perf`, `build`, `ci` or `chore`.
- The scope, when present, is a module or an area: `codec`, `checksum`, `deflate`, `zlib`,
  `gzip`, `zstd`, `brotli`, `json`, `platform`, `bench` or `oracle`.
- The description is imperative and lowercase, with no period, and the subject line fits in 72
  columns.
- The body says why, in at most 3 paragraphs and 100 words, with lines of at most 100 columns.
  Reasoning that outlives the commit goes in `docs/`.

`zig build lint-commits` checks every commit since `origin/main`. Stage files by path, never with
`git add -A`.

## Asking first

Open an issue before you:

- change a named limit;
- add a dependency, or a module or an edge to the module graph;
- weaken an assertion or an invariant to make a test pass;
- leave the checked reader or writer in a hot loop that decision 16 does not name;
- build something that decision 13 leaves out of version one.

## Security

Do not report a vulnerability in an issue. [SECURITY.md](SECURITY.md) says where to send it.
