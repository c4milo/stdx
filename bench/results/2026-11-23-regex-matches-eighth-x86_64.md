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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127349194 |
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
| literal: a word | 217 | 33529.66 ± 3.1% | 842.89 ± 0.4% | 19.70 ± 2.0% | 31332.91 ± 0.7% | 8979.14 ± 7.7% | 10.77 ± 0.1% | 75.67 ± 2.9% | 32936.88 ± 1.3% | 39.78 | 1.02 | 1.07 | 3.73 |
| literal: a word that is not there | 0 | 50068.86 ± 2.2% | 850.79 ± 0.2% | 19.82 ± 2.7% | 39838.12 ± 0.9% | 30371.41 ± 0.6% | 10.69 ± 0.3% | 72.44 ± 2.2% | 49734.91 ± 1.1% | 58.85 | 1.01 | 1.26 | 1.65 |
| literal: one of four words | 661 | 11008.85 ± 1.7% | 820.40 ± 0.5% | 10.79 ± 2.3% | 9116.21 ± 0.3% | 18.19 ± 6.7% | 3.99 ± 0.4% | 6.31 ± 1.1% | 10994.39 ± 1.5% | 13.42 | 1.00 | 1.21 | 605.07 |
| literal: a word in any case | 217 | 25968.67 ± 0.6% | 840.77 ± 1.0% | 14.48 ± 1.5% | 9221.33 ± 0.4% | 34.65 ± 4.9% | refused | differs | 25900.74 ± 0.5% | 30.89 | 1.00 | 2.82 | 749.42 |
| literal: an href attribute | 33 | 27334.28 ± 4.4% | 848.42 ± 0.1% | 18.07 ± 1.7% | 27457.81 ± 0.3% | 2040.79 ± 1.3% | 8.22 ± 0.1% | 58.57 ± 3.1% | 27223.29 ± 1.8% | 32.22 | 1.00 | 1.00 | 13.39 |
| literal: a word, second text | 123 | 33952.36 ± 1.2% | 844.36 ± 0.3% | 19.25 ± 4.1% | 31754.51 ± 2.9% | 7043.09 ± 3.0% | 11.76 ± 1.3% | 62.26 ± 5.6% | 34117.06 ± 1.3% | 40.21 | 1.00 | 1.07 | 4.82 |
| class: two capitalized words | 1331 | 786.72 ± 1.1% | 784.04 ± 0.2% | 18.29 ± 1.4% | 505.16 ± 0.2% | 32.14 ± 7.2% | 9.28 ± 0.2% | 55.01 ± 4.9% | 785.53 ± 0.3% | 1.00 | 1.00 | 1.56 | 24.48 |
| class: a word that ends in ing | 3399 | 712.98 ± 0.4% | 712.73 ± 0.4% | 12.86 ± 1.5% | 468.49 ± 0.9% | 25.06 ± 3.5% | 5.35 ± 0.2% | 17.08 ± 1.2% | 713.03 ± 1.0% | 1.00 | 1.00 | 1.52 | 28.45 |
| class: a word in capitals | 2332 | 983.93 ± 2.0% | 765.15 ± 0.1% | 19.43 ± 2.9% | 496.71 ± 0.5% | 34.31 ± 7.9% | 10.26 ± 0.5% | 76.01 ± 2.7% | 987.91 ± 2.5% | 1.29 | 1.00 | 1.98 | 28.67 |
| class: a number | 8288 | 1417.75 ± 1.2% | 640.61 ± 1.1% | 19.17 ± 1.5% | 1481.99 ± 4.0% | 32.81 ± 12.4% | 0.33 ± 0.5% | 52.68 ± 5.2% | 1417.13 ± 0.7% | 2.21 | 1.00 | 0.96 | 43.21 |
| class: two capitalized words, second text | 5359 | 587.34 ± 1.1% | 589.59 ± 0.3% | 17.07 ± 1.3% | 410.32 ± 0.6% | 28.68 ± 11.5% | 10.48 ± 0.4% | 50.81 ± 1.7% | 581.94 ± 0.4% | 1.00 | 1.01 | 1.43 | 20.48 |
| other: a word between two words | 6104 | 642.20 ± 0.6% | 615.02 ± 0.6% | 16.60 ± 1.4% | 698.25 ± 0.5% | 97.54 ± 4.3% | 7.24 ± 0.1% | 55.94 ± 3.0% | 638.16 ± 0.4% | 1.04 | 1.01 | 0.92 | 6.58 |
| other: a number before a unit, second text | 1481 | 6624.77 ± 1.4% | 788.30 ± 0.4% | 18.36 ± 2.8% | 6398.79 ± 1.6% | 34.34 ± 12.1% | 10.90 ± 0.3% | 54.78 ± 0.6% | 6574.27 ± 1.8% | 8.40 | 1.01 | 1.04 | 192.89 |
| other: a heading's start tag | 110 | 18979.68 ± 0.9% | 841.88 ± 0.3% | 18.98 ± 1.5% | 2001.50 ± 2.2% | 1450.99 ± 3.5% | 10.02 ± 0.2% | 72.54 ± 2.4% | 18862.25 ± 0.7% | 22.54 | 1.01 | 9.48 | 13.08 |
| other: a whole word | 217 | 23034.41 ± 1.8% | 842.48 ± 0.6% | 19.31 ± 1.3% | 22784.72 ± 0.7% | 39.26 ± 5.6% | 9.46 ± 0.1% | 46.70 ± 5.6% | 22724.55 ± 3.0% | 27.34 | 1.01 | 1.01 | 586.72 |
| other: a line's first word, second text | 3716 | 1714.68 ± 0.6% | 704.13 ± 0.3% | 22.09 ± 2.5% | 1721.07 ± 2.0% | 51.88 ± 7.6% | refused | refused | 1711.24 ± 1.0% | 2.44 | 1.00 | 1.00 | 33.05 |
| other: fourteen octets before an x | 87 | 25380.22 ± 3.3% | 224.43 ± 1.6% | 5.08 ± 1.0% | 3079.76 ± 1.1% | 8.88 ± 2.3% | differs | 15.19 ± 3.0% | 25549.07 ± 2.0% | 113.09 | 0.99 | 8.24 | 2858.67 |
| other: a Greek word | 21815 | 393.51 ± 0.9% | 287.91 ± 1.5% | 23.24 ± 1.2% | 260.86 ± 4.6% | 40.26 ± 10.7% | differs | refused | 386.36 ± 0.6% | 1.37 | 1.02 | 1.51 | 9.78 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.25 ± 1.7% | 24.26 ± 1.0% | 0.72 ± 1.0% | 16.82 ± 0.5% | 2.31 ± 0.8% | differs | 3.64 ± 1.5% | 24.35 ± 2.6% | 1.00 | 1.00 | 1.44 | 10.48 |
| a UUID | 32895 | 20.55 ± 0.8% | 20.55 ± 1.7% | 0.54 ± 1.4% | 12.86 ± 0.1% | 2.54 ± 7.2% | 0.44 ± 0.2% | 3.06 ± 1.5% | 20.04 ± 0.2% | 1.00 | 1.03 | 1.60 | 8.09 |
| an IPv4 address | 33176 | 34.06 ± 1.7% | 33.74 ± 1.5% | 1.75 ± 0.8% | 23.98 ± 0.6% | 5.71 ± 0.8% | differs | 3.38 ± 0.5% | 34.27 ± 3.4% | 1.01 | 0.99 | 1.42 | 5.96 |
| a date and time | 32954 | 30.29 ± 1.1% | 30.17 ± 1.3% | 1.27 ± 0.3% | 18.07 ± 1.0% | 6.63 ± 5.5% | 0.76 ± 0.5% | 6.06 ± 0.3% | 29.82 ± 1.0% | 1.00 | 1.02 | 1.68 | 4.57 |
| a field path | 32606 | 24.76 ± 2.5% | 26.91 ± 2.3% | 0.85 ± 3.6% | 19.34 ± 1.0% | 2.94 ± 0.9% | differs | 2.46 ± 1.8% | 26.74 ± 1.7% | 0.92 | 0.93 | 1.28 | 8.42 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.18 ± 0.4% | 8.27 ± 1.9% | 8.10 ± 0.5% | 10.69 ± 0.2% | 4.66 ± 4.7% | 0.62 ± 0.7% | none | 8.28 ± 2.2% | 0.99 | 0.99 | 0.77 | 1.76 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 181.97 ± 0.5% | 182.39 ± 0.7% | 212.35 ± 0.9% | 79.71 ± 4.0% | 182.62 ± 4.7% | 541.40 ± 2.9% | 3910.42 ± 3.7% | 182.21 ± 0.6% | 1.00 | 1.00 | 2.28 | 1.00 |
| a UUID | 62 | 119.80 ± 2.1% | 120.11 ± 2.1% | 133.48 ± 2.2% | 46.48 ± 4.2% | 88.93 ± 4.8% | 198.31 ± 1.4% | 4055.02 ± 4.0% | 119.39 ± 1.9% | 1.00 | 1.00 | 2.58 | 1.35 |
| an IPv4 address | 29 | 390.48 ± 3.0% | 392.07 ± 2.5% | 556.05 ± 2.1% | 69.17 ± 0.9% | 113.26 ± 1.5% | 319.09 ± 3.7% | 7051.88 ± 3.6% | 389.03 ± 1.2% | 1.00 | 1.00 | 5.65 | 3.45 |
| a date and time | 56 | 280.49 ± 1.5% | 282.06 ± 1.1% | 356.27 ± 0.6% | 68.15 ± 2.1% | 123.27 ± 2.9% | 370.54 ± 2.0% | 4023.66 ± 4.6% | 280.74 ± 0.5% | 0.99 | 1.00 | 4.12 | 2.28 |
| a field path | 39 | 178.33 ± 1.3% | 178.97 ± 0.5% | 207.84 ± 0.8% | 74.26 ± 2.5% | 171.50 ± 2.4% | 593.38 ± 6.4% | 4801.13 ± 2.1% | 178.47 ± 0.9% | 1.00 | 1.00 | 2.40 | 1.04 |
| literal: a word | 7 | 572.84 ± 1.7% | 607.32 ± 1.1% | 1082.19 ± 1.1% | 502.23 ± 1.1% | 574.86 ± 3.8% | 1230.18 ± 1.7% | 21645.44 ± 9.5% | 566.09 ± 1.2% | 0.94 | 1.01 | 1.14 | 1.00 |
| literal: a word that is not there | 8 | 549.28 ± 1.7% | 589.22 ± 1.5% | 1023.99 ± 1.1% | 458.30 ± 0.2% | 541.59 ± 4.7% | 1167.52 ± 11.4% | 23512.10 ± 13.4% | 545.86 ± 0.7% | 0.93 | 1.01 | 1.20 | 1.01 |
| literal: one of four words | 26 | 220.53 ± 1.3% | 355.53 ± 0.8% | 475.99 ± 1.2% | 40.84 ± 14.4% | 217.57 ± 3.1% | 443.00 ± 4.2% | 11414.39 ± 1.0% | 219.22 ± 2.9% | 0.62 | 1.01 | 5.40 | 1.01 |
| literal: a word in any case | 11 | 441.99 ± 1.0% | 465.59 ± 0.8% | 721.49 ± 0.7% | 14.05 ± 0.6% | 604.15 ± 3.8% | refused | 18221.86 ± 14.9% | 440.72 ± 8.9% | 0.95 | 1.00 | 31.45 | 0.73 |
| literal: an href attribute | 12 | 310.45 ± 2.4% | 321.67 ± 1.1% | 423.87 ± 7.5% | 35.95 ± 1.4% | 422.30 ± 2.0% | 958.53 ± 3.0% | 17772.71 ± 2.5% | 307.26 ± 13.6% | 0.97 | 1.01 | 8.63 | 0.74 |
| literal: a word, second text | 10 | 509.94 ± 2.1% | 555.42 ± 1.0% | 920.72 ± 1.6% | 417.69 ± 2.1% | 468.64 ± 10.8% | 1004.52 ± 6.5% | 21270.34 ± 4.5% | 502.99 ± 1.0% | 0.92 | 1.01 | 1.22 | 1.09 |
| class: two capitalized words | 23 | 413.46 ± 0.4% | 438.97 ± 10.1% | 647.96 ± 2.9% | 95.24 ± 0.3% | 444.20 ± 1.7% | 951.71 ± 11.5% | 6238.60 ± 3.6% | 411.78 ± 8.2% | 0.94 | 1.00 | 4.34 | 0.93 |
| class: a word that ends in ing | 9 | 500.39 ± 0.4% | 557.70 ± 0.8% | 998.64 ± 9.8% | 114.44 ± 9.2% | 613.82 ± 1.3% | 1502.16 ± 4.5% | 14568.37 ± 4.4% | 500.38 ± 0.8% | 0.90 | 1.00 | 4.37 | 0.82 |
| class: a word in capitals | 16 | 439.15 ± 0.7% | 468.98 ± 0.7% | 785.89 ± 0.8% | 122.33 ± 1.2% | 632.57 ± 1.6% | 1324.50 ± 3.5% | 8352.23 ± 1.2% | 439.03 ± 7.4% | 0.94 | 1.00 | 3.59 | 0.69 |
| class: a number | 6 | 552.48 ± 0.3% | 600.34 ± 0.9% | 1168.02 ± 1.3% | 35.95 ± 2.2% | 1129.48 ± 2.7% | 2307.66 ± 1.2% | 20397.62 ± 4.6% | 550.56 ± 1.6% | 0.92 | 1.00 | 15.37 | 0.49 |
| class: two capitalized words, second text | 23 | 413.62 ± 1.4% | 435.07 ± 3.5% | 631.53 ± 3.4% | 94.33 ± 0.8% | 444.52 ± 1.3% | 940.26 ± 1.1% | 6387.87 ± 0.3% | 414.20 ± 2.1% | 0.95 | 1.00 | 4.38 | 0.93 |
| other: a word between two words | 13 | 491.05 ± 1.4% | 506.07 ± 1.2% | 797.73 ± 0.6% | 122.45 ± 1.2% | 428.31 ± 1.0% | 1041.95 ± 1.0% | 13950.81 ± 2.3% | 493.29 ± 13.1% | 0.97 | 1.00 | 4.01 | 1.15 |
| other: a number before a unit, second text | 15 | 352.63 ± 0.5% | 386.12 ± 0.5% | 535.11 ± 0.7% | 33.68 ± 10.9% | 531.07 ± 5.8% | 1144.61 ± 7.1% | 13924.62 ± 0.4% | 352.49 ± 0.6% | 0.91 | 1.00 | 10.47 | 0.66 |
| other: a heading's start tag | 13 | 329.58 ± 0.9% | 334.69 ± 1.3% | 443.23 ± 0.7% | 34.91 ± 2.2% | 518.25 ± 1.4% | 1097.73 ± 1.7% | 16154.85 ± 14.4% | 329.42 ± 0.7% | 0.98 | 1.00 | 9.44 | 0.64 |
| other: a whole word | 11 | 499.53 ± 0.4% | 528.02 ± 1.6% | 856.86 ± 0.4% | 110.94 ± 1.4% | 501.80 ± 25.1% | 1057.92 ± 1.3% | 20691.92 ± 1.4% | 499.92 ± 1.2% | 0.95 | 1.00 | 4.50 | 1.00 |
| other: a line's first word, second text | 17 | 479.99 ± 1.5% | 498.49 ± 1.5% | 830.14 ± 0.2% | 114.93 ± 1.7% | 576.04 ± 3.8% | refused | refused | 478.47 ± 1.0% | 0.96 | 1.00 | 4.18 | 0.83 |
| other: fourteen octets before an x | 16 | 87.33 ± 0.6% | 124.39 ± 1.0% | 143.47 ± 0.3% | 14.26 ± 2.5% | 392.77 ± 1.7% | 451.66 ± 2.3% | 11818.51 ± 4.7% | 87.60 ± 2.9% | 0.70 | 1.00 | 6.12 | 0.22 |
| other: a Greek word | 8 | 376.49 ± 0.9% | 498.37 ± 1.1% | 830.10 ± 0.9% | 46.14 ± 1.9% | 1117.68 ± 2.2% | 2132.54 ± 0.5% | refused | 376.93 ± 0.4% | 0.76 | 1.00 | 8.16 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21247.85 ± 3.3% | not timed | not timed | 27233.06 ± 4.2% | 2002.66 ± 12.6% | not timed | not timed | 21194.93 ± 4.9% | | 1.00 | 0.78 | 10.61 |
| 01-literal/sherlock-casei-en | 522 | 4572.34 ± 2.3% | not timed | not timed | 6842.03 ± 2.7% | 27.90 ± 4.5% | not timed | not timed | 4651.61 ± 2.2% | | 0.98 | 0.67 | 163.90 |
| 01-literal/sherlock-ru | 724 | 23128.93 ± 5.7% | not timed | not timed | 27630.77 ± 17.4% | 1074.02 ± 4.3% | not timed | not timed | 23242.33 ± 8.2% | | 1.00 | 0.84 | 21.53 |
| 01-literal/sherlock-casei-ru | 746 | 7314.26 ± 0.5% | not timed | not timed | 5467.71 ± 0.5% | 30.51 ± 3.3% | not timed | not timed | 7284.96 ± 0.6% | | 1.00 | 1.34 | 239.75 |
| 01-literal/sherlock-zh | 30 | 43294.15 ± 4.2% | not timed | not timed | 37004.17 ± 3.7% | 1264.15 ± 0.5% | not timed | not timed | 43063.62 ± 1.8% | | 1.01 | 1.17 | 34.25 |
| 02-literal-alternate/sherlock-en | 714 | 9545.05 ± 0.4% | not timed | not timed | 8919.36 ± 0.4% | 14.12 ± 5.8% | not timed | not timed | 9544.77 ± 1.1% | | 1.00 | 1.07 | 676.00 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1733.88 ± 0.5% | not timed | not timed | 1818.36 ± 1.6% | 8.98 ± 6.1% | not timed | not timed | 1710.73 ± 0.3% | | 1.01 | 0.95 | 193.09 |
| 02-literal-alternate/sherlock-ru | 899 | 5837.82 ± 3.1% | not timed | not timed | 4252.36 ± 0.4% | 18.56 ± 4.3% | not timed | not timed | 5873.85 ± 0.7% | | 0.99 | 1.37 | 314.56 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1798.25 ± 3.0% | not timed | not timed | 1033.43 ± 0.4% | 8.44 ± 11.8% | not timed | not timed | 1800.32 ± 0.5% | | 1.00 | 1.74 | 213.11 |
| 02-literal-alternate/sherlock-zh | 207 | 13772.34 ± 1.0% | not timed | not timed | 10412.19 ± 6.3% | 26.98 ± 0.9% | not timed | not timed | 13795.91 ± 1.9% | | 1.00 | 1.32 | 510.40 |
| 03-date/ascii | 111817 | 97.95 ± 0.4% | not timed | not timed | 85.04 ± 0.6% | 0.18 ± 2.1% | not timed | not timed | 98.24 ± 0.8% | | 1.00 | 1.15 | 556.29 |
| 04-ruff-noqa/real | 84 | 545.03 ± 0.5% | not timed | not timed | 425.18 ± 0.5% | 15.95 ± 2.1% | not timed | not timed | 536.73 ± 0.5% | | 1.02 | 1.28 | 34.18 |
| 04-ruff-noqa/tweaked | 44 | 483.75 ± 4.2% | not timed | not timed | 420.52 ± 1.4% | 292.57 ± 2.4% | not timed | not timed | 482.62 ± 0.7% | | 1.00 | 1.15 | 1.65 |
| 05-lexer-veryl/single | 124800 | 2.77 ± 0.5% | not timed | not timed | 3.96 ± 2.5% | 0.20 ± 7.7% | not timed | not timed | 2.76 ± 3.4% | | 1.01 | 0.70 | 13.66 |
| 06-cloud-flare-redos/original | 107 | 229.58 ± 0.3% | not timed | not timed | 177.32 ± 3.7% | 20.48 ± 0.7% | not timed | not timed | 225.68 ± 0.3% | | 1.02 | 1.29 | 11.21 |
| 06-cloud-flare-redos/simplified-short | 102 | 219.57 ± 0.8% | not timed | not timed | 188.97 ± 4.3% | 21.63 ± 2.1% | not timed | not timed | 219.43 ± 0.3% | | 1.00 | 1.16 | 10.15 |
| 06-cloud-flare-redos/simplified-long | 10000 | 246.80 ± 0.8% | not timed | not timed | 195.72 ± 3.0% | 23.93 ± 0.8% | not timed | not timed | 246.72 ± 0.1% | | 1.00 | 1.26 | 10.31 |
| 07-unicode-character-data/parse-line | 558784 | 188.84 ± 5.3% | not timed | not timed | 153.80 ± 8.8% | 37.52 ± 5.5% | not timed | not timed | 185.85 ± 15.8% | | 1.02 | 1.23 | 5.03 |
| 08-words/all-english | 56691 | 91.07 ± 0.8% | not timed | not timed | 73.69 ± 8.8% | 9.92 ± 7.2% | not timed | not timed | 90.10 ± 1.9% | | 1.01 | 1.24 | 9.18 |
| 08-words/long-english | 839 | 808.41 ± 1.9% | not timed | not timed | 512.86 ± 1.4% | 25.50 ± 8.7% | not timed | not timed | 807.61 ± 1.6% | | 1.00 | 1.58 | 31.70 |
| 09-aws-keys/full | 0 | 418.94 ± 0.8% | not timed | not timed | 445.58 ± 0.4% | 53.92 ± 6.3% | not timed | not timed | 420.64 ± 1.0% | | 1.00 | 0.94 | 7.77 |
| 09-aws-keys/quick | 0 | 823.99 ± 27.5% | not timed | not timed | 780.95 ± 9.9% | 328.92 ± 1.2% | not timed | not timed | 823.83 ± 0.5% | | 1.00 | 1.06 | 2.51 |
| 10-bounded-repeat/letters-en | 1833 | 482.33 ± 5.7% | not timed | not timed | 430.77 ± 0.3% | 16.19 ± 3.9% | not timed | not timed | 489.23 ± 6.2% | | 0.99 | 1.12 | 29.80 |
| 10-bounded-repeat/letters-ru | 3475 | 315.96 ± 5.5% | not timed | not timed | 405.33 ± 2.0% | 18.65 ± 11.9% | not timed | not timed | 315.39 ± 3.5% | | 1.00 | 0.78 | 16.94 |
| 10-bounded-repeat/context | 53 | 64.81 ± 2.5% | not timed | not timed | 55.69 ± 1.9% | 16.50 ± 2.9% | not timed | not timed | 63.91 ± 3.2% | | 1.01 | 1.16 | 3.93 |
| 10-bounded-repeat/capitals | 11 | 840.91 ± 0.5% | not timed | not timed | 533.22 ± 0.1% | 29.44 ± 7.2% | not timed | not timed | 842.52 ± 3.8% | | 1.00 | 1.58 | 28.56 |
| 11-unstructured-to-json/extract | 600 | 35.60 ± 4.5% | not timed | not timed | 61.78 ± 1.5% | 40.76 ± 1.3% | not timed | not timed | 35.50 ± 0.7% | | 1.00 | 0.58 | 0.87 |
| 12-dictionary/single | 1 | 460.38 ± 0.3% | not timed | not timed | 440.65 ± 0.2% | 0.31 ± 0.5% | not timed | not timed | 463.27 ± 0.2% | | 0.99 | 1.04 | 1480.06 |
| 14-quadratic/1x | 100 | 10.04 ± 0.7% | not timed | not timed | 8.96 ± 0.6% | 0.79 ± 4.1% | not timed | not timed | 9.87 ± 1.1% | | 1.02 | 1.12 | 12.73 |
| 14-quadratic/2x | 200 | 6.26 ± 0.7% | not timed | not timed | 4.89 ± 0.3% | 0.42 ± 1.9% | not timed | not timed | 6.24 ± 0.6% | | 1.00 | 1.28 | 14.94 |
| 14-quadratic/10x | 1000 | 1.51 ± 0.3% | not timed | not timed | 1.05 ± 0.2% | 0.09 ± 3.2% | not timed | not timed | 1.51 ± 0.7% | | 1.00 | 1.44 | 16.94 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.34 ± 0.5% | not timed | not timed | 0.38 ± 2.4% | 0.47 ± 3.8% | not timed | not timed | 1.33 ± 0.9% | | 1.00 | 3.57 | 2.84 |
| 04-ruff-noqa/compile-real | 1 | 79.03 ± 0.9% | not timed | not timed | 12.80 ± 1.2% | 122.46 ± 3.8% | not timed | not timed | 78.60 ± 2.2% | | 1.01 | 6.17 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 12.83 ± 1.5% | not timed | not timed | 2.35 ± 2.6% | 5.80 ± 2.3% | not timed | not timed | 12.66 ± 1.6% | | 1.01 | 5.46 | 2.21 |
| 07-unicode-character-data/compile | 1 | 49.32 ± 1.2% | not timed | not timed | 24.08 ± 0.6% | 31.77 ± 1.6% | not timed | not timed | 49.34 ± 1.3% | | 1.00 | 2.05 | 1.55 |
| 09-aws-keys/compile-full | 1 | 33.93 ± 1.1% | not timed | not timed | 7.32 ± 1.4% | 20.00 ± 3.6% | not timed | not timed | 33.45 ± 3.1% | | 1.01 | 4.63 | 1.70 |
| 09-aws-keys/compile-quick | 1 | 157.34 ± 1.4% | not timed | not timed | 45.53 ± 1.6% | 116.17 ± 3.3% | not timed | not timed | 154.06 ± 19.8% | | 1.02 | 3.46 | 1.35 |
| 10-bounded-repeat/compile-context | 1 | 10.26 ± 2.4% | not timed | not timed | 11.33 ± 3.5% | 14.80 ± 3.9% | not timed | not timed | 10.14 ± 3.5% | | 1.01 | 0.91 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 71.46 ± 4.6% | not timed | not timed | 8.80 ± 2.2% | 21.52 ± 1.9% | not timed | not timed | 69.90 ± 2.2% | | 1.02 | 8.12 | 3.32 |
| 11-unstructured-to-json/compile | 1 | 75.55 ± 1.2% | not timed | not timed | 36.18 ± 1.1% | 60.20 ± 2.6% | not timed | not timed | 75.12 ± 6.3% | | 1.01 | 2.09 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.28 ± 1.6% | not timed | not timed | 0.07 ± 3.0% | 0.08 ± 22.0% | not timed | not timed | 0.28 ± 12.5% | | 1.01 | 4.26 | 3.42 |

