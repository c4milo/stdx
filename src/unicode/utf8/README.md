# stdx.unicode.utf8

`stdx.unicode.utf8` is UTF-8 ([RFC 3629](https://www.rfc-editor.org/rfc/rfc3629)). Its folder is
`src/unicode/utf8`. `stdx.encoding.json` and `stdx.regex` read and write characters through it.

## Use

```zig
/// True when `bytes` is UTF-8 whole.
fn is_utf8(bytes: []const u8) bool {
    var validator: stdx.unicode.utf8.Validator = .{};
    for (bytes) |byte| {
        if (!validator.accept(byte)) return false;
    }
    return validator.between_characters();
}
```

Each example is an excerpt of [`tools/consumer/main.zig`](../../../tools/consumer/main.zig), a program
that `zig build test` builds against this tree and runs.

## What it holds

- `Validator`: checks a text one byte at a time, and keeps a character that two calls split.
  [`spec/lean/Stdx/Utf8.lean`](../../../spec/lean/Stdx/Utf8.lean) proves it against RFC 3629 §4's
  syntax ([decision 28](../../../docs/decisions.md)).
- `character_len`: the bytes of the one character that starts a slice, or null.
- `encoded_len`, `encode` and `encoded`: a code point as UTF-8.
- `decode`: the code point of one character that the program checked.

The module imports nothing.
