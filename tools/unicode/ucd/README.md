# Unicode 17.0.0's data files

`tools/unicode/unicode_tables.zig` writes the `unicode` module's tables,
`src/unicode/unicode_tables.zig`, from the four data files of the Unicode Character Database
here (decision 86 as amended). They are the tool's input. No build of the library reads them,
and the package that `zig fetch` keeps does not hold them.

`SHA256SUMS` records each file's checksum, and `tools/ci.sh` checks it. Check by hand with:

```bash
cd tools/unicode/ucd && shasum -a 256 -c SHA256SUMS
```

## Where each copy came from

- `CaseFolding.txt`, `DerivedGeneralCategory.txt`, `PropertyValueAliases.txt` and `Scripts.txt`
  were downloaded on 2026-11-22 from `https://www.unicode.org/Public/17.0.0/ucd/`, unmodified.
  DerivedGeneralCategory.txt comes from that folder's `extracted/` folder.
- `license.txt`, the Unicode License v3, came from `https://www.unicode.org/license.txt` the same
  day. It allows copies of the data files with its notice beside them.

## What the tool reads

| File | What the tool reads from it |
|---|---|
| `DerivedGeneralCategory.txt` | Each code point's General_Category of two letters |
| `PropertyValueAliases.txt` | Each General_Category value's names: its `gc` lines alone |
| `Scripts.txt` | Each code point's Script, named by the Script's long name |
| `CaseFolding.txt` | The simple case folding: its lines of status C and S |

## The reports the tables follow

Unicode's terms of use allow copies of its technical reports for personal or internal use alone,
not for public distribution. So this folder holds no copy of the two reports the `unicode` module
follows. Each is named here with the SHA-256 of the copy read on 2026-11-22:

- UAX #44, Unicode Character Database, revision 36, the one for Unicode 17.0.0:
  `https://www.unicode.org/reports/tr44/tr44-36.html`, SHA-256
  `a97ed3f9dbee8e9a917106a3dc49a0fdeead42e2be06ea6f5cc31117eda3da33`. The tables follow its data
  files' format (§4.2), its groups of General_Category values (§5.7.1), their names (§5.8.2) and
  rule UAX44-LM3 (§5.9.3).
- UTS #18, Unicode Regular Expressions, revision 25:
  `https://www.unicode.org/reports/tr18/tr18-25.html`, SHA-256
  `68e34b8ba02dac859bfabac7f8d1ecbd08fbc9ec00aa003f239fe3ca7198c70d`. The tables follow its
  properties (RL1.2, §1.2.4 and §1.2.5) and its match without case (RL1.5).
