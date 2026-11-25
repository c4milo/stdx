# stdx.compress.gzip

`stdx.compress.gzip` is the gzip container ([RFC 1952](https://www.rfc-editor.org/rfc/rfc1952))
around a DEFLATE stream, with its CRC-32 and its length. HTTP's `gzip` coding names this format
(RFC 9110 §8.4.1.3).

## Use

```zig
/// Decodes the gzip file `body` into `output`, and returns the decoded octets.
fn gunzip(features: stdx.platform.CpuFeatures, body: []const u8, output: []u8) ![]u8 {
    var decoder: stdx.compress.gzip.Decoder = undefined; // about 43 KiB
    decoder.init(features);
    const whole = try decoder.decode_all(body, output);
    return output[0..whole.written];
}
```

- `decode_all` returns `error.NoSpaceLeft` when `output` fills first, `error.Truncated` when the
  input ends inside a stream, and a `stdx.compress.gzip.Error` for a corrupt stream.
- For input that arrives in pieces, call `decode` with each piece.
  [`stdx.codec`](../../codec/README.md) shows that loop.

Each example is an excerpt of [`tools/consumer/main.zig`](../../../tools/consumer/main.zig), a program
that `zig build test` builds against this tree and runs.

## What it holds

- `Decoder`: about 43 KiB. A call decodes up to the end of one member, and checks the member's
  CRC-32 and its length.
- `Encoder(options)`: the levels and the options of
  [`stdx.compress.deflate`](../deflate/README.md).
- `IoReader`: every member of a gzip file, one after another, as a `std.Io.Reader`.
- `IoWriter(options)`: one member, as a `std.Io.Writer`.
- `Error`: one value for each cause.

## Performance

The container adds a header, a checksum and a length to a DEFLATE stream.
[`stdx.compress.deflate`](../deflate/README.md#performance) shows the charts, which time gzip.
