# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102089674 |
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
| literal: a word | 217 | 40939.94 ± 0.6% | 1028.11 ± 0.4% | 31.35 ± 0.9% | 38839.26 ± 1.4% | 12228.22 ± 2.5% | 12.64 ± 7.6% | 103.09 ± 9.7% | 40824.60 ± 0.2% | 39.82 | 1.00 | 1.05 | 3.35 |
| literal: a word that is not there | 0 | 57530.82 ± 0.1% | 1040.75 ± 0.3% | 31.38 ± 0.2% | 45990.06 ± 4.4% | 43762.78 ± 7.2% | 12.50 ± 0.4% | 98.79 ± 0.3% | 57587.04 ± 3.8% | 55.28 | 1.00 | 1.25 | 1.31 |
| literal: one of four words | 661 | 14552.31 ± 4.5% | 1006.06 ± 0.2% | 17.33 ± 0.9% | 11167.51 ± 5.5% | 24.78 ± 5.7% | 4.47 ± 1.1% | 8.66 ± 0.3% | 14634.05 ± 0.2% | 14.46 | 0.99 | 1.30 | 587.24 |
| literal: a word in any case | 217 | 35985.77 ± 0.2% | 1026.83 ± 0.5% | 24.33 ± 0.3% | 11376.84 ± 3.0% | 46.96 ± 0.9% | refused | differs | 35882.50 ± 1.8% | 35.05 | 1.00 | 3.16 | 766.33 |
| literal: an href attribute | 33 | 34788.81 ± 0.8% | 1034.60 ± 0.4% | 30.20 ± 4.1% | 35168.87 ± 0.6% | 2933.99 ± 14.6% | 9.49 ± 0.3% | 91.29 ± 0.8% | 34664.93 ± 0.3% | 33.63 | 1.00 | 0.99 | 11.86 |
| literal: a word, second text | 123 | 44022.92 ± 0.5% | 1031.06 ± 0.1% | 30.99 ± 0.3% | 39003.26 ± 6.0% | 11098.95 ± 6.9% | 14.48 ± 3.3% | 88.78 ± 3.7% | 43982.21 ± 0.4% | 42.70 | 1.00 | 1.13 | 3.97 |
| class: two capitalized words | 1331 | 898.08 ± 0.3% | 950.10 ± 0.3% | 29.05 ± 4.7% | 574.67 ± 0.7% | 44.48 ± 0.2% | 10.87 ± 0.3% | 79.50 ± 2.5% | 897.60 ± 0.3% | 0.95 | 1.00 | 1.56 | 20.19 |
| class: a word that ends in ing | 3399 | 871.18 ± 0.4% | 870.87 ± 0.3% | 20.46 ± 0.5% | 540.69 ± 1.2% | 32.85 ± 10.1% | 6.19 ± 0.2% | 20.62 ± 1.2% | 869.12 ± 0.2% | 1.00 | 1.00 | 1.61 | 26.52 |
| class: a word in capitals | 2332 | 1150.65 ± 2.9% | 931.12 ± 0.3% | 30.72 ± 5.2% | 566.92 ± 0.1% | 47.87 ± 18.7% | 12.37 ± 0.2% | 102.39 ± 0.3% | 1154.68 ± 0.4% | 1.24 | 1.00 | 2.03 | 24.04 |
| class: a number | 8288 | 1815.33 ± 0.3% | 788.55 ± 2.2% | 31.90 ± 1.4% | 1784.56 ± 0.4% | 47.84 ± 13.3% | 0.38 ± 0.4% | 73.26 ± 2.5% | 1813.70 ± 0.6% | 2.30 | 1.00 | 1.02 | 37.95 |
| class: two capitalized words, second text | 5359 | 681.92 ± 0.9% | 683.17 ± 0.5% | 26.46 ± 0.3% | 478.44 ± 1.2% | 38.84 ± 5.9% | 12.70 ± 0.3% | 74.12 ± 0.5% | 683.56 ± 0.1% | 1.00 | 1.00 | 1.43 | 17.56 |
| other: a word between two words | 6104 | 769.63 ± 0.7% | 732.29 ± 0.2% | 26.20 ± 0.2% | 807.82 ± 0.6% | 129.11 ± 8.5% | 8.38 ± 0.2% | 82.45 ± 0.4% | 773.50 ± 0.4% | 1.05 | 1.00 | 0.95 | 5.96 |
| other: a number before a unit, second text | 1481 | 9444.25 ± 7.9% | 979.11 ± 0.4% | 29.12 ± 0.7% | 8207.66 ± 0.7% | 44.95 ± 7.5% | 13.28 ± 0.3% | 78.21 ± 0.5% | 9187.56 ± 0.3% | 9.65 | 1.03 | 1.15 | 210.12 |
| other: a heading's start tag | 110 | 24435.30 ± 0.5% | 1025.23 ± 0.1% | 30.97 ± 0.2% | 2532.98 ± 1.0% | 2026.92 ± 7.7% | 11.61 ± 0.2% | 107.14 ± 0.6% | 24417.15 ± 0.3% | 23.83 | 1.00 | 9.65 | 12.06 |
| other: a whole word | 217 | 29225.12 ± 4.7% | 1028.77 ± 0.3% | 31.84 ± 0.3% | 27501.23 ± 1.0% | 53.85 ± 11.8% | 10.88 ± 0.4% | 63.39 ± 0.2% | 28995.76 ± 0.2% | 28.41 | 1.01 | 1.06 | 542.69 |
| other: a line's first word, second text | 3716 | 2326.70 ± 1.5% | 848.45 ± 0.4% | 36.25 ± 0.4% | 2280.30 ± 1.0% | 70.36 ± 2.9% | refused | refused | 2302.39 ± 1.3% | 2.74 | 1.01 | 1.02 | 33.07 |
| other: fourteen octets before an x | 87 | 35170.72 ± 0.5% | 250.62 ± 0.4% | 6.05 ± 0.9% | 3529.33 ± 5.3% | 11.56 ± 6.0% | differs | 21.45 ± 0.5% | 35361.33 ± 0.4% | 140.33 | 0.99 | 9.97 | 3041.65 |
| other: a Greek word | 21815 | 464.22 ± 0.5% | 327.01 ± 0.2% | 34.90 ± 0.4% | 305.06 ± 0.9% | 57.00 ± 10.8% | differs | refused | 462.00 ± 0.4% | 1.42 | 1.00 | 1.52 | 8.14 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 30.24 ± 0.3% | 30.18 ± 5.8% | 1.00 ± 12.1% | 19.79 ± 0.0% | 2.50 ± 0.5% | differs | 4.33 ± 0.8% | 29.88 ± 6.4% | 1.00 | 1.01 | 1.53 | 12.12 |
| a UUID | 32895 | 24.44 ± 0.1% | 24.47 ± 1.2% | 0.73 ± 5.1% | 15.00 ± 0.2% | 3.02 ± 2.8% | 0.52 ± 0.8% | 3.83 ± 0.9% | 24.46 ± 0.2% | 1.00 | 1.00 | 1.63 | 8.10 |
| an IPv4 address | 33176 | 41.67 ± 5.4% | 41.89 ± 6.1% | 2.36 ± 1.0% | 28.22 ± 1.4% | 6.92 ± 8.5% | differs | 4.31 ± 1.2% | 41.97 ± 11.5% | 0.99 | 0.99 | 1.48 | 6.02 |
| a date and time | 32954 | 36.54 ± 0.3% | 36.58 ± 0.3% | 1.72 ± 0.5% | 21.62 ± 12.4% | 8.21 ± 3.5% | 0.91 ± 1.1% | 8.10 ± 28.3% | 36.38 ± 0.1% | 1.00 | 1.00 | 1.69 | 4.45 |
| a field path | 32606 | 33.31 ± 0.4% | 33.66 ± 1.5% | 1.09 ± 0.7% | 22.87 ± 3.7% | 3.55 ± 2.5% | differs | 3.08 ± 16.3% | 33.63 ± 0.7% | 0.99 | 0.99 | 1.46 | 9.38 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.26 ± 2.8% | 10.54 ± 0.5% | 10.30 ± 0.7% | 13.43 ± 0.7% | 5.80 ± 1.2% | 0.75 ± 0.9% | none | 10.54 ± 1.4% | 0.97 | 0.97 | 0.76 | 1.77 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 236.23 ± 0.9% | 238.66 ± 0.2% | 275.49 ± 0.3% | 101.88 ± 1.0% | 238.48 ± 9.5% | 714.24 ± 4.6% | 4960.80 ± 0.6% | 237.38 ± 0.3% | 0.99 | 1.00 | 2.32 | 0.99 |
| a UUID | 62 | 154.12 ± 0.4% | 154.54 ± 0.1% | 170.73 ± 0.7% | 58.67 ± 2.0% | 118.87 ± 7.0% | 257.10 ± 1.9% | 5519.85 ± 0.5% | 153.90 ± 0.6% | 1.00 | 1.00 | 2.63 | 1.30 |
| an IPv4 address | 29 | 510.31 ± 0.8% | 516.19 ± 11.9% | 737.66 ± 0.9% | 88.50 ± 1.6% | 146.58 ± 3.9% | 404.47 ± 1.5% | 8993.65 ± 2.6% | 510.25 ± 0.2% | 0.99 | 1.00 | 5.77 | 3.48 |
| a date and time | 56 | 377.24 ± 0.2% | 379.57 ± 0.3% | 484.02 ± 0.3% | 87.52 ± 1.3% | 158.53 ± 3.7% | 478.25 ± 2.4% | 5695.78 ± 0.3% | 376.42 ± 0.6% | 0.99 | 1.00 | 4.31 | 2.38 |
| a field path | 39 | 225.83 ± 0.2% | 226.90 ± 0.8% | 259.90 ± 10.0% | 96.74 ± 2.8% | 223.74 ± 2.0% | 739.60 ± 0.5% | 6053.56 ± 2.0% | 225.56 ± 0.1% | 1.00 | 1.00 | 2.33 | 1.01 |
| literal: a word | 7 | 767.65 ± 0.3% | 818.20 ± 0.3% | 1506.11 ± 0.5% | 648.25 ± 1.5% | 779.86 ± 41.2% | 1607.97 ± 0.6% | 34536.46 ± 16.7% | 768.53 ± 0.2% | 0.94 | 1.00 | 1.18 | 0.98 |
| literal: a word that is not there | 8 | 738.43 ± 9.3% | 791.90 ± 0.2% | 1417.95 ± 18.6% | 596.76 ± 0.5% | 764.44 ± 1.1% | 1511.65 ± 17.2% | 33848.71 ± 0.6% | 739.32 ± 0.4% | 0.93 | 1.00 | 1.24 | 0.97 |
| literal: one of four words | 26 | 284.17 ± 1.3% | 481.39 ± 2.4% | 654.00 ± 3.3% | 53.94 ± 1.0% | 287.78 ± 19.0% | 591.65 ± 1.8% | 18909.15 ± 0.6% | 282.21 ± 1.2% | 0.59 | 1.01 | 5.27 | 0.99 |
| literal: a word in any case | 11 | 580.55 ± 1.0% | 616.09 ± 0.5% | 959.27 ± 1.1% | 18.92 ± 0.9% | 824.93 ± 4.7% | refused | 27236.07 ± 1.0% | 577.90 ± 1.0% | 0.94 | 1.00 | 30.69 | 0.70 |
| literal: an href attribute | 12 | 412.03 ± 0.2% | 425.03 ± 0.4% | 563.66 ± 0.2% | 51.06 ± 0.6% | 566.71 ± 4.8% | 1296.84 ± 0.8% | 24836.98 ± 0.3% | 411.09 ± 0.1% | 0.97 | 1.00 | 8.07 | 0.73 |
| literal: a word, second text | 10 | 682.03 ± 0.1% | 739.47 ± 0.8% | 1274.55 ± 0.8% | 546.36 ± 1.7% | 654.39 ± 6.7% | 1381.19 ± 16.1% | 32106.25 ± 2.3% | 681.57 ± 16.7% | 0.92 | 1.00 | 1.25 | 1.04 |
| class: two capitalized words | 23 | 537.10 ± 0.3% | 582.39 ± 0.5% | 857.63 ± 9.1% | 123.72 ± 1.1% | 594.61 ± 56.7% | 1293.81 ± 1.2% | 8093.44 ± 0.4% | 536.70 ± 0.3% | 0.92 | 1.00 | 4.34 | 0.90 |
| class: a word that ends in ing | 9 | 662.15 ± 0.7% | 750.34 ± 0.8% | 1328.04 ± 12.3% | 153.61 ± 0.7% | 863.45 ± 2.5% | 1889.44 ± 0.7% | 19370.96 ± 0.7% | 662.85 ± 2.5% | 0.88 | 1.00 | 4.31 | 0.77 |
| class: a word in capitals | 16 | 591.82 ± 0.1% | 647.15 ± 1.2% | 1060.68 ± 11.0% | 158.91 ± 5.5% | 884.40 ± 7.1% | 1803.03 ± 1.7% | 10588.72 ± 0.4% | 592.78 ± 0.6% | 0.91 | 1.00 | 3.72 | 0.67 |
| class: a number | 6 | 724.93 ± 0.7% | 808.87 ± 0.6% | 1540.05 ± 0.2% | 47.56 ± 1.0% | 1631.91 ± 2.4% | 2960.94 ± 2.4% | 25743.10 ± 0.1% | 725.34 ± 0.2% | 0.90 | 1.00 | 15.24 | 0.44 |
| class: two capitalized words, second text | 23 | 535.90 ± 1.6% | 581.12 ± 0.6% | 858.74 ± 0.8% | 123.02 ± 0.6% | 600.25 ± 0.9% | 1235.09 ± 1.1% | 8082.70 ± 0.2% | 536.35 ± 1.0% | 0.92 | 1.00 | 4.36 | 0.89 |
| other: a word between two words | 13 | 658.40 ± 1.0% | 679.00 ± 0.2% | 1087.79 ± 0.9% | 158.45 ± 2.5% | 583.19 ± 24.0% | 1352.02 ± 1.2% | 17880.95 ± 0.3% | 658.26 ± 0.2% | 0.97 | 1.00 | 4.16 | 1.13 |
| other: a number before a unit, second text | 15 | 442.85 ± 1.3% | 492.37 ± 0.3% | 676.46 ± 0.6% | 44.33 ± 0.8% | 725.30 ± 7.7% | 1439.53 ± 3.4% | 17793.95 ± 0.9% | 443.72 ± 5.2% | 0.90 | 1.00 | 9.99 | 0.61 |
| other: a heading's start tag | 13 | 426.68 ± 0.5% | 435.17 ± 0.8% | 580.28 ± 0.4% | 48.49 ± 0.9% | 692.48 ± 12.9% | 1396.52 ± 0.4% | 20520.34 ± 0.8% | 426.64 ± 0.3% | 0.98 | 1.00 | 8.80 | 0.62 |
| other: a whole word | 11 | 671.17 ± 1.2% | 710.09 ± 17.2% | 1179.96 ± 1.5% | 143.57 ± 0.9% | 691.43 ± 0.9% | 1382.18 ± 1.3% | 31675.49 ± 15.6% | 670.99 ± 2.0% | 0.95 | 1.00 | 4.67 | 0.97 |
| other: a line's first word, second text | 17 | 626.53 ± 0.5% | 656.22 ± 7.2% | 1065.51 ± 0.2% | 149.50 ± 0.9% | 808.03 ± 25.7% | refused | refused | 619.17 ± 8.8% | 0.95 | 1.01 | 4.19 | 0.78 |
| other: fourteen octets before an x | 16 | 118.72 ± 1.0% | 178.84 ± 0.5% | 211.10 ± 0.3% | 18.12 ± 1.1% | 526.64 ± 8.1% | 581.32 ± 1.2% | 15596.85 ± 0.7% | 118.90 ± 2.6% | 0.66 | 1.00 | 6.55 | 0.23 |
| other: a Greek word | 8 | 460.62 ± 0.5% | 634.47 ± 0.3% | 1010.67 ± 0.6% | 63.15 ± 0.2% | 1547.50 ± 27.8% | 2764.38 ± 1.3% | refused | 460.85 ± 0.4% | 0.73 | 1.00 | 7.29 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 27258.01 ± 0.4% | not timed | not timed | 33753.35 ± 3.0% | 2914.41 ± 13.2% | not timed | not timed | 27168.75 ± 1.3% | | 1.00 | 0.81 | 9.35 |
| 01-literal/sherlock-casei-en | 522 | 6418.52 ± 5.3% | not timed | not timed | 8993.01 ± 0.8% | 34.00 ± 7.3% | not timed | not timed | 6387.34 ± 0.8% | | 1.00 | 0.71 | 188.78 |
| 01-literal/sherlock-ru | 724 | 29484.20 ± 14.5% | not timed | not timed | 34373.64 ± 1.2% | 1293.04 ± 15.8% | not timed | not timed | 29408.88 ± 0.4% | | 1.00 | 0.86 | 22.80 |
| 01-literal/sherlock-casei-ru | 746 | 8922.56 ± 1.4% | not timed | not timed | 7823.81 ± 0.7% | 37.47 ± 26.1% | not timed | not timed | 8892.83 ± 0.6% | | 1.00 | 1.14 | 238.12 |
| 01-literal/sherlock-zh | 30 | 51990.88 ± 0.5% | not timed | not timed | 42626.22 ± 28.4% | 1643.47 ± 2.6% | not timed | not timed | 51847.67 ± 0.2% | | 1.00 | 1.22 | 31.63 |
| 02-literal-alternate/sherlock-en | 714 | 13090.06 ± 4.7% | not timed | not timed | 10507.55 ± 0.9% | 19.06 ± 0.6% | not timed | not timed | 13100.35 ± 0.7% | | 1.00 | 1.25 | 686.80 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2150.26 ± 0.9% | not timed | not timed | 2309.49 ± 0.6% | 12.30 ± 0.8% | not timed | not timed | 2114.75 ± 0.5% | | 1.02 | 0.93 | 174.87 |
| 02-literal-alternate/sherlock-ru | 899 | 7571.25 ± 1.3% | not timed | not timed | 9794.39 ± 0.4% | 25.43 ± 0.2% | not timed | not timed | 7551.85 ± 0.2% | | 1.00 | 0.77 | 297.78 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2094.33 ± 0.5% | not timed | not timed | 1172.42 ± 0.3% | 10.52 ± 3.2% | not timed | not timed | 2101.98 ± 0.3% | | 1.00 | 1.79 | 198.99 |
| 02-literal-alternate/sherlock-zh | 207 | 18910.48 ± 0.9% | not timed | not timed | 12671.11 ± 0.8% | 35.44 ± 10.6% | not timed | not timed | 18865.14 ± 0.3% | | 1.00 | 1.49 | 533.58 |
| 03-date/ascii | 111817 | 128.00 ± 1.0% | not timed | not timed | 101.32 ± 0.2% | 0.23 ± 2.2% | not timed | not timed | 128.51 ± 0.8% | | 1.00 | 1.26 | 551.50 |
| 04-ruff-noqa/real | 84 | 684.42 ± 6.9% | not timed | not timed | 504.53 ± 7.5% | 18.30 ± 2.2% | not timed | not timed | 685.09 ± 5.9% | | 1.00 | 1.36 | 37.40 |
| 04-ruff-noqa/tweaked | 44 | 609.19 ± 0.4% | not timed | not timed | 515.21 ± 1.2% | 356.04 ± 16.7% | not timed | not timed | 613.08 ± 0.9% | | 0.99 | 1.18 | 1.71 |
| 05-lexer-veryl/single | 124800 | 3.63 ± 0.3% | not timed | not timed | 5.41 ± 1.1% | 0.25 ± 6.7% | not timed | not timed | 3.61 ± 24.5% | | 1.01 | 0.67 | 14.31 |
| 06-cloud-flare-redos/original | 107 | 219.37 ± 2.0% | not timed | not timed | 227.85 ± 0.6% | 25.59 ± 6.1% | not timed | not timed | 218.58 ± 15.2% | | 1.00 | 0.96 | 8.57 |
| 06-cloud-flare-redos/simplified-short | 102 | 160.90 ± 0.1% | not timed | not timed | 236.18 ± 7.6% | 27.28 ± 11.8% | not timed | not timed | 160.72 ± 0.5% | | 1.00 | 0.68 | 5.90 |
| 06-cloud-flare-redos/simplified-long | 10000 | 168.14 ± 1.1% | not timed | not timed | 259.50 ± 0.5% | 29.86 ± 1.2% | not timed | not timed | 167.91 ± 1.9% | | 1.00 | 0.65 | 5.63 |
| 07-unicode-character-data/parse-line | 558784 | 48.39 ± 1.7% | not timed | not timed | 202.74 ± 0.6% | 47.52 ± 4.5% | not timed | not timed | 49.33 ± 7.7% | | 0.98 | 0.24 | 1.02 |
| 08-words/all-english | 56691 | 98.82 ± 0.5% | not timed | not timed | 82.62 ± 0.5% | 15.26 ± 6.2% | not timed | not timed | 98.85 ± 12.7% | | 1.00 | 1.20 | 6.48 |
| 08-words/long-english | 839 | 984.27 ± 0.1% | not timed | not timed | 583.78 ± 0.3% | 35.00 ± 1.4% | not timed | not timed | 982.80 ± 0.2% | | 1.00 | 1.69 | 28.12 |
| 09-aws-keys/full | 0 | 523.22 ± 1.4% | not timed | not timed | 547.59 ± 12.4% | 66.91 ± 5.2% | not timed | not timed | 523.45 ± 0.5% | | 1.00 | 0.96 | 7.82 |
| 09-aws-keys/quick | 0 | 544.35 ± 0.3% | not timed | not timed | 964.99 ± 0.6% | 395.76 ± 2.6% | not timed | not timed | 545.96 ± 0.7% | | 1.00 | 0.56 | 1.38 |
| 10-bounded-repeat/letters-en | 1833 | 633.07 ± 1.6% | not timed | not timed | 556.39 ± 0.3% | 22.60 ± 0.9% | not timed | not timed | 629.96 ± 0.4% | | 1.00 | 1.14 | 28.02 |
| 10-bounded-repeat/letters-ru | 3475 | 369.99 ± 5.0% | not timed | not timed | 481.94 ± 0.2% | 24.91 ± 6.2% | not timed | not timed | 369.54 ± 0.3% | | 1.00 | 0.77 | 14.86 |
| 10-bounded-repeat/context | 53 | 77.31 ± 1.4% | not timed | not timed | 70.76 ± 1.4% | 22.52 ± 0.6% | not timed | not timed | 77.33 ± 1.2% | | 1.00 | 1.09 | 3.43 |
| 10-bounded-repeat/capitals | 11 | 1031.88 ± 0.6% | not timed | not timed | 604.51 ± 0.2% | 40.34 ± 0.4% | not timed | not timed | 1027.45 ± 1.7% | | 1.00 | 1.71 | 25.58 |
| 11-unstructured-to-json/extract | 600 | 26.73 ± 0.4% | not timed | not timed | 80.83 ± 1.7% | 31.65 ± 51.7% | not timed | not timed | 26.52 ± 3.3% | | 1.01 | 0.33 | 0.84 |
| 12-dictionary/single | 1 | 507.95 ± 0.1% | not timed | not timed | 480.22 ± 0.1% | 0.39 ± 2.9% | not timed | not timed | 511.01 ± 0.8% | | 0.99 | 1.06 | 1309.68 |
| 14-quadratic/1x | 100 | 13.45 ± 0.3% | not timed | not timed | 12.11 ± 8.5% | 1.02 ± 2.2% | not timed | not timed | 13.39 ± 0.7% | | 1.00 | 1.11 | 13.17 |
| 14-quadratic/2x | 200 | 8.03 ± 1.0% | not timed | not timed | 6.13 ± 0.2% | 0.56 ± 1.2% | not timed | not timed | 8.00 ± 3.1% | | 1.00 | 1.31 | 14.40 |
| 14-quadratic/10x | 1000 | 1.83 ± 0.4% | not timed | not timed | 1.22 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 1.83 ± 3.7% | | 1.00 | 1.50 | 15.48 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.70 ± 0.4% | not timed | not timed | 0.48 ± 0.5% | 0.64 ± 5.0% | not timed | not timed | 1.68 ± 1.5% | | 1.01 | 3.57 | 2.65 |
| 04-ruff-noqa/compile-real | 1 | 99.21 ± 0.3% | not timed | not timed | 17.42 ± 0.9% | 168.55 ± 6.3% | not timed | not timed | 98.89 ± 0.5% | | 1.00 | 5.69 | 0.59 |
| 05-lexer-veryl/compile-single | 1 | 17.03 ± 1.9% | not timed | not timed | 2.98 ± 1.2% | 7.88 ± 1.4% | not timed | not timed | 17.08 ± 0.3% | | 1.00 | 5.72 | 2.16 |
| 07-unicode-character-data/compile | 1 | 63.57 ± 0.7% | not timed | not timed | 30.46 ± 0.7% | 44.34 ± 0.8% | not timed | not timed | 63.66 ± 1.1% | | 1.00 | 2.09 | 1.43 |
| 09-aws-keys/compile-full | 1 | 45.06 ± 9.0% | not timed | not timed | 9.93 ± 0.6% | 27.76 ± 1.4% | not timed | not timed | 45.04 ± 0.3% | | 1.00 | 4.54 | 1.62 |
| 09-aws-keys/compile-quick | 1 | 203.20 ± 0.5% | not timed | not timed | 57.54 ± 0.5% | 158.16 ± 2.3% | not timed | not timed | 202.24 ± 2.4% | | 1.00 | 3.53 | 1.28 |
| 10-bounded-repeat/compile-context | 1 | 15.82 ± 0.2% | not timed | not timed | 14.49 ± 0.3% | 20.26 ± 1.8% | not timed | not timed | 15.73 ± 7.3% | | 1.01 | 1.09 | 0.78 |
| 10-bounded-repeat/compile-capitals | 1 | 94.69 ± 5.5% | not timed | not timed | 10.59 ± 5.9% | 29.06 ± 2.5% | not timed | not timed | 94.82 ± 0.8% | | 1.00 | 8.94 | 3.26 |
| 11-unstructured-to-json/compile | 1 | 98.38 ± 0.6% | not timed | not timed | 47.52 ± 17.5% | 79.45 ± 1.3% | not timed | not timed | 97.71 ± 1.2% | | 1.01 | 2.07 | 1.24 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.8% | not timed | not timed | 0.08 ± 20.2% | 0.11 ± 16.5% | not timed | not timed | 0.35 ± 1.3% | | 1.01 | 4.14 | 3.19 |

