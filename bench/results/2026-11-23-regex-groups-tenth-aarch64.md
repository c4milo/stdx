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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215399884 |
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
| literal: a word | 217 | 16184.30 ± 1.8% | 4994.33 ± 0.2% | 27.52 ± 0.3% | 18274.55 ± 0.6% | 9013.65 ± 10.4% | 17.46 ± 0.4% | 84.04 ± 0.8% | 16183.14 ± 1.7% | 3.24 | 1.00 | 0.89 | 1.80 |
| literal: a word that is not there | 0 | 18862.96 ± 1.1% | 4880.81 ± 0.3% | 27.58 ± 0.2% | 19903.79 ± 3.7% | 29135.47 ± 0.9% | 17.28 ± 0.3% | 79.62 ± 1.9% | 18896.25 ± 1.2% | 3.86 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6083.03 ± 0.6% | 1934.89 ± 0.4% | 14.13 ± 0.3% | 3944.51 ± 0.3% | 21.90 ± 0.1% | 5.25 ± 0.3% | 6.89 ± 0.7% | 6073.67 ± 0.3% | 3.14 | 1.00 | 1.54 | 277.82 |
| literal: a word in any case | 217 | 12603.27 ± 0.2% | 2072.71 ± 0.2% | 20.69 ± 0.2% | 3971.96 ± 0.1% | 36.80 ± 1.1% | refused | differs | 12580.94 ± 0.2% | 6.08 | 1.00 | 3.17 | 342.52 |
| literal: an href attribute | 33 | 13691.42 ± 0.4% | 615.91 ± 0.1% | 26.40 ± 0.1% | 17037.33 ± 1.9% | 2250.27 ± 1.3% | 12.93 ± 1.0% | 73.82 ± 0.3% | 13668.24 ± 0.6% | 22.23 | 1.00 | 0.80 | 6.08 |
| literal: a word, second text | 123 | 16542.99 ± 0.9% | 3355.33 ± 0.2% | 27.17 ± 0.3% | 18397.24 ± 3.3% | 7602.38 ± 4.6% | 19.28 ± 0.3% | 70.13 ± 0.7% | 16530.84 ± 1.5% | 4.93 | 1.00 | 0.90 | 2.18 |
| class: two capitalized words | 1331 | 1063.97 ± 0.4% | 603.15 ± 0.2% | 25.22 ± 0.1% | 582.12 ± 0.1% | 40.55 ± 3.3% | 14.94 ± 0.5% | 67.46 ± 0.2% | 1062.44 ± 0.3% | 1.76 | 1.00 | 1.83 | 26.24 |
| class: a word that ends in ing | 3399 | 579.77 ± 0.1% | 578.63 ± 0.2% | 17.67 ± 0.2% | 545.61 ± 0.1% | 29.51 ± 10.8% | 8.15 ± 0.1% | 18.37 ± 0.2% | 579.42 ± 0.1% | 1.00 | 1.00 | 1.06 | 19.64 |
| class: a word in capitals | 2332 | 1374.50 ± 0.5% | 614.83 ± 0.1% | 26.81 ± 0.1% | 572.79 ± 0.1% | 42.98 ± 0.5% | 17.14 ± 0.3% | 82.42 ± 0.8% | 1372.47 ± 0.3% | 2.24 | 1.00 | 2.40 | 31.98 |
| class: a number | 8288 | 1998.56 ± 0.4% | 833.50 ± 0.1% | 27.12 ± 0.2% | 1731.86 ± 0.3% | 39.85 ± 9.7% | 0.52 ± 1.0% | 57.53 ± 0.4% | 1996.07 ± 0.2% | 2.40 | 1.00 | 1.15 | 50.16 |
| class: two capitalized words, second text | 5359 | 521.38 ± 0.2% | 528.27 ± 0.1% | 22.50 ± 0.1% | 486.96 ± 0.1% | 32.62 ± 14.1% | 16.87 ± 0.2% | 62.98 ± 0.3% | 521.33 ± 0.1% | 0.99 | 1.00 | 1.07 | 15.98 |
| other: a word between two words | 6104 | 742.09 ± 0.2% | 598.01 ± 0.1% | 22.94 ± 0.1% | 734.48 ± 0.3% | 107.87 ± 12.4% | 11.34 ± 0.3% | 68.20 ± 0.6% | 741.95 ± 0.0% | 1.24 | 1.00 | 1.01 | 6.88 |
| other: a number before a unit, second text | 1481 | 5334.39 ± 1.1% | 1109.84 ± 0.2% | 25.37 ± 0.1% | 5676.26 ± 0.4% | 40.60 ± 4.1% | 17.83 ± 0.2% | 65.79 ± 0.8% | 5311.31 ± 0.4% | 4.81 | 1.00 | 0.94 | 131.38 |
| other: a heading's start tag | 110 | 12511.47 ± 0.8% | 750.51 ± 0.1% | 26.62 ± 0.2% | 1709.97 ± 0.5% | 1574.21 ± 5.6% | 16.22 ± 0.5% | 86.08 ± 0.4% | 12530.74 ± 1.1% | 16.67 | 1.00 | 7.32 | 7.95 |
| other: a whole word | 217 | 13968.16 ± 0.4% | 607.79 ± 0.1% | 28.67 ± 0.1% | 14684.40 ± 0.8% | 47.62 ± 0.1% | 13.58 ± 0.3% | 54.93 ± 0.4% | 13967.69 ± 0.8% | 22.98 | 1.00 | 0.95 | 293.31 |
| other: a line's first word, second text | 3716 | 1954.21 ± 0.4% | 594.06 ± 0.1% | 30.03 ± 0.1% | 1736.71 ± 0.8% | 61.50 ± 8.1% | refused | refused | 1943.69 ± 1.1% | 3.29 | 1.01 | 1.13 | 31.77 |
| other: fourteen octets before an x | 87 | 19604.66 ± 0.8% | 240.45 ± 0.6% | 6.27 ± 0.0% | 3969.80 ± 0.6% | 10.61 ± 0.2% | differs | 17.76 ± 0.1% | 19528.20 ± 0.5% | 81.53 | 1.00 | 4.94 | 1848.15 |
| other: a Greek word | 21815 | 501.85 ± 0.8% | 412.86 ± 0.3% | 30.40 ± 0.2% | 289.45 ± 0.1% | 45.37 ± 13.8% | differs | refused | 498.83 ± 0.7% | 1.22 | 1.01 | 1.73 | 11.06 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.84 ± 0.2% | 19.89 ± 0.2% | 0.85 ± 0.1% | 19.56 ± 0.2% | 2.78 ± 0.3% | differs | 4.05 ± 0.3% | 19.88 ± 0.4% | 1.00 | 1.00 | 1.01 | 7.13 |
| a UUID | 32895 | 21.31 ± 0.2% | 21.32 ± 0.2% | 0.64 ± 0.2% | 15.12 ± 0.4% | 3.08 ± 0.7% | 0.72 ± 0.3% | 3.64 ± 0.4% | 21.32 ± 0.1% | 1.00 | 1.00 | 1.41 | 6.91 |
| an IPv4 address | 33176 | 36.84 ± 0.4% | 36.80 ± 0.4% | 2.06 ± 0.1% | 28.93 ± 0.4% | 6.65 ± 0.3% | differs | 4.14 ± 0.0% | 36.84 ± 0.4% | 1.00 | 1.00 | 1.27 | 5.54 |
| a date and time | 32954 | 31.45 ± 0.1% | 31.45 ± 0.2% | 1.41 ± 0.4% | 21.36 ± 0.3% | 7.03 ± 0.1% | 1.19 ± 0.2% | 7.14 ± 0.6% | 31.43 ± 0.2% | 1.00 | 1.00 | 1.47 | 4.47 |
| a field path | 32606 | 23.50 ± 0.1% | 23.55 ± 0.1% | 1.00 ± 0.5% | 23.14 ± 0.1% | 3.51 ± 0.6% | differs | 2.96 ± 0.2% | 23.52 ± 0.2% | 1.00 | 1.00 | 1.02 | 6.70 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.13 ± 0.2% | 11.10 ± 0.2% | 11.13 ± 0.3% | 11.36 ± 0.1% | 4.90 ± 2.1% | 0.90 ± 0.7% | none | 11.11 ± 0.5% | 1.00 | 1.00 | 0.98 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.70 ± 0.4% | 235.18 ± 0.3% | 276.46 ± 0.4% | 87.25 ± 0.3% | 217.01 ± 1.7% | 485.60 ± 0.6% | 3797.00 ± 0.5% | 234.53 ± 0.4% | 1.00 | 1.00 | 2.69 | 1.08 |
| a UUID | 62 | 151.94 ± 0.3% | 152.23 ± 0.6% | 169.37 ± 0.1% | 46.44 ± 0.3% | 96.78 ± 1.4% | 184.65 ± 2.5% | 4217.72 ± 0.4% | 151.93 ± 0.4% | 1.00 | 1.00 | 3.27 | 1.57 |
| an IPv4 address | 29 | 428.25 ± 0.4% | 431.57 ± 0.1% | 594.26 ± 0.4% | 77.01 ± 0.6% | 127.42 ± 2.8% | 291.43 ± 0.9% | 7534.36 ± 0.7% | 428.43 ± 0.4% | 0.99 | 1.00 | 5.56 | 3.36 |
| a date and time | 56 | 300.63 ± 0.1% | 301.73 ± 0.3% | 372.46 ± 0.2% | 73.12 ± 0.6% | 132.28 ± 1.6% | 319.24 ± 1.3% | 4892.00 ± 0.5% | 300.68 ± 0.2% | 1.00 | 1.00 | 4.11 | 2.27 |
| a field path | 39 | 227.57 ± 0.6% | 228.27 ± 0.4% | 266.84 ± 0.3% | 80.72 ± 0.5% | 199.20 ± 1.7% | 508.46 ± 2.1% | 4858.28 ± 0.2% | 227.43 ± 0.5% | 1.00 | 1.00 | 2.82 | 1.14 |
| literal: a word | 7 | 638.41 ± 0.7% | 681.31 ± 0.5% | 1180.83 ± 0.2% | 520.55 ± 0.3% | 619.65 ± 1.6% | 949.73 ± 0.5% | 30402.05 ± 0.1% | 637.59 ± 0.4% | 0.94 | 1.00 | 1.23 | 1.03 |
| literal: a word that is not there | 8 | 612.47 ± 0.7% | 660.81 ± 0.7% | 1116.31 ± 0.9% | 469.40 ± 0.2% | 591.67 ± 1.4% | 901.98 ± 0.5% | 29091.28 ± 0.2% | 611.72 ± 0.5% | 0.93 | 1.00 | 1.30 | 1.04 |
| literal: one of four words | 26 | 248.86 ± 0.4% | 405.15 ± 0.3% | 542.94 ± 0.4% | 49.29 ± 0.7% | 233.03 ± 1.5% | 368.63 ± 2.6% | 15902.77 ± 0.2% | 249.12 ± 0.2% | 0.61 | 1.00 | 5.05 | 1.07 |
| literal: a word in any case | 11 | 455.71 ± 0.3% | 484.31 ± 0.6% | 700.58 ± 0.2% | 15.63 ± 0.2% | 632.87 ± 2.4% | refused | 23716.38 ± 0.4% | 455.44 ± 0.4% | 0.94 | 1.00 | 29.15 | 0.72 |
| literal: an href attribute | 12 | 346.75 ± 0.3% | 357.23 ± 0.3% | 461.50 ± 0.4% | 45.59 ± 0.9% | 482.29 ± 4.0% | 777.82 ± 0.9% | 21505.32 ± 0.4% | 346.60 ± 0.4% | 0.97 | 1.00 | 7.61 | 0.72 |
| literal: a word, second text | 10 | 565.97 ± 0.9% | 618.62 ± 0.5% | 1007.17 ± 0.5% | 421.98 ± 0.8% | 522.26 ± 2.1% | 815.25 ± 0.5% | 26958.06 ± 0.2% | 565.83 ± 0.8% | 0.91 | 1.00 | 1.34 | 1.08 |
| class: two capitalized words | 23 | 442.80 ± 0.6% | 471.01 ± 0.7% | 669.11 ± 0.9% | 100.91 ± 0.2% | 497.02 ± 2.5% | 750.24 ± 0.5% | 6454.98 ± 0.4% | 443.41 ± 0.3% | 0.94 | 1.00 | 4.39 | 0.89 |
| class: a word that ends in ing | 9 | 573.17 ± 0.5% | 638.33 ± 0.6% | 1088.59 ± 0.2% | 131.99 ± 1.0% | 757.32 ± 2.0% | 1110.19 ± 2.2% | 15867.47 ± 0.1% | 573.75 ± 0.5% | 0.90 | 1.00 | 4.34 | 0.76 |
| class: a word in capitals | 16 | 503.33 ± 0.3% | 541.55 ± 0.2% | 854.24 ± 0.3% | 135.91 ± 0.4% | 753.61 ± 0.7% | 1022.05 ± 0.3% | 8524.08 ± 0.3% | 502.66 ± 1.3% | 0.93 | 1.00 | 3.70 | 0.67 |
| class: a number | 6 | 641.49 ± 0.4% | 704.92 ± 0.5% | 1297.96 ± 0.1% | 41.87 ± 0.5% | 1393.90 ± 2.7% | 1917.13 ± 1.2% | 22683.82 ± 0.1% | 641.69 ± 0.3% | 0.91 | 1.00 | 15.32 | 0.46 |
| class: two capitalized words, second text | 23 | 442.18 ± 0.2% | 471.68 ± 0.2% | 669.51 ± 0.2% | 104.03 ± 0.5% | 494.79 ± 1.9% | 739.12 ± 0.5% | 6455.75 ± 0.2% | 442.32 ± 0.3% | 0.94 | 1.00 | 4.25 | 0.89 |
| other: a word between two words | 13 | 554.30 ± 0.4% | 571.81 ± 0.3% | 890.67 ± 0.3% | 134.61 ± 0.9% | 492.53 ± 3.3% | 815.39 ± 1.0% | 14765.55 ± 0.6% | 554.88 ± 0.4% | 0.97 | 1.00 | 4.12 | 1.13 |
| other: a number before a unit, second text | 15 | 405.74 ± 0.6% | 441.19 ± 0.4% | 615.11 ± 0.3% | 39.38 ± 0.5% | 620.66 ± 2.0% | 893.56 ± 0.2% | 15086.45 ± 0.2% | 405.39 ± 0.5% | 0.92 | 1.00 | 10.30 | 0.65 |
| other: a heading's start tag | 13 | 358.64 ± 0.3% | 364.01 ± 0.4% | 474.31 ± 0.2% | 44.42 ± 0.7% | 619.11 ± 2.3% | 866.92 ± 0.2% | 17915.08 ± 0.3% | 358.37 ± 0.3% | 0.99 | 1.00 | 8.07 | 0.58 |
| other: a whole word | 11 | 587.57 ± 0.4% | 622.24 ± 0.8% | 1021.69 ± 0.4% | 121.61 ± 0.7% | 555.25 ± 2.7% | 820.28 ± 1.3% | 26936.92 ± 0.2% | 588.53 ± 0.2% | 0.94 | 1.00 | 4.83 | 1.06 |
| other: a line's first word, second text | 17 | 543.66 ± 0.4% | 562.85 ± 0.5% | 890.05 ± 0.1% | 129.67 ± 0.2% | 690.42 ± 1.9% | refused | refused | 541.43 ± 0.8% | 0.97 | 1.00 | 4.19 | 0.79 |
| other: fourteen octets before an x | 16 | 109.14 ± 0.7% | 156.45 ± 0.4% | 177.98 ± 0.3% | 14.96 ± 0.4% | 439.27 ± 2.2% | 405.83 ± 0.6% | 12744.94 ± 2.6% | 109.03 ± 0.4% | 0.70 | 1.00 | 7.30 | 0.25 |
| other: a Greek word | 8 | 460.52 ± 0.2% | 610.16 ± 0.7% | 1015.06 ± 0.2% | 59.11 ± 0.2% | 1369.91 ± 1.0% | 1841.95 ± 0.7% | refused | 460.43 ± 0.4% | 0.75 | 1.00 | 7.79 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12706.21 ± 1.1% | not timed | not timed | 16042.20 ± 1.1% | 2100.73 ± 16.5% | not timed | not timed | 12717.53 ± 0.6% | | 1.00 | 0.79 | 6.05 |
| 01-literal/sherlock-casei-en | 522 | 4944.41 ± 0.7% | not timed | not timed | 3589.19 ± 0.2% | 32.02 ± 0.4% | not timed | not timed | 4939.37 ± 0.1% | | 1.00 | 1.38 | 154.41 |
| 01-literal/sherlock-ru | 724 | 13532.59 ± 0.6% | not timed | not timed | 17294.99 ± 0.4% | 1370.46 ± 24.3% | not timed | not timed | 13501.10 ± 0.3% | | 1.00 | 0.78 | 9.87 |
| 01-literal/sherlock-casei-ru | 746 | 5962.77 ± 0.4% | not timed | not timed | 3334.53 ± 0.1% | 31.27 ± 1.8% | not timed | not timed | 5964.24 ± 0.4% | | 1.00 | 1.79 | 190.67 |
| 01-literal/sherlock-zh | 30 | 17090.48 ± 0.3% | not timed | not timed | 18564.22 ± 1.0% | 2790.22 ± 9.5% | not timed | not timed | 17029.47 ± 0.5% | | 1.00 | 0.92 | 6.13 |
| 02-literal-alternate/sherlock-en | 714 | 5753.52 ± 0.4% | not timed | not timed | 3932.45 ± 0.1% | 16.63 ± 0.3% | not timed | not timed | 5756.98 ± 0.2% | | 1.00 | 1.46 | 346.03 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1799.23 ± 1.2% | not timed | not timed | 694.95 ± 0.2% | 10.97 ± 0.1% | not timed | not timed | 1790.10 ± 0.4% | | 1.01 | 2.59 | 164.09 |
| 02-literal-alternate/sherlock-ru | 899 | 5319.71 ± 0.2% | not timed | not timed | 3264.50 ± 0.2% | 22.68 ± 0.2% | not timed | not timed | 5324.70 ± 0.1% | | 1.00 | 1.63 | 234.56 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1915.54 ± 0.6% | not timed | not timed | 1230.84 ± 0.1% | 9.15 ± 0.3% | not timed | not timed | 1910.87 ± 0.2% | | 1.00 | 1.56 | 209.44 |
| 02-literal-alternate/sherlock-zh | 207 | 7053.34 ± 0.5% | not timed | not timed | 4160.61 ± 0.2% | 31.49 ± 0.2% | not timed | not timed | 7040.84 ± 0.5% | | 1.00 | 1.70 | 224.00 |
| 03-date/ascii | 111817 | 126.80 ± 0.6% | not timed | not timed | 95.74 ± 0.4% | 0.20 ± 4.9% | not timed | not timed | 126.05 ± 0.5% | | 1.01 | 1.32 | 636.75 |
| 04-ruff-noqa/real | 84 | 409.96 ± 0.1% | not timed | not timed | 462.78 ± 0.1% | 19.68 ± 1.2% | not timed | not timed | 408.03 ± 0.0% | | 1.00 | 0.89 | 20.83 |
| 04-ruff-noqa/tweaked | 44 | 552.51 ± 0.2% | not timed | not timed | 462.48 ± 0.1% | 361.80 ± 0.9% | not timed | not timed | 551.76 ± 0.1% | | 1.00 | 1.19 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.23 ± 0.4% | not timed | not timed | 5.00 ± 0.3% | 0.20 ± 3.0% | not timed | not timed | 5.08 ± 2.7% | | 1.03 | 1.05 | 25.69 |
| 06-cloud-flare-redos/original | 107 | 415.10 ± 0.4% | not timed | not timed | 214.65 ± 0.1% | 24.71 ± 5.6% | not timed | not timed | 413.26 ± 10.1% | | 1.00 | 1.93 | 16.80 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.81 ± 0.2% | not timed | not timed | 226.64 ± 0.2% | 26.77 ± 1.4% | not timed | not timed | 410.18 ± 0.5% | | 1.00 | 1.81 | 15.35 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.64 ± 0.2% | not timed | not timed | 253.81 ± 0.6% | 28.81 ± 0.2% | not timed | not timed | 586.79 ± 0.1% | | 1.00 | 2.32 | 20.40 |
| 07-unicode-character-data/parse-line | 558784 | 236.46 ± 0.6% | not timed | not timed | 171.73 ± 0.2% | 42.39 ± 0.9% | not timed | not timed | 236.42 ± 0.3% | | 1.00 | 1.38 | 5.58 |
| 08-words/all-english | 56691 | 117.14 ± 0.8% | not timed | not timed | 83.12 ± 0.2% | 11.84 ± 9.8% | not timed | not timed | 116.84 ± 0.5% | | 1.00 | 1.41 | 9.89 |
| 08-words/long-english | 839 | 621.34 ± 0.2% | not timed | not timed | 597.61 ± 0.1% | 32.31 ± 0.3% | not timed | not timed | 620.94 ± 0.1% | | 1.00 | 1.04 | 19.23 |
| 09-aws-keys/full | 0 | 415.92 ± 0.1% | not timed | not timed | 465.31 ± 0.1% | 64.13 ± 0.1% | not timed | not timed | 415.68 ± 0.1% | | 1.00 | 0.89 | 6.49 |
| 09-aws-keys/quick | 0 | 739.97 ± 0.3% | not timed | not timed | 987.55 ± 0.4% | 417.74 ± 1.2% | not timed | not timed | 736.42 ± 0.2% | | 1.00 | 0.75 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 582.66 ± 2.5% | not timed | not timed | 518.26 ± 0.3% | 19.56 ± 0.5% | not timed | not timed | 580.23 ± 1.9% | | 1.00 | 1.12 | 29.78 |
| 10-bounded-repeat/letters-ru | 3475 | 486.85 ± 1.1% | not timed | not timed | 476.96 ± 0.1% | 21.82 ± 10.1% | not timed | not timed | 506.46 ± 1.4% | | 0.96 | 1.02 | 22.31 |
| 10-bounded-repeat/context | 53 | 77.49 ± 0.6% | not timed | not timed | 65.74 ± 1.0% | 19.81 ± 0.2% | not timed | not timed | 77.45 ± 0.6% | | 1.00 | 1.18 | 3.91 |
| 10-bounded-repeat/capitals | 11 | 631.17 ± 8.4% | not timed | not timed | 618.48 ± 0.1% | 36.66 ± 0.0% | not timed | not timed | 630.70 ± 8.5% | | 1.00 | 1.02 | 17.22 |
| 11-unstructured-to-json/extract | 600 | 82.98 ± 0.2% | not timed | not timed | 77.76 ± 0.2% | 48.91 ± 1.0% | not timed | not timed | 82.86 ± 0.6% | | 1.00 | 1.07 | 1.70 |
| 12-dictionary/single | 1 | 560.98 ± 0.3% | not timed | not timed | 560.22 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 559.78 ± 0.1% | | 1.00 | 1.00 | 1384.26 |
| 14-quadratic/1x | 100 | 21.53 ± 0.8% | not timed | not timed | 10.01 ± 0.4% | 0.97 ± 3.6% | not timed | not timed | 21.41 ± 1.4% | | 1.01 | 2.15 | 22.15 |
| 14-quadratic/2x | 200 | 17.71 ± 3.6% | not timed | not timed | 5.54 ± 0.3% | 0.53 ± 1.9% | not timed | not timed | 17.65 ± 3.2% | | 1.00 | 3.20 | 33.65 |
| 14-quadratic/10x | 1000 | 7.71 ± 2.1% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 7.67 ± 0.4% | | 1.01 | 6.35 | 66.70 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 0.1% | not timed | not timed | 0.34 ± 0.7% | 0.54 ± 2.1% | not timed | not timed | 1.27 ± 3.1% | | 1.00 | 3.70 | 2.37 |
| 04-ruff-noqa/compile-real | 1 | 92.91 ± 1.7% | not timed | not timed | 13.76 ± 0.2% | 132.35 ± 4.9% | not timed | not timed | 92.33 ± 1.2% | | 1.01 | 6.75 | 0.70 |
| 05-lexer-veryl/compile-single | 1 | 13.79 ± 0.3% | not timed | not timed | 2.51 ± 0.4% | 6.24 ± 3.1% | not timed | not timed | 13.68 ± 0.9% | | 1.01 | 5.50 | 2.21 |
| 07-unicode-character-data/compile | 1 | 55.22 ± 0.3% | not timed | not timed | 26.10 ± 0.3% | 34.57 ± 4.3% | not timed | not timed | 54.85 ± 1.4% | | 1.01 | 2.12 | 1.60 |
| 09-aws-keys/compile-full | 1 | 41.91 ± 0.2% | not timed | not timed | 8.22 ± 0.5% | 22.44 ± 2.0% | not timed | not timed | 41.63 ± 2.4% | | 1.01 | 5.10 | 1.87 |
| 09-aws-keys/compile-quick | 1 | 188.75 ± 0.2% | not timed | not timed | 47.25 ± 0.2% | 129.48 ± 3.6% | not timed | not timed | 187.52 ± 1.2% | | 1.01 | 4.00 | 1.46 |
| 10-bounded-repeat/compile-context | 1 | 13.97 ± 0.5% | not timed | not timed | 11.18 ± 0.4% | 15.70 ± 3.4% | not timed | not timed | 13.92 ± 1.3% | | 1.00 | 1.25 | 0.89 |
| 10-bounded-repeat/compile-capitals | 1 | 83.73 ± 0.4% | not timed | not timed | 8.03 ± 0.2% | 22.85 ± 3.5% | not timed | not timed | 83.79 ± 0.9% | | 1.00 | 10.43 | 3.66 |
| 11-unstructured-to-json/compile | 1 | 86.66 ± 0.5% | not timed | not timed | 41.04 ± 0.4% | 64.51 ± 5.1% | not timed | not timed | 86.19 ± 1.2% | | 1.01 | 2.11 | 1.34 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 1.3% | 0.10 ± 3.7% | not timed | not timed | 0.35 ± 1.2% | | 1.01 | 5.22 | 3.68 |

