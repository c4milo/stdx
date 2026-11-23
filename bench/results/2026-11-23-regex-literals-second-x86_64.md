# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243460149 |
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
| literal: a word | 217 | 38758.28 ± 3.0% | 3348.51 ± 0.6% | 20.07 ± 2.8% | 31159.89 ± 2.1% | 8958.04 ± 9.1% | 10.79 ± 0.2% | 75.08 ± 2.5% | 37972.64 ± 2.4% | 11.57 | 1.02 | 1.24 | 4.33 |
| literal: a word that is not there | 0 | 52196.07 ± 1.2% | 3238.48 ± 0.4% | 19.93 ± 3.2% | 39960.04 ± 1.0% | 30312.45 ± 0.6% | 10.74 ± 0.9% | 71.26 ± 2.1% | 52004.55 ± 0.5% | 16.12 | 1.00 | 1.31 | 1.72 |
| literal: one of four words | 661 | 11647.14 ± 1.2% | 1396.10 ± 0.5% | 10.78 ± 2.1% | 9141.30 ± 0.3% | 19.31 ± 1.3% | 3.99 ± 1.4% | 6.03 ± 0.5% | 11569.01 ± 1.3% | 8.34 | 1.01 | 1.27 | 603.04 |
| literal: a word in any case | 217 | 30083.55 ± 1.9% | 1493.75 ± 0.4% | 15.02 ± 1.4% | 9238.67 ± 0.6% | 37.26 ± 0.4% | refused | differs | 30223.72 ± 1.9% | 20.14 | 1.00 | 3.26 | 807.37 |
| literal: an href attribute | 33 | 29042.59 ± 3.5% | 540.09 ± 0.2% | 18.54 ± 2.5% | 27318.14 ± 1.0% | 2057.00 ± 2.1% | 8.13 ± 18.1% | 62.91 ± 46.2% | 28827.96 ± 11.6% | 53.77 | 1.01 | 1.06 | 14.12 |
| literal: a word, second text | 123 | 37141.27 ± 3.4% | 2375.92 ± 0.3% | 19.93 ± 0.5% | 31593.26 ± 1.9% | 7266.13 ± 4.9% | 11.91 ± 0.4% | 63.99 ± 1.7% | 36739.29 ± 1.5% | 15.63 | 1.01 | 1.18 | 5.11 |
| class: two capitalized words | 1331 | 765.02 ± 0.7% | 526.42 ± 0.2% | 18.69 ± 1.8% | 505.79 ± 1.1% | 34.38 ± 9.3% | 9.35 ± 0.2% | 57.48 ± 0.3% | 764.93 ± 0.5% | 1.45 | 1.00 | 1.51 | 22.25 |
| class: a word that ends in ing | 3399 | 499.59 ± 0.2% | 499.43 ± 0.3% | 12.98 ± 0.7% | 472.22 ± 0.2% | 25.76 ± 6.4% | 5.37 ± 0.4% | 16.38 ± 1.7% | 500.26 ± 0.3% | 1.00 | 1.00 | 1.06 | 19.39 |
| class: a word in capitals | 2332 | 942.30 ± 0.3% | 531.39 ± 1.8% | 19.87 ± 1.8% | 497.60 ± 0.4% | 36.76 ± 13.2% | 10.38 ± 0.3% | 77.51 ± 5.3% | 941.36 ± 0.2% | 1.77 | 1.00 | 1.89 | 25.63 |
| class: a number | 8288 | 1448.45 ± 0.2% | 699.88 ± 0.6% | 19.82 ± 3.1% | 1481.03 ± 0.5% | 36.09 ± 10.1% | 0.34 ± 0.3% | 55.55 ± 0.6% | 1452.19 ± 0.3% | 2.07 | 1.00 | 0.98 | 40.13 |
| class: two capitalized words, second text | 5359 | 444.32 ± 0.3% | 451.21 ± 1.5% | 17.09 ± 0.4% | 416.56 ± 0.2% | 28.74 ± 9.0% | 10.54 ± 1.3% | 52.83 ± 0.5% | 443.06 ± 1.3% | 0.98 | 1.00 | 1.07 | 15.46 |
| other: a word between two words | 6104 | 707.20 ± 0.5% | 510.90 ± 0.3% | 16.94 ± 1.6% | 696.06 ± 2.9% | 98.36 ± 16.5% | 7.27 ± 0.1% | 58.12 ± 2.2% | 709.13 ± 4.0% | 1.38 | 1.00 | 1.02 | 7.19 |
| other: a number before a unit, second text | 1481 | 7262.89 ± 1.1% | 858.21 ± 0.6% | 18.88 ± 9.6% | 6459.25 ± 1.4% | 35.19 ± 7.3% | 10.96 ± 0.4% | 56.12 ± 0.5% | 7237.36 ± 5.6% | 8.46 | 1.00 | 1.12 | 206.40 |
| other: a heading's start tag | 110 | 19409.99 ± 1.8% | 654.74 ± 0.1% | 19.48 ± 3.3% | 2011.31 ± 2.6% | 1480.58 ± 1.3% | 10.06 ± 0.4% | 74.21 ± 2.2% | 19352.01 ± 1.2% | 29.65 | 1.00 | 9.65 | 13.11 |
| other: a whole word | 217 | 23478.27 ± 1.3% | 532.31 ± 0.1% | 19.66 ± 2.4% | 22629.99 ± 1.8% | 40.21 ± 0.8% | 9.47 ± 0.5% | 46.38 ± 1.4% | 23058.66 ± 0.6% | 44.11 | 1.02 | 1.04 | 583.91 |
| other: a line's first word, second text | 3716 | 1919.70 ± 3.8% | 511.98 ± 0.4% | 22.38 ± 0.8% | 1741.52 ± 3.0% | 52.91 ± 5.4% | refused | refused | 1941.20 ± 4.0% | 3.75 | 0.99 | 1.10 | 36.28 |
| other: fourteen octets before an x | 87 | 27986.87 ± 0.9% | 208.64 ± 0.4% | 5.43 ± 0.2% | 2835.58 ± 0.7% | 9.02 ± 0.2% | differs | 14.89 ± 2.4% | 27618.75 ± 1.4% | 134.14 | 1.01 | 9.87 | 3103.62 |
| other: a Greek word | 21815 | 381.73 ± 0.8% | 334.91 ± 0.3% | 23.81 ± 1.8% | 261.68 ± 0.7% | 43.82 ± 10.4% | differs | refused | 385.37 ± 0.4% | 1.14 | 0.99 | 1.46 | 8.71 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 16.81 ± 0.5% | 16.85 ± 0.4% | 0.78 ± 1.5% | 16.86 ± 0.8% | 2.32 ± 0.3% | differs | 3.58 ± 0.8% | 16.84 ± 0.1% | 1.00 | 1.00 | 1.00 | 7.23 |
| a UUID | 32895 | 18.35 ± 0.6% | 18.34 ± 0.5% | 0.55 ± 0.5% | 12.89 ± 1.0% | 2.44 ± 0.8% | 0.44 ± 0.1% | 3.00 ± 1.1% | 18.14 ± 0.5% | 1.00 | 1.01 | 1.42 | 7.51 |
| an IPv4 address | 33176 | 29.94 ± 3.2% | 30.01 ± 3.3% | 1.73 ± 3.8% | 24.13 ± 1.8% | 5.67 ± 2.1% | differs | 3.33 ± 4.6% | 30.56 ± 3.7% | 1.00 | 0.98 | 1.24 | 5.28 |
| a date and time | 32954 | 26.35 ± 0.5% | 27.06 ± 0.6% | 1.24 ± 1.7% | 18.08 ± 0.3% | 6.58 ± 3.0% | 0.76 ± 0.6% | 5.95 ± 1.3% | 26.82 ± 0.5% | 0.97 | 0.98 | 1.46 | 4.00 |
| a field path | 32606 | 19.89 ± 1.6% | 19.86 ± 0.3% | 0.87 ± 2.8% | 17.03 ± 0.6% | 2.92 ± 0.9% | differs | 2.45 ± 0.6% | 19.98 ± 0.6% | 1.00 | 1.00 | 1.17 | 6.81 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.30 ± 0.4% | 8.34 ± 2.3% | 8.33 ± 0.8% | 10.70 ± 0.8% | 4.71 ± 3.3% | 0.62 ± 0.2% | none | 8.35 ± 0.8% | 1.00 | 0.99 | 0.78 | 1.76 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 204.71 ± 2.0% | 206.03 ± 0.5% | 242.28 ± 0.3% | 80.16 ± 4.1% | 182.55 ± 2.3% | 539.76 ± 12.4% | 3439.32 ± 46.4% | 204.08 ± 1.3% | 0.99 | 1.00 | 2.55 | 1.12 |
| a UUID | 62 | 133.02 ± 1.5% | 133.50 ± 0.7% | 149.07 ± 0.9% | 46.35 ± 1.0% | 91.09 ± 3.3% | 200.79 ± 2.5% | 3868.13 ± 0.7% | 133.07 ± 0.8% | 1.00 | 1.00 | 2.87 | 1.46 |
| an IPv4 address | 29 | 382.25 ± 0.6% | 386.54 ± 0.4% | 533.37 ± 0.3% | 70.71 ± 1.5% | 113.97 ± 4.7% | 332.66 ± 2.5% | 6574.58 ± 1.1% | 384.06 ± 0.9% | 0.99 | 1.00 | 5.41 | 3.35 |
| a date and time | 56 | 278.15 ± 1.6% | 280.56 ± 1.5% | 348.14 ± 0.6% | 68.67 ± 0.9% | 123.71 ± 4.0% | 374.00 ± 1.5% | 3918.39 ± 3.3% | 278.67 ± 0.2% | 0.99 | 1.00 | 4.05 | 2.25 |
| a field path | 39 | 205.20 ± 1.7% | 206.38 ± 1.0% | 243.23 ± 0.5% | 74.53 ± 0.6% | 173.98 ± 1.3% | 591.40 ± 4.3% | 4428.41 ± 1.0% | 205.01 ± 0.5% | 0.99 | 1.00 | 2.75 | 1.18 |
| literal: a word | 7 | 571.05 ± 0.6% | 616.30 ± 0.5% | 1074.97 ± 1.1% | 465.75 ± 3.2% | 574.16 ± 6.2% | 1260.74 ± 1.1% | 24332.85 ± 0.2% | 573.37 ± 0.3% | 0.93 | 1.00 | 1.23 | 0.99 |
| literal: a word that is not there | 8 | 548.84 ± 0.7% | 596.25 ± 0.6% | 1003.91 ± 0.6% | 442.07 ± 8.8% | 544.67 ± 13.7% | 1187.78 ± 1.5% | 22446.42 ± 0.8% | 549.40 ± 0.6% | 0.92 | 1.00 | 1.24 | 1.01 |
| literal: one of four words | 26 | 213.60 ± 1.5% | 355.18 ± 0.4% | 472.19 ± 0.5% | 41.59 ± 0.6% | 217.31 ± 1.2% | 436.64 ± 4.6% | 9874.84 ± 1.4% | 212.83 ± 0.8% | 0.60 | 1.00 | 5.14 | 0.98 |
| literal: a word in any case | 11 | 395.75 ± 0.5% | 416.92 ± 0.5% | 591.26 ± 0.6% | 14.44 ± 2.8% | 605.96 ± 1.3% | refused | 18450.00 ± 11.4% | 393.07 ± 1.1% | 0.95 | 1.01 | 27.41 | 0.65 |
| literal: an href attribute | 12 | 319.87 ± 3.9% | 333.88 ± 0.4% | 441.43 ± 1.2% | 37.23 ± 2.3% | 428.48 ± 4.4% | 938.87 ± 1.1% | 17161.52 ± 0.7% | 319.90 ± 0.6% | 0.96 | 1.00 | 8.59 | 0.75 |
| literal: a word, second text | 10 | 506.39 ± 0.5% | 556.13 ± 0.2% | 899.12 ± 0.4% | 404.38 ± 1.2% | 485.13 ± 1.6% | 986.17 ± 0.6% | 20670.96 ± 1.5% | 505.35 ± 0.3% | 0.91 | 1.00 | 1.25 | 1.04 |
| class: two capitalized words | 23 | 414.78 ± 0.8% | 447.13 ± 0.3% | 649.17 ± 0.5% | 95.02 ± 1.3% | 441.41 ± 3.7% | 937.97 ± 1.4% | 6101.76 ± 2.6% | 414.58 ± 0.5% | 0.93 | 1.00 | 4.37 | 0.94 |
| class: a word that ends in ing | 9 | 494.00 ± 0.4% | 569.49 ± 1.2% | 994.01 ± 0.7% | 113.71 ± 0.6% | 616.93 ± 17.2% | 1394.53 ± 1.8% | 14858.13 ± 0.2% | 494.88 ± 9.5% | 0.87 | 1.00 | 4.34 | 0.80 |
| class: a word in capitals | 16 | 430.69 ± 0.6% | 466.26 ± 0.4% | 771.64 ± 0.5% | 121.62 ± 11.2% | 637.67 ± 15.3% | 1281.17 ± 5.3% | 8215.65 ± 16.2% | 430.85 ± 0.4% | 0.92 | 1.00 | 3.54 | 0.68 |
| class: a number | 6 | 551.94 ± 0.9% | 613.05 ± 0.3% | 1174.80 ± 0.4% | 36.15 ± 1.3% | 1166.40 ± 1.4% | 2162.56 ± 10.8% | 20135.91 ± 18.8% | 551.81 ± 0.6% | 0.90 | 1.00 | 15.27 | 0.47 |
| class: two capitalized words, second text | 23 | 415.91 ± 0.6% | 442.73 ± 2.5% | 633.39 ± 3.9% | 96.06 ± 1.1% | 447.45 ± 1.7% | 946.29 ± 1.5% | 6127.96 ± 1.6% | 415.21 ± 0.3% | 0.94 | 1.00 | 4.33 | 0.93 |
| other: a word between two words | 13 | 492.88 ± 0.4% | 516.93 ± 9.0% | 799.36 ± 3.0% | 121.52 ± 0.8% | 432.07 ± 2.1% | 1018.62 ± 1.6% | 12359.38 ± 2.9% | 492.99 ± 2.6% | 0.95 | 1.00 | 4.06 | 1.14 |
| other: a number before a unit, second text | 15 | 367.99 ± 3.1% | 414.15 ± 2.1% | 583.99 ± 2.5% | 33.12 ± 4.1% | 522.81 ± 8.0% | 1110.57 ± 4.1% | 12718.95 ± 8.3% | 367.04 ± 2.5% | 0.89 | 1.00 | 11.11 | 0.70 |
| other: a heading's start tag | 13 | 332.70 ± 0.7% | 341.41 ± 4.5% | 452.54 ± 1.9% | 35.18 ± 1.2% | 512.90 ± 0.7% | 1068.36 ± 0.9% | 15456.44 ± 5.2% | 332.97 ± 0.5% | 0.97 | 1.00 | 9.46 | 0.65 |
| other: a whole word | 11 | 496.74 ± 0.3% | 530.39 ± 0.4% | 829.62 ± 0.3% | 108.42 ± 1.2% | 498.07 ± 12.0% | 1036.87 ± 1.0% | 18984.78 ± 3.0% | 496.52 ± 0.8% | 0.94 | 1.00 | 4.58 | 1.00 |
| other: a line's first word, second text | 17 | 472.07 ± 9.3% | 505.55 ± 0.4% | 818.95 ± 0.3% | 115.50 ± 10.2% | 592.85 ± 1.7% | refused | refused | 474.20 ± 0.4% | 0.93 | 1.00 | 4.09 | 0.80 |
| other: fourteen octets before an x | 16 | 87.50 ± 1.8% | 124.10 ± 0.8% | 143.04 ± 0.5% | 14.36 ± 0.5% | 389.62 ± 11.9% | 444.64 ± 0.8% | 11751.68 ± 0.5% | 87.62 ± 7.1% | 0.71 | 1.00 | 6.09 | 0.22 |
| other: a Greek word | 8 | 375.28 ± 2.9% | 504.68 ± 11.1% | 938.68 ± 0.6% | 46.30 ± 0.5% | 1134.35 ± 1.5% | 2125.44 ± 3.5% | refused | 374.43 ± 0.8% | 0.74 | 1.00 | 8.11 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 26842.28 ± 2.2% | not timed | not timed | 26817.16 ± 0.9% | 1885.45 ± 19.6% | not timed | not timed | 26557.43 ± 2.4% | | 1.01 | 1.00 | 14.24 |
| 01-literal/sherlock-casei-en | 522 | 8046.60 ± 1.5% | not timed | not timed | 7069.85 ± 0.4% | 23.48 ± 0.4% | not timed | not timed | 7973.43 ± 0.3% | | 1.01 | 1.14 | 342.70 |
| 01-literal/sherlock-ru | 724 | 27882.93 ± 1.6% | not timed | not timed | 27891.69 ± 1.5% | 1065.05 ± 23.7% | not timed | not timed | 27905.47 ± 2.4% | | 1.00 | 1.00 | 26.18 |
| 01-literal/sherlock-casei-ru | 746 | 9759.92 ± 7.6% | not timed | not timed | 5531.98 ± 0.5% | 29.78 ± 20.4% | not timed | not timed | 9760.35 ± 0.2% | | 1.00 | 1.76 | 327.71 |
| 01-literal/sherlock-zh | 30 | 45889.35 ± 4.7% | not timed | not timed | 36945.84 ± 0.7% | 1268.27 ± 3.0% | not timed | not timed | 45648.02 ± 8.1% | | 1.01 | 1.24 | 36.18 |
| 02-literal-alternate/sherlock-en | 714 | 10050.90 ± 15.9% | not timed | not timed | 8886.30 ± 0.5% | 14.37 ± 18.1% | not timed | not timed | 10076.12 ± 0.3% | | 1.00 | 1.13 | 699.61 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2065.88 ± 7.2% | not timed | not timed | 1822.42 ± 0.3% | 8.88 ± 1.3% | not timed | not timed | 2043.10 ± 1.1% | | 1.01 | 1.13 | 232.57 |
| 02-literal-alternate/sherlock-ru | 899 | 8152.86 ± 10.7% | not timed | not timed | 4263.28 ± 0.2% | 19.48 ± 1.0% | not timed | not timed | 8165.65 ± 0.2% | | 1.00 | 1.91 | 418.45 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2109.45 ± 3.9% | not timed | not timed | 1031.19 ± 0.3% | 8.51 ± 2.1% | not timed | not timed | 2098.89 ± 4.0% | | 1.01 | 2.05 | 247.77 |
| 02-literal-alternate/sherlock-zh | 207 | 14435.48 ± 0.6% | not timed | not timed | 10443.05 ± 0.3% | 25.67 ± 5.8% | not timed | not timed | 14406.81 ± 6.2% | | 1.00 | 1.38 | 562.37 |
| 03-date/ascii | 111817 | 95.62 ± 4.2% | not timed | not timed | 84.51 ± 7.7% | 0.18 ± 1.4% | not timed | not timed | 96.24 ± 0.5% | | 0.99 | 1.13 | 530.95 |
| 04-ruff-noqa/real | 84 | 410.24 ± 0.2% | not timed | not timed | 437.83 ± 0.6% | 16.18 ± 1.9% | not timed | not timed | 410.24 ± 0.4% | | 1.00 | 0.94 | 25.36 |
| 04-ruff-noqa/tweaked | 44 | 501.90 ± 10.7% | not timed | not timed | 425.14 ± 2.4% | 294.09 ± 2.3% | not timed | not timed | 511.91 ± 2.2% | | 0.98 | 1.18 | 1.71 |
| 05-lexer-veryl/single | 124800 | 3.44 ± 4.5% | not timed | not timed | 4.14 ± 2.7% | 0.21 ± 4.8% | not timed | not timed | 3.44 ± 2.9% | | 1.00 | 0.83 | 16.15 |
| 06-cloud-flare-redos/original | 107 | 348.90 ± 0.1% | not timed | not timed | 191.03 ± 5.4% | 20.19 ± 1.8% | not timed | not timed | 348.84 ± 0.1% | | 1.00 | 1.83 | 17.28 |
| 06-cloud-flare-redos/simplified-short | 102 | 330.94 ± 4.2% | not timed | not timed | 192.07 ± 1.7% | 22.04 ± 0.3% | not timed | not timed | 329.77 ± 3.6% | | 1.00 | 1.72 | 15.02 |
| 06-cloud-flare-redos/simplified-long | 10000 | 465.22 ± 0.5% | not timed | not timed | 211.24 ± 17.9% | 24.15 ± 0.8% | not timed | not timed | 464.81 ± 0.2% | | 1.00 | 2.20 | 19.27 |
| 07-unicode-character-data/parse-line | 558784 | 198.88 ± 0.6% | not timed | not timed | 156.27 ± 2.8% | 36.67 ± 19.4% | not timed | not timed | 196.97 ± 4.4% | | 1.01 | 1.27 | 5.42 |
| 08-words/all-english | 56691 | 96.81 ± 0.9% | not timed | not timed | 73.98 ± 12.5% | 10.04 ± 5.5% | not timed | not timed | 96.20 ± 0.7% | | 1.01 | 1.31 | 9.64 |
| 08-words/long-english | 839 | 535.92 ± 0.6% | not timed | not timed | 515.26 ± 0.6% | 26.18 ± 9.0% | not timed | not timed | 536.39 ± 0.2% | | 1.00 | 1.04 | 20.47 |
| 09-aws-keys/full | 0 | 415.01 ± 0.6% | not timed | not timed | 450.16 ± 0.2% | 47.67 ± 4.4% | not timed | not timed | 415.43 ± 7.9% | | 1.00 | 0.92 | 8.71 |
| 09-aws-keys/quick | 0 | 961.36 ± 5.5% | not timed | not timed | 801.70 ± 3.5% | 330.56 ± 0.5% | not timed | not timed | 957.13 ± 1.9% | | 1.00 | 1.20 | 2.91 |
| 10-bounded-repeat/letters-en | 1833 | 483.93 ± 3.5% | not timed | not timed | 431.83 ± 0.4% | 16.70 ± 1.4% | not timed | not timed | 483.19 ± 3.2% | | 1.00 | 1.12 | 28.99 |
| 10-bounded-repeat/letters-ru | 3475 | 430.00 ± 1.1% | not timed | not timed | 407.60 ± 3.4% | 18.07 ± 11.6% | not timed | not timed | 429.16 ± 1.6% | | 1.00 | 1.05 | 23.80 |
| 10-bounded-repeat/context | 53 | 65.25 ± 1.1% | not timed | not timed | 55.82 ± 1.0% | 16.85 ± 3.4% | not timed | not timed | 65.39 ± 8.5% | | 1.00 | 1.17 | 3.87 |
| 10-bounded-repeat/capitals | 11 | 558.17 ± 8.5% | not timed | not timed | 531.46 ± 0.2% | 30.96 ± 0.7% | not timed | not timed | 553.78 ± 8.2% | | 1.01 | 1.05 | 18.03 |
| 11-unstructured-to-json/extract | 600 | 55.53 ± 17.2% | not timed | not timed | 62.82 ± 0.6% | 40.75 ± 1.7% | not timed | not timed | 55.39 ± 7.6% | | 1.00 | 0.88 | 1.36 |
| 12-dictionary/single | 1 | 460.22 ± 2.2% | not timed | not timed | 441.27 ± 0.2% | 0.33 ± 5.8% | not timed | not timed | 456.99 ± 0.7% | | 1.01 | 1.04 | 1377.64 |
| 14-quadratic/1x | 100 | 21.14 ± 0.8% | not timed | not timed | 9.13 ± 0.4% | 0.81 ± 3.3% | not timed | not timed | 20.94 ± 3.7% | | 1.01 | 2.32 | 26.21 |
| 14-quadratic/2x | 200 | 16.18 ± 1.0% | not timed | not timed | 4.92 ± 2.6% | 0.43 ± 0.3% | not timed | not timed | 16.20 ± 0.4% | | 1.00 | 3.29 | 37.51 |
| 14-quadratic/10x | 1000 | 5.63 ± 0.1% | not timed | not timed | 1.05 ± 1.4% | 0.09 ± 15.4% | not timed | not timed | 5.62 ± 0.4% | | 1.00 | 5.35 | 60.82 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.18 ± 0.6% | not timed | not timed | 0.39 ± 1.3% | 0.48 ± 3.0% | not timed | not timed | 1.17 ± 0.7% | | 1.00 | 3.04 | 2.44 |
| 04-ruff-noqa/compile-real | 1 | 84.40 ± 0.8% | not timed | not timed | 12.84 ± 0.4% | 125.02 ± 2.2% | not timed | not timed | 84.45 ± 1.0% | | 1.00 | 6.57 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 12.71 ± 1.6% | not timed | not timed | 2.36 ± 1.8% | 5.92 ± 1.0% | not timed | not timed | 12.63 ± 1.2% | | 1.01 | 5.38 | 2.15 |
| 07-unicode-character-data/compile | 1 | 51.88 ± 0.4% | not timed | not timed | 24.42 ± 1.5% | 32.66 ± 5.7% | not timed | not timed | 51.80 ± 1.4% | | 1.00 | 2.12 | 1.59 |
| 09-aws-keys/compile-full | 1 | 35.38 ± 0.6% | not timed | not timed | 7.41 ± 1.2% | 20.78 ± 5.0% | not timed | not timed | 34.93 ± 1.1% | | 1.01 | 4.78 | 1.70 |
| 09-aws-keys/compile-quick | 1 | 153.73 ± 0.5% | not timed | not timed | 43.87 ± 8.9% | 118.33 ± 1.5% | not timed | not timed | 153.02 ± 1.3% | | 1.00 | 3.50 | 1.30 |
| 10-bounded-repeat/compile-context | 1 | 10.45 ± 1.1% | not timed | not timed | 11.68 ± 0.7% | 15.21 ± 1.7% | not timed | not timed | 10.46 ± 1.0% | | 1.00 | 0.89 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 71.84 ± 0.8% | not timed | not timed | 8.81 ± 3.1% | 22.66 ± 0.9% | not timed | not timed | 71.68 ± 1.1% | | 1.00 | 8.16 | 3.17 |
| 11-unstructured-to-json/compile | 1 | 75.42 ± 1.9% | not timed | not timed | 35.72 ± 2.9% | 58.53 ± 18.9% | not timed | not timed | 75.34 ± 2.1% | | 1.00 | 2.11 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.28 ± 2.5% | not timed | not timed | 0.07 ± 4.6% | 0.08 ± 11.6% | not timed | not timed | 0.28 ± 9.0% | | 1.01 | 4.17 | 3.44 |

