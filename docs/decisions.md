# Design decisions

Every entry here is a trade made on purpose: what it costs, and what it buys. Changing one means
re-arguing the trade, not editing the code. The README states what stdx does; this file states why.

Entries marked **owner** wait on a ruling and are not settled. Everything else is settled and is
re-argued, not edited. Entries 1 to 10 record the rules the owner set in the brief that started
stdx on 2026-09-25. Entries 11 to 18 are proposals, and no codec code is written until the owner
rules on them.

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

   The alternatives refused, in colibri's decision 90: the decoder inside colibri, which makes
   every other project take HTTP to get a codec; and stdx holding colibri's `core` as well, which
   would have made stdx carry limits that belong to HTTP.

2. **No I/O.** Ruled by the owner on 2026-09-25. A codec reads octets the caller already has and
   writes into storage the caller owns. It opens no file or socket, starts no thread, and makes no
   syscall. Cost: a caller that has a file or a socket writes the loop that feeds the codec. Gain:
   the codec runs under any I/O model the caller has (blocking, `io_uring`, an event loop, a
   kernel bypass), and a test drives it with nothing but slices. `tools/lint/io.zig` refuses the
   syscall, filesystem, network, thread, process and logging surfaces of `std` under `src/`
   (invariant 2).

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
     libdeflate are proposals. Each needs its own ruling before it is added, and joins CLAUDE.md's
     list of ruled dependencies in the commit that adds it.
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
    colibri's decision 32 ruled it for colibri.
    - Benchmarks run on Linux alone, with the machine written down beside the numbers: CPU model,
      core count, frequency governor, kernel, compiler versions. macOS publishes no number.
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

## Waiting on the owner

11. **owner: The streaming contract every codec shares.** Proposed on 2026-09-25, the first
    decision record the owner asked for.

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

    `init` costs a constant. It writes the few dozen octets of state a stream starts from and does
    not clear the window or any table. No octet of history is read before this stream writes it
    (invariant 10), so neither uninitialised memory nor the octets of a previous stream in the
    same state is ever observed. That comparison is what makes a pool of decoders safe to share
    between messages from different peers, so invariant 10 tests it on every copy path.

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

12. **owner: The memory each decoder and each encoder level takes, and what happens when a
    stream asks for more.** Proposed on 2026-09-25, the second decision record the owner asked
    for.

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

13. **owner: The scope and order of version one.** Proposed on 2026-09-25, the third decision
    record the owner asked for. The owner proposed: the DEFLATE family decoder, then the Zstandard
    decoder, the brotli decoder, the DEFLATE encoder, the Zstandard encoder and the brotli
    encoder. This entry proposes one change: the DEFLATE encoder moves to second.

    **The order proposed.**
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

    Nothing else is argued in.

14. **owner: Where the speed comes from.** Proposed on 2026-09-25, the fourth decision record the
    owner asked for. Each claim below names the cost it removes, priced against a row of
    `docs/costs.md`, and the check that tests it. Each fast path is an A/B against the checked
    path on the Linux machine, five runs, median and spread (decision 10), and stays only when it
    wins by more than the noise. The last column names the baselines whose own documentation or
    published write-ups describe the same technique. It is a list of what to compare against, and
    nobody confirms it by reading their source (decision 9). A dash means none of them documents it
    that stdx found; the benchmark compares against all of them either way.

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

15. **owner: The checks.** Proposed on 2026-09-25, the fifth decision record the owner asked
    for.

    **The corpora.** Each is a lazy package pinned by hash, fetched by `tools/` and `bench/` and
    never by the library:
    - Silesia, the 12-file corpus at `https://sun.aei.polsl.pl/~sdeor/corpus/silesia.zip`.
    - Canterbury: `cantrbry.tar.gz` and `large.tar.gz` from `https://corpus.canterbury.ac.nz`.
    - HTTP-shaped payloads: HTML, JSON, JavaScript and CSS, each cut to 1 KiB, 16 KiB and 1 MiB by
      a tool, from files whose licences let stdx fetch and run them. Proposed sources, for the
      owner to rule on: the HTML of RFC 9110 from rfc-editor.org; the Unicode CLDR JSON data
      (Unicode licence); three.js's build (MIT); and Bootstrap's CSS (MIT), each from its npm
      tarball where it has one, so the hash pins an archive.

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
      (§3.1.1.1.4) is refused, as §8 warns. Content_Checksum is compared when present, and
      skippable frames are skipped (§3.1.2).
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
      records how long it ran and what it found.

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

16. **owner: Where a hot loop may leave the checked reader and writer.** Proposed on 2026-09-25,
    to resolve the first conflict the owner named: fast decoders use table-driven multi-symbol
    lookups, wide bit buffers, word-at-a-time copies that overrun on purpose, and SIMD, while
    CLAUDE.md sends all parsing through a checked reader and all output through a checked writer.

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
    - `@setRuntimeSafety(false)` appears nowhere in version one. An exception needs an A/B of the
      same function with safety on and off on the Linux machine, five runs each over all three
      corpora, a gain above the 5% noise floor, a new row in this entry with the numbers, and the
      owner's ruling.
    - A lint rule, `input-index`, lands with the `codec` module (design §8 step 3). Outside the
      reader, the writer and the functions below, it refuses an index or a slice bound derived
      from a value the reader produced, as colibri's `peer-index` rule does for peer input.

    **The fast paths, with the measurement each must show.** None exists yet. Each row's numbers
    are filled in by the step that writes it, and a row whose A/B does not beat the checked path
    by more than the noise is deleted with its code.

    | Function | Step | Input slack | Output slack | Measurement that admits it |
    |---|---|---|---|---|
    | DEFLATE symbol loop (S1 to S3) | 7 | 8 octets per refill, at most 2 refills per iteration | 258 plus 16 | Throughput against the checked path on all three corpora |
    | DEFLATE and brotli match copy (S4) | 7, 12 | none | 258 plus 16 for DEFLATE; `chunk_len_max` plus 16 for brotli | As above |
    | Zstandard literal decoding, four streams (Z1, Z2) | 11 | 8 octets before each stream's position, read backward | none: literals go to the state's literal buffer, whose size is fixed | As above |
    | Zstandard sequence execution (Z4) | 11 | none | `chunk_len_max` plus 16 | As above |
    | brotli command loop | 12 | 8 octets per refill | `chunk_len_max` plus 16 | As above |
    | Every encoder's bit writer (E5) | 9, 13, 14 | none | 8 octets | Encode throughput against the checked writer |

    The alternatives refused:
    - The checked reader and writer everywhere, with no fast path. It is the simplest, and
      colibri's survey shows what it gives up: Wuffs, which has a fast path, decodes at 1.5 to 1.9
      times zlib's speed, and the decoders without one run at zlib's speed or below.
    - Raw pointers with safety off in every hot loop, as C decoders do. It is the fastest, and a
      wrong margin becomes memory corruption. That is the class of CVE-2016-9841 and
      CVE-2022-37434 in zlib's decoder, which colibri's survey lists.
    - Slack the caller provides: buffers that carry extra octets past the length they report. It
      changes every caller's contract, and it breaks the output room of one octet h11 asked for.

17. **owner: Assertions in production, and what they cost in the inner loops.** Proposed on
    2026-09-25, to resolve the second conflict the owner named.

    **What stays on.** The build offers Debug and ReleaseSafe only. In ReleaseSafe the compiler
    keeps three kinds of check: slice bounds, integer overflow, and `unreachable`, which is what
    `std.debug.assert` compiles to. stdx adds its own assertions, about two per function.

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

    **The measurement,** made by each codec's fast-path step on the Linux machine, and written
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

    The alternatives refused:
    - Safety off in the hot functions only, with `@setRuntimeSafety(false)`. It turns every
      assertion there into an assumption the optimizer relies on, which is the opposite of a
      check. Decision 16 admits it only function by function, with a measurement and a ruling.
    - A build option that turns assertions off for callers. A caller would ship with it off, and
      the invariants would stop being checked where it matters.
    - Assertions per symbol in the fast paths. On a 1 MiB body, that is millions of branches per
      call to check what the margin already proves.

18. **owner: XXH64, which RFC 8878 defines by reference.** Proposed on 2026-09-25. A Zstandard
    frame's Content_Checksum is the low 32 bits of XXH64 with seed 0 (RFC 8878 §3.1.1). RFC 8878
    cites xxHash by a URL and gives no algorithm, and no RFC defines it. Decision 9 allows the RFCs
    alone.

    Proposal: read xxHash's own specification document (`doc/xxhash_spec.md` in
    github.com/Cyan4973/xxHash), which is a specification in prose and not an implementation's
    source. Copy it unmodified into `docs/specs/`, pinned by commit and SHA-256 like the RFCs, and
    check stdx's XXH64 against libzstd's checksums through the oracle, once libzstd is ruled in.

    The alternatives refused:
    - Skipping the check. It is what decision 4 names as a defect of Zig's DEFLATE decoder.
    - Reading libzstd's or xxHash's source. Decision 9 forbids it.
