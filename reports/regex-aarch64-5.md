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
| literal: a word | 217 | 19254.77 ± 1.2% | 10790.25 ± 0.9% | 28.08 ± 0.3% | 18160.25 ± 2.0% | 9197.65 ± 8.2% | 17.37 ± 0.3% | 86.55 ± 0.6% | 19270.49 ± 2.8% | 1.78 | 1.00 | 1.06 | 2.09 |
| literal: a word that is not there | 0 | 21218.45 ± 2.0% | 9852.89 ± 0.5% | 28.20 ± 0.2% | 19581.03 ± 1.8% | 28527.68 ± 1.8% | 17.16 ± 0.1% | 80.80 ± 0.4% | 21231.03 ± 3.5% | 2.15 | 1.00 | 1.08 | 0.74 |
| literal: one of four words | 661 | 6430.95 ± 0.5% | 1788.62 ± 0.2% | 14.39 ± 0.2% | 3945.15 ± 0.6% | 21.80 ± 0.2% | 5.26 ± 0.2% | 6.95 ± 0.2% | 6433.38 ± 0.7% | 3.60 | 1.00 | 1.63 | 294.96 |
| literal: a word in any case | 217 | 15130.14 ± 0.6% | 1917.26 ± 0.1% | 21.54 ± 0.7% | 3964.40 ± 0.3% | 38.03 ± 0.2% | refused | differs | 15101.05 ± 0.9% | 7.89 | 1.00 | 3.82 | 397.84 |
| literal: an href attribute | 33 | 16535.51 ± 1.3% | 607.73 ± 0.8% | 27.13 ± 0.3% | 16905.75 ± 1.8% | 2258.99 ± 0.3% | 13.31 ± 0.2% | 75.65 ± 0.5% | 16668.73 ± 2.2% | 27.21 | 0.99 | 0.98 | 7.32 |
| literal: a word, second text | 123 | 19741.25 ± 3.0% | 4582.28 ± 0.1% | 27.83 ± 0.4% | 18421.35 ± 0.5% | 7681.38 ± 9.6% | 19.62 ± 1.0% | 71.20 ± 0.4% | 19744.25 ± 1.4% | 4.31 | 1.00 | 1.07 | 2.57 |
| class: two capitalized words | 1331 | 1179.23 ± 0.8% | 598.15 ± 0.3% | 25.86 ± 0.4% | 586.17 ± 0.1% | 40.68 ± 12.3% | 14.79 ± 0.2% | 67.86 ± 0.3% | 1178.14 ± 0.4% | 1.97 | 1.00 | 2.01 | 28.99 |
| class: a word that ends in ing | 3399 | 571.61 ± 0.1% | 573.98 ± 0.3% | 17.89 ± 0.2% | 548.44 ± 0.1% | 29.67 ± 3.4% | 8.12 ± 0.2% | 18.38 ± 0.2% | 575.54 ± 0.3% | 1.00 | 0.99 | 1.04 | 19.26 |
| class: a word in capitals | 2332 | 1538.77 ± 0.2% | 608.08 ± 0.3% | 27.46 ± 0.2% | 573.01 ± 0.1% | 43.47 ± 6.7% | 17.21 ± 0.2% | 83.36 ± 0.2% | 1536.94 ± 0.3% | 2.53 | 1.00 | 2.69 | 35.40 |
| class: a number | 8288 | 2675.96 ± 0.3% | 840.27 ± 0.1% | 27.56 ± 0.2% | 1719.81 ± 0.1% | 40.34 ± 16.3% | 0.56 ± 0.1% | 57.20 ± 0.3% | 2674.12 ± 0.4% | 3.18 | 1.00 | 1.56 | 66.34 |
| class: two capitalized words, second text | 5359 | 521.46 ± 0.2% | 528.08 ± 0.2% | 23.19 ± 0.1% | 484.69 ± 0.1% | 34.01 ± 10.8% | 16.66 ± 0.2% | 63.32 ± 0.4% | 520.04 ± 0.2% | 0.99 | 1.00 | 1.08 | 15.33 |
| other: a word between two words | 6104 | 811.17 ± 0.2% | 602.86 ± 0.3% | 23.38 ± 0.2% | 738.37 ± 0.1% | 108.88 ± 10.3% | 11.23 ± 0.1% | 69.53 ± 0.6% | 811.38 ± 0.2% | 1.35 | 1.00 | 1.10 | 7.45 |
| other: a number before a unit, second text | 1481 | 6221.55 ± 1.2% | 1142.61 ± 0.2% | 25.83 ± 0.5% | 5650.28 ± 0.2% | 40.83 ± 1.5% | 17.73 ± 0.3% | 65.90 ± 0.1% | 6225.60 ± 1.7% | 5.45 | 1.00 | 1.10 | 152.37 |
| other: a heading's start tag | 110 | 13952.80 ± 1.3% | 739.98 ± 0.2% | 27.20 ± 0.3% | 1705.51 ± 0.1% | 1581.33 ± 6.3% | 16.31 ± 0.3% | 87.69 ± 0.6% | 14005.91 ± 1.4% | 18.86 | 1.00 | 8.18 | 8.82 |
| other: a whole word | 217 | 16069.05 ± 1.4% | 597.16 ± 0.6% | 28.57 ± 0.3% | 14470.82 ± 1.0% | 49.35 ± 0.2% | 13.50 ± 0.3% | 55.47 ± 0.3% | 16235.56 ± 1.8% | 26.91 | 0.99 | 1.11 | 325.58 |
| other: a line's first word, second text | 3716 | 2091.85 ± 0.8% | 591.85 ± 0.2% | 30.83 ± 0.2% | 1728.69 ± 0.4% | 62.05 ± 5.8% | refused | refused | 2102.97 ± 0.9% | 3.53 | 0.99 | 1.21 | 33.71 |
| other: fourteen octets before an x | 87 | 23557.08 ± 2.9% | 225.07 ± 0.6% | 6.47 ± 0.1% | 3994.29 ± 1.1% | 10.64 ± 0.3% | differs | 17.92 ± 0.5% | 23502.26 ± 8.5% | 104.67 | 1.00 | 5.90 | 2214.42 |
| other: a Greek word | 21815 | 527.56 ± 0.2% | 423.82 ± 0.1% | 30.42 ± 0.1% | 290.59 ± 0.5% | 47.45 ± 5.2% | differs | refused | 528.44 ± 0.7% | 1.24 | 1.00 | 1.82 | 11.12 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.72 ± 0.1% | 29.66 ± 0.2% | 0.86 ± 0.3% | 19.78 ± 0.1% | 2.75 ± 1.2% | differs | 4.04 ± 0.2% | 29.65 ± 0.3% | 1.00 | 1.00 | 1.50 | 10.79 |
| a UUID | 32895 | 24.56 ± 0.1% | 24.80 ± 0.1% | 0.64 ± 0.2% | 15.15 ± 0.3% | 3.11 ± 0.6% | 0.72 ± 0.2% | 3.62 ± 0.8% | 24.77 ± 0.1% | 0.99 | 0.99 | 1.62 | 7.91 |
| an IPv4 address | 33176 | 38.73 ± 0.2% | 38.78 ± 0.4% | 2.08 ± 0.3% | 29.31 ± 0.6% | 6.59 ± 0.1% | differs | 4.21 ± 0.2% | 38.74 ± 0.1% | 1.00 | 1.00 | 1.32 | 5.88 |
| a date and time | 32954 | 34.01 ± 0.3% | 34.16 ± 0.3% | 1.44 ± 0.3% | 21.50 ± 0.5% | 6.99 ± 0.1% | 1.19 ± 0.1% | 7.11 ± 0.2% | 34.15 ± 0.1% | 1.00 | 1.00 | 1.58 | 4.87 |
| a field path | 32606 | 32.81 ± 0.2% | 32.89 ± 0.2% | 1.02 ± 0.2% | 23.14 ± 0.3% | 3.49 ± 0.6% | differs | 2.96 ± 0.2% | 32.84 ± 0.1% | 1.00 | 1.00 | 1.42 | 9.40 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.24 ± 0.5% | 11.17 ± 0.4% | 11.20 ± 0.3% | 11.34 ± 0.2% | 4.96 ± 2.2% | 0.90 ± 0.6% | none | 11.18 ± 1.1% | 1.01 | 1.01 | 0.99 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 229.38 ± 0.2% | 229.25 ± 0.2% | 270.50 ± 0.1% | 86.69 ± 0.6% | 220.33 ± 1.5% | 486.00 ± 3.9% | 3741.16 ± 0.1% | 229.16 ± 0.2% | 1.00 | 1.00 | 2.65 | 1.04 |
| a UUID | 62 | 152.03 ± 0.5% | 152.20 ± 0.3% | 169.86 ± 0.2% | 45.54 ± 0.5% | 99.34 ± 0.7% | 189.49 ± 2.7% | 4368.00 ± 0.2% | 152.32 ± 0.3% | 1.00 | 1.00 | 3.34 | 1.53 |
| an IPv4 address | 29 | 422.58 ± 0.5% | 421.46 ± 0.6% | 588.08 ± 0.6% | 77.23 ± 0.5% | 131.17 ± 2.0% | 302.69 ± 0.8% | 7569.10 ± 0.5% | 423.03 ± 0.8% | 1.00 | 1.00 | 5.47 | 3.22 |
| a date and time | 56 | 302.47 ± 0.3% | 302.30 ± 0.3% | 378.94 ± 0.2% | 72.61 ± 0.5% | 136.91 ± 2.1% | 329.06 ± 1.6% | 4937.47 ± 0.4% | 302.76 ± 0.2% | 1.00 | 1.00 | 4.17 | 2.21 |
| a field path | 39 | 224.97 ± 0.3% | 224.82 ± 0.2% | 264.30 ± 0.3% | 80.10 ± 0.1% | 205.00 ± 0.9% | 506.21 ± 2.2% | 4737.01 ± 2.6% | 224.80 ± 0.2% | 1.00 | 1.00 | 2.81 | 1.10 |
| literal: a word | 7 | 604.58 ± 0.5% | 650.41 ± 0.2% | 1126.95 ± 0.1% | 512.10 ± 0.9% | 630.68 ± 1.9% | 962.68 ± 0.3% | 30438.38 ± 0.2% | 604.09 ± 0.4% | 0.93 | 1.00 | 1.18 | 0.96 |
| literal: a word that is not there | 8 | 587.29 ± 0.6% | 635.37 ± 0.3% | 1090.62 ± 0.6% | 466.11 ± 0.4% | 604.61 ± 1.0% | 909.83 ± 0.4% | 29271.56 ± 1.0% | 588.27 ± 0.4% | 0.92 | 1.00 | 1.26 | 0.97 |
| literal: one of four words | 26 | 244.42 ± 0.2% | 387.10 ± 0.4% | 524.44 ± 0.4% | 50.03 ± 0.3% | 241.78 ± 0.9% | 375.66 ± 0.5% | 15651.52 ± 0.4% | 244.37 ± 0.2% | 0.63 | 1.00 | 4.89 | 1.01 |
| literal: a word in any case | 11 | 437.94 ± 0.4% | 467.40 ± 0.3% | 681.63 ± 0.4% | 15.73 ± 0.3% | 649.73 ± 2.9% | refused | 23802.54 ± 0.6% | 439.13 ± 0.5% | 0.94 | 1.00 | 27.84 | 0.67 |
| literal: an href attribute | 12 | 339.40 ± 0.3% | 351.37 ± 0.4% | 460.29 ± 0.4% | 44.76 ± 0.4% | 500.10 ± 1.6% | 768.40 ± 0.5% | 21728.98 ± 0.3% | 339.88 ± 0.5% | 0.97 | 1.00 | 7.58 | 0.68 |
| literal: a word, second text | 10 | 541.05 ± 0.4% | 593.56 ± 0.3% | 974.28 ± 0.3% | 405.70 ± 0.8% | 536.74 ± 1.4% | 802.73 ± 0.5% | 27200.21 ± 1.6% | 541.26 ± 0.5% | 0.91 | 1.00 | 1.33 | 1.01 |
| class: two capitalized words | 23 | 431.74 ± 0.6% | 458.47 ± 0.8% | 656.93 ± 0.6% | 100.48 ± 2.3% | 501.96 ± 1.0% | 755.94 ± 1.4% | 6305.10 ± 0.4% | 431.75 ± 0.4% | 0.94 | 1.00 | 4.30 | 0.86 |
| class: a word that ends in ing | 9 | 552.83 ± 0.3% | 618.25 ± 0.5% | 1068.87 ± 0.2% | 132.14 ± 1.0% | 758.48 ± 1.2% | 1113.65 ± 0.4% | 15770.47 ± 0.3% | 553.19 ± 0.5% | 0.89 | 1.00 | 4.18 | 0.73 |
| class: a word in capitals | 16 | 493.20 ± 0.2% | 529.42 ± 0.2% | 835.94 ± 0.4% | 135.34 ± 0.7% | 755.05 ± 1.9% | 1027.74 ± 0.3% | 8307.21 ± 0.1% | 493.28 ± 0.3% | 0.93 | 1.00 | 3.64 | 0.65 |
| class: a number | 6 | 616.71 ± 0.5% | 673.15 ± 0.4% | 1229.79 ± 0.3% | 41.62 ± 1.0% | 1409.70 ± 1.5% | 1886.02 ± 0.7% | 22806.55 ± 0.2% | 616.50 ± 0.2% | 0.92 | 1.00 | 14.82 | 0.44 |
| class: two capitalized words, second text | 23 | 432.26 ± 0.3% | 459.16 ± 0.3% | 659.09 ± 0.4% | 100.78 ± 2.8% | 505.66 ± 4.4% | 768.61 ± 0.5% | 6302.81 ± 0.2% | 432.32 ± 0.4% | 0.94 | 1.00 | 4.29 | 0.85 |
| other: a word between two words | 13 | 530.40 ± 0.4% | 551.17 ± 0.7% | 869.30 ± 0.9% | 135.32 ± 1.1% | 501.50 ± 7.2% | 816.78 ± 0.2% | 14605.17 ± 0.1% | 531.25 ± 0.5% | 0.96 | 1.00 | 3.92 | 1.06 |
| other: a number before a unit, second text | 15 | 392.54 ± 0.2% | 430.43 ± 0.3% | 601.68 ± 0.4% | 39.34 ± 0.4% | 634.44 ± 0.7% | 888.08 ± 0.4% | 15137.94 ± 0.6% | 392.44 ± 0.3% | 0.91 | 1.00 | 9.98 | 0.62 |
| other: a heading's start tag | 13 | 350.51 ± 0.6% | 357.31 ± 0.4% | 468.26 ± 0.2% | 43.61 ± 0.3% | 627.67 ± 0.8% | 873.94 ± 0.2% | 18027.45 ± 0.1% | 350.72 ± 0.4% | 0.98 | 1.00 | 8.04 | 0.56 |
| other: a whole word | 11 | 560.81 ± 0.7% | 601.04 ± 0.7% | 988.00 ± 0.7% | 118.83 ± 0.8% | 566.22 ± 2.5% | 828.81 ± 0.8% | 27030.95 ± 0.1% | 562.30 ± 1.0% | 0.93 | 1.00 | 4.72 | 0.99 |
| other: a line's first word, second text | 17 | 508.33 ± 0.8% | 543.43 ± 0.4% | 860.89 ± 0.4% | 128.29 ± 0.5% | 710.18 ± 0.9% | refused | refused | 509.78 ± 0.4% | 0.94 | 1.00 | 3.96 | 0.72 |
| other: fourteen octets before an x | 16 | 109.34 ± 0.6% | 156.72 ± 0.4% | 179.29 ± 0.8% | 14.98 ± 0.4% | 451.99 ± 0.6% | 411.33 ± 0.7% | 12779.46 ± 0.2% | 109.36 ± 0.4% | 0.70 | 1.00 | 7.30 | 0.24 |
| other: a Greek word | 8 | 446.16 ± 0.3% | 586.05 ± 0.1% | 974.23 ± 0.6% | 58.62 ± 0.7% | 1402.91 ± 2.8% | 1858.36 ± 0.8% | refused | 446.55 ± 0.3% | 0.76 | 1.00 | 7.61 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15568.25 ± 0.8% | not timed | not timed | 16252.84 ± 1.6% | 2111.67 ± 16.3% | not timed | not timed | 15516.09 ± 1.7% | | 1.00 | 0.96 | 7.37 |
| 01-literal/sherlock-casei-en | 522 | 10911.28 ± 6.6% | not timed | not timed | 3589.73 ± 0.3% | 32.48 ± 0.2% | not timed | not timed | 10899.60 ± 1.8% | | 1.00 | 3.04 | 335.97 |
| 01-literal/sherlock-ru | 724 | 17008.36 ± 0.8% | not timed | not timed | 17196.30 ± 0.7% | 1585.01 ± 10.5% | not timed | not timed | 17097.06 ± 0.4% | | 0.99 | 0.99 | 10.73 |
| 01-literal/sherlock-casei-ru | 746 | 6129.49 ± 0.1% | not timed | not timed | 3330.50 ± 0.3% | 31.83 ± 0.9% | not timed | not timed | 6133.36 ± 0.1% | | 1.00 | 1.84 | 192.58 |
| 01-literal/sherlock-zh | 30 | 19615.67 ± 1.0% | not timed | not timed | 18658.99 ± 1.3% | 3004.19 ± 8.2% | not timed | not timed | 19652.67 ± 0.8% | | 1.00 | 1.05 | 6.53 |
| 02-literal-alternate/sherlock-en | 714 | 6103.63 ± 0.6% | not timed | not timed | 3940.15 ± 0.3% | 16.63 ± 0.6% | not timed | not timed | 6115.40 ± 0.5% | | 1.00 | 1.55 | 366.99 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1969.54 ± 1.5% | not timed | not timed | 697.23 ± 0.1% | 11.01 ± 7.2% | not timed | not timed | 1973.07 ± 1.9% | | 1.00 | 2.82 | 178.89 |
| 02-literal-alternate/sherlock-ru | 899 | 5494.83 ± 0.2% | not timed | not timed | 3251.33 ± 0.2% | 22.63 ± 0.1% | not timed | not timed | 5502.82 ± 0.1% | | 1.00 | 1.69 | 242.82 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2050.22 ± 0.4% | not timed | not timed | 1231.11 ± 0.9% | 9.08 ± 0.3% | not timed | not timed | 2048.31 ± 0.5% | | 1.00 | 1.67 | 225.72 |
| 02-literal-alternate/sherlock-zh | 207 | 7301.23 ± 0.8% | not timed | not timed | 4161.39 ± 0.1% | 31.44 ± 0.2% | not timed | not timed | 7281.63 ± 0.4% | | 1.00 | 1.75 | 232.22 |
| 03-date/ascii | 111817 | 134.43 ± 0.6% | not timed | not timed | 96.48 ± 0.1% | 0.20 ± 1.7% | not timed | not timed | 134.58 ± 0.7% | | 1.00 | 1.39 | 668.80 |
| 04-ruff-noqa/real | 84 | 439.00 ± 0.2% | not timed | not timed | 464.09 ± 0.1% | 19.42 ± 1.2% | not timed | not timed | 437.55 ± 0.3% | | 1.00 | 0.95 | 22.60 |
| 04-ruff-noqa/tweaked | 44 | 846.45 ± 0.3% | not timed | not timed | 461.17 ± 0.0% | 364.38 ± 0.2% | not timed | not timed | 845.60 ± 0.2% | | 1.00 | 1.84 | 2.32 |
| 05-lexer-veryl/single | 124800 | 5.25 ± 0.4% | not timed | not timed | 5.05 ± 0.2% | 0.20 ± 3.3% | not timed | not timed | 5.29 ± 2.8% | | 0.99 | 1.04 | 25.96 |
| 06-cloud-flare-redos/original | 107 | 439.78 ± 0.2% | not timed | not timed | 213.47 ± 0.0% | 24.95 ± 0.2% | not timed | not timed | 438.49 ± 0.1% | | 1.00 | 2.06 | 17.63 |
| 06-cloud-flare-redos/simplified-short | 102 | 438.72 ± 0.2% | not timed | not timed | 227.89 ± 0.0% | 26.63 ± 0.1% | not timed | not timed | 438.58 ± 0.2% | | 1.00 | 1.93 | 16.48 |
| 06-cloud-flare-redos/simplified-long | 10000 | 629.10 ± 0.1% | not timed | not timed | 255.58 ± 0.2% | 28.80 ± 0.2% | not timed | not timed | 629.40 ± 0.0% | | 1.00 | 2.46 | 21.84 |
| 07-unicode-character-data/parse-line | 558784 | 234.55 ± 1.9% | not timed | not timed | 172.01 ± 0.1% | 42.73 ± 6.2% | not timed | not timed | 236.17 ± 2.1% | | 0.99 | 1.36 | 5.49 |
| 08-words/all-english | 56691 | 129.18 ± 0.4% | not timed | not timed | 83.00 ± 0.2% | 11.88 ± 10.8% | not timed | not timed | 129.41 ± 0.5% | | 1.00 | 1.56 | 10.88 |
| 08-words/long-english | 839 | 616.80 ± 0.4% | not timed | not timed | 593.81 ± 0.2% | 32.65 ± 0.2% | not timed | not timed | 617.85 ± 0.2% | | 1.00 | 1.04 | 18.89 |
| 09-aws-keys/full | 0 | 442.77 ± 0.3% | not timed | not timed | 464.34 ± 0.2% | 63.99 ± 0.1% | not timed | not timed | 443.18 ± 0.3% | | 1.00 | 0.95 | 6.92 |
| 09-aws-keys/quick | 0 | 874.89 ± 0.2% | not timed | not timed | 990.04 ± 0.4% | 412.21 ± 0.4% | not timed | not timed | 875.28 ± 0.1% | | 1.00 | 0.88 | 2.12 |
| 10-bounded-repeat/letters-en | 1833 | 580.77 ± 1.7% | not timed | not timed | 517.74 ± 0.5% | 19.55 ± 0.6% | not timed | not timed | 579.33 ± 2.6% | | 1.00 | 1.12 | 29.70 |
| 10-bounded-repeat/letters-ru | 3475 | 504.33 ± 1.4% | not timed | not timed | 470.08 ± 0.2% | 21.75 ± 9.7% | not timed | not timed | 503.75 ± 0.7% | | 1.00 | 1.07 | 23.18 |
| 10-bounded-repeat/context | 53 | 84.46 ± 2.0% | not timed | not timed | 65.71 ± 0.4% | 19.80 ± 0.2% | not timed | not timed | 84.56 ± 1.6% | | 1.00 | 1.29 | 4.27 |
| 10-bounded-repeat/capitals | 11 | 637.59 ± 8.2% | not timed | not timed | 618.33 ± 0.1% | 36.50 ± 0.1% | not timed | not timed | 637.32 ± 8.5% | | 1.00 | 1.03 | 17.47 |
| 11-unstructured-to-json/extract | 600 | 57.96 ± 0.2% | not timed | not timed | 77.83 ± 0.2% | 49.11 ± 0.3% | not timed | not timed | 57.79 ± 0.2% | | 1.00 | 0.74 | 1.18 |
| 12-dictionary/single | 1 | 560.58 ± 1.4% | not timed | not timed | 558.87 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 561.88 ± 1.5% | | 1.00 | 1.00 | 1369.78 |
| 14-quadratic/1x | 100 | 22.08 ± 0.8% | not timed | not timed | 10.01 ± 0.1% | 0.96 ± 2.6% | not timed | not timed | 22.16 ± 2.3% | | 1.00 | 2.20 | 23.01 |
| 14-quadratic/2x | 200 | 19.70 ± 0.9% | not timed | not timed | 5.52 ± 0.1% | 0.53 ± 1.9% | not timed | not timed | 19.79 ± 1.0% | | 1.00 | 3.57 | 37.03 |
| 14-quadratic/10x | 1000 | 12.33 ± 0.4% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 12.34 ± 0.6% | | 1.00 | 10.16 | 107.07 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 1.1% | not timed | not timed | 0.34 ± 0.9% | 0.53 ± 2.6% | not timed | not timed | 1.26 ± 3.0% | | 1.00 | 3.70 | 2.37 |
| 04-ruff-noqa/compile-real | 1 | 104.63 ± 0.4% | not timed | not timed | 13.82 ± 0.3% | 134.49 ± 4.5% | not timed | not timed | 104.78 ± 0.5% | | 1.00 | 7.57 | 0.78 |
| 05-lexer-veryl/compile-single | 1 | 14.09 ± 0.5% | not timed | not timed | 2.52 ± 0.6% | 6.23 ± 1.0% | not timed | not timed | 14.11 ± 1.6% | | 1.00 | 5.58 | 2.26 |
| 07-unicode-character-data/compile | 1 | 108.95 ± 0.2% | not timed | not timed | 26.10 ± 0.2% | 35.53 ± 3.6% | not timed | not timed | 108.91 ± 0.5% | | 1.00 | 4.17 | 3.07 |
| 09-aws-keys/compile-full | 1 | 52.98 ± 0.5% | not timed | not timed | 8.33 ± 0.2% | 22.94 ± 5.6% | not timed | not timed | 53.00 ± 0.9% | | 1.00 | 6.36 | 2.31 |
| 09-aws-keys/compile-quick | 1 | 187.23 ± 0.4% | not timed | not timed | 47.43 ± 0.2% | 129.00 ± 7.8% | not timed | not timed | 187.58 ± 0.4% | | 1.00 | 3.95 | 1.45 |
| 10-bounded-repeat/compile-context | 1 | 71.47 ± 2.0% | not timed | not timed | 11.19 ± 0.3% | 15.79 ± 21.3% | not timed | not timed | 71.40 ± 1.6% | | 1.00 | 6.39 | 4.53 |
| 10-bounded-repeat/compile-capitals | 1 | 86.22 ± 0.6% | not timed | not timed | 8.09 ± 0.3% | 23.36 ± 1.8% | not timed | not timed | 86.16 ± 0.9% | | 1.00 | 10.66 | 3.69 |
| 11-unstructured-to-json/compile | 1 | 173.19 ± 1.1% | not timed | not timed | 40.59 ± 0.5% | 68.06 ± 3.0% | not timed | not timed | 172.96 ± 1.2% | | 1.00 | 4.27 | 2.54 |
| 12-dictionary/compile-single | 1 | 0.35 ± 3.0% | not timed | not timed | 0.07 ± 0.7% | 0.09 ± 14.2% | not timed | not timed | 0.35 ± 0.6% | | 1.00 | 5.20 | 3.78 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.45 ± 4.9% | not timed | not timed | 6.49 ± 0.1% | 0.53 ± 14.0% | not timed | not timed | 7.42 ± 2.6% | | 1.00 | 1.15 | 14.04 |
| dictionary/search/english-10 | 690 | 202.39 ± 3.3% | not timed | not timed | 166.37 ± 0.7% | 0.00 ± 0.2% | not timed | not timed | 211.07 ± 0.9% | | 0.96 | 1.22 | 75418.07 |
| dictionary/search/english-15 | 15 | 560.05 ± 1.5% | not timed | not timed | 559.72 ± 0.2% | 0.37 ± 0.2% | not timed | not timed | 562.05 ± 1.7% | | 1.00 | 1.00 | 1516.83 |
| folly/awyer-inn-busted | 1 | 21500.62 ± 0.1% | not timed | not timed | 143.39 ± 0.1% | 43.82 ± 0.1% | not timed | not timed | 21564.93 ± 0.1% | | 1.00 | 149.94 | 490.65 |
| folly/literal-never-match-rare | 0 | 21087.73 ± 0.9% | not timed | not timed | 19849.91 ± 0.3% | 40748.27 ± 0.7% | not timed | not timed | 21091.16 ± 0.7% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12559.34 ± 0.7% | not timed | not timed | 19871.21 ± 0.6% | 2199.17 ± 0.6% | not timed | not timed | 12574.27 ± 0.8% | | 1.00 | 0.63 | 5.71 |
| folly/literal-never-match-tricksy | 1 | 3255.56 ± 0.3% | not timed | not timed | 4416.34 ± 0.1% | 3055.24 ± 1.0% | not timed | not timed | 3256.67 ± 0.2% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1299.44 ± 0.6% | not timed | not timed | 953.97 ± 0.1% | 365.41 ± 16.7% | not timed | not timed | 1304.41 ± 0.5% | | 1.00 | 1.36 | 3.56 |
| grep/long-words-ascii | 5073 | 459.16 ± 0.3% | not timed | not timed | 470.22 ± 0.3% | 46.04 ± 6.3% | not timed | not timed | 459.03 ± 0.1% | | 1.00 | 0.98 | 9.97 |
| imported/leipzig/twain | 811 | 20608.93 ± 3.1% | not timed | not timed | 19452.62 ± 0.5% | 11892.37 ± 9.0% | not timed | not timed | 20620.47 ± 0.8% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9065.73 ± 1.7% | not timed | not timed | 4247.21 ± 0.1% | 37.68 ± 0.7% | not timed | not timed | 9101.00 ± 1.3% | | 1.00 | 2.13 | 240.58 |
| imported/leipzig/shing | 1540 | 15253.26 ± 2.0% | not timed | not timed | 13387.34 ± 1.9% | 34.02 ± 0.1% | not timed | not timed | 15518.64 ± 2.7% | | 0.98 | 1.14 | 448.42 |
| imported/leipzig/huck-saw | 262 | 8193.75 ± 3.0% | not timed | not timed | 5593.77 ± 0.6% | 31.76 ± 0.1% | not timed | not timed | 8346.62 ± 3.1% | | 0.98 | 1.46 | 257.97 |
| imported/leipzig/word-ending-nn | 262 | 603.15 ± 0.5% | not timed | not timed | 615.78 ± 0.1% | 24.89 ± 0.2% | not timed | not timed | 605.71 ± 0.4% | | 1.00 | 0.98 | 24.24 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11133.82 ± 1.1% | not timed | not timed | 4475.52 ± 0.8% | 11.49 ± 1.2% | not timed | not timed | 11180.15 ± 2.1% | | 1.00 | 2.49 | 969.15 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7767.84 ± 2.2% | not timed | not timed | 5487.16 ± 0.1% | 16.88 ± 0.1% | not timed | not timed | 7892.16 ± 2.6% | | 0.98 | 1.42 | 460.32 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4171.21 ± 0.5% | not timed | not timed | 417.15 ± 0.5% | 11.01 ± 0.0% | not timed | not timed | 4172.32 ± 0.6% | | 1.00 | 10.00 | 378.79 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7338.71 ± 3.5% | not timed | not timed | 614.73 ± 0.1% | 11.14 ± 0.1% | not timed | not timed | 7329.18 ± 2.5% | | 1.00 | 11.94 | 658.80 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7036.95 ± 3.9% | not timed | not timed | 616.01 ± 0.1% | 9.73 ± 0.1% | not timed | not timed | 7096.37 ± 6.2% | | 0.99 | 11.42 | 723.22 |
| imported/leipzig/tom-river | 2 | 6461.95 ± 2.0% | not timed | not timed | 5139.86 ± 0.4% | 30.88 ± 0.2% | not timed | not timed | 6565.21 ± 2.5% | | 0.98 | 1.26 | 209.29 |
| imported/leipzig/ing | 78424 | 603.65 ± 0.8% | not timed | not timed | 572.40 ± 0.1% | 28.26 ± 4.6% | not timed | not timed | 603.47 ± 0.7% | | 1.00 | 1.05 | 21.36 |
| imported/leipzig/ing-whitespace | 55248 | 1923.01 ± 1.1% | not timed | not timed | 2072.35 ± 0.6% | 20.54 ± 2.7% | not timed | not timed | 1934.90 ± 1.6% | | 0.99 | 0.93 | 93.62 |
| imported/leipzig/awyer-inn | 209 | 6370.54 ± 1.4% | not timed | not timed | 4283.34 ± 0.2% | 22.54 ± 0.1% | not timed | not timed | 6425.72 ± 1.7% | | 0.99 | 1.49 | 282.62 |
| imported/leipzig/quotes-bounded | 8886 | 2483.10 ± 0.6% | not timed | not timed | 3010.41 ± 0.8% | 38.28 ± 0.2% | not timed | not timed | 2477.63 ± 0.7% | | 1.00 | 0.82 | 64.86 |
| imported/leipzig/non-ascii-alternate | 2 | 12806.30 ± 2.1% | not timed | not timed | 5669.55 ± 0.2% | 50.72 ± 0.1% | not timed | not timed | 13015.16 ± 2.5% | | 0.98 | 2.26 | 252.49 |
| imported/leipzig/math-symbols | 69 | 1985.25 ± 0.4% | not timed | not timed | 613.65 ± 0.2% | 36.55 ± 0.2% | not timed | not timed | 1980.96 ± 0.3% | | 1.00 | 3.24 | 54.31 |
| imported/leipzig/bounded-strings-ending-z | 0 | 631.46 ± 0.6% | not timed | not timed | 617.76 ± 0.1% | 22.50 ± 0.1% | not timed | not timed | 630.29 ± 1.3% | | 1.00 | 1.02 | 28.06 |
| imported/lh3lh3-reb/uri | 17549 | 678.25 ± 0.1% | not timed | not timed | 1075.13 ± 0.3% | 28.33 ± 2.2% | not timed | not timed | 680.17 ± 0.2% | | 1.00 | 0.63 | 23.95 |
| imported/lh3lh3-reb/email | 15057 | 674.66 ± 0.1% | not timed | not timed | 1158.17 ± 0.3% | 30.98 ± 0.8% | not timed | not timed | 676.55 ± 0.2% | | 1.00 | 0.58 | 21.78 |
| imported/lh3lh3-reb/date | 668 | 892.09 ± 0.1% | not timed | not timed | 1033.24 ± 0.2% | 49.60 ± 3.8% | not timed | not timed | 892.84 ± 0.1% | | 1.00 | 0.86 | 17.98 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.73 ± 0.1% | not timed | not timed | 424.34 ± 0.2% | 15.23 ± 1.3% | not timed | not timed | 647.05 ± 0.1% | | 1.00 | 1.52 | 42.39 |
| imported/mariomka/email | 92 | 24203.56 ± 1.1% | not timed | not timed | 29341.97 ± 0.7% | 32.79 ± 0.1% | not timed | not timed | 24450.22 ± 2.0% | | 0.99 | 0.82 | 738.07 |
| imported/mariomka/uri | 5301 | 5541.41 ± 1.1% | not timed | not timed | 6113.96 ± 0.3% | 32.88 ± 1.0% | not timed | not timed | 5567.71 ± 0.8% | | 1.00 | 0.91 | 168.55 |
| imported/mariomka/ip | 5 | 2599.91 ± 3.0% | not timed | not timed | 2967.62 ± 0.1% | 21.05 ± 0.3% | not timed | not timed | 2598.78 ± 3.4% | | 1.00 | 0.88 | 123.53 |
| imported/rsc/no-exponential | 0 | 608.08 ± 0.1% | not timed | not timed | 322.12 ± 0.2% | 23.71 ± 0.4% | not timed | not timed | 608.13 ± 0.5% | | 1.00 | 1.89 | 25.64 |
| imported/rsc/literal | 1 | 1392.05 ± 8.2% | not timed | not timed | 1666.80 ± 4.6% | 213.01 ± 18.6% | not timed | not timed | 1495.87 ± 7.8% | | 0.93 | 0.84 | 6.54 |
| imported/rsc/not-literal | 2 | 777.25 ± 0.3% | not timed | not timed | 744.97 ± 0.4% | 46.34 ± 1.1% | not timed | not timed | 778.74 ± 8.4% | | 1.00 | 1.04 | 16.77 |
| imported/rsc/match-class | 1 | 1473.21 ± 3.1% | not timed | not timed | 1616.67 ± 0.3% | 58.73 ± 14.3% | not timed | not timed | 1472.01 ± 0.5% | | 1.00 | 0.91 | 25.08 |
| imported/rsc/match-class-in-range | 1 | 1474.81 ± 0.6% | not timed | not timed | 2423.37 ± 3.8% | 60.35 ± 0.3% | not timed | not timed | 1479.05 ± 0.7% | | 1.00 | 0.61 | 24.44 |
| imported/rsc/match-class-unicode | 1 | 539.41 ± 0.1% | not timed | not timed | 508.52 ± 0.1% | 72.71 ± 7.8% | not timed | not timed | 538.94 ± 2.1% | | 1.00 | 1.06 | 7.42 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1452.33 ± 0.2% | not timed | not timed | 958.70 ± 0.2% | 228.58 ± 1.1% | not timed | not timed | 1451.45 ± 0.1% | | 1.00 | 1.51 | 6.35 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21782.51 ± 0.2% | not timed | not timed | 14407.19 ± 0.2% | 3429.68 ± 0.6% | not timed | not timed | 21749.28 ± 0.1% | | 1.00 | 1.51 | 6.35 |
| imported/rsc/anchored-literal-short-match | 4 | 721.85 ± 3.2% | not timed | not timed | 484.08 ± 0.1% | 84.43 ± 15.6% | not timed | not timed | 722.95 ± 2.2% | | 1.00 | 1.49 | 8.55 |
| imported/rsc/anchored-literal-long-match | 4 | 10782.36 ± 2.0% | not timed | not timed | 7446.64 ± 0.3% | 1234.61 ± 7.9% | not timed | not timed | 10826.25 ± 1.6% | | 1.00 | 1.45 | 8.73 |
| imported/rsc/one-pass-short | 17 | 365.75 ± 1.4% | not timed | not timed | 216.70 ± 0.3% | 29.98 ± 12.7% | not timed | not timed | 370.19 ± 0.2% | | 0.99 | 1.69 | 12.20 |
| imported/rsc/one-pass-short-not | 17 | 266.62 ± 2.5% | not timed | not timed | 227.82 ± 0.3% | 29.51 ± 11.3% | not timed | not timed | 269.85 ± 0.2% | | 0.99 | 1.17 | 9.03 |
| imported/rsc/one-pass-long-prefix | 26 | 358.52 ± 6.7% | not timed | not timed | 282.27 ± 0.3% | 97.89 ± 13.0% | not timed | not timed | 361.41 ± 2.1% | | 0.99 | 1.27 | 3.66 |
| imported/rsc/one-pass-long-prefix-not | 26 | 358.88 ± 2.6% | not timed | not timed | 278.20 ± 0.1% | 65.51 ± 19.0% | not timed | not timed | 361.89 ± 2.1% | | 0.99 | 1.29 | 5.48 |
| imported/rsc/long-needle1 | 31 | 21909.57 ± 0.3% | not timed | not timed | 20166.89 ± 0.1% | 3.76 ± 0.1% | not timed | not timed | 21916.88 ± 0.4% | | 1.00 | 1.09 | 5825.60 |
| imported/rsc/long-needle2 | 31 | 22086.33 ± 0.2% | not timed | not timed | 216.25 ± 0.1% | 3.76 ± 0.3% | not timed | not timed | 22081.63 ± 0.1% | | 1.00 | 102.13 | 5879.11 |
| imported/rsc/easy0-32 | 26 | 1576.47 ± 1.9% | not timed | not timed | 1639.75 ± 1.0% | 148.54 ± 18.2% | not timed | not timed | 1563.22 ± 0.1% | | 1.01 | 0.96 | 10.61 |
| imported/rsc/easy0-1k | 26 | 13649.24 ± 2.1% | not timed | not timed | 12686.13 ± 0.3% | 2312.80 ± 14.5% | not timed | not timed | 13627.62 ± 1.6% | | 1.00 | 1.08 | 5.90 |
| imported/rsc/easy0-32k | 26 | 22764.96 ± 1.6% | not timed | not timed | 20425.64 ± 0.0% | 18173.10 ± 22.7% | not timed | not timed | 22768.89 ± 0.1% | | 1.00 | 1.11 | 1.25 |
| imported/rsc/easy0-1mb | 26 | 21519.90 ± 2.1% | not timed | not timed | 19753.92 ± 3.3% | 37466.73 ± 5.4% | not timed | not timed | 21688.58 ± 2.4% | | 0.99 | 1.09 | 0.57 |
| imported/rsc/easy1-32 | 19 | 770.46 ± 8.4% | not timed | not timed | 640.00 ± 0.3% | 138.46 ± 19.2% | not timed | not timed | 771.52 ± 2.3% | | 1.00 | 1.20 | 5.56 |
| imported/rsc/easy1-1k | 19 | 15808.92 ± 2.3% | not timed | not timed | 12984.44 ± 0.3% | 2479.71 ± 17.7% | not timed | not timed | 15822.44 ± 1.9% | | 1.00 | 1.22 | 6.38 |
| imported/rsc/easy1-32k | 19 | 494290.49 ± 2.5% | not timed | not timed | 410881.43 ± 0.1% | 20404.16 ± 28.6% | not timed | not timed | 494637.75 ± 0.1% | | 1.00 | 1.20 | 24.22 |
| imported/rsc/easy1-1mb | 19 | 15894215.29 ± 0.3% | not timed | not timed | 13215442.07 ± 1.1% | 37476.55 ± 4.8% | not timed | not timed | 15909112.97 ± 0.3% | | 1.00 | 1.20 | 424.11 |
| imported/rsc/medium-32 | 27 | 739.13 ± 1.6% | not timed | not timed | 627.01 ± 0.2% | 69.64 ± 11.3% | not timed | not timed | 738.51 ± 0.3% | | 1.00 | 1.18 | 10.61 |
| imported/rsc/medium-1k | 27 | 13163.42 ± 0.1% | not timed | not timed | 11194.88 ± 0.2% | 72.35 ± 0.2% | not timed | not timed | 13116.55 ± 0.2% | | 1.00 | 1.18 | 181.94 |
| imported/rsc/medium-32k | 27 | 411295.08 ± 0.1% | not timed | not timed | 355348.50 ± 0.2% | 48.79 ± 0.1% | not timed | not timed | 409355.45 ± 0.1% | | 1.00 | 1.16 | 8429.96 |
| imported/rsc/medium-1mb | 27 | 13170151.06 ± 0.2% | not timed | not timed | 11491870.10 ± 0.5% | 48.71 ± 0.3% | not timed | not timed | 13057247.19 ± 0.2% | | 1.01 | 1.15 | 270363.19 |
| imported/rsc/hard-32 | 58 | 423.94 ± 1.7% | not timed | not timed | 368.65 ± 0.1% | 49.44 ± 7.6% | not timed | not timed | 421.57 ± 0.2% | | 1.01 | 1.15 | 8.57 |
| imported/rsc/hard-1k | 27 | 12893.51 ± 0.2% | not timed | not timed | 11556.59 ± 0.4% | 40.64 ± 0.1% | not timed | not timed | 12815.97 ± 0.1% | | 1.01 | 1.12 | 317.27 |
| imported/rsc/hard-32k | 27 | 402862.49 ± 0.2% | not timed | not timed | 360424.59 ± 0.1% | 29.40 ± 0.1% | not timed | not timed | 400455.31 ± 0.1% | | 1.01 | 1.12 | 13701.65 |
| imported/rsc/hard-1mb | 51 | 8381823.63 ± 0.2% | not timed | not timed | 7288125.46 ± 0.2% | 29.46 ± 0.1% | not timed | not timed | 8358833.91 ± 0.2% | | 1.00 | 1.15 | 284556.70 |
| imported/rsc/reallyhard0-32 | 58 | 263.09 ± 2.3% | not timed | not timed | 222.52 ± 0.2% | 49.58 ± 9.0% | not timed | not timed | 262.73 ± 0.2% | | 1.00 | 1.18 | 5.31 |
| imported/rsc/reallyhard0-1k | 27 | 580.26 ± 0.3% | not timed | not timed | 586.74 ± 0.1% | 40.80 ± 0.1% | not timed | not timed | 582.09 ± 0.4% | | 1.00 | 0.99 | 14.22 |
| imported/rsc/reallyhard0-32k | 27 | 604.80 ± 0.2% | not timed | not timed | 618.81 ± 0.1% | 29.38 ± 0.1% | not timed | not timed | 601.81 ± 0.3% | | 1.00 | 0.98 | 20.59 |
| imported/rsc/reallyhard0-1mb | 51 | 625.07 ± 0.9% | not timed | not timed | 617.39 ± 0.1% | 29.38 ± 0.1% | not timed | not timed | 620.77 ± 1.2% | | 1.01 | 1.01 | 21.27 |
| imported/rsc/reallyreallyhard0-32 | 47 | 284.55 ± 1.7% | not timed | not timed | 197.83 ± 0.5% | 60.52 ± 15.7% | not timed | not timed | 285.76 ± 1.3% | | 1.00 | 1.44 | 4.70 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7014.41 ± 0.1% | not timed | not timed | 5969.53 ± 0.1% | 34.00 ± 2.1% | not timed | not timed | 6992.52 ± 0.1% | | 1.00 | 1.18 | 206.29 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21445.00 ± 0.1% | not timed | not timed | 19393.59 ± 0.1% | 25.14 ± 0.2% | not timed | not timed | 21452.98 ± 0.1% | | 1.00 | 1.11 | 852.87 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21202.66 ± 1.9% | not timed | not timed | 19455.19 ± 3.8% | 25.13 ± 0.7% | not timed | not timed | 21109.81 ± 2.2% | | 1.00 | 1.09 | 843.78 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 281.23 ± 1.8% | not timed | not timed | 213.54 ± 1.0% | 60.99 ± 12.3% | not timed | not timed | 281.60 ± 1.3% | | 1.00 | 1.32 | 4.61 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5918.81 ± 0.0% | not timed | not timed | 6219.81 ± 0.1% | 34.31 ± 0.2% | not timed | not timed | 5930.63 ± 0.0% | | 1.00 | 0.95 | 172.49 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21321.34 ± 0.1% | not timed | not timed | 19381.61 ± 0.1% | 25.17 ± 0.6% | not timed | not timed | 21315.45 ± 0.1% | | 1.00 | 1.10 | 847.25 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21370.13 ± 2.0% | not timed | not timed | 19554.93 ± 1.5% | 24.70 ± 0.5% | not timed | not timed | 21392.42 ± 1.8% | | 1.00 | 1.09 | 865.06 |
| imported/sherlock/name-sherlock | 776 | 19763.31 ± 2.1% | not timed | not timed | 18346.45 ± 1.0% | 10028.97 ± 27.1% | not timed | not timed | 19761.56 ± 2.1% | | 1.00 | 1.08 | 1.97 |
| imported/sherlock/name-holmes | 2766 | 15138.63 ± 1.4% | not timed | not timed | 15468.14 ± 0.8% | 3163.42 ± 13.6% | not timed | not timed | 15329.94 ± 1.9% | | 0.99 | 0.98 | 4.79 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19780.60 ± 2.0% | not timed | not timed | 18308.27 ± 0.3% | 8031.55 ± 25.0% | not timed | not timed | 19813.48 ± 2.0% | | 1.00 | 1.08 | 2.46 |
| imported/sherlock/name-sherlock-casei | 816 | 15714.66 ± 0.5% | not timed | not timed | 4016.95 ± 0.1% | 32.54 ± 0.3% | not timed | not timed | 15730.04 ± 0.5% | | 1.00 | 3.91 | 482.88 |
| imported/sherlock/name-holmes-casei | 2802 | 9385.88 ± 5.1% | not timed | not timed | 3319.26 ± 0.1% | 37.36 ± 1.9% | not timed | not timed | 9399.82 ± 5.4% | | 1.00 | 2.83 | 251.23 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12981.78 ± 5.1% | not timed | not timed | 3947.00 ± 0.1% | 32.43 ± 0.2% | not timed | not timed | 12981.60 ± 1.1% | | 1.00 | 3.29 | 400.34 |
| imported/sherlock/name-whitespace | 1461 | 15275.96 ± 1.5% | not timed | not timed | 14434.45 ± 0.2% | 6521.78 ± 20.1% | not timed | not timed | 15388.93 ± 1.7% | | 0.99 | 1.06 | 2.34 |
| imported/sherlock/name-alt1 | 1142 | 11640.08 ± 0.3% | not timed | not timed | 16325.50 ± 0.4% | 4119.28 ± 25.9% | not timed | not timed | 11648.46 ± 2.4% | | 1.00 | 0.71 | 2.83 |
| imported/sherlock/name-alt2 | 3542 | 8976.01 ± 0.4% | not timed | not timed | 3832.83 ± 0.1% | 31.15 ± 0.3% | not timed | not timed | 8977.79 ± 0.1% | | 1.00 | 2.34 | 288.13 |
| imported/sherlock/name-alt3 | 4507 | 5548.72 ± 0.6% | not timed | not timed | 3633.58 ± 0.1% | 9.95 ± 0.1% | not timed | not timed | 5547.75 ± 0.4% | | 1.00 | 1.53 | 557.76 |
| imported/sherlock/name-alt3-casei | 4593 | 1528.10 ± 2.6% | not timed | not timed | 285.59 ± 0.2% | 6.43 ± 0.2% | not timed | not timed | 1527.41 ± 2.0% | | 1.00 | 5.35 | 237.50 |
| imported/sherlock/name-alt4 | 3686 | 6438.57 ± 0.2% | not timed | not timed | 3798.78 ± 0.4% | 31.38 ± 0.2% | not timed | not timed | 6444.55 ± 0.5% | | 1.00 | 1.69 | 205.19 |
| imported/sherlock/name-alt4-casei | 4254 | 2817.32 ± 1.9% | not timed | not timed | 2588.09 ± 0.2% | 19.82 ± 0.5% | not timed | not timed | 2814.06 ± 1.0% | | 1.00 | 1.09 | 142.15 |
| imported/sherlock/name-alt5 | 4028 | 6406.25 ± 0.3% | not timed | not timed | 3747.15 ± 0.2% | 21.77 ± 0.1% | not timed | not timed | 6410.55 ± 0.4% | | 1.00 | 1.71 | 294.21 |
| imported/sherlock/name-alt5-casei | 4104 | 3491.68 ± 2.2% | not timed | not timed | 2230.20 ± 0.1% | 14.32 ± 0.2% | not timed | not timed | 3498.25 ± 0.9% | | 1.00 | 1.57 | 243.84 |
| imported/sherlock/no-match-uncommon | 0 | 21481.41 ± 0.7% | not timed | not timed | 19325.41 ± 0.8% | 34151.47 ± 1.5% | not timed | not timed | 21497.83 ± 0.4% | | 1.00 | 1.11 | 0.63 |
| imported/sherlock/no-match-common | 0 | 21330.67 ± 1.5% | not timed | not timed | 19335.95 ± 0.9% | 1293.60 ± 1.5% | not timed | not timed | 21385.86 ± 0.8% | | 1.00 | 1.10 | 16.49 |
| imported/sherlock/no-match-really-common | 0 | 16082.70 ± 2.5% | not timed | not timed | 18515.09 ± 0.6% | 1276.67 ± 0.4% | not timed | not timed | 16147.86 ± 2.2% | | 1.00 | 0.87 | 12.60 |
| imported/sherlock/the-lower | 21654 | 2313.37 ± 1.6% | not timed | not timed | 2334.04 ± 0.2% | 234.21 ± 19.0% | not timed | not timed | 2320.82 ± 2.3% | | 1.00 | 0.99 | 9.88 |
| imported/sherlock/the-upper | 2223 | 12736.33 ± 9.1% | not timed | not timed | 13455.88 ± 1.1% | 2860.15 ± 20.5% | not timed | not timed | 12797.50 ± 1.2% | | 1.00 | 0.95 | 4.45 |
| imported/sherlock/the-casei | 23961 | 1997.97 ± 0.4% | not timed | not timed | 1312.82 ± 0.5% | 34.58 ± 37.0% | not timed | not timed | 2003.71 ± 1.2% | | 1.00 | 1.52 | 57.78 |
| imported/sherlock/everything-greedy | 581881 | 282.66 ± 1.3% | not timed | not timed | 165.37 ± 0.9% | 28.76 ± 34.0% | not timed | not timed | 281.88 ± 0.8% | | 1.00 | 1.71 | 9.83 |
| imported/sherlock/everything-greedy-nl | 594933 | 491.15 ± 0.1% | not timed | not timed | 214.28 ± 0.2% | 32.91 ± 0.1% | not timed | not timed | 490.36 ± 0.1% | | 1.00 | 2.29 | 14.92 |
| imported/sherlock/letters | 447175 | 61.62 ± 0.3% | not timed | not timed | 33.17 ± 0.1% | 6.68 ± 2.6% | not timed | not timed | 61.33 ± 0.4% | | 1.00 | 1.86 | 9.22 |
| imported/sherlock/letters-upper | 14180 | 449.06 ± 1.2% | not timed | not timed | 371.78 ± 0.1% | 29.79 ± 21.1% | not timed | not timed | 447.35 ± 0.2% | | 1.00 | 1.21 | 15.07 |
| imported/sherlock/letters-lower | 432995 | 62.68 ± 1.2% | not timed | not timed | 33.54 ± 0.1% | 6.96 ± 43.7% | not timed | not timed | 62.99 ± 1.3% | | 1.00 | 1.87 | 9.00 |
| imported/sherlock/words | 447639 | 112.49 ± 1.1% | not timed | not timed | 83.20 ± 0.2% | 14.25 ± 11.3% | not timed | not timed | 113.22 ± 0.5% | | 0.99 | 1.35 | 7.89 |
| imported/sherlock/before-holmes | 4073 | 10267.10 ± 0.7% | not timed | not timed | 8420.49 ± 0.5% | 24.09 ± 1.7% | not timed | not timed | 10253.91 ± 0.4% | | 1.00 | 1.22 | 426.23 |
| imported/sherlock/before-after-holmes | 2593 | 9924.98 ± 1.0% | not timed | not timed | 9483.84 ± 0.6% | 23.88 ± 2.6% | not timed | not timed | 9962.79 ± 1.0% | | 1.00 | 1.05 | 415.61 |
| imported/sherlock/holmes-cochar-watson | 150 | 5205.01 ± 0.3% | not timed | not timed | 3427.11 ± 0.1% | 30.95 ± 0.1% | not timed | not timed | 5218.16 ± 0.3% | | 1.00 | 1.52 | 168.16 |
| imported/sherlock/holmes-coword-watson | 14309 | 1156.00 ± 0.2% | not timed | not timed | 1121.59 ± 0.2% | 6.77 ± 0.3% | not timed | not timed | 1152.08 ± 0.2% | | 1.00 | 1.03 | 170.73 |
| imported/sherlock/quotes | 14437 | 1576.48 ± 0.3% | not timed | not timed | 1761.63 ± 0.5% | 35.14 ± 0.4% | not timed | not timed | 1575.05 ± 0.2% | | 1.00 | 0.89 | 44.86 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17399.24 ± 0.4% | not timed | not timed | 15906.22 ± 0.4% | 36.82 ± 0.2% | not timed | not timed | 17391.15 ± 0.2% | | 1.00 | 1.09 | 472.52 |
| imported/sherlock/word-ending-n | 35297 | 478.22 ± 0.2% | not timed | not timed | 409.50 ± 0.1% | 23.69 ± 21.8% | not timed | not timed | 480.36 ± 1.2% | | 1.00 | 1.17 | 20.18 |
| imported/sherlock/repeated-class-negation | 2130 | 14765.69 ± 0.9% | not timed | not timed | 10809.00 ± 0.6% | 11.57 ± 0.2% | not timed | not timed | 14765.02 ± 0.8% | | 1.00 | 1.37 | 1276.52 |
| imported/sherlock/ing-suffix | 20547 | 559.43 ± 0.3% | not timed | not timed | 517.23 ± 0.5% | 28.76 ± 29.9% | not timed | not timed | 559.27 ± 1.1% | | 1.00 | 1.08 | 19.45 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1673.32 ± 0.6% | not timed | not timed | 2107.18 ± 0.2% | 20.48 ± 0.2% | not timed | not timed | 1670.89 ± 0.6% | | 1.00 | 0.79 | 81.71 |
| opt/accelerate/whole-line | 239963 | 457.12 ± 0.1% | not timed | not timed | 373.14 ± 0.3% | 91.95 ± 14.3% | not timed | not timed | 457.01 ± 0.4% | | 1.00 | 1.23 | 4.97 |
| opt/accelerate/non-dna | 16745 | 430.99 ± 0.8% | not timed | not timed | 398.77 ± 0.1% | 29.51 ± 23.9% | not timed | not timed | 430.50 ± 0.5% | | 1.00 | 1.08 | 14.60 |
| opt/backtrack/words-english | 40536 | 141.60 ± 1.4% | not timed | not timed | 94.36 ± 0.1% | 19.58 ± 8.0% | not timed | not timed | 141.69 ± 2.3% | | 1.00 | 1.50 | 7.23 |
| opt/fixed-length/too-small-ascii | 0 | 311.57 ± 0.3% | not timed | not timed | 713.15 ± 1.8% | 80.46 ± 0.6% | not timed | not timed | 317.16 ± 0.4% | | 0.98 | 0.44 | 3.87 |
| opt/fixed-length/too-big-ascii | 0 | 3470.21 ± 0.1% | not timed | not timed | 5844.06 ± 0.3% | 124.42 ± 0.5% | not timed | not timed | 3462.08 ± 0.1% | | 1.00 | 0.59 | 27.89 |
| opt/fixed-length/go33484-1 | 0 | 665743.52 ± 0.1% | not timed | not timed | 1127410.08 ± 0.2% | 61479.18 ± 0.5% | not timed | not timed | 666127.09 ± 0.1% | | 1.00 | 0.59 | 10.83 |
| opt/fixed-length/go33484-2 | 0 | 665930.29 ± 0.1% | not timed | not timed | 1122643.49 ± 0.1% | 32462.96 ± 1.4% | not timed | not timed | 666086.04 ± 0.1% | | 1.00 | 0.59 | 20.51 |
| opt/fixed-length/go33484-3 | 0 | 66605.47 ± 0.7% | not timed | not timed | 111899.07 ± 0.4% | 768.66 ± 0.5% | not timed | not timed | 66635.98 ± 0.6% | | 1.00 | 0.60 | 86.65 |
| opt/literal-alt/one-pattern | 1 | 548.09 ± 10.0% | not timed | not timed | 540.23 ± 0.1% | 0.40 ± 0.6% | not timed | not timed | 547.72 ± 1.6% | | 1.00 | 1.01 | 1364.43 |
| opt/onepass/fn-predicate | 916 | 367.85 ± 0.5% | not timed | not timed | 335.93 ± 0.3% | 198.52 ± 13.9% | not timed | not timed | 370.14 ± 0.8% | | 0.99 | 1.10 | 1.85 |
| opt/onepass/first-three-words-english | 35128 | 179.74 ± 3.1% | not timed | not timed | 201.09 ± 0.1% | 80.83 ± 13.4% | not timed | not timed | 182.28 ± 7.8% | | 0.99 | 0.89 | 2.22 |
| opt/prefilter/literal-english | 1 | 20789.36 ± 0.3% | not timed | not timed | 20010.40 ± 0.4% | 17671.14 ± 0.4% | not timed | not timed | 20789.84 ± 0.3% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14600.94 ± 0.4% | not timed | not timed | 4319.80 ± 0.1% | 32.61 ± 0.1% | not timed | not timed | 14617.63 ± 0.4% | | 1.00 | 3.38 | 447.69 |
| opt/prefilter/literal-russian | 1 | 20593.84 ± 1.2% | not timed | not timed | 19373.96 ± 1.2% | 3324.74 ± 0.4% | not timed | not timed | 20664.84 ± 1.1% | | 1.00 | 1.06 | 6.19 |
| opt/prefilter/literal-casei-russian | 1 | 8524.96 ± 1.1% | not timed | not timed | 3889.65 ± 0.5% | 31.67 ± 0.3% | not timed | not timed | 8512.54 ± 0.9% | | 1.00 | 2.19 | 269.22 |
| opt/prefilter/rust-functions | 948 | 6823.03 ± 0.2% | not timed | not timed | 8932.92 ± 0.4% | 1872.01 ± 0.3% | not timed | not timed | 6820.07 ± 0.4% | | 1.00 | 0.76 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 29650048.19 ± 0.2% | not timed | not timed | 21865737.07 ± 0.2% | 50.29 ± 0.2% | not timed | not timed | 29619587.37 ± 0.0% | | 1.00 | 1.36 | 589608.27 |
| opt/reverse-inner/holmes | 2593 | 9919.35 ± 0.8% | not timed | not timed | 9464.36 ± 0.3% | 23.94 ± 1.8% | not timed | not timed | 9949.66 ± 0.7% | | 1.00 | 1.05 | 414.37 |
| opt/reverse-inner/email | 47 | 36334.65 ± 2.7% | not timed | not timed | 44822.05 ± 1.9% | 32.46 ± 0.1% | not timed | not timed | 36752.92 ± 3.3% | | 0.99 | 0.81 | 1119.25 |
| opt/reverse-inner/factored-prefix | 3542 | 592.97 ± 0.4% | not timed | not timed | 597.93 ± 0.2% | 11.87 ± 0.6% | not timed | not timed | 592.17 ± 0.4% | | 1.00 | 0.99 | 49.97 |
| opt/reverse-inner/no-quadratic-backward | 0 | 20968.83 ± 0.2% | not timed | not timed | 612.97 ± 0.3% | 75.09 ± 0.2% | not timed | not timed | 21145.76 ± 0.1% | | 0.99 | 34.21 | 279.24 |
| opt/reverse-inner/no-quadratic-forward | 0 | 728.17 ± 2.0% | not timed | not timed | 287.19 ± 0.1% | 24.68 ± 0.0% | not timed | not timed | 736.18 ± 2.3% | | 0.99 | 2.54 | 29.50 |
| opt/reverse-suffix/holmes | 4073 | 10273.89 ± 0.5% | not timed | not timed | 8359.37 ± 0.3% | 24.12 ± 3.0% | not timed | not timed | 10270.37 ± 0.5% | | 1.00 | 1.23 | 426.04 |
| opt/reverse-suffix/no-quadratic | 0 | 21084.17 ± 0.1% | not timed | not timed | 613.27 ± 0.2% | 74.87 ± 0.2% | not timed | not timed | 21147.43 ± 0.1% | | 1.00 | 34.38 | 281.61 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.05 ± 8.1% | not timed | not timed | 130.86 ± 0.1% | 13.11 ± 16.5% | not timed | not timed | 121.45 ± 0.3% | | 1.00 | 0.93 | 9.23 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 118.90 ± 2.9% | not timed | not timed | 130.38 ± 0.1% | 13.19 ± 14.9% | not timed | not timed | 121.12 ± 0.4% | | 0.98 | 0.91 | 9.01 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.1% | not timed | not timed | 0.55 ± 0.3% | 112.33 ± 0.6% | not timed | not timed | 0.28 ± 0.1% | | 0.99 | 0.50 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 315.85 ± 0.3% | not timed | not timed | 294.80 ± 0.1% | 103.63 ± 8.0% | not timed | not timed | 322.45 ± 3.1% | | 0.98 | 1.07 | 3.05 |
| reported/i13-subset-regex/original-ascii | 4094 | 11227.68 ± 0.9% | not timed | not timed | 4501.67 ± 0.7% | 11.49 ± 0.2% | not timed | not timed | 11225.76 ± 1.1% | | 1.00 | 2.49 | 976.99 |
| reported/i13-subset-regex/original-unicode | 4094 | 11090.36 ± 1.3% | not timed | not timed | 251.86 ± 3.0% | 11.49 ± 0.3% | not timed | not timed | 11245.75 ± 1.0% | | 0.99 | 44.03 | 965.15 |
| reported/i13-subset-regex/big-ascii | 1955 | 10720.12 ± 1.4% | not timed | not timed | 67.95 ± 3.7% | 9.84 ± 0.1% | not timed | not timed | 10762.76 ± 1.2% | | 1.00 | 157.77 | 1089.32 |
| reported/i13-subset-regex/big-unicode | 1955 | 10622.21 ± 0.8% | not timed | not timed | 12.24 ± 54.9% | 9.85 ± 0.1% | not timed | not timed | 10629.69 ± 1.2% | | 1.00 | 867.96 | 1077.88 |
| reported/i13-subset-regex/huge-ascii | 55 | 10074.12 ± 2.5% | not timed | not timed | 11.05 ± 0.1% | 8.76 ± 0.2% | not timed | not timed | 10053.97 ± 16.9% | | 1.00 | 912.01 | 1150.65 |
| reported/i13-subset-regex/huge-unicode | 55 | 9887.25 ± 2.8% | not timed | not timed | 11.01 ± 0.4% | 8.76 ± 0.1% | not timed | not timed | 9832.25 ± 2.9% | | 1.01 | 897.67 | 1129.19 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.0% | not timed | not timed | 11.02 ± 0.1% | 8.76 ± 0.2% | not timed | not timed | 3.53 ± 0.1% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.97 ± 0.0% | not timed | not timed | 10.99 ± 0.3% | 8.75 ± 1.0% | not timed | not timed | 4.96 ± 0.1% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 484.20 ± 0.3% | not timed | not timed | 104.40 ± 0.2% | 6.63 ± 0.2% | not timed | not timed | 484.95 ± 0.3% | | 1.00 | 4.64 | 73.04 |
| reported/i787-keywords/opt-ascii | 5674 | 486.00 ± 0.2% | not timed | not timed | 274.65 ± 0.1% | 10.11 ± 0.1% | not timed | not timed | 484.04 ± 0.4% | | 1.00 | 1.77 | 48.08 |
| slow/quadratic-regex-1x | 100 | 7.09 ± 0.2% | not timed | not timed | 4.96 ± 0.2% | 0.05 ± 0.3% | not timed | not timed | 7.15 ± 0.4% | | 0.99 | 1.43 | 143.76 |
| slow/quadratic-regex-2x | 199 | 3.41 ± 0.1% | not timed | not timed | 2.75 ± 0.1% | 0.01 ± 0.4% | not timed | not timed | 3.38 ± 0.3% | | 1.01 | 1.24 | 267.76 |
| slow/quadratic-haystack-1x | 100 | 22.15 ± 6.9% | not timed | not timed | 10.00 ± 0.2% | 1.01 ± 15.3% | not timed | not timed | 22.05 ± 1.8% | | 1.00 | 2.21 | 21.88 |
| slow/quadratic-haystack-2x | 200 | 19.64 ± 0.8% | not timed | not timed | 5.55 ± 0.2% | 0.54 ± 1.0% | not timed | not timed | 19.62 ± 6.8% | | 1.00 | 3.54 | 36.22 |
| unicode/codepoints/any-one | 1112064 | 281.15 ± 0.4% | not timed | not timed | 176.51 ± 0.1% | 18.19 ± 15.1% | not timed | not timed | 282.12 ± 0.3% | | 1.00 | 1.59 | 15.46 |
| unicode/codepoints/any-all | 4382592 | 282.40 ± 1.2% | not timed | not timed | 246.65 ± 0.3% | 117.75 ± 0.1% | not timed | not timed | 282.06 ± 1.0% | | 1.00 | 1.14 | 2.40 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.73 ± 1.9% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 603.49 ± 0.5% | not timed | not timed | 616.73 ± 0.1% | 135.44 ± 0.2% | not timed | not timed | 603.67 ± 0.7% | | 1.00 | 0.98 | 4.46 |
| unicode/overlapping-words/ascii | 6156 | 32.23 ± 0.2% | not timed | not timed | 38.90 ± 0.1% | 3.94 ± 1.2% | not timed | not timed | 32.30 ± 0.2% | | 1.00 | 0.83 | 8.19 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.4% | not timed | not timed | 4.45 ± 0.2% | 2.33 ± 0.3% | not timed | not timed | 1.43 ± 0.3% | | 1.01 | 0.32 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.2% | not timed | not timed | 4.11 ± 0.1% | 6.30 ± 9.7% | not timed | not timed | 1.27 ± 0.2% | | 1.00 | 0.31 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 129.50 ± 8.1% | not timed | not timed | 83.06 ± 0.3% | 11.64 ± 22.8% | not timed | not timed | 129.74 ± 1.4% | | 1.00 | 1.56 | 11.13 |
| unicode/word/boundary-long-english | 3466 | 609.10 ± 0.1% | not timed | not timed | 604.89 ± 0.3% | 32.57 ± 0.3% | not timed | not timed | 608.63 ± 0.7% | | 1.00 | 1.01 | 18.70 |
| unicode/word/around-holmes-english | 27 | 19966.25 ± 0.2% | not timed | not timed | 19772.59 ± 0.8% | 22.34 ± 0.4% | not timed | not timed | 20007.99 ± 0.2% | | 1.00 | 1.01 | 893.89 |
| wild/bibleref/long | 874 | 564.69 ± 0.3% | not timed | not timed | 583.40 ± 0.1% | 6.52 ± 0.2% | not timed | not timed | 566.95 ± 0.1% | | 1.00 | 0.97 | 86.67 |
| wild/bibleref/short | 30 | 24.04 ± 2.0% | not timed | not timed | 30.40 ± 0.2% | 14.15 ± 12.9% | not timed | not timed | 24.54 ± 3.3% | | 0.98 | 0.79 | 1.70 |
| wild/bibleref/line | 874 | 399.03 ± 1.6% | not timed | not timed | 210.38 ± 0.2% | 9.18 ± 8.3% | not timed | not timed | 400.04 ± 0.1% | | 1.00 | 1.90 | 43.45 |
| wild/caddy/caddy | 6 | 420.21 ± 2.1% | not timed | not timed | 248.78 ± 0.2% | 68.36 ± 13.8% | not timed | not timed | 421.83 ± 2.4% | | 1.00 | 1.69 | 6.15 |
| wild/dot-star-capture/rust-src-tools | 6 | 1070.13 ± 0.4% | not timed | not timed | 350.42 ± 0.2% | 13.53 ± 0.2% | not timed | not timed | 1065.00 ± 0.3% | | 1.00 | 3.05 | 79.08 |
| wild/ruff/noqa | 84 | 438.70 ± 0.2% | not timed | not timed | 462.10 ± 0.1% | 19.55 ± 2.2% | not timed | not timed | 438.97 ± 0.3% | | 1.00 | 0.95 | 22.44 |
| wild/ruff/unnecessary-coding-comment | 16 | 956.91 ± 0.3% | not timed | not timed | 701.31 ± 0.3% | 135.48 ± 11.2% | not timed | not timed | 959.07 ± 0.5% | | 1.00 | 1.36 | 7.06 |
| wild/ruff/string-quote-prefix | 2972 | 1363.18 ± 0.7% | not timed | not timed | 405.89 ± 0.1% | 374.89 ± 30.0% | not timed | not timed | 1364.11 ± 0.7% | | 1.00 | 3.36 | 3.64 |
| wild/ruff/space-around-operator | 1224378 | 223.28 ± 1.8% | not timed | not timed | 186.86 ± 0.1% | 18.30 ± 1.5% | not timed | not timed | 223.87 ± 1.8% | | 1.00 | 1.19 | 12.20 |
| wild/ruff/shebang | 282 | 972.27 ± 0.4% | not timed | not timed | 327.92 ± 0.2% | 118.00 ± 9.4% | not timed | not timed | 978.23 ± 1.5% | | 0.99 | 2.96 | 8.24 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13824.23 ± 0.2% | not timed | not timed | 13825.07 ± 0.5% | 6921.17 ± 1.0% | not timed | not timed | 13829.58 ± 0.1% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12834.62 ± 1.3% | not timed | not timed | 13505.37 ± 0.6% | 6399.51 ± 0.8% | not timed | not timed | 12845.95 ± 0.8% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13216.97 ± 0.4% | not timed | not timed | 13727.55 ± 0.3% | 6594.42 ± 0.3% | not timed | not timed | 13222.20 ± 0.4% | | 1.00 | 0.96 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9569.69 ± 0.3% | not timed | not timed | 13611.46 ± 0.4% | 6690.05 ± 1.4% | not timed | not timed | 9571.99 ± 0.3% | | 1.00 | 0.70 | 1.43 |
| wild/url/search | 234965 | 120.58 ± 14.5% | not timed | not timed | 64.97 ± 0.6% | 2.21 ± 0.7% | not timed | not timed | 120.98 ± 13.6% | | 1.00 | 1.86 | 54.50 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 59.6% | not timed | not timed | 0.01 ± 0.8% | 0.01 ± 22.1% | not timed | not timed | 0.03 ± 69.0% | | 0.99 | 3.10 | 3.97 |
| dictionary/compile/english-15 | 1 | 0.35 ± 21.4% | not timed | not timed | 0.07 ± 0.8% | 0.10 ± 8.9% | not timed | not timed | 0.35 ± 1.7% | | 0.99 | 5.01 | 3.43 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 1.8% | not timed | not timed | 0.02 ± 1.1% | 35.40 ± 1.9% | not timed | not timed | 0.25 ± 1.2% | | 1.00 | 13.30 | 0.0071 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.71 ± 2.1% | not timed | not timed | 11.54 ± 0.2% | 53.13 ± 20.7% | not timed | not timed | 47.91 ± 2.3% | | 1.00 | 4.13 | 0.90 |
| reported/i787-keywords/compile | 1 | 35.28 ± 4.8% | not timed | not timed | 2.12 ± 1.7% | 16.43 ± 35.9% | not timed | not timed | 35.34 ± 5.0% | | 1.00 | 16.68 | 2.15 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 360.94 ± 1.7% | not timed | not timed | 122.30 ± 0.3% | 567.17 ± 7.6% | not timed | not timed | 365.58 ± 1.6% | | 0.99 | 2.95 | 0.64 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.90 ± 1.8% | not timed | not timed | 4.12 ± 0.7% | 43.35 ± 10.2% | not timed | not timed | 48.50 ± 3.6% | | 0.99 | 11.64 | 1.11 |
| unicode/compile/one-letter | 53 | 6.80 ± 3.0% | not timed | not timed | 4.56 ± 0.5% | 65.59 ± 6.3% | not timed | not timed | 6.80 ± 12.6% | | 1.00 | 1.49 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.08 ± 14.6% | not timed | not timed | 0.10 ± 0.4% | 65.32 ± 16.8% | not timed | not timed | 1.10 ± 2.3% | | 0.98 | 10.85 | 0.0165 |
| unicode/compile/fifty-letters-ascii | 1 | 222.51 ± 8.4% | not timed | not timed | 53.15 ± 0.2% | 198.79 ± 18.4% | not timed | not timed | 224.19 ± 13.2% | | 0.99 | 4.19 | 1.12 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 380.76 ± 8.8% | not timed | not timed | 47.27 ± 0.3% | 643.78 ± 19.8% | not timed | not timed | 385.24 ± 1.8% | | 0.99 | 8.06 | 0.59 |
| unicode/compile/match-every-line-ascii | 4 | 606.15 ± 7.1% | not timed | not timed | 144.42 ± 0.3% | 670.47 ± 30.6% | not timed | not timed | 613.58 ± 22.4% | | 0.99 | 4.20 | 0.90 |
| unicode/compile/negated-class-matches-codepoint | 1 | 325.99 ± 4.2% | not timed | not timed | 51.54 ± 0.3% | 1214.67 ± 4.8% | not timed | not timed | 332.71 ± 4.5% | | 0.98 | 6.33 | 0.27 |
| wild/bibleref/compile | 3 | 5.93 ± 4.2% | not timed | not timed | 1.94 ± 0.6% | 30.43 ± 6.4% | not timed | not timed | 5.95 ± 4.1% | | 1.00 | 3.05 | 0.19 |
| wild/url/compile | 1 | 0.65 ± 19.0% | not timed | not timed | 0.14 ± 0.5% | 0.46 ± 31.8% | not timed | not timed | 0.66 ± 20.5% | | 0.99 | 4.52 | 1.43 |

