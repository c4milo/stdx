# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391540000 |
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
| literal: a word | 217 | 36378.92 ± 0.3% | 4105.30 ± 0.8% | 33.93 ± 1.5% | 32608.31 ± 0.5% | 12777.65 ± 2.6% | 14.87 ± 0.4% | 107.27 ± 0.8% | 36298.44 ± 0.7% | 8.86 | 1.00 | 1.12 | 2.85 |
| literal: a word that is not there | 0 | 42406.38 ± 0.2% | 4020.86 ± 0.5% | 34.05 ± 2.0% | 36228.32 ± 0.4% | 40543.01 ± 0.9% | 14.39 ± 0.5% | 108.60 ± 1.3% | 42363.15 ± 0.4% | 10.55 | 1.00 | 1.17 | 1.05 |
| literal: one of four words | 661 | 13524.33 ± 0.7% | 1971.97 ± 1.5% | 18.80 ± 1.7% | 9741.02 ± 0.7% | 29.17 ± 0.4% | 4.30 ± 0.1% | 7.97 ± 0.9% | 13620.15 ± 1.5% | 6.86 | 0.99 | 1.39 | 463.69 |
| literal: a word in any case | 217 | 30609.72 ± 0.8% | 2103.06 ± 0.3% | 24.66 ± 0.7% | 10051.55 ± 0.3% | 58.57 ± 0.8% | refused | differs | 30686.88 ± 0.2% | 14.55 | 1.00 | 3.05 | 522.66 |
| literal: an href attribute | 33 | 29973.72 ± 0.4% | 648.12 ± 0.1% | 29.56 ± 1.3% | 29302.28 ± 0.3% | 2599.65 ± 7.0% | 10.57 ± 0.2% | 101.42 ± 0.4% | 29950.34 ± 0.3% | 46.25 | 1.00 | 1.02 | 11.53 |
| literal: a word, second text | 123 | 36690.17 ± 2.1% | 3098.82 ± 0.7% | 33.31 ± 1.9% | 32691.40 ± 0.8% | 9136.77 ± 7.7% | 19.33 ± 0.4% | 99.03 ± 1.7% | 36743.17 ± 2.4% | 11.84 | 1.00 | 1.12 | 4.02 |
| class: two capitalized words | 1331 | 983.65 ± 0.2% | 631.11 ± 0.5% | 31.02 ± 1.0% | 611.69 ± 0.2% | 48.79 ± 0.7% | 12.61 ± 0.2% | 79.24 ± 1.2% | 983.63 ± 0.5% | 1.56 | 1.00 | 1.61 | 20.16 |
| class: a word that ends in ing | 3399 | 600.30 ± 0.3% | 599.36 ± 0.8% | 19.90 ± 1.6% | 574.00 ± 0.6% | 34.92 ± 9.8% | 7.14 ± 0.4% | 21.72 ± 0.3% | 601.32 ± 0.5% | 1.00 | 1.00 | 1.05 | 17.19 |
| class: a word in capitals | 2332 | 1330.59 ± 0.9% | 635.81 ± 0.2% | 32.54 ± 1.8% | 600.14 ± 0.4% | 52.27 ± 6.7% | 15.09 ± 1.2% | 95.88 ± 0.8% | 1328.34 ± 0.7% | 2.09 | 1.00 | 2.22 | 25.46 |
| class: a number | 8288 | 2047.93 ± 0.7% | 867.45 ± 0.6% | 32.00 ± 2.9% | 2130.48 ± 0.4% | 50.25 ± 16.4% | 0.42 ± 0.4% | 75.58 ± 0.7% | 2049.32 ± 0.4% | 2.36 | 1.00 | 0.96 | 40.75 |
| class: two capitalized words, second text | 5359 | 532.21 ± 0.2% | 540.64 ± 0.2% | 27.82 ± 1.8% | 503.36 ± 0.2% | 40.11 ± 13.8% | 16.46 ± 0.4% | 72.40 ± 0.6% | 532.18 ± 0.6% | 0.98 | 1.00 | 1.06 | 13.27 |
| other: a word between two words | 6104 | 863.28 ± 0.3% | 614.81 ± 1.2% | 26.99 ± 0.5% | 872.61 ± 0.6% | 128.59 ± 14.3% | 9.60 ± 0.6% | 87.19 ± 0.3% | 864.19 ± 1.0% | 1.40 | 1.00 | 0.99 | 6.71 |
| other: a number before a unit, second text | 1481 | 8816.91 ± 1.6% | 1151.46 ± 0.6% | 31.63 ± 1.3% | 9487.80 ± 1.1% | 48.86 ± 9.1% | 17.31 ± 0.5% | 77.99 ± 1.5% | 8855.40 ± 3.1% | 7.66 | 1.00 | 0.93 | 180.45 |
| other: a heading's start tag | 110 | 21329.46 ± 0.4% | 785.30 ± 0.1% | 32.90 ± 1.2% | 2703.76 ± 0.4% | 1907.98 ± 7.6% | 13.19 ± 0.4% | 114.82 ± 1.1% | 21302.51 ± 0.5% | 27.16 | 1.00 | 7.89 | 11.18 |
| other: a whole word | 217 | 26527.83 ± 0.2% | 638.04 ± 0.2% | 34.44 ± 1.0% | 26191.81 ± 0.4% | 60.25 ± 0.4% | 12.53 ± 0.3% | 63.51 ± 1.1% | 26532.49 ± 0.3% | 41.58 | 1.00 | 1.01 | 440.28 |
| other: a line's first word, second text | 3716 | 2529.24 ± 3.9% | 618.30 ± 0.2% | 35.19 ± 1.2% | 2472.81 ± 0.5% | 80.20 ± 5.5% | refused | refused | 2535.45 ± 0.5% | 4.09 | 1.00 | 1.02 | 31.54 |
| other: fourteen octets before an x | 87 | 36758.87 ± 1.0% | 310.94 ± 0.6% | 7.64 ± 0.3% | 4172.69 ± 0.5% | 11.62 ± 0.7% | differs | 19.96 ± 0.3% | 36781.23 ± 1.6% | 118.22 | 1.00 | 8.81 | 3164.64 |
| other: a Greek word | 21815 | 529.78 ± 0.3% | 410.70 ± 0.5% | 36.77 ± 0.7% | 311.74 ± 0.2% | 53.35 ± 1.7% | differs | refused | 531.24 ± 0.3% | 1.29 | 1.00 | 1.70 | 9.93 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 23.16 ± 0.2% | 23.17 ± 0.3% | 1.10 ± 0.5% | 21.50 ± 0.2% | 3.21 ± 0.4% | differs | 4.83 ± 0.8% | 23.16 ± 0.4% | 1.00 | 1.00 | 1.08 | 7.22 |
| a UUID | 32895 | 25.98 ± 1.1% | 26.06 ± 0.1% | 0.76 ± 0.4% | 16.48 ± 0.4% | 3.22 ± 1.2% | 0.71 ± 0.1% | 3.93 ± 0.4% | 26.06 ± 0.3% | 1.00 | 1.00 | 1.58 | 8.06 |
| an IPv4 address | 33176 | 37.76 ± 0.6% | 37.63 ± 0.2% | 2.41 ± 2.7% | 31.54 ± 0.2% | 8.11 ± 0.4% | differs | 4.63 ± 1.7% | 37.76 ± 0.2% | 1.00 | 1.00 | 1.20 | 4.66 |
| a date and time | 32954 | 37.81 ± 0.6% | 37.86 ± 0.6% | 1.78 ± 0.5% | 23.84 ± 1.2% | 10.21 ± 2.5% | 1.30 ± 0.7% | 8.62 ± 0.3% | 37.81 ± 0.5% | 1.00 | 1.00 | 1.59 | 3.70 |
| a field path | 32606 | 26.23 ± 0.6% | 26.26 ± 0.3% | 1.27 ± 4.0% | 24.79 ± 0.2% | 3.71 ± 0.4% | differs | 3.11 ± 2.6% | 26.23 ± 0.6% | 1.00 | 1.00 | 1.06 | 7.08 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.89 ± 0.7% | 12.87 ± 0.5% | 12.88 ± 0.5% | 14.63 ± 0.9% | 6.75 ± 4.5% | 1.03 ± 0.6% | none | 12.89 ± 0.3% | 1.00 | 1.00 | 0.88 | 1.91 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 292.91 ± 0.7% | 294.38 ± 0.5% | 344.63 ± 0.2% | 117.12 ± 1.7% | 263.63 ± 1.9% | 689.09 ± 2.2% | 3991.52 ± 0.9% | 293.07 ± 0.6% | 1.00 | 1.00 | 2.50 | 1.11 |
| a UUID | 62 | 190.66 ± 0.3% | 191.40 ± 0.8% | 213.23 ± 0.3% | 62.07 ± 1.6% | 119.64 ± 1.6% | 253.01 ± 1.0% | 5539.06 ± 0.8% | 190.90 ± 0.7% | 1.00 | 1.00 | 3.07 | 1.59 |
| an IPv4 address | 29 | 567.97 ± 0.8% | 576.84 ± 0.4% | 797.80 ± 0.4% | 101.35 ± 2.9% | 156.90 ± 1.6% | 427.71 ± 0.3% | 10048.13 ± 1.0% | 568.75 ± 0.3% | 0.98 | 1.00 | 5.60 | 3.62 |
| a date and time | 56 | 422.89 ± 0.5% | 427.41 ± 0.6% | 537.02 ± 0.1% | 96.48 ± 0.5% | 166.60 ± 17.0% | 452.48 ± 1.4% | 5575.98 ± 0.4% | 423.39 ± 0.3% | 0.99 | 1.00 | 4.38 | 2.54 |
| a field path | 39 | 287.41 ± 0.4% | 289.34 ± 0.2% | 337.95 ± 0.3% | 105.75 ± 0.3% | 246.38 ± 12.3% | 712.78 ± 0.9% | 5328.82 ± 1.9% | 287.98 ± 0.5% | 0.99 | 1.00 | 2.72 | 1.17 |
| literal: a word | 7 | 851.16 ± 0.4% | 930.87 ± 0.4% | 1644.15 ± 0.7% | 716.93 ± 1.3% | 816.49 ± 1.8% | 1474.90 ± 2.5% | 31305.49 ± 1.4% | 851.83 ± 0.2% | 0.91 | 1.00 | 1.19 | 1.04 |
| literal: a word that is not there | 8 | 818.26 ± 0.4% | 899.47 ± 0.5% | 1539.41 ± 0.6% | 666.25 ± 0.5% | 777.56 ± 1.2% | 1381.37 ± 2.1% | 30383.85 ± 1.6% | 818.82 ± 0.3% | 0.91 | 1.00 | 1.23 | 1.05 |
| literal: one of four words | 26 | 326.65 ± 0.6% | 546.29 ± 0.6% | 737.28 ± 0.3% | 51.40 ± 1.4% | 304.38 ± 1.9% | 512.99 ± 0.4% | 15171.17 ± 0.7% | 326.69 ± 0.5% | 0.60 | 1.00 | 6.36 | 1.07 |
| literal: a word in any case | 11 | 596.90 ± 0.3% | 643.39 ± 0.9% | 922.42 ± 0.5% | 17.59 ± 0.6% | 858.78 ± 1.4% | refused | 26410.93 ± 2.6% | 596.89 ± 0.6% | 0.93 | 1.00 | 33.94 | 0.70 |
| literal: an href attribute | 12 | 441.92 ± 4.4% | 459.86 ± 0.4% | 595.81 ± 0.6% | 49.77 ± 0.7% | 619.20 ± 18.2% | 1167.37 ± 0.6% | 26031.74 ± 0.8% | 442.50 ± 0.6% | 0.96 | 1.00 | 8.88 | 0.71 |
| literal: a word, second text | 10 | 752.93 ± 0.2% | 846.44 ± 0.5% | 1389.53 ± 0.5% | 596.70 ± 0.8% | 681.69 ± 1.7% | 1197.98 ± 0.6% | 28843.33 ± 2.2% | 752.68 ± 0.4% | 0.89 | 1.00 | 1.26 | 1.10 |
| class: two capitalized words | 23 | 621.90 ± 0.4% | 679.09 ± 0.2% | 1003.16 ± 0.4% | 133.89 ± 0.5% | 632.99 ± 14.9% | 1114.50 ± 0.4% | 6755.25 ± 1.4% | 622.07 ± 0.3% | 0.92 | 1.00 | 4.64 | 0.98 |
| class: a word that ends in ing | 9 | 757.51 ± 3.7% | 880.71 ± 1.2% | 1563.13 ± 0.3% | 171.46 ± 0.3% | 929.74 ± 14.7% | 1718.01 ± 0.5% | 19537.56 ± 2.2% | 761.51 ± 3.7% | 0.86 | 0.99 | 4.42 | 0.81 |
| class: a word in capitals | 16 | 683.93 ± 0.2% | 754.62 ± 0.9% | 1228.91 ± 0.7% | 181.58 ± 2.6% | 932.06 ± 11.9% | 1569.62 ± 3.7% | 8901.86 ± 1.2% | 684.27 ± 0.3% | 0.91 | 1.00 | 3.77 | 0.73 |
| class: a number | 6 | 852.03 ± 0.4% | 962.11 ± 0.5% | 1837.13 ± 0.2% | 44.13 ± 1.0% | 1724.17 ± 1.5% | 3063.21 ± 1.6% | 29639.45 ± 1.4% | 850.63 ± 0.5% | 0.89 | 1.00 | 19.31 | 0.49 |
| class: two capitalized words, second text | 23 | 621.48 ± 0.3% | 679.32 ± 0.4% | 1004.89 ± 0.4% | 134.69 ± 0.5% | 638.82 ± 14.4% | 1124.44 ± 1.2% | 6760.14 ± 0.8% | 621.43 ± 0.3% | 0.91 | 1.00 | 4.61 | 0.97 |
| other: a word between two words | 13 | 738.74 ± 0.5% | 776.58 ± 0.6% | 1227.12 ± 1.1% | 185.57 ± 2.2% | 626.94 ± 1.4% | 1222.68 ± 1.2% | 17293.01 ± 1.2% | 739.59 ± 3.3% | 0.95 | 1.00 | 3.98 | 1.18 |
| other: a number before a unit, second text | 15 | 527.82 ± 0.4% | 592.36 ± 0.3% | 826.12 ± 0.2% | 42.46 ± 0.3% | 768.28 ± 4.3% | 1378.76 ± 0.2% | 18430.99 ± 2.8% | 528.03 ± 0.7% | 0.89 | 1.00 | 12.43 | 0.69 |
| other: a heading's start tag | 13 | 457.70 ± 0.4% | 468.70 ± 0.6% | 603.31 ± 1.4% | 48.34 ± 0.7% | 769.38 ± 12.8% | 1324.27 ± 3.0% | 22150.55 ± 1.2% | 457.54 ± 3.1% | 0.98 | 1.00 | 9.47 | 0.59 |
| other: a whole word | 11 | 761.07 ± 0.6% | 824.24 ± 0.5% | 1324.95 ± 2.9% | 162.21 ± 4.3% | 723.36 ± 9.7% | 1260.19 ± 1.0% | 29643.30 ± 2.4% | 758.78 ± 0.4% | 0.92 | 1.00 | 4.69 | 1.05 |
| other: a line's first word, second text | 17 | 714.03 ± 0.4% | 757.31 ± 0.5% | 1239.34 ± 0.4% | 173.02 ± 0.5% | 873.55 ± 2.1% | refused | refused | 716.38 ± 0.5% | 0.94 | 1.00 | 4.13 | 0.82 |
| other: fourteen octets before an x | 16 | 134.06 ± 0.8% | 186.75 ± 0.3% | 214.26 ± 0.3% | 18.55 ± 0.2% | 552.62 ± 13.2% | 592.13 ± 0.9% | 16143.49 ± 1.4% | 134.26 ± 0.7% | 0.72 | 1.00 | 7.23 | 0.24 |
| other: a Greek word | 8 | 576.70 ± 0.1% | 794.64 ± 0.3% | 1336.99 ± 1.1% | 61.34 ± 0.6% | 1729.08 ± 3.8% | 2905.36 ± 0.4% | refused | 575.00 ± 1.6% | 0.73 | 1.00 | 9.40 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 29455.38 ± 0.5% | not timed | not timed | 28923.54 ± 0.3% | 2732.44 ± 14.1% | not timed | not timed | 29423.44 ± 0.3% | | 1.00 | 1.02 | 10.78 |
| 01-literal/sherlock-casei-en | 522 | 23855.33 ± 4.4% | not timed | not timed | 8490.69 ± 0.2% | 40.20 ± 4.1% | not timed | not timed | 23870.17 ± 2.7% | | 1.00 | 2.81 | 593.48 |
| 01-literal/sherlock-ru | 724 | 29193.13 ± 0.2% | not timed | not timed | 28221.30 ± 0.6% | 1553.02 ± 8.4% | not timed | not timed | 29211.30 ± 0.5% | | 1.00 | 1.03 | 18.80 |
| 01-literal/sherlock-casei-ru | 746 | 10840.68 ± 0.5% | not timed | not timed | 6388.57 ± 1.7% | 42.72 ± 0.4% | not timed | not timed | 10831.24 ± 3.4% | | 1.00 | 1.70 | 253.75 |
| 01-literal/sherlock-zh | 30 | 39520.11 ± 2.5% | not timed | not timed | 35203.08 ± 3.7% | 1599.43 ± 1.5% | not timed | not timed | 39582.73 ± 0.3% | | 1.00 | 1.12 | 24.71 |
| 02-literal-alternate/sherlock-en | 714 | 12411.00 ± 0.9% | not timed | not timed | 9399.66 ± 0.5% | 22.37 ± 3.0% | not timed | not timed | 12362.48 ± 5.2% | | 1.00 | 1.32 | 554.80 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2271.32 ± 1.5% | not timed | not timed | 2307.40 ± 0.6% | 13.62 ± 3.4% | not timed | not timed | 2279.49 ± 1.5% | | 1.00 | 0.98 | 166.81 |
| 02-literal-alternate/sherlock-ru | 899 | 9208.78 ± 0.9% | not timed | not timed | 5148.13 ± 0.5% | 29.01 ± 0.5% | not timed | not timed | 9228.58 ± 0.7% | | 1.00 | 1.79 | 317.48 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2339.08 ± 0.7% | not timed | not timed | 1248.37 ± 0.3% | 11.72 ± 7.6% | not timed | not timed | 2341.68 ± 0.8% | | 1.00 | 1.87 | 199.58 |
| 02-literal-alternate/sherlock-zh | 207 | 16955.98 ± 3.1% | not timed | not timed | 10699.19 ± 0.2% | 41.41 ± 1.3% | not timed | not timed | 16907.33 ± 1.1% | | 1.00 | 1.58 | 409.42 |
| 03-date/ascii | 111817 | 128.08 ± 3.0% | not timed | not timed | 110.19 ± 0.7% | 0.27 ± 2.0% | not timed | not timed | 127.96 ± 0.3% | | 1.00 | 1.16 | 476.97 |
| 04-ruff-noqa/real | 84 | 557.94 ± 0.3% | not timed | not timed | 571.12 ± 0.8% | 25.98 ± 1.7% | not timed | not timed | 557.48 ± 0.6% | | 1.00 | 0.98 | 21.47 |
| 04-ruff-noqa/tweaked | 44 | 659.38 ± 0.6% | not timed | not timed | 560.95 ± 1.4% | 396.05 ± 0.9% | not timed | not timed | 660.06 ± 0.8% | | 1.00 | 1.18 | 1.66 |
| 05-lexer-veryl/single | 124800 | 5.34 ± 0.5% | not timed | not timed | 5.68 ± 4.2% | 0.27 ± 3.7% | not timed | not timed | 5.32 ± 0.7% | | 1.00 | 0.94 | 19.63 |
| 06-cloud-flare-redos/original | 107 | 474.75 ± 0.4% | not timed | not timed | 261.83 ± 0.5% | 32.20 ± 0.9% | not timed | not timed | 474.70 ± 0.4% | | 1.00 | 1.81 | 14.74 |
| 06-cloud-flare-redos/simplified-short | 102 | 420.78 ± 0.4% | not timed | not timed | 267.02 ± 0.3% | 35.16 ± 0.3% | not timed | not timed | 419.90 ± 0.7% | | 1.00 | 1.58 | 11.97 |
| 06-cloud-flare-redos/simplified-long | 10000 | 558.83 ± 0.2% | not timed | not timed | 279.61 ± 2.7% | 37.89 ± 0.7% | not timed | not timed | 558.62 ± 0.2% | | 1.00 | 2.00 | 14.75 |
| 07-unicode-character-data/parse-line | 558784 | 278.27 ± 0.8% | not timed | not timed | 206.15 ± 0.5% | 53.15 ± 8.7% | not timed | not timed | 278.49 ± 1.2% | | 1.00 | 1.35 | 5.24 |
| 08-words/all-english | 56691 | 112.81 ± 2.3% | not timed | not timed | 93.30 ± 0.9% | 15.66 ± 6.9% | not timed | not timed | 113.04 ± 1.7% | | 1.00 | 1.21 | 7.20 |
| 08-words/long-english | 839 | 646.09 ± 0.3% | not timed | not timed | 624.13 ± 0.2% | 38.09 ± 0.5% | not timed | not timed | 647.39 ± 0.3% | | 1.00 | 1.04 | 16.96 |
| 09-aws-keys/full | 0 | 568.38 ± 0.3% | not timed | not timed | 580.07 ± 0.4% | 82.71 ± 3.1% | not timed | not timed | 567.64 ± 0.5% | | 1.00 | 0.98 | 6.87 |
| 09-aws-keys/quick | 0 | 1216.65 ± 1.8% | not timed | not timed | 910.18 ± 2.0% | 455.00 ± 14.4% | not timed | not timed | 1211.55 ± 2.0% | | 1.00 | 1.34 | 2.67 |
| 10-bounded-repeat/letters-en | 1833 | 630.44 ± 5.1% | not timed | not timed | 549.32 ± 0.6% | 24.23 ± 0.3% | not timed | not timed | 635.75 ± 2.4% | | 0.99 | 1.15 | 26.02 |
| 10-bounded-repeat/letters-ru | 3475 | 533.21 ± 3.8% | not timed | not timed | 493.88 ± 0.6% | 24.77 ± 9.9% | not timed | not timed | 537.99 ± 1.0% | | 0.99 | 1.08 | 21.53 |
| 10-bounded-repeat/context | 53 | 95.95 ± 1.7% | not timed | not timed | 73.54 ± 1.6% | 24.13 ± 0.4% | not timed | not timed | 96.36 ± 1.7% | | 1.00 | 1.30 | 3.98 |
| 10-bounded-repeat/capitals | 11 | 666.22 ± 8.2% | not timed | not timed | 638.95 ± 0.8% | 44.55 ± 0.5% | not timed | not timed | 666.39 ± 8.5% | | 1.00 | 1.04 | 14.95 |
| 11-unstructured-to-json/extract | 600 | 53.77 ± 0.5% | not timed | not timed | 80.52 ± 0.1% | 63.40 ± 0.4% | not timed | not timed | 53.64 ± 0.7% | | 1.00 | 0.67 | 0.85 |
| 12-dictionary/single | 1 | 572.54 ± 0.9% | not timed | not timed | 547.26 ± 0.5% | 0.52 ± 0.2% | not timed | not timed | 573.39 ± 0.5% | | 1.00 | 1.05 | 1096.19 |
| 14-quadratic/1x | 100 | 29.69 ± 0.7% | not timed | not timed | 13.44 ± 0.4% | 1.18 ± 1.5% | not timed | not timed | 29.71 ± 0.2% | | 1.00 | 2.21 | 25.27 |
| 14-quadratic/2x | 200 | 22.91 ± 0.6% | not timed | not timed | 6.58 ± 0.2% | 0.66 ± 0.7% | not timed | not timed | 22.92 ± 0.4% | | 1.00 | 3.48 | 34.57 |
| 14-quadratic/10x | 1000 | 7.15 ± 0.6% | not timed | not timed | 1.29 ± 0.4% | 0.15 ± 1.6% | not timed | not timed | 7.15 ± 0.4% | | 1.00 | 5.55 | 47.33 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.7% | not timed | not timed | 0.45 ± 3.7% | 0.66 ± 1.8% | not timed | not timed | 1.54 ± 1.5% | | 1.00 | 3.45 | 2.34 |
| 04-ruff-noqa/compile-real | 1 | 145.33 ± 1.1% | not timed | not timed | 15.77 ± 0.4% | 176.00 ± 0.8% | not timed | not timed | 145.63 ± 0.6% | | 1.00 | 9.22 | 0.83 |
| 05-lexer-veryl/compile-single | 1 | 19.21 ± 0.5% | not timed | not timed | 3.04 ± 0.4% | 7.78 ± 1.2% | not timed | not timed | 19.10 ± 1.3% | | 1.01 | 6.31 | 2.47 |
| 07-unicode-character-data/compile | 1 | 149.79 ± 0.6% | not timed | not timed | 31.91 ± 0.8% | 43.85 ± 1.6% | not timed | not timed | 150.03 ± 1.3% | | 1.00 | 4.69 | 3.42 |
| 09-aws-keys/compile-full | 1 | 64.04 ± 0.7% | not timed | not timed | 9.01 ± 1.0% | 27.95 ± 1.1% | not timed | not timed | 63.63 ± 0.4% | | 1.01 | 7.11 | 2.29 |
| 09-aws-keys/compile-quick | 1 | 230.40 ± 0.6% | not timed | not timed | 60.13 ± 4.2% | 163.59 ± 2.9% | not timed | not timed | 230.61 ± 0.2% | | 1.00 | 3.83 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 64.75 ± 0.7% | not timed | not timed | 14.47 ± 3.6% | 20.37 ± 3.6% | not timed | not timed | 64.17 ± 0.6% | | 1.01 | 4.48 | 3.18 |
| 10-bounded-repeat/compile-capitals | 1 | 95.59 ± 2.6% | not timed | not timed | 10.83 ± 0.9% | 29.33 ± 0.8% | not timed | not timed | 94.23 ± 1.3% | | 1.01 | 8.82 | 3.26 |
| 11-unstructured-to-json/compile | 1 | 224.65 ± 1.3% | not timed | not timed | 49.97 ± 0.7% | 83.23 ± 3.8% | not timed | not timed | 226.54 ± 0.8% | | 0.99 | 4.50 | 2.70 |
| 12-dictionary/compile-single | 1 | 0.37 ± 2.0% | not timed | not timed | 0.08 ± 12.9% | 0.10 ± 20.9% | not timed | not timed | 0.37 ± 2.6% | | 1.00 | 4.61 | 3.55 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.49 ± 3.0% | not timed | not timed | 7.61 ± 1.0% | 0.76 ± 14.0% | not timed | not timed | 7.48 ± 1.8% | | 1.00 | 0.98 | 9.84 |
| dictionary/search/english-10 | 690 | 1.45 ± 0.2% | not timed | not timed | 130.87 ± 0.7% | 0.01 ± 0.2% | not timed | not timed | 1.47 ± 0.6% | | 0.98 | 0.0111 | 218.27 |
| dictionary/search/english-15 | 15 | 571.39 ± 2.2% | not timed | not timed | 545.94 ± 0.3% | 0.50 ± 4.1% | not timed | not timed | 573.21 ± 0.4% | | 1.00 | 1.05 | 1145.78 |
| folly/awyer-inn-busted | 1 | 4388.88 ± 0.2% | not timed | not timed | 134.41 ± 0.5% | 55.83 ± 0.1% | not timed | not timed | 4387.34 ± 2.4% | | 1.00 | 32.65 | 78.61 |
| folly/literal-never-match-rare | 0 | 29369.04 ± 0.3% | not timed | not timed | 28932.42 ± 5.8% | 28815.73 ± 0.4% | not timed | not timed | 29381.81 ± 0.2% | | 1.00 | 1.02 | 1.02 |
| folly/literal-never-match-frequent | 0 | 18186.17 ± 3.7% | not timed | not timed | 28833.09 ± 0.3% | 2570.14 ± 0.4% | not timed | not timed | 18250.94 ± 0.9% | | 1.00 | 0.63 | 7.08 |
| folly/literal-never-match-tricksy | 1 | 3359.57 ± 1.5% | not timed | not timed | 5738.89 ± 1.2% | 1623.05 ± 0.6% | not timed | not timed | 3341.94 ± 1.1% | | 1.01 | 0.59 | 2.07 |
| grep/every-line | 239963 | 1433.87 ± 0.7% | not timed | not timed | 935.47 ± 0.3% | 402.86 ± 17.2% | not timed | not timed | 1435.47 ± 3.4% | | 1.00 | 1.53 | 3.56 |
| grep/long-words-ascii | 5073 | 548.21 ± 0.1% | not timed | not timed | 516.46 ± 0.3% | 53.17 ± 7.2% | not timed | not timed | 547.87 ± 0.3% | | 1.00 | 1.06 | 10.31 |
| imported/leipzig/twain | 811 | 28528.10 ± 1.2% | not timed | not timed | 28100.11 ± 0.9% | 12472.33 ± 9.8% | not timed | not timed | 28525.35 ± 0.7% | | 1.00 | 1.02 | 2.29 |
| imported/leipzig/twain-insensitive | 965 | 13344.78 ± 2.0% | not timed | not timed | 8381.60 ± 1.3% | 53.29 ± 1.5% | not timed | not timed | 13547.50 ± 1.9% | | 0.99 | 1.59 | 250.41 |
| imported/leipzig/shing | 1540 | 659.69 ± 1.7% | not timed | not timed | 17694.41 ± 0.9% | 41.80 ± 1.0% | not timed | not timed | 660.23 ± 0.8% | | 1.00 | 0.0373 | 15.78 |
| imported/leipzig/huck-saw | 262 | 18349.12 ± 6.1% | not timed | not timed | 16114.50 ± 1.0% | 42.25 ± 0.6% | not timed | not timed | 19194.06 ± 5.4% | | 0.96 | 1.14 | 434.30 |
| imported/leipzig/word-ending-nn | 262 | 638.11 ± 0.6% | not timed | not timed | 634.84 ± 2.3% | 30.33 ± 0.5% | not timed | not timed | 638.15 ± 0.5% | | 1.00 | 1.01 | 21.04 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11380.04 ± 1.1% | not timed | not timed | 4302.62 ± 0.4% | 12.52 ± 0.1% | not timed | not timed | 11471.69 ± 1.2% | | 0.99 | 2.64 | 908.68 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 16325.46 ± 4.0% | not timed | not timed | 14861.24 ± 0.3% | 22.68 ± 1.0% | not timed | not timed | 16690.50 ± 3.8% | | 0.98 | 1.10 | 719.67 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5733.19 ± 1.2% | not timed | not timed | 959.63 ± 2.9% | 13.66 ± 0.9% | not timed | not timed | 5789.39 ± 1.7% | | 0.99 | 5.97 | 419.82 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 639.26 ± 0.2% | not timed | not timed | 631.64 ± 1.2% | 14.48 ± 0.8% | not timed | not timed | 639.46 ± 0.2% | | 1.00 | 1.01 | 44.14 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 637.48 ± 0.5% | not timed | not timed | 633.12 ± 0.9% | 12.25 ± 1.2% | not timed | not timed | 638.05 ± 0.6% | | 1.00 | 1.01 | 52.04 |
| imported/leipzig/tom-river | 2 | 11080.71 ± 1.9% | not timed | not timed | 12108.49 ± 0.4% | 39.59 ± 0.7% | not timed | not timed | 11271.31 ± 2.1% | | 0.98 | 0.92 | 279.90 |
| imported/leipzig/ing | 78424 | 626.90 ± 0.6% | not timed | not timed | 592.35 ± 0.5% | 33.47 ± 4.3% | not timed | not timed | 626.52 ± 0.8% | | 1.00 | 1.06 | 18.73 |
| imported/leipzig/ing-whitespace | 55248 | 784.94 ± 0.9% | not timed | not timed | 2307.66 ± 1.4% | 24.30 ± 1.9% | not timed | not timed | 786.70 ± 0.5% | | 1.00 | 0.34 | 32.31 |
| imported/leipzig/awyer-inn | 209 | 799.37 ± 0.9% | not timed | not timed | 7584.21 ± 8.9% | 27.55 ± 2.4% | not timed | not timed | 804.12 ± 0.8% | | 0.99 | 0.11 | 29.01 |
| imported/leipzig/quotes-bounded | 8886 | 1816.53 ± 5.3% | not timed | not timed | 3413.92 ± 0.5% | 44.09 ± 1.0% | not timed | not timed | 1868.15 ± 7.6% | | 0.97 | 0.53 | 41.20 |
| imported/leipzig/non-ascii-alternate | 2 | 24794.69 ± 1.8% | not timed | not timed | 16901.43 ± 1.7% | 63.31 ± 1.0% | not timed | not timed | 24928.57 ± 1.6% | | 0.99 | 1.47 | 391.63 |
| imported/leipzig/math-symbols | 69 | 2197.73 ± 8.3% | not timed | not timed | 635.34 ± 1.2% | 43.89 ± 0.7% | not timed | not timed | 2111.40 ± 11.2% | | 1.04 | 3.46 | 50.08 |
| imported/leipzig/bounded-strings-ending-z | 0 | 632.72 ± 0.6% | not timed | not timed | 635.18 ± 1.3% | 30.35 ± 0.4% | not timed | not timed | 631.78 ± 0.6% | | 1.00 | 1.00 | 20.85 |
| imported/lh3lh3-reb/uri | 17549 | 776.01 ± 8.9% | not timed | not timed | 1052.55 ± 0.4% | 33.56 ± 2.6% | not timed | not timed | 781.19 ± 1.3% | | 0.99 | 0.74 | 23.12 |
| imported/lh3lh3-reb/email | 15057 | 856.61 ± 2.2% | not timed | not timed | 1075.10 ± 0.4% | 37.65 ± 2.9% | not timed | not timed | 855.69 ± 3.0% | | 1.00 | 0.80 | 22.75 |
| imported/lh3lh3-reb/date | 668 | 870.93 ± 1.4% | not timed | not timed | 970.21 ± 0.4% | 60.63 ± 4.7% | not timed | not timed | 870.65 ± 1.9% | | 1.00 | 0.90 | 14.36 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 805.40 ± 3.1% | not timed | not timed | 476.09 ± 0.6% | 19.05 ± 0.9% | not timed | not timed | 803.62 ± 4.7% | | 1.00 | 1.69 | 42.28 |
| imported/mariomka/email | 92 | 737.91 ± 0.4% | not timed | not timed | 26364.77 ± 0.9% | 39.22 ± 2.3% | not timed | not timed | 737.97 ± 0.4% | | 1.00 | 0.0280 | 18.82 |
| imported/mariomka/uri | 5301 | 630.91 ± 1.5% | not timed | not timed | 7280.30 ± 0.3% | 39.16 ± 2.1% | not timed | not timed | 632.39 ± 0.4% | | 1.00 | 0.0867 | 16.11 |
| imported/mariomka/ip | 5 | 1896.90 ± 3.3% | not timed | not timed | 2438.94 ± 0.4% | 26.33 ± 1.7% | not timed | not timed | 1894.16 ± 4.7% | | 1.00 | 0.78 | 72.05 |
| imported/rsc/no-exponential | 0 | 1007.32 ± 1.1% | not timed | not timed | 647.19 ± 0.6% | 30.73 ± 1.0% | not timed | not timed | 1010.82 ± 0.9% | | 1.00 | 1.56 | 32.78 |
| imported/rsc/literal | 1 | 814.25 ± 2.5% | not timed | not timed | 2750.51 ± 0.5% | 253.72 ± 14.0% | not timed | not timed | 824.37 ± 2.7% | | 0.99 | 0.30 | 3.21 |
| imported/rsc/not-literal | 2 | 991.92 ± 0.7% | not timed | not timed | 1420.39 ± 0.8% | 64.44 ± 12.1% | not timed | not timed | 995.49 ± 3.3% | | 1.00 | 0.70 | 15.39 |
| imported/rsc/match-class | 1 | 1777.27 ± 1.5% | not timed | not timed | 2846.38 ± 0.4% | 75.20 ± 8.5% | not timed | not timed | 1778.35 ± 0.4% | | 1.00 | 0.62 | 23.63 |
| imported/rsc/match-class-in-range | 1 | 1778.53 ± 1.4% | not timed | not timed | 4374.35 ± 0.8% | 78.05 ± 9.3% | not timed | not timed | 1779.52 ± 0.1% | | 1.00 | 0.41 | 22.79 |
| imported/rsc/match-class-unicode | 1 | 604.75 ± 2.3% | not timed | not timed | 593.74 ± 0.3% | 82.85 ± 8.6% | not timed | not timed | 604.78 ± 0.4% | | 1.00 | 1.02 | 7.30 |
| imported/rsc/anchored-literal-short-non-match | 0 | 697.61 ± 0.4% | not timed | not timed | 1561.96 ± 0.5% | 418.38 ± 2.6% | not timed | not timed | 699.62 ± 0.8% | | 1.00 | 0.45 | 1.67 |
| imported/rsc/anchored-literal-long-non-match | 0 | 12081.61 ± 0.6% | not timed | not timed | 23403.07 ± 0.6% | 6271.53 ± 2.8% | not timed | not timed | 12071.65 ± 0.5% | | 1.00 | 0.52 | 1.93 |
| imported/rsc/anchored-literal-short-match | 4 | 543.86 ± 2.8% | not timed | not timed | 1012.36 ± 0.8% | 109.81 ± 4.2% | not timed | not timed | 551.37 ± 2.0% | | 0.99 | 0.54 | 4.95 |
| imported/rsc/anchored-literal-long-match | 4 | 2882.95 ± 1.9% | not timed | not timed | 15183.79 ± 0.4% | 1652.92 ± 1.4% | not timed | not timed | 2870.44 ± 2.3% | | 1.00 | 0.19 | 1.74 |
| imported/rsc/one-pass-short | 17 | 497.85 ± 2.9% | not timed | not timed | 484.81 ± 0.5% | 42.40 ± 17.3% | not timed | not timed | 506.26 ± 2.8% | | 0.98 | 1.03 | 11.74 |
| imported/rsc/one-pass-short-not | 17 | 297.54 ± 2.5% | not timed | not timed | 444.64 ± 0.4% | 37.63 ± 13.7% | not timed | not timed | 300.88 ± 0.8% | | 0.99 | 0.67 | 7.91 |
| imported/rsc/one-pass-long-prefix | 26 | 310.83 ± 5.4% | not timed | not timed | 539.86 ± 0.1% | 130.59 ± 16.5% | not timed | not timed | 311.30 ± 1.7% | | 1.00 | 0.58 | 2.38 |
| imported/rsc/one-pass-long-prefix-not | 26 | 499.39 ± 3.0% | not timed | not timed | 548.52 ± 2.0% | 104.30 ± 16.1% | not timed | not timed | 507.77 ± 11.7% | | 0.98 | 0.91 | 4.79 |
| imported/rsc/long-needle1 | 31 | 41939.10 ± 0.5% | not timed | not timed | 37236.40 ± 1.1% | 4.71 ± 1.3% | not timed | not timed | 41959.08 ± 4.0% | | 1.00 | 1.13 | 8899.30 |
| imported/rsc/long-needle2 | 31 | 41725.89 ± 1.4% | not timed | not timed | 257.44 ± 0.7% | 4.75 ± 1.8% | not timed | not timed | 41768.24 ± 1.7% | | 1.00 | 162.08 | 8786.73 |
| imported/rsc/easy0-32 | 26 | 1169.04 ± 3.3% | not timed | not timed | 2622.69 ± 0.7% | 189.28 ± 11.1% | not timed | not timed | 1166.67 ± 3.7% | | 1.00 | 0.45 | 6.18 |
| imported/rsc/easy0-1k | 26 | 25337.89 ± 2.3% | not timed | not timed | 19196.12 ± 0.5% | 3052.71 ± 22.7% | not timed | not timed | 25208.45 ± 2.9% | | 1.01 | 1.32 | 8.30 |
| imported/rsc/easy0-32k | 26 | 54230.38 ± 0.5% | not timed | not timed | 39276.56 ± 0.6% | 27657.60 ± 14.2% | not timed | not timed | 54172.57 ± 1.7% | | 1.00 | 1.38 | 1.96 |
| imported/rsc/easy0-1mb | 26 | 41943.73 ± 1.4% | not timed | not timed | 40058.77 ± 0.8% | 56678.10 ± 11.0% | not timed | not timed | 42020.49 ± 3.7% | | 1.00 | 1.05 | 0.74 |
| imported/rsc/easy1-32 | 19 | 464.71 ± 11.3% | not timed | not timed | 1354.52 ± 1.5% | 182.70 ± 11.3% | not timed | not timed | 470.34 ± 2.5% | | 0.99 | 0.34 | 2.54 |
| imported/rsc/easy1-1k | 19 | 622.15 ± 3.0% | not timed | not timed | 27846.71 ± 0.6% | 3067.32 ± 13.0% | not timed | not timed | 625.42 ± 0.4% | | 0.99 | 0.0223 | 0.20 |
| imported/rsc/easy1-32k | 19 | 634.26 ± 3.3% | not timed | not timed | 864933.78 ± 0.3% | 30023.93 ± 18.3% | not timed | not timed | 635.61 ± 0.2% | | 1.00 | 0.0007 | 0.0211 |
| imported/rsc/easy1-1mb | 19 | 634.97 ± 1.1% | not timed | not timed | 27947856.86 ± 9.8% | 59027.70 ± 5.8% | not timed | not timed | 634.99 ± 1.0% | | 1.00 | 0.0000 | 0.0108 |
| imported/rsc/medium-32 | 27 | 582.41 ± 0.4% | not timed | not timed | 1237.22 ± 0.5% | 93.55 ± 7.4% | not timed | not timed | 582.29 ± 9.9% | | 1.00 | 0.47 | 6.23 |
| imported/rsc/medium-1k | 27 | 9032.90 ± 0.7% | not timed | not timed | 22105.79 ± 1.0% | 97.00 ± 0.6% | not timed | not timed | 9010.81 ± 1.1% | | 1.00 | 0.41 | 93.12 |
| imported/rsc/medium-32k | 27 | 48348.12 ± 5.2% | not timed | not timed | 687578.96 ± 0.5% | 64.28 ± 0.6% | not timed | not timed | 48424.50 ± 1.0% | | 1.00 | 0.0703 | 752.20 |
| imported/rsc/medium-1mb | 27 | 41711.76 ± 4.6% | not timed | not timed | 22130088.13 ± 0.4% | 65.65 ± 1.3% | not timed | not timed | 41800.93 ± 0.8% | | 1.00 | 0.0019 | 635.32 |
| imported/rsc/hard-32 | 58 | 320.78 ± 0.9% | not timed | not timed | 480.22 ± 2.7% | 64.81 ± 9.1% | not timed | not timed | 320.06 ± 1.4% | | 1.00 | 0.67 | 4.95 |
| imported/rsc/hard-1k | 27 | 623.99 ± 0.8% | not timed | not timed | 19440.37 ± 1.3% | 53.07 ± 0.6% | not timed | not timed | 628.59 ± 0.9% | | 0.99 | 0.0321 | 11.76 |
| imported/rsc/hard-32k | 27 | 636.91 ± 1.1% | not timed | not timed | 605672.12 ± 0.2% | 39.22 ± 0.9% | not timed | not timed | 636.01 ± 1.4% | | 1.00 | 0.0011 | 16.24 |
| imported/rsc/hard-1mb | 51 | 635.29 ± 0.3% | not timed | not timed | 8645552.43 ± 0.8% | 39.53 ± 0.6% | not timed | not timed | 636.09 ± 0.7% | | 1.00 | 0.0001 | 16.07 |
| imported/rsc/reallyhard0-32 | 58 | 320.01 ± 0.3% | not timed | not timed | 288.85 ± 0.9% | 64.90 ± 12.4% | not timed | not timed | 319.86 ± 6.4% | | 1.00 | 1.11 | 4.93 |
| imported/rsc/reallyhard0-1k | 27 | 621.80 ± 0.6% | not timed | not timed | 619.70 ± 0.3% | 52.80 ± 5.1% | not timed | not timed | 623.72 ± 0.4% | | 1.00 | 1.00 | 11.78 |
| imported/rsc/reallyhard0-32k | 27 | 633.82 ± 0.8% | not timed | not timed | 635.53 ± 0.4% | 39.17 ± 9.9% | not timed | not timed | 634.53 ± 1.0% | | 1.00 | 1.00 | 16.18 |
| imported/rsc/reallyhard0-1mb | 51 | 627.72 ± 0.7% | not timed | not timed | 636.30 ± 0.4% | 39.34 ± 6.4% | not timed | not timed | 628.14 ± 1.0% | | 1.00 | 0.99 | 15.96 |
| imported/rsc/reallyreallyhard0-32 | 47 | 354.34 ± 7.5% | not timed | not timed | 260.99 ± 0.4% | 75.49 ± 7.1% | not timed | not timed | 353.28 ± 5.3% | | 1.00 | 1.36 | 4.69 |
| imported/rsc/reallyreallyhard0-1k | 16 | 923.89 ± 1.1% | not timed | not timed | 9317.02 ± 2.7% | 41.02 ± 0.7% | not timed | not timed | 926.28 ± 1.5% | | 1.00 | 0.0992 | 22.52 |
| imported/rsc/reallyreallyhard0-32k | 16 | 659.63 ± 5.0% | not timed | not timed | 36808.26 ± 0.4% | 30.30 ± 0.4% | not timed | not timed | 658.35 ± 5.6% | | 1.00 | 0.0179 | 21.77 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 629.83 ± 0.3% | not timed | not timed | 40047.85 ± 10.2% | 30.44 ± 0.5% | not timed | not timed | 629.22 ± 0.7% | | 1.00 | 0.0157 | 20.69 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 344.48 ± 1.0% | not timed | not timed | 245.79 ± 0.7% | 75.78 ± 15.6% | not timed | not timed | 344.59 ± 2.6% | | 1.00 | 1.40 | 4.55 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 894.21 ± 1.2% | not timed | not timed | 8941.40 ± 8.1% | 40.93 ± 8.1% | not timed | not timed | 895.14 ± 1.2% | | 1.00 | 0.10 | 21.85 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 657.56 ± 4.9% | not timed | not timed | 36657.78 ± 0.4% | 30.33 ± 5.4% | not timed | not timed | 658.08 ± 4.7% | | 1.00 | 0.0179 | 21.68 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 628.49 ± 0.8% | not timed | not timed | 35825.36 ± 1.6% | 30.38 ± 3.7% | not timed | not timed | 630.41 ± 0.7% | | 1.00 | 0.0175 | 20.69 |
| imported/sherlock/name-sherlock | 776 | 36042.31 ± 2.0% | not timed | not timed | 33073.91 ± 2.9% | 11952.25 ± 7.7% | not timed | not timed | 36331.96 ± 5.4% | | 0.99 | 1.09 | 3.02 |
| imported/sherlock/name-holmes | 2766 | 23223.82 ± 2.1% | not timed | not timed | 25175.95 ± 0.7% | 4046.56 ± 1.9% | not timed | not timed | 23462.50 ± 2.5% | | 0.99 | 0.92 | 5.74 |
| imported/sherlock/name-sherlock-holmes | 1365 | 36393.28 ± 1.5% | not timed | not timed | 32485.94 ± 0.4% | 10624.23 ± 18.7% | not timed | not timed | 36424.19 ± 2.3% | | 1.00 | 1.12 | 3.43 |
| imported/sherlock/name-sherlock-casei | 816 | 31641.76 ± 0.8% | not timed | not timed | 10145.11 ± 0.8% | 40.02 ± 0.8% | not timed | not timed | 31756.21 ± 0.2% | | 1.00 | 3.12 | 790.70 |
| imported/sherlock/name-holmes-casei | 2802 | 18677.30 ± 3.1% | not timed | not timed | 7038.32 ± 0.5% | 54.03 ± 0.5% | not timed | not timed | 18646.57 ± 3.1% | | 1.00 | 2.65 | 345.69 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 27957.96 ± 1.7% | not timed | not timed | 9919.66 ± 0.6% | 40.14 ± 0.9% | not timed | not timed | 28037.29 ± 1.2% | | 1.00 | 2.82 | 696.56 |
| imported/sherlock/name-whitespace | 1461 | 24093.28 ± 2.3% | not timed | not timed | 26151.52 ± 0.4% | 8040.36 ± 23.3% | not timed | not timed | 24075.82 ± 4.2% | | 1.00 | 0.92 | 3.00 |
| imported/sherlock/name-alt1 | 1142 | 22677.95 ± 2.7% | not timed | not timed | 34873.84 ± 4.9% | 5190.51 ± 21.9% | not timed | not timed | 22672.27 ± 0.2% | | 1.00 | 0.65 | 4.37 |
| imported/sherlock/name-alt2 | 3542 | 14635.96 ± 4.5% | not timed | not timed | 8777.34 ± 0.5% | 41.33 ± 0.5% | not timed | not timed | 14638.10 ± 0.8% | | 1.00 | 1.67 | 354.12 |
| imported/sherlock/name-alt3 | 4507 | 10380.26 ± 1.9% | not timed | not timed | 7892.28 ± 0.7% | 13.09 ± 0.7% | not timed | not timed | 10366.83 ± 1.7% | | 1.00 | 1.32 | 793.06 |
| imported/sherlock/name-alt3-casei | 4593 | 1699.40 ± 0.8% | not timed | not timed | 1372.62 ± 0.7% | 8.25 ± 1.4% | not timed | not timed | 1695.65 ± 0.8% | | 1.00 | 1.24 | 206.07 |
| imported/sherlock/name-alt4 | 3686 | 8888.29 ± 5.8% | not timed | not timed | 8164.58 ± 0.7% | 41.05 ± 0.6% | not timed | not timed | 8897.68 ± 1.1% | | 1.00 | 1.09 | 216.50 |
| imported/sherlock/name-alt4-casei | 4254 | 3695.48 ± 2.8% | not timed | not timed | 3963.85 ± 3.4% | 23.70 ± 4.4% | not timed | not timed | 3698.59 ± 4.2% | | 1.00 | 0.93 | 155.92 |
| imported/sherlock/name-alt5 | 4028 | 12390.44 ± 0.7% | not timed | not timed | 8407.81 ± 1.2% | 28.71 ± 0.9% | not timed | not timed | 12358.61 ± 6.8% | | 1.00 | 1.47 | 431.62 |
| imported/sherlock/name-alt5-casei | 4104 | 5203.85 ± 9.1% | not timed | not timed | 3033.32 ± 1.2% | 17.46 ± 0.9% | not timed | not timed | 5325.18 ± 7.9% | | 0.98 | 1.72 | 298.05 |
| imported/sherlock/no-match-uncommon | 0 | 41480.04 ± 0.2% | not timed | not timed | 36269.43 ± 0.2% | 53063.09 ± 0.2% | not timed | not timed | 41520.56 ± 0.3% | | 1.00 | 1.14 | 0.78 |
| imported/sherlock/no-match-common | 0 | 41136.14 ± 0.2% | not timed | not timed | 36270.33 ± 0.2% | 1994.99 ± 1.6% | not timed | not timed | 41171.82 ± 0.0% | | 1.00 | 1.13 | 20.62 |
| imported/sherlock/no-match-really-common | 0 | 32526.46 ± 2.1% | not timed | not timed | 31367.35 ± 0.9% | 1981.43 ± 1.5% | not timed | not timed | 32421.33 ± 1.4% | | 1.00 | 1.04 | 16.42 |
| imported/sherlock/the-lower | 21654 | 2853.92 ± 2.2% | not timed | not timed | 2436.62 ± 0.5% | 295.16 ± 14.1% | not timed | not timed | 2862.30 ± 2.9% | | 1.00 | 1.17 | 9.67 |
| imported/sherlock/the-upper | 2223 | 17715.67 ± 2.0% | not timed | not timed | 21250.98 ± 1.6% | 3084.91 ± 15.2% | not timed | not timed | 17895.76 ± 2.1% | | 0.99 | 0.83 | 5.74 |
| imported/sherlock/the-casei | 23961 | 2628.37 ± 2.1% | not timed | not timed | 1459.77 ± 0.5% | 48.08 ± 21.4% | not timed | not timed | 2648.97 ± 2.4% | | 0.99 | 1.80 | 54.66 |
| imported/sherlock/everything-greedy | 581881 | 306.39 ± 0.9% | not timed | not timed | 200.84 ± 0.7% | 34.62 ± 32.0% | not timed | not timed | 305.26 ± 1.0% | | 1.00 | 1.53 | 8.85 |
| imported/sherlock/everything-greedy-nl | 594933 | 490.02 ± 0.7% | not timed | not timed | 256.34 ± 1.2% | 39.49 ± 0.8% | not timed | not timed | 489.45 ± 1.1% | | 1.00 | 1.91 | 12.41 |
| imported/sherlock/letters | 447175 | 59.82 ± 1.0% | not timed | not timed | 41.84 ± 2.7% | 5.59 ± 16.3% | not timed | not timed | 59.80 ± 19.4% | | 1.00 | 1.43 | 10.70 |
| imported/sherlock/letters-upper | 14180 | 459.23 ± 1.6% | not timed | not timed | 403.72 ± 0.6% | 33.71 ± 31.3% | not timed | not timed | 460.74 ± 0.5% | | 1.00 | 1.14 | 13.62 |
| imported/sherlock/letters-lower | 432995 | 60.94 ± 2.0% | not timed | not timed | 42.97 ± 0.6% | 6.62 ± 50.3% | not timed | not timed | 60.96 ± 1.2% | | 1.00 | 1.42 | 9.20 |
| imported/sherlock/words | 447639 | 109.48 ± 7.5% | not timed | not timed | 92.78 ± 0.9% | 14.96 ± 9.4% | not timed | not timed | 109.63 ± 6.6% | | 1.00 | 1.18 | 7.32 |
| imported/sherlock/before-holmes | 4073 | 628.53 ± 1.4% | not timed | not timed | 14510.65 ± 0.6% | 27.96 ± 1.4% | not timed | not timed | 629.27 ± 1.5% | | 1.00 | 0.0433 | 22.48 |
| imported/sherlock/before-after-holmes | 2593 | 632.91 ± 1.2% | not timed | not timed | 15795.16 ± 6.9% | 27.87 ± 1.0% | not timed | not timed | 635.78 ± 0.7% | | 1.00 | 0.0401 | 22.71 |
| imported/sherlock/holmes-cochar-watson | 150 | 8102.47 ± 1.5% | not timed | not timed | 7047.79 ± 0.7% | 41.32 ± 1.0% | not timed | not timed | 8160.43 ± 0.9% | | 0.99 | 1.15 | 196.10 |
| imported/sherlock/holmes-coword-watson | 14309 | 1321.19 ± 2.4% | not timed | not timed | 1296.14 ± 1.1% | 8.40 ± 1.4% | not timed | not timed | 1328.08 ± 0.5% | | 0.99 | 1.02 | 157.20 |
| imported/sherlock/quotes | 14437 | 1335.25 ± 0.7% | not timed | not timed | 2048.00 ± 2.6% | 40.56 ± 1.2% | not timed | not timed | 1335.48 ± 1.3% | | 1.00 | 0.65 | 32.92 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 634.67 ± 0.7% | not timed | not timed | 28052.07 ± 1.3% | 47.80 ± 0.5% | not timed | not timed | 633.82 ± 0.6% | | 1.00 | 0.0226 | 13.28 |
| imported/sherlock/word-ending-n | 35297 | 473.68 ± 0.3% | not timed | not timed | 430.49 ± 0.6% | 27.98 ± 0.7% | not timed | not timed | 474.28 ± 0.6% | | 1.00 | 1.10 | 16.93 |
| imported/sherlock/repeated-class-negation | 2130 | 17581.24 ± 3.1% | not timed | not timed | 17960.78 ± 2.4% | 12.56 ± 0.8% | not timed | not timed | 17665.27 ± 1.4% | | 1.00 | 0.98 | 1400.30 |
| imported/sherlock/ing-suffix | 20547 | 574.66 ± 7.5% | not timed | not timed | 541.17 ± 0.2% | 33.74 ± 2.3% | not timed | not timed | 574.84 ± 0.6% | | 1.00 | 1.06 | 17.03 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 619.75 ± 0.2% | not timed | not timed | 2673.25 ± 1.1% | 24.08 ± 1.0% | not timed | not timed | 620.11 ± 0.6% | | 1.00 | 0.23 | 25.73 |
| opt/accelerate/whole-line | 239963 | 555.30 ± 0.8% | not timed | not timed | 436.64 ± 5.0% | 110.48 ± 17.3% | not timed | not timed | 553.75 ± 4.4% | | 1.00 | 1.27 | 5.03 |
| opt/accelerate/non-dna | 16745 | 471.20 ± 0.9% | not timed | not timed | 505.32 ± 0.2% | 38.08 ± 24.1% | not timed | not timed | 469.77 ± 6.7% | | 1.00 | 0.93 | 12.37 |
| opt/backtrack/words-english | 40536 | 149.18 ± 8.5% | not timed | not timed | 124.45 ± 1.0% | 24.20 ± 8.6% | not timed | not timed | 149.96 ± 2.0% | | 0.99 | 1.20 | 6.16 |
| opt/fixed-length/too-small-ascii | 0 | 416.15 ± 1.5% | not timed | not timed | 1028.46 ± 2.6% | 141.33 ± 1.7% | not timed | not timed | 418.16 ± 0.5% | | 1.00 | 0.40 | 2.94 |
| opt/fixed-length/too-big-ascii | 0 | 969.85 ± 0.3% | not timed | not timed | 8407.67 ± 1.1% | 172.01 ± 2.0% | not timed | not timed | 970.54 ± 0.6% | | 1.00 | 0.12 | 5.64 |
| opt/fixed-length/go33484-1 | 0 | 76.77 ± 0.5% | not timed | not timed | 1608369.47 ± 4.9% | 108565.66 ± 1.8% | not timed | not timed | 77.03 ± 0.7% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 4322.34 ± 0.9% | not timed | not timed | 1610332.59 ± 6.6% | 48236.06 ± 0.6% | not timed | not timed | 4312.58 ± 0.6% | | 1.00 | 0.0027 | 0.0896 |
| opt/fixed-length/go33484-3 | 0 | 1735.97 ± 0.7% | not timed | not timed | 162093.50 ± 6.3% | 1103.82 ± 1.1% | not timed | not timed | 1697.87 ± 1.2% | | 1.02 | 0.0107 | 1.57 |
| opt/literal-alt/one-pattern | 1 | 642.41 ± 2.3% | not timed | not timed | 648.17 ± 0.8% | 0.51 ± 3.0% | not timed | not timed | 645.16 ± 1.4% | | 1.00 | 0.99 | 1264.46 |
| opt/onepass/fn-predicate | 916 | 471.40 ± 0.2% | not timed | not timed | 438.25 ± 0.8% | 230.34 ± 13.3% | not timed | not timed | 471.38 ± 9.0% | | 1.00 | 1.08 | 2.05 |
| opt/onepass/first-three-words-english | 35128 | 163.83 ± 10.9% | not timed | not timed | 243.25 ± 0.8% | 95.13 ± 3.7% | not timed | not timed | 163.91 ± 10.1% | | 1.00 | 0.67 | 1.72 |
| opt/prefilter/literal-english | 1 | 41066.08 ± 0.5% | not timed | not timed | 35982.27 ± 1.4% | 24296.32 ± 5.9% | not timed | not timed | 41177.18 ± 0.8% | | 1.00 | 1.14 | 1.69 |
| opt/prefilter/literal-casei-english | 1 | 31304.11 ± 0.8% | not timed | not timed | 11721.51 ± 4.1% | 40.43 ± 1.0% | not timed | not timed | 31185.99 ± 0.5% | | 1.00 | 2.67 | 774.23 |
| opt/prefilter/literal-russian | 1 | 42425.68 ± 0.4% | not timed | not timed | 36001.62 ± 5.2% | 2141.79 ± 3.6% | not timed | not timed | 42229.22 ± 1.4% | | 1.00 | 1.18 | 19.81 |
| opt/prefilter/literal-casei-russian | 1 | 23569.48 ± 1.1% | not timed | not timed | 8914.15 ± 1.0% | 42.20 ± 4.0% | not timed | not timed | 23501.50 ± 0.4% | | 1.00 | 2.64 | 558.49 |
| opt/prefilter/rust-functions | 948 | 12715.24 ± 1.1% | not timed | not timed | 11329.77 ± 0.3% | 2091.54 ± 0.9% | not timed | not timed | 12685.91 ± 0.8% | | 1.00 | 1.12 | 6.08 |
| opt/reverse-anchored/word-end | 1 | 4359.21 ± 0.2% | not timed | not timed | 37382830.62 ± 0.6% | 64.10 ± 0.9% | not timed | not timed | 4363.71 ± 0.6% | | 1.00 | 0.0001 | 68.01 |
| opt/reverse-inner/holmes | 2593 | 631.61 ± 0.4% | not timed | not timed | 15958.05 ± 1.9% | 27.86 ± 0.6% | not timed | not timed | 630.81 ± 0.3% | | 1.00 | 0.0396 | 22.67 |
| opt/reverse-inner/email | 47 | 1075.47 ± 1.2% | not timed | not timed | 29041.93 ± 0.4% | 38.19 ± 0.8% | not timed | not timed | 1077.12 ± 1.1% | | 1.00 | 0.0370 | 28.16 |
| opt/reverse-inner/factored-prefix | 3542 | 621.78 ± 0.4% | not timed | not timed | 619.37 ± 0.6% | 14.95 ± 0.6% | not timed | not timed | 621.44 ± 0.5% | | 1.00 | 1.00 | 41.58 |
| opt/reverse-inner/no-quadratic-backward | 0 | 4308.25 ± 0.8% | not timed | not timed | 635.82 ± 0.8% | 101.21 ± 0.5% | not timed | not timed | 4314.41 ± 0.4% | | 1.00 | 6.78 | 42.57 |
| opt/reverse-inner/no-quadratic-forward | 0 | 730.57 ± 1.5% | not timed | not timed | 293.27 ± 0.3% | 34.78 ± 0.6% | not timed | not timed | 731.29 ± 2.0% | | 1.00 | 2.49 | 21.01 |
| opt/reverse-suffix/holmes | 4073 | 627.91 ± 0.3% | not timed | not timed | 14551.94 ± 1.0% | 27.72 ± 0.5% | not timed | not timed | 628.20 ± 0.4% | | 1.00 | 0.0431 | 22.65 |
| opt/reverse-suffix/no-quadratic | 0 | 4312.76 ± 0.3% | not timed | not timed | 636.11 ± 0.6% | 100.39 ± 1.0% | not timed | not timed | 4308.32 ± 0.3% | | 1.00 | 6.78 | 42.96 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 148.07 ± 4.5% | not timed | not timed | 225.28 ± 1.3% | 17.19 ± 11.5% | not timed | not timed | 152.34 ± 5.4% | | 0.97 | 0.66 | 8.61 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 150.54 ± 3.3% | not timed | not timed | 225.86 ± 1.5% | 18.77 ± 21.5% | not timed | not timed | 149.11 ± 10.4% | | 1.01 | 0.67 | 8.02 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.38 ± 8.3% | not timed | not timed | 0.61 ± 0.6% | 124.52 ± 0.8% | not timed | not timed | 0.38 ± 0.5% | | 1.00 | 0.62 | 0.0030 |
| reported/i1095-word-repetition/ascii-search | 256 | 329.95 ± 0.7% | not timed | not timed | 316.31 ± 0.7% | 119.55 ± 0.3% | not timed | not timed | 329.30 ± 0.7% | | 1.00 | 1.04 | 2.76 |
| reported/i13-subset-regex/original-ascii | 4094 | 11287.53 ± 1.2% | not timed | not timed | 4263.81 ± 4.8% | 12.16 ± 0.5% | not timed | not timed | 11401.22 ± 1.2% | | 0.99 | 2.65 | 928.63 |
| reported/i13-subset-regex/original-unicode | 4094 | 11233.68 ± 2.5% | not timed | not timed | 248.28 ± 1.8% | 12.44 ± 1.7% | not timed | not timed | 11230.42 ± 1.5% | | 1.00 | 45.25 | 903.38 |
| reported/i13-subset-regex/big-ascii | 1955 | 10535.84 ± 1.4% | not timed | not timed | 65.10 ± 2.8% | 10.66 ± 0.6% | not timed | not timed | 10539.50 ± 1.4% | | 1.00 | 161.83 | 988.39 |
| reported/i13-subset-regex/big-unicode | 1955 | 10493.65 ± 1.4% | not timed | not timed | 11.98 ± 55.4% | 10.85 ± 0.4% | not timed | not timed | 10535.39 ± 1.0% | | 1.00 | 875.59 | 967.02 |
| reported/i13-subset-regex/huge-ascii | 55 | 9685.30 ± 2.4% | not timed | not timed | 11.08 ± 0.5% | 10.05 ± 0.4% | not timed | not timed | 9674.18 ± 2.3% | | 1.00 | 873.77 | 963.97 |
| reported/i13-subset-regex/huge-unicode | 55 | 9571.70 ± 2.0% | not timed | not timed | 10.95 ± 0.7% | 10.04 ± 1.4% | not timed | not timed | 9601.70 ± 2.2% | | 1.00 | 873.75 | 953.40 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.37 ± 0.8% | not timed | not timed | 11.28 ± 0.7% | 10.09 ± 1.0% | not timed | not timed | 4.34 ± 0.3% | | 1.01 | 0.39 | 0.43 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 6.21 ± 0.4% | not timed | not timed | 11.37 ± 0.6% | 10.09 ± 0.4% | not timed | not timed | 6.12 ± 0.5% | | 1.02 | 0.55 | 0.62 |
| reported/i787-keywords/ascii | 5674 | 510.37 ± 1.4% | not timed | not timed | 153.21 ± 0.5% | 8.04 ± 0.9% | not timed | not timed | 512.74 ± 0.8% | | 1.00 | 3.33 | 63.49 |
| reported/i787-keywords/opt-ascii | 5674 | 510.63 ± 0.6% | not timed | not timed | 292.61 ± 1.1% | 12.57 ± 28.9% | not timed | not timed | 509.78 ± 2.2% | | 1.00 | 1.75 | 40.61 |
| slow/quadratic-regex-1x | 100 | 9.16 ± 0.3% | not timed | not timed | 6.75 ± 0.3% | 0.06 ± 0.9% | not timed | not timed | 9.17 ± 0.6% | | 1.00 | 1.36 | 142.46 |
| slow/quadratic-regex-2x | 199 | 4.03 ± 0.8% | not timed | not timed | 3.31 ± 0.2% | 0.02 ± 0.6% | not timed | not timed | 4.04 ± 0.7% | | 1.00 | 1.22 | 243.01 |
| slow/quadratic-haystack-1x | 100 | 29.52 ± 1.2% | not timed | not timed | 13.39 ± 0.5% | 1.24 ± 10.6% | not timed | not timed | 29.66 ± 2.4% | | 1.00 | 2.20 | 23.83 |
| slow/quadratic-haystack-2x | 200 | 22.88 ± 0.6% | not timed | not timed | 6.56 ± 0.6% | 0.69 ± 8.5% | not timed | not timed | 22.80 ± 7.5% | | 1.00 | 3.49 | 33.34 |
| unicode/codepoints/any-one | 1112064 | 393.48 ± 1.3% | not timed | not timed | 308.24 ± 0.7% | 17.93 ± 8.6% | not timed | not timed | 394.15 ± 0.4% | | 1.00 | 1.28 | 21.95 |
| unicode/codepoints/any-all | 4382592 | 294.07 ± 0.7% | not timed | not timed | 290.39 ± 0.5% | 144.66 ± 0.9% | not timed | not timed | 293.57 ± 0.6% | | 1.00 | 1.01 | 2.03 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.11 ± 0.3% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 640.35 ± 0.2% | not timed | not timed | 640.19 ± 0.3% | 181.10 ± 1.5% | not timed | not timed | 640.47 ± 0.4% | | 1.00 | 1.00 | 3.54 |
| unicode/overlapping-words/ascii | 6156 | 31.57 ± 0.8% | not timed | not timed | 52.63 ± 0.4% | 4.97 ± 2.5% | not timed | not timed | 31.99 ± 1.8% | | 0.99 | 0.60 | 6.36 |
| unicode/overlapping-words/english | 6156 | 1.59 ± 0.8% | not timed | not timed | 3.86 ± 0.3% | 2.92 ± 0.8% | not timed | not timed | 1.57 ± 3.4% | | 1.01 | 0.41 | 0.54 |
| unicode/overlapping-words/russian | 5710 | 1.43 ± 5.0% | not timed | not timed | 3.39 ± 0.7% | 7.25 ± 10.3% | not timed | not timed | 1.54 ± 0.8% | | 0.93 | 0.42 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 112.98 ± 2.2% | not timed | not timed | 91.06 ± 0.7% | 13.85 ± 16.5% | not timed | not timed | 112.29 ± 2.3% | | 1.01 | 1.24 | 8.16 |
| unicode/word/boundary-long-english | 3466 | 637.61 ± 0.5% | not timed | not timed | 625.70 ± 0.3% | 38.24 ± 0.8% | not timed | not timed | 637.39 ± 0.5% | | 1.00 | 1.02 | 16.67 |
| unicode/word/around-holmes-english | 27 | 636.19 ± 0.6% | not timed | not timed | 35565.13 ± 1.1% | 26.17 ± 0.2% | not timed | not timed | 635.21 ± 0.9% | | 1.00 | 0.0179 | 24.31 |
| wild/bibleref/long | 874 | 596.45 ± 1.2% | not timed | not timed | 607.74 ± 1.9% | 9.45 ± 1.2% | not timed | not timed | 595.54 ± 1.0% | | 1.00 | 0.98 | 63.14 |
| wild/bibleref/short | 30 | 24.17 ± 11.9% | not timed | not timed | 37.77 ± 0.7% | 18.02 ± 11.1% | not timed | not timed | 24.59 ± 9.3% | | 0.98 | 0.64 | 1.34 |
| wild/bibleref/line | 874 | 511.70 ± 2.9% | not timed | not timed | 286.78 ± 4.9% | 10.84 ± 1.9% | not timed | not timed | 512.41 ± 0.4% | | 1.00 | 1.78 | 47.20 |
| wild/caddy/caddy | 6 | 458.88 ± 2.3% | not timed | not timed | 280.49 ± 1.9% | 93.82 ± 9.9% | not timed | not timed | 448.39 ± 9.3% | | 1.02 | 1.64 | 4.89 |
| wild/dot-star-capture/rust-src-tools | 6 | 1522.02 ± 0.4% | not timed | not timed | 351.02 ± 1.1% | 17.56 ± 1.6% | not timed | not timed | 1523.01 ± 0.8% | | 1.00 | 4.34 | 86.70 |
| wild/ruff/noqa | 84 | 555.31 ± 0.8% | not timed | not timed | 566.72 ± 0.6% | 25.73 ± 2.5% | not timed | not timed | 555.36 ± 6.3% | | 1.00 | 0.98 | 21.58 |
| wild/ruff/unnecessary-coding-comment | 16 | 612.05 ± 0.7% | not timed | not timed | 745.54 ± 0.4% | 160.65 ± 13.1% | not timed | not timed | 612.30 ± 1.0% | | 1.00 | 0.82 | 3.81 |
| wild/ruff/string-quote-prefix | 2972 | 560.98 ± 0.9% | not timed | not timed | 529.52 ± 0.9% | 404.99 ± 31.2% | not timed | not timed | 561.52 ± 1.0% | | 1.00 | 1.06 | 1.39 |
| wild/ruff/space-around-operator | 1224378 | 257.34 ± 2.1% | not timed | not timed | 246.78 ± 0.3% | 22.07 ± 1.8% | not timed | not timed | 257.11 ± 2.1% | | 1.00 | 1.04 | 11.66 |
| wild/ruff/shebang | 282 | 553.23 ± 2.7% | not timed | not timed | 435.48 ± 0.4% | 141.61 ± 12.4% | not timed | not timed | 554.70 ± 1.7% | | 1.00 | 1.27 | 3.91 |
| wild/rustsec-cargo-audit/original-unix | 471 | 16201.29 ± 0.3% | not timed | not timed | 18317.24 ± 0.2% | 7795.90 ± 0.9% | not timed | not timed | 16207.97 ± 3.5% | | 1.00 | 0.88 | 2.08 |
| wild/rustsec-cargo-audit/original-windows | 462 | 15351.01 ± 0.4% | not timed | not timed | 17591.46 ± 0.4% | 7283.61 ± 4.5% | not timed | not timed | 15354.73 ± 0.3% | | 1.00 | 0.87 | 2.11 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 16284.54 ± 0.4% | not timed | not timed | 18260.27 ± 4.5% | 7525.58 ± 0.2% | not timed | not timed | 16307.86 ± 0.3% | | 1.00 | 0.89 | 2.16 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 14664.71 ± 3.4% | not timed | not timed | 18059.31 ± 0.1% | 7673.09 ± 19.0% | not timed | not timed | 14657.40 ± 0.3% | | 1.00 | 0.81 | 1.91 |
| wild/url/search | 234965 | 143.51 ± 13.5% | not timed | not timed | 74.97 ± 1.3% | 2.73 ± 1.0% | not timed | not timed | 144.59 ± 13.4% | | 0.99 | 1.91 | 52.53 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 59.8% | not timed | not timed | 0.01 ± 1.9% | 0.01 ± 30.6% | not timed | not timed | 0.03 ± 2.6% | | 0.98 | 3.56 | 3.91 |
| dictionary/compile/english-15 | 1 | 0.37 ± 2.2% | not timed | not timed | 0.09 ± 1.4% | 0.12 ± 20.8% | not timed | not timed | 0.37 ± 1.0% | | 1.00 | 4.35 | 3.16 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.27 ± 9.7% | not timed | not timed | 0.03 ± 1.5% | 40.31 ± 9.6% | not timed | not timed | 0.28 ± 8.1% | | 0.97 | 10.88 | 0.0068 |
| reported/i1095-word-repetition/ascii-compile | 1 | 50.54 ± 5.6% | not timed | not timed | 16.37 ± 0.4% | 68.29 ± 14.8% | not timed | not timed | 50.28 ± 6.8% | | 1.01 | 3.09 | 0.74 |
| reported/i787-keywords/compile | 1 | 44.81 ± 2.2% | not timed | not timed | 2.30 ± 0.4% | 19.49 ± 17.9% | not timed | not timed | 44.92 ± 4.0% | | 1.00 | 19.46 | 2.30 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 447.87 ± 8.5% | not timed | not timed | 166.65 ± 0.3% | 711.26 ± 16.0% | not timed | not timed | 451.56 ± 7.9% | | 0.99 | 2.69 | 0.63 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 60.29 ± 4.1% | not timed | not timed | 5.00 ± 1.0% | 50.79 ± 2.6% | not timed | not timed | 62.27 ± 3.3% | | 0.97 | 12.07 | 1.19 |
| unicode/compile/one-letter | 53 | 7.67 ± 17.1% | not timed | not timed | 6.07 ± 0.4% | 72.09 ± 7.0% | not timed | not timed | 7.68 ± 4.7% | | 1.00 | 1.26 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.18 ± 13.0% | not timed | not timed | 0.13 ± 0.4% | 73.32 ± 17.8% | not timed | not timed | 1.22 ± 6.5% | | 0.96 | 9.07 | 0.0161 |
| unicode/compile/fifty-letters-ascii | 1 | 257.81 ± 3.7% | not timed | not timed | 70.74 ± 0.8% | 251.12 ± 21.3% | not timed | not timed | 261.13 ± 5.9% | | 0.99 | 3.64 | 1.03 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 498.56 ± 11.3% | not timed | not timed | 50.71 ± 1.2% | 838.35 ± 6.2% | not timed | not timed | 511.83 ± 4.1% | | 0.97 | 9.83 | 0.59 |
| unicode/compile/match-every-line-ascii | 4 | 854.20 ± 3.6% | not timed | not timed | 195.40 ± 0.7% | 827.08 ± 13.0% | not timed | not timed | 849.73 ± 13.7% | | 1.01 | 4.37 | 1.03 |
| unicode/compile/negated-class-matches-codepoint | 1 | 425.16 ± 3.9% | not timed | not timed | 52.96 ± 0.8% | 1566.04 ± 8.2% | not timed | not timed | 428.73 ± 4.6% | | 0.99 | 8.03 | 0.27 |
| wild/bibleref/compile | 3 | 6.72 ± 3.3% | not timed | not timed | 2.40 ± 0.7% | 37.30 ± 3.2% | not timed | not timed | 6.74 ± 3.3% | | 1.00 | 2.80 | 0.18 |
| wild/url/compile | 1 | 0.80 ± 1.1% | not timed | not timed | 0.19 ± 0.8% | 0.48 ± 21.9% | not timed | not timed | 0.81 ± 11.3% | | 1.00 | 4.31 | 1.68 |

