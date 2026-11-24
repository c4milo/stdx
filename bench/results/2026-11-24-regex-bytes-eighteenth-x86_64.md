# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391571797 |
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
| literal: a word | 217 | 48416.97 ± 0.7% | 3930.50 ± 0.3% | 30.01 ± 0.5% | 38765.65 ± 4.5% | 11525.38 ± 2.3% | 12.89 ± 0.4% | 104.28 ± 0.5% | 48424.80 ± 0.2% | 12.32 | 1.00 | 1.25 | 4.20 |
| literal: a word that is not there | 0 | 63359.88 ± 1.8% | 3866.49 ± 0.3% | 29.97 ± 1.7% | 45975.42 ± 2.2% | 43424.99 ± 0.5% | 12.79 ± 0.5% | 98.40 ± 0.4% | 63491.99 ± 0.6% | 16.39 | 1.00 | 1.38 | 1.46 |
| literal: one of four words | 661 | 15072.20 ± 0.8% | 1672.29 ± 0.8% | 16.29 ± 1.9% | 11146.59 ± 15.2% | 24.56 ± 1.5% | 4.48 ± 0.1% | 8.26 ± 0.8% | 15130.34 ± 1.5% | 9.01 | 1.00 | 1.35 | 613.80 |
| literal: a word in any case | 217 | 42564.59 ± 0.6% | 1794.81 ± 1.0% | 22.39 ± 0.8% | 11312.85 ± 4.0% | 46.81 ± 13.7% | refused | differs | 42610.38 ± 0.5% | 23.72 | 1.00 | 3.76 | 909.21 |
| literal: an href attribute | 33 | 40464.60 ± 3.6% | 615.54 ± 0.4% | 28.72 ± 0.9% | 34688.11 ± 0.8% | 3022.37 ± 1.6% | 9.67 ± 0.9% | 91.27 ± 0.2% | 40726.82 ± 1.2% | 65.74 | 0.99 | 1.17 | 13.39 |
| literal: a word, second text | 123 | 49334.67 ± 0.5% | 3094.59 ± 0.3% | 29.80 ± 0.4% | 39046.41 ± 0.8% | 10080.54 ± 8.4% | 14.45 ± 0.3% | 87.50 ± 0.6% | 49338.35 ± 0.6% | 15.94 | 1.00 | 1.26 | 4.89 |
| class: two capitalized words | 1331 | 906.24 ± 3.1% | 605.26 ± 0.3% | 27.84 ± 1.2% | 574.27 ± 0.7% | 43.45 ± 1.1% | 11.08 ± 1.5% | 79.70 ± 4.2% | 905.99 ± 0.4% | 1.50 | 1.00 | 1.58 | 20.86 |
| class: a word that ends in ing | 3399 | 575.33 ± 0.7% | 574.89 ± 0.7% | 19.65 ± 0.9% | 539.47 ± 0.3% | 29.67 ± 5.9% | 6.20 ± 0.4% | 20.20 ± 1.4% | 575.54 ± 2.9% | 1.00 | 1.00 | 1.07 | 19.39 |
| class: a word in capitals | 2332 | 1141.56 ± 4.3% | 607.38 ± 0.6% | 29.47 ± 5.1% | 557.32 ± 7.0% | 46.78 ± 17.0% | 12.33 ± 1.1% | 100.75 ± 16.5% | 1140.86 ± 2.3% | 1.88 | 1.00 | 2.05 | 24.40 |
| class: a number | 8288 | 1822.91 ± 0.2% | 806.57 ± 7.8% | 29.55 ± 1.7% | 1765.43 ± 1.1% | 49.03 ± 11.6% | 0.39 ± 0.8% | 72.55 ± 5.5% | 1788.41 ± 5.5% | 2.26 | 1.02 | 1.03 | 37.18 |
| class: two capitalized words, second text | 5359 | 512.64 ± 0.2% | 518.28 ± 0.2% | 25.18 ± 0.4% | 477.58 ± 0.3% | 37.42 ± 5.1% | 12.74 ± 1.7% | 73.72 ± 6.5% | 511.92 ± 0.5% | 0.99 | 1.00 | 1.07 | 13.70 |
| other: a word between two words | 6104 | 840.74 ± 0.2% | 584.64 ± 1.7% | 24.84 ± 0.7% | 813.19 ± 3.8% | 120.68 ± 11.1% | 8.54 ± 0.3% | 81.27 ± 7.3% | 840.44 ± 1.3% | 1.44 | 1.00 | 1.03 | 6.97 |
| other: a number before a unit, second text | 1481 | 10357.80 ± 0.5% | 1057.57 ± 0.9% | 28.06 ± 1.1% | 8095.40 ± 0.8% | 44.34 ± 0.3% | 13.29 ± 0.3% | 78.43 ± 0.8% | 10304.08 ± 0.4% | 9.79 | 1.01 | 1.28 | 233.58 |
| other: a heading's start tag | 110 | 25487.16 ± 0.3% | 746.84 ± 0.1% | 29.84 ± 0.4% | 2511.51 ± 3.5% | 1973.41 ± 10.6% | 11.85 ± 0.4% | 107.09 ± 1.0% | 25381.33 ± 0.4% | 34.13 | 1.00 | 10.15 | 12.92 |
| other: a whole word | 217 | 31566.19 ± 0.3% | 607.57 ± 0.1% | 30.14 ± 1.8% | 28251.58 ± 0.6% | 51.46 ± 0.5% | 11.24 ± 0.2% | 62.68 ± 0.6% | 31536.95 ± 0.3% | 51.95 | 1.00 | 1.12 | 613.40 |
| other: a line's first word, second text | 3716 | 2536.09 ± 1.5% | 587.39 ± 9.6% | 32.04 ± 0.3% | 2308.31 ± 2.1% | 66.43 ± 3.9% | refused | refused | 2559.38 ± 9.2% | 4.32 | 0.99 | 1.10 | 38.18 |
| other: fourteen octets before an x | 87 | 37315.12 ± 2.6% | 247.00 ± 3.1% | 7.24 ± 2.3% | 3436.52 ± 0.3% | 11.05 ± 0.4% | differs | 20.56 ± 2.7% | 37257.49 ± 1.9% | 151.07 | 1.00 | 10.86 | 3376.69 |
| other: a Greek word | 21815 | 459.54 ± 0.6% | 395.10 ± 0.3% | 33.13 ± 0.3% | 303.44 ± 0.5% | 52.51 ± 10.7% | differs | refused | 461.56 ± 0.4% | 1.16 | 1.00 | 1.51 | 8.75 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 21.32 ± 1.1% | 21.53 ± 0.4% | 0.93 ± 0.9% | 19.80 ± 0.2% | 2.33 ± 13.5% | differs | 4.18 ± 2.3% | 21.51 ± 0.4% | 0.99 | 0.99 | 1.08 | 9.17 |
| a UUID | 32895 | 24.05 ± 1.3% | 24.01 ± 5.2% | 0.72 ± 6.0% | 15.13 ± 1.6% | 3.00 ± 3.0% | 0.52 ± 0.3% | 3.80 ± 3.0% | 24.15 ± 0.3% | 1.00 | 1.00 | 1.59 | 8.01 |
| an IPv4 address | 33176 | 40.01 ± 13.8% | 39.88 ± 0.6% | 2.29 ± 1.3% | 28.40 ± 1.1% | 6.81 ± 1.9% | differs | 4.07 ± 1.0% | 39.80 ± 4.7% | 1.00 | 1.01 | 1.41 | 5.88 |
| a date and time | 32954 | 35.93 ± 2.4% | 35.71 ± 11.7% | 1.71 ± 0.6% | 21.61 ± 0.4% | 7.98 ± 4.7% | 0.92 ± 0.3% | 7.34 ± 3.4% | 35.14 ± 8.2% | 1.01 | 1.02 | 1.66 | 4.50 |
| a field path | 32606 | 25.24 ± 0.4% | 25.21 ± 3.1% | 1.14 ± 2.5% | 22.91 ± 8.0% | 3.47 ± 3.7% | differs | 2.96 ± 1.7% | 25.22 ± 1.4% | 1.00 | 1.00 | 1.10 | 7.27 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.03 ± 0.4% | 10.99 ± 2.4% | 11.04 ± 0.9% | 13.11 ± 11.2% | 5.53 ± 13.3% | 0.76 ± 10.1% | none | 10.97 ± 1.0% | 1.00 | 1.01 | 0.84 | 1.99 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 227.94 ± 0.7% | 229.47 ± 1.7% | 273.83 ± 5.3% | 101.00 ± 8.0% | 220.60 ± 6.4% | 698.23 ± 4.2% | 4902.64 ± 0.8% | 228.78 ± 8.0% | 0.99 | 1.00 | 2.26 | 1.03 |
| a UUID | 62 | 149.35 ± 10.5% | 149.84 ± 0.8% | 168.17 ± 0.7% | 58.43 ± 1.0% | 113.29 ± 12.7% | 249.88 ± 2.7% | 5348.14 ± 11.1% | 149.66 ± 0.2% | 1.00 | 1.00 | 2.56 | 1.32 |
| an IPv4 address | 29 | 471.13 ± 0.4% | 473.88 ± 0.7% | 696.37 ± 11.4% | 87.96 ± 0.3% | 147.92 ± 2.2% | 413.86 ± 2.0% | 8980.82 ± 0.7% | 469.66 ± 0.9% | 0.99 | 1.00 | 5.36 | 3.19 |
| a date and time | 56 | 342.54 ± 0.3% | 344.39 ± 0.3% | 446.91 ± 0.6% | 86.49 ± 0.9% | 160.20 ± 3.2% | 455.44 ± 0.4% | 5549.76 ± 0.1% | 342.70 ± 0.7% | 0.99 | 1.00 | 3.96 | 2.14 |
| a field path | 39 | 222.92 ± 0.3% | 224.12 ± 0.2% | 263.42 ± 0.4% | 95.46 ± 1.6% | 226.89 ± 2.2% | 727.71 ± 2.9% | 5915.79 ± 0.7% | 222.89 ± 0.2% | 0.99 | 1.00 | 2.34 | 0.98 |
| literal: a word | 7 | 685.29 ± 0.4% | 731.73 ± 0.7% | 1392.27 ± 0.5% | 653.03 ± 1.0% | 779.28 ± 5.9% | 1623.48 ± 0.7% | 34106.28 ± 1.6% | 684.43 ± 0.1% | 0.94 | 1.00 | 1.05 | 0.88 |
| literal: a word that is not there | 8 | 665.36 ± 8.2% | 712.99 ± 0.7% | 1309.93 ± 0.2% | 599.44 ± 1.4% | 758.91 ± 3.5% | 1530.75 ± 0.3% | 33426.77 ± 16.6% | 665.93 ± 0.6% | 0.93 | 1.00 | 1.11 | 0.88 |
| literal: one of four words | 26 | 257.73 ± 0.6% | 432.41 ± 0.4% | 603.89 ± 0.2% | 53.40 ± 0.8% | 287.36 ± 3.2% | 582.63 ± 1.3% | 17448.02 ± 1.7% | 257.13 ± 9.9% | 0.60 | 1.00 | 4.83 | 0.90 |
| literal: a word in any case | 11 | 467.16 ± 0.9% | 494.83 ± 1.0% | 738.10 ± 0.4% | 18.82 ± 0.5% | 814.44 ± 2.7% | refused | 26429.87 ± 0.7% | 465.59 ± 8.6% | 0.94 | 1.00 | 24.83 | 0.57 |
| literal: an href attribute | 12 | 379.65 ± 0.2% | 392.87 ± 0.2% | 537.36 ± 0.2% | 50.77 ± 0.7% | 556.86 ± 26.7% | 1250.75 ± 1.6% | 24540.77 ± 2.2% | 379.76 ± 0.1% | 0.97 | 1.00 | 7.48 | 0.68 |
| literal: a word, second text | 10 | 619.17 ± 0.8% | 672.40 ± 0.3% | 1184.76 ± 1.2% | 542.23 ± 0.5% | 642.40 ± 5.9% | 1324.06 ± 1.8% | 32143.92 ± 0.5% | 620.30 ± 0.3% | 0.92 | 1.00 | 1.14 | 0.96 |
| class: two capitalized words | 23 | 479.81 ± 0.5% | 523.84 ± 1.1% | 791.08 ± 1.4% | 122.02 ± 16.1% | 573.43 ± 25.7% | 1263.72 ± 0.9% | 7918.66 ± 1.2% | 478.58 ± 0.3% | 0.92 | 1.00 | 3.93 | 0.84 |
| class: a word that ends in ing | 9 | 587.58 ± 5.6% | 680.89 ± 0.7% | 1266.14 ± 0.6% | 151.43 ± 1.7% | 823.65 ± 43.4% | 1837.26 ± 6.5% | 19281.91 ± 2.0% | 587.93 ± 1.9% | 0.86 | 1.00 | 3.88 | 0.71 |
| class: a word in capitals | 16 | 522.96 ± 11.1% | 579.28 ± 1.0% | 992.57 ± 0.4% | 157.64 ± 2.0% | 855.10 ± 5.0% | 1741.02 ± 1.6% | 10598.79 ± 0.9% | 523.74 ± 0.6% | 0.90 | 1.00 | 3.32 | 0.61 |
| class: a number | 6 | 644.63 ± 3.2% | 732.84 ± 0.1% | 1488.89 ± 0.4% | 47.71 ± 0.7% | 1597.24 ± 2.3% | 2941.39 ± 2.2% | 25916.44 ± 0.6% | 645.30 ± 0.4% | 0.88 | 1.00 | 13.51 | 0.40 |
| class: two capitalized words, second text | 23 | 478.77 ± 0.7% | 521.57 ± 5.4% | 792.01 ± 0.9% | 121.75 ± 5.1% | 578.90 ± 7.4% | 1249.92 ± 1.7% | 7931.62 ± 0.3% | 479.18 ± 6.6% | 0.92 | 1.00 | 3.93 | 0.83 |
| other: a word between two words | 13 | 596.95 ± 0.3% | 620.66 ± 1.2% | 1032.36 ± 1.0% | 157.90 ± 1.2% | 578.61 ± 30.3% | 1313.89 ± 3.1% | 17859.99 ± 0.7% | 595.76 ± 0.6% | 0.96 | 1.00 | 3.78 | 1.03 |
| other: a number before a unit, second text | 15 | 410.12 ± 0.3% | 460.26 ± 0.5% | 660.75 ± 1.0% | 44.53 ± 1.3% | 702.97 ± 34.0% | 1450.30 ± 2.1% | 17693.62 ± 1.1% | 409.94 ± 0.3% | 0.89 | 1.00 | 9.21 | 0.58 |
| other: a heading's start tag | 13 | 388.92 ± 0.3% | 396.26 ± 0.2% | 538.85 ± 12.1% | 48.26 ± 0.9% | 642.59 ± 6.8% | 1343.14 ± 5.5% | 20644.32 ± 0.6% | 388.50 ± 0.2% | 0.98 | 1.00 | 8.06 | 0.61 |
| other: a whole word | 11 | 607.36 ± 2.0% | 652.48 ± 0.7% | 1127.98 ± 0.5% | 142.86 ± 1.4% | 607.03 ± 3.5% | 1369.11 ± 7.7% | 31287.28 ± 0.8% | 616.33 ± 1.7% | 0.93 | 0.99 | 4.25 | 1.00 |
| other: a line's first word, second text | 17 | 563.39 ± 1.3% | 591.94 ± 0.2% | 1012.41 ± 0.4% | 150.21 ± 0.9% | 729.79 ± 2.3% | refused | refused | 566.10 ± 0.7% | 0.95 | 1.00 | 3.75 | 0.77 |
| other: fourteen octets before an x | 16 | 114.81 ± 3.0% | 168.75 ± 1.1% | 203.81 ± 0.6% | 18.21 ± 0.4% | 472.47 ± 2.7% | 575.39 ± 1.0% | 15826.04 ± 0.6% | 114.33 ± 0.3% | 0.68 | 1.00 | 6.31 | 0.24 |
| other: a Greek word | 8 | 433.31 ± 3.2% | 612.18 ± 0.5% | 1076.89 ± 1.2% | 62.99 ± 0.3% | 1487.19 ± 2.7% | 2792.21 ± 0.7% | refused | 433.36 ± 0.3% | 0.71 | 1.00 | 6.88 | 0.29 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 37048.29 ± 0.4% | not timed | not timed | 33524.66 ± 1.3% | 2884.07 ± 4.6% | not timed | not timed | 37039.11 ± 0.3% | | 1.00 | 1.11 | 12.85 |
| 01-literal/sherlock-casei-en | 522 | 29531.64 ± 1.7% | not timed | not timed | 9009.13 ± 0.5% | 33.33 ± 14.3% | not timed | not timed | 29303.95 ± 17.8% | | 1.01 | 3.28 | 886.17 |
| 01-literal/sherlock-ru | 724 | 38747.17 ± 0.6% | not timed | not timed | 34107.28 ± 0.6% | 1267.67 ± 17.3% | not timed | not timed | 38722.56 ± 1.1% | | 1.00 | 1.14 | 30.57 |
| 01-literal/sherlock-casei-ru | 746 | 12414.30 ± 10.4% | not timed | not timed | 7777.62 ± 0.9% | 37.39 ± 2.3% | not timed | not timed | 12442.41 ± 0.4% | | 1.00 | 1.60 | 332.06 |
| 01-literal/sherlock-zh | 30 | 60236.75 ± 0.8% | not timed | not timed | 42623.34 ± 0.6% | 1628.26 ± 0.8% | not timed | not timed | 60340.95 ± 1.7% | | 1.00 | 1.41 | 36.99 |
| 02-literal-alternate/sherlock-en | 714 | 13706.64 ± 0.6% | not timed | not timed | 10838.58 ± 0.7% | 16.26 ± 0.2% | not timed | not timed | 13693.89 ± 0.5% | | 1.00 | 1.26 | 842.93 |
| 02-literal-alternate/sherlock-casei-en | 725 | 5060.72 ± 3.3% | not timed | not timed | 2300.81 ± 1.1% | 11.19 ± 1.3% | not timed | not timed | 5160.50 ± 3.5% | | 0.98 | 2.20 | 452.11 |
| 02-literal-alternate/sherlock-ru | 899 | 10724.13 ± 0.2% | not timed | not timed | 9736.06 ± 1.1% | 25.29 ± 0.4% | not timed | not timed | 10920.02 ± 0.8% | | 0.98 | 1.10 | 424.09 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2520.04 ± 3.0% | not timed | not timed | 1197.81 ± 0.1% | 10.49 ± 1.3% | not timed | not timed | 2527.28 ± 2.8% | | 1.00 | 2.10 | 240.31 |
| 02-literal-alternate/sherlock-zh | 207 | 19617.18 ± 12.8% | not timed | not timed | 12548.94 ± 11.3% | 32.57 ± 1.0% | not timed | not timed | 19638.22 ± 0.7% | | 1.00 | 1.56 | 602.26 |
| 03-date/ascii | 111817 | 126.83 ± 9.3% | not timed | not timed | 99.00 ± 8.9% | 0.22 ± 2.9% | not timed | not timed | 127.15 ± 0.8% | | 1.00 | 1.28 | 564.52 |
| 04-ruff-noqa/real | 84 | 489.79 ± 0.9% | not timed | not timed | 516.60 ± 0.3% | 20.70 ± 1.7% | not timed | not timed | 490.62 ± 0.2% | | 1.00 | 0.95 | 23.66 |
| 04-ruff-noqa/tweaked | 44 | 614.67 ± 4.6% | not timed | not timed | 514.77 ± 4.2% | 365.98 ± 5.6% | not timed | not timed | 619.83 ± 2.4% | | 0.99 | 1.19 | 1.68 |
| 05-lexer-veryl/single | 124800 | 5.04 ± 3.0% | not timed | not timed | 5.31 ± 8.9% | 0.26 ± 6.3% | not timed | not timed | 4.98 ± 14.0% | | 1.01 | 0.95 | 19.66 |
| 06-cloud-flare-redos/original | 107 | 403.44 ± 5.8% | not timed | not timed | 228.90 ± 6.2% | 24.14 ± 0.7% | not timed | not timed | 404.97 ± 1.9% | | 1.00 | 1.76 | 16.71 |
| 06-cloud-flare-redos/simplified-short | 102 | 395.83 ± 0.7% | not timed | not timed | 236.63 ± 3.1% | 23.83 ± 15.6% | not timed | not timed | 396.10 ± 0.2% | | 1.00 | 1.67 | 16.61 |
| 06-cloud-flare-redos/simplified-long | 10000 | 499.64 ± 1.3% | not timed | not timed | 258.77 ± 0.5% | 29.83 ± 0.1% | not timed | not timed | 500.81 ± 0.8% | | 1.00 | 1.93 | 16.75 |
| 07-unicode-character-data/parse-line | 558784 | 249.78 ± 3.4% | not timed | not timed | 199.53 ± 8.2% | 44.04 ± 7.0% | not timed | not timed | 221.97 ± 28.7% | | 1.13 | 1.25 | 5.67 |
| 08-words/all-english | 56691 | 111.27 ± 1.7% | not timed | not timed | 83.08 ± 0.1% | 13.68 ± 10.9% | not timed | not timed | 111.77 ± 0.6% | | 1.00 | 1.34 | 8.13 |
| 08-words/long-english | 839 | 614.89 ± 0.2% | not timed | not timed | 584.08 ± 3.2% | 35.13 ± 0.4% | not timed | not timed | 615.26 ± 0.4% | | 1.00 | 1.05 | 17.50 |
| 09-aws-keys/full | 0 | 495.36 ± 10.9% | not timed | not timed | 540.64 ± 0.6% | 66.77 ± 5.8% | not timed | not timed | 495.63 ± 0.6% | | 1.00 | 0.92 | 7.42 |
| 09-aws-keys/quick | 0 | 1151.77 ± 0.2% | not timed | not timed | 960.91 ± 0.9% | 409.70 ± 0.6% | not timed | not timed | 1138.23 ± 0.4% | | 1.01 | 1.20 | 2.81 |
| 10-bounded-repeat/letters-en | 1833 | 679.23 ± 2.8% | not timed | not timed | 557.01 ± 3.5% | 22.95 ± 1.9% | not timed | not timed | 679.40 ± 1.2% | | 1.00 | 1.22 | 29.59 |
| 10-bounded-repeat/letters-ru | 3475 | 520.63 ± 10.8% | not timed | not timed | 482.90 ± 5.0% | 24.14 ± 17.5% | not timed | not timed | 523.85 ± 3.1% | | 0.99 | 1.08 | 21.57 |
| 10-bounded-repeat/context | 53 | 87.29 ± 5.0% | not timed | not timed | 66.44 ± 8.5% | 22.05 ± 4.2% | not timed | not timed | 88.21 ± 3.1% | | 0.99 | 1.31 | 3.96 |
| 10-bounded-repeat/capitals | 11 | 636.42 ± 7.9% | not timed | not timed | 603.33 ± 8.2% | 40.11 ± 0.6% | not timed | not timed | 637.61 ± 7.8% | | 1.00 | 1.05 | 15.87 |
| 11-unstructured-to-json/extract | 600 | 49.00 ± 0.7% | not timed | not timed | 80.64 ± 1.0% | 51.34 ± 1.8% | not timed | not timed | 49.13 ± 0.4% | | 1.00 | 0.61 | 0.95 |
| 12-dictionary/single | 1 | 513.66 ± 0.3% | not timed | not timed | 482.39 ± 0.2% | 0.40 ± 7.1% | not timed | not timed | 515.07 ± 0.2% | | 1.00 | 1.06 | 1280.77 |
| 14-quadratic/1x | 100 | 26.16 ± 21.2% | not timed | not timed | 12.17 ± 0.3% | 0.99 ± 3.2% | not timed | not timed | 26.05 ± 4.3% | | 1.00 | 2.15 | 26.54 |
| 14-quadratic/2x | 200 | 19.91 ± 0.4% | not timed | not timed | 6.12 ± 0.3% | 0.54 ± 0.3% | not timed | not timed | 19.94 ± 0.4% | | 1.00 | 3.25 | 36.78 |
| 14-quadratic/10x | 1000 | 6.87 ± 0.7% | not timed | not timed | 1.22 ± 0.1% | 0.12 ± 3.0% | not timed | not timed | 6.88 ± 11.2% | | 1.00 | 5.65 | 58.73 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.38 ± 0.3% | not timed | not timed | 0.47 ± 1.0% | 0.61 ± 8.7% | not timed | not timed | 1.39 ± 0.9% | | 1.00 | 2.92 | 2.25 |
| 04-ruff-noqa/compile-real | 1 | 124.67 ± 0.7% | not timed | not timed | 17.21 ± 1.0% | 163.68 ± 5.8% | not timed | not timed | 124.51 ± 0.5% | | 1.00 | 7.25 | 0.76 |
| 05-lexer-veryl/compile-single | 1 | 16.45 ± 1.5% | not timed | not timed | 3.00 ± 1.5% | 7.61 ± 20.8% | not timed | not timed | 16.59 ± 1.0% | | 0.99 | 5.49 | 2.16 |
| 07-unicode-character-data/compile | 1 | 125.36 ± 0.5% | not timed | not timed | 30.22 ± 7.3% | 42.98 ± 10.4% | not timed | not timed | 125.14 ± 3.2% | | 1.00 | 4.15 | 2.92 |
| 09-aws-keys/compile-full | 1 | 55.35 ± 0.5% | not timed | not timed | 9.99 ± 2.3% | 27.09 ± 2.5% | not timed | not timed | 55.27 ± 1.1% | | 1.00 | 5.54 | 2.04 |
| 09-aws-keys/compile-quick | 1 | 196.36 ± 2.4% | not timed | not timed | 57.64 ± 1.1% | 148.02 ± 7.4% | not timed | not timed | 196.74 ± 0.5% | | 1.00 | 3.41 | 1.33 |
| 10-bounded-repeat/compile-context | 1 | 59.64 ± 2.2% | not timed | not timed | 14.03 ± 0.8% | 19.00 ± 4.3% | not timed | not timed | 60.16 ± 1.1% | | 0.99 | 4.25 | 3.14 |
| 10-bounded-repeat/compile-capitals | 1 | 91.52 ± 1.1% | not timed | not timed | 10.41 ± 0.6% | 27.02 ± 7.6% | not timed | not timed | 93.71 ± 1.0% | | 0.98 | 8.79 | 3.39 |
| 11-unstructured-to-json/compile | 1 | 190.36 ± 13.1% | not timed | not timed | 46.97 ± 11.6% | 74.97 ± 35.0% | not timed | not timed | 190.02 ± 0.6% | | 1.00 | 4.05 | 2.54 |
| 12-dictionary/compile-single | 1 | 0.34 ± 2.8% | not timed | not timed | 0.08 ± 16.4% | 0.10 ± 5.0% | not timed | not timed | 0.34 ± 1.0% | | 1.00 | 4.23 | 3.39 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.14 ± 5.3% | not timed | not timed | 6.73 ± 0.6% | 0.63 ± 12.9% | not timed | not timed | 7.16 ± 0.6% | | 1.00 | 1.06 | 11.35 |
| dictionary/search/english-10 | 690 | 1.29 ± 1.8% | not timed | not timed | 154.12 ± 6.8% | 0.01 ± 0.1% | not timed | not timed | 1.29 ± 1.7% | | 1.00 | 0.0084 | 187.85 |
| dictionary/search/english-15 | 15 | 513.19 ± 0.2% | not timed | not timed | 482.39 ± 0.1% | 0.35 ± 2.3% | not timed | not timed | 513.39 ± 1.0% | | 1.00 | 1.06 | 1453.38 |
| folly/awyer-inn-busted | 1 | 4241.36 ± 0.1% | not timed | not timed | 132.44 ± 0.3% | 48.37 ± 1.4% | not timed | not timed | 4244.43 ± 0.3% | | 1.00 | 32.03 | 87.68 |
| folly/literal-never-match-rare | 0 | 67284.73 ± 5.6% | not timed | not timed | 46123.45 ± 0.8% | 68515.02 ± 2.1% | not timed | not timed | 67076.30 ± 2.4% | | 1.00 | 1.46 | 0.98 |
| folly/literal-never-match-frequent | 0 | 26244.37 ± 1.9% | not timed | not timed | 45767.53 ± 25.1% | 2567.02 ± 28.3% | not timed | not timed | 26892.38 ± 2.3% | | 0.98 | 0.57 | 10.22 |
| folly/literal-never-match-tricksy | 1 | 3980.64 ± 0.5% | not timed | not timed | 6149.12 ± 0.1% | 1724.11 ± 0.8% | not timed | not timed | 3980.05 ± 0.3% | | 1.00 | 0.65 | 2.31 |
| grep/every-line | 239963 | 1425.81 ± 0.8% | not timed | not timed | 973.34 ± 0.8% | 383.08 ± 32.2% | not timed | not timed | 1432.54 ± 1.9% | | 1.00 | 1.46 | 3.72 |
| grep/long-words-ascii | 5073 | 504.03 ± 1.3% | not timed | not timed | 497.34 ± 4.8% | 51.79 ± 6.7% | not timed | not timed | 503.45 ± 7.9% | | 1.00 | 1.01 | 9.73 |
| imported/leipzig/twain | 811 | 53695.32 ± 4.2% | not timed | not timed | 42713.00 ± 2.0% | 13069.05 ± 8.5% | not timed | not timed | 54549.15 ± 3.6% | | 0.98 | 1.26 | 4.11 |
| imported/leipzig/twain-insensitive | 965 | 15434.20 ± 0.8% | not timed | not timed | 13366.87 ± 0.5% | 43.83 ± 1.4% | not timed | not timed | 15460.68 ± 1.1% | | 1.00 | 1.15 | 352.12 |
| imported/leipzig/shing | 1540 | 629.17 ± 0.9% | not timed | not timed | 21132.40 ± 18.9% | 37.96 ± 1.3% | not timed | not timed | 629.13 ± 17.5% | | 1.00 | 0.0298 | 16.57 |
| imported/leipzig/huck-saw | 262 | 24588.72 ± 7.2% | not timed | not timed | 18623.51 ± 0.7% | 35.60 ± 7.0% | not timed | not timed | 24664.75 ± 0.6% | | 1.00 | 1.32 | 690.73 |
| imported/leipzig/word-ending-nn | 262 | 608.84 ± 0.9% | not timed | not timed | 602.93 ± 0.4% | 27.50 ± 3.4% | not timed | not timed | 609.71 ± 0.3% | | 1.00 | 1.01 | 22.14 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11403.14 ± 0.3% | not timed | not timed | 3811.62 ± 2.8% | 12.24 ± 1.0% | not timed | not timed | 11401.60 ± 1.3% | | 1.00 | 2.99 | 931.80 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 19964.97 ± 19.9% | not timed | not timed | 17236.37 ± 2.0% | 19.29 ± 0.6% | not timed | not timed | 20642.99 ± 5.5% | | 0.97 | 1.16 | 1034.95 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5525.45 ± 0.3% | not timed | not timed | 790.34 ± 2.5% | 12.30 ± 2.6% | not timed | not timed | 5524.82 ± 1.2% | | 1.00 | 6.99 | 449.38 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 607.61 ± 0.1% | not timed | not timed | 601.92 ± 0.1% | 12.47 ± 1.3% | not timed | not timed | 607.28 ± 0.4% | | 1.00 | 1.01 | 48.72 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 607.59 ± 0.3% | not timed | not timed | 602.70 ± 0.1% | 10.76 ± 1.3% | not timed | not timed | 607.72 ± 12.2% | | 1.00 | 1.01 | 56.45 |
| imported/leipzig/tom-river | 2 | 12627.39 ± 10.4% | not timed | not timed | 13062.20 ± 4.4% | 34.84 ± 1.4% | not timed | not timed | 12754.31 ± 2.1% | | 0.99 | 0.97 | 362.48 |
| imported/leipzig/ing | 78424 | 599.07 ± 0.8% | not timed | not timed | 561.05 ± 1.1% | 31.31 ± 6.8% | not timed | not timed | 599.16 ± 0.9% | | 1.00 | 1.07 | 19.13 |
| imported/leipzig/ing-whitespace | 55248 | 729.79 ± 6.9% | not timed | not timed | 2137.82 ± 0.9% | 22.83 ± 2.8% | not timed | not timed | 732.44 ± 7.8% | | 1.00 | 0.34 | 31.97 |
| imported/leipzig/awyer-inn | 209 | 769.78 ± 1.4% | not timed | not timed | 13542.47 ± 2.4% | 25.03 ± 4.1% | not timed | not timed | 770.31 ± 1.1% | | 1.00 | 0.0568 | 30.76 |
| imported/leipzig/quotes-bounded | 8886 | 1847.09 ± 7.4% | not timed | not timed | 3278.07 ± 0.9% | 40.99 ± 0.3% | not timed | not timed | 1849.57 ± 1.9% | | 1.00 | 0.56 | 45.06 |
| imported/leipzig/non-ascii-alternate | 2 | 39797.92 ± 1.6% | not timed | not timed | 19519.58 ± 0.6% | 56.90 ± 4.0% | not timed | not timed | 39476.55 ± 18.8% | | 1.01 | 2.04 | 699.46 |
| imported/leipzig/math-symbols | 69 | 2425.87 ± 45.0% | not timed | not timed | 603.09 ± 0.8% | 39.35 ± 0.1% | not timed | not timed | 2423.11 ± 1.3% | | 1.00 | 4.02 | 61.65 |
| imported/leipzig/bounded-strings-ending-z | 0 | 609.04 ± 12.0% | not timed | not timed | 602.79 ± 2.4% | 25.62 ± 20.6% | not timed | not timed | 609.45 ± 1.7% | | 1.00 | 1.01 | 23.78 |
| imported/lh3lh3-reb/uri | 17549 | 725.16 ± 0.5% | not timed | not timed | 1127.22 ± 4.5% | 27.74 ± 4.6% | not timed | not timed | 728.35 ± 0.3% | | 1.00 | 0.64 | 26.14 |
| imported/lh3lh3-reb/email | 15057 | 800.77 ± 0.6% | not timed | not timed | 1131.64 ± 1.2% | 33.74 ± 3.0% | not timed | not timed | 800.91 ± 1.6% | | 1.00 | 0.71 | 23.74 |
| imported/lh3lh3-reb/date | 668 | 926.85 ± 0.7% | not timed | not timed | 1015.41 ± 0.2% | 54.57 ± 5.0% | not timed | not timed | 929.51 ± 14.5% | | 1.00 | 0.91 | 16.98 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 744.44 ± 1.0% | not timed | not timed | 443.67 ± 2.7% | 16.54 ± 2.2% | not timed | not timed | 743.95 ± 2.1% | | 1.00 | 1.68 | 45.01 |
| imported/mariomka/email | 92 | 704.23 ± 0.5% | not timed | not timed | 60061.38 ± 0.7% | 35.56 ± 1.4% | not timed | not timed | 703.09 ± 0.9% | | 1.00 | 0.0117 | 19.81 |
| imported/mariomka/uri | 5301 | 602.21 ± 0.3% | not timed | not timed | 7933.97 ± 3.8% | 35.57 ± 6.2% | not timed | not timed | 603.04 ± 0.3% | | 1.00 | 0.0759 | 16.93 |
| imported/mariomka/ip | 5 | 1814.98 ± 3.2% | not timed | not timed | 2329.26 ± 7.4% | 22.96 ± 10.4% | not timed | not timed | 1819.82 ± 3.5% | | 1.00 | 0.78 | 79.05 |
| imported/rsc/no-exponential | 0 | 806.80 ± 0.4% | not timed | not timed | 423.35 ± 0.6% | 26.22 ± 1.3% | not timed | not timed | 829.99 ± 0.6% | | 0.97 | 1.91 | 30.77 |
| imported/rsc/literal | 1 | 829.03 ± 21.2% | not timed | not timed | 2228.01 ± 0.2% | 237.48 ± 12.1% | not timed | not timed | 883.00 ± 13.6% | | 0.94 | 0.37 | 3.49 |
| imported/rsc/not-literal | 2 | 803.87 ± 6.5% | not timed | not timed | 817.81 ± 5.5% | 54.60 ± 8.6% | not timed | not timed | 811.64 ± 23.1% | | 0.99 | 0.98 | 14.72 |
| imported/rsc/match-class | 1 | 1437.77 ± 27.5% | not timed | not timed | 1635.67 ± 1.0% | 68.23 ± 7.1% | not timed | not timed | 1422.28 ± 1.1% | | 1.01 | 0.88 | 21.07 |
| imported/rsc/match-class-in-range | 1 | 1440.21 ± 2.4% | not timed | not timed | 3307.68 ± 0.8% | 70.41 ± 8.0% | not timed | not timed | 1437.03 ± 2.6% | | 1.00 | 0.44 | 20.46 |
| imported/rsc/match-class-unicode | 1 | 547.93 ± 1.3% | not timed | not timed | 519.36 ± 7.9% | 82.45 ± 5.9% | not timed | not timed | 549.39 ± 4.2% | | 1.00 | 1.06 | 6.65 |
| imported/rsc/anchored-literal-short-non-match | 0 | 637.89 ± 0.7% | not timed | not timed | 1151.13 ± 0.3% | 345.09 ± 1.4% | not timed | not timed | 639.70 ± 1.1% | | 1.00 | 0.55 | 1.85 |
| imported/rsc/anchored-literal-long-non-match | 0 | 8976.71 ± 0.1% | not timed | not timed | 17264.84 ± 0.6% | 5142.64 ± 7.3% | not timed | not timed | 8973.82 ± 0.9% | | 1.00 | 0.52 | 1.75 |
| imported/rsc/anchored-literal-short-match | 4 | 521.97 ± 1.6% | not timed | not timed | 553.64 ± 8.5% | 105.02 ± 4.0% | not timed | not timed | 515.77 ± 2.0% | | 1.01 | 0.94 | 4.97 |
| imported/rsc/anchored-literal-long-match | 4 | 2769.53 ± 0.9% | not timed | not timed | 8605.20 ± 0.7% | 1615.28 ± 2.0% | not timed | not timed | 2802.88 ± 1.2% | | 0.99 | 0.32 | 1.71 |
| imported/rsc/one-pass-short | 17 | 364.61 ± 1.3% | not timed | not timed | 260.91 ± 0.6% | 36.07 ± 27.4% | not timed | not timed | 352.39 ± 28.0% | | 1.03 | 1.40 | 10.11 |
| imported/rsc/one-pass-short-not | 17 | 246.84 ± 6.0% | not timed | not timed | 271.85 ± 8.5% | 34.92 ± 11.5% | not timed | not timed | 242.58 ± 7.3% | | 1.02 | 0.91 | 7.07 |
| imported/rsc/one-pass-long-prefix | 26 | 225.70 ± 22.9% | not timed | not timed | 313.71 ± 8.6% | 120.45 ± 128.8% | not timed | not timed | 252.50 ± 6.9% | | 0.89 | 0.72 | 1.87 |
| imported/rsc/one-pass-long-prefix-not | 26 | 372.33 ± 2.5% | not timed | not timed | 322.37 ± 0.2% | 82.08 ± 8.0% | not timed | not timed | 375.20 ± 10.4% | | 0.99 | 1.15 | 4.54 |
| imported/rsc/long-needle1 | 31 | 68116.20 ± 1.5% | not timed | not timed | 45869.80 ± 3.5% | 4.20 ± 4.5% | not timed | not timed | 68218.43 ± 11.1% | | 1.00 | 1.48 | 16223.45 |
| imported/rsc/long-needle2 | 31 | 67640.03 ± 0.3% | not timed | not timed | 227.30 ± 0.8% | 4.19 ± 4.4% | not timed | not timed | 67741.27 ± 22.2% | | 1.00 | 297.58 | 16148.21 |
| imported/rsc/easy0-32 | 26 | 1269.77 ± 1.6% | not timed | not timed | 1937.95 ± 0.7% | 172.57 ± 18.4% | not timed | not timed | 1269.26 ± 1.6% | | 1.00 | 0.66 | 7.36 |
| imported/rsc/easy0-1k | 26 | 21312.41 ± 0.7% | not timed | not timed | 20440.83 ± 0.5% | 2632.71 ± 13.3% | not timed | not timed | 21277.13 ± 3.4% | | 1.00 | 1.04 | 8.10 |
| imported/rsc/easy0-32k | 26 | 64363.63 ± 2.3% | not timed | not timed | 43765.62 ± 0.7% | 26161.97 ± 37.7% | not timed | not timed | 64721.74 ± 0.4% | | 0.99 | 1.47 | 2.46 |
| imported/rsc/easy0-1mb | 26 | 64950.46 ± 0.4% | not timed | not timed | 46015.48 ± 0.6% | 68314.83 ± 1.5% | not timed | not timed | 64883.99 ± 0.6% | | 1.00 | 1.41 | 0.95 |
| imported/rsc/easy1-32 | 19 | 383.64 ± 1.6% | not timed | not timed | 755.11 ± 0.6% | 156.05 ± 11.4% | not timed | not timed | 387.63 ± 1.1% | | 0.99 | 0.51 | 2.46 |
| imported/rsc/easy1-1k | 19 | 592.84 ± 2.4% | not timed | not timed | 15620.11 ± 0.4% | 2536.90 ± 12.0% | not timed | not timed | 593.75 ± 6.0% | | 1.00 | 0.0380 | 0.23 |
| imported/rsc/easy1-32k | 19 | 608.36 ± 0.2% | not timed | not timed | 491165.53 ± 1.0% | 28755.76 ± 22.4% | not timed | not timed | 608.46 ± 2.1% | | 1.00 | 0.0012 | 0.0212 |
| imported/rsc/easy1-1mb | 19 | 609.01 ± 9.9% | not timed | not timed | 15402024.44 ± 1.0% | 67782.32 ± 0.4% | not timed | not timed | 609.23 ± 5.3% | | 1.00 | 0.0000 | 0.0090 |
| imported/rsc/medium-32 | 27 | 474.47 ± 1.9% | not timed | not timed | 736.30 ± 7.5% | 83.13 ± 13.0% | not timed | not timed | 474.19 ± 0.4% | | 1.00 | 0.64 | 5.71 |
| imported/rsc/medium-1k | 27 | 7853.21 ± 1.5% | not timed | not timed | 13270.31 ± 0.4% | 82.56 ± 31.3% | not timed | not timed | 7848.96 ± 0.4% | | 1.00 | 0.59 | 95.12 |
| imported/rsc/medium-32k | 27 | 53196.84 ± 2.1% | not timed | not timed | 411539.23 ± 2.0% | 53.58 ± 21.7% | not timed | not timed | 46448.16 ± 0.2% | | 1.15 | 0.13 | 992.87 |
| imported/rsc/medium-1mb | 27 | 64613.32 ± 0.4% | not timed | not timed | 13154624.33 ± 0.4% | 54.22 ± 1.0% | not timed | not timed | 64294.77 ± 0.0% | | 1.00 | 0.0049 | 1191.62 |
| imported/rsc/hard-32 | 58 | 270.22 ± 2.8% | not timed | not timed | 391.63 ± 1.3% | 53.15 ± 8.2% | not timed | not timed | 270.59 ± 0.1% | | 1.00 | 0.69 | 5.08 |
| imported/rsc/hard-1k | 27 | 588.50 ± 0.7% | not timed | not timed | 13036.75 ± 0.3% | 44.93 ± 0.4% | not timed | not timed | 589.08 ± 0.2% | | 1.00 | 0.0451 | 13.10 |
| imported/rsc/hard-32k | 27 | 608.39 ± 0.6% | not timed | not timed | 402091.90 ± 0.8% | 33.07 ± 1.3% | not timed | not timed | 608.91 ± 0.2% | | 1.00 | 0.0015 | 18.40 |
| imported/rsc/hard-1mb | 51 | 609.62 ± 0.1% | not timed | not timed | 7759384.46 ± 1.0% | 33.11 ± 0.4% | not timed | not timed | 609.30 ± 0.6% | | 1.00 | 0.0001 | 18.41 |
| imported/rsc/reallyhard0-32 | 58 | 266.77 ± 2.5% | not timed | not timed | 245.82 ± 1.0% | 52.13 ± 7.0% | not timed | not timed | 269.33 ± 0.3% | | 0.99 | 1.09 | 5.12 |
| imported/rsc/reallyhard0-1k | 27 | 588.08 ± 0.8% | not timed | not timed | 580.96 ± 0.4% | 45.02 ± 0.4% | not timed | not timed | 588.97 ± 0.1% | | 1.00 | 1.01 | 13.06 |
| imported/rsc/reallyhard0-32k | 27 | 608.70 ± 0.2% | not timed | not timed | 603.81 ± 0.3% | 32.75 ± 0.4% | not timed | not timed | 607.99 ± 0.6% | | 1.00 | 1.01 | 18.59 |
| imported/rsc/reallyhard0-1mb | 51 | 609.41 ± 0.8% | not timed | not timed | 604.25 ± 0.5% | 33.17 ± 0.3% | not timed | not timed | 610.01 ± 0.2% | | 1.00 | 1.01 | 18.37 |
| imported/rsc/reallyreallyhard0-32 | 47 | 309.44 ± 1.8% | not timed | not timed | 209.59 ± 0.3% | 66.52 ± 11.7% | not timed | not timed | 310.79 ± 0.5% | | 1.00 | 1.48 | 4.65 |
| imported/rsc/reallyreallyhard0-1k | 16 | 872.54 ± 1.7% | not timed | not timed | 7729.30 ± 13.1% | 36.83 ± 1.2% | not timed | not timed | 872.11 ± 3.2% | | 1.00 | 0.11 | 23.69 |
| imported/rsc/reallyreallyhard0-32k | 16 | 632.58 ± 4.7% | not timed | not timed | 36930.10 ± 0.9% | 26.83 ± 0.2% | not timed | not timed | 637.41 ± 12.6% | | 0.99 | 0.0171 | 23.58 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 609.63 ± 0.3% | not timed | not timed | 45654.10 ± 1.3% | 27.18 ± 0.6% | not timed | not timed | 609.22 ± 0.4% | | 1.00 | 0.0134 | 22.43 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 303.92 ± 0.3% | not timed | not timed | 216.39 ± 7.7% | 66.14 ± 7.9% | not timed | not timed | 304.60 ± 3.4% | | 1.00 | 1.40 | 4.60 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 847.64 ± 0.8% | not timed | not timed | 7538.52 ± 11.8% | 35.96 ± 1.3% | not timed | not timed | 849.73 ± 3.0% | | 1.00 | 0.11 | 23.57 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 635.31 ± 4.7% | not timed | not timed | 36773.27 ± 72.2% | 27.10 ± 2.8% | not timed | not timed | 636.44 ± 8.2% | | 1.00 | 0.0173 | 23.44 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 608.97 ± 0.8% | not timed | not timed | 45620.08 ± 0.5% | 23.90 ± 0.7% | not timed | not timed | 610.02 ± 0.2% | | 1.00 | 0.0133 | 25.48 |
| imported/sherlock/name-sherlock | 776 | 47952.31 ± 7.1% | not timed | not timed | 39715.22 ± 4.9% | 11969.02 ± 16.3% | not timed | not timed | 49750.62 ± 6.0% | | 0.96 | 1.21 | 4.01 |
| imported/sherlock/name-holmes | 2766 | 27472.00 ± 4.6% | not timed | not timed | 29983.30 ± 1.8% | 3861.34 ± 9.3% | not timed | not timed | 27631.07 ± 5.0% | | 0.99 | 0.92 | 7.11 |
| imported/sherlock/name-sherlock-holmes | 1365 | 50651.95 ± 1.1% | not timed | not timed | 40199.53 ± 1.4% | 10584.89 ± 22.0% | not timed | not timed | 50486.74 ± 21.8% | | 1.00 | 1.26 | 4.79 |
| imported/sherlock/name-sherlock-casei | 816 | 46156.00 ± 25.2% | not timed | not timed | 11577.20 ± 0.5% | 33.69 ± 1.6% | not timed | not timed | 46087.68 ± 1.0% | | 1.00 | 3.99 | 1370.15 |
| imported/sherlock/name-holmes-casei | 2802 | 22552.07 ± 0.2% | not timed | not timed | 7656.96 ± 0.5% | 44.56 ± 0.8% | not timed | not timed | 22510.08 ± 1.3% | | 1.00 | 2.95 | 506.12 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 36312.17 ± 0.8% | not timed | not timed | 11050.50 ± 0.4% | 33.70 ± 6.1% | not timed | not timed | 36248.57 ± 1.2% | | 1.00 | 3.29 | 1077.39 |
| imported/sherlock/name-whitespace | 1461 | 27788.31 ± 4.8% | not timed | not timed | 27473.23 ± 15.7% | 8226.38 ± 26.3% | not timed | not timed | 28175.76 ± 1.3% | | 0.99 | 1.01 | 3.38 |
| imported/sherlock/name-alt1 | 1142 | 28367.85 ± 23.0% | not timed | not timed | 29454.18 ± 0.5% | 5651.46 ± 24.5% | not timed | not timed | 28460.14 ± 5.3% | | 1.00 | 0.96 | 5.02 |
| imported/sherlock/name-alt2 | 3542 | 17047.67 ± 0.2% | not timed | not timed | 10084.27 ± 0.2% | 36.09 ± 1.8% | not timed | not timed | 17059.76 ± 17.4% | | 1.00 | 1.69 | 472.39 |
| imported/sherlock/name-alt3 | 4507 | 11307.29 ± 1.3% | not timed | not timed | 9086.72 ± 11.0% | 11.08 ± 28.8% | not timed | not timed | 11323.85 ± 21.6% | | 1.00 | 1.24 | 1020.72 |
| imported/sherlock/name-alt3-casei | 4593 | 3449.78 ± 2.7% | not timed | not timed | 1309.37 ± 0.3% | 7.48 ± 2.4% | not timed | not timed | 3436.81 ± 2.7% | | 1.00 | 2.63 | 461.26 |
| imported/sherlock/name-alt4 | 3686 | 9183.42 ± 0.5% | not timed | not timed | 8128.85 ± 0.9% | 35.67 ± 1.2% | not timed | not timed | 9212.36 ± 0.3% | | 1.00 | 1.13 | 257.42 |
| imported/sherlock/name-alt4-casei | 4254 | 5158.47 ± 3.7% | not timed | not timed | 4472.15 ± 1.4% | 20.51 ± 20.2% | not timed | not timed | 5143.94 ± 1.8% | | 1.00 | 1.15 | 251.56 |
| imported/sherlock/name-alt5 | 4028 | 14224.10 ± 0.6% | not timed | not timed | 9690.81 ± 0.4% | 24.75 ± 0.7% | not timed | not timed | 14257.21 ± 0.9% | | 1.00 | 1.47 | 574.71 |
| imported/sherlock/name-alt5-casei | 4104 | 6618.63 ± 7.6% | not timed | not timed | 2992.11 ± 22.8% | 15.49 ± 1.3% | not timed | not timed | 6636.33 ± 3.1% | | 1.00 | 2.21 | 427.29 |
| imported/sherlock/no-match-uncommon | 0 | 67721.66 ± 0.3% | not timed | not timed | 57856.91 ± 1.0% | 56821.02 ± 1.6% | not timed | not timed | 67752.08 ± 14.8% | | 1.00 | 1.17 | 1.19 |
| imported/sherlock/no-match-common | 0 | 66242.29 ± 0.2% | not timed | not timed | 57719.97 ± 36.8% | 2139.74 ± 1.0% | not timed | not timed | 66383.86 ± 0.4% | | 1.00 | 1.15 | 30.96 |
| imported/sherlock/no-match-really-common | 0 | 42544.51 ± 0.2% | not timed | not timed | 49701.64 ± 30.2% | 2144.60 ± 1.1% | not timed | not timed | 42488.65 ± 21.3% | | 1.00 | 0.86 | 19.84 |
| imported/sherlock/the-lower | 21654 | 3986.89 ± 1.5% | not timed | not timed | 4603.93 ± 11.5% | 292.59 ± 32.8% | not timed | not timed | 4000.30 ± 8.1% | | 1.00 | 0.87 | 13.63 |
| imported/sherlock/the-upper | 2223 | 20903.70 ± 1.7% | not timed | not timed | 29257.52 ± 16.1% | 3074.82 ± 18.0% | not timed | not timed | 20825.83 ± 1.6% | | 1.00 | 0.71 | 6.80 |
| imported/sherlock/the-casei | 23961 | 3516.06 ± 25.5% | not timed | not timed | 1317.57 ± 1.1% | 38.28 ± 23.4% | not timed | not timed | 3512.15 ± 7.5% | | 1.00 | 2.67 | 91.84 |
| imported/sherlock/everything-greedy | 581881 | 269.08 ± 0.5% | not timed | not timed | 172.88 ± 0.7% | 30.95 ± 33.9% | not timed | not timed | 272.79 ± 7.7% | | 0.99 | 1.56 | 8.69 |
| imported/sherlock/everything-greedy-nl | 594933 | 465.04 ± 0.2% | not timed | not timed | 222.84 ± 6.2% | 34.66 ± 0.9% | not timed | not timed | 464.89 ± 1.4% | | 1.00 | 2.09 | 13.42 |
| imported/sherlock/letters | 447175 | 56.07 ± 15.8% | not timed | not timed | 34.05 ± 0.5% | 6.01 ± 32.3% | not timed | not timed | 56.38 ± 1.0% | | 0.99 | 1.65 | 9.33 |
| imported/sherlock/letters-upper | 14180 | 430.88 ± 0.4% | not timed | not timed | 370.41 ± 0.2% | 31.25 ± 26.1% | not timed | not timed | 430.15 ± 1.3% | | 1.00 | 1.16 | 13.79 |
| imported/sherlock/letters-lower | 432995 | 56.99 ± 0.8% | not timed | not timed | 34.17 ± 1.9% | 7.08 ± 42.5% | not timed | not timed | 57.76 ± 1.5% | | 0.99 | 1.67 | 8.05 |
| imported/sherlock/words | 447639 | 105.91 ± 31.6% | not timed | not timed | 83.61 ± 1.1% | 15.44 ± 10.0% | not timed | not timed | 106.04 ± 5.0% | | 1.00 | 1.27 | 6.86 |
| imported/sherlock/before-holmes | 4073 | 601.66 ± 2.1% | not timed | not timed | 13267.75 ± 1.6% | 25.83 ± 26.3% | not timed | not timed | 602.20 ± 0.3% | | 1.00 | 0.0453 | 23.29 |
| imported/sherlock/before-after-holmes | 2593 | 603.71 ± 0.1% | not timed | not timed | 14942.74 ± 1.0% | 25.80 ± 0.9% | not timed | not timed | 604.73 ± 0.5% | | 1.00 | 0.0404 | 23.40 |
| imported/sherlock/holmes-cochar-watson | 150 | 9985.93 ± 0.9% | not timed | not timed | 7718.78 ± 0.2% | 35.30 ± 0.8% | not timed | not timed | 10011.61 ± 0.8% | | 1.00 | 1.29 | 282.90 |
| imported/sherlock/holmes-coword-watson | 14309 | 1266.82 ± 2.0% | not timed | not timed | 1231.13 ± 0.3% | 7.60 ± 1.0% | not timed | not timed | 1271.56 ± 0.1% | | 1.00 | 1.03 | 166.72 |
| imported/sherlock/quotes | 14437 | 1337.08 ± 0.9% | not timed | not timed | 2271.11 ± 2.2% | 37.76 ± 0.5% | not timed | not timed | 1339.36 ± 0.9% | | 1.00 | 0.59 | 35.41 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 607.70 ± 0.8% | not timed | not timed | 31195.96 ± 3.3% | 40.30 ± 9.7% | not timed | not timed | 607.43 ± 0.4% | | 1.00 | 0.0195 | 15.08 |
| imported/sherlock/word-ending-n | 35297 | 458.74 ± 0.8% | not timed | not timed | 404.48 ± 0.2% | 25.74 ± 25.9% | not timed | not timed | 458.43 ± 0.8% | | 1.00 | 1.13 | 17.82 |
| imported/sherlock/repeated-class-negation | 2130 | 18494.88 ± 0.5% | not timed | not timed | 16462.91 ± 1.0% | 12.42 ± 32.3% | not timed | not timed | 18484.47 ± 0.3% | | 1.00 | 1.12 | 1488.84 |
| imported/sherlock/ing-suffix | 20547 | 559.30 ± 1.1% | not timed | not timed | 513.73 ± 0.4% | 31.14 ± 0.5% | not timed | not timed | 560.85 ± 1.2% | | 1.00 | 1.09 | 17.96 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 590.94 ± 2.4% | not timed | not timed | 2794.92 ± 6.2% | 22.89 ± 1.2% | not timed | not timed | 588.36 ± 1.0% | | 1.00 | 0.21 | 25.82 |
| opt/accelerate/whole-line | 239963 | 503.77 ± 0.4% | not timed | not timed | 414.51 ± 0.4% | 92.19 ± 16.5% | not timed | not timed | 504.58 ± 0.5% | | 1.00 | 1.22 | 5.46 |
| opt/accelerate/non-dna | 16745 | 422.53 ± 3.8% | not timed | not timed | 439.49 ± 0.1% | 31.99 ± 23.9% | not timed | not timed | 424.55 ± 3.1% | | 1.00 | 0.96 | 13.21 |
| opt/backtrack/words-english | 40536 | 142.86 ± 3.8% | not timed | not timed | 110.90 ± 2.4% | 22.39 ± 9.3% | not timed | not timed | 144.40 ± 4.1% | | 0.99 | 1.29 | 6.38 |
| opt/fixed-length/too-small-ascii | 0 | 389.27 ± 12.6% | not timed | not timed | 709.10 ± 0.4% | 123.13 ± 3.5% | not timed | not timed | 390.60 ± 2.8% | | 1.00 | 0.55 | 3.16 |
| opt/fixed-length/too-big-ascii | 0 | 818.38 ± 0.5% | not timed | not timed | 6319.65 ± 0.6% | 151.49 ± 1.0% | not timed | not timed | 819.86 ± 1.8% | | 1.00 | 0.13 | 5.40 |
| opt/fixed-length/go33484-1 | 0 | 65.32 ± 0.5% | not timed | not timed | 1216768.62 ± 0.6% | 89884.46 ± 0.8% | not timed | not timed | 65.40 ± 0.5% | | 1.00 | 0.0001 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 4242.01 ± 0.3% | not timed | not timed | 1215459.68 ± 0.9% | 29927.48 ± 1.1% | not timed | not timed | 4240.29 ± 1.3% | | 1.00 | 0.0035 | 0.14 |
| opt/fixed-length/go33484-3 | 0 | 1654.04 ± 0.1% | not timed | not timed | 120895.82 ± 0.4% | 892.71 ± 0.6% | not timed | not timed | 1670.13 ± 0.3% | | 0.99 | 0.0137 | 1.85 |
| opt/literal-alt/one-pattern | 1 | 581.62 ± 4.5% | not timed | not timed | 569.76 ± 0.3% | 0.39 ± 1.8% | not timed | not timed | 547.93 ± 0.5% | | 1.06 | 1.02 | 1506.46 |
| opt/onepass/fn-predicate | 916 | 432.60 ± 11.8% | not timed | not timed | 391.88 ± 0.6% | 213.61 ± 16.9% | not timed | not timed | 423.67 ± 1.8% | | 1.02 | 1.10 | 2.03 |
| opt/onepass/first-three-words-english | 35128 | 157.84 ± 2.0% | not timed | not timed | 233.96 ± 8.6% | 82.30 ± 17.9% | not timed | not timed | 158.25 ± 6.2% | | 1.00 | 0.67 | 1.92 |
| opt/prefilter/literal-english | 1 | 68378.26 ± 0.4% | not timed | not timed | 46344.59 ± 0.5% | 26855.53 ± 1.6% | not timed | not timed | 68313.87 ± 1.2% | | 1.00 | 1.48 | 2.55 |
| opt/prefilter/literal-casei-english | 1 | 47248.64 ± 1.1% | not timed | not timed | 14303.01 ± 0.2% | 34.08 ± 1.6% | not timed | not timed | 47261.86 ± 1.8% | | 1.00 | 3.30 | 1386.31 |
| opt/prefilter/literal-russian | 1 | 68522.47 ± 11.7% | not timed | not timed | 46375.26 ± 2.5% | 1807.50 ± 14.8% | not timed | not timed | 68629.13 ± 0.4% | | 1.00 | 1.48 | 37.91 |
| opt/prefilter/literal-casei-russian | 1 | 26208.52 ± 37.6% | not timed | not timed | 10999.52 ± 0.2% | 37.39 ± 1.4% | not timed | not timed | 26187.60 ± 6.8% | | 1.00 | 2.38 | 700.94 |
| opt/prefilter/rust-functions | 948 | 14818.97 ± 0.9% | not timed | not timed | 12878.16 ± 4.4% | 1887.12 ± 6.5% | not timed | not timed | 14780.88 ± 0.7% | | 1.00 | 1.15 | 7.85 |
| opt/reverse-anchored/word-end | 1 | 4271.72 ± 1.3% | not timed | not timed | 25956804.11 ± 24.0% | 51.85 ± 3.9% | not timed | not timed | 4296.62 ± 28.0% | | 0.99 | 0.0002 | 82.38 |
| opt/reverse-inner/holmes | 2593 | 604.45 ± 0.5% | not timed | not timed | 14970.44 ± 0.6% | 24.17 ± 0.8% | not timed | not timed | 605.31 ± 0.1% | | 1.00 | 0.0404 | 25.01 |
| opt/reverse-inner/email | 47 | 1037.91 ± 1.7% | not timed | not timed | 92030.22 ± 0.5% | 34.52 ± 2.6% | not timed | not timed | 1039.23 ± 0.2% | | 1.00 | 0.0113 | 30.07 |
| opt/reverse-inner/factored-prefix | 3542 | 595.91 ± 0.4% | not timed | not timed | 585.13 ± 2.5% | 13.56 ± 1.5% | not timed | not timed | 596.64 ± 0.2% | | 1.00 | 1.02 | 43.94 |
| opt/reverse-inner/no-quadratic-backward | 0 | 4169.80 ± 0.3% | not timed | not timed | 604.72 ± 0.3% | 85.54 ± 2.0% | not timed | not timed | 4176.81 ± 0.2% | | 1.00 | 6.90 | 48.75 |
| opt/reverse-inner/no-quadratic-forward | 0 | 708.45 ± 1.9% | not timed | not timed | 279.07 ± 0.6% | 26.65 ± 0.6% | not timed | not timed | 709.07 ± 2.0% | | 1.00 | 2.54 | 26.58 |
| opt/reverse-suffix/holmes | 4073 | 602.39 ± 23.9% | not timed | not timed | 13187.65 ± 1.6% | 23.93 ± 2.3% | not timed | not timed | 600.75 ± 16.4% | | 1.00 | 0.0457 | 25.18 |
| opt/reverse-suffix/no-quadratic | 0 | 4166.44 ± 0.4% | not timed | not timed | 604.72 ± 0.1% | 85.90 ± 0.4% | not timed | not timed | 4178.09 ± 0.9% | | 1.00 | 6.89 | 48.50 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 142.50 ± 2.5% | not timed | not timed | 179.12 ± 0.6% | 16.73 ± 17.4% | not timed | not timed | 142.84 ± 1.1% | | 1.00 | 0.80 | 8.52 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 142.17 ± 2.4% | not timed | not timed | 183.05 ± 0.8% | 16.52 ± 21.5% | not timed | not timed | 139.03 ± 5.7% | | 1.02 | 0.78 | 8.61 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.31 ± 0.8% | not timed | not timed | 0.47 ± 4.0% | 120.85 ± 1.7% | not timed | not timed | 0.31 ± 12.2% | | 1.00 | 0.66 | 0.0026 |
| reported/i1095-word-repetition/ascii-search | 256 | 292.67 ± 0.5% | not timed | not timed | 280.62 ± 0.6% | 108.38 ± 0.5% | not timed | not timed | 293.42 ± 2.0% | | 1.00 | 1.04 | 2.70 |
| reported/i13-subset-regex/original-ascii | 4094 | 11524.72 ± 1.3% | not timed | not timed | 3939.73 ± 2.9% | 12.17 ± 1.4% | not timed | not timed | 11535.56 ± 2.0% | | 1.00 | 2.93 | 946.67 |
| reported/i13-subset-regex/original-unicode | 4094 | 11534.89 ± 0.6% | not timed | not timed | 208.77 ± 4.7% | 12.24 ± 2.8% | not timed | not timed | 11498.65 ± 2.5% | | 1.00 | 55.25 | 942.10 |
| reported/i13-subset-regex/big-ascii | 1955 | 10684.30 ± 1.4% | not timed | not timed | 53.67 ± 1.8% | 10.52 ± 1.0% | not timed | not timed | 10741.14 ± 1.4% | | 0.99 | 199.09 | 1015.57 |
| reported/i13-subset-regex/big-unicode | 1955 | 10630.30 ± 2.4% | not timed | not timed | 9.63 ± 55.3% | 10.56 ± 0.7% | not timed | not timed | 10723.62 ± 2.2% | | 0.99 | 1104.29 | 1006.94 |
| reported/i13-subset-regex/huge-ascii | 55 | 9663.01 ± 5.3% | not timed | not timed | 8.84 ± 1.0% | 9.58 ± 1.7% | not timed | not timed | 9669.34 ± 4.4% | | 1.00 | 1092.76 | 1008.86 |
| reported/i13-subset-regex/huge-unicode | 55 | 9562.50 ± 4.4% | not timed | not timed | 8.75 ± 1.3% | 9.54 ± 0.9% | not timed | not timed | 9574.71 ± 3.5% | | 1.00 | 1093.33 | 1001.97 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.17 ± 3.6% | not timed | not timed | 8.98 ± 1.4% | 9.50 ± 2.7% | not timed | not timed | 4.14 ± 1.6% | | 1.01 | 0.46 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.68 ± 2.8% | not timed | not timed | 8.86 ± 0.8% | 9.51 ± 2.7% | not timed | not timed | 5.71 ± 1.8% | | 0.99 | 0.64 | 0.60 |
| reported/i787-keywords/ascii | 5674 | 486.70 ± 0.3% | not timed | not timed | 170.61 ± 1.0% | 6.63 ± 0.3% | not timed | not timed | 498.22 ± 0.7% | | 0.98 | 2.85 | 73.42 |
| reported/i787-keywords/opt-ascii | 5674 | 491.96 ± 0.6% | not timed | not timed | 273.47 ± 1.4% | 9.96 ± 1.0% | not timed | not timed | 496.58 ± 0.8% | | 0.99 | 1.80 | 49.39 |
| slow/quadratic-regex-1x | 100 | 8.23 ± 8.5% | not timed | not timed | 5.91 ± 0.6% | 0.05 ± 1.5% | not timed | not timed | 8.25 ± 15.8% | | 1.00 | 1.39 | 158.05 |
| slow/quadratic-regex-2x | 199 | 3.66 ± 2.2% | not timed | not timed | 3.05 ± 0.2% | 0.01 ± 4.2% | not timed | not timed | 3.70 ± 1.1% | | 0.99 | 1.20 | 273.01 |
| slow/quadratic-haystack-1x | 100 | 26.13 ± 2.4% | not timed | not timed | 12.17 ± 4.4% | 1.03 ± 9.2% | not timed | not timed | 26.17 ± 5.8% | | 1.00 | 2.15 | 25.36 |
| slow/quadratic-haystack-2x | 200 | 19.81 ± 1.7% | not timed | not timed | 6.12 ± 0.2% | 0.55 ± 34.4% | not timed | not timed | 19.84 ± 2.7% | | 1.00 | 3.24 | 35.69 |
| unicode/codepoints/any-one | 1112064 | 337.27 ± 0.9% | not timed | not timed | 241.73 ± 4.8% | 19.87 ± 22.6% | not timed | not timed | 334.69 ± 3.4% | | 1.01 | 1.40 | 16.97 |
| unicode/codepoints/any-all | 4382592 | 265.22 ± 1.2% | not timed | not timed | 261.85 ± 1.4% | 125.58 ± 1.7% | not timed | not timed | 265.73 ± 0.7% | | 1.00 | 1.01 | 2.11 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.75 ± 1.4% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 610.06 ± 0.5% | not timed | not timed | 603.44 ± 0.7% | 153.57 ± 1.0% | not timed | not timed | 609.98 ± 0.4% | | 1.00 | 1.01 | 3.97 |
| unicode/overlapping-words/ascii | 6156 | 27.84 ± 7.7% | not timed | not timed | 43.40 ± 0.6% | 4.32 ± 7.4% | not timed | not timed | 28.53 ± 7.3% | | 0.98 | 0.64 | 6.44 |
| unicode/overlapping-words/english | 6156 | 1.42 ± 1.1% | not timed | not timed | 3.07 ± 13.4% | 2.92 ± 7.2% | not timed | not timed | 1.47 ± 0.8% | | 0.96 | 0.46 | 0.48 |
| unicode/overlapping-words/russian | 5710 | 1.29 ± 19.6% | not timed | not timed | 3.32 ± 6.6% | 7.35 ± 11.2% | not timed | not timed | 1.33 ± 19.5% | | 0.97 | 0.39 | 0.18 |
| unicode/word/boundary-any-english | 450561 | 114.04 ± 1.7% | not timed | not timed | 81.71 ± 0.3% | 13.87 ± 17.4% | not timed | not timed | 114.46 ± 12.5% | | 1.00 | 1.40 | 8.22 |
| unicode/word/boundary-long-english | 3466 | 610.63 ± 0.2% | not timed | not timed | 593.43 ± 0.2% | 35.39 ± 0.5% | not timed | not timed | 611.28 ± 0.2% | | 1.00 | 1.03 | 17.25 |
| unicode/word/around-holmes-english | 27 | 609.18 ± 3.0% | not timed | not timed | 45073.71 ± 34.8% | 23.61 ± 0.7% | not timed | not timed | 609.64 ± 0.2% | | 1.00 | 0.0135 | 25.80 |
| wild/bibleref/long | 874 | 569.63 ± 0.4% | not timed | not timed | 575.02 ± 0.8% | 7.90 ± 0.8% | not timed | not timed | 570.45 ± 8.0% | | 1.00 | 0.99 | 72.08 |
| wild/bibleref/short | 30 | 22.07 ± 15.4% | not timed | not timed | 32.69 ± 11.8% | 15.70 ± 31.7% | not timed | not timed | 23.30 ± 1.7% | | 0.95 | 0.68 | 1.41 |
| wild/bibleref/line | 874 | 486.09 ± 1.2% | not timed | not timed | 281.53 ± 17.0% | 9.99 ± 1.3% | not timed | not timed | 481.05 ± 11.3% | | 1.01 | 1.73 | 48.65 |
| wild/caddy/caddy | 6 | 453.58 ± 29.1% | not timed | not timed | 290.19 ± 7.7% | 76.06 ± 13.5% | not timed | not timed | 457.25 ± 26.4% | | 0.99 | 1.56 | 5.96 |
| wild/dot-star-capture/rust-src-tools | 6 | 1453.21 ± 0.3% | not timed | not timed | 404.14 ± 0.7% | 13.45 ± 0.6% | not timed | not timed | 1455.08 ± 0.6% | | 1.00 | 3.60 | 108.01 |
| wild/ruff/noqa | 84 | 491.53 ± 0.1% | not timed | not timed | 510.64 ± 0.3% | 21.41 ± 2.8% | not timed | not timed | 491.78 ± 0.3% | | 1.00 | 0.96 | 22.95 |
| wild/ruff/unnecessary-coding-comment | 16 | 535.23 ± 0.6% | not timed | not timed | 722.64 ± 0.7% | 137.34 ± 12.7% | not timed | not timed | 535.63 ± 0.6% | | 1.00 | 0.74 | 3.90 |
| wild/ruff/string-quote-prefix | 2972 | 494.37 ± 0.7% | not timed | not timed | 493.80 ± 0.3% | 320.03 ± 30.0% | not timed | not timed | 492.99 ± 0.8% | | 1.00 | 1.00 | 1.54 |
| wild/ruff/space-around-operator | 1224378 | 234.14 ± 1.5% | not timed | not timed | 225.62 ± 0.4% | 18.89 ± 2.1% | not timed | not timed | 235.64 ± 4.9% | | 0.99 | 1.04 | 12.40 |
| wild/ruff/shebang | 282 | 487.76 ± 0.5% | not timed | not timed | 391.03 ± 0.3% | 117.63 ± 15.9% | not timed | not timed | 488.67 ± 3.6% | | 1.00 | 1.25 | 4.15 |
| wild/rustsec-cargo-audit/original-unix | 471 | 21535.27 ± 7.6% | not timed | not timed | 23723.38 ± 7.1% | 8891.48 ± 3.3% | not timed | not timed | 21745.07 ± 21.1% | | 0.99 | 0.91 | 2.42 |
| wild/rustsec-cargo-audit/original-windows | 462 | 19918.59 ± 1.5% | not timed | not timed | 22208.22 ± 19.4% | 8384.33 ± 1.9% | not timed | not timed | 19849.21 ± 2.3% | | 1.00 | 0.90 | 2.38 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 22835.99 ± 4.2% | not timed | not timed | 23213.95 ± 3.4% | 8797.74 ± 59.6% | not timed | not timed | 22891.51 ± 4.8% | | 1.00 | 0.98 | 2.60 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 17783.98 ± 1.0% | not timed | not timed | 23305.13 ± 0.4% | 8767.99 ± 43.5% | not timed | not timed | 17778.23 ± 1.0% | | 1.00 | 0.76 | 2.03 |
| wild/url/search | 234965 | 124.64 ± 14.8% | not timed | not timed | 60.42 ± 1.5% | 2.41 ± 2.0% | not timed | not timed | 125.76 ± 22.4% | | 0.99 | 2.06 | 51.81 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 3.8% | not timed | not timed | 0.01 ± 14.7% | 0.01 ± 18.9% | not timed | not timed | 0.03 ± 63.0% | | 1.03 | 2.60 | 4.51 |
| dictionary/compile/english-15 | 1 | 0.34 ± 2.0% | not timed | not timed | 0.09 ± 11.1% | 0.11 ± 36.0% | not timed | not timed | 0.34 ± 10.5% | | 1.02 | 3.64 | 3.01 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.28 ± 8.1% | not timed | not timed | 0.02 ± 27.7% | 37.48 ± 6.1% | not timed | not timed | 0.29 ± 4.2% | | 0.97 | 11.57 | 0.0075 |
| reported/i1095-word-repetition/ascii-compile | 1 | 41.35 ± 7.2% | not timed | not timed | 17.02 ± 0.9% | 62.61 ± 17.2% | not timed | not timed | 44.05 ± 8.6% | | 0.94 | 2.43 | 0.66 |
| reported/i787-keywords/compile | 1 | 40.33 ± 7.9% | not timed | not timed | 2.39 ± 4.5% | 19.43 ± 27.4% | not timed | not timed | 40.61 ± 0.9% | | 0.99 | 16.88 | 2.08 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 380.40 ± 2.2% | not timed | not timed | 149.22 ± 1.3% | 619.31 ± 16.7% | not timed | not timed | 385.03 ± 1.6% | | 0.99 | 2.55 | 0.61 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 53.44 ± 3.1% | not timed | not timed | 5.57 ± 4.0% | 47.92 ± 4.8% | not timed | not timed | 53.56 ± 9.7% | | 1.00 | 9.59 | 1.12 |
| unicode/compile/one-letter | 53 | 7.04 ± 12.7% | not timed | not timed | 5.81 ± 4.6% | 62.88 ± 24.5% | not timed | not timed | 7.12 ± 12.6% | | 0.99 | 1.21 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.23 ± 4.1% | not timed | not timed | 0.12 ± 10.6% | 64.09 ± 8.9% | not timed | not timed | 1.23 ± 23.4% | | 1.01 | 9.87 | 0.0192 |
| unicode/compile/fifty-letters-ascii | 1 | 205.20 ± 11.9% | not timed | not timed | 68.37 ± 0.2% | 222.34 ± 16.4% | not timed | not timed | 204.92 ± 11.1% | | 1.00 | 3.00 | 0.92 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 452.04 ± 8.0% | not timed | not timed | 51.14 ± 1.1% | 721.02 ± 22.1% | not timed | not timed | 452.38 ± 3.8% | | 1.00 | 8.84 | 0.63 |
| unicode/compile/match-every-line-ascii | 4 | 693.13 ± 10.9% | not timed | not timed | 167.26 ± 0.4% | 752.43 ± 12.9% | not timed | not timed | 713.43 ± 2.3% | | 0.97 | 4.14 | 0.92 |
| unicode/compile/negated-class-matches-codepoint | 1 | 371.03 ± 19.3% | not timed | not timed | 54.57 ± 0.3% | 1373.85 ± 12.2% | not timed | not timed | 372.85 ± 4.2% | | 1.00 | 6.80 | 0.27 |
| wild/bibleref/compile | 3 | 6.14 ± 4.4% | not timed | not timed | 2.44 ± 2.4% | 33.25 ± 6.7% | not timed | not timed | 6.36 ± 3.7% | | 0.97 | 2.51 | 0.18 |
| wild/url/compile | 1 | 0.72 ± 1.3% | not timed | not timed | 0.20 ± 9.2% | 0.48 ± 29.5% | not timed | not timed | 0.73 ± 1.3% | | 1.00 | 3.58 | 1.52 |

