# stdx.encoding.base64

`stdx.encoding.base64` is base 64 ([RFC 4648](https://www.rfc-editor.org/rfc/rfc4648) §4), with the URL and
filename safe alphabet of §5: an encoder and a decoder ([decision 68](../../../docs/decisions.md)).

## Use

```zig
/// Writes `bytes` as base 64 into `output`, and returns the text.
fn base64_text(features: stdx.platform.CpuFeatures, bytes: []const u8, output: []u8) ![]u8 {
    var encoder: stdx.encoding.base64.Encoder = undefined;
    encoder.init(.{}, features);
    const len = try encoder.encode_all(bytes, output);
    return output[0..len];
}
```

```zig
/// Decodes the base 64 `letters` into `output`, in either alphabet, and returns the bytes.
fn base64_bytes(features: stdx.platform.CpuFeatures, letters: []const u8, output: []u8) ![]u8 {
    var decoder: stdx.encoding.base64.Decoder = undefined;
    decoder.init(.{}, features);
    const len = try decoder.decode_all(letters, output);
    return output[0..len];
}
```

Each example is an excerpt of [`tools/consumer/main.zig`](../../../tools/consumer/main.zig), a program
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

Each call follows the [streaming contract](../../codec/README.md).

## Performance

The chart is the latest release's: one job on each of GitHub's runners, which the `bench` workflow
runs on each release tag. A blue bar is ahead, a gray bar is level inside the noise, and an orange
bar is behind. A green ▲ or a red ▼ after a row's name marks a row 5% or more faster or
slower than at the previous release, measured in the same job.
[The page of the branch `charts`](https://github.com/c4milo/stdx/blob/charts/benchmarks.md) lists the counts of each panel, and
[`docs/benchmarks.md`](../../../docs/benchmarks.md#base-64) says how to read the chart and run the
benchmark again.

![stdx's base64 against its baselines, at the latest release, on GitHub's Arm Neoverse N2 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/base64-aarch64.svg)

<details>
<summary>x86-64: the CPU model of the release's job</summary>

![stdx's base64 against its baselines, at the latest release, on GitHub's x86-64 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/base64-x86_64.svg)

</details>
