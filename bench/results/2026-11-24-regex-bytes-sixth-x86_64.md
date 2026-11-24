# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
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
| literal: a word | 217 | 25146.28 ± 0.8% | 3198.48 ± 0.6% | 25.22 ± 2.1% | 23051.76 ± 0.5% | 8804.57 ± 8.1% | 11.72 ± 1.3% | 81.72 ± 1.2% | 25142.09 ± 0.5% | 7.86 | 1.00 | 1.09 | 2.86 |
| literal: a word that is not there | 0 | 28860.30 ± 1.0% | 3148.16 ± 0.5% | 25.27 ± 2.1% | 25253.61 ± 0.2% | 28637.81 ± 3.6% | 11.38 ± 0.2% | 77.83 ± 1.4% | 28842.74 ± 1.0% | 9.17 | 1.00 | 1.14 | 1.01 |
| literal: one of four words | 661 | 9942.79 ± 2.7% | 1509.33 ± 0.6% | 14.27 ± 1.1% | 7573.12 ± 1.3% | 22.53 ± 0.5% | 3.40 ± 0.2% | 5.88 ± 0.1% | 9970.59 ± 2.8% | 6.59 | 1.00 | 1.31 | 441.29 |
| literal: a word in any case | 217 | 21959.91 ± 1.0% | 1615.94 ± 3.6% | 18.38 ± 1.1% | 7724.29 ± 3.1% | 42.85 ± 3.2% | refused | differs | 21936.04 ± 4.3% | 13.59 | 1.00 | 2.84 | 512.52 |
| literal: an href attribute | 33 | 21697.21 ± 2.3% | 499.06 ± 0.2% | 22.49 ± 1.3% | 20820.07 ± 1.3% | 2005.31 ± 2.0% | 8.32 ± 0.6% | 73.22 ± 1.5% | 21758.87 ± 0.8% | 43.48 | 1.00 | 1.04 | 10.82 |
| literal: a word, second text | 123 | 26077.50 ± 0.3% | 2406.19 ± 0.6% | 25.50 ± 1.4% | 22967.43 ± 0.6% | 6889.79 ± 4.4% | 15.27 ± 0.9% | 70.53 ± 1.1% | 26067.64 ± 0.5% | 10.84 | 1.00 | 1.14 | 3.78 |
| class: two capitalized words | 1331 | 759.17 ± 0.6% | 490.24 ± 0.1% | 24.09 ± 2.8% | 472.84 ± 0.3% | 37.59 ± 7.6% | 9.92 ± 0.3% | 60.65 ± 1.0% | 759.29 ± 0.4% | 1.55 | 1.00 | 1.61 | 20.19 |
| class: a word that ends in ing | 3399 | 465.31 ± 0.3% | 464.29 ± 0.7% | 15.49 ± 2.4% | 444.41 ± 0.4% | 26.75 ± 7.0% | 5.61 ± 0.7% | 16.53 ± 0.3% | 465.53 ± 0.6% | 1.00 | 1.00 | 1.05 | 17.40 |
| class: a word in capitals | 2332 | 1025.12 ± 0.4% | 494.87 ± 0.3% | 25.33 ± 2.2% | 465.97 ± 0.4% | 40.75 ± 1.7% | 12.01 ± 1.1% | 76.90 ± 0.2% | 1025.88 ± 0.9% | 2.07 | 1.00 | 2.20 | 25.16 |
| class: a number | 8288 | 1582.44 ± 1.7% | 670.92 ± 0.3% | 24.89 ± 1.3% | 1620.20 ± 0.8% | 41.35 ± 14.8% | 0.33 ± 0.2% | 56.05 ± 0.9% | 1583.49 ± 0.5% | 2.36 | 1.00 | 0.98 | 38.27 |
| class: two capitalized words, second text | 5359 | 412.89 ± 0.1% | 419.24 ± 3.9% | 21.74 ± 1.0% | 392.10 ± 3.5% | 31.24 ± 10.3% | 13.03 ± 0.4% | 55.07 ± 0.2% | 412.62 ± 1.5% | 0.98 | 1.00 | 1.05 | 13.21 |
| other: a word between two words | 6104 | 678.34 ± 0.3% | 474.41 ± 0.7% | 21.28 ± 0.8% | 669.06 ± 0.4% | 99.65 ± 7.3% | 7.58 ± 0.3% | 63.71 ± 0.2% | 679.32 ± 0.3% | 1.43 | 1.00 | 1.01 | 6.81 |
| other: a number before a unit, second text | 1481 | 6770.34 ± 3.6% | 888.12 ± 3.2% | 24.45 ± 1.8% | 6958.36 ± 0.8% | 38.11 ± 4.9% | 13.74 ± 3.0% | 57.50 ± 3.7% | 6804.08 ± 4.9% | 7.62 | 1.00 | 0.97 | 177.64 |
| other: a heading's start tag | 110 | 15794.47 ± 0.3% | 605.43 ± 0.3% | 24.33 ± 4.0% | 2039.00 ± 1.1% | 1485.39 ± 4.8% | 10.35 ± 5.5% | 85.75 ± 0.8% | 15776.42 ± 0.6% | 26.09 | 1.00 | 7.75 | 10.63 |
| other: a whole word | 217 | 18701.04 ± 0.6% | 492.92 ± 0.2% | 25.40 ± 1.2% | 18550.84 ± 0.4% | 44.22 ± 0.6% | 9.89 ± 0.1% | 47.11 ± 0.8% | 18731.42 ± 0.2% | 37.94 | 1.00 | 1.01 | 422.95 |
| other: a line's first word, second text | 3716 | 1945.23 ± 0.6% | 476.83 ± 0.1% | 27.15 ± 1.7% | 1892.17 ± 3.7% | 62.03 ± 5.7% | refused | refused | 1947.30 ± 1.0% | 4.08 | 1.00 | 1.03 | 31.36 |
| other: fourteen octets before an x | 87 | 27273.56 ± 2.7% | 242.20 ± 0.2% | 5.79 ± 0.3% | 3303.42 ± 0.6% | 8.87 ± 1.1% | differs | 15.25 ± 1.0% | 27690.26 ± 3.4% | 112.61 | 0.98 | 8.26 | 3076.31 |
| other: a Greek word | 21815 | 408.99 ± 0.5% | 320.58 ± 0.7% | 28.53 ± 0.8% | 241.99 ± 0.2% | 43.75 ± 3.2% | differs | refused | 408.91 ± 0.7% | 1.28 | 1.00 | 1.69 | 9.35 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 17.65 ± 0.4% | 17.66 ± 1.4% | 0.83 ± 1.0% | 16.43 ± 0.5% | 2.44 ± 0.8% | differs | 3.61 ± 0.3% | 17.67 ± 0.2% | 1.00 | 1.00 | 1.07 | 7.24 |
| a UUID | 32895 | 20.03 ± 0.3% | 20.05 ± 4.0% | 0.56 ± 0.4% | 12.68 ± 0.5% | 2.43 ± 0.7% | 0.55 ± 0.5% | 3.09 ± 0.2% | 20.04 ± 0.6% | 1.00 | 1.00 | 1.58 | 8.24 |
| an IPv4 address | 33176 | 29.22 ± 0.5% | 29.20 ± 1.3% | 1.81 ± 0.5% | 24.16 ± 0.8% | 5.86 ± 0.8% | differs | 3.41 ± 0.3% | 29.27 ± 1.0% | 1.00 | 1.00 | 1.21 | 4.99 |
| a date and time | 32954 | 28.91 ± 0.5% | 28.87 ± 0.2% | 1.30 ± 2.4% | 18.38 ± 0.4% | 7.61 ± 0.8% | 1.01 ± 0.3% | 6.63 ± 0.7% | 28.90 ± 0.2% | 1.00 | 1.00 | 1.57 | 3.80 |
| a field path | 32606 | 19.94 ± 0.4% | 19.89 ± 0.2% | 0.93 ± 1.9% | 18.90 ± 0.4% | 2.74 ± 0.8% | differs | 2.32 ± 0.5% | 19.92 ± 2.1% | 1.00 | 1.00 | 1.06 | 7.29 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.65 ± 4.0% | 9.67 ± 7.4% | 9.68 ± 0.5% | 11.53 ± 0.5% | 4.89 ± 5.7% | 0.79 ± 0.8% | none | 9.69 ± 0.5% | 1.00 | 1.00 | 0.84 | 1.97 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 225.33 ± 1.2% | 225.66 ± 0.7% | 264.73 ± 0.3% | 85.94 ± 3.9% | 191.30 ± 27.2% | 543.52 ± 2.0% | 3134.16 ± 4.6% | 225.49 ± 0.5% | 1.00 | 1.00 | 2.62 | 1.18 |
| a UUID | 62 | 148.98 ± 0.5% | 149.17 ± 0.3% | 166.49 ± 0.5% | 45.73 ± 2.5% | 89.36 ± 1.6% | 191.97 ± 5.3% | 3885.96 ± 1.1% | 148.63 ± 1.3% | 1.00 | 1.00 | 3.26 | 1.67 |
| an IPv4 address | 29 | 440.65 ± 5.4% | 446.17 ± 0.2% | 618.78 ± 0.3% | 73.70 ± 1.1% | 117.22 ± 19.1% | 330.88 ± 3.2% | 6199.54 ± 1.8% | 440.85 ± 0.4% | 0.99 | 1.00 | 5.98 | 3.76 |
| a date and time | 56 | 331.24 ± 8.4% | 334.42 ± 3.4% | 421.58 ± 0.1% | 71.62 ± 1.2% | 114.82 ± 22.1% | 347.37 ± 0.9% | 4126.09 ± 0.3% | 330.76 ± 2.5% | 0.99 | 1.00 | 4.63 | 2.88 |
| a field path | 39 | 222.31 ± 4.3% | 223.32 ± 0.6% | 260.53 ± 2.7% | 78.20 ± 2.0% | 182.11 ± 18.3% | 550.15 ± 1.0% | 3987.91 ± 1.3% | 222.06 ± 0.8% | 1.00 | 1.00 | 2.84 | 1.22 |
| literal: a word | 7 | 654.03 ± 1.8% | 708.71 ± 2.7% | 1246.32 ± 2.4% | 521.46 ± 0.6% | 603.01 ± 1.8% | 1132.25 ± 6.0% | 25032.48 ± 1.0% | 652.67 ± 0.6% | 0.92 | 1.00 | 1.25 | 1.08 |
| literal: a word that is not there | 8 | 629.68 ± 0.7% | 689.05 ± 0.4% | 1174.77 ± 1.1% | 478.66 ± 1.5% | 576.35 ± 5.9% | 1062.17 ± 2.9% | 23707.86 ± 1.2% | 629.85 ± 1.9% | 0.91 | 1.00 | 1.32 | 1.09 |
| literal: one of four words | 26 | 252.91 ± 1.9% | 416.81 ± 0.7% | 562.94 ± 0.9% | 38.15 ± 1.0% | 225.82 ± 3.4% | 398.37 ± 1.5% | 12108.87 ± 0.9% | 253.83 ± 0.3% | 0.61 | 1.00 | 6.63 | 1.12 |
| literal: a word in any case | 11 | 461.23 ± 2.3% | 497.06 ± 0.4% | 709.42 ± 4.0% | 12.66 ± 5.7% | 623.72 ± 8.5% | refused | 18739.57 ± 2.4% | 461.88 ± 1.8% | 0.93 | 1.00 | 36.43 | 0.74 |
| literal: an href attribute | 12 | 346.29 ± 0.2% | 359.34 ± 0.5% | 470.83 ± 0.5% | 37.52 ± 0.3% | 462.51 ± 2.7% | 912.32 ± 5.6% | 17331.21 ± 1.4% | 346.59 ± 0.7% | 0.96 | 1.00 | 9.23 | 0.75 |
| literal: a word, second text | 10 | 579.33 ± 1.2% | 644.97 ± 0.8% | 1055.19 ± 0.5% | 444.65 ± 3.1% | 501.71 ± 1.8% | 931.54 ± 0.9% | 21653.23 ± 1.8% | 581.19 ± 0.7% | 0.90 | 1.00 | 1.30 | 1.15 |
| class: two capitalized words | 23 | 486.42 ± 0.2% | 526.07 ± 0.4% | 782.69 ± 0.4% | 103.12 ± 0.5% | 464.55 ± 2.4% | 866.23 ± 1.1% | 5498.50 ± 0.8% | 485.68 ± 0.9% | 0.92 | 1.00 | 4.72 | 1.05 |
| class: a word that ends in ing | 9 | 579.13 ± 2.2% | 668.24 ± 4.2% | 1173.59 ± 2.0% | 133.04 ± 3.0% | 686.72 ± 1.9% | 1352.63 ± 0.3% | 13572.95 ± 0.6% | 577.81 ± 7.2% | 0.87 | 1.00 | 4.35 | 0.84 |
| class: a word in capitals | 16 | 528.26 ± 0.8% | 574.78 ± 0.7% | 944.89 ± 0.2% | 137.30 ± 0.9% | 689.07 ± 1.7% | 1255.23 ± 7.9% | 7393.03 ± 1.2% | 529.53 ± 0.4% | 0.92 | 1.00 | 3.85 | 0.77 |
| class: a number | 6 | 647.47 ± 0.4% | 727.89 ± 0.2% | 1366.57 ± 0.4% | 34.07 ± 1.2% | 1240.94 ± 2.8% | 2340.89 ± 1.9% | 19904.81 ± 1.3% | 647.76 ± 0.8% | 0.89 | 1.00 | 19.00 | 0.52 |
| class: two capitalized words, second text | 23 | 484.27 ± 5.2% | 528.33 ± 3.1% | 783.11 ± 1.0% | 101.97 ± 0.8% | 466.06 ± 15.0% | 866.89 ± 1.8% | 5491.09 ± 1.9% | 486.13 ± 0.6% | 0.92 | 1.00 | 4.75 | 1.04 |
| other: a word between two words | 13 | 567.52 ± 0.4% | 592.85 ± 0.6% | 936.07 ± 0.3% | 135.43 ± 0.5% | 463.11 ± 1.9% | 936.64 ± 1.9% | 12064.92 ± 0.8% | 567.98 ± 0.4% | 0.96 | 1.00 | 4.19 | 1.23 |
| other: a number before a unit, second text | 15 | 409.55 ± 0.5% | 456.65 ± 0.4% | 642.32 ± 0.1% | 32.32 ± 0.9% | 576.28 ± 1.4% | 1067.84 ± 2.9% | 12448.91 ± 1.1% | 408.40 ± 0.6% | 0.90 | 1.00 | 12.67 | 0.71 |
| other: a heading's start tag | 13 | 359.92 ± 1.1% | 369.70 ± 0.6% | 484.00 ± 1.1% | 36.73 ± 0.8% | 556.92 ± 18.1% | 1003.25 ± 1.2% | 14231.38 ± 1.2% | 360.37 ± 0.3% | 0.97 | 1.00 | 9.80 | 0.65 |
| other: a whole word | 11 | 590.16 ± 1.5% | 634.22 ± 0.3% | 1029.17 ± 0.9% | 119.62 ± 0.8% | 533.45 ± 2.4% | 967.94 ± 0.6% | 20659.05 ± 4.0% | 589.61 ± 7.4% | 0.93 | 1.00 | 4.93 | 1.11 |
| other: a line's first word, second text | 17 | 553.09 ± 6.3% | 590.83 ± 1.0% | 964.90 ± 0.5% | 130.01 ± 0.3% | 635.35 ± 1.8% | refused | refused | 554.95 ± 1.0% | 0.94 | 1.00 | 4.25 | 0.87 |
| other: fourteen octets before an x | 16 | 102.59 ± 0.7% | 144.48 ± 1.0% | 169.08 ± 0.6% | 14.04 ± 0.5% | 410.97 ± 12.5% | 456.13 ± 0.4% | 11070.44 ± 1.1% | 102.60 ± 0.5% | 0.71 | 1.00 | 7.31 | 0.25 |
| other: a Greek word | 8 | 442.09 ± 0.7% | 603.53 ± 0.7% | 1027.64 ± 0.3% | 46.65 ± 1.5% | 1228.40 ± 2.9% | 2210.44 ± 1.0% | refused | 442.64 ± 0.9% | 0.73 | 1.00 | 9.48 | 0.36 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20736.78 ± 2.9% | not timed | not timed | 20197.37 ± 0.9% | 1911.69 ± 14.4% | not timed | not timed | 20752.57 ± 0.3% | | 1.00 | 1.03 | 10.85 |
| 01-literal/sherlock-casei-en | 522 | 17229.93 ± 1.7% | not timed | not timed | 6512.94 ± 0.3% | 29.02 ± 1.1% | not timed | not timed | 17095.23 ± 1.9% | | 1.01 | 2.65 | 593.78 |
| 01-literal/sherlock-ru | 724 | 20595.22 ± 0.6% | not timed | not timed | 20375.86 ± 0.4% | 1098.28 ± 4.2% | not timed | not timed | 21022.65 ± 0.7% | | 0.98 | 1.01 | 18.75 |
| 01-literal/sherlock-casei-ru | 746 | 8429.53 ± 0.2% | not timed | not timed | 5125.55 ± 0.6% | 31.33 ± 10.3% | not timed | not timed | 8655.60 ± 0.4% | | 0.97 | 1.64 | 269.03 |
| 01-literal/sherlock-zh | 30 | 27119.32 ± 0.3% | not timed | not timed | 24335.89 ± 0.3% | 1226.17 ± 0.1% | not timed | not timed | 27120.86 ± 0.6% | | 1.00 | 1.11 | 22.12 |
| 02-literal-alternate/sherlock-en | 714 | 9247.66 ± 1.4% | not timed | not timed | 7211.42 ± 0.4% | 16.86 ± 0.4% | not timed | not timed | 9224.15 ± 1.4% | | 1.00 | 1.28 | 548.56 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1751.05 ± 2.1% | not timed | not timed | 1861.22 ± 0.3% | 9.94 ± 4.7% | not timed | not timed | 1766.41 ± 1.6% | | 0.99 | 0.94 | 176.24 |
| 02-literal-alternate/sherlock-ru | 899 | 7439.55 ± 0.8% | not timed | not timed | 3925.38 ± 1.0% | 22.27 ± 0.5% | not timed | not timed | 7537.88 ± 1.5% | | 0.99 | 1.90 | 334.06 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1816.63 ± 1.4% | not timed | not timed | 955.93 ± 0.7% | 8.50 ± 0.5% | not timed | not timed | 1827.39 ± 1.2% | | 0.99 | 1.90 | 213.70 |
| 02-literal-alternate/sherlock-zh | 207 | 12560.97 ± 0.5% | not timed | not timed | 8235.07 ± 0.5% | 31.92 ± 0.7% | not timed | not timed | 12577.43 ± 0.3% | | 1.00 | 1.53 | 393.48 |
| 03-date/ascii | 111817 | 97.76 ± 0.8% | not timed | not timed | 85.65 ± 0.6% | 0.19 ± 1.8% | not timed | not timed | 97.91 ± 3.2% | | 1.00 | 1.14 | 525.53 |
| 04-ruff-noqa/real | 84 | 426.32 ± 0.7% | not timed | not timed | 433.69 ± 0.4% | 19.12 ± 0.2% | not timed | not timed | 426.40 ± 0.7% | | 1.00 | 0.98 | 22.30 |
| 04-ruff-noqa/tweaked | 44 | 505.12 ± 0.9% | not timed | not timed | 431.72 ± 0.4% | 305.06 ± 13.3% | not timed | not timed | 502.16 ± 1.5% | | 1.01 | 1.17 | 1.66 |
| 05-lexer-veryl/single | 124800 | 4.27 ± 2.9% | not timed | not timed | 4.30 ± 0.6% | 0.20 ± 4.7% | not timed | not timed | 4.29 ± 3.3% | | 1.00 | 0.99 | 21.26 |
| 06-cloud-flare-redos/original | 107 | 365.13 ± 0.7% | not timed | not timed | 190.05 ± 1.1% | 23.74 ± 1.3% | not timed | not timed | 365.20 ± 0.3% | | 1.00 | 1.92 | 15.38 |
| 06-cloud-flare-redos/simplified-short | 102 | 356.32 ± 0.5% | not timed | not timed | 172.80 ± 0.8% | 24.26 ± 0.6% | not timed | not timed | 356.34 ± 1.1% | | 1.00 | 2.06 | 14.69 |
| 06-cloud-flare-redos/simplified-long | 10000 | 429.96 ± 0.7% | not timed | not timed | 206.50 ± 1.7% | 27.82 ± 0.5% | not timed | not timed | 430.90 ± 0.1% | | 1.00 | 2.08 | 15.45 |
| 07-unicode-character-data/parse-line | 558784 | 220.99 ± 0.4% | not timed | not timed | 162.28 ± 0.4% | 37.74 ± 1.3% | not timed | not timed | 221.61 ± 0.7% | | 1.00 | 1.36 | 5.86 |
| 08-words/all-english | 56691 | 87.01 ± 1.1% | not timed | not timed | 71.83 ± 1.0% | 10.48 ± 10.4% | not timed | not timed | 87.15 ± 0.5% | | 1.00 | 1.21 | 8.30 |
| 08-words/long-english | 839 | 498.80 ± 0.4% | not timed | not timed | 479.79 ± 0.3% | 28.56 ± 1.4% | not timed | not timed | 499.05 ± 0.3% | | 1.00 | 1.04 | 17.47 |
| 09-aws-keys/full | 0 | 435.74 ± 0.3% | not timed | not timed | 444.01 ± 1.3% | 58.63 ± 0.5% | not timed | not timed | 435.22 ± 0.6% | | 1.00 | 0.98 | 7.43 |
| 09-aws-keys/quick | 0 | 926.64 ± 0.5% | not timed | not timed | 722.02 ± 0.6% | 345.21 ± 1.6% | not timed | not timed | 925.66 ± 0.7% | | 1.00 | 1.28 | 2.68 |
| 10-bounded-repeat/letters-en | 1833 | 510.46 ± 4.5% | not timed | not timed | 439.98 ± 0.5% | 18.42 ± 1.6% | not timed | not timed | 508.80 ± 4.7% | | 1.00 | 1.16 | 27.71 |
| 10-bounded-repeat/letters-ru | 3475 | 422.26 ± 1.2% | not timed | not timed | 393.74 ± 1.7% | 20.12 ± 7.4% | not timed | not timed | 422.99 ± 0.9% | | 1.00 | 1.07 | 20.99 |
| 10-bounded-repeat/context | 53 | 74.01 ± 2.0% | not timed | not timed | 57.95 ± 0.8% | 18.50 ± 0.9% | not timed | not timed | 74.05 ± 5.4% | | 1.00 | 1.28 | 4.00 |
| 10-bounded-repeat/capitals | 11 | 516.13 ± 8.0% | not timed | not timed | 489.59 ± 0.7% | 34.33 ± 2.2% | not timed | not timed | 515.68 ± 7.9% | | 1.00 | 1.05 | 15.04 |
| 11-unstructured-to-json/extract | 600 | 39.12 ± 4.4% | not timed | not timed | 62.23 ± 3.7% | 47.87 ± 4.3% | not timed | not timed | 39.99 ± 5.6% | | 0.98 | 0.63 | 0.82 |
| 12-dictionary/single | 1 | 442.73 ± 0.4% | not timed | not timed | 421.81 ± 0.5% | 0.36 ± 1.3% | not timed | not timed | 442.71 ± 0.4% | | 1.00 | 1.05 | 1228.27 |
| 14-quadratic/1x | 100 | 22.70 ± 0.6% | not timed | not timed | 10.57 ± 1.1% | 0.94 ± 3.3% | not timed | not timed | 22.74 ± 1.4% | | 1.00 | 2.15 | 24.27 |
| 14-quadratic/2x | 200 | 17.51 ± 1.0% | not timed | not timed | 5.15 ± 0.4% | 0.52 ± 7.3% | not timed | not timed | 17.51 ± 1.2% | | 1.00 | 3.40 | 33.88 |
| 14-quadratic/10x | 1000 | 5.56 ± 0.2% | not timed | not timed | 1.00 ± 0.1% | 0.12 ± 1.3% | not timed | not timed | 5.56 ± 0.7% | | 1.00 | 5.58 | 48.36 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.18 ± 2.6% | not timed | not timed | 0.33 ± 1.3% | 0.49 ± 5.3% | not timed | not timed | 1.18 ± 3.0% | | 1.01 | 3.59 | 2.39 |
| 04-ruff-noqa/compile-real | 1 | 112.49 ± 2.2% | not timed | not timed | 11.73 ± 0.6% | 126.89 ± 3.4% | not timed | not timed | 113.01 ± 0.5% | | 1.00 | 9.59 | 0.89 |
| 05-lexer-veryl/compile-single | 1 | 14.58 ± 1.7% | not timed | not timed | 2.23 ± 1.3% | 5.92 ± 1.3% | not timed | not timed | 14.60 ± 1.3% | | 1.00 | 6.55 | 2.46 |
| 07-unicode-character-data/compile | 1 | 116.67 ± 1.1% | not timed | not timed | 24.03 ± 0.4% | 32.89 ± 2.1% | not timed | not timed | 116.39 ± 1.4% | | 1.00 | 4.85 | 3.55 |
| 09-aws-keys/compile-full | 1 | 47.20 ± 3.6% | not timed | not timed | 6.72 ± 3.0% | 20.40 ± 12.0% | not timed | not timed | 47.94 ± 1.4% | | 0.98 | 7.02 | 2.31 |
| 09-aws-keys/compile-quick | 1 | 174.78 ± 10.1% | not timed | not timed | 45.02 ± 12.3% | 122.36 ± 1.1% | not timed | not timed | 175.91 ± 1.8% | | 0.99 | 3.88 | 1.43 |
| 10-bounded-repeat/compile-context | 1 | 47.68 ± 3.0% | not timed | not timed | 10.64 ± 0.7% | 15.50 ± 1.4% | not timed | not timed | 48.17 ± 1.0% | | 0.99 | 4.48 | 3.08 |
| 10-bounded-repeat/compile-capitals | 1 | 66.45 ± 1.8% | not timed | not timed | 7.91 ± 0.9% | 22.52 ± 2.1% | not timed | not timed | 67.17 ± 0.8% | | 0.99 | 8.40 | 2.95 |
| 11-unstructured-to-json/compile | 1 | 177.36 ± 1.2% | not timed | not timed | 37.18 ± 3.3% | 61.13 ± 4.0% | not timed | not timed | 177.48 ± 3.5% | | 1.00 | 4.77 | 2.90 |
| 12-dictionary/compile-single | 1 | 0.28 ± 13.6% | not timed | not timed | 0.06 ± 6.6% | 0.09 ± 13.1% | not timed | not timed | 0.28 ± 0.9% | | 0.98 | 4.72 | 3.18 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 5.97 ± 3.4% | not timed | not timed | 6.03 ± 1.2% | 0.60 ± 17.3% | not timed | not timed | 5.96 ± 3.4% | | 1.00 | 0.99 | 9.99 |
| dictionary/search/english-10 | 690 | 1.10 ± 1.4% | not timed | not timed | 95.69 ± 0.5% | 0.01 ± 0.4% | not timed | not timed | 1.11 ± 0.3% | | 0.99 | 0.0115 | 182.30 |
| dictionary/search/english-15 | 15 | 441.10 ± 2.7% | not timed | not timed | 420.48 ± 0.4% | 0.35 ± 0.8% | not timed | not timed | 441.50 ± 0.8% | | 1.00 | 1.05 | 1277.35 |
| folly/awyer-inn-busted | 1 | 3408.25 ± 0.2% | not timed | not timed | 104.37 ± 0.9% | 40.54 ± 0.7% | not timed | not timed | 3411.88 ± 0.2% | | 1.00 | 32.66 | 84.07 |
| folly/literal-never-match-rare | 0 | 23912.28 ± 0.9% | not timed | not timed | 21633.41 ± 0.5% | 27854.06 ± 0.5% | not timed | not timed | 23873.08 ± 0.3% | | 1.00 | 1.11 | 0.86 |
| folly/literal-never-match-frequent | 0 | 14228.40 ± 1.3% | not timed | not timed | 21636.49 ± 0.2% | 2019.19 ± 1.4% | not timed | not timed | 14218.97 ± 1.3% | | 1.00 | 0.66 | 7.05 |
| folly/literal-never-match-tricksy | 1 | 3233.89 ± 2.6% | not timed | not timed | 4055.05 ± 33.4% | 1255.60 ± 0.2% | not timed | not timed | 3239.21 ± 0.5% | | 1.00 | 0.80 | 2.58 |
| grep/every-line | 239963 | 1117.25 ± 1.3% | not timed | not timed | 717.46 ± 2.7% | 311.12 ± 33.1% | not timed | not timed | 1117.69 ± 1.8% | | 1.00 | 1.56 | 3.59 |
| grep/long-words-ascii | 5073 | 418.69 ± 0.7% | not timed | not timed | 400.73 ± 0.3% | 39.99 ± 6.5% | not timed | not timed | 419.38 ± 1.4% | | 1.00 | 1.04 | 10.47 |
| imported/leipzig/twain | 811 | 22566.27 ± 13.8% | not timed | not timed | 21290.63 ± 0.6% | 9793.36 ± 6.7% | not timed | not timed | 22608.07 ± 0.3% | | 1.00 | 1.06 | 2.30 |
| imported/leipzig/twain-insensitive | 965 | 10251.80 ± 2.6% | not timed | not timed | 8674.49 ± 1.9% | 38.95 ± 1.4% | not timed | not timed | 10291.03 ± 1.9% | | 1.00 | 1.18 | 263.18 |
| imported/leipzig/shing | 1540 | 509.35 ± 0.4% | not timed | not timed | 13415.64 ± 0.5% | 31.10 ± 2.3% | not timed | not timed | 509.35 ± 0.3% | | 1.00 | 0.0380 | 16.38 |
| imported/leipzig/huck-saw | 262 | 14020.18 ± 2.6% | not timed | not timed | 13460.38 ± 2.7% | 32.46 ± 0.8% | not timed | not timed | 14353.35 ± 8.4% | | 0.98 | 1.04 | 431.89 |
| imported/leipzig/word-ending-nn | 262 | 493.63 ± 0.2% | not timed | not timed | 490.95 ± 0.6% | 22.09 ± 0.6% | not timed | not timed | 493.58 ± 0.6% | | 1.00 | 1.01 | 22.35 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 8764.81 ± 2.3% | not timed | not timed | 3441.25 ± 0.7% | 9.42 ± 0.4% | not timed | not timed | 8983.18 ± 2.6% | | 0.98 | 2.55 | 930.45 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 12350.05 ± 3.2% | not timed | not timed | 12287.04 ± 0.8% | 17.37 ± 0.5% | not timed | not timed | 12607.60 ± 3.8% | | 0.98 | 1.01 | 710.82 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4403.61 ± 3.0% | not timed | not timed | 770.40 ± 1.2% | 9.84 ± 0.6% | not timed | not timed | 4417.30 ± 6.7% | | 1.00 | 5.72 | 447.45 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 493.27 ± 0.3% | not timed | not timed | 490.51 ± 0.4% | 10.90 ± 0.5% | not timed | not timed | 491.95 ± 0.5% | | 1.00 | 1.01 | 45.24 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 492.61 ± 0.2% | not timed | not timed | 489.89 ± 0.6% | 9.03 ± 0.5% | not timed | not timed | 492.88 ± 0.2% | | 1.00 | 1.01 | 54.57 |
| imported/leipzig/tom-river | 2 | 8922.17 ± 4.3% | not timed | not timed | 10082.67 ± 1.5% | 31.40 ± 0.6% | not timed | not timed | 9208.48 ± 15.5% | | 0.97 | 0.88 | 284.14 |
| imported/leipzig/ing | 78424 | 487.94 ± 1.2% | not timed | not timed | 458.88 ± 1.4% | 25.69 ± 3.5% | not timed | not timed | 486.45 ± 1.0% | | 1.00 | 1.06 | 19.00 |
| imported/leipzig/ing-whitespace | 55248 | 613.26 ± 0.8% | not timed | not timed | 1710.19 ± 0.5% | 18.63 ± 2.1% | not timed | not timed | 610.65 ± 1.1% | | 1.00 | 0.36 | 32.92 |
| imported/leipzig/awyer-inn | 209 | 629.78 ± 2.9% | not timed | not timed | 8601.17 ± 0.8% | 20.93 ± 1.1% | not timed | not timed | 630.76 ± 1.5% | | 1.00 | 0.0732 | 30.09 |
| imported/leipzig/quotes-bounded | 8886 | 1598.36 ± 2.7% | not timed | not timed | 2613.46 ± 3.9% | 34.66 ± 2.6% | not timed | not timed | 1602.21 ± 2.3% | | 1.00 | 0.61 | 46.11 |
| imported/leipzig/non-ascii-alternate | 2 | 17275.99 ± 5.8% | not timed | not timed | 13850.70 ± 0.7% | 45.75 ± 3.3% | not timed | not timed | 17739.23 ± 3.9% | | 0.97 | 1.25 | 377.58 |
| imported/leipzig/math-symbols | 69 | 1942.15 ± 1.4% | not timed | not timed | 495.05 ± 0.8% | 33.55 ± 0.5% | not timed | not timed | 1957.40 ± 1.6% | | 0.99 | 3.92 | 57.90 |
| imported/leipzig/bounded-strings-ending-z | 0 | 494.47 ± 0.2% | not timed | not timed | 491.40 ± 0.1% | 22.99 ± 0.6% | not timed | not timed | 494.40 ± 0.1% | | 1.00 | 1.01 | 21.50 |
| imported/lh3lh3-reb/uri | 17549 | 604.99 ± 0.3% | not timed | not timed | 826.13 ± 0.7% | 24.24 ± 3.9% | not timed | not timed | 605.52 ± 0.3% | | 1.00 | 0.73 | 24.96 |
| imported/lh3lh3-reb/email | 15057 | 668.20 ± 0.9% | not timed | not timed | 826.78 ± 1.6% | 25.43 ± 2.7% | not timed | not timed | 668.65 ± 0.3% | | 1.00 | 0.81 | 26.28 |
| imported/lh3lh3-reb/date | 668 | 692.99 ± 1.0% | not timed | not timed | 740.56 ± 3.2% | 42.76 ± 4.3% | not timed | not timed | 694.51 ± 0.6% | | 1.00 | 0.94 | 16.21 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 617.96 ± 1.3% | not timed | not timed | 364.77 ± 0.9% | 12.52 ± 1.3% | not timed | not timed | 619.10 ± 0.6% | | 1.00 | 1.69 | 49.36 |
| imported/mariomka/email | 92 | 569.86 ± 0.5% | not timed | not timed | 24221.01 ± 1.7% | 29.52 ± 0.3% | not timed | not timed | 570.35 ± 0.4% | | 1.00 | 0.0235 | 19.31 |
| imported/mariomka/uri | 5301 | 488.39 ± 0.5% | not timed | not timed | 5653.27 ± 0.2% | 29.97 ± 0.7% | not timed | not timed | 488.76 ± 0.3% | | 1.00 | 0.0864 | 16.29 |
| imported/mariomka/ip | 5 | 1482.13 ± 5.3% | not timed | not timed | 1882.40 ± 0.7% | 20.13 ± 2.7% | not timed | not timed | 1489.62 ± 3.5% | | 0.99 | 0.79 | 73.63 |
| imported/rsc/no-exponential | 0 | 763.73 ± 0.9% | not timed | not timed | 500.66 ± 1.0% | 20.99 ± 1.7% | not timed | not timed | 763.34 ± 0.3% | | 1.00 | 1.53 | 36.38 |
| imported/rsc/literal | 1 | 712.97 ± 10.9% | not timed | not timed | 2118.95 ± 0.6% | 210.97 ± 18.6% | not timed | not timed | 778.41 ± 10.8% | | 0.92 | 0.34 | 3.38 |
| imported/rsc/not-literal | 2 | 720.30 ± 1.5% | not timed | not timed | 1055.06 ± 1.2% | 44.20 ± 2.9% | not timed | not timed | 718.05 ± 8.6% | | 1.00 | 0.68 | 16.30 |
| imported/rsc/match-class | 1 | 1331.56 ± 1.0% | not timed | not timed | 2198.27 ± 0.4% | 50.94 ± 0.9% | not timed | not timed | 1328.65 ± 0.6% | | 1.00 | 0.61 | 26.14 |
| imported/rsc/match-class-in-range | 1 | 1324.69 ± 2.7% | not timed | not timed | 3371.30 ± 0.8% | 55.28 ± 9.5% | not timed | not timed | 1320.53 ± 1.2% | | 1.00 | 0.39 | 23.96 |
| imported/rsc/match-class-unicode | 1 | 467.52 ± 1.9% | not timed | not timed | 458.72 ± 0.5% | 60.89 ± 7.7% | not timed | not timed | 467.81 ± 0.9% | | 1.00 | 1.02 | 7.68 |
| imported/rsc/anchored-literal-short-non-match | 0 | 529.93 ± 0.6% | not timed | not timed | 1181.01 ± 5.2% | 278.33 ± 4.7% | not timed | not timed | 532.31 ± 1.3% | | 1.00 | 0.45 | 1.90 |
| imported/rsc/anchored-literal-long-non-match | 0 | 8954.82 ± 1.0% | not timed | not timed | 17759.80 ± 1.2% | 4183.78 ± 2.8% | not timed | not timed | 9001.03 ± 0.9% | | 0.99 | 0.50 | 2.14 |
| imported/rsc/anchored-literal-short-match | 4 | 428.24 ± 7.0% | not timed | not timed | 775.88 ± 1.4% | 82.78 ± 10.6% | not timed | not timed | 428.03 ± 2.7% | | 1.00 | 0.55 | 5.17 |
| imported/rsc/anchored-literal-long-match | 4 | 2418.04 ± 3.2% | not timed | not timed | 11693.97 ± 2.8% | 1193.64 ± 14.2% | not timed | not timed | 2415.04 ± 2.4% | | 1.00 | 0.21 | 2.03 |
| imported/rsc/one-pass-short | 17 | 378.07 ± 1.7% | not timed | not timed | 357.95 ± 0.9% | 30.49 ± 11.3% | not timed | not timed | 377.90 ± 14.3% | | 1.00 | 1.06 | 12.40 |
| imported/rsc/one-pass-short-not | 17 | 230.66 ± 2.1% | not timed | not timed | 347.22 ± 3.1% | 27.63 ± 12.7% | not timed | not timed | 230.79 ± 2.4% | | 1.00 | 0.66 | 8.35 |
| imported/rsc/one-pass-long-prefix | 26 | 243.68 ± 4.2% | not timed | not timed | 422.12 ± 13.1% | 91.00 ± 18.8% | not timed | not timed | 244.64 ± 2.5% | | 1.00 | 0.58 | 2.68 |
| imported/rsc/one-pass-long-prefix-not | 26 | 385.28 ± 9.7% | not timed | not timed | 422.49 ± 0.5% | 78.18 ± 27.4% | not timed | not timed | 393.16 ± 10.3% | | 0.98 | 0.91 | 4.93 |
| imported/rsc/long-needle1 | 31 | 28701.06 ± 0.7% | not timed | not timed | 25711.99 ± 0.3% | 3.64 ± 6.7% | not timed | not timed | 28721.34 ± 0.3% | | 1.00 | 1.12 | 7875.53 |
| imported/rsc/long-needle2 | 31 | 28494.38 ± 0.8% | not timed | not timed | 167.04 ± 2.2% | 3.57 ± 1.1% | not timed | not timed | 28485.54 ± 0.2% | | 1.00 | 170.59 | 7975.58 |
| imported/rsc/easy0-32 | 26 | 1129.93 ± 3.6% | not timed | not timed | 2004.28 ± 14.2% | 148.41 ± 24.1% | not timed | not timed | 1141.79 ± 10.5% | | 0.99 | 0.56 | 7.61 |
| imported/rsc/easy0-1k | 26 | 18880.49 ± 3.1% | not timed | not timed | 17580.73 ± 0.5% | 2491.91 ± 19.4% | not timed | not timed | 18898.54 ± 0.5% | | 1.00 | 1.07 | 7.58 |
| imported/rsc/easy0-32k | 26 | 36706.56 ± 0.6% | not timed | not timed | 30431.78 ± 0.7% | 19778.58 ± 0.6% | not timed | not timed | 36619.92 ± 2.0% | | 1.00 | 1.21 | 1.86 |
| imported/rsc/easy0-1mb | 26 | 29117.86 ± 0.3% | not timed | not timed | 28367.18 ± 0.9% | 38656.70 ± 0.1% | not timed | not timed | 29116.78 ± 0.9% | | 1.00 | 1.03 | 0.75 |
| imported/rsc/easy1-32 | 19 | 363.76 ± 1.5% | not timed | not timed | 1028.70 ± 0.3% | 131.12 ± 19.7% | not timed | not timed | 362.92 ± 2.4% | | 1.00 | 0.35 | 2.77 |
| imported/rsc/easy1-1k | 19 | 485.73 ± 10.3% | not timed | not timed | 20967.90 ± 1.4% | 2521.58 ± 15.6% | not timed | not timed | 485.21 ± 3.0% | | 1.00 | 0.0232 | 0.19 |
| imported/rsc/easy1-32k | 19 | 494.00 ± 0.5% | not timed | not timed | 661491.75 ± 0.9% | 21768.17 ± 14.5% | not timed | not timed | 493.95 ± 9.8% | | 1.00 | 0.0007 | 0.0227 |
| imported/rsc/easy1-1mb | 19 | 494.16 ± 0.2% | not timed | not timed | 21142342.88 ± 0.7% | 40714.04 ± 0.3% | not timed | not timed | 494.91 ± 0.1% | | 1.00 | 0.0000 | 0.0121 |
| imported/rsc/medium-32 | 27 | 450.77 ± 0.7% | not timed | not timed | 957.05 ± 1.0% | 65.75 ± 13.4% | not timed | not timed | 448.79 ± 2.1% | | 1.00 | 0.47 | 6.86 |
| imported/rsc/medium-1k | 27 | 6933.45 ± 0.3% | not timed | not timed | 17062.63 ± 0.8% | 69.22 ± 9.6% | not timed | not timed | 6940.12 ± 2.1% | | 1.00 | 0.41 | 100.16 |
| imported/rsc/medium-32k | 27 | 33254.55 ± 0.4% | not timed | not timed | 533661.63 ± 0.5% | 50.22 ± 0.3% | not timed | not timed | 33207.68 ± 0.4% | | 1.00 | 0.0623 | 662.23 |
| imported/rsc/medium-1mb | 27 | 28965.43 ± 0.3% | not timed | not timed | 16994339.91 ± 1.5% | 50.79 ± 1.1% | not timed | not timed | 28995.36 ± 0.8% | | 1.00 | 0.0017 | 570.33 |
| imported/rsc/hard-32 | 58 | 251.58 ± 3.1% | not timed | not timed | 383.97 ± 0.5% | 48.07 ± 9.6% | not timed | not timed | 251.24 ± 0.2% | | 1.00 | 0.66 | 5.23 |
| imported/rsc/hard-1k | 27 | 484.16 ± 1.0% | not timed | not timed | 15051.87 ± 0.2% | 39.57 ± 1.2% | not timed | not timed | 484.19 ± 0.1% | | 1.00 | 0.0322 | 12.23 |
| imported/rsc/hard-32k | 27 | 493.83 ± 0.3% | not timed | not timed | 464919.08 ± 8.7% | 28.14 ± 2.0% | not timed | not timed | 494.32 ± 0.2% | | 1.00 | 0.0011 | 17.55 |
| imported/rsc/hard-1mb | 51 | 494.91 ± 0.3% | not timed | not timed | 7835265.89 ± 0.6% | 28.26 ± 1.5% | not timed | not timed | 494.38 ± 0.6% | | 1.00 | 0.0001 | 17.51 |
| imported/rsc/reallyhard0-32 | 58 | 251.09 ± 0.3% | not timed | not timed | 231.17 ± 0.4% | 49.44 ± 0.9% | not timed | not timed | 250.78 ± 0.6% | | 1.00 | 1.09 | 5.08 |
| imported/rsc/reallyhard0-1k | 27 | 483.80 ± 2.5% | not timed | not timed | 482.70 ± 0.3% | 39.70 ± 9.9% | not timed | not timed | 484.43 ± 0.1% | | 1.00 | 1.00 | 12.19 |
| imported/rsc/reallyhard0-32k | 27 | 493.83 ± 0.8% | not timed | not timed | 494.67 ± 0.2% | 28.31 ± 0.9% | not timed | not timed | 493.77 ± 0.3% | | 1.00 | 1.00 | 17.44 |
| imported/rsc/reallyhard0-1mb | 51 | 494.59 ± 0.5% | not timed | not timed | 495.16 ± 0.2% | 28.34 ± 1.4% | not timed | not timed | 494.15 ± 0.6% | | 1.00 | 1.00 | 17.45 |
| imported/rsc/reallyreallyhard0-32 | 47 | 274.33 ± 15.8% | not timed | not timed | 210.95 ± 0.2% | 57.56 ± 1.5% | not timed | not timed | 275.54 ± 0.5% | | 1.00 | 1.30 | 4.77 |
| imported/rsc/reallyreallyhard0-1k | 16 | 720.16 ± 1.0% | not timed | not timed | 8078.93 ± 9.6% | 31.47 ± 0.4% | not timed | not timed | 719.37 ± 2.0% | | 1.00 | 0.0891 | 22.89 |
| imported/rsc/reallyreallyhard0-32k | 16 | 517.08 ± 4.8% | not timed | not timed | 28635.33 ± 0.4% | 23.44 ± 0.5% | not timed | not timed | 517.97 ± 5.1% | | 1.00 | 0.0181 | 22.06 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 495.12 ± 0.2% | not timed | not timed | 28302.16 ± 0.5% | 23.40 ± 0.7% | not timed | not timed | 495.26 ± 0.1% | | 1.00 | 0.0175 | 21.16 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 267.89 ± 12.6% | not timed | not timed | 208.45 ± 2.1% | 57.37 ± 2.8% | not timed | not timed | 268.59 ± 0.3% | | 1.00 | 1.29 | 4.67 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 697.10 ± 3.2% | not timed | not timed | 7731.23 ± 4.4% | 31.51 ± 4.6% | not timed | not timed | 697.22 ± 4.0% | | 1.00 | 0.0902 | 22.12 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 517.09 ± 4.9% | not timed | not timed | 28571.06 ± 0.4% | 23.44 ± 6.1% | not timed | not timed | 517.21 ± 4.6% | | 1.00 | 0.0181 | 22.06 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 494.60 ± 3.0% | not timed | not timed | 25250.48 ± 0.7% | 23.50 ± 0.9% | not timed | not timed | 494.30 ± 2.0% | | 1.00 | 0.0196 | 21.04 |
| imported/sherlock/name-sherlock | 776 | 25428.07 ± 14.3% | not timed | not timed | 23317.21 ± 0.7% | 9610.03 ± 16.3% | not timed | not timed | 25435.08 ± 0.4% | | 1.00 | 1.09 | 2.65 |
| imported/sherlock/name-holmes | 2766 | 17254.37 ± 2.4% | not timed | not timed | 18531.07 ± 1.3% | 3011.88 ± 4.8% | not timed | not timed | 17406.91 ± 2.1% | | 0.99 | 0.93 | 5.73 |
| imported/sherlock/name-sherlock-holmes | 1365 | 25478.92 ± 1.2% | not timed | not timed | 22992.21 ± 0.3% | 7775.05 ± 32.3% | not timed | not timed | 25419.64 ± 1.4% | | 1.00 | 1.11 | 3.28 |
| imported/sherlock/name-sherlock-casei | 816 | 22882.47 ± 0.5% | not timed | not timed | 7892.68 ± 0.3% | 28.81 ± 1.6% | not timed | not timed | 22898.84 ± 0.1% | | 1.00 | 2.90 | 794.32 |
| imported/sherlock/name-holmes-casei | 2802 | 14398.12 ± 2.5% | not timed | not timed | 5515.26 ± 0.6% | 39.66 ± 1.2% | not timed | not timed | 14341.08 ± 1.3% | | 1.00 | 2.61 | 363.05 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 19922.74 ± 1.5% | not timed | not timed | 7711.18 ± 0.3% | 28.97 ± 2.0% | not timed | not timed | 19863.26 ± 0.5% | | 1.00 | 2.58 | 687.71 |
| imported/sherlock/name-whitespace | 1461 | 17548.43 ± 1.5% | not timed | not timed | 18451.61 ± 0.3% | 6178.65 ± 16.1% | not timed | not timed | 17579.62 ± 2.8% | | 1.00 | 0.95 | 2.84 |
| imported/sherlock/name-alt1 | 1142 | 16277.13 ± 7.5% | not timed | not timed | 26863.25 ± 1.1% | 3863.12 ± 15.4% | not timed | not timed | 16281.97 ± 0.3% | | 1.00 | 0.61 | 4.21 |
| imported/sherlock/name-alt2 | 3542 | 10982.69 ± 1.3% | not timed | not timed | 6872.35 ± 0.4% | 31.43 ± 0.5% | not timed | not timed | 11014.27 ± 1.6% | | 1.00 | 1.60 | 349.43 |
| imported/sherlock/name-alt3 | 4507 | 8095.24 ± 4.2% | not timed | not timed | 6206.74 ± 1.9% | 10.05 ± 3.4% | not timed | not timed | 8041.50 ± 2.7% | | 1.01 | 1.30 | 805.34 |
| imported/sherlock/name-alt3-casei | 4593 | 1328.37 ± 2.1% | not timed | not timed | 1107.83 ± 7.6% | 6.11 ± 0.3% | not timed | not timed | 1325.12 ± 6.3% | | 1.00 | 1.20 | 217.56 |
| imported/sherlock/name-alt4 | 3686 | 6739.51 ± 0.4% | not timed | not timed | 6491.20 ± 0.5% | 31.35 ± 1.5% | not timed | not timed | 6747.06 ± 0.3% | | 1.00 | 1.04 | 214.99 |
| imported/sherlock/name-alt4-casei | 4254 | 2897.09 ± 3.9% | not timed | not timed | 3304.22 ± 0.8% | 17.50 ± 0.2% | not timed | not timed | 2906.31 ± 2.9% | | 1.00 | 0.88 | 165.54 |
| imported/sherlock/name-alt5 | 4028 | 9611.22 ± 0.8% | not timed | not timed | 6648.75 ± 0.3% | 22.18 ± 1.2% | not timed | not timed | 9589.29 ± 0.6% | | 1.00 | 1.45 | 433.27 |
| imported/sherlock/name-alt5-casei | 4104 | 4288.25 ± 6.9% | not timed | not timed | 2299.70 ± 12.0% | 12.69 ± 2.1% | not timed | not timed | 4353.77 ± 5.5% | | 0.98 | 1.86 | 337.83 |
| imported/sherlock/no-match-uncommon | 0 | 28867.15 ± 0.6% | not timed | not timed | 24579.08 ± 1.4% | 36393.60 ± 0.3% | not timed | not timed | 28861.93 ± 0.7% | | 1.00 | 1.17 | 0.79 |
| imported/sherlock/no-match-common | 0 | 28590.03 ± 0.2% | not timed | not timed | 24628.28 ± 0.4% | 1554.42 ± 0.3% | not timed | not timed | 28588.03 ± 1.4% | | 1.00 | 1.16 | 18.39 |
| imported/sherlock/no-match-really-common | 0 | 23563.48 ± 1.2% | not timed | not timed | 24005.79 ± 2.5% | 1550.33 ± 0.5% | not timed | not timed | 23437.04 ± 1.1% | | 1.01 | 0.98 | 15.20 |
| imported/sherlock/the-lower | 21654 | 2231.32 ± 3.2% | not timed | not timed | 1881.60 ± 0.5% | 223.58 ± 14.9% | not timed | not timed | 2239.31 ± 3.0% | | 1.00 | 1.19 | 9.98 |
| imported/sherlock/the-upper | 2223 | 13264.71 ± 1.8% | not timed | not timed | 16402.31 ± 4.6% | 2534.01 ± 3.3% | not timed | not timed | 13410.81 ± 2.1% | | 0.99 | 0.81 | 5.23 |
| imported/sherlock/the-casei | 23961 | 2012.29 ± 1.4% | not timed | not timed | 1120.13 ± 0.6% | 35.35 ± 41.8% | not timed | not timed | 2017.54 ± 2.3% | | 1.00 | 1.80 | 56.93 |
| imported/sherlock/everything-greedy | 581881 | 236.02 ± 5.4% | not timed | not timed | 144.95 ± 7.0% | 24.47 ± 16.4% | not timed | not timed | 236.93 ± 2.8% | | 1.00 | 1.63 | 9.64 |
| imported/sherlock/everything-greedy-nl | 594933 | 377.28 ± 0.2% | not timed | not timed | 187.47 ± 2.6% | 27.35 ± 1.3% | not timed | not timed | 377.53 ± 0.2% | | 1.00 | 2.01 | 13.79 |
| imported/sherlock/letters | 447175 | 46.10 ± 0.4% | not timed | not timed | 32.72 ± 3.5% | 5.43 ± 24.6% | not timed | not timed | 45.69 ± 1.6% | | 1.01 | 1.41 | 8.49 |
| imported/sherlock/letters-upper | 14180 | 352.75 ± 2.5% | not timed | not timed | 309.93 ± 0.3% | 25.07 ± 23.8% | not timed | not timed | 353.72 ± 0.4% | | 1.00 | 1.14 | 14.07 |
| imported/sherlock/letters-lower | 432995 | 46.58 ± 3.9% | not timed | not timed | 33.56 ± 0.6% | 6.26 ± 41.5% | not timed | not timed | 46.42 ± 1.3% | | 1.00 | 1.39 | 7.44 |
| imported/sherlock/words | 447639 | 85.02 ± 0.7% | not timed | not timed | 72.43 ± 0.9% | 12.38 ± 19.4% | not timed | not timed | 84.85 ± 0.9% | | 1.00 | 1.17 | 6.87 |
| imported/sherlock/before-holmes | 4073 | 488.87 ± 0.1% | not timed | not timed | 11387.06 ± 1.8% | 21.45 ± 6.5% | not timed | not timed | 489.16 ± 0.6% | | 1.00 | 0.0429 | 22.79 |
| imported/sherlock/before-after-holmes | 2593 | 490.96 ± 0.2% | not timed | not timed | 12060.92 ± 4.3% | 21.45 ± 0.6% | not timed | not timed | 490.77 ± 0.2% | | 1.00 | 0.0407 | 22.89 |
| imported/sherlock/holmes-cochar-watson | 150 | 7345.64 ± 1.0% | not timed | not timed | 5640.31 ± 1.9% | 31.72 ± 0.7% | not timed | not timed | 7348.43 ± 0.5% | | 1.00 | 1.30 | 231.60 |
| imported/sherlock/holmes-coword-watson | 14309 | 1015.39 ± 1.0% | not timed | not timed | 1007.86 ± 0.3% | 6.27 ± 0.5% | not timed | not timed | 1016.41 ± 4.3% | | 1.00 | 1.01 | 161.90 |
| imported/sherlock/quotes | 14437 | 1084.43 ± 1.0% | not timed | not timed | 1620.96 ± 3.2% | 31.37 ± 0.6% | not timed | not timed | 1084.24 ± 1.1% | | 1.00 | 0.67 | 34.57 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 492.99 ± 0.3% | not timed | not timed | 19916.16 ± 0.3% | 36.90 ± 0.8% | not timed | not timed | 492.95 ± 1.5% | | 1.00 | 0.0248 | 13.36 |
| imported/sherlock/word-ending-n | 35297 | 367.49 ± 2.4% | not timed | not timed | 334.29 ± 1.6% | 20.49 ± 22.2% | not timed | not timed | 367.38 ± 2.1% | | 1.00 | 1.10 | 17.93 |
| imported/sherlock/repeated-class-negation | 2130 | 13747.43 ± 4.6% | not timed | not timed | 14255.61 ± 3.2% | 9.51 ± 0.9% | not timed | not timed | 13852.69 ± 4.6% | | 0.99 | 0.96 | 1445.55 |
| imported/sherlock/ing-suffix | 20547 | 451.33 ± 0.5% | not timed | not timed | 421.61 ± 1.8% | 25.78 ± 1.1% | not timed | not timed | 450.09 ± 0.7% | | 1.00 | 1.07 | 17.51 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 482.65 ± 0.7% | not timed | not timed | 2026.17 ± 5.1% | 18.46 ± 0.8% | not timed | not timed | 483.28 ± 0.8% | | 1.00 | 0.24 | 26.15 |
| opt/accelerate/whole-line | 239963 | 424.19 ± 0.8% | not timed | not timed | 340.08 ± 4.2% | 86.87 ± 15.6% | not timed | not timed | 424.94 ± 0.2% | | 1.00 | 1.25 | 4.88 |
| opt/accelerate/non-dna | 16745 | 362.59 ± 0.9% | not timed | not timed | 388.00 ± 0.3% | 24.75 ± 13.3% | not timed | not timed | 364.16 ± 0.2% | | 1.00 | 0.93 | 14.65 |
| opt/backtrack/words-english | 40536 | 119.22 ± 2.0% | not timed | not timed | 95.66 ± 6.4% | 18.09 ± 8.8% | not timed | not timed | 119.28 ± 2.7% | | 1.00 | 1.25 | 6.59 |
| opt/fixed-length/too-small-ascii | 0 | 311.34 ± 0.9% | not timed | not timed | 744.70 ± 2.6% | 103.43 ± 1.8% | not timed | not timed | 310.89 ± 1.1% | | 1.00 | 0.42 | 3.01 |
| opt/fixed-length/too-big-ascii | 0 | 749.73 ± 0.2% | not timed | not timed | 6319.19 ± 2.2% | 129.43 ± 0.7% | not timed | not timed | 749.53 ± 0.5% | | 1.00 | 0.12 | 5.79 |
| opt/fixed-length/go33484-1 | 0 | 58.58 ± 0.3% | not timed | not timed | 1224762.85 ± 5.3% | 68369.20 ± 1.9% | not timed | not timed | 58.61 ± 6.5% | | 1.00 | 0.0000 | 0.0009 |
| opt/fixed-length/go33484-2 | 0 | 3379.25 ± 0.2% | not timed | not timed | 1213108.11 ± 10.5% | 36051.65 ± 9.2% | not timed | not timed | 3378.14 ± 0.2% | | 1.00 | 0.0028 | 0.0937 |
| opt/fixed-length/go33484-3 | 0 | 1428.71 ± 0.7% | not timed | not timed | 121210.46 ± 4.6% | 853.94 ± 0.6% | not timed | not timed | 1332.07 ± 0.3% | | 1.07 | 0.0118 | 1.67 |
| opt/literal-alt/one-pattern | 1 | 501.95 ± 0.5% | not timed | not timed | 503.94 ± 0.2% | 0.36 ± 0.7% | not timed | not timed | 502.04 ± 0.2% | | 1.00 | 1.00 | 1378.12 |
| opt/onepass/fn-predicate | 916 | 367.50 ± 1.5% | not timed | not timed | 336.69 ± 5.4% | 189.51 ± 57.8% | not timed | not timed | 366.18 ± 2.2% | | 1.00 | 1.09 | 1.94 |
| opt/onepass/first-three-words-english | 35128 | 127.28 ± 4.6% | not timed | not timed | 189.89 ± 5.7% | 64.58 ± 16.7% | not timed | not timed | 128.76 ± 0.6% | | 0.99 | 0.67 | 1.97 |
| opt/prefilter/literal-english | 1 | 28335.58 ± 0.4% | not timed | not timed | 25314.16 ± 0.3% | 18549.36 ± 0.7% | not timed | not timed | 28343.40 ± 0.5% | | 1.00 | 1.12 | 1.53 |
| opt/prefilter/literal-casei-english | 1 | 22474.08 ± 1.4% | not timed | not timed | 9136.60 ± 0.3% | 29.19 ± 2.2% | not timed | not timed | 22395.02 ± 0.4% | | 1.00 | 2.46 | 769.89 |
| opt/prefilter/literal-russian | 1 | 29313.85 ± 0.2% | not timed | not timed | 25522.58 ± 0.3% | 1477.24 ± 1.8% | not timed | not timed | 29338.11 ± 0.2% | | 1.00 | 1.15 | 19.84 |
| opt/prefilter/literal-casei-russian | 1 | 16729.32 ± 0.7% | not timed | not timed | 7214.03 ± 0.4% | 31.97 ± 6.6% | not timed | not timed | 16723.90 ± 0.3% | | 1.00 | 2.32 | 523.36 |
| opt/prefilter/rust-functions | 948 | 9843.77 ± 1.5% | not timed | not timed | 8760.29 ± 0.8% | 1585.87 ± 0.8% | not timed | not timed | 9838.53 ± 4.6% | | 1.00 | 1.12 | 6.21 |
| opt/reverse-anchored/word-end | 1 | 3417.05 ± 0.2% | not timed | not timed | 29293961.56 ± 0.5% | 50.95 ± 1.0% | not timed | not timed | 3420.73 ± 0.2% | | 1.00 | 0.0001 | 67.07 |
| opt/reverse-inner/holmes | 2593 | 490.55 ± 1.4% | not timed | not timed | 11980.70 ± 2.2% | 20.89 ± 0.4% | not timed | not timed | 490.78 ± 0.4% | | 1.00 | 0.0409 | 23.48 |
| opt/reverse-inner/email | 47 | 838.85 ± 0.3% | not timed | not timed | 28894.46 ± 0.5% | 29.48 ± 0.6% | not timed | not timed | 842.70 ± 0.2% | | 1.00 | 0.0290 | 28.45 |
| opt/reverse-inner/factored-prefix | 3542 | 484.67 ± 0.5% | not timed | not timed | 481.38 ± 0.9% | 11.19 ± 2.9% | not timed | not timed | 484.20 ± 4.6% | | 1.00 | 1.01 | 43.33 |
| opt/reverse-inner/no-quadratic-backward | 0 | 3375.95 ± 1.6% | not timed | not timed | 495.37 ± 0.5% | 67.46 ± 3.9% | not timed | not timed | 3377.69 ± 0.3% | | 1.00 | 6.82 | 50.04 |
| opt/reverse-inner/no-quadratic-forward | 0 | 577.20 ± 4.7% | not timed | not timed | 228.49 ± 0.4% | 25.42 ± 2.6% | not timed | not timed | 576.39 ± 4.7% | | 1.00 | 2.53 | 22.70 |
| opt/reverse-suffix/holmes | 4073 | 488.94 ± 0.3% | not timed | not timed | 11396.58 ± 2.2% | 21.23 ± 1.8% | not timed | not timed | 489.67 ± 0.3% | | 1.00 | 0.0429 | 23.03 |
| opt/reverse-suffix/no-quadratic | 0 | 3373.37 ± 0.4% | not timed | not timed | 495.21 ± 0.5% | 68.57 ± 3.2% | not timed | not timed | 3376.18 ± 0.5% | | 1.00 | 6.81 | 49.20 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 109.07 ± 9.0% | not timed | not timed | 158.82 ± 9.8% | 12.89 ± 18.1% | not timed | not timed | 109.14 ± 3.1% | | 1.00 | 0.69 | 8.46 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 110.35 ± 2.5% | not timed | not timed | 160.62 ± 11.1% | 13.13 ± 16.2% | not timed | not timed | 111.02 ± 1.9% | | 0.99 | 0.69 | 8.41 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.29 ± 13.2% | not timed | not timed | 0.47 ± 0.2% | 96.76 ± 0.6% | not timed | not timed | 0.29 ± 0.6% | | 1.00 | 0.62 | 0.0030 |
| reported/i1095-word-repetition/ascii-search | 256 | 261.90 ± 0.2% | not timed | not timed | 247.71 ± 2.3% | 91.64 ± 14.5% | not timed | not timed | 260.83 ± 2.8% | | 1.00 | 1.06 | 2.86 |
| reported/i13-subset-regex/original-ascii | 4094 | 8794.00 ± 2.8% | not timed | not timed | 3417.06 ± 3.3% | 9.47 ± 0.9% | not timed | not timed | 8971.30 ± 3.5% | | 0.98 | 2.57 | 928.18 |
| reported/i13-subset-regex/original-unicode | 4094 | 8737.93 ± 3.0% | not timed | not timed | 190.45 ± 3.5% | 9.47 ± 0.4% | not timed | not timed | 8738.89 ± 3.0% | | 1.00 | 45.88 | 923.12 |
| reported/i13-subset-regex/big-ascii | 1955 | 8227.16 ± 2.4% | not timed | not timed | 50.79 ± 2.9% | 8.28 ± 0.5% | not timed | not timed | 8214.61 ± 3.8% | | 1.00 | 161.99 | 993.22 |
| reported/i13-subset-regex/big-unicode | 1955 | 8182.54 ± 2.3% | not timed | not timed | 9.10 ± 55.3% | 8.28 ± 0.6% | not timed | not timed | 8183.19 ± 2.7% | | 1.00 | 899.15 | 988.04 |
| reported/i13-subset-regex/huge-ascii | 55 | 7584.79 ± 3.5% | not timed | not timed | 8.61 ± 0.1% | 7.86 ± 0.6% | not timed | not timed | 7603.49 ± 2.9% | | 1.00 | 880.81 | 965.24 |
| reported/i13-subset-regex/huge-unicode | 55 | 7495.71 ± 2.7% | not timed | not timed | 8.54 ± 0.5% | 7.85 ± 1.0% | not timed | not timed | 7528.56 ± 2.5% | | 1.00 | 877.68 | 955.08 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.43 ± 0.4% | not timed | not timed | 8.62 ± 0.8% | 7.87 ± 0.5% | not timed | not timed | 3.43 ± 1.3% | | 1.00 | 0.40 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.60 ± 0.7% | not timed | not timed | 8.12 ± 0.3% | 7.86 ± 1.2% | not timed | not timed | 4.67 ± 0.3% | | 0.99 | 0.57 | 0.59 |
| reported/i787-keywords/ascii | 5674 | 393.68 ± 1.0% | not timed | not timed | 112.85 ± 5.2% | 6.24 ± 0.4% | not timed | not timed | 394.89 ± 1.5% | | 1.00 | 3.49 | 63.14 |
| reported/i787-keywords/opt-ascii | 5674 | 394.58 ± 1.3% | not timed | not timed | 233.54 ± 0.5% | 9.87 ± 2.4% | not timed | not timed | 393.50 ± 1.0% | | 1.00 | 1.69 | 39.96 |
| slow/quadratic-regex-1x | 100 | 7.18 ± 0.7% | not timed | not timed | 5.30 ± 0.6% | 0.05 ± 1.2% | not timed | not timed | 7.17 ± 0.7% | | 1.00 | 1.36 | 148.58 |
| slow/quadratic-regex-2x | 199 | 3.12 ± 0.4% | not timed | not timed | 2.59 ± 0.3% | 0.01 ± 1.6% | not timed | not timed | 3.12 ± 0.3% | | 1.00 | 1.21 | 256.34 |
| slow/quadratic-haystack-1x | 100 | 22.69 ± 1.8% | not timed | not timed | 10.56 ± 0.4% | 0.97 ± 15.8% | not timed | not timed | 22.76 ± 2.1% | | 1.00 | 2.15 | 23.47 |
| slow/quadratic-haystack-2x | 200 | 17.55 ± 2.5% | not timed | not timed | 5.14 ± 2.3% | 0.50 ± 6.4% | not timed | not timed | 17.54 ± 0.6% | | 1.00 | 3.41 | 35.17 |
| unicode/codepoints/any-one | 1112064 | 300.37 ± 1.1% | not timed | not timed | 233.90 ± 14.4% | 14.69 ± 1.7% | not timed | not timed | 301.71 ± 0.6% | | 1.00 | 1.28 | 20.45 |
| unicode/codepoints/any-all | 4382592 | 229.59 ± 0.2% | not timed | not timed | 223.47 ± 0.4% | 108.92 ± 0.9% | not timed | not timed | 229.20 ± 0.8% | | 1.00 | 1.03 | 2.11 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.40 ± 2.2% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 494.01 ± 0.5% | not timed | not timed | 494.95 ± 0.5% | 134.22 ± 1.4% | not timed | not timed | 494.65 ± 0.5% | | 1.00 | 1.00 | 3.68 |
| unicode/overlapping-words/ascii | 6156 | 25.45 ± 4.4% | not timed | not timed | 39.09 ± 2.0% | 3.91 ± 6.5% | not timed | not timed | 25.49 ± 4.6% | | 1.00 | 0.65 | 6.51 |
| unicode/overlapping-words/english | 6156 | 1.14 ± 1.4% | not timed | not timed | 1.97 ± 0.6% | 2.24 ± 1.5% | not timed | not timed | 1.30 ± 0.4% | | 0.88 | 0.58 | 0.51 |
| unicode/overlapping-words/russian | 5710 | 1.15 ± 21.9% | not timed | not timed | 1.85 ± 0.3% | 5.73 ± 2.9% | not timed | not timed | 1.21 ± 0.7% | | 0.95 | 0.62 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 87.31 ± 0.8% | not timed | not timed | 72.04 ± 1.0% | 10.20 ± 8.8% | not timed | not timed | 87.72 ± 2.6% | | 1.00 | 1.21 | 8.56 |
| unicode/word/boundary-long-english | 3466 | 495.60 ± 0.3% | not timed | not timed | 487.40 ± 0.3% | 28.36 ± 0.3% | not timed | not timed | 495.19 ± 0.4% | | 1.00 | 1.02 | 17.48 |
| unicode/word/around-holmes-english | 27 | 493.80 ± 0.3% | not timed | not timed | 25215.12 ± 0.1% | 18.94 ± 1.8% | not timed | not timed | 494.21 ± 0.6% | | 1.00 | 0.0196 | 26.07 |
| wild/bibleref/long | 874 | 462.15 ± 0.4% | not timed | not timed | 471.29 ± 0.1% | 5.47 ± 5.7% | not timed | not timed | 462.10 ± 0.9% | | 1.00 | 0.98 | 84.51 |
| wild/bibleref/short | 30 | 18.85 ± 9.0% | not timed | not timed | 29.04 ± 7.9% | 13.40 ± 8.1% | not timed | not timed | 19.13 ± 4.0% | | 0.99 | 0.65 | 1.41 |
| wild/bibleref/line | 874 | 394.11 ± 0.3% | not timed | not timed | 208.52 ± 2.0% | 8.00 ± 0.7% | not timed | not timed | 392.26 ± 0.8% | | 1.00 | 1.89 | 49.26 |
| wild/caddy/caddy | 6 | 400.35 ± 4.5% | not timed | not timed | 228.28 ± 0.6% | 64.56 ± 17.7% | not timed | not timed | 403.61 ± 2.4% | | 0.99 | 1.75 | 6.20 |
| wild/dot-star-capture/rust-src-tools | 6 | 928.17 ± 8.5% | not timed | not timed | 282.77 ± 1.0% | 12.83 ± 70.0% | not timed | not timed | 951.35 ± 13.9% | | 0.98 | 3.28 | 72.33 |
| wild/ruff/noqa | 84 | 426.36 ± 1.8% | not timed | not timed | 436.88 ± 0.7% | 19.02 ± 2.6% | not timed | not timed | 426.55 ± 2.5% | | 1.00 | 0.98 | 22.41 |
| wild/ruff/unnecessary-coding-comment | 16 | 470.50 ± 0.7% | not timed | not timed | 564.65 ± 0.5% | 120.86 ± 13.2% | not timed | not timed | 470.46 ± 0.9% | | 1.00 | 0.83 | 3.89 |
| wild/ruff/string-quote-prefix | 2972 | 431.79 ± 0.7% | not timed | not timed | 407.31 ± 0.2% | 261.39 ± 24.2% | not timed | not timed | 430.98 ± 0.8% | | 1.00 | 1.06 | 1.65 |
| wild/ruff/space-around-operator | 1224378 | 196.08 ± 3.2% | not timed | not timed | 188.31 ± 2.3% | 16.29 ± 2.2% | not timed | not timed | 198.14 ± 1.9% | | 0.99 | 1.04 | 12.04 |
| wild/ruff/shebang | 282 | 424.71 ± 4.2% | not timed | not timed | 334.86 ± 3.1% | 100.62 ± 12.3% | not timed | not timed | 425.43 ± 0.7% | | 1.00 | 1.27 | 4.22 |
| wild/rustsec-cargo-audit/original-unix | 471 | 12677.19 ± 1.0% | not timed | not timed | 14048.45 ± 1.0% | 6101.74 ± 8.1% | not timed | not timed | 12656.30 ± 2.0% | | 1.00 | 0.90 | 2.08 |
| wild/rustsec-cargo-audit/original-windows | 462 | 11930.53 ± 0.1% | not timed | not timed | 13641.35 ± 0.4% | 5734.72 ± 2.4% | not timed | not timed | 11929.92 ± 0.3% | | 1.00 | 0.87 | 2.08 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 12625.38 ± 0.6% | not timed | not timed | 13899.25 ± 1.4% | 5833.82 ± 0.8% | not timed | not timed | 12643.57 ± 0.9% | | 1.00 | 0.91 | 2.16 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 10797.37 ± 2.4% | not timed | not timed | 13855.11 ± 0.4% | 5969.02 ± 1.2% | not timed | not timed | 10874.49 ± 1.7% | | 0.99 | 0.78 | 1.81 |
| wild/url/search | 234965 | 109.38 ± 13.0% | not timed | not timed | 56.11 ± 0.7% | 2.03 ± 0.9% | not timed | not timed | 110.67 ± 14.4% | | 0.99 | 1.95 | 53.90 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.02 ± 2.9% | not timed | not timed | 0.01 ± 1.0% | 0.01 ± 25.3% | not timed | not timed | 0.02 ± 53.3% | | 1.00 | 3.42 | 3.97 |
| dictionary/compile/english-15 | 1 | 0.28 ± 7.9% | not timed | not timed | 0.06 ± 10.3% | 0.09 ± 9.8% | not timed | not timed | 0.28 ± 29.3% | | 1.00 | 4.43 | 3.05 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.18 ± 11.8% | not timed | not timed | 0.02 ± 19.3% | 29.30 ± 11.5% | not timed | not timed | 0.18 ± 11.8% | | 1.01 | 10.77 | 0.0062 |
| reported/i1095-word-repetition/ascii-compile | 1 | 35.83 ± 15.9% | not timed | not timed | 11.78 ± 0.4% | 52.50 ± 21.2% | not timed | not timed | 36.27 ± 3.6% | | 0.99 | 3.04 | 0.68 |
| reported/i787-keywords/compile | 1 | 34.49 ± 21.8% | not timed | not timed | 1.71 ± 0.5% | 15.33 ± 16.7% | not timed | not timed | 34.50 ± 3.3% | | 1.00 | 20.20 | 2.25 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 348.33 ± 10.0% | not timed | not timed | 122.71 ± 1.3% | 527.33 ± 35.5% | not timed | not timed | 348.91 ± 9.4% | | 1.00 | 2.84 | 0.66 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 46.96 ± 7.9% | not timed | not timed | 3.59 ± 0.5% | 39.50 ± 4.2% | not timed | not timed | 47.83 ± 2.8% | | 0.98 | 13.08 | 1.19 |
| unicode/compile/one-letter | 53 | 5.78 ± 20.2% | not timed | not timed | 4.62 ± 1.2% | 49.86 ± 8.4% | not timed | not timed | 5.89 ± 3.7% | | 0.98 | 1.25 | 0.12 |
| unicode/compile/fifty-letters | 1 | 0.89 ± 6.1% | not timed | not timed | 0.10 ± 1.0% | 53.76 ± 13.4% | not timed | not timed | 0.89 ± 9.2% | | 1.00 | 8.76 | 0.0166 |
| unicode/compile/fifty-letters-ascii | 1 | 195.28 ± 26.6% | not timed | not timed | 52.11 ± 0.5% | 179.90 ± 36.0% | not timed | not timed | 199.52 ± 3.2% | | 0.98 | 3.75 | 1.09 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 402.08 ± 2.9% | not timed | not timed | 38.55 ± 0.7% | 612.87 ± 10.4% | not timed | not timed | 403.58 ± 3.3% | | 1.00 | 10.43 | 0.66 |
| unicode/compile/match-every-line-ascii | 4 | 651.50 ± 10.5% | not timed | not timed | 143.47 ± 0.2% | 582.59 ± 24.1% | not timed | not timed | 660.02 ± 2.9% | | 0.99 | 4.54 | 1.12 |
| unicode/compile/negated-class-matches-codepoint | 1 | 334.03 ± 9.1% | not timed | not timed | 41.91 ± 0.0% | 1144.39 ± 9.3% | not timed | not timed | 334.70 ± 9.4% | | 1.00 | 7.97 | 0.29 |
| wild/bibleref/compile | 3 | 4.70 ± 18.0% | not timed | not timed | 1.78 ± 1.8% | 27.57 ± 11.5% | not timed | not timed | 5.07 ± 17.2% | | 0.93 | 2.65 | 0.17 |
| wild/url/compile | 1 | 0.58 ± 14.2% | not timed | not timed | 0.13 ± 4.8% | 0.37 ± 20.1% | not timed | not timed | 0.61 ± 12.7% | | 0.96 | 4.35 | 1.56 |

