# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45895089065 |
| Date | 2026-11-26 |
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
| literal: a word | 217 | 19208.30 ± 6.0% | 10789.78 ± 0.9% | 28.33 ± 0.2% | 17886.00 ± 3.5% | 9264.83 ± 7.2% | 17.34 ± 0.5% | 86.59 ± 0.4% | 19175.76 ± 2.8% | 1.78 | 1.00 | 1.07 | 2.07 |
| literal: a word that is not there | 0 | 21356.03 ± 2.6% | 9882.81 ± 0.8% | 28.34 ± 0.8% | 19175.12 ± 2.6% | 27891.86 ± 2.5% | 17.13 ± 0.2% | 80.84 ± 0.5% | 21093.75 ± 3.5% | 2.16 | 1.01 | 1.11 | 0.77 |
| literal: one of four words | 661 | 6432.64 ± 0.3% | 1776.18 ± 0.5% | 14.33 ± 0.1% | 3948.00 ± 0.2% | 21.90 ± 0.1% | 5.43 ± 0.3% | 6.97 ± 0.3% | 6440.07 ± 0.4% | 3.62 | 1.00 | 1.63 | 293.72 |
| literal: a word in any case | 217 | 15049.14 ± 0.4% | 1912.95 ± 0.3% | 21.42 ± 0.1% | 3961.70 ± 0.4% | 38.04 ± 0.4% | refused | differs | 15062.43 ± 1.3% | 7.87 | 1.00 | 3.80 | 395.63 |
| literal: an href attribute | 33 | 16647.94 ± 1.5% | 607.32 ± 0.2% | 27.30 ± 0.2% | 16690.00 ± 2.4% | 2258.49 ± 0.6% | 13.13 ± 0.2% | 75.68 ± 0.2% | 16683.31 ± 0.4% | 27.41 | 1.00 | 1.00 | 7.37 |
| literal: a word, second text | 123 | 19002.36 ± 4.6% | 4574.88 ± 0.3% | 28.05 ± 0.1% | 17607.68 ± 1.5% | 7627.90 ± 6.3% | 20.08 ± 0.5% | 71.40 ± 0.4% | 18914.12 ± 2.1% | 4.15 | 1.00 | 1.08 | 2.49 |
| class: two capitalized words | 1331 | 1178.76 ± 0.4% | 598.39 ± 0.3% | 25.95 ± 0.3% | 586.16 ± 0.1% | 40.72 ± 0.1% | 14.80 ± 0.2% | 67.88 ± 0.3% | 1178.00 ± 0.3% | 1.97 | 1.00 | 2.01 | 28.95 |
| class: a word that ends in ing | 3399 | 575.01 ± 0.1% | 574.21 ± 0.2% | 17.75 ± 0.1% | 548.13 ± 0.1% | 29.48 ± 9.7% | 8.18 ± 0.1% | 18.42 ± 0.5% | 575.68 ± 0.1% | 1.00 | 1.00 | 1.05 | 19.51 |
| class: a word in capitals | 2332 | 1534.71 ± 0.2% | 608.13 ± 0.3% | 27.61 ± 0.4% | 572.64 ± 0.2% | 43.50 ± 2.4% | 17.15 ± 0.2% | 83.51 ± 0.3% | 1532.65 ± 0.3% | 2.52 | 1.00 | 2.68 | 35.28 |
| class: a number | 8288 | 2675.99 ± 0.9% | 839.69 ± 0.2% | 27.71 ± 0.3% | 1710.85 ± 0.2% | 42.23 ± 9.1% | 0.55 ± 0.2% | 57.38 ± 0.2% | 2673.16 ± 0.3% | 3.19 | 1.00 | 1.56 | 63.37 |
| class: two capitalized words, second text | 5359 | 522.12 ± 0.4% | 529.16 ± 0.4% | 23.16 ± 0.1% | 484.97 ± 0.2% | 35.31 ± 6.8% | 17.10 ± 0.2% | 63.30 ± 0.4% | 522.03 ± 0.2% | 0.99 | 1.00 | 1.08 | 14.79 |
| other: a word between two words | 6104 | 801.87 ± 0.1% | 602.49 ± 0.5% | 23.41 ± 0.1% | 738.38 ± 0.1% | 105.99 ± 9.9% | 11.21 ± 0.1% | 69.50 ± 0.8% | 814.89 ± 0.1% | 1.33 | 0.98 | 1.09 | 7.57 |
| other: a number before a unit, second text | 1481 | 6240.26 ± 0.9% | 1142.29 ± 0.1% | 25.93 ± 0.4% | 5579.30 ± 1.0% | 40.88 ± 10.0% | 18.06 ± 0.3% | 65.95 ± 0.2% | 6213.19 ± 1.7% | 5.46 | 1.00 | 1.12 | 152.66 |
| other: a heading's start tag | 110 | 14057.93 ± 1.6% | 740.58 ± 0.2% | 27.31 ± 0.1% | 1712.06 ± 0.5% | 1584.10 ± 6.3% | 16.18 ± 0.4% | 87.96 ± 0.2% | 14033.31 ± 1.2% | 18.98 | 1.00 | 8.21 | 8.87 |
| other: a whole word | 217 | 15852.18 ± 1.9% | 602.12 ± 0.2% | 28.50 ± 0.3% | 14309.61 ± 0.7% | 49.42 ± 0.1% | 13.35 ± 0.1% | 55.45 ± 0.2% | 16042.25 ± 1.1% | 26.33 | 0.99 | 1.11 | 320.76 |
| other: a line's first word, second text | 3716 | 2110.70 ± 0.6% | 591.89 ± 0.3% | 30.61 ± 0.2% | 1727.90 ± 0.2% | 62.99 ± 7.3% | refused | refused | 2112.73 ± 0.5% | 3.57 | 1.00 | 1.22 | 33.51 |
| other: fourteen octets before an x | 87 | 23934.07 ± 4.4% | 234.41 ± 0.5% | 6.46 ± 0.2% | 3971.74 ± 1.6% | 10.63 ± 0.3% | differs | 17.93 ± 0.2% | 23194.59 ± 8.2% | 102.10 | 1.03 | 6.03 | 2251.53 |
| other: a Greek word | 21815 | 528.99 ± 0.5% | 423.77 ± 0.1% | 30.33 ± 0.4% | 289.90 ± 0.4% | 49.38 ± 12.1% | differs | refused | 528.97 ± 0.2% | 1.25 | 1.00 | 1.82 | 10.71 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.69 ± 0.4% | 29.65 ± 0.3% | 0.85 ± 0.3% | 19.61 ± 0.4% | 2.74 ± 1.2% | differs | 4.07 ± 0.1% | 29.62 ± 0.2% | 1.00 | 1.00 | 1.51 | 10.83 |
| a UUID | 32895 | 24.73 ± 0.1% | 24.81 ± 0.1% | 0.64 ± 0.1% | 15.20 ± 1.0% | 3.10 ± 0.1% | 0.73 ± 0.1% | 3.62 ± 0.5% | 24.84 ± 0.2% | 1.00 | 1.00 | 1.63 | 7.97 |
| an IPv4 address | 33176 | 38.78 ± 0.2% | 38.76 ± 0.1% | 2.07 ± 0.5% | 29.33 ± 0.3% | 6.67 ± 0.2% | differs | 4.22 ± 0.1% | 38.78 ± 0.2% | 1.00 | 1.00 | 1.32 | 5.82 |
| a date and time | 32954 | 34.13 ± 0.1% | 34.26 ± 0.1% | 1.43 ± 0.3% | 21.51 ± 0.7% | 7.03 ± 0.2% | 1.23 ± 0.0% | 7.18 ± 0.2% | 34.23 ± 0.0% | 1.00 | 1.00 | 1.59 | 4.85 |
| a field path | 32606 | 32.73 ± 0.3% | 32.77 ± 0.2% | 1.02 ± 0.1% | 23.34 ± 0.4% | 3.49 ± 0.3% | differs | 2.97 ± 0.3% | 32.76 ± 0.1% | 1.00 | 1.00 | 1.40 | 9.39 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.24 ± 0.4% | 11.19 ± 0.8% | 11.21 ± 1.0% | 11.87 ± 0.1% | 4.99 ± 2.3% | 0.93 ± 0.3% | none | 11.10 ± 0.5% | 1.00 | 1.01 | 0.95 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 212.69 ± 0.2% | 213.01 ± 0.3% | 254.85 ± 0.1% | 87.75 ± 0.8% | 217.42 ± 8.8% | 489.12 ± 3.0% | 3709.64 ± 3.5% | 212.95 ± 0.2% | 1.00 | 1.00 | 2.42 | 0.98 |
| a UUID | 62 | 140.09 ± 0.3% | 140.20 ± 0.6% | 157.69 ± 0.4% | 46.88 ± 1.0% | 99.00 ± 0.8% | 195.08 ± 2.0% | 4320.49 ± 0.5% | 140.12 ± 0.3% | 1.00 | 1.00 | 2.99 | 1.42 |
| an IPv4 address | 29 | 395.97 ± 0.2% | 396.12 ± 0.3% | 566.94 ± 0.5% | 78.57 ± 0.7% | 130.28 ± 1.3% | 305.93 ± 0.7% | 7442.22 ± 0.3% | 395.67 ± 0.3% | 1.00 | 1.00 | 5.04 | 3.04 |
| a date and time | 56 | 278.13 ± 0.3% | 278.69 ± 0.2% | 353.43 ± 0.1% | 72.28 ± 1.5% | 137.00 ± 3.5% | 329.71 ± 1.1% | 4854.03 ± 0.4% | 278.24 ± 0.1% | 1.00 | 1.00 | 3.85 | 2.03 |
| a field path | 39 | 206.13 ± 0.2% | 206.17 ± 0.2% | 244.53 ± 0.3% | 80.48 ± 0.1% | 205.45 ± 1.7% | 493.82 ± 2.8% | 4714.86 ± 0.3% | 206.12 ± 0.1% | 1.00 | 1.00 | 2.56 | 1.00 |
| literal: a word | 7 | 570.55 ± 0.4% | 609.51 ± 0.7% | 1119.35 ± 0.2% | 492.68 ± 0.9% | 632.58 ± 1.5% | 959.81 ± 0.5% | 29372.76 ± 0.3% | 570.63 ± 0.3% | 0.94 | 1.00 | 1.16 | 0.90 |
| literal: a word that is not there | 8 | 553.71 ± 0.3% | 596.14 ± 0.2% | 1080.80 ± 0.1% | 452.12 ± 0.2% | 608.77 ± 1.2% | 907.38 ± 0.5% | 28449.08 ± 0.4% | 553.99 ± 0.2% | 0.93 | 1.00 | 1.22 | 0.91 |
| literal: one of four words | 26 | 232.52 ± 0.2% | 372.94 ± 0.4% | 522.37 ± 0.3% | 50.75 ± 0.4% | 244.26 ± 2.2% | 378.74 ± 1.9% | 15346.71 ± 0.1% | 232.40 ± 0.2% | 0.62 | 1.00 | 4.58 | 0.95 |
| literal: a word in any case | 11 | 419.16 ± 0.4% | 446.76 ± 0.3% | 677.67 ± 0.6% | 15.75 ± 0.1% | 663.62 ± 2.0% | refused | 22746.55 ± 0.4% | 419.30 ± 0.2% | 0.94 | 1.00 | 26.62 | 0.63 |
| literal: an href attribute | 12 | 318.06 ± 0.3% | 329.51 ± 0.3% | 439.79 ± 0.3% | 44.91 ± 0.8% | 504.49 ± 2.5% | 784.65 ± 2.0% | 21324.11 ± 0.3% | 318.21 ± 0.3% | 0.97 | 1.00 | 7.08 | 0.63 |
| literal: a word, second text | 10 | 512.97 ± 0.4% | 559.45 ± 0.4% | 966.16 ± 0.2% | 402.66 ± 1.7% | 541.14 ± 1.5% | 814.45 ± 0.3% | 26269.77 ± 1.2% | 513.09 ± 0.4% | 0.92 | 1.00 | 1.27 | 0.95 |
| class: two capitalized words | 23 | 397.09 ± 0.3% | 426.51 ± 0.2% | 627.85 ± 0.4% | 99.75 ± 0.7% | 507.10 ± 1.0% | 757.09 ± 1.0% | 6242.64 ± 0.4% | 397.56 ± 0.3% | 0.93 | 1.00 | 3.98 | 0.78 |
| class: a word that ends in ing | 9 | 501.28 ± 0.4% | 568.30 ± 0.2% | 1032.29 ± 0.3% | 133.32 ± 1.4% | 764.31 ± 1.3% | 1087.78 ± 2.0% | 15353.69 ± 0.2% | 502.08 ± 0.3% | 0.88 | 1.00 | 3.76 | 0.66 |
| class: a word in capitals | 16 | 442.90 ± 0.4% | 480.00 ± 0.4% | 784.13 ± 0.3% | 135.30 ± 0.6% | 759.10 ± 1.4% | 994.92 ± 0.8% | 8208.51 ± 0.2% | 442.31 ± 0.4% | 0.92 | 1.00 | 3.27 | 0.58 |
| class: a number | 6 | 562.29 ± 0.3% | 622.87 ± 0.6% | 1211.37 ± 0.3% | 42.36 ± 0.6% | 1404.07 ± 2.5% | 1871.50 ± 1.2% | 22187.13 ± 0.2% | 562.88 ± 0.2% | 0.90 | 1.00 | 13.27 | 0.40 |
| class: two capitalized words, second text | 23 | 397.27 ± 0.2% | 426.98 ± 0.4% | 627.70 ± 0.4% | 101.08 ± 2.5% | 509.10 ± 2.6% | 737.16 ± 0.6% | 6241.18 ± 0.2% | 397.75 ± 0.1% | 0.93 | 1.00 | 3.93 | 0.78 |
| other: a word between two words | 13 | 498.01 ± 0.8% | 516.54 ± 0.2% | 849.19 ± 0.3% | 132.51 ± 0.5% | 505.32 ± 2.1% | 808.05 ± 0.6% | 14313.93 ± 0.3% | 498.78 ± 0.4% | 0.96 | 1.00 | 3.76 | 0.99 |
| other: a number before a unit, second text | 15 | 357.05 ± 0.2% | 394.28 ± 0.3% | 563.05 ± 0.2% | 39.54 ± 0.5% | 636.80 ± 0.5% | 892.54 ± 0.8% | 14859.85 ± 0.4% | 356.98 ± 0.4% | 0.91 | 1.00 | 9.03 | 0.56 |
| other: a heading's start tag | 13 | 325.52 ± 0.3% | 332.19 ± 0.1% | 443.72 ± 0.1% | 43.23 ± 0.4% | 627.06 ± 11.8% | 857.72 ± 0.1% | 17686.74 ± 0.1% | 325.87 ± 0.3% | 0.98 | 1.00 | 7.53 | 0.52 |
| other: a whole word | 11 | 529.55 ± 0.9% | 565.28 ± 1.0% | 986.51 ± 0.7% | 119.54 ± 0.5% | 570.11 ± 1.2% | 821.08 ± 0.4% | 25312.08 ± 1.2% | 530.73 ± 0.9% | 0.94 | 1.00 | 4.43 | 0.93 |
| other: a line's first word, second text | 17 | 470.63 ± 0.4% | 501.81 ± 0.3% | 829.68 ± 0.2% | 128.69 ± 0.2% | 711.69 ± 4.6% | refused | refused | 471.86 ± 0.2% | 0.94 | 1.00 | 3.66 | 0.66 |
| other: fourteen octets before an x | 16 | 105.58 ± 0.7% | 149.99 ± 0.8% | 176.07 ± 0.7% | 15.08 ± 0.8% | 455.73 ± 1.6% | 416.08 ± 0.4% | 12580.14 ± 0.3% | 105.67 ± 0.2% | 0.70 | 1.00 | 7.00 | 0.23 |
| other: a Greek word | 8 | 398.53 ± 0.5% | 532.70 ± 0.6% | 918.46 ± 0.6% | 58.87 ± 0.3% | 1390.07 ± 3.7% | 1793.16 ± 1.0% | refused | 397.91 ± 0.4% | 0.75 | 1.00 | 6.77 | 0.29 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15516.44 ± 1.2% | not timed | not timed | 16114.17 ± 2.0% | 2088.77 ± 12.0% | not timed | not timed | 15509.72 ± 0.8% | | 1.00 | 0.96 | 7.43 |
| 01-literal/sherlock-casei-en | 522 | 10914.66 ± 9.1% | not timed | not timed | 3600.89 ± 0.3% | 32.48 ± 0.1% | not timed | not timed | 10936.52 ± 1.1% | | 1.00 | 3.03 | 336.03 |
| 01-literal/sherlock-ru | 724 | 17104.98 ± 0.4% | not timed | not timed | 17181.38 ± 1.2% | 1567.68 ± 7.8% | not timed | not timed | 17114.61 ± 0.6% | | 1.00 | 1.00 | 10.91 |
| 01-literal/sherlock-casei-ru | 746 | 6127.73 ± 0.3% | not timed | not timed | 3333.70 ± 0.2% | 31.70 ± 0.3% | not timed | not timed | 6139.94 ± 0.2% | | 1.00 | 1.84 | 193.32 |
| 01-literal/sherlock-zh | 30 | 19567.77 ± 0.9% | not timed | not timed | 18553.53 ± 0.9% | 2636.12 ± 5.3% | not timed | not timed | 19635.39 ± 0.5% | | 1.00 | 1.05 | 7.42 |
| 02-literal-alternate/sherlock-en | 714 | 6136.26 ± 0.5% | not timed | not timed | 3946.26 ± 0.1% | 16.63 ± 0.0% | not timed | not timed | 6140.41 ± 0.7% | | 1.00 | 1.55 | 368.89 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1968.59 ± 0.9% | not timed | not timed | 696.87 ± 0.3% | 11.05 ± 0.3% | not timed | not timed | 1969.29 ± 0.8% | | 1.00 | 2.82 | 178.11 |
| 02-literal-alternate/sherlock-ru | 899 | 5509.66 ± 0.3% | not timed | not timed | 3250.72 ± 0.3% | 22.70 ± 9.1% | not timed | not timed | 5505.82 ± 0.1% | | 1.00 | 1.69 | 242.76 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2050.30 ± 0.6% | not timed | not timed | 1231.58 ± 0.8% | 9.15 ± 0.2% | not timed | not timed | 2050.00 ± 0.8% | | 1.00 | 1.66 | 224.16 |
| 02-literal-alternate/sherlock-zh | 207 | 7304.43 ± 0.3% | not timed | not timed | 4169.50 ± 0.2% | 31.55 ± 0.2% | not timed | not timed | 7294.52 ± 0.2% | | 1.00 | 1.75 | 231.51 |
| 03-date/ascii | 111817 | 133.66 ± 0.6% | not timed | not timed | 95.63 ± 0.1% | 0.20 ± 5.4% | not timed | not timed | 133.96 ± 0.5% | | 1.00 | 1.40 | 670.35 |
| 04-ruff-noqa/real | 84 | 439.14 ± 0.2% | not timed | not timed | 474.45 ± 0.2% | 19.48 ± 1.2% | not timed | not timed | 437.06 ± 0.1% | | 1.00 | 0.93 | 22.54 |
| 04-ruff-noqa/tweaked | 44 | 848.63 ± 0.2% | not timed | not timed | 469.23 ± 0.1% | 368.39 ± 0.5% | not timed | not timed | 848.29 ± 0.2% | | 1.00 | 1.81 | 2.30 |
| 05-lexer-veryl/single | 124800 | 5.42 ± 0.3% | not timed | not timed | 5.24 ± 0.2% | 0.21 ± 4.3% | not timed | not timed | 5.59 ± 0.4% | | 0.97 | 1.03 | 26.32 |
| 06-cloud-flare-redos/original | 107 | 439.35 ± 0.1% | not timed | not timed | 216.95 ± 0.1% | 24.91 ± 0.2% | not timed | not timed | 439.38 ± 0.0% | | 1.00 | 2.03 | 17.64 |
| 06-cloud-flare-redos/simplified-short | 102 | 438.96 ± 0.0% | not timed | not timed | 228.71 ± 0.4% | 26.69 ± 0.1% | not timed | not timed | 438.98 ± 0.4% | | 1.00 | 1.92 | 16.44 |
| 06-cloud-flare-redos/simplified-long | 10000 | 629.11 ± 0.2% | not timed | not timed | 256.13 ± 0.1% | 28.74 ± 0.1% | not timed | not timed | 629.39 ± 0.1% | | 1.00 | 2.46 | 21.89 |
| 07-unicode-character-data/parse-line | 558784 | 236.33 ± 0.3% | not timed | not timed | 179.67 ± 0.1% | 42.93 ± 5.6% | not timed | not timed | 237.18 ± 1.6% | | 1.00 | 1.32 | 5.50 |
| 08-words/all-english | 56691 | 128.89 ± 0.4% | not timed | not timed | 83.40 ± 0.1% | 12.03 ± 2.0% | not timed | not timed | 128.86 ± 0.4% | | 1.00 | 1.55 | 10.71 |
| 08-words/long-english | 839 | 614.21 ± 0.6% | not timed | not timed | 596.16 ± 0.1% | 32.75 ± 0.2% | not timed | not timed | 615.83 ± 0.8% | | 1.00 | 1.03 | 18.75 |
| 09-aws-keys/full | 0 | 442.95 ± 0.0% | not timed | not timed | 482.41 ± 0.0% | 64.56 ± 0.1% | not timed | not timed | 443.06 ± 0.3% | | 1.00 | 0.92 | 6.86 |
| 09-aws-keys/quick | 0 | 872.96 ± 0.2% | not timed | not timed | 1001.10 ± 0.3% | 425.68 ± 3.6% | not timed | not timed | 872.99 ± 0.2% | | 1.00 | 0.87 | 2.05 |
| 10-bounded-repeat/letters-en | 1833 | 581.04 ± 3.2% | not timed | not timed | 517.13 ± 0.5% | 19.41 ± 0.4% | not timed | not timed | 578.63 ± 1.5% | | 1.00 | 1.12 | 29.93 |
| 10-bounded-repeat/letters-ru | 3475 | 507.13 ± 1.6% | not timed | not timed | 478.15 ± 0.3% | 22.28 ± 18.6% | not timed | not timed | 505.77 ± 1.5% | | 1.00 | 1.06 | 22.76 |
| 10-bounded-repeat/context | 53 | 84.64 ± 1.8% | not timed | not timed | 66.25 ± 0.8% | 19.78 ± 0.2% | not timed | not timed | 85.11 ± 1.5% | | 0.99 | 1.28 | 4.28 |
| 10-bounded-repeat/capitals | 11 | 637.43 ± 8.8% | not timed | not timed | 618.39 ± 0.1% | 36.26 ± 0.1% | not timed | not timed | 638.64 ± 7.9% | | 1.00 | 1.03 | 17.58 |
| 11-unstructured-to-json/extract | 600 | 57.68 ± 0.6% | not timed | not timed | 76.35 ± 0.1% | 49.02 ± 1.6% | not timed | not timed | 57.68 ± 0.5% | | 1.00 | 0.76 | 1.18 |
| 12-dictionary/single | 1 | 558.93 ± 1.9% | not timed | not timed | 561.89 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 559.87 ± 1.7% | | 1.00 | 0.99 | 1367.42 |
| 14-quadratic/1x | 100 | 22.11 ± 1.2% | not timed | not timed | 10.04 ± 0.1% | 0.98 ± 4.0% | not timed | not timed | 22.24 ± 2.0% | | 0.99 | 2.20 | 22.58 |
| 14-quadratic/2x | 200 | 19.86 ± 0.9% | not timed | not timed | 5.54 ± 0.4% | 0.53 ± 1.8% | not timed | not timed | 19.88 ± 1.0% | | 1.00 | 3.58 | 37.28 |
| 14-quadratic/10x | 1000 | 12.34 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 12.36 ± 0.7% | | 1.00 | 10.17 | 107.23 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.18 ± 1.0% | not timed | not timed | 0.34 ± 0.6% | 0.56 ± 7.7% | not timed | not timed | 1.19 ± 1.7% | | 1.00 | 3.44 | 2.11 |
| 04-ruff-noqa/compile-real | 1 | 102.47 ± 1.2% | not timed | not timed | 14.06 ± 0.4% | 141.72 ± 2.7% | not timed | not timed | 103.10 ± 0.8% | | 0.99 | 7.29 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 14.01 ± 1.4% | not timed | not timed | 2.52 ± 0.6% | 6.48 ± 1.8% | not timed | not timed | 13.99 ± 1.2% | | 1.00 | 5.57 | 2.16 |
| 07-unicode-character-data/compile | 1 | 107.32 ± 1.3% | not timed | not timed | 26.20 ± 0.3% | 36.62 ± 2.9% | not timed | not timed | 107.13 ± 0.6% | | 1.00 | 4.10 | 2.93 |
| 09-aws-keys/compile-full | 1 | 52.42 ± 1.4% | not timed | not timed | 8.34 ± 1.0% | 23.60 ± 1.8% | not timed | not timed | 52.40 ± 0.5% | | 1.00 | 6.29 | 2.22 |
| 09-aws-keys/compile-quick | 1 | 180.02 ± 0.9% | not timed | not timed | 48.98 ± 0.2% | 135.98 ± 2.2% | not timed | not timed | 181.60 ± 0.2% | | 0.99 | 3.68 | 1.32 |
| 10-bounded-repeat/compile-context | 1 | 70.57 ± 1.9% | not timed | not timed | 11.22 ± 0.3% | 16.15 ± 1.9% | not timed | not timed | 70.92 ± 0.3% | | 0.99 | 6.29 | 4.37 |
| 10-bounded-repeat/compile-capitals | 1 | 83.65 ± 0.9% | not timed | not timed | 8.12 ± 0.3% | 24.07 ± 1.7% | not timed | not timed | 84.02 ± 0.5% | | 1.00 | 10.30 | 3.47 |
| 11-unstructured-to-json/compile | 1 | 169.46 ± 0.9% | not timed | not timed | 40.47 ± 0.4% | 69.26 ± 1.9% | not timed | not timed | 169.34 ± 1.0% | | 1.00 | 4.19 | 2.45 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.5% | not timed | not timed | 0.07 ± 0.5% | 0.09 ± 20.0% | not timed | not timed | 0.35 ± 1.8% | | 1.00 | 5.03 | 3.72 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.43 ± 4.9% | not timed | not timed | 6.58 ± 0.1% | 0.53 ± 17.9% | not timed | not timed | 7.57 ± 0.4% | | 0.98 | 1.13 | 14.03 |
| dictionary/search/english-10 | 690 | 212.59 ± 0.8% | not timed | not timed | 166.19 ± 0.6% | 0.00 ± 0.7% | not timed | not timed | 209.79 ± 1.5% | | 1.01 | 1.28 | 73999.83 |
| dictionary/search/english-15 | 15 | 557.45 ± 2.0% | not timed | not timed | 552.94 ± 0.3% | 0.37 ± 0.6% | not timed | not timed | 560.77 ± 1.8% | | 0.99 | 1.01 | 1498.30 |
| folly/awyer-inn-busted | 1 | 21496.26 ± 0.1% | not timed | not timed | 143.22 ± 0.1% | 43.89 ± 0.1% | not timed | not timed | 21572.19 ± 0.1% | | 1.00 | 150.09 | 489.82 |
| folly/literal-never-match-rare | 0 | 21160.40 ± 0.8% | not timed | not timed | 19941.29 ± 0.2% | 41027.12 ± 0.2% | not timed | not timed | 21158.85 ± 0.2% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12540.06 ± 0.5% | not timed | not timed | 19888.24 ± 0.2% | 2192.97 ± 0.8% | not timed | not timed | 12562.30 ± 0.5% | | 1.00 | 0.63 | 5.72 |
| folly/literal-never-match-tricksy | 1 | 3256.77 ± 0.5% | not timed | not timed | 4411.34 ± 0.1% | 2996.34 ± 3.4% | not timed | not timed | 3256.84 ± 0.2% | | 1.00 | 0.74 | 1.09 |
| grep/every-line | 239963 | 1298.57 ± 0.7% | not timed | not timed | 960.35 ± 0.3% | 382.57 ± 17.9% | not timed | not timed | 1306.77 ± 0.1% | | 0.99 | 1.35 | 3.39 |
| grep/long-words-ascii | 5073 | 459.69 ± 0.2% | not timed | not timed | 468.80 ± 0.2% | 45.88 ± 7.9% | not timed | not timed | 459.46 ± 0.4% | | 1.00 | 0.98 | 10.02 |
| imported/leipzig/twain | 811 | 20794.92 ± 3.9% | not timed | not timed | 19635.09 ± 0.5% | 11971.05 ± 9.7% | not timed | not timed | 20822.89 ± 0.4% | | 1.00 | 1.06 | 1.74 |
| imported/leipzig/twain-insensitive | 965 | 9055.06 ± 0.8% | not timed | not timed | 4252.85 ± 0.1% | 37.78 ± 0.2% | not timed | not timed | 9114.10 ± 1.2% | | 0.99 | 2.13 | 239.69 |
| imported/leipzig/shing | 1540 | 15219.80 ± 3.6% | not timed | not timed | 13562.60 ± 0.4% | 34.05 ± 0.0% | not timed | not timed | 15535.75 ± 2.7% | | 0.98 | 1.12 | 447.03 |
| imported/leipzig/huck-saw | 262 | 8237.60 ± 3.6% | not timed | not timed | 5603.79 ± 0.2% | 31.83 ± 0.1% | not timed | not timed | 8326.70 ± 3.2% | | 0.99 | 1.47 | 258.76 |
| imported/leipzig/word-ending-nn | 262 | 598.52 ± 1.3% | not timed | not timed | 617.37 ± 0.3% | 24.76 ± 0.2% | not timed | not timed | 604.53 ± 1.0% | | 0.99 | 0.97 | 24.17 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11220.25 ± 1.1% | not timed | not timed | 4516.03 ± 1.3% | 11.49 ± 0.1% | not timed | not timed | 11274.47 ± 1.8% | | 1.00 | 2.48 | 976.69 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7809.43 ± 0.7% | not timed | not timed | 5489.91 ± 0.2% | 16.91 ± 0.1% | not timed | not timed | 7913.79 ± 2.4% | | 0.99 | 1.42 | 461.90 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4170.52 ± 1.0% | not timed | not timed | 418.86 ± 0.7% | 11.09 ± 0.1% | not timed | not timed | 4186.13 ± 1.0% | | 1.00 | 9.96 | 376.16 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7303.23 ± 3.2% | not timed | not timed | 614.74 ± 0.1% | 11.11 ± 0.1% | not timed | not timed | 7487.61 ± 2.9% | | 0.98 | 11.88 | 657.25 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7088.48 ± 4.0% | not timed | not timed | 615.41 ± 0.1% | 9.74 ± 0.1% | not timed | not timed | 7327.99 ± 3.6% | | 0.97 | 11.52 | 727.42 |
| imported/leipzig/tom-river | 2 | 6503.96 ± 1.7% | not timed | not timed | 5149.97 ± 0.2% | 30.96 ± 0.0% | not timed | not timed | 6587.94 ± 2.2% | | 0.99 | 1.26 | 210.07 |
| imported/leipzig/ing | 78424 | 602.77 ± 0.6% | not timed | not timed | 571.28 ± 0.0% | 28.13 ± 3.3% | not timed | not timed | 601.23 ± 0.9% | | 1.00 | 1.06 | 21.43 |
| imported/leipzig/ing-whitespace | 55248 | 1926.98 ± 2.3% | not timed | not timed | 2090.54 ± 0.3% | 20.57 ± 2.9% | not timed | not timed | 1937.24 ± 1.0% | | 0.99 | 0.92 | 93.68 |
| imported/leipzig/awyer-inn | 209 | 6387.61 ± 1.5% | not timed | not timed | 4285.41 ± 0.0% | 22.61 ± 0.0% | not timed | not timed | 6460.86 ± 1.2% | | 0.99 | 1.49 | 282.49 |
| imported/leipzig/quotes-bounded | 8886 | 2494.21 ± 1.4% | not timed | not timed | 3025.56 ± 0.1% | 38.30 ± 0.1% | not timed | not timed | 2514.10 ± 1.0% | | 0.99 | 0.82 | 65.12 |
| imported/leipzig/non-ascii-alternate | 2 | 12847.77 ± 3.1% | not timed | not timed | 5674.33 ± 0.2% | 50.59 ± 0.1% | not timed | not timed | 13103.36 ± 2.1% | | 0.98 | 2.26 | 253.98 |
| imported/leipzig/math-symbols | 69 | 1975.51 ± 0.7% | not timed | not timed | 619.27 ± 0.0% | 36.46 ± 0.1% | not timed | not timed | 1973.24 ± 0.6% | | 1.00 | 3.19 | 54.18 |
| imported/leipzig/bounded-strings-ending-z | 0 | 632.32 ± 1.9% | not timed | not timed | 618.37 ± 0.0% | 22.51 ± 0.1% | not timed | not timed | 629.84 ± 1.8% | | 1.00 | 1.02 | 28.09 |
| imported/lh3lh3-reb/uri | 17549 | 678.17 ± 0.1% | not timed | not timed | 1069.14 ± 0.2% | 27.96 ± 2.2% | not timed | not timed | 681.35 ± 0.1% | | 1.00 | 0.63 | 24.26 |
| imported/lh3lh3-reb/email | 15057 | 675.38 ± 0.1% | not timed | not timed | 1136.25 ± 0.2% | 30.74 ± 0.9% | not timed | not timed | 677.09 ± 0.1% | | 1.00 | 0.59 | 21.97 |
| imported/lh3lh3-reb/date | 668 | 891.81 ± 0.2% | not timed | not timed | 1042.82 ± 1.3% | 50.86 ± 4.7% | not timed | not timed | 891.28 ± 0.4% | | 1.00 | 0.86 | 17.53 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 646.07 ± 0.1% | not timed | not timed | 424.89 ± 0.2% | 15.72 ± 0.5% | not timed | not timed | 647.46 ± 0.0% | | 1.00 | 1.52 | 41.11 |
| imported/mariomka/email | 92 | 24303.41 ± 1.2% | not timed | not timed | 29331.54 ± 0.8% | 32.80 ± 0.2% | not timed | not timed | 24441.44 ± 0.7% | | 0.99 | 0.83 | 740.86 |
| imported/mariomka/uri | 5301 | 5561.32 ± 1.0% | not timed | not timed | 6128.37 ± 0.2% | 32.79 ± 0.2% | not timed | not timed | 5580.25 ± 0.8% | | 1.00 | 0.91 | 169.61 |
| imported/mariomka/ip | 5 | 2597.83 ± 3.0% | not timed | not timed | 2949.28 ± 0.1% | 21.06 ± 0.2% | not timed | not timed | 2605.38 ± 2.9% | | 1.00 | 0.88 | 123.33 |
| imported/rsc/no-exponential | 0 | 610.01 ± 0.3% | not timed | not timed | 323.29 ± 0.1% | 23.72 ± 0.3% | not timed | not timed | 611.06 ± 0.4% | | 1.00 | 1.89 | 25.71 |
| imported/rsc/literal | 1 | 1546.11 ± 8.0% | not timed | not timed | 1529.85 ± 4.0% | 191.75 ± 14.7% | not timed | not timed | 1541.76 ± 8.2% | | 1.00 | 1.01 | 8.06 |
| imported/rsc/not-literal | 2 | 778.07 ± 1.9% | not timed | not timed | 739.33 ± 0.6% | 46.42 ± 8.5% | not timed | not timed | 779.22 ± 0.1% | | 1.00 | 1.05 | 16.76 |
| imported/rsc/match-class | 1 | 1474.44 ± 0.3% | not timed | not timed | 1649.48 ± 0.2% | 58.84 ± 6.4% | not timed | not timed | 1472.05 ± 2.0% | | 1.00 | 0.89 | 25.06 |
| imported/rsc/match-class-in-range | 1 | 1477.68 ± 0.8% | not timed | not timed | 2340.71 ± 2.5% | 59.92 ± 15.5% | not timed | not timed | 1475.56 ± 0.3% | | 1.00 | 0.63 | 24.66 |
| imported/rsc/match-class-unicode | 1 | 540.44 ± 0.3% | not timed | not timed | 510.35 ± 0.1% | 72.23 ± 0.1% | not timed | not timed | 540.35 ± 0.1% | | 1.00 | 1.06 | 7.48 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1456.97 ± 0.2% | not timed | not timed | 947.50 ± 0.2% | 228.35 ± 0.7% | not timed | not timed | 1451.80 ± 0.2% | | 1.00 | 1.54 | 6.38 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21828.19 ± 0.1% | not timed | not timed | 14275.09 ± 0.3% | 3438.31 ± 1.1% | not timed | not timed | 21741.14 ± 0.1% | | 1.00 | 1.53 | 6.35 |
| imported/rsc/anchored-literal-short-match | 4 | 721.55 ± 2.0% | not timed | not timed | 494.22 ± 0.5% | 83.23 ± 7.0% | not timed | not timed | 722.34 ± 6.1% | | 1.00 | 1.46 | 8.67 |
| imported/rsc/anchored-literal-long-match | 4 | 10687.19 ± 2.0% | not timed | not timed | 7336.64 ± 0.1% | 1259.89 ± 10.6% | not timed | not timed | 10666.86 ± 4.4% | | 1.00 | 1.46 | 8.48 |
| imported/rsc/one-pass-short | 17 | 368.64 ± 1.2% | not timed | not timed | 215.89 ± 0.4% | 30.46 ± 10.5% | not timed | not timed | 370.69 ± 8.8% | | 0.99 | 1.71 | 12.10 |
| imported/rsc/one-pass-short-not | 17 | 268.10 ± 7.2% | not timed | not timed | 225.41 ± 0.2% | 30.69 ± 13.1% | not timed | not timed | 266.68 ± 2.4% | | 1.01 | 1.19 | 8.74 |
| imported/rsc/one-pass-long-prefix | 26 | 353.70 ± 5.9% | not timed | not timed | 283.02 ± 0.3% | 97.16 ± 17.1% | not timed | not timed | 360.24 ± 0.2% | | 0.98 | 1.25 | 3.64 |
| imported/rsc/one-pass-long-prefix-not | 26 | 359.63 ± 1.9% | not timed | not timed | 285.28 ± 0.3% | 64.23 ± 18.8% | not timed | not timed | 361.79 ± 2.5% | | 0.99 | 1.26 | 5.60 |
| imported/rsc/long-needle1 | 31 | 21934.75 ± 0.1% | not timed | not timed | 20152.83 ± 0.1% | 3.74 ± 0.2% | not timed | not timed | 21936.09 ± 0.1% | | 1.00 | 1.09 | 5860.16 |
| imported/rsc/long-needle2 | 31 | 22088.68 ± 0.1% | not timed | not timed | 216.13 ± 0.1% | 3.75 ± 0.3% | not timed | not timed | 22083.85 ± 0.1% | | 1.00 | 102.20 | 5892.22 |
| imported/rsc/easy0-32 | 26 | 1593.78 ± 2.3% | not timed | not timed | 1582.27 ± 2.4% | 148.70 ± 19.8% | not timed | not timed | 1588.37 ± 0.2% | | 1.00 | 1.01 | 10.72 |
| imported/rsc/easy0-1k | 26 | 13723.12 ± 2.2% | not timed | not timed | 12463.35 ± 1.0% | 2302.52 ± 15.8% | not timed | not timed | 13700.85 ± 0.4% | | 1.00 | 1.10 | 5.96 |
| imported/rsc/easy0-32k | 26 | 22753.38 ± 0.1% | not timed | not timed | 20292.56 ± 0.2% | 18820.25 ± 28.3% | not timed | not timed | 22756.50 ± 1.4% | | 1.00 | 1.12 | 1.21 |
| imported/rsc/easy0-1mb | 26 | 21305.86 ± 6.1% | not timed | not timed | 19779.64 ± 6.2% | 35625.66 ± 9.6% | not timed | not timed | 21327.06 ± 4.8% | | 1.00 | 1.08 | 0.60 |
| imported/rsc/easy1-32 | 19 | 765.27 ± 1.8% | not timed | not timed | 639.72 ± 0.2% | 129.39 ± 17.2% | not timed | not timed | 763.95 ± 2.4% | | 1.00 | 1.20 | 5.91 |
| imported/rsc/easy1-1k | 19 | 15718.48 ± 0.2% | not timed | not timed | 13050.54 ± 0.2% | 2492.44 ± 13.8% | not timed | not timed | 15639.06 ± 1.9% | | 1.01 | 1.20 | 6.31 |
| imported/rsc/easy1-32k | 19 | 491617.80 ± 2.4% | not timed | not timed | 409070.41 ± 0.3% | 20414.27 ± 25.8% | not timed | not timed | 490478.40 ± 0.2% | | 1.00 | 1.20 | 24.08 |
| imported/rsc/easy1-1mb | 19 | 15813710.51 ± 0.2% | not timed | not timed | 12937963.23 ± 0.2% | 37054.80 ± 3.2% | not timed | not timed | 15764741.10 ± 0.1% | | 1.00 | 1.22 | 426.77 |
| imported/rsc/medium-32 | 27 | 731.54 ± 0.3% | not timed | not timed | 635.20 ± 0.4% | 70.12 ± 13.5% | not timed | not timed | 731.64 ± 2.0% | | 1.00 | 1.15 | 10.43 |
| imported/rsc/medium-1k | 27 | 13036.56 ± 0.1% | not timed | not timed | 11124.34 ± 0.2% | 72.11 ± 0.1% | not timed | not timed | 12983.88 ± 0.4% | | 1.00 | 1.17 | 180.78 |
| imported/rsc/medium-32k | 27 | 406598.71 ± 0.2% | not timed | not timed | 353122.13 ± 0.2% | 48.88 ± 1.4% | not timed | not timed | 405081.16 ± 0.3% | | 1.00 | 1.15 | 8318.13 |
| imported/rsc/medium-1mb | 27 | 12998241.85 ± 0.2% | not timed | not timed | 11121651.91 ± 0.2% | 48.84 ± 0.2% | not timed | not timed | 12931948.14 ± 0.1% | | 1.01 | 1.17 | 266114.13 |
| imported/rsc/hard-32 | 58 | 422.20 ± 0.2% | not timed | not timed | 368.21 ± 0.1% | 49.55 ± 6.9% | not timed | not timed | 420.84 ± 1.8% | | 1.00 | 1.15 | 8.52 |
| imported/rsc/hard-1k | 27 | 12844.24 ± 0.3% | not timed | not timed | 11640.95 ± 0.5% | 40.60 ± 0.1% | not timed | not timed | 12786.63 ± 0.3% | | 1.00 | 1.10 | 316.36 |
| imported/rsc/hard-32k | 27 | 400938.90 ± 0.3% | not timed | not timed | 364588.22 ± 0.3% | 29.39 ± 0.1% | not timed | not timed | 399048.77 ± 0.2% | | 1.00 | 1.10 | 13642.95 |
| imported/rsc/hard-1mb | 51 | 8348650.53 ± 0.7% | not timed | not timed | 7215433.32 ± 0.3% | 29.44 ± 0.0% | not timed | not timed | 8349665.91 ± 0.2% | | 1.00 | 1.16 | 283625.07 |
| imported/rsc/reallyhard0-32 | 58 | 263.32 ± 0.2% | not timed | not timed | 222.52 ± 0.2% | 49.71 ± 7.7% | not timed | not timed | 263.01 ± 2.5% | | 1.00 | 1.18 | 5.30 |
| imported/rsc/reallyhard0-1k | 27 | 579.57 ± 0.2% | not timed | not timed | 582.44 ± 0.1% | 40.62 ± 0.1% | not timed | not timed | 583.20 ± 0.4% | | 0.99 | 1.00 | 14.27 |
| imported/rsc/reallyhard0-32k | 27 | 601.91 ± 0.7% | not timed | not timed | 616.00 ± 0.1% | 29.36 ± 0.2% | not timed | not timed | 601.81 ± 0.5% | | 1.00 | 0.98 | 20.50 |
| imported/rsc/reallyhard0-1mb | 51 | 627.99 ± 1.1% | not timed | not timed | 617.39 ± 0.2% | 29.44 ± 0.1% | not timed | not timed | 622.79 ± 1.1% | | 1.01 | 1.02 | 21.33 |
| imported/rsc/reallyreallyhard0-32 | 47 | 283.62 ± 1.5% | not timed | not timed | 196.61 ± 0.2% | 60.11 ± 15.4% | not timed | not timed | 286.29 ± 2.1% | | 0.99 | 1.44 | 4.72 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7058.91 ± 0.2% | not timed | not timed | 5960.08 ± 0.1% | 33.97 ± 1.7% | not timed | not timed | 7074.97 ± 0.1% | | 1.00 | 1.18 | 207.81 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21448.54 ± 0.0% | not timed | not timed | 19259.93 ± 0.1% | 25.09 ± 0.1% | not timed | not timed | 21461.64 ± 0.0% | | 1.00 | 1.11 | 854.99 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21514.81 ± 4.5% | not timed | not timed | 19567.86 ± 2.0% | 24.82 ± 1.7% | not timed | not timed | 21420.96 ± 2.7% | | 1.00 | 1.10 | 866.84 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 279.98 ± 1.7% | not timed | not timed | 212.71 ± 1.1% | 61.45 ± 14.8% | not timed | not timed | 281.59 ± 1.1% | | 0.99 | 1.32 | 4.56 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5945.16 ± 0.1% | not timed | not timed | 6195.62 ± 0.1% | 34.13 ± 3.3% | not timed | not timed | 5944.98 ± 0.2% | | 1.00 | 0.96 | 174.20 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21309.92 ± 0.1% | not timed | not timed | 19236.45 ± 0.1% | 24.80 ± 1.2% | not timed | not timed | 21381.06 ± 0.1% | | 1.00 | 1.11 | 859.28 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 20508.77 ± 1.0% | not timed | not timed | 19027.19 ± 2.0% | 25.14 ± 0.3% | not timed | not timed | 20572.96 ± 0.8% | | 1.00 | 1.08 | 815.77 |
| imported/sherlock/name-sherlock | 776 | 19639.03 ± 4.9% | not timed | not timed | 18458.87 ± 0.8% | 10054.10 ± 22.6% | not timed | not timed | 19671.03 ± 0.6% | | 1.00 | 1.06 | 1.95 |
| imported/sherlock/name-holmes | 2766 | 15085.06 ± 1.2% | not timed | not timed | 15491.26 ± 0.3% | 3265.62 ± 0.6% | not timed | not timed | 15179.27 ± 1.4% | | 0.99 | 0.97 | 4.62 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19662.63 ± 2.0% | not timed | not timed | 18473.38 ± 0.3% | 8042.63 ± 45.9% | not timed | not timed | 19692.96 ± 2.2% | | 1.00 | 1.06 | 2.44 |
| imported/sherlock/name-sherlock-casei | 816 | 15534.38 ± 0.5% | not timed | not timed | 4015.36 ± 0.3% | 32.52 ± 0.3% | not timed | not timed | 15540.69 ± 0.4% | | 1.00 | 3.87 | 477.73 |
| imported/sherlock/name-holmes-casei | 2802 | 9275.07 ± 7.1% | not timed | not timed | 3314.61 ± 0.3% | 37.18 ± 0.9% | not timed | not timed | 9305.56 ± 2.9% | | 1.00 | 2.80 | 249.49 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12755.19 ± 8.7% | not timed | not timed | 3949.22 ± 0.2% | 32.42 ± 0.4% | not timed | not timed | 12763.54 ± 1.8% | | 1.00 | 3.23 | 393.46 |
| imported/sherlock/name-whitespace | 1461 | 15316.23 ± 1.9% | not timed | not timed | 14540.95 ± 0.4% | 7365.58 ± 21.3% | not timed | not timed | 15326.68 ± 1.6% | | 1.00 | 1.05 | 2.08 |
| imported/sherlock/name-alt1 | 1142 | 11561.01 ± 2.5% | not timed | not timed | 16266.03 ± 0.8% | 4110.65 ± 53.1% | not timed | not timed | 11585.01 ± 2.5% | | 1.00 | 0.71 | 2.81 |
| imported/sherlock/name-alt2 | 3542 | 8925.19 ± 0.2% | not timed | not timed | 3821.12 ± 0.5% | 31.22 ± 0.2% | not timed | not timed | 8918.15 ± 0.2% | | 1.00 | 2.34 | 285.88 |
| imported/sherlock/name-alt3 | 4507 | 5538.34 ± 0.6% | not timed | not timed | 3629.42 ± 0.2% | 9.96 ± 0.1% | not timed | not timed | 5519.78 ± 0.6% | | 1.00 | 1.53 | 556.08 |
| imported/sherlock/name-alt3-casei | 4593 | 1522.02 ± 1.1% | not timed | not timed | 285.51 ± 0.2% | 6.42 ± 0.5% | not timed | not timed | 1526.88 ± 0.7% | | 1.00 | 5.33 | 236.95 |
| imported/sherlock/name-alt4 | 3686 | 6428.59 ± 0.2% | not timed | not timed | 3787.08 ± 0.5% | 31.36 ± 0.1% | not timed | not timed | 6430.57 ± 0.4% | | 1.00 | 1.70 | 205.02 |
| imported/sherlock/name-alt4-casei | 4254 | 2814.91 ± 2.1% | not timed | not timed | 2586.71 ± 0.3% | 19.84 ± 0.2% | not timed | not timed | 2814.85 ± 1.2% | | 1.00 | 1.09 | 141.87 |
| imported/sherlock/name-alt5 | 4028 | 6357.96 ± 0.2% | not timed | not timed | 3747.23 ± 0.3% | 21.84 ± 0.1% | not timed | not timed | 6368.04 ± 0.3% | | 1.00 | 1.70 | 291.06 |
| imported/sherlock/name-alt5-casei | 4104 | 3493.73 ± 1.7% | not timed | not timed | 2210.71 ± 0.2% | 14.32 ± 0.3% | not timed | not timed | 3494.19 ± 0.7% | | 1.00 | 1.58 | 244.00 |
| imported/sherlock/no-match-uncommon | 0 | 21478.11 ± 0.8% | not timed | not timed | 19421.08 ± 1.0% | 35310.61 ± 1.2% | not timed | not timed | 21476.18 ± 0.8% | | 1.00 | 1.11 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21257.53 ± 0.7% | not timed | not timed | 19462.15 ± 0.3% | 1282.87 ± 1.2% | not timed | not timed | 21249.49 ± 0.4% | | 1.00 | 1.09 | 16.57 |
| imported/sherlock/no-match-really-common | 0 | 15991.65 ± 2.6% | not timed | not timed | 18679.11 ± 0.5% | 1289.55 ± 1.3% | not timed | not timed | 16086.60 ± 2.0% | | 0.99 | 0.86 | 12.40 |
| imported/sherlock/the-lower | 21654 | 2296.63 ± 8.0% | not timed | not timed | 2327.43 ± 0.6% | 247.36 ± 15.9% | not timed | not timed | 2306.00 ± 0.9% | | 1.00 | 0.99 | 9.28 |
| imported/sherlock/the-upper | 2223 | 12640.25 ± 0.6% | not timed | not timed | 13526.21 ± 0.7% | 2794.77 ± 21.3% | not timed | not timed | 12679.51 ± 10.5% | | 1.00 | 0.93 | 4.52 |
| imported/sherlock/the-casei | 23961 | 1986.47 ± 1.3% | not timed | not timed | 1321.71 ± 0.3% | 34.89 ± 36.9% | not timed | not timed | 1989.99 ± 0.3% | | 1.00 | 1.50 | 56.94 |
| imported/sherlock/everything-greedy | 581881 | 282.26 ± 0.7% | not timed | not timed | 166.49 ± 0.1% | 28.95 ± 29.8% | not timed | not timed | 282.49 ± 0.3% | | 1.00 | 1.70 | 9.75 |
| imported/sherlock/everything-greedy-nl | 594933 | 490.63 ± 0.2% | not timed | not timed | 209.46 ± 0.7% | 32.99 ± 0.1% | not timed | not timed | 489.61 ± 0.2% | | 1.00 | 2.34 | 14.87 |
| imported/sherlock/letters | 447175 | 61.37 ± 7.7% | not timed | not timed | 33.10 ± 0.1% | 5.36 ± 21.2% | not timed | not timed | 61.81 ± 0.3% | | 0.99 | 1.85 | 11.45 |
| imported/sherlock/letters-upper | 14180 | 447.31 ± 1.0% | not timed | not timed | 370.26 ± 0.1% | 29.46 ± 30.5% | not timed | not timed | 446.01 ± 0.2% | | 1.00 | 1.21 | 15.18 |
| imported/sherlock/letters-lower | 432995 | 62.59 ± 0.5% | not timed | not timed | 34.01 ± 0.2% | 5.96 ± 29.2% | not timed | not timed | 62.90 ± 0.9% | | 1.00 | 1.84 | 10.50 |
| imported/sherlock/words | 447639 | 112.83 ± 1.1% | not timed | not timed | 83.23 ± 0.2% | 14.11 ± 9.1% | not timed | not timed | 112.86 ± 6.9% | | 1.00 | 1.36 | 8.00 |
| imported/sherlock/before-holmes | 4073 | 10256.02 ± 0.6% | not timed | not timed | 8455.21 ± 0.5% | 24.16 ± 0.5% | not timed | not timed | 10275.62 ± 0.5% | | 1.00 | 1.21 | 424.57 |
| imported/sherlock/before-after-holmes | 2593 | 9888.65 ± 0.5% | not timed | not timed | 9229.70 ± 0.4% | 23.85 ± 0.9% | not timed | not timed | 9933.61 ± 0.8% | | 1.00 | 1.07 | 414.54 |
| imported/sherlock/holmes-cochar-watson | 150 | 5201.40 ± 0.2% | not timed | not timed | 3426.84 ± 0.3% | 31.07 ± 0.1% | not timed | not timed | 5193.99 ± 0.2% | | 1.00 | 1.52 | 167.41 |
| imported/sherlock/holmes-coword-watson | 14309 | 1152.59 ± 0.3% | not timed | not timed | 1123.62 ± 0.2% | 6.79 ± 0.1% | not timed | not timed | 1150.86 ± 0.3% | | 1.00 | 1.03 | 169.76 |
| imported/sherlock/quotes | 14437 | 1571.15 ± 0.5% | not timed | not timed | 1748.89 ± 1.0% | 35.13 ± 0.3% | not timed | not timed | 1571.30 ± 0.2% | | 1.00 | 0.90 | 44.73 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17397.24 ± 0.3% | not timed | not timed | 16049.26 ± 0.1% | 36.86 ± 0.3% | not timed | not timed | 17344.74 ± 0.5% | | 1.00 | 1.08 | 471.95 |
| imported/sherlock/word-ending-n | 35297 | 480.71 ± 0.7% | not timed | not timed | 409.25 ± 0.0% | 23.52 ± 23.3% | not timed | not timed | 480.65 ± 0.3% | | 1.00 | 1.17 | 20.44 |
| imported/sherlock/repeated-class-negation | 2130 | 14716.07 ± 2.0% | not timed | not timed | 10835.03 ± 0.7% | 11.35 ± 0.2% | not timed | not timed | 14766.26 ± 0.4% | | 1.00 | 1.36 | 1296.81 |
| imported/sherlock/ing-suffix | 20547 | 558.85 ± 0.3% | not timed | not timed | 518.02 ± 0.1% | 28.83 ± 0.1% | not timed | not timed | 558.92 ± 0.5% | | 1.00 | 1.08 | 19.38 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1672.27 ± 0.6% | not timed | not timed | 2118.11 ± 0.5% | 20.50 ± 0.2% | not timed | not timed | 1673.67 ± 0.8% | | 1.00 | 0.79 | 81.57 |
| opt/accelerate/whole-line | 239963 | 457.85 ± 0.4% | not timed | not timed | 373.79 ± 0.5% | 91.80 ± 15.4% | not timed | not timed | 457.51 ± 0.1% | | 1.00 | 1.22 | 4.99 |
| opt/accelerate/non-dna | 16745 | 430.70 ± 0.9% | not timed | not timed | 398.72 ± 0.1% | 29.48 ± 19.0% | not timed | not timed | 430.65 ± 0.2% | | 1.00 | 1.08 | 14.61 |
| opt/backtrack/words-english | 40536 | 141.67 ± 1.6% | not timed | not timed | 94.01 ± 0.1% | 19.53 ± 6.1% | not timed | not timed | 141.39 ± 1.7% | | 1.00 | 1.51 | 7.25 |
| opt/fixed-length/too-small-ascii | 0 | 316.29 ± 0.7% | not timed | not timed | 683.79 ± 5.3% | 80.24 ± 0.7% | not timed | not timed | 318.17 ± 0.4% | | 0.99 | 0.46 | 3.94 |
| opt/fixed-length/too-big-ascii | 0 | 3349.64 ± 0.2% | not timed | not timed | 5757.50 ± 0.6% | 126.13 ± 0.5% | not timed | not timed | 3336.85 ± 0.1% | | 1.00 | 0.58 | 26.56 |
| opt/fixed-length/go33484-1 | 0 | 644262.95 ± 0.1% | not timed | not timed | 1109047.19 ± 0.6% | 61538.21 ± 0.6% | not timed | not timed | 640601.94 ± 0.0% | | 1.01 | 0.58 | 10.47 |
| opt/fixed-length/go33484-2 | 0 | 644297.55 ± 0.1% | not timed | not timed | 1102903.04 ± 1.1% | 32335.06 ± 2.2% | not timed | not timed | 640995.62 ± 0.1% | | 1.01 | 0.58 | 19.93 |
| opt/fixed-length/go33484-3 | 0 | 64411.86 ± 0.6% | not timed | not timed | 111176.43 ± 0.2% | 767.27 ± 0.4% | not timed | not timed | 64075.33 ± 0.6% | | 1.01 | 0.58 | 83.95 |
| opt/literal-alt/one-pattern | 1 | 548.12 ± 1.6% | not timed | not timed | 545.20 ± 0.0% | 0.40 ± 0.2% | not timed | not timed | 549.28 ± 1.8% | | 1.00 | 1.01 | 1368.74 |
| opt/onepass/fn-predicate | 916 | 363.98 ± 0.7% | not timed | not timed | 334.92 ± 0.0% | 199.73 ± 16.5% | not timed | not timed | 367.30 ± 0.3% | | 0.99 | 1.09 | 1.82 |
| opt/onepass/first-three-words-english | 35128 | 181.04 ± 10.9% | not timed | not timed | 199.45 ± 0.1% | 81.65 ± 15.4% | not timed | not timed | 181.79 ± 1.9% | | 1.00 | 0.91 | 2.22 |
| opt/prefilter/literal-english | 1 | 20299.49 ± 1.0% | not timed | not timed | 19295.86 ± 0.6% | 17287.96 ± 0.5% | not timed | not timed | 20366.36 ± 1.0% | | 1.00 | 1.05 | 1.17 |
| opt/prefilter/literal-casei-english | 1 | 14416.68 ± 0.6% | not timed | not timed | 4315.47 ± 0.1% | 32.73 ± 0.3% | not timed | not timed | 14427.98 ± 0.6% | | 1.00 | 3.34 | 440.47 |
| opt/prefilter/literal-russian | 1 | 21451.38 ± 0.5% | not timed | not timed | 20009.05 ± 0.3% | 3328.93 ± 0.2% | not timed | not timed | 21446.39 ± 0.5% | | 1.00 | 1.07 | 6.44 |
| opt/prefilter/literal-casei-russian | 1 | 8563.45 ± 0.5% | not timed | not timed | 3891.03 ± 0.4% | 31.69 ± 0.3% | not timed | not timed | 8564.35 ± 0.6% | | 1.00 | 2.20 | 270.22 |
| opt/prefilter/rust-functions | 948 | 6808.28 ± 0.4% | not timed | not timed | 8922.93 ± 0.1% | 1873.26 ± 0.4% | not timed | not timed | 6822.99 ± 0.3% | | 1.00 | 0.76 | 3.63 |
| opt/reverse-anchored/word-end | 1 | 29329063.06 ± 0.1% | not timed | not timed | 20949675.91 ± 0.4% | 50.49 ± 0.2% | not timed | not timed | 29242910.81 ± 0.1% | | 1.00 | 1.40 | 580888.10 |
| opt/reverse-inner/holmes | 2593 | 9886.67 ± 0.6% | not timed | not timed | 9510.01 ± 0.3% | 24.10 ± 1.0% | not timed | not timed | 9903.54 ± 0.7% | | 1.00 | 1.04 | 410.32 |
| opt/reverse-inner/email | 47 | 36219.71 ± 1.4% | not timed | not timed | 44914.57 ± 0.6% | 32.48 ± 0.3% | not timed | not timed | 36756.35 ± 2.1% | | 0.99 | 0.81 | 1114.97 |
| opt/reverse-inner/factored-prefix | 3542 | 593.03 ± 0.3% | not timed | not timed | 595.10 ± 0.1% | 12.53 ± 0.3% | not timed | not timed | 590.68 ± 0.8% | | 1.00 | 1.00 | 47.32 |
| opt/reverse-inner/no-quadratic-backward | 0 | 21018.67 ± 0.1% | not timed | not timed | 613.79 ± 0.2% | 74.87 ± 0.2% | not timed | not timed | 21164.53 ± 0.1% | | 0.99 | 34.24 | 280.73 |
| opt/reverse-inner/no-quadratic-forward | 0 | 731.48 ± 0.7% | not timed | not timed | 287.70 ± 0.4% | 24.64 ± 0.1% | not timed | not timed | 743.57 ± 1.6% | | 0.98 | 2.54 | 29.68 |
| opt/reverse-suffix/holmes | 4073 | 10225.99 ± 0.5% | not timed | not timed | 8426.54 ± 0.1% | 24.08 ± 1.3% | not timed | not timed | 10232.17 ± 0.3% | | 1.00 | 1.21 | 424.59 |
| opt/reverse-suffix/no-quadratic | 0 | 21073.93 ± 0.1% | not timed | not timed | 619.30 ± 0.4% | 74.79 ± 0.1% | not timed | not timed | 21151.13 ± 0.0% | | 1.00 | 34.03 | 281.77 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.17 ± 8.6% | not timed | not timed | 134.73 ± 0.5% | 13.22 ± 16.2% | not timed | not timed | 121.01 ± 2.8% | | 0.99 | 0.89 | 9.09 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 119.57 ± 3.0% | not timed | not timed | 133.33 ± 0.1% | 13.35 ± 14.3% | not timed | not timed | 120.68 ± 0.6% | | 0.99 | 0.90 | 8.95 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.2% | not timed | not timed | 0.54 ± 0.1% | 112.82 ± 0.2% | not timed | not timed | 0.28 ± 0.3% | | 0.99 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 322.88 ± 0.2% | not timed | not timed | 295.29 ± 0.1% | 103.47 ± 7.5% | not timed | not timed | 318.60 ± 3.8% | | 1.01 | 1.09 | 3.12 |
| reported/i13-subset-regex/original-ascii | 4094 | 11215.40 ± 1.0% | not timed | not timed | 4504.31 ± 0.7% | 11.50 ± 0.1% | not timed | not timed | 11277.66 ± 1.0% | | 0.99 | 2.49 | 975.53 |
| reported/i13-subset-regex/original-unicode | 4094 | 10679.93 ± 1.9% | not timed | not timed | 251.22 ± 3.0% | 11.52 ± 0.1% | not timed | not timed | 11233.83 ± 0.5% | | 0.95 | 42.51 | 927.10 |
| reported/i13-subset-regex/big-ascii | 1955 | 10727.00 ± 0.8% | not timed | not timed | 67.93 ± 3.4% | 9.87 ± 0.3% | not timed | not timed | 10773.99 ± 1.2% | | 1.00 | 157.92 | 1087.03 |
| reported/i13-subset-regex/big-unicode | 1955 | 10660.06 ± 1.2% | not timed | not timed | 12.22 ± 54.9% | 9.86 ± 0.1% | not timed | not timed | 10757.57 ± 1.1% | | 0.99 | 872.14 | 1080.64 |
| reported/i13-subset-regex/huge-ascii | 55 | 10071.35 ± 2.8% | not timed | not timed | 10.98 ± 0.1% | 8.78 ± 0.1% | not timed | not timed | 9868.96 ± 2.7% | | 1.02 | 917.49 | 1147.72 |
| reported/i13-subset-regex/huge-unicode | 55 | 10057.47 ± 2.6% | not timed | not timed | 11.00 ± 0.4% | 8.78 ± 0.1% | not timed | not timed | 9894.51 ± 2.9% | | 1.02 | 914.11 | 1145.01 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.53 ± 0.1% | not timed | not timed | 11.04 ± 0.1% | 8.77 ± 0.3% | not timed | not timed | 3.53 ± 0.2% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.97 ± 0.1% | not timed | not timed | 11.03 ± 0.2% | 8.76 ± 1.0% | not timed | not timed | 4.98 ± 0.0% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 483.67 ± 0.3% | not timed | not timed | 104.61 ± 0.1% | 6.64 ± 0.2% | not timed | not timed | 484.13 ± 0.4% | | 1.00 | 4.62 | 72.81 |
| reported/i787-keywords/opt-ascii | 5674 | 485.22 ± 0.3% | not timed | not timed | 266.05 ± 0.2% | 10.28 ± 0.2% | not timed | not timed | 483.39 ± 0.4% | | 1.00 | 1.82 | 47.18 |
| slow/quadratic-regex-1x | 100 | 7.10 ± 0.4% | not timed | not timed | 4.91 ± 0.8% | 0.05 ± 0.3% | not timed | not timed | 7.13 ± 0.5% | | 1.00 | 1.44 | 144.08 |
| slow/quadratic-regex-2x | 199 | 3.42 ± 0.3% | not timed | not timed | 2.76 ± 0.1% | 0.01 ± 0.2% | not timed | not timed | 3.42 ± 0.3% | | 1.00 | 1.24 | 268.94 |
| slow/quadratic-haystack-1x | 100 | 22.11 ± 7.0% | not timed | not timed | 10.04 ± 0.2% | 1.01 ± 14.8% | not timed | not timed | 22.06 ± 0.7% | | 1.00 | 2.20 | 21.90 |
| slow/quadratic-haystack-2x | 200 | 19.68 ± 0.9% | not timed | not timed | 5.53 ± 0.1% | 0.54 ± 0.4% | not timed | not timed | 19.65 ± 6.9% | | 1.00 | 3.56 | 36.22 |
| unicode/codepoints/any-one | 1112064 | 281.36 ± 0.4% | not timed | not timed | 176.98 ± 0.5% | 18.62 ± 1.1% | not timed | not timed | 281.60 ± 0.4% | | 1.00 | 1.59 | 15.11 |
| unicode/codepoints/any-all | 4382592 | 283.08 ± 1.0% | not timed | not timed | 247.34 ± 0.2% | 117.52 ± 0.0% | not timed | not timed | 281.65 ± 0.6% | | 1.01 | 1.14 | 2.41 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.71 ± 0.8% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 601.04 ± 0.7% | not timed | not timed | 616.11 ± 0.6% | 134.47 ± 0.4% | not timed | not timed | 601.68 ± 0.7% | | 1.00 | 0.98 | 4.47 |
| unicode/overlapping-words/ascii | 6156 | 31.79 ± 0.3% | not timed | not timed | 38.08 ± 0.1% | 3.93 ± 0.4% | not timed | not timed | 31.84 ± 0.4% | | 1.00 | 0.83 | 8.10 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.2% | not timed | not timed | 2.99 ± 0.1% | 2.33 ± 0.7% | not timed | not timed | 1.43 ± 0.1% | | 1.01 | 0.48 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.2% | not timed | not timed | 2.86 ± 0.1% | 6.22 ± 9.7% | not timed | not timed | 1.27 ± 0.2% | | 1.00 | 0.45 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 128.78 ± 4.2% | not timed | not timed | 83.26 ± 0.1% | 11.82 ± 16.7% | not timed | not timed | 129.38 ± 3.0% | | 1.00 | 1.55 | 10.90 |
| unicode/word/boundary-long-english | 3466 | 609.21 ± 0.9% | not timed | not timed | 604.90 ± 0.1% | 32.62 ± 0.8% | not timed | not timed | 604.55 ± 0.7% | | 1.01 | 1.01 | 18.67 |
| unicode/word/around-holmes-english | 27 | 19434.20 ± 0.7% | not timed | not timed | 19039.72 ± 1.1% | 22.11 ± 1.7% | not timed | not timed | 19438.78 ± 0.5% | | 1.00 | 1.02 | 879.02 |
| wild/bibleref/long | 874 | 566.72 ± 0.1% | not timed | not timed | 584.35 ± 0.1% | 6.84 ± 0.0% | not timed | not timed | 569.25 ± 0.2% | | 1.00 | 0.97 | 82.91 |
| wild/bibleref/short | 30 | 25.30 ± 2.1% | not timed | not timed | 30.98 ± 0.5% | 14.40 ± 9.6% | not timed | not timed | 26.05 ± 7.3% | | 0.97 | 0.82 | 1.76 |
| wild/bibleref/line | 874 | 398.09 ± 0.1% | not timed | not timed | 215.18 ± 0.1% | 9.19 ± 8.0% | not timed | not timed | 399.67 ± 1.6% | | 1.00 | 1.85 | 43.30 |
| wild/caddy/caddy | 6 | 422.52 ± 2.0% | not timed | not timed | 243.69 ± 0.3% | 68.22 ± 14.6% | not timed | not timed | 423.36 ± 0.3% | | 1.00 | 1.73 | 6.19 |
| wild/dot-star-capture/rust-src-tools | 6 | 1069.93 ± 0.4% | not timed | not timed | 350.53 ± 0.4% | 13.53 ± 0.3% | not timed | not timed | 1065.61 ± 0.4% | | 1.00 | 3.05 | 79.05 |
| wild/ruff/noqa | 84 | 439.35 ± 0.3% | not timed | not timed | 473.09 ± 0.2% | 19.54 ± 2.2% | not timed | not timed | 438.37 ± 2.2% | | 1.00 | 0.93 | 22.49 |
| wild/ruff/unnecessary-coding-comment | 16 | 959.21 ± 0.5% | not timed | not timed | 701.90 ± 0.2% | 136.36 ± 11.1% | not timed | not timed | 960.94 ± 0.5% | | 1.00 | 1.37 | 7.03 |
| wild/ruff/string-quote-prefix | 2972 | 1359.07 ± 0.6% | not timed | not timed | 440.26 ± 0.4% | 316.14 ± 26.3% | not timed | not timed | 1359.35 ± 0.7% | | 1.00 | 3.09 | 4.30 |
| wild/ruff/space-around-operator | 1224378 | 222.88 ± 1.8% | not timed | not timed | 188.17 ± 0.1% | 18.39 ± 1.7% | not timed | not timed | 223.72 ± 1.9% | | 1.00 | 1.18 | 12.12 |
| wild/ruff/shebang | 282 | 968.68 ± 0.4% | not timed | not timed | 327.35 ± 0.2% | 111.48 ± 11.3% | not timed | not timed | 974.67 ± 0.5% | | 0.99 | 2.96 | 8.69 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13827.02 ± 0.2% | not timed | not timed | 13875.77 ± 0.3% | 6950.42 ± 0.4% | not timed | not timed | 13837.43 ± 0.2% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12845.00 ± 0.3% | not timed | not timed | 13457.32 ± 0.3% | 6404.73 ± 0.7% | not timed | not timed | 12867.94 ± 0.6% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13209.52 ± 0.4% | not timed | not timed | 13713.77 ± 0.6% | 6614.73 ± 0.3% | not timed | not timed | 13210.09 ± 0.5% | | 1.00 | 0.96 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9576.11 ± 0.2% | not timed | not timed | 13644.69 ± 0.5% | 6723.02 ± 1.7% | not timed | not timed | 9598.84 ± 0.2% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 120.53 ± 12.9% | not timed | not timed | 66.03 ± 0.3% | 2.22 ± 0.7% | not timed | not timed | 121.56 ± 14.0% | | 0.99 | 1.83 | 54.25 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 2.9% | not timed | not timed | 0.01 ± 0.7% | 0.01 ± 15.3% | not timed | not timed | 0.03 ± 2.4% | | 0.98 | 3.11 | 3.99 |
| dictionary/compile/english-15 | 1 | 0.35 ± 1.7% | not timed | not timed | 0.07 ± 2.3% | 0.10 ± 31.0% | not timed | not timed | 0.35 ± 26.3% | | 0.99 | 5.04 | 3.37 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 1.9% | not timed | not timed | 0.02 ± 2.4% | 35.44 ± 2.8% | not timed | not timed | 0.24 ± 1.9% | | 0.98 | 12.60 | 0.0067 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.34 ± 2.4% | not timed | not timed | 11.52 ± 0.4% | 60.49 ± 21.6% | not timed | not timed | 46.44 ± 2.3% | | 1.00 | 4.02 | 0.77 |
| reported/i787-keywords/compile | 1 | 34.46 ± 16.8% | not timed | not timed | 2.12 ± 0.6% | 16.54 ± 27.1% | not timed | not timed | 34.47 ± 3.2% | | 1.00 | 16.27 | 2.08 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 338.78 ± 1.9% | not timed | not timed | 119.06 ± 0.2% | 563.76 ± 26.0% | not timed | not timed | 348.98 ± 2.8% | | 0.97 | 2.85 | 0.60 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 45.96 ± 2.0% | not timed | not timed | 4.11 ± 0.5% | 44.00 ± 14.5% | not timed | not timed | 46.89 ± 2.2% | | 0.98 | 11.19 | 1.04 |
| unicode/compile/one-letter | 53 | 6.61 ± 13.9% | not timed | not timed | 4.56 ± 1.4% | 66.09 ± 4.6% | not timed | not timed | 6.71 ± 12.5% | | 0.98 | 1.45 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.03 ± 12.5% | not timed | not timed | 0.10 ± 1.0% | 66.70 ± 8.1% | not timed | not timed | 1.05 ± 18.5% | | 0.98 | 10.33 | 0.0154 |
| unicode/compile/fifty-letters-ascii | 1 | 210.97 ± 3.5% | not timed | not timed | 53.03 ± 0.2% | 181.37 ± 17.0% | not timed | not timed | 214.96 ± 3.2% | | 0.98 | 3.98 | 1.16 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 364.56 ± 26.6% | not timed | not timed | 46.79 ± 0.6% | 672.75 ± 26.3% | not timed | not timed | 373.42 ± 2.3% | | 0.98 | 7.79 | 0.54 |
| unicode/compile/match-every-line-ascii | 4 | 553.84 ± 11.6% | not timed | not timed | 144.88 ± 0.4% | 657.20 ± 29.6% | not timed | not timed | 598.61 ± 1.3% | | 0.93 | 3.82 | 0.84 |
| unicode/compile/negated-class-matches-codepoint | 1 | 304.21 ± 6.5% | not timed | not timed | 51.32 ± 0.5% | 1259.87 ± 24.3% | not timed | not timed | 311.54 ± 7.2% | | 0.98 | 5.93 | 0.24 |
| wild/bibleref/compile | 3 | 5.74 ± 3.4% | not timed | not timed | 1.93 ± 0.7% | 31.83 ± 4.5% | not timed | not timed | 5.88 ± 4.0% | | 0.97 | 2.97 | 0.18 |
| wild/url/compile | 1 | 0.60 ± 19.3% | not timed | not timed | 0.14 ± 0.2% | 0.42 ± 27.3% | not timed | not timed | 0.59 ± 15.5% | | 1.01 | 4.16 | 1.43 |

