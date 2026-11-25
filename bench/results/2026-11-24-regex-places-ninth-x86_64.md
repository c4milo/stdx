# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507011788 |
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
| literal: a word | 217 | 48382.79 ± 0.4% | 4000.23 ± 1.5% | 32.68 ± 0.6% | 37864.82 ± 1.2% | 12121.53 ± 4.1% | 12.90 ± 0.4% | 104.03 ± 0.3% | 48432.10 ± 1.4% | 12.10 | 1.00 | 1.28 | 3.99 |
| literal: a word that is not there | 0 | 63452.09 ± 0.3% | 3884.31 ± 1.5% | 32.63 ± 0.2% | 45855.60 ± 0.4% | 44354.84 ± 1.0% | 12.78 ± 0.3% | 98.47 ± 2.8% | 63542.55 ± 0.4% | 16.34 | 1.00 | 1.38 | 1.43 |
| literal: one of four words | 661 | 17043.26 ± 0.4% | 1694.47 ± 0.3% | 16.99 ± 0.5% | 11171.27 ± 0.2% | 24.92 ± 0.0% | 4.47 ± 0.4% | 8.65 ± 5.5% | 17029.06 ± 7.6% | 10.06 | 1.00 | 1.53 | 683.91 |
| literal: a word in any case | 217 | 42251.96 ± 0.2% | 1806.34 ± 0.3% | 24.16 ± 4.5% | 11378.99 ± 3.9% | 47.26 ± 0.3% | refused | differs | 42311.71 ± 0.4% | 23.39 | 1.00 | 3.71 | 894.01 |
| literal: an href attribute | 33 | 41644.77 ± 0.8% | 615.36 ± 0.2% | 29.87 ± 0.6% | 34984.18 ± 2.0% | 3022.19 ± 16.2% | 9.69 ± 0.6% | 91.31 ± 9.7% | 41572.20 ± 0.6% | 67.68 | 1.00 | 1.19 | 13.78 |
| literal: a word, second text | 123 | 50594.81 ± 0.4% | 3131.37 ± 1.0% | 32.37 ± 0.5% | 39739.95 ± 0.9% | 11125.37 ± 3.0% | 14.46 ± 1.0% | 88.38 ± 0.8% | 50568.27 ± 1.6% | 16.16 | 1.00 | 1.27 | 4.55 |
| class: two capitalized words | 1331 | 925.78 ± 0.1% | 611.74 ± 0.2% | 30.22 ± 0.9% | 575.60 ± 0.5% | 44.45 ± 0.7% | 11.07 ± 0.2% | 79.52 ± 0.6% | 926.64 ± 0.3% | 1.51 | 1.00 | 1.61 | 20.83 |
| class: a word that ends in ing | 3399 | 583.61 ± 0.6% | 584.57 ± 0.2% | 20.37 ± 1.8% | 538.15 ± 0.6% | 32.39 ± 8.7% | 6.19 ± 0.5% | 20.59 ± 1.3% | 585.54 ± 0.3% | 1.00 | 1.00 | 1.08 | 18.02 |
| class: a word in capitals | 2332 | 1160.67 ± 0.2% | 617.34 ± 0.1% | 29.53 ± 0.4% | 564.71 ± 0.4% | 47.65 ± 4.1% | 12.48 ± 0.2% | 102.26 ± 0.3% | 1159.82 ± 0.6% | 1.88 | 1.00 | 2.06 | 24.36 |
| class: a number | 8288 | 2030.80 ± 5.9% | 854.85 ± 3.3% | 32.48 ± 1.3% | 1773.38 ± 0.4% | 47.66 ± 13.8% | 0.39 ± 0.4% | 73.22 ± 0.8% | 2010.38 ± 0.2% | 2.38 | 1.01 | 1.15 | 42.61 |
| class: two capitalized words, second text | 5359 | 522.54 ± 0.2% | 530.16 ± 0.4% | 27.06 ± 1.7% | 477.64 ± 1.2% | 38.92 ± 24.7% | 12.75 ± 0.2% | 73.99 ± 0.2% | 522.38 ± 0.6% | 0.99 | 1.00 | 1.09 | 13.43 |
| other: a word between two words | 6104 | 922.22 ± 4.4% | 607.41 ± 0.3% | 26.89 ± 6.1% | 812.46 ± 0.3% | 122.91 ± 17.7% | 8.60 ± 0.1% | 82.51 ± 0.2% | 925.22 ± 0.2% | 1.52 | 1.00 | 1.14 | 7.50 |
| other: a number before a unit, second text | 1481 | 11241.46 ± 11.7% | 1067.73 ± 0.4% | 29.87 ± 6.4% | 8286.57 ± 0.5% | 45.38 ± 0.9% | 13.32 ± 0.5% | 77.88 ± 7.7% | 11175.97 ± 0.4% | 10.53 | 1.01 | 1.36 | 247.74 |
| other: a heading's start tag | 110 | 26524.33 ± 0.1% | 747.66 ± 0.2% | 32.10 ± 7.8% | 2501.42 ± 0.3% | 2006.69 ± 10.4% | 11.86 ± 0.1% | 107.25 ± 2.8% | 26472.49 ± 4.8% | 35.48 | 1.00 | 10.60 | 13.22 |
| other: a whole word | 217 | 34187.05 ± 0.5% | 608.07 ± 0.1% | 32.27 ± 1.6% | 27916.96 ± 0.8% | 54.34 ± 0.7% | 11.24 ± 0.1% | 63.35 ± 0.3% | 34323.76 ± 0.3% | 56.22 | 1.00 | 1.22 | 629.09 |
| other: a line's first word, second text | 3716 | 2796.20 ± 0.4% | 599.67 ± 0.2% | 35.24 ± 1.4% | 2317.81 ± 2.7% | 71.15 ± 3.4% | refused | refused | 2797.51 ± 1.0% | 4.66 | 1.00 | 1.21 | 39.30 |
| other: fourteen octets before an x | 87 | 38559.66 ± 0.3% | 252.25 ± 0.7% | 7.39 ± 0.8% | 3494.40 ± 0.3% | 11.56 ± 0.4% | differs | 21.30 ± 2.7% | 38823.31 ± 0.3% | 152.86 | 0.99 | 11.03 | 3334.51 |
| other: a Greek word | 21815 | 516.55 ± 1.0% | 442.29 ± 0.3% | 34.60 ± 0.7% | 303.07 ± 0.2% | 54.28 ± 9.1% | differs | refused | 518.66 ± 0.5% | 1.17 | 1.00 | 1.70 | 9.52 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 31.46 ± 1.0% | 31.35 ± 0.2% | 1.00 ± 1.3% | 19.77 ± 0.5% | 2.12 ± 0.4% | differs | 4.31 ± 2.4% | 26.24 ± 1.7% | 1.00 | 1.20 | 1.59 | 14.87 |
| a UUID | 32895 | 26.56 ± 0.4% | 27.59 ± 0.2% | 0.69 ± 2.9% | 15.12 ± 0.3% | 3.02 ± 2.7% | 0.52 ± 0.4% | 3.83 ± 0.8% | 27.47 ± 0.1% | 0.96 | 0.97 | 1.76 | 8.80 |
| an IPv4 address | 33176 | 40.59 ± 0.2% | 40.58 ± 0.5% | 2.23 ± 0.5% | 28.40 ± 0.3% | 6.99 ± 1.5% | differs | 3.88 ± 0.9% | 40.62 ± 1.4% | 1.00 | 1.00 | 1.43 | 5.81 |
| a date and time | 32954 | 37.77 ± 1.1% | 37.95 ± 1.1% | 1.67 ± 1.1% | 21.68 ± 0.2% | 8.08 ± 2.1% | 0.91 ± 0.5% | 8.07 ± 0.8% | 37.52 ± 1.1% | 1.00 | 1.01 | 1.74 | 4.67 |
| a field path | 32606 | 34.95 ± 0.4% | 34.67 ± 2.1% | 1.04 ± 0.9% | 22.93 ± 0.3% | 3.47 ± 13.7% | differs | 3.08 ± 1.0% | 34.99 ± 2.6% | 1.01 | 1.00 | 1.52 | 10.07 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.79 ± 5.0% | 10.94 ± 0.4% | 10.93 ± 0.6% | 13.23 ± 1.8% | 5.83 ± 4.2% | 0.76 ± 3.7% | none | 10.90 ± 0.5% | 0.99 | 0.99 | 0.82 | 1.85 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 231.95 ± 0.2% | 231.81 ± 6.0% | 271.81 ± 5.3% | 101.96 ± 1.1% | 243.32 ± 1.6% | 709.99 ± 4.7% | 4952.06 ± 0.2% | 231.93 ± 1.8% | 1.00 | 1.00 | 2.27 | 0.95 |
| a UUID | 62 | 152.23 ± 0.5% | 152.29 ± 0.5% | 170.75 ± 0.2% | 59.09 ± 1.9% | 117.23 ± 10.1% | 256.01 ± 2.2% | 5403.73 ± 0.3% | 152.50 ± 0.2% | 1.00 | 1.00 | 2.58 | 1.30 |
| an IPv4 address | 29 | 478.76 ± 8.2% | 479.37 ± 0.3% | 685.78 ± 0.5% | 88.28 ± 1.2% | 147.27 ± 2.2% | 418.32 ± 2.1% | 8940.48 ± 0.3% | 479.62 ± 0.3% | 1.00 | 1.00 | 5.42 | 3.25 |
| a date and time | 56 | 347.30 ± 0.2% | 347.73 ± 0.2% | 445.53 ± 0.3% | 86.62 ± 0.5% | 159.50 ± 26.2% | 468.21 ± 8.6% | 5708.14 ± 0.3% | 347.81 ± 0.5% | 1.00 | 1.00 | 4.01 | 2.18 |
| a field path | 39 | 224.51 ± 0.4% | 224.75 ± 0.1% | 261.27 ± 0.6% | 95.70 ± 3.8% | 226.06 ± 14.9% | 756.71 ± 1.6% | 6011.24 ± 2.8% | 224.67 ± 0.3% | 1.00 | 1.00 | 2.35 | 0.99 |
| literal: a word | 7 | 699.63 ± 0.6% | 747.59 ± 0.2% | 1368.80 ± 1.7% | 647.17 ± 1.7% | 784.32 ± 1.2% | 1652.91 ± 0.4% | 34139.89 ± 0.4% | 699.82 ± 0.9% | 0.94 | 1.00 | 1.08 | 0.89 |
| literal: a word that is not there | 8 | 676.19 ± 0.3% | 725.23 ± 0.3% | 1310.03 ± 0.2% | 586.61 ± 1.3% | 753.92 ± 1.9% | 1553.68 ± 0.6% | 33409.68 ± 1.1% | 676.82 ± 0.9% | 0.93 | 1.00 | 1.15 | 0.90 |
| literal: one of four words | 26 | 260.39 ± 0.4% | 439.54 ± 0.5% | 608.60 ± 0.3% | 53.00 ± 1.2% | 289.11 ± 1.6% | 591.16 ± 2.4% | 17946.17 ± 1.6% | 260.33 ± 0.9% | 0.59 | 1.00 | 4.91 | 0.90 |
| literal: a word in any case | 11 | 486.10 ± 0.7% | 514.36 ± 0.3% | 752.58 ± 0.4% | 18.93 ± 0.8% | 813.80 ± 27.4% | refused | 27601.27 ± 0.7% | 486.47 ± 0.7% | 0.95 | 1.00 | 25.68 | 0.60 |
| literal: an href attribute | 12 | 387.53 ± 0.8% | 399.72 ± 0.3% | 534.84 ± 0.3% | 50.36 ± 0.5% | 564.48 ± 2.8% | 1253.05 ± 0.8% | 24625.02 ± 0.5% | 387.57 ± 0.6% | 0.97 | 1.00 | 7.70 | 0.69 |
| literal: a word, second text | 10 | 634.58 ± 0.6% | 687.82 ± 0.5% | 1180.51 ± 1.0% | 539.50 ± 0.7% | 645.68 ± 3.8% | 1323.00 ± 0.9% | 32044.43 ± 0.3% | 633.25 ± 0.6% | 0.92 | 1.00 | 1.18 | 0.98 |
| class: two capitalized words | 23 | 488.38 ± 0.2% | 533.15 ± 0.3% | 791.45 ± 0.4% | 123.46 ± 1.8% | 596.05 ± 0.4% | 1236.66 ± 0.8% | 8161.64 ± 0.3% | 488.12 ± 0.9% | 0.92 | 1.00 | 3.96 | 0.82 |
| class: a word that ends in ing | 9 | 593.79 ± 0.1% | 690.13 ± 0.6% | 1252.95 ± 1.5% | 152.02 ± 0.9% | 840.96 ± 0.7% | 1851.06 ± 0.6% | 19353.70 ± 1.5% | 594.40 ± 0.1% | 0.86 | 1.00 | 3.91 | 0.71 |
| class: a word in capitals | 16 | 535.79 ± 0.3% | 590.62 ± 0.2% | 990.24 ± 0.2% | 158.20 ± 0.7% | 884.89 ± 2.0% | 1785.03 ± 0.9% | 10665.86 ± 0.6% | 536.12 ± 0.3% | 0.91 | 1.00 | 3.39 | 0.61 |
| class: a number | 6 | 664.10 ± 0.6% | 750.92 ± 0.5% | 1477.98 ± 0.4% | 47.58 ± 0.7% | 1610.90 ± 1.8% | 2958.26 ± 3.7% | 26017.45 ± 0.5% | 664.97 ± 0.3% | 0.88 | 1.00 | 13.96 | 0.41 |
| class: two capitalized words, second text | 23 | 487.59 ± 0.7% | 532.95 ± 0.3% | 790.96 ± 0.1% | 121.66 ± 1.3% | 596.25 ± 2.2% | 1253.40 ± 1.4% | 8121.75 ± 0.8% | 488.70 ± 0.3% | 0.91 | 1.00 | 4.01 | 0.82 |
| other: a word between two words | 13 | 605.66 ± 0.4% | 629.53 ± 12.9% | 1021.37 ± 0.3% | 159.80 ± 2.1% | 576.18 ± 1.1% | 1325.28 ± 2.0% | 18018.88 ± 0.5% | 605.62 ± 0.3% | 0.96 | 1.00 | 3.79 | 1.05 |
| other: a number before a unit, second text | 15 | 414.72 ± 0.4% | 467.13 ± 0.2% | 658.62 ± 0.2% | 44.19 ± 1.4% | 715.91 ± 15.6% | 1443.99 ± 0.7% | 17835.91 ± 1.3% | 415.24 ± 0.1% | 0.89 | 1.00 | 9.39 | 0.58 |
| other: a heading's start tag | 13 | 394.69 ± 0.3% | 402.49 ± 0.3% | 541.03 ± 0.3% | 48.26 ± 0.5% | 700.77 ± 6.3% | 1394.68 ± 0.9% | 20488.58 ± 0.4% | 394.49 ± 0.5% | 0.98 | 1.00 | 8.18 | 0.56 |
| other: a whole word | 11 | 620.87 ± 0.5% | 656.39 ± 1.0% | 1121.36 ± 0.5% | 146.88 ± 0.3% | 673.24 ± 1.3% | 1397.78 ± 1.0% | 31821.32 ± 1.2% | 619.54 ± 0.7% | 0.95 | 1.00 | 4.23 | 0.92 |
| other: a line's first word, second text | 17 | 575.07 ± 8.1% | 608.56 ± 0.7% | 999.77 ± 5.1% | 149.99 ± 0.9% | 796.29 ± 8.9% | refused | refused | 574.87 ± 5.5% | 0.94 | 1.00 | 3.83 | 0.72 |
| other: fourteen octets before an x | 16 | 113.05 ± 3.1% | 170.67 ± 0.1% | 203.22 ± 0.6% | 18.08 ± 1.0% | 517.79 ± 1.2% | 591.83 ± 1.0% | 15672.00 ± 0.2% | 113.00 ± 0.5% | 0.66 | 1.00 | 6.25 | 0.22 |
| other: a Greek word | 8 | 436.05 ± 0.3% | 620.34 ± 1.0% | 1059.29 ± 0.8% | 63.47 ± 1.1% | 1579.83 ± 9.5% | 2811.31 ± 1.0% | refused | 435.90 ± 0.3% | 0.70 | 1.00 | 6.87 | 0.28 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 37579.30 ± 10.1% | not timed | not timed | 33078.78 ± 1.9% | 3009.80 ± 20.3% | not timed | not timed | 37429.41 ± 0.1% | | 1.00 | 1.14 | 12.49 |
| 01-literal/sherlock-casei-en | 522 | 29624.07 ± 0.9% | not timed | not timed | 9033.13 ± 13.0% | 34.07 ± 1.0% | not timed | not timed | 29501.65 ± 0.4% | | 1.00 | 3.28 | 869.39 |
| 01-literal/sherlock-ru | 724 | 38859.49 ± 1.6% | not timed | not timed | 34300.05 ± 0.7% | 1300.11 ± 4.6% | not timed | not timed | 38786.82 ± 0.4% | | 1.00 | 1.13 | 29.89 |
| 01-literal/sherlock-casei-ru | 746 | 12458.16 ± 0.3% | not timed | not timed | 7773.16 ± 1.0% | 37.51 ± 3.2% | not timed | not timed | 12523.61 ± 0.2% | | 0.99 | 1.60 | 332.09 |
| 01-literal/sherlock-zh | 30 | 61234.58 ± 0.6% | not timed | not timed | 42734.52 ± 0.2% | 1633.05 ± 0.9% | not timed | not timed | 61299.79 ± 0.7% | | 1.00 | 1.43 | 37.50 |
| 02-literal-alternate/sherlock-en | 714 | 15504.18 ± 0.9% | not timed | not timed | 10920.13 ± 0.2% | 19.12 ± 0.7% | not timed | not timed | 15533.56 ± 1.0% | | 1.00 | 1.42 | 811.00 |
| 02-literal-alternate/sherlock-casei-en | 725 | 5111.89 ± 5.1% | not timed | not timed | 2297.13 ± 1.2% | 12.38 ± 17.4% | not timed | not timed | 5141.97 ± 4.3% | | 0.99 | 2.23 | 412.81 |
| 02-literal-alternate/sherlock-ru | 899 | 10928.29 ± 0.6% | not timed | not timed | 9735.28 ± 0.9% | 25.17 ± 0.3% | not timed | not timed | 10885.64 ± 0.6% | | 1.00 | 1.12 | 434.11 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2541.61 ± 3.9% | not timed | not timed | 1186.08 ± 0.5% | 10.61 ± 1.0% | not timed | not timed | 2548.18 ± 3.1% | | 1.00 | 2.14 | 239.59 |
| 02-literal-alternate/sherlock-zh | 207 | 20577.87 ± 1.1% | not timed | not timed | 12646.70 ± 0.2% | 35.81 ± 0.4% | not timed | not timed | 20570.11 ± 0.4% | | 1.00 | 1.63 | 574.64 |
| 03-date/ascii | 111817 | 147.69 ± 1.5% | not timed | not timed | 100.58 ± 0.4% | 0.23 ± 4.3% | not timed | not timed | 148.45 ± 0.8% | | 0.99 | 1.47 | 641.94 |
| 04-ruff-noqa/real | 84 | 507.89 ± 0.3% | not timed | not timed | 510.22 ± 0.5% | 20.39 ± 2.3% | not timed | not timed | 514.22 ± 11.5% | | 0.99 | 1.00 | 24.91 |
| 04-ruff-noqa/tweaked | 44 | 645.66 ± 1.1% | not timed | not timed | 512.93 ± 0.7% | 363.18 ± 12.0% | not timed | not timed | 653.86 ± 1.1% | | 0.99 | 1.26 | 1.78 |
| 05-lexer-veryl/single | 124800 | 4.33 ± 4.5% | not timed | not timed | 5.27 ± 1.0% | 0.26 ± 2.8% | not timed | not timed | 4.76 ± 6.7% | | 0.91 | 0.82 | 16.64 |
| 06-cloud-flare-redos/original | 107 | 431.56 ± 0.1% | not timed | not timed | 223.46 ± 1.0% | 25.52 ± 7.8% | not timed | not timed | 432.05 ± 0.4% | | 1.00 | 1.93 | 16.91 |
| 06-cloud-flare-redos/simplified-short | 102 | 418.52 ± 1.1% | not timed | not timed | 236.41 ± 0.2% | 27.25 ± 1.5% | not timed | not timed | 420.95 ± 0.3% | | 0.99 | 1.77 | 15.36 |
| 06-cloud-flare-redos/simplified-long | 10000 | 529.95 ± 0.2% | not timed | not timed | 259.57 ± 0.4% | 29.54 ± 0.9% | not timed | not timed | 530.09 ± 0.3% | | 1.00 | 2.04 | 17.94 |
| 07-unicode-character-data/parse-line | 558784 | 248.74 ± 2.3% | not timed | not timed | 202.02 ± 0.4% | 48.28 ± 9.9% | not timed | not timed | 248.38 ± 2.4% | | 1.00 | 1.23 | 5.15 |
| 08-words/all-english | 56691 | 134.01 ± 5.1% | not timed | not timed | 84.52 ± 1.0% | 14.82 ± 8.3% | not timed | not timed | 134.46 ± 5.5% | | 1.00 | 1.59 | 9.04 |
| 08-words/long-english | 839 | 618.19 ± 2.3% | not timed | not timed | 583.00 ± 0.6% | 35.23 ± 0.4% | not timed | not timed | 618.70 ± 0.1% | | 1.00 | 1.06 | 17.55 |
| 09-aws-keys/full | 0 | 520.45 ± 0.3% | not timed | not timed | 541.90 ± 0.5% | 66.83 ± 5.1% | not timed | not timed | 521.53 ± 0.4% | | 1.00 | 0.96 | 7.79 |
| 09-aws-keys/quick | 0 | 1150.20 ± 0.6% | not timed | not timed | 958.94 ± 1.1% | 395.31 ± 1.0% | not timed | not timed | 1148.64 ± 12.6% | | 1.00 | 1.20 | 2.91 |
| 10-bounded-repeat/letters-en | 1833 | 680.32 ± 0.2% | not timed | not timed | 552.51 ± 0.6% | 22.86 ± 18.1% | not timed | not timed | 680.45 ± 0.6% | | 1.00 | 1.23 | 29.77 |
| 10-bounded-repeat/letters-ru | 3475 | 525.56 ± 1.3% | not timed | not timed | 481.08 ± 0.3% | 26.57 ± 19.6% | not timed | not timed | 526.73 ± 2.0% | | 1.00 | 1.09 | 19.78 |
| 10-bounded-repeat/context | 53 | 89.91 ± 5.2% | not timed | not timed | 70.75 ± 0.7% | 22.77 ± 0.6% | not timed | not timed | 90.44 ± 1.3% | | 0.99 | 1.27 | 3.95 |
| 10-bounded-repeat/capitals | 11 | 639.80 ± 8.0% | not timed | not timed | 604.43 ± 0.4% | 40.31 ± 0.2% | not timed | not timed | 638.18 ± 7.9% | | 1.00 | 1.06 | 15.87 |
| 11-unstructured-to-json/extract | 600 | 51.48 ± 0.7% | not timed | not timed | 81.30 ± 1.0% | 36.29 ± 25.7% | not timed | not timed | 51.11 ± 1.7% | | 1.01 | 0.63 | 1.42 |
| 12-dictionary/single | 1 | 514.88 ± 1.0% | not timed | not timed | 480.65 ± 0.1% | 0.39 ± 2.6% | not timed | not timed | 509.77 ± 2.1% | | 1.01 | 1.07 | 1309.24 |
| 14-quadratic/1x | 100 | 26.18 ± 0.4% | not timed | not timed | 12.18 ± 0.3% | 1.00 ± 3.1% | not timed | not timed | 26.19 ± 1.7% | | 1.00 | 2.15 | 26.17 |
| 14-quadratic/2x | 200 | 19.86 ± 0.8% | not timed | not timed | 6.12 ± 0.2% | 0.54 ± 0.7% | not timed | not timed | 19.89 ± 1.0% | | 1.00 | 3.24 | 36.66 |
| 14-quadratic/10x | 1000 | 6.85 ± 1.4% | not timed | not timed | 1.22 ± 0.3% | 0.12 ± 1.3% | not timed | not timed | 6.85 ± 1.6% | | 1.00 | 5.63 | 59.07 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.35 ± 0.2% | not timed | not timed | 0.48 ± 0.5% | 0.64 ± 1.5% | not timed | not timed | 1.36 ± 1.2% | | 1.00 | 2.84 | 2.11 |
| 04-ruff-noqa/compile-real | 1 | 118.26 ± 1.4% | not timed | not timed | 17.14 ± 1.8% | 169.27 ± 6.6% | not timed | not timed | 118.05 ± 0.4% | | 1.00 | 6.90 | 0.70 |
| 05-lexer-veryl/compile-single | 1 | 16.25 ± 1.4% | not timed | not timed | 3.00 ± 0.9% | 7.89 ± 1.8% | not timed | not timed | 16.43 ± 0.5% | | 0.99 | 5.41 | 2.06 |
| 07-unicode-character-data/compile | 1 | 124.11 ± 1.1% | not timed | not timed | 30.37 ± 0.8% | 44.57 ± 1.2% | not timed | not timed | 123.76 ± 1.3% | | 1.00 | 4.09 | 2.78 |
| 09-aws-keys/compile-full | 1 | 55.16 ± 0.1% | not timed | not timed | 9.94 ± 1.3% | 27.89 ± 1.9% | not timed | not timed | 55.13 ± 0.3% | | 1.00 | 5.55 | 1.98 |
| 09-aws-keys/compile-quick | 1 | 190.91 ± 0.5% | not timed | not timed | 57.76 ± 0.3% | 138.94 ± 12.3% | not timed | not timed | 190.70 ± 0.2% | | 1.00 | 3.30 | 1.37 |
| 10-bounded-repeat/compile-context | 1 | 59.73 ± 0.8% | not timed | not timed | 14.49 ± 1.4% | 19.86 ± 5.8% | not timed | not timed | 59.66 ± 0.4% | | 1.00 | 4.12 | 3.01 |
| 10-bounded-repeat/compile-capitals | 1 | 92.99 ± 1.5% | not timed | not timed | 10.49 ± 0.8% | 29.14 ± 1.8% | not timed | not timed | 93.67 ± 0.3% | | 0.99 | 8.86 | 3.19 |
| 11-unstructured-to-json/compile | 1 | 188.35 ± 0.8% | not timed | not timed | 47.93 ± 1.0% | 80.04 ± 2.5% | not timed | not timed | 188.15 ± 0.9% | | 1.00 | 3.93 | 2.35 |
| 12-dictionary/compile-single | 1 | 0.34 ± 2.0% | not timed | not timed | 0.08 ± 2.4% | 0.11 ± 19.2% | not timed | not timed | 0.34 ± 7.0% | | 1.00 | 4.09 | 3.08 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 6.82 ± 1.8% | not timed | not timed | 6.38 ± 1.1% | 0.63 ± 13.9% | not timed | not timed | 7.23 ± 1.9% | | 0.94 | 1.07 | 10.83 |
| dictionary/search/english-10 | 690 | 1.30 ± 0.9% | not timed | not timed | 152.76 ± 1.2% | 0.01 ± 0.6% | not timed | not timed | 1.30 ± 1.5% | | 1.00 | 0.0085 | 188.56 |
| dictionary/search/english-15 | 15 | 514.12 ± 2.9% | not timed | not timed | 479.01 ± 0.2% | 0.36 ± 5.6% | not timed | not timed | 512.86 ± 0.8% | | 1.00 | 1.07 | 1428.36 |
| folly/awyer-inn-busted | 1 | 4247.25 ± 0.2% | not timed | not timed | 132.21 ± 0.3% | 47.73 ± 29.7% | not timed | not timed | 4250.04 ± 0.8% | | 1.00 | 32.12 | 88.98 |
| folly/literal-never-match-rare | 0 | 67479.31 ± 0.7% | not timed | not timed | 46248.13 ± 0.6% | 68945.44 ± 0.4% | not timed | not timed | 67586.74 ± 0.5% | | 1.00 | 1.46 | 0.98 |
| folly/literal-never-match-frequent | 0 | 26261.45 ± 4.8% | not timed | not timed | 46063.30 ± 0.3% | 2584.94 ± 0.3% | not timed | not timed | 26290.45 ± 6.1% | | 1.00 | 0.57 | 10.16 |
| folly/literal-never-match-tricksy | 1 | 3979.10 ± 3.9% | not timed | not timed | 6149.13 ± 0.9% | 1723.59 ± 0.5% | not timed | not timed | 3976.43 ± 1.9% | | 1.00 | 0.65 | 2.31 |
| grep/every-line | 239963 | 1474.98 ± 2.8% | not timed | not timed | 963.38 ± 0.4% | 377.66 ± 18.9% | not timed | not timed | 1477.39 ± 0.7% | | 1.00 | 1.53 | 3.91 |
| grep/long-words-ascii | 5073 | 504.19 ± 0.4% | not timed | not timed | 497.65 ± 0.2% | 50.30 ± 8.6% | not timed | not timed | 504.53 ± 0.3% | | 1.00 | 1.01 | 10.02 |
| imported/leipzig/twain | 811 | 57249.34 ± 7.3% | not timed | not timed | 43616.13 ± 9.5% | 12941.75 ± 11.3% | not timed | not timed | 58451.52 ± 8.5% | | 0.98 | 1.31 | 4.42 |
| imported/leipzig/twain-insensitive | 965 | 15455.13 ± 1.2% | not timed | not timed | 13394.16 ± 1.2% | 39.86 ± 0.5% | not timed | not timed | 15457.97 ± 0.8% | | 1.00 | 1.15 | 387.71 |
| imported/leipzig/shing | 1540 | 30165.82 ± 6.6% | not timed | not timed | 22147.10 ± 1.4% | 34.38 ± 1.1% | not timed | not timed | 30174.02 ± 2.4% | | 1.00 | 1.36 | 877.53 |
| imported/leipzig/huck-saw | 262 | 24993.82 ± 0.3% | not timed | not timed | 18788.28 ± 0.6% | 30.01 ± 2.2% | not timed | not timed | 24987.03 ± 0.5% | | 1.00 | 1.33 | 832.79 |
| imported/leipzig/word-ending-nn | 262 | 609.75 ± 0.1% | not timed | not timed | 603.35 ± 0.4% | 25.04 ± 0.3% | not timed | not timed | 608.91 ± 0.2% | | 1.00 | 1.01 | 24.35 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11952.91 ± 0.3% | not timed | not timed | 3918.20 ± 0.4% | 12.02 ± 0.4% | not timed | not timed | 11971.86 ± 0.2% | | 1.00 | 3.05 | 994.31 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 22117.69 ± 1.6% | not timed | not timed | 17553.55 ± 11.3% | 18.33 ± 0.2% | not timed | not timed | 22151.02 ± 1.8% | | 1.00 | 1.26 | 1206.44 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5578.10 ± 0.3% | not timed | not timed | 793.02 ± 0.4% | 12.05 ± 0.9% | not timed | not timed | 5581.12 ± 0.3% | | 1.00 | 7.03 | 462.78 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 607.47 ± 0.1% | not timed | not timed | 601.88 ± 0.1% | 12.49 ± 0.2% | not timed | not timed | 607.31 ± 0.6% | | 1.00 | 1.01 | 48.62 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 607.51 ± 0.2% | not timed | not timed | 603.00 ± 0.3% | 10.69 ± 0.7% | not timed | not timed | 607.65 ± 0.2% | | 1.00 | 1.01 | 56.84 |
| imported/leipzig/tom-river | 2 | 12808.18 ± 0.9% | not timed | not timed | 13221.35 ± 3.3% | 34.70 ± 2.0% | not timed | not timed | 12829.73 ± 1.3% | | 1.00 | 0.97 | 369.13 |
| imported/leipzig/ing | 78424 | 595.08 ± 1.1% | not timed | not timed | 561.70 ± 0.6% | 30.66 ± 3.4% | not timed | not timed | 598.84 ± 0.1% | | 0.99 | 1.06 | 19.41 |
| imported/leipzig/ing-whitespace | 55248 | 731.14 ± 0.7% | not timed | not timed | 2151.40 ± 0.4% | 22.99 ± 3.0% | not timed | not timed | 742.74 ± 0.8% | | 0.98 | 0.34 | 31.80 |
| imported/leipzig/awyer-inn | 209 | 770.36 ± 1.7% | not timed | not timed | 13746.46 ± 1.0% | 25.15 ± 0.2% | not timed | not timed | 770.96 ± 1.1% | | 1.00 | 0.0560 | 30.63 |
| imported/leipzig/quotes-bounded | 8886 | 1847.36 ± 0.2% | not timed | not timed | 3280.00 ± 0.7% | 41.08 ± 0.2% | not timed | not timed | 1845.69 ± 0.2% | | 1.00 | 0.56 | 44.97 |
| imported/leipzig/non-ascii-alternate | 2 | 40503.32 ± 1.6% | not timed | not timed | 19573.51 ± 2.0% | 56.14 ± 3.6% | not timed | not timed | 40543.19 ± 25.0% | | 1.00 | 2.07 | 721.53 |
| imported/leipzig/math-symbols | 69 | 2425.14 ± 0.2% | not timed | not timed | 603.07 ± 0.7% | 39.39 ± 0.7% | not timed | not timed | 2428.17 ± 0.2% | | 1.00 | 4.02 | 61.57 |
| imported/leipzig/bounded-strings-ending-z | 0 | 609.06 ± 0.6% | not timed | not timed | 603.16 ± 0.4% | 25.67 ± 0.7% | not timed | not timed | 609.55 ± 0.2% | | 1.00 | 1.01 | 23.73 |
| imported/lh3lh3-reb/uri | 17549 | 816.34 ± 0.4% | not timed | not timed | 1126.57 ± 4.9% | 24.41 ± 3.7% | not timed | not timed | 815.45 ± 4.7% | | 1.00 | 0.72 | 33.44 |
| imported/lh3lh3-reb/email | 15057 | 810.01 ± 0.2% | not timed | not timed | 1135.14 ± 1.4% | 25.40 ± 3.2% | not timed | not timed | 810.54 ± 0.1% | | 1.00 | 0.71 | 31.88 |
| imported/lh3lh3-reb/date | 668 | 933.29 ± 0.5% | not timed | not timed | 1011.17 ± 0.7% | 52.68 ± 5.1% | not timed | not timed | 936.56 ± 0.4% | | 1.00 | 0.92 | 17.71 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 751.84 ± 0.2% | not timed | not timed | 442.29 ± 5.7% | 12.51 ± 3.6% | not timed | not timed | 746.88 ± 0.1% | | 1.01 | 1.70 | 60.08 |
| imported/mariomka/email | 92 | 42933.02 ± 1.4% | not timed | not timed | 60277.02 ± 1.2% | 35.88 ± 0.2% | not timed | not timed | 42951.28 ± 1.7% | | 1.00 | 0.71 | 1196.74 |
| imported/mariomka/uri | 5301 | 6631.75 ± 0.3% | not timed | not timed | 7955.19 ± 0.5% | 35.86 ± 0.7% | not timed | not timed | 6662.66 ± 0.4% | | 1.00 | 0.83 | 184.92 |
| imported/mariomka/ip | 5 | 1820.95 ± 3.7% | not timed | not timed | 2323.51 ± 0.4% | 23.26 ± 4.4% | not timed | not timed | 1830.27 ± 3.2% | | 0.99 | 0.78 | 78.29 |
| imported/rsc/no-exponential | 0 | 894.26 ± 1.2% | not timed | not timed | 422.45 ± 0.4% | 25.77 ± 1.8% | not timed | not timed | 897.02 ± 1.1% | | 1.00 | 2.12 | 34.70 |
| imported/rsc/literal | 1 | 866.74 ± 4.4% | not timed | not timed | 2220.02 ± 0.4% | 220.64 ± 16.2% | not timed | not timed | 871.44 ± 6.1% | | 0.99 | 0.39 | 3.93 |
| imported/rsc/not-literal | 2 | 968.75 ± 0.8% | not timed | not timed | 695.75 ± 1.3% | 53.38 ± 94.6% | not timed | not timed | 969.23 ± 0.3% | | 1.00 | 1.39 | 18.15 |
| imported/rsc/match-class | 1 | 1675.60 ± 3.1% | not timed | not timed | 1548.23 ± 1.4% | 67.84 ± 7.4% | not timed | not timed | 1669.71 ± 2.8% | | 1.00 | 1.08 | 24.70 |
| imported/rsc/match-class-in-range | 1 | 1660.28 ± 6.4% | not timed | not timed | 3434.28 ± 0.7% | 69.61 ± 8.0% | not timed | not timed | 1672.10 ± 9.4% | | 0.99 | 0.48 | 23.85 |
| imported/rsc/match-class-unicode | 1 | 571.04 ± 0.8% | not timed | not timed | 523.54 ± 1.2% | 82.90 ± 14.3% | not timed | not timed | 571.45 ± 2.0% | | 1.00 | 1.09 | 6.89 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1699.02 ± 0.3% | not timed | not timed | 1146.48 ± 1.6% | 344.97 ± 1.0% | not timed | not timed | 1697.71 ± 0.5% | | 1.00 | 1.48 | 4.93 |
| imported/rsc/anchored-literal-long-non-match | 0 | 25446.07 ± 0.5% | not timed | not timed | 17203.04 ± 0.3% | 5144.61 ± 34.4% | not timed | not timed | 25449.59 ± 0.4% | | 1.00 | 1.48 | 4.95 |
| imported/rsc/anchored-literal-short-match | 4 | 876.66 ± 2.2% | not timed | not timed | 572.71 ± 0.6% | 105.83 ± 23.3% | not timed | not timed | 888.67 ± 7.7% | | 0.99 | 1.53 | 8.28 |
| imported/rsc/anchored-literal-long-match | 4 | 13031.67 ± 2.3% | not timed | not timed | 8562.19 ± 0.7% | 1648.21 ± 2.9% | not timed | not timed | 13342.38 ± 2.5% | | 0.98 | 1.52 | 7.91 |
| imported/rsc/one-pass-short | 17 | 502.84 ± 6.8% | not timed | not timed | 261.98 ± 0.4% | 37.94 ± 16.4% | not timed | not timed | 501.53 ± 0.4% | | 1.00 | 1.92 | 13.25 |
| imported/rsc/one-pass-short-not | 17 | 326.33 ± 1.7% | not timed | not timed | 271.45 ± 1.1% | 33.92 ± 11.2% | not timed | not timed | 327.48 ± 9.4% | | 1.00 | 1.20 | 9.62 |
| imported/rsc/one-pass-long-prefix | 26 | 446.64 ± 1.6% | not timed | not timed | 322.97 ± 1.8% | 128.24 ± 28.6% | not timed | not timed | 449.88 ± 2.2% | | 0.99 | 1.38 | 3.48 |
| imported/rsc/one-pass-long-prefix-not | 26 | 446.92 ± 2.9% | not timed | not timed | 321.94 ± 0.3% | 85.38 ± 10.7% | not timed | not timed | 448.12 ± 1.2% | | 1.00 | 1.39 | 5.23 |
| imported/rsc/long-needle1 | 31 | 68331.82 ± 0.2% | not timed | not timed | 45846.04 ± 21.6% | 4.20 ± 1.0% | not timed | not timed | 68208.46 ± 0.5% | | 1.00 | 1.49 | 16252.64 |
| imported/rsc/long-needle2 | 31 | 67718.40 ± 21.6% | not timed | not timed | 227.37 ± 0.6% | 4.20 ± 0.4% | not timed | not timed | 67737.76 ± 0.3% | | 1.00 | 297.83 | 16127.95 |
| imported/rsc/easy0-32 | 26 | 1266.76 ± 10.5% | not timed | not timed | 1939.40 ± 0.3% | 146.48 ± 45.5% | not timed | not timed | 1266.96 ± 4.4% | | 1.00 | 0.65 | 8.65 |
| imported/rsc/easy0-1k | 26 | 21411.76 ± 1.4% | not timed | not timed | 20465.91 ± 0.4% | 2283.83 ± 29.2% | not timed | not timed | 21517.54 ± 0.4% | | 1.00 | 1.05 | 9.38 |
| imported/rsc/easy0-32k | 26 | 64612.04 ± 0.9% | not timed | not timed | 43878.19 ± 0.3% | 26142.03 ± 38.0% | not timed | not timed | 64754.84 ± 2.0% | | 1.00 | 1.47 | 2.47 |
| imported/rsc/easy0-1mb | 26 | 64632.15 ± 0.4% | not timed | not timed | 45997.90 ± 0.2% | 67842.46 ± 0.5% | not timed | not timed | 64731.17 ± 0.3% | | 1.00 | 1.41 | 0.95 |
| imported/rsc/easy1-32 | 19 | 898.01 ± 6.0% | not timed | not timed | 760.28 ± 0.3% | 152.78 ± 20.1% | not timed | not timed | 924.62 ± 1.5% | | 0.97 | 1.18 | 5.88 |
| imported/rsc/easy1-1k | 19 | 18332.81 ± 2.9% | not timed | not timed | 15613.02 ± 0.6% | 2486.81 ± 18.5% | not timed | not timed | 19044.98 ± 0.5% | | 0.96 | 1.17 | 7.37 |
| imported/rsc/easy1-32k | 19 | 575448.81 ± 3.3% | not timed | not timed | 490823.71 ± 0.9% | 29261.74 ± 15.0% | not timed | not timed | 597487.15 ± 0.5% | | 0.96 | 1.17 | 19.67 |
| imported/rsc/easy1-1mb | 19 | 18457675.79 ± 1.1% | not timed | not timed | 15684698.21 ± 5.0% | 69493.17 ± 0.6% | not timed | not timed | 19143180.61 ± 9.7% | | 0.96 | 1.18 | 265.60 |
| imported/rsc/medium-32 | 27 | 867.89 ± 1.7% | not timed | not timed | 740.48 ± 0.3% | 73.78 ± 34.0% | not timed | not timed | 845.32 ± 1.5% | | 1.03 | 1.17 | 11.76 |
| imported/rsc/medium-1k | 27 | 15546.99 ± 0.6% | not timed | not timed | 13238.78 ± 0.4% | 82.48 ± 5.2% | not timed | not timed | 15100.45 ± 0.4% | | 1.03 | 1.17 | 188.49 |
| imported/rsc/medium-32k | 27 | 485501.04 ± 0.4% | not timed | not timed | 413693.30 ± 0.4% | 54.54 ± 1.9% | not timed | not timed | 470788.96 ± 1.1% | | 1.03 | 1.17 | 8901.14 |
| imported/rsc/medium-1mb | 27 | 15505119.18 ± 0.8% | not timed | not timed | 13043876.34 ± 0.7% | 54.76 ± 1.3% | not timed | not timed | 15042038.39 ± 1.8% | | 1.03 | 1.19 | 283160.48 |
| imported/rsc/hard-32 | 58 | 448.83 ± 0.5% | not timed | not timed | 391.13 ± 1.0% | 52.15 ± 11.8% | not timed | not timed | 449.83 ± 2.1% | | 1.00 | 1.15 | 8.61 |
| imported/rsc/hard-1k | 27 | 14819.49 ± 0.4% | not timed | not timed | 12936.52 ± 0.1% | 44.42 ± 12.5% | not timed | not timed | 14880.96 ± 7.6% | | 1.00 | 1.15 | 333.64 |
| imported/rsc/hard-32k | 27 | 462391.96 ± 2.9% | not timed | not timed | 410462.45 ± 1.2% | 33.02 ± 0.3% | not timed | not timed | 464905.00 ± 0.7% | | 0.99 | 1.13 | 14002.40 |
| imported/rsc/hard-1mb | 51 | 8946777.86 ± 0.5% | not timed | not timed | 7803782.67 ± 1.7% | 33.09 ± 9.7% | not timed | not timed | 8957158.76 ± 0.7% | | 1.00 | 1.15 | 270417.82 |
| imported/rsc/reallyhard0-32 | 58 | 282.44 ± 1.5% | not timed | not timed | 220.02 ± 1.9% | 51.47 ± 9.0% | not timed | not timed | 282.08 ± 2.6% | | 1.00 | 1.28 | 5.49 |
| imported/rsc/reallyhard0-1k | 27 | 592.07 ± 0.3% | not timed | not timed | 581.06 ± 0.7% | 44.49 ± 0.8% | not timed | not timed | 592.05 ± 0.2% | | 1.00 | 1.02 | 13.31 |
| imported/rsc/reallyhard0-32k | 27 | 607.49 ± 0.1% | not timed | not timed | 602.18 ± 0.5% | 32.87 ± 0.8% | not timed | not timed | 607.96 ± 0.2% | | 1.00 | 1.01 | 18.48 |
| imported/rsc/reallyhard0-1mb | 51 | 609.56 ± 0.5% | not timed | not timed | 603.25 ± 0.7% | 33.13 ± 0.5% | not timed | not timed | 609.56 ± 0.6% | | 1.00 | 1.01 | 18.40 |
| imported/rsc/reallyreallyhard0-32 | 47 | 336.15 ± 1.4% | not timed | not timed | 209.32 ± 4.6% | 64.76 ± 17.8% | not timed | not timed | 334.92 ± 3.5% | | 1.00 | 1.61 | 5.19 |
| imported/rsc/reallyreallyhard0-1k | 16 | 8206.83 ± 0.5% | not timed | not timed | 7520.37 ± 0.8% | 36.63 ± 2.3% | not timed | not timed | 8223.04 ± 0.7% | | 1.00 | 1.09 | 224.07 |
| imported/rsc/reallyreallyhard0-32k | 16 | 52508.62 ± 0.7% | not timed | not timed | 36640.10 ± 0.1% | 24.82 ± 0.7% | not timed | not timed | 52702.93 ± 0.2% | | 1.00 | 1.43 | 2115.86 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 72316.06 ± 0.3% | not timed | not timed | 45522.22 ± 0.3% | 24.96 ± 8.8% | not timed | not timed | 72579.38 ± 0.5% | | 1.00 | 1.59 | 2897.76 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 323.50 ± 3.8% | not timed | not timed | 215.96 ± 0.3% | 63.98 ± 6.9% | not timed | not timed | 324.56 ± 1.2% | | 1.00 | 1.50 | 5.06 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 6792.71 ± 0.9% | not timed | not timed | 7509.96 ± 0.4% | 36.79 ± 0.4% | not timed | not timed | 6811.12 ± 0.2% | | 1.00 | 0.90 | 184.62 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 49222.63 ± 1.0% | not timed | not timed | 36499.99 ± 1.4% | 25.01 ± 0.3% | not timed | not timed | 47991.67 ± 0.6% | | 1.03 | 1.35 | 1967.91 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 63371.85 ± 0.4% | not timed | not timed | 45179.01 ± 1.1% | 24.37 ± 0.5% | not timed | not timed | 63162.61 ± 1.0% | | 1.00 | 1.40 | 2599.95 |
| imported/sherlock/name-sherlock | 776 | 50597.58 ± 1.4% | not timed | not timed | 40021.66 ± 1.5% | 11987.09 ± 5.5% | not timed | not timed | 50752.75 ± 1.2% | | 1.00 | 1.26 | 4.22 |
| imported/sherlock/name-holmes | 2766 | 27849.64 ± 2.0% | not timed | not timed | 30338.83 ± 5.7% | 4011.86 ± 3.9% | not timed | not timed | 27810.49 ± 16.6% | | 1.00 | 0.92 | 6.94 |
| imported/sherlock/name-sherlock-holmes | 1365 | 51609.98 ± 1.1% | not timed | not timed | 40055.22 ± 1.4% | 9819.35 ± 28.2% | not timed | not timed | 51565.99 ± 1.3% | | 1.00 | 1.29 | 5.26 |
| imported/sherlock/name-sherlock-casei | 816 | 46580.25 ± 0.3% | not timed | not timed | 11618.26 ± 0.4% | 33.34 ± 14.4% | not timed | not timed | 46534.53 ± 0.6% | | 1.00 | 4.01 | 1397.30 |
| imported/sherlock/name-holmes-casei | 2802 | 22640.16 ± 0.9% | not timed | not timed | 7661.58 ± 0.4% | 43.37 ± 0.7% | not timed | not timed | 22661.16 ± 0.4% | | 1.00 | 2.96 | 522.01 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 36638.04 ± 0.6% | not timed | not timed | 11191.08 ± 0.8% | 33.47 ± 1.3% | not timed | not timed | 36649.46 ± 0.3% | | 1.00 | 3.27 | 1094.68 |
| imported/sherlock/name-whitespace | 1461 | 29695.87 ± 1.4% | not timed | not timed | 28055.36 ± 1.5% | 8131.71 ± 22.5% | not timed | not timed | 30176.40 ± 1.1% | | 0.98 | 1.06 | 3.65 |
| imported/sherlock/name-alt1 | 1142 | 31312.87 ± 0.7% | not timed | not timed | 29661.58 ± 0.3% | 5395.54 ± 26.5% | not timed | not timed | 31401.21 ± 1.5% | | 1.00 | 1.06 | 5.80 |
| imported/sherlock/name-alt2 | 3542 | 21123.85 ± 26.9% | not timed | not timed | 10109.12 ± 0.2% | 34.81 ± 2.2% | not timed | not timed | 21159.34 ± 0.4% | | 1.00 | 2.09 | 606.80 |
| imported/sherlock/name-alt3 | 4507 | 13540.89 ± 2.1% | not timed | not timed | 9228.71 ± 0.1% | 10.09 ± 0.3% | not timed | not timed | 13547.36 ± 0.5% | | 1.00 | 1.47 | 1342.12 |
| imported/sherlock/name-alt3-casei | 4593 | 3512.49 ± 3.1% | not timed | not timed | 1311.78 ± 0.9% | 7.03 ± 0.6% | not timed | not timed | 3571.66 ± 5.1% | | 0.98 | 2.68 | 499.29 |
| imported/sherlock/name-alt4 | 3686 | 9959.15 ± 0.6% | not timed | not timed | 8143.54 ± 0.2% | 35.62 ± 0.6% | not timed | not timed | 9963.63 ± 0.8% | | 1.00 | 1.22 | 279.58 |
| imported/sherlock/name-alt4-casei | 4254 | 5406.87 ± 1.0% | not timed | not timed | 4473.38 ± 2.1% | 20.63 ± 0.7% | not timed | not timed | 5462.09 ± 0.9% | | 0.99 | 1.21 | 262.10 |
| imported/sherlock/name-alt5 | 4028 | 17234.94 ± 0.7% | not timed | not timed | 9684.23 ± 0.3% | 23.74 ± 0.3% | not timed | not timed | 17270.20 ± 1.0% | | 1.00 | 1.78 | 725.99 |
| imported/sherlock/name-alt5-casei | 4104 | 6922.91 ± 0.9% | not timed | not timed | 3001.53 ± 1.4% | 15.16 ± 13.2% | not timed | not timed | 6976.53 ± 0.9% | | 0.99 | 2.31 | 456.74 |
| imported/sherlock/no-match-uncommon | 0 | 68619.45 ± 0.6% | not timed | not timed | 57956.23 ± 3.3% | 57609.97 ± 1.0% | not timed | not timed | 68579.55 ± 0.4% | | 1.00 | 1.18 | 1.19 |
| imported/sherlock/no-match-common | 0 | 67005.21 ± 0.3% | not timed | not timed | 57922.87 ± 0.4% | 2157.84 ± 0.7% | not timed | not timed | 67039.35 ± 5.6% | | 1.00 | 1.16 | 31.05 |
| imported/sherlock/no-match-really-common | 0 | 42964.70 ± 0.4% | not timed | not timed | 49670.43 ± 0.4% | 2160.46 ± 1.1% | not timed | not timed | 42915.98 ± 9.3% | | 1.00 | 0.86 | 19.89 |
| imported/sherlock/the-lower | 21654 | 3998.92 ± 0.7% | not timed | not timed | 4602.93 ± 2.0% | 278.95 ± 21.9% | not timed | not timed | 3996.58 ± 6.6% | | 1.00 | 0.87 | 14.34 |
| imported/sherlock/the-upper | 2223 | 20887.79 ± 1.3% | not timed | not timed | 29274.14 ± 0.4% | 2978.53 ± 22.1% | not timed | not timed | 20977.27 ± 1.8% | | 1.00 | 0.71 | 7.01 |
| imported/sherlock/the-casei | 23961 | 3497.61 ± 1.6% | not timed | not timed | 1365.23 ± 0.3% | 40.17 ± 13.1% | not timed | not timed | 3492.62 ± 16.0% | | 1.00 | 2.56 | 87.08 |
| imported/sherlock/everything-greedy | 581881 | 294.03 ± 0.2% | not timed | not timed | 172.99 ± 0.1% | 28.04 ± 38.3% | not timed | not timed | 295.99 ± 1.8% | | 0.99 | 1.70 | 10.49 |
| imported/sherlock/everything-greedy-nl | 594933 | 464.33 ± 0.2% | not timed | not timed | 226.02 ± 0.5% | 31.21 ± 1.2% | not timed | not timed | 464.43 ± 0.1% | | 1.00 | 2.05 | 14.88 |
| imported/sherlock/letters | 447175 | 67.28 ± 19.0% | not timed | not timed | 33.44 ± 21.2% | 6.74 ± 56.0% | not timed | not timed | 67.47 ± 2.6% | | 1.00 | 2.01 | 9.98 |
| imported/sherlock/letters-upper | 14180 | 452.26 ± 0.4% | not timed | not timed | 365.73 ± 0.1% | 28.81 ± 26.6% | not timed | not timed | 449.25 ± 3.8% | | 1.01 | 1.24 | 15.70 |
| imported/sherlock/letters-lower | 432995 | 68.39 ± 1.7% | not timed | not timed | 34.10 ± 1.1% | 6.42 ± 5.9% | not timed | not timed | 68.42 ± 0.9% | | 1.00 | 2.01 | 10.65 |
| imported/sherlock/words | 447639 | 124.72 ± 7.1% | not timed | not timed | 82.48 ± 0.4% | 14.70 ± 16.9% | not timed | not timed | 125.37 ± 14.2% | | 0.99 | 1.51 | 8.49 |
| imported/sherlock/before-holmes | 4073 | 15231.97 ± 0.4% | not timed | not timed | 13349.26 ± 0.2% | 23.85 ± 0.6% | not timed | not timed | 15249.30 ± 1.4% | | 1.00 | 1.14 | 638.79 |
| imported/sherlock/before-after-holmes | 2593 | 14923.67 ± 0.7% | not timed | not timed | 14942.61 ± 0.8% | 24.01 ± 0.5% | not timed | not timed | 15068.60 ± 11.1% | | 0.99 | 1.00 | 621.63 |
| imported/sherlock/holmes-cochar-watson | 150 | 10033.72 ± 0.3% | not timed | not timed | 7669.25 ± 0.1% | 35.28 ± 1.4% | not timed | not timed | 10085.79 ± 0.4% | | 0.99 | 1.31 | 284.44 |
| imported/sherlock/holmes-coword-watson | 14309 | 1269.35 ± 0.4% | not timed | not timed | 1232.32 ± 0.1% | 7.62 ± 0.9% | not timed | not timed | 1273.26 ± 0.3% | | 1.00 | 1.03 | 166.51 |
| imported/sherlock/quotes | 14437 | 1362.83 ± 8.5% | not timed | not timed | 2244.67 ± 1.5% | 37.31 ± 13.9% | not timed | not timed | 1364.79 ± 0.5% | | 1.00 | 0.61 | 36.53 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 606.00 ± 0.2% | not timed | not timed | 31218.42 ± 1.0% | 40.15 ± 39.2% | not timed | not timed | 604.94 ± 0.3% | | 1.00 | 0.0194 | 15.09 |
| imported/sherlock/word-ending-n | 35297 | 477.87 ± 0.2% | not timed | not timed | 401.76 ± 0.6% | 23.90 ± 0.5% | not timed | not timed | 477.98 ± 0.2% | | 1.00 | 1.19 | 19.99 |
| imported/sherlock/repeated-class-negation | 2130 | 19163.12 ± 0.3% | not timed | not timed | 16558.29 ± 0.2% | 11.72 ± 1.1% | not timed | not timed | 19149.21 ± 0.2% | | 1.00 | 1.16 | 1635.28 |
| imported/sherlock/ing-suffix | 20547 | 572.55 ± 0.6% | not timed | not timed | 510.71 ± 0.4% | 28.52 ± 27.5% | not timed | not timed | 574.13 ± 1.5% | | 1.00 | 1.12 | 20.07 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 604.07 ± 0.3% | not timed | not timed | 2864.67 ± 1.4% | 20.91 ± 0.2% | not timed | not timed | 605.21 ± 0.7% | | 1.00 | 0.21 | 28.89 |
| opt/accelerate/whole-line | 239963 | 505.04 ± 0.2% | not timed | not timed | 414.61 ± 0.1% | 91.68 ± 14.9% | not timed | not timed | 504.08 ± 0.2% | | 1.00 | 1.22 | 5.51 |
| opt/accelerate/non-dna | 16745 | 451.08 ± 1.2% | not timed | not timed | 439.37 ± 0.2% | 29.97 ± 21.5% | not timed | not timed | 453.19 ± 0.3% | | 1.00 | 1.03 | 15.05 |
| opt/backtrack/words-english | 40536 | 134.04 ± 3.4% | not timed | not timed | 110.74 ± 2.1% | 21.79 ± 6.4% | not timed | not timed | 135.66 ± 7.6% | | 0.99 | 1.21 | 6.15 |
| opt/fixed-length/too-small-ascii | 0 | 391.53 ± 15.0% | not timed | not timed | 708.88 ± 0.3% | 122.34 ± 2.2% | not timed | not timed | 391.10 ± 0.3% | | 1.00 | 0.55 | 3.20 |
| opt/fixed-length/too-big-ascii | 0 | 4343.71 ± 6.1% | not timed | not timed | 6301.97 ± 3.8% | 151.71 ± 5.6% | not timed | not timed | 4308.40 ± 3.0% | | 1.01 | 0.69 | 28.63 |
| opt/fixed-length/go33484-1 | 0 | 834382.27 ± 5.0% | not timed | not timed | 1214055.71 ± 0.6% | 89508.23 ± 2.1% | not timed | not timed | 835569.54 ± 1.2% | | 1.00 | 0.69 | 9.32 |
| opt/fixed-length/go33484-2 | 0 | 834608.25 ± 0.7% | not timed | not timed | 1215712.54 ± 1.0% | 25985.16 ± 16.6% | not timed | not timed | 834156.76 ± 0.7% | | 1.00 | 0.69 | 32.12 |
| opt/fixed-length/go33484-3 | 0 | 2453.60 ± 0.4% | not timed | not timed | 121367.92 ± 0.4% | 936.98 ± 1.3% | not timed | not timed | 2431.27 ± 0.5% | | 1.01 | 0.0202 | 2.62 |
| opt/literal-alt/one-pattern | 1 | 558.88 ± 1.7% | not timed | not timed | 564.98 ± 0.4% | 0.38 ± 0.2% | not timed | not timed | 576.93 ± 1.4% | | 0.97 | 0.99 | 1466.40 |
| opt/onepass/fn-predicate | 916 | 435.65 ± 2.6% | not timed | not timed | 395.04 ± 0.4% | 210.78 ± 16.4% | not timed | not timed | 438.28 ± 2.4% | | 0.99 | 1.10 | 2.07 |
| opt/onepass/first-three-words-english | 35128 | 149.33 ± 9.0% | not timed | not timed | 201.89 ± 0.7% | 75.41 ± 9.1% | not timed | not timed | 176.57 ± 2.8% | | 0.85 | 0.74 | 1.98 |
| opt/prefilter/literal-english | 1 | 67156.49 ± 1.1% | not timed | not timed | 46432.80 ± 0.4% | 26803.14 ± 0.2% | not timed | not timed | 67121.17 ± 0.3% | | 1.00 | 1.45 | 2.51 |
| opt/prefilter/literal-casei-english | 1 | 46706.42 ± 29.3% | not timed | not timed | 14301.42 ± 0.2% | 33.30 ± 2.7% | not timed | not timed | 46983.27 ± 2.1% | | 0.99 | 3.27 | 1402.50 |
| opt/prefilter/literal-russian | 1 | 68396.55 ± 0.5% | not timed | not timed | 46245.27 ± 31.1% | 1808.95 ± 0.3% | not timed | not timed | 68528.41 ± 0.3% | | 1.00 | 1.48 | 37.81 |
| opt/prefilter/literal-casei-russian | 1 | 26191.65 ± 0.2% | not timed | not timed | 11029.53 ± 0.3% | 37.38 ± 0.8% | not timed | not timed | 26170.11 ± 0.2% | | 1.00 | 2.37 | 700.62 |
| opt/prefilter/rust-functions | 948 | 14286.72 ± 1.3% | not timed | not timed | 12795.30 ± 1.5% | 1909.33 ± 0.3% | not timed | not timed | 14644.52 ± 1.3% | | 0.98 | 1.12 | 7.48 |
| opt/reverse-anchored/word-end | 1 | 35271160.72 ± 25.4% | not timed | not timed | 25914728.99 ± 1.1% | 56.55 ± 0.5% | not timed | not timed | 35474481.16 ± 0.4% | | 0.99 | 1.36 | 623669.88 |
| opt/reverse-inner/holmes | 2593 | 14956.42 ± 0.2% | not timed | not timed | 14985.79 ± 25.2% | 25.61 ± 6.2% | not timed | not timed | 15079.49 ± 3.9% | | 0.99 | 1.00 | 584.09 |
| opt/reverse-inner/email | 47 | 84072.37 ± 4.8% | not timed | not timed | 92374.61 ± 0.2% | 35.20 ± 0.9% | not timed | not timed | 84183.58 ± 5.8% | | 1.00 | 0.91 | 2388.20 |
| opt/reverse-inner/factored-prefix | 3542 | 599.79 ± 0.2% | not timed | not timed | 585.43 ± 0.6% | 14.02 ± 0.2% | not timed | not timed | 599.60 ± 0.2% | | 1.00 | 1.02 | 42.77 |
| opt/reverse-inner/no-quadratic-backward | 0 | 4200.95 ± 0.2% | not timed | not timed | 604.67 ± 0.5% | 86.18 ± 0.5% | not timed | not timed | 4198.03 ± 0.5% | | 1.00 | 6.95 | 48.74 |
| opt/reverse-inner/no-quadratic-forward | 0 | 709.20 ± 1.9% | not timed | not timed | 279.59 ± 0.1% | 26.01 ± 7.6% | not timed | not timed | 709.31 ± 2.1% | | 1.00 | 2.54 | 27.26 |
| opt/reverse-suffix/holmes | 4073 | 15244.60 ± 0.2% | not timed | not timed | 12935.84 ± 1.1% | 25.57 ± 0.4% | not timed | not timed | 15262.87 ± 0.4% | | 1.00 | 1.18 | 596.14 |
| opt/reverse-suffix/no-quadratic | 0 | 4195.27 ± 0.2% | not timed | not timed | 603.61 ± 0.5% | 86.15 ± 0.2% | not timed | not timed | 4197.10 ± 0.6% | | 1.00 | 6.95 | 48.70 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 142.21 ± 2.1% | not timed | not timed | 172.66 ± 0.3% | 13.57 ± 18.0% | not timed | not timed | 142.72 ± 2.2% | | 1.00 | 0.82 | 10.48 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 142.72 ± 1.0% | not timed | not timed | 182.59 ± 2.8% | 15.09 ± 31.2% | not timed | not timed | 142.26 ± 9.7% | | 1.00 | 0.78 | 9.46 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.31 ± 12.4% | not timed | not timed | 0.48 ± 1.3% | 120.58 ± 0.5% | not timed | not timed | 0.32 ± 0.6% | | 0.98 | 0.65 | 0.0026 |
| reported/i1095-word-repetition/ascii-search | 256 | 300.75 ± 2.3% | not timed | not timed | 285.45 ± 1.6% | 109.46 ± 0.9% | not timed | not timed | 300.03 ± 0.5% | | 1.00 | 1.05 | 2.75 |
| reported/i13-subset-regex/original-ascii | 4094 | 11926.05 ± 0.4% | not timed | not timed | 3955.52 ± 1.1% | 12.22 ± 2.4% | not timed | not timed | 11924.40 ± 0.6% | | 1.00 | 3.02 | 976.01 |
| reported/i13-subset-regex/original-unicode | 4094 | 11897.39 ± 0.2% | not timed | not timed | 210.49 ± 1.2% | 12.22 ± 1.0% | not timed | not timed | 11947.55 ± 0.3% | | 1.00 | 56.52 | 973.42 |
| reported/i13-subset-regex/big-ascii | 1955 | 11136.62 ± 1.0% | not timed | not timed | 54.38 ± 2.2% | 10.55 ± 0.9% | not timed | not timed | 11155.19 ± 0.9% | | 1.00 | 204.81 | 1055.82 |
| reported/i13-subset-regex/big-unicode | 1955 | 11065.30 ± 1.8% | not timed | not timed | 9.63 ± 55.9% | 10.56 ± 0.7% | not timed | not timed | 11116.06 ± 0.9% | | 1.00 | 1149.17 | 1047.80 |
| reported/i13-subset-regex/huge-ascii | 55 | 10230.07 ± 0.2% | not timed | not timed | 8.97 ± 1.0% | 9.60 ± 1.2% | not timed | not timed | 10216.21 ± 2.2% | | 1.00 | 1140.60 | 1065.67 |
| reported/i13-subset-regex/huge-unicode | 55 | 10138.23 ± 0.3% | not timed | not timed | 8.99 ± 0.7% | 9.58 ± 0.8% | not timed | not timed | 10113.29 ± 0.7% | | 1.00 | 1127.66 | 1058.24 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.18 ± 0.4% | not timed | not timed | 8.91 ± 0.9% | 9.63 ± 2.0% | not timed | not timed | 4.18 ± 0.9% | | 1.00 | 0.47 | 0.43 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.84 ± 0.9% | not timed | not timed | 8.95 ± 2.3% | 9.45 ± 1.0% | not timed | not timed | 5.86 ± 1.4% | | 1.00 | 0.65 | 0.62 |
| reported/i787-keywords/ascii | 5674 | 556.52 ± 1.0% | not timed | not timed | 170.21 ± 1.3% | 7.29 ± 2.4% | not timed | not timed | 561.15 ± 0.5% | | 0.99 | 3.27 | 76.29 |
| reported/i787-keywords/opt-ascii | 5674 | 555.47 ± 1.2% | not timed | not timed | 267.39 ± 1.4% | 12.18 ± 1.6% | not timed | not timed | 558.36 ± 0.4% | | 0.99 | 2.08 | 45.60 |
| slow/quadratic-regex-1x | 100 | 8.19 ± 0.2% | not timed | not timed | 6.02 ± 1.0% | 0.05 ± 0.5% | not timed | not timed | 8.17 ± 0.4% | | 1.00 | 1.36 | 161.68 |
| slow/quadratic-regex-2x | 199 | 3.70 ± 0.4% | not timed | not timed | 3.05 ± 1.2% | 0.01 ± 4.4% | not timed | not timed | 3.70 ± 2.1% | | 1.00 | 1.21 | 280.29 |
| slow/quadratic-haystack-1x | 100 | 25.87 ± 1.7% | not timed | not timed | 12.18 ± 0.7% | 0.99 ± 14.9% | not timed | not timed | 26.20 ± 1.7% | | 0.99 | 2.12 | 26.06 |
| slow/quadratic-haystack-2x | 200 | 19.84 ± 1.0% | not timed | not timed | 6.12 ± 0.5% | 0.55 ± 2.8% | not timed | not timed | 19.92 ± 6.7% | | 1.00 | 3.24 | 36.00 |
| unicode/codepoints/any-one | 1112064 | 336.06 ± 0.9% | not timed | not timed | 236.68 ± 0.7% | 21.84 ± 14.5% | not timed | not timed | 338.86 ± 0.3% | | 0.99 | 1.42 | 15.39 |
| unicode/codepoints/any-all | 4382592 | 268.35 ± 0.6% | not timed | not timed | 261.63 ± 0.6% | 125.75 ± 0.5% | not timed | not timed | 266.87 ± 1.4% | | 1.01 | 1.03 | 2.13 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.86 ± 0.8% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 610.03 ± 0.2% | not timed | not timed | 604.03 ± 0.2% | 153.96 ± 12.6% | not timed | not timed | 610.05 ± 0.3% | | 1.00 | 1.01 | 3.96 |
| unicode/overlapping-words/ascii | 6156 | 28.95 ± 6.8% | not timed | not timed | 42.83 ± 1.2% | 4.33 ± 4.3% | not timed | not timed | 28.37 ± 0.9% | | 1.02 | 0.68 | 6.68 |
| unicode/overlapping-words/english | 6156 | 1.48 ± 0.4% | not timed | not timed | 3.09 ± 3.4% | 2.81 ± 9.3% | not timed | not timed | 1.47 ± 3.4% | | 1.00 | 0.48 | 0.52 |
| unicode/overlapping-words/russian | 5710 | 1.31 ± 9.6% | not timed | not timed | 3.08 ± 0.0% | 7.11 ± 10.0% | not timed | not timed | 1.33 ± 1.0% | | 0.99 | 0.43 | 0.18 |
| unicode/word/boundary-any-english | 450561 | 138.23 ± 1.3% | not timed | not timed | 82.65 ± 0.8% | 13.73 ± 20.1% | not timed | not timed | 138.26 ± 0.7% | | 1.00 | 1.67 | 10.07 |
| unicode/word/boundary-long-english | 3466 | 611.12 ± 0.3% | not timed | not timed | 593.28 ± 0.6% | 35.51 ± 0.7% | not timed | not timed | 611.96 ± 0.3% | | 1.00 | 1.03 | 17.21 |
| unicode/word/around-holmes-english | 27 | 63378.08 ± 35.0% | not timed | not timed | 44916.75 ± 0.8% | 24.04 ± 0.3% | not timed | not timed | 63026.56 ± 1.0% | | 1.01 | 1.41 | 2636.30 |
| wild/bibleref/long | 874 | 568.45 ± 0.5% | not timed | not timed | 574.52 ± 0.2% | 7.93 ± 0.4% | not timed | not timed | 569.99 ± 0.3% | | 1.00 | 0.99 | 71.65 |
| wild/bibleref/short | 30 | 21.61 ± 6.5% | not timed | not timed | 32.40 ± 0.7% | 15.56 ± 23.4% | not timed | not timed | 23.06 ± 0.9% | | 0.94 | 0.67 | 1.39 |
| wild/bibleref/line | 874 | 511.85 ± 1.5% | not timed | not timed | 282.14 ± 0.2% | 9.65 ± 2.6% | not timed | not timed | 515.71 ± 0.6% | | 0.99 | 1.81 | 53.06 |
| wild/caddy/caddy | 6 | 449.32 ± 2.5% | not timed | not timed | 290.55 ± 0.8% | 78.88 ± 22.1% | not timed | not timed | 443.79 ± 9.3% | | 1.01 | 1.55 | 5.70 |
| wild/dot-star-capture/rust-src-tools | 6 | 1455.23 ± 0.2% | not timed | not timed | 402.96 ± 1.1% | 15.90 ± 0.1% | not timed | not timed | 1454.96 ± 0.3% | | 1.00 | 3.61 | 91.50 |
| wild/ruff/noqa | 84 | 511.33 ± 0.3% | not timed | not timed | 512.33 ± 1.2% | 21.35 ± 4.1% | not timed | not timed | 512.16 ± 0.6% | | 1.00 | 1.00 | 23.95 |
| wild/ruff/unnecessary-coding-comment | 16 | 1072.70 ± 0.6% | not timed | not timed | 722.27 ± 0.3% | 89.92 ± 8.5% | not timed | not timed | 1074.35 ± 1.3% | | 1.00 | 1.49 | 11.93 |
| wild/ruff/string-quote-prefix | 2972 | 1560.28 ± 1.0% | not timed | not timed | 488.69 ± 7.6% | 321.67 ± 29.2% | not timed | not timed | 1592.34 ± 0.8% | | 0.98 | 3.19 | 4.85 |
| wild/ruff/space-around-operator | 1224378 | 236.85 ± 4.2% | not timed | not timed | 227.70 ± 0.7% | 18.93 ± 4.7% | not timed | not timed | 237.69 ± 1.9% | | 1.00 | 1.04 | 12.51 |
| wild/ruff/shebang | 282 | 1110.28 ± 0.6% | not timed | not timed | 387.05 ± 0.4% | 106.96 ± 9.5% | not timed | not timed | 1121.63 ± 0.8% | | 0.99 | 2.87 | 10.38 |
| wild/rustsec-cargo-audit/original-unix | 471 | 22586.55 ± 0.7% | not timed | not timed | 23784.18 ± 1.0% | 8926.56 ± 3.2% | not timed | not timed | 21897.45 ± 0.9% | | 1.03 | 0.95 | 2.53 |
| wild/rustsec-cargo-audit/original-windows | 462 | 20578.24 ± 1.5% | not timed | not timed | 22285.79 ± 3.0% | 8426.64 ± 0.8% | not timed | not timed | 20595.45 ± 0.6% | | 1.00 | 0.92 | 2.44 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 22738.15 ± 2.1% | not timed | not timed | 23216.44 ± 1.6% | 8622.72 ± 2.1% | not timed | not timed | 22756.31 ± 1.4% | | 1.00 | 0.98 | 2.64 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 17989.39 ± 5.7% | not timed | not timed | 23007.51 ± 0.8% | 8583.19 ± 23.4% | not timed | not timed | 18111.24 ± 6.5% | | 0.99 | 0.78 | 2.10 |
| wild/url/search | 234965 | 127.24 ± 16.1% | not timed | not timed | 60.24 ± 1.3% | 2.44 ± 2.3% | not timed | not timed | 128.35 ± 12.7% | | 0.99 | 2.11 | 52.21 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 3.8% | not timed | not timed | 0.01 ± 0.6% | 0.01 ± 15.6% | not timed | not timed | 0.03 ± 14.4% | | 1.01 | 2.57 | 4.72 |
| dictionary/compile/english-15 | 1 | 0.34 ± 1.6% | not timed | not timed | 0.09 ± 1.7% | 0.12 ± 4.8% | not timed | not timed | 0.34 ± 1.2% | | 1.00 | 3.73 | 2.94 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.29 ± 4.7% | not timed | not timed | 0.02 ± 0.9% | 36.67 ± 21.7% | not timed | not timed | 0.30 ± 9.3% | | 0.97 | 12.75 | 0.0078 |
| reported/i1095-word-repetition/ascii-compile | 1 | 43.91 ± 9.8% | not timed | not timed | 17.02 ± 0.3% | 61.56 ± 15.3% | not timed | not timed | 44.31 ± 17.0% | | 0.99 | 2.58 | 0.71 |
| reported/i787-keywords/compile | 1 | 39.68 ± 3.6% | not timed | not timed | 2.38 ± 0.3% | 17.80 ± 21.8% | not timed | not timed | 39.99 ± 2.9% | | 0.99 | 16.66 | 2.23 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 358.61 ± 1.3% | not timed | not timed | 152.36 ± 0.3% | 597.92 ± 16.1% | not timed | not timed | 359.46 ± 1.5% | | 1.00 | 2.35 | 0.60 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 52.29 ± 3.3% | not timed | not timed | 5.53 ± 1.6% | 47.99 ± 10.0% | not timed | not timed | 53.60 ± 8.9% | | 0.98 | 9.45 | 1.09 |
| unicode/compile/one-letter | 53 | 6.91 ± 13.2% | not timed | not timed | 5.79 ± 1.3% | 64.07 ± 5.2% | not timed | not timed | 6.95 ± 1.5% | | 0.99 | 1.19 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.19 ± 11.7% | not timed | not timed | 0.13 ± 0.9% | 64.76 ± 17.3% | not timed | not timed | 1.24 ± 1.7% | | 0.96 | 9.47 | 0.0184 |
| unicode/compile/fifty-letters-ascii | 1 | 200.98 ± 3.1% | not timed | not timed | 69.03 ± 0.3% | 228.29 ± 16.2% | not timed | not timed | 200.61 ± 2.6% | | 1.00 | 2.91 | 0.88 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 428.35 ± 5.5% | not timed | not timed | 51.20 ± 1.1% | 735.05 ± 15.1% | not timed | not timed | 433.28 ± 7.2% | | 0.99 | 8.37 | 0.58 |
| unicode/compile/match-every-line-ascii | 4 | 669.75 ± 10.3% | not timed | not timed | 168.11 ± 6.9% | 737.69 ± 14.2% | not timed | not timed | 678.60 ± 6.7% | | 0.99 | 3.98 | 0.91 |
| unicode/compile/negated-class-matches-codepoint | 1 | 343.89 ± 21.7% | not timed | not timed | 55.44 ± 0.3% | 1331.75 ± 11.8% | not timed | not timed | 348.23 ± 2.1% | | 0.99 | 6.20 | 0.26 |
| wild/bibleref/compile | 3 | 6.13 ± 2.6% | not timed | not timed | 2.44 ± 0.4% | 32.90 ± 7.1% | not timed | not timed | 6.20 ± 2.5% | | 0.99 | 2.51 | 0.19 |
| wild/url/compile | 1 | 0.70 ± 0.6% | not timed | not timed | 0.20 ± 2.8% | 0.48 ± 40.6% | not timed | not timed | 0.70 ± 20.2% | | 1.00 | 3.51 | 1.47 |

