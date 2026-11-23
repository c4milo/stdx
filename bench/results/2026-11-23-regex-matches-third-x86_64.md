# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127328395 |
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
| literal: a word | 217 | 32734.88 ± 2.1% | 842.19 ± 0.2% | 19.82 ± 2.4% | 31184.40 ± 0.7% | 8883.39 ± 10.5% | 10.76 ± 0.4% | 76.47 ± 1.2% | 32476.51 ± 1.1% | 38.87 | 1.01 | 1.05 | 3.68 |
| literal: a word that is not there | 0 | 49405.26 ± 2.0% | 849.74 ± 0.2% | 19.61 ± 2.1% | 39593.60 ± 0.9% | 30236.66 ± 0.4% | 10.70 ± 0.3% | 72.46 ± 1.8% | 48890.15 ± 1.2% | 58.14 | 1.01 | 1.25 | 1.63 |
| literal: one of four words | 661 | 10966.26 ± 4.7% | 824.04 ± 0.2% | 10.90 ± 2.9% | 9116.77 ± 0.5% | 19.21 ± 1.6% | 4.00 ± 1.6% | 6.69 ± 1.2% | 11051.20 ± 4.7% | 13.31 | 0.99 | 1.20 | 570.88 |
| literal: a word in any case | 217 | 25897.05 ± 4.7% | 841.68 ± 0.8% | 14.82 ± 5.4% | 9236.90 ± 0.5% | 37.19 ± 0.5% | refused | differs | 25553.36 ± 1.3% | 30.77 | 1.01 | 2.80 | 696.40 |
| literal: an href attribute | 33 | 27239.51 ± 1.7% | 847.54 ± 0.2% | 18.21 ± 1.7% | 27176.57 ± 0.8% | 2051.06 ± 4.7% | 8.22 ± 0.2% | 61.69 ± 0.8% | 27007.67 ± 1.4% | 32.14 | 1.01 | 1.00 | 13.28 |
| literal: a word, second text | 123 | 34187.63 ± 2.5% | 845.96 ± 0.1% | 19.58 ± 0.7% | 31999.50 ± 0.6% | 7302.55 ± 5.4% | 11.86 ± 0.7% | 65.37 ± 0.7% | 33602.44 ± 0.9% | 40.41 | 1.02 | 1.07 | 4.68 |
| class: two capitalized words | 1331 | 786.48 ± 0.3% | 788.59 ± 0.3% | 18.58 ± 3.7% | 506.52 ± 0.1% | 33.72 ± 9.7% | 9.29 ± 0.4% | 55.70 ± 0.3% | 784.16 ± 0.4% | 1.00 | 1.00 | 1.55 | 23.32 |
| class: a word that ends in ing | 3399 | 715.76 ± 0.2% | 716.54 ± 0.5% | 12.99 ± 0.3% | 472.25 ± 0.3% | 25.60 ± 6.0% | 5.35 ± 0.2% | 17.24 ± 0.6% | 714.22 ± 0.9% | 1.00 | 1.00 | 1.52 | 27.96 |
| class: a word in capitals | 2332 | 987.71 ± 0.3% | 768.57 ± 2.2% | 19.52 ± 1.0% | 497.10 ± 1.0% | 36.63 ± 3.1% | 10.34 ± 0.7% | 76.42 ± 0.3% | 987.57 ± 3.3% | 1.29 | 1.00 | 1.99 | 26.96 |
| class: a number | 8288 | 1418.83 ± 17.2% | 658.26 ± 2.5% | 19.23 ± 2.2% | 1485.56 ± 2.3% | 35.94 ± 11.3% | 0.33 ± 0.6% | 55.76 ± 2.5% | 1420.87 ± 1.7% | 2.16 | 1.00 | 0.96 | 39.48 |
| class: two capitalized words, second text | 5359 | 594.03 ± 0.2% | 593.44 ± 0.4% | 17.15 ± 3.1% | 418.33 ± 0.2% | 30.03 ± 4.7% | 10.56 ± 0.3% | 51.80 ± 0.5% | 593.68 ± 0.3% | 1.00 | 1.00 | 1.42 | 19.78 |
| other: a word between two words | 6104 | 641.39 ± 0.3% | 619.02 ± 0.4% | 16.70 ± 2.3% | 682.78 ± 0.5% | 98.33 ± 6.5% | 7.18 ± 0.2% | 56.72 ± 0.6% | 638.21 ± 4.7% | 1.04 | 1.00 | 0.94 | 6.52 |
| other: a number before a unit, second text | 1481 | 6610.10 ± 1.2% | 793.89 ± 0.4% | 18.67 ± 2.6% | 6438.79 ± 0.5% | 35.02 ± 16.6% | 10.93 ± 0.3% | 55.18 ± 5.9% | 6572.21 ± 1.0% | 8.33 | 1.01 | 1.03 | 188.77 |
| other: a heading's start tag | 110 | 18856.85 ± 3.5% | 840.84 ± 0.9% | 19.18 ± 7.1% | 2010.40 ± 0.4% | 1475.81 ± 3.6% | 10.01 ± 0.2% | 72.61 ± 0.6% | 18634.83 ± 0.7% | 22.43 | 1.01 | 9.38 | 12.78 |
| other: a whole word | 217 | 22796.99 ± 15.3% | 842.18 ± 0.1% | 19.20 ± 2.2% | 22559.10 ± 0.4% | 40.67 ± 14.0% | 9.42 ± 0.5% | 47.08 ± 0.7% | 22382.32 ± 1.6% | 27.07 | 1.02 | 1.01 | 560.52 |
| other: a line's first word, second text | 3716 | 1694.69 ± 5.0% | 704.89 ± 0.2% | 22.15 ± 3.1% | 1705.25 ± 3.0% | 53.23 ± 2.2% | refused | refused | 1716.05 ± 0.8% | 2.40 | 0.99 | 0.99 | 31.84 |
| other: fourteen octets before an x | 87 | 25330.47 ± 1.8% | 187.36 ± 1.4% | 5.08 ± 0.2% | 2731.87 ± 1.3% | 9.01 ± 0.4% | differs | 15.44 ± 2.2% | 25315.51 ± 1.1% | 135.20 | 1.00 | 9.27 | 2809.91 |
| other: a Greek word | 21815 | 396.37 ± 0.5% | 289.62 ± 1.1% | 23.15 ± 2.5% | 264.31 ± 1.0% | 38.18 ± 7.1% | differs | refused | 394.99 ± 0.3% | 1.37 | 1.00 | 1.50 | 10.38 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.47 ± 0.9% | 24.48 ± 0.7% | 0.71 ± 0.5% | 16.79 ± 0.2% | 2.33 ± 0.7% | differs | 3.64 ± 0.4% | 24.57 ± 1.7% | 1.00 | 1.00 | 1.46 | 10.48 |
| a UUID | 32895 | 20.61 ± 0.6% | 20.53 ± 0.2% | 0.55 ± 1.0% | 12.82 ± 0.3% | 2.49 ± 2.0% | 0.44 ± 0.2% | 3.09 ± 0.3% | 20.62 ± 0.2% | 1.00 | 1.00 | 1.61 | 8.26 |
| an IPv4 address | 33176 | 33.86 ± 4.1% | 33.95 ± 0.5% | 1.76 ± 0.6% | 24.00 ± 0.2% | 5.79 ± 1.0% | differs | 3.38 ± 12.4% | 33.91 ± 2.1% | 1.00 | 1.00 | 1.41 | 5.85 |
| a date and time | 32954 | 30.39 ± 8.4% | 30.39 ± 0.3% | 1.27 ± 0.3% | 17.91 ± 0.3% | 6.68 ± 1.1% | 0.76 ± 0.5% | 6.19 ± 9.4% | 30.33 ± 8.3% | 1.00 | 1.00 | 1.70 | 4.55 |
| a field path | 32606 | 27.36 ± 0.5% | 27.36 ± 0.6% | 0.85 ± 0.5% | 19.37 ± 0.2% | 2.94 ± 0.7% | differs | 2.47 ± 0.8% | 27.28 ± 7.7% | 1.00 | 1.00 | 1.41 | 9.29 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.28 ± 2.6% | 8.38 ± 0.8% | 8.24 ± 1.7% | 10.65 ± 0.3% | 4.59 ± 1.3% | 0.62 ± 0.5% | none | 8.46 ± 3.0% | 0.99 | 0.98 | 0.78 | 1.80 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 181.88 ± 0.7% | 182.21 ± 2.1% | 207.36 ± 0.5% | 79.87 ± 3.9% | 178.80 ± 11.6% | 539.54 ± 5.3% | 3989.99 ± 0.9% | 181.91 ± 1.4% | 1.00 | 1.00 | 2.28 | 1.02 |
| a UUID | 62 | 120.25 ± 2.1% | 120.87 ± 4.2% | 132.68 ± 2.2% | 46.42 ± 4.9% | 87.20 ± 10.8% | 197.31 ± 2.1% | 4094.87 ± 2.3% | 119.68 ± 2.3% | 0.99 | 1.00 | 2.59 | 1.38 |
| an IPv4 address | 29 | 392.50 ± 8.8% | 398.04 ± 10.2% | 558.78 ± 2.1% | 70.67 ± 0.8% | 110.07 ± 3.0% | 325.23 ± 1.7% | 7186.90 ± 0.4% | 395.24 ± 1.5% | 0.99 | 0.99 | 5.55 | 3.57 |
| a date and time | 56 | 285.32 ± 0.6% | 286.46 ± 0.4% | 358.27 ± 0.3% | 69.32 ± 8.0% | 116.99 ± 5.6% | 371.02 ± 2.8% | 4242.16 ± 3.7% | 284.85 ± 0.4% | 1.00 | 1.00 | 4.12 | 2.44 |
| a field path | 39 | 180.72 ± 0.4% | 181.39 ± 0.2% | 208.92 ± 0.4% | 74.51 ± 0.8% | 153.08 ± 3.6% | 570.87 ± 1.4% | 4825.88 ± 1.0% | 180.78 ± 0.2% | 1.00 | 1.00 | 2.43 | 1.18 |
| literal: a word | 7 | 594.62 ± 3.5% | 632.01 ± 0.6% | 1110.24 ± 0.7% | 480.68 ± 0.9% | 577.45 ± 2.2% | 1263.96 ± 1.3% | 25077.10 ± 0.5% | 594.96 ± 0.8% | 0.94 | 1.00 | 1.24 | 1.03 |
| literal: a word that is not there | 8 | 568.20 ± 14.0% | 613.33 ± 0.9% | 1051.50 ± 0.5% | 449.58 ± 0.4% | 548.34 ± 1.7% | 1190.50 ± 0.7% | 23813.81 ± 1.0% | 570.21 ± 0.3% | 0.93 | 1.00 | 1.26 | 1.04 |
| literal: one of four words | 26 | 225.25 ± 6.7% | 364.99 ± 0.3% | 490.01 ± 1.1% | 41.70 ± 0.9% | 208.69 ± 5.0% | 454.45 ± 9.9% | 11478.95 ± 1.1% | 225.25 ± 0.7% | 0.62 | 1.00 | 5.40 | 1.08 |
| literal: a word in any case | 11 | 450.73 ± 0.7% | 476.53 ± 0.5% | 710.20 ± 2.3% | 14.58 ± 1.3% | 594.25 ± 5.6% | refused | 19047.31 ± 5.5% | 449.07 ± 10.0% | 0.95 | 1.00 | 30.91 | 0.76 |
| literal: an href attribute | 12 | 317.62 ± 0.6% | 328.05 ± 1.4% | 429.72 ± 1.1% | 36.05 ± 1.2% | 425.57 ± 4.2% | 968.47 ± 1.5% | 18591.82 ± 11.0% | 317.56 ± 5.2% | 0.97 | 1.00 | 8.81 | 0.75 |
| literal: a word, second text | 10 | 527.73 ± 1.9% | 573.78 ± 1.4% | 951.65 ± 4.1% | 405.82 ± 8.5% | 472.64 ± 18.3% | 1018.05 ± 0.8% | 21584.52 ± 1.2% | 527.28 ± 0.6% | 0.92 | 1.00 | 1.30 | 1.12 |
| class: two capitalized words | 23 | 422.75 ± 0.2% | 449.48 ± 1.6% | 654.67 ± 3.7% | 95.13 ± 1.6% | 443.43 ± 6.8% | 949.75 ± 0.6% | 6390.32 ± 1.2% | 422.82 ± 0.3% | 0.94 | 1.00 | 4.44 | 0.95 |
| class: a word that ends in ing | 9 | 513.65 ± 1.3% | 575.30 ± 0.8% | 1008.86 ± 0.5% | 114.57 ± 7.1% | 606.53 ± 28.7% | 1414.54 ± 2.1% | 15296.64 ± 0.3% | 511.50 ± 1.5% | 0.89 | 1.00 | 4.48 | 0.85 |
| class: a word in capitals | 16 | 447.14 ± 0.3% | 480.84 ± 5.9% | 784.49 ± 0.8% | 121.98 ± 1.0% | 638.47 ± 1.1% | 1321.01 ± 1.0% | 8373.91 ± 3.3% | 446.50 ± 2.7% | 0.93 | 1.00 | 3.67 | 0.70 |
| class: a number | 6 | 564.16 ± 0.7% | 616.08 ± 0.3% | 1169.57 ± 0.6% | 36.48 ± 2.1% | 1153.03 ± 1.9% | 2186.95 ± 3.5% | 20456.74 ± 0.6% | 562.15 ± 3.1% | 0.92 | 1.00 | 15.46 | 0.49 |
| class: two capitalized words, second text | 23 | 415.33 ± 8.8% | 442.25 ± 1.9% | 633.47 ± 3.2% | 94.74 ± 0.5% | 438.29 ± 4.1% | 970.85 ± 1.9% | 6397.58 ± 0.3% | 422.05 ± 0.3% | 0.94 | 0.98 | 4.38 | 0.95 |
| other: a word between two words | 13 | 507.06 ± 0.4% | 522.22 ± 0.3% | 813.58 ± 1.1% | 123.33 ± 0.6% | 427.76 ± 3.9% | 1014.04 ± 2.9% | 14086.06 ± 12.7% | 506.86 ± 0.2% | 0.97 | 1.00 | 4.11 | 1.19 |
| other: a number before a unit, second text | 15 | 357.18 ± 12.3% | 390.17 ± 0.4% | 539.82 ± 0.4% | 33.74 ± 1.1% | 545.73 ± 1.9% | 1122.77 ± 4.6% | 13816.80 ± 13.6% | 356.34 ± 21.1% | 0.92 | 1.00 | 10.58 | 0.65 |
| other: a heading's start tag | 13 | 329.49 ± 4.1% | 335.30 ± 16.4% | 440.08 ± 5.9% | 34.63 ± 11.9% | 521.67 ± 6.1% | 1078.46 ± 1.4% | 16417.89 ± 0.6% | 329.78 ± 0.5% | 0.98 | 1.00 | 9.51 | 0.63 |
| other: a whole word | 11 | 511.75 ± 0.6% | 541.62 ± 0.4% | 869.72 ± 0.4% | 111.31 ± 1.0% | 493.33 ± 3.8% | 1031.19 ± 1.1% | 20853.33 ± 0.8% | 511.65 ± 7.5% | 0.94 | 1.00 | 4.60 | 1.04 |
| other: a line's first word, second text | 17 | 486.30 ± 9.1% | 509.09 ± 1.0% | 833.10 ± 0.6% | 114.97 ± 1.7% | 580.07 ± 38.3% | refused | refused | 486.19 ± 58.0% | 0.96 | 1.00 | 4.23 | 0.84 |
| other: fourteen octets before an x | 16 | 87.19 ± 0.6% | 124.92 ± 0.4% | 143.20 ± 3.3% | 14.08 ± 1.0% | 391.65 ± 4.7% | 450.02 ± 1.0% | 11729.45 ± 1.0% | 87.44 ± 8.0% | 0.70 | 1.00 | 6.19 | 0.22 |
| other: a Greek word | 8 | 381.84 ± 0.9% | 508.03 ± 0.1% | 838.46 ± 3.0% | 45.33 ± 8.4% | 1114.66 ± 16.0% | 2142.24 ± 0.6% | refused | 381.90 ± 0.5% | 0.75 | 1.00 | 8.42 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20801.62 ± 3.9% | not timed | not timed | 26599.88 ± 16.4% | 1919.14 ± 13.4% | not timed | not timed | 20822.22 ± 2.3% | | 1.00 | 0.78 | 10.84 |
| 01-literal/sherlock-casei-en | 522 | 4651.74 ± 2.1% | not timed | not timed | 7041.32 ± 1.7% | 28.44 ± 3.3% | not timed | not timed | 4643.44 ± 2.0% | | 1.00 | 0.66 | 163.59 |
| 01-literal/sherlock-ru | 724 | 23066.38 ± 3.2% | not timed | not timed | 27974.93 ± 1.1% | 1061.87 ± 7.3% | not timed | not timed | 23098.68 ± 1.1% | | 1.00 | 0.82 | 21.72 |
| 01-literal/sherlock-casei-ru | 746 | 7277.10 ± 12.6% | not timed | not timed | 5534.89 ± 0.2% | 30.49 ± 0.4% | not timed | not timed | 7255.98 ± 0.2% | | 1.00 | 1.31 | 238.67 |
| 01-literal/sherlock-zh | 30 | 41816.32 ± 1.2% | not timed | not timed | 36890.73 ± 13.0% | 1262.22 ± 0.9% | not timed | not timed | 41778.71 ± 2.3% | | 1.00 | 1.13 | 33.13 |
| 02-literal-alternate/sherlock-en | 714 | 9565.00 ± 18.5% | not timed | not timed | 8929.26 ± 5.7% | 14.17 ± 18.8% | not timed | not timed | 9564.57 ± 0.5% | | 1.00 | 1.07 | 675.15 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1728.90 ± 0.3% | not timed | not timed | 1822.61 ± 0.9% | 9.52 ± 0.5% | not timed | not timed | 1707.53 ± 0.7% | | 1.01 | 0.95 | 181.59 |
| 02-literal-alternate/sherlock-ru | 899 | 5927.54 ± 0.6% | not timed | not timed | 4277.59 ± 0.2% | 19.17 ± 0.3% | not timed | not timed | 5905.72 ± 0.3% | | 1.00 | 1.39 | 309.18 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1798.53 ± 0.2% | not timed | not timed | 1040.37 ± 4.9% | 8.45 ± 1.9% | not timed | not timed | 1790.95 ± 5.6% | | 1.00 | 1.73 | 212.77 |
| 02-literal-alternate/sherlock-zh | 207 | 13726.09 ± 16.6% | not timed | not timed | 10266.27 ± 0.7% | 27.09 ± 2.5% | not timed | not timed | 13717.74 ± 0.6% | | 1.00 | 1.34 | 506.64 |
| 03-date/ascii | 111817 | 99.73 ± 3.2% | not timed | not timed | 85.10 ± 10.5% | 0.18 ± 3.0% | not timed | not timed | 99.73 ± 1.1% | | 1.00 | 1.17 | 563.51 |
| 04-ruff-noqa/real | 84 | 546.37 ± 0.5% | not timed | not timed | 424.38 ± 1.2% | 16.23 ± 2.0% | not timed | not timed | 544.67 ± 17.3% | | 1.00 | 1.29 | 33.67 |
| 04-ruff-noqa/tweaked | 44 | 483.69 ± 0.8% | not timed | not timed | 416.62 ± 0.4% | 294.48 ± 0.4% | not timed | not timed | 482.55 ± 0.3% | | 1.00 | 1.16 | 1.64 |
| 05-lexer-veryl/single | 124800 | 2.73 ± 1.8% | not timed | not timed | 4.25 ± 2.7% | 0.21 ± 7.0% | not timed | not timed | 2.72 ± 3.9% | | 1.00 | 0.64 | 12.98 |
| 06-cloud-flare-redos/original | 107 | 230.92 ± 3.2% | not timed | not timed | 190.64 ± 2.0% | 19.79 ± 0.3% | not timed | not timed | 230.60 ± 2.8% | | 1.00 | 1.21 | 11.67 |
| 06-cloud-flare-redos/simplified-short | 102 | 220.30 ± 0.8% | not timed | not timed | 192.39 ± 0.4% | 20.65 ± 0.2% | not timed | not timed | 220.26 ± 9.5% | | 1.00 | 1.15 | 10.67 |
| 06-cloud-flare-redos/simplified-long | 10000 | 247.02 ± 0.7% | not timed | not timed | 211.24 ± 0.3% | 24.16 ± 1.2% | not timed | not timed | 246.90 ± 0.1% | | 1.00 | 1.17 | 10.22 |
| 07-unicode-character-data/parse-line | 558784 | 196.37 ± 3.4% | not timed | not timed | 161.24 ± 0.4% | 36.53 ± 3.2% | not timed | not timed | 192.17 ± 1.8% | | 1.02 | 1.22 | 5.38 |
| 08-words/all-english | 56691 | 91.22 ± 13.7% | not timed | not timed | 73.81 ± 1.0% | 10.23 ± 8.7% | not timed | not timed | 90.66 ± 0.4% | | 1.01 | 1.24 | 8.92 |
| 08-words/long-english | 839 | 801.22 ± 1.6% | not timed | not timed | 508.88 ± 1.9% | 25.49 ± 2.7% | not timed | not timed | 799.28 ± 1.1% | | 1.00 | 1.57 | 31.44 |
| 09-aws-keys/full | 0 | 413.03 ± 0.2% | not timed | not timed | 446.32 ± 0.4% | 54.77 ± 0.8% | not timed | not timed | 424.09 ± 1.6% | | 0.97 | 0.93 | 7.54 |
| 09-aws-keys/quick | 0 | 825.17 ± 0.3% | not timed | not timed | 805.45 ± 0.8% | 329.75 ± 0.4% | not timed | not timed | 821.60 ± 0.1% | | 1.00 | 1.02 | 2.50 |
| 10-bounded-repeat/letters-en | 1833 | 490.92 ± 6.2% | not timed | not timed | 430.74 ± 1.2% | 16.79 ± 9.0% | not timed | not timed | 489.81 ± 31.4% | | 1.00 | 1.14 | 29.24 |
| 10-bounded-repeat/letters-ru | 3475 | 318.39 ± 0.3% | not timed | not timed | 408.01 ± 0.4% | 18.09 ± 17.8% | not timed | not timed | 318.00 ± 3.9% | | 1.00 | 0.78 | 17.60 |
| 10-bounded-repeat/context | 53 | 65.92 ± 0.6% | not timed | not timed | 56.24 ± 1.3% | 16.80 ± 0.8% | not timed | not timed | 65.99 ± 4.0% | | 1.00 | 1.17 | 3.92 |
| 10-bounded-repeat/capitals | 11 | 845.65 ± 1.3% | not timed | not timed | 533.12 ± 0.2% | 30.90 ± 4.9% | not timed | not timed | 844.12 ± 0.9% | | 1.00 | 1.59 | 27.37 |
| 11-unstructured-to-json/extract | 600 | 35.89 ± 0.4% | not timed | not timed | 61.99 ± 1.1% | 39.51 ± 15.6% | not timed | not timed | 35.78 ± 1.1% | | 1.00 | 0.58 | 0.91 |
| 12-dictionary/single | 1 | 462.28 ± 2.3% | not timed | not timed | 443.38 ± 0.2% | 0.31 ± 5.3% | not timed | not timed | 465.03 ± 0.5% | | 0.99 | 1.04 | 1482.86 |
| 14-quadratic/1x | 100 | 10.06 ± 0.5% | not timed | not timed | 9.08 ± 2.2% | 0.80 ± 9.5% | not timed | not timed | 10.05 ± 1.3% | | 1.00 | 1.11 | 12.64 |
| 14-quadratic/2x | 200 | 6.30 ± 1.2% | not timed | not timed | 4.92 ± 2.6% | 0.43 ± 2.1% | not timed | not timed | 6.29 ± 0.4% | | 1.00 | 1.28 | 14.72 |
| 14-quadratic/10x | 1000 | 1.51 ± 0.3% | not timed | not timed | 1.05 ± 0.2% | 0.09 ± 4.5% | not timed | not timed | 1.50 ± 4.4% | | 1.00 | 1.43 | 16.21 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.32 ± 7.1% | not timed | not timed | 0.39 ± 1.0% | 0.46 ± 3.1% | not timed | not timed | 1.32 ± 1.2% | | 1.00 | 3.44 | 2.88 |
| 04-ruff-noqa/compile-real | 1 | 79.45 ± 1.3% | not timed | not timed | 12.97 ± 1.4% | 118.21 ± 5.1% | not timed | not timed | 78.37 ± 1.6% | | 1.01 | 6.13 | 0.67 |
| 05-lexer-veryl/compile-single | 1 | 12.80 ± 0.6% | not timed | not timed | 2.36 ± 0.7% | 5.56 ± 5.2% | not timed | not timed | 12.72 ± 11.0% | | 1.01 | 5.43 | 2.30 |
| 07-unicode-character-data/compile | 1 | 49.95 ± 0.6% | not timed | not timed | 24.06 ± 0.5% | 30.90 ± 3.6% | not timed | not timed | 49.99 ± 1.3% | | 1.00 | 2.08 | 1.62 |
| 09-aws-keys/compile-full | 1 | 34.73 ± 0.3% | not timed | not timed | 7.47 ± 7.5% | 19.70 ± 13.7% | not timed | not timed | 34.28 ± 14.0% | | 1.01 | 4.65 | 1.76 |
| 09-aws-keys/compile-quick | 1 | 159.29 ± 0.9% | not timed | not timed | 45.05 ± 0.8% | 113.21 ± 9.0% | not timed | not timed | 157.89 ± 1.8% | | 1.01 | 3.54 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 10.46 ± 11.7% | not timed | not timed | 11.52 ± 0.4% | 14.84 ± 6.1% | not timed | not timed | 10.36 ± 4.6% | | 1.01 | 0.91 | 0.71 |
| 10-bounded-repeat/compile-capitals | 1 | 74.12 ± 17.3% | not timed | not timed | 8.90 ± 0.9% | 21.85 ± 2.3% | not timed | not timed | 72.77 ± 18.7% | | 1.02 | 8.33 | 3.39 |
| 11-unstructured-to-json/compile | 1 | 76.11 ± 10.4% | not timed | not timed | 36.50 ± 2.6% | 56.57 ± 6.0% | not timed | not timed | 73.23 ± 2.3% | | 1.04 | 2.09 | 1.35 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.3% | not timed | not timed | 0.07 ± 3.5% | 0.08 ± 18.8% | not timed | not timed | 0.29 ± 2.8% | | 1.00 | 4.39 | 3.43 |

