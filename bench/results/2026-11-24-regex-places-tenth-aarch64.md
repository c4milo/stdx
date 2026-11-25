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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507016562 |
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
| literal: a word | 217 | 19073.28 ± 4.7% | 5084.86 ± 0.4% | 27.74 ± 0.4% | 17878.08 ± 1.7% | 9198.51 ± 7.3% | 17.29 ± 0.1% | 85.87 ± 0.3% | 19067.82 ± 5.2% | 3.75 | 1.00 | 1.07 | 2.07 |
| literal: a word that is not there | 0 | 21256.96 ± 0.9% | 4948.15 ± 0.3% | 27.79 ± 0.4% | 19623.51 ± 3.8% | 26855.88 ± 1.9% | 17.13 ± 0.1% | 81.83 ± 0.2% | 21051.23 ± 3.7% | 4.30 | 1.01 | 1.08 | 0.79 |
| literal: one of four words | 661 | 6433.16 ± 0.4% | 1978.72 ± 0.1% | 14.28 ± 0.1% | 3942.78 ± 0.2% | 21.90 ± 0.1% | 5.39 ± 0.1% | 6.74 ± 0.2% | 6437.45 ± 0.4% | 3.25 | 1.00 | 1.63 | 293.70 |
| literal: a word in any case | 217 | 15068.41 ± 0.7% | 2106.08 ± 0.3% | 21.23 ± 0.3% | 3972.60 ± 0.2% | 38.07 ± 0.2% | refused | differs | 15095.23 ± 1.4% | 7.15 | 1.00 | 3.79 | 395.85 |
| literal: an href attribute | 33 | 16556.25 ± 1.1% | 617.97 ± 0.2% | 26.91 ± 0.3% | 16803.06 ± 2.0% | 2263.66 ± 0.5% | 13.08 ± 0.2% | 74.88 ± 0.2% | 16479.58 ± 1.0% | 26.79 | 1.00 | 0.99 | 7.31 |
| literal: a word, second text | 123 | 19347.10 ± 3.4% | 3428.09 ± 0.4% | 27.55 ± 0.3% | 17922.96 ± 3.4% | 7614.34 ± 6.9% | 20.00 ± 0.2% | 68.31 ± 0.4% | 19406.25 ± 4.5% | 5.64 | 1.00 | 1.08 | 2.54 |
| class: two capitalized words | 1331 | 1065.61 ± 0.5% | 609.62 ± 0.2% | 25.63 ± 0.2% | 585.35 ± 0.0% | 40.62 ± 7.9% | 14.75 ± 0.2% | 68.11 ± 0.3% | 1064.36 ± 0.5% | 1.75 | 1.00 | 1.82 | 26.24 |
| class: a word that ends in ing | 3399 | 583.01 ± 0.1% | 582.59 ± 0.2% | 17.81 ± 1.2% | 547.89 ± 0.3% | 29.65 ± 5.4% | 8.14 ± 0.1% | 18.21 ± 0.6% | 583.91 ± 0.1% | 1.00 | 1.00 | 1.06 | 19.66 |
| class: a word in capitals | 2332 | 1389.29 ± 0.5% | 614.60 ± 0.1% | 27.14 ± 0.9% | 572.38 ± 0.1% | 43.58 ± 2.7% | 17.16 ± 0.3% | 82.70 ± 0.5% | 1394.42 ± 0.6% | 2.26 | 1.00 | 2.43 | 31.88 |
| class: a number | 8288 | 2110.51 ± 0.3% | 852.43 ± 0.1% | 27.32 ± 0.2% | 1722.77 ± 0.1% | 42.30 ± 14.3% | 0.55 ± 0.1% | 56.63 ± 0.4% | 2131.68 ± 0.3% | 2.48 | 0.99 | 1.23 | 49.90 |
| class: two capitalized words, second text | 5359 | 525.65 ± 0.1% | 534.71 ± 0.1% | 23.11 ± 0.2% | 484.20 ± 0.2% | 34.26 ± 11.4% | 17.07 ± 0.3% | 63.41 ± 0.4% | 525.90 ± 0.1% | 0.98 | 1.00 | 1.09 | 15.34 |
| other: a word between two words | 6104 | 807.25 ± 0.1% | 609.76 ± 0.1% | 23.31 ± 0.2% | 739.80 ± 0.4% | 109.86 ± 15.6% | 11.19 ± 0.2% | 69.13 ± 0.4% | 808.26 ± 0.1% | 1.32 | 1.00 | 1.09 | 7.35 |
| other: a number before a unit, second text | 1481 | 6157.13 ± 1.1% | 1131.97 ± 0.5% | 25.58 ± 0.2% | 5637.80 ± 0.4% | 40.85 ± 7.7% | 18.17 ± 0.2% | 66.68 ± 0.2% | 6170.38 ± 1.8% | 5.44 | 1.00 | 1.09 | 150.71 |
| other: a heading's start tag | 110 | 13925.04 ± 2.3% | 750.45 ± 0.1% | 26.96 ± 0.3% | 1708.71 ± 0.3% | 1588.25 ± 3.4% | 16.05 ± 0.4% | 88.33 ± 0.3% | 13737.77 ± 1.6% | 18.56 | 1.01 | 8.15 | 8.77 |
| other: a whole word | 217 | 16064.83 ± 1.3% | 607.84 ± 0.7% | 28.75 ± 0.5% | 14586.13 ± 1.1% | 47.95 ± 0.1% | 13.16 ± 0.2% | 54.03 ± 0.4% | 16129.66 ± 1.5% | 26.43 | 1.00 | 1.10 | 335.02 |
| other: a line's first word, second text | 3716 | 2104.19 ± 0.5% | 599.92 ± 0.2% | 30.17 ± 0.2% | 1725.06 ± 0.4% | 63.40 ± 7.0% | refused | refused | 2117.61 ± 0.4% | 3.51 | 0.99 | 1.22 | 33.19 |
| other: fourteen octets before an x | 87 | 23683.58 ± 1.3% | 236.11 ± 0.6% | 6.53 ± 0.1% | 4087.15 ± 0.9% | 10.55 ± 0.1% | differs | 17.44 ± 0.1% | 23613.09 ± 7.7% | 100.31 | 1.00 | 5.79 | 2244.50 |
| other: a Greek word | 21815 | 522.45 ± 1.0% | 425.28 ± 0.3% | 30.44 ± 1.1% | 289.81 ± 0.1% | 48.32 ± 10.5% | differs | refused | 522.46 ± 0.8% | 1.23 | 1.00 | 1.80 | 10.81 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.28 ± 0.4% | 29.13 ± 0.5% | 0.86 ± 0.4% | 19.78 ± 0.4% | 2.78 ± 1.1% | differs | 4.02 ± 0.3% | 29.22 ± 0.3% | 1.01 | 1.00 | 1.48 | 10.55 |
| a UUID | 32895 | 24.67 ± 0.3% | 24.67 ± 0.3% | 0.64 ± 0.1% | 15.03 ± 0.3% | 3.10 ± 0.5% | 0.73 ± 0.3% | 3.60 ± 0.8% | 24.74 ± 0.2% | 1.00 | 1.00 | 1.64 | 7.95 |
| an IPv4 address | 33176 | 38.50 ± 0.4% | 38.44 ± 0.4% | 2.09 ± 0.2% | 29.26 ± 0.7% | 6.64 ± 0.2% | differs | 4.15 ± 0.3% | 38.50 ± 0.1% | 1.00 | 1.00 | 1.32 | 5.80 |
| a date and time | 32954 | 34.41 ± 0.2% | 34.15 ± 0.2% | 1.45 ± 0.2% | 21.46 ± 0.6% | 7.04 ± 0.5% | 1.25 ± 0.1% | 7.12 ± 0.9% | 34.29 ± 0.2% | 1.01 | 1.00 | 1.60 | 4.89 |
| a field path | 32606 | 32.56 ± 0.1% | 32.58 ± 0.2% | 1.02 ± 0.4% | 23.21 ± 0.3% | 3.49 ± 1.1% | differs | 2.93 ± 0.1% | 32.59 ± 0.2% | 1.00 | 1.00 | 1.40 | 9.33 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.12 ± 0.1% | 11.08 ± 0.2% | 11.12 ± 0.3% | 11.45 ± 0.2% | 4.96 ± 2.1% | 0.94 ± 0.6% | none | 11.06 ± 0.2% | 1.00 | 1.01 | 0.97 | 2.24 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.77 ± 1.0% | 221.72 ± 0.6% | 264.05 ± 0.4% | 86.22 ± 0.3% | 223.22 ± 1.2% | 478.08 ± 1.2% | 3747.38 ± 2.3% | 221.93 ± 0.3% | 1.00 | 1.00 | 2.57 | 0.99 |
| a UUID | 62 | 144.53 ± 0.4% | 144.11 ± 0.3% | 162.27 ± 0.3% | 46.10 ± 1.1% | 99.48 ± 1.1% | 190.27 ± 1.4% | 4457.79 ± 0.4% | 144.21 ± 0.9% | 1.00 | 1.00 | 3.14 | 1.45 |
| an IPv4 address | 29 | 411.43 ± 0.7% | 411.89 ± 0.5% | 586.91 ± 0.5% | 77.28 ± 0.9% | 132.00 ± 3.4% | 297.17 ± 0.7% | 7666.80 ± 0.4% | 410.91 ± 0.7% | 1.00 | 1.00 | 5.32 | 3.12 |
| a date and time | 56 | 299.82 ± 0.2% | 299.93 ± 0.1% | 383.62 ± 0.1% | 72.50 ± 0.3% | 138.53 ± 3.1% | 326.54 ± 2.8% | 4974.95 ± 0.8% | 299.59 ± 0.1% | 1.00 | 1.00 | 4.14 | 2.16 |
| a field path | 39 | 213.96 ± 0.4% | 214.03 ± 0.7% | 252.81 ± 0.2% | 79.58 ± 2.4% | 207.11 ± 0.5% | 510.47 ± 4.1% | 4854.45 ± 0.7% | 213.21 ± 0.7% | 1.00 | 1.00 | 2.69 | 1.03 |
| literal: a word | 7 | 597.61 ± 0.6% | 646.08 ± 0.4% | 1193.94 ± 0.7% | 504.17 ± 0.2% | 633.15 ± 2.7% | 965.99 ± 0.3% | 30544.32 ± 0.1% | 598.33 ± 0.2% | 0.92 | 1.00 | 1.19 | 0.94 |
| literal: a word that is not there | 8 | 573.46 ± 0.4% | 622.27 ± 0.3% | 1127.83 ± 0.7% | 461.80 ± 0.1% | 609.11 ± 1.6% | 910.71 ± 0.5% | 29564.63 ± 0.2% | 573.41 ± 0.5% | 0.92 | 1.00 | 1.24 | 0.94 |
| literal: one of four words | 26 | 236.38 ± 0.1% | 386.62 ± 0.3% | 537.92 ± 0.5% | 49.78 ± 0.7% | 247.50 ± 2.0% | 365.03 ± 0.5% | 15784.98 ± 0.1% | 236.55 ± 0.2% | 0.61 | 1.00 | 4.75 | 0.96 |
| literal: a word in any case | 11 | 436.82 ± 0.3% | 466.59 ± 0.6% | 703.47 ± 0.1% | 15.56 ± 0.2% | 653.29 ± 3.5% | refused | 23813.49 ± 0.4% | 436.65 ± 0.4% | 0.94 | 1.00 | 28.08 | 0.67 |
| literal: an href attribute | 12 | 334.88 ± 0.4% | 347.64 ± 0.2% | 464.77 ± 0.3% | 40.48 ± 0.5% | 504.87 ± 2.9% | 777.00 ± 0.5% | 22423.01 ± 0.4% | 335.27 ± 0.4% | 0.96 | 1.00 | 8.27 | 0.66 |
| literal: a word, second text | 10 | 532.34 ± 0.8% | 585.56 ± 0.3% | 1012.20 ± 0.2% | 420.18 ± 1.8% | 545.34 ± 2.1% | 795.56 ± 0.2% | 27451.63 ± 0.3% | 532.40 ± 0.4% | 0.91 | 1.00 | 1.27 | 0.98 |
| class: two capitalized words | 23 | 420.85 ± 0.7% | 450.76 ± 0.8% | 662.46 ± 1.0% | 100.10 ± 0.1% | 503.57 ± 0.7% | 739.27 ± 0.4% | 6383.30 ± 0.1% | 419.66 ± 0.3% | 0.93 | 1.00 | 4.20 | 0.84 |
| class: a word that ends in ing | 9 | 525.52 ± 0.2% | 595.46 ± 0.2% | 1074.49 ± 0.6% | 133.27 ± 1.7% | 761.91 ± 3.2% | 1143.64 ± 0.9% | 15960.94 ± 0.1% | 525.50 ± 0.4% | 0.88 | 1.00 | 3.94 | 0.69 |
| class: a word in capitals | 16 | 468.39 ± 0.3% | 508.89 ± 0.6% | 836.11 ± 0.3% | 136.41 ± 1.1% | 756.60 ± 0.7% | 1048.15 ± 0.5% | 8393.57 ± 0.1% | 467.97 ± 0.3% | 0.92 | 1.00 | 3.43 | 0.62 |
| class: a number | 6 | 590.58 ± 0.5% | 652.98 ± 0.5% | 1268.02 ± 0.2% | 42.17 ± 1.0% | 1393.96 ± 1.8% | 1875.88 ± 0.8% | 23147.33 ± 0.4% | 588.83 ± 0.3% | 0.90 | 1.00 | 14.01 | 0.42 |
| class: two capitalized words, second text | 23 | 420.36 ± 0.3% | 451.14 ± 0.7% | 663.69 ± 0.3% | 102.05 ± 1.3% | 499.84 ± 1.5% | 763.10 ± 0.7% | 6381.13 ± 0.1% | 420.09 ± 0.2% | 0.93 | 1.00 | 4.12 | 0.84 |
| other: a word between two words | 13 | 520.28 ± 0.5% | 542.34 ± 0.3% | 885.48 ± 0.1% | 133.45 ± 1.0% | 508.21 ± 2.4% | 808.93 ± 1.8% | 14760.62 ± 0.1% | 520.43 ± 0.2% | 0.96 | 1.00 | 3.90 | 1.02 |
| other: a number before a unit, second text | 15 | 378.12 ± 0.7% | 420.57 ± 0.2% | 599.25 ± 0.2% | 39.57 ± 0.6% | 639.91 ± 1.2% | 892.08 ± 2.8% | 15429.23 ± 0.3% | 378.51 ± 0.4% | 0.90 | 1.00 | 9.56 | 0.59 |
| other: a heading's start tag | 13 | 346.39 ± 0.3% | 354.09 ± 0.5% | 473.22 ± 0.5% | 40.84 ± 1.3% | 633.28 ± 1.1% | 875.65 ± 0.6% | 18530.95 ± 0.1% | 346.98 ± 0.3% | 0.98 | 1.00 | 8.48 | 0.55 |
| other: a whole word | 11 | 551.31 ± 0.3% | 587.14 ± 0.3% | 1015.21 ± 0.1% | 120.01 ± 0.9% | 563.96 ± 1.7% | 835.25 ± 0.4% | 26988.04 ± 1.6% | 551.06 ± 0.3% | 0.94 | 1.00 | 4.59 | 0.98 |
| other: a line's first word, second text | 17 | 496.98 ± 0.7% | 527.98 ± 0.3% | 873.64 ± 0.2% | 128.41 ± 0.2% | 712.91 ± 0.8% | refused | refused | 499.21 ± 0.2% | 0.94 | 1.00 | 3.87 | 0.70 |
| other: fourteen octets before an x | 16 | 106.38 ± 0.3% | 151.36 ± 0.9% | 177.22 ± 0.6% | 14.52 ± 0.2% | 451.06 ± 2.5% | 417.11 ± 0.5% | 12802.79 ± 0.3% | 106.25 ± 0.4% | 0.70 | 1.00 | 7.32 | 0.24 |
| other: a Greek word | 8 | 412.39 ± 0.2% | 566.30 ± 0.3% | 989.30 ± 0.2% | 57.85 ± 0.6% | 1382.33 ± 1.0% | 1784.63 ± 0.4% | refused | 412.49 ± 0.4% | 0.73 | 1.00 | 7.13 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15493.80 ± 0.6% | not timed | not timed | 16009.53 ± 1.3% | 2069.69 ± 15.1% | not timed | not timed | 15433.28 ± 1.5% | | 1.00 | 0.97 | 7.49 |
| 01-literal/sherlock-casei-en | 522 | 11065.00 ± 6.2% | not timed | not timed | 3589.32 ± 0.1% | 32.30 ± 0.1% | not timed | not timed | 11057.34 ± 1.7% | | 1.00 | 3.08 | 342.58 |
| 01-literal/sherlock-ru | 724 | 17221.49 ± 0.8% | not timed | not timed | 17345.75 ± 0.6% | 1562.39 ± 20.9% | not timed | not timed | 17248.79 ± 0.4% | | 1.00 | 0.99 | 11.02 |
| 01-literal/sherlock-casei-ru | 746 | 6156.83 ± 0.3% | not timed | not timed | 3329.44 ± 0.1% | 31.62 ± 0.3% | not timed | not timed | 6159.22 ± 0.2% | | 1.00 | 1.85 | 194.74 |
| 01-literal/sherlock-zh | 30 | 19501.83 ± 0.2% | not timed | not timed | 18561.20 ± 1.5% | 2610.72 ± 9.9% | not timed | not timed | 19469.95 ± 1.6% | | 1.00 | 1.05 | 7.47 |
| 02-literal-alternate/sherlock-en | 714 | 6141.06 ± 0.2% | not timed | not timed | 3934.39 ± 0.1% | 16.52 ± 0.2% | not timed | not timed | 6152.07 ± 0.5% | | 1.00 | 1.56 | 371.82 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1967.84 ± 1.4% | not timed | not timed | 696.40 ± 0.3% | 11.06 ± 6.6% | not timed | not timed | 1977.21 ± 0.7% | | 1.00 | 2.83 | 177.99 |
| 02-literal-alternate/sherlock-ru | 899 | 5539.52 ± 0.3% | not timed | not timed | 3252.82 ± 0.1% | 22.47 ± 0.2% | not timed | not timed | 5538.72 ± 0.2% | | 1.00 | 1.70 | 246.53 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2057.65 ± 0.4% | not timed | not timed | 1233.72 ± 0.2% | 9.07 ± 0.3% | not timed | not timed | 2056.13 ± 0.6% | | 1.00 | 1.67 | 226.85 |
| 02-literal-alternate/sherlock-zh | 207 | 7327.53 ± 0.2% | not timed | not timed | 4163.02 ± 0.1% | 31.24 ± 0.1% | not timed | not timed | 7329.29 ± 0.4% | | 1.00 | 1.76 | 234.58 |
| 03-date/ascii | 111817 | 133.49 ± 1.3% | not timed | not timed | 95.45 ± 0.1% | 0.20 ± 0.9% | not timed | not timed | 134.33 ± 0.7% | | 0.99 | 1.40 | 659.13 |
| 04-ruff-noqa/real | 84 | 438.37 ± 0.1% | not timed | not timed | 479.79 ± 0.1% | 19.49 ± 0.4% | not timed | not timed | 438.17 ± 0.1% | | 1.00 | 0.91 | 22.50 |
| 04-ruff-noqa/tweaked | 44 | 593.65 ± 0.3% | not timed | not timed | 465.76 ± 0.1% | 364.39 ± 0.5% | not timed | not timed | 594.31 ± 0.3% | | 1.00 | 1.27 | 1.63 |
| 05-lexer-veryl/single | 124800 | 5.28 ± 0.2% | not timed | not timed | 5.15 ± 0.2% | 0.21 ± 2.5% | not timed | not timed | 5.27 ± 0.2% | | 1.00 | 1.02 | 25.48 |
| 06-cloud-flare-redos/original | 107 | 427.00 ± 0.1% | not timed | not timed | 214.12 ± 0.2% | 24.97 ± 0.2% | not timed | not timed | 431.90 ± 0.1% | | 0.99 | 1.99 | 17.10 |
| 06-cloud-flare-redos/simplified-short | 102 | 431.67 ± 0.2% | not timed | not timed | 229.04 ± 0.0% | 26.72 ± 0.1% | not timed | not timed | 428.42 ± 0.1% | | 1.01 | 1.88 | 16.15 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.65 ± 0.1% | not timed | not timed | 256.94 ± 0.1% | 28.70 ± 0.2% | not timed | not timed | 588.57 ± 0.1% | | 1.00 | 2.29 | 20.51 |
| 07-unicode-character-data/parse-line | 558784 | 237.95 ± 2.5% | not timed | not timed | 180.27 ± 0.1% | 42.45 ± 5.2% | not timed | not timed | 239.40 ± 2.2% | | 0.99 | 1.32 | 5.61 |
| 08-words/all-english | 56691 | 127.39 ± 0.8% | not timed | not timed | 83.20 ± 0.2% | 11.85 ± 4.4% | not timed | not timed | 127.18 ± 0.4% | | 1.00 | 1.53 | 10.75 |
| 08-words/long-english | 839 | 623.28 ± 0.1% | not timed | not timed | 595.47 ± 0.2% | 32.26 ± 0.2% | not timed | not timed | 623.76 ± 0.2% | | 1.00 | 1.05 | 19.32 |
| 09-aws-keys/full | 0 | 443.36 ± 0.3% | not timed | not timed | 476.11 ± 0.1% | 64.32 ± 3.4% | not timed | not timed | 442.07 ± 0.2% | | 1.00 | 0.93 | 6.89 |
| 09-aws-keys/quick | 0 | 875.82 ± 0.2% | not timed | not timed | 1003.14 ± 0.1% | 417.63 ± 3.0% | not timed | not timed | 875.50 ± 0.1% | | 1.00 | 0.87 | 2.10 |
| 10-bounded-repeat/letters-en | 1833 | 580.53 ± 3.4% | not timed | not timed | 516.75 ± 0.7% | 19.48 ± 0.7% | not timed | not timed | 577.19 ± 1.4% | | 1.01 | 1.12 | 29.80 |
| 10-bounded-repeat/letters-ru | 3475 | 505.36 ± 1.4% | not timed | not timed | 475.23 ± 0.2% | 21.73 ± 17.7% | not timed | not timed | 506.40 ± 0.8% | | 1.00 | 1.06 | 23.25 |
| 10-bounded-repeat/context | 53 | 84.74 ± 1.6% | not timed | not timed | 66.05 ± 0.2% | 19.84 ± 0.2% | not timed | not timed | 85.55 ± 1.7% | | 0.99 | 1.28 | 4.27 |
| 10-bounded-repeat/capitals | 11 | 632.62 ± 8.1% | not timed | not timed | 615.78 ± 0.1% | 36.53 ± 0.1% | not timed | not timed | 634.35 ± 8.2% | | 1.00 | 1.03 | 17.32 |
| 11-unstructured-to-json/extract | 600 | 57.25 ± 0.9% | not timed | not timed | 76.57 ± 0.1% | 49.27 ± 1.1% | not timed | not timed | 57.25 ± 1.2% | | 1.00 | 0.75 | 1.16 |
| 12-dictionary/single | 1 | 561.70 ± 1.2% | not timed | not timed | 561.99 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 559.38 ± 1.3% | | 1.00 | 1.00 | 1381.50 |
| 14-quadratic/1x | 100 | 21.22 ± 1.3% | not timed | not timed | 10.00 ± 0.3% | 0.99 ± 3.1% | not timed | not timed | 21.40 ± 1.1% | | 0.99 | 2.12 | 21.52 |
| 14-quadratic/2x | 200 | 17.76 ± 2.1% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 0.7% | not timed | not timed | 17.88 ± 0.9% | | 0.99 | 3.20 | 33.23 |
| 14-quadratic/10x | 1000 | 7.77 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 7.78 ± 2.9% | | 1.00 | 6.43 | 67.27 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 0.7% | not timed | not timed | 0.35 ± 0.8% | 0.55 ± 3.5% | not timed | not timed | 1.26 ± 2.5% | | 1.00 | 3.63 | 2.30 |
| 04-ruff-noqa/compile-real | 1 | 105.42 ± 1.1% | not timed | not timed | 13.90 ± 0.6% | 139.31 ± 3.2% | not timed | not timed | 105.00 ± 0.4% | | 1.00 | 7.58 | 0.76 |
| 05-lexer-veryl/compile-single | 1 | 14.01 ± 1.5% | not timed | not timed | 2.56 ± 0.2% | 6.49 ± 1.1% | not timed | not timed | 14.09 ± 0.7% | | 0.99 | 5.48 | 2.16 |
| 07-unicode-character-data/compile | 1 | 108.32 ± 1.1% | not timed | not timed | 26.20 ± 0.2% | 36.42 ± 1.3% | not timed | not timed | 108.73 ± 1.3% | | 1.00 | 4.13 | 2.97 |
| 09-aws-keys/compile-full | 1 | 52.80 ± 0.8% | not timed | not timed | 8.35 ± 0.4% | 23.33 ± 1.9% | not timed | not timed | 52.72 ± 1.3% | | 1.00 | 6.32 | 2.26 |
| 09-aws-keys/compile-quick | 1 | 183.41 ± 1.0% | not timed | not timed | 48.29 ± 0.5% | 134.23 ± 1.9% | not timed | not timed | 181.99 ± 0.4% | | 1.01 | 3.80 | 1.37 |
| 10-bounded-repeat/compile-context | 1 | 71.14 ± 1.6% | not timed | not timed | 11.17 ± 0.2% | 16.08 ± 4.3% | not timed | not timed | 71.03 ± 1.7% | | 1.00 | 6.37 | 4.42 |
| 10-bounded-repeat/compile-capitals | 1 | 82.11 ± 0.7% | not timed | not timed | 8.11 ± 0.2% | 24.01 ± 2.0% | not timed | not timed | 82.09 ± 0.7% | | 1.00 | 10.13 | 3.42 |
| 11-unstructured-to-json/compile | 1 | 172.43 ± 1.5% | not timed | not timed | 41.05 ± 0.9% | 68.13 ± 2.2% | not timed | not timed | 171.22 ± 0.5% | | 1.01 | 4.20 | 2.53 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.0% | not timed | not timed | 0.07 ± 1.0% | 0.09 ± 15.9% | not timed | not timed | 0.35 ± 0.7% | | 1.00 | 4.97 | 3.90 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.31 ± 0.7% | not timed | not timed | 6.55 ± 0.5% | 0.54 ± 1.5% | not timed | not timed | 7.30 ± 4.6% | | 1.00 | 1.12 | 13.56 |
| dictionary/search/english-10 | 690 | 1.16 ± 0.5% | not timed | not timed | 165.36 ± 0.4% | 0.00 ± 0.5% | not timed | not timed | 1.16 ± 0.4% | | 1.00 | 0.0070 | 429.34 |
| dictionary/search/english-15 | 15 | 566.51 ± 1.0% | not timed | not timed | 560.73 ± 0.1% | 0.37 ± 0.2% | not timed | not timed | 567.49 ± 0.9% | | 1.00 | 1.01 | 1544.23 |
| folly/awyer-inn-busted | 1 | 5591.30 ± 0.1% | not timed | not timed | 143.09 ± 0.1% | 44.09 ± 0.2% | not timed | not timed | 5614.82 ± 0.0% | | 1.00 | 39.07 | 126.82 |
| folly/literal-never-match-rare | 0 | 21118.74 ± 1.3% | not timed | not timed | 19930.54 ± 0.4% | 41014.13 ± 0.3% | not timed | not timed | 21125.33 ± 0.1% | | 1.00 | 1.06 | 0.51 |
| folly/literal-never-match-frequent | 0 | 12494.85 ± 0.6% | not timed | not timed | 19911.61 ± 0.2% | 2188.80 ± 0.9% | not timed | not timed | 12522.43 ± 0.7% | | 1.00 | 0.63 | 5.71 |
| folly/literal-never-match-tricksy | 1 | 3232.62 ± 0.1% | not timed | not timed | 4389.28 ± 0.5% | 3055.94 ± 0.3% | not timed | not timed | 3245.37 ± 0.3% | | 1.00 | 0.74 | 1.06 |
| grep/every-line | 239963 | 1316.56 ± 0.5% | not timed | not timed | 952.68 ± 0.2% | 370.14 ± 18.4% | not timed | not timed | 1319.45 ± 1.0% | | 1.00 | 1.38 | 3.56 |
| grep/long-words-ascii | 5073 | 459.28 ± 0.1% | not timed | not timed | 469.36 ± 0.1% | 46.17 ± 6.4% | not timed | not timed | 458.23 ± 0.3% | | 1.00 | 0.98 | 9.95 |
| imported/leipzig/twain | 811 | 20760.35 ± 3.6% | not timed | not timed | 19629.19 ± 0.3% | 11963.95 ± 11.2% | not timed | not timed | 20788.49 ± 0.4% | | 1.00 | 1.06 | 1.74 |
| imported/leipzig/twain-insensitive | 965 | 9057.29 ± 1.3% | not timed | not timed | 4252.97 ± 0.1% | 37.79 ± 0.4% | not timed | not timed | 9080.71 ± 1.6% | | 1.00 | 2.13 | 239.64 |
| imported/leipzig/shing | 1540 | 15080.29 ± 4.2% | not timed | not timed | 13543.60 ± 0.3% | 34.00 ± 0.1% | not timed | not timed | 15551.67 ± 4.1% | | 0.97 | 1.11 | 443.50 |
| imported/leipzig/huck-saw | 262 | 8217.01 ± 5.0% | not timed | not timed | 5603.77 ± 12.6% | 31.93 ± 0.1% | not timed | not timed | 8211.69 ± 7.2% | | 1.00 | 1.47 | 257.37 |
| imported/leipzig/word-ending-nn | 262 | 603.34 ± 0.9% | not timed | not timed | 615.59 ± 0.1% | 24.77 ± 0.4% | not timed | not timed | 599.26 ± 0.2% | | 1.01 | 0.98 | 24.36 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11188.02 ± 1.0% | not timed | not timed | 4532.58 ± 0.5% | 11.51 ± 0.1% | not timed | not timed | 11262.95 ± 1.1% | | 0.99 | 2.47 | 972.11 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7811.27 ± 1.9% | not timed | not timed | 5482.32 ± 0.2% | 16.86 ± 0.1% | not timed | not timed | 7954.26 ± 2.2% | | 0.98 | 1.42 | 463.29 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4185.07 ± 1.1% | not timed | not timed | 397.70 ± 1.9% | 11.04 ± 0.0% | not timed | not timed | 4199.97 ± 1.2% | | 1.00 | 10.52 | 379.19 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 602.84 ± 0.6% | not timed | not timed | 615.58 ± 0.1% | 11.13 ± 0.1% | not timed | not timed | 603.27 ± 0.5% | | 1.00 | 0.98 | 54.17 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 602.69 ± 0.4% | not timed | not timed | 615.97 ± 0.1% | 9.74 ± 0.0% | not timed | not timed | 602.68 ± 0.3% | | 1.00 | 0.98 | 61.86 |
| imported/leipzig/tom-river | 2 | 6484.53 ± 4.4% | not timed | not timed | 5144.86 ± 16.3% | 30.92 ± 0.1% | not timed | not timed | 6613.27 ± 2.3% | | 0.98 | 1.26 | 209.71 |
| imported/leipzig/ing | 78424 | 601.00 ± 0.5% | not timed | not timed | 572.16 ± 0.1% | 28.15 ± 3.2% | not timed | not timed | 602.40 ± 1.0% | | 1.00 | 1.05 | 21.35 |
| imported/leipzig/ing-whitespace | 55248 | 752.73 ± 1.0% | not timed | not timed | 2070.22 ± 1.2% | 20.61 ± 2.9% | not timed | not timed | 753.60 ± 0.4% | | 1.00 | 0.36 | 36.52 |
| imported/leipzig/awyer-inn | 209 | 769.19 ± 1.4% | not timed | not timed | 4265.00 ± 0.7% | 22.63 ± 0.1% | not timed | not timed | 769.03 ± 1.2% | | 1.00 | 0.18 | 34.00 |
| imported/leipzig/quotes-bounded | 8886 | 2117.78 ± 0.9% | not timed | not timed | 3026.91 ± 0.4% | 38.24 ± 0.1% | not timed | not timed | 2128.35 ± 0.6% | | 1.00 | 0.70 | 55.38 |
| imported/leipzig/non-ascii-alternate | 2 | 12844.57 ± 2.3% | not timed | not timed | 5661.20 ± 0.2% | 50.52 ± 0.1% | not timed | not timed | 13086.08 ± 2.6% | | 0.98 | 2.27 | 254.24 |
| imported/leipzig/math-symbols | 69 | 1980.47 ± 0.3% | not timed | not timed | 613.83 ± 0.1% | 36.45 ± 0.1% | not timed | not timed | 1979.87 ± 0.7% | | 1.00 | 3.23 | 54.33 |
| imported/leipzig/bounded-strings-ending-z | 0 | 586.01 ± 1.2% | not timed | not timed | 618.08 ± 0.1% | 22.53 ± 0.2% | not timed | not timed | 586.56 ± 1.6% | | 1.00 | 0.95 | 26.01 |
| imported/lh3lh3-reb/uri | 17549 | 679.92 ± 0.2% | not timed | not timed | 1076.80 ± 0.3% | 28.47 ± 2.0% | not timed | not timed | 679.20 ± 1.8% | | 1.00 | 0.63 | 23.88 |
| imported/lh3lh3-reb/email | 15057 | 674.59 ± 0.2% | not timed | not timed | 1169.13 ± 0.2% | 30.93 ± 2.3% | not timed | not timed | 673.73 ± 0.1% | | 1.00 | 0.58 | 21.81 |
| imported/lh3lh3-reb/date | 668 | 860.74 ± 0.1% | not timed | not timed | 1037.29 ± 0.2% | 51.23 ± 3.8% | not timed | not timed | 860.62 ± 0.3% | | 1.00 | 0.83 | 16.80 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 646.75 ± 0.1% | not timed | not timed | 422.87 ± 0.2% | 15.76 ± 1.2% | not timed | not timed | 645.54 ± 0.1% | | 1.00 | 1.53 | 41.03 |
| imported/mariomka/email | 92 | 24377.77 ± 0.7% | not timed | not timed | 29574.12 ± 0.7% | 32.81 ± 0.2% | not timed | not timed | 24272.79 ± 1.3% | | 1.00 | 0.82 | 743.02 |
| imported/mariomka/uri | 5301 | 5349.90 ± 0.5% | not timed | not timed | 6091.07 ± 0.5% | 32.82 ± 0.3% | not timed | not timed | 5376.23 ± 0.8% | | 1.00 | 0.88 | 163.01 |
| imported/mariomka/ip | 5 | 2153.98 ± 2.3% | not timed | not timed | 2971.92 ± 0.1% | 21.10 ± 0.3% | not timed | not timed | 2154.66 ± 2.5% | | 1.00 | 0.72 | 102.07 |
| imported/rsc/no-exponential | 0 | 605.23 ± 0.1% | not timed | not timed | 319.55 ± 0.1% | 23.86 ± 0.3% | not timed | not timed | 601.65 ± 0.1% | | 1.01 | 1.89 | 25.37 |
| imported/rsc/literal | 1 | 771.25 ± 8.5% | not timed | not timed | 1636.28 ± 8.1% | 185.94 ± 15.3% | not timed | not timed | 771.78 ± 2.8% | | 1.00 | 0.47 | 4.15 |
| imported/rsc/not-literal | 2 | 781.16 ± 2.0% | not timed | not timed | 722.61 ± 0.3% | 46.49 ± 9.8% | not timed | not timed | 783.52 ± 0.4% | | 1.00 | 1.08 | 16.80 |
| imported/rsc/match-class | 1 | 1439.93 ± 0.2% | not timed | not timed | 1648.09 ± 0.2% | 59.02 ± 7.3% | not timed | not timed | 1439.38 ± 2.5% | | 1.00 | 0.87 | 24.40 |
| imported/rsc/match-class-in-range | 1 | 1441.89 ± 9.5% | not timed | not timed | 2322.02 ± 4.3% | 59.96 ± 1.5% | not timed | not timed | 1439.97 ± 0.2% | | 1.00 | 0.62 | 24.05 |
| imported/rsc/match-class-unicode | 1 | 547.52 ± 7.5% | not timed | not timed | 514.67 ± 0.1% | 72.56 ± 0.3% | not timed | not timed | 548.85 ± 0.1% | | 1.00 | 1.06 | 7.55 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1443.85 ± 0.2% | not timed | not timed | 937.53 ± 0.1% | 228.18 ± 0.7% | not timed | not timed | 1445.93 ± 0.2% | | 1.00 | 1.54 | 6.33 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21657.82 ± 0.1% | not timed | not timed | 14147.55 ± 0.1% | 3424.14 ± 0.8% | not timed | not timed | 21636.53 ± 0.1% | | 1.00 | 1.53 | 6.33 |
| imported/rsc/anchored-literal-short-match | 4 | 710.32 ± 1.4% | not timed | not timed | 485.81 ± 0.3% | 84.18 ± 11.1% | not timed | not timed | 716.09 ± 1.8% | | 0.99 | 1.46 | 8.44 |
| imported/rsc/anchored-literal-long-match | 4 | 10695.40 ± 1.9% | not timed | not timed | 7251.48 ± 0.0% | 1237.62 ± 5.3% | not timed | not timed | 10700.31 ± 1.8% | | 1.00 | 1.47 | 8.64 |
| imported/rsc/one-pass-short | 17 | 374.21 ± 1.0% | not timed | not timed | 216.35 ± 0.3% | 31.89 ± 10.9% | not timed | not timed | 373.03 ± 12.2% | | 1.00 | 1.73 | 11.73 |
| imported/rsc/one-pass-short-not | 17 | 280.20 ± 2.2% | not timed | not timed | 223.74 ± 0.1% | 29.79 ± 10.5% | not timed | not timed | 281.57 ± 2.1% | | 1.00 | 1.25 | 9.40 |
| imported/rsc/one-pass-long-prefix | 26 | 364.09 ± 8.6% | not timed | not timed | 288.74 ± 0.3% | 97.23 ± 16.2% | not timed | not timed | 365.98 ± 1.9% | | 0.99 | 1.26 | 3.74 |
| imported/rsc/one-pass-long-prefix-not | 26 | 360.02 ± 1.8% | not timed | not timed | 291.75 ± 1.0% | 61.98 ± 21.5% | not timed | not timed | 363.64 ± 5.8% | | 0.99 | 1.23 | 5.81 |
| imported/rsc/long-needle1 | 31 | 22206.45 ± 0.1% | not timed | not timed | 20157.55 ± 0.1% | 3.63 ± 0.3% | not timed | not timed | 22200.87 ± 0.1% | | 1.00 | 1.10 | 6119.56 |
| imported/rsc/long-needle2 | 31 | 22345.10 ± 0.2% | not timed | not timed | 215.96 ± 0.1% | 3.71 ± 0.3% | not timed | not timed | 22346.69 ± 0.2% | | 1.00 | 103.47 | 6018.18 |
| imported/rsc/easy0-32 | 26 | 1087.94 ± 3.0% | not timed | not timed | 1520.13 ± 0.3% | 141.61 ± 17.7% | not timed | not timed | 1091.69 ± 0.3% | | 1.00 | 0.72 | 7.68 |
| imported/rsc/easy0-1k | 26 | 14929.64 ± 2.1% | not timed | not timed | 12374.29 ± 0.3% | 2290.59 ± 16.6% | not timed | not timed | 14946.29 ± 0.4% | | 1.00 | 1.21 | 6.52 |
| imported/rsc/easy0-32k | 26 | 23038.00 ± 1.6% | not timed | not timed | 20366.29 ± 0.1% | 18833.25 ± 21.4% | not timed | not timed | 23060.51 ± 0.2% | | 1.00 | 1.13 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21263.03 ± 2.2% | not timed | not timed | 19412.43 ± 2.9% | 34270.08 ± 1.3% | not timed | not timed | 21141.22 ± 2.3% | | 1.01 | 1.10 | 0.62 |
| imported/rsc/easy1-32 | 19 | 806.55 ± 3.2% | not timed | not timed | 641.30 ± 0.5% | 130.76 ± 14.6% | not timed | not timed | 803.32 ± 2.2% | | 1.00 | 1.26 | 6.17 |
| imported/rsc/easy1-1k | 19 | 16507.71 ± 0.3% | not timed | not timed | 12740.18 ± 0.2% | 2465.83 ± 18.3% | not timed | not timed | 16510.32 ± 2.2% | | 1.00 | 1.30 | 6.69 |
| imported/rsc/easy1-32k | 19 | 517652.49 ± 2.7% | not timed | not timed | 403640.93 ± 0.5% | 20442.12 ± 30.6% | not timed | not timed | 517605.97 ± 0.3% | | 1.00 | 1.28 | 25.32 |
| imported/rsc/easy1-1mb | 19 | 16596752.21 ± 0.4% | not timed | not timed | 12803805.11 ± 0.1% | 36885.74 ± 4.3% | not timed | not timed | 16566360.26 ± 0.6% | | 1.00 | 1.30 | 449.95 |
| imported/rsc/medium-32 | 27 | 769.65 ± 0.4% | not timed | not timed | 624.84 ± 0.7% | 69.93 ± 10.3% | not timed | not timed | 776.11 ± 2.3% | | 0.99 | 1.23 | 11.01 |
| imported/rsc/medium-1k | 27 | 13664.36 ± 0.3% | not timed | not timed | 11148.62 ± 0.7% | 72.40 ± 0.1% | not timed | not timed | 13718.25 ± 0.8% | | 1.00 | 1.23 | 188.73 |
| imported/rsc/medium-32k | 27 | 426312.31 ± 0.3% | not timed | not timed | 345626.15 ± 0.1% | 48.31 ± 0.1% | not timed | not timed | 427865.67 ± 0.7% | | 1.00 | 1.23 | 8824.44 |
| imported/rsc/medium-1mb | 27 | 13625563.44 ± 0.3% | not timed | not timed | 11071095.94 ± 0.1% | 48.60 ± 0.3% | not timed | not timed | 13691969.44 ± 0.8% | | 1.00 | 1.23 | 280365.63 |
| imported/rsc/hard-32 | 58 | 419.30 ± 0.1% | not timed | not timed | 365.99 ± 0.2% | 49.80 ± 9.0% | not timed | not timed | 417.47 ± 1.7% | | 1.00 | 1.15 | 8.42 |
| imported/rsc/hard-1k | 27 | 13434.72 ± 0.5% | not timed | not timed | 11515.16 ± 0.1% | 40.65 ± 0.1% | not timed | not timed | 13333.19 ± 0.9% | | 1.01 | 1.17 | 330.46 |
| imported/rsc/hard-32k | 27 | 416648.07 ± 0.2% | not timed | not timed | 362424.75 ± 0.2% | 29.36 ± 0.1% | not timed | not timed | 414668.87 ± 0.7% | | 1.00 | 1.15 | 14189.45 |
| imported/rsc/hard-1mb | 51 | 8363295.24 ± 0.3% | not timed | not timed | 7207959.75 ± 0.1% | 29.41 ± 0.1% | not timed | not timed | 8329616.84 ± 0.5% | | 1.00 | 1.16 | 284347.77 |
| imported/rsc/reallyhard0-32 | 58 | 267.27 ± 0.2% | not timed | not timed | 222.90 ± 0.1% | 49.72 ± 7.2% | not timed | not timed | 267.52 ± 2.4% | | 1.00 | 1.20 | 5.38 |
| imported/rsc/reallyhard0-1k | 27 | 592.42 ± 0.1% | not timed | not timed | 582.11 ± 0.3% | 40.83 ± 0.3% | not timed | not timed | 590.66 ± 0.1% | | 1.00 | 1.02 | 14.51 |
| imported/rsc/reallyhard0-32k | 27 | 611.78 ± 0.1% | not timed | not timed | 616.92 ± 0.1% | 29.36 ± 0.1% | not timed | not timed | 610.05 ± 0.2% | | 1.00 | 0.99 | 20.84 |
| imported/rsc/reallyhard0-1mb | 51 | 590.65 ± 1.5% | not timed | not timed | 617.60 ± 0.3% | 29.40 ± 0.3% | not timed | not timed | 591.81 ± 1.0% | | 1.00 | 0.96 | 20.09 |
| imported/rsc/reallyreallyhard0-32 | 47 | 288.63 ± 1.6% | not timed | not timed | 197.30 ± 0.2% | 60.56 ± 16.8% | not timed | not timed | 288.84 ± 1.8% | | 1.00 | 1.46 | 4.77 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6883.25 ± 0.1% | not timed | not timed | 5937.76 ± 0.1% | 34.14 ± 0.3% | not timed | not timed | 6881.56 ± 0.1% | | 1.00 | 1.16 | 201.62 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21508.96 ± 0.1% | not timed | not timed | 19239.73 ± 0.1% | 24.97 ± 0.5% | not timed | not timed | 21518.01 ± 0.1% | | 1.00 | 1.12 | 861.39 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21700.46 ± 2.0% | not timed | not timed | 19843.06 ± 1.4% | 24.95 ± 0.0% | not timed | not timed | 21633.79 ± 1.5% | | 1.00 | 1.09 | 869.59 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.08 ± 1.3% | not timed | not timed | 211.47 ± 0.4% | 60.76 ± 13.5% | not timed | not timed | 282.86 ± 1.9% | | 1.00 | 1.33 | 4.64 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5903.09 ± 0.2% | not timed | not timed | 6155.67 ± 0.2% | 34.37 ± 1.1% | not timed | not timed | 5896.29 ± 0.1% | | 1.00 | 0.96 | 171.75 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21415.99 ± 0.0% | not timed | not timed | 19296.56 ± 0.1% | 24.95 ± 0.3% | not timed | not timed | 21436.62 ± 0.0% | | 1.00 | 1.11 | 858.20 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 20809.74 ± 1.5% | not timed | not timed | 19310.59 ± 1.1% | 24.80 ± 1.0% | not timed | not timed | 20848.55 ± 1.4% | | 1.00 | 1.08 | 839.23 |
| imported/sherlock/name-sherlock | 776 | 19345.20 ± 2.8% | not timed | not timed | 18203.46 ± 0.9% | 9973.34 ± 24.2% | not timed | not timed | 19351.35 ± 2.5% | | 1.00 | 1.06 | 1.94 |
| imported/sherlock/name-holmes | 2766 | 14802.87 ± 5.0% | not timed | not timed | 15376.90 ± 1.0% | 3185.45 ± 23.8% | not timed | not timed | 15076.12 ± 5.1% | | 0.98 | 0.96 | 4.65 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19356.16 ± 2.2% | not timed | not timed | 18153.68 ± 1.0% | 7993.41 ± 37.4% | not timed | not timed | 19369.62 ± 0.8% | | 1.00 | 1.07 | 2.42 |
| imported/sherlock/name-sherlock-casei | 816 | 15534.98 ± 0.5% | not timed | not timed | 4004.31 ± 0.1% | 32.49 ± 0.2% | not timed | not timed | 15535.78 ± 0.7% | | 1.00 | 3.88 | 478.11 |
| imported/sherlock/name-holmes-casei | 2802 | 9221.24 ± 4.8% | not timed | not timed | 3317.70 ± 0.2% | 37.40 ± 1.1% | not timed | not timed | 9302.31 ± 5.5% | | 0.99 | 2.78 | 246.56 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13112.38 ± 4.2% | not timed | not timed | 3941.23 ± 0.1% | 32.55 ± 0.1% | not timed | not timed | 13090.81 ± 1.1% | | 1.00 | 3.33 | 402.83 |
| imported/sherlock/name-whitespace | 1461 | 15024.85 ± 4.6% | not timed | not timed | 14395.63 ± 0.2% | 7337.32 ± 37.6% | not timed | not timed | 15075.70 ± 0.5% | | 1.00 | 1.04 | 2.05 |
| imported/sherlock/name-alt1 | 1142 | 11656.36 ± 2.4% | not timed | not timed | 15973.54 ± 0.6% | 4091.91 ± 21.7% | not timed | not timed | 11648.15 ± 0.3% | | 1.00 | 0.73 | 2.85 |
| imported/sherlock/name-alt2 | 3542 | 8967.49 ± 0.5% | not timed | not timed | 3803.18 ± 0.2% | 31.48 ± 0.1% | not timed | not timed | 8955.81 ± 0.5% | | 1.00 | 2.36 | 284.90 |
| imported/sherlock/name-alt3 | 4507 | 5575.17 ± 0.6% | not timed | not timed | 3628.96 ± 0.2% | 9.94 ± 4.0% | not timed | not timed | 5573.12 ± 0.6% | | 1.00 | 1.54 | 561.10 |
| imported/sherlock/name-alt3-casei | 4593 | 1529.68 ± 0.9% | not timed | not timed | 285.32 ± 0.1% | 6.48 ± 0.2% | not timed | not timed | 1532.28 ± 1.2% | | 1.00 | 5.36 | 235.89 |
| imported/sherlock/name-alt4 | 3686 | 6395.27 ± 0.3% | not timed | not timed | 3785.94 ± 0.1% | 31.33 ± 0.1% | not timed | not timed | 6396.91 ± 0.4% | | 1.00 | 1.69 | 204.13 |
| imported/sherlock/name-alt4-casei | 4254 | 2817.80 ± 2.1% | not timed | not timed | 2574.83 ± 0.4% | 19.89 ± 0.2% | not timed | not timed | 2818.53 ± 1.5% | | 1.00 | 1.09 | 141.64 |
| imported/sherlock/name-alt5 | 4028 | 6445.63 ± 0.4% | not timed | not timed | 3743.30 ± 0.2% | 21.73 ± 0.1% | not timed | not timed | 6441.28 ± 0.3% | | 1.00 | 1.72 | 296.61 |
| imported/sherlock/name-alt5-casei | 4104 | 3515.97 ± 1.8% | not timed | not timed | 2223.16 ± 0.2% | 14.37 ± 0.2% | not timed | not timed | 3522.75 ± 0.8% | | 1.00 | 1.58 | 244.71 |
| imported/sherlock/no-match-uncommon | 0 | 21172.40 ± 1.1% | not timed | not timed | 19181.18 ± 1.1% | 33643.73 ± 0.7% | not timed | not timed | 21189.48 ± 1.0% | | 1.00 | 1.10 | 0.63 |
| imported/sherlock/no-match-common | 0 | 20763.70 ± 0.8% | not timed | not timed | 19081.44 ± 0.5% | 1286.94 ± 0.8% | not timed | not timed | 20787.08 ± 0.5% | | 1.00 | 1.09 | 16.13 |
| imported/sherlock/no-match-really-common | 0 | 15686.71 ± 3.1% | not timed | not timed | 18438.53 ± 1.1% | 1282.48 ± 0.5% | not timed | not timed | 15800.18 ± 1.1% | | 0.99 | 0.85 | 12.23 |
| imported/sherlock/the-lower | 21654 | 2308.27 ± 0.6% | not timed | not timed | 2326.48 ± 0.3% | 229.55 ± 15.0% | not timed | not timed | 2320.55 ± 7.9% | | 0.99 | 0.99 | 10.06 |
| imported/sherlock/the-upper | 2223 | 12609.20 ± 1.6% | not timed | not timed | 13424.30 ± 0.4% | 2599.52 ± 23.2% | not timed | not timed | 12652.10 ± 1.0% | | 1.00 | 0.94 | 4.85 |
| imported/sherlock/the-casei | 23961 | 2004.88 ± 0.9% | not timed | not timed | 1320.08 ± 0.3% | 34.43 ± 22.5% | not timed | not timed | 2010.64 ± 1.3% | | 1.00 | 1.52 | 58.24 |
| imported/sherlock/everything-greedy | 581881 | 282.82 ± 0.8% | not timed | not timed | 166.38 ± 0.2% | 28.80 ± 32.3% | not timed | not timed | 283.73 ± 0.7% | | 1.00 | 1.70 | 9.82 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.61 ± 0.1% | not timed | not timed | 212.10 ± 0.9% | 33.06 ± 0.1% | not timed | not timed | 462.50 ± 0.1% | | 1.00 | 2.18 | 13.99 |
| imported/sherlock/letters | 447175 | 62.59 ± 1.8% | not timed | not timed | 32.75 ± 0.2% | 6.64 ± 17.7% | not timed | not timed | 62.59 ± 0.5% | | 1.00 | 1.91 | 9.43 |
| imported/sherlock/letters-upper | 14180 | 453.20 ± 1.1% | not timed | not timed | 370.71 ± 0.3% | 29.50 ± 23.5% | not timed | not timed | 453.30 ± 0.0% | | 1.00 | 1.22 | 15.36 |
| imported/sherlock/letters-lower | 432995 | 63.60 ± 0.8% | not timed | not timed | 33.53 ± 0.2% | 5.28 ± 33.0% | not timed | not timed | 63.59 ± 0.7% | | 1.00 | 1.90 | 12.06 |
| imported/sherlock/words | 447639 | 115.10 ± 1.2% | not timed | not timed | 82.76 ± 0.3% | 13.89 ± 6.7% | not timed | not timed | 115.75 ± 1.9% | | 0.99 | 1.39 | 8.28 |
| imported/sherlock/before-holmes | 4073 | 10198.81 ± 0.7% | not timed | not timed | 8384.89 ± 0.4% | 23.91 ± 1.5% | not timed | not timed | 10223.64 ± 0.5% | | 1.00 | 1.22 | 426.57 |
| imported/sherlock/before-after-holmes | 2593 | 9768.77 ± 0.9% | not timed | not timed | 9459.50 ± 0.9% | 23.98 ± 2.0% | not timed | not timed | 9745.91 ± 1.6% | | 1.00 | 1.03 | 407.33 |
| imported/sherlock/holmes-cochar-watson | 150 | 5206.65 ± 0.3% | not timed | not timed | 3427.08 ± 0.2% | 30.99 ± 0.2% | not timed | not timed | 5211.04 ± 0.5% | | 1.00 | 1.52 | 168.00 |
| imported/sherlock/holmes-coword-watson | 14309 | 1190.45 ± 0.7% | not timed | not timed | 1123.40 ± 0.3% | 6.79 ± 0.4% | not timed | not timed | 1190.32 ± 0.5% | | 1.00 | 1.06 | 175.37 |
| imported/sherlock/quotes | 14437 | 1399.04 ± 0.2% | not timed | not timed | 1764.08 ± 0.7% | 35.09 ± 0.1% | not timed | not timed | 1391.80 ± 0.3% | | 1.01 | 0.79 | 39.87 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 609.91 ± 0.1% | not timed | not timed | 15838.12 ± 1.5% | 36.62 ± 0.3% | not timed | not timed | 609.81 ± 0.2% | | 1.00 | 0.0385 | 16.66 |
| imported/sherlock/word-ending-n | 35297 | 480.91 ± 1.1% | not timed | not timed | 408.77 ± 0.2% | 23.46 ± 26.2% | not timed | not timed | 391.46 ± 0.3% | | 1.23 | 1.18 | 20.50 |
| imported/sherlock/repeated-class-negation | 2130 | 14464.74 ± 1.7% | not timed | not timed | 10855.13 ± 0.9% | 11.60 ± 1.9% | not timed | not timed | 14514.51 ± 1.9% | | 1.00 | 1.33 | 1247.28 |
| imported/sherlock/ing-suffix | 20547 | 566.58 ± 0.3% | not timed | not timed | 516.95 ± 0.3% | 28.87 ± 0.2% | not timed | not timed | 567.18 ± 0.5% | | 1.00 | 1.10 | 19.62 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 607.97 ± 0.4% | not timed | not timed | 2108.53 ± 0.5% | 20.58 ± 0.2% | not timed | not timed | 608.38 ± 0.3% | | 1.00 | 0.29 | 29.55 |
| opt/accelerate/whole-line | 239963 | 458.12 ± 0.3% | not timed | not timed | 372.91 ± 0.3% | 92.64 ± 13.7% | not timed | not timed | 457.83 ± 0.1% | | 1.00 | 1.23 | 4.94 |
| opt/accelerate/non-dna | 16745 | 426.91 ± 0.2% | not timed | not timed | 399.36 ± 0.1% | 29.47 ± 23.3% | not timed | not timed | 428.39 ± 0.6% | | 1.00 | 1.07 | 14.48 |
| opt/backtrack/words-english | 40536 | 136.63 ± 2.2% | not timed | not timed | 94.42 ± 0.2% | 20.02 ± 7.0% | not timed | not timed | 136.58 ± 1.6% | | 1.00 | 1.45 | 6.82 |
| opt/fixed-length/too-small-ascii | 0 | 309.65 ± 0.2% | not timed | not timed | 695.40 ± 4.5% | 80.06 ± 0.3% | not timed | not timed | 315.64 ± 0.3% | | 0.98 | 0.45 | 3.87 |
| opt/fixed-length/too-big-ascii | 0 | 3443.38 ± 0.1% | not timed | not timed | 5789.81 ± 0.2% | 125.69 ± 0.1% | not timed | not timed | 3441.13 ± 0.2% | | 1.00 | 0.59 | 27.40 |
| opt/fixed-length/go33484-1 | 0 | 662571.12 ± 0.2% | not timed | not timed | 1127910.38 ± 0.2% | 61624.52 ± 0.4% | not timed | not timed | 660652.22 ± 0.2% | | 1.00 | 0.59 | 10.75 |
| opt/fixed-length/go33484-2 | 0 | 662789.16 ± 0.2% | not timed | not timed | 1116623.50 ± 0.6% | 32363.85 ± 2.7% | not timed | not timed | 660729.40 ± 0.1% | | 1.00 | 0.59 | 20.48 |
| opt/fixed-length/go33484-3 | 0 | 2438.87 ± 12.9% | not timed | not timed | 111823.94 ± 0.4% | 768.35 ± 0.2% | not timed | not timed | 2491.71 ± 3.0% | | 0.98 | 0.0218 | 3.17 |
| opt/literal-alt/one-pattern | 1 | 551.06 ± 1.2% | not timed | not timed | 544.65 ± 0.4% | 0.40 ± 0.2% | not timed | not timed | 550.40 ± 1.4% | | 1.00 | 1.01 | 1382.19 |
| opt/onepass/fn-predicate | 916 | 365.31 ± 1.2% | not timed | not timed | 331.01 ± 0.2% | 203.24 ± 12.8% | not timed | not timed | 367.17 ± 0.6% | | 0.99 | 1.10 | 1.80 |
| opt/onepass/first-three-words-english | 35128 | 175.64 ± 2.1% | not timed | not timed | 199.94 ± 0.2% | 84.19 ± 11.7% | not timed | not timed | 176.78 ± 1.7% | | 0.99 | 0.88 | 2.09 |
| opt/prefilter/literal-english | 1 | 20134.95 ± 0.9% | not timed | not timed | 19528.97 ± 0.6% | 17203.76 ± 0.3% | not timed | not timed | 20184.44 ± 0.4% | | 1.00 | 1.03 | 1.17 |
| opt/prefilter/literal-casei-english | 1 | 14389.66 ± 0.5% | not timed | not timed | 4307.84 ± 0.5% | 32.81 ± 0.4% | not timed | not timed | 14395.13 ± 0.4% | | 1.00 | 3.34 | 438.61 |
| opt/prefilter/literal-russian | 1 | 21226.75 ± 0.6% | not timed | not timed | 19817.81 ± 0.4% | 3328.86 ± 0.2% | not timed | not timed | 21212.83 ± 0.7% | | 1.00 | 1.07 | 6.38 |
| opt/prefilter/literal-casei-russian | 1 | 8558.64 ± 0.5% | not timed | not timed | 3885.22 ± 0.2% | 31.84 ± 0.3% | not timed | not timed | 8561.26 ± 0.7% | | 1.00 | 2.20 | 268.77 |
| opt/prefilter/rust-functions | 948 | 6830.58 ± 0.2% | not timed | not timed | 8960.21 ± 1.0% | 1873.39 ± 0.5% | not timed | not timed | 6830.47 ± 0.5% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 29991118.83 ± 0.5% | not timed | not timed | 20801957.15 ± 0.3% | 50.37 ± 0.3% | not timed | not timed | 29959652.67 ± 0.4% | | 1.00 | 1.44 | 595420.79 |
| opt/reverse-inner/holmes | 2593 | 9751.90 ± 0.6% | not timed | not timed | 9371.24 ± 0.6% | 24.01 ± 1.8% | not timed | not timed | 9758.62 ± 0.6% | | 1.00 | 1.04 | 406.21 |
| opt/reverse-inner/email | 47 | 36467.84 ± 1.6% | not timed | not timed | 44957.81 ± 0.9% | 32.49 ± 0.5% | not timed | not timed | 36758.86 ± 1.6% | | 0.99 | 0.81 | 1122.41 |
| opt/reverse-inner/factored-prefix | 3542 | 601.11 ± 2.1% | not timed | not timed | 597.59 ± 0.1% | 12.32 ± 13.0% | not timed | not timed | 600.43 ± 0.2% | | 1.00 | 1.01 | 48.79 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5555.75 ± 0.1% | not timed | not timed | 613.94 ± 0.6% | 75.27 ± 0.1% | not timed | not timed | 5531.60 ± 0.0% | | 1.00 | 9.05 | 73.81 |
| opt/reverse-inner/no-quadratic-forward | 0 | 686.92 ± 1.7% | not timed | not timed | 288.05 ± 0.3% | 24.89 ± 0.1% | not timed | not timed | 688.29 ± 1.8% | | 1.00 | 2.38 | 27.60 |
| opt/reverse-suffix/holmes | 4073 | 10215.63 ± 0.6% | not timed | not timed | 8404.53 ± 0.4% | 24.07 ± 0.6% | not timed | not timed | 10216.17 ± 0.5% | | 1.00 | 1.22 | 424.39 |
| opt/reverse-suffix/no-quadratic | 0 | 5532.76 ± 0.1% | not timed | not timed | 619.07 ± 0.3% | 75.09 ± 0.1% | not timed | not timed | 5560.06 ± 0.1% | | 1.00 | 8.94 | 73.69 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.97 ± 2.4% | not timed | not timed | 131.42 ± 0.0% | 13.64 ± 16.9% | not timed | not timed | 116.20 ± 0.6% | | 1.04 | 0.92 | 8.87 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 122.36 ± 0.3% | not timed | not timed | 132.80 ± 0.1% | 13.15 ± 15.0% | not timed | not timed | 116.27 ± 2.3% | | 1.05 | 0.92 | 9.30 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.4% | not timed | not timed | 0.54 ± 0.3% | 112.65 ± 7.2% | not timed | not timed | 0.28 ± 3.4% | | 0.99 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 317.93 ± 0.1% | not timed | not timed | 293.73 ± 0.3% | 103.51 ± 0.9% | not timed | not timed | 316.43 ± 0.3% | | 1.00 | 1.08 | 3.07 |
| reported/i13-subset-regex/original-ascii | 4094 | 11194.80 ± 0.8% | not timed | not timed | 4530.09 ± 0.5% | 11.50 ± 0.1% | not timed | not timed | 11252.23 ± 0.9% | | 0.99 | 2.47 | 973.26 |
| reported/i13-subset-regex/original-unicode | 4094 | 11054.52 ± 2.6% | not timed | not timed | 252.67 ± 3.0% | 11.51 ± 1.4% | not timed | not timed | 11245.86 ± 0.8% | | 0.98 | 43.75 | 960.68 |
| reported/i13-subset-regex/big-ascii | 1955 | 10706.44 ± 1.1% | not timed | not timed | 67.17 ± 3.8% | 9.84 ± 0.1% | not timed | not timed | 10748.55 ± 1.0% | | 1.00 | 159.38 | 1088.26 |
| reported/i13-subset-regex/big-unicode | 1955 | 10619.16 ± 1.1% | not timed | not timed | 12.11 ± 54.9% | 9.84 ± 0.2% | not timed | not timed | 10744.83 ± 1.0% | | 0.99 | 877.00 | 1079.16 |
| reported/i13-subset-regex/huge-ascii | 55 | 10114.85 ± 1.3% | not timed | not timed | 11.05 ± 0.1% | 8.78 ± 0.3% | not timed | not timed | 10094.54 ± 2.7% | | 1.00 | 915.51 | 1152.30 |
| reported/i13-subset-regex/huge-unicode | 55 | 10065.74 ± 1.2% | not timed | not timed | 10.96 ± 0.3% | 8.77 ± 0.1% | not timed | not timed | 9865.95 ± 3.3% | | 1.02 | 918.39 | 1147.50 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.55 ± 0.0% | not timed | not timed | 11.01 ± 0.1% | 8.78 ± 1.0% | not timed | not timed | 3.55 ± 0.1% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.1% | not timed | not timed | 10.99 ± 0.3% | 8.76 ± 0.4% | not timed | not timed | 5.03 ± 0.1% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 486.44 ± 0.5% | not timed | not timed | 104.04 ± 0.2% | 6.67 ± 0.2% | not timed | not timed | 487.83 ± 0.5% | | 1.00 | 4.68 | 72.93 |
| reported/i787-keywords/opt-ascii | 5674 | 488.53 ± 0.4% | not timed | not timed | 274.21 ± 0.3% | 10.28 ± 0.4% | not timed | not timed | 489.40 ± 0.3% | | 1.00 | 1.78 | 47.51 |
| slow/quadratic-regex-1x | 100 | 7.11 ± 0.2% | not timed | not timed | 4.97 ± 0.2% | 0.05 ± 0.3% | not timed | not timed | 7.15 ± 0.2% | | 0.99 | 1.43 | 144.17 |
| slow/quadratic-regex-2x | 199 | 3.43 ± 1.4% | not timed | not timed | 2.77 ± 0.1% | 0.01 ± 10.9% | not timed | not timed | 3.42 ± 0.1% | | 1.00 | 1.24 | 268.64 |
| slow/quadratic-haystack-1x | 100 | 21.29 ± 1.0% | not timed | not timed | 10.00 ± 0.1% | 1.02 ± 6.9% | not timed | not timed | 21.34 ± 5.9% | | 1.00 | 2.13 | 20.96 |
| slow/quadratic-haystack-2x | 200 | 17.72 ± 13.3% | not timed | not timed | 5.53 ± 0.1% | 0.55 ± 0.8% | not timed | not timed | 17.88 ± 1.2% | | 0.99 | 3.20 | 32.36 |
| unicode/codepoints/any-one | 1112064 | 290.48 ± 0.5% | not timed | not timed | 176.01 ± 0.1% | 18.31 ± 1.1% | not timed | not timed | 291.65 ± 0.3% | | 1.00 | 1.65 | 15.86 |
| unicode/codepoints/any-all | 4382592 | 269.46 ± 0.3% | not timed | not timed | 247.15 ± 0.2% | 117.26 ± 0.2% | not timed | not timed | 270.00 ± 0.5% | | 1.00 | 1.09 | 2.30 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.79 ± 0.7% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 605.28 ± 0.4% | not timed | not timed | 616.43 ± 0.2% | 135.43 ± 0.3% | not timed | not timed | 603.35 ± 0.5% | | 1.00 | 0.98 | 4.47 |
| unicode/overlapping-words/ascii | 6156 | 32.03 ± 0.4% | not timed | not timed | 37.93 ± 0.2% | 3.95 ± 0.5% | not timed | not timed | 32.01 ± 0.3% | | 1.00 | 0.84 | 8.11 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 0.3% | not timed | not timed | 3.26 ± 0.5% | 2.34 ± 0.6% | not timed | not timed | 1.45 ± 0.1% | | 1.00 | 0.44 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 9.8% | not timed | not timed | 2.97 ± 1.6% | 6.20 ± 9.8% | not timed | not timed | 1.29 ± 0.1% | | 1.00 | 0.43 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 127.45 ± 2.7% | not timed | not timed | 82.97 ± 0.2% | 12.21 ± 17.3% | not timed | not timed | 128.43 ± 0.8% | | 0.99 | 1.54 | 10.44 |
| unicode/word/boundary-long-english | 3466 | 615.53 ± 0.1% | not timed | not timed | 603.45 ± 0.1% | 32.60 ± 0.4% | not timed | not timed | 615.90 ± 0.5% | | 1.00 | 1.02 | 18.88 |
| unicode/word/around-holmes-english | 27 | 19261.03 ± 0.7% | not timed | not timed | 19028.50 ± 0.7% | 22.06 ± 0.8% | not timed | not timed | 19231.07 ± 0.5% | | 1.00 | 1.01 | 873.05 |
| wild/bibleref/long | 874 | 563.30 ± 0.5% | not timed | not timed | 584.91 ± 0.1% | 6.81 ± 0.2% | not timed | not timed | 562.65 ± 0.1% | | 1.00 | 0.96 | 82.70 |
| wild/bibleref/short | 30 | 24.06 ± 3.4% | not timed | not timed | 31.51 ± 0.3% | 14.03 ± 10.9% | not timed | not timed | 24.55 ± 1.4% | | 0.98 | 0.76 | 1.72 |
| wild/bibleref/line | 874 | 397.33 ± 0.2% | not timed | not timed | 218.85 ± 0.2% | 9.07 ± 0.5% | not timed | not timed | 396.88 ± 0.1% | | 1.00 | 1.82 | 43.80 |
| wild/caddy/caddy | 6 | 417.74 ± 2.5% | not timed | not timed | 242.29 ± 0.5% | 68.49 ± 14.3% | not timed | not timed | 417.04 ± 0.2% | | 1.00 | 1.72 | 6.10 |
| wild/dot-star-capture/rust-src-tools | 6 | 1071.17 ± 0.3% | not timed | not timed | 344.78 ± 0.3% | 13.49 ± 0.4% | not timed | not timed | 1070.96 ± 0.4% | | 1.00 | 3.11 | 79.39 |
| wild/ruff/noqa | 84 | 439.14 ± 0.1% | not timed | not timed | 469.13 ± 0.1% | 19.46 ± 2.0% | not timed | not timed | 436.52 ± 2.6% | | 1.01 | 0.94 | 22.57 |
| wild/ruff/unnecessary-coding-comment | 16 | 959.64 ± 0.5% | not timed | not timed | 705.27 ± 0.2% | 135.88 ± 11.0% | not timed | not timed | 962.00 ± 0.4% | | 1.00 | 1.36 | 7.06 |
| wild/ruff/string-quote-prefix | 2972 | 1358.95 ± 0.6% | not timed | not timed | 444.26 ± 0.1% | 312.48 ± 25.1% | not timed | not timed | 1355.26 ± 0.6% | | 1.00 | 3.06 | 4.35 |
| wild/ruff/space-around-operator | 1224378 | 220.85 ± 2.5% | not timed | not timed | 187.45 ± 0.0% | 18.34 ± 1.8% | not timed | not timed | 221.60 ± 1.9% | | 1.00 | 1.18 | 12.04 |
| wild/ruff/shebang | 282 | 984.45 ± 0.5% | not timed | not timed | 329.82 ± 0.1% | 117.06 ± 9.5% | not timed | not timed | 983.41 ± 0.4% | | 1.00 | 2.98 | 8.41 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13788.24 ± 0.3% | not timed | not timed | 13845.08 ± 0.3% | 6943.69 ± 0.6% | not timed | not timed | 13819.05 ± 0.2% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12824.99 ± 13.0% | not timed | not timed | 13548.79 ± 8.2% | 6405.38 ± 11.9% | not timed | not timed | 12816.52 ± 2.8% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13182.72 ± 0.5% | not timed | not timed | 13758.60 ± 0.4% | 6671.48 ± 0.1% | not timed | not timed | 13222.61 ± 0.2% | | 1.00 | 0.96 | 1.98 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9546.85 ± 0.6% | not timed | not timed | 13690.16 ± 0.2% | 6755.09 ± 0.8% | not timed | not timed | 9563.04 ± 0.2% | | 1.00 | 0.70 | 1.41 |
| wild/url/search | 234965 | 121.95 ± 14.4% | not timed | not timed | 66.04 ± 0.7% | 2.24 ± 0.7% | not timed | not timed | 122.66 ± 14.2% | | 0.99 | 1.85 | 54.53 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 36.6% | not timed | not timed | 0.01 ± 0.9% | 0.01 ± 21.2% | not timed | not timed | 0.03 ± 68.6% | | 0.99 | 3.08 | 3.91 |
| dictionary/compile/english-15 | 1 | 0.35 ± 19.7% | not timed | not timed | 0.07 ± 0.5% | 0.11 ± 13.7% | not timed | not timed | 0.35 ± 6.6% | | 1.00 | 4.97 | 3.12 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 13.0% | not timed | not timed | 0.02 ± 0.9% | 35.40 ± 7.8% | not timed | not timed | 0.24 ± 3.1% | | 1.00 | 12.76 | 0.0068 |
| reported/i1095-word-repetition/ascii-compile | 1 | 45.90 ± 2.2% | not timed | not timed | 11.53 ± 0.2% | 54.96 ± 18.6% | not timed | not timed | 46.26 ± 13.6% | | 0.99 | 3.98 | 0.84 |
| reported/i787-keywords/compile | 1 | 35.31 ± 4.3% | not timed | not timed | 2.12 ± 0.9% | 16.61 ± 35.4% | not timed | not timed | 35.24 ± 5.0% | | 1.00 | 16.61 | 2.12 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 352.63 ± 9.6% | not timed | not timed | 119.12 ± 0.2% | 558.48 ± 26.6% | not timed | not timed | 348.17 ± 0.4% | | 1.01 | 2.96 | 0.63 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.56 ± 2.1% | not timed | not timed | 4.12 ± 0.9% | 44.10 ± 5.2% | not timed | not timed | 48.33 ± 2.3% | | 0.98 | 11.55 | 1.08 |
| unicode/compile/one-letter | 53 | 6.76 ± 3.2% | not timed | not timed | 4.55 ± 0.5% | 65.47 ± 7.9% | not timed | not timed | 6.79 ± 13.3% | | 1.00 | 1.48 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.00 ± 17.3% | not timed | not timed | 0.10 ± 0.1% | 66.13 ± 6.1% | not timed | not timed | 1.04 ± 16.7% | | 0.96 | 10.08 | 0.0151 |
| unicode/compile/fifty-letters-ascii | 1 | 211.40 ± 3.3% | not timed | not timed | 53.28 ± 0.2% | 184.93 ± 16.0% | not timed | not timed | 212.41 ± 5.6% | | 1.00 | 3.97 | 1.14 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 384.91 ± 7.6% | not timed | not timed | 47.23 ± 0.5% | 687.86 ± 21.7% | not timed | not timed | 379.27 ± 4.5% | | 1.01 | 8.15 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 598.48 ± 8.7% | not timed | not timed | 147.19 ± 0.3% | 669.87 ± 28.6% | not timed | not timed | 598.75 ± 14.1% | | 1.00 | 4.07 | 0.89 |
| unicode/compile/negated-class-matches-codepoint | 1 | 309.22 ± 4.6% | not timed | not timed | 51.67 ± 0.7% | 1231.89 ± 2.6% | not timed | not timed | 315.72 ± 4.1% | | 0.98 | 5.98 | 0.25 |
| wild/bibleref/compile | 3 | 5.79 ± 22.6% | not timed | not timed | 1.92 ± 0.6% | 31.12 ± 19.1% | not timed | not timed | 5.96 ± 21.2% | | 0.97 | 3.01 | 0.19 |
| wild/url/compile | 1 | 0.64 ± 18.1% | not timed | not timed | 0.14 ± 0.5% | 0.45 ± 33.7% | not timed | not timed | 0.65 ± 16.4% | | 1.00 | 4.44 | 1.41 |

