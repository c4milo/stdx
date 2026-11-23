# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127387921 |
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
| literal: a word | 217 | 24098.16 ± 1.9% | 867.49 ± 0.3% | 28.56 ± 1.1% | 24692.21 ± 0.9% | 9326.51 ± 5.2% | 12.15 ± 0.4% | 88.01 ± 2.5% | 24110.14 ± 0.4% | 27.78 | 1.00 | 0.98 | 2.58 |
| literal: a word that is not there | 0 | 30520.02 ± 0.2% | 876.61 ± 1.3% | 28.60 ± 8.4% | 27145.75 ± 1.4% | 30160.88 ± 0.9% | 11.83 ± 0.4% | 84.16 ± 3.1% | 30491.24 ± 0.8% | 34.82 | 1.00 | 1.12 | 1.01 |
| literal: one of four words | 661 | 10344.80 ± 1.2% | 850.66 ± 0.8% | 15.39 ± 2.6% | 7738.07 ± 1.3% | 23.31 ± 0.5% | 3.54 ± 0.2% | 7.65 ± 0.5% | 10208.93 ± 2.0% | 12.16 | 1.01 | 1.34 | 443.84 |
| literal: a word in any case | 217 | 21037.71 ± 2.7% | 868.11 ± 0.4% | 19.94 ± 0.9% | 7997.62 ± 0.6% | 43.45 ± 1.1% | refused | differs | 20976.04 ± 1.0% | 24.23 | 1.00 | 2.63 | 484.18 |
| literal: an href attribute | 33 | 21921.12 ± 1.8% | 873.86 ± 0.2% | 25.43 ± 0.8% | 22133.97 ± 1.6% | 2045.07 ± 0.8% | 8.66 ± 0.8% | 78.99 ± 3.6% | 21765.64 ± 0.8% | 25.09 | 1.01 | 0.99 | 10.72 |
| literal: a word, second text | 123 | 25164.30 ± 1.0% | 870.38 ± 0.3% | 27.80 ± 1.2% | 24618.31 ± 0.4% | 7147.21 ± 9.4% | 15.75 ± 2.9% | 75.65 ± 1.3% | 25186.35 ± 1.3% | 28.91 | 1.00 | 1.02 | 3.52 |
| class: two capitalized words | 1331 | 797.43 ± 0.2% | 807.08 ± 0.5% | 26.32 ± 2.0% | 488.05 ± 0.4% | 38.86 ± 7.3% | 10.35 ± 0.2% | 63.67 ± 0.3% | 798.27 ± 0.2% | 0.99 | 1.00 | 1.63 | 20.52 |
| class: a word that ends in ing | 3399 | 734.24 ± 1.2% | 731.60 ± 1.1% | 16.98 ± 1.0% | 459.98 ± 2.9% | 27.83 ± 12.6% | 5.78 ± 0.4% | 17.27 ± 1.1% | 732.63 ± 4.8% | 1.00 | 1.00 | 1.60 | 26.38 |
| class: a word in capitals | 2332 | 1074.16 ± 0.7% | 786.81 ± 0.2% | 28.20 ± 0.6% | 480.95 ± 0.6% | 42.25 ± 4.5% | 12.42 ± 0.4% | 81.05 ± 1.7% | 1072.58 ± 0.2% | 1.37 | 1.00 | 2.23 | 25.42 |
| class: a number | 8288 | 1580.35 ± 0.4% | 683.35 ± 0.5% | 27.52 ± 1.9% | 1677.91 ± 0.3% | 42.45 ± 9.3% | 0.34 ± 1.0% | 60.09 ± 1.2% | 1579.36 ± 0.4% | 2.31 | 1.00 | 0.94 | 37.23 |
| class: two capitalized words, second text | 5359 | 599.96 ± 1.1% | 597.51 ± 1.8% | 23.47 ± 0.5% | 404.89 ± 1.3% | 31.60 ± 5.7% | 13.48 ± 0.4% | 58.24 ± 0.6% | 599.13 ± 0.1% | 1.00 | 1.00 | 1.48 | 18.99 |
| other: a word between two words | 6104 | 623.25 ± 1.1% | 632.23 ± 0.3% | 23.22 ± 1.6% | 689.26 ± 1.0% | 104.49 ± 11.1% | 7.86 ± 0.3% | 68.00 ± 1.2% | 622.98 ± 0.9% | 0.99 | 1.00 | 0.90 | 5.96 |
| other: a number before a unit, second text | 1481 | 6925.82 ± 6.6% | 820.20 ± 0.8% | 25.94 ± 3.0% | 7278.02 ± 0.3% | 39.48 ± 4.1% | 14.16 ± 0.5% | 62.16 ± 2.7% | 6768.75 ± 3.0% | 8.44 | 1.02 | 0.95 | 175.44 |
| other: a heading's start tag | 110 | 16176.64 ± 1.5% | 862.08 ± 0.2% | 27.66 ± 1.3% | 2096.72 ± 2.6% | 1537.14 ± 4.4% | 10.76 ± 0.2% | 93.59 ± 1.3% | 16118.90 ± 0.1% | 18.76 | 1.00 | 7.72 | 10.52 |
| other: a whole word | 217 | 19099.00 ± 0.5% | 867.85 ± 0.7% | 28.79 ± 2.8% | 19876.38 ± 0.3% | 45.80 ± 2.9% | 10.24 ± 0.5% | 53.34 ± 1.2% | 19090.34 ± 2.7% | 22.01 | 1.00 | 0.96 | 417.03 |
| other: a line's first word, second text | 3716 | 1810.85 ± 0.7% | 723.16 ± 0.3% | 30.07 ± 0.6% | 1958.19 ± 2.8% | 63.68 ± 9.0% | refused | refused | 1794.98 ± 0.8% | 2.50 | 1.01 | 0.92 | 28.44 |
| other: fourteen octets before an x | 87 | 26843.49 ± 1.3% | 235.56 ± 0.9% | 5.88 ± 1.0% | 3345.96 ± 0.9% | 9.13 ± 0.7% | differs | 16.85 ± 0.8% | 26603.96 ± 3.4% | 113.95 | 1.01 | 8.02 | 2939.03 |
| other: a Greek word | 21815 | 411.59 ± 0.3% | 286.86 ± 0.7% | 29.81 ± 1.0% | 249.89 ± 0.5% | 47.67 ± 9.6% | differs | refused | 409.91 ± 0.5% | 1.43 | 1.00 | 1.65 | 8.63 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 23.45 ± 0.3% | 23.41 ± 0.3% | 0.84 ± 0.7% | 16.90 ± 0.3% | 2.52 ± 0.6% | differs | 3.92 ± 0.4% | 23.23 ± 0.5% | 1.00 | 1.01 | 1.39 | 9.31 |
| a UUID | 32895 | 20.92 ± 0.9% | 20.98 ± 0.2% | 0.60 ± 1.2% | 13.07 ± 0.1% | 2.53 ± 0.9% | 0.57 ± 0.2% | 3.27 ± 0.1% | 20.98 ± 0.3% | 1.00 | 1.00 | 1.60 | 8.26 |
| an IPv4 address | 33176 | 31.04 ± 0.3% | 31.04 ± 0.8% | 1.94 ± 0.5% | 24.88 ± 0.2% | 6.02 ± 1.2% | differs | 3.81 ± 0.5% | 30.96 ± 0.3% | 1.00 | 1.00 | 1.25 | 5.15 |
| a date and time | 32954 | 31.12 ± 1.8% | 31.15 ± 0.7% | 1.36 ± 1.3% | 18.89 ± 0.8% | 7.85 ± 1.0% | 1.05 ± 0.9% | 7.35 ± 0.7% | 31.30 ± 0.8% | 1.00 | 0.99 | 1.65 | 3.96 |
| a field path | 32606 | 25.35 ± 0.2% | 25.36 ± 0.4% | 0.96 ± 1.1% | 19.41 ± 0.3% | 2.82 ± 1.0% | differs | 2.46 ± 0.7% | 25.32 ± 1.6% | 1.00 | 1.00 | 1.31 | 8.99 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.77 ± 0.6% | 9.78 ± 0.6% | 9.80 ± 0.9% | 11.92 ± 0.7% | 5.16 ± 1.5% | 0.83 ± 0.5% | none | 9.77 ± 1.3% | 1.00 | 1.00 | 0.82 | 1.89 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 238.87 ± 1.2% | 239.14 ± 0.4% | 279.75 ± 0.9% | 87.00 ± 5.0% | 199.45 ± 7.0% | 553.18 ± 2.2% | 3303.31 ± 0.6% | 239.36 ± 0.5% | 1.00 | 1.00 | 2.75 | 1.20 |
| a UUID | 62 | 157.01 ± 0.5% | 157.92 ± 0.3% | 174.77 ± 0.4% | 47.03 ± 0.9% | 91.55 ± 0.7% | 193.76 ± 3.3% | 4133.82 ± 1.2% | 157.13 ± 0.3% | 0.99 | 1.00 | 3.34 | 1.72 |
| an IPv4 address | 29 | 483.39 ± 0.5% | 488.14 ± 0.7% | 677.09 ± 1.7% | 77.45 ± 0.7% | 121.60 ± 1.1% | 344.05 ± 0.5% | 6761.16 ± 3.8% | 483.64 ± 1.2% | 0.99 | 1.00 | 6.24 | 3.98 |
| a date and time | 56 | 371.14 ± 0.5% | 374.15 ± 0.8% | 473.64 ± 0.6% | 72.45 ± 0.7% | 127.15 ± 2.0% | 355.02 ± 4.2% | 4375.07 ± 0.6% | 371.34 ± 1.0% | 0.99 | 1.00 | 5.12 | 2.92 |
| a field path | 39 | 232.03 ± 0.8% | 233.36 ± 0.9% | 269.85 ± 0.4% | 79.68 ± 1.2% | 190.35 ± 1.4% | 561.45 ± 1.4% | 4176.75 ± 0.6% | 231.60 ± 4.4% | 0.99 | 1.00 | 2.91 | 1.22 |
| literal: a word | 7 | 744.11 ± 0.6% | 791.61 ± 4.9% | 1430.18 ± 0.5% | 525.56 ± 0.2% | 603.34 ± 16.5% | 1129.42 ± 1.3% | 27498.45 ± 2.5% | 744.30 ± 0.3% | 0.94 | 1.00 | 1.42 | 1.23 |
| literal: a word that is not there | 8 | 712.59 ± 0.5% | 769.32 ± 0.4% | 1348.71 ± 1.2% | 487.29 ± 1.3% | 592.60 ± 1.5% | 1066.50 ± 1.7% | 26156.50 ± 2.9% | 712.09 ± 0.5% | 0.93 | 1.00 | 1.46 | 1.20 |
| literal: one of four words | 26 | 286.23 ± 0.3% | 487.06 ± 0.8% | 666.58 ± 0.6% | 39.30 ± 0.8% | 235.42 ± 2.0% | 410.03 ± 0.5% | 14466.82 ± 0.7% | 285.98 ± 1.6% | 0.59 | 1.00 | 7.28 | 1.22 |
| literal: a word in any case | 11 | 559.99 ± 0.5% | 599.79 ± 5.6% | 905.09 ± 1.0% | 13.26 ± 1.2% | 643.07 ± 4.8% | refused | 22034.79 ± 2.2% | 558.06 ± 3.9% | 0.93 | 1.00 | 42.22 | 0.87 |
| literal: an href attribute | 12 | 387.06 ± 0.9% | 397.42 ± 1.4% | 521.98 ± 0.9% | 38.77 ± 0.5% | 471.15 ± 13.3% | 921.22 ± 17.1% | 19041.28 ± 2.8% | 387.39 ± 0.4% | 0.97 | 1.00 | 9.98 | 0.82 |
| literal: a word, second text | 10 | 663.74 ± 0.4% | 726.06 ± 0.6% | 1225.74 ± 0.5% | 441.27 ± 1.2% | 517.75 ± 3.3% | 943.52 ± 1.5% | 24082.82 ± 0.5% | 660.60 ± 3.0% | 0.91 | 1.00 | 1.50 | 1.28 |
| class: two capitalized words | 23 | 555.41 ± 1.1% | 585.40 ± 0.5% | 872.20 ± 4.3% | 103.46 ± 1.0% | 480.55 ± 14.4% | 874.71 ± 1.5% | 5980.04 ± 3.1% | 553.84 ± 0.8% | 0.95 | 1.00 | 5.37 | 1.16 |
| class: a word that ends in ing | 9 | 652.06 ± 0.6% | 735.95 ± 0.5% | 1279.76 ± 1.0% | 135.92 ± 0.7% | 707.38 ± 1.4% | 1339.08 ± 0.4% | 14740.46 ± 1.3% | 653.84 ± 0.9% | 0.89 | 1.00 | 4.80 | 0.92 |
| class: a word in capitals | 16 | 598.25 ± 0.3% | 640.83 ± 0.6% | 1053.52 ± 0.6% | 141.01 ± 0.7% | 709.50 ± 7.1% | 1222.83 ± 0.7% | 7942.57 ± 1.6% | 597.21 ± 1.0% | 0.93 | 1.00 | 4.24 | 0.84 |
| class: a number | 6 | 729.43 ± 0.6% | 795.28 ± 0.5% | 1476.87 ± 1.1% | 34.72 ± 1.4% | 1299.90 ± 3.0% | 2282.38 ± 2.6% | 20709.97 ± 4.0% | 729.43 ± 0.2% | 0.92 | 1.00 | 21.01 | 0.56 |
| class: two capitalized words, second text | 23 | 554.97 ± 1.3% | 587.68 ± 0.6% | 873.18 ± 2.7% | 104.36 ± 0.5% | 478.75 ± 7.2% | 891.18 ± 0.8% | 5987.38 ± 0.5% | 554.93 ± 0.3% | 0.94 | 1.00 | 5.32 | 1.16 |
| other: a word between two words | 13 | 644.85 ± 0.8% | 661.66 ± 7.2% | 1061.56 ± 0.6% | 136.25 ± 0.9% | 477.53 ± 11.0% | 959.60 ± 0.3% | 13430.84 ± 1.2% | 644.17 ± 0.7% | 0.97 | 1.00 | 4.73 | 1.35 |
| other: a number before a unit, second text | 15 | 451.34 ± 0.7% | 493.79 ± 0.5% | 683.81 ± 0.5% | 33.10 ± 4.1% | 580.13 ± 15.7% | 1048.78 ± 3.5% | 13256.96 ± 1.0% | 451.17 ± 0.4% | 0.91 | 1.00 | 13.64 | 0.78 |
| other: a heading's start tag | 13 | 401.53 ± 1.5% | 408.68 ± 1.5% | 531.72 ± 0.3% | 37.88 ± 0.5% | 580.67 ± 1.5% | 1027.18 ± 0.9% | 15907.61 ± 1.5% | 401.41 ± 0.9% | 0.98 | 1.00 | 10.60 | 0.69 |
| other: a whole word | 11 | 677.99 ± 0.5% | 718.39 ± 3.3% | 1208.15 ± 6.4% | 119.35 ± 6.7% | 539.91 ± 6.1% | 985.21 ± 6.7% | 23048.64 ± 1.8% | 678.26 ± 0.3% | 0.94 | 1.00 | 5.68 | 1.26 |
| other: a line's first word, second text | 17 | 621.20 ± 0.4% | 654.61 ± 0.2% | 1048.81 ± 0.4% | 136.20 ± 0.3% | 666.59 ± 4.9% | refused | refused | 618.73 ± 0.5% | 0.95 | 1.00 | 4.56 | 0.93 |
| other: fourteen octets before an x | 16 | 103.97 ± 0.4% | 153.82 ± 0.3% | 183.85 ± 0.3% | 14.69 ± 3.5% | 420.26 ± 52.9% | 473.50 ± 4.0% | 12041.04 ± 0.8% | 103.89 ± 0.1% | 0.68 | 1.00 | 7.08 | 0.25 |
| other: a Greek word | 8 | 472.52 ± 0.9% | 646.48 ± 2.7% | 1040.73 ± 0.9% | 48.32 ± 0.4% | 1291.66 ± 2.4% | 2205.40 ± 4.8% | refused | 471.30 ± 0.6% | 0.73 | 1.00 | 9.78 | 0.37 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 17698.28 ± 3.4% | not timed | not timed | 21366.54 ± 1.0% | 1932.93 ± 22.3% | not timed | not timed | 17677.02 ± 0.8% | | 1.00 | 0.83 | 9.16 |
| 01-literal/sherlock-casei-en | 522 | 4997.26 ± 1.0% | not timed | not timed | 6721.64 ± 1.1% | 29.81 ± 1.1% | not timed | not timed | 4983.88 ± 0.6% | | 1.00 | 0.74 | 167.63 |
| 01-literal/sherlock-ru | 724 | 18693.01 ± 0.4% | not timed | not timed | 21427.59 ± 1.0% | 1177.36 ± 7.8% | not timed | not timed | 18619.54 ± 0.5% | | 1.00 | 0.87 | 15.88 |
| 01-literal/sherlock-casei-ru | 746 | 7002.70 ± 0.1% | not timed | not timed | 5312.18 ± 1.5% | 32.69 ± 0.6% | not timed | not timed | 6994.05 ± 0.4% | | 1.00 | 1.32 | 214.22 |
| 01-literal/sherlock-zh | 30 | 27823.52 ± 0.1% | not timed | not timed | 25984.16 ± 0.4% | 1267.85 ± 0.7% | not timed | not timed | 27820.49 ± 0.4% | | 1.00 | 1.07 | 21.95 |
| 02-literal-alternate/sherlock-en | 714 | 9592.05 ± 0.6% | not timed | not timed | 7473.72 ± 0.5% | 17.81 ± 0.9% | not timed | not timed | 9539.77 ± 0.7% | | 1.01 | 1.28 | 538.54 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1644.46 ± 1.7% | not timed | not timed | 1917.01 ± 0.5% | 10.40 ± 6.5% | not timed | not timed | 1640.75 ± 1.3% | | 1.00 | 0.86 | 158.13 |
| 02-literal-alternate/sherlock-ru | 899 | 5945.56 ± 0.4% | not timed | not timed | 4089.46 ± 1.4% | 23.07 ± 0.8% | not timed | not timed | 5984.61 ± 0.2% | | 0.99 | 1.45 | 257.71 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1711.76 ± 0.9% | not timed | not timed | 983.29 ± 2.0% | 8.74 ± 0.6% | not timed | not timed | 1707.99 ± 0.6% | | 1.00 | 1.74 | 195.90 |
| 02-literal-alternate/sherlock-zh | 207 | 12861.69 ± 2.6% | not timed | not timed | 8525.71 ± 0.7% | 33.00 ± 0.9% | not timed | not timed | 12857.73 ± 1.8% | | 1.00 | 1.51 | 389.75 |
| 03-date/ascii | 111817 | 98.70 ± 0.5% | not timed | not timed | 87.60 ± 0.4% | 0.20 ± 3.8% | not timed | not timed | 98.70 ± 0.3% | | 1.00 | 1.13 | 502.00 |
| 04-ruff-noqa/real | 84 | 574.77 ± 1.5% | not timed | not timed | 449.00 ± 0.4% | 19.75 ± 1.2% | not timed | not timed | 573.32 ± 1.8% | | 1.00 | 1.28 | 29.10 |
| 04-ruff-noqa/tweaked | 44 | 501.45 ± 0.4% | not timed | not timed | 450.98 ± 0.2% | 319.31 ± 1.2% | not timed | not timed | 501.61 ± 0.4% | | 1.00 | 1.11 | 1.57 |
| 05-lexer-veryl/single | 124800 | 3.41 ± 0.8% | not timed | not timed | 4.69 ± 0.7% | 0.21 ± 2.7% | not timed | not timed | 3.41 ± 2.8% | | 1.00 | 0.73 | 16.43 |
| 06-cloud-flare-redos/original | 107 | 246.86 ± 8.9% | not timed | not timed | 194.45 ± 2.9% | 24.85 ± 1.7% | not timed | not timed | 246.35 ± 0.8% | | 1.00 | 1.27 | 9.93 |
| 06-cloud-flare-redos/simplified-short | 102 | 240.54 ± 3.0% | not timed | not timed | 178.38 ± 2.2% | 26.34 ± 5.8% | not timed | not timed | 240.40 ± 7.9% | | 1.00 | 1.35 | 9.13 |
| 06-cloud-flare-redos/simplified-long | 10000 | 235.76 ± 7.2% | not timed | not timed | 213.39 ± 1.6% | 28.67 ± 5.4% | not timed | not timed | 235.64 ± 0.7% | | 1.00 | 1.10 | 8.22 |
| 07-unicode-character-data/parse-line | 558784 | 225.42 ± 0.9% | not timed | not timed | 167.39 ± 1.5% | 39.99 ± 2.1% | not timed | not timed | 225.44 ± 0.4% | | 1.00 | 1.35 | 5.64 |
| 08-words/all-english | 56691 | 91.90 ± 0.6% | not timed | not timed | 73.86 ± 0.7% | 10.76 ± 3.0% | not timed | not timed | 91.72 ± 0.6% | | 1.00 | 1.24 | 8.54 |
| 08-words/long-english | 839 | 830.42 ± 0.2% | not timed | not timed | 496.12 ± 0.4% | 29.21 ± 14.9% | not timed | not timed | 830.17 ± 0.2% | | 1.00 | 1.67 | 28.43 |
| 09-aws-keys/full | 0 | 450.19 ± 0.6% | not timed | not timed | 450.36 ± 5.3% | 56.42 ± 0.8% | not timed | not timed | 449.46 ± 0.3% | | 1.00 | 1.00 | 7.98 |
| 09-aws-keys/quick | 0 | 873.61 ± 0.8% | not timed | not timed | 746.40 ± 1.8% | 368.53 ± 0.9% | not timed | not timed | 872.30 ± 0.5% | | 1.00 | 1.17 | 2.37 |
| 10-bounded-repeat/letters-en | 1833 | 504.69 ± 0.6% | not timed | not timed | 451.81 ± 2.1% | 19.13 ± 0.4% | not timed | not timed | 503.97 ± 0.8% | | 1.00 | 1.12 | 26.38 |
| 10-bounded-repeat/letters-ru | 3475 | 310.26 ± 0.4% | not timed | not timed | 407.02 ± 1.3% | 20.74 ± 13.3% | not timed | not timed | 309.05 ± 2.3% | | 1.00 | 0.76 | 14.96 |
| 10-bounded-repeat/context | 53 | 71.80 ± 1.9% | not timed | not timed | 59.82 ± 0.5% | 19.14 ± 0.4% | not timed | not timed | 71.53 ± 1.2% | | 1.00 | 1.20 | 3.75 |
| 10-bounded-repeat/capitals | 11 | 861.45 ± 0.3% | not timed | not timed | 511.24 ± 0.9% | 35.44 ± 0.4% | not timed | not timed | 862.01 ± 0.5% | | 1.00 | 1.69 | 24.31 |
| 11-unstructured-to-json/extract | 600 | 37.45 ± 2.9% | not timed | not timed | 64.36 ± 0.2% | 49.81 ± 0.9% | not timed | not timed | 37.71 ± 0.8% | | 0.99 | 0.58 | 0.75 |
| 12-dictionary/single | 1 | 452.49 ± 1.7% | not timed | not timed | 436.35 ± 0.2% | 0.38 ± 2.9% | not timed | not timed | 455.34 ± 0.2% | | 0.99 | 1.04 | 1194.23 |
| 14-quadratic/1x | 100 | 11.65 ± 3.1% | not timed | not timed | 10.91 ± 0.6% | 0.98 ± 3.6% | not timed | not timed | 11.58 ± 0.8% | | 1.01 | 1.07 | 11.89 |
| 14-quadratic/2x | 200 | 6.94 ± 0.8% | not timed | not timed | 5.32 ± 0.4% | 0.55 ± 2.1% | not timed | not timed | 6.93 ± 0.8% | | 1.00 | 1.30 | 12.66 |
| 14-quadratic/10x | 1000 | 1.55 ± 1.9% | not timed | not timed | 1.03 ± 0.1% | 0.12 ± 5.4% | not timed | not timed | 1.55 ± 1.5% | | 1.00 | 1.50 | 13.31 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.60 ± 13.8% | not timed | not timed | 0.34 ± 4.0% | 0.52 ± 11.9% | not timed | not timed | 1.58 ± 12.4% | | 1.01 | 4.75 | 3.07 |
| 04-ruff-noqa/compile-real | 1 | 102.53 ± 1.4% | not timed | not timed | 12.13 ± 5.5% | 133.67 ± 7.5% | not timed | not timed | 101.75 ± 1.4% | | 1.01 | 8.46 | 0.77 |
| 05-lexer-veryl/compile-single | 1 | 16.88 ± 1.2% | not timed | not timed | 2.29 ± 2.5% | 6.16 ± 5.0% | not timed | not timed | 16.75 ± 2.6% | | 1.01 | 7.36 | 2.74 |
| 07-unicode-character-data/compile | 1 | 61.54 ± 0.7% | not timed | not timed | 24.70 ± 0.8% | 34.24 ± 1.9% | not timed | not timed | 60.87 ± 1.1% | | 1.01 | 2.49 | 1.80 |
| 09-aws-keys/compile-full | 1 | 40.66 ± 1.1% | not timed | not timed | 6.99 ± 0.7% | 22.11 ± 1.7% | not timed | not timed | 40.08 ± 1.7% | | 1.01 | 5.82 | 1.84 |
| 09-aws-keys/compile-quick | 1 | 192.84 ± 5.6% | not timed | not timed | 46.61 ± 1.0% | 127.57 ± 2.2% | not timed | not timed | 191.25 ± 0.9% | | 1.01 | 4.14 | 1.51 |
| 10-bounded-repeat/compile-context | 1 | 12.06 ± 0.4% | not timed | not timed | 10.96 ± 0.2% | 15.68 ± 4.5% | not timed | not timed | 11.96 ± 0.9% | | 1.01 | 1.10 | 0.77 |
| 10-bounded-repeat/compile-capitals | 1 | 73.63 ± 1.0% | not timed | not timed | 8.26 ± 4.9% | 23.48 ± 0.7% | not timed | not timed | 72.24 ± 2.1% | | 1.02 | 8.92 | 3.14 |
| 11-unstructured-to-json/compile | 1 | 94.13 ± 1.4% | not timed | not timed | 38.74 ± 0.9% | 64.41 ± 1.7% | not timed | not timed | 91.12 ± 0.9% | | 1.03 | 2.43 | 1.46 |
| 12-dictionary/compile-single | 1 | 0.30 ± 1.1% | not timed | not timed | 0.06 ± 8.2% | 0.09 ± 14.4% | not timed | not timed | 0.29 ± 4.1% | | 1.01 | 4.70 | 3.23 |

