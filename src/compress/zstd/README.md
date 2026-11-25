# stdx.compress.zstd

`stdx.compress.zstd` is Zstandard ([RFC 8878](https://www.rfc-editor.org/rfc/rfc8878)) with
[RFC 9659](https://www.rfc-editor.org/rfc/rfc9659)'s limits for HTTP: an encoder and a decoder.
HTTP's `zstd` coding names this format.

## Use

```zig
/// Encodes `input` as one Zstandard frame at level 3, with its checksum, into `output`.
fn zstd_frame(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures, input: []const u8, output: []u8) ![]u8 {
    const Encoder = stdx.compress.zstd.Encoder(.{ .level = 3, .checksum = true });
    const encoder = try gpa.create(Encoder); // about 3.8 MiB
    defer gpa.destroy(encoder);
    encoder.init(features);
    const len = try encoder.encode_all(input, output);
    return output[0..len];
}
```

```zig
/// Decodes the Zstandard frames of `body` into `output`, within the window that HTTP allows.
fn unzstd(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures, body: []const u8, output: []u8) ![]u8 {
    const decoder = try gpa.create(stdx.compress.zstd.HttpDecoder); // about 8.3 MiB, its window included
    defer gpa.destroy(decoder);
    decoder.init(features);
    const whole = try decoder.decode_all(body, output);
    return output[0..whole.written];
}
```

Each example is an excerpt of [`tools/consumer/main.zig`](../../../tools/consumer/main.zig), a program
that `zig build test` builds against this tree and runs.

## What it holds

- `HttpDecoder`: the decoder of the `zstd` coding. It takes a window of 2^23 bytes at most (RFC
  9659 §3), and its state of about 8.3 MiB holds that window.
- `Decoder(options)`: a decoder with another `window_len_max`, for a program outside HTTP.
- `Encoder(options)`: level 1 or 3, and level 3 by default. Its state is about 1.8 MiB at level 1
  and about 3.8 MiB at level 3.
- `EncoderOptions.window_log`: the window of a frame, 2^19 bytes at level 1 and 2^21 at level 3 by
  default, and 2^17 at the least.
- `EncoderOptions.checksum`: whether a frame ends with its checksum.
- `Encoder.start`: starts the next frame of an encoder that `init` started. It clears no table
  ([decision 60](../../../docs/decisions.md)).
- `IoReader`, `HttpIoReader` and `IoWriter`: the `std.Io` interfaces.

The decoder refuses two things as unsupported: a frame whose window passes the decoder's
(`error.WindowTooLarge`), and a frame that needs a dictionary (`error.DictionaryUnsupported`).

Each call follows the [streaming contract](../../codec/README.md).

## Performance

On GitHub's Arm Neoverse N2 runner, stdx decodes Zstandard slower than libzstd on 25 of the 39
corpus files. libzstd's level 3 is both faster and smaller than stdx's levels 1 and 3.

One job, from the first runs on Ubuntu 26.04, at commit 0dd2e97. A blue bar is ahead, a gray bar is
level inside the noise, and an orange bar is behind. An encoder's panel plots speed against
compression ratio. [`docs/benchmarks.md`](../../../docs/benchmarks.md#zstandard) lists the counts of each panel, and
says how to run the benchmark again.

![stdx's Zstandard against its baselines, on Neoverse-N2](../../../docs/images/zstd-aarch64.svg)

<details>
<summary>x86-64: Intel Xeon Platinum 8370C</summary>

![stdx's Zstandard against its baselines, on Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz](../../../docs/images/zstd-x86_64.svg)

</details>
