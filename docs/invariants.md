# Invariants

[docs/decisions.md](decisions.md) answers "why is it built this way". This document answers "what
must a change never break". Every entry names the check that proves it.

Each entry has four fields. **Claim** is the invariant. **Mechanism** is what makes it true.
**Check** is what would catch a violation, graded on this scale, strongest first:

1. *type system*: a violation does not compile.
2. *comptime assert*: the property is pinned when the program is built.
3. *runtime assertion*: asserted on every execution, in production, at a contract point that input
   cannot reach (INV-13).
4. *seeded check*: a differential, round-trip or fuzz run over seeds and corpora; a violation
   names the seed and the input that produced it.
5. *lint rule*: a structural or syntactic rule over the tree.
6. *convention*: code review is the only check.

**Violation** is what a breaking change looks like, so review can recognise one.

Each entry names the step of design §8 that lands its check. Step 0's checks exist; every other
check lands with its step.

## Memory and the host

### INV-1: stdx never allocates

- **Claim.** No code under `src/` obtains memory. Every state, window, table and buffer is inside
  a struct the caller placed, or was handed in by the caller for one call.
- **Mechanism.** No module takes, holds or names an `Allocator`, and no source under `src/`
  references `std.heap` or the allocators of `std.testing` (decision 3). Each codec's size is
  `@sizeOf` of its type.
- **Check.** Lint rule `tools/lint/heap.zig`, step 0. A comptime assert pins each decoder's and
  each encoder level's size to its budget in decision 12, in the step that writes it.
- **Violation.** A "temporary" buffer for an oversized header field, or a test that reaches for
  `std.testing.allocator`.

### INV-2: stdx performs no I/O

- **Claim.** No code under `src/` opens, reads, writes or polls anything, starts a thread, or
  prints.
- **Mechanism.** No source names `std.posix`, `std.os`, `std.c`, `std.fs`, `std.net`,
  `std.Thread`, `std.Io`, `std.process`, `std.log` or `std.debug.print` (decision 2).
- **Check.** Lint rule `tools/lint/io.zig`, step 0.
- **Violation.** A debug print left in a decoder, or a helper that decodes a file.

### INV-3: no source reads a clock or randomness

- **Claim.** No code under `src/` reads the time or draws a random number.
- **Mechanism.** No source names `std.time`, `std.Random` or `std.crypto.random` (decision 5).
- **Check.** Lint rule `tools/lint/determinism.zig`, step 0.
- **Violation.** An encoder that gives up on a slow match search after a deadline, or a hash seeded
  at random.

### INV-4: the library keeps no process-wide mutable state

- **Claim.** Two codec instances share nothing, so they run on any threads and compose, one's output
  feeding another's input.
- **Mechanism.** Every table stdx computes once is a comptime `const`. Everything a codec changes is
  in the struct the caller owns (decision 6).
- **Check.** Lint rule `tools/lint/global_state.zig`, step 0: no container-level `var` under
  `src/`.
- **Violation.** A table built lazily on first use into a global.

### INV-5: an output is a pure function of the input and the parameters

- **Claim.** A decoder's output and verdict depend on the input octets alone. An encoder's output
  depends on its input, its level and its flush points alone: not on the host, the build mode, or
  how the caller split the input and the output across calls.
- **Mechanism.** INV-3 and INV-10; an encoder decides a block's contents from the octets it holds,
  never from how many arrived in the last call (decision 11).
- **Check.** Seeded check (decision 15): the same input under many seeded splits gives the same
  octets; the SHA-256 of every encoder output over the corpora is committed and must match on macOS
  arm64 and Linux x86_64, in Debug and ReleaseSafe. Steps 5 and 9.
- **Violation.** An encoder that ends a block when its input buffer runs dry, so a caller feeding
  one octet at a time gets different octets.

## The streaming call

### INV-6: every read is inside the input and every write inside the output

- **Claim.** A call reads only `input[0..input.len]` and history it has written, and writes only
  `output[0..output.len]` and its own state.
- **Mechanism.** The checked reader and writer of `codec`, and fast paths entered and continued only
  while their margins hold (decision 16). Zig's bounds checks stay on in ReleaseSafe (decision 17).
- **Check.** Type system and the compiler's bounds checks for the access itself; seeded check for
  the margins: every fast path writes what the checked path writes, under the fuzzer. Steps 3 and 7.
- **Violation.** A copy that writes 16 octets when only 8 of `output` remain.

### INV-7: the counts stay inside the slices, and the status matches them

- **Claim.** On every return, `consumed <= input.len` and `written <= output.len`. A call that
  returns `needs_input` consumed all of `input`. A call that returns `needs_room` wrote all of
  `output`.
- **Mechanism.** The streaming call's exit (decision 11).
- **Check.** Runtime assertion at every public call's exit, step 3 for the shared helper and each
  codec's step for its call.
- **Violation.** A decoder that stops at a block boundary with input left and reports
  `needs_input`, so a caller waits for input it already gave.

### INV-8: a call makes progress, or its status says why not

- **Claim.** A call consumes or writes at least one octet, or returns `done`, or returns
  `needs_input` with an empty `input`, or `needs_room` with an empty `output`.
- **Mechanism.** The status rules of decision 11. It follows from invariant 7: a call that returns
  `needs_input` took all of its input, and one that returns `needs_room` filled all of its output,
  so either made progress unless its slice was empty. Step 3 found this when a test for a separate
  violation turned out to have no case.
- **Check.** Invariant 7's runtime assertion, `codec.check_progress`, at every public call's exit;
  the split driver's bound on calls per octet; seeded check with empty calls in the split
  schedule. Steps 3 and 5.
- **Violation.** A decoder that returns `needs_room` with room left, so a caller loops forever.

### INV-9: every loop over input-derived counts is bounded

- **Claim.** No loop runs a number of times the input chooses without a limit stdx named.
- **Mechanism.** Loops run over slices of fixed length, or stop at a named constant (CLAUDE.md,
  Non-negotiables).
- **Check.** Lint rule `tools/lint/unbounded_loop.zig`, step 0, for the two shapes it can see;
  INV-17's count for the work.
- **Violation.** `while (reader.remaining() > 0)` over gzip's FEXTRA subfields with no limit.

### INV-10: a decoder reads no history octet it has not written

- **Claim.** A back-reference reads only octets this stream wrote since `init`, in this call's
  output or in the window. This is a boundary between messages, not only a format rule: `init`
  clears no window (decision 11), and a caller that keeps decoders in a pool and takes one per
  message, as colibri's h11 does (colibri's decision 91), hands the next message a window that
  still holds the last one's octets. On a server those can be another client's request body. A
  back-reference that reached them would copy one peer's data into another peer's output, and
  would make the output depend on memory the input never wrote.
- **Mechanism.** Each decoder counts the octets it has written since `init`, up to the window's
  size, and compares every distance with that count before it copies:
  - DEFLATE refuses a distance past the start of the output as `Corrupt` (RFC 1951 §3.2.3). Each
    gzip member starts at zero, because each starts with `init`.
  - Zstandard refuses an offset past the start of the frame (RFC 8878 §3.1.1.3, §3.1.1.4). Only
    a dictionary lets an offset reach past the output decoded so far (§5), and stdx takes none
    (decision 13). Repeat offsets are checked the same way: their first values reach 8 octets
    back before any are decoded, and an offset_value of 3 with a literals_length of 0 means
    Repeated_Offset1 minus 1 (§3.1.1.5), which is 0 when Repeated_Offset1 is 1. An offset counts
    octets back from the current position (§3.1.1.4), so an offset of 0 names no decoded octet.
    RFC 8878 does not name the case, so stdx refuses it as `Corrupt`, failing closed
    (decision 15).
  - brotli reads a distance past the octets produced as a reference into the static dictionary
    (RFC 7932 §8), never into the window. A dictionary reference whose copy length is under 4 or
    over 24, or whose transform_id is over 120, is `Corrupt` (§8), and never falls back to the
    window.
  - Every copy path makes the comparison: the checked path, and each fast path of decision 16,
    whose deliberate overrun writes past the match but never reads before the output's start.
- **Check.** Runtime assertion in each copy, after the comparison that refuses the input. And a
  seeded check at the codec's step, proposed by the colibri session, with a mutation that removes
  the comparison:
  1. Fill a decoder's window with a marker pattern.
  2. Call `init`.
  3. Decode a stream whose first back-reference reaches past the start of its output. For
     Zstandard, also one whose first sequence has an offset_value of 3 and a literals_length of
     0, an offset of 0. For brotli, also dictionary references with a copy length of 3 and of 25,
     and with a transform_id of 121.
  4. Each call must return a `Corrupt` error, except a valid brotli dictionary reference, which
     must write the dictionary word. The marker must appear in no output octet.

  It runs through the checked path and through every fast path, across a gzip member boundary,
  and across a Zstandard frame boundary. Steps 5, 6, 7, 11 and 12.
- **Violation.** A distance checked against the window's size instead of the octets written since
  `init`, which lets a stream read the previous message's octets.

### INV-11: `done` follows every check the format carries

- **Claim.** A decoder reports `done` only after the stream's checksum, length and trailer have
  been compared.
- **Mechanism.** The container reads its trailer before it changes status (decision 15).
- **Check.** Runtime assertion at `done`; seeded check with corrupted checksums and sizes.
  Step 6.
- **Violation.** A gzip decoder that reports `done` at the last DEFLATE block and checks CRC32 on
  the next call, which a caller that stops at `done` never makes.

### INV-12: the state is a plain value

- **Claim.** A codec's state holds no pointer, into itself or elsewhere, so the caller may move or
  copy it between calls and continue from the copy.
- **Mechanism.** Positions are indices into arrays inside the struct (decision 11).
- **Check.** Seeded check: at a seeded call, the harness copies the state to another address and
  continues from the copy, and the output must not change. Step 5.
- **Violation.** A slice into the window kept in the state between calls.

### INV-13: no assertion is reachable from input

- **Claim.** Every refusal of input is an error value. No input, however formed, reaches an
  assertion, a bounds check or an overflow check.
- **Mechanism.** Every check an RFC demands comes before the code that relies on it, and returns
  an error (CLAUDE.md, Non-negotiables).
- **Check.** Seeded check: the fuzzer over arbitrary input, in each codec's step. A panic is a
  failure.
- **Violation.** An assertion that a Huffman code is complete, placed before the check that refuses
  an incomplete one.

## Structure

### INV-14: each library module imports only what design §3 gives it, and no package

- **Claim.** The wrappers build on `deflate` and never the reverse, the codecs do not reach one
  another, and no library module receives pepegrillo, an oracle or a corpus.
- **Mechanism.** A module can import only what `build/modules.zig` gives it.
- **Check.** Lint rule `tools/lint/module_graph.zig` pins the graph; `zig build graph-check`
  compiles fixtures that import a wrapper, another codec, a package and the oracle bindings from
  inside `src/deflate/`, and requires each compile to fail, beside a control that must compile.
  Steps 0 and 2.
- **Violation.** `deflate.addImport("checksum", checksum)` to share a helper.

### INV-15: no source names a consumer

- **Claim.** No `.zig` file in the tree spells the name of a project that consumes stdx.
- **Mechanism.** Decision 1.
- **Check.** Lint rule `tools/lint/denied_words.zig`, step 0.
- **Violation.** A comment explaining that a limit exists because a consumer's server needs it.

### INV-16: every check an RFC demands cites the RFC and the section

- **Claim.** Every `return error.X` under `src/` that refuses input carries `RFC <number> §<section>`
  on its statement or in the comment directly above.
- **Mechanism.** CLAUDE.md, Non-negotiables.
- **Check.** Lint rule `tools/lint/rfc_citation.zig`, step 0. It sees the citation, not whether the
  section says what the check does; review does that.
- **Violation.** A new refusal with a comment that names the RFC and no section.

### INV-17: work per call is linear in the octets consumed and written

- **Claim.** A call does at most a constant amount of work per octet consumed and per octet written,
  plus a constant per call. No stream, valid or not, makes a decoder spend more.
- **Mechanism.** Tables are built once per block, into only the entries the code uses, and a block
  costs input octets (decisions 12 and 14).
- **Check.** Seeded check: a test build counts table entries written and symbols decoded per octet
  consumed on the worst-case generators of decision 15, and `zig build test` bounds the count.
  Steps 5, 11 and 12.
- **Violation.** A brotli decoder that rebuilds a prefix-code table on every block switch.
