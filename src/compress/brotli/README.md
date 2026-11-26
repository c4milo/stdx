# stdx.compress.brotli

`stdx.compress.brotli` is brotli ([RFC 7932](https://www.rfc-editor.org/rfc/rfc7932)): an encoder
and a decoder. HTTP's `br` coding names this format.

## Use

```zig
/// Encodes `input` as one brotli stream at level 1 into `output`, and returns the stream.
fn brotli_stream(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures, input: []const u8, output: []u8) ![]u8 {
    const Encoder = stdx.compress.brotli.Encoder(.{});
    const encoder = try gpa.create(Encoder); // about 650 KiB
    defer gpa.destroy(encoder);
    encoder.init(features);
    const len = try encoder.encode_all(input, output);
    return output[0..len];
}
```

```zig
/// Decodes the brotli stream `body` into `output`, at any window that RFC 7932 allows.
fn unbrotli(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures, body: []const u8, output: []u8) ![]u8 {
    const decoder = try gpa.create(stdx.compress.brotli.HttpDecoder); // about 18.6 MiB, its window included
    defer gpa.destroy(decoder);
    decoder.init(features);
    const whole = try decoder.decode_all(body, output);
    return output[0..whole.written];
}
```

Each example is an excerpt of [`tools/consumer/main.zig`](../../../tools/consumer/main.zig), a program
that `zig build test` builds against this tree and runs.

## What it holds

- `HttpDecoder`: the decoder that the `br` coding needs. It takes every window that RFC 7932
  allows, up to WBITS 24, and its state of about 18.6 MiB holds that window.
- `Decoder(options)`: a decoder with a smaller `window_bits_max`. It takes a smaller window, and
  refuses a larger stream with `error.WindowTooLarge`.
- `Encoder(options)`: level 1 or 5, and level 1 by default. Its state is about 650 KiB at level 1
  and about 7.1 MiB at level 5.
- `EncoderOptions.window_bits`: WBITS, 18 at level 1 and 22 at level 5 by default, and 16 at the
  least.
- `Encoder.start`: starts the next stream of an encoder that `init` started.
- `IoReader`, `HttpIoReader` and `IoWriter`: the `std.Io` interfaces.

stdx leaves out RFC 9841's large windows, shared dictionaries and framing format
([decision 13](../../../docs/decisions.md)). The decoder refuses a large-window stream with `error.LargeWindow`.

Each call follows the [streaming contract](../../codec/README.md).

## Performance

The chart is the latest release's: one job on each of GitHub's runners, which the `bench` workflow
runs on each release tag. A blue bar is ahead, a gray bar is level inside the noise, and an orange
bar is behind. An encoder's panel plots speed against compression ratio. A green ▲ or a red ▼ after a row's name marks a row 5% or more faster or
slower than at the previous release, measured in the same job.
[The page of the branch `charts`](https://github.com/c4milo/stdx/blob/charts/benchmarks.md) lists the counts of each panel, and
[`docs/benchmarks.md`](../../../docs/benchmarks.md#brotli) says how to read the chart and run the
benchmark again.

![stdx's brotli against its baselines, at the latest release, on GitHub's Arm Neoverse N2 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/brotli-aarch64.svg)

<details>
<summary>x86-64: the CPU model of the release's job</summary>

![stdx's brotli against its baselines, at the latest release, on GitHub's x86-64 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/brotli-x86_64.svg)

</details>
