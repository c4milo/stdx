# Design decisions

Every entry here is a trade made on purpose: what it costs, and what it buys. Changing one means
re-arguing the trade, not editing the code. The README states what stdx does; this file states why.

Entries marked **owner** wait on a ruling and are not settled. Everything else is settled and is
re-argued, not edited. Entries 1 to 10 record the rules the owner set in the brief that started
stdx on 2026-09-25. Entries 11 to 18 were proposed the same day, as the decision records the
brief asked for before any codec code, and the owner ruled on each after reviewing it. Entries 19
and 20 came out of that review, entry 21 out of design §8 step 2, entries 22 to 25 out of step 11,
entry 26 out of the owner's review of CI, entry 27 out of the owner's request for JSON, entry 28
out of the owner's request that its state machines be proved, entry 29 out of [issue
13](https://github.com/c4milo/stdx/issues/13)'s DEFLATE decoder, entry 30 out of the JSON
baselines' numbers, entry 31 out of design §8 step 17's profile, entry 32 out of step 12's brotli
decoder, entry 33 out of the owner's ruling on what step 17's profile left, entry 34 out of the
losing files of [issue 13](https://github.com/c4milo/stdx/issues/13), entry 35 out of decision
17's json measurement, entry 36 out of design §8 step 9's comparison with libdeflate's output,
entry 37 out of design §8 step 18's non-ASCII rows, entry 38 out of the question entry 37 left,
how fast the check runs alone, entry 39 out of the owner's ruling on the gap entry 38 measured on
x86-64, entry 40 out of [issue 15](https://github.com/c4milo/stdx/issues/15)'s request for a
probe of the CPU, and entry 41 out of the owner's ruling once the benchmarks carried a `memset`
of their own.

## Scope and shape

1. **stdx is a library of compression codecs, and it stands alone.** Ruled by the owner on
   2026-09-25. It holds DEFLATE with its zlib and gzip containers, Zstandard and brotli, each with
   an encoder and a decoder. colibri's decision 90 moved the DEFLATE decoder here from colibri, so
   that another project can take a codec without taking an HTTP library.
   - stdx never depends on colibri and never names a consumer in its source.
     `tools/lint/denied_words.zig` refuses the names in every `.zig` file (invariant 15).
   - colibri is the first consumer: its h11 decodes the `gzip` and `deflate` transfer codings of
     RFC 9112 §7.2 with stdx. Other projects want the encoders and decoders for the HTTP content
     codings of RFC 9110 §8.4: `gzip`, `deflate`, `br` and `zstd`.
   - Entry 27 amends this item: stdx also holds a JSON encoder and decoder, the `json` module.

   The alternatives refused, in colibri's decision 90: the decoder inside colibri, which makes
   every other project take HTTP to get a codec; and stdx holding colibri's `core` as well, which
   would have made stdx carry limits that belong to HTTP.

2. **No I/O.** Ruled by the owner on 2026-09-25. A codec reads octets the caller already has and
   writes into storage the caller owns. It opens no file or socket, starts no thread, and makes no
   syscall. Cost: a caller that has a file or a socket writes the loop that feeds the codec. Gain:
   the codec runs under any I/O model the caller has (blocking, `io_uring`, an event loop, a
   kernel bypass), and a test drives it with nothing but slices. `tools/lint/io.zig` refuses the
   syscall, filesystem, network, thread, process and logging surfaces of `std` under `src/`
   (invariant 2). Entry 40 names the one exception: `platform`, whose probe a program calls once
   when it starts, may read macOS's `sysctlbyname`, and no other module may import it.

   The alternative refused: the `std.Io.Reader` and `std.Io.Writer` interfaces of Zig 0.16, which
   `std.compress.flate` takes. They put a vtable call on every refill and a blocking model in the
   API, and colibri's survey found that `std.compress.flate` cannot resume when its input runs out.

3. **No heap.** Ruled by the owner on 2026-09-25, as colibri's decision 35 ruled it for colibri.
   There is no `Allocator` anywhere in `src/`: no parameter, no field, no `std.heap`, and no test
   that allocates. The caller owns every state, window, table and hash chain, and places each one
   where it chooses: static storage, its own arena, or memory it mapped. Each size is a comptime
   constant the codec exports, per codec and per encoder level (decision 12).

   Cost: a stream that asks for more than the size the caller chose is refused, never
   accommodated, and a decoder of a format whose window the stream chooses (brotli, Zstandard)
   holds the largest window it accepts. Gain: nothing to allocate, fail or leak; no
   `error.OutOfMemory` in any signature; and `@sizeOf` accounts for all of a codec's memory.

   The alternatives refused: an allocating constructor, which puts `error.OutOfMemory` into the
   API and makes stdx decide where memory lives; and allocation through callbacks the caller
   supplies (zlib's `zalloc`, libzstd's `customMem`), which keeps a failure path in every call
   that no format requires.

4. **Streaming, and able to resume.** Ruled by the owner on 2026-09-25. Every call takes whatever
   input the caller has and writes what fits. It ends by saying whether it needs more input, needs
   more room, or is done, and the next call resumes where it stopped. Work per call is bounded by
   the octets it consumed and wrote. A whole-buffer helper is built on the streaming call, never
   the reverse. Decision 11 proposes the call.

   The alternative refused: a whole-buffer core with a streaming wrapper, the shape of libdeflate,
   tinf and puff. It needs the whole coded body in memory at once, which a caller receiving a
   body in pieces cannot give. colibri's survey found that Zig's `std.compress.flate` cannot
   resume when its input runs out and never compares the checksums it reads, so a caller would
   hold the whole body and check the checksums itself.

5. **Deterministic.** Ruled by the owner on 2026-09-25. No clock, no PRNG, and no pointer value in
   any output. An encoder's output is a pure function of its input and its parameters, byte-identical
   across hosts and build modes. A decoder's output and verdict are a pure function of its input.
   Decision 11 adds that the way a caller splits the input and the output across calls is not a
   parameter: it changes no octet of the output (invariant 5).

   Cost: an encoder cannot adapt to elapsed time, and a heuristic that would read a pointer's
   alignment reads an offset instead. Gain: a failure found on one seed reproduces on every host,
   and a cache or a content hash over encoded output stays valid across hosts and releases of the
   same version.

6. **One module per codec, plus a checksum module, each exported by name.** Ruled by the owner on
   2026-09-25, as colibri's decision 86 exports colibri's modules. `build/modules.zig` creates
   `checksum`, `deflate`, `zlib`, `gzip`, `zstd` and `brotli` with `b.addModule`, so a dependent
   reaches one with `dependency.module("gzip")` and compiles no other codec. The library keeps no
   process-wide mutable state (invariant 4), so a dependent runs codecs on its own threads.
   Decision 11 proposes a seventh module, `codec`, for what the six share.

   The alternative refused: a dependent that imports stdx's source files by path. It would bypass
   the module graph that keeps each codec from reaching another (invariant 14).

   Entry 27 adds an eighth module, `json`, exported the same way, and entry 40 a ninth,
   `platform`, which no other module imports.

## Tooling and checks

7. **stdx's developer tooling comes from pepegrillo, a lazy Zig package pinned by hash.** Ruled by
   the owner on 2026-09-25, as colibri's decision 36 ruled it. The lint driver and its generic
   rules, the cognitive-complexity scorer, the commit-message linter and the pre-push hook come
   from github.com/c4milo/pepegrillo, pinned at `6fcb273`, its main branch on that date.
   `build.zig` requests it only when stdx is the root build, so a project that depends on stdx
   never fetches it. `tools/` keeps stdx's configuration of each rule with the fixtures that pin
   it, and the two rules only stdx has: `module-graph` and `rfc-citation`. `.githooks/pre-push` is
   a copy of pepegrillo's hook, and `zig build test` compares the two byte for byte.

   The alternatives refused are colibri's: a copy of the tooling per repository, which drifts
   within a day; a vendored copy with a sync step per change; a git submodule; and a `.path`
   dependency, which resolves wrong inside a worktree.

8. **Other implementations are test oracles and benchmark baselines, compiled in `tools/` and
   `bench/` only.** Ruled by the owner on 2026-09-25.
   - zlib and Wuffs are ruled in for the DEFLATE family (stdx issue 1, 2026-09-25). zlib is
     fetched from its release archive, and Wuffs as the single file `wuffs-v0.4.c` from
     github.com/google/wuffs-mirror-release-c. Each is a lazy package pinned by hash.
   - libzstd (github.com/facebook/zstd), Google's brotli (github.com/google/brotli), zlib-ng and
     libdeflate were proposed, and the owner ruled all four in on 2026-09-25. Each is a lazy
     package pinned by hash, and joins CLAUDE.md's list of ruled dependencies in the commit that
     adds it.
   - Each does two jobs. In `tools/`, it is an oracle: the same inputs through stdx and through it
     give the same octets, and stdx refuses what it refuses (decision 15). In `bench/`, it is a
     baseline, run in the same harness in the same run as stdx (decision 10).
   - Nobody working on stdx reads an oracle's source (decision 9). An oracle is a black box that
     takes octets and returns octets or a refusal.

   The alternative refused: linking any of them into the library. colibri's decision 89 weighed
   Wuffs, zlib, zlib-ng, zlib-rs and miniz_oxide as the library itself and refused each: C that
   every consumer would compile, Rust that every consumer would need a toolchain for, or four CVEs
   in zlib's decoder and checksums.

9. **The RFCs, never another implementation's source.** Ruled by the owner on 2026-09-25. stdx is
   written from RFC 1950, 1951, 1952, 7932, 8878 and 9659, copied unmodified into `docs/rfcs/` with
   `docs/rfcs/SHA256SUMS`. RFC 9841 is copied so stdx can refuse what it adds (decision 13). Each
   was checked for a later revision on 2026-09-25, and `docs/rfcs/README.md` lists the errata that
   change what a codec does. Every check that exists because an RFC demands it cites the RFC and
   the section on the line that does the checking (invariant 16).

   Cost: stdx cannot copy a known-good trick from a baseline, and must find each one again from
   the format and from first principles, then prove it with a measurement. Gain: every rule in
   the code traces to a sentence in a document the owner can read, and stdx inherits no defect
   and no licence from another codebase. Decision 18 asks about the one place an RFC defines a
   rule by reference to a document that is not an RFC.

10. **Real numbers come from Linux, measured one way.** Ruled by the owner on 2026-09-25, as
    colibri's decision 32 ruled it for colibri. Entry 20 amends it: the Linux hosts are GitHub's
    hosted runners, and a result is a ratio within one job. Entry 25 adds a literal-heavy text to
    its corpora.
    - Benchmarks run on Linux alone, with the machine written down beside the numbers: CPU model,
      core count, kernel, compiler versions. macOS publishes no number.
    - Each result is the median of five runs, with the spread.
    - Every candidate runs in the same harness in the same run, at a pinned version: zlib,
      zlib-ng, libdeflate, Wuffs, libzstd and brotli, as far as decision 8's rulings admit them.
    - The corpora are Silesia, Canterbury, and HTTP-shaped payloads (HTML, JSON, JavaScript and
      CSS) at 1 KiB, 16 KiB and 1 MiB (decision 15).
    - Each report gives decoding and encoding throughput, and the ratio per level, and includes
      the runs where stdx loses.
    - `docs/costs.md` holds the measured costs that every speed claim is priced against
      (decision 14).
    - Anything under about 5% is noise until shown otherwise, as colibri's decision 33 states.

    The alternatives refused: best-of-N, which reports the favourable tail of the noise; and a
    number from the development Mac, which predicts nothing about the Linux hosts stdx's
    consumers run on.

## The decision records

11. **The streaming contract every codec shares.** Proposed on 2026-09-25, the first decision record
    the owner asked for. Ruled by the owner on 2026-09-25, after a review of the proposal. The owner
    accepted the `codec` module, the overrun into the caller's output past `written`, and an
    assertion for a call after `done`. Amended by the owner on 2026-09-26, at design §8 step 9: an
    encoder's `init` clears its hash heads (under **State and sizes**).

    **A seventh module, `codec`.** Decision 6 names six modules. The status a call ends with, the
    counts it reports and the checked reader and writer are the same for all five codecs, so they
    need a home that every codec imports and that imports nothing. The proposal is a module named
    `codec`. The alternatives refused:
    - A copy of the types in each codec. A caller that dispatches on the HTTP content coding
      would switch over five `Status` types that only look alike, and the copies would drift.
    - The types in `checksum` or in `deflate`. `zstd` would then import a module whose concern it
      does not share, and `deflate` would stop being the smallest thing a DEFLATE user compiles.
    - The same shape in each codec with a comptime test that the shapes match. The types would
      still be distinct, so the dispatching caller keeps its five switches.

    **The call.** Every decoder and every encoder is a struct the caller places. One call:

    ```zig
    // In codec:
    pub const Status = enum { needs_input, needs_room, done };
    pub const Progress = struct { consumed: usize, written: usize, status: Status };
    pub const Flush = enum { none, flush, finish };

    // In each codec, for example gzip:
    pub fn init(decoder: *Decoder) void;
    pub fn decode(decoder: *Decoder, input: []const u8, output: []u8) Error!Progress;

    pub fn init(encoder: *Encoder) void;
    pub fn encode(encoder: *Encoder, input: []const u8, output: []u8, flush: codec.Flush) codec.Progress;
    ```

    - `consumed` counts the octets of `input` the call took. The caller never presents them
      again: a call that returns `needs_input` took every octet of `input`, even when they end in
      the middle of a code, and the state holds the partial code.
    - `written` counts the octets of `output` that hold decoded or encoded data, from
      `output[0]`. A call may write any octet of `output` while it works, so the octets past
      `written` are scratch (decision 16); only `output[0..written]` carries meaning.
    - `needs_input`: the call took all of `input` and the stream is not finished. A caller with
      no more input has a truncated stream.
    - `needs_room`: the call filled all of `output` and has more to write, or input left to
      process. The caller gives more room, and may give more input.
    - `done`: the stream ended, and every check its format carries has passed (invariant 11).
      `consumed` stops at the stream's last octet. Octets after it stay in `input[consumed..]`
      for the caller: trailing data, the next gzip member, or the next Zstandard frame.
    - Read-ahead: a decoder may take up to 8 octets into its bit buffer before it knows it needs
      them. At the end of every call but one that returns `needs_input`, it hands back every whole
      octet it has not used, by leaving it out of `consumed`, so the caller presents it again. A
      call that returns `needs_input` keeps only the octets of the code it could not finish, and
      all of them belong to the stream. So the octets after the end of a stream are always in the
      input of the call that returns `done`, and never in the state.
    - Progress: a call either consumes or writes at least one octet, or returns `done`, or
      returns the status an empty slice explains (`needs_input` with empty `input`, `needs_room`
      with empty `output`). A caller loop therefore never spins (invariant 8).
    - An encoder cannot fail: every input is valid, and misuse is a programmer error that an
      assertion catches. `Flush.none` lets it hold input back to find matches; `Flush.flush` makes
      it write everything taken so far so that a decoder can produce all of it, and the stream
      continues; `Flush.finish` ends the stream. Once a call passes `finish`, every later call
      passes it too, with the input the earlier call did not consume.
    - After `done`, the caller calls `init` before the next stream. A `decode` or `encode` call
      after `done` without `init` is a programmer error, and an assertion catches it.
    - The call takes no flag for the end of input. Every format marks its own end: the last
      DEFLATE block, the zlib and gzip trailers, a Zstandard frame's last block, brotli's ISLAST.
    - `input` and `output` must not overlap, and an assertion checks it at entry.

    **Errors.** Each codec has its own error set, with one value per cause, each cited to the
    sentence that requires the refusal. The set is the union of two named sets, so a caller can
    tell the two kinds of refusal apart without listing names:

    ```zig
    // In codec:
    pub const Refusal = enum { corrupt, unsupported };

    // In each codec, for example zlib:
    pub const Corrupt = error{ InvalidHeaderCheck, InvalidWindowSize, ChecksumMismatch, ... };
    pub const Unsupported = error{PresetDictionary};
    pub const Error = Corrupt || Unsupported;
    pub fn refusal(err: Error) codec.Refusal;
    ```

    - `Corrupt` holds every way the input breaks its RFC: a bad header check, a malformed block, a
      wrong checksum, a distance past the output.
    - `Unsupported` holds every valid feature stdx refuses: `error.PresetDictionary` (RFC 1950
      §2.3), `error.DictionaryUnsupported` (RFC 8878 §3.1.1.1.3), `error.WindowTooLarge`
      (decision 12) and `error.LargeWindow` (RFC 9841 §6).
    - A refusal leaves the state unusable until `init`.

    **State and sizes.** The state is a plain value. It holds no pointer, not even into itself, so
    the caller may move or copy it between calls and continue from the copy (invariant 12). Its
    size is `@sizeOf`, known at comptime. Where a format leaves a size to the decoder or to the
    encoder's level, the type is a comptime function of the choice, with a named instance for the
    usual one:

    ```zig
    const Http = zstd.Decoder(.{ .window_len_max = zstd.constants.http_window_len });
    const Fast = deflate.Encoder(.{ .level = 1 });
    comptime std.debug.assert(@sizeOf(Http) <= 9 * 1024 * 1024);
    ```

    A decoder's `init` costs a constant. It writes the few dozen octets of state a stream starts
    from and does not clear the window or any table. No octet of history is read before this
    stream writes it (invariant 10), so neither uninitialised memory nor the octets of a previous
    stream in the same state is ever observed. That comparison is what makes a pool of decoders
    safe to share between messages from different peers, so invariant 10 tests it on every copy
    path.

    An encoder's `init` also clears its hash heads: `1 << hash_bits` positions of 2 octets, 32 KiB
    at level 1 and 64 KiB at levels 6 and 9. A head holds the last position with its hash, and each
    search for a match starts there. A head left by a previous stream, or never written, can name
    a position this stream has written, so the search would try it, and the output would depend
    on more than this stream's input (invariant 5). The clear is estimated at about one copy of
    32 KiB in docs/costs.md, 568 ns on x86-64 and 393 ns on aarch64, and has not been measured on
    its own. The alternatives it beat:

    - A sparse set recording which heads this stream wrote, so that `init` clears nothing: a second
      dependent load for each search, and a second table as large as the heads.
    - A head checked against the current position alone: a stale head below the position passes
      the check, so the search still depends on it.

    **Whole-buffer helpers.** Each codec builds these on the streaming call:

    ```zig
    pub const Whole = struct { consumed: usize, written: usize };
    pub fn decode_all(decoder: *Decoder, input: []const u8, output: []u8) (Error || error{ Truncated, NoSpaceLeft })!Whole;
    pub fn encode_all(encoder: *Encoder, input: []const u8, output: []u8) error{NoSpaceLeft}!usize;
    pub fn encoded_len_max(input_len: usize) usize;
    ```

    `decode_all` makes one streaming call with all the input and all the output, and turns
    `needs_input` into `error.Truncated` and `needs_room` into `error.NoSpaceLeft`, the two
    operational errors CLAUDE.md names. For gzip and Zstandard it calls `init` and continues while
    input remains, because a gzip file is a series of members (RFC 1952 §2.2) and Zstandard data is
    a series of frames (RFC 8878 §3). `encoded_len_max` bounds the encoded size of any input, so a
    caller sizes the output of `encode_all` once.

    **What colibri's h11 needs.** colibri's owner ruled on it on 2026-09-25, in colibri's decision
    91 (colibri commit `f925839`), after the colibri session read these questions. Each ruling, and
    what in this contract serves it:
    - At most one compression coding per body, so h11 holds one decoder per message. Instances
      still compose, one's output feeding another's input, because they share no state
      (invariant 4).
    - `deflate` is the zlib container alone, and a raw stream fails its header check. The raw
      `deflate` module stays for other callers.
    - No cap on the decoded size. h11 counts `written` per call, and the output goes into the
      application's buffers.
    - A `gzip` body may hold several members, each checked. The decoder reports `done` at the end
      of each member, with the octets after it left in `input`. h11 calls `init` and continues
      with them, as `decode_all` does. Octets that do not start a member fail the next member's
      header check.
    - Octets after the coded stream make the message malformed. `done` with `consumed` shows h11
      exactly where the stream ended and what input remains; stdx never swallows it.
    - Two verdicts: a corrupt body, and a feature refused. `refusal` gives the class of every
      error.
    - Decoders live in a pool the caller owns, taken per message. The state is a plain struct of
      comptime size that holds no pointer, so the caller places it in any slot, moves it, and
      resets it with `init` (invariant 12).
    - Earlier, the colibri session asked for input split anywhere down to one octet and output
      room down to one octet. `consumed` takes every octet and a partial code waits in the state,
      and the checked path writes one octet at a time when that is all the room there is
      (decision 16).

    The alternatives refused:
    - Cursor structs in the shape of Wuffs's I/O buffers, where history is read from the part of
      the output buffer the caller kept. It saves the copy into the window when a caller decodes
      into one large buffer. It costs a second API shape, unlike the slice-and-counts contract
      colibri's design §4.1 uses, and a caller must keep old output unchanged. The copy it saves is
      at most one copy per output octet, and at most 32 KiB per call for DEFLATE; decision 14 prices
      it. Reopen if step 7's benchmark shows the copy above the noise floor.
    - A decoder that pulls input through a callback, as uzlib and puff do. It inverts control and
      blocks, which decision 4 forbids.
    - A flag for the end of input on every decoder call. Every format marks its own end, so the
      flag would carry nothing a decoder uses, and a caller could set it wrong.
    - A window the caller hands to `init` as a separate slice, so one type serves every window
      size. The state would then hold a pointer and could move only with its window, and the ring
      buffer's mask would stop being a comptime constant.
    - An encoder that returns an error union. No input is invalid to an encoder, so the error set
      would be empty and every caller would handle it anyway.
    - One flat error set per codec, with each caller keeping its own list of which names mean a
      refused feature. Every caller would copy the list, and a name stdx adds would land in the
      wrong class until each caller noticed.
    - A fourth status for the end of a gzip member, so the decoder crosses members by itself. The
      caller would still need to know whether the body may end there, which `done` already says,
      and the owner fixed three statuses.

12. **The memory each decoder and each encoder level takes, and what happens when a stream asks for
    more.** Proposed on 2026-09-25, the second decision record the owner asked for. Ruled by the
    owner on 2026-09-25, after a review of the proposal. The owner accepted a Zstandard HTTP window
    of 2^23 for decoding and at most 8,000,000 octets for encoding, a brotli default of WBITS 24
    with every tree's table held, and the refusal of a distance past the window a zlib header
    declares.

    **Decoders.** The window is the history a back-reference reaches. The other state is tables,
    counters, and the buffers a format needs between calls. Budgets are upper bounds. The step
    that writes each decoder pins its exact `@sizeOf` with a comptime assert, and `bench/`
    measures each baseline's memory through its allocator hook, never an estimate.

    | Decoder | Window | Other state, budget | What a stream that asks for more gets |
    |---|---|---|---|
    | `deflate` | 32 KiB, fixed by RFC 1951 §3.2.5 | 16 KiB of tables and state | It cannot ask for more: no distance exceeds 32,768. A distance past the start of the output is `error.DistanceTooFar` (RFC 1951 §3.2.3) |
    | `zlib` | `deflate`'s | `deflate`'s plus 16 octets | CINFO above 7 is `error.InvalidWindowSize` (RFC 1950 §2.2). FDICT is `error.PresetDictionary` (RFC 1950 §2.3) |
    | `gzip` | `deflate`'s | `deflate`'s plus 32 octets | Nothing: the gzip header states no window |
    | `zstd`, HTTP instance | 8 MiB, 2^23 octets (RFC 9659 §3) | 128 KiB for a block that spans calls, 128 KiB of literals, 32 KiB of tables | A Window_Size over the instance's limit, or a single-segment frame whose Frame_Content_Size is over it, is `error.WindowTooLarge` (RFC 8878 §3.1.1.1.2 allows the refusal) |
    | `brotli` | 16 MiB, 2^24 octets for WBITS 24 (RFC 7932 §9.1) | 3 MiB of prefix-code tables for 256 trees of each kind; 17 KiB of context maps | WBITS over the instance's `window_bits_max` is `error.WindowTooLarge` (RFC 7932 §12 advises a constrained decoder to check the window against its limit). RFC 9841's large-window signature is `error.LargeWindow` (RFC 7932 §9.1 calls the pattern invalid; RFC 9841 §6 gives it its meaning) |

    What each row rests on:
    - **DEFLATE.** RFC 1951 §3.3 requires a decoder to accept every distance up to 32,768, so the
      window is fixed, and §3.2.3 forbids a distance past the start of the output. zlib's CINFO
      states the window the encoder used (RFC 1950 §2.2), and allows no value above 7, a window
      of 32 KiB. The decoder keeps 32 KiB whatever CINFO says. A distance past the window CINFO
      declares is refused as `error.DistanceTooFar`: RFC 1950 states no decoder rule for it, so
      stdx fails closed (decision 15), and step 6 records the oracles' verdicts on it.
    - **Zstandard, the HTTP instance.** RFC 9659 §3 says decoders of the `zstd` content coding
      MUST support a Window_Size up to and including 8 MB. It does not say whether a MB is 10^6 or
      2^20 octets. The instance holds 2^23 octets, which covers both readings. A Window_Size is
      2^(10+E) plus a multiple of 2^(7+E) (RFC 8878 §3.1.1.1.2), so the representable values
      nearest 8,000,000 are 7.5 MiB and 8 MiB, and a limit of 8,000,000 would refuse a frame that
      RFC 9659's other reading requires. The encoder takes the other side: its HTTP levels never
      require more than 8,000,000 octets.
    - **Zstandard, a larger instance.** `zstd.Decoder(.{ .window_len_max = ... })` takes any power
      of two, for a caller outside HTTP that wants more. The window and the size of the type grow
      with it. Nothing else changes.
    - **Zstandard block buffer.** A compressed block's sequences are read backward from the
      block's last octet (RFC 8878 §3.1.1.3.2.1.2), so a block must be whole before its sequences decode.
      When the caller's input holds the whole block, the decoder reads it in place; when a block
      spans calls, the decoder copies it into a buffer of Block_Maximum_Size, 128 KiB
      (RFC 8878 §3.1.1.2.4).
    - **brotli.** RFC 7932 §1.4 and §9.1 require a decoder to accept WBITS up to 24, so the
      default instance holds 16 MiB. A caller may build a smaller instance with
      `brotli.Decoder(.{ .window_bits_max = 22 })`, which refuses larger streams and no longer
      decodes every compliant stream. RFC 7932 §12 advises a decoder to grow its window as the
      stream grows. Without a heap, stdx cannot grow, but `init` touches no window octet, so a
      caller that maps the window lazily commits only the pages a stream writes.
    - **brotli tables.** A meta-block may carry up to 256 prefix codes each for literals,
      insert-and-copy lengths and distances (RFC 7932 §9.2, NTREESL, NBLTYPESI and NTREESD). A
      decoder that builds tables only for the tree a block switch selects would rebuild one per
      block switch, and a stream could switch every symbol, so the budget holds all of them. The
      exact worst-case table size for an alphabet, a root width and RFC 7932's canonical codes is
      computed by a tool at the brotli decoder's step and pinned there. The 3 MiB above assumes 8
      root bits, about 2.5 KiB per 256-symbol table, and is the number that step must beat.

    **Encoders.** Every encoder keeps a window of input (the history its matches reach plus the
    input it has not yet encoded), its match finder's tables, and the symbols of the block it is
    building. It writes a block into the caller's output as it goes, resuming where it stopped,
    so it holds no copy of its own output, except where a format needs the block's size before its
    content (Zstandard's Block_Size, RFC 8878 §3.1.1.2.3). Decision 13 proposes the levels.

    | Encoder level | Window of input | Match finder | Block state | Budget |
    |---|---|---|---|---|
    | `deflate` 1: greedy, one probe | 64 KiB: 32 KiB history, 32 KiB ahead | 16,384 hash heads of 2 octets: 32 KiB | 16,384 symbols of 4 octets: 64 KiB, and 3 KiB of counts and codes | 163 KiB |
    | `deflate` 6: lazy, hash chains | 64 KiB | 32,768 heads and 32,768 chain links of 2 octets: 128 KiB | 67 KiB | 259 KiB |
    | `deflate` 9: lazy, longer chains | 64 KiB | 128 KiB | 67 KiB | 259 KiB |
    | `zstd` 1: one hash table | 512 KiB window plus 128 KiB ahead | 2^16 entries of 4 octets: 256 KiB | 128 KiB of literals, 512 KiB of sequences, 128 KiB for the block's compressed octets | 1.6 MiB |
    | `zstd` 3: two hash tables | 2 MiB plus 128 KiB | 2^17 and 2^16 entries: 768 KiB | 768 KiB | 3.6 MiB |
    | `brotli` 1: one pass, no context modeling | 256 KiB | 2^15 entries of 4 octets: 128 KiB | 256 KiB of commands | 0.6 MiB |
    | `brotli` 5: hash chains and literal context modeling | 4 MiB | 2 MiB | 2 MiB of commands and histograms | 8 MiB |

    Each level also takes a smaller comptime window, `zstd.Encoder(.{ .level = 3, .window_log =
    17 })`, which shrinks the window and the tables with it for a caller whose messages are small.
    The brotli rows are the least certain: the brotli encoder's step writes its own record before
    any code, and may change them.

    The alternatives refused:
    - A decoder that sizes its window to what each stream declares. With no heap, that means a
      caller-supplied window per stream, which is the separate-slice API decision 11 refused.
    - A Zstandard HTTP instance of 8,000,000 octets. It refuses frames of 8 MiB, which one
      reading of RFC 9659 §3 requires a decoder to accept.
    - A brotli default below WBITS 24, which saves memory and fails RFC 7932's compliance clause.
    - A brotli decoder that rebuilds a table on each block switch, with a cache of built tables.
      It saves most of 3 MiB, and a stream that switches on every symbol makes it rebuild a
      table per output octet.

13. **The scope and order of version one.** Proposed on 2026-09-25, the third decision record the
    owner asked for. Ruled by the owner on 2026-09-25, after a review of the proposal: the DEFLATE
    encoder second, the levels as proposed, and nothing further into version one. The owner's brief
    proposed: the DEFLATE family decoder, then the Zstandard decoder, the brotli decoder, the
    DEFLATE encoder, the Zstandard encoder and the brotli encoder. This entry proposed one change:
    the DEFLATE encoder moves to second.

    **The order.**
    1. The gzip, zlib and DEFLATE decoder: stdx issue 1, which colibri waits on.
    2. The DEFLATE encoder, levels 1, 6 and 9, in all three containers.
    3. The Zstandard decoder.
    4. The brotli decoder.
    5. The Zstandard encoder, levels 1 and 3.
    6. The brotli encoder, levels 1 and 5.

    **Why the DEFLATE encoder moves to second.**
    - It completes one coding on both sides of HTTP. The HTTP clients in wide use accept `gzip`,
      so a server with a gzip encoder compresses for nearly all of them. A client needs a
      decoder only for the codings it lists in Accept-Encoding, so it can list `gzip` alone until
      the other decoders land.
    - It is the cheapest encoder to get right. It reuses what the decoder builds: the canonical
      codes of RFC 1951 §3.2.2, the bit order, the containers, the checksums, the oracles and the
      corpora.
    - It is where the encoder checks get built: the round trip through the reference decoders,
      the output hashes across hosts and modes, and the split independence of invariant 5. Every
      later encoder reuses them.
    - It widens the decoder's differential inputs. zlib's encoder makes one family of block
      splits, code lengths and match choices. A second encoder makes another, and stdx's decoder
      and both oracles must agree on both.
    - The cost: the Zstandard decoder waits one step, and a client that wants `zstd` responses
      waits with it.

    **Why the rest keep the owner's order.** Decoders come before their encoders because a
    decoder has a fixed finish line: every valid stream decodes, and every invalid one is refused.
    An encoder's finish line is a ratio and a speed, which the decoders are needed to check.
    Zstandard's decoder comes before brotli's because it is smaller: no 122,784-octet dictionary
    and no context modeling, and RFC 9659 fixed its memory for HTTP. The Zstandard encoder comes
    before brotli's because its fast levels are what a server uses for content it compresses per
    response, while brotli's strongest qualities are slow and mostly used ahead of time, where
    any tool will do. If a consumer needs `br` responses decoded before `zstd`, steps 3 and 4 swap
    without touching anything else.

    **Inside version one, because the formats require it.**
    - Multi-member gzip (RFC 1952 §2.2), multi-frame Zstandard and skippable frames (RFC 8878 §3
      and §3.1.2).
    - `Flush.flush` in every encoder, which a streamed HTTP response needs.
    - `encoded_len_max` for every encoder.

    **Out of version one.**
    - RFC 9841: shared dictionaries, large windows and the framing format. The `br` content coding
      is RFC 7932, and shared dictionaries serve Compression Dictionary Transport, which the owner
      left out. The decoder refuses the large-window signature by name.
    - Zstandard dictionaries (RFC 8878 §5). RFC 8878 §6 says content of the registered media type
      should not use one. A frame that names one is refused.
    - zlib preset dictionaries. RFC 1950 §2.3 requires a decoder to refuse FDICT when the
      enclosing format defines no dictionary, and HTTP defines none.
    - Dictionary training, multithreaded compression and Compression Dictionary Transport, which
      the owner left out. Threads also contradict decision 2.
    - Telling raw DEFLATE from zlib in the HTTP `deflate` coding. RFC 9110 §8.4.1.2 names the zlib
      format, and stdx fails closed. A caller that wants to accept raw streams can try both.
    - Zstandard's long-distance matching, negative levels, and brotli qualities above 5.
    - Formats that are not the four HTTP codings: Deflate64, LZW (`compress`), LZ4, Snappy, xz.

    Nothing else is argued in. Entry 27 argues JSON in, at the owner's request.

14. **Where the speed comes from.** Proposed on 2026-09-25, the fourth decision record the owner
    asked for. Ruled by the owner on 2026-09-25, after a review of the proposal. The owner chose
    checksum paths per architecture (x86-64 and aarch64, register operands only) with a table path
    for every other target and as the oracle, and the predictions stated before any code. Each claim
    below names the cost it removes, priced against a row of `docs/costs.md`, and the check that
    tests it. Each fast path is an A/B against the checked path on the Linux runners, five runs,
    median and spread (decision 10), and stays only when it wins by more than the noise. The last
    column names the baselines whose own documentation or published write-ups describe the same
    technique. It is a list of what to compare against, and nobody confirms it by reading their
    source (decision 9). A dash means none of them documents it that stdx found; the benchmark
    compares against all of them either way.

    DEFLATE decoder:

    | Claim | Cost it removes (`docs/costs.md` row) | Test | Baselines documented to do it |
    |---|---|---|---|
    | S1. A 64-bit bit buffer, refilled with one unaligned 8-octet little-endian load and no loop | A branch per octet refilled; one refill per several symbols (64-bit refill) | A/B against the octet-at-a-time refill of the checked path | libdeflate, Wuffs |
    | S2. Primary tables of 11 bits for literal/length and 8 for distance, whose entries carry the base and the count of extra bits, so most symbols take one lookup | A second lookup and its branch per symbol (L1 hit, branch mispredict) | The fraction of one-lookup symbols per corpus, counted in a test build; A/B against 9 and 6 bits | libdeflate; zlib documents 9-bit root tables |
    | S3. Two literals from one lookup when both codes fit the table width | One lookup and one data-dependent branch per literal pair (branch mispredict) | A/B with the pairing off | None of the baselines documents it |
    | S4. Match copies of 8 or 16 octets at a time, overrunning into the output's scratch room; a fill for distance 1 and a repeated pattern for distances under 8 | A branch per copied octet (memcpy of 64 octets) | A/B against the octet copy of the checked path | libdeflate, zlib-ng (chunk copy), Wuffs |
    | S5. Decoding straight into the caller's output, with one copy of the call's last 32 KiB into the window at the end of the call | A second write of every output octet (memcpy of 32 KiB per call at most) | Copies counted per call in a test build; A/B against decoding into the window and copying out | Wuffs |
    | S6. `init` writes a few dozen octets and clears no window or table | A 32 KiB clear per stream, which dominates a 1 KiB body (memcpy of 32 KiB) | Start-of-stream cost on the 1 KiB HTTP corpus against each baseline's reset | zlib.h: inflate defers allocating its window to the first call that needs it |
    | S7. The fixed codes of RFC 1951 §3.2.6 as comptime tables | A table build per fixed block; a small body is often one fixed block | The fraction of fixed blocks in the 1 KiB corpus from zlib's encoder; A/B with the tables built per block | — |
    | S8. A table build that writes only the entries the code uses | Clearing unused entries; bounds the cost of a stream of tiny dynamic blocks (invariant 17) | Entries written per octet consumed, counted in a test build, on the worst-case generators | — |
    | S9. CRC-32 by carry-less multiplication (x86 PCLMULQDQ, Arm PMULL) or Arm's CRC32 instructions; Adler-32 with vectors and a deferred modulo | A table-driven CRC-32 runs at about the speed of a fast decode, so it comes close to doubling the cost per output octet; step 4 measures both | Checksum throughput against each baseline; the checked table path is the oracle | zlib-ng, libdeflate, Wuffs |
    | S10. The checksum runs over each call's output once, while it is still in cache | A second pass over output that left L1 (cache miss) | A/B against checksumming after the whole stream | — |
    | S11. A length and its distance's code in one literal/length entry, when both fit the table, so one lookup decodes both | The distance's lookup, a second load each match waits on (L1 hit) | A/B with the entries of a length and its distance apart | — |
    | S12. A length's extra bits in its literal/length entry, when its code and the extra bits fit the table | Reading the extra bits of most matches: a shift and a mask each | A/B with every table built plain | — |

    Zstandard and brotli decoders:

    | Claim | Cost it removes | Test | Baselines documented to do it |
    |---|---|---|---|
    | Z1. The four Huffman-coded literal streams of RFC 8878 §4.2.2 decoded in one interleaved loop | A serial dependency between lookups (L1 hit latency) | A/B against one stream at a time | libzstd |
    | Z2. A two-symbol table when the literal codes are short | One lookup per two literals | A/B | libzstd |
    | Z3. The default distributions of RFC 8878 §3.1.1.3.2.2 as comptime tables | A table build per block that uses them | A/B | — |
    | Z4. Sequence execution with 16-octet copies and overrun, as S4 | As S4 | As S4 | — |
    | Z5. Sequences read from the caller's input when the whole block is there | A copy of up to 128 KiB per block | Copies counted in a test build | — |
    | B1. RFC 7932's 122,784-octet dictionary and its transforms as comptime data, checked against Appendix A's CRC-32 0x5136cb04 | Generating or loading the dictionary per process | A comptime assert on the CRC-32 | Every brotli decoder carries the dictionary |
    | B2. The context lookup tables of RFC 7932 §7.1 as comptime data | A computation per literal | A/B | — |
    | B3. Every tree's table built once per meta-block (decision 12) | A table build per block switch | Entries written per octet consumed on a switch-per-symbol stream | — |

    Encoders:

    | Claim | Cost it removes | Test | Baselines documented to do it |
    |---|---|---|---|
    | E1. A 4-octet hash by one multiply and a shift; match length by 8-octet XOR and a count of trailing zeros | A compare and a branch per octet of every candidate | A/B against octet compares | zlib-ng (compare256) |
    | E2. One code path per level, chosen at comptime | A runtime switch on the level in the inner loop (branch mispredict) | The level's code size and speed against a runtime-dispatched build | — |
    | E3. The exact bit cost of a stored, fixed and dynamic block computed from the symbol counts before writing, so each block takes the cheapest (RFC 1951 §3.2.3) | Output larger than the stored form of the same input | Ratio per level against zlib at the same level | zlib |
    | E4. When the first call passes `finish` with all the input, matches are found in the caller's input with no copy into the window | A copy of every input octet | A/B on the 1 MiB corpora | libdeflate takes whole buffers only |
    | E5. A 64-bit bit writer that stores 8 octets at a time when the output has the room, resuming octet by octet when it does not | A branch per output octet | A/B against the checked writer | — |

    **Where stdx expects to win, match and lose,** reported all three ways, as colibri's decision
    31 does:
    - **Win, plausibly:** 1 KiB and 16 KiB messages, where starting a stream and crossing the
      call boundary dominate (S6, S7), and memory per stream, which is fixed, known and placed
      by the caller.
    - **Match, at best:** 1 MiB DEFLATE decoding against libdeflate, which is years deep and needs
      the whole buffer; checksums against zlib-ng's and libdeflate's vector paths; Zstandard
      decoding against libzstd.
    - **Lose, probably:** every encoder's strongest levels against libzstd, Google's brotli and
      libdeflate's level 12; and anything a baseline does with AVX-512 that stdx has not written.

    The alternative refused: tuning before the checked path exists and is proved. Every claim
    above is measured against a correct path, never against a guess.

    **What design §8 step 7 found.** Recorded on 2026-09-26; step 7's entry holds the runs.
    - S1, S2, S4, S5 and S7 beat the noise on both runners and stay. S3 did not: with the pairs
      off, the median was 1.00 on both runners, and the 1 KiB bodies ran faster, so the pairs
      left with their code.
    - S10 beats the noise on the N2 and ties on the EPYC 7763. It stays, since a container sees
      one call's output at a time, and a checksum after the stream is the caller's to run.
    - S7's test as written finds nothing to time: zlib at level 6 writes no fixed block for the
      HTTP corpus. Step 7 times S7 over zlib's fixed strategy instead.
    - S4's repeated pattern for distances under 8 is not written: few matches take such a
      distance. Since decision 29, the assembly loops copy a match whose distance is below 16
      with one table lookup (TBL on aarch64, PSHUFB on x86-64); the Zig loop still leaves it to
      the step out of line.
    - The predictions: the 1 KiB bodies beat zlib, libdeflate and Wuffs on the N2 but lose to
      zlib-ng, and 1 MiB decoding stays behind libdeflate, at a median of 0.69 of its speed on
      the N2 and 0.66 on the EPYC 7763.

    **What [issue 13](https://github.com/c4milo/stdx/issues/13) found.** Recorded on 2026-09-28;
    design §8 step 7 holds the runs.
    - S12 beats the noise. With it off, the N2 runs at a median of 0.97 of all on and the EPYC
      7763 at 0.99, and all on wins by more than 5% on 14 and 12 files (run
      [36380436703](https://github.com/c4milo/stdx/actions/runs/36380436703)). It stays.
    - S11 tied with S12 alone in the Zig loop: 1.00 at the median on both runners. A table that
      mixes combined and plain entries makes the branch between the two mispredict, and building
      plain each block whose matches mostly would not combine removed those mispredictions and
      none of the cycles (runs [36412089015](https://github.com/c4milo/stdx/actions/runs/36412089015)
      and [36412091480](https://github.com/c4milo/stdx/actions/runs/36412091480)). The owner kept
      S11 until the assembly loops of decision 29 measured it again.
    - They did, and it stays. The combination read and branched on every entry of a block's
      table, in an order no predictor follows, and each extra pass cost the M1 2 to 4% of a text
      decode, so the tie had hidden S11's worth. Once it visits only the pairs it joins (dac6cd9),
      S11 off runs at a median of 0.96 of all on on both runners, and all on wins by more than
      5% on 16 of the N2's files and 18 of the EPYC 9V74's, off on none (run
      [36478169575](https://github.com/c4milo/stdx/actions/runs/36478169575)). S12 off runs at
      0.97 and 0.92.

15. **The checks.** Proposed on 2026-09-25, the fifth decision record the owner asked for. Ruled by
    the owner on 2026-09-25, after a review of the proposal. The owner chose to fail closed where an
    RFC lets a decoder choose, and let a verdict entry land when it cites its RFC section and
    carries its mutation results, with no separate ruling per entry. The owner chose the payload
    sources below.

    **The corpora.** Each is a lazy package pinned by hash, fetched by `tools/` and `bench/` and
    never by the library:
    - Silesia, the 12-file corpus at `https://sun.aei.polsl.pl/~sdeor/corpus/silesia.zip`.
    - Canterbury: `cantrbry.tar.gz` and `large.tar.gz` from `https://corpus.canterbury.ac.nz`;
      since 2026-09-29 from the `corpora` release of this repository, a copy of the two tarballs
      that the pinned hashes verify, after canterbury.ac.nz put its site behind a bot-management
      rule that turns Zig's fetch away (every run failed at the fetch from 03:18 UTC that day; the
      copies came through the Internet Archive). The owner ruled the mirror the same day.
    - HTTP-shaped payloads: HTML, JSON, JavaScript and CSS, each cut to 1 KiB, 16 KiB and 1 MiB by
      a tool, from files whose licences let stdx fetch and run them. The owner chose the sources
      on 2026-09-25: the WHATWG HTML Standard's single page (CC-BY 4.0, about 13 MB); the Unicode
      CLDR JSON data (Unicode licence); three.js's `three.module.js` (MIT); and Bootstrap's CSS
      files (MIT), concatenated and repeated to reach 1 MiB. Each comes from its npm tarball where
      it has one, so the hash pins an archive. Bootstrap's 1 MiB piece repeats about 500 KB, a
      distance DEFLATE's 32 KiB window cannot reach and Zstandard's and brotli's can, so its ratios
      favour those two, and each report says so beside the number.
    - Entry 25 adds a literal-heavy text, derived from Silesia's dickens rather than fetched.

    **Decoders against the oracles.** `tools/oracle/` runs the same inputs through stdx and through
    every ruled oracle, and requires byte-identical output.
    - Inputs, DEFLATE family: every corpus file, encoded by zlib at every level (0 to 9) and every
      strategy (default, filtered, Huffman-only, RLE, fixed), in all three containers. A seed
      draws windowBits (9 to 15), memLevel (1 to 9), and flush points of every kind zlib offers,
      which put empty stored blocks and odd bit positions in the stream. Once stdx's encoder
      exists, its outputs join the inputs.
    - Inputs, Zstandard and brotli: every corpus file, encoded by the reference encoder at every
      level or quality, with the window, checksum and content-size options a seed draws.
    - Splits: a seed draws the size of each input piece and each output room from a mix of 0, 1,
      2 to 16, 17 to 4096 and the rest, so every stream is decoded one octet at a time somewhere,
      and with empty calls between. At a seeded call, the harness copies the state to another
      address and continues from the copy (invariant 12).
    - Each stream is decoded three ways: stdx's streaming call under the seeded split, stdx's
      whole-buffer helper, and each oracle. Output, verdict and the `consumed` count at `done` must
      agree.

    **Encoders against the reference decoders.** Every stdx encoder output decodes to its input
    through each ruled reference decoder and through stdx's own. Every level, every corpus file, a
    seed's flush points and a seed's splits. Beside the round trip:
    - The same input at the same level and flush points gives the same octets under every split
      (invariant 5).
    - The SHA-256 of each encoder output over the corpora is committed, and must match on macOS
      arm64 and Linux x86_64, in Debug and in ReleaseSafe.
    - `encoded_len_max` bounds every output, incompressible input included.
    - After `Flush.flush`, decoding the output so far gives exactly the input so far.

    **Corruptions.** A seed turns valid streams into invalid ones: flipped bits, from 1 to 8, at
    offsets weighted toward headers and trailers; a cut at every offset for streams under 4 KiB and
    at seeded offsets above; wrong checksums and sizes; header fields set to values the RFC
    forbids (CM, CINFO, FDICT, reserved flags, BTYPE 11, extreme HLIT and HDIST, the reserved bit
    of a Zstandard frame header, WBITS patterns); and octets appended after a valid stream. Each
    input gets a verdict from stdx and from every oracle: accepted with its output, refused, or
    incomplete (input ended first). Then:
    1. stdx accepts and an oracle refuses: a failure, unless a verdict entry allows it.
    2. stdx refuses and every oracle accepts: a failure, unless a verdict entry allows it.
    3. stdx and every oracle accept: the outputs must be identical.
    4. The oracles disagree: the RFC decides, not a vote. Where the RFC says must, stdx does what
       it says. Where the RFC lets a decoder choose, stdx refuses, because it fails closed, and a
       verdict entry records the case.

    A verdict entry lives in `tools/oracle/verdicts.zig`. It names the codec, the shape of the
    input, stdx's verdict, each oracle's verdict, the RFC section, and the decision behind stdx's
    choice. A disagreement with no entry fails the run until an entry is added, and adding one
    is a change to a check, so it carries its mutation results.

    **stdx's verdicts where an RFC lets a decoder choose.** These are the entries known before any
    code:
    - gzip: stdx checks CRC32 and ISIZE, which RFC 1952 §2.3.1.2 lets a decoder skip. It checks
      the header's CRC16 when FHCRC is set (RFC 1952 §2.3.1), which Wuffs skips. It refuses a
      reserved FLG bit, as the same section requires. It ignores FTEXT, MTIME, XFL and OS, and
      skips FEXTRA, FNAME and FCOMMENT without storing them, with no limit on their length but the
      input's.
    - gzip, whole-buffer helper: it decodes every member (RFC 1952 §2.2) and refuses octets after
      the last member that do not start another.
    - zlib: stdx checks FCHECK, CM, CINFO and ADLER32, as RFC 1950 §2.3 requires, refuses FDICT,
      and ignores FLEVEL, which §2.3 allows. It refuses a distance past the window CINFO declares
      (decision 12), on which RFC 1950 is silent.
    - DEFLATE: an over-subscribed code, a code with no end-of-block symbol, and a code-length
      repeat with nothing to repeat are refused. An incomplete code is refused, except the single
      one-bit distance code and the single zero-length distance code that RFC 1951 §3.2.7
      describes. Distance codes 30 and 31 and length codes 286 and 287 are refused when they
      appear, because RFC 1951 §3.2.6 says they never occur.
    - Zstandard: the reserved bit is refused (RFC 8878 §3.1.1.1.1.4) and the unused bit ignored
      (§3.1.1.1.1.3). A frame whose decoded size differs from its Frame_Content_Size
      (§3.1.1.1.4) is refused, as §8 warns. An offset of 0, which a repeat offset can produce
      (§3.1.1.5) and which names no decoded octet (§3.1.1.4), is refused; the RFC does not name
      the case. Content_Checksum is compared when present, and skippable frames are skipped
      (§3.1.2).
    - brotli: every "should be rejected as invalid" of RFC 7932 is a refusal, nonzero padding bits
      included.

    **Fuzzing, with Zig's fuzzer.**
    - In each codec's module, with no oracle: arbitrary input under a split the fuzzer draws. It
      checks that nothing panics, that the invariants' assertions hold, that the fast path writes
      what the checked path writes (decision 16), and, once the encoder exists, that
      decode(encode(x)) is x at every level and flush pattern.
    - In `tools/oracle/`, with the oracles linked: arbitrary input through stdx and every oracle,
      judged by the rules above.
    - The seed corpus is the committed fixtures of each module. A crash or a disagreement the
      fuzzer finds becomes a fixture and a named test.
    - Zig's fuzzer runs on Linux, so fuzzing runs there, and each step's entry in design §8
      records how long it ran and what it found. Entry 26 amends this item: fuzzing runs on macOS
      arm64 too.

    **Worst cases (invariant 17).** Generators build valid and invalid streams that maximize work
    per octet: a DEFLATE stream of minimal dynamic blocks, each forcing a full table build; a
    Zstandard frame of tiny blocks with new FSE tables; a brotli stream that switches block type
    every symbol. A test build counts table entries written and symbols decoded per octet consumed,
    which is deterministic, and `zig build test` bounds the count. `bench/` reports the octets per
    second on the same streams.

    **Mutations.** Every check lands with its mutations reported as `CAUGHT` or `NOT CAUGHT`
    (CLAUDE.md).

    The alternatives refused:
    - Majority vote among the oracles. Two oracles that share a lenience would outvote the RFC.
    - Following one oracle's verdict. zlib and Wuffs already disagree on the gzip header's CRC16,
      and stdx would inherit whichever lenience it followed.
    - Fuzzing without oracles. It finds crashes, and misses a decoder that accepts what it should
      refuse.

16. **Where a hot loop may leave the checked reader and writer.** Proposed on 2026-09-25, and ruled
    by the owner on 2026-09-25, after a review of the proposal: no safety turned off without a
    measurement and a ruling, and the `input-index` rule at step 3. It resolves the first conflict
    the owner named: fast decoders use table-driven multi-symbol lookups, wide bit buffers,
    word-at-a-time copies that overrun on purpose, and SIMD, while CLAUDE.md sends all parsing
    through a checked reader and all output through a checked writer.

    **The rule.**
    - The checked `codec` reader, writer and bit reader are the reference path. Every codec
      decodes and encodes through them alone, and each codec's checked path lands and passes
      every check of decision 15 before any fast path exists.
    - A fast path is a function this entry names, in the table below. Its caller enters it only
      after checking, once, that at least `input_slack` octets of input and `output_slack` octets
      of output remain. Both are named constants of the codec.
    - Inside, the loop checks the same two margins at the top of every iteration, one compare
      each, and returns to the checked path when either fails. The margins bound the most one
      iteration reads (a refill of 8 octets) and writes (a longest match plus its overrun), so
      every access in an iteration is in bounds by construction.
    - Zig's safety checks stay on (ReleaseSafe). Every slice access is still checked by the
      compiler, and a wide access is written `input[position..][0..8]`, so one check covers 8
      octets. The margin makes those checks predictable branches, and the checks turn a wrong
      margin into a panic instead of a write past the buffer.
    - A fast path writes the octets the checked path writes, on every input. A comptime field of
      the codec's options turns the fast paths off, the tests and the fuzzer build both, and the
      fuzzer runs the two against each other.
    - A fast path copies a long literal run or a long match in chunks of at most
      `chunk_len_max` octets, a named constant, so one iteration's writes stay bounded whatever
      length the stream asks for.
    - Overrun writes stay inside `output`. A call may write any octet of `output`, and only
      `output[0..written]` means anything (decision 11). Reads stay inside `input` and inside the
      history already written (invariant 10).
    - SIMD uses `@Vector` through the same slices. Inline assembly, for carry-less multiplication
      or the CRC32 instructions, takes register operands only, loaded through checked slices, and
      never an address.
    - `@setRuntimeSafety(false)` appears in one place, the brotli command loop, ruled below on
      2026-09-29. An exception needs an A/B of the same function with safety on and off on the
      Linux runners, five runs each over all three corpora, a gain above the 5% noise floor, a new
      row in this entry with the numbers, and the owner's ruling.
    - A lint rule, `input-index`, lands with the `codec` module (design §8 step 3). Outside the
      reader, the writer and the functions below, it refuses an index or a slice bound derived
      from a value the reader produced, as colibri's `peer-index` rule does for peer input.

    **The brotli command loop without Zig's checks.** Ruled by the owner on 2026-09-29, after the
    A/B the rule above asks for: the claim then named `loop_checks`, off against on in one job on
    both runners (runs [36542507833](https://github.com/c4milo/stdx/actions/runs/36542507833) and
    [36542514694](https://github.com/c4milo/stdx/actions/runs/36542514694), at 0957f69). The N2
    decodes the command-heavy files 1.10 to 1.22 times as fast without the checks, 1.11 and 1.12 at
    the corpus's median, the 1 KiB bodies 1.03 to 1.06, whose time is the header's, and the
    all-literal text 1.04; an EPYC 9V74 1.10 at the median, css-1m 1.31 and E.coli 0.90. The
    proposal came after the by-construction work decision 17 puts first (design §8 step 12): the
    straight loop in a frame of its own and the cuts around it.
    - Every function under `decoder_fast.run`, the straight loop, the chain and what they inline,
      runs with `@setRuntimeSafety(false)`: no bounds, overflow or `unreachable` check, the loop's
      own assertions among them. The margins and the per-write checks of this entry and decision 32
      stay, as does the checked path, which every refusal still reaches.
    - The claim `unchecked_loop` of `src/brotli/claims.zig` holds it, on by default. Off, the checks
      return: bench-brotli prices them in each run, and the tests and the fuzzer compare both
      settings with the checked path.
    - Decision 24's measures, once ruled, cover this loop as they cover the assembly loops.

    **The fast paths, with the measurement each must show.** The DEFLATE rows exist since design
    §8 step 7, which records their A/Bs. Each row's numbers are filled in by the step that writes
    it, and a row whose A/B does not beat the checked path by more than the noise is deleted with
    its code.

    | Function | Step | Input slack | Output slack | Measurement that admits it |
    |---|---|---|---|---|
    | DEFLATE symbol loop (S1, S2) | 7 | 8 octets, one refill per iteration | 258 plus 16 | Throughput against the checked path on all three corpora: a median of 11.68 times on the N2 and 9.29 on the EPYC 7763 in step 7 |
    | DEFLATE and brotli match copy (S4) | 7, 12 | none | 258 plus 16 for DEFLATE; `chunk_len_max` plus 16 for brotli | As above |
    | Zstandard literal decoding, four streams (Z1, Z2) | 11 | 8 octets before each stream's position, read backward | none: literals go to the state's literal buffer, whose size is fixed | As above |
    | Zstandard sequence execution (Z4) | 11 | none | `chunk_len_max` plus 16 | As above |
    | brotli command loop | 12 | 8 octets per refill | `chunk_len_max` plus 16 | As above |
    | brotli code lengths, in the header | 12 | 8 octets per refill | none: the lengths go to the state's array, whose size is fixed | Throughput against the loop off, two N2 jobs a side at 442ea0c against d478f94 (runs 36503381259 and 36503386029 against 36501231721 and 36501237307): the 1 KiB HTTP bodies +2.7 to +4.0%, json-16k +2%, xargs.1 +3 to +5%, no file behind by more than 1% in both; the x86-64 jobs drew different CPUs. The experiment the owner allowed on 2026-09-28; the owner approved the row on the N2 numbers the same day, and the x86-64 pair follows from the workflow's `base` input |
    | Every encoder's bit writer (E5) | 9, 13, 14 | none | 8 octets | Encode throughput against the checked writer |
    | JSON encoder token loop (J11) | 18 | none: an item's octets are its own slice, read inside it | none: it checks the room an item takes before it writes the item | Throughput of batches against every item through `Encoder.run`, over bench-json's workloads |
    | JSON encoder token loop with runtime safety off, at the caller's choice (J11, decision 35) | 18 | as J11 | as J11 | Throughput with safety off over on in the loop's two files, run [36515654643](https://github.com/c4milo/stdx/actions/runs/36515654643): CLDR's texts 1.071 and qlog's records 1.053 on the N2, 1.057 and 1.089 on the EPYC 9V45 |
    | JSON decoder token loop (J10) | 18 | none: it checks a token's octets are there before it reads them, and a string's a block of 16 at a time | 16 octets: a string's last block, stored past its end | Throughput of batches (decision 33) against every token through `Decoder.run`, over bench-json's workloads |

    The alternatives refused:
    - The checked reader and writer everywhere, with no fast path. It is the simplest, and
      colibri's survey shows what it gives up: Wuffs, which has a fast path, decodes at 1.5 to 1.9
      times zlib's speed, and the decoders without one run at zlib's speed or below.
    - Raw pointers with safety off in every hot loop, as C decoders do. It is the fastest, and a
      wrong margin becomes memory corruption. That is the class of CVE-2016-9841 and
      CVE-2022-37434 in zlib's decoder, which colibri's survey lists.
    - Slack the caller provides: buffers that carry extra octets past the length they report. It
      changes every caller's contract, and it breaks the output room of one octet h11 asked for.

17. **Assertions in production, and what they cost in the inner loops.** Proposed on 2026-09-25, to
    resolve the second conflict the owner named. Ruled by the owner on 2026-09-25, after a review of
    the proposal: no assertion per symbol in a fast path, and a proposal whenever the safety checks
    cost more than 5% on any corpus.

    **What stays on.** The build offers Debug and ReleaseSafe only. In ReleaseSafe the compiler
    keeps three kinds of check: slice bounds, integer overflow, and `unreachable`, which is what
    `std.debug.assert` compiles to. stdx adds its own assertions, about two per function. One
    exception stands, ruled under decision 16 on 2026-09-29: the brotli command loop runs without
    them, its margins and per-write checks in force.

    **Where assertions live.**
    - At every public call's entry and exit: the state is valid, `input` and `output` do not
      overlap, the counts are inside the slices, and the status matches the counts (invariants 7
      and 8).
    - At every fast path's entry and exit: the margins hold, and the bit buffer holds at most 64
      bits.
    - Once per block: a built table's counts sum to what the code lengths say, and a block's
      decoded length fits what its header declared.
    - None per symbol and none per copied octet inside a fast path. The checked path may assert
      per symbol, because it runs only for the last octets of a call, within the fast path's
      margins.
    - Arithmetic in the inner loops uses `usize` positions and a `u64` bit buffer, so the
      overflow checks the compiler keeps are branches that never fire. The wrapping operators
      appear only where the format itself wraps: CRC and Adler arithmetic, and hash multiplies.

    **The measurement,** made by each codec's fast-path step on the Linux runners, and written
    into this entry:
    1. The same benchmark built ReleaseSafe and ReleaseFast. The difference bounds the cost of
       every safety check together. ReleaseFast is a measuring device only, and never offered to
       a caller.
    2. A test build that counts the assertions executed per octet decoded. The count times the
       `docs/costs.md` row for a predicted branch prices stdx's own assertions apart from the
       compiler's checks.
    3. When the first measurement shows more than 5% on any corpus, the entry says which checks
       cost it, and proposes either moving assertions out of a loop or an exception under decision
       16. The owner rules on either.

    **brotli's measurement, 2026-09-28**, at 7520761 in run
    [36487926168](https://github.com/c4milo/stdx/actions/runs/36487926168): built ReleaseFast, the
    decoder runs at a median of 1.17 of its ReleaseSafe speed on the N2 and 1.23 on the EPYC 9V74,
    and at up to 2.40 on the 1 KiB HTTP bodies, past this entry's 5% (design §8 step 12). The owner
    ruled the same day on the route: remove the cost by construction first, rewriting the hot code
    so the compiler proves its bounds and writes nothing it need not, with every check still on;
    measure on the runners; and propose an exception under decision 16 only for what remains.

    **json's measurement, 2026-09-28**, counted with perf's counters on the N2 in one run of each
    build, not decision 20's five (design §8 step 18). Built ReleaseFast, bench_json's stdx takes
    16% to 18% fewer cycles a token decoding CLDR's texts and qlog's records, and 29% to 36% fewer
    encoding them (runs [36508599164](https://github.com/c4milo/stdx/actions/runs/36508599164)
    and [36508601413](https://github.com/c4milo/stdx/actions/runs/36508601413)), past this entry's
    5%. With stdx's own assertions turned off and the compiler's checks on, it takes 1% to 3% fewer
    decoding and 6% to 10% fewer encoding (runs
    [36509679849](https://github.com/c4milo/stdx/actions/runs/36509679849) and
    [36509681736](https://github.com/c4milo/stdx/actions/runs/36509681736)): the rest is the
    compiler's bounds and overflow checks. With safety off in the files of claims J10's and J11's
    token loops alone, it takes 13% fewer cycles decoding and 11% to 12% fewer encoding (runs
    [36511601584](https://github.com/c4milo/stdx/actions/runs/36511601584) and
    [36511603467](https://github.com/c4milo/stdx/actions/runs/36511603467)). The json fast paths
    take the route the owner ruled for brotli's. Construction took the decoder loop's share first:
    it reads and writes slices whose lengths the compiler knows, where indices into the whole input
    and output cost each access a check (design §8 step 18). The owner ruled on 2026-09-28: once
    construction has taken what it can, propose an exception under decision 16 for the token loops
    of claims J10 and J11, with the A/B that entry asks for.

    The alternatives refused:
    - Safety off in the hot functions only, with `@setRuntimeSafety(false)`. It turns every
      assertion there into an assumption the optimizer relies on, which is the opposite of a
      check. Decision 16 admits it only function by function, with a measurement and a ruling.
    - A build option that turns assertions off for callers. A caller would ship with it off, and
      the invariants would stop being checked where it matters.
    - Assertions per symbol in the fast paths. On a 1 MiB body, that is millions of branches per
      call to check what the margin already proves.

18. **XXH64, which RFC 8878 defines by reference.** Proposed on 2026-09-25. Ruled by the owner on
    2026-09-25, after a review of the proposal: read xxHash's specification document. A Zstandard
    frame's Content_Checksum is the low 32 bits of XXH64 with seed 0 (RFC 8878 §3.1.1). RFC 8878
    cites xxHash by a URL and gives no algorithm, and no RFC defines it. Decision 9 allows the RFCs
    alone.

    Proposal: read xxHash's own specification document (`doc/xxhash_spec.md` in
    github.com/Cyan4973/xxHash), which is a specification in prose and not an implementation's
    source. Copy it unmodified into `docs/specs/`, pinned by commit and SHA-256 like the RFCs, and
    check stdx's XXH64 against libzstd's checksums through the oracle.

    The alternatives refused:
    - Skipping the check. It is what decision 4 names as a defect of Zig's DEFLATE decoder.
    - Reading libzstd's or xxHash's source. Decision 9 forbids it.

19. **Every check that needs no fixed machine runs on each push to main.** Ruled by the owner on
    2026-09-25, during the review of entries 11 to 18, as colibri's decision 47 rules it for
    colibri.
    - `tools/ci.sh` runs the lint, the tests, the graph check and the oracle checks, and writes a
      report. `.github/workflows/main.yml` runs it on a hosted runner on each push to main. A new
      check joins `tools/ci.sh`, never the workflow file, so CI and a person run the same thing.
    - Entry 20 amends this item. Published numbers were to come from a machine of the owner's; the
      owner then ruled that costs, benchmarks and fuzzing run on the hosted runners too, in jobs of
      their own.
    - Both land with design §8 step 2.
    - Entry 26 amends this item: `main.yml` runs `tools/ci.sh` on three runners, macOS arm64 among
      them.

    The alternative refused: every check run by hand, with each step's entry recording what was run.
    A check nobody runs between steps drifts, and the owner asked for CI.

20. **Costs, benchmarks and fuzzing run on GitHub's hosted Linux runners.** Ruled by the owner on
    2026-09-25, when asked which Linux machine decision 10 needs. It amends entry 10, which asked
    for a machine written down beside the numbers, and entry 19, which kept published numbers off
    the hosted runners.
    - The jobs run on pinned runner labels, never `ubuntu-latest`: `ubuntu-24.04` for x86-64 and
      `ubuntu-24.04-arm` for aarch64, both free for a public repository, with 4 virtual CPUs and
      16 GB each. Both architectures are measured, so both checksum paths of decision 14 are.
    - A hosted runner is a virtual machine on shared hardware. Its CPU model can change from one
      run to the next, other tenants load the host, nobody pins a governor, and it may expose no
      performance counters. So the method changes in four ways:
      - Every comparison happens inside one job. stdx and each baseline run on the same virtual
        machine in the same run, interleaved candidate by candidate, so a slowdown lands on all of
        them alike. A result is a ratio against a baseline in that job. An absolute number from one
        run is never compared with another run's.
      - Each report records the runner label, the image version, the CPU model and core count from
        `/proc/cpuinfo`, the kernel, the Zig version and the run's URL, and is committed under
        `bench/` with that record.
      - The noise floor is the larger of 5% and the spread the job measured for that candidate. A
        claim of decision 14 must beat it, in the same job, on both architectures it applies to.
      - `docs/costs.md` is filled from one named run per architecture, in nanoseconds. Cycles are
        filled only where the runner exposes the counters, and marked unavailable otherwise.
    - Fuzzing runs in scheduled jobs of fixed length per target, within the runner's job time
      limit. The corpus a run grows is kept between runs, and a finding becomes a committed
      fixture and a named test (decision 15).
    - Entry 26 amends this item: fuzzing runs on macOS arm64 too. The costs and the benchmarks stay
      on Linux.
    - Amended by the owner on 2026-09-28, for [issue 13](https://github.com/c4milo/stdx/issues/13)'s
      losing DEFLATE files and again for the brotli decoder, in two ways. A change may stay when
      it beats the target files' own run-to-run spread in two jobs and costs no other file more
      than the larger of its spread and 1% in both, in place of the 5% floor above; the 1% is for
      the shifts of code placement, which measured 0.6 to 1.0% on 1 MiB files whose decode never
      ran the changed code. And a temporary `perf-*` branch may run the bench workflow for a
      change's A/B, deleted once its numbers are recorded. The x86-64 runner draws a different CPU
      from run to run, four models on 2026-09-28, and a ratio against Google's brotli differs by
      12% between two of them, so the workflow's `base` input benchmarks the change's base first
      in the same job, and an x86-64 pair counts only when one job holds both.
    - Amended by the owner on 2026-09-29, after design §8 step 18's UTF-8 run: a file that moves
      past the larger of its spread and 1% in both jobs counts as placement, neither the change's
      loss nor its gain, when the bench program built at both commits runs that file on code
      identical apart from its addresses. The change is then judged on the code it touches. The
      proof builds the benchmark for the runner's target at both commits with `zig build-exe` and
      the module flags `build/` gives it, the C baselines replaced by stand-ins, and compares every
      function with its addresses masked; a file whose path runs a function that differs still
      counts. There, `content_len_vector` shrank by 52 octets and moved the 167 functions after
      it, the walks among them, by 48 or 52 octets: on the N2, five text files lost 1.2% to 4.3%
      in both runs and bible.txt encoded 12% to 15% faster, on the walks' unchanged instructions.
      The alternatives refused: counting such a move as a loss on its architecture, which blocks a
      change for where the linker placed code the change did not touch; and reading "every job"
      across both architectures alone, which lets a real loss on one of them pass.
    - Amended by the owner on 2026-09-30, after design §8 step 12's header cuts for the small
      bodies: a file whose ratio to the baseline moves past the larger of its spread and 1% in
      both jobs is not the change's loss when stdx's own speed on that file stays within its
      spread in every job and the baseline's speed moved instead. The proof splits the move into
      both decoders' speeds, the change phase's over the base phase's, in every table of the job
      that times them. There, E.coli's ratio to Google's brotli fell 1.4% and 1.5% in both N2 runs
      of the cuts (36648491985 and 36648500622), and 1.8% and 2.0% in the fill's own pair, because
      Google's decoder ran 1.4% to 2.3% faster in the job's second phase; stdx's E.coli speed moved
      under 0.4% in the decoding table, the fast path's and the ReleaseFast table, where Google's
      own speed held within 0.3%. The alternatives refused: a one-time exception, which leaves the
      next change to argue the same case; and holding the change for a third pair, which would
      time Google's second phase again.
    - Amended by the owner on 2026-09-30, after the brotli benchmark's detection fix: a change to a
      benchmark's harness alone, with the library's functions identical apart from their addresses
      on a runner, is judged there on the library, so the harness's own functions are not the
      function that differs of the placement amendment above. There, the harness stopped running
      `codec.Features.detect()` for each decode (13dc23a): x86-64's small bodies gained 7% to 62% in
      both jobs of runs 36676450570 and 36676457924, while on the N2 xargs.1 fell 1.5% and 1.6%, its
      library functions identical, stdx's unchanged checked path moving the same 1.1% to 1.3%, and
      only `run_once`, two instructions shorter, differing. The alternatives refused: landing it as
      a one-off, which leaves the next harness change to argue the same case; and holding it, which
      keeps charging stdx a cost a caller pays once.
    - Amended by the owner on 2026-09-30, after the brotli decoder's context map loop: a change that
      only moves code, every function's body the same apart from its addresses, need not win; it
      lands when its pair shows no loss past placement, and a change measured on top of it is judged
      on its own code. There, the context map loop won on both runners and lost world192.txt on the
      N2 on hot code it had only moved; 3abeeda started the decoder's hot functions on 64-octet
      lines, as the json module's kernels are, and its pair (runs 36733153860 and 36733165581) moved
      no file in both jobs. The alternatives refused: amending the placement rule for files whose
      changed function runs only in the header, which leaves every later change moving the hot
      loops; and holding the map loop.
    - Amended by the owner on 2026-09-30, after design §8 step 11's fill of repeated blocks: a
      change whose code no corpus file runs is judged on a probe, inputs that run that code, which
      a branch that never lands adds to the benchmark beside the corpus, in the base and the
      change alike. The change stays when the probe's inputs win past the larger of their spread
      and 1% in two paired jobs on each architecture, and no corpus file loses by its ratio to the
      baseline in both. There, libzstd writes no repeated block (RFC 8878 §3.1.1.2.2) for any
      corpus file at level 3, so no file ran the fill that `codec.fill` took over; the probe's
      1 MiB of zeros decoded at 3.40 and 3.04 times its speed on the N2 and at 1.79 and 1.78 on an
      EPYC 7763, in runs 36669197603 and 36669203656. The alternatives refused: keeping the
      probe's inputs in the benchmark for good, which times inputs outside decision 15's corpora in
      every run; and leaving the fill as it was, an octet at a time on Linux for every repeated
      block.

    Cost: no absolute number is stable from run to run, and the noise floor can sit above 5% on a
    busy host, so a small gain may not be provable. Gain: no machine to keep, both architectures,
    and a run anyone can repeat from the workflow file.

    The alternatives refused: a machine of the owner's, which the owner declined; and a bare-metal
    cloud instance, which is steadier and costs money per run.

21. **SIMD wherever it measurably speeds a loop up.** Ruled by the owner on 2026-09-25, during
    design §8 step 2: "use SIMD to accelerate anything that can be accelerated". It amends entry
    14, which named SIMD for the checksums alone.
    - Every hot loop gets a SIMD path beside its scalar one. The candidates known now: CRC-32 and
      Adler-32 (claim S9); match copies, runs of one octet and short repeated patterns (S4, Z4);
      the copy into the window at the end of a call (S5); stored blocks and raw Zstandard blocks;
      the replicated entries of a Huffman or FSE table fill (S8, Z3); match-length compares 16 or
      32 octets at a time (E1); hashing several positions at once in the encoders' match finders;
      Zstandard's literal copies; and brotli's word transforms, which change the case of up to 24
      octets (RFC 7932 Appendix B).
    - A SIMD path is written with `@Vector` wherever Zig can express it, so one source serves
      x86-64 and aarch64. Instructions `@Vector` cannot express, carry-less multiplication and
      Arm's CRC32, use inline assembly with register operands only (decision 16).
    - The scalar path stays. It is the oracle the fuzzer runs the SIMD path against, and the path on
      a target without the instructions.
    - "Anything that can be accelerated" is read as anything measurably accelerated. A SIMD path
      must beat its scalar path by more than the noise, in the same job, on each architecture it
      applies to (decision 20), or it is removed with its code, as every claim of entry 14 is.
    - `docs/costs.md` prices a 32-octet vector compare beside the scalar costs, so a SIMD claim
      states what it replaces in the same units.

    **How the instructions are chosen.** Ruled by the owner on 2026-09-25: at run time, from what
    the hardware supports, and not from the build target alone. Two rules shape how, and the owner
    ruled on each:
    - The caller detects, and passes the result in. `codec.Features.detect()` reads the CPU once,
      and the caller hands the value to each codec's `init`, which keeps it in the codec's state.
      Invariant 4 forbids a process-wide cache, and detecting in every `init` would pay for it on
      every message a pooled decoder starts: CPUID leaves a virtual machine on a cloud host, about
      half a microsecond. A caller may pass `codec.Features.target()` instead, what the build
      target guarantees with no detection, and a test may pass any set, so one machine exercises
      every path its CPU supports.
    - One object per feature level. Zig 0.16 cannot compile one function for more CPU features
      than the module's target. So the build compiles each SIMD path's source once per feature
      level, as a separate object linked into the module, and a codec calls the variant its
      features allow, once per call and never per octet. The SIMD stays in `@Vector` code at every
      level. The levels are x86-64 with SSE4.1 and carry-less multiplication, x86-64 with AVX2,
      x86-64 with AVX-512, and aarch64 with the CRC32 and PMULL instructions; the target's own
      level is the module itself.
    - Detection reads no file and makes no syscall. On x86-64 it runs the CPUID and XGETBV
      instructions. On aarch64 Linux it reads the kernel's hardware capability words with
      `getauxval`, which reads the auxiliary vector the kernel wrote into the process's memory at
      start: Zig's `std.os.linux.getauxval`, or libc's `std.c.getauxval` in a program that links
      libc, where Zig's finds nothing. `tools/lint/io.zig` allows those two calls and nothing else
      under `std.os` or `std.c`, and `src/codec/features.zig` is their one caller. On macOS, every
      aarch64 machine has CRC32 and PMULL. Entry 40 makes `src/platform/` a second caller, and
      allows it `sysctlbyname` besides.
      Elsewhere, `detect()` gives the build target's features.

    The alternatives refused:
    - Comptime from the target alone, which stdx proposed. A consumer shipping one generic x86-64
      binary would get SSE2 paths where zlib-ng and libdeflate use AVX2.
    - A write-once global cache of the features, which invariant 4 forbids.
    - Detection in every `init`, which pays a virtual machine exit per message.
    - Inline assembly for every path above the baseline. It needs no build change, but each SIMD
      path becomes hand-written assembly per architecture, which is more code to review and test.
    - `@Vector` at the baseline alone, with assembly only for carry-less multiplication and CRC32.
      It needs the least machinery and gives up AVX2 and AVX-512.

    **What design §8 step 4 found.** Recorded on 2026-09-25; the rulings above stand, and these
    are what applying them to the checksums took. Step 4's entry holds the measurements.
    - Seven levels, not four: x86-64 with PCLMULQDQ; with AVX2; with AVX2 and VPCLMULQDQ; with
      AVX-512 and VPCLMULQDQ; with AVX-512 and VNNI; aarch64 with CRC32 and PMULL; and aarch64
      with DotProd. Each exists because a path on it measured faster on a hosted runner than the
      level below it.
    - Inline assembly also carries the dot products of Adler-32: UDOT, VPDPBUSD, VPMADDUBSW with
      VPMADDWD, and VPSADBW. `@Vector` cannot write a sum of products into wider lanes, and the
      shuffles that describe a pairwise sum measured slower than the scalar-reduction path they
      were meant to replace.
    - The level objects are compiled by LLVM in every build mode: Zig's own x86-64 backend, which
      Debug builds use on Linux, cannot place a 512-bit operand of inline assembly.
    - The checksum module imports nothing (design §3), so it names the fields of
      `codec.Features` it reads in a `Features` of its own, and the caller copies them.
    - A path is chosen by length as well as by features where the measurement asks for it:
      CRC-32 below one AVX-512 step takes the VPCLMULQDQ object.
    - Detection reads libc's `getauxval` in a program that links libc; Zig's reads a vector only
      Zig's own start code fills.

    **What design §8 step 10 found.** Ruled by the owner on 2026-09-26: where the same instructions
    measure faster on one vendor's cores and slower on another's, a path is chosen by the vendor as
    well as the features. Step 10's entry holds the measurements.
    - XXH64's AVX-512 path holds its four accumulators in one 256-bit register and multiplies them
      with VPMULLQ. From 16 KiB it ran at 1.27 times the scalar path on an AMD EPYC 9V74 runner and
      at 0.47 on an Intel Xeon 6973P-C, whose VPMULLQ takes about 15 cycles to AMD's 3. Both CPUs
      report the same AVX-512 features.
    - `codec.Features.vpmullq_fast` holds on an AMD CPU with AVX-512, which detection reads from
      CPUID leaf 0's vendor string. `Xxh64Path.fastest` takes the AVX-512 path only with it, and
      only for 1 KiB of stripes or more. `runs_on` holds on Intel as well, so the differential
      check and the benchmark run the path there.
    - `avx512` now requires DQ with F, BW and VL, as the AVX-512 level objects are compiled for it.
    - NEON has no multiply of 64-bit lanes, so XXH64 stays scalar on aarch64.

    The alternatives refused:
    - XXH64 scalar everywhere, which gives up the 27% on AMD.
    - The AVX-512 path kept for callers that name it, with `fastest` always scalar.

22. **An offset equal to Window_Size is accepted.** Ruled by the owner on 2026-09-26, during design
    §8 step 11. RFC 8878 §3.1.1.4 says that "all offsets leading to previously decoded data must be
    smaller than Window_Size". libzstd 1.5.7 writes offsets equal to Window_Size. The differential
    check found 38 such frames among 669. Each was encoded at level 9 or 19 with a window log of 10,
    and each held an offset of 1024 in a window of 1024.
    - stdx's decoder refuses an offset larger than Window_Size as `error.OffsetTooFar`, and accepts
      one equal to it.
    - Invariant 10 holds. An offset still reaches no octet written before the frame's first.
      `codec.Window` keeps the last `capacity` octets, and Window_Size is at most `capacity`, so an
      offset equal to Window_Size reads the oldest octet the window holds.
    - The evidence the owner weighed:
      - libzstd's maintainers say that its decoder accepts any offset inside its history buffer,
        even past Window_Size, because the check costs speed
        ([facebook/zstd#3482](https://github.com/facebook/zstd/issues/3482),
        [facebook/zstd#3151](https://github.com/facebook/zstd/issues/3151)). In the first of the
        two, they also say that a conforming compressor sends only what the format allows. By that
        rule, these frames come from a defect in libzstd's encoder.
      - Since [facebook/zstd#1624](https://github.com/facebook/zstd/pull/1624), libzstd's
        strategies from greedy up take match candidates up to the maximum window size. Levels 9
        and 19 use those strategies, and levels 1 and 3 do not, which fits where the frames came
        from.
      - RFC 8878 §5 lets a frame reach its dictionary "as long as the amount of data decoded from
        this frame is less than or equal to Window_Size". That sentence treats Window_Size as
        inclusive.

    Cost: stdx accepts frames that RFC 8878 §3.1.1.4 calls invalid, by one octet of distance. Gain:
    stdx decodes what libzstd writes at level 9 and above for any input longer than its window.

    The alternatives refused:
    - Refusing an offset equal to Window_Size, as RFC 8878 §3.1.1.4 says. stdx would refuse frames
      the reference encoder writes, which libzstd's own decoder accepts.
    - Accepting any offset inside the window's `capacity`, as libzstd's decoder does. It decodes no
      more of the frames libzstd writes, and it lets a frame reach octets past the Window_Size it
      declared.

23. **An assembly sequence loop for the Zstandard decoder, speed first.** Ruled by the owner on
    2026-09-27, during design §8 step 11, in the owner's words: "let's try assembly, once we match
    or exceed performance, we can see how to make it safe." The runners had shown the Zig sequence
    loop at 0.72 of libzstd's speed on the N2 (run 36323029517), at the same instructions per cycle
    as libzstd and 24 to 67% more instructions (run 36323476089), and three changes to its source
    that each dropped instructions ran 4% slower.
    - It amends decision 16 for one function: the Zstandard sequence execution fast path (Z4) may
      run as hand-written assembly that reads and writes memory by address, without the bounds
      checks Zig adds, inside the margins the checked Zig code sets up. aarch64 comes first, then
      x86-64.
    - It is an experiment. The Zig fast path stays for every other target and every other claim
      setting, as the reference the assembly must match: the tests and the fuzzer run the assembly
      wherever the CPU does, and the differential check compares it with libzstd.
    - Safety comes after speed. Once the loop matches or beats libzstd on the runners, a proposal
      says how it is made safe, and the owner rules on it. Until then, decision 16's refusal of raw
      memory access stands for every other loop.
    - Extended by the owner the same day, after the N2 reached 0.94 of libzstd's speed: "use
      assembly where you can't get the zig compiler to do better", in the Zstandard decoder's hot
      paths. The target is to beat libzstd on every corpus file on an aarch64 Mac first, the owner's
      M1 Pro, and port to the other architectures after. Published numbers still come from the
      runners (decision 20).
    - Extended by the owner to the brotli decoder on 2026-09-28, during design §8 step 12, in the
      owner's words: "Remember that you can write assembly once you cannot get the zig compiler to
      do better." Asked when, the owner ruled the same day to record it now and keep to Zig first:
      the brotli command loop moves to aarch64 assembly only once changes in Zig stop gaining on the
      runners. The Zig fast path stays the reference, as it does for Zstandard.
    - The condition met for brotli on 2026-09-29, and the loop begun on the owner's ruling that day:
      the header's cuts left the HTTP bodies at 0.77 to 0.90 of Google's speed on the N2 for 1 KiB,
      0.83 to 0.88 for 16 KiB and 0.91 to 0.97 for 1 MiB, with the straight command loop at about
      255 instructions per command against Google's about 175 on html-16k (M1 Pro, literals and
      words excluded), and every Zig cut left in it worth 1 to 3%. The loop follows decision 29's
      shape: the Zig loop stays the reference and runs on x86-64 and under every other claim
      setting; words and block switches leave the assembly for Zig at first.
    - The x86-64 port ruled by the owner on 2026-09-30, once the header's cuts left every corpus
      file at or above Google's speed on the N2 and 16 of 39 below it on an EPYC 9V45 (json-1k
      0.57, js-1k 0.61, html-1k 0.65, css-1k 0.69, kennedy.xls 0.72): the straight command loop in
      x86-64 assembly, in files of its own beside the aarch64 loop's, which stay as they are. As
      decision 29's x86-64 DEFLATE loop does, it runs where LLVM assembles it and on a CPU with
      BMI2, which the caller's `codec.Features` names at `init`; the Zig loop stays the reference
      and runs everywhere else. The x86-64 runner exposes no hardware counters, so paired runs alone
      judge it. The alternatives refused: chasing the small bodies on x86-64 in Zig first, and
      leaving x86-64 as it stands.

24. **How the assembly loops are shown safe.** **owner** Proposed on 2026-09-27, as decision 23
    asks once its loops match or beat libzstd on the runners: at 3a45936 the decoder runs at a
    median of 1.13 to 1.19 of libzstd's speed on the x86-64 runners and 1.01 on the N2 (design §8
    step 11).

    **What runs without Zig's checks.** Five loops read and write memory by address:
    - The Zstandard sequence loop, in aarch64 and in x86-64 assembly.
    - The four-stream literal loops, in aarch64 and in x86-64 assembly.
    - XXH64's stripe loop, on Apple's cores.
    - The brotli straight command loop, in aarch64 assembly (decision 23's brotli extension, landed
      2026-09-29) and in x86-64 assembly (its port, landed 2026-09-30), whose access tables their
      first template files carry.

    Each loop checks, once a sequence or a pass, the conditions that keep its accesses inside the
    stream, the tables, the literals and the output: the checked path's checks, and the margins
    the Zig code around it sets up (decision 16). Nothing checks each access. Only the tests check
    the checks: the loops must write what the Zig fast path and the checked path write, and
    libzstd's verdicts must hold.

    **The proposal.** Four measures, none of which adds an instruction to a loop:
    1. An access table in each loop's file: every load and store, the range it touches, and the
       check or entry condition that bounds it. A commit that changes a loop changes its table,
       and review compares the two.
    2. Guard pages, in a tool under `tools/`, where mapping memory is allowed. It decodes the
       differential check's frames and corruptions with every buffer a loop touches placed
       between two pages that fault on any access: the input, the output, the window, the
       literals buffer and the tables. An access past a bound then stops the tool, where
       octets a loop read or wrote past a bound could otherwise go unnoticed. It joins
       `tools/ci.sh` (decision 19) and runs on every runner of decision 26.
    3. Boundary tests: one per check of each loop, with the checked value on each side of its
       bound, as c6197bf's test does for an output below Window_Size.
    4. The Zig fast path stays the reference on every target: each test and the fuzzer compare
       the loops' octets and verdicts with it and with the checked path.

    The alternatives refused:
    - Dropping the assembly. Before it, the x86-64 runners measured stdx at 0.69 and 0.80 of
      libzstd's speed (runs 36328791718 and 36347478310), and the N2 at 0.72 with the Zig
      sequence loop (run 36323029517).
    - A bounds check on each access in the assembly. It repeats what the per-sequence checks
      prove, at a cost per octet.
    - A proof of each loop. No tool here reads Zig's inline assembly, and a proof by hand would be
      the access table with less to check it.

25. **A literal-heavy text joins the corpora.** Ruled by the owner on 2026-09-27, during design §8
    step 11. It amends entries 10 and 15.
    - `tools/corpus/shuffle.zig` writes the first MiB of Silesia's dickens in the order a
      Fisher-Yates shuffle draws from a fixed seed, and `zig build corpus` installs it as
      `shuffled/dickens-1m`. Every check and benchmark over the corpora takes it.
    - `codec.split.Generator` draws the order, so every host writes the same octets. A host that
      wrote others would fail differential-encode, whose recorded hashes cover the file.
    - The shuffle keeps the text's octet frequencies and breaks its repeated strings: libzstd at
      level 3 leaves 868,620 of its 1,048,576 octets as literals, with Huffman codes of many
      lengths.
    - The reason: matches cover most of every other file at level 3, so no file measured claim Z2
      of decision 14, which decodes two literals a lookup. The owner keeps Z2 for text that
      compresses poorly, as long as it costs nothing where it does not apply.

    The alternatives refused:
    - Random dictionary words: the word list differs from host to host.
    - Base64 or hexadecimal text: every literal takes a code of one length, and Z2 pairs no two.
    - A fetched file: none of the corpora holds text that level 3 leaves mostly as literals.

26. **The checks and the fuzzer run on macOS arm64 too.** Ruled by the owner on 2026-09-27, who
    asked that stdx be tested on Linux on x86-64 and aarch64 and on macOS on arm64. It amends
    entries 15, 19 and 20.
    - `.github/workflows/main.yml` runs `tools/ci.sh` on `ubuntu-24.04`, `ubuntu-24.04-arm` and
      `macos-26` on each push to main, and the `fuzz` workflow fuzzes each module on the same
      three. The labels are pinned, as entry 20 pins Linux's: `macos-latest` moves to each new
      macOS. macOS 26 is the owner's.
    - Some code runs on macOS alone. There, `codec.Features.detect()` returns a fixed set, since
      every aarch64 Mac is an Apple M-series part, and the set's `madd_addend_slow` makes the
      Zstandard decoder check Content_Checksum with XXH64's aarch64 path. On Linux the decoder
      takes the scalar path, and only `differential-checksum` calls the aarch64 path, directly.
      Before this entry, only a person's run on the Mac ran the one or the decoder's use of the
      other.
    - Zig 0.16's fuzzer runs on macOS as well as on Linux, so fuzzing need not stay on Linux, as
      entry 15 had it.
    - Numbers stay on Linux (decision 10): macOS runs the checks and the fuzzer, never the costs or
      the benchmarks.

    Cost: a macOS runner has 3 virtual CPUs, so its CI job takes the longest; like the Linux
    runners, it is free for a public repository.

    The alternatives refused:
    - macOS by hand alone: a check nobody runs between steps drifts (entry 19).
    - `macos-latest`: the macOS under the checks would change without a commit.

27. **A JSON module, `json`: RFC 8259's encoder and decoder, with RFC 7464's text sequences.**
    Ruled by the owner on 2026-09-28, who asked for it. colibri writes qlog
    (draft-ietf-quic-qlog-main-schema-14) as JSON text sequences, and today carries its own small
    JSON writer; the owner wants that code to come from stdx, so that colibri's `qlog` module
    imports `json`. It amends entry 1, which held stdx to compression codecs, entry 6, which listed
    the modules, and entry 13, which left every format but the four HTTP codings out of version one.
    - `json` imports `codec` alone, and no module imports it (design §3, invariant 14). It is
      exported by name as every module is (entry 6).
    - Every non-negotiable holds as for the codecs: no heap, no I/O, calls that stream and resume,
      output that is a pure function of the input, and each refusal citing its RFC section.
    - What colibri needs shaped three parts of the API, each one any writer of structured records
      needs: a whole-buffer writer that fails whole, hex strings, and fixed-point decimals. It
      shaped nothing else, and no source names it (invariant 15).

    **The encoder.** A struct the caller places, started by `init(framing)`, and one call:
    `encode(token, input, output)`, which returns decision 11's `codec.Progress`.
    - A token is the start or the end of an object or an array, a name, a string, a hex string, a
      number's text, an unsigned or a signed integer, a fixed-point decimal, a boolean or null. A
      name's, a string's, a hex string's or a number's octets are the call's input, all at once
      (`Piece.last`) or over several calls (`Piece.more`).
    - `needs_input` says the token is written, or all of a token's input so far is taken, and the
      text goes on; `needs_room` says the output filled first, and the next call passes the same
      token with the input not consumed; `done` says the token ended the text.
    - The encoder writes the value separators and the name separators itself, and no insignificant
      whitespace, so its output depends on the tokens and the framing alone, never on how the
      caller split the input and the output (invariant 5).
    - A string escapes what RFC 8259 §7 requires and nothing else: the quotation mark, the reverse
      solidus, and U+0000 to U+001F, in the two-character form where one exists and as `\u00` and
      two lowercase digits where none does. Every other character is written as its UTF-8.
    - It refuses input three ways: a name or a string that is not UTF-8, as `error.InvalidUtf8`
      (RFC 8259 §8.1, RFC 3629 §4); a number's text that is not one number, as
      `error.InvalidNumber` (§6); and a container past `depth_max`, as `error.DepthTooLarge` (§9).
      Unlike entry 11's encoders, this one can fail: its input is text in a grammar, not octets
      that are all valid. A token the grammar does not allow where it comes is a programmer error,
      which an assertion catches.
    - Numbers come from integers and from fixed-point decimals, never from floating point. A
      decimal is an integer part and a fraction of a fixed number of digits, so "1234.567" is 1234,
      567 and 3 digits: qlog's milliseconds with three digits of microseconds, with no rounding and
      the same text on every host. A `number` token writes a caller's own text, checked against §6.
    - A hex string holds two lowercase hexadecimal digits for each octet, the more significant
      first: qlog's hexstring.
    - The whole-buffer helper, `TextWriter`, hands each token all of its octets and all the room
      left, so each token fits whole or the call fails with `error.NoSpaceLeft`, writing nothing
      past the buffer. `written` gives the text. A caller that writes one record into the free part
      of a buffer keeps it only when `written` returns, as colibri does.

    **The decoder.** A pull reader: a struct the caller places, started by `init(framing)`, and one
    call: `decode(input, output, piece)`, which returns a `Progress` whose status adds `token` to
    decision 11's three. A call returns at most one token, and `kind` names it.
    - A name's or a string's octets, unescaped into UTF-8, and a number's text are written into the
      caller's output, over several calls when it fills (`needs_room`). Numbers are not converted:
      their range and precision are the caller's to choose (§9), and no floating point enters.
    - `piece` says whether the input holds the text's last octets. Entry 11 refused a flag for the
      end of the input, because every compression format marks its own end. A JSON text does not:
      a number, or the whitespace after the text's value, can go on in the next call, so only the
      caller knows where the text ends.
    - It follows RFC 8259's grammar strictly and refuses, with a distinct error each, what §2 to §7
      refuse. Where the RFC lets a parser choose, it fails closed (entry 15):
      - a byte order mark, which §8.1 lets a parser ignore, is `error.ByteOrderMark`;
      - an escape of a surrogate that no other completes, which §8.2 leaves unpredictable and UTF-8
        cannot hold (RFC 3629 §3), is `error.LoneSurrogate`;
      - a text deeper than `depth_max` is `error.DepthTooLarge` (§9).
    - It reports every member of an object, duplicate names included, in order. Refusing a
      duplicate would take storage for every name of every open object; §4 says names should be
      unique, not must, and the caller holds the names.
    - `error.DepthTooLarge` and `error.LoneSurrogate` are `Unsupported`, texts RFC 8259 allows that
      stdx refuses; every other refusal is `Corrupt`. `refusal` gives the class (entry 11).
    - The whole-buffer helper, `TextReader`, gives each token with its octets in the caller's
      storage, and turns the operational statuses into `error.Truncated` and `error.NoSpaceLeft`.

    **Text sequences.** `Framing.sequence` delimits a text as RFC 7464 does. The encoder writes a
    record separator, the text and a line feed (§2.2). The decoder reads one text per `init`: one
    record separator or more, then the octets up to the next one or the input's end (§2.1). Its
    `done` leaves the next record separator in the input, as a gzip member's `done` leaves the next
    member. A text a record separator cuts is `error.IncompleteText`, and a text whose number or
    literal name has no whitespace after it is `error.UndelimitedValue`, which §2.4 requires a
    parser to drop. §2.1 asks a parser to go on after a text it cannot read; the decoder refuses the
    text, and a caller that wants the rest calls `init` at the next record separator.

    **The limit.** `json.constants.depth_max`, 1,024 levels, one bit of state each in the encoder
    and in the decoder: 128 octets.

    **SIMD, as entry 21 asks.** Each loop below has a vector path of 16 octets, SSE2's and NEON's,
    the baseline of both architectures, so no feature detection chooses it. The vector paths take a
    slice and return a count; the encoder and the decoder take the counted octets through
    `codec.Reader` and write them through `codec.Writer`, so no bound goes unchecked (entry 16), and
    the `input-index` rule reads them. The scalar paths stay as the reference, and `claims.zig`
    switches each claim at comptime, as entry 14's claims are.

    | Claim | Cost it removes | Test |
    |---|---|---|
    | J1. The encoder finds the run of a string's octets that need no escape a vector at a time | A compare and a branch per octet of a string | A/B against the octet-at-a-time path |
    | J2. The encoder writes a hex string's digits a vector of octets at a time | Two table loads and two stores per octet | A/B |
    | J3. The decoder finds the run of a string's octets up to the next quotation mark, reverse solidus, control character or non-ASCII octet a vector at a time | As J1, in the decoder | A/B |
    | J4. The decoder skips whitespace a vector at a time | A compare and a branch per octet of whitespace | A/B on pretty-printed texts |
    | J5. Inside J1's and J3's runs, UTF-8 is validated a vector at a time, so a run goes on past non-ASCII characters | A state machine step per non-ASCII octet | A/B on text of two- and three-octet characters |

    A claim stays only where `bench-json` shows its vector path faster than the scalar path by more
    than the noise, on each runner of entry 20; design §8 step 16 records the runs. Wider vectors
    behind entry 21's per-level objects wait until a measurement asks for them.

    **The checks, with no oracle.** A conformance corpus such as JSONTestSuite and an oracle are
    each a dependency, which CLAUDE.md asks the owner about; neither is added. In their place:
    - an independent recursive-descent parser in the tests, written from RFC 8259 §2 to §7 and RFC
      7464 §2.1 and §2.4, whose verdict and tokens the decoder must match on every seeded and fuzzed
      input;
    - round trips: seeded and fuzzed lists of tokens encode to a text the parser accepts and decode
      back to the same tokens;
    - every text under seeded splits of the input and the output with the state moved between
      calls (invariants 5 and 12), and every vector path against its scalar one;
    - the fuzzer over every property above, on each runner of entry 26.

    **The baselines.** Ruled by the owner on 2026-09-28, after the first A/Bs: simdjson, yyjson
    and Zig's std.json time beside stdx in `bench-json`, in the same interleaved run as the claims'
    candidates. Each reaches the benchmark through its documented API alone, and nobody working on
    stdx reads its source (entry 9).
    - simdjson 4.6.11 and yyjson 0.13.0 are lazy packages pinned by hash, compiled in `bench/` for
      the host in ReleaseFast, as the codecs' baselines are. simdjson picks its kernel at run time.
    - std.json comes with Zig 0.16.0, so it adds no package; the benchmark builds it for the host in
      ReleaseFast.
    - Decoding visits every value of each text: names and strings unescaped, numbers checked, and
      the text's end checked. Every baseline must count what stdx counts before any is timed.
    - Encoding writes each text from its tokens. A hex string's digits and a decimal's text are
      formatted as a caller of that library would, since none has either, and yyjson writes
      numbers from values, as its API documents no raw number for a document it builds. Each
      baseline's text must decode, through stdx, to what stdx's own text decodes to.
    - Zig 0.16.0 builds no libc++ for macOS 26, so a macOS host builds the benchmark without
      simdjson; the benchmark's numbers come from the Linux runners (entry 10).

    The alternatives refused:
    - A JSON writer in each project that needs one, colibri's today. Each copies the escapes and
      the UTF-8 rules, and each copy drifts.
    - Zig's std.json in the library. Its scanner takes an allocator, and its writer a `std.Io`
      writer, which entries 2 and 3 refuse.
    - A decoder that writes every token of a text into one buffer in one call. It crosses the call
      boundary in bulk, but a caller then parses a second format to read the tokens.
    - A decoder that builds a tree of the text. It needs the heap.
    - Floating point in the encoder or the decoder. The shortest text of a float needs an algorithm
      no RFC gives, and a decimal of fixed digits writes what a log means.
    - Accepting a byte order mark or a lone surrogate, as RFC 8259 §8.1 and §8.2 allow. stdx fails
      closed (entry 15).
    - Framing left to the caller, with RS and LF written and split by hand. RFC 7464 §2.4's check
      needs the decoder to know where a text ends.

    **What design §8 step 16 found.** Recorded on 2026-09-28; the rulings above stand, and these
    are what measuring the claims changed. Step 16's entry holds the runs and the numbers.
    - The benchmark first measured a fault of its own. LLVM inlines a function by how many callers
      it has, and building the workloads called two candidates' codecs a second time: every claim
      on read CLDR's texts, and every claim off built the other texts. Those two codecs alone then
      paid a call for each token, which slowed them by 14 to 26% on texts of short tokens, CLDR's
      and qlog's, on the N2, and every claim's column on those texts carried it. The workloads now
      take claims no candidate takes, and each candidate's loop inlines its codec. `run`, each
      call's loop, is inline in `encode_with` and `decode_with`, so a caller's build cannot pay the
      same call.
    - J4 left with its code on runs that carried that fault. It ran CLDR's texts and qlog's records
      at 1.14 to 1.18 of all on with J4 off, on the N2, about what the fault alone gave every
      column there, so those runs cannot show whether J4 wins or loses. It stays out: entry 21
      keeps a path only where a measurement shows it faster, and none does.
    - J5 starts only where the scalar path would check a non-ASCII octet: past the encoder's
      escapes and past the decoder's delimiters. Inside J1's run, as the table has it, it tested
      the end of each run, and cost the encoder 3 to 4% on ASCII strings on the N2. In the
      decoder, J5 left, and came back once the fault above was gone: J5 off ran CLDR's texts at 1.18
      of all on, but that was the fault's call, and with it gone J5 changes no workload but the text
      of non-ASCII characters, which it decodes 5 to 6 times as fast.
    - J3's run starts only after an ASCII octet, and only at a plain one. Tested before every
      octet, it found no run at each character of a non-ASCII text, and the decoder ran such text
      at 0.71 of the scalar path's speed on the N2.
    - The vectors hold 16 octets on every target. `constants.vector_len` first took the width the
      build target suggests, 32 or 64 octets for AVX2 or AVX-512: widths no benchmark measured,
      chosen from the build target, which entry 21 refuses. At 64 octets, a string shorter than a
      vector, as most of qlog's are, never reaches one.
    - Every function that takes or returns a vector of bool is inline. LLVM keeps such a vector in
      AVX-512's mask registers, and its Debug build cannot pass one across a call: it stopped with
      "Cannot emit physreg copy instruction" in CI run 36377079320. `zig build test-avx512` builds
      every module's tests for an AVX-512 CPU in Debug, since the hosted x86-64 runner draws one
      only now and then.
    - Zig's own x86-64 backend, a caller's Debug default on x86-64 Linux, indexes a vector only at
      a lane known at comptime, so `first_lane`'s fallback runs `inline for` over the lanes.

    The alternatives refused:
    - J5 out of the decoder, as it was from cbea12b to 4721a9f. Text of non-ASCII characters then
      decoded at 81 MB/s on the N2, where J5 decodes about 600, and no text measured faster
      without it once the benchmark was fixed.
    - J4 kept, as the faulty runs cannot show it slower either. Entry 21 asks the reverse: a path
      shows itself faster before it stays.
    - Each target's own width. It needs a measurement of its own, and entry 21's objects to choose
      it at run time.

28. **The `json` module's state machines, proved in Lean.** Ruled by the owner on 2026-09-28, who
    asked for the proofs design §10 had left open after entry 27. The UTF-8 machine of
    `src/json/utf8.zig` and the number machine of `src/json/number.zig` each have a twin in
    `spec/lean/`, a Lake package built with Lean's core alone, and each twin is proved against its
    RFC's grammar, transcribed one ABNF rule to one definition:
    - `Utf8.accepts_iff`: from the start, the UTF-8 machine ends between characters exactly on the
      sequences RFC 3629 §4's `UTF8-octets` derives. `Utf8.refuses_iff`: it refuses an octet exactly
      when no such sequence starts with the octets up to it, so it refuses at the first octet that
      rules a text out.
    - `Number.accepts_iff`: from the start, the number machine takes every octet and ends whole
      exactly on the texts RFC 8259 §6's `number` derives. `Number.refuses_iff` is its
      `refuses_iff`.
    - `Number.accept_taken`, `ended_spec` and `invalid_spec`: what each verdict of `Number.accept`
      tells the decoder, which ends a number at the first octet the machine does not take. A number
      it ends is whole, and no number goes on with the octet it ends before; after an octet it
      refuses, no number goes on at all.

    **What ties a proof to the Zig code.** `spec/lean/Vectors.lean` writes every step of each proved
    machine, from every state and for every octet, into `src/json/utf8_vectors.txt` and
    `src/json/number_vectors.txt`. A unit test of each Zig machine replays every line: the same
    verdict, and the same state after it, and for UTF-8 an unchanged state after a refused octet. The
    number machine has nine states, and the UTF-8 machine reaches eight from its start, so the
    replay covers every step either Zig machine can take, and what is proved of the Lean machines
    holds of the Zig ones.
    - `zig build lean` builds the proofs through pepegrillo's `lean` engine, then checks the vector
      files are what the proved machines give; `zig build lean -- write` rewrites them.
      `zig build test` replays them, with no Lean needed.
    - `spec/lean/Stdx/Axioms.lean` pins each theorem's axioms with `#guard_msgs`, so a proof left as
      `sorry` fails `lake build`. Each rests on Lean's standard axioms alone.
    - `spec/lean/lean-toolchain` pins Lean 4.34.0, the release colibri's proofs pin. On each push,
      `tools/install_lean.sh` installs it on the x86-64 Linux runner, checked against the SHA-256
      GitHub records for the release, and `tools/ci.sh` builds the proofs where lake is on the path.

    The alternatives refused:
    - A Zig tool that writes the Zig machines' tables into Lean, with the proofs about those tables.
      It ties the proofs to the code as tightly, but puts the code under test in the grammar's
      place: the proofs would start from the code, not from the RFC.
    - Mathlib, whose tactics would shorten the proofs, at the cost of a package of gigabytes for a
      proof of two small machines; Lean's core, `omega` included, is enough.
    - The vector UTF-8 check of claim J5 proved equal to the scalar one on every window of four
      octets, which design §10 first listed with these proofs. The owner asked for the machines;
      design §10 keeps it open.

29. **An assembly symbol loop for the DEFLATE decoder.** Ruled by the owner on 2026-09-28, after a
    review of the proposal, during [issue 13](https://github.com/c4milo/stdx/issues/13), which asks
    the DEFLATE decoder to beat libdeflate's on both hosted runners. The owner had asked for
    assembly once the Zig compiler gives no more gains, as decision 23's extension asked for the
    Zstandard decoder. The Zig loop had stopped gaining:
    - At fbcaf44, stdx decoded gzip at a median of 0.662 of libdeflate's speed on the EPYC 7763 and
      0.696 on the N2 (run
      [36372046166](https://github.com/c4milo/stdx/actions/runs/36372046166)).
    - Five commits to the Zig loop took that to 0.856 and 0.862 at 402c953 (run
      [36378152449](https://github.com/c4milo/stdx/actions/runs/36378152449)). The next two
      measured 0.840 and 0.873 at b735d6a (run
      [36380031615](https://github.com/c4milo/stdx/actions/runs/36380031615)), inside the noise.
    - In that run, the program built ReleaseFast runs the fast path at 1.084 of its ReleaseSafe
      speed on the EPYC and 1.119 on the N2. Without Zig's checks, the loop would reach about 0.91
      and 0.98 of libdeflate.
    - On the N2, stdx executes 1.27 to 1.50 times libdeflate's instructions per octet on the files
      where it loses most (run
      [36378148401](https://github.com/c4milo/stdx/actions/runs/36378148401)).

    **The rule.**
    - It amends decision 16 for one function: the common loop of the DEFLATE decoder's fast path
      (`decode_common` in `fast.zig`: S1, S2, S4 and S11) may run as hand-written assembly. The
      assembly reads and writes memory by address, without the bounds checks Zig adds, inside the
      margins the checked Zig code sets up. aarch64 comes first, then x86-64.
    - The assembly takes the symbols the Zig common loop takes, and leaves every other symbol to
      `decode_rare`, in Zig: a code longer than the table, a block's end, a match that reaches the
      window, and a value the checked path refuses.
    - The Zig loop stays for every other target and every other claim setting. It is the
      reference the assembly must match: the tests and the fuzzer run the assembly wherever the
      CPU does, and `differential-deflate` compares it with zlib and Wuffs.
    - Its loads read only the input, the tables and octets this call already wrote (invariant
      10), a match whose distance is below a chunk included; its stores write only the room the
      output margin holds.
    - Decision 24's measures, once ruled, cover this loop as they cover the Zstandard loops.

    The alternatives refused:
    - `@setRuntimeSafety(false)` in the Zig loop, the exception decision 16 allows. It leaves the
      code to the compiler, which reaches ReleaseFast's speed at best: about 0.91 and 0.98 of
      libdeflate.
    - Staying in Zig: the last two commits measured inside the noise.
    - C compiled into the library. Its compiler would be LLVM, as Zig's is, so it would reach
      about ReleaseFast's speed, and the library would hold a second language.

30. **A structural index for the `json` decoder, and the module's vector paths picked at run
    time.** Ruled by the owner on 2026-09-28, after entry 27's baselines measured stdx at a sixth or
    a seventh of simdjson's and yyjson's speed on texts of short tokens: a structural index for the
    decoder, and every vector path chosen at run time, by the caller's `codec.Features` passed to
    `init` as the codecs pass theirs. The design below is proposed with those rulings, and design
    §8 step 17 measures it before any of it stays.

    **The structural index.** Each decoder call classifies the next block of its input, 64 octets
    or what the call holds, a vector at a time, into masks of its octets:
    - the octets inside strings, found from the quotation marks and the parity of the reverse
      solidi before each, carried from the decoder's state;
    - the structural characters outside strings, and whitespace;
    - the octets that start and end a number or a literal name.

    The call finds its token's start and end with bit scans of those masks, not an octet at a time.
    - The index holds no octet the call has not consumed. A call builds it from its own input,
      since the streaming contract lets a caller pass other octets past the ones consumed (entry
      11).
    - It locates, and checks nothing. A string's, a number's and a literal name's octets go through
      the checks they go through today, so every refusal and every theorem of entry 28 stands.
    - It is claim J6, switched at comptime as J1 to J5 are, and the decoder without it stays the
      reference (entry 16).
    - One token per call stays (entry 27). The index removes the scans between tokens, not the call
      each token costs. On compact texts such as qlog's records those scans are short, and step 17's
      profile says how much of a token's cost each part is before the index is built.

    **Picked at run time.** The vector paths of J1, J2, J3, J5 and J6 are compiled once per feature
    level of entry 21, by build/variants.zig: x86-64 with AVX2, 32 octets a block, and with
    AVX-512, 64. The module's own target keeps SSE2's and NEON's 16.
    - `Encoder.init`, `Decoder.init`, `TextWriter.init` and `TextReader.init` take a
      `codec.Features`, and each keeps the level those features allow, which each call reads once.
      A caller passes `codec.Features.detect()`, read once per process, or `codec.Features.target()`.
    - Each level is claim J7's candidate, timed against the 16-octet paths on the same machine.
    - It changes the API entry 27 gave: each caller adds the argument.

    The alternatives refused:
    - A tape of the whole text's structure, as simdjson builds. It needs the whole text at once and
      storage that grows with it, which entries 2 and 3 refuse.
    - An index kept from one call to the next over octets not yet consumed. A caller may pass other
      octets there.
    - The width the build target suggests. Entry 21 refuses choosing instructions from the build
      target alone, and entry 27 found that width measured by nothing.
    - `init` keeping its arguments, with an `init_with` that takes the features. The owner ruled for
      one way to start each type.

    **What design §8 step 17 measured, and the owner's rulings on it, 2026-09-28.**
    - J6 is dropped, ruled by the owner. The step's profile put the scans at a quarter of a token's
      time on the N2, and at 10% to 15% once entry 31's fast paths had cut the calls. An index built
      within one call does more vector work for a token than the 16-octet scan it replaces, and one
      kept across calls is refused above. It returns only if a call ever takes many tokens. Entry
      33's batches take many; the owner ruled on 2026-09-29 that J6 returns as an experiment over a
      batch's input, design §8 step 19, landed on its A/B alone. Built that day, it decoded CLDR's
      texts and qlog's records 36% to 41% slower on both runners, and left with its code.
    - J7 stays, for a name's or a string's run and a hex string's digits. On an AMD EPYC 9V74 it ran
      the runs of plain ASCII and the hex strings 1.3 to 1.45 times as fast.
    - J5's UTF-8 scan stays at 16 octets. At 64 it ran text of Cyrillic and CJK characters 37% slower,
      as each escape that stops a run sends the whole block to the scalar path.
    - A run takes the 16-octet path for its first 64 octets (`constants.wide_run_len_min`) before a
      kernel takes the rest. English text encoded 5% to 8% slower with the kernels from the 17th
      octet, its lines ending before a call paid for itself.
    - J7 takes AVX2's 32 octets alone, on a CPU with AVX-512 too. On an Intel Xeon Platinum 8573C
      its 64-octet kernels ran hex strings 14% slower than 16 octets, and English text 5% to 12%
      slower, where the AMD EPYC 9V74's won and AVX2's won on the EPYC 7763 (design §8 step 18).

31. **A fast path for each token of the `json` decoder and encoder (claims J8 and J9).** Ruled by
    the owner on 2026-09-28, who accepted both after design §8 step 17 measured them; proposed the
    same day from that step's profile. On the N2, stdx's decoder took 600 to 625 instructions a
    token, five to six times simdjson's and yyjson's. perf put about a quarter of them in the scans
    entry 30's index would replace, and the rest in the calls and switches each token passes
    through.

    **The fast path.** At the start of a call between tokens, the decoder takes the next token in
    one straight line, when the input holds all of it and the output has room for its octets:
    - whitespace, and at most one separator;
    - then a structural character, a name or a string of plain ASCII, a whole number with the
      octet that ends it, or a literal name.

    Every other case returns having consumed nothing and changed nothing, and the checked path takes
    the call from its start: an escape, a non-ASCII octet, a record separator, a token the input
    cuts, an output without the room, and every refusal.
    - It reads through the checked reader and writes through the checked writer. It reads each
      octet the grammar turns on with `read_octet`, counts each run with a scan of `scan.zig` or
      `number.zig`, and takes the run with `take`. So entry 16 needs no new exception, and the
      input-index rule reads it.
    - It leaves the state the checked path leaves, field for field. The tests require the same
      progress and the same state after every call with J8 on and off, whole and under seeded
      splits.
    - It is claim J8, switched at comptime as J1 to J5 are. Off, every token takes the checked path,
      the reference (entry 16).

    **J9, the encoder.** The encoder's profile had the same shape, with up to five calls of
    `memcpy` a token, each copying a few octets held in `pending`. At the start of a token, when
    the call's input holds all of its octets and the output has room for every octet it writes,
    the encoder writes them in one straight line, holding none:
    - the record separator that starts a sequence's text, the value separator before a value, the
      token, and the line feed that ends a sequence's text;
    - a structural character, a name or a string of plain ASCII, a hex string, a number's text that
      is one whole number, a number it formats, or a literal name.

    Every other case writes nothing and changes nothing, and the checked path takes the call: an
    octet to escape, a non-ASCII octet, a token whose octets go on in a later call, an output
    without the room, and every refusal. It leaves the state the checked path leaves, and the tests
    require that as they require it of J8.

    The alternatives refused:
    - Inlining the checked path's functions alone. The calls go, but each token still passes the
      same switches, and what LLVM inlines changes with the callers each build gives it, the fault
      entry 27's benchmark found.
    - Many tokens a call. The owner kept one token a call (entry 30).
    - A fast path that indexes the input itself, as DEFLATE's does. Entry 16 would have to name it,
      and the profile did not find the checked reader's cost.

32. **brotli's fast path checks the room of each write, and runs to a call's last octets.**
    Proposed on 2026-09-28, during design §8 step 12. Ruled by the owner the same day: the owner
    chose to amend decision 16 for it, reviewed this text before any code, and approved it as
    written. The code then revised the rule in two places, the second mode and the copy one octet
    at a time, and the owner had the revision committed with it. It amends decision 16 for one
    function: the brotli command loop.

    **The cost it removes.** Decision 16's output margin for the brotli command loop,
    `chunk_len_max` plus 16, is 272 octets, so the checked path decodes the last 272 octets of
    every call: a quarter of a 1 KiB body, at about 90 instructions an octet. On the owner's M1
    Pro, decoding the corpus's 1 KiB HTTP files into an output 512 octets longer than they need
    takes 15 to 25% fewer instructions and 12 to 19% fewer cycles than into one that holds them
    exactly, and html-16k 3% fewer of each. Numbers for publication come from the runners.

    **The rule.** For the brotli command loop alone:
    - The input margin stands as decision 16 sets it: 8 octets, checked where the loop refills.
    - While at least `chunk_len_max` plus 16 octets of room remain, one check at the top of a chain
      and one after its literals cover every write the chain makes, as decision 16's margin does.
    - Below that, the loop runs in a second mode, where each write checks the room it stores into,
      against the most it stores:
      - a literal run stores its batch, which the run bounds by the room left;
      - a copy in chunks (S4) stores its length rounded up to a whole chunk of 16 octets, and at
        least the two chunks it writes first; with less room it copies its octets one at a time,
        as with S4 off;
      - a dictionary word's wide transform stores `transform.wide_output_len`, 64 octets, and its
        exact transform, near DICT's end, `transformed_word_len_max`;
      - the rest of a word the checked path started stores what is left of it.
    - A write whose room is short returns to the checked path, as a failed margin does now, so the
      checked path decodes at most the last write's octets, not 272.
    - Each mode is its own instance of the loop, so the margin's mode compiles as though the other
      did not exist. The checks at each write cost the common case nothing: on the owner's M1 Pro
      they cost command-heavy files 3% when every chain made them.
    - Zig's safety checks stay on (decision 16). Each check is one compare against the room the
      loop already holds in a register, and the slice checks behind it still turn a wrong bound
      into a panic.
    - Every write's check has a test that decodes a stream into every room up to its length, as
      the fast path's margin tests do now.

    **The measurement that admits it:** bench-brotli on both runners, the 1 KiB and 16 KiB HTTP
    files ahead of the fixed margin by more than the noise, and no corpus file behind it.

    **Measured** on 2026-09-28, at d238737 against 5bf6b54, two jobs a side (runs
    [36497674142](https://github.com/c4milo/stdx/actions/runs/36497674142), [36497679595](https://github.com/c4milo/stdx/actions/runs/36497679595),
    [36497685015](https://github.com/c4milo/stdx/actions/runs/36497685015) and [36497690375](https://github.com/c4milo/stdx/actions/runs/36497690375)). On the N2: the 1 KiB HTTP
    bodies +4 to +13%, json-1k -0.6%; the 16 KiB bodies tie, json-16k and json-1m -0.7%;
    grammar.lsp +3%, dickens-1m +2%, the rest within the noise. The x86-64 jobs drew two CPUs, so
    one pair compared like with like: html-1k +9%, css-1k +7%, css-1m -8%. The json files never
    run the second mode, decoded whole in one call, so their loss is the margin instance's
    placement; the owner kept the decision the same day under decision 20's 1% floor, and the
    x86-64 pair waits for the workflow's `base` input. Inlining the wide transform into both
    instances, which two instances had left out of line, gained nothing on the N2 and cost
    html-16k 2% (runs [36501364058](https://github.com/c4milo/stdx/actions/runs/36501364058) and [36501370200](https://github.com/c4milo/stdx/actions/runs/36501370200)); dropped.

    The alternatives refused:
    - The fixed margin, as decision 16 ruled it: every call's last 272 octets at the checked path's
      speed.
    - A faster checked path. It is the reference, one octet a step; making it fast writes the fast
      path a second time.
    - Slack the caller provides, which decision 16 refused.

33. **Many tokens a call for the `json` codecs.** Ruled by the owner on 2026-09-28, who lifted the
    one token a call that entries 27 and 30 kept: "everyone knows batching is good for
    performance". Design §8 step 17 had put about a third of a decoded token's time on the N2 at the
    call's boundary once entry 31's fast paths ran: loading and storing the decoder's state,
    invariant 7's checks at the call's entry and exit, building its `Progress`, and the caller's
    dispatch on it. simdjson and yyjson pay that once a text.

    **The decoder.** `Decoder.decode_batch` decodes tokens one after another into slots the caller
    owns, until the slots are full, the input or the output runs out, or the text ends. The output
    holds the octets of the call's names, strings and numbers one after another, and each slot holds
    its token's kind, where its octets start in the output and how many there are.
    - A call that ends inside a name, a string or a number fills its last slot with what it wrote,
      marked as not ended. The next call's first slot holds the rest of that token.
    - Its status adds `needs_slots` to `decode`'s: every slot is filled, and the text goes on.

    **The encoder.** `Encoder.encode_batch` writes a list of items, each a token with its octets as
    `encode` takes them, until the list ends, the output is full, or the text ends. It returns how
    many items it wrote whole and how many octets of the next it took, so the caller passes the rest
    of the list, and the rest of that item's octets, to the next call.

    Both keep the streaming contract:
    - A call takes what the caller has, says whether it needs input, room or slots or is done, and
      the next call resumes where it stopped (non-negotiable 3).
    - A token takes at least one octet of input decoding, and writes at least one octet encoding, so
      a call's work stays bounded by the octets it consumes and writes (invariant 17). Invariant 7's
      checks run at each batch's exit.
    - A refused text fails the call, as with one token a call. The tokens the call took before the
      refusal are not reported, since the text is refused whole.
    - `decode` and `encode` stay, one token a call, and are the reference: a batch gives their
      tokens, octets and verdicts, whatever the slots, the items and the splits (invariant 5).

    Entry 30's structural index was dropped for one token a call. Its question reopens with batches,
    and design §8 step 18 asks it again from its profile.

    The alternatives refused:
    - A callback for each token, through a pointer: a call a token, the cost this entry removes. A
      comptime callback inlines, but compiles every caller's handling into the decoder's loop.
    - An iterator over a whole text: it needs the whole text in one call, which the streaming
      contract refuses (non-negotiable 3).

34. **The DEFLATE decoder's losing files: smaller gains, a wider table measured, and an x86-64-v3
    benchmark.** Ruled by the owner on 2026-09-28, during
    [issue 13](https://github.com/c4milo/stdx/issues/13). At 11b5b8a, stdx decoded gzip faster than
    libdeflate at the median on every runner CPU drawn: 1.101 of libdeflate's speed on the N2, 1.028
    on an AMD EPYC 9V74 and 1.005 to 1.021 on Intel Xeons. It was slower on 13 to 20 of the 39
    corpus files, depending on the CPU. The owner asked for every file ahead of libdeflate, and was
    asked which rules to relax for it. The rulings:
    - A change for the losing files may stay when it beats those files' own run-to-run spread in
      two jobs and costs no other file more than that file's spread. It amends decision 20's noise
      floor, the larger of 5% and the job's spread, for this work: the losing files need several
      gains of 1 to 3%.
    - The fast path's literal/length table may be measured at 12 bits (`literal_length_table_bits`,
      decision 14's S2), with the decoder's state budget of decision 12 raised to hold it. The
      limits change only if the runners' numbers earn it and the owner rules on it.
    - On x86-64, `bench-deflate` also times the gzip decoders with stdx built for x86-64-v3, beside
      the build for the architecture's baseline, which decision 21's caller ships: what a caller
      that builds for its servers' CPUs gets. The program runs where the host has x86-64-v3's
      instructions.

    Kept as they were: assertions in production (decision 17), the RFCs as the only source
    (decision 9), and decision 16's margins.

35. **Runtime safety off in the `json` encoder's token loop (claim J11), at the caller's choice.**
    Proposed on 2026-09-28, as decision 17's json measurement asks once construction has taken what
    it can (design §8 step 18). Ruled by the owner the same day, who asked whether it could be the
    caller's choice: a caller chooses it at compile time, and every check stays on unless it does.
    It is decision 16's first exception.

    **The measurement.** One A/B of the four files of claims J10's and J11's token loops, with
    runtime safety on, at d2998c4, and off, at 43698a9, where every function of the four starts
    with `@setRuntimeSafety(false)`: bench-json's workloads, five runs a side, both builds in one
    job on each runner (run [36515654643](https://github.com/c4milo/stdx/actions/runs/36515654643)).
    Throughput with safety off over throughput with it on:

    | Workload | N2, decoding | N2, encoding | EPYC 9V45, decoding | EPYC 9V45, encoding |
    |---|---|---|---|---|
    | CLDR's texts | 1.025 | 1.071 | 1.044 | 1.057 |
    | qlog's records | 1.024 | 1.053 | 0.987 | 1.089 |
    | The 17 text files as strings, median | 0.995 | 1.025 | 1.100 | 1.030 |
    | The same, lowest to highest | 0.931 to 1.022 | 1.000 to 1.054 | 0.981 to 1.184 | 0.985 to 1.209 |
    | The non-ASCII text | 0.982 | 0.998 | 1.020 | 1.082 |

    The larger spread of each token row was under 1% on the N2, but for qlog's decoding at 10.7%,
    and 2.8% to 8.3% on the EPYC.

    **What it shows.**
    - The encoder's loop gains 5.3% to 8.9% on the token workloads on both runners, past decision
      16's 5% floor. On the EPYC, CLDR's 5.7% is inside that row's 6.0% spread, decision 20's
      floor for the job.
    - The decoder's loop gains 2.4% and 2.5% on the N2, and −1.3% to +4.4% on the EPYC, under the
      floor. Its text files gain a median of 10% on the EPYC and nothing on the N2: escapes
      decoded on x86-64, which design §8 step 18 takes up by construction.

    **The ruling.**
    - `Claims` gains `encoder_token_loop_runtime_safety`, true by default. A caller that sets it
      false in the claims it passes `Encoder.encode_batch_with` runs the loop at that call site with
      Zig's runtime safety checks off in every function of `encoder_loop.zig` and
      `encoder_loop_string.zig`. `encode_batch` and every other call keep them.
    - A test build, the fuzzer's included, and a Debug build keep the checks whatever the field
      says. A test of `encoder_loop_test.zig` requires every `@setRuntimeSafety` of the two files to
      take the field, and the decoder's loop and the string walk to hold none.
    - bench-json times the encoder with the field false beside every claim on, and puts both beside
      the baselines.
    - Decision 16 gains a row with these numbers.
    - The decoder's loop keeps every check.
    - It amends decision 17's refusal of a switch that turns checks off for callers, for this loop
      alone: the switch is a call site's, and stdx's assertions stay on.

    What stays checked in the encoder's loop: Zig turns safety off in the function that says so, and
    a function it calls, inline or not, keeps its own, so `scan.zig`, `wide.zig` and
    `string_walk.zig` keep their checks. `std.debug.assert` keeps its check too, as its `unreachable`
    lies in its own function. An `unreachable` written in the loop's own functions becomes an
    assumption, as decision 17 warns.

    What it risks: a wrong room check in the loop writes past `output` instead of panicking. The loop
    reads the caller's items and not a peer's octets, and it checks the room an item takes before it
    writes the item (decision 16's J11 row).

    The alternatives refused:
    - The checks off in every ReleaseSafe build, stdx's choice and not a caller's, as first
      proposed.
    - The caller's choice with the checks off by default.
    - A switch at run time. It compiles the loop twice, and every binary carries both.
    - Both loops. The decoder's gain on the token workloads is under the floor, and the decoder
      reads a peer's octets, where a wrong margin reads or writes outside the buffers.
    - Neither. Every check stays, and the encoder gives up 5% to 9% on the token workloads.

36. **The finder's two rules that spend speed on size: the greedy level's covered inserts, and the
    lazy step's distance penalty.** Ruled by the owner on 2026-09-29, from a comparison of
    libdeflate's output with stdx's that keeps decision 9: the symbols of each stream, parsed and
    counted by a scratch tool, and never its source.

    What the comparison found, on the corpus of decision 15:
    - Level 1 emitted twice libdeflate's literals on dickens. A position a match covers never
      entered the hash heads, so a later match could not start there, and a head named a farther
      position than the nearest.
    - Levels 6 and 9 paid 13.3 bits a distance on json-1m against libdeflate's 10.6. The lazy step
      took the longer of its two matches whatever their distances, and a distance 8 KiB back costs
      13 more extra bits (RFC 1951 §3.2.5) than one under 32.

    The rules:
    - The greedy level makes every position a match covers, after its first, its hash's head, for
      a match of `covered_insert_len_max` octets or fewer, 8 at level 1: the 4 octets slide through
      a word, one octet loaded a position. Output over libdeflate's, the median of dickens,
      json-1m, css-1m, html-16k, x-ray, mozilla, E.coli, webster, kennedy.xls and nci: 1.121 to
      1.054, E.coli 1.215 to 1.016.
    - The lazy step compares the match waiting from the position before with the next position's
      by length less `lazy_distance_penalty_octets`, octets of literals a distance costs: 0 under
      32, 1 under 512, 2 under 4096, 3 beyond. Level 6's median goes from 1.017 to 1.007 and
      json-1m from 1.077 to 0.994; level 9's from 1.029 to 1.026 and json-1m from 1.108 to 1.013.
      No file grows more than 0.5%.
    - What they cost, run [36559451595](https://github.com/c4milo/stdx/actions/runs/36559451595)
      against run 36556604513 on the same CPU models, a Neoverse N2 and an EPYC 7763: level 1 at
      0.91 and 0.93 of its speed, the text files 0.80 to 0.88 and E.coli 0.68 and 0.73; level 6 at
      0.98 and 0.97, json-1m 0.75 on both; level 9 at 0.98 and 0.99, json-1m 0.63 and 0.66, samba
      0.70 and 0.74. The 39 files' median output over libdeflate's: level 1 1.101 to 1.055, level
      6 1.000 to 0.999, level 9 1.011 to 1.010.

    The alternatives refused, each measured on the same ten files (speed on the M1, which publishes
    no number, decision 10):
    - Inserting every covered position at level 1: 1.048, and json-1m a quarter slower, as its
      matches run long.
    - 15 and 16 hash bits at level 1, 64 and 128 KiB of heads against the 32 of decision 12: 1.048
      and 1.047 with the inserts above. Not worth the state.
    - The same penalty inside the chain walk, a farther candidate having to beat the found match by
      it: nothing on json-1m, E.coli 0.5% worse. The walk visits candidates nearest first and keeps
      the nearer of two equals already.
    - A `lazy_len` of 16 or 8 at level 6, the waiting match's length that skips the next search:
      json-1m 3.9% and 6.5% larger.
    - The four most recent positions of each hash in one row of the heads, with a 13-bit hash so
      the heads keep their 64 KiB: four times the false candidates, level 6 a fifth slower, level
      1's output 5% larger.
    - A second table keyed by 8 octets, another 64 KiB, so one probe finds a long match: skipping
      the walk after a match of 16 octets or more cost json-1m 3.2%, and after 32 or more the walk
      ran anyway for the table's insert.
    - A budget of 64 candidates at level 6 instead of 128, its cut 16: the M1 put it at 0.3 to
      0.6% larger for 12 to 27% of the time, and the owner asked for the runners' numbers. Run
      [36568474837](https://github.com/c4milo/stdx/actions/runs/36568474837), main (bb0d5c8) and
      the budget in one job: level 6 at 1.12 times its speed on the N2 and 1.15 on an EPYC 7763,
      no file slower, E.coli 1.7, reymont and json-1m 1.3; output over libdeflate's at the median
      from 0.999 to 1.000, a median 0.15% larger, 16 of 39 files by more than 0.2%, E.coli 1.6%,
      reymont 1.2%, xml 1.1%. Ruled adopted on 2026-09-29.

37. **A table lookup in the `json` module's UTF-8 check (claim J5).** Proposed on 2026-09-29,
    from design §8 step 18's non-ASCII rows, once construction in plain vectors had taken what it
    could. Ruled by the owner the same day: as an experiment first, on an unmerged branch with the
    A/B below, and landed only on its numbers. At 1247c3e stdx decodes the non-ASCII text at 0.866 of simdjson's speed on
    the N2 and 0.643 on an Intel Xeon Platinum 8573C, and encodes it at 0.757 and 0.662 (run
    [36522098273](https://github.com/c4milo/stdx/actions/runs/36522098273)). The encoder writes
    its input's UTF-8 as it is and the decoder writes a string's as it is, so on that text the
    check is the work.

    **The check today.** `scan.utf8_error_lanes` judges a block of 16 octets with each rule of RFC
    3629 §4 as a compare against a splat: about 14 compares, 3 shuffles that bring in the previous
    block's last octets, and 10 ANDs and ORs, before the stop test every block pays. With the
    check skipped, an experiment never merged (run
    [36522631693](https://github.com/c4milo/stdx/actions/runs/36522631693), branch
    `exp-json-utf8-ceiling` against 1247c3e), the non-ASCII text decoded 2.21 times as fast on
    the N2 and 1.83 times on the Xeon, and encoded 1.94 and 1.87 times as fast, with every other
    row inside its spread: the check is more than half of the time on that text, and that is the
    most a faster check can give.

    **The proposal.** Three lookups of 16 entries each, indexed by the high nibble of the octet
    before, its low nibble, and the high nibble of the octet itself, ANDed together: a lane left
    nonzero is an octet RFC 3629 §4 rules out within a window of two octets, which covers C0, C1
    and F5 up, a continuation octet after an octet that asks for none, an octet that is no
    continuation after one that asks for it, and the narrower second octet after E0, ED, F0 and F4.
    A character's third and fourth octets are judged as today, from whether the octet two or three
    back asks for them. About 9 vector operations a block against 27. The technique is Keiser and
    Lemire's, from their paper "Validating UTF-8 In Less Than One Instruction Per Byte" (2021); no
    implementation's source is read (entry 9).
    - The lookup is `tbl` on aarch64, in NEON's baseline, and `pshufb` on x86-64, which needs
      SSSE3, above the baseline: there it goes in the variant object claim J7's kernels already
      build for AVX2 (`build/variants.zig`), at 16 octets, and the baseline keeps the compares.
      Both are inline assembly with register operands only, as entry 16 admits.
    - The three tables are comptime data built from RFC 3629 §4's rules in `constants.zig`, and a
      test requires the lookup to judge every pair of octets, 65536 cases, as `utf8.zig`'s machine
      does, entry 28's reference; the existing tests over every sequence of three octets and the
      fuzzer cover the rest.
    - It is measured as entry 16 asks: the A/B of the lookup against the compares on both runners,
      five runs a side, and the gain must pass the noise on the non-ASCII text with no loss past
      the noise elsewhere. Below that, it leaves with its code.
    - The compares stay as the reference for every target without a kernel, and the tests run both.

    What it costs: a second kernel per architecture for one function, assembly that no lint reads,
    and a build variant on x86-64 the lookup alone needs; the module's first inline assembly.

    **The measurement, 2026-09-29.** The lookup against the compares alone, on the N2 (run
    [36558384471](https://github.com/c4milo/stdx/actions/runs/36558384471), before the x86-64
    kernel existed): the non-ASCII text decoded 1.333 times as fast and encoded 1.332, every other
    row inside its spread, and the J5 loss on samba gone. The batch that carried it, against main
    at 1247c3e (run [36568234592](https://github.com/c4milo/stdx/actions/runs/36568234592)): the
    non-ASCII text decoded 1.668 times as fast on the N2 and 1.443 on an AMD EPYC 9V45, and
    encoded 1.332 and 1.433; the text with its characters as `\u` escapes, which the module's own
    UTF-8 writer in the same batch serves, decoded 1.228 and 1.218 times as fast; tokens, ASCII
    text and hex strings stayed inside the noise on both. stdx decodes the non-ASCII text at 1.441
    of simdjson's speed on the N2, from 0.864, and encodes it at 1.008, from 0.756; on the EPYC
    9V45, at 0.744 from 0.516 and 0.929 from 0.648. Landed at c134f2c.

    **What was built, 2026-09-29.** `scan_utf8.zig` holds the check apart from `scan.zig`, in both
    forms, and takes the lookup where the target has one: every aarch64 target, and x86-64 with
    AVX2, which the module's baseline target lacks and its AVX2 variant object has. There the
    loops' string functions compile into the object whole (`variants/loop_string.zig`), and each
    loop calls its kernel once a string when the caller's level is AVX2. A first cut called the
    walk's block loop from inside the string function, and on an AMD EPYC 7763 the text files
    decoded at 0.62 to 0.83 of main's speed and encoded at 0.52 to 0.72, ASCII files included,
    the kernel called or not (run
    [36558900057](https://github.com/c4milo/stdx/actions/runs/36558900057)): x86-64 saves no
    vector register across a call, so a call inside the block loop kept the walk's state in memory
    through the loop. The call now sits outside every loop. The tables are built from RFC 3629 §4's
    constants at compile time. Two tests pin them: every pair of octets judged as utf8.zig's
    machine judges it, an octet UTF-8 never holds counted by its place alone since the tables flag
    it on the lane after; and every sequence of an edge octet and two more, at six places across
    two blocks of letters, run to the length the machine gives (`scan_test.zig`). Nine mutations
    were CAUGHT (commits b7baada and 7957e71).

    The alternatives:
    - The compares, as today. The reference, and the non-ASCII rows stay where the table above
      puts them.
    - The check at 32 or 64 octets a block. Refused by entry 30's measurement: at 64, each escape
      that stopped a run sent the whole block to the scalar path, 37% slower.
    - No check. RFC 8259 §8.1 requires UTF-8, and entry 27's decoder refuses a text that is not.
    - A lookup written in plain Zig from selects. Sixteen selects a lookup, more than the compares
      it replaces.

38. **simdutf as the baseline of the `json` module's UTF-8 check.** Proposed and taken on
    2026-09-29, from the question entry 37 left. Entry 37 measured the check inside the loops, where
    it is one cost among the stops, the copies and the escapes, against simdjson's and yyjson's
    whole parsers. The owner asked how the check itself compares with simdutf, the library that
    publishes the fastest UTF-8 validation and the algorithm entry 37 built from its paper. Only a
    check run alone answers that, so the module exports one, and bench-json times it beside
    simdutf's.
    - `json.is_utf8(octets)`, `scan_utf8.valid`: whether a buffer is UTF-8 whole (RFC 3629 §4),
      through the same `error_lanes` the loops run a block of 16 octets at a time, and utf8.zig's
      machine, entry 28's reference, over the character the last block cuts and the octets after
      it. It is a function of its input alone, keeps no state, and follows the module's rules: no
      heap, no I/O, a loop bounded by the input.
    - simdutf 9.2.1 joins bench-json's baselines as a lazy package pinned by hash (entry 8), built
      from its sources with Zig's clang as simdjson is, its AVX-512 kernel left out on an x86-64
      host without `evex512` for entry 27's reason, and absent on macOS with simdjson (entry 10).
      Its binding calls `validate_utf8` and nothing else (`bench/json/baselines/`).
    - bench-json's section "UTF-8 validation against simdutf" (`bench/json/json_utf8.zig`) runs
      both over each string workload's octets, the ASCII texts and the non-ASCII one, interleaved
      in one run, the median of five with the spread, and lists the losses under entry 20's floor.
      Before it times anything, both must judge every buffer alike.
    - Nothing in `src/` reads simdutf's source or its output; the bench holds the only call.

    What it costs: a third C++ baseline in `bench/`, about 4 MB of source the first `-Doracles`
    build fetches, and one public function the module must keep.

    **What was built, 2026-09-29.** `is_utf8(octets, features)` is `scan_utf8.valid` at the level
    the caller's features pick. `valid` takes the buffer a group of `utf8_group_blocks` blocks at a
    time, four blocks and 64 octets: a group with no octet from 0x80 up costs its four loads, three
    ORs and one test, and its one possible fault, a character the block before it cut, is found on
    that block's last three lanes (`incomplete_octets`, `cut_character_len` as lanes); any other
    group runs the lookup a block at a time and ORs the verdicts as octets, which are read once,
    after the last group. The blocks after the last group run one at a time, and the last octets
    through utf8.zig's machine. Two costs were found on the way. LLVM split each block's load into
    a load of 13 lanes and three loads of one lane, with a copy between them, for the shuffles that
    read a block's low lanes: 24 loads and 12 copies a group in place of 4 loads. An empty assembly
    statement that takes the block in a vector register and gives it back (`loaded`) stops it. And
    the lookup's verdict took five vector instructions to become bools; XORing the lanes asked into
    the bit that marks a continuation octet after one leaves a nonzero octet on exactly the lanes
    that break a rule, in two (`error_octets_lookup`), and `error_lanes` now reads it with one
    compare, so the loops' block walk shares the saving. On x86-64 the check runs in the AVX2
    variant object when the caller's features name the level (`variants/scan_utf8.zig`,
    `wide.is_utf8`), where it takes the lookup; the module's own x86-64 target keeps the compares.
    Tests: `valid` against utf8.zig's machine with a sequence of edge octets at every offset of a
    buffer of two groups and a block, the ASCII group's cases by hand, and one verdict at the
    target's level and the features' (`wide.zig`), and the fuzzer draws buffers of up to four
    groups against the machine. Six mutations of `valid`: the cut before an ASCII group ignored,
    the asked lanes ORed, 0x80 let through, the last group's verdict alone kept and the thresholds
    one too high were CAUGHT; `previous` left behind an ASCII group was NOT CAUGHT and is
    equivalent, since a block that ends between characters asks nothing of the next, and a group
    of ASCII after one that ends inside a character is refused for the cut (commit 5369a3c).

    **Measured, 2026-09-29.** Paired against 0551a38, the check as the walk ran it, in run
    [36603861241](https://github.com/c4milo/stdx/actions/runs/36603861241). On the N2, `is_utf8`
    runs the ASCII text files at 1.005 to 1.083 of simdutf's speed (median 1.037; 30.0 to 43.6
    GB/s against simdutf's 34.0) and the non-ASCII text at 1.039 (5.77 GB/s against 5.56), from
    0.075 to 0.100 and 0.542 before: 10 to 14 times its old speed on ASCII and 1.9 on the
    non-ASCII text. On an Intel Xeon Platinum 8370C, the AVX2 object's copy runs the ASCII files
    at 0.340 to 0.460 of simdutf (36.2 to 47.4 GB/s against 106.2) and the non-ASCII text at 0.407
    (7.24 GB/s against 17.8), from 0.019 to 0.038 and 0.116: 17 to 23 times its old speed, and
    simdutf's AVX-512 kernel, 64 lanes to the object's 16, holds the rest. The loops share the
    lookup's shorter verdict: the non-ASCII text decodes at 1.098 and encodes at 1.101 of 0551a38
    on the N2, 1.056 and 1.045 on the Xeon; the ASCII files move within their noise, the hex
    strings among them, whose path the change does not touch. The second paired run,
    [36605683401](https://github.com/c4milo/stdx/actions/runs/36605683401), drew the N2 again and
    an AMD EPYC 7763: on the N2 the ASCII files at 1.012 to 1.083 (median 1.047) and the non-ASCII
    text at 1.039; on the EPYC 7763, where simdutf runs its AVX2 kernel of 32 lanes against the
    object's 16, at 0.575 to 0.844 (median 0.824; 43.2 to 50.4 GB/s against 59.4) and 0.520 (7.99
    GB/s against 15.4), from 0.027 to 0.034 and 0.151. In the loops there, the non-ASCII text
    decoded at 1.026 and encoded at 0.988; on the N2 at 1.100 and 1.101. bible.txt and html-1m
    decoded at 0.951 to 0.957 and 0.948 to 0.951 on the N2 in both runs, past their spread, and
    within 1.5% on both x86-64 CPUs, while the hex strings, whose path the change does not touch,
    moved 2 to 5% up on the N2 in both runs: the binary's layout moved with the change, not the
    loops' work. By decision 20's rule no file loses in every job, and the change stays. What the
    x86-64 gap wants, a copy of the check at 32 lanes for AVX2 and 64 for AVX-512, is a width the
    json module's variant object does not build (wide.zig), and is left to the owner.

    The alternatives:
    - No measurement of the check alone: entry 37's rows against simdjson and yyjson stand for it.
      Refused because they mix the check with the rest of the loop, and a check slower than the
      state of the art would hide behind a faster copy.
    - simdjson's `validate_utf8`, already built. It is the same family of algorithm in a copy
      simdjson keeps, not the library that leads on UTF-8, and the owner named simdutf.
    - Timing the check through the walk with the copies and stops taken out. The walk's shape is
      the walk's; a validator that a caller may run over a buffer is what a caller compares.

39. **A wider copy of the `json` module's UTF-8 check on x86-64.** Ruled by the owner on
    2026-09-29, from the gap entry 38 measured. There `is_utf8` ran 16 lanes a block in the AVX2
    object, while simdutf ran 32 on an AMD EPYC 7763 and 64 on an Intel Xeon Platinum 8370C: stdx
    ran the ASCII text files at 0.575 to 0.844 and 0.340 to 0.460 of simdutf's speed, and the
    non-ASCII text at 0.520 and 0.407 (runs
    [36603861241](https://github.com/c4milo/stdx/actions/runs/36603861241) and
    [36605683401](https://github.com/c4milo/stdx/actions/runs/36605683401)). The owner ruled to
    build the wider copies.
    - `scan_utf8.valid_by(width, form, octets)` holds the check at any width: groups of
      `utf8_group_blocks` blocks, then blocks of the width, then blocks of 16, and the last octets
      through utf8.zig's machine. The variant object runs it by the lookup at AVX2's 32 lanes and at
      AVX-512's 64, a level it now builds for the check alone (`variants/scan_utf8.zig`,
      `build/modules.zig`). VPSHUFB looks each 16 lanes up in their own 16 entries, so each table
      repeats once for each 16 lanes.
    - `wide.CheckLevel` picks the width from the caller's features: AVX-512's, then AVX2's, then
      the module's own 16. The loops keep `Level`, whose AVX-512 kernels ran hex strings slower
      (entry 30), and the walk keeps 16 lanes, which step 17 measured against 64 (37% slower on
      non-ASCII text, a rescan for each escape); the check has no octet to stop at, and takes the
      widest.
    - Zig's own x86-64 backend cannot place a 512-bit operand of inline assembly, so the lookup at
      32 and 64 lanes compiles in the variant object alone, which LLVM builds. The module's own
      code runs those widths by the compares, the reference, and its tests hold them to utf8.zig's
      machine on every target (`scan_utf8.Form`).
    - Tests: each of 25 characters and faults on every lane of a buffer that crosses every
      boundary a width has, at 32 and 64 lanes by the compares on every target, by the lookup where
      LLVM builds it for the CPU, and through each kernel at every level the CPU runs; the fuzzer
      does the same with its own buffers. The AVX-512 kernel runs only on a CPU with AVX-512, which
      the M-series host and Rosetta lack. So bench-json requires every copy of the check to judge
      20000 seeded buffers and each workload, whole and with an octet changed, as the module's own
      16 lanes and simdutf do before it times anything, and every run on such a runner checks it.
    - The wider copies start their loads on a line of their width (`aligned_start`): they judge
      one block from the buffer's first octet, unaligned, then load every block from the next line
      on, the three octets before it placed in one shuffle. A first cut loaded from the buffer's
      first octet, and on an Intel Xeon Platinum 8370C the 64-lane copy ran 16 files at 55 GB/s and
      the one whose buffer sat on a line at 163, while simdutf ran the same files at 107 and 55 (run
      [36628661670](https://github.com/c4milo/stdx/actions/runs/36628661670)). bench-json now times
      the check at six offsets from a line. On an AMD EPYC 9V45 the aligned start took an ASCII
      text at those offsets from 142 to 147 GB/s up to 199 to 207, with simdutf at 132 to 140 (run
      [36634334010](https://github.com/c4milo/stdx/actions/runs/36634334010)). A buffer under
      `utf8_aligned_len_min`, 1 KiB, keeps its unaligned loads, where the setup costs more than the
      loads it saves.
    - The same run decoded the hex strings at 0.62 to 0.79 of their speed on the EPYC 9V45 with
      the decoder's code unchanged: the variant object's text was aligned to 16 octets, so every
      change to the module's own code moved the object and its kernels within their lines. Each
      kernel and each of the loops' string functions now starts on a 64-octet line
      (`kernel_alignment`), and its loops sit where its own code puts them.

    **Measured, 2026-09-29.** Two paired runs of ee0f015 against main at 6fa420f,
    [36643926336](https://github.com/c4milo/stdx/actions/runs/36643926336) and
    [36643928058](https://github.com/c4milo/stdx/actions/runs/36643928058), drew the N2 twice, an AMD
    EPYC 9V45 and an AMD EPYC 7763.
    - On the EPYC 9V45, with AVX-512, `is_utf8` ran the ASCII text files at 1.206 to 1.603 of
      simdutf's speed (median 1.422) and the non-ASCII text at 1.087: 1.86 to 2.46 times main's
      speed on the ASCII files and 3.84 on the non-ASCII text. Its 64 lanes ran the ASCII files at
      1.08 to 1.57 of its own 32 in the same job (median 1.42) and the non-ASCII text at 2.12, so a
      CPU with AVX-512 keeps the 64-lane copy.
    - On the EPYC 7763, with AVX2, the 32-lane copy ran the ASCII files at 0.950 to 1.190 of
      simdutf's speed (median 1.008) and the non-ASCII text at 0.952, from 0.596 to 0.979 and
      0.521 at main.
    - The N2's copy, which the batch leaves as it was, stayed at 1.01 to 1.08 and 1.04.
    - No Intel Xeon was drawn after the aligned start. Before it, the Xeon 8370C ran the 64-lane
      copy at 0.511 to 0.551 of simdutf's speed on the 16 files off a line (run 36628661670).
    - The placement proof (entry 20) built bench-json for both runners' targets at both commits.
      Outside the check and bench-json's own UTF-8 section, every function of stdx and of the
      benchmark's timing loop is identical apart from its address. So the decoder's and encoder's
      rows moved by placement alone, the kernels now each on a line: on the EPYC 9V45 the hex
      strings decoded 1.27 to 1.65 times as fast and E.coli 1.45, and on the N2 bible.txt and
      html-1m decoded at 0.95 in both runs.

    What it costs: two kernels more in the variant object, the AVX-512 level built for the json
    module, a width through the check, and up to 63 octets of padding before each aligned kernel.

    The alternatives:
    - The check at 16 lanes on x86-64, as entry 38 built it. simdutf stays 1.2 to 2.9 times as fast
      there.
    - A 32-lane copy alone, for every x86-64 CPU with AVX2. Measured against the 64-lane copy in the
      same job on a CPU with AVX-512; the numbers decide.
    - The walk at the wider widths too. Refused by step 17's measurement above.

40. **`platform`: what the CPU offers, probed once when a program starts, and the one module that
    may make a syscall.** Ruled by the owner on 2026-09-29, in colibri's session, as [issue
    15](https://github.com/c4milo/stdx/issues/15) records. The owner confirmed each point below on
    2026-09-30, through the question prompt.

    **What it is.** A program calls `platform.probe()` once, at start, and passes the fields of the
    `Cpu` it returns down its stack: to a TLS stack's configuration, for example, which hands them
    to each session. It is the shape of `codec.Features.detect()` (entry 21). No library calls it,
    and stdx keeps no copy of the answers (invariant 4).

    ```zig
    pub const Answer = enum { yes, no, not_known };
    pub const Cpu = struct { aes_clmul: Answer, dit: Answer };
    pub fn probe() Cpu;
    ```

    - `aes_clmul` says whether the CPU has the AES instructions and a carry-less multiply of two
      64-bit values. It is `yes` only when the CPU has both.
    - `dit` says whether the CPU has Arm's FEAT_DIT: the PSTATE.DIT bit, under which Arm's timing
      statement for instructions such as MADD and UMULH holds.

    **Where each answer comes from.**
    - x86-64, on every system: CPUID leaf 1, ECX bit 25 (AES-NI) and bit 1 (PCLMULQDQ). `dit` is
      `not_known`: x86-64's matching mode, DOITM, is one the operating system sets on Ice Lake and
      later parts, and user code cannot read it.
    - aarch64 Linux: the AT_HWCAP word through `getauxval`, bit 3 (HWCAP_AES), bit 4 (HWCAP_PMULL)
      and bit 24 (HWCAP_DIT).
    - aarch64 macOS: `sysctlbyname` of `hw.optional.arm.FEAT_AES`, `hw.optional.arm.FEAT_PMULL`
      and `hw.optional.arm.FEAT_DIT`. All three read 1 on the owner's M1 Pro, under macOS 26.6.2.
    - Any other aarch64 system: `yes` for a feature the build target guarantees, and `not_known`
      otherwise.
    - Any other architecture: `not_known`.

    Where Linux's or macOS's source gives no answer, the target's guarantee stands in, as on any
    other aarch64 system. `getauxval` returns 0 when it finds no AT_HWCAP entry, which Zig's reader
    does in a program that starts in libc but whose Zig code was built without it. A macOS release
    older than a sysctl name has no value for it.

    **The one module that may make a syscall.** macOS's `sysctlbyname` is a syscall; Linux's
    `getauxval` reads memory the kernel wrote at start, and CPUID is an instruction. `platform` may
    make the syscall because a program makes the call once, and no codec path runs it.
    - `tools/lint/io.zig` reads `src/platform/` under a configuration of its own. It allows
      `std.c.sysctlbyname` beside `getauxval` and refuses every other chain the rule's list names,
      so the probe opens no file, starts no thread and prints nothing. Every other directory under
      `src/` refuses `sysctlbyname` as before (invariant 2).
    - No module imports `platform`, and `platform` imports nothing (invariant 14). The module-graph
      rule's table gives no module an edge to it, and `zig build graph-check` requires an import of
      it from `src/deflate/` to fail.

    **It only reads.** `platform` changes no CPU state. It offers no call that sets PSTATE.DIT for
    the calling thread (`msr dit, #1`). The owner revisits this only if [chapulin issue
    186](https://github.com/c4milo/chapulin/issues/186) rules that the caller sets PSTATE.DIT.

    **Its own CPUID.** `platform` runs CPUID in a function of its own and does not import `codec`,
    whose `Features` runs the same instruction. The copy is one function of a dozen lines, and the
    module graph gains no edge from `platform`.

    **The check.** `zig build platform-check`, which `zig build test` runs, so it runs on every
    runner of entry 26. `tools/platform_check.zig` requires `probe()` to give the answers the host
    reports through a source the probe does not read: on Linux, /proc/cpuinfo's `flags` line on
    x86-64 and its `Features` line on aarch64; on macOS, `sysctl hw.optional.arm`.
    - The build compiles `platform` for the generic CPU of the host's architecture, so no answer
      comes from the target. The check refuses to run when built for a CPU that guarantees a feature
      it reads.
    - On Linux it runs twice, without libc and with it: the probe reads the auxiliary vector through
      Zig's `getauxval` in one and libc's in the other.
    - It is a tool and not a unit test because it reads a file and runs a process, which no source
      under `src/` may do. The unit tests hold each bit, each sysctl value and each target's
      guarantee to its answer.

    What it costs: a syscall inside stdx, a second configuration of the io rule, and a ninth module.

    The alternatives refused:
    - Fields in `codec.Features`, the issue's first form. `Features` chooses the codecs' SIMD paths
      and makes no syscall (entry 21). macOS's sysctl would put a syscall in the module every codec
      imports, and neither answer chooses a codec path.
    - A module of the caller's own. Each program that needs the answers would write the CPUID,
      AT_HWCAP and sysctl reads again.
    - One call per answer. A program passes one value down its stack, as it passes
      `codec.Features`, and one call reads each source once.
    - A call that sets PSTATE.DIT, above.
    - A compile error on any other system. A program built for one would fail to build to learn what
      it can do without, and `not_known` says what the program cannot read.
    - Importing `codec`'s CPUID. It adds an edge to the module graph, which CLAUDE.md asks the owner
      about first, to save a dozen lines.
    - `src/platform/` left out of the io rule. The probe could then open a file, start a thread or
      print, and it needs none of them.
    - `sysctlbyname` added to the io rule's shared exceptions. Every module could then call it.
    - The comparison as a unit test of the module, above.

41. **Fills go through `@memset`, and the program that links stdx owns `memset`.** Ruled by the
    owner on 2026-09-30, after 97e42ca gave every benchmark program a vector `memset` of its own.
    Zig 0.16's compiler runtime defines `memset` one octet at a time, and on Linux that copy serves
    every `memset` call in a program, glibc linked or not (design §8 step 9); Zig's next release
    stores vectors. `codec.fill` (b47400b) kept stdx's clears and fills out of that loop: the
    DEFLATE encoder's clear of its heads at each stream's start, which took 33,500 cycles on a
    Neoverse N2 at level 1 and 66,000 at level 6 through it, the encoder's counts at each block,
    the Zstandard decoder's repeated blocks, which decoded 3.40 times as fast through
    `codec.fill` on the N2 (design §8 step 11), and brotli's runs of zeros in a context map. With their own `memset`, the benchmarks no longer
    show those costs. So stdx calls `@memset`, and a program on Linux under Zig 0.16 that wants
    these fills fast exports a `memset` of its own, as `bench/timing/memset.zig` does for the
    benchmarks (pepegrillo's `performance_zig.md`, "Copies and fills"). A library exports none,
    since its caller's program owns the symbol.

    Measured with the benchmarks' own `memset` (design §8 step 11), the removal encoded the 1 KiB
    bodies 2% to 15% faster on both architectures, and fields.c and js-16k at level 9 4% to 6%
    slower on x86-64 in both jobs; the owner ruled it in with those losses.

    Cost: a program on Linux under Zig 0.16 without a `memset` of its own pays the octet loop in
    these fills, and no benchmark shows it. Gain: the library fills one way, and no code in it
    answers one Zig release's runtime.

    The alternatives refused: keeping `codec.fill` until stdx moves to a Zig release whose `memset`
    stores vectors; and keeping it with its vector path limited to Zig 0.16, so that the upgrade
    turns it into `@memset`.
