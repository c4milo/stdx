# stdx.unicode

`stdx.unicode` holds Unicode 17.0.0's general categories, scripts and simple case folding
([decision 86](../../docs/decisions.md)). [`stdx.unicode.utf8`](utf8/README.md) is UTF-8.

## Use

```zig
/// True when the code point `scalar` has the property `name`, such as the script "Greek".
fn has_property(name: []const u8, scalar: u32) bool {
    const ranges = stdx.unicode.property(name) orelse return false;
    for (ranges) |range| {
        if (scalar >= range.lo and scalar <= range.hi) return true;
    }
    return false;
}
```

Each example is an excerpt of [`tools/consumer/main.zig`](../../tools/consumer/main.zig), a program
that `zig build test` builds against this tree and runs.

## What it holds

- `property(name)`: the ranges of the property that a name names, in order and apart, or null. A
  name is a General_Category value, a group of them, a Script, or `Any`, `ASCII` or `Assigned`.
- `simple_fold(scalar)`: the next code point of a code point's case orbit. `images` gives the next
  code points of a range's.
- `version`: the version of the Unicode Character Database, "17.0.0".
- `utf8`: the module [`stdx.unicode.utf8`](utf8/README.md).

The tables come from the data files of Unicode 17.0.0 in
[`tools/unicode/ucd`](../../tools/unicode/ucd). `zig build test` fails when the committed tables
differ from what those files give.
