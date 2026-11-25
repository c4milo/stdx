# stdx.compress.zlib

`stdx.compress.zlib` is the zlib container ([RFC 1950](https://www.rfc-editor.org/rfc/rfc1950))
around a DEFLATE stream, with its Adler-32. HTTP's `deflate` coding names this format, and not raw
DEFLATE (RFC 9110 §8.4.1.2).

## Use

```zig
/// Decodes the zlib stream `body`, which HTTP names `deflate`, into `output`.
fn inflate(features: stdx.platform.CpuFeatures, body: []const u8, output: []u8) ![]u8 {
    var decoder: stdx.compress.zlib.Decoder = undefined; // about 43 KiB
    decoder.init(features);
    const whole = try decoder.decode_all(body, output);
    return output[0..whole.written];
}
```

Each example is an excerpt of [`tools/consumer/main.zig`](../../../tools/consumer/main.zig), a program
that `zig build test` builds against this tree and runs.

## What it holds

- `Decoder`: about 43 KiB. It checks the stream's Adler-32.
- `Encoder(options)`: the levels and the options of
  [`stdx.compress.deflate`](../deflate/README.md).
- `IoReader` and `IoWriter`: the decoder as a `std.Io.Reader`, and the encoder as a
  `std.Io.Writer`.
- `Error`: one value for each cause. A stream that needs a preset dictionary is
  `error.PresetDictionary`, which stdx refuses.

Each call follows the [streaming contract](../../codec/README.md).

## Performance

The container adds a header and a checksum to a DEFLATE stream.
[`stdx.compress.deflate`](../deflate/README.md#performance) shows the charts.
