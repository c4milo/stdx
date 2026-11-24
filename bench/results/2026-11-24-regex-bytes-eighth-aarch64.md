# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391514216 |
| Date | 2026-11-24 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache and the CPU features it detected at start, as Rust's regex detects them, `stdx, no skip` the same with claims R1 to R5 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. Each round times the other candidates from one place later than the round before, so none of them takes one place in every round. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

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
| literal: a word | 217 | 19158.16 ± 3.9% | 5036.90 ± 0.2% | 27.70 ± 0.2% | 18347.54 ± 3.8% | 9236.86 ± 9.5% | 17.57 ± 0.2% | 84.37 ± 0.4% | 19249.59 ± 6.2% | 3.80 | 1.00 | 1.04 | 2.07 |
| literal: a word that is not there | 0 | 21125.94 ± 3.5% | 4921.81 ± 0.3% | 27.84 ± 0.1% | 19101.00 ± 4.1% | 27292.51 ± 4.1% | 17.38 ± 0.2% | 79.74 ± 0.5% | 20838.65 ± 2.1% | 4.29 | 1.01 | 1.11 | 0.77 |
| literal: one of four words | 661 | 6351.20 ± 0.3% | 1950.72 ± 0.1% | 14.20 ± 0.2% | 3949.19 ± 0.1% | 21.89 ± 0.1% | 5.32 ± 0.1% | 6.85 ± 0.3% | 6368.51 ± 0.6% | 3.26 | 1.00 | 1.61 | 290.18 |
| literal: a word in any case | 217 | 14993.82 ± 0.7% | 2089.88 ± 0.2% | 21.10 ± 0.1% | 3968.09 ± 0.3% | 38.29 ± 2.4% | refused | differs | 14981.73 ± 1.7% | 7.17 | 1.00 | 3.78 | 391.57 |
| literal: an href attribute | 33 | 16660.93 ± 1.4% | 609.85 ± 0.3% | 26.58 ± 0.3% | 16776.00 ± 1.3% | 2263.84 ± 0.3% | 13.41 ± 0.6% | 74.10 ± 0.5% | 16785.65 ± 0.8% | 27.32 | 0.99 | 0.99 | 7.36 |
| literal: a word, second text | 123 | 19853.13 ± 2.4% | 3389.21 ± 0.3% | 27.27 ± 0.2% | 18213.30 ± 5.4% | 7600.89 ± 12.3% | 19.77 ± 0.2% | 70.16 ± 0.6% | 19618.95 ± 2.4% | 5.86 | 1.01 | 1.09 | 2.61 |
| class: two capitalized words | 1331 | 1069.50 ± 0.3% | 598.62 ± 0.2% | 25.39 ± 0.1% | 585.47 ± 0.1% | 40.68 ± 6.2% | 14.94 ± 0.2% | 67.44 ± 0.5% | 1072.60 ± 0.3% | 1.79 | 1.00 | 1.83 | 26.29 |
| class: a word that ends in ing | 3399 | 573.37 ± 0.2% | 573.51 ± 0.4% | 17.72 ± 0.3% | 547.76 ± 0.1% | 29.64 ± 4.7% | 8.26 ± 0.4% | 18.42 ± 0.5% | 573.97 ± 0.0% | 1.00 | 1.00 | 1.05 | 19.34 |
| class: a word in capitals | 2332 | 1377.19 ± 0.5% | 604.21 ± 0.7% | 26.86 ± 0.7% | 572.51 ± 0.3% | 43.60 ± 6.3% | 17.31 ± 0.3% | 82.69 ± 0.2% | 1380.56 ± 0.2% | 2.28 | 1.00 | 2.41 | 31.59 |
| class: a number | 8288 | 1998.34 ± 0.2% | 829.36 ± 0.1% | 27.09 ± 0.3% | 1732.03 ± 0.2% | 43.11 ± 7.5% | 0.57 ± 0.2% | 57.56 ± 0.4% | 2000.37 ± 0.2% | 2.41 | 1.00 | 1.15 | 46.36 |
| class: two capitalized words, second text | 5359 | 515.93 ± 0.1% | 523.49 ± 0.1% | 22.77 ± 0.1% | 485.16 ± 0.1% | 34.39 ± 13.0% | 16.73 ± 0.2% | 62.82 ± 0.4% | 516.15 ± 0.2% | 0.99 | 1.00 | 1.06 | 15.00 |
| other: a word between two words | 6104 | 793.28 ± 0.5% | 592.56 ± 0.2% | 23.10 ± 0.4% | 734.74 ± 0.2% | 109.70 ± 15.2% | 11.35 ± 0.1% | 68.33 ± 0.3% | 793.65 ± 0.3% | 1.34 | 1.00 | 1.08 | 7.23 |
| other: a number before a unit, second text | 1481 | 5937.02 ± 1.2% | 1120.71 ± 0.2% | 25.46 ± 0.2% | 5632.82 ± 0.3% | 40.80 ± 9.1% | 17.86 ± 0.1% | 65.83 ± 0.4% | 5919.93 ± 1.0% | 5.30 | 1.00 | 1.05 | 145.52 |
| other: a heading's start tag | 110 | 13911.23 ± 0.8% | 742.99 ± 0.2% | 26.78 ± 0.2% | 1713.24 ± 0.5% | 1572.53 ± 4.0% | 16.40 ± 0.4% | 86.11 ± 1.8% | 14003.60 ± 1.4% | 18.72 | 0.99 | 8.12 | 8.85 |
| other: a whole word | 217 | 15687.50 ± 0.8% | 604.13 ± 0.2% | 28.64 ± 0.5% | 14354.85 ± 1.9% | 49.43 ± 0.1% | 13.84 ± 0.2% | 54.99 ± 0.3% | 15831.80 ± 1.3% | 25.97 | 0.99 | 1.09 | 317.38 |
| other: a line's first word, second text | 3716 | 2037.22 ± 0.7% | 587.49 ± 0.2% | 29.94 ± 0.1% | 1723.48 ± 0.3% | 63.81 ± 7.1% | refused | refused | 2044.41 ± 0.4% | 3.47 | 1.00 | 1.18 | 31.93 |
| other: fourteen octets before an x | 87 | 23326.16 ± 3.7% | 245.24 ± 0.3% | 6.28 ± 0.1% | 4013.37 ± 1.3% | 10.63 ± 0.2% | differs | 17.77 ± 0.2% | 23229.16 ± 10.0% | 95.12 | 1.00 | 5.81 | 2193.64 |
| other: a Greek word | 21815 | 497.69 ± 0.4% | 412.85 ± 0.2% | 30.33 ± 0.5% | 290.08 ± 0.2% | 49.30 ± 7.2% | differs | refused | 500.27 ± 0.3% | 1.21 | 0.99 | 1.72 | 10.09 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.59 ± 0.2% | 19.54 ± 0.2% | 0.85 ± 0.3% | 19.70 ± 0.4% | 2.76 ± 0.3% | differs | 4.06 ± 0.2% | 19.54 ± 0.2% | 1.00 | 1.00 | 0.99 | 7.11 |
| a UUID | 32895 | 21.10 ± 0.2% | 21.08 ± 0.2% | 0.64 ± 0.1% | 15.10 ± 0.4% | 3.09 ± 0.8% | 0.72 ± 0.3% | 3.64 ± 0.7% | 21.06 ± 0.1% | 1.00 | 1.00 | 1.40 | 6.84 |
| an IPv4 address | 33176 | 35.95 ± 0.2% | 35.95 ± 0.1% | 2.05 ± 0.2% | 28.83 ± 0.7% | 6.67 ± 0.2% | differs | 4.16 ± 0.2% | 35.91 ± 0.2% | 1.00 | 1.00 | 1.25 | 5.39 |
| a date and time | 32954 | 31.03 ± 0.4% | 31.01 ± 0.3% | 1.43 ± 0.3% | 21.16 ± 0.2% | 7.04 ± 0.3% | 1.20 ± 0.2% | 7.11 ± 0.5% | 31.01 ± 0.4% | 1.00 | 1.00 | 1.47 | 4.41 |
| a field path | 32606 | 23.17 ± 0.1% | 23.13 ± 0.3% | 1.01 ± 0.2% | 23.07 ± 0.4% | 3.50 ± 0.8% | differs | 2.98 ± 0.5% | 23.12 ± 0.2% | 1.00 | 1.00 | 1.00 | 6.63 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.15 ± 3.8% | 11.15 ± 0.6% | 11.17 ± 4.4% | 11.50 ± 0.1% | 5.03 ± 1.4% | 0.92 ± 0.4% | none | 11.15 ± 4.7% | 1.00 | 1.00 | 0.97 | 2.22 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 205.58 ± 0.6% | 208.31 ± 0.4% | 274.74 ± 0.6% | 87.54 ± 1.1% | 220.44 ± 8.2% | 487.98 ± 3.2% | 3779.97 ± 0.4% | 205.74 ± 0.3% | 0.99 | 1.00 | 2.35 | 0.93 |
| a UUID | 62 | 137.81 ± 0.3% | 139.26 ± 0.6% | 168.95 ± 0.4% | 46.28 ± 0.9% | 98.15 ± 1.4% | 188.39 ± 1.6% | 4162.75 ± 1.3% | 138.07 ± 0.1% | 0.99 | 1.00 | 2.98 | 1.40 |
| an IPv4 address | 29 | 344.24 ± 0.1% | 350.38 ± 0.2% | 593.80 ± 0.4% | 78.07 ± 0.1% | 131.09 ± 2.4% | 299.51 ± 1.1% | 7455.49 ± 0.4% | 344.00 ± 0.2% | 0.98 | 1.00 | 4.41 | 2.63 |
| a date and time | 56 | 260.59 ± 0.2% | 264.47 ± 0.1% | 381.69 ± 0.5% | 73.92 ± 0.1% | 136.13 ± 1.0% | 324.50 ± 1.0% | 4785.29 ± 0.9% | 260.61 ± 0.3% | 0.99 | 1.00 | 3.53 | 1.91 |
| a field path | 39 | 199.82 ± 0.6% | 201.63 ± 0.4% | 263.38 ± 0.4% | 79.82 ± 1.6% | 204.72 ± 1.3% | 505.31 ± 3.4% | 4847.17 ± 0.3% | 199.52 ± 0.2% | 0.99 | 1.00 | 2.50 | 0.98 |
| literal: a word | 7 | 473.80 ± 0.4% | 500.19 ± 0.5% | 1222.22 ± 0.1% | 510.03 ± 0.2% | 637.00 ± 5.4% | 935.65 ± 0.3% | 29596.31 ± 0.1% | 474.07 ± 0.5% | 0.95 | 1.00 | 0.93 | 0.74 |
| literal: a word that is not there | 8 | 460.74 ± 0.5% | 494.32 ± 0.4% | 1144.92 ± 0.6% | 463.69 ± 0.1% | 599.33 ± 2.2% | 887.58 ± 0.5% | 28650.51 ± 0.1% | 460.18 ± 0.5% | 0.93 | 1.00 | 0.99 | 0.77 |
| literal: one of four words | 26 | 213.29 ± 0.1% | 331.98 ± 0.1% | 541.83 ± 0.4% | 50.19 ± 0.3% | 241.63 ± 1.4% | 372.56 ± 0.5% | 15719.89 ± 0.3% | 213.36 ± 0.2% | 0.64 | 1.00 | 4.25 | 0.88 |
| literal: a word in any case | 11 | 362.97 ± 0.2% | 383.18 ± 0.3% | 708.15 ± 0.0% | 15.61 ± 0.2% | 648.89 ± 2.1% | refused | 23554.22 ± 0.2% | 362.79 ± 0.2% | 0.95 | 1.00 | 23.26 | 0.56 |
| literal: an href attribute | 12 | 286.91 ± 0.7% | 298.01 ± 0.2% | 465.66 ± 0.3% | 45.69 ± 0.3% | 497.37 ± 1.2% | 767.75 ± 0.6% | 21420.93 ± 0.5% | 287.71 ± 0.3% | 0.96 | 1.00 | 6.28 | 0.58 |
| literal: a word, second text | 10 | 433.43 ± 0.3% | 467.81 ± 0.5% | 1032.27 ± 0.8% | 398.47 ± 0.5% | 537.82 ± 4.1% | 796.29 ± 0.5% | 26568.28 ± 0.2% | 433.77 ± 0.4% | 0.93 | 1.00 | 1.09 | 0.81 |
| class: two capitalized words | 23 | 326.50 ± 0.5% | 373.80 ± 0.6% | 670.77 ± 0.8% | 101.09 ± 0.2% | 502.63 ± 1.3% | 740.58 ± 0.6% | 6433.67 ± 0.4% | 326.78 ± 0.5% | 0.87 | 1.00 | 3.23 | 0.65 |
| class: a word that ends in ing | 9 | 391.07 ± 0.3% | 474.36 ± 0.4% | 1089.71 ± 0.3% | 132.48 ± 0.5% | 755.88 ± 1.0% | 1100.87 ± 0.6% | 15842.44 ± 0.1% | 391.18 ± 0.5% | 0.82 | 1.00 | 2.95 | 0.52 |
| class: a word in capitals | 16 | 358.92 ± 0.2% | 424.38 ± 0.2% | 849.06 ± 0.1% | 136.32 ± 0.9% | 751.73 ± 0.9% | 1026.74 ± 2.0% | 8460.42 ± 0.3% | 359.72 ± 0.4% | 0.85 | 1.00 | 2.63 | 0.48 |
| class: a number | 6 | 426.33 ± 0.4% | 522.82 ± 0.1% | 1304.47 ± 0.1% | 41.82 ± 0.9% | 1400.42 ± 0.7% | 1935.50 ± 4.5% | 22413.65 ± 0.1% | 425.75 ± 0.4% | 0.82 | 1.00 | 10.19 | 0.30 |
| class: two capitalized words, second text | 23 | 326.85 ± 0.2% | 374.02 ± 0.2% | 671.96 ± 0.0% | 102.34 ± 1.9% | 501.82 ± 1.9% | 741.56 ± 0.9% | 6428.41 ± 0.2% | 326.19 ± 0.4% | 0.87 | 1.00 | 3.19 | 0.65 |
| other: a word between two words | 13 | 427.02 ± 0.1% | 440.04 ± 0.2% | 891.18 ± 0.3% | 133.23 ± 0.7% | 502.39 ± 1.6% | 798.24 ± 0.5% | 14465.80 ± 0.5% | 426.30 ± 0.3% | 0.97 | 1.00 | 3.21 | 0.85 |
| other: a number before a unit, second text | 15 | 303.89 ± 0.7% | 358.81 ± 0.2% | 611.75 ± 0.4% | 39.45 ± 0.7% | 638.30 ± 0.8% | 881.06 ± 0.7% | 15068.78 ± 0.4% | 304.88 ± 0.4% | 0.85 | 1.00 | 7.70 | 0.48 |
| other: a heading's start tag | 13 | 298.20 ± 0.3% | 304.85 ± 0.4% | 474.92 ± 0.6% | 44.26 ± 0.6% | 628.64 ± 1.9% | 871.56 ± 0.5% | 17771.95 ± 0.3% | 298.78 ± 0.4% | 0.98 | 1.00 | 6.74 | 0.47 |
| other: a whole word | 11 | 445.74 ± 0.4% | 469.56 ± 0.4% | 1037.98 ± 0.5% | 119.65 ± 0.7% | 563.33 ± 1.4% | 829.78 ± 0.7% | 26860.22 ± 0.2% | 446.20 ± 0.2% | 0.95 | 1.00 | 3.73 | 0.79 |
| other: a line's first word, second text | 17 | 410.87 ± 0.7% | 428.48 ± 0.2% | 874.62 ± 0.5% | 128.67 ± 0.2% | 711.91 ± 1.7% | refused | refused | 411.36 ± 0.5% | 0.96 | 1.00 | 3.19 | 0.58 |
| other: fourteen octets before an x | 16 | 96.76 ± 0.4% | 136.57 ± 0.9% | 180.80 ± 1.0% | 15.20 ± 0.2% | 454.91 ± 3.7% | 410.79 ± 0.7% | 12670.92 ± 0.4% | 96.71 ± 0.8% | 0.71 | 1.00 | 6.37 | 0.21 |
| other: a Greek word | 8 | 345.51 ± 0.1% | 453.99 ± 0.3% | 998.89 ± 0.5% | 58.95 ± 1.3% | 1393.59 ± 2.0% | 1833.34 ± 0.3% | refused | 342.51 ± 0.2% | 0.76 | 1.01 | 5.86 | 0.25 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15395.49 ± 1.2% | not timed | not timed | 15906.18 ± 0.8% | 2099.66 ± 6.4% | not timed | not timed | 15400.98 ± 1.0% | | 1.00 | 0.97 | 7.33 |
| 01-literal/sherlock-casei-en | 522 | 11002.43 ± 3.6% | not timed | not timed | 3593.56 ± 0.2% | 32.55 ± 0.1% | not timed | not timed | 11021.04 ± 1.0% | | 1.00 | 3.06 | 338.00 |
| 01-literal/sherlock-ru | 724 | 17111.79 ± 0.9% | not timed | not timed | 17226.78 ± 0.5% | 1578.17 ± 10.9% | not timed | not timed | 17147.13 ± 0.4% | | 1.00 | 0.99 | 10.84 |
| 01-literal/sherlock-casei-ru | 746 | 6171.45 ± 0.3% | not timed | not timed | 3330.12 ± 0.1% | 30.90 ± 0.1% | not timed | not timed | 6178.70 ± 0.2% | | 1.00 | 1.85 | 199.72 |
| 01-literal/sherlock-zh | 30 | 19199.43 ± 0.7% | not timed | not timed | 18201.43 ± 2.6% | 2546.79 ± 16.1% | not timed | not timed | 19128.77 ± 1.0% | | 1.00 | 1.05 | 7.54 |
| 02-literal-alternate/sherlock-en | 714 | 6045.14 ± 0.7% | not timed | not timed | 3942.78 ± 0.2% | 16.59 ± 0.3% | not timed | not timed | 6047.67 ± 0.4% | | 1.00 | 1.53 | 364.38 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1979.44 ± 1.1% | not timed | not timed | 700.21 ± 0.2% | 11.12 ± 0.2% | not timed | not timed | 1983.66 ± 0.7% | | 1.00 | 2.83 | 178.03 |
| 02-literal-alternate/sherlock-ru | 899 | 5564.16 ± 0.0% | not timed | not timed | 3259.35 ± 0.1% | 22.61 ± 0.3% | not timed | not timed | 5567.20 ± 0.2% | | 1.00 | 1.71 | 246.05 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2056.63 ± 0.6% | not timed | not timed | 1234.53 ± 0.1% | 9.11 ± 0.2% | not timed | not timed | 2059.78 ± 0.4% | | 1.00 | 1.67 | 225.80 |
| 02-literal-alternate/sherlock-zh | 207 | 7292.62 ± 0.5% | not timed | not timed | 4161.40 ± 0.2% | 31.52 ± 0.2% | not timed | not timed | 7306.57 ± 0.2% | | 1.00 | 1.75 | 231.36 |
| 03-date/ascii | 111817 | 124.52 ± 0.7% | not timed | not timed | 95.76 ± 0.2% | 0.20 ± 3.7% | not timed | not timed | 124.77 ± 0.6% | | 1.00 | 1.30 | 614.85 |
| 04-ruff-noqa/real | 84 | 403.93 ± 0.1% | not timed | not timed | 465.06 ± 0.0% | 19.51 ± 2.0% | not timed | not timed | 404.45 ± 0.2% | | 1.00 | 0.87 | 20.70 |
| 04-ruff-noqa/tweaked | 44 | 558.40 ± 0.7% | not timed | not timed | 458.69 ± 0.0% | 365.49 ± 0.2% | not timed | not timed | 557.86 ± 0.4% | | 1.00 | 1.22 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.32 ± 3.0% | not timed | not timed | 5.02 ± 0.4% | 0.21 ± 4.0% | not timed | not timed | 5.31 ± 0.6% | | 1.00 | 1.06 | 25.88 |
| 06-cloud-flare-redos/original | 107 | 414.72 ± 0.5% | not timed | not timed | 217.29 ± 0.2% | 24.49 ± 4.5% | not timed | not timed | 414.93 ± 16.6% | | 1.00 | 1.91 | 16.93 |
| 06-cloud-flare-redos/simplified-short | 102 | 416.16 ± 0.5% | not timed | not timed | 228.29 ± 0.2% | 26.70 ± 1.8% | not timed | not timed | 410.13 ± 0.4% | | 1.01 | 1.82 | 15.58 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.01 ± 0.8% | not timed | not timed | 253.71 ± 0.3% | 28.81 ± 0.1% | not timed | not timed | 578.45 ± 0.1% | | 1.02 | 2.32 | 20.41 |
| 07-unicode-character-data/parse-line | 558784 | 242.35 ± 0.5% | not timed | not timed | 173.02 ± 0.2% | 43.08 ± 0.4% | not timed | not timed | 243.09 ± 0.6% | | 1.00 | 1.40 | 5.63 |
| 08-words/all-english | 56691 | 116.66 ± 0.4% | not timed | not timed | 82.35 ± 0.2% | 11.67 ± 4.9% | not timed | not timed | 116.48 ± 0.2% | | 1.00 | 1.42 | 10.00 |
| 08-words/long-english | 839 | 612.66 ± 0.5% | not timed | not timed | 597.51 ± 0.1% | 32.59 ± 0.6% | not timed | not timed | 613.99 ± 0.4% | | 1.00 | 1.03 | 18.80 |
| 09-aws-keys/full | 0 | 409.08 ± 0.2% | not timed | not timed | 463.38 ± 0.1% | 64.50 ± 0.7% | not timed | not timed | 410.26 ± 0.2% | | 1.00 | 0.88 | 6.34 |
| 09-aws-keys/quick | 0 | 873.99 ± 0.2% | not timed | not timed | 984.56 ± 0.3% | 418.62 ± 0.5% | not timed | not timed | 874.61 ± 0.2% | | 1.00 | 0.89 | 2.09 |
| 10-bounded-repeat/letters-en | 1833 | 586.26 ± 2.9% | not timed | not timed | 516.54 ± 0.5% | 19.50 ± 0.7% | not timed | not timed | 579.19 ± 2.5% | | 1.01 | 1.13 | 30.06 |
| 10-bounded-repeat/letters-ru | 3475 | 510.19 ± 1.5% | not timed | not timed | 478.37 ± 0.1% | 22.07 ± 16.0% | not timed | not timed | 512.34 ± 2.5% | | 1.00 | 1.07 | 23.12 |
| 10-bounded-repeat/context | 53 | 85.22 ± 1.6% | not timed | not timed | 65.59 ± 0.4% | 19.84 ± 0.1% | not timed | not timed | 85.11 ± 1.3% | | 1.00 | 1.30 | 4.30 |
| 10-bounded-repeat/capitals | 11 | 641.65 ± 8.0% | not timed | not timed | 618.65 ± 0.0% | 36.32 ± 0.1% | not timed | not timed | 641.40 ± 8.1% | | 1.00 | 1.04 | 17.67 |
| 11-unstructured-to-json/extract | 600 | 56.92 ± 0.1% | not timed | not timed | 77.06 ± 0.4% | 49.00 ± 0.4% | not timed | not timed | 56.95 ± 0.1% | | 1.00 | 0.74 | 1.16 |
| 12-dictionary/single | 1 | 566.42 ± 0.6% | not timed | not timed | 555.28 ± 0.4% | 0.41 ± 0.1% | not timed | not timed | 568.99 ± 0.2% | | 1.00 | 1.02 | 1392.68 |
| 14-quadratic/1x | 100 | 21.24 ± 1.9% | not timed | not timed | 10.01 ± 0.2% | 0.97 ± 1.5% | not timed | not timed | 21.14 ± 1.3% | | 1.00 | 2.12 | 21.83 |
| 14-quadratic/2x | 200 | 17.41 ± 0.9% | not timed | not timed | 5.54 ± 0.4% | 0.53 ± 1.1% | not timed | not timed | 17.39 ± 0.7% | | 1.00 | 3.14 | 32.72 |
| 14-quadratic/10x | 1000 | 7.68 ± 0.5% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.4% | not timed | not timed | 7.69 ± 0.6% | | 1.00 | 6.37 | 66.53 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.22 ± 2.4% | not timed | not timed | 0.34 ± 0.7% | 0.55 ± 5.3% | not timed | not timed | 1.22 ± 1.0% | | 1.00 | 3.57 | 2.23 |
| 04-ruff-noqa/compile-real | 1 | 104.74 ± 1.3% | not timed | not timed | 13.81 ± 0.3% | 140.18 ± 2.6% | not timed | not timed | 105.12 ± 1.1% | | 1.00 | 7.59 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 13.90 ± 1.7% | not timed | not timed | 2.52 ± 0.6% | 6.48 ± 1.3% | not timed | not timed | 14.04 ± 1.0% | | 0.99 | 5.51 | 2.15 |
| 07-unicode-character-data/compile | 1 | 107.05 ± 0.3% | not timed | not timed | 25.71 ± 0.4% | 35.99 ± 3.6% | not timed | not timed | 107.34 ± 1.0% | | 1.00 | 4.16 | 2.97 |
| 09-aws-keys/compile-full | 1 | 52.83 ± 0.5% | not timed | not timed | 8.29 ± 0.6% | 23.40 ± 0.6% | not timed | not timed | 52.98 ± 0.3% | | 1.00 | 6.38 | 2.26 |
| 09-aws-keys/compile-quick | 1 | 181.75 ± 1.0% | not timed | not timed | 46.41 ± 0.4% | 134.72 ± 1.9% | not timed | not timed | 181.76 ± 0.2% | | 1.00 | 3.92 | 1.35 |
| 10-bounded-repeat/compile-context | 1 | 71.31 ± 0.9% | not timed | not timed | 11.21 ± 0.1% | 16.07 ± 2.6% | not timed | not timed | 71.61 ± 0.6% | | 1.00 | 6.36 | 4.44 |
| 10-bounded-repeat/compile-capitals | 1 | 83.99 ± 1.4% | not timed | not timed | 8.02 ± 0.7% | 23.70 ± 1.5% | not timed | not timed | 83.84 ± 0.8% | | 1.00 | 10.48 | 3.54 |
| 11-unstructured-to-json/compile | 1 | 168.31 ± 1.0% | not timed | not timed | 41.12 ± 0.4% | 68.39 ± 2.3% | not timed | not timed | 169.64 ± 0.8% | | 0.99 | 4.09 | 2.46 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.4% | not timed | not timed | 0.07 ± 31.0% | 0.09 ± 13.9% | not timed | not timed | 0.35 ± 1.4% | | 1.00 | 5.11 | 3.69 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.55 ± 0.4% | not timed | not timed | 6.48 ± 0.1% | 0.53 ± 20.8% | not timed | not timed | 7.55 ± 0.3% | | 1.00 | 1.16 | 14.20 |
| dictionary/search/english-10 | 690 | 1.05 ± 2.7% | not timed | not timed | 165.88 ± 0.6% | 0.00 ± 1.9% | not timed | not timed | 1.05 ± 0.3% | | 1.00 | 0.0063 | 414.27 |
| dictionary/search/english-15 | 15 | 560.12 ± 0.4% | not timed | not timed | 561.09 ± 0.1% | 0.36 ± 0.3% | not timed | not timed | 562.33 ± 0.7% | | 1.00 | 1.00 | 1539.29 |
| folly/awyer-inn-busted | 1 | 5587.54 ± 0.1% | not timed | not timed | 137.85 ± 0.3% | 44.04 ± 0.2% | not timed | not timed | 5575.72 ± 0.1% | | 1.00 | 40.53 | 126.87 |
| folly/literal-never-match-rare | 0 | 21145.18 ± 0.3% | not timed | not timed | 19925.91 ± 0.1% | 40988.97 ± 0.4% | not timed | not timed | 21155.07 ± 0.2% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12552.18 ± 1.5% | not timed | not timed | 19857.74 ± 0.2% | 2185.66 ± 0.9% | not timed | not timed | 12566.75 ± 1.2% | | 1.00 | 0.63 | 5.74 |
| folly/literal-never-match-tricksy | 1 | 3259.91 ± 0.4% | not timed | not timed | 4404.35 ± 0.3% | 3033.09 ± 9.3% | not timed | not timed | 3245.12 ± 0.5% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1312.37 ± 0.9% | not timed | not timed | 949.20 ± 0.1% | 380.53 ± 21.5% | not timed | not timed | 1313.06 ± 0.5% | | 1.00 | 1.38 | 3.45 |
| grep/long-words-ascii | 5073 | 459.80 ± 0.1% | not timed | not timed | 468.89 ± 0.1% | 46.29 ± 6.8% | not timed | not timed | 436.89 ± 0.7% | | 1.05 | 0.98 | 9.93 |
| imported/leipzig/twain | 811 | 20596.25 ± 90.5% | not timed | not timed | 19604.56 ± 65.5% | 11151.89 ± 51.7% | not timed | not timed | 20681.59 ± 123.1% | | 1.00 | 1.05 | 1.85 |
| imported/leipzig/twain-insensitive | 965 | 9037.18 ± 0.9% | not timed | not timed | 4249.08 ± 0.1% | 37.56 ± 0.3% | not timed | not timed | 9096.75 ± 1.0% | | 0.99 | 2.13 | 240.61 |
| imported/leipzig/shing | 1540 | 629.47 ± 0.2% | not timed | not timed | 13229.68 ± 2.3% | 34.03 ± 0.5% | not timed | not timed | 632.23 ± 0.2% | | 1.00 | 0.0476 | 18.50 |
| imported/leipzig/huck-saw | 262 | 8218.91 ± 2.9% | not timed | not timed | 5599.65 ± 0.2% | 31.86 ± 0.2% | not timed | not timed | 8463.03 ± 3.5% | | 0.97 | 1.47 | 257.98 |
| imported/leipzig/word-ending-nn | 262 | 608.66 ± 0.3% | not timed | not timed | 617.85 ± 0.1% | 24.47 ± 1.2% | not timed | not timed | 611.39 ± 0.4% | | 1.00 | 0.99 | 24.88 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11075.15 ± 0.8% | not timed | not timed | 4522.65 ± 0.3% | 11.52 ± 0.1% | not timed | not timed | 11089.37 ± 1.2% | | 1.00 | 2.45 | 961.68 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7757.17 ± 2.7% | not timed | not timed | 5490.24 ± 0.1% | 16.87 ± 0.1% | not timed | not timed | 7924.83 ± 3.2% | | 0.98 | 1.41 | 459.90 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4188.43 ± 1.2% | not timed | not timed | 416.84 ± 2.3% | 11.11 ± 0.0% | not timed | not timed | 4220.72 ± 1.1% | | 0.99 | 10.05 | 376.88 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 608.56 ± 0.5% | not timed | not timed | 615.25 ± 0.0% | 11.14 ± 0.1% | not timed | not timed | 609.67 ± 0.4% | | 1.00 | 0.99 | 54.63 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.33 ± 0.1% | not timed | not timed | 615.62 ± 0.1% | 9.73 ± 0.2% | not timed | not timed | 610.22 ± 0.1% | | 1.00 | 0.99 | 62.64 |
| imported/leipzig/tom-river | 2 | 6518.18 ± 1.9% | not timed | not timed | 5146.48 ± 0.1% | 31.03 ± 0.0% | not timed | not timed | 6623.22 ± 2.1% | | 0.98 | 1.27 | 210.05 |
| imported/leipzig/ing | 78424 | 608.79 ± 0.7% | not timed | not timed | 571.25 ± 0.2% | 28.13 ± 4.1% | not timed | not timed | 607.82 ± 0.7% | | 1.00 | 1.07 | 21.65 |
| imported/leipzig/ing-whitespace | 55248 | 758.72 ± 0.8% | not timed | not timed | 2079.58 ± 0.5% | 20.57 ± 2.8% | not timed | not timed | 758.75 ± 0.4% | | 1.00 | 0.36 | 36.88 |
| imported/leipzig/awyer-inn | 209 | 774.29 ± 1.5% | not timed | not timed | 4268.59 ± 0.5% | 22.71 ± 0.0% | not timed | not timed | 775.42 ± 1.3% | | 1.00 | 0.18 | 34.10 |
| imported/leipzig/quotes-bounded | 8886 | 2126.12 ± 0.4% | not timed | not timed | 3003.88 ± 0.5% | 38.27 ± 0.1% | not timed | not timed | 2123.37 ± 0.8% | | 1.00 | 0.71 | 55.55 |
| imported/leipzig/non-ascii-alternate | 2 | 12809.05 ± 2.8% | not timed | not timed | 5670.34 ± 0.2% | 50.92 ± 0.1% | not timed | not timed | 13081.96 ± 3.0% | | 0.98 | 2.26 | 251.57 |
| imported/leipzig/math-symbols | 69 | 1967.89 ± 0.6% | not timed | not timed | 619.24 ± 0.1% | 36.55 ± 0.2% | not timed | not timed | 1969.32 ± 0.3% | | 1.00 | 3.18 | 53.85 |
| imported/leipzig/bounded-strings-ending-z | 0 | 596.42 ± 0.7% | not timed | not timed | 616.50 ± 0.1% | 22.52 ± 0.1% | not timed | not timed | 594.88 ± 0.7% | | 1.00 | 0.97 | 26.49 |
| imported/lh3lh3-reb/uri | 17549 | 632.04 ± 0.1% | not timed | not timed | 1065.15 ± 0.2% | 28.07 ± 2.5% | not timed | not timed | 633.10 ± 0.3% | | 1.00 | 0.59 | 22.52 |
| imported/lh3lh3-reb/email | 15057 | 668.63 ± 0.1% | not timed | not timed | 1163.21 ± 0.2% | 30.66 ± 2.6% | not timed | not timed | 668.79 ± 0.1% | | 1.00 | 0.57 | 21.81 |
| imported/lh3lh3-reb/date | 668 | 865.78 ± 0.1% | not timed | not timed | 1037.78 ± 0.3% | 50.92 ± 4.3% | not timed | not timed | 865.25 ± 0.2% | | 1.00 | 0.83 | 17.00 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 642.30 ± 0.1% | not timed | not timed | 422.36 ± 0.1% | 15.72 ± 1.6% | not timed | not timed | 643.43 ± 0.0% | | 1.00 | 1.52 | 40.86 |
| imported/mariomka/email | 92 | 705.87 ± 0.3% | not timed | not timed | 29662.71 ± 1.3% | 32.83 ± 0.1% | not timed | not timed | 706.74 ± 0.1% | | 1.00 | 0.0238 | 21.50 |
| imported/mariomka/uri | 5301 | 608.93 ± 0.2% | not timed | not timed | 6077.40 ± 0.4% | 32.79 ± 0.4% | not timed | not timed | 606.38 ± 0.1% | | 1.00 | 0.10 | 18.57 |
| imported/mariomka/ip | 5 | 2156.42 ± 2.2% | not timed | not timed | 2971.71 ± 0.1% | 21.04 ± 0.3% | not timed | not timed | 2153.42 ± 2.5% | | 1.00 | 0.73 | 102.47 |
| imported/rsc/no-exponential | 0 | 567.50 ± 0.1% | not timed | not timed | 321.67 ± 0.2% | 23.86 ± 0.2% | not timed | not timed | 568.90 ± 0.1% | | 1.00 | 1.76 | 23.79 |
| imported/rsc/literal | 1 | 739.75 ± 7.7% | not timed | not timed | 1630.81 ± 8.4% | 191.47 ± 20.2% | not timed | not timed | 738.95 ± 6.7% | | 1.00 | 0.45 | 3.86 |
| imported/rsc/not-literal | 2 | 705.09 ± 1.4% | not timed | not timed | 732.21 ± 0.3% | 46.35 ± 8.9% | not timed | not timed | 697.22 ± 0.4% | | 1.01 | 0.96 | 15.21 |
| imported/rsc/match-class | 1 | 1303.73 ± 0.4% | not timed | not timed | 1619.21 ± 0.4% | 58.78 ± 6.9% | not timed | not timed | 1307.69 ± 1.9% | | 1.00 | 0.81 | 22.18 |
| imported/rsc/match-class-in-range | 1 | 1309.99 ± 8.5% | not timed | not timed | 2254.91 ± 7.1% | 59.97 ± 1.1% | not timed | not timed | 1313.03 ± 0.2% | | 1.00 | 0.58 | 21.85 |
| imported/rsc/match-class-unicode | 1 | 524.99 ± 3.6% | not timed | not timed | 501.70 ± 0.1% | 72.78 ± 5.7% | not timed | not timed | 525.21 ± 0.1% | | 1.00 | 1.05 | 7.21 |
| imported/rsc/anchored-literal-short-non-match | 0 | 535.01 ± 0.3% | not timed | not timed | 947.26 ± 0.1% | 227.49 ± 0.6% | not timed | not timed | 534.41 ± 0.2% | | 1.00 | 0.56 | 2.35 |
| imported/rsc/anchored-literal-long-non-match | 0 | 7947.36 ± 0.3% | not timed | not timed | 14320.65 ± 0.1% | 3415.25 ± 0.7% | not timed | not timed | 7941.71 ± 0.4% | | 1.00 | 0.55 | 2.33 |
| imported/rsc/anchored-literal-short-match | 4 | 417.25 ± 1.9% | not timed | not timed | 484.97 ± 0.2% | 82.77 ± 6.2% | not timed | not timed | 420.67 ± 2.3% | | 0.99 | 0.86 | 5.04 |
| imported/rsc/anchored-literal-long-match | 4 | 3027.16 ± 0.7% | not timed | not timed | 7216.77 ± 0.3% | 1237.38 ± 7.0% | not timed | not timed | 3029.44 ± 0.7% | | 1.00 | 0.42 | 2.45 |
| imported/rsc/one-pass-short | 17 | 312.44 ± 9.0% | not timed | not timed | 215.16 ± 0.6% | 31.21 ± 12.1% | not timed | not timed | 313.04 ± 2.5% | | 1.00 | 1.45 | 10.01 |
| imported/rsc/one-pass-short-not | 17 | 219.81 ± 2.9% | not timed | not timed | 222.72 ± 0.1% | 29.67 ± 9.6% | not timed | not timed | 220.41 ± 1.2% | | 1.00 | 0.99 | 7.41 |
| imported/rsc/one-pass-long-prefix | 26 | 235.39 ± 2.7% | not timed | not timed | 281.90 ± 0.1% | 106.30 ± 19.1% | not timed | not timed | 238.81 ± 9.3% | | 0.99 | 0.83 | 2.21 |
| imported/rsc/one-pass-long-prefix-not | 26 | 314.46 ± 1.6% | not timed | not timed | 282.09 ± 0.4% | 64.29 ± 20.1% | not timed | not timed | 313.18 ± 1.8% | | 1.00 | 1.11 | 4.89 |
| imported/rsc/long-needle1 | 31 | 21965.76 ± 0.2% | not timed | not timed | 20147.15 ± 0.1% | 3.75 ± 0.2% | not timed | not timed | 21979.76 ± 0.1% | | 1.00 | 1.09 | 5854.63 |
| imported/rsc/long-needle2 | 31 | 22121.54 ± 0.2% | not timed | not timed | 216.74 ± 0.2% | 3.76 ± 0.1% | not timed | not timed | 22119.45 ± 0.1% | | 1.00 | 102.06 | 5890.24 |
| imported/rsc/easy0-32 | 26 | 1051.71 ± 2.9% | not timed | not timed | 1620.33 ± 4.7% | 147.60 ± 18.6% | not timed | not timed | 1050.72 ± 2.9% | | 1.00 | 0.65 | 7.13 |
| imported/rsc/easy0-1k | 26 | 14978.31 ± 0.1% | not timed | not timed | 12478.94 ± 0.8% | 2310.06 ± 16.1% | not timed | not timed | 14989.94 ± 2.4% | | 1.00 | 1.20 | 6.48 |
| imported/rsc/easy0-32k | 26 | 22905.32 ± 0.4% | not timed | not timed | 20369.19 ± 0.1% | 18726.73 ± 22.7% | not timed | not timed | 22924.58 ± 2.5% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21506.38 ± 1.7% | not timed | not timed | 19945.82 ± 0.9% | 36652.92 ± 4.9% | not timed | not timed | 21420.56 ± 2.1% | | 1.00 | 1.08 | 0.59 |
| imported/rsc/easy1-32 | 19 | 359.41 ± 1.8% | not timed | not timed | 636.94 ± 0.3% | 139.77 ± 18.0% | not timed | not timed | 360.75 ± 7.4% | | 1.00 | 0.56 | 2.57 |
| imported/rsc/easy1-1k | 19 | 583.75 ± 2.8% | not timed | not timed | 12793.24 ± 0.2% | 2499.04 ± 17.8% | not timed | not timed | 582.30 ± 0.2% | | 1.00 | 0.0456 | 0.23 |
| imported/rsc/easy1-32k | 19 | 603.57 ± 0.5% | not timed | not timed | 411578.62 ± 0.5% | 20540.60 ± 0.2% | not timed | not timed | 599.79 ± 0.4% | | 1.01 | 0.0015 | 0.0294 |
| imported/rsc/easy1-1mb | 19 | 604.84 ± 1.1% | not timed | not timed | 13004308.06 ± 0.1% | 35811.23 ± 4.0% | not timed | not timed | 598.95 ± 0.9% | | 1.01 | 0.0000 | 0.0169 |
| imported/rsc/medium-32 | 27 | 424.77 ± 1.9% | not timed | not timed | 639.69 ± 0.5% | 70.36 ± 12.6% | not timed | not timed | 425.32 ± 0.3% | | 1.00 | 0.66 | 6.04 |
| imported/rsc/medium-1k | 27 | 6760.26 ± 0.3% | not timed | not timed | 11399.86 ± 0.2% | 72.38 ± 0.1% | not timed | not timed | 6754.14 ± 0.1% | | 1.00 | 0.59 | 93.41 |
| imported/rsc/medium-32k | 27 | 21569.76 ± 0.2% | not timed | not timed | 354819.37 ± 0.6% | 48.60 ± 0.3% | not timed | not timed | 21439.55 ± 0.0% | | 1.01 | 0.0608 | 443.82 |
| imported/rsc/medium-1mb | 27 | 20179.46 ± 1.6% | not timed | not timed | 11308056.09 ± 0.9% | 48.51 ± 0.1% | not timed | not timed | 20412.60 ± 2.6% | | 0.99 | 0.0018 | 415.96 |
| imported/rsc/hard-32 | 58 | 255.47 ± 2.2% | not timed | not timed | 359.01 ± 0.1% | 49.69 ± 7.4% | not timed | not timed | 255.32 ± 0.2% | | 1.00 | 0.71 | 5.14 |
| imported/rsc/hard-1k | 27 | 575.99 ± 0.3% | not timed | not timed | 11607.36 ± 0.8% | 40.87 ± 0.1% | not timed | not timed | 574.24 ± 0.3% | | 1.00 | 0.0496 | 14.09 |
| imported/rsc/hard-32k | 27 | 600.31 ± 1.1% | not timed | not timed | 361167.69 ± 0.1% | 29.36 ± 0.0% | not timed | not timed | 597.96 ± 0.4% | | 1.00 | 0.0017 | 20.45 |
| imported/rsc/hard-1mb | 51 | 602.98 ± 0.7% | not timed | not timed | 7297981.50 ± 0.2% | 29.40 ± 0.1% | not timed | not timed | 598.24 ± 1.0% | | 1.01 | 0.0001 | 20.51 |
| imported/rsc/reallyhard0-32 | 58 | 254.21 ± 0.3% | not timed | not timed | 222.31 ± 0.1% | 49.76 ± 7.0% | not timed | not timed | 255.54 ± 2.7% | | 0.99 | 1.14 | 5.11 |
| imported/rsc/reallyhard0-1k | 27 | 576.43 ± 0.3% | not timed | not timed | 585.06 ± 0.1% | 40.69 ± 0.2% | not timed | not timed | 578.25 ± 0.3% | | 1.00 | 0.99 | 14.16 |
| imported/rsc/reallyhard0-32k | 27 | 599.30 ± 0.4% | not timed | not timed | 618.69 ± 0.1% | 29.38 ± 0.2% | not timed | not timed | 602.46 ± 0.9% | | 0.99 | 0.97 | 20.40 |
| imported/rsc/reallyhard0-1mb | 51 | 586.41 ± 1.3% | not timed | not timed | 617.47 ± 0.3% | 29.43 ± 0.1% | not timed | not timed | 592.91 ± 1.1% | | 0.99 | 0.95 | 19.92 |
| imported/rsc/reallyreallyhard0-32 | 47 | 274.06 ± 0.1% | not timed | not timed | 192.63 ± 0.4% | 61.15 ± 19.0% | not timed | not timed | 274.35 ± 1.8% | | 1.00 | 1.42 | 4.48 |
| imported/rsc/reallyreallyhard0-1k | 16 | 855.98 ± 0.4% | not timed | not timed | 5920.84 ± 0.1% | 34.33 ± 0.1% | not timed | not timed | 853.18 ± 0.9% | | 1.00 | 0.14 | 24.93 |
| imported/rsc/reallyreallyhard0-32k | 16 | 638.42 ± 7.0% | not timed | not timed | 19268.34 ± 0.1% | 24.96 ± 1.0% | not timed | not timed | 620.19 ± 8.0% | | 1.03 | 0.0331 | 25.58 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 591.36 ± 0.6% | not timed | not timed | 19432.46 ± 2.4% | 24.99 ± 0.1% | not timed | not timed | 590.21 ± 0.6% | | 1.00 | 0.0304 | 23.67 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 269.27 ± 2.9% | not timed | not timed | 213.43 ± 0.4% | 60.66 ± 10.7% | not timed | not timed | 268.53 ± 0.0% | | 1.00 | 1.26 | 4.44 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 841.75 ± 0.8% | not timed | not timed | 6191.82 ± 0.1% | 34.15 ± 1.2% | not timed | not timed | 841.41 ± 0.8% | | 1.00 | 0.14 | 24.65 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 647.02 ± 6.7% | not timed | not timed | 19197.33 ± 0.1% | 24.95 ± 0.5% | not timed | not timed | 649.80 ± 7.8% | | 1.00 | 0.0337 | 25.93 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 592.59 ± 1.1% | not timed | not timed | 19046.49 ± 3.3% | 25.10 ± 0.4% | not timed | not timed | 591.71 ± 0.6% | | 1.00 | 0.0311 | 23.61 |
| imported/sherlock/name-sherlock | 776 | 19395.31 ± 2.5% | not timed | not timed | 18078.06 ± 1.3% | 8739.30 ± 21.4% | not timed | not timed | 19440.26 ± 2.2% | | 1.00 | 1.07 | 2.22 |
| imported/sherlock/name-holmes | 2766 | 14933.56 ± 4.6% | not timed | not timed | 15312.31 ± 1.0% | 3215.68 ± 7.6% | not timed | not timed | 15203.73 ± 5.4% | | 0.98 | 0.98 | 4.64 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19403.66 ± 2.0% | not timed | not timed | 18182.23 ± 0.8% | 8053.62 ± 32.8% | not timed | not timed | 19522.08 ± 0.5% | | 0.99 | 1.07 | 2.41 |
| imported/sherlock/name-sherlock-casei | 816 | 15568.88 ± 1.3% | not timed | not timed | 4020.77 ± 0.1% | 32.60 ± 0.5% | not timed | not timed | 15493.97 ± 1.0% | | 1.00 | 3.87 | 477.61 |
| imported/sherlock/name-holmes-casei | 2802 | 9383.77 ± 12.8% | not timed | not timed | 3313.28 ± 0.1% | 37.69 ± 2.2% | not timed | not timed | 9347.73 ± 1.9% | | 1.00 | 2.83 | 248.98 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12967.35 ± 3.6% | not timed | not timed | 3953.66 ± 0.1% | 32.58 ± 0.4% | not timed | not timed | 12962.92 ± 1.5% | | 1.00 | 3.28 | 398.02 |
| imported/sherlock/name-whitespace | 1461 | 14935.48 ± 4.7% | not timed | not timed | 14321.64 ± 0.5% | 7373.97 ± 37.6% | not timed | not timed | 14973.81 ± 0.3% | | 1.00 | 1.04 | 2.03 |
| imported/sherlock/name-alt1 | 1142 | 11416.33 ± 2.8% | not timed | not timed | 16064.82 ± 1.1% | 4134.59 ± 27.1% | not timed | not timed | 11449.81 ± 1.7% | | 1.00 | 0.71 | 2.76 |
| imported/sherlock/name-alt2 | 3542 | 8597.55 ± 0.2% | not timed | not timed | 3834.20 ± 0.2% | 31.33 ± 0.3% | not timed | not timed | 8614.15 ± 0.7% | | 1.00 | 2.24 | 274.38 |
| imported/sherlock/name-alt3 | 4507 | 5458.12 ± 0.2% | not timed | not timed | 3637.73 ± 0.1% | 9.89 ± 4.1% | not timed | not timed | 5460.50 ± 0.3% | | 1.00 | 1.50 | 551.70 |
| imported/sherlock/name-alt3-casei | 4593 | 1523.71 ± 2.5% | not timed | not timed | 285.84 ± 0.2% | 6.47 ± 0.1% | not timed | not timed | 1521.56 ± 1.4% | | 1.00 | 5.33 | 235.66 |
| imported/sherlock/name-alt4 | 3686 | 6199.07 ± 0.2% | not timed | not timed | 3795.97 ± 0.1% | 31.24 ± 0.3% | not timed | not timed | 6197.23 ± 0.2% | | 1.00 | 1.63 | 198.46 |
| imported/sherlock/name-alt4-casei | 4254 | 2768.73 ± 2.4% | not timed | not timed | 2599.94 ± 0.1% | 19.91 ± 0.1% | not timed | not timed | 2765.62 ± 1.0% | | 1.00 | 1.06 | 139.07 |
| imported/sherlock/name-alt5 | 4028 | 6237.98 ± 0.4% | not timed | not timed | 3750.49 ± 0.1% | 21.76 ± 0.1% | not timed | not timed | 6245.08 ± 0.4% | | 1.00 | 1.66 | 286.62 |
| imported/sherlock/name-alt5-casei | 4104 | 3453.35 ± 2.3% | not timed | not timed | 2220.63 ± 0.1% | 14.35 ± 0.1% | not timed | not timed | 3463.99 ± 0.9% | | 1.00 | 1.56 | 240.61 |
| imported/sherlock/no-match-uncommon | 0 | 21223.61 ± 0.9% | not timed | not timed | 19060.21 ± 1.4% | 34575.26 ± 0.6% | not timed | not timed | 21084.33 ± 0.3% | | 1.01 | 1.11 | 0.61 |
| imported/sherlock/no-match-common | 0 | 20916.39 ± 0.2% | not timed | not timed | 19017.17 ± 0.8% | 1282.05 ± 0.8% | not timed | not timed | 20912.51 ± 0.5% | | 1.00 | 1.10 | 16.31 |
| imported/sherlock/no-match-really-common | 0 | 16007.80 ± 2.4% | not timed | not timed | 18359.64 ± 1.7% | 1281.76 ± 1.2% | not timed | not timed | 15984.78 ± 2.3% | | 1.00 | 0.87 | 12.49 |
| imported/sherlock/the-lower | 21654 | 2323.09 ± 0.7% | not timed | not timed | 2342.65 ± 0.4% | 230.25 ± 17.3% | not timed | not timed | 2323.81 ± 1.3% | | 1.00 | 0.99 | 10.09 |
| imported/sherlock/the-upper | 2223 | 12615.75 ± 1.0% | not timed | not timed | 13423.29 ± 0.2% | 2736.35 ± 1.8% | not timed | not timed | 12669.34 ± 1.5% | | 1.00 | 0.94 | 4.61 |
| imported/sherlock/the-casei | 23961 | 2013.46 ± 1.0% | not timed | not timed | 1321.74 ± 0.2% | 34.92 ± 37.1% | not timed | not timed | 2017.72 ± 0.3% | | 1.00 | 1.52 | 57.66 |
| imported/sherlock/everything-greedy | 581881 | 270.28 ± 0.1% | not timed | not timed | 165.49 ± 0.0% | 28.96 ± 29.7% | not timed | not timed | 271.43 ± 0.8% | | 1.00 | 1.63 | 9.33 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.61 ± 0.1% | not timed | not timed | 212.17 ± 0.1% | 33.01 ± 0.1% | not timed | not timed | 463.67 ± 0.1% | | 1.00 | 2.18 | 14.01 |
| imported/sherlock/letters | 447175 | 54.44 ± 0.9% | not timed | not timed | 32.80 ± 0.1% | 5.87 ± 34.3% | not timed | not timed | 54.29 ± 1.0% | | 1.00 | 1.66 | 9.27 |
| imported/sherlock/letters-upper | 14180 | 433.46 ± 1.2% | not timed | not timed | 370.32 ± 0.1% | 29.84 ± 23.2% | not timed | not timed | 434.42 ± 0.1% | | 1.00 | 1.17 | 14.53 |
| imported/sherlock/letters-lower | 432995 | 55.32 ± 0.9% | not timed | not timed | 33.67 ± 0.1% | 5.36 ± 34.1% | not timed | not timed | 55.45 ± 1.0% | | 1.00 | 1.64 | 10.32 |
| imported/sherlock/words | 447639 | 107.20 ± 0.9% | not timed | not timed | 83.09 ± 0.2% | 15.39 ± 16.5% | not timed | not timed | 107.70 ± 0.5% | | 1.00 | 1.29 | 6.97 |
| imported/sherlock/before-holmes | 4073 | 599.50 ± 0.2% | not timed | not timed | 8482.47 ± 0.2% | 24.09 ± 1.1% | not timed | not timed | 597.51 ± 0.2% | | 1.00 | 0.0707 | 24.88 |
| imported/sherlock/before-after-holmes | 2593 | 598.26 ± 0.3% | not timed | not timed | 9489.07 ± 0.2% | 23.85 ± 2.4% | not timed | not timed | 599.00 ± 0.3% | | 1.00 | 0.0630 | 25.09 |
| imported/sherlock/holmes-cochar-watson | 150 | 5217.53 ± 0.2% | not timed | not timed | 3429.73 ± 0.1% | 31.11 ± 0.1% | not timed | not timed | 5236.22 ± 0.2% | | 1.00 | 1.52 | 167.74 |
| imported/sherlock/holmes-coword-watson | 14309 | 1261.87 ± 2.2% | not timed | not timed | 1127.20 ± 0.1% | 6.78 ± 0.1% | not timed | not timed | 1264.52 ± 0.3% | | 1.00 | 1.12 | 186.02 |
| imported/sherlock/quotes | 14437 | 1416.87 ± 0.2% | not timed | not timed | 1758.10 ± 1.0% | 35.08 ± 0.4% | not timed | not timed | 1414.54 ± 0.7% | | 1.00 | 0.81 | 40.39 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 602.34 ± 0.2% | not timed | not timed | 15802.68 ± 0.9% | 36.89 ± 0.1% | not timed | not timed | 602.69 ± 0.3% | | 1.00 | 0.0381 | 16.33 |
| imported/sherlock/word-ending-n | 35297 | 468.89 ± 0.2% | not timed | not timed | 409.44 ± 0.1% | 23.44 ± 17.0% | not timed | not timed | 468.03 ± 1.0% | | 1.00 | 1.15 | 20.00 |
| imported/sherlock/repeated-class-negation | 2130 | 14423.46 ± 1.0% | not timed | not timed | 10840.36 ± 0.6% | 11.58 ± 0.4% | not timed | not timed | 14424.73 ± 0.4% | | 1.00 | 1.33 | 1245.15 |
| imported/sherlock/ing-suffix | 20547 | 555.49 ± 1.0% | not timed | not timed | 516.62 ± 0.2% | 28.85 ± 20.6% | not timed | not timed | 554.97 ± 0.2% | | 1.00 | 1.08 | 19.25 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 595.87 ± 0.2% | not timed | not timed | 2106.26 ± 0.6% | 20.51 ± 0.3% | not timed | not timed | 594.85 ± 0.5% | | 1.00 | 0.28 | 29.05 |
| opt/accelerate/whole-line | 239963 | 459.50 ± 0.1% | not timed | not timed | 373.33 ± 0.3% | 92.54 ± 16.8% | not timed | not timed | 459.12 ± 0.4% | | 1.00 | 1.23 | 4.97 |
| opt/accelerate/non-dna | 16745 | 412.57 ± 6.7% | not timed | not timed | 400.85 ± 0.5% | 29.46 ± 22.6% | not timed | not timed | 412.38 ± 0.2% | | 1.00 | 1.03 | 14.01 |
| opt/backtrack/words-english | 40536 | 137.30 ± 1.8% | not timed | not timed | 94.70 ± 0.2% | 19.80 ± 6.4% | not timed | not timed | 134.80 ± 4.5% | | 1.02 | 1.45 | 6.93 |
| opt/fixed-length/too-small-ascii | 0 | 312.68 ± 0.2% | not timed | not timed | 686.33 ± 1.0% | 80.04 ± 0.4% | not timed | not timed | 310.28 ± 0.2% | | 1.01 | 0.46 | 3.91 |
| opt/fixed-length/too-big-ascii | 0 | 649.10 ± 0.2% | not timed | not timed | 5784.74 ± 0.2% | 126.58 ± 0.6% | not timed | not timed | 658.38 ± 0.3% | | 0.99 | 0.11 | 5.13 |
| opt/fixed-length/go33484-1 | 0 | 45.49 ± 0.1% | not timed | not timed | 1096838.35 ± 0.3% | 61433.49 ± 0.5% | not timed | not timed | 45.50 ± 0.2% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5536.40 ± 0.1% | not timed | not timed | 1103156.06 ± 0.5% | 32246.75 ± 1.7% | not timed | not timed | 5520.06 ± 0.1% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1832.97 ± 2.7% | not timed | not timed | 111279.38 ± 0.3% | 761.17 ± 0.5% | not timed | not timed | 1783.85 ± 0.2% | | 1.03 | 0.0165 | 2.41 |
| opt/literal-alt/one-pattern | 1 | 555.69 ± 0.3% | not timed | not timed | 543.47 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 555.91 ± 0.3% | | 1.00 | 1.02 | 1388.97 |
| opt/onepass/fn-predicate | 916 | 368.13 ± 0.9% | not timed | not timed | 330.84 ± 0.2% | 201.94 ± 12.7% | not timed | not timed | 371.74 ± 0.3% | | 0.99 | 1.11 | 1.82 |
| opt/onepass/first-three-words-english | 35128 | 148.65 ± 4.5% | not timed | not timed | 202.22 ± 0.1% | 78.31 ± 10.5% | not timed | not timed | 150.01 ± 1.3% | | 0.99 | 0.74 | 1.90 |
| opt/prefilter/literal-english | 1 | 20112.16 ± 0.6% | not timed | not timed | 19242.26 ± 0.6% | 17203.54 ± 0.8% | not timed | not timed | 20099.14 ± 0.4% | | 1.00 | 1.05 | 1.17 |
| opt/prefilter/literal-casei-english | 1 | 14337.09 ± 0.5% | not timed | not timed | 4321.39 ± 0.1% | 32.61 ± 0.1% | not timed | not timed | 14336.92 ± 0.3% | | 1.00 | 3.32 | 439.61 |
| opt/prefilter/literal-russian | 1 | 21249.53 ± 0.3% | not timed | not timed | 19818.43 ± 0.7% | 3325.16 ± 0.3% | not timed | not timed | 21263.24 ± 0.4% | | 1.00 | 1.07 | 6.39 |
| opt/prefilter/literal-casei-russian | 1 | 8598.88 ± 0.2% | not timed | not timed | 3897.30 ± 0.2% | 30.90 ± 0.4% | not timed | not timed | 8584.08 ± 0.3% | | 1.00 | 2.21 | 278.30 |
| opt/prefilter/rust-functions | 948 | 6830.92 ± 0.3% | not timed | not timed | 9002.14 ± 0.5% | 1877.07 ± 0.4% | not timed | not timed | 6822.93 ± 0.3% | | 1.00 | 0.76 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 5588.38 ± 0.2% | not timed | not timed | 21264961.93 ± 0.2% | 50.17 ± 0.2% | not timed | not timed | 5589.47 ± 0.2% | | 1.00 | 0.0003 | 111.39 |
| opt/reverse-inner/holmes | 2593 | 597.91 ± 0.2% | not timed | not timed | 9486.67 ± 0.6% | 24.12 ± 0.9% | not timed | not timed | 599.08 ± 0.2% | | 1.00 | 0.0630 | 24.79 |
| opt/reverse-inner/email | 47 | 1045.92 ± 0.3% | not timed | not timed | 44923.27 ± 0.4% | 32.26 ± 0.2% | not timed | not timed | 1044.71 ± 0.1% | | 1.00 | 0.0233 | 32.42 |
| opt/reverse-inner/factored-prefix | 3542 | 591.67 ± 0.6% | not timed | not timed | 596.88 ± 0.0% | 12.55 ± 0.3% | not timed | not timed | 592.61 ± 0.4% | | 1.00 | 0.99 | 47.14 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5511.08 ± 0.1% | not timed | not timed | 616.39 ± 0.1% | 75.08 ± 0.2% | not timed | not timed | 5522.82 ± 0.0% | | 1.00 | 8.94 | 73.40 |
| opt/reverse-inner/no-quadratic-forward | 0 | 687.70 ± 2.2% | not timed | not timed | 287.97 ± 0.1% | 24.85 ± 0.4% | not timed | not timed | 688.75 ± 6.2% | | 1.00 | 2.39 | 27.67 |
| opt/reverse-suffix/holmes | 4073 | 599.22 ± 0.4% | not timed | not timed | 8438.22 ± 0.2% | 23.76 ± 1.0% | not timed | not timed | 597.31 ± 0.2% | | 1.00 | 0.0710 | 25.21 |
| opt/reverse-suffix/no-quadratic | 0 | 5523.49 ± 0.1% | not timed | not timed | 615.28 ± 0.2% | 74.88 ± 0.1% | not timed | not timed | 5509.96 ± 0.0% | | 1.00 | 8.98 | 73.77 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.99 ± 2.0% | not timed | not timed | 132.60 ± 0.3% | 13.11 ± 15.1% | not timed | not timed | 120.92 ± 1.9% | | 1.00 | 0.91 | 9.23 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 121.02 ± 2.3% | not timed | not timed | 132.68 ± 0.1% | 12.99 ± 14.9% | not timed | not timed | 121.07 ± 1.3% | | 1.00 | 0.91 | 9.32 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.5% | not timed | not timed | 0.55 ± 0.3% | 110.11 ± 2.2% | not timed | not timed | 0.28 ± 0.2% | | 1.00 | 0.52 | 0.0026 |
| reported/i1095-word-repetition/ascii-search | 256 | 316.57 ± 3.1% | not timed | not timed | 294.38 ± 0.1% | 102.50 ± 7.5% | not timed | not timed | 309.67 ± 0.2% | | 1.02 | 1.08 | 3.09 |
| reported/i13-subset-regex/original-ascii | 4094 | 11062.51 ± 1.0% | not timed | not timed | 4524.11 ± 0.9% | 11.49 ± 0.1% | not timed | not timed | 11115.61 ± 1.5% | | 1.00 | 2.45 | 962.72 |
| reported/i13-subset-regex/original-unicode | 4094 | 10945.85 ± 1.3% | not timed | not timed | 252.35 ± 2.6% | 11.50 ± 0.2% | not timed | not timed | 11132.03 ± 1.8% | | 0.98 | 43.38 | 951.63 |
| reported/i13-subset-regex/big-ascii | 1955 | 10667.31 ± 1.8% | not timed | not timed | 68.28 ± 3.6% | 9.86 ± 0.2% | not timed | not timed | 10755.25 ± 1.0% | | 0.99 | 156.24 | 1082.33 |
| reported/i13-subset-regex/big-unicode | 1955 | 10593.28 ± 0.6% | not timed | not timed | 12.26 ± 54.9% | 9.85 ± 0.1% | not timed | not timed | 10694.82 ± 1.2% | | 0.99 | 863.96 | 1075.60 |
| reported/i13-subset-regex/huge-ascii | 55 | 10117.43 ± 1.2% | not timed | not timed | 11.03 ± 0.1% | 8.76 ± 0.1% | not timed | not timed | 10080.42 ± 1.1% | | 1.00 | 917.46 | 1155.20 |
| reported/i13-subset-regex/huge-unicode | 55 | 10084.25 ± 1.1% | not timed | not timed | 10.97 ± 0.4% | 8.76 ± 0.1% | not timed | not timed | 9899.90 ± 2.5% | | 1.02 | 918.99 | 1151.30 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.0% | not timed | not timed | 11.05 ± 0.1% | 8.70 ± 0.4% | not timed | not timed | 3.53 ± 0.0% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.0% | not timed | not timed | 10.98 ± 0.3% | 8.75 ± 1.1% | not timed | not timed | 5.02 ± 0.1% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 469.84 ± 0.3% | not timed | not timed | 104.95 ± 0.2% | 6.64 ± 0.1% | not timed | not timed | 470.25 ± 0.2% | | 1.00 | 4.48 | 70.75 |
| reported/i787-keywords/opt-ascii | 5674 | 471.00 ± 0.2% | not timed | not timed | 268.34 ± 0.2% | 10.26 ± 0.1% | not timed | not timed | 470.97 ± 0.2% | | 1.00 | 1.76 | 45.90 |
| slow/quadratic-regex-1x | 100 | 6.96 ± 0.4% | not timed | not timed | 4.93 ± 0.1% | 0.05 ± 0.2% | not timed | not timed | 6.95 ± 0.3% | | 1.00 | 1.41 | 141.57 |
| slow/quadratic-regex-2x | 199 | 3.40 ± 0.1% | not timed | not timed | 2.76 ± 0.1% | 0.01 ± 0.3% | not timed | not timed | 3.40 ± 0.1% | | 1.00 | 1.23 | 266.18 |
| slow/quadratic-haystack-1x | 100 | 21.04 ± 5.8% | not timed | not timed | 10.00 ± 0.3% | 1.02 ± 14.4% | not timed | not timed | 21.09 ± 1.2% | | 1.00 | 2.10 | 20.68 |
| slow/quadratic-haystack-2x | 200 | 17.48 ± 0.6% | not timed | not timed | 5.54 ± 0.3% | 0.55 ± 1.1% | not timed | not timed | 17.46 ± 11.8% | | 1.00 | 3.15 | 32.02 |
| unicode/codepoints/any-one | 1112064 | 285.48 ± 0.2% | not timed | not timed | 175.74 ± 0.1% | 18.64 ± 2.4% | not timed | not timed | 284.39 ± 0.2% | | 1.00 | 1.62 | 15.32 |
| unicode/codepoints/any-all | 4382592 | 289.24 ± 0.3% | not timed | not timed | 246.90 ± 0.2% | 117.39 ± 0.1% | not timed | not timed | 289.52 ± 0.3% | | 1.00 | 1.17 | 2.46 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.75 ± 0.5% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 610.83 ± 0.1% | not timed | not timed | 616.52 ± 0.3% | 134.35 ± 0.4% | not timed | not timed | 611.05 ± 0.3% | | 1.00 | 0.99 | 4.55 |
| unicode/overlapping-words/ascii | 6156 | 31.87 ± 0.3% | not timed | not timed | 38.24 ± 0.2% | 3.92 ± 1.3% | not timed | not timed | 31.95 ± 0.4% | | 1.00 | 0.83 | 8.14 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 0.3% | not timed | not timed | 4.46 ± 0.1% | 2.37 ± 0.7% | not timed | not timed | 1.36 ± 0.0% | | 1.00 | 0.30 | 0.57 |
| unicode/overlapping-words/russian | 5710 | 1.22 ± 9.6% | not timed | not timed | 3.87 ± 0.4% | 6.30 ± 9.3% | not timed | not timed | 1.22 ± 0.3% | | 1.00 | 0.32 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 116.36 ± 7.8% | not timed | not timed | 82.86 ± 0.2% | 11.74 ± 21.8% | not timed | not timed | 117.24 ± 1.1% | | 0.99 | 1.40 | 9.91 |
| unicode/word/boundary-long-english | 3466 | 605.10 ± 0.4% | not timed | not timed | 607.45 ± 0.1% | 32.46 ± 0.6% | not timed | not timed | 604.94 ± 0.5% | | 1.00 | 1.00 | 18.64 |
| unicode/word/around-holmes-english | 27 | 602.88 ± 0.4% | not timed | not timed | 19075.10 ± 0.3% | 22.30 ± 0.4% | not timed | not timed | 602.45 ± 0.3% | | 1.00 | 0.0316 | 27.03 |
| wild/bibleref/long | 874 | 564.55 ± 0.3% | not timed | not timed | 584.28 ± 0.1% | 6.77 ± 0.1% | not timed | not timed | 565.00 ± 0.2% | | 1.00 | 0.97 | 83.41 |
| wild/bibleref/short | 30 | 24.70 ± 2.2% | not timed | not timed | 30.56 ± 0.7% | 14.28 ± 12.2% | not timed | not timed | 24.73 ± 3.5% | | 1.00 | 0.81 | 1.73 |
| wild/bibleref/line | 874 | 359.37 ± 3.1% | not timed | not timed | 213.10 ± 0.3% | 9.20 ± 8.2% | not timed | not timed | 359.91 ± 0.2% | | 1.00 | 1.69 | 39.08 |
| wild/caddy/caddy | 6 | 418.42 ± 1.7% | not timed | not timed | 246.84 ± 0.1% | 68.57 ± 14.2% | not timed | not timed | 419.41 ± 0.3% | | 1.00 | 1.70 | 6.10 |
| wild/dot-star-capture/rust-src-tools | 6 | 1058.79 ± 0.3% | not timed | not timed | 347.87 ± 0.4% | 13.49 ± 0.2% | not timed | not timed | 1058.50 ± 0.3% | | 1.00 | 3.04 | 78.46 |
| wild/ruff/noqa | 84 | 404.63 ± 0.1% | not timed | not timed | 463.89 ± 0.2% | 19.61 ± 3.8% | not timed | not timed | 404.74 ± 0.1% | | 1.00 | 0.87 | 20.63 |
| wild/ruff/unnecessary-coding-comment | 16 | 489.90 ± 0.5% | not timed | not timed | 702.04 ± 0.1% | 135.42 ± 11.3% | not timed | not timed | 489.73 ± 0.7% | | 1.00 | 0.70 | 3.62 |
| wild/ruff/string-quote-prefix | 2972 | 408.57 ± 0.7% | not timed | not timed | 444.05 ± 0.2% | 318.59 ± 26.4% | not timed | not timed | 408.52 ± 0.5% | | 1.00 | 0.92 | 1.28 |
| wild/ruff/space-around-operator | 1224378 | 217.75 ± 1.8% | not timed | not timed | 186.94 ± 0.1% | 18.41 ± 1.8% | not timed | not timed | 218.14 ± 1.7% | | 1.00 | 1.16 | 11.83 |
| wild/ruff/shebang | 282 | 402.21 ± 0.5% | not timed | not timed | 328.24 ± 0.1% | 117.77 ± 8.9% | not timed | not timed | 402.17 ± 0.4% | | 1.00 | 1.23 | 3.42 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13861.13 ± 0.3% | not timed | not timed | 13860.45 ± 0.3% | 6951.27 ± 0.6% | not timed | not timed | 13867.05 ± 0.4% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12825.19 ± 0.2% | not timed | not timed | 13480.08 ± 0.4% | 6441.49 ± 0.8% | not timed | not timed | 12830.02 ± 0.5% | | 1.00 | 0.95 | 1.99 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13212.78 ± 0.8% | not timed | not timed | 13633.50 ± 0.5% | 6620.02 ± 1.0% | not timed | not timed | 13206.48 ± 0.4% | | 1.00 | 0.97 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9580.85 ± 0.3% | not timed | not timed | 13652.57 ± 0.5% | 6773.18 ± 1.4% | not timed | not timed | 9579.92 ± 0.1% | | 1.00 | 0.70 | 1.41 |
| wild/url/search | 234965 | 122.04 ± 14.2% | not timed | not timed | 65.47 ± 0.5% | 2.22 ± 0.8% | not timed | not timed | 122.02 ± 14.5% | | 1.00 | 1.86 | 55.00 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 40.9% | not timed | not timed | 0.01 ± 1.3% | 0.01 ± 18.9% | not timed | not timed | 0.03 ± 1.8% | | 0.99 | 3.08 | 4.05 |
| dictionary/compile/english-15 | 1 | 0.35 ± 23.7% | not timed | not timed | 0.07 ± 0.3% | 0.10 ± 13.7% | not timed | not timed | 0.35 ± 1.6% | | 0.99 | 5.00 | 3.37 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 16.2% | not timed | not timed | 0.02 ± 0.4% | 36.47 ± 6.9% | not timed | not timed | 0.25 ± 4.0% | | 1.01 | 13.16 | 0.0069 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.40 ± 16.3% | not timed | not timed | 11.56 ± 0.6% | 58.13 ± 18.3% | not timed | not timed | 46.81 ± 4.1% | | 0.99 | 4.01 | 0.80 |
| reported/i787-keywords/compile | 1 | 34.44 ± 2.9% | not timed | not timed | 2.11 ± 0.8% | 17.00 ± 24.6% | not timed | not timed | 34.55 ± 2.1% | | 1.00 | 16.31 | 2.03 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 343.03 ± 2.1% | not timed | not timed | 118.95 ± 0.2% | 577.37 ± 27.7% | not timed | not timed | 343.80 ± 6.3% | | 1.00 | 2.88 | 0.59 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.20 ± 1.7% | not timed | not timed | 4.11 ± 0.5% | 43.12 ± 15.0% | not timed | not timed | 47.84 ± 19.8% | | 0.99 | 11.49 | 1.09 |
| unicode/compile/one-letter | 53 | 6.70 ± 13.4% | not timed | not timed | 4.44 ± 0.8% | 66.49 ± 5.1% | not timed | not timed | 6.71 ± 2.6% | | 1.00 | 1.51 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.05 ± 14.0% | not timed | not timed | 0.10 ± 0.3% | 65.86 ± 8.6% | not timed | not timed | 1.07 ± 16.2% | | 0.98 | 10.55 | 0.0159 |
| unicode/compile/fifty-letters-ascii | 1 | 212.36 ± 2.5% | not timed | not timed | 52.68 ± 0.2% | 190.29 ± 16.3% | not timed | not timed | 215.09 ± 5.7% | | 0.99 | 4.03 | 1.12 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 375.68 ± 6.2% | not timed | not timed | 47.01 ± 0.2% | 681.96 ± 28.4% | not timed | not timed | 374.83 ± 17.1% | | 1.00 | 7.99 | 0.55 |
| unicode/compile/match-every-line-ascii | 4 | 573.47 ± 12.3% | not timed | not timed | 144.42 ± 0.2% | 639.85 ± 21.3% | not timed | not timed | 587.04 ± 5.2% | | 0.98 | 3.97 | 0.90 |
| unicode/compile/negated-class-matches-codepoint | 1 | 307.02 ± 5.0% | not timed | not timed | 49.25 ± 0.6% | 1282.83 ± 26.6% | not timed | not timed | 309.91 ± 1.8% | | 0.99 | 6.23 | 0.24 |
| wild/bibleref/compile | 3 | 5.86 ± 1.8% | not timed | not timed | 1.88 ± 0.5% | 31.23 ± 3.9% | not timed | not timed | 5.87 ± 2.0% | | 1.00 | 3.11 | 0.19 |
| wild/url/compile | 1 | 0.63 ± 16.5% | not timed | not timed | 0.14 ± 0.8% | 0.42 ± 19.3% | not timed | not timed | 0.63 ± 8.1% | | 0.99 | 4.33 | 1.51 |

