# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215476620 |
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
| literal: a word | 217 | 23985.08 ± 0.3% | 3299.72 ± 0.3% | 28.66 ± 0.6% | 24662.72 ± 1.0% | 9238.89 ± 5.3% | 12.09 ± 0.3% | 90.25 ± 1.2% | 23921.83 ± 0.6% | 7.27 | 1.00 | 0.97 | 2.60 |
| literal: a word that is not there | 0 | 30500.00 ± 0.5% | 3241.83 ± 0.7% | 28.58 ± 1.1% | 27139.77 ± 1.4% | 30305.85 ± 0.9% | 11.75 ± 0.1% | 85.92 ± 0.8% | 30478.99 ± 1.4% | 9.41 | 1.00 | 1.12 | 1.01 |
| literal: one of four words | 661 | 10473.36 ± 1.4% | 1540.17 ± 0.4% | 15.22 ± 2.6% | 7821.58 ± 1.2% | 23.25 ± 1.6% | 3.52 ± 0.1% | 7.66 ± 0.4% | 10363.73 ± 1.1% | 6.80 | 1.01 | 1.34 | 450.54 |
| literal: a word in any case | 217 | 20639.82 ± 3.4% | 1643.70 ± 3.4% | 20.38 ± 5.3% | 8002.21 ± 2.1% | 43.21 ± 2.0% | refused | differs | 20574.52 ± 2.8% | 12.56 | 1.00 | 2.58 | 477.67 |
| literal: an href attribute | 33 | 21769.52 ± 1.0% | 516.03 ± 0.2% | 24.34 ± 0.3% | 22201.58 ± 1.6% | 2057.87 ± 1.6% | 8.61 ± 1.0% | 79.64 ± 2.2% | 21741.93 ± 2.2% | 42.19 | 1.00 | 0.98 | 10.58 |
| literal: a word, second text | 123 | 24983.55 ± 0.3% | 2474.68 ± 0.5% | 27.89 ± 0.8% | 24603.62 ± 1.7% | 7336.73 ± 6.3% | 15.73 ± 0.4% | 77.14 ± 1.0% | 25035.74 ± 0.2% | 10.10 | 1.00 | 1.02 | 3.41 |
| class: two capitalized words | 1331 | 791.52 ± 1.2% | 505.66 ± 0.2% | 24.25 ± 0.5% | 487.49 ± 0.2% | 38.81 ± 7.4% | 10.29 ± 0.6% | 63.60 ± 0.3% | 791.73 ± 2.4% | 1.57 | 1.00 | 1.62 | 20.40 |
| class: a word that ends in ing | 3399 | 481.32 ± 0.5% | 479.93 ± 0.8% | 16.60 ± 0.9% | 458.62 ± 0.8% | 27.95 ± 3.2% | 5.79 ± 0.2% | 17.30 ± 0.5% | 480.14 ± 0.2% | 1.00 | 1.00 | 1.05 | 17.22 |
| class: a word in capitals | 2332 | 1075.50 ± 0.7% | 510.76 ± 0.4% | 28.27 ± 0.4% | 480.41 ± 0.4% | 42.36 ± 6.1% | 12.38 ± 0.9% | 81.19 ± 1.3% | 1070.82 ± 0.8% | 2.11 | 1.00 | 2.24 | 25.39 |
| class: a number | 8288 | 1637.27 ± 0.4% | 689.77 ± 0.6% | 27.85 ± 0.7% | 1679.96 ± 0.4% | 41.17 ± 15.9% | 0.34 ± 0.1% | 60.08 ± 1.7% | 1633.78 ± 0.1% | 2.37 | 1.00 | 0.97 | 39.77 |
| class: two capitalized words, second text | 5359 | 427.07 ± 0.8% | 432.92 ± 0.2% | 17.91 ± 2.6% | 405.18 ± 0.1% | 32.46 ± 11.4% | 13.47 ± 1.2% | 58.22 ± 0.3% | 426.21 ± 0.3% | 0.99 | 1.00 | 1.05 | 13.16 |
| other: a word between two words | 6104 | 691.57 ± 0.5% | 491.07 ± 0.4% | 22.17 ± 0.4% | 688.75 ± 1.6% | 105.20 ± 10.3% | 7.80 ± 0.7% | 67.88 ± 0.5% | 690.17 ± 1.5% | 1.41 | 1.00 | 1.00 | 6.57 |
| other: a number before a unit, second text | 1481 | 7435.62 ± 5.5% | 912.18 ± 0.6% | 26.59 ± 0.3% | 7264.87 ± 0.5% | 39.38 ± 0.9% | 14.15 ± 0.2% | 62.09 ± 0.9% | 7157.04 ± 5.0% | 8.15 | 1.04 | 1.02 | 188.83 |
| other: a heading's start tag | 110 | 16220.47 ± 1.3% | 626.46 ± 0.5% | 27.80 ± 0.2% | 2109.74 ± 1.1% | 1541.49 ± 3.0% | 10.67 ± 0.9% | 93.68 ± 0.3% | 16192.28 ± 2.0% | 25.89 | 1.00 | 7.69 | 10.52 |
| other: a whole word | 217 | 19187.82 ± 0.8% | 509.47 ± 1.0% | 28.74 ± 3.4% | 19886.75 ± 4.7% | 45.41 ± 3.0% | 10.20 ± 3.3% | 53.56 ± 0.8% | 19155.46 ± 2.8% | 37.66 | 1.00 | 0.96 | 422.53 |
| other: a line's first word, second text | 3716 | 1999.02 ± 0.9% | 492.25 ± 0.7% | 29.68 ± 2.3% | 1946.29 ± 2.4% | 64.44 ± 9.6% | refused | refused | 1988.23 ± 0.9% | 4.06 | 1.01 | 1.03 | 31.02 |
| other: fourteen octets before an x | 87 | 27346.65 ± 1.1% | 247.77 ± 0.9% | 5.96 ± 0.3% | 3380.69 ± 1.0% | 9.16 ± 0.9% | differs | 16.72 ± 0.5% | 26910.05 ± 0.7% | 110.37 | 1.02 | 8.09 | 2985.40 |
| other: a Greek word | 21815 | 423.79 ± 0.9% | 329.30 ± 0.5% | 30.68 ± 0.7% | 248.48 ± 1.3% | 46.63 ± 7.1% | differs | refused | 421.96 ± 2.3% | 1.29 | 1.00 | 1.71 | 9.09 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.59 ± 0.6% | 18.58 ± 0.7% | 0.86 ± 0.6% | 16.97 ± 0.5% | 2.52 ± 0.2% | differs | 3.90 ± 1.1% | 18.61 ± 0.1% | 1.00 | 1.00 | 1.10 | 7.38 |
| a UUID | 32895 | 20.97 ± 2.0% | 20.99 ± 0.4% | 0.61 ± 0.3% | 13.10 ± 0.8% | 2.49 ± 0.8% | 0.57 ± 0.4% | 3.27 ± 0.6% | 20.98 ± 0.4% | 1.00 | 1.00 | 1.60 | 8.43 |
| an IPv4 address | 33176 | 30.57 ± 0.2% | 30.61 ± 0.6% | 1.91 ± 1.0% | 24.94 ± 0.2% | 6.03 ± 1.7% | differs | 3.80 ± 0.8% | 30.56 ± 0.4% | 1.00 | 1.00 | 1.23 | 5.07 |
| a date and time | 32954 | 30.53 ± 0.7% | 30.48 ± 0.5% | 1.39 ± 1.7% | 18.98 ± 0.2% | 7.82 ± 0.6% | 1.05 ± 0.5% | 7.35 ± 3.1% | 30.44 ± 0.7% | 1.00 | 1.00 | 1.61 | 3.90 |
| a field path | 32606 | 21.05 ± 0.3% | 21.03 ± 0.4% | 1.01 ± 1.4% | 19.54 ± 1.2% | 2.82 ± 1.1% | differs | 2.49 ± 0.7% | 21.05 ± 0.2% | 1.00 | 1.00 | 1.08 | 7.47 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.95 ± 0.3% | 9.96 ± 0.5% | 9.95 ± 0.6% | 11.91 ± 0.9% | 5.15 ± 2.0% | 0.83 ± 0.5% | none | 9.98 ± 0.8% | 1.00 | 1.00 | 0.84 | 1.93 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 233.44 ± 3.1% | 233.79 ± 1.2% | 273.57 ± 0.3% | 87.41 ± 4.0% | 202.08 ± 3.5% | 569.46 ± 1.8% | 3292.16 ± 1.0% | 233.03 ± 3.5% | 1.00 | 1.00 | 2.67 | 1.16 |
| a UUID | 62 | 154.47 ± 1.4% | 155.15 ± 0.3% | 172.30 ± 0.4% | 47.44 ± 1.2% | 91.59 ± 5.2% | 198.05 ± 1.8% | 4227.26 ± 1.5% | 154.15 ± 0.6% | 1.00 | 1.00 | 3.26 | 1.69 |
| an IPv4 address | 29 | 458.99 ± 0.6% | 462.48 ± 0.6% | 634.85 ± 5.2% | 77.32 ± 0.7% | 122.57 ± 2.2% | 349.98 ± 1.1% | 7130.54 ± 0.7% | 458.71 ± 0.8% | 0.99 | 1.00 | 5.94 | 3.74 |
| a date and time | 56 | 347.48 ± 3.6% | 349.76 ± 0.2% | 437.15 ± 0.5% | 72.93 ± 0.7% | 127.86 ± 1.3% | 361.50 ± 1.8% | 4356.80 ± 0.7% | 347.83 ± 1.2% | 0.99 | 1.00 | 4.76 | 2.72 |
| a field path | 39 | 230.95 ± 0.2% | 232.36 ± 0.6% | 269.72 ± 0.5% | 79.89 ± 1.0% | 186.35 ± 23.7% | 570.69 ± 2.8% | 4068.83 ± 3.8% | 231.08 ± 0.4% | 0.99 | 1.00 | 2.89 | 1.24 |
| literal: a word | 7 | 705.22 ± 0.5% | 752.08 ± 0.2% | 1292.40 ± 0.7% | 532.32 ± 0.4% | 622.82 ± 1.9% | 1147.76 ± 1.0% | 27276.80 ± 3.8% | 706.25 ± 0.4% | 0.94 | 1.00 | 1.32 | 1.13 |
| literal: a word that is not there | 8 | 673.53 ± 3.6% | 721.33 ± 0.4% | 1205.87 ± 0.9% | 494.02 ± 0.2% | 587.65 ± 2.4% | 1082.71 ± 0.4% | 26161.69 ± 2.6% | 671.56 ± 3.8% | 0.93 | 1.00 | 1.36 | 1.15 |
| literal: one of four words | 26 | 262.13 ± 0.7% | 437.90 ± 4.6% | 581.79 ± 1.0% | 39.43 ± 0.6% | 233.63 ± 14.5% | 417.13 ± 0.4% | 14523.58 ± 1.6% | 262.76 ± 0.2% | 0.60 | 1.00 | 6.65 | 1.12 |
| literal: a word in any case | 11 | 486.18 ± 0.2% | 519.07 ± 0.6% | 730.47 ± 0.2% | 13.19 ± 0.6% | 634.64 ± 21.9% | refused | 21861.11 ± 1.5% | 485.08 ± 0.2% | 0.94 | 1.00 | 36.85 | 0.77 |
| literal: an href attribute | 12 | 369.54 ± 5.7% | 377.07 ± 6.9% | 483.79 ± 5.4% | 38.63 ± 5.8% | 471.97 ± 3.6% | 943.57 ± 0.4% | 19066.21 ± 1.6% | 369.37 ± 4.5% | 0.98 | 1.00 | 9.57 | 0.78 |
| literal: a word, second text | 10 | 619.90 ± 1.2% | 675.89 ± 0.3% | 1085.41 ± 0.7% | 447.19 ± 1.0% | 518.99 ± 1.8% | 969.93 ± 5.5% | 24046.04 ± 1.3% | 620.22 ± 0.2% | 0.92 | 1.00 | 1.39 | 1.19 |
| class: two capitalized words | 23 | 522.71 ± 0.3% | 553.44 ± 6.2% | 808.88 ± 0.1% | 103.93 ± 4.7% | 483.00 ± 0.9% | 888.81 ± 1.1% | 5952.39 ± 0.4% | 522.43 ± 5.4% | 0.94 | 1.00 | 5.03 | 1.08 |
| class: a word that ends in ing | 9 | 631.95 ± 0.4% | 706.07 ± 0.4% | 1195.25 ± 5.9% | 135.86 ± 1.1% | 703.32 ± 10.0% | 1357.17 ± 1.4% | 14853.91 ± 1.1% | 630.39 ± 0.8% | 0.90 | 1.00 | 4.65 | 0.90 |
| class: a word in capitals | 16 | 573.21 ± 0.4% | 610.59 ± 0.6% | 987.90 ± 5.3% | 141.42 ± 1.3% | 715.25 ± 14.4% | 1245.95 ± 0.3% | 7901.94 ± 0.6% | 574.55 ± 3.2% | 0.94 | 1.00 | 4.05 | 0.80 |
| class: a number | 6 | 713.90 ± 1.0% | 782.48 ± 3.2% | 1422.93 ± 0.4% | 34.54 ± 3.0% | 1301.96 ± 3.1% | 2329.62 ± 3.1% | 20905.71 ± 1.4% | 711.94 ± 0.6% | 0.91 | 1.00 | 20.67 | 0.55 |
| class: two capitalized words, second text | 23 | 523.00 ± 0.9% | 552.56 ± 0.4% | 808.21 ± 0.2% | 104.92 ± 0.7% | 482.43 ± 1.3% | 901.66 ± 0.7% | 5951.80 ± 0.6% | 521.81 ± 0.5% | 0.95 | 1.00 | 4.98 | 1.08 |
| other: a word between two words | 13 | 603.04 ± 0.3% | 624.42 ± 0.3% | 961.97 ± 0.6% | 137.15 ± 0.6% | 481.13 ± 14.9% | 985.09 ± 1.7% | 13417.00 ± 0.9% | 603.81 ± 0.4% | 0.97 | 1.00 | 4.40 | 1.25 |
| other: a number before a unit, second text | 15 | 437.37 ± 0.5% | 482.73 ± 0.8% | 663.39 ± 0.5% | 32.87 ± 0.9% | 588.41 ± 7.0% | 1084.11 ± 2.9% | 13465.97 ± 0.6% | 437.94 ± 0.2% | 0.91 | 1.00 | 13.31 | 0.74 |
| other: a heading's start tag | 13 | 375.60 ± 0.4% | 383.41 ± 0.6% | 495.23 ± 0.5% | 37.80 ± 0.5% | 580.97 ± 1.8% | 1053.94 ± 0.3% | 16173.24 ± 1.4% | 376.15 ± 0.3% | 0.98 | 1.00 | 9.94 | 0.65 |
| other: a whole word | 11 | 633.61 ± 0.5% | 668.99 ± 0.2% | 1072.29 ± 1.0% | 120.60 ± 0.5% | 542.46 ± 1.8% | 999.96 ± 1.2% | 23415.59 ± 3.0% | 633.56 ± 0.6% | 0.95 | 1.00 | 5.25 | 1.17 |
| other: a line's first word, second text | 17 | 588.83 ± 0.5% | 614.41 ± 11.2% | 972.00 ± 8.6% | 137.23 ± 0.9% | 669.35 ± 3.3% | refused | refused | 586.44 ± 0.5% | 0.96 | 1.00 | 4.29 | 0.88 |
| other: fourteen octets before an x | 16 | 106.79 ± 0.3% | 151.27 ± 1.8% | 176.23 ± 0.4% | 14.65 ± 0.4% | 425.60 ± 6.1% | 477.84 ± 1.4% | 12175.70 ± 0.6% | 106.87 ± 0.6% | 0.71 | 1.00 | 7.29 | 0.25 |
| other: a Greek word | 8 | 473.45 ± 1.3% | 648.55 ± 0.6% | 1055.21 ± 0.5% | 48.43 ± 0.8% | 1301.51 ± 2.4% | 2242.62 ± 1.9% | refused | 473.95 ± 1.0% | 0.73 | 1.00 | 9.78 | 0.36 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 18192.75 ± 0.5% | not timed | not timed | 20190.61 ± 0.5% | 1896.95 ± 21.4% | not timed | not timed | 18138.80 ± 0.9% | | 1.00 | 0.90 | 9.59 |
| 01-literal/sherlock-casei-en | 522 | 7946.74 ± 3.7% | not timed | not timed | 6725.68 ± 1.2% | 29.98 ± 1.5% | not timed | not timed | 7834.02 ± 5.6% | | 1.01 | 1.18 | 265.11 |
| 01-literal/sherlock-ru | 724 | 18623.02 ± 2.5% | not timed | not timed | 21458.87 ± 0.7% | 1126.27 ± 1.8% | not timed | not timed | 18592.51 ± 1.1% | | 1.00 | 0.87 | 16.54 |
| 01-literal/sherlock-casei-ru | 746 | 9002.35 ± 0.3% | not timed | not timed | 5294.58 ± 2.6% | 32.55 ± 7.3% | not timed | not timed | 8993.79 ± 0.3% | | 1.00 | 1.70 | 276.58 |
| 01-literal/sherlock-zh | 30 | 27962.20 ± 3.1% | not timed | not timed | 26042.56 ± 0.4% | 1262.52 ± 1.1% | not timed | not timed | 27879.86 ± 0.4% | | 1.00 | 1.07 | 22.15 |
| 02-literal-alternate/sherlock-en | 714 | 9633.72 ± 3.1% | not timed | not timed | 7459.81 ± 0.3% | 17.68 ± 1.0% | not timed | not timed | 9600.79 ± 0.9% | | 1.00 | 1.29 | 544.93 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1764.97 ± 1.0% | not timed | not timed | 1922.36 ± 0.2% | 10.42 ± 3.6% | not timed | not timed | 1757.11 ± 0.8% | | 1.00 | 0.92 | 169.34 |
| 02-literal-alternate/sherlock-ru | 899 | 7705.20 ± 1.2% | not timed | not timed | 4079.79 ± 2.9% | 23.03 ± 0.5% | not timed | not timed | 7778.39 ± 4.9% | | 0.99 | 1.89 | 334.50 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1891.40 ± 0.6% | not timed | not timed | 984.05 ± 0.5% | 8.90 ± 0.9% | not timed | not timed | 1882.40 ± 1.1% | | 1.00 | 1.92 | 212.61 |
| 02-literal-alternate/sherlock-zh | 207 | 13031.15 ± 1.8% | not timed | not timed | 8521.56 ± 0.4% | 32.96 ± 9.0% | not timed | not timed | 12985.00 ± 3.3% | | 1.00 | 1.53 | 395.34 |
| 03-date/ascii | 111817 | 101.35 ± 0.8% | not timed | not timed | 87.83 ± 0.4% | 0.20 ± 1.7% | not timed | not timed | 100.73 ± 1.2% | | 1.01 | 1.15 | 518.12 |
| 04-ruff-noqa/real | 84 | 440.76 ± 0.7% | not timed | not timed | 449.58 ± 4.8% | 19.74 ± 0.6% | not timed | not timed | 441.49 ± 4.2% | | 1.00 | 0.98 | 22.33 |
| 04-ruff-noqa/tweaked | 44 | 499.57 ± 1.0% | not timed | not timed | 451.56 ± 0.3% | 312.17 ± 0.9% | not timed | not timed | 500.36 ± 0.3% | | 1.00 | 1.11 | 1.60 |
| 05-lexer-veryl/single | 124800 | 4.31 ± 0.4% | not timed | not timed | 4.77 ± 0.4% | 0.21 ± 6.9% | not timed | not timed | 4.29 ± 1.6% | | 1.01 | 0.90 | 20.54 |
| 06-cloud-flare-redos/original | 107 | 377.56 ± 0.1% | not timed | not timed | 195.50 ± 5.1% | 24.78 ± 1.3% | not timed | not timed | 377.35 ± 3.6% | | 1.00 | 1.93 | 15.23 |
| 06-cloud-flare-redos/simplified-short | 102 | 368.77 ± 0.4% | not timed | not timed | 179.43 ± 0.7% | 26.23 ± 1.0% | not timed | not timed | 368.48 ± 0.1% | | 1.00 | 2.06 | 14.06 |
| 06-cloud-flare-redos/simplified-long | 10000 | 445.18 ± 0.2% | not timed | not timed | 213.91 ± 0.5% | 28.92 ± 1.4% | not timed | not timed | 445.09 ± 0.2% | | 1.00 | 2.08 | 15.39 |
| 07-unicode-character-data/parse-line | 558784 | 224.49 ± 1.2% | not timed | not timed | 168.34 ± 3.4% | 37.89 ± 6.0% | not timed | not timed | 223.67 ± 1.7% | | 1.00 | 1.33 | 5.93 |
| 08-words/all-english | 56691 | 90.37 ± 1.3% | not timed | not timed | 74.22 ± 0.4% | 10.72 ± 3.4% | not timed | not timed | 89.73 ± 0.8% | | 1.01 | 1.22 | 8.43 |
| 08-words/long-english | 839 | 515.87 ± 0.3% | not timed | not timed | 496.03 ± 0.0% | 29.46 ± 0.4% | not timed | not timed | 515.67 ± 0.6% | | 1.00 | 1.04 | 17.51 |
| 09-aws-keys/full | 0 | 450.50 ± 4.3% | not timed | not timed | 459.93 ± 1.5% | 51.73 ± 2.8% | not timed | not timed | 450.30 ± 1.1% | | 1.00 | 0.98 | 8.71 |
| 09-aws-keys/quick | 0 | 842.70 ± 0.9% | not timed | not timed | 747.10 ± 0.7% | 354.34 ± 12.7% | not timed | not timed | 841.45 ± 0.7% | | 1.00 | 1.13 | 2.38 |
| 10-bounded-repeat/letters-en | 1833 | 536.80 ± 2.6% | not timed | not timed | 452.52 ± 2.4% | 19.15 ± 0.5% | not timed | not timed | 526.24 ± 4.1% | | 1.02 | 1.19 | 28.04 |
| 10-bounded-repeat/letters-ru | 3475 | 439.33 ± 1.2% | not timed | not timed | 404.35 ± 1.4% | 20.59 ± 14.5% | not timed | not timed | 434.57 ± 1.6% | | 1.01 | 1.09 | 21.34 |
| 10-bounded-repeat/context | 53 | 70.31 ± 0.9% | not timed | not timed | 59.98 ± 0.7% | 19.16 ± 1.1% | not timed | not timed | 69.67 ± 2.0% | | 1.01 | 1.17 | 3.67 |
| 10-bounded-repeat/capitals | 11 | 534.35 ± 7.9% | not timed | not timed | 506.06 ± 0.7% | 35.43 ± 0.6% | not timed | not timed | 533.28 ± 8.2% | | 1.00 | 1.06 | 15.08 |
| 11-unstructured-to-json/extract | 600 | 70.67 ± 0.7% | not timed | not timed | 64.38 ± 0.4% | 49.80 ± 0.6% | not timed | not timed | 70.62 ± 0.5% | | 1.00 | 1.10 | 1.42 |
| 12-dictionary/single | 1 | 455.94 ± 0.2% | not timed | not timed | 437.10 ± 0.2% | 0.38 ± 0.5% | not timed | not timed | 455.08 ± 0.7% | | 1.00 | 1.04 | 1203.74 |
| 14-quadratic/1x | 100 | 23.27 ± 0.8% | not timed | not timed | 10.91 ± 0.5% | 0.99 ± 3.8% | not timed | not timed | 23.15 ± 0.5% | | 1.00 | 2.13 | 23.40 |
| 14-quadratic/2x | 200 | 17.98 ± 4.2% | not timed | not timed | 5.31 ± 3.1% | 0.55 ± 7.0% | not timed | not timed | 17.93 ± 3.8% | | 1.00 | 3.38 | 32.93 |
| 14-quadratic/10x | 1000 | 5.65 ± 0.5% | not timed | not timed | 1.03 ± 0.6% | 0.12 ± 0.7% | not timed | not timed | 5.64 ± 1.1% | | 1.00 | 5.49 | 47.25 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.31 ± 0.3% | not timed | not timed | 0.34 ± 0.4% | 0.51 ± 4.2% | not timed | not timed | 1.30 ± 0.9% | | 1.00 | 3.83 | 2.58 |
| 04-ruff-noqa/compile-real | 1 | 95.00 ± 0.4% | not timed | not timed | 12.10 ± 0.6% | 132.63 ± 4.0% | not timed | not timed | 95.15 ± 1.2% | | 1.00 | 7.85 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 15.32 ± 1.6% | not timed | not timed | 2.29 ± 1.7% | 5.98 ± 4.0% | not timed | not timed | 15.28 ± 1.2% | | 1.00 | 6.70 | 2.56 |
| 07-unicode-character-data/compile | 1 | 57.27 ± 0.6% | not timed | not timed | 24.86 ± 0.8% | 33.47 ± 1.5% | not timed | not timed | 57.08 ± 0.7% | | 1.00 | 2.30 | 1.71 |
| 09-aws-keys/compile-full | 1 | 37.83 ± 0.4% | not timed | not timed | 6.98 ± 0.6% | 21.56 ± 14.4% | not timed | not timed | 37.62 ± 1.5% | | 1.01 | 5.42 | 1.75 |
| 09-aws-keys/compile-quick | 1 | 177.98 ± 2.3% | not timed | not timed | 45.91 ± 4.3% | 123.97 ± 7.5% | not timed | not timed | 176.31 ± 3.0% | | 1.01 | 3.88 | 1.44 |
| 10-bounded-repeat/compile-context | 1 | 11.48 ± 1.0% | not timed | not timed | 10.88 ± 3.5% | 15.84 ± 8.3% | not timed | not timed | 11.45 ± 1.6% | | 1.00 | 1.06 | 0.72 |
| 10-bounded-repeat/compile-capitals | 1 | 69.75 ± 0.2% | not timed | not timed | 8.27 ± 0.3% | 23.45 ± 1.9% | not timed | not timed | 70.49 ± 0.6% | | 0.99 | 8.43 | 2.97 |
| 11-unstructured-to-json/compile | 1 | 85.77 ± 0.8% | not timed | not timed | 38.99 ± 0.7% | 63.01 ± 4.0% | not timed | not timed | 86.52 ± 0.4% | | 0.99 | 2.20 | 1.36 |
| 12-dictionary/compile-single | 1 | 0.30 ± 1.2% | not timed | not timed | 0.07 ± 3.9% | 0.09 ± 7.7% | not timed | not timed | 0.29 ± 1.7% | | 1.00 | 4.54 | 3.23 |

