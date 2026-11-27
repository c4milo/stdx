# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261122.195.1 |
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
| literal: a word | 217 | 19906.60 ± 2.1% | 10889.74 ± 0.5% | 28.19 ± 0.6% | 18406.20 ± 2.1% | 9254.06 ± 8.9% | 17.59 ± 0.2% | 86.56 ± 0.3% | 19827.66 ± 3.3% | 1.83 | 1.00 | 1.08 | 2.15 |
| literal: a word that is not there | 0 | 21820.36 ± 3.6% | 9893.46 ± 0.9% | 28.37 ± 0.3% | 19920.89 ± 0.9% | 29342.94 ± 1.0% | 17.37 ± 0.4% | 80.79 ± 0.2% | 21768.51 ± 2.9% | 2.21 | 1.00 | 1.10 | 0.74 |
| literal: one of four words | 661 | 6431.10 ± 0.3% | 1788.64 ± 0.5% | 14.41 ± 0.2% | 3948.18 ± 0.2% | 21.87 ± 0.1% | 5.31 ± 0.1% | 6.94 ± 0.2% | 6439.49 ± 0.2% | 3.60 | 1.00 | 1.63 | 294.10 |
| literal: a word in any case | 217 | 15214.03 ± 1.2% | 1914.72 ± 0.3% | 21.52 ± 0.3% | 3960.47 ± 0.2% | 38.13 ± 0.6% | refused | differs | 15198.69 ± 0.2% | 7.95 | 1.00 | 3.84 | 398.96 |
| literal: an href attribute | 33 | 16907.06 ± 1.1% | 608.95 ± 0.2% | 27.28 ± 0.2% | 17097.80 ± 0.3% | 2260.93 ± 0.3% | 13.34 ± 1.0% | 75.24 ± 0.4% | 17020.62 ± 1.0% | 27.76 | 0.99 | 0.99 | 7.48 |
| literal: a word, second text | 123 | 20030.79 ± 1.9% | 4593.84 ± 0.5% | 27.96 ± 0.2% | 18381.88 ± 1.1% | 7813.27 ± 3.8% | 19.71 ± 0.5% | 70.66 ± 0.3% | 19922.38 ± 1.3% | 4.36 | 1.01 | 1.09 | 2.56 |
| class: two capitalized words | 1331 | 1178.05 ± 0.3% | 599.35 ± 0.3% | 25.98 ± 0.4% | 584.62 ± 0.0% | 40.66 ± 7.8% | 14.94 ± 0.1% | 67.88 ± 0.1% | 1177.77 ± 0.2% | 1.97 | 1.00 | 2.02 | 28.97 |
| class: a word that ends in ing | 3399 | 575.16 ± 0.2% | 574.50 ± 0.4% | 17.86 ± 0.1% | 548.11 ± 0.1% | 29.68 ± 1.3% | 8.21 ± 0.1% | 18.40 ± 0.9% | 575.64 ± 0.1% | 1.00 | 1.00 | 1.05 | 19.38 |
| class: a word in capitals | 2332 | 1538.36 ± 0.5% | 609.03 ± 0.4% | 27.58 ± 0.3% | 573.16 ± 0.1% | 43.50 ± 13.9% | 17.22 ± 0.4% | 83.40 ± 0.5% | 1533.69 ± 0.3% | 2.53 | 1.00 | 2.68 | 35.36 |
| class: a number | 8288 | 2675.81 ± 0.7% | 841.14 ± 0.0% | 27.60 ± 0.3% | 1708.18 ± 0.2% | 38.76 ± 15.1% | 0.55 ± 1.0% | 57.19 ± 0.4% | 2676.80 ± 1.1% | 3.18 | 1.00 | 1.57 | 69.03 |
| class: two capitalized words, second text | 5359 | 522.19 ± 0.1% | 528.50 ± 0.2% | 23.22 ± 0.2% | 484.24 ± 0.1% | 35.36 ± 15.4% | 16.72 ± 0.4% | 63.16 ± 0.2% | 522.05 ± 0.3% | 0.99 | 1.00 | 1.08 | 14.77 |
| other: a word between two words | 6104 | 811.19 ± 0.6% | 602.86 ± 0.0% | 23.45 ± 0.2% | 737.65 ± 0.1% | 110.91 ± 9.1% | 11.37 ± 0.1% | 69.25 ± 0.7% | 811.11 ± 0.2% | 1.35 | 1.00 | 1.10 | 7.31 |
| other: a number before a unit, second text | 1481 | 6289.37 ± 1.4% | 1144.87 ± 0.1% | 25.94 ± 0.4% | 5646.93 ± 0.3% | 40.74 ± 0.5% | 17.78 ± 0.1% | 65.71 ± 0.3% | 6260.82 ± 1.0% | 5.49 | 1.00 | 1.11 | 154.38 |
| other: a heading's start tag | 110 | 14164.27 ± 0.7% | 740.03 ± 0.1% | 27.29 ± 0.3% | 1709.63 ± 0.1% | 1577.93 ± 7.3% | 16.25 ± 9.8% | 87.65 ± 0.8% | 14201.74 ± 1.1% | 19.14 | 1.00 | 8.28 | 8.98 |
| other: a whole word | 217 | 16387.13 ± 1.5% | 602.00 ± 0.2% | 28.69 ± 0.3% | 14499.08 ± 0.7% | 49.40 ± 0.2% | 14.01 ± 0.1% | 54.98 ± 0.4% | 16389.75 ± 0.7% | 27.22 | 1.00 | 1.13 | 331.71 |
| other: a line's first word, second text | 3716 | 2095.21 ± 0.6% | 592.41 ± 0.2% | 30.80 ± 0.2% | 1721.90 ± 0.3% | 61.77 ± 8.2% | refused | refused | 2093.55 ± 0.5% | 3.54 | 1.00 | 1.22 | 33.92 |
| other: fourteen octets before an x | 87 | 24423.09 ± 0.6% | 243.57 ± 0.5% | 6.47 ± 0.2% | 4057.32 ± 1.3% | 10.64 ± 0.3% | differs | 17.89 ± 0.1% | 24413.06 ± 3.3% | 100.27 | 1.00 | 6.02 | 2295.18 |
| other: a Greek word | 21815 | 528.92 ± 0.9% | 423.89 ± 0.3% | 30.43 ± 0.1% | 290.23 ± 0.5% | 44.45 ± 10.3% | differs | refused | 529.26 ± 1.4% | 1.25 | 1.00 | 1.82 | 11.90 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.67 ± 0.1% | 29.51 ± 0.1% | 0.86 ± 0.2% | 19.76 ± 0.1% | 2.75 ± 0.4% | differs | 4.03 ± 0.1% | 29.59 ± 0.3% | 1.01 | 1.00 | 1.50 | 10.78 |
| a UUID | 32895 | 24.74 ± 0.2% | 24.79 ± 0.2% | 0.64 ± 0.2% | 15.18 ± 0.1% | 3.10 ± 0.4% | 0.72 ± 0.5% | 3.60 ± 0.8% | 24.84 ± 0.2% | 1.00 | 1.00 | 1.63 | 7.99 |
| an IPv4 address | 33176 | 38.52 ± 0.2% | 38.66 ± 0.3% | 2.07 ± 0.5% | 29.36 ± 0.1% | 6.67 ± 0.2% | differs | 4.14 ± 0.2% | 38.58 ± 0.2% | 1.00 | 1.00 | 1.31 | 5.78 |
| a date and time | 32954 | 34.10 ± 0.2% | 34.20 ± 0.3% | 1.44 ± 0.1% | 21.48 ± 0.1% | 7.04 ± 0.1% | 1.20 ± 0.3% | 7.10 ± 0.1% | 34.20 ± 0.3% | 1.00 | 1.00 | 1.59 | 4.85 |
| a field path | 32606 | 32.75 ± 0.5% | 32.85 ± 0.2% | 1.01 ± 0.2% | 23.18 ± 0.1% | 3.49 ± 0.2% | differs | 2.96 ± 0.1% | 32.78 ± 0.3% | 1.00 | 1.00 | 1.41 | 9.39 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.21 ± 0.3% | 11.15 ± 0.2% | 11.19 ± 0.4% | 11.54 ± 0.7% | 4.90 ± 1.7% | 0.91 ± 0.6% | none | 11.21 ± 0.6% | 1.01 | 1.00 | 0.97 | 2.29 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 223.95 ± 0.3% | 223.69 ± 0.2% | 263.11 ± 0.1% | 86.76 ± 0.1% | 220.47 ± 0.9% | 482.35 ± 4.4% | 3699.21 ± 0.2% | 223.95 ± 0.1% | 1.00 | 1.00 | 2.58 | 1.02 |
| a UUID | 62 | 147.74 ± 0.5% | 147.81 ± 0.2% | 164.57 ± 0.2% | 45.73 ± 0.4% | 99.48 ± 0.7% | 188.38 ± 2.7% | 4322.49 ± 0.2% | 147.68 ± 0.2% | 1.00 | 1.00 | 3.23 | 1.49 |
| an IPv4 address | 29 | 419.81 ± 0.3% | 419.26 ± 0.3% | 583.88 ± 0.6% | 77.82 ± 0.6% | 130.70 ± 1.1% | 300.97 ± 1.0% | 7444.03 ± 0.3% | 419.48 ± 0.5% | 1.00 | 1.00 | 5.39 | 3.21 |
| a date and time | 56 | 300.76 ± 0.3% | 300.57 ± 0.2% | 376.42 ± 0.2% | 73.43 ± 0.5% | 136.49 ± 2.2% | 326.68 ± 1.5% | 4901.50 ± 0.7% | 301.02 ± 0.2% | 1.00 | 1.00 | 4.10 | 2.20 |
| a field path | 39 | 217.48 ± 0.2% | 217.40 ± 0.2% | 254.19 ± 0.1% | 81.22 ± 0.6% | 204.93 ± 1.5% | 504.87 ± 0.7% | 4683.10 ± 0.1% | 217.64 ± 0.2% | 1.00 | 1.00 | 2.68 | 1.06 |
| literal: a word | 7 | 605.48 ± 0.8% | 650.29 ± 0.7% | 1130.89 ± 0.5% | 520.82 ± 1.4% | 632.48 ± 1.4% | 954.30 ± 1.0% | 28531.57 ± 0.6% | 605.04 ± 0.5% | 0.93 | 1.00 | 1.16 | 0.96 |
| literal: a word that is not there | 8 | 586.19 ± 0.4% | 634.78 ± 0.2% | 1092.50 ± 0.1% | 469.31 ± 0.5% | 601.02 ± 1.6% | 905.38 ± 0.9% | 27780.84 ± 0.1% | 586.87 ± 0.3% | 0.92 | 1.00 | 1.25 | 0.98 |
| literal: one of four words | 26 | 245.10 ± 0.2% | 390.56 ± 0.2% | 530.56 ± 0.1% | 50.39 ± 0.3% | 239.78 ± 1.7% | 377.80 ± 3.1% | 15167.77 ± 1.6% | 245.28 ± 0.3% | 0.63 | 1.00 | 4.86 | 1.02 |
| literal: a word in any case | 11 | 439.31 ± 0.2% | 468.75 ± 0.7% | 683.32 ± 0.3% | 15.79 ± 0.2% | 639.38 ± 2.5% | refused | 22663.78 ± 0.3% | 438.88 ± 0.2% | 0.94 | 1.00 | 27.83 | 0.69 |
| literal: an href attribute | 12 | 340.05 ± 0.3% | 352.16 ± 0.1% | 460.48 ± 0.1% | 45.51 ± 0.7% | 495.59 ± 1.2% | 764.48 ± 0.4% | 20836.91 ± 0.2% | 340.33 ± 0.2% | 0.97 | 1.00 | 7.47 | 0.69 |
| literal: a word, second text | 10 | 537.20 ± 0.9% | 589.30 ± 0.3% | 970.07 ± 0.1% | 406.65 ± 2.9% | 536.68 ± 1.8% | 793.86 ± 0.7% | 25854.25 ± 1.5% | 537.80 ± 0.2% | 0.91 | 1.00 | 1.32 | 1.00 |
| class: two capitalized words | 23 | 430.56 ± 0.4% | 456.45 ± 0.5% | 655.16 ± 0.6% | 100.31 ± 0.9% | 497.44 ± 1.6% | 749.03 ± 1.5% | 6210.17 ± 0.4% | 430.04 ± 0.3% | 0.94 | 1.00 | 4.29 | 0.87 |
| class: a word that ends in ing | 9 | 546.79 ± 0.3% | 611.30 ± 0.3% | 1052.12 ± 0.1% | 132.87 ± 0.7% | 753.58 ± 1.6% | 1105.56 ± 0.4% | 15209.32 ± 0.2% | 547.37 ± 0.6% | 0.89 | 1.00 | 4.12 | 0.73 |
| class: a word in capitals | 16 | 488.69 ± 0.1% | 524.02 ± 0.3% | 822.61 ± 0.1% | 136.21 ± 1.1% | 756.22 ± 1.6% | 1024.33 ± 0.5% | 8122.75 ± 0.3% | 488.92 ± 0.2% | 0.93 | 1.00 | 3.59 | 0.65 |
| class: a number | 6 | 618.61 ± 0.4% | 674.68 ± 1.0% | 1239.71 ± 0.2% | 42.11 ± 1.2% | 1417.53 ± 0.3% | 1910.85 ± 1.3% | 21610.21 ± 0.2% | 618.60 ± 0.3% | 0.92 | 1.00 | 14.69 | 0.44 |
| class: two capitalized words, second text | 23 | 429.71 ± 0.4% | 456.12 ± 0.3% | 653.37 ± 0.6% | 100.84 ± 2.4% | 497.73 ± 1.3% | 736.97 ± 0.6% | 6212.27 ± 0.1% | 429.45 ± 0.7% | 0.94 | 1.00 | 4.26 | 0.86 |
| other: a word between two words | 13 | 530.37 ± 0.5% | 551.37 ± 1.3% | 868.72 ± 1.0% | 136.01 ± 0.9% | 499.95 ± 8.1% | 805.73 ± 0.5% | 14164.32 ± 0.2% | 528.74 ± 0.7% | 0.96 | 1.00 | 3.90 | 1.06 |
| other: a number before a unit, second text | 15 | 384.18 ± 0.1% | 421.55 ± 0.3% | 584.84 ± 0.1% | 39.54 ± 0.9% | 635.27 ± 1.2% | 875.23 ± 1.5% | 14745.02 ± 0.2% | 384.21 ± 0.2% | 0.91 | 1.00 | 9.72 | 0.60 |
| other: a heading's start tag | 13 | 349.89 ± 0.5% | 355.93 ± 0.4% | 466.64 ± 0.4% | 43.85 ± 0.3% | 625.85 ± 9.9% | 854.26 ± 0.3% | 17289.59 ± 0.1% | 350.08 ± 0.2% | 0.98 | 1.00 | 7.98 | 0.56 |
| other: a whole word | 11 | 562.39 ± 1.3% | 599.95 ± 1.3% | 992.88 ± 1.6% | 121.68 ± 0.2% | 561.84 ± 0.8% | 818.55 ± 0.5% | 25444.50 ± 0.2% | 561.27 ± 0.8% | 0.94 | 1.00 | 4.62 | 1.00 |
| other: a line's first word, second text | 17 | 508.92 ± 1.1% | 543.27 ± 0.7% | 863.29 ± 0.1% | 128.87 ± 0.1% | 698.84 ± 1.4% | refused | refused | 509.92 ± 0.3% | 0.94 | 1.00 | 3.95 | 0.73 |
| other: fourteen octets before an x | 16 | 109.15 ± 0.3% | 156.31 ± 0.8% | 179.00 ± 0.9% | 15.10 ± 0.3% | 451.05 ± 0.8% | 411.95 ± 1.2% | 12428.84 ± 0.2% | 109.04 ± 0.9% | 0.70 | 1.00 | 7.23 | 0.24 |
| other: a Greek word | 8 | 446.81 ± 0.2% | 586.42 ± 0.3% | 977.91 ± 1.0% | 59.23 ± 0.5% | 1368.40 ± 2.0% | 1789.30 ± 0.6% | refused | 446.77 ± 0.4% | 0.76 | 1.00 | 7.54 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15759.94 ± 0.3% | not timed | not timed | 16435.29 ± 1.2% | 1987.48 ± 16.5% | not timed | not timed | 15733.35 ± 0.7% | | 1.00 | 0.96 | 7.93 |
| 01-literal/sherlock-casei-en | 522 | 10969.75 ± 2.7% | not timed | not timed | 3590.83 ± 0.3% | 32.47 ± 0.2% | not timed | not timed | 10942.74 ± 0.9% | | 1.00 | 3.05 | 337.85 |
| 01-literal/sherlock-ru | 724 | 17120.22 ± 0.3% | not timed | not timed | 17293.72 ± 0.2% | 1514.96 ± 4.0% | not timed | not timed | 17138.70 ± 0.4% | | 1.00 | 0.99 | 11.30 |
| 01-literal/sherlock-casei-ru | 746 | 6132.45 ± 0.3% | not timed | not timed | 3330.91 ± 0.1% | 31.76 ± 10.4% | not timed | not timed | 6127.08 ± 0.1% | | 1.00 | 1.84 | 193.07 |
| 01-literal/sherlock-zh | 30 | 19826.29 ± 0.9% | not timed | not timed | 18802.36 ± 1.2% | 2566.78 ± 6.7% | not timed | not timed | 19852.42 ± 0.6% | | 1.00 | 1.05 | 7.72 |
| 02-literal-alternate/sherlock-en | 714 | 6139.91 ± 0.6% | not timed | not timed | 3938.14 ± 0.1% | 16.68 ± 0.1% | not timed | not timed | 6133.99 ± 0.1% | | 1.00 | 1.56 | 368.14 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1962.51 ± 1.7% | not timed | not timed | 698.12 ± 0.2% | 11.04 ± 0.1% | not timed | not timed | 1972.72 ± 1.0% | | 0.99 | 2.81 | 177.73 |
| 02-literal-alternate/sherlock-ru | 899 | 5505.29 ± 0.1% | not timed | not timed | 3251.16 ± 0.1% | 22.67 ± 0.1% | not timed | not timed | 5509.31 ± 0.1% | | 1.00 | 1.69 | 242.88 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2047.68 ± 0.4% | not timed | not timed | 1225.31 ± 0.6% | 9.15 ± 0.1% | not timed | not timed | 2049.59 ± 0.5% | | 1.00 | 1.67 | 223.85 |
| 02-literal-alternate/sherlock-zh | 207 | 7341.16 ± 0.1% | not timed | not timed | 4159.27 ± 0.5% | 31.54 ± 0.2% | not timed | not timed | 7345.24 ± 0.3% | | 1.00 | 1.77 | 232.78 |
| 03-date/ascii | 111817 | 134.03 ± 0.7% | not timed | not timed | 96.48 ± 0.2% | 0.20 ± 3.2% | not timed | not timed | 135.03 ± 0.8% | | 0.99 | 1.39 | 671.25 |
| 04-ruff-noqa/real | 84 | 439.29 ± 0.1% | not timed | not timed | 457.71 ± 0.3% | 19.64 ± 1.3% | not timed | not timed | 437.51 ± 0.1% | | 1.00 | 0.96 | 22.36 |
| 04-ruff-noqa/tweaked | 44 | 847.37 ± 0.1% | not timed | not timed | 461.87 ± 0.1% | 364.49 ± 0.9% | not timed | not timed | 847.17 ± 0.1% | | 1.00 | 1.83 | 2.32 |
| 05-lexer-veryl/single | 124800 | 5.34 ± 4.5% | not timed | not timed | 4.94 ± 0.2% | 0.20 ± 3.6% | not timed | not timed | 5.34 ± 1.2% | | 1.00 | 1.08 | 26.25 |
| 06-cloud-flare-redos/original | 107 | 438.28 ± 11.5% | not timed | not timed | 214.46 ± 0.1% | 24.77 ± 6.5% | not timed | not timed | 440.92 ± 0.1% | | 0.99 | 2.04 | 17.69 |
| 06-cloud-flare-redos/simplified-short | 102 | 439.27 ± 5.5% | not timed | not timed | 227.59 ± 0.1% | 26.67 ± 0.6% | not timed | not timed | 439.78 ± 0.4% | | 1.00 | 1.93 | 16.47 |
| 06-cloud-flare-redos/simplified-long | 10000 | 629.12 ± 1.1% | not timed | not timed | 255.96 ± 0.3% | 28.84 ± 0.1% | not timed | not timed | 629.43 ± 0.1% | | 1.00 | 2.46 | 21.81 |
| 07-unicode-character-data/parse-line | 558784 | 240.35 ± 0.8% | not timed | not timed | 171.13 ± 0.3% | 43.09 ± 0.6% | not timed | not timed | 243.22 ± 0.5% | | 0.99 | 1.40 | 5.58 |
| 08-words/all-english | 56691 | 128.87 ± 0.7% | not timed | not timed | 82.71 ± 0.1% | 12.13 ± 8.7% | not timed | not timed | 129.33 ± 0.6% | | 1.00 | 1.56 | 10.62 |
| 08-words/long-english | 839 | 615.21 ± 1.0% | not timed | not timed | 597.20 ± 0.2% | 32.55 ± 0.4% | not timed | not timed | 617.39 ± 0.9% | | 1.00 | 1.03 | 18.90 |
| 09-aws-keys/full | 0 | 443.33 ± 0.2% | not timed | not timed | 463.57 ± 0.2% | 64.39 ± 3.4% | not timed | not timed | 443.44 ± 0.2% | | 1.00 | 0.96 | 6.88 |
| 09-aws-keys/quick | 0 | 875.34 ± 0.2% | not timed | not timed | 989.20 ± 0.3% | 418.70 ± 0.7% | not timed | not timed | 874.86 ± 0.1% | | 1.00 | 0.88 | 2.09 |
| 10-bounded-repeat/letters-en | 1833 | 577.36 ± 3.3% | not timed | not timed | 516.16 ± 0.2% | 19.59 ± 0.4% | not timed | not timed | 580.53 ± 1.4% | | 0.99 | 1.12 | 29.48 |
| 10-bounded-repeat/letters-ru | 3475 | 507.17 ± 2.0% | not timed | not timed | 478.74 ± 0.1% | 22.18 ± 11.1% | not timed | not timed | 506.65 ± 1.8% | | 1.00 | 1.06 | 22.86 |
| 10-bounded-repeat/context | 53 | 85.41 ± 1.7% | not timed | not timed | 66.01 ± 0.6% | 19.71 ± 0.2% | not timed | not timed | 85.70 ± 1.8% | | 1.00 | 1.29 | 4.33 |
| 10-bounded-repeat/capitals | 11 | 635.94 ± 8.5% | not timed | not timed | 618.46 ± 0.0% | 36.59 ± 0.1% | not timed | not timed | 636.28 ± 8.3% | | 1.00 | 1.03 | 17.38 |
| 11-unstructured-to-json/extract | 600 | 57.83 ± 1.3% | not timed | not timed | 77.40 ± 0.0% | 49.00 ± 0.7% | not timed | not timed | 57.86 ± 0.2% | | 1.00 | 0.75 | 1.18 |
| 12-dictionary/single | 1 | 560.26 ± 1.4% | not timed | not timed | 559.59 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 561.15 ± 1.5% | | 1.00 | 1.00 | 1367.36 |
| 14-quadratic/1x | 100 | 21.99 ± 0.8% | not timed | not timed | 10.02 ± 0.5% | 0.96 ± 3.6% | not timed | not timed | 22.01 ± 2.1% | | 1.00 | 2.20 | 22.89 |
| 14-quadratic/2x | 200 | 19.77 ± 1.1% | not timed | not timed | 5.56 ± 0.2% | 0.53 ± 1.3% | not timed | not timed | 19.83 ± 1.5% | | 1.00 | 3.56 | 37.26 |
| 14-quadratic/10x | 1000 | 12.35 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 12.36 ± 0.4% | | 1.00 | 10.18 | 107.23 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 0.5% | not timed | not timed | 0.35 ± 0.4% | 0.55 ± 3.2% | not timed | not timed | 1.27 ± 0.3% | | 1.00 | 3.67 | 2.32 |
| 04-ruff-noqa/compile-real | 1 | 107.34 ± 1.3% | not timed | not timed | 13.77 ± 0.6% | 140.86 ± 2.2% | not timed | not timed | 107.44 ± 0.6% | | 1.00 | 7.79 | 0.76 |
| 05-lexer-veryl/compile-single | 1 | 13.99 ± 1.7% | not timed | not timed | 2.55 ± 1.5% | 6.54 ± 1.4% | not timed | not timed | 14.16 ± 1.6% | | 0.99 | 5.49 | 2.14 |
| 07-unicode-character-data/compile | 1 | 110.05 ± 0.7% | not timed | not timed | 25.68 ± 0.3% | 36.13 ± 5.0% | not timed | not timed | 110.12 ± 0.5% | | 1.00 | 4.29 | 3.05 |
| 09-aws-keys/compile-full | 1 | 53.61 ± 0.3% | not timed | not timed | 8.23 ± 0.6% | 23.37 ± 5.0% | not timed | not timed | 53.67 ± 1.2% | | 1.00 | 6.51 | 2.29 |
| 09-aws-keys/compile-quick | 1 | 188.72 ± 0.9% | not timed | not timed | 47.38 ± 0.1% | 135.14 ± 2.4% | not timed | not timed | 189.21 ± 0.3% | | 1.00 | 3.98 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 72.77 ± 1.4% | not timed | not timed | 11.19 ± 0.3% | 16.31 ± 3.4% | not timed | not timed | 72.82 ± 1.7% | | 1.00 | 6.50 | 4.46 |
| 10-bounded-repeat/compile-capitals | 1 | 86.26 ± 0.9% | not timed | not timed | 8.14 ± 0.4% | 24.35 ± 1.5% | not timed | not timed | 86.16 ± 2.2% | | 1.00 | 10.60 | 3.54 |
| 11-unstructured-to-json/compile | 1 | 175.17 ± 0.1% | not timed | not timed | 40.87 ± 0.8% | 68.06 ± 7.0% | not timed | not timed | 174.85 ± 1.3% | | 1.00 | 4.29 | 2.57 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.7% | not timed | not timed | 0.07 ± 0.2% | 0.10 ± 5.8% | not timed | not timed | 0.35 ± 2.0% | | 0.99 | 4.97 | 3.50 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.47 ± 2.7% | not timed | not timed | 6.46 ± 0.1% | 0.56 ± 16.8% | not timed | not timed | 7.46 ± 0.3% | | 1.00 | 1.16 | 13.35 |
| dictionary/search/english-10 | 690 | 210.32 ± 1.8% | not timed | not timed | 166.80 ± 0.9% | 0.00 ± 0.2% | not timed | not timed | 211.81 ± 2.1% | | 0.99 | 1.26 | 71367.63 |
| dictionary/search/english-15 | 15 | 558.91 ± 1.5% | not timed | not timed | 559.85 ± 0.1% | 0.37 ± 0.4% | not timed | not timed | 561.87 ± 1.8% | | 0.99 | 1.00 | 1530.68 |
| folly/awyer-inn-busted | 1 | 21501.62 ± 0.1% | not timed | not timed | 142.42 ± 0.1% | 43.92 ± 0.1% | not timed | not timed | 21563.83 ± 0.0% | | 1.00 | 150.97 | 489.52 |
| folly/literal-never-match-rare | 0 | 21170.14 ± 0.4% | not timed | not timed | 19920.29 ± 0.2% | 41080.71 ± 0.3% | not timed | not timed | 21165.24 ± 0.2% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12545.07 ± 0.6% | not timed | not timed | 19883.75 ± 0.3% | 2194.97 ± 1.0% | not timed | not timed | 12563.13 ± 0.7% | | 1.00 | 0.63 | 5.72 |
| folly/literal-never-match-tricksy | 1 | 3252.12 ± 0.4% | not timed | not timed | 4408.33 ± 0.5% | 2897.64 ± 4.6% | not timed | not timed | 3255.44 ± 0.3% | | 1.00 | 0.74 | 1.12 |
| grep/every-line | 239963 | 1303.90 ± 0.7% | not timed | not timed | 952.66 ± 0.5% | 383.18 ± 18.1% | not timed | not timed | 1311.68 ± 0.6% | | 0.99 | 1.37 | 3.40 |
| grep/long-words-ascii | 5073 | 460.12 ± 0.3% | not timed | not timed | 466.33 ± 0.1% | 46.15 ± 6.3% | not timed | not timed | 458.67 ± 0.3% | | 1.00 | 0.99 | 9.97 |
| imported/leipzig/twain | 811 | 20744.97 ± 0.4% | not timed | not timed | 19566.70 ± 0.7% | 11984.08 ± 0.7% | not timed | not timed | 20774.27 ± 0.3% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9104.69 ± 1.2% | not timed | not timed | 4255.41 ± 0.1% | 37.66 ± 0.2% | not timed | not timed | 9158.61 ± 0.8% | | 0.99 | 2.14 | 241.79 |
| imported/leipzig/shing | 1540 | 15343.46 ± 2.4% | not timed | not timed | 13550.45 ± 0.8% | 34.03 ± 0.1% | not timed | not timed | 15553.59 ± 2.3% | | 0.99 | 1.13 | 450.91 |
| imported/leipzig/huck-saw | 262 | 8327.16 ± 2.4% | not timed | not timed | 5612.06 ± 0.1% | 31.70 ± 0.2% | not timed | not timed | 8474.08 ± 2.6% | | 0.98 | 1.48 | 262.69 |
| imported/leipzig/word-ending-nn | 262 | 603.80 ± 0.6% | not timed | not timed | 615.68 ± 0.4% | 24.74 ± 2.8% | not timed | not timed | 592.28 ± 2.9% | | 1.02 | 0.98 | 24.40 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11244.81 ± 0.9% | not timed | not timed | 4559.50 ± 0.8% | 11.36 ± 0.1% | not timed | not timed | 11289.61 ± 1.1% | | 1.00 | 2.47 | 989.64 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7859.26 ± 1.8% | not timed | not timed | 5493.80 ± 0.1% | 16.91 ± 0.1% | not timed | not timed | 7953.09 ± 2.2% | | 0.99 | 1.43 | 464.74 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4172.48 ± 0.9% | not timed | not timed | 417.59 ± 0.3% | 11.06 ± 0.0% | not timed | not timed | 4190.47 ± 0.8% | | 1.00 | 9.99 | 377.18 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7343.22 ± 1.6% | not timed | not timed | 615.48 ± 0.0% | 11.14 ± 0.1% | not timed | not timed | 7468.09 ± 2.5% | | 0.98 | 11.93 | 659.41 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7231.86 ± 2.2% | not timed | not timed | 615.79 ± 0.1% | 9.74 ± 0.1% | not timed | not timed | 7296.15 ± 2.5% | | 0.99 | 11.74 | 742.52 |
| imported/leipzig/tom-river | 2 | 6515.71 ± 1.5% | not timed | not timed | 5158.33 ± 0.2% | 31.02 ± 0.1% | not timed | not timed | 6597.00 ± 1.5% | | 0.99 | 1.26 | 210.03 |
| imported/leipzig/ing | 78424 | 601.76 ± 0.4% | not timed | not timed | 570.37 ± 0.1% | 28.23 ± 4.1% | not timed | not timed | 603.07 ± 0.6% | | 1.00 | 1.06 | 21.32 |
| imported/leipzig/ing-whitespace | 55248 | 1913.06 ± 1.6% | not timed | not timed | 2077.10 ± 0.8% | 20.28 ± 2.4% | not timed | not timed | 1924.70 ± 0.4% | | 0.99 | 0.92 | 94.34 |
| imported/leipzig/awyer-inn | 209 | 6373.18 ± 1.2% | not timed | not timed | 4287.87 ± 0.1% | 22.12 ± 0.2% | not timed | not timed | 6435.72 ± 1.1% | | 0.99 | 1.49 | 288.05 |
| imported/leipzig/quotes-bounded | 8886 | 2495.49 ± 0.9% | not timed | not timed | 3031.06 ± 0.5% | 38.24 ± 0.2% | not timed | not timed | 2509.22 ± 1.1% | | 0.99 | 0.82 | 65.26 |
| imported/leipzig/non-ascii-alternate | 2 | 12886.95 ± 2.0% | not timed | not timed | 5675.48 ± 0.1% | 51.02 ± 0.1% | not timed | not timed | 13084.24 ± 1.9% | | 0.98 | 2.27 | 252.61 |
| imported/leipzig/math-symbols | 69 | 1985.42 ± 0.7% | not timed | not timed | 613.10 ± 0.2% | 36.57 ± 0.0% | not timed | not timed | 1984.01 ± 0.5% | | 1.00 | 3.24 | 54.30 |
| imported/leipzig/bounded-strings-ending-z | 0 | 627.15 ± 3.1% | not timed | not timed | 616.35 ± 0.1% | 22.42 ± 0.1% | not timed | not timed | 629.15 ± 1.6% | | 1.00 | 1.02 | 27.97 |
| imported/lh3lh3-reb/uri | 17549 | 678.81 ± 0.1% | not timed | not timed | 1067.16 ± 0.1% | 28.25 ± 2.3% | not timed | not timed | 680.24 ± 0.1% | | 1.00 | 0.64 | 24.03 |
| imported/lh3lh3-reb/email | 15057 | 675.15 ± 0.1% | not timed | not timed | 1151.92 ± 0.1% | 30.90 ± 2.4% | not timed | not timed | 677.24 ± 0.1% | | 1.00 | 0.59 | 21.85 |
| imported/lh3lh3-reb/date | 668 | 893.07 ± 0.2% | not timed | not timed | 1029.60 ± 0.2% | 49.99 ± 3.8% | not timed | not timed | 893.56 ± 0.2% | | 1.00 | 0.87 | 17.87 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 646.00 ± 0.1% | not timed | not timed | 423.75 ± 0.1% | 15.75 ± 1.2% | not timed | not timed | 644.53 ± 0.2% | | 1.00 | 1.52 | 41.02 |
| imported/mariomka/email | 92 | 24340.32 ± 1.3% | not timed | not timed | 29784.87 ± 0.3% | 32.85 ± 0.1% | not timed | not timed | 24566.15 ± 1.5% | | 0.99 | 0.82 | 740.91 |
| imported/mariomka/uri | 5301 | 5560.77 ± 1.0% | not timed | not timed | 6109.07 ± 0.2% | 32.80 ± 0.8% | not timed | not timed | 5590.52 ± 0.8% | | 0.99 | 0.91 | 169.53 |
| imported/mariomka/ip | 5 | 2601.44 ± 2.8% | not timed | not timed | 2971.20 ± 0.2% | 21.05 ± 0.2% | not timed | not timed | 2606.34 ± 3.5% | | 1.00 | 0.88 | 123.59 |
| imported/rsc/no-exponential | 0 | 610.69 ± 0.1% | not timed | not timed | 319.04 ± 0.1% | 23.84 ± 0.3% | not timed | not timed | 608.86 ± 0.4% | | 1.00 | 1.91 | 25.62 |
| imported/rsc/literal | 1 | 1491.64 ± 1.9% | not timed | not timed | 1624.17 ± 6.9% | 189.23 ± 17.8% | not timed | not timed | 1497.59 ± 5.2% | | 1.00 | 0.92 | 7.88 |
| imported/rsc/not-literal | 2 | 777.67 ± 0.1% | not timed | not timed | 747.12 ± 0.4% | 46.11 ± 9.1% | not timed | not timed | 778.68 ± 2.1% | | 1.00 | 1.04 | 16.87 |
| imported/rsc/match-class | 1 | 1474.58 ± 10.0% | not timed | not timed | 1614.68 ± 0.2% | 58.35 ± 0.9% | not timed | not timed | 1472.06 ± 0.6% | | 1.00 | 0.91 | 25.27 |
| imported/rsc/match-class-in-range | 1 | 1477.17 ± 2.7% | not timed | not timed | 2261.28 ± 6.0% | 59.71 ± 5.9% | not timed | not timed | 1473.36 ± 0.7% | | 1.00 | 0.65 | 24.74 |
| imported/rsc/match-class-unicode | 1 | 540.75 ± 1.7% | not timed | not timed | 502.71 ± 0.4% | 72.38 ± 6.9% | not timed | not timed | 541.33 ± 0.6% | | 1.00 | 1.08 | 7.47 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1457.84 ± 0.1% | not timed | not timed | 946.63 ± 0.0% | 228.53 ± 0.6% | not timed | not timed | 1455.79 ± 0.1% | | 1.00 | 1.54 | 6.38 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21872.83 ± 0.1% | not timed | not timed | 14202.63 ± 0.1% | 3434.81 ± 1.1% | not timed | not timed | 21842.98 ± 0.2% | | 1.00 | 1.54 | 6.37 |
| imported/rsc/anchored-literal-short-match | 4 | 711.63 ± 2.0% | not timed | not timed | 491.77 ± 0.2% | 82.32 ± 5.8% | not timed | not timed | 723.81 ± 1.7% | | 0.98 | 1.45 | 8.64 |
| imported/rsc/anchored-literal-long-match | 4 | 10859.93 ± 1.8% | not timed | not timed | 7319.05 ± 0.2% | 1232.02 ± 3.2% | not timed | not timed | 10820.21 ± 1.8% | | 1.00 | 1.48 | 8.81 |
| imported/rsc/one-pass-short | 17 | 368.06 ± 1.1% | not timed | not timed | 215.22 ± 0.1% | 30.28 ± 10.4% | not timed | not timed | 370.18 ± 9.7% | | 0.99 | 1.71 | 12.16 |
| imported/rsc/one-pass-short-not | 17 | 267.10 ± 6.9% | not timed | not timed | 223.61 ± 0.4% | 31.00 ± 13.2% | not timed | not timed | 268.57 ± 2.4% | | 0.99 | 1.19 | 8.62 |
| imported/rsc/one-pass-long-prefix | 26 | 359.40 ± 7.2% | not timed | not timed | 284.23 ± 0.2% | 98.85 ± 19.3% | not timed | not timed | 363.06 ± 1.9% | | 0.99 | 1.26 | 3.64 |
| imported/rsc/one-pass-long-prefix-not | 26 | 359.04 ± 2.2% | not timed | not timed | 284.43 ± 0.0% | 66.61 ± 19.5% | not timed | not timed | 363.14 ± 2.1% | | 0.99 | 1.26 | 5.39 |
| imported/rsc/long-needle1 | 31 | 21983.03 ± 0.2% | not timed | not timed | 20142.70 ± 0.1% | 3.75 ± 0.2% | not timed | not timed | 21987.46 ± 0.2% | | 1.00 | 1.09 | 5867.18 |
| imported/rsc/long-needle2 | 31 | 22086.73 ± 0.2% | not timed | not timed | 216.06 ± 0.3% | 3.75 ± 0.1% | not timed | not timed | 22080.90 ± 0.1% | | 1.00 | 102.22 | 5893.49 |
| imported/rsc/easy0-32 | 26 | 1536.83 ± 1.8% | not timed | not timed | 1602.33 ± 4.0% | 148.96 ± 20.5% | not timed | not timed | 1539.07 ± 0.4% | | 1.00 | 0.96 | 10.32 |
| imported/rsc/easy0-1k | 26 | 13473.16 ± 0.2% | not timed | not timed | 12481.13 ± 1.8% | 2306.95 ± 15.4% | not timed | not timed | 13538.71 ± 2.3% | | 1.00 | 1.08 | 5.84 |
| imported/rsc/easy0-32k | 26 | 22739.19 ± 0.0% | not timed | not timed | 20292.67 ± 0.1% | 18798.64 ± 10.2% | not timed | not timed | 22754.06 ± 8.6% | | 1.00 | 1.12 | 1.21 |
| imported/rsc/easy0-1mb | 26 | 21970.30 ± 2.5% | not timed | not timed | 20070.42 ± 2.9% | 37811.21 ± 2.5% | not timed | not timed | 21893.09 ± 1.0% | | 1.00 | 1.09 | 0.58 |
| imported/rsc/easy1-32 | 19 | 768.52 ± 2.1% | not timed | not timed | 628.51 ± 0.7% | 139.23 ± 17.5% | not timed | not timed | 768.75 ± 7.5% | | 1.00 | 1.22 | 5.52 |
| imported/rsc/easy1-1k | 19 | 15780.15 ± 2.3% | not timed | not timed | 12859.76 ± 0.1% | 2461.61 ± 15.0% | not timed | not timed | 15765.73 ± 0.1% | | 1.00 | 1.23 | 6.41 |
| imported/rsc/easy1-32k | 19 | 495951.44 ± 0.2% | not timed | not timed | 406688.11 ± 0.1% | 20265.81 ± 0.1% | not timed | not timed | 493983.62 ± 0.3% | | 1.00 | 1.22 | 24.47 |
| imported/rsc/easy1-1mb | 19 | 15868932.78 ± 0.2% | not timed | not timed | 13152794.78 ± 0.2% | 38290.27 ± 3.6% | not timed | not timed | 15845377.70 ± 0.1% | | 1.00 | 1.21 | 414.44 |
| imported/rsc/medium-32 | 27 | 732.40 ± 1.8% | not timed | not timed | 641.66 ± 0.3% | 69.81 ± 9.7% | not timed | not timed | 737.24 ± 0.2% | | 0.99 | 1.14 | 10.49 |
| imported/rsc/medium-1k | 27 | 13055.49 ± 0.3% | not timed | not timed | 11359.66 ± 0.2% | 72.16 ± 0.2% | not timed | not timed | 13091.17 ± 0.6% | | 1.00 | 1.15 | 180.93 |
| imported/rsc/medium-32k | 27 | 407226.01 ± 0.3% | not timed | not timed | 346803.33 ± 0.1% | 48.78 ± 0.1% | not timed | not timed | 408774.69 ± 0.4% | | 1.00 | 1.17 | 8348.58 |
| imported/rsc/medium-1mb | 27 | 13059785.20 ± 0.1% | not timed | not timed | 11312410.50 ± 0.2% | 48.57 ± 0.2% | not timed | not timed | 13038945.86 ± 0.3% | | 1.00 | 1.15 | 268911.56 |
| imported/rsc/hard-32 | 58 | 422.97 ± 1.9% | not timed | not timed | 367.97 ± 0.0% | 49.46 ± 8.5% | not timed | not timed | 420.31 ± 0.3% | | 1.01 | 1.15 | 8.55 |
| imported/rsc/hard-1k | 27 | 12882.27 ± 0.4% | not timed | not timed | 11526.74 ± 0.1% | 40.39 ± 0.2% | not timed | not timed | 12811.37 ± 0.4% | | 1.01 | 1.12 | 318.95 |
| imported/rsc/hard-32k | 27 | 402708.42 ± 0.2% | not timed | not timed | 363027.70 ± 0.6% | 29.41 ± 0.0% | not timed | not timed | 400479.18 ± 0.4% | | 1.01 | 1.11 | 13693.04 |
| imported/rsc/hard-1mb | 51 | 8359144.27 ± 0.4% | not timed | not timed | 7256579.69 ± 0.0% | 29.46 ± 0.1% | not timed | not timed | 8366539.36 ± 0.2% | | 1.00 | 1.15 | 283729.12 |
| imported/rsc/reallyhard0-32 | 58 | 263.62 ± 2.4% | not timed | not timed | 223.09 ± 0.3% | 49.72 ± 7.7% | not timed | not timed | 263.91 ± 0.1% | | 1.00 | 1.18 | 5.30 |
| imported/rsc/reallyhard0-1k | 27 | 577.59 ± 0.7% | not timed | not timed | 582.84 ± 0.1% | 40.61 ± 0.2% | not timed | not timed | 578.65 ± 0.6% | | 1.00 | 0.99 | 14.22 |
| imported/rsc/reallyhard0-32k | 27 | 601.82 ± 0.6% | not timed | not timed | 615.10 ± 0.2% | 29.42 ± 0.1% | not timed | not timed | 600.50 ± 0.5% | | 1.00 | 0.98 | 20.46 |
| imported/rsc/reallyhard0-1mb | 51 | 623.52 ± 1.1% | not timed | not timed | 617.48 ± 0.2% | 29.42 ± 0.1% | not timed | not timed | 620.52 ± 0.7% | | 1.00 | 1.01 | 21.19 |
| imported/rsc/reallyreallyhard0-32 | 47 | 284.90 ± 1.6% | not timed | not timed | 194.61 ± 0.4% | 59.97 ± 14.4% | not timed | not timed | 286.73 ± 1.4% | | 0.99 | 1.46 | 4.75 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7000.55 ± 0.2% | not timed | not timed | 5924.47 ± 0.1% | 34.20 ± 0.7% | not timed | not timed | 7000.27 ± 0.2% | | 1.00 | 1.18 | 204.69 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21456.41 ± 0.1% | not timed | not timed | 19273.47 ± 0.1% | 24.79 ± 0.3% | not timed | not timed | 21454.28 ± 0.1% | | 1.00 | 1.11 | 865.60 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21428.23 ± 0.7% | not timed | not timed | 19740.10 ± 0.4% | 24.83 ± 0.2% | not timed | not timed | 21444.71 ± 0.4% | | 1.00 | 1.09 | 863.04 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 281.55 ± 1.7% | not timed | not timed | 213.62 ± 0.3% | 61.05 ± 11.1% | not timed | not timed | 282.76 ± 1.3% | | 1.00 | 1.32 | 4.61 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5934.03 ± 0.2% | not timed | not timed | 6244.96 ± 0.2% | 34.34 ± 1.2% | not timed | not timed | 5930.69 ± 0.2% | | 1.00 | 0.95 | 172.79 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21304.49 ± 0.0% | not timed | not timed | 19254.03 ± 0.1% | 24.71 ± 0.2% | not timed | not timed | 21368.79 ± 0.1% | | 1.00 | 1.11 | 862.13 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21156.00 ± 1.0% | not timed | not timed | 19691.98 ± 0.6% | 24.52 ± 3.0% | not timed | not timed | 21130.59 ± 0.7% | | 1.00 | 1.07 | 862.79 |
| imported/sherlock/name-sherlock | 776 | 20161.63 ± 5.7% | not timed | not timed | 18832.33 ± 0.1% | 10269.33 ± 16.7% | not timed | not timed | 20180.08 ± 2.4% | | 1.00 | 1.07 | 1.96 |
| imported/sherlock/name-holmes | 2766 | 15374.56 ± 1.4% | not timed | not timed | 15743.14 ± 0.2% | 3234.99 ± 13.7% | not timed | not timed | 15521.32 ± 1.4% | | 0.99 | 0.98 | 4.75 |
| imported/sherlock/name-sherlock-holmes | 1365 | 20198.76 ± 1.8% | not timed | not timed | 18781.08 ± 0.2% | 8150.72 ± 50.9% | not timed | not timed | 20220.35 ± 2.1% | | 1.00 | 1.08 | 2.48 |
| imported/sherlock/name-sherlock-casei | 816 | 15914.20 ± 0.1% | not timed | not timed | 4024.02 ± 0.1% | 32.51 ± 0.7% | not timed | not timed | 15906.62 ± 0.1% | | 1.00 | 3.95 | 489.55 |
| imported/sherlock/name-holmes-casei | 2802 | 9448.06 ± 6.7% | not timed | not timed | 3320.41 ± 0.1% | 37.33 ± 1.0% | not timed | not timed | 9452.68 ± 3.2% | | 1.00 | 2.85 | 253.11 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13009.39 ± 8.8% | not timed | not timed | 3960.26 ± 0.1% | 32.42 ± 0.4% | not timed | not timed | 13005.82 ± 1.5% | | 1.00 | 3.28 | 401.27 |
| imported/sherlock/name-whitespace | 1461 | 15587.96 ± 5.8% | not timed | not timed | 14770.99 ± 0.1% | 6470.43 ± 16.1% | not timed | not timed | 15645.54 ± 1.7% | | 1.00 | 1.06 | 2.41 |
| imported/sherlock/name-alt1 | 1142 | 11694.00 ± 0.2% | not timed | not timed | 16770.09 ± 1.3% | 4128.20 ± 20.6% | not timed | not timed | 11695.93 ± 2.3% | | 1.00 | 0.70 | 2.83 |
| imported/sherlock/name-alt2 | 3542 | 9010.05 ± 0.3% | not timed | not timed | 3836.93 ± 0.1% | 31.09 ± 0.2% | not timed | not timed | 9009.99 ± 0.3% | | 1.00 | 2.35 | 289.80 |
| imported/sherlock/name-alt3 | 4507 | 5569.52 ± 0.7% | not timed | not timed | 3636.06 ± 0.1% | 9.94 ± 4.4% | not timed | not timed | 5555.86 ± 0.5% | | 1.00 | 1.53 | 560.07 |
| imported/sherlock/name-alt3-casei | 4593 | 1528.81 ± 2.0% | not timed | not timed | 285.53 ± 0.2% | 6.44 ± 0.1% | not timed | not timed | 1528.53 ± 0.8% | | 1.00 | 5.35 | 237.44 |
| imported/sherlock/name-alt4 | 3686 | 6437.75 ± 0.2% | not timed | not timed | 3792.56 ± 0.2% | 31.28 ± 0.1% | not timed | not timed | 6453.99 ± 0.2% | | 1.00 | 1.70 | 205.83 |
| imported/sherlock/name-alt4-casei | 4254 | 2819.32 ± 2.0% | not timed | not timed | 2591.31 ± 0.2% | 19.88 ± 0.3% | not timed | not timed | 2812.57 ± 1.2% | | 1.00 | 1.09 | 141.84 |
| imported/sherlock/name-alt5 | 4028 | 6416.49 ± 0.4% | not timed | not timed | 3752.05 ± 0.1% | 21.85 ± 0.4% | not timed | not timed | 6417.51 ± 0.3% | | 1.00 | 1.71 | 293.62 |
| imported/sherlock/name-alt5-casei | 4104 | 3500.23 ± 1.9% | not timed | not timed | 2227.41 ± 0.1% | 14.34 ± 0.1% | not timed | not timed | 3496.08 ± 0.8% | | 1.00 | 1.57 | 244.13 |
| imported/sherlock/no-match-uncommon | 0 | 22068.30 ± 0.2% | not timed | not timed | 19930.34 ± 0.2% | 37405.34 ± 0.7% | not timed | not timed | 22056.48 ± 0.3% | | 1.00 | 1.11 | 0.59 |
| imported/sherlock/no-match-common | 0 | 21943.45 ± 0.1% | not timed | not timed | 19937.29 ± 0.1% | 1279.58 ± 0.7% | not timed | not timed | 21961.09 ± 0.2% | | 1.00 | 1.10 | 17.15 |
| imported/sherlock/no-match-really-common | 0 | 16334.89 ± 3.1% | not timed | not timed | 19041.75 ± 0.1% | 1282.81 ± 1.1% | not timed | not timed | 16429.06 ± 1.2% | | 0.99 | 0.86 | 12.73 |
| imported/sherlock/the-lower | 21654 | 2309.78 ± 0.7% | not timed | not timed | 2331.74 ± 0.3% | 243.67 ± 15.7% | not timed | not timed | 2319.10 ± 2.1% | | 1.00 | 0.99 | 9.48 |
| imported/sherlock/the-upper | 2223 | 12842.09 ± 7.4% | not timed | not timed | 13746.30 ± 0.4% | 2726.33 ± 15.8% | not timed | not timed | 12929.69 ± 0.8% | | 0.99 | 0.93 | 4.71 |
| imported/sherlock/the-casei | 23961 | 2004.84 ± 0.5% | not timed | not timed | 1317.95 ± 0.2% | 34.87 ± 0.7% | not timed | not timed | 2004.76 ± 0.4% | | 1.00 | 1.52 | 57.49 |
| imported/sherlock/everything-greedy | 581881 | 282.89 ± 0.6% | not timed | not timed | 166.02 ± 0.1% | 28.30 ± 30.7% | not timed | not timed | 281.99 ± 1.0% | | 1.00 | 1.70 | 10.00 |
| imported/sherlock/everything-greedy-nl | 594933 | 491.77 ± 0.1% | not timed | not timed | 212.26 ± 0.5% | 32.99 ± 0.1% | not timed | not timed | 491.02 ± 0.0% | | 1.00 | 2.32 | 14.91 |
| imported/sherlock/letters | 447175 | 61.75 ± 1.0% | not timed | not timed | 32.76 ± 0.2% | 6.71 ± 21.3% | not timed | not timed | 61.88 ± 0.3% | | 1.00 | 1.89 | 9.20 |
| imported/sherlock/letters-upper | 14180 | 448.31 ± 1.3% | not timed | not timed | 372.18 ± 0.1% | 29.64 ± 23.0% | not timed | not timed | 446.79 ± 0.2% | | 1.00 | 1.20 | 15.12 |
| imported/sherlock/letters-lower | 432995 | 62.67 ± 1.0% | not timed | not timed | 33.76 ± 0.1% | 5.90 ± 36.7% | not timed | not timed | 62.72 ± 0.5% | | 1.00 | 1.86 | 10.62 |
| imported/sherlock/words | 447639 | 113.11 ± 0.6% | not timed | not timed | 82.94 ± 0.2% | 13.67 ± 6.8% | not timed | not timed | 113.74 ± 0.4% | | 0.99 | 1.36 | 8.27 |
| imported/sherlock/before-holmes | 4073 | 10381.57 ± 0.3% | not timed | not timed | 8511.69 ± 0.3% | 23.94 ± 2.2% | not timed | not timed | 10401.20 ± 0.2% | | 1.00 | 1.22 | 433.67 |
| imported/sherlock/before-after-holmes | 2593 | 10019.19 ± 0.8% | not timed | not timed | 9582.53 ± 0.6% | 24.18 ± 0.4% | not timed | not timed | 10059.99 ± 0.5% | | 1.00 | 1.05 | 414.34 |
| imported/sherlock/holmes-cochar-watson | 150 | 5215.09 ± 0.4% | not timed | not timed | 3436.55 ± 0.0% | 30.98 ± 0.5% | not timed | not timed | 5216.24 ± 0.3% | | 1.00 | 1.52 | 168.32 |
| imported/sherlock/holmes-coword-watson | 14309 | 1156.71 ± 0.2% | not timed | not timed | 1126.58 ± 0.1% | 6.78 ± 0.5% | not timed | not timed | 1155.80 ± 0.3% | | 1.00 | 1.03 | 170.63 |
| imported/sherlock/quotes | 14437 | 1577.94 ± 0.6% | not timed | not timed | 1757.53 ± 0.9% | 35.16 ± 0.2% | not timed | not timed | 1578.04 ± 0.2% | | 1.00 | 0.90 | 44.88 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17767.36 ± 0.2% | not timed | not timed | 16244.16 ± 0.1% | 36.79 ± 0.2% | not timed | not timed | 17715.20 ± 0.1% | | 1.00 | 1.09 | 482.98 |
| imported/sherlock/word-ending-n | 35297 | 481.28 ± 2.5% | not timed | not timed | 409.55 ± 0.1% | 23.58 ± 23.8% | not timed | not timed | 391.88 ± 0.3% | | 1.23 | 1.18 | 20.41 |
| imported/sherlock/repeated-class-negation | 2130 | 15078.23 ± 0.6% | not timed | not timed | 11136.07 ± 0.5% | 11.59 ± 0.1% | not timed | not timed | 15093.51 ± 0.9% | | 1.00 | 1.35 | 1301.46 |
| imported/sherlock/ing-suffix | 20547 | 560.37 ± 0.5% | not timed | not timed | 517.84 ± 0.1% | 28.87 ± 0.1% | not timed | not timed | 559.41 ± 0.4% | | 1.00 | 1.08 | 19.41 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1672.20 ± 0.4% | not timed | not timed | 2105.46 ± 0.3% | 20.53 ± 0.1% | not timed | not timed | 1675.99 ± 0.6% | | 1.00 | 0.79 | 81.44 |
| opt/accelerate/whole-line | 239963 | 458.22 ± 0.1% | not timed | not timed | 371.59 ± 0.4% | 92.39 ± 16.3% | not timed | not timed | 457.81 ± 0.4% | | 1.00 | 1.23 | 4.96 |
| opt/accelerate/non-dna | 16745 | 431.63 ± 0.9% | not timed | not timed | 400.16 ± 0.2% | 29.52 ± 20.6% | not timed | not timed | 432.26 ± 0.2% | | 1.00 | 1.08 | 14.62 |
| opt/backtrack/words-english | 40536 | 141.91 ± 1.3% | not timed | not timed | 93.25 ± 0.3% | 19.62 ± 7.3% | not timed | not timed | 141.83 ± 1.9% | | 1.00 | 1.52 | 7.23 |
| opt/fixed-length/too-small-ascii | 0 | 315.78 ± 0.5% | not timed | not timed | 699.73 ± 2.6% | 80.53 ± 0.5% | not timed | not timed | 316.70 ± 0.4% | | 1.00 | 0.45 | 3.92 |
| opt/fixed-length/too-big-ascii | 0 | 3433.77 ± 0.1% | not timed | not timed | 5770.94 ± 0.5% | 125.41 ± 0.1% | not timed | not timed | 3426.43 ± 0.0% | | 1.00 | 0.60 | 27.38 |
| opt/fixed-length/go33484-1 | 0 | 658937.38 ± 0.1% | not timed | not timed | 1106163.77 ± 1.3% | 61644.16 ± 0.3% | not timed | not timed | 659523.55 ± 0.1% | | 1.00 | 0.60 | 10.69 |
| opt/fixed-length/go33484-2 | 0 | 658827.92 ± 0.2% | not timed | not timed | 1114920.56 ± 1.1% | 32235.01 ± 1.9% | not timed | not timed | 659491.36 ± 0.1% | | 1.00 | 0.59 | 20.44 |
| opt/fixed-length/go33484-3 | 0 | 65904.28 ± 0.6% | not timed | not timed | 109486.54 ± 0.8% | 769.74 ± 0.2% | not timed | not timed | 65935.00 ± 0.5% | | 1.00 | 0.60 | 85.62 |
| opt/literal-alt/one-pattern | 1 | 549.61 ± 6.6% | not timed | not timed | 542.63 ± 0.1% | 0.40 ± 0.4% | not timed | not timed | 549.99 ± 1.6% | | 1.00 | 1.01 | 1359.56 |
| opt/onepass/fn-predicate | 916 | 369.10 ± 0.9% | not timed | not timed | 335.70 ± 0.1% | 201.90 ± 14.9% | not timed | not timed | 370.87 ± 0.8% | | 1.00 | 1.10 | 1.83 |
| opt/onepass/first-three-words-english | 35128 | 179.94 ± 2.6% | not timed | not timed | 202.30 ± 0.1% | 79.97 ± 12.9% | not timed | not timed | 182.16 ± 7.3% | | 0.99 | 0.89 | 2.25 |
| opt/prefilter/literal-english | 1 | 21157.02 ± 0.3% | not timed | not timed | 20277.79 ± 0.2% | 17853.91 ± 0.5% | not timed | not timed | 21163.15 ± 0.2% | | 1.00 | 1.04 | 1.19 |
| opt/prefilter/literal-casei-english | 1 | 14704.80 ± 0.3% | not timed | not timed | 4323.86 ± 0.1% | 32.69 ± 0.4% | not timed | not timed | 14714.74 ± 0.4% | | 1.00 | 3.40 | 449.76 |
| opt/prefilter/literal-russian | 1 | 21234.01 ± 0.5% | not timed | not timed | 19886.69 ± 0.7% | 3328.41 ± 0.4% | not timed | not timed | 21231.66 ± 0.5% | | 1.00 | 1.07 | 6.38 |
| opt/prefilter/literal-casei-russian | 1 | 8594.14 ± 0.3% | not timed | not timed | 3893.13 ± 0.2% | 31.77 ± 0.2% | not timed | not timed | 8590.57 ± 0.3% | | 1.00 | 2.21 | 270.54 |
| opt/prefilter/rust-functions | 948 | 6824.40 ± 0.2% | not timed | not timed | 8995.02 ± 0.4% | 1874.16 ± 0.3% | not timed | not timed | 6836.85 ± 0.2% | | 1.00 | 0.76 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 29573610.65 ± 0.1% | not timed | not timed | 21360824.52 ± 0.4% | 50.30 ± 0.3% | not timed | not timed | 29598769.59 ± 0.1% | | 1.00 | 1.38 | 587941.80 |
| opt/reverse-inner/holmes | 2593 | 10023.17 ± 0.9% | not timed | not timed | 9553.70 ± 0.4% | 24.20 ± 1.5% | not timed | not timed | 10069.17 ± 0.5% | | 1.00 | 1.05 | 414.19 |
| opt/reverse-inner/email | 47 | 36566.15 ± 2.3% | not timed | not timed | 45043.52 ± 0.4% | 32.40 ± 0.2% | not timed | not timed | 36875.59 ± 2.8% | | 0.99 | 0.81 | 1128.43 |
| opt/reverse-inner/factored-prefix | 3542 | 594.37 ± 0.5% | not timed | not timed | 598.03 ± 0.1% | 12.55 ± 0.6% | not timed | not timed | 592.76 ± 0.5% | | 1.00 | 0.99 | 47.34 |
| opt/reverse-inner/no-quadratic-backward | 0 | 20999.47 ± 0.1% | not timed | not timed | 613.56 ± 0.1% | 74.80 ± 0.1% | not timed | not timed | 21140.24 ± 0.2% | | 0.99 | 34.23 | 280.73 |
| opt/reverse-inner/no-quadratic-forward | 0 | 719.89 ± 4.4% | not timed | not timed | 289.11 ± 0.9% | 24.69 ± 0.0% | not timed | not timed | 732.23 ± 4.4% | | 0.98 | 2.49 | 29.16 |
| opt/reverse-suffix/holmes | 4073 | 10370.86 ± 0.5% | not timed | not timed | 8521.46 ± 0.2% | 24.05 ± 0.3% | not timed | not timed | 10396.62 ± 0.3% | | 1.00 | 1.22 | 431.31 |
| opt/reverse-suffix/no-quadratic | 0 | 21072.51 ± 0.2% | not timed | not timed | 614.32 ± 0.5% | 74.94 ± 0.1% | not timed | not timed | 21150.82 ± 0.0% | | 1.00 | 34.30 | 281.21 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.26 ± 2.4% | not timed | not timed | 132.39 ± 0.6% | 13.55 ± 16.5% | not timed | not timed | 121.05 ± 2.5% | | 1.00 | 0.92 | 8.95 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.75 ± 0.8% | not timed | not timed | 132.58 ± 0.0% | 13.76 ± 12.6% | not timed | not timed | 120.03 ± 6.7% | | 1.01 | 0.91 | 8.78 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.4% | not timed | not timed | 0.55 ± 0.3% | 112.14 ± 2.9% | not timed | not timed | 0.28 ± 9.2% | | 0.99 | 0.50 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 321.09 ± 0.4% | not timed | not timed | 291.97 ± 0.7% | 104.30 ± 1.8% | not timed | not timed | 318.41 ± 0.2% | | 1.01 | 1.10 | 3.08 |
| reported/i13-subset-regex/original-ascii | 4094 | 11229.28 ± 0.4% | not timed | not timed | 4569.05 ± 0.7% | 11.51 ± 0.1% | not timed | not timed | 11283.54 ± 1.1% | | 1.00 | 2.46 | 975.65 |
| reported/i13-subset-regex/original-unicode | 4094 | 10784.32 ± 1.0% | not timed | not timed | 254.20 ± 2.7% | 11.51 ± 0.1% | not timed | not timed | 11261.87 ± 0.9% | | 0.96 | 42.43 | 937.02 |
| reported/i13-subset-regex/big-ascii | 1955 | 10733.52 ± 1.4% | not timed | not timed | 68.40 ± 3.6% | 9.85 ± 0.0% | not timed | not timed | 10788.04 ± 0.7% | | 0.99 | 156.93 | 1089.15 |
| reported/i13-subset-regex/big-unicode | 1955 | 10662.40 ± 2.3% | not timed | not timed | 12.23 ± 55.0% | 9.86 ± 1.0% | not timed | not timed | 10788.99 ± 0.8% | | 0.99 | 872.17 | 1081.82 |
| reported/i13-subset-regex/huge-ascii | 55 | 10145.60 ± 1.0% | not timed | not timed | 11.07 ± 0.0% | 8.77 ± 0.2% | not timed | not timed | 10112.66 ± 1.1% | | 1.00 | 916.83 | 1157.50 |
| reported/i13-subset-regex/huge-unicode | 55 | 10086.71 ± 0.8% | not timed | not timed | 11.02 ± 0.4% | 8.77 ± 0.1% | not timed | not timed | 9883.04 ± 3.0% | | 1.02 | 915.28 | 1150.54 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.53 ± 0.1% | not timed | not timed | 11.03 ± 0.1% | 8.78 ± 1.2% | not timed | not timed | 3.53 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.96 ± 0.1% | not timed | not timed | 10.98 ± 0.3% | 8.78 ± 0.1% | not timed | not timed | 4.96 ± 0.1% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 483.73 ± 0.1% | not timed | not timed | 104.54 ± 0.1% | 6.55 ± 0.5% | not timed | not timed | 485.10 ± 0.3% | | 1.00 | 4.63 | 73.85 |
| reported/i787-keywords/opt-ascii | 5674 | 484.96 ± 0.5% | not timed | not timed | 269.19 ± 0.2% | 10.20 ± 0.2% | not timed | not timed | 483.62 ± 0.4% | | 1.00 | 1.80 | 47.52 |
| slow/quadratic-regex-1x | 100 | 7.08 ± 0.4% | not timed | not timed | 4.96 ± 0.1% | 0.05 ± 0.1% | not timed | not timed | 6.90 ± 0.4% | | 1.03 | 1.43 | 143.97 |
| slow/quadratic-regex-2x | 199 | 3.42 ± 0.3% | not timed | not timed | 2.76 ± 0.1% | 0.01 ± 0.2% | not timed | not timed | 3.43 ± 0.2% | | 1.00 | 1.24 | 268.77 |
| slow/quadratic-haystack-1x | 100 | 22.08 ± 6.3% | not timed | not timed | 9.98 ± 0.3% | 1.01 ± 12.8% | not timed | not timed | 22.03 ± 1.6% | | 1.00 | 2.21 | 21.76 |
| slow/quadratic-haystack-2x | 200 | 19.74 ± 1.1% | not timed | not timed | 5.53 ± 0.4% | 0.54 ± 0.2% | not timed | not timed | 19.73 ± 7.1% | | 1.00 | 3.57 | 36.37 |
| unicode/codepoints/any-one | 1112064 | 280.87 ± 0.1% | not timed | not timed | 174.73 ± 0.1% | 18.63 ± 5.0% | not timed | not timed | 280.28 ± 0.3% | | 1.00 | 1.61 | 15.08 |
| unicode/codepoints/any-all | 4382592 | 281.91 ± 1.1% | not timed | not timed | 246.77 ± 0.3% | 117.19 ± 0.4% | not timed | not timed | 282.84 ± 1.5% | | 1.00 | 1.14 | 2.41 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.74 ± 1.0% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 603.15 ± 0.8% | not timed | not timed | 615.71 ± 0.1% | 135.32 ± 0.4% | not timed | not timed | 604.44 ± 0.5% | | 1.00 | 0.98 | 4.46 |
| unicode/overlapping-words/ascii | 6156 | 32.32 ± 0.2% | not timed | not timed | 38.88 ± 0.1% | 3.93 ± 1.2% | not timed | not timed | 32.36 ± 0.3% | | 1.00 | 0.83 | 8.23 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.1% | not timed | not timed | 4.12 ± 0.1% | 2.34 ± 0.8% | not timed | not timed | 1.43 ± 0.1% | | 1.01 | 0.35 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 9.4% | not timed | not timed | 4.13 ± 0.3% | 6.25 ± 9.3% | not timed | not timed | 1.28 ± 0.2% | | 1.00 | 0.31 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 129.78 ± 4.0% | not timed | not timed | 83.41 ± 0.2% | 11.89 ± 14.6% | not timed | not timed | 130.04 ± 3.0% | | 1.00 | 1.56 | 10.91 |
| unicode/word/boundary-long-english | 3466 | 608.66 ± 0.3% | not timed | not timed | 605.32 ± 0.1% | 30.68 ± 1.0% | not timed | not timed | 607.66 ± 1.4% | | 1.00 | 1.01 | 19.84 |
| unicode/word/around-holmes-english | 27 | 20341.90 ± 0.1% | not timed | not timed | 20068.22 ± 0.2% | 22.22 ± 0.9% | not timed | not timed | 20358.66 ± 0.2% | | 1.00 | 1.01 | 915.55 |
| wild/bibleref/long | 874 | 565.87 ± 0.2% | not timed | not timed | 584.36 ± 0.1% | 6.52 ± 0.1% | not timed | not timed | 567.66 ± 0.3% | | 1.00 | 0.97 | 86.75 |
| wild/bibleref/short | 30 | 25.25 ± 1.7% | not timed | not timed | 30.60 ± 1.0% | 14.33 ± 7.5% | not timed | not timed | 25.02 ± 5.2% | | 1.01 | 0.83 | 1.76 |
| wild/bibleref/line | 874 | 398.56 ± 1.8% | not timed | not timed | 213.21 ± 1.2% | 9.20 ± 8.6% | not timed | not timed | 400.35 ± 0.2% | | 1.00 | 1.87 | 43.32 |
| wild/caddy/caddy | 6 | 422.13 ± 8.6% | not timed | not timed | 249.11 ± 0.1% | 67.01 ± 12.9% | not timed | not timed | 423.12 ± 0.7% | | 1.00 | 1.69 | 6.30 |
| wild/dot-star-capture/rust-src-tools | 6 | 1061.15 ± 0.2% | not timed | not timed | 345.09 ± 0.2% | 13.53 ± 0.2% | not timed | not timed | 1056.01 ± 0.4% | | 1.00 | 3.08 | 78.43 |
| wild/ruff/noqa | 84 | 440.03 ± 0.2% | not timed | not timed | 460.27 ± 0.1% | 19.53 ± 1.9% | not timed | not timed | 439.35 ± 2.6% | | 1.00 | 0.96 | 22.53 |
| wild/ruff/unnecessary-coding-comment | 16 | 961.12 ± 0.4% | not timed | not timed | 702.08 ± 0.2% | 135.22 ± 11.9% | not timed | not timed | 960.77 ± 0.4% | | 1.00 | 1.37 | 7.11 |
| wild/ruff/string-quote-prefix | 2972 | 1370.47 ± 0.7% | not timed | not timed | 440.13 ± 0.1% | 316.99 ± 25.4% | not timed | not timed | 1372.86 ± 0.7% | | 1.00 | 3.11 | 4.32 |
| wild/ruff/space-around-operator | 1224378 | 223.27 ± 1.7% | not timed | not timed | 186.56 ± 0.0% | 18.34 ± 1.7% | not timed | not timed | 223.91 ± 1.8% | | 1.00 | 1.20 | 12.17 |
| wild/ruff/shebang | 282 | 973.17 ± 0.4% | not timed | not timed | 328.79 ± 0.3% | 111.99 ± 9.1% | not timed | not timed | 980.20 ± 0.4% | | 0.99 | 2.96 | 8.69 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13849.59 ± 0.2% | not timed | not timed | 13826.26 ± 0.4% | 6956.79 ± 1.1% | not timed | not timed | 13855.98 ± 0.1% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12850.54 ± 0.2% | not timed | not timed | 13524.95 ± 0.3% | 6406.13 ± 0.5% | not timed | not timed | 12872.09 ± 0.3% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13249.96 ± 0.4% | not timed | not timed | 13664.78 ± 0.3% | 6621.46 ± 0.9% | not timed | not timed | 13227.84 ± 0.3% | | 1.00 | 0.97 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9579.58 ± 0.2% | not timed | not timed | 13600.29 ± 0.3% | 6748.32 ± 1.4% | not timed | not timed | 9584.41 ± 0.4% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 121.86 ± 14.1% | not timed | not timed | 66.24 ± 0.6% | 2.22 ± 0.7% | not timed | not timed | 122.18 ± 14.2% | | 1.00 | 1.84 | 54.95 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 1.5% | not timed | not timed | 0.01 ± 1.0% | 0.01 ± 19.9% | not timed | not timed | 0.03 ± 11.5% | | 0.99 | 3.09 | 3.65 |
| dictionary/compile/english-15 | 1 | 0.35 ± 38.3% | not timed | not timed | 0.07 ± 1.1% | 0.10 ± 11.6% | not timed | not timed | 0.35 ± 1.3% | | 1.00 | 4.97 | 3.37 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.26 ± 3.5% | not timed | not timed | 0.02 ± 0.9% | 35.56 ± 11.5% | not timed | not timed | 0.25 ± 3.9% | | 1.01 | 13.19 | 0.0072 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.41 ± 6.7% | not timed | not timed | 11.60 ± 0.2% | 55.04 ± 21.1% | not timed | not timed | 47.79 ± 2.2% | | 0.99 | 4.09 | 0.86 |
| reported/i787-keywords/compile | 1 | 35.43 ± 13.3% | not timed | not timed | 2.13 ± 1.3% | 17.19 ± 26.7% | not timed | not timed | 35.55 ± 2.8% | | 1.00 | 16.59 | 2.06 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 368.35 ± 2.2% | not timed | not timed | 119.11 ± 0.3% | 577.46 ± 27.1% | not timed | not timed | 370.49 ± 3.4% | | 0.99 | 3.09 | 0.64 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 48.59 ± 1.9% | not timed | not timed | 4.14 ± 0.8% | 44.02 ± 14.1% | not timed | not timed | 49.45 ± 21.9% | | 0.98 | 11.75 | 1.10 |
| unicode/compile/one-letter | 53 | 6.77 ± 13.3% | not timed | not timed | 4.58 ± 0.6% | 67.07 ± 5.6% | not timed | not timed | 6.84 ± 11.0% | | 0.99 | 1.48 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.10 ± 15.2% | not timed | not timed | 0.10 ± 0.8% | 67.49 ± 2.4% | not timed | not timed | 1.10 ± 16.5% | | 1.00 | 10.95 | 0.0163 |
| unicode/compile/fifty-letters-ascii | 1 | 225.39 ± 9.6% | not timed | not timed | 53.01 ± 0.1% | 202.01 ± 11.9% | not timed | not timed | 225.36 ± 11.2% | | 1.00 | 4.25 | 1.12 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 383.02 ± 2.8% | not timed | not timed | 47.03 ± 0.5% | 678.80 ± 23.3% | not timed | not timed | 385.87 ± 8.3% | | 0.99 | 8.14 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 600.51 ± 13.9% | not timed | not timed | 147.25 ± 0.3% | 642.83 ± 13.3% | not timed | not timed | 614.91 ± 15.3% | | 0.98 | 4.08 | 0.93 |
| unicode/compile/negated-class-matches-codepoint | 1 | 330.47 ± 6.1% | not timed | not timed | 51.12 ± 0.5% | 1287.88 ± 23.6% | not timed | not timed | 329.97 ± 2.6% | | 1.00 | 6.47 | 0.26 |
| wild/bibleref/compile | 3 | 5.99 ± 1.6% | not timed | not timed | 1.95 ± 0.5% | 31.57 ± 3.7% | not timed | not timed | 6.02 ± 2.0% | | 0.99 | 3.07 | 0.19 |
| wild/url/compile | 1 | 0.66 ± 1.4% | not timed | not timed | 0.15 ± 0.3% | 0.39 ± 28.4% | not timed | not timed | 0.66 ± 10.9% | | 1.00 | 4.50 | 1.68 |

