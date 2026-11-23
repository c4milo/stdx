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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127362752 |
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
| literal: a word | 217 | 32512.67 ± 3.5% | 842.61 ± 0.3% | 20.03 ± 2.7% | 30675.69 ± 1.3% | 8966.70 ± 8.2% | 10.76 ± 0.1% | 76.81 ± 2.1% | 32477.46 ± 1.2% | 38.59 | 1.00 | 1.06 | 3.63 |
| literal: a word that is not there | 0 | 49229.79 ± 0.7% | 850.16 ± 1.2% | 19.64 ± 2.2% | 39219.38 ± 1.0% | 29323.51 ± 0.9% | 10.68 ± 0.4% | 72.89 ± 4.3% | 48701.70 ± 1.9% | 57.91 | 1.01 | 1.26 | 1.68 |
| literal: one of four words | 661 | 10841.42 ± 1.9% | 824.40 ± 0.2% | 10.94 ± 3.6% | 9074.02 ± 1.8% | 19.19 ± 5.9% | 4.00 ± 0.4% | 6.68 ± 0.4% | 10942.49 ± 1.3% | 13.15 | 0.99 | 1.19 | 564.83 |
| literal: a word in any case | 217 | 25743.57 ± 1.7% | 840.77 ± 0.3% | 14.87 ± 0.8% | 9214.92 ± 4.7% | 37.27 ± 5.5% | refused | differs | 25510.85 ± 3.8% | 30.62 | 1.01 | 2.79 | 690.75 |
| literal: an href attribute | 33 | 26434.34 ± 4.7% | 847.89 ± 0.3% | 18.22 ± 1.6% | 26879.40 ± 1.9% | 2051.44 ± 0.9% | 8.20 ± 0.4% | 61.61 ± 5.6% | 26265.98 ± 4.3% | 31.18 | 1.01 | 0.98 | 12.89 |
| literal: a word, second text | 123 | 33970.79 ± 3.0% | 845.59 ± 0.3% | 19.82 ± 3.9% | 31670.47 ± 1.1% | 7229.06 ± 5.1% | 11.75 ± 0.2% | 66.50 ± 2.1% | 33458.37 ± 1.2% | 40.17 | 1.02 | 1.07 | 4.70 |
| class: two capitalized words | 1331 | 785.05 ± 0.2% | 786.51 ± 1.2% | 18.60 ± 2.7% | 505.27 ± 0.7% | 34.30 ± 0.3% | 9.19 ± 0.4% | 55.68 ± 1.1% | 785.79 ± 0.7% | 1.00 | 1.00 | 1.55 | 22.88 |
| class: a word that ends in ing | 3399 | 716.01 ± 0.2% | 715.72 ± 1.1% | 12.83 ± 2.2% | 470.87 ± 1.0% | 25.55 ± 27.2% | 5.34 ± 0.4% | 17.17 ± 8.0% | 716.18 ± 0.1% | 1.00 | 1.00 | 1.52 | 28.03 |
| class: a word in capitals | 2332 | 987.40 ± 0.2% | 769.70 ± 0.3% | 19.63 ± 1.3% | 496.27 ± 0.5% | 36.55 ± 10.2% | 10.18 ± 0.1% | 76.31 ± 0.6% | 986.95 ± 0.2% | 1.28 | 1.00 | 1.99 | 27.01 |
| class: a number | 8288 | 1427.00 ± 0.1% | 659.06 ± 0.3% | 19.15 ± 1.8% | 1458.32 ± 0.2% | 36.26 ± 17.7% | 0.33 ± 0.6% | 55.67 ± 0.5% | 1424.47 ± 1.0% | 2.17 | 1.00 | 0.98 | 39.36 |
| class: two capitalized words, second text | 5359 | 593.85 ± 0.5% | 593.37 ± 0.3% | 17.05 ± 4.0% | 417.89 ± 0.2% | 30.17 ± 4.0% | 10.46 ± 0.1% | 51.59 ± 0.2% | 592.62 ± 0.3% | 1.00 | 1.00 | 1.42 | 19.69 |
| other: a word between two words | 6104 | 641.96 ± 0.6% | 615.44 ± 0.4% | 16.78 ± 1.1% | 697.47 ± 0.4% | 105.06 ± 11.1% | 7.17 ± 0.9% | 56.62 ± 0.7% | 641.63 ± 0.2% | 1.04 | 1.00 | 0.92 | 6.11 |
| other: a number before a unit, second text | 1481 | 6580.67 ± 4.4% | 792.65 ± 0.2% | 18.62 ± 2.1% | 6441.42 ± 5.9% | 35.15 ± 0.2% | 10.87 ± 0.9% | 55.08 ± 0.3% | 6545.82 ± 0.8% | 8.30 | 1.01 | 1.02 | 187.24 |
| other: a heading's start tag | 110 | 18815.23 ± 1.2% | 842.37 ± 0.2% | 19.06 ± 2.7% | 2009.33 ± 0.7% | 1479.69 ± 6.9% | 10.01 ± 0.1% | 72.69 ± 0.5% | 18722.50 ± 2.1% | 22.34 | 1.00 | 9.36 | 12.72 |
| other: a whole word | 217 | 22386.65 ± 2.4% | 842.14 ± 0.4% | 19.51 ± 4.8% | 22452.84 ± 10.9% | 40.77 ± 0.2% | 9.46 ± 0.1% | 46.79 ± 0.4% | 22107.84 ± 1.5% | 26.58 | 1.01 | 1.00 | 549.13 |
| other: a line's first word, second text | 3716 | 1717.09 ± 0.6% | 705.09 ± 0.2% | 22.18 ± 0.6% | 1704.87 ± 2.0% | 52.75 ± 4.7% | refused | refused | 1704.35 ± 0.6% | 2.44 | 1.01 | 1.01 | 32.55 |
| other: fourteen octets before an x | 87 | 25124.93 ± 1.1% | 199.07 ± 1.0% | 5.11 ± 0.5% | 2966.08 ± 0.9% | 9.00 ± 6.5% | differs | 15.46 ± 1.7% | 25165.37 ± 1.5% | 126.21 | 1.00 | 8.47 | 2790.49 |
| other: a Greek word | 21815 | 394.84 ± 2.3% | 290.50 ± 2.3% | 23.21 ± 1.9% | 265.52 ± 0.9% | 42.66 ± 10.7% | differs | refused | 394.01 ± 0.7% | 1.36 | 1.00 | 1.49 | 9.25 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.50 ± 0.9% | 24.15 ± 0.5% | 0.71 ± 0.7% | 16.82 ± 1.0% | 2.34 ± 0.8% | differs | 3.66 ± 1.5% | 24.70 ± 1.8% | 1.01 | 0.99 | 1.46 | 10.48 |
| a UUID | 32895 | 20.50 ± 0.5% | 20.56 ± 0.1% | 0.55 ± 0.7% | 12.91 ± 0.2% | 2.51 ± 0.7% | 0.44 ± 0.3% | 3.09 ± 0.1% | 20.31 ± 0.1% | 1.00 | 1.01 | 1.59 | 8.18 |
| an IPv4 address | 33176 | 33.87 ± 6.8% | 33.87 ± 0.7% | 1.76 ± 0.4% | 24.13 ± 0.3% | 5.82 ± 1.3% | differs | 3.36 ± 12.4% | 34.20 ± 1.8% | 1.00 | 0.99 | 1.40 | 5.82 |
| a date and time | 32954 | 30.27 ± 8.0% | 30.37 ± 0.3% | 1.27 ± 0.3% | 18.05 ± 0.2% | 6.71 ± 0.6% | 0.76 ± 0.3% | 6.19 ± 11.2% | 30.35 ± 8.0% | 1.00 | 1.00 | 1.68 | 4.51 |
| a field path | 32606 | 27.34 ± 3.8% | 27.35 ± 0.8% | 0.85 ± 0.3% | 19.41 ± 0.5% | 2.96 ± 0.4% | differs | 2.46 ± 1.5% | 27.09 ± 8.1% | 1.00 | 1.01 | 1.41 | 9.25 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.24 ± 2.9% | 8.30 ± 0.6% | 8.27 ± 13.1% | 10.69 ± 1.1% | 4.74 ± 1.2% | 0.62 ± 0.4% | none | 8.29 ± 1.7% | 0.99 | 0.99 | 0.77 | 1.74 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 185.38 ± 0.3% | 185.24 ± 6.7% | 215.56 ± 0.4% | 78.24 ± 3.3% | 182.87 ± 10.2% | 543.92 ± 3.1% | 3988.88 ± 3.2% | 184.29 ± 13.8% | 1.00 | 1.01 | 2.37 | 1.01 |
| a UUID | 62 | 120.85 ± 2.1% | 120.68 ± 1.9% | 133.49 ± 10.0% | 45.96 ± 3.7% | 90.73 ± 4.4% | 202.63 ± 4.6% | 4106.56 ± 2.2% | 119.39 ± 7.9% | 1.00 | 1.01 | 2.63 | 1.33 |
| an IPv4 address | 29 | 393.60 ± 6.0% | 397.45 ± 1.2% | 556.64 ± 1.2% | 69.41 ± 3.0% | 115.01 ± 1.2% | 333.63 ± 2.1% | 7178.09 ± 0.7% | 394.79 ± 0.5% | 0.99 | 1.00 | 5.67 | 3.42 |
| a date and time | 56 | 284.95 ± 0.5% | 286.38 ± 0.5% | 358.24 ± 7.4% | 68.46 ± 3.6% | 123.19 ± 1.6% | 374.25 ± 0.9% | 4244.77 ± 0.5% | 285.33 ± 0.2% | 1.00 | 1.00 | 4.16 | 2.31 |
| a field path | 39 | 180.91 ± 0.3% | 181.41 ± 0.2% | 208.36 ± 0.8% | 74.30 ± 2.0% | 173.80 ± 1.0% | 593.37 ± 2.4% | 4829.12 ± 1.8% | 180.90 ± 6.3% | 1.00 | 1.00 | 2.44 | 1.04 |
| literal: a word | 7 | 587.61 ± 0.4% | 623.72 ± 13.8% | 1085.97 ± 13.8% | 492.63 ± 1.2% | 573.23 ± 3.6% | 1268.96 ± 0.1% | 25147.59 ± 0.8% | 588.31 ± 0.6% | 0.94 | 1.00 | 1.19 | 1.03 |
| literal: a word that is not there | 8 | 567.16 ± 1.0% | 606.00 ± 0.7% | 1036.60 ± 0.3% | 451.19 ± 11.5% | 551.69 ± 2.2% | 1194.47 ± 0.3% | 23974.21 ± 0.5% | 565.66 ± 0.7% | 0.94 | 1.00 | 1.26 | 1.03 |
| literal: one of four words | 26 | 222.00 ± 8.7% | 362.30 ± 0.3% | 484.00 ± 10.7% | 41.70 ± 0.6% | 217.51 ± 2.8% | 456.24 ± 9.0% | 11667.30 ± 1.2% | 222.29 ± 0.4% | 0.61 | 1.00 | 5.32 | 1.02 |
| literal: a word in any case | 11 | 453.31 ± 9.5% | 479.06 ± 6.9% | 726.51 ± 0.6% | 14.53 ± 0.6% | 599.77 ± 2.7% | refused | 19405.13 ± 2.7% | 453.00 ± 0.2% | 0.95 | 1.00 | 31.20 | 0.76 |
| literal: an href attribute | 12 | 318.47 ± 1.3% | 329.95 ± 0.3% | 430.72 ± 1.3% | 36.55 ± 1.3% | 425.94 ± 1.4% | 975.88 ± 0.4% | 18356.44 ± 0.9% | 318.06 ± 0.6% | 0.97 | 1.00 | 8.71 | 0.75 |
| literal: a word, second text | 10 | 523.17 ± 1.5% | 568.27 ± 1.0% | 932.43 ± 1.8% | 418.57 ± 1.2% | 482.96 ± 3.3% | 1019.32 ± 2.7% | 21752.48 ± 0.8% | 523.29 ± 0.2% | 0.92 | 1.00 | 1.25 | 1.08 |
| class: two capitalized words | 23 | 417.37 ± 8.0% | 445.82 ± 0.4% | 642.73 ± 12.5% | 93.02 ± 0.3% | 444.36 ± 1.1% | 965.23 ± 10.8% | 6389.26 ± 0.4% | 417.41 ± 1.0% | 0.94 | 1.00 | 4.49 | 0.94 |
| class: a word that ends in ing | 9 | 509.91 ± 0.8% | 568.97 ± 1.1% | 994.06 ± 0.6% | 115.38 ± 1.5% | 617.92 ± 3.7% | 1466.33 ± 1.2% | 15251.61 ± 0.5% | 509.46 ± 0.4% | 0.90 | 1.00 | 4.42 | 0.83 |
| class: a word in capitals | 16 | 443.95 ± 4.2% | 477.91 ± 1.2% | 781.13 ± 5.5% | 121.22 ± 4.2% | 638.47 ± 2.2% | 1330.21 ± 0.7% | 8384.14 ± 1.6% | 445.44 ± 0.5% | 0.93 | 1.00 | 3.66 | 0.70 |
| class: a number | 6 | 559.76 ± 1.3% | 614.68 ± 0.8% | 1163.63 ± 0.9% | 36.21 ± 1.0% | 1132.22 ± 3.5% | 2396.04 ± 0.9% | 20416.77 ± 0.6% | 560.97 ± 0.3% | 0.91 | 1.00 | 15.46 | 0.49 |
| class: two capitalized words, second text | 23 | 417.93 ± 0.4% | 444.30 ± 5.3% | 642.66 ± 2.2% | 93.52 ± 3.2% | 445.53 ± 1.2% | 985.26 ± 1.0% | 6384.42 ± 0.4% | 417.25 ± 0.9% | 0.94 | 1.00 | 4.47 | 0.94 |
| other: a word between two words | 13 | 502.81 ± 1.6% | 518.45 ± 0.4% | 802.18 ± 0.8% | 122.99 ± 2.9% | 429.08 ± 1.2% | 1055.38 ± 0.4% | 14069.60 ± 0.3% | 503.07 ± 0.5% | 0.97 | 1.00 | 4.09 | 1.17 |
| other: a number before a unit, second text | 15 | 355.38 ± 0.4% | 389.54 ± 0.8% | 535.21 ± 9.5% | 33.53 ± 0.7% | 536.19 ± 2.3% | 1153.91 ± 3.1% | 13905.33 ± 1.9% | 354.94 ± 0.5% | 0.91 | 1.00 | 10.60 | 0.66 |
| other: a heading's start tag | 13 | 332.90 ± 3.8% | 338.05 ± 0.6% | 443.15 ± 9.5% | 35.47 ± 0.8% | 525.77 ± 1.9% | 1069.96 ± 10.0% | 16348.97 ± 4.0% | 332.09 ± 6.4% | 0.98 | 1.00 | 9.39 | 0.63 |
| other: a whole word | 11 | 508.42 ± 0.8% | 537.87 ± 11.7% | 861.28 ± 0.9% | 111.53 ± 0.9% | 506.18 ± 2.1% | 1050.99 ± 1.0% | 20684.34 ± 0.6% | 510.49 ± 1.1% | 0.95 | 1.00 | 4.56 | 1.00 |
| other: a line's first word, second text | 17 | 485.99 ± 0.9% | 505.84 ± 0.2% | 826.84 ± 1.0% | 112.86 ± 9.3% | 582.49 ± 3.7% | refused | refused | 485.11 ± 0.4% | 0.96 | 1.00 | 4.31 | 0.83 |
| other: fourteen octets before an x | 16 | 87.81 ± 6.9% | 124.77 ± 0.2% | 144.06 ± 0.2% | 14.19 ± 1.4% | 400.66 ± 3.1% | 451.60 ± 2.1% | 11843.57 ± 0.2% | 88.12 ± 1.3% | 0.70 | 1.00 | 6.19 | 0.22 |
| other: a Greek word | 8 | 379.24 ± 2.3% | 505.08 ± 3.9% | 824.66 ± 3.6% | 45.74 ± 44.9% | 1101.26 ± 48.4% | 2182.69 ± 3.3% | refused | 376.47 ± 2.6% | 0.75 | 1.01 | 8.29 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20821.09 ± 3.8% | not timed | not timed | 26527.32 ± 14.3% | 2000.89 ± 11.8% | not timed | not timed | 20800.63 ± 0.9% | | 1.00 | 0.78 | 10.41 |
| 01-literal/sherlock-casei-en | 522 | 4660.44 ± 5.8% | not timed | not timed | 7033.50 ± 0.4% | 28.60 ± 0.5% | not timed | not timed | 4618.84 ± 0.5% | | 1.01 | 0.66 | 162.96 |
| 01-literal/sherlock-ru | 724 | 22744.85 ± 10.9% | not timed | not timed | 27161.05 ± 0.9% | 1063.45 ± 27.2% | not timed | not timed | 22837.66 ± 1.8% | | 1.00 | 0.84 | 21.39 |
| 01-literal/sherlock-casei-ru | 746 | 7275.86 ± 1.2% | not timed | not timed | 5470.40 ± 0.6% | 30.46 ± 0.9% | not timed | not timed | 7275.86 ± 3.7% | | 1.00 | 1.33 | 238.90 |
| 01-literal/sherlock-zh | 30 | 41507.61 ± 1.7% | not timed | not timed | 36339.52 ± 0.7% | 1262.74 ± 0.1% | not timed | not timed | 41522.81 ± 0.6% | | 1.00 | 1.14 | 32.87 |
| 02-literal-alternate/sherlock-en | 714 | 9458.51 ± 0.7% | not timed | not timed | 8881.60 ± 0.6% | 14.20 ± 3.6% | not timed | not timed | 9480.47 ± 1.1% | | 1.00 | 1.06 | 666.21 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1731.72 ± 0.2% | not timed | not timed | 1818.88 ± 0.2% | 9.53 ± 0.7% | not timed | not timed | 1713.36 ± 0.6% | | 1.01 | 0.95 | 181.76 |
| 02-literal-alternate/sherlock-ru | 899 | 5959.58 ± 1.1% | not timed | not timed | 4254.64 ± 1.5% | 18.76 ± 2.1% | not timed | not timed | 5946.59 ± 0.5% | | 1.00 | 1.40 | 317.67 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1797.87 ± 0.1% | not timed | not timed | 1037.97 ± 0.1% | 8.29 ± 4.7% | not timed | not timed | 1794.48 ± 5.3% | | 1.00 | 1.73 | 216.84 |
| 02-literal-alternate/sherlock-zh | 207 | 13668.94 ± 0.9% | not timed | not timed | 10369.54 ± 0.5% | 26.90 ± 0.8% | not timed | not timed | 13747.99 ± 1.1% | | 0.99 | 1.32 | 508.08 |
| 03-date/ascii | 111817 | 98.47 ± 1.6% | not timed | not timed | 85.47 ± 0.5% | 0.18 ± 2.5% | not timed | not timed | 98.37 ± 1.1% | | 1.00 | 1.15 | 546.34 |
| 04-ruff-noqa/real | 84 | 545.23 ± 15.7% | not timed | not timed | 426.53 ± 0.2% | 15.95 ± 1.2% | not timed | not timed | 544.24 ± 1.0% | | 1.00 | 1.28 | 34.17 |
| 04-ruff-noqa/tweaked | 44 | 476.56 ± 0.3% | not timed | not timed | 422.77 ± 0.4% | 293.75 ± 0.8% | not timed | not timed | 482.46 ± 0.5% | | 0.99 | 1.13 | 1.62 |
| 05-lexer-veryl/single | 124800 | 2.73 ± 1.8% | not timed | not timed | 4.19 ± 1.9% | 0.22 ± 2.9% | not timed | not timed | 2.74 ± 2.1% | | 1.00 | 0.65 | 12.67 |
| 06-cloud-flare-redos/original | 107 | 229.66 ± 1.5% | not timed | not timed | 191.26 ± 5.3% | 20.67 ± 14.1% | not timed | not timed | 230.08 ± 0.2% | | 1.00 | 1.20 | 11.11 |
| 06-cloud-flare-redos/simplified-short | 102 | 219.83 ± 0.4% | not timed | not timed | 192.48 ± 0.3% | 22.03 ± 6.0% | not timed | not timed | 220.43 ± 0.4% | | 1.00 | 1.14 | 9.98 |
| 06-cloud-flare-redos/simplified-long | 10000 | 246.73 ± 0.6% | not timed | not timed | 211.60 ± 17.4% | 23.97 ± 0.3% | not timed | not timed | 246.78 ± 0.1% | | 1.00 | 1.17 | 10.29 |
| 07-unicode-character-data/parse-line | 558784 | 194.03 ± 3.4% | not timed | not timed | 159.91 ± 1.9% | 35.85 ± 6.5% | not timed | not timed | 190.79 ± 2.6% | | 1.02 | 1.21 | 5.41 |
| 08-words/all-english | 56691 | 90.98 ± 2.6% | not timed | not timed | 70.89 ± 1.8% | 10.01 ± 4.8% | not timed | not timed | 90.50 ± 13.7% | | 1.01 | 1.28 | 9.09 |
| 08-words/long-english | 839 | 809.27 ± 0.3% | not timed | not timed | 515.30 ± 0.2% | 25.65 ± 0.7% | not timed | not timed | 809.84 ± 0.1% | | 1.00 | 1.57 | 31.55 |
| 09-aws-keys/full | 0 | 424.13 ± 0.3% | not timed | not timed | 444.74 ± 0.5% | 55.05 ± 5.4% | not timed | not timed | 422.73 ± 0.3% | | 1.00 | 0.95 | 7.70 |
| 09-aws-keys/quick | 0 | 823.70 ± 7.7% | not timed | not timed | 804.69 ± 0.4% | 331.78 ± 1.4% | not timed | not timed | 823.82 ± 27.0% | | 1.00 | 1.02 | 2.48 |
| 10-bounded-repeat/letters-en | 1833 | 488.69 ± 3.8% | not timed | not timed | 431.15 ± 0.1% | 16.90 ± 1.2% | not timed | not timed | 489.69 ± 2.5% | | 1.00 | 1.13 | 28.92 |
| 10-bounded-repeat/letters-ru | 3475 | 317.11 ± 4.6% | not timed | not timed | 407.70 ± 0.2% | 19.79 ± 14.9% | not timed | not timed | 316.97 ± 2.1% | | 1.00 | 0.78 | 16.03 |
| 10-bounded-repeat/context | 53 | 65.83 ± 9.1% | not timed | not timed | 56.42 ± 0.4% | 16.12 ± 3.0% | not timed | not timed | 65.84 ± 1.2% | | 1.00 | 1.17 | 4.08 |
| 10-bounded-repeat/capitals | 11 | 842.80 ± 0.3% | not timed | not timed | 531.52 ± 0.7% | 30.85 ± 6.2% | not timed | not timed | 842.36 ± 0.6% | | 1.00 | 1.59 | 27.32 |
| 11-unstructured-to-json/extract | 600 | 35.80 ± 0.1% | not timed | not timed | 60.54 ± 0.9% | 40.27 ± 14.7% | not timed | not timed | 35.84 ± 0.4% | | 1.00 | 0.59 | 0.89 |
| 12-dictionary/single | 1 | 462.78 ± 0.5% | not timed | not timed | 436.70 ± 0.3% | 0.32 ± 0.3% | not timed | not timed | 464.31 ± 0.3% | | 1.00 | 1.06 | 1432.03 |
| 14-quadratic/1x | 100 | 10.20 ± 0.7% | not timed | not timed | 9.12 ± 0.7% | 0.81 ± 1.8% | not timed | not timed | 10.12 ± 1.2% | | 1.01 | 1.12 | 12.60 |
| 14-quadratic/2x | 200 | 6.36 ± 0.2% | not timed | not timed | 4.91 ± 0.6% | 0.43 ± 4.2% | not timed | not timed | 6.34 ± 0.2% | | 1.00 | 1.29 | 14.70 |
| 14-quadratic/10x | 1000 | 1.51 ± 0.5% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 13.2% | not timed | not timed | 1.51 ± 0.3% | | 1.00 | 1.44 | 16.24 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.34 ± 1.0% | not timed | not timed | 0.38 ± 2.9% | 0.48 ± 10.5% | not timed | not timed | 1.34 ± 1.8% | | 1.00 | 3.49 | 2.81 |
| 04-ruff-noqa/compile-real | 1 | 79.89 ± 0.2% | not timed | not timed | 12.86 ± 1.8% | 122.90 ± 3.4% | not timed | not timed | 79.02 ± 1.8% | | 1.01 | 6.21 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 12.82 ± 4.5% | not timed | not timed | 2.36 ± 4.7% | 5.93 ± 2.1% | not timed | not timed | 12.73 ± 5.1% | | 1.01 | 5.42 | 2.16 |
| 07-unicode-character-data/compile | 1 | 50.37 ± 0.8% | not timed | not timed | 24.23 ± 0.7% | 32.79 ± 19.2% | not timed | not timed | 50.17 ± 10.6% | | 1.00 | 2.08 | 1.54 |
| 09-aws-keys/compile-full | 1 | 34.65 ± 0.4% | not timed | not timed | 7.36 ± 1.1% | 20.20 ± 23.6% | not timed | not timed | 34.32 ± 1.2% | | 1.01 | 4.71 | 1.72 |
| 09-aws-keys/compile-quick | 1 | 160.58 ± 2.9% | not timed | not timed | 44.69 ± 0.9% | 116.45 ± 3.1% | not timed | not timed | 159.71 ± 0.2% | | 1.01 | 3.59 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 10.57 ± 0.3% | not timed | not timed | 11.42 ± 1.6% | 14.99 ± 2.0% | not timed | not timed | 10.53 ± 0.7% | | 1.00 | 0.93 | 0.71 |
| 10-bounded-repeat/compile-capitals | 1 | 74.12 ± 1.3% | not timed | not timed | 8.89 ± 1.6% | 21.95 ± 3.9% | not timed | not timed | 72.66 ± 2.4% | | 1.02 | 8.34 | 3.38 |
| 11-unstructured-to-json/compile | 1 | 76.85 ± 0.6% | not timed | not timed | 36.43 ± 0.6% | 60.22 ± 3.7% | not timed | not timed | 76.27 ± 1.7% | | 1.01 | 2.11 | 1.28 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.9% | not timed | not timed | 0.07 ± 38.3% | 0.09 ± 11.8% | not timed | not timed | 0.29 ± 2.1% | | 1.00 | 4.32 | 3.26 |

