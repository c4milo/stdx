# RFCs

These are the plain-text RFCs stdx is written from, unmodified. CLAUDE.md non-negotiable 5 says to
read the RFCs themselves rather than a summary or another implementation's source; these copies
are what that sentence points at, so every reader works from the same bytes.

`SHA256SUMS` records each file's checksum. Check that nothing was edited with:

```bash
cd docs/rfcs && shasum -a 256 -c SHA256SUMS
```

## Where each copy came from

- RFC 1950, 1951 and 1952 were copied on 2026-09-25 from colibri's `docs/rfcs/compression/`,
  which took them from `https://www.rfc-editor.org/rfc/rfcNNNN.txt` the same day. Their SHA-256
  sums equal the sums in colibri's `docs/rfcs/SHA256SUMS`.
- RFC 7932, 9841, 8878 and 9659 were downloaded on 2026-09-25 from
  `https://www.rfc-editor.org/rfc/rfcNNNN.txt`.

## Later revisions

On 2026-09-25, `https://www.rfc-editor.org/rfc/rfcNNNN.json` named no RFC that obsoletes any of the
seven. Two are updated by another RFC in this directory, and a check that exists because of the
update cites the update:

- RFC 7932 is updated by RFC 9841.
- RFC 8878 is updated by RFC 9659. RFC 8878 obsoletes RFC 8478, which stdx never reads or cites.

Check again before relying on a section, and record a new revision here.

## Errata

An erratum is not part of the RFC, so it is not copied here. The ones that change what a decoder
or encoder does are listed below, as the RFC Editor's errata pages showed them on 2026-09-25. A
check that follows an erratum cites the RFC section and names the erratum in the same comment.
Read the erratum at its URL before implementing the section it corrects.

| RFC | Erratum | Status | Section | What it corrects |
|---|---|---|---|---|
| 8878 | [6441](https://www.rfc-editor.org/errata/eid6441) | Verified | Appendix A | Duplicate all-zero rows in the decoding tables of the default distributions |
| 8878 | [6442](https://www.rfc-editor.org/errata/eid6442) | Verified | 3.1.1.5 | One `offset_value` in Table 18 |
| 8878 | [7297](https://www.rfc-editor.org/errata/eid7297) | Verified | 3.1.1.3.1.1 | The value ranges of Regenerated_Size and Compressed_Size in four-stream mode |
| 8878 | [8085](https://www.rfc-editor.org/errata/eid8085) | Reported | 3.1.1.5 | Table 18 again, overlapping 6442 |
| 8878 | [8195](https://www.rfc-editor.org/errata/eid8195) | Reported | 4.2.2 | The example symbol codes and bitstream |
| 7932 | [6977](https://www.rfc-editor.org/errata/eid6977) | Reported | 9.3 | Block switch bookkeeping when the distance code is implicitly 0 |
| 1951 | [7764](https://www.rfc-editor.org/errata/eid7764) | Reported | 3.2.5 | The bit order of extra bits |
| 1951 | [8429](https://www.rfc-editor.org/errata/eid8429) | Reported | 3.2.7 | Wording of the single distance code of length zero |

A reported erratum has not been verified by the RFC's stream. Where one disagrees with the RFC
text, stdx follows the text and records the case in the differential checks' verdicts (decision
15), so the oracles decide nothing on their own.

## Compression

| RFC | Title | What stdx uses it for |
|---|---|---|
| [1951](rfc1951.txt) | DEFLATE Compressed Data Format Specification version 1.3 | `deflate`, and the stream inside both containers |
| [1950](rfc1950.txt) | ZLIB Compressed Data Format Specification version 3.3 | `zlib`, and the Adler-32 check in `checksum`. HTTP's `deflate` coding is this format |
| [1952](rfc1952.txt) | GZIP file format specification version 4.3 | `gzip`, and the CRC-32 check in `checksum` |
| [8878](rfc8878.txt) | Zstandard Compression and the 'application/zstd' Media Type | `zstd`. Its Content_Checksum is XXH64, which the RFC defines by reference only (decision 18) |
| [9659](rfc9659.txt) | Window Sizing for Zstandard Content Encoding | The `zstd` HTTP coding's window of 8 MB (decision 12) |
| [7932](rfc7932.txt) | Brotli Compressed Data Format | `brotli`, its static dictionary (Appendix A) and its CRC-32 check values (Appendix C) |
| [9841](rfc9841.txt) | Shared Brotli Compressed Data Format | Read to refuse its large-window signature by name; out of version one otherwise (decision 13) |

RFC 9110 §8.4 defines the HTTP content codings these formats serve. stdx makes no check that RFC
9110 demands, so it is not copied here; colibri keeps a copy.
