# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243538212 |
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
| literal: a word | 217 | 48898.53 ± 0.5% | 3974.41 ± 0.1% | 31.36 ± 0.4% | 38658.25 ± 1.2% | 12227.48 ± 3.1% | 12.93 ± 0.6% | 107.14 ± 0.7% | 48698.46 ± 0.4% | 12.30 | 1.00 | 1.26 | 4.00 |
| literal: a word that is not there | 0 | 63579.20 ± 0.1% | 3908.76 ± 3.5% | 31.33 ± 3.6% | 45995.44 ± 0.3% | 43915.69 ± 2.9% | 12.82 ± 0.8% | 101.23 ± 0.5% | 63689.36 ± 0.2% | 16.27 | 1.00 | 1.38 | 1.45 |
| literal: one of four words | 661 | 15098.58 ± 5.3% | 1677.13 ± 0.3% | 17.07 ± 6.1% | 11147.46 ± 4.9% | 24.90 ± 6.0% | 4.47 ± 0.2% | 7.64 ± 0.8% | 15090.88 ± 1.5% | 9.00 | 1.00 | 1.35 | 606.37 |
| literal: a word in any case | 217 | 42774.36 ± 0.4% | 1812.53 ± 0.5% | 24.16 ± 0.8% | 11335.36 ± 0.2% | 47.13 ± 7.3% | refused | differs | 42702.51 ± 7.5% | 23.60 | 1.00 | 3.77 | 907.53 |
| literal: an href attribute | 33 | 40823.07 ± 0.3% | 615.97 ± 0.1% | 29.46 ± 0.7% | 34539.22 ± 0.4% | 3031.20 ± 5.5% | 9.70 ± 0.3% | 93.36 ± 0.5% | 40885.08 ± 0.3% | 66.27 | 1.00 | 1.18 | 13.47 |
| literal: a word, second text | 123 | 50986.64 ± 0.5% | 3128.12 ± 1.0% | 30.95 ± 0.1% | 39570.44 ± 0.9% | 11108.82 ± 7.4% | 14.51 ± 0.1% | 90.73 ± 0.3% | 51213.39 ± 0.5% | 16.30 | 1.00 | 1.29 | 4.59 |
| class: two capitalized words | 1331 | 900.10 ± 0.2% | 605.24 ± 0.3% | 17.79 ± 16.5% | 574.91 ± 0.6% | 44.32 ± 0.4% | 11.08 ± 0.3% | 80.00 ± 0.6% | 898.84 ± 0.2% | 1.49 | 1.00 | 1.57 | 20.31 |
| class: a word that ends in ing | 3399 | 576.75 ± 0.0% | 576.11 ± 0.1% | 19.80 ± 0.7% | 540.37 ± 1.1% | 32.60 ± 3.5% | 6.24 ± 0.1% | 20.06 ± 0.8% | 576.07 ± 0.2% | 1.00 | 1.00 | 1.07 | 17.69 |
| class: a word in capitals | 2332 | 1132.09 ± 0.2% | 610.30 ± 0.2% | 30.67 ± 0.6% | 565.85 ± 0.4% | 47.30 ± 4.4% | 12.53 ± 0.3% | 101.82 ± 0.7% | 1130.93 ± 0.1% | 1.85 | 1.00 | 2.00 | 23.93 |
| class: a number | 8288 | 1827.07 ± 2.9% | 815.44 ± 0.7% | 31.06 ± 0.9% | 1800.01 ± 0.3% | 47.99 ± 20.0% | 0.39 ± 0.5% | 75.14 ± 0.7% | 1824.41 ± 0.1% | 2.24 | 1.00 | 1.02 | 38.07 |
| class: two capitalized words, second text | 5359 | 509.92 ± 0.6% | 518.69 ± 5.3% | 25.74 ± 34.2% | 477.05 ± 0.7% | 38.49 ± 12.0% | 12.76 ± 0.1% | 74.46 ± 0.4% | 511.67 ± 0.3% | 0.98 | 1.00 | 1.07 | 13.25 |
| other: a word between two words | 6104 | 848.19 ± 0.7% | 585.49 ± 0.8% | 25.44 ± 0.1% | 815.99 ± 0.6% | 131.73 ± 10.6% | 8.58 ± 0.1% | 83.22 ± 0.1% | 847.34 ± 0.5% | 1.45 | 1.00 | 1.04 | 6.44 |
| other: a number before a unit, second text | 1481 | 10488.01 ± 0.9% | 1053.20 ± 0.9% | 28.91 ± 29.3% | 8310.53 ± 0.1% | 44.50 ± 2.0% | 13.36 ± 0.2% | 78.02 ± 0.5% | 10453.59 ± 0.3% | 9.96 | 1.00 | 1.26 | 235.71 |
| other: a heading's start tag | 110 | 25634.82 ± 0.3% | 747.17 ± 0.1% | 30.70 ± 0.6% | 2570.98 ± 1.6% | 2012.25 ± 8.3% | 11.84 ± 0.2% | 110.33 ± 0.7% | 25568.60 ± 0.2% | 34.31 | 1.00 | 9.97 | 12.74 |
| other: a whole word | 217 | 31709.84 ± 0.7% | 607.18 ± 0.1% | 31.79 ± 3.3% | 28202.16 ± 8.4% | 53.55 ± 6.1% | 11.22 ± 0.2% | 62.55 ± 0.2% | 31794.15 ± 0.6% | 52.22 | 1.00 | 1.12 | 592.19 |
| other: a line's first word, second text | 3716 | 2609.60 ± 4.4% | 587.70 ± 0.4% | 35.33 ± 0.4% | 2333.52 ± 2.7% | 69.85 ± 3.8% | refused | refused | 2601.05 ± 2.0% | 4.44 | 1.00 | 1.12 | 37.36 |
| other: fourteen octets before an x | 87 | 37945.01 ± 0.9% | 263.05 ± 0.5% | 7.39 ± 0.3% | 3467.80 ± 0.6% | 11.42 ± 1.3% | differs | 19.27 ± 1.9% | 37897.52 ± 1.0% | 144.25 | 1.00 | 10.94 | 3321.75 |
| other: a Greek word | 21815 | 462.98 ± 0.5% | 396.41 ± 0.4% | 34.64 ± 0.6% | 303.66 ± 0.7% | 58.04 ± 9.7% | differs | refused | 461.85 ± 0.3% | 1.17 | 1.00 | 1.52 | 7.98 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 20.46 ± 0.4% | 20.41 ± 0.3% | 1.02 ± 0.5% | 19.77 ± 0.2% | 2.70 ± 1.0% | differs | 4.10 ± 1.6% | 20.48 ± 0.2% | 1.00 | 1.00 | 1.03 | 7.57 |
| a UUID | 32895 | 22.83 ± 1.2% | 22.60 ± 1.2% | 0.72 ± 0.6% | 15.11 ± 0.4% | 3.04 ± 3.5% | 0.52 ± 0.3% | 3.57 ± 0.3% | 22.79 ± 1.0% | 1.01 | 1.00 | 1.51 | 7.52 |
| an IPv4 address | 33176 | 36.82 ± 36.1% | 36.88 ± 11.7% | 2.32 ± 1.3% | 27.78 ± 0.0% | 6.63 ± 0.7% | differs | 3.95 ± 1.3% | 36.80 ± 2.4% | 1.00 | 1.00 | 1.33 | 5.55 |
| a date and time | 32954 | 32.22 ± 8.0% | 32.96 ± 2.1% | 1.70 ± 1.1% | 21.63 ± 0.5% | 8.19 ± 2.4% | 0.91 ± 0.6% | 7.19 ± 3.1% | 32.95 ± 1.3% | 0.98 | 0.98 | 1.49 | 3.94 |
| a field path | 32606 | 23.81 ± 0.1% | 23.62 ± 0.3% | 1.11 ± 1.8% | 22.91 ± 0.8% | 3.51 ± 2.0% | differs | 3.00 ± 0.6% | 23.84 ± 0.3% | 1.01 | 1.00 | 1.04 | 6.79 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.92 ± 0.6% | 10.91 ± 0.4% | 10.92 ± 0.7% | 13.39 ± 0.7% | 5.83 ± 2.5% | 0.76 ± 0.4% | none | 10.90 ± 0.4% | 1.00 | 1.00 | 0.82 | 1.87 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 238.51 ± 0.2% | 239.93 ± 0.3% | 273.36 ± 0.3% | 101.88 ± 2.0% | 245.89 ± 1.6% | 694.27 ± 5.3% | 4845.57 ± 0.6% | 238.43 ± 0.4% | 0.99 | 1.00 | 2.34 | 0.97 |
| a UUID | 62 | 155.05 ± 0.3% | 156.13 ± 0.2% | 170.97 ± 7.0% | 58.48 ± 5.2% | 120.52 ± 0.9% | 256.63 ± 1.8% | 5211.84 ± 0.8% | 155.15 ± 0.1% | 0.99 | 1.00 | 2.65 | 1.29 |
| an IPv4 address | 29 | 508.51 ± 1.5% | 514.78 ± 0.5% | 702.39 ± 1.1% | 88.36 ± 0.6% | 148.83 ± 2.4% | 412.85 ± 0.7% | 8957.34 ± 1.0% | 508.15 ± 0.3% | 0.99 | 1.00 | 5.76 | 3.42 |
| a date and time | 56 | 363.72 ± 0.6% | 366.67 ± 0.7% | 446.79 ± 6.9% | 86.94 ± 0.7% | 161.43 ± 1.3% | 477.00 ± 2.2% | 5279.74 ± 0.2% | 363.17 ± 0.6% | 0.99 | 1.00 | 4.18 | 2.25 |
| a field path | 39 | 231.69 ± 0.6% | 233.54 ± 0.3% | 264.82 ± 0.6% | 96.70 ± 1.9% | 230.27 ± 1.0% | 710.71 ± 0.9% | 5838.97 ± 0.6% | 231.68 ± 0.4% | 0.99 | 1.00 | 2.40 | 1.01 |
| literal: a word | 7 | 781.05 ± 0.9% | 836.37 ± 0.3% | 1419.62 ± 1.0% | 659.55 ± 1.9% | 788.11 ± 1.8% | 1621.96 ± 25.1% | 33481.68 ± 0.4% | 781.70 ± 1.2% | 0.93 | 1.00 | 1.18 | 0.99 |
| literal: a word that is not there | 8 | 749.37 ± 0.3% | 808.02 ± 1.4% | 1334.43 ± 0.3% | 606.63 ± 0.6% | 766.87 ± 2.5% | 1517.74 ± 0.7% | 32996.55 ± 0.8% | 749.51 ± 3.7% | 0.93 | 1.00 | 1.24 | 0.98 |
| literal: one of four words | 26 | 274.33 ± 1.1% | 461.53 ± 0.5% | 601.20 ± 1.8% | 53.53 ± 0.9% | 289.86 ± 19.4% | 545.58 ± 1.8% | 15933.57 ± 0.9% | 273.70 ± 0.3% | 0.59 | 1.00 | 5.13 | 0.95 |
| literal: a word in any case | 11 | 520.31 ± 1.0% | 556.67 ± 0.3% | 775.34 ± 0.8% | 18.66 ± 0.5% | 824.95 ± 1.5% | refused | 21783.49 ± 0.8% | 517.22 ± 1.2% | 0.93 | 1.01 | 27.88 | 0.63 |
| literal: an href attribute | 12 | 405.61 ± 0.4% | 423.36 ± 0.1% | 541.05 ± 0.5% | 51.01 ± 1.7% | 568.36 ± 2.0% | 1287.13 ± 1.7% | 24195.50 ± 0.7% | 405.22 ± 8.7% | 0.96 | 1.00 | 7.95 | 0.71 |
| literal: a word, second text | 10 | 688.48 ± 2.2% | 753.52 ± 0.3% | 1195.57 ± 0.4% | 539.23 ± 2.4% | 654.02 ± 3.4% | 1354.08 ± 15.5% | 29875.89 ± 7.2% | 687.95 ± 5.1% | 0.91 | 1.00 | 1.28 | 1.05 |
| class: two capitalized words | 23 | 534.42 ± 0.8% | 580.45 ± 1.0% | 809.65 ± 1.3% | 123.51 ± 0.4% | 594.85 ± 2.0% | 1234.02 ± 17.0% | 7855.45 ± 10.9% | 533.88 ± 0.5% | 0.92 | 1.00 | 4.33 | 0.90 |
| class: a word that ends in ing | 9 | 674.49 ± 0.2% | 778.76 ± 7.5% | 1296.43 ± 0.2% | 153.03 ± 0.8% | 850.29 ± 9.8% | 1902.63 ± 0.6% | 19091.87 ± 0.2% | 674.48 ± 0.6% | 0.87 | 1.00 | 4.41 | 0.79 |
| class: a word in capitals | 16 | 593.95 ± 1.5% | 651.73 ± 2.8% | 1004.23 ± 1.6% | 158.36 ± 0.3% | 889.31 ± 1.4% | 1795.61 ± 0.5% | 10482.66 ± 0.9% | 591.80 ± 0.5% | 0.91 | 1.00 | 3.75 | 0.67 |
| class: a number | 6 | 752.20 ± 0.5% | 852.31 ± 0.1% | 1522.20 ± 0.6% | 47.76 ± 0.8% | 1642.73 ± 0.6% | 3036.06 ± 3.6% | 25841.62 ± 0.4% | 752.37 ± 1.0% | 0.88 | 1.00 | 15.75 | 0.46 |
| class: two capitalized words, second text | 23 | 534.11 ± 0.3% | 580.21 ± 0.7% | 809.21 ± 1.5% | 121.71 ± 9.5% | 594.11 ± 2.8% | 1213.72 ± 0.2% | 7877.35 ± 0.1% | 534.08 ± 0.7% | 0.92 | 1.00 | 4.39 | 0.90 |
| other: a word between two words | 13 | 661.91 ± 0.3% | 688.16 ± 0.5% | 1037.67 ± 0.3% | 159.14 ± 1.0% | 582.37 ± 1.8% | 1356.76 ± 0.6% | 17230.37 ± 0.7% | 661.35 ± 15.3% | 0.96 | 1.00 | 4.16 | 1.14 |
| other: a number before a unit, second text | 15 | 448.16 ± 0.2% | 502.91 ± 0.2% | 673.01 ± 0.7% | 44.73 ± 1.4% | 723.01 ± 16.1% | 1478.05 ± 0.7% | 16585.19 ± 1.1% | 447.90 ± 0.2% | 0.89 | 1.00 | 10.02 | 0.62 |
| other: a heading's start tag | 13 | 416.36 ± 1.5% | 427.85 ± 0.4% | 547.73 ± 0.5% | 48.33 ± 0.4% | 704.78 ± 1.3% | 1372.05 ± 0.2% | 20733.15 ± 0.4% | 416.60 ± 8.8% | 0.97 | 1.00 | 8.62 | 0.59 |
| other: a whole word | 11 | 673.90 ± 1.7% | 717.47 ± 0.6% | 1126.29 ± 12.2% | 143.95 ± 1.0% | 679.27 ± 24.5% | 1350.16 ± 0.5% | 29221.76 ± 14.6% | 665.03 ± 15.5% | 0.94 | 1.01 | 4.68 | 0.99 |
| other: a line's first word, second text | 17 | 631.51 ± 0.9% | 666.27 ± 1.0% | 1024.89 ± 0.8% | 152.11 ± 0.8% | 799.67 ± 4.7% | refused | refused | 628.91 ± 1.1% | 0.95 | 1.00 | 4.15 | 0.79 |
| other: fourteen octets before an x | 16 | 117.85 ± 3.3% | 175.13 ± 0.6% | 201.65 ± 0.3% | 17.94 ± 0.3% | 519.51 ± 2.8% | 560.96 ± 1.8% | 15698.51 ± 0.8% | 117.89 ± 0.1% | 0.67 | 1.00 | 6.57 | 0.23 |
| other: a Greek word | 8 | 484.41 ± 0.8% | 688.65 ± 1.1% | 1069.05 ± 1.1% | 63.03 ± 0.4% | 1614.50 ± 17.0% | 2782.84 ± 1.9% | refused | 484.66 ± 0.3% | 0.70 | 1.00 | 7.69 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 36908.36 ± 0.6% | not timed | not timed | 33734.97 ± 1.7% | 2979.17 ± 13.2% | not timed | not timed | 36827.63 ± 0.5% | | 1.00 | 1.09 | 12.39 |
| 01-literal/sherlock-casei-en | 522 | 11334.43 ± 0.3% | not timed | not timed | 9039.49 ± 14.0% | 33.83 ± 0.6% | not timed | not timed | 11323.25 ± 0.2% | | 1.00 | 1.25 | 335.03 |
| 01-literal/sherlock-ru | 724 | 39022.81 ± 0.6% | not timed | not timed | 34592.04 ± 2.3% | 1297.32 ± 1.2% | not timed | not timed | 38996.18 ± 0.6% | | 1.00 | 1.13 | 30.08 |
| 01-literal/sherlock-casei-ru | 746 | 12516.57 ± 0.7% | not timed | not timed | 7801.64 ± 0.8% | 37.64 ± 1.2% | not timed | not timed | 12496.66 ± 0.4% | | 1.00 | 1.60 | 332.55 |
| 01-literal/sherlock-zh | 30 | 60350.98 ± 0.5% | not timed | not timed | 42972.27 ± 0.7% | 1634.15 ± 1.8% | not timed | not timed | 60279.77 ± 1.5% | | 1.00 | 1.40 | 36.93 |
| 02-literal-alternate/sherlock-en | 714 | 13684.26 ± 1.2% | not timed | not timed | 10920.34 ± 0.2% | 18.56 ± 0.5% | not timed | not timed | 13647.53 ± 0.5% | | 1.00 | 1.25 | 737.17 |
| 02-literal-alternate/sherlock-casei-en | 725 | 5236.74 ± 4.3% | not timed | not timed | 2301.12 ± 1.4% | 12.23 ± 0.6% | not timed | not timed | 4911.02 ± 1.5% | | 1.07 | 2.28 | 428.19 |
| 02-literal-alternate/sherlock-ru | 899 | 10991.72 ± 0.5% | not timed | not timed | 9826.68 ± 0.6% | 25.39 ± 0.5% | not timed | not timed | 10984.43 ± 0.3% | | 1.00 | 1.12 | 432.91 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2597.76 ± 3.3% | not timed | not timed | 1187.57 ± 0.5% | 10.54 ± 0.5% | not timed | not timed | 2515.50 ± 0.9% | | 1.03 | 2.19 | 246.56 |
| 02-literal-alternate/sherlock-zh | 207 | 19515.31 ± 0.8% | not timed | not timed | 12665.30 ± 0.1% | 34.22 ± 12.1% | not timed | not timed | 19507.00 ± 0.3% | | 1.00 | 1.54 | 570.27 |
| 03-date/ascii | 111817 | 127.51 ± 1.4% | not timed | not timed | 99.90 ± 0.7% | 0.22 ± 4.1% | not timed | not timed | 126.60 ± 0.9% | | 1.01 | 1.28 | 588.74 |
| 04-ruff-noqa/real | 84 | 487.28 ± 0.2% | not timed | not timed | 502.92 ± 0.5% | 21.13 ± 0.7% | not timed | not timed | 484.31 ± 2.1% | | 1.01 | 0.97 | 23.06 |
| 04-ruff-noqa/tweaked | 44 | 617.82 ± 0.9% | not timed | not timed | 517.76 ± 0.3% | 370.09 ± 9.3% | not timed | not timed | 618.38 ± 0.4% | | 1.00 | 1.19 | 1.67 |
| 05-lexer-veryl/single | 124800 | 5.00 ± 0.2% | not timed | not timed | 5.40 ± 0.3% | 0.26 ± 4.2% | not timed | not timed | 4.88 ± 2.3% | | 1.02 | 0.93 | 19.50 |
| 06-cloud-flare-redos/original | 107 | 406.60 ± 0.5% | not timed | not timed | 224.72 ± 1.5% | 25.82 ± 1.3% | not timed | not timed | 407.32 ± 0.5% | | 1.00 | 1.81 | 15.75 |
| 06-cloud-flare-redos/simplified-short | 102 | 397.08 ± 0.2% | not timed | not timed | 235.39 ± 15.5% | 27.73 ± 0.2% | not timed | not timed | 396.55 ± 0.3% | | 1.00 | 1.69 | 14.32 |
| 06-cloud-flare-redos/simplified-long | 10000 | 532.04 ± 0.2% | not timed | not timed | 259.41 ± 0.6% | 29.94 ± 0.3% | not timed | not timed | 531.56 ± 0.1% | | 1.00 | 2.05 | 17.77 |
| 07-unicode-character-data/parse-line | 558784 | 246.48 ± 7.2% | not timed | not timed | 196.65 ± 0.4% | 46.56 ± 11.3% | not timed | not timed | 239.38 ± 13.4% | | 1.03 | 1.25 | 5.29 |
| 08-words/all-english | 56691 | 112.50 ± 0.7% | not timed | not timed | 84.76 ± 0.3% | 13.77 ± 3.6% | not timed | not timed | 111.88 ± 0.4% | | 1.01 | 1.33 | 8.17 |
| 08-words/long-english | 839 | 614.37 ± 0.3% | not timed | not timed | 584.35 ± 0.4% | 34.84 ± 1.0% | not timed | not timed | 615.22 ± 0.2% | | 1.00 | 1.05 | 17.63 |
| 09-aws-keys/full | 0 | 495.44 ± 9.8% | not timed | not timed | 540.81 ± 0.7% | 67.50 ± 0.1% | not timed | not timed | 495.54 ± 0.1% | | 1.00 | 0.92 | 7.34 |
| 09-aws-keys/quick | 0 | 1188.52 ± 0.4% | not timed | not timed | 961.06 ± 0.4% | 416.41 ± 2.2% | not timed | not timed | 1189.27 ± 0.1% | | 1.00 | 1.24 | 2.85 |
| 10-bounded-repeat/letters-en | 1833 | 678.70 ± 0.8% | not timed | not timed | 555.65 ± 0.7% | 22.72 ± 0.7% | not timed | not timed | 679.56 ± 0.5% | | 1.00 | 1.22 | 29.87 |
| 10-bounded-repeat/letters-ru | 3475 | 530.25 ± 1.4% | not timed | not timed | 482.49 ± 0.2% | 24.48 ± 10.0% | not timed | not timed | 526.08 ± 1.3% | | 1.01 | 1.10 | 21.66 |
| 10-bounded-repeat/context | 53 | 83.30 ± 0.9% | not timed | not timed | 70.49 ± 0.7% | 22.45 ± 2.0% | not timed | not timed | 82.68 ± 1.0% | | 1.01 | 1.18 | 3.71 |
| 10-bounded-repeat/capitals | 11 | 639.05 ± 8.0% | not timed | not timed | 604.05 ± 0.4% | 40.20 ± 1.1% | not timed | not timed | 638.67 ± 7.9% | | 1.00 | 1.06 | 15.90 |
| 11-unstructured-to-json/extract | 600 | 71.77 ± 2.8% | not timed | not timed | 81.13 ± 1.0% | 52.60 ± 1.7% | not timed | not timed | 72.96 ± 3.6% | | 0.98 | 0.88 | 1.36 |
| 12-dictionary/single | 1 | 510.30 ± 0.2% | not timed | not timed | 482.04 ± 0.6% | 0.40 ± 3.0% | not timed | not timed | 511.80 ± 0.5% | | 1.00 | 1.06 | 1288.01 |
| 14-quadratic/1x | 100 | 26.24 ± 0.4% | not timed | not timed | 12.18 ± 0.4% | 1.04 ± 3.9% | not timed | not timed | 26.25 ± 1.9% | | 1.00 | 2.15 | 25.28 |
| 14-quadratic/2x | 200 | 19.93 ± 0.3% | not timed | not timed | 6.12 ± 0.1% | 0.56 ± 1.5% | not timed | not timed | 19.82 ± 0.9% | | 1.01 | 3.26 | 35.53 |
| 14-quadratic/10x | 1000 | 6.86 ± 0.9% | not timed | not timed | 1.22 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 6.85 ± 0.5% | | 1.00 | 5.64 | 56.82 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.41 ± 0.3% | not timed | not timed | 0.48 ± 0.8% | 0.64 ± 8.0% | not timed | not timed | 1.40 ± 0.3% | | 1.00 | 2.94 | 2.20 |
| 04-ruff-noqa/compile-real | 1 | 100.23 ± 0.6% | not timed | not timed | 17.19 ± 1.2% | 167.85 ± 4.7% | not timed | not timed | 99.41 ± 0.7% | | 1.01 | 5.83 | 0.60 |
| 05-lexer-veryl/compile-single | 1 | 16.11 ± 1.3% | not timed | not timed | 3.00 ± 0.6% | 7.69 ± 21.0% | not timed | not timed | 15.89 ± 5.2% | | 1.01 | 5.37 | 2.09 |
| 07-unicode-character-data/compile | 1 | 61.28 ± 4.5% | not timed | not timed | 30.29 ± 1.0% | 44.69 ± 1.0% | not timed | not timed | 61.06 ± 0.2% | | 1.00 | 2.02 | 1.37 |
| 09-aws-keys/compile-full | 1 | 43.66 ± 0.1% | not timed | not timed | 9.91 ± 2.3% | 27.98 ± 1.2% | not timed | not timed | 43.39 ± 1.1% | | 1.01 | 4.41 | 1.56 |
| 09-aws-keys/compile-quick | 1 | 194.40 ± 0.5% | not timed | not timed | 57.39 ± 0.8% | 157.08 ± 1.4% | not timed | not timed | 191.60 ± 0.9% | | 1.01 | 3.39 | 1.24 |
| 10-bounded-repeat/compile-context | 1 | 15.01 ± 0.3% | not timed | not timed | 14.29 ± 0.4% | 20.39 ± 3.4% | not timed | not timed | 14.86 ± 1.2% | | 1.01 | 1.05 | 0.74 |
| 10-bounded-repeat/compile-capitals | 1 | 91.61 ± 27.8% | not timed | not timed | 10.35 ± 0.9% | 29.62 ± 2.5% | not timed | not timed | 91.52 ± 9.6% | | 1.00 | 8.85 | 3.09 |
| 11-unstructured-to-json/compile | 1 | 94.04 ± 1.3% | not timed | not timed | 47.74 ± 0.4% | 80.38 ± 4.1% | not timed | not timed | 93.37 ± 1.0% | | 1.01 | 1.97 | 1.17 |
| 12-dictionary/compile-single | 1 | 0.34 ± 3.8% | not timed | not timed | 0.08 ± 16.5% | 0.10 ± 23.3% | not timed | not timed | 0.34 ± 0.9% | | 1.01 | 4.05 | 3.31 |

