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
| literal: a word | 217 | 16303.03 ± 1.4% | 4996.06 ± 0.2% | 27.52 ± 0.3% | 18353.23 ± 0.9% | 9156.94 ± 10.4% | 17.49 ± 0.3% | 84.15 ± 0.4% | 16340.37 ± 1.3% | 3.26 | 1.00 | 0.89 | 1.78 |
| literal: a word that is not there | 0 | 18782.68 ± 1.4% | 4879.59 ± 0.5% | 27.56 ± 0.1% | 19843.96 ± 1.9% | 28947.96 ± 2.0% | 17.29 ± 0.3% | 79.87 ± 0.5% | 18847.53 ± 1.1% | 3.85 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6096.02 ± 0.4% | 1933.03 ± 0.3% | 14.13 ± 0.2% | 3940.99 ± 0.2% | 21.88 ± 0.1% | 5.25 ± 0.2% | 6.87 ± 0.3% | 6082.65 ± 0.3% | 3.15 | 1.00 | 1.55 | 278.60 |
| literal: a word in any case | 217 | 12634.82 ± 0.4% | 2072.40 ± 0.2% | 20.69 ± 0.1% | 3972.39 ± 0.3% | 36.81 ± 0.3% | refused | differs | 12629.64 ± 0.3% | 6.10 | 1.00 | 3.18 | 343.24 |
| literal: an href attribute | 33 | 13738.49 ± 0.9% | 616.07 ± 0.1% | 26.42 ± 0.4% | 17038.21 ± 1.4% | 2249.88 ± 0.2% | 13.33 ± 0.3% | 73.95 ± 0.3% | 13695.82 ± 0.4% | 22.30 | 1.00 | 0.81 | 6.11 |
| literal: a word, second text | 123 | 16521.19 ± 0.8% | 3356.41 ± 0.3% | 27.13 ± 0.2% | 18324.48 ± 2.2% | 7698.83 ± 5.4% | 19.61 ± 0.4% | 70.04 ± 0.5% | 16530.83 ± 1.0% | 4.92 | 1.00 | 0.90 | 2.15 |
| class: two capitalized words | 1331 | 1062.53 ± 0.5% | 603.76 ± 0.1% | 25.25 ± 0.2% | 585.76 ± 0.1% | 40.49 ± 7.4% | 14.80 ± 0.2% | 67.55 ± 1.8% | 1061.56 ± 0.4% | 1.76 | 1.00 | 1.81 | 26.24 |
| class: a word that ends in ing | 3399 | 580.30 ± 0.2% | 578.58 ± 0.2% | 17.68 ± 0.2% | 548.04 ± 0.1% | 29.59 ± 2.0% | 8.19 ± 0.2% | 18.37 ± 0.3% | 579.90 ± 0.2% | 1.00 | 1.00 | 1.06 | 19.61 |
| class: a word in capitals | 2332 | 1373.22 ± 0.2% | 613.44 ± 0.1% | 26.80 ± 0.2% | 572.52 ± 0.2% | 43.23 ± 13.3% | 16.98 ± 0.2% | 82.33 ± 0.8% | 1372.70 ± 0.3% | 2.24 | 1.00 | 2.40 | 31.77 |
| class: a number | 8288 | 2001.45 ± 0.5% | 833.68 ± 0.1% | 27.14 ± 0.1% | 1730.09 ± 0.5% | 41.33 ± 15.3% | 0.56 ± 0.1% | 57.50 ± 0.8% | 1999.91 ± 0.3% | 2.40 | 1.00 | 1.16 | 48.42 |
| class: two capitalized words, second text | 5359 | 521.74 ± 0.2% | 528.13 ± 0.1% | 22.62 ± 0.2% | 485.72 ± 0.1% | 35.32 ± 14.3% | 16.66 ± 0.1% | 62.99 ± 1.3% | 521.27 ± 0.2% | 0.99 | 1.00 | 1.07 | 14.77 |
| other: a word between two words | 6104 | 742.66 ± 0.2% | 598.09 ± 0.2% | 22.96 ± 0.3% | 732.63 ± 0.2% | 111.34 ± 16.3% | 11.29 ± 0.1% | 68.14 ± 0.6% | 742.85 ± 0.0% | 1.24 | 1.00 | 1.01 | 6.67 |
| other: a number before a unit, second text | 1481 | 5346.50 ± 0.6% | 1109.42 ± 0.2% | 25.34 ± 0.2% | 5677.55 ± 0.4% | 40.55 ± 0.2% | 17.77 ± 0.1% | 65.67 ± 0.2% | 5304.71 ± 0.5% | 4.82 | 1.01 | 0.94 | 131.85 |
| other: a heading's start tag | 110 | 12556.87 ± 0.6% | 750.58 ± 0.1% | 26.62 ± 0.2% | 1707.30 ± 0.2% | 1576.04 ± 4.9% | 16.21 ± 0.6% | 85.97 ± 0.4% | 12547.98 ± 0.4% | 16.73 | 1.00 | 7.35 | 7.97 |
| other: a whole word | 217 | 14004.31 ± 1.2% | 608.08 ± 0.1% | 28.65 ± 0.2% | 14739.75 ± 0.4% | 47.64 ± 0.4% | 13.63 ± 0.2% | 54.97 ± 0.9% | 14086.20 ± 0.4% | 23.03 | 0.99 | 0.95 | 293.94 |
| other: a line's first word, second text | 3716 | 1954.37 ± 0.3% | 594.05 ± 0.1% | 29.99 ± 0.3% | 1720.84 ± 0.6% | 62.39 ± 3.3% | refused | refused | 1946.60 ± 0.8% | 3.29 | 1.00 | 1.14 | 31.33 |
| other: fourteen octets before an x | 87 | 19961.57 ± 0.9% | 244.39 ± 0.3% | 6.27 ± 0.1% | 3997.43 ± 0.4% | 10.60 ± 0.2% | differs | 17.70 ± 0.3% | 19789.10 ± 0.8% | 81.68 | 1.01 | 4.99 | 1882.37 |
| other: a Greek word | 21815 | 500.34 ± 0.9% | 412.64 ± 0.3% | 30.40 ± 0.1% | 289.32 ± 0.5% | 47.46 ± 6.4% | differs | refused | 497.99 ± 1.0% | 1.21 | 1.00 | 1.73 | 10.54 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.81 ± 0.1% | 19.84 ± 0.3% | 0.85 ± 0.2% | 19.83 ± 0.2% | 2.76 ± 1.0% | differs | 4.04 ± 0.2% | 19.87 ± 0.3% | 1.00 | 1.00 | 1.00 | 7.18 |
| a UUID | 32895 | 21.26 ± 0.3% | 21.29 ± 0.3% | 0.64 ± 0.3% | 15.19 ± 0.6% | 3.10 ± 0.2% | 0.72 ± 0.1% | 3.63 ± 0.9% | 21.30 ± 0.2% | 1.00 | 1.00 | 1.40 | 6.86 |
| an IPv4 address | 33176 | 36.86 ± 0.3% | 36.78 ± 0.4% | 2.06 ± 0.7% | 29.01 ± 0.3% | 6.63 ± 0.1% | differs | 4.14 ± 0.1% | 36.79 ± 0.3% | 1.00 | 1.00 | 1.27 | 5.56 |
| a date and time | 32954 | 31.43 ± 0.2% | 31.43 ± 0.5% | 1.41 ± 0.4% | 21.17 ± 0.1% | 7.05 ± 0.1% | 1.20 ± 0.1% | 7.16 ± 0.1% | 31.41 ± 0.2% | 1.00 | 1.00 | 1.48 | 4.46 |
| a field path | 32606 | 23.47 ± 0.2% | 23.50 ± 0.2% | 1.00 ± 0.6% | 23.07 ± 0.2% | 3.48 ± 1.4% | differs | 2.96 ± 0.2% | 23.50 ± 0.2% | 1.00 | 1.00 | 1.02 | 6.75 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.14 ± 0.3% | 11.11 ± 0.2% | 11.13 ± 0.1% | 11.44 ± 0.2% | 4.90 ± 1.8% | 0.91 ± 0.4% | none | 11.11 ± 0.2% | 1.00 | 1.00 | 0.97 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.37 ± 0.4% | 236.33 ± 0.3% | 277.86 ± 0.2% | 86.18 ± 0.7% | 221.46 ± 0.7% | 485.97 ± 1.1% | 3788.36 ± 0.6% | 235.39 ± 0.4% | 1.00 | 1.00 | 2.73 | 1.06 |
| a UUID | 62 | 152.19 ± 0.3% | 152.34 ± 0.4% | 168.85 ± 0.3% | 46.17 ± 0.5% | 98.79 ± 0.7% | 188.05 ± 3.6% | 4218.73 ± 0.3% | 152.17 ± 0.2% | 1.00 | 1.00 | 3.30 | 1.54 |
| an IPv4 address | 29 | 430.60 ± 0.3% | 434.29 ± 0.6% | 598.09 ± 0.7% | 76.20 ± 0.3% | 131.14 ± 0.9% | 299.07 ± 1.5% | 7538.64 ± 0.4% | 429.69 ± 0.3% | 0.99 | 1.00 | 5.65 | 3.28 |
| a date and time | 56 | 301.59 ± 0.4% | 302.49 ± 0.4% | 374.34 ± 0.4% | 72.31 ± 0.2% | 137.43 ± 0.8% | 328.99 ± 1.4% | 4889.81 ± 0.5% | 301.18 ± 0.5% | 1.00 | 1.00 | 4.17 | 2.19 |
| a field path | 39 | 228.41 ± 0.4% | 229.07 ± 0.4% | 267.77 ± 0.2% | 80.26 ± 0.7% | 206.49 ± 1.8% | 505.61 ± 5.2% | 4849.80 ± 2.9% | 228.23 ± 0.1% | 1.00 | 1.00 | 2.85 | 1.11 |
| literal: a word | 7 | 651.35 ± 0.3% | 695.28 ± 0.6% | 1220.50 ± 0.2% | 505.43 ± 0.1% | 638.49 ± 1.8% | 962.97 ± 0.3% | 30348.92 ± 0.1% | 649.98 ± 0.5% | 0.94 | 1.00 | 1.29 | 1.02 |
| literal: a word that is not there | 8 | 626.00 ± 0.2% | 675.05 ± 0.4% | 1155.04 ± 0.5% | 454.34 ± 0.4% | 613.58 ± 2.1% | 912.31 ± 0.6% | 29094.75 ± 0.1% | 625.41 ± 0.6% | 0.93 | 1.00 | 1.38 | 1.02 |
| literal: one of four words | 26 | 249.69 ± 0.3% | 406.45 ± 0.9% | 543.74 ± 0.4% | 50.37 ± 0.6% | 243.42 ± 2.4% | 383.65 ± 1.1% | 15939.82 ± 0.2% | 249.75 ± 0.4% | 0.61 | 1.00 | 4.96 | 1.03 |
| literal: a word in any case | 11 | 456.31 ± 0.2% | 484.48 ± 0.5% | 701.14 ± 0.2% | 15.67 ± 1.8% | 653.24 ± 1.9% | refused | 23745.68 ± 0.1% | 456.34 ± 0.3% | 0.94 | 1.00 | 29.12 | 0.70 |
| literal: an href attribute | 12 | 348.35 ± 0.4% | 359.82 ± 0.5% | 464.89 ± 0.4% | 42.98 ± 0.1% | 503.33 ± 0.8% | 780.00 ± 1.0% | 21413.53 ± 0.5% | 348.23 ± 0.3% | 0.97 | 1.00 | 8.11 | 0.69 |
| literal: a word, second text | 10 | 577.64 ± 0.9% | 633.34 ± 0.6% | 1041.52 ± 1.2% | 387.41 ± 0.1% | 540.11 ± 2.9% | 813.55 ± 0.4% | 26959.41 ± 0.2% | 578.15 ± 0.7% | 0.91 | 1.00 | 1.49 | 1.07 |
| class: two capitalized words | 23 | 445.33 ± 0.8% | 473.19 ± 0.8% | 676.26 ± 0.8% | 99.61 ± 0.3% | 508.60 ± 1.5% | 747.04 ± 0.4% | 6460.49 ± 0.3% | 445.16 ± 0.6% | 0.94 | 1.00 | 4.47 | 0.88 |
| class: a word that ends in ing | 9 | 578.35 ± 0.7% | 645.37 ± 0.6% | 1106.37 ± 0.3% | 129.91 ± 1.4% | 769.60 ± 1.2% | 1122.05 ± 0.3% | 15816.68 ± 0.2% | 578.57 ± 0.3% | 0.90 | 1.00 | 4.45 | 0.75 |
| class: a word in capitals | 16 | 506.94 ± 0.2% | 545.17 ± 0.3% | 862.41 ± 0.1% | 134.47 ± 0.8% | 761.87 ± 0.5% | 1034.81 ± 1.3% | 8506.77 ± 0.3% | 507.26 ± 0.2% | 0.93 | 1.00 | 3.77 | 0.67 |
| class: a number | 6 | 646.73 ± 0.4% | 710.69 ± 0.7% | 1319.92 ± 0.0% | 41.31 ± 0.9% | 1416.01 ± 1.0% | 1880.47 ± 1.3% | 22678.13 ± 0.1% | 646.32 ± 0.4% | 0.91 | 1.00 | 15.65 | 0.46 |
| class: two capitalized words, second text | 23 | 445.12 ± 0.5% | 475.33 ± 0.7% | 675.58 ± 0.4% | 101.20 ± 0.7% | 507.23 ± 0.8% | 769.83 ± 1.2% | 6456.77 ± 0.4% | 445.82 ± 0.5% | 0.94 | 1.00 | 4.40 | 0.88 |
| other: a word between two words | 13 | 559.40 ± 0.5% | 576.24 ± 0.7% | 901.88 ± 0.2% | 132.34 ± 0.5% | 505.09 ± 1.5% | 813.47 ± 0.5% | 14738.62 ± 0.6% | 559.61 ± 0.8% | 0.97 | 1.00 | 4.23 | 1.11 |
| other: a number before a unit, second text | 15 | 408.58 ± 0.3% | 445.68 ± 0.9% | 620.34 ± 0.2% | 38.97 ± 0.4% | 637.28 ± 0.7% | 901.80 ± 0.5% | 15089.34 ± 0.1% | 408.03 ± 0.4% | 0.92 | 1.00 | 10.48 | 0.64 |
| other: a heading's start tag | 13 | 360.32 ± 0.4% | 365.95 ± 0.3% | 476.54 ± 0.1% | 43.54 ± 0.7% | 631.13 ± 1.5% | 867.05 ± 0.5% | 17912.54 ± 0.2% | 360.04 ± 0.7% | 0.98 | 1.00 | 8.28 | 0.57 |
| other: a whole word | 11 | 594.02 ± 1.2% | 627.18 ± 0.6% | 1036.85 ± 0.1% | 116.78 ± 0.4% | 572.85 ± 1.6% | 832.57 ± 1.0% | 26938.39 ± 0.3% | 593.80 ± 0.5% | 0.95 | 1.00 | 5.09 | 1.04 |
| other: a line's first word, second text | 17 | 544.55 ± 0.7% | 563.13 ± 0.1% | 893.22 ± 0.3% | 128.64 ± 0.2% | 717.28 ± 0.9% | refused | refused | 542.91 ± 0.6% | 0.97 | 1.00 | 4.23 | 0.76 |
| other: fourteen octets before an x | 16 | 109.29 ± 0.3% | 156.56 ± 0.6% | 177.96 ± 0.6% | 14.92 ± 0.8% | 457.79 ± 0.9% | 412.00 ± 0.8% | 12756.57 ± 0.3% | 109.20 ± 0.3% | 0.70 | 1.00 | 7.32 | 0.24 |
| other: a Greek word | 8 | 464.50 ± 0.5% | 616.06 ± 0.4% | 1029.22 ± 0.1% | 58.55 ± 0.5% | 1410.69 ± 0.5% | 1802.63 ± 1.1% | refused | 464.17 ± 0.4% | 0.75 | 1.00 | 7.93 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12922.05 ± 0.5% | not timed | not timed | 16493.33 ± 0.9% | 2028.87 ± 18.2% | not timed | not timed | 12893.57 ± 0.6% | | 1.00 | 0.78 | 6.37 |
| 01-literal/sherlock-casei-en | 522 | 4959.89 ± 1.3% | not timed | not timed | 3578.83 ± 0.1% | 32.10 ± 2.1% | not timed | not timed | 4952.76 ± 0.7% | | 1.00 | 1.39 | 154.49 |
| 01-literal/sherlock-ru | 724 | 13574.60 ± 0.5% | not timed | not timed | 17296.68 ± 0.3% | 1516.86 ± 5.1% | not timed | not timed | 13544.69 ± 0.3% | | 1.00 | 0.78 | 8.95 |
| 01-literal/sherlock-casei-ru | 746 | 5984.40 ± 0.3% | not timed | not timed | 3329.23 ± 0.2% | 31.62 ± 1.0% | not timed | not timed | 5971.75 ± 0.2% | | 1.00 | 1.80 | 189.25 |
| 01-literal/sherlock-zh | 30 | 17229.09 ± 0.5% | not timed | not timed | 18847.58 ± 0.8% | 2632.77 ± 3.4% | not timed | not timed | 17204.14 ± 0.5% | | 1.00 | 0.91 | 6.54 |
| 02-literal-alternate/sherlock-en | 714 | 5770.51 ± 0.7% | not timed | not timed | 3942.49 ± 0.3% | 16.58 ± 0.1% | not timed | not timed | 5760.81 ± 0.4% | | 1.00 | 1.46 | 348.01 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1804.52 ± 1.2% | not timed | not timed | 696.75 ± 0.3% | 11.04 ± 0.1% | not timed | not timed | 1794.39 ± 0.6% | | 1.01 | 2.59 | 163.39 |
| 02-literal-alternate/sherlock-ru | 899 | 5341.38 ± 0.1% | not timed | not timed | 3266.28 ± 0.1% | 22.66 ± 0.1% | not timed | not timed | 5333.60 ± 0.1% | | 1.00 | 1.64 | 235.69 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1921.99 ± 0.8% | not timed | not timed | 1232.05 ± 0.1% | 9.14 ± 0.2% | not timed | not timed | 1911.09 ± 0.3% | | 1.01 | 1.56 | 210.29 |
| 02-literal-alternate/sherlock-zh | 207 | 7033.43 ± 0.3% | not timed | not timed | 4161.82 ± 0.3% | 31.49 ± 0.1% | not timed | not timed | 7040.62 ± 0.3% | | 1.00 | 1.69 | 223.37 |
| 03-date/ascii | 111817 | 126.91 ± 0.6% | not timed | not timed | 94.49 ± 0.1% | 0.20 ± 0.8% | not timed | not timed | 126.28 ± 0.3% | | 1.00 | 1.34 | 625.51 |
| 04-ruff-noqa/real | 84 | 410.13 ± 0.1% | not timed | not timed | 452.46 ± 0.2% | 19.50 ± 1.9% | not timed | not timed | 408.32 ± 0.1% | | 1.00 | 0.91 | 21.03 |
| 04-ruff-noqa/tweaked | 44 | 552.23 ± 0.2% | not timed | not timed | 462.23 ± 0.1% | 363.49 ± 0.4% | not timed | not timed | 551.81 ± 0.1% | | 1.00 | 1.19 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.20 ± 0.8% | not timed | not timed | 5.04 ± 0.1% | 0.20 ± 5.1% | not timed | not timed | 5.06 ± 3.0% | | 1.03 | 1.03 | 25.53 |
| 06-cloud-flare-redos/original | 107 | 414.42 ± 0.6% | not timed | not timed | 214.28 ± 0.2% | 24.86 ± 0.5% | not timed | not timed | 415.01 ± 0.1% | | 1.00 | 1.93 | 16.67 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.70 ± 0.1% | not timed | not timed | 226.76 ± 0.0% | 26.73 ± 0.2% | not timed | not timed | 410.62 ± 0.2% | | 1.00 | 1.81 | 15.36 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.57 ± 0.2% | not timed | not timed | 255.58 ± 0.1% | 28.78 ± 0.2% | not timed | not timed | 586.77 ± 0.1% | | 1.00 | 2.30 | 20.42 |
| 07-unicode-character-data/parse-line | 558784 | 236.79 ± 4.1% | not timed | not timed | 171.49 ± 0.1% | 42.80 ± 3.0% | not timed | not timed | 237.61 ± 0.2% | | 1.00 | 1.38 | 5.53 |
| 08-words/all-english | 56691 | 116.98 ± 0.4% | not timed | not timed | 82.94 ± 0.1% | 11.95 ± 2.2% | not timed | not timed | 116.87 ± 0.4% | | 1.00 | 1.41 | 9.79 |
| 08-words/long-english | 839 | 620.83 ± 0.2% | not timed | not timed | 597.27 ± 0.1% | 32.15 ± 0.2% | not timed | not timed | 620.18 ± 0.2% | | 1.00 | 1.04 | 19.31 |
| 09-aws-keys/full | 0 | 416.02 ± 0.1% | not timed | not timed | 464.40 ± 0.1% | 64.79 ± 3.4% | not timed | not timed | 415.57 ± 0.1% | | 1.00 | 0.90 | 6.42 |
| 09-aws-keys/quick | 0 | 735.58 ± 0.2% | not timed | not timed | 987.63 ± 0.2% | 422.31 ± 0.3% | not timed | not timed | 731.99 ± 0.1% | | 1.00 | 0.74 | 1.74 |
| 10-bounded-repeat/letters-en | 1833 | 582.60 ± 2.5% | not timed | not timed | 516.80 ± 0.4% | 19.51 ± 0.3% | not timed | not timed | 583.56 ± 2.5% | | 1.00 | 1.13 | 29.85 |
| 10-bounded-repeat/letters-ru | 3475 | 510.24 ± 0.5% | not timed | not timed | 478.37 ± 0.1% | 22.24 ± 18.1% | not timed | not timed | 507.36 ± 0.6% | | 1.01 | 1.07 | 22.95 |
| 10-bounded-repeat/context | 53 | 77.25 ± 0.6% | not timed | not timed | 65.82 ± 0.6% | 19.69 ± 0.1% | not timed | not timed | 77.43 ± 0.6% | | 1.00 | 1.17 | 3.92 |
| 10-bounded-repeat/capitals | 11 | 631.64 ± 8.5% | not timed | not timed | 615.63 ± 0.1% | 36.50 ± 0.4% | not timed | not timed | 630.75 ± 8.5% | | 1.00 | 1.03 | 17.30 |
| 11-unstructured-to-json/extract | 600 | 82.97 ± 0.1% | not timed | not timed | 77.23 ± 0.1% | 48.96 ± 1.3% | not timed | not timed | 81.92 ± 0.3% | | 1.01 | 1.07 | 1.69 |
| 12-dictionary/single | 1 | 561.52 ± 0.4% | not timed | not timed | 562.67 ± 0.1% | 0.40 ± 0.4% | not timed | not timed | 559.50 ± 0.3% | | 1.00 | 1.00 | 1386.98 |
| 14-quadratic/1x | 100 | 21.47 ± 2.6% | not timed | not timed | 10.03 ± 0.3% | 0.98 ± 3.3% | not timed | not timed | 21.33 ± 0.7% | | 1.01 | 2.14 | 21.93 |
| 14-quadratic/2x | 200 | 17.62 ± 3.9% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 0.7% | not timed | not timed | 17.60 ± 1.2% | | 1.00 | 3.18 | 32.96 |
| 14-quadratic/10x | 1000 | 7.71 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 7.69 ± 0.2% | | 1.00 | 6.36 | 66.94 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 1.4% | not timed | not timed | 0.34 ± 0.4% | 0.55 ± 1.6% | not timed | not timed | 1.27 ± 0.7% | | 1.00 | 3.67 | 2.28 |
| 04-ruff-noqa/compile-real | 1 | 92.87 ± 0.2% | not timed | not timed | 13.85 ± 0.6% | 139.72 ± 2.1% | not timed | not timed | 92.52 ± 1.1% | | 1.00 | 6.70 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 13.78 ± 0.4% | not timed | not timed | 2.51 ± 0.4% | 6.55 ± 0.8% | not timed | not timed | 13.69 ± 1.1% | | 1.01 | 5.48 | 2.10 |
| 07-unicode-character-data/compile | 1 | 54.84 ± 0.5% | not timed | not timed | 26.13 ± 0.2% | 36.86 ± 1.7% | not timed | not timed | 54.53 ± 1.0% | | 1.01 | 2.10 | 1.49 |
| 09-aws-keys/compile-full | 1 | 41.98 ± 0.3% | not timed | not timed | 8.36 ± 0.3% | 23.65 ± 1.9% | not timed | not timed | 41.80 ± 2.4% | | 1.00 | 5.02 | 1.78 |
| 09-aws-keys/compile-quick | 1 | 188.33 ± 0.2% | not timed | not timed | 47.96 ± 0.4% | 122.43 ± 15.1% | not timed | not timed | 186.82 ± 1.1% | | 1.01 | 3.93 | 1.54 |
| 10-bounded-repeat/compile-context | 1 | 14.01 ± 0.5% | not timed | not timed | 11.31 ± 0.2% | 16.46 ± 2.5% | not timed | not timed | 13.82 ± 1.1% | | 1.01 | 1.24 | 0.85 |
| 10-bounded-repeat/compile-capitals | 1 | 83.61 ± 0.4% | not timed | not timed | 8.05 ± 0.1% | 24.15 ± 1.4% | not timed | not timed | 83.41 ± 2.4% | | 1.00 | 10.38 | 3.46 |
| 11-unstructured-to-json/compile | 1 | 86.28 ± 0.9% | not timed | not timed | 41.43 ± 0.1% | 68.86 ± 2.6% | not timed | not timed | 86.13 ± 1.1% | | 1.00 | 2.08 | 1.25 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.1% | not timed | not timed | 0.07 ± 0.8% | 0.09 ± 14.7% | not timed | not timed | 0.35 ± 1.2% | | 1.00 | 5.03 | 3.74 |

