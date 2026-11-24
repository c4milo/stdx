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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391496695 |
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
| literal: a word | 217 | 19232.85 ± 1.9% | 5026.87 ± 0.3% | 28.09 ± 0.4% | 18134.91 ± 2.3% | 9019.00 ± 9.9% | 17.48 ± 0.2% | 84.43 ± 0.4% | 19320.66 ± 2.1% | 3.83 | 1.00 | 1.06 | 2.13 |
| literal: a word that is not there | 0 | 21293.67 ± 2.2% | 4914.00 ± 0.5% | 28.14 ± 0.7% | 19443.86 ± 2.4% | 28441.09 ± 2.1% | 17.21 ± 0.6% | 79.92 ± 0.3% | 21231.90 ± 1.6% | 4.33 | 1.00 | 1.10 | 0.75 |
| literal: one of four words | 661 | 6361.60 ± 0.3% | 1943.99 ± 0.3% | 14.26 ± 0.6% | 3950.19 ± 0.2% | 21.85 ± 0.1% | 5.27 ± 0.1% | 6.89 ± 3.0% | 6343.37 ± 0.5% | 3.27 | 1.00 | 1.61 | 291.13 |
| literal: a word in any case | 217 | 15131.20 ± 0.6% | 2087.93 ± 0.2% | 21.24 ± 0.1% | 3976.63 ± 0.2% | 37.99 ± 0.3% | refused | differs | 15119.08 ± 0.7% | 7.25 | 1.00 | 3.81 | 398.28 |
| literal: an href attribute | 33 | 16893.56 ± 2.8% | 610.08 ± 0.1% | 26.77 ± 0.3% | 17031.64 ± 2.5% | 2255.44 ± 8.7% | 13.26 ± 0.4% | 74.09 ± 0.3% | 16799.40 ± 2.5% | 27.69 | 1.01 | 0.99 | 7.49 |
| literal: a word, second text | 123 | 19945.67 ± 2.8% | 3385.63 ± 0.2% | 27.70 ± 0.2% | 18144.99 ± 3.7% | 7565.51 ± 1.8% | 19.60 ± 0.5% | 70.51 ± 0.4% | 19913.63 ± 3.5% | 5.89 | 1.00 | 1.10 | 2.64 |
| class: two capitalized words | 1331 | 1070.09 ± 0.5% | 598.69 ± 0.1% | 25.74 ± 0.2% | 585.68 ± 0.1% | 40.55 ± 8.7% | 14.74 ± 0.3% | 67.49 ± 0.3% | 1070.44 ± 0.5% | 1.79 | 1.00 | 1.83 | 26.39 |
| class: a word that ends in ing | 3399 | 573.20 ± 0.1% | 573.03 ± 0.3% | 17.81 ± 0.2% | 547.81 ± 0.2% | 29.60 ± 12.7% | 8.17 ± 0.2% | 18.41 ± 0.2% | 573.72 ± 0.3% | 1.00 | 1.00 | 1.05 | 19.36 |
| class: a word in capitals | 2332 | 1377.23 ± 0.5% | 604.59 ± 0.2% | 27.25 ± 0.9% | 572.55 ± 0.1% | 43.58 ± 0.7% | 17.19 ± 0.2% | 82.49 ± 0.3% | 1377.81 ± 0.7% | 2.28 | 1.00 | 2.41 | 31.60 |
| class: a number | 8288 | 1998.22 ± 0.1% | 828.27 ± 0.1% | 27.49 ± 0.3% | 1732.73 ± 0.2% | 40.02 ± 16.4% | 0.56 ± 0.1% | 57.41 ± 0.5% | 1996.27 ± 0.4% | 2.41 | 1.00 | 1.15 | 49.93 |
| class: two capitalized words, second text | 5359 | 515.87 ± 0.3% | 523.75 ± 0.2% | 23.04 ± 0.1% | 485.63 ± 0.1% | 31.04 ± 12.7% | 16.64 ± 0.2% | 62.90 ± 0.2% | 516.02 ± 0.2% | 0.98 | 1.00 | 1.06 | 16.62 |
| other: a word between two words | 6104 | 792.04 ± 0.2% | 593.08 ± 0.1% | 23.26 ± 0.1% | 736.91 ± 0.2% | 105.43 ± 5.9% | 11.30 ± 0.1% | 68.33 ± 1.5% | 791.87 ± 0.1% | 1.34 | 1.00 | 1.07 | 7.51 |
| other: a number before a unit, second text | 1481 | 5992.16 ± 0.8% | 1120.44 ± 0.3% | 25.87 ± 0.2% | 5649.81 ± 0.4% | 40.76 ± 14.2% | 17.80 ± 0.1% | 65.86 ± 0.3% | 5974.41 ± 1.3% | 5.35 | 1.00 | 1.06 | 147.01 |
| other: a heading's start tag | 110 | 14066.32 ± 1.3% | 743.07 ± 0.1% | 27.15 ± 0.3% | 1707.74 ± 0.3% | 1572.00 ± 2.7% | 16.20 ± 0.5% | 86.21 ± 0.3% | 14066.80 ± 1.1% | 18.93 | 1.00 | 8.24 | 8.95 |
| other: a whole word | 217 | 15731.10 ± 0.5% | 602.07 ± 0.2% | 28.87 ± 0.3% | 14456.76 ± 0.9% | 49.45 ± 8.8% | 13.53 ± 0.2% | 54.98 ± 0.2% | 15780.88 ± 0.4% | 26.13 | 1.00 | 1.09 | 318.13 |
| other: a line's first word, second text | 3716 | 2037.19 ± 0.3% | 587.35 ± 0.3% | 30.43 ± 0.3% | 1719.87 ± 0.8% | 63.05 ± 2.6% | refused | refused | 2042.24 ± 0.3% | 3.47 | 1.00 | 1.18 | 32.31 |
| other: fourteen octets before an x | 87 | 23854.68 ± 2.4% | 248.62 ± 0.7% | 6.29 ± 0.1% | 3959.73 ± 0.5% | 10.64 ± 0.1% | differs | 17.76 ± 0.2% | 23703.18 ± 6.4% | 95.95 | 1.01 | 6.02 | 2241.83 |
| other: a Greek word | 21815 | 498.47 ± 0.5% | 413.55 ± 0.2% | 30.60 ± 0.1% | 289.44 ± 0.2% | 47.54 ± 10.2% | differs | refused | 500.92 ± 0.5% | 1.21 | 1.00 | 1.72 | 10.49 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.52 ± 0.3% | 19.50 ± 0.0% | 0.85 ± 0.3% | 19.81 ± 0.4% | 2.76 ± 0.5% | differs | 4.05 ± 0.1% | 19.50 ± 0.3% | 1.00 | 1.00 | 0.99 | 7.07 |
| a UUID | 32895 | 20.92 ± 0.1% | 21.08 ± 0.5% | 0.64 ± 0.2% | 15.16 ± 0.6% | 3.11 ± 0.2% | 0.72 ± 0.4% | 3.64 ± 0.5% | 21.04 ± 0.5% | 0.99 | 0.99 | 1.38 | 6.73 |
| an IPv4 address | 33176 | 35.75 ± 0.3% | 35.95 ± 0.1% | 2.05 ± 0.1% | 29.00 ± 0.1% | 6.66 ± 0.4% | differs | 4.16 ± 0.2% | 35.95 ± 0.2% | 0.99 | 0.99 | 1.23 | 5.37 |
| a date and time | 32954 | 30.92 ± 0.4% | 31.02 ± 0.5% | 1.43 ± 0.1% | 21.16 ± 0.1% | 7.04 ± 0.7% | 1.20 ± 0.3% | 7.14 ± 0.3% | 31.06 ± 0.5% | 1.00 | 1.00 | 1.46 | 4.39 |
| a field path | 32606 | 23.16 ± 0.2% | 23.11 ± 0.2% | 1.01 ± 0.8% | 23.06 ± 0.2% | 3.52 ± 0.8% | differs | 2.98 ± 0.2% | 23.11 ± 0.1% | 1.00 | 1.00 | 1.00 | 6.59 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.18 ± 1.6% | 11.21 ± 1.0% | 11.14 ± 0.6% | 11.44 ± 0.1% | 4.94 ± 0.8% | 0.90 ± 0.3% | none | 11.16 ± 0.6% | 1.00 | 1.00 | 0.98 | 2.26 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 218.18 ± 0.2% | 219.51 ± 0.2% | 261.62 ± 0.3% | 86.85 ± 0.5% | 218.63 ± 0.6% | 483.51 ± 0.8% | 3788.28 ± 0.3% | 218.26 ± 0.2% | 0.99 | 1.00 | 2.51 | 1.00 |
| a UUID | 62 | 143.47 ± 0.2% | 144.13 ± 0.1% | 162.17 ± 0.2% | 46.35 ± 1.1% | 98.21 ± 1.8% | 185.66 ± 2.1% | 4162.06 ± 0.5% | 143.68 ± 0.3% | 1.00 | 1.00 | 3.10 | 1.46 |
| an IPv4 address | 29 | 409.37 ± 0.5% | 413.88 ± 0.5% | 594.84 ± 0.4% | 78.21 ± 0.7% | 130.12 ± 1.9% | 294.76 ± 0.8% | 7489.23 ± 0.3% | 409.03 ± 0.5% | 0.99 | 1.00 | 5.23 | 3.15 |
| a date and time | 56 | 296.61 ± 0.3% | 298.91 ± 0.2% | 382.22 ± 0.2% | 73.20 ± 0.1% | 134.75 ± 2.2% | 325.65 ± 2.1% | 4792.59 ± 0.8% | 296.72 ± 0.4% | 0.99 | 1.00 | 4.05 | 2.20 |
| a field path | 39 | 209.94 ± 0.3% | 210.68 ± 0.3% | 248.99 ± 0.3% | 79.99 ± 2.3% | 201.27 ± 12.3% | 515.32 ± 4.2% | 4861.25 ± 2.7% | 209.73 ± 0.2% | 1.00 | 1.00 | 2.62 | 1.04 |
| literal: a word | 7 | 604.61 ± 0.5% | 653.78 ± 0.6% | 1223.56 ± 0.9% | 509.37 ± 0.1% | 626.62 ± 1.6% | 967.23 ± 0.6% | 30437.60 ± 0.2% | 605.43 ± 0.4% | 0.92 | 1.00 | 1.19 | 0.96 |
| literal: a word that is not there | 8 | 581.06 ± 0.6% | 633.55 ± 0.6% | 1151.07 ± 0.6% | 464.73 ± 0.4% | 602.35 ± 1.2% | 914.30 ± 0.4% | 29291.73 ± 0.1% | 581.29 ± 0.2% | 0.92 | 1.00 | 1.25 | 0.96 |
| literal: one of four words | 26 | 235.78 ± 0.3% | 385.78 ± 0.3% | 538.58 ± 0.5% | 49.77 ± 0.8% | 236.37 ± 4.7% | 373.77 ± 1.0% | 15954.78 ± 0.2% | 235.82 ± 0.2% | 0.61 | 1.00 | 4.74 | 1.00 |
| literal: a word in any case | 11 | 439.13 ± 0.3% | 468.21 ± 0.5% | 712.10 ± 0.1% | 15.55 ± 0.1% | 639.38 ± 10.0% | refused | 23796.91 ± 0.2% | 438.98 ± 0.1% | 0.94 | 1.00 | 28.23 | 0.69 |
| literal: an href attribute | 12 | 329.96 ± 0.3% | 342.11 ± 0.1% | 459.63 ± 0.3% | 44.61 ± 0.7% | 494.72 ± 1.5% | 776.45 ± 0.2% | 21586.92 ± 0.3% | 330.01 ± 0.3% | 0.96 | 1.00 | 7.40 | 0.67 |
| literal: a word, second text | 10 | 541.41 ± 0.3% | 597.59 ± 0.4% | 1035.97 ± 1.0% | 420.95 ± 1.7% | 533.85 ± 1.5% | 800.11 ± 0.4% | 27219.01 ± 0.2% | 541.35 ± 0.7% | 0.91 | 1.00 | 1.29 | 1.01 |
| class: two capitalized words | 23 | 423.58 ± 0.3% | 453.57 ± 0.7% | 672.21 ± 0.6% | 101.42 ± 0.1% | 496.33 ± 1.1% | 745.17 ± 0.6% | 6433.42 ± 0.4% | 424.31 ± 0.7% | 0.93 | 1.00 | 4.18 | 0.85 |
| class: a word that ends in ing | 9 | 534.39 ± 0.3% | 599.09 ± 0.5% | 1085.50 ± 0.4% | 134.39 ± 1.6% | 757.06 ± 1.4% | 1139.66 ± 0.4% | 15905.11 ± 1.5% | 535.69 ± 0.2% | 0.89 | 1.00 | 3.98 | 0.71 |
| class: a word in capitals | 16 | 474.42 ± 0.3% | 515.87 ± 0.7% | 844.54 ± 0.2% | 138.11 ± 1.1% | 738.01 ± 8.0% | 1059.59 ± 0.7% | 8516.68 ± 0.2% | 474.91 ± 0.2% | 0.92 | 1.00 | 3.44 | 0.64 |
| class: a number | 6 | 600.29 ± 0.3% | 666.89 ± 0.4% | 1302.31 ± 0.1% | 42.03 ± 0.8% | 1391.40 ± 4.1% | 1876.63 ± 1.8% | 22842.56 ± 0.3% | 601.06 ± 0.4% | 0.90 | 1.00 | 14.28 | 0.43 |
| class: two capitalized words, second text | 23 | 424.27 ± 0.4% | 454.27 ± 0.4% | 674.61 ± 0.6% | 101.32 ± 0.6% | 495.47 ± 1.7% | 740.05 ± 0.6% | 6454.66 ± 0.3% | 423.96 ± 0.7% | 0.93 | 1.00 | 4.19 | 0.86 |
| other: a word between two words | 13 | 520.46 ± 0.3% | 540.34 ± 0.4% | 892.92 ± 0.5% | 133.52 ± 0.1% | 496.56 ± 2.0% | 815.13 ± 1.0% | 14561.95 ± 0.9% | 521.16 ± 0.3% | 0.96 | 1.00 | 3.90 | 1.05 |
| other: a number before a unit, second text | 15 | 377.28 ± 0.1% | 414.11 ± 0.6% | 592.29 ± 0.2% | 39.54 ± 1.4% | 629.68 ± 0.9% | 905.02 ± 1.2% | 15189.54 ± 0.2% | 377.62 ± 0.4% | 0.91 | 1.00 | 9.54 | 0.60 |
| other: a heading's start tag | 13 | 344.01 ± 0.2% | 351.02 ± 0.1% | 470.18 ± 0.3% | 44.86 ± 0.4% | 623.21 ± 0.7% | 873.16 ± 1.1% | 17979.32 ± 0.7% | 343.86 ± 0.3% | 0.98 | 1.00 | 7.67 | 0.55 |
| other: a whole word | 11 | 558.41 ± 0.5% | 596.51 ± 0.3% | 1032.94 ± 0.2% | 120.63 ± 1.5% | 558.49 ± 1.3% | 839.33 ± 1.2% | 27153.61 ± 0.4% | 559.86 ± 0.6% | 0.94 | 1.00 | 4.63 | 1.00 |
| other: a line's first word, second text | 17 | 507.73 ± 0.4% | 531.23 ± 0.3% | 879.38 ± 0.5% | 129.51 ± 0.3% | 695.68 ± 2.1% | refused | refused | 508.47 ± 0.7% | 0.96 | 1.00 | 3.92 | 0.73 |
| other: fourteen octets before an x | 16 | 107.56 ± 0.8% | 152.94 ± 0.5% | 179.66 ± 0.9% | 14.99 ± 0.7% | 449.34 ± 2.6% | 405.66 ± 1.3% | 12777.42 ± 0.4% | 107.60 ± 0.3% | 0.70 | 1.00 | 7.18 | 0.24 |
| other: a Greek word | 8 | 413.89 ± 0.5% | 562.64 ± 0.3% | 971.19 ± 0.2% | 59.03 ± 0.9% | 1376.17 ± 1.7% | 1818.13 ± 0.4% | refused | 414.03 ± 0.2% | 0.74 | 1.00 | 7.01 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15565.17 ± 1.2% | not timed | not timed | 16005.87 ± 1.1% | 2102.05 ± 17.6% | not timed | not timed | 15596.91 ± 0.6% | | 1.00 | 0.97 | 7.40 |
| 01-literal/sherlock-casei-en | 522 | 11010.42 ± 7.2% | not timed | not timed | 3592.66 ± 0.3% | 32.48 ± 0.2% | not timed | not timed | 11018.80 ± 5.8% | | 1.00 | 3.06 | 339.01 |
| 01-literal/sherlock-ru | 724 | 17129.16 ± 0.5% | not timed | not timed | 17307.83 ± 0.5% | 1418.07 ± 9.9% | not timed | not timed | 17135.34 ± 0.4% | | 1.00 | 0.99 | 12.08 |
| 01-literal/sherlock-casei-ru | 746 | 6179.31 ± 0.8% | not timed | not timed | 3325.91 ± 0.1% | 30.80 ± 7.2% | not timed | not timed | 6188.21 ± 0.2% | | 1.00 | 1.86 | 200.65 |
| 01-literal/sherlock-zh | 30 | 19861.63 ± 0.5% | not timed | not timed | 18762.41 ± 0.5% | 2717.57 ± 3.6% | not timed | not timed | 19870.66 ± 0.6% | | 1.00 | 1.06 | 7.31 |
| 02-literal-alternate/sherlock-en | 714 | 6069.28 ± 0.3% | not timed | not timed | 3946.63 ± 0.2% | 16.58 ± 6.0% | not timed | not timed | 6068.10 ± 0.7% | | 1.00 | 1.54 | 365.98 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1976.32 ± 1.2% | not timed | not timed | 698.07 ± 0.5% | 11.10 ± 0.3% | not timed | not timed | 1988.46 ± 1.0% | | 0.99 | 2.83 | 177.98 |
| 02-literal-alternate/sherlock-ru | 899 | 5564.21 ± 0.2% | not timed | not timed | 3259.12 ± 0.4% | 22.63 ± 0.2% | not timed | not timed | 5563.74 ± 0.2% | | 1.00 | 1.71 | 245.83 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2057.12 ± 0.4% | not timed | not timed | 1233.48 ± 0.1% | 9.10 ± 0.3% | not timed | not timed | 2058.42 ± 0.5% | | 1.00 | 1.67 | 226.00 |
| 02-literal-alternate/sherlock-zh | 207 | 7303.48 ± 0.2% | not timed | not timed | 4161.80 ± 0.5% | 31.44 ± 0.2% | not timed | not timed | 7299.43 ± 0.3% | | 1.00 | 1.75 | 232.32 |
| 03-date/ascii | 111817 | 124.39 ± 0.6% | not timed | not timed | 95.78 ± 0.2% | 0.20 ± 6.8% | not timed | not timed | 124.68 ± 0.7% | | 1.00 | 1.30 | 623.42 |
| 04-ruff-noqa/real | 84 | 403.00 ± 0.1% | not timed | not timed | 458.65 ± 0.1% | 19.67 ± 1.3% | not timed | not timed | 402.87 ± 0.1% | | 1.00 | 0.88 | 20.49 |
| 04-ruff-noqa/tweaked | 44 | 556.82 ± 0.4% | not timed | not timed | 459.63 ± 0.1% | 363.24 ± 0.3% | not timed | not timed | 557.01 ± 0.5% | | 1.00 | 1.21 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.24 ± 0.5% | not timed | not timed | 5.06 ± 0.1% | 0.21 ± 3.9% | not timed | not timed | 5.19 ± 3.8% | | 1.01 | 1.04 | 25.44 |
| 06-cloud-flare-redos/original | 107 | 414.11 ± 1.2% | not timed | not timed | 213.62 ± 0.0% | 24.88 ± 10.6% | not timed | not timed | 415.16 ± 0.1% | | 1.00 | 1.94 | 16.64 |
| 06-cloud-flare-redos/simplified-short | 102 | 414.42 ± 7.8% | not timed | not timed | 228.23 ± 0.1% | 26.60 ± 7.9% | not timed | not timed | 409.78 ± 0.3% | | 1.01 | 1.82 | 15.58 |
| 06-cloud-flare-redos/simplified-long | 10000 | 586.73 ± 0.2% | not timed | not timed | 253.50 ± 0.2% | 28.71 ± 0.3% | not timed | not timed | 577.04 ± 0.4% | | 1.02 | 2.31 | 20.43 |
| 07-unicode-character-data/parse-line | 558784 | 239.68 ± 0.6% | not timed | not timed | 171.80 ± 0.2% | 42.60 ± 2.1% | not timed | not timed | 242.32 ± 0.4% | | 0.99 | 1.40 | 5.63 |
| 08-words/all-english | 56691 | 115.98 ± 0.6% | not timed | not timed | 82.87 ± 0.1% | 11.83 ± 3.2% | not timed | not timed | 116.67 ± 0.5% | | 0.99 | 1.40 | 9.80 |
| 08-words/long-english | 839 | 614.26 ± 0.3% | not timed | not timed | 596.91 ± 0.1% | 32.42 ± 0.6% | not timed | not timed | 614.40 ± 0.2% | | 1.00 | 1.03 | 18.95 |
| 09-aws-keys/full | 0 | 408.04 ± 0.1% | not timed | not timed | 460.92 ± 0.2% | 64.50 ± 0.1% | not timed | not timed | 408.43 ± 0.1% | | 1.00 | 0.89 | 6.33 |
| 09-aws-keys/quick | 0 | 870.24 ± 0.1% | not timed | not timed | 985.24 ± 0.3% | 417.57 ± 0.2% | not timed | not timed | 871.16 ± 0.2% | | 1.00 | 0.88 | 2.08 |
| 10-bounded-repeat/letters-en | 1833 | 577.01 ± 2.6% | not timed | not timed | 517.17 ± 0.6% | 19.56 ± 0.5% | not timed | not timed | 577.93 ± 1.6% | | 1.00 | 1.12 | 29.50 |
| 10-bounded-repeat/letters-ru | 3475 | 508.81 ± 1.6% | not timed | not timed | 478.24 ± 0.3% | 22.29 ± 16.6% | not timed | not timed | 510.05 ± 0.9% | | 1.00 | 1.06 | 22.82 |
| 10-bounded-repeat/context | 53 | 85.17 ± 2.1% | not timed | not timed | 65.91 ± 0.5% | 19.83 ± 0.2% | not timed | not timed | 85.24 ± 1.5% | | 1.00 | 1.29 | 4.30 |
| 10-bounded-repeat/capitals | 11 | 641.64 ± 8.0% | not timed | not timed | 618.22 ± 0.0% | 36.57 ± 0.1% | not timed | not timed | 640.90 ± 8.0% | | 1.00 | 1.04 | 17.54 |
| 11-unstructured-to-json/extract | 600 | 56.82 ± 0.9% | not timed | not timed | 76.95 ± 0.1% | 48.94 ± 0.3% | not timed | not timed | 56.88 ± 0.1% | | 1.00 | 0.74 | 1.16 |
| 12-dictionary/single | 1 | 567.08 ± 0.2% | not timed | not timed | 562.96 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 568.39 ± 0.3% | | 1.00 | 1.01 | 1410.06 |
| 14-quadratic/1x | 100 | 21.23 ± 1.4% | not timed | not timed | 10.02 ± 0.3% | 0.98 ± 4.8% | not timed | not timed | 21.16 ± 2.4% | | 1.00 | 2.12 | 21.72 |
| 14-quadratic/2x | 200 | 17.43 ± 1.4% | not timed | not timed | 5.55 ± 0.2% | 0.53 ± 1.4% | not timed | not timed | 17.39 ± 0.8% | | 1.00 | 3.14 | 32.68 |
| 14-quadratic/10x | 1000 | 7.70 ± 0.5% | not timed | not timed | 1.21 ± 0.3% | 0.12 ± 1.6% | not timed | not timed | 7.69 ± 0.8% | | 1.00 | 6.35 | 66.72 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.21 ± 2.7% | not timed | not timed | 0.34 ± 0.9% | 0.55 ± 15.0% | not timed | not timed | 1.21 ± 2.8% | | 1.00 | 3.53 | 2.21 |
| 04-ruff-noqa/compile-real | 1 | 103.82 ± 1.5% | not timed | not timed | 13.75 ± 0.5% | 138.16 ± 3.7% | not timed | not timed | 105.11 ± 0.6% | | 0.99 | 7.55 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 13.96 ± 0.8% | not timed | not timed | 2.53 ± 0.8% | 6.43 ± 2.3% | not timed | not timed | 13.99 ± 1.4% | | 1.00 | 5.52 | 2.17 |
| 07-unicode-character-data/compile | 1 | 106.82 ± 1.5% | not timed | not timed | 25.76 ± 0.6% | 35.59 ± 1.4% | not timed | not timed | 107.37 ± 0.4% | | 0.99 | 4.15 | 3.00 |
| 09-aws-keys/compile-full | 1 | 52.75 ± 1.7% | not timed | not timed | 8.27 ± 0.6% | 23.17 ± 2.8% | not timed | not timed | 52.96 ± 1.2% | | 1.00 | 6.38 | 2.28 |
| 09-aws-keys/compile-quick | 1 | 183.16 ± 0.9% | not timed | not timed | 46.92 ± 0.1% | 131.19 ± 2.2% | not timed | not timed | 183.24 ± 1.1% | | 1.00 | 3.90 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 71.32 ± 1.4% | not timed | not timed | 11.07 ± 0.5% | 15.84 ± 4.0% | not timed | not timed | 71.79 ± 0.6% | | 0.99 | 6.44 | 4.50 |
| 10-bounded-repeat/compile-capitals | 1 | 84.88 ± 1.8% | not timed | not timed | 7.97 ± 0.2% | 23.42 ± 28.3% | not timed | not timed | 84.27 ± 1.6% | | 1.01 | 10.65 | 3.62 |
| 11-unstructured-to-json/compile | 1 | 168.63 ± 1.1% | not timed | not timed | 40.80 ± 0.5% | 65.23 ± 4.6% | not timed | not timed | 169.55 ± 0.3% | | 0.99 | 4.13 | 2.59 |
| 12-dictionary/compile-single | 1 | 0.34 ± 3.1% | not timed | not timed | 0.07 ± 1.3% | 0.10 ± 9.9% | not timed | not timed | 0.34 ± 0.9% | | 0.99 | 4.96 | 3.49 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.54 ± 1.9% | not timed | not timed | 6.45 ± 0.2% | 0.52 ± 17.4% | not timed | not timed | 7.53 ± 3.2% | | 1.00 | 1.17 | 14.42 |
| dictionary/search/english-10 | 690 | 1.05 ± 0.4% | not timed | not timed | 165.55 ± 0.3% | 0.00 ± 0.5% | not timed | not timed | 1.05 ± 0.4% | | 1.00 | 0.0063 | 384.96 |
| dictionary/search/english-15 | 15 | 559.95 ± 0.4% | not timed | not timed | 558.32 ± 0.1% | 0.37 ± 0.1% | not timed | not timed | 561.82 ± 0.8% | | 1.00 | 1.00 | 1530.19 |
| folly/awyer-inn-busted | 1 | 5585.94 ± 0.2% | not timed | not timed | 143.56 ± 0.0% | 43.80 ± 0.1% | not timed | not timed | 5574.27 ± 0.1% | | 1.00 | 38.91 | 127.53 |
| folly/literal-never-match-rare | 0 | 21108.73 ± 0.3% | not timed | not timed | 19930.48 ± 0.3% | 40972.87 ± 0.3% | not timed | not timed | 21102.85 ± 0.4% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12521.40 ± 0.8% | not timed | not timed | 19854.49 ± 0.5% | 2196.02 ± 0.5% | not timed | not timed | 12570.18 ± 0.6% | | 1.00 | 0.63 | 5.70 |
| folly/literal-never-match-tricksy | 1 | 3246.31 ± 0.2% | not timed | not timed | 4412.84 ± 0.1% | 3049.47 ± 0.3% | not timed | not timed | 3250.03 ± 0.2% | | 1.00 | 0.74 | 1.06 |
| grep/every-line | 239963 | 1303.29 ± 0.4% | not timed | not timed | 956.15 ± 0.3% | 371.19 ± 16.0% | not timed | not timed | 1308.51 ± 0.2% | | 1.00 | 1.36 | 3.51 |
| grep/long-words-ascii | 5073 | 459.09 ± 0.3% | not timed | not timed | 469.45 ± 0.1% | 46.21 ± 6.2% | not timed | not timed | 434.54 ± 0.2% | | 1.06 | 0.98 | 9.93 |
| imported/leipzig/twain | 811 | 20380.65 ± 2.9% | not timed | not timed | 19402.41 ± 0.9% | 11875.53 ± 13.2% | not timed | not timed | 20608.91 ± 1.9% | | 0.99 | 1.05 | 1.72 |
| imported/leipzig/twain-insensitive | 965 | 9046.04 ± 0.8% | not timed | not timed | 4243.14 ± 0.4% | 37.59 ± 0.1% | not timed | not timed | 9076.04 ± 0.6% | | 1.00 | 2.13 | 240.67 |
| imported/leipzig/shing | 1540 | 629.46 ± 0.1% | not timed | not timed | 13027.37 ± 1.7% | 34.04 ± 0.2% | not timed | not timed | 631.95 ± 0.0% | | 1.00 | 0.0483 | 18.49 |
| imported/leipzig/huck-saw | 262 | 8154.67 ± 4.1% | not timed | not timed | 5576.38 ± 0.1% | 31.89 ± 0.1% | not timed | not timed | 8301.84 ± 3.3% | | 0.98 | 1.46 | 255.74 |
| imported/leipzig/word-ending-nn | 262 | 608.52 ± 0.1% | not timed | not timed | 615.67 ± 0.3% | 24.76 ± 0.1% | not timed | not timed | 611.26 ± 0.1% | | 1.00 | 0.99 | 24.58 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11016.69 ± 0.9% | not timed | not timed | 4489.39 ± 1.0% | 11.51 ± 0.1% | not timed | not timed | 11035.10 ± 0.9% | | 1.00 | 2.45 | 957.54 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7680.94 ± 2.2% | not timed | not timed | 5458.53 ± 0.6% | 16.84 ± 2.3% | not timed | not timed | 7794.25 ± 2.2% | | 0.99 | 1.41 | 456.19 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4154.15 ± 1.5% | not timed | not timed | 415.10 ± 2.0% | 11.11 ± 0.0% | not timed | not timed | 4179.72 ± 0.4% | | 0.99 | 10.01 | 374.03 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 609.54 ± 0.2% | not timed | not timed | 615.36 ± 0.1% | 11.12 ± 0.0% | not timed | not timed | 610.03 ± 0.1% | | 1.00 | 0.99 | 54.79 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.34 ± 0.2% | not timed | not timed | 615.87 ± 0.0% | 9.75 ± 0.0% | not timed | not timed | 610.21 ± 0.1% | | 1.00 | 0.99 | 62.47 |
| imported/leipzig/tom-river | 2 | 6498.64 ± 2.0% | not timed | not timed | 5135.80 ± 3.0% | 31.01 ± 0.1% | not timed | not timed | 6608.14 ± 18.5% | | 0.98 | 1.27 | 209.58 |
| imported/leipzig/ing | 78424 | 608.73 ± 0.7% | not timed | not timed | 571.03 ± 0.1% | 28.29 ± 2.8% | not timed | not timed | 607.33 ± 0.8% | | 1.00 | 1.07 | 21.52 |
| imported/leipzig/ing-whitespace | 55248 | 757.39 ± 0.6% | not timed | not timed | 2064.68 ± 0.7% | 20.57 ± 2.6% | not timed | not timed | 757.65 ± 0.8% | | 1.00 | 0.37 | 36.82 |
| imported/leipzig/awyer-inn | 209 | 774.86 ± 1.5% | not timed | not timed | 4216.78 ± 1.9% | 22.72 ± 0.1% | not timed | not timed | 775.11 ± 1.3% | | 1.00 | 0.18 | 34.10 |
| imported/leipzig/quotes-bounded | 8886 | 2119.20 ± 0.5% | not timed | not timed | 2984.92 ± 0.4% | 38.24 ± 0.1% | not timed | not timed | 2113.57 ± 0.5% | | 1.00 | 0.71 | 55.42 |
| imported/leipzig/non-ascii-alternate | 2 | 12653.85 ± 38.0% | not timed | not timed | 5647.16 ± 29.6% | 50.51 ± 0.1% | not timed | not timed | 12721.93 ± 13.5% | | 0.99 | 2.24 | 250.50 |
| imported/leipzig/math-symbols | 69 | 1974.15 ± 0.2% | not timed | not timed | 618.38 ± 0.1% | 36.47 ± 0.1% | not timed | not timed | 1970.61 ± 0.4% | | 1.00 | 3.19 | 54.13 |
| imported/leipzig/bounded-strings-ending-z | 0 | 594.20 ± 0.8% | not timed | not timed | 614.83 ± 0.1% | 22.52 ± 0.1% | not timed | not timed | 592.41 ± 0.4% | | 1.00 | 0.97 | 26.38 |
| imported/lh3lh3-reb/uri | 17549 | 631.72 ± 0.1% | not timed | not timed | 1068.71 ± 0.1% | 28.29 ± 2.4% | not timed | not timed | 633.06 ± 0.1% | | 1.00 | 0.59 | 22.33 |
| imported/lh3lh3-reb/email | 15057 | 666.42 ± 0.3% | not timed | not timed | 1169.59 ± 0.2% | 30.87 ± 2.5% | not timed | not timed | 668.24 ± 0.1% | | 1.00 | 0.57 | 21.59 |
| imported/lh3lh3-reb/date | 668 | 863.62 ± 0.2% | not timed | not timed | 1041.94 ± 0.4% | 50.28 ± 4.4% | not timed | not timed | 863.63 ± 0.1% | | 1.00 | 0.83 | 17.18 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 641.17 ± 0.1% | not timed | not timed | 424.25 ± 0.1% | 15.78 ± 2.1% | not timed | not timed | 642.58 ± 0.1% | | 1.00 | 1.51 | 40.64 |
| imported/mariomka/email | 92 | 705.77 ± 0.1% | not timed | not timed | 29555.04 ± 1.0% | 32.83 ± 0.1% | not timed | not timed | 706.49 ± 0.1% | | 1.00 | 0.0239 | 21.50 |
| imported/mariomka/uri | 5301 | 607.93 ± 0.1% | not timed | not timed | 6016.70 ± 0.9% | 32.78 ± 0.2% | not timed | not timed | 605.62 ± 0.1% | | 1.00 | 0.10 | 18.55 |
| imported/mariomka/ip | 5 | 2155.48 ± 2.0% | not timed | not timed | 2961.36 ± 0.5% | 21.09 ± 0.3% | not timed | not timed | 2150.92 ± 2.3% | | 1.00 | 0.73 | 102.21 |
| imported/rsc/no-exponential | 0 | 563.71 ± 0.2% | not timed | not timed | 318.55 ± 0.1% | 23.80 ± 0.3% | not timed | not timed | 563.22 ± 0.1% | | 1.00 | 1.77 | 23.69 |
| imported/rsc/literal | 1 | 744.25 ± 7.6% | not timed | not timed | 1545.60 ± 2.7% | 189.76 ± 18.1% | not timed | not timed | 745.09 ± 5.5% | | 1.00 | 0.48 | 3.92 |
| imported/rsc/not-literal | 2 | 709.42 ± 1.7% | not timed | not timed | 733.78 ± 0.1% | 46.44 ± 9.6% | not timed | not timed | 707.56 ± 0.2% | | 1.00 | 0.97 | 15.28 |
| imported/rsc/match-class | 1 | 1309.21 ± 0.3% | not timed | not timed | 1629.02 ± 0.4% | 58.78 ± 6.4% | not timed | not timed | 1304.08 ± 3.3% | | 1.00 | 0.80 | 22.27 |
| imported/rsc/match-class-in-range | 1 | 1310.00 ± 0.2% | not timed | not timed | 2368.87 ± 2.2% | 59.95 ± 7.0% | not timed | not timed | 1313.58 ± 2.4% | | 1.00 | 0.55 | 21.85 |
| imported/rsc/match-class-unicode | 1 | 525.66 ± 0.1% | not timed | not timed | 512.41 ± 0.1% | 72.76 ± 0.3% | not timed | not timed | 524.39 ± 0.1% | | 1.00 | 1.03 | 7.22 |
| imported/rsc/anchored-literal-short-non-match | 0 | 536.14 ± 0.4% | not timed | not timed | 963.13 ± 0.2% | 226.94 ± 0.7% | not timed | not timed | 535.17 ± 0.7% | | 1.00 | 0.56 | 2.36 |
| imported/rsc/anchored-literal-long-non-match | 0 | 7975.69 ± 0.2% | not timed | not timed | 14322.81 ± 0.1% | 3418.66 ± 0.9% | not timed | not timed | 7969.39 ± 0.1% | | 1.00 | 0.56 | 2.33 |
| imported/rsc/anchored-literal-short-match | 4 | 421.02 ± 2.4% | not timed | not timed | 478.60 ± 0.3% | 84.37 ± 7.6% | not timed | not timed | 421.47 ± 8.6% | | 1.00 | 0.88 | 4.99 |
| imported/rsc/anchored-literal-long-match | 4 | 3021.16 ± 0.8% | not timed | not timed | 7280.12 ± 0.4% | 1218.89 ± 6.4% | not timed | not timed | 3022.88 ± 0.7% | | 1.00 | 0.41 | 2.48 |
| imported/rsc/one-pass-short | 17 | 312.03 ± 10.2% | not timed | not timed | 215.73 ± 0.4% | 30.00 ± 12.2% | not timed | not timed | 310.83 ± 2.7% | | 1.00 | 1.45 | 10.40 |
| imported/rsc/one-pass-short-not | 17 | 216.38 ± 7.3% | not timed | not timed | 226.29 ± 0.1% | 32.22 ± 12.0% | not timed | not timed | 219.02 ± 0.2% | | 0.99 | 0.96 | 6.72 |
| imported/rsc/one-pass-long-prefix | 26 | 237.53 ± 2.2% | not timed | not timed | 282.66 ± 0.7% | 94.76 ± 12.7% | not timed | not timed | 240.14 ± 9.2% | | 0.99 | 0.84 | 2.51 |
| imported/rsc/one-pass-long-prefix-not | 26 | 314.69 ± 1.6% | not timed | not timed | 282.58 ± 0.1% | 67.19 ± 17.2% | not timed | not timed | 312.23 ± 6.2% | | 1.01 | 1.11 | 4.68 |
| imported/rsc/long-needle1 | 31 | 21903.82 ± 0.3% | not timed | not timed | 20150.99 ± 0.1% | 3.76 ± 0.3% | not timed | not timed | 21922.74 ± 0.1% | | 1.00 | 1.09 | 5817.83 |
| imported/rsc/long-needle2 | 31 | 22098.77 ± 0.0% | not timed | not timed | 216.28 ± 0.1% | 3.77 ± 0.2% | not timed | not timed | 22100.41 ± 0.1% | | 1.00 | 102.18 | 5862.06 |
| imported/rsc/easy0-32 | 26 | 1058.04 ± 2.9% | not timed | not timed | 1588.67 ± 0.8% | 146.69 ± 18.5% | not timed | not timed | 1059.67 ± 0.6% | | 1.00 | 0.67 | 7.21 |
| imported/rsc/easy0-1k | 26 | 14963.14 ± 2.4% | not timed | not timed | 12538.58 ± 0.2% | 2291.11 ± 13.5% | not timed | not timed | 14987.67 ± 0.1% | | 1.00 | 1.19 | 6.53 |
| imported/rsc/easy0-32k | 26 | 22890.44 ± 0.2% | not timed | not timed | 20388.79 ± 0.1% | 18823.47 ± 0.2% | not timed | not timed | 22903.38 ± 0.1% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21600.13 ± 3.4% | not timed | not timed | 19911.38 ± 2.6% | 36391.96 ± 2.6% | not timed | not timed | 21602.99 ± 1.0% | | 1.00 | 1.08 | 0.59 |
| imported/rsc/easy1-32 | 19 | 359.00 ± 3.7% | not timed | not timed | 646.08 ± 0.3% | 130.92 ± 16.7% | not timed | not timed | 361.14 ± 2.1% | | 0.99 | 0.56 | 2.74 |
| imported/rsc/easy1-1k | 19 | 585.18 ± 3.3% | not timed | not timed | 12860.59 ± 0.3% | 2454.82 ± 16.3% | not timed | not timed | 581.31 ± 2.4% | | 1.01 | 0.0455 | 0.24 |
| imported/rsc/easy1-32k | 19 | 602.56 ± 2.8% | not timed | not timed | 408571.21 ± 0.8% | 20365.39 ± 32.3% | not timed | not timed | 599.98 ± 0.1% | | 1.00 | 0.0015 | 0.0296 |
| imported/rsc/easy1-1mb | 19 | 602.65 ± 0.6% | not timed | not timed | 13063178.33 ± 0.2% | 37785.71 ± 3.1% | not timed | not timed | 601.59 ± 0.2% | | 1.00 | 0.0000 | 0.0159 |
| imported/rsc/medium-32 | 27 | 424.95 ± 2.2% | not timed | not timed | 629.08 ± 0.0% | 69.79 ± 11.8% | not timed | not timed | 426.07 ± 0.3% | | 1.00 | 0.68 | 6.09 |
| imported/rsc/medium-1k | 27 | 6767.63 ± 0.1% | not timed | not timed | 11508.90 ± 0.2% | 72.37 ± 0.1% | not timed | not timed | 6761.59 ± 0.1% | | 1.00 | 0.59 | 93.51 |
| imported/rsc/medium-32k | 27 | 21488.91 ± 0.1% | not timed | not timed | 356763.01 ± 0.3% | 48.45 ± 0.2% | not timed | not timed | 21583.43 ± 0.1% | | 1.00 | 0.0602 | 443.56 |
| imported/rsc/medium-1mb | 27 | 21024.84 ± 1.3% | not timed | not timed | 11364197.93 ± 0.2% | 48.24 ± 0.3% | not timed | not timed | 21063.66 ± 2.4% | | 1.00 | 0.0019 | 435.80 |
| imported/rsc/hard-32 | 58 | 254.53 ± 2.4% | not timed | not timed | 366.54 ± 0.1% | 49.44 ± 8.4% | not timed | not timed | 256.25 ± 0.1% | | 0.99 | 0.69 | 5.15 |
| imported/rsc/hard-1k | 27 | 577.12 ± 0.3% | not timed | not timed | 11636.65 ± 0.1% | 40.82 ± 0.2% | not timed | not timed | 574.24 ± 0.4% | | 1.01 | 0.0496 | 14.14 |
| imported/rsc/hard-32k | 27 | 600.57 ± 0.2% | not timed | not timed | 366095.08 ± 0.4% | 29.38 ± 0.1% | not timed | not timed | 597.99 ± 0.4% | | 1.00 | 0.0016 | 20.44 |
| imported/rsc/hard-1mb | 51 | 603.61 ± 0.4% | not timed | not timed | 7232210.17 ± 0.4% | 29.40 ± 0.1% | not timed | not timed | 600.31 ± 0.4% | | 1.01 | 0.0001 | 20.53 |
| imported/rsc/reallyhard0-32 | 58 | 253.71 ± 2.6% | not timed | not timed | 222.23 ± 0.2% | 46.85 ± 13.6% | not timed | not timed | 254.62 ± 0.1% | | 1.00 | 1.14 | 5.42 |
| imported/rsc/reallyhard0-1k | 27 | 576.58 ± 0.1% | not timed | not timed | 579.28 ± 0.2% | 40.83 ± 0.1% | not timed | not timed | 577.52 ± 0.1% | | 1.00 | 1.00 | 14.12 |
| imported/rsc/reallyhard0-32k | 27 | 601.07 ± 0.3% | not timed | not timed | 617.45 ± 0.2% | 29.36 ± 0.2% | not timed | not timed | 603.94 ± 0.5% | | 1.00 | 0.97 | 20.47 |
| imported/rsc/reallyhard0-1mb | 51 | 592.20 ± 0.9% | not timed | not timed | 618.49 ± 0.6% | 29.32 ± 0.2% | not timed | not timed | 594.49 ± 0.4% | | 1.00 | 0.96 | 20.20 |
| imported/rsc/reallyreallyhard0-32 | 47 | 274.03 ± 12.3% | not timed | not timed | 196.17 ± 1.2% | 60.47 ± 9.3% | not timed | not timed | 274.28 ± 0.1% | | 1.00 | 1.40 | 4.53 |
| imported/rsc/reallyreallyhard0-1k | 16 | 860.90 ± 3.5% | not timed | not timed | 5946.66 ± 0.2% | 34.40 ± 0.9% | not timed | not timed | 853.56 ± 0.9% | | 1.01 | 0.14 | 25.02 |
| imported/rsc/reallyreallyhard0-32k | 16 | 624.32 ± 5.0% | not timed | not timed | 19370.58 ± 0.2% | 24.74 ± 2.1% | not timed | not timed | 624.62 ± 6.5% | | 1.00 | 0.0322 | 25.24 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 592.77 ± 0.4% | not timed | not timed | 19845.59 ± 1.3% | 24.77 ± 0.2% | not timed | not timed | 589.68 ± 0.2% | | 1.01 | 0.0299 | 23.93 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 268.76 ± 0.1% | not timed | not timed | 212.33 ± 0.6% | 59.42 ± 11.8% | not timed | not timed | 268.49 ± 2.7% | | 1.00 | 1.27 | 4.52 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 841.64 ± 0.2% | not timed | not timed | 6194.74 ± 0.1% | 34.49 ± 1.0% | not timed | not timed | 843.69 ± 0.8% | | 1.00 | 0.14 | 24.40 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 620.50 ± 4.0% | not timed | not timed | 19282.30 ± 0.1% | 24.91 ± 1.9% | not timed | not timed | 625.04 ± 5.9% | | 0.99 | 0.0322 | 24.91 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 588.70 ± 0.2% | not timed | not timed | 20049.02 ± 1.0% | 24.40 ± 4.3% | not timed | not timed | 594.12 ± 2.1% | | 0.99 | 0.0294 | 24.13 |
| imported/sherlock/name-sherlock | 776 | 20041.45 ± 2.2% | not timed | not timed | 18819.42 ± 0.6% | 10144.14 ± 21.3% | not timed | not timed | 20095.45 ± 1.9% | | 1.00 | 1.06 | 1.98 |
| imported/sherlock/name-holmes | 2766 | 15261.47 ± 1.9% | not timed | not timed | 15678.96 ± 0.3% | 3158.94 ± 15.4% | not timed | not timed | 15451.22 ± 1.8% | | 0.99 | 0.97 | 4.83 |
| imported/sherlock/name-sherlock-holmes | 1365 | 20109.24 ± 1.9% | not timed | not timed | 18776.24 ± 0.1% | 8088.44 ± 25.8% | not timed | not timed | 20117.09 ± 1.8% | | 1.00 | 1.07 | 2.49 |
| imported/sherlock/name-sherlock-casei | 816 | 15843.08 ± 0.2% | not timed | not timed | 4021.44 ± 0.2% | 32.32 ± 0.6% | not timed | not timed | 15849.84 ± 0.1% | | 1.00 | 3.94 | 490.18 |
| imported/sherlock/name-holmes-casei | 2802 | 9396.21 ± 6.4% | not timed | not timed | 3315.22 ± 0.3% | 38.15 ± 3.2% | not timed | not timed | 9463.79 ± 2.6% | | 0.99 | 2.83 | 246.27 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13144.94 ± 5.2% | not timed | not timed | 3943.97 ± 0.1% | 32.51 ± 0.3% | not timed | not timed | 13147.69 ± 0.7% | | 1.00 | 3.33 | 404.37 |
| imported/sherlock/name-whitespace | 1461 | 15274.76 ± 1.7% | not timed | not timed | 14689.95 ± 0.3% | 6491.30 ± 20.1% | not timed | not timed | 15328.45 ± 1.3% | | 1.00 | 1.04 | 2.35 |
| imported/sherlock/name-alt1 | 1142 | 11514.13 ± 0.3% | not timed | not timed | 16724.72 ± 1.3% | 4133.80 ± 25.6% | not timed | not timed | 11506.40 ± 2.4% | | 1.00 | 0.69 | 2.79 |
| imported/sherlock/name-alt2 | 3542 | 8641.04 ± 0.4% | not timed | not timed | 3825.32 ± 0.1% | 31.49 ± 0.2% | not timed | not timed | 8641.59 ± 0.4% | | 1.00 | 2.26 | 274.40 |
| imported/sherlock/name-alt3 | 4507 | 5452.99 ± 0.5% | not timed | not timed | 3634.34 ± 0.1% | 9.45 ± 4.3% | not timed | not timed | 5454.61 ± 0.4% | | 1.00 | 1.50 | 576.75 |
| imported/sherlock/name-alt3-casei | 4593 | 1507.86 ± 3.0% | not timed | not timed | 285.56 ± 0.2% | 6.48 ± 0.2% | not timed | not timed | 1508.15 ± 0.8% | | 1.00 | 5.28 | 232.69 |
| imported/sherlock/name-alt4 | 3686 | 6186.56 ± 0.2% | not timed | not timed | 3792.12 ± 0.3% | 31.26 ± 0.3% | not timed | not timed | 6199.24 ± 0.2% | | 1.00 | 1.63 | 197.89 |
| imported/sherlock/name-alt4-casei | 4254 | 2763.78 ± 2.9% | not timed | not timed | 2595.92 ± 0.2% | 19.88 ± 0.2% | not timed | not timed | 2758.53 ± 0.9% | | 1.00 | 1.06 | 139.03 |
| imported/sherlock/name-alt5 | 4028 | 6232.58 ± 0.4% | not timed | not timed | 3747.17 ± 0.1% | 21.86 ± 0.1% | not timed | not timed | 6239.43 ± 0.3% | | 1.00 | 1.66 | 285.14 |
| imported/sherlock/name-alt5-casei | 4104 | 3448.63 ± 2.0% | not timed | not timed | 2236.55 ± 0.2% | 14.37 ± 0.1% | not timed | not timed | 3464.75 ± 0.9% | | 1.00 | 1.54 | 240.00 |
| imported/sherlock/no-match-uncommon | 0 | 21976.36 ± 0.3% | not timed | not timed | 19924.97 ± 0.8% | 37737.66 ± 0.5% | not timed | not timed | 21988.05 ± 0.4% | | 1.00 | 1.10 | 0.58 |
| imported/sherlock/no-match-common | 0 | 21834.30 ± 0.4% | not timed | not timed | 19906.86 ± 0.2% | 1273.82 ± 1.1% | not timed | not timed | 21845.36 ± 0.2% | | 1.00 | 1.10 | 17.14 |
| imported/sherlock/no-match-really-common | 0 | 16421.96 ± 4.5% | not timed | not timed | 19056.39 ± 0.5% | 1275.89 ± 1.0% | not timed | not timed | 16395.50 ± 3.4% | | 1.00 | 0.86 | 12.87 |
| imported/sherlock/the-lower | 21654 | 2313.89 ± 1.2% | not timed | not timed | 2339.63 ± 0.4% | 236.54 ± 14.0% | not timed | not timed | 2327.45 ± 1.8% | | 0.99 | 0.99 | 9.78 |
| imported/sherlock/the-upper | 2223 | 12803.52 ± 1.3% | not timed | not timed | 13701.99 ± 0.9% | 2630.02 ± 20.9% | not timed | not timed | 12862.99 ± 1.7% | | 1.00 | 0.93 | 4.87 |
| imported/sherlock/the-casei | 23961 | 2014.23 ± 1.4% | not timed | not timed | 1315.60 ± 0.2% | 34.84 ± 29.5% | not timed | not timed | 2018.08 ± 0.2% | | 1.00 | 1.53 | 57.81 |
| imported/sherlock/everything-greedy | 581881 | 270.86 ± 1.2% | not timed | not timed | 165.11 ± 0.2% | 28.98 ± 21.7% | not timed | not timed | 271.05 ± 0.1% | | 1.00 | 1.64 | 9.35 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.23 ± 0.1% | not timed | not timed | 213.96 ± 0.1% | 31.94 ± 0.2% | not timed | not timed | 463.38 ± 0.1% | | 1.00 | 2.16 | 14.47 |
| imported/sherlock/letters | 447175 | 50.86 ± 8.9% | not timed | not timed | 32.83 ± 0.1% | 5.84 ± 22.8% | not timed | not timed | 54.46 ± 6.7% | | 0.93 | 1.55 | 8.70 |
| imported/sherlock/letters-upper | 14180 | 433.60 ± 1.3% | not timed | not timed | 371.78 ± 0.1% | 29.54 ± 22.4% | not timed | not timed | 434.97 ± 0.2% | | 1.00 | 1.17 | 14.68 |
| imported/sherlock/letters-lower | 432995 | 55.41 ± 0.9% | not timed | not timed | 33.93 ± 0.1% | 5.31 ± 35.0% | not timed | not timed | 55.35 ± 0.8% | | 1.00 | 1.63 | 10.44 |
| imported/sherlock/words | 447639 | 106.99 ± 0.9% | not timed | not timed | 83.22 ± 0.2% | 15.75 ± 13.7% | not timed | not timed | 107.09 ± 0.5% | | 1.00 | 1.29 | 6.79 |
| imported/sherlock/before-holmes | 4073 | 598.91 ± 0.2% | not timed | not timed | 8552.96 ± 0.5% | 23.79 ± 2.0% | not timed | not timed | 596.89 ± 0.4% | | 1.00 | 0.0700 | 25.17 |
| imported/sherlock/before-after-holmes | 2593 | 597.20 ± 0.3% | not timed | not timed | 9618.41 ± 0.3% | 23.75 ± 1.9% | not timed | not timed | 598.30 ± 0.2% | | 1.00 | 0.0621 | 25.14 |
| imported/sherlock/holmes-cochar-watson | 150 | 5220.32 ± 0.3% | not timed | not timed | 3425.73 ± 0.1% | 31.04 ± 0.3% | not timed | not timed | 5233.79 ± 0.2% | | 1.00 | 1.52 | 168.17 |
| imported/sherlock/holmes-coword-watson | 14309 | 1261.61 ± 1.0% | not timed | not timed | 1124.04 ± 0.3% | 6.78 ± 0.2% | not timed | not timed | 1265.72 ± 0.4% | | 1.00 | 1.12 | 186.17 |
| imported/sherlock/quotes | 14437 | 1416.04 ± 0.2% | not timed | not timed | 1741.85 ± 1.0% | 35.09 ± 0.2% | not timed | not timed | 1400.82 ± 0.2% | | 1.01 | 0.81 | 40.35 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 601.64 ± 0.2% | not timed | not timed | 16309.19 ± 0.2% | 36.65 ± 0.2% | not timed | not timed | 602.18 ± 0.3% | | 1.00 | 0.0369 | 16.42 |
| imported/sherlock/word-ending-n | 35297 | 468.15 ± 0.3% | not timed | not timed | 409.84 ± 0.2% | 23.54 ± 20.2% | not timed | not timed | 467.95 ± 0.8% | | 1.00 | 1.14 | 19.89 |
| imported/sherlock/repeated-class-negation | 2130 | 14814.61 ± 0.9% | not timed | not timed | 11089.20 ± 0.8% | 11.59 ± 0.2% | not timed | not timed | 14794.17 ± 0.8% | | 1.00 | 1.34 | 1278.60 |
| imported/sherlock/ing-suffix | 20547 | 554.56 ± 1.0% | not timed | not timed | 517.14 ± 0.1% | 28.80 ± 30.9% | not timed | not timed | 554.34 ± 0.2% | | 1.00 | 1.07 | 19.25 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 594.66 ± 0.2% | not timed | not timed | 2086.10 ± 0.8% | 20.55 ± 0.1% | not timed | not timed | 594.49 ± 0.4% | | 1.00 | 0.29 | 28.93 |
| opt/accelerate/whole-line | 239963 | 458.13 ± 0.2% | not timed | not timed | 373.96 ± 0.3% | 92.40 ± 16.4% | not timed | not timed | 458.39 ± 0.4% | | 1.00 | 1.23 | 4.96 |
| opt/accelerate/non-dna | 16745 | 413.47 ± 1.0% | not timed | not timed | 400.97 ± 0.1% | 29.55 ± 20.2% | not timed | not timed | 412.07 ± 0.6% | | 1.00 | 1.03 | 13.99 |
| opt/backtrack/words-english | 40536 | 137.01 ± 1.8% | not timed | not timed | 93.11 ± 0.1% | 19.89 ± 7.4% | not timed | not timed | 134.47 ± 2.2% | | 1.02 | 1.47 | 6.89 |
| opt/fixed-length/too-small-ascii | 0 | 312.20 ± 0.1% | not timed | not timed | 705.04 ± 1.1% | 79.72 ± 0.6% | not timed | not timed | 316.26 ± 0.2% | | 0.99 | 0.44 | 3.92 |
| opt/fixed-length/too-big-ascii | 0 | 646.97 ± 0.4% | not timed | not timed | 5827.34 ± 0.7% | 123.20 ± 0.1% | not timed | not timed | 653.80 ± 0.3% | | 0.99 | 0.11 | 5.25 |
| opt/fixed-length/go33484-1 | 0 | 45.38 ± 0.1% | not timed | not timed | 1117865.04 ± 0.8% | 61139.36 ± 0.1% | not timed | not timed | 45.25 ± 0.0% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5528.26 ± 0.1% | not timed | not timed | 1101568.82 ± 0.7% | 32075.92 ± 2.1% | not timed | not timed | 5519.64 ± 0.1% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1775.59 ± 2.1% | not timed | not timed | 112136.54 ± 0.1% | 765.61 ± 0.3% | not timed | not timed | 1765.98 ± 1.8% | | 1.01 | 0.0158 | 2.32 |
| opt/literal-alt/one-pattern | 1 | 554.79 ± 10.5% | not timed | not timed | 537.45 ± 0.2% | 0.39 ± 0.4% | not timed | not timed | 556.16 ± 0.1% | | 1.00 | 1.03 | 1410.22 |
| opt/onepass/fn-predicate | 916 | 368.47 ± 1.1% | not timed | not timed | 335.08 ± 0.1% | 197.88 ± 14.1% | not timed | not timed | 369.67 ± 0.5% | | 1.00 | 1.10 | 1.86 |
| opt/onepass/first-three-words-english | 35128 | 146.94 ± 7.3% | not timed | not timed | 201.86 ± 0.1% | 80.88 ± 14.4% | not timed | not timed | 149.62 ± 1.7% | | 0.98 | 0.73 | 1.82 |
| opt/prefilter/literal-english | 1 | 20743.32 ± 1.0% | not timed | not timed | 19984.06 ± 0.6% | 17650.68 ± 0.3% | not timed | not timed | 20778.21 ± 0.6% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14508.48 ± 0.5% | not timed | not timed | 4318.30 ± 0.1% | 32.14 ± 0.3% | not timed | not timed | 14511.98 ± 0.6% | | 1.00 | 3.36 | 451.41 |
| opt/prefilter/literal-russian | 1 | 21287.93 ± 0.8% | not timed | not timed | 19881.09 ± 0.7% | 3326.18 ± 0.3% | not timed | not timed | 21326.86 ± 0.6% | | 1.00 | 1.07 | 6.40 |
| opt/prefilter/literal-casei-russian | 1 | 8552.97 ± 0.6% | not timed | not timed | 3886.65 ± 0.4% | 30.81 ± 0.2% | not timed | not timed | 8544.55 ± 0.3% | | 1.00 | 2.20 | 277.63 |
| opt/prefilter/rust-functions | 948 | 6815.88 ± 0.3% | not timed | not timed | 8969.73 ± 0.6% | 1850.05 ± 0.3% | not timed | not timed | 6815.28 ± 0.5% | | 1.00 | 0.76 | 3.68 |
| opt/reverse-anchored/word-end | 1 | 5573.67 ± 0.3% | not timed | not timed | 21673258.64 ± 0.3% | 48.85 ± 0.1% | not timed | not timed | 5578.78 ± 0.2% | | 1.00 | 0.0003 | 114.11 |
| opt/reverse-inner/holmes | 2593 | 597.42 ± 0.3% | not timed | not timed | 9332.94 ± 0.9% | 23.19 ± 0.9% | not timed | not timed | 598.65 ± 0.3% | | 1.00 | 0.0640 | 25.77 |
| opt/reverse-inner/email | 47 | 1045.77 ± 0.3% | not timed | not timed | 44737.99 ± 0.6% | 31.88 ± 0.4% | not timed | not timed | 1044.28 ± 0.2% | | 1.00 | 0.0234 | 32.81 |
| opt/reverse-inner/factored-prefix | 3542 | 592.78 ± 0.5% | not timed | not timed | 597.27 ± 0.0% | 12.35 ± 0.2% | not timed | not timed | 592.71 ± 0.2% | | 1.00 | 0.99 | 47.99 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5510.04 ± 0.1% | not timed | not timed | 616.75 ± 0.0% | 75.25 ± 0.1% | not timed | not timed | 5520.37 ± 0.0% | | 1.00 | 8.93 | 73.22 |
| opt/reverse-inner/no-quadratic-forward | 0 | 687.60 ± 9.1% | not timed | not timed | 287.75 ± 0.2% | 24.83 ± 0.1% | not timed | not timed | 688.05 ± 4.3% | | 1.00 | 2.39 | 27.69 |
| opt/reverse-suffix/holmes | 4073 | 598.97 ± 0.5% | not timed | not timed | 8475.04 ± 0.3% | 23.56 ± 1.2% | not timed | not timed | 596.44 ± 0.4% | | 1.00 | 0.0707 | 25.42 |
| opt/reverse-suffix/no-quadratic | 0 | 5520.40 ± 0.0% | not timed | not timed | 619.28 ± 0.1% | 75.17 ± 0.2% | not timed | not timed | 5506.81 ± 0.1% | | 1.00 | 8.91 | 73.44 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.93 ± 7.8% | not timed | not timed | 132.26 ± 0.1% | 13.27 ± 16.2% | not timed | not timed | 121.33 ± 2.7% | | 1.00 | 0.91 | 9.11 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.66 ± 10.0% | not timed | not timed | 127.21 ± 0.1% | 14.48 ± 19.2% | not timed | not timed | 120.55 ± 0.7% | | 1.00 | 0.95 | 8.33 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.4% | not timed | not timed | 0.54 ± 0.4% | 112.91 ± 0.2% | not timed | not timed | 0.28 ± 0.4% | | 1.00 | 0.52 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 310.05 ± 0.2% | not timed | not timed | 294.67 ± 0.2% | 103.39 ± 7.5% | not timed | not timed | 304.87 ± 3.1% | | 1.02 | 1.05 | 3.00 |
| reported/i13-subset-regex/original-ascii | 4094 | 11053.34 ± 0.7% | not timed | not timed | 4495.81 ± 0.9% | 11.37 ± 0.3% | not timed | not timed | 11007.23 ± 1.6% | | 1.00 | 2.46 | 972.33 |
| reported/i13-subset-regex/original-unicode | 4094 | 10907.64 ± 1.3% | not timed | not timed | 249.41 ± 3.6% | 11.45 ± 0.1% | not timed | not timed | 10999.36 ± 0.9% | | 0.99 | 43.73 | 952.27 |
| reported/i13-subset-regex/big-ascii | 1955 | 10610.50 ± 0.9% | not timed | not timed | 68.26 ± 3.6% | 9.85 ± 0.2% | not timed | not timed | 10674.85 ± 1.2% | | 0.99 | 155.44 | 1076.79 |
| reported/i13-subset-regex/big-unicode | 1955 | 10537.46 ± 1.4% | not timed | not timed | 12.31 ± 54.9% | 9.85 ± 0.1% | not timed | not timed | 10709.63 ± 0.8% | | 0.98 | 855.79 | 1069.45 |
| reported/i13-subset-regex/huge-ascii | 55 | 9800.78 ± 3.4% | not timed | not timed | 11.00 ± 0.1% | 8.76 ± 0.1% | not timed | not timed | 9709.01 ± 4.4% | | 1.01 | 891.01 | 1119.05 |
| reported/i13-subset-regex/huge-unicode | 55 | 9689.55 ± 41.3% | not timed | not timed | 11.05 ± 0.4% | 8.75 ± 0.1% | not timed | not timed | 9615.33 ± 41.6% | | 1.01 | 876.71 | 1107.70 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.1% | not timed | not timed | 11.03 ± 0.1% | 8.76 ± 0.2% | not timed | not timed | 3.54 ± 0.1% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.1% | not timed | not timed | 10.98 ± 0.3% | 8.75 ± 1.2% | not timed | not timed | 5.02 ± 0.0% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 469.43 ± 0.1% | not timed | not timed | 104.75 ± 0.1% | 6.60 ± 0.3% | not timed | not timed | 469.57 ± 0.2% | | 1.00 | 4.48 | 71.12 |
| reported/i787-keywords/opt-ascii | 5674 | 471.47 ± 0.3% | not timed | not timed | 276.31 ± 0.5% | 10.27 ± 0.1% | not timed | not timed | 471.10 ± 0.4% | | 1.00 | 1.71 | 45.92 |
| slow/quadratic-regex-1x | 100 | 6.95 ± 0.1% | not timed | not timed | 4.89 ± 0.4% | 0.05 ± 0.1% | not timed | not timed | 6.95 ± 0.1% | | 1.00 | 1.42 | 141.10 |
| slow/quadratic-regex-2x | 199 | 3.40 ± 0.2% | not timed | not timed | 2.76 ± 0.2% | 0.01 ± 0.2% | not timed | not timed | 3.40 ± 0.3% | | 1.00 | 1.23 | 267.45 |
| slow/quadratic-haystack-1x | 100 | 21.23 ± 7.0% | not timed | not timed | 10.01 ± 0.1% | 1.01 ± 14.9% | not timed | not timed | 21.21 ± 1.6% | | 1.00 | 2.12 | 20.92 |
| slow/quadratic-haystack-2x | 200 | 17.46 ± 0.4% | not timed | not timed | 5.55 ± 0.1% | 0.55 ± 1.4% | not timed | not timed | 17.42 ± 12.2% | | 1.00 | 3.15 | 31.94 |
| unicode/codepoints/any-one | 1112064 | 286.01 ± 0.7% | not timed | not timed | 169.84 ± 0.1% | 18.35 ± 3.2% | not timed | not timed | 287.17 ± 0.2% | | 1.00 | 1.68 | 15.58 |
| unicode/codepoints/any-all | 4382592 | 289.44 ± 0.1% | not timed | not timed | 246.28 ± 0.2% | 113.82 ± 0.4% | not timed | not timed | 289.62 ± 0.2% | | 1.00 | 1.18 | 2.54 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.73 ± 0.7% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 610.30 ± 0.1% | not timed | not timed | 615.92 ± 0.1% | 135.30 ± 0.1% | not timed | not timed | 610.84 ± 0.1% | | 1.00 | 0.99 | 4.51 |
| unicode/overlapping-words/ascii | 6156 | 31.68 ± 0.3% | not timed | not timed | 38.91 ± 0.1% | 3.93 ± 1.2% | not timed | not timed | 31.84 ± 0.2% | | 1.00 | 0.81 | 8.07 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 0.2% | not timed | not timed | 4.10 ± 0.4% | 2.36 ± 0.3% | not timed | not timed | 1.35 ± 0.1% | | 1.00 | 0.33 | 0.57 |
| unicode/overlapping-words/russian | 5710 | 1.22 ± 9.0% | not timed | not timed | 3.85 ± 0.2% | 6.29 ± 8.1% | not timed | not timed | 1.22 ± 0.2% | | 1.00 | 0.32 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 117.14 ± 7.7% | not timed | not timed | 82.95 ± 0.2% | 12.20 ± 15.8% | not timed | not timed | 117.13 ± 1.8% | | 1.00 | 1.41 | 9.60 |
| unicode/word/boundary-long-english | 3466 | 604.78 ± 0.2% | not timed | not timed | 604.16 ± 0.3% | 32.61 ± 0.7% | not timed | not timed | 605.60 ± 0.4% | | 1.00 | 1.00 | 18.55 |
| unicode/word/around-holmes-english | 27 | 601.23 ± 0.5% | not timed | not timed | 19610.53 ± 0.4% | 22.09 ± 1.0% | not timed | not timed | 601.45 ± 0.1% | | 1.00 | 0.0307 | 27.22 |
| wild/bibleref/long | 874 | 563.08 ± 0.2% | not timed | not timed | 582.45 ± 0.2% | 6.81 ± 0.6% | not timed | not timed | 563.56 ± 0.1% | | 1.00 | 0.97 | 82.70 |
| wild/bibleref/short | 30 | 23.63 ± 2.3% | not timed | not timed | 31.08 ± 0.3% | 14.18 ± 12.0% | not timed | not timed | 24.22 ± 3.6% | | 0.98 | 0.76 | 1.67 |
| wild/bibleref/line | 874 | 357.70 ± 3.0% | not timed | not timed | 211.09 ± 0.2% | 9.25 ± 8.7% | not timed | not timed | 358.18 ± 0.2% | | 1.00 | 1.69 | 38.65 |
| wild/caddy/caddy | 6 | 414.15 ± 6.1% | not timed | not timed | 245.80 ± 0.1% | 68.26 ± 12.3% | not timed | not timed | 415.54 ± 1.3% | | 1.00 | 1.68 | 6.07 |
| wild/dot-star-capture/rust-src-tools | 6 | 1060.07 ± 0.4% | not timed | not timed | 345.21 ± 0.1% | 13.48 ± 0.2% | not timed | not timed | 1058.86 ± 0.3% | | 1.00 | 3.07 | 78.65 |
| wild/ruff/noqa | 84 | 403.47 ± 0.1% | not timed | not timed | 461.12 ± 0.1% | 19.64 ± 2.3% | not timed | not timed | 403.08 ± 0.1% | | 1.00 | 0.87 | 20.54 |
| wild/ruff/unnecessary-coding-comment | 16 | 488.66 ± 0.6% | not timed | not timed | 702.58 ± 0.2% | 135.98 ± 11.0% | not timed | not timed | 488.11 ± 0.6% | | 1.00 | 0.70 | 3.59 |
| wild/ruff/string-quote-prefix | 2972 | 405.86 ± 0.7% | not timed | not timed | 407.39 ± 0.2% | 314.95 ± 28.6% | not timed | not timed | 407.19 ± 0.6% | | 1.00 | 1.00 | 1.29 |
| wild/ruff/space-around-operator | 1224378 | 217.65 ± 1.8% | not timed | not timed | 186.64 ± 0.0% | 18.18 ± 1.8% | not timed | not timed | 217.80 ± 1.4% | | 1.00 | 1.17 | 11.97 |
| wild/ruff/shebang | 282 | 400.77 ± 0.5% | not timed | not timed | 325.35 ± 0.0% | 120.70 ± 9.7% | not timed | not timed | 400.72 ± 0.5% | | 1.00 | 1.23 | 3.32 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13793.04 ± 0.3% | not timed | not timed | 13825.97 ± 0.3% | 6908.20 ± 0.6% | not timed | not timed | 13793.39 ± 0.3% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12799.32 ± 0.4% | not timed | not timed | 13510.36 ± 0.4% | 6403.33 ± 0.7% | not timed | not timed | 12803.19 ± 0.4% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13147.69 ± 0.3% | not timed | not timed | 13614.42 ± 0.3% | 6635.91 ± 37.2% | not timed | not timed | 13177.54 ± 3.2% | | 1.00 | 0.97 | 1.98 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9533.31 ± 0.3% | not timed | not timed | 13606.63 ± 0.2% | 6771.51 ± 0.5% | not timed | not timed | 9551.62 ± 0.2% | | 1.00 | 0.70 | 1.41 |
| wild/url/search | 234965 | 122.21 ± 14.0% | not timed | not timed | 65.25 ± 0.5% | 2.24 ± 0.7% | not timed | not timed | 121.36 ± 14.2% | | 1.01 | 1.87 | 54.61 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 6.2% | not timed | not timed | 0.01 ± 1.7% | 0.01 ± 30.3% | not timed | not timed | 0.03 ± 58.8% | | 1.00 | 3.08 | 4.03 |
| dictionary/compile/english-15 | 1 | 0.33 ± 20.0% | not timed | not timed | 0.07 ± 1.4% | 0.10 ± 12.4% | not timed | not timed | 0.35 ± 0.5% | | 0.97 | 4.86 | 3.30 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 4.8% | not timed | not timed | 0.02 ± 1.3% | 35.74 ± 9.8% | not timed | not timed | 0.25 ± 4.2% | | 0.98 | 12.81 | 0.0068 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.60 ± 4.7% | not timed | not timed | 11.54 ± 0.6% | 62.76 ± 21.3% | not timed | not timed | 46.94 ± 2.6% | | 0.99 | 4.04 | 0.74 |
| reported/i787-keywords/compile | 1 | 34.79 ± 18.2% | not timed | not timed | 2.12 ± 0.8% | 16.74 ± 26.2% | not timed | not timed | 35.25 ± 1.2% | | 0.99 | 16.38 | 2.08 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 349.98 ± 8.5% | not timed | not timed | 118.83 ± 0.2% | 571.37 ± 24.7% | not timed | not timed | 350.53 ± 9.5% | | 1.00 | 2.95 | 0.61 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.02 ± 2.0% | not timed | not timed | 4.11 ± 0.7% | 43.75 ± 5.4% | not timed | not timed | 47.80 ± 2.5% | | 0.98 | 11.45 | 1.07 |
| unicode/compile/one-letter | 53 | 6.72 ± 2.6% | not timed | not timed | 4.55 ± 0.6% | 64.80 ± 7.7% | not timed | not timed | 6.69 ± 12.8% | | 1.00 | 1.48 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.03 ± 6.8% | not timed | not timed | 0.10 ± 1.0% | 66.01 ± 14.0% | not timed | not timed | 1.06 ± 16.5% | | 0.97 | 10.46 | 0.0156 |
| unicode/compile/fifty-letters-ascii | 1 | 213.64 ± 4.9% | not timed | not timed | 52.66 ± 0.3% | 177.04 ± 16.9% | not timed | not timed | 217.74 ± 3.3% | | 0.98 | 4.06 | 1.21 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 374.48 ± 17.7% | not timed | not timed | 47.53 ± 0.3% | 659.81 ± 28.1% | not timed | not timed | 377.06 ± 2.4% | | 0.99 | 7.88 | 0.57 |
| unicode/compile/match-every-line-ascii | 4 | 595.70 ± 20.5% | not timed | not timed | 145.86 ± 0.1% | 664.54 ± 30.2% | not timed | not timed | 604.89 ± 3.8% | | 0.98 | 4.08 | 0.90 |
| unicode/compile/negated-class-matches-codepoint | 1 | 306.06 ± 13.0% | not timed | not timed | 51.61 ± 0.4% | 1223.90 ± 27.4% | not timed | not timed | 313.57 ± 2.1% | | 0.98 | 5.93 | 0.25 |
| wild/bibleref/compile | 3 | 5.64 ± 7.1% | not timed | not timed | 1.91 ± 0.8% | 32.79 ± 11.3% | not timed | not timed | 5.88 ± 22.4% | | 0.96 | 2.95 | 0.17 |
| wild/url/compile | 1 | 0.61 ± 18.0% | not timed | not timed | 0.14 ± 0.6% | 0.45 ± 32.2% | not timed | not timed | 0.63 ± 16.6% | | 0.98 | 4.24 | 1.37 |

