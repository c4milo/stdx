# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215335767 |
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
| literal: a word | 217 | 40597.83 ± 0.5% | 3968.37 ± 0.3% | 31.19 ± 13.4% | 38740.99 ± 1.1% | 11649.06 ± 1.9% | 12.87 ± 1.8% | 104.01 ± 1.0% | 40536.61 ± 0.7% | 10.23 | 1.00 | 1.05 | 3.49 |
| literal: a word that is not there | 0 | 57333.84 ± 0.3% | 3903.79 ± 0.8% | 28.71 ± 0.4% | 45519.28 ± 0.5% | 43670.84 ± 0.5% | 12.75 ± 0.1% | 98.75 ± 0.3% | 57350.87 ± 0.5% | 14.69 | 1.00 | 1.26 | 1.31 |
| literal: one of four words | 661 | 14175.08 ± 0.4% | 1671.60 ± 0.8% | 16.96 ± 0.8% | 11125.98 ± 0.9% | 24.95 ± 0.8% | 4.47 ± 1.4% | 8.64 ± 8.7% | 14153.04 ± 1.2% | 8.48 | 1.00 | 1.27 | 568.22 |
| literal: a word in any case | 217 | 36336.18 ± 0.4% | 1790.69 ± 0.7% | 23.90 ± 2.2% | 11327.86 ± 1.1% | 47.15 ± 1.1% | refused | differs | 36258.70 ± 0.1% | 20.29 | 1.00 | 3.21 | 770.60 |
| literal: an href attribute | 33 | 35305.24 ± 0.5% | 615.44 ± 0.1% | 29.50 ± 0.6% | 34909.71 ± 7.2% | 3040.85 ± 7.7% | 9.68 ± 2.4% | 91.32 ± 1.0% | 35336.39 ± 0.9% | 57.37 | 1.00 | 1.01 | 11.61 |
| literal: a word, second text | 123 | 43731.50 ± 0.6% | 3108.61 ± 0.7% | 30.94 ± 4.4% | 39813.25 ± 0.2% | 11037.06 ± 8.5% | 14.52 ± 0.4% | 88.94 ± 1.4% | 43762.21 ± 0.8% | 14.07 | 1.00 | 1.10 | 3.96 |
| class: two capitalized words | 1331 | 902.67 ± 3.1% | 605.40 ± 2.6% | 28.50 ± 3.1% | 575.04 ± 0.4% | 44.33 ± 1.2% | 11.07 ± 0.1% | 79.45 ± 0.3% | 904.63 ± 1.2% | 1.49 | 1.00 | 1.57 | 20.36 |
| class: a word that ends in ing | 3399 | 575.59 ± 0.3% | 574.83 ± 0.3% | 19.21 ± 1.0% | 539.69 ± 0.4% | 32.41 ± 7.6% | 6.22 ± 0.2% | 20.59 ± 0.4% | 575.50 ± 0.4% | 1.00 | 1.00 | 1.07 | 17.76 |
| class: a word in capitals | 2332 | 1141.43 ± 0.3% | 609.83 ± 0.1% | 30.57 ± 0.1% | 565.09 ± 0.6% | 47.66 ± 4.9% | 12.51 ± 0.1% | 101.88 ± 0.6% | 1140.32 ± 0.2% | 1.87 | 1.00 | 2.02 | 23.95 |
| class: a number | 8288 | 1830.24 ± 0.4% | 814.42 ± 0.4% | 30.85 ± 1.6% | 1810.47 ± 19.8% | 44.78 ± 11.8% | 0.39 ± 0.3% | 72.39 ± 0.3% | 1812.72 ± 1.6% | 2.25 | 1.01 | 1.01 | 40.87 |
| class: two capitalized words, second text | 5359 | 512.39 ± 0.2% | 517.76 ± 1.2% | 21.56 ± 0.2% | 478.76 ± 0.2% | 38.84 ± 5.9% | 12.75 ± 1.0% | 73.91 ± 0.5% | 512.49 ± 0.1% | 0.99 | 1.00 | 1.07 | 13.19 |
| other: a word between two words | 6104 | 832.68 ± 0.3% | 583.78 ± 0.4% | 25.35 ± 0.2% | 817.18 ± 0.5% | 123.92 ± 11.0% | 8.58 ± 0.2% | 82.60 ± 0.2% | 831.58 ± 0.1% | 1.43 | 1.00 | 1.02 | 6.72 |
| other: a number before a unit, second text | 1481 | 9939.41 ± 0.6% | 1053.05 ± 0.5% | 28.84 ± 0.4% | 8281.10 ± 0.6% | 44.93 ± 0.2% | 13.37 ± 0.2% | 77.32 ± 0.4% | 9874.08 ± 0.5% | 9.44 | 1.01 | 1.20 | 221.23 |
| other: a heading's start tag | 110 | 24409.86 ± 0.4% | 746.89 ± 0.1% | 30.61 ± 0.2% | 2566.70 ± 1.1% | 1975.25 ± 8.4% | 11.84 ± 0.3% | 107.24 ± 0.3% | 24350.11 ± 0.4% | 32.68 | 1.00 | 9.51 | 12.36 |
| other: a whole word | 217 | 28769.28 ± 6.2% | 607.90 ± 0.2% | 31.67 ± 0.5% | 28058.13 ± 0.4% | 54.11 ± 1.6% | 11.19 ± 0.7% | 63.21 ± 0.4% | 29214.92 ± 0.4% | 47.33 | 0.98 | 1.03 | 531.68 |
| other: a line's first word, second text | 3716 | 2563.04 ± 9.3% | 588.55 ± 0.6% | 35.16 ± 0.4% | 2322.56 ± 1.1% | 70.96 ± 3.3% | refused | refused | 2537.30 ± 8.9% | 4.35 | 1.01 | 1.10 | 36.12 |
| other: fourteen octets before an x | 87 | 36178.30 ± 1.9% | 262.05 ± 9.2% | 6.93 ± 0.5% | 3413.06 ± 0.1% | 11.47 ± 0.9% | differs | 21.38 ± 1.1% | 36124.49 ± 1.0% | 138.06 | 1.00 | 10.60 | 3154.59 |
| other: a Greek word | 21815 | 459.42 ± 2.2% | 395.26 ± 3.8% | 34.72 ± 11.7% | 302.65 ± 0.2% | 52.46 ± 12.6% | differs | refused | 458.28 ± 0.3% | 1.16 | 1.00 | 1.52 | 8.76 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 20.34 ± 3.9% | 21.46 ± 4.8% | 1.01 ± 3.2% | 19.87 ± 0.5% | 2.69 ± 3.4% | differs | 4.35 ± 0.8% | 21.53 ± 0.9% | 0.95 | 0.94 | 1.02 | 7.56 |
| a UUID | 32895 | 24.44 ± 0.3% | 24.19 ± 1.0% | 0.72 ± 0.5% | 15.11 ± 1.0% | 3.07 ± 2.0% | 0.52 ± 0.9% | 3.77 ± 1.1% | 24.38 ± 0.2% | 1.01 | 1.00 | 1.62 | 7.97 |
| an IPv4 address | 33176 | 41.06 ± 0.4% | 41.03 ± 3.6% | 2.30 ± 6.7% | 26.74 ± 0.2% | 6.99 ± 10.1% | differs | 4.21 ± 0.8% | 41.05 ± 0.6% | 1.00 | 1.00 | 1.54 | 5.87 |
| a date and time | 32954 | 36.31 ± 4.3% | 35.77 ± 4.7% | 1.69 ± 7.7% | 21.68 ± 2.7% | 8.10 ± 2.1% | 0.91 ± 0.3% | 7.88 ± 1.5% | 36.21 ± 0.6% | 1.01 | 1.00 | 1.67 | 4.48 |
| a field path | 32606 | 25.30 ± 0.4% | 25.45 ± 0.2% | 1.13 ± 1.1% | 21.98 ± 0.1% | 3.55 ± 1.9% | differs | 3.10 ± 0.7% | 25.45 ± 0.2% | 0.99 | 0.99 | 1.15 | 7.13 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.95 ± 0.3% | 10.95 ± 0.5% | 10.98 ± 0.7% | 13.33 ± 1.4% | 5.89 ± 4.0% | 0.75 ± 0.5% | none | 10.81 ± 0.7% | 1.00 | 1.01 | 0.82 | 1.86 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.40 ± 0.6% | 236.38 ± 0.2% | 275.01 ± 1.4% | 102.08 ± 1.5% | 247.88 ± 3.2% | 690.71 ± 5.0% | 4959.38 ± 0.2% | 235.03 ± 0.2% | 1.00 | 1.00 | 2.31 | 0.95 |
| a UUID | 62 | 153.74 ± 0.2% | 154.32 ± 1.3% | 171.53 ± 0.2% | 58.61 ± 1.5% | 120.15 ± 0.8% | 260.06 ± 1.5% | 5540.52 ± 0.8% | 153.66 ± 1.1% | 1.00 | 1.00 | 2.62 | 1.28 |
| an IPv4 address | 29 | 487.44 ± 1.8% | 492.02 ± 0.4% | 694.91 ± 0.7% | 88.21 ± 0.6% | 149.15 ± 2.8% | 416.80 ± 0.5% | 8982.14 ± 0.5% | 488.42 ± 0.1% | 0.99 | 1.00 | 5.53 | 3.27 |
| a date and time | 56 | 353.87 ± 0.6% | 356.05 ± 1.1% | 449.16 ± 19.3% | 87.11 ± 2.0% | 162.12 ± 2.6% | 479.00 ± 10.3% | 5679.97 ± 0.8% | 354.26 ± 0.7% | 0.99 | 1.00 | 4.06 | 2.18 |
| a field path | 39 | 228.03 ± 0.3% | 229.59 ± 0.8% | 265.81 ± 1.3% | 96.28 ± 2.3% | 232.61 ± 1.0% | 739.54 ± 15.4% | 6021.42 ± 1.9% | 227.93 ± 3.7% | 0.99 | 1.00 | 2.37 | 0.98 |
| literal: a word | 7 | 746.51 ± 0.2% | 789.17 ± 0.5% | 1429.74 ± 0.4% | 654.34 ± 5.2% | 798.24 ± 36.9% | 1601.35 ± 2.0% | 34235.83 ± 0.7% | 747.30 ± 0.2% | 0.95 | 1.00 | 1.14 | 0.94 |
| literal: a word that is not there | 8 | 717.36 ± 0.3% | 764.69 ± 17.7% | 1339.09 ± 0.6% | 599.12 ± 0.7% | 768.04 ± 55.0% | 1502.68 ± 0.8% | 33540.30 ± 0.2% | 716.84 ± 0.6% | 0.94 | 1.00 | 1.20 | 0.93 |
| literal: one of four words | 26 | 262.08 ± 1.6% | 443.17 ± 0.3% | 594.39 ± 0.2% | 54.04 ± 1.1% | 292.99 ± 1.3% | 596.88 ± 1.3% | 18001.53 ± 1.3% | 264.08 ± 0.3% | 0.59 | 0.99 | 4.85 | 0.89 |
| literal: a word in any case | 11 | 514.28 ± 9.6% | 538.44 ± 0.8% | 780.61 ± 0.6% | 18.96 ± 0.7% | 830.50 ± 39.3% | refused | 27550.05 ± 1.6% | 513.22 ± 0.7% | 0.96 | 1.00 | 27.13 | 0.62 |
| literal: an href attribute | 12 | 397.82 ± 0.2% | 411.31 ± 0.6% | 542.14 ± 0.3% | 49.34 ± 0.6% | 575.82 ± 0.8% | 1277.76 ± 0.9% | 24707.09 ± 0.5% | 397.30 ± 0.8% | 0.97 | 1.00 | 8.06 | 0.69 |
| literal: a word, second text | 10 | 661.91 ± 2.2% | 716.90 ± 0.5% | 1197.77 ± 0.7% | 531.48 ± 1.6% | 647.53 ± 9.6% | 1359.75 ± 13.7% | 32166.18 ± 0.3% | 661.84 ± 10.3% | 0.92 | 1.00 | 1.25 | 1.02 |
| class: two capitalized words | 23 | 513.25 ± 0.4% | 556.60 ± 0.1% | 814.36 ± 3.0% | 124.26 ± 1.1% | 595.48 ± 17.5% | 1289.94 ± 2.2% | 8093.58 ± 0.4% | 513.79 ± 0.1% | 0.92 | 1.00 | 4.13 | 0.86 |
| class: a word that ends in ing | 9 | 640.70 ± 0.4% | 726.53 ± 2.0% | 1292.35 ± 0.9% | 155.19 ± 1.5% | 857.79 ± 1.9% | 1934.44 ± 0.8% | 19326.64 ± 0.3% | 641.24 ± 0.2% | 0.88 | 1.00 | 4.13 | 0.75 |
| class: a word in capitals | 16 | 561.02 ± 0.2% | 611.17 ± 0.1% | 999.83 ± 0.3% | 159.29 ± 2.4% | 897.70 ± 12.2% | 1778.44 ± 0.6% | 10576.91 ± 0.4% | 561.60 ± 0.4% | 0.92 | 1.00 | 3.52 | 0.62 |
| class: a number | 6 | 703.55 ± 0.6% | 788.07 ± 1.7% | 1506.46 ± 0.4% | 47.37 ± 3.1% | 1648.82 ± 2.6% | 3010.82 ± 9.0% | 25956.62 ± 2.4% | 704.00 ± 0.5% | 0.89 | 1.00 | 14.85 | 0.43 |
| class: two capitalized words, second text | 23 | 512.94 ± 0.3% | 557.38 ± 1.1% | 811.30 ± 1.2% | 121.78 ± 0.9% | 603.50 ± 7.8% | 1224.66 ± 6.8% | 8088.01 ± 5.6% | 512.98 ± 1.1% | 0.92 | 1.00 | 4.21 | 0.85 |
| other: a word between two words | 13 | 632.24 ± 6.2% | 653.88 ± 0.1% | 1034.70 ± 4.1% | 156.62 ± 4.6% | 588.50 ± 1.0% | 1349.74 ± 0.6% | 18064.69 ± 0.5% | 632.23 ± 2.7% | 0.97 | 1.00 | 4.04 | 1.07 |
| other: a number before a unit, second text | 15 | 437.43 ± 0.6% | 487.97 ± 0.4% | 671.95 ± 6.0% | 44.23 ± 7.8% | 734.60 ± 1.3% | 1479.46 ± 1.5% | 17826.91 ± 0.1% | 437.05 ± 0.2% | 0.90 | 1.00 | 9.89 | 0.60 |
| other: a heading's start tag | 13 | 409.93 ± 8.5% | 415.59 ± 1.1% | 549.33 ± 1.4% | 47.17 ± 1.3% | 712.63 ± 2.3% | 1346.77 ± 15.6% | 20677.38 ± 0.6% | 410.55 ± 0.1% | 0.99 | 1.00 | 8.69 | 0.58 |
| other: a whole word | 11 | 650.22 ± 0.4% | 682.68 ± 15.7% | 1120.21 ± 0.5% | 142.75 ± 0.2% | 692.65 ± 1.6% | 1361.09 ± 0.9% | 31829.69 ± 0.7% | 647.81 ± 1.6% | 0.95 | 1.00 | 4.56 | 0.94 |
| other: a line's first word, second text | 17 | 604.30 ± 0.5% | 632.69 ± 0.1% | 1023.80 ± 9.7% | 149.33 ± 0.3% | 814.26 ± 0.8% | refused | refused | 603.93 ± 0.7% | 0.96 | 1.00 | 4.05 | 0.74 |
| other: fourteen octets before an x | 16 | 115.88 ± 13.4% | 169.93 ± 15.6% | 199.74 ± 0.2% | 17.71 ± 0.9% | 532.57 ± 19.8% | 582.41 ± 1.0% | 15683.20 ± 0.4% | 115.99 ± 3.3% | 0.68 | 1.00 | 6.54 | 0.22 |
| other: a Greek word | 8 | 446.07 ± 0.4% | 653.32 ± 1.6% | 1066.14 ± 0.8% | 60.75 ± 0.2% | 1619.16 ± 1.5% | 2855.71 ± 0.8% | refused | 446.33 ± 0.3% | 0.68 | 1.00 | 7.34 | 0.28 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 29041.58 ± 14.0% | not timed | not timed | 33231.33 ± 1.3% | 2604.67 ± 7.4% | not timed | not timed | 29008.96 ± 0.5% | | 1.00 | 0.87 | 11.15 |
| 01-literal/sherlock-casei-en | 522 | 10741.97 ± 1.3% | not timed | not timed | 8998.35 ± 0.2% | 34.12 ± 14.2% | not timed | not timed | 10714.39 ± 9.4% | | 1.00 | 1.19 | 314.83 |
| 01-literal/sherlock-ru | 724 | 30455.57 ± 0.4% | not timed | not timed | 34409.27 ± 5.3% | 1253.62 ± 14.3% | not timed | not timed | 30332.24 ± 0.7% | | 1.00 | 0.89 | 24.29 |
| 01-literal/sherlock-casei-ru | 746 | 11893.71 ± 0.5% | not timed | not timed | 7778.34 ± 0.9% | 37.70 ± 0.6% | not timed | not timed | 11849.39 ± 11.5% | | 1.00 | 1.53 | 315.49 |
| 01-literal/sherlock-zh | 30 | 53040.25 ± 0.4% | not timed | not timed | 42782.75 ± 0.3% | 1630.19 ± 5.4% | not timed | not timed | 52816.46 ± 0.9% | | 1.00 | 1.24 | 32.54 |
| 02-literal-alternate/sherlock-en | 714 | 12600.44 ± 0.2% | not timed | not timed | 10869.12 ± 8.0% | 19.09 ± 0.5% | not timed | not timed | 12614.95 ± 2.3% | | 1.00 | 1.16 | 660.00 |
| 02-literal-alternate/sherlock-casei-en | 725 | 4815.10 ± 7.0% | not timed | not timed | 2309.13 ± 0.5% | 12.26 ± 1.0% | not timed | not timed | 4450.37 ± 8.7% | | 1.08 | 2.09 | 392.70 |
| 02-literal-alternate/sherlock-ru | 899 | 10320.47 ± 0.3% | not timed | not timed | 9790.30 ± 0.7% | 25.39 ± 0.5% | not timed | not timed | 10297.84 ± 0.2% | | 1.00 | 1.05 | 406.51 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2466.53 ± 2.6% | not timed | not timed | 1187.52 ± 1.0% | 10.52 ± 4.3% | not timed | not timed | 2451.65 ± 1.1% | | 1.01 | 2.08 | 234.53 |
| 02-literal-alternate/sherlock-zh | 207 | 18398.60 ± 0.3% | not timed | not timed | 12610.01 ± 0.3% | 35.21 ± 0.7% | not timed | not timed | 18398.63 ± 1.4% | | 1.00 | 1.46 | 522.47 |
| 03-date/ascii | 111817 | 127.10 ± 1.2% | not timed | not timed | 100.80 ± 0.3% | 0.23 ± 3.0% | not timed | not timed | 126.77 ± 9.9% | | 1.00 | 1.26 | 550.97 |
| 04-ruff-noqa/real | 84 | 489.37 ± 0.2% | not timed | not timed | 508.39 ± 0.4% | 20.86 ± 2.6% | not timed | not timed | 488.15 ± 3.8% | | 1.00 | 0.96 | 23.46 |
| 04-ruff-noqa/tweaked | 44 | 585.00 ± 0.2% | not timed | not timed | 510.42 ± 10.9% | 365.02 ± 1.0% | not timed | not timed | 584.13 ± 0.4% | | 1.00 | 1.15 | 1.60 |
| 05-lexer-veryl/single | 124800 | 4.65 ± 2.1% | not timed | not timed | 5.36 ± 1.5% | 0.26 ± 3.5% | not timed | not timed | 4.55 ± 0.6% | | 1.02 | 0.87 | 17.96 |
| 06-cloud-flare-redos/original | 107 | 411.94 ± 0.4% | not timed | not timed | 228.22 ± 0.4% | 25.75 ± 0.5% | not timed | not timed | 411.29 ± 1.0% | | 1.00 | 1.80 | 15.99 |
| 06-cloud-flare-redos/simplified-short | 102 | 398.43 ± 0.6% | not timed | not timed | 237.14 ± 0.3% | 27.70 ± 15.3% | not timed | not timed | 397.58 ± 2.1% | | 1.00 | 1.68 | 14.38 |
| 06-cloud-flare-redos/simplified-long | 10000 | 510.42 ± 0.1% | not timed | not timed | 259.83 ± 0.1% | 29.88 ± 1.1% | not timed | not timed | 509.56 ± 0.3% | | 1.00 | 1.96 | 17.08 |
| 07-unicode-character-data/parse-line | 558784 | 247.72 ± 11.1% | not timed | not timed | 201.59 ± 0.2% | 48.51 ± 4.3% | not timed | not timed | 246.19 ± 4.7% | | 1.01 | 1.23 | 5.11 |
| 08-words/all-english | 56691 | 112.53 ± 0.9% | not timed | not timed | 84.86 ± 0.3% | 14.17 ± 10.5% | not timed | not timed | 111.07 ± 0.5% | | 1.01 | 1.33 | 7.94 |
| 08-words/long-english | 839 | 615.55 ± 0.1% | not timed | not timed | 585.12 ± 0.1% | 34.98 ± 0.3% | not timed | not timed | 614.75 ± 0.5% | | 1.00 | 1.05 | 17.60 |
| 09-aws-keys/full | 0 | 495.02 ± 1.2% | not timed | not timed | 541.52 ± 0.4% | 67.21 ± 0.7% | not timed | not timed | 495.05 ± 17.2% | | 1.00 | 0.91 | 7.36 |
| 09-aws-keys/quick | 0 | 910.18 ± 0.7% | not timed | not timed | 961.29 ± 1.1% | 415.67 ± 0.6% | not timed | not timed | 897.07 ± 0.9% | | 1.01 | 0.95 | 2.19 |
| 10-bounded-repeat/letters-en | 1833 | 677.17 ± 1.1% | not timed | not timed | 554.54 ± 0.4% | 22.11 ± 0.8% | not timed | not timed | 678.07 ± 0.3% | | 1.00 | 1.22 | 30.63 |
| 10-bounded-repeat/letters-ru | 3475 | 529.26 ± 1.9% | not timed | not timed | 483.41 ± 0.4% | 24.17 ± 12.4% | not timed | not timed | 525.41 ± 0.6% | | 1.01 | 1.09 | 21.90 |
| 10-bounded-repeat/context | 53 | 83.62 ± 0.6% | not timed | not timed | 70.58 ± 1.6% | 22.59 ± 3.7% | not timed | not timed | 82.94 ± 5.2% | | 1.01 | 1.18 | 3.70 |
| 10-bounded-repeat/capitals | 11 | 640.30 ± 7.7% | not timed | not timed | 604.59 ± 0.1% | 40.21 ± 1.7% | not timed | not timed | 638.55 ± 8.0% | | 1.00 | 1.06 | 15.93 |
| 11-unstructured-to-json/extract | 600 | 64.31 ± 0.8% | not timed | not timed | 80.04 ± 12.3% | 49.79 ± 16.7% | not timed | not timed | 64.07 ± 1.3% | | 1.00 | 0.80 | 1.29 |
| 12-dictionary/single | 1 | 510.28 ± 0.4% | not timed | not timed | 481.40 ± 0.3% | 0.38 ± 4.2% | not timed | not timed | 512.72 ± 0.1% | | 1.00 | 1.06 | 1343.14 |
| 14-quadratic/1x | 100 | 26.35 ± 1.0% | not timed | not timed | 12.19 ± 0.3% | 1.00 ± 4.6% | not timed | not timed | 26.27 ± 1.0% | | 1.00 | 2.16 | 26.44 |
| 14-quadratic/2x | 200 | 19.96 ± 0.6% | not timed | not timed | 6.13 ± 0.2% | 0.53 ± 3.2% | not timed | not timed | 19.98 ± 3.7% | | 1.00 | 3.26 | 37.59 |
| 14-quadratic/10x | 1000 | 6.88 ± 0.3% | not timed | not timed | 1.22 ± 0.1% | 0.12 ± 2.8% | not timed | not timed | 6.86 ± 0.6% | | 1.00 | 5.66 | 59.59 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.42 ± 1.1% | not timed | not timed | 0.48 ± 0.5% | 0.64 ± 1.7% | not timed | not timed | 1.42 ± 1.2% | | 1.00 | 2.98 | 2.21 |
| 04-ruff-noqa/compile-real | 1 | 99.25 ± 2.8% | not timed | not timed | 17.20 ± 20.1% | 169.51 ± 3.2% | not timed | not timed | 98.25 ± 0.7% | | 1.01 | 5.77 | 0.59 |
| 05-lexer-veryl/compile-single | 1 | 16.19 ± 0.4% | not timed | not timed | 3.01 ± 0.9% | 7.85 ± 2.9% | not timed | not timed | 16.09 ± 11.8% | | 1.01 | 5.39 | 2.06 |
| 07-unicode-character-data/compile | 1 | 61.20 ± 1.4% | not timed | not timed | 30.30 ± 1.4% | 44.45 ± 2.6% | not timed | not timed | 61.24 ± 1.5% | | 1.00 | 2.02 | 1.38 |
| 09-aws-keys/compile-full | 1 | 43.76 ± 0.1% | not timed | not timed | 10.02 ± 0.4% | 27.72 ± 2.5% | not timed | not timed | 43.44 ± 1.4% | | 1.01 | 4.37 | 1.58 |
| 09-aws-keys/compile-quick | 1 | 189.72 ± 0.9% | not timed | not timed | 57.90 ± 1.2% | 155.77 ± 3.3% | not timed | not timed | 186.34 ± 0.7% | | 1.02 | 3.28 | 1.22 |
| 10-bounded-repeat/compile-context | 1 | 14.86 ± 1.1% | not timed | not timed | 14.47 ± 0.3% | 19.99 ± 2.9% | not timed | not timed | 14.79 ± 1.1% | | 1.00 | 1.03 | 0.74 |
| 10-bounded-repeat/compile-capitals | 1 | 90.19 ± 1.0% | not timed | not timed | 10.52 ± 0.7% | 29.10 ± 5.1% | not timed | not timed | 89.99 ± 1.3% | | 1.00 | 8.57 | 3.10 |
| 11-unstructured-to-json/compile | 1 | 94.12 ± 0.4% | not timed | not timed | 47.67 ± 0.5% | 77.80 ± 5.7% | not timed | not timed | 93.61 ± 0.9% | | 1.01 | 1.97 | 1.21 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.08 ± 4.3% | 0.11 ± 12.6% | not timed | not timed | 0.34 ± 2.3% | | 1.01 | 4.22 | 3.24 |

