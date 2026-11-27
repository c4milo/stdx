# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
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
| literal: a word | 217 | 19887.49 ± 0.9% | 10879.40 ± 0.3% | 28.09 ± 0.2% | 18382.31 ± 1.9% | 9254.19 ± 8.8% | 17.44 ± 0.1% | 86.78 ± 0.2% | 19747.90 ± 1.4% | 1.83 | 1.01 | 1.08 | 2.15 |
| literal: a word that is not there | 0 | 21982.43 ± 1.0% | 9931.36 ± 0.7% | 28.36 ± 0.2% | 20098.77 ± 1.7% | 29472.54 ± 0.9% | 17.20 ± 0.4% | 80.86 ± 0.1% | 21885.95 ± 1.4% | 2.21 | 1.00 | 1.09 | 0.75 |
| literal: one of four words | 661 | 6436.40 ± 0.3% | 1789.06 ± 0.3% | 14.41 ± 0.2% | 3949.67 ± 0.2% | 21.87 ± 0.1% | 5.26 ± 0.3% | 6.74 ± 0.2% | 6446.08 ± 0.4% | 3.60 | 1.00 | 1.63 | 294.31 |
| literal: a word in any case | 217 | 15276.00 ± 0.4% | 1919.42 ± 0.1% | 21.54 ± 0.3% | 3967.25 ± 0.2% | 38.11 ± 0.7% | refused | differs | 15248.72 ± 0.6% | 7.96 | 1.00 | 3.85 | 400.80 |
| literal: an href attribute | 33 | 17026.04 ± 1.9% | 608.45 ± 0.7% | 27.26 ± 0.7% | 17278.48 ± 2.4% | 2261.48 ± 0.7% | 13.31 ± 0.3% | 75.60 ± 0.3% | 17165.93 ± 1.8% | 27.98 | 0.99 | 0.99 | 7.53 |
| literal: a word, second text | 123 | 19703.41 ± 3.0% | 4582.73 ± 0.4% | 27.96 ± 0.2% | 18564.32 ± 2.4% | 7826.31 ± 4.9% | 19.75 ± 0.2% | 71.14 ± 0.4% | 19717.57 ± 1.5% | 4.30 | 1.00 | 1.06 | 2.52 |
| class: two capitalized words | 1331 | 1178.21 ± 0.4% | 598.15 ± 0.6% | 25.97 ± 0.2% | 586.48 ± 0.1% | 40.68 ± 7.7% | 14.82 ± 0.3% | 67.85 ± 0.6% | 1177.56 ± 0.3% | 1.97 | 1.00 | 2.01 | 28.96 |
| class: a word that ends in ing | 3399 | 575.27 ± 0.1% | 574.13 ± 0.2% | 17.87 ± 0.1% | 548.45 ± 0.1% | 29.69 ± 1.4% | 8.14 ± 0.1% | 18.40 ± 0.2% | 575.65 ± 0.4% | 1.00 | 1.00 | 1.05 | 19.38 |
| class: a word in capitals | 2332 | 1535.45 ± 0.4% | 607.85 ± 0.5% | 27.61 ± 0.2% | 573.21 ± 0.1% | 43.55 ± 7.1% | 17.20 ± 0.2% | 83.48 ± 0.2% | 1534.82 ± 0.2% | 2.53 | 1.00 | 2.68 | 35.26 |
| class: a number | 8288 | 2681.63 ± 0.3% | 841.84 ± 0.1% | 27.73 ± 0.1% | 1723.03 ± 0.1% | 43.18 ± 4.0% | 0.56 ± 0.1% | 57.21 ± 0.3% | 2681.18 ± 0.3% | 3.19 | 1.00 | 1.56 | 62.11 |
| class: two capitalized words, second text | 5359 | 519.99 ± 0.6% | 528.35 ± 0.4% | 23.24 ± 0.1% | 485.03 ± 0.1% | 35.53 ± 11.2% | 16.67 ± 0.3% | 63.39 ± 0.3% | 521.92 ± 0.3% | 0.98 | 1.00 | 1.07 | 14.64 |
| other: a word between two words | 6104 | 811.76 ± 0.1% | 602.58 ± 0.1% | 23.44 ± 0.2% | 739.31 ± 0.3% | 109.55 ± 12.8% | 11.25 ± 0.2% | 69.35 ± 0.8% | 811.75 ± 0.2% | 1.35 | 1.00 | 1.10 | 7.41 |
| other: a number before a unit, second text | 1481 | 6257.92 ± 1.8% | 1143.14 ± 0.0% | 25.96 ± 0.3% | 5652.13 ± 0.5% | 40.77 ± 0.1% | 17.75 ± 0.1% | 65.85 ± 0.3% | 6236.29 ± 0.8% | 5.47 | 1.00 | 1.11 | 153.51 |
| other: a heading's start tag | 110 | 14164.87 ± 0.4% | 740.79 ± 0.2% | 27.34 ± 0.3% | 1707.19 ± 0.4% | 1586.44 ± 2.9% | 16.32 ± 0.3% | 87.90 ± 0.5% | 14240.36 ± 1.0% | 19.12 | 0.99 | 8.30 | 8.93 |
| other: a whole word | 217 | 16433.86 ± 1.4% | 599.39 ± 0.6% | 28.74 ± 0.3% | 14706.51 ± 0.7% | 49.42 ± 0.4% | 13.50 ± 0.2% | 55.49 ± 0.9% | 16517.45 ± 0.8% | 27.42 | 0.99 | 1.12 | 332.52 |
| other: a line's first word, second text | 3716 | 2098.10 ± 0.6% | 592.09 ± 0.2% | 30.87 ± 0.3% | 1705.18 ± 0.5% | 62.49 ± 8.2% | refused | refused | 2106.16 ± 1.2% | 3.54 | 1.00 | 1.23 | 33.58 |
| other: fourteen octets before an x | 87 | 24827.07 ± 1.4% | 241.81 ± 0.3% | 6.47 ± 0.2% | 4037.81 ± 0.8% | 10.64 ± 0.1% | differs | 17.93 ± 0.2% | 24640.12 ± 7.1% | 102.67 | 1.01 | 6.15 | 2333.76 |
| other: a Greek word | 21815 | 529.56 ± 0.5% | 423.78 ± 0.2% | 30.44 ± 0.1% | 290.80 ± 0.2% | 49.95 ± 10.6% | differs | refused | 529.65 ± 0.2% | 1.25 | 1.00 | 1.82 | 10.60 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.71 ± 0.3% | 29.62 ± 0.1% | 0.86 ± 0.2% | 19.70 ± 0.5% | 2.76 ± 1.2% | differs | 4.04 ± 0.1% | 29.61 ± 0.1% | 1.00 | 1.00 | 1.51 | 10.76 |
| a UUID | 32895 | 24.61 ± 0.2% | 24.77 ± 0.2% | 0.64 ± 0.2% | 15.13 ± 0.5% | 3.10 ± 0.6% | 0.72 ± 0.4% | 3.60 ± 0.8% | 24.77 ± 0.2% | 0.99 | 0.99 | 1.63 | 7.93 |
| an IPv4 address | 33176 | 38.75 ± 0.3% | 38.79 ± 0.4% | 2.08 ± 0.3% | 29.28 ± 0.5% | 6.68 ± 0.3% | differs | 4.21 ± 0.2% | 38.74 ± 0.3% | 1.00 | 1.00 | 1.32 | 5.80 |
| a date and time | 32954 | 33.99 ± 0.2% | 34.22 ± 0.1% | 1.44 ± 0.3% | 21.43 ± 0.5% | 6.85 ± 0.1% | 1.19 ± 0.2% | 7.11 ± 0.4% | 34.20 ± 0.2% | 0.99 | 0.99 | 1.59 | 4.96 |
| a field path | 32606 | 32.79 ± 0.3% | 32.85 ± 0.3% | 1.02 ± 0.2% | 23.06 ± 0.5% | 3.46 ± 0.6% | differs | 2.96 ± 0.1% | 32.84 ± 0.4% | 1.00 | 1.00 | 1.42 | 9.47 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.22 ± 0.3% | 11.18 ± 0.6% | 11.19 ± 0.5% | 11.44 ± 0.1% | 4.94 ± 1.9% | 0.90 ± 0.5% | none | 11.19 ± 1.1% | 1.00 | 1.00 | 0.98 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 228.41 ± 0.2% | 228.44 ± 0.2% | 269.51 ± 0.2% | 85.77 ± 0.5% | 220.39 ± 8.0% | 478.15 ± 1.2% | 3744.07 ± 2.7% | 228.61 ± 0.1% | 1.00 | 1.00 | 2.66 | 1.04 |
| a UUID | 62 | 151.80 ± 0.3% | 152.01 ± 0.2% | 169.39 ± 0.2% | 45.72 ± 0.5% | 100.09 ± 3.8% | 178.62 ± 1.0% | 4364.96 ± 1.3% | 152.05 ± 0.2% | 1.00 | 1.00 | 3.32 | 1.52 |
| an IPv4 address | 29 | 421.69 ± 0.8% | 421.91 ± 0.4% | 587.32 ± 0.5% | 76.17 ± 0.7% | 132.60 ± 4.0% | 291.38 ± 0.8% | 7558.24 ± 0.4% | 422.24 ± 0.6% | 1.00 | 1.00 | 5.54 | 3.18 |
| a date and time | 56 | 302.34 ± 1.0% | 302.37 ± 0.2% | 378.62 ± 0.1% | 71.08 ± 1.2% | 138.76 ± 1.8% | 317.17 ± 1.3% | 4935.40 ± 0.5% | 302.15 ± 0.3% | 1.00 | 1.00 | 4.25 | 2.18 |
| a field path | 39 | 224.34 ± 0.4% | 224.19 ± 0.2% | 263.65 ± 0.3% | 79.48 ± 1.2% | 208.44 ± 1.2% | 491.49 ± 1.8% | 4745.81 ± 0.3% | 224.27 ± 0.1% | 1.00 | 1.00 | 2.82 | 1.08 |
| literal: a word | 7 | 602.99 ± 0.3% | 648.53 ± 0.3% | 1124.88 ± 0.2% | 497.42 ± 0.8% | 634.85 ± 2.2% | 926.17 ± 0.6% | 30250.44 ± 0.4% | 603.52 ± 0.3% | 0.93 | 1.00 | 1.21 | 0.95 |
| literal: a word that is not there | 8 | 587.98 ± 0.3% | 635.33 ± 0.6% | 1085.18 ± 0.5% | 454.93 ± 0.1% | 605.62 ± 1.5% | 895.82 ± 0.5% | 29158.83 ± 0.4% | 585.66 ± 0.6% | 0.93 | 1.00 | 1.29 | 0.97 |
| literal: one of four words | 26 | 243.90 ± 0.4% | 385.85 ± 0.5% | 522.96 ± 0.4% | 49.35 ± 1.0% | 244.23 ± 1.3% | 364.61 ± 0.2% | 15574.02 ± 0.2% | 244.10 ± 0.7% | 0.63 | 1.00 | 4.94 | 1.00 |
| literal: a word in any case | 11 | 439.09 ± 0.2% | 468.65 ± 0.4% | 682.85 ± 0.4% | 15.67 ± 0.5% | 652.10 ± 1.3% | refused | 23766.51 ± 0.4% | 439.06 ± 0.1% | 0.94 | 1.00 | 28.03 | 0.67 |
| literal: an href attribute | 12 | 339.42 ± 0.2% | 351.44 ± 0.4% | 459.90 ± 0.3% | 45.33 ± 0.7% | 497.62 ± 2.7% | 773.50 ± 1.2% | 21637.71 ± 0.1% | 339.40 ± 0.3% | 0.97 | 1.00 | 7.49 | 0.68 |
| literal: a word, second text | 10 | 540.39 ± 0.3% | 592.39 ± 0.8% | 973.86 ± 0.1% | 413.88 ± 0.3% | 540.02 ± 3.1% | 811.70 ± 0.5% | 27047.11 ± 1.1% | 541.02 ± 0.2% | 0.91 | 1.00 | 1.31 | 1.00 |
| class: two capitalized words | 23 | 432.62 ± 0.3% | 458.37 ± 0.6% | 657.93 ± 0.3% | 100.43 ± 2.6% | 506.04 ± 5.4% | 745.31 ± 0.9% | 6296.08 ± 0.2% | 432.40 ± 0.6% | 0.94 | 1.00 | 4.31 | 0.85 |
| class: a word that ends in ing | 9 | 552.82 ± 0.2% | 617.50 ± 0.4% | 1067.85 ± 0.1% | 132.67 ± 0.4% | 757.35 ± 0.8% | 1106.85 ± 0.4% | 15705.44 ± 0.4% | 552.86 ± 0.5% | 0.90 | 1.00 | 4.17 | 0.73 |
| class: a word in capitals | 16 | 492.95 ± 0.2% | 529.42 ± 0.4% | 836.33 ± 0.4% | 134.96 ± 1.2% | 755.58 ± 1.0% | 1033.58 ± 1.1% | 8299.16 ± 0.1% | 493.04 ± 0.3% | 0.93 | 1.00 | 3.65 | 0.65 |
| class: a number | 6 | 620.58 ± 0.2% | 677.37 ± 0.2% | 1247.01 ± 0.3% | 41.79 ± 1.2% | 1405.39 ± 0.5% | 1878.07 ± 0.8% | 22771.97 ± 0.0% | 620.22 ± 0.4% | 0.92 | 1.00 | 14.85 | 0.44 |
| class: two capitalized words, second text | 23 | 432.11 ± 0.5% | 458.94 ± 0.4% | 659.39 ± 0.5% | 101.57 ± 1.7% | 507.37 ± 0.9% | 763.64 ± 3.5% | 6297.66 ± 0.2% | 432.06 ± 0.5% | 0.94 | 1.00 | 4.25 | 0.85 |
| other: a word between two words | 13 | 529.32 ± 0.5% | 550.86 ± 0.8% | 867.24 ± 0.5% | 134.53 ± 0.6% | 504.92 ± 0.9% | 803.84 ± 0.4% | 14569.77 ± 0.3% | 529.23 ± 0.7% | 0.96 | 1.00 | 3.93 | 1.05 |
| other: a number before a unit, second text | 15 | 391.45 ± 0.1% | 429.13 ± 0.5% | 598.92 ± 0.1% | 39.60 ± 0.1% | 636.97 ± 1.6% | 891.51 ± 0.4% | 15113.29 ± 0.4% | 391.33 ± 0.3% | 0.91 | 1.00 | 9.89 | 0.61 |
| other: a heading's start tag | 13 | 350.85 ± 0.3% | 357.55 ± 0.2% | 468.64 ± 0.1% | 43.82 ± 0.6% | 632.79 ± 0.8% | 874.97 ± 0.3% | 17984.58 ± 0.3% | 351.18 ± 0.2% | 0.98 | 1.00 | 8.01 | 0.55 |
| other: a whole word | 11 | 559.90 ± 0.8% | 596.87 ± 1.1% | 988.07 ± 1.1% | 119.69 ± 0.2% | 565.92 ± 1.9% | 815.77 ± 1.0% | 26807.17 ± 0.4% | 560.60 ± 1.0% | 0.94 | 1.00 | 4.68 | 0.99 |
| other: a line's first word, second text | 17 | 509.71 ± 0.6% | 544.24 ± 0.3% | 863.34 ± 0.2% | 128.34 ± 0.1% | 711.38 ± 0.5% | refused | refused | 510.98 ± 0.6% | 0.94 | 1.00 | 3.97 | 0.72 |
| other: fourteen octets before an x | 16 | 109.20 ± 0.3% | 157.21 ± 0.7% | 179.32 ± 0.6% | 15.00 ± 0.4% | 455.24 ± 0.8% | 401.99 ± 0.8% | 12751.21 ± 0.2% | 109.50 ± 0.4% | 0.69 | 1.00 | 7.28 | 0.24 |
| other: a Greek word | 8 | 446.94 ± 0.7% | 586.46 ± 0.6% | 978.62 ± 0.9% | 58.30 ± 0.1% | 1401.68 ± 0.9% | 1849.82 ± 0.4% | refused | 448.07 ± 0.7% | 0.76 | 1.00 | 7.67 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15766.51 ± 1.0% | not timed | not timed | 16483.35 ± 1.2% | 2063.31 ± 15.2% | not timed | not timed | 15737.08 ± 0.4% | | 1.00 | 0.96 | 7.64 |
| 01-literal/sherlock-casei-en | 522 | 10988.88 ± 5.1% | not timed | not timed | 3600.04 ± 0.2% | 32.47 ± 0.2% | not timed | not timed | 10966.47 ± 2.9% | | 1.00 | 3.05 | 338.47 |
| 01-literal/sherlock-ru | 724 | 17125.67 ± 0.3% | not timed | not timed | 17343.93 ± 0.2% | 1436.11 ± 14.5% | not timed | not timed | 17018.28 ± 0.1% | | 1.01 | 0.99 | 11.93 |
| 01-literal/sherlock-casei-ru | 746 | 6137.23 ± 0.4% | not timed | not timed | 3333.36 ± 0.1% | 31.75 ± 0.4% | not timed | not timed | 6141.84 ± 0.2% | | 1.00 | 1.84 | 193.28 |
| 01-literal/sherlock-zh | 30 | 20010.30 ± 0.6% | not timed | not timed | 18776.66 ± 1.0% | 2517.89 ± 15.5% | not timed | not timed | 19985.76 ± 1.0% | | 1.00 | 1.07 | 7.95 |
| 02-literal-alternate/sherlock-en | 714 | 6134.96 ± 0.4% | not timed | not timed | 3944.41 ± 0.2% | 16.64 ± 7.3% | not timed | not timed | 6131.77 ± 0.2% | | 1.00 | 1.56 | 368.70 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1971.90 ± 1.7% | not timed | not timed | 697.22 ± 0.3% | 11.03 ± 0.1% | not timed | not timed | 1977.19 ± 1.1% | | 1.00 | 2.83 | 178.83 |
| 02-literal-alternate/sherlock-ru | 899 | 5511.15 ± 0.3% | not timed | not timed | 3252.38 ± 0.0% | 22.63 ± 0.1% | not timed | not timed | 5507.91 ± 0.1% | | 1.00 | 1.69 | 243.48 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2053.00 ± 0.5% | not timed | not timed | 1231.36 ± 0.6% | 9.14 ± 0.3% | not timed | not timed | 2047.89 ± 0.4% | | 1.00 | 1.67 | 224.59 |
| 02-literal-alternate/sherlock-zh | 207 | 7330.47 ± 0.3% | not timed | not timed | 4160.74 ± 0.2% | 31.52 ± 0.1% | not timed | not timed | 7324.81 ± 0.3% | | 1.00 | 1.76 | 232.58 |
| 03-date/ascii | 111817 | 133.25 ± 0.6% | not timed | not timed | 96.26 ± 0.1% | 0.20 ± 4.5% | not timed | not timed | 132.78 ± 0.6% | | 1.00 | 1.38 | 657.60 |
| 04-ruff-noqa/real | 84 | 438.41 ± 0.2% | not timed | not timed | 457.94 ± 0.2% | 19.83 ± 1.3% | not timed | not timed | 437.41 ± 0.2% | | 1.00 | 0.96 | 22.10 |
| 04-ruff-noqa/tweaked | 44 | 846.77 ± 0.2% | not timed | not timed | 459.63 ± 0.0% | 368.44 ± 0.4% | not timed | not timed | 846.21 ± 0.2% | | 1.00 | 1.84 | 2.30 |
| 05-lexer-veryl/single | 124800 | 5.26 ± 0.2% | not timed | not timed | 5.07 ± 0.4% | 0.20 ± 3.4% | not timed | not timed | 5.30 ± 3.3% | | 0.99 | 1.04 | 25.74 |
| 06-cloud-flare-redos/original | 107 | 439.62 ± 0.1% | not timed | not timed | 217.41 ± 0.0% | 24.94 ± 0.2% | not timed | not timed | 435.74 ± 0.1% | | 1.01 | 2.02 | 17.63 |
| 06-cloud-flare-redos/simplified-short | 102 | 438.74 ± 0.4% | not timed | not timed | 228.47 ± 0.1% | 26.65 ± 0.5% | not timed | not timed | 434.17 ± 0.1% | | 1.01 | 1.92 | 16.46 |
| 06-cloud-flare-redos/simplified-long | 10000 | 629.11 ± 0.1% | not timed | not timed | 256.50 ± 0.2% | 28.69 ± 0.1% | not timed | not timed | 629.16 ± 0.1% | | 1.00 | 2.45 | 21.93 |
| 07-unicode-character-data/parse-line | 558784 | 240.19 ± 2.3% | not timed | not timed | 171.54 ± 0.2% | 42.37 ± 3.1% | not timed | not timed | 243.45 ± 2.3% | | 0.99 | 1.40 | 5.67 |
| 08-words/all-english | 56691 | 129.04 ± 0.8% | not timed | not timed | 82.98 ± 0.2% | 11.94 ± 11.4% | not timed | not timed | 127.49 ± 0.9% | | 1.01 | 1.56 | 10.81 |
| 08-words/long-english | 839 | 617.10 ± 0.4% | not timed | not timed | 595.68 ± 0.1% | 32.67 ± 1.3% | not timed | not timed | 617.84 ± 0.7% | | 1.00 | 1.04 | 18.89 |
| 09-aws-keys/full | 0 | 443.31 ± 0.2% | not timed | not timed | 461.38 ± 0.2% | 64.45 ± 0.3% | not timed | not timed | 442.84 ± 0.4% | | 1.00 | 0.96 | 6.88 |
| 09-aws-keys/quick | 0 | 874.19 ± 0.4% | not timed | not timed | 995.20 ± 0.7% | 425.39 ± 2.3% | not timed | not timed | 875.26 ± 0.3% | | 1.00 | 0.88 | 2.06 |
| 10-bounded-repeat/letters-en | 1833 | 579.96 ± 2.0% | not timed | not timed | 517.95 ± 0.6% | 19.24 ± 0.5% | not timed | not timed | 580.13 ± 2.0% | | 1.00 | 1.12 | 30.14 |
| 10-bounded-repeat/letters-ru | 3475 | 505.17 ± 1.6% | not timed | not timed | 479.35 ± 0.1% | 21.79 ± 10.6% | not timed | not timed | 506.52 ± 1.0% | | 1.00 | 1.05 | 23.19 |
| 10-bounded-repeat/context | 53 | 85.08 ± 1.9% | not timed | not timed | 66.27 ± 0.5% | 19.82 ± 0.3% | not timed | not timed | 85.52 ± 1.4% | | 0.99 | 1.28 | 4.29 |
| 10-bounded-repeat/capitals | 11 | 639.02 ± 8.7% | not timed | not timed | 617.13 ± 0.1% | 36.38 ± 0.1% | not timed | not timed | 638.23 ± 8.1% | | 1.00 | 1.04 | 17.56 |
| 11-unstructured-to-json/extract | 600 | 57.80 ± 0.6% | not timed | not timed | 77.86 ± 0.1% | 49.22 ± 0.5% | not timed | not timed | 57.79 ± 0.4% | | 1.00 | 0.74 | 1.17 |
| 12-dictionary/single | 1 | 559.57 ± 1.7% | not timed | not timed | 560.26 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 560.55 ± 1.4% | | 1.00 | 1.00 | 1359.68 |
| 14-quadratic/1x | 100 | 21.79 ± 1.3% | not timed | not timed | 10.01 ± 0.1% | 0.98 ± 5.1% | not timed | not timed | 22.09 ± 1.6% | | 0.99 | 2.18 | 22.12 |
| 14-quadratic/2x | 200 | 19.75 ± 0.7% | not timed | not timed | 5.53 ± 0.4% | 0.53 ± 0.8% | not timed | not timed | 19.83 ± 0.8% | | 1.00 | 3.57 | 37.22 |
| 14-quadratic/10x | 1000 | 12.33 ± 0.5% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 1.5% | not timed | not timed | 12.35 ± 0.4% | | 1.00 | 10.16 | 107.04 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 1.9% | not timed | not timed | 0.35 ± 0.6% | 0.56 ± 4.6% | not timed | not timed | 1.27 ± 1.4% | | 1.00 | 3.64 | 2.27 |
| 04-ruff-noqa/compile-real | 1 | 104.64 ± 0.9% | not timed | not timed | 13.79 ± 0.2% | 142.13 ± 2.0% | not timed | not timed | 104.68 ± 1.1% | | 1.00 | 7.59 | 0.74 |
| 05-lexer-veryl/compile-single | 1 | 14.12 ± 1.1% | not timed | not timed | 2.53 ± 0.6% | 6.51 ± 2.0% | not timed | not timed | 14.11 ± 0.8% | | 1.00 | 5.58 | 2.17 |
| 07-unicode-character-data/compile | 1 | 108.47 ± 0.8% | not timed | not timed | 25.72 ± 0.5% | 36.81 ± 3.8% | not timed | not timed | 108.41 ± 1.0% | | 1.00 | 4.22 | 2.95 |
| 09-aws-keys/compile-full | 1 | 52.88 ± 0.3% | not timed | not timed | 8.20 ± 0.4% | 23.50 ± 1.2% | not timed | not timed | 52.81 ± 0.6% | | 1.00 | 6.45 | 2.25 |
| 09-aws-keys/compile-quick | 1 | 187.39 ± 1.0% | not timed | not timed | 46.81 ± 0.2% | 135.87 ± 2.0% | not timed | not timed | 187.76 ± 0.2% | | 1.00 | 4.00 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 70.37 ± 1.9% | not timed | not timed | 11.14 ± 0.7% | 16.42 ± 2.2% | not timed | not timed | 71.30 ± 1.8% | | 0.99 | 6.32 | 4.29 |
| 10-bounded-repeat/compile-capitals | 1 | 85.88 ± 1.7% | not timed | not timed | 8.14 ± 0.2% | 24.14 ± 1.4% | not timed | not timed | 86.00 ± 0.5% | | 1.00 | 10.56 | 3.56 |
| 11-unstructured-to-json/compile | 1 | 172.36 ± 1.4% | not timed | not timed | 40.79 ± 0.4% | 68.90 ± 1.6% | not timed | not timed | 171.98 ± 0.8% | | 1.00 | 4.23 | 2.50 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.8% | not timed | not timed | 0.07 ± 32.5% | 0.10 ± 13.0% | not timed | not timed | 0.35 ± 0.5% | | 1.00 | 4.99 | 3.66 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.45 ± 5.0% | not timed | not timed | 6.47 ± 0.1% | 0.57 ± 20.8% | not timed | not timed | 7.45 ± 5.0% | | 1.00 | 1.15 | 13.13 |
| dictionary/search/english-10 | 690 | 211.72 ± 1.6% | not timed | not timed | 166.61 ± 0.5% | 0.00 ± 0.3% | not timed | not timed | 199.06 ± 2.7% | | 1.06 | 1.27 | 70131.35 |
| dictionary/search/english-15 | 15 | 558.41 ± 1.4% | not timed | not timed | 559.84 ± 0.1% | 0.37 ± 0.3% | not timed | not timed | 560.60 ± 1.8% | | 1.00 | 1.00 | 1519.68 |
| folly/awyer-inn-busted | 1 | 21508.59 ± 0.1% | not timed | not timed | 143.23 ± 0.1% | 43.88 ± 0.1% | not timed | not timed | 21579.30 ± 0.1% | | 1.00 | 150.16 | 490.12 |
| folly/literal-never-match-rare | 0 | 21181.51 ± 1.0% | not timed | not timed | 19970.05 ± 0.4% | 41074.41 ± 0.7% | not timed | not timed | 21182.93 ± 0.3% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12556.96 ± 0.9% | not timed | not timed | 19910.28 ± 0.2% | 2186.07 ± 1.0% | not timed | not timed | 12590.67 ± 0.4% | | 1.00 | 0.63 | 5.74 |
| folly/literal-never-match-tricksy | 1 | 3264.20 ± 0.3% | not timed | not timed | 4410.44 ± 0.1% | 2959.60 ± 3.1% | not timed | not timed | 3267.03 ± 0.5% | | 1.00 | 0.74 | 1.10 |
| grep/every-line | 239963 | 1300.83 ± 0.5% | not timed | not timed | 958.18 ± 0.2% | 374.29 ± 17.9% | not timed | not timed | 1305.48 ± 0.2% | | 1.00 | 1.36 | 3.48 |
| grep/long-words-ascii | 5073 | 459.10 ± 0.2% | not timed | not timed | 469.05 ± 0.3% | 45.87 ± 6.6% | not timed | not timed | 459.12 ± 0.1% | | 1.00 | 0.98 | 10.01 |
| imported/leipzig/twain | 811 | 20785.20 ± 1.4% | not timed | not timed | 19638.08 ± 0.3% | 12020.98 ± 9.7% | not timed | not timed | 20766.56 ± 0.6% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9091.55 ± 1.1% | not timed | not timed | 4255.60 ± 0.1% | 37.73 ± 0.1% | not timed | not timed | 9156.63 ± 1.3% | | 0.99 | 2.14 | 240.96 |
| imported/leipzig/shing | 1540 | 15188.47 ± 2.9% | not timed | not timed | 13585.51 ± 0.2% | 34.01 ± 0.0% | not timed | not timed | 15579.35 ± 3.4% | | 0.97 | 1.12 | 446.62 |
| imported/leipzig/huck-saw | 262 | 8291.82 ± 2.9% | not timed | not timed | 5608.85 ± 0.1% | 31.58 ± 0.2% | not timed | not timed | 8463.98 ± 2.4% | | 0.98 | 1.48 | 262.53 |
| imported/leipzig/word-ending-nn | 262 | 601.83 ± 1.4% | not timed | not timed | 616.92 ± 0.1% | 24.74 ± 0.7% | not timed | not timed | 605.19 ± 0.6% | | 0.99 | 0.98 | 24.32 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11216.57 ± 1.3% | not timed | not timed | 4581.64 ± 0.3% | 11.49 ± 1.0% | not timed | not timed | 11139.65 ± 2.9% | | 1.01 | 2.45 | 975.86 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7803.63 ± 2.3% | not timed | not timed | 5494.02 ± 0.1% | 16.93 ± 0.1% | not timed | not timed | 7942.25 ± 2.6% | | 0.98 | 1.42 | 460.97 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4186.92 ± 0.7% | not timed | not timed | 417.65 ± 1.1% | 11.09 ± 0.0% | not timed | not timed | 4203.37 ± 0.7% | | 1.00 | 10.02 | 377.52 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7325.24 ± 3.8% | not timed | not timed | 614.50 ± 0.3% | 11.12 ± 0.1% | not timed | not timed | 7504.41 ± 3.0% | | 0.98 | 11.92 | 658.47 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7138.68 ± 3.0% | not timed | not timed | 616.08 ± 0.0% | 9.73 ± 0.1% | not timed | not timed | 7337.88 ± 3.0% | | 0.97 | 11.59 | 734.02 |
| imported/leipzig/tom-river | 2 | 6485.79 ± 2.1% | not timed | not timed | 5157.89 ± 0.1% | 30.94 ± 0.1% | not timed | not timed | 6593.70 ± 2.0% | | 0.98 | 1.26 | 209.63 |
| imported/leipzig/ing | 78424 | 602.51 ± 0.6% | not timed | not timed | 572.50 ± 0.1% | 28.32 ± 3.0% | not timed | not timed | 601.53 ± 0.8% | | 1.00 | 1.05 | 21.28 |
| imported/leipzig/ing-whitespace | 55248 | 1930.96 ± 1.5% | not timed | not timed | 2062.07 ± 0.9% | 20.58 ± 2.8% | not timed | not timed | 1942.24 ± 1.3% | | 0.99 | 0.94 | 93.82 |
| imported/leipzig/awyer-inn | 209 | 6379.88 ± 1.4% | not timed | not timed | 4286.41 ± 0.2% | 22.62 ± 0.0% | not timed | not timed | 6447.69 ± 1.3% | | 0.99 | 1.49 | 282.11 |
| imported/leipzig/quotes-bounded | 8886 | 2500.15 ± 1.1% | not timed | not timed | 2958.03 ± 0.2% | 38.33 ± 0.1% | not timed | not timed | 2514.68 ± 1.2% | | 0.99 | 0.85 | 65.23 |
| imported/leipzig/non-ascii-alternate | 2 | 12927.50 ± 2.2% | not timed | not timed | 5675.50 ± 0.1% | 50.88 ± 0.1% | not timed | not timed | 13112.40 ± 2.1% | | 0.99 | 2.28 | 254.09 |
| imported/leipzig/math-symbols | 69 | 1974.04 ± 0.8% | not timed | not timed | 618.69 ± 0.1% | 36.56 ± 0.1% | not timed | not timed | 1976.14 ± 0.9% | | 1.00 | 3.19 | 54.00 |
| imported/leipzig/bounded-strings-ending-z | 0 | 631.16 ± 2.1% | not timed | not timed | 617.87 ± 0.1% | 22.33 ± 0.1% | not timed | not timed | 633.44 ± 1.9% | | 1.00 | 1.02 | 28.27 |
| imported/lh3lh3-reb/uri | 17549 | 677.83 ± 0.2% | not timed | not timed | 1069.84 ± 0.1% | 28.31 ± 2.1% | not timed | not timed | 679.74 ± 0.1% | | 1.00 | 0.63 | 23.94 |
| imported/lh3lh3-reb/email | 15057 | 674.16 ± 0.1% | not timed | not timed | 1154.40 ± 0.1% | 30.76 ± 0.7% | not timed | not timed | 676.35 ± 0.1% | | 1.00 | 0.58 | 21.92 |
| imported/lh3lh3-reb/date | 668 | 892.55 ± 0.3% | not timed | not timed | 1036.43 ± 0.1% | 50.02 ± 3.8% | not timed | not timed | 888.58 ± 0.2% | | 1.00 | 0.86 | 17.84 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.82 ± 0.1% | not timed | not timed | 424.52 ± 0.2% | 15.77 ± 0.5% | not timed | not timed | 647.09 ± 0.2% | | 1.00 | 1.52 | 40.94 |
| imported/mariomka/email | 92 | 24439.43 ± 0.9% | not timed | not timed | 29682.50 ± 0.6% | 32.87 ± 0.1% | not timed | not timed | 24535.21 ± 0.7% | | 1.00 | 0.82 | 743.47 |
| imported/mariomka/uri | 5301 | 5581.55 ± 0.4% | not timed | not timed | 6127.38 ± 0.2% | 32.88 ± 0.5% | not timed | not timed | 5537.08 ± 0.4% | | 1.01 | 0.91 | 169.76 |
| imported/mariomka/ip | 5 | 2607.54 ± 2.6% | not timed | not timed | 2970.11 ± 0.1% | 21.04 ± 0.2% | not timed | not timed | 2605.90 ± 2.9% | | 1.00 | 0.88 | 123.93 |
| imported/rsc/no-exponential | 0 | 607.52 ± 0.3% | not timed | not timed | 317.40 ± 0.2% | 23.87 ± 0.1% | not timed | not timed | 607.11 ± 0.1% | | 1.00 | 1.91 | 25.45 |
| imported/rsc/literal | 1 | 1491.52 ± 7.6% | not timed | not timed | 1666.16 ± 7.5% | 184.23 ± 19.7% | not timed | not timed | 1460.52 ± 3.1% | | 1.02 | 0.90 | 8.10 |
| imported/rsc/not-literal | 2 | 776.66 ± 1.6% | not timed | not timed | 742.22 ± 0.4% | 46.20 ± 8.6% | not timed | not timed | 775.23 ± 0.4% | | 1.00 | 1.05 | 16.81 |
| imported/rsc/match-class | 1 | 1475.89 ± 0.2% | not timed | not timed | 1616.38 ± 0.4% | 58.33 ± 5.9% | not timed | not timed | 1470.00 ± 2.1% | | 1.00 | 0.91 | 25.30 |
| imported/rsc/match-class-in-range | 1 | 1474.82 ± 8.8% | not timed | not timed | 2410.81 ± 4.0% | 59.54 ± 1.3% | not timed | not timed | 1475.35 ± 0.3% | | 1.00 | 0.61 | 24.77 |
| imported/rsc/match-class-unicode | 1 | 539.59 ± 0.6% | not timed | not timed | 512.88 ± 0.1% | 72.71 ± 0.2% | not timed | not timed | 542.18 ± 0.8% | | 1.00 | 1.05 | 7.42 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1453.06 ± 0.2% | not timed | not timed | 961.34 ± 0.3% | 222.26 ± 0.8% | not timed | not timed | 1442.94 ± 0.2% | | 1.01 | 1.51 | 6.54 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21789.42 ± 0.3% | not timed | not timed | 14360.79 ± 0.2% | 3330.71 ± 1.0% | not timed | not timed | 21606.77 ± 0.1% | | 1.01 | 1.52 | 6.54 |
| imported/rsc/anchored-literal-short-match | 4 | 717.74 ± 1.4% | not timed | not timed | 490.23 ± 0.5% | 83.42 ± 14.2% | not timed | not timed | 718.43 ± 1.8% | | 1.00 | 1.46 | 8.60 |
| imported/rsc/anchored-literal-long-match | 4 | 10878.01 ± 0.4% | not timed | not timed | 7270.30 ± 0.3% | 1217.17 ± 4.1% | not timed | not timed | 10767.49 ± 0.6% | | 1.01 | 1.50 | 8.94 |
| imported/rsc/one-pass-short | 17 | 367.55 ± 10.3% | not timed | not timed | 218.50 ± 0.3% | 30.10 ± 9.5% | not timed | not timed | 367.33 ± 1.5% | | 1.00 | 1.68 | 12.21 |
| imported/rsc/one-pass-short-not | 17 | 270.05 ± 2.3% | not timed | not timed | 225.62 ± 0.2% | 30.12 ± 11.9% | not timed | not timed | 268.81 ± 1.3% | | 1.00 | 1.20 | 8.97 |
| imported/rsc/one-pass-long-prefix | 26 | 360.43 ± 1.8% | not timed | not timed | 279.63 ± 0.6% | 102.18 ± 16.7% | not timed | not timed | 362.14 ± 5.7% | | 1.00 | 1.29 | 3.53 |
| imported/rsc/one-pass-long-prefix-not | 26 | 360.23 ± 1.8% | not timed | not timed | 281.83 ± 0.1% | 65.41 ± 18.7% | not timed | not timed | 363.71 ± 2.2% | | 0.99 | 1.28 | 5.51 |
| imported/rsc/long-needle1 | 31 | 21931.23 ± 0.1% | not timed | not timed | 20165.08 ± 0.0% | 3.76 ± 0.1% | not timed | not timed | 21943.82 ± 0.1% | | 1.00 | 1.09 | 5833.50 |
| imported/rsc/long-needle2 | 31 | 22097.14 ± 0.1% | not timed | not timed | 216.11 ± 0.2% | 3.76 ± 0.1% | not timed | not timed | 22094.74 ± 0.1% | | 1.00 | 102.25 | 5884.62 |
| imported/rsc/easy0-32 | 26 | 1577.75 ± 7.4% | not timed | not timed | 1590.84 ± 4.2% | 148.08 ± 13.2% | not timed | not timed | 1532.50 ± 2.3% | | 1.03 | 0.99 | 10.65 |
| imported/rsc/easy0-1k | 26 | 13633.21 ± 0.3% | not timed | not timed | 12498.31 ± 1.6% | 2309.47 ± 14.6% | not timed | not timed | 13668.30 ± 1.5% | | 1.00 | 1.09 | 5.90 |
| imported/rsc/easy0-32k | 26 | 22774.04 ± 1.5% | not timed | not timed | 20327.25 ± 0.1% | 18808.12 ± 23.0% | not timed | not timed | 23022.45 ± 0.4% | | 0.99 | 1.12 | 1.21 |
| imported/rsc/easy0-1mb | 26 | 21905.18 ± 1.4% | not timed | not timed | 20029.02 ± 1.2% | 37893.60 ± 1.3% | not timed | not timed | 21911.76 ± 0.7% | | 1.00 | 1.09 | 0.58 |
| imported/rsc/easy1-32 | 19 | 769.01 ± 2.1% | not timed | not timed | 650.01 ± 0.3% | 130.43 ± 21.1% | not timed | not timed | 769.50 ± 1.6% | | 1.00 | 1.18 | 5.90 |
| imported/rsc/easy1-1k | 19 | 15839.20 ± 2.4% | not timed | not timed | 12917.87 ± 0.1% | 2499.02 ± 16.8% | not timed | not timed | 15791.35 ± 0.2% | | 1.00 | 1.23 | 6.34 |
| imported/rsc/easy1-32k | 19 | 495997.75 ± 0.3% | not timed | not timed | 410420.42 ± 0.2% | 20417.17 ± 0.1% | not timed | not timed | 494827.22 ± 0.2% | | 1.00 | 1.21 | 24.29 |
| imported/rsc/easy1-1mb | 19 | 15889486.90 ± 0.1% | not timed | not timed | 13062183.88 ± 0.4% | 38339.02 ± 1.9% | not timed | not timed | 15859355.58 ± 0.2% | | 1.00 | 1.22 | 414.45 |
| imported/rsc/medium-32 | 27 | 739.28 ± 2.0% | not timed | not timed | 648.83 ± 0.5% | 69.69 ± 13.1% | not timed | not timed | 740.14 ± 0.1% | | 1.00 | 1.14 | 10.61 |
| imported/rsc/medium-1k | 27 | 13190.17 ± 0.2% | not timed | not timed | 11339.17 ± 0.5% | 72.05 ± 0.1% | not timed | not timed | 13161.03 ± 0.2% | | 1.00 | 1.16 | 183.07 |
| imported/rsc/medium-32k | 27 | 411161.39 ± 0.4% | not timed | not timed | 354142.01 ± 0.2% | 48.94 ± 0.0% | not timed | not timed | 410109.95 ± 0.3% | | 1.00 | 1.16 | 8401.26 |
| imported/rsc/medium-1mb | 27 | 13137225.38 ± 0.3% | not timed | not timed | 11331605.81 ± 0.5% | 48.92 ± 0.3% | not timed | not timed | 13123354.17 ± 0.3% | | 1.00 | 1.16 | 268555.35 |
| imported/rsc/hard-32 | 58 | 424.74 ± 1.8% | not timed | not timed | 377.10 ± 0.4% | 49.73 ± 9.2% | not timed | not timed | 422.14 ± 0.2% | | 1.01 | 1.13 | 8.54 |
| imported/rsc/hard-1k | 27 | 12906.75 ± 0.2% | not timed | not timed | 11652.24 ± 0.2% | 40.57 ± 0.0% | not timed | not timed | 12858.15 ± 0.2% | | 1.00 | 1.11 | 318.12 |
| imported/rsc/hard-32k | 27 | 402876.51 ± 0.1% | not timed | not timed | 364059.47 ± 0.3% | 29.28 ± 0.1% | not timed | not timed | 401441.92 ± 0.1% | | 1.00 | 1.11 | 13759.04 |
| imported/rsc/hard-1mb | 51 | 8410764.29 ± 0.2% | not timed | not timed | 7251290.91 ± 0.1% | 29.39 ± 0.1% | not timed | not timed | 8377704.17 ± 0.1% | | 1.00 | 1.16 | 286195.74 |
| imported/rsc/reallyhard0-32 | 58 | 263.36 ± 2.3% | not timed | not timed | 223.25 ± 0.1% | 49.61 ± 7.7% | not timed | not timed | 263.73 ± 0.4% | | 1.00 | 1.18 | 5.31 |
| imported/rsc/reallyhard0-1k | 27 | 580.03 ± 0.5% | not timed | not timed | 583.56 ± 0.3% | 40.53 ± 0.1% | not timed | not timed | 581.99 ± 0.2% | | 1.00 | 0.99 | 14.31 |
| imported/rsc/reallyhard0-32k | 27 | 601.18 ± 0.5% | not timed | not timed | 616.81 ± 0.0% | 29.33 ± 0.1% | not timed | not timed | 598.32 ± 0.7% | | 1.00 | 0.97 | 20.50 |
| imported/rsc/reallyhard0-1mb | 51 | 625.50 ± 0.7% | not timed | not timed | 616.55 ± 0.1% | 29.37 ± 0.1% | not timed | not timed | 625.13 ± 1.3% | | 1.00 | 1.01 | 21.30 |
| imported/rsc/reallyreallyhard0-32 | 47 | 284.48 ± 6.3% | not timed | not timed | 196.98 ± 1.0% | 61.25 ± 3.0% | not timed | not timed | 282.61 ± 1.4% | | 1.01 | 1.44 | 4.64 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7012.64 ± 0.2% | not timed | not timed | 5973.81 ± 0.3% | 34.25 ± 0.2% | not timed | not timed | 6971.44 ± 0.1% | | 1.01 | 1.17 | 204.75 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21449.81 ± 0.1% | not timed | not timed | 19177.59 ± 0.0% | 24.85 ± 0.3% | not timed | not timed | 21499.99 ± 0.0% | | 1.00 | 1.12 | 863.26 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21730.98 ± 1.7% | not timed | not timed | 19881.51 ± 1.0% | 25.04 ± 0.7% | not timed | not timed | 21644.03 ± 0.4% | | 1.00 | 1.09 | 867.93 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 281.25 ± 1.6% | not timed | not timed | 214.24 ± 1.0% | 60.70 ± 13.2% | not timed | not timed | 278.60 ± 1.4% | | 1.01 | 1.31 | 4.63 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5923.57 ± 0.2% | not timed | not timed | 6211.46 ± 0.2% | 33.57 ± 3.4% | not timed | not timed | 5831.07 ± 0.2% | | 1.02 | 0.95 | 176.46 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21321.37 ± 0.1% | not timed | not timed | 19258.89 ± 0.0% | 24.79 ± 0.6% | not timed | not timed | 21375.31 ± 0.1% | | 1.00 | 1.11 | 860.18 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21524.25 ± 1.3% | not timed | not timed | 19928.23 ± 1.7% | 24.72 ± 0.4% | not timed | not timed | 21617.95 ± 0.9% | | 1.00 | 1.08 | 870.61 |
| imported/sherlock/name-sherlock | 776 | 19996.80 ± 0.1% | not timed | not timed | 18569.47 ± 0.5% | 10152.42 ± 27.5% | not timed | not timed | 20021.60 ± 2.7% | | 1.00 | 1.08 | 1.97 |
| imported/sherlock/name-holmes | 2766 | 15316.47 ± 1.3% | not timed | not timed | 15611.52 ± 0.3% | 3280.31 ± 13.3% | not timed | not timed | 15408.57 ± 1.2% | | 0.99 | 0.98 | 4.67 |
| imported/sherlock/name-sherlock-holmes | 1365 | 20044.30 ± 1.7% | not timed | not timed | 18540.18 ± 0.6% | 8128.21 ± 48.2% | not timed | not timed | 20033.72 ± 1.9% | | 1.00 | 1.08 | 2.47 |
| imported/sherlock/name-sherlock-casei | 816 | 15827.15 ± 0.3% | not timed | not timed | 4022.32 ± 0.1% | 32.29 ± 0.9% | not timed | not timed | 15831.85 ± 0.3% | | 1.00 | 3.93 | 490.12 |
| imported/sherlock/name-holmes-casei | 2802 | 9404.17 ± 3.7% | not timed | not timed | 3331.86 ± 0.1% | 37.40 ± 0.3% | not timed | not timed | 9378.83 ± 1.5% | | 1.00 | 2.82 | 251.44 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13014.21 ± 2.4% | not timed | not timed | 3958.10 ± 0.1% | 32.44 ± 0.5% | not timed | not timed | 13045.12 ± 0.7% | | 1.00 | 3.29 | 401.20 |
| imported/sherlock/name-whitespace | 1461 | 15434.76 ± 1.4% | not timed | not timed | 14583.77 ± 0.3% | 7388.47 ± 23.5% | not timed | not timed | 15366.69 ± 1.5% | | 1.00 | 1.06 | 2.09 |
| imported/sherlock/name-alt1 | 1142 | 11671.55 ± 2.4% | not timed | not timed | 16466.77 ± 0.3% | 4129.24 ± 54.2% | not timed | not timed | 11620.33 ± 2.3% | | 1.00 | 0.71 | 2.83 |
| imported/sherlock/name-alt2 | 3542 | 8984.52 ± 0.2% | not timed | not timed | 3837.26 ± 0.1% | 31.29 ± 0.1% | not timed | not timed | 8909.98 ± 0.2% | | 1.01 | 2.34 | 287.17 |
| imported/sherlock/name-alt3 | 4507 | 5559.97 ± 0.5% | not timed | not timed | 3639.92 ± 0.0% | 9.96 ± 4.2% | not timed | not timed | 5544.47 ± 0.4% | | 1.00 | 1.53 | 558.30 |
| imported/sherlock/name-alt3-casei | 4593 | 1528.47 ± 2.7% | not timed | not timed | 285.02 ± 0.1% | 6.45 ± 0.2% | not timed | not timed | 1528.88 ± 0.6% | | 1.00 | 5.36 | 237.12 |
| imported/sherlock/name-alt4 | 3686 | 6442.79 ± 0.2% | not timed | not timed | 3795.08 ± 0.1% | 31.33 ± 0.1% | not timed | not timed | 6406.82 ± 0.1% | | 1.01 | 1.70 | 205.64 |
| imported/sherlock/name-alt4-casei | 4254 | 2811.50 ± 2.3% | not timed | not timed | 2589.15 ± 0.2% | 19.86 ± 0.4% | not timed | not timed | 2818.36 ± 1.2% | | 1.00 | 1.09 | 141.56 |
| imported/sherlock/name-alt5 | 4028 | 6419.88 ± 0.3% | not timed | not timed | 3753.07 ± 0.1% | 21.88 ± 0.1% | not timed | not timed | 6397.07 ± 0.3% | | 1.00 | 1.71 | 293.42 |
| imported/sherlock/name-alt5-casei | 4104 | 3485.89 ± 1.8% | not timed | not timed | 2228.75 ± 0.5% | 14.32 ± 0.1% | not timed | not timed | 3491.29 ± 1.0% | | 1.00 | 1.56 | 243.38 |
| imported/sherlock/no-match-uncommon | 0 | 21797.59 ± 0.8% | not timed | not timed | 19681.56 ± 0.8% | 36339.71 ± 1.2% | not timed | not timed | 21827.97 ± 0.7% | | 1.00 | 1.11 | 0.60 |
| imported/sherlock/no-match-common | 0 | 21677.00 ± 0.5% | not timed | not timed | 19526.66 ± 0.7% | 1279.06 ± 1.0% | not timed | not timed | 21707.59 ± 0.4% | | 1.00 | 1.11 | 16.95 |
| imported/sherlock/no-match-really-common | 0 | 16251.79 ± 1.5% | not timed | not timed | 18754.18 ± 0.4% | 1278.24 ± 1.3% | not timed | not timed | 16411.39 ± 1.8% | | 0.99 | 0.87 | 12.71 |
| imported/sherlock/the-lower | 21654 | 2307.63 ± 0.9% | not timed | not timed | 2327.09 ± 0.4% | 240.63 ± 17.1% | not timed | not timed | 2264.68 ± 1.0% | | 1.02 | 0.99 | 9.59 |
| imported/sherlock/the-upper | 2223 | 12792.51 ± 9.8% | not timed | not timed | 13606.69 ± 0.5% | 2742.00 ± 20.7% | not timed | not timed | 12673.83 ± 0.7% | | 1.01 | 0.94 | 4.67 |
| imported/sherlock/the-casei | 23961 | 1996.67 ± 0.4% | not timed | not timed | 1320.40 ± 0.4% | 34.92 ± 26.7% | not timed | not timed | 1944.00 ± 1.0% | | 1.03 | 1.51 | 57.18 |
| imported/sherlock/everything-greedy | 581881 | 282.63 ± 0.6% | not timed | not timed | 164.93 ± 0.1% | 29.06 ± 22.1% | not timed | not timed | 279.53 ± 0.9% | | 1.01 | 1.71 | 9.73 |
| imported/sherlock/everything-greedy-nl | 594933 | 491.36 ± 0.1% | not timed | not timed | 213.10 ± 0.4% | 32.93 ± 0.2% | not timed | not timed | 490.39 ± 0.1% | | 1.00 | 2.31 | 14.92 |
| imported/sherlock/letters | 447175 | 61.70 ± 0.5% | not timed | not timed | 33.00 ± 0.2% | 6.63 ± 10.2% | not timed | not timed | 61.53 ± 0.4% | | 1.00 | 1.87 | 9.31 |
| imported/sherlock/letters-upper | 14180 | 448.17 ± 1.4% | not timed | not timed | 372.62 ± 0.1% | 29.74 ± 21.1% | not timed | not timed | 444.66 ± 0.3% | | 1.01 | 1.20 | 15.07 |
| imported/sherlock/letters-lower | 432995 | 62.67 ± 0.4% | not timed | not timed | 33.80 ± 0.1% | 5.49 ± 35.5% | not timed | not timed | 62.68 ± 1.0% | | 1.00 | 1.85 | 11.41 |
| imported/sherlock/words | 447639 | 112.46 ± 0.5% | not timed | not timed | 83.03 ± 0.5% | 13.95 ± 29.5% | not timed | not timed | 112.08 ± 0.6% | | 1.00 | 1.35 | 8.06 |
| imported/sherlock/before-holmes | 4073 | 10344.98 ± 0.4% | not timed | not timed | 8481.31 ± 0.2% | 24.11 ± 1.1% | not timed | not timed | 10252.61 ± 0.6% | | 1.01 | 1.22 | 429.00 |
| imported/sherlock/before-after-holmes | 2593 | 10012.10 ± 0.9% | not timed | not timed | 9533.43 ± 0.5% | 24.11 ± 0.6% | not timed | not timed | 9977.70 ± 0.6% | | 1.00 | 1.05 | 415.30 |
| imported/sherlock/holmes-cochar-watson | 150 | 5207.77 ± 0.3% | not timed | not timed | 3435.96 ± 0.1% | 31.08 ± 0.3% | not timed | not timed | 5214.97 ± 0.4% | | 1.00 | 1.52 | 167.59 |
| imported/sherlock/holmes-coword-watson | 14309 | 1154.23 ± 0.2% | not timed | not timed | 1125.37 ± 0.2% | 6.76 ± 0.2% | not timed | not timed | 1157.19 ± 0.2% | | 1.00 | 1.03 | 170.72 |
| imported/sherlock/quotes | 14437 | 1577.33 ± 0.2% | not timed | not timed | 1753.63 ± 0.3% | 35.08 ± 0.4% | not timed | not timed | 1573.45 ± 0.3% | | 1.00 | 0.90 | 44.97 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17626.43 ± 0.3% | not timed | not timed | 16059.80 ± 0.2% | 36.86 ± 0.1% | not timed | not timed | 17541.45 ± 0.2% | | 1.00 | 1.10 | 478.18 |
| imported/sherlock/word-ending-n | 35297 | 481.62 ± 0.8% | not timed | not timed | 409.87 ± 0.1% | 23.51 ± 14.9% | not timed | not timed | 479.18 ± 0.3% | | 1.01 | 1.18 | 20.49 |
| imported/sherlock/repeated-class-negation | 2130 | 14945.00 ± 1.2% | not timed | not timed | 10963.78 ± 0.3% | 11.57 ± 0.4% | not timed | not timed | 14891.18 ± 0.4% | | 1.00 | 1.36 | 1291.29 |
| imported/sherlock/ing-suffix | 20547 | 559.25 ± 0.5% | not timed | not timed | 515.32 ± 0.1% | 28.95 ± 0.1% | not timed | not timed | 557.80 ± 0.4% | | 1.00 | 1.09 | 19.32 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1667.56 ± 0.8% | not timed | not timed | 2112.94 ± 0.7% | 20.53 ± 0.2% | not timed | not timed | 1653.05 ± 0.7% | | 1.01 | 0.79 | 81.24 |
| opt/accelerate/whole-line | 239963 | 457.43 ± 0.4% | not timed | not timed | 374.44 ± 0.3% | 92.44 ± 15.6% | not timed | not timed | 457.48 ± 0.0% | | 1.00 | 1.22 | 4.95 |
| opt/accelerate/non-dna | 16745 | 431.82 ± 0.4% | not timed | not timed | 397.70 ± 0.1% | 29.28 ± 21.7% | not timed | not timed | 427.97 ± 0.5% | | 1.01 | 1.09 | 14.75 |
| opt/backtrack/words-english | 40536 | 141.59 ± 7.5% | not timed | not timed | 94.45 ± 0.2% | 19.73 ± 7.4% | not timed | not timed | 141.36 ± 1.1% | | 1.00 | 1.50 | 7.18 |
| opt/fixed-length/too-small-ascii | 0 | 311.01 ± 0.2% | not timed | not timed | 709.25 ± 1.1% | 80.49 ± 0.5% | not timed | not timed | 316.17 ± 0.5% | | 0.98 | 0.44 | 3.86 |
| opt/fixed-length/too-big-ascii | 0 | 3465.59 ± 0.2% | not timed | not timed | 5800.37 ± 1.4% | 125.83 ± 0.1% | not timed | not timed | 3438.46 ± 0.4% | | 1.01 | 0.60 | 27.54 |
| opt/fixed-length/go33484-1 | 0 | 665099.73 ± 0.1% | not timed | not timed | 1099104.62 ± 1.5% | 61493.77 ± 0.5% | not timed | not timed | 663528.98 ± 0.2% | | 1.00 | 0.61 | 10.82 |
| opt/fixed-length/go33484-2 | 0 | 665975.10 ± 0.2% | not timed | not timed | 1112562.61 ± 1.7% | 31921.16 ± 1.9% | not timed | not timed | 662756.02 ± 0.4% | | 1.00 | 0.60 | 20.86 |
| opt/fixed-length/go33484-3 | 0 | 67102.32 ± 0.7% | not timed | not timed | 111199.80 ± 1.3% | 765.09 ± 0.6% | not timed | not timed | 66362.00 ± 0.8% | | 1.01 | 0.60 | 87.70 |
| opt/literal-alt/one-pattern | 1 | 548.56 ± 1.5% | not timed | not timed | 540.05 ± 0.0% | 0.40 ± 0.2% | not timed | not timed | 550.59 ± 1.6% | | 1.00 | 1.02 | 1366.23 |
| opt/onepass/fn-predicate | 916 | 367.80 ± 0.2% | not timed | not timed | 333.34 ± 0.1% | 203.07 ± 11.7% | not timed | not timed | 371.05 ± 0.7% | | 0.99 | 1.10 | 1.81 |
| opt/onepass/first-three-words-english | 35128 | 178.59 ± 6.9% | not timed | not timed | 201.91 ± 0.1% | 80.09 ± 11.5% | not timed | not timed | 182.16 ± 1.4% | | 0.98 | 0.88 | 2.23 |
| opt/prefilter/literal-english | 1 | 20901.99 ± 0.2% | not timed | not timed | 20019.27 ± 0.5% | 17610.82 ± 0.8% | not timed | not timed | 20855.73 ± 0.4% | | 1.00 | 1.04 | 1.19 |
| opt/prefilter/literal-casei-english | 1 | 14611.15 ± 2.1% | not timed | not timed | 4314.71 ± 0.5% | 32.60 ± 0.6% | not timed | not timed | 14595.53 ± 1.3% | | 1.00 | 3.39 | 448.25 |
| opt/prefilter/literal-russian | 1 | 21259.46 ± 0.5% | not timed | not timed | 19803.17 ± 0.9% | 3328.51 ± 0.2% | not timed | not timed | 21266.11 ± 0.3% | | 1.00 | 1.07 | 6.39 |
| opt/prefilter/literal-casei-russian | 1 | 8557.80 ± 0.4% | not timed | not timed | 3893.85 ± 0.2% | 31.70 ± 0.6% | not timed | not timed | 8544.04 ± 0.2% | | 1.00 | 2.20 | 269.94 |
| opt/prefilter/rust-functions | 948 | 6828.11 ± 0.3% | not timed | not timed | 8822.87 ± 0.3% | 1865.62 ± 0.4% | not timed | not timed | 6828.41 ± 0.4% | | 1.00 | 0.77 | 3.66 |
| opt/reverse-anchored/word-end | 1 | 29680244.92 ± 0.2% | not timed | not timed | 21879789.70 ± 0.2% | 50.17 ± 0.2% | not timed | not timed | 29356490.65 ± 0.1% | | 1.01 | 1.36 | 591588.91 |
| opt/reverse-inner/holmes | 2593 | 10017.89 ± 0.7% | not timed | not timed | 9559.49 ± 0.3% | 24.03 ± 1.7% | not timed | not timed | 9966.40 ± 0.5% | | 1.01 | 1.05 | 416.89 |
| opt/reverse-inner/email | 47 | 36852.33 ± 1.0% | not timed | not timed | 45159.80 ± 0.4% | 32.24 ± 0.2% | not timed | not timed | 36953.67 ± 0.8% | | 1.00 | 0.82 | 1142.95 |
| opt/reverse-inner/factored-prefix | 3542 | 591.12 ± 0.4% | not timed | not timed | 598.22 ± 0.1% | 12.38 ± 0.8% | not timed | not timed | 589.25 ± 0.5% | | 1.00 | 0.99 | 47.75 |
| opt/reverse-inner/no-quadratic-backward | 0 | 21006.89 ± 0.2% | not timed | not timed | 610.86 ± 0.1% | 74.80 ± 0.2% | not timed | not timed | 21170.99 ± 0.1% | | 0.99 | 34.39 | 280.83 |
| opt/reverse-inner/no-quadratic-forward | 0 | 734.62 ± 0.7% | not timed | not timed | 289.26 ± 0.4% | 24.67 ± 0.1% | not timed | not timed | 750.31 ± 2.3% | | 0.98 | 2.54 | 29.78 |
| opt/reverse-suffix/holmes | 4073 | 10354.25 ± 0.7% | not timed | not timed | 8482.47 ± 0.3% | 23.75 ± 1.7% | not timed | not timed | 10272.16 ± 0.3% | | 1.01 | 1.22 | 435.90 |
| opt/reverse-suffix/no-quadratic | 0 | 21090.57 ± 0.2% | not timed | not timed | 611.20 ± 0.4% | 74.66 ± 0.1% | not timed | not timed | 21161.07 ± 0.1% | | 1.00 | 34.51 | 282.49 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.49 ± 0.5% | not timed | not timed | 132.51 ± 0.1% | 13.22 ± 17.5% | not timed | not timed | 120.36 ± 2.7% | | 1.00 | 0.91 | 9.11 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.06 ± 2.3% | not timed | not timed | 131.79 ± 0.2% | 12.92 ± 14.6% | not timed | not timed | 120.33 ± 2.7% | | 1.00 | 0.91 | 9.29 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.3% | not timed | not timed | 0.55 ± 0.2% | 112.63 ± 0.8% | not timed | not timed | 0.28 ± 0.2% | | 0.99 | 0.50 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 314.20 ± 0.3% | not timed | not timed | 294.26 ± 0.1% | 103.30 ± 1.7% | not timed | not timed | 316.48 ± 0.4% | | 0.99 | 1.07 | 3.04 |
| reported/i13-subset-regex/original-ascii | 4094 | 11241.50 ± 1.1% | not timed | not timed | 4569.62 ± 0.3% | 11.47 ± 0.1% | not timed | not timed | 11129.27 ± 1.9% | | 1.01 | 2.46 | 980.28 |
| reported/i13-subset-regex/original-unicode | 4094 | 11064.76 ± 1.8% | not timed | not timed | 255.54 ± 2.8% | 11.51 ± 0.2% | not timed | not timed | 11100.98 ± 1.6% | | 1.00 | 43.30 | 961.03 |
| reported/i13-subset-regex/big-ascii | 1955 | 10727.49 ± 1.1% | not timed | not timed | 68.00 ± 3.4% | 9.71 ± 0.1% | not timed | not timed | 10733.88 ± 1.5% | | 1.00 | 157.76 | 1104.60 |
| reported/i13-subset-regex/big-unicode | 1955 | 10637.67 ± 1.6% | not timed | not timed | 12.27 ± 54.9% | 9.87 ± 0.1% | not timed | not timed | 10683.07 ± 1.4% | | 1.00 | 866.77 | 1077.75 |
| reported/i13-subset-regex/huge-ascii | 55 | 10125.97 ± 1.3% | not timed | not timed | 10.93 ± 0.1% | 8.77 ± 0.1% | not timed | not timed | 10116.61 ± 3.3% | | 1.00 | 926.66 | 1154.30 |
| reported/i13-subset-regex/huge-unicode | 55 | 10088.00 ± 2.9% | not timed | not timed | 11.03 ± 0.4% | 8.76 ± 0.1% | not timed | not timed | 9894.40 ± 3.6% | | 1.02 | 914.45 | 1151.37 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.1% | not timed | not timed | 11.03 ± 0.0% | 8.77 ± 1.0% | not timed | not timed | 3.53 ± 0.1% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.97 ± 0.2% | not timed | not timed | 10.96 ± 0.3% | 8.78 ± 0.1% | not timed | not timed | 4.97 ± 0.1% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 483.44 ± 0.3% | not timed | not timed | 104.44 ± 0.2% | 6.52 ± 0.2% | not timed | not timed | 482.31 ± 0.4% | | 1.00 | 4.63 | 74.14 |
| reported/i787-keywords/opt-ascii | 5674 | 485.38 ± 0.3% | not timed | not timed | 273.90 ± 0.3% | 10.31 ± 0.2% | not timed | not timed | 481.34 ± 0.3% | | 1.01 | 1.77 | 47.10 |
| slow/quadratic-regex-1x | 100 | 7.09 ± 0.4% | not timed | not timed | 4.96 ± 0.3% | 0.05 ± 0.3% | not timed | not timed | 7.14 ± 0.4% | | 0.99 | 1.43 | 144.00 |
| slow/quadratic-regex-2x | 199 | 3.42 ± 0.3% | not timed | not timed | 2.76 ± 0.3% | 0.01 ± 0.2% | not timed | not timed | 3.44 ± 0.2% | | 0.99 | 1.24 | 269.27 |
| slow/quadratic-haystack-1x | 100 | 22.11 ± 1.9% | not timed | not timed | 9.99 ± 0.2% | 1.01 ± 13.7% | not timed | not timed | 22.01 ± 0.8% | | 1.00 | 2.21 | 21.95 |
| slow/quadratic-haystack-2x | 200 | 19.70 ± 1.0% | not timed | not timed | 5.53 ± 0.1% | 0.54 ± 5.5% | not timed | not timed | 19.62 ± 1.5% | | 1.00 | 3.56 | 36.34 |
| unicode/codepoints/any-one | 1112064 | 280.76 ± 0.6% | not timed | not timed | 174.07 ± 0.3% | 17.82 ± 21.0% | not timed | not timed | 281.92 ± 0.3% | | 1.00 | 1.61 | 15.76 |
| unicode/codepoints/any-all | 4382592 | 279.33 ± 2.0% | not timed | not timed | 246.78 ± 0.2% | 117.35 ± 0.4% | not timed | not timed | 280.69 ± 0.2% | | 1.00 | 1.13 | 2.38 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.74 ± 0.7% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 600.21 ± 1.0% | not timed | not timed | 615.78 ± 0.4% | 135.66 ± 0.2% | not timed | not timed | 600.73 ± 0.8% | | 1.00 | 0.97 | 4.42 |
| unicode/overlapping-words/ascii | 6156 | 32.28 ± 2.1% | not timed | not timed | 38.78 ± 0.2% | 3.74 ± 5.8% | not timed | not timed | 32.32 ± 2.8% | | 1.00 | 0.83 | 8.63 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 1.2% | not timed | not timed | 4.46 ± 0.2% | 2.35 ± 6.3% | not timed | not timed | 1.43 ± 0.1% | | 1.01 | 0.32 | 0.61 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 7.8% | not timed | not timed | 3.86 ± 0.1% | 6.38 ± 5.0% | not timed | not timed | 1.27 ± 0.1% | | 1.01 | 0.33 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 129.50 ± 0.7% | not timed | not timed | 82.91 ± 0.1% | 12.08 ± 14.5% | not timed | not timed | 127.79 ± 2.9% | | 1.01 | 1.56 | 10.72 |
| unicode/word/boundary-long-english | 3466 | 605.96 ± 0.5% | not timed | not timed | 607.45 ± 0.2% | 32.36 ± 2.2% | not timed | not timed | 604.34 ± 0.8% | | 1.00 | 1.00 | 18.73 |
| unicode/word/around-holmes-english | 27 | 20066.79 ± 0.4% | not timed | not timed | 19688.57 ± 0.6% | 22.29 ± 0.7% | not timed | not timed | 19985.52 ± 0.3% | | 1.00 | 1.02 | 900.36 |
| wild/bibleref/long | 874 | 564.36 ± 0.2% | not timed | not timed | 584.97 ± 0.1% | 6.83 ± 0.2% | not timed | not timed | 566.88 ± 0.1% | | 1.00 | 0.96 | 82.59 |
| wild/bibleref/short | 30 | 23.75 ± 2.6% | not timed | not timed | 31.04 ± 0.2% | 14.34 ± 8.2% | not timed | not timed | 24.53 ± 1.4% | | 0.97 | 0.77 | 1.66 |
| wild/bibleref/line | 874 | 398.99 ± 0.1% | not timed | not timed | 211.50 ± 0.1% | 9.19 ± 0.2% | not timed | not timed | 399.89 ± 0.3% | | 1.00 | 1.89 | 43.40 |
| wild/caddy/caddy | 6 | 418.86 ± 2.8% | not timed | not timed | 247.39 ± 0.1% | 68.72 ± 14.5% | not timed | not timed | 422.10 ± 0.8% | | 0.99 | 1.69 | 6.10 |
| wild/dot-star-capture/rust-src-tools | 6 | 1071.00 ± 0.1% | not timed | not timed | 348.06 ± 0.3% | 13.59 ± 0.1% | not timed | not timed | 1065.39 ± 0.4% | | 1.01 | 3.08 | 78.80 |
| wild/ruff/noqa | 84 | 438.91 ± 0.2% | not timed | not timed | 462.93 ± 0.1% | 19.51 ± 2.1% | not timed | not timed | 438.98 ± 0.2% | | 1.00 | 0.95 | 22.50 |
| wild/ruff/unnecessary-coding-comment | 16 | 958.06 ± 0.4% | not timed | not timed | 702.27 ± 0.1% | 136.59 ± 10.8% | not timed | not timed | 959.44 ± 0.3% | | 1.00 | 1.36 | 7.01 |
| wild/ruff/string-quote-prefix | 2972 | 1365.82 ± 0.6% | not timed | not timed | 406.41 ± 0.1% | 317.39 ± 25.3% | not timed | not timed | 1366.76 ± 0.8% | | 1.00 | 3.36 | 4.30 |
| wild/ruff/space-around-operator | 1224378 | 223.34 ± 1.7% | not timed | not timed | 185.94 ± 0.1% | 18.37 ± 1.8% | not timed | not timed | 223.87 ± 1.8% | | 1.00 | 1.20 | 12.16 |
| wild/ruff/shebang | 282 | 971.91 ± 0.3% | not timed | not timed | 327.41 ± 0.1% | 111.72 ± 11.2% | not timed | not timed | 978.90 ± 0.5% | | 0.99 | 2.97 | 8.70 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13860.68 ± 0.7% | not timed | not timed | 13856.69 ± 0.2% | 6953.76 ± 0.4% | not timed | not timed | 13878.46 ± 0.1% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12880.19 ± 0.5% | not timed | not timed | 13556.37 ± 0.5% | 6410.47 ± 0.5% | not timed | not timed | 12913.07 ± 0.1% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13235.37 ± 1.8% | not timed | not timed | 13761.92 ± 0.2% | 6680.56 ± 1.2% | not timed | not timed | 13277.73 ± 0.4% | | 1.00 | 0.96 | 1.98 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9585.06 ± 0.2% | not timed | not timed | 13692.72 ± 0.1% | 6741.93 ± 0.4% | not timed | not timed | 9587.71 ± 0.2% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 121.91 ± 14.0% | not timed | not timed | 66.26 ± 0.4% | 2.23 ± 0.8% | not timed | not timed | 122.19 ± 14.7% | | 1.00 | 1.84 | 54.68 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 1.9% | not timed | not timed | 0.01 ± 1.4% | 0.01 ± 23.8% | not timed | not timed | 0.03 ± 8.3% | | 0.99 | 3.01 | 3.60 |
| dictionary/compile/english-15 | 1 | 0.35 ± 21.9% | not timed | not timed | 0.07 ± 0.5% | 0.11 ± 10.6% | not timed | not timed | 0.35 ± 1.6% | | 1.00 | 4.95 | 3.14 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 16.4% | not timed | not timed | 0.02 ± 1.3% | 36.83 ± 3.0% | not timed | not timed | 0.25 ± 2.4% | | 1.00 | 12.90 | 0.0069 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.34 ± 4.1% | not timed | not timed | 11.60 ± 0.2% | 57.06 ± 18.0% | not timed | not timed | 47.77 ± 6.9% | | 0.99 | 4.08 | 0.83 |
| reported/i787-keywords/compile | 1 | 35.59 ± 2.6% | not timed | not timed | 2.14 ± 0.9% | 17.88 ± 24.9% | not timed | not timed | 35.63 ± 2.7% | | 1.00 | 16.61 | 1.99 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 364.14 ± 2.4% | not timed | not timed | 117.73 ± 0.2% | 590.33 ± 28.5% | not timed | not timed | 364.99 ± 2.9% | | 1.00 | 3.09 | 0.62 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.87 ± 1.9% | not timed | not timed | 4.07 ± 1.1% | 44.41 ± 11.1% | not timed | not timed | 48.46 ± 2.6% | | 0.99 | 11.77 | 1.08 |
| unicode/compile/one-letter | 53 | 6.77 ± 10.6% | not timed | not timed | 4.61 ± 0.2% | 68.95 ± 11.0% | not timed | not timed | 6.80 ± 13.1% | | 1.00 | 1.47 | 0.0982 |
| unicode/compile/fifty-letters | 1 | 1.07 ± 16.5% | not timed | not timed | 0.10 ± 0.7% | 69.11 ± 13.1% | not timed | not timed | 1.11 ± 10.2% | | 0.96 | 10.52 | 0.0154 |
| unicode/compile/fifty-letters-ascii | 1 | 219.33 ± 7.8% | not timed | not timed | 53.39 ± 0.1% | 204.40 ± 11.2% | not timed | not timed | 223.82 ± 11.0% | | 0.98 | 4.11 | 1.07 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 386.25 ± 18.8% | not timed | not timed | 47.39 ± 0.3% | 695.50 ± 15.3% | not timed | not timed | 385.74 ± 2.5% | | 1.00 | 8.15 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 606.18 ± 11.8% | not timed | not timed | 145.02 ± 0.2% | 687.89 ± 23.8% | not timed | not timed | 613.06 ± 12.1% | | 0.99 | 4.18 | 0.88 |
| unicode/compile/negated-class-matches-codepoint | 1 | 331.06 ± 2.3% | not timed | not timed | 51.49 ± 0.4% | 1298.19 ± 27.3% | not timed | not timed | 332.35 ± 8.4% | | 1.00 | 6.43 | 0.26 |
| wild/bibleref/compile | 3 | 5.96 ± 1.2% | not timed | not timed | 1.95 ± 0.6% | 32.58 ± 2.3% | not timed | not timed | 5.97 ± 1.6% | | 1.00 | 3.06 | 0.18 |
| wild/url/compile | 1 | 0.66 ± 2.8% | not timed | not timed | 0.15 ± 0.5% | 0.39 ± 30.6% | not timed | not timed | 0.66 ± 0.9% | | 1.00 | 4.51 | 1.69 |

