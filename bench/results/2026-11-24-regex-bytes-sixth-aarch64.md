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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391501799 |
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
| literal: a word | 217 | 19612.36 ± 0.9% | 5024.03 ± 0.3% | 28.14 ± 0.2% | 18291.93 ± 1.3% | 9034.55 ± 7.8% | 17.33 ± 1.5% | 84.19 ± 0.3% | 19500.60 ± 1.3% | 3.90 | 1.01 | 1.07 | 2.17 |
| literal: a word that is not there | 0 | 21493.13 ± 2.2% | 4908.98 ± 0.2% | 28.20 ± 0.3% | 19904.51 ± 1.9% | 29208.13 ± 0.4% | 17.12 ± 0.1% | 79.68 ± 0.5% | 21513.56 ± 0.9% | 4.38 | 1.00 | 1.08 | 0.74 |
| literal: one of four words | 661 | 6319.14 ± 0.3% | 1940.79 ± 0.1% | 14.35 ± 0.1% | 3928.78 ± 0.2% | 21.81 ± 0.1% | 5.43 ± 0.4% | 6.90 ± 0.4% | 6338.96 ± 0.7% | 3.26 | 1.00 | 1.61 | 289.69 |
| literal: a word in any case | 217 | 15056.38 ± 1.0% | 2083.40 ± 0.2% | 21.30 ± 0.2% | 3942.88 ± 0.4% | 37.87 ± 0.2% | refused | differs | 15104.32 ± 1.1% | 7.23 | 1.00 | 3.82 | 397.55 |
| literal: an href attribute | 33 | 16950.27 ± 0.7% | 607.59 ± 0.3% | 27.23 ± 0.2% | 16975.74 ± 0.6% | 2248.58 ± 0.8% | 13.14 ± 0.1% | 74.11 ± 0.2% | 17008.18 ± 0.6% | 27.90 | 1.00 | 1.00 | 7.54 |
| literal: a word, second text | 123 | 19840.43 ± 0.5% | 3381.68 ± 0.1% | 27.82 ± 0.2% | 18472.58 ± 0.7% | 7592.43 ± 7.7% | 20.13 ± 0.5% | 70.39 ± 0.4% | 19892.09 ± 1.0% | 5.87 | 1.00 | 1.07 | 2.61 |
| class: two capitalized words | 1331 | 1066.17 ± 0.5% | 597.39 ± 0.2% | 25.95 ± 0.2% | 584.46 ± 0.2% | 40.45 ± 17.7% | 14.73 ± 0.3% | 67.43 ± 0.3% | 1066.76 ± 0.4% | 1.78 | 1.00 | 1.82 | 26.36 |
| class: a word that ends in ing | 3399 | 571.79 ± 0.5% | 572.23 ± 0.4% | 17.96 ± 0.1% | 546.46 ± 0.3% | 29.57 ± 12.5% | 8.18 ± 0.2% | 18.39 ± 0.3% | 572.61 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.34 |
| class: a word in capitals | 2332 | 1374.38 ± 0.6% | 603.18 ± 0.1% | 27.55 ± 0.5% | 571.07 ± 0.2% | 43.49 ± 9.9% | 17.16 ± 0.2% | 82.37 ± 0.7% | 1374.10 ± 0.1% | 2.28 | 1.00 | 2.41 | 31.60 |
| class: a number | 8288 | 1993.60 ± 0.1% | 827.47 ± 0.2% | 27.69 ± 0.4% | 1729.38 ± 0.1% | 42.10 ± 8.4% | 0.55 ± 0.1% | 57.63 ± 0.2% | 1998.11 ± 0.2% | 2.41 | 1.00 | 1.15 | 47.35 |
| class: two capitalized words, second text | 5359 | 515.23 ± 0.3% | 523.06 ± 0.2% | 23.28 ± 0.2% | 483.89 ± 0.2% | 35.04 ± 6.2% | 17.08 ± 0.2% | 62.87 ± 0.2% | 515.16 ± 0.1% | 0.99 | 1.00 | 1.06 | 14.70 |
| other: a word between two words | 6104 | 784.94 ± 0.3% | 591.09 ± 0.2% | 23.54 ± 0.1% | 734.68 ± 0.2% | 108.22 ± 9.3% | 11.20 ± 0.3% | 68.15 ± 1.5% | 787.13 ± 0.2% | 1.33 | 1.00 | 1.07 | 7.25 |
| other: a number before a unit, second text | 1481 | 5944.17 ± 0.8% | 1116.47 ± 0.3% | 26.00 ± 0.1% | 5660.24 ± 0.3% | 40.78 ± 15.9% | 18.18 ± 0.2% | 65.82 ± 0.3% | 5903.52 ± 1.2% | 5.32 | 1.01 | 1.05 | 145.77 |
| other: a heading's start tag | 110 | 14155.47 ± 0.3% | 742.35 ± 0.5% | 27.36 ± 0.2% | 1707.89 ± 0.4% | 1568.40 ± 5.7% | 16.16 ± 0.5% | 86.14 ± 0.3% | 14180.19 ± 0.5% | 19.07 | 1.00 | 8.29 | 9.03 |
| other: a whole word | 217 | 15872.78 ± 1.5% | 601.83 ± 1.0% | 29.29 ± 0.5% | 14560.38 ± 1.0% | 49.30 ± 0.3% | 13.35 ± 0.2% | 55.00 ± 0.8% | 15969.37 ± 0.4% | 26.37 | 0.99 | 1.09 | 321.98 |
| other: a line's first word, second text | 3716 | 2034.90 ± 0.2% | 586.75 ± 0.2% | 30.94 ± 0.2% | 1721.29 ± 1.0% | 62.06 ± 5.9% | refused | refused | 2044.81 ± 0.3% | 3.47 | 1.00 | 1.18 | 32.79 |
| other: fourteen octets before an x | 87 | 24504.30 ± 1.1% | 244.24 ± 0.5% | 6.31 ± 0.1% | 4001.79 ± 0.4% | 10.62 ± 0.2% | differs | 17.80 ± 0.2% | 24413.62 ± 4.7% | 100.33 | 1.00 | 6.12 | 2307.74 |
| other: a Greek word | 21815 | 496.47 ± 0.4% | 411.32 ± 0.3% | 30.59 ± 0.1% | 289.40 ± 0.8% | 44.93 ± 10.4% | differs | refused | 498.39 ± 0.9% | 1.21 | 1.00 | 1.72 | 11.05 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.60 ± 0.1% | 19.56 ± 0.3% | 0.84 ± 0.3% | 19.86 ± 0.5% | 2.75 ± 4.6% | differs | 4.06 ± 0.1% | 19.57 ± 0.2% | 1.00 | 1.00 | 0.99 | 7.12 |
| a UUID | 32895 | 21.10 ± 0.2% | 21.05 ± 0.3% | 0.63 ± 0.1% | 15.15 ± 0.2% | 3.09 ± 0.6% | 0.73 ± 0.3% | 3.65 ± 0.9% | 21.06 ± 0.2% | 1.00 | 1.00 | 1.39 | 6.83 |
| an IPv4 address | 33176 | 35.98 ± 0.4% | 36.04 ± 0.5% | 2.04 ± 0.1% | 29.38 ± 0.4% | 6.65 ± 0.1% | differs | 4.18 ± 0.1% | 36.06 ± 0.5% | 1.00 | 1.00 | 1.22 | 5.41 |
| a date and time | 32954 | 30.99 ± 0.1% | 31.00 ± 0.3% | 1.43 ± 0.2% | 21.50 ± 0.1% | 7.02 ± 0.1% | 1.25 ± 0.2% | 7.18 ± 0.4% | 30.98 ± 0.2% | 1.00 | 1.00 | 1.44 | 4.42 |
| a field path | 32606 | 23.14 ± 0.2% | 23.08 ± 0.4% | 1.00 ± 0.7% | 23.30 ± 0.4% | 3.47 ± 0.8% | differs | 2.99 ± 0.1% | 23.06 ± 0.2% | 1.00 | 1.00 | 0.99 | 6.66 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.12 ± 0.6% | 11.13 ± 1.0% | 11.14 ± 0.5% | 11.79 ± 0.2% | 4.93 ± 1.6% | 0.93 ± 0.6% | none | 11.13 ± 1.7% | 1.00 | 1.00 | 0.94 | 2.26 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 226.27 ± 0.2% | 227.12 ± 0.3% | 267.21 ± 0.3% | 86.73 ± 0.2% | 218.96 ± 1.5% | 484.11 ± 0.7% | 3794.94 ± 5.2% | 226.21 ± 0.3% | 1.00 | 1.00 | 2.61 | 1.03 |
| a UUID | 62 | 148.56 ± 0.1% | 149.08 ± 0.2% | 165.53 ± 0.3% | 45.78 ± 0.7% | 98.97 ± 1.4% | 182.05 ± 1.2% | 4173.18 ± 0.5% | 148.65 ± 0.3% | 1.00 | 1.00 | 3.24 | 1.50 |
| an IPv4 address | 29 | 426.97 ± 0.2% | 430.47 ± 0.4% | 598.83 ± 0.4% | 75.80 ± 0.7% | 130.70 ± 1.7% | 294.89 ± 0.6% | 7501.63 ± 0.3% | 427.29 ± 0.2% | 0.99 | 1.00 | 5.63 | 3.27 |
| a date and time | 56 | 308.41 ± 0.4% | 310.55 ± 0.3% | 389.22 ± 0.4% | 72.18 ± 1.1% | 136.73 ± 1.0% | 320.33 ± 1.3% | 4805.06 ± 0.4% | 308.63 ± 0.3% | 0.99 | 1.00 | 4.27 | 2.26 |
| a field path | 39 | 217.57 ± 0.2% | 218.75 ± 0.4% | 255.08 ± 0.4% | 78.96 ± 0.3% | 202.78 ± 8.8% | 483.18 ± 1.1% | 4860.11 ± 0.9% | 218.05 ± 0.3% | 0.99 | 1.00 | 2.76 | 1.07 |
| literal: a word | 7 | 635.02 ± 0.7% | 687.54 ± 0.5% | 1230.81 ± 0.2% | 494.99 ± 1.5% | 626.07 ± 3.0% | 923.40 ± 0.4% | 31070.61 ± 0.1% | 635.60 ± 0.6% | 0.92 | 1.00 | 1.28 | 1.01 |
| literal: a word that is not there | 8 | 612.30 ± 0.5% | 666.25 ± 0.1% | 1159.48 ± 0.6% | 453.93 ± 0.4% | 591.72 ± 2.4% | 872.61 ± 0.5% | 29473.34 ± 0.1% | 613.48 ± 0.5% | 0.92 | 1.00 | 1.35 | 1.03 |
| literal: one of four words | 26 | 247.95 ± 0.4% | 402.19 ± 0.3% | 547.06 ± 0.4% | 49.13 ± 0.3% | 236.30 ± 2.9% | 356.15 ± 0.2% | 16064.69 ± 0.2% | 248.13 ± 0.2% | 0.62 | 1.00 | 5.05 | 1.05 |
| literal: a word in any case | 11 | 453.89 ± 0.4% | 485.32 ± 0.5% | 715.96 ± 0.2% | 15.60 ± 0.5% | 634.86 ± 3.4% | refused | 23720.37 ± 0.2% | 454.11 ± 0.2% | 0.94 | 1.00 | 29.10 | 0.71 |
| literal: an href attribute | 12 | 349.02 ± 0.3% | 361.45 ± 0.2% | 473.15 ± 0.4% | 10.82 ± 17.9% | 483.95 ± 1.6% | 756.25 ± 0.5% | 22199.03 ± 0.3% | 349.64 ± 0.3% | 0.97 | 1.00 | 32.27 | 0.72 |
| literal: a word, second text | 10 | 561.90 ± 0.5% | 621.16 ± 0.4% | 1036.35 ± 0.6% | 413.03 ± 1.7% | 536.07 ± 3.3% | 783.74 ± 0.4% | 27542.15 ± 0.1% | 562.79 ± 0.5% | 0.90 | 1.00 | 1.36 | 1.05 |
| class: two capitalized words | 23 | 438.99 ± 0.9% | 472.32 ± 0.6% | 674.40 ± 0.5% | 99.51 ± 0.3% | 502.47 ± 1.6% | 735.83 ± 0.9% | 6450.37 ± 0.3% | 439.98 ± 0.4% | 0.93 | 1.00 | 4.41 | 0.87 |
| class: a word that ends in ing | 9 | 570.44 ± 0.4% | 636.91 ± 0.2% | 1105.62 ± 0.1% | 131.70 ± 0.8% | 752.34 ± 1.0% | 1085.53 ± 1.8% | 16005.07 ± 1.2% | 570.86 ± 0.4% | 0.90 | 1.00 | 4.33 | 0.76 |
| class: a word in capitals | 16 | 496.55 ± 0.3% | 541.88 ± 0.2% | 855.80 ± 0.2% | 134.01 ± 0.4% | 745.25 ± 0.8% | 995.21 ± 1.6% | 8535.69 ± 0.5% | 496.60 ± 0.4% | 0.92 | 1.00 | 3.71 | 0.67 |
| class: a number | 6 | 637.68 ± 0.2% | 704.47 ± 0.8% | 1313.55 ± 0.1% | 42.09 ± 0.6% | 1395.57 ± 2.8% | 1921.92 ± 1.1% | 23015.43 ± 0.2% | 638.14 ± 0.2% | 0.91 | 1.00 | 15.15 | 0.46 |
| class: two capitalized words, second text | 23 | 439.58 ± 0.4% | 471.15 ± 0.5% | 675.60 ± 0.8% | 100.08 ± 1.9% | 495.87 ± 10.2% | 763.37 ± 1.0% | 6469.83 ± 0.3% | 439.45 ± 0.6% | 0.93 | 1.00 | 4.39 | 0.89 |
| other: a word between two words | 13 | 552.68 ± 0.1% | 572.63 ± 0.4% | 910.18 ± 0.4% | 133.77 ± 0.8% | 496.99 ± 1.9% | 820.25 ± 0.8% | 14674.78 ± 0.6% | 552.91 ± 0.2% | 0.97 | 1.00 | 4.13 | 1.11 |
| other: a number before a unit, second text | 15 | 398.63 ± 0.5% | 437.16 ± 0.7% | 607.37 ± 0.5% | 39.46 ± 0.2% | 621.65 ± 6.9% | 892.97 ± 0.8% | 15327.88 ± 0.3% | 399.64 ± 0.4% | 0.91 | 1.00 | 10.10 | 0.64 |
| other: a heading's start tag | 13 | 360.97 ± 0.3% | 368.39 ± 0.3% | 483.24 ± 0.3% | 11.51 ± 21.3% | 611.09 ± 3.2% | 858.02 ± 0.2% | 18348.89 ± 0.6% | 361.74 ± 0.3% | 0.98 | 1.00 | 31.35 | 0.59 |
| other: a whole word | 11 | 582.49 ± 0.3% | 622.25 ± 0.2% | 1036.11 ± 0.4% | 120.57 ± 0.6% | 557.05 ± 3.5% | 815.98 ± 1.1% | 27329.43 ± 0.3% | 582.58 ± 0.6% | 0.94 | 1.00 | 4.83 | 1.05 |
| other: a line's first word, second text | 17 | 530.96 ± 0.7% | 558.88 ± 0.4% | 896.28 ± 0.7% | 127.60 ± 0.2% | 700.24 ± 1.5% | refused | refused | 533.36 ± 0.2% | 0.95 | 1.00 | 4.16 | 0.76 |
| other: fourteen octets before an x | 16 | 110.05 ± 0.5% | 158.49 ± 0.6% | 181.44 ± 0.6% | 7.77 ± 14.8% | 449.56 ± 3.2% | 414.32 ± 0.8% | 12941.31 ± 0.4% | 110.24 ± 0.4% | 0.69 | 1.00 | 14.17 | 0.24 |
| other: a Greek word | 8 | 456.07 ± 0.2% | 605.21 ± 0.5% | 1014.30 ± 0.2% | 13.53 ± 56.2% | 1381.29 ± 1.5% | 1799.10 ± 0.7% | refused | 456.36 ± 0.1% | 0.75 | 1.00 | 33.72 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15882.16 ± 1.0% | not timed | not timed | 16443.14 ± 1.3% | 1911.45 ± 22.2% | not timed | not timed | 15845.54 ± 0.5% | | 1.00 | 0.97 | 8.31 |
| 01-literal/sherlock-casei-en | 522 | 11007.06 ± 4.2% | not timed | not timed | 3586.91 ± 0.1% | 32.45 ± 1.5% | not timed | not timed | 10976.51 ± 2.8% | | 1.00 | 3.07 | 339.21 |
| 01-literal/sherlock-ru | 724 | 17031.49 ± 1.1% | not timed | not timed | 17250.54 ± 0.2% | 1524.76 ± 10.8% | not timed | not timed | 17128.01 ± 0.5% | | 0.99 | 0.99 | 11.17 |
| 01-literal/sherlock-casei-ru | 746 | 6159.77 ± 0.4% | not timed | not timed | 3323.96 ± 0.0% | 30.69 ± 0.4% | not timed | not timed | 6163.88 ± 0.5% | | 1.00 | 1.85 | 200.71 |
| 01-literal/sherlock-zh | 30 | 20016.54 ± 0.8% | not timed | not timed | 18989.34 ± 1.7% | 2834.21 ± 19.2% | not timed | not timed | 20060.28 ± 0.9% | | 1.00 | 1.05 | 7.06 |
| 02-literal-alternate/sherlock-en | 714 | 6039.16 ± 0.2% | not timed | not timed | 3931.85 ± 0.3% | 16.47 ± 0.1% | not timed | not timed | 6039.03 ± 0.3% | | 1.00 | 1.54 | 366.78 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1975.17 ± 1.3% | not timed | not timed | 697.93 ± 0.2% | 10.78 ± 0.3% | not timed | not timed | 1982.28 ± 0.8% | | 1.00 | 2.83 | 183.19 |
| 02-literal-alternate/sherlock-ru | 899 | 5544.76 ± 0.3% | not timed | not timed | 3246.02 ± 0.1% | 22.61 ± 0.1% | not timed | not timed | 5555.45 ± 0.2% | | 1.00 | 1.71 | 245.23 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2054.11 ± 0.7% | not timed | not timed | 1226.21 ± 0.1% | 9.09 ± 0.1% | not timed | not timed | 2053.02 ± 0.7% | | 1.00 | 1.68 | 225.86 |
| 02-literal-alternate/sherlock-zh | 207 | 7281.42 ± 0.4% | not timed | not timed | 4152.79 ± 0.2% | 31.39 ± 0.3% | not timed | not timed | 7290.49 ± 0.3% | | 1.00 | 1.75 | 231.94 |
| 03-date/ascii | 111817 | 123.91 ± 0.7% | not timed | not timed | 95.72 ± 0.1% | 0.20 ± 3.7% | not timed | not timed | 124.15 ± 0.7% | | 1.00 | 1.29 | 617.13 |
| 04-ruff-noqa/real | 84 | 402.68 ± 0.2% | not timed | not timed | 461.91 ± 0.2% | 19.52 ± 1.6% | not timed | not timed | 403.04 ± 0.3% | | 1.00 | 0.87 | 20.63 |
| 04-ruff-noqa/tweaked | 44 | 554.62 ± 0.2% | not timed | not timed | 449.47 ± 0.2% | 363.95 ± 0.3% | not timed | not timed | 556.14 ± 0.6% | | 1.00 | 1.23 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.52 ± 4.9% | not timed | not timed | 5.16 ± 0.1% | 0.20 ± 4.6% | not timed | not timed | 5.37 ± 0.7% | | 1.03 | 1.07 | 27.06 |
| 06-cloud-flare-redos/original | 107 | 415.10 ± 0.2% | not timed | not timed | 213.98 ± 0.0% | 24.92 ± 0.2% | not timed | not timed | 415.51 ± 0.1% | | 1.00 | 1.94 | 16.66 |
| 06-cloud-flare-redos/simplified-short | 102 | 415.74 ± 0.1% | not timed | not timed | 227.98 ± 0.1% | 26.60 ± 0.2% | not timed | not timed | 409.64 ± 0.3% | | 1.01 | 1.82 | 15.63 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.12 ± 0.4% | not timed | not timed | 253.21 ± 0.3% | 28.72 ± 0.1% | not timed | not timed | 577.52 ± 0.8% | | 1.02 | 2.32 | 20.44 |
| 07-unicode-character-data/parse-line | 558784 | 234.51 ± 2.2% | not timed | not timed | 180.43 ± 0.1% | 41.22 ± 5.6% | not timed | not timed | 237.87 ± 3.0% | | 0.99 | 1.30 | 5.69 |
| 08-words/all-english | 56691 | 115.73 ± 0.9% | not timed | not timed | 83.02 ± 0.1% | 11.81 ± 14.4% | not timed | not timed | 116.34 ± 0.7% | | 0.99 | 1.39 | 9.80 |
| 08-words/long-english | 839 | 612.41 ± 0.2% | not timed | not timed | 593.71 ± 0.4% | 32.48 ± 0.3% | not timed | not timed | 613.70 ± 0.3% | | 1.00 | 1.03 | 18.86 |
| 09-aws-keys/full | 0 | 406.67 ± 0.2% | not timed | not timed | 494.08 ± 0.1% | 64.11 ± 0.1% | not timed | not timed | 407.78 ± 0.1% | | 1.00 | 0.82 | 6.34 |
| 09-aws-keys/quick | 0 | 867.53 ± 0.2% | not timed | not timed | 996.59 ± 0.2% | 415.33 ± 0.3% | not timed | not timed | 869.42 ± 0.2% | | 1.00 | 0.87 | 2.09 |
| 10-bounded-repeat/letters-en | 1833 | 581.45 ± 1.8% | not timed | not timed | 515.51 ± 0.3% | 19.43 ± 0.4% | not timed | not timed | 578.89 ± 1.2% | | 1.00 | 1.13 | 29.92 |
| 10-bounded-repeat/letters-ru | 3475 | 508.88 ± 0.8% | not timed | not timed | 478.02 ± 0.2% | 22.09 ± 9.2% | not timed | not timed | 509.94 ± 1.4% | | 1.00 | 1.06 | 23.04 |
| 10-bounded-repeat/context | 53 | 84.55 ± 2.0% | not timed | not timed | 65.72 ± 0.7% | 19.78 ± 0.3% | not timed | not timed | 84.52 ± 1.7% | | 1.00 | 1.29 | 4.28 |
| 10-bounded-repeat/capitals | 11 | 640.19 ± 8.1% | not timed | not timed | 617.38 ± 0.1% | 36.40 ± 0.2% | not timed | not timed | 639.80 ± 8.0% | | 1.00 | 1.04 | 17.59 |
| 11-unstructured-to-json/extract | 600 | 56.78 ± 0.2% | not timed | not timed | 76.06 ± 0.2% | 48.87 ± 0.5% | not timed | not timed | 56.74 ± 0.6% | | 1.00 | 0.75 | 1.16 |
| 12-dictionary/single | 1 | 566.37 ± 0.5% | not timed | not timed | 560.34 ± 0.2% | 0.40 ± 0.3% | not timed | not timed | 568.14 ± 0.3% | | 1.00 | 1.01 | 1398.53 |
| 14-quadratic/1x | 100 | 21.15 ± 1.0% | not timed | not timed | 10.03 ± 0.1% | 0.97 ± 4.4% | not timed | not timed | 21.16 ± 1.1% | | 1.00 | 2.11 | 21.90 |
| 14-quadratic/2x | 200 | 17.39 ± 0.6% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 2.3% | not timed | not timed | 17.39 ± 0.4% | | 1.00 | 3.13 | 32.82 |
| 14-quadratic/10x | 1000 | 7.66 ± 0.4% | not timed | not timed | 1.20 ± 0.2% | 0.12 ± 2.1% | not timed | not timed | 7.68 ± 0.8% | | 1.00 | 6.36 | 66.50 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.25 ± 2.9% | not timed | not timed | 0.34 ± 0.3% | 0.53 ± 5.2% | not timed | not timed | 1.26 ± 3.4% | | 0.99 | 3.67 | 2.35 |
| 04-ruff-noqa/compile-real | 1 | 104.05 ± 0.4% | not timed | not timed | 13.86 ± 0.6% | 133.59 ± 4.5% | not timed | not timed | 104.22 ± 1.5% | | 1.00 | 7.51 | 0.78 |
| 05-lexer-veryl/compile-single | 1 | 14.09 ± 0.2% | not timed | not timed | 2.50 ± 0.7% | 6.14 ± 2.9% | not timed | not timed | 14.11 ± 0.7% | | 1.00 | 5.64 | 2.29 |
| 07-unicode-character-data/compile | 1 | 108.30 ± 0.8% | not timed | not timed | 26.16 ± 0.5% | 34.56 ± 1.3% | not timed | not timed | 108.74 ± 1.3% | | 1.00 | 4.14 | 3.13 |
| 09-aws-keys/compile-full | 1 | 52.94 ± 1.5% | not timed | not timed | 8.25 ± 0.5% | 22.57 ± 1.8% | not timed | not timed | 53.04 ± 1.6% | | 1.00 | 6.42 | 2.35 |
| 09-aws-keys/compile-quick | 1 | 188.01 ± 1.0% | not timed | not timed | 47.99 ± 0.7% | 123.65 ± 5.8% | not timed | not timed | 188.48 ± 0.7% | | 1.00 | 3.92 | 1.52 |
| 10-bounded-repeat/compile-context | 1 | 71.48 ± 0.6% | not timed | not timed | 11.12 ± 0.4% | 15.61 ± 5.1% | not timed | not timed | 71.67 ± 2.6% | | 1.00 | 6.43 | 4.58 |
| 10-bounded-repeat/compile-capitals | 1 | 84.38 ± 3.2% | not timed | not timed | 7.93 ± 0.2% | 23.32 ± 2.6% | not timed | not timed | 85.39 ± 0.5% | | 0.99 | 10.64 | 3.62 |
| 11-unstructured-to-json/compile | 1 | 171.86 ± 1.1% | not timed | not timed | 41.13 ± 0.3% | 65.36 ± 5.0% | not timed | not timed | 172.17 ± 1.6% | | 1.00 | 4.18 | 2.63 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.4% | not timed | not timed | 0.07 ± 1.4% | 0.09 ± 16.5% | not timed | not timed | 0.35 ± 1.4% | | 0.99 | 5.26 | 3.91 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.60 ± 5.1% | not timed | not timed | 6.57 ± 0.5% | 0.59 ± 18.6% | not timed | not timed | 7.60 ± 2.3% | | 1.00 | 1.16 | 12.96 |
| dictionary/search/english-10 | 690 | 1.04 ± 1.5% | not timed | not timed | 164.37 ± 1.0% | 0.00 ± 0.3% | not timed | not timed | 1.04 ± 0.8% | | 0.99 | 0.0063 | 351.80 |
| dictionary/search/english-15 | 15 | 559.25 ± 0.3% | not timed | not timed | 558.82 ± 0.1% | 0.37 ± 0.1% | not timed | not timed | 561.75 ± 0.8% | | 1.00 | 1.00 | 1527.56 |
| folly/awyer-inn-busted | 1 | 5575.47 ± 0.2% | not timed | not timed | 143.65 ± 0.0% | 43.98 ± 0.2% | not timed | not timed | 5566.75 ± 0.2% | | 1.00 | 38.81 | 126.77 |
| folly/literal-never-match-rare | 0 | 20711.67 ± 1.2% | not timed | not timed | 19528.81 ± 0.7% | 40110.50 ± 0.6% | not timed | not timed | 20749.56 ± 1.3% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12396.94 ± 2.0% | not timed | not timed | 19613.88 ± 1.2% | 2184.09 ± 1.0% | not timed | not timed | 12410.61 ± 1.7% | | 1.00 | 0.63 | 5.68 |
| folly/literal-never-match-tricksy | 1 | 3236.03 ± 0.2% | not timed | not timed | 4417.24 ± 0.6% | 3003.42 ± 2.2% | not timed | not timed | 3235.66 ± 0.2% | | 1.00 | 0.73 | 1.08 |
| grep/every-line | 239963 | 1300.61 ± 0.5% | not timed | not timed | 961.57 ± 0.4% | 362.07 ± 15.7% | not timed | not timed | 1304.15 ± 0.7% | | 1.00 | 1.35 | 3.59 |
| grep/long-words-ascii | 5073 | 458.78 ± 0.3% | not timed | not timed | 470.47 ± 0.1% | 46.11 ± 6.5% | not timed | not timed | 458.52 ± 0.1% | | 1.00 | 0.98 | 9.95 |
| imported/leipzig/twain | 811 | 19328.26 ± 4.1% | not timed | not timed | 18258.67 ± 3.5% | 11431.31 ± 12.7% | not timed | not timed | 19854.65 ± 4.8% | | 0.97 | 1.06 | 1.69 |
| imported/leipzig/twain-insensitive | 965 | 8874.80 ± 1.1% | not timed | not timed | 4170.97 ± 1.3% | 37.71 ± 0.1% | not timed | not timed | 8946.97 ± 1.9% | | 0.99 | 2.13 | 235.37 |
| imported/leipzig/shing | 1540 | 628.43 ± 0.1% | not timed | not timed | 12242.77 ± 3.1% | 34.01 ± 0.1% | not timed | not timed | 630.69 ± 0.1% | | 1.00 | 0.0513 | 18.48 |
| imported/leipzig/huck-saw | 262 | 8031.50 ± 4.3% | not timed | not timed | 5468.10 ± 1.9% | 31.89 ± 0.1% | not timed | not timed | 8149.22 ± 4.6% | | 0.99 | 1.47 | 251.82 |
| imported/leipzig/word-ending-nn | 262 | 607.57 ± 0.4% | not timed | not timed | 615.35 ± 0.2% | 24.69 ± 0.2% | not timed | not timed | 610.09 ± 0.3% | | 1.00 | 0.99 | 24.61 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 10783.37 ± 0.9% | not timed | not timed | 4308.99 ± 2.0% | 11.47 ± 0.2% | not timed | not timed | 10840.62 ± 1.0% | | 0.99 | 2.50 | 939.76 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7492.05 ± 5.1% | not timed | not timed | 5326.22 ± 1.8% | 16.81 ± 0.1% | not timed | not timed | 7617.25 ± 2.6% | | 0.98 | 1.41 | 445.80 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4096.02 ± 1.2% | not timed | not timed | 423.57 ± 0.3% | 11.09 ± 0.0% | not timed | not timed | 4112.92 ± 1.3% | | 1.00 | 9.67 | 369.41 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 608.25 ± 0.3% | not timed | not timed | 607.24 ± 1.2% | 11.12 ± 0.1% | not timed | not timed | 608.91 ± 0.2% | | 1.00 | 1.00 | 54.71 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 608.41 ± 0.1% | not timed | not timed | 615.12 ± 0.1% | 9.46 ± 0.0% | not timed | not timed | 608.56 ± 0.2% | | 1.00 | 0.99 | 64.33 |
| imported/leipzig/tom-river | 2 | 6209.41 ± 4.5% | not timed | not timed | 4950.48 ± 1.3% | 30.98 ± 0.2% | not timed | not timed | 6228.63 ± 3.0% | | 1.00 | 1.25 | 200.40 |
| imported/leipzig/ing | 78424 | 607.04 ± 0.8% | not timed | not timed | 569.17 ± 0.1% | 28.26 ± 2.7% | not timed | not timed | 606.28 ± 0.7% | | 1.00 | 1.07 | 21.48 |
| imported/leipzig/ing-whitespace | 55248 | 754.93 ± 3.2% | not timed | not timed | 2023.24 ± 9.8% | 20.49 ± 2.8% | not timed | not timed | 756.09 ± 1.2% | | 1.00 | 0.37 | 36.85 |
| imported/leipzig/awyer-inn | 209 | 773.35 ± 1.5% | not timed | not timed | 4047.04 ± 4.2% | 22.70 ± 0.0% | not timed | not timed | 773.44 ± 1.4% | | 1.00 | 0.19 | 34.06 |
| imported/leipzig/quotes-bounded | 8886 | 2102.48 ± 2.0% | not timed | not timed | 2913.17 ± 0.4% | 38.17 ± 0.0% | not timed | not timed | 2096.45 ± 1.7% | | 1.00 | 0.72 | 55.09 |
| imported/leipzig/non-ascii-alternate | 2 | 12421.65 ± 3.6% | not timed | not timed | 5405.68 ± 3.5% | 50.88 ± 0.1% | not timed | not timed | 12576.35 ± 2.4% | | 0.99 | 2.30 | 244.12 |
| imported/leipzig/math-symbols | 69 | 1967.16 ± 0.6% | not timed | not timed | 617.44 ± 0.1% | 36.54 ± 0.2% | not timed | not timed | 1970.16 ± 0.4% | | 1.00 | 3.19 | 53.83 |
| imported/leipzig/bounded-strings-ending-z | 0 | 592.31 ± 0.3% | not timed | not timed | 613.84 ± 0.0% | 22.49 ± 0.1% | not timed | not timed | 594.11 ± 0.3% | | 1.00 | 0.96 | 26.34 |
| imported/lh3lh3-reb/uri | 17549 | 632.13 ± 0.1% | not timed | not timed | 1077.70 ± 0.6% | 28.27 ± 2.7% | not timed | not timed | 631.62 ± 0.2% | | 1.00 | 0.59 | 22.36 |
| imported/lh3lh3-reb/email | 15057 | 666.92 ± 0.2% | not timed | not timed | 1177.24 ± 0.2% | 30.73 ± 2.8% | not timed | not timed | 667.74 ± 0.0% | | 1.00 | 0.57 | 21.70 |
| imported/lh3lh3-reb/date | 668 | 862.51 ± 0.3% | not timed | not timed | 1047.86 ± 0.1% | 51.41 ± 3.8% | not timed | not timed | 863.69 ± 0.2% | | 1.00 | 0.82 | 16.78 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 641.00 ± 0.2% | not timed | not timed | 423.19 ± 0.2% | 15.75 ± 5.1% | not timed | not timed | 640.81 ± 0.2% | | 1.00 | 1.51 | 40.71 |
| imported/mariomka/email | 92 | 703.64 ± 0.1% | not timed | not timed | 29235.24 ± 0.9% | 31.12 ± 0.1% | not timed | not timed | 704.29 ± 0.2% | | 1.00 | 0.0241 | 22.61 |
| imported/mariomka/uri | 5301 | 606.82 ± 0.1% | not timed | not timed | 5920.11 ± 1.1% | 31.08 ± 0.3% | not timed | not timed | 604.26 ± 0.2% | | 1.00 | 0.10 | 19.52 |
| imported/mariomka/ip | 5 | 2142.54 ± 2.3% | not timed | not timed | 2913.12 ± 0.7% | 20.99 ± 0.3% | not timed | not timed | 2139.67 ± 2.7% | | 1.00 | 0.74 | 102.05 |
| imported/rsc/no-exponential | 0 | 569.71 ± 0.1% | not timed | not timed | 321.11 ± 0.2% | 23.88 ± 0.3% | not timed | not timed | 568.53 ± 0.1% | | 1.00 | 1.77 | 23.86 |
| imported/rsc/literal | 1 | 744.34 ± 8.9% | not timed | not timed | 1553.41 ± 2.3% | 190.60 ± 14.5% | not timed | not timed | 740.50 ± 5.9% | | 1.01 | 0.48 | 3.91 |
| imported/rsc/not-literal | 2 | 707.28 ± 0.6% | not timed | not timed | 716.51 ± 0.3% | 46.38 ± 11.7% | not timed | not timed | 707.05 ± 0.1% | | 1.00 | 0.99 | 15.25 |
| imported/rsc/match-class | 1 | 1298.79 ± 0.3% | not timed | not timed | 1641.52 ± 0.2% | 58.57 ± 6.7% | not timed | not timed | 1303.76 ± 2.0% | | 1.00 | 0.79 | 22.18 |
| imported/rsc/match-class-in-range | 1 | 1303.36 ± 2.2% | not timed | not timed | 2364.88 ± 2.5% | 60.23 ± 7.2% | not timed | not timed | 1302.73 ± 0.3% | | 1.00 | 0.55 | 21.64 |
| imported/rsc/match-class-unicode | 1 | 524.84 ± 6.9% | not timed | not timed | 514.63 ± 0.0% | 72.68 ± 2.0% | not timed | not timed | 523.76 ± 0.1% | | 1.00 | 1.02 | 7.22 |
| imported/rsc/anchored-literal-short-non-match | 0 | 538.28 ± 0.5% | not timed | not timed | 953.28 ± 0.8% | 227.38 ± 1.3% | not timed | not timed | 534.53 ± 0.6% | | 1.01 | 0.56 | 2.37 |
| imported/rsc/anchored-literal-long-non-match | 0 | 8003.81 ± 0.3% | not timed | not timed | 14343.24 ± 0.1% | 3412.38 ± 0.6% | not timed | not timed | 8016.69 ± 0.1% | | 1.00 | 0.56 | 2.35 |
| imported/rsc/anchored-literal-short-match | 4 | 417.67 ± 2.0% | not timed | not timed | 471.40 ± 0.2% | 85.13 ± 10.7% | not timed | not timed | 421.96 ± 0.3% | | 0.99 | 0.89 | 4.91 |
| imported/rsc/anchored-literal-long-match | 4 | 3002.06 ± 1.9% | not timed | not timed | 7311.65 ± 0.1% | 1238.61 ± 5.3% | not timed | not timed | 3022.56 ± 1.8% | | 0.99 | 0.41 | 2.42 |
| imported/rsc/one-pass-short | 17 | 310.58 ± 8.3% | not timed | not timed | 212.86 ± 0.2% | 31.03 ± 13.5% | not timed | not timed | 307.96 ± 2.8% | | 1.01 | 1.46 | 10.01 |
| imported/rsc/one-pass-short-not | 17 | 219.86 ± 2.1% | not timed | not timed | 222.67 ± 0.1% | 28.67 ± 10.5% | not timed | not timed | 219.97 ± 1.9% | | 1.00 | 0.99 | 7.67 |
| imported/rsc/one-pass-long-prefix | 26 | 234.56 ± 11.8% | not timed | not timed | 281.98 ± 0.2% | 98.38 ± 15.5% | not timed | not timed | 239.04 ± 2.3% | | 0.98 | 0.83 | 2.38 |
| imported/rsc/one-pass-long-prefix-not | 26 | 313.19 ± 3.0% | not timed | not timed | 280.67 ± 0.0% | 66.85 ± 16.7% | not timed | not timed | 311.89 ± 1.8% | | 1.00 | 1.12 | 4.69 |
| imported/rsc/long-needle1 | 31 | 21911.60 ± 0.2% | not timed | not timed | 20142.86 ± 0.2% | 3.76 ± 0.3% | not timed | not timed | 21925.58 ± 0.3% | | 1.00 | 1.09 | 5824.86 |
| imported/rsc/long-needle2 | 31 | 22071.92 ± 0.1% | not timed | not timed | 216.37 ± 0.2% | 3.77 ± 0.2% | not timed | not timed | 22078.86 ± 0.2% | | 1.00 | 102.01 | 5855.58 |
| imported/rsc/easy0-32 | 26 | 1065.79 ± 3.6% | not timed | not timed | 1605.23 ± 1.9% | 147.42 ± 16.0% | not timed | not timed | 1062.21 ± 2.3% | | 1.00 | 0.66 | 7.23 |
| imported/rsc/easy0-1k | 26 | 14881.51 ± 6.3% | not timed | not timed | 12565.36 ± 0.5% | 2301.70 ± 12.7% | not timed | not timed | 14879.86 ± 1.9% | | 1.00 | 1.18 | 6.47 |
| imported/rsc/easy0-32k | 26 | 22864.30 ± 1.4% | not timed | not timed | 20469.37 ± 0.1% | 18756.93 ± 18.7% | not timed | not timed | 22886.41 ± 0.2% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21698.89 ± 0.7% | not timed | not timed | 20026.02 ± 0.7% | 36231.41 ± 2.8% | not timed | not timed | 21627.28 ± 0.6% | | 1.00 | 1.08 | 0.60 |
| imported/rsc/easy1-32 | 19 | 359.58 ± 7.3% | not timed | not timed | 634.19 ± 0.2% | 133.77 ± 14.2% | not timed | not timed | 359.71 ± 1.8% | | 1.00 | 0.57 | 2.69 |
| imported/rsc/easy1-1k | 19 | 583.90 ± 2.3% | not timed | not timed | 12659.72 ± 0.2% | 2477.46 ± 15.2% | not timed | not timed | 579.66 ± 0.2% | | 1.01 | 0.0461 | 0.24 |
| imported/rsc/easy1-32k | 19 | 603.22 ± 0.2% | not timed | not timed | 405079.91 ± 0.3% | 20419.66 ± 30.6% | not timed | not timed | 600.66 ± 3.0% | | 1.00 | 0.0015 | 0.0295 |
| imported/rsc/easy1-1mb | 19 | 602.56 ± 0.5% | not timed | not timed | 13064088.79 ± 0.2% | 36967.36 ± 3.2% | not timed | not timed | 601.16 ± 0.4% | | 1.00 | 0.0000 | 0.0163 |
| imported/rsc/medium-32 | 27 | 429.01 ± 2.6% | not timed | not timed | 634.63 ± 0.2% | 69.85 ± 12.6% | not timed | not timed | 429.34 ± 0.4% | | 1.00 | 0.68 | 6.14 |
| imported/rsc/medium-1k | 27 | 6804.20 ± 0.3% | not timed | not timed | 11130.49 ± 0.1% | 72.33 ± 0.1% | not timed | not timed | 6815.06 ± 0.1% | | 1.00 | 0.61 | 94.07 |
| imported/rsc/medium-32k | 27 | 21581.91 ± 0.1% | not timed | not timed | 349873.47 ± 0.3% | 48.26 ± 0.2% | not timed | not timed | 21591.50 ± 0.3% | | 1.00 | 0.0617 | 447.24 |
| imported/rsc/medium-1mb | 27 | 21139.00 ± 1.9% | not timed | not timed | 11111549.60 ± 0.2% | 48.18 ± 0.1% | not timed | not timed | 21183.46 ± 1.5% | | 1.00 | 0.0019 | 438.71 |
| imported/rsc/hard-32 | 58 | 255.27 ± 2.5% | not timed | not timed | 366.35 ± 0.1% | 49.53 ± 8.6% | not timed | not timed | 255.60 ± 0.1% | | 1.00 | 0.70 | 5.15 |
| imported/rsc/hard-1k | 27 | 576.08 ± 0.5% | not timed | not timed | 11497.68 ± 0.1% | 40.81 ± 0.1% | not timed | not timed | 573.83 ± 0.2% | | 1.00 | 0.0501 | 14.12 |
| imported/rsc/hard-32k | 27 | 602.80 ± 0.1% | not timed | not timed | 361590.83 ± 0.1% | 29.32 ± 0.1% | not timed | not timed | 598.50 ± 0.3% | | 1.01 | 0.0017 | 20.56 |
| imported/rsc/hard-1mb | 51 | 601.93 ± 0.5% | not timed | not timed | 7253888.73 ± 0.1% | 29.35 ± 0.1% | not timed | not timed | 599.58 ± 0.4% | | 1.00 | 0.0001 | 20.51 |
| imported/rsc/reallyhard0-32 | 58 | 254.12 ± 0.3% | not timed | not timed | 224.35 ± 0.1% | 44.95 ± 13.3% | not timed | not timed | 254.96 ± 0.2% | | 1.00 | 1.13 | 5.65 |
| imported/rsc/reallyhard0-1k | 27 | 573.66 ± 0.2% | not timed | not timed | 581.06 ± 0.2% | 40.65 ± 0.1% | not timed | not timed | 579.89 ± 0.1% | | 0.99 | 0.99 | 14.11 |
| imported/rsc/reallyhard0-32k | 27 | 599.77 ± 0.2% | not timed | not timed | 615.81 ± 0.0% | 29.32 ± 0.1% | not timed | not timed | 602.26 ± 0.2% | | 1.00 | 0.97 | 20.46 |
| imported/rsc/reallyhard0-1mb | 51 | 589.71 ± 0.3% | not timed | not timed | 616.77 ± 0.0% | 29.34 ± 0.1% | not timed | not timed | 595.11 ± 0.7% | | 0.99 | 0.96 | 20.10 |
| imported/rsc/reallyreallyhard0-32 | 47 | 273.97 ± 1.6% | not timed | not timed | 196.42 ± 0.1% | 60.55 ± 15.8% | not timed | not timed | 273.70 ± 0.2% | | 1.00 | 1.39 | 4.53 |
| imported/rsc/reallyreallyhard0-1k | 16 | 882.76 ± 3.3% | not timed | not timed | 5924.74 ± 0.1% | 33.90 ± 1.0% | not timed | not timed | 884.79 ± 3.2% | | 1.00 | 0.15 | 26.04 |
| imported/rsc/reallyreallyhard0-32k | 16 | 618.85 ± 2.4% | not timed | not timed | 19234.62 ± 0.3% | 24.69 ± 1.4% | not timed | not timed | 625.55 ± 5.0% | | 0.99 | 0.0322 | 25.07 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 587.18 ± 0.4% | not timed | not timed | 19853.72 ± 0.9% | 25.18 ± 1.7% | not timed | not timed | 591.38 ± 0.6% | | 0.99 | 0.0296 | 23.32 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 268.94 ± 3.4% | not timed | not timed | 212.22 ± 0.2% | 60.03 ± 11.2% | not timed | not timed | 268.53 ± 0.1% | | 1.00 | 1.27 | 4.48 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 843.76 ± 3.7% | not timed | not timed | 6208.90 ± 0.2% | 33.13 ± 0.8% | not timed | not timed | 842.74 ± 2.2% | | 1.00 | 0.14 | 25.47 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 623.55 ± 4.0% | not timed | not timed | 19321.63 ± 0.1% | 24.86 ± 2.9% | not timed | not timed | 623.86 ± 5.2% | | 1.00 | 0.0323 | 25.08 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 591.41 ± 0.4% | not timed | not timed | 19847.68 ± 0.8% | 24.75 ± 1.2% | not timed | not timed | 591.64 ± 0.5% | | 1.00 | 0.0298 | 23.90 |
| imported/sherlock/name-sherlock | 776 | 19688.09 ± 1.8% | not timed | not timed | 18625.60 ± 0.5% | 10131.05 ± 29.1% | not timed | not timed | 19691.69 ± 2.0% | | 1.00 | 1.06 | 1.94 |
| imported/sherlock/name-holmes | 2766 | 15012.32 ± 1.8% | not timed | not timed | 15550.74 ± 0.4% | 3182.12 ± 13.7% | not timed | not timed | 15210.78 ± 2.0% | | 0.99 | 0.97 | 4.72 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19752.76 ± 2.0% | not timed | not timed | 18592.75 ± 0.3% | 8072.90 ± 25.0% | not timed | not timed | 19758.92 ± 2.2% | | 1.00 | 1.06 | 2.45 |
| imported/sherlock/name-sherlock-casei | 816 | 15660.48 ± 0.2% | not timed | not timed | 4012.56 ± 0.1% | 32.54 ± 0.3% | not timed | not timed | 15672.05 ± 0.1% | | 1.00 | 3.90 | 481.22 |
| imported/sherlock/name-holmes-casei | 2802 | 9270.06 ± 7.8% | not timed | not timed | 3313.38 ± 0.1% | 37.60 ± 1.1% | not timed | not timed | 9223.02 ± 6.0% | | 1.01 | 2.80 | 246.53 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12934.47 ± 7.5% | not timed | not timed | 3945.33 ± 0.1% | 32.43 ± 0.3% | not timed | not timed | 12967.04 ± 1.1% | | 1.00 | 3.28 | 398.82 |
| imported/sherlock/name-whitespace | 1461 | 15017.61 ± 1.5% | not timed | not timed | 14600.64 ± 0.2% | 6645.35 ± 20.2% | not timed | not timed | 15039.26 ± 1.8% | | 1.00 | 1.03 | 2.26 |
| imported/sherlock/name-alt1 | 1142 | 11457.33 ± 0.5% | not timed | not timed | 16425.84 ± 0.9% | 4129.01 ± 24.2% | not timed | not timed | 11492.87 ± 2.5% | | 1.00 | 0.70 | 2.77 |
| imported/sherlock/name-alt2 | 3542 | 8620.66 ± 0.2% | not timed | not timed | 3820.66 ± 0.1% | 31.33 ± 0.1% | not timed | not timed | 8621.36 ± 0.2% | | 1.00 | 2.26 | 275.18 |
| imported/sherlock/name-alt3 | 4507 | 5437.33 ± 0.5% | not timed | not timed | 3618.76 ± 0.1% | 9.82 ± 4.1% | not timed | not timed | 5439.41 ± 0.5% | | 1.00 | 1.50 | 553.46 |
| imported/sherlock/name-alt3-casei | 4593 | 1509.14 ± 1.9% | not timed | not timed | 285.89 ± 0.4% | 6.44 ± 0.1% | not timed | not timed | 1511.11 ± 0.9% | | 1.00 | 5.28 | 234.48 |
| imported/sherlock/name-alt4 | 3686 | 6173.94 ± 0.3% | not timed | not timed | 3786.35 ± 0.1% | 31.36 ± 0.2% | not timed | not timed | 6183.37 ± 0.1% | | 1.00 | 1.63 | 196.87 |
| imported/sherlock/name-alt4-casei | 4254 | 2760.55 ± 2.8% | not timed | not timed | 2591.39 ± 0.2% | 19.85 ± 0.2% | not timed | not timed | 2772.49 ± 1.1% | | 1.00 | 1.07 | 139.05 |
| imported/sherlock/name-alt5 | 4028 | 6236.14 ± 0.4% | not timed | not timed | 3738.56 ± 0.1% | 21.71 ± 0.1% | not timed | not timed | 6237.43 ± 0.2% | | 1.00 | 1.67 | 287.26 |
| imported/sherlock/name-alt5-casei | 4104 | 3450.96 ± 2.1% | not timed | not timed | 2191.63 ± 0.1% | 14.37 ± 0.2% | not timed | not timed | 3461.55 ± 1.3% | | 1.00 | 1.57 | 240.17 |
| imported/sherlock/no-match-uncommon | 0 | 21601.71 ± 0.2% | not timed | not timed | 19668.24 ± 0.2% | 36275.38 ± 0.4% | not timed | not timed | 21526.19 ± 0.9% | | 1.00 | 1.10 | 0.60 |
| imported/sherlock/no-match-common | 0 | 21298.07 ± 0.6% | not timed | not timed | 19661.54 ± 0.4% | 1267.84 ± 1.4% | not timed | not timed | 21340.04 ± 0.5% | | 1.00 | 1.08 | 16.80 |
| imported/sherlock/no-match-really-common | 0 | 15972.23 ± 2.3% | not timed | not timed | 18843.91 ± 0.5% | 1268.17 ± 1.8% | not timed | not timed | 16160.01 ± 2.8% | | 0.99 | 0.85 | 12.59 |
| imported/sherlock/the-lower | 21654 | 2300.55 ± 1.0% | not timed | not timed | 2328.32 ± 0.2% | 234.66 ± 9.7% | not timed | not timed | 2315.33 ± 2.0% | | 0.99 | 0.99 | 9.80 |
| imported/sherlock/the-upper | 2223 | 12651.81 ± 1.0% | not timed | not timed | 13546.87 ± 0.8% | 2702.00 ± 5.0% | not timed | not timed | 12706.14 ± 1.1% | | 1.00 | 0.93 | 4.68 |
| imported/sherlock/the-casei | 23961 | 2005.31 ± 1.5% | not timed | not timed | 1313.83 ± 0.3% | 34.84 ± 31.4% | not timed | not timed | 2009.88 ± 0.5% | | 1.00 | 1.53 | 57.55 |
| imported/sherlock/everything-greedy | 581881 | 270.50 ± 0.5% | not timed | not timed | 165.53 ± 0.1% | 28.69 ± 19.8% | not timed | not timed | 270.01 ± 0.3% | | 1.00 | 1.63 | 9.43 |
| imported/sherlock/everything-greedy-nl | 594933 | 461.47 ± 0.2% | not timed | not timed | 211.52 ± 0.3% | 32.75 ± 0.2% | not timed | not timed | 462.50 ± 0.1% | | 1.00 | 2.18 | 14.09 |
| imported/sherlock/letters | 447175 | 54.29 ± 8.5% | not timed | not timed | 32.97 ± 0.1% | 5.15 ± 20.0% | not timed | not timed | 54.32 ± 0.3% | | 1.00 | 1.65 | 10.53 |
| imported/sherlock/letters-upper | 14180 | 432.09 ± 1.0% | not timed | not timed | 371.65 ± 0.1% | 29.04 ± 30.6% | not timed | not timed | 432.82 ± 0.2% | | 1.00 | 1.16 | 14.88 |
| imported/sherlock/letters-lower | 432995 | 55.26 ± 0.5% | not timed | not timed | 33.91 ± 0.1% | 5.89 ± 11.0% | not timed | not timed | 55.43 ± 0.5% | | 1.00 | 1.63 | 9.39 |
| imported/sherlock/words | 447639 | 106.35 ± 1.5% | not timed | not timed | 83.03 ± 0.2% | 14.09 ± 7.8% | not timed | not timed | 106.81 ± 0.7% | | 1.00 | 1.28 | 7.55 |
| imported/sherlock/before-holmes | 4073 | 597.19 ± 0.3% | not timed | not timed | 8480.00 ± 0.1% | 23.75 ± 1.5% | not timed | not timed | 595.10 ± 0.3% | | 1.00 | 0.0704 | 25.14 |
| imported/sherlock/before-after-holmes | 2593 | 595.70 ± 0.1% | not timed | not timed | 9507.47 ± 0.4% | 24.10 ± 2.5% | not timed | not timed | 597.14 ± 0.2% | | 1.00 | 0.0627 | 24.72 |
| imported/sherlock/holmes-cochar-watson | 150 | 5215.84 ± 0.3% | not timed | not timed | 3424.38 ± 0.0% | 30.98 ± 0.1% | not timed | not timed | 5227.91 ± 0.3% | | 1.00 | 1.52 | 168.38 |
| imported/sherlock/holmes-coword-watson | 14309 | 1261.18 ± 2.9% | not timed | not timed | 1121.00 ± 0.1% | 6.78 ± 0.2% | not timed | not timed | 1259.15 ± 4.9% | | 1.00 | 1.13 | 186.07 |
| imported/sherlock/quotes | 14437 | 1401.72 ± 0.2% | not timed | not timed | 1757.02 ± 0.5% | 34.96 ± 0.3% | not timed | not timed | 1410.50 ± 0.3% | | 0.99 | 0.80 | 40.09 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 600.09 ± 0.3% | not timed | not timed | 16035.00 ± 0.4% | 36.72 ± 0.3% | not timed | not timed | 599.35 ± 1.0% | | 1.00 | 0.0374 | 16.34 |
| imported/sherlock/word-ending-n | 35297 | 467.58 ± 1.0% | not timed | not timed | 409.02 ± 0.1% | 23.48 ± 20.7% | not timed | not timed | 466.17 ± 0.2% | | 1.00 | 1.14 | 19.91 |
| imported/sherlock/repeated-class-negation | 2130 | 14618.27 ± 0.6% | not timed | not timed | 10995.51 ± 0.5% | 11.57 ± 0.2% | not timed | not timed | 14584.10 ± 0.6% | | 1.00 | 1.33 | 1263.86 |
| imported/sherlock/ing-suffix | 20547 | 553.39 ± 0.5% | not timed | not timed | 515.62 ± 0.2% | 28.72 ± 0.1% | not timed | not timed | 552.13 ± 0.6% | | 1.00 | 1.07 | 19.27 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 592.00 ± 1.3% | not timed | not timed | 2099.93 ± 0.3% | 20.48 ± 18.8% | not timed | not timed | 593.53 ± 0.2% | | 1.00 | 0.28 | 28.91 |
| opt/accelerate/whole-line | 239963 | 458.07 ± 0.4% | not timed | not timed | 372.54 ± 0.5% | 92.23 ± 16.4% | not timed | not timed | 458.30 ± 0.5% | | 1.00 | 1.23 | 4.97 |
| opt/accelerate/non-dna | 16745 | 412.79 ± 1.3% | not timed | not timed | 400.70 ± 0.2% | 29.39 ± 16.7% | not timed | not timed | 411.81 ± 0.4% | | 1.00 | 1.03 | 14.04 |
| opt/backtrack/words-english | 40536 | 135.73 ± 2.0% | not timed | not timed | 94.16 ± 0.1% | 19.81 ± 6.8% | not timed | not timed | 137.00 ± 0.1% | | 0.99 | 1.44 | 6.85 |
| opt/fixed-length/too-small-ascii | 0 | 311.90 ± 0.3% | not timed | not timed | 705.65 ± 4.0% | 79.53 ± 0.7% | not timed | not timed | 309.65 ± 0.2% | | 1.01 | 0.44 | 3.92 |
| opt/fixed-length/too-big-ascii | 0 | 645.87 ± 0.3% | not timed | not timed | 5824.96 ± 0.6% | 125.46 ± 2.9% | not timed | not timed | 653.08 ± 0.6% | | 0.99 | 0.11 | 5.15 |
| opt/fixed-length/go33484-1 | 0 | 44.87 ± 1.0% | not timed | not timed | 1107146.39 ± 0.3% | 61314.39 ± 1.0% | not timed | not timed | 44.82 ± 0.4% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5518.01 ± 0.3% | not timed | not timed | 1105955.52 ± 0.1% | 32271.39 ± 0.7% | not timed | not timed | 5513.54 ± 0.1% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1751.11 ± 1.6% | not timed | not timed | 111096.75 ± 0.2% | 763.25 ± 0.1% | not timed | not timed | 1758.50 ± 1.7% | | 1.00 | 0.0158 | 2.29 |
| opt/literal-alt/one-pattern | 1 | 551.28 ± 0.3% | not timed | not timed | 539.62 ± 0.3% | 0.40 ± 0.5% | not timed | not timed | 555.30 ± 0.5% | | 0.99 | 1.02 | 1383.52 |
| opt/onepass/fn-predicate | 916 | 366.18 ± 0.5% | not timed | not timed | 330.21 ± 0.1% | 202.43 ± 11.6% | not timed | not timed | 369.63 ± 0.8% | | 0.99 | 1.11 | 1.81 |
| opt/onepass/first-three-words-english | 35128 | 148.77 ± 2.1% | not timed | not timed | 201.33 ± 0.2% | 82.43 ± 12.7% | not timed | not timed | 149.53 ± 1.6% | | 0.99 | 0.74 | 1.80 |
| opt/prefilter/literal-english | 1 | 20849.88 ± 0.5% | not timed | not timed | 20133.25 ± 0.3% | 17598.90 ± 0.2% | not timed | not timed | 20852.26 ± 0.2% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14537.38 ± 0.4% | not timed | not timed | 4308.97 ± 0.2% | 32.64 ± 0.2% | not timed | not timed | 14555.05 ± 0.4% | | 1.00 | 3.37 | 445.32 |
| opt/prefilter/literal-russian | 1 | 21425.00 ± 0.4% | not timed | not timed | 20029.07 ± 0.6% | 3305.82 ± 0.5% | not timed | not timed | 21440.20 ± 0.6% | | 1.00 | 1.07 | 6.48 |
| opt/prefilter/literal-casei-russian | 1 | 8565.83 ± 0.6% | not timed | not timed | 3885.15 ± 0.4% | 30.82 ± 0.2% | not timed | not timed | 8578.43 ± 0.4% | | 1.00 | 2.20 | 277.97 |
| opt/prefilter/rust-functions | 948 | 6785.30 ± 1.8% | not timed | not timed | 9003.27 ± 0.4% | 1860.02 ± 27.8% | not timed | not timed | 6795.57 ± 0.5% | | 1.00 | 0.75 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 5563.19 ± 0.2% | not timed | not timed | 20857916.24 ± 0.2% | 49.93 ± 0.2% | not timed | not timed | 5563.99 ± 0.2% | | 1.00 | 0.0003 | 111.41 |
| opt/reverse-inner/holmes | 2593 | 595.82 ± 0.3% | not timed | not timed | 9501.34 ± 0.5% | 23.92 ± 1.1% | not timed | not timed | 596.91 ± 0.2% | | 1.00 | 0.0627 | 24.91 |
| opt/reverse-inner/email | 47 | 1043.21 ± 0.4% | not timed | not timed | 44464.90 ± 1.3% | 32.30 ± 0.4% | not timed | not timed | 1042.98 ± 0.1% | | 1.00 | 0.0235 | 32.29 |
| opt/reverse-inner/factored-prefix | 3542 | 589.64 ± 0.3% | not timed | not timed | 594.32 ± 0.1% | 12.53 ± 0.2% | not timed | not timed | 591.76 ± 0.3% | | 1.00 | 0.99 | 47.05 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5504.58 ± 0.1% | not timed | not timed | 613.13 ± 0.2% | 75.16 ± 0.1% | not timed | not timed | 5513.92 ± 0.0% | | 1.00 | 8.98 | 73.24 |
| opt/reverse-inner/no-quadratic-forward | 0 | 686.12 ± 2.0% | not timed | not timed | 288.30 ± 0.3% | 24.78 ± 6.9% | not timed | not timed | 687.87 ± 2.1% | | 1.00 | 2.38 | 27.69 |
| opt/reverse-suffix/holmes | 4073 | 597.44 ± 0.2% | not timed | not timed | 8450.17 ± 0.5% | 22.76 ± 0.8% | not timed | not timed | 595.62 ± 0.4% | | 1.00 | 0.0707 | 26.25 |
| opt/reverse-suffix/no-quadratic | 0 | 5513.95 ± 0.1% | not timed | not timed | 610.98 ± 0.1% | 75.01 ± 0.1% | not timed | not timed | 5502.95 ± 0.1% | | 1.00 | 9.02 | 73.51 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.14 ± 1.8% | not timed | not timed | 132.82 ± 0.1% | 13.04 ± 15.1% | not timed | not timed | 120.90 ± 3.3% | | 1.00 | 0.91 | 9.29 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 118.75 ± 9.0% | not timed | not timed | 134.42 ± 0.2% | 13.22 ± 13.5% | not timed | not timed | 120.71 ± 0.5% | | 0.98 | 0.88 | 8.98 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.2% | not timed | not timed | 0.55 ± 0.1% | 113.18 ± 0.2% | not timed | not timed | 0.28 ± 0.3% | | 1.00 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 316.84 ± 0.2% | not timed | not timed | 292.72 ± 0.1% | 103.02 ± 11.6% | not timed | not timed | 309.39 ± 0.8% | | 1.02 | 1.08 | 3.08 |
| reported/i13-subset-regex/original-ascii | 4094 | 10910.42 ± 1.8% | not timed | not timed | 4456.71 ± 1.2% | 11.49 ± 0.1% | not timed | not timed | 10960.17 ± 1.7% | | 1.00 | 2.45 | 949.49 |
| reported/i13-subset-regex/original-unicode | 4094 | 10875.96 ± 2.4% | not timed | not timed | 250.83 ± 3.5% | 11.49 ± 0.1% | not timed | not timed | 11031.50 ± 1.9% | | 0.99 | 43.36 | 946.49 |
| reported/i13-subset-regex/big-ascii | 1955 | 10628.78 ± 1.7% | not timed | not timed | 67.93 ± 3.6% | 9.83 ± 0.1% | not timed | not timed | 10687.45 ± 1.1% | | 0.99 | 156.47 | 1081.46 |
| reported/i13-subset-regex/big-unicode | 1955 | 10598.10 ± 1.4% | not timed | not timed | 12.21 ± 54.9% | 9.82 ± 0.1% | not timed | not timed | 10686.86 ± 1.3% | | 0.99 | 868.28 | 1078.92 |
| reported/i13-subset-regex/huge-ascii | 55 | 10098.14 ± 4.1% | not timed | not timed | 11.01 ± 0.1% | 8.75 ± 0.1% | not timed | not timed | 10081.08 ± 3.6% | | 1.00 | 917.53 | 1154.12 |
| reported/i13-subset-regex/huge-unicode | 55 | 9924.68 ± 2.8% | not timed | not timed | 10.99 ± 0.4% | 8.60 ± 0.2% | not timed | not timed | 9861.33 ± 3.9% | | 1.01 | 903.18 | 1154.40 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.0% | not timed | not timed | 11.08 ± 0.2% | 8.64 ± 0.3% | not timed | not timed | 3.54 ± 0.0% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.0% | not timed | not timed | 10.95 ± 0.3% | 8.74 ± 1.0% | not timed | not timed | 5.03 ± 0.1% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 469.60 ± 0.5% | not timed | not timed | 104.77 ± 0.2% | 6.58 ± 0.1% | not timed | not timed | 468.26 ± 0.4% | | 1.00 | 4.48 | 71.41 |
| reported/i787-keywords/opt-ascii | 5674 | 470.36 ± 0.1% | not timed | not timed | 271.28 ± 0.2% | 10.26 ± 0.1% | not timed | not timed | 469.87 ± 0.5% | | 1.00 | 1.73 | 45.83 |
| slow/quadratic-regex-1x | 100 | 6.95 ± 0.2% | not timed | not timed | 4.95 ± 0.5% | 0.05 ± 0.3% | not timed | not timed | 6.95 ± 0.3% | | 1.00 | 1.40 | 141.33 |
| slow/quadratic-regex-2x | 199 | 3.39 ± 0.1% | not timed | not timed | 2.76 ± 0.1% | 0.01 ± 0.2% | not timed | not timed | 3.40 ± 0.3% | | 1.00 | 1.23 | 266.38 |
| slow/quadratic-haystack-1x | 100 | 20.99 ± 6.7% | not timed | not timed | 10.07 ± 0.2% | 1.01 ± 12.5% | not timed | not timed | 21.06 ± 1.6% | | 1.00 | 2.08 | 20.75 |
| slow/quadratic-haystack-2x | 200 | 17.43 ± 1.4% | not timed | not timed | 5.55 ± 0.1% | 0.55 ± 12.2% | not timed | not timed | 17.49 ± 0.5% | | 1.00 | 3.14 | 31.92 |
| unicode/codepoints/any-one | 1112064 | 286.11 ± 0.5% | not timed | not timed | 175.92 ± 0.3% | 18.55 ± 2.6% | not timed | not timed | 285.71 ± 0.5% | | 1.00 | 1.63 | 15.42 |
| unicode/codepoints/any-all | 4382592 | 288.83 ± 0.3% | not timed | not timed | 246.63 ± 0.1% | 117.05 ± 0.2% | not timed | not timed | 288.93 ± 0.3% | | 1.00 | 1.17 | 2.47 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.76 ± 0.7% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 609.47 ± 0.2% | not timed | not timed | 615.64 ± 0.3% | 135.21 ± 0.1% | not timed | not timed | 609.73 ± 0.3% | | 1.00 | 0.99 | 4.51 |
| unicode/overlapping-words/ascii | 6156 | 31.05 ± 0.3% | not timed | not timed | 38.89 ± 0.2% | 3.90 ± 1.3% | not timed | not timed | 31.14 ± 0.3% | | 1.00 | 0.80 | 7.95 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 0.1% | not timed | not timed | 2.99 ± 0.2% | 2.35 ± 1.1% | not timed | not timed | 1.35 ± 0.1% | | 1.00 | 0.45 | 0.57 |
| unicode/overlapping-words/russian | 5710 | 1.21 ± 9.5% | not timed | not timed | 2.85 ± 0.4% | 6.28 ± 9.7% | not timed | not timed | 1.22 ± 0.3% | | 1.00 | 0.43 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 116.34 ± 7.0% | not timed | not timed | 82.55 ± 0.2% | 11.58 ± 23.7% | not timed | not timed | 116.94 ± 1.7% | | 0.99 | 1.41 | 10.05 |
| unicode/word/boundary-long-english | 3466 | 605.64 ± 0.2% | not timed | not timed | 602.87 ± 0.2% | 32.36 ± 0.7% | not timed | not timed | 515.80 ± 1.4% | | 1.17 | 1.00 | 18.72 |
| unicode/word/around-holmes-english | 27 | 601.86 ± 0.2% | not timed | not timed | 19824.30 ± 0.7% | 22.07 ± 0.6% | not timed | not timed | 602.34 ± 0.3% | | 1.00 | 0.0304 | 27.27 |
| wild/bibleref/long | 874 | 564.07 ± 0.1% | not timed | not timed | 581.17 ± 0.2% | 6.79 ± 0.2% | not timed | not timed | 565.43 ± 0.2% | | 1.00 | 0.97 | 83.03 |
| wild/bibleref/short | 30 | 24.82 ± 4.5% | not timed | not timed | 30.96 ± 0.3% | 13.89 ± 10.3% | not timed | not timed | 25.66 ± 3.1% | | 0.97 | 0.80 | 1.79 |
| wild/bibleref/line | 874 | 356.09 ± 3.5% | not timed | not timed | 218.80 ± 0.3% | 9.21 ± 8.3% | not timed | not timed | 357.30 ± 0.4% | | 1.00 | 1.63 | 38.67 |
| wild/caddy/caddy | 6 | 415.78 ± 7.4% | not timed | not timed | 244.85 ± 0.1% | 67.20 ± 10.9% | not timed | not timed | 417.52 ± 1.0% | | 1.00 | 1.70 | 6.19 |
| wild/dot-star-capture/rust-src-tools | 6 | 1056.56 ± 0.3% | not timed | not timed | 344.67 ± 0.3% | 13.48 ± 0.3% | not timed | not timed | 1055.85 ± 0.3% | | 1.00 | 3.07 | 78.40 |
| wild/ruff/noqa | 84 | 403.50 ± 0.1% | not timed | not timed | 466.04 ± 0.1% | 19.59 ± 3.5% | not timed | not timed | 402.87 ± 0.3% | | 1.00 | 0.87 | 20.60 |
| wild/ruff/unnecessary-coding-comment | 16 | 488.96 ± 0.7% | not timed | not timed | 703.60 ± 0.1% | 135.48 ± 11.3% | not timed | not timed | 488.22 ± 0.8% | | 1.00 | 0.69 | 3.61 |
| wild/ruff/string-quote-prefix | 2972 | 405.19 ± 0.6% | not timed | not timed | 441.47 ± 0.1% | 315.18 ± 25.2% | not timed | not timed | 406.34 ± 0.7% | | 1.00 | 0.92 | 1.29 |
| wild/ruff/space-around-operator | 1224378 | 217.00 ± 1.8% | not timed | not timed | 186.38 ± 0.1% | 18.42 ± 2.5% | not timed | not timed | 216.87 ± 1.8% | | 1.00 | 1.16 | 11.78 |
| wild/ruff/shebang | 282 | 399.97 ± 0.7% | not timed | not timed | 328.35 ± 0.1% | 117.97 ± 9.6% | not timed | not timed | 400.51 ± 0.5% | | 1.00 | 1.22 | 3.39 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13808.31 ± 0.3% | not timed | not timed | 13853.36 ± 0.4% | 6906.98 ± 0.6% | not timed | not timed | 13805.91 ± 0.2% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12807.84 ± 0.5% | not timed | not timed | 13527.92 ± 0.3% | 6387.76 ± 0.7% | not timed | not timed | 12812.46 ± 0.4% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13161.21 ± 0.9% | not timed | not timed | 13660.01 ± 0.4% | 6579.95 ± 1.0% | not timed | not timed | 13164.35 ± 0.5% | | 1.00 | 0.96 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9535.20 ± 0.3% | not timed | not timed | 13655.71 ± 0.2% | 6713.74 ± 1.7% | not timed | not timed | 9536.97 ± 0.2% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 122.27 ± 12.8% | not timed | not timed | 65.54 ± 0.5% | 2.20 ± 0.8% | not timed | not timed | 122.07 ± 13.6% | | 1.00 | 1.87 | 55.46 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 45.9% | not timed | not timed | 0.01 ± 0.3% | 0.01 ± 6.3% | not timed | not timed | 0.03 ± 1.3% | | 0.99 | 3.12 | 4.14 |
| dictionary/compile/english-15 | 1 | 0.35 ± 27.7% | not timed | not timed | 0.07 ± 0.5% | 0.11 ± 11.6% | not timed | not timed | 0.35 ± 0.9% | | 0.99 | 5.09 | 3.27 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 18.2% | not timed | not timed | 0.02 ± 0.8% | 34.59 ± 17.1% | not timed | not timed | 0.25 ± 4.5% | | 0.96 | 12.78 | 0.0070 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.15 ± 4.6% | not timed | not timed | 11.51 ± 0.3% | 59.55 ± 16.9% | not timed | not timed | 47.54 ± 2.5% | | 0.99 | 4.10 | 0.79 |
| reported/i787-keywords/compile | 1 | 34.51 ± 4.5% | not timed | not timed | 2.12 ± 0.5% | 16.40 ± 37.4% | not timed | not timed | 35.63 ± 0.6% | | 0.97 | 16.29 | 2.10 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 365.02 ± 1.6% | not timed | not timed | 117.28 ± 0.2% | 562.67 ± 8.9% | not timed | not timed | 370.44 ± 1.8% | | 0.99 | 3.11 | 0.65 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.11 ± 8.1% | not timed | not timed | 4.07 ± 0.6% | 43.44 ± 20.8% | not timed | not timed | 47.95 ± 1.9% | | 0.98 | 11.58 | 1.08 |
| unicode/compile/one-letter | 53 | 6.71 ± 11.3% | not timed | not timed | 4.59 ± 0.3% | 64.58 ± 2.2% | not timed | not timed | 6.76 ± 14.3% | | 0.99 | 1.46 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.07 ± 19.0% | not timed | not timed | 0.10 ± 0.3% | 67.81 ± 11.7% | not timed | not timed | 1.10 ± 19.9% | | 0.97 | 10.75 | 0.0158 |
| unicode/compile/fifty-letters-ascii | 1 | 220.75 ± 12.9% | not timed | not timed | 51.62 ± 0.2% | 198.78 ± 15.3% | not timed | not timed | 223.37 ± 6.3% | | 0.99 | 4.28 | 1.11 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 389.98 ± 25.9% | not timed | not timed | 46.48 ± 0.3% | 665.98 ± 22.9% | not timed | not timed | 395.30 ± 2.6% | | 0.99 | 8.39 | 0.59 |
| unicode/compile/match-every-line-ascii | 4 | 617.30 ± 23.4% | not timed | not timed | 145.10 ± 0.1% | 667.16 ± 27.5% | not timed | not timed | 634.49 ± 2.9% | | 0.97 | 4.25 | 0.93 |
| unicode/compile/negated-class-matches-codepoint | 1 | 333.00 ± 16.0% | not timed | not timed | 49.12 ± 0.3% | 1285.36 ± 25.2% | not timed | not timed | 338.51 ± 8.0% | | 0.98 | 6.78 | 0.26 |
| wild/bibleref/compile | 3 | 5.75 ± 21.4% | not timed | not timed | 1.95 ± 0.3% | 32.34 ± 13.7% | not timed | not timed | 5.94 ± 21.9% | | 0.97 | 2.95 | 0.18 |
| wild/url/compile | 1 | 0.65 ± 20.0% | not timed | not timed | 0.14 ± 0.4% | 0.45 ± 30.0% | not timed | not timed | 0.66 ± 18.1% | | 0.99 | 4.51 | 1.45 |

