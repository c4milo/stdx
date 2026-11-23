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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127359545 |
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
| literal: a word | 217 | 33063.16 ± 2.8% | 842.83 ± 0.2% | 19.80 ± 5.3% | 31194.74 ± 1.0% | 8940.57 ± 7.9% | 10.79 ± 0.2% | 76.78 ± 1.2% | 32631.71 ± 4.2% | 39.23 | 1.01 | 1.06 | 3.70 |
| literal: a word that is not there | 0 | 49590.40 ± 5.2% | 850.11 ± 4.3% | 19.60 ± 3.8% | 39640.34 ± 0.8% | 30152.49 ± 1.2% | 10.69 ± 0.3% | 72.95 ± 7.0% | 48960.44 ± 18.2% | 58.33 | 1.01 | 1.25 | 1.64 |
| literal: one of four words | 661 | 10997.66 ± 1.1% | 823.05 ± 0.3% | 10.94 ± 2.0% | 9120.68 ± 0.7% | 19.10 ± 1.0% | 3.99 ± 0.4% | 6.68 ± 0.5% | 11026.29 ± 1.6% | 13.36 | 1.00 | 1.21 | 575.91 |
| literal: a word in any case | 217 | 26022.69 ± 3.6% | 841.84 ± 0.2% | 14.80 ± 1.7% | 9255.25 ± 0.2% | 37.03 ± 1.8% | refused | differs | 25675.65 ± 3.1% | 30.91 | 1.01 | 2.81 | 702.80 |
| literal: an href attribute | 33 | 27120.35 ± 4.2% | 847.68 ± 1.4% | 18.22 ± 2.7% | 26714.05 ± 3.0% | 2060.27 ± 2.9% | 8.21 ± 1.2% | 61.92 ± 1.3% | 26650.95 ± 0.7% | 31.99 | 1.02 | 1.02 | 13.16 |
| literal: a word, second text | 123 | 34372.78 ± 1.2% | 845.34 ± 0.2% | 19.68 ± 5.5% | 32178.22 ± 0.7% | 7289.75 ± 6.6% | 11.92 ± 0.3% | 66.65 ± 1.0% | 33992.87 ± 1.6% | 40.66 | 1.01 | 1.07 | 4.72 |
| class: two capitalized words | 1331 | 785.56 ± 0.2% | 787.31 ± 0.1% | 18.75 ± 2.9% | 505.91 ± 0.2% | 34.37 ± 0.3% | 9.29 ± 0.2% | 55.65 ± 0.2% | 786.22 ± 0.2% | 1.00 | 1.00 | 1.55 | 22.86 |
| class: a word that ends in ing | 3399 | 715.85 ± 0.4% | 715.56 ± 0.2% | 12.96 ± 1.9% | 472.67 ± 0.4% | 25.60 ± 1.2% | 5.34 ± 0.1% | 17.23 ± 1.8% | 715.46 ± 0.2% | 1.00 | 1.00 | 1.51 | 27.97 |
| class: a word in capitals | 2332 | 986.18 ± 0.6% | 768.97 ± 0.2% | 19.63 ± 4.2% | 497.61 ± 0.5% | 36.61 ± 11.0% | 10.33 ± 0.2% | 76.48 ± 0.3% | 986.77 ± 0.3% | 1.28 | 1.00 | 1.98 | 26.93 |
| class: a number | 8288 | 1426.57 ± 24.8% | 658.00 ± 0.4% | 19.24 ± 2.9% | 1466.21 ± 0.3% | 36.49 ± 8.2% | 0.33 ± 0.2% | 55.69 ± 10.3% | 1426.76 ± 0.2% | 2.17 | 1.00 | 0.97 | 39.10 |
| class: two capitalized words, second text | 5359 | 593.69 ± 0.3% | 593.72 ± 0.4% | 17.06 ± 1.7% | 417.76 ± 1.5% | 30.09 ± 7.7% | 10.52 ± 0.1% | 51.67 ± 0.3% | 593.08 ± 0.3% | 1.00 | 1.00 | 1.42 | 19.73 |
| other: a word between two words | 6104 | 643.11 ± 0.3% | 619.27 ± 0.1% | 16.74 ± 1.4% | 698.55 ± 1.0% | 100.20 ± 4.6% | 7.26 ± 0.5% | 56.87 ± 0.9% | 642.54 ± 0.4% | 1.04 | 1.00 | 0.92 | 6.42 |
| other: a number before a unit, second text | 1481 | 6624.72 ± 5.3% | 793.14 ± 0.2% | 18.47 ± 9.1% | 6413.51 ± 0.8% | 35.13 ± 18.3% | 10.93 ± 1.2% | 55.11 ± 0.4% | 6587.81 ± 1.5% | 8.35 | 1.01 | 1.03 | 188.58 |
| other: a heading's start tag | 110 | 18716.07 ± 9.1% | 841.38 ± 0.3% | 19.14 ± 1.5% | 2007.25 ± 0.2% | 1482.18 ± 0.4% | 10.01 ± 2.2% | 72.69 ± 0.5% | 18512.41 ± 4.0% | 22.24 | 1.01 | 9.32 | 12.63 |
| other: a whole word | 217 | 22487.93 ± 1.4% | 842.51 ± 1.1% | 19.36 ± 4.9% | 22641.08 ± 3.0% | 39.74 ± 5.6% | 9.46 ± 2.3% | 46.91 ± 2.8% | 22315.49 ± 7.6% | 26.69 | 1.01 | 0.99 | 565.84 |
| other: a line's first word, second text | 3716 | 1718.06 ± 0.4% | 705.31 ± 0.3% | 22.05 ± 4.5% | 1705.91 ± 8.7% | 53.31 ± 1.8% | refused | refused | 1711.08 ± 0.5% | 2.44 | 1.00 | 1.01 | 32.23 |
| other: fourteen octets before an x | 87 | 25327.28 ± 1.6% | 193.69 ± 1.7% | 5.11 ± 0.4% | 2930.21 ± 1.5% | 9.01 ± 0.5% | differs | 15.42 ± 9.4% | 25018.98 ± 0.5% | 130.76 | 1.01 | 8.64 | 2810.63 |
| other: a Greek word | 21815 | 396.95 ± 1.1% | 291.26 ± 0.9% | 23.37 ± 5.6% | 265.16 ± 0.6% | 42.73 ± 5.8% | differs | refused | 395.04 ± 0.5% | 1.36 | 1.00 | 1.50 | 9.29 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.59 ± 1.6% | 24.37 ± 6.1% | 0.71 ± 1.6% | 16.83 ± 0.6% | 2.16 ± 0.7% | differs | 3.65 ± 0.9% | 24.78 ± 0.7% | 1.01 | 0.99 | 1.46 | 11.40 |
| a UUID | 32895 | 20.55 ± 4.3% | 20.62 ± 0.4% | 0.55 ± 8.1% | 12.89 ± 0.3% | 2.53 ± 2.2% | 0.44 ± 0.3% | 3.09 ± 18.6% | 19.83 ± 24.0% | 1.00 | 1.04 | 1.59 | 8.12 |
| an IPv4 address | 33176 | 34.01 ± 1.8% | 33.95 ± 1.1% | 1.76 ± 0.4% | 24.15 ± 4.4% | 5.78 ± 0.9% | differs | 3.38 ± 0.3% | 34.47 ± 1.1% | 1.00 | 0.99 | 1.41 | 5.89 |
| a date and time | 32954 | 30.46 ± 0.2% | 29.88 ± 0.4% | 1.27 ± 0.3% | 17.89 ± 3.2% | 6.69 ± 11.2% | 0.69 ± 0.3% | 6.20 ± 0.6% | 30.44 ± 0.7% | 1.02 | 1.00 | 1.70 | 4.55 |
| a field path | 32606 | 27.38 ± 0.4% | 27.32 ± 0.6% | 0.85 ± 0.5% | 19.34 ± 6.2% | 2.96 ± 11.1% | differs | 2.48 ± 0.7% | 27.39 ± 0.2% | 1.00 | 1.00 | 1.42 | 9.26 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.28 ± 2.8% | 8.33 ± 2.7% | 8.29 ± 2.4% | 10.69 ± 1.3% | 4.69 ± 3.8% | 0.62 ± 0.7% | none | 8.51 ± 18.9% | 0.99 | 0.97 | 0.77 | 1.77 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 185.49 ± 0.1% | 185.61 ± 7.0% | 216.04 ± 0.7% | 79.56 ± 3.0% | 183.18 ± 20.9% | 536.72 ± 2.4% | 3997.52 ± 1.3% | 185.39 ± 7.6% | 1.00 | 1.00 | 2.33 | 1.01 |
| a UUID | 62 | 120.89 ± 0.7% | 121.07 ± 0.1% | 133.64 ± 0.3% | 46.44 ± 1.1% | 89.81 ± 0.7% | 195.97 ± 10.6% | 4100.57 ± 0.6% | 120.77 ± 0.2% | 1.00 | 1.00 | 2.60 | 1.35 |
| an IPv4 address | 29 | 396.55 ± 0.7% | 398.22 ± 1.3% | 559.21 ± 1.7% | 69.02 ± 1.3% | 114.90 ± 18.0% | 326.92 ± 1.5% | 7188.77 ± 2.7% | 395.90 ± 8.7% | 1.00 | 1.00 | 5.75 | 3.45 |
| a date and time | 56 | 285.82 ± 0.5% | 286.88 ± 0.5% | 358.85 ± 0.6% | 69.08 ± 1.9% | 123.52 ± 1.2% | 373.13 ± 0.9% | 4241.04 ± 0.5% | 285.28 ± 0.4% | 1.00 | 1.00 | 4.14 | 2.31 |
| a field path | 39 | 181.43 ± 0.2% | 181.78 ± 0.6% | 209.38 ± 6.9% | 74.34 ± 1.9% | 174.27 ± 11.1% | 598.10 ± 4.1% | 4832.48 ± 1.2% | 181.36 ± 0.3% | 1.00 | 1.00 | 2.44 | 1.04 |
| literal: a word | 7 | 592.57 ± 1.1% | 628.67 ± 0.3% | 1101.02 ± 14.0% | 492.00 ± 5.6% | 583.63 ± 2.4% | 1257.86 ± 2.3% | 25212.97 ± 0.2% | 592.48 ± 3.1% | 0.94 | 1.00 | 1.20 | 1.02 |
| literal: a word that is not there | 8 | 569.49 ± 0.6% | 609.86 ± 0.8% | 1042.44 ± 3.1% | 448.62 ± 11.9% | 562.71 ± 0.9% | 1180.18 ± 0.5% | 23968.45 ± 0.2% | 568.24 ± 0.6% | 0.93 | 1.00 | 1.27 | 1.01 |
| literal: one of four words | 26 | 222.54 ± 1.7% | 363.33 ± 0.8% | 486.48 ± 10.8% | 41.92 ± 2.0% | 219.80 ± 2.3% | 454.82 ± 1.9% | 11426.27 ± 1.3% | 222.64 ± 0.4% | 0.61 | 1.00 | 5.31 | 1.01 |
| literal: a word in any case | 11 | 453.27 ± 0.3% | 478.45 ± 8.7% | 724.51 ± 0.3% | 14.48 ± 2.2% | 605.17 ± 3.7% | refused | 19287.70 ± 5.0% | 452.20 ± 1.2% | 0.95 | 1.00 | 31.30 | 0.75 |
| literal: an href attribute | 12 | 309.78 ± 0.5% | 320.89 ± 0.7% | 414.44 ± 1.3% | 37.59 ± 2.7% | 430.33 ± 2.8% | 963.92 ± 0.5% | 18419.98 ± 1.0% | 309.05 ± 1.5% | 0.97 | 1.00 | 8.24 | 0.72 |
| literal: a word, second text | 10 | 514.14 ± 3.7% | 569.33 ± 2.8% | 937.60 ± 3.6% | 407.01 ± 12.5% | 476.94 ± 5.0% | 1009.48 ± 4.7% | 21199.49 ± 2.5% | 522.14 ± 3.2% | 0.90 | 0.98 | 1.26 | 1.08 |
| class: two capitalized words | 23 | 418.68 ± 1.9% | 448.21 ± 2.8% | 644.99 ± 3.7% | 92.98 ± 2.9% | 440.81 ± 8.7% | 958.55 ± 1.1% | 6389.06 ± 1.0% | 419.62 ± 0.5% | 0.93 | 1.00 | 4.50 | 0.95 |
| class: a word that ends in ing | 9 | 509.03 ± 0.8% | 570.06 ± 0.8% | 998.32 ± 0.8% | 111.52 ± 0.4% | 616.80 ± 2.3% | 1433.43 ± 1.2% | 13859.35 ± 2.4% | 508.37 ± 0.5% | 0.89 | 1.00 | 4.56 | 0.83 |
| class: a word in capitals | 16 | 443.16 ± 1.1% | 480.19 ± 0.3% | 782.73 ± 8.3% | 119.65 ± 0.8% | 641.83 ± 0.6% | 1318.63 ± 5.4% | 8381.33 ± 0.9% | 444.11 ± 0.4% | 0.92 | 1.00 | 3.70 | 0.69 |
| class: a number | 6 | 564.22 ± 0.4% | 617.54 ± 0.9% | 1174.40 ± 0.9% | 36.26 ± 11.3% | 1148.50 ± 2.6% | 2209.77 ± 1.7% | 20413.99 ± 0.3% | 564.65 ± 1.2% | 0.91 | 1.00 | 15.56 | 0.49 |
| class: two capitalized words, second text | 23 | 416.20 ± 1.7% | 448.06 ± 2.6% | 646.06 ± 4.2% | 92.70 ± 1.2% | 448.24 ± 3.2% | 926.74 ± 2.3% | 6393.81 ± 0.7% | 419.96 ± 0.5% | 0.93 | 0.99 | 4.49 | 0.93 |
| other: a word between two words | 13 | 504.88 ± 0.3% | 520.81 ± 1.0% | 805.21 ± 1.8% | 121.04 ± 1.2% | 431.90 ± 0.6% | 1008.62 ± 2.2% | 13894.04 ± 3.0% | 504.50 ± 0.6% | 0.97 | 1.00 | 4.17 | 1.17 |
| other: a number before a unit, second text | 15 | 354.28 ± 4.0% | 388.50 ± 36.3% | 536.10 ± 12.6% | 33.23 ± 0.5% | 533.42 ± 2.5% | 1080.91 ± 1.0% | 13906.61 ± 0.4% | 356.09 ± 1.2% | 0.91 | 0.99 | 10.66 | 0.66 |
| other: a heading's start tag | 13 | 318.07 ± 2.9% | 323.22 ± 0.9% | 419.06 ± 0.4% | 35.54 ± 7.4% | 523.32 ± 1.3% | 1062.81 ± 0.6% | 16275.01 ± 17.5% | 317.52 ± 9.7% | 0.98 | 1.00 | 8.95 | 0.61 |
| other: a whole word | 11 | 511.16 ± 0.6% | 538.80 ± 2.2% | 864.02 ± 1.6% | 109.81 ± 0.3% | 503.53 ± 2.0% | 1034.27 ± 1.7% | 20303.82 ± 17.9% | 511.26 ± 0.5% | 0.95 | 1.00 | 4.65 | 1.02 |
| other: a line's first word, second text | 17 | 487.91 ± 1.2% | 509.74 ± 0.5% | 831.70 ± 0.4% | 112.17 ± 1.3% | 586.32 ± 1.5% | refused | refused | 488.41 ± 0.4% | 0.96 | 1.00 | 4.35 | 0.83 |
| other: fourteen octets before an x | 16 | 87.41 ± 1.0% | 124.43 ± 0.2% | 143.00 ± 11.5% | 14.19 ± 1.7% | 394.49 ± 8.8% | 452.46 ± 0.7% | 11856.03 ± 0.4% | 87.94 ± 2.1% | 0.70 | 0.99 | 6.16 | 0.22 |
| other: a Greek word | 8 | 380.43 ± 0.9% | 509.41 ± 0.3% | 831.12 ± 1.0% | 46.18 ± 2.0% | 1128.68 ± 1.6% | 2084.45 ± 0.8% | refused | 380.73 ± 0.5% | 0.75 | 1.00 | 8.24 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 18662.01 ± 1.7% | not timed | not timed | 27083.39 ± 0.5% | 1868.54 ± 19.2% | not timed | not timed | 18604.72 ± 0.7% | | 1.00 | 0.69 | 9.99 |
| 01-literal/sherlock-casei-en | 522 | 4554.32 ± 0.7% | not timed | not timed | 7032.57 ± 0.7% | 28.37 ± 1.0% | not timed | not timed | 4516.18 ± 0.4% | | 1.01 | 0.65 | 160.56 |
| 01-literal/sherlock-ru | 724 | 20802.17 ± 1.8% | not timed | not timed | 27551.76 ± 1.8% | 1037.69 ± 9.8% | not timed | not timed | 20735.26 ± 1.5% | | 1.00 | 0.76 | 20.05 |
| 01-literal/sherlock-casei-ru | 746 | 7062.87 ± 0.2% | not timed | not timed | 5485.61 ± 0.7% | 30.28 ± 2.1% | not timed | not timed | 7020.63 ± 0.4% | | 1.01 | 1.29 | 233.27 |
| 01-literal/sherlock-zh | 30 | 42962.53 ± 1.6% | not timed | not timed | 36862.39 ± 12.5% | 1262.23 ± 1.2% | not timed | not timed | 42351.40 ± 0.7% | | 1.01 | 1.17 | 34.04 |
| 02-literal-alternate/sherlock-en | 714 | 8899.97 ± 12.8% | not timed | not timed | 8918.23 ± 29.0% | 13.70 ± 1.8% | not timed | not timed | 8870.91 ± 2.3% | | 1.00 | 1.00 | 649.75 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1712.35 ± 0.3% | not timed | not timed | 1819.49 ± 0.9% | 9.25 ± 16.9% | not timed | not timed | 1691.08 ± 0.4% | | 1.01 | 0.94 | 185.21 |
| 02-literal-alternate/sherlock-ru | 899 | 5755.54 ± 0.4% | not timed | not timed | 4259.28 ± 3.8% | 17.95 ± 0.5% | not timed | not timed | 5763.80 ± 3.7% | | 1.00 | 1.35 | 320.57 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1781.46 ± 7.1% | not timed | not timed | 1038.85 ± 0.2% | 8.38 ± 6.2% | not timed | not timed | 1777.40 ± 0.4% | | 1.00 | 1.71 | 212.49 |
| 02-literal-alternate/sherlock-zh | 207 | 13406.61 ± 0.5% | not timed | not timed | 10442.87 ± 1.7% | 24.72 ± 1.0% | not timed | not timed | 13405.21 ± 0.3% | | 1.00 | 1.28 | 542.24 |
| 03-date/ascii | 111817 | 84.69 ± 0.3% | not timed | not timed | 85.17 ± 2.4% | 0.18 ± 3.5% | not timed | not timed | 84.23 ± 6.4% | | 1.01 | 0.99 | 483.67 |
| 04-ruff-noqa/real | 84 | 545.64 ± 0.5% | not timed | not timed | 427.08 ± 0.4% | 16.19 ± 1.7% | not timed | not timed | 546.04 ± 0.4% | | 1.00 | 1.28 | 33.71 |
| 04-ruff-noqa/tweaked | 44 | 483.53 ± 14.7% | not timed | not timed | 415.01 ± 9.6% | 294.70 ± 0.4% | not timed | not timed | 483.13 ± 0.1% | | 1.00 | 1.17 | 1.64 |
| 05-lexer-veryl/single | 124800 | 2.70 ± 21.7% | not timed | not timed | 4.04 ± 10.9% | 0.22 ± 3.1% | not timed | not timed | 2.71 ± 16.5% | | 0.99 | 0.67 | 12.53 |
| 06-cloud-flare-redos/original | 107 | 219.98 ± 0.2% | not timed | not timed | 190.87 ± 16.1% | 20.85 ± 0.9% | not timed | not timed | 220.81 ± 4.0% | | 1.00 | 1.15 | 10.55 |
| 06-cloud-flare-redos/simplified-short | 102 | 211.91 ± 3.2% | not timed | not timed | 192.55 ± 0.2% | 21.98 ± 0.9% | not timed | not timed | 211.63 ± 1.2% | | 1.00 | 1.10 | 9.64 |
| 06-cloud-flare-redos/simplified-long | 10000 | 246.79 ± 0.1% | not timed | not timed | 211.75 ± 1.5% | 24.17 ± 1.1% | not timed | not timed | 246.70 ± 0.4% | | 1.00 | 1.17 | 10.21 |
| 07-unicode-character-data/parse-line | 558784 | 192.75 ± 0.2% | not timed | not timed | 156.28 ± 1.5% | 37.58 ± 7.4% | not timed | not timed | 194.17 ± 3.0% | | 0.99 | 1.23 | 5.13 |
| 08-words/all-english | 56691 | 79.24 ± 0.5% | not timed | not timed | 74.20 ± 0.6% | 10.37 ± 10.9% | not timed | not timed | 78.09 ± 0.7% | | 1.01 | 1.07 | 7.64 |
| 08-words/long-english | 839 | 804.00 ± 0.3% | not timed | not timed | 515.65 ± 0.3% | 26.43 ± 0.6% | not timed | not timed | 804.21 ± 0.2% | | 1.00 | 1.56 | 30.42 |
| 09-aws-keys/full | 0 | 424.78 ± 0.4% | not timed | not timed | 417.38 ± 0.8% | 55.07 ± 0.6% | not timed | not timed | 424.46 ± 0.5% | | 1.00 | 1.02 | 7.71 |
| 09-aws-keys/quick | 0 | 826.34 ± 0.5% | not timed | not timed | 801.40 ± 0.7% | 330.36 ± 5.7% | not timed | not timed | 823.37 ± 1.5% | | 1.00 | 1.03 | 2.50 |
| 10-bounded-repeat/letters-en | 1833 | 464.08 ± 0.7% | not timed | not timed | 431.84 ± 0.2% | 17.02 ± 2.0% | not timed | not timed | 462.75 ± 1.1% | | 1.00 | 1.07 | 27.27 |
| 10-bounded-repeat/letters-ru | 3475 | 304.37 ± 0.3% | not timed | not timed | 408.75 ± 0.8% | 19.03 ± 14.3% | not timed | not timed | 303.84 ± 2.1% | | 1.00 | 0.74 | 15.99 |
| 10-bounded-repeat/context | 53 | 65.97 ± 1.6% | not timed | not timed | 56.26 ± 1.9% | 16.96 ± 1.2% | not timed | not timed | 65.54 ± 1.2% | | 1.01 | 1.17 | 3.89 |
| 10-bounded-repeat/capitals | 11 | 844.11 ± 0.4% | not timed | not timed | 533.71 ± 0.4% | 30.99 ± 0.3% | not timed | not timed | 842.36 ± 0.9% | | 1.00 | 1.58 | 27.24 |
| 11-unstructured-to-json/extract | 600 | 35.94 ± 0.4% | not timed | not timed | 61.99 ± 0.8% | 40.93 ± 0.6% | not timed | not timed | 35.96 ± 9.5% | | 1.00 | 0.58 | 0.88 |
| 12-dictionary/single | 1 | 461.23 ± 2.8% | not timed | not timed | 431.12 ± 2.6% | 0.31 ± 2.2% | not timed | not timed | 459.78 ± 3.1% | | 1.00 | 1.07 | 1487.92 |
| 14-quadratic/1x | 100 | 9.23 ± 1.1% | not timed | not timed | 9.13 ± 0.1% | 0.79 ± 19.0% | not timed | not timed | 9.34 ± 1.3% | | 0.99 | 1.01 | 11.71 |
| 14-quadratic/2x | 200 | 5.97 ± 11.8% | not timed | not timed | 4.92 ± 0.2% | 0.43 ± 1.0% | not timed | not timed | 6.03 ± 0.4% | | 0.99 | 1.21 | 13.86 |
| 14-quadratic/10x | 1000 | 1.49 ± 0.1% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 15.4% | not timed | not timed | 1.49 ± 4.2% | | 1.00 | 1.42 | 15.77 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.32 ± 8.0% | not timed | not timed | 0.39 ± 0.5% | 0.48 ± 3.5% | not timed | not timed | 1.31 ± 3.6% | | 1.00 | 3.41 | 2.74 |
| 04-ruff-noqa/compile-real | 1 | 79.59 ± 0.7% | not timed | not timed | 12.92 ± 13.6% | 124.57 ± 2.8% | not timed | not timed | 77.90 ± 1.9% | | 1.02 | 6.16 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 12.58 ± 1.7% | not timed | not timed | 2.36 ± 0.8% | 5.91 ± 2.3% | not timed | not timed | 12.48 ± 10.3% | | 1.01 | 5.33 | 2.13 |
| 07-unicode-character-data/compile | 1 | 50.17 ± 1.6% | not timed | not timed | 23.93 ± 19.6% | 32.93 ± 3.3% | not timed | not timed | 48.93 ± 1.1% | | 1.03 | 2.10 | 1.52 |
| 09-aws-keys/compile-full | 1 | 34.40 ± 0.3% | not timed | not timed | 7.41 ± 1.5% | 19.80 ± 14.7% | not timed | not timed | 33.88 ± 1.7% | | 1.02 | 4.64 | 1.74 |
| 09-aws-keys/compile-quick | 1 | 159.46 ± 0.3% | not timed | not timed | 44.37 ± 3.3% | 117.65 ± 18.1% | not timed | not timed | 157.76 ± 1.7% | | 1.01 | 3.59 | 1.36 |
| 10-bounded-repeat/compile-context | 1 | 10.63 ± 17.4% | not timed | not timed | 11.54 ± 4.9% | 14.94 ± 3.7% | not timed | not timed | 10.57 ± 1.0% | | 1.01 | 0.92 | 0.71 |
| 10-bounded-repeat/compile-capitals | 1 | 73.96 ± 1.4% | not timed | not timed | 8.84 ± 1.2% | 22.39 ± 3.2% | not timed | not timed | 72.78 ± 2.4% | | 1.02 | 8.37 | 3.30 |
| 11-unstructured-to-json/compile | 1 | 76.54 ± 2.5% | not timed | not timed | 35.99 ± 1.8% | 60.34 ± 2.8% | not timed | not timed | 75.69 ± 1.4% | | 1.01 | 2.13 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.4% | not timed | not timed | 0.07 ± 6.1% | 0.08 ± 17.8% | not timed | not timed | 0.29 ± 2.5% | | 1.01 | 4.13 | 3.43 |

