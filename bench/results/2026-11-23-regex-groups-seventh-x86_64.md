# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215380058 |
| Date | 2026-11-23 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache and the CPU features it detected at start, as Rust's regex detects them, `stdx, no skip` the same with claims R1 to R5 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

The patterns of the search table:

- literal: a word, in canterbury-large/bible.txt: `Pharaoh`
- literal: a word that is not there, in canterbury-large/bible.txt: `Sherlock`
- literal: one of four words, in canterbury-large/bible.txt: `Abraham|Isaac|Jacob|Joseph`
- literal: a word in any case, in canterbury-large/bible.txt: `(?i)pharaoh`
- literal: an href attribute, in http/html-1m: `href="[^"]*"`
- literal: a word, second text, in canterbury-large/world192.txt: `Population`
- class: two capitalized words, in canterbury-large/bible.txt: `[A-Z][a-z]+ [A-Z][a-z]+`
- class: a word that ends in ing, in canterbury-large/bible.txt: `[a-z]+ing`
- class: a word in capitals, in canterbury-large/bible.txt: `[A-Z][A-Z][A-Z]+`
- class: a number, in http/html-1m: `[0-9]+`
- class: two capitalized words, second text, in canterbury-large/world192.txt: `[A-Z][a-z]+ [A-Z][a-z]+`
- other: a word between two words, in canterbury-large/bible.txt: `the [a-z]+ of`
- other: a number before a unit, second text, in canterbury-large/world192.txt: `[0-9][0-9,]* km`
- other: a heading's start tag, in http/html-1m: `<h[1-6][^>]*>`
- other: a whole word, in canterbury-large/bible.txt: `\bPharaoh\b`, which Rust's regex takes as `(?-u:\b)Pharaoh(?-u:\b)`
- other: a line's first word, second text, in canterbury-large/world192.txt: `(?m)^[A-Z][a-z]+:`
- other: fourteen octets before an x, in canterbury-large/bible.txt: `[a-q][^u-z]{13}x`
- other: a Greek word, in generated: words in four scripts: `[α-ω]+`

## Search in 1 MiB, MB/s

| Pattern | Matches | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| literal: a word | 217 | 28066.61 ± 2.5% | 3504.21 ± 1.5% | 27.84 ± 0.7% | 25991.64 ± 0.3% | 8618.87 ± 9.2% | 12.38 ± 0.9% | 90.50 ± 0.5% | 28075.21 ± 0.5% | 8.01 | 1.00 | 1.08 | 3.26 |
| literal: a word that is not there | 0 | 34436.98 ± 1.4% | 3439.29 ± 0.3% | 28.07 ± 0.3% | 28976.67 ± 0.9% | 23630.51 ± 1.2% | 12.14 ± 0.1% | 85.62 ± 2.3% | 34427.00 ± 0.3% | 10.01 | 1.00 | 1.19 | 1.46 |
| literal: one of four words | 661 | 10810.35 ± 2.4% | 1630.93 ± 0.5% | 14.61 ± 0.6% | 8012.27 ± 1.9% | 21.23 ± 1.3% | 3.79 ± 0.8% | 7.17 ± 2.5% | 10662.13 ± 2.4% | 6.63 | 1.01 | 1.35 | 509.24 |
| literal: a word in any case | 217 | 23387.81 ± 0.5% | 1718.40 ± 0.2% | 19.95 ± 1.4% | 8219.26 ± 7.8% | 40.82 ± 2.0% | refused | differs | 23189.45 ± 0.7% | 13.61 | 1.01 | 2.85 | 572.98 |
| literal: an href attribute | 33 | 22755.25 ± 1.1% | 583.24 ± 0.2% | 24.34 ± 0.2% | 23350.40 ± 1.9% | 1906.19 ± 0.3% | 9.04 ± 0.2% | 79.99 ± 0.6% | 22816.65 ± 0.6% | 39.02 | 1.00 | 0.97 | 11.94 |
| literal: a word, second text | 123 | 29505.41 ± 0.8% | 2609.26 ± 0.6% | 27.69 ± 0.8% | 25921.12 ± 0.6% | 6715.74 ± 5.3% | 15.21 ± 0.2% | 78.40 ± 0.6% | 29497.49 ± 0.4% | 11.31 | 1.00 | 1.14 | 4.39 |
| class: two capitalized words | 1331 | 859.56 ± 0.4% | 564.67 ± 0.2% | 25.48 ± 0.1% | 544.72 ± 0.3% | 36.42 ± 7.1% | 10.58 ± 2.1% | 65.63 ± 0.6% | 859.65 ± 0.4% | 1.52 | 1.00 | 1.58 | 23.60 |
| class: a word that ends in ing | 3399 | 533.01 ± 0.2% | 532.60 ± 0.4% | 16.65 ± 0.1% | 503.77 ± 0.4% | 27.14 ± 8.3% | 5.85 ± 0.2% | 18.32 ± 0.3% | 532.58 ± 0.2% | 1.00 | 1.00 | 1.06 | 19.64 |
| class: a word in capitals | 2332 | 1124.10 ± 3.7% | 565.51 ± 0.2% | 27.05 ± 2.0% | 533.38 ± 0.2% | 39.21 ± 1.9% | 12.49 ± 2.4% | 82.03 ± 0.3% | 1123.51 ± 0.5% | 1.99 | 1.00 | 2.11 | 28.67 |
| class: a number | 8288 | 1662.23 ± 0.4% | 670.75 ± 1.1% | 27.23 ± 0.4% | 1641.35 ± 0.3% | 35.85 ± 14.1% | 0.36 ± 0.4% | 60.50 ± 0.6% | 1670.70 ± 0.5% | 2.48 | 0.99 | 1.01 | 46.37 |
| class: two capitalized words, second text | 5359 | 469.05 ± 0.4% | 474.80 ± 0.3% | 20.12 ± 13.2% | 442.96 ± 0.3% | 29.58 ± 13.1% | 13.24 ± 0.0% | 60.48 ± 0.5% | 468.23 ± 1.0% | 0.99 | 1.00 | 1.06 | 15.86 |
| other: a word between two words | 6104 | 728.90 ± 0.4% | 527.13 ± 0.3% | 22.38 ± 9.2% | 729.67 ± 0.4% | 99.15 ± 16.8% | 8.01 ± 0.2% | 70.99 ± 0.3% | 733.02 ± 0.6% | 1.38 | 0.99 | 1.00 | 7.35 |
| other: a number before a unit, second text | 1481 | 7605.65 ± 1.8% | 958.04 ± 1.5% | 25.96 ± 0.4% | 6707.06 ± 0.5% | 36.83 ± 5.6% | 13.99 ± 18.3% | 64.68 ± 13.0% | 7323.46 ± 1.1% | 7.94 | 1.04 | 1.13 | 206.49 |
| other: a heading's start tag | 110 | 18269.14 ± 3.3% | 674.15 ± 0.2% | 27.09 ± 2.4% | 2033.26 ± 1.4% | 1366.09 ± 7.6% | 10.97 ± 1.0% | 91.93 ± 0.3% | 18077.93 ± 4.4% | 27.10 | 1.01 | 8.99 | 13.37 |
| other: a whole word | 217 | 21282.48 ± 2.3% | 575.85 ± 0.7% | 28.35 ± 0.5% | 20012.85 ± 0.5% | 45.92 ± 0.9% | 10.57 ± 0.3% | 52.69 ± 7.4% | 21241.72 ± 10.2% | 36.96 | 1.00 | 1.06 | 463.48 |
| other: a line's first word, second text | 3716 | 2029.22 ± 1.5% | 541.74 ± 0.1% | 30.16 ± 0.7% | 1860.79 ± 2.7% | 56.91 ± 11.1% | refused | refused | 2012.23 ± 1.6% | 3.75 | 1.01 | 1.09 | 35.66 |
| other: fourteen octets before an x | 87 | 28374.66 ± 5.8% | 284.63 ± 0.3% | 5.85 ± 2.3% | 3585.10 ± 0.8% | 9.23 ± 3.1% | differs | 17.60 ± 6.4% | 28156.29 ± 0.8% | 99.69 | 1.01 | 7.91 | 3073.26 |
| other: a Greek word | 21815 | 425.77 ± 0.3% | 337.63 ± 0.8% | 29.46 ± 0.7% | 258.31 ± 1.0% | 41.31 ± 10.9% | differs | refused | 424.15 ± 13.4% | 1.26 | 1.00 | 1.65 | 10.31 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.72 ± 0.2% | 19.70 ± 0.7% | 0.86 ± 1.2% | 18.52 ± 0.2% | 2.43 ± 0.8% | differs | 4.13 ± 6.1% | 19.28 ± 0.4% | 1.00 | 1.02 | 1.06 | 8.12 |
| a UUID | 32895 | 20.39 ± 4.3% | 20.29 ± 1.6% | 0.59 ± 4.5% | 14.38 ± 0.2% | 2.48 ± 3.4% | 0.54 ± 0.2% | 3.28 ± 0.5% | 20.32 ± 7.3% | 1.00 | 1.00 | 1.42 | 8.21 |
| an IPv4 address | 33176 | 32.18 ± 1.3% | 32.19 ± 3.0% | 1.92 ± 0.4% | 26.45 ± 0.8% | 5.96 ± 0.7% | differs | 3.95 ± 9.5% | 32.22 ± 7.1% | 1.00 | 1.00 | 1.22 | 5.40 |
| a date and time | 32954 | 29.05 ± 9.5% | 28.39 ± 8.2% | 1.38 ± 2.0% | 20.20 ± 0.1% | 7.20 ± 0.8% | 0.95 ± 2.1% | 7.71 ± 5.1% | 29.27 ± 13.7% | 1.02 | 0.99 | 1.44 | 4.03 |
| a field path | 32606 | 22.60 ± 0.3% | 22.47 ± 0.6% | 0.95 ± 6.2% | 21.22 ± 0.3% | 2.84 ± 5.4% | differs | 2.62 ± 0.5% | 22.54 ± 8.9% | 1.01 | 1.00 | 1.07 | 7.95 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.56 ± 3.3% | 8.69 ± 0.4% | 8.66 ± 0.5% | 11.43 ± 0.5% | 4.66 ± 6.2% | 0.76 ± 0.5% | none | 8.66 ± 0.7% | 0.99 | 0.99 | 0.75 | 1.84 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 217.15 ± 0.4% | 216.99 ± 0.3% | 256.06 ± 7.8% | 85.29 ± 2.7% | 183.34 ± 2.3% | 541.69 ± 4.2% | 3543.55 ± 0.3% | 216.35 ± 6.5% | 1.00 | 1.00 | 2.55 | 1.18 |
| a UUID | 62 | 143.80 ± 0.6% | 143.74 ± 0.9% | 161.00 ± 0.4% | 46.79 ± 1.2% | 88.12 ± 11.1% | 192.77 ± 7.3% | 4389.49 ± 3.5% | 143.62 ± 0.7% | 1.00 | 1.00 | 3.07 | 1.63 |
| an IPv4 address | 29 | 418.91 ± 0.8% | 422.35 ± 7.9% | 593.40 ± 0.2% | 74.30 ± 21.6% | 113.90 ± 8.1% | 329.20 ± 1.0% | 7427.16 ± 0.8% | 418.84 ± 0.3% | 0.99 | 1.00 | 5.64 | 3.68 |
| a date and time | 56 | 317.52 ± 0.2% | 319.88 ± 1.2% | 407.93 ± 0.7% | 71.54 ± 0.8% | 118.67 ± 13.1% | 356.51 ± 0.8% | 4502.42 ± 2.9% | 317.84 ± 0.1% | 0.99 | 1.00 | 4.44 | 2.68 |
| a field path | 39 | 213.54 ± 3.3% | 215.50 ± 5.9% | 251.76 ± 0.6% | 77.53 ± 1.8% | 173.53 ± 15.2% | 546.10 ± 2.3% | 4455.86 ± 0.8% | 215.10 ± 1.1% | 0.99 | 0.99 | 2.75 | 1.23 |
| literal: a word | 7 | 647.79 ± 10.4% | 689.89 ± 2.0% | 1240.70 ± 0.5% | 498.73 ± 0.4% | 537.97 ± 2.1% | 1156.04 ± 0.7% | 28650.35 ± 0.7% | 648.62 ± 0.3% | 0.94 | 1.00 | 1.30 | 1.20 |
| literal: a word that is not there | 8 | 620.96 ± 3.3% | 667.49 ± 2.8% | 1168.63 ± 0.2% | 462.37 ± 0.5% | 512.38 ± 12.4% | 1063.70 ± 1.5% | 27751.50 ± 0.1% | 619.77 ± 3.2% | 0.93 | 1.00 | 1.34 | 1.21 |
| literal: one of four words | 26 | 238.69 ± 0.3% | 384.19 ± 0.8% | 516.67 ± 0.4% | 40.56 ± 0.5% | 210.75 ± 2.6% | 422.42 ± 1.3% | 16346.51 ± 1.4% | 238.68 ± 0.4% | 0.62 | 1.00 | 5.88 | 1.13 |
| literal: a word in any case | 11 | 455.64 ± 0.8% | 486.45 ± 0.3% | 712.18 ± 2.1% | 13.69 ± 0.8% | 556.26 ± 2.5% | refused | 22560.14 ± 0.7% | 455.71 ± 1.4% | 0.94 | 1.00 | 33.28 | 0.82 |
| literal: an href attribute | 12 | 328.38 ± 1.1% | 338.08 ± 1.0% | 441.11 ± 2.1% | 37.11 ± 7.4% | 380.44 ± 11.7% | 888.93 ± 0.7% | 20741.91 ± 1.9% | 327.78 ± 1.3% | 0.97 | 1.00 | 8.85 | 0.86 |
| literal: a word, second text | 10 | 567.89 ± 2.7% | 623.37 ± 0.9% | 1031.91 ± 1.3% | 423.42 ± 1.6% | 455.76 ± 2.6% | 890.16 ± 6.1% | 24960.14 ± 31.2% | 569.46 ± 1.0% | 0.91 | 1.00 | 1.34 | 1.25 |
| class: two capitalized words | 23 | 457.94 ± 0.5% | 492.14 ± 0.3% | 737.83 ± 0.3% | 101.96 ± 0.2% | 424.15 ± 2.8% | 872.90 ± 2.1% | 5691.42 ± 0.8% | 457.66 ± 0.7% | 0.93 | 1.00 | 4.49 | 1.08 |
| class: a word that ends in ing | 9 | 562.76 ± 0.5% | 642.74 ± 0.5% | 1143.29 ± 2.2% | 127.74 ± 1.0% | 620.80 ± 1.7% | 1339.47 ± 3.1% | 14627.71 ± 2.4% | 563.50 ± 2.7% | 0.88 | 1.00 | 4.41 | 0.91 |
| class: a word in capitals | 16 | 521.52 ± 0.2% | 567.27 ± 0.3% | 960.96 ± 0.9% | 135.03 ± 1.7% | 625.42 ± 12.9% | 1208.55 ± 2.6% | 7520.01 ± 0.4% | 522.51 ± 0.4% | 0.92 | 1.00 | 3.86 | 0.83 |
| class: a number | 6 | 638.17 ± 1.3% | 708.92 ± 0.3% | 1372.74 ± 0.2% | 35.83 ± 1.4% | 1117.26 ± 11.6% | 2349.62 ± 6.8% | 19977.27 ± 12.2% | 635.44 ± 1.1% | 0.90 | 1.00 | 17.81 | 0.57 |
| class: two capitalized words, second text | 23 | 457.82 ± 1.0% | 492.41 ± 1.0% | 738.19 ± 0.5% | 99.73 ± 11.6% | 432.49 ± 1.2% | 879.85 ± 7.9% | 5694.75 ± 0.6% | 458.02 ± 0.4% | 0.93 | 1.00 | 4.59 | 1.06 |
| other: a word between two words | 13 | 559.11 ± 2.8% | 577.84 ± 0.6% | 921.98 ± 0.5% | 133.53 ± 1.5% | 424.91 ± 3.8% | 891.70 ± 1.2% | 13680.74 ± 0.6% | 558.15 ± 1.9% | 0.97 | 1.00 | 4.19 | 1.32 |
| other: a number before a unit, second text | 15 | 404.12 ± 1.0% | 450.59 ± 1.3% | 639.06 ± 1.6% | 33.67 ± 0.6% | 525.35 ± 1.3% | 1052.94 ± 3.7% | 14523.95 ± 0.9% | 403.97 ± 1.3% | 0.90 | 1.00 | 12.00 | 0.77 |
| other: a heading's start tag | 13 | 343.05 ± 4.8% | 347.66 ± 7.6% | 455.01 ± 0.4% | 36.00 ± 6.3% | 518.64 ± 5.4% | 979.83 ± 4.6% | 16943.89 ± 11.9% | 342.42 ± 4.9% | 0.99 | 1.00 | 9.53 | 0.66 |
| other: a whole word | 11 | 573.12 ± 7.5% | 603.86 ± 2.4% | 999.95 ± 0.7% | 118.64 ± 0.6% | 477.74 ± 1.7% | 975.11 ± 1.0% | 25120.51 ± 1.4% | 570.29 ± 9.4% | 0.95 | 1.00 | 4.83 | 1.20 |
| other: a line's first word, second text | 17 | 539.22 ± 0.6% | 566.74 ± 0.5% | 930.63 ± 0.6% | 127.02 ± 6.7% | 587.27 ± 12.5% | refused | refused | 537.87 ± 0.8% | 0.95 | 1.00 | 4.25 | 0.92 |
| other: fourteen octets before an x | 16 | 90.66 ± 0.9% | 138.25 ± 3.5% | 162.20 ± 1.3% | 15.16 ± 0.4% | 382.55 ± 7.6% | 445.60 ± 1.2% | 11965.57 ± 2.4% | 90.60 ± 3.9% | 0.66 | 1.00 | 5.98 | 0.24 |
| other: a Greek word | 8 | 417.07 ± 1.0% | 578.70 ± 0.7% | 959.94 ± 0.5% | 45.45 ± 0.2% | 1133.98 ± 10.8% | 2137.24 ± 2.0% | refused | 416.92 ± 1.0% | 0.72 | 1.00 | 9.18 | 0.37 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20306.69 ± 1.5% | not timed | not timed | 21202.57 ± 0.7% | 1902.20 ± 25.2% | not timed | not timed | 20254.83 ± 0.9% | | 1.00 | 0.96 | 10.68 |
| 01-literal/sherlock-casei-en | 522 | 7863.86 ± 2.3% | not timed | not timed | 6726.15 ± 5.7% | 29.49 ± 1.9% | not timed | not timed | 7813.61 ± 3.0% | | 1.01 | 1.17 | 266.67 |
| 01-literal/sherlock-ru | 724 | 20305.55 ± 0.2% | not timed | not timed | 21244.18 ± 0.8% | 1164.64 ± 3.7% | not timed | not timed | 20267.54 ± 0.7% | | 1.00 | 0.96 | 17.44 |
| 01-literal/sherlock-casei-ru | 746 | 9483.87 ± 5.9% | not timed | not timed | 5547.92 ± 14.2% | 32.40 ± 3.8% | not timed | not timed | 9490.53 ± 0.8% | | 1.00 | 1.71 | 292.75 |
| 01-literal/sherlock-zh | 30 | 31908.48 ± 0.1% | not timed | not timed | 27337.83 ± 0.2% | 1102.03 ± 0.5% | not timed | not timed | 31876.13 ± 2.0% | | 1.00 | 1.17 | 28.95 |
| 02-literal-alternate/sherlock-en | 714 | 9715.01 ± 0.7% | not timed | not timed | 7692.47 ± 0.7% | 16.02 ± 1.2% | not timed | not timed | 9677.57 ± 0.7% | | 1.00 | 1.26 | 606.35 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1919.79 ± 1.1% | not timed | not timed | 2068.92 ± 4.4% | 9.74 ± 0.8% | not timed | not timed | 1905.53 ± 0.8% | | 1.01 | 0.93 | 197.20 |
| 02-literal-alternate/sherlock-ru | 899 | 8106.97 ± 0.4% | not timed | not timed | 4432.54 ± 2.5% | 21.14 ± 8.9% | not timed | not timed | 8083.19 ± 2.1% | | 1.00 | 1.83 | 383.49 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2068.39 ± 1.6% | not timed | not timed | 1087.79 ± 0.7% | 8.77 ± 1.5% | not timed | not timed | 2065.65 ± 0.6% | | 1.00 | 1.90 | 235.73 |
| 02-literal-alternate/sherlock-zh | 207 | 13328.62 ± 0.3% | not timed | not timed | 8849.34 ± 0.2% | 30.17 ± 9.2% | not timed | not timed | 13292.91 ± 0.3% | | 1.00 | 1.51 | 441.84 |
| 03-date/ascii | 111817 | 107.79 ± 0.3% | not timed | not timed | 91.83 ± 0.6% | 0.17 ± 3.8% | not timed | not timed | 105.34 ± 1.1% | | 1.02 | 1.17 | 639.36 |
| 04-ruff-noqa/real | 84 | 466.66 ± 1.1% | not timed | not timed | 456.85 ± 0.4% | 17.46 ± 1.0% | not timed | not timed | 466.08 ± 0.4% | | 1.00 | 1.02 | 26.73 |
| 04-ruff-noqa/tweaked | 44 | 480.00 ± 3.7% | not timed | not timed | 444.86 ± 0.3% | 302.20 ± 1.7% | not timed | not timed | 481.36 ± 1.8% | | 1.00 | 1.08 | 1.59 |
| 05-lexer-veryl/single | 124800 | 4.34 ± 0.8% | not timed | not timed | 4.47 ± 3.9% | 0.21 ± 3.0% | not timed | not timed | 4.29 ± 3.7% | | 1.01 | 0.97 | 21.04 |
| 06-cloud-flare-redos/original | 107 | 371.69 ± 0.3% | not timed | not timed | 196.31 ± 4.5% | 22.60 ± 8.5% | not timed | not timed | 373.90 ± 1.7% | | 0.99 | 1.89 | 16.45 |
| 06-cloud-flare-redos/simplified-short | 102 | 361.80 ± 2.1% | not timed | not timed | 208.59 ± 1.1% | 25.01 ± 16.3% | not timed | not timed | 362.17 ± 6.2% | | 1.00 | 1.73 | 14.46 |
| 06-cloud-flare-redos/simplified-long | 10000 | 484.69 ± 0.6% | not timed | not timed | 228.72 ± 1.9% | 27.73 ± 22.7% | not timed | not timed | 484.57 ± 0.3% | | 1.00 | 2.12 | 17.48 |
| 07-unicode-character-data/parse-line | 558784 | 203.48 ± 0.7% | not timed | not timed | 163.18 ± 0.3% | 38.71 ± 14.8% | not timed | not timed | 197.94 ± 6.9% | | 1.03 | 1.25 | 5.26 |
| 08-words/all-english | 56691 | 95.44 ± 1.1% | not timed | not timed | 77.48 ± 0.8% | 11.59 ± 3.7% | not timed | not timed | 96.15 ± 1.7% | | 0.99 | 1.23 | 8.24 |
| 08-words/long-english | 839 | 577.34 ± 0.4% | not timed | not timed | 552.22 ± 0.5% | 28.52 ± 2.1% | not timed | not timed | 577.37 ± 0.1% | | 1.00 | 1.05 | 20.24 |
| 09-aws-keys/full | 0 | 486.77 ± 0.4% | not timed | not timed | 457.97 ± 2.9% | 57.11 ± 5.1% | not timed | not timed | 483.35 ± 0.4% | | 1.01 | 1.06 | 8.52 |
| 09-aws-keys/quick | 0 | 802.17 ± 1.2% | not timed | not timed | 794.77 ± 1.7% | 341.65 ± 0.6% | not timed | not timed | 804.98 ± 1.1% | | 1.00 | 1.01 | 2.35 |
| 10-bounded-repeat/letters-en | 1833 | 574.25 ± 2.6% | not timed | not timed | 478.97 ± 1.9% | 18.57 ± 1.0% | not timed | not timed | 567.17 ± 1.5% | | 1.01 | 1.20 | 30.92 |
| 10-bounded-repeat/letters-ru | 3475 | 485.07 ± 1.4% | not timed | not timed | 434.78 ± 0.5% | 21.45 ± 6.7% | not timed | not timed | 483.05 ± 0.7% | | 1.00 | 1.12 | 22.62 |
| 10-bounded-repeat/context | 53 | 70.33 ± 0.7% | not timed | not timed | 59.98 ± 0.9% | 18.48 ± 0.5% | not timed | not timed | 70.75 ± 0.7% | | 0.99 | 1.17 | 3.80 |
| 10-bounded-repeat/capitals | 11 | 603.42 ± 7.4% | not timed | not timed | 576.83 ± 0.5% | 33.22 ± 0.3% | not timed | not timed | 601.97 ± 7.7% | | 1.00 | 1.05 | 18.16 |
| 11-unstructured-to-json/extract | 600 | 59.45 ± 0.3% | not timed | not timed | 69.28 ± 7.5% | 44.46 ± 6.7% | not timed | not timed | 61.66 ± 9.2% | | 0.96 | 0.86 | 1.34 |
| 12-dictionary/single | 1 | 522.97 ± 0.8% | not timed | not timed | 505.47 ± 0.5% | 0.27 ± 0.8% | not timed | not timed | 523.96 ± 1.6% | | 1.00 | 1.03 | 1954.68 |
| 14-quadratic/1x | 100 | 20.26 ± 10.5% | not timed | not timed | 9.60 ± 2.2% | 0.89 ± 2.5% | not timed | not timed | 20.37 ± 1.7% | | 1.00 | 2.11 | 22.71 |
| 14-quadratic/2x | 200 | 15.92 ± 4.3% | not timed | not timed | 5.90 ± 0.1% | 0.50 ± 0.9% | not timed | not timed | 15.81 ± 15.4% | | 1.01 | 2.70 | 32.02 |
| 14-quadratic/10x | 1000 | 5.77 ± 0.2% | not timed | not timed | 1.16 ± 0.6% | 0.11 ± 10.8% | not timed | not timed | 5.77 ± 0.7% | | 1.00 | 4.96 | 53.19 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.36 ± 1.9% | not timed | not timed | 0.35 ± 2.2% | 0.49 ± 3.1% | not timed | not timed | 1.35 ± 11.1% | | 1.00 | 3.91 | 2.76 |
| 04-ruff-noqa/compile-real | 1 | 100.88 ± 0.2% | not timed | not timed | 11.93 ± 1.9% | 125.05 ± 1.5% | not timed | not timed | 100.65 ± 0.4% | | 1.00 | 8.46 | 0.81 |
| 05-lexer-veryl/compile-single | 1 | 14.30 ± 4.8% | not timed | not timed | 2.40 ± 7.0% | 5.96 ± 2.3% | not timed | not timed | 14.32 ± 10.5% | | 1.00 | 5.96 | 2.40 |
| 07-unicode-character-data/compile | 1 | 56.14 ± 0.5% | not timed | not timed | 24.55 ± 0.7% | 32.76 ± 1.5% | not timed | not timed | 55.89 ± 0.3% | | 1.00 | 2.29 | 1.71 |
| 09-aws-keys/compile-full | 1 | 37.46 ± 0.4% | not timed | not timed | 7.13 ± 0.9% | 20.41 ± 6.8% | not timed | not timed | 37.53 ± 7.9% | | 1.00 | 5.25 | 1.84 |
| 09-aws-keys/compile-quick | 1 | 174.53 ± 4.7% | not timed | not timed | 46.04 ± 5.7% | 117.45 ± 6.1% | not timed | not timed | 174.82 ± 27.0% | | 1.00 | 3.79 | 1.49 |
| 10-bounded-repeat/compile-context | 1 | 11.84 ± 3.0% | not timed | not timed | 11.30 ± 0.8% | 14.82 ± 2.1% | not timed | not timed | 11.82 ± 7.6% | | 1.00 | 1.05 | 0.80 |
| 10-bounded-repeat/compile-capitals | 1 | 71.84 ± 0.9% | not timed | not timed | 8.49 ± 0.5% | 22.14 ± 1.7% | not timed | not timed | 72.01 ± 1.0% | | 1.00 | 8.46 | 3.25 |
| 11-unstructured-to-json/compile | 1 | 83.49 ± 2.0% | not timed | not timed | 36.54 ± 0.3% | 62.99 ± 2.5% | not timed | not timed | 83.43 ± 1.1% | | 1.00 | 2.28 | 1.33 |
| 12-dictionary/compile-single | 1 | 0.30 ± 0.9% | not timed | not timed | 0.07 ± 4.2% | 0.09 ± 13.4% | not timed | not timed | 0.29 ± 6.6% | | 1.01 | 4.32 | 3.27 |

