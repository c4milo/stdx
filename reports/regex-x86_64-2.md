# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
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
| literal: a word | 217 | 44752.32 ± 0.1% | 11982.44 ± 0.2% | 29.83 ± 1.0% | 38784.72 ± 1.7% | 12267.54 ± 4.5% | 12.76 ± 0.5% | 104.30 ± 0.4% | 45036.72 ± 4.9% | 3.73 | 0.99 | 1.15 | 3.65 |
| literal: a word that is not there | 0 | 63527.92 ± 0.5% | 11144.20 ± 0.3% | 29.98 ± 0.5% | 45597.48 ± 0.2% | 42540.48 ± 1.7% | 12.61 ± 0.7% | 96.96 ± 0.8% | 63576.39 ± 0.1% | 5.70 | 1.00 | 1.39 | 1.49 |
| literal: one of four words | 661 | 15657.84 ± 0.3% | 1670.39 ± 0.5% | 16.44 ± 0.4% | 11163.36 ± 0.2% | 24.98 ± 9.8% | 4.48 ± 0.3% | 8.26 ± 0.7% | 15673.02 ± 0.4% | 9.37 | 1.00 | 1.40 | 626.86 |
| literal: a word in any case | 217 | 39928.73 ± 0.3% | 1792.87 ± 1.1% | 22.50 ± 0.5% | 11356.57 ± 10.5% | 47.02 ± 17.1% | refused | differs | 39956.79 ± 0.4% | 22.27 | 1.00 | 3.52 | 849.24 |
| literal: an href attribute | 33 | 40453.26 ± 0.3% | 616.28 ± 0.3% | 25.88 ± 1.8% | 34690.94 ± 0.4% | 3042.94 ± 2.4% | 9.55 ± 0.5% | 91.38 ± 3.6% | 40428.33 ± 0.3% | 65.64 | 1.00 | 1.17 | 13.29 |
| literal: a word, second text | 123 | 49090.24 ± 4.3% | 6321.83 ± 0.8% | 29.65 ± 1.8% | 39595.39 ± 0.6% | 11121.82 ± 10.1% | 14.46 ± 0.3% | 87.54 ± 1.8% | 49025.90 ± 4.7% | 7.77 | 1.00 | 1.24 | 4.41 |
| class: two capitalized words | 1331 | 1151.18 ± 0.3% | 612.76 ± 1.1% | 27.91 ± 5.7% | 577.22 ± 0.5% | 44.47 ± 13.7% | 10.94 ± 0.3% | 79.62 ± 0.3% | 1150.94 ± 0.1% | 1.88 | 1.00 | 1.99 | 25.88 |
| class: a word that ends in ing | 3399 | 585.79 ± 1.6% | 585.12 ± 0.3% | 19.96 ± 12.7% | 540.47 ± 0.1% | 32.77 ± 9.6% | 6.19 ± 0.1% | 20.66 ± 9.8% | 584.36 ± 0.3% | 1.00 | 1.00 | 1.08 | 17.88 |
| class: a word in capitals | 2332 | 1579.41 ± 0.3% | 618.38 ± 0.1% | 29.25 ± 0.2% | 565.64 ± 0.5% | 47.96 ± 20.3% | 12.38 ± 0.2% | 101.07 ± 2.2% | 1577.38 ± 1.2% | 2.55 | 1.00 | 2.79 | 32.93 |
| class: a number | 8288 | 3200.87 ± 7.2% | 853.32 ± 0.2% | 29.63 ± 1.4% | 1799.62 ± 0.6% | 48.90 ± 12.4% | 0.38 ± 0.7% | 71.87 ± 0.4% | 3229.16 ± 1.2% | 3.75 | 0.99 | 1.78 | 65.46 |
| class: two capitalized words, second text | 5359 | 515.02 ± 3.1% | 530.00 ± 0.7% | 25.41 ± 3.3% | 478.49 ± 0.1% | 38.79 ± 9.3% | 12.72 ± 0.1% | 73.16 ± 2.6% | 522.63 ± 2.5% | 0.97 | 0.99 | 1.08 | 13.28 |
| other: a word between two words | 6104 | 856.32 ± 1.9% | 606.50 ± 0.4% | 25.22 ± 0.6% | 815.79 ± 0.5% | 128.92 ± 14.8% | 8.47 ± 0.1% | 81.29 ± 0.4% | 854.83 ± 0.5% | 1.41 | 1.00 | 1.05 | 6.64 |
| other: a number before a unit, second text | 1481 | 10481.45 ± 0.4% | 1185.32 ± 0.4% | 27.85 ± 1.1% | 8235.73 ± 0.2% | 44.85 ± 1.1% | 13.30 ± 0.3% | 77.03 ± 0.6% | 10487.77 ± 0.7% | 8.84 | 1.00 | 1.27 | 233.69 |
| other: a heading's start tag | 110 | 24654.62 ± 0.1% | 747.87 ± 0.1% | 29.66 ± 0.5% | 2580.17 ± 0.6% | 2013.79 ± 12.0% | 11.71 ± 0.2% | 107.09 ± 2.6% | 24674.96 ± 0.5% | 32.97 | 1.00 | 9.56 | 12.24 |
| other: a whole word | 217 | 32286.16 ± 0.2% | 608.72 ± 0.2% | 30.59 ± 0.3% | 28162.45 ± 0.3% | 53.68 ± 0.9% | 11.00 ± 0.2% | 62.56 ± 1.5% | 32297.03 ± 0.3% | 53.04 | 1.00 | 1.15 | 601.45 |
| other: a line's first word, second text | 3716 | 2429.13 ± 0.5% | 598.47 ± 0.2% | 31.45 ± 0.7% | 2316.50 ± 0.9% | 70.17 ± 5.5% | refused | refused | 2444.99 ± 3.2% | 4.06 | 0.99 | 1.05 | 34.62 |
| other: fourteen octets before an x | 87 | 34989.18 ± 0.4% | 250.08 ± 2.6% | 7.65 ± 0.1% | 3468.26 ± 0.4% | 11.57 ± 0.9% | differs | 19.95 ± 1.5% | 35091.95 ± 0.3% | 139.91 | 1.00 | 10.09 | 3022.85 |
| other: a Greek word | 21815 | 573.07 ± 0.4% | 439.53 ± 1.5% | 33.19 ± 0.4% | 305.54 ± 0.3% | 57.04 ± 14.4% | differs | refused | 574.75 ± 0.4% | 1.30 | 1.00 | 1.88 | 10.05 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 31.46 ± 1.4% | 31.33 ± 1.8% | 1.02 ± 0.5% | 19.78 ± 0.2% | 2.68 ± 0.1% | differs | 4.27 ± 2.0% | 31.39 ± 2.3% | 1.00 | 1.00 | 1.59 | 11.73 |
| a UUID | 32895 | 27.76 ± 14.9% | 27.76 ± 0.7% | 0.72 ± 0.3% | 15.10 ± 0.9% | 3.07 ± 10.7% | 0.52 ± 2.2% | 3.90 ± 9.4% | 27.76 ± 0.5% | 1.00 | 1.00 | 1.84 | 9.04 |
| an IPv4 address | 33176 | 40.09 ± 0.4% | 40.32 ± 2.7% | 2.22 ± 1.6% | 27.58 ± 0.3% | 6.94 ± 1.4% | differs | 4.19 ± 1.1% | 39.86 ± 1.9% | 0.99 | 1.01 | 1.45 | 5.78 |
| a date and time | 32954 | 38.02 ± 0.2% | 38.01 ± 0.4% | 1.32 ± 1.0% | 21.61 ± 2.1% | 8.03 ± 22.5% | 0.90 ± 1.6% | 7.70 ± 8.7% | 38.02 ± 0.7% | 1.00 | 1.00 | 1.76 | 4.74 |
| a field path | 32606 | 33.73 ± 2.6% | 33.60 ± 2.1% | 1.13 ± 15.5% | 22.88 ± 4.8% | 3.47 ± 16.8% | differs | 2.98 ± 23.6% | 33.53 ± 0.3% | 1.00 | 1.01 | 1.47 | 9.73 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.89 ± 10.5% | 10.91 ± 4.2% | 10.80 ± 2.9% | 13.36 ± 3.0% | 5.83 ± 2.3% | 0.73 ± 0.7% | none | 10.85 ± 6.0% | 1.00 | 1.00 | 0.82 | 1.87 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 231.29 ± 0.1% | 231.37 ± 9.3% | 272.07 ± 0.3% | 102.21 ± 1.0% | 244.85 ± 0.7% | 699.21 ± 1.6% | 4912.43 ± 0.6% | 231.22 ± 0.6% | 1.00 | 1.00 | 2.26 | 0.94 |
| a UUID | 62 | 152.92 ± 0.3% | 153.37 ± 0.9% | 171.43 ± 0.6% | 57.89 ± 1.6% | 117.62 ± 30.2% | 250.70 ± 2.5% | 5399.78 ± 2.0% | 153.14 ± 0.3% | 1.00 | 1.00 | 2.64 | 1.30 |
| an IPv4 address | 29 | 473.65 ± 10.5% | 477.09 ± 0.3% | 683.50 ± 0.1% | 87.42 ± 0.8% | 150.47 ± 1.3% | 398.67 ± 4.1% | 9011.86 ± 0.5% | 476.28 ± 3.6% | 0.99 | 0.99 | 5.42 | 3.15 |
| a date and time | 56 | 347.96 ± 14.5% | 348.29 ± 7.9% | 444.12 ± 1.0% | 86.43 ± 0.4% | 161.92 ± 2.0% | 477.48 ± 1.4% | 5554.92 ± 2.2% | 348.02 ± 1.5% | 1.00 | 1.00 | 4.03 | 2.15 |
| a field path | 39 | 224.00 ± 2.3% | 224.37 ± 0.2% | 262.13 ± 0.2% | 95.82 ± 1.5% | 228.70 ± 2.1% | 750.22 ± 3.5% | 5945.80 ± 0.5% | 224.40 ± 0.5% | 1.00 | 1.00 | 2.34 | 0.98 |
| literal: a word | 7 | 700.67 ± 0.4% | 750.38 ± 0.6% | 1388.42 ± 0.3% | 621.85 ± 3.8% | 746.17 ± 21.7% | 1580.44 ± 2.5% | 34658.19 ± 0.8% | 700.94 ± 5.4% | 0.93 | 1.00 | 1.13 | 0.94 |
| literal: a word that is not there | 8 | 675.57 ± 0.8% | 727.19 ± 0.1% | 1300.94 ± 1.6% | 576.64 ± 0.8% | 750.85 ± 35.0% | 1483.07 ± 0.5% | 33909.42 ± 0.6% | 675.96 ± 0.7% | 0.93 | 1.00 | 1.17 | 0.90 |
| literal: one of four words | 26 | 266.68 ± 0.4% | 442.18 ± 1.8% | 610.08 ± 2.7% | 53.51 ± 0.6% | 294.32 ± 2.6% | 587.27 ± 1.4% | 18364.40 ± 0.4% | 267.07 ± 0.3% | 0.60 | 1.00 | 4.98 | 0.91 |
| literal: a word in any case | 11 | 487.35 ± 1.2% | 516.82 ± 0.7% | 761.85 ± 0.6% | 18.91 ± 0.7% | 818.68 ± 5.2% | refused | 24793.83 ± 2.0% | 486.07 ± 1.0% | 0.94 | 1.00 | 25.77 | 0.60 |
| literal: an href attribute | 12 | 380.13 ± 0.2% | 394.90 ± 0.2% | 528.62 ± 1.2% | 50.42 ± 0.8% | 573.42 ± 19.2% | 1254.84 ± 5.3% | 24640.52 ± 1.9% | 380.29 ± 0.2% | 0.96 | 1.00 | 7.54 | 0.66 |
| literal: a word, second text | 10 | 630.64 ± 0.2% | 684.48 ± 1.0% | 1169.83 ± 0.3% | 518.70 ± 1.9% | 655.08 ± 4.1% | 1326.17 ± 3.6% | 32124.83 ± 0.5% | 629.89 ± 1.1% | 0.92 | 1.00 | 1.22 | 0.96 |
| class: two capitalized words | 23 | 491.77 ± 2.7% | 534.03 ± 7.0% | 790.80 ± 0.5% | 121.36 ± 0.7% | 596.80 ± 2.2% | 1193.51 ± 0.3% | 7949.47 ± 0.3% | 492.72 ± 0.4% | 0.92 | 1.00 | 4.05 | 0.82 |
| class: a word that ends in ing | 9 | 599.86 ± 0.4% | 686.74 ± 0.3% | 1234.27 ± 0.2% | 149.04 ± 1.6% | 857.68 ± 1.5% | 1780.70 ± 1.8% | 19312.00 ± 0.6% | 599.32 ± 0.3% | 0.87 | 1.00 | 4.02 | 0.70 |
| class: a word in capitals | 16 | 536.29 ± 1.0% | 585.51 ± 0.4% | 971.66 ± 0.3% | 154.04 ± 4.0% | 876.52 ± 14.2% | 1683.35 ± 0.7% | 10593.12 ± 0.2% | 536.46 ± 0.3% | 0.92 | 1.00 | 3.48 | 0.61 |
| class: a number | 6 | 669.09 ± 0.7% | 745.48 ± 0.1% | 1452.80 ± 0.5% | 46.91 ± 0.3% | 1625.74 ± 6.6% | 2973.84 ± 24.1% | 25841.45 ± 0.5% | 668.82 ± 0.3% | 0.90 | 1.00 | 14.26 | 0.41 |
| class: two capitalized words, second text | 23 | 491.94 ± 0.3% | 533.42 ± 0.2% | 790.35 ± 1.4% | 121.49 ± 5.3% | 602.51 ± 2.4% | 1223.48 ± 0.5% | 7945.46 ± 0.3% | 491.74 ± 0.4% | 0.92 | 1.00 | 4.05 | 0.82 |
| other: a word between two words | 13 | 606.07 ± 0.6% | 629.17 ± 0.3% | 1017.54 ± 1.1% | 159.35 ± 1.5% | 583.89 ± 3.0% | 1344.54 ± 0.5% | 17890.03 ± 1.2% | 605.53 ± 0.4% | 0.96 | 1.00 | 3.80 | 1.04 |
| other: a number before a unit, second text | 15 | 414.55 ± 4.3% | 466.00 ± 12.9% | 657.23 ± 0.4% | 43.75 ± 1.2% | 732.35 ± 1.4% | 1454.87 ± 2.5% | 17678.35 ± 17.5% | 414.96 ± 0.4% | 0.89 | 1.00 | 9.47 | 0.57 |
| other: a heading's start tag | 13 | 388.41 ± 1.5% | 396.53 ± 0.3% | 528.66 ± 0.8% | 48.28 ± 0.4% | 708.99 ± 8.8% | 1382.13 ± 10.3% | 20117.87 ± 0.9% | 388.21 ± 0.6% | 0.98 | 1.00 | 8.05 | 0.55 |
| other: a whole word | 11 | 626.27 ± 0.6% | 663.25 ± 0.2% | 1114.89 ± 0.3% | 140.99 ± 0.4% | 673.53 ± 25.1% | 1327.01 ± 8.7% | 31724.38 ± 0.6% | 627.30 ± 2.8% | 0.94 | 1.00 | 4.44 | 0.93 |
| other: a line's first word, second text | 17 | 566.85 ± 9.5% | 605.03 ± 3.0% | 1000.69 ± 0.5% | 146.05 ± 0.5% | 804.94 ± 13.9% | refused | refused | 568.87 ± 0.8% | 0.94 | 1.00 | 3.88 | 0.70 |
| other: fourteen octets before an x | 16 | 110.86 ± 0.4% | 166.44 ± 3.2% | 198.79 ± 0.7% | 18.09 ± 11.8% | 515.04 ± 18.9% | 566.70 ± 0.6% | 15678.02 ± 0.5% | 110.85 ± 8.3% | 0.67 | 1.00 | 6.13 | 0.22 |
| other: a Greek word | 8 | 429.67 ± 0.3% | 613.20 ± 0.3% | 1026.00 ± 0.5% | 62.53 ± 0.4% | 1607.42 ± 3.4% | 2761.64 ± 0.5% | refused | 429.75 ± 7.7% | 0.70 | 1.00 | 6.87 | 0.27 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 34043.33 ± 14.0% | not timed | not timed | 33548.15 ± 2.1% | 2832.32 ± 3.8% | not timed | not timed | 34183.88 ± 0.4% | | 1.00 | 1.01 | 12.02 |
| 01-literal/sherlock-casei-en | 522 | 27715.78 ± 8.4% | not timed | not timed | 9035.66 ± 0.7% | 33.99 ± 7.4% | not timed | not timed | 27728.16 ± 0.3% | | 1.00 | 3.07 | 815.43 |
| 01-literal/sherlock-ru | 724 | 35667.02 ± 17.0% | not timed | not timed | 33993.82 ± 27.9% | 1302.65 ± 3.5% | not timed | not timed | 35656.15 ± 12.6% | | 1.00 | 1.05 | 27.38 |
| 01-literal/sherlock-casei-ru | 746 | 12479.83 ± 0.5% | not timed | not timed | 7854.15 ± 0.7% | 37.11 ± 9.2% | not timed | not timed | 12430.54 ± 1.9% | | 1.00 | 1.59 | 336.27 |
| 01-literal/sherlock-zh | 30 | 59132.94 ± 0.6% | not timed | not timed | 42975.39 ± 0.7% | 1649.38 ± 5.4% | not timed | not timed | 59126.67 ± 8.3% | | 1.00 | 1.38 | 35.85 |
| 02-literal-alternate/sherlock-en | 714 | 14138.90 ± 0.2% | not timed | not timed | 10929.80 ± 0.8% | 19.09 ± 0.9% | not timed | not timed | 14103.80 ± 0.4% | | 1.00 | 1.29 | 740.58 |
| 02-literal-alternate/sherlock-casei-en | 725 | 5224.55 ± 2.9% | not timed | not timed | 2308.88 ± 2.3% | 12.27 ± 1.3% | not timed | not timed | 5223.09 ± 3.0% | | 1.00 | 2.26 | 425.94 |
| 02-literal-alternate/sherlock-ru | 899 | 10871.93 ± 2.7% | not timed | not timed | 9793.96 ± 4.9% | 25.52 ± 37.4% | not timed | not timed | 10897.17 ± 4.5% | | 1.00 | 1.11 | 426.10 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2520.43 ± 4.0% | not timed | not timed | 1189.83 ± 0.6% | 10.58 ± 0.7% | not timed | not timed | 2528.62 ± 3.4% | | 1.00 | 2.12 | 238.23 |
| 02-literal-alternate/sherlock-zh | 207 | 19840.04 ± 0.4% | not timed | not timed | 12682.97 ± 0.5% | 35.76 ± 3.4% | not timed | not timed | 19811.63 ± 0.5% | | 1.00 | 1.56 | 554.85 |
| 03-date/ascii | 111817 | 143.70 ± 11.6% | not timed | not timed | 99.60 ± 1.5% | 0.23 ± 3.1% | not timed | not timed | 146.78 ± 0.6% | | 0.98 | 1.44 | 626.21 |
| 04-ruff-noqa/real | 84 | 507.25 ± 0.7% | not timed | not timed | 509.96 ± 0.5% | 20.86 ± 2.1% | not timed | not timed | 508.38 ± 0.1% | | 1.00 | 0.99 | 24.32 |
| 04-ruff-noqa/tweaked | 44 | 894.96 ± 5.8% | not timed | not timed | 510.62 ± 1.3% | 370.54 ± 14.1% | not timed | not timed | 896.18 ± 0.3% | | 1.00 | 1.75 | 2.42 |
| 05-lexer-veryl/single | 124800 | 4.68 ± 2.2% | not timed | not timed | 5.53 ± 6.9% | 0.25 ± 6.7% | not timed | not timed | 4.75 ± 1.2% | | 0.98 | 0.85 | 18.55 |
| 06-cloud-flare-redos/original | 107 | 443.01 ± 0.7% | not timed | not timed | 227.25 ± 16.2% | 25.76 ± 2.1% | not timed | not timed | 451.71 ± 0.2% | | 0.98 | 1.95 | 17.20 |
| 06-cloud-flare-redos/simplified-short | 102 | 451.41 ± 1.2% | not timed | not timed | 237.16 ± 0.5% | 27.78 ± 1.4% | not timed | not timed | 450.87 ± 1.3% | | 1.00 | 1.90 | 16.25 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.66 ± 2.0% | not timed | not timed | 258.77 ± 0.3% | 29.79 ± 0.3% | not timed | not timed | 584.41 ± 0.1% | | 1.00 | 2.26 | 19.59 |
| 07-unicode-character-data/parse-line | 558784 | 250.71 ± 8.7% | not timed | not timed | 201.09 ± 11.7% | 48.35 ± 3.5% | not timed | not timed | 250.71 ± 2.6% | | 1.00 | 1.25 | 5.18 |
| 08-words/all-english | 56691 | 132.79 ± 1.8% | not timed | not timed | 83.23 ± 1.5% | 14.30 ± 11.5% | not timed | not timed | 131.25 ± 2.1% | | 1.01 | 1.60 | 9.29 |
| 08-words/long-english | 839 | 620.49 ± 0.2% | not timed | not timed | 585.19 ± 0.1% | 35.02 ± 1.5% | not timed | not timed | 618.78 ± 0.3% | | 1.00 | 1.06 | 17.72 |
| 09-aws-keys/full | 0 | 519.07 ± 1.1% | not timed | not timed | 522.07 ± 0.3% | 64.94 ± 6.2% | not timed | not timed | 519.24 ± 0.1% | | 1.00 | 0.99 | 7.99 |
| 09-aws-keys/quick | 0 | 1147.20 ± 12.5% | not timed | not timed | 963.53 ± 3.0% | 416.73 ± 1.1% | not timed | not timed | 1141.87 ± 12.3% | | 1.00 | 1.19 | 2.75 |
| 10-bounded-repeat/letters-en | 1833 | 681.58 ± 1.1% | not timed | not timed | 557.50 ± 3.5% | 22.80 ± 1.7% | not timed | not timed | 681.17 ± 1.2% | | 1.00 | 1.22 | 29.89 |
| 10-bounded-repeat/letters-ru | 3475 | 524.60 ± 0.9% | not timed | not timed | 483.48 ± 0.3% | 25.44 ± 18.1% | not timed | not timed | 526.04 ± 3.0% | | 1.00 | 1.09 | 20.62 |
| 10-bounded-repeat/context | 53 | 90.82 ± 1.0% | not timed | not timed | 70.87 ± 0.5% | 22.40 ± 1.3% | not timed | not timed | 91.04 ± 1.2% | | 1.00 | 1.28 | 4.05 |
| 10-bounded-repeat/capitals | 11 | 641.75 ± 8.1% | not timed | not timed | 604.36 ± 0.2% | 40.36 ± 7.6% | not timed | not timed | 641.85 ± 9.9% | | 1.00 | 1.06 | 15.90 |
| 11-unstructured-to-json/extract | 600 | 52.21 ± 8.5% | not timed | not timed | 79.45 ± 6.3% | 50.81 ± 11.8% | not timed | not timed | 51.81 ± 1.6% | | 1.01 | 0.66 | 1.03 |
| 12-dictionary/single | 1 | 510.04 ± 8.2% | not timed | not timed | 482.10 ± 0.5% | 0.37 ± 6.1% | not timed | not timed | 515.41 ± 1.7% | | 0.99 | 1.06 | 1362.48 |
| 14-quadratic/1x | 100 | 28.57 ± 0.5% | not timed | not timed | 12.18 ± 0.7% | 1.00 ± 2.7% | not timed | not timed | 28.47 ± 1.2% | | 1.00 | 2.35 | 28.62 |
| 14-quadratic/2x | 200 | 25.62 ± 1.3% | not timed | not timed | 6.12 ± 0.7% | 0.55 ± 2.3% | not timed | not timed | 25.57 ± 1.3% | | 1.00 | 4.19 | 46.75 |
| 14-quadratic/10x | 1000 | 15.10 ± 0.6% | not timed | not timed | 1.22 ± 1.0% | 0.12 ± 1.8% | not timed | not timed | 15.02 ± 4.1% | | 1.01 | 12.41 | 127.26 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.37 ± 0.2% | not timed | not timed | 0.48 ± 0.2% | 0.63 ± 5.5% | not timed | not timed | 1.37 ± 0.4% | | 1.00 | 2.88 | 2.17 |
| 04-ruff-noqa/compile-real | 1 | 120.04 ± 0.6% | not timed | not timed | 17.22 ± 0.7% | 162.77 ± 7.0% | not timed | not timed | 120.66 ± 0.6% | | 0.99 | 6.97 | 0.74 |
| 05-lexer-veryl/compile-single | 1 | 16.21 ± 1.2% | not timed | not timed | 3.00 ± 0.8% | 7.75 ± 1.7% | not timed | not timed | 16.31 ± 0.7% | | 0.99 | 5.41 | 2.09 |
| 07-unicode-character-data/compile | 1 | 123.61 ± 1.3% | not timed | not timed | 30.64 ± 13.3% | 44.39 ± 2.2% | not timed | not timed | 123.99 ± 1.4% | | 1.00 | 4.03 | 2.78 |
| 09-aws-keys/compile-full | 1 | 55.00 ± 0.9% | not timed | not timed | 10.00 ± 0.6% | 27.61 ± 1.3% | not timed | not timed | 55.03 ± 7.1% | | 1.00 | 5.50 | 1.99 |
| 09-aws-keys/compile-quick | 1 | 189.27 ± 1.2% | not timed | not timed | 58.31 ± 1.3% | 156.44 ± 3.0% | not timed | not timed | 190.28 ± 0.9% | | 0.99 | 3.25 | 1.21 |
| 10-bounded-repeat/compile-context | 1 | 59.53 ± 0.5% | not timed | not timed | 14.46 ± 0.3% | 19.75 ± 3.0% | not timed | not timed | 59.91 ± 1.7% | | 0.99 | 4.12 | 3.01 |
| 10-bounded-repeat/compile-capitals | 1 | 93.98 ± 0.3% | not timed | not timed | 10.54 ± 0.3% | 29.18 ± 3.0% | not timed | not timed | 94.25 ± 0.3% | | 1.00 | 8.92 | 3.22 |
| 11-unstructured-to-json/compile | 1 | 186.39 ± 1.3% | not timed | not timed | 47.19 ± 0.9% | 78.55 ± 3.6% | not timed | not timed | 188.52 ± 1.0% | | 0.99 | 3.95 | 2.37 |
| 12-dictionary/compile-single | 1 | 0.34 ± 0.6% | not timed | not timed | 0.08 ± 0.7% | 0.11 ± 26.6% | not timed | not timed | 0.34 ± 1.0% | | 1.00 | 4.14 | 3.04 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.24 ± 1.4% | not timed | not timed | 6.93 ± 0.2% | 0.68 ± 18.9% | not timed | not timed | 7.25 ± 2.0% | | 1.00 | 1.05 | 10.64 |
| dictionary/search/english-10 | 690 | 213.79 ± 1.5% | not timed | not timed | 152.14 ± 0.9% | 0.01 ± 0.7% | not timed | not timed | 212.51 ± 1.9% | | 1.01 | 1.41 | 31014.22 |
| dictionary/search/english-15 | 15 | 510.34 ± 1.7% | not timed | not timed | 481.63 ± 0.1% | 0.36 ± 3.0% | not timed | not timed | 515.16 ± 2.0% | | 0.99 | 1.06 | 1398.64 |
| folly/awyer-inn-busted | 1 | 24106.62 ± 0.3% | not timed | not timed | 132.23 ± 1.1% | 48.36 ± 0.7% | not timed | not timed | 24091.11 ± 0.1% | | 1.00 | 182.30 | 498.52 |
| folly/literal-never-match-rare | 0 | 67535.39 ± 8.3% | not timed | not timed | 46450.65 ± 60.8% | 69187.04 ± 2.6% | not timed | not timed | 67798.16 ± 5.9% | | 1.00 | 1.45 | 0.98 |
| folly/literal-never-match-frequent | 0 | 28751.44 ± 10.0% | not timed | not timed | 46201.29 ± 0.1% | 2587.48 ± 5.0% | not timed | not timed | 28671.56 ± 7.9% | | 1.00 | 0.62 | 11.11 |
| folly/literal-never-match-tricksy | 1 | 3915.21 ± 12.3% | not timed | not timed | 6156.06 ± 0.2% | 1724.50 ± 12.7% | not timed | not timed | 3990.01 ± 0.3% | | 0.98 | 0.64 | 2.27 |
| grep/every-line | 239963 | 1417.46 ± 4.4% | not timed | not timed | 968.19 ± 1.9% | 377.00 ± 23.3% | not timed | not timed | 1417.29 ± 3.2% | | 1.00 | 1.46 | 3.76 |
| grep/long-words-ascii | 5073 | 501.28 ± 0.4% | not timed | not timed | 498.69 ± 3.4% | 51.63 ± 8.2% | not timed | not timed | 501.82 ± 17.4% | | 1.00 | 1.01 | 9.71 |
| imported/leipzig/twain | 811 | 54803.77 ± 23.5% | not timed | not timed | 43296.46 ± 14.0% | 12856.64 ± 10.4% | not timed | not timed | 55378.09 ± 2.1% | | 0.99 | 1.27 | 4.26 |
| imported/leipzig/twain-insensitive | 965 | 15201.18 ± 0.3% | not timed | not timed | 13441.19 ± 1.3% | 44.56 ± 5.2% | not timed | not timed | 15177.81 ± 2.5% | | 1.00 | 1.13 | 341.13 |
| imported/leipzig/shing | 1540 | 28997.98 ± 0.9% | not timed | not timed | 22083.78 ± 0.6% | 38.10 ± 3.9% | not timed | not timed | 28853.48 ± 2.0% | | 1.01 | 1.31 | 761.19 |
| imported/leipzig/huck-saw | 262 | 24907.85 ± 0.5% | not timed | not timed | 18736.67 ± 18.4% | 35.78 ± 0.1% | not timed | not timed | 24983.78 ± 0.9% | | 1.00 | 1.33 | 696.12 |
| imported/leipzig/word-ending-nn | 262 | 609.74 ± 0.2% | not timed | not timed | 604.47 ± 0.5% | 27.45 ± 1.9% | not timed | not timed | 609.72 ± 0.3% | | 1.00 | 1.01 | 22.21 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 10818.87 ± 0.5% | not timed | not timed | 3921.80 ± 2.5% | 12.19 ± 0.9% | not timed | not timed | 10799.39 ± 3.8% | | 1.00 | 2.76 | 887.31 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 21483.34 ± 1.3% | not timed | not timed | 17620.94 ± 14.3% | 19.35 ± 1.9% | not timed | not timed | 21535.36 ± 2.5% | | 1.00 | 1.22 | 1110.38 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5534.23 ± 0.1% | not timed | not timed | 793.70 ± 1.1% | 12.04 ± 4.4% | not timed | not timed | 5534.14 ± 0.2% | | 1.00 | 6.97 | 459.65 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 17957.24 ± 1.1% | not timed | not timed | 602.42 ± 0.4% | 12.34 ± 0.8% | not timed | not timed | 17997.08 ± 1.3% | | 1.00 | 29.81 | 1455.77 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 16913.63 ± 4.4% | not timed | not timed | 602.84 ± 0.6% | 10.63 ± 1.1% | not timed | not timed | 16949.15 ± 1.6% | | 1.00 | 28.06 | 1591.59 |
| imported/leipzig/tom-river | 2 | 12928.24 ± 0.5% | not timed | not timed | 13430.74 ± 4.0% | 34.52 ± 2.7% | not timed | not timed | 12947.02 ± 0.4% | | 1.00 | 0.96 | 374.54 |
| imported/leipzig/ing | 78424 | 600.34 ± 0.5% | not timed | not timed | 560.79 ± 0.3% | 30.63 ± 4.3% | not timed | not timed | 599.97 ± 0.7% | | 1.00 | 1.07 | 19.60 |
| imported/leipzig/ing-whitespace | 55248 | 1915.30 ± 1.2% | not timed | not timed | 2137.48 ± 4.0% | 22.10 ± 5.0% | not timed | not timed | 1927.74 ± 10.3% | | 0.99 | 0.90 | 86.65 |
| imported/leipzig/awyer-inn | 209 | 10952.95 ± 1.5% | not timed | not timed | 13706.24 ± 13.6% | 24.35 ± 2.0% | not timed | not timed | 10952.52 ± 0.8% | | 1.00 | 0.80 | 449.90 |
| imported/leipzig/quotes-bounded | 8886 | 2313.57 ± 0.7% | not timed | not timed | 3277.82 ± 0.6% | 41.04 ± 3.8% | not timed | not timed | 2318.27 ± 0.1% | | 1.00 | 0.71 | 56.38 |
| imported/leipzig/non-ascii-alternate | 2 | 40424.90 ± 1.7% | not timed | not timed | 19599.65 ± 0.4% | 56.88 ± 3.0% | not timed | not timed | 40599.41 ± 0.2% | | 1.00 | 2.06 | 710.70 |
| imported/leipzig/math-symbols | 69 | 2434.53 ± 0.1% | not timed | not timed | 604.30 ± 0.3% | 39.46 ± 0.6% | not timed | not timed | 2434.62 ± 7.5% | | 1.00 | 4.03 | 61.70 |
| imported/leipzig/bounded-strings-ending-z | 0 | 610.03 ± 0.7% | not timed | not timed | 603.94 ± 0.4% | 25.34 ± 4.9% | not timed | not timed | 609.60 ± 2.4% | | 1.00 | 1.01 | 24.08 |
| imported/lh3lh3-reb/uri | 17549 | 807.08 ± 0.5% | not timed | not timed | 1125.33 ± 3.4% | 30.56 ± 2.5% | not timed | not timed | 805.20 ± 0.2% | | 1.00 | 0.72 | 26.41 |
| imported/lh3lh3-reb/email | 15057 | 788.04 ± 0.4% | not timed | not timed | 1135.45 ± 1.5% | 33.36 ± 3.1% | not timed | not timed | 800.71 ± 0.7% | | 0.98 | 0.69 | 23.62 |
| imported/lh3lh3-reb/date | 668 | 947.04 ± 0.2% | not timed | not timed | 1017.38 ± 1.4% | 53.81 ± 4.8% | not timed | not timed | 948.32 ± 0.3% | | 1.00 | 0.93 | 17.60 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 744.90 ± 22.1% | not timed | not timed | 443.51 ± 0.4% | 16.51 ± 2.0% | not timed | not timed | 742.12 ± 0.7% | | 1.00 | 1.68 | 45.11 |
| imported/mariomka/email | 92 | 39000.69 ± 1.7% | not timed | not timed | 59616.44 ± 0.6% | 35.88 ± 0.3% | not timed | not timed | 39298.48 ± 0.6% | | 0.99 | 0.65 | 1087.04 |
| imported/mariomka/uri | 5301 | 6546.91 ± 0.4% | not timed | not timed | 7928.93 ± 0.7% | 35.89 ± 1.2% | not timed | not timed | 6580.86 ± 0.3% | | 0.99 | 0.83 | 182.41 |
| imported/mariomka/ip | 5 | 2531.76 ± 2.8% | not timed | not timed | 2323.33 ± 0.9% | 22.63 ± 6.5% | not timed | not timed | 2524.87 ± 2.7% | | 1.00 | 1.09 | 111.88 |
| imported/rsc/no-exponential | 0 | 893.46 ± 0.4% | not timed | not timed | 422.38 ± 0.7% | 26.10 ± 0.8% | not timed | not timed | 888.94 ± 0.8% | | 1.01 | 2.12 | 34.24 |
| imported/rsc/literal | 1 | 1913.33 ± 11.0% | not timed | not timed | 1989.91 ± 0.5% | 234.13 ± 12.4% | not timed | not timed | 1914.50 ± 19.1% | | 1.00 | 0.96 | 8.17 |
| imported/rsc/not-literal | 2 | 961.83 ± 5.3% | not timed | not timed | 841.38 ± 14.8% | 54.60 ± 9.0% | not timed | not timed | 965.19 ± 0.5% | | 1.00 | 1.14 | 17.62 |
| imported/rsc/match-class | 1 | 1904.27 ± 1.4% | not timed | not timed | 1765.38 ± 0.3% | 68.09 ± 7.1% | not timed | not timed | 1902.31 ± 0.6% | | 1.00 | 1.08 | 27.97 |
| imported/rsc/match-class-in-range | 1 | 1865.33 ± 20.0% | not timed | not timed | 3430.98 ± 3.9% | 70.01 ± 6.1% | not timed | not timed | 1896.45 ± 1.2% | | 0.98 | 0.54 | 26.64 |
| imported/rsc/match-class-unicode | 1 | 571.46 ± 4.4% | not timed | not timed | 519.20 ± 10.2% | 83.20 ± 14.3% | not timed | not timed | 571.86 ± 7.9% | | 1.00 | 1.10 | 6.87 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1586.81 ± 50.1% | not timed | not timed | 1136.66 ± 32.0% | 345.17 ± 1.7% | not timed | not timed | 1587.53 ± 0.1% | | 1.00 | 1.40 | 4.60 |
| imported/rsc/anchored-literal-long-non-match | 0 | 23730.71 ± 8.5% | not timed | not timed | 17008.55 ± 35.5% | 5156.21 ± 1.7% | not timed | not timed | 23827.83 ± 0.2% | | 1.00 | 1.40 | 4.60 |
| imported/rsc/anchored-literal-short-match | 4 | 815.49 ± 5.9% | not timed | not timed | 553.73 ± 1.2% | 110.19 ± 13.4% | not timed | not timed | 828.57 ± 3.8% | | 0.98 | 1.47 | 7.40 |
| imported/rsc/anchored-literal-long-match | 4 | 12297.13 ± 2.0% | not timed | not timed | 8271.66 ± 12.8% | 1674.73 ± 1.1% | not timed | not timed | 12478.17 ± 9.3% | | 0.99 | 1.49 | 7.34 |
| imported/rsc/one-pass-short | 17 | 472.22 ± 7.2% | not timed | not timed | 258.74 ± 0.3% | 39.09 ± 17.4% | not timed | not timed | 483.81 ± 45.1% | | 0.98 | 1.83 | 12.08 |
| imported/rsc/one-pass-short-not | 17 | 328.20 ± 2.4% | not timed | not timed | 271.77 ± 0.9% | 35.59 ± 16.0% | not timed | not timed | 319.83 ± 10.3% | | 1.03 | 1.21 | 9.22 |
| imported/rsc/one-pass-long-prefix | 26 | 430.62 ± 4.9% | not timed | not timed | 319.04 ± 4.9% | 129.60 ± 16.2% | not timed | not timed | 440.93 ± 3.3% | | 0.98 | 1.35 | 3.32 |
| imported/rsc/one-pass-long-prefix-not | 26 | 440.08 ± 2.7% | not timed | not timed | 322.53 ± 0.4% | 85.44 ± 10.7% | not timed | not timed | 445.83 ± 1.9% | | 0.99 | 1.36 | 5.15 |
| imported/rsc/long-needle1 | 31 | 67908.42 ± 10.3% | not timed | not timed | 45852.11 ± 16.1% | 4.19 ± 2.2% | not timed | not timed | 68076.76 ± 0.0% | | 1.00 | 1.48 | 16194.94 |
| imported/rsc/long-needle2 | 31 | 67563.47 ± 12.1% | not timed | not timed | 227.73 ± 1.7% | 4.21 ± 3.3% | not timed | not timed | 67646.02 ± 0.2% | | 1.00 | 296.69 | 16066.58 |
| imported/rsc/easy0-32 | 26 | 2004.38 ± 8.0% | not timed | not timed | 1950.24 ± 1.6% | 169.99 ± 19.3% | not timed | not timed | 2018.73 ± 10.3% | | 0.99 | 1.03 | 11.79 |
| imported/rsc/easy0-1k | 26 | 16762.34 ± 1.9% | not timed | not timed | 20435.00 ± 5.7% | 2592.00 ± 17.7% | not timed | not timed | 16755.51 ± 20.2% | | 1.00 | 0.82 | 6.47 |
| imported/rsc/easy0-32k | 26 | 63455.51 ± 15.2% | not timed | not timed | 43856.71 ± 0.3% | 26276.61 ± 22.1% | not timed | not timed | 63262.24 ± 2.4% | | 1.00 | 1.45 | 2.41 |
| imported/rsc/easy0-1mb | 26 | 66103.02 ± 0.3% | not timed | not timed | 45963.51 ± 26.8% | 66747.45 ± 5.6% | not timed | not timed | 66231.30 ± 0.5% | | 1.00 | 1.44 | 0.99 |
| imported/rsc/easy1-32 | 19 | 915.36 ± 11.4% | not timed | not timed | 758.20 ± 0.5% | 148.70 ± 12.8% | not timed | not timed | 941.70 ± 7.4% | | 0.97 | 1.21 | 6.16 |
| imported/rsc/easy1-1k | 19 | 18972.84 ± 2.8% | not timed | not timed | 15274.52 ± 0.7% | 2678.00 ± 14.4% | not timed | not timed | 19124.17 ± 19.1% | | 0.99 | 1.24 | 7.08 |
| imported/rsc/easy1-32k | 19 | 598311.47 ± 6.6% | not timed | not timed | 492209.79 ± 1.0% | 29382.81 ± 18.6% | not timed | not timed | 605039.69 ± 19.1% | | 0.99 | 1.22 | 20.36 |
| imported/rsc/easy1-1mb | 19 | 19086731.77 ± 1.3% | not timed | not timed | 15762931.03 ± 0.9% | 67305.08 ± 0.2% | not timed | not timed | 19256988.14 ± 1.2% | | 0.99 | 1.21 | 283.59 |
| imported/rsc/medium-32 | 27 | 875.08 ± 6.1% | not timed | not timed | 738.98 ± 0.6% | 83.00 ± 9.2% | not timed | not timed | 877.17 ± 1.0% | | 1.00 | 1.18 | 10.54 |
| imported/rsc/medium-1k | 27 | 15615.24 ± 0.4% | not timed | not timed | 11199.23 ± 10.4% | 80.94 ± 0.5% | not timed | not timed | 15619.40 ± 0.6% | | 1.00 | 1.39 | 192.92 |
| imported/rsc/medium-32k | 27 | 487301.74 ± 2.7% | not timed | not timed | 283479.30 ± 1.3% | 53.79 ± 1.4% | not timed | not timed | 486969.12 ± 4.2% | | 1.00 | 1.72 | 9059.32 |
| imported/rsc/medium-1mb | 27 | 15620895.35 ± 3.6% | not timed | not timed | 13129828.44 ± 0.4% | 54.36 ± 1.5% | not timed | not timed | 15612518.50 ± 1.3% | | 1.00 | 1.19 | 287372.26 |
| imported/rsc/hard-32 | 58 | 450.77 ± 0.3% | not timed | not timed | 386.69 ± 1.0% | 53.37 ± 8.4% | not timed | not timed | 449.90 ± 2.6% | | 1.00 | 1.17 | 8.45 |
| imported/rsc/hard-1k | 27 | 14938.71 ± 5.8% | not timed | not timed | 12867.67 ± 5.5% | 41.57 ± 43.3% | not timed | not timed | 14797.97 ± 7.1% | | 1.01 | 1.16 | 359.33 |
| imported/rsc/hard-32k | 27 | 448151.23 ± 7.3% | not timed | not timed | 396890.03 ± 5.7% | 31.60 ± 12.1% | not timed | not timed | 463079.69 ± 5.0% | | 0.97 | 1.13 | 14184.03 |
| imported/rsc/hard-1mb | 51 | 9023073.94 ± 1.2% | not timed | not timed | 7855274.78 ± 0.4% | 33.09 ± 0.3% | not timed | not timed | 9003611.21 ± 0.5% | | 1.00 | 1.15 | 272680.76 |
| imported/rsc/reallyhard0-32 | 58 | 281.04 ± 1.5% | not timed | not timed | 244.61 ± 1.0% | 53.35 ± 7.5% | not timed | not timed | 280.19 ± 2.4% | | 1.00 | 1.15 | 5.27 |
| imported/rsc/reallyhard0-1k | 27 | 590.98 ± 0.3% | not timed | not timed | 580.28 ± 1.4% | 44.97 ± 0.6% | not timed | not timed | 592.44 ± 0.4% | | 1.00 | 1.02 | 13.14 |
| imported/rsc/reallyhard0-32k | 27 | 608.93 ± 0.5% | not timed | not timed | 602.88 ± 0.6% | 32.89 ± 0.5% | not timed | not timed | 608.81 ± 0.1% | | 1.00 | 1.01 | 18.51 |
| imported/rsc/reallyhard0-1mb | 51 | 608.67 ± 0.4% | not timed | not timed | 603.89 ± 0.5% | 33.11 ± 0.9% | not timed | not timed | 608.63 ± 0.4% | | 1.00 | 1.01 | 18.38 |
| imported/rsc/reallyreallyhard0-32 | 47 | 327.44 ± 2.0% | not timed | not timed | 209.45 ± 0.8% | 66.66 ± 6.8% | not timed | not timed | 330.29 ± 1.3% | | 0.99 | 1.56 | 4.91 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7657.62 ± 0.9% | not timed | not timed | 7729.10 ± 0.9% | 36.86 ± 0.2% | not timed | not timed | 7669.42 ± 0.3% | | 1.00 | 0.99 | 207.74 |
| imported/rsc/reallyreallyhard0-32k | 16 | 52097.47 ± 1.3% | not timed | not timed | 36963.12 ± 3.8% | 26.46 ± 1.1% | not timed | not timed | 51991.89 ± 0.3% | | 1.00 | 1.41 | 1968.63 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 70518.33 ± 0.4% | not timed | not timed | 45568.41 ± 0.7% | 26.82 ± 0.4% | not timed | not timed | 70796.78 ± 0.2% | | 1.00 | 1.55 | 2629.10 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 316.46 ± 1.5% | not timed | not timed | 215.57 ± 4.3% | 66.23 ± 10.4% | not timed | not timed | 319.85 ± 1.4% | | 0.99 | 1.47 | 4.78 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 6392.62 ± 0.3% | not timed | not timed | 7400.14 ± 11.8% | 36.99 ± 0.5% | not timed | not timed | 6388.40 ± 0.2% | | 1.00 | 0.86 | 172.83 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 48821.46 ± 0.3% | not timed | not timed | 37232.76 ± 0.9% | 26.79 ± 0.4% | not timed | not timed | 48826.75 ± 0.6% | | 1.00 | 1.31 | 1822.10 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 63685.79 ± 0.3% | not timed | not timed | 45452.42 ± 0.7% | 26.89 ± 0.4% | not timed | not timed | 63849.02 ± 0.7% | | 1.00 | 1.40 | 2368.60 |
| imported/sherlock/name-sherlock | 776 | 44609.30 ± 9.8% | not timed | not timed | 40261.82 ± 1.9% | 13283.64 ± 17.2% | not timed | not timed | 48532.54 ± 10.3% | | 0.92 | 1.11 | 3.36 |
| imported/sherlock/name-holmes | 2766 | 23346.24 ± 6.4% | not timed | not timed | 30413.61 ± 1.7% | 4006.50 ± 4.0% | not timed | not timed | 23800.43 ± 7.8% | | 0.98 | 0.77 | 5.83 |
| imported/sherlock/name-sherlock-holmes | 1365 | 48772.25 ± 10.8% | not timed | not timed | 40621.20 ± 1.1% | 10496.95 ± 27.9% | not timed | not timed | 48722.31 ± 3.1% | | 1.00 | 1.20 | 4.65 |
| imported/sherlock/name-sherlock-casei | 816 | 44390.10 ± 21.0% | not timed | not timed | 11550.95 ± 6.5% | 33.79 ± 2.2% | not timed | not timed | 44440.35 ± 2.6% | | 1.00 | 3.84 | 1313.84 |
| imported/sherlock/name-holmes-casei | 2802 | 19852.37 ± 0.4% | not timed | not timed | 7662.04 ± 0.4% | 44.72 ± 0.4% | not timed | not timed | 19856.67 ± 0.4% | | 1.00 | 2.59 | 443.97 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 35407.92 ± 4.3% | not timed | not timed | 11214.40 ± 0.5% | 33.76 ± 31.2% | not timed | not timed | 35413.52 ± 0.4% | | 1.00 | 3.16 | 1048.82 |
| imported/sherlock/name-whitespace | 1461 | 28158.34 ± 1.0% | not timed | not timed | 28201.81 ± 1.1% | 8421.98 ± 17.0% | not timed | not timed | 28511.91 ± 11.3% | | 0.99 | 1.00 | 3.34 |
| imported/sherlock/name-alt1 | 1142 | 29151.54 ± 0.7% | not timed | not timed | 29619.56 ± 1.3% | 5649.71 ± 31.4% | not timed | not timed | 29302.63 ± 1.4% | | 0.99 | 0.98 | 5.16 |
| imported/sherlock/name-alt2 | 3542 | 17951.27 ± 0.5% | not timed | not timed | 10095.81 ± 0.2% | 35.70 ± 2.0% | not timed | not timed | 17962.13 ± 0.9% | | 1.00 | 1.78 | 502.90 |
| imported/sherlock/name-alt3 | 4507 | 11783.44 ± 1.8% | not timed | not timed | 9234.38 ± 1.1% | 11.26 ± 0.7% | not timed | not timed | 11820.17 ± 0.6% | | 1.00 | 1.28 | 1046.58 |
| imported/sherlock/name-alt3-casei | 4593 | 3552.94 ± 2.1% | not timed | not timed | 1309.35 ± 8.5% | 7.54 ± 12.7% | not timed | not timed | 3545.15 ± 8.0% | | 1.00 | 2.71 | 471.47 |
| imported/sherlock/name-alt4 | 3686 | 9896.97 ± 0.2% | not timed | not timed | 8064.56 ± 0.4% | 35.46 ± 0.8% | not timed | not timed | 10015.14 ± 13.8% | | 0.99 | 1.23 | 279.10 |
| imported/sherlock/name-alt4-casei | 4254 | 5315.16 ± 1.2% | not timed | not timed | 4477.35 ± 1.6% | 20.75 ± 4.4% | not timed | not timed | 5458.13 ± 1.2% | | 0.97 | 1.19 | 256.20 |
| imported/sherlock/name-alt5 | 4028 | 14944.59 ± 1.1% | not timed | not timed | 9662.93 ± 0.9% | 24.77 ± 0.8% | not timed | not timed | 14947.25 ± 0.9% | | 1.00 | 1.55 | 603.24 |
| imported/sherlock/name-alt5-casei | 4104 | 6920.96 ± 1.6% | not timed | not timed | 2998.18 ± 0.3% | 15.49 ± 0.6% | not timed | not timed | 6960.24 ± 0.6% | | 0.99 | 2.31 | 446.87 |
| imported/sherlock/no-match-uncommon | 0 | 69574.71 ± 0.6% | not timed | not timed | 58157.11 ± 0.5% | 58061.52 ± 0.8% | not timed | not timed | 69546.90 ± 1.0% | | 1.00 | 1.20 | 1.20 |
| imported/sherlock/no-match-common | 0 | 68036.93 ± 0.9% | not timed | not timed | 58235.90 ± 0.7% | 2140.25 ± 1.1% | not timed | not timed | 68079.88 ± 0.4% | | 1.00 | 1.17 | 31.79 |
| imported/sherlock/no-match-really-common | 0 | 43338.69 ± 0.3% | not timed | not timed | 49884.88 ± 14.6% | 2139.06 ± 10.9% | not timed | not timed | 43432.12 ± 0.3% | | 1.00 | 0.87 | 20.26 |
| imported/sherlock/the-lower | 21654 | 3382.11 ± 1.3% | not timed | not timed | 4608.10 ± 17.4% | 269.43 ± 23.2% | not timed | not timed | 3398.98 ± 2.9% | | 1.00 | 0.73 | 12.55 |
| imported/sherlock/the-upper | 2223 | 17204.92 ± 1.1% | not timed | not timed | 29508.58 ± 0.3% | 3103.37 ± 16.7% | not timed | not timed | 17274.69 ± 13.3% | | 1.00 | 0.58 | 5.54 |
| imported/sherlock/the-casei | 23961 | 3038.42 ± 0.9% | not timed | not timed | 1363.40 ± 2.0% | 41.41 ± 36.0% | not timed | not timed | 3040.30 ± 9.7% | | 1.00 | 2.23 | 73.37 |
| imported/sherlock/everything-greedy | 581881 | 291.97 ± 0.8% | not timed | not timed | 172.90 ± 8.3% | 30.58 ± 31.2% | not timed | not timed | 292.55 ± 8.6% | | 1.00 | 1.69 | 9.55 |
| imported/sherlock/everything-greedy-nl | 594933 | 510.24 ± 0.4% | not timed | not timed | 224.61 ± 1.3% | 34.66 ± 1.1% | not timed | not timed | 510.27 ± 0.2% | | 1.00 | 2.27 | 14.72 |
| imported/sherlock/letters | 447175 | 64.78 ± 8.6% | not timed | not timed | 33.14 ± 5.1% | 6.76 ± 48.9% | not timed | not timed | 67.95 ± 3.1% | | 0.95 | 1.95 | 9.58 |
| imported/sherlock/letters-upper | 14180 | 455.04 ± 1.5% | not timed | not timed | 367.28 ± 0.2% | 31.09 ± 28.5% | not timed | not timed | 454.49 ± 0.2% | | 1.00 | 1.24 | 14.64 |
| imported/sherlock/letters-lower | 432995 | 67.37 ± 19.7% | not timed | not timed | 33.89 ± 5.1% | 6.71 ± 38.8% | not timed | not timed | 69.37 ± 2.6% | | 0.97 | 1.99 | 10.05 |
| imported/sherlock/words | 447639 | 122.55 ± 5.5% | not timed | not timed | 82.75 ± 2.1% | 15.38 ± 17.0% | not timed | not timed | 123.08 ± 5.9% | | 1.00 | 1.48 | 7.97 |
| imported/sherlock/before-holmes | 4073 | 13894.21 ± 3.0% | not timed | not timed | 13335.84 ± 0.3% | 25.64 ± 0.6% | not timed | not timed | 13839.51 ± 1.5% | | 1.00 | 1.04 | 541.82 |
| imported/sherlock/before-after-holmes | 2593 | 13434.83 ± 19.4% | not timed | not timed | 15070.66 ± 0.3% | 25.66 ± 0.4% | not timed | not timed | 13518.99 ± 0.9% | | 0.99 | 0.89 | 523.51 |
| imported/sherlock/holmes-cochar-watson | 150 | 10018.37 ± 15.7% | not timed | not timed | 7670.19 ± 0.3% | 34.82 ± 0.8% | not timed | not timed | 10078.00 ± 0.3% | | 0.99 | 1.31 | 287.69 |
| imported/sherlock/holmes-coword-watson | 14309 | 1271.75 ± 0.2% | not timed | not timed | 1231.27 ± 0.2% | 7.61 ± 1.4% | not timed | not timed | 1272.28 ± 0.2% | | 1.00 | 1.03 | 167.14 |
| imported/sherlock/quotes | 14437 | 1545.64 ± 3.6% | not timed | not timed | 2270.02 ± 2.7% | 37.69 ± 35.0% | not timed | not timed | 1549.68 ± 0.8% | | 1.00 | 0.68 | 41.00 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 35360.41 ± 13.7% | not timed | not timed | 31423.71 ± 11.7% | 40.75 ± 22.3% | not timed | not timed | 35437.11 ± 0.2% | | 1.00 | 1.13 | 867.72 |
| imported/sherlock/word-ending-n | 35297 | 473.64 ± 0.3% | not timed | not timed | 402.64 ± 0.2% | 25.72 ± 1.7% | not timed | not timed | 473.75 ± 0.3% | | 1.00 | 1.18 | 18.42 |
| imported/sherlock/repeated-class-negation | 2130 | 16599.65 ± 2.7% | not timed | not timed | 16678.14 ± 0.1% | 12.15 ± 26.1% | not timed | not timed | 16612.08 ± 1.5% | | 1.00 | 1.00 | 1366.52 |
| imported/sherlock/ing-suffix | 20547 | 572.12 ± 0.5% | not timed | not timed | 512.66 ± 1.2% | 30.60 ± 20.8% | not timed | not timed | 571.16 ± 3.2% | | 1.00 | 1.12 | 18.70 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1737.20 ± 2.2% | not timed | not timed | 2919.33 ± 0.9% | 22.54 ± 0.6% | not timed | not timed | 1742.99 ± 2.3% | | 1.00 | 0.60 | 77.08 |
| opt/accelerate/whole-line | 239963 | 502.44 ± 0.3% | not timed | not timed | 414.51 ± 1.1% | 84.38 ± 14.8% | not timed | not timed | 501.00 ± 8.6% | | 1.00 | 1.21 | 5.95 |
| opt/accelerate/non-dna | 16745 | 451.52 ± 1.7% | not timed | not timed | 432.77 ± 0.5% | 32.74 ± 22.9% | not timed | not timed | 456.73 ± 9.8% | | 0.99 | 1.04 | 13.79 |
| opt/backtrack/words-english | 40536 | 140.16 ± 3.3% | not timed | not timed | 109.75 ± 1.3% | 21.83 ± 8.1% | not timed | not timed | 136.78 ± 5.3% | | 1.02 | 1.28 | 6.42 |
| opt/fixed-length/too-small-ascii | 0 | 388.48 ± 0.8% | not timed | not timed | 708.35 ± 0.7% | 122.98 ± 3.2% | not timed | not timed | 390.63 ± 0.2% | | 0.99 | 0.55 | 3.16 |
| opt/fixed-length/too-big-ascii | 0 | 4386.48 ± 0.6% | not timed | not timed | 6169.84 ± 0.3% | 151.46 ± 0.7% | not timed | not timed | 4394.29 ± 0.3% | | 1.00 | 0.71 | 28.96 |
| opt/fixed-length/go33484-1 | 0 | 844251.04 ± 0.6% | not timed | not timed | 1214684.37 ± 0.4% | 90145.42 ± 0.3% | not timed | not timed | 846537.93 ± 0.7% | | 1.00 | 0.70 | 9.37 |
| opt/fixed-length/go33484-2 | 0 | 842144.71 ± 1.1% | not timed | not timed | 1216018.03 ± 0.3% | 29775.30 ± 2.5% | not timed | not timed | 845565.75 ± 15.7% | | 1.00 | 0.69 | 28.28 |
| opt/fixed-length/go33484-3 | 0 | 82594.97 ± 1.2% | not timed | not timed | 121547.17 ± 0.3% | 933.63 ± 1.4% | not timed | not timed | 83249.29 ± 1.2% | | 0.99 | 0.68 | 88.47 |
| opt/literal-alt/one-pattern | 1 | 574.10 ± 7.7% | not timed | not timed | 569.41 ± 6.7% | 0.38 ± 3.0% | not timed | not timed | 575.76 ± 1.9% | | 1.00 | 1.01 | 1528.50 |
| opt/onepass/fn-predicate | 916 | 436.16 ± 27.8% | not timed | not timed | 397.81 ± 0.4% | 215.06 ± 16.8% | not timed | not timed | 430.62 ± 3.3% | | 1.01 | 1.10 | 2.03 |
| opt/onepass/first-three-words-english | 35128 | 178.53 ± 10.7% | not timed | not timed | 229.89 ± 0.7% | 69.34 ± 19.8% | not timed | not timed | 175.77 ± 1.9% | | 1.02 | 0.78 | 2.57 |
| opt/prefilter/literal-english | 1 | 69258.65 ± 1.0% | not timed | not timed | 46482.54 ± 0.6% | 26857.62 ± 0.4% | not timed | not timed | 69422.26 ± 0.5% | | 1.00 | 1.49 | 2.58 |
| opt/prefilter/literal-casei-english | 1 | 48429.57 ± 0.7% | not timed | not timed | 14309.68 ± 0.8% | 33.86 ± 1.1% | not timed | not timed | 48272.34 ± 2.0% | | 1.00 | 3.38 | 1430.37 |
| opt/prefilter/literal-russian | 1 | 67800.81 ± 0.3% | not timed | not timed | 46380.23 ± 0.3% | 1803.99 ± 1.3% | not timed | not timed | 67834.28 ± 1.4% | | 1.00 | 1.46 | 37.58 |
| opt/prefilter/literal-casei-russian | 1 | 26031.36 ± 0.3% | not timed | not timed | 11021.22 ± 1.8% | 37.75 ± 0.8% | not timed | not timed | 26171.27 ± 0.1% | | 0.99 | 2.36 | 689.64 |
| opt/prefilter/rust-functions | 948 | 14659.86 ± 1.0% | not timed | not timed | 12786.86 ± 1.1% | 1960.90 ± 0.2% | not timed | not timed | 14688.30 ± 0.7% | | 1.00 | 1.15 | 7.48 |
| opt/reverse-anchored/word-end | 1 | 35418114.47 ± 0.9% | not timed | not timed | 27255614.65 ± 1.4% | 56.91 ± 0.5% | not timed | not timed | 36271880.83 ± 0.9% | | 0.98 | 1.30 | 622387.17 |
| opt/reverse-inner/holmes | 2593 | 13445.97 ± 0.4% | not timed | not timed | 15001.24 ± 15.9% | 25.61 ± 0.4% | not timed | not timed | 13511.44 ± 2.1% | | 1.00 | 0.90 | 525.03 |
| opt/reverse-inner/email | 47 | 83269.73 ± 1.1% | not timed | not timed | 92344.12 ± 0.2% | 35.31 ± 0.4% | not timed | not timed | 83180.29 ± 4.9% | | 1.00 | 0.90 | 2358.26 |
| opt/reverse-inner/factored-prefix | 3542 | 599.94 ± 0.3% | not timed | not timed | 585.71 ± 3.0% | 13.94 ± 0.7% | not timed | not timed | 600.20 ± 0.6% | | 1.00 | 1.02 | 43.04 |
| opt/reverse-inner/no-quadratic-backward | 0 | 23282.18 ± 0.4% | not timed | not timed | 604.48 ± 0.4% | 86.06 ± 0.9% | not timed | not timed | 23309.20 ± 0.1% | | 1.00 | 38.52 | 270.54 |
| opt/reverse-inner/no-quadratic-forward | 0 | 708.58 ± 1.8% | not timed | not timed | 278.18 ± 0.1% | 25.85 ± 1.5% | not timed | not timed | 708.09 ± 2.0% | | 1.00 | 2.55 | 27.41 |
| opt/reverse-suffix/holmes | 4073 | 13892.87 ± 1.1% | not timed | not timed | 13328.95 ± 0.4% | 25.38 ± 2.7% | not timed | not timed | 13851.43 ± 6.0% | | 1.00 | 1.04 | 547.47 |
| opt/reverse-suffix/no-quadratic | 0 | 23272.46 ± 0.2% | not timed | not timed | 604.01 ± 0.3% | 84.17 ± 0.1% | not timed | not timed | 23230.80 ± 0.5% | | 1.00 | 38.53 | 276.50 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 142.91 ± 0.4% | not timed | not timed | 180.73 ± 0.3% | 16.66 ± 23.7% | not timed | not timed | 141.47 ± 3.5% | | 1.01 | 0.79 | 8.58 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 140.27 ± 2.8% | not timed | not timed | 182.42 ± 0.9% | 16.52 ± 16.7% | not timed | not timed | 141.35 ± 1.6% | | 0.99 | 0.77 | 8.49 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.32 ± 4.4% | not timed | not timed | 0.49 ± 4.7% | 119.31 ± 5.9% | not timed | not timed | 0.31 ± 0.4% | | 1.01 | 0.65 | 0.0027 |
| reported/i1095-word-repetition/ascii-search | 256 | 304.16 ± 3.2% | not timed | not timed | 284.62 ± 0.1% | 109.43 ± 7.1% | not timed | not timed | 287.80 ± 0.5% | | 1.06 | 1.07 | 2.78 |
| reported/i13-subset-regex/original-ascii | 4094 | 10781.98 ± 4.7% | not timed | not timed | 3917.50 ± 0.6% | 12.10 ± 1.5% | not timed | not timed | 10777.94 ± 0.9% | | 1.00 | 2.75 | 891.29 |
| reported/i13-subset-regex/original-unicode | 4094 | 10726.95 ± 1.0% | not timed | not timed | 206.35 ± 1.4% | 12.18 ± 0.9% | not timed | not timed | 10755.10 ± 0.6% | | 1.00 | 51.98 | 880.86 |
| reported/i13-subset-regex/big-ascii | 1955 | 10164.94 ± 0.4% | not timed | not timed | 54.43 ± 2.2% | 10.47 ± 2.6% | not timed | not timed | 10160.82 ± 0.8% | | 1.00 | 186.77 | 970.68 |
| reported/i13-subset-regex/big-unicode | 1955 | 10075.17 ± 0.5% | not timed | not timed | 9.60 ± 55.3% | 10.45 ± 1.1% | not timed | not timed | 10127.70 ± 0.5% | | 0.99 | 1048.95 | 964.13 |
| reported/i13-subset-regex/huge-ascii | 55 | 9328.59 ± 1.6% | not timed | not timed | 8.93 ± 0.4% | 9.42 ± 1.3% | not timed | not timed | 9329.12 ± 1.3% | | 1.00 | 1044.63 | 990.35 |
| reported/i13-subset-regex/huge-unicode | 55 | 9224.26 ± 1.5% | not timed | not timed | 8.81 ± 1.2% | 9.43 ± 2.0% | not timed | not timed | 9175.26 ± 1.6% | | 1.01 | 1046.69 | 978.26 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.16 ± 0.7% | not timed | not timed | 8.97 ± 0.5% | 9.40 ± 1.6% | not timed | not timed | 4.17 ± 1.4% | | 1.00 | 0.46 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.68 ± 1.0% | not timed | not timed | 8.14 ± 0.5% | 9.36 ± 2.0% | not timed | not timed | 5.82 ± 1.5% | | 0.98 | 0.70 | 0.61 |
| reported/i787-keywords/ascii | 5674 | 558.66 ± 1.2% | not timed | not timed | 171.37 ± 2.0% | 6.86 ± 1.3% | not timed | not timed | 555.04 ± 1.2% | | 1.01 | 3.26 | 81.50 |
| reported/i787-keywords/opt-ascii | 5674 | 556.78 ± 2.0% | not timed | not timed | 271.43 ± 1.2% | 12.02 ± 0.2% | not timed | not timed | 557.56 ± 0.3% | | 1.00 | 2.05 | 46.31 |
| slow/quadratic-regex-1x | 100 | 8.22 ± 0.3% | not timed | not timed | 6.01 ± 0.1% | 0.05 ± 0.4% | not timed | not timed | 8.14 ± 1.1% | | 1.01 | 1.37 | 167.83 |
| slow/quadratic-regex-2x | 199 | 3.70 ± 0.3% | not timed | not timed | 3.04 ± 2.4% | 0.01 ± 20.1% | not timed | not timed | 3.71 ± 0.1% | | 1.00 | 1.22 | 279.63 |
| slow/quadratic-haystack-1x | 100 | 28.33 ± 27.8% | not timed | not timed | 12.19 ± 0.3% | 0.82 ± 10.5% | not timed | not timed | 28.53 ± 1.5% | | 0.99 | 2.32 | 34.65 |
| slow/quadratic-haystack-2x | 200 | 25.65 ± 0.2% | not timed | not timed | 6.12 ± 0.2% | 0.30 ± 0.8% | not timed | not timed | 25.66 ± 0.8% | | 1.00 | 4.19 | 86.21 |
| unicode/codepoints/any-one | 1112064 | 340.13 ± 0.3% | not timed | not timed | 241.73 ± 0.5% | 21.00 ± 26.1% | not timed | not timed | 340.63 ± 18.3% | | 1.00 | 1.41 | 16.20 |
| unicode/codepoints/any-all | 4382592 | 271.68 ± 1.2% | not timed | not timed | 259.92 ± 1.7% | 125.89 ± 0.7% | not timed | not timed | 273.08 ± 0.5% | | 0.99 | 1.05 | 2.16 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.68 ± 2.9% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 609.98 ± 0.2% | not timed | not timed | 604.01 ± 0.3% | 153.44 ± 0.7% | not timed | not timed | 610.11 ± 0.2% | | 1.00 | 1.01 | 3.98 |
| unicode/overlapping-words/ascii | 6156 | 30.31 ± 6.9% | not timed | not timed | 43.34 ± 12.6% | 4.40 ± 16.2% | not timed | not timed | 30.43 ± 4.3% | | 1.00 | 0.70 | 6.90 |
| unicode/overlapping-words/english | 6156 | 1.50 ± 0.7% | not timed | not timed | 2.80 ± 7.4% | 2.90 ± 8.8% | not timed | not timed | 1.46 ± 0.3% | | 1.03 | 0.54 | 0.52 |
| unicode/overlapping-words/russian | 5710 | 1.33 ± 17.4% | not timed | not timed | 2.69 ± 1.0% | 6.83 ± 13.0% | not timed | not timed | 1.28 ± 0.3% | | 1.04 | 0.50 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 135.68 ± 1.6% | not timed | not timed | 84.75 ± 0.2% | 13.53 ± 18.9% | not timed | not timed | 134.23 ± 1.8% | | 1.01 | 1.60 | 10.03 |
| unicode/word/boundary-long-english | 3466 | 612.56 ± 0.2% | not timed | not timed | 593.38 ± 0.3% | 35.38 ± 1.0% | not timed | not timed | 612.69 ± 0.6% | | 1.00 | 1.03 | 17.31 |
| unicode/word/around-holmes-english | 27 | 64711.96 ± 0.8% | not timed | not timed | 44978.41 ± 0.5% | 23.74 ± 0.6% | not timed | not timed | 64632.90 ± 0.9% | | 1.00 | 1.44 | 2725.69 |
| wild/bibleref/long | 874 | 566.96 ± 1.9% | not timed | not timed | 573.00 ± 0.6% | 7.86 ± 0.6% | not timed | not timed | 568.30 ± 0.1% | | 1.00 | 0.99 | 72.12 |
| wild/bibleref/short | 30 | 20.19 ± 20.0% | not timed | not timed | 32.69 ± 0.4% | 16.81 ± 14.3% | not timed | not timed | 23.20 ± 5.2% | | 0.87 | 0.62 | 1.20 |
| wild/bibleref/line | 874 | 504.68 ± 2.3% | not timed | not timed | 270.32 ± 13.3% | 10.01 ± 0.4% | not timed | not timed | 511.20 ± 0.4% | | 0.99 | 1.87 | 50.42 |
| wild/caddy/caddy | 6 | 448.11 ± 2.4% | not timed | not timed | 293.23 ± 0.3% | 78.34 ± 14.9% | not timed | not timed | 449.15 ± 6.4% | | 1.00 | 1.53 | 5.72 |
| wild/dot-star-capture/rust-src-tools | 6 | 1456.77 ± 0.3% | not timed | not timed | 405.34 ± 4.4% | 15.84 ± 4.4% | not timed | not timed | 1456.83 ± 0.1% | | 1.00 | 3.59 | 91.98 |
| wild/ruff/noqa | 84 | 507.95 ± 0.6% | not timed | not timed | 510.55 ± 0.4% | 21.00 ± 2.9% | not timed | not timed | 504.76 ± 0.3% | | 1.01 | 0.99 | 24.19 |
| wild/ruff/unnecessary-coding-comment | 16 | 1067.07 ± 1.2% | not timed | not timed | 722.83 ± 0.7% | 132.55 ± 12.2% | not timed | not timed | 1069.16 ± 1.7% | | 1.00 | 1.48 | 8.05 |
| wild/ruff/string-quote-prefix | 2972 | 1564.86 ± 1.8% | not timed | not timed | 454.64 ± 1.8% | 319.98 ± 29.4% | not timed | not timed | 1566.05 ± 1.5% | | 1.00 | 3.44 | 4.89 |
| wild/ruff/space-around-operator | 1224378 | 235.37 ± 2.3% | not timed | not timed | 228.10 ± 0.4% | 19.65 ± 2.5% | not timed | not timed | 235.44 ± 1.6% | | 1.00 | 1.03 | 11.98 |
| wild/ruff/shebang | 282 | 1100.10 ± 0.4% | not timed | not timed | 392.59 ± 0.4% | 108.95 ± 12.1% | not timed | not timed | 1100.03 ± 0.8% | | 1.00 | 2.80 | 10.10 |
| wild/rustsec-cargo-audit/original-unix | 471 | 22607.31 ± 1.3% | not timed | not timed | 23685.94 ± 0.5% | 8953.76 ± 4.2% | not timed | not timed | 22559.52 ± 0.6% | | 1.00 | 0.95 | 2.52 |
| wild/rustsec-cargo-audit/original-windows | 462 | 20502.44 ± 0.3% | not timed | not timed | 22538.82 ± 23.3% | 8468.62 ± 1.8% | not timed | not timed | 20495.11 ± 0.4% | | 1.00 | 0.91 | 2.42 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 22731.52 ± 2.5% | not timed | not timed | 23495.19 ± 0.5% | 8683.83 ± 2.0% | not timed | not timed | 22652.22 ± 1.0% | | 1.00 | 0.97 | 2.62 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 18264.98 ± 3.4% | not timed | not timed | 22953.95 ± 0.2% | 8643.41 ± 23.3% | not timed | not timed | 18219.49 ± 1.9% | | 1.00 | 0.80 | 2.11 |
| wild/url/search | 234965 | 128.96 ± 12.3% | not timed | not timed | 60.82 ± 1.7% | 2.47 ± 1.6% | not timed | not timed | 129.62 ± 12.9% | | 0.99 | 2.12 | 52.23 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 13.4% | not timed | not timed | 0.01 ± 0.7% | 0.01 ± 16.8% | not timed | not timed | 0.03 ± 65.6% | | 0.98 | 2.52 | 4.21 |
| dictionary/compile/english-15 | 1 | 0.34 ± 9.2% | not timed | not timed | 0.09 ± 20.7% | 0.11 ± 20.7% | not timed | not timed | 0.34 ± 2.1% | | 0.98 | 3.68 | 3.05 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.29 ± 11.0% | not timed | not timed | 0.02 ± 15.9% | 36.58 ± 10.0% | not timed | not timed | 0.30 ± 11.7% | | 0.97 | 12.75 | 0.0079 |
| reported/i1095-word-repetition/ascii-compile | 1 | 43.78 ± 3.3% | not timed | not timed | 17.09 ± 0.4% | 64.19 ± 18.0% | not timed | not timed | 44.25 ± 3.9% | | 0.99 | 2.56 | 0.68 |
| reported/i787-keywords/compile | 1 | 39.16 ± 4.0% | not timed | not timed | 2.38 ± 1.1% | 18.68 ± 21.4% | not timed | not timed | 39.66 ± 1.2% | | 0.99 | 16.45 | 2.10 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 354.67 ± 16.7% | not timed | not timed | 145.47 ± 2.4% | 628.69 ± 31.7% | not timed | not timed | 362.63 ± 2.1% | | 0.98 | 2.44 | 0.56 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 52.32 ± 3.9% | not timed | not timed | 5.58 ± 30.6% | 48.58 ± 3.5% | not timed | not timed | 54.41 ± 3.9% | | 0.96 | 9.38 | 1.08 |
| unicode/compile/one-letter | 53 | 7.01 ± 13.6% | not timed | not timed | 5.86 ± 1.3% | 65.29 ± 4.5% | not timed | not timed | 7.06 ± 11.9% | | 0.99 | 1.20 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.20 ± 20.0% | not timed | not timed | 0.13 ± 1.0% | 65.02 ± 13.7% | not timed | not timed | 1.25 ± 5.3% | | 0.96 | 9.42 | 0.0184 |
| unicode/compile/fifty-letters-ascii | 1 | 194.93 ± 10.6% | not timed | not timed | 68.31 ± 0.2% | 218.30 ± 18.3% | not timed | not timed | 200.32 ± 22.7% | | 0.97 | 2.85 | 0.89 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 424.05 ± 4.8% | not timed | not timed | 50.87 ± 0.9% | 743.43 ± 15.6% | not timed | not timed | 430.67 ± 21.1% | | 0.98 | 8.34 | 0.57 |
| unicode/compile/match-every-line-ascii | 4 | 660.04 ± 6.5% | not timed | not timed | 164.61 ± 1.3% | 727.10 ± 19.9% | not timed | not timed | 670.97 ± 8.2% | | 0.98 | 4.01 | 0.91 |
| unicode/compile/negated-class-matches-codepoint | 1 | 339.53 ± 6.4% | not timed | not timed | 55.32 ± 0.1% | 1386.96 ± 9.6% | not timed | not timed | 341.99 ± 4.4% | | 0.99 | 6.14 | 0.24 |
| wild/bibleref/compile | 3 | 6.03 ± 4.7% | not timed | not timed | 2.44 ± 1.6% | 34.27 ± 14.4% | not timed | not timed | 6.24 ± 9.1% | | 0.97 | 2.47 | 0.18 |
| wild/url/compile | 1 | 0.71 ± 16.4% | not timed | not timed | 0.20 ± 1.0% | 0.44 ± 18.9% | not timed | not timed | 0.71 ± 0.7% | | 0.99 | 3.49 | 1.60 |

