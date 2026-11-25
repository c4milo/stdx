# stdx.codec

`stdx.codec` holds the streaming contract that every codec of stdx shares
([decision 11](../../docs/decisions.md)).

## The contract

- A call takes the input that the program has and the room that it has. It reads what it can, and
  writes what fits.
- A call returns a `Progress`: the bytes it took, the bytes it wrote, and a `Status`.
- The `Status` says what the next call needs: `needs_input`, `needs_room`, or `done`.
- The next call resumes where the last one stopped. The program splits its input and its output
  as it likes, and the codec gives the same bytes for every split.
- An encoder's caller says with a `Flush` whether more input follows: `none`, `flush`, or
  `finish`.

## Use

```zig
/// Decodes the gzip file that arrives as `pieces` into `output`, and returns the decoded bytes.
/// Each call takes the input and the room that the program has, and says what it needs next.
fn gunzip_pieces(features: stdx.platform.CpuFeatures, pieces: []const []const u8, output: []u8) ![]u8 {
    var decoder: stdx.compress.gzip.Decoder = undefined;
    decoder.init(features);
    var written: usize = 0;
    for (pieces) |piece| {
        const progress = try decoder.decode(piece, output[written..]);
        written += progress.written;
        switch (progress.status) {
            .needs_input => {},
            .needs_room => return error.NoSpaceLeft,
            .done => return output[0..written],
        }
    }
    return error.Truncated;
}
```

Each example is an excerpt of [`tools/consumer/main.zig`](../../tools/consumer/main.zig), a program
that `zig build test` builds against this tree and runs.

## Whole buffers

Each codec has a helper for a program that holds all of the input and all of the room:
`decode_all` and `encode_all`. A helper is built on the streaming call. It returns
`error.Truncated` when the input ends before the stream does, and `error.NoSpaceLeft` when the
output fills first.

## Refusals

A decoder returns one error value for each cause. Each module's `refusal` gives the class of an
error:

- `corrupt`: the input breaks its RFC.
- `unsupported`: the input uses a feature that stdx refuses.

## What it holds

- `Status`, `Progress`, `Flush`, and `Refusal`.
- `Whole` and `Incomplete`: what a whole-buffer helper returns, and its two errors.
- `IoReader` and `IoWriter`: a decoder as a `std.Io.Reader`, and an encoder as a `std.Io.Writer`
  ([decision 56](../../docs/decisions.md)).
- `Reader`, `Writer` and `BitReader`: the checked reader and writer that every codec parses and
  writes through ([decision 16](../../docs/decisions.md)).
- `Window`: the history that a decoder's back-references read.
