# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243520475 |
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
| literal: a word | 217 | 38128.01 ± 0.5% | 3140.41 ± 1.7% | 24.74 ± 2.6% | 29825.74 ± 0.3% | 9147.97 ± 5.9% | 9.90 ± 0.6% | 83.31 ± 0.7% | 38162.56 ± 0.4% | 12.14 | 1.00 | 1.28 | 4.17 |
| literal: a word that is not there | 0 | 49939.27 ± 3.5% | 3086.01 ± 1.6% | 25.37 ± 1.3% | 35435.19 ± 7.2% | 33782.79 ± 2.4% | 9.78 ± 0.5% | 78.39 ± 0.2% | 50089.94 ± 0.3% | 16.18 | 1.00 | 1.41 | 1.48 |
| literal: one of four words | 661 | 12172.09 ± 0.6% | 1288.89 ± 1.0% | 13.19 ± 0.6% | 8871.17 ± 0.2% | 19.21 ± 0.7% | 3.47 ± 0.1% | 5.91 ± 0.8% | 12142.80 ± 0.8% | 9.44 | 1.00 | 1.37 | 633.78 |
| literal: a word in any case | 217 | 34136.62 ± 1.2% | 1394.13 ± 0.8% | 18.74 ± 4.7% | 9005.72 ± 24.3% | 36.53 ± 1.8% | refused | differs | 33987.22 ± 0.2% | 24.49 | 1.00 | 3.79 | 934.57 |
| literal: an href attribute | 33 | 31693.13 ± 1.2% | 477.77 ± 0.2% | 23.91 ± 3.9% | 26914.54 ± 1.6% | 2288.71 ± 2.2% | 7.41 ± 0.2% | 72.48 ± 3.3% | 31638.84 ± 0.5% | 66.34 | 1.00 | 1.18 | 13.85 |
| literal: a word, second text | 123 | 39985.87 ± 0.5% | 2443.65 ± 2.2% | 25.01 ± 4.3% | 30680.35 ± 0.9% | 8646.72 ± 17.1% | 11.25 ± 1.6% | 70.46 ± 15.2% | 39905.37 ± 38.0% | 16.36 | 1.00 | 1.30 | 4.62 |
| class: two capitalized words | 1331 | 694.34 ± 0.5% | 469.61 ± 0.9% | 23.02 ± 1.4% | 446.25 ± 0.9% | 34.43 ± 2.3% | 8.51 ± 0.6% | 62.12 ± 0.4% | 692.30 ± 0.6% | 1.48 | 1.00 | 1.56 | 20.17 |
| class: a word that ends in ing | 3399 | 447.82 ± 0.2% | 447.46 ± 0.2% | 15.43 ± 0.7% | 419.60 ± 0.2% | 25.27 ± 5.2% | 4.76 ± 0.1% | 15.52 ± 1.6% | 446.97 ± 0.3% | 1.00 | 1.00 | 1.07 | 17.72 |
| class: a word in capitals | 2332 | 870.77 ± 0.2% | 472.62 ± 0.5% | 24.80 ± 0.2% | 439.30 ± 0.4% | 36.78 ± 2.7% | 9.65 ± 0.1% | 78.88 ± 1.6% | 868.87 ± 0.5% | 1.84 | 1.00 | 1.98 | 23.67 |
| class: a number | 8288 | 1419.72 ± 0.9% | 625.23 ± 0.8% | 23.18 ± 0.7% | 1395.39 ± 0.8% | 35.55 ± 12.2% | 0.30 ± 0.7% | 58.32 ± 1.3% | 1419.67 ± 5.0% | 2.27 | 1.00 | 1.02 | 39.93 |
| class: two capitalized words, second text | 5359 | 397.49 ± 0.5% | 402.52 ± 0.5% | 20.56 ± 9.9% | 370.55 ± 0.5% | 29.03 ± 8.7% | 9.89 ± 0.3% | 57.79 ± 12.3% | 386.84 ± 0.2% | 0.99 | 1.03 | 1.07 | 13.69 |
| other: a word between two words | 6104 | 659.98 ± 0.5% | 452.28 ± 0.5% | 20.50 ± 0.9% | 632.49 ± 0.5% | 96.59 ± 11.8% | 6.57 ± 0.5% | 64.60 ± 13.2% | 658.60 ± 0.7% | 1.46 | 1.00 | 1.04 | 6.83 |
| other: a number before a unit, second text | 1481 | 8155.51 ± 0.7% | 815.10 ± 4.7% | 23.44 ± 0.3% | 6399.36 ± 1.2% | 34.40 ± 9.2% | 10.32 ± 0.2% | 60.42 ± 0.5% | 8135.58 ± 0.3% | 10.01 | 1.00 | 1.27 | 237.07 |
| other: a heading's start tag | 110 | 19778.43 ± 0.4% | 579.68 ± 0.7% | 24.97 ± 0.6% | 1998.27 ± 2.0% | 1572.61 ± 2.3% | 9.05 ± 7.8% | 85.61 ± 0.2% | 19776.32 ± 0.6% | 34.12 | 1.00 | 9.90 | 12.58 |
| other: a whole word | 217 | 24709.12 ± 0.6% | 471.43 ± 0.5% | 25.19 ± 1.9% | 21556.42 ± 1.8% | 42.15 ± 8.4% | 8.60 ± 0.2% | 48.61 ± 0.3% | 24664.39 ± 3.7% | 52.41 | 1.00 | 1.15 | 586.23 |
| other: a line's first word, second text | 3716 | 2006.12 ± 6.3% | 457.27 ± 3.1% | 27.63 ± 1.1% | 1809.39 ± 1.0% | 55.34 ± 4.8% | refused | refused | 2022.81 ± 3.4% | 4.39 | 0.99 | 1.11 | 36.25 |
| other: fourteen octets before an x | 87 | 29594.23 ± 7.0% | 204.71 ± 0.3% | 5.78 ± 0.4% | 2718.93 ± 2.8% | 8.98 ± 1.7% | differs | 15.13 ± 2.0% | 27302.03 ± 0.7% | 144.57 | 1.08 | 10.88 | 3293.75 |
| other: a Greek word | 21815 | 358.48 ± 0.3% | 308.13 ± 0.4% | 27.02 ± 0.2% | 236.54 ± 0.8% | 38.49 ± 6.9% | differs | refused | 357.54 ± 0.4% | 1.16 | 1.00 | 1.52 | 9.31 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 15.90 ± 0.6% | 15.92 ± 0.3% | 0.79 ± 0.4% | 15.44 ± 0.4% | 2.20 ± 0.2% | differs | 3.17 ± 2.2% | 15.90 ± 0.3% | 1.00 | 1.00 | 1.03 | 7.22 |
| a UUID | 32895 | 17.74 ± 0.6% | 17.62 ± 1.3% | 0.56 ± 0.2% | 11.73 ± 0.1% | 2.34 ± 3.3% | 0.40 ± 0.8% | 2.75 ± 0.5% | 17.68 ± 0.2% | 1.01 | 1.00 | 1.51 | 7.58 |
| an IPv4 address | 33176 | 28.58 ± 1.2% | 28.54 ± 1.2% | 1.80 ± 1.2% | 22.13 ± 0.2% | 5.37 ± 2.3% | differs | 3.08 ± 3.0% | 28.65 ± 0.7% | 1.00 | 1.00 | 1.29 | 5.32 |
| a date and time | 32954 | 25.56 ± 2.4% | 25.23 ± 1.8% | 1.32 ± 1.1% | 16.73 ± 0.7% | 6.35 ± 12.9% | 0.70 ± 0.2% | 5.59 ± 2.4% | 25.65 ± 0.2% | 1.01 | 1.00 | 1.53 | 4.02 |
| a field path | 32606 | 18.43 ± 0.5% | 18.44 ± 0.8% | 0.87 ± 1.3% | 17.84 ± 0.6% | 2.72 ± 3.3% | differs | 2.34 ± 1.0% | 18.47 ± 0.6% | 1.00 | 1.00 | 1.03 | 6.78 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.45 ± 0.4% | 8.42 ± 0.4% | 8.39 ± 0.5% | 10.32 ± 1.6% | 4.48 ± 1.8% | 0.58 ± 0.3% | none | 8.25 ± 0.5% | 1.00 | 1.02 | 0.82 | 1.89 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 197.38 ± 0.4% | 198.70 ± 0.8% | 234.69 ± 13.4% | 78.57 ± 3.6% | 186.14 ± 13.5% | 520.10 ± 3.0% | 3768.56 ± 20.6% | 196.97 ± 1.7% | 0.99 | 1.00 | 2.51 | 1.06 |
| a UUID | 62 | 129.24 ± 0.5% | 129.93 ± 4.2% | 145.81 ± 0.4% | 45.11 ± 1.5% | 91.64 ± 1.7% | 195.01 ± 7.1% | 4053.05 ± 0.5% | 129.16 ± 0.2% | 0.99 | 1.00 | 2.86 | 1.41 |
| an IPv4 address | 29 | 381.68 ± 18.6% | 385.80 ± 0.7% | 543.05 ± 0.8% | 67.53 ± 0.7% | 115.04 ± 1.3% | 316.58 ± 12.6% | 6938.50 ± 0.8% | 381.60 ± 0.8% | 0.99 | 1.00 | 5.65 | 3.32 |
| a date and time | 56 | 274.80 ± 0.8% | 276.58 ± 0.5% | 344.71 ± 0.8% | 66.34 ± 1.6% | 124.02 ± 2.6% | 371.40 ± 3.3% | 4095.82 ± 0.5% | 274.59 ± 0.3% | 0.99 | 1.00 | 4.14 | 2.22 |
| a field path | 39 | 196.94 ± 1.1% | 198.55 ± 0.2% | 232.51 ± 0.6% | 72.43 ± 3.9% | 176.35 ± 1.4% | 592.89 ± 5.2% | 4526.93 ± 1.0% | 196.38 ± 6.5% | 0.99 | 1.00 | 2.72 | 1.12 |
| literal: a word | 7 | 579.31 ± 12.2% | 616.23 ± 0.4% | 1098.72 ± 0.2% | 505.13 ± 0.2% | 598.72 ± 2.4% | 1253.32 ± 16.6% | 26913.37 ± 0.9% | 579.73 ± 0.3% | 0.94 | 1.00 | 1.15 | 0.97 |
| literal: a word that is not there | 8 | 557.39 ± 0.3% | 597.87 ± 0.4% | 1031.35 ± 0.3% | 460.32 ± 1.4% | 575.95 ± 6.1% | 1187.63 ± 0.8% | 25576.99 ± 28.0% | 555.25 ± 1.2% | 0.93 | 1.00 | 1.21 | 0.97 |
| literal: one of four words | 26 | 204.79 ± 0.1% | 345.90 ± 8.1% | 460.63 ± 0.4% | 41.67 ± 0.4% | 221.96 ± 3.1% | 448.89 ± 10.8% | 12383.72 ± 1.9% | 204.78 ± 0.2% | 0.59 | 1.00 | 4.91 | 0.92 |
| literal: a word in any case | 11 | 394.48 ± 0.8% | 418.15 ± 0.2% | 599.07 ± 6.2% | 14.74 ± 12.4% | 623.84 ± 18.8% | refused | 16856.02 ± 3.2% | 392.59 ± 0.6% | 0.94 | 1.00 | 26.76 | 0.63 |
| literal: an href attribute | 12 | 313.06 ± 0.2% | 327.33 ± 0.2% | 430.32 ± 1.0% | 38.38 ± 0.8% | 440.88 ± 2.4% | 964.87 ± 1.6% | 18721.74 ± 1.3% | 313.32 ± 0.3% | 0.96 | 1.00 | 8.16 | 0.71 |
| literal: a word, second text | 10 | 513.51 ± 0.4% | 557.37 ± 0.3% | 920.92 ± 0.3% | 419.39 ± 11.6% | 508.66 ± 2.6% | 1006.91 ± 1.3% | 23188.87 ± 0.6% | 514.38 ± 2.9% | 0.92 | 1.00 | 1.22 | 1.01 |
| class: two capitalized words | 23 | 401.13 ± 5.3% | 433.35 ± 9.8% | 624.28 ± 5.5% | 94.36 ± 1.9% | 455.91 ± 2.2% | 969.15 ± 0.7% | 6104.11 ± 0.4% | 400.79 ± 0.3% | 0.93 | 1.00 | 4.25 | 0.88 |
| class: a word that ends in ing | 9 | 499.40 ± 0.3% | 572.59 ± 0.2% | 999.43 ± 0.6% | 115.75 ± 0.8% | 651.28 ± 1.0% | 1431.11 ± 1.1% | 14880.64 ± 0.7% | 499.49 ± 0.2% | 0.87 | 1.00 | 4.31 | 0.77 |
| class: a word in capitals | 16 | 436.33 ± 2.7% | 477.65 ± 6.8% | 772.18 ± 0.6% | 119.77 ± 10.7% | 681.07 ± 3.0% | 1325.30 ± 1.6% | 8163.44 ± 0.5% | 435.92 ± 1.2% | 0.91 | 1.00 | 3.64 | 0.64 |
| class: a number | 6 | 548.15 ± 12.1% | 617.17 ± 0.4% | 1154.79 ± 1.0% | 36.67 ± 0.5% | 1241.13 ± 3.0% | 2376.95 ± 5.5% | 20195.67 ± 1.2% | 548.23 ± 0.2% | 0.89 | 1.00 | 14.95 | 0.44 |
| class: two capitalized words, second text | 23 | 399.67 ± 8.7% | 434.51 ± 0.4% | 625.86 ± 0.8% | 94.68 ± 1.2% | 453.21 ± 15.1% | 951.57 ± 11.8% | 6069.61 ± 2.5% | 400.66 ± 0.3% | 0.92 | 1.00 | 4.22 | 0.88 |
| other: a word between two words | 13 | 492.45 ± 0.4% | 512.02 ± 0.4% | 798.35 ± 0.6% | 123.69 ± 2.7% | 442.09 ± 55.5% | 1041.21 ± 0.8% | 13360.32 ± 0.3% | 492.94 ± 0.9% | 0.96 | 1.00 | 3.98 | 1.11 |
| other: a number before a unit, second text | 15 | 356.10 ± 5.9% | 401.93 ± 2.4% | 562.15 ± 0.6% | 34.33 ± 1.6% | 550.88 ± 1.0% | 1154.56 ± 2.4% | 13114.18 ± 29.0% | 356.39 ± 15.4% | 0.89 | 1.00 | 10.37 | 0.65 |
| other: a heading's start tag | 13 | 319.32 ± 21.2% | 327.96 ± 0.9% | 438.00 ± 0.7% | 37.74 ± 1.3% | 537.26 ± 16.1% | 1097.17 ± 3.5% | 16052.99 ± 0.6% | 319.85 ± 0.9% | 0.97 | 1.00 | 8.46 | 0.59 |
| other: a whole word | 11 | 502.97 ± 1.5% | 527.72 ± 1.6% | 866.68 ± 13.0% | 110.15 ± 12.2% | 512.11 ± 2.6% | 1073.69 ± 2.6% | 22573.23 ± 2.2% | 500.24 ± 1.3% | 0.95 | 1.01 | 4.57 | 0.98 |
| other: a line's first word, second text | 17 | 468.41 ± 10.9% | 494.09 ± 0.4% | 794.11 ± 1.2% | 115.34 ± 1.0% | 614.19 ± 1.4% | refused | refused | 464.24 ± 1.9% | 0.95 | 1.01 | 4.06 | 0.76 |
| other: fourteen octets before an x | 16 | 90.65 ± 15.0% | 134.37 ± 1.1% | 158.37 ± 0.8% | 14.12 ± 0.8% | 402.82 ± 0.7% | 444.90 ± 0.5% | 12176.38 ± 1.7% | 90.69 ± 0.6% | 0.67 | 1.00 | 6.42 | 0.23 |
| other: a Greek word | 8 | 357.52 ± 0.9% | 528.50 ± 0.4% | 872.91 ± 0.3% | 48.99 ± 0.2% | 1233.01 ± 3.2% | 2171.48 ± 2.2% | refused | 358.43 ± 0.2% | 0.68 | 1.00 | 7.30 | 0.29 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 28662.82 ± 0.5% | not timed | not timed | 25930.02 ± 1.1% | 1976.10 ± 18.1% | not timed | not timed | 28592.83 ± 1.4% | | 1.00 | 1.11 | 14.50 |
| 01-literal/sherlock-casei-en | 522 | 8913.97 ± 0.3% | not timed | not timed | 7083.96 ± 1.4% | 26.22 ± 3.1% | not timed | not timed | 8879.22 ± 0.8% | | 1.00 | 1.26 | 339.97 |
| 01-literal/sherlock-ru | 724 | 29658.63 ± 1.5% | not timed | not timed | 26457.66 ± 1.2% | 1012.28 ± 6.2% | not timed | not timed | 29629.43 ± 0.4% | | 1.00 | 1.12 | 29.30 |
| 01-literal/sherlock-casei-ru | 746 | 9814.73 ± 0.6% | not timed | not timed | 6103.60 ± 0.4% | 28.87 ± 1.5% | not timed | not timed | 9822.68 ± 0.3% | | 1.00 | 1.61 | 339.97 |
| 01-literal/sherlock-zh | 30 | 46831.99 ± 7.8% | not timed | not timed | 33127.44 ± 3.7% | 1267.66 ± 0.5% | not timed | not timed | 46789.35 ± 1.0% | | 1.00 | 1.41 | 36.94 |
| 02-literal-alternate/sherlock-en | 714 | 10845.11 ± 0.5% | not timed | not timed | 8607.44 ± 0.9% | 14.73 ± 0.7% | not timed | not timed | 10830.37 ± 1.1% | | 1.00 | 1.26 | 736.12 |
| 02-literal-alternate/sherlock-casei-en | 725 | 4049.90 ± 9.1% | not timed | not timed | 1781.30 ± 0.6% | 9.50 ± 8.1% | not timed | not timed | 3776.51 ± 6.3% | | 1.07 | 2.27 | 426.23 |
| 02-literal-alternate/sherlock-ru | 899 | 8611.04 ± 0.4% | not timed | not timed | 7704.24 ± 1.5% | 19.73 ± 0.2% | not timed | not timed | 8587.54 ± 0.4% | | 1.00 | 1.12 | 436.43 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1988.75 ± 3.8% | not timed | not timed | 918.94 ± 2.0% | 8.18 ± 0.6% | not timed | not timed | 1919.24 ± 8.0% | | 1.04 | 2.16 | 243.03 |
| 02-literal-alternate/sherlock-zh | 207 | 15825.16 ± 0.5% | not timed | not timed | 10033.41 ± 0.3% | 26.64 ± 12.5% | not timed | not timed | 15768.52 ± 1.4% | | 1.00 | 1.58 | 594.06 |
| 03-date/ascii | 111817 | 98.06 ± 4.1% | not timed | not timed | 77.35 ± 1.8% | 0.18 ± 0.8% | not timed | not timed | 97.62 ± 5.3% | | 1.00 | 1.27 | 553.92 |
| 04-ruff-noqa/real | 84 | 378.74 ± 0.3% | not timed | not timed | 390.85 ± 1.1% | 15.35 ± 2.1% | not timed | not timed | 378.28 ± 0.2% | | 1.00 | 0.97 | 24.68 |
| 04-ruff-noqa/tweaked | 44 | 481.62 ± 1.5% | not timed | not timed | 399.32 ± 2.4% | 290.33 ± 1.3% | not timed | not timed | 473.90 ± 0.8% | | 1.02 | 1.21 | 1.66 |
| 05-lexer-veryl/single | 124800 | 3.91 ± 1.7% | not timed | not timed | 4.19 ± 0.9% | 0.20 ± 2.6% | not timed | not timed | 3.83 ± 2.9% | | 1.02 | 0.93 | 19.10 |
| 06-cloud-flare-redos/original | 107 | 316.85 ± 7.6% | not timed | not timed | 176.85 ± 0.6% | 20.00 ± 6.1% | not timed | not timed | 318.03 ± 15.0% | | 1.00 | 1.79 | 15.84 |
| 06-cloud-flare-redos/simplified-short | 102 | 311.13 ± 0.4% | not timed | not timed | 180.68 ± 0.6% | 21.50 ± 1.0% | not timed | not timed | 311.73 ± 0.2% | | 1.00 | 1.72 | 14.47 |
| 06-cloud-flare-redos/simplified-long | 10000 | 413.58 ± 3.6% | not timed | not timed | 201.21 ± 0.4% | 22.99 ± 0.6% | not timed | not timed | 413.46 ± 0.7% | | 1.00 | 2.06 | 17.99 |
| 07-unicode-character-data/parse-line | 558784 | 188.79 ± 16.1% | not timed | not timed | 155.58 ± 1.4% | 36.23 ± 2.6% | not timed | not timed | 187.84 ± 1.7% | | 1.01 | 1.21 | 5.21 |
| 08-words/all-english | 56691 | 86.78 ± 0.7% | not timed | not timed | 65.07 ± 0.3% | 10.38 ± 4.4% | not timed | not timed | 86.00 ± 0.5% | | 1.01 | 1.33 | 8.36 |
| 08-words/long-english | 839 | 477.93 ± 0.2% | not timed | not timed | 453.80 ± 0.5% | 24.40 ± 21.1% | not timed | not timed | 477.44 ± 0.3% | | 1.00 | 1.05 | 19.59 |
| 09-aws-keys/full | 0 | 383.77 ± 5.2% | not timed | not timed | 407.70 ± 7.0% | 52.50 ± 6.0% | not timed | not timed | 383.04 ± 3.6% | | 1.00 | 0.94 | 7.31 |
| 09-aws-keys/quick | 0 | 918.54 ± 0.1% | not timed | not timed | 746.95 ± 0.5% | 327.50 ± 0.4% | not timed | not timed | 917.61 ± 0.5% | | 1.00 | 1.23 | 2.80 |
| 10-bounded-repeat/letters-en | 1833 | 528.58 ± 0.5% | not timed | not timed | 431.02 ± 4.1% | 17.61 ± 1.1% | not timed | not timed | 527.94 ± 0.3% | | 1.00 | 1.23 | 30.01 |
| 10-bounded-repeat/letters-ru | 3475 | 406.31 ± 2.5% | not timed | not timed | 374.14 ± 11.9% | 20.52 ± 34.4% | not timed | not timed | 407.35 ± 0.3% | | 1.00 | 1.09 | 19.80 |
| 10-bounded-repeat/context | 53 | 63.23 ± 3.0% | not timed | not timed | 54.05 ± 1.3% | 16.87 ± 1.4% | not timed | not timed | 64.31 ± 0.7% | | 0.98 | 1.17 | 3.75 |
| 10-bounded-repeat/capitals | 11 | 494.33 ± 7.9% | not timed | not timed | 468.78 ± 0.3% | 30.95 ± 3.4% | not timed | not timed | 494.01 ± 8.6% | | 1.00 | 1.05 | 15.97 |
| 11-unstructured-to-json/extract | 600 | 54.39 ± 5.8% | not timed | not timed | 62.93 ± 0.9% | 40.96 ± 3.8% | not timed | not timed | 54.21 ± 4.6% | | 1.00 | 0.86 | 1.33 |
| 12-dictionary/single | 1 | 396.54 ± 0.4% | not timed | not timed | 373.92 ± 2.0% | 0.30 ± 5.1% | not timed | not timed | 397.32 ± 0.4% | | 1.00 | 1.06 | 1342.99 |
| 14-quadratic/1x | 100 | 20.57 ± 0.6% | not timed | not timed | 9.45 ± 0.6% | 0.80 ± 1.4% | not timed | not timed | 20.55 ± 0.2% | | 1.00 | 2.18 | 25.80 |
| 14-quadratic/2x | 200 | 15.71 ± 26.8% | not timed | not timed | 4.75 ± 0.2% | 0.43 ± 0.5% | not timed | not timed | 15.71 ± 0.4% | | 1.00 | 3.31 | 36.44 |
| 14-quadratic/10x | 1000 | 5.42 ± 1.3% | not timed | not timed | 0.94 ± 0.1% | 0.09 ± 0.7% | not timed | not timed | 5.44 ± 2.6% | | 1.00 | 5.74 | 57.96 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.13 ± 0.5% | not timed | not timed | 0.37 ± 2.0% | 0.48 ± 3.3% | not timed | not timed | 1.11 ± 2.5% | | 1.02 | 3.07 | 2.35 |
| 04-ruff-noqa/compile-real | 1 | 82.91 ± 2.4% | not timed | not timed | 13.35 ± 7.7% | 126.49 ± 7.7% | not timed | not timed | 82.99 ± 0.6% | | 1.00 | 6.21 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 12.59 ± 0.4% | not timed | not timed | 2.31 ± 0.5% | 5.98 ± 2.0% | not timed | not timed | 12.43 ± 1.7% | | 1.01 | 5.45 | 2.10 |
| 07-unicode-character-data/compile | 1 | 49.71 ± 1.1% | not timed | not timed | 23.60 ± 0.6% | 33.52 ± 2.0% | not timed | not timed | 49.49 ± 0.1% | | 1.00 | 2.11 | 1.48 |
| 09-aws-keys/compile-full | 1 | 34.55 ± 2.0% | not timed | not timed | 7.69 ± 0.4% | 21.04 ± 4.7% | not timed | not timed | 34.09 ± 2.4% | | 1.01 | 4.49 | 1.64 |
| 09-aws-keys/compile-quick | 1 | 149.79 ± 0.4% | not timed | not timed | 44.82 ± 1.0% | 118.09 ± 3.9% | not timed | not timed | 149.28 ± 1.5% | | 1.00 | 3.34 | 1.27 |
| 10-bounded-repeat/compile-context | 1 | 11.49 ± 23.8% | not timed | not timed | 11.07 ± 11.8% | 15.39 ± 6.7% | not timed | not timed | 11.38 ± 1.4% | | 1.01 | 1.04 | 0.75 |
| 10-bounded-repeat/compile-capitals | 1 | 69.84 ± 0.5% | not timed | not timed | 8.09 ± 9.4% | 22.09 ± 13.5% | not timed | not timed | 70.51 ± 0.9% | | 0.99 | 8.63 | 3.16 |
| 11-unstructured-to-json/compile | 1 | 74.80 ± 2.3% | not timed | not timed | 37.21 ± 0.3% | 61.77 ± 4.4% | not timed | not timed | 74.96 ± 16.1% | | 1.00 | 2.01 | 1.21 |
| 12-dictionary/compile-single | 1 | 0.27 ± 1.3% | not timed | not timed | 0.06 ± 44.1% | 0.08 ± 26.0% | not timed | not timed | 0.26 ± 0.6% | | 1.01 | 4.15 | 3.13 |

