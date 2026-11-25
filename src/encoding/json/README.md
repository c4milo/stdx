# stdx.encoding.json

`stdx.encoding.json` is JSON ([RFC 8259](https://www.rfc-editor.org/rfc/rfc8259)) with JSON text sequences
([RFC 7464](https://www.rfc-editor.org/rfc/rfc7464)): an encoder and a pull decoder
([decision 27](../../../docs/decisions.md)).

## Use

```zig
/// Writes the JSON text `{"code":<code>,"message":"<message>"}` into `output`, and returns it.
fn write_event(features: stdx.platform.CpuFeatures, code: u64, message: []const u8, output: []u8) ![]const u8 {
    var writer = stdx.encoding.json.TextWriter.init(output, .text, features);
    try writer.begin_object();
    try writer.member_unsigned("code", code);
    try writer.member_string("message", message);
    try writer.end_object();
    return writer.written();
}
```

```zig
/// The string that the first member `name` with a string for its value holds in the JSON text
/// `json`, or null. `storage` takes the bytes of a string that the text escapes.
fn string_member(features: stdx.platform.CpuFeatures, json: []const u8, name: []const u8, storage: []u8) !?[]const u8 {
    var reader = stdx.encoding.json.TextReader.init(json, storage, .text, features);
    if (!reader.next_text()) return null;
    var named = false;
    while (try reader.next()) |item| {
        switch (item) {
            .name => |bytes| named = std.mem.eql(u8, bytes, name),
            .string => |bytes| if (named) return bytes,
            else => named = false,
        }
    }
    return null;
}
```

- `TextWriter` returns `error.NoSpaceLeft` when a token does not fit, and writes nothing past the
  buffer.
- `TextReader.next` gives a text's next token, or null at its end. Call `next_text` before the
  first `next`.
- The bytes of a name, a string or a number stay in the input. Where the text escapes them, they
  go into `storage`, and they stay there until the next call.

Each example is an excerpt of [`tools/consumer/main.zig`](../../../tools/consumer/main.zig), a program
that `zig build test` builds against this tree and runs.

## What it holds

- `TextWriter`: writes one text into one buffer, a token for each call. A `member_` call writes a
  member's name and its value.
- `TextReader`: reads the tokens of a text that one buffer holds. `next_items` gives every token
  that the reader has ready in one call.
- `Encoder` and `Decoder`: the streaming calls that the two helpers are built on, for a text that
  arrives or leaves in pieces.
- `Framing`: one text (`.text`), or a text of a sequence (`.sequence`).
- `encode_value` and `decode_value`: a text from a Zig value, and a Zig value from a text
  ([decision 61](../../../docs/decisions.md)).
- `is_utf8`: whether a buffer is UTF-8 whole.

A text may hold 1,024 objects and arrays open at once. A deeper text is `error.DepthTooLarge`.

## Performance

On GitHub's Arm Neoverse N2 runner, `TextWriter` writes JSON at 1.64 to 16.35 times serde_json's
speed.

One job, from the first runs on Ubuntu 26.04, at commit 0dd2e97. A blue bar is ahead, a gray bar is
level inside the noise, and an orange bar is behind. An encoder's panel plots speed against
compression ratio. [`docs/benchmarks.md`](../../../docs/benchmarks.md#json) lists the counts of each panel, and
says how to run the benchmark again.

![stdx's JSON against its baselines, on Neoverse-N2](../../../docs/images/json-aarch64.svg)

<details>
<summary>x86-64: AMD EPYC 9V45</summary>

![stdx's JSON against its baselines, on AMD EPYC 9V45 96-Core Processor](../../../docs/images/json-x86_64.svg)

</details>
