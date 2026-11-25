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

Each example is an excerpt of [`tools/consumer/main.zig`](../../tools/consumer/main.zig), a program
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
([decision 13](../../docs/decisions.md)). The decoder refuses a large-window stream with `error.LargeWindow`.

Each call follows the [streaming contract](../codec/README.md).

## Performance

On GitHub's Arm Neoverse N2 runner, stdx decodes brotli faster than Google's decoder on all 39
corpus files, at 1.10 to 3.36 times its speed.

One job, from the first runs on Ubuntu 26.04, at commit 0dd2e97. A blue bar is ahead, a gray bar is
level inside the noise, and an orange bar is behind. An encoder's panel plots speed against
compression ratio. [`docs/benchmarks.md`](../../docs/benchmarks.md#brotli) lists the counts of each panel, and
says how to run the benchmark again.

![stdx's brotli against its baselines, on Neoverse-N2](../../docs/images/brotli-aarch64.svg)

<details>
<summary>x86-64: AMD EPYC 7763</summary>

![stdx's brotli against its baselines, on AMD EPYC 7763 64-Core Processor](../../docs/images/brotli-x86_64.svg)

</details>
