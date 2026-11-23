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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215413015 |
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
| literal: a word | 217 | 15981.07 ± 1.5% | 4997.15 ± 0.2% | 27.95 ± 0.1% | 17857.24 ± 3.2% | 9049.33 ± 7.5% | 17.41 ± 0.3% | 83.75 ± 0.6% | 15966.09 ± 1.1% | 3.20 | 1.00 | 0.89 | 1.77 |
| literal: a word that is not there | 0 | 18231.22 ± 1.7% | 4873.37 ± 0.3% | 28.05 ± 0.2% | 19131.82 ± 1.3% | 28064.11 ± 4.4% | 17.14 ± 0.2% | 79.35 ± 1.8% | 18479.97 ± 2.1% | 3.74 | 0.99 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6083.81 ± 0.2% | 1933.37 ± 0.2% | 14.27 ± 0.1% | 3941.52 ± 0.3% | 21.93 ± 0.0% | 5.40 ± 0.1% | 6.90 ± 0.2% | 6070.76 ± 0.3% | 3.15 | 1.00 | 1.54 | 277.38 |
| literal: a word in any case | 217 | 12571.10 ± 0.4% | 2074.56 ± 0.1% | 21.03 ± 0.2% | 3970.49 ± 0.4% | 36.81 ± 1.1% | refused | differs | 12585.77 ± 0.2% | 6.06 | 1.00 | 3.17 | 341.52 |
| literal: an href attribute | 33 | 13807.72 ± 0.8% | 615.83 ± 0.2% | 27.01 ± 0.3% | 17098.44 ± 0.6% | 2261.99 ± 0.3% | 13.06 ± 0.4% | 73.74 ± 1.4% | 13802.54 ± 0.6% | 22.42 | 1.00 | 0.81 | 6.10 |
| literal: a word, second text | 123 | 16279.73 ± 2.5% | 3351.33 ± 0.3% | 27.75 ± 0.3% | 17621.42 ± 1.5% | 7683.65 ± 8.6% | 20.17 ± 0.2% | 70.25 ± 0.3% | 16252.41 ± 2.9% | 4.86 | 1.00 | 0.92 | 2.12 |
| class: two capitalized words | 1331 | 1065.58 ± 0.4% | 603.96 ± 0.1% | 25.79 ± 0.3% | 585.45 ± 0.1% | 40.49 ± 7.6% | 14.73 ± 0.2% | 67.38 ± 0.7% | 1063.48 ± 0.3% | 1.76 | 1.00 | 1.82 | 26.32 |
| class: a word that ends in ing | 3399 | 580.22 ± 0.1% | 578.64 ± 0.1% | 17.87 ± 0.2% | 548.15 ± 0.1% | 29.61 ± 2.9% | 8.14 ± 0.2% | 18.43 ± 0.4% | 579.64 ± 0.1% | 1.00 | 1.00 | 1.06 | 19.60 |
| class: a word in capitals | 2332 | 1373.50 ± 0.3% | 615.20 ± 0.1% | 27.32 ± 0.4% | 572.73 ± 0.1% | 43.20 ± 3.4% | 17.15 ± 0.4% | 82.63 ± 2.1% | 1370.64 ± 0.3% | 2.23 | 1.00 | 2.40 | 31.80 |
| class: a number | 8288 | 2007.43 ± 0.6% | 834.37 ± 0.2% | 27.49 ± 0.3% | 1726.01 ± 0.1% | 39.67 ± 14.6% | 0.53 ± 0.4% | 57.58 ± 1.2% | 2002.22 ± 0.4% | 2.41 | 1.00 | 1.16 | 50.60 |
| class: two capitalized words, second text | 5359 | 521.56 ± 0.2% | 528.20 ± 0.1% | 23.07 ± 0.1% | 484.98 ± 0.1% | 34.46 ± 13.5% | 17.11 ± 0.2% | 62.68 ± 1.5% | 521.05 ± 0.1% | 0.99 | 1.00 | 1.08 | 15.14 |
| other: a word between two words | 6104 | 741.31 ± 0.1% | 598.33 ± 0.1% | 23.31 ± 0.2% | 735.25 ± 0.1% | 109.50 ± 13.2% | 11.16 ± 0.1% | 68.18 ± 0.6% | 740.69 ± 0.2% | 1.24 | 1.00 | 1.01 | 6.77 |
| other: a number before a unit, second text | 1481 | 5317.30 ± 0.5% | 1107.95 ± 0.1% | 25.86 ± 0.3% | 5663.65 ± 0.7% | 40.71 ± 9.5% | 18.21 ± 0.2% | 65.75 ± 0.6% | 5320.68 ± 0.6% | 4.80 | 1.00 | 0.94 | 130.61 |
| other: a heading's start tag | 110 | 12602.51 ± 0.9% | 750.69 ± 0.0% | 27.09 ± 0.2% | 1713.44 ± 0.6% | 1577.36 ± 5.4% | 16.09 ± 0.3% | 86.12 ± 0.6% | 12628.58 ± 0.4% | 16.79 | 1.00 | 7.36 | 7.99 |
| other: a whole word | 217 | 13966.43 ± 0.8% | 608.06 ± 0.4% | 29.12 ± 0.2% | 14371.53 ± 2.6% | 47.67 ± 0.1% | 13.35 ± 0.1% | 54.98 ± 0.2% | 13979.36 ± 0.4% | 22.97 | 1.00 | 0.97 | 292.97 |
| other: a line's first word, second text | 3716 | 1947.93 ± 0.5% | 594.28 ± 0.2% | 30.96 ± 0.1% | 1723.04 ± 0.6% | 61.55 ± 7.0% | refused | refused | 1944.23 ± 0.3% | 3.28 | 1.00 | 1.13 | 31.65 |
| other: fourteen octets before an x | 87 | 19818.72 ± 0.9% | 248.33 ± 0.3% | 6.30 ± 0.1% | 4015.66 ± 0.2% | 10.62 ± 0.1% | differs | 17.77 ± 0.1% | 19763.37 ± 0.8% | 79.81 | 1.00 | 4.94 | 1867.04 |
| other: a Greek word | 21815 | 503.20 ± 0.8% | 412.94 ± 0.2% | 30.72 ± 0.2% | 289.74 ± 0.2% | 44.00 ± 9.1% | differs | refused | 499.28 ± 0.5% | 1.22 | 1.01 | 1.74 | 11.44 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.90 ± 0.1% | 19.91 ± 0.1% | 0.84 ± 0.3% | 19.90 ± 0.5% | 2.76 ± 1.3% | differs | 4.07 ± 0.1% | 19.92 ± 0.1% | 1.00 | 1.00 | 1.00 | 7.20 |
| a UUID | 32895 | 21.33 ± 0.2% | 21.40 ± 0.1% | 0.64 ± 0.0% | 15.14 ± 0.5% | 3.08 ± 0.4% | 0.73 ± 0.4% | 3.65 ± 0.7% | 21.40 ± 0.1% | 1.00 | 1.00 | 1.41 | 6.93 |
| an IPv4 address | 33176 | 36.82 ± 0.1% | 36.86 ± 0.2% | 2.05 ± 0.0% | 29.56 ± 0.1% | 6.67 ± 0.2% | differs | 4.15 ± 0.2% | 36.84 ± 0.2% | 1.00 | 1.00 | 1.25 | 5.52 |
| a date and time | 32954 | 31.52 ± 0.4% | 31.42 ± 0.2% | 1.41 ± 1.4% | 21.56 ± 0.5% | 7.03 ± 0.1% | 1.25 ± 0.1% | 7.22 ± 0.2% | 31.39 ± 0.2% | 1.00 | 1.00 | 1.46 | 4.48 |
| a field path | 32606 | 23.51 ± 0.2% | 23.57 ± 0.2% | 1.00 ± 0.2% | 23.36 ± 0.3% | 3.52 ± 0.7% | differs | 2.97 ± 0.2% | 23.56 ± 0.1% | 1.00 | 1.00 | 1.01 | 6.67 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.05 ± 0.3% | 11.11 ± 0.4% | 11.07 ± 0.2% | 11.82 ± 0.0% | 4.92 ± 2.2% | 0.94 ± 0.2% | none | 11.12 ± 0.2% | 0.99 | 0.99 | 0.93 | 2.24 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 230.83 ± 0.4% | 231.83 ± 0.2% | 276.97 ± 0.3% | 86.63 ± 0.5% | 221.61 ± 0.4% | 483.30 ± 1.2% | 3797.37 ± 0.5% | 230.74 ± 0.7% | 1.00 | 1.00 | 2.66 | 1.04 |
| a UUID | 62 | 151.71 ± 0.4% | 152.07 ± 0.3% | 171.18 ± 0.1% | 46.43 ± 0.7% | 98.49 ± 1.4% | 190.47 ± 2.8% | 4231.90 ± 0.4% | 151.68 ± 0.1% | 1.00 | 1.00 | 3.27 | 1.54 |
| an IPv4 address | 29 | 416.79 ± 0.2% | 421.22 ± 0.5% | 603.11 ± 0.4% | 76.94 ± 0.2% | 131.17 ± 1.2% | 303.18 ± 1.3% | 7577.98 ± 0.4% | 416.90 ± 0.6% | 0.99 | 1.00 | 5.42 | 3.18 |
| a date and time | 56 | 300.81 ± 0.3% | 302.73 ± 0.6% | 384.09 ± 0.2% | 73.15 ± 0.3% | 136.83 ± 2.1% | 324.01 ± 1.2% | 4918.29 ± 0.6% | 300.79 ± 0.2% | 0.99 | 1.00 | 4.11 | 2.20 |
| a field path | 39 | 225.84 ± 0.6% | 226.82 ± 0.2% | 268.99 ± 0.6% | 81.14 ± 1.2% | 206.58 ± 2.4% | 500.53 ± 3.0% | 4863.04 ± 0.5% | 226.27 ± 0.3% | 1.00 | 1.00 | 2.78 | 1.09 |
| literal: a word | 7 | 626.90 ± 0.5% | 674.91 ± 0.4% | 1244.68 ± 0.9% | 526.28 ± 0.2% | 634.35 ± 1.6% | 959.15 ± 0.4% | 30928.86 ± 0.1% | 626.36 ± 1.1% | 0.93 | 1.00 | 1.19 | 0.99 |
| literal: a word that is not there | 8 | 607.21 ± 0.2% | 654.02 ± 0.5% | 1172.10 ± 0.2% | 483.54 ± 0.7% | 606.69 ± 2.0% | 908.50 ± 0.6% | 29446.88 ± 0.1% | 606.93 ± 0.3% | 0.93 | 1.00 | 1.26 | 1.00 |
| literal: one of four words | 26 | 239.13 ± 0.2% | 398.54 ± 0.2% | 550.25 ± 0.3% | 50.18 ± 1.2% | 245.13 ± 2.0% | 375.22 ± 1.2% | 16047.10 ± 0.2% | 239.16 ± 0.2% | 0.60 | 1.00 | 4.77 | 0.98 |
| literal: a word in any case | 11 | 444.88 ± 0.3% | 473.76 ± 0.5% | 704.89 ± 0.1% | 15.81 ± 1.9% | 657.94 ± 2.2% | refused | 23709.89 ± 0.4% | 444.78 ± 0.2% | 0.94 | 1.00 | 28.14 | 0.68 |
| literal: an href attribute | 12 | 343.08 ± 0.4% | 355.48 ± 0.4% | 474.98 ± 0.4% | 45.87 ± 0.6% | 503.31 ± 1.6% | 774.07 ± 0.5% | 21987.37 ± 0.7% | 343.33 ± 0.4% | 0.97 | 1.00 | 7.48 | 0.68 |
| literal: a word, second text | 10 | 559.76 ± 0.7% | 614.20 ± 0.4% | 1055.28 ± 0.4% | 400.76 ± 0.2% | 537.26 ± 1.8% | 802.37 ± 0.3% | 27307.54 ± 0.1% | 559.33 ± 0.3% | 0.91 | 1.00 | 1.40 | 1.04 |
| class: two capitalized words | 23 | 427.66 ± 0.3% | 462.20 ± 0.4% | 685.64 ± 0.7% | 100.27 ± 0.1% | 505.41 ± 1.5% | 743.87 ± 0.4% | 6480.73 ± 0.1% | 427.76 ± 0.3% | 0.93 | 1.00 | 4.27 | 0.85 |
| class: a word that ends in ing | 9 | 550.04 ± 0.3% | 625.77 ± 0.4% | 1132.67 ± 0.1% | 132.96 ± 2.0% | 767.50 ± 1.1% | 1105.36 ± 0.5% | 16026.01 ± 0.3% | 549.70 ± 0.2% | 0.88 | 1.00 | 4.14 | 0.72 |
| class: a word in capitals | 16 | 482.28 ± 0.5% | 526.23 ± 0.2% | 883.04 ± 0.2% | 135.61 ± 0.7% | 762.57 ± 0.6% | 1022.71 ± 0.9% | 8539.10 ± 0.5% | 481.70 ± 0.3% | 0.92 | 1.00 | 3.56 | 0.63 |
| class: a number | 6 | 606.72 ± 0.4% | 677.23 ± 0.3% | 1351.39 ± 0.1% | 41.72 ± 0.8% | 1423.88 ± 0.9% | 1857.98 ± 1.5% | 22783.11 ± 0.1% | 606.56 ± 0.1% | 0.90 | 1.00 | 14.54 | 0.43 |
| class: two capitalized words, second text | 23 | 428.23 ± 0.5% | 462.86 ± 0.3% | 686.55 ± 0.4% | 101.70 ± 0.4% | 506.66 ± 1.7% | 763.12 ± 0.6% | 6484.07 ± 0.3% | 428.19 ± 0.7% | 0.93 | 1.00 | 4.21 | 0.85 |
| other: a word between two words | 13 | 542.19 ± 0.3% | 559.14 ± 0.5% | 921.46 ± 0.8% | 133.17 ± 0.6% | 503.97 ± 0.8% | 814.99 ± 0.5% | 14864.60 ± 0.1% | 540.47 ± 0.4% | 0.97 | 1.00 | 4.07 | 1.08 |
| other: a number before a unit, second text | 15 | 395.36 ± 0.7% | 436.71 ± 0.3% | 625.24 ± 0.2% | 39.53 ± 0.4% | 642.78 ± 1.3% | 888.90 ± 1.1% | 15249.42 ± 0.5% | 394.75 ± 0.4% | 0.91 | 1.00 | 10.00 | 0.62 |
| other: a heading's start tag | 13 | 354.61 ± 0.4% | 360.12 ± 0.4% | 484.73 ± 0.4% | 43.99 ± 0.5% | 637.05 ± 0.5% | 876.06 ± 0.8% | 18210.72 ± 0.6% | 354.14 ± 0.4% | 0.98 | 1.00 | 8.06 | 0.56 |
| other: a whole word | 11 | 576.44 ± 0.5% | 608.66 ± 0.4% | 1038.05 ± 0.4% | 118.00 ± 0.6% | 567.26 ± 1.2% | 837.90 ± 0.4% | 27212.33 ± 0.3% | 574.71 ± 0.6% | 0.95 | 1.00 | 4.89 | 1.02 |
| other: a line's first word, second text | 17 | 523.68 ± 0.3% | 543.25 ± 0.4% | 893.37 ± 0.2% | 129.44 ± 0.1% | 716.20 ± 0.9% | refused | refused | 522.87 ± 0.6% | 0.96 | 1.00 | 4.05 | 0.73 |
| other: fourteen octets before an x | 16 | 107.72 ± 0.3% | 154.90 ± 0.5% | 180.55 ± 0.5% | 15.18 ± 0.5% | 458.10 ± 1.8% | 413.55 ± 0.5% | 12961.68 ± 0.1% | 107.81 ± 0.3% | 0.70 | 1.00 | 7.10 | 0.24 |
| other: a Greek word | 8 | 423.37 ± 0.1% | 586.89 ± 0.6% | 1046.16 ± 0.2% | 59.16 ± 0.5% | 1415.98 ± 1.2% | 1794.92 ± 0.2% | refused | 422.59 ± 0.3% | 0.72 | 1.00 | 7.16 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12732.94 ± 1.1% | not timed | not timed | 16031.41 ± 1.3% | 2131.08 ± 8.6% | not timed | not timed | 12747.13 ± 1.4% | | 1.00 | 0.79 | 5.97 |
| 01-literal/sherlock-casei-en | 522 | 4938.86 ± 1.2% | not timed | not timed | 3594.01 ± 0.5% | 32.13 ± 0.6% | not timed | not timed | 4936.55 ± 0.6% | | 1.00 | 1.37 | 153.72 |
| 01-literal/sherlock-ru | 724 | 13501.06 ± 0.5% | not timed | not timed | 17219.14 ± 1.0% | 1515.71 ± 4.6% | not timed | not timed | 13493.22 ± 0.8% | | 1.00 | 0.78 | 8.91 |
| 01-literal/sherlock-casei-ru | 746 | 5985.40 ± 0.1% | not timed | not timed | 3332.96 ± 0.1% | 31.52 ± 2.1% | not timed | not timed | 5980.86 ± 0.2% | | 1.00 | 1.80 | 189.88 |
| 01-literal/sherlock-zh | 30 | 16917.64 ± 1.0% | not timed | not timed | 18476.09 ± 1.2% | 2554.17 ± 17.6% | not timed | not timed | 16864.12 ± 0.4% | | 1.00 | 0.92 | 6.62 |
| 02-literal-alternate/sherlock-en | 714 | 5755.17 ± 0.5% | not timed | not timed | 3942.62 ± 0.2% | 16.57 ± 5.9% | not timed | not timed | 5761.50 ± 0.5% | | 1.00 | 1.46 | 347.28 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1805.86 ± 1.6% | not timed | not timed | 696.32 ± 0.2% | 10.94 ± 0.2% | not timed | not timed | 1796.53 ± 0.5% | | 1.01 | 2.59 | 165.02 |
| 02-literal-alternate/sherlock-ru | 899 | 5336.36 ± 0.3% | not timed | not timed | 3263.37 ± 0.1% | 22.58 ± 0.0% | not timed | not timed | 5339.76 ± 0.1% | | 1.00 | 1.64 | 236.30 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1920.90 ± 0.6% | not timed | not timed | 1232.98 ± 0.2% | 9.14 ± 0.2% | not timed | not timed | 1912.89 ± 0.2% | | 1.00 | 1.56 | 210.11 |
| 02-literal-alternate/sherlock-zh | 207 | 7037.02 ± 0.4% | not timed | not timed | 4164.22 ± 0.1% | 31.51 ± 0.2% | not timed | not timed | 7062.13 ± 0.6% | | 1.00 | 1.69 | 223.36 |
| 03-date/ascii | 111817 | 126.64 ± 0.5% | not timed | not timed | 96.16 ± 0.1% | 0.20 ± 9.0% | not timed | not timed | 125.98 ± 0.9% | | 1.01 | 1.32 | 623.73 |
| 04-ruff-noqa/real | 84 | 409.23 ± 0.1% | not timed | not timed | 478.60 ± 0.2% | 19.69 ± 1.4% | not timed | not timed | 407.87 ± 0.1% | | 1.00 | 0.86 | 20.79 |
| 04-ruff-noqa/tweaked | 44 | 550.12 ± 0.2% | not timed | not timed | 461.12 ± 0.2% | 365.32 ± 0.5% | not timed | not timed | 549.51 ± 0.3% | | 1.00 | 1.19 | 1.51 |
| 05-lexer-veryl/single | 124800 | 5.32 ± 0.1% | not timed | not timed | 5.19 ± 0.2% | 0.20 ± 1.7% | not timed | not timed | 5.37 ± 0.2% | | 0.99 | 1.02 | 26.00 |
| 06-cloud-flare-redos/original | 107 | 415.21 ± 0.2% | not timed | not timed | 216.92 ± 0.0% | 24.99 ± 0.2% | not timed | not timed | 415.08 ± 0.2% | | 1.00 | 1.91 | 16.61 |
| 06-cloud-flare-redos/simplified-short | 102 | 409.76 ± 0.2% | not timed | not timed | 228.41 ± 0.1% | 26.71 ± 0.3% | not timed | not timed | 409.97 ± 0.2% | | 1.00 | 1.79 | 15.34 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.44 ± 0.2% | not timed | not timed | 255.79 ± 0.1% | 28.81 ± 0.2% | not timed | not timed | 586.67 ± 0.1% | | 1.00 | 2.30 | 20.39 |
| 07-unicode-character-data/parse-line | 558784 | 223.52 ± 1.9% | not timed | not timed | 178.42 ± 0.1% | 43.06 ± 5.1% | not timed | not timed | 232.08 ± 1.9% | | 0.96 | 1.25 | 5.19 |
| 08-words/all-english | 56691 | 117.03 ± 0.9% | not timed | not timed | 82.56 ± 0.1% | 11.81 ± 5.4% | not timed | not timed | 116.50 ± 0.6% | | 1.00 | 1.42 | 9.91 |
| 08-words/long-english | 839 | 620.57 ± 0.5% | not timed | not timed | 597.38 ± 0.1% | 32.26 ± 0.4% | not timed | not timed | 620.52 ± 0.2% | | 1.00 | 1.04 | 19.24 |
| 09-aws-keys/full | 0 | 415.46 ± 0.1% | not timed | not timed | 495.61 ± 0.2% | 64.68 ± 0.3% | not timed | not timed | 414.74 ± 0.1% | | 1.00 | 0.84 | 6.42 |
| 09-aws-keys/quick | 0 | 731.84 ± 0.2% | not timed | not timed | 998.01 ± 0.6% | 422.51 ± 4.4% | not timed | not timed | 729.33 ± 0.3% | | 1.00 | 0.73 | 1.73 |
| 10-bounded-repeat/letters-en | 1833 | 583.09 ± 3.1% | not timed | not timed | 518.59 ± 0.4% | 19.57 ± 0.4% | not timed | not timed | 581.96 ± 2.5% | | 1.00 | 1.12 | 29.80 |
| 10-bounded-repeat/letters-ru | 3475 | 509.07 ± 1.5% | not timed | not timed | 479.05 ± 0.1% | 21.70 ± 16.5% | not timed | not timed | 506.17 ± 1.1% | | 1.01 | 1.06 | 23.46 |
| 10-bounded-repeat/context | 53 | 77.65 ± 0.7% | not timed | not timed | 65.77 ± 0.2% | 19.82 ± 0.2% | not timed | not timed | 77.49 ± 0.4% | | 1.00 | 1.18 | 3.92 |
| 10-bounded-repeat/capitals | 11 | 631.26 ± 8.3% | not timed | not timed | 618.61 ± 0.1% | 36.52 ± 1.2% | not timed | not timed | 630.57 ± 8.6% | | 1.00 | 1.02 | 17.29 |
| 11-unstructured-to-json/extract | 600 | 79.54 ± 0.1% | not timed | not timed | 76.86 ± 0.2% | 49.04 ± 0.7% | not timed | not timed | 81.24 ± 0.6% | | 0.98 | 1.03 | 1.62 |
| 12-dictionary/single | 1 | 561.49 ± 0.5% | not timed | not timed | 559.24 ± 0.2% | 0.40 ± 0.1% | not timed | not timed | 560.15 ± 0.5% | | 1.00 | 1.00 | 1387.71 |
| 14-quadratic/1x | 100 | 21.51 ± 0.5% | not timed | not timed | 10.00 ± 0.2% | 0.98 ± 4.5% | not timed | not timed | 21.40 ± 1.5% | | 1.01 | 2.15 | 21.97 |
| 14-quadratic/2x | 200 | 17.62 ± 0.6% | not timed | not timed | 5.53 ± 0.1% | 0.53 ± 2.1% | not timed | not timed | 17.60 ± 0.3% | | 1.00 | 3.19 | 33.06 |
| 14-quadratic/10x | 1000 | 7.71 ± 2.1% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 7.67 ± 1.9% | | 1.01 | 6.36 | 66.96 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.29 ± 0.4% | not timed | not timed | 0.34 ± 0.7% | 0.54 ± 5.5% | not timed | not timed | 1.29 ± 3.0% | | 1.00 | 3.77 | 2.38 |
| 04-ruff-noqa/compile-real | 1 | 91.36 ± 1.4% | not timed | not timed | 13.87 ± 0.4% | 140.62 ± 3.2% | not timed | not timed | 91.32 ± 1.1% | | 1.00 | 6.58 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 13.96 ± 1.3% | not timed | not timed | 2.53 ± 0.6% | 6.52 ± 2.4% | not timed | not timed | 13.84 ± 1.5% | | 1.01 | 5.53 | 2.14 |
| 07-unicode-character-data/compile | 1 | 55.53 ± 0.2% | not timed | not timed | 26.18 ± 0.2% | 36.38 ± 3.3% | not timed | not timed | 55.27 ± 0.2% | | 1.00 | 2.12 | 1.53 |
| 09-aws-keys/compile-full | 1 | 42.27 ± 0.3% | not timed | not timed | 8.31 ± 0.2% | 23.52 ± 1.0% | not timed | not timed | 42.01 ± 0.4% | | 1.01 | 5.09 | 1.80 |
| 09-aws-keys/compile-quick | 1 | 182.18 ± 0.2% | not timed | not timed | 47.43 ± 0.3% | 135.74 ± 3.9% | not timed | not timed | 181.37 ± 0.8% | | 1.00 | 3.84 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 13.89 ± 0.6% | not timed | not timed | 11.07 ± 0.2% | 16.20 ± 1.7% | not timed | not timed | 13.89 ± 0.2% | | 1.00 | 1.25 | 0.86 |
| 10-bounded-repeat/compile-capitals | 1 | 82.56 ± 0.2% | not timed | not timed | 8.00 ± 0.2% | 24.00 ± 1.3% | not timed | not timed | 82.55 ± 1.9% | | 1.00 | 10.32 | 3.44 |
| 11-unstructured-to-json/compile | 1 | 86.54 ± 0.2% | not timed | not timed | 40.99 ± 0.7% | 69.55 ± 2.0% | not timed | not timed | 86.14 ± 0.1% | | 1.00 | 2.11 | 1.24 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.7% | not timed | not timed | 0.07 ± 34.7% | 0.10 ± 9.1% | not timed | not timed | 0.34 ± 1.1% | | 1.01 | 4.95 | 3.61 |

