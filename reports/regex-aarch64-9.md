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
| literal: a word | 217 | 19551.19 ± 2.5% | 10832.72 ± 0.8% | 27.62 ± 0.3% | 18299.93 ± 1.7% | 9215.66 ± 8.5% | 17.31 ± 0.1% | 85.92 ± 0.4% | 19455.56 ± 2.2% | 1.80 | 1.00 | 1.07 | 2.12 |
| literal: a word that is not there | 0 | 21654.76 ± 2.1% | 9886.55 ± 1.0% | 27.72 ± 0.5% | 19564.05 ± 1.5% | 28812.15 ± 1.2% | 17.10 ± 0.1% | 80.30 ± 0.8% | 21395.78 ± 1.6% | 2.19 | 1.01 | 1.11 | 0.75 |
| literal: one of four words | 661 | 6421.62 ± 0.3% | 1789.84 ± 0.4% | 14.24 ± 0.1% | 3947.48 ± 0.3% | 21.14 ± 0.1% | 5.38 ± 0.3% | 6.95 ± 0.2% | 6427.63 ± 0.3% | 3.59 | 1.00 | 1.63 | 303.76 |
| literal: a word in any case | 217 | 15090.49 ± 0.3% | 1911.54 ± 0.3% | 21.25 ± 0.1% | 3969.00 ± 0.1% | 38.02 ± 0.2% | refused | differs | 15120.11 ± 0.4% | 7.89 | 1.00 | 3.80 | 396.89 |
| literal: an href attribute | 33 | 16577.70 ± 2.2% | 608.70 ± 0.5% | 26.75 ± 0.4% | 16725.65 ± 2.2% | 2255.10 ± 1.1% | 13.09 ± 0.4% | 75.05 ± 0.2% | 16663.45 ± 2.8% | 27.23 | 0.99 | 0.99 | 7.35 |
| literal: a word, second text | 123 | 19783.10 ± 2.9% | 4585.27 ± 0.4% | 27.42 ± 0.1% | 18303.06 ± 2.1% | 7715.37 ± 5.0% | 20.09 ± 0.6% | 70.24 ± 1.3% | 19874.56 ± 2.0% | 4.31 | 1.00 | 1.08 | 2.56 |
| class: two capitalized words | 1331 | 1180.64 ± 0.4% | 599.13 ± 0.2% | 25.58 ± 0.2% | 585.32 ± 0.2% | 40.71 ± 7.5% | 14.80 ± 0.2% | 67.87 ± 0.2% | 1179.87 ± 0.1% | 1.97 | 1.00 | 2.02 | 29.00 |
| class: a word that ends in ing | 3399 | 574.73 ± 0.4% | 574.23 ± 0.2% | 17.66 ± 0.1% | 522.07 ± 0.4% | 29.61 ± 12.5% | 8.16 ± 0.3% | 18.40 ± 0.2% | 575.76 ± 0.3% | 1.00 | 1.00 | 1.10 | 19.41 |
| class: a word in capitals | 2332 | 1532.82 ± 0.5% | 608.84 ± 0.2% | 27.13 ± 0.2% | 577.70 ± 0.0% | 43.57 ± 0.4% | 17.07 ± 0.2% | 83.24 ± 0.4% | 1533.65 ± 0.4% | 2.52 | 1.00 | 2.65 | 35.18 |
| class: a number | 8288 | 2675.33 ± 0.3% | 840.58 ± 0.1% | 27.23 ± 0.2% | 1717.12 ± 0.3% | 40.26 ± 15.6% | 0.55 ± 0.3% | 57.34 ± 0.2% | 2667.90 ± 1.0% | 3.18 | 1.00 | 1.56 | 66.45 |
| class: two capitalized words, second text | 5359 | 521.75 ± 0.2% | 528.42 ± 0.3% | 22.89 ± 0.2% | 484.49 ± 0.0% | 34.17 ± 9.6% | 17.07 ± 0.2% | 63.08 ± 0.6% | 522.31 ± 0.4% | 0.99 | 1.00 | 1.08 | 15.27 |
| other: a word between two words | 6104 | 814.84 ± 0.2% | 602.48 ± 0.2% | 23.07 ± 0.1% | 737.92 ± 0.2% | 108.94 ± 10.7% | 11.26 ± 0.2% | 69.16 ± 0.5% | 813.34 ± 0.1% | 1.35 | 1.00 | 1.10 | 7.48 |
| other: a number before a unit, second text | 1481 | 6238.27 ± 0.9% | 1142.36 ± 0.2% | 25.49 ± 0.5% | 5633.40 ± 0.3% | 40.76 ± 1.5% | 18.09 ± 0.4% | 65.64 ± 0.4% | 6222.50 ± 0.9% | 5.46 | 1.00 | 1.11 | 153.05 |
| other: a heading's start tag | 110 | 14050.39 ± 1.6% | 739.97 ± 0.1% | 26.84 ± 0.1% | 1705.25 ± 0.6% | 1584.93 ± 6.0% | 16.03 ± 0.4% | 87.62 ± 1.9% | 14107.76 ± 0.5% | 18.99 | 1.00 | 8.24 | 8.86 |
| other: a whole word | 217 | 16223.86 ± 1.2% | 601.68 ± 0.8% | 28.14 ± 0.3% | 14618.27 ± 0.4% | 49.34 ± 0.2% | 13.15 ± 0.2% | 55.01 ± 0.9% | 16290.15 ± 0.9% | 26.96 | 1.00 | 1.11 | 328.81 |
| other: a line's first word, second text | 3716 | 2105.11 ± 0.2% | 592.62 ± 0.1% | 29.96 ± 0.3% | 1727.55 ± 0.6% | 62.26 ± 5.9% | refused | refused | 2112.63 ± 0.4% | 3.55 | 1.00 | 1.22 | 33.81 |
| other: fourteen octets before an x | 87 | 24093.84 ± 1.8% | 239.72 ± 0.6% | 6.45 ± 0.1% | 4037.84 ± 1.2% | 10.65 ± 0.5% | differs | 17.93 ± 0.1% | 23938.09 ± 9.2% | 100.51 | 1.01 | 5.97 | 2262.81 |
| other: a Greek word | 21815 | 529.57 ± 0.5% | 423.54 ± 0.1% | 30.14 ± 0.1% | 289.62 ± 0.3% | 48.11 ± 10.9% | differs | refused | 529.70 ± 0.8% | 1.25 | 1.00 | 1.83 | 11.01 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.58 ± 0.3% | 29.56 ± 0.3% | 0.86 ± 0.3% | 19.77 ± 0.1% | 2.76 ± 0.3% | differs | 3.99 ± 0.1% | 29.59 ± 0.2% | 1.00 | 1.00 | 1.50 | 10.73 |
| a UUID | 32895 | 24.76 ± 0.1% | 24.82 ± 0.1% | 0.64 ± 0.2% | 15.17 ± 0.3% | 3.10 ± 0.1% | 0.74 ± 0.1% | 3.62 ± 1.0% | 24.85 ± 0.1% | 1.00 | 1.00 | 1.63 | 7.98 |
| an IPv4 address | 33176 | 38.78 ± 0.2% | 38.18 ± 0.1% | 2.07 ± 0.3% | 29.40 ± 0.2% | 6.66 ± 0.2% | differs | 4.22 ± 0.1% | 38.80 ± 0.2% | 1.02 | 1.00 | 1.32 | 5.82 |
| a date and time | 32954 | 34.07 ± 0.2% | 34.29 ± 0.2% | 1.44 ± 0.4% | 21.77 ± 0.4% | 7.04 ± 0.1% | 1.25 ± 0.1% | 7.18 ± 0.2% | 34.15 ± 0.1% | 0.99 | 1.00 | 1.57 | 4.84 |
| a field path | 32606 | 32.84 ± 0.4% | 32.76 ± 0.2% | 1.02 ± 0.1% | 23.22 ± 0.3% | 3.48 ± 0.9% | differs | 2.97 ± 0.1% | 32.88 ± 0.2% | 1.00 | 1.00 | 1.41 | 9.45 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.24 ± 0.6% | 11.22 ± 1.0% | 11.23 ± 0.8% | 11.58 ± 0.2% | 4.92 ± 2.5% | 0.94 ± 0.2% | none | 11.13 ± 0.5% | 1.00 | 1.01 | 0.97 | 2.29 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.31 ± 0.5% | 221.92 ± 1.2% | 268.08 ± 0.4% | 88.17 ± 1.5% | 217.88 ± 2.1% | 472.65 ± 2.5% | 3747.98 ± 3.1% | 221.78 ± 0.9% | 1.00 | 1.00 | 2.52 | 1.02 |
| a UUID | 62 | 147.88 ± 0.5% | 147.85 ± 0.3% | 167.24 ± 0.7% | 46.23 ± 0.5% | 98.49 ± 1.2% | 184.97 ± 3.2% | 4380.54 ± 0.2% | 147.69 ± 1.2% | 1.00 | 1.00 | 3.20 | 1.50 |
| an IPv4 address | 29 | 401.96 ± 0.9% | 403.29 ± 0.9% | 575.91 ± 0.5% | 76.73 ± 0.4% | 129.93 ± 0.4% | 297.09 ± 0.2% | 7585.09 ± 0.8% | 403.78 ± 0.4% | 1.00 | 1.00 | 5.24 | 3.09 |
| a date and time | 56 | 290.83 ± 0.5% | 291.02 ± 0.1% | 371.74 ± 0.1% | 72.56 ± 0.4% | 136.42 ± 0.6% | 323.26 ± 0.7% | 4971.06 ± 0.5% | 290.80 ± 0.1% | 1.00 | 1.00 | 4.01 | 2.13 |
| a field path | 39 | 217.10 ± 0.5% | 217.17 ± 1.3% | 261.37 ± 1.0% | 80.68 ± 1.5% | 203.54 ± 1.5% | 491.33 ± 1.1% | 4758.31 ± 0.2% | 216.35 ± 1.3% | 1.00 | 1.00 | 2.69 | 1.07 |
| literal: a word | 7 | 573.20 ± 0.2% | 613.96 ± 0.5% | 1121.73 ± 0.1% | 524.76 ± 0.2% | 626.71 ± 1.4% | 937.83 ± 0.5% | 30743.44 ± 0.3% | 573.77 ± 0.3% | 0.93 | 1.00 | 1.09 | 0.91 |
| literal: a word that is not there | 8 | 556.51 ± 0.5% | 600.24 ± 0.7% | 1083.45 ± 0.7% | 471.69 ± 0.2% | 604.97 ± 2.2% | 896.53 ± 0.5% | 29493.70 ± 1.0% | 557.39 ± 0.4% | 0.93 | 1.00 | 1.18 | 0.92 |
| literal: one of four words | 26 | 232.72 ± 0.3% | 375.03 ± 0.2% | 522.19 ± 0.3% | 49.57 ± 1.3% | 240.84 ± 1.1% | 355.91 ± 0.7% | 15827.49 ± 0.3% | 232.91 ± 0.3% | 0.62 | 1.00 | 4.69 | 0.97 |
| literal: a word in any case | 11 | 419.88 ± 0.4% | 447.64 ± 0.6% | 671.41 ± 0.1% | 15.70 ± 0.1% | 647.02 ± 1.7% | refused | 23929.09 ± 0.5% | 420.18 ± 0.4% | 0.94 | 1.00 | 26.74 | 0.65 |
| literal: an href attribute | 12 | 322.93 ± 0.6% | 334.79 ± 0.3% | 446.93 ± 0.4% | 45.45 ± 1.0% | 494.29 ± 1.3% | 779.05 ± 0.5% | 22285.43 ± 0.3% | 323.32 ± 0.2% | 0.96 | 1.00 | 7.11 | 0.65 |
| literal: a word, second text | 10 | 516.28 ± 0.3% | 563.03 ± 0.2% | 967.49 ± 0.2% | 420.06 ± 0.5% | 530.88 ± 3.4% | 806.78 ± 0.7% | 27647.69 ± 0.3% | 516.31 ± 0.3% | 0.92 | 1.00 | 1.23 | 0.97 |
| class: two capitalized words | 23 | 413.15 ± 0.4% | 440.48 ± 0.8% | 654.38 ± 0.4% | 101.68 ± 0.4% | 500.64 ± 1.7% | 756.85 ± 1.6% | 6340.30 ± 0.1% | 412.31 ± 0.3% | 0.94 | 1.00 | 4.06 | 0.83 |
| class: a word that ends in ing | 9 | 518.70 ± 0.2% | 581.91 ± 0.5% | 1052.53 ± 0.1% | 133.09 ± 0.5% | 755.00 ± 1.1% | 1100.78 ± 2.9% | 15855.18 ± 0.1% | 518.93 ± 0.2% | 0.89 | 1.00 | 3.90 | 0.69 |
| class: a word in capitals | 16 | 465.26 ± 0.3% | 501.07 ± 0.2% | 815.46 ± 0.2% | 134.62 ± 1.5% | 755.61 ± 1.2% | 1007.38 ± 0.6% | 8349.59 ± 0.1% | 464.81 ± 0.2% | 0.93 | 1.00 | 3.46 | 0.62 |
| class: a number | 6 | 582.03 ± 0.2% | 637.52 ± 0.5% | 1230.92 ± 0.1% | 42.27 ± 0.9% | 1409.30 ± 0.9% | 1835.70 ± 0.9% | 23138.40 ± 0.2% | 582.84 ± 0.1% | 0.91 | 1.00 | 13.77 | 0.41 |
| class: two capitalized words, second text | 23 | 412.39 ± 0.8% | 441.19 ± 0.6% | 654.72 ± 0.6% | 102.89 ± 0.9% | 500.98 ± 1.4% | 765.66 ± 0.5% | 6337.43 ± 0.2% | 412.64 ± 0.3% | 0.93 | 1.00 | 4.01 | 0.82 |
| other: a word between two words | 13 | 503.95 ± 0.5% | 522.55 ± 0.4% | 856.74 ± 0.4% | 134.16 ± 0.4% | 503.40 ± 1.1% | 799.15 ± 0.6% | 14688.96 ± 0.3% | 504.22 ± 0.3% | 0.96 | 1.00 | 3.76 | 1.00 |
| other: a number before a unit, second text | 15 | 370.26 ± 0.5% | 406.14 ± 0.2% | 587.95 ± 0.4% | 39.77 ± 0.5% | 635.92 ± 1.9% | 880.88 ± 0.1% | 15300.04 ± 0.1% | 369.76 ± 0.3% | 0.91 | 1.00 | 9.31 | 0.58 |
| other: a heading's start tag | 13 | 333.05 ± 0.3% | 340.11 ± 0.4% | 456.78 ± 0.4% | 44.34 ± 0.2% | 630.69 ± 1.3% | 862.54 ± 0.4% | 18476.70 ± 0.3% | 333.71 ± 0.3% | 0.98 | 1.00 | 7.51 | 0.53 |
| other: a whole word | 11 | 532.74 ± 1.1% | 567.99 ± 0.9% | 988.45 ± 0.9% | 121.76 ± 0.3% | 565.41 ± 2.1% | 829.44 ± 0.5% | 26878.30 ± 1.1% | 533.60 ± 0.9% | 0.94 | 1.00 | 4.38 | 0.94 |
| other: a line's first word, second text | 17 | 484.01 ± 0.6% | 516.00 ± 0.3% | 851.56 ± 0.1% | 128.62 ± 0.1% | 709.54 ± 0.8% | refused | refused | 484.61 ± 0.3% | 0.94 | 1.00 | 3.76 | 0.68 |
| other: fourteen octets before an x | 16 | 106.48 ± 0.1% | 151.72 ± 0.5% | 177.28 ± 0.2% | 15.28 ± 0.2% | 451.13 ± 3.4% | 414.46 ± 0.8% | 12965.41 ± 0.2% | 106.40 ± 0.8% | 0.70 | 1.00 | 6.97 | 0.24 |
| other: a Greek word | 8 | 404.74 ± 0.3% | 551.64 ± 0.4% | 960.73 ± 0.9% | 59.24 ± 0.4% | 1388.44 ± 1.3% | 1789.59 ± 1.2% | refused | 405.02 ± 0.3% | 0.73 | 1.00 | 6.83 | 0.29 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15472.06 ± 1.3% | not timed | not timed | 16002.67 ± 2.2% | 2079.09 ± 18.7% | not timed | not timed | 15563.34 ± 3.9% | | 0.99 | 0.97 | 7.44 |
| 01-literal/sherlock-casei-en | 522 | 10931.40 ± 8.2% | not timed | not timed | 3593.65 ± 0.3% | 32.37 ± 0.2% | not timed | not timed | 10912.84 ± 6.1% | | 1.00 | 3.04 | 337.72 |
| 01-literal/sherlock-ru | 724 | 17092.41 ± 0.5% | not timed | not timed | 17202.12 ± 1.6% | 1503.64 ± 13.8% | not timed | not timed | 17070.64 ± 0.8% | | 1.00 | 0.99 | 11.37 |
| 01-literal/sherlock-casei-ru | 746 | 6128.86 ± 0.3% | not timed | not timed | 3330.16 ± 0.3% | 31.80 ± 10.1% | not timed | not timed | 6118.11 ± 0.6% | | 1.00 | 1.84 | 192.74 |
| 01-literal/sherlock-zh | 30 | 19361.85 ± 0.4% | not timed | not timed | 18237.62 ± 0.7% | 2641.38 ± 15.2% | not timed | not timed | 19343.24 ± 0.7% | | 1.00 | 1.06 | 7.33 |
| 02-literal-alternate/sherlock-en | 714 | 6134.84 ± 0.3% | not timed | not timed | 3938.81 ± 0.6% | 16.63 ± 0.3% | not timed | not timed | 6139.55 ± 0.3% | | 1.00 | 1.56 | 368.82 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1968.51 ± 0.7% | not timed | not timed | 696.50 ± 0.4% | 11.05 ± 0.1% | not timed | not timed | 1961.03 ± 0.8% | | 1.00 | 2.83 | 178.14 |
| 02-literal-alternate/sherlock-ru | 899 | 5494.03 ± 0.1% | not timed | not timed | 3249.35 ± 0.1% | 22.68 ± 0.0% | not timed | not timed | 5498.74 ± 0.1% | | 1.00 | 1.69 | 242.20 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2048.03 ± 0.5% | not timed | not timed | 1225.46 ± 0.6% | 9.14 ± 0.1% | not timed | not timed | 2048.28 ± 0.4% | | 1.00 | 1.67 | 223.95 |
| 02-literal-alternate/sherlock-zh | 207 | 7324.31 ± 0.2% | not timed | not timed | 4161.40 ± 0.2% | 31.56 ± 0.1% | not timed | not timed | 7324.62 ± 0.2% | | 1.00 | 1.76 | 232.06 |
| 03-date/ascii | 111817 | 134.33 ± 0.6% | not timed | not timed | 96.27 ± 0.1% | 0.20 ± 7.2% | not timed | not timed | 134.18 ± 0.6% | | 1.00 | 1.40 | 666.27 |
| 04-ruff-noqa/real | 84 | 436.58 ± 0.2% | not timed | not timed | 468.26 ± 0.2% | 19.59 ± 0.3% | not timed | not timed | 435.96 ± 0.2% | | 1.00 | 0.93 | 22.28 |
| 04-ruff-noqa/tweaked | 44 | 845.18 ± 0.1% | not timed | not timed | 466.96 ± 0.1% | 363.69 ± 0.8% | not timed | not timed | 846.42 ± 0.1% | | 1.00 | 1.81 | 2.32 |
| 05-lexer-veryl/single | 124800 | 5.42 ± 0.8% | not timed | not timed | 5.16 ± 0.4% | 0.21 ± 2.0% | not timed | not timed | 5.59 ± 0.5% | | 0.97 | 1.05 | 26.38 |
| 06-cloud-flare-redos/original | 107 | 440.09 ± 0.1% | not timed | not timed | 215.49 ± 0.1% | 24.94 ± 0.1% | not timed | not timed | 439.45 ± 0.2% | | 1.00 | 2.04 | 17.64 |
| 06-cloud-flare-redos/simplified-short | 102 | 439.74 ± 0.2% | not timed | not timed | 228.58 ± 0.1% | 26.60 ± 0.7% | not timed | not timed | 438.91 ± 0.9% | | 1.00 | 1.92 | 16.53 |
| 06-cloud-flare-redos/simplified-long | 10000 | 628.80 ± 0.2% | not timed | not timed | 256.29 ± 0.2% | 28.80 ± 0.1% | not timed | not timed | 629.43 ± 0.1% | | 1.00 | 2.45 | 21.84 |
| 07-unicode-character-data/parse-line | 558784 | 234.99 ± 11.8% | not timed | not timed | 179.63 ± 0.1% | 42.70 ± 4.9% | not timed | not timed | 233.89 ± 2.5% | | 1.00 | 1.31 | 5.50 |
| 08-words/all-english | 56691 | 129.33 ± 0.5% | not timed | not timed | 83.00 ± 0.2% | 12.97 ± 12.2% | not timed | not timed | 128.84 ± 0.8% | | 1.00 | 1.56 | 9.97 |
| 08-words/long-english | 839 | 618.79 ± 0.4% | not timed | not timed | 595.24 ± 0.3% | 32.49 ± 13.9% | not timed | not timed | 618.54 ± 0.8% | | 1.00 | 1.04 | 19.05 |
| 09-aws-keys/full | 0 | 440.96 ± 0.2% | not timed | not timed | 479.30 ± 0.1% | 64.00 ± 3.4% | not timed | not timed | 440.73 ± 0.4% | | 1.00 | 0.92 | 6.89 |
| 09-aws-keys/quick | 0 | 875.55 ± 0.2% | not timed | not timed | 998.84 ± 0.1% | 419.12 ± 0.9% | not timed | not timed | 876.14 ± 0.2% | | 1.00 | 0.88 | 2.09 |
| 10-bounded-repeat/letters-en | 1833 | 579.98 ± 1.3% | not timed | not timed | 518.60 ± 0.6% | 19.60 ± 0.4% | not timed | not timed | 577.23 ± 2.0% | | 1.00 | 1.12 | 29.60 |
| 10-bounded-repeat/letters-ru | 3475 | 505.74 ± 1.7% | not timed | not timed | 479.35 ± 0.2% | 22.59 ± 17.6% | not timed | not timed | 505.49 ± 1.1% | | 1.00 | 1.06 | 22.39 |
| 10-bounded-repeat/context | 53 | 84.59 ± 1.9% | not timed | not timed | 65.68 ± 0.7% | 19.80 ± 0.3% | not timed | not timed | 85.10 ± 1.5% | | 0.99 | 1.29 | 4.27 |
| 10-bounded-repeat/capitals | 11 | 637.45 ± 8.1% | not timed | not timed | 618.50 ± 0.3% | 36.25 ± 0.1% | not timed | not timed | 638.34 ± 8.0% | | 1.00 | 1.03 | 17.58 |
| 11-unstructured-to-json/extract | 600 | 57.68 ± 0.6% | not timed | not timed | 76.94 ± 0.4% | 48.98 ± 1.0% | not timed | not timed | 57.22 ± 0.6% | | 1.01 | 0.75 | 1.18 |
| 12-dictionary/single | 1 | 560.03 ± 1.5% | not timed | not timed | 561.48 ± 0.2% | 0.40 ± 0.2% | not timed | not timed | 562.33 ± 1.6% | | 1.00 | 1.00 | 1397.46 |
| 14-quadratic/1x | 100 | 21.91 ± 1.5% | not timed | not timed | 10.02 ± 0.3% | 0.98 ± 1.8% | not timed | not timed | 22.10 ± 1.4% | | 0.99 | 2.19 | 22.47 |
| 14-quadratic/2x | 200 | 19.70 ± 1.5% | not timed | not timed | 5.51 ± 0.2% | 0.53 ± 0.6% | not timed | not timed | 19.82 ± 0.8% | | 0.99 | 3.58 | 36.98 |
| 14-quadratic/10x | 1000 | 12.31 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.2% | not timed | not timed | 12.31 ± 0.9% | | 1.00 | 10.19 | 107.03 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.21 ± 0.5% | not timed | not timed | 0.34 ± 0.7% | 0.54 ± 4.5% | not timed | not timed | 1.22 ± 2.0% | | 1.00 | 3.53 | 2.23 |
| 04-ruff-noqa/compile-real | 1 | 102.76 ± 0.3% | not timed | not timed | 13.93 ± 0.4% | 137.67 ± 3.8% | not timed | not timed | 102.58 ± 0.4% | | 1.00 | 7.38 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 13.97 ± 0.3% | not timed | not timed | 2.54 ± 0.5% | 6.42 ± 2.1% | not timed | not timed | 13.97 ± 0.4% | | 1.00 | 5.51 | 2.17 |
| 07-unicode-character-data/compile | 1 | 106.95 ± 1.3% | not timed | not timed | 26.10 ± 0.2% | 36.23 ± 2.9% | not timed | not timed | 107.19 ± 1.0% | | 1.00 | 4.10 | 2.95 |
| 09-aws-keys/compile-full | 1 | 52.36 ± 1.7% | not timed | not timed | 8.36 ± 0.9% | 23.19 ± 2.1% | not timed | not timed | 52.23 ± 1.2% | | 1.00 | 6.26 | 2.26 |
| 09-aws-keys/compile-quick | 1 | 180.53 ± 0.8% | not timed | not timed | 47.77 ± 0.3% | 131.18 ± 3.5% | not timed | not timed | 181.63 ± 0.3% | | 0.99 | 3.78 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 70.45 ± 0.4% | not timed | not timed | 11.20 ± 0.2% | 15.96 ± 2.4% | not timed | not timed | 70.57 ± 0.4% | | 1.00 | 6.29 | 4.41 |
| 10-bounded-repeat/compile-capitals | 1 | 83.22 ± 2.6% | not timed | not timed | 8.11 ± 0.2% | 23.63 ± 2.0% | not timed | not timed | 83.61 ± 3.0% | | 1.00 | 10.26 | 3.52 |
| 11-unstructured-to-json/compile | 1 | 168.27 ± 3.6% | not timed | not timed | 40.89 ± 0.5% | 65.92 ± 6.8% | not timed | not timed | 169.03 ± 1.4% | | 1.00 | 4.12 | 2.55 |
| 12-dictionary/compile-single | 1 | 0.34 ± 0.8% | not timed | not timed | 0.07 ± 2.0% | 0.09 ± 11.0% | not timed | not timed | 0.35 ± 0.6% | | 1.00 | 5.11 | 4.04 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.46 ± 2.5% | not timed | not timed | 6.55 ± 0.5% | 0.59 ± 28.0% | not timed | not timed | 7.56 ± 2.9% | | 0.99 | 1.14 | 12.60 |
| dictionary/search/english-10 | 690 | 207.83 ± 2.1% | not timed | not timed | 165.85 ± 0.2% | 0.00 ± 0.4% | not timed | not timed | 206.35 ± 4.0% | | 1.01 | 1.25 | 77311.21 |
| dictionary/search/english-15 | 15 | 560.36 ± 1.4% | not timed | not timed | 554.56 ± 0.4% | 0.37 ± 0.4% | not timed | not timed | 561.50 ± 1.5% | | 1.00 | 1.01 | 1525.03 |
| folly/awyer-inn-busted | 1 | 21501.23 ± 0.1% | not timed | not timed | 142.89 ± 0.1% | 43.80 ± 0.2% | not timed | not timed | 21570.60 ± 0.1% | | 1.00 | 150.48 | 490.93 |
| folly/literal-never-match-rare | 0 | 21092.66 ± 0.7% | not timed | not timed | 19814.58 ± 0.3% | 40786.34 ± 0.7% | not timed | not timed | 21113.73 ± 0.4% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12524.82 ± 0.8% | not timed | not timed | 19784.23 ± 0.6% | 2184.59 ± 0.8% | not timed | not timed | 12528.22 ± 0.3% | | 1.00 | 0.63 | 5.73 |
| folly/literal-never-match-tricksy | 1 | 3255.83 ± 0.2% | not timed | not timed | 4403.66 ± 0.1% | 3001.37 ± 0.3% | not timed | not timed | 3255.41 ± 0.3% | | 1.00 | 0.74 | 1.08 |
| grep/every-line | 239963 | 1299.77 ± 0.5% | not timed | not timed | 956.91 ± 0.2% | 377.84 ± 16.9% | not timed | not timed | 1307.43 ± 0.3% | | 0.99 | 1.36 | 3.44 |
| grep/long-words-ascii | 5073 | 458.84 ± 0.4% | not timed | not timed | 469.17 ± 0.2% | 45.84 ± 6.0% | not timed | not timed | 459.81 ± 0.2% | | 1.00 | 0.98 | 10.01 |
| imported/leipzig/twain | 811 | 20664.85 ± 0.9% | not timed | not timed | 19478.64 ± 0.7% | 11972.99 ± 10.0% | not timed | not timed | 20667.65 ± 0.3% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9064.58 ± 1.4% | not timed | not timed | 4247.63 ± 0.1% | 37.75 ± 0.4% | not timed | not timed | 9097.87 ± 1.1% | | 1.00 | 2.13 | 240.13 |
| imported/leipzig/shing | 1540 | 15213.74 ± 1.7% | not timed | not timed | 13499.73 ± 1.0% | 34.00 ± 0.1% | not timed | not timed | 15527.02 ± 2.7% | | 0.98 | 1.13 | 447.46 |
| imported/leipzig/huck-saw | 262 | 8204.39 ± 3.2% | not timed | not timed | 5593.83 ± 0.3% | 31.79 ± 0.1% | not timed | not timed | 8409.67 ± 3.3% | | 0.98 | 1.47 | 258.06 |
| imported/leipzig/word-ending-nn | 262 | 604.06 ± 0.3% | not timed | not timed | 616.34 ± 0.1% | 24.79 ± 0.2% | not timed | not timed | 605.10 ± 0.2% | | 1.00 | 0.98 | 24.37 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11257.52 ± 1.0% | not timed | not timed | 4536.58 ± 1.5% | 11.49 ± 1.1% | not timed | not timed | 11300.95 ± 2.0% | | 1.00 | 2.48 | 979.58 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7812.32 ± 1.7% | not timed | not timed | 5485.21 ± 0.3% | 16.92 ± 0.1% | not timed | not timed | 7872.08 ± 2.4% | | 0.99 | 1.42 | 461.69 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4159.01 ± 0.8% | not timed | not timed | 423.87 ± 0.9% | 11.08 ± 0.1% | not timed | not timed | 4168.78 ± 0.9% | | 1.00 | 9.81 | 375.38 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7266.22 ± 1.8% | not timed | not timed | 615.20 ± 0.1% | 11.12 ± 0.1% | not timed | not timed | 7282.18 ± 3.1% | | 1.00 | 11.81 | 653.41 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7053.17 ± 1.8% | not timed | not timed | 615.72 ± 0.0% | 9.74 ± 0.1% | not timed | not timed | 7158.03 ± 3.8% | | 0.99 | 11.46 | 724.21 |
| imported/leipzig/tom-river | 2 | 6390.06 ± 2.3% | not timed | not timed | 5090.95 ± 1.4% | 30.91 ± 0.1% | not timed | not timed | 6413.06 ± 4.3% | | 1.00 | 1.26 | 206.73 |
| imported/leipzig/ing | 78424 | 602.66 ± 1.1% | not timed | not timed | 571.54 ± 0.0% | 28.27 ± 4.3% | not timed | not timed | 603.51 ± 0.8% | | 1.00 | 1.05 | 21.32 |
| imported/leipzig/ing-whitespace | 55248 | 1924.06 ± 0.9% | not timed | not timed | 2065.52 ± 0.5% | 20.49 ± 2.7% | not timed | not timed | 1927.44 ± 1.6% | | 1.00 | 0.93 | 93.89 |
| imported/leipzig/awyer-inn | 209 | 6375.33 ± 1.7% | not timed | not timed | 4278.99 ± 0.2% | 22.55 ± 0.1% | not timed | not timed | 6417.24 ± 1.4% | | 0.99 | 1.49 | 282.77 |
| imported/leipzig/quotes-bounded | 8886 | 2470.85 ± 0.9% | not timed | not timed | 2778.79 ± 0.9% | 38.24 ± 0.2% | not timed | not timed | 2481.73 ± 1.1% | | 1.00 | 0.89 | 64.61 |
| imported/leipzig/non-ascii-alternate | 2 | 12770.61 ± 2.5% | not timed | not timed | 5660.02 ± 0.4% | 50.77 ± 0.1% | not timed | not timed | 13053.45 ± 3.2% | | 0.98 | 2.26 | 251.52 |
| imported/leipzig/math-symbols | 69 | 1981.02 ± 0.4% | not timed | not timed | 614.63 ± 0.1% | 36.50 ± 0.1% | not timed | not timed | 1982.92 ± 0.5% | | 1.00 | 3.22 | 54.27 |
| imported/leipzig/bounded-strings-ending-z | 0 | 632.60 ± 1.2% | not timed | not timed | 618.13 ± 0.0% | 22.44 ± 0.1% | not timed | not timed | 630.58 ± 1.8% | | 1.00 | 1.02 | 28.19 |
| imported/lh3lh3-reb/uri | 17549 | 676.84 ± 0.2% | not timed | not timed | 1079.68 ± 0.2% | 28.19 ± 2.7% | not timed | not timed | 680.73 ± 0.4% | | 0.99 | 0.63 | 24.01 |
| imported/lh3lh3-reb/email | 15057 | 674.48 ± 0.0% | not timed | not timed | 1164.41 ± 1.2% | 29.89 ± 2.7% | not timed | not timed | 671.04 ± 0.1% | | 1.01 | 0.58 | 22.57 |
| imported/lh3lh3-reb/date | 668 | 892.67 ± 0.1% | not timed | not timed | 1038.58 ± 0.3% | 48.15 ± 3.6% | not timed | not timed | 893.06 ± 0.1% | | 1.00 | 0.86 | 18.54 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 644.86 ± 0.1% | not timed | not timed | 424.64 ± 0.1% | 15.49 ± 1.2% | not timed | not timed | 647.45 ± 0.1% | | 1.00 | 1.52 | 41.62 |
| imported/mariomka/email | 92 | 24137.84 ± 1.2% | not timed | not timed | 28900.78 ± 2.6% | 32.84 ± 0.2% | not timed | not timed | 24333.57 ± 1.5% | | 0.99 | 0.84 | 734.97 |
| imported/mariomka/uri | 5301 | 5535.24 ± 1.1% | not timed | not timed | 6083.71 ± 0.4% | 32.78 ± 0.4% | not timed | not timed | 5583.60 ± 0.9% | | 0.99 | 0.91 | 168.88 |
| imported/mariomka/ip | 5 | 2598.88 ± 2.8% | not timed | not timed | 2966.89 ± 0.1% | 21.04 ± 0.2% | not timed | not timed | 2598.28 ± 3.7% | | 1.00 | 0.88 | 123.50 |
| imported/rsc/no-exponential | 0 | 606.81 ± 0.1% | not timed | not timed | 315.67 ± 0.1% | 23.63 ± 0.3% | not timed | not timed | 608.24 ± 0.2% | | 1.00 | 1.92 | 25.68 |
| imported/rsc/literal | 1 | 1525.07 ± 7.9% | not timed | not timed | 1668.79 ± 4.3% | 190.09 ± 20.4% | not timed | not timed | 1523.92 ± 9.0% | | 1.00 | 0.91 | 8.02 |
| imported/rsc/not-literal | 2 | 778.10 ± 1.9% | not timed | not timed | 735.97 ± 0.1% | 45.10 ± 8.4% | not timed | not timed | 778.56 ± 0.2% | | 1.00 | 1.06 | 17.25 |
| imported/rsc/match-class | 1 | 1475.66 ± 0.4% | not timed | not timed | 1697.92 ± 0.2% | 56.26 ± 6.7% | not timed | not timed | 1476.64 ± 2.5% | | 1.00 | 0.87 | 26.23 |
| imported/rsc/match-class-in-range | 1 | 1475.23 ± 10.2% | not timed | not timed | 2384.50 ± 2.7% | 57.68 ± 1.3% | not timed | not timed | 1477.56 ± 0.4% | | 1.00 | 0.62 | 25.57 |
| imported/rsc/match-class-unicode | 1 | 540.28 ± 1.8% | not timed | not timed | 511.42 ± 0.1% | 69.21 ± 7.3% | not timed | not timed | 541.13 ± 0.2% | | 1.00 | 1.06 | 7.81 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1461.39 ± 0.3% | not timed | not timed | 938.71 ± 0.1% | 228.65 ± 0.3% | not timed | not timed | 1440.14 ± 0.1% | | 1.01 | 1.56 | 6.39 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21922.42 ± 0.3% | not timed | not timed | 13644.41 ± 0.3% | 3423.98 ± 0.6% | not timed | not timed | 21509.59 ± 0.1% | | 1.02 | 1.61 | 6.40 |
| imported/rsc/anchored-literal-short-match | 4 | 725.69 ± 1.4% | not timed | not timed | 490.86 ± 0.2% | 85.71 ± 11.7% | not timed | not timed | 724.82 ± 1.8% | | 1.00 | 1.48 | 8.47 |
| imported/rsc/anchored-literal-long-match | 4 | 10885.88 ± 2.2% | not timed | not timed | 7299.80 ± 0.1% | 1231.19 ± 4.2% | not timed | not timed | 10859.46 ± 2.2% | | 1.00 | 1.49 | 8.84 |
| imported/rsc/one-pass-short | 17 | 370.62 ± 1.3% | not timed | not timed | 216.32 ± 0.2% | 31.13 ± 9.6% | not timed | not timed | 365.08 ± 10.9% | | 1.02 | 1.71 | 11.91 |
| imported/rsc/one-pass-short-not | 17 | 270.03 ± 7.5% | not timed | not timed | 223.42 ± 0.1% | 30.74 ± 8.9% | not timed | not timed | 270.39 ± 2.5% | | 1.00 | 1.21 | 8.78 |
| imported/rsc/one-pass-long-prefix | 26 | 361.21 ± 1.2% | not timed | not timed | 284.82 ± 0.5% | 95.39 ± 20.8% | not timed | not timed | 362.88 ± 1.6% | | 1.00 | 1.27 | 3.79 |
| imported/rsc/one-pass-long-prefix-not | 26 | 359.30 ± 2.1% | not timed | not timed | 286.33 ± 0.5% | 65.43 ± 22.9% | not timed | not timed | 363.48 ± 2.1% | | 0.99 | 1.25 | 5.49 |
| imported/rsc/long-needle1 | 31 | 21946.57 ± 0.2% | not timed | not timed | 20133.15 ± 0.1% | 3.75 ± 0.1% | not timed | not timed | 21947.04 ± 0.1% | | 1.00 | 1.09 | 5848.07 |
| imported/rsc/long-needle2 | 31 | 22075.53 ± 0.2% | not timed | not timed | 216.39 ± 0.2% | 3.75 ± 0.1% | not timed | not timed | 22080.51 ± 0.1% | | 1.00 | 102.02 | 5880.93 |
| imported/rsc/easy0-32 | 26 | 1593.57 ± 2.0% | not timed | not timed | 1521.54 ± 0.3% | 147.94 ± 19.9% | not timed | not timed | 1576.49 ± 1.9% | | 1.01 | 1.05 | 10.77 |
| imported/rsc/easy0-1k | 26 | 13667.60 ± 0.5% | not timed | not timed | 12321.95 ± 0.1% | 2299.22 ± 16.0% | not timed | not timed | 13597.97 ± 2.3% | | 1.01 | 1.11 | 5.94 |
| imported/rsc/easy0-32k | 26 | 22770.13 ± 1.7% | not timed | not timed | 20294.69 ± 0.1% | 18813.95 ± 17.9% | not timed | not timed | 22776.49 ± 0.1% | | 1.00 | 1.12 | 1.21 |
| imported/rsc/easy0-1mb | 26 | 21328.86 ± 3.1% | not timed | not timed | 19588.72 ± 1.9% | 36246.63 ± 4.3% | not timed | not timed | 21352.87 ± 2.9% | | 1.00 | 1.09 | 0.59 |
| imported/rsc/easy1-32 | 19 | 762.07 ± 2.3% | not timed | not timed | 627.49 ± 0.7% | 129.59 ± 15.5% | not timed | not timed | 769.86 ± 0.3% | | 0.99 | 1.21 | 5.88 |
| imported/rsc/easy1-1k | 19 | 15892.65 ± 0.1% | not timed | not timed | 12828.76 ± 0.3% | 2494.05 ± 21.9% | not timed | not timed | 15759.55 ± 0.1% | | 1.01 | 1.24 | 6.37 |
| imported/rsc/easy1-32k | 19 | 495718.36 ± 0.1% | not timed | not timed | 415515.20 ± 0.1% | 20481.08 ± 19.4% | not timed | not timed | 493281.34 ± 2.7% | | 1.00 | 1.19 | 24.20 |
| imported/rsc/easy1-1mb | 19 | 15961229.68 ± 0.1% | not timed | not timed | 13037642.92 ± 0.4% | 36504.92 ± 2.6% | not timed | not timed | 15849745.38 ± 0.3% | | 1.01 | 1.22 | 437.23 |
| imported/rsc/medium-32 | 27 | 738.63 ± 0.1% | not timed | not timed | 632.40 ± 0.3% | 69.78 ± 15.2% | not timed | not timed | 739.61 ± 0.2% | | 1.00 | 1.17 | 10.58 |
| imported/rsc/medium-1k | 27 | 13153.76 ± 0.2% | not timed | not timed | 11110.26 ± 0.1% | 72.35 ± 0.1% | not timed | not timed | 13142.99 ± 0.2% | | 1.00 | 1.18 | 181.81 |
| imported/rsc/medium-32k | 27 | 410792.80 ± 0.1% | not timed | not timed | 348926.22 ± 0.4% | 48.66 ± 0.1% | not timed | not timed | 409864.06 ± 0.3% | | 1.00 | 1.18 | 8442.60 |
| imported/rsc/medium-1mb | 27 | 13134637.89 ± 0.2% | not timed | not timed | 11287399.35 ± 0.1% | 48.52 ± 0.1% | not timed | not timed | 13084234.32 ± 0.3% | | 1.00 | 1.16 | 270723.46 |
| imported/rsc/hard-32 | 58 | 423.83 ± 2.3% | not timed | not timed | 362.78 ± 0.1% | 49.68 ± 8.0% | not timed | not timed | 421.97 ± 0.2% | | 1.00 | 1.17 | 8.53 |
| imported/rsc/hard-1k | 27 | 12940.67 ± 0.3% | not timed | not timed | 11487.00 ± 0.7% | 40.51 ± 0.1% | not timed | not timed | 12860.71 ± 0.3% | | 1.01 | 1.13 | 319.48 |
| imported/rsc/hard-32k | 27 | 400524.20 ± 0.4% | not timed | not timed | 360453.08 ± 0.4% | 29.41 ± 0.1% | not timed | not timed | 401475.71 ± 0.2% | | 1.00 | 1.11 | 13620.03 |
| imported/rsc/hard-1mb | 51 | 8332134.72 ± 0.6% | not timed | not timed | 7108325.55 ± 0.1% | 29.49 ± 0.1% | not timed | not timed | 8327768.62 ± 0.1% | | 1.00 | 1.17 | 282533.29 |
| imported/rsc/reallyhard0-32 | 58 | 263.61 ± 2.3% | not timed | not timed | 222.09 ± 0.2% | 49.34 ± 7.6% | not timed | not timed | 263.37 ± 0.1% | | 1.00 | 1.19 | 5.34 |
| imported/rsc/reallyhard0-1k | 27 | 579.77 ± 0.3% | not timed | not timed | 583.80 ± 0.2% | 40.69 ± 0.2% | not timed | not timed | 581.99 ± 0.1% | | 1.00 | 0.99 | 14.25 |
| imported/rsc/reallyhard0-32k | 27 | 605.06 ± 0.1% | not timed | not timed | 615.94 ± 0.1% | 29.38 ± 0.0% | not timed | not timed | 601.49 ± 0.2% | | 1.01 | 0.98 | 20.59 |
| imported/rsc/reallyhard0-1mb | 51 | 625.79 ± 1.3% | not timed | not timed | 617.53 ± 0.1% | 29.43 ± 0.1% | not timed | not timed | 630.20 ± 1.3% | | 0.99 | 1.01 | 21.26 |
| imported/rsc/reallyreallyhard0-32 | 47 | 284.72 ± 5.7% | not timed | not timed | 193.93 ± 0.9% | 60.31 ± 5.3% | not timed | not timed | 286.29 ± 1.4% | | 0.99 | 1.47 | 4.72 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7066.34 ± 0.1% | not timed | not timed | 5925.32 ± 0.1% | 34.01 ± 1.5% | not timed | not timed | 7089.17 ± 0.1% | | 1.00 | 1.19 | 207.80 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21462.06 ± 0.2% | not timed | not timed | 19260.36 ± 0.1% | 25.16 ± 0.1% | not timed | not timed | 21467.36 ± 0.1% | | 1.00 | 1.11 | 853.07 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21935.21 ± 1.0% | not timed | not timed | 19940.76 ± 1.2% | 25.04 ± 0.3% | not timed | not timed | 21910.44 ± 1.7% | | 1.00 | 1.10 | 876.07 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 281.20 ± 1.5% | not timed | not timed | 211.89 ± 0.1% | 60.97 ± 10.9% | not timed | not timed | 281.92 ± 1.3% | | 1.00 | 1.33 | 4.61 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5938.40 ± 0.3% | not timed | not timed | 6166.55 ± 0.0% | 34.22 ± 1.8% | not timed | not timed | 5947.14 ± 0.1% | | 1.00 | 0.96 | 173.55 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21367.54 ± 0.2% | not timed | not timed | 19233.72 ± 0.1% | 25.07 ± 0.3% | not timed | not timed | 21291.85 ± 0.1% | | 1.00 | 1.11 | 852.26 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21676.94 ± 1.2% | not timed | not timed | 19796.81 ± 2.1% | 24.96 ± 2.0% | not timed | not timed | 21554.74 ± 0.9% | | 1.01 | 1.09 | 868.57 |
| imported/sherlock/name-sherlock | 776 | 19649.93 ± 0.6% | not timed | not timed | 18389.03 ± 0.8% | 10036.32 ± 15.1% | not timed | not timed | 19579.66 ± 7.0% | | 1.00 | 1.07 | 1.96 |
| imported/sherlock/name-holmes | 2766 | 15177.10 ± 1.6% | not timed | not timed | 15530.29 ± 0.5% | 3304.19 ± 9.8% | not timed | not timed | 15207.18 ± 1.1% | | 1.00 | 0.98 | 4.59 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19668.99 ± 2.7% | not timed | not timed | 18413.80 ± 0.5% | 8013.76 ± 37.8% | not timed | not timed | 19687.81 ± 2.7% | | 1.00 | 1.07 | 2.45 |
| imported/sherlock/name-sherlock-casei | 816 | 15584.64 ± 0.5% | not timed | not timed | 4013.31 ± 0.2% | 32.46 ± 0.5% | not timed | not timed | 15618.87 ± 1.0% | | 1.00 | 3.88 | 480.11 |
| imported/sherlock/name-holmes-casei | 2802 | 9363.43 ± 5.7% | not timed | not timed | 3306.96 ± 0.1% | 37.32 ± 0.2% | not timed | not timed | 9393.85 ± 4.5% | | 1.00 | 2.83 | 250.87 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12814.23 ± 7.4% | not timed | not timed | 3950.35 ± 0.2% | 32.42 ± 0.2% | not timed | not timed | 12827.25 ± 1.1% | | 1.00 | 3.24 | 395.24 |
| imported/sherlock/name-whitespace | 1461 | 15249.46 ± 0.3% | not timed | not timed | 14395.70 ± 0.2% | 7317.32 ± 24.2% | not timed | not timed | 15235.54 ± 2.3% | | 1.00 | 1.06 | 2.08 |
| imported/sherlock/name-alt1 | 1142 | 11554.25 ± 2.3% | not timed | not timed | 16261.00 ± 0.4% | 4111.36 ± 42.3% | not timed | not timed | 11569.60 ± 0.4% | | 1.00 | 0.71 | 2.81 |
| imported/sherlock/name-alt2 | 3542 | 8898.60 ± 0.4% | not timed | not timed | 3828.99 ± 0.2% | 31.42 ± 0.1% | not timed | not timed | 8908.10 ± 0.2% | | 1.00 | 2.32 | 283.19 |
| imported/sherlock/name-alt3 | 4507 | 5537.09 ± 0.5% | not timed | not timed | 3633.13 ± 0.0% | 9.96 ± 4.5% | not timed | not timed | 5493.33 ± 0.5% | | 1.01 | 1.52 | 555.68 |
| imported/sherlock/name-alt3-casei | 4593 | 1510.81 ± 2.3% | not timed | not timed | 285.30 ± 0.2% | 6.39 ± 0.2% | not timed | not timed | 1519.23 ± 1.2% | | 0.99 | 5.30 | 236.26 |
| imported/sherlock/name-alt4 | 3686 | 6426.00 ± 0.2% | not timed | not timed | 3777.28 ± 0.1% | 31.28 ± 0.2% | not timed | not timed | 6423.76 ± 0.2% | | 1.00 | 1.70 | 205.43 |
| imported/sherlock/name-alt4-casei | 4254 | 2805.73 ± 12.0% | not timed | not timed | 2585.52 ± 0.3% | 19.84 ± 2.7% | not timed | not timed | 2800.36 ± 0.9% | | 1.00 | 1.09 | 141.43 |
| imported/sherlock/name-alt5 | 4028 | 6371.46 ± 0.2% | not timed | not timed | 3748.09 ± 0.1% | 21.83 ± 0.2% | not timed | not timed | 6376.03 ± 0.1% | | 1.00 | 1.70 | 291.85 |
| imported/sherlock/name-alt5-casei | 4104 | 3488.05 ± 2.0% | not timed | not timed | 2218.97 ± 0.0% | 14.35 ± 0.1% | not timed | not timed | 3487.30 ± 0.9% | | 1.00 | 1.57 | 243.12 |
| imported/sherlock/no-match-uncommon | 0 | 21384.23 ± 0.4% | not timed | not timed | 19398.19 ± 1.0% | 35374.67 ± 0.2% | not timed | not timed | 21350.59 ± 1.5% | | 1.00 | 1.10 | 0.60 |
| imported/sherlock/no-match-common | 0 | 21227.90 ± 0.4% | not timed | not timed | 19293.18 ± 0.5% | 1283.76 ± 1.7% | not timed | not timed | 21208.38 ± 0.7% | | 1.00 | 1.10 | 16.54 |
| imported/sherlock/no-match-really-common | 0 | 15966.72 ± 2.0% | not timed | not timed | 18601.01 ± 0.9% | 1275.67 ± 1.3% | not timed | not timed | 16127.38 ± 2.1% | | 0.99 | 0.86 | 12.52 |
| imported/sherlock/the-lower | 21654 | 2299.65 ± 0.8% | not timed | not timed | 2337.97 ± 0.3% | 233.56 ± 20.7% | not timed | not timed | 2303.48 ± 1.1% | | 1.00 | 0.98 | 9.85 |
| imported/sherlock/the-upper | 2223 | 12699.37 ± 1.4% | not timed | not timed | 13565.75 ± 0.3% | 2708.37 ± 14.1% | not timed | not timed | 12735.63 ± 0.9% | | 1.00 | 0.94 | 4.69 |
| imported/sherlock/the-casei | 23961 | 1986.07 ± 1.2% | not timed | not timed | 1310.33 ± 0.4% | 34.87 ± 24.1% | not timed | not timed | 1986.15 ± 0.4% | | 1.00 | 1.52 | 56.95 |
| imported/sherlock/everything-greedy | 581881 | 281.97 ± 0.9% | not timed | not timed | 166.77 ± 0.2% | 28.94 ± 31.6% | not timed | not timed | 280.55 ± 0.1% | | 1.01 | 1.69 | 9.74 |
| imported/sherlock/everything-greedy-nl | 594933 | 490.44 ± 0.2% | not timed | not timed | 211.93 ± 0.3% | 32.89 ± 0.1% | not timed | not timed | 489.68 ± 0.1% | | 1.00 | 2.31 | 14.91 |
| imported/sherlock/letters | 447175 | 61.63 ± 0.5% | not timed | not timed | 32.86 ± 0.1% | 6.41 ± 18.8% | not timed | not timed | 61.69 ± 0.7% | | 1.00 | 1.88 | 9.62 |
| imported/sherlock/letters-upper | 14180 | 447.81 ± 3.9% | not timed | not timed | 371.48 ± 0.1% | 29.57 ± 23.3% | not timed | not timed | 445.79 ± 0.2% | | 1.00 | 1.21 | 15.14 |
| imported/sherlock/letters-lower | 432995 | 62.31 ± 0.6% | not timed | not timed | 33.91 ± 0.1% | 5.22 ± 31.7% | not timed | not timed | 62.80 ± 1.1% | | 0.99 | 1.84 | 11.93 |
| imported/sherlock/words | 447639 | 113.00 ± 2.6% | not timed | not timed | 82.85 ± 0.1% | 13.69 ± 6.6% | not timed | not timed | 112.67 ± 0.8% | | 1.00 | 1.36 | 8.25 |
| imported/sherlock/before-holmes | 4073 | 10215.07 ± 0.5% | not timed | not timed | 8350.85 ± 0.3% | 24.00 ± 1.2% | not timed | not timed | 10219.80 ± 0.5% | | 1.00 | 1.22 | 425.62 |
| imported/sherlock/before-after-holmes | 2593 | 9840.24 ± 1.0% | not timed | not timed | 9491.75 ± 0.2% | 23.83 ± 1.6% | not timed | not timed | 9878.41 ± 0.6% | | 1.00 | 1.04 | 412.92 |
| imported/sherlock/holmes-cochar-watson | 150 | 5191.19 ± 0.3% | not timed | not timed | 3422.12 ± 0.1% | 31.07 ± 0.1% | not timed | not timed | 5191.61 ± 0.4% | | 1.00 | 1.52 | 167.08 |
| imported/sherlock/holmes-coword-watson | 14309 | 1152.00 ± 0.2% | not timed | not timed | 1123.47 ± 0.4% | 6.73 ± 0.3% | not timed | not timed | 1154.95 ± 0.1% | | 1.00 | 1.03 | 171.17 |
| imported/sherlock/quotes | 14437 | 1573.03 ± 0.3% | not timed | not timed | 1742.01 ± 1.0% | 35.10 ± 0.5% | not timed | not timed | 1571.45 ± 0.2% | | 1.00 | 0.90 | 44.81 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17305.31 ± 0.3% | not timed | not timed | 15966.53 ± 0.6% | 36.69 ± 0.2% | not timed | not timed | 17275.99 ± 0.1% | | 1.00 | 1.08 | 471.69 |
| imported/sherlock/word-ending-n | 35297 | 482.14 ± 1.1% | not timed | not timed | 409.43 ± 0.1% | 23.62 ± 25.8% | not timed | not timed | 479.53 ± 0.4% | | 1.01 | 1.18 | 20.41 |
| imported/sherlock/repeated-class-negation | 2130 | 14772.37 ± 0.7% | not timed | not timed | 10876.57 ± 0.8% | 11.43 ± 0.1% | not timed | not timed | 14807.45 ± 0.7% | | 1.00 | 1.36 | 1292.17 |
| imported/sherlock/ing-suffix | 20547 | 558.32 ± 0.5% | not timed | not timed | 516.36 ± 0.1% | 28.87 ± 0.2% | not timed | not timed | 556.76 ± 0.3% | | 1.00 | 1.08 | 19.34 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1672.82 ± 0.6% | not timed | not timed | 2105.62 ± 0.5% | 20.51 ± 0.3% | not timed | not timed | 1668.18 ± 0.8% | | 1.00 | 0.79 | 81.55 |
| opt/accelerate/whole-line | 239963 | 457.88 ± 0.4% | not timed | not timed | 372.39 ± 0.4% | 90.97 ± 16.7% | not timed | not timed | 457.54 ± 0.1% | | 1.00 | 1.23 | 5.03 |
| opt/accelerate/non-dna | 16745 | 431.65 ± 0.5% | not timed | not timed | 398.34 ± 0.1% | 29.58 ± 15.4% | not timed | not timed | 430.97 ± 2.1% | | 1.00 | 1.08 | 14.59 |
| opt/backtrack/words-english | 40536 | 141.51 ± 9.4% | not timed | not timed | 94.16 ± 0.1% | 19.60 ± 7.0% | not timed | not timed | 141.52 ± 1.7% | | 1.00 | 1.50 | 7.22 |
| opt/fixed-length/too-small-ascii | 0 | 315.36 ± 0.1% | not timed | not timed | 686.70 ± 3.7% | 79.97 ± 1.0% | not timed | not timed | 315.71 ± 0.3% | | 1.00 | 0.46 | 3.94 |
| opt/fixed-length/too-big-ascii | 0 | 3484.90 ± 0.2% | not timed | not timed | 5855.30 ± 0.1% | 125.84 ± 0.3% | not timed | not timed | 3488.17 ± 0.1% | | 1.00 | 0.60 | 27.69 |
| opt/fixed-length/go33484-1 | 0 | 670344.75 ± 0.1% | not timed | not timed | 1120317.15 ± 0.1% | 61128.47 ± 0.5% | not timed | not timed | 669976.48 ± 0.4% | | 1.00 | 0.60 | 10.97 |
| opt/fixed-length/go33484-2 | 0 | 670308.84 ± 0.1% | not timed | not timed | 1122926.14 ± 0.1% | 32671.43 ± 1.1% | not timed | not timed | 669948.74 ± 0.2% | | 1.00 | 0.60 | 20.52 |
| opt/fixed-length/go33484-3 | 0 | 67043.83 ± 0.7% | not timed | not timed | 111781.00 ± 0.2% | 768.84 ± 0.2% | not timed | not timed | 66983.04 ± 0.6% | | 1.00 | 0.60 | 87.20 |
| opt/literal-alt/one-pattern | 1 | 549.27 ± 3.3% | not timed | not timed | 543.37 ± 0.1% | 0.40 ± 0.4% | not timed | not timed | 549.55 ± 1.7% | | 1.00 | 1.01 | 1372.09 |
| opt/onepass/fn-predicate | 916 | 364.93 ± 0.8% | not timed | not timed | 332.20 ± 0.2% | 199.86 ± 14.2% | not timed | not timed | 367.89 ± 0.8% | | 0.99 | 1.10 | 1.83 |
| opt/onepass/first-three-words-english | 35128 | 178.43 ± 7.3% | not timed | not timed | 201.56 ± 0.3% | 79.50 ± 10.4% | not timed | not timed | 181.90 ± 1.8% | | 0.98 | 0.89 | 2.24 |
| opt/prefilter/literal-english | 1 | 20566.68 ± 0.5% | not timed | not timed | 19736.80 ± 0.4% | 17534.30 ± 0.5% | not timed | not timed | 20548.26 ± 0.2% | | 1.00 | 1.04 | 1.17 |
| opt/prefilter/literal-casei-english | 1 | 14466.99 ± 0.7% | not timed | not timed | 4316.43 ± 0.1% | 32.74 ± 0.3% | not timed | not timed | 14478.83 ± 0.3% | | 1.00 | 3.35 | 441.90 |
| opt/prefilter/literal-russian | 1 | 21724.40 ± 0.2% | not timed | not timed | 20178.58 ± 0.2% | 3320.98 ± 0.2% | not timed | not timed | 21755.31 ± 0.3% | | 1.00 | 1.08 | 6.54 |
| opt/prefilter/literal-casei-russian | 1 | 8557.54 ± 0.1% | not timed | not timed | 3889.90 ± 0.4% | 31.75 ± 0.4% | not timed | not timed | 8590.33 ± 0.8% | | 1.00 | 2.20 | 269.56 |
| opt/prefilter/rust-functions | 948 | 6812.44 ± 0.3% | not timed | not timed | 8926.05 ± 0.4% | 1869.79 ± 0.3% | not timed | not timed | 6811.74 ± 0.4% | | 1.00 | 0.76 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 29559346.40 ± 0.1% | not timed | not timed | 20884778.13 ± 0.4% | 50.69 ± 0.1% | not timed | not timed | 29601718.78 ± 0.2% | | 1.00 | 1.42 | 583123.49 |
| opt/reverse-inner/holmes | 2593 | 9840.91 ± 0.7% | not timed | not timed | 9498.54 ± 0.3% | 24.03 ± 1.2% | not timed | not timed | 9879.66 ± 1.0% | | 1.00 | 1.04 | 409.45 |
| opt/reverse-inner/email | 47 | 36111.52 ± 1.6% | not timed | not timed | 44525.35 ± 0.7% | 32.45 ± 0.3% | not timed | not timed | 36609.39 ± 2.1% | | 0.99 | 0.81 | 1112.97 |
| opt/reverse-inner/factored-prefix | 3542 | 592.59 ± 0.2% | not timed | not timed | 597.18 ± 0.1% | 12.56 ± 0.4% | not timed | not timed | 590.91 ± 0.4% | | 1.00 | 0.99 | 47.17 |
| opt/reverse-inner/no-quadratic-backward | 0 | 21009.72 ± 0.1% | not timed | not timed | 619.14 ± 0.2% | 74.98 ± 0.1% | not timed | not timed | 21152.90 ± 0.1% | | 0.99 | 33.93 | 280.21 |
| opt/reverse-inner/no-quadratic-forward | 0 | 724.54 ± 3.7% | not timed | not timed | 287.33 ± 0.7% | 24.70 ± 0.0% | not timed | not timed | 735.19 ± 2.0% | | 0.99 | 2.52 | 29.34 |
| opt/reverse-suffix/holmes | 4073 | 10223.84 ± 0.6% | not timed | not timed | 8445.76 ± 0.3% | 24.03 ± 1.3% | not timed | not timed | 10220.36 ± 0.4% | | 1.00 | 1.21 | 425.52 |
| opt/reverse-suffix/no-quadratic | 0 | 21064.48 ± 0.1% | not timed | not timed | 611.35 ± 0.4% | 74.94 ± 0.2% | not timed | not timed | 21147.95 ± 0.1% | | 1.00 | 34.46 | 281.10 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.87 ± 1.7% | not timed | not timed | 130.49 ± 0.1% | 12.90 ± 15.7% | not timed | not timed | 120.72 ± 2.9% | | 1.00 | 0.93 | 9.37 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.84 ± 2.9% | not timed | not timed | 133.02 ± 0.1% | 13.00 ± 14.9% | not timed | not timed | 121.10 ± 2.1% | | 1.00 | 0.91 | 9.30 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.3% | not timed | not timed | 0.55 ± 0.1% | 113.31 ± 0.4% | not timed | not timed | 0.28 ± 0.2% | | 0.99 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 320.16 ± 0.2% | not timed | not timed | 294.33 ± 0.1% | 103.68 ± 0.2% | not timed | not timed | 321.94 ± 0.1% | | 0.99 | 1.09 | 3.09 |
| reported/i13-subset-regex/original-ascii | 4094 | 11255.50 ± 2.0% | not timed | not timed | 4520.91 ± 1.1% | 11.51 ± 0.1% | not timed | not timed | 11240.30 ± 1.7% | | 1.00 | 2.49 | 978.02 |
| reported/i13-subset-regex/original-unicode | 4094 | 11076.73 ± 2.6% | not timed | not timed | 250.42 ± 3.4% | 11.51 ± 1.6% | not timed | not timed | 11250.80 ± 1.2% | | 0.98 | 44.23 | 962.33 |
| reported/i13-subset-regex/big-ascii | 1955 | 10657.17 ± 1.3% | not timed | not timed | 67.75 ± 3.6% | 9.86 ± 0.2% | not timed | not timed | 10763.06 ± 0.8% | | 0.99 | 157.30 | 1081.06 |
| reported/i13-subset-regex/big-unicode | 1955 | 10623.05 ± 2.0% | not timed | not timed | 12.27 ± 54.9% | 9.81 ± 0.1% | not timed | not timed | 10761.40 ± 1.4% | | 0.99 | 865.64 | 1082.62 |
| reported/i13-subset-regex/huge-ascii | 55 | 9916.01 ± 2.8% | not timed | not timed | 11.05 ± 0.1% | 8.77 ± 0.1% | not timed | not timed | 9901.89 ± 3.4% | | 1.00 | 897.57 | 1130.09 |
| reported/i13-subset-regex/huge-unicode | 55 | 9902.97 ± 3.2% | not timed | not timed | 10.97 ± 0.4% | 8.76 ± 0.4% | not timed | not timed | 9823.09 ± 4.4% | | 1.01 | 902.81 | 1130.45 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.53 ± 0.1% | not timed | not timed | 11.06 ± 0.1% | 8.77 ± 1.4% | not timed | not timed | 3.53 ± 0.1% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.97 ± 0.3% | not timed | not timed | 10.98 ± 0.3% | 8.77 ± 0.2% | not timed | not timed | 4.97 ± 0.1% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 483.13 ± 0.4% | not timed | not timed | 104.28 ± 0.2% | 6.62 ± 0.2% | not timed | not timed | 484.76 ± 0.3% | | 1.00 | 4.63 | 73.00 |
| reported/i787-keywords/opt-ascii | 5674 | 484.60 ± 0.2% | not timed | not timed | 273.49 ± 0.1% | 10.28 ± 0.1% | not timed | not timed | 483.86 ± 0.2% | | 1.00 | 1.77 | 47.13 |
| slow/quadratic-regex-1x | 100 | 7.09 ± 0.6% | not timed | not timed | 4.96 ± 0.2% | 0.05 ± 0.4% | not timed | not timed | 7.15 ± 0.4% | | 0.99 | 1.43 | 143.70 |
| slow/quadratic-regex-2x | 199 | 3.42 ± 0.1% | not timed | not timed | 2.76 ± 0.1% | 0.01 ± 10.7% | not timed | not timed | 3.43 ± 1.5% | | 1.00 | 1.24 | 269.24 |
| slow/quadratic-haystack-1x | 100 | 22.11 ± 1.6% | not timed | not timed | 9.97 ± 0.2% | 1.01 ± 9.0% | not timed | not timed | 22.04 ± 6.3% | | 1.00 | 2.22 | 21.83 |
| slow/quadratic-haystack-2x | 200 | 19.82 ± 1.0% | not timed | not timed | 5.53 ± 0.3% | 0.54 ± 12.6% | not timed | not timed | 19.72 ± 1.6% | | 1.01 | 3.58 | 36.45 |
| unicode/codepoints/any-one | 1112064 | 282.32 ± 0.3% | not timed | not timed | 177.00 ± 0.2% | 18.30 ± 2.6% | not timed | not timed | 282.04 ± 0.4% | | 1.00 | 1.59 | 15.43 |
| unicode/codepoints/any-all | 4382592 | 283.24 ± 0.9% | not timed | not timed | 246.64 ± 0.2% | 116.44 ± 0.1% | not timed | not timed | 282.27 ± 0.4% | | 1.00 | 1.15 | 2.43 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.78 ± 0.6% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 603.43 ± 0.7% | not timed | not timed | 616.09 ± 0.2% | 135.30 ± 0.2% | not timed | not timed | 603.81 ± 0.4% | | 1.00 | 0.98 | 4.46 |
| unicode/overlapping-words/ascii | 6156 | 31.74 ± 0.2% | not timed | not timed | 38.95 ± 0.0% | 3.93 ± 1.4% | not timed | not timed | 31.83 ± 0.4% | | 1.00 | 0.82 | 8.09 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.1% | not timed | not timed | 3.25 ± 0.8% | 2.35 ± 0.2% | not timed | not timed | 1.43 ± 0.4% | | 1.01 | 0.44 | 0.61 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.8% | not timed | not timed | 3.02 ± 1.3% | 6.30 ± 10.2% | not timed | not timed | 1.27 ± 0.1% | | 1.01 | 0.42 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 125.78 ± 9.5% | not timed | not timed | 82.77 ± 0.1% | 11.76 ± 20.9% | not timed | not timed | 129.95 ± 0.8% | | 0.97 | 1.52 | 10.69 |
| unicode/word/boundary-long-english | 3466 | 608.79 ± 0.2% | not timed | not timed | 605.72 ± 0.1% | 32.80 ± 0.5% | not timed | not timed | 608.37 ± 0.4% | | 1.00 | 1.01 | 18.56 |
| unicode/word/around-holmes-english | 27 | 19639.07 ± 0.7% | not timed | not timed | 19430.43 ± 0.2% | 22.05 ± 1.2% | not timed | not timed | 19688.72 ± 0.8% | | 1.00 | 1.01 | 890.75 |
| wild/bibleref/long | 874 | 566.33 ± 0.2% | not timed | not timed | 584.01 ± 0.1% | 6.71 ± 0.2% | not timed | not timed | 569.01 ± 0.2% | | 1.00 | 0.97 | 84.46 |
| wild/bibleref/short | 30 | 25.38 ± 2.0% | not timed | not timed | 31.41 ± 0.8% | 14.48 ± 15.1% | not timed | not timed | 26.08 ± 7.9% | | 0.97 | 0.81 | 1.75 |
| wild/bibleref/line | 874 | 394.85 ± 1.8% | not timed | not timed | 218.24 ± 0.1% | 9.21 ± 8.5% | not timed | not timed | 396.40 ± 0.1% | | 1.00 | 1.81 | 42.88 |
| wild/caddy/caddy | 6 | 421.75 ± 2.2% | not timed | not timed | 242.17 ± 0.2% | 68.47 ± 14.4% | not timed | not timed | 422.50 ± 0.4% | | 1.00 | 1.74 | 6.16 |
| wild/dot-star-capture/rust-src-tools | 6 | 1070.90 ± 0.5% | not timed | not timed | 348.07 ± 0.4% | 13.53 ± 0.2% | not timed | not timed | 1064.86 ± 0.5% | | 1.01 | 3.08 | 79.13 |
| wild/ruff/noqa | 84 | 437.70 ± 0.1% | not timed | not timed | 479.71 ± 0.1% | 19.73 ± 2.1% | not timed | not timed | 437.28 ± 0.1% | | 1.00 | 0.91 | 22.19 |
| wild/ruff/unnecessary-coding-comment | 16 | 956.99 ± 0.3% | not timed | not timed | 700.26 ± 0.4% | 135.83 ± 11.2% | not timed | not timed | 961.65 ± 0.5% | | 1.00 | 1.37 | 7.05 |
| wild/ruff/string-quote-prefix | 2972 | 1365.40 ± 0.7% | not timed | not timed | 441.08 ± 0.2% | 313.31 ± 25.4% | not timed | not timed | 1365.33 ± 0.7% | | 1.00 | 3.10 | 4.36 |
| wild/ruff/space-around-operator | 1224378 | 222.28 ± 1.9% | not timed | not timed | 187.06 ± 0.2% | 18.36 ± 1.7% | not timed | not timed | 223.20 ± 1.8% | | 1.00 | 1.19 | 12.10 |
| wild/ruff/shebang | 282 | 971.88 ± 0.4% | not timed | not timed | 329.47 ± 0.1% | 111.30 ± 11.9% | not timed | not timed | 974.43 ± 0.5% | | 1.00 | 2.95 | 8.73 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13798.55 ± 0.5% | not timed | not timed | 13792.62 ± 0.8% | 6937.85 ± 1.7% | not timed | not timed | 13836.09 ± 0.2% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12822.24 ± 0.7% | not timed | not timed | 13458.35 ± 0.4% | 6405.57 ± 0.3% | not timed | not timed | 12851.41 ± 0.3% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13222.49 ± 1.4% | not timed | not timed | 13638.89 ± 0.5% | 6612.64 ± 0.6% | not timed | not timed | 13231.50 ± 0.4% | | 1.00 | 0.97 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9577.67 ± 0.4% | not timed | not timed | 13594.88 ± 0.8% | 6709.54 ± 0.5% | not timed | not timed | 9576.68 ± 0.5% | | 1.00 | 0.70 | 1.43 |
| wild/url/search | 234965 | 121.58 ± 13.7% | not timed | not timed | 65.84 ± 0.3% | 2.21 ± 0.6% | not timed | not timed | 120.79 ± 13.8% | | 1.01 | 1.85 | 54.97 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 1.7% | not timed | not timed | 0.01 ± 2.0% | 0.01 ± 28.5% | not timed | not timed | 0.03 ± 42.0% | | 1.00 | 3.07 | 3.98 |
| dictionary/compile/english-15 | 1 | 0.34 ± 23.1% | not timed | not timed | 0.07 ± 0.3% | 0.10 ± 11.0% | not timed | not timed | 0.35 ± 1.2% | | 0.98 | 4.88 | 3.33 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 15.0% | not timed | not timed | 0.02 ± 0.5% | 35.01 ± 4.0% | not timed | not timed | 0.24 ± 1.1% | | 0.98 | 12.58 | 0.0068 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.27 ± 2.2% | not timed | not timed | 11.57 ± 0.2% | 59.52 ± 21.3% | not timed | not timed | 46.74 ± 2.3% | | 0.99 | 4.00 | 0.78 |
| reported/i787-keywords/compile | 1 | 34.63 ± 18.3% | not timed | not timed | 2.13 ± 0.8% | 16.29 ± 15.1% | not timed | not timed | 35.02 ± 16.2% | | 0.99 | 16.26 | 2.13 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 339.03 ± 9.4% | not timed | not timed | 119.17 ± 0.3% | 561.54 ± 21.8% | not timed | not timed | 344.73 ± 8.1% | | 0.98 | 2.85 | 0.60 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 46.85 ± 23.5% | not timed | not timed | 4.12 ± 0.8% | 44.87 ± 5.3% | not timed | not timed | 47.29 ± 2.1% | | 0.99 | 11.36 | 1.04 |
| unicode/compile/one-letter | 53 | 6.67 ± 11.4% | not timed | not timed | 4.57 ± 0.6% | 65.30 ± 4.6% | not timed | not timed | 6.72 ± 15.5% | | 0.99 | 1.46 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.01 ± 17.6% | not timed | not timed | 0.10 ± 0.5% | 66.44 ± 9.1% | not timed | not timed | 1.08 ± 11.9% | | 0.93 | 10.16 | 0.0151 |
| unicode/compile/fifty-letters-ascii | 1 | 212.15 ± 11.7% | not timed | not timed | 52.38 ± 0.3% | 200.17 ± 12.9% | not timed | not timed | 214.39 ± 13.1% | | 0.99 | 4.05 | 1.06 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 359.89 ± 12.1% | not timed | not timed | 47.17 ± 0.2% | 676.07 ± 26.9% | not timed | not timed | 368.13 ± 18.9% | | 0.98 | 7.63 | 0.53 |
| unicode/compile/match-every-line-ascii | 4 | 566.00 ± 14.3% | not timed | not timed | 144.89 ± 0.3% | 660.91 ± 14.4% | not timed | not timed | 582.54 ± 20.5% | | 0.97 | 3.91 | 0.86 |
| unicode/compile/negated-class-matches-codepoint | 1 | 302.54 ± 12.6% | not timed | not timed | 51.35 ± 0.3% | 1250.51 ± 24.6% | not timed | not timed | 308.10 ± 9.9% | | 0.98 | 5.89 | 0.24 |
| wild/bibleref/compile | 3 | 5.87 ± 1.6% | not timed | not timed | 1.91 ± 0.7% | 30.74 ± 4.9% | not timed | not timed | 5.89 ± 1.4% | | 1.00 | 3.08 | 0.19 |
| wild/url/compile | 1 | 0.62 ± 15.4% | not timed | not timed | 0.14 ± 0.6% | 0.41 ± 34.0% | not timed | not timed | 0.63 ± 3.7% | | 1.00 | 4.33 | 1.54 |

