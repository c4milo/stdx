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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507046217 |
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
| literal: a word | 217 | 19523.51 ± 2.7% | 5072.77 ± 0.6% | 28.24 ± 0.3% | 18059.65 ± 1.9% | 9149.42 ± 8.9% | 17.61 ± 0.2% | 86.08 ± 0.8% | 19571.23 ± 3.4% | 3.85 | 1.00 | 1.08 | 2.13 |
| literal: a word that is not there | 0 | 21676.73 ± 3.8% | 4942.52 ± 0.4% | 28.19 ± 0.6% | 19615.26 ± 1.7% | 29131.11 ± 1.9% | 17.42 ± 0.2% | 81.90 ± 0.2% | 21425.60 ± 1.5% | 4.39 | 1.01 | 1.11 | 0.74 |
| literal: one of four words | 661 | 6427.00 ± 0.3% | 1974.19 ± 0.1% | 14.40 ± 0.2% | 3942.61 ± 0.2% | 21.89 ± 0.1% | 5.30 ± 0.1% | 6.17 ± 0.3% | 6435.23 ± 0.4% | 3.26 | 1.00 | 1.63 | 293.59 |
| literal: a word in any case | 217 | 15105.89 ± 0.6% | 2102.94 ± 0.2% | 21.47 ± 0.5% | 3964.76 ± 0.2% | 38.10 ± 1.9% | refused | differs | 15113.47 ± 0.3% | 7.18 | 1.00 | 3.81 | 396.48 |
| literal: an href attribute | 33 | 16787.02 ± 1.2% | 617.77 ± 0.2% | 27.19 ± 0.5% | 16930.37 ± 1.0% | 2262.68 ± 0.6% | 13.44 ± 0.1% | 75.27 ± 0.1% | 16877.58 ± 1.1% | 27.17 | 0.99 | 0.99 | 7.42 |
| literal: a word, second text | 123 | 19804.77 ± 3.3% | 3421.10 ± 0.2% | 28.03 ± 0.3% | 18237.43 ± 2.1% | 7616.94 ± 3.7% | 19.60 ± 0.5% | 68.96 ± 0.3% | 19726.19 ± 2.4% | 5.79 | 1.00 | 1.09 | 2.60 |
| class: two capitalized words | 1331 | 1065.22 ± 0.4% | 608.71 ± 0.4% | 25.99 ± 0.3% | 585.26 ± 0.1% | 40.61 ± 8.6% | 14.99 ± 0.3% | 68.20 ± 0.5% | 1066.78 ± 1.3% | 1.75 | 1.00 | 1.82 | 26.23 |
| class: a word that ends in ing | 3399 | 583.33 ± 0.1% | 583.10 ± 0.3% | 17.99 ± 0.1% | 547.89 ± 0.1% | 29.68 ± 6.6% | 8.24 ± 0.2% | 18.25 ± 0.2% | 581.26 ± 0.2% | 1.00 | 1.00 | 1.06 | 19.65 |
| class: a word in capitals | 2332 | 1390.34 ± 0.7% | 614.73 ± 0.1% | 27.62 ± 0.5% | 572.50 ± 0.1% | 43.61 ± 6.7% | 17.26 ± 0.3% | 82.95 ± 0.6% | 1391.11 ± 0.3% | 2.26 | 1.00 | 2.43 | 31.88 |
| class: a number | 8288 | 2129.17 ± 0.3% | 853.67 ± 0.2% | 27.84 ± 0.3% | 1721.21 ± 0.2% | 42.99 ± 7.2% | 0.57 ± 0.2% | 56.82 ± 0.1% | 2131.39 ± 0.4% | 2.49 | 1.00 | 1.24 | 49.52 |
| class: two capitalized words, second text | 5359 | 523.26 ± 0.2% | 534.39 ± 0.2% | 23.33 ± 0.2% | 484.02 ± 0.1% | 35.16 ± 12.5% | 16.69 ± 0.5% | 63.30 ± 0.7% | 525.63 ± 0.2% | 0.98 | 1.00 | 1.08 | 14.88 |
| other: a word between two words | 6104 | 810.87 ± 0.3% | 609.83 ± 0.2% | 23.51 ± 0.3% | 737.65 ± 0.3% | 109.06 ± 13.4% | 11.33 ± 0.4% | 69.29 ± 0.2% | 808.84 ± 0.2% | 1.33 | 1.00 | 1.10 | 7.44 |
| other: a number before a unit, second text | 1481 | 6180.57 ± 0.5% | 1130.70 ± 0.4% | 26.00 ± 0.3% | 5631.71 ± 0.3% | 40.79 ± 16.6% | 17.84 ± 0.4% | 66.78 ± 0.1% | 6173.20 ± 1.0% | 5.47 | 1.00 | 1.10 | 151.53 |
| other: a heading's start tag | 110 | 14094.60 ± 0.6% | 750.47 ± 0.1% | 27.40 ± 0.3% | 1708.25 ± 0.5% | 1585.46 ± 0.4% | 16.29 ± 0.5% | 88.59 ± 0.3% | 14158.50 ± 1.4% | 18.78 | 1.00 | 8.25 | 8.89 |
| other: a whole word | 217 | 16278.43 ± 1.9% | 608.70 ± 0.7% | 29.34 ± 0.8% | 14551.82 ± 0.7% | 48.01 ± 0.4% | 13.79 ± 0.3% | 55.50 ± 0.3% | 16346.51 ± 1.2% | 26.74 | 1.00 | 1.12 | 339.04 |
| other: a line's first word, second text | 3716 | 2098.73 ± 0.2% | 599.69 ± 0.5% | 31.03 ± 0.2% | 1723.79 ± 0.6% | 62.29 ± 5.9% | refused | refused | 2095.75 ± 0.7% | 3.50 | 1.00 | 1.22 | 33.69 |
| other: fourteen octets before an x | 87 | 23985.59 ± 1.3% | 235.91 ± 0.5% | 6.55 ± 0.1% | 4032.12 ± 1.2% | 10.65 ± 0.1% | differs | 17.50 ± 0.2% | 24198.88 ± 8.0% | 101.67 | 0.99 | 5.95 | 2252.95 |
| other: a Greek word | 21815 | 519.59 ± 0.4% | 425.12 ± 0.2% | 30.81 ± 0.4% | 289.02 ± 0.1% | 44.78 ± 9.9% | differs | refused | 523.24 ± 0.6% | 1.22 | 0.99 | 1.80 | 11.60 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.29 ± 0.4% | 29.27 ± 0.3% | 0.86 ± 0.1% | 19.76 ± 0.5% | 2.74 ± 9.5% | differs | 4.02 ± 0.3% | 29.23 ± 0.3% | 1.00 | 1.00 | 1.48 | 10.69 |
| a UUID | 32895 | 24.70 ± 0.2% | 24.63 ± 0.1% | 0.64 ± 0.3% | 15.11 ± 0.6% | 3.10 ± 0.6% | 0.72 ± 0.3% | 3.60 ± 0.4% | 24.70 ± 0.4% | 1.00 | 1.00 | 1.63 | 7.97 |
| an IPv4 address | 33176 | 38.52 ± 0.4% | 38.48 ± 0.4% | 2.07 ± 0.4% | 29.19 ± 0.5% | 6.63 ± 0.4% | differs | 4.15 ± 0.2% | 38.48 ± 0.3% | 1.00 | 1.00 | 1.32 | 5.81 |
| a date and time | 32954 | 34.37 ± 0.1% | 34.12 ± 0.0% | 1.45 ± 0.1% | 21.41 ± 0.7% | 7.03 ± 0.2% | 1.19 ± 0.2% | 7.03 ± 0.3% | 34.34 ± 0.1% | 1.01 | 1.00 | 1.60 | 4.89 |
| a field path | 32606 | 32.58 ± 0.3% | 32.56 ± 0.3% | 1.02 ± 0.4% | 23.15 ± 0.6% | 3.47 ± 0.4% | differs | 2.92 ± 0.3% | 32.57 ± 0.2% | 1.00 | 1.00 | 1.41 | 9.39 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.12 ± 0.4% | 11.03 ± 0.4% | 11.12 ± 0.2% | 11.36 ± 0.3% | 4.95 ± 2.2% | 0.90 ± 0.3% | none | 11.08 ± 0.3% | 1.01 | 1.00 | 0.98 | 2.24 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.51 ± 0.4% | 222.62 ± 0.2% | 259.96 ± 0.2% | 86.54 ± 0.6% | 223.07 ± 0.5% | 479.19 ± 1.2% | 3716.27 ± 0.6% | 222.49 ± 0.2% | 1.00 | 1.00 | 2.57 | 1.00 |
| a UUID | 62 | 144.07 ± 0.1% | 144.24 ± 0.2% | 159.46 ± 0.3% | 45.85 ± 0.7% | 99.40 ± 0.9% | 184.67 ± 2.4% | 4424.69 ± 1.3% | 144.19 ± 0.1% | 1.00 | 1.00 | 3.14 | 1.45 |
| an IPv4 address | 29 | 420.55 ± 0.2% | 421.43 ± 0.2% | 583.44 ± 0.3% | 79.16 ± 1.6% | 131.53 ± 1.8% | 305.68 ± 2.2% | 7243.60 ± 0.2% | 420.66 ± 0.2% | 1.00 | 1.00 | 5.31 | 3.20 |
| a date and time | 56 | 302.26 ± 0.3% | 302.44 ± 0.3% | 376.43 ± 0.4% | 74.07 ± 0.4% | 138.04 ± 0.9% | 326.52 ± 0.3% | 4941.25 ± 0.6% | 302.29 ± 0.2% | 1.00 | 1.00 | 4.08 | 2.19 |
| a field path | 39 | 213.61 ± 0.2% | 213.72 ± 0.2% | 248.38 ± 0.2% | 79.07 ± 0.1% | 206.80 ± 1.1% | 503.75 ± 0.7% | 4824.15 ± 3.1% | 213.37 ± 0.2% | 1.00 | 1.00 | 2.70 | 1.03 |
| literal: a word | 7 | 619.33 ± 0.7% | 671.25 ± 0.6% | 1181.67 ± 0.8% | 494.84 ± 0.5% | 633.70 ± 2.7% | 953.45 ± 0.4% | 29805.66 ± 0.4% | 617.79 ± 0.7% | 0.92 | 1.00 | 1.25 | 0.98 |
| literal: a word that is not there | 8 | 597.07 ± 0.4% | 655.17 ± 0.7% | 1120.23 ± 0.7% | 455.86 ± 0.3% | 613.46 ± 2.0% | 893.05 ± 0.4% | 28798.12 ± 0.3% | 596.26 ± 0.5% | 0.91 | 1.00 | 1.31 | 0.97 |
| literal: one of four words | 26 | 246.83 ± 0.2% | 396.07 ± 0.2% | 533.17 ± 0.4% | 50.71 ± 0.5% | 245.54 ± 2.0% | 371.44 ± 0.5% | 15524.46 ± 0.2% | 246.96 ± 0.2% | 0.62 | 1.00 | 4.87 | 1.01 |
| literal: a word in any case | 11 | 448.25 ± 0.3% | 480.06 ± 0.1% | 701.80 ± 0.2% | 15.67 ± 0.3% | 660.95 ± 13.8% | refused | 23249.06 ± 0.6% | 448.29 ± 0.4% | 0.93 | 1.00 | 28.60 | 0.68 |
| literal: an href attribute | 12 | 336.45 ± 0.4% | 347.89 ± 0.2% | 450.93 ± 0.2% | 45.03 ± 0.8% | 496.75 ± 1.8% | 771.02 ± 0.4% | 21758.13 ± 0.1% | 336.54 ± 0.3% | 0.97 | 1.00 | 7.47 | 0.68 |
| literal: a word, second text | 10 | 553.75 ± 0.3% | 615.22 ± 0.4% | 1007.07 ± 0.1% | 405.07 ± 0.6% | 535.76 ± 1.9% | 792.22 ± 0.5% | 26512.39 ± 0.4% | 553.71 ± 0.4% | 0.90 | 1.00 | 1.37 | 1.03 |
| class: two capitalized words | 23 | 435.83 ± 0.3% | 464.32 ± 0.3% | 661.31 ± 0.2% | 102.96 ± 2.4% | 496.39 ± 2.9% | 743.75 ± 0.7% | 6345.36 ± 0.1% | 435.26 ± 0.3% | 0.94 | 1.00 | 4.23 | 0.88 |
| class: a word that ends in ing | 9 | 549.11 ± 0.2% | 618.13 ± 0.4% | 1060.05 ± 0.2% | 133.29 ± 1.5% | 752.45 ± 1.2% | 1092.95 ± 0.5% | 15752.71 ± 0.3% | 548.05 ± 0.2% | 0.89 | 1.00 | 4.12 | 0.73 |
| class: a word in capitals | 16 | 492.23 ± 0.2% | 528.56 ± 0.3% | 829.89 ± 0.3% | 135.13 ± 1.7% | 747.00 ± 0.9% | 1021.73 ± 0.9% | 8345.27 ± 0.1% | 491.82 ± 0.2% | 0.93 | 1.00 | 3.64 | 0.66 |
| class: a number | 6 | 627.56 ± 0.2% | 687.25 ± 0.1% | 1262.30 ± 0.1% | 41.84 ± 0.6% | 1376.95 ± 0.9% | 1862.82 ± 0.9% | 22565.51 ± 0.1% | 626.48 ± 0.4% | 0.91 | 1.00 | 15.00 | 0.46 |
| class: two capitalized words, second text | 23 | 436.03 ± 0.3% | 464.43 ± 0.3% | 662.43 ± 0.7% | 102.22 ± 3.2% | 499.17 ± 0.4% | 760.42 ± 0.6% | 6344.47 ± 0.1% | 434.95 ± 0.2% | 0.94 | 1.00 | 4.27 | 0.87 |
| other: a word between two words | 13 | 532.48 ± 0.3% | 554.58 ± 0.6% | 869.71 ± 0.1% | 131.94 ± 0.4% | 504.19 ± 0.9% | 805.91 ± 1.1% | 14585.27 ± 0.1% | 532.12 ± 0.4% | 0.96 | 1.00 | 4.04 | 1.06 |
| other: a number before a unit, second text | 15 | 384.91 ± 0.2% | 424.98 ± 0.4% | 587.45 ± 0.1% | 39.29 ± 0.3% | 632.84 ± 1.1% | 886.21 ± 0.9% | 15173.56 ± 0.3% | 384.63 ± 0.2% | 0.91 | 1.00 | 9.80 | 0.61 |
| other: a heading's start tag | 13 | 347.33 ± 0.2% | 353.65 ± 0.4% | 460.67 ± 0.3% | 43.81 ± 0.3% | 630.49 ± 1.1% | 847.92 ± 0.1% | 17909.32 ± 0.2% | 346.80 ± 0.4% | 0.98 | 1.00 | 7.93 | 0.55 |
| other: a whole word | 11 | 572.11 ± 0.4% | 615.73 ± 0.8% | 1012.11 ± 0.1% | 120.72 ± 0.2% | 560.32 ± 2.6% | 805.07 ± 0.6% | 26366.22 ± 0.2% | 573.30 ± 0.5% | 0.93 | 1.00 | 4.74 | 1.02 |
| other: a line's first word, second text | 17 | 516.93 ± 0.7% | 546.80 ± 0.7% | 861.42 ± 0.6% | 127.11 ± 0.1% | 705.17 ± 12.1% | refused | refused | 517.18 ± 0.7% | 0.95 | 1.00 | 4.07 | 0.73 |
| other: fourteen octets before an x | 16 | 107.57 ± 0.3% | 153.80 ± 0.4% | 175.43 ± 0.4% | 15.10 ± 0.6% | 452.25 ± 2.6% | 405.66 ± 0.5% | 12652.97 ± 0.2% | 107.65 ± 0.4% | 0.70 | 1.00 | 7.12 | 0.24 |
| other: a Greek word | 8 | 443.68 ± 0.2% | 579.21 ± 0.2% | 946.58 ± 0.1% | 58.81 ± 0.7% | 1374.59 ± 1.6% | 1843.00 ± 1.9% | refused | 444.18 ± 0.2% | 0.77 | 1.00 | 7.54 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15708.76 ± 0.9% | not timed | not timed | 16028.51 ± 1.1% | 2110.65 ± 10.9% | not timed | not timed | 15651.92 ± 0.9% | | 1.00 | 0.98 | 7.44 |
| 01-literal/sherlock-casei-en | 522 | 11062.35 ± 7.5% | not timed | not timed | 3585.46 ± 0.4% | 31.65 ± 0.2% | not timed | not timed | 11056.31 ± 1.8% | | 1.00 | 3.09 | 349.51 |
| 01-literal/sherlock-ru | 724 | 17186.36 ± 0.4% | not timed | not timed | 17294.29 ± 0.3% | 1501.13 ± 13.6% | not timed | not timed | 17200.13 ± 0.4% | | 1.00 | 0.99 | 11.45 |
| 01-literal/sherlock-casei-ru | 746 | 6156.72 ± 0.3% | not timed | not timed | 3328.47 ± 0.2% | 29.90 ± 0.8% | not timed | not timed | 6140.43 ± 0.1% | | 1.00 | 1.85 | 205.91 |
| 01-literal/sherlock-zh | 30 | 19528.58 ± 0.6% | not timed | not timed | 18616.56 ± 1.3% | 2602.22 ± 15.1% | not timed | not timed | 19432.63 ± 0.6% | | 1.00 | 1.05 | 7.50 |
| 02-literal-alternate/sherlock-en | 714 | 6140.06 ± 0.4% | not timed | not timed | 3935.83 ± 0.3% | 16.62 ± 0.1% | not timed | not timed | 6146.54 ± 0.4% | | 1.00 | 1.56 | 369.46 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1969.56 ± 1.4% | not timed | not timed | 697.39 ± 0.4% | 10.99 ± 0.4% | not timed | not timed | 1973.38 ± 0.9% | | 1.00 | 2.82 | 179.25 |
| 02-literal-alternate/sherlock-ru | 899 | 5541.63 ± 0.2% | not timed | not timed | 3253.33 ± 0.1% | 22.63 ± 0.1% | not timed | not timed | 5532.35 ± 0.1% | | 1.00 | 1.70 | 244.88 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2055.42 ± 0.5% | not timed | not timed | 1227.62 ± 0.8% | 8.59 ± 2.3% | not timed | not timed | 2054.20 ± 0.4% | | 1.00 | 1.67 | 239.17 |
| 02-literal-alternate/sherlock-zh | 207 | 7326.00 ± 0.6% | not timed | not timed | 4148.72 ± 0.1% | 31.47 ± 0.1% | not timed | not timed | 7347.08 ± 0.7% | | 1.00 | 1.77 | 232.77 |
| 03-date/ascii | 111817 | 133.51 ± 1.2% | not timed | not timed | 95.63 ± 0.1% | 0.20 ± 4.0% | not timed | not timed | 134.52 ± 0.4% | | 0.99 | 1.40 | 659.61 |
| 04-ruff-noqa/real | 84 | 438.93 ± 0.2% | not timed | not timed | 466.17 ± 0.1% | 19.69 ± 1.3% | not timed | not timed | 435.62 ± 0.2% | | 1.01 | 0.94 | 22.29 |
| 04-ruff-noqa/tweaked | 44 | 594.74 ± 0.2% | not timed | not timed | 460.91 ± 0.1% | 364.76 ± 0.4% | not timed | not timed | 596.06 ± 0.4% | | 1.00 | 1.29 | 1.63 |
| 05-lexer-veryl/single | 124800 | 5.36 ± 3.9% | not timed | not timed | 5.00 ± 0.4% | 0.20 ± 4.8% | not timed | not timed | 5.50 ± 0.3% | | 0.97 | 1.07 | 26.56 |
| 06-cloud-flare-redos/original | 107 | 426.73 ± 0.1% | not timed | not timed | 210.89 ± 0.1% | 24.94 ± 0.3% | not timed | not timed | 432.30 ± 0.2% | | 0.99 | 2.02 | 17.11 |
| 06-cloud-flare-redos/simplified-short | 102 | 431.63 ± 0.1% | not timed | not timed | 228.56 ± 0.1% | 26.71 ± 0.2% | not timed | not timed | 431.21 ± 0.2% | | 1.00 | 1.89 | 16.16 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.55 ± 0.1% | not timed | not timed | 256.97 ± 0.2% | 28.73 ± 0.1% | not timed | not timed | 588.56 ± 0.1% | | 1.00 | 2.29 | 20.48 |
| 07-unicode-character-data/parse-line | 558784 | 233.32 ± 1.1% | not timed | not timed | 169.81 ± 0.1% | 43.07 ± 5.6% | not timed | not timed | 232.67 ± 2.4% | | 1.00 | 1.37 | 5.42 |
| 08-words/all-english | 56691 | 127.87 ± 0.6% | not timed | not timed | 82.94 ± 0.2% | 12.52 ± 14.3% | not timed | not timed | 128.19 ± 0.7% | | 1.00 | 1.54 | 10.22 |
| 08-words/long-english | 839 | 623.12 ± 0.1% | not timed | not timed | 597.31 ± 0.1% | 32.28 ± 0.1% | not timed | not timed | 623.26 ± 0.1% | | 1.00 | 1.04 | 19.30 |
| 09-aws-keys/full | 0 | 444.24 ± 0.1% | not timed | not timed | 464.47 ± 0.1% | 64.48 ± 3.5% | not timed | not timed | 439.44 ± 0.1% | | 1.01 | 0.96 | 6.89 |
| 09-aws-keys/quick | 0 | 874.49 ± 0.1% | not timed | not timed | 991.83 ± 0.5% | 420.94 ± 0.6% | not timed | not timed | 874.67 ± 0.2% | | 1.00 | 0.88 | 2.08 |
| 10-bounded-repeat/letters-en | 1833 | 580.95 ± 3.0% | not timed | not timed | 516.87 ± 0.1% | 19.46 ± 0.3% | not timed | not timed | 582.27 ± 1.6% | | 1.00 | 1.12 | 29.86 |
| 10-bounded-repeat/letters-ru | 3475 | 504.97 ± 1.5% | not timed | not timed | 478.70 ± 0.1% | 21.46 ± 13.3% | not timed | not timed | 506.91 ± 1.0% | | 1.00 | 1.05 | 23.53 |
| 10-bounded-repeat/context | 53 | 85.18 ± 1.9% | not timed | not timed | 65.83 ± 0.5% | 19.81 ± 0.1% | not timed | not timed | 85.28 ± 1.8% | | 1.00 | 1.29 | 4.30 |
| 10-bounded-repeat/capitals | 11 | 633.37 ± 8.5% | not timed | not timed | 618.41 ± 0.1% | 36.55 ± 0.1% | not timed | not timed | 633.48 ± 8.4% | | 1.00 | 1.02 | 17.33 |
| 11-unstructured-to-json/extract | 600 | 57.21 ± 1.1% | not timed | not timed | 77.39 ± 0.2% | 48.73 ± 1.2% | not timed | not timed | 57.31 ± 0.5% | | 1.00 | 0.74 | 1.17 |
| 12-dictionary/single | 1 | 560.05 ± 1.2% | not timed | not timed | 562.17 ± 0.2% | 0.41 ± 0.1% | not timed | not timed | 559.86 ± 0.9% | | 1.00 | 1.00 | 1363.70 |
| 14-quadratic/1x | 100 | 21.30 ± 1.5% | not timed | not timed | 9.98 ± 0.3% | 0.98 ± 3.8% | not timed | not timed | 21.38 ± 2.3% | | 1.00 | 2.13 | 21.75 |
| 14-quadratic/2x | 200 | 17.80 ± 1.6% | not timed | not timed | 5.55 ± 0.3% | 0.53 ± 1.5% | not timed | not timed | 17.92 ± 0.9% | | 0.99 | 3.21 | 33.37 |
| 14-quadratic/10x | 1000 | 7.77 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 2.0% | not timed | not timed | 7.77 ± 0.4% | | 1.00 | 6.44 | 67.06 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.21 ± 1.7% | not timed | not timed | 0.34 ± 0.4% | 0.55 ± 5.0% | not timed | not timed | 1.22 ± 0.8% | | 0.99 | 3.51 | 2.20 |
| 04-ruff-noqa/compile-real | 1 | 106.23 ± 0.7% | not timed | not timed | 13.65 ± 0.5% | 140.79 ± 2.4% | not timed | not timed | 106.38 ± 0.5% | | 1.00 | 7.78 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 13.87 ± 1.6% | not timed | not timed | 2.52 ± 0.4% | 6.54 ± 2.6% | not timed | not timed | 14.04 ± 1.7% | | 0.99 | 5.50 | 2.12 |
| 07-unicode-character-data/compile | 1 | 107.61 ± 1.1% | not timed | not timed | 25.84 ± 0.2% | 36.56 ± 2.1% | not timed | not timed | 108.06 ± 1.5% | | 1.00 | 4.16 | 2.94 |
| 09-aws-keys/compile-full | 1 | 53.03 ± 0.7% | not timed | not timed | 8.28 ± 0.7% | 23.54 ± 0.8% | not timed | not timed | 52.96 ± 0.8% | | 1.00 | 6.41 | 2.25 |
| 09-aws-keys/compile-quick | 1 | 186.75 ± 0.1% | not timed | not timed | 47.05 ± 0.3% | 135.37 ± 1.5% | not timed | not timed | 187.13 ± 1.3% | | 1.00 | 3.97 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 72.15 ± 0.9% | not timed | not timed | 11.21 ± 0.3% | 16.29 ± 1.9% | not timed | not timed | 71.61 ± 0.5% | | 1.01 | 6.44 | 4.43 |
| 10-bounded-repeat/compile-capitals | 1 | 85.06 ± 0.1% | not timed | not timed | 8.14 ± 0.3% | 23.88 ± 2.3% | not timed | not timed | 84.89 ± 0.4% | | 1.00 | 10.45 | 3.56 |
| 11-unstructured-to-json/compile | 1 | 170.18 ± 0.2% | not timed | not timed | 40.48 ± 0.4% | 69.25 ± 2.8% | not timed | not timed | 170.71 ± 0.4% | | 1.00 | 4.20 | 2.46 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.8% | not timed | not timed | 0.07 ± 17.9% | 0.09 ± 4.7% | not timed | not timed | 0.35 ± 2.9% | | 1.00 | 5.04 | 3.74 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.35 ± 1.8% | not timed | not timed | 6.48 ± 0.1% | 0.56 ± 16.5% | not timed | not timed | 7.36 ± 5.1% | | 1.00 | 1.13 | 13.02 |
| dictionary/search/english-10 | 690 | 1.16 ± 0.5% | not timed | not timed | 164.93 ± 0.5% | 0.00 ± 1.2% | not timed | not timed | 1.16 ± 0.5% | | 1.00 | 0.0070 | 429.03 |
| dictionary/search/english-15 | 15 | 566.34 ± 1.0% | not timed | not timed | 560.32 ± 0.1% | 0.37 ± 0.2% | not timed | not timed | 567.48 ± 1.0% | | 1.00 | 1.01 | 1539.91 |
| folly/awyer-inn-busted | 1 | 5592.22 ± 0.1% | not timed | not timed | 142.20 ± 0.1% | 43.97 ± 6.7% | not timed | not timed | 5614.92 ± 0.0% | | 1.00 | 39.33 | 127.18 |
| folly/literal-never-match-rare | 0 | 21050.99 ± 0.5% | not timed | not timed | 19856.50 ± 0.4% | 40734.62 ± 0.6% | not timed | not timed | 21057.45 ± 0.1% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12484.86 ± 1.8% | not timed | not timed | 19794.95 ± 0.4% | 2199.27 ± 0.9% | not timed | not timed | 12530.70 ± 1.4% | | 1.00 | 0.63 | 5.68 |
| folly/literal-never-match-tricksy | 1 | 3249.29 ± 0.3% | not timed | not timed | 4406.89 ± 0.1% | 3050.83 ± 0.3% | not timed | not timed | 3241.11 ± 0.3% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1318.07 ± 0.6% | not timed | not timed | 945.15 ± 0.3% | 364.71 ± 16.8% | not timed | not timed | 1325.14 ± 0.3% | | 0.99 | 1.39 | 3.61 |
| grep/long-words-ascii | 5073 | 459.35 ± 0.3% | not timed | not timed | 466.44 ± 0.1% | 46.31 ± 6.1% | not timed | not timed | 459.21 ± 0.3% | | 1.00 | 0.98 | 9.92 |
| imported/leipzig/twain | 811 | 20713.54 ± 1.2% | not timed | not timed | 19591.03 ± 0.3% | 11997.81 ± 9.3% | not timed | not timed | 20743.23 ± 0.6% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9045.77 ± 0.7% | not timed | not timed | 4249.26 ± 0.2% | 37.74 ± 0.5% | not timed | not timed | 9073.37 ± 0.9% | | 1.00 | 2.13 | 239.70 |
| imported/leipzig/shing | 1540 | 15194.13 ± 2.7% | not timed | not timed | 13470.57 ± 0.5% | 34.02 ± 0.1% | not timed | not timed | 15486.22 ± 2.5% | | 0.98 | 1.13 | 446.66 |
| imported/leipzig/huck-saw | 262 | 8240.79 ± 3.2% | not timed | not timed | 5600.34 ± 0.3% | 31.73 ± 0.2% | not timed | not timed | 8451.30 ± 3.1% | | 0.98 | 1.47 | 259.70 |
| imported/leipzig/word-ending-nn | 262 | 605.47 ± 0.7% | not timed | not timed | 617.97 ± 0.1% | 24.83 ± 0.3% | not timed | not timed | 604.03 ± 0.9% | | 1.00 | 0.98 | 24.39 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11172.10 ± 1.0% | not timed | not timed | 4533.04 ± 0.3% | 11.50 ± 1.2% | not timed | not timed | 11208.66 ± 1.3% | | 1.00 | 2.46 | 971.15 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7823.33 ± 2.3% | not timed | not timed | 5488.43 ± 0.1% | 16.84 ± 0.1% | not timed | not timed | 7940.99 ± 2.1% | | 0.99 | 1.43 | 464.45 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4182.24 ± 0.8% | not timed | not timed | 408.89 ± 1.3% | 11.14 ± 0.0% | not timed | not timed | 4188.73 ± 0.7% | | 1.00 | 10.23 | 375.57 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 600.99 ± 0.6% | not timed | not timed | 615.07 ± 0.1% | 11.13 ± 0.0% | not timed | not timed | 603.77 ± 0.4% | | 1.00 | 0.98 | 54.00 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 604.02 ± 0.8% | not timed | not timed | 615.44 ± 0.1% | 9.75 ± 0.1% | not timed | not timed | 603.32 ± 0.5% | | 1.00 | 0.98 | 61.95 |
| imported/leipzig/tom-river | 2 | 6497.32 ± 2.2% | not timed | not timed | 5147.95 ± 0.2% | 30.90 ± 0.1% | not timed | not timed | 6607.64 ± 1.7% | | 0.98 | 1.26 | 210.29 |
| imported/leipzig/ing | 78424 | 600.42 ± 0.7% | not timed | not timed | 572.06 ± 0.1% | 28.30 ± 2.9% | not timed | not timed | 602.60 ± 0.9% | | 1.00 | 1.05 | 21.21 |
| imported/leipzig/ing-whitespace | 55248 | 751.21 ± 0.7% | not timed | not timed | 2071.41 ± 0.3% | 20.56 ± 2.8% | not timed | not timed | 752.46 ± 1.0% | | 1.00 | 0.36 | 36.54 |
| imported/leipzig/awyer-inn | 209 | 768.26 ± 1.4% | not timed | not timed | 4232.88 ± 1.9% | 22.65 ± 0.1% | not timed | not timed | 768.56 ± 1.7% | | 1.00 | 0.18 | 33.93 |
| imported/leipzig/quotes-bounded | 8886 | 2115.58 ± 0.6% | not timed | not timed | 2985.29 ± 1.1% | 38.25 ± 0.1% | not timed | not timed | 2120.01 ± 0.6% | | 1.00 | 0.71 | 55.31 |
| imported/leipzig/non-ascii-alternate | 2 | 12828.02 ± 2.7% | not timed | not timed | 5661.49 ± 0.1% | 50.79 ± 0.1% | not timed | not timed | 13004.90 ± 2.6% | | 0.99 | 2.27 | 252.58 |
| imported/leipzig/math-symbols | 69 | 1979.28 ± 0.4% | not timed | not timed | 619.31 ± 0.1% | 36.53 ± 0.1% | not timed | not timed | 1981.15 ± 0.4% | | 1.00 | 3.20 | 54.18 |
| imported/leipzig/bounded-strings-ending-z | 0 | 585.97 ± 1.0% | not timed | not timed | 617.81 ± 0.1% | 22.54 ± 0.0% | not timed | not timed | 585.89 ± 1.4% | | 1.00 | 0.95 | 25.99 |
| imported/lh3lh3-reb/uri | 17549 | 679.93 ± 0.1% | not timed | not timed | 1061.40 ± 0.2% | 27.94 ± 2.1% | not timed | not timed | 679.06 ± 0.3% | | 1.00 | 0.64 | 24.34 |
| imported/lh3lh3-reb/email | 15057 | 673.71 ± 0.1% | not timed | not timed | 1157.37 ± 0.2% | 30.83 ± 2.8% | not timed | not timed | 673.62 ± 0.2% | | 1.00 | 0.58 | 21.86 |
| imported/lh3lh3-reb/date | 668 | 860.57 ± 0.1% | not timed | not timed | 1029.88 ± 0.2% | 51.30 ± 3.9% | not timed | not timed | 860.65 ± 0.1% | | 1.00 | 0.84 | 16.78 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.84 ± 0.1% | not timed | not timed | 422.14 ± 0.1% | 15.81 ± 1.2% | not timed | not timed | 644.91 ± 0.1% | | 1.00 | 1.53 | 40.85 |
| imported/mariomka/email | 92 | 24222.39 ± 1.1% | not timed | not timed | 29216.53 ± 2.0% | 32.81 ± 0.1% | not timed | not timed | 24180.85 ± 1.3% | | 1.00 | 0.83 | 738.34 |
| imported/mariomka/uri | 5301 | 5340.11 ± 0.9% | not timed | not timed | 6084.65 ± 0.4% | 32.61 ± 0.9% | not timed | not timed | 5377.46 ± 0.8% | | 0.99 | 0.88 | 163.76 |
| imported/mariomka/ip | 5 | 2154.84 ± 2.0% | not timed | not timed | 2966.98 ± 0.1% | 21.10 ± 0.4% | not timed | not timed | 2155.96 ± 2.5% | | 1.00 | 0.73 | 102.14 |
| imported/rsc/no-exponential | 0 | 607.82 ± 0.4% | not timed | not timed | 323.27 ± 0.2% | 23.90 ± 0.1% | not timed | not timed | 602.42 ± 0.1% | | 1.01 | 1.88 | 25.43 |
| imported/rsc/literal | 1 | 759.91 ± 2.3% | not timed | not timed | 1599.96 ± 5.3% | 184.58 ± 16.6% | not timed | not timed | 759.50 ± 5.5% | | 1.00 | 0.47 | 4.12 |
| imported/rsc/not-literal | 2 | 781.17 ± 0.2% | not timed | not timed | 730.48 ± 0.1% | 46.52 ± 3.3% | not timed | not timed | 781.74 ± 8.4% | | 1.00 | 1.07 | 16.79 |
| imported/rsc/match-class | 1 | 1438.81 ± 0.1% | not timed | not timed | 1611.19 ± 0.3% | 58.55 ± 14.3% | not timed | not timed | 1439.70 ± 2.5% | | 1.00 | 0.89 | 24.58 |
| imported/rsc/match-class-in-range | 1 | 1448.65 ± 0.3% | not timed | not timed | 2349.08 ± 6.8% | 59.81 ± 6.9% | not timed | not timed | 1437.32 ± 2.4% | | 1.01 | 0.62 | 24.22 |
| imported/rsc/match-class-unicode | 1 | 548.03 ± 0.1% | not timed | not timed | 512.88 ± 0.1% | 72.93 ± 0.2% | not timed | not timed | 549.20 ± 0.2% | | 1.00 | 1.07 | 7.51 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1441.22 ± 0.2% | not timed | not timed | 945.72 ± 0.1% | 228.37 ± 1.1% | not timed | not timed | 1438.12 ± 0.3% | | 1.00 | 1.52 | 6.31 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21588.48 ± 0.2% | not timed | not timed | 14136.01 ± 0.1% | 3428.05 ± 0.6% | not timed | not timed | 21558.69 ± 0.1% | | 1.00 | 1.53 | 6.30 |
| imported/rsc/anchored-literal-short-match | 4 | 710.49 ± 2.0% | not timed | not timed | 488.14 ± 0.5% | 85.08 ± 5.9% | not timed | not timed | 708.06 ± 5.6% | | 1.00 | 1.46 | 8.35 |
| imported/rsc/anchored-literal-long-match | 4 | 10480.43 ± 2.5% | not timed | not timed | 7288.24 ± 0.1% | 1228.54 ± 8.3% | not timed | not timed | 10626.69 ± 0.4% | | 0.99 | 1.44 | 8.53 |
| imported/rsc/one-pass-short | 17 | 368.98 ± 11.5% | not timed | not timed | 215.48 ± 0.1% | 31.60 ± 12.3% | not timed | not timed | 371.60 ± 0.5% | | 0.99 | 1.71 | 11.68 |
| imported/rsc/one-pass-short-not | 17 | 280.76 ± 2.6% | not timed | not timed | 224.76 ± 0.2% | 30.87 ± 13.0% | not timed | not timed | 280.55 ± 8.4% | | 1.00 | 1.25 | 9.09 |
| imported/rsc/one-pass-long-prefix | 26 | 366.57 ± 6.1% | not timed | not timed | 282.04 ± 0.6% | 97.07 ± 14.4% | not timed | not timed | 366.96 ± 4.1% | | 1.00 | 1.30 | 3.78 |
| imported/rsc/one-pass-long-prefix-not | 26 | 363.42 ± 2.2% | not timed | not timed | 277.96 ± 0.3% | 64.31 ± 17.7% | not timed | not timed | 366.18 ± 2.1% | | 0.99 | 1.31 | 5.65 |
| imported/rsc/long-needle1 | 31 | 22209.09 ± 0.1% | not timed | not timed | 20164.48 ± 0.2% | 3.76 ± 0.1% | not timed | not timed | 22211.74 ± 0.2% | | 1.00 | 1.10 | 5907.06 |
| imported/rsc/long-needle2 | 31 | 22348.89 ± 0.1% | not timed | not timed | 216.29 ± 0.3% | 3.77 ± 0.1% | not timed | not timed | 22345.49 ± 0.1% | | 1.00 | 103.33 | 5921.54 |
| imported/rsc/easy0-32 | 26 | 1066.87 ± 2.8% | not timed | not timed | 1612.54 ± 4.2% | 149.02 ± 14.3% | not timed | not timed | 1069.26 ± 0.2% | | 1.00 | 0.66 | 7.16 |
| imported/rsc/easy0-1k | 26 | 14970.99 ± 1.9% | not timed | not timed | 12609.55 ± 1.5% | 2304.65 ± 13.8% | not timed | not timed | 14960.76 ± 1.8% | | 1.00 | 1.19 | 6.50 |
| imported/rsc/easy0-32k | 26 | 23004.40 ± 1.7% | not timed | not timed | 20360.05 ± 0.3% | 18779.87 ± 29.9% | not timed | not timed | 23005.16 ± 0.4% | | 1.00 | 1.13 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21618.65 ± 3.3% | not timed | not timed | 19655.32 ± 1.4% | 36099.66 ± 6.5% | not timed | not timed | 21463.45 ± 3.4% | | 1.01 | 1.10 | 0.60 |
| imported/rsc/easy1-32 | 19 | 803.64 ± 3.0% | not timed | not timed | 630.56 ± 0.1% | 126.85 ± 15.3% | not timed | not timed | 802.64 ± 2.3% | | 1.00 | 1.27 | 6.34 |
| imported/rsc/easy1-1k | 19 | 16490.39 ± 2.5% | not timed | not timed | 13121.42 ± 0.2% | 2446.46 ± 16.2% | not timed | not timed | 16440.41 ± 0.2% | | 1.00 | 1.26 | 6.74 |
| imported/rsc/easy1-32k | 19 | 517159.33 ± 0.1% | not timed | not timed | 409806.50 ± 0.2% | 20410.27 ± 0.2% | not timed | not timed | 516610.47 ± 0.2% | | 1.00 | 1.26 | 25.34 |
| imported/rsc/easy1-1mb | 19 | 16548984.28 ± 0.2% | not timed | not timed | 13058467.86 ± 0.2% | 37904.89 ± 3.3% | not timed | not timed | 16503156.65 ± 0.2% | | 1.00 | 1.27 | 436.59 |
| imported/rsc/medium-32 | 27 | 767.30 ± 1.4% | not timed | not timed | 641.29 ± 0.3% | 69.93 ± 11.2% | not timed | not timed | 774.05 ± 0.2% | | 0.99 | 1.20 | 10.97 |
| imported/rsc/medium-1k | 27 | 13654.13 ± 0.3% | not timed | not timed | 11317.20 ± 0.3% | 72.64 ± 0.1% | not timed | not timed | 13756.76 ± 0.7% | | 0.99 | 1.21 | 187.97 |
| imported/rsc/medium-32k | 27 | 427091.37 ± 0.3% | not timed | not timed | 354771.60 ± 0.2% | 48.55 ± 0.2% | not timed | not timed | 429515.69 ± 0.4% | | 0.99 | 1.20 | 8796.69 |
| imported/rsc/medium-1mb | 27 | 13632078.89 ± 0.7% | not timed | not timed | 11313509.06 ± 0.1% | 48.59 ± 0.2% | not timed | not timed | 13725963.27 ± 0.4% | | 0.99 | 1.20 | 280565.49 |
| imported/rsc/hard-32 | 58 | 422.57 ± 1.8% | not timed | not timed | 365.62 ± 0.1% | 49.56 ± 8.7% | not timed | not timed | 418.97 ± 0.3% | | 1.01 | 1.16 | 8.53 |
| imported/rsc/hard-1k | 27 | 13432.76 ± 0.4% | not timed | not timed | 11386.75 ± 0.3% | 40.78 ± 0.1% | not timed | not timed | 13383.86 ± 0.8% | | 1.00 | 1.18 | 329.38 |
| imported/rsc/hard-32k | 27 | 418351.19 ± 0.3% | not timed | not timed | 360956.30 ± 0.1% | 29.41 ± 0.1% | not timed | not timed | 417420.65 ± 0.6% | | 1.00 | 1.16 | 14225.86 |
| imported/rsc/hard-1mb | 51 | 8427399.69 ± 0.1% | not timed | not timed | 7273997.70 ± 0.1% | 29.44 ± 0.1% | not timed | not timed | 8328724.93 ± 0.4% | | 1.01 | 1.16 | 286259.14 |
| imported/rsc/reallyhard0-32 | 58 | 267.18 ± 2.3% | not timed | not timed | 225.77 ± 0.3% | 49.69 ± 7.1% | not timed | not timed | 266.76 ± 0.2% | | 1.00 | 1.18 | 5.38 |
| imported/rsc/reallyhard0-1k | 27 | 591.82 ± 0.5% | not timed | not timed | 583.71 ± 0.5% | 40.72 ± 0.2% | not timed | not timed | 590.40 ± 0.0% | | 1.00 | 1.01 | 14.53 |
| imported/rsc/reallyhard0-32k | 27 | 611.11 ± 0.4% | not timed | not timed | 615.11 ± 0.1% | 29.40 ± 0.3% | not timed | not timed | 612.09 ± 0.2% | | 1.00 | 0.99 | 20.79 |
| imported/rsc/reallyhard0-1mb | 51 | 591.62 ± 0.7% | not timed | not timed | 616.73 ± 0.2% | 29.45 ± 0.2% | not timed | not timed | 591.49 ± 0.6% | | 1.00 | 0.96 | 20.09 |
| imported/rsc/reallyreallyhard0-32 | 47 | 289.27 ± 1.8% | not timed | not timed | 197.32 ± 0.1% | 60.80 ± 7.8% | not timed | not timed | 289.50 ± 7.1% | | 1.00 | 1.47 | 4.76 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6773.32 ± 0.1% | not timed | not timed | 5973.85 ± 0.1% | 34.01 ± 6.7% | not timed | not timed | 6763.09 ± 0.2% | | 1.00 | 1.13 | 199.18 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21501.88 ± 0.1% | not timed | not timed | 19181.56 ± 0.1% | 24.90 ± 0.9% | not timed | not timed | 21508.48 ± 0.1% | | 1.00 | 1.12 | 863.70 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21707.55 ± 0.6% | not timed | not timed | 19857.33 ± 0.6% | 25.19 ± 0.1% | not timed | not timed | 21684.02 ± 0.6% | | 1.00 | 1.09 | 861.71 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.54 ± 1.5% | not timed | not timed | 213.90 ± 0.1% | 60.48 ± 11.6% | not timed | not timed | 281.83 ± 1.4% | | 1.00 | 1.32 | 4.67 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5891.13 ± 0.1% | not timed | not timed | 6251.53 ± 0.1% | 34.34 ± 1.7% | not timed | not timed | 5873.33 ± 0.1% | | 1.00 | 0.94 | 171.55 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21430.80 ± 0.1% | not timed | not timed | 19320.94 ± 0.1% | 25.02 ± 0.6% | not timed | not timed | 21421.48 ± 0.1% | | 1.00 | 1.11 | 856.41 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21363.49 ± 0.8% | not timed | not timed | 19856.96 ± 1.4% | 24.95 ± 0.8% | not timed | not timed | 21326.07 ± 1.3% | | 1.00 | 1.08 | 856.37 |
| imported/sherlock/name-sherlock | 776 | 19615.31 ± 2.7% | not timed | not timed | 18453.07 ± 0.5% | 8624.98 ± 24.7% | not timed | not timed | 19635.21 ± 2.5% | | 1.00 | 1.06 | 2.27 |
| imported/sherlock/name-holmes | 2766 | 14959.16 ± 5.4% | not timed | not timed | 15433.46 ± 0.7% | 3289.12 ± 7.0% | not timed | not timed | 15213.35 ± 6.0% | | 0.98 | 0.97 | 4.55 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19601.37 ± 1.8% | not timed | not timed | 18394.47 ± 0.5% | 8009.10 ± 33.0% | not timed | not timed | 19655.60 ± 0.6% | | 1.00 | 1.07 | 2.45 |
| imported/sherlock/name-sherlock-casei | 816 | 15547.23 ± 0.9% | not timed | not timed | 4007.60 ± 0.1% | 32.62 ± 0.3% | not timed | not timed | 15596.25 ± 0.4% | | 1.00 | 3.88 | 476.56 |
| imported/sherlock/name-holmes-casei | 2802 | 9332.12 ± 8.1% | not timed | not timed | 3311.32 ± 0.5% | 37.62 ± 0.4% | not timed | not timed | 9380.27 ± 7.9% | | 0.99 | 2.82 | 248.08 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13119.86 ± 8.3% | not timed | not timed | 3943.16 ± 0.3% | 32.58 ± 0.2% | not timed | not timed | 13143.69 ± 1.3% | | 1.00 | 3.33 | 402.67 |
| imported/sherlock/name-whitespace | 1461 | 15234.53 ± 5.9% | not timed | not timed | 14309.18 ± 0.4% | 7330.86 ± 25.2% | not timed | not timed | 15205.42 ± 7.6% | | 1.00 | 1.06 | 2.08 |
| imported/sherlock/name-alt1 | 1142 | 11608.81 ± 2.4% | not timed | not timed | 16162.43 ± 0.9% | 4093.49 ± 22.1% | not timed | not timed | 11630.57 ± 0.4% | | 1.00 | 0.72 | 2.84 |
| imported/sherlock/name-alt2 | 3542 | 8937.76 ± 0.3% | not timed | not timed | 3827.31 ± 0.3% | 31.23 ± 0.1% | not timed | not timed | 8944.01 ± 0.3% | | 1.00 | 2.34 | 286.20 |
| imported/sherlock/name-alt3 | 4507 | 5564.37 ± 0.3% | not timed | not timed | 3628.30 ± 0.1% | 9.94 ± 4.1% | not timed | not timed | 5564.18 ± 0.3% | | 1.00 | 1.53 | 559.54 |
| imported/sherlock/name-alt3-casei | 4593 | 1529.03 ± 2.6% | not timed | not timed | 285.08 ± 0.3% | 6.48 ± 0.2% | not timed | not timed | 1527.90 ± 1.6% | | 1.00 | 5.36 | 235.95 |
| imported/sherlock/name-alt4 | 3686 | 6395.61 ± 0.1% | not timed | not timed | 3773.32 ± 0.2% | 31.30 ± 0.1% | not timed | not timed | 6362.54 ± 0.2% | | 1.01 | 1.69 | 204.34 |
| imported/sherlock/name-alt4-casei | 4254 | 2809.97 ± 2.1% | not timed | not timed | 2573.26 ± 0.5% | 19.86 ± 2.8% | not timed | not timed | 2795.46 ± 11.5% | | 1.01 | 1.09 | 141.48 |
| imported/sherlock/name-alt5 | 4028 | 6434.80 ± 0.3% | not timed | not timed | 3743.18 ± 0.1% | 21.75 ± 0.1% | not timed | not timed | 6439.77 ± 0.1% | | 1.00 | 1.72 | 295.79 |
| imported/sherlock/name-alt5-casei | 4104 | 3528.51 ± 2.1% | not timed | not timed | 2223.90 ± 0.2% | 14.40 ± 0.2% | not timed | not timed | 3529.77 ± 1.1% | | 1.00 | 1.59 | 245.10 |
| imported/sherlock/no-match-uncommon | 0 | 21369.22 ± 0.7% | not timed | not timed | 19338.06 ± 0.8% | 34993.60 ± 0.5% | not timed | not timed | 21341.21 ± 0.7% | | 1.00 | 1.11 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21147.00 ± 0.7% | not timed | not timed | 19344.65 ± 0.8% | 1283.86 ± 0.6% | not timed | not timed | 21131.33 ± 0.4% | | 1.00 | 1.09 | 16.47 |
| imported/sherlock/no-match-really-common | 0 | 15851.13 ± 2.6% | not timed | not timed | 18551.03 ± 0.9% | 1291.54 ± 0.9% | not timed | not timed | 15970.62 ± 2.7% | | 0.99 | 0.85 | 12.27 |
| imported/sherlock/the-lower | 21654 | 2319.95 ± 1.3% | not timed | not timed | 2334.50 ± 0.3% | 241.35 ± 20.0% | not timed | not timed | 2323.54 ± 0.8% | | 1.00 | 0.99 | 9.61 |
| imported/sherlock/the-upper | 2223 | 12701.16 ± 1.6% | not timed | not timed | 13547.50 ± 0.7% | 2698.05 ± 9.2% | not timed | not timed | 12752.51 ± 1.0% | | 1.00 | 0.94 | 4.71 |
| imported/sherlock/the-casei | 23961 | 2013.60 ± 1.3% | not timed | not timed | 1313.52 ± 0.2% | 34.66 ± 30.4% | not timed | not timed | 2010.88 ± 0.4% | | 1.00 | 1.53 | 58.10 |
| imported/sherlock/everything-greedy | 581881 | 283.46 ± 0.8% | not timed | not timed | 165.40 ± 0.2% | 28.63 ± 32.7% | not timed | not timed | 283.57 ± 0.1% | | 1.00 | 1.71 | 9.90 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.59 ± 0.1% | not timed | not timed | 211.37 ± 1.0% | 32.92 ± 0.1% | not timed | not timed | 462.30 ± 0.2% | | 1.00 | 2.19 | 14.05 |
| imported/sherlock/letters | 447175 | 62.09 ± 7.5% | not timed | not timed | 33.03 ± 0.1% | 5.30 ± 26.7% | not timed | not timed | 62.51 ± 9.8% | | 0.99 | 1.88 | 11.72 |
| imported/sherlock/letters-upper | 14180 | 453.34 ± 1.3% | not timed | not timed | 370.73 ± 0.1% | 29.77 ± 17.8% | not timed | not timed | 453.25 ± 0.1% | | 1.00 | 1.22 | 15.23 |
| imported/sherlock/letters-lower | 432995 | 63.46 ± 1.0% | not timed | not timed | 33.69 ± 0.1% | 6.19 ± 33.0% | not timed | not timed | 63.65 ± 1.5% | | 1.00 | 1.88 | 10.25 |
| imported/sherlock/words | 447639 | 115.71 ± 0.7% | not timed | not timed | 82.84 ± 0.2% | 13.88 ± 9.0% | not timed | not timed | 116.02 ± 6.6% | | 1.00 | 1.40 | 8.33 |
| imported/sherlock/before-holmes | 4073 | 10233.36 ± 0.2% | not timed | not timed | 8412.18 ± 0.3% | 24.12 ± 0.4% | not timed | not timed | 10246.16 ± 0.3% | | 1.00 | 1.22 | 424.35 |
| imported/sherlock/before-after-holmes | 2593 | 9802.92 ± 1.1% | not timed | not timed | 9471.93 ± 0.4% | 23.97 ± 0.9% | not timed | not timed | 9809.13 ± 0.5% | | 1.00 | 1.03 | 409.04 |
| imported/sherlock/holmes-cochar-watson | 150 | 5181.73 ± 0.2% | not timed | not timed | 3423.56 ± 0.2% | 31.06 ± 0.2% | not timed | not timed | 5182.24 ± 0.2% | | 1.00 | 1.51 | 166.85 |
| imported/sherlock/holmes-coword-watson | 14309 | 1186.85 ± 0.8% | not timed | not timed | 1118.94 ± 0.2% | 6.78 ± 0.4% | not timed | not timed | 1188.12 ± 0.6% | | 1.00 | 1.06 | 175.13 |
| imported/sherlock/quotes | 14437 | 1398.38 ± 0.4% | not timed | not timed | 1763.96 ± 1.0% | 35.17 ± 0.3% | not timed | not timed | 1400.59 ± 0.4% | | 1.00 | 0.79 | 39.76 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 609.34 ± 0.3% | not timed | not timed | 15808.39 ± 1.0% | 36.79 ± 0.2% | not timed | not timed | 609.58 ± 0.1% | | 1.00 | 0.0385 | 16.56 |
| imported/sherlock/word-ending-n | 35297 | 480.15 ± 0.2% | not timed | not timed | 410.58 ± 0.1% | 23.44 ± 21.0% | not timed | not timed | 480.41 ± 1.0% | | 1.00 | 1.17 | 20.48 |
| imported/sherlock/repeated-class-negation | 2130 | 14605.19 ± 0.9% | not timed | not timed | 10918.98 ± 0.6% | 11.56 ± 0.3% | not timed | not timed | 14630.11 ± 0.7% | | 1.00 | 1.34 | 1263.40 |
| imported/sherlock/ing-suffix | 20547 | 565.99 ± 0.3% | not timed | not timed | 516.54 ± 0.1% | 28.92 ± 0.2% | not timed | not timed | 567.05 ± 0.3% | | 1.00 | 1.10 | 19.57 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 607.36 ± 0.4% | not timed | not timed | 2096.71 ± 0.7% | 20.55 ± 0.3% | not timed | not timed | 608.25 ± 0.1% | | 1.00 | 0.29 | 29.56 |
| opt/accelerate/whole-line | 239963 | 458.32 ± 0.3% | not timed | not timed | 372.49 ± 0.1% | 92.60 ± 14.0% | not timed | not timed | 458.26 ± 0.1% | | 1.00 | 1.23 | 4.95 |
| opt/accelerate/non-dna | 16745 | 427.36 ± 0.6% | not timed | not timed | 400.64 ± 0.1% | 29.55 ± 23.4% | not timed | not timed | 428.17 ± 0.9% | | 1.00 | 1.07 | 14.46 |
| opt/backtrack/words-english | 40536 | 137.02 ± 8.0% | not timed | not timed | 94.70 ± 0.2% | 19.67 ± 7.1% | not timed | not timed | 136.87 ± 1.3% | | 1.00 | 1.45 | 6.97 |
| opt/fixed-length/too-small-ascii | 0 | 311.65 ± 0.6% | not timed | not timed | 686.62 ± 2.8% | 80.25 ± 0.5% | not timed | not timed | 314.54 ± 0.4% | | 0.99 | 0.45 | 3.88 |
| opt/fixed-length/too-big-ascii | 0 | 3498.58 ± 0.7% | not timed | not timed | 5773.84 ± 0.2% | 123.10 ± 1.8% | not timed | not timed | 3482.40 ± 0.4% | | 1.00 | 0.61 | 28.42 |
| opt/fixed-length/go33484-1 | 0 | 670565.74 ± 0.6% | not timed | not timed | 1110265.85 ± 0.8% | 61419.86 ± 0.5% | not timed | not timed | 669896.71 ± 0.5% | | 1.00 | 0.60 | 10.92 |
| opt/fixed-length/go33484-2 | 0 | 670366.40 ± 0.6% | not timed | not timed | 1112638.40 ± 1.6% | 32453.14 ± 1.2% | not timed | not timed | 669466.64 ± 0.4% | | 1.00 | 0.60 | 20.66 |
| opt/fixed-length/go33484-3 | 0 | 2432.28 ± 1.4% | not timed | not timed | 110899.98 ± 0.4% | 767.90 ± 0.3% | not timed | not timed | 2422.09 ± 2.9% | | 1.00 | 0.0219 | 3.17 |
| opt/literal-alt/one-pattern | 1 | 548.04 ± 1.4% | not timed | not timed | 543.33 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 548.43 ± 1.1% | | 1.00 | 1.01 | 1359.65 |
| opt/onepass/fn-predicate | 916 | 372.14 ± 0.7% | not timed | not timed | 333.26 ± 0.3% | 201.75 ± 12.9% | not timed | not timed | 373.66 ± 0.7% | | 1.00 | 1.12 | 1.84 |
| opt/onepass/first-three-words-english | 35128 | 172.40 ± 7.0% | not timed | not timed | 200.82 ± 0.1% | 79.36 ± 10.6% | not timed | not timed | 176.82 ± 1.1% | | 0.97 | 0.86 | 2.17 |
| opt/prefilter/literal-english | 1 | 20380.98 ± 0.3% | not timed | not timed | 19523.45 ± 0.4% | 17298.31 ± 0.8% | not timed | not timed | 20406.83 ± 0.2% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14480.97 ± 1.2% | not timed | not timed | 4310.52 ± 0.2% | 32.83 ± 0.3% | not timed | not timed | 14458.82 ± 0.2% | | 1.00 | 3.36 | 441.04 |
| opt/prefilter/literal-russian | 1 | 21218.30 ± 0.4% | not timed | not timed | 19614.17 ± 0.2% | 3326.74 ± 0.2% | not timed | not timed | 21232.16 ± 0.7% | | 1.00 | 1.08 | 6.38 |
| opt/prefilter/literal-casei-russian | 1 | 8587.84 ± 0.6% | not timed | not timed | 3892.97 ± 0.2% | 31.75 ± 0.2% | not timed | not timed | 8582.57 ± 0.4% | | 1.00 | 2.21 | 270.47 |
| opt/prefilter/rust-functions | 948 | 6816.92 ± 0.2% | not timed | not timed | 8969.34 ± 0.3% | 1869.78 ± 0.4% | not timed | not timed | 6831.66 ± 0.5% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 29951581.91 ± 0.1% | not timed | not timed | 21662305.95 ± 0.2% | 50.29 ± 0.1% | not timed | not timed | 29885567.68 ± 0.1% | | 1.00 | 1.38 | 595604.29 |
| opt/reverse-inner/holmes | 2593 | 9809.02 ± 0.4% | not timed | not timed | 9490.26 ± 0.5% | 23.99 ± 1.7% | not timed | not timed | 9816.17 ± 0.6% | | 1.00 | 1.03 | 408.92 |
| opt/reverse-inner/email | 47 | 36355.08 ± 2.0% | not timed | not timed | 44946.57 ± 0.6% | 32.33 ± 0.2% | not timed | not timed | 36745.71 ± 3.3% | | 0.99 | 0.81 | 1124.65 |
| opt/reverse-inner/factored-prefix | 3542 | 600.95 ± 0.1% | not timed | not timed | 594.83 ± 0.1% | 12.55 ± 1.2% | not timed | not timed | 600.01 ± 0.1% | | 1.00 | 1.01 | 47.87 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5554.70 ± 0.1% | not timed | not timed | 611.07 ± 0.5% | 75.10 ± 0.1% | not timed | not timed | 5531.78 ± 0.1% | | 1.00 | 9.09 | 73.97 |
| opt/reverse-inner/no-quadratic-forward | 0 | 688.76 ± 3.2% | not timed | not timed | 288.90 ± 0.7% | 24.84 ± 0.0% | not timed | not timed | 688.74 ± 3.4% | | 1.00 | 2.38 | 27.73 |
| opt/reverse-suffix/holmes | 4073 | 10234.50 ± 0.7% | not timed | not timed | 8418.64 ± 0.3% | 24.14 ± 1.1% | not timed | not timed | 10264.10 ± 0.4% | | 1.00 | 1.22 | 423.94 |
| opt/reverse-suffix/no-quadratic | 0 | 5531.68 ± 0.1% | not timed | not timed | 615.32 ± 0.6% | 75.06 ± 0.3% | not timed | not timed | 5559.75 ± 0.1% | | 0.99 | 8.99 | 73.70 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 122.35 ± 1.6% | not timed | not timed | 132.03 ± 0.2% | 12.99 ± 15.2% | not timed | not timed | 122.51 ± 3.0% | | 1.00 | 0.93 | 9.42 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 121.76 ± 3.4% | not timed | not timed | 130.69 ± 0.1% | 13.23 ± 14.7% | not timed | not timed | 121.66 ± 2.4% | | 1.00 | 0.93 | 9.20 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.4% | not timed | not timed | 0.55 ± 0.2% | 111.96 ± 1.8% | not timed | not timed | 0.28 ± 0.2% | | 0.99 | 0.50 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 316.34 ± 0.3% | not timed | not timed | 293.07 ± 0.1% | 102.65 ± 0.7% | not timed | not timed | 312.31 ± 0.2% | | 1.01 | 1.08 | 3.08 |
| reported/i13-subset-regex/original-ascii | 4094 | 11127.79 ± 0.8% | not timed | not timed | 4507.18 ± 0.6% | 11.48 ± 0.1% | not timed | not timed | 11201.76 ± 0.9% | | 0.99 | 2.47 | 969.00 |
| reported/i13-subset-regex/original-unicode | 4094 | 10999.33 ± 1.3% | not timed | not timed | 252.45 ± 3.2% | 11.52 ± 1.4% | not timed | not timed | 11174.57 ± 2.7% | | 0.98 | 43.57 | 955.21 |
| reported/i13-subset-regex/big-ascii | 1955 | 10668.50 ± 1.2% | not timed | not timed | 67.64 ± 3.6% | 9.84 ± 0.1% | not timed | not timed | 10714.94 ± 1.1% | | 1.00 | 157.73 | 1083.92 |
| reported/i13-subset-regex/big-unicode | 1955 | 10612.69 ± 1.4% | not timed | not timed | 12.19 ± 54.9% | 9.86 ± 0.0% | not timed | not timed | 10705.53 ± 0.9% | | 0.99 | 870.93 | 1076.76 |
| reported/i13-subset-regex/huge-ascii | 55 | 10080.10 ± 1.2% | not timed | not timed | 10.93 ± 0.1% | 8.77 ± 0.3% | not timed | not timed | 10052.91 ± 3.0% | | 1.00 | 922.06 | 1148.77 |
| reported/i13-subset-regex/huge-unicode | 55 | 9913.99 ± 2.4% | not timed | not timed | 10.97 ± 0.3% | 8.75 ± 0.0% | not timed | not timed | 9893.25 ± 2.4% | | 1.00 | 903.69 | 1132.46 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.56 ± 0.1% | not timed | not timed | 11.04 ± 0.1% | 8.78 ± 1.1% | not timed | not timed | 3.56 ± 0.1% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.05 ± 0.1% | not timed | not timed | 10.98 ± 0.3% | 8.78 ± 0.0% | not timed | not timed | 5.04 ± 0.0% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 486.56 ± 0.2% | not timed | not timed | 104.29 ± 0.1% | 6.63 ± 0.4% | not timed | not timed | 487.82 ± 0.2% | | 1.00 | 4.67 | 73.39 |
| reported/i787-keywords/opt-ascii | 5674 | 488.11 ± 0.3% | not timed | not timed | 276.51 ± 0.2% | 10.29 ± 0.4% | not timed | not timed | 489.29 ± 0.2% | | 1.00 | 1.77 | 47.45 |
| slow/quadratic-regex-1x | 100 | 7.15 ± 0.3% | not timed | not timed | 4.95 ± 0.1% | 0.05 ± 0.2% | not timed | not timed | 7.15 ± 0.4% | | 1.00 | 1.45 | 144.91 |
| slow/quadratic-regex-2x | 199 | 3.43 ± 0.1% | not timed | not timed | 2.76 ± 0.2% | 0.01 ± 10.5% | not timed | not timed | 3.43 ± 1.5% | | 1.00 | 1.24 | 270.44 |
| slow/quadratic-haystack-1x | 100 | 21.32 ± 1.1% | not timed | not timed | 10.02 ± 0.3% | 1.02 ± 7.6% | not timed | not timed | 21.36 ± 6.6% | | 1.00 | 2.13 | 20.98 |
| slow/quadratic-haystack-2x | 200 | 17.75 ± 11.9% | not timed | not timed | 5.56 ± 0.3% | 0.55 ± 1.5% | not timed | not timed | 17.88 ± 1.3% | | 0.99 | 3.19 | 32.43 |
| unicode/codepoints/any-one | 1112064 | 290.21 ± 0.2% | not timed | not timed | 174.11 ± 0.1% | 18.44 ± 2.2% | not timed | not timed | 289.76 ± 0.4% | | 1.00 | 1.67 | 15.74 |
| unicode/codepoints/any-all | 4382592 | 269.90 ± 0.3% | not timed | not timed | 247.45 ± 0.2% | 117.18 ± 0.2% | not timed | not timed | 270.07 ± 0.6% | | 1.00 | 1.09 | 2.30 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.68 ± 0.7% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 604.23 ± 0.5% | not timed | not timed | 616.81 ± 0.1% | 135.50 ± 0.1% | not timed | not timed | 603.84 ± 0.8% | | 1.00 | 0.98 | 4.46 |
| unicode/overlapping-words/ascii | 6156 | 31.59 ± 0.2% | not timed | not timed | 38.63 ± 0.3% | 3.95 ± 1.1% | not timed | not timed | 31.59 ± 0.5% | | 1.00 | 0.82 | 8.00 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 0.1% | not timed | not timed | 4.46 ± 0.4% | 2.35 ± 0.5% | not timed | not timed | 1.45 ± 0.2% | | 1.00 | 0.32 | 0.61 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.7% | not timed | not timed | 4.10 ± 0.3% | 6.33 ± 9.3% | not timed | not timed | 1.29 ± 0.1% | | 0.99 | 0.31 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 126.48 ± 3.5% | not timed | not timed | 83.12 ± 0.3% | 12.30 ± 16.3% | not timed | not timed | 128.11 ± 1.2% | | 0.99 | 1.52 | 10.28 |
| unicode/word/boundary-long-english | 3466 | 615.28 ± 0.2% | not timed | not timed | 606.72 ± 0.2% | 32.47 ± 0.1% | not timed | not timed | 616.19 ± 0.0% | | 1.00 | 1.01 | 18.95 |
| unicode/word/around-holmes-english | 27 | 19621.76 ± 0.3% | not timed | not timed | 19137.05 ± 0.4% | 22.21 ± 0.7% | not timed | not timed | 19628.70 ± 1.1% | | 1.00 | 1.03 | 883.39 |
| wild/bibleref/long | 874 | 563.58 ± 0.2% | not timed | not timed | 582.85 ± 0.2% | 6.81 ± 0.2% | not timed | not timed | 564.08 ± 0.2% | | 1.00 | 0.97 | 82.81 |
| wild/bibleref/short | 30 | 24.91 ± 13.1% | not timed | not timed | 30.81 ± 0.1% | 14.26 ± 9.2% | not timed | not timed | 25.54 ± 4.6% | | 0.98 | 0.81 | 1.75 |
| wild/bibleref/line | 874 | 397.14 ± 0.2% | not timed | not timed | 213.94 ± 0.2% | 9.11 ± 0.1% | not timed | not timed | 394.30 ± 0.1% | | 1.01 | 1.86 | 43.59 |
| wild/caddy/caddy | 6 | 416.68 ± 11.0% | not timed | not timed | 248.81 ± 0.1% | 68.56 ± 16.2% | not timed | not timed | 418.51 ± 0.1% | | 1.00 | 1.67 | 6.08 |
| wild/dot-star-capture/rust-src-tools | 6 | 1071.76 ± 0.4% | not timed | not timed | 344.43 ± 0.4% | 13.50 ± 0.3% | not timed | not timed | 1071.81 ± 0.4% | | 1.00 | 3.11 | 79.40 |
| wild/ruff/noqa | 84 | 439.36 ± 0.2% | not timed | not timed | 461.60 ± 0.2% | 19.59 ± 2.1% | not timed | not timed | 434.86 ± 0.1% | | 1.01 | 0.95 | 22.43 |
| wild/ruff/unnecessary-coding-comment | 16 | 962.42 ± 0.5% | not timed | not timed | 701.05 ± 0.1% | 133.60 ± 10.9% | not timed | not timed | 961.00 ± 0.4% | | 1.00 | 1.37 | 7.20 |
| wild/ruff/string-quote-prefix | 2972 | 1356.33 ± 0.7% | not timed | not timed | 440.74 ± 0.1% | 316.30 ± 25.9% | not timed | not timed | 1357.04 ± 0.6% | | 1.00 | 3.08 | 4.29 |
| wild/ruff/space-around-operator | 1224378 | 220.68 ± 1.8% | not timed | not timed | 186.51 ± 0.1% | 18.24 ± 1.7% | not timed | not timed | 220.82 ± 1.8% | | 1.00 | 1.18 | 12.10 |
| wild/ruff/shebang | 282 | 986.79 ± 0.5% | not timed | not timed | 323.04 ± 0.3% | 120.75 ± 9.8% | not timed | not timed | 988.82 ± 0.3% | | 1.00 | 3.05 | 8.17 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13814.87 ± 0.4% | not timed | not timed | 13819.33 ± 0.5% | 6935.72 ± 0.8% | not timed | not timed | 13816.28 ± 0.4% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12825.10 ± 0.5% | not timed | not timed | 13490.21 ± 0.2% | 6414.33 ± 0.4% | not timed | not timed | 12849.43 ± 0.4% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13190.21 ± 0.7% | not timed | not timed | 13610.35 ± 0.7% | 6699.82 ± 34.5% | not timed | not timed | 13220.13 ± 3.3% | | 1.00 | 0.97 | 1.97 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9558.31 ± 0.1% | not timed | not timed | 13587.94 ± 0.5% | 6778.12 ± 0.7% | not timed | not timed | 9571.62 ± 0.1% | | 1.00 | 0.70 | 1.41 |
| wild/url/search | 234965 | 122.60 ± 14.2% | not timed | not timed | 65.78 ± 0.4% | 2.24 ± 0.6% | not timed | not timed | 122.39 ± 14.3% | | 1.00 | 1.86 | 54.65 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 40.1% | not timed | not timed | 0.01 ± 0.4% | 0.01 ± 13.6% | not timed | not timed | 0.03 ± 11.6% | | 0.98 | 3.05 | 4.01 |
| dictionary/compile/english-15 | 1 | 0.35 ± 21.6% | not timed | not timed | 0.07 ± 0.5% | 0.10 ± 6.0% | not timed | not timed | 0.35 ± 2.7% | | 0.99 | 4.98 | 3.34 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 1.6% | not timed | not timed | 0.02 ± 0.7% | 35.55 ± 10.9% | not timed | not timed | 0.25 ± 3.6% | | 1.00 | 13.04 | 0.0070 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.21 ± 2.1% | not timed | not timed | 11.51 ± 0.3% | 52.24 ± 18.1% | not timed | not timed | 47.48 ± 2.3% | | 0.99 | 4.10 | 0.90 |
| reported/i787-keywords/compile | 1 | 34.57 ± 13.7% | not timed | not timed | 2.12 ± 0.1% | 17.25 ± 23.7% | not timed | not timed | 34.63 ± 3.5% | | 1.00 | 16.28 | 2.00 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 363.64 ± 3.8% | not timed | not timed | 127.42 ± 0.1% | 571.68 ± 24.8% | not timed | not timed | 370.04 ± 3.3% | | 0.98 | 2.85 | 0.64 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.25 ± 1.9% | not timed | not timed | 4.11 ± 0.6% | 44.00 ± 5.4% | not timed | not timed | 47.98 ± 2.1% | | 0.98 | 11.51 | 1.07 |
| unicode/compile/one-letter | 53 | 6.70 ± 11.2% | not timed | not timed | 4.50 ± 0.8% | 66.22 ± 5.0% | not timed | not timed | 6.71 ± 12.6% | | 1.00 | 1.49 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.06 ± 16.3% | not timed | not timed | 0.10 ± 0.2% | 65.04 ± 9.0% | not timed | not timed | 1.09 ± 13.9% | | 0.97 | 10.63 | 0.0162 |
| unicode/compile/fifty-letters-ascii | 1 | 217.84 ± 6.7% | not timed | not timed | 53.76 ± 0.1% | 181.48 ± 13.7% | not timed | not timed | 222.12 ± 2.5% | | 0.98 | 4.05 | 1.20 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 383.21 ± 7.4% | not timed | not timed | 47.25 ± 0.4% | 684.15 ± 24.3% | not timed | not timed | 386.21 ± 2.1% | | 0.99 | 8.11 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 611.41 ± 3.7% | not timed | not timed | 145.51 ± 0.3% | 670.04 ± 22.1% | not timed | not timed | 617.19 ± 13.8% | | 0.99 | 4.20 | 0.91 |
| unicode/compile/negated-class-matches-codepoint | 1 | 318.96 ± 4.4% | not timed | not timed | 51.28 ± 0.4% | 1237.84 ± 2.4% | not timed | not timed | 331.08 ± 4.1% | | 0.96 | 6.22 | 0.26 |
| wild/bibleref/compile | 3 | 5.69 ± 22.9% | not timed | not timed | 1.93 ± 1.0% | 32.01 ± 21.1% | not timed | not timed | 5.87 ± 4.6% | | 0.97 | 2.96 | 0.18 |
| wild/url/compile | 1 | 0.63 ± 1.0% | not timed | not timed | 0.14 ± 0.8% | 0.43 ± 27.7% | not timed | not timed | 0.63 ± 15.4% | | 1.00 | 4.37 | 1.46 |

