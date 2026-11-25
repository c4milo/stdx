# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45506993528 |
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
| literal: a word | 217 | 19790.31 ± 5.2% | 5085.29 ± 0.6% | 28.25 ± 0.2% | 18287.69 ± 1.7% | 9151.65 ± 8.9% | 17.58 ± 0.3% | 86.17 ± 0.1% | 19769.49 ± 3.1% | 3.89 | 1.00 | 1.08 | 2.16 |
| literal: a word that is not there | 0 | 21463.23 ± 3.5% | 4941.65 ± 0.4% | 28.19 ± 0.8% | 19593.91 ± 4.2% | 27919.64 ± 1.8% | 17.42 ± 0.5% | 81.87 ± 0.4% | 21247.95 ± 1.7% | 4.34 | 1.01 | 1.10 | 0.77 |
| literal: one of four words | 661 | 6438.84 ± 0.3% | 1975.73 ± 0.2% | 14.40 ± 0.5% | 3945.82 ± 0.3% | 21.88 ± 0.1% | 5.31 ± 0.1% | 6.74 ± 0.1% | 6439.53 ± 0.8% | 3.26 | 1.00 | 1.63 | 294.29 |
| literal: a word in any case | 217 | 15152.46 ± 0.6% | 2104.75 ± 0.3% | 21.50 ± 0.2% | 3957.68 ± 0.2% | 38.10 ± 0.2% | refused | differs | 15130.51 ± 1.0% | 7.20 | 1.00 | 3.83 | 397.75 |
| literal: an href attribute | 33 | 16714.17 ± 2.9% | 617.94 ± 0.1% | 27.32 ± 0.5% | 16980.03 ± 1.5% | 2257.92 ± 0.4% | 13.43 ± 0.2% | 75.07 ± 0.5% | 16786.76 ± 2.0% | 27.05 | 1.00 | 0.98 | 7.40 |
| literal: a word, second text | 123 | 20110.79 ± 0.8% | 3428.62 ± 0.3% | 28.03 ± 0.5% | 18523.36 ± 0.9% | 7675.81 ± 5.8% | 19.66 ± 0.4% | 68.99 ± 0.4% | 20027.07 ± 1.1% | 5.87 | 1.00 | 1.09 | 2.62 |
| class: two capitalized words | 1331 | 1066.34 ± 0.6% | 609.45 ± 0.2% | 26.01 ± 0.3% | 585.18 ± 0.2% | 40.58 ± 11.9% | 14.98 ± 0.3% | 68.17 ± 0.5% | 1066.58 ± 0.4% | 1.75 | 1.00 | 1.82 | 26.28 |
| class: a word that ends in ing | 3399 | 582.68 ± 0.2% | 582.83 ± 0.3% | 18.00 ± 0.1% | 547.97 ± 0.1% | 29.65 ± 3.3% | 8.23 ± 0.3% | 18.22 ± 0.3% | 583.71 ± 0.2% | 1.00 | 1.00 | 1.06 | 19.65 |
| class: a word in capitals | 2332 | 1390.27 ± 0.5% | 614.37 ± 0.1% | 27.63 ± 0.3% | 572.34 ± 0.2% | 43.56 ± 6.8% | 17.28 ± 0.4% | 82.95 ± 0.8% | 1390.93 ± 0.5% | 2.26 | 1.00 | 2.43 | 31.91 |
| class: a number | 8288 | 2129.68 ± 0.2% | 853.63 ± 0.1% | 27.85 ± 0.3% | 1722.87 ± 0.7% | 40.26 ± 15.9% | 0.57 ± 0.1% | 56.82 ± 0.1% | 2132.49 ± 0.5% | 2.49 | 1.00 | 1.24 | 52.90 |
| class: two capitalized words, second text | 5359 | 525.84 ± 0.1% | 535.30 ± 0.2% | 23.34 ± 0.1% | 483.94 ± 0.1% | 35.21 ± 15.2% | 16.70 ± 0.2% | 63.45 ± 0.5% | 526.16 ± 0.2% | 0.98 | 1.00 | 1.09 | 14.93 |
| other: a word between two words | 6104 | 810.81 ± 0.1% | 609.50 ± 0.2% | 23.57 ± 0.4% | 736.75 ± 0.4% | 106.46 ± 4.6% | 11.34 ± 0.3% | 69.25 ± 0.3% | 809.17 ± 0.1% | 1.33 | 1.00 | 1.10 | 7.62 |
| other: a number before a unit, second text | 1481 | 6197.47 ± 0.8% | 1133.74 ± 0.2% | 25.98 ± 0.2% | 5648.68 ± 0.2% | 40.81 ± 7.6% | 17.84 ± 0.2% | 66.80 ± 0.2% | 6180.55 ± 1.0% | 5.47 | 1.00 | 1.10 | 151.87 |
| other: a heading's start tag | 110 | 14246.79 ± 2.4% | 750.75 ± 0.2% | 27.43 ± 0.2% | 1710.81 ± 0.6% | 1583.21 ± 3.5% | 16.37 ± 0.5% | 88.42 ± 0.1% | 14199.15 ± 1.5% | 18.98 | 1.00 | 8.33 | 9.00 |
| other: a whole word | 217 | 16204.88 ± 0.2% | 608.58 ± 0.3% | 29.38 ± 0.4% | 14595.82 ± 1.0% | 48.01 ± 0.4% | 13.78 ± 0.2% | 55.20 ± 0.6% | 16311.65 ± 0.9% | 26.63 | 0.99 | 1.11 | 337.53 |
| other: a line's first word, second text | 3716 | 2097.74 ± 0.7% | 600.23 ± 0.1% | 31.07 ± 0.2% | 1722.56 ± 0.4% | 63.15 ± 7.2% | refused | refused | 2095.57 ± 0.5% | 3.49 | 1.00 | 1.22 | 33.22 |
| other: fourteen octets before an x | 87 | 23969.95 ± 1.6% | 239.24 ± 0.3% | 6.55 ± 0.1% | 4039.17 ± 2.3% | 10.64 ± 0.2% | differs | 17.47 ± 0.2% | 23924.70 ± 10.1% | 100.19 | 1.00 | 5.93 | 2252.37 |
| other: a Greek word | 21815 | 520.14 ± 0.7% | 424.84 ± 0.2% | 30.89 ± 0.4% | 289.72 ± 0.3% | 49.70 ± 10.1% | differs | refused | 522.20 ± 0.4% | 1.22 | 1.00 | 1.80 | 10.47 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.28 ± 0.3% | 29.25 ± 0.1% | 0.86 ± 0.2% | 19.71 ± 0.7% | 2.76 ± 0.9% | differs | 4.01 ± 0.2% | 29.22 ± 0.2% | 1.00 | 1.00 | 1.49 | 10.60 |
| a UUID | 32895 | 24.70 ± 0.1% | 24.67 ± 0.1% | 0.64 ± 0.3% | 15.12 ± 0.4% | 3.12 ± 0.1% | 0.72 ± 0.3% | 3.59 ± 0.3% | 24.72 ± 0.2% | 1.00 | 1.00 | 1.63 | 7.91 |
| an IPv4 address | 33176 | 38.47 ± 0.3% | 38.43 ± 0.2% | 2.07 ± 0.3% | 28.94 ± 0.3% | 6.66 ± 0.2% | differs | 4.16 ± 0.3% | 38.47 ± 0.4% | 1.00 | 1.00 | 1.33 | 5.78 |
| a date and time | 32954 | 34.33 ± 0.2% | 34.07 ± 0.3% | 1.45 ± 0.1% | 21.12 ± 0.5% | 7.03 ± 0.2% | 1.20 ± 0.3% | 7.03 ± 0.2% | 34.33 ± 0.2% | 1.01 | 1.00 | 1.63 | 4.88 |
| a field path | 32606 | 32.56 ± 0.3% | 32.56 ± 0.3% | 1.01 ± 0.5% | 22.98 ± 0.6% | 3.49 ± 0.6% | differs | 2.92 ± 0.2% | 32.52 ± 0.3% | 1.00 | 1.00 | 1.42 | 9.34 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.13 ± 0.3% | 11.04 ± 0.3% | 11.13 ± 0.3% | 11.46 ± 0.1% | 4.93 ± 1.2% | 0.91 ± 0.8% | none | 11.08 ± 0.2% | 1.01 | 1.00 | 0.97 | 2.26 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.84 ± 0.4% | 222.76 ± 0.4% | 260.11 ± 0.4% | 86.21 ± 0.5% | 221.20 ± 0.4% | 476.09 ± 1.1% | 3731.02 ± 0.9% | 222.75 ± 0.4% | 1.00 | 1.00 | 2.58 | 1.01 |
| a UUID | 62 | 144.23 ± 0.4% | 144.35 ± 0.2% | 159.56 ± 0.1% | 45.96 ± 1.0% | 98.79 ± 1.8% | 187.75 ± 2.3% | 4449.31 ± 0.6% | 144.32 ± 0.2% | 1.00 | 1.00 | 3.14 | 1.46 |
| an IPv4 address | 29 | 421.53 ± 0.3% | 421.64 ± 0.2% | 583.39 ± 0.4% | 77.28 ± 0.7% | 129.98 ± 1.3% | 292.69 ± 0.8% | 7590.08 ± 0.2% | 421.18 ± 0.4% | 1.00 | 1.00 | 5.45 | 3.24 |
| a date and time | 56 | 302.48 ± 0.3% | 302.69 ± 0.1% | 376.97 ± 0.1% | 72.43 ± 0.5% | 136.48 ± 1.0% | 320.94 ± 3.8% | 4934.14 ± 0.4% | 302.51 ± 0.1% | 1.00 | 1.00 | 4.18 | 2.22 |
| a field path | 39 | 213.81 ± 0.2% | 214.05 ± 0.3% | 248.54 ± 0.4% | 79.42 ± 1.5% | 205.84 ± 1.7% | 502.65 ± 4.7% | 4825.54 ± 2.8% | 213.45 ± 0.4% | 1.00 | 1.00 | 2.69 | 1.04 |
| literal: a word | 7 | 619.02 ± 0.7% | 671.50 ± 0.7% | 1187.49 ± 0.9% | 507.41 ± 0.1% | 630.40 ± 1.8% | 947.52 ± 0.3% | 29757.92 ± 0.4% | 619.97 ± 0.9% | 0.92 | 1.00 | 1.22 | 0.98 |
| literal: a word that is not there | 8 | 597.70 ± 0.8% | 656.55 ± 0.7% | 1121.69 ± 0.6% | 463.97 ± 0.2% | 607.86 ± 1.4% | 890.93 ± 0.5% | 28558.09 ± 0.2% | 597.49 ± 0.5% | 0.91 | 1.00 | 1.29 | 0.98 |
| literal: one of four words | 26 | 246.04 ± 0.2% | 396.65 ± 0.5% | 533.13 ± 0.2% | 49.71 ± 1.1% | 241.98 ± 2.1% | 367.57 ± 0.8% | 15439.41 ± 0.1% | 246.09 ± 0.2% | 0.62 | 1.00 | 4.95 | 1.02 |
| literal: a word in any case | 11 | 448.65 ± 0.2% | 479.78 ± 0.4% | 702.89 ± 0.1% | 15.89 ± 1.5% | 663.50 ± 1.6% | refused | 23295.09 ± 0.3% | 448.77 ± 0.1% | 0.94 | 1.00 | 28.24 | 0.68 |
| literal: an href attribute | 12 | 336.90 ± 0.6% | 347.13 ± 0.9% | 450.57 ± 0.6% | 44.66 ± 1.3% | 498.13 ± 10.0% | 765.03 ± 0.6% | 21513.30 ± 0.6% | 335.96 ± 0.3% | 0.97 | 1.00 | 7.54 | 0.68 |
| literal: a word, second text | 10 | 554.99 ± 0.7% | 617.00 ± 0.6% | 1012.63 ± 0.7% | 417.34 ± 1.1% | 535.90 ± 2.1% | 789.26 ± 0.6% | 26358.05 ± 0.2% | 555.68 ± 0.3% | 0.90 | 1.00 | 1.33 | 1.04 |
| class: two capitalized words | 23 | 436.78 ± 0.8% | 464.20 ± 0.9% | 662.35 ± 0.8% | 100.05 ± 1.1% | 504.09 ± 0.9% | 742.17 ± 0.4% | 6331.52 ± 0.1% | 435.86 ± 0.6% | 0.94 | 1.00 | 4.37 | 0.87 |
| class: a word that ends in ing | 9 | 549.97 ± 0.2% | 618.49 ± 0.7% | 1059.81 ± 0.3% | 131.89 ± 0.4% | 759.36 ± 2.4% | 1105.13 ± 0.5% | 15691.78 ± 0.1% | 549.51 ± 0.1% | 0.89 | 1.00 | 4.17 | 0.72 |
| class: a word in capitals | 16 | 493.12 ± 0.4% | 529.96 ± 0.5% | 830.85 ± 0.2% | 134.96 ± 1.1% | 755.22 ± 2.5% | 1020.70 ± 0.6% | 8326.24 ± 0.1% | 492.98 ± 0.2% | 0.93 | 1.00 | 3.65 | 0.65 |
| class: a number | 6 | 627.66 ± 0.4% | 686.65 ± 0.5% | 1262.76 ± 0.2% | 41.58 ± 1.2% | 1403.13 ± 1.2% | 1856.69 ± 1.5% | 22439.64 ± 0.1% | 625.79 ± 0.5% | 0.91 | 1.00 | 15.10 | 0.45 |
| class: two capitalized words, second text | 23 | 437.22 ± 0.3% | 464.23 ± 0.4% | 662.51 ± 0.5% | 100.39 ± 0.9% | 505.13 ± 1.3% | 763.51 ± 0.6% | 6334.92 ± 0.1% | 436.14 ± 0.2% | 0.94 | 1.00 | 4.36 | 0.87 |
| other: a word between two words | 13 | 532.11 ± 0.4% | 553.72 ± 0.4% | 869.25 ± 0.3% | 133.43 ± 1.1% | 503.52 ± 1.4% | 808.84 ± 1.2% | 14552.93 ± 0.1% | 531.97 ± 0.2% | 0.96 | 1.00 | 3.99 | 1.06 |
| other: a number before a unit, second text | 15 | 384.61 ± 0.2% | 424.26 ± 0.3% | 586.80 ± 0.1% | 39.36 ± 1.4% | 633.58 ± 6.7% | 886.35 ± 2.6% | 15080.31 ± 0.1% | 384.73 ± 0.1% | 0.91 | 1.00 | 9.77 | 0.61 |
| other: a heading's start tag | 13 | 346.93 ± 0.4% | 354.38 ± 0.4% | 461.22 ± 0.2% | 43.76 ± 0.2% | 631.00 ± 1.1% | 873.60 ± 0.5% | 17839.51 ± 0.1% | 346.38 ± 0.5% | 0.98 | 1.00 | 7.93 | 0.55 |
| other: a whole word | 11 | 571.65 ± 0.5% | 615.23 ± 0.5% | 1011.51 ± 0.7% | 119.41 ± 0.7% | 567.06 ± 1.4% | 828.62 ± 0.6% | 26243.19 ± 0.2% | 572.68 ± 0.2% | 0.93 | 1.00 | 4.79 | 1.01 |
| other: a line's first word, second text | 17 | 516.50 ± 0.8% | 547.37 ± 0.4% | 866.81 ± 0.6% | 128.66 ± 0.4% | 714.02 ± 0.9% | refused | refused | 517.07 ± 0.4% | 0.94 | 1.00 | 4.01 | 0.72 |
| other: fourteen octets before an x | 16 | 107.68 ± 0.3% | 154.23 ± 0.7% | 175.07 ± 0.6% | 14.80 ± 0.6% | 455.60 ± 7.4% | 409.54 ± 0.6% | 12618.26 ± 0.3% | 107.83 ± 0.3% | 0.70 | 1.00 | 7.28 | 0.24 |
| other: a Greek word | 8 | 443.28 ± 0.2% | 578.04 ± 0.3% | 946.26 ± 0.6% | 58.70 ± 0.7% | 1381.10 ± 1.3% | 1811.63 ± 0.2% | refused | 443.45 ± 0.2% | 0.77 | 1.00 | 7.55 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15611.05 ± 1.7% | not timed | not timed | 16252.77 ± 2.0% | 2084.78 ± 12.6% | not timed | not timed | 15603.87 ± 1.5% | | 1.00 | 0.96 | 7.49 |
| 01-literal/sherlock-casei-en | 522 | 11037.36 ± 6.3% | not timed | not timed | 3591.26 ± 0.2% | 32.53 ± 0.3% | not timed | not timed | 11065.12 ± 1.4% | | 1.00 | 3.07 | 339.26 |
| 01-literal/sherlock-ru | 724 | 17211.60 ± 0.8% | not timed | not timed | 17326.31 ± 0.3% | 1537.89 ± 8.4% | not timed | not timed | 17216.56 ± 0.5% | | 1.00 | 0.99 | 11.19 |
| 01-literal/sherlock-casei-ru | 746 | 6152.79 ± 0.1% | not timed | not timed | 3332.15 ± 0.2% | 31.66 ± 1.0% | not timed | not timed | 6143.06 ± 0.2% | | 1.00 | 1.85 | 194.33 |
| 01-literal/sherlock-zh | 30 | 19554.35 ± 1.0% | not timed | not timed | 18460.44 ± 0.5% | 2570.02 ± 9.3% | not timed | not timed | 19549.99 ± 0.8% | | 1.00 | 1.06 | 7.61 |
| 02-literal-alternate/sherlock-en | 714 | 6145.10 ± 0.7% | not timed | not timed | 3938.97 ± 0.6% | 16.62 ± 0.1% | not timed | not timed | 6137.45 ± 0.4% | | 1.00 | 1.56 | 369.82 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1975.58 ± 1.6% | not timed | not timed | 697.76 ± 0.1% | 11.14 ± 2.1% | not timed | not timed | 1978.16 ± 0.9% | | 1.00 | 2.83 | 177.37 |
| 02-literal-alternate/sherlock-ru | 899 | 5539.61 ± 0.1% | not timed | not timed | 3248.49 ± 0.1% | 22.63 ± 0.1% | not timed | not timed | 5527.74 ± 0.1% | | 1.00 | 1.71 | 244.84 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2058.13 ± 0.4% | not timed | not timed | 1231.64 ± 0.6% | 8.94 ± 2.3% | not timed | not timed | 2054.63 ± 0.7% | | 1.00 | 1.67 | 230.15 |
| 02-literal-alternate/sherlock-zh | 207 | 7342.46 ± 0.2% | not timed | not timed | 4162.20 ± 0.1% | 31.01 ± 0.1% | not timed | not timed | 7350.05 ± 0.3% | | 1.00 | 1.76 | 236.81 |
| 03-date/ascii | 111817 | 133.67 ± 0.5% | not timed | not timed | 95.32 ± 0.1% | 0.20 ± 1.6% | not timed | not timed | 134.49 ± 0.6% | | 0.99 | 1.40 | 659.96 |
| 04-ruff-noqa/real | 84 | 435.94 ± 0.1% | not timed | not timed | 462.91 ± 0.0% | 19.55 ± 1.4% | not timed | not timed | 435.96 ± 0.2% | | 1.00 | 0.94 | 22.30 |
| 04-ruff-noqa/tweaked | 44 | 593.81 ± 0.3% | not timed | not timed | 460.13 ± 0.0% | 364.43 ± 6.0% | not timed | not timed | 595.13 ± 0.3% | | 1.00 | 1.29 | 1.63 |
| 05-lexer-veryl/single | 124800 | 5.36 ± 0.4% | not timed | not timed | 4.98 ± 0.1% | 0.20 ± 4.0% | not timed | not timed | 5.51 ± 0.2% | | 0.97 | 1.08 | 26.21 |
| 06-cloud-flare-redos/original | 107 | 426.38 ± 0.1% | not timed | not timed | 216.84 ± 0.1% | 24.94 ± 0.1% | not timed | not timed | 430.85 ± 0.1% | | 0.99 | 1.97 | 17.10 |
| 06-cloud-flare-redos/simplified-short | 102 | 431.18 ± 0.2% | not timed | not timed | 229.45 ± 0.2% | 26.79 ± 0.2% | not timed | not timed | 429.28 ± 0.2% | | 1.00 | 1.88 | 16.10 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.50 ± 0.1% | not timed | not timed | 256.95 ± 0.2% | 28.84 ± 0.2% | not timed | not timed | 588.54 ± 0.1% | | 1.00 | 2.29 | 20.40 |
| 07-unicode-character-data/parse-line | 558784 | 233.31 ± 2.7% | not timed | not timed | 172.16 ± 0.1% | 43.31 ± 4.2% | not timed | not timed | 232.66 ± 2.3% | | 1.00 | 1.36 | 5.39 |
| 08-words/all-english | 56691 | 127.78 ± 1.2% | not timed | not timed | 82.82 ± 0.1% | 12.94 ± 2.5% | not timed | not timed | 127.87 ± 0.7% | | 1.00 | 1.54 | 9.87 |
| 08-words/long-english | 839 | 620.58 ± 0.1% | not timed | not timed | 594.14 ± 0.1% | 32.40 ± 0.4% | not timed | not timed | 623.41 ± 0.3% | | 1.00 | 1.04 | 19.15 |
| 09-aws-keys/full | 0 | 440.66 ± 0.1% | not timed | not timed | 463.55 ± 0.1% | 61.47 ± 0.1% | not timed | not timed | 439.53 ± 0.1% | | 1.00 | 0.95 | 7.17 |
| 09-aws-keys/quick | 0 | 874.70 ± 0.1% | not timed | not timed | 991.37 ± 0.2% | 418.73 ± 1.5% | not timed | not timed | 874.37 ± 0.2% | | 1.00 | 0.88 | 2.09 |
| 10-bounded-repeat/letters-en | 1833 | 581.38 ± 3.1% | not timed | not timed | 514.96 ± 0.2% | 19.55 ± 0.7% | not timed | not timed | 587.11 ± 1.4% | | 0.99 | 1.13 | 29.74 |
| 10-bounded-repeat/letters-ru | 3475 | 505.22 ± 1.7% | not timed | not timed | 479.00 ± 0.2% | 22.04 ± 9.0% | not timed | not timed | 507.13 ± 0.6% | | 1.00 | 1.05 | 22.93 |
| 10-bounded-repeat/context | 53 | 85.35 ± 1.2% | not timed | not timed | 65.25 ± 0.4% | 19.82 ± 0.2% | not timed | not timed | 85.23 ± 1.6% | | 1.00 | 1.31 | 4.31 |
| 10-bounded-repeat/capitals | 11 | 634.19 ± 8.2% | not timed | not timed | 618.60 ± 0.1% | 36.30 ± 0.2% | not timed | not timed | 634.01 ± 8.1% | | 1.00 | 1.03 | 17.47 |
| 11-unstructured-to-json/extract | 600 | 57.23 ± 0.3% | not timed | not timed | 77.68 ± 0.2% | 49.05 ± 0.3% | not timed | not timed | 57.37 ± 0.3% | | 1.00 | 0.74 | 1.17 |
| 12-dictionary/single | 1 | 561.33 ± 1.3% | not timed | not timed | 562.62 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 562.15 ± 0.7% | | 1.00 | 1.00 | 1383.51 |
| 14-quadratic/1x | 100 | 21.32 ± 0.5% | not timed | not timed | 10.01 ± 0.3% | 0.96 ± 2.9% | not timed | not timed | 21.31 ± 1.3% | | 1.00 | 2.13 | 22.10 |
| 14-quadratic/2x | 200 | 17.75 ± 1.7% | not timed | not timed | 5.55 ± 0.4% | 0.53 ± 0.2% | not timed | not timed | 17.83 ± 1.1% | | 1.00 | 3.20 | 33.25 |
| 14-quadratic/10x | 1000 | 7.76 ± 0.9% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.1% | not timed | not timed | 7.77 ± 0.5% | | 1.00 | 6.41 | 67.29 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.22 ± 2.3% | not timed | not timed | 0.34 ± 0.3% | 0.55 ± 1.9% | not timed | not timed | 1.22 ± 1.9% | | 1.00 | 3.54 | 2.20 |
| 04-ruff-noqa/compile-real | 1 | 106.14 ± 1.2% | not timed | not timed | 13.95 ± 0.6% | 139.82 ± 3.0% | not timed | not timed | 106.43 ± 1.4% | | 1.00 | 7.61 | 0.76 |
| 05-lexer-veryl/compile-single | 1 | 14.03 ± 0.5% | not timed | not timed | 2.53 ± 0.9% | 6.42 ± 0.9% | not timed | not timed | 14.04 ± 1.3% | | 1.00 | 5.54 | 2.18 |
| 07-unicode-character-data/compile | 1 | 108.05 ± 1.2% | not timed | not timed | 26.18 ± 0.2% | 36.02 ± 2.5% | not timed | not timed | 108.19 ± 1.1% | | 1.00 | 4.13 | 3.00 |
| 09-aws-keys/compile-full | 1 | 53.15 ± 0.8% | not timed | not timed | 8.33 ± 0.6% | 23.17 ± 19.7% | not timed | not timed | 53.14 ± 0.5% | | 1.00 | 6.38 | 2.29 |
| 09-aws-keys/compile-quick | 1 | 187.15 ± 1.2% | not timed | not timed | 47.59 ± 1.0% | 135.00 ± 2.3% | not timed | not timed | 187.51 ± 0.2% | | 1.00 | 3.93 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 72.18 ± 2.1% | not timed | not timed | 11.21 ± 0.2% | 16.09 ± 1.5% | not timed | not timed | 72.02 ± 1.4% | | 1.00 | 6.44 | 4.49 |
| 10-bounded-repeat/compile-capitals | 1 | 85.01 ± 1.5% | not timed | not timed | 8.10 ± 0.3% | 23.81 ± 1.5% | not timed | not timed | 85.00 ± 1.4% | | 1.00 | 10.49 | 3.57 |
| 11-unstructured-to-json/compile | 1 | 170.22 ± 1.0% | not timed | not timed | 40.89 ± 0.6% | 68.38 ± 1.7% | not timed | not timed | 170.87 ± 0.3% | | 1.00 | 4.16 | 2.49 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.0% | not timed | not timed | 0.07 ± 9.8% | 0.10 ± 6.2% | not timed | not timed | 0.35 ± 0.4% | | 1.00 | 5.04 | 3.58 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.37 ± 0.4% | not timed | not timed | 6.46 ± 0.1% | 0.54 ± 1.0% | not timed | not timed | 7.38 ± 1.0% | | 1.00 | 1.14 | 13.73 |
| dictionary/search/english-10 | 690 | 1.16 ± 0.3% | not timed | not timed | 165.06 ± 0.5% | 0.00 ± 0.3% | not timed | not timed | 1.17 ± 0.3% | | 1.00 | 0.0070 | 432.87 |
| dictionary/search/english-15 | 15 | 566.24 ± 1.0% | not timed | not timed | 561.80 ± 0.2% | 0.37 ± 0.4% | not timed | not timed | 567.62 ± 1.0% | | 1.00 | 1.01 | 1544.10 |
| folly/awyer-inn-busted | 1 | 5590.68 ± 0.2% | not timed | not timed | 138.74 ± 4.4% | 43.98 ± 0.1% | not timed | not timed | 5613.30 ± 0.0% | | 1.00 | 40.30 | 127.12 |
| folly/literal-never-match-rare | 0 | 21145.12 ± 0.7% | not timed | not timed | 19928.60 ± 1.1% | 41010.17 ± 1.5% | not timed | not timed | 21154.24 ± 0.3% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12494.42 ± 1.4% | not timed | not timed | 19876.67 ± 0.5% | 2184.88 ± 0.7% | not timed | not timed | 12526.67 ± 1.2% | | 1.00 | 0.63 | 5.72 |
| folly/literal-never-match-tricksy | 1 | 3244.66 ± 0.2% | not timed | not timed | 4414.85 ± 0.2% | 3040.68 ± 3.0% | not timed | not timed | 3242.99 ± 0.3% | | 1.00 | 0.73 | 1.07 |
| grep/every-line | 239963 | 1318.84 ± 0.4% | not timed | not timed | 948.51 ± 0.2% | 375.58 ± 18.0% | not timed | not timed | 1322.43 ± 0.6% | | 1.00 | 1.39 | 3.51 |
| grep/long-words-ascii | 5073 | 459.07 ± 0.3% | not timed | not timed | 466.87 ± 0.1% | 46.25 ± 6.1% | not timed | not timed | 458.86 ± 0.2% | | 1.00 | 0.98 | 9.93 |
| imported/leipzig/twain | 811 | 20728.80 ± 0.8% | not timed | not timed | 19542.79 ± 0.6% | 12011.91 ± 12.5% | not timed | not timed | 20763.41 ± 0.3% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9051.85 ± 0.8% | not timed | not timed | 4250.24 ± 0.2% | 37.81 ± 0.1% | not timed | not timed | 9100.49 ± 0.8% | | 0.99 | 2.13 | 239.42 |
| imported/leipzig/shing | 1540 | 15265.33 ± 2.2% | not timed | not timed | 13537.14 ± 0.2% | 33.99 ± 0.1% | not timed | not timed | 15517.52 ± 2.0% | | 0.98 | 1.13 | 449.07 |
| imported/leipzig/huck-saw | 262 | 8323.89 ± 2.9% | not timed | not timed | 5606.68 ± 0.2% | 31.86 ± 0.2% | not timed | not timed | 8467.66 ± 2.5% | | 0.98 | 1.48 | 261.25 |
| imported/leipzig/word-ending-nn | 262 | 603.60 ± 0.6% | not timed | not timed | 615.53 ± 0.4% | 24.71 ± 0.3% | not timed | not timed | 603.67 ± 0.6% | | 1.00 | 0.98 | 24.43 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11159.19 ± 0.8% | not timed | not timed | 4538.85 ± 0.6% | 11.46 ± 0.1% | not timed | not timed | 11209.13 ± 1.0% | | 1.00 | 2.46 | 973.92 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7830.59 ± 2.3% | not timed | not timed | 5487.99 ± 0.2% | 16.51 ± 1.7% | not timed | not timed | 7937.98 ± 2.5% | | 0.99 | 1.43 | 474.31 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4188.83 ± 0.7% | not timed | not timed | 418.73 ± 1.1% | 10.96 ± 0.0% | not timed | not timed | 4215.42 ± 0.8% | | 0.99 | 10.00 | 382.24 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 600.82 ± 0.7% | not timed | not timed | 615.65 ± 0.3% | 11.13 ± 0.1% | not timed | not timed | 602.95 ± 0.8% | | 1.00 | 0.98 | 53.97 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 603.22 ± 0.4% | not timed | not timed | 616.04 ± 0.1% | 9.72 ± 0.0% | not timed | not timed | 602.17 ± 0.5% | | 1.00 | 0.98 | 62.05 |
| imported/leipzig/tom-river | 2 | 6515.38 ± 1.6% | not timed | not timed | 5151.34 ± 0.4% | 31.11 ± 0.1% | not timed | not timed | 6603.96 ± 1.4% | | 0.99 | 1.26 | 209.46 |
| imported/leipzig/ing | 78424 | 600.65 ± 0.7% | not timed | not timed | 570.38 ± 0.1% | 28.29 ± 2.8% | not timed | not timed | 602.26 ± 0.8% | | 1.00 | 1.05 | 21.23 |
| imported/leipzig/ing-whitespace | 55248 | 752.09 ± 1.0% | not timed | not timed | 2079.06 ± 0.3% | 20.54 ± 2.8% | not timed | not timed | 754.81 ± 1.1% | | 1.00 | 0.36 | 36.61 |
| imported/leipzig/awyer-inn | 209 | 768.62 ± 1.6% | not timed | not timed | 4277.68 ± 0.4% | 22.62 ± 0.1% | not timed | not timed | 768.19 ± 1.0% | | 1.00 | 0.18 | 33.99 |
| imported/leipzig/quotes-bounded | 8886 | 2126.49 ± 0.3% | not timed | not timed | 3030.56 ± 0.4% | 38.29 ± 0.2% | not timed | not timed | 2130.52 ± 0.5% | | 1.00 | 0.70 | 55.54 |
| imported/leipzig/non-ascii-alternate | 2 | 12858.28 ± 2.1% | not timed | not timed | 5674.83 ± 0.3% | 50.75 ± 0.1% | not timed | not timed | 13078.84 ± 2.0% | | 0.98 | 2.27 | 253.36 |
| imported/leipzig/math-symbols | 69 | 1978.52 ± 0.6% | not timed | not timed | 613.72 ± 0.0% | 36.46 ± 0.2% | not timed | not timed | 1981.10 ± 0.4% | | 1.00 | 3.22 | 54.27 |
| imported/leipzig/bounded-strings-ending-z | 0 | 587.08 ± 0.4% | not timed | not timed | 617.78 ± 0.0% | 22.57 ± 0.3% | not timed | not timed | 587.28 ± 0.5% | | 1.00 | 0.95 | 26.01 |
| imported/lh3lh3-reb/uri | 17549 | 679.75 ± 0.1% | not timed | not timed | 1061.99 ± 0.2% | 27.96 ± 5.8% | not timed | not timed | 679.27 ± 0.2% | | 1.00 | 0.64 | 24.31 |
| imported/lh3lh3-reb/email | 15057 | 673.83 ± 0.1% | not timed | not timed | 1156.12 ± 0.0% | 30.42 ± 7.6% | not timed | not timed | 673.66 ± 0.1% | | 1.00 | 0.58 | 22.15 |
| imported/lh3lh3-reb/date | 668 | 861.00 ± 0.2% | not timed | not timed | 1029.75 ± 0.1% | 51.48 ± 3.9% | not timed | not timed | 861.03 ± 0.1% | | 1.00 | 0.84 | 16.72 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 646.23 ± 0.2% | not timed | not timed | 422.17 ± 0.1% | 15.80 ± 1.5% | not timed | not timed | 645.41 ± 0.2% | | 1.00 | 1.53 | 40.90 |
| imported/mariomka/email | 92 | 24407.89 ± 1.2% | not timed | not timed | 29700.63 ± 0.5% | 32.86 ± 0.2% | not timed | not timed | 24375.23 ± 1.5% | | 1.00 | 0.82 | 742.87 |
| imported/mariomka/uri | 5301 | 5348.44 ± 0.5% | not timed | not timed | 6116.84 ± 0.1% | 32.68 ± 0.5% | not timed | not timed | 5380.91 ± 0.7% | | 0.99 | 0.87 | 163.66 |
| imported/mariomka/ip | 5 | 2150.84 ± 2.1% | not timed | not timed | 2969.49 ± 0.1% | 21.06 ± 0.2% | not timed | not timed | 2154.96 ± 2.3% | | 1.00 | 0.72 | 102.13 |
| imported/rsc/no-exponential | 0 | 606.45 ± 0.1% | not timed | not timed | 320.77 ± 0.3% | 23.88 ± 0.1% | not timed | not timed | 602.29 ± 0.0% | | 1.01 | 1.89 | 25.40 |
| imported/rsc/literal | 1 | 759.11 ± 3.2% | not timed | not timed | 1649.29 ± 4.4% | 187.25 ± 14.6% | not timed | not timed | 758.44 ± 5.0% | | 1.00 | 0.46 | 4.05 |
| imported/rsc/not-literal | 2 | 780.77 ± 0.1% | not timed | not timed | 730.00 ± 0.5% | 46.37 ± 2.9% | not timed | not timed | 782.53 ± 8.5% | | 1.00 | 1.07 | 16.84 |
| imported/rsc/match-class | 1 | 1439.99 ± 0.9% | not timed | not timed | 1605.11 ± 0.4% | 58.66 ± 14.2% | not timed | not timed | 1437.65 ± 2.3% | | 1.00 | 0.90 | 24.55 |
| imported/rsc/match-class-in-range | 1 | 1445.48 ± 0.4% | not timed | not timed | 2359.90 ± 2.9% | 60.24 ± 7.2% | not timed | not timed | 1437.04 ± 2.5% | | 1.01 | 0.61 | 23.99 |
| imported/rsc/match-class-unicode | 1 | 548.05 ± 0.1% | not timed | not timed | 515.87 ± 0.0% | 72.69 ± 0.3% | not timed | not timed | 548.67 ± 0.1% | | 1.00 | 1.06 | 7.54 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1441.39 ± 0.1% | not timed | not timed | 953.08 ± 0.1% | 229.91 ± 0.7% | not timed | not timed | 1437.78 ± 0.2% | | 1.00 | 1.51 | 6.27 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21612.07 ± 0.1% | not timed | not timed | 14242.02 ± 0.2% | 3428.80 ± 0.6% | not timed | not timed | 21561.47 ± 0.1% | | 1.00 | 1.52 | 6.30 |
| imported/rsc/anchored-literal-short-match | 4 | 709.03 ± 2.0% | not timed | not timed | 487.40 ± 0.2% | 85.49 ± 6.8% | not timed | not timed | 707.79 ± 5.7% | | 1.00 | 1.45 | 8.29 |
| imported/rsc/anchored-literal-long-match | 4 | 10485.67 ± 2.4% | not timed | not timed | 7348.75 ± 0.5% | 1237.20 ± 8.8% | not timed | not timed | 10624.73 ± 3.5% | | 0.99 | 1.43 | 8.48 |
| imported/rsc/one-pass-short | 17 | 370.29 ± 11.8% | not timed | not timed | 214.30 ± 0.1% | 31.50 ± 11.5% | not timed | not timed | 370.90 ± 0.5% | | 1.00 | 1.73 | 11.75 |
| imported/rsc/one-pass-short-not | 17 | 281.54 ± 1.7% | not timed | not timed | 226.39 ± 0.1% | 30.37 ± 8.4% | not timed | not timed | 281.16 ± 5.9% | | 1.00 | 1.24 | 9.27 |
| imported/rsc/one-pass-long-prefix | 26 | 366.53 ± 2.1% | not timed | not timed | 281.22 ± 0.1% | 97.38 ± 13.9% | not timed | not timed | 367.71 ± 1.8% | | 1.00 | 1.30 | 3.76 |
| imported/rsc/one-pass-long-prefix-not | 26 | 362.81 ± 2.1% | not timed | not timed | 282.04 ± 0.1% | 69.41 ± 21.5% | not timed | not timed | 366.38 ± 6.1% | | 0.99 | 1.29 | 5.23 |
| imported/rsc/long-needle1 | 31 | 22194.34 ± 0.0% | not timed | not timed | 20118.50 ± 0.1% | 3.77 ± 0.1% | not timed | not timed | 22199.35 ± 0.1% | | 1.00 | 1.10 | 5892.80 |
| imported/rsc/long-needle2 | 31 | 22317.95 ± 0.1% | not timed | not timed | 216.36 ± 0.2% | 3.77 ± 0.1% | not timed | not timed | 22323.15 ± 0.1% | | 1.00 | 103.15 | 5927.58 |
| imported/rsc/easy0-32 | 26 | 1067.78 ± 2.8% | not timed | not timed | 1634.28 ± 2.6% | 148.64 ± 18.7% | not timed | not timed | 1069.68 ± 0.2% | | 1.00 | 0.65 | 7.18 |
| imported/rsc/easy0-1k | 26 | 14940.25 ± 2.2% | not timed | not timed | 12515.61 ± 0.8% | 2328.30 ± 16.2% | not timed | not timed | 14926.18 ± 0.2% | | 1.00 | 1.19 | 6.42 |
| imported/rsc/easy0-32k | 26 | 22983.93 ± 1.8% | not timed | not timed | 20299.55 ± 0.1% | 18808.30 ± 30.8% | not timed | not timed | 23025.67 ± 0.3% | | 1.00 | 1.13 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21606.50 ± 2.0% | not timed | not timed | 19678.51 ± 1.7% | 36058.86 ± 4.4% | not timed | not timed | 21404.51 ± 2.9% | | 1.01 | 1.10 | 0.60 |
| imported/rsc/easy1-32 | 19 | 806.88 ± 8.4% | not timed | not timed | 640.60 ± 0.5% | 139.09 ± 19.0% | not timed | not timed | 804.57 ± 2.4% | | 1.00 | 1.26 | 5.80 |
| imported/rsc/easy1-1k | 19 | 16454.04 ± 2.4% | not timed | not timed | 12940.07 ± 0.1% | 2497.19 ± 17.1% | not timed | not timed | 16456.45 ± 2.0% | | 1.00 | 1.27 | 6.59 |
| imported/rsc/easy1-32k | 19 | 516753.90 ± 2.3% | not timed | not timed | 410673.95 ± 0.3% | 20446.45 ± 25.6% | not timed | not timed | 504901.19 ± 0.2% | | 1.02 | 1.26 | 25.27 |
| imported/rsc/easy1-1mb | 19 | 16547942.95 ± 0.2% | not timed | not timed | 13188148.60 ± 0.2% | 39304.59 ± 1.3% | not timed | not timed | 16528733.89 ± 0.2% | | 1.00 | 1.25 | 421.02 |
| imported/rsc/medium-32 | 27 | 768.41 ± 2.0% | not timed | not timed | 641.94 ± 0.9% | 69.97 ± 10.8% | not timed | not timed | 772.91 ± 0.1% | | 0.99 | 1.20 | 10.98 |
| imported/rsc/medium-1k | 27 | 13679.61 ± 0.5% | not timed | not timed | 11421.84 ± 0.3% | 72.44 ± 0.1% | not timed | not timed | 13768.24 ± 0.3% | | 0.99 | 1.20 | 188.85 |
| imported/rsc/medium-32k | 27 | 425371.75 ± 0.7% | not timed | not timed | 352121.15 ± 0.2% | 48.40 ± 0.1% | not timed | not timed | 429945.18 ± 0.3% | | 0.99 | 1.21 | 8788.46 |
| imported/rsc/medium-1mb | 27 | 13622903.57 ± 0.4% | not timed | not timed | 11403644.16 ± 0.1% | 48.37 ± 0.1% | not timed | not timed | 13716122.71 ± 0.4% | | 0.99 | 1.19 | 281658.46 |
| imported/rsc/hard-32 | 58 | 420.78 ± 1.9% | not timed | not timed | 368.89 ± 0.2% | 49.52 ± 7.4% | not timed | not timed | 418.11 ± 0.2% | | 1.01 | 1.14 | 8.50 |
| imported/rsc/hard-1k | 27 | 13370.23 ± 1.2% | not timed | not timed | 11491.06 ± 0.2% | 40.85 ± 0.1% | not timed | not timed | 13335.42 ± 1.0% | | 1.00 | 1.16 | 327.33 |
| imported/rsc/hard-32k | 27 | 414342.49 ± 0.5% | not timed | not timed | 359147.32 ± 0.1% | 29.36 ± 0.1% | not timed | not timed | 417357.89 ± 0.6% | | 0.99 | 1.15 | 14111.95 |
| imported/rsc/hard-1mb | 51 | 8396678.80 ± 0.4% | not timed | not timed | 7191359.71 ± 0.1% | 29.44 ± 0.1% | not timed | not timed | 8327840.02 ± 0.2% | | 1.01 | 1.17 | 285223.53 |
| imported/rsc/reallyhard0-32 | 58 | 267.02 ± 2.2% | not timed | not timed | 223.21 ± 0.1% | 49.37 ± 8.3% | not timed | not timed | 266.95 ± 0.2% | | 1.00 | 1.20 | 5.41 |
| imported/rsc/reallyhard0-1k | 27 | 589.04 ± 0.1% | not timed | not timed | 581.71 ± 0.1% | 40.71 ± 0.2% | not timed | not timed | 590.04 ± 0.2% | | 1.00 | 1.01 | 14.47 |
| imported/rsc/reallyhard0-32k | 27 | 611.21 ± 0.3% | not timed | not timed | 616.76 ± 0.2% | 29.41 ± 0.2% | not timed | not timed | 610.76 ± 0.2% | | 1.00 | 0.99 | 20.79 |
| imported/rsc/reallyhard0-1mb | 51 | 591.93 ± 0.8% | not timed | not timed | 612.96 ± 0.1% | 29.45 ± 0.1% | not timed | not timed | 590.24 ± 1.3% | | 1.00 | 0.97 | 20.10 |
| imported/rsc/reallyreallyhard0-32 | 47 | 288.58 ± 1.7% | not timed | not timed | 195.97 ± 0.9% | 61.29 ± 15.9% | not timed | not timed | 288.90 ± 1.5% | | 1.00 | 1.47 | 4.71 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6770.74 ± 0.1% | not timed | not timed | 5961.50 ± 0.1% | 34.39 ± 0.1% | not timed | not timed | 6765.09 ± 0.2% | | 1.00 | 1.14 | 196.90 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21483.77 ± 0.1% | not timed | not timed | 19252.55 ± 0.1% | 24.99 ± 0.3% | not timed | not timed | 21499.81 ± 0.0% | | 1.00 | 1.12 | 859.85 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21664.17 ± 2.4% | not timed | not timed | 19859.96 ± 3.3% | 25.06 ± 0.3% | not timed | not timed | 21723.23 ± 1.0% | | 1.00 | 1.09 | 864.40 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.74 ± 1.7% | not timed | not timed | 214.37 ± 0.4% | 60.89 ± 12.2% | not timed | not timed | 282.69 ± 1.4% | | 1.00 | 1.32 | 4.64 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5888.87 ± 0.1% | not timed | not timed | 6246.29 ± 0.2% | 33.80 ± 1.0% | not timed | not timed | 5871.05 ± 0.1% | | 1.00 | 0.94 | 174.24 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21415.03 ± 0.1% | not timed | not timed | 19265.09 ± 0.1% | 24.72 ± 2.4% | not timed | not timed | 21429.83 ± 0.1% | | 1.00 | 1.11 | 866.18 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 20721.57 ± 2.3% | not timed | not timed | 19209.84 ± 1.2% | 24.89 ± 1.8% | not timed | not timed | 20817.25 ± 1.9% | | 1.00 | 1.08 | 832.63 |
| imported/sherlock/name-sherlock | 776 | 19551.47 ± 1.9% | not timed | not timed | 18293.94 ± 0.7% | 9877.66 ± 26.9% | not timed | not timed | 19591.10 ± 2.0% | | 1.00 | 1.07 | 1.98 |
| imported/sherlock/name-holmes | 2766 | 15052.68 ± 1.6% | not timed | not timed | 15422.08 ± 1.1% | 3142.70 ± 13.7% | not timed | not timed | 15171.06 ± 1.5% | | 0.99 | 0.98 | 4.79 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19533.08 ± 1.7% | not timed | not timed | 18193.28 ± 1.0% | 7936.22 ± 24.6% | not timed | not timed | 19537.22 ± 1.9% | | 1.00 | 1.07 | 2.46 |
| imported/sherlock/name-sherlock-casei | 816 | 15623.62 ± 0.6% | not timed | not timed | 4010.54 ± 0.4% | 32.61 ± 0.3% | not timed | not timed | 15626.22 ± 0.9% | | 1.00 | 3.90 | 479.15 |
| imported/sherlock/name-holmes-casei | 2802 | 9352.66 ± 7.7% | not timed | not timed | 3310.19 ± 0.1% | 37.58 ± 0.5% | not timed | not timed | 9431.16 ± 7.4% | | 0.99 | 2.83 | 248.89 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13035.22 ± 8.5% | not timed | not timed | 3950.21 ± 0.2% | 32.58 ± 0.2% | not timed | not timed | 13082.18 ± 1.1% | | 1.00 | 3.30 | 400.06 |
| imported/sherlock/name-whitespace | 1461 | 15155.84 ± 1.9% | not timed | not timed | 14354.41 ± 0.2% | 6430.68 ± 20.1% | not timed | not timed | 15221.78 ± 1.7% | | 1.00 | 1.06 | 2.36 |
| imported/sherlock/name-alt1 | 1142 | 11617.61 ± 0.5% | not timed | not timed | 16030.95 ± 0.9% | 4089.27 ± 22.7% | not timed | not timed | 11616.98 ± 2.6% | | 1.00 | 0.72 | 2.84 |
| imported/sherlock/name-alt2 | 3542 | 8952.31 ± 0.2% | not timed | not timed | 3828.77 ± 0.2% | 31.44 ± 0.1% | not timed | not timed | 8949.38 ± 0.1% | | 1.00 | 2.34 | 284.73 |
| imported/sherlock/name-alt3 | 4507 | 5569.27 ± 0.8% | not timed | not timed | 3628.50 ± 0.2% | 9.95 ± 4.3% | not timed | not timed | 5564.32 ± 0.4% | | 1.00 | 1.53 | 559.98 |
| imported/sherlock/name-alt3-casei | 4593 | 1528.56 ± 2.5% | not timed | not timed | 285.01 ± 0.2% | 6.49 ± 0.2% | not timed | not timed | 1529.74 ± 1.1% | | 1.00 | 5.36 | 235.49 |
| imported/sherlock/name-alt4 | 3686 | 6392.19 ± 0.4% | not timed | not timed | 3778.25 ± 0.1% | 31.46 ± 0.1% | not timed | not timed | 6391.64 ± 0.4% | | 1.00 | 1.69 | 203.16 |
| imported/sherlock/name-alt4-casei | 4254 | 2804.61 ± 2.3% | not timed | not timed | 2569.63 ± 0.2% | 19.89 ± 0.3% | not timed | not timed | 2813.04 ± 1.0% | | 1.00 | 1.09 | 140.97 |
| imported/sherlock/name-alt5 | 4028 | 6432.87 ± 0.4% | not timed | not timed | 3746.54 ± 0.2% | 21.72 ± 0.1% | not timed | not timed | 6438.97 ± 0.3% | | 1.00 | 1.72 | 296.21 |
| imported/sherlock/name-alt5-casei | 4104 | 3499.82 ± 1.7% | not timed | not timed | 2224.14 ± 0.1% | 14.37 ± 0.1% | not timed | not timed | 3513.48 ± 0.9% | | 1.00 | 1.57 | 243.54 |
| imported/sherlock/no-match-uncommon | 0 | 21307.67 ± 0.7% | not timed | not timed | 19158.69 ± 0.9% | 34146.83 ± 0.7% | not timed | not timed | 21276.04 ± 0.7% | | 1.00 | 1.11 | 0.62 |
| imported/sherlock/no-match-common | 0 | 21011.05 ± 0.8% | not timed | not timed | 19171.09 ± 1.0% | 1278.81 ± 0.4% | not timed | not timed | 21043.38 ± 0.9% | | 1.00 | 1.10 | 16.43 |
| imported/sherlock/no-match-really-common | 0 | 15891.63 ± 2.2% | not timed | not timed | 18467.03 ± 1.1% | 1282.68 ± 1.3% | not timed | not timed | 16047.85 ± 1.5% | | 0.99 | 0.86 | 12.39 |
| imported/sherlock/the-lower | 21654 | 2318.98 ± 0.9% | not timed | not timed | 2337.67 ± 0.5% | 246.71 ± 16.7% | not timed | not timed | 2327.69 ± 1.7% | | 1.00 | 0.99 | 9.40 |
| imported/sherlock/the-upper | 2223 | 11637.65 ± 10.4% | not timed | not timed | 13493.62 ± 0.6% | 2746.62 ± 25.3% | not timed | not timed | 12702.90 ± 1.0% | | 0.92 | 0.86 | 4.24 |
| imported/sherlock/the-casei | 23961 | 2014.96 ± 0.3% | not timed | not timed | 1312.58 ± 0.3% | 34.88 ± 1.6% | not timed | not timed | 2015.04 ± 0.3% | | 1.00 | 1.54 | 57.77 |
| imported/sherlock/everything-greedy | 581881 | 283.45 ± 0.7% | not timed | not timed | 165.40 ± 0.2% | 28.26 ± 31.1% | not timed | not timed | 283.46 ± 0.7% | | 1.00 | 1.71 | 10.03 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.62 ± 0.1% | not timed | not timed | 211.86 ± 0.8% | 32.90 ± 0.2% | not timed | not timed | 462.68 ± 0.2% | | 1.00 | 2.18 | 14.06 |
| imported/sherlock/letters | 447175 | 62.36 ± 0.3% | not timed | not timed | 32.96 ± 0.1% | 6.69 ± 5.5% | not timed | not timed | 62.46 ± 0.3% | | 1.00 | 1.89 | 9.32 |
| imported/sherlock/letters-upper | 14180 | 453.73 ± 2.2% | not timed | not timed | 368.93 ± 0.2% | 29.73 ± 22.5% | not timed | not timed | 453.31 ± 0.1% | | 1.00 | 1.23 | 15.26 |
| imported/sherlock/letters-lower | 432995 | 63.46 ± 1.3% | not timed | not timed | 33.88 ± 0.1% | 5.38 ± 33.8% | not timed | not timed | 63.41 ± 1.1% | | 1.00 | 1.87 | 11.78 |
| imported/sherlock/words | 447639 | 115.89 ± 0.4% | not timed | not timed | 83.03 ± 0.1% | 15.81 ± 16.2% | not timed | not timed | 115.94 ± 0.5% | | 1.00 | 1.40 | 7.33 |
| imported/sherlock/before-holmes | 4073 | 10241.60 ± 0.6% | not timed | not timed | 8385.78 ± 0.5% | 23.91 ± 1.2% | not timed | not timed | 10266.86 ± 0.4% | | 1.00 | 1.22 | 428.42 |
| imported/sherlock/before-after-holmes | 2593 | 9859.93 ± 0.7% | not timed | not timed | 9463.59 ± 0.5% | 23.97 ± 2.0% | not timed | not timed | 9876.93 ± 0.6% | | 1.00 | 1.04 | 411.39 |
| imported/sherlock/holmes-cochar-watson | 150 | 5185.38 ± 0.3% | not timed | not timed | 3423.99 ± 0.3% | 31.00 ± 0.1% | not timed | not timed | 5200.54 ± 0.3% | | 1.00 | 1.51 | 167.28 |
| imported/sherlock/holmes-coword-watson | 14309 | 1192.37 ± 0.7% | not timed | not timed | 1122.68 ± 0.3% | 6.79 ± 0.2% | not timed | not timed | 1193.36 ± 0.4% | | 1.00 | 1.06 | 175.56 |
| imported/sherlock/quotes | 14437 | 1396.31 ± 0.3% | not timed | not timed | 1769.03 ± 0.9% | 34.95 ± 0.1% | not timed | not timed | 1399.34 ± 0.3% | | 1.00 | 0.79 | 39.95 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 609.96 ± 0.1% | not timed | not timed | 15798.04 ± 0.3% | 36.70 ± 0.3% | not timed | not timed | 609.54 ± 0.3% | | 1.00 | 0.0386 | 16.62 |
| imported/sherlock/word-ending-n | 35297 | 480.89 ± 0.3% | not timed | not timed | 408.71 ± 0.1% | 23.36 ± 20.8% | not timed | not timed | 480.80 ± 1.2% | | 1.00 | 1.18 | 20.58 |
| imported/sherlock/repeated-class-negation | 2130 | 14535.52 ± 1.2% | not timed | not timed | 10710.53 ± 2.3% | 11.58 ± 0.1% | not timed | not timed | 14541.22 ± 1.0% | | 1.00 | 1.36 | 1255.05 |
| imported/sherlock/ing-suffix | 20547 | 566.21 ± 0.4% | not timed | not timed | 517.25 ± 0.1% | 28.84 ± 11.1% | not timed | not timed | 566.72 ± 9.1% | | 1.00 | 1.09 | 19.63 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 607.02 ± 0.9% | not timed | not timed | 2100.24 ± 0.7% | 20.55 ± 0.2% | not timed | not timed | 608.39 ± 0.4% | | 1.00 | 0.29 | 29.54 |
| opt/accelerate/whole-line | 239963 | 458.32 ± 0.1% | not timed | not timed | 362.39 ± 0.1% | 92.35 ± 17.3% | not timed | not timed | 458.47 ± 0.3% | | 1.00 | 1.26 | 4.96 |
| opt/accelerate/non-dna | 16745 | 426.09 ± 0.9% | not timed | not timed | 400.03 ± 0.2% | 29.68 ± 24.2% | not timed | not timed | 428.71 ± 0.7% | | 0.99 | 1.07 | 14.36 |
| opt/backtrack/words-english | 40536 | 136.70 ± 1.7% | not timed | not timed | 95.10 ± 0.1% | 19.76 ± 7.1% | not timed | not timed | 136.50 ± 4.5% | | 1.00 | 1.44 | 6.92 |
| opt/fixed-length/too-small-ascii | 0 | 311.07 ± 0.4% | not timed | not timed | 681.95 ± 3.4% | 80.33 ± 0.5% | not timed | not timed | 314.63 ± 0.4% | | 0.99 | 0.46 | 3.87 |
| opt/fixed-length/too-big-ascii | 0 | 3494.85 ± 0.4% | not timed | not timed | 5781.96 ± 0.4% | 123.31 ± 0.4% | not timed | not timed | 3473.76 ± 0.6% | | 1.01 | 0.60 | 28.34 |
| opt/fixed-length/go33484-1 | 0 | 671119.77 ± 0.4% | not timed | not timed | 1114379.28 ± 0.7% | 61725.03 ± 0.3% | not timed | not timed | 668315.05 ± 0.5% | | 1.00 | 0.60 | 10.87 |
| opt/fixed-length/go33484-2 | 0 | 671323.69 ± 0.5% | not timed | not timed | 1106382.80 ± 0.7% | 32534.38 ± 3.3% | not timed | not timed | 668812.44 ± 0.6% | | 1.00 | 0.61 | 20.63 |
| opt/fixed-length/go33484-3 | 0 | 2415.01 ± 3.4% | not timed | not timed | 110982.19 ± 0.2% | 767.23 ± 0.5% | not timed | not timed | 2486.77 ± 3.0% | | 0.97 | 0.0218 | 3.15 |
| opt/literal-alt/one-pattern | 1 | 548.43 ± 1.6% | not timed | not timed | 543.46 ± 0.2% | 0.40 ± 0.2% | not timed | not timed | 547.76 ± 1.3% | | 1.00 | 1.01 | 1364.76 |
| opt/onepass/fn-predicate | 916 | 370.37 ± 0.7% | not timed | not timed | 331.51 ± 0.2% | 202.72 ± 14.6% | not timed | not timed | 373.38 ± 0.5% | | 0.99 | 1.12 | 1.83 |
| opt/onepass/first-three-words-english | 35128 | 174.46 ± 1.7% | not timed | not timed | 200.16 ± 0.1% | 77.55 ± 11.5% | not timed | not timed | 176.66 ± 0.9% | | 0.99 | 0.87 | 2.25 |
| opt/prefilter/literal-english | 1 | 20226.11 ± 0.7% | not timed | not timed | 19480.36 ± 0.4% | 17334.19 ± 1.0% | not timed | not timed | 20242.78 ± 0.3% | | 1.00 | 1.04 | 1.17 |
| opt/prefilter/literal-casei-english | 1 | 14423.78 ± 0.6% | not timed | not timed | 4315.72 ± 0.2% | 31.49 ± 1.0% | not timed | not timed | 14424.42 ± 0.7% | | 1.00 | 3.34 | 458.09 |
| opt/prefilter/literal-russian | 1 | 20859.27 ± 0.6% | not timed | not timed | 19568.64 ± 0.9% | 3324.58 ± 0.2% | not timed | not timed | 20886.20 ± 1.3% | | 1.00 | 1.07 | 6.27 |
| opt/prefilter/literal-casei-russian | 1 | 8593.93 ± 0.8% | not timed | not timed | 3886.89 ± 0.2% | 31.37 ± 0.2% | not timed | not timed | 8590.66 ± 0.7% | | 1.00 | 2.21 | 273.94 |
| opt/prefilter/rust-functions | 948 | 6819.11 ± 0.2% | not timed | not timed | 8973.22 ± 0.2% | 1868.99 ± 0.3% | not timed | not timed | 6828.80 ± 0.2% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 29945203.52 ± 0.1% | not timed | not timed | 21695292.21 ± 0.5% | 50.07 ± 0.5% | not timed | not timed | 29910689.62 ± 0.1% | | 1.00 | 1.38 | 598053.92 |
| opt/reverse-inner/holmes | 2593 | 9866.11 ± 0.9% | not timed | not timed | 9422.82 ± 0.4% | 23.84 ± 0.6% | not timed | not timed | 9880.56 ± 0.7% | | 1.00 | 1.05 | 413.91 |
| opt/reverse-inner/email | 47 | 36503.56 ± 1.7% | not timed | not timed | 45054.45 ± 0.3% | 32.32 ± 0.7% | not timed | not timed | 36982.01 ± 2.0% | | 0.99 | 0.81 | 1129.37 |
| opt/reverse-inner/factored-prefix | 3542 | 601.13 ± 0.1% | not timed | not timed | 595.84 ± 0.0% | 11.98 ± 1.3% | not timed | not timed | 600.52 ± 0.1% | | 1.00 | 1.01 | 50.16 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5553.42 ± 0.1% | not timed | not timed | 615.97 ± 0.2% | 75.25 ± 0.1% | not timed | not timed | 5531.84 ± 0.0% | | 1.00 | 9.02 | 73.80 |
| opt/reverse-inner/no-quadratic-forward | 0 | 686.93 ± 1.8% | not timed | not timed | 287.31 ± 0.2% | 24.50 ± 0.1% | not timed | not timed | 687.44 ± 2.0% | | 1.00 | 2.39 | 28.04 |
| opt/reverse-suffix/holmes | 4073 | 10256.93 ± 0.7% | not timed | not timed | 8355.53 ± 0.6% | 24.07 ± 1.5% | not timed | not timed | 10276.89 ± 0.6% | | 1.00 | 1.23 | 426.14 |
| opt/reverse-suffix/no-quadratic | 0 | 5532.40 ± 0.1% | not timed | not timed | 611.79 ± 0.2% | 75.10 ± 0.1% | not timed | not timed | 5559.08 ± 0.0% | | 1.00 | 9.04 | 73.66 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 122.03 ± 3.2% | not timed | not timed | 131.73 ± 0.6% | 13.50 ± 15.4% | not timed | not timed | 122.21 ± 2.3% | | 1.00 | 0.93 | 9.04 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 122.48 ± 1.9% | not timed | not timed | 128.82 ± 0.3% | 13.90 ± 16.1% | not timed | not timed | 122.41 ± 8.3% | | 1.00 | 0.95 | 8.81 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.3% | not timed | not timed | 0.55 ± 0.4% | 114.13 ± 0.7% | not timed | not timed | 0.28 ± 0.2% | | 1.00 | 0.50 | 0.0024 |
| reported/i1095-word-repetition/ascii-search | 256 | 317.75 ± 0.4% | not timed | not timed | 293.80 ± 0.2% | 104.26 ± 7.6% | not timed | not timed | 316.06 ± 3.6% | | 1.01 | 1.08 | 3.05 |
| reported/i13-subset-regex/original-ascii | 4094 | 10969.84 ± 15.3% | not timed | not timed | 4522.71 ± 0.4% | 11.49 ± 0.1% | not timed | not timed | 11172.57 ± 3.8% | | 0.98 | 2.43 | 954.44 |
| reported/i13-subset-regex/original-unicode | 4094 | 11016.50 ± 1.1% | not timed | not timed | 253.44 ± 3.0% | 11.50 ± 0.1% | not timed | not timed | 11194.00 ± 1.0% | | 0.98 | 43.47 | 958.16 |
| reported/i13-subset-regex/big-ascii | 1955 | 10676.91 ± 1.0% | not timed | not timed | 68.25 ± 3.6% | 9.83 ± 0.2% | not timed | not timed | 10715.52 ± 1.0% | | 1.00 | 156.45 | 1086.58 |
| reported/i13-subset-regex/big-unicode | 1955 | 10600.52 ± 1.3% | not timed | not timed | 12.22 ± 54.9% | 9.83 ± 0.3% | not timed | not timed | 10682.95 ± 0.9% | | 0.99 | 867.16 | 1078.35 |
| reported/i13-subset-regex/huge-ascii | 55 | 10111.45 ± 1.2% | not timed | not timed | 11.03 ± 0.1% | 8.70 ± 0.1% | not timed | not timed | 10084.68 ± 2.5% | | 1.00 | 917.09 | 1161.87 |
| reported/i13-subset-regex/huge-unicode | 55 | 9923.06 ± 40.1% | not timed | not timed | 10.97 ± 0.3% | 8.77 ± 0.1% | not timed | not timed | 9864.59 ± 14.0% | | 1.01 | 904.42 | 1131.85 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.57 ± 0.1% | not timed | not timed | 11.04 ± 0.0% | 8.76 ± 0.0% | not timed | not timed | 3.56 ± 0.1% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.05 ± 0.1% | not timed | not timed | 11.01 ± 0.3% | 8.75 ± 1.0% | not timed | not timed | 5.04 ± 0.1% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 486.67 ± 0.3% | not timed | not timed | 104.21 ± 0.2% | 6.60 ± 0.2% | not timed | not timed | 487.42 ± 0.3% | | 1.00 | 4.67 | 73.77 |
| reported/i787-keywords/opt-ascii | 5674 | 488.67 ± 0.2% | not timed | not timed | 273.00 ± 0.5% | 10.26 ± 0.1% | not timed | not timed | 489.07 ± 0.3% | | 1.00 | 1.79 | 47.65 |
| slow/quadratic-regex-1x | 100 | 7.13 ± 0.1% | not timed | not timed | 4.95 ± 0.1% | 0.05 ± 0.4% | not timed | not timed | 7.14 ± 0.3% | | 1.00 | 1.44 | 144.18 |
| slow/quadratic-regex-2x | 199 | 3.43 ± 0.1% | not timed | not timed | 2.76 ± 0.1% | 0.01 ± 0.2% | not timed | not timed | 3.43 ± 0.2% | | 1.00 | 1.24 | 268.82 |
| slow/quadratic-haystack-1x | 100 | 21.36 ± 6.6% | not timed | not timed | 10.02 ± 0.3% | 1.02 ± 13.1% | not timed | not timed | 21.43 ± 1.6% | | 1.00 | 2.13 | 21.02 |
| slow/quadratic-haystack-2x | 200 | 17.74 ± 1.3% | not timed | not timed | 5.51 ± 0.3% | 0.55 ± 0.5% | not timed | not timed | 17.81 ± 12.8% | | 1.00 | 3.22 | 32.41 |
| unicode/codepoints/any-one | 1112064 | 289.87 ± 1.1% | not timed | not timed | 173.03 ± 0.1% | 17.63 ± 23.9% | not timed | not timed | 289.69 ± 0.4% | | 1.00 | 1.68 | 16.44 |
| unicode/codepoints/any-all | 4382592 | 268.87 ± 1.5% | not timed | not timed | 246.23 ± 0.2% | 117.41 ± 0.1% | not timed | not timed | 269.68 ± 1.2% | | 1.00 | 1.09 | 2.29 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.68 ± 0.6% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 600.89 ± 1.1% | not timed | not timed | 615.57 ± 0.1% | 135.58 ± 0.3% | not timed | not timed | 603.30 ± 0.9% | | 1.00 | 0.98 | 4.43 |
| unicode/overlapping-words/ascii | 6156 | 31.61 ± 0.4% | not timed | not timed | 38.96 ± 0.0% | 3.71 ± 6.6% | not timed | not timed | 31.59 ± 7.0% | | 1.00 | 0.81 | 8.53 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.1% | not timed | not timed | 4.47 ± 0.2% | 2.36 ± 6.5% | not timed | not timed | 1.45 ± 1.3% | | 0.99 | 0.32 | 0.61 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 1.2% | not timed | not timed | 4.14 ± 0.2% | 6.30 ± 8.0% | not timed | not timed | 1.29 ± 0.1% | | 0.99 | 0.31 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 127.75 ± 2.0% | not timed | not timed | 82.70 ± 0.1% | 13.14 ± 27.8% | not timed | not timed | 128.94 ± 7.7% | | 0.99 | 1.54 | 9.72 |
| unicode/word/boundary-long-english | 3466 | 615.11 ± 0.2% | not timed | not timed | 603.47 ± 0.1% | 32.32 ± 1.1% | not timed | not timed | 615.92 ± 0.2% | | 1.00 | 1.02 | 19.03 |
| unicode/word/around-holmes-english | 27 | 19386.58 ± 0.3% | not timed | not timed | 19267.61 ± 0.5% | 22.17 ± 0.4% | not timed | not timed | 19425.51 ± 0.2% | | 1.00 | 1.01 | 874.64 |
| wild/bibleref/long | 874 | 563.32 ± 0.4% | not timed | not timed | 583.34 ± 0.0% | 6.83 ± 0.2% | not timed | not timed | 564.41 ± 0.4% | | 1.00 | 0.97 | 82.53 |
| wild/bibleref/short | 30 | 24.88 ± 4.1% | not timed | not timed | 30.78 ± 0.3% | 14.12 ± 8.6% | not timed | not timed | 25.51 ± 2.5% | | 0.98 | 0.81 | 1.76 |
| wild/bibleref/line | 874 | 393.86 ± 0.1% | not timed | not timed | 212.80 ± 0.1% | 9.14 ± 0.2% | not timed | not timed | 393.94 ± 0.1% | | 1.00 | 1.85 | 43.11 |
| wild/caddy/caddy | 6 | 418.29 ± 9.1% | not timed | not timed | 248.01 ± 0.2% | 67.42 ± 12.3% | not timed | not timed | 418.73 ± 0.2% | | 1.00 | 1.69 | 6.20 |
| wild/dot-star-capture/rust-src-tools | 6 | 1059.60 ± 0.2% | not timed | not timed | 350.44 ± 0.3% | 13.56 ± 0.1% | not timed | not timed | 1059.27 ± 0.2% | | 1.00 | 3.02 | 78.15 |
| wild/ruff/noqa | 84 | 436.35 ± 0.1% | not timed | not timed | 464.35 ± 0.1% | 19.51 ± 2.3% | not timed | not timed | 434.94 ± 0.1% | | 1.00 | 0.94 | 22.37 |
| wild/ruff/unnecessary-coding-comment | 16 | 962.59 ± 0.3% | not timed | not timed | 698.87 ± 0.2% | 136.32 ± 11.1% | not timed | not timed | 959.70 ± 0.6% | | 1.00 | 1.38 | 7.06 |
| wild/ruff/string-quote-prefix | 2972 | 1359.03 ± 0.7% | not timed | not timed | 439.20 ± 0.1% | 316.99 ± 25.6% | not timed | not timed | 1359.46 ± 0.7% | | 1.00 | 3.09 | 4.29 |
| wild/ruff/space-around-operator | 1224378 | 220.15 ± 1.9% | not timed | not timed | 187.15 ± 0.1% | 18.25 ± 1.7% | not timed | not timed | 221.01 ± 1.4% | | 1.00 | 1.18 | 12.06 |
| wild/ruff/shebang | 282 | 984.79 ± 0.4% | not timed | not timed | 331.54 ± 0.1% | 120.84 ± 10.0% | not timed | not timed | 988.85 ± 0.4% | | 1.00 | 2.97 | 8.15 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13837.91 ± 0.4% | not timed | not timed | 13871.49 ± 0.5% | 6954.62 ± 0.7% | not timed | not timed | 13855.64 ± 0.1% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12847.29 ± 0.3% | not timed | not timed | 13509.81 ± 0.6% | 6426.18 ± 0.7% | not timed | not timed | 12849.05 ± 0.3% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13213.68 ± 0.3% | not timed | not timed | 13657.26 ± 0.7% | 6711.55 ± 36.8% | not timed | not timed | 13231.53 ± 4.1% | | 1.00 | 0.97 | 1.97 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9581.66 ± 0.3% | not timed | not timed | 13583.67 ± 0.1% | 6791.70 ± 0.3% | not timed | not timed | 9574.94 ± 0.4% | | 1.00 | 0.71 | 1.41 |
| wild/url/search | 234965 | 121.77 ± 15.1% | not timed | not timed | 65.75 ± 0.6% | 2.23 ± 0.8% | not timed | not timed | 122.95 ± 14.0% | | 0.99 | 1.85 | 54.55 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 1.3% | not timed | not timed | 0.01 ± 1.3% | 0.01 ± 11.0% | not timed | not timed | 0.03 ± 8.6% | | 0.99 | 3.06 | 4.05 |
| dictionary/compile/english-15 | 1 | 0.35 ± 20.6% | not timed | not timed | 0.07 ± 0.6% | 0.10 ± 13.8% | not timed | not timed | 0.35 ± 1.6% | | 1.00 | 4.95 | 3.34 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 1.6% | not timed | not timed | 0.02 ± 0.8% | 36.04 ± 13.4% | not timed | not timed | 0.25 ± 4.3% | | 1.00 | 12.99 | 0.0069 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.47 ± 1.2% | not timed | not timed | 11.49 ± 0.5% | 60.46 ± 21.8% | not timed | not timed | 47.60 ± 2.1% | | 1.00 | 4.13 | 0.79 |
| reported/i787-keywords/compile | 1 | 34.52 ± 4.4% | not timed | not timed | 2.14 ± 0.2% | 16.59 ± 33.3% | not timed | not timed | 34.62 ± 2.2% | | 1.00 | 16.16 | 2.08 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 364.96 ± 3.0% | not timed | not timed | 121.24 ± 0.5% | 565.73 ± 31.2% | not timed | not timed | 369.33 ± 4.4% | | 0.99 | 3.01 | 0.65 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 45.92 ± 1.8% | not timed | not timed | 4.09 ± 1.0% | 43.33 ± 10.6% | not timed | not timed | 46.63 ± 3.3% | | 0.98 | 11.23 | 1.06 |
| unicode/compile/one-letter | 53 | 6.70 ± 10.5% | not timed | not timed | 4.51 ± 0.5% | 66.01 ± 4.3% | not timed | not timed | 6.71 ± 14.4% | | 1.00 | 1.49 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.06 ± 18.3% | not timed | not timed | 0.10 ± 0.4% | 68.20 ± 13.0% | not timed | not timed | 1.09 ± 13.2% | | 0.97 | 10.61 | 0.0155 |
| unicode/compile/fifty-letters-ascii | 1 | 219.25 ± 3.1% | not timed | not timed | 53.53 ± 0.3% | 202.71 ± 37.1% | not timed | not timed | 222.39 ± 4.6% | | 0.99 | 4.10 | 1.08 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 376.96 ± 5.9% | not timed | not timed | 46.26 ± 1.0% | 674.70 ± 29.8% | not timed | not timed | 387.46 ± 1.1% | | 0.97 | 8.15 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 610.15 ± 17.3% | not timed | not timed | 144.14 ± 0.2% | 679.51 ± 20.1% | not timed | not timed | 617.78 ± 4.0% | | 0.99 | 4.23 | 0.90 |
| unicode/compile/negated-class-matches-codepoint | 1 | 316.98 ± 13.5% | not timed | not timed | 51.16 ± 0.3% | 1243.38 ± 25.9% | not timed | not timed | 331.60 ± 1.9% | | 0.96 | 6.20 | 0.25 |
| wild/bibleref/compile | 3 | 5.76 ± 4.1% | not timed | not timed | 1.92 ± 0.9% | 32.35 ± 3.7% | not timed | not timed | 5.89 ± 3.8% | | 0.98 | 3.00 | 0.18 |
| wild/url/compile | 1 | 0.63 ± 18.3% | not timed | not timed | 0.15 ± 0.6% | 0.42 ± 26.1% | not timed | not timed | 0.63 ± 0.5% | | 1.00 | 4.32 | 1.49 |

