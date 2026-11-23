# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215450814 |
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
| literal: a word | 217 | 16219.47 ± 2.0% | 4995.10 ± 0.2% | 27.52 ± 0.2% | 18345.69 ± 2.6% | 9170.42 ± 9.3% | 17.45 ± 0.1% | 84.42 ± 0.8% | 16203.04 ± 1.7% | 3.25 | 1.00 | 0.88 | 1.77 |
| literal: a word that is not there | 0 | 18849.11 ± 2.6% | 4882.88 ± 0.3% | 27.55 ± 0.3% | 20112.56 ± 1.1% | 29535.69 ± 1.2% | 17.25 ± 0.3% | 79.77 ± 1.0% | 18814.66 ± 2.5% | 3.86 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6091.56 ± 0.6% | 1932.08 ± 0.4% | 14.12 ± 0.3% | 3942.91 ± 0.4% | 21.92 ± 0.1% | 5.25 ± 0.7% | 6.88 ± 0.8% | 6075.16 ± 0.4% | 3.15 | 1.00 | 1.54 | 277.86 |
| literal: a word in any case | 217 | 12609.45 ± 0.7% | 2071.23 ± 0.3% | 20.67 ± 0.4% | 3962.62 ± 0.8% | 36.80 ± 0.3% | refused | differs | 12582.46 ± 1.2% | 6.09 | 1.00 | 3.18 | 342.61 |
| literal: an href attribute | 33 | 13933.42 ± 1.2% | 616.25 ± 0.1% | 26.43 ± 0.1% | 17289.24 ± 1.7% | 2260.24 ± 0.7% | 13.32 ± 0.2% | 73.81 ± 0.4% | 13913.91 ± 0.4% | 22.61 | 1.00 | 0.81 | 6.16 |
| literal: a word, second text | 123 | 16460.88 ± 1.4% | 3357.28 ± 0.3% | 27.19 ± 0.0% | 18142.17 ± 0.8% | 7506.41 ± 6.6% | 19.55 ± 0.2% | 70.13 ± 1.0% | 16453.25 ± 1.7% | 4.90 | 1.00 | 0.91 | 2.19 |
| class: two capitalized words | 1331 | 1063.10 ± 0.3% | 603.63 ± 0.1% | 25.23 ± 0.4% | 585.44 ± 0.0% | 40.48 ± 12.9% | 14.80 ± 0.4% | 67.30 ± 1.1% | 1061.01 ± 0.5% | 1.76 | 1.00 | 1.82 | 26.26 |
| class: a word that ends in ing | 3399 | 579.95 ± 0.1% | 578.59 ± 0.2% | 17.67 ± 0.2% | 547.93 ± 0.2% | 29.61 ± 2.2% | 8.16 ± 0.1% | 18.38 ± 0.5% | 579.33 ± 0.1% | 1.00 | 1.00 | 1.06 | 19.59 |
| class: a word in capitals | 2332 | 1372.50 ± 0.3% | 614.62 ± 0.1% | 26.81 ± 0.6% | 572.36 ± 0.3% | 43.20 ± 14.8% | 17.16 ± 0.3% | 82.34 ± 0.9% | 1370.28 ± 0.3% | 2.23 | 1.00 | 2.40 | 31.77 |
| class: a number | 8288 | 2004.53 ± 0.4% | 834.39 ± 0.1% | 27.09 ± 0.2% | 1729.38 ± 0.3% | 38.65 ± 13.7% | 0.56 ± 0.2% | 57.24 ± 0.7% | 2004.40 ± 0.2% | 2.40 | 1.00 | 1.16 | 51.86 |
| class: two capitalized words, second text | 5359 | 521.05 ± 0.1% | 527.86 ± 0.2% | 22.60 ± 0.1% | 485.54 ± 0.0% | 35.27 ± 15.1% | 16.62 ± 0.6% | 62.51 ± 0.9% | 520.04 ± 0.1% | 0.99 | 1.00 | 1.07 | 14.77 |
| other: a word between two words | 6104 | 742.55 ± 0.1% | 598.01 ± 0.3% | 22.94 ± 0.2% | 734.76 ± 0.1% | 107.90 ± 15.5% | 11.28 ± 0.2% | 68.23 ± 0.5% | 742.32 ± 0.3% | 1.24 | 1.00 | 1.01 | 6.88 |
| other: a number before a unit, second text | 1481 | 5342.62 ± 0.5% | 1108.47 ± 0.3% | 25.34 ± 0.1% | 5658.55 ± 0.9% | 40.38 ± 0.1% | 17.80 ± 0.2% | 65.90 ± 0.3% | 5314.11 ± 0.3% | 4.82 | 1.01 | 0.94 | 132.32 |
| other: a heading's start tag | 110 | 12650.42 ± 0.5% | 751.22 ± 0.1% | 26.62 ± 0.3% | 1709.14 ± 0.3% | 1570.91 ± 3.1% | 16.12 ± 0.4% | 85.89 ± 0.5% | 12650.22 ± 0.6% | 16.84 | 1.00 | 7.40 | 8.05 |
| other: a whole word | 217 | 13987.10 ± 0.7% | 607.90 ± 0.2% | 28.61 ± 0.3% | 14621.75 ± 0.8% | 47.65 ± 0.2% | 13.61 ± 0.3% | 54.95 ± 0.5% | 13977.87 ± 1.0% | 23.01 | 1.00 | 0.96 | 293.54 |
| other: a line's first word, second text | 3716 | 1955.67 ± 0.7% | 593.21 ± 0.1% | 29.98 ± 0.2% | 1721.85 ± 0.3% | 62.27 ± 9.0% | refused | refused | 1945.03 ± 0.5% | 3.30 | 1.01 | 1.14 | 31.40 |
| other: fourteen octets before an x | 87 | 19682.12 ± 1.5% | 244.87 ± 0.3% | 6.27 ± 0.0% | 4018.88 ± 0.5% | 10.60 ± 0.2% | differs | 17.72 ± 0.2% | 19742.24 ± 0.9% | 80.38 | 1.00 | 4.90 | 1857.48 |
| other: a Greek word | 21815 | 503.00 ± 0.5% | 413.07 ± 0.2% | 30.39 ± 0.1% | 289.89 ± 0.1% | 46.69 ± 6.6% | differs | refused | 498.67 ± 0.6% | 1.22 | 1.01 | 1.74 | 10.77 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.80 ± 0.3% | 19.86 ± 0.3% | 0.84 ± 0.2% | 19.80 ± 0.9% | 2.77 ± 0.4% | differs | 4.05 ± 0.3% | 19.86 ± 0.2% | 1.00 | 1.00 | 1.00 | 7.15 |
| a UUID | 32895 | 21.31 ± 0.1% | 21.33 ± 0.3% | 0.64 ± 0.2% | 15.09 ± 0.4% | 3.08 ± 0.4% | 0.72 ± 0.2% | 3.63 ± 0.8% | 21.34 ± 0.2% | 1.00 | 1.00 | 1.41 | 6.91 |
| an IPv4 address | 33176 | 36.80 ± 0.4% | 36.77 ± 0.3% | 2.06 ± 0.2% | 29.24 ± 0.2% | 6.65 ± 0.2% | differs | 4.13 ± 0.1% | 36.80 ± 0.2% | 1.00 | 1.00 | 1.26 | 5.53 |
| a date and time | 32954 | 31.33 ± 0.6% | 31.30 ± 0.6% | 1.42 ± 0.1% | 21.49 ± 0.4% | 7.03 ± 0.1% | 1.19 ± 0.2% | 7.15 ± 0.4% | 31.36 ± 0.3% | 1.00 | 1.00 | 1.46 | 4.46 |
| a field path | 32606 | 23.49 ± 0.1% | 23.54 ± 0.3% | 1.01 ± 0.1% | 23.22 ± 0.3% | 3.49 ± 0.8% | differs | 2.96 ± 0.3% | 23.52 ± 0.3% | 1.00 | 1.00 | 1.01 | 6.74 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.12 ± 0.4% | 11.10 ± 0.2% | 11.12 ± 0.2% | 11.37 ± 0.1% | 4.90 ± 1.8% | 0.91 ± 0.7% | none | 11.10 ± 0.2% | 1.00 | 1.00 | 0.98 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.93 ± 0.4% | 235.61 ± 0.3% | 276.77 ± 0.5% | 86.60 ± 0.6% | 219.31 ± 0.9% | 484.25 ± 0.3% | 3786.25 ± 4.4% | 234.68 ± 0.7% | 1.00 | 1.00 | 2.71 | 1.07 |
| a UUID | 62 | 151.63 ± 0.5% | 151.64 ± 0.5% | 169.04 ± 0.7% | 45.68 ± 1.0% | 98.55 ± 1.7% | 183.42 ± 2.1% | 4217.78 ± 0.4% | 151.84 ± 0.9% | 1.00 | 1.00 | 3.32 | 1.54 |
| an IPv4 address | 29 | 430.82 ± 0.5% | 433.31 ± 0.4% | 598.58 ± 0.3% | 77.84 ± 0.1% | 130.41 ± 6.8% | 288.85 ± 0.4% | 7542.65 ± 0.3% | 430.29 ± 0.6% | 0.99 | 1.00 | 5.53 | 3.30 |
| a date and time | 56 | 301.32 ± 0.4% | 302.97 ± 0.3% | 374.28 ± 0.2% | 72.93 ± 1.3% | 135.67 ± 4.5% | 326.81 ± 2.1% | 4892.84 ± 0.5% | 301.06 ± 0.4% | 0.99 | 1.00 | 4.13 | 2.22 |
| a field path | 39 | 227.84 ± 0.2% | 228.71 ± 0.2% | 267.64 ± 0.3% | 80.25 ± 0.8% | 204.31 ± 2.2% | 530.81 ± 6.0% | 4851.36 ± 0.9% | 227.84 ± 0.4% | 1.00 | 1.00 | 2.84 | 1.12 |
| literal: a word | 7 | 650.85 ± 0.3% | 696.77 ± 0.7% | 1221.00 ± 0.5% | 496.79 ± 0.1% | 630.72 ± 2.5% | 967.15 ± 0.4% | 30330.53 ± 0.3% | 648.91 ± 0.6% | 0.93 | 1.00 | 1.31 | 1.03 |
| literal: a word that is not there | 8 | 623.90 ± 0.7% | 673.37 ± 0.9% | 1155.10 ± 1.7% | 448.44 ± 0.3% | 606.80 ± 4.4% | 913.62 ± 0.5% | 29100.82 ± 0.2% | 622.10 ± 0.4% | 0.93 | 1.00 | 1.39 | 1.03 |
| literal: one of four words | 26 | 249.45 ± 0.3% | 406.05 ± 0.6% | 543.81 ± 0.3% | 50.35 ± 1.2% | 242.70 ± 1.3% | 368.74 ± 0.6% | 15915.30 ± 0.2% | 249.47 ± 0.4% | 0.61 | 1.00 | 4.95 | 1.03 |
| literal: a word in any case | 11 | 456.10 ± 0.2% | 485.35 ± 0.5% | 701.86 ± 0.2% | 15.46 ± 0.2% | 649.53 ± 1.6% | refused | 23751.48 ± 0.4% | 456.46 ± 0.3% | 0.94 | 1.00 | 29.50 | 0.70 |
| literal: an href attribute | 12 | 349.15 ± 0.3% | 360.08 ± 0.3% | 465.77 ± 0.3% | 45.63 ± 0.5% | 500.29 ± 1.2% | 777.18 ± 0.3% | 21441.98 ± 0.3% | 348.67 ± 0.4% | 0.97 | 1.00 | 7.65 | 0.70 |
| literal: a word, second text | 10 | 577.11 ± 0.4% | 632.48 ± 0.8% | 1040.36 ± 0.7% | 397.84 ± 0.1% | 535.46 ± 1.8% | 808.93 ± 0.5% | 26937.02 ± 0.2% | 576.70 ± 0.2% | 0.91 | 1.00 | 1.45 | 1.08 |
| class: two capitalized words | 23 | 445.61 ± 0.4% | 475.22 ± 0.7% | 677.03 ± 0.6% | 98.93 ± 0.2% | 503.71 ± 1.1% | 745.20 ± 0.7% | 6459.42 ± 0.6% | 445.64 ± 0.5% | 0.94 | 1.00 | 4.50 | 0.88 |
| class: a word that ends in ing | 9 | 579.04 ± 0.4% | 643.39 ± 0.6% | 1104.23 ± 0.3% | 131.38 ± 1.4% | 765.72 ± 1.0% | 1105.58 ± 0.8% | 15856.46 ± 0.2% | 578.95 ± 0.2% | 0.90 | 1.00 | 4.41 | 0.76 |
| class: a word in capitals | 16 | 507.28 ± 0.5% | 545.11 ± 0.3% | 863.19 ± 0.3% | 135.23 ± 1.1% | 758.96 ± 1.4% | 1024.83 ± 0.7% | 8521.60 ± 0.2% | 506.61 ± 0.4% | 0.93 | 1.00 | 3.75 | 0.67 |
| class: a number | 6 | 647.61 ± 0.6% | 710.32 ± 0.3% | 1319.74 ± 0.1% | 41.76 ± 0.9% | 1420.36 ± 0.6% | 1865.09 ± 0.9% | 22680.15 ± 0.0% | 646.51 ± 0.3% | 0.91 | 1.00 | 15.51 | 0.46 |
| class: two capitalized words, second text | 23 | 445.55 ± 0.5% | 474.89 ± 0.5% | 675.97 ± 0.3% | 100.23 ± 0.3% | 504.74 ± 1.2% | 739.00 ± 3.7% | 6456.32 ± 0.5% | 445.28 ± 0.2% | 0.94 | 1.00 | 4.45 | 0.88 |
| other: a word between two words | 13 | 558.39 ± 0.4% | 577.23 ± 0.4% | 902.29 ± 0.2% | 132.96 ± 0.4% | 507.24 ± 1.5% | 813.78 ± 0.8% | 14753.31 ± 0.2% | 558.95 ± 0.3% | 0.97 | 1.00 | 4.20 | 1.10 |
| other: a number before a unit, second text | 15 | 406.90 ± 0.9% | 443.99 ± 0.5% | 618.13 ± 0.2% | 39.41 ± 0.4% | 640.16 ± 1.7% | 892.74 ± 0.3% | 15064.07 ± 0.3% | 407.31 ± 0.2% | 0.92 | 1.00 | 10.33 | 0.64 |
| other: a heading's start tag | 13 | 360.40 ± 0.4% | 365.42 ± 0.3% | 476.64 ± 0.3% | 44.20 ± 0.2% | 631.87 ± 1.9% | 876.68 ± 0.5% | 17907.48 ± 0.6% | 360.67 ± 0.4% | 0.99 | 1.00 | 8.15 | 0.57 |
| other: a whole word | 11 | 592.18 ± 0.7% | 626.59 ± 0.9% | 1035.74 ± 0.1% | 118.79 ± 0.7% | 569.57 ± 2.0% | 837.73 ± 0.5% | 26954.07 ± 0.3% | 593.22 ± 0.6% | 0.95 | 1.00 | 4.99 | 1.04 |
| other: a line's first word, second text | 17 | 544.79 ± 0.3% | 563.19 ± 0.7% | 893.53 ± 0.1% | 128.76 ± 0.1% | 717.47 ± 2.0% | refused | refused | 542.14 ± 1.0% | 0.97 | 1.00 | 4.23 | 0.76 |
| other: fourteen octets before an x | 16 | 108.92 ± 0.4% | 156.33 ± 0.6% | 178.16 ± 0.7% | 15.12 ± 0.6% | 457.14 ± 1.6% | 415.13 ± 0.9% | 12767.60 ± 0.6% | 109.00 ± 0.5% | 0.70 | 1.00 | 7.21 | 0.24 |
| other: a Greek word | 8 | 463.45 ± 0.3% | 613.75 ± 0.7% | 1027.95 ± 0.7% | 59.10 ± 0.2% | 1395.54 ± 0.9% | 1826.97 ± 0.3% | refused | 462.27 ± 0.4% | 0.76 | 1.00 | 7.84 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12828.11 ± 1.9% | not timed | not timed | 16377.01 ± 2.2% | 1985.71 ± 22.0% | not timed | not timed | 12812.88 ± 0.6% | | 1.00 | 0.78 | 6.46 |
| 01-literal/sherlock-casei-en | 522 | 4937.22 ± 1.5% | not timed | not timed | 3592.08 ± 1.0% | 32.17 ± 0.7% | not timed | not timed | 4943.02 ± 0.4% | | 1.00 | 1.37 | 153.48 |
| 01-literal/sherlock-ru | 724 | 13570.61 ± 0.7% | not timed | not timed | 17280.41 ± 0.3% | 1591.92 ± 3.7% | not timed | not timed | 13547.71 ± 0.2% | | 1.00 | 0.79 | 8.52 |
| 01-literal/sherlock-casei-ru | 746 | 5961.16 ± 0.3% | not timed | not timed | 3334.52 ± 0.2% | 31.33 ± 1.1% | not timed | not timed | 5969.92 ± 0.1% | | 1.00 | 1.79 | 190.28 |
| 01-literal/sherlock-zh | 30 | 17017.47 ± 0.3% | not timed | not timed | 18515.20 ± 0.9% | 2607.99 ± 14.2% | not timed | not timed | 16985.32 ± 0.3% | | 1.00 | 0.92 | 6.53 |
| 02-literal-alternate/sherlock-en | 714 | 5692.61 ± 0.5% | not timed | not timed | 3946.02 ± 0.4% | 16.43 ± 0.3% | not timed | not timed | 5762.11 ± 0.1% | | 0.99 | 1.44 | 346.56 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1798.07 ± 1.6% | not timed | not timed | 697.72 ± 0.2% | 11.07 ± 0.2% | not timed | not timed | 1791.92 ± 0.5% | | 1.00 | 2.58 | 162.43 |
| 02-literal-alternate/sherlock-ru | 899 | 5315.71 ± 1.2% | not timed | not timed | 3267.21 ± 0.1% | 22.65 ± 0.1% | not timed | not timed | 5328.73 ± 1.3% | | 1.00 | 1.63 | 234.69 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1915.91 ± 0.9% | not timed | not timed | 1234.95 ± 0.1% | 9.14 ± 0.1% | not timed | not timed | 1910.92 ± 0.2% | | 1.00 | 1.55 | 209.51 |
| 02-literal-alternate/sherlock-zh | 207 | 7011.11 ± 0.3% | not timed | not timed | 4160.31 ± 0.1% | 31.56 ± 0.1% | not timed | not timed | 7049.35 ± 0.2% | | 0.99 | 1.69 | 222.15 |
| 03-date/ascii | 111817 | 126.87 ± 0.2% | not timed | not timed | 95.58 ± 0.1% | 0.20 ± 3.3% | not timed | not timed | 126.14 ± 0.8% | | 1.01 | 1.33 | 621.15 |
| 04-ruff-noqa/real | 84 | 410.13 ± 0.1% | not timed | not timed | 458.77 ± 0.1% | 19.66 ± 1.4% | not timed | not timed | 408.18 ± 0.3% | | 1.00 | 0.89 | 20.86 |
| 04-ruff-noqa/tweaked | 44 | 552.69 ± 0.2% | not timed | not timed | 461.38 ± 0.1% | 363.42 ± 0.4% | not timed | not timed | 551.49 ± 0.2% | | 1.00 | 1.20 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.24 ± 0.9% | not timed | not timed | 4.94 ± 0.3% | 0.21 ± 4.0% | not timed | not timed | 5.09 ± 0.8% | | 1.03 | 1.06 | 25.26 |
| 06-cloud-flare-redos/original | 107 | 415.31 ± 0.2% | not timed | not timed | 215.14 ± 0.0% | 24.89 ± 5.8% | not timed | not timed | 414.50 ± 5.1% | | 1.00 | 1.93 | 16.69 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.92 ± 1.5% | not timed | not timed | 227.75 ± 0.0% | 26.71 ± 3.0% | not timed | not timed | 410.05 ± 8.4% | | 1.00 | 1.80 | 15.39 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.49 ± 0.2% | not timed | not timed | 255.13 ± 0.8% | 28.84 ± 0.1% | not timed | not timed | 586.87 ± 0.1% | | 1.00 | 2.30 | 20.37 |
| 07-unicode-character-data/parse-line | 558784 | 236.45 ± 0.3% | not timed | not timed | 169.97 ± 0.0% | 43.08 ± 0.4% | not timed | not timed | 236.85 ± 0.2% | | 1.00 | 1.39 | 5.49 |
| 08-words/all-english | 56691 | 117.39 ± 0.5% | not timed | not timed | 82.99 ± 0.1% | 11.81 ± 4.8% | not timed | not timed | 117.03 ± 0.5% | | 1.00 | 1.41 | 9.94 |
| 08-words/long-english | 839 | 621.37 ± 0.4% | not timed | not timed | 595.21 ± 0.1% | 32.28 ± 0.1% | not timed | not timed | 620.46 ± 0.1% | | 1.00 | 1.04 | 19.25 |
| 09-aws-keys/full | 0 | 415.81 ± 0.0% | not timed | not timed | 463.75 ± 0.2% | 64.31 ± 4.8% | not timed | not timed | 415.49 ± 0.1% | | 1.00 | 0.90 | 6.47 |
| 09-aws-keys/quick | 0 | 739.68 ± 0.1% | not timed | not timed | 984.11 ± 0.4% | 420.10 ± 0.2% | not timed | not timed | 735.84 ± 0.1% | | 1.01 | 0.75 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 581.95 ± 3.7% | not timed | not timed | 518.09 ± 0.4% | 19.56 ± 0.5% | not timed | not timed | 579.10 ± 2.2% | | 1.00 | 1.12 | 29.75 |
| 10-bounded-repeat/letters-ru | 3475 | 509.77 ± 0.9% | not timed | not timed | 478.41 ± 0.1% | 22.26 ± 17.1% | not timed | not timed | 507.06 ± 1.0% | | 1.01 | 1.07 | 22.91 |
| 10-bounded-repeat/context | 53 | 77.51 ± 0.4% | not timed | not timed | 65.45 ± 0.5% | 19.78 ± 0.2% | not timed | not timed | 77.43 ± 0.4% | | 1.00 | 1.18 | 3.92 |
| 10-bounded-repeat/capitals | 11 | 631.47 ± 8.2% | not timed | not timed | 616.77 ± 0.1% | 35.26 ± 0.1% | not timed | not timed | 630.72 ± 8.5% | | 1.00 | 1.02 | 17.91 |
| 11-unstructured-to-json/extract | 600 | 83.03 ± 0.2% | not timed | not timed | 76.97 ± 0.3% | 49.05 ± 1.2% | not timed | not timed | 82.71 ± 0.5% | | 1.00 | 1.08 | 1.69 |
| 12-dictionary/single | 1 | 560.94 ± 0.2% | not timed | not timed | 560.70 ± 0.0% | 0.40 ± 0.2% | not timed | not timed | 559.85 ± 0.4% | | 1.00 | 1.00 | 1399.94 |
| 14-quadratic/1x | 100 | 21.46 ± 2.0% | not timed | not timed | 10.00 ± 0.3% | 0.97 ± 3.4% | not timed | not timed | 21.39 ± 2.2% | | 1.00 | 2.15 | 22.10 |
| 14-quadratic/2x | 200 | 17.64 ± 0.6% | not timed | not timed | 5.54 ± 0.2% | 0.53 ± 2.0% | not timed | not timed | 17.57 ± 0.6% | | 1.00 | 3.18 | 33.33 |
| 14-quadratic/10x | 1000 | 7.71 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 2.0% | not timed | not timed | 7.66 ± 0.6% | | 1.01 | 6.35 | 66.69 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 0.1% | not timed | not timed | 0.34 ± 2.2% | 0.55 ± 7.1% | not timed | not timed | 1.27 ± 2.6% | | 1.00 | 3.69 | 2.30 |
| 04-ruff-noqa/compile-real | 1 | 92.86 ± 0.4% | not timed | not timed | 13.78 ± 0.3% | 140.32 ± 1.3% | not timed | not timed | 91.82 ± 1.2% | | 1.01 | 6.74 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 13.79 ± 1.4% | not timed | not timed | 2.53 ± 0.4% | 6.44 ± 2.0% | not timed | not timed | 13.68 ± 1.0% | | 1.01 | 5.45 | 2.14 |
| 07-unicode-character-data/compile | 1 | 55.04 ± 0.4% | not timed | not timed | 25.98 ± 0.4% | 36.82 ± 1.9% | not timed | not timed | 54.24 ± 1.4% | | 1.01 | 2.12 | 1.49 |
| 09-aws-keys/compile-full | 1 | 41.72 ± 2.6% | not timed | not timed | 8.29 ± 0.2% | 23.48 ± 0.8% | not timed | not timed | 41.65 ± 0.2% | | 1.00 | 5.03 | 1.78 |
| 09-aws-keys/compile-quick | 1 | 188.91 ± 0.2% | not timed | not timed | 47.64 ± 0.2% | 133.93 ± 3.6% | not timed | not timed | 187.61 ± 0.3% | | 1.01 | 3.97 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 14.01 ± 0.4% | not timed | not timed | 11.22 ± 0.1% | 16.22 ± 1.3% | not timed | not timed | 13.88 ± 1.2% | | 1.01 | 1.25 | 0.86 |
| 10-bounded-repeat/compile-capitals | 1 | 83.47 ± 0.5% | not timed | not timed | 8.04 ± 0.1% | 24.06 ± 0.9% | not timed | not timed | 83.74 ± 1.0% | | 1.00 | 10.38 | 3.47 |
| 11-unstructured-to-json/compile | 1 | 86.30 ± 0.5% | not timed | not timed | 40.61 ± 0.4% | 69.07 ± 5.3% | not timed | not timed | 85.00 ± 1.6% | | 1.02 | 2.13 | 1.25 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.4% | not timed | not timed | 0.07 ± 0.6% | 0.10 ± 17.8% | not timed | not timed | 0.35 ± 0.4% | | 1.01 | 5.10 | 3.68 |

