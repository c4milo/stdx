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
| literal: a word | 217 | 45676.40 ± 0.3% | 11964.69 ± 0.2% | 29.77 ± 1.2% | 39050.03 ± 0.3% | 12243.14 ± 4.3% | 12.91 ± 0.1% | 104.34 ± 0.3% | 45733.20 ± 0.1% | 3.82 | 1.00 | 1.17 | 3.73 |
| literal: a word that is not there | 0 | 64555.71 ± 0.2% | 11150.40 ± 0.3% | 29.83 ± 1.7% | 45746.37 ± 0.5% | 43564.93 ± 7.9% | 12.76 ± 0.4% | 98.52 ± 0.7% | 64493.65 ± 0.2% | 5.79 | 1.00 | 1.41 | 1.48 |
| literal: one of four words | 661 | 15637.64 ± 0.8% | 1670.19 ± 0.4% | 16.46 ± 0.4% | 11214.76 ± 0.2% | 24.95 ± 1.3% | 4.48 ± 0.2% | 8.25 ± 2.2% | 15653.58 ± 1.3% | 9.36 | 1.00 | 1.39 | 626.83 |
| literal: a word in any case | 217 | 40501.46 ± 0.6% | 1789.28 ± 0.4% | 22.47 ± 0.0% | 11359.74 ± 0.2% | 46.84 ± 0.6% | refused | differs | 40507.10 ± 0.1% | 22.64 | 1.00 | 3.57 | 864.65 |
| literal: an href attribute | 33 | 40743.37 ± 0.1% | 616.07 ± 0.3% | 28.77 ± 1.7% | 34973.82 ± 1.7% | 3058.73 ± 3.5% | 9.68 ± 0.1% | 91.26 ± 0.2% | 40792.54 ± 0.6% | 66.13 | 1.00 | 1.16 | 13.32 |
| literal: a word, second text | 123 | 49018.79 ± 0.3% | 6342.60 ± 0.6% | 29.40 ± 0.8% | 39496.47 ± 0.2% | 11601.58 ± 3.0% | 14.47 ± 0.3% | 87.43 ± 0.1% | 48934.02 ± 0.5% | 7.73 | 1.00 | 1.24 | 4.23 |
| class: two capitalized words | 1331 | 1150.20 ± 0.1% | 611.96 ± 0.3% | 27.86 ± 1.2% | 575.10 ± 0.2% | 44.38 ± 12.3% | 11.08 ± 0.4% | 78.46 ± 1.5% | 1149.75 ± 0.6% | 1.88 | 1.00 | 2.00 | 25.92 |
| class: a word that ends in ing | 3399 | 583.57 ± 0.5% | 584.97 ± 0.3% | 19.98 ± 0.9% | 539.78 ± 0.2% | 32.82 ± 1.7% | 6.23 ± 0.2% | 20.74 ± 0.5% | 585.23 ± 0.5% | 1.00 | 1.00 | 1.08 | 17.78 |
| class: a word in capitals | 2332 | 1573.58 ± 1.6% | 617.53 ± 0.3% | 29.38 ± 0.6% | 565.75 ± 0.4% | 47.18 ± 6.7% | 12.52 ± 0.5% | 101.05 ± 4.2% | 1574.04 ± 0.4% | 2.55 | 1.00 | 2.78 | 33.35 |
| class: a number | 8288 | 3192.97 ± 0.3% | 852.25 ± 0.3% | 29.54 ± 0.3% | 1781.03 ± 0.2% | 48.30 ± 12.6% | 0.39 ± 0.5% | 71.71 ± 16.1% | 3207.90 ± 1.3% | 3.75 | 1.00 | 1.79 | 66.10 |
| class: two capitalized words, second text | 5359 | 522.23 ± 0.6% | 529.30 ± 0.4% | 25.34 ± 5.7% | 478.22 ± 0.1% | 37.18 ± 7.0% | 12.73 ± 0.3% | 73.86 ± 19.7% | 522.46 ± 0.2% | 0.99 | 1.00 | 1.09 | 14.05 |
| other: a word between two words | 6104 | 859.38 ± 0.4% | 606.52 ± 0.1% | 25.20 ± 0.4% | 813.76 ± 1.3% | 127.65 ± 6.3% | 8.52 ± 0.3% | 81.11 ± 1.3% | 858.83 ± 0.5% | 1.42 | 1.00 | 1.06 | 6.73 |
| other: a number before a unit, second text | 1481 | 10568.67 ± 0.4% | 1185.17 ± 0.3% | 27.80 ± 1.0% | 8287.29 ± 0.6% | 44.75 ± 1.1% | 13.29 ± 0.4% | 77.75 ± 0.4% | 10580.24 ± 0.5% | 8.92 | 1.00 | 1.28 | 236.19 |
| other: a heading's start tag | 110 | 24822.24 ± 0.9% | 747.37 ± 0.3% | 29.56 ± 2.7% | 2573.24 ± 2.2% | 1967.39 ± 8.8% | 11.86 ± 1.0% | 106.84 ± 0.4% | 24812.81 ± 0.2% | 33.21 | 1.00 | 9.65 | 12.62 |
| other: a whole word | 217 | 32558.08 ± 1.5% | 608.01 ± 1.6% | 29.84 ± 0.7% | 28117.79 ± 10.9% | 54.30 ± 1.1% | 11.16 ± 0.5% | 62.38 ± 0.4% | 32566.77 ± 6.0% | 53.55 | 1.00 | 1.16 | 599.60 |
| other: a line's first word, second text | 3716 | 2454.65 ± 0.8% | 599.65 ± 0.3% | 32.11 ± 1.9% | 2283.95 ± 2.0% | 71.04 ± 3.3% | refused | refused | 2441.09 ± 1.1% | 4.09 | 1.01 | 1.07 | 34.55 |
| other: fourteen octets before an x | 87 | 35259.46 ± 0.9% | 251.80 ± 0.6% | 7.62 ± 0.8% | 3551.69 ± 0.2% | 11.57 ± 1.5% | differs | 20.20 ± 0.9% | 35194.27 ± 0.5% | 140.03 | 1.00 | 9.93 | 3047.47 |
| other: a Greek word | 21815 | 570.95 ± 0.9% | 439.26 ± 0.3% | 32.88 ± 7.4% | 303.36 ± 0.1% | 56.74 ± 6.6% | differs | refused | 573.36 ± 0.3% | 1.30 | 1.00 | 1.88 | 10.06 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 31.48 ± 1.3% | 30.05 ± 1.0% | 1.02 ± 1.5% | 19.82 ± 0.2% | 2.69 ± 0.3% | differs | 4.24 ± 9.0% | 31.36 ± 1.6% | 1.05 | 1.00 | 1.59 | 11.71 |
| a UUID | 32895 | 27.30 ± 3.1% | 27.41 ± 3.9% | 0.70 ± 4.7% | 14.98 ± 2.3% | 2.99 ± 1.0% | 0.51 ± 1.8% | 3.84 ± 1.9% | 27.43 ± 1.6% | 1.00 | 1.00 | 1.82 | 9.12 |
| an IPv4 address | 33176 | 39.72 ± 1.1% | 39.52 ± 0.3% | 2.29 ± 0.4% | 28.39 ± 1.5% | 6.94 ± 1.1% | differs | 4.18 ± 0.7% | 39.79 ± 2.5% | 1.01 | 1.00 | 1.40 | 5.72 |
| a date and time | 32954 | 38.00 ± 1.0% | 38.01 ± 2.4% | 1.68 ± 0.8% | 21.51 ± 2.0% | 8.18 ± 0.8% | 0.92 ± 2.7% | 7.71 ± 3.7% | 37.95 ± 3.7% | 1.00 | 1.00 | 1.77 | 4.65 |
| a field path | 32606 | 33.70 ± 2.0% | 33.54 ± 3.0% | 1.13 ± 1.2% | 22.80 ± 1.8% | 3.42 ± 3.3% | differs | 2.98 ± 0.6% | 33.47 ± 10.7% | 1.00 | 1.01 | 1.48 | 9.86 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.90 ± 0.9% | 10.93 ± 1.8% | 10.60 ± 8.4% | 13.38 ± 2.6% | 5.82 ± 2.1% | 0.76 ± 2.6% | none | 10.85 ± 2.5% | 1.00 | 1.00 | 0.81 | 1.87 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 253.58 ± 1.0% | 253.53 ± 1.4% | 297.98 ± 1.7% | 101.58 ± 2.0% | 245.45 ± 4.3% | 700.60 ± 17.2% | 4868.88 ± 1.5% | 252.51 ± 1.0% | 1.00 | 1.00 | 2.50 | 1.03 |
| a UUID | 62 | 168.69 ± 0.5% | 168.69 ± 1.3% | 187.82 ± 5.6% | 57.90 ± 4.7% | 116.52 ± 19.1% | 251.94 ± 2.5% | 5383.39 ± 0.5% | 163.03 ± 3.9% | 1.00 | 1.03 | 2.91 | 1.45 |
| an IPv4 address | 29 | 498.34 ± 0.3% | 497.12 ± 0.6% | 690.31 ± 0.5% | 87.60 ± 1.8% | 147.46 ± 15.7% | 420.02 ± 0.8% | 9028.98 ± 0.2% | 498.50 ± 0.9% | 1.00 | 1.00 | 5.69 | 3.38 |
| a date and time | 56 | 359.89 ± 0.8% | 360.12 ± 0.9% | 450.05 ± 0.3% | 85.07 ± 0.6% | 161.40 ± 1.4% | 470.88 ± 11.1% | 5549.12 ± 20.6% | 359.99 ± 1.2% | 1.00 | 1.00 | 4.23 | 2.23 |
| a field path | 39 | 252.28 ± 0.3% | 252.53 ± 2.4% | 296.70 ± 0.4% | 94.75 ± 2.2% | 227.68 ± 10.4% | 735.96 ± 1.3% | 5946.78 ± 0.9% | 252.57 ± 0.5% | 1.00 | 1.00 | 2.66 | 1.11 |
| literal: a word | 7 | 737.49 ± 0.2% | 791.18 ± 0.2% | 1404.71 ± 9.4% | 602.63 ± 4.3% | 794.05 ± 10.0% | 1597.78 ± 6.6% | 34094.28 ± 0.4% | 737.51 ± 0.4% | 0.93 | 1.00 | 1.22 | 0.93 |
| literal: a word that is not there | 8 | 708.77 ± 0.5% | 764.75 ± 0.2% | 1313.28 ± 0.4% | 558.85 ± 1.8% | 761.61 ± 1.4% | 1505.79 ± 0.3% | 33388.26 ± 1.0% | 711.34 ± 0.4% | 0.93 | 1.00 | 1.27 | 0.93 |
| literal: one of four words | 26 | 273.05 ± 0.8% | 444.99 ± 2.5% | 591.86 ± 4.4% | 53.35 ± 1.5% | 293.97 ± 2.4% | 593.36 ± 1.1% | 18319.73 ± 0.5% | 273.82 ± 0.5% | 0.61 | 1.00 | 5.12 | 0.93 |
| literal: a word in any case | 11 | 502.66 ± 1.0% | 532.20 ± 0.2% | 761.23 ± 1.0% | 19.27 ± 0.5% | 829.56 ± 1.6% | refused | 24792.73 ± 1.0% | 503.53 ± 2.0% | 0.94 | 1.00 | 26.09 | 0.61 |
| literal: an href attribute | 12 | 397.31 ± 0.6% | 413.16 ± 1.3% | 543.80 ± 1.3% | 50.53 ± 0.8% | 580.48 ± 1.0% | 1236.83 ± 2.1% | 24526.85 ± 1.3% | 396.98 ± 0.4% | 0.96 | 1.00 | 7.86 | 0.68 |
| literal: a word, second text | 10 | 655.09 ± 0.3% | 719.37 ± 0.3% | 1184.75 ± 0.3% | 480.75 ± 5.2% | 659.75 ± 19.2% | 1330.74 ± 0.4% | 31886.11 ± 0.4% | 657.05 ± 0.8% | 0.91 | 1.00 | 1.36 | 0.99 |
| class: two capitalized words | 23 | 509.86 ± 0.2% | 553.99 ± 10.6% | 797.38 ± 2.2% | 121.08 ± 1.5% | 588.08 ± 14.4% | 1213.76 ± 0.9% | 7917.88 ± 16.2% | 510.00 ± 0.4% | 0.92 | 1.00 | 4.21 | 0.87 |
| class: a word that ends in ing | 9 | 626.31 ± 1.2% | 727.68 ± 0.2% | 1248.25 ± 0.3% | 150.08 ± 1.0% | 859.94 ± 1.8% | 1774.75 ± 0.7% | 18989.71 ± 0.7% | 626.69 ± 0.2% | 0.86 | 1.00 | 4.17 | 0.73 |
| class: a word in capitals | 16 | 563.12 ± 0.2% | 617.22 ± 0.4% | 975.94 ± 0.2% | 156.65 ± 1.0% | 889.94 ± 11.8% | 1740.32 ± 2.1% | 10566.99 ± 0.1% | 563.45 ± 0.6% | 0.91 | 1.00 | 3.59 | 0.63 |
| class: a number | 6 | 701.12 ± 0.1% | 788.54 ± 0.2% | 1443.65 ± 0.7% | 47.11 ± 0.5% | 1643.34 ± 0.9% | 3038.20 ± 1.6% | 25884.66 ± 0.3% | 702.42 ± 0.8% | 0.89 | 1.00 | 14.88 | 0.43 |
| class: two capitalized words, second text | 23 | 509.09 ± 0.6% | 554.44 ± 0.2% | 796.69 ± 0.7% | 120.22 ± 0.8% | 603.34 ± 1.8% | 1244.08 ± 1.1% | 7949.69 ± 0.2% | 510.32 ± 0.5% | 0.92 | 1.00 | 4.23 | 0.84 |
| other: a word between two words | 13 | 632.06 ± 0.4% | 657.07 ± 0.6% | 1023.53 ± 0.7% | 156.21 ± 0.4% | 585.31 ± 2.1% | 1334.97 ± 4.5% | 17774.06 ± 0.4% | 632.32 ± 0.3% | 0.96 | 1.00 | 4.05 | 1.08 |
| other: a number before a unit, second text | 15 | 446.42 ± 0.2% | 507.06 ± 0.3% | 703.67 ± 0.4% | 44.21 ± 0.8% | 733.43 ± 0.3% | 1472.09 ± 1.6% | 17603.25 ± 0.9% | 446.95 ± 1.0% | 0.88 | 1.00 | 10.10 | 0.61 |
| other: a heading's start tag | 13 | 410.07 ± 0.4% | 418.98 ± 0.4% | 553.32 ± 0.6% | 48.47 ± 0.8% | 715.07 ± 2.7% | 1343.27 ± 1.0% | 20617.98 ± 0.3% | 410.26 ± 0.2% | 0.98 | 1.00 | 8.46 | 0.57 |
| other: a whole word | 11 | 654.00 ± 0.6% | 695.96 ± 0.2% | 1120.20 ± 0.4% | 142.39 ± 1.6% | 685.63 ± 2.1% | 1342.93 ± 0.5% | 31570.06 ± 0.9% | 654.30 ± 0.4% | 0.94 | 1.00 | 4.59 | 0.95 |
| other: a line's first word, second text | 17 | 588.71 ± 0.7% | 633.47 ± 0.2% | 998.07 ± 0.2% | 149.47 ± 0.6% | 808.41 ± 9.3% | refused | refused | 589.03 ± 0.1% | 0.93 | 1.00 | 3.94 | 0.73 |
| other: fourteen octets before an x | 16 | 113.87 ± 0.3% | 173.18 ± 0.9% | 204.34 ± 1.1% | 17.99 ± 0.3% | 522.43 ± 2.7% | 559.89 ± 0.7% | 15845.46 ± 0.3% | 113.95 ± 0.6% | 0.66 | 1.00 | 6.33 | 0.22 |
| other: a Greek word | 8 | 474.80 ± 0.5% | 669.07 ± 0.1% | 1091.16 ± 5.9% | 62.93 ± 6.3% | 1604.56 ± 1.9% | 2785.98 ± 1.2% | refused | 474.53 ± 4.7% | 0.71 | 1.00 | 7.54 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 34062.63 ± 0.8% | not timed | not timed | 33881.65 ± 0.8% | 2717.40 ± 10.4% | not timed | not timed | 34126.04 ± 17.8% | | 1.00 | 1.01 | 12.53 |
| 01-literal/sherlock-casei-en | 522 | 27565.00 ± 1.1% | not timed | not timed | 9047.81 ± 0.2% | 33.48 ± 0.7% | not timed | not timed | 27622.62 ± 0.6% | | 1.00 | 3.05 | 823.41 |
| 01-literal/sherlock-ru | 724 | 35826.98 ± 8.8% | not timed | not timed | 34457.93 ± 2.3% | 1287.36 ± 4.2% | not timed | not timed | 35876.46 ± 0.2% | | 1.00 | 1.04 | 27.83 |
| 01-literal/sherlock-casei-ru | 746 | 12411.27 ± 0.8% | not timed | not timed | 7772.07 ± 1.8% | 37.56 ± 3.6% | not timed | not timed | 12371.24 ± 0.3% | | 1.00 | 1.60 | 330.48 |
| 01-literal/sherlock-zh | 30 | 60549.25 ± 0.5% | not timed | not timed | 43079.40 ± 0.1% | 1637.24 ± 0.4% | not timed | not timed | 60663.62 ± 1.1% | | 1.00 | 1.41 | 36.98 |
| 02-literal-alternate/sherlock-en | 714 | 14117.56 ± 0.3% | not timed | not timed | 10927.62 ± 0.5% | 16.65 ± 1.1% | not timed | not timed | 14108.69 ± 0.4% | | 1.00 | 1.29 | 848.02 |
| 02-literal-alternate/sherlock-casei-en | 725 | 5182.38 ± 2.7% | not timed | not timed | 2300.65 ± 1.2% | 11.56 ± 0.7% | not timed | not timed | 5189.07 ± 4.0% | | 1.00 | 2.25 | 448.48 |
| 02-literal-alternate/sherlock-ru | 899 | 10843.92 ± 0.5% | not timed | not timed | 9787.66 ± 1.1% | 25.43 ± 8.3% | not timed | not timed | 10822.16 ± 0.5% | | 1.00 | 1.11 | 426.50 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2527.71 ± 4.3% | not timed | not timed | 1188.13 ± 0.4% | 10.56 ± 2.0% | not timed | not timed | 2521.93 ± 3.1% | | 1.00 | 2.13 | 239.45 |
| 02-literal-alternate/sherlock-zh | 207 | 19936.45 ± 0.8% | not timed | not timed | 12661.46 ± 0.3% | 35.00 ± 0.4% | not timed | not timed | 19945.19 ± 0.1% | | 1.00 | 1.57 | 569.64 |
| 03-date/ascii | 111817 | 145.80 ± 1.0% | not timed | not timed | 100.47 ± 1.1% | 0.23 ± 1.7% | not timed | not timed | 145.79 ± 1.3% | | 1.00 | 1.45 | 645.51 |
| 04-ruff-noqa/real | 84 | 507.41 ± 4.4% | not timed | not timed | 514.77 ± 3.6% | 21.19 ± 1.8% | not timed | not timed | 505.30 ± 0.5% | | 1.00 | 0.99 | 23.95 |
| 04-ruff-noqa/tweaked | 44 | 895.46 ± 10.4% | not timed | not timed | 516.42 ± 0.3% | 372.05 ± 0.3% | not timed | not timed | 895.81 ± 10.8% | | 1.00 | 1.73 | 2.41 |
| 05-lexer-veryl/single | 124800 | 4.76 ± 0.5% | not timed | not timed | 5.17 ± 0.4% | 0.25 ± 1.9% | not timed | not timed | 4.81 ± 1.2% | | 0.99 | 0.92 | 18.76 |
| 06-cloud-flare-redos/original | 107 | 451.01 ± 0.3% | not timed | not timed | 227.57 ± 16.0% | 25.33 ± 0.5% | not timed | not timed | 448.26 ± 0.3% | | 1.01 | 1.98 | 17.81 |
| 06-cloud-flare-redos/simplified-short | 102 | 450.36 ± 0.2% | not timed | not timed | 233.15 ± 0.4% | 23.71 ± 0.4% | not timed | not timed | 450.33 ± 0.3% | | 1.00 | 1.93 | 18.99 |
| 06-cloud-flare-redos/simplified-long | 10000 | 584.11 ± 0.2% | not timed | not timed | 259.29 ± 1.4% | 29.63 ± 0.4% | not timed | not timed | 583.71 ± 0.1% | | 1.00 | 2.25 | 19.72 |
| 07-unicode-character-data/parse-line | 558784 | 234.66 ± 2.7% | not timed | not timed | 202.01 ± 0.7% | 47.45 ± 6.9% | not timed | not timed | 251.29 ± 4.8% | | 0.93 | 1.16 | 4.95 |
| 08-words/all-english | 56691 | 132.28 ± 2.0% | not timed | not timed | 84.34 ± 5.7% | 13.37 ± 16.7% | not timed | not timed | 132.70 ± 1.5% | | 1.00 | 1.57 | 9.89 |
| 08-words/long-english | 839 | 620.05 ± 0.2% | not timed | not timed | 584.55 ± 0.1% | 35.08 ± 0.3% | not timed | not timed | 618.32 ± 0.2% | | 1.00 | 1.06 | 17.68 |
| 09-aws-keys/full | 0 | 518.28 ± 0.3% | not timed | not timed | 543.54 ± 0.8% | 67.27 ± 2.6% | not timed | not timed | 515.50 ± 2.4% | | 1.01 | 0.95 | 7.70 |
| 09-aws-keys/quick | 0 | 1147.85 ± 0.5% | not timed | not timed | 958.43 ± 1.0% | 417.65 ± 1.0% | not timed | not timed | 1147.65 ± 0.1% | | 1.00 | 1.20 | 2.75 |
| 10-bounded-repeat/letters-en | 1833 | 680.30 ± 1.6% | not timed | not timed | 555.55 ± 0.4% | 22.74 ± 1.0% | not timed | not timed | 682.63 ± 0.6% | | 1.00 | 1.22 | 29.92 |
| 10-bounded-repeat/letters-ru | 3475 | 522.08 ± 2.9% | not timed | not timed | 481.28 ± 1.8% | 24.24 ± 17.0% | not timed | not timed | 526.96 ± 3.5% | | 0.99 | 1.08 | 21.54 |
| 10-bounded-repeat/context | 53 | 90.92 ± 1.8% | not timed | not timed | 69.57 ± 0.8% | 22.50 ± 0.7% | not timed | not timed | 90.88 ± 1.3% | | 1.00 | 1.31 | 4.04 |
| 10-bounded-repeat/capitals | 11 | 639.67 ± 8.1% | not timed | not timed | 604.21 ± 0.2% | 40.05 ± 0.6% | not timed | not timed | 642.41 ± 8.4% | | 1.00 | 1.06 | 15.97 |
| 11-unstructured-to-json/extract | 600 | 51.93 ± 2.3% | not timed | not timed | 80.79 ± 1.1% | 50.55 ± 1.5% | not timed | not timed | 52.11 ± 0.9% | | 1.00 | 0.64 | 1.03 |
| 12-dictionary/single | 1 | 510.99 ± 1.6% | not timed | not timed | 481.45 ± 0.2% | 0.38 ± 2.3% | not timed | not timed | 515.79 ± 1.7% | | 0.99 | 1.06 | 1334.81 |
| 14-quadratic/1x | 100 | 28.48 ± 1.8% | not timed | not timed | 12.15 ± 0.3% | 0.99 ± 4.2% | not timed | not timed | 28.40 ± 0.8% | | 1.00 | 2.34 | 28.67 |
| 14-quadratic/2x | 200 | 25.56 ± 0.2% | not timed | not timed | 6.12 ± 0.2% | 0.55 ± 1.5% | not timed | not timed | 25.49 ± 1.4% | | 1.00 | 4.18 | 46.84 |
| 14-quadratic/10x | 1000 | 15.05 ± 1.6% | not timed | not timed | 1.22 ± 0.3% | 0.12 ± 0.7% | not timed | not timed | 15.12 ± 0.7% | | 1.00 | 12.38 | 127.31 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.40 ± 0.5% | not timed | not timed | 0.48 ± 0.5% | 0.64 ± 3.5% | not timed | not timed | 1.40 ± 0.5% | | 1.00 | 2.92 | 2.19 |
| 04-ruff-noqa/compile-real | 1 | 121.72 ± 1.0% | not timed | not timed | 17.28 ± 0.6% | 170.16 ± 13.6% | not timed | not timed | 121.79 ± 2.1% | | 1.00 | 7.05 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 16.60 ± 1.6% | not timed | not timed | 2.97 ± 2.3% | 7.86 ± 1.6% | not timed | not timed | 16.69 ± 0.3% | | 0.99 | 5.59 | 2.11 |
| 07-unicode-character-data/compile | 1 | 126.49 ± 11.7% | not timed | not timed | 30.44 ± 0.7% | 44.24 ± 1.4% | not timed | not timed | 126.73 ± 0.3% | | 1.00 | 4.16 | 2.86 |
| 09-aws-keys/compile-full | 1 | 55.72 ± 0.7% | not timed | not timed | 9.93 ± 14.2% | 28.00 ± 1.2% | not timed | not timed | 55.90 ± 2.0% | | 1.00 | 5.61 | 1.99 |
| 09-aws-keys/compile-quick | 1 | 195.63 ± 0.6% | not timed | not timed | 58.03 ± 0.3% | 156.46 ± 0.7% | not timed | not timed | 196.66 ± 0.3% | | 0.99 | 3.37 | 1.25 |
| 10-bounded-repeat/compile-context | 1 | 60.13 ± 1.0% | not timed | not timed | 14.40 ± 9.5% | 20.15 ± 5.9% | not timed | not timed | 60.53 ± 0.6% | | 0.99 | 4.18 | 2.98 |
| 10-bounded-repeat/compile-capitals | 1 | 94.87 ± 11.4% | not timed | not timed | 10.67 ± 0.6% | 29.49 ± 2.2% | not timed | not timed | 95.25 ± 1.2% | | 1.00 | 8.89 | 3.22 |
| 11-unstructured-to-json/compile | 1 | 191.66 ± 0.9% | not timed | not timed | 47.40 ± 0.8% | 80.80 ± 2.9% | not timed | not timed | 193.24 ± 0.9% | | 0.99 | 4.04 | 2.37 |
| 12-dictionary/compile-single | 1 | 0.34 ± 10.8% | not timed | not timed | 0.09 ± 5.1% | 0.11 ± 27.9% | not timed | not timed | 0.34 ± 0.9% | | 0.99 | 3.99 | 3.08 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.24 ± 1.0% | not timed | not timed | 6.74 ± 16.0% | 0.62 ± 20.8% | not timed | not timed | 7.24 ± 0.8% | | 1.00 | 1.07 | 11.58 |
| dictionary/search/english-10 | 690 | 213.37 ± 1.7% | not timed | not timed | 153.79 ± 1.2% | 0.01 ± 0.3% | not timed | not timed | 212.48 ± 0.9% | | 1.00 | 1.39 | 30586.10 |
| dictionary/search/english-15 | 15 | 509.67 ± 1.5% | not timed | not timed | 482.55 ± 0.1% | 0.37 ± 2.6% | not timed | not timed | 514.61 ± 1.6% | | 0.99 | 1.06 | 1390.97 |
| folly/awyer-inn-busted | 1 | 24105.96 ± 0.4% | not timed | not timed | 131.87 ± 0.6% | 48.38 ± 0.5% | not timed | not timed | 24101.61 ± 0.3% | | 1.00 | 182.80 | 498.28 |
| folly/literal-never-match-rare | 0 | 67798.30 ± 0.6% | not timed | not timed | 46464.00 ± 0.8% | 69443.89 ± 0.4% | not timed | not timed | 67719.27 ± 1.5% | | 1.00 | 1.46 | 0.98 |
| folly/literal-never-match-frequent | 0 | 28778.47 ± 9.9% | not timed | not timed | 46152.78 ± 0.7% | 2586.25 ± 0.6% | not timed | not timed | 28974.24 ± 18.0% | | 0.99 | 0.62 | 11.13 |
| folly/literal-never-match-tricksy | 1 | 3981.67 ± 0.6% | not timed | not timed | 6149.65 ± 0.4% | 1721.73 ± 1.1% | not timed | not timed | 3921.56 ± 0.4% | | 1.02 | 0.65 | 2.31 |
| grep/every-line | 239963 | 1413.59 ± 0.4% | not timed | not timed | 959.56 ± 0.5% | 379.13 ± 18.5% | not timed | not timed | 1418.01 ± 1.2% | | 1.00 | 1.47 | 3.73 |
| grep/long-words-ascii | 5073 | 501.03 ± 1.0% | not timed | not timed | 460.59 ± 0.4% | 51.55 ± 8.2% | not timed | not timed | 501.84 ± 0.7% | | 1.00 | 1.09 | 9.72 |
| imported/leipzig/twain | 811 | 57105.47 ± 1.0% | not timed | not timed | 43817.61 ± 0.2% | 13126.31 ± 12.3% | not timed | not timed | 57131.07 ± 0.4% | | 1.00 | 1.30 | 4.35 |
| imported/leipzig/twain-insensitive | 965 | 15213.33 ± 0.7% | not timed | not timed | 13502.96 ± 0.3% | 43.30 ± 0.2% | not timed | not timed | 15243.43 ± 1.0% | | 1.00 | 1.13 | 351.36 |
| imported/leipzig/shing | 1540 | 29130.56 ± 0.8% | not timed | not timed | 22332.48 ± 0.2% | 36.06 ± 2.8% | not timed | not timed | 29103.71 ± 0.4% | | 1.00 | 1.30 | 807.86 |
| imported/leipzig/huck-saw | 262 | 24989.82 ± 0.7% | not timed | not timed | 18772.98 ± 0.6% | 35.44 ± 0.5% | not timed | not timed | 24990.46 ± 2.2% | | 1.00 | 1.33 | 705.23 |
| imported/leipzig/word-ending-nn | 262 | 608.47 ± 0.4% | not timed | not timed | 602.42 ± 0.6% | 25.12 ± 2.1% | not timed | not timed | 609.66 ± 1.2% | | 1.00 | 1.01 | 24.22 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 10812.70 ± 1.1% | not timed | not timed | 3871.92 ± 3.7% | 11.69 ± 2.4% | not timed | not timed | 10800.84 ± 0.4% | | 1.00 | 2.79 | 924.75 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 21409.46 ± 1.6% | not timed | not timed | 17671.88 ± 0.9% | 18.95 ± 1.0% | not timed | not timed | 21520.73 ± 9.7% | | 0.99 | 1.21 | 1129.87 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5531.20 ± 0.9% | not timed | not timed | 791.39 ± 0.1% | 11.89 ± 2.9% | not timed | not timed | 5522.38 ± 0.3% | | 1.00 | 6.99 | 465.17 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 18009.71 ± 0.6% | not timed | not timed | 602.29 ± 0.3% | 8.78 ± 0.7% | not timed | not timed | 18056.04 ± 0.6% | | 1.00 | 29.90 | 2051.41 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 16952.52 ± 1.6% | not timed | not timed | 602.00 ± 3.2% | 7.83 ± 0.8% | not timed | not timed | 16982.51 ± 12.4% | | 1.00 | 28.16 | 2164.33 |
| imported/leipzig/tom-river | 2 | 12953.35 ± 1.6% | not timed | not timed | 13460.73 ± 0.9% | 34.45 ± 0.4% | not timed | not timed | 12929.07 ± 1.0% | | 1.00 | 0.96 | 376.05 |
| imported/leipzig/ing | 78424 | 600.02 ± 1.1% | not timed | not timed | 560.93 ± 1.4% | 28.43 ± 3.3% | not timed | not timed | 600.34 ± 0.8% | | 1.00 | 1.07 | 21.11 |
| imported/leipzig/ing-whitespace | 55248 | 1921.81 ± 1.4% | not timed | not timed | 2136.51 ± 1.0% | 20.79 ± 3.6% | not timed | not timed | 1923.57 ± 5.5% | | 1.00 | 0.90 | 92.43 |
| imported/leipzig/awyer-inn | 209 | 10956.64 ± 0.3% | not timed | not timed | 13790.62 ± 0.2% | 21.64 ± 1.6% | not timed | not timed | 10964.59 ± 0.3% | | 1.00 | 0.79 | 506.35 |
| imported/leipzig/quotes-bounded | 8886 | 2314.14 ± 0.7% | not timed | not timed | 3280.07 ± 2.0% | 40.36 ± 0.5% | not timed | not timed | 2298.71 ± 6.1% | | 1.01 | 0.71 | 57.34 |
| imported/leipzig/non-ascii-alternate | 2 | 40521.32 ± 1.9% | not timed | not timed | 19460.30 ± 1.9% | 56.82 ± 0.9% | not timed | not timed | 40598.91 ± 2.5% | | 1.00 | 2.08 | 713.21 |
| imported/leipzig/math-symbols | 69 | 2426.50 ± 0.3% | not timed | not timed | 603.50 ± 0.2% | 39.33 ± 4.1% | not timed | not timed | 2434.60 ± 2.8% | | 1.00 | 4.02 | 61.69 |
| imported/leipzig/bounded-strings-ending-z | 0 | 609.68 ± 0.1% | not timed | not timed | 604.43 ± 0.1% | 19.81 ± 1.4% | not timed | not timed | 609.78 ± 0.2% | | 1.00 | 1.01 | 30.78 |
| imported/lh3lh3-reb/uri | 17549 | 805.56 ± 0.2% | not timed | not timed | 1128.59 ± 0.9% | 30.74 ± 4.9% | not timed | not timed | 806.96 ± 1.3% | | 1.00 | 0.71 | 26.21 |
| imported/lh3lh3-reb/email | 15057 | 800.19 ± 0.7% | not timed | not timed | 1128.98 ± 1.1% | 33.38 ± 3.9% | not timed | not timed | 800.92 ± 0.4% | | 1.00 | 0.71 | 23.97 |
| imported/lh3lh3-reb/date | 668 | 940.37 ± 1.0% | not timed | not timed | 1013.16 ± 2.0% | 53.92 ± 6.2% | not timed | not timed | 939.30 ± 0.7% | | 1.00 | 0.93 | 17.44 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 744.13 ± 0.7% | not timed | not timed | 443.50 ± 1.6% | 16.53 ± 2.1% | not timed | not timed | 742.87 ± 17.5% | | 1.00 | 1.68 | 45.01 |
| imported/mariomka/email | 92 | 39325.44 ± 1.3% | not timed | not timed | 59707.17 ± 2.0% | 35.70 ± 1.0% | not timed | not timed | 39275.56 ± 0.8% | | 1.00 | 0.66 | 1101.46 |
| imported/mariomka/uri | 5301 | 6574.43 ± 1.2% | not timed | not timed | 7902.34 ± 0.2% | 35.74 ± 0.6% | not timed | not timed | 6585.46 ± 0.6% | | 1.00 | 0.83 | 183.94 |
| imported/mariomka/ip | 5 | 2544.95 ± 2.9% | not timed | not timed | 2299.20 ± 0.6% | 22.85 ± 6.8% | not timed | not timed | 2545.08 ± 3.4% | | 1.00 | 1.11 | 111.36 |
| imported/rsc/no-exponential | 0 | 886.11 ± 19.0% | not timed | not timed | 423.33 ± 0.4% | 21.87 ± 0.4% | not timed | not timed | 862.62 ± 1.2% | | 1.03 | 2.09 | 40.51 |
| imported/rsc/literal | 1 | 1914.84 ± 10.5% | not timed | not timed | 2219.01 ± 0.7% | 241.56 ± 90.7% | not timed | not timed | 1928.43 ± 5.2% | | 0.99 | 0.86 | 7.93 |
| imported/rsc/not-literal | 2 | 961.73 ± 2.6% | not timed | not timed | 842.23 ± 14.6% | 54.51 ± 9.5% | not timed | not timed | 958.86 ± 0.8% | | 1.00 | 1.14 | 17.64 |
| imported/rsc/match-class | 1 | 1901.44 ± 0.6% | not timed | not timed | 1811.10 ± 17.3% | 68.12 ± 8.9% | not timed | not timed | 1895.89 ± 1.6% | | 1.00 | 1.05 | 27.91 |
| imported/rsc/match-class-in-range | 1 | 1897.34 ± 18.2% | not timed | not timed | 3371.43 ± 0.6% | 70.44 ± 7.1% | not timed | not timed | 1889.71 ± 17.6% | | 1.00 | 0.56 | 26.93 |
| imported/rsc/match-class-unicode | 1 | 570.10 ± 2.7% | not timed | not timed | 517.63 ± 0.4% | 83.01 ± 7.8% | not timed | not timed | 570.26 ± 0.3% | | 1.00 | 1.10 | 6.87 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1585.50 ± 1.1% | not timed | not timed | 1142.68 ± 0.2% | 345.76 ± 11.3% | not timed | not timed | 1583.67 ± 0.2% | | 1.00 | 1.39 | 4.59 |
| imported/rsc/anchored-literal-long-non-match | 0 | 23775.86 ± 0.4% | not timed | not timed | 17225.58 ± 8.9% | 5187.71 ± 10.2% | not timed | not timed | 23741.23 ± 0.6% | | 1.00 | 1.38 | 4.58 |
| imported/rsc/anchored-literal-short-match | 4 | 832.58 ± 1.7% | not timed | not timed | 570.77 ± 0.3% | 109.57 ± 9.2% | not timed | not timed | 840.25 ± 1.4% | | 0.99 | 1.46 | 7.60 |
| imported/rsc/anchored-literal-long-match | 4 | 12450.72 ± 26.9% | not timed | not timed | 8519.52 ± 4.9% | 1637.98 ± 13.5% | not timed | not timed | 12612.30 ± 8.6% | | 0.99 | 1.46 | 7.60 |
| imported/rsc/one-pass-short | 17 | 482.23 ± 6.1% | not timed | not timed | 259.91 ± 0.5% | 36.49 ± 11.5% | not timed | not timed | 478.54 ± 1.8% | | 1.01 | 1.86 | 13.22 |
| imported/rsc/one-pass-short-not | 17 | 325.98 ± 3.0% | not timed | not timed | 263.55 ± 1.4% | 34.29 ± 13.7% | not timed | not timed | 328.48 ± 3.8% | | 0.99 | 1.24 | 9.51 |
| imported/rsc/one-pass-long-prefix | 26 | 433.46 ± 6.4% | not timed | not timed | 321.82 ± 1.6% | 128.12 ± 15.0% | not timed | not timed | 443.11 ± 1.7% | | 0.98 | 1.35 | 3.38 |
| imported/rsc/one-pass-long-prefix-not | 26 | 440.08 ± 2.2% | not timed | not timed | 322.32 ± 0.6% | 90.31 ± 14.4% | not timed | not timed | 446.99 ± 6.6% | | 0.98 | 1.37 | 4.87 |
| imported/rsc/long-needle1 | 31 | 67980.45 ± 0.2% | not timed | not timed | 45875.22 ± 0.5% | 4.19 ± 1.3% | not timed | not timed | 67861.33 ± 1.3% | | 1.00 | 1.48 | 16206.76 |
| imported/rsc/long-needle2 | 31 | 67521.15 ± 0.3% | not timed | not timed | 227.10 ± 0.3% | 4.19 ± 0.3% | not timed | not timed | 67441.48 ± 0.5% | | 1.00 | 297.32 | 16111.76 |
| imported/rsc/easy0-32 | 26 | 1991.17 ± 2.1% | not timed | not timed | 1936.78 ± 0.5% | 162.29 ± 21.5% | not timed | not timed | 2013.73 ± 2.1% | | 0.99 | 1.03 | 12.27 |
| imported/rsc/easy0-1k | 26 | 16705.67 ± 0.9% | not timed | not timed | 20395.65 ± 0.5% | 2622.73 ± 13.6% | not timed | not timed | 16629.85 ± 2.0% | | 1.00 | 0.82 | 6.37 |
| imported/rsc/easy0-32k | 26 | 63481.48 ± 6.5% | not timed | not timed | 43694.47 ± 0.1% | 26238.67 ± 12.6% | not timed | not timed | 63425.76 ± 0.8% | | 1.00 | 1.45 | 2.42 |
| imported/rsc/easy0-1mb | 26 | 65867.42 ± 0.2% | not timed | not timed | 46319.83 ± 0.7% | 67028.55 ± 0.3% | not timed | not timed | 65946.75 ± 0.3% | | 1.00 | 1.42 | 0.98 |
| imported/rsc/easy1-32 | 19 | 930.25 ± 3.1% | not timed | not timed | 763.48 ± 0.1% | 151.37 ± 11.6% | not timed | not timed | 932.74 ± 2.4% | | 1.00 | 1.22 | 6.15 |
| imported/rsc/easy1-1k | 19 | 18960.57 ± 2.5% | not timed | not timed | 15607.67 ± 0.3% | 2725.87 ± 17.7% | not timed | not timed | 19051.55 ± 2.7% | | 1.00 | 1.21 | 6.96 |
| imported/rsc/easy1-32k | 19 | 597214.94 ± 2.8% | not timed | not timed | 489013.49 ± 0.9% | 29303.45 ± 42.7% | not timed | not timed | 599491.74 ± 0.4% | | 1.00 | 1.22 | 20.38 |
| imported/rsc/easy1-1mb | 19 | 19099212.37 ± 1.3% | not timed | not timed | 15692773.37 ± 0.4% | 67811.40 ± 0.4% | not timed | not timed | 19165134.84 ± 1.2% | | 1.00 | 1.22 | 281.65 |
| imported/rsc/medium-32 | 27 | 876.38 ± 6.0% | not timed | not timed | 744.35 ± 0.4% | 83.08 ± 22.0% | not timed | not timed | 874.23 ± 1.5% | | 1.00 | 1.18 | 10.55 |
| imported/rsc/medium-1k | 27 | 15627.97 ± 0.4% | not timed | not timed | 13201.46 ± 0.6% | 82.83 ± 0.6% | not timed | not timed | 15657.62 ± 0.9% | | 1.00 | 1.18 | 188.68 |
| imported/rsc/medium-32k | 27 | 487527.31 ± 0.5% | not timed | not timed | 412578.63 ± 0.3% | 53.50 ± 4.2% | not timed | not timed | 488569.97 ± 0.9% | | 1.00 | 1.18 | 9112.36 |
| imported/rsc/medium-1mb | 27 | 15613598.85 ± 0.5% | not timed | not timed | 12906870.03 ± 0.3% | 54.31 ± 0.3% | not timed | not timed | 15553140.88 ± 0.7% | | 1.00 | 1.21 | 287485.17 |
| imported/rsc/hard-32 | 58 | 450.12 ± 0.4% | not timed | not timed | 388.42 ± 0.3% | 53.03 ± 7.6% | not timed | not timed | 450.02 ± 5.0% | | 1.00 | 1.16 | 8.49 |
| imported/rsc/hard-1k | 27 | 14913.35 ± 3.4% | not timed | not timed | 13102.74 ± 0.3% | 44.76 ± 0.5% | not timed | not timed | 14977.78 ± 0.2% | | 1.00 | 1.14 | 333.17 |
| imported/rsc/hard-32k | 27 | 466238.74 ± 1.9% | not timed | not timed | 402978.66 ± 0.4% | 32.92 ± 3.6% | not timed | not timed | 465167.50 ± 0.4% | | 1.00 | 1.16 | 14161.92 |
| imported/rsc/hard-1mb | 51 | 9009467.13 ± 0.4% | not timed | not timed | 7814789.54 ± 1.3% | 33.10 ± 0.2% | not timed | not timed | 8994570.96 ± 0.7% | | 1.00 | 1.15 | 272195.66 |
| imported/rsc/reallyhard0-32 | 58 | 280.57 ± 0.5% | not timed | not timed | 246.16 ± 0.6% | 53.15 ± 7.4% | not timed | not timed | 274.45 ± 2.3% | | 1.02 | 1.14 | 5.28 |
| imported/rsc/reallyhard0-1k | 27 | 590.60 ± 0.2% | not timed | not timed | 580.57 ± 0.8% | 44.78 ± 0.5% | not timed | not timed | 590.57 ± 2.1% | | 1.00 | 1.02 | 13.19 |
| imported/rsc/reallyhard0-32k | 27 | 608.61 ± 0.1% | not timed | not timed | 602.89 ± 0.4% | 32.74 ± 23.0% | not timed | not timed | 608.92 ± 0.3% | | 1.00 | 1.01 | 18.59 |
| imported/rsc/reallyhard0-1mb | 51 | 609.14 ± 0.1% | not timed | not timed | 604.37 ± 0.2% | 33.07 ± 0.2% | not timed | not timed | 609.84 ± 0.5% | | 1.00 | 1.01 | 18.42 |
| imported/rsc/reallyreallyhard0-32 | 47 | 331.71 ± 1.5% | not timed | not timed | 209.03 ± 0.5% | 66.45 ± 12.9% | not timed | not timed | 331.07 ± 3.0% | | 1.00 | 1.59 | 4.99 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7644.82 ± 0.4% | not timed | not timed | 7684.15 ± 1.5% | 36.90 ± 0.7% | not timed | not timed | 7672.24 ± 11.3% | | 1.00 | 0.99 | 207.19 |
| imported/rsc/reallyreallyhard0-32k | 16 | 52200.74 ± 1.3% | not timed | not timed | 35520.59 ± 0.9% | 24.34 ± 0.1% | not timed | not timed | 52069.36 ± 0.2% | | 1.00 | 1.47 | 2144.71 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 70322.18 ± 0.9% | not timed | not timed | 44539.93 ± 16.5% | 24.60 ± 0.4% | not timed | not timed | 70443.35 ± 1.2% | | 1.00 | 1.58 | 2858.85 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 307.81 ± 10.9% | not timed | not timed | 215.59 ± 1.4% | 65.91 ± 10.8% | not timed | not timed | 316.01 ± 1.4% | | 0.97 | 1.43 | 4.67 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 6377.94 ± 0.9% | not timed | not timed | 7532.54 ± 1.5% | 36.90 ± 2.1% | not timed | not timed | 6374.01 ± 0.2% | | 1.00 | 0.85 | 172.85 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 48734.47 ± 1.1% | not timed | not timed | 36652.38 ± 1.3% | 24.47 ± 1.0% | not timed | not timed | 48761.78 ± 1.7% | | 1.00 | 1.33 | 1991.40 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 62941.29 ± 0.5% | not timed | not timed | 45359.46 ± 1.0% | 24.59 ± 0.2% | not timed | not timed | 63255.80 ± 0.4% | | 1.00 | 1.39 | 2560.01 |
| imported/sherlock/name-sherlock | 776 | 47789.08 ± 2.2% | not timed | not timed | 40123.29 ± 0.8% | 12007.73 ± 8.2% | not timed | not timed | 48077.51 ± 2.0% | | 0.99 | 1.19 | 3.98 |
| imported/sherlock/name-holmes | 2766 | 23418.61 ± 6.6% | not timed | not timed | 30394.93 ± 1.2% | 3810.59 ± 6.5% | not timed | not timed | 23808.59 ± 2.1% | | 0.98 | 0.77 | 6.15 |
| imported/sherlock/name-sherlock-holmes | 1365 | 48352.05 ± 1.5% | not timed | not timed | 40329.59 ± 2.2% | 10292.54 ± 23.3% | not timed | not timed | 48542.93 ± 1.0% | | 1.00 | 1.20 | 4.70 |
| imported/sherlock/name-sherlock-casei | 816 | 44359.58 ± 0.7% | not timed | not timed | 11610.68 ± 0.2% | 32.93 ± 1.4% | not timed | not timed | 44317.36 ± 0.9% | | 1.00 | 3.82 | 1347.25 |
| imported/sherlock/name-holmes-casei | 2802 | 19809.67 ± 1.2% | not timed | not timed | 7531.22 ± 0.6% | 43.43 ± 1.7% | not timed | not timed | 19776.63 ± 0.3% | | 1.00 | 2.63 | 456.13 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 35250.46 ± 0.3% | not timed | not timed | 11219.88 ± 1.1% | 32.77 ± 1.1% | not timed | not timed | 35257.33 ± 0.1% | | 1.00 | 3.14 | 1075.59 |
| imported/sherlock/name-whitespace | 1461 | 28146.31 ± 5.2% | not timed | not timed | 28111.42 ± 0.5% | 8100.92 ± 23.8% | not timed | not timed | 28061.55 ± 9.3% | | 1.00 | 1.00 | 3.47 |
| imported/sherlock/name-alt1 | 1142 | 29240.77 ± 6.0% | not timed | not timed | 29848.36 ± 7.1% | 5394.46 ± 22.0% | not timed | not timed | 29206.82 ± 2.4% | | 1.00 | 0.98 | 5.42 |
| imported/sherlock/name-alt2 | 3542 | 17913.47 ± 1.7% | not timed | not timed | 10088.65 ± 0.2% | 34.99 ± 0.2% | not timed | not timed | 17939.71 ± 0.3% | | 1.00 | 1.78 | 511.98 |
| imported/sherlock/name-alt3 | 4507 | 11797.90 ± 0.4% | not timed | not timed | 9209.55 ± 0.2% | 10.07 ± 0.6% | not timed | not timed | 11772.83 ± 0.8% | | 1.00 | 1.28 | 1171.22 |
| imported/sherlock/name-alt3-casei | 4593 | 3581.69 ± 3.2% | not timed | not timed | 1307.31 ± 3.0% | 6.99 ± 1.1% | not timed | not timed | 3578.38 ± 24.4% | | 1.00 | 2.74 | 512.11 |
| imported/sherlock/name-alt4 | 3686 | 10004.17 ± 0.3% | not timed | not timed | 8174.24 ± 0.3% | 35.41 ± 32.5% | not timed | not timed | 10032.40 ± 0.2% | | 1.00 | 1.22 | 282.53 |
| imported/sherlock/name-alt4-casei | 4254 | 5441.41 ± 7.2% | not timed | not timed | 4476.80 ± 8.7% | 20.41 ± 0.9% | not timed | not timed | 5485.86 ± 1.6% | | 0.99 | 1.22 | 266.63 |
| imported/sherlock/name-alt5 | 4028 | 14954.32 ± 13.6% | not timed | not timed | 9675.68 ± 0.0% | 23.66 ± 0.5% | not timed | not timed | 14974.66 ± 0.2% | | 1.00 | 1.55 | 632.10 |
| imported/sherlock/name-alt5-casei | 4104 | 7036.52 ± 0.3% | not timed | not timed | 3003.83 ± 0.7% | 15.04 ± 32.3% | not timed | not timed | 7026.61 ± 0.4% | | 1.00 | 2.34 | 467.95 |
| imported/sherlock/no-match-uncommon | 0 | 69452.68 ± 0.3% | not timed | not timed | 58097.84 ± 0.2% | 58433.85 ± 1.3% | not timed | not timed | 69377.29 ± 15.5% | | 1.00 | 1.20 | 1.19 |
| imported/sherlock/no-match-common | 0 | 67702.05 ± 0.4% | not timed | not timed | 57972.13 ± 6.7% | 2021.96 ± 6.3% | not timed | not timed | 67963.17 ± 2.6% | | 1.00 | 1.17 | 33.48 |
| imported/sherlock/no-match-really-common | 0 | 43283.73 ± 0.7% | not timed | not timed | 49770.42 ± 0.6% | 2155.14 ± 1.0% | not timed | not timed | 42647.70 ± 0.6% | | 1.01 | 0.87 | 20.08 |
| imported/sherlock/the-lower | 21654 | 3384.15 ± 0.7% | not timed | not timed | 4463.26 ± 2.8% | 273.69 ± 22.8% | not timed | not timed | 3372.99 ± 5.6% | | 1.00 | 0.76 | 12.36 |
| imported/sherlock/the-upper | 2223 | 17247.26 ± 1.2% | not timed | not timed | 29334.36 ± 0.3% | 3023.00 ± 15.4% | not timed | not timed | 17271.62 ± 1.1% | | 1.00 | 0.59 | 5.71 |
| imported/sherlock/the-casei | 23961 | 3025.06 ± 0.9% | not timed | not timed | 1364.88 ± 0.2% | 39.69 ± 27.3% | not timed | not timed | 3029.73 ± 10.6% | | 1.00 | 2.22 | 76.22 |
| imported/sherlock/everything-greedy | 581881 | 293.35 ± 0.9% | not timed | not timed | 173.59 ± 0.1% | 27.58 ± 25.5% | not timed | not timed | 292.43 ± 1.1% | | 1.00 | 1.69 | 10.64 |
| imported/sherlock/everything-greedy-nl | 594933 | 510.35 ± 0.3% | not timed | not timed | 223.54 ± 0.6% | 30.82 ± 0.2% | not timed | not timed | 510.45 ± 0.1% | | 1.00 | 2.28 | 16.56 |
| imported/sherlock/letters | 447175 | 63.11 ± 8.4% | not timed | not timed | 33.79 ± 0.4% | 5.73 ± 16.5% | not timed | not timed | 67.56 ± 10.7% | | 0.93 | 1.87 | 11.02 |
| imported/sherlock/letters-upper | 14180 | 454.44 ± 1.1% | not timed | not timed | 369.52 ± 0.4% | 31.11 ± 51.5% | not timed | not timed | 454.73 ± 0.3% | | 1.00 | 1.23 | 14.61 |
| imported/sherlock/letters-lower | 432995 | 69.16 ± 2.1% | not timed | not timed | 33.39 ± 0.5% | 7.90 ± 4.4% | not timed | not timed | 69.77 ± 1.2% | | 0.99 | 2.07 | 8.75 |
| imported/sherlock/words | 447639 | 123.03 ± 0.9% | not timed | not timed | 83.60 ± 0.2% | 14.48 ± 7.7% | not timed | not timed | 123.19 ± 0.5% | | 1.00 | 1.47 | 8.50 |
| imported/sherlock/before-holmes | 4073 | 13905.39 ± 0.4% | not timed | not timed | 13329.69 ± 11.9% | 23.44 ± 1.4% | not timed | not timed | 13884.56 ± 1.1% | | 1.00 | 1.04 | 593.30 |
| imported/sherlock/before-after-holmes | 2593 | 13468.51 ± 0.2% | not timed | not timed | 15024.17 ± 0.4% | 23.43 ± 12.7% | not timed | not timed | 13539.83 ± 0.3% | | 0.99 | 0.90 | 574.79 |
| imported/sherlock/holmes-cochar-watson | 150 | 10017.89 ± 11.4% | not timed | not timed | 7669.24 ± 2.5% | 34.80 ± 0.6% | not timed | not timed | 10067.98 ± 0.5% | | 1.00 | 1.31 | 287.85 |
| imported/sherlock/holmes-coword-watson | 14309 | 1272.34 ± 0.2% | not timed | not timed | 1233.57 ± 0.1% | 6.70 ± 6.5% | not timed | not timed | 1274.26 ± 0.5% | | 1.00 | 1.03 | 189.80 |
| imported/sherlock/quotes | 14437 | 1549.38 ± 0.6% | not timed | not timed | 2239.68 ± 3.7% | 37.37 ± 14.5% | not timed | not timed | 1551.22 ± 0.5% | | 1.00 | 0.69 | 41.46 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 35224.10 ± 0.4% | not timed | not timed | 30939.73 ± 1.0% | 40.15 ± 0.8% | not timed | not timed | 35278.44 ± 0.2% | | 1.00 | 1.14 | 877.23 |
| imported/sherlock/word-ending-n | 35297 | 473.72 ± 1.0% | not timed | not timed | 404.94 ± 0.5% | 23.32 ± 23.2% | not timed | not timed | 472.91 ± 0.3% | | 1.00 | 1.17 | 20.31 |
| imported/sherlock/repeated-class-negation | 2130 | 16626.66 ± 11.5% | not timed | not timed | 16681.32 ± 0.8% | 11.85 ± 1.4% | not timed | not timed | 16595.07 ± 10.8% | | 1.00 | 1.00 | 1402.72 |
| imported/sherlock/ing-suffix | 20547 | 572.32 ± 0.7% | not timed | not timed | 511.76 ± 2.7% | 28.36 ± 2.3% | not timed | not timed | 572.88 ± 0.4% | | 1.00 | 1.12 | 20.18 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1733.59 ± 2.6% | not timed | not timed | 2916.01 ± 11.4% | 21.06 ± 0.9% | not timed | not timed | 1753.90 ± 2.3% | | 0.99 | 0.59 | 82.31 |
| opt/accelerate/whole-line | 239963 | 502.78 ± 0.9% | not timed | not timed | 413.69 ± 0.5% | 92.29 ± 16.5% | not timed | not timed | 502.79 ± 0.5% | | 1.00 | 1.22 | 5.45 |
| opt/accelerate/non-dna | 16745 | 456.01 ± 1.1% | not timed | not timed | 437.66 ± 0.7% | 32.61 ± 19.2% | not timed | not timed | 455.55 ± 0.4% | | 1.00 | 1.04 | 13.98 |
| opt/backtrack/words-english | 40536 | 138.63 ± 2.3% | not timed | not timed | 111.37 ± 1.9% | 21.68 ± 12.2% | not timed | not timed | 136.97 ± 1.0% | | 1.01 | 1.24 | 6.39 |
| opt/fixed-length/too-small-ascii | 0 | 390.18 ± 1.2% | not timed | not timed | 707.82 ± 0.5% | 123.40 ± 2.0% | not timed | not timed | 390.18 ± 0.7% | | 1.00 | 0.55 | 3.16 |
| opt/fixed-length/too-big-ascii | 0 | 4386.62 ± 1.0% | not timed | not timed | 6300.01 ± 1.2% | 150.65 ± 1.7% | not timed | not timed | 4372.19 ± 0.6% | | 1.00 | 0.70 | 29.12 |
| opt/fixed-length/go33484-1 | 0 | 845731.91 ± 1.3% | not timed | not timed | 1215293.36 ± 0.4% | 88360.37 ± 1.7% | not timed | not timed | 838431.56 ± 0.8% | | 1.01 | 0.70 | 9.57 |
| opt/fixed-length/go33484-2 | 0 | 844376.96 ± 21.0% | not timed | not timed | 1213224.93 ± 0.5% | 29934.65 ± 0.4% | not timed | not timed | 843067.51 ± 0.7% | | 1.00 | 0.70 | 28.21 |
| opt/fixed-length/go33484-3 | 0 | 84141.79 ± 1.0% | not timed | not timed | 121534.39 ± 0.7% | 935.48 ± 0.2% | not timed | not timed | 83843.27 ± 0.7% | | 1.00 | 0.69 | 89.94 |
| opt/literal-alt/one-pattern | 1 | 578.24 ± 2.8% | not timed | not timed | 518.54 ± 0.7% | 0.38 ± 5.7% | not timed | not timed | 580.10 ± 6.5% | | 1.00 | 1.12 | 1533.26 |
| opt/onepass/fn-predicate | 916 | 430.85 ± 1.2% | not timed | not timed | 394.47 ± 7.9% | 211.36 ± 14.4% | not timed | not timed | 431.49 ± 0.8% | | 1.00 | 1.09 | 2.04 |
| opt/onepass/first-three-words-english | 35128 | 152.35 ± 4.2% | not timed | not timed | 227.72 ± 4.6% | 71.89 ± 16.0% | not timed | not timed | 176.39 ± 2.6% | | 0.86 | 0.67 | 2.12 |
| opt/prefilter/literal-english | 1 | 67601.34 ± 0.4% | not timed | not timed | 46472.30 ± 22.3% | 26619.90 ± 1.1% | not timed | not timed | 67596.60 ± 0.2% | | 1.00 | 1.45 | 2.54 |
| opt/prefilter/literal-casei-english | 1 | 47791.18 ± 12.1% | not timed | not timed | 14260.11 ± 8.0% | 33.70 ± 28.4% | not timed | not timed | 47681.60 ± 32.9% | | 1.00 | 3.35 | 1418.08 |
| opt/prefilter/literal-russian | 1 | 67416.88 ± 5.4% | not timed | not timed | 44521.35 ± 12.0% | 1765.99 ± 10.7% | not timed | not timed | 67194.61 ± 8.1% | | 1.00 | 1.51 | 38.18 |
| opt/prefilter/literal-casei-russian | 1 | 26201.47 ± 0.2% | not timed | not timed | 11019.96 ± 0.2% | 37.70 ± 0.9% | not timed | not timed | 26055.60 ± 0.3% | | 1.01 | 2.38 | 694.94 |
| opt/prefilter/rust-functions | 948 | 14583.89 ± 2.4% | not timed | not timed | 12865.16 ± 0.2% | 1905.87 ± 19.2% | not timed | not timed | 14640.17 ± 1.6% | | 1.00 | 1.13 | 7.65 |
| opt/reverse-anchored/word-end | 1 | 36353626.44 ± 1.4% | not timed | not timed | 26858040.81 ± 0.8% | 52.37 ± 0.4% | not timed | not timed | 36281526.39 ± 0.4% | | 1.00 | 1.35 | 694117.27 |
| opt/reverse-inner/holmes | 2593 | 13484.91 ± 0.5% | not timed | not timed | 14916.66 ± 1.1% | 24.25 ± 0.1% | not timed | not timed | 13545.13 ± 0.1% | | 1.00 | 0.90 | 556.05 |
| opt/reverse-inner/email | 47 | 83462.04 ± 0.8% | not timed | not timed | 92843.81 ± 0.2% | 34.57 ± 0.5% | not timed | not timed | 83718.91 ± 0.9% | | 1.00 | 0.90 | 2414.05 |
| opt/reverse-inner/factored-prefix | 3542 | 599.96 ± 0.1% | not timed | not timed | 584.40 ± 0.3% | 13.65 ± 0.4% | not timed | not timed | 600.15 ± 0.1% | | 1.00 | 1.03 | 43.97 |
| opt/reverse-inner/no-quadratic-backward | 0 | 23281.85 ± 0.7% | not timed | not timed | 604.24 ± 0.4% | 85.65 ± 0.2% | not timed | not timed | 23287.06 ± 0.1% | | 1.00 | 38.53 | 271.81 |
| opt/reverse-inner/no-quadratic-forward | 0 | 708.04 ± 1.8% | not timed | not timed | 278.38 ± 0.4% | 25.39 ± 0.9% | not timed | not timed | 709.58 ± 1.9% | | 1.00 | 2.54 | 27.88 |
| opt/reverse-suffix/holmes | 4073 | 13898.74 ± 0.2% | not timed | not timed | 13296.24 ± 0.6% | 24.04 ± 0.2% | not timed | not timed | 13899.20 ± 0.1% | | 1.00 | 1.05 | 578.09 |
| opt/reverse-suffix/no-quadratic | 0 | 23296.85 ± 0.1% | not timed | not timed | 604.33 ± 0.5% | 85.95 ± 0.8% | not timed | not timed | 23280.99 ± 0.3% | | 1.00 | 38.55 | 271.04 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 142.29 ± 2.1% | not timed | not timed | 180.60 ± 0.7% | 16.88 ± 13.9% | not timed | not timed | 142.22 ± 7.0% | | 1.00 | 0.79 | 8.43 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 141.01 ± 1.8% | not timed | not timed | 182.01 ± 0.3% | 16.54 ± 15.2% | not timed | not timed | 142.52 ± 0.1% | | 0.99 | 0.77 | 8.53 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.32 ± 0.3% | not timed | not timed | 0.48 ± 0.8% | 119.77 ± 1.6% | not timed | not timed | 0.31 ± 0.5% | | 1.02 | 0.66 | 0.0026 |
| reported/i1095-word-repetition/ascii-search | 256 | 304.69 ± 0.6% | not timed | not timed | 284.64 ± 0.5% | 108.23 ± 1.2% | not timed | not timed | 279.88 ± 11.3% | | 1.09 | 1.07 | 2.82 |
| reported/i13-subset-regex/original-ascii | 4094 | 10817.56 ± 0.4% | not timed | not timed | 3931.29 ± 0.3% | 12.16 ± 1.8% | not timed | not timed | 10810.22 ± 0.9% | | 1.00 | 2.75 | 889.86 |
| reported/i13-subset-regex/original-unicode | 4094 | 10793.29 ± 0.5% | not timed | not timed | 210.11 ± 2.6% | 12.14 ± 0.7% | not timed | not timed | 10834.89 ± 0.8% | | 1.00 | 51.37 | 889.12 |
| reported/i13-subset-regex/big-ascii | 1955 | 10216.37 ± 0.3% | not timed | not timed | 54.11 ± 2.0% | 10.45 ± 1.3% | not timed | not timed | 10210.13 ± 0.3% | | 1.00 | 188.82 | 977.42 |
| reported/i13-subset-regex/big-unicode | 1955 | 10159.71 ± 0.4% | not timed | not timed | 9.62 ± 55.1% | 10.44 ± 1.6% | not timed | not timed | 10206.40 ± 0.7% | | 1.00 | 1055.84 | 972.80 |
| reported/i13-subset-regex/huge-ascii | 55 | 9462.77 ± 0.8% | not timed | not timed | 8.95 ± 1.1% | 9.50 ± 1.7% | not timed | not timed | 9448.48 ± 1.1% | | 1.00 | 1056.83 | 995.75 |
| reported/i13-subset-regex/huge-unicode | 55 | 9370.46 ± 1.0% | not timed | not timed | 8.92 ± 1.4% | 9.47 ± 1.7% | not timed | not timed | 9208.86 ± 0.9% | | 1.02 | 1050.14 | 989.48 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.13 ± 0.6% | not timed | not timed | 9.01 ± 0.6% | 9.42 ± 4.1% | not timed | not timed | 4.10 ± 0.9% | | 1.01 | 0.46 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.81 ± 0.8% | not timed | not timed | 8.94 ± 1.0% | 9.38 ± 1.8% | not timed | not timed | 5.83 ± 0.9% | | 1.00 | 0.65 | 0.62 |
| reported/i787-keywords/ascii | 5674 | 549.67 ± 0.9% | not timed | not timed | 171.16 ± 1.3% | 7.15 ± 0.8% | not timed | not timed | 554.24 ± 0.6% | | 0.99 | 3.21 | 76.86 |
| reported/i787-keywords/opt-ascii | 5674 | 553.88 ± 9.6% | not timed | not timed | 268.78 ± 2.5% | 11.93 ± 17.7% | not timed | not timed | 557.34 ± 0.7% | | 0.99 | 2.06 | 46.44 |
| slow/quadratic-regex-1x | 100 | 8.23 ± 0.2% | not timed | not timed | 5.94 ± 0.1% | 0.05 ± 0.1% | not timed | not timed | 8.26 ± 6.0% | | 1.00 | 1.38 | 159.41 |
| slow/quadratic-regex-2x | 199 | 3.70 ± 0.6% | not timed | not timed | 3.05 ± 0.6% | 0.01 ± 4.7% | not timed | not timed | 3.70 ± 1.5% | | 1.00 | 1.21 | 277.03 |
| slow/quadratic-haystack-1x | 100 | 28.46 ± 6.8% | not timed | not timed | 12.16 ± 5.5% | 1.00 ± 14.5% | not timed | not timed | 28.51 ± 0.3% | | 1.00 | 2.34 | 28.33 |
| slow/quadratic-haystack-2x | 200 | 25.62 ± 2.0% | not timed | not timed | 6.12 ± 0.3% | 0.56 ± 13.3% | not timed | not timed | 25.61 ± 0.2% | | 1.00 | 4.18 | 45.96 |
| unicode/codepoints/any-one | 1112064 | 339.41 ± 11.9% | not timed | not timed | 230.65 ± 1.3% | 22.44 ± 4.3% | not timed | not timed | 339.96 ± 1.0% | | 1.00 | 1.47 | 15.13 |
| unicode/codepoints/any-all | 4382592 | 273.05 ± 0.5% | not timed | not timed | 262.94 ± 1.3% | 125.66 ± 0.7% | not timed | not timed | 273.09 ± 0.2% | | 1.00 | 1.04 | 2.17 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.91 ± 0.5% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 609.92 ± 0.7% | not timed | not timed | 601.91 ± 0.4% | 151.67 ± 0.3% | not timed | not timed | 610.16 ± 0.1% | | 1.00 | 1.01 | 4.02 |
| unicode/overlapping-words/ascii | 6156 | 29.56 ± 8.7% | not timed | not timed | 42.87 ± 0.5% | 4.20 ± 4.1% | not timed | not timed | 25.49 ± 3.5% | | 1.16 | 0.69 | 7.03 |
| unicode/overlapping-words/english | 6156 | 1.48 ± 0.8% | not timed | not timed | 3.50 ± 0.4% | 2.81 ± 0.6% | not timed | not timed | 1.45 ± 1.2% | | 1.02 | 0.42 | 0.53 |
| unicode/overlapping-words/russian | 5710 | 1.31 ± 7.8% | not timed | not timed | 3.40 ± 0.4% | 6.86 ± 7.8% | not timed | not timed | 1.32 ± 0.4% | | 0.99 | 0.38 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 132.78 ± 6.6% | not timed | not timed | 84.68 ± 4.6% | 12.24 ± 15.1% | not timed | not timed | 134.61 ± 5.3% | | 0.99 | 1.57 | 10.85 |
| unicode/word/boundary-long-english | 3466 | 610.72 ± 0.5% | not timed | not timed | 592.70 ± 0.2% | 35.16 ± 1.4% | not timed | not timed | 611.45 ± 0.8% | | 1.00 | 1.03 | 17.37 |
| unicode/word/around-holmes-english | 27 | 63271.44 ± 2.5% | not timed | not timed | 44963.34 ± 0.4% | 23.75 ± 1.2% | not timed | not timed | 63204.81 ± 1.5% | | 1.00 | 1.41 | 2663.78 |
| wild/bibleref/long | 874 | 564.86 ± 1.8% | not timed | not timed | 570.69 ± 1.8% | 7.96 ± 1.4% | not timed | not timed | 565.59 ± 2.4% | | 1.00 | 0.99 | 70.95 |
| wild/bibleref/short | 30 | 22.84 ± 9.0% | not timed | not timed | 32.20 ± 2.3% | 16.60 ± 9.6% | not timed | not timed | 22.74 ± 7.6% | | 1.00 | 0.71 | 1.38 |
| wild/bibleref/line | 874 | 505.57 ± 3.2% | not timed | not timed | 276.96 ± 2.3% | 9.80 ± 1.7% | not timed | not timed | 479.18 ± 1.5% | | 1.06 | 1.83 | 51.61 |
| wild/caddy/caddy | 6 | 445.58 ± 9.4% | not timed | not timed | 287.81 ± 2.2% | 74.30 ± 15.1% | not timed | not timed | 447.36 ± 5.8% | | 1.00 | 1.55 | 6.00 |
| wild/dot-star-capture/rust-src-tools | 6 | 1426.08 ± 8.3% | not timed | not timed | 399.49 ± 1.0% | 15.69 ± 2.9% | not timed | not timed | 1443.87 ± 2.5% | | 0.99 | 3.57 | 90.92 |
| wild/ruff/noqa | 84 | 506.37 ± 1.1% | not timed | not timed | 511.46 ± 0.5% | 21.52 ± 2.4% | not timed | not timed | 506.90 ± 0.3% | | 1.00 | 0.99 | 23.53 |
| wild/ruff/unnecessary-coding-comment | 16 | 1068.96 ± 0.7% | not timed | not timed | 720.74 ± 0.5% | 139.78 ± 12.8% | not timed | not timed | 1071.00 ± 0.6% | | 1.00 | 1.48 | 7.65 |
| wild/ruff/string-quote-prefix | 2972 | 1573.85 ± 0.7% | not timed | not timed | 489.34 ± 0.8% | 322.36 ± 29.7% | not timed | not timed | 1567.00 ± 0.8% | | 1.00 | 3.22 | 4.88 |
| wild/ruff/space-around-operator | 1224378 | 234.97 ± 1.7% | not timed | not timed | 227.53 ± 0.9% | 19.10 ± 2.7% | not timed | not timed | 234.19 ± 1.3% | | 1.00 | 1.03 | 12.30 |
| wild/ruff/shebang | 282 | 1101.28 ± 0.6% | not timed | not timed | 392.59 ± 0.5% | 125.74 ± 11.7% | not timed | not timed | 1070.96 ± 1.0% | | 1.03 | 2.81 | 8.76 |
| wild/rustsec-cargo-audit/original-unix | 471 | 22550.85 ± 1.0% | not timed | not timed | 23752.79 ± 0.6% | 8939.90 ± 3.6% | not timed | not timed | 22406.02 ± 1.2% | | 1.01 | 0.95 | 2.52 |
| wild/rustsec-cargo-audit/original-windows | 462 | 20566.17 ± 0.5% | not timed | not timed | 22533.55 ± 0.2% | 8442.60 ± 1.0% | not timed | not timed | 20549.56 ± 0.9% | | 1.00 | 0.91 | 2.44 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 22719.75 ± 0.8% | not timed | not timed | 23459.94 ± 0.4% | 8768.26 ± 17.1% | not timed | not timed | 22695.84 ± 3.5% | | 1.00 | 0.97 | 2.59 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 18269.34 ± 2.4% | not timed | not timed | 23394.60 ± 24.5% | 8766.42 ± 24.1% | not timed | not timed | 18315.22 ± 2.7% | | 1.00 | 0.78 | 2.08 |
| wild/url/search | 234965 | 130.54 ± 13.7% | not timed | not timed | 61.89 ± 0.3% | 2.44 ± 0.3% | not timed | not timed | 129.92 ± 16.0% | | 1.00 | 2.11 | 53.42 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 64.5% | not timed | not timed | 0.01 ± 3.8% | 0.01 ± 20.2% | not timed | not timed | 0.03 ± 57.1% | | 0.98 | 2.44 | 3.76 |
| dictionary/compile/english-15 | 1 | 0.34 ± 28.3% | not timed | not timed | 0.10 ± 0.4% | 0.12 ± 13.6% | not timed | not timed | 0.34 ± 1.9% | | 1.00 | 3.54 | 2.90 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.30 ± 1.5% | not timed | not timed | 0.02 ± 0.4% | 36.63 ± 21.4% | not timed | not timed | 0.29 ± 33.0% | | 1.03 | 13.16 | 0.0082 |
| reported/i1095-word-repetition/ascii-compile | 1 | 44.28 ± 10.3% | not timed | not timed | 16.99 ± 3.2% | 59.01 ± 23.6% | not timed | not timed | 44.73 ± 1.4% | | 0.99 | 2.61 | 0.75 |
| reported/i787-keywords/compile | 1 | 40.70 ± 24.9% | not timed | not timed | 2.38 ± 0.6% | 20.84 ± 28.2% | not timed | not timed | 40.65 ± 3.2% | | 1.00 | 17.10 | 1.95 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 373.33 ± 7.1% | not timed | not timed | 158.46 ± 1.2% | 597.89 ± 23.5% | not timed | not timed | 382.66 ± 3.1% | | 0.98 | 2.36 | 0.62 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 53.21 ± 9.2% | not timed | not timed | 5.59 ± 3.4% | 49.06 ± 3.1% | not timed | not timed | 54.76 ± 3.1% | | 0.97 | 9.51 | 1.08 |
| unicode/compile/one-letter | 53 | 7.01 ± 10.1% | not timed | not timed | 5.82 ± 0.6% | 65.70 ± 6.4% | not timed | not timed | 7.08 ± 11.2% | | 0.99 | 1.20 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.26 ± 16.0% | not timed | not timed | 0.13 ± 2.6% | 66.25 ± 8.2% | not timed | not timed | 1.25 ± 18.1% | | 1.00 | 10.01 | 0.0189 |
| unicode/compile/fifty-letters-ascii | 1 | 193.26 ± 10.5% | not timed | not timed | 67.63 ± 16.2% | 219.55 ± 16.8% | not timed | not timed | 199.31 ± 9.4% | | 0.97 | 2.86 | 0.88 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 444.37 ± 8.1% | not timed | not timed | 51.36 ± 17.5% | 747.19 ± 11.3% | not timed | not timed | 453.01 ± 5.0% | | 0.98 | 8.65 | 0.59 |
| unicode/compile/match-every-line-ascii | 4 | 690.10 ± 3.0% | not timed | not timed | 168.71 ± 0.6% | 761.48 ± 15.6% | not timed | not timed | 704.71 ± 7.9% | | 0.98 | 4.09 | 0.91 |
| unicode/compile/negated-class-matches-codepoint | 1 | 359.09 ± 3.7% | not timed | not timed | 56.08 ± 6.3% | 1396.42 ± 23.0% | not timed | not timed | 369.44 ± 3.6% | | 0.97 | 6.40 | 0.26 |
| wild/bibleref/compile | 3 | 6.11 ± 5.3% | not timed | not timed | 2.42 ± 6.3% | 34.03 ± 6.4% | not timed | not timed | 6.19 ± 7.1% | | 0.99 | 2.52 | 0.18 |
| wild/url/compile | 1 | 0.73 ± 8.3% | not timed | not timed | 0.21 ± 0.7% | 0.46 ± 26.0% | not timed | not timed | 0.73 ± 1.1% | | 1.00 | 3.52 | 1.57 |

