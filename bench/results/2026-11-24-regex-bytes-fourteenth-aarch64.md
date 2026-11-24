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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391548887 |
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
| literal: a word | 217 | 19262.48 ± 1.7% | 5029.46 ± 0.5% | 28.15 ± 0.3% | 18152.26 ± 2.6% | 9277.75 ± 6.9% | 17.36 ± 0.3% | 84.36 ± 0.5% | 19352.89 ± 3.2% | 3.83 | 1.00 | 1.06 | 2.08 |
| literal: a word that is not there | 0 | 21696.59 ± 4.5% | 4925.10 ± 0.5% | 28.25 ± 0.3% | 19865.96 ± 2.7% | 28976.27 ± 1.6% | 17.14 ± 0.3% | 79.77 ± 0.3% | 21642.19 ± 3.5% | 4.41 | 1.00 | 1.09 | 0.75 |
| literal: one of four words | 661 | 6350.76 ± 0.1% | 1945.52 ± 0.2% | 14.35 ± 0.3% | 3941.83 ± 0.6% | 21.85 ± 0.2% | 5.44 ± 0.4% | 6.88 ± 0.3% | 6353.18 ± 0.3% | 3.26 | 1.00 | 1.61 | 290.59 |
| literal: a word in any case | 217 | 15119.56 ± 0.9% | 2085.54 ± 0.2% | 21.31 ± 0.3% | 3967.71 ± 0.3% | 37.68 ± 1.1% | refused | differs | 15025.69 ± 2.7% | 7.25 | 1.01 | 3.81 | 401.25 |
| literal: an href attribute | 33 | 16581.21 ± 0.9% | 608.73 ± 0.1% | 27.22 ± 0.3% | 16751.86 ± 1.3% | 2259.30 ± 0.8% | 13.18 ± 0.3% | 74.12 ± 0.3% | 16591.46 ± 2.2% | 27.24 | 1.00 | 0.99 | 7.34 |
| literal: a word, second text | 123 | 20125.28 ± 3.2% | 3386.40 ± 0.2% | 27.86 ± 0.5% | 18337.66 ± 1.8% | 7742.75 ± 4.3% | 20.15 ± 0.6% | 70.42 ± 0.2% | 19930.70 ± 2.3% | 5.94 | 1.01 | 1.10 | 2.60 |
| class: two capitalized words | 1331 | 1069.65 ± 0.3% | 597.55 ± 0.2% | 25.94 ± 0.3% | 585.14 ± 0.1% | 40.58 ± 2.4% | 14.75 ± 0.4% | 67.53 ± 0.4% | 1068.64 ± 0.2% | 1.79 | 1.00 | 1.83 | 26.36 |
| class: a word that ends in ing | 3399 | 572.73 ± 0.2% | 572.28 ± 0.4% | 17.97 ± 0.4% | 547.31 ± 0.1% | 29.58 ± 8.2% | 8.21 ± 0.2% | 18.43 ± 0.1% | 573.12 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.36 |
| class: a word in capitals | 2332 | 1374.13 ± 0.5% | 603.95 ± 0.1% | 27.55 ± 0.2% | 572.07 ± 0.5% | 43.57 ± 16.5% | 17.19 ± 0.1% | 82.66 ± 0.2% | 1380.24 ± 0.4% | 2.28 | 1.00 | 2.40 | 31.54 |
| class: a number | 8288 | 1992.03 ± 0.4% | 828.38 ± 0.1% | 27.65 ± 0.5% | 1730.16 ± 0.3% | 41.59 ± 16.4% | 0.55 ± 0.0% | 57.77 ± 0.2% | 1986.82 ± 0.5% | 2.40 | 1.00 | 1.15 | 47.90 |
| class: two capitalized words, second text | 5359 | 515.99 ± 0.2% | 523.40 ± 0.2% | 23.28 ± 0.1% | 481.49 ± 0.1% | 35.51 ± 14.2% | 17.11 ± 0.2% | 62.91 ± 0.2% | 516.22 ± 0.1% | 0.99 | 1.00 | 1.07 | 14.53 |
| other: a word between two words | 6104 | 786.34 ± 0.1% | 592.59 ± 0.4% | 23.53 ± 0.1% | 736.11 ± 0.2% | 111.98 ± 24.1% | 11.17 ± 0.1% | 68.37 ± 0.2% | 787.45 ± 0.2% | 1.33 | 1.00 | 1.07 | 7.02 |
| other: a number before a unit, second text | 1481 | 5976.82 ± 1.2% | 1120.45 ± 0.3% | 26.02 ± 0.1% | 5670.06 ± 0.2% | 40.74 ± 0.1% | 18.23 ± 0.1% | 65.90 ± 0.4% | 5945.16 ± 0.5% | 5.33 | 1.01 | 1.05 | 146.72 |
| other: a heading's start tag | 110 | 13906.35 ± 0.3% | 743.56 ± 0.1% | 27.39 ± 0.2% | 1709.64 ± 0.2% | 1574.25 ± 5.5% | 16.17 ± 0.5% | 86.37 ± 0.3% | 13903.77 ± 1.4% | 18.70 | 1.00 | 8.13 | 8.83 |
| other: a whole word | 217 | 15508.25 ± 0.6% | 602.78 ± 0.2% | 29.26 ± 0.4% | 14558.28 ± 0.5% | 49.23 ± 0.7% | 13.31 ± 0.2% | 55.12 ± 0.1% | 15890.98 ± 1.5% | 25.73 | 0.98 | 1.07 | 315.02 |
| other: a line's first word, second text | 3716 | 2043.09 ± 0.3% | 587.73 ± 0.2% | 31.02 ± 0.2% | 1722.07 ± 0.5% | 62.58 ± 6.4% | refused | refused | 2048.65 ± 0.9% | 3.48 | 1.00 | 1.19 | 32.65 |
| other: fourteen octets before an x | 87 | 23656.73 ± 1.2% | 238.63 ± 0.4% | 6.32 ± 0.1% | 4032.67 ± 1.1% | 10.63 ± 0.2% | differs | 17.82 ± 0.0% | 23732.27 ± 7.3% | 99.14 | 1.00 | 5.87 | 2225.79 |
| other: a Greek word | 21815 | 497.77 ± 0.4% | 411.61 ± 0.3% | 30.64 ± 0.1% | 289.94 ± 0.1% | 49.51 ± 13.2% | differs | refused | 499.15 ± 0.5% | 1.21 | 1.00 | 1.72 | 10.05 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.59 ± 0.2% | 19.57 ± 0.3% | 0.85 ± 0.4% | 19.85 ± 0.4% | 2.77 ± 0.7% | differs | 4.07 ± 0.1% | 19.55 ± 0.3% | 1.00 | 1.00 | 0.99 | 7.09 |
| a UUID | 32895 | 21.13 ± 0.1% | 21.10 ± 0.2% | 0.64 ± 0.1% | 15.13 ± 0.4% | 3.11 ± 0.1% | 0.73 ± 0.2% | 3.67 ± 0.9% | 21.09 ± 0.2% | 1.00 | 1.00 | 1.40 | 6.80 |
| an IPv4 address | 33176 | 35.96 ± 0.2% | 35.97 ± 0.3% | 2.04 ± 0.0% | 29.43 ± 0.4% | 6.67 ± 0.2% | differs | 4.18 ± 0.1% | 35.99 ± 0.8% | 1.00 | 1.00 | 1.22 | 5.39 |
| a date and time | 32954 | 31.12 ± 0.2% | 31.10 ± 0.1% | 1.43 ± 0.2% | 21.54 ± 0.4% | 7.03 ± 0.1% | 1.25 ± 0.1% | 7.17 ± 0.3% | 31.10 ± 0.7% | 1.00 | 1.00 | 1.44 | 4.42 |
| a field path | 32606 | 23.09 ± 0.1% | 23.15 ± 0.3% | 1.01 ± 0.2% | 23.26 ± 0.3% | 3.47 ± 1.1% | differs | 2.99 ± 0.4% | 23.12 ± 0.1% | 1.00 | 1.00 | 0.99 | 6.65 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.22 ± 0.6% | 11.20 ± 0.3% | 11.21 ± 0.5% | 11.81 ± 0.2% | 4.94 ± 1.8% | 0.93 ± 1.2% | none | 11.19 ± 1.8% | 1.00 | 1.00 | 0.95 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 227.07 ± 0.1% | 228.28 ± 0.3% | 268.40 ± 0.2% | 86.71 ± 0.6% | 220.31 ± 2.5% | 477.32 ± 1.4% | 3804.58 ± 3.2% | 227.44 ± 0.3% | 0.99 | 1.00 | 2.62 | 1.03 |
| a UUID | 62 | 149.14 ± 0.1% | 149.63 ± 0.1% | 166.29 ± 0.1% | 46.05 ± 0.9% | 98.61 ± 0.8% | 190.55 ± 2.3% | 4177.31 ± 0.8% | 149.13 ± 0.2% | 1.00 | 1.00 | 3.24 | 1.51 |
| an IPv4 address | 29 | 427.19 ± 0.3% | 429.65 ± 0.4% | 599.31 ± 0.7% | 76.99 ± 0.6% | 130.90 ± 0.9% | 296.86 ± 0.6% | 7509.26 ± 0.2% | 427.82 ± 0.4% | 0.99 | 1.00 | 5.55 | 3.26 |
| a date and time | 56 | 308.89 ± 0.5% | 311.10 ± 0.2% | 389.54 ± 0.2% | 72.34 ± 0.2% | 136.02 ± 1.4% | 326.24 ± 2.2% | 4809.49 ± 1.0% | 309.01 ± 0.2% | 0.99 | 1.00 | 4.27 | 2.27 |
| a field path | 39 | 218.79 ± 0.2% | 219.91 ± 0.1% | 256.33 ± 0.2% | 79.47 ± 2.5% | 203.97 ± 1.9% | 507.62 ± 4.0% | 4876.13 ± 1.7% | 218.97 ± 0.2% | 0.99 | 1.00 | 2.75 | 1.07 |
| literal: a word | 7 | 635.62 ± 0.3% | 688.40 ± 0.4% | 1232.75 ± 0.1% | 501.88 ± 0.1% | 625.17 ± 1.5% | 968.03 ± 0.6% | 31070.79 ± 0.1% | 635.98 ± 0.3% | 0.92 | 1.00 | 1.27 | 1.02 |
| literal: a word that is not there | 8 | 612.32 ± 0.4% | 665.17 ± 0.4% | 1155.61 ± 0.6% | 459.34 ± 0.3% | 600.41 ± 2.4% | 913.09 ± 0.3% | 29548.30 ± 0.2% | 612.79 ± 0.3% | 0.92 | 1.00 | 1.33 | 1.02 |
| literal: one of four words | 26 | 246.81 ± 0.2% | 403.55 ± 0.2% | 549.34 ± 0.3% | 49.53 ± 0.5% | 239.64 ± 2.6% | 368.31 ± 0.7% | 16096.89 ± 0.1% | 247.16 ± 0.1% | 0.61 | 1.00 | 4.98 | 1.03 |
| literal: a word in any case | 11 | 454.39 ± 0.2% | 486.66 ± 0.3% | 717.36 ± 0.1% | 15.47 ± 0.2% | 642.80 ± 1.5% | refused | 23753.57 ± 0.9% | 454.83 ± 0.3% | 0.93 | 1.00 | 29.38 | 0.71 |
| literal: an href attribute | 12 | 349.04 ± 1.7% | 361.42 ± 0.4% | 472.59 ± 0.4% | 10.09 ± 21.9% | 492.33 ± 2.0% | 773.93 ± 0.3% | 22258.56 ± 0.3% | 349.40 ± 0.2% | 0.97 | 1.00 | 34.60 | 0.71 |
| literal: a word, second text | 10 | 561.90 ± 0.5% | 621.44 ± 0.4% | 1032.72 ± 0.5% | 407.04 ± 1.4% | 531.34 ± 8.6% | 793.36 ± 0.5% | 27569.17 ± 0.3% | 562.30 ± 0.8% | 0.90 | 1.00 | 1.38 | 1.06 |
| class: two capitalized words | 23 | 440.42 ± 0.4% | 472.98 ± 0.3% | 677.28 ± 1.1% | 99.24 ± 0.7% | 503.00 ± 1.8% | 739.97 ± 0.7% | 6466.35 ± 0.3% | 440.83 ± 0.4% | 0.93 | 1.00 | 4.44 | 0.88 |
| class: a word that ends in ing | 9 | 571.19 ± 0.2% | 637.59 ± 0.5% | 1106.71 ± 0.4% | 133.24 ± 2.0% | 750.47 ± 1.3% | 1146.03 ± 0.9% | 16078.83 ± 1.2% | 571.98 ± 0.2% | 0.90 | 1.00 | 4.29 | 0.76 |
| class: a word in capitals | 16 | 497.15 ± 0.2% | 541.30 ± 0.1% | 857.35 ± 0.2% | 137.53 ± 0.4% | 748.77 ± 2.0% | 1051.08 ± 0.3% | 8548.29 ± 0.5% | 497.50 ± 0.3% | 0.92 | 1.00 | 3.61 | 0.66 |
| class: a number | 6 | 638.23 ± 0.2% | 704.15 ± 0.2% | 1314.47 ± 0.1% | 42.15 ± 0.9% | 1376.36 ± 3.4% | 1859.94 ± 1.0% | 23060.09 ± 0.2% | 638.48 ± 0.2% | 0.91 | 1.00 | 15.14 | 0.46 |
| class: two capitalized words, second text | 23 | 439.49 ± 0.6% | 471.20 ± 1.0% | 674.73 ± 0.5% | 101.32 ± 1.0% | 495.02 ± 6.5% | 767.97 ± 0.9% | 6468.67 ± 0.2% | 440.32 ± 0.4% | 0.93 | 1.00 | 4.34 | 0.89 |
| other: a word between two words | 13 | 553.70 ± 0.3% | 573.20 ± 0.5% | 912.96 ± 0.3% | 131.23 ± 0.8% | 496.86 ± 1.5% | 814.15 ± 2.1% | 14633.75 ± 0.3% | 553.48 ± 0.4% | 0.97 | 1.00 | 4.22 | 1.11 |
| other: a number before a unit, second text | 15 | 399.69 ± 0.3% | 438.62 ± 0.2% | 609.95 ± 0.6% | 39.23 ± 1.2% | 627.80 ± 2.0% | 890.95 ± 0.8% | 15381.59 ± 0.5% | 399.94 ± 0.3% | 0.91 | 1.00 | 10.19 | 0.64 |
| other: a heading's start tag | 13 | 361.36 ± 0.6% | 368.78 ± 0.4% | 484.18 ± 0.4% | 12.62 ± 6.1% | 617.50 ± 1.3% | 886.87 ± 0.1% | 18397.90 ± 0.5% | 361.94 ± 0.5% | 0.98 | 1.00 | 28.63 | 0.59 |
| other: a whole word | 11 | 584.59 ± 0.3% | 622.92 ± 0.6% | 1038.33 ± 0.2% | 119.26 ± 0.4% | 561.88 ± 2.0% | 848.18 ± 0.4% | 27309.27 ± 0.2% | 583.17 ± 0.4% | 0.94 | 1.00 | 4.90 | 1.04 |
| other: a line's first word, second text | 17 | 533.10 ± 0.8% | 559.88 ± 0.7% | 894.83 ± 1.2% | 129.00 ± 0.1% | 704.48 ± 0.6% | refused | refused | 533.26 ± 1.0% | 0.95 | 1.00 | 4.13 | 0.76 |
| other: fourteen octets before an x | 16 | 110.38 ± 0.6% | 158.77 ± 1.4% | 181.33 ± 1.5% | 6.79 ± 1.4% | 446.19 ± 0.9% | 431.04 ± 0.7% | 12953.16 ± 0.7% | 110.35 ± 0.4% | 0.70 | 1.00 | 16.25 | 0.25 |
| other: a Greek word | 8 | 456.37 ± 0.5% | 607.41 ± 0.2% | 1018.07 ± 0.1% | 13.05 ± 24.0% | 1345.78 ± 4.9% | 1771.46 ± 0.6% | refused | 456.38 ± 0.4% | 0.75 | 1.00 | 34.98 | 0.34 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15696.84 ± 1.8% | not timed | not timed | 16200.00 ± 2.4% | 2113.54 ± 19.0% | not timed | not timed | 15692.46 ± 0.6% | | 1.00 | 0.97 | 7.43 |
| 01-literal/sherlock-casei-en | 522 | 11010.78 ± 6.8% | not timed | not timed | 3590.11 ± 0.2% | 32.54 ± 0.3% | not timed | not timed | 10956.08 ± 6.4% | | 1.00 | 3.07 | 338.36 |
| 01-literal/sherlock-ru | 724 | 17112.29 ± 3.0% | not timed | not timed | 17273.68 ± 0.4% | 1437.33 ± 5.5% | not timed | not timed | 17127.91 ± 0.8% | | 1.00 | 0.99 | 11.91 |
| 01-literal/sherlock-casei-ru | 746 | 6175.51 ± 0.4% | not timed | not timed | 3334.76 ± 0.4% | 30.71 ± 0.7% | not timed | not timed | 6186.78 ± 0.3% | | 1.00 | 1.85 | 201.10 |
| 01-literal/sherlock-zh | 30 | 19830.33 ± 0.5% | not timed | not timed | 18631.83 ± 0.4% | 2668.82 ± 9.6% | not timed | not timed | 19866.30 ± 0.8% | | 1.00 | 1.06 | 7.43 |
| 02-literal-alternate/sherlock-en | 714 | 6062.78 ± 0.3% | not timed | not timed | 3942.86 ± 0.4% | 16.60 ± 0.1% | not timed | not timed | 6064.23 ± 0.3% | | 1.00 | 1.54 | 365.20 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1982.23 ± 1.1% | not timed | not timed | 699.41 ± 0.2% | 11.12 ± 0.2% | not timed | not timed | 1981.88 ± 0.7% | | 1.00 | 2.83 | 178.31 |
| 02-literal-alternate/sherlock-ru | 899 | 5567.97 ± 0.3% | not timed | not timed | 3251.32 ± 0.4% | 22.61 ± 0.2% | not timed | not timed | 5573.19 ± 0.2% | | 1.00 | 1.71 | 246.27 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2056.17 ± 0.5% | not timed | not timed | 1231.21 ± 0.2% | 9.12 ± 0.4% | not timed | not timed | 2055.78 ± 0.3% | | 1.00 | 1.67 | 225.47 |
| 02-literal-alternate/sherlock-zh | 207 | 7305.42 ± 0.3% | not timed | not timed | 4165.57 ± 0.1% | 31.54 ± 0.1% | not timed | not timed | 7294.61 ± 0.2% | | 1.00 | 1.75 | 231.62 |
| 03-date/ascii | 111817 | 120.29 ± 0.5% | not timed | not timed | 96.23 ± 0.2% | 0.20 ± 4.3% | not timed | not timed | 124.10 ± 0.5% | | 0.97 | 1.25 | 589.39 |
| 04-ruff-noqa/real | 84 | 403.53 ± 0.1% | not timed | not timed | 449.03 ± 0.1% | 19.55 ± 2.2% | not timed | not timed | 403.66 ± 0.1% | | 1.00 | 0.90 | 20.64 |
| 04-ruff-noqa/tweaked | 44 | 556.19 ± 0.2% | not timed | not timed | 465.71 ± 0.1% | 364.25 ± 1.0% | not timed | not timed | 555.72 ± 0.6% | | 1.00 | 1.19 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.55 ± 0.3% | not timed | not timed | 5.22 ± 0.2% | 0.20 ± 3.7% | not timed | not timed | 5.40 ± 13.4% | | 1.03 | 1.06 | 27.06 |
| 06-cloud-flare-redos/original | 107 | 416.04 ± 0.4% | not timed | not timed | 214.57 ± 0.0% | 24.75 ± 0.1% | not timed | not timed | 415.98 ± 0.2% | | 1.00 | 1.94 | 16.81 |
| 06-cloud-flare-redos/simplified-short | 102 | 415.92 ± 0.1% | not timed | not timed | 228.42 ± 0.1% | 26.66 ± 0.3% | not timed | not timed | 410.74 ± 0.1% | | 1.01 | 1.82 | 15.60 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.10 ± 0.5% | not timed | not timed | 255.59 ± 0.1% | 28.88 ± 0.1% | not timed | not timed | 578.01 ± 0.4% | | 1.02 | 2.30 | 20.33 |
| 07-unicode-character-data/parse-line | 558784 | 235.51 ± 1.2% | not timed | not timed | 180.26 ± 0.1% | 41.29 ± 4.9% | not timed | not timed | 238.27 ± 1.9% | | 0.99 | 1.31 | 5.70 |
| 08-words/all-english | 56691 | 115.84 ± 0.8% | not timed | not timed | 83.06 ± 0.1% | 12.44 ± 8.7% | not timed | not timed | 116.69 ± 0.7% | | 0.99 | 1.39 | 9.31 |
| 08-words/long-english | 839 | 614.48 ± 0.3% | not timed | not timed | 596.27 ± 0.1% | 32.61 ± 0.2% | not timed | not timed | 614.70 ± 0.2% | | 1.00 | 1.03 | 18.84 |
| 09-aws-keys/full | 0 | 407.30 ± 0.1% | not timed | not timed | 492.52 ± 0.3% | 64.49 ± 0.5% | not timed | not timed | 368.27 ± 0.6% | | 1.11 | 0.83 | 6.32 |
| 09-aws-keys/quick | 0 | 871.01 ± 0.2% | not timed | not timed | 996.96 ± 0.2% | 416.50 ± 1.2% | not timed | not timed | 871.62 ± 0.4% | | 1.00 | 0.87 | 2.09 |
| 10-bounded-repeat/letters-en | 1833 | 577.73 ± 1.2% | not timed | not timed | 518.56 ± 0.7% | 19.53 ± 0.6% | not timed | not timed | 581.23 ± 1.9% | | 0.99 | 1.11 | 29.59 |
| 10-bounded-repeat/letters-ru | 3475 | 508.52 ± 1.5% | not timed | not timed | 479.27 ± 0.1% | 21.76 ± 17.5% | not timed | not timed | 510.19 ± 1.2% | | 1.00 | 1.06 | 23.37 |
| 10-bounded-repeat/context | 53 | 84.73 ± 2.0% | not timed | not timed | 65.27 ± 1.5% | 19.83 ± 0.2% | not timed | not timed | 84.66 ± 1.8% | | 1.00 | 1.30 | 4.27 |
| 10-bounded-repeat/capitals | 11 | 641.43 ± 8.0% | not timed | not timed | 616.47 ± 0.1% | 36.52 ± 0.1% | not timed | not timed | 640.68 ± 8.0% | | 1.00 | 1.04 | 17.56 |
| 11-unstructured-to-json/extract | 600 | 56.73 ± 0.5% | not timed | not timed | 76.33 ± 0.2% | 48.89 ± 0.4% | not timed | not timed | 56.84 ± 0.5% | | 1.00 | 0.74 | 1.16 |
| 12-dictionary/single | 1 | 567.17 ± 0.9% | not timed | not timed | 561.74 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 568.94 ± 0.2% | | 1.00 | 1.01 | 1430.92 |
| 14-quadratic/1x | 100 | 20.92 ± 0.6% | not timed | not timed | 10.04 ± 0.1% | 0.98 ± 3.5% | not timed | not timed | 21.13 ± 1.4% | | 0.99 | 2.08 | 21.39 |
| 14-quadratic/2x | 200 | 17.37 ± 0.8% | not timed | not timed | 5.56 ± 0.1% | 0.53 ± 0.8% | not timed | not timed | 17.40 ± 0.7% | | 1.00 | 3.13 | 32.55 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.6% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 7.67 ± 0.7% | | 1.00 | 6.34 | 66.78 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 1.6% | not timed | not timed | 0.34 ± 0.6% | 0.53 ± 4.4% | not timed | not timed | 1.27 ± 1.9% | | 0.99 | 3.69 | 2.36 |
| 04-ruff-noqa/compile-real | 1 | 103.98 ± 1.4% | not timed | not timed | 13.85 ± 0.3% | 129.78 ± 5.0% | not timed | not timed | 104.39 ± 1.6% | | 1.00 | 7.51 | 0.80 |
| 05-lexer-veryl/compile-single | 1 | 14.09 ± 1.4% | not timed | not timed | 2.53 ± 0.9% | 6.04 ± 4.0% | not timed | not timed | 14.17 ± 0.5% | | 0.99 | 5.56 | 2.33 |
| 07-unicode-character-data/compile | 1 | 108.60 ± 0.5% | not timed | not timed | 26.02 ± 0.4% | 34.29 ± 4.1% | not timed | not timed | 108.90 ± 1.3% | | 1.00 | 4.17 | 3.17 |
| 09-aws-keys/compile-full | 1 | 52.74 ± 1.5% | not timed | not timed | 8.34 ± 0.8% | 22.12 ± 5.7% | not timed | not timed | 53.25 ± 0.5% | | 0.99 | 6.32 | 2.38 |
| 09-aws-keys/compile-quick | 1 | 188.24 ± 1.5% | not timed | not timed | 48.46 ± 0.4% | 127.96 ± 8.3% | not timed | not timed | 188.63 ± 0.3% | | 1.00 | 3.88 | 1.47 |
| 10-bounded-repeat/compile-context | 1 | 71.44 ± 0.8% | not timed | not timed | 11.07 ± 0.2% | 14.61 ± 5.5% | not timed | not timed | 71.75 ± 2.0% | | 1.00 | 6.45 | 4.89 |
| 10-bounded-repeat/compile-capitals | 1 | 84.38 ± 1.5% | not timed | not timed | 7.95 ± 0.3% | 22.06 ± 6.0% | not timed | not timed | 85.55 ± 0.2% | | 0.99 | 10.61 | 3.82 |
| 11-unstructured-to-json/compile | 1 | 171.69 ± 1.3% | not timed | not timed | 40.89 ± 0.8% | 62.69 ± 1.8% | not timed | not timed | 172.39 ± 1.4% | | 1.00 | 4.20 | 2.74 |
| 12-dictionary/compile-single | 1 | 0.35 ± 3.6% | not timed | not timed | 0.06 ± 16.4% | 0.09 ± 13.8% | not timed | not timed | 0.35 ± 0.6% | | 1.00 | 5.46 | 3.87 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.59 ± 6.0% | not timed | not timed | 6.57 ± 0.1% | 0.59 ± 20.1% | not timed | not timed | 7.61 ± 2.3% | | 1.00 | 1.16 | 12.89 |
| dictionary/search/english-10 | 690 | 1.04 ± 1.1% | not timed | not timed | 165.21 ± 1.1% | 0.00 ± 0.8% | not timed | not timed | 1.05 ± 1.3% | | 1.00 | 0.0063 | 374.20 |
| dictionary/search/english-15 | 15 | 560.05 ± 0.6% | not timed | not timed | 558.01 ± 0.1% | 0.36 ± 0.2% | not timed | not timed | 560.84 ± 0.3% | | 1.00 | 1.00 | 1537.10 |
| folly/awyer-inn-busted | 1 | 5587.66 ± 0.1% | not timed | not timed | 142.96 ± 0.4% | 43.70 ± 0.2% | not timed | not timed | 5574.95 ± 0.1% | | 1.00 | 39.09 | 127.86 |
| folly/literal-never-match-rare | 0 | 21077.82 ± 0.4% | not timed | not timed | 19860.90 ± 0.4% | 40760.96 ± 0.5% | not timed | not timed | 21081.48 ± 0.3% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12507.61 ± 1.0% | not timed | not timed | 19816.93 ± 0.4% | 2196.13 ± 0.5% | not timed | not timed | 12507.36 ± 0.9% | | 1.00 | 0.63 | 5.70 |
| folly/literal-never-match-tricksy | 1 | 3236.60 ± 0.3% | not timed | not timed | 4408.31 ± 0.2% | 2952.61 ± 0.4% | not timed | not timed | 3230.77 ± 0.4% | | 1.00 | 0.73 | 1.10 |
| grep/every-line | 239963 | 1304.57 ± 1.3% | not timed | not timed | 964.69 ± 0.3% | 373.14 ± 19.0% | not timed | not timed | 1302.82 ± 3.7% | | 1.00 | 1.35 | 3.50 |
| grep/long-words-ascii | 5073 | 459.41 ± 0.1% | not timed | not timed | 469.82 ± 0.2% | 46.22 ± 8.3% | not timed | not timed | 436.23 ± 0.9% | | 1.05 | 0.98 | 9.94 |
| imported/leipzig/twain | 811 | 20547.89 ± 6.6% | not timed | not timed | 19434.81 ± 1.3% | 11847.82 ± 12.1% | not timed | not timed | 20511.19 ± 1.2% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9004.43 ± 1.1% | not timed | not timed | 4243.17 ± 0.1% | 37.70 ± 0.1% | not timed | not timed | 9042.16 ± 0.6% | | 1.00 | 2.12 | 238.82 |
| imported/leipzig/shing | 1540 | 629.63 ± 0.1% | not timed | not timed | 13035.71 ± 1.4% | 34.07 ± 0.1% | not timed | not timed | 631.99 ± 0.1% | | 1.00 | 0.0483 | 18.48 |
| imported/leipzig/huck-saw | 262 | 8157.54 ± 2.6% | not timed | not timed | 5537.32 ± 0.7% | 31.82 ± 0.4% | not timed | not timed | 8248.85 ± 3.1% | | 0.99 | 1.47 | 256.33 |
| imported/leipzig/word-ending-nn | 262 | 608.91 ± 0.2% | not timed | not timed | 616.90 ± 0.1% | 24.58 ± 0.6% | not timed | not timed | 611.29 ± 0.1% | | 1.00 | 0.99 | 24.78 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11026.05 ± 1.6% | not timed | not timed | 4477.25 ± 0.8% | 11.51 ± 0.2% | not timed | not timed | 10989.34 ± 1.6% | | 1.00 | 2.46 | 958.31 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7692.87 ± 25.6% | not timed | not timed | 5391.78 ± 23.3% | 16.84 ± 0.1% | not timed | not timed | 7714.38 ± 26.0% | | 1.00 | 1.43 | 456.85 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4186.11 ± 1.9% | not timed | not timed | 417.08 ± 1.0% | 11.08 ± 0.2% | not timed | not timed | 4176.05 ± 1.7% | | 1.00 | 10.04 | 377.92 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 610.01 ± 0.2% | not timed | not timed | 615.34 ± 0.0% | 11.12 ± 0.1% | not timed | not timed | 609.51 ± 0.1% | | 1.00 | 0.99 | 54.84 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.68 ± 0.1% | not timed | not timed | 616.01 ± 0.0% | 9.62 ± 0.1% | not timed | not timed | 610.31 ± 0.1% | | 1.00 | 0.99 | 63.38 |
| imported/leipzig/tom-river | 2 | 6426.11 ± 2.8% | not timed | not timed | 5095.30 ± 0.5% | 30.90 ± 0.1% | not timed | not timed | 6463.22 ± 1.4% | | 0.99 | 1.26 | 207.99 |
| imported/leipzig/ing | 78424 | 609.11 ± 0.4% | not timed | not timed | 571.51 ± 0.2% | 28.11 ± 3.4% | not timed | not timed | 606.97 ± 0.5% | | 1.00 | 1.07 | 21.67 |
| imported/leipzig/ing-whitespace | 55248 | 757.54 ± 0.7% | not timed | not timed | 2069.09 ± 0.7% | 20.56 ± 2.9% | not timed | not timed | 757.54 ± 0.2% | | 1.00 | 0.37 | 36.84 |
| imported/leipzig/awyer-inn | 209 | 774.71 ± 1.5% | not timed | not timed | 4228.14 ± 1.4% | 22.56 ± 0.1% | not timed | not timed | 775.16 ± 1.0% | | 1.00 | 0.18 | 34.35 |
| imported/leipzig/quotes-bounded | 8886 | 2115.98 ± 0.9% | not timed | not timed | 2965.73 ± 0.2% | 38.23 ± 0.2% | not timed | not timed | 2109.06 ± 0.3% | | 1.00 | 0.71 | 55.35 |
| imported/leipzig/non-ascii-alternate | 2 | 12569.07 ± 1.9% | not timed | not timed | 5622.43 ± 0.8% | 50.47 ± 0.1% | not timed | not timed | 12655.55 ± 2.3% | | 0.99 | 2.24 | 249.04 |
| imported/leipzig/math-symbols | 69 | 1972.42 ± 0.5% | not timed | not timed | 618.18 ± 0.3% | 36.64 ± 0.2% | not timed | not timed | 1974.26 ± 0.3% | | 1.00 | 3.19 | 53.84 |
| imported/leipzig/bounded-strings-ending-z | 0 | 593.06 ± 0.3% | not timed | not timed | 617.99 ± 0.1% | 22.54 ± 0.1% | not timed | not timed | 594.83 ± 0.5% | | 1.00 | 0.96 | 26.32 |
| imported/lh3lh3-reb/uri | 17549 | 633.12 ± 0.0% | not timed | not timed | 1046.31 ± 0.2% | 28.26 ± 2.6% | not timed | not timed | 632.30 ± 0.1% | | 1.00 | 0.61 | 22.40 |
| imported/lh3lh3-reb/email | 15057 | 668.11 ± 0.1% | not timed | not timed | 1143.91 ± 0.3% | 30.02 ± 5.0% | not timed | not timed | 668.75 ± 0.1% | | 1.00 | 0.58 | 22.25 |
| imported/lh3lh3-reb/date | 668 | 863.18 ± 0.2% | not timed | not timed | 1017.78 ± 0.6% | 50.08 ± 3.8% | not timed | not timed | 864.37 ± 0.2% | | 1.00 | 0.85 | 17.24 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 641.95 ± 0.1% | not timed | not timed | 423.09 ± 0.2% | 15.64 ± 4.3% | not timed | not timed | 642.23 ± 0.1% | | 1.00 | 1.52 | 41.05 |
| imported/mariomka/email | 92 | 705.61 ± 0.1% | not timed | not timed | 29462.68 ± 0.6% | 32.86 ± 0.1% | not timed | not timed | 706.41 ± 0.1% | | 1.00 | 0.0239 | 21.47 |
| imported/mariomka/uri | 5301 | 608.04 ± 0.1% | not timed | not timed | 5672.41 ± 2.2% | 32.70 ± 0.8% | not timed | not timed | 605.38 ± 0.1% | | 1.00 | 0.11 | 18.59 |
| imported/mariomka/ip | 5 | 2149.44 ± 2.3% | not timed | not timed | 2927.74 ± 0.6% | 21.08 ± 0.3% | not timed | not timed | 2145.51 ± 2.1% | | 1.00 | 0.73 | 101.99 |
| imported/rsc/no-exponential | 0 | 569.90 ± 0.2% | not timed | not timed | 322.25 ± 0.1% | 23.86 ± 0.1% | not timed | not timed | 569.38 ± 0.1% | | 1.00 | 1.77 | 23.89 |
| imported/rsc/literal | 1 | 744.83 ± 2.6% | not timed | not timed | 1610.32 ± 2.8% | 183.72 ± 39.6% | not timed | not timed | 744.17 ± 6.1% | | 1.00 | 0.46 | 4.05 |
| imported/rsc/not-literal | 2 | 708.32 ± 0.1% | not timed | not timed | 721.25 ± 0.4% | 46.47 ± 3.4% | not timed | not timed | 708.47 ± 8.1% | | 1.00 | 0.98 | 15.24 |
| imported/rsc/match-class | 1 | 1300.98 ± 0.2% | not timed | not timed | 1639.19 ± 0.2% | 58.66 ± 14.2% | not timed | not timed | 1303.57 ± 2.0% | | 1.00 | 0.79 | 22.18 |
| imported/rsc/match-class-in-range | 1 | 1306.75 ± 0.6% | not timed | not timed | 2380.45 ± 1.1% | 60.26 ± 7.3% | not timed | not timed | 1304.51 ± 2.3% | | 1.00 | 0.55 | 21.69 |
| imported/rsc/match-class-unicode | 1 | 525.28 ± 0.1% | not timed | not timed | 514.88 ± 0.0% | 72.91 ± 0.6% | not timed | not timed | 524.34 ± 0.1% | | 1.00 | 1.02 | 7.20 |
| imported/rsc/anchored-literal-short-non-match | 0 | 538.89 ± 1.1% | not timed | not timed | 944.88 ± 0.1% | 226.40 ± 1.1% | not timed | not timed | 539.09 ± 0.6% | | 1.00 | 0.57 | 2.38 |
| imported/rsc/anchored-literal-long-non-match | 0 | 8019.61 ± 0.1% | not timed | not timed | 14296.36 ± 0.2% | 3407.49 ± 0.6% | not timed | not timed | 8030.86 ± 0.1% | | 1.00 | 0.56 | 2.35 |
| imported/rsc/anchored-literal-short-match | 4 | 420.83 ± 1.6% | not timed | not timed | 481.78 ± 0.1% | 82.04 ± 6.9% | not timed | not timed | 422.58 ± 7.1% | | 1.00 | 0.87 | 5.13 |
| imported/rsc/anchored-literal-long-match | 4 | 3024.94 ± 2.5% | not timed | not timed | 7293.07 ± 0.1% | 1245.90 ± 11.3% | not timed | not timed | 3027.35 ± 3.9% | | 1.00 | 0.41 | 2.43 |
| imported/rsc/one-pass-short | 17 | 304.95 ± 7.8% | not timed | not timed | 212.39 ± 0.1% | 30.64 ± 10.2% | not timed | not timed | 308.02 ± 0.2% | | 0.99 | 1.44 | 9.95 |
| imported/rsc/one-pass-short-not | 17 | 219.58 ± 1.5% | not timed | not timed | 223.15 ± 0.2% | 30.03 ± 8.1% | not timed | not timed | 220.22 ± 5.4% | | 1.00 | 0.98 | 7.31 |
| imported/rsc/one-pass-long-prefix | 26 | 235.64 ± 8.5% | not timed | not timed | 282.39 ± 0.3% | 96.51 ± 16.5% | not timed | not timed | 238.64 ± 2.7% | | 0.99 | 0.83 | 2.44 |
| imported/rsc/one-pass-long-prefix-not | 26 | 313.43 ± 1.8% | not timed | not timed | 281.06 ± 0.2% | 65.32 ± 18.0% | not timed | not timed | 311.70 ± 1.8% | | 1.01 | 1.12 | 4.80 |
| imported/rsc/long-needle1 | 31 | 21906.40 ± 0.1% | not timed | not timed | 20156.69 ± 0.0% | 3.77 ± 0.1% | not timed | not timed | 21926.29 ± 0.1% | | 1.00 | 1.09 | 5811.64 |
| imported/rsc/long-needle2 | 31 | 22098.31 ± 0.2% | not timed | not timed | 216.23 ± 0.1% | 3.77 ± 0.1% | not timed | not timed | 22107.57 ± 0.1% | | 1.00 | 102.20 | 5858.86 |
| imported/rsc/easy0-32 | 26 | 1063.39 ± 2.8% | not timed | not timed | 1599.28 ± 0.6% | 148.55 ± 13.5% | not timed | not timed | 1062.86 ± 2.1% | | 1.00 | 0.66 | 7.16 |
| imported/rsc/easy0-1k | 26 | 14963.32 ± 2.4% | not timed | not timed | 12526.49 ± 0.4% | 2288.97 ± 13.7% | not timed | not timed | 14936.92 ± 1.6% | | 1.00 | 1.19 | 6.54 |
| imported/rsc/easy0-32k | 26 | 22898.67 ± 1.6% | not timed | not timed | 20389.17 ± 0.2% | 18839.84 ± 26.1% | not timed | not timed | 22909.24 ± 0.1% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21465.82 ± 0.7% | not timed | not timed | 19634.51 ± 2.2% | 35571.56 ± 1.7% | not timed | not timed | 21212.13 ± 1.7% | | 1.01 | 1.09 | 0.60 |
| imported/rsc/easy1-32 | 19 | 359.73 ± 1.6% | not timed | not timed | 638.80 ± 0.6% | 131.45 ± 15.0% | not timed | not timed | 359.85 ± 2.2% | | 1.00 | 0.56 | 2.74 |
| imported/rsc/easy1-1k | 19 | 585.45 ± 0.3% | not timed | not timed | 12922.86 ± 0.2% | 2485.16 ± 13.4% | not timed | not timed | 581.76 ± 2.7% | | 1.01 | 0.0453 | 0.24 |
| imported/rsc/easy1-32k | 19 | 603.63 ± 3.2% | not timed | not timed | 402136.07 ± 0.5% | 20535.55 ± 32.5% | not timed | not timed | 601.68 ± 0.4% | | 1.00 | 0.0015 | 0.0294 |
| imported/rsc/easy1-1mb | 19 | 604.54 ± 0.5% | not timed | not timed | 12768550.94 ± 0.1% | 38699.48 ± 2.6% | not timed | not timed | 602.29 ± 0.4% | | 1.00 | 0.0000 | 0.0156 |
| imported/rsc/medium-32 | 27 | 428.25 ± 0.5% | not timed | not timed | 623.11 ± 0.2% | 70.22 ± 13.7% | not timed | not timed | 427.04 ± 2.1% | | 1.00 | 0.69 | 6.10 |
| imported/rsc/medium-1k | 27 | 6811.41 ± 0.1% | not timed | not timed | 11329.44 ± 0.4% | 72.60 ± 0.1% | not timed | not timed | 6774.17 ± 0.3% | | 1.01 | 0.60 | 93.82 |
| imported/rsc/medium-32k | 27 | 21499.66 ± 0.1% | not timed | not timed | 353569.97 ± 0.3% | 48.64 ± 0.1% | not timed | not timed | 21404.25 ± 0.1% | | 1.00 | 0.0608 | 442.04 |
| imported/rsc/medium-1mb | 27 | 21289.33 ± 1.4% | not timed | not timed | 11212675.31 ± 0.2% | 48.63 ± 0.2% | not timed | not timed | 21160.73 ± 3.2% | | 1.01 | 0.0019 | 437.81 |
| imported/rsc/hard-32 | 58 | 255.44 ± 0.2% | not timed | not timed | 365.18 ± 0.1% | 49.58 ± 8.9% | not timed | not timed | 255.98 ± 3.0% | | 1.00 | 0.70 | 5.15 |
| imported/rsc/hard-1k | 27 | 577.17 ± 0.2% | not timed | not timed | 11410.94 ± 0.3% | 40.64 ± 10.9% | not timed | not timed | 574.69 ± 0.3% | | 1.00 | 0.0506 | 14.20 |
| imported/rsc/hard-32k | 27 | 601.99 ± 0.2% | not timed | not timed | 359814.20 ± 0.1% | 29.38 ± 0.0% | not timed | not timed | 600.29 ± 0.2% | | 1.00 | 0.0017 | 20.49 |
| imported/rsc/hard-1mb | 51 | 603.07 ± 0.2% | not timed | not timed | 7258374.13 ± 0.2% | 29.33 ± 0.2% | not timed | not timed | 600.56 ± 0.4% | | 1.00 | 0.0001 | 20.56 |
| imported/rsc/reallyhard0-32 | 58 | 254.02 ± 0.2% | not timed | not timed | 222.97 ± 0.1% | 49.75 ± 1.9% | not timed | not timed | 254.93 ± 8.3% | | 1.00 | 1.14 | 5.11 |
| imported/rsc/reallyhard0-1k | 27 | 576.65 ± 0.1% | not timed | not timed | 583.15 ± 0.6% | 40.94 ± 0.1% | not timed | not timed | 581.21 ± 0.2% | | 0.99 | 0.99 | 14.08 |
| imported/rsc/reallyhard0-32k | 27 | 600.08 ± 0.2% | not timed | not timed | 618.75 ± 0.1% | 29.35 ± 0.1% | not timed | not timed | 603.54 ± 0.7% | | 0.99 | 0.97 | 20.45 |
| imported/rsc/reallyhard0-1mb | 51 | 591.49 ± 0.4% | not timed | not timed | 613.25 ± 0.1% | 29.39 ± 0.1% | not timed | not timed | 595.28 ± 0.5% | | 0.99 | 0.96 | 20.13 |
| imported/rsc/reallyreallyhard0-32 | 47 | 274.30 ± 0.1% | not timed | not timed | 195.52 ± 0.7% | 60.15 ± 5.0% | not timed | not timed | 273.85 ± 5.4% | | 1.00 | 1.40 | 4.56 |
| imported/rsc/reallyreallyhard0-1k | 16 | 884.37 ± 3.6% | not timed | not timed | 5916.58 ± 0.0% | 34.51 ± 0.8% | not timed | not timed | 877.07 ± 3.4% | | 1.01 | 0.15 | 25.62 |
| imported/rsc/reallyreallyhard0-32k | 16 | 625.28 ± 6.2% | not timed | not timed | 19350.73 ± 0.1% | 24.64 ± 1.4% | not timed | not timed | 628.85 ± 4.6% | | 0.99 | 0.0323 | 25.38 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 590.38 ± 0.5% | not timed | not timed | 19952.97 ± 1.4% | 25.06 ± 0.9% | not timed | not timed | 595.42 ± 0.3% | | 0.99 | 0.0296 | 23.56 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 269.48 ± 0.3% | not timed | not timed | 211.17 ± 0.2% | 61.04 ± 1.6% | not timed | not timed | 268.91 ± 11.8% | | 1.00 | 1.28 | 4.41 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 872.12 ± 3.8% | not timed | not timed | 6139.68 ± 0.1% | 34.03 ± 0.1% | not timed | not timed | 871.19 ± 0.7% | | 1.00 | 0.14 | 25.63 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 627.74 ± 4.2% | not timed | not timed | 19105.80 ± 0.2% | 24.89 ± 1.0% | not timed | not timed | 626.45 ± 4.7% | | 1.00 | 0.0329 | 25.22 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 592.64 ± 0.2% | not timed | not timed | 19404.80 ± 2.2% | 25.15 ± 1.3% | not timed | not timed | 594.48 ± 0.4% | | 1.00 | 0.0305 | 23.56 |
| imported/sherlock/name-sherlock | 776 | 19685.99 ± 2.2% | not timed | not timed | 18441.54 ± 0.6% | 10144.37 ± 29.9% | not timed | not timed | 19718.37 ± 2.5% | | 1.00 | 1.07 | 1.94 |
| imported/sherlock/name-holmes | 2766 | 15070.12 ± 1.3% | not timed | not timed | 15421.78 ± 0.5% | 3094.03 ± 2.3% | not timed | not timed | 15225.46 ± 1.5% | | 0.99 | 0.98 | 4.87 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19668.78 ± 2.1% | not timed | not timed | 18434.05 ± 0.5% | 8075.83 ± 48.1% | not timed | not timed | 19730.12 ± 2.4% | | 1.00 | 1.07 | 2.44 |
| imported/sherlock/name-sherlock-casei | 816 | 15679.25 ± 0.4% | not timed | not timed | 4013.30 ± 0.1% | 32.52 ± 0.2% | not timed | not timed | 15681.26 ± 0.5% | | 1.00 | 3.91 | 482.19 |
| imported/sherlock/name-holmes-casei | 2802 | 9343.67 ± 6.3% | not timed | not timed | 3322.26 ± 0.1% | 37.60 ± 0.1% | not timed | not timed | 9337.06 ± 6.3% | | 1.00 | 2.81 | 248.50 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12952.21 ± 7.4% | not timed | not timed | 3953.16 ± 0.1% | 32.51 ± 0.3% | not timed | not timed | 12952.71 ± 1.0% | | 1.00 | 3.28 | 398.43 |
| imported/sherlock/name-whitespace | 1461 | 15058.69 ± 1.7% | not timed | not timed | 14427.02 ± 0.2% | 6571.78 ± 18.3% | not timed | not timed | 15101.86 ± 1.9% | | 1.00 | 1.04 | 2.29 |
| imported/sherlock/name-alt1 | 1142 | 11498.70 ± 0.6% | not timed | not timed | 16213.61 ± 0.7% | 4134.73 ± 23.6% | not timed | not timed | 11498.14 ± 2.4% | | 1.00 | 0.71 | 2.78 |
| imported/sherlock/name-alt2 | 3542 | 8647.60 ± 0.3% | not timed | not timed | 3827.08 ± 0.1% | 31.39 ± 0.1% | not timed | not timed | 8635.15 ± 0.4% | | 1.00 | 2.26 | 275.53 |
| imported/sherlock/name-alt3 | 4507 | 5453.96 ± 0.3% | not timed | not timed | 3628.88 ± 0.1% | 9.96 ± 2.0% | not timed | not timed | 5448.85 ± 0.3% | | 1.00 | 1.50 | 547.44 |
| imported/sherlock/name-alt3-casei | 4593 | 1520.21 ± 2.5% | not timed | not timed | 286.11 ± 0.3% | 6.48 ± 0.1% | not timed | not timed | 1518.86 ± 1.1% | | 1.00 | 5.31 | 234.56 |
| imported/sherlock/name-alt4 | 3686 | 6178.55 ± 0.2% | not timed | not timed | 3789.00 ± 0.1% | 31.21 ± 0.1% | not timed | not timed | 6187.35 ± 0.2% | | 1.00 | 1.63 | 197.99 |
| imported/sherlock/name-alt4-casei | 4254 | 2775.81 ± 2.7% | not timed | not timed | 2600.67 ± 0.1% | 19.90 ± 0.1% | not timed | not timed | 2773.03 ± 1.2% | | 1.00 | 1.07 | 139.47 |
| imported/sherlock/name-alt5 | 4028 | 6241.36 ± 0.4% | not timed | not timed | 3743.79 ± 0.1% | 21.77 ± 0.1% | not timed | not timed | 6240.38 ± 0.3% | | 1.00 | 1.67 | 286.69 |
| imported/sherlock/name-alt5-casei | 4104 | 3470.50 ± 2.7% | not timed | not timed | 2230.68 ± 0.1% | 14.37 ± 0.1% | not timed | not timed | 3466.88 ± 1.1% | | 1.00 | 1.56 | 241.59 |
| imported/sherlock/no-match-uncommon | 0 | 21423.01 ± 0.6% | not timed | not timed | 19419.12 ± 0.9% | 35795.16 ± 0.3% | not timed | not timed | 21439.09 ± 0.8% | | 1.00 | 1.10 | 0.60 |
| imported/sherlock/no-match-common | 0 | 21179.02 ± 0.5% | not timed | not timed | 19356.98 ± 0.8% | 1270.02 ± 0.4% | not timed | not timed | 21247.47 ± 0.5% | | 1.00 | 1.09 | 16.68 |
| imported/sherlock/no-match-really-common | 0 | 16022.18 ± 2.8% | not timed | not timed | 18661.63 ± 0.9% | 1267.84 ± 0.2% | not timed | not timed | 16159.00 ± 1.7% | | 0.99 | 0.86 | 12.64 |
| imported/sherlock/the-lower | 21654 | 2305.59 ± 1.1% | not timed | not timed | 2332.04 ± 0.8% | 236.50 ± 13.8% | not timed | not timed | 2321.99 ± 1.7% | | 0.99 | 0.99 | 9.75 |
| imported/sherlock/the-upper | 2223 | 12688.61 ± 1.0% | not timed | not timed | 13487.14 ± 0.3% | 2752.85 ± 14.4% | not timed | not timed | 12732.50 ± 1.5% | | 1.00 | 0.94 | 4.61 |
| imported/sherlock/the-casei | 23961 | 2009.86 ± 0.7% | not timed | not timed | 1314.50 ± 0.2% | 34.79 ± 27.0% | not timed | not timed | 2013.10 ± 1.5% | | 1.00 | 1.53 | 57.78 |
| imported/sherlock/everything-greedy | 581881 | 270.95 ± 0.8% | not timed | not timed | 164.16 ± 0.1% | 29.02 ± 34.4% | not timed | not timed | 270.39 ± 1.2% | | 1.00 | 1.65 | 9.34 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.19 ± 0.1% | not timed | not timed | 213.61 ± 0.1% | 32.88 ± 0.1% | not timed | not timed | 463.20 ± 0.3% | | 1.00 | 2.16 | 14.06 |
| imported/sherlock/letters | 447175 | 54.47 ± 0.5% | not timed | not timed | 33.14 ± 0.3% | 6.58 ± 2.8% | not timed | not timed | 54.47 ± 0.4% | | 1.00 | 1.64 | 8.28 |
| imported/sherlock/letters-upper | 14180 | 433.28 ± 1.2% | not timed | not timed | 369.25 ± 0.2% | 29.52 ± 22.3% | not timed | not timed | 433.84 ± 0.1% | | 1.00 | 1.17 | 14.68 |
| imported/sherlock/letters-lower | 432995 | 55.14 ± 1.0% | not timed | not timed | 33.87 ± 0.1% | 5.63 ± 27.3% | not timed | not timed | 55.45 ± 1.4% | | 0.99 | 1.63 | 9.79 |
| imported/sherlock/words | 447639 | 106.48 ± 0.8% | not timed | not timed | 82.51 ± 0.1% | 13.58 ± 5.5% | not timed | not timed | 106.75 ± 6.5% | | 1.00 | 1.29 | 7.84 |
| imported/sherlock/before-holmes | 4073 | 599.43 ± 0.3% | not timed | not timed | 8470.49 ± 0.2% | 23.70 ± 2.7% | not timed | not timed | 597.06 ± 0.2% | | 1.00 | 0.0708 | 25.30 |
| imported/sherlock/before-after-holmes | 2593 | 597.40 ± 0.2% | not timed | not timed | 9431.70 ± 0.2% | 24.01 ± 0.9% | not timed | not timed | 598.27 ± 0.1% | | 1.00 | 0.0633 | 24.88 |
| imported/sherlock/holmes-cochar-watson | 150 | 5225.37 ± 0.2% | not timed | not timed | 3428.09 ± 0.1% | 31.03 ± 0.1% | not timed | not timed | 5235.36 ± 0.2% | | 1.00 | 1.52 | 168.40 |
| imported/sherlock/holmes-coword-watson | 14309 | 1197.85 ± 6.0% | not timed | not timed | 1124.98 ± 0.2% | 6.80 ± 0.2% | not timed | not timed | 1264.96 ± 5.6% | | 0.95 | 1.06 | 176.17 |
| imported/sherlock/quotes | 14437 | 1404.73 ± 0.2% | not timed | not timed | 1754.38 ± 0.8% | 35.17 ± 0.3% | not timed | not timed | 1412.10 ± 0.2% | | 0.99 | 0.80 | 39.94 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 602.13 ± 0.4% | not timed | not timed | 15990.90 ± 0.4% | 36.85 ± 0.1% | not timed | not timed | 602.59 ± 0.1% | | 1.00 | 0.0377 | 16.34 |
| imported/sherlock/word-ending-n | 35297 | 468.32 ± 0.2% | not timed | not timed | 409.66 ± 0.2% | 23.56 ± 17.9% | not timed | not timed | 466.68 ± 1.0% | | 1.00 | 1.14 | 19.88 |
| imported/sherlock/repeated-class-negation | 2130 | 14628.20 ± 0.8% | not timed | not timed | 10841.70 ± 0.9% | 11.59 ± 0.1% | not timed | not timed | 14642.82 ± 1.0% | | 1.00 | 1.35 | 1262.20 |
| imported/sherlock/ing-suffix | 20547 | 554.98 ± 0.2% | not timed | not timed | 516.96 ± 0.1% | 28.88 ± 0.1% | not timed | not timed | 554.23 ± 0.3% | | 1.00 | 1.07 | 19.22 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 594.63 ± 0.3% | not timed | not timed | 2090.79 ± 0.3% | 20.55 ± 0.2% | not timed | not timed | 595.32 ± 0.4% | | 1.00 | 0.28 | 28.94 |
| opt/accelerate/whole-line | 239963 | 458.80 ± 0.4% | not timed | not timed | 373.33 ± 0.2% | 92.92 ± 12.6% | not timed | not timed | 458.74 ± 0.1% | | 1.00 | 1.23 | 4.94 |
| opt/accelerate/non-dna | 16745 | 413.40 ± 3.2% | not timed | not timed | 399.63 ± 0.1% | 29.48 ± 53.5% | not timed | not timed | 412.00 ± 1.7% | | 1.00 | 1.03 | 14.02 |
| opt/backtrack/words-english | 40536 | 136.32 ± 2.5% | not timed | not timed | 94.21 ± 0.1% | 19.73 ± 7.7% | not timed | not timed | 134.65 ± 0.2% | | 1.01 | 1.45 | 6.91 |
| opt/fixed-length/too-small-ascii | 0 | 312.36 ± 0.2% | not timed | not timed | 701.50 ± 0.7% | 79.60 ± 0.5% | not timed | not timed | 310.06 ± 0.1% | | 1.01 | 0.45 | 3.92 |
| opt/fixed-length/too-big-ascii | 0 | 648.58 ± 0.2% | not timed | not timed | 5826.36 ± 0.1% | 124.89 ± 0.4% | not timed | not timed | 655.10 ± 0.4% | | 0.99 | 0.11 | 5.19 |
| opt/fixed-length/go33484-1 | 0 | 45.03 ± 0.2% | not timed | not timed | 1106282.57 ± 0.2% | 61410.37 ± 0.4% | not timed | not timed | 44.97 ± 0.1% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5531.84 ± 0.1% | not timed | not timed | 1118755.54 ± 0.2% | 32190.23 ± 2.8% | not timed | not timed | 5524.33 ± 0.1% | | 1.00 | 0.0049 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1808.19 ± 0.8% | not timed | not timed | 112014.23 ± 0.2% | 755.03 ± 0.3% | not timed | not timed | 1735.94 ± 0.3% | | 1.04 | 0.0161 | 2.39 |
| opt/literal-alt/one-pattern | 1 | 553.47 ± 0.2% | not timed | not timed | 545.24 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 552.38 ± 0.8% | | 1.00 | 1.02 | 1382.86 |
| opt/onepass/fn-predicate | 916 | 366.14 ± 0.7% | not timed | not timed | 334.89 ± 0.1% | 195.67 ± 13.4% | not timed | not timed | 368.79 ± 1.0% | | 0.99 | 1.09 | 1.87 |
| opt/onepass/first-three-words-english | 35128 | 148.50 ± 2.7% | not timed | not timed | 197.84 ± 0.2% | 76.39 ± 12.3% | not timed | not timed | 149.91 ± 4.1% | | 0.99 | 0.75 | 1.94 |
| opt/prefilter/literal-english | 1 | 20397.62 ± 0.2% | not timed | not timed | 19640.14 ± 0.4% | 17296.52 ± 0.4% | not timed | not timed | 20435.09 ± 0.7% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14398.24 ± 0.4% | not timed | not timed | 4315.60 ± 0.2% | 32.63 ± 0.2% | not timed | not timed | 14422.91 ± 0.4% | | 1.00 | 3.34 | 441.22 |
| opt/prefilter/literal-russian | 1 | 20905.74 ± 0.3% | not timed | not timed | 19730.87 ± 0.7% | 3323.55 ± 0.2% | not timed | not timed | 20951.91 ± 0.6% | | 1.00 | 1.06 | 6.29 |
| opt/prefilter/literal-casei-russian | 1 | 8593.38 ± 0.2% | not timed | not timed | 3890.30 ± 0.1% | 30.98 ± 0.2% | not timed | not timed | 8589.28 ± 0.2% | | 1.00 | 2.21 | 277.37 |
| opt/prefilter/rust-functions | 948 | 6677.71 ± 13.6% | not timed | not timed | 8810.92 ± 1.2% | 1856.85 ± 0.5% | not timed | not timed | 6681.37 ± 1.6% | | 1.00 | 0.76 | 3.60 |
| opt/reverse-anchored/word-end | 1 | 5590.68 ± 0.2% | not timed | not timed | 21098364.42 ± 0.2% | 50.12 ± 0.5% | not timed | not timed | 5595.81 ± 0.1% | | 1.00 | 0.0003 | 111.55 |
| opt/reverse-inner/holmes | 2593 | 596.92 ± 0.4% | not timed | not timed | 9389.60 ± 0.8% | 23.80 ± 1.9% | not timed | not timed | 598.01 ± 0.2% | | 1.00 | 0.0636 | 25.08 |
| opt/reverse-inner/email | 47 | 1044.88 ± 0.1% | not timed | not timed | 43781.46 ± 1.7% | 32.30 ± 0.5% | not timed | not timed | 1044.12 ± 0.1% | | 1.00 | 0.0239 | 32.35 |
| opt/reverse-inner/factored-prefix | 3542 | 591.44 ± 0.2% | not timed | not timed | 595.02 ± 0.1% | 11.98 ± 0.2% | not timed | not timed | 566.19 ± 0.2% | | 1.04 | 0.99 | 49.38 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5510.94 ± 0.1% | not timed | not timed | 617.10 ± 0.6% | 75.27 ± 0.1% | not timed | not timed | 5521.79 ± 0.0% | | 1.00 | 8.93 | 73.22 |
| opt/reverse-inner/no-quadratic-forward | 0 | 688.57 ± 1.5% | not timed | not timed | 288.17 ± 0.4% | 24.82 ± 0.1% | not timed | not timed | 689.60 ± 1.8% | | 1.00 | 2.39 | 27.75 |
| opt/reverse-suffix/holmes | 4073 | 599.71 ± 0.4% | not timed | not timed | 8446.11 ± 0.5% | 23.81 ± 0.8% | not timed | not timed | 597.72 ± 0.2% | | 1.00 | 0.0710 | 25.19 |
| opt/reverse-suffix/no-quadratic | 0 | 5520.43 ± 0.3% | not timed | not timed | 616.59 ± 0.5% | 75.21 ± 0.1% | not timed | not timed | 5507.13 ± 0.1% | | 1.00 | 8.95 | 73.40 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.46 ± 2.6% | not timed | not timed | 133.14 ± 0.1% | 13.54 ± 15.4% | not timed | not timed | 121.54 ± 2.1% | | 1.00 | 0.91 | 8.97 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.76 ± 0.2% | not timed | not timed | 135.71 ± 0.2% | 14.66 ± 12.8% | not timed | not timed | 120.84 ± 9.2% | | 1.00 | 0.89 | 8.24 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 3.2% | not timed | not timed | 0.55 ± 0.4% | 113.17 ± 7.9% | not timed | not timed | 0.28 ± 0.3% | | 1.00 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 316.98 ± 0.3% | not timed | not timed | 294.72 ± 0.1% | 94.67 ± 9.7% | not timed | not timed | 309.67 ± 0.2% | | 1.02 | 1.08 | 3.35 |
| reported/i13-subset-regex/original-ascii | 4094 | 10945.73 ± 3.0% | not timed | not timed | 4441.85 ± 2.3% | 11.51 ± 0.1% | not timed | not timed | 10806.89 ± 2.3% | | 1.01 | 2.46 | 950.66 |
| reported/i13-subset-regex/original-unicode | 4094 | 10688.44 ± 3.0% | not timed | not timed | 249.92 ± 3.3% | 11.52 ± 0.2% | not timed | not timed | 10818.97 ± 1.5% | | 0.99 | 42.77 | 927.74 |
| reported/i13-subset-regex/big-ascii | 1955 | 10360.91 ± 18.3% | not timed | not timed | 68.08 ± 3.7% | 9.85 ± 1.2% | not timed | not timed | 10430.00 ± 2.0% | | 0.99 | 152.19 | 1051.52 |
| reported/i13-subset-regex/big-unicode | 1955 | 10279.13 ± 1.9% | not timed | not timed | 12.25 ± 54.9% | 9.87 ± 0.2% | not timed | not timed | 10493.96 ± 18.4% | | 0.98 | 839.33 | 1041.88 |
| reported/i13-subset-regex/huge-ascii | 55 | 9793.27 ± 3.3% | not timed | not timed | 11.04 ± 0.1% | 8.76 ± 0.1% | not timed | not timed | 9834.02 ± 3.6% | | 1.00 | 886.69 | 1117.70 |
| reported/i13-subset-regex/huge-unicode | 55 | 9694.55 ± 3.9% | not timed | not timed | 11.01 ± 0.4% | 8.77 ± 0.2% | not timed | not timed | 9755.87 ± 4.8% | | 0.99 | 880.16 | 1105.36 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.0% | not timed | not timed | 11.04 ± 0.1% | 8.73 ± 1.2% | not timed | not timed | 3.54 ± 0.0% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.04 ± 0.1% | not timed | not timed | 11.02 ± 0.3% | 8.77 ± 0.4% | not timed | not timed | 5.03 ± 0.0% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 469.94 ± 0.3% | not timed | not timed | 104.11 ± 0.1% | 6.61 ± 0.3% | not timed | not timed | 470.22 ± 0.4% | | 1.00 | 4.51 | 71.08 |
| reported/i787-keywords/opt-ascii | 5674 | 470.83 ± 0.4% | not timed | not timed | 270.75 ± 0.2% | 10.18 ± 0.2% | not timed | not timed | 470.70 ± 0.4% | | 1.00 | 1.74 | 46.25 |
| slow/quadratic-regex-1x | 100 | 6.96 ± 0.3% | not timed | not timed | 4.99 ± 0.4% | 0.05 ± 0.2% | not timed | not timed | 6.96 ± 0.2% | | 1.00 | 1.39 | 140.87 |
| slow/quadratic-regex-2x | 199 | 3.40 ± 0.2% | not timed | not timed | 2.77 ± 0.1% | 0.01 ± 0.1% | not timed | not timed | 3.41 ± 0.1% | | 1.00 | 1.23 | 266.43 |
| slow/quadratic-haystack-1x | 100 | 21.15 ± 3.0% | not timed | not timed | 10.02 ± 0.2% | 1.02 ± 9.0% | not timed | not timed | 21.18 ± 5.2% | | 1.00 | 2.11 | 20.84 |
| slow/quadratic-haystack-2x | 200 | 17.37 ± 9.0% | not timed | not timed | 5.55 ± 0.0% | 0.55 ± 7.3% | not timed | not timed | 17.43 ± 1.7% | | 1.00 | 3.13 | 31.79 |
| unicode/codepoints/any-one | 1112064 | 286.43 ± 0.4% | not timed | not timed | 176.06 ± 0.3% | 18.28 ± 3.0% | not timed | not timed | 285.80 ± 0.4% | | 1.00 | 1.63 | 15.67 |
| unicode/codepoints/any-all | 4382592 | 290.01 ± 0.3% | not timed | not timed | 246.41 ± 0.1% | 117.21 ± 0.1% | not timed | not timed | 289.66 ± 0.6% | | 1.00 | 1.18 | 2.47 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.76 ± 0.8% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 610.63 ± 0.0% | not timed | not timed | 615.96 ± 0.7% | 135.25 ± 0.1% | not timed | not timed | 610.14 ± 0.7% | | 1.00 | 0.99 | 4.51 |
| unicode/overlapping-words/ascii | 6156 | 31.13 ± 0.2% | not timed | not timed | 38.91 ± 0.2% | 3.94 ± 1.2% | not timed | not timed | 31.19 ± 0.3% | | 1.00 | 0.80 | 7.91 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 0.2% | not timed | not timed | 2.99 ± 0.2% | 2.36 ± 0.3% | not timed | not timed | 1.36 ± 0.1% | | 1.00 | 0.45 | 0.57 |
| unicode/overlapping-words/russian | 5710 | 1.22 ± 9.7% | not timed | not timed | 2.86 ± 0.3% | 6.20 ± 10.3% | not timed | not timed | 1.22 ± 0.2% | | 1.00 | 0.43 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 116.73 ± 7.2% | not timed | not timed | 83.01 ± 0.5% | 11.63 ± 28.7% | not timed | not timed | 117.24 ± 0.6% | | 1.00 | 1.41 | 10.04 |
| unicode/word/boundary-long-english | 3466 | 607.02 ± 0.5% | not timed | not timed | 606.53 ± 0.1% | 31.18 ± 1.5% | not timed | not timed | 607.41 ± 0.2% | | 1.00 | 1.00 | 19.47 |
| unicode/word/around-holmes-english | 27 | 603.48 ± 0.5% | not timed | not timed | 19367.10 ± 0.9% | 22.05 ± 1.2% | not timed | not timed | 602.17 ± 0.3% | | 1.00 | 0.0312 | 27.37 |
| wild/bibleref/long | 874 | 565.00 ± 0.1% | not timed | not timed | 585.91 ± 0.1% | 6.73 ± 0.3% | not timed | not timed | 566.39 ± 0.1% | | 1.00 | 0.96 | 83.99 |
| wild/bibleref/short | 30 | 24.97 ± 1.0% | not timed | not timed | 31.39 ± 0.5% | 14.08 ± 9.7% | not timed | not timed | 25.64 ± 3.6% | | 0.97 | 0.80 | 1.77 |
| wild/bibleref/line | 874 | 357.20 ± 0.1% | not timed | not timed | 214.79 ± 0.0% | 9.11 ± 8.3% | not timed | not timed | 357.82 ± 3.2% | | 1.00 | 1.66 | 39.19 |
| wild/caddy/caddy | 6 | 418.10 ± 3.6% | not timed | not timed | 244.64 ± 0.0% | 68.16 ± 15.2% | not timed | not timed | 419.23 ± 0.9% | | 1.00 | 1.71 | 6.13 |
| wild/dot-star-capture/rust-src-tools | 6 | 1059.00 ± 0.2% | not timed | not timed | 344.14 ± 0.1% | 13.49 ± 0.0% | not timed | not timed | 1059.56 ± 0.2% | | 1.00 | 3.08 | 78.48 |
| wild/ruff/noqa | 84 | 404.21 ± 0.1% | not timed | not timed | 457.58 ± 0.3% | 19.56 ± 2.3% | not timed | not timed | 403.62 ± 1.7% | | 1.00 | 0.88 | 20.67 |
| wild/ruff/unnecessary-coding-comment | 16 | 489.34 ± 0.6% | not timed | not timed | 705.87 ± 0.2% | 133.49 ± 11.0% | not timed | not timed | 489.08 ± 0.6% | | 1.00 | 0.69 | 3.67 |
| wild/ruff/string-quote-prefix | 2972 | 406.07 ± 0.6% | not timed | not timed | 441.22 ± 0.4% | 316.05 ± 25.5% | not timed | not timed | 406.91 ± 0.6% | | 1.00 | 0.92 | 1.28 |
| wild/ruff/space-around-operator | 1224378 | 217.29 ± 1.8% | not timed | not timed | 186.12 ± 0.1% | 18.41 ± 2.0% | not timed | not timed | 217.62 ± 1.8% | | 1.00 | 1.17 | 11.80 |
| wild/ruff/shebang | 282 | 400.60 ± 0.5% | not timed | not timed | 324.57 ± 0.1% | 118.90 ± 9.8% | not timed | not timed | 401.35 ± 0.5% | | 1.00 | 1.23 | 3.37 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13823.72 ± 0.2% | not timed | not timed | 13841.43 ± 1.1% | 6921.68 ± 0.8% | not timed | not timed | 13809.42 ± 0.6% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12797.53 ± 0.4% | not timed | not timed | 13461.65 ± 0.5% | 6373.04 ± 0.8% | not timed | not timed | 12816.90 ± 0.3% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13158.88 ± 0.4% | not timed | not timed | 13583.13 ± 0.8% | 6610.88 ± 0.5% | not timed | not timed | 13129.28 ± 0.7% | | 1.00 | 0.97 | 1.99 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9509.61 ± 0.3% | not timed | not timed | 13517.94 ± 0.5% | 6701.96 ± 1.1% | not timed | not timed | 9538.29 ± 0.6% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 121.57 ± 13.9% | not timed | not timed | 65.41 ± 0.7% | 2.23 ± 0.6% | not timed | not timed | 121.38 ± 14.4% | | 1.00 | 1.86 | 54.62 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 1.7% | not timed | not timed | 0.01 ± 1.4% | 0.01 ± 23.7% | not timed | not timed | 0.03 ± 46.8% | | 1.00 | 3.13 | 4.10 |
| dictionary/compile/english-15 | 1 | 0.35 ± 23.7% | not timed | not timed | 0.07 ± 0.9% | 0.10 ± 13.6% | not timed | not timed | 0.35 ± 2.8% | | 0.99 | 5.12 | 3.34 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 1.3% | not timed | not timed | 0.02 ± 1.2% | 35.46 ± 12.5% | not timed | not timed | 0.25 ± 4.0% | | 0.96 | 12.84 | 0.0068 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.89 ± 2.1% | not timed | not timed | 11.56 ± 0.6% | 51.22 ± 20.7% | not timed | not timed | 47.73 ± 2.6% | | 0.98 | 4.06 | 0.92 |
| reported/i787-keywords/compile | 1 | 35.68 ± 4.4% | not timed | not timed | 2.14 ± 1.0% | 16.62 ± 34.7% | not timed | not timed | 35.71 ± 4.9% | | 1.00 | 16.68 | 2.15 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 365.23 ± 5.0% | not timed | not timed | 118.54 ± 0.3% | 576.78 ± 31.5% | not timed | not timed | 371.48 ± 2.2% | | 0.98 | 3.08 | 0.63 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.33 ± 1.9% | not timed | not timed | 4.12 ± 0.7% | 42.83 ± 7.1% | not timed | not timed | 48.00 ± 2.2% | | 0.99 | 11.49 | 1.10 |
| unicode/compile/one-letter | 53 | 6.78 ± 2.9% | not timed | not timed | 4.52 ± 1.4% | 65.19 ± 6.7% | not timed | not timed | 6.77 ± 13.9% | | 1.00 | 1.50 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.06 ± 14.9% | not timed | not timed | 0.10 ± 4.4% | 65.12 ± 23.4% | not timed | not timed | 1.10 ± 18.4% | | 0.96 | 10.69 | 0.0162 |
| unicode/compile/fifty-letters-ascii | 1 | 221.23 ± 9.2% | not timed | not timed | 52.80 ± 0.2% | 198.70 ± 17.7% | not timed | not timed | 223.73 ± 14.1% | | 0.99 | 4.19 | 1.11 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 389.97 ± 27.2% | not timed | not timed | 47.20 ± 0.3% | 708.07 ± 18.0% | not timed | not timed | 394.98 ± 10.4% | | 0.99 | 8.26 | 0.55 |
| unicode/compile/match-every-line-ascii | 4 | 627.43 ± 16.2% | not timed | not timed | 146.17 ± 0.8% | 656.23 ± 15.3% | not timed | not timed | 632.50 ± 19.4% | | 0.99 | 4.29 | 0.96 |
| unicode/compile/negated-class-matches-codepoint | 1 | 333.41 ± 10.0% | not timed | not timed | 51.52 ± 0.3% | 1089.69 ± 26.6% | not timed | not timed | 337.41 ± 7.9% | | 0.99 | 6.47 | 0.31 |
| wild/bibleref/compile | 3 | 5.69 ± 7.5% | not timed | not timed | 1.92 ± 0.8% | 32.58 ± 8.2% | not timed | not timed | 5.94 ± 19.2% | | 0.96 | 2.96 | 0.17 |
| wild/url/compile | 1 | 0.65 ± 17.0% | not timed | not timed | 0.14 ± 0.6% | 0.45 ± 29.9% | not timed | not timed | 0.66 ± 18.8% | | 0.99 | 4.52 | 1.47 |

