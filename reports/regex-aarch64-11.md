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
| literal: a word | 217 | 19733.92 ± 4.5% | 10859.16 ± 1.0% | 28.15 ± 0.4% | 18138.95 ± 3.5% | 9227.68 ± 6.0% | 17.40 ± 0.3% | 86.69 ± 0.4% | 19673.61 ± 2.1% | 1.82 | 1.00 | 1.09 | 2.14 |
| literal: a word that is not there | 0 | 21662.79 ± 3.1% | 9903.54 ± 1.3% | 28.35 ± 0.5% | 19776.44 ± 1.5% | 28817.01 ± 3.5% | 17.21 ± 0.2% | 80.87 ± 0.4% | 21622.77 ± 2.3% | 2.19 | 1.00 | 1.10 | 0.75 |
| literal: one of four words | 661 | 6436.91 ± 0.3% | 1787.87 ± 0.2% | 14.41 ± 0.1% | 3946.72 ± 0.4% | 21.85 ± 0.1% | 5.26 ± 0.4% | 6.96 ± 0.2% | 6442.14 ± 0.1% | 3.60 | 1.00 | 1.63 | 294.63 |
| literal: a word in any case | 217 | 15135.73 ± 0.9% | 1916.67 ± 0.5% | 21.56 ± 0.3% | 3964.43 ± 0.2% | 37.80 ± 0.8% | refused | differs | 15210.78 ± 1.0% | 7.90 | 1.00 | 3.82 | 400.47 |
| literal: an href attribute | 33 | 16827.41 ± 2.2% | 610.28 ± 0.5% | 27.28 ± 0.3% | 16981.37 ± 1.2% | 2252.88 ± 0.2% | 13.31 ± 0.2% | 75.65 ± 0.5% | 16943.00 ± 1.8% | 27.57 | 0.99 | 0.99 | 7.47 |
| literal: a word, second text | 123 | 19555.60 ± 2.7% | 4575.23 ± 0.4% | 27.94 ± 0.3% | 18019.86 ± 2.7% | 7514.08 ± 6.4% | 19.69 ± 0.8% | 71.12 ± 0.3% | 19666.03 ± 2.1% | 4.27 | 0.99 | 1.09 | 2.60 |
| class: two capitalized words | 1331 | 1178.58 ± 0.3% | 598.76 ± 0.1% | 25.95 ± 0.3% | 586.33 ± 0.2% | 40.68 ± 12.9% | 14.80 ± 0.5% | 67.82 ± 1.3% | 1179.55 ± 0.7% | 1.97 | 1.00 | 2.01 | 28.97 |
| class: a word that ends in ing | 3399 | 574.59 ± 0.1% | 573.91 ± 0.5% | 17.90 ± 0.1% | 548.08 ± 0.1% | 29.62 ± 7.3% | 8.13 ± 0.2% | 18.41 ± 0.3% | 574.94 ± 0.1% | 1.00 | 1.00 | 1.05 | 19.40 |
| class: a word in capitals | 2332 | 1539.49 ± 0.3% | 608.36 ± 0.2% | 27.58 ± 0.2% | 572.89 ± 0.1% | 43.60 ± 3.1% | 17.20 ± 0.3% | 83.30 ± 0.2% | 1537.14 ± 0.2% | 2.53 | 1.00 | 2.69 | 35.31 |
| class: a number | 8288 | 2675.19 ± 0.1% | 840.92 ± 0.1% | 27.71 ± 0.2% | 1708.71 ± 0.1% | 39.28 ± 15.6% | 0.56 ± 0.2% | 57.21 ± 0.3% | 2676.77 ± 0.4% | 3.18 | 1.00 | 1.57 | 68.10 |
| class: two capitalized words, second text | 5359 | 521.54 ± 0.4% | 528.78 ± 0.2% | 23.22 ± 0.1% | 484.72 ± 0.0% | 35.34 ± 10.7% | 16.68 ± 0.3% | 63.32 ± 0.5% | 521.58 ± 0.2% | 0.99 | 1.00 | 1.08 | 14.76 |
| other: a word between two words | 6104 | 811.12 ± 0.1% | 600.49 ± 0.2% | 23.42 ± 0.1% | 739.62 ± 0.1% | 110.27 ± 9.4% | 11.23 ± 0.2% | 69.50 ± 0.5% | 811.22 ± 0.1% | 1.35 | 1.00 | 1.10 | 7.36 |
| other: a number before a unit, second text | 1481 | 6248.94 ± 0.8% | 1141.46 ± 0.3% | 25.96 ± 0.2% | 5523.33 ± 0.9% | 40.85 ± 0.2% | 17.70 ± 0.2% | 65.94 ± 0.3% | 6252.18 ± 1.0% | 5.47 | 1.00 | 1.13 | 152.96 |
| other: a heading's start tag | 110 | 14216.21 ± 1.5% | 740.61 ± 0.1% | 27.33 ± 0.1% | 1709.21 ± 0.4% | 1581.33 ± 9.5% | 16.32 ± 0.5% | 87.96 ± 0.4% | 14229.15 ± 0.7% | 19.20 | 1.00 | 8.32 | 8.99 |
| other: a whole word | 217 | 16175.82 ± 1.8% | 601.93 ± 0.3% | 28.73 ± 0.4% | 14405.29 ± 1.9% | 49.37 ± 0.2% | 13.48 ± 0.2% | 55.49 ± 0.1% | 16371.33 ± 2.4% | 26.87 | 0.99 | 1.12 | 327.64 |
| other: a line's first word, second text | 3716 | 2096.65 ± 0.6% | 591.99 ± 0.6% | 30.85 ± 0.2% | 1664.27 ± 0.5% | 61.92 ± 8.0% | refused | refused | 2105.59 ± 0.8% | 3.54 | 1.00 | 1.26 | 33.86 |
| other: fourteen octets before an x | 87 | 23674.20 ± 2.4% | 244.81 ± 0.4% | 6.46 ± 0.0% | 4006.21 ± 1.7% | 10.64 ± 0.2% | differs | 17.91 ± 0.3% | 23778.71 ± 7.9% | 96.71 | 1.00 | 5.91 | 2224.04 |
| other: a Greek word | 21815 | 527.05 ± 0.8% | 423.68 ± 0.1% | 30.42 ± 0.2% | 290.42 ± 0.4% | 47.02 ± 8.2% | differs | refused | 529.00 ± 0.7% | 1.24 | 1.00 | 1.81 | 11.21 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.67 ± 0.2% | 29.58 ± 0.2% | 0.86 ± 0.3% | 19.76 ± 0.1% | 2.76 ± 0.6% | differs | 4.04 ± 0.1% | 29.58 ± 0.3% | 1.00 | 1.00 | 1.50 | 10.76 |
| a UUID | 32895 | 24.65 ± 0.1% | 24.77 ± 0.2% | 0.64 ± 0.2% | 15.14 ± 0.3% | 3.12 ± 0.1% | 0.72 ± 0.1% | 3.60 ± 0.9% | 24.76 ± 0.1% | 1.00 | 1.00 | 1.63 | 7.91 |
| an IPv4 address | 33176 | 38.74 ± 0.3% | 38.78 ± 0.4% | 2.08 ± 0.3% | 29.32 ± 0.4% | 6.67 ± 0.1% | differs | 4.21 ± 0.1% | 38.72 ± 0.1% | 1.00 | 1.00 | 1.32 | 5.80 |
| a date and time | 32954 | 33.95 ± 0.3% | 34.10 ± 0.2% | 1.44 ± 0.5% | 21.47 ± 0.3% | 7.02 ± 0.1% | 1.19 ± 0.3% | 7.11 ± 0.2% | 34.11 ± 0.2% | 1.00 | 1.00 | 1.58 | 4.83 |
| a field path | 32606 | 32.72 ± 0.4% | 32.80 ± 0.6% | 1.02 ± 0.1% | 23.13 ± 0.4% | 3.50 ± 1.5% | differs | 2.96 ± 0.1% | 32.77 ± 0.2% | 1.00 | 1.00 | 1.41 | 9.36 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.24 ± 0.6% | 11.17 ± 0.5% | 11.18 ± 0.4% | 11.35 ± 0.1% | 4.95 ± 2.2% | 0.90 ± 0.4% | none | 11.18 ± 2.3% | 1.01 | 1.01 | 0.99 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 229.08 ± 0.2% | 228.93 ± 0.2% | 270.07 ± 0.1% | 86.65 ± 0.2% | 221.09 ± 1.3% | 487.32 ± 3.5% | 3741.91 ± 2.3% | 229.22 ± 0.2% | 1.00 | 1.00 | 2.64 | 1.04 |
| a UUID | 62 | 152.02 ± 0.5% | 152.06 ± 0.2% | 169.75 ± 0.1% | 45.47 ± 0.5% | 99.13 ± 1.5% | 189.44 ± 2.4% | 4367.11 ± 0.3% | 152.14 ± 0.1% | 1.00 | 1.00 | 3.34 | 1.53 |
| an IPv4 address | 29 | 423.12 ± 0.5% | 421.97 ± 0.4% | 588.81 ± 0.3% | 77.10 ± 0.5% | 130.37 ± 0.9% | 295.25 ± 0.9% | 7568.94 ± 0.5% | 423.00 ± 0.3% | 1.00 | 1.00 | 5.49 | 3.25 |
| a date and time | 56 | 302.20 ± 0.3% | 302.29 ± 0.3% | 378.57 ± 0.3% | 72.67 ± 0.5% | 135.26 ± 1.9% | 327.21 ± 2.9% | 4944.06 ± 0.7% | 302.28 ± 0.1% | 1.00 | 1.00 | 4.16 | 2.23 |
| a field path | 39 | 224.46 ± 0.3% | 224.69 ± 0.2% | 264.23 ± 0.2% | 81.41 ± 1.8% | 205.07 ± 0.9% | 534.75 ± 2.0% | 4748.06 ± 2.7% | 224.57 ± 0.1% | 1.00 | 1.00 | 2.76 | 1.09 |
| literal: a word | 7 | 604.09 ± 0.2% | 650.79 ± 0.3% | 1126.23 ± 0.2% | 515.64 ± 0.4% | 631.27 ± 2.3% | 958.45 ± 0.3% | 30210.89 ± 0.2% | 604.29 ± 0.2% | 0.93 | 1.00 | 1.17 | 0.96 |
| literal: a word that is not there | 8 | 587.32 ± 0.6% | 635.86 ± 0.3% | 1089.99 ± 0.1% | 463.49 ± 0.4% | 605.76 ± 2.1% | 906.00 ± 0.8% | 29138.11 ± 0.5% | 587.76 ± 0.1% | 0.92 | 1.00 | 1.27 | 0.97 |
| literal: one of four words | 26 | 244.69 ± 0.2% | 387.01 ± 0.6% | 524.18 ± 0.6% | 49.96 ± 0.9% | 241.64 ± 1.7% | 372.01 ± 2.6% | 15595.87 ± 0.4% | 244.47 ± 0.4% | 0.63 | 1.00 | 4.90 | 1.01 |
| literal: a word in any case | 11 | 439.14 ± 0.2% | 468.11 ± 0.4% | 681.96 ± 0.3% | 15.67 ± 0.2% | 654.71 ± 3.9% | refused | 23729.60 ± 0.4% | 439.02 ± 0.2% | 0.94 | 1.00 | 28.02 | 0.67 |
| literal: an href attribute | 12 | 338.90 ± 0.4% | 351.21 ± 0.2% | 460.13 ± 0.2% | 44.81 ± 0.1% | 500.04 ± 0.8% | 757.57 ± 0.5% | 21609.52 ± 0.3% | 339.68 ± 0.3% | 0.96 | 1.00 | 7.56 | 0.68 |
| literal: a word, second text | 10 | 540.63 ± 0.5% | 591.58 ± 0.4% | 972.78 ± 0.1% | 413.74 ± 0.6% | 538.01 ± 1.4% | 788.85 ± 0.1% | 27055.95 ± 0.8% | 539.95 ± 0.4% | 0.91 | 1.00 | 1.31 | 1.00 |
| class: two capitalized words | 23 | 431.17 ± 0.7% | 458.81 ± 0.6% | 658.32 ± 0.4% | 99.51 ± 1.0% | 498.70 ± 1.7% | 746.46 ± 0.3% | 6294.71 ± 0.2% | 432.17 ± 0.3% | 0.94 | 1.00 | 4.33 | 0.86 |
| class: a word that ends in ing | 9 | 553.18 ± 0.3% | 617.73 ± 0.7% | 1066.75 ± 0.3% | 131.92 ± 1.3% | 751.31 ± 1.5% | 1116.81 ± 0.3% | 15726.72 ± 0.2% | 552.80 ± 0.5% | 0.90 | 1.00 | 4.19 | 0.74 |
| class: a word in capitals | 16 | 493.33 ± 0.3% | 528.16 ± 0.3% | 835.87 ± 0.1% | 135.74 ± 0.6% | 749.14 ± 1.4% | 1031.57 ± 0.8% | 8296.67 ± 0.1% | 493.09 ± 0.2% | 0.93 | 1.00 | 3.63 | 0.66 |
| class: a number | 6 | 622.07 ± 0.3% | 677.34 ± 0.5% | 1246.31 ± 0.1% | 41.84 ± 1.5% | 1406.06 ± 1.3% | 1942.36 ± 0.3% | 22767.89 ± 0.1% | 620.51 ± 0.4% | 0.92 | 1.00 | 14.87 | 0.44 |
| class: two capitalized words, second text | 23 | 431.87 ± 0.3% | 459.97 ± 1.1% | 660.08 ± 0.4% | 101.62 ± 2.8% | 501.00 ± 5.8% | 739.19 ± 0.9% | 6296.81 ± 0.2% | 431.67 ± 0.4% | 0.94 | 1.00 | 4.25 | 0.86 |
| other: a word between two words | 13 | 529.39 ± 0.4% | 550.37 ± 0.3% | 867.86 ± 0.3% | 135.75 ± 1.8% | 504.31 ± 1.2% | 809.07 ± 0.8% | 14570.53 ± 0.3% | 529.78 ± 0.1% | 0.96 | 1.00 | 3.90 | 1.05 |
| other: a number before a unit, second text | 15 | 391.69 ± 0.2% | 429.49 ± 0.3% | 599.79 ± 0.1% | 39.32 ± 1.0% | 635.23 ± 0.5% | 892.69 ± 0.6% | 15130.94 ± 0.4% | 392.20 ± 0.3% | 0.91 | 1.00 | 9.96 | 0.62 |
| other: a heading's start tag | 13 | 350.83 ± 0.3% | 357.69 ± 0.4% | 469.14 ± 0.2% | 44.30 ± 0.2% | 629.36 ± 0.6% | 879.77 ± 0.3% | 17964.05 ± 0.6% | 351.31 ± 0.2% | 0.98 | 1.00 | 7.92 | 0.56 |
| other: a whole word | 11 | 564.60 ± 1.7% | 601.95 ± 1.3% | 990.70 ± 2.2% | 120.94 ± 0.5% | 566.14 ± 1.8% | 832.46 ± 0.8% | 26804.70 ± 1.0% | 563.46 ± 0.3% | 0.94 | 1.00 | 4.67 | 1.00 |
| other: a line's first word, second text | 17 | 509.84 ± 0.4% | 544.74 ± 0.2% | 863.23 ± 0.3% | 129.59 ± 0.2% | 710.61 ± 1.4% | refused | refused | 510.64 ± 0.6% | 0.94 | 1.00 | 3.93 | 0.72 |
| other: fourteen octets before an x | 16 | 109.30 ± 1.3% | 156.64 ± 1.1% | 179.29 ± 0.5% | 14.89 ± 0.2% | 453.63 ± 1.0% | 412.75 ± 0.6% | 12755.48 ± 0.3% | 109.43 ± 0.8% | 0.70 | 1.00 | 7.34 | 0.24 |
| other: a Greek word | 8 | 448.23 ± 0.5% | 588.12 ± 0.5% | 981.87 ± 0.7% | 58.80 ± 0.5% | 1382.95 ± 3.1% | 1849.84 ± 0.8% | refused | 448.43 ± 0.3% | 0.76 | 1.00 | 7.62 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15522.06 ± 1.7% | not timed | not timed | 16217.68 ± 1.9% | 1997.48 ± 23.7% | not timed | not timed | 15540.58 ± 0.9% | | 1.00 | 0.96 | 7.77 |
| 01-literal/sherlock-casei-en | 522 | 10932.23 ± 6.9% | not timed | not timed | 3591.30 ± 0.2% | 32.52 ± 0.2% | not timed | not timed | 10940.64 ± 3.8% | | 1.00 | 3.04 | 336.20 |
| 01-literal/sherlock-ru | 724 | 17088.22 ± 0.9% | not timed | not timed | 17203.71 ± 1.9% | 1530.22 ± 22.9% | not timed | not timed | 17128.68 ± 0.5% | | 1.00 | 0.99 | 11.17 |
| 01-literal/sherlock-casei-ru | 746 | 6132.89 ± 0.2% | not timed | not timed | 3334.75 ± 0.0% | 31.67 ± 0.5% | not timed | not timed | 6134.97 ± 0.2% | | 1.00 | 1.84 | 193.66 |
| 01-literal/sherlock-zh | 30 | 19393.77 ± 0.6% | not timed | not timed | 18347.63 ± 1.3% | 2591.15 ± 5.2% | not timed | not timed | 19389.55 ± 0.6% | | 1.00 | 1.06 | 7.48 |
| 02-literal-alternate/sherlock-en | 714 | 6144.14 ± 0.2% | not timed | not timed | 3942.47 ± 0.1% | 16.60 ± 0.3% | not timed | not timed | 6147.92 ± 0.2% | | 1.00 | 1.56 | 370.13 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1966.99 ± 1.3% | not timed | not timed | 697.68 ± 0.1% | 11.03 ± 0.2% | not timed | not timed | 1972.08 ± 0.9% | | 1.00 | 2.82 | 178.38 |
| 02-literal-alternate/sherlock-ru | 899 | 5499.84 ± 0.3% | not timed | not timed | 3250.59 ± 0.2% | 22.55 ± 0.4% | not timed | not timed | 5499.72 ± 0.1% | | 1.00 | 1.69 | 243.94 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2046.69 ± 0.8% | not timed | not timed | 1224.05 ± 0.8% | 9.14 ± 5.4% | not timed | not timed | 2047.87 ± 0.4% | | 1.00 | 1.67 | 224.00 |
| 02-literal-alternate/sherlock-zh | 207 | 7328.26 ± 0.5% | not timed | not timed | 4165.51 ± 0.1% | 31.46 ± 0.1% | not timed | not timed | 7324.20 ± 0.3% | | 1.00 | 1.76 | 232.95 |
| 03-date/ascii | 111817 | 133.57 ± 0.7% | not timed | not timed | 96.18 ± 0.2% | 0.20 ± 5.1% | not timed | not timed | 134.65 ± 0.8% | | 0.99 | 1.39 | 669.63 |
| 04-ruff-noqa/real | 84 | 438.59 ± 0.1% | not timed | not timed | 463.20 ± 0.3% | 19.46 ± 1.3% | not timed | not timed | 437.59 ± 0.2% | | 1.00 | 0.95 | 22.54 |
| 04-ruff-noqa/tweaked | 44 | 846.42 ± 0.2% | not timed | not timed | 460.81 ± 0.1% | 363.99 ± 0.6% | not timed | not timed | 845.72 ± 0.2% | | 1.00 | 1.84 | 2.33 |
| 05-lexer-veryl/single | 124800 | 5.26 ± 2.1% | not timed | not timed | 5.11 ± 0.2% | 0.20 ± 4.5% | not timed | not timed | 5.30 ± 3.4% | | 0.99 | 1.03 | 26.04 |
| 06-cloud-flare-redos/original | 107 | 439.59 ± 0.1% | not timed | not timed | 217.33 ± 0.1% | 24.85 ± 0.4% | not timed | not timed | 438.72 ± 0.1% | | 1.00 | 2.02 | 17.69 |
| 06-cloud-flare-redos/simplified-short | 102 | 438.93 ± 0.1% | not timed | not timed | 228.93 ± 0.1% | 26.61 ± 0.1% | not timed | not timed | 438.46 ± 0.2% | | 1.00 | 1.92 | 16.50 |
| 06-cloud-flare-redos/simplified-long | 10000 | 629.07 ± 0.1% | not timed | not timed | 256.13 ± 0.4% | 28.79 ± 0.3% | not timed | not timed | 629.07 ± 0.2% | | 1.00 | 2.46 | 21.85 |
| 07-unicode-character-data/parse-line | 558784 | 241.26 ± 2.3% | not timed | not timed | 172.50 ± 0.1% | 42.39 ± 5.2% | not timed | not timed | 243.08 ± 1.5% | | 0.99 | 1.40 | 5.69 |
| 08-words/all-english | 56691 | 128.97 ± 0.9% | not timed | not timed | 83.10 ± 0.1% | 11.94 ± 5.5% | not timed | not timed | 129.23 ± 0.4% | | 1.00 | 1.55 | 10.81 |
| 08-words/long-english | 839 | 616.72 ± 0.6% | not timed | not timed | 597.35 ± 0.2% | 32.57 ± 0.2% | not timed | not timed | 617.76 ± 0.4% | | 1.00 | 1.03 | 18.94 |
| 09-aws-keys/full | 0 | 442.57 ± 0.2% | not timed | not timed | 459.32 ± 0.2% | 63.91 ± 3.3% | not timed | not timed | 442.65 ± 0.2% | | 1.00 | 0.96 | 6.93 |
| 09-aws-keys/quick | 0 | 874.35 ± 0.3% | not timed | not timed | 991.40 ± 0.2% | 417.07 ± 0.1% | not timed | not timed | 873.87 ± 0.3% | | 1.00 | 0.88 | 2.10 |
| 10-bounded-repeat/letters-en | 1833 | 586.07 ± 1.9% | not timed | not timed | 517.23 ± 0.3% | 19.57 ± 0.5% | not timed | not timed | 576.28 ± 2.6% | | 1.02 | 1.13 | 29.94 |
| 10-bounded-repeat/letters-ru | 3475 | 506.92 ± 1.5% | not timed | not timed | 478.59 ± 0.2% | 21.58 ± 13.1% | not timed | not timed | 507.60 ± 1.2% | | 1.00 | 1.06 | 23.49 |
| 10-bounded-repeat/context | 53 | 84.64 ± 1.8% | not timed | not timed | 65.79 ± 0.7% | 19.81 ± 0.2% | not timed | not timed | 84.99 ± 1.8% | | 1.00 | 1.29 | 4.27 |
| 10-bounded-repeat/capitals | 11 | 637.47 ± 8.2% | not timed | not timed | 615.35 ± 0.1% | 36.64 ± 0.1% | not timed | not timed | 637.71 ± 8.0% | | 1.00 | 1.04 | 17.40 |
| 11-unstructured-to-json/extract | 600 | 58.01 ± 0.5% | not timed | not timed | 77.65 ± 0.1% | 49.03 ± 1.0% | not timed | not timed | 57.82 ± 1.3% | | 1.00 | 0.75 | 1.18 |
| 12-dictionary/single | 1 | 560.05 ± 1.5% | not timed | not timed | 560.60 ± 0.1% | 0.40 ± 0.3% | not timed | not timed | 561.01 ± 1.6% | | 1.00 | 1.00 | 1404.28 |
| 14-quadratic/1x | 100 | 22.01 ± 0.2% | not timed | not timed | 10.01 ± 0.2% | 0.96 ± 1.8% | not timed | not timed | 22.09 ± 0.8% | | 1.00 | 2.20 | 22.94 |
| 14-quadratic/2x | 200 | 19.68 ± 1.0% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 0.9% | not timed | not timed | 19.82 ± 1.1% | | 0.99 | 3.55 | 36.94 |
| 14-quadratic/10x | 1000 | 12.31 ± 0.5% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 2.0% | not timed | not timed | 12.33 ± 0.7% | | 1.00 | 10.15 | 106.67 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.25 ± 3.2% | not timed | not timed | 0.34 ± 0.8% | 0.55 ± 4.2% | not timed | not timed | 1.27 ± 0.7% | | 0.99 | 3.62 | 2.25 |
| 04-ruff-noqa/compile-real | 1 | 103.98 ± 1.4% | not timed | not timed | 13.77 ± 0.4% | 138.27 ± 1.1% | not timed | not timed | 104.91 ± 1.1% | | 0.99 | 7.55 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 14.09 ± 1.1% | not timed | not timed | 2.53 ± 1.0% | 6.41 ± 1.0% | not timed | not timed | 14.13 ± 1.7% | | 1.00 | 5.56 | 2.20 |
| 07-unicode-character-data/compile | 1 | 108.42 ± 1.4% | not timed | not timed | 25.92 ± 0.4% | 35.88 ± 2.7% | not timed | not timed | 108.58 ± 0.4% | | 1.00 | 4.18 | 3.02 |
| 09-aws-keys/compile-full | 1 | 52.97 ± 1.4% | not timed | not timed | 8.27 ± 1.1% | 23.33 ± 1.7% | not timed | not timed | 53.04 ± 0.5% | | 1.00 | 6.41 | 2.27 |
| 09-aws-keys/compile-quick | 1 | 187.62 ± 0.4% | not timed | not timed | 47.10 ± 0.3% | 133.42 ± 2.1% | not timed | not timed | 187.71 ± 1.0% | | 1.00 | 3.98 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 71.29 ± 1.2% | not timed | not timed | 11.09 ± 0.2% | 16.16 ± 3.3% | not timed | not timed | 71.23 ± 1.2% | | 1.00 | 6.43 | 4.41 |
| 10-bounded-repeat/compile-capitals | 1 | 86.04 ± 0.3% | not timed | not timed | 8.10 ± 0.3% | 23.81 ± 2.5% | not timed | not timed | 86.01 ± 1.5% | | 1.00 | 10.62 | 3.61 |
| 11-unstructured-to-json/compile | 1 | 172.47 ± 0.5% | not timed | not timed | 41.16 ± 0.5% | 67.89 ± 1.8% | not timed | not timed | 172.29 ± 0.8% | | 1.00 | 4.19 | 2.54 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.2% | not timed | not timed | 0.07 ± 41.0% | 0.09 ± 6.2% | not timed | not timed | 0.35 ± 1.7% | | 1.00 | 5.13 | 3.68 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.45 ± 2.3% | not timed | not timed | 6.47 ± 0.1% | 0.57 ± 17.0% | not timed | not timed | 7.41 ± 1.5% | | 1.01 | 1.15 | 13.12 |
| dictionary/search/english-10 | 690 | 210.13 ± 1.7% | not timed | not timed | 166.79 ± 0.7% | 0.00 ± 0.3% | not timed | not timed | 208.85 ± 4.0% | | 1.01 | 1.26 | 76862.20 |
| dictionary/search/english-15 | 15 | 560.13 ± 1.4% | not timed | not timed | 558.80 ± 0.1% | 0.37 ± 0.4% | not timed | not timed | 561.31 ± 1.7% | | 1.00 | 1.00 | 1531.76 |
| folly/awyer-inn-busted | 1 | 21500.48 ± 0.1% | not timed | not timed | 143.09 ± 0.1% | 43.76 ± 0.1% | not timed | not timed | 21567.62 ± 0.1% | | 1.00 | 150.26 | 491.31 |
| folly/literal-never-match-rare | 0 | 21114.13 ± 0.2% | not timed | not timed | 19932.36 ± 0.3% | 40895.71 ± 0.5% | not timed | not timed | 21142.94 ± 0.1% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12553.52 ± 0.7% | not timed | not timed | 19850.32 ± 0.4% | 2200.48 ± 0.6% | not timed | not timed | 12589.01 ± 0.6% | | 1.00 | 0.63 | 5.70 |
| folly/literal-never-match-tricksy | 1 | 3253.01 ± 0.4% | not timed | not timed | 4411.09 ± 0.4% | 3054.66 ± 0.1% | not timed | not timed | 3251.93 ± 0.1% | | 1.00 | 0.74 | 1.06 |
| grep/every-line | 239963 | 1299.59 ± 0.5% | not timed | not timed | 958.85 ± 0.8% | 376.84 ± 17.2% | not timed | not timed | 1304.97 ± 0.4% | | 1.00 | 1.36 | 3.45 |
| grep/long-words-ascii | 5073 | 459.25 ± 0.3% | not timed | not timed | 470.00 ± 0.0% | 46.05 ± 6.6% | not timed | not timed | 458.82 ± 0.2% | | 1.00 | 0.98 | 9.97 |
| imported/leipzig/twain | 811 | 20547.90 ± 0.8% | not timed | not timed | 19410.02 ± 0.8% | 11923.64 ± 9.1% | not timed | not timed | 20598.96 ± 1.3% | | 1.00 | 1.06 | 1.72 |
| imported/leipzig/twain-insensitive | 965 | 9035.73 ± 1.2% | not timed | not timed | 4245.67 ± 0.1% | 37.73 ± 0.1% | not timed | not timed | 9059.79 ± 1.3% | | 1.00 | 2.13 | 239.49 |
| imported/leipzig/shing | 1540 | 15252.13 ± 1.9% | not timed | not timed | 13416.94 ± 0.5% | 33.98 ± 0.1% | not timed | not timed | 15512.24 ± 2.2% | | 0.98 | 1.14 | 448.85 |
| imported/leipzig/huck-saw | 262 | 8115.02 ± 3.5% | not timed | not timed | 5581.63 ± 0.2% | 31.61 ± 0.1% | not timed | not timed | 8291.39 ± 3.2% | | 0.98 | 1.45 | 256.76 |
| imported/leipzig/word-ending-nn | 262 | 603.09 ± 0.5% | not timed | not timed | 616.35 ± 0.1% | 24.76 ± 0.5% | not timed | not timed | 594.08 ± 1.0% | | 1.02 | 0.98 | 24.35 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11231.08 ± 0.5% | not timed | not timed | 4515.50 ± 0.9% | 11.51 ± 1.2% | not timed | not timed | 11203.94 ± 1.7% | | 1.00 | 2.49 | 975.92 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7748.10 ± 0.8% | not timed | not timed | 5474.35 ± 0.1% | 16.93 ± 0.1% | not timed | not timed | 7817.30 ± 1.6% | | 0.99 | 1.42 | 457.78 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4150.34 ± 3.6% | not timed | not timed | 417.93 ± 0.2% | 11.09 ± 0.0% | not timed | not timed | 4167.82 ± 1.1% | | 1.00 | 9.93 | 374.20 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7246.83 ± 3.7% | not timed | not timed | 614.76 ± 0.1% | 11.14 ± 0.1% | not timed | not timed | 7311.99 ± 3.9% | | 0.99 | 11.79 | 650.43 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7124.58 ± 3.5% | not timed | not timed | 615.19 ± 0.1% | 9.75 ± 0.0% | not timed | not timed | 7166.06 ± 2.4% | | 0.99 | 11.58 | 731.09 |
| imported/leipzig/tom-river | 2 | 6462.49 ± 2.1% | not timed | not timed | 5125.96 ± 0.3% | 31.02 ± 0.2% | not timed | not timed | 6520.62 ± 2.0% | | 0.99 | 1.26 | 208.35 |
| imported/leipzig/ing | 78424 | 604.23 ± 0.8% | not timed | not timed | 571.10 ± 0.1% | 28.29 ± 3.0% | not timed | not timed | 603.07 ± 0.8% | | 1.00 | 1.06 | 21.36 |
| imported/leipzig/ing-whitespace | 55248 | 1921.94 ± 0.7% | not timed | not timed | 2082.19 ± 0.8% | 20.51 ± 2.7% | not timed | not timed | 1919.70 ± 1.0% | | 1.00 | 0.92 | 93.71 |
| imported/leipzig/awyer-inn | 209 | 6305.42 ± 2.1% | not timed | not timed | 4275.25 ± 0.3% | 22.62 ± 0.1% | not timed | not timed | 6373.52 ± 1.5% | | 0.99 | 1.47 | 278.73 |
| imported/leipzig/quotes-bounded | 8886 | 2473.24 ± 0.8% | not timed | not timed | 3008.79 ± 0.7% | 38.24 ± 0.1% | not timed | not timed | 2483.17 ± 0.9% | | 1.00 | 0.82 | 64.67 |
| imported/leipzig/non-ascii-alternate | 2 | 12758.10 ± 2.3% | not timed | not timed | 5660.46 ± 0.3% | 50.51 ± 0.1% | not timed | not timed | 12972.76 ± 2.5% | | 0.98 | 2.25 | 252.56 |
| imported/leipzig/math-symbols | 69 | 1986.85 ± 0.6% | not timed | not timed | 614.48 ± 0.1% | 36.46 ± 0.5% | not timed | not timed | 1988.96 ± 0.5% | | 1.00 | 3.23 | 54.50 |
| imported/leipzig/bounded-strings-ending-z | 0 | 630.05 ± 2.2% | not timed | not timed | 617.92 ± 0.1% | 22.51 ± 0.0% | not timed | not timed | 631.58 ± 0.9% | | 1.00 | 1.02 | 27.99 |
| imported/lh3lh3-reb/uri | 17549 | 678.04 ± 0.2% | not timed | not timed | 1070.70 ± 1.3% | 27.80 ± 3.0% | not timed | not timed | 679.89 ± 0.2% | | 1.00 | 0.63 | 24.39 |
| imported/lh3lh3-reb/email | 15057 | 674.47 ± 0.1% | not timed | not timed | 1156.19 ± 0.2% | 30.68 ± 2.5% | not timed | not timed | 676.46 ± 0.2% | | 1.00 | 0.58 | 21.98 |
| imported/lh3lh3-reb/date | 668 | 892.24 ± 0.2% | not timed | not timed | 1033.29 ± 0.3% | 51.17 ± 3.8% | not timed | not timed | 893.09 ± 0.2% | | 1.00 | 0.86 | 17.44 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 644.53 ± 0.1% | not timed | not timed | 424.12 ± 0.1% | 15.77 ± 1.2% | not timed | not timed | 646.63 ± 0.1% | | 1.00 | 1.52 | 40.88 |
| imported/mariomka/email | 92 | 24147.82 ± 1.8% | not timed | not timed | 29392.32 ± 2.8% | 32.82 ± 0.1% | not timed | not timed | 24171.33 ± 1.1% | | 1.00 | 0.82 | 735.71 |
| imported/mariomka/uri | 5301 | 5515.97 ± 1.0% | not timed | not timed | 6085.90 ± 0.3% | 32.75 ± 0.4% | not timed | not timed | 5553.67 ± 1.3% | | 0.99 | 0.91 | 168.42 |
| imported/mariomka/ip | 5 | 2593.00 ± 3.4% | not timed | not timed | 2958.62 ± 0.5% | 21.02 ± 0.2% | not timed | not timed | 2598.17 ± 3.0% | | 1.00 | 0.88 | 123.36 |
| imported/rsc/no-exponential | 0 | 607.70 ± 0.2% | not timed | not timed | 322.69 ± 0.1% | 23.71 ± 0.1% | not timed | not timed | 608.18 ± 0.1% | | 1.00 | 1.88 | 25.63 |
| imported/rsc/literal | 1 | 1496.87 ± 2.2% | not timed | not timed | 1667.90 ± 3.1% | 186.89 ± 17.9% | not timed | not timed | 1495.36 ± 5.4% | | 1.00 | 0.90 | 8.01 |
| imported/rsc/not-literal | 2 | 776.90 ± 0.3% | not timed | not timed | 750.67 ± 0.6% | 45.90 ± 3.5% | not timed | not timed | 779.98 ± 8.3% | | 1.00 | 1.03 | 16.93 |
| imported/rsc/match-class | 1 | 1471.83 ± 0.8% | not timed | not timed | 1629.03 ± 0.2% | 58.12 ± 13.5% | not timed | not timed | 1469.40 ± 2.5% | | 1.00 | 0.90 | 25.32 |
| imported/rsc/match-class-in-range | 1 | 1471.34 ± 0.4% | not timed | not timed | 2447.01 ± 1.4% | 59.92 ± 5.8% | not timed | not timed | 1470.95 ± 2.4% | | 1.00 | 0.60 | 24.56 |
| imported/rsc/match-class-unicode | 1 | 541.43 ± 0.4% | not timed | not timed | 509.32 ± 0.1% | 72.62 ± 0.3% | not timed | not timed | 543.21 ± 0.5% | | 1.00 | 1.06 | 7.46 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1454.04 ± 0.3% | not timed | not timed | 963.09 ± 0.2% | 228.73 ± 0.6% | not timed | not timed | 1451.36 ± 0.3% | | 1.00 | 1.51 | 6.36 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21785.20 ± 0.1% | not timed | not timed | 14303.94 ± 0.2% | 3428.00 ± 0.8% | not timed | not timed | 21742.16 ± 0.1% | | 1.00 | 1.52 | 6.36 |
| imported/rsc/anchored-literal-short-match | 4 | 711.30 ± 2.2% | not timed | not timed | 488.89 ± 0.9% | 82.09 ± 6.9% | not timed | not timed | 723.56 ± 5.7% | | 0.98 | 1.45 | 8.66 |
| imported/rsc/anchored-literal-long-match | 4 | 10831.21 ± 0.6% | not timed | not timed | 7427.48 ± 0.2% | 1236.47 ± 6.9% | not timed | not timed | 10833.90 ± 2.1% | | 1.00 | 1.46 | 8.76 |
| imported/rsc/one-pass-short | 17 | 368.28 ± 12.9% | not timed | not timed | 215.78 ± 0.3% | 29.80 ± 11.1% | not timed | not timed | 369.70 ± 1.8% | | 1.00 | 1.71 | 12.36 |
| imported/rsc/one-pass-short-not | 17 | 269.64 ± 2.6% | not timed | not timed | 225.76 ± 0.0% | 29.93 ± 12.5% | not timed | not timed | 269.84 ± 1.6% | | 1.00 | 1.19 | 9.01 |
| imported/rsc/one-pass-long-prefix | 26 | 361.77 ± 2.2% | not timed | not timed | 285.31 ± 0.5% | 108.21 ± 16.7% | not timed | not timed | 361.41 ± 8.6% | | 1.00 | 1.27 | 3.34 |
| imported/rsc/one-pass-long-prefix-not | 26 | 359.46 ± 2.0% | not timed | not timed | 283.49 ± 0.5% | 63.96 ± 19.3% | not timed | not timed | 363.45 ± 2.4% | | 0.99 | 1.27 | 5.62 |
| imported/rsc/long-needle1 | 31 | 21962.25 ± 0.3% | not timed | not timed | 20151.68 ± 0.1% | 3.75 ± 0.2% | not timed | not timed | 21962.79 ± 0.1% | | 1.00 | 1.09 | 5852.43 |
| imported/rsc/long-needle2 | 31 | 22083.61 ± 0.3% | not timed | not timed | 216.07 ± 0.2% | 3.76 ± 0.1% | not timed | not timed | 22090.44 ± 0.2% | | 1.00 | 102.21 | 5872.97 |
| imported/rsc/easy0-32 | 26 | 1576.60 ± 2.2% | not timed | not timed | 1611.83 ± 1.6% | 148.09 ± 17.4% | not timed | not timed | 1562.99 ± 1.8% | | 1.01 | 0.98 | 10.65 |
| imported/rsc/easy0-1k | 26 | 13669.11 ± 0.2% | not timed | not timed | 12634.32 ± 0.5% | 2304.79 ± 15.9% | not timed | not timed | 13651.15 ± 2.1% | | 1.00 | 1.08 | 5.93 |
| imported/rsc/easy0-32k | 26 | 22809.56 ± 0.3% | not timed | not timed | 20306.73 ± 0.0% | 18795.11 ± 20.3% | not timed | not timed | 22811.85 ± 6.9% | | 1.00 | 1.12 | 1.21 |
| imported/rsc/easy0-1mb | 26 | 21388.44 ± 2.7% | not timed | not timed | 19594.30 ± 3.2% | 35640.41 ± 3.6% | not timed | not timed | 21312.86 ± 1.6% | | 1.00 | 1.09 | 0.60 |
| imported/rsc/easy1-32 | 19 | 771.77 ± 1.9% | not timed | not timed | 650.75 ± 0.1% | 136.89 ± 19.2% | not timed | not timed | 770.82 ± 7.7% | | 1.00 | 1.19 | 5.64 |
| imported/rsc/easy1-1k | 19 | 15744.18 ± 2.6% | not timed | not timed | 13089.35 ± 0.4% | 2470.38 ± 16.5% | not timed | not timed | 15806.04 ± 0.2% | | 1.00 | 1.20 | 6.37 |
| imported/rsc/easy1-32k | 19 | 495335.78 ± 0.2% | not timed | not timed | 414915.12 ± 0.2% | 20361.13 ± 0.0% | not timed | not timed | 494490.51 ± 0.2% | | 1.00 | 1.19 | 24.33 |
| imported/rsc/easy1-1mb | 19 | 15888826.30 ± 0.3% | not timed | not timed | 13203303.98 ± 0.4% | 37912.78 ± 2.2% | not timed | not timed | 15908976.47 ± 0.1% | | 1.00 | 1.20 | 419.09 |
| imported/rsc/medium-32 | 27 | 739.85 ± 1.9% | not timed | not timed | 644.08 ± 0.3% | 69.75 ± 13.0% | not timed | not timed | 738.36 ± 0.2% | | 1.00 | 1.15 | 10.61 |
| imported/rsc/medium-1k | 27 | 13181.71 ± 0.1% | not timed | not timed | 11404.48 ± 0.4% | 72.13 ± 0.1% | not timed | not timed | 13131.71 ± 0.2% | | 1.00 | 1.16 | 182.75 |
| imported/rsc/medium-32k | 27 | 410975.09 ± 0.1% | not timed | not timed | 358520.12 ± 0.3% | 48.68 ± 0.1% | not timed | not timed | 408614.69 ± 0.3% | | 1.01 | 1.15 | 8442.64 |
| imported/rsc/medium-1mb | 27 | 13139709.79 ± 0.1% | not timed | not timed | 11519114.79 ± 0.3% | 48.31 ± 0.3% | not timed | not timed | 13066273.58 ± 0.3% | | 1.01 | 1.14 | 271968.18 |
| imported/rsc/hard-32 | 58 | 424.39 ± 0.6% | not timed | not timed | 368.64 ± 0.0% | 49.64 ± 11.5% | not timed | not timed | 422.14 ± 0.0% | | 1.01 | 1.15 | 8.55 |
| imported/rsc/hard-1k | 27 | 12904.70 ± 0.1% | not timed | not timed | 11736.89 ± 0.3% | 40.46 ± 0.1% | not timed | not timed | 12844.77 ± 0.3% | | 1.00 | 1.10 | 318.95 |
| imported/rsc/hard-32k | 27 | 403127.75 ± 0.1% | not timed | not timed | 365580.88 ± 0.2% | 29.24 ± 0.0% | not timed | not timed | 401036.70 ± 0.1% | | 1.01 | 1.10 | 13784.95 |
| imported/rsc/hard-1mb | 51 | 8402581.77 ± 0.2% | not timed | not timed | 7310332.53 ± 0.2% | 29.46 ± 0.2% | not timed | not timed | 8366848.64 ± 0.2% | | 1.00 | 1.15 | 285216.46 |
| imported/rsc/reallyhard0-32 | 58 | 263.39 ± 2.3% | not timed | not timed | 223.30 ± 0.2% | 49.58 ± 7.3% | not timed | not timed | 263.31 ± 0.1% | | 1.00 | 1.18 | 5.31 |
| imported/rsc/reallyhard0-1k | 27 | 580.13 ± 0.4% | not timed | not timed | 582.88 ± 0.1% | 40.75 ± 0.1% | not timed | not timed | 582.37 ± 0.1% | | 1.00 | 1.00 | 14.24 |
| imported/rsc/reallyhard0-32k | 27 | 602.81 ± 0.3% | not timed | not timed | 618.24 ± 0.0% | 29.41 ± 0.1% | not timed | not timed | 602.54 ± 0.3% | | 1.00 | 0.98 | 20.49 |
| imported/rsc/reallyhard0-1mb | 51 | 626.13 ± 1.4% | not timed | not timed | 618.04 ± 0.2% | 29.44 ± 0.0% | not timed | not timed | 623.46 ± 1.6% | | 1.00 | 1.01 | 21.27 |
| imported/rsc/reallyreallyhard0-32 | 47 | 284.60 ± 1.4% | not timed | not timed | 197.71 ± 0.1% | 60.53 ± 5.7% | not timed | not timed | 285.95 ± 7.1% | | 1.00 | 1.44 | 4.70 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7006.92 ± 0.1% | not timed | not timed | 5976.24 ± 0.0% | 34.22 ± 0.1% | not timed | not timed | 6994.82 ± 0.2% | | 1.00 | 1.17 | 204.78 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21477.42 ± 0.5% | not timed | not timed | 19289.13 ± 0.1% | 24.99 ± 4.3% | not timed | not timed | 21465.35 ± 0.3% | | 1.00 | 1.11 | 859.48 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21564.03 ± 0.4% | not timed | not timed | 19709.82 ± 1.1% | 25.15 ± 0.1% | not timed | not timed | 21589.26 ± 1.1% | | 1.00 | 1.09 | 857.32 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 280.93 ± 1.3% | not timed | not timed | 213.29 ± 0.3% | 61.26 ± 1.5% | not timed | not timed | 281.32 ± 15.3% | | 1.00 | 1.32 | 4.59 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5923.55 ± 0.1% | not timed | not timed | 6231.05 ± 0.1% | 34.36 ± 1.2% | not timed | not timed | 5935.86 ± 0.0% | | 1.00 | 0.95 | 172.39 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21303.55 ± 0.1% | not timed | not timed | 19275.92 ± 0.1% | 24.97 ± 0.1% | not timed | not timed | 21361.15 ± 0.1% | | 1.00 | 1.11 | 853.05 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21084.58 ± 0.8% | not timed | not timed | 19591.21 ± 1.1% | 24.89 ± 0.7% | not timed | not timed | 21143.52 ± 1.0% | | 1.00 | 1.08 | 846.98 |
| imported/sherlock/name-sherlock | 776 | 19507.10 ± 2.1% | not timed | not timed | 18348.72 ± 0.5% | 8587.79 ± 23.6% | not timed | not timed | 19517.00 ± 2.0% | | 1.00 | 1.06 | 2.27 |
| imported/sherlock/name-holmes | 2766 | 14983.03 ± 4.7% | not timed | not timed | 15459.47 ± 0.6% | 3062.23 ± 6.6% | not timed | not timed | 15225.24 ± 5.7% | | 0.98 | 0.97 | 4.89 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19580.59 ± 2.2% | not timed | not timed | 18304.18 ± 1.3% | 7970.67 ± 34.9% | not timed | not timed | 19653.65 ± 0.7% | | 1.00 | 1.07 | 2.46 |
| imported/sherlock/name-sherlock-casei | 816 | 15544.31 ± 1.0% | not timed | not timed | 4012.57 ± 0.1% | 32.22 ± 0.5% | not timed | not timed | 15575.32 ± 1.0% | | 1.00 | 3.87 | 482.43 |
| imported/sherlock/name-holmes-casei | 2802 | 9409.71 ± 5.7% | not timed | not timed | 3320.74 ± 0.1% | 37.30 ± 1.0% | not timed | not timed | 9432.22 ± 6.4% | | 1.00 | 2.83 | 252.26 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12896.54 ± 8.2% | not timed | not timed | 3943.58 ± 0.2% | 32.40 ± 0.2% | not timed | not timed | 12895.70 ± 1.7% | | 1.00 | 3.27 | 398.05 |
| imported/sherlock/name-whitespace | 1461 | 15147.50 ± 1.8% | not timed | not timed | 14369.24 ± 0.5% | 7320.28 ± 46.1% | not timed | not timed | 15144.99 ± 7.0% | | 1.00 | 1.05 | 2.07 |
| imported/sherlock/name-alt1 | 1142 | 11523.25 ± 2.3% | not timed | not timed | 16352.27 ± 0.7% | 4100.47 ± 28.1% | not timed | not timed | 11515.94 ± 0.5% | | 1.00 | 0.70 | 2.81 |
| imported/sherlock/name-alt2 | 3542 | 8902.54 ± 0.4% | not timed | not timed | 3831.17 ± 0.1% | 31.27 ± 0.0% | not timed | not timed | 8904.80 ± 0.4% | | 1.00 | 2.32 | 284.66 |
| imported/sherlock/name-alt3 | 4507 | 5534.94 ± 0.3% | not timed | not timed | 3629.95 ± 0.1% | 9.94 ± 2.5% | not timed | not timed | 5530.01 ± 0.5% | | 1.00 | 1.52 | 556.65 |
| imported/sherlock/name-alt3-casei | 4593 | 1526.55 ± 1.9% | not timed | not timed | 285.73 ± 0.3% | 6.45 ± 0.1% | not timed | not timed | 1524.81 ± 0.6% | | 1.00 | 5.34 | 236.71 |
| imported/sherlock/name-alt4 | 3686 | 6393.86 ± 1.1% | not timed | not timed | 3795.04 ± 0.2% | 31.36 ± 0.2% | not timed | not timed | 6371.58 ± 0.5% | | 1.00 | 1.68 | 203.89 |
| imported/sherlock/name-alt4-casei | 4254 | 2807.28 ± 3.9% | not timed | not timed | 2592.14 ± 0.1% | 19.81 ± 19.7% | not timed | not timed | 2816.92 ± 1.1% | | 1.00 | 1.08 | 141.73 |
| imported/sherlock/name-alt5 | 4028 | 6388.22 ± 0.4% | not timed | not timed | 3743.42 ± 0.1% | 21.86 ± 0.2% | not timed | not timed | 6390.63 ± 0.2% | | 1.00 | 1.71 | 292.25 |
| imported/sherlock/name-alt5-casei | 4104 | 3491.83 ± 1.2% | not timed | not timed | 2230.68 ± 0.1% | 14.33 ± 0.2% | not timed | not timed | 3485.10 ± 0.8% | | 1.00 | 1.57 | 243.75 |
| imported/sherlock/no-match-uncommon | 0 | 21200.85 ± 1.1% | not timed | not timed | 19153.22 ± 1.6% | 34217.66 ± 0.6% | not timed | not timed | 21335.00 ± 1.2% | | 0.99 | 1.11 | 0.62 |
| imported/sherlock/no-match-common | 0 | 21142.17 ± 0.6% | not timed | not timed | 19281.18 ± 1.3% | 1281.25 ± 1.2% | not timed | not timed | 21106.10 ± 0.5% | | 1.00 | 1.10 | 16.50 |
| imported/sherlock/no-match-really-common | 0 | 15970.08 ± 2.8% | not timed | not timed | 18485.81 ± 1.1% | 1282.33 ± 1.3% | not timed | not timed | 16180.01 ± 1.6% | | 0.99 | 0.86 | 12.45 |
| imported/sherlock/the-lower | 21654 | 2303.65 ± 1.2% | not timed | not timed | 2333.75 ± 0.3% | 238.87 ± 18.7% | not timed | not timed | 2314.45 ± 1.1% | | 1.00 | 0.99 | 9.64 |
| imported/sherlock/the-upper | 2223 | 12660.37 ± 1.6% | not timed | not timed | 13525.21 ± 1.2% | 2560.70 ± 13.1% | not timed | not timed | 12769.72 ± 1.0% | | 0.99 | 0.94 | 4.94 |
| imported/sherlock/the-casei | 23961 | 1989.56 ± 0.3% | not timed | not timed | 1314.47 ± 0.3% | 34.69 ± 11.1% | not timed | not timed | 1992.82 ± 7.0% | | 1.00 | 1.51 | 57.35 |
| imported/sherlock/everything-greedy | 581881 | 282.53 ± 0.7% | not timed | not timed | 163.53 ± 0.3% | 28.85 ± 24.3% | not timed | not timed | 281.79 ± 0.1% | | 1.00 | 1.73 | 9.79 |
| imported/sherlock/everything-greedy-nl | 594933 | 490.90 ± 0.1% | not timed | not timed | 212.28 ± 0.1% | 32.95 ± 0.0% | not timed | not timed | 489.83 ± 0.2% | | 1.00 | 2.31 | 14.90 |
| imported/sherlock/letters | 447175 | 61.56 ± 8.3% | not timed | not timed | 33.25 ± 0.4% | 5.18 ± 12.3% | not timed | not timed | 61.89 ± 1.1% | | 0.99 | 1.85 | 11.90 |
| imported/sherlock/letters-upper | 14180 | 448.53 ± 4.3% | not timed | not timed | 369.76 ± 0.1% | 29.61 ± 20.3% | not timed | not timed | 446.67 ± 0.2% | | 1.00 | 1.21 | 15.15 |
| imported/sherlock/letters-lower | 432995 | 62.55 ± 1.0% | not timed | not timed | 33.94 ± 0.2% | 4.91 ± 30.9% | not timed | not timed | 63.08 ± 1.0% | | 0.99 | 1.84 | 12.73 |
| imported/sherlock/words | 447639 | 112.14 ± 1.3% | not timed | not timed | 82.73 ± 0.1% | 13.85 ± 5.5% | not timed | not timed | 113.24 ± 0.9% | | 0.99 | 1.36 | 8.10 |
| imported/sherlock/before-holmes | 4073 | 10230.35 ± 0.9% | not timed | not timed | 8440.81 ± 1.1% | 23.98 ± 2.4% | not timed | not timed | 10252.81 ± 0.3% | | 1.00 | 1.21 | 426.61 |
| imported/sherlock/before-after-holmes | 2593 | 9894.24 ± 1.0% | not timed | not timed | 9468.65 ± 0.4% | 23.86 ± 1.2% | not timed | not timed | 9921.89 ± 0.7% | | 1.00 | 1.04 | 414.67 |
| imported/sherlock/holmes-cochar-watson | 150 | 5181.99 ± 0.2% | not timed | not timed | 3429.35 ± 0.1% | 30.98 ± 0.1% | not timed | not timed | 5190.37 ± 0.3% | | 1.00 | 1.51 | 167.28 |
| imported/sherlock/holmes-coword-watson | 14309 | 1151.93 ± 0.2% | not timed | not timed | 1124.49 ± 0.1% | 6.76 ± 0.2% | not timed | not timed | 1151.35 ± 0.3% | | 1.00 | 1.02 | 170.42 |
| imported/sherlock/quotes | 14437 | 1573.18 ± 0.4% | not timed | not timed | 1755.75 ± 0.6% | 35.16 ± 0.3% | not timed | not timed | 1572.84 ± 0.7% | | 1.00 | 0.90 | 44.75 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17234.66 ± 0.6% | not timed | not timed | 15847.55 ± 0.7% | 36.33 ± 0.1% | not timed | not timed | 17224.34 ± 0.8% | | 1.00 | 1.09 | 474.41 |
| imported/sherlock/word-ending-n | 35297 | 480.68 ± 1.1% | not timed | not timed | 409.15 ± 0.1% | 23.41 ± 20.9% | not timed | not timed | 391.83 ± 0.4% | | 1.23 | 1.17 | 20.54 |
| imported/sherlock/repeated-class-negation | 2130 | 14613.95 ± 0.3% | not timed | not timed | 10825.47 ± 0.5% | 11.59 ± 1.3% | not timed | not timed | 14584.35 ± 0.5% | | 1.00 | 1.35 | 1261.00 |
| imported/sherlock/ing-suffix | 20547 | 559.90 ± 0.5% | not timed | not timed | 517.04 ± 0.4% | 28.81 ± 0.2% | not timed | not timed | 559.23 ± 0.3% | | 1.00 | 1.08 | 19.43 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1671.75 ± 0.1% | not timed | not timed | 2108.88 ± 0.3% | 20.53 ± 0.2% | not timed | not timed | 1670.70 ± 0.4% | | 1.00 | 0.79 | 81.45 |
| opt/accelerate/whole-line | 239963 | 457.17 ± 0.4% | not timed | not timed | 372.16 ± 0.2% | 92.15 ± 16.6% | not timed | not timed | 457.09 ± 0.2% | | 1.00 | 1.23 | 4.96 |
| opt/accelerate/non-dna | 16745 | 431.56 ± 0.5% | not timed | not timed | 401.38 ± 0.1% | 29.23 ± 20.4% | not timed | not timed | 430.59 ± 0.8% | | 1.00 | 1.08 | 14.76 |
| opt/backtrack/words-english | 40536 | 139.19 ± 2.5% | not timed | not timed | 94.51 ± 0.1% | 19.69 ± 7.2% | not timed | not timed | 141.66 ± 0.1% | | 0.98 | 1.47 | 7.07 |
| opt/fixed-length/too-small-ascii | 0 | 311.68 ± 0.2% | not timed | not timed | 700.48 ± 1.0% | 80.59 ± 0.6% | not timed | not timed | 316.89 ± 0.3% | | 0.98 | 0.44 | 3.87 |
| opt/fixed-length/too-big-ascii | 0 | 3467.12 ± 0.1% | not timed | not timed | 5868.03 ± 0.4% | 121.74 ± 0.2% | not timed | not timed | 3459.01 ± 0.1% | | 1.00 | 0.59 | 28.48 |
| opt/fixed-length/go33484-1 | 0 | 665649.97 ± 0.1% | not timed | not timed | 1109528.01 ± 0.4% | 61497.48 ± 0.3% | not timed | not timed | 666293.34 ± 0.1% | | 1.00 | 0.60 | 10.82 |
| opt/fixed-length/go33484-2 | 0 | 665894.65 ± 0.2% | not timed | not timed | 1118187.77 ± 0.2% | 32405.48 ± 1.1% | not timed | not timed | 666197.75 ± 0.1% | | 1.00 | 0.60 | 20.55 |
| opt/fixed-length/go33484-3 | 0 | 66604.60 ± 0.8% | not timed | not timed | 112631.09 ± 0.3% | 771.31 ± 0.1% | not timed | not timed | 66611.33 ± 0.6% | | 1.00 | 0.59 | 86.35 |
| opt/literal-alt/one-pattern | 1 | 549.28 ± 1.8% | not timed | not timed | 544.08 ± 0.4% | 0.39 ± 0.3% | not timed | not timed | 550.54 ± 1.9% | | 1.00 | 1.01 | 1394.03 |
| opt/onepass/fn-predicate | 916 | 368.46 ± 0.7% | not timed | not timed | 337.47 ± 0.2% | 202.86 ± 14.0% | not timed | not timed | 370.25 ± 0.9% | | 1.00 | 1.09 | 1.82 |
| opt/onepass/first-three-words-english | 35128 | 181.60 ± 2.4% | not timed | not timed | 202.88 ± 0.1% | 82.64 ± 13.2% | not timed | not timed | 182.24 ± 2.4% | | 1.00 | 0.90 | 2.20 |
| opt/prefilter/literal-english | 1 | 20570.02 ± 0.8% | not timed | not timed | 19868.56 ± 0.5% | 17442.31 ± 0.6% | not timed | not timed | 20682.00 ± 0.3% | | 0.99 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14467.26 ± 0.9% | not timed | not timed | 4311.13 ± 0.3% | 32.60 ± 0.6% | not timed | not timed | 14505.45 ± 0.5% | | 1.00 | 3.36 | 443.82 |
| opt/prefilter/literal-russian | 1 | 20838.89 ± 0.9% | not timed | not timed | 19525.79 ± 0.8% | 3324.07 ± 0.4% | not timed | not timed | 20862.61 ± 0.6% | | 1.00 | 1.07 | 6.27 |
| opt/prefilter/literal-casei-russian | 1 | 8598.57 ± 0.2% | not timed | not timed | 3894.34 ± 0.4% | 31.86 ± 0.3% | not timed | not timed | 8599.77 ± 0.2% | | 1.00 | 2.21 | 269.89 |
| opt/prefilter/rust-functions | 948 | 6806.06 ± 1.7% | not timed | not timed | 8880.76 ± 0.6% | 1869.12 ± 29.0% | not timed | not timed | 6809.81 ± 0.5% | | 1.00 | 0.77 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 29625618.53 ± 0.1% | not timed | not timed | 21927378.51 ± 0.1% | 50.25 ± 0.2% | not timed | not timed | 29645550.02 ± 0.1% | | 1.00 | 1.35 | 589529.13 |
| opt/reverse-inner/holmes | 2593 | 9894.32 ± 1.3% | not timed | not timed | 9478.63 ± 0.5% | 24.15 ± 2.5% | not timed | not timed | 9901.22 ± 0.7% | | 1.00 | 1.04 | 409.73 |
| opt/reverse-inner/email | 47 | 36216.71 ± 1.6% | not timed | not timed | 44725.22 ± 0.7% | 32.41 ± 0.4% | not timed | not timed | 36681.87 ± 1.9% | | 0.99 | 0.81 | 1117.45 |
| opt/reverse-inner/factored-prefix | 3542 | 593.16 ± 0.5% | not timed | not timed | 595.12 ± 0.1% | 12.58 ± 0.2% | not timed | not timed | 592.53 ± 0.4% | | 1.00 | 1.00 | 47.14 |
| opt/reverse-inner/no-quadratic-backward | 0 | 21016.29 ± 0.1% | not timed | not timed | 616.73 ± 0.4% | 74.87 ± 0.2% | not timed | not timed | 21167.39 ± 0.1% | | 0.99 | 34.08 | 280.69 |
| opt/reverse-inner/no-quadratic-forward | 0 | 734.41 ± 2.6% | not timed | not timed | 288.33 ± 0.4% | 24.71 ± 0.1% | not timed | not timed | 739.86 ± 5.0% | | 0.99 | 2.55 | 29.73 |
| opt/reverse-suffix/holmes | 4073 | 10231.50 ± 0.6% | not timed | not timed | 8419.19 ± 0.5% | 24.06 ± 0.8% | not timed | not timed | 10232.24 ± 0.7% | | 1.00 | 1.22 | 425.19 |
| opt/reverse-suffix/no-quadratic | 0 | 21082.90 ± 0.1% | not timed | not timed | 613.65 ± 0.3% | 74.91 ± 0.1% | not timed | not timed | 21160.36 ± 0.1% | | 1.00 | 34.36 | 281.45 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.12 ± 1.8% | not timed | not timed | 130.11 ± 0.2% | 13.18 ± 15.5% | not timed | not timed | 121.32 ± 3.3% | | 1.00 | 0.93 | 9.19 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.87 ± 3.0% | not timed | not timed | 130.89 ± 0.1% | 13.16 ± 14.3% | not timed | not timed | 120.94 ± 2.3% | | 1.00 | 0.92 | 9.19 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.2% | not timed | not timed | 0.55 ± 0.2% | 110.58 ± 2.1% | not timed | not timed | 0.28 ± 0.2% | | 0.99 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 322.21 ± 0.4% | not timed | not timed | 294.94 ± 0.1% | 104.53 ± 0.4% | not timed | not timed | 322.40 ± 0.3% | | 1.00 | 1.09 | 3.08 |
| reported/i13-subset-regex/original-ascii | 4094 | 11210.85 ± 0.7% | not timed | not timed | 4480.03 ± 0.5% | 11.51 ± 0.1% | not timed | not timed | 11259.51 ± 1.3% | | 1.00 | 2.50 | 973.59 |
| reported/i13-subset-regex/original-unicode | 4094 | 11056.80 ± 1.3% | not timed | not timed | 250.79 ± 3.3% | 11.52 ± 1.3% | not timed | not timed | 11250.98 ± 2.6% | | 0.98 | 44.09 | 959.77 |
| reported/i13-subset-regex/big-ascii | 1955 | 10697.12 ± 1.0% | not timed | not timed | 65.51 ± 3.6% | 9.88 ± 0.2% | not timed | not timed | 10755.26 ± 0.9% | | 0.99 | 163.29 | 1082.71 |
| reported/i13-subset-regex/big-unicode | 1955 | 10549.05 ± 1.8% | not timed | not timed | 12.31 ± 54.9% | 9.86 ± 0.2% | not timed | not timed | 10701.84 ± 0.4% | | 0.99 | 856.85 | 1069.52 |
| reported/i13-subset-regex/huge-ascii | 55 | 9868.74 ± 3.3% | not timed | not timed | 11.05 ± 0.1% | 8.78 ± 0.1% | not timed | not timed | 9887.00 ± 2.6% | | 1.00 | 892.92 | 1123.39 |
| reported/i13-subset-regex/huge-unicode | 55 | 9797.16 ± 3.2% | not timed | not timed | 11.01 ± 0.4% | 8.80 ± 0.1% | not timed | not timed | 9764.07 ± 3.5% | | 1.00 | 889.88 | 1113.59 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.1% | not timed | not timed | 11.04 ± 0.1% | 8.78 ± 1.1% | not timed | not timed | 3.53 ± 0.1% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.97 ± 0.1% | not timed | not timed | 10.97 ± 0.3% | 8.79 ± 0.2% | not timed | not timed | 4.97 ± 0.1% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 483.91 ± 0.3% | not timed | not timed | 104.62 ± 0.1% | 6.50 ± 0.1% | not timed | not timed | 484.59 ± 0.4% | | 1.00 | 4.63 | 74.47 |
| reported/i787-keywords/opt-ascii | 5674 | 485.31 ± 0.1% | not timed | not timed | 270.68 ± 0.3% | 10.29 ± 0.4% | not timed | not timed | 482.95 ± 0.3% | | 1.00 | 1.79 | 47.18 |
| slow/quadratic-regex-1x | 100 | 7.09 ± 10.3% | not timed | not timed | 4.97 ± 0.3% | 0.05 ± 0.4% | not timed | not timed | 7.14 ± 0.5% | | 0.99 | 1.43 | 144.12 |
| slow/quadratic-regex-2x | 199 | 3.43 ± 0.4% | not timed | not timed | 2.67 ± 0.3% | 0.01 ± 0.3% | not timed | not timed | 3.44 ± 0.1% | | 1.00 | 1.28 | 269.55 |
| slow/quadratic-haystack-1x | 100 | 22.02 ± 0.5% | not timed | not timed | 10.02 ± 0.2% | 1.01 ± 8.4% | not timed | not timed | 21.95 ± 6.2% | | 1.00 | 2.20 | 21.84 |
| slow/quadratic-haystack-2x | 200 | 19.71 ± 1.0% | not timed | not timed | 5.53 ± 0.1% | 0.54 ± 14.1% | not timed | not timed | 19.69 ± 1.5% | | 1.00 | 3.57 | 36.21 |
| unicode/codepoints/any-one | 1112064 | 281.83 ± 0.3% | not timed | not timed | 174.63 ± 0.3% | 18.39 ± 1.4% | not timed | not timed | 282.48 ± 0.3% | | 1.00 | 1.61 | 15.32 |
| unicode/codepoints/any-all | 4382592 | 282.51 ± 1.0% | not timed | not timed | 247.08 ± 0.2% | 117.27 ± 0.0% | not timed | not timed | 283.23 ± 1.0% | | 1.00 | 1.14 | 2.41 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.76 ± 1.3% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 604.27 ± 0.7% | not timed | not timed | 615.54 ± 0.1% | 135.25 ± 0.5% | not timed | not timed | 603.62 ± 0.3% | | 1.00 | 0.98 | 4.47 |
| unicode/overlapping-words/ascii | 6156 | 32.28 ± 0.3% | not timed | not timed | 38.71 ± 0.2% | 3.94 ± 1.3% | not timed | not timed | 32.34 ± 0.3% | | 1.00 | 0.83 | 8.18 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.2% | not timed | not timed | 4.12 ± 0.2% | 2.33 ± 0.7% | not timed | not timed | 1.43 ± 0.3% | | 1.01 | 0.35 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.5% | not timed | not timed | 4.13 ± 0.3% | 6.20 ± 10.0% | not timed | not timed | 1.27 ± 0.1% | | 1.00 | 0.31 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 128.47 ± 5.1% | not timed | not timed | 83.04 ± 0.4% | 11.38 ± 18.7% | not timed | not timed | 128.12 ± 2.5% | | 1.00 | 1.55 | 11.29 |
| unicode/word/boundary-long-english | 3466 | 608.00 ± 0.3% | not timed | not timed | 606.48 ± 0.3% | 32.70 ± 1.4% | not timed | not timed | 606.68 ± 0.7% | | 1.00 | 1.00 | 18.59 |
| unicode/word/around-holmes-english | 27 | 19704.44 ± 0.5% | not timed | not timed | 19380.72 ± 0.2% | 22.08 ± 0.7% | not timed | not timed | 19888.20 ± 0.4% | | 0.99 | 1.02 | 892.43 |
| wild/bibleref/long | 874 | 564.40 ± 0.2% | not timed | not timed | 581.00 ± 0.2% | 6.75 ± 0.1% | not timed | not timed | 566.40 ± 0.2% | | 1.00 | 0.97 | 83.66 |
| wild/bibleref/short | 30 | 24.03 ± 2.6% | not timed | not timed | 30.55 ± 0.5% | 14.16 ± 12.3% | not timed | not timed | 24.30 ± 3.9% | | 0.99 | 0.79 | 1.70 |
| wild/bibleref/line | 874 | 398.98 ± 0.2% | not timed | not timed | 210.50 ± 0.1% | 9.20 ± 8.1% | not timed | not timed | 399.54 ± 1.6% | | 1.00 | 1.90 | 43.34 |
| wild/caddy/caddy | 6 | 420.48 ± 4.2% | not timed | not timed | 247.10 ± 0.1% | 68.77 ± 15.3% | not timed | not timed | 420.36 ± 1.3% | | 1.00 | 1.70 | 6.11 |
| wild/dot-star-capture/rust-src-tools | 6 | 1069.93 ± 0.2% | not timed | not timed | 344.81 ± 0.1% | 13.52 ± 0.2% | not timed | not timed | 1065.07 ± 0.2% | | 1.00 | 3.10 | 79.14 |
| wild/ruff/noqa | 84 | 438.91 ± 0.4% | not timed | not timed | 461.46 ± 0.1% | 19.55 ± 2.2% | not timed | not timed | 438.88 ± 0.6% | | 1.00 | 0.95 | 22.45 |
| wild/ruff/unnecessary-coding-comment | 16 | 957.46 ± 0.5% | not timed | not timed | 700.58 ± 0.3% | 135.92 ± 11.4% | not timed | not timed | 959.03 ± 0.4% | | 1.00 | 1.37 | 7.04 |
| wild/ruff/string-quote-prefix | 2972 | 1362.86 ± 0.7% | not timed | not timed | 405.75 ± 0.2% | 313.33 ± 26.1% | not timed | not timed | 1363.81 ± 0.6% | | 1.00 | 3.36 | 4.35 |
| wild/ruff/space-around-operator | 1224378 | 223.08 ± 1.9% | not timed | not timed | 186.48 ± 0.1% | 18.33 ± 1.7% | not timed | not timed | 223.81 ± 1.7% | | 1.00 | 1.20 | 12.17 |
| wild/ruff/shebang | 282 | 972.45 ± 0.4% | not timed | not timed | 330.49 ± 0.1% | 116.98 ± 9.5% | not timed | not timed | 977.96 ± 0.3% | | 0.99 | 2.94 | 8.31 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13817.37 ± 0.2% | not timed | not timed | 13869.39 ± 0.6% | 6929.16 ± 0.9% | not timed | not timed | 13819.84 ± 0.5% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12773.71 ± 0.7% | not timed | not timed | 13341.85 ± 1.0% | 6385.94 ± 0.7% | not timed | not timed | 12769.00 ± 0.6% | | 1.00 | 0.96 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13143.15 ± 0.6% | not timed | not timed | 13556.55 ± 0.5% | 6586.87 ± 1.1% | not timed | not timed | 13133.75 ± 0.7% | | 1.00 | 0.97 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9537.88 ± 4.0% | not timed | not timed | 13483.48 ± 4.0% | 6678.92 ± 4.3% | not timed | not timed | 9554.63 ± 4.2% | | 1.00 | 0.71 | 1.43 |
| wild/url/search | 234965 | 120.75 ± 13.7% | not timed | not timed | 65.31 ± 0.3% | 2.20 ± 0.8% | not timed | not timed | 120.72 ± 14.1% | | 1.00 | 1.85 | 54.81 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 1.2% | not timed | not timed | 0.01 ± 2.3% | 0.01 ± 19.5% | not timed | not timed | 0.03 ± 0.5% | | 1.00 | 3.11 | 4.19 |
| dictionary/compile/english-15 | 1 | 0.35 ± 4.3% | not timed | not timed | 0.07 ± 0.5% | 0.10 ± 27.2% | not timed | not timed | 0.35 ± 3.9% | | 0.99 | 4.98 | 3.43 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 17.4% | not timed | not timed | 0.02 ± 0.6% | 35.09 ± 3.6% | not timed | not timed | 0.25 ± 2.2% | | 0.98 | 12.88 | 0.0070 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.37 ± 2.4% | not timed | not timed | 11.58 ± 0.4% | 60.01 ± 21.7% | not timed | not timed | 47.73 ± 0.6% | | 0.99 | 4.09 | 0.79 |
| reported/i787-keywords/compile | 1 | 35.48 ± 17.1% | not timed | not timed | 2.12 ± 0.8% | 17.20 ± 23.2% | not timed | not timed | 35.58 ± 2.6% | | 1.00 | 16.75 | 2.06 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 360.94 ± 5.2% | not timed | not timed | 124.61 ± 0.3% | 566.19 ± 30.5% | not timed | not timed | 364.95 ± 1.9% | | 0.99 | 2.90 | 0.64 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.79 ± 1.7% | not timed | not timed | 4.10 ± 0.4% | 43.74 ± 6.5% | not timed | not timed | 48.55 ± 2.4% | | 0.98 | 11.66 | 1.09 |
| unicode/compile/one-letter | 53 | 6.73 ± 13.8% | not timed | not timed | 4.56 ± 0.5% | 64.90 ± 6.6% | not timed | not timed | 6.79 ± 1.5% | | 0.99 | 1.48 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.08 ± 18.0% | not timed | not timed | 0.10 ± 0.6% | 64.26 ± 10.4% | not timed | not timed | 1.11 ± 5.3% | | 0.98 | 10.83 | 0.0169 |
| unicode/compile/fifty-letters-ascii | 1 | 214.50 ± 12.9% | not timed | not timed | 52.62 ± 0.2% | 192.81 ± 16.3% | not timed | not timed | 223.88 ± 8.7% | | 0.96 | 4.08 | 1.11 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 385.10 ± 7.9% | not timed | not timed | 47.40 ± 0.4% | 675.24 ± 22.9% | not timed | not timed | 386.26 ± 2.9% | | 1.00 | 8.13 | 0.57 |
| unicode/compile/match-every-line-ascii | 4 | 611.00 ± 3.2% | not timed | not timed | 145.82 ± 0.3% | 659.52 ± 31.0% | not timed | not timed | 614.12 ± 7.6% | | 0.99 | 4.19 | 0.93 |
| unicode/compile/negated-class-matches-codepoint | 1 | 322.71 ± 4.5% | not timed | not timed | 51.28 ± 0.3% | 1233.32 ± 4.4% | not timed | not timed | 331.68 ± 2.6% | | 0.97 | 6.29 | 0.26 |
| wild/bibleref/compile | 3 | 5.71 ± 17.2% | not timed | not timed | 1.93 ± 0.5% | 32.13 ± 15.3% | not timed | not timed | 5.95 ± 9.1% | | 0.96 | 2.96 | 0.18 |
| wild/url/compile | 1 | 0.65 ± 17.2% | not timed | not timed | 0.14 ± 0.3% | 0.42 ± 27.9% | not timed | not timed | 0.66 ± 0.8% | | 0.99 | 4.50 | 1.55 |

