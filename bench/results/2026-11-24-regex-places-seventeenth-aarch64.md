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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507055345 |
| Date | 2026-11-25 |
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
| literal: a word | 217 | 19216.09 ± 0.5% | 5074.06 ± 0.4% | 28.29 ± 0.3% | 18052.53 ± 1.3% | 9034.96 ± 8.6% | 17.34 ± 0.2% | 86.11 ± 0.2% | 19249.57 ± 1.2% | 3.79 | 1.00 | 1.06 | 2.13 |
| literal: a word that is not there | 0 | 21408.60 ± 1.4% | 4932.45 ± 0.2% | 28.29 ± 0.4% | 19654.10 ± 2.2% | 28586.23 ± 1.8% | 17.05 ± 0.4% | 82.22 ± 0.3% | 21353.26 ± 1.8% | 4.34 | 1.00 | 1.09 | 0.75 |
| literal: one of four words | 661 | 6410.19 ± 0.7% | 1970.15 ± 0.5% | 14.33 ± 0.1% | 3937.51 ± 0.2% | 21.87 ± 0.1% | 5.45 ± 0.2% | 6.78 ± 0.3% | 6414.55 ± 0.4% | 3.25 | 1.00 | 1.63 | 293.09 |
| literal: a word in any case | 217 | 15106.86 ± 0.8% | 2098.26 ± 0.5% | 21.44 ± 0.8% | 3963.11 ± 0.5% | 38.07 ± 0.3% | refused | differs | 15082.24 ± 0.6% | 7.20 | 1.00 | 3.81 | 396.82 |
| literal: an href attribute | 33 | 16788.87 ± 1.0% | 617.33 ± 0.2% | 27.31 ± 0.2% | 17006.07 ± 1.6% | 2255.46 ± 0.6% | 13.10 ± 0.1% | 75.25 ± 0.1% | 16883.56 ± 1.0% | 27.20 | 0.99 | 0.99 | 7.44 |
| literal: a word, second text | 123 | 19766.37 ± 2.7% | 3420.23 ± 0.2% | 28.01 ± 0.2% | 18285.90 ± 2.0% | 7615.48 ± 3.6% | 20.09 ± 0.7% | 69.65 ± 0.3% | 19671.45 ± 1.4% | 5.78 | 1.00 | 1.08 | 2.60 |
| class: two capitalized words | 1331 | 1064.06 ± 0.5% | 608.96 ± 0.2% | 26.03 ± 0.2% | 584.49 ± 0.2% | 40.61 ± 1.1% | 14.72 ± 0.3% | 68.00 ± 1.1% | 1063.49 ± 0.3% | 1.75 | 1.00 | 1.82 | 26.20 |
| class: a word that ends in ing | 3399 | 581.73 ± 0.3% | 581.93 ± 0.3% | 17.96 ± 0.2% | 547.45 ± 0.4% | 29.60 ± 6.5% | 8.19 ± 0.3% | 18.22 ± 0.4% | 583.02 ± 0.1% | 1.00 | 1.00 | 1.06 | 19.65 |
| class: a word in capitals | 2332 | 1389.25 ± 0.3% | 614.18 ± 0.1% | 27.62 ± 0.5% | 572.09 ± 0.3% | 43.57 ± 6.8% | 17.17 ± 0.4% | 82.98 ± 0.6% | 1390.46 ± 0.3% | 2.26 | 1.00 | 2.43 | 31.89 |
| class: a number | 8288 | 2124.86 ± 0.3% | 852.75 ± 0.1% | 27.78 ± 0.3% | 1719.65 ± 0.1% | 42.36 ± 16.3% | 0.55 ± 0.1% | 56.99 ± 0.5% | 2131.74 ± 0.3% | 2.49 | 1.00 | 1.24 | 50.16 |
| class: two capitalized words, second text | 5359 | 525.67 ± 0.3% | 534.79 ± 0.2% | 23.35 ± 0.1% | 483.58 ± 0.2% | 34.96 ± 10.5% | 17.07 ± 0.1% | 63.57 ± 0.4% | 525.72 ± 0.2% | 0.98 | 1.00 | 1.09 | 15.04 |
| other: a word between two words | 6104 | 807.77 ± 0.1% | 608.54 ± 0.1% | 23.52 ± 0.2% | 735.94 ± 0.6% | 109.67 ± 5.6% | 11.15 ± 0.2% | 69.31 ± 0.7% | 807.05 ± 0.2% | 1.33 | 1.00 | 1.10 | 7.37 |
| other: a number before a unit, second text | 1481 | 6156.70 ± 0.9% | 1130.47 ± 0.7% | 25.96 ± 0.3% | 5634.46 ± 0.6% | 40.74 ± 16.0% | 18.16 ± 0.3% | 66.88 ± 0.2% | 6183.06 ± 1.4% | 5.45 | 1.00 | 1.09 | 151.12 |
| other: a heading's start tag | 110 | 14092.27 ± 1.3% | 750.44 ± 0.1% | 27.38 ± 0.4% | 1709.83 ± 0.3% | 1582.75 ± 3.6% | 16.08 ± 0.2% | 88.40 ± 0.4% | 14112.96 ± 1.6% | 18.78 | 1.00 | 8.24 | 8.90 |
| other: a whole word | 217 | 16133.02 ± 0.7% | 608.57 ± 0.1% | 29.32 ± 0.4% | 14478.05 ± 1.2% | 47.95 ± 0.3% | 13.03 ± 0.1% | 55.83 ± 0.4% | 16133.36 ± 0.4% | 26.51 | 1.00 | 1.11 | 336.47 |
| other: a line's first word, second text | 3716 | 2108.34 ± 0.4% | 599.83 ± 0.2% | 30.66 ± 0.5% | 1725.35 ± 0.7% | 62.01 ± 5.8% | refused | refused | 2108.42 ± 0.5% | 3.51 | 1.00 | 1.22 | 34.00 |
| other: fourteen octets before an x | 87 | 23749.87 ± 2.3% | 217.83 ± 0.6% | 6.53 ± 0.2% | 4052.62 ± 0.8% | 10.63 ± 0.3% | differs | 17.56 ± 0.3% | 23881.94 ± 5.4% | 109.03 | 0.99 | 5.86 | 2234.83 |
| other: a Greek word | 21815 | 520.13 ± 0.6% | 425.31 ± 0.1% | 30.76 ± 0.2% | 289.69 ± 0.3% | 43.58 ± 10.0% | differs | refused | 521.84 ± 0.7% | 1.22 | 1.00 | 1.80 | 11.94 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.29 ± 0.4% | 29.23 ± 0.2% | 0.86 ± 0.2% | 19.84 ± 0.2% | 2.77 ± 0.6% | differs | 4.02 ± 0.1% | 29.29 ± 0.2% | 1.00 | 1.00 | 1.48 | 10.58 |
| a UUID | 32895 | 24.69 ± 0.2% | 24.65 ± 0.4% | 0.64 ± 0.2% | 15.14 ± 0.1% | 3.09 ± 0.4% | 0.73 ± 0.2% | 3.62 ± 0.3% | 24.72 ± 0.1% | 1.00 | 1.00 | 1.63 | 7.99 |
| an IPv4 address | 33176 | 38.41 ± 0.7% | 38.49 ± 0.4% | 2.07 ± 0.3% | 29.44 ± 0.2% | 6.66 ± 0.2% | differs | 4.17 ± 0.1% | 38.44 ± 0.2% | 1.00 | 1.00 | 1.30 | 5.77 |
| a date and time | 32954 | 34.35 ± 0.4% | 34.12 ± 0.2% | 1.44 ± 0.1% | 21.53 ± 0.1% | 7.03 ± 0.1% | 1.25 ± 0.3% | 7.14 ± 0.1% | 34.24 ± 0.3% | 1.01 | 1.00 | 1.60 | 4.89 |
| a field path | 32606 | 32.18 ± 0.2% | 32.62 ± 0.5% | 1.01 ± 0.4% | 23.30 ± 0.1% | 3.50 ± 1.2% | differs | 2.93 ± 0.2% | 32.58 ± 0.3% | 0.99 | 0.99 | 1.38 | 9.20 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.12 ± 0.3% | 11.12 ± 0.3% | 11.02 ± 0.3% | 11.78 ± 0.2% | 4.85 ± 3.1% | 0.94 ± 0.4% | none | 11.13 ± 0.6% | 1.00 | 1.00 | 0.94 | 2.29 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 228.78 ± 0.2% | 229.28 ± 0.1% | 271.87 ± 0.1% | 87.42 ± 1.3% | 213.63 ± 8.6% | 487.97 ± 3.0% | 3751.49 ± 0.5% | 228.96 ± 0.3% | 1.00 | 1.00 | 2.62 | 1.07 |
| a UUID | 62 | 150.27 ± 0.4% | 150.21 ± 0.2% | 168.28 ± 0.2% | 46.36 ± 0.8% | 98.25 ± 1.5% | 192.19 ± 1.9% | 4482.85 ± 1.2% | 150.34 ± 0.2% | 1.00 | 1.00 | 3.24 | 1.53 |
| an IPv4 address | 29 | 417.90 ± 0.5% | 418.06 ± 0.4% | 586.74 ± 0.7% | 77.92 ± 0.2% | 130.10 ± 1.0% | 304.57 ± 0.3% | 7652.13 ± 0.3% | 417.82 ± 0.4% | 1.00 | 1.00 | 5.36 | 3.21 |
| a date and time | 56 | 301.19 ± 0.2% | 301.54 ± 0.3% | 380.29 ± 0.4% | 73.89 ± 0.3% | 136.35 ± 3.1% | 330.72 ± 1.5% | 4963.73 ± 0.4% | 301.35 ± 0.3% | 1.00 | 1.00 | 4.08 | 2.21 |
| a field path | 39 | 222.25 ± 0.5% | 222.70 ± 0.5% | 263.44 ± 0.4% | 79.90 ± 1.2% | 203.01 ± 1.4% | 493.06 ± 3.2% | 4854.38 ± 1.6% | 222.47 ± 0.3% | 1.00 | 1.00 | 2.78 | 1.09 |
| literal: a word | 7 | 608.35 ± 0.4% | 659.41 ± 0.5% | 1186.82 ± 0.1% | 513.82 ± 0.0% | 614.19 ± 4.0% | 940.95 ± 0.8% | 30802.44 ± 0.6% | 608.28 ± 0.3% | 0.92 | 1.00 | 1.18 | 0.99 |
| literal: a word that is not there | 8 | 584.20 ± 0.5% | 636.23 ± 0.3% | 1117.85 ± 0.7% | 465.71 ± 0.7% | 588.57 ± 5.1% | 888.36 ± 0.7% | 29375.68 ± 0.1% | 584.65 ± 0.4% | 0.92 | 1.00 | 1.25 | 0.99 |
| literal: one of four words | 26 | 239.13 ± 0.3% | 389.23 ± 0.4% | 533.30 ± 0.5% | 50.32 ± 0.7% | 237.70 ± 1.1% | 377.78 ± 2.2% | 15754.06 ± 0.1% | 239.52 ± 0.5% | 0.61 | 1.00 | 4.75 | 1.01 |
| literal: a word in any case | 11 | 442.07 ± 0.3% | 473.40 ± 0.2% | 700.00 ± 0.2% | 15.58 ± 0.2% | 642.02 ± 3.2% | refused | 23589.82 ± 0.5% | 442.39 ± 0.1% | 0.93 | 1.00 | 28.37 | 0.69 |
| literal: an href attribute | 12 | 336.88 ± 0.5% | 350.19 ± 0.6% | 461.60 ± 0.5% | 45.24 ± 0.4% | 490.04 ± 2.7% | 779.80 ± 0.9% | 22248.61 ± 0.2% | 336.97 ± 0.3% | 0.96 | 1.00 | 7.45 | 0.69 |
| literal: a word, second text | 10 | 541.48 ± 0.5% | 598.45 ± 0.7% | 1011.14 ± 0.9% | 419.78 ± 0.3% | 530.84 ± 1.2% | 811.29 ± 0.3% | 27279.65 ± 0.3% | 542.19 ± 0.4% | 0.90 | 1.00 | 1.29 | 1.02 |
| class: two capitalized words | 23 | 428.35 ± 0.5% | 457.12 ± 0.5% | 663.28 ± 0.2% | 102.75 ± 0.2% | 498.70 ± 1.4% | 766.59 ± 1.0% | 6377.78 ± 0.1% | 427.67 ± 0.5% | 0.94 | 1.00 | 4.17 | 0.86 |
| class: a word that ends in ing | 9 | 544.12 ± 0.4% | 613.86 ± 0.7% | 1081.80 ± 0.3% | 132.47 ± 0.6% | 755.50 ± 1.9% | 1118.26 ± 0.7% | 15936.83 ± 0.2% | 543.26 ± 0.7% | 0.89 | 1.00 | 4.11 | 0.72 |
| class: a word in capitals | 16 | 486.30 ± 0.3% | 523.88 ± 0.7% | 833.05 ± 0.3% | 138.45 ± 0.6% | 751.98 ± 1.2% | 1018.12 ± 0.6% | 8378.17 ± 0.1% | 486.18 ± 0.3% | 0.93 | 1.00 | 3.51 | 0.65 |
| class: a number | 6 | 615.81 ± 0.6% | 673.74 ± 0.3% | 1254.94 ± 0.2% | 42.21 ± 0.3% | 1395.14 ± 1.2% | 1921.45 ± 0.7% | 22925.14 ± 0.3% | 614.44 ± 0.2% | 0.91 | 1.00 | 14.59 | 0.44 |
| class: two capitalized words, second text | 23 | 428.35 ± 0.3% | 457.48 ± 0.7% | 661.86 ± 0.7% | 101.69 ± 0.2% | 498.70 ± 0.7% | 765.31 ± 1.0% | 6378.00 ± 0.1% | 427.85 ± 0.5% | 0.94 | 1.00 | 4.21 | 0.86 |
| other: a word between two words | 13 | 526.89 ± 0.5% | 550.27 ± 0.1% | 879.93 ± 0.2% | 134.61 ± 1.2% | 498.67 ± 0.5% | 812.83 ± 1.9% | 14788.96 ± 0.1% | 526.63 ± 0.6% | 0.96 | 1.00 | 3.91 | 1.06 |
| other: a number before a unit, second text | 15 | 390.47 ± 0.2% | 433.09 ± 0.6% | 613.33 ± 0.1% | 39.73 ± 0.3% | 626.79 ± 1.2% | 884.55 ± 0.6% | 15422.85 ± 0.2% | 390.31 ± 0.2% | 0.90 | 1.00 | 9.83 | 0.62 |
| other: a heading's start tag | 13 | 348.86 ± 0.6% | 356.40 ± 0.3% | 471.53 ± 0.4% | 43.92 ± 0.3% | 624.42 ± 0.6% | 877.85 ± 0.4% | 18428.82 ± 0.2% | 349.57 ± 0.5% | 0.98 | 1.00 | 7.94 | 0.56 |
| other: a whole word | 11 | 561.87 ± 0.3% | 601.32 ± 0.6% | 1015.99 ± 0.3% | 120.90 ± 0.6% | 553.67 ± 2.6% | 842.11 ± 0.7% | 26883.25 ± 0.8% | 561.66 ± 0.3% | 0.93 | 1.00 | 4.65 | 1.01 |
| other: a line's first word, second text | 17 | 508.71 ± 0.3% | 542.67 ± 0.7% | 871.67 ± 0.7% | 128.24 ± 0.2% | 711.37 ± 1.1% | refused | refused | 510.50 ± 0.5% | 0.94 | 1.00 | 3.97 | 0.72 |
| other: fourteen octets before an x | 16 | 106.58 ± 0.6% | 151.83 ± 0.6% | 175.73 ± 0.3% | 15.08 ± 0.3% | 446.88 ± 2.0% | 419.41 ± 3.0% | 12797.90 ± 0.1% | 106.75 ± 0.6% | 0.70 | 1.00 | 7.07 | 0.24 |
| other: a Greek word | 8 | 426.96 ± 0.2% | 584.89 ± 0.4% | 989.82 ± 0.1% | 58.60 ± 1.4% | 1376.69 ± 18.1% | 1795.30 ± 0.5% | refused | 426.88 ± 0.2% | 0.73 | 1.00 | 7.29 | 0.31 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15716.24 ± 1.2% | not timed | not timed | 16276.24 ± 0.4% | 1975.89 ± 17.3% | not timed | not timed | 15735.13 ± 0.3% | | 1.00 | 0.97 | 7.95 |
| 01-literal/sherlock-casei-en | 522 | 11012.00 ± 3.5% | not timed | not timed | 3599.94 ± 0.2% | 32.54 ± 0.3% | not timed | not timed | 11005.97 ± 2.5% | | 1.00 | 3.06 | 338.41 |
| 01-literal/sherlock-ru | 724 | 17218.88 ± 0.8% | not timed | not timed | 17261.46 ± 0.4% | 1550.10 ± 14.0% | not timed | not timed | 17210.67 ± 0.4% | | 1.00 | 1.00 | 11.11 |
| 01-literal/sherlock-casei-ru | 746 | 6143.13 ± 0.4% | not timed | not timed | 3331.33 ± 0.1% | 31.65 ± 0.4% | not timed | not timed | 6146.10 ± 0.2% | | 1.00 | 1.84 | 194.12 |
| 01-literal/sherlock-zh | 30 | 19779.47 ± 1.0% | not timed | not timed | 18759.99 ± 1.4% | 2680.81 ± 15.4% | not timed | not timed | 19884.10 ± 1.1% | | 0.99 | 1.05 | 7.38 |
| 02-literal-alternate/sherlock-en | 714 | 6143.48 ± 0.5% | not timed | not timed | 3931.98 ± 0.6% | 16.58 ± 0.4% | not timed | not timed | 6153.89 ± 0.3% | | 1.00 | 1.56 | 370.49 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1965.03 ± 1.3% | not timed | not timed | 697.68 ± 0.3% | 11.11 ± 0.4% | not timed | not timed | 1973.40 ± 0.8% | | 1.00 | 2.82 | 176.89 |
| 02-literal-alternate/sherlock-ru | 899 | 5541.17 ± 0.4% | not timed | not timed | 3246.80 ± 0.1% | 22.59 ± 4.7% | not timed | not timed | 5528.12 ± 0.2% | | 1.00 | 1.71 | 245.24 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2056.76 ± 0.3% | not timed | not timed | 1232.70 ± 0.2% | 9.13 ± 0.2% | not timed | not timed | 2056.05 ± 0.4% | | 1.00 | 1.67 | 225.20 |
| 02-literal-alternate/sherlock-zh | 207 | 7340.58 ± 0.2% | not timed | not timed | 4164.00 ± 0.5% | 31.48 ± 0.1% | not timed | not timed | 7351.31 ± 0.4% | | 1.00 | 1.76 | 233.15 |
| 03-date/ascii | 111817 | 133.73 ± 1.2% | not timed | not timed | 95.82 ± 0.1% | 0.20 ± 5.2% | not timed | not timed | 134.11 ± 0.8% | | 1.00 | 1.40 | 655.95 |
| 04-ruff-noqa/real | 84 | 435.43 ± 0.1% | not timed | not timed | 472.31 ± 0.2% | 19.65 ± 1.6% | not timed | not timed | 435.75 ± 0.2% | | 1.00 | 0.92 | 22.16 |
| 04-ruff-noqa/tweaked | 44 | 591.54 ± 0.2% | not timed | not timed | 461.67 ± 0.2% | 364.67 ± 0.3% | not timed | not timed | 593.46 ± 0.1% | | 1.00 | 1.28 | 1.62 |
| 05-lexer-veryl/single | 124800 | 5.18 ± 3.3% | not timed | not timed | 5.22 ± 0.3% | 0.21 ± 3.6% | not timed | not timed | 5.22 ± 0.6% | | 0.99 | 0.99 | 24.98 |
| 06-cloud-flare-redos/original | 107 | 425.85 ± 0.2% | not timed | not timed | 212.79 ± 0.1% | 24.97 ± 0.5% | not timed | not timed | 429.79 ± 0.1% | | 0.99 | 2.00 | 17.05 |
| 06-cloud-flare-redos/simplified-short | 102 | 429.98 ± 0.2% | not timed | not timed | 228.97 ± 0.1% | 26.68 ± 0.3% | not timed | not timed | 429.47 ± 0.2% | | 1.00 | 1.88 | 16.12 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.61 ± 0.1% | not timed | not timed | 256.87 ± 0.2% | 28.76 ± 0.1% | not timed | not timed | 588.65 ± 0.1% | | 1.00 | 2.29 | 20.47 |
| 07-unicode-character-data/parse-line | 558784 | 238.68 ± 0.6% | not timed | not timed | 179.01 ± 0.1% | 42.76 ± 5.7% | not timed | not timed | 239.59 ± 1.6% | | 1.00 | 1.33 | 5.58 |
| 08-words/all-english | 56691 | 127.31 ± 2.2% | not timed | not timed | 83.44 ± 0.2% | 11.88 ± 2.6% | not timed | not timed | 127.50 ± 0.5% | | 1.00 | 1.53 | 10.72 |
| 08-words/long-english | 839 | 623.42 ± 0.3% | not timed | not timed | 597.62 ± 0.1% | 32.20 ± 1.8% | not timed | not timed | 623.04 ± 0.3% | | 1.00 | 1.04 | 19.36 |
| 09-aws-keys/full | 0 | 441.00 ± 0.3% | not timed | not timed | 494.19 ± 0.0% | 64.26 ± 3.5% | not timed | not timed | 439.19 ± 0.4% | | 1.00 | 0.89 | 6.86 |
| 09-aws-keys/quick | 0 | 876.63 ± 0.1% | not timed | not timed | 1001.18 ± 0.2% | 415.68 ± 1.2% | not timed | not timed | 876.81 ± 0.1% | | 1.00 | 0.88 | 2.11 |
| 10-bounded-repeat/letters-en | 1833 | 584.25 ± 1.7% | not timed | not timed | 518.21 ± 0.2% | 19.50 ± 0.7% | not timed | not timed | 580.90 ± 3.3% | | 1.01 | 1.13 | 29.96 |
| 10-bounded-repeat/letters-ru | 3475 | 505.70 ± 1.5% | not timed | not timed | 478.85 ± 0.3% | 22.20 ± 20.0% | not timed | not timed | 509.08 ± 1.0% | | 0.99 | 1.06 | 22.77 |
| 10-bounded-repeat/context | 53 | 85.33 ± 1.9% | not timed | not timed | 66.30 ± 0.4% | 19.77 ± 0.1% | not timed | not timed | 85.33 ± 1.5% | | 1.00 | 1.29 | 4.32 |
| 10-bounded-repeat/capitals | 11 | 632.89 ± 8.2% | not timed | not timed | 616.39 ± 0.1% | 36.49 ± 0.1% | not timed | not timed | 632.82 ± 8.1% | | 1.00 | 1.03 | 17.35 |
| 11-unstructured-to-json/extract | 600 | 57.31 ± 1.1% | not timed | not timed | 76.45 ± 0.4% | 49.05 ± 1.1% | not timed | not timed | 57.28 ± 1.2% | | 1.00 | 0.75 | 1.17 |
| 12-dictionary/single | 1 | 560.43 ± 0.9% | not timed | not timed | 558.76 ± 0.2% | 0.41 ± 0.1% | not timed | not timed | 560.96 ± 0.8% | | 1.00 | 1.00 | 1367.93 |
| 14-quadratic/1x | 100 | 21.30 ± 1.5% | not timed | not timed | 10.09 ± 0.4% | 0.96 ± 3.3% | not timed | not timed | 21.32 ± 1.5% | | 1.00 | 2.11 | 22.11 |
| 14-quadratic/2x | 200 | 17.81 ± 1.4% | not timed | not timed | 5.55 ± 0.3% | 0.53 ± 1.6% | not timed | not timed | 17.83 ± 2.1% | | 1.00 | 3.21 | 33.39 |
| 14-quadratic/10x | 1000 | 7.77 ± 0.6% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 2.2% | not timed | not timed | 7.77 ± 0.5% | | 1.00 | 6.45 | 67.21 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.25 ± 1.6% | not timed | not timed | 0.35 ± 0.6% | 0.55 ± 3.7% | not timed | not timed | 1.26 ± 0.5% | | 0.99 | 3.61 | 2.27 |
| 04-ruff-noqa/compile-real | 1 | 102.05 ± 1.3% | not timed | not timed | 13.88 ± 0.5% | 140.79 ± 2.5% | not timed | not timed | 101.69 ± 1.2% | | 1.00 | 7.35 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 13.92 ± 1.3% | not timed | not timed | 2.50 ± 0.4% | 6.46 ± 1.5% | not timed | not timed | 14.06 ± 0.6% | | 0.99 | 5.56 | 2.16 |
| 07-unicode-character-data/compile | 1 | 107.15 ± 1.6% | not timed | not timed | 26.02 ± 0.4% | 36.16 ± 4.1% | not timed | not timed | 107.21 ± 0.9% | | 1.00 | 4.12 | 2.96 |
| 09-aws-keys/compile-full | 1 | 51.94 ± 0.2% | not timed | not timed | 8.29 ± 0.7% | 23.39 ± 1.0% | not timed | not timed | 52.22 ± 0.5% | | 0.99 | 6.26 | 2.22 |
| 09-aws-keys/compile-quick | 1 | 180.43 ± 0.6% | not timed | not timed | 47.58 ± 0.4% | 132.45 ± 2.7% | not timed | not timed | 179.37 ± 0.6% | | 1.01 | 3.79 | 1.36 |
| 10-bounded-repeat/compile-context | 1 | 69.07 ± 2.1% | not timed | not timed | 11.14 ± 0.5% | 16.23 ± 3.0% | not timed | not timed | 69.50 ± 2.1% | | 0.99 | 6.20 | 4.25 |
| 10-bounded-repeat/compile-capitals | 1 | 81.36 ± 1.6% | not timed | not timed | 8.08 ± 0.4% | 23.95 ± 19.4% | not timed | not timed | 81.46 ± 0.7% | | 1.00 | 10.06 | 3.40 |
| 11-unstructured-to-json/compile | 1 | 169.42 ± 0.4% | not timed | not timed | 41.00 ± 0.4% | 68.73 ± 1.7% | not timed | not timed | 168.68 ± 0.9% | | 1.00 | 4.13 | 2.47 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.8% | not timed | not timed | 0.07 ± 38.3% | 0.10 ± 14.9% | not timed | not timed | 0.35 ± 0.9% | | 1.00 | 5.08 | 3.60 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.19 ± 5.0% | not timed | not timed | 6.53 ± 0.3% | 0.59 ± 19.6% | not timed | not timed | 7.27 ± 2.4% | | 0.99 | 1.10 | 12.21 |
| dictionary/search/english-10 | 690 | 1.16 ± 0.3% | not timed | not timed | 165.05 ± 0.7% | 0.00 ± 0.7% | not timed | not timed | 1.16 ± 0.5% | | 1.00 | 0.0070 | 404.95 |
| dictionary/search/english-15 | 15 | 565.66 ± 0.8% | not timed | not timed | 560.16 ± 0.1% | 0.37 ± 0.2% | not timed | not timed | 567.32 ± 1.0% | | 1.00 | 1.01 | 1538.81 |
| folly/awyer-inn-busted | 1 | 5593.28 ± 0.3% | not timed | not timed | 142.81 ± 0.0% | 43.79 ± 0.3% | not timed | not timed | 5613.79 ± 0.1% | | 1.00 | 39.17 | 127.72 |
| folly/literal-never-match-rare | 0 | 21050.26 ± 0.3% | not timed | not timed | 19831.08 ± 0.3% | 40689.59 ± 0.8% | not timed | not timed | 21043.03 ± 0.5% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12457.99 ± 1.1% | not timed | not timed | 19834.74 ± 0.1% | 2204.85 ± 1.1% | not timed | not timed | 12503.58 ± 0.7% | | 1.00 | 0.63 | 5.65 |
| folly/literal-never-match-tricksy | 1 | 3233.31 ± 0.2% | not timed | not timed | 4352.35 ± 1.2% | 3057.03 ± 0.4% | not timed | not timed | 3242.65 ± 0.1% | | 1.00 | 0.74 | 1.06 |
| grep/every-line | 239963 | 1313.11 ± 0.8% | not timed | not timed | 955.09 ± 0.2% | 367.32 ± 16.3% | not timed | not timed | 1321.85 ± 0.3% | | 0.99 | 1.37 | 3.57 |
| grep/long-words-ascii | 5073 | 458.41 ± 0.3% | not timed | not timed | 470.27 ± 0.1% | 46.21 ± 6.2% | not timed | not timed | 404.88 ± 0.3% | | 1.13 | 0.97 | 9.92 |
| imported/leipzig/twain | 811 | 20561.64 ± 1.0% | not timed | not timed | 19424.71 ± 1.2% | 11999.44 ± 9.9% | not timed | not timed | 20637.80 ± 0.8% | | 1.00 | 1.06 | 1.71 |
| imported/leipzig/twain-insensitive | 965 | 9023.45 ± 1.2% | not timed | not timed | 4243.12 ± 0.3% | 37.80 ± 0.1% | not timed | not timed | 9050.57 ± 0.7% | | 1.00 | 2.13 | 238.72 |
| imported/leipzig/shing | 1540 | 15054.16 ± 3.5% | not timed | not timed | 13448.96 ± 2.4% | 33.98 ± 0.1% | not timed | not timed | 15265.04 ± 3.0% | | 0.99 | 1.12 | 443.00 |
| imported/leipzig/huck-saw | 262 | 8141.82 ± 2.8% | not timed | not timed | 5576.82 ± 0.3% | 31.97 ± 0.3% | not timed | not timed | 8264.89 ± 2.8% | | 0.99 | 1.46 | 254.65 |
| imported/leipzig/word-ending-nn | 262 | 605.79 ± 0.4% | not timed | not timed | 616.49 ± 0.1% | 24.73 ± 0.3% | not timed | not timed | 605.39 ± 0.2% | | 1.00 | 0.98 | 24.49 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11109.38 ± 1.8% | not timed | not timed | 4485.87 ± 0.9% | 11.51 ± 1.2% | not timed | not timed | 11090.65 ± 1.5% | | 1.00 | 2.48 | 965.35 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7744.57 ± 1.4% | not timed | not timed | 5466.94 ± 0.7% | 16.88 ± 0.0% | not timed | not timed | 7762.20 ± 2.3% | | 1.00 | 1.42 | 458.79 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4145.81 ± 2.2% | not timed | not timed | 421.11 ± 1.1% | 11.12 ± 0.1% | not timed | not timed | 4144.66 ± 1.8% | | 1.00 | 9.84 | 372.86 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 602.73 ± 0.6% | not timed | not timed | 614.43 ± 0.2% | 11.02 ± 0.2% | not timed | not timed | 602.90 ± 0.2% | | 1.00 | 0.98 | 54.70 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 603.54 ± 0.4% | not timed | not timed | 615.47 ± 0.0% | 9.73 ± 0.3% | not timed | not timed | 602.45 ± 0.3% | | 1.00 | 0.98 | 62.05 |
| imported/leipzig/tom-river | 2 | 6384.19 ± 1.8% | not timed | not timed | 5099.13 ± 0.2% | 30.85 ± 0.2% | not timed | not timed | 6431.80 ± 1.3% | | 0.99 | 1.25 | 206.91 |
| imported/leipzig/ing | 78424 | 600.86 ± 0.9% | not timed | not timed | 572.11 ± 0.2% | 27.57 ± 4.0% | not timed | not timed | 602.29 ± 1.0% | | 1.00 | 1.05 | 21.80 |
| imported/leipzig/ing-whitespace | 55248 | 751.24 ± 0.6% | not timed | not timed | 2062.32 ± 0.5% | 20.52 ± 2.5% | not timed | not timed | 752.85 ± 0.6% | | 1.00 | 0.36 | 36.62 |
| imported/leipzig/awyer-inn | 209 | 769.20 ± 1.6% | not timed | not timed | 4171.53 ± 2.0% | 22.58 ± 0.2% | not timed | not timed | 767.61 ± 1.3% | | 1.00 | 0.18 | 34.06 |
| imported/leipzig/quotes-bounded | 8886 | 2115.51 ± 0.9% | not timed | not timed | 2975.79 ± 0.7% | 38.24 ± 0.2% | not timed | not timed | 2117.83 ± 0.5% | | 1.00 | 0.71 | 55.32 |
| imported/leipzig/non-ascii-alternate | 2 | 12744.52 ± 2.1% | not timed | not timed | 5654.54 ± 0.1% | 50.75 ± 0.1% | not timed | not timed | 12878.24 ± 2.0% | | 0.99 | 2.25 | 251.14 |
| imported/leipzig/math-symbols | 69 | 1982.60 ± 0.3% | not timed | not timed | 618.49 ± 0.1% | 36.48 ± 0.2% | not timed | not timed | 1983.27 ± 0.6% | | 1.00 | 3.21 | 54.35 |
| imported/leipzig/bounded-strings-ending-z | 0 | 587.60 ± 2.0% | not timed | not timed | 617.45 ± 0.1% | 22.51 ± 0.3% | not timed | not timed | 587.30 ± 1.7% | | 1.00 | 0.95 | 26.11 |
| imported/lh3lh3-reb/uri | 17549 | 679.23 ± 0.2% | not timed | not timed | 1081.55 ± 0.3% | 28.37 ± 2.2% | not timed | not timed | 679.60 ± 0.2% | | 1.00 | 0.63 | 23.94 |
| imported/lh3lh3-reb/email | 15057 | 674.37 ± 0.3% | not timed | not timed | 1173.62 ± 0.1% | 31.13 ± 2.4% | not timed | not timed | 673.42 ± 0.2% | | 1.00 | 0.57 | 21.66 |
| imported/lh3lh3-reb/date | 668 | 859.42 ± 0.2% | not timed | not timed | 1041.44 ± 0.2% | 51.12 ± 3.9% | not timed | not timed | 860.11 ± 0.2% | | 1.00 | 0.83 | 16.81 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.98 ± 0.1% | not timed | not timed | 424.61 ± 0.1% | 15.75 ± 1.3% | not timed | not timed | 645.66 ± 0.3% | | 1.00 | 1.52 | 41.02 |
| imported/mariomka/email | 92 | 24358.93 ± 0.7% | not timed | not timed | 29651.45 ± 0.9% | 32.81 ± 0.2% | not timed | not timed | 24386.59 ± 1.2% | | 1.00 | 0.82 | 742.35 |
| imported/mariomka/uri | 5301 | 5325.71 ± 0.9% | not timed | not timed | 6076.04 ± 0.5% | 32.76 ± 0.6% | not timed | not timed | 5348.31 ± 0.6% | | 1.00 | 0.88 | 162.58 |
| imported/mariomka/ip | 5 | 2150.59 ± 2.2% | not timed | not timed | 2949.24 ± 0.6% | 21.09 ± 0.1% | not timed | not timed | 2149.63 ± 2.4% | | 1.00 | 0.73 | 101.99 |
| imported/rsc/no-exponential | 0 | 604.53 ± 0.2% | not timed | not timed | 320.34 ± 0.3% | 23.83 ± 0.2% | not timed | not timed | 600.38 ± 0.4% | | 1.01 | 1.89 | 25.37 |
| imported/rsc/literal | 1 | 763.63 ± 8.5% | not timed | not timed | 1652.04 ± 5.0% | 191.73 ± 16.0% | not timed | not timed | 762.98 ± 8.0% | | 1.00 | 0.46 | 3.98 |
| imported/rsc/not-literal | 2 | 780.79 ± 1.9% | not timed | not timed | 719.99 ± 0.1% | 46.53 ± 9.6% | not timed | not timed | 782.86 ± 0.3% | | 1.00 | 1.08 | 16.78 |
| imported/rsc/match-class | 1 | 1442.51 ± 0.4% | not timed | not timed | 1658.03 ± 0.2% | 59.03 ± 7.3% | not timed | not timed | 1439.65 ± 2.3% | | 1.00 | 0.87 | 24.44 |
| imported/rsc/match-class-in-range | 1 | 1444.19 ± 2.3% | not timed | not timed | 2357.88 ± 1.9% | 60.32 ± 6.3% | not timed | not timed | 1440.56 ± 0.4% | | 1.00 | 0.61 | 23.94 |
| imported/rsc/match-class-unicode | 1 | 547.78 ± 1.6% | not timed | not timed | 515.19 ± 0.2% | 72.38 ± 7.0% | not timed | not timed | 549.19 ± 0.1% | | 1.00 | 1.06 | 7.57 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1440.52 ± 0.2% | not timed | not timed | 944.38 ± 0.2% | 228.62 ± 1.0% | not timed | not timed | 1442.40 ± 0.2% | | 1.00 | 1.53 | 6.30 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21599.96 ± 0.2% | not timed | not timed | 14259.15 ± 0.3% | 3416.02 ± 0.4% | not timed | not timed | 21585.17 ± 0.3% | | 1.00 | 1.51 | 6.32 |
| imported/rsc/anchored-literal-short-match | 4 | 709.22 ± 1.9% | not timed | not timed | 486.99 ± 0.3% | 85.58 ± 12.8% | not timed | not timed | 713.05 ± 1.4% | | 0.99 | 1.46 | 8.29 |
| imported/rsc/anchored-literal-long-match | 4 | 10670.30 ± 1.7% | not timed | not timed | 7362.36 ± 0.4% | 1251.61 ± 7.2% | not timed | not timed | 10672.33 ± 1.8% | | 1.00 | 1.45 | 8.53 |
| imported/rsc/one-pass-short | 17 | 370.18 ± 11.5% | not timed | not timed | 214.79 ± 0.7% | 31.03 ± 12.0% | not timed | not timed | 369.04 ± 1.3% | | 1.00 | 1.72 | 11.93 |
| imported/rsc/one-pass-short-not | 17 | 244.07 ± 2.8% | not timed | not timed | 224.80 ± 0.4% | 32.23 ± 10.3% | not timed | not timed | 280.34 ± 1.8% | | 0.87 | 1.09 | 7.57 |
| imported/rsc/one-pass-long-prefix | 26 | 363.11 ± 2.0% | not timed | not timed | 279.47 ± 0.3% | 97.61 ± 12.5% | not timed | not timed | 364.15 ± 1.0% | | 1.00 | 1.30 | 3.72 |
| imported/rsc/one-pass-long-prefix-not | 26 | 360.08 ± 2.3% | not timed | not timed | 282.72 ± 0.9% | 61.65 ± 18.9% | not timed | not timed | 362.48 ± 0.3% | | 0.99 | 1.27 | 5.84 |
| imported/rsc/long-needle1 | 31 | 22177.45 ± 0.2% | not timed | not timed | 20120.32 ± 0.2% | 3.75 ± 0.1% | not timed | not timed | 22191.60 ± 0.1% | | 1.00 | 1.10 | 5910.34 |
| imported/rsc/long-needle2 | 31 | 22318.85 ± 0.1% | not timed | not timed | 216.05 ± 0.2% | 3.75 ± 0.1% | not timed | not timed | 22323.37 ± 0.4% | | 1.00 | 103.30 | 5950.26 |
| imported/rsc/easy0-32 | 26 | 1082.26 ± 3.2% | not timed | not timed | 1592.95 ± 1.4% | 148.44 ± 18.8% | not timed | not timed | 1080.61 ± 0.1% | | 1.00 | 0.68 | 7.29 |
| imported/rsc/easy0-1k | 26 | 14891.14 ± 2.3% | not timed | not timed | 12551.69 ± 0.5% | 2323.41 ± 16.3% | not timed | not timed | 14888.40 ± 0.2% | | 1.00 | 1.19 | 6.41 |
| imported/rsc/easy0-32k | 26 | 23057.19 ± 1.8% | not timed | not timed | 20295.87 ± 0.0% | 18847.42 ± 21.3% | not timed | not timed | 23051.46 ± 0.3% | | 1.00 | 1.14 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21922.42 ± 0.9% | not timed | not timed | 20023.10 ± 1.9% | 37518.98 ± 1.3% | not timed | not timed | 21940.52 ± 1.0% | | 1.00 | 1.09 | 0.58 |
| imported/rsc/easy1-32 | 19 | 806.16 ± 2.4% | not timed | not timed | 627.36 ± 0.5% | 125.83 ± 17.6% | not timed | not timed | 803.89 ± 2.4% | | 1.00 | 1.28 | 6.41 |
| imported/rsc/easy1-1k | 19 | 16512.75 ± 3.4% | not timed | not timed | 12893.70 ± 0.2% | 2497.80 ± 18.2% | not timed | not timed | 16517.75 ± 0.2% | | 1.00 | 1.28 | 6.61 |
| imported/rsc/easy1-32k | 19 | 517234.86 ± 0.3% | not timed | not timed | 406900.52 ± 0.1% | 20496.95 ± 0.2% | not timed | not timed | 516912.23 ± 0.2% | | 1.00 | 1.27 | 25.23 |
| imported/rsc/easy1-1mb | 19 | 16640351.11 ± 0.3% | not timed | not timed | 13126848.60 ± 0.4% | 38180.88 ± 1.1% | not timed | not timed | 16601319.91 ± 0.4% | | 1.00 | 1.27 | 435.83 |
| imported/rsc/medium-32 | 27 | 771.25 ± 2.0% | not timed | not timed | 641.30 ± 0.5% | 70.08 ± 13.2% | not timed | not timed | 773.50 ± 0.4% | | 1.00 | 1.20 | 11.01 |
| imported/rsc/medium-1k | 27 | 13681.29 ± 0.4% | not timed | not timed | 11308.39 ± 0.2% | 72.33 ± 0.1% | not timed | not timed | 13744.74 ± 0.6% | | 1.00 | 1.21 | 189.15 |
| imported/rsc/medium-32k | 27 | 426002.54 ± 0.4% | not timed | not timed | 347697.31 ± 2.2% | 48.59 ± 0.2% | not timed | not timed | 429364.92 ± 0.4% | | 0.99 | 1.23 | 8767.87 |
| imported/rsc/medium-1mb | 27 | 13643855.05 ± 0.7% | not timed | not timed | 11440540.57 ± 0.1% | 48.31 ± 0.2% | not timed | not timed | 13690361.14 ± 0.3% | | 1.00 | 1.19 | 282435.46 |
| imported/rsc/hard-32 | 58 | 421.91 ± 1.8% | not timed | not timed | 367.41 ± 0.0% | 49.75 ± 8.0% | not timed | not timed | 418.41 ± 0.4% | | 1.01 | 1.15 | 8.48 |
| imported/rsc/hard-1k | 27 | 13379.97 ± 0.1% | not timed | not timed | 11716.21 ± 0.2% | 40.63 ± 0.2% | not timed | not timed | 13257.18 ± 0.4% | | 1.01 | 1.14 | 329.32 |
| imported/rsc/hard-32k | 27 | 417955.27 ± 0.2% | not timed | not timed | 364261.47 ± 0.4% | 29.41 ± 0.1% | not timed | not timed | 415567.47 ± 0.3% | | 1.01 | 1.15 | 14211.19 |
| imported/rsc/hard-1mb | 51 | 8419642.90 ± 0.1% | not timed | not timed | 7256502.39 ± 0.4% | 29.49 ± 0.2% | not timed | not timed | 8347493.94 ± 0.3% | | 1.01 | 1.16 | 285552.34 |
| imported/rsc/reallyhard0-32 | 58 | 266.69 ± 0.3% | not timed | not timed | 224.10 ± 0.1% | 49.68 ± 7.0% | not timed | not timed | 266.97 ± 2.8% | | 1.00 | 1.19 | 5.37 |
| imported/rsc/reallyhard0-1k | 27 | 591.67 ± 0.3% | not timed | not timed | 587.01 ± 0.4% | 40.87 ± 0.1% | not timed | not timed | 590.09 ± 0.2% | | 1.00 | 1.01 | 14.48 |
| imported/rsc/reallyhard0-32k | 27 | 611.10 ± 0.2% | not timed | not timed | 614.53 ± 0.1% | 29.40 ± 0.3% | not timed | not timed | 610.28 ± 0.2% | | 1.00 | 0.99 | 20.79 |
| imported/rsc/reallyhard0-1mb | 51 | 591.58 ± 0.5% | not timed | not timed | 616.86 ± 0.4% | 29.46 ± 0.3% | not timed | not timed | 591.37 ± 1.1% | | 1.00 | 0.96 | 20.08 |
| imported/rsc/reallyreallyhard0-32 | 47 | 287.88 ± 1.7% | not timed | not timed | 197.46 ± 2.0% | 59.37 ± 13.3% | not timed | not timed | 288.04 ± 3.5% | | 1.00 | 1.46 | 4.85 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6884.55 ± 0.1% | not timed | not timed | 5954.96 ± 0.3% | 34.08 ± 5.5% | not timed | not timed | 6888.28 ± 0.2% | | 1.00 | 1.16 | 202.04 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21493.18 ± 0.2% | not timed | not timed | 19242.13 ± 0.1% | 25.05 ± 0.3% | not timed | not timed | 21512.52 ± 0.1% | | 1.00 | 1.12 | 858.05 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21760.67 ± 1.1% | not timed | not timed | 19977.89 ± 0.9% | 25.10 ± 1.1% | not timed | not timed | 21792.58 ± 1.2% | | 1.00 | 1.09 | 867.09 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.09 ± 1.5% | not timed | not timed | 212.58 ± 0.7% | 59.58 ± 9.7% | not timed | not timed | 282.42 ± 1.5% | | 1.00 | 1.33 | 4.73 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5897.20 ± 0.1% | not timed | not timed | 6207.67 ± 0.1% | 34.39 ± 0.5% | not timed | not timed | 5889.59 ± 0.1% | | 1.00 | 0.95 | 171.49 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21424.43 ± 0.1% | not timed | not timed | 19250.86 ± 0.1% | 24.55 ± 2.7% | not timed | not timed | 21429.39 ± 0.1% | | 1.00 | 1.11 | 872.56 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21395.73 ± 1.7% | not timed | not timed | 19759.45 ± 1.2% | 24.97 ± 0.5% | not timed | not timed | 21433.75 ± 1.2% | | 1.00 | 1.08 | 856.72 |
| imported/sherlock/name-sherlock | 776 | 19720.49 ± 5.4% | not timed | not timed | 18497.87 ± 0.8% | 8747.69 ± 25.2% | not timed | not timed | 19774.87 ± 2.6% | | 1.00 | 1.07 | 2.25 |
| imported/sherlock/name-holmes | 2766 | 14675.79 ± 4.9% | not timed | not timed | 15502.76 ± 1.0% | 3250.84 ± 5.5% | not timed | not timed | 15209.57 ± 6.0% | | 0.96 | 0.95 | 4.51 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19750.21 ± 1.8% | not timed | not timed | 18519.86 ± 0.5% | 8033.40 ± 32.5% | not timed | not timed | 19792.14 ± 0.6% | | 1.00 | 1.07 | 2.46 |
| imported/sherlock/name-sherlock-casei | 816 | 15699.72 ± 0.5% | not timed | not timed | 4005.42 ± 0.3% | 32.56 ± 0.6% | not timed | not timed | 15713.82 ± 0.6% | | 1.00 | 3.92 | 482.15 |
| imported/sherlock/name-holmes-casei | 2802 | 9443.24 ± 6.3% | not timed | not timed | 3312.05 ± 0.1% | 37.37 ± 10.6% | not timed | not timed | 9439.75 ± 7.0% | | 1.00 | 2.85 | 252.73 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13131.06 ± 3.7% | not timed | not timed | 3949.62 ± 0.2% | 32.53 ± 0.3% | not timed | not timed | 13107.62 ± 1.5% | | 1.00 | 3.32 | 403.68 |
| imported/sherlock/name-whitespace | 1461 | 15223.24 ± 1.4% | not timed | not timed | 14485.23 ± 0.1% | 7349.92 ± 17.9% | not timed | not timed | 15296.66 ± 1.6% | | 1.00 | 1.05 | 2.07 |
| imported/sherlock/name-alt1 | 1142 | 11614.85 ± 3.0% | not timed | not timed | 16341.27 ± 1.9% | 4095.11 ± 55.7% | not timed | not timed | 11604.19 ± 0.3% | | 1.00 | 0.71 | 2.84 |
| imported/sherlock/name-alt2 | 3542 | 8952.36 ± 0.2% | not timed | not timed | 3822.08 ± 0.1% | 31.24 ± 0.1% | not timed | not timed | 8962.61 ± 0.3% | | 1.00 | 2.34 | 286.53 |
| imported/sherlock/name-alt3 | 4507 | 5554.27 ± 0.5% | not timed | not timed | 3619.88 ± 0.1% | 9.95 ± 0.2% | not timed | not timed | 5558.57 ± 0.5% | | 1.00 | 1.53 | 558.15 |
| imported/sherlock/name-alt3-casei | 4593 | 1527.61 ± 2.2% | not timed | not timed | 285.67 ± 0.2% | 6.48 ± 0.1% | not timed | not timed | 1527.45 ± 1.2% | | 1.00 | 5.35 | 235.61 |
| imported/sherlock/name-alt4 | 3686 | 6380.10 ± 0.4% | not timed | not timed | 3787.64 ± 0.2% | 31.39 ± 0.3% | not timed | not timed | 6378.48 ± 0.3% | | 1.00 | 1.68 | 203.26 |
| imported/sherlock/name-alt4-casei | 4254 | 2801.23 ± 2.0% | not timed | not timed | 2582.89 ± 0.4% | 19.88 ± 2.6% | not timed | not timed | 2811.36 ± 12.2% | | 1.00 | 1.08 | 140.91 |
| imported/sherlock/name-alt5 | 4028 | 6425.20 ± 0.2% | not timed | not timed | 3741.67 ± 0.2% | 21.65 ± 0.2% | not timed | not timed | 6432.50 ± 0.3% | | 1.00 | 1.72 | 296.75 |
| imported/sherlock/name-alt5-casei | 4104 | 3507.29 ± 1.9% | not timed | not timed | 2228.45 ± 0.3% | 14.35 ± 0.1% | not timed | not timed | 3513.64 ± 1.0% | | 1.00 | 1.57 | 244.47 |
| imported/sherlock/no-match-uncommon | 0 | 21570.30 ± 0.8% | not timed | not timed | 19473.80 ± 1.0% | 35173.63 ± 0.9% | not timed | not timed | 21624.84 ± 0.9% | | 1.00 | 1.11 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21304.04 ± 0.1% | not timed | not timed | 19415.37 ± 0.6% | 1284.51 ± 1.0% | not timed | not timed | 21311.23 ± 0.5% | | 1.00 | 1.10 | 16.59 |
| imported/sherlock/no-match-really-common | 0 | 15890.10 ± 2.0% | not timed | not timed | 18737.40 ± 1.2% | 1282.46 ± 1.3% | not timed | not timed | 16032.49 ± 2.8% | | 0.99 | 0.85 | 12.39 |
| imported/sherlock/the-lower | 21654 | 2313.78 ± 1.0% | not timed | not timed | 2330.78 ± 0.2% | 235.99 ± 19.4% | not timed | not timed | 2326.07 ± 1.3% | | 0.99 | 0.99 | 9.80 |
| imported/sherlock/the-upper | 2223 | 12716.11 ± 0.8% | not timed | not timed | 13502.18 ± 0.6% | 2559.94 ± 16.6% | not timed | not timed | 12729.62 ± 1.3% | | 1.00 | 0.94 | 4.97 |
| imported/sherlock/the-casei | 23961 | 2011.47 ± 0.6% | not timed | not timed | 1318.27 ± 0.4% | 34.83 ± 1.2% | not timed | not timed | 2012.87 ± 0.2% | | 1.00 | 1.53 | 57.74 |
| imported/sherlock/everything-greedy | 581881 | 282.19 ± 1.8% | not timed | not timed | 165.71 ± 0.1% | 28.62 ± 33.0% | not timed | not timed | 283.34 ± 0.6% | | 1.00 | 1.70 | 9.86 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.71 ± 0.1% | not timed | not timed | 211.86 ± 0.2% | 32.89 ± 0.1% | not timed | not timed | 462.73 ± 0.2% | | 1.00 | 2.18 | 14.07 |
| imported/sherlock/letters | 447175 | 62.18 ± 8.1% | not timed | not timed | 32.92 ± 0.2% | 5.14 ± 21.0% | not timed | not timed | 62.34 ± 1.2% | | 1.00 | 1.89 | 12.10 |
| imported/sherlock/letters-upper | 14180 | 453.51 ± 1.3% | not timed | not timed | 369.96 ± 0.2% | 29.61 ± 31.8% | not timed | not timed | 453.08 ± 0.2% | | 1.00 | 1.23 | 15.31 |
| imported/sherlock/letters-lower | 432995 | 63.63 ± 0.6% | not timed | not timed | 33.86 ± 0.1% | 5.93 ± 11.7% | not timed | not timed | 63.58 ± 0.5% | | 1.00 | 1.88 | 10.74 |
| imported/sherlock/words | 447639 | 114.85 ± 1.5% | not timed | not timed | 78.66 ± 0.2% | 14.00 ± 10.4% | not timed | not timed | 114.96 ± 6.8% | | 1.00 | 1.46 | 8.20 |
| imported/sherlock/before-holmes | 4073 | 10295.90 ± 0.5% | not timed | not timed | 8405.56 ± 0.2% | 24.03 ± 0.7% | not timed | not timed | 10321.52 ± 0.2% | | 1.00 | 1.22 | 428.45 |
| imported/sherlock/before-after-holmes | 2593 | 9876.14 ± 0.7% | not timed | not timed | 9451.77 ± 0.5% | 24.05 ± 0.2% | not timed | not timed | 9887.94 ± 0.6% | | 1.00 | 1.04 | 410.59 |
| imported/sherlock/holmes-cochar-watson | 150 | 5172.88 ± 0.3% | not timed | not timed | 3424.46 ± 0.2% | 31.07 ± 0.1% | not timed | not timed | 5180.31 ± 0.1% | | 1.00 | 1.51 | 166.49 |
| imported/sherlock/holmes-coword-watson | 14309 | 1187.40 ± 0.5% | not timed | not timed | 1122.44 ± 0.1% | 6.68 ± 0.2% | not timed | not timed | 1188.94 ± 0.7% | | 1.00 | 1.06 | 177.66 |
| imported/sherlock/quotes | 14437 | 1402.63 ± 0.2% | not timed | not timed | 1766.07 ± 1.2% | 34.95 ± 0.2% | not timed | not timed | 1399.02 ± 0.7% | | 1.00 | 0.79 | 40.13 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 609.95 ± 0.1% | not timed | not timed | 16033.63 ± 0.3% | 36.16 ± 0.1% | not timed | not timed | 610.00 ± 0.1% | | 1.00 | 0.0380 | 16.87 |
| imported/sherlock/word-ending-n | 35297 | 479.96 ± 1.1% | not timed | not timed | 409.67 ± 0.1% | 23.37 ± 17.0% | not timed | not timed | 481.52 ± 0.3% | | 1.00 | 1.17 | 20.54 |
| imported/sherlock/repeated-class-negation | 2130 | 14638.71 ± 1.1% | not timed | not timed | 10936.77 ± 0.6% | 11.56 ± 0.5% | not timed | not timed | 14629.45 ± 0.9% | | 1.00 | 1.34 | 1266.11 |
| imported/sherlock/ing-suffix | 20547 | 565.84 ± 0.4% | not timed | not timed | 517.97 ± 0.2% | 28.88 ± 0.3% | not timed | not timed | 567.40 ± 0.4% | | 1.00 | 1.09 | 19.59 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 607.12 ± 0.4% | not timed | not timed | 2102.53 ± 0.9% | 20.52 ± 0.2% | not timed | not timed | 608.71 ± 0.4% | | 1.00 | 0.29 | 29.58 |
| opt/accelerate/whole-line | 239963 | 458.11 ± 0.3% | not timed | not timed | 375.02 ± 0.5% | 92.56 ± 16.6% | not timed | not timed | 457.83 ± 0.4% | | 1.00 | 1.22 | 4.95 |
| opt/accelerate/non-dna | 16745 | 425.83 ± 0.8% | not timed | not timed | 398.85 ± 0.2% | 29.18 ± 19.7% | not timed | not timed | 428.27 ± 0.2% | | 0.99 | 1.07 | 14.59 |
| opt/backtrack/words-english | 40536 | 136.49 ± 0.3% | not timed | not timed | 94.73 ± 0.1% | 19.90 ± 7.6% | not timed | not timed | 135.25 ± 1.7% | | 1.01 | 1.44 | 6.86 |
| opt/fixed-length/too-small-ascii | 0 | 312.41 ± 0.3% | not timed | not timed | 674.73 ± 3.8% | 80.06 ± 0.6% | not timed | not timed | 313.11 ± 0.1% | | 1.00 | 0.46 | 3.90 |
| opt/fixed-length/too-big-ascii | 0 | 3483.63 ± 0.2% | not timed | not timed | 5838.34 ± 0.3% | 126.98 ± 0.4% | not timed | not timed | 3462.17 ± 0.2% | | 1.01 | 0.60 | 27.43 |
| opt/fixed-length/go33484-1 | 0 | 670646.34 ± 0.3% | not timed | not timed | 1122938.75 ± 0.4% | 61452.89 ± 0.4% | not timed | not timed | 664339.98 ± 0.1% | | 1.01 | 0.60 | 10.91 |
| opt/fixed-length/go33484-2 | 0 | 670315.22 ± 0.3% | not timed | not timed | 1120449.33 ± 0.1% | 32802.58 ± 0.5% | not timed | not timed | 664628.41 ± 0.1% | | 1.01 | 0.60 | 20.43 |
| opt/fixed-length/go33484-3 | 0 | 2405.00 ± 2.6% | not timed | not timed | 111648.75 ± 0.3% | 764.15 ± 0.3% | not timed | not timed | 2439.93 ± 3.7% | | 0.99 | 0.0215 | 3.15 |
| opt/literal-alt/one-pattern | 1 | 547.51 ± 1.2% | not timed | not timed | 543.91 ± 0.2% | 0.40 ± 0.2% | not timed | not timed | 550.07 ± 1.3% | | 1.00 | 1.01 | 1364.89 |
| opt/onepass/fn-predicate | 916 | 370.07 ± 0.5% | not timed | not timed | 331.73 ± 0.2% | 201.99 ± 12.7% | not timed | not timed | 369.76 ± 0.8% | | 1.00 | 1.12 | 1.83 |
| opt/onepass/first-three-words-english | 35128 | 176.84 ± 12.5% | not timed | not timed | 201.09 ± 0.3% | 79.66 ± 13.0% | not timed | not timed | 176.53 ± 1.7% | | 1.00 | 0.88 | 2.22 |
| opt/prefilter/literal-english | 1 | 20759.81 ± 0.6% | not timed | not timed | 19999.48 ± 0.6% | 17572.18 ± 0.4% | not timed | not timed | 20749.03 ± 0.2% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14388.34 ± 0.4% | not timed | not timed | 4313.32 ± 0.2% | 32.74 ± 0.2% | not timed | not timed | 14406.28 ± 0.1% | | 1.00 | 3.34 | 439.51 |
| opt/prefilter/literal-russian | 1 | 21495.70 ± 0.5% | not timed | not timed | 19896.12 ± 0.7% | 3324.61 ± 0.3% | not timed | not timed | 21485.97 ± 0.6% | | 1.00 | 1.08 | 6.47 |
| opt/prefilter/literal-casei-russian | 1 | 8589.91 ± 0.3% | not timed | not timed | 3892.24 ± 0.3% | 31.69 ± 0.3% | not timed | not timed | 8568.40 ± 0.4% | | 1.00 | 2.21 | 271.05 |
| opt/prefilter/rust-functions | 948 | 6819.73 ± 1.9% | not timed | not timed | 8973.33 ± 0.3% | 1867.14 ± 32.4% | not timed | not timed | 6827.41 ± 0.3% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 30109938.15 ± 0.1% | not timed | not timed | 21135717.03 ± 0.1% | 50.34 ± 0.2% | not timed | not timed | 30038746.83 ± 0.2% | | 1.00 | 1.42 | 598159.58 |
| opt/reverse-inner/holmes | 2593 | 9878.62 ± 1.1% | not timed | not timed | 9471.87 ± 0.2% | 23.93 ± 1.2% | not timed | not timed | 9889.23 ± 0.9% | | 1.00 | 1.04 | 412.81 |
| opt/reverse-inner/email | 47 | 36278.75 ± 2.3% | not timed | not timed | 44850.47 ± 0.8% | 32.40 ± 0.3% | not timed | not timed | 36744.58 ± 2.5% | | 0.99 | 0.81 | 1119.60 |
| opt/reverse-inner/factored-prefix | 3542 | 601.20 ± 0.1% | not timed | not timed | 597.82 ± 0.1% | 12.46 ± 0.3% | not timed | not timed | 600.88 ± 0.2% | | 1.00 | 1.01 | 48.25 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5555.45 ± 0.1% | not timed | not timed | 613.01 ± 0.4% | 75.01 ± 0.2% | not timed | not timed | 5532.03 ± 0.0% | | 1.00 | 9.06 | 74.06 |
| opt/reverse-inner/no-quadratic-forward | 0 | 702.42 ± 2.8% | not timed | not timed | 287.42 ± 0.5% | 24.84 ± 0.1% | not timed | not timed | 705.08 ± 4.1% | | 1.00 | 2.44 | 28.28 |
| opt/reverse-suffix/holmes | 4073 | 10287.40 ± 0.8% | not timed | not timed | 8422.08 ± 0.5% | 23.51 ± 1.8% | not timed | not timed | 10308.70 ± 0.7% | | 1.00 | 1.22 | 437.65 |
| opt/reverse-suffix/no-quadratic | 0 | 5533.27 ± 0.1% | not timed | not timed | 616.25 ± 0.1% | 75.03 ± 0.2% | not timed | not timed | 5561.58 ± 0.1% | | 0.99 | 8.98 | 73.74 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 122.31 ± 1.9% | not timed | not timed | 133.18 ± 0.1% | 13.19 ± 17.5% | not timed | not timed | 122.59 ± 2.2% | | 1.00 | 0.92 | 9.27 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 121.98 ± 2.2% | not timed | not timed | 133.05 ± 0.1% | 13.35 ± 14.6% | not timed | not timed | 122.41 ± 1.2% | | 1.00 | 0.92 | 9.13 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.7% | not timed | not timed | 0.55 ± 0.5% | 113.28 ± 0.2% | not timed | not timed | 0.28 ± 0.5% | | 1.00 | 0.51 | 0.0024 |
| reported/i1095-word-repetition/ascii-search | 256 | 318.09 ± 0.5% | not timed | not timed | 294.38 ± 0.2% | 103.74 ± 0.3% | not timed | not timed | 316.36 ± 0.2% | | 1.01 | 1.08 | 3.07 |
| reported/i13-subset-regex/original-ascii | 4094 | 11194.12 ± 2.6% | not timed | not timed | 4549.40 ± 10.2% | 11.51 ± 1.3% | not timed | not timed | 11257.88 ± 7.0% | | 0.99 | 2.46 | 972.95 |
| reported/i13-subset-regex/original-unicode | 4094 | 11055.31 ± 1.4% | not timed | not timed | 252.50 ± 3.4% | 11.49 ± 0.1% | not timed | not timed | 11203.70 ± 0.9% | | 0.99 | 43.78 | 961.85 |
| reported/i13-subset-regex/big-ascii | 1955 | 10709.82 ± 1.0% | not timed | not timed | 67.97 ± 3.3% | 9.87 ± 0.2% | not timed | not timed | 10726.37 ± 0.9% | | 1.00 | 157.57 | 1085.55 |
| reported/i13-subset-regex/big-unicode | 1955 | 10651.23 ± 1.3% | not timed | not timed | 12.22 ± 54.9% | 9.88 ± 0.1% | not timed | not timed | 10713.42 ± 3.9% | | 0.99 | 871.64 | 1078.25 |
| reported/i13-subset-regex/huge-ascii | 55 | 10131.49 ± 1.4% | not timed | not timed | 11.01 ± 0.1% | 8.75 ± 0.3% | not timed | not timed | 10097.12 ± 1.4% | | 1.00 | 920.11 | 1157.87 |
| reported/i13-subset-regex/huge-unicode | 55 | 10064.71 ± 4.0% | not timed | not timed | 10.98 ± 0.3% | 8.78 ± 0.1% | not timed | not timed | 9908.47 ± 3.1% | | 1.02 | 916.90 | 1146.60 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.56 ± 0.1% | not timed | not timed | 11.05 ± 0.1% | 8.75 ± 1.0% | not timed | not timed | 3.56 ± 0.1% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.04 ± 0.1% | not timed | not timed | 10.94 ± 0.3% | 8.78 ± 0.3% | not timed | not timed | 5.03 ± 0.1% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 483.03 ± 0.4% | not timed | not timed | 104.22 ± 0.2% | 6.65 ± 0.4% | not timed | not timed | 487.05 ± 0.1% | | 0.99 | 4.63 | 72.67 |
| reported/i787-keywords/opt-ascii | 5674 | 488.62 ± 0.5% | not timed | not timed | 273.44 ± 0.2% | 10.23 ± 0.2% | not timed | not timed | 489.07 ± 0.3% | | 1.00 | 1.79 | 47.76 |
| slow/quadratic-regex-1x | 100 | 7.12 ± 0.2% | not timed | not timed | 4.94 ± 0.3% | 0.05 ± 0.4% | not timed | not timed | 7.14 ± 0.1% | | 1.00 | 1.44 | 144.12 |
| slow/quadratic-regex-2x | 199 | 3.43 ± 0.1% | not timed | not timed | 2.76 ± 0.2% | 0.01 ± 0.2% | not timed | not timed | 3.44 ± 0.1% | | 1.00 | 1.24 | 269.70 |
| slow/quadratic-haystack-1x | 100 | 21.29 ± 5.6% | not timed | not timed | 10.03 ± 0.2% | 1.01 ± 13.2% | not timed | not timed | 21.37 ± 1.7% | | 1.00 | 2.12 | 21.04 |
| slow/quadratic-haystack-2x | 200 | 17.75 ± 2.0% | not timed | not timed | 5.56 ± 0.2% | 0.55 ± 11.2% | not timed | not timed | 17.82 ± 0.5% | | 1.00 | 3.19 | 32.49 |
| unicode/codepoints/any-one | 1112064 | 291.48 ± 0.7% | not timed | not timed | 176.75 ± 0.4% | 18.51 ± 0.6% | not timed | not timed | 291.76 ± 0.3% | | 1.00 | 1.65 | 15.75 |
| unicode/codepoints/any-all | 4382592 | 269.56 ± 0.4% | not timed | not timed | 247.39 ± 0.2% | 117.38 ± 0.2% | not timed | not timed | 270.18 ± 0.4% | | 1.00 | 1.09 | 2.30 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.78 ± 0.7% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 604.25 ± 0.2% | not timed | not timed | 616.55 ± 0.1% | 135.41 ± 0.4% | not timed | not timed | 603.54 ± 0.1% | | 1.00 | 0.98 | 4.46 |
| unicode/overlapping-words/ascii | 6156 | 32.00 ± 0.1% | not timed | not timed | 38.79 ± 0.1% | 3.95 ± 0.5% | not timed | not timed | 32.05 ± 0.3% | | 1.00 | 0.83 | 8.11 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 0.1% | not timed | not timed | 2.99 ± 0.2% | 2.36 ± 0.5% | not timed | not timed | 1.45 ± 0.2% | | 1.00 | 0.48 | 0.61 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.4% | not timed | not timed | 3.20 ± 0.2% | 6.30 ± 9.9% | not timed | not timed | 1.29 ± 0.1% | | 1.00 | 0.40 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 127.93 ± 3.9% | not timed | not timed | 83.08 ± 0.4% | 11.70 ± 19.6% | not timed | not timed | 128.21 ± 0.5% | | 1.00 | 1.54 | 10.93 |
| unicode/word/boundary-long-english | 3466 | 615.31 ± 0.2% | not timed | not timed | 603.61 ± 0.2% | 32.44 ± 0.6% | not timed | not timed | 616.12 ± 0.3% | | 1.00 | 1.02 | 18.97 |
| unicode/word/around-holmes-english | 27 | 19897.64 ± 0.1% | not timed | not timed | 19624.12 ± 0.4% | 22.23 ± 1.5% | not timed | not timed | 19827.88 ± 0.3% | | 1.00 | 1.01 | 895.20 |
| wild/bibleref/long | 874 | 561.88 ± 0.4% | not timed | not timed | 581.85 ± 0.1% | 6.81 ± 0.1% | not timed | not timed | 561.88 ± 0.1% | | 1.00 | 0.97 | 82.48 |
| wild/bibleref/short | 30 | 23.54 ± 3.4% | not timed | not timed | 31.16 ± 0.7% | 14.53 ± 9.2% | not timed | not timed | 24.20 ± 4.0% | | 0.97 | 0.76 | 1.62 |
| wild/bibleref/line | 874 | 394.20 ± 0.2% | not timed | not timed | 217.57 ± 0.2% | 9.12 ± 0.3% | not timed | not timed | 394.63 ± 0.1% | | 1.00 | 1.81 | 43.21 |
| wild/caddy/caddy | 6 | 415.82 ± 8.0% | not timed | not timed | 243.79 ± 0.2% | 66.98 ± 11.4% | not timed | not timed | 417.09 ± 2.7% | | 1.00 | 1.71 | 6.21 |
| wild/dot-star-capture/rust-src-tools | 6 | 1070.26 ± 0.4% | not timed | not timed | 350.48 ± 0.1% | 13.47 ± 0.2% | not timed | not timed | 1069.65 ± 0.6% | | 1.00 | 3.05 | 79.45 |
| wild/ruff/noqa | 84 | 436.26 ± 0.1% | not timed | not timed | 476.00 ± 0.3% | 19.52 ± 2.1% | not timed | not timed | 434.48 ± 0.1% | | 1.00 | 0.92 | 22.35 |
| wild/ruff/unnecessary-coding-comment | 16 | 958.07 ± 0.4% | not timed | not timed | 706.06 ± 0.2% | 136.69 ± 11.1% | not timed | not timed | 960.45 ± 0.5% | | 1.00 | 1.36 | 7.01 |
| wild/ruff/string-quote-prefix | 2972 | 1348.67 ± 0.6% | not timed | not timed | 443.62 ± 0.1% | 376.39 ± 30.1% | not timed | not timed | 1348.45 ± 0.7% | | 1.00 | 3.04 | 3.58 |
| wild/ruff/space-around-operator | 1224378 | 220.67 ± 1.9% | not timed | not timed | 186.51 ± 0.1% | 18.48 ± 1.8% | not timed | not timed | 221.23 ± 2.0% | | 1.00 | 1.18 | 11.94 |
| wild/ruff/shebang | 282 | 981.52 ± 0.4% | not timed | not timed | 331.63 ± 0.2% | 110.83 ± 11.0% | not timed | not timed | 985.68 ± 0.5% | | 1.00 | 2.96 | 8.86 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13820.07 ± 0.4% | not timed | not timed | 13846.80 ± 0.2% | 6943.13 ± 0.9% | not timed | not timed | 13832.50 ± 0.4% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12853.90 ± 0.3% | not timed | not timed | 13450.44 ± 0.4% | 6412.31 ± 0.3% | not timed | not timed | 12851.34 ± 0.4% | | 1.00 | 0.96 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13198.71 ± 0.8% | not timed | not timed | 13706.53 ± 0.5% | 6667.72 ± 1.5% | not timed | not timed | 13199.11 ± 0.9% | | 1.00 | 0.96 | 1.98 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9563.12 ± 0.6% | not timed | not timed | 13632.90 ± 0.4% | 6726.91 ± 0.3% | not timed | not timed | 9571.30 ± 0.4% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 122.05 ± 13.9% | not timed | not timed | 66.13 ± 0.3% | 2.22 ± 0.8% | not timed | not timed | 122.82 ± 13.7% | | 0.99 | 1.85 | 55.01 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 57.0% | not timed | not timed | 0.01 ± 1.0% | 0.01 ± 12.4% | not timed | not timed | 0.03 ± 1.7% | | 0.99 | 3.09 | 4.10 |
| dictionary/compile/english-15 | 1 | 0.35 ± 1.0% | not timed | not timed | 0.07 ± 0.6% | 0.10 ± 28.4% | not timed | not timed | 0.35 ± 0.8% | | 0.99 | 5.09 | 3.35 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 1.1% | not timed | not timed | 0.02 ± 1.2% | 35.45 ± 0.7% | not timed | not timed | 0.24 ± 1.8% | | 0.98 | 12.44 | 0.0066 |
| reported/i1095-word-repetition/ascii-compile | 1 | 45.34 ± 13.5% | not timed | not timed | 11.49 ± 0.3% | 53.72 ± 20.9% | not timed | not timed | 45.77 ± 2.2% | | 0.99 | 3.95 | 0.84 |
| reported/i787-keywords/compile | 1 | 34.80 ± 13.6% | not timed | not timed | 2.13 ± 0.4% | 16.93 ± 25.9% | not timed | not timed | 35.45 ± 2.1% | | 0.98 | 16.35 | 2.06 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 335.83 ± 1.5% | not timed | not timed | 125.99 ± 0.7% | 561.81 ± 7.0% | not timed | not timed | 335.75 ± 3.0% | | 1.00 | 2.67 | 0.60 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 46.85 ± 21.8% | not timed | not timed | 4.11 ± 0.8% | 42.70 ± 14.8% | not timed | not timed | 47.46 ± 1.4% | | 0.99 | 11.39 | 1.10 |
| unicode/compile/one-letter | 53 | 6.63 ± 11.6% | not timed | not timed | 4.51 ± 0.4% | 66.31 ± 11.2% | not timed | not timed | 6.74 ± 8.4% | | 0.98 | 1.47 | 0.0999 |
| unicode/compile/fifty-letters | 1 | 0.99 ± 11.8% | not timed | not timed | 0.10 ± 1.1% | 64.16 ± 8.5% | not timed | not timed | 1.06 ± 3.3% | | 0.93 | 9.94 | 0.0154 |
| unicode/compile/fifty-letters-ascii | 1 | 206.56 ± 5.8% | not timed | not timed | 52.70 ± 0.1% | 200.27 ± 21.4% | not timed | not timed | 207.75 ± 13.0% | | 0.99 | 3.92 | 1.03 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 370.84 ± 17.1% | not timed | not timed | 46.70 ± 0.4% | 669.96 ± 28.5% | not timed | not timed | 377.12 ± 1.6% | | 0.98 | 7.94 | 0.55 |
| unicode/compile/match-every-line-ascii | 4 | 586.37 ± 7.6% | not timed | not timed | 147.14 ± 0.4% | 665.69 ± 27.9% | not timed | not timed | 588.64 ± 5.9% | | 1.00 | 3.99 | 0.88 |
| unicode/compile/negated-class-matches-codepoint | 1 | 301.24 ± 4.4% | not timed | not timed | 51.07 ± 0.3% | 1227.78 ± 5.8% | not timed | not timed | 311.22 ± 5.5% | | 0.97 | 5.90 | 0.25 |
| wild/bibleref/compile | 3 | 5.72 ± 17.8% | not timed | not timed | 1.91 ± 0.5% | 31.96 ± 19.3% | not timed | not timed | 5.91 ± 21.1% | | 0.97 | 2.99 | 0.18 |
| wild/url/compile | 1 | 0.65 ± 20.0% | not timed | not timed | 0.14 ± 2.7% | 0.43 ± 26.8% | not timed | not timed | 0.65 ± 16.4% | | 1.00 | 4.65 | 1.50 |

