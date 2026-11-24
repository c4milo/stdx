# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391553475 |
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
| literal: a word | 217 | 19902.49 ± 2.6% | 5043.58 ± 0.3% | 28.12 ± 0.3% | 18545.18 ± 1.8% | 9283.52 ± 9.2% | 17.32 ± 0.3% | 84.17 ± 1.6% | 19917.68 ± 1.2% | 3.95 | 1.00 | 1.07 | 2.14 |
| literal: a word that is not there | 0 | 22092.97 ± 1.6% | 4930.48 ± 0.3% | 28.24 ± 0.5% | 20067.15 ± 1.6% | 29677.97 ± 1.0% | 17.09 ± 0.3% | 79.40 ± 0.7% | 22000.01 ± 2.5% | 4.48 | 1.00 | 1.10 | 0.74 |
| literal: one of four words | 661 | 6357.46 ± 0.1% | 1948.04 ± 0.3% | 14.35 ± 0.2% | 3946.48 ± 0.1% | 21.89 ± 0.1% | 5.36 ± 0.2% | 6.87 ± 0.6% | 6365.83 ± 0.3% | 3.26 | 1.00 | 1.61 | 290.48 |
| literal: a word in any case | 217 | 15203.22 ± 0.9% | 2086.86 ± 0.2% | 21.31 ± 0.1% | 3977.91 ± 0.1% | 37.99 ± 3.3% | refused | differs | 15192.86 ± 0.3% | 7.29 | 1.00 | 3.82 | 400.18 |
| literal: an href attribute | 33 | 17022.75 ± 2.1% | 609.54 ± 0.2% | 27.17 ± 0.1% | 16957.15 ± 1.7% | 2260.82 ± 5.4% | 13.15 ± 0.4% | 73.84 ± 0.2% | 16981.65 ± 1.2% | 27.93 | 1.00 | 1.00 | 7.53 |
| literal: a word, second text | 123 | 19815.66 ± 2.1% | 3385.57 ± 0.2% | 27.71 ± 0.4% | 18405.11 ± 1.9% | 7594.60 ± 4.5% | 20.12 ± 0.5% | 69.58 ± 0.5% | 19870.20 ± 1.8% | 5.85 | 1.00 | 1.08 | 2.61 |
| class: two capitalized words | 1331 | 1071.00 ± 0.5% | 598.73 ± 0.2% | 25.98 ± 0.3% | 585.45 ± 0.1% | 40.64 ± 2.8% | 14.73 ± 0.4% | 67.42 ± 0.2% | 1070.37 ± 0.4% | 1.79 | 1.00 | 1.83 | 26.35 |
| class: a word that ends in ing | 3399 | 573.84 ± 0.2% | 573.05 ± 0.3% | 17.95 ± 0.4% | 547.46 ± 0.3% | 29.63 ± 12.8% | 8.15 ± 0.3% | 18.43 ± 0.4% | 573.79 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.37 |
| class: a word in capitals | 2332 | 1378.02 ± 0.1% | 604.84 ± 0.3% | 27.53 ± 0.3% | 572.50 ± 0.1% | 43.57 ± 0.2% | 17.18 ± 0.3% | 82.57 ± 0.3% | 1381.20 ± 0.3% | 2.28 | 1.00 | 2.41 | 31.63 |
| class: a number | 8288 | 1999.66 ± 0.3% | 828.42 ± 0.1% | 27.57 ± 0.6% | 1730.65 ± 0.3% | 41.05 ± 8.6% | 0.55 ± 0.2% | 57.39 ± 0.1% | 2001.03 ± 0.3% | 2.41 | 1.00 | 1.16 | 48.72 |
| class: two capitalized words, second text | 5359 | 515.83 ± 0.3% | 523.71 ± 0.1% | 23.36 ± 0.2% | 485.46 ± 0.2% | 31.22 ± 12.5% | 17.11 ± 0.3% | 62.89 ± 0.3% | 516.17 ± 0.4% | 0.98 | 1.00 | 1.06 | 16.52 |
| other: a word between two words | 6104 | 788.45 ± 0.1% | 592.60 ± 0.1% | 23.50 ± 0.2% | 737.36 ± 0.1% | 101.98 ± 17.7% | 11.17 ± 0.1% | 68.21 ± 0.3% | 788.56 ± 0.1% | 1.33 | 1.00 | 1.07 | 7.73 |
| other: a number before a unit, second text | 1481 | 5948.81 ± 0.9% | 1120.45 ± 0.3% | 25.93 ± 0.3% | 5679.26 ± 0.7% | 40.79 ± 11.2% | 18.20 ± 0.2% | 65.80 ± 0.2% | 5973.50 ± 0.8% | 5.31 | 1.00 | 1.05 | 145.85 |
| other: a heading's start tag | 110 | 14073.58 ± 1.3% | 743.99 ± 0.1% | 27.28 ± 0.2% | 1710.77 ± 0.4% | 1575.04 ± 0.8% | 16.08 ± 0.7% | 86.03 ± 0.3% | 14148.11 ± 0.5% | 18.92 | 0.99 | 8.23 | 8.94 |
| other: a whole word | 217 | 15981.47 ± 1.9% | 601.99 ± 0.6% | 29.26 ± 0.2% | 14473.36 ± 0.8% | 49.33 ± 7.0% | 13.23 ± 0.4% | 54.98 ± 0.3% | 16098.66 ± 1.6% | 26.55 | 0.99 | 1.10 | 323.96 |
| other: a line's first word, second text | 3716 | 2044.43 ± 0.3% | 587.42 ± 0.2% | 30.92 ± 0.4% | 1723.07 ± 0.4% | 62.96 ± 4.9% | refused | refused | 2047.35 ± 0.3% | 3.48 | 1.00 | 1.19 | 32.47 |
| other: fourteen octets before an x | 87 | 24201.02 ± 1.8% | 247.06 ± 0.5% | 6.31 ± 0.1% | 3949.51 ± 1.2% | 10.62 ± 0.2% | differs | 17.76 ± 0.2% | 24367.47 ± 6.3% | 97.96 | 0.99 | 6.13 | 2278.96 |
| other: a Greek word | 21815 | 496.88 ± 0.2% | 412.71 ± 0.3% | 30.60 ± 0.3% | 289.55 ± 0.1% | 49.15 ± 11.0% | differs | refused | 501.12 ± 0.3% | 1.20 | 0.99 | 1.72 | 10.11 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.52 ± 0.3% | 19.54 ± 0.4% | 0.85 ± 0.3% | 19.77 ± 0.2% | 2.76 ± 0.6% | differs | 4.07 ± 0.2% | 19.56 ± 0.3% | 1.00 | 1.00 | 0.99 | 7.08 |
| a UUID | 32895 | 21.15 ± 0.1% | 21.12 ± 0.1% | 0.64 ± 0.2% | 15.01 ± 0.4% | 3.11 ± 0.3% | 0.73 ± 0.3% | 3.65 ± 1.2% | 21.11 ± 0.2% | 1.00 | 1.00 | 1.41 | 6.80 |
| an IPv4 address | 33176 | 36.08 ± 0.2% | 36.03 ± 0.1% | 2.05 ± 0.2% | 29.38 ± 0.5% | 6.67 ± 0.1% | differs | 4.18 ± 0.3% | 36.05 ± 0.2% | 1.00 | 1.00 | 1.23 | 5.41 |
| a date and time | 32954 | 31.05 ± 0.3% | 31.03 ± 0.3% | 1.43 ± 0.4% | 21.44 ± 0.4% | 7.00 ± 0.2% | 1.26 ± 0.3% | 7.16 ± 0.2% | 31.07 ± 0.3% | 1.00 | 1.00 | 1.45 | 4.43 |
| a field path | 32606 | 23.19 ± 0.2% | 23.14 ± 0.3% | 1.01 ± 0.3% | 23.19 ± 0.4% | 3.49 ± 1.1% | differs | 2.98 ± 0.2% | 23.13 ± 0.2% | 1.00 | 1.00 | 1.00 | 6.66 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.18 ± 0.4% | 11.09 ± 0.5% | 11.14 ± 0.5% | 11.55 ± 0.2% | 4.97 ± 0.8% | 0.94 ± 0.3% | none | 11.05 ± 0.5% | 1.01 | 1.01 | 0.97 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 230.76 ± 0.2% | 231.69 ± 0.2% | 273.29 ± 0.1% | 86.69 ± 0.6% | 220.83 ± 1.0% | 479.91 ± 1.1% | 3739.49 ± 0.3% | 230.84 ± 0.2% | 1.00 | 1.00 | 2.66 | 1.04 |
| a UUID | 62 | 151.94 ± 0.2% | 152.45 ± 0.2% | 169.42 ± 0.2% | 46.40 ± 1.0% | 99.49 ± 1.6% | 190.32 ± 2.2% | 4095.21 ± 0.9% | 151.95 ± 0.3% | 1.00 | 1.00 | 3.27 | 1.53 |
| an IPv4 address | 29 | 427.30 ± 0.4% | 431.66 ± 0.3% | 598.99 ± 0.4% | 77.81 ± 0.9% | 131.38 ± 1.9% | 297.90 ± 0.9% | 7242.51 ± 0.6% | 428.02 ± 0.2% | 0.99 | 1.00 | 5.49 | 3.25 |
| a date and time | 56 | 307.23 ± 0.3% | 310.25 ± 0.1% | 387.64 ± 0.2% | 73.27 ± 0.2% | 136.83 ± 1.5% | 326.62 ± 2.9% | 4695.81 ± 0.9% | 307.32 ± 0.4% | 0.99 | 1.00 | 4.19 | 2.25 |
| a field path | 39 | 223.35 ± 0.2% | 224.58 ± 0.3% | 262.93 ± 0.3% | 80.12 ± 2.4% | 204.54 ± 0.7% | 509.58 ± 3.8% | 4773.91 ± 2.9% | 223.53 ± 0.3% | 0.99 | 1.00 | 2.79 | 1.09 |
| literal: a word | 7 | 633.01 ± 1.3% | 685.92 ± 0.6% | 1229.76 ± 0.9% | 518.57 ± 0.3% | 632.14 ± 1.2% | 970.28 ± 0.3% | 30843.55 ± 0.3% | 634.25 ± 0.4% | 0.92 | 1.00 | 1.22 | 1.00 |
| literal: a word that is not there | 8 | 610.81 ± 0.5% | 663.55 ± 0.2% | 1162.32 ± 0.7% | 472.93 ± 0.7% | 602.23 ± 2.5% | 914.82 ± 0.7% | 29455.23 ± 0.2% | 610.25 ± 0.4% | 0.92 | 1.00 | 1.29 | 1.01 |
| literal: one of four words | 26 | 245.76 ± 0.1% | 398.86 ± 0.4% | 543.55 ± 0.4% | 49.66 ± 0.8% | 241.94 ± 1.7% | 367.44 ± 0.6% | 16165.17 ± 0.2% | 245.74 ± 0.4% | 0.62 | 1.00 | 4.95 | 1.02 |
| literal: a word in any case | 11 | 452.09 ± 0.3% | 483.67 ± 0.2% | 712.46 ± 0.1% | 15.46 ± 0.3% | 649.53 ± 2.9% | refused | 23091.96 ± 0.5% | 452.31 ± 0.4% | 0.93 | 1.00 | 29.25 | 0.70 |
| literal: an href attribute | 12 | 347.47 ± 0.3% | 359.82 ± 0.3% | 470.71 ± 0.4% | 44.97 ± 0.3% | 497.00 ± 2.0% | 777.41 ± 0.9% | 22166.39 ± 0.4% | 347.44 ± 0.3% | 0.97 | 1.00 | 7.73 | 0.70 |
| literal: a word, second text | 10 | 563.82 ± 0.8% | 624.13 ± 0.7% | 1041.63 ± 0.7% | 431.14 ± 2.0% | 537.50 ± 1.4% | 798.48 ± 0.8% | 27605.35 ± 0.3% | 564.51 ± 0.7% | 0.90 | 1.00 | 1.31 | 1.05 |
| class: two capitalized words | 23 | 438.73 ± 0.4% | 470.53 ± 0.3% | 674.19 ± 0.4% | 101.34 ± 0.1% | 505.34 ± 0.8% | 740.63 ± 0.2% | 6481.27 ± 0.3% | 438.68 ± 0.3% | 0.93 | 1.00 | 4.33 | 0.87 |
| class: a word that ends in ing | 9 | 569.96 ± 0.4% | 637.65 ± 0.3% | 1117.14 ± 0.3% | 134.28 ± 1.5% | 758.39 ± 0.9% | 1145.05 ± 0.8% | 15997.41 ± 1.5% | 569.85 ± 0.2% | 0.89 | 1.00 | 4.24 | 0.75 |
| class: a word in capitals | 16 | 495.70 ± 0.3% | 538.49 ± 0.4% | 851.28 ± 0.2% | 138.11 ± 1.0% | 753.84 ± 1.3% | 1051.13 ± 0.7% | 8557.83 ± 0.6% | 495.94 ± 0.1% | 0.92 | 1.00 | 3.59 | 0.66 |
| class: a number | 6 | 633.27 ± 0.1% | 695.60 ± 0.2% | 1299.92 ± 0.1% | 42.15 ± 0.8% | 1404.92 ± 1.4% | 1860.83 ± 1.0% | 22680.26 ± 0.1% | 633.07 ± 0.2% | 0.91 | 1.00 | 15.02 | 0.45 |
| class: two capitalized words, second text | 23 | 438.96 ± 0.3% | 471.10 ± 0.4% | 673.31 ± 0.4% | 101.08 ± 0.4% | 504.55 ± 1.9% | 739.23 ± 1.0% | 6480.42 ± 0.7% | 439.08 ± 0.4% | 0.93 | 1.00 | 4.34 | 0.87 |
| other: a word between two words | 13 | 550.49 ± 0.6% | 570.50 ± 0.6% | 905.44 ± 0.9% | 133.07 ± 0.2% | 500.77 ± 3.3% | 809.95 ± 0.2% | 14661.31 ± 0.7% | 550.22 ± 0.4% | 0.96 | 1.00 | 4.14 | 1.10 |
| other: a number before a unit, second text | 15 | 401.92 ± 0.2% | 441.12 ± 0.3% | 617.83 ± 0.1% | 39.58 ± 1.1% | 637.95 ± 1.0% | 900.37 ± 1.1% | 15158.82 ± 12.8% | 402.60 ± 0.4% | 0.91 | 1.00 | 10.15 | 0.63 |
| other: a heading's start tag | 13 | 360.43 ± 0.7% | 367.70 ± 0.8% | 482.44 ± 0.4% | 44.87 ± 0.2% | 619.98 ± 7.3% | 865.45 ± 1.6% | 18298.00 ± 0.4% | 360.55 ± 0.4% | 0.98 | 1.00 | 8.03 | 0.58 |
| other: a whole word | 11 | 581.74 ± 0.3% | 620.58 ± 0.5% | 1041.40 ± 0.3% | 120.68 ± 1.3% | 557.24 ± 4.0% | 843.50 ± 1.8% | 27314.47 ± 0.2% | 582.61 ± 0.6% | 0.94 | 1.00 | 4.82 | 1.04 |
| other: a line's first word, second text | 17 | 530.31 ± 0.6% | 556.61 ± 0.2% | 889.95 ± 0.2% | 129.50 ± 0.3% | 712.20 ± 1.3% | refused | refused | 531.44 ± 0.2% | 0.95 | 1.00 | 4.10 | 0.74 |
| other: fourteen octets before an x | 16 | 109.98 ± 0.8% | 158.27 ± 0.7% | 180.96 ± 0.4% | 15.09 ± 0.6% | 449.78 ± 1.5% | 417.93 ± 1.3% | 12883.14 ± 2.6% | 110.20 ± 0.9% | 0.69 | 1.00 | 7.29 | 0.24 |
| other: a Greek word | 8 | 455.58 ± 0.2% | 605.15 ± 0.1% | 1018.29 ± 0.1% | 59.38 ± 0.7% | 1379.24 ± 1.6% | 1761.69 ± 0.5% | refused | 455.43 ± 0.2% | 0.75 | 1.00 | 7.67 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15643.56 ± 0.8% | not timed | not timed | 16131.14 ± 0.7% | 2012.22 ± 14.6% | not timed | not timed | 15654.03 ± 0.6% | | 1.00 | 0.97 | 7.77 |
| 01-literal/sherlock-casei-en | 522 | 11050.49 ± 7.5% | not timed | not timed | 3586.83 ± 0.5% | 32.52 ± 0.2% | not timed | not timed | 11039.10 ± 1.5% | | 1.00 | 3.08 | 339.83 |
| 01-literal/sherlock-ru | 724 | 17125.27 ± 0.6% | not timed | not timed | 17253.88 ± 0.3% | 1517.58 ± 8.2% | not timed | not timed | 17156.71 ± 0.4% | | 1.00 | 0.99 | 11.28 |
| 01-literal/sherlock-casei-ru | 746 | 6182.22 ± 0.4% | not timed | not timed | 3323.71 ± 0.2% | 30.72 ± 0.7% | not timed | not timed | 6177.43 ± 0.1% | | 1.00 | 1.86 | 201.24 |
| 01-literal/sherlock-zh | 30 | 19991.05 ± 1.1% | not timed | not timed | 18902.72 ± 1.1% | 2640.93 ± 4.3% | not timed | not timed | 20005.00 ± 0.6% | | 1.00 | 1.06 | 7.57 |
| 02-literal-alternate/sherlock-en | 714 | 6047.77 ± 0.4% | not timed | not timed | 3943.54 ± 0.2% | 16.64 ± 0.1% | not timed | not timed | 6052.50 ± 0.5% | | 1.00 | 1.53 | 363.52 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1980.31 ± 1.5% | not timed | not timed | 698.82 ± 0.3% | 11.12 ± 2.6% | not timed | not timed | 1985.56 ± 0.7% | | 1.00 | 2.83 | 178.16 |
| 02-literal-alternate/sherlock-ru | 899 | 5562.90 ± 0.2% | not timed | not timed | 3251.86 ± 0.1% | 22.60 ± 0.1% | not timed | not timed | 5570.67 ± 0.3% | | 1.00 | 1.71 | 246.09 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2054.14 ± 0.6% | not timed | not timed | 1227.16 ± 0.1% | 9.11 ± 0.1% | not timed | not timed | 2057.36 ± 0.4% | | 1.00 | 1.67 | 225.40 |
| 02-literal-alternate/sherlock-zh | 207 | 7319.66 ± 0.2% | not timed | not timed | 4161.43 ± 0.2% | 31.47 ± 0.2% | not timed | not timed | 7314.74 ± 0.2% | | 1.00 | 1.76 | 232.58 |
| 03-date/ascii | 111817 | 123.77 ± 0.8% | not timed | not timed | 88.42 ± 0.1% | 0.20 ± 4.7% | not timed | not timed | 124.54 ± 0.6% | | 0.99 | 1.40 | 614.06 |
| 04-ruff-noqa/real | 84 | 404.24 ± 0.1% | not timed | not timed | 468.09 ± 0.1% | 19.56 ± 1.5% | not timed | not timed | 403.49 ± 0.1% | | 1.00 | 0.86 | 20.67 |
| 04-ruff-noqa/tweaked | 44 | 555.01 ± 0.6% | not timed | not timed | 463.87 ± 0.1% | 365.31 ± 0.3% | not timed | not timed | 556.16 ± 0.4% | | 1.00 | 1.20 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.51 ± 1.4% | not timed | not timed | 5.22 ± 0.4% | 0.20 ± 3.6% | not timed | not timed | 5.40 ± 0.6% | | 1.02 | 1.06 | 27.43 |
| 06-cloud-flare-redos/original | 107 | 415.23 ± 0.2% | not timed | not timed | 213.28 ± 0.0% | 24.93 ± 0.4% | not timed | not timed | 416.12 ± 0.1% | | 1.00 | 1.95 | 16.65 |
| 06-cloud-flare-redos/simplified-short | 102 | 415.68 ± 0.1% | not timed | not timed | 224.23 ± 0.1% | 26.79 ± 0.1% | not timed | not timed | 410.61 ± 0.2% | | 1.01 | 1.85 | 15.52 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.96 ± 0.2% | not timed | not timed | 253.67 ± 0.1% | 28.83 ± 0.1% | not timed | not timed | 578.26 ± 0.1% | | 1.02 | 2.32 | 20.39 |
| 07-unicode-character-data/parse-line | 558784 | 237.38 ± 1.7% | not timed | not timed | 181.52 ± 0.1% | 42.10 ± 6.4% | not timed | not timed | 239.02 ± 0.4% | | 0.99 | 1.31 | 5.64 |
| 08-words/all-english | 56691 | 116.65 ± 0.5% | not timed | not timed | 75.74 ± 0.2% | 11.63 ± 3.8% | not timed | not timed | 116.78 ± 0.5% | | 1.00 | 1.54 | 10.03 |
| 08-words/long-english | 839 | 615.53 ± 0.6% | not timed | not timed | 595.41 ± 0.2% | 32.55 ± 1.1% | not timed | not timed | 614.53 ± 0.5% | | 1.00 | 1.03 | 18.91 |
| 09-aws-keys/full | 0 | 408.01 ± 0.3% | not timed | not timed | 475.67 ± 0.1% | 64.55 ± 0.1% | not timed | not timed | 408.87 ± 0.1% | | 1.00 | 0.86 | 6.32 |
| 09-aws-keys/quick | 0 | 872.59 ± 0.2% | not timed | not timed | 998.42 ± 0.7% | 415.72 ± 0.8% | not timed | not timed | 873.44 ± 0.2% | | 1.00 | 0.87 | 2.10 |
| 10-bounded-repeat/letters-en | 1833 | 580.78 ± 1.9% | not timed | not timed | 516.68 ± 1.1% | 19.50 ± 0.3% | not timed | not timed | 583.65 ± 2.2% | | 1.00 | 1.12 | 29.78 |
| 10-bounded-repeat/letters-ru | 3475 | 508.18 ± 1.5% | not timed | not timed | 478.56 ± 0.1% | 21.87 ± 17.4% | not timed | not timed | 510.74 ± 0.3% | | 0.99 | 1.06 | 23.24 |
| 10-bounded-repeat/context | 53 | 85.58 ± 1.6% | not timed | not timed | 66.11 ± 0.2% | 19.85 ± 0.2% | not timed | not timed | 85.37 ± 1.5% | | 1.00 | 1.29 | 4.31 |
| 10-bounded-repeat/capitals | 11 | 641.74 ± 8.0% | not timed | not timed | 618.22 ± 0.3% | 36.60 ± 0.1% | not timed | not timed | 641.02 ± 8.0% | | 1.00 | 1.04 | 17.53 |
| 11-unstructured-to-json/extract | 600 | 56.68 ± 1.0% | not timed | not timed | 76.45 ± 0.2% | 49.08 ± 1.0% | not timed | not timed | 56.77 ± 0.8% | | 1.00 | 0.74 | 1.15 |
| 12-dictionary/single | 1 | 567.48 ± 0.2% | not timed | not timed | 560.70 ± 0.2% | 0.40 ± 0.1% | not timed | not timed | 568.96 ± 0.2% | | 1.00 | 1.01 | 1408.07 |
| 14-quadratic/1x | 100 | 21.14 ± 0.6% | not timed | not timed | 10.01 ± 0.2% | 0.96 ± 2.7% | not timed | not timed | 21.18 ± 0.7% | | 1.00 | 2.11 | 22.04 |
| 14-quadratic/2x | 200 | 17.50 ± 0.9% | not timed | not timed | 5.53 ± 0.1% | 0.53 ± 0.6% | not timed | not timed | 17.46 ± 1.2% | | 1.00 | 3.16 | 32.88 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.4% | not timed | not timed | 1.21 ± 0.1% | 0.11 ± 1.7% | not timed | not timed | 7.69 ± 0.3% | | 1.00 | 6.34 | 66.91 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 2.1% | not timed | not timed | 0.34 ± 0.4% | 0.55 ± 2.8% | not timed | not timed | 1.28 ± 0.3% | | 1.00 | 3.70 | 2.30 |
| 04-ruff-noqa/compile-real | 1 | 107.09 ± 1.7% | not timed | not timed | 13.77 ± 0.5% | 139.10 ± 1.7% | not timed | not timed | 107.07 ± 1.6% | | 1.00 | 7.77 | 0.77 |
| 05-lexer-veryl/compile-single | 1 | 14.13 ± 0.4% | not timed | not timed | 2.54 ± 1.6% | 6.42 ± 3.1% | not timed | not timed | 14.19 ± 0.3% | | 1.00 | 5.57 | 2.20 |
| 07-unicode-character-data/compile | 1 | 109.76 ± 1.0% | not timed | not timed | 25.94 ± 0.3% | 35.68 ± 2.4% | not timed | not timed | 110.19 ± 0.6% | | 1.00 | 4.23 | 3.08 |
| 09-aws-keys/compile-full | 1 | 53.55 ± 1.2% | not timed | not timed | 8.30 ± 0.6% | 23.09 ± 1.8% | not timed | not timed | 53.64 ± 0.4% | | 1.00 | 6.45 | 2.32 |
| 09-aws-keys/compile-quick | 1 | 189.48 ± 1.5% | not timed | not timed | 47.28 ± 0.3% | 131.58 ± 2.5% | not timed | not timed | 189.88 ± 0.8% | | 1.00 | 4.01 | 1.44 |
| 10-bounded-repeat/compile-context | 1 | 72.45 ± 1.4% | not timed | not timed | 11.04 ± 0.4% | 15.95 ± 1.9% | not timed | not timed | 72.60 ± 1.6% | | 1.00 | 6.56 | 4.54 |
| 10-bounded-repeat/compile-capitals | 1 | 84.45 ± 0.5% | not timed | not timed | 7.98 ± 0.3% | 23.55 ± 1.7% | not timed | not timed | 85.35 ± 0.5% | | 0.99 | 10.59 | 3.59 |
| 11-unstructured-to-json/compile | 1 | 174.21 ± 0.8% | not timed | not timed | 41.33 ± 0.3% | 67.31 ± 3.7% | not timed | not timed | 174.31 ± 1.4% | | 1.00 | 4.21 | 2.59 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.6% | not timed | not timed | 0.07 ± 29.2% | 0.10 ± 13.7% | not timed | not timed | 0.35 ± 3.8% | | 1.00 | 5.13 | 3.67 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.60 ± 5.7% | not timed | not timed | 6.56 ± 0.1% | 0.59 ± 21.3% | not timed | not timed | 7.61 ± 2.6% | | 1.00 | 1.16 | 12.83 |
| dictionary/search/english-10 | 690 | 1.05 ± 0.5% | not timed | not timed | 165.42 ± 0.7% | 0.00 ± 1.0% | not timed | not timed | 1.05 ± 0.3% | | 1.00 | 0.0063 | 371.38 |
| dictionary/search/english-15 | 15 | 559.98 ± 0.5% | not timed | not timed | 558.88 ± 0.1% | 0.37 ± 0.1% | not timed | not timed | 560.45 ± 0.4% | | 1.00 | 1.00 | 1517.23 |
| folly/awyer-inn-busted | 1 | 5585.95 ± 0.1% | not timed | not timed | 143.76 ± 0.2% | 43.81 ± 0.2% | not timed | not timed | 5575.78 ± 0.2% | | 1.00 | 38.86 | 127.49 |
| folly/literal-never-match-rare | 0 | 20986.28 ± 0.6% | not timed | not timed | 19763.26 ± 0.5% | 40794.32 ± 1.1% | not timed | not timed | 20960.27 ± 0.7% | | 1.00 | 1.06 | 0.51 |
| folly/literal-never-match-frequent | 0 | 12471.72 ± 1.9% | not timed | not timed | 19745.36 ± 0.7% | 2196.64 ± 1.1% | not timed | not timed | 12523.31 ± 1.6% | | 1.00 | 0.63 | 5.68 |
| folly/literal-never-match-tricksy | 1 | 3249.41 ± 0.3% | not timed | not timed | 4421.19 ± 0.3% | 3048.41 ± 4.4% | not timed | not timed | 3256.89 ± 0.2% | | 1.00 | 0.73 | 1.07 |
| grep/every-line | 239963 | 1305.89 ± 0.6% | not timed | not timed | 959.98 ± 0.3% | 380.83 ± 17.6% | not timed | not timed | 1309.62 ± 0.5% | | 1.00 | 1.36 | 3.43 |
| grep/long-words-ascii | 5073 | 459.95 ± 0.1% | not timed | not timed | 468.34 ± 0.2% | 46.22 ± 8.5% | not timed | not timed | 460.24 ± 0.3% | | 1.00 | 0.98 | 9.95 |
| imported/leipzig/twain | 811 | 20351.70 ± 3.9% | not timed | not timed | 19244.80 ± 1.5% | 11817.79 ± 10.7% | not timed | not timed | 20361.12 ± 2.3% | | 1.00 | 1.06 | 1.72 |
| imported/leipzig/twain-insensitive | 965 | 8994.77 ± 1.1% | not timed | not timed | 4204.62 ± 1.8% | 37.77 ± 0.1% | not timed | not timed | 9051.85 ± 2.1% | | 0.99 | 2.14 | 238.14 |
| imported/leipzig/shing | 1540 | 629.66 ± 0.0% | not timed | not timed | 13063.34 ± 4.4% | 34.08 ± 0.2% | not timed | not timed | 631.87 ± 0.0% | | 1.00 | 0.0482 | 18.48 |
| imported/leipzig/huck-saw | 262 | 8001.38 ± 3.7% | not timed | not timed | 5517.40 ± 1.5% | 31.80 ± 0.2% | not timed | not timed | 8233.64 ± 3.7% | | 0.97 | 1.45 | 251.64 |
| imported/leipzig/word-ending-nn | 262 | 608.81 ± 0.2% | not timed | not timed | 616.53 ± 0.1% | 24.76 ± 0.2% | not timed | not timed | 611.44 ± 0.1% | | 1.00 | 0.99 | 24.59 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 10987.08 ± 1.8% | not timed | not timed | 4487.14 ± 1.3% | 11.51 ± 0.1% | not timed | not timed | 11021.67 ± 1.2% | | 1.00 | 2.45 | 954.23 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7716.18 ± 1.1% | not timed | not timed | 5476.07 ± 1.2% | 16.90 ± 0.1% | not timed | not timed | 7802.52 ± 2.0% | | 0.99 | 1.41 | 456.58 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4133.98 ± 0.6% | not timed | not timed | 417.12 ± 1.5% | 11.10 ± 0.1% | not timed | not timed | 4159.24 ± 1.2% | | 0.99 | 9.91 | 372.47 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 609.97 ± 0.0% | not timed | not timed | 614.87 ± 0.1% | 11.16 ± 0.1% | not timed | not timed | 609.75 ± 0.1% | | 1.00 | 0.99 | 54.65 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.38 ± 0.1% | not timed | not timed | 615.26 ± 0.0% | 9.74 ± 0.0% | not timed | not timed | 610.30 ± 0.1% | | 1.00 | 0.99 | 62.56 |
| imported/leipzig/tom-river | 2 | 6337.89 ± 3.7% | not timed | not timed | 4994.08 ± 3.9% | 31.08 ± 0.2% | not timed | not timed | 6301.32 ± 9.0% | | 1.01 | 1.27 | 203.91 |
| imported/leipzig/ing | 78424 | 609.08 ± 0.5% | not timed | not timed | 569.78 ± 0.1% | 28.43 ± 3.5% | not timed | not timed | 607.72 ± 0.6% | | 1.00 | 1.07 | 21.42 |
| imported/leipzig/ing-whitespace | 55248 | 756.65 ± 0.9% | not timed | not timed | 2058.66 ± 0.4% | 20.55 ± 2.9% | not timed | not timed | 757.95 ± 0.2% | | 1.00 | 0.37 | 36.82 |
| imported/leipzig/awyer-inn | 209 | 774.65 ± 1.5% | not timed | not timed | 4183.45 ± 4.8% | 22.67 ± 0.1% | not timed | not timed | 774.99 ± 1.3% | | 1.00 | 0.19 | 34.17 |
| imported/leipzig/quotes-bounded | 8886 | 2111.65 ± 1.8% | not timed | not timed | 2929.64 ± 1.0% | 38.31 ± 0.1% | not timed | not timed | 2106.52 ± 0.4% | | 1.00 | 0.72 | 55.12 |
| imported/leipzig/non-ascii-alternate | 2 | 12383.73 ± 2.9% | not timed | not timed | 5552.01 ± 3.4% | 50.60 ± 0.0% | not timed | not timed | 12539.41 ± 1.5% | | 0.99 | 2.23 | 244.76 |
| imported/leipzig/math-symbols | 69 | 1972.91 ± 0.5% | not timed | not timed | 613.70 ± 0.0% | 36.47 ± 0.2% | not timed | not timed | 1974.40 ± 0.3% | | 1.00 | 3.21 | 54.10 |
| imported/leipzig/bounded-strings-ending-z | 0 | 595.52 ± 0.4% | not timed | not timed | 617.82 ± 0.0% | 22.52 ± 0.2% | not timed | not timed | 592.42 ± 0.3% | | 1.01 | 0.96 | 26.45 |
| imported/lh3lh3-reb/uri | 17549 | 632.90 ± 0.1% | not timed | not timed | 1076.18 ± 0.1% | 27.70 ± 2.3% | not timed | not timed | 633.67 ± 0.1% | | 1.00 | 0.59 | 22.85 |
| imported/lh3lh3-reb/email | 15057 | 668.01 ± 0.1% | not timed | not timed | 1173.56 ± 0.2% | 30.85 ± 2.4% | not timed | not timed | 669.12 ± 0.1% | | 1.00 | 0.57 | 21.65 |
| imported/lh3lh3-reb/date | 668 | 866.09 ± 0.2% | not timed | not timed | 1044.81 ± 0.2% | 51.19 ± 4.0% | not timed | not timed | 866.74 ± 0.2% | | 1.00 | 0.83 | 16.92 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 642.91 ± 0.0% | not timed | not timed | 423.62 ± 0.8% | 15.76 ± 1.2% | not timed | not timed | 643.33 ± 0.1% | | 1.00 | 1.52 | 40.80 |
| imported/mariomka/email | 92 | 705.87 ± 0.1% | not timed | not timed | 29692.66 ± 0.4% | 32.83 ± 0.1% | not timed | not timed | 706.31 ± 0.2% | | 1.00 | 0.0238 | 21.50 |
| imported/mariomka/uri | 5301 | 608.39 ± 0.2% | not timed | not timed | 6061.22 ± 0.4% | 32.52 ± 0.3% | not timed | not timed | 605.62 ± 0.1% | | 1.00 | 0.10 | 18.71 |
| imported/mariomka/ip | 5 | 2154.00 ± 2.1% | not timed | not timed | 2967.32 ± 0.6% | 21.05 ± 0.0% | not timed | not timed | 2154.04 ± 2.3% | | 1.00 | 0.73 | 102.31 |
| imported/rsc/no-exponential | 0 | 565.33 ± 0.1% | not timed | not timed | 319.61 ± 0.2% | 23.86 ± 0.1% | not timed | not timed | 564.49 ± 0.1% | | 1.00 | 1.77 | 23.69 |
| imported/rsc/literal | 1 | 748.53 ± 2.5% | not timed | not timed | 1637.98 ± 10.6% | 186.88 ± 16.7% | not timed | not timed | 748.02 ± 3.8% | | 1.00 | 0.46 | 4.01 |
| imported/rsc/not-literal | 2 | 706.67 ± 0.2% | not timed | not timed | 726.53 ± 0.3% | 46.40 ± 3.4% | not timed | not timed | 704.58 ± 7.0% | | 1.00 | 0.97 | 15.23 |
| imported/rsc/match-class | 1 | 1302.34 ± 0.5% | not timed | not timed | 1618.50 ± 0.2% | 58.79 ± 13.9% | not timed | not timed | 1304.36 ± 2.4% | | 1.00 | 0.80 | 22.15 |
| imported/rsc/match-class-in-range | 1 | 1312.85 ± 0.1% | not timed | not timed | 2384.06 ± 7.9% | 60.17 ± 7.1% | not timed | not timed | 1311.35 ± 2.3% | | 1.00 | 0.55 | 21.82 |
| imported/rsc/match-class-unicode | 1 | 524.40 ± 0.2% | not timed | not timed | 480.69 ± 0.3% | 72.51 ± 0.4% | not timed | not timed | 523.44 ± 0.1% | | 1.00 | 1.09 | 7.23 |
| imported/rsc/anchored-literal-short-non-match | 0 | 539.01 ± 0.9% | not timed | not timed | 939.06 ± 0.2% | 227.48 ± 0.5% | not timed | not timed | 537.52 ± 0.8% | | 1.00 | 0.57 | 2.37 |
| imported/rsc/anchored-literal-long-non-match | 0 | 8053.18 ± 0.1% | not timed | not timed | 14176.74 ± 0.2% | 3414.32 ± 0.7% | not timed | not timed | 8023.98 ± 0.1% | | 1.00 | 0.57 | 2.36 |
| imported/rsc/anchored-literal-short-match | 4 | 417.47 ± 2.5% | not timed | not timed | 481.09 ± 0.2% | 85.96 ± 7.9% | not timed | not timed | 420.83 ± 5.7% | | 0.99 | 0.87 | 4.86 |
| imported/rsc/anchored-literal-long-match | 4 | 3020.55 ± 0.8% | not timed | not timed | 7261.77 ± 0.3% | 1217.28 ± 1.6% | not timed | not timed | 3021.09 ± 0.2% | | 1.00 | 0.42 | 2.48 |
| imported/rsc/one-pass-short | 17 | 310.59 ± 9.3% | not timed | not timed | 218.09 ± 0.1% | 31.30 ± 14.0% | not timed | not timed | 309.40 ± 1.9% | | 1.00 | 1.42 | 9.92 |
| imported/rsc/one-pass-short-not | 17 | 219.22 ± 7.0% | not timed | not timed | 223.31 ± 0.3% | 32.01 ± 13.9% | not timed | not timed | 218.87 ± 0.2% | | 1.00 | 0.98 | 6.85 |
| imported/rsc/one-pass-long-prefix | 26 | 235.35 ± 2.1% | not timed | not timed | 287.76 ± 0.5% | 99.24 ± 11.5% | not timed | not timed | 240.29 ± 2.8% | | 0.98 | 0.82 | 2.37 |
| imported/rsc/one-pass-long-prefix-not | 26 | 310.85 ± 1.7% | not timed | not timed | 287.51 ± 0.5% | 65.59 ± 15.5% | not timed | not timed | 307.95 ± 1.8% | | 1.01 | 1.08 | 4.74 |
| imported/rsc/long-needle1 | 31 | 21923.89 ± 0.2% | not timed | not timed | 20126.66 ± 0.1% | 3.76 ± 0.4% | not timed | not timed | 21922.41 ± 0.1% | | 1.00 | 1.09 | 5835.96 |
| imported/rsc/long-needle2 | 31 | 22096.93 ± 0.2% | not timed | not timed | 215.99 ± 0.2% | 3.75 ± 0.2% | not timed | not timed | 22101.19 ± 0.1% | | 1.00 | 102.31 | 5887.72 |
| imported/rsc/easy0-32 | 26 | 1074.72 ± 3.5% | not timed | not timed | 1511.80 ± 0.4% | 147.47 ± 17.2% | not timed | not timed | 1074.30 ± 2.7% | | 1.00 | 0.71 | 7.29 |
| imported/rsc/easy0-1k | 26 | 14971.76 ± 0.4% | not timed | not timed | 12451.21 ± 0.2% | 2302.52 ± 16.2% | not timed | not timed | 14920.42 ± 2.2% | | 1.00 | 1.20 | 6.50 |
| imported/rsc/easy0-32k | 26 | 22900.90 ± 0.1% | not timed | not timed | 20342.90 ± 0.1% | 18818.59 ± 22.8% | not timed | not timed | 22910.95 ± 1.5% | | 1.00 | 1.13 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21853.57 ± 2.3% | not timed | not timed | 20070.52 ± 2.4% | 37448.00 ± 5.2% | not timed | not timed | 21858.61 ± 1.3% | | 1.00 | 1.09 | 0.58 |
| imported/rsc/easy1-32 | 19 | 359.78 ± 2.2% | not timed | not timed | 623.52 ± 0.5% | 130.90 ± 17.3% | not timed | not timed | 359.46 ± 1.9% | | 1.00 | 0.58 | 2.75 |
| imported/rsc/easy1-1k | 19 | 585.08 ± 2.7% | not timed | not timed | 12801.01 ± 0.3% | 2503.74 ± 15.7% | not timed | not timed | 582.28 ± 0.1% | | 1.00 | 0.0457 | 0.23 |
| imported/rsc/easy1-32k | 19 | 602.34 ± 0.9% | not timed | not timed | 402487.86 ± 0.3% | 20557.04 ± 0.1% | not timed | not timed | 602.36 ± 0.7% | | 1.00 | 0.0015 | 0.0293 |
| imported/rsc/easy1-1mb | 19 | 602.80 ± 0.4% | not timed | not timed | 12771476.39 ± 0.1% | 37330.09 ± 3.3% | not timed | not timed | 600.80 ± 0.7% | | 1.00 | 0.0000 | 0.0161 |
| imported/rsc/medium-32 | 27 | 429.28 ± 2.3% | not timed | not timed | 625.77 ± 0.2% | 70.32 ± 11.3% | not timed | not timed | 429.04 ± 0.2% | | 1.00 | 0.69 | 6.11 |
| imported/rsc/medium-1k | 27 | 6821.43 ± 0.4% | not timed | not timed | 11125.34 ± 0.4% | 72.51 ± 0.2% | not timed | not timed | 6794.76 ± 0.4% | | 1.00 | 0.61 | 94.08 |
| imported/rsc/medium-32k | 27 | 21610.00 ± 0.1% | not timed | not timed | 349036.52 ± 0.1% | 48.74 ± 0.1% | not timed | not timed | 21602.67 ± 0.0% | | 1.00 | 0.0619 | 443.40 |
| imported/rsc/medium-1mb | 27 | 21347.74 ± 0.9% | not timed | not timed | 11240462.35 ± 0.1% | 48.66 ± 0.2% | not timed | not timed | 21343.52 ± 1.1% | | 1.00 | 0.0019 | 438.69 |
| imported/rsc/hard-32 | 58 | 255.06 ± 2.1% | not timed | not timed | 364.42 ± 0.2% | 49.72 ± 7.5% | not timed | not timed | 254.73 ± 0.1% | | 1.00 | 0.70 | 5.13 |
| imported/rsc/hard-1k | 27 | 577.85 ± 0.4% | not timed | not timed | 11548.81 ± 0.2% | 40.68 ± 0.1% | not timed | not timed | 574.37 ± 0.4% | | 1.01 | 0.0500 | 14.21 |
| imported/rsc/hard-32k | 27 | 604.00 ± 0.1% | not timed | not timed | 359135.32 ± 0.3% | 29.37 ± 0.2% | not timed | not timed | 599.27 ± 0.3% | | 1.01 | 0.0017 | 20.56 |
| imported/rsc/hard-1mb | 51 | 603.07 ± 0.9% | not timed | not timed | 7221749.48 ± 0.2% | 29.39 ± 0.1% | not timed | not timed | 601.31 ± 0.4% | | 1.00 | 0.0001 | 20.52 |
| imported/rsc/reallyhard0-32 | 58 | 254.32 ± 0.2% | not timed | not timed | 216.88 ± 0.2% | 49.79 ± 7.7% | not timed | not timed | 254.21 ± 2.5% | | 1.00 | 1.17 | 5.11 |
| imported/rsc/reallyhard0-1k | 27 | 576.32 ± 0.3% | not timed | not timed | 583.49 ± 0.0% | 40.85 ± 0.1% | not timed | not timed | 580.98 ± 0.2% | | 0.99 | 0.99 | 14.11 |
| imported/rsc/reallyhard0-32k | 27 | 601.40 ± 0.1% | not timed | not timed | 618.56 ± 0.0% | 29.40 ± 0.1% | not timed | not timed | 604.80 ± 0.3% | | 0.99 | 0.97 | 20.46 |
| imported/rsc/reallyhard0-1mb | 51 | 590.46 ± 0.6% | not timed | not timed | 613.10 ± 0.1% | 29.40 ± 0.1% | not timed | not timed | 595.74 ± 0.3% | | 0.99 | 0.96 | 20.08 |
| imported/rsc/reallyreallyhard0-32 | 47 | 274.06 ± 0.1% | not timed | not timed | 195.88 ± 0.3% | 61.19 ± 10.9% | not timed | not timed | 273.80 ± 1.6% | | 1.00 | 1.40 | 4.48 |
| imported/rsc/reallyreallyhard0-1k | 16 | 860.30 ± 3.8% | not timed | not timed | 5931.96 ± 0.2% | 33.65 ± 2.6% | not timed | not timed | 856.49 ± 2.3% | | 1.00 | 0.15 | 25.56 |
| imported/rsc/reallyreallyhard0-32k | 16 | 622.09 ± 5.2% | not timed | not timed | 19244.15 ± 0.1% | 24.84 ± 3.8% | not timed | not timed | 625.38 ± 4.8% | | 0.99 | 0.0323 | 25.04 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 589.63 ± 0.5% | not timed | not timed | 19701.64 ± 1.4% | 24.98 ± 0.3% | not timed | not timed | 592.61 ± 0.3% | | 0.99 | 0.0299 | 23.60 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 269.23 ± 0.1% | not timed | not timed | 213.27 ± 0.3% | 60.75 ± 13.0% | not timed | not timed | 268.19 ± 2.8% | | 1.00 | 1.26 | 4.43 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 840.54 ± 1.6% | not timed | not timed | 6190.46 ± 0.1% | 34.33 ± 1.2% | not timed | not timed | 840.35 ± 1.4% | | 1.00 | 0.14 | 24.48 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 621.87 ± 4.1% | not timed | not timed | 19204.81 ± 0.1% | 25.11 ± 0.5% | not timed | not timed | 618.97 ± 5.1% | | 1.00 | 0.0324 | 24.76 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 589.77 ± 0.4% | not timed | not timed | 19715.70 ± 0.7% | 25.06 ± 0.1% | not timed | not timed | 589.20 ± 0.6% | | 1.00 | 0.0299 | 23.53 |
| imported/sherlock/name-sherlock | 776 | 19816.00 ± 1.7% | not timed | not timed | 18554.77 ± 0.4% | 8762.83 ± 24.9% | not timed | not timed | 19850.76 ± 1.7% | | 1.00 | 1.07 | 2.26 |
| imported/sherlock/name-holmes | 2766 | 15104.09 ± 1.7% | not timed | not timed | 15531.41 ± 0.7% | 3258.57 ± 2.0% | not timed | not timed | 15299.65 ± 1.8% | | 0.99 | 0.97 | 4.64 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19848.14 ± 1.9% | not timed | not timed | 18585.35 ± 0.3% | 8102.65 ± 24.4% | not timed | not timed | 19880.25 ± 2.3% | | 1.00 | 1.07 | 2.45 |
| imported/sherlock/name-sherlock-casei | 816 | 15629.59 ± 0.5% | not timed | not timed | 3981.76 ± 0.1% | 32.45 ± 0.5% | not timed | not timed | 15617.75 ± 0.3% | | 1.00 | 3.93 | 481.63 |
| imported/sherlock/name-holmes-casei | 2802 | 9322.83 ± 5.4% | not timed | not timed | 3214.64 ± 0.2% | 38.75 ± 3.2% | not timed | not timed | 9372.47 ± 2.1% | | 0.99 | 2.90 | 240.61 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12985.57 ± 9.2% | not timed | not timed | 3929.32 ± 0.1% | 32.54 ± 0.2% | not timed | not timed | 12988.36 ± 1.5% | | 1.00 | 3.30 | 399.09 |
| imported/sherlock/name-whitespace | 1461 | 15109.00 ± 1.5% | not timed | not timed | 14194.55 ± 0.4% | 6703.27 ± 15.9% | not timed | not timed | 15137.37 ± 1.5% | | 1.00 | 1.06 | 2.25 |
| imported/sherlock/name-alt1 | 1142 | 11417.61 ± 0.1% | not timed | not timed | 15630.70 ± 1.0% | 4145.76 ± 22.6% | not timed | not timed | 11427.15 ± 2.3% | | 1.00 | 0.73 | 2.75 |
| imported/sherlock/name-alt2 | 3542 | 8581.21 ± 0.3% | not timed | not timed | 3830.14 ± 0.2% | 31.27 ± 0.1% | not timed | not timed | 8612.33 ± 0.3% | | 1.00 | 2.24 | 274.41 |
| imported/sherlock/name-alt3 | 4507 | 5438.59 ± 0.5% | not timed | not timed | 3636.14 ± 0.1% | 9.71 ± 4.4% | not timed | not timed | 5451.05 ± 0.2% | | 1.00 | 1.50 | 560.08 |
| imported/sherlock/name-alt3-casei | 4593 | 1518.82 ± 2.5% | not timed | not timed | 285.52 ± 0.2% | 6.47 ± 0.1% | not timed | not timed | 1519.27 ± 0.5% | | 1.00 | 5.32 | 234.63 |
| imported/sherlock/name-alt4 | 3686 | 6155.35 ± 0.2% | not timed | not timed | 3664.77 ± 0.1% | 31.11 ± 0.3% | not timed | not timed | 6154.97 ± 0.1% | | 1.00 | 1.68 | 197.85 |
| imported/sherlock/name-alt4-casei | 4254 | 2765.59 ± 2.7% | not timed | not timed | 2531.92 ± 0.1% | 19.85 ± 0.1% | not timed | not timed | 2764.81 ± 1.5% | | 1.00 | 1.09 | 139.35 |
| imported/sherlock/name-alt5 | 4028 | 6219.05 ± 0.3% | not timed | not timed | 3749.09 ± 0.1% | 21.75 ± 0.1% | not timed | not timed | 6233.98 ± 0.4% | | 1.00 | 1.66 | 285.96 |
| imported/sherlock/name-alt5-casei | 4104 | 3460.92 ± 1.7% | not timed | not timed | 2172.88 ± 0.3% | 14.38 ± 0.2% | not timed | not timed | 3469.02 ± 1.1% | | 1.00 | 1.59 | 240.66 |
| imported/sherlock/no-match-uncommon | 0 | 21727.84 ± 0.4% | not timed | not timed | 19632.63 ± 0.5% | 36744.02 ± 0.4% | not timed | not timed | 21747.20 ± 0.5% | | 1.00 | 1.11 | 0.59 |
| imported/sherlock/no-match-common | 0 | 21530.05 ± 0.6% | not timed | not timed | 19612.43 ± 0.5% | 1278.27 ± 0.8% | not timed | not timed | 21557.51 ± 0.7% | | 1.00 | 1.10 | 16.84 |
| imported/sherlock/no-match-really-common | 0 | 16175.30 ± 2.7% | not timed | not timed | 18851.01 ± 0.6% | 1279.94 ± 1.3% | not timed | not timed | 16318.66 ± 2.1% | | 0.99 | 0.86 | 12.64 |
| imported/sherlock/the-lower | 21654 | 2301.34 ± 0.9% | not timed | not timed | 2340.03 ± 0.3% | 232.25 ± 13.8% | not timed | not timed | 2314.14 ± 1.3% | | 0.99 | 0.98 | 9.91 |
| imported/sherlock/the-upper | 2223 | 12734.56 ± 0.9% | not timed | not timed | 13556.05 ± 0.5% | 2672.80 ± 23.2% | not timed | not timed | 12762.06 ± 7.6% | | 1.00 | 0.94 | 4.76 |
| imported/sherlock/the-casei | 23961 | 2004.32 ± 1.3% | not timed | not timed | 1322.63 ± 0.3% | 34.66 ± 27.6% | not timed | not timed | 2003.69 ± 0.2% | | 1.00 | 1.52 | 57.82 |
| imported/sherlock/everything-greedy | 581881 | 270.87 ± 1.2% | not timed | not timed | 166.82 ± 0.2% | 29.01 ± 23.6% | not timed | not timed | 270.87 ± 0.2% | | 1.00 | 1.62 | 9.34 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.37 ± 0.1% | not timed | not timed | 213.70 ± 0.5% | 32.91 ± 0.2% | not timed | not timed | 463.59 ± 0.1% | | 1.00 | 2.16 | 14.05 |
| imported/sherlock/letters | 447175 | 54.22 ± 8.6% | not timed | not timed | 27.64 ± 0.1% | 5.50 ± 32.1% | not timed | not timed | 54.40 ± 0.9% | | 1.00 | 1.96 | 9.86 |
| imported/sherlock/letters-upper | 14180 | 433.66 ± 1.2% | not timed | not timed | 351.68 ± 0.1% | 29.79 ± 16.9% | not timed | not timed | 434.73 ± 0.2% | | 1.00 | 1.23 | 14.56 |
| imported/sherlock/letters-lower | 432995 | 55.41 ± 0.9% | not timed | not timed | 28.41 ± 0.1% | 5.42 ± 41.2% | not timed | not timed | 55.58 ± 0.9% | | 1.00 | 1.95 | 10.23 |
| imported/sherlock/words | 447639 | 106.33 ± 1.2% | not timed | not timed | 79.20 ± 0.1% | 13.84 ± 3.5% | not timed | not timed | 106.71 ± 1.2% | | 1.00 | 1.34 | 7.68 |
| imported/sherlock/before-holmes | 4073 | 599.72 ± 0.3% | not timed | not timed | 8492.75 ± 0.4% | 23.72 ± 1.6% | not timed | not timed | 596.38 ± 0.3% | | 1.01 | 0.0706 | 25.28 |
| imported/sherlock/before-after-holmes | 2593 | 598.00 ± 0.2% | not timed | not timed | 9481.02 ± 0.5% | 23.74 ± 1.4% | not timed | not timed | 598.36 ± 0.3% | | 1.00 | 0.0631 | 25.19 |
| imported/sherlock/holmes-cochar-watson | 150 | 5222.84 ± 0.2% | not timed | not timed | 3420.73 ± 0.1% | 31.09 ± 0.1% | not timed | not timed | 5218.62 ± 0.2% | | 1.00 | 1.53 | 167.99 |
| imported/sherlock/holmes-coword-watson | 14309 | 1261.33 ± 5.4% | not timed | not timed | 1122.23 ± 0.2% | 6.79 ± 0.1% | not timed | not timed | 1260.06 ± 5.5% | | 1.00 | 1.12 | 185.83 |
| imported/sherlock/quotes | 14437 | 1414.01 ± 0.4% | not timed | not timed | 1736.48 ± 0.6% | 35.13 ± 0.2% | not timed | not timed | 1413.89 ± 0.3% | | 1.00 | 0.81 | 40.25 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 601.43 ± 0.4% | not timed | not timed | 15850.73 ± 0.4% | 36.69 ± 0.2% | not timed | not timed | 601.25 ± 0.8% | | 1.00 | 0.0379 | 16.39 |
| imported/sherlock/word-ending-n | 35297 | 469.03 ± 0.9% | not timed | not timed | 392.95 ± 0.1% | 23.64 ± 21.6% | not timed | not timed | 468.24 ± 0.3% | | 1.00 | 1.19 | 19.84 |
| imported/sherlock/repeated-class-negation | 2130 | 14618.67 ± 0.8% | not timed | not timed | 10945.23 ± 0.4% | 11.57 ± 0.3% | not timed | not timed | 14609.35 ± 0.6% | | 1.00 | 1.34 | 1263.56 |
| imported/sherlock/ing-suffix | 20547 | 554.95 ± 0.4% | not timed | not timed | 506.99 ± 0.1% | 28.84 ± 0.2% | not timed | not timed | 554.09 ± 0.1% | | 1.00 | 1.09 | 19.24 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 595.43 ± 0.3% | not timed | not timed | 2095.90 ± 0.6% | 20.51 ± 0.2% | not timed | not timed | 595.24 ± 0.3% | | 1.00 | 0.28 | 29.03 |
| opt/accelerate/whole-line | 239963 | 458.92 ± 0.2% | not timed | not timed | 373.10 ± 0.4% | 92.38 ± 16.8% | not timed | not timed | 459.07 ± 0.3% | | 1.00 | 1.23 | 4.97 |
| opt/accelerate/non-dna | 16745 | 414.24 ± 0.8% | not timed | not timed | 379.05 ± 0.0% | 29.63 ± 16.3% | not timed | not timed | 413.78 ± 0.5% | | 1.00 | 1.09 | 13.98 |
| opt/backtrack/words-english | 40536 | 137.22 ± 0.2% | not timed | not timed | 94.08 ± 0.2% | 19.82 ± 7.9% | not timed | not timed | 137.17 ± 2.3% | | 1.00 | 1.46 | 6.92 |
| opt/fixed-length/too-small-ascii | 0 | 313.39 ± 0.4% | not timed | not timed | 686.22 ± 4.0% | 79.89 ± 0.4% | not timed | not timed | 311.93 ± 0.8% | | 1.00 | 0.46 | 3.92 |
| opt/fixed-length/too-big-ascii | 0 | 647.60 ± 0.7% | not timed | not timed | 5811.17 ± 0.3% | 124.75 ± 0.4% | not timed | not timed | 650.80 ± 0.4% | | 1.00 | 0.11 | 5.19 |
| opt/fixed-length/go33484-1 | 0 | 41.39 ± 1.5% | not timed | not timed | 1102264.39 ± 0.1% | 61486.35 ± 0.3% | not timed | not timed | 41.56 ± 0.9% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5535.55 ± 0.1% | not timed | not timed | 1105760.44 ± 0.3% | 31909.12 ± 0.8% | not timed | not timed | 5522.80 ± 0.1% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1769.56 ± 1.7% | not timed | not timed | 111460.05 ± 0.0% | 759.95 ± 0.3% | not timed | not timed | 1772.51 ± 1.7% | | 1.00 | 0.0159 | 2.33 |
| opt/literal-alt/one-pattern | 1 | 551.86 ± 2.4% | not timed | not timed | 544.34 ± 0.1% | 0.39 ± 0.4% | not timed | not timed | 535.02 ± 0.4% | | 1.03 | 1.01 | 1401.40 |
| opt/onepass/fn-predicate | 916 | 365.17 ± 2.1% | not timed | not timed | 332.52 ± 0.1% | 200.73 ± 12.6% | not timed | not timed | 368.80 ± 0.9% | | 0.99 | 1.10 | 1.82 |
| opt/onepass/first-three-words-english | 35128 | 149.90 ± 1.7% | not timed | not timed | 200.21 ± 0.2% | 81.02 ± 11.4% | not timed | not timed | 150.05 ± 7.9% | | 1.00 | 0.75 | 1.85 |
| opt/prefilter/literal-english | 1 | 21078.47 ± 0.3% | not timed | not timed | 20039.09 ± 0.2% | 17678.46 ± 0.6% | not timed | not timed | 21081.75 ± 0.7% | | 1.00 | 1.05 | 1.19 |
| opt/prefilter/literal-casei-english | 1 | 14604.41 ± 0.5% | not timed | not timed | 4317.54 ± 0.1% | 32.65 ± 0.2% | not timed | not timed | 14604.55 ± 0.2% | | 1.00 | 3.38 | 447.27 |
| opt/prefilter/literal-russian | 1 | 21332.02 ± 0.4% | not timed | not timed | 19798.17 ± 0.7% | 3321.09 ± 0.4% | not timed | not timed | 21338.09 ± 0.3% | | 1.00 | 1.08 | 6.42 |
| opt/prefilter/literal-casei-russian | 1 | 8553.55 ± 0.6% | not timed | not timed | 3891.23 ± 0.0% | 30.89 ± 0.1% | not timed | not timed | 8538.28 ± 0.2% | | 1.00 | 2.20 | 276.92 |
| opt/prefilter/rust-functions | 948 | 6826.58 ± 0.4% | not timed | not timed | 8978.15 ± 0.6% | 1864.58 ± 0.4% | not timed | not timed | 6827.06 ± 0.4% | | 1.00 | 0.76 | 3.66 |
| opt/reverse-anchored/word-end | 1 | 5576.54 ± 0.6% | not timed | not timed | 20796173.87 ± 0.1% | 50.18 ± 0.1% | not timed | not timed | 5579.36 ± 0.4% | | 1.00 | 0.0003 | 111.12 |
| opt/reverse-inner/holmes | 2593 | 597.42 ± 0.3% | not timed | not timed | 9490.56 ± 0.3% | 24.05 ± 1.2% | not timed | not timed | 598.05 ± 0.2% | | 1.00 | 0.0629 | 24.84 |
| opt/reverse-inner/email | 47 | 1045.21 ± 0.1% | not timed | not timed | 44497.90 ± 1.3% | 32.38 ± 0.1% | not timed | not timed | 1044.68 ± 0.1% | | 1.00 | 0.0235 | 32.28 |
| opt/reverse-inner/factored-prefix | 3542 | 591.00 ± 0.5% | not timed | not timed | 593.09 ± 0.1% | 12.55 ± 0.1% | not timed | not timed | 591.56 ± 0.6% | | 1.00 | 1.00 | 47.09 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5511.42 ± 0.1% | not timed | not timed | 611.42 ± 0.3% | 75.27 ± 0.2% | not timed | not timed | 5520.54 ± 0.0% | | 1.00 | 9.01 | 73.23 |
| opt/reverse-inner/no-quadratic-forward | 0 | 743.08 ± 10.2% | not timed | not timed | 288.32 ± 0.2% | 24.77 ± 0.1% | not timed | not timed | 745.58 ± 11.6% | | 1.00 | 2.58 | 30.00 |
| opt/reverse-suffix/holmes | 4073 | 599.60 ± 0.1% | not timed | not timed | 8442.42 ± 0.2% | 23.49 ± 2.0% | not timed | not timed | 597.40 ± 0.4% | | 1.00 | 0.0710 | 25.53 |
| opt/reverse-suffix/no-quadratic | 0 | 5520.43 ± 0.1% | not timed | not timed | 613.63 ± 0.3% | 75.20 ± 0.2% | not timed | not timed | 5508.88 ± 0.0% | | 1.00 | 9.00 | 73.41 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.74 ± 7.3% | not timed | not timed | 131.84 ± 0.2% | 13.52 ± 15.2% | not timed | not timed | 120.89 ± 1.0% | | 1.00 | 0.92 | 8.93 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 121.14 ± 0.4% | not timed | not timed | 132.63 ± 0.1% | 13.29 ± 14.1% | not timed | not timed | 120.70 ± 3.2% | | 1.00 | 0.91 | 9.12 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.3% | not timed | not timed | 0.55 ± 0.3% | 113.09 ± 0.4% | not timed | not timed | 0.28 ± 0.2% | | 1.00 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 316.88 ± 0.2% | not timed | not timed | 292.15 ± 0.1% | 104.13 ± 1.8% | not timed | not timed | 309.59 ± 0.5% | | 1.02 | 1.08 | 3.04 |
| reported/i13-subset-regex/original-ascii | 4094 | 11035.37 ± 0.9% | not timed | not timed | 4526.27 ± 0.4% | 11.52 ± 0.0% | not timed | not timed | 11080.38 ± 1.4% | | 1.00 | 2.44 | 958.34 |
| reported/i13-subset-regex/original-unicode | 4094 | 10933.15 ± 2.8% | not timed | not timed | 250.07 ± 3.7% | 11.52 ± 0.1% | not timed | not timed | 11048.83 ± 1.1% | | 0.99 | 43.72 | 949.24 |
| reported/i13-subset-regex/big-ascii | 1955 | 10648.96 ± 1.5% | not timed | not timed | 67.86 ± 3.6% | 9.77 ± 0.2% | not timed | not timed | 10726.59 ± 0.8% | | 0.99 | 156.94 | 1090.16 |
| reported/i13-subset-regex/big-unicode | 1955 | 10579.01 ± 1.7% | not timed | not timed | 12.22 ± 54.9% | 9.83 ± 0.1% | not timed | not timed | 10712.63 ± 1.0% | | 0.99 | 865.64 | 1075.67 |
| reported/i13-subset-regex/huge-ascii | 55 | 10093.93 ± 3.0% | not timed | not timed | 11.02 ± 0.1% | 8.72 ± 0.1% | not timed | not timed | 9926.47 ± 3.1% | | 1.02 | 915.56 | 1158.21 |
| reported/i13-subset-regex/huge-unicode | 55 | 9915.31 ± 3.4% | not timed | not timed | 11.02 ± 0.3% | 8.77 ± 0.1% | not timed | not timed | 9880.60 ± 3.0% | | 1.00 | 899.76 | 1130.37 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.0% | not timed | not timed | 11.07 ± 0.1% | 8.76 ± 1.5% | not timed | not timed | 3.54 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.1% | not timed | not timed | 11.01 ± 0.3% | 8.76 ± 0.1% | not timed | not timed | 5.03 ± 0.1% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 467.06 ± 0.3% | not timed | not timed | 102.90 ± 0.2% | 6.53 ± 0.1% | not timed | not timed | 469.62 ± 0.3% | | 0.99 | 4.54 | 71.57 |
| reported/i787-keywords/opt-ascii | 5674 | 468.67 ± 0.2% | not timed | not timed | 267.70 ± 0.2% | 10.27 ± 0.2% | not timed | not timed | 471.25 ± 0.4% | | 0.99 | 1.75 | 45.62 |
| slow/quadratic-regex-1x | 100 | 6.95 ± 0.3% | not timed | not timed | 4.95 ± 0.0% | 0.05 ± 0.2% | not timed | not timed | 6.96 ± 0.3% | | 1.00 | 1.40 | 141.23 |
| slow/quadratic-regex-2x | 199 | 3.40 ± 0.2% | not timed | not timed | 2.77 ± 0.1% | 0.01 ± 0.2% | not timed | not timed | 3.40 ± 0.1% | | 1.00 | 1.23 | 266.92 |
| slow/quadratic-haystack-1x | 100 | 21.14 ± 1.1% | not timed | not timed | 9.99 ± 0.2% | 1.01 ± 14.1% | not timed | not timed | 21.14 ± 1.4% | | 1.00 | 2.12 | 20.83 |
| slow/quadratic-haystack-2x | 200 | 17.54 ± 12.5% | not timed | not timed | 5.55 ± 0.1% | 0.54 ± 13.7% | not timed | not timed | 17.48 ± 1.7% | | 1.00 | 3.16 | 32.19 |
| unicode/codepoints/any-one | 1112064 | 286.45 ± 0.5% | not timed | not timed | 176.82 ± 0.0% | 18.40 ± 0.8% | not timed | not timed | 286.85 ± 0.4% | | 1.00 | 1.62 | 15.57 |
| unicode/codepoints/any-all | 4382592 | 289.80 ± 0.5% | not timed | not timed | 245.95 ± 0.3% | 117.08 ± 0.2% | not timed | not timed | 289.71 ± 0.5% | | 1.00 | 1.18 | 2.48 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.70 ± 1.1% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 610.60 ± 0.1% | not timed | not timed | 615.74 ± 0.3% | 134.28 ± 0.4% | not timed | not timed | 609.88 ± 0.4% | | 1.00 | 0.99 | 4.55 |
| unicode/overlapping-words/ascii | 6156 | 31.09 ± 0.6% | not timed | not timed | 38.85 ± 0.2% | 3.91 ± 0.9% | not timed | not timed | 31.16 ± 0.3% | | 1.00 | 0.80 | 7.94 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 0.3% | not timed | not timed | 3.80 ± 0.2% | 2.34 ± 0.8% | not timed | not timed | 1.35 ± 0.2% | | 1.00 | 0.35 | 0.58 |
| unicode/overlapping-words/russian | 5710 | 1.22 ± 10.0% | not timed | not timed | 3.58 ± 0.4% | 6.30 ± 8.9% | not timed | not timed | 1.22 ± 0.5% | | 1.00 | 0.34 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 117.10 ± 7.3% | not timed | not timed | 74.85 ± 0.2% | 11.69 ± 24.0% | not timed | not timed | 117.79 ± 0.4% | | 0.99 | 1.56 | 10.02 |
| unicode/word/boundary-long-english | 3466 | 606.11 ± 0.4% | not timed | not timed | 604.98 ± 0.2% | 31.91 ± 1.0% | not timed | not timed | 607.88 ± 0.8% | | 1.00 | 1.00 | 18.99 |
| unicode/word/around-holmes-english | 27 | 604.13 ± 0.7% | not timed | not timed | 19849.86 ± 0.4% | 21.91 ± 1.3% | not timed | not timed | 603.25 ± 0.5% | | 1.00 | 0.0304 | 27.58 |
| wild/bibleref/long | 874 | 565.03 ± 0.2% | not timed | not timed | 584.40 ± 0.3% | 6.24 ± 0.1% | not timed | not timed | 566.47 ± 0.1% | | 1.00 | 0.97 | 90.62 |
| wild/bibleref/short | 30 | 24.88 ± 2.2% | not timed | not timed | 30.87 ± 0.2% | 14.05 ± 9.2% | not timed | not timed | 25.71 ± 2.5% | | 0.97 | 0.81 | 1.77 |
| wild/bibleref/line | 874 | 357.46 ± 3.5% | not timed | not timed | 214.76 ± 0.1% | 9.24 ± 7.8% | not timed | not timed | 357.45 ± 0.3% | | 1.00 | 1.66 | 38.68 |
| wild/caddy/caddy | 6 | 418.01 ± 1.7% | not timed | not timed | 244.89 ± 0.1% | 68.28 ± 14.6% | not timed | not timed | 416.79 ± 0.5% | | 1.00 | 1.71 | 6.12 |
| wild/dot-star-capture/rust-src-tools | 6 | 1056.63 ± 0.5% | not timed | not timed | 350.82 ± 0.3% | 13.55 ± 0.1% | not timed | not timed | 1057.78 ± 0.3% | | 1.00 | 3.01 | 77.96 |
| wild/ruff/noqa | 84 | 404.13 ± 0.3% | not timed | not timed | 467.23 ± 0.1% | 19.65 ± 2.1% | not timed | not timed | 403.39 ± 1.3% | | 1.00 | 0.86 | 20.56 |
| wild/ruff/unnecessary-coding-comment | 16 | 488.25 ± 0.5% | not timed | not timed | 702.13 ± 0.1% | 136.11 ± 10.9% | not timed | not timed | 489.90 ± 0.7% | | 1.00 | 0.70 | 3.59 |
| wild/ruff/string-quote-prefix | 2972 | 406.79 ± 0.7% | not timed | not timed | 441.57 ± 0.2% | 313.53 ± 25.5% | not timed | not timed | 407.26 ± 0.6% | | 1.00 | 0.92 | 1.30 |
| wild/ruff/space-around-operator | 1224378 | 217.10 ± 1.7% | not timed | not timed | 186.64 ± 0.1% | 18.45 ± 1.9% | not timed | not timed | 217.37 ± 1.9% | | 1.00 | 1.16 | 11.77 |
| wild/ruff/shebang | 282 | 401.23 ± 0.5% | not timed | not timed | 322.81 ± 0.1% | 118.73 ± 13.2% | not timed | not timed | 401.38 ± 0.5% | | 1.00 | 1.24 | 3.38 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13819.18 ± 0.6% | not timed | not timed | 13771.72 ± 0.5% | 6939.83 ± 0.9% | not timed | not timed | 13827.99 ± 0.6% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12718.44 ± 9.8% | not timed | not timed | 13380.39 ± 2.7% | 6339.11 ± 3.2% | not timed | not timed | 12683.91 ± 0.8% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13156.24 ± 0.7% | not timed | not timed | 13610.48 ± 0.9% | 6618.06 ± 1.8% | not timed | not timed | 13176.52 ± 0.8% | | 1.00 | 0.97 | 1.99 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9529.25 ± 0.6% | not timed | not timed | 13425.94 ± 1.0% | 6681.10 ± 0.6% | not timed | not timed | 9525.33 ± 1.3% | | 1.00 | 0.71 | 1.43 |
| wild/url/search | 234965 | 120.39 ± 15.0% | not timed | not timed | 64.98 ± 1.5% | 2.21 ± 0.7% | not timed | not timed | 121.02 ± 14.8% | | 0.99 | 1.85 | 54.56 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 5.8% | not timed | not timed | 0.01 ± 2.5% | 0.01 ± 53.5% | not timed | not timed | 0.03 ± 65.0% | | 1.00 | 3.13 | 4.27 |
| dictionary/compile/english-15 | 1 | 0.35 ± 24.4% | not timed | not timed | 0.07 ± 1.0% | 0.10 ± 24.9% | not timed | not timed | 0.35 ± 1.1% | | 0.98 | 5.23 | 3.37 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 3.6% | not timed | not timed | 0.02 ± 1.5% | 34.21 ± 5.6% | not timed | not timed | 0.25 ± 13.7% | | 0.95 | 12.87 | 0.0069 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.34 ± 2.2% | not timed | not timed | 11.59 ± 0.3% | 60.74 ± 21.8% | not timed | not timed | 47.82 ± 2.3% | | 0.99 | 4.09 | 0.78 |
| reported/i787-keywords/compile | 1 | 35.47 ± 4.7% | not timed | not timed | 2.14 ± 0.6% | 16.15 ± 35.7% | not timed | not timed | 35.48 ± 5.3% | | 1.00 | 16.55 | 2.20 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 372.10 ± 5.5% | not timed | not timed | 120.90 ± 0.2% | 551.66 ± 22.8% | not timed | not timed | 376.31 ± 1.0% | | 0.99 | 3.08 | 0.67 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 48.13 ± 2.0% | not timed | not timed | 4.12 ± 0.4% | 43.54 ± 5.9% | not timed | not timed | 49.00 ± 2.8% | | 0.98 | 11.69 | 1.11 |
| unicode/compile/one-letter | 53 | 6.72 ± 4.5% | not timed | not timed | 4.59 ± 0.4% | 64.23 ± 10.5% | not timed | not timed | 6.82 ± 14.6% | | 0.99 | 1.46 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.06 ± 17.0% | not timed | not timed | 0.10 ± 1.3% | 65.07 ± 8.7% | not timed | not timed | 1.11 ± 1.7% | | 0.96 | 10.66 | 0.0163 |
| unicode/compile/fifty-letters-ascii | 1 | 223.10 ± 3.3% | not timed | not timed | 52.36 ± 0.2% | 192.09 ± 28.4% | not timed | not timed | 226.47 ± 3.6% | | 0.99 | 4.26 | 1.16 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 389.96 ± 4.9% | not timed | not timed | 47.43 ± 0.4% | 677.57 ± 31.9% | not timed | not timed | 396.95 ± 9.2% | | 0.98 | 8.22 | 0.58 |
| unicode/compile/match-every-line-ascii | 4 | 620.44 ± 6.2% | not timed | not timed | 146.09 ± 0.2% | 645.89 ± 16.1% | not timed | not timed | 633.72 ± 22.1% | | 0.98 | 4.25 | 0.96 |
| unicode/compile/negated-class-matches-codepoint | 1 | 322.34 ± 4.1% | not timed | not timed | 51.22 ± 0.3% | 1234.50 ± 5.5% | not timed | not timed | 336.45 ± 4.9% | | 0.96 | 6.29 | 0.26 |
| wild/bibleref/compile | 3 | 5.99 ± 5.7% | not timed | not timed | 1.93 ± 0.8% | 30.74 ± 5.5% | not timed | not timed | 5.99 ± 4.1% | | 1.00 | 3.10 | 0.19 |
| wild/url/compile | 1 | 0.65 ± 19.1% | not timed | not timed | 0.14 ± 0.7% | 0.42 ± 27.7% | not timed | not timed | 0.66 ± 0.7% | | 1.00 | 4.56 | 1.56 |

