# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243505717 |
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
| literal: a word | 217 | 19485.45 ± 1.8% | 4990.97 ± 0.3% | 28.30 ± 0.5% | 18168.73 ± 2.3% | 9137.56 ± 10.1% | 17.47 ± 0.4% | 84.30 ± 0.3% | 19361.65 ± 1.2% | 3.90 | 1.01 | 1.07 | 2.13 |
| literal: a word that is not there | 0 | 21320.39 ± 2.2% | 4871.29 ± 0.3% | 28.38 ± 0.2% | 19738.59 ± 0.5% | 28829.83 ± 0.4% | 17.29 ± 0.4% | 79.71 ± 2.0% | 21460.25 ± 1.8% | 4.38 | 0.99 | 1.08 | 0.74 |
| literal: one of four words | 661 | 6380.62 ± 0.5% | 1927.49 ± 0.4% | 14.36 ± 0.3% | 3945.70 ± 0.6% | 21.90 ± 0.2% | 5.27 ± 0.1% | 6.86 ± 0.5% | 6359.43 ± 0.1% | 3.31 | 1.00 | 1.62 | 291.34 |
| literal: a word in any case | 217 | 15189.22 ± 1.5% | 2073.07 ± 0.2% | 21.42 ± 0.7% | 3972.68 ± 0.3% | 38.11 ± 3.1% | refused | differs | 15118.12 ± 1.1% | 7.33 | 1.00 | 3.82 | 398.53 |
| literal: an href attribute | 33 | 16776.18 ± 2.8% | 610.45 ± 0.1% | 27.02 ± 0.3% | 17001.40 ± 1.5% | 2254.93 ± 0.4% | 13.28 ± 0.2% | 73.94 ± 1.1% | 16710.57 ± 2.1% | 27.48 | 1.00 | 0.99 | 7.44 |
| literal: a word, second text | 123 | 19562.30 ± 2.7% | 3349.23 ± 0.3% | 27.96 ± 0.2% | 18245.73 ± 1.2% | 7729.99 ± 5.3% | 19.61 ± 0.5% | 70.45 ± 0.5% | 19705.63 ± 2.8% | 5.84 | 0.99 | 1.07 | 2.53 |
| class: two capitalized words | 1331 | 1055.78 ± 0.3% | 599.48 ± 0.1% | 25.87 ± 0.2% | 585.66 ± 0.1% | 40.62 ± 3.0% | 14.89 ± 0.4% | 67.35 ± 0.7% | 1056.13 ± 0.4% | 1.76 | 1.00 | 1.80 | 25.99 |
| class: a word that ends in ing | 3399 | 572.89 ± 0.3% | 572.78 ± 0.3% | 17.83 ± 0.4% | 547.39 ± 0.1% | 29.54 ± 3.1% | 8.19 ± 0.2% | 18.19 ± 0.2% | 572.22 ± 0.1% | 1.00 | 1.00 | 1.05 | 19.39 |
| class: a word in capitals | 2332 | 1368.93 ± 0.3% | 603.36 ± 0.4% | 27.55 ± 0.3% | 572.45 ± 0.1% | 43.51 ± 7.6% | 17.24 ± 0.6% | 82.37 ± 2.2% | 1371.36 ± 0.1% | 2.27 | 1.00 | 2.39 | 31.46 |
| class: a number | 8288 | 1957.92 ± 0.3% | 827.27 ± 0.2% | 27.87 ± 0.2% | 1714.63 ± 0.1% | 41.67 ± 16.3% | 0.55 ± 0.4% | 57.36 ± 0.9% | 1955.79 ± 0.2% | 2.37 | 1.00 | 1.14 | 46.99 |
| class: two capitalized words, second text | 5359 | 515.66 ± 0.4% | 523.40 ± 0.1% | 23.12 ± 0.1% | 485.45 ± 0.1% | 34.14 ± 9.4% | 16.66 ± 0.1% | 62.62 ± 2.6% | 514.95 ± 0.3% | 0.99 | 1.00 | 1.06 | 15.11 |
| other: a word between two words | 6104 | 795.44 ± 0.1% | 594.22 ± 0.1% | 23.35 ± 0.1% | 738.73 ± 0.3% | 108.74 ± 11.8% | 11.29 ± 0.1% | 68.16 ± 0.9% | 795.52 ± 0.1% | 1.34 | 1.00 | 1.08 | 7.32 |
| other: a number before a unit, second text | 1481 | 5957.00 ± 1.4% | 1119.38 ± 0.4% | 26.00 ± 0.1% | 5652.44 ± 0.4% | 40.76 ± 8.9% | 17.83 ± 0.1% | 65.62 ± 0.9% | 5912.07 ± 0.8% | 5.32 | 1.01 | 1.05 | 146.14 |
| other: a heading's start tag | 110 | 13983.08 ± 0.8% | 742.49 ± 0.1% | 27.43 ± 0.3% | 1711.95 ± 0.3% | 1584.64 ± 5.7% | 16.21 ± 0.3% | 86.16 ± 0.2% | 13975.16 ± 0.4% | 18.83 | 1.00 | 8.17 | 8.82 |
| other: a whole word | 217 | 15929.51 ± 0.5% | 601.05 ± 0.2% | 29.03 ± 0.1% | 14503.15 ± 0.9% | 49.37 ± 0.2% | 13.63 ± 0.1% | 54.95 ± 1.0% | 15846.63 ± 0.9% | 26.50 | 1.01 | 1.10 | 322.67 |
| other: a line's first word, second text | 3716 | 2036.64 ± 0.4% | 586.94 ± 0.2% | 30.62 ± 0.2% | 1713.16 ± 0.8% | 61.57 ± 8.0% | refused | refused | 2029.19 ± 0.7% | 3.47 | 1.00 | 1.19 | 33.08 |
| other: fourteen octets before an x | 87 | 23836.19 ± 2.9% | 251.11 ± 0.3% | 6.53 ± 0.0% | 4050.49 ± 0.4% | 10.65 ± 0.2% | differs | 17.70 ± 0.2% | 23811.42 ± 1.1% | 94.93 | 1.00 | 5.88 | 2237.69 |
| other: a Greek word | 21815 | 488.66 ± 0.8% | 409.17 ± 0.2% | 30.80 ± 0.2% | 289.95 ± 0.5% | 44.73 ± 8.8% | differs | refused | 476.21 ± 0.5% | 1.19 | 1.03 | 1.69 | 10.92 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.42 ± 0.2% | 18.49 ± 0.3% | 0.86 ± 0.4% | 19.80 ± 0.5% | 2.76 ± 0.7% | differs | 3.98 ± 0.2% | 18.49 ± 0.2% | 1.00 | 1.00 | 0.93 | 6.67 |
| a UUID | 32895 | 20.14 ± 0.2% | 20.10 ± 0.2% | 0.64 ± 0.2% | 15.12 ± 0.5% | 3.09 ± 0.8% | 0.72 ± 0.5% | 3.61 ± 0.6% | 20.11 ± 0.1% | 1.00 | 1.00 | 1.33 | 6.52 |
| an IPv4 address | 33176 | 33.70 ± 0.2% | 33.64 ± 0.3% | 2.07 ± 0.4% | 29.31 ± 0.5% | 6.63 ± 0.3% | differs | 4.14 ± 0.2% | 33.68 ± 0.3% | 1.00 | 1.00 | 1.15 | 5.09 |
| a date and time | 32954 | 28.85 ± 0.3% | 28.80 ± 0.3% | 1.44 ± 0.4% | 21.47 ± 0.6% | 7.04 ± 0.1% | 1.19 ± 0.2% | 7.13 ± 0.6% | 28.76 ± 0.2% | 1.00 | 1.00 | 1.34 | 4.09 |
| a field path | 32606 | 21.76 ± 0.2% | 21.72 ± 0.2% | 1.02 ± 0.5% | 23.09 ± 0.3% | 3.48 ± 1.5% | differs | 2.92 ± 0.2% | 21.69 ± 0.2% | 1.00 | 1.00 | 0.94 | 6.25 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.13 ± 0.3% | 11.10 ± 0.2% | 11.12 ± 0.4% | 11.37 ± 0.5% | 4.92 ± 1.3% | 0.91 ± 0.6% | none | 11.10 ± 0.2% | 1.00 | 1.00 | 0.98 | 2.26 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 231.46 ± 0.8% | 230.71 ± 1.3% | 274.47 ± 0.8% | 86.65 ± 0.5% | 218.99 ± 2.3% | 484.36 ± 0.5% | 3813.47 ± 0.5% | 231.43 ± 0.4% | 1.00 | 1.00 | 2.67 | 1.06 |
| a UUID | 62 | 147.10 ± 0.6% | 147.49 ± 0.9% | 166.97 ± 0.4% | 45.93 ± 1.0% | 98.86 ± 1.7% | 185.22 ± 2.3% | 4279.77 ± 0.4% | 147.65 ± 1.6% | 1.00 | 1.00 | 3.20 | 1.49 |
| an IPv4 address | 29 | 417.65 ± 0.4% | 421.41 ± 0.3% | 595.20 ± 0.6% | 78.83 ± 0.1% | 131.35 ± 0.8% | 294.54 ± 0.6% | 7603.86 ± 0.3% | 417.68 ± 0.3% | 0.99 | 1.00 | 5.30 | 3.18 |
| a date and time | 56 | 297.61 ± 0.8% | 298.95 ± 0.3% | 375.10 ± 0.2% | 73.76 ± 0.8% | 136.83 ± 2.0% | 328.41 ± 0.8% | 4935.64 ± 0.8% | 297.65 ± 0.4% | 1.00 | 1.00 | 4.03 | 2.18 |
| a field path | 39 | 224.07 ± 1.7% | 226.18 ± 0.7% | 267.32 ± 0.2% | 80.58 ± 0.9% | 206.50 ± 1.3% | 519.77 ± 3.5% | 4863.28 ± 0.4% | 223.70 ± 0.9% | 0.99 | 1.00 | 2.78 | 1.09 |
| literal: a word | 7 | 621.87 ± 0.3% | 673.12 ± 0.3% | 1205.52 ± 0.1% | 497.19 ± 0.0% | 628.70 ± 6.0% | 958.04 ± 0.4% | 30432.25 ± 0.1% | 621.41 ± 0.3% | 0.92 | 1.00 | 1.25 | 0.99 |
| literal: a word that is not there | 8 | 598.83 ± 0.2% | 650.37 ± 0.3% | 1142.90 ± 0.5% | 458.17 ± 0.2% | 602.91 ± 1.3% | 901.80 ± 0.3% | 29180.45 ± 0.1% | 598.50 ± 0.2% | 0.92 | 1.00 | 1.31 | 0.99 |
| literal: one of four words | 26 | 239.99 ± 0.3% | 396.85 ± 0.6% | 543.21 ± 0.4% | 50.58 ± 0.6% | 240.23 ± 1.2% | 377.33 ± 0.3% | 15906.51 ± 0.1% | 240.18 ± 0.1% | 0.60 | 1.00 | 4.74 | 1.00 |
| literal: a word in any case | 11 | 442.50 ± 0.2% | 473.91 ± 0.2% | 694.97 ± 0.1% | 15.61 ± 0.3% | 646.15 ± 2.3% | refused | 23735.89 ± 0.4% | 441.51 ± 0.4% | 0.93 | 1.00 | 28.35 | 0.68 |
| literal: an href attribute | 12 | 339.84 ± 0.5% | 352.16 ± 0.6% | 465.53 ± 0.9% | 45.27 ± 0.4% | 502.14 ± 2.6% | 782.10 ± 0.4% | 21462.69 ± 0.0% | 339.88 ± 0.2% | 0.97 | 1.00 | 7.51 | 0.68 |
| literal: a word, second text | 10 | 558.20 ± 0.2% | 616.56 ± 0.3% | 1038.57 ± 0.1% | 401.66 ± 0.2% | 535.73 ± 1.4% | 812.69 ± 0.5% | 27096.76 ± 0.2% | 557.53 ± 0.3% | 0.91 | 1.00 | 1.39 | 1.04 |
| class: two capitalized words | 23 | 432.71 ± 0.5% | 461.17 ± 0.3% | 673.81 ± 0.2% | 100.30 ± 0.1% | 498.35 ± 2.1% | 746.17 ± 0.6% | 6434.63 ± 0.4% | 432.64 ± 0.2% | 0.94 | 1.00 | 4.31 | 0.87 |
| class: a word that ends in ing | 9 | 558.16 ± 0.3% | 623.70 ± 0.8% | 1098.63 ± 0.3% | 133.32 ± 0.8% | 742.20 ± 3.5% | 1091.40 ± 0.6% | 15866.85 ± 0.2% | 558.18 ± 0.2% | 0.89 | 1.00 | 4.19 | 0.75 |
| class: a word in capitals | 16 | 495.38 ± 0.5% | 536.39 ± 0.5% | 869.52 ± 0.2% | 136.80 ± 0.4% | 743.89 ± 1.5% | 1013.18 ± 0.7% | 8540.37 ± 0.2% | 493.75 ± 1.1% | 0.92 | 1.00 | 3.62 | 0.67 |
| class: a number | 6 | 625.27 ± 0.3% | 688.70 ± 0.3% | 1317.83 ± 0.1% | 41.94 ± 1.4% | 1379.72 ± 1.9% | 1861.10 ± 1.2% | 22698.71 ± 0.2% | 624.87 ± 0.5% | 0.91 | 1.00 | 14.91 | 0.45 |
| class: two capitalized words, second text | 23 | 432.24 ± 0.2% | 461.10 ± 0.3% | 673.85 ± 0.6% | 102.95 ± 0.1% | 501.36 ± 2.7% | 763.88 ± 0.6% | 6448.30 ± 0.2% | 433.27 ± 0.3% | 0.94 | 1.00 | 4.20 | 0.86 |
| other: a word between two words | 13 | 534.68 ± 0.5% | 554.02 ± 0.6% | 894.31 ± 0.5% | 134.40 ± 0.8% | 498.23 ± 3.8% | 820.27 ± 0.5% | 14771.63 ± 0.5% | 534.95 ± 0.2% | 0.97 | 1.00 | 3.98 | 1.07 |
| other: a number before a unit, second text | 15 | 396.95 ± 0.6% | 434.37 ± 0.3% | 612.35 ± 1.0% | 39.48 ± 0.5% | 639.88 ± 0.7% | 895.44 ± 0.9% | 15095.25 ± 0.1% | 397.03 ± 0.9% | 0.91 | 1.00 | 10.05 | 0.62 |
| other: a heading's start tag | 13 | 350.23 ± 0.3% | 357.35 ± 0.8% | 474.05 ± 0.7% | 44.26 ± 0.5% | 629.26 ± 0.9% | 862.67 ± 1.6% | 17908.88 ± 0.2% | 350.17 ± 0.6% | 0.98 | 1.00 | 7.91 | 0.56 |
| other: a whole word | 11 | 574.85 ± 0.3% | 613.67 ± 0.9% | 1031.61 ± 0.1% | 119.06 ± 0.6% | 565.48 ± 2.8% | 810.89 ± 0.3% | 26909.00 ± 0.1% | 574.66 ± 0.4% | 0.94 | 1.00 | 4.83 | 1.02 |
| other: a line's first word, second text | 17 | 531.73 ± 0.3% | 555.43 ± 0.4% | 893.01 ± 0.2% | 129.82 ± 0.1% | 708.58 ± 1.0% | refused | refused | 528.93 ± 0.7% | 0.96 | 1.01 | 4.10 | 0.75 |
| other: fourteen octets before an x | 16 | 107.32 ± 0.5% | 153.55 ± 0.6% | 175.58 ± 0.9% | 15.25 ± 0.2% | 451.31 ± 1.9% | 410.27 ± 0.8% | 12762.79 ± 0.2% | 107.29 ± 0.3% | 0.70 | 1.00 | 7.04 | 0.24 |
| other: a Greek word | 8 | 429.48 ± 0.4% | 591.77 ± 0.4% | 1017.82 ± 0.7% | 59.20 ± 0.6% | 1375.31 ± 1.7% | 1830.86 ± 0.6% | refused | 429.60 ± 0.1% | 0.73 | 1.00 | 7.25 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15643.69 ± 0.7% | not timed | not timed | 16344.75 ± 1.1% | 1960.54 ± 12.6% | not timed | not timed | 15659.81 ± 0.7% | | 1.00 | 0.96 | 7.98 |
| 01-literal/sherlock-casei-en | 522 | 5174.74 ± 1.3% | not timed | not timed | 3592.09 ± 0.1% | 32.36 ± 4.6% | not timed | not timed | 5158.70 ± 0.7% | | 1.00 | 1.44 | 159.91 |
| 01-literal/sherlock-ru | 724 | 17131.13 ± 0.8% | not timed | not timed | 17324.22 ± 0.2% | 1447.78 ± 10.9% | not timed | not timed | 17085.18 ± 0.2% | | 1.00 | 0.99 | 11.83 |
| 01-literal/sherlock-casei-ru | 746 | 6175.45 ± 0.2% | not timed | not timed | 3320.69 ± 0.1% | 30.93 ± 0.3% | not timed | not timed | 6176.04 ± 0.1% | | 1.00 | 1.86 | 199.69 |
| 01-literal/sherlock-zh | 30 | 19779.18 ± 0.7% | not timed | not timed | 18698.16 ± 0.8% | 2569.46 ± 11.4% | not timed | not timed | 19726.76 ± 0.5% | | 1.00 | 1.06 | 7.70 |
| 02-literal-alternate/sherlock-en | 714 | 6061.77 ± 0.3% | not timed | not timed | 3942.33 ± 0.3% | 16.29 ± 0.3% | not timed | not timed | 6055.02 ± 0.4% | | 1.00 | 1.54 | 372.14 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1940.75 ± 1.5% | not timed | not timed | 695.56 ± 0.2% | 10.96 ± 0.3% | not timed | not timed | 1928.98 ± 0.8% | | 1.01 | 2.79 | 177.08 |
| 02-literal-alternate/sherlock-ru | 899 | 5567.68 ± 0.1% | not timed | not timed | 3252.20 ± 0.2% | 21.86 ± 0.4% | not timed | not timed | 5558.94 ± 0.1% | | 1.00 | 1.71 | 254.75 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2059.84 ± 0.3% | not timed | not timed | 1231.18 ± 0.1% | 9.01 ± 0.2% | not timed | not timed | 2053.07 ± 0.1% | | 1.00 | 1.67 | 228.53 |
| 02-literal-alternate/sherlock-zh | 207 | 7298.39 ± 0.3% | not timed | not timed | 4161.60 ± 0.2% | 30.96 ± 0.4% | not timed | not timed | 7294.64 ± 0.1% | | 1.00 | 1.75 | 235.75 |
| 03-date/ascii | 111817 | 124.17 ± 0.8% | not timed | not timed | 96.53 ± 0.1% | 0.20 ± 2.1% | not timed | not timed | 123.27 ± 0.9% | | 1.01 | 1.29 | 618.30 |
| 04-ruff-noqa/real | 84 | 403.00 ± 0.1% | not timed | not timed | 458.10 ± 0.3% | 19.57 ± 1.1% | not timed | not timed | 403.32 ± 0.0% | | 1.00 | 0.88 | 20.60 |
| 04-ruff-noqa/tweaked | 44 | 561.11 ± 0.1% | not timed | not timed | 461.87 ± 0.1% | 367.63 ± 0.4% | not timed | not timed | 561.47 ± 0.2% | | 1.00 | 1.21 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.23 ± 0.3% | not timed | not timed | 4.96 ± 0.4% | 0.21 ± 4.9% | not timed | not timed | 5.02 ± 4.0% | | 1.04 | 1.05 | 25.34 |
| 06-cloud-flare-redos/original | 107 | 415.78 ± 0.1% | not timed | not timed | 216.53 ± 0.1% | 24.80 ± 4.1% | not timed | not timed | 415.58 ± 2.8% | | 1.00 | 1.92 | 16.76 |
| 06-cloud-flare-redos/simplified-short | 102 | 411.81 ± 0.6% | not timed | not timed | 226.57 ± 0.0% | 26.26 ± 3.0% | not timed | not timed | 410.74 ± 9.2% | | 1.00 | 1.82 | 15.68 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.84 ± 0.2% | not timed | not timed | 255.69 ± 0.1% | 28.85 ± 0.4% | not timed | not timed | 583.30 ± 0.1% | | 1.00 | 2.28 | 20.24 |
| 07-unicode-character-data/parse-line | 558784 | 235.58 ± 0.2% | not timed | not timed | 172.22 ± 0.1% | 42.75 ± 1.2% | not timed | not timed | 236.73 ± 0.8% | | 1.00 | 1.37 | 5.51 |
| 08-words/all-english | 56691 | 116.79 ± 0.5% | not timed | not timed | 83.01 ± 0.1% | 11.81 ± 4.8% | not timed | not timed | 116.46 ± 0.4% | | 1.00 | 1.41 | 9.89 |
| 08-words/long-english | 839 | 614.31 ± 0.4% | not timed | not timed | 597.63 ± 0.1% | 32.48 ± 0.9% | not timed | not timed | 615.45 ± 0.7% | | 1.00 | 1.03 | 18.91 |
| 09-aws-keys/full | 0 | 409.25 ± 0.0% | not timed | not timed | 466.35 ± 0.1% | 64.56 ± 0.2% | not timed | not timed | 409.77 ± 0.0% | | 1.00 | 0.88 | 6.34 |
| 09-aws-keys/quick | 0 | 946.24 ± 0.1% | not timed | not timed | 993.67 ± 0.3% | 420.15 ± 1.3% | not timed | not timed | 946.26 ± 0.2% | | 1.00 | 0.95 | 2.25 |
| 10-bounded-repeat/letters-en | 1833 | 584.91 ± 1.8% | not timed | not timed | 516.81 ± 0.5% | 19.57 ± 0.7% | not timed | not timed | 584.06 ± 1.7% | | 1.00 | 1.13 | 29.88 |
| 10-bounded-repeat/letters-ru | 3475 | 512.76 ± 1.8% | not timed | not timed | 478.40 ± 0.1% | 22.13 ± 16.8% | not timed | not timed | 509.18 ± 0.7% | | 1.01 | 1.07 | 23.18 |
| 10-bounded-repeat/context | 53 | 77.36 ± 0.4% | not timed | not timed | 65.74 ± 0.6% | 19.80 ± 0.1% | not timed | not timed | 76.88 ± 0.7% | | 1.01 | 1.18 | 3.91 |
| 10-bounded-repeat/capitals | 11 | 635.28 ± 8.3% | not timed | not timed | 615.81 ± 0.1% | 36.51 ± 0.1% | not timed | not timed | 635.23 ± 8.4% | | 1.00 | 1.03 | 17.40 |
| 11-unstructured-to-json/extract | 600 | 82.87 ± 0.2% | not timed | not timed | 77.65 ± 0.1% | 49.11 ± 1.3% | not timed | not timed | 82.45 ± 0.5% | | 1.01 | 1.07 | 1.69 |
| 12-dictionary/single | 1 | 559.95 ± 0.5% | not timed | not timed | 560.86 ± 0.1% | 0.40 ± 0.3% | not timed | not timed | 559.84 ± 0.2% | | 1.00 | 1.00 | 1391.61 |
| 14-quadratic/1x | 100 | 21.36 ± 2.0% | not timed | not timed | 9.98 ± 0.4% | 0.97 ± 4.0% | not timed | not timed | 21.34 ± 1.4% | | 1.00 | 2.14 | 21.91 |
| 14-quadratic/2x | 200 | 17.56 ± 0.6% | not timed | not timed | 5.54 ± 0.2% | 0.53 ± 2.0% | not timed | not timed | 17.54 ± 0.2% | | 1.00 | 3.17 | 32.99 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.3% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 1.7% | not timed | not timed | 7.68 ± 0.3% | | 1.00 | 6.34 | 66.54 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 0.2% | not timed | not timed | 0.34 ± 0.7% | 0.53 ± 9.6% | not timed | not timed | 1.25 ± 3.0% | | 1.01 | 3.68 | 2.37 |
| 04-ruff-noqa/compile-real | 1 | 91.61 ± 0.1% | not timed | not timed | 13.81 ± 0.3% | 133.11 ± 1.6% | not timed | not timed | 91.42 ± 0.4% | | 1.00 | 6.63 | 0.69 |
| 05-lexer-veryl/compile-single | 1 | 13.79 ± 0.1% | not timed | not timed | 2.51 ± 0.4% | 6.33 ± 2.4% | not timed | not timed | 13.67 ± 1.8% | | 1.01 | 5.49 | 2.18 |
| 07-unicode-character-data/compile | 1 | 54.91 ± 0.2% | not timed | not timed | 26.02 ± 0.3% | 35.56 ± 2.7% | not timed | not timed | 54.02 ± 1.0% | | 1.02 | 2.11 | 1.54 |
| 09-aws-keys/compile-full | 1 | 41.64 ± 0.3% | not timed | not timed | 8.28 ± 0.1% | 22.75 ± 3.5% | not timed | not timed | 41.06 ± 0.8% | | 1.01 | 5.03 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 181.96 ± 0.2% | not timed | not timed | 47.80 ± 0.8% | 129.62 ± 2.3% | not timed | not timed | 180.57 ± 1.0% | | 1.01 | 3.81 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 13.57 ± 0.6% | not timed | not timed | 11.23 ± 0.2% | 15.76 ± 3.8% | not timed | not timed | 13.52 ± 1.7% | | 1.00 | 1.21 | 0.86 |
| 10-bounded-repeat/compile-capitals | 1 | 81.14 ± 0.6% | not timed | not timed | 8.13 ± 0.2% | 23.52 ± 1.8% | not timed | not timed | 81.24 ± 2.2% | | 1.00 | 9.98 | 3.45 |
| 11-unstructured-to-json/compile | 1 | 85.67 ± 0.6% | not timed | not timed | 40.68 ± 1.2% | 66.44 ± 4.6% | not timed | not timed | 84.96 ± 0.8% | | 1.01 | 2.11 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.5% | not timed | not timed | 0.07 ± 0.9% | 0.10 ± 6.0% | not timed | not timed | 0.35 ± 2.2% | | 1.01 | 5.17 | 3.66 |

