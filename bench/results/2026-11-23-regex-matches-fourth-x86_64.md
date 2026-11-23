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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127331443 |
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
| literal: a word | 217 | 32939.27 ± 3.1% | 842.70 ± 0.2% | 19.91 ± 4.3% | 31142.01 ± 0.9% | 8931.38 ± 12.0% | 10.72 ± 0.5% | 76.59 ± 1.4% | 31919.47 ± 3.6% | 39.09 | 1.03 | 1.06 | 3.69 |
| literal: a word that is not there | 0 | 49088.31 ± 3.9% | 849.79 ± 0.5% | 19.60 ± 3.6% | 39640.45 ± 0.9% | 30067.98 ± 1.5% | 10.67 ± 0.5% | 73.44 ± 43.8% | 48922.63 ± 85.7% | 57.77 | 1.00 | 1.24 | 1.63 |
| literal: one of four words | 661 | 11029.28 ± 3.8% | 824.46 ± 0.1% | 10.89 ± 1.2% | 8925.56 ± 0.5% | 19.34 ± 0.4% | 4.00 ± 0.2% | 6.68 ± 2.5% | 11024.18 ± 7.5% | 13.38 | 1.00 | 1.24 | 570.15 |
| literal: a word in any case | 217 | 25819.66 ± 4.1% | 840.18 ± 0.3% | 14.69 ± 1.2% | 9098.24 ± 0.6% | 37.31 ± 0.2% | refused | differs | 25956.35 ± 3.7% | 30.73 | 0.99 | 2.84 | 692.03 |
| literal: an href attribute | 33 | 27127.87 ± 6.9% | 847.31 ± 0.3% | 18.20 ± 6.0% | 27444.27 ± 0.8% | 2048.56 ± 1.1% | 8.22 ± 0.2% | 61.57 ± 1.6% | 26776.14 ± 1.9% | 32.02 | 1.01 | 0.99 | 13.24 |
| literal: a word, second text | 123 | 33688.74 ± 2.4% | 846.47 ± 0.1% | 19.62 ± 4.0% | 32225.03 ± 3.8% | 7329.42 ± 4.5% | 11.74 ± 0.3% | 66.06 ± 2.3% | 33739.62 ± 4.4% | 39.80 | 1.00 | 1.05 | 4.60 |
| class: two capitalized words | 1331 | 787.10 ± 0.4% | 788.22 ± 0.2% | 18.42 ± 2.2% | 506.54 ± 0.0% | 34.37 ± 6.0% | 9.26 ± 0.5% | 55.76 ± 0.4% | 786.35 ± 0.2% | 1.00 | 1.00 | 1.55 | 22.90 |
| class: a word that ends in ing | 3399 | 716.47 ± 0.9% | 717.00 ± 0.5% | 12.75 ± 6.5% | 472.76 ± 0.3% | 25.56 ± 29.8% | 5.34 ± 0.2% | 17.24 ± 0.3% | 715.81 ± 0.2% | 1.00 | 1.00 | 1.52 | 28.03 |
| class: a word in capitals | 2332 | 987.36 ± 1.6% | 770.70 ± 0.5% | 19.54 ± 1.0% | 497.97 ± 0.1% | 36.75 ± 6.7% | 10.29 ± 0.5% | 76.54 ± 0.3% | 988.71 ± 0.2% | 1.28 | 1.00 | 1.98 | 26.86 |
| class: a number | 8288 | 1426.17 ± 3.4% | 659.49 ± 1.5% | 19.19 ± 3.1% | 1398.00 ± 2.5% | 36.31 ± 6.5% | 0.33 ± 0.4% | 55.87 ± 2.3% | 1426.16 ± 3.1% | 2.16 | 1.00 | 1.02 | 39.28 |
| class: two capitalized words, second text | 5359 | 593.57 ± 0.2% | 592.85 ± 0.6% | 17.09 ± 0.9% | 418.29 ± 0.7% | 30.21 ± 7.3% | 10.46 ± 0.2% | 51.75 ± 0.3% | 594.37 ± 0.3% | 1.00 | 1.00 | 1.42 | 19.65 |
| other: a word between two words | 6104 | 642.39 ± 1.2% | 619.76 ± 0.4% | 16.73 ± 4.1% | 700.00 ± 0.4% | 96.09 ± 15.0% | 7.24 ± 0.3% | 56.84 ± 1.2% | 642.24 ± 0.2% | 1.04 | 1.00 | 0.92 | 6.68 |
| other: a number before a unit, second text | 1481 | 6620.23 ± 1.1% | 792.84 ± 0.1% | 18.57 ± 2.2% | 6465.00 ± 0.2% | 35.09 ± 13.6% | 10.86 ± 0.2% | 55.13 ± 1.0% | 6570.06 ± 3.1% | 8.35 | 1.01 | 1.02 | 188.65 |
| other: a heading's start tag | 110 | 18975.23 ± 2.2% | 840.96 ± 0.2% | 19.09 ± 2.8% | 2009.21 ± 0.3% | 1478.42 ± 4.1% | 9.99 ± 6.3% | 72.78 ± 0.6% | 18851.18 ± 1.3% | 22.56 | 1.01 | 9.44 | 12.83 |
| other: a whole word | 217 | 22621.28 ± 3.5% | 841.89 ± 0.9% | 19.23 ± 8.5% | 22743.85 ± 1.3% | 40.62 ± 10.2% | 9.45 ± 0.2% | 46.79 ± 9.7% | 22625.78 ± 2.7% | 26.87 | 1.00 | 0.99 | 556.93 |
| other: a line's first word, second text | 3716 | 1709.30 ± 0.9% | 705.78 ± 0.1% | 22.13 ± 1.6% | 1705.54 ± 3.7% | 53.28 ± 1.5% | refused | refused | 1714.07 ± 1.4% | 2.42 | 1.00 | 1.00 | 32.08 |
| other: fourteen octets before an x | 87 | 25393.59 ± 1.4% | 196.09 ± 0.3% | 5.11 ± 2.4% | 2809.19 ± 0.4% | 9.01 ± 0.8% | differs | 15.43 ± 10.2% | 25646.83 ± 1.8% | 129.50 | 0.99 | 9.04 | 2819.27 |
| other: a Greek word | 21815 | 397.18 ± 0.8% | 290.40 ± 0.9% | 23.00 ± 6.0% | 265.66 ± 1.1% | 38.44 ± 6.7% | differs | refused | 396.67 ± 1.9% | 1.37 | 1.00 | 1.50 | 10.33 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.78 ± 0.7% | 24.52 ± 6.1% | 0.71 ± 3.6% | 16.81 ± 0.6% | 2.34 ± 0.2% | differs | 3.65 ± 0.9% | 24.74 ± 0.3% | 1.01 | 1.00 | 1.47 | 10.59 |
| a UUID | 32895 | 20.61 ± 4.6% | 20.62 ± 0.4% | 0.54 ± 6.2% | 12.83 ± 0.1% | 2.49 ± 8.1% | 0.44 ± 0.2% | 3.09 ± 9.6% | 20.64 ± 0.2% | 1.00 | 1.00 | 1.61 | 8.28 |
| an IPv4 address | 33176 | 34.13 ± 3.6% | 33.97 ± 2.7% | 1.72 ± 1.9% | 23.92 ± 3.1% | 5.79 ± 0.3% | differs | 3.37 ± 1.4% | 34.50 ± 3.6% | 1.00 | 0.99 | 1.43 | 5.90 |
| a date and time | 32954 | 30.43 ± 0.6% | 30.44 ± 0.8% | 1.26 ± 1.4% | 17.86 ± 0.2% | 6.68 ± 6.6% | 0.76 ± 0.7% | 6.20 ± 0.2% | 29.88 ± 0.1% | 1.00 | 1.02 | 1.70 | 4.55 |
| a field path | 32606 | 27.24 ± 0.9% | 27.34 ± 0.6% | 0.84 ± 0.6% | 19.39 ± 6.1% | 2.94 ± 11.6% | differs | 2.47 ± 2.4% | 27.32 ± 0.3% | 1.00 | 1.00 | 1.40 | 9.28 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.07 ± 3.6% | 8.03 ± 5.5% | 8.02 ± 2.6% | 10.65 ± 2.1% | 4.70 ± 4.1% | 0.61 ± 2.0% | none | 8.06 ± 6.3% | 1.00 | 1.00 | 0.76 | 1.72 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 183.91 ± 7.0% | 184.82 ± 0.4% | 213.82 ± 0.5% | 79.66 ± 3.8% | 181.56 ± 1.0% | 519.88 ± 3.1% | 3975.67 ± 2.6% | 184.40 ± 0.3% | 1.00 | 1.00 | 2.31 | 1.01 |
| a UUID | 62 | 120.62 ± 0.3% | 120.68 ± 1.2% | 133.30 ± 0.2% | 46.36 ± 7.1% | 90.50 ± 1.5% | 196.23 ± 3.2% | 4108.23 ± 0.5% | 120.55 ± 0.1% | 1.00 | 1.00 | 2.60 | 1.33 |
| an IPv4 address | 29 | 395.90 ± 0.6% | 398.32 ± 0.9% | 558.99 ± 1.7% | 69.43 ± 1.1% | 115.41 ± 1.6% | 316.73 ± 2.9% | 7196.08 ± 0.6% | 396.14 ± 0.8% | 0.99 | 1.00 | 5.70 | 3.43 |
| a date and time | 56 | 284.03 ± 0.9% | 286.35 ± 0.6% | 358.47 ± 1.1% | 67.70 ± 1.8% | 124.36 ± 1.1% | 348.58 ± 5.0% | 4243.30 ± 3.1% | 284.06 ± 0.9% | 0.99 | 1.00 | 4.20 | 2.28 |
| a field path | 39 | 180.73 ± 0.4% | 181.34 ± 0.6% | 209.01 ± 0.1% | 74.44 ± 2.1% | 171.88 ± 1.3% | 563.78 ± 7.2% | 4850.86 ± 0.7% | 180.57 ± 0.4% | 1.00 | 1.00 | 2.43 | 1.05 |
| literal: a word | 7 | 593.82 ± 0.5% | 630.19 ± 0.6% | 1112.81 ± 0.2% | 484.87 ± 3.1% | 578.79 ± 3.3% | 1197.55 ± 0.6% | 25122.68 ± 1.5% | 594.45 ± 1.4% | 0.94 | 1.00 | 1.22 | 1.03 |
| literal: a word that is not there | 8 | 571.29 ± 0.5% | 606.39 ± 14.8% | 1051.74 ± 0.5% | 449.06 ± 0.3% | 558.51 ± 3.2% | 1127.53 ± 1.2% | 23814.86 ± 2.6% | 570.14 ± 1.2% | 0.94 | 1.00 | 1.27 | 1.02 |
| literal: one of four words | 26 | 221.16 ± 9.8% | 364.51 ± 0.9% | 490.23 ± 0.5% | 41.59 ± 0.9% | 220.79 ± 1.5% | 443.70 ± 4.2% | 11552.63 ± 1.1% | 220.75 ± 0.5% | 0.61 | 1.00 | 5.32 | 1.00 |
| literal: a word in any case | 11 | 451.52 ± 0.6% | 476.34 ± 0.2% | 721.85 ± 0.6% | 14.35 ± 0.4% | 606.27 ± 1.4% | refused | 19344.46 ± 3.3% | 449.61 ± 9.3% | 0.95 | 1.00 | 31.46 | 0.74 |
| literal: an href attribute | 12 | 319.82 ± 14.6% | 330.20 ± 0.2% | 433.73 ± 0.6% | 36.94 ± 1.4% | 431.49 ± 3.0% | 911.41 ± 10.5% | 18706.29 ± 14.1% | 319.29 ± 0.3% | 0.97 | 1.00 | 8.66 | 0.74 |
| literal: a word, second text | 10 | 527.92 ± 1.2% | 573.11 ± 8.3% | 951.28 ± 3.3% | 402.56 ± 10.9% | 483.22 ± 2.1% | 932.19 ± 9.2% | 21596.05 ± 1.1% | 528.01 ± 0.2% | 0.92 | 1.00 | 1.31 | 1.09 |
| class: two capitalized words | 23 | 422.20 ± 0.7% | 451.00 ± 2.3% | 654.44 ± 1.4% | 93.86 ± 1.0% | 444.17 ± 0.7% | 916.54 ± 1.0% | 6396.12 ± 0.4% | 421.18 ± 1.0% | 0.94 | 1.00 | 4.50 | 0.95 |
| class: a word that ends in ing | 9 | 513.81 ± 0.5% | 575.03 ± 1.2% | 1006.19 ± 0.6% | 111.99 ± 1.4% | 621.73 ± 2.2% | 1380.19 ± 0.4% | 15255.39 ± 2.2% | 514.48 ± 0.5% | 0.89 | 1.00 | 4.59 | 0.83 |
| class: a word in capitals | 16 | 444.66 ± 0.5% | 478.93 ± 0.1% | 781.87 ± 0.4% | 119.33 ± 0.8% | 637.08 ± 1.8% | 1254.33 ± 2.3% | 8380.41 ± 0.6% | 445.48 ± 0.9% | 0.93 | 1.00 | 3.73 | 0.70 |
| class: a number | 6 | 560.41 ± 0.6% | 612.58 ± 0.4% | 1159.68 ± 1.1% | 36.00 ± 1.6% | 1139.03 ± 1.9% | 2112.52 ± 3.9% | 20437.21 ± 0.4% | 560.09 ± 1.0% | 0.91 | 1.00 | 15.57 | 0.49 |
| class: two capitalized words, second text | 23 | 422.43 ± 1.5% | 451.08 ± 0.4% | 653.78 ± 0.4% | 94.37 ± 0.4% | 443.76 ± 2.2% | 911.29 ± 1.3% | 6396.43 ± 1.4% | 421.99 ± 0.3% | 0.94 | 1.00 | 4.48 | 0.95 |
| other: a word between two words | 13 | 507.57 ± 1.9% | 521.73 ± 1.2% | 812.71 ± 0.5% | 122.08 ± 2.1% | 429.30 ± 3.3% | 1034.99 ± 0.7% | 14087.39 ± 12.2% | 507.92 ± 10.1% | 0.97 | 1.00 | 4.16 | 1.18 |
| other: a number before a unit, second text | 15 | 357.36 ± 1.1% | 391.84 ± 1.0% | 539.91 ± 10.4% | 33.62 ± 1.1% | 534.08 ± 4.3% | 1090.32 ± 9.1% | 13853.92 ± 1.0% | 357.45 ± 0.3% | 0.91 | 1.00 | 10.63 | 0.67 |
| other: a heading's start tag | 13 | 332.13 ± 0.3% | 338.45 ± 1.8% | 445.88 ± 0.6% | 35.46 ± 2.0% | 522.68 ± 1.0% | 1077.27 ± 0.6% | 16351.30 ± 0.7% | 332.15 ± 2.0% | 0.98 | 1.00 | 9.37 | 0.64 |
| other: a whole word | 11 | 514.44 ± 0.2% | 542.53 ± 0.3% | 873.25 ± 0.4% | 109.24 ± 1.0% | 501.58 ± 2.2% | 1022.32 ± 2.9% | 20785.98 ± 2.2% | 514.10 ± 1.8% | 0.95 | 1.00 | 4.71 | 1.03 |
| other: a line's first word, second text | 17 | 477.21 ± 10.8% | 503.06 ± 2.7% | 829.92 ± 3.1% | 114.06 ± 27.1% | 582.11 ± 4.8% | refused | refused | 481.17 ± 3.7% | 0.95 | 0.99 | 4.18 | 0.82 |
| other: fourteen octets before an x | 16 | 87.29 ± 2.9% | 124.68 ± 2.2% | 143.88 ± 2.5% | 14.01 ± 2.0% | 399.92 ± 2.3% | 445.04 ± 2.4% | 11710.32 ± 0.2% | 87.37 ± 1.3% | 0.70 | 1.00 | 6.23 | 0.22 |
| other: a Greek word | 8 | 379.24 ± 2.5% | 510.35 ± 0.6% | 829.84 ± 1.0% | 46.60 ± 0.6% | 1128.37 ± 1.9% | 2134.07 ± 0.9% | refused | 379.12 ± 1.0% | 0.74 | 1.00 | 8.14 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21032.38 ± 1.3% | not timed | not timed | 24972.08 ± 1.8% | 1961.79 ± 14.4% | not timed | not timed | 21014.13 ± 1.6% | | 1.00 | 0.84 | 10.72 |
| 01-literal/sherlock-casei-en | 522 | 4561.37 ± 0.2% | not timed | not timed | 6994.89 ± 0.4% | 28.61 ± 0.9% | not timed | not timed | 4651.66 ± 0.4% | | 0.98 | 0.65 | 159.44 |
| 01-literal/sherlock-ru | 724 | 22408.40 ± 2.4% | not timed | not timed | 27477.85 ± 0.5% | 1080.77 ± 3.7% | not timed | not timed | 22720.99 ± 1.3% | | 0.99 | 0.82 | 20.73 |
| 01-literal/sherlock-casei-ru | 746 | 7235.03 ± 3.3% | not timed | not timed | 5444.93 ± 0.9% | 30.33 ± 1.4% | not timed | not timed | 7248.60 ± 0.3% | | 1.00 | 1.33 | 238.53 |
| 01-literal/sherlock-zh | 30 | 41620.83 ± 2.4% | not timed | not timed | 36768.48 ± 1.1% | 1263.47 ± 0.4% | not timed | not timed | 41198.54 ± 10.6% | | 1.01 | 1.13 | 32.94 |
| 02-literal-alternate/sherlock-en | 714 | 9518.93 ± 0.7% | not timed | not timed | 8893.80 ± 0.3% | 14.40 ± 19.6% | not timed | not timed | 9561.95 ± 0.7% | | 1.00 | 1.07 | 661.07 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1734.68 ± 0.4% | not timed | not timed | 1823.18 ± 0.4% | 9.45 ± 0.3% | not timed | not timed | 1729.18 ± 1.0% | | 1.00 | 0.95 | 183.65 |
| 02-literal-alternate/sherlock-ru | 899 | 5925.93 ± 0.6% | not timed | not timed | 4258.02 ± 0.7% | 19.27 ± 1.5% | not timed | not timed | 5929.23 ± 9.2% | | 1.00 | 1.39 | 307.56 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1798.20 ± 0.2% | not timed | not timed | 1040.76 ± 0.7% | 8.47 ± 0.2% | not timed | not timed | 1782.77 ± 0.3% | | 1.01 | 1.73 | 212.38 |
| 02-literal-alternate/sherlock-zh | 207 | 13692.78 ± 0.7% | not timed | not timed | 10437.86 ± 0.3% | 26.82 ± 13.5% | not timed | not timed | 13757.31 ± 0.6% | | 1.00 | 1.31 | 510.53 |
| 03-date/ascii | 111817 | 99.75 ± 0.5% | not timed | not timed | 84.86 ± 0.1% | 0.18 ± 1.8% | not timed | not timed | 100.02 ± 0.1% | | 1.00 | 1.18 | 561.39 |
| 04-ruff-noqa/real | 84 | 546.57 ± 0.5% | not timed | not timed | 425.38 ± 8.1% | 15.93 ± 2.0% | not timed | not timed | 545.44 ± 0.3% | | 1.00 | 1.28 | 34.32 |
| 04-ruff-noqa/tweaked | 44 | 478.64 ± 4.4% | not timed | not timed | 419.68 ± 1.0% | 294.26 ± 1.1% | not timed | not timed | 483.02 ± 1.2% | | 0.99 | 1.14 | 1.63 |
| 05-lexer-veryl/single | 124800 | 2.76 ± 3.2% | not timed | not timed | 4.06 ± 4.9% | 0.21 ± 5.1% | not timed | not timed | 2.80 ± 2.1% | | 0.99 | 0.68 | 13.14 |
| 06-cloud-flare-redos/original | 107 | 230.59 ± 0.5% | not timed | not timed | 192.62 ± 0.7% | 20.59 ± 7.6% | not timed | not timed | 230.65 ± 1.7% | | 1.00 | 1.20 | 11.20 |
| 06-cloud-flare-redos/simplified-short | 102 | 220.34 ± 0.4% | not timed | not timed | 192.25 ± 0.7% | 21.88 ± 0.5% | not timed | not timed | 220.01 ± 0.3% | | 1.00 | 1.15 | 10.07 |
| 06-cloud-flare-redos/simplified-long | 10000 | 246.89 ± 0.2% | not timed | not timed | 210.24 ± 1.2% | 24.10 ± 0.6% | not timed | not timed | 246.87 ± 0.1% | | 1.00 | 1.17 | 10.25 |
| 07-unicode-character-data/parse-line | 558784 | 187.20 ± 0.3% | not timed | not timed | 160.30 ± 0.6% | 37.49 ± 7.1% | not timed | not timed | 186.47 ± 3.2% | | 1.00 | 1.17 | 4.99 |
| 08-words/all-english | 56691 | 90.48 ± 3.2% | not timed | not timed | 73.66 ± 0.5% | 11.30 ± 1.1% | not timed | not timed | 90.19 ± 0.5% | | 1.00 | 1.23 | 8.01 |
| 08-words/long-english | 839 | 808.68 ± 0.2% | not timed | not timed | 514.34 ± 0.2% | 26.40 ± 1.3% | not timed | not timed | 807.93 ± 0.7% | | 1.00 | 1.57 | 30.63 |
| 09-aws-keys/full | 0 | 424.56 ± 0.1% | not timed | not timed | 437.37 ± 1.1% | 43.37 ± 5.4% | not timed | not timed | 424.26 ± 0.1% | | 1.00 | 0.97 | 9.79 |
| 09-aws-keys/quick | 0 | 827.57 ± 0.3% | not timed | not timed | 806.53 ± 0.2% | 303.99 ± 1.2% | not timed | not timed | 824.53 ± 0.4% | | 1.00 | 1.03 | 2.72 |
| 10-bounded-repeat/letters-en | 1833 | 491.31 ± 0.4% | not timed | not timed | 430.34 ± 1.1% | 16.79 ± 10.2% | not timed | not timed | 490.74 ± 0.1% | | 1.00 | 1.14 | 29.25 |
| 10-bounded-repeat/letters-ru | 3475 | 317.71 ± 0.2% | not timed | not timed | 408.64 ± 4.1% | 19.65 ± 15.6% | not timed | not timed | 318.15 ± 2.0% | | 1.00 | 0.78 | 16.17 |
| 10-bounded-repeat/context | 53 | 65.96 ± 2.5% | not timed | not timed | 55.91 ± 0.5% | 16.86 ± 3.3% | not timed | not timed | 66.12 ± 1.4% | | 1.00 | 1.18 | 3.91 |
| 10-bounded-repeat/capitals | 11 | 845.69 ± 0.4% | not timed | not timed | 532.81 ± 0.3% | 30.62 ± 0.3% | not timed | not timed | 844.04 ± 0.3% | | 1.00 | 1.59 | 27.62 |
| 11-unstructured-to-json/extract | 600 | 35.97 ± 1.1% | not timed | not timed | 62.26 ± 1.0% | 40.75 ± 0.4% | not timed | not timed | 35.94 ± 0.9% | | 1.00 | 0.58 | 0.88 |
| 12-dictionary/single | 1 | 461.87 ± 0.5% | not timed | not timed | 440.89 ± 0.1% | 0.33 ± 0.7% | not timed | not timed | 464.86 ± 1.2% | | 0.99 | 1.05 | 1410.03 |
| 14-quadratic/1x | 100 | 10.01 ± 10.4% | not timed | not timed | 9.08 ± 1.1% | 0.81 ± 1.9% | not timed | not timed | 9.98 ± 1.2% | | 1.00 | 1.10 | 12.34 |
| 14-quadratic/2x | 200 | 6.28 ± 0.2% | not timed | not timed | 4.93 ± 0.2% | 0.43 ± 0.6% | not timed | not timed | 6.29 ± 0.2% | | 1.00 | 1.28 | 14.51 |
| 14-quadratic/10x | 1000 | 1.50 ± 0.7% | not timed | not timed | 1.05 ± 0.3% | 0.09 ± 15.2% | not timed | not timed | 1.49 ± 4.2% | | 1.01 | 1.43 | 16.18 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.35 ± 0.1% | not timed | not timed | 0.39 ± 0.2% | 0.48 ± 2.4% | not timed | not timed | 1.35 ± 7.6% | | 1.00 | 3.46 | 2.81 |
| 04-ruff-noqa/compile-real | 1 | 79.92 ± 1.4% | not timed | not timed | 13.01 ± 2.6% | 125.11 ± 2.7% | not timed | not timed | 79.51 ± 2.0% | | 1.01 | 6.14 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 12.88 ± 0.7% | not timed | not timed | 2.38 ± 1.2% | 5.93 ± 10.1% | not timed | not timed | 12.85 ± 2.0% | | 1.00 | 5.42 | 2.17 |
| 07-unicode-character-data/compile | 1 | 50.51 ± 1.7% | not timed | not timed | 24.00 ± 1.0% | 33.04 ± 1.7% | not timed | not timed | 50.39 ± 1.0% | | 1.00 | 2.11 | 1.53 |
| 09-aws-keys/compile-full | 1 | 34.75 ± 0.4% | not timed | not timed | 7.34 ± 7.1% | 19.41 ± 11.5% | not timed | not timed | 34.64 ± 1.2% | | 1.00 | 4.73 | 1.79 |
| 09-aws-keys/compile-quick | 1 | 159.67 ± 0.4% | not timed | not timed | 44.83 ± 1.6% | 120.14 ± 2.7% | not timed | not timed | 158.44 ± 1.8% | | 1.01 | 3.56 | 1.33 |
| 10-bounded-repeat/compile-context | 1 | 10.61 ± 0.3% | not timed | not timed | 11.57 ± 0.2% | 15.05 ± 17.4% | not timed | not timed | 10.61 ± 0.8% | | 1.00 | 0.92 | 0.70 |
| 10-bounded-repeat/compile-capitals | 1 | 73.61 ± 0.9% | not timed | not timed | 8.86 ± 19.8% | 22.62 ± 1.9% | not timed | not timed | 72.88 ± 1.8% | | 1.01 | 8.31 | 3.25 |
| 11-unstructured-to-json/compile | 1 | 77.03 ± 1.2% | not timed | not timed | 36.99 ± 4.5% | 60.61 ± 13.0% | not timed | not timed | 75.80 ± 2.1% | | 1.02 | 2.08 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.3% | not timed | not timed | 0.07 ± 14.5% | 0.08 ± 16.3% | not timed | not timed | 0.29 ± 5.8% | | 1.00 | 4.26 | 3.58 |

