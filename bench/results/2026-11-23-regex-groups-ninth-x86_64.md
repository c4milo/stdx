# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215394112 |
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
| literal: a word | 217 | 31809.87 ± 3.9% | 3353.43 ± 0.5% | 20.12 ± 0.5% | 30877.49 ± 1.8% | 8678.76 ± 11.2% | 10.74 ± 0.2% | 76.32 ± 2.5% | 31247.10 ± 0.8% | 9.49 | 1.02 | 1.03 | 3.67 |
| literal: a word that is not there | 0 | 46818.16 ± 2.2% | 3249.05 ± 0.2% | 20.11 ± 8.1% | 39207.50 ± 83.9% | 29908.41 ± 0.8% | 10.69 ± 0.3% | 72.31 ± 1.6% | 46392.03 ± 102.7% | 14.41 | 1.01 | 1.19 | 1.57 |
| literal: one of four words | 661 | 11117.31 ± 5.6% | 1391.88 ± 1.9% | 10.92 ± 0.5% | 9105.98 ± 2.2% | 18.83 ± 2.7% | 3.96 ± 2.2% | 6.67 ± 5.9% | 11033.24 ± 4.3% | 7.99 | 1.01 | 1.22 | 590.31 |
| literal: a word in any case | 217 | 25446.23 ± 1.6% | 1492.18 ± 0.3% | 15.36 ± 5.1% | 9179.07 ± 2.7% | 37.08 ± 5.9% | refused | differs | 25473.36 ± 0.8% | 17.05 | 1.00 | 2.77 | 686.24 |
| literal: an href attribute | 33 | 26249.75 ± 3.1% | 537.37 ± 0.3% | 18.64 ± 0.2% | 27408.89 ± 39.0% | 2039.06 ± 3.9% | 8.23 ± 0.1% | 61.30 ± 1.1% | 25990.02 ± 2.7% | 48.85 | 1.01 | 0.96 | 12.87 |
| literal: a word, second text | 123 | 31734.89 ± 1.0% | 2369.54 ± 4.4% | 19.99 ± 0.2% | 31789.79 ± 1.5% | 6951.07 ± 6.6% | 11.70 ± 0.3% | 64.89 ± 4.3% | 31584.56 ± 0.6% | 13.39 | 1.00 | 1.00 | 4.57 |
| class: two capitalized words | 1331 | 768.41 ± 1.2% | 525.12 ± 0.2% | 18.76 ± 0.4% | 505.37 ± 0.2% | 33.92 ± 6.5% | 9.37 ± 0.2% | 55.57 ± 0.3% | 768.58 ± 1.0% | 1.46 | 1.00 | 1.52 | 22.65 |
| class: a word that ends in ing | 3399 | 498.73 ± 0.0% | 498.08 ± 0.2% | 13.02 ± 5.5% | 472.56 ± 1.3% | 25.19 ± 2.1% | 5.32 ± 0.3% | 17.21 ± 0.6% | 497.31 ± 0.4% | 1.00 | 1.00 | 1.06 | 19.80 |
| class: a word in capitals | 2332 | 952.73 ± 0.5% | 528.94 ± 0.8% | 19.76 ± 0.9% | 496.97 ± 0.2% | 36.34 ± 6.0% | 10.48 ± 0.6% | 76.29 ± 2.8% | 951.48 ± 2.0% | 1.80 | 1.00 | 1.92 | 26.22 |
| class: a number | 8288 | 1454.63 ± 0.5% | 696.17 ± 1.4% | 19.68 ± 2.1% | 1479.04 ± 0.4% | 35.61 ± 9.2% | 0.33 ± 0.2% | 55.89 ± 0.7% | 1455.69 ± 0.6% | 2.09 | 1.00 | 0.98 | 40.85 |
| class: two capitalized words, second text | 5359 | 442.46 ± 0.2% | 450.09 ± 0.6% | 15.60 ± 0.2% | 417.09 ± 0.2% | 28.23 ± 7.4% | 10.66 ± 1.2% | 51.55 ± 0.4% | 443.57 ± 0.3% | 0.98 | 1.00 | 1.06 | 15.67 |
| other: a word between two words | 6104 | 685.62 ± 0.6% | 510.55 ± 0.1% | 16.68 ± 0.5% | 695.60 ± 0.6% | 98.30 ± 10.3% | 7.25 ± 0.3% | 56.49 ± 0.9% | 685.61 ± 7.1% | 1.34 | 1.00 | 0.99 | 6.97 |
| other: a number before a unit, second text | 1481 | 7098.87 ± 1.5% | 859.61 ± 0.4% | 18.77 ± 0.5% | 6436.98 ± 2.1% | 34.78 ± 7.4% | 11.06 ± 0.6% | 55.09 ± 0.2% | 6980.17 ± 0.7% | 8.26 | 1.02 | 1.10 | 204.10 |
| other: a heading's start tag | 110 | 18438.62 ± 3.4% | 653.45 ± 1.1% | 19.55 ± 1.8% | 1980.58 ± 2.3% | 1440.00 ± 15.2% | 10.02 ± 1.3% | 72.50 ± 2.4% | 18572.38 ± 10.2% | 28.22 | 0.99 | 9.31 | 12.80 |
| other: a whole word | 217 | 22341.97 ± 2.2% | 531.04 ± 0.2% | 20.71 ± 0.9% | 22681.41 ± 0.8% | 39.13 ± 0.2% | 9.52 ± 0.2% | 46.74 ± 1.7% | 19476.22 ± 2.4% | 42.07 | 1.15 | 0.99 | 570.92 |
| other: a line's first word, second text | 3716 | 1894.33 ± 5.9% | 512.53 ± 0.3% | 24.24 ± 0.7% | 1692.21 ± 7.1% | 52.48 ± 5.5% | refused | refused | 1896.24 ± 6.6% | 3.70 | 1.00 | 1.12 | 36.09 |
| other: fourteen octets before an x | 87 | 25627.28 ± 1.8% | 207.88 ± 0.6% | 5.24 ± 0.1% | 2976.55 ± 2.1% | 8.76 ± 0.9% | differs | 15.48 ± 1.4% | 25780.16 ± 1.2% | 123.28 | 0.99 | 8.61 | 2927.05 |
| other: a Greek word | 21815 | 386.14 ± 0.3% | 333.70 ± 0.7% | 24.06 ± 1.4% | 265.35 ± 1.0% | 44.10 ± 20.6% | differs | refused | 385.59 ± 0.3% | 1.16 | 1.00 | 1.46 | 8.76 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.62 ± 1.2% | 18.63 ± 0.1% | 0.79 ± 3.1% | 17.02 ± 0.3% | 2.34 ± 0.6% | differs | 3.63 ± 0.3% | 18.59 ± 0.2% | 1.00 | 1.00 | 1.09 | 7.95 |
| a UUID | 32895 | 20.43 ± 0.4% | 20.41 ± 0.5% | 0.55 ± 1.6% | 12.86 ± 1.8% | 2.52 ± 2.6% | 0.43 ± 0.7% | 3.10 ± 0.4% | 20.26 ± 0.4% | 1.00 | 1.01 | 1.59 | 8.12 |
| an IPv4 address | 33176 | 33.88 ± 0.4% | 33.26 ± 0.4% | 1.70 ± 0.5% | 24.29 ± 0.3% | 5.61 ± 0.7% | differs | 3.45 ± 1.7% | 33.83 ± 10.2% | 1.02 | 1.00 | 1.40 | 6.04 |
| a date and time | 32954 | 30.17 ± 9.5% | 30.15 ± 9.4% | 1.25 ± 0.3% | 18.07 ± 0.1% | 6.70 ± 1.3% | 0.75 ± 0.6% | 6.19 ± 5.4% | 29.87 ± 0.7% | 1.00 | 1.01 | 1.67 | 4.50 |
| a field path | 32606 | 21.81 ± 0.1% | 21.78 ± 0.3% | 0.90 ± 1.0% | 19.63 ± 0.2% | 2.95 ± 0.3% | differs | 2.47 ± 0.5% | 21.80 ± 0.3% | 1.00 | 1.00 | 1.11 | 7.40 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.59 ± 3.1% | 8.58 ± 3.2% | 8.71 ± 2.5% | 10.68 ± 0.2% | 4.79 ± 8.1% | 0.62 ± 2.5% | none | 8.77 ± 3.4% | 1.00 | 0.98 | 0.80 | 1.79 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 186.19 ± 0.7% | 187.15 ± 2.6% | 218.13 ± 1.5% | 79.33 ± 3.2% | 185.13 ± 1.1% | 536.33 ± 4.6% | 3979.87 ± 1.6% | 186.47 ± 0.2% | 0.99 | 1.00 | 2.35 | 1.01 |
| a UUID | 62 | 121.57 ± 0.2% | 121.79 ± 0.4% | 135.18 ± 0.5% | 46.78 ± 2.0% | 89.97 ± 3.4% | 200.91 ± 10.5% | 4136.41 ± 1.0% | 121.62 ± 0.2% | 1.00 | 1.00 | 2.60 | 1.35 |
| an IPv4 address | 29 | 379.55 ± 1.6% | 381.69 ± 1.0% | 535.30 ± 0.7% | 69.87 ± 13.3% | 112.82 ± 3.5% | 319.31 ± 10.9% | 7160.04 ± 2.1% | 382.67 ± 1.2% | 0.99 | 0.99 | 5.43 | 3.36 |
| a date and time | 56 | 277.88 ± 0.4% | 279.06 ± 12.5% | 350.53 ± 0.2% | 67.84 ± 1.6% | 122.18 ± 1.7% | 375.03 ± 5.1% | 4248.07 ± 0.9% | 278.37 ± 0.2% | 1.00 | 1.00 | 4.10 | 2.27 |
| a field path | 39 | 184.66 ± 13.3% | 185.41 ± 0.5% | 215.27 ± 0.3% | 73.61 ± 2.2% | 172.57 ± 2.7% | 584.69 ± 31.0% | 4774.19 ± 0.8% | 184.72 ± 1.3% | 1.00 | 1.00 | 2.51 | 1.07 |
| literal: a word | 7 | 579.66 ± 0.4% | 622.70 ± 13.9% | 1103.63 ± 1.5% | 492.45 ± 1.8% | 583.24 ± 2.0% | 1251.11 ± 0.6% | 25161.46 ± 0.5% | 580.35 ± 0.5% | 0.93 | 1.00 | 1.18 | 0.99 |
| literal: a word that is not there | 8 | 553.21 ± 0.5% | 602.21 ± 0.5% | 1035.09 ± 4.9% | 455.04 ± 1.1% | 562.10 ± 4.8% | 1174.22 ± 1.1% | 23676.33 ± 0.4% | 554.37 ± 0.8% | 0.92 | 1.00 | 1.22 | 0.98 |
| literal: one of four words | 26 | 206.21 ± 0.3% | 358.20 ± 0.9% | 480.39 ± 1.3% | 41.75 ± 0.7% | 216.22 ± 2.0% | 450.16 ± 1.9% | 11548.12 ± 0.7% | 206.06 ± 1.0% | 0.58 | 1.00 | 4.94 | 0.95 |
| literal: a word in any case | 11 | 396.81 ± 9.8% | 418.61 ± 2.4% | 595.50 ± 2.5% | 14.51 ± 4.4% | 601.89 ± 3.9% | refused | 19282.89 ± 6.3% | 395.50 ± 2.5% | 0.95 | 1.00 | 27.35 | 0.66 |
| literal: an href attribute | 12 | 313.97 ± 2.4% | 323.94 ± 11.5% | 427.99 ± 10.0% | 37.51 ± 3.1% | 429.38 ± 2.0% | 922.07 ± 1.3% | 18848.71 ± 0.6% | 313.61 ± 1.3% | 0.97 | 1.00 | 8.37 | 0.73 |
| literal: a word, second text | 10 | 512.49 ± 12.7% | 563.08 ± 0.2% | 926.73 ± 0.9% | 405.64 ± 0.2% | 482.11 ± 2.7% | 996.87 ± 0.4% | 21623.34 ± 9.3% | 514.40 ± 0.4% | 0.91 | 1.00 | 1.26 | 1.06 |
| class: two capitalized words | 23 | 408.70 ± 0.6% | 439.25 ± 2.6% | 622.07 ± 4.7% | 95.25 ± 0.8% | 447.86 ± 5.9% | 929.36 ± 1.3% | 6394.62 ± 0.2% | 408.41 ± 1.0% | 0.93 | 1.00 | 4.29 | 0.91 |
| class: a word that ends in ing | 9 | 500.58 ± 0.7% | 559.26 ± 0.7% | 997.94 ± 0.6% | 113.85 ± 1.2% | 621.55 ± 2.6% | 1406.82 ± 0.4% | 15178.85 ± 0.4% | 500.17 ± 0.8% | 0.90 | 1.00 | 4.40 | 0.81 |
| class: a word in capitals | 16 | 424.46 ± 1.1% | 457.13 ± 0.3% | 762.17 ± 0.4% | 120.84 ± 1.6% | 649.92 ± 4.7% | 1282.76 ± 0.8% | 8394.56 ± 0.2% | 424.06 ± 1.0% | 0.93 | 1.00 | 3.51 | 0.65 |
| class: a number | 6 | 542.15 ± 3.8% | 595.54 ± 9.6% | 1152.98 ± 14.4% | 36.26 ± 1.4% | 1178.24 ± 1.4% | 2190.20 ± 4.3% | 20451.77 ± 0.1% | 542.81 ± 0.3% | 0.91 | 1.00 | 14.95 | 0.46 |
| class: two capitalized words, second text | 23 | 408.60 ± 0.8% | 440.31 ± 10.3% | 643.74 ± 3.5% | 95.71 ± 0.8% | 447.37 ± 13.1% | 901.13 ± 0.3% | 6400.74 ± 0.2% | 408.16 ± 1.2% | 0.93 | 1.00 | 4.27 | 0.91 |
| other: a word between two words | 13 | 495.87 ± 0.6% | 512.40 ± 13.0% | 809.18 ± 0.7% | 121.77 ± 2.6% | 436.76 ± 3.2% | 1044.74 ± 0.8% | 14084.24 ± 0.5% | 495.73 ± 0.7% | 0.97 | 1.00 | 4.07 | 1.14 |
| other: a number before a unit, second text | 15 | 356.27 ± 0.6% | 392.08 ± 0.6% | 547.08 ± 0.8% | 33.78 ± 0.3% | 540.04 ± 1.6% | 1118.27 ± 4.9% | 13900.41 ± 0.5% | 356.23 ± 0.6% | 0.91 | 1.00 | 10.55 | 0.66 |
| other: a heading's start tag | 13 | 324.09 ± 0.5% | 328.27 ± 1.1% | 436.91 ± 0.6% | 35.73 ± 0.6% | 527.36 ± 1.5% | 1079.96 ± 4.0% | 16307.84 ± 0.9% | 324.59 ± 0.3% | 0.99 | 1.00 | 9.07 | 0.61 |
| other: a whole word | 11 | 499.98 ± 12.3% | 528.64 ± 0.4% | 843.03 ± 0.7% | 110.09 ± 0.9% | 506.43 ± 1.5% | 1057.20 ± 0.7% | 20924.29 ± 18.2% | 500.38 ± 8.9% | 0.95 | 1.00 | 4.54 | 0.99 |
| other: a line's first word, second text | 17 | 474.08 ± 0.2% | 490.91 ± 11.5% | 811.11 ± 0.3% | 115.71 ± 0.2% | 589.35 ± 1.8% | refused | refused | 471.99 ± 0.5% | 0.97 | 1.00 | 4.10 | 0.80 |
| other: fourteen octets before an x | 16 | 85.73 ± 0.2% | 121.60 ± 0.4% | 140.26 ± 0.3% | 14.20 ± 0.5% | 392.95 ± 1.9% | 443.59 ± 0.7% | 11718.09 ± 0.7% | 85.59 ± 0.3% | 0.71 | 1.00 | 6.04 | 0.22 |
| other: a Greek word | 8 | 364.27 ± 0.8% | 514.16 ± 0.2% | 874.39 ± 11.3% | 46.93 ± 1.5% | 1151.23 ± 1.3% | 2181.87 ± 0.9% | refused | 364.70 ± 0.2% | 0.71 | 1.00 | 7.76 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21446.11 ± 0.9% | not timed | not timed | 26955.42 ± 3.6% | 2153.93 ± 25.4% | not timed | not timed | 21267.82 ± 0.9% | | 1.01 | 0.80 | 9.96 |
| 01-literal/sherlock-casei-en | 522 | 7590.04 ± 1.5% | not timed | not timed | 7047.84 ± 0.2% | 28.41 ± 0.2% | not timed | not timed | 7556.81 ± 0.9% | | 1.00 | 1.08 | 267.13 |
| 01-literal/sherlock-ru | 724 | 22958.34 ± 1.5% | not timed | not timed | 27658.40 ± 0.7% | 1075.83 ± 3.7% | not timed | not timed | 22781.66 ± 1.2% | | 1.01 | 0.83 | 21.34 |
| 01-literal/sherlock-casei-ru | 746 | 9437.54 ± 2.5% | not timed | not timed | 5512.37 ± 6.1% | 30.44 ± 0.9% | not timed | not timed | 9401.86 ± 0.7% | | 1.00 | 1.71 | 310.01 |
| 01-literal/sherlock-zh | 30 | 40443.15 ± 0.6% | not timed | not timed | 37005.36 ± 0.6% | 1258.56 ± 9.9% | not timed | not timed | 40440.66 ± 1.2% | | 1.00 | 1.09 | 32.13 |
| 02-literal-alternate/sherlock-en | 714 | 9565.27 ± 0.6% | not timed | not timed | 8903.65 ± 3.2% | 14.18 ± 4.1% | not timed | not timed | 9543.27 ± 14.9% | | 1.00 | 1.07 | 674.66 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1983.69 ± 0.4% | not timed | not timed | 1817.99 ± 0.5% | 9.30 ± 1.3% | not timed | not timed | 1964.54 ± 1.0% | | 1.01 | 1.09 | 213.36 |
| 02-literal-alternate/sherlock-ru | 899 | 7860.35 ± 0.5% | not timed | not timed | 4253.82 ± 0.2% | 19.44 ± 2.0% | not timed | not timed | 7838.19 ± 0.7% | | 1.00 | 1.85 | 404.32 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2055.72 ± 0.5% | not timed | not timed | 1044.65 ± 0.6% | 8.57 ± 0.6% | not timed | not timed | 2052.16 ± 0.2% | | 1.00 | 1.97 | 239.90 |
| 02-literal-alternate/sherlock-zh | 207 | 13968.45 ± 1.6% | not timed | not timed | 10447.53 ± 0.2% | 26.96 ± 2.4% | not timed | not timed | 13936.70 ± 0.5% | | 1.00 | 1.34 | 518.11 |
| 03-date/ascii | 111817 | 97.49 ± 2.8% | not timed | not timed | 84.81 ± 2.5% | 0.18 ± 1.3% | not timed | not timed | 98.20 ± 2.9% | | 0.99 | 1.15 | 542.68 |
| 04-ruff-noqa/real | 84 | 419.91 ± 0.5% | not timed | not timed | 426.86 ± 0.5% | 15.64 ± 1.6% | not timed | not timed | 419.75 ± 0.2% | | 1.00 | 0.98 | 26.85 |
| 04-ruff-noqa/tweaked | 44 | 476.50 ± 0.3% | not timed | not timed | 419.70 ± 0.3% | 294.07 ± 1.5% | not timed | not timed | 475.44 ± 1.5% | | 1.00 | 1.14 | 1.62 |
| 05-lexer-veryl/single | 124800 | 3.29 ± 1.0% | not timed | not timed | 4.10 ± 0.6% | 0.21 ± 2.3% | not timed | not timed | 3.25 ± 3.0% | | 1.01 | 0.80 | 15.65 |
| 06-cloud-flare-redos/original | 107 | 347.89 ± 0.3% | not timed | not timed | 192.62 ± 0.2% | 20.71 ± 1.3% | not timed | not timed | 347.45 ± 1.0% | | 1.00 | 1.81 | 16.80 |
| 06-cloud-flare-redos/simplified-short | 102 | 335.33 ± 1.1% | not timed | not timed | 192.44 ± 0.5% | 21.97 ± 0.3% | not timed | not timed | 334.31 ± 0.4% | | 1.00 | 1.74 | 15.26 |
| 06-cloud-flare-redos/simplified-long | 10000 | 465.53 ± 0.3% | not timed | not timed | 211.58 ± 0.2% | 24.17 ± 24.2% | not timed | not timed | 464.08 ± 0.1% | | 1.00 | 2.20 | 19.26 |
| 07-unicode-character-data/parse-line | 558784 | 198.44 ± 0.5% | not timed | not timed | 160.55 ± 1.5% | 35.25 ± 22.3% | not timed | not timed | 195.96 ± 1.4% | | 1.01 | 1.24 | 5.63 |
| 08-words/all-english | 56691 | 97.91 ± 0.9% | not timed | not timed | 73.58 ± 1.0% | 10.30 ± 7.4% | not timed | not timed | 97.27 ± 0.4% | | 1.01 | 1.33 | 9.51 |
| 08-words/long-english | 839 | 535.89 ± 0.3% | not timed | not timed | 513.76 ± 0.2% | 26.14 ± 3.3% | not timed | not timed | 536.09 ± 0.2% | | 1.00 | 1.04 | 20.50 |
| 09-aws-keys/full | 0 | 426.64 ± 1.2% | not timed | not timed | 439.10 ± 0.3% | 46.28 ± 3.6% | not timed | not timed | 426.15 ± 0.3% | | 1.00 | 0.97 | 9.22 |
| 09-aws-keys/quick | 0 | 786.79 ± 2.7% | not timed | not timed | 805.99 ± 3.8% | 330.31 ± 0.3% | not timed | not timed | 764.63 ± 0.5% | | 1.03 | 0.98 | 2.38 |
| 10-bounded-repeat/letters-en | 1833 | 487.16 ± 0.6% | not timed | not timed | 431.83 ± 2.7% | 16.89 ± 0.7% | not timed | not timed | 486.84 ± 0.3% | | 1.00 | 1.13 | 28.85 |
| 10-bounded-repeat/letters-ru | 3475 | 432.73 ± 1.1% | not timed | not timed | 409.04 ± 0.2% | 17.97 ± 35.3% | not timed | not timed | 430.78 ± 2.5% | | 1.00 | 1.06 | 24.07 |
| 10-bounded-repeat/context | 53 | 64.29 ± 4.2% | not timed | not timed | 56.10 ± 1.8% | 16.62 ± 1.8% | not timed | not timed | 63.87 ± 2.6% | | 1.01 | 1.15 | 3.87 |
| 10-bounded-repeat/capitals | 11 | 558.35 ± 7.0% | not timed | not timed | 530.96 ± 0.8% | 30.97 ± 0.3% | not timed | not timed | 557.67 ± 8.0% | | 1.00 | 1.05 | 18.03 |
| 11-unstructured-to-json/extract | 600 | 54.62 ± 21.2% | not timed | not timed | 61.94 ± 7.5% | 40.83 ± 1.3% | not timed | not timed | 54.71 ± 0.6% | | 1.00 | 0.88 | 1.34 |
| 12-dictionary/single | 1 | 463.86 ± 1.4% | not timed | not timed | 442.58 ± 1.4% | 0.31 ± 5.1% | not timed | not timed | 464.73 ± 0.3% | | 1.00 | 1.05 | 1516.69 |
| 14-quadratic/1x | 100 | 20.73 ± 4.2% | not timed | not timed | 9.12 ± 3.2% | 0.80 ± 1.5% | not timed | not timed | 20.70 ± 0.7% | | 1.00 | 2.27 | 25.92 |
| 14-quadratic/2x | 200 | 15.97 ± 0.5% | not timed | not timed | 4.92 ± 2.6% | 0.43 ± 1.4% | not timed | not timed | 16.02 ± 0.3% | | 1.00 | 3.24 | 36.76 |
| 14-quadratic/10x | 1000 | 5.62 ± 0.3% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 1.6% | not timed | not timed | 5.61 ± 14.0% | | 1.00 | 5.34 | 61.40 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.13 ± 1.4% | not timed | not timed | 0.39 ± 0.4% | 0.48 ± 3.4% | not timed | not timed | 1.13 ± 0.8% | | 1.00 | 2.93 | 2.34 |
| 04-ruff-noqa/compile-real | 1 | 79.07 ± 1.2% | not timed | not timed | 13.12 ± 0.5% | 126.95 ± 3.4% | not timed | not timed | 78.77 ± 0.8% | | 1.00 | 6.03 | 0.62 |
| 05-lexer-veryl/compile-single | 1 | 12.44 ± 1.1% | not timed | not timed | 2.37 ± 0.1% | 5.99 ± 0.4% | not timed | not timed | 12.40 ± 9.8% | | 1.00 | 5.25 | 2.08 |
| 07-unicode-character-data/compile | 1 | 48.92 ± 2.2% | not timed | not timed | 24.79 ± 0.9% | 33.42 ± 2.6% | not timed | not timed | 48.56 ± 1.3% | | 1.01 | 1.97 | 1.46 |
| 09-aws-keys/compile-full | 1 | 34.02 ± 0.3% | not timed | not timed | 7.45 ± 1.2% | 20.81 ± 1.2% | not timed | not timed | 33.22 ± 12.8% | | 1.02 | 4.57 | 1.64 |
| 09-aws-keys/compile-quick | 1 | 151.70 ± 0.3% | not timed | not timed | 44.96 ± 0.9% | 117.88 ± 4.5% | not timed | not timed | 148.64 ± 1.0% | | 1.02 | 3.37 | 1.29 |
| 10-bounded-repeat/compile-context | 1 | 10.38 ± 0.5% | not timed | not timed | 11.77 ± 0.6% | 15.25 ± 1.4% | not timed | not timed | 10.33 ± 1.6% | | 1.00 | 0.88 | 0.68 |
| 10-bounded-repeat/compile-capitals | 1 | 71.80 ± 0.3% | not timed | not timed | 8.89 ± 10.9% | 22.61 ± 11.5% | not timed | not timed | 71.73 ± 0.2% | | 1.00 | 8.08 | 3.18 |
| 11-unstructured-to-json/compile | 1 | 74.36 ± 0.2% | not timed | not timed | 37.26 ± 1.3% | 60.85 ± 2.4% | not timed | not timed | 72.55 ± 2.2% | | 1.03 | 2.00 | 1.22 |
| 12-dictionary/compile-single | 1 | 0.29 ± 0.1% | not timed | not timed | 0.07 ± 16.9% | 0.08 ± 15.4% | not timed | not timed | 0.29 ± 0.8% | | 1.01 | 4.19 | 3.56 |

