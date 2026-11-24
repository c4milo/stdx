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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391506872 |
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
| literal: a word | 217 | 19418.89 ± 0.5% | 5030.00 ± 0.3% | 27.69 ± 0.4% | 18389.72 ± 0.7% | 9287.47 ± 7.1% | 17.60 ± 0.3% | 84.42 ± 0.4% | 19561.41 ± 1.0% | 3.86 | 0.99 | 1.06 | 2.09 |
| literal: a word that is not there | 0 | 21735.87 ± 0.9% | 4922.74 ± 0.6% | 27.79 ± 0.3% | 19743.36 ± 1.4% | 29094.90 ± 1.8% | 17.42 ± 0.5% | 79.93 ± 0.6% | 21552.30 ± 2.3% | 4.42 | 1.01 | 1.10 | 0.75 |
| literal: one of four words | 661 | 6342.22 ± 0.3% | 1951.38 ± 0.1% | 14.19 ± 0.3% | 3941.48 ± 0.2% | 21.89 ± 0.2% | 5.31 ± 0.2% | 6.64 ± 0.9% | 6360.95 ± 0.6% | 3.25 | 1.00 | 1.61 | 289.69 |
| literal: a word in any case | 217 | 15152.59 ± 0.9% | 2089.06 ± 0.2% | 21.09 ± 0.4% | 3960.22 ± 0.3% | 37.94 ± 0.8% | refused | differs | 15123.62 ± 1.0% | 7.25 | 1.00 | 3.83 | 399.34 |
| literal: an href attribute | 33 | 16775.89 ± 0.8% | 608.53 ± 0.6% | 26.60 ± 0.2% | 16942.28 ± 1.6% | 2262.43 ± 1.3% | 13.43 ± 0.2% | 74.15 ± 0.3% | 16822.19 ± 1.1% | 27.57 | 1.00 | 0.99 | 7.42 |
| literal: a word, second text | 123 | 19865.22 ± 2.1% | 3385.55 ± 0.2% | 27.28 ± 0.2% | 18443.23 ± 1.8% | 7661.81 ± 10.2% | 19.78 ± 0.3% | 70.28 ± 0.2% | 20016.47 ± 1.2% | 5.87 | 0.99 | 1.08 | 2.59 |
| class: two capitalized words | 1331 | 1071.54 ± 0.2% | 598.46 ± 0.4% | 25.41 ± 0.1% | 585.27 ± 0.2% | 40.62 ± 7.8% | 15.00 ± 0.2% | 67.48 ± 0.2% | 1071.46 ± 0.4% | 1.79 | 1.00 | 1.83 | 26.38 |
| class: a word that ends in ing | 3399 | 573.24 ± 0.1% | 573.23 ± 0.2% | 17.72 ± 0.1% | 547.56 ± 0.0% | 29.67 ± 3.1% | 8.25 ± 0.2% | 18.43 ± 0.3% | 573.51 ± 0.1% | 1.00 | 1.00 | 1.05 | 19.32 |
| class: a word in capitals | 2332 | 1377.67 ± 0.2% | 604.41 ± 0.3% | 26.89 ± 0.3% | 572.63 ± 0.1% | 43.55 ± 2.9% | 17.28 ± 0.1% | 82.68 ± 0.5% | 1377.99 ± 0.4% | 2.28 | 1.00 | 2.41 | 31.63 |
| class: a number | 8288 | 1996.58 ± 0.3% | 829.21 ± 0.0% | 27.10 ± 0.2% | 1732.53 ± 0.2% | 42.39 ± 16.6% | 0.57 ± 0.1% | 57.55 ± 0.2% | 2002.65 ± 0.5% | 2.41 | 1.00 | 1.15 | 47.10 |
| class: two capitalized words, second text | 5359 | 516.32 ± 0.2% | 522.53 ± 0.4% | 22.74 ± 0.2% | 485.06 ± 0.1% | 35.28 ± 6.8% | 16.70 ± 0.4% | 62.91 ± 0.4% | 515.83 ± 0.3% | 0.99 | 1.00 | 1.06 | 14.64 |
| other: a word between two words | 6104 | 792.66 ± 0.1% | 592.55 ± 0.2% | 23.09 ± 0.1% | 735.90 ± 0.3% | 108.07 ± 15.4% | 11.34 ± 0.1% | 68.39 ± 0.5% | 793.26 ± 0.2% | 1.34 | 1.00 | 1.08 | 7.33 |
| other: a number before a unit, second text | 1481 | 5941.96 ± 1.1% | 1122.39 ± 0.2% | 25.39 ± 0.2% | 5653.90 ± 0.3% | 40.78 ± 15.8% | 17.85 ± 0.2% | 65.83 ± 0.2% | 5888.27 ± 1.0% | 5.29 | 1.01 | 1.05 | 145.69 |
| other: a heading's start tag | 110 | 14077.97 ± 1.6% | 742.89 ± 0.3% | 26.78 ± 0.3% | 1713.07 ± 0.5% | 1569.71 ± 5.5% | 16.39 ± 0.4% | 86.22 ± 0.6% | 14112.33 ± 0.9% | 18.95 | 1.00 | 8.22 | 8.97 |
| other: a whole word | 217 | 15776.43 ± 0.6% | 602.86 ± 0.9% | 28.60 ± 0.3% | 14487.53 ± 1.6% | 49.43 ± 0.4% | 13.89 ± 0.4% | 54.91 ± 0.3% | 15925.42 ± 1.4% | 26.17 | 0.99 | 1.09 | 319.18 |
| other: a line's first word, second text | 3716 | 2041.02 ± 0.4% | 587.97 ± 0.1% | 29.95 ± 0.4% | 1729.59 ± 0.7% | 62.31 ± 5.8% | refused | refused | 2049.22 ± 0.4% | 3.47 | 1.00 | 1.18 | 32.76 |
| other: fourteen octets before an x | 87 | 23756.37 ± 1.4% | 238.30 ± 0.4% | 6.28 ± 0.4% | 4024.15 ± 1.2% | 10.65 ± 0.2% | differs | 17.78 ± 0.2% | 23881.02 ± 5.9% | 99.69 | 0.99 | 5.90 | 2229.84 |
| other: a Greek word | 21815 | 497.90 ± 0.3% | 413.25 ± 0.1% | 30.32 ± 0.1% | 289.62 ± 0.2% | 44.70 ± 9.3% | differs | refused | 499.95 ± 0.8% | 1.20 | 1.00 | 1.72 | 11.14 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.61 ± 0.3% | 19.56 ± 0.3% | 0.85 ± 0.1% | 19.82 ± 0.6% | 2.77 ± 0.3% | differs | 4.06 ± 0.1% | 19.54 ± 0.2% | 1.00 | 1.00 | 0.99 | 7.08 |
| a UUID | 32895 | 21.11 ± 0.4% | 21.08 ± 0.4% | 0.64 ± 0.1% | 15.08 ± 0.2% | 3.09 ± 0.6% | 0.73 ± 0.2% | 3.64 ± 0.6% | 21.08 ± 0.4% | 1.00 | 1.00 | 1.40 | 6.83 |
| an IPv4 address | 33176 | 35.98 ± 0.1% | 35.98 ± 0.1% | 2.05 ± 0.1% | 29.30 ± 0.7% | 6.67 ± 0.1% | differs | 4.16 ± 0.1% | 35.96 ± 0.2% | 1.00 | 1.00 | 1.23 | 5.39 |
| a date and time | 32954 | 31.05 ± 0.2% | 31.05 ± 0.3% | 1.43 ± 0.2% | 21.29 ± 1.1% | 7.03 ± 0.3% | 1.20 ± 0.1% | 7.10 ± 0.5% | 30.99 ± 0.5% | 1.00 | 1.00 | 1.46 | 4.41 |
| a field path | 32606 | 23.18 ± 0.2% | 23.10 ± 0.1% | 1.01 ± 0.2% | 23.16 ± 0.6% | 3.49 ± 1.2% | differs | 2.98 ± 0.2% | 23.10 ± 0.2% | 1.00 | 1.00 | 1.00 | 6.64 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.16 ± 0.9% | 11.10 ± 1.5% | 11.13 ± 1.5% | 11.43 ± 0.0% | 4.95 ± 2.2% | 0.91 ± 0.3% | none | 11.13 ± 4.1% | 1.01 | 1.00 | 0.98 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 226.01 ± 1.3% | 227.12 ± 0.4% | 275.38 ± 0.6% | 87.92 ± 2.7% | 223.07 ± 2.2% | 479.11 ± 3.0% | 3780.51 ± 0.6% | 224.54 ± 0.4% | 1.00 | 1.01 | 2.57 | 1.01 |
| a UUID | 62 | 148.07 ± 0.8% | 148.73 ± 1.1% | 169.07 ± 0.7% | 46.45 ± 0.6% | 100.01 ± 1.0% | 187.24 ± 2.4% | 4158.46 ± 3.6% | 147.40 ± 0.6% | 1.00 | 1.00 | 3.19 | 1.48 |
| an IPv4 address | 29 | 404.79 ± 0.7% | 409.75 ± 0.7% | 592.79 ± 0.5% | 78.18 ± 0.7% | 132.15 ± 2.0% | 298.35 ± 0.3% | 7465.19 ± 0.4% | 404.57 ± 0.4% | 0.99 | 1.00 | 5.18 | 3.06 |
| a date and time | 56 | 294.51 ± 0.3% | 296.54 ± 0.7% | 381.55 ± 0.2% | 73.27 ± 0.5% | 138.76 ± 2.7% | 331.79 ± 1.0% | 4784.04 ± 0.7% | 294.49 ± 0.2% | 0.99 | 1.00 | 4.02 | 2.12 |
| a field path | 39 | 215.36 ± 1.7% | 217.67 ± 1.8% | 263.08 ± 1.2% | 79.69 ± 1.3% | 206.02 ± 1.4% | 492.14 ± 2.0% | 4852.97 ± 0.5% | 217.90 ± 0.4% | 0.99 | 0.99 | 2.70 | 1.05 |
| literal: a word | 7 | 596.94 ± 0.4% | 643.90 ± 0.3% | 1221.39 ± 0.2% | 497.38 ± 0.2% | 629.62 ± 2.3% | 956.61 ± 0.7% | 29786.56 ± 0.1% | 596.97 ± 0.2% | 0.93 | 1.00 | 1.20 | 0.95 |
| literal: a word that is not there | 8 | 572.88 ± 0.5% | 623.66 ± 0.4% | 1150.57 ± 0.7% | 454.86 ± 0.2% | 608.98 ± 3.0% | 900.42 ± 0.6% | 28799.59 ± 0.4% | 573.95 ± 0.3% | 0.92 | 1.00 | 1.26 | 0.94 |
| literal: one of four words | 26 | 235.55 ± 0.2% | 383.86 ± 0.5% | 541.75 ± 0.4% | 50.62 ± 0.8% | 243.39 ± 4.0% | 373.80 ± 0.5% | 15749.11 ± 0.1% | 235.40 ± 0.2% | 0.61 | 1.00 | 4.65 | 0.97 |
| literal: a word in any case | 11 | 432.35 ± 0.2% | 460.84 ± 0.3% | 707.90 ± 0.1% | 15.69 ± 0.2% | 647.63 ± 3.0% | refused | 23566.41 ± 0.4% | 432.52 ± 0.2% | 0.94 | 1.00 | 27.55 | 0.67 |
| literal: an href attribute | 12 | 329.50 ± 0.2% | 341.43 ± 0.2% | 465.06 ± 0.7% | 45.02 ± 1.1% | 499.15 ± 3.2% | 768.91 ± 0.8% | 21440.62 ± 0.3% | 329.70 ± 0.2% | 0.97 | 1.00 | 7.32 | 0.66 |
| literal: a word, second text | 10 | 535.07 ± 0.4% | 587.81 ± 0.3% | 1036.94 ± 0.6% | 404.36 ± 0.4% | 541.51 ± 1.3% | 794.63 ± 0.4% | 26691.14 ± 0.4% | 535.00 ± 0.4% | 0.91 | 1.00 | 1.32 | 0.99 |
| class: two capitalized words | 23 | 414.92 ± 0.4% | 449.90 ± 0.5% | 671.34 ± 0.4% | 100.93 ± 0.1% | 505.39 ± 0.6% | 747.84 ± 1.9% | 6432.63 ± 0.4% | 415.17 ± 0.2% | 0.92 | 1.00 | 4.11 | 0.82 |
| class: a word that ends in ing | 9 | 518.58 ± 0.2% | 587.31 ± 0.3% | 1089.47 ± 0.3% | 132.67 ± 0.9% | 764.61 ± 0.8% | 1106.07 ± 0.8% | 15885.04 ± 1.3% | 518.67 ± 0.5% | 0.88 | 1.00 | 3.91 | 0.68 |
| class: a word in capitals | 16 | 460.39 ± 0.4% | 505.48 ± 0.3% | 848.98 ± 0.3% | 136.33 ± 1.3% | 754.60 ± 2.2% | 1012.79 ± 1.0% | 8472.80 ± 0.4% | 460.55 ± 0.4% | 0.91 | 1.00 | 3.38 | 0.61 |
| class: a number | 6 | 576.61 ± 0.4% | 648.37 ± 0.6% | 1303.46 ± 0.1% | 41.85 ± 0.7% | 1405.11 ± 1.5% | 1853.11 ± 1.2% | 22500.72 ± 0.1% | 576.21 ± 0.3% | 0.89 | 1.00 | 13.78 | 0.41 |
| class: two capitalized words, second text | 23 | 415.22 ± 0.4% | 449.68 ± 0.6% | 673.08 ± 0.3% | 99.54 ± 0.9% | 500.95 ± 1.4% | 762.54 ± 0.8% | 6434.59 ± 0.6% | 415.55 ± 0.4% | 0.92 | 1.00 | 4.17 | 0.83 |
| other: a word between two words | 13 | 514.58 ± 0.3% | 533.63 ± 0.3% | 889.77 ± 0.1% | 132.85 ± 0.7% | 505.34 ± 1.6% | 810.58 ± 0.5% | 14474.95 ± 0.9% | 514.62 ± 0.7% | 0.96 | 1.00 | 3.87 | 1.02 |
| other: a number before a unit, second text | 15 | 377.15 ± 0.9% | 416.89 ± 0.5% | 612.07 ± 1.0% | 39.56 ± 1.3% | 642.11 ± 0.9% | 882.70 ± 0.6% | 15096.19 ± 0.4% | 376.83 ± 0.2% | 0.90 | 1.00 | 9.53 | 0.59 |
| other: a heading's start tag | 13 | 343.33 ± 0.2% | 350.93 ± 0.2% | 475.75 ± 0.3% | 43.13 ± 0.4% | 634.59 ± 0.9% | 868.95 ± 0.8% | 17762.12 ± 0.6% | 343.80 ± 0.3% | 0.98 | 1.00 | 7.96 | 0.54 |
| other: a whole word | 11 | 552.98 ± 0.4% | 589.52 ± 0.2% | 1035.22 ± 0.3% | 119.05 ± 0.2% | 564.33 ± 1.7% | 830.24 ± 1.8% | 26899.74 ± 0.1% | 553.02 ± 0.5% | 0.94 | 1.00 | 4.64 | 0.98 |
| other: a line's first word, second text | 17 | 495.60 ± 0.7% | 518.76 ± 0.2% | 874.69 ± 0.4% | 129.68 ± 1.0% | 708.39 ± 0.6% | refused | refused | 497.39 ± 0.5% | 0.96 | 1.00 | 3.82 | 0.70 |
| other: fourteen octets before an x | 16 | 107.40 ± 0.6% | 152.18 ± 0.8% | 180.50 ± 1.2% | 15.18 ± 0.5% | 451.33 ± 1.3% | 406.53 ± 0.7% | 12710.38 ± 0.7% | 107.24 ± 0.5% | 0.71 | 1.00 | 7.08 | 0.24 |
| other: a Greek word | 8 | 405.54 ± 0.3% | 558.76 ± 0.6% | 997.61 ± 0.4% | 58.88 ± 0.8% | 1381.27 ± 1.3% | 1830.04 ± 1.7% | refused | 406.04 ± 0.3% | 0.73 | 1.00 | 6.89 | 0.29 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15741.04 ± 0.5% | not timed | not timed | 16278.44 ± 0.8% | 2003.27 ± 20.9% | not timed | not timed | 15775.45 ± 0.5% | | 1.00 | 0.97 | 7.86 |
| 01-literal/sherlock-casei-en | 522 | 11058.48 ± 4.3% | not timed | not timed | 3592.06 ± 0.2% | 32.52 ± 0.4% | not timed | not timed | 11039.91 ± 1.9% | | 1.00 | 3.08 | 340.07 |
| 01-literal/sherlock-ru | 724 | 17139.74 ± 0.5% | not timed | not timed | 17263.66 ± 0.3% | 1558.42 ± 9.7% | not timed | not timed | 17166.84 ± 0.3% | | 1.00 | 0.99 | 11.00 |
| 01-literal/sherlock-casei-ru | 746 | 6177.85 ± 0.1% | not timed | not timed | 3331.97 ± 0.1% | 30.83 ± 0.3% | not timed | not timed | 6183.10 ± 0.1% | | 1.00 | 1.85 | 200.41 |
| 01-literal/sherlock-zh | 30 | 19972.46 ± 0.7% | not timed | not timed | 18805.02 ± 0.3% | 2848.65 ± 5.2% | not timed | not timed | 19964.75 ± 0.5% | | 1.00 | 1.06 | 7.01 |
| 02-literal-alternate/sherlock-en | 714 | 6036.30 ± 0.3% | not timed | not timed | 3936.40 ± 0.2% | 16.57 ± 0.4% | not timed | not timed | 6035.65 ± 0.4% | | 1.00 | 1.53 | 364.19 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1982.60 ± 1.1% | not timed | not timed | 697.49 ± 0.3% | 11.12 ± 0.1% | not timed | not timed | 1984.08 ± 1.0% | | 1.00 | 2.84 | 178.28 |
| 02-literal-alternate/sherlock-ru | 899 | 5566.06 ± 0.1% | not timed | not timed | 3260.04 ± 0.1% | 22.61 ± 0.2% | not timed | not timed | 5568.27 ± 0.1% | | 1.00 | 1.71 | 246.14 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2056.59 ± 0.5% | not timed | not timed | 1234.15 ± 0.1% | 9.10 ± 5.2% | not timed | not timed | 2059.90 ± 0.5% | | 1.00 | 1.67 | 226.00 |
| 02-literal-alternate/sherlock-zh | 207 | 7310.33 ± 0.3% | not timed | not timed | 4159.72 ± 0.1% | 31.49 ± 0.2% | not timed | not timed | 7315.52 ± 0.3% | | 1.00 | 1.76 | 232.17 |
| 03-date/ascii | 111817 | 124.27 ± 1.2% | not timed | not timed | 95.40 ± 0.1% | 0.20 ± 4.6% | not timed | not timed | 124.82 ± 0.5% | | 1.00 | 1.30 | 614.86 |
| 04-ruff-noqa/real | 84 | 403.92 ± 0.1% | not timed | not timed | 463.67 ± 0.1% | 19.53 ± 1.7% | not timed | not timed | 404.54 ± 0.1% | | 1.00 | 0.87 | 20.68 |
| 04-ruff-noqa/tweaked | 44 | 559.08 ± 0.4% | not timed | not timed | 464.75 ± 0.1% | 366.80 ± 0.3% | not timed | not timed | 557.68 ± 0.3% | | 1.00 | 1.20 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.31 ± 4.2% | not timed | not timed | 5.02 ± 0.2% | 0.21 ± 4.3% | not timed | not timed | 5.32 ± 0.7% | | 1.00 | 1.06 | 25.73 |
| 06-cloud-flare-redos/original | 107 | 414.95 ± 0.2% | not timed | not timed | 213.69 ± 0.2% | 24.76 ± 0.2% | not timed | not timed | 415.64 ± 0.2% | | 1.00 | 1.94 | 16.76 |
| 06-cloud-flare-redos/simplified-short | 102 | 416.52 ± 0.1% | not timed | not timed | 223.85 ± 0.1% | 26.60 ± 0.0% | not timed | not timed | 410.49 ± 0.3% | | 1.01 | 1.86 | 15.66 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.61 ± 0.1% | not timed | not timed | 255.05 ± 0.1% | 28.82 ± 0.5% | not timed | not timed | 578.04 ± 0.6% | | 1.02 | 2.30 | 20.39 |
| 07-unicode-character-data/parse-line | 558784 | 241.87 ± 3.1% | not timed | not timed | 172.32 ± 0.3% | 42.86 ± 3.0% | not timed | not timed | 243.05 ± 3.3% | | 1.00 | 1.40 | 5.64 |
| 08-words/all-english | 56691 | 116.43 ± 0.7% | not timed | not timed | 81.84 ± 0.3% | 13.01 ± 4.5% | not timed | not timed | 116.68 ± 0.4% | | 1.00 | 1.42 | 8.95 |
| 08-words/long-english | 839 | 613.73 ± 0.4% | not timed | not timed | 595.14 ± 0.1% | 32.53 ± 0.7% | not timed | not timed | 613.62 ± 0.5% | | 1.00 | 1.03 | 18.86 |
| 09-aws-keys/full | 0 | 409.26 ± 0.1% | not timed | not timed | 464.23 ± 0.2% | 64.66 ± 3.4% | not timed | not timed | 410.02 ± 0.1% | | 1.00 | 0.88 | 6.33 |
| 09-aws-keys/quick | 0 | 874.39 ± 0.4% | not timed | not timed | 945.90 ± 0.5% | 422.58 ± 0.6% | not timed | not timed | 874.31 ± 0.2% | | 1.00 | 0.92 | 2.07 |
| 10-bounded-repeat/letters-en | 1833 | 578.47 ± 2.8% | not timed | not timed | 511.32 ± 0.6% | 19.57 ± 0.6% | not timed | not timed | 582.01 ± 1.5% | | 0.99 | 1.13 | 29.55 |
| 10-bounded-repeat/letters-ru | 3475 | 510.38 ± 1.5% | not timed | not timed | 473.35 ± 0.2% | 21.61 ± 9.4% | not timed | not timed | 500.00 ± 1.6% | | 1.02 | 1.08 | 23.61 |
| 10-bounded-repeat/context | 53 | 85.36 ± 1.9% | not timed | not timed | 66.14 ± 0.2% | 19.42 ± 0.1% | not timed | not timed | 85.43 ± 1.6% | | 1.00 | 1.29 | 4.40 |
| 10-bounded-repeat/capitals | 11 | 641.36 ± 8.0% | not timed | not timed | 618.45 ± 0.1% | 36.52 ± 0.1% | not timed | not timed | 640.51 ± 8.1% | | 1.00 | 1.04 | 17.56 |
| 11-unstructured-to-json/extract | 600 | 56.84 ± 0.8% | not timed | not timed | 77.59 ± 0.1% | 45.98 ± 6.2% | not timed | not timed | 56.85 ± 0.4% | | 1.00 | 0.73 | 1.24 |
| 12-dictionary/single | 1 | 567.29 ± 0.5% | not timed | not timed | 560.39 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 569.01 ± 0.2% | | 1.00 | 1.01 | 1392.91 |
| 14-quadratic/1x | 100 | 21.18 ± 1.0% | not timed | not timed | 10.00 ± 0.3% | 0.98 ± 2.1% | not timed | not timed | 21.15 ± 0.8% | | 1.00 | 2.12 | 21.66 |
| 14-quadratic/2x | 200 | 17.46 ± 0.2% | not timed | not timed | 5.55 ± 0.3% | 0.53 ± 1.6% | not timed | not timed | 17.37 ± 0.8% | | 1.01 | 3.15 | 32.86 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.6% | not timed | not timed | 1.20 ± 0.1% | 0.12 ± 1.9% | not timed | not timed | 7.69 ± 0.4% | | 1.00 | 6.38 | 66.52 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.22 ± 1.3% | not timed | not timed | 0.34 ± 0.2% | 0.54 ± 5.0% | not timed | not timed | 1.23 ± 0.7% | | 1.00 | 3.56 | 2.27 |
| 04-ruff-noqa/compile-real | 1 | 101.91 ± 1.4% | not timed | not timed | 13.87 ± 0.3% | 139.12 ± 1.7% | not timed | not timed | 101.99 ± 1.4% | | 1.00 | 7.35 | 0.73 |
| 05-lexer-veryl/compile-single | 1 | 14.02 ± 0.6% | not timed | not timed | 2.55 ± 1.2% | 6.45 ± 2.8% | not timed | not timed | 14.03 ± 0.4% | | 1.00 | 5.49 | 2.17 |
| 07-unicode-character-data/compile | 1 | 106.95 ± 1.5% | not timed | not timed | 25.93 ± 0.2% | 36.09 ± 4.0% | not timed | not timed | 107.55 ± 0.3% | | 0.99 | 4.12 | 2.96 |
| 09-aws-keys/compile-full | 1 | 52.82 ± 0.6% | not timed | not timed | 8.34 ± 0.4% | 23.53 ± 1.2% | not timed | not timed | 52.99 ± 0.5% | | 1.00 | 6.34 | 2.24 |
| 09-aws-keys/compile-quick | 1 | 179.43 ± 1.0% | not timed | not timed | 47.64 ± 0.2% | 132.72 ± 3.6% | not timed | not timed | 179.69 ± 0.1% | | 1.00 | 3.77 | 1.35 |
| 10-bounded-repeat/compile-context | 1 | 71.23 ± 2.3% | not timed | not timed | 11.19 ± 0.3% | 16.18 ± 2.5% | not timed | not timed | 71.68 ± 1.9% | | 0.99 | 6.37 | 4.40 |
| 10-bounded-repeat/compile-capitals | 1 | 84.43 ± 0.3% | not timed | not timed | 8.02 ± 0.3% | 23.93 ± 1.6% | not timed | not timed | 83.91 ± 0.3% | | 1.01 | 10.52 | 3.53 |
| 11-unstructured-to-json/compile | 1 | 169.27 ± 1.4% | not timed | not timed | 41.17 ± 1.1% | 68.33 ± 2.4% | not timed | not timed | 169.55 ± 0.9% | | 1.00 | 4.11 | 2.48 |
| 12-dictionary/compile-single | 1 | 0.35 ± 3.0% | not timed | not timed | 0.07 ± 33.2% | 0.10 ± 20.8% | not timed | not timed | 0.35 ± 1.5% | | 1.00 | 5.13 | 3.60 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.52 ± 5.1% | not timed | not timed | 6.51 ± 0.3% | 0.55 ± 18.8% | not timed | not timed | 7.54 ± 5.3% | | 1.00 | 1.16 | 13.58 |
| dictionary/search/english-10 | 690 | 1.05 ± 0.5% | not timed | not timed | 166.20 ± 0.8% | 0.00 ± 0.7% | not timed | not timed | 1.05 ± 0.8% | | 1.00 | 0.0063 | 358.53 |
| dictionary/search/english-15 | 15 | 559.92 ± 0.7% | not timed | not timed | 559.27 ± 0.1% | 0.37 ± 0.2% | not timed | not timed | 561.14 ± 0.5% | | 1.00 | 1.00 | 1518.79 |
| folly/awyer-inn-busted | 1 | 5585.71 ± 0.2% | not timed | not timed | 141.60 ± 0.1% | 44.10 ± 0.4% | not timed | not timed | 5573.87 ± 0.1% | | 1.00 | 39.45 | 126.66 |
| folly/literal-never-match-rare | 0 | 21102.15 ± 0.3% | not timed | not timed | 19914.55 ± 0.1% | 40933.45 ± 0.4% | not timed | not timed | 21095.18 ± 0.2% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12533.32 ± 0.8% | not timed | not timed | 19882.10 ± 0.2% | 2193.57 ± 1.1% | not timed | not timed | 12589.14 ± 0.8% | | 1.00 | 0.63 | 5.71 |
| folly/literal-never-match-tricksy | 1 | 3261.70 ± 0.3% | not timed | not timed | 4398.65 ± 0.4% | 3049.94 ± 0.9% | not timed | not timed | 3245.93 ± 0.5% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1312.23 ± 0.9% | not timed | not timed | 928.87 ± 0.2% | 382.95 ± 22.3% | not timed | not timed | 1314.08 ± 0.6% | | 1.00 | 1.41 | 3.43 |
| grep/long-words-ascii | 5073 | 459.53 ± 0.1% | not timed | not timed | 453.98 ± 0.1% | 46.24 ± 6.4% | not timed | not timed | 435.71 ± 0.7% | | 1.05 | 1.01 | 9.94 |
| imported/leipzig/twain | 811 | 20527.19 ± 1.2% | not timed | not timed | 19494.28 ± 0.8% | 11959.47 ± 10.4% | not timed | not timed | 20596.41 ± 0.3% | | 1.00 | 1.05 | 1.72 |
| imported/leipzig/twain-insensitive | 965 | 8992.28 ± 1.3% | not timed | not timed | 4244.45 ± 0.3% | 37.73 ± 0.1% | not timed | not timed | 9044.82 ± 0.8% | | 0.99 | 2.12 | 238.35 |
| imported/leipzig/shing | 1540 | 629.63 ± 0.1% | not timed | not timed | 12933.26 ± 4.7% | 34.05 ± 0.1% | not timed | not timed | 631.85 ± 0.3% | | 1.00 | 0.0487 | 18.49 |
| imported/leipzig/huck-saw | 262 | 8126.53 ± 3.0% | not timed | not timed | 5552.90 ± 0.9% | 30.92 ± 0.1% | not timed | not timed | 8285.32 ± 2.6% | | 0.98 | 1.46 | 262.87 |
| imported/leipzig/word-ending-nn | 262 | 608.57 ± 0.2% | not timed | not timed | 616.77 ± 0.1% | 24.41 ± 0.2% | not timed | not timed | 611.38 ± 0.1% | | 1.00 | 0.99 | 24.93 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11047.87 ± 1.2% | not timed | not timed | 4483.12 ± 1.3% | 11.52 ± 0.1% | not timed | not timed | 11073.17 ± 1.1% | | 1.00 | 2.46 | 958.75 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7757.89 ± 2.9% | not timed | not timed | 5471.97 ± 0.2% | 16.87 ± 0.0% | not timed | not timed | 7788.58 ± 3.0% | | 1.00 | 1.42 | 459.86 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4153.45 ± 1.2% | not timed | not timed | 416.01 ± 1.7% | 11.12 ± 0.0% | not timed | not timed | 4184.61 ± 0.7% | | 0.99 | 9.98 | 373.60 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 609.00 ± 0.2% | not timed | not timed | 615.34 ± 0.1% | 11.13 ± 0.1% | not timed | not timed | 609.52 ± 0.3% | | 1.00 | 0.99 | 54.72 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.57 ± 0.2% | not timed | not timed | 615.26 ± 0.1% | 9.73 ± 0.0% | not timed | not timed | 610.32 ± 0.2% | | 1.00 | 0.99 | 62.65 |
| imported/leipzig/tom-river | 2 | 6394.87 ± 2.2% | not timed | not timed | 5049.86 ± 2.3% | 31.05 ± 0.1% | not timed | not timed | 6480.28 ± 3.2% | | 0.99 | 1.27 | 205.97 |
| imported/leipzig/ing | 78424 | 608.90 ± 0.5% | not timed | not timed | 568.67 ± 0.3% | 28.18 ± 3.6% | not timed | not timed | 607.22 ± 0.6% | | 1.00 | 1.07 | 21.61 |
| imported/leipzig/ing-whitespace | 55248 | 758.08 ± 0.9% | not timed | not timed | 2056.19 ± 0.3% | 20.57 ± 3.2% | not timed | not timed | 758.07 ± 0.2% | | 1.00 | 0.37 | 36.85 |
| imported/leipzig/awyer-inn | 209 | 774.78 ± 1.5% | not timed | not timed | 4101.56 ± 3.0% | 22.72 ± 0.0% | not timed | not timed | 775.04 ± 1.3% | | 1.00 | 0.19 | 34.10 |
| imported/leipzig/quotes-bounded | 8886 | 2114.60 ± 0.8% | not timed | not timed | 2939.51 ± 3.0% | 38.28 ± 0.2% | not timed | not timed | 2110.30 ± 1.1% | | 1.00 | 0.72 | 55.24 |
| imported/leipzig/non-ascii-alternate | 2 | 12624.87 ± 3.1% | not timed | not timed | 5631.51 ± 0.6% | 50.45 ± 0.1% | not timed | not timed | 12715.93 ± 3.6% | | 0.99 | 2.24 | 250.24 |
| imported/leipzig/math-symbols | 69 | 1973.85 ± 0.2% | not timed | not timed | 618.47 ± 0.5% | 36.50 ± 0.1% | not timed | not timed | 1977.38 ± 0.7% | | 1.00 | 3.19 | 54.07 |
| imported/leipzig/bounded-strings-ending-z | 0 | 596.32 ± 0.4% | not timed | not timed | 617.85 ± 0.0% | 22.57 ± 0.2% | not timed | not timed | 594.71 ± 0.2% | | 1.00 | 0.97 | 26.42 |
| imported/lh3lh3-reb/uri | 17549 | 632.45 ± 0.1% | not timed | not timed | 1010.23 ± 0.4% | 28.35 ± 2.3% | not timed | not timed | 633.27 ± 0.1% | | 1.00 | 0.63 | 22.31 |
| imported/lh3lh3-reb/email | 15057 | 668.36 ± 0.1% | not timed | not timed | 1089.90 ± 0.2% | 30.97 ± 2.6% | not timed | not timed | 668.44 ± 0.1% | | 1.00 | 0.61 | 21.58 |
| imported/lh3lh3-reb/date | 668 | 865.62 ± 0.1% | not timed | not timed | 978.84 ± 0.3% | 50.23 ± 3.8% | not timed | not timed | 865.48 ± 0.2% | | 1.00 | 0.88 | 17.23 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 642.17 ± 0.3% | not timed | not timed | 413.57 ± 0.1% | 15.84 ± 1.3% | not timed | not timed | 643.36 ± 0.1% | | 1.00 | 1.55 | 40.54 |
| imported/mariomka/email | 92 | 704.77 ± 0.2% | not timed | not timed | 29513.29 ± 0.5% | 32.57 ± 0.6% | not timed | not timed | 706.47 ± 0.1% | | 1.00 | 0.0239 | 21.64 |
| imported/mariomka/uri | 5301 | 608.15 ± 0.1% | not timed | not timed | 6030.15 ± 0.6% | 32.77 ± 0.5% | not timed | not timed | 605.80 ± 0.1% | | 1.00 | 0.10 | 18.56 |
| imported/mariomka/ip | 5 | 2152.99 ± 2.4% | not timed | not timed | 2959.58 ± 0.6% | 21.07 ± 0.1% | not timed | not timed | 2153.18 ± 2.3% | | 1.00 | 0.73 | 102.18 |
| imported/rsc/no-exponential | 0 | 567.57 ± 0.3% | not timed | not timed | 309.54 ± 0.3% | 23.88 ± 0.4% | not timed | not timed | 569.25 ± 0.1% | | 1.00 | 1.83 | 23.77 |
| imported/rsc/literal | 1 | 740.98 ± 2.1% | not timed | not timed | 1385.13 ± 11.0% | 183.96 ± 19.7% | not timed | not timed | 741.94 ± 8.5% | | 1.00 | 0.53 | 4.03 |
| imported/rsc/not-literal | 2 | 706.33 ± 0.2% | not timed | not timed | 647.54 ± 0.1% | 46.38 ± 2.4% | not timed | not timed | 707.76 ± 8.6% | | 1.00 | 1.09 | 15.23 |
| imported/rsc/match-class | 1 | 1301.90 ± 8.6% | not timed | not timed | 1329.84 ± 0.4% | 58.63 ± 0.5% | not timed | not timed | 1310.24 ± 0.4% | | 0.99 | 0.98 | 22.20 |
| imported/rsc/match-class-in-range | 1 | 1308.99 ± 7.4% | not timed | not timed | 2166.05 ± 13.7% | 60.11 ± 2.6% | not timed | not timed | 1312.71 ± 0.4% | | 1.00 | 0.60 | 21.78 |
| imported/rsc/match-class-unicode | 1 | 525.79 ± 0.2% | not timed | not timed | 501.60 ± 0.1% | 72.47 ± 6.7% | not timed | not timed | 524.73 ± 1.6% | | 1.00 | 1.05 | 7.26 |
| imported/rsc/anchored-literal-short-non-match | 0 | 535.24 ± 0.3% | not timed | not timed | 869.51 ± 0.8% | 228.01 ± 0.7% | not timed | not timed | 534.14 ± 0.3% | | 1.00 | 0.62 | 2.35 |
| imported/rsc/anchored-literal-long-non-match | 0 | 7953.99 ± 0.1% | not timed | not timed | 13228.07 ± 0.2% | 3420.63 ± 0.9% | not timed | not timed | 7937.05 ± 0.1% | | 1.00 | 0.60 | 2.33 |
| imported/rsc/anchored-literal-short-match | 4 | 422.93 ± 2.6% | not timed | not timed | 426.93 ± 0.4% | 82.08 ± 7.8% | not timed | not timed | 420.67 ± 2.5% | | 1.01 | 0.99 | 5.15 |
| imported/rsc/anchored-literal-long-match | 4 | 2960.23 ± 2.3% | not timed | not timed | 6441.41 ± 0.2% | 1235.94 ± 0.9% | not timed | not timed | 3026.57 ± 2.2% | | 0.98 | 0.46 | 2.40 |
| imported/rsc/one-pass-short | 17 | 312.67 ± 2.0% | not timed | not timed | 198.97 ± 0.2% | 31.15 ± 10.5% | not timed | not timed | 313.05 ± 8.7% | | 1.00 | 1.57 | 10.04 |
| imported/rsc/one-pass-short-not | 17 | 219.55 ± 6.0% | not timed | not timed | 207.95 ± 0.6% | 30.91 ± 9.2% | not timed | not timed | 219.79 ± 2.1% | | 1.00 | 1.06 | 7.10 |
| imported/rsc/one-pass-long-prefix | 26 | 235.65 ± 2.2% | not timed | not timed | 262.85 ± 0.5% | 96.42 ± 16.2% | not timed | not timed | 238.34 ± 2.0% | | 0.99 | 0.90 | 2.44 |
| imported/rsc/one-pass-long-prefix-not | 26 | 314.45 ± 6.5% | not timed | not timed | 264.92 ± 0.4% | 66.15 ± 14.4% | not timed | not timed | 313.17 ± 1.7% | | 1.00 | 1.19 | 4.75 |
| imported/rsc/long-needle1 | 31 | 21929.09 ± 0.3% | not timed | not timed | 20171.40 ± 0.1% | 3.77 ± 0.3% | not timed | not timed | 21942.28 ± 0.3% | | 1.00 | 1.09 | 5815.48 |
| imported/rsc/long-needle2 | 31 | 22105.56 ± 0.0% | not timed | not timed | 216.15 ± 0.1% | 3.76 ± 0.2% | not timed | not timed | 22117.52 ± 0.2% | | 1.00 | 102.27 | 5877.37 |
| imported/rsc/easy0-32 | 26 | 1051.89 ± 2.7% | not timed | not timed | 1417.25 ± 9.9% | 148.51 ± 15.2% | not timed | not timed | 1049.69 ± 0.9% | | 1.00 | 0.74 | 7.08 |
| imported/rsc/easy0-1k | 26 | 15000.10 ± 2.3% | not timed | not timed | 11945.90 ± 3.4% | 2316.09 ± 13.5% | not timed | not timed | 15011.88 ± 0.2% | | 1.00 | 1.26 | 6.48 |
| imported/rsc/easy0-32k | 26 | 22908.96 ± 1.6% | not timed | not timed | 20412.03 ± 0.1% | 18785.90 ± 29.7% | not timed | not timed | 22915.07 ± 0.2% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21895.50 ± 1.5% | not timed | not timed | 20110.52 ± 0.7% | 37752.39 ± 1.9% | not timed | not timed | 21975.49 ± 0.6% | | 1.00 | 1.09 | 0.58 |
| imported/rsc/easy1-32 | 19 | 358.99 ± 2.4% | not timed | not timed | 574.39 ± 0.3% | 127.10 ± 16.7% | not timed | not timed | 360.58 ± 2.0% | | 1.00 | 0.62 | 2.82 |
| imported/rsc/easy1-1k | 19 | 583.94 ± 3.1% | not timed | not timed | 11844.02 ± 0.2% | 2471.70 ± 13.9% | not timed | not timed | 582.57 ± 0.3% | | 1.00 | 0.0493 | 0.24 |
| imported/rsc/easy1-32k | 19 | 602.66 ± 0.5% | not timed | not timed | 367549.46 ± 0.2% | 20476.78 ± 0.1% | not timed | not timed | 599.21 ± 0.4% | | 1.01 | 0.0016 | 0.0294 |
| imported/rsc/easy1-1mb | 19 | 603.81 ± 0.3% | not timed | not timed | 11867717.68 ± 0.4% | 38191.73 ± 4.6% | not timed | not timed | 600.15 ± 0.7% | | 1.01 | 0.0001 | 0.0158 |
| imported/rsc/medium-32 | 27 | 426.30 ± 0.3% | not timed | not timed | 587.67 ± 0.1% | 70.15 ± 13.7% | not timed | not timed | 425.63 ± 0.1% | | 1.00 | 0.73 | 6.08 |
| imported/rsc/medium-1k | 27 | 6758.94 ± 0.2% | not timed | not timed | 10534.17 ± 0.3% | 72.34 ± 0.1% | not timed | not timed | 6758.78 ± 0.2% | | 1.00 | 0.64 | 93.43 |
| imported/rsc/medium-32k | 27 | 21571.14 ± 0.1% | not timed | not timed | 326948.45 ± 0.1% | 48.54 ± 0.2% | not timed | not timed | 21579.05 ± 0.1% | | 1.00 | 0.0660 | 444.44 |
| imported/rsc/medium-1mb | 27 | 21140.91 ± 2.0% | not timed | not timed | 10447971.58 ± 0.2% | 48.47 ± 0.3% | not timed | not timed | 21302.46 ± 1.2% | | 0.99 | 0.0020 | 436.20 |
| imported/rsc/hard-32 | 58 | 255.09 ± 2.1% | not timed | not timed | 346.26 ± 0.1% | 49.36 ± 7.2% | not timed | not timed | 255.38 ± 0.2% | | 1.00 | 0.74 | 5.17 |
| imported/rsc/hard-1k | 27 | 575.91 ± 0.2% | not timed | not timed | 10685.42 ± 0.3% | 40.13 ± 0.1% | not timed | not timed | 574.50 ± 0.2% | | 1.00 | 0.0539 | 14.35 |
| imported/rsc/hard-32k | 27 | 602.33 ± 0.5% | not timed | not timed | 336150.54 ± 0.2% | 29.37 ± 0.1% | not timed | not timed | 599.29 ± 0.3% | | 1.01 | 0.0018 | 20.51 |
| imported/rsc/hard-1mb | 51 | 603.94 ± 1.0% | not timed | not timed | 6935633.89 ± 0.1% | 29.38 ± 0.1% | not timed | not timed | 600.46 ± 0.5% | | 1.01 | 0.0001 | 20.55 |
| imported/rsc/reallyhard0-32 | 58 | 254.52 ± 0.4% | not timed | not timed | 215.93 ± 0.1% | 49.80 ± 6.9% | not timed | not timed | 255.09 ± 2.5% | | 1.00 | 1.18 | 5.11 |
| imported/rsc/reallyhard0-1k | 27 | 577.27 ± 0.3% | not timed | not timed | 583.56 ± 0.1% | 40.68 ± 0.1% | not timed | not timed | 581.42 ± 0.3% | | 0.99 | 0.99 | 14.19 |
| imported/rsc/reallyhard0-32k | 27 | 600.70 ± 0.2% | not timed | not timed | 613.49 ± 0.0% | 29.41 ± 0.1% | not timed | not timed | 603.29 ± 0.5% | | 1.00 | 0.98 | 20.42 |
| imported/rsc/reallyhard0-1mb | 51 | 591.94 ± 0.5% | not timed | not timed | 618.55 ± 0.2% | 29.41 ± 0.2% | not timed | not timed | 594.52 ± 0.6% | | 1.00 | 0.96 | 20.13 |
| imported/rsc/reallyreallyhard0-32 | 47 | 274.14 ± 0.1% | not timed | not timed | 191.50 ± 0.9% | 60.68 ± 10.6% | not timed | not timed | 274.36 ± 4.4% | | 1.00 | 1.43 | 4.52 |
| imported/rsc/reallyreallyhard0-1k | 16 | 860.75 ± 2.3% | not timed | not timed | 5704.51 ± 0.1% | 34.23 ± 1.3% | not timed | not timed | 857.45 ± 0.9% | | 1.00 | 0.15 | 25.14 |
| imported/rsc/reallyreallyhard0-32k | 16 | 639.45 ± 4.3% | not timed | not timed | 19258.31 ± 0.1% | 24.97 ± 1.6% | not timed | not timed | 644.46 ± 5.6% | | 0.99 | 0.0332 | 25.61 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 594.03 ± 0.3% | not timed | not timed | 19860.99 ± 2.2% | 25.16 ± 0.1% | not timed | not timed | 590.63 ± 2.1% | | 1.01 | 0.0299 | 23.61 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 269.35 ± 0.1% | not timed | not timed | 210.82 ± 0.2% | 59.97 ± 7.8% | not timed | not timed | 268.67 ± 5.8% | | 1.00 | 1.28 | 4.49 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 841.49 ± 0.6% | not timed | not timed | 6080.73 ± 0.1% | 34.25 ± 1.7% | not timed | not timed | 841.15 ± 1.5% | | 1.00 | 0.14 | 24.57 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 625.91 ± 2.8% | not timed | not timed | 19200.79 ± 0.1% | 24.54 ± 1.1% | not timed | not timed | 622.72 ± 5.1% | | 1.01 | 0.0326 | 25.50 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 593.41 ± 0.6% | not timed | not timed | 19945.66 ± 1.6% | 24.95 ± 1.5% | not timed | not timed | 591.51 ± 0.7% | | 1.00 | 0.0298 | 23.78 |
| imported/sherlock/name-sherlock | 776 | 19887.95 ± 2.5% | not timed | not timed | 18495.33 ± 0.5% | 8906.15 ± 24.1% | not timed | not timed | 19947.84 ± 1.9% | | 1.00 | 1.08 | 2.23 |
| imported/sherlock/name-holmes | 2766 | 14727.56 ± 5.8% | not timed | not timed | 15338.82 ± 0.3% | 3137.28 ± 8.4% | not timed | not timed | 15349.21 ± 1.9% | | 0.96 | 0.96 | 4.69 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19966.69 ± 1.8% | not timed | not timed | 18621.91 ± 0.4% | 8166.72 ± 37.3% | not timed | not timed | 19991.42 ± 0.2% | | 1.00 | 1.07 | 2.44 |
| imported/sherlock/name-sherlock-casei | 816 | 15771.57 ± 0.3% | not timed | not timed | 4019.73 ± 0.2% | 32.58 ± 0.2% | not timed | not timed | 15767.70 ± 0.2% | | 1.00 | 3.92 | 484.06 |
| imported/sherlock/name-holmes-casei | 2802 | 9489.29 ± 6.3% | not timed | not timed | 3308.18 ± 0.1% | 37.61 ± 0.5% | not timed | not timed | 9461.81 ± 3.9% | | 1.00 | 2.87 | 252.31 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13133.04 ± 1.6% | not timed | not timed | 3956.37 ± 0.1% | 32.48 ± 0.4% | not timed | not timed | 13116.10 ± 0.6% | | 1.00 | 3.32 | 404.29 |
| imported/sherlock/name-whitespace | 1461 | 15252.12 ± 2.2% | not timed | not timed | 14484.33 ± 0.1% | 7464.22 ± 47.2% | not timed | not timed | 15225.20 ± 7.1% | | 1.00 | 1.05 | 2.04 |
| imported/sherlock/name-alt1 | 1142 | 11478.24 ± 2.5% | not timed | not timed | 16421.77 ± 0.9% | 4157.28 ± 25.0% | not timed | not timed | 11486.43 ± 0.5% | | 1.00 | 0.70 | 2.76 |
| imported/sherlock/name-alt2 | 3542 | 8600.04 ± 0.2% | not timed | not timed | 3816.49 ± 0.3% | 31.22 ± 0.2% | not timed | not timed | 8610.16 ± 0.3% | | 1.00 | 2.25 | 275.44 |
| imported/sherlock/name-alt3 | 4507 | 5451.96 ± 0.5% | not timed | not timed | 3612.82 ± 0.2% | 9.93 ± 1.7% | not timed | not timed | 5463.36 ± 0.4% | | 1.00 | 1.51 | 548.80 |
| imported/sherlock/name-alt3-casei | 4593 | 1517.44 ± 2.6% | not timed | not timed | 285.72 ± 0.2% | 6.47 ± 0.3% | not timed | not timed | 1521.48 ± 1.7% | | 1.00 | 5.31 | 234.52 |
| imported/sherlock/name-alt4 | 3686 | 6206.07 ± 0.1% | not timed | not timed | 3770.98 ± 0.1% | 31.31 ± 0.3% | not timed | not timed | 6217.18 ± 0.2% | | 1.00 | 1.65 | 198.21 |
| imported/sherlock/name-alt4-casei | 4254 | 2750.96 ± 11.3% | not timed | not timed | 2593.57 ± 0.2% | 19.88 ± 3.1% | not timed | not timed | 2758.30 ± 1.3% | | 1.00 | 1.06 | 138.37 |
| imported/sherlock/name-alt5 | 4028 | 6233.71 ± 0.2% | not timed | not timed | 3733.43 ± 0.3% | 21.74 ± 0.6% | not timed | not timed | 6236.15 ± 0.2% | | 1.00 | 1.67 | 286.80 |
| imported/sherlock/name-alt5-casei | 4104 | 3452.84 ± 2.1% | not timed | not timed | 2222.53 ± 0.1% | 14.37 ± 0.2% | not timed | not timed | 3469.06 ± 0.9% | | 1.00 | 1.55 | 240.22 |
| imported/sherlock/no-match-uncommon | 0 | 21803.01 ± 0.3% | not timed | not timed | 19740.25 ± 0.5% | 37019.23 ± 0.5% | not timed | not timed | 21773.00 ± 0.3% | | 1.00 | 1.10 | 0.59 |
| imported/sherlock/no-match-common | 0 | 21615.11 ± 0.3% | not timed | not timed | 19723.38 ± 0.3% | 1281.04 ± 1.4% | not timed | not timed | 21624.59 ± 0.1% | | 1.00 | 1.10 | 16.87 |
| imported/sherlock/no-match-really-common | 0 | 16374.80 ± 2.9% | not timed | not timed | 18893.20 ± 1.1% | 1269.84 ± 0.5% | not timed | not timed | 16345.87 ± 1.6% | | 1.00 | 0.87 | 12.90 |
| imported/sherlock/the-lower | 21654 | 2318.14 ± 1.1% | not timed | not timed | 2326.91 ± 0.2% | 238.55 ± 19.6% | not timed | not timed | 2330.86 ± 0.9% | | 0.99 | 1.00 | 9.72 |
| imported/sherlock/the-upper | 2223 | 12708.90 ± 1.5% | not timed | not timed | 13408.99 ± 0.5% | 2650.88 ± 19.8% | not timed | not timed | 12845.32 ± 1.6% | | 0.99 | 0.95 | 4.79 |
| imported/sherlock/the-casei | 23961 | 2011.56 ± 0.3% | not timed | not timed | 1283.72 ± 0.5% | 34.81 ± 18.3% | not timed | not timed | 2016.96 ± 2.8% | | 1.00 | 1.57 | 57.79 |
| imported/sherlock/everything-greedy | 581881 | 269.98 ± 0.5% | not timed | not timed | 163.94 ± 0.7% | 29.06 ± 36.6% | not timed | not timed | 271.10 ± 0.2% | | 1.00 | 1.65 | 9.29 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.35 ± 0.1% | not timed | not timed | 212.90 ± 0.2% | 32.89 ± 0.4% | not timed | not timed | 463.36 ± 0.2% | | 1.00 | 2.17 | 14.06 |
| imported/sherlock/letters | 447175 | 53.18 ± 7.6% | not timed | not timed | 31.95 ± 0.1% | 5.20 ± 17.7% | not timed | not timed | 54.31 ± 0.8% | | 0.98 | 1.66 | 10.23 |
| imported/sherlock/letters-upper | 14180 | 432.84 ± 1.3% | not timed | not timed | 366.35 ± 2.1% | 29.49 ± 28.9% | not timed | not timed | 434.61 ± 0.3% | | 1.00 | 1.18 | 14.68 |
| imported/sherlock/letters-lower | 432995 | 55.35 ± 0.4% | not timed | not timed | 33.01 ± 0.2% | 6.58 ± 3.7% | not timed | not timed | 55.36 ± 0.3% | | 1.00 | 1.68 | 8.41 |
| imported/sherlock/words | 447639 | 107.10 ± 0.9% | not timed | not timed | 81.67 ± 0.2% | 13.75 ± 30.3% | not timed | not timed | 107.53 ± 0.6% | | 1.00 | 1.31 | 7.79 |
| imported/sherlock/before-holmes | 4073 | 599.61 ± 0.6% | not timed | not timed | 8507.65 ± 0.5% | 23.97 ± 1.5% | not timed | not timed | 595.74 ± 0.7% | | 1.01 | 0.0705 | 25.02 |
| imported/sherlock/before-after-holmes | 2593 | 596.36 ± 0.7% | not timed | not timed | 9499.68 ± 0.4% | 24.19 ± 1.0% | not timed | not timed | 598.03 ± 0.3% | | 1.00 | 0.0628 | 24.65 |
| imported/sherlock/holmes-cochar-watson | 150 | 5223.19 ± 0.1% | not timed | not timed | 3434.25 ± 0.2% | 31.11 ± 0.2% | not timed | not timed | 5236.86 ± 0.2% | | 1.00 | 1.52 | 167.89 |
| imported/sherlock/holmes-coword-watson | 14309 | 1262.78 ± 1.8% | not timed | not timed | 1126.38 ± 0.2% | 6.78 ± 0.2% | not timed | not timed | 1264.11 ± 1.4% | | 1.00 | 1.12 | 186.20 |
| imported/sherlock/quotes | 14437 | 1415.11 ± 0.2% | not timed | not timed | 1758.40 ± 0.8% | 35.10 ± 0.3% | not timed | not timed | 1413.64 ± 0.3% | | 1.00 | 0.80 | 40.31 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 602.35 ± 0.7% | not timed | not timed | 16153.75 ± 0.2% | 36.75 ± 0.0% | not timed | not timed | 601.54 ± 0.8% | | 1.00 | 0.0373 | 16.39 |
| imported/sherlock/word-ending-n | 35297 | 468.03 ± 0.2% | not timed | not timed | 408.44 ± 0.1% | 23.57 ± 0.9% | not timed | not timed | 467.66 ± 0.2% | | 1.00 | 1.15 | 19.85 |
| imported/sherlock/repeated-class-negation | 2130 | 14699.07 ± 0.9% | not timed | not timed | 11040.79 ± 0.8% | 11.57 ± 0.2% | not timed | not timed | 14707.79 ± 0.7% | | 1.00 | 1.33 | 1270.87 |
| imported/sherlock/ing-suffix | 20547 | 555.34 ± 0.1% | not timed | not timed | 516.17 ± 0.1% | 28.75 ± 30.5% | not timed | not timed | 554.68 ± 1.4% | | 1.00 | 1.08 | 19.31 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 595.61 ± 0.3% | not timed | not timed | 2086.62 ± 1.7% | 20.52 ± 0.2% | not timed | not timed | 595.92 ± 0.4% | | 1.00 | 0.29 | 29.02 |
| opt/accelerate/whole-line | 239963 | 459.58 ± 0.1% | not timed | not timed | 364.22 ± 0.4% | 91.96 ± 16.5% | not timed | not timed | 459.27 ± 0.4% | | 1.00 | 1.26 | 5.00 |
| opt/accelerate/non-dna | 16745 | 412.05 ± 0.9% | not timed | not timed | 397.07 ± 0.1% | 29.42 ± 22.0% | not timed | not timed | 413.59 ± 0.4% | | 1.00 | 1.04 | 14.01 |
| opt/backtrack/words-english | 40536 | 137.35 ± 0.2% | not timed | not timed | 94.55 ± 0.1% | 19.95 ± 6.2% | not timed | not timed | 134.78 ± 8.4% | | 1.02 | 1.45 | 6.89 |
| opt/fixed-length/too-small-ascii | 0 | 313.03 ± 0.3% | not timed | not timed | 700.25 ± 1.4% | 80.02 ± 1.1% | not timed | not timed | 310.34 ± 0.5% | | 1.01 | 0.45 | 3.91 |
| opt/fixed-length/too-big-ascii | 0 | 645.26 ± 1.2% | not timed | not timed | 5797.16 ± 0.1% | 126.34 ± 0.1% | not timed | not timed | 653.79 ± 0.8% | | 0.99 | 0.11 | 5.11 |
| opt/fixed-length/go33484-1 | 0 | 45.50 ± 0.1% | not timed | not timed | 1114754.20 ± 0.6% | 61270.01 ± 0.3% | not timed | not timed | 45.50 ± 0.2% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5535.45 ± 0.1% | not timed | not timed | 1116932.43 ± 0.3% | 32276.11 ± 1.3% | not timed | not timed | 5519.07 ± 0.0% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1789.71 ± 1.9% | not timed | not timed | 110285.89 ± 0.2% | 766.26 ± 0.6% | not timed | not timed | 1782.01 ± 3.3% | | 1.00 | 0.0162 | 2.34 |
| opt/literal-alt/one-pattern | 1 | 555.57 ± 1.7% | not timed | not timed | 543.72 ± 0.1% | 0.40 ± 0.3% | not timed | not timed | 556.12 ± 0.1% | | 1.00 | 1.02 | 1404.83 |
| opt/onepass/fn-predicate | 916 | 367.59 ± 1.0% | not timed | not timed | 332.68 ± 0.2% | 199.56 ± 17.6% | not timed | not timed | 371.09 ± 0.2% | | 0.99 | 1.10 | 1.84 |
| opt/onepass/first-three-words-english | 35128 | 149.93 ± 1.2% | not timed | not timed | 202.34 ± 0.1% | 77.53 ± 14.2% | not timed | not timed | 149.97 ± 1.6% | | 1.00 | 0.74 | 1.93 |
| opt/prefilter/literal-english | 1 | 20852.27 ± 0.7% | not timed | not timed | 19996.31 ± 0.3% | 17537.81 ± 0.4% | not timed | not timed | 20803.32 ± 0.6% | | 1.00 | 1.04 | 1.19 |
| opt/prefilter/literal-casei-english | 1 | 14523.30 ± 0.7% | not timed | not timed | 4312.14 ± 0.2% | 32.73 ± 0.1% | not timed | not timed | 14531.00 ± 0.4% | | 1.00 | 3.37 | 443.75 |
| opt/prefilter/literal-russian | 1 | 21477.46 ± 0.5% | not timed | not timed | 19973.83 ± 0.6% | 3331.20 ± 0.2% | not timed | not timed | 21451.83 ± 0.4% | | 1.00 | 1.08 | 6.45 |
| opt/prefilter/literal-casei-russian | 1 | 8574.15 ± 0.3% | not timed | not timed | 3895.73 ± 0.1% | 30.92 ± 0.5% | not timed | not timed | 8586.83 ± 0.2% | | 1.00 | 2.20 | 277.32 |
| opt/prefilter/rust-functions | 948 | 6828.17 ± 0.4% | not timed | not timed | 9034.27 ± 0.3% | 1871.88 ± 0.5% | not timed | not timed | 6820.14 ± 0.5% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 5582.02 ± 0.2% | not timed | not timed | 16931338.01 ± 0.3% | 50.31 ± 0.3% | not timed | not timed | 5585.61 ± 0.4% | | 1.00 | 0.0003 | 110.95 |
| opt/reverse-inner/holmes | 2593 | 596.07 ± 0.4% | not timed | not timed | 9546.27 ± 0.6% | 24.14 ± 1.5% | not timed | not timed | 598.35 ± 0.4% | | 1.00 | 0.0624 | 24.69 |
| opt/reverse-inner/email | 47 | 1045.50 ± 0.1% | not timed | not timed | 44945.04 ± 0.8% | 32.46 ± 0.2% | not timed | not timed | 1044.96 ± 0.0% | | 1.00 | 0.0233 | 32.20 |
| opt/reverse-inner/factored-prefix | 3542 | 590.79 ± 0.5% | not timed | not timed | 595.04 ± 0.1% | 12.04 ± 0.4% | not timed | not timed | 591.98 ± 0.6% | | 1.00 | 0.99 | 49.06 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5510.26 ± 0.1% | not timed | not timed | 613.75 ± 0.4% | 75.13 ± 0.2% | not timed | not timed | 5519.87 ± 0.0% | | 1.00 | 8.98 | 73.34 |
| opt/reverse-inner/no-quadratic-forward | 0 | 687.75 ± 2.1% | not timed | not timed | 288.18 ± 0.1% | 24.78 ± 0.1% | not timed | not timed | 688.49 ± 1.9% | | 1.00 | 2.39 | 27.75 |
| opt/reverse-suffix/holmes | 4073 | 599.14 ± 0.5% | not timed | not timed | 8482.54 ± 0.3% | 24.03 ± 1.8% | not timed | not timed | 597.44 ± 0.3% | | 1.00 | 0.0706 | 24.93 |
| opt/reverse-suffix/no-quadratic | 0 | 5518.26 ± 0.1% | not timed | not timed | 614.00 ± 0.5% | 75.00 ± 0.1% | not timed | not timed | 5506.00 ± 0.0% | | 1.00 | 8.99 | 73.58 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.33 ± 2.7% | not timed | not timed | 131.65 ± 0.1% | 13.04 ± 15.2% | not timed | not timed | 121.22 ± 2.3% | | 1.00 | 0.92 | 9.30 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 118.72 ± 2.9% | not timed | not timed | 130.94 ± 0.3% | 13.21 ± 14.8% | not timed | not timed | 120.65 ± 0.5% | | 0.98 | 0.91 | 8.99 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.4% | not timed | not timed | 0.55 ± 0.7% | 113.90 ± 0.2% | not timed | not timed | 0.28 ± 0.3% | | 1.00 | 0.52 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 316.65 ± 0.2% | not timed | not timed | 289.54 ± 0.2% | 103.31 ± 7.6% | not timed | not timed | 309.60 ± 2.9% | | 1.02 | 1.09 | 3.07 |
| reported/i13-subset-regex/original-ascii | 4094 | 11093.05 ± 1.0% | not timed | not timed | 4557.20 ± 1.4% | 11.52 ± 0.2% | not timed | not timed | 11119.92 ± 1.1% | | 1.00 | 2.43 | 963.30 |
| reported/i13-subset-regex/original-unicode | 4094 | 10971.88 ± 2.4% | not timed | not timed | 254.01 ± 3.1% | 11.52 ± 0.1% | not timed | not timed | 11110.16 ± 0.8% | | 0.99 | 43.19 | 952.63 |
| reported/i13-subset-regex/big-ascii | 1955 | 10595.63 ± 1.6% | not timed | not timed | 68.20 ± 3.6% | 9.85 ± 0.2% | not timed | not timed | 10676.70 ± 2.9% | | 0.99 | 155.36 | 1075.82 |
| reported/i13-subset-regex/big-unicode | 1955 | 10184.14 ± 2.3% | not timed | not timed | 12.21 ± 54.9% | 9.86 ± 0.1% | not timed | not timed | 10423.21 ± 0.8% | | 0.98 | 834.21 | 1032.88 |
| reported/i13-subset-regex/huge-ascii | 55 | 9595.23 ± 3.6% | not timed | not timed | 11.04 ± 0.1% | 8.77 ± 0.1% | not timed | not timed | 9424.94 ± 4.8% | | 1.02 | 869.45 | 1093.65 |
| reported/i13-subset-regex/huge-unicode | 55 | 9828.03 ± 4.0% | not timed | not timed | 11.00 ± 0.3% | 8.77 ± 0.0% | not timed | not timed | 9679.31 ± 8.4% | | 1.02 | 893.52 | 1120.15 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.0% | not timed | not timed | 11.06 ± 0.1% | 8.75 ± 0.3% | not timed | not timed | 3.53 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.0% | not timed | not timed | 10.97 ± 0.4% | 8.77 ± 1.0% | not timed | not timed | 5.02 ± 0.0% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 470.25 ± 0.2% | not timed | not timed | 104.60 ± 0.2% | 6.58 ± 0.1% | not timed | not timed | 470.12 ± 0.1% | | 1.00 | 4.50 | 71.43 |
| reported/i787-keywords/opt-ascii | 5674 | 471.12 ± 0.3% | not timed | not timed | 268.61 ± 0.2% | 10.22 ± 0.4% | not timed | not timed | 470.73 ± 0.3% | | 1.00 | 1.75 | 46.10 |
| slow/quadratic-regex-1x | 100 | 6.96 ± 0.1% | not timed | not timed | 4.92 ± 0.1% | 0.05 ± 0.1% | not timed | not timed | 6.94 ± 0.3% | | 1.00 | 1.42 | 141.00 |
| slow/quadratic-regex-2x | 199 | 3.41 ± 0.1% | not timed | not timed | 2.75 ± 0.1% | 0.01 ± 0.2% | not timed | not timed | 3.40 ± 0.2% | | 1.00 | 1.24 | 266.90 |
| slow/quadratic-haystack-1x | 100 | 21.23 ± 6.3% | not timed | not timed | 9.98 ± 0.5% | 1.01 ± 14.5% | not timed | not timed | 21.16 ± 2.1% | | 1.00 | 2.13 | 20.95 |
| slow/quadratic-haystack-2x | 200 | 17.45 ± 0.7% | not timed | not timed | 5.54 ± 0.3% | 0.55 ± 1.4% | not timed | not timed | 17.41 ± 12.3% | | 1.00 | 3.15 | 31.96 |
| unicode/codepoints/any-one | 1112064 | 285.01 ± 0.4% | not timed | not timed | 174.11 ± 0.2% | 17.34 ± 18.6% | not timed | not timed | 283.86 ± 0.3% | | 1.00 | 1.64 | 16.44 |
| unicode/codepoints/any-all | 4382592 | 289.20 ± 0.3% | not timed | not timed | 246.75 ± 0.2% | 117.43 ± 0.1% | not timed | not timed | 289.42 ± 0.4% | | 1.00 | 1.17 | 2.46 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.77 ± 0.8% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 610.44 ± 0.2% | not timed | not timed | 616.26 ± 0.3% | 135.32 ± 0.7% | not timed | not timed | 610.85 ± 0.3% | | 1.00 | 0.99 | 4.51 |
| unicode/overlapping-words/ascii | 6156 | 31.81 ± 0.4% | not timed | not timed | 38.92 ± 0.2% | 3.95 ± 1.3% | not timed | not timed | 31.84 ± 0.2% | | 1.00 | 0.82 | 8.05 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 0.1% | not timed | not timed | 4.10 ± 0.4% | 2.36 ± 0.7% | not timed | not timed | 1.36 ± 0.2% | | 1.00 | 0.33 | 0.57 |
| unicode/overlapping-words/russian | 5710 | 1.22 ± 9.3% | not timed | not timed | 4.12 ± 0.1% | 6.27 ± 9.7% | not timed | not timed | 1.22 ± 0.4% | | 1.00 | 0.30 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 117.42 ± 7.3% | not timed | not timed | 81.56 ± 0.2% | 11.41 ± 13.2% | not timed | not timed | 117.23 ± 0.5% | | 1.00 | 1.44 | 10.29 |
| unicode/word/boundary-long-english | 3466 | 607.83 ± 0.7% | not timed | not timed | 605.51 ± 0.1% | 32.52 ± 0.5% | not timed | not timed | 607.49 ± 0.3% | | 1.00 | 1.00 | 18.69 |
| unicode/word/around-holmes-english | 27 | 603.92 ± 0.5% | not timed | not timed | 19603.73 ± 0.5% | 22.29 ± 1.0% | not timed | not timed | 603.66 ± 0.3% | | 1.00 | 0.0308 | 27.09 |
| wild/bibleref/long | 874 | 564.83 ± 0.2% | not timed | not timed | 583.37 ± 0.0% | 6.78 ± 0.1% | not timed | not timed | 564.82 ± 0.2% | | 1.00 | 0.97 | 83.28 |
| wild/bibleref/short | 30 | 24.87 ± 2.1% | not timed | not timed | 30.72 ± 0.3% | 14.00 ± 11.3% | not timed | not timed | 24.72 ± 5.1% | | 1.01 | 0.81 | 1.78 |
| wild/bibleref/line | 874 | 358.94 ± 2.9% | not timed | not timed | 212.57 ± 0.3% | 9.14 ± 8.0% | not timed | not timed | 359.62 ± 0.2% | | 1.00 | 1.69 | 39.25 |
| wild/caddy/caddy | 6 | 412.40 ± 8.4% | not timed | not timed | 247.82 ± 0.1% | 66.82 ± 14.8% | not timed | not timed | 415.14 ± 1.4% | | 0.99 | 1.66 | 6.17 |
| wild/dot-star-capture/rust-src-tools | 6 | 1058.13 ± 0.4% | not timed | not timed | 347.88 ± 0.1% | 13.48 ± 0.1% | not timed | not timed | 1058.48 ± 0.8% | | 1.00 | 3.04 | 78.48 |
| wild/ruff/noqa | 84 | 404.38 ± 0.1% | not timed | not timed | 461.93 ± 0.1% | 19.58 ± 2.0% | not timed | not timed | 404.65 ± 0.1% | | 1.00 | 0.88 | 20.65 |
| wild/ruff/unnecessary-coding-comment | 16 | 489.85 ± 0.6% | not timed | not timed | 683.28 ± 0.1% | 136.52 ± 11.2% | not timed | not timed | 489.35 ± 0.7% | | 1.00 | 0.72 | 3.59 |
| wild/ruff/string-quote-prefix | 2972 | 408.33 ± 0.6% | not timed | not timed | 444.00 ± 0.2% | 375.10 ± 30.9% | not timed | not timed | 408.23 ± 0.5% | | 1.00 | 0.92 | 1.09 |
| wild/ruff/space-around-operator | 1224378 | 218.02 ± 1.8% | not timed | not timed | 186.10 ± 0.1% | 18.23 ± 2.2% | not timed | not timed | 218.17 ± 1.3% | | 1.00 | 1.17 | 11.96 |
| wild/ruff/shebang | 282 | 402.07 ± 0.4% | not timed | not timed | 328.49 ± 0.1% | 122.21 ± 11.3% | not timed | not timed | 401.83 ± 0.5% | | 1.00 | 1.22 | 3.29 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13692.63 ± 1.0% | not timed | not timed | 13697.48 ± 1.2% | 6837.64 ± 1.3% | not timed | not timed | 13712.47 ± 1.0% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12682.19 ± 1.0% | not timed | not timed | 13378.56 ± 0.8% | 6319.13 ± 0.4% | not timed | not timed | 12721.37 ± 0.4% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13104.55 ± 1.0% | not timed | not timed | 13550.17 ± 1.1% | 6541.32 ± 35.7% | not timed | not timed | 13059.02 ± 5.9% | | 1.00 | 0.97 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9435.04 ± 1.2% | not timed | not timed | 13559.05 ± 0.8% | 6703.34 ± 1.8% | not timed | not timed | 9449.27 ± 1.4% | | 1.00 | 0.70 | 1.41 |
| wild/url/search | 234965 | 122.29 ± 14.3% | not timed | not timed | 65.58 ± 1.6% | 2.25 ± 0.4% | not timed | not timed | 121.92 ± 14.0% | | 1.00 | 1.86 | 54.45 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 2.9% | not timed | not timed | 0.01 ± 0.5% | 0.01 ± 20.1% | not timed | not timed | 0.03 ± 2.3% | | 0.98 | 3.08 | 3.93 |
| dictionary/compile/english-15 | 1 | 0.35 ± 0.6% | not timed | not timed | 0.07 ± 0.7% | 0.10 ± 11.7% | not timed | not timed | 0.35 ± 44.3% | | 0.99 | 5.10 | 3.47 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 1.6% | not timed | not timed | 0.02 ± 0.5% | 35.11 ± 6.0% | not timed | not timed | 0.24 ± 1.5% | | 1.02 | 13.37 | 0.0071 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.25 ± 5.5% | not timed | not timed | 11.52 ± 0.3% | 53.73 ± 18.9% | not timed | not timed | 46.67 ± 2.6% | | 0.99 | 4.02 | 0.86 |
| reported/i787-keywords/compile | 1 | 34.52 ± 17.1% | not timed | not timed | 2.14 ± 0.6% | 16.76 ± 21.3% | not timed | not timed | 34.53 ± 1.4% | | 1.00 | 16.15 | 2.06 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 339.78 ± 5.5% | not timed | not timed | 118.59 ± 0.1% | 564.51 ± 14.2% | not timed | not timed | 342.49 ± 1.6% | | 0.99 | 2.87 | 0.60 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 46.77 ± 2.9% | not timed | not timed | 4.12 ± 0.6% | 43.55 ± 16.4% | not timed | not timed | 47.35 ± 2.0% | | 0.99 | 11.35 | 1.07 |
| unicode/compile/one-letter | 53 | 6.41 ± 12.6% | not timed | not timed | 4.56 ± 0.5% | 63.94 ± 6.6% | not timed | not timed | 6.53 ± 1.9% | | 0.98 | 1.41 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.05 ± 5.0% | not timed | not timed | 0.10 ± 0.3% | 65.30 ± 18.4% | not timed | not timed | 1.07 ± 16.5% | | 0.98 | 10.64 | 0.0161 |
| unicode/compile/fifty-letters-ascii | 1 | 213.02 ± 3.4% | not timed | not timed | 52.38 ± 0.3% | 175.57 ± 17.7% | not timed | not timed | 215.22 ± 3.0% | | 0.99 | 4.07 | 1.21 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 372.88 ± 18.8% | not timed | not timed | 47.38 ± 0.2% | 668.42 ± 13.9% | not timed | not timed | 374.15 ± 2.5% | | 1.00 | 7.87 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 580.22 ± 3.6% | not timed | not timed | 145.98 ± 0.3% | 671.04 ± 30.6% | not timed | not timed | 586.88 ± 7.5% | | 0.99 | 3.97 | 0.86 |
| unicode/compile/negated-class-matches-codepoint | 1 | 301.20 ± 3.9% | not timed | not timed | 51.21 ± 0.6% | 1233.06 ± 2.9% | not timed | not timed | 310.64 ± 4.2% | | 0.97 | 5.88 | 0.24 |
| wild/bibleref/compile | 3 | 5.68 ± 20.6% | not timed | not timed | 1.93 ± 0.5% | 31.73 ± 16.5% | not timed | not timed | 5.74 ± 4.0% | | 0.99 | 2.94 | 0.18 |
| wild/url/compile | 1 | 0.54 ± 15.8% | not timed | not timed | 0.15 ± 0.5% | 0.46 ± 7.0% | not timed | not timed | 0.63 ± 18.8% | | 0.86 | 3.75 | 1.19 |

