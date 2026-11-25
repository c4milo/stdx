# stdx.base64

`stdx.base64` is base 64 ([RFC 4648](https://www.rfc-editor.org/rfc/rfc4648) §4), with the URL and
filename safe alphabet of §5: an encoder and a decoder ([decision 68](../../docs/decisions.md)).

## Use

```zig
/// Writes `bytes` as base 64 into `output`, and returns the text.
fn base64_text(features: stdx.platform.CpuFeatures, bytes: []const u8, output: []u8) ![]u8 {
    var encoder: stdx.base64.Encoder = undefined;
    encoder.init(.{}, features);
    const len = try encoder.encode_all(bytes, output);
    return output[0..len];
}
```

```zig
/// Decodes the base 64 `letters` into `output`, in either alphabet, and returns the bytes.
fn base64_bytes(features: stdx.platform.CpuFeatures, letters: []const u8, output: []u8) ![]u8 {
    var decoder: stdx.base64.Decoder = undefined;
    decoder.init(.{}, features);
    const len = try decoder.decode_all(letters, output);
    return output[0..len];
}
```

Each example is an excerpt of [`tools/consumer/main.zig`](../../tools/consumer/main.zig), a program
that `zig build test` builds against this tree and runs.

## What it holds

- `Encoder`: `EncoderOptions` chooses the alphabet, and whether a final group ends with its pad
  characters.
- `Decoder`: it takes either alphabet in one pass, and `alphabet` says which one a text used. It
  refuses a text that mixes them, and any byte outside them.
- `DecoderOptions.accept`: either alphabet, or one of them alone.
- `DecoderOptions.padding`: whether a text must, may, or must not hold pad characters.
- `DecoderOptions.pad_bits`: by default the decoder refuses a final group whose unused bits are
  not zero, so each byte string has one text that decodes to it. A program may drop those bits.
- `Encoder.encoded_len` and `Decoder.decoded_len`: the length that a call writes.
- `Error`: one value for each cause.

Each call follows the [streaming contract](../codec/README.md).

## Performance

One job, from the first runs on Ubuntu 26.04, at commit 0dd2e97. A blue bar is ahead, a gray bar is
level inside the noise, and an orange bar is behind. An encoder's panel plots speed against
compression ratio. [`docs/benchmarks.md`](../../docs/benchmarks.md#base-64) lists the counts of each panel, and
says how to run the benchmark again.

![stdx's base64 against its baselines, on Neoverse-N2](../../docs/images/base64-aarch64.svg)

<details>
<summary>x86-64: AMD EPYC 7763</summary>

![stdx's base64 against its baselines, on AMD EPYC 7763 64-Core Processor](../../docs/images/base64-x86_64.svg)

</details>
