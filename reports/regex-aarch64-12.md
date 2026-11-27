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
| literal: a word | 217 | 19525.68 ± 0.9% | 10806.38 ± 0.7% | 28.15 ± 0.3% | 18118.13 ± 1.3% | 9214.44 ± 7.5% | 17.56 ± 0.2% | 86.13 ± 0.7% | 19435.74 ± 1.2% | 1.81 | 1.00 | 1.08 | 2.12 |
| literal: a word that is not there | 0 | 21590.08 ± 1.2% | 9861.20 ± 0.3% | 28.24 ± 0.3% | 19696.13 ± 0.7% | 29050.77 ± 1.5% | 17.33 ± 0.2% | 80.65 ± 0.5% | 21548.36 ± 1.6% | 2.19 | 1.00 | 1.10 | 0.74 |
| literal: one of four words | 661 | 6408.63 ± 0.4% | 1789.06 ± 0.4% | 14.40 ± 0.2% | 3934.17 ± 0.2% | 21.87 ± 0.1% | 5.30 ± 0.2% | 6.93 ± 0.2% | 6420.43 ± 0.6% | 3.58 | 1.00 | 1.63 | 293.07 |
| literal: a word in any case | 217 | 15131.91 ± 1.1% | 1910.06 ± 0.5% | 21.49 ± 0.1% | 3948.67 ± 0.2% | 37.92 ± 0.2% | refused | differs | 15179.79 ± 1.0% | 7.92 | 1.00 | 3.83 | 399.09 |
| literal: an href attribute | 33 | 16837.01 ± 0.7% | 607.93 ± 0.1% | 27.23 ± 0.1% | 16852.73 ± 1.0% | 2250.40 ± 0.9% | 13.37 ± 0.1% | 75.16 ± 0.3% | 16816.29 ± 0.7% | 27.70 | 1.00 | 1.00 | 7.48 |
| literal: a word, second text | 123 | 19918.33 ± 2.3% | 4580.26 ± 0.9% | 27.94 ± 0.2% | 18415.13 ± 0.6% | 7754.62 ± 5.9% | 19.76 ± 0.3% | 70.40 ± 0.6% | 19971.88 ± 0.7% | 4.35 | 1.00 | 1.08 | 2.57 |
| class: two capitalized words | 1331 | 1177.52 ± 0.3% | 597.62 ± 0.4% | 25.93 ± 0.3% | 585.28 ± 0.1% | 40.57 ± 8.7% | 14.91 ± 0.5% | 67.74 ± 0.5% | 1175.40 ± 0.3% | 1.97 | 1.00 | 2.01 | 29.02 |
| class: a word that ends in ing | 3399 | 574.16 ± 0.2% | 572.60 ± 0.5% | 17.86 ± 0.2% | 546.92 ± 0.1% | 29.51 ± 12.4% | 8.19 ± 0.3% | 18.37 ± 0.2% | 574.18 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.46 |
| class: a word in capitals | 2332 | 1534.64 ± 0.5% | 606.76 ± 0.2% | 27.56 ± 0.3% | 572.00 ± 0.1% | 43.42 ± 7.2% | 17.20 ± 0.2% | 83.27 ± 0.6% | 1531.68 ± 0.2% | 2.53 | 1.00 | 2.68 | 35.34 |
| class: a number | 8288 | 2668.63 ± 0.6% | 839.67 ± 0.1% | 27.56 ± 0.3% | 1702.22 ± 0.3% | 42.59 ± 16.3% | 0.56 ± 0.5% | 57.18 ± 0.3% | 2662.67 ± 0.7% | 3.18 | 1.00 | 1.57 | 62.66 |
| class: two capitalized words, second text | 5359 | 521.31 ± 0.4% | 527.72 ± 0.4% | 22.68 ± 0.5% | 483.39 ± 0.1% | 35.36 ± 14.2% | 16.68 ± 0.4% | 63.12 ± 0.4% | 521.14 ± 0.3% | 0.99 | 1.00 | 1.08 | 14.74 |
| other: a word between two words | 6104 | 808.59 ± 0.3% | 601.14 ± 0.2% | 23.41 ± 0.1% | 735.91 ± 0.1% | 111.08 ± 15.5% | 11.35 ± 0.2% | 69.25 ± 0.3% | 809.17 ± 0.2% | 1.35 | 1.00 | 1.10 | 7.28 |
| other: a number before a unit, second text | 1481 | 6196.98 ± 0.8% | 1140.21 ± 0.3% | 25.91 ± 0.2% | 5642.07 ± 0.4% | 40.68 ± 0.1% | 17.74 ± 0.1% | 65.55 ± 0.3% | 6259.05 ± 1.4% | 5.43 | 0.99 | 1.10 | 152.35 |
| other: a heading's start tag | 110 | 14080.65 ± 0.8% | 738.85 ± 0.3% | 27.25 ± 0.1% | 1697.96 ± 0.3% | 1576.82 ± 4.7% | 16.32 ± 0.5% | 87.79 ± 0.5% | 14114.75 ± 0.5% | 19.06 | 1.00 | 8.29 | 8.93 |
| other: a whole word | 217 | 16332.45 ± 1.4% | 600.11 ± 0.5% | 28.73 ± 0.4% | 14496.17 ± 0.4% | 49.23 ± 0.2% | 13.78 ± 0.3% | 54.97 ± 0.3% | 16439.70 ± 1.0% | 27.22 | 0.99 | 1.13 | 331.79 |
| other: a line's first word, second text | 3716 | 2091.21 ± 0.4% | 591.30 ± 0.2% | 30.75 ± 0.2% | 1724.42 ± 0.5% | 62.67 ± 6.7% | refused | refused | 2100.68 ± 1.1% | 3.54 | 1.00 | 1.21 | 33.37 |
| other: fourteen octets before an x | 87 | 24435.70 ± 0.8% | 232.81 ± 0.4% | 6.46 ± 0.1% | 3920.85 ± 0.9% | 10.60 ± 0.0% | differs | 17.87 ± 0.1% | 24395.31 ± 6.5% | 104.96 | 1.00 | 6.23 | 2305.41 |
| other: a Greek word | 21815 | 527.48 ± 0.8% | 423.03 ± 0.2% | 30.43 ± 0.1% | 289.47 ± 0.5% | 47.99 ± 14.5% | differs | refused | 528.05 ± 0.5% | 1.25 | 1.00 | 1.82 | 10.99 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.64 ± 0.2% | 29.64 ± 0.2% | 0.85 ± 0.1% | 19.71 ± 0.6% | 2.76 ± 0.9% | differs | 3.97 ± 0.1% | 29.57 ± 0.5% | 1.00 | 1.00 | 1.50 | 10.72 |
| a UUID | 32895 | 24.72 ± 0.3% | 24.74 ± 0.3% | 0.64 ± 0.3% | 15.12 ± 0.3% | 3.11 ± 0.4% | 0.72 ± 0.3% | 3.61 ± 0.3% | 24.81 ± 0.3% | 1.00 | 1.00 | 1.63 | 7.94 |
| an IPv4 address | 33176 | 38.60 ± 0.2% | 38.61 ± 0.3% | 2.07 ± 0.5% | 29.19 ± 0.6% | 6.63 ± 0.2% | differs | 4.20 ± 0.1% | 38.56 ± 0.4% | 1.00 | 1.00 | 1.32 | 5.82 |
| a date and time | 32954 | 34.02 ± 0.3% | 34.14 ± 0.2% | 1.43 ± 0.3% | 21.46 ± 0.2% | 6.98 ± 0.5% | 1.20 ± 0.4% | 7.09 ± 0.1% | 34.18 ± 0.4% | 1.00 | 1.00 | 1.59 | 4.88 |
| a field path | 32606 | 31.91 ± 0.1% | 32.85 ± 0.2% | 1.01 ± 0.2% | 23.11 ± 0.6% | 3.48 ± 0.6% | differs | 2.92 ± 0.1% | 32.75 ± 0.1% | 0.97 | 0.97 | 1.38 | 9.17 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.16 ± 1.0% | 11.13 ± 1.0% | 11.16 ± 0.4% | 11.44 ± 0.1% | 4.82 ± 3.9% | 0.91 ± 0.5% | none | 11.16 ± 0.5% | 1.00 | 1.00 | 0.98 | 2.32 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.26 ± 0.6% | 221.98 ± 0.6% | 261.30 ± 0.4% | 86.10 ± 0.5% | 220.51 ± 0.8% | 471.51 ± 0.7% | 3724.78 ± 2.5% | 222.14 ± 0.9% | 1.00 | 1.00 | 2.58 | 1.01 |
| a UUID | 62 | 147.07 ± 0.7% | 147.33 ± 0.2% | 164.03 ± 0.2% | 45.93 ± 0.6% | 99.24 ± 0.7% | 177.69 ± 1.5% | 4352.84 ± 0.2% | 147.23 ± 0.6% | 1.00 | 1.00 | 3.20 | 1.48 |
| an IPv4 address | 29 | 420.88 ± 0.7% | 421.61 ± 0.2% | 587.25 ± 0.6% | 76.48 ± 0.7% | 130.86 ± 2.4% | 290.62 ± 1.3% | 7536.71 ± 0.4% | 421.20 ± 0.7% | 1.00 | 1.00 | 5.50 | 3.22 |
| a date and time | 56 | 303.09 ± 0.4% | 302.83 ± 0.4% | 380.19 ± 0.6% | 71.65 ± 1.4% | 137.47 ± 2.0% | 314.32 ± 0.9% | 4925.57 ± 0.6% | 302.96 ± 0.3% | 1.00 | 1.00 | 4.23 | 2.20 |
| a field path | 39 | 215.31 ± 1.5% | 215.59 ± 0.8% | 251.77 ± 0.4% | 80.34 ± 1.1% | 205.34 ± 1.2% | 481.58 ± 1.6% | 4717.03 ± 2.8% | 215.18 ± 1.0% | 1.00 | 1.00 | 2.68 | 1.05 |
| literal: a word | 7 | 603.12 ± 0.2% | 649.62 ± 0.3% | 1128.87 ± 0.1% | 504.19 ± 0.1% | 629.74 ± 3.7% | 921.16 ± 0.7% | 29506.68 ± 0.3% | 603.94 ± 0.5% | 0.93 | 1.00 | 1.20 | 0.96 |
| literal: a word that is not there | 8 | 585.14 ± 0.2% | 633.81 ± 0.6% | 1086.22 ± 0.6% | 461.67 ± 0.4% | 603.17 ± 1.1% | 882.79 ± 0.5% | 28527.36 ± 0.4% | 585.97 ± 0.6% | 0.92 | 1.00 | 1.27 | 0.97 |
| literal: one of four words | 26 | 246.03 ± 0.2% | 390.27 ± 0.4% | 529.80 ± 0.6% | 49.52 ± 0.8% | 241.03 ± 3.8% | 357.74 ± 0.4% | 15454.72 ± 0.2% | 246.20 ± 0.3% | 0.63 | 1.00 | 4.97 | 1.02 |
| literal: a word in any case | 11 | 438.76 ± 0.3% | 467.52 ± 0.4% | 683.47 ± 0.3% | 15.74 ± 0.4% | 650.79 ± 1.6% | refused | 23386.76 ± 0.3% | 439.71 ± 0.4% | 0.94 | 1.00 | 27.88 | 0.67 |
| literal: an href attribute | 12 | 340.15 ± 0.3% | 352.02 ± 0.2% | 459.85 ± 0.2% | 45.36 ± 0.8% | 498.85 ± 0.5% | 768.37 ± 2.5% | 21507.81 ± 0.2% | 339.94 ± 0.1% | 0.97 | 1.00 | 7.50 | 0.68 |
| literal: a word, second text | 10 | 536.19 ± 0.3% | 588.05 ± 0.5% | 969.55 ± 0.1% | 420.38 ± 0.5% | 533.36 ± 0.9% | 810.73 ± 0.7% | 26512.19 ± 0.1% | 537.28 ± 0.7% | 0.91 | 1.00 | 1.28 | 1.01 |
| class: two capitalized words | 23 | 431.07 ± 0.5% | 458.87 ± 0.4% | 658.81 ± 0.6% | 100.73 ± 0.1% | 502.52 ± 1.0% | 748.45 ± 0.3% | 6272.28 ± 0.2% | 431.63 ± 0.3% | 0.94 | 1.00 | 4.28 | 0.86 |
| class: a word that ends in ing | 9 | 549.39 ± 0.3% | 614.25 ± 0.1% | 1056.95 ± 0.2% | 132.76 ± 0.2% | 756.30 ± 1.4% | 1122.38 ± 2.1% | 15605.80 ± 0.1% | 549.37 ± 0.2% | 0.89 | 1.00 | 4.14 | 0.73 |
| class: a word in capitals | 16 | 491.93 ± 0.1% | 528.24 ± 0.3% | 832.49 ± 0.2% | 135.76 ± 0.8% | 752.33 ± 2.0% | 1014.79 ± 0.7% | 8223.01 ± 0.2% | 492.30 ± 0.1% | 0.93 | 1.00 | 3.62 | 0.65 |
| class: a number | 6 | 620.92 ± 0.3% | 678.32 ± 0.4% | 1249.73 ± 0.1% | 42.08 ± 0.7% | 1399.80 ± 1.3% | 1868.38 ± 1.1% | 22243.45 ± 0.1% | 620.04 ± 0.6% | 0.92 | 1.00 | 14.76 | 0.44 |
| class: two capitalized words, second text | 23 | 431.35 ± 0.3% | 457.87 ± 0.5% | 658.24 ± 0.1% | 101.98 ± 1.4% | 501.14 ± 3.2% | 752.02 ± 0.4% | 6269.76 ± 0.1% | 431.65 ± 0.4% | 0.94 | 1.00 | 4.23 | 0.86 |
| other: a word between two words | 13 | 530.52 ± 0.8% | 551.08 ± 0.2% | 871.78 ± 0.2% | 136.18 ± 0.5% | 498.98 ± 0.8% | 807.40 ± 0.6% | 14452.24 ± 0.2% | 530.89 ± 0.5% | 0.96 | 1.00 | 3.90 | 1.06 |
| other: a number before a unit, second text | 15 | 384.39 ± 0.4% | 421.51 ± 0.3% | 584.76 ± 0.6% | 39.42 ± 0.5% | 630.56 ± 0.9% | 875.10 ± 0.3% | 14995.38 ± 0.4% | 384.53 ± 0.3% | 0.91 | 1.00 | 9.75 | 0.61 |
| other: a heading's start tag | 13 | 349.88 ± 0.3% | 356.00 ± 0.2% | 467.89 ± 0.3% | 44.39 ± 0.6% | 625.77 ± 0.7% | 868.10 ± 0.2% | 17768.47 ± 0.1% | 350.25 ± 0.4% | 0.98 | 1.00 | 7.88 | 0.56 |
| other: a whole word | 11 | 561.48 ± 0.8% | 597.28 ± 1.0% | 993.47 ± 1.5% | 120.46 ± 0.3% | 565.14 ± 2.4% | 822.94 ± 1.5% | 26609.89 ± 0.5% | 562.16 ± 0.9% | 0.94 | 1.00 | 4.66 | 0.99 |
| other: a line's first word, second text | 17 | 509.34 ± 0.3% | 545.01 ± 0.3% | 866.04 ± 0.1% | 128.59 ± 0.1% | 705.21 ± 1.0% | refused | refused | 510.52 ± 0.4% | 0.93 | 1.00 | 3.96 | 0.72 |
| other: fourteen octets before an x | 16 | 109.12 ± 0.9% | 156.23 ± 1.7% | 179.38 ± 2.3% | 15.14 ± 0.4% | 450.51 ± 1.6% | 398.72 ± 1.0% | 12680.84 ± 0.3% | 109.41 ± 0.2% | 0.70 | 1.00 | 7.21 | 0.24 |
| other: a Greek word | 8 | 448.64 ± 0.5% | 587.27 ± 0.4% | 977.35 ± 0.7% | 58.75 ± 0.5% | 1387.20 ± 1.1% | 1815.69 ± 0.6% | refused | 448.54 ± 0.5% | 0.76 | 1.00 | 7.64 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15745.11 ± 0.7% | not timed | not timed | 16235.95 ± 0.7% | 1948.72 ± 20.2% | not timed | not timed | 15738.68 ± 1.4% | | 1.00 | 0.97 | 8.08 |
| 01-literal/sherlock-casei-en | 522 | 10781.20 ± 3.6% | not timed | not timed | 3584.60 ± 0.2% | 32.35 ± 1.7% | not timed | not timed | 10777.05 ± 1.5% | | 1.00 | 3.01 | 333.23 |
| 01-literal/sherlock-ru | 724 | 17013.54 ± 0.9% | not timed | not timed | 17319.50 ± 0.2% | 1463.44 ± 17.8% | not timed | not timed | 17094.40 ± 0.4% | | 1.00 | 0.98 | 11.63 |
| 01-literal/sherlock-casei-ru | 746 | 6111.98 ± 0.2% | not timed | not timed | 3317.73 ± 0.2% | 31.70 ± 0.3% | not timed | not timed | 6106.57 ± 0.5% | | 1.00 | 1.84 | 192.79 |
| 01-literal/sherlock-zh | 30 | 19860.42 ± 0.5% | not timed | not timed | 18754.76 ± 0.9% | 2722.26 ± 13.2% | not timed | not timed | 19863.16 ± 0.8% | | 1.00 | 1.06 | 7.30 |
| 02-literal-alternate/sherlock-en | 714 | 6112.08 ± 0.4% | not timed | not timed | 3932.08 ± 0.2% | 16.63 ± 0.1% | not timed | not timed | 6113.48 ± 0.3% | | 1.00 | 1.55 | 367.59 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1963.79 ± 1.4% | not timed | not timed | 695.73 ± 0.2% | 11.02 ± 0.2% | not timed | not timed | 1964.64 ± 1.1% | | 1.00 | 2.82 | 178.16 |
| 02-literal-alternate/sherlock-ru | 899 | 5496.61 ± 0.2% | not timed | not timed | 3245.42 ± 0.3% | 22.60 ± 0.1% | not timed | not timed | 5495.44 ± 0.4% | | 1.00 | 1.69 | 243.24 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2043.12 ± 0.5% | not timed | not timed | 1227.41 ± 0.8% | 9.12 ± 0.2% | not timed | not timed | 2044.44 ± 0.5% | | 1.00 | 1.66 | 224.11 |
| 02-literal-alternate/sherlock-zh | 207 | 7293.19 ± 0.2% | not timed | not timed | 4156.02 ± 0.5% | 31.40 ± 2.1% | not timed | not timed | 7284.40 ± 0.5% | | 1.00 | 1.75 | 232.28 |
| 03-date/ascii | 111817 | 134.01 ± 0.6% | not timed | not timed | 95.56 ± 0.4% | 0.20 ± 3.0% | not timed | not timed | 134.15 ± 0.8% | | 1.00 | 1.40 | 677.78 |
| 04-ruff-noqa/real | 84 | 438.43 ± 0.3% | not timed | not timed | 465.83 ± 0.1% | 19.44 ± 1.2% | not timed | not timed | 436.67 ± 0.2% | | 1.00 | 0.94 | 22.55 |
| 04-ruff-noqa/tweaked | 44 | 844.39 ± 0.1% | not timed | not timed | 461.10 ± 0.1% | 362.71 ± 0.3% | not timed | not timed | 844.99 ± 0.1% | | 1.00 | 1.83 | 2.33 |
| 05-lexer-veryl/single | 124800 | 5.34 ± 0.6% | not timed | not timed | 4.92 ± 0.3% | 0.20 ± 4.1% | not timed | not timed | 5.33 ± 0.5% | | 1.00 | 1.09 | 26.47 |
| 06-cloud-flare-redos/original | 107 | 439.93 ± 0.2% | not timed | not timed | 213.02 ± 0.1% | 24.85 ± 0.2% | not timed | not timed | 439.00 ± 0.1% | | 1.00 | 2.07 | 17.70 |
| 06-cloud-flare-redos/simplified-short | 102 | 438.84 ± 0.1% | not timed | not timed | 228.90 ± 0.1% | 26.59 ± 0.2% | not timed | not timed | 439.00 ± 0.2% | | 1.00 | 1.92 | 16.51 |
| 06-cloud-flare-redos/simplified-long | 10000 | 628.17 ± 0.2% | not timed | not timed | 255.85 ± 0.1% | 28.74 ± 0.2% | not timed | not timed | 628.81 ± 0.2% | | 1.00 | 2.46 | 21.86 |
| 07-unicode-character-data/parse-line | 558784 | 241.90 ± 2.3% | not timed | not timed | 169.35 ± 0.2% | 43.14 ± 5.6% | not timed | not timed | 242.80 ± 1.5% | | 1.00 | 1.43 | 5.61 |
| 08-words/all-english | 56691 | 128.61 ± 1.0% | not timed | not timed | 82.84 ± 0.2% | 13.01 ± 12.2% | not timed | not timed | 129.36 ± 0.5% | | 0.99 | 1.55 | 9.88 |
| 08-words/long-english | 839 | 617.05 ± 0.4% | not timed | not timed | 596.65 ± 0.3% | 32.60 ± 4.2% | not timed | not timed | 617.52 ± 0.4% | | 1.00 | 1.03 | 18.93 |
| 09-aws-keys/full | 0 | 442.27 ± 0.2% | not timed | not timed | 464.29 ± 0.1% | 63.80 ± 3.5% | not timed | not timed | 442.82 ± 0.2% | | 1.00 | 0.95 | 6.93 |
| 09-aws-keys/quick | 0 | 873.12 ± 0.4% | not timed | not timed | 989.68 ± 0.5% | 418.65 ± 0.7% | not timed | not timed | 872.65 ± 0.3% | | 1.00 | 0.88 | 2.09 |
| 10-bounded-repeat/letters-en | 1833 | 578.29 ± 1.6% | not timed | not timed | 516.14 ± 0.6% | 19.52 ± 0.5% | not timed | not timed | 580.93 ± 1.9% | | 1.00 | 1.12 | 29.62 |
| 10-bounded-repeat/letters-ru | 3475 | 505.39 ± 1.9% | not timed | not timed | 478.59 ± 0.1% | 21.90 ± 9.0% | not timed | not timed | 507.21 ± 1.2% | | 1.00 | 1.06 | 23.08 |
| 10-bounded-repeat/context | 53 | 84.95 ± 1.8% | not timed | not timed | 65.81 ± 0.6% | 19.76 ± 0.2% | not timed | not timed | 84.99 ± 1.4% | | 1.00 | 1.29 | 4.30 |
| 10-bounded-repeat/capitals | 11 | 637.09 ± 8.1% | not timed | not timed | 616.07 ± 0.1% | 36.57 ± 0.1% | not timed | not timed | 634.72 ± 8.5% | | 1.00 | 1.03 | 17.42 |
| 11-unstructured-to-json/extract | 600 | 57.73 ± 0.2% | not timed | not timed | 76.06 ± 0.3% | 48.96 ± 0.3% | not timed | not timed | 57.73 ± 0.2% | | 1.00 | 0.76 | 1.18 |
| 12-dictionary/single | 1 | 559.13 ± 1.7% | not timed | not timed | 560.03 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 560.79 ± 1.4% | | 1.00 | 1.00 | 1385.77 |
| 14-quadratic/1x | 100 | 22.08 ± 1.5% | not timed | not timed | 9.97 ± 0.3% | 0.95 ± 2.8% | not timed | not timed | 22.12 ± 0.9% | | 1.00 | 2.21 | 23.24 |
| 14-quadratic/2x | 200 | 19.70 ± 0.9% | not timed | not timed | 5.53 ± 0.2% | 0.53 ± 1.9% | not timed | not timed | 19.78 ± 0.7% | | 1.00 | 3.56 | 37.06 |
| 14-quadratic/10x | 1000 | 12.32 ± 0.6% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 1.6% | not timed | not timed | 12.33 ± 0.9% | | 1.00 | 10.16 | 107.10 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 2.9% | not timed | not timed | 0.34 ± 0.6% | 0.55 ± 2.7% | not timed | not timed | 1.27 ± 0.3% | | 1.00 | 3.69 | 2.32 |
| 04-ruff-noqa/compile-real | 1 | 105.80 ± 1.3% | not timed | not timed | 13.71 ± 0.4% | 140.25 ± 3.2% | not timed | not timed | 106.00 ± 1.7% | | 1.00 | 7.72 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 14.04 ± 0.4% | not timed | not timed | 2.50 ± 0.6% | 6.47 ± 1.5% | not timed | not timed | 14.07 ± 1.5% | | 1.00 | 5.62 | 2.17 |
| 07-unicode-character-data/compile | 1 | 109.84 ± 0.5% | not timed | not timed | 25.58 ± 0.3% | 36.38 ± 2.3% | not timed | not timed | 109.82 ± 0.5% | | 1.00 | 4.29 | 3.02 |
| 09-aws-keys/compile-full | 1 | 53.10 ± 0.8% | not timed | not timed | 8.20 ± 0.4% | 23.45 ± 1.2% | not timed | not timed | 53.33 ± 1.1% | | 1.00 | 6.47 | 2.26 |
| 09-aws-keys/compile-quick | 1 | 188.03 ± 0.4% | not timed | not timed | 47.03 ± 0.3% | 135.59 ± 3.2% | not timed | not timed | 188.26 ± 0.5% | | 1.00 | 4.00 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 72.48 ± 1.2% | not timed | not timed | 11.17 ± 0.4% | 16.27 ± 2.5% | not timed | not timed | 72.63 ± 2.1% | | 1.00 | 6.49 | 4.45 |
| 10-bounded-repeat/compile-capitals | 1 | 85.36 ± 0.8% | not timed | not timed | 8.11 ± 0.4% | 24.09 ± 1.4% | not timed | not timed | 85.78 ± 0.3% | | 1.00 | 10.53 | 3.54 |
| 11-unstructured-to-json/compile | 1 | 173.94 ± 1.4% | not timed | not timed | 40.86 ± 0.7% | 69.02 ± 2.3% | not timed | not timed | 174.01 ± 1.2% | | 1.00 | 4.26 | 2.52 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.4% | not timed | not timed | 0.07 ± 9.7% | 0.09 ± 16.2% | not timed | not timed | 0.35 ± 2.6% | | 0.99 | 5.09 | 3.70 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.45 ± 0.7% | not timed | not timed | 6.48 ± 0.1% | 0.60 ± 14.6% | not timed | not timed | 7.43 ± 0.3% | | 1.00 | 1.15 | 12.33 |
| dictionary/search/english-10 | 690 | 205.30 ± 2.7% | not timed | not timed | 166.12 ± 0.7% | 0.00 ± 0.9% | not timed | not timed | 210.65 ± 0.7% | | 0.97 | 1.24 | 71817.98 |
| dictionary/search/english-15 | 15 | 558.78 ± 1.6% | not timed | not timed | 560.38 ± 0.1% | 0.37 ± 0.2% | not timed | not timed | 560.62 ± 1.3% | | 1.00 | 1.00 | 1527.25 |
| folly/awyer-inn-busted | 1 | 21468.20 ± 0.1% | not timed | not timed | 141.39 ± 0.2% | 43.80 ± 0.2% | not timed | not timed | 21531.99 ± 0.2% | | 1.00 | 151.84 | 490.13 |
| folly/literal-never-match-rare | 0 | 21088.75 ± 0.4% | not timed | not timed | 19908.20 ± 0.1% | 40888.75 ± 0.2% | not timed | not timed | 21088.04 ± 0.1% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12517.53 ± 0.7% | not timed | not timed | 19856.63 ± 0.2% | 2189.10 ± 0.6% | not timed | not timed | 12534.78 ± 0.5% | | 1.00 | 0.63 | 5.72 |
| folly/literal-never-match-tricksy | 1 | 3251.65 ± 0.6% | not timed | not timed | 4406.67 ± 0.1% | 3044.83 ± 0.3% | not timed | not timed | 3255.95 ± 0.3% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1301.43 ± 0.6% | not timed | not timed | 952.12 ± 0.1% | 373.97 ± 19.2% | not timed | not timed | 1308.35 ± 0.6% | | 0.99 | 1.37 | 3.48 |
| grep/long-words-ascii | 5073 | 459.33 ± 0.1% | not timed | not timed | 467.68 ± 0.0% | 46.01 ± 6.8% | not timed | not timed | 457.95 ± 0.4% | | 1.00 | 0.98 | 9.98 |
| imported/leipzig/twain | 811 | 20633.75 ± 1.5% | not timed | not timed | 19534.12 ± 0.4% | 11894.35 ± 10.3% | not timed | not timed | 20714.34 ± 0.9% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9036.22 ± 0.9% | not timed | not timed | 4240.16 ± 0.2% | 37.56 ± 0.8% | not timed | not timed | 9129.08 ± 1.6% | | 0.99 | 2.13 | 240.59 |
| imported/leipzig/shing | 1540 | 15148.37 ± 25.1% | not timed | not timed | 13458.43 ± 19.2% | 33.98 ± 0.1% | not timed | not timed | 15500.63 ± 2.9% | | 0.98 | 1.13 | 445.77 |
| imported/leipzig/huck-saw | 262 | 8189.44 ± 3.6% | not timed | not timed | 5588.55 ± 0.1% | 31.58 ± 0.1% | not timed | not timed | 8427.19 ± 4.6% | | 0.97 | 1.47 | 259.35 |
| imported/leipzig/word-ending-nn | 262 | 598.80 ± 0.9% | not timed | not timed | 615.57 ± 0.7% | 24.76 ± 0.3% | not timed | not timed | 601.99 ± 1.1% | | 0.99 | 0.97 | 24.19 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11179.93 ± 1.1% | not timed | not timed | 4542.27 ± 0.6% | 11.49 ± 0.0% | not timed | not timed | 11267.14 ± 1.5% | | 0.99 | 2.46 | 972.79 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7772.00 ± 1.9% | not timed | not timed | 5479.01 ± 0.1% | 16.83 ± 0.0% | not timed | not timed | 7932.54 ± 2.4% | | 0.98 | 1.42 | 461.80 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4147.64 ± 1.2% | not timed | not timed | 415.43 ± 0.7% | 11.06 ± 0.1% | not timed | not timed | 4165.70 ± 1.3% | | 1.00 | 9.98 | 375.00 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7298.46 ± 2.8% | not timed | not timed | 614.72 ± 0.0% | 11.13 ± 0.0% | not timed | not timed | 7350.04 ± 3.1% | | 0.99 | 11.87 | 655.71 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7155.28 ± 3.6% | not timed | not timed | 614.47 ± 0.1% | 9.73 ± 0.0% | not timed | not timed | 7288.41 ± 3.1% | | 0.98 | 11.64 | 735.16 |
| imported/leipzig/tom-river | 2 | 6457.30 ± 2.1% | not timed | not timed | 5140.21 ± 0.1% | 31.04 ± 0.1% | not timed | not timed | 6576.33 ± 2.2% | | 0.98 | 1.26 | 208.05 |
| imported/leipzig/ing | 78424 | 600.12 ± 1.1% | not timed | not timed | 571.57 ± 0.1% | 28.09 ± 3.2% | not timed | not timed | 602.13 ± 0.9% | | 1.00 | 1.05 | 21.36 |
| imported/leipzig/ing-whitespace | 55248 | 1921.66 ± 1.4% | not timed | not timed | 2080.47 ± 0.2% | 20.50 ± 2.9% | not timed | not timed | 1925.12 ± 0.8% | | 1.00 | 0.92 | 93.72 |
| imported/leipzig/awyer-inn | 209 | 6332.97 ± 1.5% | not timed | not timed | 4276.20 ± 0.1% | 22.46 ± 0.1% | not timed | not timed | 6355.23 ± 1.0% | | 1.00 | 1.48 | 281.95 |
| imported/leipzig/quotes-bounded | 8886 | 2476.60 ± 1.2% | not timed | not timed | 3009.79 ± 0.6% | 37.79 ± 0.2% | not timed | not timed | 2496.04 ± 1.2% | | 0.99 | 0.82 | 65.54 |
| imported/leipzig/non-ascii-alternate | 2 | 12777.83 ± 2.3% | not timed | not timed | 5655.34 ± 0.1% | 50.50 ± 0.1% | not timed | not timed | 13050.86 ± 2.2% | | 0.98 | 2.26 | 253.00 |
| imported/leipzig/math-symbols | 69 | 1976.27 ± 0.5% | not timed | not timed | 612.75 ± 0.1% | 36.44 ± 0.4% | not timed | not timed | 1983.70 ± 0.9% | | 1.00 | 3.23 | 54.24 |
| imported/leipzig/bounded-strings-ending-z | 0 | 632.52 ± 2.3% | not timed | not timed | 615.66 ± 0.1% | 22.45 ± 0.1% | not timed | not timed | 632.08 ± 1.1% | | 1.00 | 1.03 | 28.17 |
| imported/lh3lh3-reb/uri | 17549 | 677.65 ± 0.1% | not timed | not timed | 1067.59 ± 0.2% | 27.91 ± 2.5% | not timed | not timed | 679.11 ± 0.3% | | 1.00 | 0.63 | 24.28 |
| imported/lh3lh3-reb/email | 15057 | 673.90 ± 0.1% | not timed | not timed | 1153.84 ± 0.2% | 30.67 ± 2.3% | not timed | not timed | 676.23 ± 0.3% | | 1.00 | 0.58 | 21.97 |
| imported/lh3lh3-reb/date | 668 | 891.58 ± 0.2% | not timed | not timed | 1029.32 ± 0.2% | 50.89 ± 4.0% | not timed | not timed | 892.62 ± 0.1% | | 1.00 | 0.87 | 17.52 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 644.50 ± 0.1% | not timed | not timed | 422.81 ± 0.1% | 15.63 ± 1.6% | not timed | not timed | 646.13 ± 0.1% | | 1.00 | 1.52 | 41.24 |
| imported/mariomka/email | 92 | 24171.38 ± 2.1% | not timed | not timed | 29411.49 ± 0.5% | 32.79 ± 0.1% | not timed | not timed | 24236.59 ± 1.2% | | 1.00 | 0.82 | 737.11 |
| imported/mariomka/uri | 5301 | 5526.27 ± 7.9% | not timed | not timed | 6060.90 ± 12.4% | 32.67 ± 0.6% | not timed | not timed | 5571.26 ± 6.7% | | 0.99 | 0.91 | 169.13 |
| imported/mariomka/ip | 5 | 2595.84 ± 2.9% | not timed | not timed | 2958.29 ± 0.2% | 20.96 ± 0.2% | not timed | not timed | 2600.57 ± 3.1% | | 1.00 | 0.88 | 123.85 |
| imported/rsc/no-exponential | 0 | 610.06 ± 0.3% | not timed | not timed | 320.45 ± 0.3% | 23.67 ± 0.1% | not timed | not timed | 608.11 ± 0.2% | | 1.00 | 1.90 | 25.78 |
| imported/rsc/literal | 1 | 1491.81 ± 7.4% | not timed | not timed | 1620.12 ± 5.4% | 188.67 ± 20.6% | not timed | not timed | 1496.92 ± 6.8% | | 1.00 | 0.92 | 7.91 |
| imported/rsc/not-literal | 2 | 774.36 ± 1.6% | not timed | not timed | 737.08 ± 0.5% | 46.30 ± 9.0% | not timed | not timed | 776.70 ± 0.6% | | 1.00 | 1.05 | 16.73 |
| imported/rsc/match-class | 1 | 1468.73 ± 1.1% | not timed | not timed | 1584.62 ± 0.2% | 58.59 ± 6.1% | not timed | not timed | 1470.26 ± 2.7% | | 1.00 | 0.93 | 25.07 |
| imported/rsc/match-class-in-range | 1 | 1469.53 ± 1.8% | not timed | not timed | 2282.04 ± 5.5% | 59.91 ± 6.0% | not timed | not timed | 1476.75 ± 0.3% | | 1.00 | 0.64 | 24.53 |
| imported/rsc/match-class-unicode | 1 | 539.67 ± 1.9% | not timed | not timed | 511.55 ± 0.3% | 72.31 ± 7.6% | not timed | not timed | 539.40 ± 0.3% | | 1.00 | 1.05 | 7.46 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1457.79 ± 0.2% | not timed | not timed | 949.06 ± 0.1% | 228.00 ± 1.1% | not timed | not timed | 1457.00 ± 0.4% | | 1.00 | 1.54 | 6.39 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21850.15 ± 0.2% | not timed | not timed | 14115.67 ± 0.2% | 3432.44 ± 0.8% | not timed | not timed | 21838.39 ± 0.1% | | 1.00 | 1.55 | 6.37 |
| imported/rsc/anchored-literal-short-match | 4 | 723.12 ± 1.6% | not timed | not timed | 487.95 ± 0.4% | 85.09 ± 7.4% | not timed | not timed | 723.98 ± 1.8% | | 1.00 | 1.48 | 8.50 |
| imported/rsc/anchored-literal-long-match | 4 | 10802.06 ± 0.7% | not timed | not timed | 7320.46 ± 0.2% | 1226.58 ± 1.4% | not timed | not timed | 10861.63 ± 0.6% | | 0.99 | 1.48 | 8.81 |
| imported/rsc/one-pass-short | 17 | 368.06 ± 1.7% | not timed | not timed | 214.94 ± 0.4% | 29.94 ± 10.0% | not timed | not timed | 371.85 ± 1.7% | | 0.99 | 1.71 | 12.29 |
| imported/rsc/one-pass-short-not | 17 | 267.17 ± 2.7% | not timed | not timed | 225.70 ± 0.2% | 29.82 ± 10.9% | not timed | not timed | 268.93 ± 1.8% | | 0.99 | 1.18 | 8.96 |
| imported/rsc/one-pass-long-prefix | 26 | 359.17 ± 2.2% | not timed | not timed | 283.62 ± 0.7% | 107.96 ± 18.6% | not timed | not timed | 362.79 ± 8.0% | | 0.99 | 1.27 | 3.33 |
| imported/rsc/one-pass-long-prefix-not | 26 | 357.87 ± 1.9% | not timed | not timed | 279.69 ± 0.2% | 64.84 ± 20.0% | not timed | not timed | 363.72 ± 2.0% | | 0.98 | 1.28 | 5.52 |
| imported/rsc/long-needle1 | 31 | 21915.98 ± 0.4% | not timed | not timed | 20164.44 ± 0.1% | 3.75 ± 0.1% | not timed | not timed | 21916.37 ± 0.2% | | 1.00 | 1.09 | 5848.01 |
| imported/rsc/long-needle2 | 31 | 22050.02 ± 0.1% | not timed | not timed | 216.31 ± 0.3% | 3.74 ± 0.1% | not timed | not timed | 22035.97 ± 0.1% | | 1.00 | 101.93 | 5897.88 |
| imported/rsc/easy0-32 | 26 | 1539.94 ± 0.3% | not timed | not timed | 1611.62 ± 2.2% | 147.81 ± 20.2% | not timed | not timed | 1543.28 ± 2.2% | | 1.00 | 0.96 | 10.42 |
| imported/rsc/easy0-1k | 26 | 13478.44 ± 0.4% | not timed | not timed | 12617.56 ± 1.6% | 2300.36 ± 13.4% | not timed | not timed | 13531.19 ± 2.2% | | 1.00 | 1.07 | 5.86 |
| imported/rsc/easy0-32k | 26 | 22783.66 ± 0.4% | not timed | not timed | 20400.97 ± 0.1% | 18758.92 ± 8.9% | not timed | not timed | 22797.52 ± 10.0% | | 1.00 | 1.12 | 1.21 |
| imported/rsc/easy0-1mb | 26 | 21859.77 ± 2.5% | not timed | not timed | 20138.17 ± 1.8% | 38351.78 ± 2.3% | not timed | not timed | 21847.74 ± 1.3% | | 1.00 | 1.09 | 0.57 |
| imported/rsc/easy1-32 | 19 | 769.32 ± 2.2% | not timed | not timed | 633.18 ± 0.7% | 138.15 ± 17.0% | not timed | not timed | 768.50 ± 7.8% | | 1.00 | 1.22 | 5.57 |
| imported/rsc/easy1-1k | 19 | 15739.36 ± 2.3% | not timed | not timed | 12836.31 ± 0.1% | 2462.88 ± 14.6% | not timed | not timed | 15752.26 ± 0.3% | | 1.00 | 1.23 | 6.39 |
| imported/rsc/easy1-32k | 19 | 494965.47 ± 0.3% | not timed | not timed | 407354.34 ± 0.4% | 20382.29 ± 0.4% | not timed | not timed | 492746.76 ± 0.4% | | 1.00 | 1.22 | 24.28 |
| imported/rsc/easy1-1mb | 19 | 15898076.62 ± 0.4% | not timed | not timed | 13167410.70 ± 0.2% | 37890.45 ± 3.5% | not timed | not timed | 15845454.66 ± 0.4% | | 1.00 | 1.21 | 419.58 |
| imported/rsc/medium-32 | 27 | 734.20 ± 1.9% | not timed | not timed | 645.91 ± 0.2% | 69.73 ± 10.9% | not timed | not timed | 736.12 ± 0.3% | | 1.00 | 1.14 | 10.53 |
| imported/rsc/medium-1k | 27 | 13076.78 ± 0.2% | not timed | not timed | 11387.31 ± 0.4% | 72.02 ± 0.1% | not timed | not timed | 13080.29 ± 0.3% | | 1.00 | 1.15 | 181.58 |
| imported/rsc/medium-32k | 27 | 407849.13 ± 0.1% | not timed | not timed | 351260.61 ± 0.1% | 48.74 ± 0.1% | not timed | not timed | 408015.94 ± 0.2% | | 1.00 | 1.16 | 8368.68 |
| imported/rsc/medium-1mb | 27 | 13025541.77 ± 0.2% | not timed | not timed | 11240322.39 ± 0.1% | 48.86 ± 0.3% | not timed | not timed | 13007226.06 ± 0.3% | | 1.00 | 1.16 | 266598.12 |
| imported/rsc/hard-32 | 58 | 423.33 ± 2.1% | not timed | not timed | 364.63 ± 0.1% | 49.43 ± 7.1% | not timed | not timed | 420.93 ± 0.3% | | 1.01 | 1.16 | 8.56 |
| imported/rsc/hard-1k | 27 | 12915.85 ± 0.1% | not timed | not timed | 11520.69 ± 0.2% | 40.53 ± 0.1% | not timed | not timed | 12819.58 ± 0.2% | | 1.01 | 1.12 | 318.66 |
| imported/rsc/hard-32k | 27 | 403590.89 ± 0.1% | not timed | not timed | 360609.76 ± 0.2% | 29.32 ± 0.1% | not timed | not timed | 400075.57 ± 0.4% | | 1.01 | 1.12 | 13767.32 |
| imported/rsc/hard-1mb | 51 | 8388175.14 ± 0.2% | not timed | not timed | 7255341.91 ± 0.1% | 29.37 ± 0.0% | not timed | not timed | 8352341.22 ± 0.2% | | 1.00 | 1.16 | 285603.72 |
| imported/rsc/reallyhard0-32 | 58 | 263.75 ± 0.6% | not timed | not timed | 222.84 ± 0.1% | 49.57 ± 7.5% | not timed | not timed | 263.46 ± 2.8% | | 1.00 | 1.18 | 5.32 |
| imported/rsc/reallyhard0-1k | 27 | 579.38 ± 0.4% | not timed | not timed | 579.84 ± 0.1% | 40.53 ± 0.2% | not timed | not timed | 581.38 ± 0.3% | | 1.00 | 1.00 | 14.30 |
| imported/rsc/reallyhard0-32k | 27 | 603.77 ± 0.5% | not timed | not timed | 615.23 ± 0.1% | 29.33 ± 0.2% | not timed | not timed | 600.50 ± 0.2% | | 1.01 | 0.98 | 20.58 |
| imported/rsc/reallyhard0-1mb | 51 | 621.08 ± 0.8% | not timed | not timed | 616.66 ± 0.2% | 29.35 ± 0.1% | not timed | not timed | 623.86 ± 1.1% | | 1.00 | 1.01 | 21.16 |
| imported/rsc/reallyreallyhard0-32 | 47 | 284.97 ± 1.4% | not timed | not timed | 196.32 ± 0.1% | 60.58 ± 16.0% | not timed | not timed | 286.47 ± 3.4% | | 0.99 | 1.45 | 4.70 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6977.51 ± 0.1% | not timed | not timed | 5917.13 ± 0.2% | 33.86 ± 6.2% | not timed | not timed | 6974.42 ± 0.1% | | 1.00 | 1.18 | 206.05 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21470.09 ± 0.1% | not timed | not timed | 19258.79 ± 0.2% | 24.09 ± 1.8% | not timed | not timed | 21469.11 ± 0.2% | | 1.00 | 1.11 | 891.41 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21679.78 ± 1.2% | not timed | not timed | 19919.17 ± 1.3% | 23.39 ± 3.8% | not timed | not timed | 21732.60 ± 1.0% | | 1.00 | 1.09 | 926.76 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 281.06 ± 1.7% | not timed | not timed | 214.82 ± 0.3% | 60.32 ± 14.3% | not timed | not timed | 282.15 ± 1.2% | | 1.00 | 1.31 | 4.66 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5921.91 ± 0.1% | not timed | not timed | 6238.29 ± 0.3% | 33.74 ± 3.8% | not timed | not timed | 5926.00 ± 0.2% | | 1.00 | 0.95 | 175.52 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21350.34 ± 0.1% | not timed | not timed | 19322.50 ± 0.0% | 25.10 ± 0.8% | not timed | not timed | 21336.54 ± 0.1% | | 1.00 | 1.10 | 850.74 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21190.35 ± 1.3% | not timed | not timed | 19785.33 ± 1.1% | 24.93 ± 0.2% | not timed | not timed | 21281.93 ± 0.8% | | 1.00 | 1.07 | 850.09 |
| imported/sherlock/name-sherlock | 776 | 19868.21 ± 5.4% | not timed | not timed | 18599.47 ± 0.6% | 10042.74 ± 22.7% | not timed | not timed | 19927.79 ± 2.6% | | 1.00 | 1.07 | 1.98 |
| imported/sherlock/name-holmes | 2766 | 15207.11 ± 1.4% | not timed | not timed | 15580.83 ± 0.2% | 3223.66 ± 14.3% | not timed | not timed | 15392.99 ± 1.5% | | 0.99 | 0.98 | 4.72 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19888.62 ± 2.2% | not timed | not timed | 18615.84 ± 0.3% | 8054.48 ± 46.7% | not timed | not timed | 19954.59 ± 1.9% | | 1.00 | 1.07 | 2.47 |
| imported/sherlock/name-sherlock-casei | 816 | 15747.88 ± 0.3% | not timed | not timed | 4001.02 ± 0.1% | 32.16 ± 1.4% | not timed | not timed | 15751.86 ± 0.4% | | 1.00 | 3.94 | 489.60 |
| imported/sherlock/name-holmes-casei | 2802 | 9264.94 ± 6.0% | not timed | not timed | 3305.03 ± 0.1% | 37.34 ± 1.9% | not timed | not timed | 9337.70 ± 6.3% | | 0.99 | 2.80 | 248.14 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12935.18 ± 7.5% | not timed | not timed | 3938.95 ± 0.1% | 32.41 ± 0.2% | not timed | not timed | 12949.92 ± 1.4% | | 1.00 | 3.28 | 399.15 |
| imported/sherlock/name-whitespace | 1461 | 15069.12 ± 1.7% | not timed | not timed | 14476.03 ± 0.1% | 6624.55 ± 20.6% | not timed | not timed | 15431.96 ± 1.6% | | 0.98 | 1.04 | 2.27 |
| imported/sherlock/name-alt1 | 1142 | 11568.54 ± 0.2% | not timed | not timed | 16437.35 ± 0.9% | 4106.46 ± 20.8% | not timed | not timed | 11575.22 ± 2.6% | | 1.00 | 0.70 | 2.82 |
| imported/sherlock/name-alt2 | 3542 | 8931.75 ± 0.5% | not timed | not timed | 3818.78 ± 0.2% | 31.25 ± 0.1% | not timed | not timed | 8933.05 ± 0.5% | | 1.00 | 2.34 | 285.79 |
| imported/sherlock/name-alt3 | 4507 | 5529.96 ± 0.5% | not timed | not timed | 3625.50 ± 0.4% | 9.92 ± 0.1% | not timed | not timed | 5518.41 ± 0.5% | | 1.00 | 1.53 | 557.33 |
| imported/sherlock/name-alt3-casei | 4593 | 1511.03 ± 2.1% | not timed | not timed | 285.02 ± 0.1% | 6.43 ± 0.2% | not timed | not timed | 1521.50 ± 1.4% | | 0.99 | 5.30 | 235.13 |
| imported/sherlock/name-alt4 | 3686 | 6412.80 ± 0.3% | not timed | not timed | 3757.12 ± 0.1% | 31.13 ± 0.3% | not timed | not timed | 6416.87 ± 0.3% | | 1.00 | 1.71 | 205.98 |
| imported/sherlock/name-alt4-casei | 4254 | 2796.46 ± 2.3% | not timed | not timed | 2578.12 ± 0.2% | 19.74 ± 0.5% | not timed | not timed | 2807.61 ± 0.9% | | 1.00 | 1.08 | 141.66 |
| imported/sherlock/name-alt5 | 4028 | 6383.58 ± 0.3% | not timed | not timed | 3738.61 ± 0.1% | 21.81 ± 0.2% | not timed | not timed | 6391.48 ± 0.2% | | 1.00 | 1.71 | 292.75 |
| imported/sherlock/name-alt5-casei | 4104 | 3472.51 ± 1.9% | not timed | not timed | 2219.25 ± 0.1% | 14.29 ± 0.1% | not timed | not timed | 3480.07 ± 0.9% | | 1.00 | 1.56 | 243.03 |
| imported/sherlock/no-match-uncommon | 0 | 21716.51 ± 0.3% | not timed | not timed | 19661.67 ± 0.5% | 36694.22 ± 0.3% | not timed | not timed | 21730.07 ± 0.5% | | 1.00 | 1.10 | 0.59 |
| imported/sherlock/no-match-common | 0 | 21558.67 ± 0.6% | not timed | not timed | 19618.82 ± 0.5% | 1273.95 ± 0.9% | not timed | not timed | 21651.09 ± 0.6% | | 1.00 | 1.10 | 16.92 |
| imported/sherlock/no-match-really-common | 0 | 16061.38 ± 2.4% | not timed | not timed | 18744.99 ± 0.6% | 1282.44 ± 0.5% | not timed | not timed | 16182.05 ± 3.7% | | 0.99 | 0.86 | 12.52 |
| imported/sherlock/the-lower | 21654 | 2298.89 ± 1.1% | not timed | not timed | 2333.19 ± 0.5% | 240.32 ± 17.2% | not timed | not timed | 2314.72 ± 1.4% | | 0.99 | 0.99 | 9.57 |
| imported/sherlock/the-upper | 2223 | 12741.36 ± 1.5% | not timed | not timed | 13646.31 ± 0.9% | 2731.47 ± 3.4% | not timed | not timed | 12814.32 ± 0.8% | | 0.99 | 0.93 | 4.66 |
| imported/sherlock/the-casei | 23961 | 1996.44 ± 1.2% | not timed | not timed | 1315.03 ± 0.4% | 34.73 ± 34.3% | not timed | not timed | 1994.22 ± 0.9% | | 1.00 | 1.52 | 57.49 |
| imported/sherlock/everything-greedy | 581881 | 282.15 ± 0.1% | not timed | not timed | 164.90 ± 0.2% | 28.21 ± 31.8% | not timed | not timed | 281.28 ± 0.7% | | 1.00 | 1.71 | 10.00 |
| imported/sherlock/everything-greedy-nl | 594933 | 490.21 ± 0.2% | not timed | not timed | 211.59 ± 0.2% | 32.87 ± 0.1% | not timed | not timed | 489.31 ± 0.1% | | 1.00 | 2.32 | 14.91 |
| imported/sherlock/letters | 447175 | 61.71 ± 1.0% | not timed | not timed | 33.01 ± 0.1% | 6.61 ± 22.4% | not timed | not timed | 61.96 ± 0.6% | | 1.00 | 1.87 | 9.33 |
| imported/sherlock/letters-upper | 14180 | 447.18 ± 1.3% | not timed | not timed | 369.90 ± 0.1% | 29.31 ± 23.8% | not timed | not timed | 445.66 ± 0.2% | | 1.00 | 1.21 | 15.26 |
| imported/sherlock/letters-lower | 432995 | 62.50 ± 1.2% | not timed | not timed | 33.65 ± 0.1% | 5.32 ± 36.0% | not timed | not timed | 62.73 ± 1.1% | | 1.00 | 1.86 | 11.74 |
| imported/sherlock/words | 447639 | 112.71 ± 0.6% | not timed | not timed | 82.90 ± 0.2% | 13.39 ± 24.9% | not timed | not timed | 113.49 ± 1.8% | | 0.99 | 1.36 | 8.42 |
| imported/sherlock/before-holmes | 4073 | 10307.37 ± 0.8% | not timed | not timed | 8430.44 ± 0.2% | 23.74 ± 1.4% | not timed | not timed | 10306.18 ± 0.4% | | 1.00 | 1.22 | 434.11 |
| imported/sherlock/before-after-holmes | 2593 | 9871.34 ± 0.9% | not timed | not timed | 9499.98 ± 0.2% | 24.13 ± 0.7% | not timed | not timed | 9957.12 ± 0.7% | | 0.99 | 1.04 | 409.05 |
| imported/sherlock/holmes-cochar-watson | 150 | 5176.96 ± 0.4% | not timed | not timed | 3418.75 ± 0.1% | 30.87 ± 0.1% | not timed | not timed | 5063.78 ± 0.4% | | 1.02 | 1.51 | 167.72 |
| imported/sherlock/holmes-coword-watson | 14309 | 1149.14 ± 0.6% | not timed | not timed | 1120.07 ± 0.1% | 6.77 ± 0.3% | not timed | not timed | 1150.34 ± 0.6% | | 1.00 | 1.03 | 169.73 |
| imported/sherlock/quotes | 14437 | 1569.57 ± 0.2% | not timed | not timed | 1750.59 ± 0.3% | 35.02 ± 0.1% | not timed | not timed | 1570.54 ± 0.2% | | 1.00 | 0.90 | 44.82 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17428.47 ± 0.3% | not timed | not timed | 15961.07 ± 0.2% | 36.63 ± 3.2% | not timed | not timed | 17386.15 ± 0.4% | | 1.00 | 1.09 | 475.74 |
| imported/sherlock/word-ending-n | 35297 | 479.94 ± 0.2% | not timed | not timed | 409.10 ± 0.1% | 23.25 ± 21.0% | not timed | not timed | 479.04 ± 1.3% | | 1.00 | 1.17 | 20.64 |
| imported/sherlock/repeated-class-negation | 2130 | 14866.73 ± 0.7% | not timed | not timed | 10924.21 ± 1.7% | 11.55 ± 0.2% | not timed | not timed | 14858.73 ± 0.6% | | 1.00 | 1.36 | 1287.21 |
| imported/sherlock/ing-suffix | 20547 | 557.52 ± 0.3% | not timed | not timed | 515.45 ± 0.1% | 28.81 ± 0.1% | not timed | not timed | 557.79 ± 0.4% | | 1.00 | 1.08 | 19.35 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1659.87 ± 0.4% | not timed | not timed | 2101.55 ± 0.4% | 20.47 ± 0.3% | not timed | not timed | 1662.50 ± 0.5% | | 1.00 | 0.79 | 81.09 |
| opt/accelerate/whole-line | 239963 | 457.18 ± 0.1% | not timed | not timed | 370.53 ± 0.1% | 91.86 ± 17.4% | not timed | not timed | 456.68 ± 0.4% | | 1.00 | 1.23 | 4.98 |
| opt/accelerate/non-dna | 16745 | 432.53 ± 1.1% | not timed | not timed | 398.82 ± 0.1% | 29.21 ± 65.5% | not timed | not timed | 431.15 ± 1.7% | | 1.00 | 1.08 | 14.81 |
| opt/backtrack/words-english | 40536 | 140.99 ± 2.8% | not timed | not timed | 93.47 ± 0.1% | 18.48 ± 6.6% | not timed | not timed | 141.48 ± 1.3% | | 1.00 | 1.51 | 7.63 |
| opt/fixed-length/too-small-ascii | 0 | 315.28 ± 0.3% | not timed | not timed | 674.87 ± 2.6% | 80.36 ± 0.3% | not timed | not timed | 316.32 ± 0.5% | | 1.00 | 0.47 | 3.92 |
| opt/fixed-length/too-big-ascii | 0 | 3425.25 ± 0.1% | not timed | not timed | 5781.04 ± 0.3% | 120.73 ± 0.2% | not timed | not timed | 3421.15 ± 0.1% | | 1.00 | 0.59 | 28.37 |
| opt/fixed-length/go33484-1 | 0 | 657144.57 ± 0.1% | not timed | not timed | 1107053.85 ± 0.5% | 61307.34 ± 0.8% | not timed | not timed | 658841.86 ± 0.1% | | 1.00 | 0.59 | 10.72 |
| opt/fixed-length/go33484-2 | 0 | 657159.15 ± 0.1% | not timed | not timed | 1114889.26 ± 0.7% | 32389.33 ± 2.0% | not timed | not timed | 658432.58 ± 0.1% | | 1.00 | 0.59 | 20.29 |
| opt/fixed-length/go33484-3 | 0 | 65683.06 ± 0.7% | not timed | not timed | 110747.09 ± 0.5% | 763.05 ± 0.1% | not timed | not timed | 65812.09 ± 0.6% | | 1.00 | 0.59 | 86.08 |
| opt/literal-alt/one-pattern | 1 | 548.29 ± 2.1% | not timed | not timed | 541.39 ± 0.1% | 0.40 ± 0.3% | not timed | not timed | 548.07 ± 1.7% | | 1.00 | 1.01 | 1380.92 |
| opt/onepass/fn-predicate | 916 | 368.66 ± 1.2% | not timed | not timed | 336.47 ± 0.2% | 202.21 ± 12.7% | not timed | not timed | 370.27 ± 0.8% | | 1.00 | 1.10 | 1.82 |
| opt/onepass/first-three-words-english | 35128 | 180.46 ± 3.3% | not timed | not timed | 200.03 ± 0.2% | 83.02 ± 14.5% | not timed | not timed | 179.60 ± 1.9% | | 1.00 | 0.90 | 2.17 |
| opt/prefilter/literal-english | 1 | 20759.18 ± 0.4% | not timed | not timed | 20006.60 ± 0.5% | 17554.57 ± 0.3% | not timed | not timed | 20739.87 ± 0.3% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14565.36 ± 0.6% | not timed | not timed | 4305.88 ± 0.1% | 32.48 ± 0.3% | not timed | not timed | 14578.94 ± 0.4% | | 1.00 | 3.38 | 448.50 |
| opt/prefilter/literal-russian | 1 | 21403.43 ± 0.7% | not timed | not timed | 19913.59 ± 0.8% | 3312.34 ± 0.2% | not timed | not timed | 21412.38 ± 0.5% | | 1.00 | 1.07 | 6.46 |
| opt/prefilter/literal-casei-russian | 1 | 8483.11 ± 0.2% | not timed | not timed | 3882.27 ± 0.1% | 31.66 ± 0.3% | not timed | not timed | 8496.34 ± 0.3% | | 1.00 | 2.19 | 267.95 |
| opt/prefilter/rust-functions | 948 | 6700.72 ± 2.9% | not timed | not timed | 8887.32 ± 1.6% | 1854.86 ± 30.3% | not timed | not timed | 6723.29 ± 1.2% | | 1.00 | 0.75 | 3.61 |
| opt/reverse-anchored/word-end | 1 | 29514109.20 ± 0.1% | not timed | not timed | 21740995.46 ± 0.2% | 50.22 ± 0.1% | not timed | not timed | 29549931.28 ± 0.4% | | 1.00 | 1.36 | 587733.62 |
| opt/reverse-inner/holmes | 2593 | 9867.41 ± 1.0% | not timed | not timed | 9492.81 ± 0.7% | 23.79 ± 0.9% | not timed | not timed | 9985.25 ± 0.7% | | 0.99 | 1.04 | 414.79 |
| opt/reverse-inner/email | 47 | 36273.02 ± 1.9% | not timed | not timed | 44699.98 ± 0.5% | 32.34 ± 0.2% | not timed | not timed | 36702.11 ± 2.1% | | 0.99 | 0.81 | 1121.70 |
| opt/reverse-inner/factored-prefix | 3542 | 591.88 ± 0.1% | not timed | not timed | 593.90 ± 0.1% | 12.32 ± 0.9% | not timed | not timed | 590.42 ± 0.5% | | 1.00 | 1.00 | 48.03 |
| opt/reverse-inner/no-quadratic-backward | 0 | 20971.22 ± 0.1% | not timed | not timed | 613.95 ± 0.1% | 74.69 ± 0.1% | not timed | not timed | 21143.06 ± 0.1% | | 0.99 | 34.16 | 280.77 |
| opt/reverse-inner/no-quadratic-forward | 0 | 730.18 ± 1.4% | not timed | not timed | 287.90 ± 0.1% | 24.68 ± 0.1% | not timed | not timed | 737.65 ± 1.8% | | 0.99 | 2.54 | 29.59 |
| opt/reverse-suffix/holmes | 4073 | 10295.81 ± 0.5% | not timed | not timed | 8444.18 ± 0.4% | 24.03 ± 0.5% | not timed | not timed | 10307.44 ± 0.3% | | 1.00 | 1.22 | 428.53 |
| opt/reverse-suffix/no-quadratic | 0 | 21054.11 ± 0.2% | not timed | not timed | 613.93 ± 0.6% | 74.74 ± 0.2% | not timed | not timed | 21130.35 ± 0.1% | | 1.00 | 34.29 | 281.71 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.91 ± 1.5% | not timed | not timed | 131.92 ± 0.3% | 13.09 ± 15.6% | not timed | not timed | 120.46 ± 3.2% | | 1.00 | 0.92 | 9.23 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.30 ± 2.7% | not timed | not timed | 132.25 ± 0.2% | 13.22 ± 14.2% | not timed | not timed | 120.26 ± 3.1% | | 1.00 | 0.91 | 9.10 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.2% | not timed | not timed | 0.55 ± 0.3% | 112.49 ± 0.3% | not timed | not timed | 0.28 ± 0.5% | | 0.99 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 322.32 ± 0.2% | not timed | not timed | 293.87 ± 0.4% | 103.56 ± 0.3% | not timed | not timed | 322.48 ± 0.3% | | 1.00 | 1.10 | 3.11 |
| reported/i13-subset-regex/original-ascii | 4094 | 11117.42 ± 0.6% | not timed | not timed | 4450.29 ± 0.4% | 11.49 ± 1.5% | not timed | not timed | 11096.33 ± 2.8% | | 1.00 | 2.50 | 967.43 |
| reported/i13-subset-regex/original-unicode | 4094 | 10658.19 ± 2.5% | not timed | not timed | 251.56 ± 3.2% | 11.52 ± 0.1% | not timed | not timed | 11208.19 ± 1.3% | | 0.95 | 42.37 | 925.47 |
| reported/i13-subset-regex/big-ascii | 1955 | 10668.97 ± 1.1% | not timed | not timed | 68.08 ± 3.6% | 9.85 ± 0.1% | not timed | not timed | 10748.03 ± 0.8% | | 0.99 | 156.71 | 1083.50 |
| reported/i13-subset-regex/big-unicode | 1955 | 10571.92 ± 1.2% | not timed | not timed | 12.21 ± 55.0% | 9.86 ± 0.2% | not timed | not timed | 10727.67 ± 0.9% | | 0.99 | 865.79 | 1072.21 |
| reported/i13-subset-regex/huge-ascii | 55 | 10091.51 ± 1.4% | not timed | not timed | 11.05 ± 0.1% | 8.77 ± 0.1% | not timed | not timed | 10073.48 ± 2.9% | | 1.00 | 913.10 | 1150.57 |
| reported/i13-subset-regex/huge-unicode | 55 | 9907.66 ± 2.8% | not timed | not timed | 10.94 ± 0.4% | 8.75 ± 0.1% | not timed | not timed | 9858.19 ± 3.0% | | 1.01 | 905.70 | 1131.67 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.52 ± 0.1% | not timed | not timed | 10.96 ± 0.0% | 8.76 ± 1.1% | not timed | not timed | 3.52 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.96 ± 0.2% | not timed | not timed | 10.99 ± 0.3% | 8.73 ± 0.2% | not timed | not timed | 4.96 ± 0.1% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 483.18 ± 0.3% | not timed | not timed | 104.35 ± 0.2% | 6.63 ± 0.3% | not timed | not timed | 484.45 ± 0.3% | | 1.00 | 4.63 | 72.89 |
| reported/i787-keywords/opt-ascii | 5674 | 483.94 ± 0.6% | not timed | not timed | 273.93 ± 0.1% | 10.23 ± 0.1% | not timed | not timed | 483.24 ± 0.3% | | 1.00 | 1.77 | 47.32 |
| slow/quadratic-regex-1x | 100 | 7.07 ± 0.3% | not timed | not timed | 4.93 ± 0.2% | 0.05 ± 0.4% | not timed | not timed | 7.10 ± 0.3% | | 0.99 | 1.43 | 143.61 |
| slow/quadratic-regex-2x | 199 | 3.40 ± 0.2% | not timed | not timed | 2.75 ± 0.3% | 0.01 ± 0.2% | not timed | not timed | 3.42 ± 0.1% | | 1.00 | 1.24 | 270.32 |
| slow/quadratic-haystack-1x | 100 | 21.93 ± 6.4% | not timed | not timed | 9.99 ± 0.5% | 1.01 ± 12.6% | not timed | not timed | 21.94 ± 2.1% | | 1.00 | 2.19 | 21.66 |
| slow/quadratic-haystack-2x | 200 | 19.70 ± 4.0% | not timed | not timed | 5.54 ± 0.3% | 0.54 ± 9.6% | not timed | not timed | 19.72 ± 1.1% | | 1.00 | 3.56 | 36.24 |
| unicode/codepoints/any-one | 1112064 | 280.46 ± 0.2% | not timed | not timed | 173.10 ± 0.3% | 18.45 ± 3.5% | not timed | not timed | 279.87 ± 0.2% | | 1.00 | 1.62 | 15.20 |
| unicode/codepoints/any-all | 4382592 | 282.46 ± 0.9% | not timed | not timed | 246.97 ± 0.2% | 112.64 ± 0.2% | not timed | not timed | 281.43 ± 1.1% | | 1.00 | 1.14 | 2.51 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.75 ± 0.7% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 601.73 ± 0.7% | not timed | not timed | 615.19 ± 0.4% | 135.07 ± 0.3% | not timed | not timed | 600.49 ± 0.8% | | 1.00 | 0.98 | 4.45 |
| unicode/overlapping-words/ascii | 6156 | 32.25 ± 0.2% | not timed | not timed | 38.55 ± 0.2% | 3.93 ± 1.0% | not timed | not timed | 32.24 ± 0.4% | | 1.00 | 0.84 | 8.20 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.1% | not timed | not timed | 4.11 ± 0.3% | 2.33 ± 0.2% | not timed | not timed | 1.43 ± 0.1% | | 1.01 | 0.35 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.27 ± 9.1% | not timed | not timed | 3.84 ± 0.3% | 6.20 ± 9.8% | not timed | not timed | 1.27 ± 0.2% | | 1.00 | 0.33 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 128.73 ± 7.1% | not timed | not timed | 82.78 ± 0.2% | 11.63 ± 20.4% | not timed | not timed | 129.61 ± 0.8% | | 0.99 | 1.56 | 11.07 |
| unicode/word/boundary-long-english | 3466 | 604.93 ± 0.3% | not timed | not timed | 603.93 ± 0.2% | 32.58 ± 0.4% | not timed | not timed | 604.50 ± 0.7% | | 1.00 | 1.00 | 18.57 |
| unicode/word/around-holmes-english | 27 | 19866.41 ± 0.3% | not timed | not timed | 19750.20 ± 0.2% | 22.24 ± 0.4% | not timed | not timed | 19894.21 ± 0.4% | | 1.00 | 1.01 | 893.40 |
| wild/bibleref/long | 874 | 564.35 ± 0.2% | not timed | not timed | 583.45 ± 0.2% | 6.51 ± 0.1% | not timed | not timed | 566.24 ± 0.2% | | 1.00 | 0.97 | 86.65 |
| wild/bibleref/short | 30 | 25.08 ± 3.1% | not timed | not timed | 30.67 ± 0.4% | 14.19 ± 12.9% | not timed | not timed | 24.88 ± 3.8% | | 1.01 | 0.82 | 1.77 |
| wild/bibleref/line | 874 | 397.66 ± 1.6% | not timed | not timed | 212.28 ± 0.6% | 9.17 ± 8.5% | not timed | not timed | 399.06 ± 0.3% | | 1.00 | 1.87 | 43.35 |
| wild/caddy/caddy | 6 | 416.12 ± 7.6% | not timed | not timed | 246.71 ± 0.1% | 67.52 ± 13.1% | not timed | not timed | 421.54 ± 1.5% | | 0.99 | 1.69 | 6.16 |
| wild/dot-star-capture/rust-src-tools | 6 | 1066.48 ± 0.4% | not timed | not timed | 343.40 ± 0.5% | 13.50 ± 0.2% | not timed | not timed | 1060.73 ± 0.4% | | 1.01 | 3.11 | 79.00 |
| wild/ruff/noqa | 84 | 438.91 ± 0.1% | not timed | not timed | 463.63 ± 0.2% | 19.54 ± 2.1% | not timed | not timed | 438.51 ± 0.1% | | 1.00 | 0.95 | 22.47 |
| wild/ruff/unnecessary-coding-comment | 16 | 959.88 ± 0.3% | not timed | not timed | 700.82 ± 0.4% | 136.68 ± 11.0% | not timed | not timed | 959.54 ± 0.5% | | 1.00 | 1.37 | 7.02 |
| wild/ruff/string-quote-prefix | 2972 | 1369.35 ± 0.8% | not timed | not timed | 435.93 ± 0.2% | 379.20 ± 30.6% | not timed | not timed | 1369.89 ± 0.7% | | 1.00 | 3.14 | 3.61 |
| wild/ruff/space-around-operator | 1224378 | 222.32 ± 1.9% | not timed | not timed | 186.60 ± 0.1% | 18.26 ± 1.7% | not timed | not timed | 223.74 ± 9.5% | | 0.99 | 1.19 | 12.18 |
| wild/ruff/shebang | 282 | 970.85 ± 0.4% | not timed | not timed | 328.57 ± 0.2% | 120.32 ± 9.7% | not timed | not timed | 978.25 ± 0.4% | | 0.99 | 2.95 | 8.07 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13807.27 ± 0.3% | not timed | not timed | 13856.03 ± 0.4% | 6918.36 ± 1.1% | not timed | not timed | 13820.25 ± 0.3% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12842.08 ± 0.7% | not timed | not timed | 13526.50 ± 0.5% | 6401.58 ± 0.8% | not timed | not timed | 12816.06 ± 0.8% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13182.87 ± 0.6% | not timed | not timed | 13718.37 ± 0.2% | 6634.31 ± 37.4% | not timed | not timed | 13184.18 ± 5.9% | | 1.00 | 0.96 | 1.99 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9544.91 ± 0.2% | not timed | not timed | 13561.58 ± 0.1% | 6768.61 ± 1.0% | not timed | not timed | 9557.11 ± 0.3% | | 1.00 | 0.70 | 1.41 |
| wild/url/search | 234965 | 120.85 ± 13.8% | not timed | not timed | 66.03 ± 0.6% | 2.24 ± 0.6% | not timed | not timed | 121.34 ± 13.8% | | 1.00 | 1.83 | 54.06 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 65.8% | not timed | not timed | 0.01 ± 1.1% | 0.01 ± 13.4% | not timed | not timed | 0.03 ± 1.5% | | 0.98 | 3.07 | 3.92 |
| dictionary/compile/english-15 | 1 | 0.35 ± 4.6% | not timed | not timed | 0.07 ± 0.5% | 0.11 ± 12.2% | not timed | not timed | 0.35 ± 17.7% | | 0.99 | 4.99 | 3.30 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 3.1% | not timed | not timed | 0.02 ± 0.6% | 36.08 ± 8.0% | not timed | not timed | 0.25 ± 2.5% | | 1.00 | 13.06 | 0.0070 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.95 ± 1.8% | not timed | not timed | 11.52 ± 0.4% | 62.40 ± 23.6% | not timed | not timed | 47.96 ± 8.4% | | 1.00 | 4.16 | 0.77 |
| reported/i787-keywords/compile | 1 | 34.94 ± 1.6% | not timed | not timed | 2.11 ± 0.9% | 17.15 ± 27.9% | not timed | not timed | 35.00 ± 15.9% | | 1.00 | 16.52 | 2.04 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 369.96 ± 3.2% | not timed | not timed | 117.59 ± 0.3% | 591.95 ± 25.6% | not timed | not timed | 369.02 ± 2.7% | | 1.00 | 3.15 | 0.62 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 48.35 ± 1.8% | not timed | not timed | 4.10 ± 0.5% | 43.66 ± 14.1% | not timed | not timed | 48.84 ± 3.3% | | 0.99 | 11.81 | 1.11 |
| unicode/compile/one-letter | 53 | 6.80 ± 4.0% | not timed | not timed | 4.51 ± 0.4% | 66.50 ± 7.8% | not timed | not timed | 6.83 ± 8.7% | | 1.00 | 1.51 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.09 ± 3.0% | not timed | not timed | 0.10 ± 1.0% | 67.66 ± 7.3% | not timed | not timed | 1.11 ± 14.8% | | 0.99 | 10.87 | 0.0161 |
| unicode/compile/fifty-letters-ascii | 1 | 222.65 ± 8.1% | not timed | not timed | 52.48 ± 0.1% | 193.87 ± 14.9% | not timed | not timed | 225.00 ± 3.0% | | 0.99 | 4.24 | 1.15 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 378.62 ± 7.9% | not timed | not timed | 46.53 ± 0.2% | 678.17 ± 22.4% | not timed | not timed | 387.00 ± 1.0% | | 0.98 | 8.14 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 608.40 ± 13.4% | not timed | not timed | 143.17 ± 0.4% | 687.20 ± 16.0% | not timed | not timed | 618.56 ± 4.0% | | 0.98 | 4.25 | 0.89 |
| unicode/compile/negated-class-matches-codepoint | 1 | 318.54 ± 4.9% | not timed | not timed | 50.84 ± 0.7% | 1255.65 ± 5.5% | not timed | not timed | 330.15 ± 4.7% | | 0.96 | 6.27 | 0.25 |
| wild/bibleref/compile | 3 | 5.87 ± 3.4% | not timed | not timed | 1.92 ± 1.0% | 32.33 ± 5.6% | not timed | not timed | 5.98 ± 4.0% | | 0.98 | 3.05 | 0.18 |
| wild/url/compile | 1 | 0.57 ± 16.7% | not timed | not timed | 0.14 ± 1.2% | 0.45 ± 9.4% | not timed | not timed | 0.65 ± 22.3% | | 0.87 | 3.94 | 1.28 |

