# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159314380 |
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
| literal: a word | 217 | 32693.51 ± 1.7% | 897.77 ± 0.0% | 20.08 ± 0.9% | 31081.86 ± 1.1% | 9067.84 ± 7.6% | 10.82 ± 0.6% | 76.64 ± 0.7% | 32403.35 ± 0.7% | 36.42 | 1.01 | 1.05 | 3.61 |
| literal: a word that is not there | 0 | 49421.02 ± 1.0% | 906.55 ± 0.2% | 20.06 ± 0.3% | 39818.00 ± 0.6% | 29997.67 ± 0.5% | 10.75 ± 0.6% | 73.02 ± 6.7% | 49464.77 ± 0.4% | 54.52 | 1.00 | 1.24 | 1.65 |
| literal: one of four words | 661 | 11082.73 ± 0.6% | 876.44 ± 1.3% | 11.24 ± 4.6% | 9131.17 ± 0.3% | 19.31 ± 1.6% | 3.95 ± 0.2% | 6.52 ± 0.4% | 11103.08 ± 1.2% | 12.65 | 1.00 | 1.21 | 573.99 |
| literal: a word in any case | 217 | 25741.75 ± 1.3% | 895.76 ± 0.1% | 15.74 ± 0.6% | 9227.82 ± 0.2% | 37.29 ± 0.3% | refused | differs | 25684.84 ± 1.2% | 28.74 | 1.00 | 2.79 | 690.30 |
| literal: an href attribute | 33 | 26611.56 ± 4.6% | 903.37 ± 1.3% | 18.85 ± 1.9% | 27366.27 ± 3.2% | 2067.99 ± 2.4% | 8.25 ± 1.1% | 66.70 ± 6.8% | 26617.24 ± 5.9% | 29.46 | 1.00 | 0.97 | 12.87 |
| literal: a word, second text | 123 | 33602.62 ± 2.0% | 900.37 ± 0.2% | 19.87 ± 0.2% | 32047.41 ± 0.7% | 7347.03 ± 3.1% | 11.85 ± 0.4% | 65.93 ± 1.6% | 33548.24 ± 1.6% | 37.32 | 1.00 | 1.05 | 4.57 |
| class: two capitalized words | 1331 | 777.14 ± 0.4% | 827.87 ± 0.1% | 18.87 ± 0.4% | 506.25 ± 0.1% | 34.38 ± 1.3% | 9.40 ± 0.1% | 59.49 ± 0.7% | 776.49 ± 0.6% | 0.94 | 1.00 | 1.54 | 22.61 |
| class: a word that ends in ing | 3399 | 757.54 ± 0.5% | 756.94 ± 0.2% | 13.34 ± 0.3% | 473.00 ± 0.3% | 25.68 ± 9.1% | 5.34 ± 0.2% | 16.93 ± 1.0% | 755.78 ± 0.2% | 1.00 | 1.00 | 1.60 | 29.50 |
| class: a word in capitals | 2332 | 976.82 ± 0.3% | 806.22 ± 0.2% | 19.76 ± 0.5% | 498.07 ± 0.3% | 36.58 ± 6.5% | 10.49 ± 0.2% | 77.21 ± 0.3% | 977.26 ± 0.2% | 1.21 | 1.00 | 1.96 | 26.70 |
| class: a number | 8288 | 1359.68 ± 0.3% | 690.29 ± 0.5% | 19.43 ± 0.6% | 1458.59 ± 0.3% | 36.48 ± 9.5% | 0.34 ± 0.3% | 56.55 ± 10.1% | 1356.95 ± 0.4% | 1.97 | 1.00 | 0.93 | 37.27 |
| class: two capitalized words, second text | 5359 | 622.18 ± 0.5% | 621.00 ± 0.5% | 17.40 ± 0.2% | 418.42 ± 0.3% | 30.21 ± 9.6% | 10.63 ± 0.3% | 54.93 ± 1.6% | 621.63 ± 0.3% | 1.00 | 1.00 | 1.49 | 20.59 |
| other: a word between two words | 6104 | 682.78 ± 6.2% | 651.82 ± 0.2% | 17.17 ± 0.3% | 687.35 ± 0.3% | 105.04 ± 11.1% | 7.32 ± 0.2% | 60.45 ± 1.9% | 690.01 ± 0.3% | 1.05 | 0.99 | 0.99 | 6.50 |
| other: a number before a unit, second text | 1481 | 6971.58 ± 0.8% | 841.89 ± 0.8% | 18.83 ± 0.6% | 6415.32 ± 0.7% | 35.26 ± 6.2% | 11.05 ± 0.1% | 59.30 ± 1.2% | 6916.28 ± 0.9% | 8.28 | 1.01 | 1.09 | 197.73 |
| other: a heading's start tag | 110 | 18970.31 ± 8.8% | 896.35 ± 0.4% | 19.61 ± 0.1% | 2002.36 ± 0.7% | 1465.03 ± 6.5% | 10.07 ± 0.2% | 78.12 ± 8.5% | 18916.22 ± 0.9% | 21.16 | 1.00 | 9.47 | 12.95 |
| other: a whole word | 217 | 22475.34 ± 8.3% | 896.33 ± 0.2% | 20.94 ± 1.1% | 22670.59 ± 0.9% | 41.37 ± 0.3% | 9.54 ± 0.1% | 46.25 ± 0.6% | 22417.73 ± 1.2% | 25.07 | 1.00 | 0.99 | 543.24 |
| other: a line's first word, second text | 3716 | 1854.08 ± 7.3% | 744.72 ± 1.5% | 24.43 ± 2.4% | 1691.84 ± 2.4% | 51.87 ± 4.2% | refused | refused | 1872.06 ± 2.2% | 2.49 | 0.99 | 1.10 | 35.74 |
| other: fourteen octets before an x | 87 | 25347.55 ± 1.2% | 196.45 ± 0.7% | 5.50 ± 0.2% | 2741.40 ± 1.4% | 8.99 ± 0.5% | differs | 15.88 ± 10.0% | 25496.40 ± 2.1% | 129.03 | 0.99 | 9.25 | 2818.93 |
| other: a Greek word | 21815 | 395.31 ± 1.6% | 335.87 ± 0.3% | 24.35 ± 0.6% | 264.93 ± 0.4% | 44.61 ± 7.4% | differs | refused | 395.34 ± 0.3% | 1.18 | 1.00 | 1.49 | 8.86 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.14 ± 1.9% | 24.31 ± 0.5% | 0.80 ± 0.6% | 17.02 ± 0.3% | 2.34 ± 0.5% | differs | 3.47 ± 2.4% | 24.22 ± 0.8% | 0.99 | 1.00 | 1.42 | 10.32 |
| a UUID | 32895 | 20.42 ± 0.3% | 20.39 ± 0.6% | 0.55 ± 0.5% | 12.70 ± 0.2% | 2.52 ± 1.6% | 0.43 ± 0.2% | 3.21 ± 1.9% | 20.37 ± 0.1% | 1.00 | 1.00 | 1.61 | 8.10 |
| an IPv4 address | 33176 | 33.45 ± 9.7% | 33.41 ± 13.6% | 1.80 ± 11.3% | 24.26 ± 0.3% | 5.80 ± 0.7% | differs | 3.44 ± 2.4% | 33.84 ± 1.7% | 1.00 | 0.99 | 1.38 | 5.76 |
| a date and time | 32954 | 30.08 ± 0.5% | 30.02 ± 0.7% | 1.26 ± 3.6% | 18.07 ± 0.4% | 6.69 ± 2.7% | 0.75 ± 0.3% | 6.05 ± 0.6% | 30.03 ± 0.2% | 1.00 | 1.00 | 1.66 | 4.49 |
| a field path | 32606 | 27.10 ± 0.5% | 27.16 ± 0.9% | 0.92 ± 0.7% | 19.70 ± 0.1% | 2.95 ± 0.4% | differs | 2.32 ± 1.1% | 27.03 ± 0.5% | 1.00 | 1.00 | 1.38 | 9.19 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.22 ± 1.9% | 8.23 ± 3.5% | 8.15 ± 2.3% | 10.68 ± 3.9% | 4.75 ± 2.3% | 0.62 ± 0.7% | none | 8.23 ± 15.1% | 1.00 | 1.00 | 0.77 | 1.73 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 192.66 ± 0.6% | 193.87 ± 8.3% | 228.85 ± 0.8% | 80.28 ± 3.6% | 174.17 ± 32.8% | 525.00 ± 3.0% | 3921.65 ± 1.6% | 192.75 ± 0.4% | 0.99 | 1.00 | 2.40 | 1.11 |
| a UUID | 62 | 123.62 ± 0.4% | 124.42 ± 0.4% | 140.12 ± 0.8% | 46.69 ± 2.5% | 89.26 ± 1.9% | 198.17 ± 2.8% | 4034.75 ± 0.5% | 123.46 ± 0.9% | 0.99 | 1.00 | 2.65 | 1.38 |
| an IPv4 address | 29 | 381.54 ± 1.6% | 384.07 ± 9.6% | 545.51 ± 3.1% | 69.75 ± 0.8% | 113.71 ± 1.1% | 327.22 ± 2.3% | 6734.09 ± 3.1% | 383.05 ± 6.5% | 0.99 | 1.00 | 5.47 | 3.36 |
| a date and time | 56 | 278.28 ± 0.4% | 280.25 ± 0.3% | 355.62 ± 14.9% | 68.16 ± 0.5% | 123.27 ± 25.6% | 373.73 ± 1.8% | 4180.12 ± 0.7% | 278.35 ± 1.8% | 0.99 | 1.00 | 4.08 | 2.26 |
| a field path | 39 | 189.76 ± 0.6% | 190.33 ± 6.7% | 223.65 ± 2.1% | 74.53 ± 1.2% | 171.03 ± 8.0% | 587.75 ± 1.6% | 4779.09 ± 0.3% | 189.63 ± 0.5% | 1.00 | 1.00 | 2.55 | 1.11 |
| literal: a word | 7 | 571.12 ± 1.5% | 608.34 ± 0.9% | 1121.66 ± 0.3% | 486.81 ± 8.7% | 574.07 ± 1.2% | 1255.78 ± 0.5% | 25199.92 ± 0.9% | 568.45 ± 1.0% | 0.94 | 1.00 | 1.17 | 0.99 |
| literal: a word that is not there | 8 | 546.33 ± 0.7% | 588.39 ± 0.8% | 1056.66 ± 7.9% | 460.51 ± 0.7% | 550.71 ± 15.6% | 1171.41 ± 3.3% | 23977.45 ± 0.2% | 545.61 ± 0.6% | 0.93 | 1.00 | 1.19 | 0.99 |
| literal: one of four words | 26 | 214.75 ± 0.6% | 357.84 ± 0.5% | 491.89 ± 0.3% | 41.84 ± 0.6% | 220.96 ± 4.3% | 450.56 ± 1.3% | 12858.64 ± 0.2% | 215.06 ± 0.1% | 0.60 | 1.00 | 5.13 | 0.97 |
| literal: a word in any case | 11 | 443.27 ± 0.8% | 471.50 ± 1.4% | 728.78 ± 14.5% | 14.55 ± 0.6% | 602.49 ± 1.7% | refused | 19823.74 ± 1.0% | 441.29 ± 0.4% | 0.94 | 1.00 | 30.46 | 0.74 |
| literal: an href attribute | 12 | 316.60 ± 0.6% | 328.64 ± 0.3% | 444.71 ± 10.5% | 36.39 ± 0.6% | 423.00 ± 1.7% | 934.64 ± 1.7% | 17905.99 ± 1.2% | 316.93 ± 0.5% | 0.96 | 1.00 | 8.70 | 0.75 |
| literal: a word, second text | 10 | 506.54 ± 1.2% | 552.96 ± 10.7% | 952.61 ± 2.2% | 416.61 ± 0.4% | 475.04 ± 5.7% | 992.41 ± 0.5% | 21856.67 ± 14.3% | 506.37 ± 11.7% | 0.92 | 1.00 | 1.22 | 1.07 |
| class: two capitalized words | 23 | 404.42 ± 2.1% | 428.24 ± 14.5% | 635.80 ± 7.8% | 95.26 ± 4.3% | 446.72 ± 16.7% | 943.21 ± 2.4% | 6282.35 ± 2.4% | 403.08 ± 2.2% | 0.94 | 1.00 | 4.25 | 0.91 |
| class: a word that ends in ing | 9 | 491.08 ± 0.5% | 552.71 ± 0.3% | 1017.76 ± 1.0% | 113.54 ± 2.2% | 625.34 ± 2.0% | 1390.69 ± 0.9% | 15232.74 ± 0.6% | 490.45 ± 2.8% | 0.89 | 1.00 | 4.33 | 0.79 |
| class: a word in capitals | 16 | 421.87 ± 1.0% | 453.15 ± 2.2% | 778.32 ± 0.6% | 119.96 ± 1.4% | 650.57 ± 1.4% | 1210.21 ± 0.6% | 8293.93 ± 2.4% | 422.59 ± 8.1% | 0.93 | 1.00 | 3.52 | 0.65 |
| class: a number | 6 | 527.75 ± 0.5% | 579.84 ± 12.0% | 1157.48 ± 13.8% | 36.44 ± 0.6% | 1178.49 ± 3.2% | 2210.16 ± 2.3% | 20680.07 ± 0.8% | 526.93 ± 4.0% | 0.91 | 1.00 | 14.48 | 0.45 |
| class: two capitalized words, second text | 23 | 406.66 ± 0.8% | 436.91 ± 0.4% | 653.27 ± 0.7% | 95.51 ± 3.0% | 447.45 ± 13.7% | 974.61 ± 1.8% | 6292.72 ± 10.2% | 407.07 ± 0.4% | 0.93 | 1.00 | 4.26 | 0.91 |
| other: a word between two words | 13 | 488.76 ± 10.6% | 506.77 ± 0.4% | 826.69 ± 9.9% | 121.66 ± 1.3% | 431.31 ± 1.8% | 1030.26 ± 1.1% | 14098.27 ± 0.6% | 488.67 ± 10.5% | 0.96 | 1.00 | 4.02 | 1.13 |
| other: a number before a unit, second text | 15 | 356.36 ± 0.2% | 395.51 ± 0.3% | 558.76 ± 7.3% | 33.63 ± 0.8% | 534.78 ± 1.5% | 1111.55 ± 3.3% | 12527.77 ± 2.1% | 355.65 ± 0.7% | 0.90 | 1.00 | 10.60 | 0.67 |
| other: a heading's start tag | 13 | 329.37 ± 12.6% | 335.20 ± 0.6% | 456.65 ± 0.6% | 34.95 ± 2.5% | 518.23 ± 1.7% | 1078.44 ± 2.5% | 15047.66 ± 9.7% | 329.68 ± 0.6% | 0.98 | 1.00 | 9.42 | 0.64 |
| other: a whole word | 11 | 491.57 ± 4.3% | 521.86 ± 1.0% | 856.54 ± 0.8% | 108.89 ± 1.0% | 504.12 ± 0.7% | 1061.76 ± 0.7% | 20811.18 ± 0.9% | 492.50 ± 0.8% | 0.94 | 1.00 | 4.51 | 0.98 |
| other: a line's first word, second text | 17 | 475.79 ± 1.5% | 492.80 ± 0.5% | 834.12 ± 2.7% | 114.09 ± 6.8% | 594.72 ± 3.3% | refused | refused | 473.66 ± 0.5% | 0.97 | 1.00 | 4.17 | 0.80 |
| other: fourteen octets before an x | 16 | 85.60 ± 0.4% | 120.44 ± 0.4% | 141.30 ± 0.4% | 14.24 ± 0.2% | 390.97 ± 2.0% | 451.45 ± 1.0% | 11491.87 ± 2.3% | 85.67 ± 0.4% | 0.71 | 1.00 | 6.01 | 0.22 |
| other: a Greek word | 8 | 360.70 ± 0.4% | 503.94 ± 0.4% | 867.33 ± 9.9% | 47.00 ± 1.9% | 1161.31 ± 1.6% | 2248.33 ± 0.6% | refused | 360.41 ± 0.2% | 0.72 | 1.00 | 7.67 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21962.50 ± 1.4% | not timed | not timed | 26952.77 ± 1.1% | 1993.45 ± 31.2% | not timed | not timed | 21985.94 ± 0.6% | | 1.00 | 0.81 | 11.02 |
| 01-literal/sherlock-casei-en | 522 | 6274.89 ± 2.6% | not timed | not timed | 7055.50 ± 1.8% | 28.56 ± 1.1% | not timed | not timed | 6250.28 ± 0.4% | | 1.00 | 0.89 | 219.68 |
| 01-literal/sherlock-ru | 724 | 23755.56 ± 1.7% | not timed | not timed | 27696.76 ± 0.4% | 1076.45 ± 3.5% | not timed | not timed | 23699.82 ± 1.1% | | 1.00 | 0.86 | 22.07 |
| 01-literal/sherlock-casei-ru | 746 | 7352.21 ± 0.4% | not timed | not timed | 5530.51 ± 1.4% | 30.65 ± 0.9% | not timed | not timed | 6904.87 ± 2.3% | | 1.06 | 1.33 | 239.85 |
| 01-literal/sherlock-zh | 30 | 42346.05 ± 0.8% | not timed | not timed | 36902.32 ± 0.5% | 1263.14 ± 0.7% | not timed | not timed | 42229.29 ± 0.4% | | 1.00 | 1.15 | 33.52 |
| 02-literal-alternate/sherlock-en | 714 | 9656.38 ± 2.4% | not timed | not timed | 8923.88 ± 0.9% | 14.52 ± 4.0% | not timed | not timed | 9666.55 ± 8.8% | | 1.00 | 1.08 | 664.89 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1832.21 ± 0.5% | not timed | not timed | 1793.96 ± 0.3% | 9.55 ± 11.7% | not timed | not timed | 1831.06 ± 0.5% | | 1.00 | 1.02 | 191.90 |
| 02-literal-alternate/sherlock-ru | 899 | 5974.11 ± 0.2% | not timed | not timed | 4268.46 ± 0.4% | 19.64 ± 0.9% | not timed | not timed | 5980.00 ± 0.3% | | 1.00 | 1.40 | 304.21 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1882.39 ± 0.3% | not timed | not timed | 1047.88 ± 0.3% | 8.55 ± 1.2% | not timed | not timed | 1879.58 ± 0.2% | | 1.00 | 1.80 | 220.09 |
| 02-literal-alternate/sherlock-zh | 207 | 13986.15 ± 2.4% | not timed | not timed | 10422.49 ± 0.4% | 27.76 ± 16.1% | not timed | not timed | 13978.35 ± 2.1% | | 1.00 | 1.34 | 503.89 |
| 03-date/ascii | 111817 | 99.50 ± 0.3% | not timed | not timed | 85.16 ± 0.4% | 0.18 ± 2.3% | not timed | not timed | 99.51 ± 7.4% | | 1.00 | 1.17 | 551.99 |
| 04-ruff-noqa/real | 84 | 567.90 ± 0.3% | not timed | not timed | 406.80 ± 1.6% | 12.09 ± 0.9% | not timed | not timed | 566.81 ± 1.1% | | 1.00 | 1.40 | 46.96 |
| 04-ruff-noqa/tweaked | 44 | 483.11 ± 0.3% | not timed | not timed | 420.85 ± 0.4% | 278.97 ± 10.0% | not timed | not timed | 481.42 ± 0.6% | | 1.00 | 1.15 | 1.73 |
| 05-lexer-veryl/single | 124800 | 3.05 ± 1.8% | not timed | not timed | 4.17 ± 1.2% | 0.21 ± 6.5% | not timed | not timed | 3.09 ± 1.6% | | 0.99 | 0.73 | 14.32 |
| 06-cloud-flare-redos/original | 107 | 221.43 ± 0.7% | not timed | not timed | 191.97 ± 1.5% | 20.71 ± 0.7% | not timed | not timed | 221.67 ± 0.7% | | 1.00 | 1.15 | 10.69 |
| 06-cloud-flare-redos/simplified-short | 102 | 214.76 ± 7.4% | not timed | not timed | 190.20 ± 14.3% | 21.87 ± 1.9% | not timed | not timed | 214.03 ± 3.6% | | 1.00 | 1.13 | 9.82 |
| 06-cloud-flare-redos/simplified-long | 10000 | 246.21 ± 0.1% | not timed | not timed | 211.42 ± 17.1% | 24.19 ± 0.4% | not timed | not timed | 245.72 ± 1.8% | | 1.00 | 1.16 | 10.18 |
| 07-unicode-character-data/parse-line | 558784 | 189.22 ± 8.7% | not timed | not timed | 160.70 ± 4.9% | 37.64 ± 11.8% | not timed | not timed | 185.58 ± 17.4% | | 1.02 | 1.18 | 5.03 |
| 08-words/all-english | 56691 | 95.30 ± 14.7% | not timed | not timed | 73.08 ± 0.2% | 10.14 ± 10.8% | not timed | not timed | 94.44 ± 2.0% | | 1.01 | 1.30 | 9.40 |
| 08-words/long-english | 839 | 859.45 ± 0.1% | not timed | not timed | 515.48 ± 0.2% | 26.49 ± 13.2% | not timed | not timed | 855.02 ± 0.2% | | 1.01 | 1.67 | 32.45 |
| 09-aws-keys/full | 0 | 429.41 ± 8.8% | not timed | not timed | 445.64 ± 0.3% | 54.60 ± 7.4% | not timed | not timed | 429.47 ± 0.3% | | 1.00 | 0.96 | 7.86 |
| 09-aws-keys/quick | 0 | 820.83 ± 0.7% | not timed | not timed | 802.58 ± 0.8% | 332.59 ± 0.5% | not timed | not timed | 822.94 ± 9.1% | | 1.00 | 1.02 | 2.47 |
| 10-bounded-repeat/letters-en | 1833 | 491.86 ± 0.3% | not timed | not timed | 432.17 ± 0.5% | 16.86 ± 1.5% | not timed | not timed | 502.31 ± 0.5% | | 0.98 | 1.14 | 29.16 |
| 10-bounded-repeat/letters-ru | 3475 | 318.37 ± 0.1% | not timed | not timed | 407.96 ± 1.5% | 19.67 ± 12.3% | not timed | not timed | 316.83 ± 2.3% | | 1.00 | 0.78 | 16.19 |
| 10-bounded-repeat/context | 53 | 65.75 ± 1.2% | not timed | not timed | 56.66 ± 0.9% | 16.97 ± 0.3% | not timed | not timed | 65.20 ± 1.0% | | 1.01 | 1.16 | 3.87 |
| 10-bounded-repeat/capitals | 11 | 896.40 ± 1.4% | not timed | not timed | 530.47 ± 1.0% | 30.66 ± 2.5% | not timed | not timed | 885.59 ± 2.4% | | 1.01 | 1.69 | 29.24 |
| 11-unstructured-to-json/extract | 600 | 37.12 ± 1.5% | not timed | not timed | 61.91 ± 0.3% | 40.33 ± 1.0% | not timed | not timed | 37.15 ± 0.3% | | 1.00 | 0.60 | 0.92 |
| 12-dictionary/single | 1 | 462.41 ± 2.9% | not timed | not timed | 443.86 ± 0.4% | 0.32 ± 5.1% | not timed | not timed | 462.87 ± 0.3% | | 1.00 | 1.04 | 1423.93 |
| 14-quadratic/1x | 100 | 10.09 ± 1.1% | not timed | not timed | 9.10 ± 0.1% | 0.80 ± 2.5% | not timed | not timed | 10.03 ± 23.7% | | 1.01 | 1.11 | 12.59 |
| 14-quadratic/2x | 200 | 6.43 ± 0.6% | not timed | not timed | 4.91 ± 0.3% | 0.43 ± 7.9% | not timed | not timed | 6.44 ± 1.2% | | 1.00 | 1.31 | 15.06 |
| 14-quadratic/10x | 1000 | 1.57 ± 0.5% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 4.4% | not timed | not timed | 1.57 ± 0.3% | | 1.00 | 1.49 | 17.56 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.31 ± 0.2% | not timed | not timed | 0.39 ± 12.4% | 0.49 ± 4.5% | not timed | not timed | 1.30 ± 1.3% | | 1.00 | 3.36 | 2.68 |
| 04-ruff-noqa/compile-real | 1 | 81.00 ± 2.3% | not timed | not timed | 13.07 ± 6.4% | 125.26 ± 2.9% | not timed | not timed | 80.29 ± 4.9% | | 1.01 | 6.20 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 12.64 ± 1.1% | not timed | not timed | 2.38 ± 4.1% | 5.91 ± 0.4% | not timed | not timed | 12.56 ± 1.0% | | 1.01 | 5.31 | 2.14 |
| 07-unicode-character-data/compile | 1 | 51.24 ± 0.2% | not timed | not timed | 24.49 ± 0.7% | 33.18 ± 2.7% | not timed | not timed | 51.10 ± 0.9% | | 1.00 | 2.09 | 1.54 |
| 09-aws-keys/compile-full | 1 | 34.99 ± 0.4% | not timed | not timed | 7.46 ± 0.8% | 20.56 ± 3.3% | not timed | not timed | 34.76 ± 0.6% | | 1.01 | 4.69 | 1.70 |
| 09-aws-keys/compile-quick | 1 | 156.96 ± 2.2% | not timed | not timed | 45.45 ± 2.3% | 118.20 ± 3.5% | not timed | not timed | 155.05 ± 6.0% | | 1.01 | 3.45 | 1.33 |
| 10-bounded-repeat/compile-context | 1 | 10.52 ± 0.1% | not timed | not timed | 11.76 ± 1.2% | 15.06 ± 3.3% | not timed | not timed | 10.44 ± 16.9% | | 1.01 | 0.89 | 0.70 |
| 10-bounded-repeat/compile-capitals | 1 | 72.99 ± 0.7% | not timed | not timed | 8.94 ± 0.7% | 22.27 ± 2.8% | not timed | not timed | 71.42 ± 0.7% | | 1.02 | 8.16 | 3.28 |
| 11-unstructured-to-json/compile | 1 | 77.12 ± 0.8% | not timed | not timed | 36.94 ± 1.1% | 60.33 ± 1.9% | not timed | not timed | 76.79 ± 0.7% | | 1.00 | 2.09 | 1.28 |
| 12-dictionary/compile-single | 1 | 0.29 ± 0.5% | not timed | not timed | 0.07 ± 1.5% | 0.09 ± 17.4% | not timed | not timed | 0.29 ± 1.1% | | 1.01 | 4.24 | 3.38 |

