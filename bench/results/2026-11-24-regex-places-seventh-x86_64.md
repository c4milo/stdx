# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507003840 |
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
| literal: a word | 217 | 48946.78 ± 0.4% | 3995.64 ± 0.3% | 30.81 ± 1.5% | 38114.57 ± 15.3% | 12331.48 ± 5.0% | 12.75 ± 2.2% | 103.41 ± 1.0% | 48996.18 ± 1.7% | 12.25 | 1.00 | 1.28 | 3.97 |
| literal: a word that is not there | 0 | 64315.81 ± 0.4% | 3890.64 ± 0.6% | 31.20 ± 0.4% | 45750.17 ± 0.2% | 43846.70 ± 3.3% | 12.42 ± 0.2% | 98.44 ± 1.4% | 64358.94 ± 0.4% | 16.53 | 1.00 | 1.41 | 1.47 |
| literal: one of four words | 661 | 16869.48 ± 0.5% | 1694.36 ± 1.2% | 16.89 ± 0.4% | 11168.50 ± 0.2% | 24.89 ± 0.5% | 4.45 ± 0.1% | 8.66 ± 0.1% | 16865.11 ± 0.4% | 9.96 | 1.00 | 1.51 | 677.80 |
| literal: a word in any case | 217 | 42633.64 ± 0.8% | 1809.09 ± 0.3% | 24.06 ± 0.4% | 11361.13 ± 0.1% | 46.89 ± 8.3% | refused | differs | 42917.86 ± 2.8% | 23.57 | 0.99 | 3.75 | 909.26 |
| literal: an href attribute | 33 | 41247.12 ± 0.5% | 615.77 ± 0.2% | 29.77 ± 0.1% | 34966.90 ± 1.3% | 2981.99 ± 3.4% | 9.56 ± 0.5% | 91.52 ± 5.4% | 41215.66 ± 0.5% | 66.98 | 1.00 | 1.18 | 13.83 |
| literal: a word, second text | 123 | 49802.09 ± 1.1% | 3135.22 ± 1.1% | 30.84 ± 1.2% | 39615.87 ± 0.6% | 10639.86 ± 8.4% | 14.50 ± 0.2% | 87.98 ± 1.0% | 49901.97 ± 0.4% | 15.88 | 1.00 | 1.26 | 4.68 |
| class: two capitalized words | 1331 | 925.42 ± 3.1% | 611.60 ± 1.4% | 28.84 ± 1.7% | 575.35 ± 0.7% | 44.19 ± 0.4% | 10.78 ± 0.4% | 79.72 ± 5.6% | 925.63 ± 0.2% | 1.51 | 1.00 | 1.61 | 20.94 |
| class: a word that ends in ing | 3399 | 584.21 ± 0.4% | 585.61 ± 0.2% | 19.92 ± 0.2% | 539.20 ± 0.6% | 32.87 ± 6.9% | 6.19 ± 0.2% | 20.59 ± 1.7% | 584.92 ± 0.5% | 1.00 | 1.00 | 1.08 | 17.78 |
| class: a word in capitals | 2332 | 1161.75 ± 0.6% | 617.73 ± 0.3% | 30.43 ± 2.4% | 564.73 ± 0.4% | 47.06 ± 16.3% | 12.43 ± 0.3% | 102.33 ± 0.5% | 1160.23 ± 0.6% | 1.88 | 1.00 | 2.06 | 24.68 |
| class: a number | 8288 | 2035.06 ± 0.6% | 858.18 ± 0.4% | 29.91 ± 0.3% | 1813.05 ± 0.2% | 47.88 ± 9.9% | 0.38 ± 0.5% | 73.33 ± 0.3% | 2018.77 ± 0.8% | 2.37 | 1.01 | 1.12 | 42.50 |
| class: two capitalized words, second text | 5359 | 522.78 ± 0.2% | 530.40 ± 0.2% | 26.06 ± 0.2% | 478.01 ± 0.2% | 38.99 ± 7.8% | 12.78 ± 0.2% | 74.00 ± 0.2% | 522.89 ± 1.0% | 0.99 | 1.00 | 1.09 | 13.41 |
| other: a word between two words | 6104 | 925.88 ± 0.5% | 606.83 ± 0.2% | 25.99 ± 0.3% | 814.90 ± 0.5% | 130.87 ± 13.1% | 8.48 ± 0.2% | 82.48 ± 0.2% | 908.11 ± 4.4% | 1.53 | 1.02 | 1.14 | 7.07 |
| other: a number before a unit, second text | 1481 | 11196.02 ± 1.0% | 1070.00 ± 0.5% | 28.78 ± 0.4% | 8266.35 ± 0.4% | 45.15 ± 12.3% | 13.34 ± 0.6% | 77.72 ± 0.3% | 11178.30 ± 0.7% | 10.46 | 1.00 | 1.35 | 248.00 |
| other: a heading's start tag | 110 | 26282.90 ± 0.4% | 747.95 ± 0.1% | 30.49 ± 0.8% | 2500.85 ± 1.6% | 2014.05 ± 2.0% | 11.70 ± 0.4% | 107.43 ± 0.5% | 26230.67 ± 0.5% | 35.14 | 1.00 | 10.51 | 13.05 |
| other: a whole word | 217 | 34204.50 ± 0.3% | 608.07 ± 0.4% | 31.27 ± 0.3% | 27862.54 ± 9.3% | 53.80 ± 11.0% | 11.07 ± 0.5% | 63.31 ± 0.2% | 34444.61 ± 1.9% | 56.25 | 0.99 | 1.23 | 635.79 |
| other: a line's first word, second text | 3716 | 2784.35 ± 6.2% | 600.52 ± 0.2% | 35.15 ± 1.3% | 2333.36 ± 2.3% | 71.64 ± 3.8% | refused | refused | 2787.82 ± 1.9% | 4.64 | 1.00 | 1.19 | 38.87 |
| other: fourteen octets before an x | 87 | 38069.43 ± 0.6% | 249.32 ± 0.5% | 7.61 ± 0.6% | 3475.24 ± 0.3% | 11.53 ± 1.9% | differs | 21.41 ± 1.4% | 38639.76 ± 2.0% | 152.69 | 0.99 | 10.95 | 3300.49 |
| other: a Greek word | 21815 | 516.15 ± 0.2% | 441.62 ± 0.1% | 34.24 ± 0.3% | 302.19 ± 0.2% | 58.20 ± 10.2% | differs | refused | 519.25 ± 1.1% | 1.17 | 0.99 | 1.71 | 8.87 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 31.47 ± 1.5% | 31.41 ± 0.2% | 1.00 ± 1.5% | 19.85 ± 1.0% | 2.66 ± 0.5% | differs | 4.33 ± 1.2% | 31.34 ± 12.1% | 1.00 | 1.00 | 1.59 | 11.84 |
| a UUID | 32895 | 27.45 ± 1.0% | 27.47 ± 1.2% | 0.69 ± 2.2% | 15.11 ± 0.1% | 3.00 ± 8.0% | 0.52 ± 2.3% | 3.80 ± 13.5% | 27.24 ± 6.5% | 1.00 | 1.01 | 1.82 | 9.16 |
| an IPv4 address | 33176 | 40.40 ± 1.4% | 40.72 ± 0.1% | 2.24 ± 1.4% | 28.48 ± 2.7% | 6.75 ± 2.0% | differs | 3.92 ± 1.2% | 40.41 ± 0.8% | 0.99 | 1.00 | 1.42 | 5.98 |
| a date and time | 32954 | 37.92 ± 4.3% | 37.96 ± 0.7% | 1.67 ± 1.7% | 21.70 ± 0.3% | 8.13 ± 1.6% | 0.90 ± 2.3% | 8.04 ± 9.2% | 37.86 ± 1.3% | 1.00 | 1.00 | 1.75 | 4.67 |
| a field path | 32606 | 34.27 ± 0.4% | 34.15 ± 0.8% | 1.05 ± 1.3% | 23.02 ± 1.8% | 3.44 ± 4.5% | differs | 3.08 ± 2.6% | 34.31 ± 0.8% | 1.00 | 1.00 | 1.49 | 9.97 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.88 ± 0.4% | 10.71 ± 0.4% | 10.90 ± 10.3% | 13.46 ± 0.9% | 5.89 ± 2.2% | 0.75 ± 0.5% | none | 10.87 ± 0.5% | 1.02 | 1.00 | 0.81 | 1.85 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 251.37 ± 0.9% | 251.62 ± 0.8% | 293.20 ± 0.1% | 101.65 ± 1.6% | 242.71 ± 4.8% | 704.90 ± 12.2% | 4637.83 ± 3.2% | 251.53 ± 0.4% | 1.00 | 1.00 | 2.47 | 1.04 |
| a UUID | 62 | 160.45 ± 0.2% | 160.70 ± 0.3% | 178.66 ± 0.4% | 58.05 ± 4.9% | 118.40 ± 7.7% | 255.99 ± 0.6% | 4983.63 ± 15.8% | 160.67 ± 0.1% | 1.00 | 1.00 | 2.76 | 1.36 |
| an IPv4 address | 29 | 447.32 ± 0.5% | 446.71 ± 0.3% | 603.90 ± 1.6% | 88.64 ± 0.9% | 149.36 ± 1.0% | 411.67 ± 1.0% | 7831.00 ± 1.4% | 447.44 ± 0.7% | 1.00 | 1.00 | 5.05 | 2.99 |
| a date and time | 56 | 326.18 ± 9.6% | 326.38 ± 0.3% | 401.73 ± 1.1% | 86.28 ± 1.1% | 159.92 ± 4.4% | 471.76 ± 2.2% | 5184.33 ± 0.7% | 326.52 ± 0.3% | 1.00 | 1.00 | 3.78 | 2.04 |
| a field path | 39 | 245.70 ± 0.1% | 246.11 ± 0.1% | 285.78 ± 0.2% | 92.63 ± 1.9% | 225.42 ± 16.2% | 748.65 ± 11.5% | 4974.26 ± 3.4% | 245.73 ± 0.2% | 1.00 | 1.00 | 2.65 | 1.09 |
| literal: a word | 7 | 734.88 ± 0.7% | 785.94 ± 0.2% | 1378.60 ± 0.4% | 635.22 ± 1.4% | 785.46 ± 1.2% | 1652.03 ± 0.6% | 34822.02 ± 1.0% | 735.46 ± 0.3% | 0.94 | 1.00 | 1.16 | 0.94 |
| literal: a word that is not there | 8 | 704.82 ± 0.4% | 757.96 ± 0.2% | 1310.25 ± 13.8% | 590.15 ± 4.2% | 754.24 ± 3.5% | 1549.80 ± 0.8% | 34168.00 ± 0.4% | 705.05 ± 5.0% | 0.93 | 1.00 | 1.19 | 0.93 |
| literal: one of four words | 26 | 270.74 ± 1.0% | 452.13 ± 9.6% | 608.24 ± 1.0% | 53.24 ± 0.4% | 288.62 ± 18.3% | 583.95 ± 9.9% | 17712.54 ± 3.8% | 271.15 ± 0.5% | 0.60 | 1.00 | 5.09 | 0.94 |
| literal: a word in any case | 11 | 501.32 ± 0.7% | 532.67 ± 0.3% | 758.86 ± 0.4% | 18.76 ± 1.5% | 814.58 ± 0.9% | refused | 20729.56 ± 7.0% | 503.72 ± 0.4% | 0.94 | 1.00 | 26.72 | 0.62 |
| literal: an href attribute | 12 | 406.36 ± 0.5% | 419.95 ± 0.2% | 550.79 ± 0.3% | 49.96 ± 1.0% | 566.58 ± 1.7% | 1267.34 ± 0.8% | 20636.59 ± 1.3% | 406.83 ± 0.4% | 0.97 | 1.00 | 8.13 | 0.72 |
| literal: a word, second text | 10 | 652.99 ± 14.4% | 713.62 ± 0.3% | 1175.56 ± 0.2% | 526.58 ± 1.0% | 649.86 ± 1.5% | 1338.23 ± 0.3% | 32344.08 ± 0.7% | 655.24 ± 0.4% | 0.92 | 1.00 | 1.24 | 1.00 |
| class: two capitalized words | 23 | 514.04 ± 0.9% | 550.07 ± 1.9% | 790.66 ± 0.3% | 126.50 ± 9.9% | 597.46 ± 1.7% | 1284.21 ± 15.6% | 8100.23 ± 0.4% | 514.71 ± 0.2% | 0.93 | 1.00 | 4.06 | 0.86 |
| class: a word that ends in ing | 9 | 635.45 ± 0.6% | 726.51 ± 0.2% | 1239.60 ± 0.3% | 153.17 ± 0.8% | 857.75 ± 1.1% | 1840.09 ± 0.4% | 19049.18 ± 0.5% | 637.01 ± 0.2% | 0.87 | 1.00 | 4.15 | 0.74 |
| class: a word in capitals | 16 | 570.47 ± 0.4% | 617.84 ± 0.7% | 976.77 ± 0.6% | 158.91 ± 1.0% | 886.64 ± 13.0% | 1709.51 ± 1.7% | 10274.95 ± 0.6% | 570.68 ± 0.7% | 0.92 | 1.00 | 3.59 | 0.64 |
| class: a number | 6 | 716.28 ± 0.3% | 790.61 ± 0.4% | 1458.90 ± 0.2% | 47.06 ± 0.6% | 1613.87 ± 2.5% | 2956.43 ± 2.6% | 23859.32 ± 0.4% | 717.04 ± 0.2% | 0.91 | 1.00 | 15.22 | 0.44 |
| class: two capitalized words, second text | 23 | 513.67 ± 0.5% | 550.31 ± 10.9% | 791.76 ± 0.2% | 124.70 ± 1.3% | 593.96 ± 2.7% | 1267.16 ± 1.8% | 8087.91 ± 0.8% | 514.46 ± 1.3% | 0.93 | 1.00 | 4.12 | 0.86 |
| other: a word between two words | 13 | 626.91 ± 0.3% | 653.55 ± 0.1% | 1008.93 ± 3.0% | 159.97 ± 7.2% | 575.75 ± 6.7% | 1351.20 ± 8.5% | 17720.79 ± 1.4% | 627.85 ± 0.6% | 0.96 | 1.00 | 3.92 | 1.09 |
| other: a number before a unit, second text | 15 | 457.87 ± 0.4% | 510.16 ± 0.2% | 708.86 ± 0.2% | 43.74 ± 0.7% | 715.40 ± 2.4% | 1455.87 ± 3.6% | 13019.74 ± 2.4% | 457.89 ± 0.1% | 0.90 | 1.00 | 10.47 | 0.64 |
| other: a heading's start tag | 13 | 415.11 ± 0.2% | 423.54 ± 0.9% | 559.74 ± 1.9% | 49.08 ± 0.8% | 701.87 ± 0.6% | 1397.87 ± 1.1% | 14585.73 ± 1.8% | 415.13 ± 0.1% | 0.98 | 1.00 | 8.46 | 0.59 |
| other: a whole word | 11 | 645.01 ± 1.5% | 686.62 ± 0.9% | 1107.58 ± 0.3% | 143.41 ± 0.6% | 670.91 ± 7.9% | 1347.90 ± 3.0% | 17211.23 ± 2.1% | 645.58 ± 1.0% | 0.94 | 1.00 | 4.50 | 0.96 |
| other: a line's first word, second text | 17 | 602.51 ± 0.3% | 637.18 ± 4.4% | 1002.40 ± 9.2% | 148.65 ± 0.5% | 799.89 ± 0.9% | refused | refused | 603.53 ± 8.3% | 0.95 | 1.00 | 4.05 | 0.75 |
| other: fourteen octets before an x | 16 | 116.93 ± 3.0% | 175.49 ± 16.0% | 205.86 ± 0.8% | 18.23 ± 0.9% | 503.90 ± 5.0% | 573.92 ± 0.7% | 15844.78 ± 0.4% | 116.70 ± 7.0% | 0.67 | 1.00 | 6.42 | 0.23 |
| other: a Greek word | 8 | 478.21 ± 0.8% | 675.35 ± 0.1% | 1116.17 ± 1.1% | 63.50 ± 0.2% | 1588.44 ± 1.9% | 2846.11 ± 0.5% | refused | 478.64 ± 0.1% | 0.71 | 1.00 | 7.53 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 36952.64 ± 0.4% | not timed | not timed | 33544.20 ± 0.3% | 2906.54 ± 3.5% | not timed | not timed | 36945.22 ± 0.3% | | 1.00 | 1.10 | 12.71 |
| 01-literal/sherlock-casei-en | 522 | 29474.59 ± 0.4% | not timed | not timed | 9019.04 ± 0.2% | 33.95 ± 1.0% | not timed | not timed | 29329.05 ± 0.3% | | 1.00 | 3.27 | 868.24 |
| 01-literal/sherlock-ru | 724 | 38613.27 ± 0.6% | not timed | not timed | 34393.27 ± 0.3% | 1295.01 ± 4.8% | not timed | not timed | 38671.94 ± 0.3% | | 1.00 | 1.12 | 29.82 |
| 01-literal/sherlock-casei-ru | 746 | 12365.53 ± 0.9% | not timed | not timed | 7756.53 ± 0.7% | 37.70 ± 0.6% | not timed | not timed | 12385.85 ± 0.3% | | 1.00 | 1.59 | 328.03 |
| 01-literal/sherlock-zh | 30 | 61076.33 ± 0.6% | not timed | not timed | 42765.85 ± 1.1% | 1633.18 ± 3.8% | not timed | not timed | 61013.69 ± 0.8% | | 1.00 | 1.43 | 37.40 |
| 02-literal-alternate/sherlock-en | 714 | 15649.52 ± 0.2% | not timed | not timed | 10887.45 ± 0.2% | 19.12 ± 0.6% | not timed | not timed | 15572.36 ± 2.2% | | 1.00 | 1.44 | 818.70 |
| 02-literal-alternate/sherlock-casei-en | 725 | 5106.19 ± 5.8% | not timed | not timed | 2300.66 ± 0.3% | 12.32 ± 0.7% | not timed | not timed | 5124.51 ± 5.5% | | 1.00 | 2.22 | 414.53 |
| 02-literal-alternate/sherlock-ru | 899 | 10772.38 ± 0.7% | not timed | not timed | 9738.81 ± 8.8% | 25.42 ± 0.4% | not timed | not timed | 10777.89 ± 0.6% | | 1.00 | 1.11 | 423.79 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2543.30 ± 3.0% | not timed | not timed | 1196.34 ± 4.3% | 10.60 ± 8.3% | not timed | not timed | 2535.52 ± 3.4% | | 1.00 | 2.13 | 239.86 |
| 02-literal-alternate/sherlock-zh | 207 | 20761.67 ± 0.4% | not timed | not timed | 12425.82 ± 4.0% | 35.77 ± 16.0% | not timed | not timed | 20759.40 ± 7.5% | | 1.00 | 1.67 | 580.47 |
| 03-date/ascii | 111817 | 147.79 ± 1.5% | not timed | not timed | 100.62 ± 0.7% | 0.23 ± 4.3% | not timed | not timed | 148.04 ± 1.7% | | 1.00 | 1.47 | 640.65 |
| 04-ruff-noqa/real | 84 | 512.27 ± 0.4% | not timed | not timed | 507.31 ± 7.3% | 17.15 ± 19.8% | not timed | not timed | 508.86 ± 0.2% | | 1.01 | 1.01 | 29.88 |
| 04-ruff-noqa/tweaked | 44 | 651.98 ± 1.0% | not timed | not timed | 509.15 ± 0.7% | 367.62 ± 0.7% | not timed | not timed | 653.87 ± 0.4% | | 1.00 | 1.28 | 1.77 |
| 05-lexer-veryl/single | 124800 | 4.80 ± 7.1% | not timed | not timed | 5.41 ± 0.7% | 0.26 ± 2.1% | not timed | not timed | 4.87 ± 6.4% | | 0.99 | 0.89 | 18.41 |
| 06-cloud-flare-redos/original | 107 | 430.81 ± 6.4% | not timed | not timed | 227.16 ± 0.4% | 25.44 ± 6.3% | not timed | not timed | 431.81 ± 0.1% | | 1.00 | 1.90 | 16.93 |
| 06-cloud-flare-redos/simplified-short | 102 | 420.70 ± 1.7% | not timed | not timed | 237.00 ± 0.7% | 27.32 ± 1.0% | not timed | not timed | 419.43 ± 0.9% | | 1.00 | 1.78 | 15.40 |
| 06-cloud-flare-redos/simplified-long | 10000 | 531.07 ± 0.2% | not timed | not timed | 259.27 ± 0.8% | 29.51 ± 0.6% | not timed | not timed | 529.91 ± 0.7% | | 1.00 | 2.05 | 18.00 |
| 07-unicode-character-data/parse-line | 558784 | 250.67 ± 1.4% | not timed | not timed | 198.43 ± 0.2% | 48.09 ± 5.9% | not timed | not timed | 249.91 ± 1.0% | | 1.00 | 1.26 | 5.21 |
| 08-words/all-english | 56691 | 134.43 ± 0.6% | not timed | not timed | 84.74 ± 0.9% | 15.13 ± 8.0% | not timed | not timed | 134.95 ± 1.1% | | 1.00 | 1.59 | 8.89 |
| 08-words/long-english | 839 | 619.11 ± 0.7% | not timed | not timed | 584.66 ± 0.3% | 35.21 ± 0.7% | not timed | not timed | 619.33 ± 0.3% | | 1.00 | 1.06 | 17.58 |
| 09-aws-keys/full | 0 | 520.27 ± 0.2% | not timed | not timed | 538.62 ± 0.2% | 57.16 ± 3.7% | not timed | not timed | 521.76 ± 0.3% | | 1.00 | 0.97 | 9.10 |
| 09-aws-keys/quick | 0 | 1153.55 ± 0.3% | not timed | not timed | 959.64 ± 0.8% | 379.85 ± 0.4% | not timed | not timed | 1148.56 ± 9.7% | | 1.00 | 1.20 | 3.04 |
| 10-bounded-repeat/letters-en | 1833 | 681.03 ± 0.7% | not timed | not timed | 555.11 ± 0.4% | 22.98 ± 1.5% | not timed | not timed | 680.12 ± 1.2% | | 1.00 | 1.23 | 29.63 |
| 10-bounded-repeat/letters-ru | 3475 | 525.77 ± 1.2% | not timed | not timed | 481.37 ± 0.1% | 25.18 ± 11.0% | not timed | not timed | 527.41 ± 0.9% | | 1.00 | 1.09 | 20.88 |
| 10-bounded-repeat/context | 53 | 90.54 ± 1.7% | not timed | not timed | 71.05 ± 0.7% | 22.58 ± 0.2% | not timed | not timed | 90.49 ± 1.4% | | 1.00 | 1.27 | 4.01 |
| 10-bounded-repeat/capitals | 11 | 637.32 ± 8.0% | not timed | not timed | 604.53 ± 0.4% | 40.26 ± 0.7% | not timed | not timed | 638.56 ± 8.2% | | 1.00 | 1.05 | 15.83 |
| 11-unstructured-to-json/extract | 600 | 51.61 ± 15.0% | not timed | not timed | 78.16 ± 0.7% | 30.76 ± 29.7% | not timed | not timed | 51.71 ± 8.6% | | 1.00 | 0.66 | 1.68 |
| 12-dictionary/single | 1 | 514.88 ± 0.8% | not timed | not timed | 481.40 ± 0.8% | 0.40 ± 3.7% | not timed | not timed | 514.04 ± 0.8% | | 1.00 | 1.07 | 1301.79 |
| 14-quadratic/1x | 100 | 26.14 ± 0.9% | not timed | not timed | 12.18 ± 0.5% | 0.99 ± 4.3% | not timed | not timed | 26.17 ± 1.5% | | 1.00 | 2.15 | 26.45 |
| 14-quadratic/2x | 200 | 19.87 ± 0.9% | not timed | not timed | 6.13 ± 0.7% | 0.54 ± 2.9% | not timed | not timed | 19.72 ± 1.4% | | 1.01 | 3.24 | 36.64 |
| 14-quadratic/10x | 1000 | 6.85 ± 1.1% | not timed | not timed | 1.22 ± 0.3% | 0.12 ± 1.3% | not timed | not timed | 6.83 ± 1.4% | | 1.00 | 5.63 | 58.90 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.38 ± 0.5% | not timed | not timed | 0.48 ± 0.6% | 0.64 ± 1.9% | not timed | not timed | 1.38 ± 0.4% | | 0.99 | 2.89 | 2.15 |
| 04-ruff-noqa/compile-real | 1 | 120.34 ± 0.5% | not timed | not timed | 17.34 ± 1.0% | 168.45 ± 7.1% | not timed | not timed | 120.35 ± 0.6% | | 1.00 | 6.94 | 0.71 |
| 05-lexer-veryl/compile-single | 1 | 16.46 ± 1.2% | not timed | not timed | 2.97 ± 0.9% | 7.86 ± 2.3% | not timed | not timed | 16.51 ± 0.6% | | 1.00 | 5.54 | 2.09 |
| 07-unicode-character-data/compile | 1 | 125.76 ± 1.0% | not timed | not timed | 30.68 ± 1.0% | 44.47 ± 3.4% | not timed | not timed | 125.93 ± 1.2% | | 1.00 | 4.10 | 2.83 |
| 09-aws-keys/compile-full | 1 | 55.42 ± 1.7% | not timed | not timed | 9.94 ± 1.1% | 27.89 ± 1.5% | not timed | not timed | 55.53 ± 1.0% | | 1.00 | 5.58 | 1.99 |
| 09-aws-keys/compile-quick | 1 | 196.36 ± 0.7% | not timed | not timed | 59.01 ± 0.7% | 155.39 ± 2.5% | not timed | not timed | 196.15 ± 1.1% | | 1.00 | 3.33 | 1.26 |
| 10-bounded-repeat/compile-context | 1 | 60.66 ± 1.4% | not timed | not timed | 14.50 ± 0.7% | 20.29 ± 5.3% | not timed | not timed | 60.37 ± 0.7% | | 1.00 | 4.18 | 2.99 |
| 10-bounded-repeat/compile-capitals | 1 | 95.16 ± 0.3% | not timed | not timed | 10.42 ± 1.2% | 29.25 ± 1.9% | not timed | not timed | 94.68 ± 0.8% | | 1.01 | 9.13 | 3.25 |
| 11-unstructured-to-json/compile | 1 | 192.41 ± 0.5% | not timed | not timed | 47.09 ± 0.5% | 81.37 ± 3.3% | not timed | not timed | 192.05 ± 0.7% | | 1.00 | 4.09 | 2.36 |
| 12-dictionary/compile-single | 1 | 0.34 ± 1.3% | not timed | not timed | 0.08 ± 0.9% | 0.12 ± 26.7% | not timed | not timed | 0.34 ± 1.0% | | 1.00 | 4.09 | 2.90 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.24 ± 4.0% | not timed | not timed | 6.96 ± 7.9% | 0.55 ± 15.3% | not timed | not timed | 7.29 ± 2.1% | | 0.99 | 1.04 | 13.12 |
| dictionary/search/english-10 | 690 | 1.31 ± 0.9% | not timed | not timed | 153.16 ± 1.8% | 0.01 ± 0.1% | not timed | not timed | 1.31 ± 0.9% | | 1.00 | 0.0086 | 189.89 |
| dictionary/search/english-15 | 15 | 514.22 ± 1.5% | not timed | not timed | 481.70 ± 0.2% | 0.36 ± 1.1% | not timed | not timed | 513.14 ± 0.8% | | 1.00 | 1.07 | 1417.87 |
| folly/awyer-inn-busted | 1 | 4248.15 ± 0.6% | not timed | not timed | 132.30 ± 0.7% | 48.43 ± 0.5% | not timed | not timed | 4249.45 ± 0.2% | | 1.00 | 32.11 | 87.73 |
| folly/literal-never-match-rare | 0 | 67627.32 ± 0.9% | not timed | not timed | 46346.18 ± 0.4% | 68675.25 ± 0.7% | not timed | not timed | 67585.74 ± 0.6% | | 1.00 | 1.46 | 0.98 |
| folly/literal-never-match-frequent | 0 | 26216.85 ± 4.9% | not timed | not timed | 46105.21 ± 0.4% | 2588.49 ± 2.6% | not timed | not timed | 26154.64 ± 4.7% | | 1.00 | 0.57 | 10.13 |
| folly/literal-never-match-tricksy | 1 | 3978.24 ± 0.4% | not timed | not timed | 6144.50 ± 0.2% | 1719.83 ± 1.3% | not timed | not timed | 3973.48 ± 0.5% | | 1.00 | 0.65 | 2.31 |
| grep/every-line | 239963 | 1471.62 ± 1.0% | not timed | not timed | 967.14 ± 2.1% | 380.01 ± 17.9% | not timed | not timed | 1476.52 ± 4.4% | | 1.00 | 1.52 | 3.87 |
| grep/long-words-ascii | 5073 | 503.45 ± 8.8% | not timed | not timed | 496.62 ± 2.7% | 50.50 ± 8.1% | not timed | not timed | 504.67 ± 0.3% | | 1.00 | 1.01 | 9.97 |
| imported/leipzig/twain | 811 | 57977.52 ± 6.2% | not timed | not timed | 43580.97 ± 0.6% | 12540.78 ± 10.0% | not timed | not timed | 58239.86 ± 0.9% | | 1.00 | 1.33 | 4.62 |
| imported/leipzig/twain-insensitive | 965 | 15455.96 ± 0.2% | not timed | not timed | 13468.15 ± 0.4% | 37.78 ± 2.4% | not timed | not timed | 15502.20 ± 0.4% | | 1.00 | 1.15 | 409.09 |
| imported/leipzig/shing | 1540 | 30256.62 ± 1.5% | not timed | not timed | 22227.12 ± 0.4% | 26.14 ± 1.5% | not timed | not timed | 30090.81 ± 3.2% | | 1.01 | 1.36 | 1157.36 |
| imported/leipzig/huck-saw | 262 | 24970.09 ± 0.2% | not timed | not timed | 18691.42 ± 0.7% | 23.77 ± 3.8% | not timed | not timed | 24913.98 ± 1.2% | | 1.00 | 1.34 | 1050.57 |
| imported/leipzig/word-ending-nn | 262 | 609.55 ± 0.1% | not timed | not timed | 603.84 ± 0.4% | 23.32 ± 0.2% | not timed | not timed | 610.11 ± 0.5% | | 1.00 | 1.01 | 26.14 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11895.58 ± 0.2% | not timed | not timed | 3924.78 ± 0.5% | 11.37 ± 1.3% | not timed | not timed | 11911.00 ± 0.4% | | 1.00 | 3.03 | 1046.43 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 22093.24 ± 1.3% | not timed | not timed | 17585.28 ± 0.2% | 19.32 ± 0.4% | not timed | not timed | 22226.88 ± 1.5% | | 0.99 | 1.26 | 1143.35 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5567.16 ± 0.0% | not timed | not timed | 792.06 ± 1.7% | 12.32 ± 3.3% | not timed | not timed | 5564.96 ± 0.7% | | 1.00 | 7.03 | 451.74 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 607.72 ± 0.1% | not timed | not timed | 601.99 ± 0.1% | 11.00 ± 1.8% | not timed | not timed | 608.35 ± 0.1% | | 1.00 | 1.01 | 55.27 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 608.08 ± 0.1% | not timed | not timed | 602.72 ± 0.1% | 8.90 ± 1.0% | not timed | not timed | 608.11 ± 0.1% | | 1.00 | 1.01 | 68.34 |
| imported/leipzig/tom-river | 2 | 12867.89 ± 0.7% | not timed | not timed | 13380.09 ± 0.8% | 31.25 ± 2.1% | not timed | not timed | 12903.63 ± 1.1% | | 1.00 | 0.96 | 411.74 |
| imported/leipzig/ing | 78424 | 599.26 ± 0.4% | not timed | not timed | 561.18 ± 0.2% | 27.94 ± 3.2% | not timed | not timed | 599.14 ± 0.6% | | 1.00 | 1.07 | 21.45 |
| imported/leipzig/ing-whitespace | 55248 | 731.26 ± 1.0% | not timed | not timed | 2146.85 ± 0.9% | 21.37 ± 2.9% | not timed | not timed | 742.80 ± 0.2% | | 0.98 | 0.34 | 34.21 |
| imported/leipzig/awyer-inn | 209 | 770.45 ± 1.2% | not timed | not timed | 13763.99 ± 0.3% | 22.32 ± 0.2% | not timed | not timed | 771.09 ± 0.8% | | 1.00 | 0.0560 | 34.51 |
| imported/leipzig/quotes-bounded | 8886 | 1846.72 ± 0.4% | not timed | not timed | 3286.40 ± 0.2% | 39.17 ± 0.5% | not timed | not timed | 1842.72 ± 0.9% | | 1.00 | 0.56 | 47.15 |
| imported/leipzig/non-ascii-alternate | 2 | 40422.27 ± 6.8% | not timed | not timed | 19577.25 ± 0.3% | 56.32 ± 7.5% | not timed | not timed | 40526.84 ± 6.1% | | 1.00 | 2.06 | 717.78 |
| imported/leipzig/math-symbols | 69 | 2430.02 ± 0.2% | not timed | not timed | 604.49 ± 0.2% | 39.42 ± 3.5% | not timed | not timed | 2431.10 ± 6.3% | | 1.00 | 4.02 | 61.65 |
| imported/leipzig/bounded-strings-ending-z | 0 | 610.07 ± 0.1% | not timed | not timed | 603.57 ± 0.2% | 23.31 ± 6.5% | not timed | not timed | 610.06 ± 0.2% | | 1.00 | 1.01 | 26.17 |
| imported/lh3lh3-reb/uri | 17549 | 815.41 ± 0.1% | not timed | not timed | 1131.20 ± 0.8% | 24.85 ± 19.4% | not timed | not timed | 816.07 ± 0.5% | | 1.00 | 0.72 | 32.82 |
| imported/lh3lh3-reb/email | 15057 | 809.15 ± 1.4% | not timed | not timed | 1124.96 ± 4.7% | 25.61 ± 2.6% | not timed | not timed | 810.80 ± 13.7% | | 1.00 | 0.72 | 31.59 |
| imported/lh3lh3-reb/date | 668 | 934.63 ± 0.6% | not timed | not timed | 1018.30 ± 0.6% | 52.21 ± 6.5% | not timed | not timed | 935.76 ± 8.5% | | 1.00 | 0.92 | 17.90 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 752.11 ± 11.0% | not timed | not timed | 443.44 ± 0.3% | 12.67 ± 2.0% | not timed | not timed | 747.92 ± 0.2% | | 1.01 | 1.70 | 59.34 |
| imported/mariomka/email | 92 | 42805.12 ± 0.8% | not timed | not timed | 60363.07 ± 0.7% | 35.97 ± 8.1% | not timed | not timed | 42818.26 ± 2.0% | | 1.00 | 0.71 | 1189.88 |
| imported/mariomka/uri | 5301 | 6651.29 ± 0.8% | not timed | not timed | 7966.39 ± 0.5% | 35.95 ± 0.6% | not timed | not timed | 6644.79 ± 0.7% | | 1.00 | 0.83 | 185.03 |
| imported/mariomka/ip | 5 | 1819.96 ± 3.4% | not timed | not timed | 2313.41 ± 0.4% | 23.31 ± 0.8% | not timed | not timed | 1819.00 ± 3.3% | | 1.00 | 0.79 | 78.08 |
| imported/rsc/no-exponential | 0 | 895.55 ± 0.6% | not timed | not timed | 423.10 ± 1.1% | 25.97 ± 1.9% | not timed | not timed | 893.41 ± 0.3% | | 1.00 | 2.12 | 34.49 |
| imported/rsc/literal | 1 | 860.05 ± 13.7% | not timed | not timed | 2223.88 ± 1.0% | 225.03 ± 7.4% | not timed | not timed | 895.62 ± 5.4% | | 0.96 | 0.39 | 3.82 |
| imported/rsc/not-literal | 2 | 965.40 ± 2.6% | not timed | not timed | 839.61 ± 0.6% | 47.73 ± 34.6% | not timed | not timed | 961.43 ± 0.1% | | 1.00 | 1.15 | 20.23 |
| imported/rsc/match-class | 1 | 1674.92 ± 2.5% | not timed | not timed | 1773.64 ± 0.7% | 67.90 ± 6.9% | not timed | not timed | 1673.62 ± 0.3% | | 1.00 | 0.94 | 24.67 |
| imported/rsc/match-class-in-range | 1 | 1669.98 ± 2.3% | not timed | not timed | 3393.15 ± 15.5% | 69.39 ± 9.8% | not timed | not timed | 1675.46 ± 8.7% | | 1.00 | 0.49 | 24.07 |
| imported/rsc/match-class-unicode | 1 | 571.36 ± 0.2% | not timed | not timed | 522.85 ± 0.5% | 82.72 ± 0.3% | not timed | not timed | 571.75 ± 0.6% | | 1.00 | 1.09 | 6.91 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1698.25 ± 0.9% | not timed | not timed | 1145.32 ± 0.3% | 339.78 ± 2.0% | not timed | not timed | 1698.67 ± 0.4% | | 1.00 | 1.48 | 5.00 |
| imported/rsc/anchored-literal-long-non-match | 0 | 25479.20 ± 0.7% | not timed | not timed | 17161.99 ± 1.1% | 5128.99 ± 2.0% | not timed | not timed | 25480.28 ± 5.9% | | 1.00 | 1.48 | 4.97 |
| imported/rsc/anchored-literal-short-match | 4 | 887.95 ± 6.0% | not timed | not timed | 578.12 ± 1.5% | 106.26 ± 4.8% | not timed | not timed | 888.57 ± 2.9% | | 1.00 | 1.54 | 8.36 |
| imported/rsc/anchored-literal-long-match | 4 | 13043.93 ± 2.6% | not timed | not timed | 8418.99 ± 0.6% | 1620.62 ± 4.6% | not timed | not timed | 13214.00 ± 2.3% | | 0.99 | 1.55 | 8.05 |
| imported/rsc/one-pass-short | 17 | 493.72 ± 1.8% | not timed | not timed | 259.67 ± 0.8% | 35.99 ± 12.8% | not timed | not timed | 497.07 ± 0.6% | | 0.99 | 1.90 | 13.72 |
| imported/rsc/one-pass-short-not | 17 | 326.54 ± 2.0% | not timed | not timed | 269.45 ± 1.2% | 33.53 ± 11.0% | not timed | not timed | 325.20 ± 8.9% | | 1.00 | 1.21 | 9.74 |
| imported/rsc/one-pass-long-prefix | 26 | 445.55 ± 2.6% | not timed | not timed | 324.72 ± 0.6% | 131.77 ± 14.7% | not timed | not timed | 444.21 ± 7.1% | | 1.00 | 1.37 | 3.38 |
| imported/rsc/one-pass-long-prefix-not | 26 | 438.08 ± 2.4% | not timed | not timed | 320.58 ± 0.9% | 84.83 ± 23.6% | not timed | not timed | 446.61 ± 2.9% | | 0.98 | 1.37 | 5.16 |
| imported/rsc/long-needle1 | 31 | 68205.69 ± 0.3% | not timed | not timed | 45890.60 ± 0.4% | 4.20 ± 1.3% | not timed | not timed | 68147.79 ± 0.3% | | 1.00 | 1.49 | 16243.99 |
| imported/rsc/long-needle2 | 31 | 67808.53 ± 0.2% | not timed | not timed | 227.35 ± 27.7% | 4.20 ± 3.0% | not timed | not timed | 67706.28 ± 0.3% | | 1.00 | 298.26 | 16146.70 |
| imported/rsc/easy0-32 | 26 | 1264.83 ± 1.1% | not timed | not timed | 1820.57 ± 1.0% | 145.15 ± 8.2% | not timed | not timed | 1257.38 ± 1.1% | | 1.01 | 0.69 | 8.71 |
| imported/rsc/easy0-1k | 26 | 21368.96 ± 1.3% | not timed | not timed | 20434.94 ± 0.3% | 2290.10 ± 35.5% | not timed | not timed | 21562.36 ± 3.7% | | 0.99 | 1.05 | 9.33 |
| imported/rsc/easy0-32k | 26 | 64438.77 ± 1.5% | not timed | not timed | 43859.70 ± 0.1% | 26515.92 ± 18.5% | not timed | not timed | 64518.81 ± 1.6% | | 1.00 | 1.47 | 2.43 |
| imported/rsc/easy0-1mb | 26 | 64297.21 ± 0.5% | not timed | not timed | 45943.82 ± 1.4% | 67528.48 ± 0.9% | not timed | not timed | 64256.68 ± 1.2% | | 1.00 | 1.40 | 0.95 |
| imported/rsc/easy1-32 | 19 | 928.18 ± 0.8% | not timed | not timed | 746.27 ± 0.6% | 119.75 ± 29.8% | not timed | not timed | 920.66 ± 2.9% | | 1.01 | 1.24 | 7.75 |
| imported/rsc/easy1-1k | 19 | 18925.85 ± 2.9% | not timed | not timed | 15850.97 ± 0.6% | 2483.49 ± 19.2% | not timed | not timed | 18781.25 ± 6.2% | | 1.01 | 1.19 | 7.62 |
| imported/rsc/easy1-32k | 19 | 597016.77 ± 2.0% | not timed | not timed | 495373.54 ± 1.1% | 29363.80 ± 16.6% | not timed | not timed | 590084.53 ± 13.2% | | 1.01 | 1.21 | 20.33 |
| imported/rsc/easy1-1mb | 19 | 19073510.08 ± 0.5% | not timed | not timed | 15728451.61 ± 0.7% | 68105.91 ± 1.1% | not timed | not timed | 18912354.64 ± 1.3% | | 1.01 | 1.21 | 280.06 |
| imported/rsc/medium-32 | 27 | 868.97 ± 1.8% | not timed | not timed | 733.26 ± 0.6% | 73.72 ± 22.7% | not timed | not timed | 861.66 ± 0.7% | | 1.01 | 1.19 | 11.79 |
| imported/rsc/medium-1k | 27 | 15479.45 ± 0.4% | not timed | not timed | 13167.51 ± 0.3% | 81.45 ± 1.2% | not timed | not timed | 15385.07 ± 0.3% | | 1.01 | 1.18 | 190.04 |
| imported/rsc/medium-32k | 27 | 483080.75 ± 0.6% | not timed | not timed | 411737.10 ± 0.1% | 54.25 ± 1.6% | not timed | not timed | 481278.80 ± 0.9% | | 1.00 | 1.17 | 8905.43 |
| imported/rsc/medium-1mb | 27 | 15469934.82 ± 1.1% | not timed | not timed | 13122424.16 ± 0.4% | 54.59 ± 0.6% | not timed | not timed | 15350019.95 ± 0.6% | | 1.01 | 1.18 | 283374.88 |
| imported/rsc/hard-32 | 58 | 448.37 ± 6.7% | not timed | not timed | 392.80 ± 1.3% | 52.15 ± 7.0% | not timed | not timed | 447.07 ± 0.9% | | 1.00 | 1.14 | 8.60 |
| imported/rsc/hard-1k | 27 | 14829.62 ± 0.6% | not timed | not timed | 13011.06 ± 0.3% | 44.44 ± 27.7% | not timed | not timed | 14791.41 ± 0.8% | | 1.00 | 1.14 | 333.69 |
| imported/rsc/hard-32k | 27 | 462742.83 ± 0.9% | not timed | not timed | 405983.65 ± 1.7% | 32.97 ± 24.9% | not timed | not timed | 461297.13 ± 4.4% | | 1.00 | 1.14 | 14034.60 |
| imported/rsc/hard-1mb | 51 | 8943549.97 ± 0.8% | not timed | not timed | 7844410.75 ± 6.8% | 33.08 ± 0.1% | not timed | not timed | 8964946.36 ± 0.6% | | 1.00 | 1.14 | 270401.39 |
| imported/rsc/reallyhard0-32 | 58 | 279.87 ± 1.9% | not timed | not timed | 246.90 ± 0.5% | 52.20 ± 8.1% | not timed | not timed | 282.23 ± 0.3% | | 0.99 | 1.13 | 5.36 |
| imported/rsc/reallyhard0-1k | 27 | 591.15 ± 0.3% | not timed | not timed | 580.35 ± 0.2% | 44.89 ± 13.2% | not timed | not timed | 591.61 ± 0.2% | | 1.00 | 1.02 | 13.17 |
| imported/rsc/reallyhard0-32k | 27 | 607.62 ± 0.3% | not timed | not timed | 603.37 ± 0.2% | 32.94 ± 0.2% | not timed | not timed | 608.36 ± 0.3% | | 1.00 | 1.01 | 18.45 |
| imported/rsc/reallyhard0-1mb | 51 | 609.92 ± 0.2% | not timed | not timed | 604.58 ± 0.2% | 33.15 ± 0.8% | not timed | not timed | 609.58 ± 0.2% | | 1.00 | 1.01 | 18.40 |
| imported/rsc/reallyreallyhard0-32 | 47 | 334.33 ± 2.4% | not timed | not timed | 208.41 ± 0.2% | 64.78 ± 11.7% | not timed | not timed | 330.53 ± 12.6% | | 1.01 | 1.60 | 5.16 |
| imported/rsc/reallyreallyhard0-1k | 16 | 8192.30 ± 0.4% | not timed | not timed | 7702.15 ± 0.3% | 36.80 ± 0.1% | not timed | not timed | 8201.04 ± 8.9% | | 1.00 | 1.06 | 222.64 |
| imported/rsc/reallyreallyhard0-32k | 16 | 52609.23 ± 11.8% | not timed | not timed | 36949.45 ± 0.5% | 26.80 ± 1.2% | not timed | not timed | 52864.98 ± 0.1% | | 1.00 | 1.42 | 1962.90 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 70660.81 ± 0.4% | not timed | not timed | 45511.82 ± 0.1% | 27.15 ± 0.7% | not timed | not timed | 70669.89 ± 0.2% | | 1.00 | 1.55 | 2602.47 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 324.78 ± 1.5% | not timed | not timed | 211.06 ± 0.4% | 65.29 ± 9.8% | not timed | not timed | 324.39 ± 11.3% | | 1.00 | 1.54 | 4.97 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 6802.96 ± 0.3% | not timed | not timed | 7522.07 ± 11.3% | 36.58 ± 24.6% | not timed | not timed | 6789.92 ± 0.3% | | 1.00 | 0.90 | 186.00 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 49572.01 ± 10.7% | not timed | not timed | 36855.74 ± 0.2% | 27.10 ± 0.3% | not timed | not timed | 48348.73 ± 0.3% | | 1.03 | 1.35 | 1829.43 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 65003.77 ± 0.6% | not timed | not timed | 45563.29 ± 16.8% | 27.20 ± 1.7% | not timed | not timed | 65067.33 ± 0.4% | | 1.00 | 1.43 | 2390.01 |
| imported/sherlock/name-sherlock | 776 | 48601.63 ± 7.8% | not timed | not timed | 39723.33 ± 1.8% | 13081.35 ± 25.7% | not timed | not timed | 49521.53 ± 10.3% | | 0.98 | 1.22 | 3.72 |
| imported/sherlock/name-holmes | 2766 | 26884.21 ± 3.5% | not timed | not timed | 30073.08 ± 1.1% | 4125.83 ± 5.0% | not timed | not timed | 27589.36 ± 3.7% | | 0.97 | 0.89 | 6.52 |
| imported/sherlock/name-sherlock-holmes | 1365 | 50090.40 ± 4.6% | not timed | not timed | 39969.43 ± 1.0% | 10307.86 ± 22.0% | not timed | not timed | 50140.60 ± 0.4% | | 1.00 | 1.25 | 4.86 |
| imported/sherlock/name-sherlock-casei | 816 | 45457.57 ± 0.4% | not timed | not timed | 11533.01 ± 0.8% | 34.27 ± 0.7% | not timed | not timed | 45406.00 ± 0.5% | | 1.00 | 3.94 | 1326.46 |
| imported/sherlock/name-holmes-casei | 2802 | 22487.28 ± 0.2% | not timed | not timed | 7617.38 ± 1.7% | 44.84 ± 1.6% | not timed | not timed | 22466.55 ± 0.7% | | 1.00 | 2.95 | 501.47 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 36305.85 ± 20.3% | not timed | not timed | 11118.24 ± 0.3% | 33.98 ± 3.0% | not timed | not timed | 36180.84 ± 0.4% | | 1.00 | 3.27 | 1068.31 |
| imported/sherlock/name-whitespace | 1461 | 29198.89 ± 5.8% | not timed | not timed | 28125.74 ± 1.7% | 9170.38 ± 20.2% | not timed | not timed | 29636.81 ± 6.1% | | 0.99 | 1.04 | 3.18 |
| imported/sherlock/name-alt1 | 1142 | 31121.28 ± 0.6% | not timed | not timed | 29048.66 ± 0.2% | 5693.13 ± 27.9% | not timed | not timed | 31096.10 ± 1.5% | | 1.00 | 1.07 | 5.47 |
| imported/sherlock/name-alt2 | 3542 | 21034.36 ± 16.6% | not timed | not timed | 10045.31 ± 12.7% | 32.93 ± 28.1% | not timed | not timed | 21063.79 ± 7.1% | | 1.00 | 2.09 | 638.72 |
| imported/sherlock/name-alt3 | 4507 | 13468.13 ± 0.4% | not timed | not timed | 9188.94 ± 12.2% | 11.30 ± 0.3% | not timed | not timed | 13471.28 ± 0.3% | | 1.00 | 1.47 | 1191.97 |
| imported/sherlock/name-alt3-casei | 4593 | 3544.11 ± 3.3% | not timed | not timed | 1314.07 ± 15.4% | 7.45 ± 1.2% | not timed | not timed | 3509.13 ± 5.9% | | 1.01 | 2.70 | 475.67 |
| imported/sherlock/name-alt4 | 3686 | 9923.14 ± 0.4% | not timed | not timed | 8163.25 ± 0.6% | 36.07 ± 1.9% | not timed | not timed | 9892.17 ± 1.3% | | 1.00 | 1.22 | 275.14 |
| imported/sherlock/name-alt4-casei | 4254 | 5430.54 ± 3.1% | not timed | not timed | 4446.62 ± 1.6% | 20.68 ± 0.8% | not timed | not timed | 5454.05 ± 1.5% | | 1.00 | 1.22 | 262.57 |
| imported/sherlock/name-alt5 | 4028 | 17209.40 ± 2.6% | not timed | not timed | 9647.02 ± 0.4% | 24.76 ± 1.0% | not timed | not timed | 17211.74 ± 0.7% | | 1.00 | 1.78 | 694.99 |
| imported/sherlock/name-alt5-casei | 4104 | 6987.30 ± 0.7% | not timed | not timed | 2989.77 ± 4.5% | 15.57 ± 1.0% | not timed | not timed | 7008.58 ± 0.8% | | 1.00 | 2.34 | 448.85 |
| imported/sherlock/no-match-uncommon | 0 | 66033.31 ± 0.2% | not timed | not timed | 57400.97 ± 0.3% | 56351.54 ± 0.8% | not timed | not timed | 66090.93 ± 12.9% | | 1.00 | 1.15 | 1.17 |
| imported/sherlock/no-match-common | 0 | 64725.53 ± 12.4% | not timed | not timed | 57302.14 ± 0.6% | 2161.17 ± 0.3% | not timed | not timed | 64784.88 ± 0.5% | | 1.00 | 1.13 | 29.95 |
| imported/sherlock/no-match-really-common | 0 | 42263.65 ± 0.9% | not timed | not timed | 49564.95 ± 0.1% | 2139.82 ± 1.2% | not timed | not timed | 42293.10 ± 0.4% | | 1.00 | 0.85 | 19.75 |
| imported/sherlock/the-lower | 21654 | 3981.24 ± 2.7% | not timed | not timed | 4602.19 ± 1.3% | 272.74 ± 23.4% | not timed | not timed | 4009.05 ± 6.0% | | 0.99 | 0.87 | 14.60 |
| imported/sherlock/the-upper | 2223 | 20773.31 ± 1.4% | not timed | not timed | 28875.59 ± 0.9% | 3137.07 ± 15.9% | not timed | not timed | 20736.96 ± 1.4% | | 1.00 | 0.72 | 6.62 |
| imported/sherlock/the-casei | 23961 | 3497.61 ± 3.3% | not timed | not timed | 1364.25 ± 0.4% | 41.47 ± 15.0% | not timed | not timed | 3498.77 ± 1.3% | | 1.00 | 2.56 | 84.35 |
| imported/sherlock/everything-greedy | 581881 | 294.42 ± 7.4% | not timed | not timed | 173.52 ± 0.9% | 31.01 ± 35.1% | not timed | not timed | 295.51 ± 0.6% | | 1.00 | 1.70 | 9.50 |
| imported/sherlock/everything-greedy-nl | 594933 | 464.67 ± 0.1% | not timed | not timed | 224.55 ± 1.3% | 34.74 ± 0.5% | not timed | not timed | 464.50 ± 0.1% | | 1.00 | 2.07 | 13.38 |
| imported/sherlock/letters | 447175 | 67.06 ± 0.5% | not timed | not timed | 34.10 ± 0.8% | 6.99 ± 54.3% | not timed | not timed | 67.30 ± 0.7% | | 1.00 | 1.97 | 9.60 |
| imported/sherlock/letters-upper | 14180 | 453.22 ± 1.2% | not timed | not timed | 366.40 ± 0.3% | 31.19 ± 18.7% | not timed | not timed | 452.70 ± 5.5% | | 1.00 | 1.24 | 14.53 |
| imported/sherlock/letters-lower | 432995 | 68.40 ± 1.5% | not timed | not timed | 34.83 ± 0.2% | 6.77 ± 47.0% | not timed | not timed | 69.17 ± 1.7% | | 0.99 | 1.96 | 10.11 |
| imported/sherlock/words | 447639 | 123.91 ± 4.4% | not timed | not timed | 83.24 ± 4.4% | 15.11 ± 13.1% | not timed | not timed | 123.66 ± 6.0% | | 1.00 | 1.49 | 8.20 |
| imported/sherlock/before-holmes | 4073 | 15109.38 ± 0.3% | not timed | not timed | 13321.68 ± 0.4% | 25.79 ± 0.3% | not timed | not timed | 15112.88 ± 0.3% | | 1.00 | 1.13 | 585.92 |
| imported/sherlock/before-after-holmes | 2593 | 14903.88 ± 0.4% | not timed | not timed | 15031.78 ± 0.4% | 25.85 ± 0.7% | not timed | not timed | 14814.93 ± 0.4% | | 1.01 | 0.99 | 576.50 |
| imported/sherlock/holmes-cochar-watson | 150 | 10013.08 ± 0.6% | not timed | not timed | 7620.86 ± 0.2% | 35.42 ± 30.4% | not timed | not timed | 10076.41 ± 0.5% | | 0.99 | 1.31 | 282.69 |
| imported/sherlock/holmes-coword-watson | 14309 | 1271.65 ± 0.2% | not timed | not timed | 1233.45 ± 2.1% | 7.61 ± 19.0% | not timed | not timed | 1275.22 ± 0.8% | | 1.00 | 1.03 | 167.00 |
| imported/sherlock/quotes | 14437 | 1363.70 ± 0.7% | not timed | not timed | 2255.31 ± 2.1% | 37.51 ± 0.8% | not timed | not timed | 1361.90 ± 1.4% | | 1.00 | 0.60 | 36.36 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 606.23 ± 0.3% | not timed | not timed | 30979.06 ± 2.0% | 40.39 ± 0.6% | not timed | not timed | 605.81 ± 0.6% | | 1.00 | 0.0196 | 15.01 |
| imported/sherlock/word-ending-n | 35297 | 477.24 ± 0.3% | not timed | not timed | 402.61 ± 0.2% | 26.21 ± 1.1% | not timed | not timed | 477.85 ± 0.4% | | 1.00 | 1.19 | 18.21 |
| imported/sherlock/repeated-class-negation | 2130 | 18857.71 ± 0.2% | not timed | not timed | 16237.85 ± 0.3% | 12.31 ± 1.3% | not timed | not timed | 18796.18 ± 0.4% | | 1.00 | 1.16 | 1532.14 |
| imported/sherlock/ing-suffix | 20547 | 573.28 ± 7.5% | not timed | not timed | 511.10 ± 0.1% | 30.36 ± 11.9% | not timed | not timed | 573.36 ± 0.3% | | 1.00 | 1.12 | 18.88 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 605.50 ± 0.7% | not timed | not timed | 2924.79 ± 1.2% | 22.84 ± 0.8% | not timed | not timed | 606.93 ± 2.3% | | 1.00 | 0.21 | 26.51 |
| opt/accelerate/whole-line | 239963 | 504.22 ± 7.2% | not timed | not timed | 414.70 ± 0.4% | 83.32 ± 14.7% | not timed | not timed | 505.43 ± 0.5% | | 1.00 | 1.22 | 6.05 |
| opt/accelerate/non-dna | 16745 | 451.14 ± 3.7% | not timed | not timed | 438.71 ± 0.1% | 33.19 ± 22.6% | not timed | not timed | 452.76 ± 9.5% | | 1.00 | 1.03 | 13.59 |
| opt/backtrack/words-english | 40536 | 139.79 ± 4.5% | not timed | not timed | 109.23 ± 2.2% | 21.69 ± 25.8% | not timed | not timed | 137.46 ± 18.7% | | 1.02 | 1.28 | 6.44 |
| opt/fixed-length/too-small-ascii | 0 | 390.85 ± 26.5% | not timed | not timed | 709.00 ± 0.3% | 120.88 ± 3.3% | not timed | not timed | 391.26 ± 5.7% | | 1.00 | 0.55 | 3.23 |
| opt/fixed-length/too-big-ascii | 0 | 4315.91 ± 5.4% | not timed | not timed | 6323.45 ± 0.3% | 150.81 ± 0.7% | not timed | not timed | 4296.09 ± 0.2% | | 1.00 | 0.68 | 28.62 |
| opt/fixed-length/go33484-1 | 0 | 829182.15 ± 0.6% | not timed | not timed | 1214979.84 ± 1.1% | 89201.88 ± 1.2% | not timed | not timed | 833388.09 ± 0.7% | | 0.99 | 0.68 | 9.30 |
| opt/fixed-length/go33484-2 | 0 | 831719.26 ± 0.5% | not timed | not timed | 1217598.30 ± 0.9% | 24297.67 ± 20.1% | not timed | not timed | 833499.22 ± 0.8% | | 1.00 | 0.68 | 34.23 |
| opt/fixed-length/go33484-3 | 0 | 2448.97 ± 0.5% | not timed | not timed | 121554.38 ± 0.5% | 939.63 ± 2.6% | not timed | not timed | 2433.30 ± 0.4% | | 1.01 | 0.0201 | 2.61 |
| opt/literal-alt/one-pattern | 1 | 560.33 ± 3.0% | not timed | not timed | 567.36 ± 0.4% | 0.39 ± 4.1% | not timed | not timed | 581.67 ± 1.3% | | 0.96 | 0.99 | 1448.82 |
| opt/onepass/fn-predicate | 916 | 436.36 ± 1.2% | not timed | not timed | 393.69 ± 14.8% | 211.89 ± 17.8% | not timed | not timed | 437.73 ± 0.9% | | 1.00 | 1.11 | 2.06 |
| opt/onepass/first-three-words-english | 35128 | 177.47 ± 15.4% | not timed | not timed | 215.41 ± 0.7% | 71.51 ± 21.8% | not timed | not timed | 178.66 ± 2.1% | | 0.99 | 0.82 | 2.48 |
| opt/prefilter/literal-english | 1 | 67172.97 ± 0.6% | not timed | not timed | 46297.59 ± 0.6% | 26707.17 ± 0.3% | not timed | not timed | 67040.74 ± 0.3% | | 1.00 | 1.45 | 2.52 |
| opt/prefilter/literal-casei-english | 1 | 46865.72 ± 0.9% | not timed | not timed | 14290.00 ± 0.4% | 34.08 ± 0.4% | not timed | not timed | 46885.51 ± 0.4% | | 1.00 | 3.28 | 1375.11 |
| opt/prefilter/literal-russian | 1 | 68747.81 ± 0.5% | not timed | not timed | 46504.90 ± 0.5% | 1805.56 ± 0.4% | not timed | not timed | 68575.91 ± 0.5% | | 1.00 | 1.48 | 38.08 |
| opt/prefilter/literal-casei-russian | 1 | 26173.00 ± 5.7% | not timed | not timed | 10947.94 ± 0.6% | 37.72 ± 0.7% | not timed | not timed | 26059.78 ± 19.5% | | 1.00 | 2.39 | 693.88 |
| opt/prefilter/rust-functions | 948 | 14650.37 ± 2.5% | not timed | not timed | 12911.19 ± 0.5% | 1828.86 ± 0.3% | not timed | not timed | 14695.03 ± 1.9% | | 1.00 | 1.13 | 8.01 |
| opt/reverse-anchored/word-end | 1 | 35277779.23 ± 0.4% | not timed | not timed | 27031370.32 ± 1.8% | 56.52 ± 0.7% | not timed | not timed | 34943486.70 ± 0.6% | | 1.01 | 1.31 | 624119.86 |
| opt/reverse-inner/holmes | 2593 | 14898.00 ± 0.4% | not timed | not timed | 14886.45 ± 3.7% | 23.43 ± 5.1% | not timed | not timed | 14812.31 ± 6.7% | | 1.01 | 1.00 | 635.88 |
| opt/reverse-inner/email | 47 | 84322.46 ± 1.1% | not timed | not timed | 92113.32 ± 16.6% | 33.18 ± 6.5% | not timed | not timed | 84859.28 ± 0.5% | | 0.99 | 0.92 | 2541.62 |
| opt/reverse-inner/factored-prefix | 3542 | 600.02 ± 0.1% | not timed | not timed | 586.21 ± 0.1% | 12.89 ± 1.0% | not timed | not timed | 599.34 ± 0.2% | | 1.00 | 1.02 | 46.56 |
| opt/reverse-inner/no-quadratic-backward | 0 | 4193.91 ± 0.9% | not timed | not timed | 603.16 ± 3.3% | 85.84 ± 13.4% | not timed | not timed | 4198.64 ± 9.8% | | 1.00 | 6.95 | 48.86 |
| opt/reverse-inner/no-quadratic-forward | 0 | 709.05 ± 2.0% | not timed | not timed | 279.99 ± 0.4% | 25.55 ± 17.9% | not timed | not timed | 707.91 ± 10.1% | | 1.00 | 2.53 | 27.76 |
| opt/reverse-suffix/holmes | 4073 | 15103.37 ± 0.2% | not timed | not timed | 13252.68 ± 0.3% | 23.59 ± 0.5% | not timed | not timed | 15122.69 ± 0.3% | | 1.00 | 1.14 | 640.38 |
| opt/reverse-suffix/no-quadratic | 0 | 4210.85 ± 0.7% | not timed | not timed | 604.64 ± 0.4% | 86.17 ± 0.6% | not timed | not timed | 4199.51 ± 0.4% | | 1.00 | 6.96 | 48.87 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 141.63 ± 7.8% | not timed | not timed | 179.43 ± 0.4% | 15.71 ± 27.9% | not timed | not timed | 142.74 ± 2.8% | | 0.99 | 0.79 | 9.02 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 140.88 ± 27.5% | not timed | not timed | 183.27 ± 0.3% | 14.57 ± 19.4% | not timed | not timed | 142.90 ± 0.5% | | 0.99 | 0.77 | 9.67 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.32 ± 0.5% | not timed | not timed | 0.48 ± 13.0% | 119.17 ± 0.3% | not timed | not timed | 0.32 ± 0.7% | | 0.99 | 0.66 | 0.0026 |
| reported/i1095-word-repetition/ascii-search | 256 | 300.36 ± 0.6% | not timed | not timed | 141.31 ± 0.4% | 107.16 ± 6.7% | not timed | not timed | 301.44 ± 2.6% | | 1.00 | 2.13 | 2.80 |
| reported/i13-subset-regex/original-ascii | 4094 | 11930.12 ± 0.7% | not timed | not timed | 3978.32 ± 1.5% | 11.61 ± 1.0% | not timed | not timed | 11901.43 ± 0.9% | | 1.00 | 3.00 | 1027.88 |
| reported/i13-subset-regex/original-unicode | 4094 | 11844.85 ± 0.3% | not timed | not timed | 199.78 ± 1.7% | 12.25 ± 0.3% | not timed | not timed | 11880.62 ± 0.5% | | 1.00 | 59.29 | 966.67 |
| reported/i13-subset-regex/big-ascii | 1955 | 11121.54 ± 1.0% | not timed | not timed | 53.76 ± 2.6% | 10.57 ± 0.7% | not timed | not timed | 11127.04 ± 1.5% | | 1.00 | 206.86 | 1052.41 |
| reported/i13-subset-regex/big-unicode | 1955 | 11076.29 ± 0.6% | not timed | not timed | 9.71 ± 55.7% | 10.56 ± 0.6% | not timed | not timed | 11109.72 ± 0.5% | | 1.00 | 1141.17 | 1049.32 |
| reported/i13-subset-regex/huge-ascii | 55 | 10165.14 ± 0.7% | not timed | not timed | 8.99 ± 0.8% | 9.54 ± 1.6% | not timed | not timed | 10189.63 ± 0.5% | | 1.00 | 1131.15 | 1065.42 |
| reported/i13-subset-regex/huge-unicode | 55 | 10073.08 ± 0.6% | not timed | not timed | 8.94 ± 0.5% | 9.54 ± 1.5% | not timed | not timed | 10059.63 ± 1.8% | | 1.00 | 1126.96 | 1056.25 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.20 ± 0.4% | not timed | not timed | 9.03 ± 0.7% | 9.50 ± 1.9% | not timed | not timed | 4.20 ± 0.3% | | 1.00 | 0.47 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.88 ± 0.2% | not timed | not timed | 8.92 ± 0.5% | 9.52 ± 0.6% | not timed | not timed | 5.83 ± 0.7% | | 1.01 | 0.66 | 0.62 |
| reported/i787-keywords/ascii | 5674 | 555.56 ± 2.9% | not timed | not timed | 170.24 ± 1.0% | 7.23 ± 0.7% | not timed | not timed | 560.30 ± 0.8% | | 0.99 | 3.26 | 76.85 |
| reported/i787-keywords/opt-ascii | 5674 | 560.55 ± 0.4% | not timed | not timed | 272.68 ± 1.0% | 11.63 ± 0.7% | not timed | not timed | 559.59 ± 1.1% | | 1.00 | 2.06 | 48.18 |
| slow/quadratic-regex-1x | 100 | 8.23 ± 0.4% | not timed | not timed | 6.01 ± 0.2% | 0.05 ± 2.6% | not timed | not timed | 8.24 ± 0.3% | | 1.00 | 1.37 | 159.76 |
| slow/quadratic-regex-2x | 199 | 3.71 ± 7.3% | not timed | not timed | 3.03 ± 2.2% | 0.01 ± 0.8% | not timed | not timed | 3.71 ± 0.3% | | 1.00 | 1.22 | 279.39 |
| slow/quadratic-haystack-1x | 100 | 26.13 ± 0.6% | not timed | not timed | 12.12 ± 2.2% | 0.99 ± 17.6% | not timed | not timed | 26.09 ± 2.6% | | 1.00 | 2.16 | 26.28 |
| slow/quadratic-haystack-2x | 200 | 19.74 ± 7.2% | not timed | not timed | 6.12 ± 6.5% | 0.55 ± 19.8% | not timed | not timed | 19.93 ± 0.3% | | 0.99 | 3.22 | 35.79 |
| unicode/codepoints/any-one | 1112064 | 336.05 ± 1.6% | not timed | not timed | 240.63 ± 0.3% | 20.88 ± 28.4% | not timed | not timed | 336.25 ± 2.6% | | 1.00 | 1.40 | 16.10 |
| unicode/codepoints/any-all | 4382592 | 267.91 ± 0.4% | not timed | not timed | 263.98 ± 0.9% | 125.78 ± 1.4% | not timed | not timed | 268.46 ± 0.3% | | 1.00 | 1.01 | 2.13 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.93 ± 2.1% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 610.23 ± 0.4% | not timed | not timed | 603.62 ± 0.1% | 153.35 ± 1.1% | not timed | not timed | 610.03 ± 0.5% | | 1.00 | 1.01 | 3.98 |
| unicode/overlapping-words/ascii | 6156 | 29.44 ± 2.0% | not timed | not timed | 42.78 ± 20.0% | 4.03 ± 3.0% | not timed | not timed | 28.47 ± 8.7% | | 1.03 | 0.69 | 7.31 |
| unicode/overlapping-words/english | 6156 | 1.46 ± 2.2% | not timed | not timed | 2.70 ± 0.4% | 2.89 ± 1.8% | not timed | not timed | 1.49 ± 0.7% | | 0.98 | 0.54 | 0.51 |
| unicode/overlapping-words/russian | 5710 | 1.32 ± 10.9% | not timed | not timed | 2.69 ± 9.3% | 6.92 ± 11.9% | not timed | not timed | 1.34 ± 16.4% | | 0.99 | 0.49 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 138.01 ± 1.5% | not timed | not timed | 84.25 ± 0.3% | 13.20 ± 18.4% | not timed | not timed | 138.17 ± 1.0% | | 1.00 | 1.64 | 10.45 |
| unicode/word/boundary-long-english | 3466 | 611.84 ± 0.1% | not timed | not timed | 593.15 ± 0.1% | 35.33 ± 1.2% | not timed | not timed | 612.61 ± 0.1% | | 1.00 | 1.03 | 17.32 |
| unicode/word/around-holmes-english | 27 | 63075.13 ± 0.8% | not timed | not timed | 44821.32 ± 0.6% | 24.04 ± 2.2% | not timed | not timed | 63405.64 ± 0.6% | | 0.99 | 1.41 | 2624.26 |
| wild/bibleref/long | 874 | 569.62 ± 0.7% | not timed | not timed | 574.23 ± 0.1% | 7.87 ± 0.3% | not timed | not timed | 570.88 ± 0.6% | | 1.00 | 0.99 | 72.41 |
| wild/bibleref/short | 30 | 22.98 ± 11.4% | not timed | not timed | 33.28 ± 0.4% | 14.57 ± 25.9% | not timed | not timed | 23.95 ± 1.3% | | 0.96 | 0.69 | 1.58 |
| wild/bibleref/line | 874 | 510.03 ± 0.2% | not timed | not timed | 275.54 ± 0.2% | 8.86 ± 7.8% | not timed | not timed | 514.51 ± 0.7% | | 0.99 | 1.85 | 57.60 |
| wild/caddy/caddy | 6 | 447.03 ± 2.9% | not timed | not timed | 291.96 ± 0.3% | 75.55 ± 16.0% | not timed | not timed | 418.44 ± 2.4% | | 1.07 | 1.53 | 5.92 |
| wild/dot-star-capture/rust-src-tools | 6 | 1452.73 ± 1.3% | not timed | not timed | 404.51 ± 0.3% | 15.77 ± 0.8% | not timed | not timed | 1451.21 ± 0.9% | | 1.00 | 3.59 | 92.12 |
| wild/ruff/noqa | 84 | 510.68 ± 0.5% | not timed | not timed | 503.04 ± 0.5% | 21.23 ± 7.3% | not timed | not timed | 514.16 ± 13.9% | | 0.99 | 1.02 | 24.06 |
| wild/ruff/unnecessary-coding-comment | 16 | 1076.53 ± 1.1% | not timed | not timed | 723.85 ± 0.9% | 89.07 ± 14.0% | not timed | not timed | 1078.53 ± 0.5% | | 1.00 | 1.49 | 12.09 |
| wild/ruff/string-quote-prefix | 2972 | 1557.11 ± 4.2% | not timed | not timed | 460.77 ± 4.5% | 321.64 ± 29.1% | not timed | not timed | 1580.69 ± 23.0% | | 0.99 | 3.38 | 4.84 |
| wild/ruff/space-around-operator | 1224378 | 236.79 ± 1.6% | not timed | not timed | 220.52 ± 0.2% | 18.93 ± 5.3% | not timed | not timed | 238.02 ± 1.8% | | 0.99 | 1.07 | 12.51 |
| wild/ruff/shebang | 282 | 1110.25 ± 1.1% | not timed | not timed | 384.67 ± 10.3% | 109.25 ± 12.3% | not timed | not timed | 1120.11 ± 8.1% | | 0.99 | 2.89 | 10.16 |
| wild/rustsec-cargo-audit/original-unix | 471 | 22568.78 ± 0.3% | not timed | not timed | 23546.77 ± 0.9% | 8770.96 ± 1.8% | not timed | not timed | 22012.06 ± 1.0% | | 1.03 | 0.96 | 2.57 |
| wild/rustsec-cargo-audit/original-windows | 462 | 20007.58 ± 0.3% | not timed | not timed | 22460.68 ± 1.8% | 8387.27 ± 1.2% | not timed | not timed | 20658.27 ± 0.6% | | 0.97 | 0.89 | 2.39 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 22394.79 ± 1.2% | not timed | not timed | 23415.21 ± 19.1% | 8661.33 ± 2.3% | not timed | not timed | 23056.44 ± 10.1% | | 0.97 | 0.96 | 2.59 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 18226.72 ± 3.5% | not timed | not timed | 23398.38 ± 0.7% | 8568.62 ± 23.4% | not timed | not timed | 18223.62 ± 0.4% | | 1.00 | 0.78 | 2.13 |
| wild/url/search | 234965 | 128.88 ± 14.2% | not timed | not timed | 61.02 ± 0.8% | 2.45 ± 2.4% | not timed | not timed | 128.74 ± 13.6% | | 1.00 | 2.11 | 52.52 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 59.5% | not timed | not timed | 0.01 ± 11.7% | 0.01 ± 13.3% | not timed | not timed | 0.03 ± 66.0% | | 1.00 | 2.55 | 4.10 |
| dictionary/compile/english-15 | 1 | 0.34 ± 2.2% | not timed | not timed | 0.09 ± 9.6% | 0.11 ± 17.6% | not timed | not timed | 0.35 ± 2.5% | | 0.98 | 3.59 | 3.03 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.30 ± 17.5% | not timed | not timed | 0.02 ± 0.9% | 36.00 ± 16.2% | not timed | not timed | 0.30 ± 3.6% | | 1.00 | 12.15 | 0.0083 |
| reported/i1095-word-repetition/ascii-compile | 1 | 39.67 ± 15.0% | not timed | not timed | 17.02 ± 4.3% | 59.86 ± 23.1% | not timed | not timed | 45.23 ± 2.2% | | 0.88 | 2.33 | 0.66 |
| reported/i787-keywords/compile | 1 | 39.59 ± 3.8% | not timed | not timed | 2.40 ± 20.5% | 19.44 ± 29.1% | not timed | not timed | 40.15 ± 1.9% | | 0.99 | 16.51 | 2.04 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 376.39 ± 6.5% | not timed | not timed | 149.51 ± 0.5% | 658.72 ± 25.1% | not timed | not timed | 377.66 ± 3.9% | | 1.00 | 2.52 | 0.57 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 53.00 ± 3.8% | not timed | not timed | 5.60 ± 1.4% | 48.33 ± 4.9% | not timed | not timed | 54.50 ± 10.6% | | 0.97 | 9.47 | 1.10 |
| unicode/compile/one-letter | 53 | 6.83 ± 12.2% | not timed | not timed | 5.81 ± 0.5% | 65.10 ± 8.3% | not timed | not timed | 6.98 ± 2.0% | | 0.98 | 1.18 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.23 ± 23.9% | not timed | not timed | 0.13 ± 5.3% | 65.43 ± 3.6% | not timed | not timed | 1.23 ± 16.3% | | 1.00 | 9.75 | 0.0187 |
| unicode/compile/fifty-letters-ascii | 1 | 206.02 ± 2.4% | not timed | not timed | 69.52 ± 0.5% | 203.02 ± 15.5% | not timed | not timed | 206.26 ± 3.0% | | 1.00 | 2.96 | 1.01 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 449.18 ± 6.5% | not timed | not timed | 50.78 ± 1.2% | 747.13 ± 12.0% | not timed | not timed | 454.12 ± 3.8% | | 0.99 | 8.85 | 0.60 |
| unicode/compile/match-every-line-ascii | 4 | 701.78 ± 20.6% | not timed | not timed | 168.96 ± 13.4% | 723.11 ± 13.3% | not timed | not timed | 708.66 ± 6.4% | | 0.99 | 4.15 | 0.97 |
| unicode/compile/negated-class-matches-codepoint | 1 | 369.76 ± 18.4% | not timed | not timed | 55.45 ± 0.4% | 1370.52 ± 11.2% | not timed | not timed | 372.37 ± 2.6% | | 0.99 | 6.67 | 0.27 |
| wild/bibleref/compile | 3 | 6.04 ± 10.0% | not timed | not timed | 2.42 ± 1.6% | 34.34 ± 12.0% | not timed | not timed | 6.09 ± 23.0% | | 0.99 | 2.49 | 0.18 |
| wild/url/compile | 1 | 0.72 ± 7.7% | not timed | not timed | 0.20 ± 0.9% | 0.46 ± 23.3% | not timed | not timed | 0.72 ± 1.9% | | 1.00 | 3.53 | 1.58 |

