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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391454319 |
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
| literal: a word | 217 | 19343.59 ± 2.4% | 5030.56 ± 0.3% | 28.09 ± 0.1% | 18234.27 ± 1.9% | 9071.92 ± 9.9% | 17.29 ± 0.1% | 84.14 ± 0.5% | 19318.68 ± 2.0% | 3.85 | 1.00 | 1.06 | 2.13 |
| literal: a word that is not there | 0 | 21453.55 ± 2.2% | 4916.97 ± 0.5% | 28.24 ± 0.3% | 19506.25 ± 3.0% | 28553.90 ± 1.9% | 17.07 ± 0.3% | 79.51 ± 0.3% | 21225.51 ± 1.3% | 4.36 | 1.01 | 1.10 | 0.75 |
| literal: one of four words | 661 | 6358.36 ± 0.2% | 1946.42 ± 0.1% | 14.37 ± 0.2% | 3942.84 ± 0.2% | 21.89 ± 0.2% | 5.35 ± 0.4% | 6.87 ± 0.7% | 6347.85 ± 0.2% | 3.27 | 1.00 | 1.61 | 290.44 |
| literal: a word in any case | 217 | 15069.96 ± 0.9% | 2085.66 ± 0.2% | 21.30 ± 0.1% | 3972.26 ± 0.5% | 38.02 ± 0.8% | refused | differs | 15132.36 ± 1.1% | 7.23 | 1.00 | 3.79 | 396.40 |
| literal: an href attribute | 33 | 16536.50 ± 3.1% | 608.14 ± 0.5% | 27.14 ± 0.3% | 16861.27 ± 1.0% | 2253.52 ± 1.2% | 13.12 ± 0.4% | 73.99 ± 0.5% | 16478.36 ± 1.6% | 27.19 | 1.00 | 0.98 | 7.34 |
| literal: a word, second text | 123 | 19478.42 ± 2.3% | 3381.86 ± 0.1% | 27.71 ± 0.3% | 18177.42 ± 2.2% | 7586.01 ± 5.5% | 20.10 ± 0.4% | 69.92 ± 0.6% | 19466.28 ± 2.5% | 5.76 | 1.00 | 1.07 | 2.57 |
| class: two capitalized words | 1331 | 1069.25 ± 0.4% | 598.72 ± 0.1% | 26.02 ± 0.2% | 585.14 ± 0.0% | 40.58 ± 2.4% | 14.72 ± 0.2% | 67.50 ± 0.2% | 1069.83 ± 0.2% | 1.79 | 1.00 | 1.83 | 26.35 |
| class: a word that ends in ing | 3399 | 573.39 ± 0.2% | 573.01 ± 0.4% | 17.97 ± 2.4% | 547.24 ± 0.1% | 29.65 ± 9.6% | 8.13 ± 0.2% | 18.40 ± 0.3% | 573.51 ± 0.1% | 1.00 | 1.00 | 1.05 | 19.34 |
| class: a word in capitals | 2332 | 1372.09 ± 0.7% | 604.34 ± 0.2% | 27.53 ± 0.4% | 572.36 ± 0.1% | 43.68 ± 0.8% | 16.85 ± 0.3% | 82.43 ± 0.5% | 1378.64 ± 0.3% | 2.27 | 1.00 | 2.40 | 31.41 |
| class: a number | 8288 | 1995.62 ± 0.3% | 827.83 ± 0.1% | 27.57 ± 0.6% | 1727.82 ± 0.7% | 40.67 ± 16.0% | 0.54 ± 0.1% | 57.37 ± 0.2% | 1999.61 ± 0.3% | 2.41 | 1.00 | 1.15 | 49.07 |
| class: two capitalized words, second text | 5359 | 514.98 ± 0.1% | 523.20 ± 0.3% | 23.32 ± 0.2% | 484.79 ± 0.2% | 32.75 ± 7.7% | 17.09 ± 0.1% | 62.81 ± 0.2% | 516.00 ± 0.3% | 0.98 | 1.00 | 1.06 | 15.72 |
| other: a word between two words | 6104 | 788.87 ± 0.2% | 591.84 ± 0.2% | 23.49 ± 0.1% | 736.48 ± 0.2% | 101.67 ± 16.6% | 11.17 ± 0.2% | 68.19 ± 0.3% | 788.24 ± 0.2% | 1.33 | 1.00 | 1.07 | 7.76 |
| other: a number before a unit, second text | 1481 | 5929.07 ± 0.9% | 1113.80 ± 0.2% | 25.92 ± 0.1% | 5665.95 ± 0.7% | 40.75 ± 10.3% | 18.20 ± 0.2% | 65.75 ± 0.2% | 5947.64 ± 0.8% | 5.32 | 1.00 | 1.05 | 145.49 |
| other: a heading's start tag | 110 | 13723.67 ± 5.3% | 742.69 ± 0.2% | 27.27 ± 0.2% | 1708.73 ± 0.2% | 1572.47 ± 1.1% | 15.96 ± 0.7% | 86.19 ± 0.5% | 13926.17 ± 1.5% | 18.48 | 0.99 | 8.03 | 8.73 |
| other: a whole word | 217 | 15728.95 ± 3.8% | 602.80 ± 0.4% | 29.25 ± 0.4% | 14684.85 ± 0.8% | 49.37 ± 9.7% | 13.23 ± 0.3% | 55.05 ± 0.3% | 15682.49 ± 2.6% | 26.09 | 1.00 | 1.07 | 318.58 |
| other: a line's first word, second text | 3716 | 2043.42 ± 0.8% | 587.34 ± 0.2% | 30.91 ± 0.3% | 1725.71 ± 0.6% | 62.93 ± 5.0% | refused | refused | 2055.94 ± 1.1% | 3.48 | 0.99 | 1.18 | 32.47 |
| other: fourteen octets before an x | 87 | 23692.06 ± 1.9% | 240.69 ± 0.5% | 6.31 ± 0.1% | 3910.74 ± 1.7% | 10.64 ± 0.1% | differs | 17.75 ± 0.1% | 23641.62 ± 8.3% | 98.43 | 1.00 | 6.06 | 2226.96 |
| other: a Greek word | 21815 | 497.22 ± 1.0% | 411.88 ± 0.3% | 29.73 ± 0.1% | 290.17 ± 0.2% | 48.34 ± 10.7% | differs | refused | 499.50 ± 0.8% | 1.21 | 1.00 | 1.71 | 10.29 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.61 ± 0.5% | 19.60 ± 0.3% | 0.85 ± 0.1% | 19.84 ± 0.4% | 2.78 ± 0.8% | differs | 3.96 ± 0.3% | 19.58 ± 0.2% | 1.00 | 1.00 | 0.99 | 7.05 |
| a UUID | 32895 | 21.14 ± 0.2% | 21.11 ± 0.4% | 0.64 ± 0.1% | 15.21 ± 0.1% | 3.10 ± 1.0% | 0.73 ± 0.2% | 3.65 ± 0.4% | 21.09 ± 0.2% | 1.00 | 1.00 | 1.39 | 6.83 |
| an IPv4 address | 33176 | 36.01 ± 0.2% | 35.97 ± 0.1% | 2.05 ± 0.1% | 29.10 ± 0.1% | 6.67 ± 0.3% | differs | 4.18 ± 0.1% | 35.96 ± 0.2% | 1.00 | 1.00 | 1.24 | 5.40 |
| a date and time | 32954 | 31.03 ± 0.3% | 31.08 ± 0.5% | 1.43 ± 0.2% | 21.58 ± 0.2% | 7.05 ± 0.7% | 1.25 ± 0.4% | 7.16 ± 0.2% | 31.09 ± 0.6% | 1.00 | 1.00 | 1.44 | 4.40 |
| a field path | 32606 | 23.20 ± 0.2% | 23.16 ± 0.1% | 1.01 ± 0.1% | 23.30 ± 0.2% | 3.50 ± 0.8% | differs | 2.99 ± 0.1% | 23.16 ± 0.1% | 1.00 | 1.00 | 1.00 | 6.62 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.10 ± 0.5% | 11.20 ± 0.6% | 11.15 ± 1.3% | 11.46 ± 0.2% | 4.94 ± 1.0% | 0.94 ± 0.4% | none | 11.16 ± 0.9% | 0.99 | 1.00 | 0.97 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 231.68 ± 0.1% | 232.92 ± 0.1% | 275.03 ± 0.2% | 86.60 ± 0.8% | 218.79 ± 0.4% | 480.66 ± 0.9% | 3804.90 ± 0.4% | 231.83 ± 0.2% | 0.99 | 1.00 | 2.68 | 1.06 |
| a UUID | 62 | 152.95 ± 0.4% | 153.30 ± 0.4% | 170.53 ± 0.3% | 45.93 ± 0.5% | 98.16 ± 1.1% | 186.54 ± 2.6% | 4168.68 ± 1.0% | 152.93 ± 0.2% | 1.00 | 1.00 | 3.33 | 1.56 |
| an IPv4 address | 29 | 426.48 ± 0.2% | 431.17 ± 0.4% | 598.45 ± 0.3% | 78.82 ± 1.7% | 129.82 ± 1.1% | 307.99 ± 1.9% | 7501.64 ± 0.4% | 427.39 ± 0.3% | 0.99 | 1.00 | 5.41 | 3.29 |
| a date and time | 56 | 307.15 ± 0.3% | 310.06 ± 0.2% | 387.50 ± 0.1% | 73.93 ± 0.5% | 135.21 ± 1.8% | 329.93 ± 1.1% | 4794.97 ± 0.7% | 307.13 ± 0.2% | 0.99 | 1.00 | 4.15 | 2.27 |
| a field path | 39 | 225.40 ± 0.3% | 226.18 ± 0.3% | 265.41 ± 0.3% | 79.86 ± 0.8% | 202.55 ± 0.7% | 510.48 ± 4.1% | 4866.18 ± 0.7% | 225.38 ± 0.4% | 1.00 | 1.00 | 2.82 | 1.11 |
| literal: a word | 7 | 632.31 ± 0.6% | 684.53 ± 0.4% | 1229.22 ± 0.6% | 496.01 ± 0.3% | 626.24 ± 2.3% | 960.69 ± 0.7% | 31035.03 ± 0.2% | 632.77 ± 0.4% | 0.92 | 1.00 | 1.27 | 1.01 |
| literal: a word that is not there | 8 | 608.34 ± 0.4% | 661.25 ± 0.7% | 1160.62 ± 0.8% | 456.10 ± 0.1% | 598.32 ± 2.3% | 907.34 ± 0.7% | 29640.47 ± 0.4% | 608.65 ± 0.4% | 0.92 | 1.00 | 1.33 | 1.02 |
| literal: one of four words | 26 | 245.66 ± 0.4% | 398.33 ± 0.3% | 542.38 ± 0.5% | 50.64 ± 0.6% | 239.29 ± 2.1% | 368.57 ± 0.8% | 16143.69 ± 0.2% | 245.55 ± 0.4% | 0.62 | 1.00 | 4.85 | 1.03 |
| literal: a word in any case | 11 | 453.13 ± 0.3% | 484.95 ± 0.2% | 713.89 ± 0.1% | 15.58 ± 0.3% | 639.36 ± 8.4% | refused | 23957.21 ± 0.3% | 453.88 ± 0.3% | 0.93 | 1.00 | 29.08 | 0.71 |
| literal: an href attribute | 12 | 347.60 ± 0.4% | 359.34 ± 0.3% | 470.51 ± 0.3% | 45.05 ± 0.4% | 492.73 ± 2.2% | 774.68 ± 0.7% | 22270.67 ± 0.3% | 347.67 ± 0.3% | 0.97 | 1.00 | 7.72 | 0.71 |
| literal: a word, second text | 10 | 564.10 ± 0.2% | 624.32 ± 0.4% | 1045.15 ± 0.9% | 406.95 ± 0.4% | 534.32 ± 2.1% | 807.97 ± 0.6% | 27791.86 ± 0.2% | 563.67 ± 0.5% | 0.90 | 1.00 | 1.39 | 1.06 |
| class: two capitalized words | 23 | 438.74 ± 0.6% | 470.51 ± 0.8% | 674.37 ± 0.8% | 101.62 ± 1.7% | 498.94 ± 1.2% | 747.85 ± 0.6% | 6503.87 ± 0.4% | 439.49 ± 0.3% | 0.93 | 1.00 | 4.32 | 0.88 |
| class: a word that ends in ing | 9 | 569.28 ± 0.4% | 636.02 ± 0.6% | 1115.17 ± 0.2% | 132.02 ± 0.6% | 753.25 ± 1.5% | 1109.35 ± 0.4% | 16057.19 ± 1.4% | 569.75 ± 0.2% | 0.90 | 1.00 | 4.31 | 0.76 |
| class: a word in capitals | 16 | 496.29 ± 0.1% | 539.11 ± 0.3% | 850.30 ± 0.3% | 134.46 ± 1.2% | 743.56 ± 0.5% | 1011.40 ± 1.2% | 8602.44 ± 0.1% | 496.21 ± 0.2% | 0.92 | 1.00 | 3.69 | 0.67 |
| class: a number | 6 | 632.42 ± 0.4% | 696.62 ± 0.4% | 1298.96 ± 0.1% | 41.85 ± 1.2% | 1391.19 ± 3.1% | 1861.38 ± 0.8% | 23299.77 ± 0.1% | 632.59 ± 0.2% | 0.91 | 1.00 | 15.11 | 0.45 |
| class: two capitalized words, second text | 23 | 439.18 ± 0.2% | 471.77 ± 0.4% | 674.98 ± 0.3% | 100.68 ± 1.7% | 497.51 ± 2.5% | 760.44 ± 0.7% | 6500.43 ± 0.1% | 439.26 ± 0.4% | 0.93 | 1.00 | 4.36 | 0.88 |
| other: a word between two words | 13 | 550.21 ± 0.3% | 569.68 ± 0.3% | 903.77 ± 0.5% | 133.39 ± 0.3% | 497.14 ± 3.1% | 812.97 ± 0.3% | 14725.29 ± 0.4% | 550.41 ± 1.0% | 0.97 | 1.00 | 4.12 | 1.11 |
| other: a number before a unit, second text | 15 | 403.13 ± 0.2% | 442.46 ± 0.3% | 620.15 ± 0.3% | 39.34 ± 0.4% | 629.38 ± 1.4% | 888.65 ± 0.4% | 15403.33 ± 0.3% | 402.72 ± 0.4% | 0.91 | 1.00 | 10.25 | 0.64 |
| other: a heading's start tag | 13 | 359.87 ± 0.5% | 366.99 ± 0.4% | 480.84 ± 0.3% | 42.85 ± 0.3% | 624.97 ± 1.2% | 859.28 ± 0.2% | 18454.90 ± 0.7% | 360.46 ± 0.2% | 0.98 | 1.00 | 8.40 | 0.58 |
| other: a whole word | 11 | 582.87 ± 0.9% | 620.39 ± 0.3% | 1041.23 ± 0.3% | 120.68 ± 0.1% | 559.10 ± 1.2% | 825.43 ± 0.4% | 27470.33 ± 0.5% | 582.00 ± 0.7% | 0.94 | 1.00 | 4.83 | 1.04 |
| other: a line's first word, second text | 17 | 530.15 ± 1.1% | 556.21 ± 0.5% | 889.79 ± 0.5% | 130.20 ± 0.2% | 706.52 ± 1.0% | refused | refused | 530.96 ± 0.4% | 0.95 | 1.00 | 4.07 | 0.75 |
| other: fourteen octets before an x | 16 | 109.99 ± 0.4% | 157.46 ± 0.8% | 180.46 ± 0.9% | 15.20 ± 0.5% | 451.85 ± 3.0% | 416.79 ± 0.7% | 13009.09 ± 0.3% | 109.96 ± 0.6% | 0.70 | 1.00 | 7.24 | 0.24 |
| other: a Greek word | 8 | 453.61 ± 0.4% | 602.88 ± 0.4% | 1012.45 ± 0.6% | 59.03 ± 0.6% | 1380.94 ± 9.0% | 1810.91 ± 0.3% | refused | 453.69 ± 0.1% | 0.75 | 1.00 | 7.68 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15406.86 ± 1.2% | not timed | not timed | 15966.52 ± 1.9% | 1975.21 ± 11.7% | not timed | not timed | 15388.27 ± 0.9% | | 1.00 | 0.96 | 7.80 |
| 01-literal/sherlock-casei-en | 522 | 11013.32 ± 5.5% | not timed | not timed | 3590.89 ± 0.2% | 32.45 ± 0.5% | not timed | not timed | 10999.37 ± 0.8% | | 1.00 | 3.07 | 339.38 |
| 01-literal/sherlock-ru | 724 | 17031.08 ± 1.1% | not timed | not timed | 17138.92 ± 1.6% | 1314.89 ± 9.9% | not timed | not timed | 17092.40 ± 1.1% | | 1.00 | 0.99 | 12.95 |
| 01-literal/sherlock-casei-ru | 746 | 6181.39 ± 0.4% | not timed | not timed | 3333.25 ± 0.1% | 30.63 ± 0.4% | not timed | not timed | 6175.37 ± 0.4% | | 1.00 | 1.85 | 201.84 |
| 01-literal/sherlock-zh | 30 | 19117.42 ± 0.2% | not timed | not timed | 18199.05 ± 0.6% | 2673.19 ± 22.0% | not timed | not timed | 19189.91 ± 0.7% | | 1.00 | 1.05 | 7.15 |
| 02-literal-alternate/sherlock-en | 714 | 6040.90 ± 0.6% | not timed | not timed | 3938.73 ± 0.3% | 16.64 ± 0.1% | not timed | not timed | 6042.28 ± 0.4% | | 1.00 | 1.53 | 362.99 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1978.34 ± 1.0% | not timed | not timed | 698.35 ± 0.2% | 11.03 ± 0.1% | not timed | not timed | 1980.81 ± 0.7% | | 1.00 | 2.83 | 179.36 |
| 02-literal-alternate/sherlock-ru | 899 | 5566.02 ± 0.4% | not timed | not timed | 3259.96 ± 0.1% | 22.61 ± 0.4% | not timed | not timed | 5563.29 ± 0.1% | | 1.00 | 1.71 | 246.21 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2054.69 ± 0.5% | not timed | not timed | 1233.78 ± 0.1% | 9.11 ± 0.1% | not timed | not timed | 2057.26 ± 0.3% | | 1.00 | 1.67 | 225.47 |
| 02-literal-alternate/sherlock-zh | 207 | 7301.25 ± 0.1% | not timed | not timed | 4160.10 ± 0.1% | 31.46 ± 0.1% | not timed | not timed | 7303.38 ± 0.2% | | 1.00 | 1.76 | 232.09 |
| 03-date/ascii | 111817 | 124.24 ± 0.5% | not timed | not timed | 95.92 ± 0.2% | 0.20 ± 1.6% | not timed | not timed | 124.62 ± 0.7% | | 1.00 | 1.30 | 632.66 |
| 04-ruff-noqa/real | 84 | 404.06 ± 0.4% | not timed | not timed | 470.53 ± 0.1% | 19.73 ± 1.4% | not timed | not timed | 403.29 ± 0.1% | | 1.00 | 0.86 | 20.48 |
| 04-ruff-noqa/tweaked | 44 | 556.05 ± 0.4% | not timed | not timed | 460.09 ± 0.1% | 364.55 ± 0.4% | not timed | not timed | 555.63 ± 0.3% | | 1.00 | 1.21 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.54 ± 0.5% | not timed | not timed | 5.18 ± 0.2% | 0.20 ± 6.5% | not timed | not timed | 5.40 ± 0.9% | | 1.03 | 1.07 | 27.06 |
| 06-cloud-flare-redos/original | 107 | 415.04 ± 0.2% | not timed | not timed | 214.80 ± 0.2% | 24.93 ± 0.1% | not timed | not timed | 415.70 ± 0.1% | | 1.00 | 1.93 | 16.65 |
| 06-cloud-flare-redos/simplified-short | 102 | 415.73 ± 0.2% | not timed | not timed | 227.82 ± 0.0% | 26.72 ± 0.1% | not timed | not timed | 410.42 ± 0.2% | | 1.01 | 1.82 | 15.56 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.10 ± 0.3% | not timed | not timed | 253.65 ± 0.1% | 28.70 ± 0.1% | not timed | not timed | 578.26 ± 0.1% | | 1.02 | 2.32 | 20.49 |
| 07-unicode-character-data/parse-line | 558784 | 237.58 ± 2.1% | not timed | not timed | 181.18 ± 1.7% | 42.30 ± 13.1% | not timed | not timed | 238.61 ± 4.1% | | 1.00 | 1.31 | 5.62 |
| 08-words/all-english | 56691 | 116.13 ± 0.6% | not timed | not timed | 82.83 ± 0.1% | 12.96 ± 17.1% | not timed | not timed | 117.26 ± 0.8% | | 0.99 | 1.40 | 8.96 |
| 08-words/long-english | 839 | 614.25 ± 0.2% | not timed | not timed | 593.72 ± 0.3% | 32.62 ± 0.4% | not timed | not timed | 614.29 ± 0.3% | | 1.00 | 1.03 | 18.83 |
| 09-aws-keys/full | 0 | 408.13 ± 0.1% | not timed | not timed | 494.07 ± 0.6% | 64.34 ± 3.5% | not timed | not timed | 408.87 ± 0.2% | | 1.00 | 0.83 | 6.34 |
| 09-aws-keys/quick | 0 | 872.48 ± 0.3% | not timed | not timed | 995.33 ± 0.5% | 418.65 ± 1.0% | not timed | not timed | 872.47 ± 0.2% | | 1.00 | 0.88 | 2.08 |
| 10-bounded-repeat/letters-en | 1833 | 582.47 ± 1.9% | not timed | not timed | 516.72 ± 0.2% | 19.54 ± 0.8% | not timed | not timed | 582.45 ± 2.6% | | 1.00 | 1.13 | 29.81 |
| 10-bounded-repeat/letters-ru | 3475 | 510.60 ± 1.7% | not timed | not timed | 479.08 ± 0.2% | 22.14 ± 9.5% | not timed | not timed | 511.27 ± 0.6% | | 1.00 | 1.07 | 23.06 |
| 10-bounded-repeat/context | 53 | 85.08 ± 2.6% | not timed | not timed | 65.75 ± 1.7% | 19.57 ± 0.2% | not timed | not timed | 85.33 ± 1.5% | | 1.00 | 1.29 | 4.35 |
| 10-bounded-repeat/capitals | 11 | 641.14 ± 8.0% | not timed | not timed | 618.44 ± 0.1% | 36.49 ± 0.1% | not timed | not timed | 641.15 ± 8.0% | | 1.00 | 1.04 | 17.57 |
| 11-unstructured-to-json/extract | 600 | 56.63 ± 0.7% | not timed | not timed | 76.59 ± 0.4% | 48.98 ± 1.1% | not timed | not timed | 56.74 ± 1.4% | | 1.00 | 0.74 | 1.16 |
| 12-dictionary/single | 1 | 567.28 ± 0.5% | not timed | not timed | 560.35 ± 0.5% | 0.41 ± 0.0% | not timed | not timed | 567.92 ± 0.2% | | 1.00 | 1.01 | 1399.82 |
| 14-quadratic/1x | 100 | 21.11 ± 3.2% | not timed | not timed | 9.98 ± 0.2% | 0.98 ± 3.4% | not timed | not timed | 21.23 ± 1.7% | | 0.99 | 2.12 | 21.60 |
| 14-quadratic/2x | 200 | 17.42 ± 1.4% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 1.7% | not timed | not timed | 17.46 ± 0.8% | | 1.00 | 3.14 | 32.65 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 7.69 ± 0.7% | | 1.00 | 6.38 | 66.60 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 2.9% | not timed | not timed | 0.34 ± 0.4% | 0.54 ± 4.1% | not timed | not timed | 1.27 ± 0.1% | | 1.00 | 3.70 | 2.34 |
| 04-ruff-noqa/compile-real | 1 | 106.64 ± 1.7% | not timed | not timed | 13.89 ± 0.4% | 137.34 ± 3.7% | not timed | not timed | 106.94 ± 0.5% | | 1.00 | 7.68 | 0.78 |
| 05-lexer-veryl/compile-single | 1 | 14.10 ± 1.1% | not timed | not timed | 2.53 ± 0.7% | 6.41 ± 1.3% | not timed | not timed | 14.10 ± 1.5% | | 1.00 | 5.58 | 2.20 |
| 07-unicode-character-data/compile | 1 | 109.19 ± 0.5% | not timed | not timed | 26.08 ± 0.2% | 35.49 ± 5.2% | not timed | not timed | 109.44 ± 0.2% | | 1.00 | 4.19 | 3.08 |
| 09-aws-keys/compile-full | 1 | 53.65 ± 0.5% | not timed | not timed | 8.34 ± 0.5% | 22.95 ± 0.8% | not timed | not timed | 53.58 ± 0.2% | | 1.00 | 6.43 | 2.34 |
| 09-aws-keys/compile-quick | 1 | 189.25 ± 0.4% | not timed | not timed | 48.01 ± 0.3% | 131.45 ± 4.5% | not timed | not timed | 190.07 ± 0.5% | | 1.00 | 3.94 | 1.44 |
| 10-bounded-repeat/compile-context | 1 | 72.86 ± 3.0% | not timed | not timed | 11.13 ± 0.3% | 15.78 ± 1.6% | not timed | not timed | 73.12 ± 2.2% | | 1.00 | 6.54 | 4.62 |
| 10-bounded-repeat/compile-capitals | 1 | 84.33 ± 0.9% | not timed | not timed | 7.98 ± 0.4% | 23.30 ± 2.7% | not timed | not timed | 85.21 ± 0.4% | | 0.99 | 10.57 | 3.62 |
| 11-unstructured-to-json/compile | 1 | 173.35 ± 1.3% | not timed | not timed | 41.11 ± 1.1% | 67.23 ± 2.2% | not timed | not timed | 173.99 ± 1.0% | | 1.00 | 4.22 | 2.58 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.4% | not timed | not timed | 0.07 ± 0.5% | 0.09 ± 7.4% | not timed | not timed | 0.35 ± 3.9% | | 1.00 | 5.22 | 3.73 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.63 ± 1.2% | not timed | not timed | 6.56 ± 0.2% | 0.53 ± 1.3% | not timed | not timed | 7.60 ± 0.9% | | 1.00 | 1.16 | 14.38 |
| dictionary/search/english-10 | 690 | 1.05 ± 0.3% | not timed | not timed | 164.92 ± 0.8% | 0.00 ± 1.0% | not timed | not timed | 1.05 ± 0.7% | | 1.00 | 0.0063 | 406.67 |
| dictionary/search/english-15 | 15 | 560.22 ± 0.5% | not timed | not timed | 561.78 ± 0.2% | 0.37 ± 0.3% | not timed | not timed | 560.45 ± 0.5% | | 1.00 | 1.00 | 1520.91 |
| folly/awyer-inn-busted | 1 | 5586.65 ± 0.1% | not timed | not timed | 143.42 ± 0.2% | 44.09 ± 0.4% | not timed | not timed | 5573.57 ± 0.1% | | 1.00 | 38.95 | 126.72 |
| folly/literal-never-match-rare | 0 | 21026.00 ± 0.6% | not timed | not timed | 19827.91 ± 0.5% | 40697.68 ± 0.9% | not timed | not timed | 21009.65 ± 1.2% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12485.83 ± 13.8% | not timed | not timed | 19680.94 ± 0.9% | 2193.12 ± 0.3% | not timed | not timed | 12477.61 ± 14.0% | | 1.00 | 0.63 | 5.69 |
| folly/literal-never-match-tricksy | 1 | 3248.54 ± 0.4% | not timed | not timed | 4409.93 ± 0.2% | 3056.75 ± 0.2% | not timed | not timed | 3254.50 ± 0.3% | | 1.00 | 0.74 | 1.06 |
| grep/every-line | 239963 | 1306.32 ± 0.6% | not timed | not timed | 958.46 ± 0.2% | 383.00 ± 20.6% | not timed | not timed | 1309.52 ± 0.5% | | 1.00 | 1.36 | 3.41 |
| grep/long-words-ascii | 5073 | 459.93 ± 0.1% | not timed | not timed | 470.12 ± 0.1% | 46.23 ± 8.2% | not timed | not timed | 436.10 ± 0.7% | | 1.05 | 0.98 | 9.95 |
| imported/leipzig/twain | 811 | 20378.74 ± 2.5% | not timed | not timed | 19211.87 ± 2.1% | 11677.17 ± 10.9% | not timed | not timed | 20494.32 ± 1.5% | | 0.99 | 1.06 | 1.75 |
| imported/leipzig/twain-insensitive | 965 | 8980.23 ± 1.0% | not timed | not timed | 4235.19 ± 0.2% | 37.32 ± 0.0% | not timed | not timed | 9019.69 ± 1.3% | | 1.00 | 2.12 | 240.65 |
| imported/leipzig/shing | 1540 | 629.37 ± 0.0% | not timed | not timed | 13103.18 ± 1.4% | 33.60 ± 0.1% | not timed | not timed | 631.65 ± 0.1% | | 1.00 | 0.0480 | 18.73 |
| imported/leipzig/huck-saw | 262 | 8151.02 ± 2.3% | not timed | not timed | 5574.07 ± 0.7% | 31.13 ± 0.5% | not timed | not timed | 8275.26 ± 2.3% | | 0.98 | 1.46 | 261.82 |
| imported/leipzig/word-ending-nn | 262 | 609.04 ± 0.3% | not timed | not timed | 616.20 ± 0.1% | 24.53 ± 0.4% | not timed | not timed | 611.27 ± 0.0% | | 1.00 | 0.99 | 24.83 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11022.78 ± 1.1% | not timed | not timed | 4452.23 ± 2.4% | 11.38 ± 0.1% | not timed | not timed | 10999.94 ± 1.8% | | 1.00 | 2.48 | 968.38 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7719.87 ± 1.3% | not timed | not timed | 5449.73 ± 0.6% | 16.58 ± 0.1% | not timed | not timed | 7743.14 ± 1.2% | | 1.00 | 1.42 | 465.60 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4179.39 ± 0.6% | not timed | not timed | 405.83 ± 1.5% | 10.98 ± 0.1% | not timed | not timed | 4179.33 ± 0.8% | | 1.00 | 10.30 | 380.75 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 609.28 ± 0.2% | not timed | not timed | 614.79 ± 0.1% | 10.85 ± 0.0% | not timed | not timed | 609.73 ± 0.1% | | 1.00 | 0.99 | 56.17 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.69 ± 0.0% | not timed | not timed | 615.33 ± 0.1% | 9.53 ± 0.1% | not timed | not timed | 610.38 ± 0.1% | | 1.00 | 0.99 | 64.01 |
| imported/leipzig/tom-river | 2 | 6452.11 ± 2.5% | not timed | not timed | 5124.53 ± 0.9% | 30.37 ± 0.2% | not timed | not timed | 6471.11 ± 2.0% | | 1.00 | 1.26 | 212.47 |
| imported/leipzig/ing | 78424 | 608.76 ± 0.4% | not timed | not timed | 570.56 ± 0.1% | 27.99 ± 3.1% | not timed | not timed | 607.25 ± 0.7% | | 1.00 | 1.07 | 21.75 |
| imported/leipzig/ing-whitespace | 55248 | 756.94 ± 0.8% | not timed | not timed | 2063.01 ± 0.7% | 20.54 ± 2.8% | not timed | not timed | 757.04 ± 0.3% | | 1.00 | 0.37 | 36.84 |
| imported/leipzig/awyer-inn | 209 | 774.45 ± 1.5% | not timed | not timed | 4165.47 ± 2.8% | 22.44 ± 0.0% | not timed | not timed | 774.99 ± 1.5% | | 1.00 | 0.19 | 34.52 |
| imported/leipzig/quotes-bounded | 8886 | 2118.38 ± 0.4% | not timed | not timed | 2960.60 ± 1.2% | 37.96 ± 0.0% | not timed | not timed | 2111.47 ± 0.5% | | 1.00 | 0.72 | 55.80 |
| imported/leipzig/non-ascii-alternate | 2 | 12667.90 ± 3.8% | not timed | not timed | 5634.72 ± 0.3% | 50.40 ± 0.2% | not timed | not timed | 12634.27 ± 2.2% | | 1.00 | 2.25 | 251.35 |
| imported/leipzig/math-symbols | 69 | 1976.84 ± 0.4% | not timed | not timed | 613.59 ± 0.1% | 36.47 ± 0.1% | not timed | not timed | 1973.73 ± 0.3% | | 1.00 | 3.22 | 54.21 |
| imported/leipzig/bounded-strings-ending-z | 0 | 596.21 ± 0.3% | not timed | not timed | 617.68 ± 0.0% | 22.18 ± 0.5% | not timed | not timed | 593.19 ± 0.2% | | 1.01 | 0.97 | 26.88 |
| imported/lh3lh3-reb/uri | 17549 | 633.13 ± 0.1% | not timed | not timed | 1072.39 ± 0.1% | 28.10 ± 2.5% | not timed | not timed | 633.36 ± 0.2% | | 1.00 | 0.59 | 22.53 |
| imported/lh3lh3-reb/email | 15057 | 668.00 ± 0.1% | not timed | not timed | 1172.19 ± 0.2% | 30.80 ± 2.4% | not timed | not timed | 669.44 ± 0.1% | | 1.00 | 0.57 | 21.69 |
| imported/lh3lh3-reb/date | 668 | 866.24 ± 0.2% | not timed | not timed | 1046.68 ± 0.3% | 51.00 ± 1.2% | not timed | not timed | 866.32 ± 0.2% | | 1.00 | 0.83 | 16.98 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 642.50 ± 0.1% | not timed | not timed | 423.28 ± 0.3% | 15.78 ± 1.2% | not timed | not timed | 643.15 ± 0.0% | | 1.00 | 1.52 | 40.71 |
| imported/mariomka/email | 92 | 705.53 ± 0.1% | not timed | not timed | 29213.69 ± 0.6% | 32.82 ± 0.1% | not timed | not timed | 706.06 ± 0.1% | | 1.00 | 0.0242 | 21.50 |
| imported/mariomka/uri | 5301 | 607.94 ± 0.1% | not timed | not timed | 5964.80 ± 1.8% | 32.48 ± 0.7% | not timed | not timed | 605.21 ± 0.1% | | 1.00 | 0.10 | 18.72 |
| imported/mariomka/ip | 5 | 2160.16 ± 1.7% | not timed | not timed | 2963.55 ± 0.5% | 20.94 ± 0.4% | not timed | not timed | 2156.52 ± 2.5% | | 1.00 | 0.73 | 103.15 |
| imported/rsc/no-exponential | 0 | 565.16 ± 0.2% | not timed | not timed | 320.08 ± 0.2% | 23.84 ± 0.2% | not timed | not timed | 565.01 ± 0.1% | | 1.00 | 1.77 | 23.70 |
| imported/rsc/literal | 1 | 749.44 ± 3.0% | not timed | not timed | 1553.82 ± 2.9% | 188.64 ± 15.4% | not timed | not timed | 750.76 ± 3.8% | | 1.00 | 0.48 | 3.97 |
| imported/rsc/not-literal | 2 | 706.06 ± 7.6% | not timed | not timed | 716.14 ± 0.2% | 46.31 ± 1.8% | not timed | not timed | 705.44 ± 0.1% | | 1.00 | 0.99 | 15.25 |
| imported/rsc/match-class | 1 | 1291.39 ± 9.3% | not timed | not timed | 1627.32 ± 0.3% | 58.95 ± 28.8% | not timed | not timed | 1305.79 ± 0.2% | | 0.99 | 0.79 | 21.91 |
| imported/rsc/match-class-in-range | 1 | 1299.39 ± 2.0% | not timed | not timed | 2347.88 ± 3.0% | 60.22 ± 6.7% | not timed | not timed | 1310.70 ± 0.4% | | 0.99 | 0.55 | 21.58 |
| imported/rsc/match-class-unicode | 1 | 524.65 ± 0.1% | not timed | not timed | 508.29 ± 0.1% | 72.73 ± 0.4% | not timed | not timed | 523.87 ± 0.1% | | 1.00 | 1.03 | 7.21 |
| imported/rsc/anchored-literal-short-non-match | 0 | 541.12 ± 0.4% | not timed | not timed | 924.46 ± 0.2% | 227.39 ± 0.4% | not timed | not timed | 538.35 ± 0.3% | | 1.01 | 0.59 | 2.38 |
| imported/rsc/anchored-literal-long-non-match | 0 | 8048.32 ± 0.2% | not timed | not timed | 14207.62 ± 0.1% | 3417.47 ± 0.3% | not timed | not timed | 8024.79 ± 0.1% | | 1.00 | 0.57 | 2.36 |
| imported/rsc/anchored-literal-short-match | 4 | 420.05 ± 2.0% | not timed | not timed | 479.84 ± 0.4% | 84.40 ± 9.1% | not timed | not timed | 421.02 ± 9.1% | | 1.00 | 0.88 | 4.98 |
| imported/rsc/anchored-literal-long-match | 4 | 3011.29 ± 1.9% | not timed | not timed | 7281.70 ± 0.1% | 1252.81 ± 9.0% | not timed | not timed | 3016.90 ± 1.6% | | 1.00 | 0.41 | 2.40 |
| imported/rsc/one-pass-short | 17 | 310.81 ± 2.1% | not timed | not timed | 215.54 ± 0.3% | 30.89 ± 9.9% | not timed | not timed | 309.27 ± 8.8% | | 1.00 | 1.44 | 10.06 |
| imported/rsc/one-pass-short-not | 17 | 219.45 ± 5.9% | not timed | not timed | 223.96 ± 0.1% | 30.38 ± 9.2% | not timed | not timed | 218.71 ± 2.1% | | 1.00 | 0.98 | 7.22 |
| imported/rsc/one-pass-long-prefix | 26 | 236.10 ± 10.6% | not timed | not timed | 283.47 ± 0.4% | 95.02 ± 16.1% | not timed | not timed | 239.00 ± 2.6% | | 0.99 | 0.83 | 2.48 |
| imported/rsc/one-pass-long-prefix-not | 26 | 310.88 ± 1.8% | not timed | not timed | 279.49 ± 0.3% | 65.89 ± 19.2% | not timed | not timed | 307.76 ± 1.6% | | 1.01 | 1.11 | 4.72 |
| imported/rsc/long-needle1 | 31 | 21912.93 ± 0.1% | not timed | not timed | 20130.00 ± 0.1% | 3.73 ± 0.1% | not timed | not timed | 21919.71 ± 0.1% | | 1.00 | 1.09 | 5869.12 |
| imported/rsc/long-needle2 | 31 | 22100.78 ± 0.1% | not timed | not timed | 216.27 ± 0.2% | 3.73 ± 0.4% | not timed | not timed | 22109.06 ± 0.2% | | 1.00 | 102.19 | 5927.17 |
| imported/rsc/easy0-32 | 26 | 1073.22 ± 0.3% | not timed | not timed | 1505.45 ± 0.3% | 147.76 ± 20.0% | not timed | not timed | 1070.38 ± 3.4% | | 1.00 | 0.71 | 7.26 |
| imported/rsc/easy0-1k | 26 | 14995.28 ± 2.2% | not timed | not timed | 12402.50 ± 0.2% | 2309.41 ± 16.2% | not timed | not timed | 14995.96 ± 0.2% | | 1.00 | 1.21 | 6.49 |
| imported/rsc/easy0-32k | 26 | 22895.36 ± 0.2% | not timed | not timed | 20467.87 ± 0.2% | 18617.76 ± 0.4% | not timed | not timed | 22906.50 ± 0.2% | | 1.00 | 1.12 | 1.23 |
| imported/rsc/easy0-1mb | 26 | 21438.29 ± 2.6% | not timed | not timed | 19631.50 ± 2.2% | 35163.12 ± 3.0% | not timed | not timed | 21243.88 ± 0.7% | | 1.01 | 1.09 | 0.61 |
| imported/rsc/easy1-32 | 19 | 359.82 ± 2.0% | not timed | not timed | 629.56 ± 0.1% | 126.63 ± 18.4% | not timed | not timed | 359.79 ± 2.8% | | 1.00 | 0.57 | 2.84 |
| imported/rsc/easy1-1k | 19 | 585.14 ± 0.1% | not timed | not timed | 12803.96 ± 0.2% | 2485.95 ± 16.7% | not timed | not timed | 582.05 ± 2.6% | | 1.01 | 0.0457 | 0.24 |
| imported/rsc/easy1-32k | 19 | 601.95 ± 2.9% | not timed | not timed | 398063.35 ± 0.1% | 20475.83 ± 31.8% | not timed | not timed | 599.61 ± 0.2% | | 1.00 | 0.0015 | 0.0294 |
| imported/rsc/easy1-1mb | 19 | 603.14 ± 0.3% | not timed | not timed | 12865920.43 ± 0.3% | 37594.06 ± 5.3% | not timed | not timed | 601.00 ± 0.3% | | 1.00 | 0.0000 | 0.0160 |
| imported/rsc/medium-32 | 27 | 429.06 ± 0.3% | not timed | not timed | 630.17 ± 0.3% | 70.14 ± 10.7% | not timed | not timed | 429.14 ± 2.0% | | 1.00 | 0.68 | 6.12 |
| imported/rsc/medium-1k | 27 | 6810.66 ± 0.1% | not timed | not timed | 11064.22 ± 0.2% | 72.34 ± 0.1% | not timed | not timed | 6794.01 ± 0.1% | | 1.00 | 0.62 | 94.14 |
| imported/rsc/medium-32k | 27 | 21603.29 ± 0.1% | not timed | not timed | 349918.60 ± 0.1% | 48.69 ± 0.1% | not timed | not timed | 21598.55 ± 0.1% | | 1.00 | 0.0617 | 443.69 |
| imported/rsc/medium-1mb | 27 | 20960.52 ± 1.3% | not timed | not timed | 11276135.59 ± 0.2% | 48.64 ± 0.1% | not timed | not timed | 20870.52 ± 2.1% | | 1.00 | 0.0019 | 430.90 |
| imported/rsc/hard-32 | 58 | 255.25 ± 0.1% | not timed | not timed | 364.49 ± 0.1% | 49.65 ± 7.4% | not timed | not timed | 254.36 ± 2.0% | | 1.00 | 0.70 | 5.14 |
| imported/rsc/hard-1k | 27 | 576.91 ± 0.1% | not timed | not timed | 11539.21 ± 0.5% | 40.79 ± 0.3% | not timed | not timed | 575.30 ± 0.2% | | 1.00 | 0.0500 | 14.14 |
| imported/rsc/hard-32k | 27 | 602.57 ± 0.3% | not timed | not timed | 354484.19 ± 0.1% | 29.08 ± 0.1% | not timed | not timed | 600.58 ± 0.2% | | 1.00 | 0.0017 | 20.72 |
| imported/rsc/hard-1mb | 51 | 601.77 ± 0.3% | not timed | not timed | 7248120.13 ± 0.1% | 29.06 ± 0.1% | not timed | not timed | 598.15 ± 0.2% | | 1.01 | 0.0001 | 20.71 |
| imported/rsc/reallyhard0-32 | 58 | 254.35 ± 2.8% | not timed | not timed | 222.57 ± 0.2% | 49.74 ± 7.3% | not timed | not timed | 254.53 ± 0.2% | | 1.00 | 1.14 | 5.11 |
| imported/rsc/reallyhard0-1k | 27 | 577.74 ± 0.3% | not timed | not timed | 585.54 ± 0.4% | 40.84 ± 0.4% | not timed | not timed | 580.92 ± 0.1% | | 0.99 | 0.99 | 14.15 |
| imported/rsc/reallyhard0-32k | 27 | 602.73 ± 0.3% | not timed | not timed | 612.50 ± 0.1% | 28.93 ± 0.4% | not timed | not timed | 602.68 ± 0.4% | | 1.00 | 0.98 | 20.84 |
| imported/rsc/reallyhard0-1mb | 51 | 592.48 ± 0.5% | not timed | not timed | 616.21 ± 0.1% | 28.88 ± 0.1% | not timed | not timed | 597.55 ± 0.1% | | 0.99 | 0.96 | 20.52 |
| imported/rsc/reallyreallyhard0-32 | 47 | 273.97 ± 5.3% | not timed | not timed | 196.13 ± 0.5% | 60.24 ± 5.3% | not timed | not timed | 273.85 ± 0.1% | | 1.00 | 1.40 | 4.55 |
| imported/rsc/reallyreallyhard0-1k | 16 | 858.72 ± 0.7% | not timed | not timed | 5821.59 ± 0.1% | 33.89 ± 2.8% | not timed | not timed | 859.27 ± 1.6% | | 1.00 | 0.15 | 25.34 |
| imported/rsc/reallyreallyhard0-32k | 16 | 627.13 ± 7.0% | not timed | not timed | 19110.31 ± 0.1% | 24.57 ± 1.0% | not timed | not timed | 628.32 ± 6.7% | | 1.00 | 0.0328 | 25.53 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 590.26 ± 0.8% | not timed | not timed | 19460.85 ± 1.3% | 24.48 ± 2.9% | not timed | not timed | 592.13 ± 0.8% | | 1.00 | 0.0303 | 24.11 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 268.92 ± 0.2% | not timed | not timed | 211.57 ± 0.4% | 60.92 ± 10.2% | not timed | not timed | 268.17 ± 2.9% | | 1.00 | 1.27 | 4.41 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 841.46 ± 1.2% | not timed | not timed | 6199.24 ± 0.1% | 34.58 ± 0.8% | not timed | not timed | 841.37 ± 1.7% | | 1.00 | 0.14 | 24.33 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 625.88 ± 5.3% | not timed | not timed | 19123.08 ± 0.0% | 24.60 ± 1.0% | not timed | not timed | 622.86 ± 5.3% | | 1.00 | 0.0327 | 25.44 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 589.18 ± 0.5% | not timed | not timed | 19255.60 ± 2.0% | 24.96 ± 0.1% | not timed | not timed | 587.99 ± 0.6% | | 1.00 | 0.0306 | 23.61 |
| imported/sherlock/name-sherlock | 776 | 19586.51 ± 1.8% | not timed | not timed | 18439.62 ± 0.8% | 10035.82 ± 18.9% | not timed | not timed | 19612.69 ± 2.1% | | 1.00 | 1.06 | 1.95 |
| imported/sherlock/name-holmes | 2766 | 15019.53 ± 1.7% | not timed | not timed | 15414.99 ± 0.5% | 3142.38 ± 17.0% | not timed | not timed | 15204.46 ± 1.8% | | 0.99 | 0.97 | 4.78 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19591.17 ± 2.1% | not timed | not timed | 18387.29 ± 0.8% | 8017.05 ± 25.7% | not timed | not timed | 19645.86 ± 2.6% | | 1.00 | 1.07 | 2.44 |
| imported/sherlock/name-sherlock-casei | 816 | 15594.83 ± 0.3% | not timed | not timed | 4007.64 ± 0.1% | 32.54 ± 0.3% | not timed | not timed | 15612.45 ± 0.3% | | 1.00 | 3.89 | 479.31 |
| imported/sherlock/name-holmes-casei | 2802 | 9291.05 ± 6.4% | not timed | not timed | 3307.83 ± 0.2% | 37.58 ± 0.3% | not timed | not timed | 9338.26 ± 5.8% | | 0.99 | 2.81 | 247.26 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12950.96 ± 7.6% | not timed | not timed | 3948.52 ± 0.1% | 32.37 ± 0.2% | not timed | not timed | 12961.32 ± 1.3% | | 1.00 | 3.28 | 400.14 |
| imported/sherlock/name-whitespace | 1461 | 14894.01 ± 1.8% | not timed | not timed | 14339.07 ± 0.3% | 6532.32 ± 12.8% | not timed | not timed | 14858.91 ± 1.4% | | 1.00 | 1.04 | 2.28 |
| imported/sherlock/name-alt1 | 1142 | 11403.70 ± 7.1% | not timed | not timed | 16191.68 ± 0.7% | 4080.11 ± 6.5% | not timed | not timed | 11431.51 ± 0.5% | | 1.00 | 0.70 | 2.79 |
| imported/sherlock/name-alt2 | 3542 | 8559.94 ± 0.2% | not timed | not timed | 3828.24 ± 0.1% | 30.71 ± 0.2% | not timed | not timed | 8594.82 ± 0.1% | | 1.00 | 2.24 | 278.69 |
| imported/sherlock/name-alt3 | 4507 | 5428.60 ± 0.5% | not timed | not timed | 3633.13 ± 0.1% | 9.84 ± 3.1% | not timed | not timed | 5435.06 ± 0.3% | | 1.00 | 1.49 | 551.88 |
| imported/sherlock/name-alt3-casei | 4593 | 1507.39 ± 2.3% | not timed | not timed | 285.37 ± 0.3% | 6.44 ± 0.3% | not timed | not timed | 1508.55 ± 1.3% | | 1.00 | 5.28 | 234.24 |
| imported/sherlock/name-alt4 | 3686 | 6145.42 ± 1.0% | not timed | not timed | 3773.10 ± 0.2% | 30.95 ± 0.2% | not timed | not timed | 6137.57 ± 0.7% | | 1.00 | 1.63 | 198.56 |
| imported/sherlock/name-alt4-casei | 4254 | 2747.46 ± 2.7% | not timed | not timed | 2575.00 ± 0.2% | 19.70 ± 0.2% | not timed | not timed | 2755.07 ± 1.8% | | 1.00 | 1.07 | 139.46 |
| imported/sherlock/name-alt5 | 4028 | 6203.02 ± 0.3% | not timed | not timed | 3748.79 ± 0.1% | 21.65 ± 0.2% | not timed | not timed | 6221.07 ± 0.2% | | 1.00 | 1.65 | 286.46 |
| imported/sherlock/name-alt5-casei | 4104 | 3447.81 ± 2.3% | not timed | not timed | 2223.25 ± 0.4% | 14.24 ± 0.1% | not timed | not timed | 3449.44 ± 1.2% | | 1.00 | 1.55 | 242.17 |
| imported/sherlock/no-match-uncommon | 0 | 21390.79 ± 0.4% | not timed | not timed | 19352.45 ± 1.2% | 35071.04 ± 0.8% | not timed | not timed | 21317.00 ± 0.5% | | 1.00 | 1.11 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21190.99 ± 0.7% | not timed | not timed | 19339.21 ± 0.5% | 1276.54 ± 0.8% | not timed | not timed | 21168.86 ± 0.5% | | 1.00 | 1.10 | 16.60 |
| imported/sherlock/no-match-really-common | 0 | 15847.00 ± 3.7% | not timed | not timed | 18630.78 ± 1.1% | 1277.13 ± 1.0% | not timed | not timed | 16201.13 ± 2.4% | | 0.98 | 0.85 | 12.41 |
| imported/sherlock/the-lower | 21654 | 2303.62 ± 7.9% | not timed | not timed | 2333.01 ± 0.6% | 227.51 ± 12.7% | not timed | not timed | 2309.64 ± 1.1% | | 1.00 | 0.99 | 10.13 |
| imported/sherlock/the-upper | 2223 | 11731.46 ± 11.1% | not timed | not timed | 13533.26 ± 1.3% | 2977.19 ± 20.7% | not timed | not timed | 12729.30 ± 10.7% | | 0.92 | 0.87 | 3.94 |
| imported/sherlock/the-casei | 23961 | 2005.26 ± 0.3% | not timed | not timed | 1320.64 ± 0.3% | 34.38 ± 1.1% | not timed | not timed | 2005.31 ± 0.1% | | 1.00 | 1.52 | 58.33 |
| imported/sherlock/everything-greedy | 581881 | 270.75 ± 0.4% | not timed | not timed | 165.09 ± 0.1% | 28.09 ± 24.1% | not timed | not timed | 270.54 ± 8.2% | | 1.00 | 1.64 | 9.64 |
| imported/sherlock/everything-greedy-nl | 594933 | 461.96 ± 0.2% | not timed | not timed | 214.27 ± 0.1% | 32.52 ± 0.2% | not timed | not timed | 462.99 ± 0.1% | | 1.00 | 2.16 | 14.20 |
| imported/sherlock/letters | 447175 | 54.36 ± 0.4% | not timed | not timed | 33.10 ± 0.2% | 6.54 ± 10.3% | not timed | not timed | 54.32 ± 0.4% | | 1.00 | 1.64 | 8.31 |
| imported/sherlock/letters-upper | 14180 | 433.25 ± 1.2% | not timed | not timed | 368.23 ± 0.1% | 28.98 ± 21.5% | not timed | not timed | 434.68 ± 0.2% | | 1.00 | 1.18 | 14.95 |
| imported/sherlock/letters-lower | 432995 | 55.47 ± 1.2% | not timed | not timed | 33.60 ± 0.2% | 6.68 ± 43.2% | not timed | not timed | 55.53 ± 0.7% | | 1.00 | 1.65 | 8.30 |
| imported/sherlock/words | 447639 | 106.77 ± 0.9% | not timed | not timed | 82.36 ± 0.3% | 13.63 ± 4.2% | not timed | not timed | 106.56 ± 1.6% | | 1.00 | 1.30 | 7.84 |
| imported/sherlock/before-holmes | 4073 | 599.59 ± 0.2% | not timed | not timed | 8470.34 ± 0.3% | 23.54 ± 1.9% | not timed | not timed | 597.39 ± 0.3% | | 1.00 | 0.0708 | 25.47 |
| imported/sherlock/before-after-holmes | 2593 | 596.66 ± 0.4% | not timed | not timed | 9499.35 ± 0.4% | 23.93 ± 2.3% | not timed | not timed | 598.15 ± 0.3% | | 1.00 | 0.0628 | 24.93 |
| imported/sherlock/holmes-cochar-watson | 150 | 5200.45 ± 0.2% | not timed | not timed | 3417.01 ± 0.1% | 30.80 ± 0.2% | not timed | not timed | 5199.30 ± 0.2% | | 1.00 | 1.52 | 168.86 |
| imported/sherlock/holmes-coword-watson | 14309 | 1267.53 ± 1.9% | not timed | not timed | 1122.77 ± 0.0% | 6.70 ± 0.3% | not timed | not timed | 1267.02 ± 0.7% | | 1.00 | 1.13 | 189.31 |
| imported/sherlock/quotes | 14437 | 1410.68 ± 0.3% | not timed | not timed | 1751.76 ± 0.8% | 34.87 ± 0.3% | not timed | not timed | 1413.25 ± 0.2% | | 1.00 | 0.81 | 40.46 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 601.79 ± 0.3% | not timed | not timed | 15894.89 ± 0.4% | 36.64 ± 0.5% | not timed | not timed | 602.02 ± 0.7% | | 1.00 | 0.0379 | 16.42 |
| imported/sherlock/word-ending-n | 35297 | 468.77 ± 1.2% | not timed | not timed | 409.25 ± 0.1% | 23.31 ± 21.7% | not timed | not timed | 468.20 ± 0.2% | | 1.00 | 1.15 | 20.11 |
| imported/sherlock/repeated-class-negation | 2130 | 14563.80 ± 0.8% | not timed | not timed | 10944.01 ± 0.7% | 11.48 ± 0.1% | not timed | not timed | 14556.25 ± 0.4% | | 1.00 | 1.33 | 1268.94 |
| imported/sherlock/ing-suffix | 20547 | 554.75 ± 0.2% | not timed | not timed | 516.92 ± 0.2% | 28.58 ± 0.1% | not timed | not timed | 554.26 ± 0.3% | | 1.00 | 1.07 | 19.41 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 595.03 ± 0.3% | not timed | not timed | 2106.91 ± 0.3% | 20.46 ± 0.2% | not timed | not timed | 595.51 ± 0.4% | | 1.00 | 0.28 | 29.08 |
| opt/accelerate/whole-line | 239963 | 458.64 ± 0.1% | not timed | not timed | 372.52 ± 0.2% | 92.01 ± 16.7% | not timed | not timed | 459.32 ± 0.3% | | 1.00 | 1.23 | 4.98 |
| opt/accelerate/non-dna | 16745 | 413.03 ± 2.4% | not timed | not timed | 397.77 ± 0.1% | 28.66 ± 49.1% | not timed | not timed | 413.32 ± 0.4% | | 1.00 | 1.04 | 14.41 |
| opt/backtrack/words-english | 40536 | 137.19 ± 1.6% | not timed | not timed | 94.51 ± 0.2% | 19.60 ± 6.8% | not timed | not timed | 134.53 ± 2.3% | | 1.02 | 1.45 | 7.00 |
| opt/fixed-length/too-small-ascii | 0 | 313.81 ± 0.2% | not timed | not timed | 697.66 ± 2.5% | 79.97 ± 0.6% | not timed | not timed | 311.78 ± 0.1% | | 1.01 | 0.45 | 3.92 |
| opt/fixed-length/too-big-ascii | 0 | 647.66 ± 0.6% | not timed | not timed | 5752.00 ± 0.2% | 125.96 ± 0.5% | not timed | not timed | 655.40 ± 0.2% | | 0.99 | 0.11 | 5.14 |
| opt/fixed-length/go33484-1 | 0 | 45.19 ± 0.3% | not timed | not timed | 1108708.49 ± 0.2% | 61416.90 ± 0.4% | not timed | not timed | 45.27 ± 0.1% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5536.47 ± 0.1% | not timed | not timed | 1112868.79 ± 0.0% | 32150.21 ± 0.6% | not timed | not timed | 5521.62 ± 0.2% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1803.43 ± 2.5% | not timed | not timed | 111245.82 ± 0.1% | 761.86 ± 0.0% | not timed | not timed | 1762.47 ± 0.5% | | 1.02 | 0.0162 | 2.37 |
| opt/literal-alt/one-pattern | 1 | 555.63 ± 10.0% | not timed | not timed | 544.73 ± 0.1% | 0.40 ± 0.4% | not timed | not timed | 556.27 ± 0.4% | | 1.00 | 1.02 | 1389.45 |
| opt/onepass/fn-predicate | 916 | 364.73 ± 1.0% | not timed | not timed | 336.61 ± 0.4% | 201.21 ± 48.3% | not timed | not timed | 368.15 ± 0.9% | | 0.99 | 1.08 | 1.81 |
| opt/onepass/first-three-words-english | 35128 | 148.27 ± 2.6% | not timed | not timed | 201.41 ± 0.1% | 80.91 ± 16.4% | not timed | not timed | 149.74 ± 2.0% | | 0.99 | 0.74 | 1.83 |
| opt/prefilter/literal-english | 1 | 20084.47 ± 0.5% | not timed | not timed | 19272.61 ± 0.7% | 17246.23 ± 0.4% | not timed | not timed | 20131.03 ± 0.4% | | 1.00 | 1.04 | 1.16 |
| opt/prefilter/literal-casei-english | 1 | 14265.98 ± 0.7% | not timed | not timed | 4309.23 ± 0.2% | 32.17 ± 0.5% | not timed | not timed | 14261.21 ± 0.4% | | 1.00 | 3.31 | 443.52 |
| opt/prefilter/literal-russian | 1 | 20878.27 ± 0.8% | not timed | not timed | 19334.72 ± 1.3% | 3323.55 ± 0.6% | not timed | not timed | 20939.34 ± 0.9% | | 1.00 | 1.08 | 6.28 |
| opt/prefilter/literal-casei-russian | 1 | 8528.69 ± 1.1% | not timed | not timed | 3894.72 ± 0.2% | 30.78 ± 0.5% | not timed | not timed | 8524.50 ± 1.1% | | 1.00 | 2.19 | 277.13 |
| opt/prefilter/rust-functions | 948 | 6759.57 ± 0.7% | not timed | not timed | 8849.79 ± 0.8% | 1854.05 ± 0.5% | not timed | not timed | 6744.86 ± 1.2% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 5588.01 ± 0.5% | not timed | not timed | 20797510.28 ± 0.3% | 49.04 ± 0.1% | not timed | not timed | 5588.60 ± 0.1% | | 1.00 | 0.0003 | 113.94 |
| opt/reverse-inner/holmes | 2593 | 596.47 ± 0.5% | not timed | not timed | 9493.52 ± 0.3% | 23.35 ± 2.8% | not timed | not timed | 598.58 ± 0.2% | | 1.00 | 0.0628 | 25.55 |
| opt/reverse-inner/email | 47 | 1044.33 ± 0.1% | not timed | not timed | 43979.95 ± 0.8% | 31.83 ± 0.6% | not timed | not timed | 1043.96 ± 0.1% | | 1.00 | 0.0237 | 32.81 |
| opt/reverse-inner/factored-prefix | 3542 | 591.95 ± 0.5% | not timed | not timed | 596.26 ± 0.3% | 12.24 ± 0.3% | not timed | not timed | 592.62 ± 0.6% | | 1.00 | 0.99 | 48.35 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5510.60 ± 0.1% | not timed | not timed | 610.22 ± 0.3% | 74.87 ± 0.1% | not timed | not timed | 5520.23 ± 0.0% | | 1.00 | 9.03 | 73.60 |
| opt/reverse-inner/no-quadratic-forward | 0 | 686.96 ± 1.7% | not timed | not timed | 287.83 ± 0.2% | 24.77 ± 0.1% | not timed | not timed | 689.22 ± 2.0% | | 1.00 | 2.39 | 27.73 |
| opt/reverse-suffix/holmes | 4073 | 599.35 ± 0.1% | not timed | not timed | 8489.07 ± 0.2% | 23.43 ± 0.4% | not timed | not timed | 597.17 ± 0.1% | | 1.00 | 0.0706 | 25.58 |
| opt/reverse-suffix/no-quadratic | 0 | 5520.26 ± 0.0% | not timed | not timed | 614.80 ± 0.3% | 75.03 ± 0.2% | not timed | not timed | 5498.86 ± 0.3% | | 1.00 | 8.98 | 73.57 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.45 ± 2.3% | not timed | not timed | 131.22 ± 0.0% | 13.41 ± 14.7% | not timed | not timed | 120.90 ± 1.2% | | 1.00 | 0.92 | 8.98 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.84 ± 3.2% | not timed | not timed | 132.98 ± 0.1% | 13.01 ± 14.6% | not timed | not timed | 121.12 ± 1.7% | | 1.00 | 0.91 | 9.29 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.2% | not timed | not timed | 0.55 ± 0.4% | 110.53 ± 1.6% | not timed | not timed | 0.28 ± 0.2% | | 1.00 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 311.40 ± 0.2% | not timed | not timed | 294.41 ± 0.1% | 104.26 ± 0.4% | not timed | not timed | 309.55 ± 0.1% | | 1.01 | 1.06 | 2.99 |
| reported/i13-subset-regex/original-ascii | 4094 | 10883.34 ± 0.6% | not timed | not timed | 4381.94 ± 2.1% | 11.41 ± 1.6% | not timed | not timed | 10821.45 ± 2.9% | | 1.01 | 2.48 | 954.04 |
| reported/i13-subset-regex/original-unicode | 4094 | 10588.95 ± 1.9% | not timed | not timed | 247.39 ± 3.1% | 11.42 ± 0.1% | not timed | not timed | 10791.79 ± 2.0% | | 0.98 | 42.80 | 927.63 |
| reported/i13-subset-regex/big-ascii | 1955 | 10413.95 ± 1.9% | not timed | not timed | 68.10 ± 3.7% | 9.79 ± 0.2% | not timed | not timed | 10565.77 ± 2.4% | | 0.99 | 152.92 | 1064.14 |
| reported/i13-subset-regex/big-unicode | 1955 | 10302.82 ± 1.2% | not timed | not timed | 12.29 ± 54.9% | 9.79 ± 0.2% | not timed | not timed | 10500.33 ± 1.8% | | 0.98 | 838.60 | 1052.38 |
| reported/i13-subset-regex/huge-ascii | 55 | 9737.73 ± 2.8% | not timed | not timed | 11.00 ± 0.1% | 8.71 ± 0.0% | not timed | not timed | 9427.91 ± 4.4% | | 1.03 | 884.96 | 1117.50 |
| reported/i13-subset-regex/huge-unicode | 55 | 9735.65 ± 3.4% | not timed | not timed | 10.99 ± 0.3% | 8.72 ± 0.2% | not timed | not timed | 9713.09 ± 3.2% | | 1.00 | 885.48 | 1115.86 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.1% | not timed | not timed | 11.05 ± 0.1% | 8.71 ± 1.1% | not timed | not timed | 3.54 ± 0.0% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.1% | not timed | not timed | 10.99 ± 0.4% | 8.72 ± 0.1% | not timed | not timed | 5.03 ± 0.1% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 447.14 ± 0.3% | not timed | not timed | 104.55 ± 0.1% | 6.60 ± 0.1% | not timed | not timed | 469.82 ± 0.4% | | 0.95 | 4.28 | 67.73 |
| reported/i787-keywords/opt-ascii | 5674 | 471.45 ± 0.1% | not timed | not timed | 272.40 ± 0.4% | 10.28 ± 0.1% | not timed | not timed | 470.33 ± 0.3% | | 1.00 | 1.73 | 45.87 |
| slow/quadratic-regex-1x | 100 | 6.89 ± 0.2% | not timed | not timed | 4.96 ± 0.2% | 0.05 ± 0.4% | not timed | not timed | 6.96 ± 0.2% | | 0.99 | 1.39 | 139.33 |
| slow/quadratic-regex-2x | 199 | 3.40 ± 0.2% | not timed | not timed | 2.76 ± 0.2% | 0.01 ± 0.1% | not timed | not timed | 3.40 ± 0.1% | | 1.00 | 1.23 | 267.08 |
| slow/quadratic-haystack-1x | 100 | 21.19 ± 6.1% | not timed | not timed | 9.99 ± 0.1% | 1.01 ± 13.5% | not timed | not timed | 21.22 ± 1.4% | | 1.00 | 2.12 | 20.98 |
| slow/quadratic-haystack-2x | 200 | 17.43 ± 1.6% | not timed | not timed | 5.54 ± 0.1% | 0.54 ± 13.2% | not timed | not timed | 17.45 ± 0.7% | | 1.00 | 3.14 | 32.00 |
| unicode/codepoints/any-one | 1112064 | 286.40 ± 0.3% | not timed | not timed | 176.93 ± 0.0% | 17.96 ± 23.6% | not timed | not timed | 286.44 ± 16.5% | | 1.00 | 1.62 | 15.95 |
| unicode/codepoints/any-all | 4382592 | 289.12 ± 0.3% | not timed | not timed | 246.79 ± 0.1% | 114.10 ± 0.1% | not timed | not timed | 289.17 ± 0.3% | | 1.00 | 1.17 | 2.53 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.76 ± 1.0% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 610.41 ± 0.2% | not timed | not timed | 616.05 ± 1.6% | 135.21 ± 0.6% | not timed | not timed | 610.88 ± 0.9% | | 1.00 | 0.99 | 4.51 |
| unicode/overlapping-words/ascii | 6156 | 31.05 ± 0.1% | not timed | not timed | 38.99 ± 0.2% | 3.88 ± 7.5% | not timed | not timed | 31.16 ± 3.6% | | 1.00 | 0.80 | 8.00 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 1.2% | not timed | not timed | 3.81 ± 0.2% | 2.35 ± 6.8% | not timed | not timed | 1.36 ± 0.2% | | 1.00 | 0.35 | 0.57 |
| unicode/overlapping-words/russian | 5710 | 1.22 ± 8.4% | not timed | not timed | 3.13 ± 0.7% | 6.28 ± 4.3% | not timed | not timed | 1.22 ± 0.2% | | 1.00 | 0.39 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 116.42 ± 1.6% | not timed | not timed | 82.88 ± 0.2% | 11.86 ± 15.1% | not timed | not timed | 117.64 ± 4.1% | | 0.99 | 1.40 | 9.81 |
| unicode/word/boundary-long-english | 3466 | 605.23 ± 0.1% | not timed | not timed | 605.10 ± 0.2% | 32.37 ± 1.0% | not timed | not timed | 606.06 ± 0.3% | | 1.00 | 1.00 | 18.69 |
| unicode/word/around-holmes-english | 27 | 601.67 ± 0.4% | not timed | not timed | 18881.61 ± 0.7% | 22.00 ± 1.2% | not timed | not timed | 602.16 ± 0.2% | | 1.00 | 0.0319 | 27.34 |
| wild/bibleref/long | 874 | 565.11 ± 0.2% | not timed | not timed | 584.28 ± 0.2% | 6.74 ± 0.2% | not timed | not timed | 565.82 ± 0.2% | | 1.00 | 0.97 | 83.81 |
| wild/bibleref/short | 30 | 24.86 ± 2.7% | not timed | not timed | 31.22 ± 0.6% | 14.21 ± 7.2% | not timed | not timed | 25.71 ± 9.8% | | 0.97 | 0.80 | 1.75 |
| wild/bibleref/line | 874 | 357.06 ± 3.0% | not timed | not timed | 215.76 ± 0.2% | 9.20 ± 8.3% | not timed | not timed | 357.55 ± 0.3% | | 1.00 | 1.65 | 38.82 |
| wild/caddy/caddy | 6 | 418.94 ± 3.0% | not timed | not timed | 243.51 ± 0.2% | 68.66 ± 14.9% | not timed | not timed | 419.87 ± 0.4% | | 1.00 | 1.72 | 6.10 |
| wild/dot-star-capture/rust-src-tools | 6 | 1059.60 ± 0.4% | not timed | not timed | 350.17 ± 0.1% | 13.49 ± 0.3% | not timed | not timed | 1058.20 ± 0.2% | | 1.00 | 3.03 | 78.54 |
| wild/ruff/noqa | 84 | 404.21 ± 0.1% | not timed | not timed | 468.79 ± 0.2% | 19.62 ± 2.2% | not timed | not timed | 403.58 ± 0.1% | | 1.00 | 0.86 | 20.60 |
| wild/ruff/unnecessary-coding-comment | 16 | 488.63 ± 0.5% | not timed | not timed | 701.09 ± 0.2% | 135.30 ± 10.8% | not timed | not timed | 489.72 ± 0.7% | | 1.00 | 0.70 | 3.61 |
| wild/ruff/string-quote-prefix | 2972 | 407.15 ± 0.6% | not timed | not timed | 442.94 ± 0.3% | 313.79 ± 25.4% | not timed | not timed | 407.22 ± 0.6% | | 1.00 | 0.92 | 1.30 |
| wild/ruff/space-around-operator | 1224378 | 217.11 ± 1.7% | not timed | not timed | 187.37 ± 0.1% | 18.42 ± 1.9% | not timed | not timed | 217.07 ± 2.5% | | 1.00 | 1.16 | 11.78 |
| wild/ruff/shebang | 282 | 401.12 ± 0.5% | not timed | not timed | 326.69 ± 0.5% | 109.45 ± 11.9% | not timed | not timed | 401.21 ± 1.5% | | 1.00 | 1.23 | 3.66 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13705.93 ± 0.4% | not timed | not timed | 13629.45 ± 0.8% | 6852.95 ± 0.8% | not timed | not timed | 13668.63 ± 0.5% | | 1.00 | 1.01 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12721.68 ± 1.0% | not timed | not timed | 13354.50 ± 0.7% | 6356.57 ± 0.9% | not timed | not timed | 12703.70 ± 0.7% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13091.57 ± 0.8% | not timed | not timed | 13503.21 ± 0.8% | 6548.48 ± 0.2% | not timed | not timed | 13101.69 ± 1.1% | | 1.00 | 0.97 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9487.62 ± 0.6% | not timed | not timed | 13423.45 ± 1.0% | 6608.53 ± 1.2% | not timed | not timed | 9473.18 ± 0.3% | | 1.00 | 0.71 | 1.44 |
| wild/url/search | 234965 | 121.19 ± 13.1% | not timed | not timed | 64.54 ± 0.6% | 2.22 ± 0.8% | not timed | not timed | 120.98 ± 14.4% | | 1.00 | 1.88 | 54.56 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 1.7% | not timed | not timed | 0.01 ± 1.0% | 0.01 ± 14.3% | not timed | not timed | 0.03 ± 3.0% | | 1.00 | 3.13 | 4.19 |
| dictionary/compile/english-15 | 1 | 0.35 ± 21.1% | not timed | not timed | 0.07 ± 1.1% | 0.10 ± 29.0% | not timed | not timed | 0.35 ± 4.1% | | 0.99 | 5.14 | 3.45 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.23 ± 6.5% | not timed | not timed | 0.02 ± 0.8% | 35.37 ± 4.6% | not timed | not timed | 0.25 ± 4.8% | | 0.92 | 12.50 | 0.0065 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.73 ± 5.7% | not timed | not timed | 11.47 ± 0.3% | 55.61 ± 29.9% | not timed | not timed | 47.80 ± 0.9% | | 0.98 | 4.07 | 0.84 |
| reported/i787-keywords/compile | 1 | 34.59 ± 5.1% | not timed | not timed | 2.11 ± 0.9% | 16.60 ± 35.3% | not timed | not timed | 35.34 ± 5.7% | | 0.98 | 16.40 | 2.08 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 369.40 ± 5.5% | not timed | not timed | 119.25 ± 0.1% | 600.48 ± 13.3% | not timed | not timed | 375.94 ± 6.1% | | 0.98 | 3.10 | 0.62 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 48.26 ± 1.6% | not timed | not timed | 4.09 ± 1.0% | 42.69 ± 7.3% | not timed | not timed | 48.92 ± 2.7% | | 0.99 | 11.80 | 1.13 |
| unicode/compile/one-letter | 53 | 6.68 ± 11.9% | not timed | not timed | 4.52 ± 0.8% | 64.70 ± 17.2% | not timed | not timed | 6.80 ± 5.0% | | 0.98 | 1.48 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.06 ± 16.6% | not timed | not timed | 0.10 ± 1.2% | 64.10 ± 17.3% | not timed | not timed | 1.10 ± 7.4% | | 0.97 | 11.05 | 0.0166 |
| unicode/compile/fifty-letters-ascii | 1 | 224.87 ± 6.3% | not timed | not timed | 53.05 ± 0.1% | 189.43 ± 23.3% | not timed | not timed | 226.98 ± 8.8% | | 0.99 | 4.24 | 1.19 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 390.97 ± 26.1% | not timed | not timed | 47.41 ± 0.6% | 647.88 ± 19.9% | not timed | not timed | 396.20 ± 3.2% | | 0.99 | 8.25 | 0.60 |
| unicode/compile/match-every-line-ascii | 4 | 630.05 ± 7.6% | not timed | not timed | 146.17 ± 0.2% | 660.38 ± 30.0% | not timed | not timed | 632.31 ± 3.4% | | 1.00 | 4.31 | 0.95 |
| unicode/compile/negated-class-matches-codepoint | 1 | 320.82 ± 4.6% | not timed | not timed | 51.46 ± 0.4% | 1237.29 ± 4.9% | not timed | not timed | 337.05 ± 4.5% | | 0.95 | 6.23 | 0.26 |
| wild/bibleref/compile | 3 | 5.86 ± 4.4% | not timed | not timed | 1.89 ± 1.0% | 30.78 ± 12.2% | not timed | not timed | 6.00 ± 3.2% | | 0.98 | 3.11 | 0.19 |
| wild/url/compile | 1 | 0.65 ± 16.8% | not timed | not timed | 0.14 ± 0.5% | 0.42 ± 17.2% | not timed | not timed | 0.64 ± 22.1% | | 1.02 | 4.60 | 1.55 |

