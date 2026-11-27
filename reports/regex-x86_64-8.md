# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04 |
| Image version | 20261122.9.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
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
| literal: a word | 217 | 34381.30 ± 2.9% | 9541.71 ± 1.1% | 20.23 ± 0.6% | 31154.79 ± 1.0% | 8928.12 ± 12.8% | 10.83 ± 0.3% | 76.12 ± 1.1% | 35759.34 ± 3.2% | 3.60 | 0.96 | 1.10 | 3.85 |
| literal: a word that is not there | 0 | 52958.89 ± 2.6% | 8447.82 ± 1.1% | 20.19 ± 0.5% | 39815.11 ± 1.7% | 30184.99 ± 0.5% | 10.77 ± 0.4% | 71.79 ± 5.3% | 53840.96 ± 3.2% | 6.27 | 0.98 | 1.33 | 1.75 |
| literal: one of four words | 661 | 11923.32 ± 1.2% | 1381.34 ± 0.2% | 10.95 ± 0.1% | 9100.76 ± 0.4% | 19.11 ± 4.6% | 3.95 ± 1.2% | 6.44 ± 0.3% | 11882.80 ± 1.0% | 8.63 | 1.00 | 1.31 | 624.02 |
| literal: a word in any case | 217 | 28501.74 ± 4.1% | 1471.20 ± 3.2% | 15.77 ± 0.4% | 9230.75 ± 0.2% | 37.23 ± 7.0% | refused | differs | 28464.27 ± 2.1% | 19.37 | 1.00 | 3.09 | 765.63 |
| literal: an href attribute | 33 | 28710.28 ± 1.6% | 537.21 ± 0.5% | 18.38 ± 0.6% | 27235.04 ± 1.7% | 2061.59 ± 1.1% | 8.31 ± 0.4% | 60.25 ± 2.4% | 28704.06 ± 2.8% | 53.44 | 1.00 | 1.05 | 13.93 |
| literal: a word, second text | 123 | 35768.84 ± 1.4% | 3772.79 ± 0.8% | 19.96 ± 9.4% | 32015.25 ± 1.1% | 7275.81 ± 4.4% | 11.77 ± 0.4% | 65.19 ± 1.3% | 36074.40 ± 2.0% | 9.48 | 0.99 | 1.12 | 4.92 |
| class: two capitalized words | 1331 | 976.78 ± 0.4% | 529.59 ± 0.5% | 18.89 ± 0.7% | 501.84 ± 0.8% | 34.39 ± 7.0% | 9.48 ± 0.2% | 54.89 ± 0.4% | 977.86 ± 0.4% | 1.84 | 1.00 | 1.95 | 28.40 |
| class: a word that ends in ing | 3399 | 500.61 ± 0.1% | 504.12 ± 1.3% | 13.71 ± 0.3% | 472.99 ± 0.3% | 24.00 ± 4.4% | 5.32 ± 0.5% | 15.71 ± 0.7% | 505.58 ± 0.2% | 0.99 | 0.99 | 1.06 | 20.86 |
| class: a word in capitals | 2332 | 1310.36 ± 5.4% | 537.08 ± 0.4% | 19.81 ± 1.0% | 497.01 ± 0.7% | 36.79 ± 11.0% | 10.61 ± 0.2% | 76.35 ± 0.5% | 1315.75 ± 0.3% | 2.44 | 1.00 | 2.64 | 35.62 |
| class: a number | 8288 | 2390.24 ± 0.2% | 730.29 ± 0.4% | 19.79 ± 0.3% | 1466.36 ± 0.4% | 34.81 ± 17.0% | 0.34 ± 0.4% | 54.15 ± 0.3% | 2397.27 ± 0.2% | 3.27 | 1.00 | 1.63 | 68.67 |
| class: two capitalized words, second text | 5359 | 449.06 ± 0.2% | 455.70 ± 0.6% | 17.38 ± 0.6% | 417.45 ± 0.3% | 30.09 ± 9.7% | 10.75 ± 0.5% | 50.38 ± 0.3% | 440.27 ± 0.3% | 0.99 | 1.02 | 1.08 | 14.92 |
| other: a word between two words | 6104 | 720.21 ± 0.2% | 526.29 ± 0.2% | 17.28 ± 1.4% | 696.02 ± 0.9% | 105.60 ± 9.8% | 7.26 ± 0.1% | 55.86 ± 1.9% | 723.92 ± 1.1% | 1.37 | 0.99 | 1.03 | 6.82 |
| other: a number before a unit, second text | 1481 | 7102.01 ± 0.9% | 971.37 ± 0.3% | 18.92 ± 1.5% | 6406.08 ± 1.4% | 35.17 ± 0.2% | 11.21 ± 0.3% | 53.83 ± 0.4% | 7072.32 ± 0.8% | 7.31 | 1.00 | 1.11 | 201.96 |
| other: a heading's start tag | 110 | 18834.23 ± 3.4% | 653.48 ± 0.6% | 19.52 ± 1.0% | 2008.76 ± 1.0% | 1472.04 ± 5.3% | 10.12 ± 0.1% | 71.17 ± 0.5% | 18689.95 ± 2.9% | 28.82 | 1.01 | 9.38 | 12.79 |
| other: a whole word | 217 | 23878.76 ± 1.6% | 529.67 ± 0.7% | 20.77 ± 0.4% | 22392.98 ± 0.8% | 41.37 ± 0.9% | 9.54 ± 0.1% | 46.29 ± 1.0% | 24142.38 ± 0.8% | 45.08 | 0.99 | 1.07 | 577.18 |
| other: a line's first word, second text | 3716 | 1771.49 ± 5.7% | 520.34 ± 0.4% | 24.03 ± 5.9% | 1707.08 ± 2.7% | 53.27 ± 6.5% | refused | refused | 1787.09 ± 2.9% | 3.40 | 0.99 | 1.04 | 33.26 |
| other: fourteen octets before an x | 87 | 24977.80 ± 1.7% | 194.51 ± 2.8% | 5.59 ± 1.1% | 2750.47 ± 1.4% | 8.97 ± 1.0% | differs | 15.03 ± 0.9% | 24897.79 ± 1.6% | 128.42 | 1.00 | 9.08 | 2783.32 |
| other: a Greek word | 21815 | 463.23 ± 0.4% | 369.72 ± 0.6% | 24.03 ± 0.6% | 264.65 ± 1.5% | 43.71 ± 7.9% | differs | refused | 464.87 ± 0.2% | 1.25 | 1.00 | 1.75 | 10.60 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.68 ± 8.3% | 26.64 ± 1.7% | 0.79 ± 0.8% | 16.79 ± 1.1% | 2.34 ± 9.8% | differs | 3.43 ± 0.6% | 26.70 ± 1.1% | 1.00 | 1.00 | 1.59 | 11.39 |
| a UUID | 32895 | 23.26 ± 0.2% | 23.31 ± 0.3% | 0.54 ± 6.7% | 12.84 ± 0.2% | 2.51 ± 0.6% | 0.44 ± 1.1% | 2.99 ± 2.5% | 23.14 ± 0.4% | 1.00 | 1.01 | 1.81 | 9.26 |
| an IPv4 address | 33176 | 34.60 ± 3.1% | 34.42 ± 3.1% | 1.73 ± 6.7% | 23.96 ± 3.8% | 5.76 ± 2.2% | differs | 3.36 ± 2.9% | 34.16 ± 3.3% | 1.01 | 1.01 | 1.44 | 6.01 |
| a date and time | 32954 | 31.50 ± 0.8% | 31.51 ± 0.9% | 1.25 ± 0.9% | 17.99 ± 2.1% | 6.69 ± 12.5% | 0.76 ± 0.8% | 5.66 ± 2.9% | 31.53 ± 0.4% | 1.00 | 1.00 | 1.75 | 4.71 |
| a field path | 32606 | 29.03 ± 0.4% | 29.08 ± 0.2% | 0.87 ± 12.4% | 19.41 ± 4.6% | 2.93 ± 0.6% | differs | 2.37 ± 10.7% | 29.05 ± 0.3% | 1.00 | 1.00 | 1.50 | 9.92 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.81 ± 0.5% | 8.81 ± 2.8% | 8.84 ± 0.3% | 9.97 ± 1.0% | 4.68 ± 4.4% | 0.62 ± 2.7% | none | 8.72 ± 0.4% | 1.00 | 1.01 | 0.88 | 1.88 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 195.24 ± 0.3% | 195.93 ± 0.5% | 230.13 ± 0.4% | 80.80 ± 2.8% | 186.33 ± 0.9% | 540.39 ± 1.3% | 3842.22 ± 0.5% | 195.65 ± 0.4% | 1.00 | 1.00 | 2.42 | 1.05 |
| a UUID | 62 | 128.61 ± 1.2% | 128.96 ± 1.1% | 144.25 ± 0.3% | 46.94 ± 1.1% | 91.34 ± 1.8% | 199.73 ± 2.1% | 4036.51 ± 0.8% | 128.78 ± 0.6% | 1.00 | 1.00 | 2.74 | 1.41 |
| an IPv4 address | 29 | 373.44 ± 0.7% | 372.16 ± 1.0% | 520.02 ± 4.1% | 70.27 ± 0.7% | 115.27 ± 1.5% | 324.40 ± 1.1% | 6975.39 ± 0.8% | 373.11 ± 1.4% | 1.00 | 1.00 | 5.31 | 3.24 |
| a date and time | 56 | 270.32 ± 0.4% | 270.58 ± 0.3% | 341.76 ± 0.2% | 68.66 ± 0.6% | 124.04 ± 3.3% | 364.77 ± 1.0% | 4083.02 ± 1.0% | 270.52 ± 0.5% | 1.00 | 1.00 | 3.94 | 2.18 |
| a field path | 39 | 198.64 ± 2.5% | 199.60 ± 0.5% | 235.60 ± 0.7% | 73.16 ± 0.9% | 174.61 ± 3.4% | 578.75 ± 1.6% | 4644.73 ± 0.7% | 199.27 ± 0.5% | 1.00 | 1.00 | 2.71 | 1.14 |
| literal: a word | 7 | 548.10 ± 1.2% | 588.70 ± 0.4% | 1037.17 ± 0.4% | 485.45 ± 1.3% | 591.57 ± 3.5% | 1184.33 ± 0.6% | 24427.56 ± 0.9% | 548.93 ± 0.4% | 0.93 | 1.00 | 1.13 | 0.93 |
| literal: a word that is not there | 8 | 526.84 ± 0.6% | 567.86 ± 3.3% | 974.47 ± 0.9% | 444.07 ± 2.5% | 564.70 ± 1.9% | 1122.08 ± 2.0% | 23303.74 ± 0.6% | 527.90 ± 0.7% | 0.93 | 1.00 | 1.19 | 0.93 |
| literal: one of four words | 26 | 204.51 ± 0.6% | 345.57 ± 1.8% | 462.17 ± 1.3% | 41.88 ± 0.7% | 222.86 ± 2.0% | 448.84 ± 1.1% | 10580.96 ± 1.3% | 204.96 ± 0.8% | 0.59 | 1.00 | 4.88 | 0.92 |
| literal: a word in any case | 11 | 388.00 ± 1.2% | 408.14 ± 0.4% | 591.35 ± 5.9% | 14.54 ± 1.1% | 609.98 ± 2.8% | refused | 19409.15 ± 0.3% | 388.78 ± 4.0% | 0.95 | 1.00 | 26.68 | 0.64 |
| literal: an href attribute | 12 | 306.55 ± 0.8% | 319.16 ± 0.6% | 423.64 ± 0.4% | 37.27 ± 1.7% | 430.65 ± 2.3% | 950.37 ± 1.3% | 18542.15 ± 10.0% | 306.03 ± 2.3% | 0.96 | 1.00 | 8.22 | 0.71 |
| literal: a word, second text | 10 | 486.71 ± 13.8% | 532.08 ± 0.6% | 869.81 ± 1.9% | 422.13 ± 1.8% | 487.93 ± 2.7% | 1001.14 ± 0.4% | 20611.92 ± 0.3% | 486.76 ± 12.9% | 0.91 | 1.00 | 1.15 | 1.00 |
| class: two capitalized words | 23 | 387.69 ± 1.6% | 414.87 ± 2.1% | 605.76 ± 3.3% | 93.08 ± 0.9% | 448.11 ± 1.6% | 902.70 ± 1.3% | 6196.47 ± 0.3% | 388.13 ± 2.0% | 0.93 | 1.00 | 4.16 | 0.87 |
| class: a word that ends in ing | 9 | 476.00 ± 0.5% | 539.78 ± 0.8% | 957.10 ± 0.4% | 113.46 ± 1.5% | 642.96 ± 2.2% | 1355.58 ± 0.8% | 15178.39 ± 0.1% | 477.75 ± 0.4% | 0.88 | 1.00 | 4.20 | 0.74 |
| class: a word in capitals | 16 | 419.28 ± 2.9% | 450.48 ± 20.3% | 742.59 ± 3.2% | 120.09 ± 3.0% | 654.27 ± 1.5% | 1253.36 ± 1.6% | 8336.32 ± 0.7% | 418.98 ± 1.2% | 0.93 | 1.00 | 3.49 | 0.64 |
| class: a number | 6 | 527.53 ± 11.1% | 579.36 ± 0.4% | 1117.69 ± 0.7% | 36.31 ± 2.4% | 1165.94 ± 2.3% | 2159.19 ± 2.2% | 20589.00 ± 1.5% | 528.34 ± 0.6% | 0.91 | 1.00 | 14.53 | 0.45 |
| class: two capitalized words, second text | 23 | 390.42 ± 0.9% | 414.80 ± 2.1% | 605.98 ± 7.3% | 94.02 ± 2.5% | 447.75 ± 2.0% | 939.51 ± 4.5% | 6194.13 ± 2.6% | 389.84 ± 2.2% | 0.94 | 1.00 | 4.15 | 0.87 |
| other: a word between two words | 13 | 475.62 ± 1.7% | 492.43 ± 0.3% | 772.68 ± 0.2% | 119.52 ± 0.9% | 446.21 ± 1.7% | 1022.42 ± 0.4% | 13238.77 ± 4.8% | 475.92 ± 1.5% | 0.97 | 1.00 | 3.98 | 1.07 |
| other: a number before a unit, second text | 15 | 354.54 ± 3.0% | 393.61 ± 2.5% | 558.74 ± 11.2% | 33.54 ± 4.4% | 542.03 ± 4.8% | 1109.09 ± 2.4% | 13711.50 ± 2.8% | 355.31 ± 3.0% | 0.90 | 1.00 | 10.57 | 0.65 |
| other: a heading's start tag | 13 | 320.27 ± 0.9% | 326.49 ± 0.6% | 435.43 ± 11.3% | 34.92 ± 1.9% | 524.48 ± 2.5% | 1054.66 ± 0.6% | 15996.32 ± 16.5% | 320.51 ± 0.5% | 0.98 | 1.00 | 9.17 | 0.61 |
| other: a whole word | 11 | 474.86 ± 12.1% | 501.83 ± 1.8% | 810.89 ± 10.0% | 111.16 ± 1.2% | 510.65 ± 2.5% | 1020.54 ± 1.3% | 19771.52 ± 18.6% | 475.87 ± 1.4% | 0.95 | 1.00 | 4.27 | 0.93 |
| other: a line's first word, second text | 17 | 451.58 ± 0.7% | 480.81 ± 7.7% | 786.72 ± 0.6% | 114.31 ± 0.7% | 600.82 ± 1.5% | refused | refused | 453.37 ± 11.5% | 0.94 | 1.00 | 3.95 | 0.75 |
| other: fourteen octets before an x | 16 | 86.13 ± 5.7% | 122.31 ± 3.9% | 141.45 ± 0.8% | 14.09 ± 2.3% | 394.34 ± 2.1% | 452.00 ± 2.6% | 11999.53 ± 12.6% | 86.57 ± 1.3% | 0.70 | 0.99 | 6.11 | 0.22 |
| other: a Greek word | 8 | 375.46 ± 0.9% | 518.06 ± 0.6% | 885.77 ± 13.0% | 45.46 ± 1.2% | 1126.13 ± 15.3% | 2062.42 ± 2.3% | refused | 377.01 ± 0.7% | 0.72 | 1.00 | 8.26 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 24491.19 ± 1.8% | not timed | not timed | 26996.07 ± 0.7% | 1907.24 ± 12.4% | not timed | not timed | 24442.37 ± 2.3% | | 1.00 | 0.91 | 12.84 |
| 01-literal/sherlock-casei-en | 522 | 20534.87 ± 12.5% | not timed | not timed | 7059.10 ± 0.2% | 28.62 ± 0.7% | not timed | not timed | 20355.77 ± 2.6% | | 1.01 | 2.91 | 717.49 |
| 01-literal/sherlock-ru | 724 | 25265.74 ± 1.1% | not timed | not timed | 27612.55 ± 1.8% | 1053.06 ± 4.8% | not timed | not timed | 25329.56 ± 1.7% | | 1.00 | 0.92 | 23.99 |
| 01-literal/sherlock-casei-ru | 746 | 9542.50 ± 0.2% | not timed | not timed | 5535.58 ± 0.3% | 30.43 ± 24.4% | not timed | not timed | 9536.16 ± 7.9% | | 1.00 | 1.72 | 313.58 |
| 01-literal/sherlock-zh | 30 | 45639.15 ± 2.8% | not timed | not timed | 36200.48 ± 0.9% | 1262.25 ± 0.6% | not timed | not timed | 45181.29 ± 2.8% | | 1.01 | 1.26 | 36.16 |
| 02-literal-alternate/sherlock-en | 714 | 10417.71 ± 1.0% | not timed | not timed | 8934.38 ± 0.8% | 14.11 ± 3.4% | not timed | not timed | 10393.36 ± 1.0% | | 1.00 | 1.17 | 738.32 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2114.04 ± 0.9% | not timed | not timed | 1816.15 ± 1.0% | 9.44 ± 4.8% | not timed | not timed | 2112.02 ± 1.1% | | 1.00 | 1.16 | 223.87 |
| 02-literal-alternate/sherlock-ru | 899 | 7925.59 ± 0.2% | not timed | not timed | 4253.43 ± 0.4% | 18.90 ± 13.4% | not timed | not timed | 8005.17 ± 12.1% | | 0.99 | 1.86 | 419.33 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2090.15 ± 0.5% | not timed | not timed | 1047.64 ± 0.2% | 8.53 ± 6.9% | not timed | not timed | 2086.80 ± 8.3% | | 1.00 | 2.00 | 245.15 |
| 02-literal-alternate/sherlock-zh | 207 | 14704.19 ± 0.5% | not timed | not timed | 10440.38 ± 0.2% | 27.16 ± 0.8% | not timed | not timed | 14715.09 ± 0.7% | | 1.00 | 1.41 | 541.33 |
| 03-date/ascii | 111817 | 114.61 ± 11.5% | not timed | not timed | 85.38 ± 0.3% | 0.18 ± 3.5% | not timed | not timed | 114.87 ± 1.2% | | 1.00 | 1.34 | 649.20 |
| 04-ruff-noqa/real | 84 | 425.68 ± 3.8% | not timed | not timed | 425.18 ± 0.9% | 15.87 ± 1.3% | not timed | not timed | 425.23 ± 0.9% | | 1.00 | 1.00 | 26.82 |
| 04-ruff-noqa/tweaked | 44 | 698.69 ± 2.7% | not timed | not timed | 417.88 ± 1.9% | 293.84 ± 2.4% | not timed | not timed | 714.42 ± 6.6% | | 0.98 | 1.67 | 2.38 |
| 05-lexer-veryl/single | 124800 | 3.61 ± 1.7% | not timed | not timed | 4.15 ± 6.9% | 0.21 ± 6.1% | not timed | not timed | 3.64 ± 4.1% | | 0.99 | 0.87 | 17.04 |
| 06-cloud-flare-redos/original | 107 | 378.72 ± 1.7% | not timed | not timed | 192.55 ± 1.1% | 20.63 ± 0.7% | not timed | not timed | 376.83 ± 7.6% | | 1.01 | 1.97 | 18.36 |
| 06-cloud-flare-redos/simplified-short | 102 | 357.01 ± 9.1% | not timed | not timed | 191.75 ± 0.1% | 22.00 ± 0.8% | not timed | not timed | 351.67 ± 0.8% | | 1.02 | 1.86 | 16.23 |
| 06-cloud-flare-redos/simplified-long | 10000 | 511.72 ± 0.1% | not timed | not timed | 211.59 ± 0.3% | 24.07 ± 9.8% | not timed | not timed | 508.67 ± 0.8% | | 1.01 | 2.42 | 21.26 |
| 07-unicode-character-data/parse-line | 558784 | 194.80 ± 0.9% | not timed | not timed | 159.81 ± 0.2% | 37.39 ± 7.2% | not timed | not timed | 193.06 ± 12.9% | | 1.01 | 1.22 | 5.21 |
| 08-words/all-english | 56691 | 109.96 ± 0.5% | not timed | not timed | 73.66 ± 0.6% | 10.29 ± 5.0% | not timed | not timed | 110.73 ± 1.8% | | 0.99 | 1.49 | 10.68 |
| 08-words/long-english | 839 | 538.02 ± 0.4% | not timed | not timed | 514.15 ± 0.3% | 26.53 ± 31.7% | not timed | not timed | 536.08 ± 1.5% | | 1.00 | 1.05 | 20.28 |
| 09-aws-keys/full | 0 | 439.53 ± 0.3% | not timed | not timed | 440.22 ± 1.9% | 54.94 ± 7.3% | not timed | not timed | 437.50 ± 0.3% | | 1.00 | 1.00 | 8.00 |
| 09-aws-keys/quick | 0 | 935.49 ± 6.7% | not timed | not timed | 805.52 ± 0.3% | 332.37 ± 0.2% | not timed | not timed | 933.29 ± 1.3% | | 1.00 | 1.16 | 2.81 |
| 10-bounded-repeat/letters-en | 1833 | 482.76 ± 0.9% | not timed | not timed | 431.67 ± 0.4% | 16.82 ± 1.8% | not timed | not timed | 483.84 ± 0.3% | | 1.00 | 1.12 | 28.70 |
| 10-bounded-repeat/letters-ru | 3475 | 428.97 ± 0.4% | not timed | not timed | 407.93 ± 0.2% | 17.67 ± 12.3% | not timed | not timed | 427.92 ± 0.5% | | 1.00 | 1.05 | 24.28 |
| 10-bounded-repeat/context | 53 | 70.15 ± 1.4% | not timed | not timed | 55.81 ± 7.6% | 16.95 ± 3.4% | not timed | not timed | 70.22 ± 1.9% | | 1.00 | 1.26 | 4.14 |
| 10-bounded-repeat/capitals | 11 | 558.44 ± 8.4% | not timed | not timed | 533.72 ± 0.2% | 30.91 ± 0.6% | not timed | not timed | 556.65 ± 8.1% | | 1.00 | 1.05 | 18.07 |
| 11-unstructured-to-json/extract | 600 | 37.70 ± 5.4% | not timed | not timed | 62.09 ± 0.6% | 40.75 ± 0.7% | not timed | not timed | 37.66 ± 4.9% | | 1.00 | 0.61 | 0.93 |
| 12-dictionary/single | 1 | 459.23 ± 1.6% | not timed | not timed | 439.42 ± 0.2% | 0.32 ± 5.4% | not timed | not timed | 461.15 ± 1.5% | | 1.00 | 1.05 | 1415.23 |
| 14-quadratic/1x | 100 | 22.06 ± 10.3% | not timed | not timed | 9.12 ± 0.3% | 0.81 ± 2.9% | not timed | not timed | 22.36 ± 2.3% | | 0.99 | 2.42 | 27.35 |
| 14-quadratic/2x | 200 | 20.01 ± 34.6% | not timed | not timed | 4.92 ± 0.4% | 0.43 ± 1.2% | not timed | not timed | 20.15 ± 0.7% | | 0.99 | 4.07 | 46.24 |
| 14-quadratic/10x | 1000 | 11.61 ± 1.1% | not timed | not timed | 1.05 ± 0.5% | 0.09 ± 2.5% | not timed | not timed | 11.67 ± 2.6% | | 0.99 | 11.03 | 124.70 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.08 ± 10.3% | not timed | not timed | 0.38 ± 0.7% | 0.49 ± 2.6% | not timed | not timed | 1.09 ± 2.3% | | 1.00 | 2.81 | 2.21 |
| 04-ruff-noqa/compile-real | 1 | 96.23 ± 2.0% | not timed | not timed | 12.84 ± 10.4% | 124.21 ± 4.8% | not timed | not timed | 96.45 ± 0.7% | | 1.00 | 7.50 | 0.77 |
| 05-lexer-veryl/compile-single | 1 | 12.09 ± 0.3% | not timed | not timed | 2.36 ± 1.5% | 5.94 ± 2.6% | not timed | not timed | 12.13 ± 0.9% | | 1.00 | 5.11 | 2.04 |
| 07-unicode-character-data/compile | 1 | 99.00 ± 1.5% | not timed | not timed | 23.95 ± 1.4% | 33.12 ± 3.1% | not timed | not timed | 99.09 ± 0.7% | | 1.00 | 4.13 | 2.99 |
| 09-aws-keys/compile-full | 1 | 42.88 ± 1.1% | not timed | not timed | 7.39 ± 2.8% | 20.70 ± 4.8% | not timed | not timed | 43.21 ± 1.2% | | 0.99 | 5.80 | 2.07 |
| 09-aws-keys/compile-quick | 1 | 152.85 ± 1.8% | not timed | not timed | 44.76 ± 0.9% | 118.57 ± 2.6% | not timed | not timed | 153.55 ± 0.7% | | 1.00 | 3.42 | 1.29 |
| 10-bounded-repeat/compile-context | 1 | 48.34 ± 1.0% | not timed | not timed | 11.55 ± 2.0% | 15.10 ± 3.3% | not timed | not timed | 48.63 ± 2.5% | | 0.99 | 4.19 | 3.20 |
| 10-bounded-repeat/compile-capitals | 1 | 72.43 ± 0.9% | not timed | not timed | 8.83 ± 1.3% | 22.52 ± 0.7% | not timed | not timed | 72.20 ± 1.3% | | 1.00 | 8.20 | 3.22 |
| 11-unstructured-to-json/compile | 1 | 146.80 ± 2.7% | not timed | not timed | 35.88 ± 4.1% | 61.23 ± 6.4% | not timed | not timed | 144.90 ± 4.3% | | 1.01 | 4.09 | 2.40 |
| 12-dictionary/compile-single | 1 | 0.28 ± 3.0% | not timed | not timed | 0.07 ± 2.2% | 0.09 ± 18.7% | not timed | not timed | 0.28 ± 3.5% | | 0.98 | 4.05 | 3.08 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 5.27 ± 0.9% | not timed | not timed | 5.55 ± 0.3% | 0.48 ± 16.5% | not timed | not timed | 5.31 ± 0.8% | | 0.99 | 0.95 | 11.00 |
| dictionary/search/english-10 | 690 | 149.99 ± 1.3% | not timed | not timed | 108.38 ± 0.8% | 0.00 ± 0.6% | not timed | not timed | 148.30 ± 1.0% | | 1.01 | 1.38 | 33028.12 |
| dictionary/search/english-15 | 15 | 461.36 ± 2.9% | not timed | not timed | 438.94 ± 1.0% | 0.28 ± 2.0% | not timed | not timed | 463.58 ± 2.0% | | 1.00 | 1.05 | 1640.34 |
| folly/awyer-inn-busted | 1 | 18848.80 ± 9.5% | not timed | not timed | 112.97 ± 0.4% | 37.34 ± 0.3% | not timed | not timed | 18878.79 ± 0.3% | | 1.00 | 166.85 | 504.76 |
| folly/literal-never-match-rare | 0 | 53906.48 ± 2.9% | not timed | not timed | 40098.18 ± 0.4% | 53744.26 ± 1.2% | not timed | not timed | 54250.67 ± 2.1% | | 0.99 | 1.34 | 1.00 |
| folly/literal-never-match-frequent | 0 | 19016.99 ± 0.6% | not timed | not timed | 39612.14 ± 1.3% | 2082.51 ± 0.3% | not timed | not timed | 18970.18 ± 2.1% | | 1.00 | 0.48 | 9.13 |
| folly/literal-never-match-tricksy | 1 | 3223.73 ± 0.4% | not timed | not timed | 4773.19 ± 1.4% | 1507.99 ± 0.6% | not timed | not timed | 3229.41 ± 19.1% | | 1.00 | 0.68 | 2.14 |
| grep/every-line | 239963 | 1222.58 ± 0.3% | not timed | not timed | 795.98 ± 8.8% | 285.42 ± 31.8% | not timed | not timed | 1224.08 ± 7.7% | | 1.00 | 1.54 | 4.28 |
| grep/long-words-ascii | 5073 | 437.15 ± 0.2% | not timed | not timed | 413.71 ± 0.3% | 37.87 ± 6.9% | not timed | not timed | 437.19 ± 0.7% | | 1.00 | 1.06 | 11.54 |
| imported/leipzig/twain | 811 | 40411.94 ± 8.9% | not timed | not timed | 35939.92 ± 2.2% | 10121.27 ± 13.4% | not timed | not timed | 40572.51 ± 11.8% | | 1.00 | 1.12 | 3.99 |
| imported/leipzig/twain-insensitive | 965 | 12803.15 ± 0.5% | not timed | not timed | 11146.61 ± 3.2% | 35.39 ± 2.0% | not timed | not timed | 12763.75 ± 1.6% | | 1.00 | 1.15 | 361.81 |
| imported/leipzig/shing | 1540 | 22153.64 ± 7.1% | not timed | not timed | 17826.18 ± 11.3% | 29.98 ± 2.8% | not timed | not timed | 21861.05 ± 13.4% | | 1.01 | 1.24 | 738.85 |
| imported/leipzig/huck-saw | 262 | 20362.24 ± 1.5% | not timed | not timed | 15688.42 ± 4.6% | 27.51 ± 1.2% | not timed | not timed | 20379.51 ± 7.5% | | 1.00 | 1.30 | 740.07 |
| imported/leipzig/word-ending-nn | 262 | 525.98 ± 1.4% | not timed | not timed | 531.88 ± 0.2% | 21.57 ± 1.4% | not timed | not timed | 531.48 ± 0.6% | | 0.99 | 0.99 | 24.39 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 9098.07 ± 3.2% | not timed | not timed | 3150.32 ± 0.7% | 9.70 ± 1.7% | not timed | not timed | 9022.93 ± 1.3% | | 1.01 | 2.89 | 938.11 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 17224.49 ± 11.5% | not timed | not timed | 14322.06 ± 7.1% | 14.79 ± 1.3% | not timed | not timed | 16966.07 ± 8.6% | | 1.02 | 1.20 | 1164.79 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5013.92 ± 0.3% | not timed | not timed | 705.29 ± 2.1% | 9.47 ± 0.6% | not timed | not timed | 5010.29 ± 1.3% | | 1.00 | 7.11 | 529.40 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 14645.04 ± 2.6% | not timed | not timed | 530.08 ± 0.6% | 9.82 ± 3.1% | not timed | not timed | 14420.56 ± 7.3% | | 1.02 | 27.63 | 1490.76 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 13913.67 ± 3.3% | not timed | not timed | 531.41 ± 0.3% | 8.51 ± 1.5% | not timed | not timed | 13751.65 ± 4.8% | | 1.01 | 26.18 | 1634.03 |
| imported/leipzig/tom-river | 2 | 10970.78 ± 1.3% | not timed | not timed | 11239.13 ± 1.5% | 27.12 ± 1.9% | not timed | not timed | 10996.72 ± 0.9% | | 1.00 | 0.98 | 404.46 |
| imported/leipzig/ing | 78424 | 522.51 ± 0.5% | not timed | not timed | 492.41 ± 0.6% | 24.41 ± 3.7% | not timed | not timed | 521.49 ± 0.1% | | 1.00 | 1.06 | 21.40 |
| imported/leipzig/ing-whitespace | 55248 | 1527.54 ± 0.8% | not timed | not timed | 1880.02 ± 0.9% | 17.86 ± 3.5% | not timed | not timed | 1526.21 ± 1.0% | | 1.00 | 0.81 | 85.51 |
| imported/leipzig/awyer-inn | 209 | 9114.71 ± 1.1% | not timed | not timed | 11452.34 ± 1.0% | 19.46 ± 2.2% | not timed | not timed | 9130.31 ± 1.2% | | 1.00 | 0.80 | 468.37 |
| imported/leipzig/quotes-bounded | 8886 | 2033.63 ± 0.4% | not timed | not timed | 2845.14 ± 0.4% | 31.78 ± 3.0% | not timed | not timed | 2030.95 ± 0.3% | | 1.00 | 0.71 | 63.99 |
| imported/leipzig/non-ascii-alternate | 2 | 30493.94 ± 2.6% | not timed | not timed | 16489.33 ± 0.9% | 42.60 ± 1.0% | not timed | not timed | 30461.67 ± 2.7% | | 1.00 | 1.85 | 715.87 |
| imported/leipzig/math-symbols | 69 | 2126.84 ± 0.4% | not timed | not timed | 532.26 ± 0.4% | 31.33 ± 2.1% | not timed | not timed | 2117.95 ± 1.0% | | 1.00 | 4.00 | 67.90 |
| imported/leipzig/bounded-strings-ending-z | 0 | 532.84 ± 7.6% | not timed | not timed | 532.35 ± 0.4% | 20.09 ± 4.6% | not timed | not timed | 534.34 ± 2.2% | | 1.00 | 1.00 | 26.52 |
| imported/lh3lh3-reb/uri | 17549 | 662.10 ± 0.8% | not timed | not timed | 892.61 ± 1.6% | 23.84 ± 4.1% | not timed | not timed | 664.25 ± 0.4% | | 1.00 | 0.74 | 27.77 |
| imported/lh3lh3-reb/email | 15057 | 656.53 ± 1.0% | not timed | not timed | 919.96 ± 3.7% | 25.81 ± 1.0% | not timed | not timed | 660.12 ± 3.5% | | 0.99 | 0.71 | 25.43 |
| imported/lh3lh3-reb/date | 668 | 799.40 ± 3.7% | not timed | not timed | 821.32 ± 0.7% | 43.98 ± 1.7% | not timed | not timed | 797.57 ± 0.9% | | 1.00 | 0.97 | 18.18 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 616.71 ± 3.0% | not timed | not timed | 373.78 ± 0.7% | 12.78 ± 0.5% | not timed | not timed | 620.32 ± 0.3% | | 0.99 | 1.65 | 48.26 |
| imported/mariomka/email | 92 | 26997.47 ± 1.5% | not timed | not timed | 39055.76 ± 3.4% | 28.34 ± 0.1% | not timed | not timed | 28070.11 ± 4.2% | | 0.96 | 0.69 | 952.68 |
| imported/mariomka/uri | 5301 | 5386.53 ± 0.9% | not timed | not timed | 6483.16 ± 1.5% | 28.43 ± 0.6% | not timed | not timed | 5424.92 ± 3.0% | | 0.99 | 0.83 | 189.46 |
| imported/mariomka/ip | 5 | 2172.62 ± 3.0% | not timed | not timed | 2040.94 ± 1.3% | 17.95 ± 1.2% | not timed | not timed | 2170.22 ± 3.0% | | 1.00 | 1.06 | 121.01 |
| imported/rsc/no-exponential | 0 | 683.03 ± 1.1% | not timed | not timed | 323.95 ± 0.6% | 19.78 ± 2.4% | not timed | not timed | 679.37 ± 18.1% | | 1.01 | 2.11 | 34.53 |
| imported/rsc/literal | 1 | 1485.49 ± 7.7% | not timed | not timed | 1739.93 ± 0.4% | 165.15 ± 18.6% | not timed | not timed | 1447.59 ± 13.3% | | 1.03 | 0.85 | 8.99 |
| imported/rsc/not-literal | 2 | 737.32 ± 8.3% | not timed | not timed | 721.02 ± 0.3% | 41.68 ± 12.3% | not timed | not timed | 739.33 ± 0.3% | | 1.00 | 1.02 | 17.69 |
| imported/rsc/match-class | 1 | 1459.03 ± 0.4% | not timed | not timed | 1494.13 ± 0.6% | 50.08 ± 0.6% | not timed | not timed | 1457.72 ± 29.0% | | 1.00 | 0.98 | 29.13 |
| imported/rsc/match-class-in-range | 1 | 1460.15 ± 1.9% | not timed | not timed | 2773.96 ± 23.4% | 51.62 ± 22.7% | not timed | not timed | 1460.73 ± 1.6% | | 1.00 | 0.53 | 28.29 |
| imported/rsc/match-class-unicode | 1 | 483.27 ± 1.6% | not timed | not timed | 459.63 ± 0.6% | 62.09 ± 9.6% | not timed | not timed | 478.50 ± 1.2% | | 1.01 | 1.05 | 7.78 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1245.49 ± 1.1% | not timed | not timed | 897.54 ± 0.4% | 266.49 ± 1.2% | not timed | not timed | 1244.90 ± 2.0% | | 1.00 | 1.39 | 4.67 |
| imported/rsc/anchored-literal-long-non-match | 0 | 18667.78 ± 41.3% | not timed | not timed | 13463.84 ± 1.1% | 3962.02 ± 22.8% | not timed | not timed | 18649.24 ± 0.3% | | 1.00 | 1.39 | 4.71 |
| imported/rsc/anchored-literal-short-match | 4 | 650.32 ± 1.4% | not timed | not timed | 495.54 ± 1.2% | 80.91 ± 23.4% | not timed | not timed | 653.52 ± 29.5% | | 1.00 | 1.31 | 8.04 |
| imported/rsc/anchored-literal-long-match | 4 | 9767.96 ± 1.3% | not timed | not timed | 7789.18 ± 0.5% | 1198.06 ± 2.6% | not timed | not timed | 9772.33 ± 1.5% | | 1.00 | 1.25 | 8.15 |
| imported/rsc/one-pass-short | 17 | 320.59 ± 2.0% | not timed | not timed | 222.97 ± 1.4% | 27.30 ± 11.3% | not timed | not timed | 321.56 ± 2.8% | | 1.00 | 1.44 | 11.74 |
| imported/rsc/one-pass-short-not | 17 | 267.60 ± 1.8% | not timed | not timed | 230.13 ± 0.3% | 25.45 ± 10.0% | not timed | not timed | 264.67 ± 5.5% | | 1.01 | 1.16 | 10.51 |
| imported/rsc/one-pass-long-prefix | 26 | 335.32 ± 6.6% | not timed | not timed | 283.78 ± 2.2% | 85.11 ± 9.2% | not timed | not timed | 339.47 ± 1.2% | | 0.99 | 1.18 | 3.94 |
| imported/rsc/one-pass-long-prefix-not | 26 | 334.48 ± 11.2% | not timed | not timed | 285.04 ± 0.2% | 63.03 ± 19.6% | not timed | not timed | 338.41 ± 1.7% | | 0.99 | 1.17 | 5.31 |
| imported/rsc/long-needle1 | 31 | 54432.68 ± 1.5% | not timed | not timed | 39708.91 ± 2.4% | 3.32 ± 0.1% | not timed | not timed | 54273.23 ± 0.9% | | 1.00 | 1.37 | 16387.32 |
| imported/rsc/long-needle2 | 31 | 55520.55 ± 2.6% | not timed | not timed | 171.80 ± 1.2% | 3.32 ± 0.9% | not timed | not timed | 55363.91 ± 22.1% | | 1.00 | 323.16 | 16721.19 |
| imported/rsc/easy0-32 | 26 | 1575.40 ± 7.4% | not timed | not timed | 1510.15 ± 38.3% | 126.88 ± 14.7% | not timed | not timed | 1575.94 ± 0.9% | | 1.00 | 1.04 | 12.42 |
| imported/rsc/easy0-1k | 26 | 13077.96 ± 7.3% | not timed | not timed | 16219.08 ± 5.1% | 1868.25 ± 13.7% | not timed | not timed | 12983.69 ± 29.6% | | 1.01 | 0.81 | 7.00 |
| imported/rsc/easy0-32k | 26 | 51998.38 ± 8.1% | not timed | not timed | 38412.59 ± 28.1% | 20753.04 ± 0.4% | not timed | not timed | 51643.74 ± 1.2% | | 1.01 | 1.35 | 2.51 |
| imported/rsc/easy0-1mb | 26 | 53119.50 ± 1.8% | not timed | not timed | 40119.52 ± 0.6% | 54806.53 ± 2.3% | not timed | not timed | 53242.42 ± 0.9% | | 1.00 | 1.32 | 0.97 |
| imported/rsc/easy1-32 | 19 | 743.82 ± 2.9% | not timed | not timed | 646.08 ± 0.4% | 118.55 ± 15.2% | not timed | not timed | 750.94 ± 11.1% | | 0.99 | 1.15 | 6.27 |
| imported/rsc/easy1-1k | 19 | 15233.43 ± 1.8% | not timed | not timed | 12600.51 ± 1.3% | 1884.90 ± 12.4% | not timed | not timed | 15376.50 ± 9.3% | | 0.99 | 1.21 | 8.08 |
| imported/rsc/easy1-32k | 19 | 478555.60 ± 7.3% | not timed | not timed | 414420.98 ± 2.2% | 22946.37 ± 20.1% | not timed | not timed | 483790.07 ± 0.7% | | 0.99 | 1.15 | 20.86 |
| imported/rsc/easy1-1mb | 19 | 15288185.67 ± 1.9% | not timed | not timed | 13378806.41 ± 0.5% | 54107.61 ± 2.7% | not timed | not timed | 15576928.23 ± 0.8% | | 0.98 | 1.14 | 282.55 |
| imported/rsc/medium-32 | 27 | 679.80 ± 13.1% | not timed | not timed | 579.90 ± 1.1% | 60.09 ± 3.3% | not timed | not timed | 675.92 ± 1.2% | | 1.01 | 1.17 | 11.31 |
| imported/rsc/medium-1k | 27 | 12763.58 ± 1.0% | not timed | not timed | 10733.70 ± 0.9% | 61.07 ± 1.6% | not timed | not timed | 12822.85 ± 0.3% | | 1.00 | 1.19 | 209.02 |
| imported/rsc/medium-32k | 27 | 398086.89 ± 10.4% | not timed | not timed | 350465.29 ± 0.3% | 41.20 ± 19.3% | not timed | not timed | 400228.82 ± 2.2% | | 0.99 | 1.14 | 9663.05 |
| imported/rsc/medium-1mb | 27 | 12133669.29 ± 5.3% | not timed | not timed | 11113075.60 ± 5.0% | 41.58 ± 0.2% | not timed | not timed | 12821126.11 ± 0.5% | | 0.95 | 1.09 | 291834.84 |
| imported/rsc/hard-32 | 58 | 375.14 ± 4.3% | not timed | not timed | 334.87 ± 0.8% | 41.13 ± 7.8% | not timed | not timed | 376.56 ± 0.5% | | 1.00 | 1.12 | 9.12 |
| imported/rsc/hard-1k | 27 | 11868.95 ± 2.4% | not timed | not timed | 11107.47 ± 2.4% | 33.44 ± 1.3% | not timed | not timed | 11857.24 ± 0.5% | | 1.00 | 1.07 | 354.95 |
| imported/rsc/hard-32k | 27 | 370812.11 ± 4.3% | not timed | not timed | 333563.26 ± 2.4% | 25.57 ± 0.2% | not timed | not timed | 370368.56 ± 1.9% | | 1.00 | 1.11 | 14501.23 |
| imported/rsc/hard-1mb | 51 | 7558439.62 ± 1.9% | not timed | not timed | 6762228.14 ± 0.4% | 25.65 ± 42.4% | not timed | not timed | 7573922.41 ± 1.8% | | 1.00 | 1.12 | 294729.94 |
| imported/rsc/reallyhard0-32 | 58 | 238.23 ± 3.9% | not timed | not timed | 212.51 ± 2.1% | 39.54 ± 9.1% | not timed | not timed | 238.64 ± 3.1% | | 1.00 | 1.12 | 6.02 |
| imported/rsc/reallyhard0-1k | 27 | 514.02 ± 0.9% | not timed | not timed | 509.52 ± 1.6% | 33.21 ± 8.8% | not timed | not timed | 516.14 ± 0.5% | | 1.00 | 1.01 | 15.48 |
| imported/rsc/reallyhard0-32k | 27 | 531.08 ± 2.0% | not timed | not timed | 531.98 ± 0.2% | 25.47 ± 0.3% | not timed | not timed | 532.31 ± 0.4% | | 1.00 | 1.00 | 20.85 |
| imported/rsc/reallyhard0-1mb | 51 | 533.21 ± 21.6% | not timed | not timed | 533.66 ± 0.4% | 25.61 ± 14.5% | not timed | not timed | 534.30 ± 0.3% | | 1.00 | 1.00 | 20.82 |
| imported/rsc/reallyreallyhard0-32 | 47 | 266.65 ± 18.3% | not timed | not timed | 181.34 ± 3.5% | 51.00 ± 3.6% | not timed | not timed | 269.84 ± 1.4% | | 0.99 | 1.47 | 5.23 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6053.66 ± 1.9% | not timed | not timed | 6451.80 ± 1.1% | 28.16 ± 19.8% | not timed | not timed | 6025.06 ± 1.5% | | 1.00 | 0.94 | 214.97 |
| imported/rsc/reallyreallyhard0-32k | 16 | 43719.28 ± 0.5% | not timed | not timed | 32149.94 ± 1.2% | 20.75 ± 7.6% | not timed | not timed | 43631.32 ± 0.4% | | 1.00 | 1.36 | 2106.64 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 53831.30 ± 1.5% | not timed | not timed | 39212.93 ± 0.4% | 20.95 ± 0.1% | not timed | not timed | 54061.91 ± 3.2% | | 1.00 | 1.37 | 2570.01 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 257.96 ± 3.9% | not timed | not timed | 189.94 ± 0.8% | 51.40 ± 9.8% | not timed | not timed | 258.67 ± 24.5% | | 1.00 | 1.36 | 5.02 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5339.11 ± 3.3% | not timed | not timed | 6617.17 ± 0.8% | 28.25 ± 10.5% | not timed | not timed | 5343.37 ± 2.0% | | 1.00 | 0.81 | 189.01 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 41193.09 ± 2.9% | not timed | not timed | 32732.82 ± 0.7% | 21.03 ± 0.3% | not timed | not timed | 41323.97 ± 2.3% | | 1.00 | 1.26 | 1958.42 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 52467.19 ± 15.5% | not timed | not timed | 39466.02 ± 2.2% | 20.93 ± 0.3% | not timed | not timed | 52912.75 ± 2.0% | | 0.99 | 1.33 | 2506.85 |
| imported/sherlock/name-sherlock | 776 | 35110.71 ± 2.7% | not timed | not timed | 31238.46 ± 7.5% | 9622.05 ± 20.0% | not timed | not timed | 35104.89 ± 1.9% | | 1.00 | 1.12 | 3.65 |
| imported/sherlock/name-holmes | 2766 | 16296.39 ± 1.2% | not timed | not timed | 18340.95 ± 0.7% | 3027.85 ± 14.4% | not timed | not timed | 16252.03 ± 1.0% | | 1.00 | 0.89 | 5.38 |
| imported/sherlock/name-sherlock-holmes | 1365 | 35688.61 ± 1.5% | not timed | not timed | 31711.38 ± 1.4% | 7583.27 ± 16.9% | not timed | not timed | 35623.24 ± 2.0% | | 1.00 | 1.13 | 4.71 |
| imported/sherlock/name-sherlock-casei | 816 | 30065.92 ± 1.0% | not timed | not timed | 9462.62 ± 4.4% | 28.49 ± 19.1% | not timed | not timed | 29772.65 ± 1.4% | | 1.01 | 3.18 | 1055.49 |
| imported/sherlock/name-holmes-casei | 2802 | 14903.33 ± 0.5% | not timed | not timed | 5900.83 ± 10.2% | 35.37 ± 0.6% | not timed | not timed | 14813.72 ± 5.1% | | 1.01 | 2.53 | 421.32 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 26989.85 ± 1.8% | not timed | not timed | 9091.54 ± 1.2% | 28.52 ± 0.7% | not timed | not timed | 26871.01 ± 2.0% | | 1.00 | 2.97 | 946.50 |
| imported/sherlock/name-whitespace | 1461 | 21368.25 ± 1.8% | not timed | not timed | 22526.37 ± 0.6% | 6014.25 ± 22.2% | not timed | not timed | 21459.37 ± 1.6% | | 1.00 | 0.95 | 3.55 |
| imported/sherlock/name-alt1 | 1142 | 20932.56 ± 1.2% | not timed | not timed | 23236.33 ± 2.0% | 3800.52 ± 51.1% | not timed | not timed | 20977.76 ± 2.1% | | 1.00 | 0.90 | 5.51 |
| imported/sherlock/name-alt2 | 3542 | 12533.60 ± 1.3% | not timed | not timed | 7785.15 ± 0.4% | 27.19 ± 1.0% | not timed | not timed | 12502.02 ± 0.7% | | 1.00 | 1.61 | 460.93 |
| imported/sherlock/name-alt3 | 4507 | 8556.04 ± 1.0% | not timed | not timed | 7006.54 ± 0.3% | 8.70 ± 0.2% | not timed | not timed | 8579.88 ± 2.0% | | 1.00 | 1.22 | 983.88 |
| imported/sherlock/name-alt3-casei | 4593 | 1565.57 ± 1.0% | not timed | not timed | 1089.26 ± 0.2% | 5.68 ± 0.2% | not timed | not timed | 1595.08 ± 0.6% | | 0.98 | 1.44 | 275.87 |
| imported/sherlock/name-alt4 | 3686 | 7164.58 ± 2.0% | not timed | not timed | 6026.67 ± 0.5% | 27.07 ± 22.6% | not timed | not timed | 7238.04 ± 1.5% | | 0.99 | 1.19 | 264.67 |
| imported/sherlock/name-alt4-casei | 4254 | 3189.24 ± 0.7% | not timed | not timed | 3161.64 ± 30.0% | 16.67 ± 16.2% | not timed | not timed | 3203.35 ± 1.2% | | 1.00 | 1.01 | 191.35 |
| imported/sherlock/name-alt5 | 4028 | 10577.12 ± 1.3% | not timed | not timed | 7403.86 ± 1.6% | 18.95 ± 2.3% | not timed | not timed | 10566.71 ± 0.8% | | 1.00 | 1.43 | 558.30 |
| imported/sherlock/name-alt5-casei | 4104 | 4810.68 ± 2.2% | not timed | not timed | 2386.58 ± 1.4% | 12.26 ± 0.7% | not timed | not timed | 4828.41 ± 2.3% | | 1.00 | 2.02 | 392.26 |
| imported/sherlock/no-match-uncommon | 0 | 52948.12 ± 1.7% | not timed | not timed | 46508.97 ± 6.1% | 45046.75 ± 0.8% | not timed | not timed | 52929.31 ± 1.6% | | 1.00 | 1.14 | 1.18 |
| imported/sherlock/no-match-common | 0 | 51981.18 ± 1.4% | not timed | not timed | 46662.96 ± 3.6% | 1575.96 ± 0.2% | not timed | not timed | 51587.25 ± 1.4% | | 1.01 | 1.11 | 32.98 |
| imported/sherlock/no-match-really-common | 0 | 33578.90 ± 2.7% | not timed | not timed | 28487.95 ± 4.9% | 1577.45 ± 0.3% | not timed | not timed | 33235.36 ± 2.3% | | 1.01 | 1.18 | 21.29 |
| imported/sherlock/the-lower | 21654 | 2054.11 ± 2.3% | not timed | not timed | 2189.87 ± 1.3% | 232.35 ± 16.7% | not timed | not timed | 2059.51 ± 1.7% | | 1.00 | 0.94 | 8.84 |
| imported/sherlock/the-upper | 2223 | 11682.11 ± 6.1% | not timed | not timed | 18654.41 ± 2.6% | 2574.81 ± 2.9% | not timed | not timed | 11629.01 ± 1.7% | | 1.00 | 0.63 | 4.54 |
| imported/sherlock/the-casei | 23961 | 1928.83 ± 0.7% | not timed | not timed | 1126.48 ± 12.6% | 32.56 ± 37.1% | not timed | not timed | 1919.13 ± 1.0% | | 1.01 | 1.71 | 59.24 |
| imported/sherlock/everything-greedy | 581881 | 249.10 ± 4.6% | not timed | not timed | 144.37 ± 0.8% | 24.15 ± 16.0% | not timed | not timed | 249.58 ± 1.7% | | 1.00 | 1.73 | 10.31 |
| imported/sherlock/everything-greedy-nl | 594933 | 446.08 ± 0.3% | not timed | not timed | 187.23 ± 0.4% | 27.05 ± 26.6% | not timed | not timed | 445.65 ± 0.3% | | 1.00 | 2.38 | 16.49 |
| imported/sherlock/letters | 447175 | 54.13 ± 10.1% | not timed | not timed | 30.05 ± 0.5% | 4.59 ± 23.9% | not timed | not timed | 54.66 ± 0.5% | | 0.99 | 1.80 | 11.80 |
| imported/sherlock/letters-upper | 14180 | 382.54 ± 11.6% | not timed | not timed | 324.60 ± 0.3% | 24.96 ± 26.2% | not timed | not timed | 387.13 ± 1.0% | | 0.99 | 1.18 | 15.33 |
| imported/sherlock/letters-lower | 432995 | 55.38 ± 1.6% | not timed | not timed | 30.75 ± 5.3% | 4.98 ± 8.0% | not timed | not timed | 55.61 ± 22.2% | | 1.00 | 1.80 | 11.12 |
| imported/sherlock/words | 447639 | 93.33 ± 3.0% | not timed | not timed | 72.60 ± 2.3% | 12.16 ± 20.5% | not timed | not timed | 94.14 ± 2.3% | | 0.99 | 1.29 | 7.68 |
| imported/sherlock/before-holmes | 4073 | 9614.70 ± 2.8% | not timed | not timed | 9796.12 ± 0.5% | 20.18 ± 1.2% | not timed | not timed | 9627.56 ± 2.9% | | 1.00 | 0.98 | 476.54 |
| imported/sherlock/before-after-holmes | 2593 | 9364.64 ± 2.1% | not timed | not timed | 11111.94 ± 0.5% | 20.20 ± 19.7% | not timed | not timed | 9530.37 ± 1.0% | | 0.98 | 0.84 | 463.68 |
| imported/sherlock/holmes-cochar-watson | 150 | 7363.70 ± 0.3% | not timed | not timed | 5962.03 ± 0.2% | 26.63 ± 28.4% | not timed | not timed | 7389.58 ± 0.1% | | 1.00 | 1.24 | 276.48 |
| imported/sherlock/holmes-coword-watson | 14309 | 1118.47 ± 0.2% | not timed | not timed | 1077.32 ± 0.1% | 5.88 ± 0.6% | not timed | not timed | 1121.98 ± 5.3% | | 1.00 | 1.04 | 190.34 |
| imported/sherlock/quotes | 14437 | 1279.88 ± 0.6% | not timed | not timed | 1557.88 ± 0.5% | 29.32 ± 0.5% | not timed | not timed | 1282.17 ± 18.4% | | 1.00 | 0.82 | 43.65 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 25876.63 ± 0.9% | not timed | not timed | 24792.26 ± 0.9% | 31.59 ± 1.6% | not timed | not timed | 25943.35 ± 1.2% | | 1.00 | 1.04 | 819.06 |
| imported/sherlock/word-ending-n | 35297 | 408.11 ± 0.3% | not timed | not timed | 352.93 ± 0.2% | 20.32 ± 1.3% | not timed | not timed | 407.86 ± 3.2% | | 1.00 | 1.16 | 20.09 |
| imported/sherlock/repeated-class-negation | 2130 | 11233.96 ± 5.8% | not timed | not timed | 11809.75 ± 2.5% | 9.75 ± 0.6% | not timed | not timed | 11113.27 ± 3.4% | | 1.01 | 0.95 | 1152.78 |
| imported/sherlock/ing-suffix | 20547 | 488.74 ± 0.3% | not timed | not timed | 446.91 ± 3.1% | 24.37 ± 16.6% | not timed | not timed | 489.23 ± 0.4% | | 1.00 | 1.09 | 20.06 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1309.88 ± 2.2% | not timed | not timed | 1931.80 ± 0.8% | 17.81 ± 1.0% | not timed | not timed | 1330.83 ± 1.0% | | 0.98 | 0.68 | 73.54 |
| opt/accelerate/whole-line | 239963 | 438.90 ± 0.6% | not timed | not timed | 345.45 ± 1.0% | 75.24 ± 16.5% | not timed | not timed | 437.18 ± 1.1% | | 1.00 | 1.27 | 5.83 |
| opt/accelerate/non-dna | 16745 | 383.10 ± 0.5% | not timed | not timed | 369.20 ± 0.7% | 25.59 ± 54.2% | not timed | not timed | 383.50 ± 1.6% | | 1.00 | 1.04 | 14.97 |
| opt/backtrack/words-english | 40536 | 103.67 ± 9.6% | not timed | not timed | 83.65 ± 9.0% | 16.16 ± 11.2% | not timed | not timed | 102.46 ± 4.6% | | 1.01 | 1.24 | 6.42 |
| opt/fixed-length/too-small-ascii | 0 | 295.88 ± 0.2% | not timed | not timed | 622.11 ± 0.6% | 99.64 ± 2.2% | not timed | not timed | 296.20 ± 0.3% | | 1.00 | 0.48 | 2.97 |
| opt/fixed-length/too-big-ascii | 0 | 3260.48 ± 3.5% | not timed | not timed | 4911.34 ± 0.6% | 114.75 ± 0.9% | not timed | not timed | 3266.07 ± 0.7% | | 1.00 | 0.66 | 28.41 |
| opt/fixed-length/go33484-1 | 0 | 628204.86 ± 30.8% | not timed | not timed | 945952.39 ± 0.5% | 65043.39 ± 5.4% | not timed | not timed | 627704.44 ± 0.9% | | 1.00 | 0.66 | 9.66 |
| opt/fixed-length/go33484-2 | 0 | 626684.95 ± 4.0% | not timed | not timed | 945135.40 ± 0.7% | 23837.97 ± 0.6% | not timed | not timed | 628648.97 ± 26.9% | | 1.00 | 0.66 | 26.29 |
| opt/fixed-length/go33484-3 | 0 | 62847.53 ± 1.1% | not timed | not timed | 94452.79 ± 0.3% | 743.22 ± 33.3% | not timed | not timed | 62839.50 ± 1.7% | | 1.00 | 0.67 | 84.56 |
| opt/literal-alt/one-pattern | 1 | 487.38 ± 3.0% | not timed | not timed | 484.27 ± 0.7% | 0.31 ± 22.3% | not timed | not timed | 486.35 ± 2.0% | | 1.00 | 1.01 | 1584.96 |
| opt/onepass/fn-predicate | 916 | 333.40 ± 0.6% | not timed | not timed | 321.11 ± 1.0% | 176.50 ± 41.1% | not timed | not timed | 334.28 ± 1.6% | | 1.00 | 1.04 | 1.89 |
| opt/onepass/first-three-words-english | 35128 | 125.99 ± 2.4% | not timed | not timed | 188.91 ± 55.6% | 62.65 ± 11.6% | not timed | not timed | 127.85 ± 4.2% | | 0.99 | 0.67 | 2.01 |
| opt/prefilter/literal-english | 1 | 53380.68 ± 4.2% | not timed | not timed | 40160.69 ± 0.6% | 19273.72 ± 0.9% | not timed | not timed | 53345.13 ± 13.9% | | 1.00 | 1.33 | 2.77 |
| opt/prefilter/literal-casei-english | 1 | 35105.39 ± 2.2% | not timed | not timed | 11924.05 ± 6.4% | 28.90 ± 0.9% | not timed | not timed | 35314.28 ± 12.5% | | 0.99 | 2.94 | 1214.68 |
| opt/prefilter/literal-russian | 1 | 53090.88 ± 2.0% | not timed | not timed | 40036.00 ± 0.6% | 1578.65 ± 20.9% | not timed | not timed | 53729.69 ± 2.9% | | 0.99 | 1.33 | 33.63 |
| opt/prefilter/literal-casei-russian | 1 | 21970.20 ± 1.0% | not timed | not timed | 8262.27 ± 1.4% | 30.43 ± 7.4% | not timed | not timed | 21967.93 ± 1.0% | | 1.00 | 2.66 | 721.99 |
| opt/prefilter/rust-functions | 948 | 11705.15 ± 11.0% | not timed | not timed | 10458.23 ± 1.6% | 1551.11 ± 0.6% | not timed | not timed | 11701.86 ± 0.8% | | 1.00 | 1.12 | 7.55 |
| opt/reverse-anchored/word-end | 1 | 29232730.81 ± 0.5% | not timed | not timed | 22649764.84 ± 1.3% | 41.83 ± 1.6% | not timed | not timed | 29201272.44 ± 0.6% | | 1.00 | 1.29 | 698853.91 |
| opt/reverse-inner/holmes | 2593 | 9433.83 ± 2.0% | not timed | not timed | 11091.83 ± 0.7% | 20.29 ± 0.8% | not timed | not timed | 9560.83 ± 1.1% | | 0.99 | 0.85 | 465.06 |
| opt/reverse-inner/email | 47 | 52420.80 ± 4.5% | not timed | not timed | 57432.12 ± 0.8% | 27.42 ± 6.7% | not timed | not timed | 54082.92 ± 4.1% | | 0.97 | 0.91 | 1911.51 |
| opt/reverse-inner/factored-prefix | 3542 | 523.75 ± 0.1% | not timed | not timed | 515.45 ± 0.4% | 11.02 ± 0.8% | not timed | not timed | 523.12 ± 0.8% | | 1.00 | 1.02 | 47.52 |
| opt/reverse-inner/no-quadratic-backward | 0 | 17860.91 ± 3.5% | not timed | not timed | 531.27 ± 0.4% | 64.09 ± 1.5% | not timed | not timed | 17898.72 ± 2.2% | | 1.00 | 33.62 | 278.68 |
| opt/reverse-inner/no-quadratic-forward | 0 | 623.15 ± 4.8% | not timed | not timed | 246.48 ± 0.2% | 21.00 ± 0.8% | not timed | not timed | 610.82 ± 23.0% | | 1.02 | 2.53 | 29.67 |
| opt/reverse-suffix/holmes | 4073 | 9656.53 ± 1.6% | not timed | not timed | 9813.33 ± 0.3% | 20.33 ± 20.4% | not timed | not timed | 9689.44 ± 2.5% | | 1.00 | 0.98 | 474.99 |
| opt/reverse-suffix/no-quadratic | 0 | 17893.69 ± 0.5% | not timed | not timed | 532.08 ± 0.6% | 64.07 ± 2.5% | not timed | not timed | 17913.08 ± 0.4% | | 1.00 | 33.63 | 279.28 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 110.16 ± 9.0% | not timed | not timed | 131.71 ± 0.8% | 12.10 ± 14.2% | not timed | not timed | 110.22 ± 1.2% | | 1.00 | 0.84 | 9.10 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 110.22 ± 1.8% | not timed | not timed | 137.32 ± 0.9% | 11.99 ± 34.5% | not timed | not timed | 110.07 ± 1.5% | | 1.00 | 0.80 | 9.20 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.27 ± 3.5% | not timed | not timed | 0.40 ± 0.4% | 92.98 ± 0.7% | not timed | not timed | 0.27 ± 4.4% | | 1.00 | 0.67 | 0.0029 |
| reported/i1095-word-repetition/ascii-search | 256 | 267.51 ± 0.4% | not timed | not timed | 244.99 ± 1.3% | 80.98 ± 14.0% | not timed | not timed | 264.75 ± 2.3% | | 1.01 | 1.09 | 3.30 |
| reported/i13-subset-regex/original-ascii | 4094 | 9073.64 ± 1.1% | not timed | not timed | 3100.78 ± 4.7% | 9.72 ± 1.2% | not timed | not timed | 9058.43 ± 4.7% | | 1.00 | 2.93 | 933.12 |
| reported/i13-subset-regex/original-unicode | 4094 | 9106.87 ± 1.3% | not timed | not timed | 162.42 ± 1.5% | 9.66 ± 0.7% | not timed | not timed | 9088.50 ± 1.7% | | 1.00 | 56.07 | 942.76 |
| reported/i13-subset-regex/big-ascii | 1955 | 8601.72 ± 4.7% | not timed | not timed | 42.72 ± 4.5% | 8.27 ± 2.0% | not timed | not timed | 8588.21 ± 5.8% | | 1.00 | 201.34 | 1040.43 |
| reported/i13-subset-regex/big-unicode | 1955 | 8540.33 ± 1.5% | not timed | not timed | 7.79 ± 56.0% | 8.19 ± 0.7% | not timed | not timed | 8591.33 ± 0.4% | | 0.99 | 1096.19 | 1042.32 |
| reported/i13-subset-regex/huge-ascii | 55 | 8071.76 ± 1.3% | not timed | not timed | 7.26 ± 0.9% | 7.34 ± 0.5% | not timed | not timed | 8053.14 ± 2.2% | | 1.00 | 1111.41 | 1099.24 |
| reported/i13-subset-regex/huge-unicode | 55 | 7938.32 ± 2.5% | not timed | not timed | 6.96 ± 1.0% | 7.29 ± 0.7% | not timed | not timed | 7905.84 ± 1.7% | | 1.00 | 1140.44 | 1089.19 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.10 ± 1.0% | not timed | not timed | 7.19 ± 1.6% | 7.30 ± 1.3% | not timed | not timed | 3.05 ± 1.0% | | 1.02 | 0.43 | 0.42 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.31 ± 0.7% | not timed | not timed | 7.07 ± 1.7% | 7.30 ± 1.1% | not timed | not timed | 4.32 ± 0.8% | | 1.00 | 0.61 | 0.59 |
| reported/i787-keywords/ascii | 5674 | 418.88 ± 0.5% | not timed | not timed | 124.68 ± 0.1% | 4.63 ± 0.6% | not timed | not timed | 419.72 ± 6.8% | | 1.00 | 3.36 | 90.50 |
| reported/i787-keywords/opt-ascii | 5674 | 418.38 ± 0.4% | not timed | not timed | 213.70 ± 2.0% | 8.22 ± 34.9% | not timed | not timed | 418.16 ± 3.0% | | 1.00 | 1.96 | 50.87 |
| slow/quadratic-regex-1x | 100 | 5.79 ± 0.2% | not timed | not timed | 4.62 ± 0.5% | 0.04 ± 0.4% | not timed | not timed | 6.31 ± 17.0% | | 0.92 | 1.25 | 137.02 |
| slow/quadratic-regex-2x | 199 | 2.96 ± 1.3% | not timed | not timed | 2.49 ± 0.3% | 0.01 ± 0.9% | not timed | not timed | 2.97 ± 0.4% | | 0.99 | 1.19 | 273.36 |
| slow/quadratic-haystack-1x | 100 | 22.13 ± 6.4% | not timed | not timed | 9.09 ± 2.7% | 0.83 ± 13.4% | not timed | not timed | 22.40 ± 2.0% | | 0.99 | 2.43 | 26.75 |
| slow/quadratic-haystack-2x | 200 | 20.04 ± 0.8% | not timed | not timed | 4.91 ± 0.3% | 0.44 ± 2.0% | not timed | not timed | 20.12 ± 1.7% | | 1.00 | 4.08 | 45.68 |
| unicode/codepoints/any-one | 1112064 | 267.62 ± 0.7% | not timed | not timed | 184.09 ± 0.4% | 15.89 ± 18.9% | not timed | not timed | 267.75 ± 1.7% | | 1.00 | 1.45 | 16.84 |
| unicode/codepoints/any-all | 4382592 | 235.16 ± 0.6% | not timed | not timed | 235.07 ± 11.9% | 98.69 ± 1.2% | not timed | not timed | 235.11 ± 0.2% | | 1.00 | 1.00 | 2.38 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 6.27 ± 1.1% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 530.91 ± 0.3% | not timed | not timed | 532.59 ± 0.2% | 113.37 ± 1.3% | not timed | not timed | 531.24 ± 1.5% | | 1.00 | 1.00 | 4.68 |
| unicode/overlapping-words/ascii | 6156 | 21.10 ± 6.6% | not timed | not timed | 33.78 ± 8.5% | 3.50 ± 2.8% | not timed | not timed | 21.04 ± 3.0% | | 1.00 | 0.62 | 6.03 |
| unicode/overlapping-words/english | 6156 | 1.15 ± 6.1% | not timed | not timed | 2.62 ± 2.7% | 2.13 ± 6.9% | not timed | not timed | 1.16 ± 1.6% | | 1.00 | 0.44 | 0.54 |
| unicode/overlapping-words/russian | 5710 | 1.04 ± 2.4% | not timed | not timed | 2.51 ± 1.6% | 5.39 ± 7.4% | not timed | not timed | 1.07 ± 0.2% | | 0.98 | 0.42 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 111.05 ± 0.2% | not timed | not timed | 74.23 ± 0.7% | 10.76 ± 27.4% | not timed | not timed | 111.32 ± 10.9% | | 1.00 | 1.50 | 10.32 |
| unicode/word/boundary-long-english | 3466 | 534.01 ± 0.2% | not timed | not timed | 521.84 ± 0.1% | 26.70 ± 0.7% | not timed | not timed | 532.05 ± 0.8% | | 1.00 | 1.02 | 20.00 |
| unicode/word/around-holmes-english | 27 | 40836.82 ± 3.0% | not timed | not timed | 38208.80 ± 4.2% | 18.54 ± 0.6% | not timed | not timed | 41251.37 ± 2.2% | | 0.99 | 1.07 | 2203.04 |
| wild/bibleref/long | 874 | 488.16 ± 1.5% | not timed | not timed | 498.00 ± 0.4% | 6.51 ± 0.8% | not timed | not timed | 488.38 ± 0.5% | | 1.00 | 0.98 | 75.03 |
| wild/bibleref/short | 30 | 16.01 ± 6.0% | not timed | not timed | 25.92 ± 18.8% | 13.64 ± 21.8% | not timed | not timed | 17.17 ± 8.0% | | 0.93 | 0.62 | 1.17 |
| wild/bibleref/line | 874 | 392.90 ± 1.7% | not timed | not timed | 214.91 ± 22.4% | 7.72 ± 0.4% | not timed | not timed | 393.85 ± 5.3% | | 1.00 | 1.83 | 50.92 |
| wild/caddy/caddy | 6 | 343.39 ± 1.9% | not timed | not timed | 238.58 ± 0.5% | 62.01 ± 15.8% | not timed | not timed | 347.03 ± 0.8% | | 0.99 | 1.44 | 5.54 |
| wild/dot-star-capture/rust-src-tools | 6 | 1275.87 ± 0.2% | not timed | not timed | 352.61 ± 3.8% | 11.46 ± 0.5% | not timed | not timed | 1274.66 ± 0.4% | | 1.00 | 3.62 | 111.34 |
| wild/ruff/noqa | 84 | 425.88 ± 0.5% | not timed | not timed | 421.40 ± 0.7% | 16.47 ± 4.2% | not timed | not timed | 425.98 ± 0.7% | | 1.00 | 1.01 | 25.85 |
| wild/ruff/unnecessary-coding-comment | 16 | 905.42 ± 0.5% | not timed | not timed | 605.31 ± 0.4% | 116.46 ± 4.5% | not timed | not timed | 904.73 ± 1.0% | | 1.00 | 1.50 | 7.77 |
| wild/ruff/string-quote-prefix | 2972 | 1279.03 ± 0.7% | not timed | not timed | 343.14 ± 1.0% | 307.84 ± 34.5% | not timed | not timed | 1279.77 ± 21.9% | | 1.00 | 3.73 | 4.15 |
| wild/ruff/space-around-operator | 1224378 | 185.04 ± 2.2% | not timed | not timed | 182.71 ± 2.5% | 14.89 ± 3.5% | not timed | not timed | 184.04 ± 2.2% | | 1.01 | 1.01 | 12.43 |
| wild/ruff/shebang | 282 | 896.51 ± 0.7% | not timed | not timed | 320.94 ± 0.6% | 93.98 ± 3.2% | not timed | not timed | 894.70 ± 1.1% | | 1.00 | 2.79 | 9.54 |
| wild/rustsec-cargo-audit/original-unix | 471 | 16221.12 ± 9.2% | not timed | not timed | 19748.21 ± 22.5% | 6344.69 ± 1.2% | not timed | not timed | 16485.69 ± 3.4% | | 0.98 | 0.82 | 2.56 |
| wild/rustsec-cargo-audit/original-windows | 462 | 15041.95 ± 3.5% | not timed | not timed | 18574.01 ± 0.7% | 5951.19 ± 1.1% | not timed | not timed | 14978.22 ± 2.6% | | 1.00 | 0.81 | 2.53 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 16801.51 ± 1.7% | not timed | not timed | 18825.68 ± 1.9% | 6071.84 ± 1.6% | not timed | not timed | 16669.12 ± 1.4% | | 1.01 | 0.89 | 2.77 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 13717.75 ± 22.9% | not timed | not timed | 19207.00 ± 7.4% | 6277.02 ± 39.8% | not timed | not timed | 13775.96 ± 5.1% | | 1.00 | 0.71 | 2.19 |
| wild/url/search | 234965 | 96.18 ± 12.5% | not timed | not timed | 48.29 ± 4.5% | 1.90 ± 1.5% | not timed | not timed | 102.99 ± 13.2% | | 0.93 | 1.99 | 50.69 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.02 ± 62.5% | not timed | not timed | 0.01 ± 1.4% | 0.01 ± 16.2% | not timed | not timed | 0.02 ± 27.6% | | 1.00 | 2.49 | 3.92 |
| dictionary/compile/english-15 | 1 | 0.28 ± 16.8% | not timed | not timed | 0.08 ± 1.8% | 0.09 ± 23.8% | not timed | not timed | 0.28 ± 5.8% | | 0.99 | 3.72 | 3.02 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.21 ± 1.5% | not timed | not timed | 0.02 ± 11.9% | 30.69 ± 9.6% | not timed | not timed | 0.21 ± 2.9% | | 1.00 | 10.65 | 0.0070 |
| reported/i1095-word-repetition/ascii-compile | 1 | 34.92 ± 15.3% | not timed | not timed | 13.35 ± 0.3% | 50.38 ± 21.4% | not timed | not timed | 35.64 ± 2.3% | | 0.98 | 2.62 | 0.69 |
| reported/i787-keywords/compile | 1 | 30.36 ± 2.5% | not timed | not timed | 1.95 ± 8.2% | 15.49 ± 8.8% | not timed | not timed | 30.40 ± 17.5% | | 1.00 | 15.56 | 1.96 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 286.99 ± 4.7% | not timed | not timed | 116.48 ± 0.6% | 498.00 ± 23.5% | not timed | not timed | 291.42 ± 6.3% | | 0.98 | 2.46 | 0.58 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 40.67 ± 3.8% | not timed | not timed | 4.24 ± 0.7% | 39.13 ± 3.6% | not timed | not timed | 41.56 ± 4.8% | | 0.98 | 9.60 | 1.04 |
| unicode/compile/one-letter | 53 | 5.46 ± 2.6% | not timed | not timed | 4.50 ± 1.1% | 54.59 ± 4.0% | not timed | not timed | 5.47 ± 21.1% | | 1.00 | 1.21 | 0.10 |
| unicode/compile/fifty-letters | 1 | 0.91 ± 5.6% | not timed | not timed | 0.10 ± 1.7% | 57.27 ± 17.1% | not timed | not timed | 0.92 ± 11.8% | | 0.99 | 8.82 | 0.0159 |
| unicode/compile/fifty-letters-ascii | 1 | 158.30 ± 11.9% | not timed | not timed | 56.18 ± 1.3% | 163.15 ± 29.6% | not timed | not timed | 162.78 ± 3.9% | | 0.97 | 2.82 | 0.97 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 350.63 ± 27.8% | not timed | not timed | 36.40 ± 22.0% | 611.82 ± 6.7% | not timed | not timed | 354.42 ± 5.9% | | 0.99 | 9.63 | 0.57 |
| unicode/compile/match-every-line-ascii | 4 | 521.45 ± 3.8% | not timed | not timed | 134.19 ± 1.0% | 546.53 ± 24.2% | not timed | not timed | 524.49 ± 2.1% | | 0.99 | 3.89 | 0.95 |
| unicode/compile/negated-class-matches-codepoint | 1 | 271.95 ± 26.4% | not timed | not timed | 40.11 ± 11.1% | 1047.86 ± 18.2% | not timed | not timed | 288.35 ± 6.0% | | 0.94 | 6.78 | 0.26 |
| wild/bibleref/compile | 3 | 4.34 ± 32.9% | not timed | not timed | 1.95 ± 1.8% | 28.71 ± 9.3% | not timed | not timed | 4.88 ± 14.0% | | 0.89 | 2.23 | 0.15 |
| wild/url/compile | 1 | 0.56 ± 9.6% | not timed | not timed | 0.16 ± 19.7% | 0.37 ± 26.4% | not timed | not timed | 0.56 ± 9.1% | | 1.00 | 3.41 | 1.51 |

