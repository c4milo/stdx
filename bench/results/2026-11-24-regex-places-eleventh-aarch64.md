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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507021102 |
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
| literal: a word | 217 | 19505.35 ± 1.6% | 5078.13 ± 0.2% | 28.28 ± 0.3% | 18295.44 ± 0.8% | 9256.23 ± 9.8% | 17.37 ± 0.3% | 86.01 ± 0.2% | 19489.10 ± 1.5% | 3.84 | 1.00 | 1.07 | 2.11 |
| literal: a word that is not there | 0 | 21593.26 ± 1.5% | 4938.84 ± 0.3% | 28.29 ± 0.3% | 20058.84 ± 2.0% | 28742.93 ± 1.4% | 17.23 ± 0.2% | 82.00 ± 0.1% | 21407.15 ± 1.5% | 4.37 | 1.01 | 1.08 | 0.75 |
| literal: one of four words | 661 | 6426.10 ± 0.5% | 1975.10 ± 0.2% | 14.41 ± 0.3% | 3939.47 ± 0.3% | 21.85 ± 0.1% | 5.26 ± 0.1% | 6.75 ± 0.2% | 6430.21 ± 0.3% | 3.25 | 1.00 | 1.63 | 294.10 |
| literal: a word in any case | 217 | 15180.11 ± 0.5% | 2102.68 ± 0.5% | 21.49 ± 0.3% | 3970.38 ± 0.4% | 38.02 ± 0.4% | refused | differs | 15164.82 ± 0.9% | 7.22 | 1.00 | 3.82 | 399.25 |
| literal: an href attribute | 33 | 16888.37 ± 0.6% | 617.80 ± 0.3% | 27.21 ± 0.5% | 17008.06 ± 0.6% | 2255.37 ± 0.4% | 13.18 ± 0.2% | 75.37 ± 0.2% | 16914.27 ± 0.7% | 27.34 | 1.00 | 0.99 | 7.49 |
| literal: a word, second text | 123 | 19883.35 ± 2.4% | 3423.51 ± 0.1% | 27.95 ± 0.1% | 18337.04 ± 1.7% | 7503.81 ± 5.2% | 19.59 ± 0.5% | 69.79 ± 0.4% | 19731.10 ± 1.8% | 5.81 | 1.01 | 1.08 | 2.65 |
| class: two capitalized words | 1331 | 1065.77 ± 0.6% | 609.52 ± 0.1% | 25.99 ± 0.2% | 585.00 ± 0.2% | 40.60 ± 6.5% | 14.79 ± 0.3% | 68.48 ± 0.2% | 1065.41 ± 0.5% | 1.75 | 1.00 | 1.82 | 26.25 |
| class: a word that ends in ing | 3399 | 582.64 ± 0.1% | 582.58 ± 0.2% | 17.96 ± 0.2% | 547.72 ± 0.3% | 29.48 ± 7.4% | 8.17 ± 0.1% | 18.21 ± 0.5% | 584.22 ± 0.2% | 1.00 | 1.00 | 1.06 | 19.76 |
| class: a word in capitals | 2332 | 1387.54 ± 0.3% | 614.42 ± 0.1% | 27.52 ± 0.2% | 571.54 ± 0.3% | 43.51 ± 17.1% | 17.12 ± 0.5% | 82.87 ± 0.3% | 1389.05 ± 0.7% | 2.26 | 1.00 | 2.43 | 31.89 |
| class: a number | 8288 | 2132.20 ± 0.4% | 853.16 ± 0.2% | 27.68 ± 0.4% | 1725.67 ± 0.1% | 43.41 ± 3.8% | 0.53 ± 0.8% | 56.54 ± 0.8% | 2129.01 ± 0.5% | 2.50 | 1.00 | 1.24 | 49.12 |
| class: two capitalized words, second text | 5359 | 525.03 ± 0.1% | 534.43 ± 0.2% | 23.32 ± 0.2% | 484.25 ± 0.1% | 35.37 ± 8.3% | 16.62 ± 0.4% | 63.51 ± 0.3% | 525.39 ± 0.5% | 0.98 | 1.00 | 1.08 | 14.84 |
| other: a word between two words | 6104 | 811.74 ± 0.4% | 609.42 ± 0.3% | 23.57 ± 0.1% | 738.15 ± 0.3% | 102.42 ± 16.9% | 11.27 ± 0.2% | 69.45 ± 0.5% | 810.37 ± 0.2% | 1.33 | 1.00 | 1.10 | 7.93 |
| other: a number before a unit, second text | 1481 | 6146.11 ± 1.1% | 1132.05 ± 0.1% | 25.95 ± 0.2% | 5637.54 ± 0.3% | 40.77 ± 0.2% | 17.75 ± 0.1% | 66.55 ± 0.4% | 6088.74 ± 1.3% | 5.43 | 1.01 | 1.09 | 150.74 |
| other: a heading's start tag | 110 | 14136.93 ± 0.6% | 750.79 ± 0.3% | 27.33 ± 0.4% | 1706.30 ± 0.4% | 1579.93 ± 4.8% | 15.94 ± 0.5% | 88.44 ± 0.3% | 14239.20 ± 0.4% | 18.83 | 0.99 | 8.29 | 8.95 |
| other: a whole word | 217 | 16324.99 ± 0.7% | 608.67 ± 0.1% | 29.25 ± 0.3% | 14673.97 ± 0.6% | 48.07 ± 0.4% | 13.50 ± 0.1% | 55.46 ± 0.7% | 16404.23 ± 1.1% | 26.82 | 1.00 | 1.11 | 339.58 |
| other: a line's first word, second text | 3716 | 2094.82 ± 0.4% | 598.75 ± 0.3% | 30.93 ± 0.6% | 1721.43 ± 0.3% | 62.35 ± 3.0% | refused | refused | 2100.41 ± 1.0% | 3.50 | 1.00 | 1.22 | 33.60 |
| other: fourteen octets before an x | 87 | 23947.56 ± 1.6% | 227.21 ± 0.8% | 6.56 ± 0.2% | 4046.63 ± 1.4% | 10.65 ± 0.1% | differs | 17.48 ± 0.1% | 23978.50 ± 7.9% | 105.40 | 1.00 | 5.92 | 2247.88 |
| other: a Greek word | 21815 | 520.86 ± 0.3% | 426.15 ± 0.1% | 30.80 ± 0.2% | 289.41 ± 0.4% | 49.42 ± 10.9% | differs | refused | 523.05 ± 0.7% | 1.22 | 1.00 | 1.80 | 10.54 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.28 ± 0.2% | 29.22 ± 0.3% | 0.86 ± 0.2% | 19.77 ± 0.2% | 2.52 ± 9.5% | differs | 4.00 ± 0.3% | 29.18 ± 0.2% | 1.00 | 1.00 | 1.48 | 11.63 |
| a UUID | 32895 | 24.64 ± 0.1% | 24.42 ± 1.4% | 0.64 ± 0.1% | 15.16 ± 0.2% | 3.11 ± 0.7% | 0.71 ± 0.1% | 3.60 ± 0.4% | 24.42 ± 0.1% | 1.01 | 1.01 | 1.62 | 7.93 |
| an IPv4 address | 33176 | 38.43 ± 0.4% | 38.38 ± 0.7% | 2.08 ± 0.1% | 28.97 ± 0.5% | 6.65 ± 0.2% | differs | 4.14 ± 0.2% | 38.50 ± 0.3% | 1.00 | 1.00 | 1.33 | 5.78 |
| a date and time | 32954 | 34.33 ± 0.1% | 34.10 ± 0.2% | 1.45 ± 0.4% | 21.13 ± 0.4% | 7.06 ± 0.1% | 1.20 ± 0.3% | 7.07 ± 0.2% | 34.04 ± 0.1% | 1.01 | 1.01 | 1.62 | 4.86 |
| a field path | 32606 | 32.57 ± 0.2% | 32.57 ± 0.2% | 1.01 ± 0.5% | 22.99 ± 0.4% | 3.51 ± 0.8% | differs | 2.92 ± 0.2% | 32.58 ± 0.2% | 1.00 | 1.00 | 1.42 | 9.29 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.11 ± 0.2% | 11.05 ± 0.2% | 11.12 ± 0.3% | 11.39 ± 0.1% | 4.89 ± 3.1% | 0.90 ± 0.7% | none | 11.09 ± 0.3% | 1.01 | 1.00 | 0.98 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 231.32 ± 0.5% | 231.82 ± 0.1% | 272.80 ± 0.3% | 86.69 ± 0.5% | 216.43 ± 8.8% | 483.51 ± 0.5% | 3727.81 ± 0.7% | 231.85 ± 0.1% | 1.00 | 1.00 | 2.67 | 1.07 |
| a UUID | 62 | 149.91 ± 0.2% | 149.95 ± 0.3% | 166.92 ± 0.3% | 46.27 ± 1.0% | 98.17 ± 1.8% | 189.11 ± 2.5% | 4455.36 ± 0.5% | 150.10 ± 0.2% | 1.00 | 1.00 | 3.24 | 1.53 |
| an IPv4 address | 29 | 421.01 ± 0.2% | 421.52 ± 0.2% | 582.95 ± 0.3% | 78.39 ± 0.8% | 128.75 ± 0.9% | 295.67 ± 0.8% | 7630.61 ± 0.4% | 420.89 ± 0.2% | 1.00 | 1.00 | 5.37 | 3.27 |
| a date and time | 56 | 301.89 ± 1.5% | 302.12 ± 0.3% | 375.87 ± 0.3% | 72.95 ± 0.2% | 134.76 ± 1.3% | 329.32 ± 2.7% | 4942.25 ± 0.7% | 302.31 ± 2.3% | 1.00 | 1.00 | 4.14 | 2.24 |
| a field path | 39 | 223.47 ± 0.4% | 223.74 ± 0.6% | 262.56 ± 0.2% | 80.05 ± 2.7% | 201.20 ± 1.2% | 515.96 ± 4.5% | 4840.47 ± 0.4% | 224.17 ± 0.2% | 1.00 | 1.00 | 2.79 | 1.11 |
| literal: a word | 7 | 617.31 ± 0.4% | 666.49 ± 0.4% | 1174.50 ± 0.3% | 511.50 ± 0.2% | 611.43 ± 1.5% | 960.26 ± 1.0% | 30245.80 ± 0.2% | 618.51 ± 0.5% | 0.93 | 1.00 | 1.21 | 1.01 |
| literal: a word that is not there | 8 | 595.39 ± 0.5% | 649.77 ± 0.5% | 1108.28 ± 0.6% | 468.77 ± 0.3% | 588.25 ± 3.1% | 902.00 ± 0.3% | 29171.95 ± 0.3% | 596.42 ± 0.6% | 0.92 | 1.00 | 1.27 | 1.01 |
| literal: one of four words | 26 | 246.63 ± 0.4% | 396.27 ± 0.2% | 535.02 ± 0.2% | 49.88 ± 0.4% | 238.79 ± 3.4% | 368.82 ± 0.3% | 15570.28 ± 0.3% | 246.66 ± 0.1% | 0.62 | 1.00 | 4.94 | 1.03 |
| literal: a word in any case | 11 | 446.68 ± 0.2% | 476.95 ± 0.4% | 696.35 ± 0.4% | 15.60 ± 0.3% | 641.06 ± 4.4% | refused | 23593.24 ± 0.6% | 447.46 ± 0.2% | 0.94 | 1.00 | 28.63 | 0.70 |
| literal: an href attribute | 12 | 339.54 ± 0.4% | 351.46 ± 0.8% | 457.26 ± 0.3% | 44.17 ± 1.2% | 488.04 ± 1.7% | 777.52 ± 0.3% | 21668.02 ± 0.1% | 340.19 ± 0.3% | 0.97 | 1.00 | 7.69 | 0.70 |
| literal: a word, second text | 10 | 550.84 ± 0.7% | 608.64 ± 0.5% | 1000.25 ± 0.8% | 422.81 ± 2.0% | 527.03 ± 2.4% | 798.84 ± 0.6% | 26966.19 ± 0.1% | 551.19 ± 0.3% | 0.91 | 1.00 | 1.30 | 1.05 |
| class: two capitalized words | 23 | 435.14 ± 0.2% | 463.06 ± 0.4% | 659.71 ± 0.4% | 100.92 ± 0.2% | 492.67 ± 2.6% | 743.38 ± 0.4% | 6352.26 ± 0.0% | 434.33 ± 0.2% | 0.94 | 1.00 | 4.31 | 0.88 |
| class: a word that ends in ing | 9 | 548.97 ± 0.1% | 617.62 ± 0.2% | 1058.06 ± 0.2% | 133.11 ± 1.2% | 750.97 ± 1.5% | 1132.24 ± 0.9% | 15782.66 ± 0.3% | 549.37 ± 0.2% | 0.89 | 1.00 | 4.12 | 0.73 |
| class: a word in capitals | 16 | 490.97 ± 0.4% | 529.10 ± 0.3% | 827.69 ± 0.3% | 137.44 ± 1.2% | 741.72 ± 0.9% | 1057.27 ± 0.6% | 8359.59 ± 0.1% | 489.96 ± 0.4% | 0.93 | 1.00 | 3.57 | 0.66 |
| class: a number | 6 | 627.07 ± 0.2% | 686.33 ± 0.4% | 1259.28 ± 0.1% | 42.09 ± 0.7% | 1385.61 ± 0.9% | 1879.70 ± 1.4% | 22794.22 ± 0.0% | 627.84 ± 0.3% | 0.91 | 1.00 | 14.90 | 0.45 |
| class: two capitalized words, second text | 23 | 435.23 ± 0.5% | 463.21 ± 0.2% | 659.82 ± 0.3% | 100.69 ± 0.5% | 498.52 ± 2.2% | 740.09 ± 0.6% | 6352.13 ± 0.2% | 434.53 ± 0.2% | 0.94 | 1.00 | 4.32 | 0.87 |
| other: a word between two words | 13 | 532.95 ± 0.5% | 552.71 ± 0.4% | 867.54 ± 0.2% | 133.20 ± 0.4% | 492.69 ± 9.4% | 809.91 ± 1.2% | 14655.24 ± 0.1% | 532.03 ± 0.5% | 0.96 | 1.00 | 4.00 | 1.08 |
| other: a number before a unit, second text | 15 | 391.52 ± 0.6% | 433.35 ± 0.3% | 604.01 ± 0.3% | 39.56 ± 1.1% | 622.81 ± 1.7% | 900.94 ± 1.3% | 15223.02 ± 0.1% | 392.05 ± 0.3% | 0.90 | 1.00 | 9.90 | 0.63 |
| other: a heading's start tag | 13 | 349.58 ± 0.4% | 356.94 ± 0.2% | 467.80 ± 0.5% | 44.74 ± 0.5% | 616.05 ± 1.0% | 870.70 ± 0.3% | 18051.09 ± 0.1% | 350.14 ± 0.3% | 0.98 | 1.00 | 7.81 | 0.57 |
| other: a whole word | 11 | 572.47 ± 0.4% | 614.65 ± 0.2% | 1012.02 ± 0.3% | 120.94 ± 1.4% | 558.48 ± 3.1% | 830.77 ± 1.4% | 26595.46 ± 0.7% | 574.05 ± 0.6% | 0.93 | 1.00 | 4.73 | 1.03 |
| other: a line's first word, second text | 17 | 515.30 ± 1.1% | 544.43 ± 0.5% | 859.79 ± 0.2% | 129.18 ± 0.1% | 703.02 ± 2.1% | refused | refused | 514.77 ± 0.5% | 0.95 | 1.00 | 3.99 | 0.73 |
| other: fourteen octets before an x | 16 | 108.15 ± 0.4% | 154.77 ± 1.2% | 176.17 ± 0.7% | 15.03 ± 0.6% | 448.02 ± 1.1% | 413.91 ± 1.2% | 12663.93 ± 0.3% | 108.10 ± 1.0% | 0.70 | 1.00 | 7.20 | 0.24 |
| other: a Greek word | 8 | 447.93 ± 0.3% | 586.46 ± 0.1% | 972.39 ± 0.1% | 59.21 ± 1.2% | 1374.50 ± 2.0% | 1813.81 ± 0.3% | refused | 447.90 ± 0.2% | 0.76 | 1.00 | 7.57 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15722.62 ± 1.3% | not timed | not timed | 16357.07 ± 1.3% | 1924.93 ± 21.0% | not timed | not timed | 15736.88 ± 0.7% | | 1.00 | 0.96 | 8.17 |
| 01-literal/sherlock-casei-en | 522 | 11038.75 ± 6.3% | not timed | not timed | 3590.59 ± 0.2% | 32.52 ± 14.8% | not timed | not timed | 11023.01 ± 1.5% | | 1.00 | 3.07 | 339.43 |
| 01-literal/sherlock-ru | 724 | 17122.84 ± 0.7% | not timed | not timed | 17273.09 ± 0.4% | 1508.99 ± 7.8% | not timed | not timed | 17191.66 ± 0.2% | | 1.00 | 0.99 | 11.35 |
| 01-literal/sherlock-casei-ru | 746 | 6131.77 ± 0.4% | not timed | not timed | 3329.93 ± 0.1% | 31.65 ± 1.7% | not timed | not timed | 6137.49 ± 0.3% | | 1.00 | 1.84 | 193.74 |
| 01-literal/sherlock-zh | 30 | 19659.74 ± 1.6% | not timed | not timed | 18644.89 ± 1.0% | 2765.29 ± 13.9% | not timed | not timed | 19697.63 ± 1.4% | | 1.00 | 1.05 | 7.11 |
| 02-literal-alternate/sherlock-en | 714 | 6151.46 ± 0.2% | not timed | not timed | 3939.27 ± 0.3% | 16.59 ± 0.2% | not timed | not timed | 6145.84 ± 0.3% | | 1.00 | 1.56 | 370.68 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1965.68 ± 0.9% | not timed | not timed | 697.37 ± 0.2% | 11.11 ± 0.1% | not timed | not timed | 1971.87 ± 0.6% | | 1.00 | 2.82 | 176.87 |
| 02-literal-alternate/sherlock-ru | 899 | 5537.32 ± 0.3% | not timed | not timed | 3250.86 ± 0.3% | 22.61 ± 0.2% | not timed | not timed | 5478.24 ± 0.2% | | 1.01 | 1.70 | 244.88 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2057.31 ± 0.5% | not timed | not timed | 1226.24 ± 0.6% | 9.14 ± 0.1% | not timed | not timed | 2055.44 ± 0.5% | | 1.00 | 1.68 | 225.08 |
| 02-literal-alternate/sherlock-zh | 207 | 7333.32 ± 0.4% | not timed | not timed | 4162.19 ± 0.1% | 31.47 ± 8.7% | not timed | not timed | 7346.29 ± 0.3% | | 1.00 | 1.76 | 233.06 |
| 03-date/ascii | 111817 | 133.79 ± 0.8% | not timed | not timed | 95.35 ± 0.1% | 0.20 ± 3.8% | not timed | not timed | 134.48 ± 0.8% | | 0.99 | 1.40 | 660.78 |
| 04-ruff-noqa/real | 84 | 435.49 ± 0.2% | not timed | not timed | 458.94 ± 0.1% | 19.57 ± 1.4% | not timed | not timed | 435.30 ± 0.1% | | 1.00 | 0.95 | 22.25 |
| 04-ruff-noqa/tweaked | 44 | 594.49 ± 0.1% | not timed | not timed | 460.69 ± 0.2% | 363.61 ± 0.7% | not timed | not timed | 594.83 ± 0.3% | | 1.00 | 1.29 | 1.63 |
| 05-lexer-veryl/single | 124800 | 5.37 ± 3.1% | not timed | not timed | 5.05 ± 0.2% | 0.21 ± 3.3% | not timed | not timed | 5.52 ± 0.6% | | 0.97 | 1.06 | 26.16 |
| 06-cloud-flare-redos/original | 107 | 426.31 ± 0.3% | not timed | not timed | 213.41 ± 0.1% | 24.96 ± 0.1% | not timed | not timed | 429.51 ± 0.2% | | 0.99 | 2.00 | 17.08 |
| 06-cloud-flare-redos/simplified-short | 102 | 431.25 ± 0.1% | not timed | not timed | 229.08 ± 0.1% | 26.78 ± 0.4% | not timed | not timed | 429.90 ± 0.2% | | 1.00 | 1.88 | 16.11 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.79 ± 0.2% | not timed | not timed | 254.79 ± 0.2% | 28.83 ± 0.0% | not timed | not timed | 588.66 ± 0.1% | | 1.00 | 2.31 | 20.42 |
| 07-unicode-character-data/parse-line | 558784 | 233.93 ± 1.9% | not timed | not timed | 172.14 ± 0.2% | 42.58 ± 5.3% | not timed | not timed | 235.14 ± 2.3% | | 0.99 | 1.36 | 5.49 |
| 08-words/all-english | 56691 | 127.70 ± 0.9% | not timed | not timed | 82.74 ± 0.1% | 11.79 ± 6.4% | not timed | not timed | 127.92 ± 0.7% | | 1.00 | 1.54 | 10.83 |
| 08-words/long-english | 839 | 623.10 ± 0.2% | not timed | not timed | 597.29 ± 0.3% | 32.33 ± 0.4% | not timed | not timed | 623.97 ± 0.4% | | 1.00 | 1.04 | 19.27 |
| 09-aws-keys/full | 0 | 440.68 ± 0.2% | not timed | not timed | 460.94 ± 0.2% | 64.55 ± 0.1% | not timed | not timed | 439.15 ± 0.2% | | 1.00 | 0.96 | 6.83 |
| 09-aws-keys/quick | 0 | 875.38 ± 0.3% | not timed | not timed | 988.31 ± 0.1% | 416.87 ± 0.6% | not timed | not timed | 874.84 ± 0.1% | | 1.00 | 0.89 | 2.10 |
| 10-bounded-repeat/letters-en | 1833 | 579.00 ± 3.4% | not timed | not timed | 516.01 ± 0.5% | 19.54 ± 0.6% | not timed | not timed | 582.45 ± 3.2% | | 0.99 | 1.12 | 29.63 |
| 10-bounded-repeat/letters-ru | 3475 | 505.18 ± 1.8% | not timed | not timed | 477.46 ± 0.0% | 22.43 ± 16.5% | not timed | not timed | 508.79 ± 2.7% | | 0.99 | 1.06 | 22.52 |
| 10-bounded-repeat/context | 53 | 85.34 ± 1.9% | not timed | not timed | 65.95 ± 0.6% | 19.81 ± 0.1% | not timed | not timed | 85.40 ± 1.7% | | 1.00 | 1.29 | 4.31 |
| 10-bounded-repeat/capitals | 11 | 633.66 ± 8.2% | not timed | not timed | 616.97 ± 0.2% | 36.65 ± 0.1% | not timed | not timed | 634.76 ± 8.2% | | 1.00 | 1.03 | 17.29 |
| 11-unstructured-to-json/extract | 600 | 57.02 ± 0.7% | not timed | not timed | 77.49 ± 0.2% | 49.12 ± 1.2% | not timed | not timed | 56.87 ± 0.7% | | 1.00 | 0.74 | 1.16 |
| 12-dictionary/single | 1 | 561.18 ± 1.0% | not timed | not timed | 560.36 ± 0.3% | 0.41 ± 0.1% | not timed | not timed | 562.39 ± 1.4% | | 1.00 | 1.00 | 1380.85 |
| 14-quadratic/1x | 100 | 21.29 ± 0.6% | not timed | not timed | 10.00 ± 0.1% | 0.97 ± 3.6% | not timed | not timed | 21.36 ± 1.3% | | 1.00 | 2.13 | 22.04 |
| 14-quadratic/2x | 200 | 17.69 ± 1.2% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 2.1% | not timed | not timed | 17.79 ± 0.7% | | 0.99 | 3.19 | 33.57 |
| 14-quadratic/10x | 1000 | 7.76 ± 0.5% | not timed | not timed | 1.21 ± 0.6% | 0.12 ± 1.9% | not timed | not timed | 7.78 ± 0.5% | | 1.00 | 6.43 | 67.16 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.19 ± 2.5% | not timed | not timed | 0.35 ± 0.7% | 0.55 ± 4.1% | not timed | not timed | 1.21 ± 1.8% | | 0.99 | 3.45 | 2.16 |
| 04-ruff-noqa/compile-real | 1 | 106.11 ± 0.9% | not timed | not timed | 13.63 ± 0.8% | 140.85 ± 2.3% | not timed | not timed | 106.46 ± 0.2% | | 1.00 | 7.78 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 13.99 ± 0.7% | not timed | not timed | 2.52 ± 0.6% | 6.52 ± 1.7% | not timed | not timed | 14.00 ± 0.5% | | 1.00 | 5.55 | 2.15 |
| 07-unicode-character-data/compile | 1 | 108.21 ± 1.2% | not timed | not timed | 25.65 ± 0.3% | 36.12 ± 3.8% | not timed | not timed | 108.17 ± 1.1% | | 1.00 | 4.22 | 3.00 |
| 09-aws-keys/compile-full | 1 | 53.21 ± 0.9% | not timed | not timed | 8.24 ± 0.5% | 23.47 ± 2.0% | not timed | not timed | 53.23 ± 0.5% | | 1.00 | 6.46 | 2.27 |
| 09-aws-keys/compile-quick | 1 | 187.91 ± 0.8% | not timed | not timed | 46.98 ± 0.2% | 133.50 ± 3.7% | not timed | not timed | 188.11 ± 0.2% | | 1.00 | 4.00 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 71.95 ± 1.4% | not timed | not timed | 11.15 ± 0.3% | 16.23 ± 12.5% | not timed | not timed | 72.12 ± 0.3% | | 1.00 | 6.45 | 4.43 |
| 10-bounded-repeat/compile-capitals | 1 | 85.18 ± 0.9% | not timed | not timed | 8.09 ± 0.1% | 23.90 ± 12.6% | not timed | not timed | 85.01 ± 0.2% | | 1.00 | 10.53 | 3.56 |
| 11-unstructured-to-json/compile | 1 | 170.32 ± 1.3% | not timed | not timed | 41.25 ± 0.3% | 68.50 ± 2.7% | not timed | not timed | 170.42 ± 0.8% | | 1.00 | 4.13 | 2.49 |
| 12-dictionary/compile-single | 1 | 0.34 ± 2.9% | not timed | not timed | 0.07 ± 9.3% | 0.09 ± 20.0% | not timed | not timed | 0.34 ± 0.6% | | 1.01 | 4.89 | 3.63 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.37 ± 0.5% | not timed | not timed | 6.35 ± 0.1% | 0.51 ± 25.3% | not timed | not timed | 7.37 ± 5.1% | | 1.00 | 1.16 | 14.52 |
| dictionary/search/english-10 | 690 | 1.16 ± 0.5% | not timed | not timed | 164.73 ± 0.6% | 0.00 ± 1.1% | not timed | not timed | 1.16 ± 0.3% | | 1.00 | 0.0070 | 406.73 |
| dictionary/search/english-15 | 15 | 566.12 ± 1.2% | not timed | not timed | 557.25 ± 0.1% | 0.37 ± 0.2% | not timed | not timed | 567.41 ± 1.1% | | 1.00 | 1.02 | 1546.78 |
| folly/awyer-inn-busted | 1 | 5591.41 ± 0.1% | not timed | not timed | 143.51 ± 0.1% | 41.29 ± 5.8% | not timed | not timed | 5614.45 ± 0.1% | | 1.00 | 38.96 | 135.42 |
| folly/literal-never-match-rare | 0 | 21110.54 ± 2.4% | not timed | not timed | 19894.83 ± 1.1% | 40820.97 ± 0.2% | not timed | not timed | 21113.38 ± 0.5% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12493.45 ± 1.6% | not timed | not timed | 19848.63 ± 0.4% | 2190.93 ± 0.8% | not timed | not timed | 12555.76 ± 1.5% | | 1.00 | 0.63 | 5.70 |
| folly/literal-never-match-tricksy | 1 | 3239.85 ± 0.4% | not timed | not timed | 4401.78 ± 0.2% | 3047.94 ± 1.9% | not timed | not timed | 3242.06 ± 0.3% | | 1.00 | 0.74 | 1.06 |
| grep/every-line | 239963 | 1314.82 ± 0.5% | not timed | not timed | 949.22 ± 1.0% | 362.29 ± 17.8% | not timed | not timed | 1322.19 ± 0.5% | | 0.99 | 1.39 | 3.63 |
| grep/long-words-ascii | 5073 | 458.47 ± 0.5% | not timed | not timed | 468.61 ± 0.2% | 46.31 ± 6.2% | not timed | not timed | 402.06 ± 0.1% | | 1.14 | 0.98 | 9.90 |
| imported/leipzig/twain | 811 | 20726.47 ± 0.7% | not timed | not timed | 19643.16 ± 0.3% | 12050.32 ± 9.2% | not timed | not timed | 20777.75 ± 0.4% | | 1.00 | 1.06 | 1.72 |
| imported/leipzig/twain-insensitive | 965 | 9045.78 ± 1.1% | not timed | not timed | 4253.28 ± 0.1% | 37.79 ± 0.2% | not timed | not timed | 9100.17 ± 0.7% | | 0.99 | 2.13 | 239.40 |
| imported/leipzig/shing | 1540 | 15167.20 ± 20.4% | not timed | not timed | 13472.55 ± 13.6% | 34.02 ± 0.1% | not timed | not timed | 15518.57 ± 2.6% | | 0.98 | 1.13 | 445.81 |
| imported/leipzig/huck-saw | 262 | 8226.20 ± 3.0% | not timed | not timed | 5601.53 ± 0.1% | 31.86 ± 0.1% | not timed | not timed | 8453.42 ± 4.0% | | 0.97 | 1.47 | 258.22 |
| imported/leipzig/word-ending-nn | 262 | 605.84 ± 0.5% | not timed | not timed | 615.78 ± 0.0% | 24.79 ± 0.3% | not timed | not timed | 605.32 ± 0.5% | | 1.00 | 0.98 | 24.44 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11184.50 ± 0.7% | not timed | not timed | 4532.46 ± 0.6% | 11.50 ± 1.1% | not timed | not timed | 11251.50 ± 2.1% | | 0.99 | 2.47 | 972.82 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7846.36 ± 1.3% | not timed | not timed | 5480.00 ± 0.2% | 16.86 ± 0.0% | not timed | not timed | 7951.87 ± 1.8% | | 0.99 | 1.43 | 465.35 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4165.26 ± 1.2% | not timed | not timed | 415.00 ± 1.1% | 11.11 ± 0.1% | not timed | not timed | 4185.59 ± 2.3% | | 1.00 | 10.04 | 374.99 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 602.81 ± 0.6% | not timed | not timed | 614.81 ± 0.1% | 11.14 ± 0.1% | not timed | not timed | 601.50 ± 0.8% | | 1.00 | 0.98 | 54.12 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 602.14 ± 0.2% | not timed | not timed | 615.98 ± 0.0% | 9.72 ± 0.1% | not timed | not timed | 602.82 ± 0.6% | | 1.00 | 0.98 | 61.98 |
| imported/leipzig/tom-river | 2 | 6488.02 ± 2.4% | not timed | not timed | 5145.32 ± 0.3% | 31.07 ± 0.1% | not timed | not timed | 6488.67 ± 10.1% | | 1.00 | 1.26 | 208.81 |
| imported/leipzig/ing | 78424 | 600.93 ± 0.9% | not timed | not timed | 571.96 ± 0.1% | 28.27 ± 2.7% | not timed | not timed | 601.01 ± 0.8% | | 1.00 | 1.05 | 21.26 |
| imported/leipzig/ing-whitespace | 55248 | 751.76 ± 0.7% | not timed | not timed | 2056.43 ± 0.9% | 20.12 ± 2.5% | not timed | not timed | 754.05 ± 1.0% | | 1.00 | 0.37 | 37.36 |
| imported/leipzig/awyer-inn | 209 | 767.72 ± 1.3% | not timed | not timed | 4242.96 ± 1.1% | 22.19 ± 0.1% | not timed | not timed | 768.24 ± 1.6% | | 1.00 | 0.18 | 34.60 |
| imported/leipzig/quotes-bounded | 8886 | 2118.89 ± 0.5% | not timed | not timed | 2996.43 ± 1.1% | 38.28 ± 0.0% | not timed | not timed | 2121.70 ± 1.0% | | 1.00 | 0.71 | 55.35 |
| imported/leipzig/non-ascii-alternate | 2 | 12796.22 ± 2.5% | not timed | not timed | 5660.13 ± 0.5% | 50.76 ± 0.1% | not timed | not timed | 12993.81 ± 2.5% | | 0.98 | 2.26 | 252.08 |
| imported/leipzig/math-symbols | 69 | 1978.71 ± 0.6% | not timed | not timed | 613.78 ± 0.1% | 36.46 ± 0.1% | not timed | not timed | 1984.74 ± 0.6% | | 1.00 | 3.22 | 54.28 |
| imported/leipzig/bounded-strings-ending-z | 0 | 585.27 ± 1.1% | not timed | not timed | 616.22 ± 0.0% | 22.53 ± 0.1% | not timed | not timed | 585.44 ± 1.9% | | 1.00 | 0.95 | 25.97 |
| imported/lh3lh3-reb/uri | 17549 | 679.24 ± 0.1% | not timed | not timed | 1072.70 ± 0.2% | 28.35 ± 2.4% | not timed | not timed | 678.61 ± 0.2% | | 1.00 | 0.63 | 23.96 |
| imported/lh3lh3-reb/email | 15057 | 673.19 ± 0.2% | not timed | not timed | 1166.35 ± 0.1% | 30.45 ± 2.4% | not timed | not timed | 674.20 ± 0.2% | | 1.00 | 0.58 | 22.10 |
| imported/lh3lh3-reb/date | 668 | 858.14 ± 0.2% | not timed | not timed | 1036.78 ± 0.1% | 51.30 ± 1.4% | not timed | not timed | 859.45 ± 0.2% | | 1.00 | 0.83 | 16.73 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.17 ± 0.2% | not timed | not timed | 423.14 ± 0.2% | 15.76 ± 1.3% | not timed | not timed | 644.76 ± 0.2% | | 1.00 | 1.52 | 40.93 |
| imported/mariomka/email | 92 | 24365.09 ± 1.2% | not timed | not timed | 29660.55 ± 0.6% | 32.81 ± 0.2% | not timed | not timed | 24400.91 ± 1.4% | | 1.00 | 0.82 | 742.60 |
| imported/mariomka/uri | 5301 | 5336.72 ± 0.8% | not timed | not timed | 6113.80 ± 0.2% | 32.79 ± 0.3% | not timed | not timed | 5375.94 ± 1.0% | | 0.99 | 0.87 | 162.74 |
| imported/mariomka/ip | 5 | 2150.60 ± 2.2% | not timed | not timed | 2965.46 ± 0.1% | 21.08 ± 0.4% | not timed | not timed | 2151.37 ± 2.4% | | 1.00 | 0.73 | 102.04 |
| imported/rsc/no-exponential | 0 | 604.36 ± 0.1% | not timed | not timed | 322.78 ± 0.4% | 23.80 ± 0.4% | not timed | not timed | 597.73 ± 0.4% | | 1.01 | 1.87 | 25.40 |
| imported/rsc/literal | 1 | 763.55 ± 2.0% | not timed | not timed | 1606.81 ± 6.0% | 186.30 ± 19.1% | not timed | not timed | 763.49 ± 3.9% | | 1.00 | 0.48 | 4.10 |
| imported/rsc/not-literal | 2 | 780.78 ± 0.2% | not timed | not timed | 737.04 ± 0.3% | 46.18 ± 6.2% | not timed | not timed | 782.91 ± 6.2% | | 1.00 | 1.06 | 16.91 |
| imported/rsc/match-class | 1 | 1441.55 ± 0.4% | not timed | not timed | 1642.04 ± 0.2% | 58.85 ± 7.1% | not timed | not timed | 1441.00 ± 2.7% | | 1.00 | 0.88 | 24.49 |
| imported/rsc/match-class-in-range | 1 | 1446.71 ± 0.4% | not timed | not timed | 2358.51 ± 5.1% | 59.97 ± 7.3% | not timed | not timed | 1440.85 ± 3.6% | | 1.00 | 0.61 | 24.13 |
| imported/rsc/match-class-unicode | 1 | 548.00 ± 0.1% | not timed | not timed | 515.76 ± 0.1% | 72.51 ± 0.1% | not timed | not timed | 548.36 ± 0.1% | | 1.00 | 1.06 | 7.56 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1436.56 ± 0.2% | not timed | not timed | 956.06 ± 0.2% | 228.34 ± 0.3% | not timed | not timed | 1440.00 ± 0.2% | | 1.00 | 1.50 | 6.29 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21575.05 ± 0.2% | not timed | not timed | 14435.73 ± 0.2% | 3425.55 ± 0.6% | not timed | not timed | 21603.82 ± 0.1% | | 1.00 | 1.49 | 6.30 |
| imported/rsc/anchored-literal-short-match | 4 | 712.66 ± 3.9% | not timed | not timed | 493.13 ± 0.5% | 83.16 ± 12.4% | not timed | not timed | 714.75 ± 2.0% | | 1.00 | 1.45 | 8.57 |
| imported/rsc/anchored-literal-long-match | 4 | 10675.78 ± 0.7% | not timed | not timed | 7316.54 ± 0.3% | 1224.01 ± 4.8% | not timed | not timed | 10654.50 ± 1.5% | | 1.00 | 1.46 | 8.72 |
| imported/rsc/one-pass-short | 17 | 373.46 ± 10.9% | not timed | not timed | 213.96 ± 0.1% | 31.48 ± 13.4% | not timed | not timed | 373.43 ± 1.6% | | 1.00 | 1.75 | 11.86 |
| imported/rsc/one-pass-short-not | 17 | 280.55 ± 9.6% | not timed | not timed | 226.33 ± 0.2% | 29.99 ± 10.5% | not timed | not timed | 281.32 ± 2.1% | | 1.00 | 1.24 | 9.35 |
| imported/rsc/one-pass-long-prefix | 26 | 363.02 ± 1.7% | not timed | not timed | 282.09 ± 0.2% | 98.65 ± 16.2% | not timed | not timed | 363.66 ± 2.7% | | 1.00 | 1.29 | 3.68 |
| imported/rsc/one-pass-long-prefix-not | 26 | 355.73 ± 8.9% | not timed | not timed | 284.43 ± 0.6% | 64.89 ± 15.0% | not timed | not timed | 362.77 ± 1.6% | | 0.98 | 1.25 | 5.48 |
| imported/rsc/long-needle1 | 31 | 22191.90 ± 0.1% | not timed | not timed | 20166.95 ± 0.1% | 3.76 ± 0.2% | not timed | not timed | 22204.29 ± 0.1% | | 1.00 | 1.10 | 5904.25 |
| imported/rsc/long-needle2 | 31 | 22326.95 ± 0.1% | not timed | not timed | 216.12 ± 0.1% | 3.76 ± 0.2% | not timed | not timed | 22332.85 ± 0.3% | | 1.00 | 103.31 | 5940.72 |
| imported/rsc/easy0-32 | 26 | 1078.15 ± 3.4% | not timed | not timed | 1634.96 ± 2.4% | 148.36 ± 16.7% | not timed | not timed | 1077.19 ± 0.4% | | 1.00 | 0.66 | 7.27 |
| imported/rsc/easy0-1k | 26 | 14910.04 ± 2.0% | not timed | not timed | 12741.07 ± 0.8% | 2299.59 ± 11.1% | not timed | not timed | 14930.71 ± 0.2% | | 1.00 | 1.17 | 6.48 |
| imported/rsc/easy0-32k | 26 | 23041.60 ± 0.3% | not timed | not timed | 20337.45 ± 0.2% | 18736.15 ± 0.4% | not timed | not timed | 23055.71 ± 0.0% | | 1.00 | 1.13 | 1.23 |
| imported/rsc/easy0-1mb | 26 | 21907.42 ± 1.3% | not timed | not timed | 19857.33 ± 2.3% | 37293.30 ± 3.5% | not timed | not timed | 21631.85 ± 2.2% | | 1.01 | 1.10 | 0.59 |
| imported/rsc/easy1-32 | 19 | 808.92 ± 2.4% | not timed | not timed | 656.28 ± 0.3% | 128.98 ± 22.3% | not timed | not timed | 808.28 ± 6.8% | | 1.00 | 1.23 | 6.27 |
| imported/rsc/easy1-1k | 19 | 16555.72 ± 2.6% | not timed | not timed | 13023.49 ± 0.2% | 2484.98 ± 17.1% | not timed | not timed | 16608.61 ± 0.1% | | 1.00 | 1.27 | 6.66 |
| imported/rsc/easy1-32k | 19 | 517923.17 ± 0.2% | not timed | not timed | 409711.49 ± 0.2% | 20451.25 ± 0.2% | not timed | not timed | 519034.48 ± 0.2% | | 1.00 | 1.26 | 25.32 |
| imported/rsc/easy1-1mb | 19 | 16664770.15 ± 0.2% | not timed | not timed | 13215967.21 ± 0.2% | 38955.14 ± 1.7% | not timed | not timed | 16663857.64 ± 0.2% | | 1.00 | 1.26 | 427.79 |
| imported/rsc/medium-32 | 27 | 770.81 ± 2.0% | not timed | not timed | 644.30 ± 0.1% | 69.94 ± 11.9% | not timed | not timed | 776.90 ± 0.5% | | 0.99 | 1.20 | 11.02 |
| imported/rsc/medium-1k | 27 | 13694.58 ± 0.5% | not timed | not timed | 11294.94 ± 0.2% | 72.23 ± 0.2% | not timed | not timed | 13759.98 ± 0.5% | | 1.00 | 1.21 | 189.59 |
| imported/rsc/medium-32k | 27 | 427778.00 ± 0.5% | not timed | not timed | 358145.31 ± 0.3% | 48.65 ± 0.1% | not timed | not timed | 430391.99 ± 0.5% | | 0.99 | 1.19 | 8793.00 |
| imported/rsc/medium-1mb | 27 | 13628779.92 ± 0.4% | not timed | not timed | 11432307.46 ± 0.3% | 48.45 ± 0.1% | not timed | not timed | 13758545.02 ± 0.5% | | 0.99 | 1.19 | 281299.99 |
| imported/rsc/hard-32 | 58 | 419.12 ± 1.9% | not timed | not timed | 370.09 ± 0.2% | 49.61 ± 8.4% | not timed | not timed | 419.18 ± 0.3% | | 1.00 | 1.13 | 8.45 |
| imported/rsc/hard-1k | 27 | 13354.97 ± 0.5% | not timed | not timed | 11648.04 ± 0.9% | 40.70 ± 0.2% | not timed | not timed | 13358.74 ± 0.6% | | 1.00 | 1.15 | 328.12 |
| imported/rsc/hard-32k | 27 | 415468.77 ± 0.6% | not timed | not timed | 361285.20 ± 0.1% | 29.40 ± 0.0% | not timed | not timed | 416790.06 ± 0.4% | | 1.00 | 1.15 | 14131.81 |
| imported/rsc/hard-1mb | 51 | 8344365.13 ± 0.2% | not timed | not timed | 7284620.45 ± 0.2% | 29.46 ± 0.2% | not timed | not timed | 8342111.62 ± 0.5% | | 1.00 | 1.15 | 283261.98 |
| imported/rsc/reallyhard0-32 | 58 | 267.46 ± 2.7% | not timed | not timed | 223.49 ± 0.1% | 49.52 ± 8.4% | not timed | not timed | 266.73 ± 0.4% | | 1.00 | 1.20 | 5.40 |
| imported/rsc/reallyhard0-1k | 27 | 592.79 ± 0.0% | not timed | not timed | 586.18 ± 0.1% | 40.81 ± 0.1% | not timed | not timed | 589.77 ± 0.2% | | 1.01 | 1.01 | 14.53 |
| imported/rsc/reallyhard0-32k | 27 | 610.88 ± 0.1% | not timed | not timed | 612.96 ± 0.1% | 29.43 ± 0.1% | not timed | not timed | 609.91 ± 0.5% | | 1.00 | 1.00 | 20.76 |
| imported/rsc/reallyhard0-1mb | 51 | 591.62 ± 0.6% | not timed | not timed | 618.03 ± 0.1% | 29.40 ± 0.2% | not timed | not timed | 590.85 ± 1.0% | | 1.00 | 0.96 | 20.12 |
| imported/rsc/reallyreallyhard0-32 | 47 | 288.38 ± 1.7% | not timed | not timed | 197.19 ± 0.1% | 60.60 ± 11.1% | not timed | not timed | 288.48 ± 1.7% | | 1.00 | 1.46 | 4.76 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6807.96 ± 0.3% | not timed | not timed | 6044.30 ± 0.1% | 34.14 ± 1.3% | not timed | not timed | 6779.96 ± 0.0% | | 1.00 | 1.13 | 199.39 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21507.54 ± 0.2% | not timed | not timed | 19214.10 ± 0.2% | 25.03 ± 3.9% | not timed | not timed | 21505.80 ± 0.0% | | 1.00 | 1.12 | 859.13 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21730.34 ± 0.9% | not timed | not timed | 19744.12 ± 0.6% | 24.65 ± 0.1% | not timed | not timed | 21676.38 ± 0.6% | | 1.00 | 1.10 | 881.61 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.41 ± 1.5% | not timed | not timed | 212.65 ± 0.1% | 58.44 ± 10.6% | not timed | not timed | 282.34 ± 1.3% | | 1.00 | 1.33 | 4.83 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5892.94 ± 0.1% | not timed | not timed | 6238.66 ± 0.2% | 33.76 ± 1.0% | not timed | not timed | 5877.56 ± 0.0% | | 1.00 | 0.94 | 174.57 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21430.65 ± 0.1% | not timed | not timed | 19256.45 ± 0.2% | 24.54 ± 4.6% | not timed | not timed | 21429.44 ± 0.1% | | 1.00 | 1.11 | 873.28 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21382.41 ± 0.5% | not timed | not timed | 19834.86 ± 0.5% | 24.89 ± 3.9% | not timed | not timed | 21376.88 ± 0.5% | | 1.00 | 1.08 | 859.07 |
| imported/sherlock/name-sherlock | 776 | 20010.01 ± 3.6% | not timed | not timed | 18737.93 ± 0.3% | 10044.74 ± 26.7% | not timed | not timed | 20020.52 ± 2.6% | | 1.00 | 1.07 | 1.99 |
| imported/sherlock/name-holmes | 2766 | 15187.54 ± 1.4% | not timed | not timed | 15723.74 ± 0.9% | 3229.79 ± 14.8% | not timed | not timed | 15363.72 ± 1.6% | | 0.99 | 0.97 | 4.70 |
| imported/sherlock/name-sherlock-holmes | 1365 | 20007.98 ± 2.2% | not timed | not timed | 18730.46 ± 0.1% | 8043.77 ± 48.8% | not timed | not timed | 20022.51 ± 2.3% | | 1.00 | 1.07 | 2.49 |
| imported/sherlock/name-sherlock-casei | 816 | 15657.04 ± 0.2% | not timed | not timed | 4009.51 ± 0.1% | 32.58 ± 0.5% | not timed | not timed | 15643.78 ± 0.1% | | 1.00 | 3.90 | 480.52 |
| imported/sherlock/name-holmes-casei | 2802 | 9344.94 ± 5.1% | not timed | not timed | 3314.79 ± 0.2% | 37.63 ± 11.1% | not timed | not timed | 9393.42 ± 5.5% | | 0.99 | 2.82 | 248.36 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13101.63 ± 4.2% | not timed | not timed | 3948.00 ± 0.1% | 32.56 ± 0.2% | not timed | not timed | 13131.67 ± 0.9% | | 1.00 | 3.32 | 402.34 |
| imported/sherlock/name-whitespace | 1461 | 15347.21 ± 2.3% | not timed | not timed | 14590.51 ± 0.1% | 7355.22 ± 22.5% | not timed | not timed | 15323.96 ± 1.8% | | 1.00 | 1.05 | 2.09 |
| imported/sherlock/name-alt1 | 1142 | 11614.42 ± 2.4% | not timed | not timed | 16504.90 ± 1.8% | 4060.96 ± 36.5% | not timed | not timed | 11644.04 ± 2.5% | | 1.00 | 0.70 | 2.86 |
| imported/sherlock/name-alt2 | 3542 | 8961.43 ± 0.2% | not timed | not timed | 3826.49 ± 0.1% | 31.35 ± 0.3% | not timed | not timed | 8963.43 ± 0.3% | | 1.00 | 2.34 | 285.85 |
| imported/sherlock/name-alt3 | 4507 | 5563.38 ± 0.4% | not timed | not timed | 3625.71 ± 0.4% | 9.94 ± 4.4% | not timed | not timed | 5555.26 ± 0.3% | | 1.00 | 1.53 | 559.81 |
| imported/sherlock/name-alt3-casei | 4593 | 1523.38 ± 2.3% | not timed | not timed | 285.46 ± 0.1% | 6.47 ± 0.3% | not timed | not timed | 1526.95 ± 1.5% | | 1.00 | 5.34 | 235.32 |
| imported/sherlock/name-alt4 | 3686 | 6392.95 ± 0.2% | not timed | not timed | 3776.20 ± 0.2% | 31.34 ± 0.2% | not timed | not timed | 6396.06 ± 0.1% | | 1.00 | 1.69 | 203.99 |
| imported/sherlock/name-alt4-casei | 4254 | 2799.48 ± 2.0% | not timed | not timed | 2575.38 ± 0.4% | 19.84 ± 0.1% | not timed | not timed | 2800.49 ± 0.9% | | 1.00 | 1.09 | 141.13 |
| imported/sherlock/name-alt5 | 4028 | 6424.10 ± 0.3% | not timed | not timed | 3750.35 ± 0.2% | 21.80 ± 0.3% | not timed | not timed | 6413.07 ± 0.2% | | 1.00 | 1.71 | 294.73 |
| imported/sherlock/name-alt5-casei | 4104 | 3509.97 ± 1.9% | not timed | not timed | 2227.90 ± 0.1% | 14.40 ± 0.1% | not timed | not timed | 3522.65 ± 1.1% | | 1.00 | 1.58 | 243.81 |
| imported/sherlock/no-match-uncommon | 0 | 21853.86 ± 0.3% | not timed | not timed | 19799.63 ± 0.5% | 36887.95 ± 0.6% | not timed | not timed | 21841.22 ± 0.3% | | 1.00 | 1.10 | 0.59 |
| imported/sherlock/no-match-common | 0 | 21729.86 ± 0.1% | not timed | not timed | 19656.24 ± 0.2% | 1277.57 ± 0.3% | not timed | not timed | 21727.76 ± 0.2% | | 1.00 | 1.11 | 17.01 |
| imported/sherlock/no-match-really-common | 0 | 16119.49 ± 2.2% | not timed | not timed | 18957.02 ± 0.4% | 1276.40 ± 0.3% | not timed | not timed | 16230.17 ± 5.8% | | 0.99 | 0.85 | 12.63 |
| imported/sherlock/the-lower | 21654 | 2322.30 ± 1.1% | not timed | not timed | 2332.76 ± 0.3% | 234.49 ± 16.0% | not timed | not timed | 2328.89 ± 10.0% | | 1.00 | 1.00 | 9.90 |
| imported/sherlock/the-upper | 2223 | 12711.52 ± 1.2% | not timed | not timed | 13649.55 ± 0.9% | 2683.18 ± 1.7% | not timed | not timed | 12838.60 ± 1.9% | | 0.99 | 0.93 | 4.74 |
| imported/sherlock/the-casei | 23961 | 2013.58 ± 1.2% | not timed | not timed | 1321.29 ± 0.3% | 34.70 ± 29.2% | not timed | not timed | 2013.09 ± 0.4% | | 1.00 | 1.52 | 58.04 |
| imported/sherlock/everything-greedy | 581881 | 283.23 ± 8.2% | not timed | not timed | 166.11 ± 0.4% | 28.72 ± 12.8% | not timed | not timed | 283.39 ± 0.2% | | 1.00 | 1.71 | 9.86 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.55 ± 0.1% | not timed | not timed | 213.10 ± 0.3% | 32.98 ± 0.2% | not timed | not timed | 462.13 ± 0.1% | | 1.00 | 2.17 | 14.03 |
| imported/sherlock/letters | 447175 | 62.32 ± 1.5% | not timed | not timed | 33.05 ± 0.1% | 6.44 ± 31.8% | not timed | not timed | 62.41 ± 0.9% | | 1.00 | 1.89 | 9.67 |
| imported/sherlock/letters-upper | 14180 | 452.76 ± 1.3% | not timed | not timed | 371.14 ± 0.1% | 29.49 ± 23.0% | not timed | not timed | 453.03 ± 0.1% | | 1.00 | 1.22 | 15.35 |
| imported/sherlock/letters-lower | 432995 | 63.41 ± 0.8% | not timed | not timed | 33.78 ± 0.2% | 5.67 ± 33.5% | not timed | not timed | 63.56 ± 1.2% | | 1.00 | 1.88 | 11.18 |
| imported/sherlock/words | 447639 | 115.27 ± 0.7% | not timed | not timed | 78.00 ± 0.3% | 13.52 ± 20.7% | not timed | not timed | 115.47 ± 0.6% | | 1.00 | 1.48 | 8.53 |
| imported/sherlock/before-holmes | 4073 | 10340.94 ± 0.4% | not timed | not timed | 8480.12 ± 0.4% | 23.99 ± 1.1% | not timed | not timed | 10340.49 ± 0.3% | | 1.00 | 1.22 | 431.06 |
| imported/sherlock/before-after-holmes | 2593 | 9929.15 ± 0.7% | not timed | not timed | 9527.70 ± 0.5% | 24.09 ± 0.9% | not timed | not timed | 9922.03 ± 2.0% | | 1.00 | 1.04 | 412.25 |
| imported/sherlock/holmes-cochar-watson | 150 | 5194.70 ± 0.4% | not timed | not timed | 3428.12 ± 0.1% | 30.94 ± 0.1% | not timed | not timed | 5190.79 ± 0.3% | | 1.00 | 1.52 | 167.91 |
| imported/sherlock/holmes-coword-watson | 14309 | 1189.44 ± 0.6% | not timed | not timed | 1125.58 ± 0.3% | 6.77 ± 0.4% | not timed | not timed | 1188.95 ± 0.2% | | 1.00 | 1.06 | 175.64 |
| imported/sherlock/quotes | 14437 | 1389.22 ± 0.2% | not timed | not timed | 1755.23 ± 0.8% | 35.05 ± 0.1% | not timed | not timed | 1398.09 ± 0.3% | | 0.99 | 0.79 | 39.63 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 609.51 ± 0.2% | not timed | not timed | 16201.26 ± 0.2% | 36.56 ± 0.1% | not timed | not timed | 609.55 ± 0.1% | | 1.00 | 0.0376 | 16.67 |
| imported/sherlock/word-ending-n | 35297 | 481.34 ± 1.0% | not timed | not timed | 408.61 ± 0.2% | 23.39 ± 20.6% | not timed | not timed | 482.45 ± 0.3% | | 1.00 | 1.18 | 20.58 |
| imported/sherlock/repeated-class-negation | 2130 | 14817.47 ± 0.7% | not timed | not timed | 11006.89 ± 0.4% | 11.57 ± 0.3% | not timed | not timed | 14799.37 ± 0.8% | | 1.00 | 1.35 | 1280.45 |
| imported/sherlock/ing-suffix | 20547 | 566.49 ± 0.2% | not timed | not timed | 516.04 ± 0.2% | 28.87 ± 0.1% | not timed | not timed | 567.25 ± 0.1% | | 1.00 | 1.10 | 19.62 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 607.52 ± 0.7% | not timed | not timed | 2101.54 ± 0.3% | 20.54 ± 0.2% | not timed | not timed | 608.10 ± 0.4% | | 1.00 | 0.29 | 29.57 |
| opt/accelerate/whole-line | 239963 | 457.05 ± 0.1% | not timed | not timed | 372.15 ± 0.2% | 92.82 ± 17.2% | not timed | not timed | 457.59 ± 0.4% | | 1.00 | 1.23 | 4.92 |
| opt/accelerate/non-dna | 16745 | 425.60 ± 0.7% | not timed | not timed | 401.33 ± 0.1% | 29.46 ± 19.3% | not timed | not timed | 427.47 ± 1.9% | | 1.00 | 1.06 | 14.45 |
| opt/backtrack/words-english | 40536 | 136.77 ± 0.3% | not timed | not timed | 94.63 ± 0.1% | 19.78 ± 8.7% | not timed | not timed | 135.67 ± 2.0% | | 1.01 | 1.45 | 6.91 |
| opt/fixed-length/too-small-ascii | 0 | 318.78 ± 0.3% | not timed | not timed | 704.39 ± 2.5% | 79.89 ± 0.9% | not timed | not timed | 318.07 ± 0.3% | | 1.00 | 0.45 | 3.99 |
| opt/fixed-length/too-big-ascii | 0 | 3481.03 ± 0.1% | not timed | not timed | 5839.44 ± 0.1% | 126.78 ± 0.9% | not timed | not timed | 3464.99 ± 0.1% | | 1.00 | 0.60 | 27.46 |
| opt/fixed-length/go33484-1 | 0 | 668991.46 ± 0.3% | not timed | not timed | 1122897.10 ± 0.5% | 61408.46 ± 0.4% | not timed | not timed | 667886.22 ± 0.2% | | 1.00 | 0.60 | 10.89 |
| opt/fixed-length/go33484-2 | 0 | 668565.99 ± 0.1% | not timed | not timed | 1122043.26 ± 0.4% | 32266.56 ± 0.7% | not timed | not timed | 667613.23 ± 0.2% | | 1.00 | 0.60 | 20.72 |
| opt/fixed-length/go33484-3 | 0 | 2418.07 ± 2.7% | not timed | not timed | 111981.22 ± 0.5% | 765.17 ± 0.3% | not timed | not timed | 2477.32 ± 4.3% | | 0.98 | 0.0216 | 3.16 |
| opt/literal-alt/one-pattern | 1 | 551.34 ± 1.6% | not timed | not timed | 540.84 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 551.37 ± 1.2% | | 1.00 | 1.02 | 1380.23 |
| opt/onepass/fn-predicate | 916 | 372.54 ± 0.6% | not timed | not timed | 333.93 ± 0.2% | 201.39 ± 14.6% | not timed | not timed | 372.91 ± 0.9% | | 1.00 | 1.12 | 1.85 |
| opt/onepass/first-three-words-english | 35128 | 174.49 ± 9.4% | not timed | not timed | 201.19 ± 0.1% | 81.95 ± 11.5% | not timed | not timed | 176.26 ± 9.9% | | 0.99 | 0.87 | 2.13 |
| opt/prefilter/literal-english | 1 | 20371.66 ± 0.7% | not timed | not timed | 19498.59 ± 0.8% | 17479.38 ± 0.3% | not timed | not timed | 20390.17 ± 0.8% | | 1.00 | 1.04 | 1.17 |
| opt/prefilter/literal-casei-english | 1 | 14467.83 ± 0.7% | not timed | not timed | 4312.19 ± 0.2% | 32.76 ± 0.5% | not timed | not timed | 14459.46 ± 0.5% | | 1.00 | 3.36 | 441.66 |
| opt/prefilter/literal-russian | 1 | 21144.09 ± 1.6% | not timed | not timed | 19628.02 ± 1.2% | 3326.97 ± 0.2% | not timed | not timed | 21134.18 ± 1.2% | | 1.00 | 1.08 | 6.36 |
| opt/prefilter/literal-casei-russian | 1 | 8576.92 ± 0.6% | not timed | not timed | 3887.84 ± 0.3% | 31.71 ± 0.4% | not timed | not timed | 8574.25 ± 0.8% | | 1.00 | 2.21 | 270.50 |
| opt/prefilter/rust-functions | 948 | 6799.97 ± 0.7% | not timed | not timed | 8943.73 ± 0.2% | 1860.64 ± 0.4% | not timed | not timed | 6787.89 ± 0.8% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 30039680.96 ± 0.1% | not timed | not timed | 21726543.57 ± 0.1% | 50.37 ± 0.2% | not timed | not timed | 30141765.15 ± 0.1% | | 1.00 | 1.38 | 596386.21 |
| opt/reverse-inner/holmes | 2593 | 9939.27 ± 1.0% | not timed | not timed | 9493.81 ± 0.2% | 24.08 ± 0.8% | not timed | not timed | 9947.02 ± 0.4% | | 1.00 | 1.05 | 412.70 |
| opt/reverse-inner/email | 47 | 36346.49 ± 1.2% | not timed | not timed | 44805.17 ± 0.6% | 32.47 ± 0.3% | not timed | not timed | 36712.00 ± 2.0% | | 0.99 | 0.81 | 1119.43 |
| opt/reverse-inner/factored-prefix | 3542 | 601.13 ± 0.1% | not timed | not timed | 597.40 ± 0.2% | 11.88 ± 0.4% | not timed | not timed | 600.35 ± 0.1% | | 1.00 | 1.01 | 50.62 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5557.16 ± 0.2% | not timed | not timed | 612.66 ± 0.4% | 75.18 ± 0.1% | not timed | not timed | 5532.56 ± 0.1% | | 1.00 | 9.07 | 73.92 |
| opt/reverse-inner/no-quadratic-forward | 0 | 684.52 ± 1.6% | not timed | not timed | 287.90 ± 0.1% | 24.79 ± 0.1% | not timed | not timed | 685.08 ± 1.8% | | 1.00 | 2.38 | 27.61 |
| opt/reverse-suffix/holmes | 4073 | 10358.16 ± 0.5% | not timed | not timed | 8459.70 ± 0.4% | 24.05 ± 0.7% | not timed | not timed | 10368.63 ± 0.2% | | 1.00 | 1.22 | 430.74 |
| opt/reverse-suffix/no-quadratic | 0 | 5533.14 ± 0.0% | not timed | not timed | 616.86 ± 0.5% | 75.15 ± 0.3% | not timed | not timed | 5561.94 ± 0.0% | | 0.99 | 8.97 | 73.63 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.43 ± 2.6% | not timed | not timed | 132.60 ± 0.3% | 13.41 ± 16.4% | not timed | not timed | 122.17 ± 1.2% | | 0.99 | 0.91 | 8.98 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 122.08 ± 2.2% | not timed | not timed | 130.64 ± 0.1% | 13.33 ± 14.7% | not timed | not timed | 122.26 ± 3.5% | | 1.00 | 0.93 | 9.16 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.2% | not timed | not timed | 0.55 ± 0.4% | 112.28 ± 1.7% | not timed | not timed | 0.28 ± 11.7% | | 0.99 | 0.50 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 317.76 ± 0.2% | not timed | not timed | 293.65 ± 0.2% | 103.16 ± 0.2% | not timed | not timed | 316.35 ± 0.1% | | 1.00 | 1.08 | 3.08 |
| reported/i13-subset-regex/original-ascii | 4094 | 11129.73 ± 1.0% | not timed | not timed | 4501.39 ± 1.9% | 11.36 ± 0.2% | not timed | not timed | 11179.22 ± 0.9% | | 1.00 | 2.47 | 979.88 |
| reported/i13-subset-regex/original-unicode | 4094 | 11024.89 ± 1.0% | not timed | not timed | 250.26 ± 3.4% | 11.50 ± 0.2% | not timed | not timed | 11139.58 ± 1.5% | | 0.99 | 44.05 | 959.08 |
| reported/i13-subset-regex/big-ascii | 1955 | 10666.40 ± 1.5% | not timed | not timed | 67.90 ± 3.7% | 9.86 ± 0.1% | not timed | not timed | 10704.24 ± 1.0% | | 1.00 | 157.08 | 1082.24 |
| reported/i13-subset-regex/big-unicode | 1955 | 10609.74 ± 2.2% | not timed | not timed | 12.21 ± 54.9% | 9.84 ± 1.4% | not timed | not timed | 10705.08 ± 1.2% | | 0.99 | 869.00 | 1078.44 |
| reported/i13-subset-regex/huge-ascii | 55 | 9927.45 ± 2.9% | not timed | not timed | 10.99 ± 0.1% | 8.75 ± 0.4% | not timed | not timed | 10072.53 ± 3.1% | | 0.99 | 903.08 | 1134.95 |
| reported/i13-subset-regex/huge-unicode | 55 | 9839.01 ± 3.1% | not timed | not timed | 10.95 ± 0.3% | 8.74 ± 0.2% | not timed | not timed | 9847.87 ± 3.2% | | 1.00 | 898.50 | 1125.67 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.56 ± 0.1% | not timed | not timed | 10.98 ± 0.1% | 8.73 ± 1.0% | not timed | not timed | 3.56 ± 0.0% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.05 ± 0.1% | not timed | not timed | 10.98 ± 0.3% | 8.75 ± 0.3% | not timed | not timed | 5.02 ± 0.1% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 487.23 ± 0.4% | not timed | not timed | 104.38 ± 0.5% | 6.64 ± 0.3% | not timed | not timed | 486.38 ± 0.3% | | 1.00 | 4.67 | 73.35 |
| reported/i787-keywords/opt-ascii | 5674 | 488.69 ± 0.4% | not timed | not timed | 277.07 ± 0.2% | 10.27 ± 0.2% | not timed | not timed | 489.03 ± 0.5% | | 1.00 | 1.76 | 47.57 |
| slow/quadratic-regex-1x | 100 | 7.12 ± 0.1% | not timed | not timed | 4.96 ± 0.3% | 0.05 ± 0.5% | not timed | not timed | 7.14 ± 0.3% | | 1.00 | 1.44 | 143.93 |
| slow/quadratic-regex-2x | 199 | 3.44 ± 0.3% | not timed | not timed | 2.76 ± 0.3% | 0.01 ± 0.2% | not timed | not timed | 3.43 ± 0.2% | | 1.00 | 1.24 | 269.47 |
| slow/quadratic-haystack-1x | 100 | 21.18 ± 6.5% | not timed | not timed | 10.02 ± 0.3% | 1.01 ± 13.3% | not timed | not timed | 21.28 ± 1.8% | | 1.00 | 2.11 | 20.98 |
| slow/quadratic-haystack-2x | 200 | 17.76 ± 1.1% | not timed | not timed | 5.55 ± 0.1% | 0.55 ± 0.8% | not timed | not timed | 17.83 ± 12.7% | | 1.00 | 3.20 | 32.39 |
| unicode/codepoints/any-one | 1112064 | 291.89 ± 1.9% | not timed | not timed | 174.57 ± 0.1% | 17.70 ± 17.2% | not timed | not timed | 291.33 ± 0.4% | | 1.00 | 1.67 | 16.49 |
| unicode/codepoints/any-all | 4382592 | 270.37 ± 0.5% | not timed | not timed | 246.70 ± 0.3% | 117.50 ± 0.1% | not timed | not timed | 270.89 ± 0.3% | | 1.00 | 1.10 | 2.30 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.80 ± 1.2% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 604.66 ± 0.4% | not timed | not timed | 616.03 ± 0.2% | 135.42 ± 0.2% | not timed | not timed | 602.95 ± 0.4% | | 1.00 | 0.98 | 4.47 |
| unicode/overlapping-words/ascii | 6156 | 31.50 ± 0.4% | not timed | not timed | 38.35 ± 0.2% | 3.92 ± 0.9% | not timed | not timed | 31.61 ± 0.3% | | 1.00 | 0.82 | 8.03 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 0.2% | not timed | not timed | 4.46 ± 0.2% | 2.36 ± 0.7% | not timed | not timed | 1.45 ± 0.1% | | 1.00 | 0.32 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.6% | not timed | not timed | 4.13 ± 0.3% | 6.31 ± 9.3% | not timed | not timed | 1.29 ± 0.1% | | 1.00 | 0.31 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 126.61 ± 8.1% | not timed | not timed | 82.72 ± 0.2% | 11.86 ± 21.5% | not timed | not timed | 128.56 ± 0.6% | | 0.98 | 1.53 | 10.68 |
| unicode/word/boundary-long-english | 3466 | 615.29 ± 0.1% | not timed | not timed | 605.60 ± 0.2% | 32.46 ± 0.5% | not timed | not timed | 615.07 ± 0.3% | | 1.00 | 1.02 | 18.95 |
| unicode/word/around-holmes-english | 27 | 19610.20 ± 0.1% | not timed | not timed | 19000.29 ± 0.4% | 22.10 ± 0.9% | not timed | not timed | 19599.73 ± 0.5% | | 1.00 | 1.03 | 887.50 |
| wild/bibleref/long | 874 | 563.67 ± 0.4% | not timed | not timed | 584.58 ± 0.1% | 6.82 ± 0.2% | not timed | not timed | 563.82 ± 0.2% | | 1.00 | 0.96 | 82.59 |
| wild/bibleref/short | 30 | 24.97 ± 2.7% | not timed | not timed | 31.01 ± 0.4% | 14.50 ± 16.3% | not timed | not timed | 25.61 ± 7.9% | | 0.97 | 0.81 | 1.72 |
| wild/bibleref/line | 874 | 393.10 ± 1.7% | not timed | not timed | 212.41 ± 0.2% | 9.07 ± 11.6% | not timed | not timed | 392.91 ± 0.2% | | 1.00 | 1.85 | 43.33 |
| wild/caddy/caddy | 6 | 417.66 ± 2.4% | not timed | not timed | 247.16 ± 0.3% | 68.17 ± 14.4% | not timed | not timed | 418.84 ± 0.2% | | 1.00 | 1.69 | 6.13 |
| wild/dot-star-capture/rust-src-tools | 6 | 1071.33 ± 0.6% | not timed | not timed | 344.38 ± 0.2% | 13.51 ± 0.1% | not timed | not timed | 1072.08 ± 0.4% | | 1.00 | 3.11 | 79.30 |
| wild/ruff/noqa | 84 | 435.89 ± 0.2% | not timed | not timed | 458.45 ± 0.2% | 19.82 ± 2.1% | not timed | not timed | 434.11 ± 0.1% | | 1.00 | 0.95 | 22.00 |
| wild/ruff/unnecessary-coding-comment | 16 | 958.92 ± 0.5% | not timed | not timed | 702.97 ± 0.3% | 134.51 ± 12.3% | not timed | not timed | 954.80 ± 0.4% | | 1.00 | 1.36 | 7.13 |
| wild/ruff/string-quote-prefix | 2972 | 1362.60 ± 0.7% | not timed | not timed | 406.64 ± 0.1% | 313.24 ± 27.1% | not timed | not timed | 1359.75 ± 0.7% | | 1.00 | 3.35 | 4.35 |
| wild/ruff/space-around-operator | 1224378 | 219.89 ± 2.0% | not timed | not timed | 186.32 ± 0.1% | 18.26 ± 1.5% | not timed | not timed | 220.32 ± 1.3% | | 1.00 | 1.18 | 12.04 |
| wild/ruff/shebang | 282 | 988.19 ± 0.5% | not timed | not timed | 330.94 ± 0.2% | 120.34 ± 3.5% | not timed | not timed | 988.99 ± 0.5% | | 1.00 | 2.99 | 8.21 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13797.56 ± 0.3% | not timed | not timed | 13850.79 ± 0.4% | 6946.76 ± 1.1% | not timed | not timed | 13799.27 ± 0.4% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12844.75 ± 0.4% | not timed | not timed | 13498.99 ± 0.2% | 6408.95 ± 0.7% | not timed | not timed | 12826.00 ± 0.3% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13172.76 ± 0.3% | not timed | not timed | 13651.52 ± 0.3% | 6689.94 ± 35.8% | not timed | not timed | 13191.78 ± 4.6% | | 1.00 | 0.96 | 1.97 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9553.10 ± 0.2% | not timed | not timed | 13590.79 ± 0.5% | 6771.31 ± 0.3% | not timed | not timed | 9562.77 ± 0.3% | | 1.00 | 0.70 | 1.41 |
| wild/url/search | 234965 | 122.55 ± 14.5% | not timed | not timed | 65.58 ± 1.2% | 2.23 ± 0.7% | not timed | not timed | 122.59 ± 13.7% | | 1.00 | 1.87 | 54.86 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 3.0% | not timed | not timed | 0.01 ± 2.2% | 0.01 ± 20.9% | not timed | not timed | 0.03 ± 2.4% | | 1.01 | 3.09 | 4.04 |
| dictionary/compile/english-15 | 1 | 0.34 ± 2.1% | not timed | not timed | 0.07 ± 1.1% | 0.11 ± 23.9% | not timed | not timed | 0.34 ± 2.8% | | 1.01 | 4.93 | 3.21 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 16.7% | not timed | not timed | 0.02 ± 1.5% | 35.56 ± 9.6% | not timed | not timed | 0.25 ± 2.5% | | 1.00 | 12.94 | 0.0069 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.29 ± 1.9% | not timed | not timed | 11.61 ± 0.2% | 57.29 ± 22.2% | not timed | not timed | 47.50 ± 6.5% | | 1.00 | 4.07 | 0.83 |
| reported/i787-keywords/compile | 1 | 35.37 ± 4.5% | not timed | not timed | 2.11 ± 0.5% | 16.43 ± 38.7% | not timed | not timed | 35.41 ± 4.9% | | 1.00 | 16.75 | 2.15 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 367.76 ± 4.8% | not timed | not timed | 119.56 ± 0.1% | 585.83 ± 31.2% | not timed | not timed | 368.26 ± 4.3% | | 1.00 | 3.08 | 0.63 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.28 ± 1.6% | not timed | not timed | 4.06 ± 0.6% | 43.78 ± 2.7% | not timed | not timed | 47.84 ± 2.3% | | 0.99 | 11.64 | 1.08 |
| unicode/compile/one-letter | 53 | 6.62 ± 4.9% | not timed | not timed | 4.53 ± 0.7% | 64.37 ± 9.4% | not timed | not timed | 6.72 ± 14.1% | | 0.99 | 1.46 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.07 ± 16.9% | not timed | not timed | 0.10 ± 1.4% | 67.04 ± 9.5% | not timed | not timed | 1.08 ± 11.7% | | 0.99 | 10.84 | 0.0160 |
| unicode/compile/fifty-letters-ascii | 1 | 213.39 ± 10.8% | not timed | not timed | 53.35 ± 0.3% | 192.42 ± 23.8% | not timed | not timed | 221.86 ± 0.8% | | 0.96 | 4.00 | 1.11 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 382.59 ± 18.4% | not timed | not timed | 46.13 ± 0.5% | 659.13 ± 34.0% | not timed | not timed | 385.49 ± 3.0% | | 0.99 | 8.29 | 0.58 |
| unicode/compile/match-every-line-ascii | 4 | 619.55 ± 9.1% | not timed | not timed | 144.06 ± 0.9% | 674.25 ± 37.8% | not timed | not timed | 623.22 ± 5.7% | | 0.99 | 4.30 | 0.92 |
| unicode/compile/negated-class-matches-codepoint | 1 | 327.99 ± 7.8% | not timed | not timed | 49.16 ± 0.4% | 1241.04 ± 22.7% | not timed | not timed | 328.62 ± 2.6% | | 1.00 | 6.67 | 0.26 |
| wild/bibleref/compile | 3 | 5.72 ± 19.6% | not timed | not timed | 1.95 ± 0.6% | 30.15 ± 15.6% | not timed | not timed | 5.91 ± 4.4% | | 0.97 | 2.93 | 0.19 |
| wild/url/compile | 1 | 0.62 ± 15.1% | not timed | not timed | 0.14 ± 0.9% | 0.41 ± 12.5% | not timed | not timed | 0.63 ± 14.8% | | 1.00 | 4.33 | 1.51 |

