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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507007418 |
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
| literal: a word | 217 | 19949.31 ± 2.2% | 5087.30 ± 0.3% | 28.20 ± 0.2% | 18268.97 ± 2.1% | 9158.62 ± 8.9% | 17.58 ± 0.4% | 86.06 ± 0.2% | 19932.37 ± 1.6% | 3.92 | 1.00 | 1.09 | 2.18 |
| literal: a word that is not there | 0 | 21853.06 ± 1.9% | 4934.27 ± 1.1% | 28.13 ± 0.3% | 19917.58 ± 1.2% | 29331.04 ± 3.4% | 17.39 ± 0.3% | 81.88 ± 0.1% | 21781.94 ± 3.0% | 4.43 | 1.00 | 1.10 | 0.75 |
| literal: one of four words | 661 | 6426.23 ± 0.3% | 1973.29 ± 0.3% | 14.40 ± 0.2% | 3946.11 ± 0.2% | 21.89 ± 0.3% | 5.30 ± 0.1% | 6.74 ± 0.3% | 6437.91 ± 0.4% | 3.26 | 1.00 | 1.63 | 293.55 |
| literal: a word in any case | 217 | 15181.27 ± 0.5% | 2105.59 ± 0.3% | 21.50 ± 0.3% | 3969.55 ± 0.3% | 38.03 ± 0.2% | refused | differs | 15222.31 ± 0.7% | 7.21 | 1.00 | 3.82 | 399.15 |
| literal: an href attribute | 33 | 16726.89 ± 0.7% | 617.70 ± 0.4% | 27.25 ± 0.3% | 16959.71 ± 0.8% | 2255.50 ± 7.8% | 13.44 ± 0.3% | 75.27 ± 0.2% | 16872.75 ± 1.3% | 27.08 | 0.99 | 0.99 | 7.42 |
| literal: a word, second text | 123 | 20120.48 ± 0.7% | 3424.86 ± 0.3% | 27.98 ± 0.4% | 18608.81 ± 1.8% | 7500.37 ± 4.5% | 19.42 ± 0.4% | 68.97 ± 0.4% | 20120.99 ± 0.9% | 5.87 | 1.00 | 1.08 | 2.68 |
| class: two capitalized words | 1331 | 1065.79 ± 0.8% | 609.59 ± 0.1% | 26.03 ± 0.3% | 582.17 ± 0.7% | 40.56 ± 0.8% | 15.07 ± 0.5% | 68.17 ± 0.2% | 1064.47 ± 0.5% | 1.75 | 1.00 | 1.83 | 26.28 |
| class: a word that ends in ing | 3399 | 582.76 ± 0.2% | 583.15 ± 0.3% | 17.99 ± 0.3% | 545.50 ± 0.2% | 29.67 ± 2.5% | 8.20 ± 0.1% | 18.24 ± 0.3% | 583.73 ± 0.2% | 1.00 | 1.00 | 1.07 | 19.64 |
| class: a word in capitals | 2332 | 1389.84 ± 0.2% | 614.38 ± 0.1% | 27.63 ± 0.4% | 572.70 ± 0.1% | 43.69 ± 0.2% | 17.26 ± 0.1% | 83.07 ± 0.3% | 1389.34 ± 0.4% | 2.26 | 1.00 | 2.43 | 31.81 |
| class: a number | 8288 | 2128.10 ± 0.5% | 853.36 ± 0.3% | 27.85 ± 0.5% | 1720.55 ± 0.1% | 42.29 ± 16.8% | 0.57 ± 0.3% | 56.83 ± 0.2% | 2130.54 ± 0.5% | 2.49 | 1.00 | 1.24 | 50.32 |
| class: two capitalized words, second text | 5359 | 525.55 ± 0.2% | 535.07 ± 0.2% | 23.32 ± 0.1% | 485.10 ± 0.1% | 35.14 ± 6.4% | 16.95 ± 0.3% | 63.40 ± 0.1% | 526.15 ± 0.1% | 0.98 | 1.00 | 1.08 | 14.96 |
| other: a word between two words | 6104 | 810.84 ± 0.1% | 609.08 ± 0.1% | 23.56 ± 0.3% | 737.16 ± 0.2% | 108.15 ± 15.0% | 11.44 ± 0.2% | 69.21 ± 0.5% | 808.79 ± 0.2% | 1.33 | 1.00 | 1.10 | 7.50 |
| other: a number before a unit, second text | 1481 | 6196.36 ± 1.2% | 1131.13 ± 0.2% | 25.94 ± 0.4% | 5455.98 ± 0.5% | 40.80 ± 15.5% | 17.91 ± 0.3% | 66.84 ± 0.2% | 6193.53 ± 1.0% | 5.48 | 1.00 | 1.14 | 151.89 |
| other: a heading's start tag | 110 | 14152.64 ± 0.4% | 750.68 ± 0.1% | 27.36 ± 0.3% | 1712.76 ± 0.4% | 1580.41 ± 5.4% | 16.33 ± 0.4% | 88.35 ± 0.2% | 14179.30 ± 0.6% | 18.85 | 1.00 | 8.26 | 8.96 |
| other: a whole word | 217 | 16271.69 ± 1.8% | 608.13 ± 0.4% | 29.33 ± 0.2% | 14607.51 ± 0.8% | 48.05 ± 0.3% | 13.77 ± 0.2% | 55.41 ± 0.6% | 16404.41 ± 0.8% | 26.76 | 0.99 | 1.11 | 338.63 |
| other: a line's first word, second text | 3716 | 2096.74 ± 0.7% | 600.09 ± 0.1% | 31.02 ± 0.1% | 1730.21 ± 0.2% | 62.27 ± 6.1% | refused | refused | 2103.30 ± 0.6% | 3.49 | 1.00 | 1.21 | 33.67 |
| other: fourteen octets before an x | 87 | 24437.82 ± 1.6% | 233.21 ± 0.4% | 6.55 ± 0.2% | 3958.89 ± 1.1% | 10.66 ± 0.1% | differs | 17.47 ± 0.3% | 24453.63 ± 8.0% | 104.79 | 1.00 | 6.17 | 2292.94 |
| other: a Greek word | 21815 | 519.94 ± 0.5% | 424.64 ± 0.2% | 30.83 ± 0.3% | 289.99 ± 0.5% | 44.87 ± 8.9% | differs | refused | 522.89 ± 0.8% | 1.22 | 0.99 | 1.79 | 11.59 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.28 ± 0.3% | 29.26 ± 0.2% | 0.86 ± 0.2% | 19.53 ± 0.4% | 2.77 ± 0.6% | differs | 4.01 ± 0.3% | 29.21 ± 0.5% | 1.00 | 1.00 | 1.50 | 10.58 |
| a UUID | 32895 | 24.70 ± 0.1% | 24.66 ± 0.1% | 0.64 ± 0.2% | 15.10 ± 0.6% | 3.10 ± 0.5% | 0.71 ± 0.4% | 3.60 ± 0.4% | 24.75 ± 0.1% | 1.00 | 1.00 | 1.64 | 7.96 |
| an IPv4 address | 33176 | 38.43 ± 0.5% | 38.42 ± 0.4% | 2.07 ± 0.2% | 28.99 ± 0.4% | 6.64 ± 0.1% | differs | 4.14 ± 0.3% | 38.42 ± 0.3% | 1.00 | 1.00 | 1.33 | 5.79 |
| a date and time | 32954 | 34.32 ± 0.0% | 34.06 ± 0.2% | 1.45 ± 0.6% | 21.39 ± 0.6% | 7.03 ± 0.1% | 1.17 ± 0.2% | 7.03 ± 0.1% | 34.29 ± 0.2% | 1.01 | 1.00 | 1.60 | 4.88 |
| a field path | 32606 | 32.54 ± 0.4% | 32.57 ± 0.4% | 1.01 ± 0.2% | 23.14 ± 0.4% | 3.49 ± 0.8% | differs | 2.92 ± 0.1% | 32.57 ± 0.1% | 1.00 | 1.00 | 1.41 | 9.31 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.13 ± 0.2% | 11.05 ± 0.3% | 11.11 ± 0.4% | 11.48 ± 0.1% | 4.94 ± 1.6% | 0.90 ± 0.8% | none | 11.08 ± 0.2% | 1.01 | 1.00 | 0.97 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 220.87 ± 0.2% | 221.02 ± 0.1% | 257.90 ± 0.5% | 87.40 ± 0.3% | 220.91 ± 2.7% | 478.53 ± 1.6% | 3727.29 ± 0.8% | 220.89 ± 0.2% | 1.00 | 1.00 | 2.53 | 1.00 |
| a UUID | 62 | 144.18 ± 0.3% | 144.26 ± 0.2% | 159.54 ± 0.3% | 46.03 ± 0.4% | 99.02 ± 4.4% | 180.43 ± 0.6% | 4450.70 ± 0.4% | 144.07 ± 0.2% | 1.00 | 1.00 | 3.13 | 1.46 |
| an IPv4 address | 29 | 417.09 ± 0.4% | 416.96 ± 0.5% | 575.24 ± 0.5% | 77.32 ± 1.2% | 130.38 ± 1.4% | 290.82 ± 0.4% | 7585.60 ± 0.0% | 415.98 ± 0.5% | 1.00 | 1.00 | 5.39 | 3.20 |
| a date and time | 56 | 301.58 ± 0.1% | 301.75 ± 0.3% | 375.49 ± 0.4% | 72.71 ± 0.7% | 136.61 ± 1.3% | 314.96 ± 3.2% | 4935.15 ± 0.3% | 301.63 ± 0.2% | 1.00 | 1.00 | 4.15 | 2.21 |
| a field path | 39 | 212.19 ± 0.3% | 212.28 ± 0.3% | 246.36 ± 0.3% | 79.52 ± 0.2% | 205.85 ± 0.7% | 493.01 ± 1.5% | 4817.75 ± 2.8% | 212.14 ± 0.1% | 1.00 | 1.00 | 2.67 | 1.03 |
| literal: a word | 7 | 617.02 ± 0.5% | 668.59 ± 0.4% | 1179.11 ± 0.3% | 522.18 ± 0.2% | 628.30 ± 1.7% | 919.16 ± 0.6% | 29690.51 ± 0.2% | 617.53 ± 0.6% | 0.92 | 1.00 | 1.18 | 0.98 |
| literal: a word that is not there | 8 | 594.88 ± 0.2% | 653.52 ± 0.4% | 1114.67 ± 0.6% | 469.10 ± 0.2% | 603.57 ± 2.1% | 870.06 ± 0.4% | 28545.89 ± 0.2% | 595.46 ± 0.5% | 0.91 | 1.00 | 1.27 | 0.99 |
| literal: one of four words | 26 | 245.27 ± 0.2% | 393.05 ± 0.4% | 526.11 ± 0.3% | 49.43 ± 1.3% | 241.95 ± 2.8% | 352.35 ± 2.6% | 15432.48 ± 0.4% | 245.57 ± 0.2% | 0.62 | 1.00 | 4.96 | 1.01 |
| literal: a word in any case | 11 | 444.96 ± 0.4% | 476.05 ± 0.2% | 693.80 ± 0.0% | 15.70 ± 0.4% | 664.29 ± 3.1% | refused | 23263.43 ± 0.2% | 445.04 ± 0.1% | 0.93 | 1.00 | 28.34 | 0.67 |
| literal: an href attribute | 12 | 331.61 ± 0.2% | 342.66 ± 0.4% | 442.40 ± 0.6% | 44.96 ± 1.0% | 499.57 ± 2.6% | 768.07 ± 0.5% | 21505.87 ± 0.3% | 331.18 ± 0.4% | 0.97 | 1.00 | 7.38 | 0.66 |
| literal: a word, second text | 10 | 552.70 ± 0.6% | 613.77 ± 0.7% | 1007.53 ± 0.9% | 413.98 ± 3.8% | 537.56 ± 2.2% | 788.52 ± 1.0% | 26355.25 ± 0.1% | 552.86 ± 0.7% | 0.90 | 1.00 | 1.34 | 1.03 |
| class: two capitalized words | 23 | 435.87 ± 0.7% | 463.26 ± 0.6% | 661.68 ± 0.8% | 101.57 ± 0.2% | 501.39 ± 2.9% | 736.13 ± 0.9% | 6333.73 ± 0.1% | 434.60 ± 0.5% | 0.94 | 1.00 | 4.29 | 0.87 |
| class: a word that ends in ing | 9 | 548.37 ± 0.3% | 616.36 ± 0.2% | 1054.79 ± 0.3% | 133.40 ± 0.6% | 757.20 ± 0.7% | 1092.97 ± 0.7% | 15683.68 ± 0.1% | 548.00 ± 0.6% | 0.89 | 1.00 | 4.11 | 0.72 |
| class: a word in capitals | 16 | 493.16 ± 0.1% | 529.04 ± 0.1% | 829.70 ± 0.1% | 137.00 ± 1.2% | 751.70 ± 0.6% | 1009.04 ± 0.6% | 8326.56 ± 0.1% | 492.71 ± 0.3% | 0.93 | 1.00 | 3.60 | 0.66 |
| class: a number | 6 | 627.84 ± 0.2% | 686.58 ± 0.4% | 1261.79 ± 0.1% | 41.92 ± 0.9% | 1399.47 ± 0.9% | 1870.27 ± 1.1% | 22432.43 ± 0.1% | 627.26 ± 0.4% | 0.91 | 1.00 | 14.98 | 0.45 |
| class: two capitalized words, second text | 23 | 436.30 ± 0.2% | 463.66 ± 0.5% | 660.84 ± 0.2% | 101.33 ± 2.1% | 501.76 ± 0.9% | 761.45 ± 0.8% | 6333.36 ± 0.2% | 434.95 ± 0.5% | 0.94 | 1.00 | 4.31 | 0.87 |
| other: a word between two words | 13 | 531.34 ± 0.3% | 553.17 ± 0.3% | 867.06 ± 0.1% | 136.32 ± 0.6% | 503.05 ± 1.3% | 809.53 ± 1.2% | 14550.03 ± 0.0% | 531.71 ± 0.6% | 0.96 | 1.00 | 3.90 | 1.06 |
| other: a number before a unit, second text | 15 | 383.75 ± 0.1% | 423.62 ± 0.2% | 584.61 ± 0.7% | 39.68 ± 1.1% | 626.56 ± 1.5% | 885.38 ± 0.7% | 15087.24 ± 0.1% | 383.54 ± 0.2% | 0.91 | 1.00 | 9.67 | 0.61 |
| other: a heading's start tag | 13 | 341.33 ± 0.4% | 348.41 ± 0.4% | 451.65 ± 0.4% | 43.19 ± 0.7% | 629.78 ± 0.5% | 860.92 ± 0.5% | 17839.00 ± 0.1% | 341.35 ± 0.3% | 0.98 | 1.00 | 7.90 | 0.54 |
| other: a whole word | 11 | 570.30 ± 0.2% | 612.34 ± 0.3% | 1003.09 ± 0.1% | 120.57 ± 1.2% | 562.10 ± 1.8% | 826.82 ± 0.1% | 26217.31 ± 0.3% | 569.09 ± 0.5% | 0.93 | 1.00 | 4.73 | 1.01 |
| other: a line's first word, second text | 17 | 516.67 ± 0.5% | 545.57 ± 0.3% | 861.96 ± 0.2% | 129.70 ± 0.6% | 708.10 ± 1.2% | refused | refused | 515.99 ± 1.0% | 0.95 | 1.00 | 3.98 | 0.73 |
| other: fourteen octets before an x | 16 | 106.90 ± 0.5% | 152.46 ± 0.4% | 173.05 ± 0.6% | 15.22 ± 0.2% | 457.61 ± 2.1% | 409.73 ± 0.4% | 12598.02 ± 0.2% | 107.15 ± 0.4% | 0.70 | 1.00 | 7.02 | 0.23 |
| other: a Greek word | 8 | 439.85 ± 0.3% | 573.34 ± 0.3% | 935.28 ± 0.1% | 59.14 ± 1.0% | 1376.15 ± 8.5% | 1829.59 ± 0.6% | refused | 440.18 ± 0.5% | 0.77 | 1.00 | 7.44 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15602.20 ± 1.5% | not timed | not timed | 16066.49 ± 1.5% | 1929.60 ± 22.3% | not timed | not timed | 15506.70 ± 0.8% | | 1.01 | 0.97 | 8.09 |
| 01-literal/sherlock-casei-en | 522 | 11020.64 ± 3.8% | not timed | not timed | 3588.62 ± 0.2% | 31.80 ± 2.0% | not timed | not timed | 11048.27 ± 2.3% | | 1.00 | 3.07 | 346.56 |
| 01-literal/sherlock-ru | 724 | 17142.01 ± 1.1% | not timed | not timed | 17313.81 ± 0.2% | 1520.69 ± 20.3% | not timed | not timed | 17197.39 ± 0.4% | | 1.00 | 0.99 | 11.27 |
| 01-literal/sherlock-casei-ru | 746 | 6155.48 ± 0.3% | not timed | not timed | 3329.57 ± 0.1% | 31.73 ± 0.5% | not timed | not timed | 6144.36 ± 0.1% | | 1.00 | 1.85 | 194.00 |
| 01-literal/sherlock-zh | 30 | 19579.68 ± 1.0% | not timed | not timed | 18432.22 ± 1.3% | 2721.43 ± 12.2% | not timed | not timed | 19598.59 ± 1.2% | | 1.00 | 1.06 | 7.19 |
| 02-literal-alternate/sherlock-en | 714 | 6139.88 ± 0.5% | not timed | not timed | 3932.02 ± 0.3% | 16.59 ± 0.2% | not timed | not timed | 6145.45 ± 0.3% | | 1.00 | 1.56 | 370.13 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1972.61 ± 1.6% | not timed | not timed | 697.92 ± 0.2% | 11.12 ± 0.1% | not timed | not timed | 1975.83 ± 0.8% | | 1.00 | 2.83 | 177.35 |
| 02-literal-alternate/sherlock-ru | 899 | 5533.52 ± 0.3% | not timed | not timed | 3251.97 ± 0.1% | 22.19 ± 0.4% | not timed | not timed | 5521.48 ± 0.2% | | 1.00 | 1.70 | 249.39 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2056.76 ± 0.4% | not timed | not timed | 1226.46 ± 0.1% | 9.14 ± 0.6% | not timed | not timed | 2052.90 ± 0.6% | | 1.00 | 1.68 | 225.00 |
| 02-literal-alternate/sherlock-zh | 207 | 7320.82 ± 0.5% | not timed | not timed | 4164.24 ± 0.2% | 31.46 ± 0.1% | not timed | not timed | 7324.85 ± 0.4% | | 1.00 | 1.76 | 232.68 |
| 03-date/ascii | 111817 | 132.97 ± 1.4% | not timed | not timed | 95.50 ± 0.1% | 0.20 ± 3.0% | not timed | not timed | 133.86 ± 0.7% | | 0.99 | 1.39 | 663.44 |
| 04-ruff-noqa/real | 84 | 436.00 ± 0.1% | not timed | not timed | 465.03 ± 0.2% | 19.57 ± 1.3% | not timed | not timed | 436.03 ± 0.3% | | 1.00 | 0.94 | 22.27 |
| 04-ruff-noqa/tweaked | 44 | 593.57 ± 0.4% | not timed | not timed | 459.34 ± 0.1% | 364.62 ± 0.5% | not timed | not timed | 595.61 ± 0.4% | | 1.00 | 1.29 | 1.63 |
| 05-lexer-veryl/single | 124800 | 5.35 ± 0.5% | not timed | not timed | 4.92 ± 0.1% | 0.20 ± 4.6% | not timed | not timed | 5.51 ± 0.3% | | 0.97 | 1.09 | 26.62 |
| 06-cloud-flare-redos/original | 107 | 423.20 ± 0.2% | not timed | not timed | 214.62 ± 0.1% | 24.87 ± 0.2% | not timed | not timed | 428.81 ± 0.2% | | 0.99 | 1.97 | 17.02 |
| 06-cloud-flare-redos/simplified-short | 102 | 429.17 ± 0.4% | not timed | not timed | 227.37 ± 0.1% | 26.68 ± 0.4% | not timed | not timed | 428.82 ± 0.2% | | 1.00 | 1.89 | 16.09 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.19 ± 0.2% | not timed | not timed | 254.69 ± 0.2% | 28.83 ± 0.1% | not timed | not timed | 588.52 ± 0.1% | | 1.00 | 2.31 | 20.40 |
| 07-unicode-character-data/parse-line | 558784 | 233.87 ± 2.2% | not timed | not timed | 172.35 ± 0.1% | 42.66 ± 5.0% | not timed | not timed | 232.67 ± 0.9% | | 1.01 | 1.36 | 5.48 |
| 08-words/all-english | 56691 | 127.71 ± 1.1% | not timed | not timed | 82.91 ± 0.1% | 12.50 ± 19.5% | not timed | not timed | 127.81 ± 0.5% | | 1.00 | 1.54 | 10.22 |
| 08-words/long-english | 839 | 622.25 ± 0.1% | not timed | not timed | 593.57 ± 0.1% | 32.42 ± 0.3% | not timed | not timed | 623.40 ± 0.2% | | 1.00 | 1.05 | 19.19 |
| 09-aws-keys/full | 0 | 440.66 ± 0.2% | not timed | not timed | 458.25 ± 0.1% | 64.55 ± 3.4% | not timed | not timed | 439.31 ± 0.2% | | 1.00 | 0.96 | 6.83 |
| 09-aws-keys/quick | 0 | 875.01 ± 0.3% | not timed | not timed | 991.03 ± 0.2% | 416.65 ± 1.5% | not timed | not timed | 874.28 ± 0.2% | | 1.00 | 0.88 | 2.10 |
| 10-bounded-repeat/letters-en | 1833 | 577.00 ± 2.7% | not timed | not timed | 517.93 ± 0.4% | 19.23 ± 0.3% | not timed | not timed | 576.63 ± 3.3% | | 1.00 | 1.11 | 30.00 |
| 10-bounded-repeat/letters-ru | 3475 | 505.88 ± 1.2% | not timed | not timed | 477.97 ± 0.6% | 21.83 ± 17.8% | not timed | not timed | 506.99 ± 1.0% | | 1.00 | 1.06 | 23.17 |
| 10-bounded-repeat/context | 53 | 84.70 ± 1.9% | not timed | not timed | 65.73 ± 0.4% | 19.81 ± 0.1% | not timed | not timed | 85.23 ± 1.7% | | 0.99 | 1.29 | 4.27 |
| 10-bounded-repeat/capitals | 11 | 633.14 ± 8.3% | not timed | not timed | 618.56 ± 0.0% | 36.58 ± 0.1% | not timed | not timed | 632.45 ± 8.1% | | 1.00 | 1.02 | 17.31 |
| 11-unstructured-to-json/extract | 600 | 56.76 ± 1.1% | not timed | not timed | 76.97 ± 0.2% | 49.27 ± 1.4% | not timed | not timed | 57.27 ± 1.1% | | 0.99 | 0.74 | 1.15 |
| 12-dictionary/single | 1 | 560.55 ± 1.1% | not timed | not timed | 558.78 ± 0.2% | 0.41 ± 0.1% | not timed | not timed | 561.03 ± 0.7% | | 1.00 | 1.00 | 1380.57 |
| 14-quadratic/1x | 100 | 21.33 ± 1.4% | not timed | not timed | 10.00 ± 0.2% | 0.98 ± 3.3% | not timed | not timed | 21.48 ± 1.4% | | 0.99 | 2.13 | 21.66 |
| 14-quadratic/2x | 200 | 17.77 ± 1.4% | not timed | not timed | 5.52 ± 0.3% | 0.53 ± 1.9% | not timed | not timed | 17.90 ± 0.9% | | 0.99 | 3.22 | 33.48 |
| 14-quadratic/10x | 1000 | 7.77 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 7.77 ± 0.5% | | 1.00 | 6.41 | 67.27 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.22 ± 1.7% | not timed | not timed | 0.34 ± 0.8% | 0.55 ± 2.0% | not timed | not timed | 1.22 ± 0.5% | | 1.00 | 3.56 | 2.23 |
| 04-ruff-noqa/compile-real | 1 | 106.24 ± 1.7% | not timed | not timed | 13.78 ± 0.5% | 137.48 ± 2.3% | not timed | not timed | 106.51 ± 1.3% | | 1.00 | 7.71 | 0.77 |
| 05-lexer-veryl/compile-single | 1 | 14.04 ± 1.1% | not timed | not timed | 2.51 ± 0.7% | 6.45 ± 2.8% | not timed | not timed | 14.05 ± 2.0% | | 1.00 | 5.59 | 2.18 |
| 07-unicode-character-data/compile | 1 | 108.03 ± 0.4% | not timed | not timed | 25.85 ± 0.2% | 35.91 ± 2.8% | not timed | not timed | 108.08 ± 0.9% | | 1.00 | 4.18 | 3.01 |
| 09-aws-keys/compile-full | 1 | 53.21 ± 0.3% | not timed | not timed | 8.28 ± 0.6% | 23.35 ± 0.9% | not timed | not timed | 53.18 ± 1.1% | | 1.00 | 6.43 | 2.28 |
| 09-aws-keys/compile-quick | 1 | 186.80 ± 1.2% | not timed | not timed | 47.55 ± 0.1% | 133.63 ± 2.5% | not timed | not timed | 187.50 ± 0.2% | | 1.00 | 3.93 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 71.83 ± 1.2% | not timed | not timed | 11.12 ± 0.2% | 16.01 ± 1.4% | not timed | not timed | 72.13 ± 0.2% | | 1.00 | 6.46 | 4.49 |
| 10-bounded-repeat/compile-capitals | 1 | 85.02 ± 0.9% | not timed | not timed | 8.06 ± 0.3% | 23.73 ± 2.3% | not timed | not timed | 84.99 ± 0.6% | | 1.00 | 10.55 | 3.58 |
| 11-unstructured-to-json/compile | 1 | 170.39 ± 0.6% | not timed | not timed | 41.40 ± 0.6% | 67.29 ± 3.9% | not timed | not timed | 170.70 ± 0.4% | | 1.00 | 4.12 | 2.53 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.9% | not timed | not timed | 0.07 ± 2.6% | 0.09 ± 17.0% | not timed | not timed | 0.35 ± 3.0% | | 0.99 | 4.99 | 3.73 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.36 ± 5.3% | not timed | not timed | 6.49 ± 1.4% | 0.56 ± 20.9% | not timed | not timed | 7.38 ± 0.5% | | 1.00 | 1.13 | 13.06 |
| dictionary/search/english-10 | 690 | 1.16 ± 0.3% | not timed | not timed | 164.29 ± 0.7% | 0.00 ± 0.2% | not timed | not timed | 1.16 ± 0.4% | | 1.00 | 0.0071 | 427.97 |
| dictionary/search/english-15 | 15 | 565.74 ± 1.0% | not timed | not timed | 561.61 ± 0.2% | 0.37 ± 0.2% | not timed | not timed | 566.44 ± 1.0% | | 1.00 | 1.01 | 1537.04 |
| folly/awyer-inn-busted | 1 | 5592.67 ± 0.2% | not timed | not timed | 141.87 ± 0.1% | 44.08 ± 0.1% | not timed | not timed | 5610.02 ± 0.3% | | 1.00 | 39.42 | 126.89 |
| folly/literal-never-match-rare | 0 | 21060.56 ± 0.9% | not timed | not timed | 19871.31 ± 0.5% | 40895.25 ± 0.6% | not timed | not timed | 21065.49 ± 0.3% | | 1.00 | 1.06 | 0.51 |
| folly/literal-never-match-frequent | 0 | 12481.39 ± 1.6% | not timed | not timed | 19841.38 ± 0.4% | 2194.99 ± 1.0% | not timed | not timed | 12514.33 ± 1.0% | | 1.00 | 0.63 | 5.69 |
| folly/literal-never-match-tricksy | 1 | 3242.69 ± 0.5% | not timed | not timed | 4406.77 ± 0.3% | 3054.44 ± 0.6% | not timed | not timed | 3243.29 ± 0.5% | | 1.00 | 0.74 | 1.06 |
| grep/every-line | 239963 | 1318.70 ± 0.5% | not timed | not timed | 945.35 ± 0.3% | 385.32 ± 18.5% | not timed | not timed | 1324.08 ± 0.5% | | 1.00 | 1.39 | 3.42 |
| grep/long-words-ascii | 5073 | 459.14 ± 0.1% | not timed | not timed | 467.12 ± 0.1% | 46.29 ± 6.9% | not timed | not timed | 458.78 ± 0.3% | | 1.00 | 0.98 | 9.92 |
| imported/leipzig/twain | 811 | 20578.64 ± 1.3% | not timed | not timed | 19547.64 ± 0.6% | 11964.27 ± 10.4% | not timed | not timed | 20749.39 ± 0.9% | | 0.99 | 1.05 | 1.72 |
| imported/leipzig/twain-insensitive | 965 | 9065.56 ± 0.7% | not timed | not timed | 4247.55 ± 0.2% | 37.82 ± 0.3% | not timed | not timed | 9092.46 ± 0.6% | | 1.00 | 2.13 | 239.73 |
| imported/leipzig/shing | 1540 | 15210.76 ± 2.1% | not timed | not timed | 13529.04 ± 0.3% | 34.00 ± 0.1% | not timed | not timed | 15488.83 ± 1.7% | | 0.98 | 1.12 | 447.41 |
| imported/leipzig/huck-saw | 262 | 8222.12 ± 3.2% | not timed | not timed | 5588.99 ± 0.8% | 31.95 ± 0.3% | not timed | not timed | 8315.22 ± 2.3% | | 0.99 | 1.47 | 257.37 |
| imported/leipzig/word-ending-nn | 262 | 605.21 ± 0.6% | not timed | not timed | 616.76 ± 0.3% | 24.69 ± 0.5% | not timed | not timed | 604.82 ± 0.2% | | 1.00 | 0.98 | 24.51 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11143.11 ± 0.6% | not timed | not timed | 4509.17 ± 0.9% | 11.48 ± 0.1% | not timed | not timed | 11194.53 ± 1.1% | | 1.00 | 2.47 | 970.53 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7796.23 ± 2.2% | not timed | not timed | 5483.16 ± 0.2% | 16.85 ± 0.1% | not timed | not timed | 7923.46 ± 2.7% | | 0.98 | 1.42 | 462.74 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4181.37 ± 1.4% | not timed | not timed | 410.63 ± 0.5% | 11.12 ± 0.1% | not timed | not timed | 4182.66 ± 1.1% | | 1.00 | 10.18 | 375.94 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 601.88 ± 0.5% | not timed | not timed | 614.71 ± 0.2% | 11.13 ± 0.1% | not timed | not timed | 603.34 ± 0.7% | | 1.00 | 0.98 | 54.09 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 603.35 ± 0.3% | not timed | not timed | 615.98 ± 0.1% | 9.68 ± 0.1% | not timed | not timed | 603.23 ± 0.3% | | 1.00 | 0.98 | 62.33 |
| imported/leipzig/tom-river | 2 | 6488.86 ± 2.2% | not timed | not timed | 5145.12 ± 0.3% | 30.95 ± 0.1% | not timed | not timed | 6612.13 ± 1.7% | | 0.98 | 1.26 | 209.66 |
| imported/leipzig/ing | 78424 | 600.71 ± 0.6% | not timed | not timed | 570.48 ± 0.2% | 28.15 ± 3.4% | not timed | not timed | 601.44 ± 0.6% | | 1.00 | 1.05 | 21.34 |
| imported/leipzig/ing-whitespace | 55248 | 750.86 ± 1.0% | not timed | not timed | 2080.60 ± 0.6% | 20.55 ± 2.9% | not timed | not timed | 753.34 ± 0.4% | | 1.00 | 0.36 | 36.54 |
| imported/leipzig/awyer-inn | 209 | 768.81 ± 1.7% | not timed | not timed | 4227.61 ± 1.3% | 22.60 ± 0.0% | not timed | not timed | 767.14 ± 1.3% | | 1.00 | 0.18 | 34.01 |
| imported/leipzig/quotes-bounded | 8886 | 2119.45 ± 0.4% | not timed | not timed | 3016.24 ± 0.8% | 38.27 ± 0.2% | not timed | not timed | 2129.51 ± 0.7% | | 1.00 | 0.70 | 55.38 |
| imported/leipzig/non-ascii-alternate | 2 | 12831.47 ± 2.6% | not timed | not timed | 5670.78 ± 0.1% | 50.57 ± 0.1% | not timed | not timed | 13054.96 ± 2.4% | | 0.98 | 2.26 | 253.75 |
| imported/leipzig/math-symbols | 69 | 1983.69 ± 1.9% | not timed | not timed | 613.62 ± 0.1% | 36.65 ± 0.3% | not timed | not timed | 1992.13 ± 0.6% | | 1.00 | 3.23 | 54.12 |
| imported/leipzig/bounded-strings-ending-z | 0 | 585.34 ± 0.9% | not timed | not timed | 614.79 ± 0.2% | 22.41 ± 0.5% | not timed | not timed | 585.65 ± 1.0% | | 1.00 | 0.95 | 26.12 |
| imported/lh3lh3-reb/uri | 17549 | 679.57 ± 0.2% | not timed | not timed | 1063.50 ± 0.1% | 26.95 ± 2.1% | not timed | not timed | 679.17 ± 0.4% | | 1.00 | 0.64 | 25.21 |
| imported/lh3lh3-reb/email | 15057 | 673.68 ± 0.1% | not timed | not timed | 1156.21 ± 0.2% | 30.87 ± 2.4% | not timed | not timed | 673.58 ± 0.1% | | 1.00 | 0.58 | 21.82 |
| imported/lh3lh3-reb/date | 668 | 860.58 ± 0.3% | not timed | not timed | 1031.45 ± 0.2% | 51.21 ± 3.9% | not timed | not timed | 860.95 ± 0.2% | | 1.00 | 0.83 | 16.81 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 646.38 ± 0.2% | not timed | not timed | 421.77 ± 0.1% | 15.81 ± 1.4% | not timed | not timed | 645.36 ± 0.2% | | 1.00 | 1.53 | 40.89 |
| imported/mariomka/email | 92 | 24316.25 ± 1.4% | not timed | not timed | 29518.63 ± 0.5% | 32.84 ± 0.2% | not timed | not timed | 24327.07 ± 1.2% | | 1.00 | 0.82 | 740.52 |
| imported/mariomka/uri | 5301 | 5344.23 ± 0.8% | not timed | not timed | 6125.32 ± 0.2% | 32.68 ± 0.3% | not timed | not timed | 5381.36 ± 0.6% | | 0.99 | 0.87 | 163.54 |
| imported/mariomka/ip | 5 | 2154.33 ± 2.0% | not timed | not timed | 2969.07 ± 0.2% | 21.08 ± 0.1% | not timed | not timed | 2152.68 ± 2.2% | | 1.00 | 0.73 | 102.22 |
| imported/rsc/no-exponential | 0 | 602.01 ± 0.1% | not timed | not timed | 321.41 ± 0.1% | 23.89 ± 0.3% | not timed | not timed | 597.31 ± 0.1% | | 1.01 | 1.87 | 25.19 |
| imported/rsc/literal | 1 | 759.14 ± 1.9% | not timed | not timed | 1629.79 ± 3.6% | 188.12 ± 17.1% | not timed | not timed | 759.01 ± 5.7% | | 1.00 | 0.47 | 4.04 |
| imported/rsc/not-literal | 2 | 775.14 ± 0.2% | not timed | not timed | 731.66 ± 0.1% | 46.42 ± 10.0% | not timed | not timed | 778.79 ± 2.7% | | 1.00 | 1.06 | 16.70 |
| imported/rsc/match-class | 1 | 1417.37 ± 0.3% | not timed | not timed | 1601.21 ± 0.3% | 58.97 ± 13.7% | not timed | not timed | 1416.47 ± 2.4% | | 1.00 | 0.89 | 24.03 |
| imported/rsc/match-class-in-range | 1 | 1428.42 ± 0.3% | not timed | not timed | 2326.17 ± 4.0% | 60.04 ± 7.5% | not timed | not timed | 1415.09 ± 2.3% | | 1.01 | 0.61 | 23.79 |
| imported/rsc/match-class-unicode | 1 | 541.65 ± 0.2% | not timed | not timed | 513.91 ± 0.1% | 72.82 ± 0.2% | not timed | not timed | 540.75 ± 0.1% | | 1.00 | 1.05 | 7.44 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1308.83 ± 0.1% | not timed | not timed | 948.29 ± 0.1% | 228.72 ± 0.6% | not timed | not timed | 1433.68 ± 0.2% | | 0.91 | 1.38 | 5.72 |
| imported/rsc/anchored-literal-long-non-match | 0 | 19640.63 ± 0.1% | not timed | not timed | 14162.05 ± 0.0% | 3430.64 ± 0.8% | not timed | not timed | 21479.58 ± 0.2% | | 0.91 | 1.39 | 5.73 |
| imported/rsc/anchored-literal-short-match | 4 | 661.07 ± 1.8% | not timed | not timed | 489.54 ± 0.2% | 82.28 ± 4.4% | not timed | not timed | 703.50 ± 5.9% | | 0.94 | 1.35 | 8.03 |
| imported/rsc/anchored-literal-long-match | 4 | 9968.81 ± 1.8% | not timed | not timed | 7319.15 ± 0.3% | 1236.83 ± 7.4% | not timed | not timed | 10581.03 ± 1.6% | | 0.94 | 1.36 | 8.06 |
| imported/rsc/one-pass-short | 17 | 348.46 ± 2.0% | not timed | not timed | 214.04 ± 0.1% | 31.58 ± 10.2% | not timed | not timed | 364.62 ± 12.8% | | 0.96 | 1.63 | 11.04 |
| imported/rsc/one-pass-short-not | 17 | 280.83 ± 2.3% | not timed | not timed | 226.02 ± 0.2% | 29.39 ± 11.9% | not timed | not timed | 280.41 ± 2.4% | | 1.00 | 1.24 | 9.56 |
| imported/rsc/one-pass-long-prefix | 26 | 348.67 ± 1.9% | not timed | not timed | 281.90 ± 0.1% | 98.62 ± 18.6% | not timed | not timed | 359.90 ± 0.2% | | 0.97 | 1.24 | 3.54 |
| imported/rsc/one-pass-long-prefix-not | 26 | 347.52 ± 1.7% | not timed | not timed | 281.69 ± 0.4% | 65.82 ± 12.8% | not timed | not timed | 358.40 ± 2.1% | | 0.97 | 1.23 | 5.28 |
| imported/rsc/long-needle1 | 31 | 22199.89 ± 0.1% | not timed | not timed | 20121.38 ± 0.1% | 3.77 ± 0.1% | not timed | not timed | 22205.14 ± 0.1% | | 1.00 | 1.10 | 5896.06 |
| imported/rsc/long-needle2 | 31 | 22315.46 ± 0.1% | not timed | not timed | 216.64 ± 0.2% | 3.76 ± 0.2% | not timed | not timed | 22321.05 ± 0.2% | | 1.00 | 103.01 | 5931.51 |
| imported/rsc/easy0-32 | 26 | 1065.83 ± 3.0% | not timed | not timed | 1613.79 ± 2.1% | 148.51 ± 19.9% | not timed | not timed | 1068.55 ± 0.3% | | 1.00 | 0.66 | 7.18 |
| imported/rsc/easy0-1k | 26 | 14947.82 ± 0.2% | not timed | not timed | 12682.37 ± 0.6% | 2296.62 ± 18.7% | not timed | not timed | 14943.96 ± 0.2% | | 1.00 | 1.18 | 6.51 |
| imported/rsc/easy0-32k | 26 | 22980.65 ± 1.7% | not timed | not timed | 20297.24 ± 0.1% | 18844.36 ± 31.2% | not timed | not timed | 22979.64 ± 0.4% | | 1.00 | 1.13 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21525.40 ± 2.4% | not timed | not timed | 19464.75 ± 1.4% | 35760.04 ± 5.6% | not timed | not timed | 21428.50 ± 0.8% | | 1.00 | 1.11 | 0.60 |
| imported/rsc/easy1-32 | 19 | 806.11 ± 8.5% | not timed | not timed | 644.09 ± 0.3% | 137.51 ± 19.2% | not timed | not timed | 802.97 ± 2.0% | | 1.00 | 1.25 | 5.86 |
| imported/rsc/easy1-1k | 19 | 16471.29 ± 2.5% | not timed | not timed | 13006.06 ± 0.9% | 2491.63 ± 17.1% | not timed | not timed | 16428.16 ± 0.3% | | 1.00 | 1.27 | 6.61 |
| imported/rsc/easy1-32k | 19 | 516986.62 ± 2.4% | not timed | not timed | 402969.26 ± 0.3% | 20498.12 ± 29.0% | not timed | not timed | 505188.05 ± 0.1% | | 1.02 | 1.28 | 25.22 |
| imported/rsc/easy1-1mb | 19 | 16557382.97 ± 0.2% | not timed | not timed | 13144534.46 ± 0.1% | 37781.23 ± 2.2% | not timed | not timed | 16517181.22 ± 0.6% | | 1.00 | 1.26 | 438.24 |
| imported/rsc/medium-32 | 27 | 768.32 ± 6.9% | not timed | not timed | 639.52 ± 0.1% | 69.93 ± 3.9% | not timed | not timed | 774.05 ± 0.3% | | 0.99 | 1.20 | 10.99 |
| imported/rsc/medium-1k | 27 | 13679.43 ± 0.4% | not timed | not timed | 11417.68 ± 0.2% | 72.12 ± 0.1% | not timed | not timed | 13770.40 ± 0.5% | | 0.99 | 1.20 | 189.67 |
| imported/rsc/medium-32k | 27 | 426519.51 ± 0.6% | not timed | not timed | 359117.97 ± 0.3% | 48.66 ± 0.1% | not timed | not timed | 429721.75 ± 0.3% | | 0.99 | 1.19 | 8765.50 |
| imported/rsc/medium-1mb | 27 | 13638255.64 ± 0.4% | not timed | not timed | 11299418.17 ± 0.1% | 48.70 ± 0.2% | not timed | not timed | 13761831.67 ± 0.3% | | 0.99 | 1.21 | 280060.22 |
| imported/rsc/hard-32 | 58 | 421.08 ± 1.9% | not timed | not timed | 367.05 ± 0.1% | 49.64 ± 7.1% | not timed | not timed | 418.72 ± 0.3% | | 1.01 | 1.15 | 8.48 |
| imported/rsc/hard-1k | 27 | 13387.65 ± 0.6% | not timed | not timed | 11567.54 ± 0.1% | 40.82 ± 0.4% | not timed | not timed | 13375.37 ± 0.6% | | 1.00 | 1.16 | 327.97 |
| imported/rsc/hard-32k | 27 | 415458.69 ± 0.5% | not timed | not timed | 363957.91 ± 0.5% | 29.38 ± 0.1% | not timed | not timed | 417057.61 ± 0.6% | | 1.00 | 1.14 | 14141.03 |
| imported/rsc/hard-1mb | 51 | 8419380.76 ± 0.3% | not timed | not timed | 7235565.22 ± 0.1% | 29.39 ± 0.1% | not timed | not timed | 8343342.43 ± 0.2% | | 1.01 | 1.16 | 286442.20 |
| imported/rsc/reallyhard0-32 | 58 | 264.67 ± 2.3% | not timed | not timed | 224.53 ± 0.1% | 49.76 ± 8.9% | not timed | not timed | 264.65 ± 0.1% | | 1.00 | 1.18 | 5.32 |
| imported/rsc/reallyhard0-1k | 27 | 591.72 ± 0.3% | not timed | not timed | 583.90 ± 0.1% | 40.77 ± 0.1% | not timed | not timed | 590.04 ± 0.1% | | 1.00 | 1.01 | 14.51 |
| imported/rsc/reallyhard0-32k | 27 | 611.18 ± 0.1% | not timed | not timed | 618.08 ± 0.1% | 29.37 ± 0.1% | not timed | not timed | 610.70 ± 0.2% | | 1.00 | 0.99 | 20.81 |
| imported/rsc/reallyhard0-1mb | 51 | 590.80 ± 1.4% | not timed | not timed | 618.64 ± 0.2% | 29.35 ± 0.2% | not timed | not timed | 591.35 ± 1.7% | | 1.00 | 0.96 | 20.13 |
| imported/rsc/reallyreallyhard0-32 | 47 | 286.32 ± 1.8% | not timed | not timed | 195.95 ± 1.0% | 60.92 ± 15.9% | not timed | not timed | 286.63 ± 1.6% | | 1.00 | 1.46 | 4.70 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6747.04 ± 0.4% | not timed | not timed | 5950.25 ± 0.1% | 34.38 ± 1.1% | not timed | not timed | 6766.97 ± 0.1% | | 1.00 | 1.13 | 196.24 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21461.88 ± 0.1% | not timed | not timed | 19254.00 ± 0.1% | 24.75 ± 1.5% | not timed | not timed | 21472.32 ± 0.2% | | 1.00 | 1.11 | 867.15 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21490.25 ± 1.8% | not timed | not timed | 19602.78 ± 1.2% | 24.69 ± 1.7% | not timed | not timed | 21569.60 ± 1.9% | | 1.00 | 1.10 | 870.44 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 280.65 ± 1.7% | not timed | not timed | 214.04 ± 0.3% | 60.50 ± 10.3% | not timed | not timed | 280.65 ± 1.4% | | 1.00 | 1.31 | 4.64 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5888.56 ± 0.2% | not timed | not timed | 6255.22 ± 0.1% | 34.34 ± 1.0% | not timed | not timed | 5873.38 ± 0.0% | | 1.00 | 0.94 | 171.47 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21407.47 ± 0.2% | not timed | not timed | 19321.28 ± 0.3% | 24.82 ± 1.5% | not timed | not timed | 21421.06 ± 0.0% | | 1.00 | 1.11 | 862.63 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21505.09 ± 0.9% | not timed | not timed | 19764.44 ± 1.0% | 24.72 ± 0.5% | not timed | not timed | 21466.68 ± 1.1% | | 1.00 | 1.09 | 870.02 |
| imported/sherlock/name-sherlock | 776 | 19421.35 ± 2.4% | not timed | not timed | 18136.46 ± 1.3% | 9956.22 ± 26.5% | not timed | not timed | 19277.94 ± 2.3% | | 1.01 | 1.07 | 1.95 |
| imported/sherlock/name-holmes | 2766 | 14955.25 ± 1.7% | not timed | not timed | 15371.46 ± 0.8% | 3142.29 ± 15.2% | not timed | not timed | 15014.94 ± 2.1% | | 1.00 | 0.97 | 4.76 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19366.43 ± 2.1% | not timed | not timed | 18211.36 ± 0.8% | 7976.21 ± 15.2% | not timed | not timed | 19407.31 ± 2.0% | | 1.00 | 1.06 | 2.43 |
| imported/sherlock/name-sherlock-casei | 816 | 15515.88 ± 1.4% | not timed | not timed | 4013.24 ± 0.1% | 32.58 ± 0.5% | not timed | not timed | 15486.52 ± 0.7% | | 1.00 | 3.87 | 476.19 |
| imported/sherlock/name-holmes-casei | 2802 | 9267.20 ± 9.1% | not timed | not timed | 3309.17 ± 0.2% | 37.69 ± 5.9% | not timed | not timed | 9404.51 ± 5.0% | | 0.99 | 2.80 | 245.87 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13107.26 ± 4.7% | not timed | not timed | 3939.75 ± 0.3% | 32.57 ± 0.3% | not timed | not timed | 13133.85 ± 1.3% | | 1.00 | 3.33 | 402.49 |
| imported/sherlock/name-whitespace | 1461 | 15042.32 ± 7.0% | not timed | not timed | 14076.45 ± 0.4% | 6991.09 ± 23.6% | not timed | not timed | 15020.43 ± 6.0% | | 1.00 | 1.07 | 2.15 |
| imported/sherlock/name-alt1 | 1142 | 11624.67 ± 0.2% | not timed | not timed | 15735.53 ± 1.9% | 4093.07 ± 19.6% | not timed | not timed | 11613.44 ± 3.2% | | 1.00 | 0.74 | 2.84 |
| imported/sherlock/name-alt2 | 3542 | 8951.78 ± 0.4% | not timed | not timed | 3831.48 ± 0.1% | 31.37 ± 0.1% | not timed | not timed | 8966.58 ± 0.5% | | 1.00 | 2.34 | 285.32 |
| imported/sherlock/name-alt3 | 4507 | 5576.66 ± 0.7% | not timed | not timed | 3629.38 ± 0.2% | 9.91 ± 4.0% | not timed | not timed | 5577.88 ± 1.1% | | 1.00 | 1.54 | 562.45 |
| imported/sherlock/name-alt3-casei | 4593 | 1530.36 ± 2.0% | not timed | not timed | 285.00 ± 0.2% | 6.48 ± 0.1% | not timed | not timed | 1529.80 ± 0.9% | | 1.00 | 5.37 | 236.23 |
| imported/sherlock/name-alt4 | 3686 | 6396.05 ± 0.4% | not timed | not timed | 3771.62 ± 0.1% | 31.28 ± 0.3% | not timed | not timed | 6391.80 ± 0.3% | | 1.00 | 1.70 | 204.48 |
| imported/sherlock/name-alt4-casei | 4254 | 2809.49 ± 2.2% | not timed | not timed | 2579.81 ± 0.2% | 19.88 ± 0.3% | not timed | not timed | 2815.69 ± 0.6% | | 1.00 | 1.09 | 141.35 |
| imported/sherlock/name-alt5 | 4028 | 6447.50 ± 0.4% | not timed | not timed | 3746.16 ± 0.1% | 21.66 ± 0.1% | not timed | not timed | 6459.17 ± 0.2% | | 1.00 | 1.72 | 297.70 |
| imported/sherlock/name-alt5-casei | 4104 | 3512.55 ± 1.9% | not timed | not timed | 2198.55 ± 0.2% | 14.33 ± 0.1% | not timed | not timed | 3526.08 ± 1.2% | | 1.00 | 1.60 | 245.12 |
| imported/sherlock/no-match-uncommon | 0 | 21219.23 ± 1.3% | not timed | not timed | 19051.35 ± 0.8% | 33241.87 ± 0.5% | not timed | not timed | 21065.75 ± 1.1% | | 1.01 | 1.11 | 0.64 |
| imported/sherlock/no-match-common | 0 | 20687.25 ± 1.0% | not timed | not timed | 19031.52 ± 0.7% | 1279.05 ± 0.7% | not timed | not timed | 20727.28 ± 0.3% | | 1.00 | 1.09 | 16.17 |
| imported/sherlock/no-match-really-common | 0 | 15722.17 ± 3.2% | not timed | not timed | 18356.09 ± 1.0% | 1275.18 ± 0.2% | not timed | not timed | 15906.98 ± 2.4% | | 0.99 | 0.86 | 12.33 |
| imported/sherlock/the-lower | 21654 | 2321.41 ± 0.8% | not timed | not timed | 2330.55 ± 0.3% | 238.31 ± 14.9% | not timed | not timed | 2329.02 ± 1.7% | | 1.00 | 1.00 | 9.74 |
| imported/sherlock/the-upper | 2223 | 12528.69 ± 9.7% | not timed | not timed | 13398.85 ± 1.4% | 2658.17 ± 21.4% | not timed | not timed | 12637.93 ± 1.3% | | 0.99 | 0.94 | 4.71 |
| imported/sherlock/the-casei | 23961 | 2012.14 ± 0.3% | not timed | not timed | 1317.08 ± 0.5% | 34.56 ± 0.9% | not timed | not timed | 2014.90 ± 0.2% | | 1.00 | 1.53 | 58.22 |
| imported/sherlock/everything-greedy | 581881 | 283.03 ± 1.0% | not timed | not timed | 162.14 ± 0.1% | 28.77 ± 18.6% | not timed | not timed | 283.25 ± 0.7% | | 1.00 | 1.75 | 9.84 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.74 ± 0.2% | not timed | not timed | 212.86 ± 0.3% | 32.97 ± 0.1% | not timed | not timed | 462.35 ± 0.2% | | 1.00 | 2.17 | 14.03 |
| imported/sherlock/letters | 447175 | 62.13 ± 0.5% | not timed | not timed | 32.92 ± 0.2% | 6.56 ± 28.9% | not timed | not timed | 62.36 ± 8.9% | | 1.00 | 1.89 | 9.47 |
| imported/sherlock/letters-upper | 14180 | 453.16 ± 1.2% | not timed | not timed | 371.05 ± 0.2% | 29.46 ± 21.3% | not timed | not timed | 453.12 ± 0.1% | | 1.00 | 1.22 | 15.38 |
| imported/sherlock/letters-lower | 432995 | 63.39 ± 0.3% | not timed | not timed | 33.80 ± 0.1% | 5.81 ± 18.1% | not timed | not timed | 63.43 ± 0.1% | | 1.00 | 1.88 | 10.91 |
| imported/sherlock/words | 447639 | 114.49 ± 1.1% | not timed | not timed | 82.74 ± 0.2% | 13.76 ± 3.6% | not timed | not timed | 115.21 ± 0.6% | | 0.99 | 1.38 | 8.32 |
| imported/sherlock/before-holmes | 4073 | 10245.86 ± 0.4% | not timed | not timed | 8344.75 ± 0.6% | 23.94 ± 0.4% | not timed | not timed | 10272.89 ± 0.8% | | 1.00 | 1.23 | 427.98 |
| imported/sherlock/before-after-holmes | 2593 | 9887.22 ± 0.7% | not timed | not timed | 9389.73 ± 0.9% | 24.14 ± 2.5% | not timed | not timed | 9850.65 ± 0.8% | | 1.00 | 1.05 | 409.64 |
| imported/sherlock/holmes-cochar-watson | 150 | 5190.62 ± 0.3% | not timed | not timed | 3424.20 ± 0.1% | 30.93 ± 0.1% | not timed | not timed | 5198.68 ± 0.3% | | 1.00 | 1.52 | 167.83 |
| imported/sherlock/holmes-coword-watson | 14309 | 1184.44 ± 0.5% | not timed | not timed | 1124.28 ± 0.3% | 6.81 ± 0.1% | not timed | not timed | 1186.68 ± 0.8% | | 1.00 | 1.05 | 174.02 |
| imported/sherlock/quotes | 14437 | 1397.48 ± 1.5% | not timed | not timed | 1765.52 ± 0.9% | 35.10 ± 0.2% | not timed | not timed | 1399.42 ± 0.4% | | 1.00 | 0.79 | 39.82 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 609.85 ± 0.0% | not timed | not timed | 15570.03 ± 1.9% | 36.76 ± 0.1% | not timed | not timed | 609.70 ± 0.3% | | 1.00 | 0.0392 | 16.59 |
| imported/sherlock/word-ending-n | 35297 | 480.90 ± 0.5% | not timed | not timed | 409.25 ± 0.1% | 23.42 ± 20.5% | not timed | not timed | 481.71 ± 1.0% | | 1.00 | 1.18 | 20.53 |
| imported/sherlock/repeated-class-negation | 2130 | 14384.81 ± 1.5% | not timed | not timed | 10804.39 ± 0.8% | 11.57 ± 0.2% | not timed | not timed | 14402.48 ± 0.7% | | 1.00 | 1.33 | 1243.36 |
| imported/sherlock/ing-suffix | 20547 | 565.96 ± 0.1% | not timed | not timed | 516.51 ± 0.2% | 28.84 ± 0.2% | not timed | not timed | 566.55 ± 0.2% | | 1.00 | 1.10 | 19.63 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 607.67 ± 0.5% | not timed | not timed | 2094.60 ± 0.5% | 20.50 ± 0.2% | not timed | not timed | 607.39 ± 0.4% | | 1.00 | 0.29 | 29.64 |
| opt/accelerate/whole-line | 239963 | 458.14 ± 0.4% | not timed | not timed | 373.15 ± 0.3% | 92.71 ± 14.0% | not timed | not timed | 458.23 ± 0.2% | | 1.00 | 1.23 | 4.94 |
| opt/accelerate/non-dna | 16745 | 426.33 ± 0.8% | not timed | not timed | 400.66 ± 0.2% | 28.26 ± 20.1% | not timed | not timed | 428.54 ± 0.3% | | 0.99 | 1.06 | 15.08 |
| opt/backtrack/words-english | 40536 | 136.20 ± 1.9% | not timed | not timed | 94.43 ± 0.1% | 19.72 ± 6.6% | not timed | not timed | 136.29 ± 4.5% | | 1.00 | 1.44 | 6.90 |
| opt/fixed-length/too-small-ascii | 0 | 312.14 ± 0.2% | not timed | not timed | 703.62 ± 2.1% | 80.41 ± 1.1% | not timed | not timed | 314.57 ± 0.4% | | 0.99 | 0.44 | 3.88 |
| opt/fixed-length/too-big-ascii | 0 | 3502.32 ± 0.6% | not timed | not timed | 5746.63 ± 0.4% | 125.17 ± 0.3% | not timed | not timed | 3470.87 ± 0.5% | | 1.01 | 0.61 | 27.98 |
| opt/fixed-length/go33484-1 | 0 | 673399.98 ± 0.2% | not timed | not timed | 1107974.47 ± 0.1% | 61537.78 ± 0.7% | not timed | not timed | 669144.36 ± 0.3% | | 1.01 | 0.61 | 10.94 |
| opt/fixed-length/go33484-2 | 0 | 672943.19 ± 0.4% | not timed | not timed | 1106269.93 ± 0.4% | 32548.11 ± 1.1% | not timed | not timed | 669581.45 ± 0.5% | | 1.01 | 0.61 | 20.68 |
| opt/fixed-length/go33484-3 | 0 | 2406.43 ± 0.9% | not timed | not timed | 110682.33 ± 0.3% | 770.46 ± 0.4% | not timed | not timed | 2485.14 ± 3.7% | | 0.97 | 0.0217 | 3.12 |
| opt/literal-alt/one-pattern | 1 | 548.03 ± 1.7% | not timed | not timed | 537.71 ± 0.1% | 0.40 ± 0.3% | not timed | not timed | 548.35 ± 1.3% | | 1.00 | 1.02 | 1380.93 |
| opt/onepass/fn-predicate | 916 | 369.91 ± 0.8% | not timed | not timed | 333.62 ± 0.2% | 201.98 ± 14.4% | not timed | not timed | 373.37 ± 0.2% | | 0.99 | 1.11 | 1.83 |
| opt/onepass/first-three-words-english | 35128 | 174.81 ± 2.0% | not timed | not timed | 195.70 ± 0.1% | 77.32 ± 13.1% | not timed | not timed | 176.89 ± 0.9% | | 0.99 | 0.89 | 2.26 |
| opt/prefilter/literal-english | 1 | 20227.99 ± 0.3% | not timed | not timed | 19670.90 ± 0.1% | 17281.68 ± 0.4% | not timed | not timed | 20260.47 ± 0.6% | | 1.00 | 1.03 | 1.17 |
| opt/prefilter/literal-casei-english | 1 | 14448.50 ± 0.7% | not timed | not timed | 4307.22 ± 0.3% | 32.56 ± 0.3% | not timed | not timed | 14435.63 ± 0.5% | | 1.00 | 3.35 | 443.75 |
| opt/prefilter/literal-russian | 1 | 21411.74 ± 0.3% | not timed | not timed | 19856.41 ± 0.9% | 3324.60 ± 0.2% | not timed | not timed | 21406.56 ± 0.7% | | 1.00 | 1.08 | 6.44 |
| opt/prefilter/literal-casei-russian | 1 | 8583.90 ± 0.3% | not timed | not timed | 3894.17 ± 0.1% | 31.67 ± 0.3% | not timed | not timed | 8586.66 ± 0.2% | | 1.00 | 2.20 | 271.07 |
| opt/prefilter/rust-functions | 948 | 6821.87 ± 0.2% | not timed | not timed | 8948.72 ± 0.3% | 1869.01 ± 0.5% | not timed | not timed | 6825.70 ± 0.4% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 29917600.04 ± 0.2% | not timed | not timed | 21405890.96 ± 0.4% | 50.28 ± 0.2% | not timed | not timed | 29880502.63 ± 0.1% | | 1.00 | 1.40 | 595013.26 |
| opt/reverse-inner/holmes | 2593 | 9886.72 ± 1.1% | not timed | not timed | 9404.70 ± 0.6% | 23.97 ± 1.2% | not timed | not timed | 9882.75 ± 0.8% | | 1.00 | 1.05 | 412.43 |
| opt/reverse-inner/email | 47 | 36125.34 ± 2.1% | not timed | not timed | 44821.47 ± 0.5% | 32.41 ± 0.6% | not timed | not timed | 36842.54 ± 2.3% | | 0.98 | 0.81 | 1114.59 |
| opt/reverse-inner/factored-prefix | 3542 | 600.94 ± 0.1% | not timed | not timed | 597.49 ± 0.1% | 12.54 ± 0.1% | not timed | not timed | 600.49 ± 0.2% | | 1.00 | 1.01 | 47.94 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5553.38 ± 0.1% | not timed | not timed | 613.30 ± 0.6% | 75.33 ± 0.2% | not timed | not timed | 5531.61 ± 0.1% | | 1.00 | 9.05 | 73.72 |
| opt/reverse-inner/no-quadratic-forward | 0 | 687.23 ± 2.1% | not timed | not timed | 288.51 ± 0.2% | 24.83 ± 0.1% | not timed | not timed | 688.00 ± 2.3% | | 1.00 | 2.38 | 27.68 |
| opt/reverse-suffix/holmes | 4073 | 10211.35 ± 0.3% | not timed | not timed | 8365.21 ± 0.5% | 23.89 ± 0.9% | not timed | not timed | 10250.90 ± 0.3% | | 1.00 | 1.22 | 427.47 |
| opt/reverse-suffix/no-quadratic | 0 | 5531.67 ± 0.1% | not timed | not timed | 615.96 ± 0.2% | 75.16 ± 0.1% | not timed | not timed | 5559.22 ± 0.2% | | 1.00 | 8.98 | 73.60 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.94 ± 8.7% | not timed | not timed | 132.28 ± 0.1% | 13.58 ± 14.7% | not timed | not timed | 122.84 ± 2.6% | | 0.99 | 0.92 | 8.98 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 122.42 ± 1.6% | not timed | not timed | 130.74 ± 0.1% | 13.64 ± 14.2% | not timed | not timed | 122.46 ± 4.5% | | 1.00 | 0.94 | 8.98 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.3% | not timed | not timed | 0.55 ± 0.3% | 110.56 ± 1.1% | not timed | not timed | 0.28 ± 0.1% | | 0.99 | 0.50 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 317.38 ± 0.4% | not timed | not timed | 294.02 ± 0.1% | 103.10 ± 7.5% | not timed | not timed | 312.64 ± 3.3% | | 1.02 | 1.08 | 3.08 |
| reported/i13-subset-regex/original-ascii | 4094 | 11104.61 ± 0.6% | not timed | not timed | 4496.08 ± 1.2% | 11.49 ± 0.2% | not timed | not timed | 11161.99 ± 0.9% | | 0.99 | 2.47 | 966.59 |
| reported/i13-subset-regex/original-unicode | 4094 | 11027.01 ± 1.3% | not timed | not timed | 252.55 ± 2.9% | 11.50 ± 0.1% | not timed | not timed | 11156.69 ± 0.9% | | 0.99 | 43.66 | 958.55 |
| reported/i13-subset-regex/big-ascii | 1955 | 10673.14 ± 1.1% | not timed | not timed | 68.02 ± 3.5% | 9.84 ± 0.2% | not timed | not timed | 10713.50 ± 0.9% | | 1.00 | 156.91 | 1084.47 |
| reported/i13-subset-regex/big-unicode | 1955 | 10592.76 ± 1.0% | not timed | not timed | 12.18 ± 54.9% | 9.82 ± 0.3% | not timed | not timed | 10709.57 ± 1.5% | | 0.99 | 869.84 | 1078.32 |
| reported/i13-subset-regex/huge-ascii | 55 | 10095.90 ± 2.6% | not timed | not timed | 11.05 ± 0.1% | 8.74 ± 0.3% | not timed | not timed | 9919.34 ± 2.4% | | 1.02 | 913.86 | 1155.58 |
| reported/i13-subset-regex/huge-unicode | 55 | 9916.79 ± 2.4% | not timed | not timed | 10.94 ± 0.3% | 8.77 ± 0.2% | not timed | not timed | 9876.28 ± 2.6% | | 1.00 | 906.30 | 1131.07 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.57 ± 0.0% | not timed | not timed | 11.03 ± 0.1% | 8.75 ± 0.2% | not timed | not timed | 3.56 ± 0.1% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.05 ± 0.1% | not timed | not timed | 10.96 ± 0.4% | 8.75 ± 1.3% | not timed | not timed | 5.04 ± 0.1% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 487.22 ± 0.2% | not timed | not timed | 104.23 ± 0.2% | 6.64 ± 0.3% | not timed | not timed | 487.85 ± 0.3% | | 1.00 | 4.67 | 73.34 |
| reported/i787-keywords/opt-ascii | 5674 | 488.48 ± 0.3% | not timed | not timed | 268.02 ± 0.2% | 10.29 ± 0.1% | not timed | not timed | 488.99 ± 0.4% | | 1.00 | 1.82 | 47.45 |
| slow/quadratic-regex-1x | 100 | 7.14 ± 0.3% | not timed | not timed | 4.94 ± 0.2% | 0.05 ± 0.2% | not timed | not timed | 7.12 ± 0.2% | | 1.00 | 1.45 | 144.75 |
| slow/quadratic-regex-2x | 199 | 3.43 ± 0.2% | not timed | not timed | 2.76 ± 0.1% | 0.01 ± 0.3% | not timed | not timed | 3.43 ± 0.2% | | 1.00 | 1.24 | 268.64 |
| slow/quadratic-haystack-1x | 100 | 21.33 ± 7.0% | not timed | not timed | 10.00 ± 0.3% | 1.01 ± 13.8% | not timed | not timed | 21.36 ± 1.7% | | 1.00 | 2.13 | 21.06 |
| slow/quadratic-haystack-2x | 200 | 17.72 ± 1.1% | not timed | not timed | 5.55 ± 0.3% | 0.55 ± 1.2% | not timed | not timed | 17.79 ± 12.8% | | 1.00 | 3.19 | 32.48 |
| unicode/codepoints/any-one | 1112064 | 289.55 ± 0.3% | not timed | not timed | 173.69 ± 0.1% | 17.99 ± 16.4% | not timed | not timed | 289.73 ± 0.5% | | 1.00 | 1.67 | 16.10 |
| unicode/codepoints/any-all | 4382592 | 269.60 ± 0.5% | not timed | not timed | 245.72 ± 0.1% | 114.10 ± 0.1% | not timed | not timed | 270.63 ± 1.2% | | 1.00 | 1.10 | 2.36 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.78 ± 1.2% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 604.85 ± 1.1% | not timed | not timed | 615.78 ± 0.4% | 135.38 ± 0.1% | not timed | not timed | 600.34 ± 1.0% | | 1.01 | 0.98 | 4.47 |
| unicode/overlapping-words/ascii | 6156 | 31.62 ± 0.3% | not timed | not timed | 39.02 ± 0.1% | 3.93 ± 1.0% | not timed | not timed | 31.60 ± 0.2% | | 1.00 | 0.81 | 8.04 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 0.1% | not timed | not timed | 4.10 ± 0.3% | 2.34 ± 0.8% | not timed | not timed | 1.45 ± 0.1% | | 1.00 | 0.35 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 1.1% | not timed | not timed | 3.87 ± 0.4% | 6.30 ± 9.0% | not timed | not timed | 1.29 ± 22.7% | | 0.99 | 0.33 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 126.95 ± 3.7% | not timed | not timed | 83.02 ± 0.1% | 12.81 ± 17.7% | not timed | not timed | 128.76 ± 0.6% | | 0.99 | 1.53 | 9.91 |
| unicode/word/boundary-long-english | 3466 | 615.18 ± 0.3% | not timed | not timed | 605.48 ± 0.2% | 32.29 ± 0.5% | not timed | not timed | 615.98 ± 0.2% | | 1.00 | 1.02 | 19.05 |
| unicode/word/around-holmes-english | 27 | 19280.19 ± 0.4% | not timed | not timed | 19306.27 ± 0.3% | 22.13 ± 0.9% | not timed | not timed | 19411.44 ± 0.6% | | 0.99 | 1.00 | 871.16 |
| wild/bibleref/long | 874 | 562.94 ± 0.1% | not timed | not timed | 582.40 ± 0.1% | 6.37 ± 0.1% | not timed | not timed | 563.34 ± 0.1% | | 1.00 | 0.97 | 88.40 |
| wild/bibleref/short | 30 | 24.75 ± 7.5% | not timed | not timed | 30.61 ± 0.6% | 13.95 ± 9.6% | not timed | not timed | 25.58 ± 1.9% | | 0.97 | 0.81 | 1.77 |
| wild/bibleref/line | 874 | 393.59 ± 0.2% | not timed | not timed | 212.29 ± 0.1% | 9.15 ± 0.1% | not timed | not timed | 393.80 ± 0.2% | | 1.00 | 1.85 | 43.03 |
| wild/caddy/caddy | 6 | 416.51 ± 2.3% | not timed | not timed | 248.51 ± 0.1% | 67.31 ± 13.2% | not timed | not timed | 418.45 ± 0.2% | | 1.00 | 1.68 | 6.19 |
| wild/dot-star-capture/rust-src-tools | 6 | 1070.15 ± 0.2% | not timed | not timed | 345.05 ± 0.2% | 13.56 ± 0.3% | not timed | not timed | 1069.72 ± 0.3% | | 1.00 | 3.10 | 78.91 |
| wild/ruff/noqa | 84 | 436.33 ± 0.1% | not timed | not timed | 460.94 ± 0.1% | 19.56 ± 1.8% | not timed | not timed | 434.66 ± 3.1% | | 1.00 | 0.95 | 22.31 |
| wild/ruff/unnecessary-coding-comment | 16 | 963.47 ± 0.4% | not timed | not timed | 704.29 ± 0.2% | 136.34 ± 11.1% | not timed | not timed | 960.84 ± 0.4% | | 1.00 | 1.37 | 7.07 |
| wild/ruff/string-quote-prefix | 2972 | 1356.65 ± 0.6% | not timed | not timed | 435.26 ± 0.3% | 316.52 ± 25.9% | not timed | not timed | 1358.63 ± 0.6% | | 1.00 | 3.12 | 4.29 |
| wild/ruff/space-around-operator | 1224378 | 220.15 ± 1.8% | not timed | not timed | 186.66 ± 0.1% | 18.45 ± 1.8% | not timed | not timed | 220.94 ± 1.9% | | 1.00 | 1.18 | 11.93 |
| wild/ruff/shebang | 282 | 984.27 ± 0.4% | not timed | not timed | 329.99 ± 0.2% | 118.53 ± 9.4% | not timed | not timed | 988.27 ± 0.4% | | 1.00 | 2.98 | 8.30 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13774.15 ± 0.3% | not timed | not timed | 13775.36 ± 0.6% | 6928.89 ± 0.4% | not timed | not timed | 13775.91 ± 0.4% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12805.46 ± 0.7% | not timed | not timed | 13496.19 ± 0.6% | 6400.83 ± 0.7% | not timed | not timed | 12823.11 ± 0.8% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13185.74 ± 0.8% | not timed | not timed | 13648.64 ± 0.5% | 6607.73 ± 0.7% | not timed | not timed | 13174.10 ± 0.5% | | 1.00 | 0.97 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9554.81 ± 0.4% | not timed | not timed | 13554.23 ± 0.3% | 6752.89 ± 1.0% | not timed | not timed | 9566.35 ± 0.4% | | 1.00 | 0.70 | 1.41 |
| wild/url/search | 234965 | 121.25 ± 13.8% | not timed | not timed | 65.80 ± 1.1% | 2.21 ± 0.6% | not timed | not timed | 121.92 ± 13.9% | | 0.99 | 1.84 | 54.91 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 67.4% | not timed | not timed | 0.01 ± 0.7% | 0.01 ± 16.5% | not timed | not timed | 0.03 ± 2.8% | | 0.99 | 3.10 | 4.12 |
| dictionary/compile/english-15 | 1 | 0.35 ± 2.0% | not timed | not timed | 0.07 ± 0.5% | 0.10 ± 10.5% | not timed | not timed | 0.35 ± 21.8% | | 1.00 | 4.99 | 3.39 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 0.9% | not timed | not timed | 0.02 ± 1.3% | 35.65 ± 4.9% | not timed | not timed | 0.25 ± 3.5% | | 1.00 | 13.02 | 0.0070 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.18 ± 2.4% | not timed | not timed | 11.57 ± 0.2% | 52.67 ± 19.2% | not timed | not timed | 47.49 ± 2.3% | | 0.99 | 4.08 | 0.90 |
| reported/i787-keywords/compile | 1 | 34.63 ± 15.5% | not timed | not timed | 2.13 ± 2.3% | 16.75 ± 27.2% | not timed | not timed | 34.59 ± 2.2% | | 1.00 | 16.28 | 2.07 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 366.26 ± 5.0% | not timed | not timed | 122.33 ± 0.2% | 561.87 ± 28.7% | not timed | not timed | 370.19 ± 3.0% | | 0.99 | 2.99 | 0.65 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.17 ± 2.1% | not timed | not timed | 4.10 ± 0.3% | 43.74 ± 5.4% | not timed | not timed | 47.87 ± 2.2% | | 0.99 | 11.51 | 1.08 |
| unicode/compile/one-letter | 53 | 6.59 ± 12.6% | not timed | not timed | 4.53 ± 0.3% | 63.75 ± 6.0% | not timed | not timed | 6.71 ± 2.0% | | 0.98 | 1.45 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.07 ± 6.5% | not timed | not timed | 0.10 ± 0.4% | 64.30 ± 18.5% | not timed | not timed | 1.09 ± 4.9% | | 0.99 | 10.75 | 0.0166 |
| unicode/compile/fifty-letters-ascii | 1 | 218.87 ± 3.1% | not timed | not timed | 52.65 ± 0.3% | 189.76 ± 17.5% | not timed | not timed | 222.15 ± 3.7% | | 0.99 | 4.16 | 1.15 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 380.20 ± 17.8% | not timed | not timed | 47.09 ± 0.6% | 691.50 ± 18.3% | not timed | not timed | 386.98 ± 8.3% | | 0.98 | 8.07 | 0.55 |
| unicode/compile/match-every-line-ascii | 4 | 602.70 ± 20.2% | not timed | not timed | 144.46 ± 0.2% | 659.98 ± 12.2% | not timed | not timed | 620.27 ± 14.9% | | 0.97 | 4.17 | 0.91 |
| unicode/compile/negated-class-matches-codepoint | 1 | 324.06 ± 4.6% | not timed | not timed | 51.34 ± 0.6% | 1240.72 ± 14.2% | not timed | not timed | 330.97 ± 4.2% | | 0.98 | 6.31 | 0.26 |
| wild/bibleref/compile | 3 | 5.73 ± 3.3% | not timed | not timed | 1.91 ± 0.9% | 31.96 ± 4.5% | not timed | not timed | 5.88 ± 4.3% | | 0.98 | 3.01 | 0.18 |
| wild/url/compile | 1 | 0.63 ± 17.6% | not timed | not timed | 0.14 ± 0.3% | 0.46 ± 12.0% | not timed | not timed | 0.63 ± 17.8% | | 1.00 | 4.35 | 1.37 |

