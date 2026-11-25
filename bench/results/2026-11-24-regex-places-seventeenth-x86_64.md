# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507055345 |
| Date | 2026-11-25 |
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
| literal: a word | 217 | 38914.33 ± 1.5% | 3378.78 ± 0.2% | 20.20 ± 3.0% | 31169.53 ± 3.3% | 9019.01 ± 9.6% | 10.73 ± 0.1% | 75.95 ± 0.8% | 39512.38 ± 1.5% | 11.52 | 0.98 | 1.25 | 4.31 |
| literal: a word that is not there | 0 | 53388.32 ± 1.3% | 3238.32 ± 0.2% | 20.18 ± 0.2% | 39743.46 ± 1.4% | 29780.15 ± 0.9% | 10.67 ± 0.6% | 71.68 ± 3.4% | 52988.23 ± 2.3% | 16.49 | 1.01 | 1.34 | 1.79 |
| literal: one of four words | 661 | 12304.13 ± 4.3% | 1421.44 ± 1.5% | 10.85 ± 4.3% | 9052.09 ± 2.2% | 19.00 ± 3.6% | 3.98 ± 1.8% | 6.64 ± 1.9% | 12444.69 ± 2.2% | 8.66 | 0.99 | 1.36 | 647.54 |
| literal: a word in any case | 217 | 29880.98 ± 2.7% | 1504.80 ± 2.5% | 15.00 ± 2.3% | 9202.59 ± 0.4% | 37.29 ± 1.2% | refused | differs | 29757.72 ± 1.8% | 19.86 | 1.00 | 3.25 | 801.39 |
| literal: an href attribute | 33 | 29198.54 ± 1.1% | 540.34 ± 0.2% | 18.90 ± 0.5% | 27263.13 ± 0.6% | 2062.94 ± 0.9% | 8.19 ± 0.1% | 61.24 ± 1.5% | 29152.96 ± 0.9% | 54.04 | 1.00 | 1.07 | 14.15 |
| literal: a word, second text | 123 | 37238.92 ± 1.0% | 2381.04 ± 0.7% | 20.03 ± 0.1% | 31694.49 ± 0.9% | 7041.36 ± 5.1% | 11.81 ± 0.3% | 65.12 ± 1.7% | 37181.27 ± 1.6% | 15.64 | 1.00 | 1.17 | 5.29 |
| class: two capitalized words | 1331 | 777.62 ± 0.1% | 532.73 ± 0.1% | 18.89 ± 0.7% | 505.91 ± 0.2% | 34.27 ± 7.4% | 9.25 ± 0.3% | 55.66 ± 0.1% | 776.83 ± 0.2% | 1.46 | 1.00 | 1.54 | 22.69 |
| class: a word that ends in ing | 3399 | 505.76 ± 0.2% | 506.64 ± 0.3% | 13.37 ± 0.4% | 472.64 ± 0.3% | 25.11 ± 10.7% | 5.33 ± 0.8% | 17.21 ± 1.2% | 507.31 ± 0.4% | 1.00 | 1.00 | 1.07 | 20.14 |
| class: a word in capitals | 2332 | 979.34 ± 0.1% | 538.79 ± 0.2% | 19.86 ± 0.7% | 497.11 ± 0.3% | 36.70 ± 7.2% | 10.31 ± 0.7% | 76.40 ± 6.6% | 977.95 ± 1.4% | 1.82 | 1.00 | 1.97 | 26.68 |
| class: a number | 8288 | 1648.85 ± 0.8% | 736.89 ± 0.1% | 19.60 ± 8.6% | 1480.02 ± 3.5% | 34.20 ± 15.2% | 0.33 ± 0.4% | 55.87 ± 0.5% | 1648.54 ± 0.4% | 2.24 | 1.00 | 1.11 | 48.21 |
| class: two capitalized words, second text | 5359 | 452.53 ± 0.2% | 458.90 ± 0.5% | 17.34 ± 0.4% | 416.97 ± 0.2% | 29.18 ± 8.4% | 10.52 ± 0.2% | 51.73 ± 1.1% | 445.36 ± 0.4% | 0.99 | 1.02 | 1.09 | 15.51 |
| other: a word between two words | 6104 | 737.01 ± 0.2% | 527.70 ± 0.3% | 17.04 ± 1.5% | 698.38 ± 0.2% | 99.52 ± 14.3% | 7.20 ± 0.4% | 56.52 ± 0.8% | 742.12 ± 0.2% | 1.40 | 0.99 | 1.06 | 7.41 |
| other: a number before a unit, second text | 1481 | 7317.22 ± 0.8% | 872.21 ± 0.5% | 18.92 ± 0.3% | 6333.77 ± 0.3% | 34.91 ± 2.4% | 10.91 ± 0.5% | 55.10 ± 0.6% | 7370.48 ± 0.9% | 8.39 | 0.99 | 1.16 | 209.58 |
| other: a heading's start tag | 110 | 19738.14 ± 5.9% | 654.56 ± 1.2% | 19.54 ± 1.9% | 2007.47 ± 2.6% | 1454.08 ± 3.5% | 9.98 ± 1.4% | 72.56 ± 2.3% | 19588.14 ± 3.1% | 30.15 | 1.01 | 9.83 | 13.57 |
| other: a whole word | 217 | 25014.29 ± 3.9% | 532.98 ± 0.2% | 20.42 ± 0.9% | 22651.45 ± 0.8% | 41.39 ± 0.3% | 9.45 ± 0.2% | 46.63 ± 10.4% | 25602.70 ± 2.2% | 46.93 | 0.98 | 1.10 | 604.41 |
| other: a line's first word, second text | 3716 | 1947.43 ± 0.7% | 521.93 ± 0.2% | 24.16 ± 1.3% | 1691.95 ± 4.1% | 53.39 ± 3.6% | refused | refused | 1929.17 ± 8.4% | 3.73 | 1.01 | 1.15 | 36.48 |
| other: fourteen octets before an x | 87 | 26847.63 ± 1.6% | 215.87 ± 0.9% | 5.43 ± 1.3% | 2949.50 ± 0.6% | 9.00 ± 0.4% | differs | 14.81 ± 4.4% | 26996.52 ± 1.2% | 124.37 | 0.99 | 9.10 | 2982.44 |
| other: a Greek word | 21815 | 437.78 ± 0.5% | 382.87 ± 5.2% | 23.93 ± 5.4% | 264.02 ± 0.8% | 45.69 ± 14.9% | differs | refused | 439.44 ± 2.3% | 1.14 | 1.00 | 1.66 | 9.58 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.91 ± 0.3% | 26.79 ± 0.5% | 0.77 ± 5.7% | 16.76 ± 0.5% | 1.72 ± 5.4% | differs | 3.64 ± 0.8% | 26.83 ± 1.0% | 1.00 | 1.00 | 1.61 | 15.67 |
| a UUID | 32895 | 22.98 ± 5.5% | 23.10 ± 0.3% | 0.54 ± 2.1% | 12.82 ± 2.2% | 2.49 ± 1.3% | 0.44 ± 0.1% | 3.10 ± 1.3% | 23.09 ± 0.3% | 0.99 | 1.00 | 1.79 | 9.24 |
| an IPv4 address | 33176 | 34.54 ± 1.3% | 34.49 ± 0.5% | 1.73 ± 1.6% | 23.93 ± 0.2% | 5.61 ± 1.7% | differs | 3.09 ± 1.6% | 34.46 ± 0.6% | 1.00 | 1.00 | 1.44 | 6.15 |
| a date and time | 32954 | 31.46 ± 2.3% | 31.52 ± 0.6% | 1.23 ± 0.4% | 17.00 ± 0.1% | 6.58 ± 1.8% | 0.76 ± 0.2% | 6.17 ± 0.2% | 31.46 ± 0.5% | 1.00 | 1.00 | 1.85 | 4.78 |
| a field path | 32606 | 29.33 ± 0.5% | 29.07 ± 2.9% | 0.85 ± 0.5% | 19.29 ± 0.5% | 2.90 ± 0.5% | differs | 2.46 ± 1.2% | 29.29 ± 8.9% | 1.01 | 1.00 | 1.52 | 10.10 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.62 ± 0.9% | 8.74 ± 3.3% | 8.77 ± 1.3% | 10.57 ± 1.6% | 4.78 ± 2.3% | 0.62 ± 0.4% | none | 8.71 ± 3.2% | 0.99 | 0.99 | 0.82 | 1.80 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 200.20 ± 0.4% | 199.61 ± 8.6% | 235.20 ± 0.5% | 79.65 ± 3.0% | 183.48 ± 14.5% | 543.44 ± 2.6% | 3988.07 ± 1.2% | 200.10 ± 0.9% | 1.00 | 1.00 | 2.51 | 1.09 |
| a UUID | 62 | 130.74 ± 0.2% | 131.02 ± 0.9% | 146.75 ± 0.9% | 46.52 ± 1.5% | 88.82 ± 8.8% | 198.97 ± 1.8% | 4140.93 ± 1.3% | 130.75 ± 2.1% | 1.00 | 1.00 | 2.81 | 1.47 |
| an IPv4 address | 29 | 382.21 ± 0.3% | 382.05 ± 0.5% | 526.05 ± 1.5% | 71.40 ± 0.7% | 112.87 ± 11.9% | 341.15 ± 3.1% | 7187.43 ± 11.7% | 381.42 ± 0.5% | 1.00 | 1.00 | 5.35 | 3.39 |
| a date and time | 56 | 274.07 ± 2.7% | 273.68 ± 9.1% | 342.26 ± 0.5% | 68.62 ± 0.6% | 121.46 ± 3.6% | 375.10 ± 0.5% | 4239.86 ± 15.1% | 274.28 ± 0.6% | 1.00 | 1.00 | 3.99 | 2.26 |
| a field path | 39 | 201.55 ± 0.2% | 202.02 ± 0.2% | 237.40 ± 5.8% | 74.39 ± 15.4% | 172.46 ± 32.2% | 591.81 ± 2.4% | 4795.71 ± 1.4% | 201.58 ± 1.3% | 1.00 | 1.00 | 2.71 | 1.17 |
| literal: a word | 7 | 557.21 ± 0.7% | 598.13 ± 0.6% | 1063.09 ± 0.6% | 500.91 ± 1.8% | 573.82 ± 3.3% | 1280.58 ± 0.7% | 25202.76 ± 2.4% | 556.35 ± 0.7% | 0.93 | 1.00 | 1.11 | 0.97 |
| literal: a word that is not there | 8 | 530.70 ± 0.9% | 573.50 ± 0.5% | 996.81 ± 0.2% | 454.03 ± 1.3% | 547.72 ± 2.5% | 1200.76 ± 0.6% | 23821.04 ± 0.9% | 529.45 ± 11.6% | 0.93 | 1.00 | 1.17 | 0.97 |
| literal: one of four words | 26 | 214.27 ± 0.6% | 348.26 ± 1.2% | 467.83 ± 3.0% | 41.87 ± 0.8% | 215.09 ± 1.2% | 463.42 ± 0.4% | 11592.75 ± 1.2% | 214.33 ± 0.5% | 0.62 | 1.00 | 5.12 | 1.00 |
| literal: a word in any case | 11 | 400.56 ± 2.0% | 422.05 ± 2.2% | 614.18 ± 2.1% | 14.62 ± 4.1% | 600.23 ± 4.2% | refused | 19118.41 ± 2.7% | 400.91 ± 2.2% | 0.95 | 1.00 | 27.40 | 0.67 |
| literal: an href attribute | 12 | 317.22 ± 2.8% | 321.93 ± 11.3% | 425.34 ± 9.7% | 36.98 ± 4.1% | 417.31 ± 13.6% | 986.56 ± 1.5% | 18508.60 ± 19.0% | 317.02 ± 2.9% | 0.99 | 1.00 | 8.58 | 0.76 |
| literal: a word, second text | 10 | 493.47 ± 0.8% | 537.99 ± 1.1% | 887.35 ± 0.6% | 410.62 ± 1.0% | 484.58 ± 1.1% | 1039.67 ± 11.5% | 21739.40 ± 1.3% | 493.73 ± 1.1% | 0.92 | 1.00 | 1.20 | 1.02 |
| class: two capitalized words | 23 | 397.79 ± 9.6% | 418.68 ± 0.7% | 601.13 ± 1.1% | 94.73 ± 0.6% | 443.68 ± 3.3% | 980.37 ± 0.5% | 6390.32 ± 0.4% | 399.17 ± 0.9% | 0.95 | 1.00 | 4.20 | 0.90 |
| class: a word that ends in ing | 9 | 491.76 ± 7.7% | 546.67 ± 0.5% | 960.54 ± 8.3% | 115.78 ± 0.5% | 623.44 ± 2.5% | 1512.06 ± 2.8% | 15332.81 ± 0.4% | 491.49 ± 11.0% | 0.90 | 1.00 | 4.25 | 0.79 |
| class: a word in capitals | 16 | 429.12 ± 0.5% | 456.17 ± 0.4% | 746.07 ± 0.5% | 123.66 ± 1.1% | 639.83 ± 1.7% | 1370.95 ± 1.3% | 8382.95 ± 0.4% | 429.38 ± 0.6% | 0.94 | 1.00 | 3.47 | 0.67 |
| class: a number | 6 | 550.39 ± 1.7% | 590.47 ± 1.7% | 1139.98 ± 0.4% | 36.95 ± 0.4% | 1142.50 ± 1.2% | 2294.75 ± 4.7% | 20450.36 ± 0.2% | 548.57 ± 5.0% | 0.93 | 1.00 | 14.90 | 0.48 |
| class: two capitalized words, second text | 23 | 401.15 ± 2.2% | 418.72 ± 2.8% | 601.34 ± 3.9% | 94.62 ± 4.1% | 441.72 ± 2.9% | 958.13 ± 1.6% | 6387.76 ± 0.4% | 401.82 ± 2.9% | 0.96 | 1.00 | 4.24 | 0.91 |
| other: a word between two words | 13 | 482.56 ± 2.7% | 499.19 ± 0.4% | 781.82 ± 0.1% | 122.80 ± 1.6% | 432.94 ± 10.4% | 1026.04 ± 2.8% | 14118.85 ± 0.2% | 483.17 ± 0.3% | 0.97 | 1.00 | 3.93 | 1.11 |
| other: a number before a unit, second text | 15 | 364.83 ± 7.7% | 404.35 ± 8.0% | 572.29 ± 0.3% | 34.38 ± 0.6% | 534.21 ± 2.6% | 1149.81 ± 0.5% | 13908.76 ± 0.8% | 365.85 ± 15.5% | 0.90 | 1.00 | 10.61 | 0.68 |
| other: a heading's start tag | 13 | 332.51 ± 3.9% | 337.75 ± 2.0% | 450.25 ± 5.3% | 35.91 ± 0.4% | 521.90 ± 0.8% | 1054.17 ± 1.1% | 16383.79 ± 3.3% | 332.55 ± 15.2% | 0.98 | 1.00 | 9.26 | 0.64 |
| other: a whole word | 11 | 477.31 ± 0.9% | 500.73 ± 27.9% | 791.29 ± 0.9% | 110.01 ± 2.5% | 496.42 ± 2.8% | 1041.64 ± 1.0% | 20940.53 ± 2.7% | 477.64 ± 0.3% | 0.95 | 1.00 | 4.34 | 0.96 |
| other: a line's first word, second text | 17 | 464.06 ± 1.1% | 487.32 ± 0.4% | 793.99 ± 1.3% | 114.45 ± 1.3% | 591.54 ± 1.3% | refused | refused | 463.92 ± 0.9% | 0.95 | 1.00 | 4.05 | 0.78 |
| other: fourteen octets before an x | 16 | 89.77 ± 2.3% | 124.62 ± 7.4% | 144.15 ± 0.3% | 14.31 ± 0.2% | 394.12 ± 2.7% | 450.47 ± 1.9% | 11701.05 ± 0.8% | 89.81 ± 3.4% | 0.72 | 1.00 | 6.27 | 0.23 |
| other: a Greek word | 8 | 384.72 ± 1.1% | 529.68 ± 0.5% | 908.00 ± 0.4% | 46.91 ± 1.3% | 1123.22 ± 1.7% | 2198.83 ± 0.6% | refused | 383.95 ± 0.4% | 0.73 | 1.00 | 8.20 | 0.34 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 26533.21 ± 2.1% | not timed | not timed | 26801.67 ± 1.7% | 1939.57 ± 24.8% | not timed | not timed | 26775.38 ± 0.8% | | 0.99 | 0.99 | 13.68 |
| 01-literal/sherlock-casei-en | 522 | 21143.77 ± 1.7% | not timed | not timed | 7008.58 ± 0.3% | 23.99 ± 0.8% | not timed | not timed | 21197.26 ± 1.9% | | 1.00 | 3.02 | 881.44 |
| 01-literal/sherlock-ru | 724 | 27800.50 ± 2.3% | not timed | not timed | 27609.52 ± 11.1% | 1071.26 ± 4.9% | not timed | not timed | 27878.34 ± 0.9% | | 1.00 | 1.01 | 25.95 |
| 01-literal/sherlock-casei-ru | 746 | 9439.80 ± 0.6% | not timed | not timed | 5507.77 ± 0.4% | 30.33 ± 1.2% | not timed | not timed | 9463.98 ± 0.3% | | 1.00 | 1.71 | 311.19 |
| 01-literal/sherlock-zh | 30 | 45847.37 ± 1.4% | not timed | not timed | 36670.74 ± 1.2% | 1262.15 ± 1.1% | not timed | not timed | 45946.18 ± 2.8% | | 1.00 | 1.25 | 36.32 |
| 02-literal-alternate/sherlock-en | 714 | 10979.99 ± 4.6% | not timed | not timed | 8906.52 ± 0.6% | 14.53 ± 4.2% | not timed | not timed | 10963.94 ± 0.5% | | 1.00 | 1.23 | 755.58 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2093.36 ± 1.8% | not timed | not timed | 1818.60 ± 0.1% | 8.81 ± 0.9% | not timed | not timed | 2094.00 ± 2.1% | | 1.00 | 1.15 | 237.61 |
| 02-literal-alternate/sherlock-ru | 899 | 7926.44 ± 1.6% | not timed | not timed | 4240.65 ± 1.2% | 19.54 ± 24.3% | not timed | not timed | 7933.13 ± 9.4% | | 1.00 | 1.87 | 405.58 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2074.60 ± 0.4% | not timed | not timed | 1044.26 ± 0.4% | 8.57 ± 6.6% | not timed | not timed | 2073.69 ± 0.4% | | 1.00 | 1.99 | 242.06 |
| 02-literal-alternate/sherlock-zh | 207 | 14803.81 ± 0.4% | not timed | not timed | 10346.29 ± 3.0% | 27.48 ± 2.6% | not timed | not timed | 14787.19 ± 0.9% | | 1.00 | 1.43 | 538.71 |
| 03-date/ascii | 111817 | 117.59 ± 1.5% | not timed | not timed | 84.10 ± 4.4% | 0.18 ± 5.3% | not timed | not timed | 117.94 ± 0.8% | | 1.00 | 1.40 | 657.88 |
| 04-ruff-noqa/real | 84 | 432.12 ± 0.5% | not timed | not timed | 436.85 ± 0.3% | 15.63 ± 4.6% | not timed | not timed | 435.37 ± 0.2% | | 0.99 | 0.99 | 27.64 |
| 04-ruff-noqa/tweaked | 44 | 537.73 ± 17.9% | not timed | not timed | 428.94 ± 0.5% | 286.80 ± 4.6% | not timed | not timed | 539.19 ± 0.6% | | 1.00 | 1.25 | 1.87 |
| 05-lexer-veryl/single | 124800 | 3.64 ± 3.2% | not timed | not timed | 4.05 ± 1.2% | 0.21 ± 8.9% | not timed | not timed | 3.63 ± 2.1% | | 1.00 | 0.90 | 17.44 |
| 06-cloud-flare-redos/original | 107 | 363.28 ± 1.9% | not timed | not timed | 192.65 ± 5.5% | 13.12 ± 1.3% | not timed | not timed | 364.87 ± 3.9% | | 1.00 | 1.89 | 27.69 |
| 06-cloud-flare-redos/simplified-short | 102 | 339.80 ± 0.3% | not timed | not timed | 192.23 ± 0.4% | 14.08 ± 2.3% | not timed | not timed | 340.77 ± 0.4% | | 1.00 | 1.77 | 24.13 |
| 06-cloud-flare-redos/simplified-long | 10000 | 463.89 ± 0.9% | not timed | not timed | 211.63 ± 0.5% | 14.86 ± 0.4% | not timed | not timed | 464.79 ± 0.2% | | 1.00 | 2.19 | 31.23 |
| 07-unicode-character-data/parse-line | 558784 | 201.87 ± 1.9% | not timed | not timed | 160.51 ± 1.3% | 36.75 ± 23.1% | not timed | not timed | 201.38 ± 1.7% | | 1.00 | 1.26 | 5.49 |
| 08-words/all-english | 56691 | 111.58 ± 0.2% | not timed | not timed | 72.61 ± 0.2% | 10.13 ± 8.0% | not timed | not timed | 111.14 ± 2.1% | | 1.00 | 1.54 | 11.01 |
| 08-words/long-english | 839 | 540.02 ± 0.3% | not timed | not timed | 513.35 ± 0.8% | 26.51 ± 14.5% | not timed | not timed | 540.44 ± 0.1% | | 1.00 | 1.05 | 20.37 |
| 09-aws-keys/full | 0 | 431.68 ± 8.6% | not timed | not timed | 450.14 ± 0.1% | 53.68 ± 6.0% | not timed | not timed | 441.44 ± 0.7% | | 0.98 | 0.96 | 8.04 |
| 09-aws-keys/quick | 0 | 937.79 ± 7.3% | not timed | not timed | 803.18 ± 0.4% | 299.51 ± 7.9% | not timed | not timed | 935.99 ± 1.6% | | 1.00 | 1.17 | 3.13 |
| 10-bounded-repeat/letters-en | 1833 | 487.04 ± 0.5% | not timed | not timed | 432.06 ± 0.8% | 16.94 ± 0.8% | not timed | not timed | 487.12 ± 1.1% | | 1.00 | 1.13 | 28.75 |
| 10-bounded-repeat/letters-ru | 3475 | 429.99 ± 0.5% | not timed | not timed | 402.62 ± 0.3% | 19.84 ± 14.3% | not timed | not timed | 430.12 ± 0.8% | | 1.00 | 1.07 | 21.68 |
| 10-bounded-repeat/context | 53 | 69.00 ± 1.6% | not timed | not timed | 55.49 ± 2.9% | 16.83 ± 2.7% | not timed | not timed | 69.85 ± 3.8% | | 0.99 | 1.24 | 4.10 |
| 10-bounded-repeat/capitals | 11 | 555.66 ± 7.6% | not timed | not timed | 531.03 ± 0.5% | 30.94 ± 0.6% | not timed | not timed | 555.54 ± 7.9% | | 1.00 | 1.05 | 17.96 |
| 11-unstructured-to-json/extract | 600 | 37.70 ± 13.5% | not timed | not timed | 62.56 ± 1.0% | 23.13 ± 2.7% | not timed | not timed | 37.92 ± 1.1% | | 0.99 | 0.60 | 1.63 |
| 12-dictionary/single | 1 | 464.58 ± 1.4% | not timed | not timed | 443.42 ± 0.4% | 0.32 ± 0.6% | not timed | not timed | 463.79 ± 1.0% | | 1.00 | 1.05 | 1467.52 |
| 14-quadratic/1x | 100 | 21.44 ± 1.5% | not timed | not timed | 9.10 ± 0.5% | 0.80 ± 1.4% | not timed | not timed | 21.45 ± 1.3% | | 1.00 | 2.36 | 26.86 |
| 14-quadratic/2x | 200 | 16.26 ± 2.3% | not timed | not timed | 4.92 ± 1.7% | 0.43 ± 7.8% | not timed | not timed | 16.07 ± 3.1% | | 1.01 | 3.31 | 37.89 |
| 14-quadratic/10x | 1000 | 5.65 ± 7.4% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 1.0% | not timed | not timed | 5.63 ± 0.7% | | 1.00 | 5.37 | 60.74 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.08 ± 11.0% | not timed | not timed | 0.39 ± 0.8% | 0.48 ± 18.2% | not timed | not timed | 1.08 ± 3.0% | | 1.00 | 2.80 | 2.23 |
| 04-ruff-noqa/compile-real | 1 | 96.21 ± 1.3% | not timed | not timed | 12.87 ± 1.2% | 123.92 ± 1.7% | not timed | not timed | 94.93 ± 8.5% | | 1.01 | 7.48 | 0.78 |
| 05-lexer-veryl/compile-single | 1 | 12.58 ± 9.2% | not timed | not timed | 2.37 ± 1.4% | 5.91 ± 4.2% | not timed | not timed | 12.56 ± 0.1% | | 1.00 | 5.30 | 2.13 |
| 07-unicode-character-data/compile | 1 | 101.03 ± 0.5% | not timed | not timed | 24.11 ± 0.8% | 32.84 ± 5.2% | not timed | not timed | 100.34 ± 1.1% | | 1.01 | 4.19 | 3.08 |
| 09-aws-keys/compile-full | 1 | 43.55 ± 1.1% | not timed | not timed | 7.35 ± 1.5% | 20.70 ± 3.4% | not timed | not timed | 43.26 ± 0.8% | | 1.01 | 5.92 | 2.10 |
| 09-aws-keys/compile-quick | 1 | 153.94 ± 1.2% | not timed | not timed | 45.11 ± 0.5% | 117.91 ± 2.0% | not timed | not timed | 154.16 ± 1.8% | | 1.00 | 3.41 | 1.31 |
| 10-bounded-repeat/compile-context | 1 | 50.25 ± 1.3% | not timed | not timed | 11.65 ± 2.3% | 15.09 ± 1.5% | not timed | not timed | 49.50 ± 1.1% | | 1.02 | 4.31 | 3.33 |
| 10-bounded-repeat/compile-capitals | 1 | 73.94 ± 1.2% | not timed | not timed | 8.88 ± 1.0% | 22.21 ± 1.5% | not timed | not timed | 73.79 ± 0.6% | | 1.00 | 8.33 | 3.33 |
| 11-unstructured-to-json/compile | 1 | 151.10 ± 18.6% | not timed | not timed | 36.95 ± 1.0% | 60.99 ± 6.3% | not timed | not timed | 151.21 ± 0.7% | | 1.00 | 4.09 | 2.48 |
| 12-dictionary/compile-single | 1 | 0.29 ± 5.1% | not timed | not timed | 0.07 ± 14.8% | 0.08 ± 12.1% | not timed | not timed | 0.29 ± 1.3% | | 1.00 | 4.14 | 3.45 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 5.17 ± 14.8% | not timed | not timed | 5.63 ± 0.6% | 0.54 ± 15.5% | not timed | not timed | 5.22 ± 2.8% | | 0.99 | 0.92 | 9.61 |
| dictionary/search/english-10 | 690 | 0.92 ± 1.0% | not timed | not timed | 109.09 ± 0.6% | 0.00 ± 0.5% | not timed | not timed | 0.93 ± 0.8% | | 0.99 | 0.0084 | 197.45 |
| dictionary/search/english-15 | 15 | 466.17 ± 1.0% | not timed | not timed | 442.14 ± 0.1% | 0.28 ± 0.7% | not timed | not timed | 466.45 ± 1.1% | | 1.00 | 1.05 | 1648.67 |
| folly/awyer-inn-busted | 1 | 3681.68 ± 0.5% | not timed | not timed | 112.99 ± 0.2% | 37.37 ± 0.1% | not timed | not timed | 3678.11 ± 0.2% | | 1.00 | 32.58 | 98.52 |
| folly/literal-never-match-rare | 0 | 53868.74 ± 3.0% | not timed | not timed | 40235.98 ± 0.3% | 53940.86 ± 0.8% | not timed | not timed | 53945.48 ± 1.5% | | 1.00 | 1.34 | 1.00 |
| folly/literal-never-match-frequent | 0 | 17954.97 ± 0.6% | not timed | not timed | 39772.78 ± 0.7% | 2080.05 ± 1.7% | not timed | not timed | 17923.71 ± 0.5% | | 1.00 | 0.45 | 8.63 |
| folly/literal-never-match-tricksy | 1 | 3228.46 ± 5.7% | not timed | not timed | 4814.01 ± 0.7% | 1513.17 ± 0.7% | not timed | not timed | 3235.65 ± 0.5% | | 1.00 | 0.67 | 2.13 |
| grep/every-line | 239963 | 1226.75 ± 0.7% | not timed | not timed | 790.59 ± 0.4% | 312.88 ± 37.9% | not timed | not timed | 1230.36 ± 1.1% | | 1.00 | 1.55 | 3.92 |
| grep/long-words-ascii | 5073 | 444.85 ± 0.7% | not timed | not timed | 411.49 ± 0.3% | 38.08 ± 12.5% | not timed | not timed | 445.02 ± 0.1% | | 1.00 | 1.08 | 11.68 |
| imported/leipzig/twain | 811 | 43299.13 ± 2.2% | not timed | not timed | 36187.63 ± 5.5% | 10141.77 ± 21.4% | not timed | not timed | 42305.54 ± 9.5% | | 1.02 | 1.20 | 4.27 |
| imported/leipzig/twain-insensitive | 965 | 12916.54 ± 1.1% | not timed | not timed | 11123.86 ± 1.1% | 35.00 ± 0.2% | not timed | not timed | 12907.16 ± 1.0% | | 1.00 | 1.16 | 369.03 |
| imported/leipzig/shing | 1540 | 22867.75 ± 4.9% | not timed | not timed | 18440.12 ± 1.3% | 30.03 ± 0.1% | not timed | not timed | 23028.82 ± 1.6% | | 0.99 | 1.24 | 761.46 |
| imported/leipzig/huck-saw | 262 | 20593.90 ± 1.1% | not timed | not timed | 15679.25 ± 0.4% | 27.30 ± 1.1% | not timed | not timed | 20343.51 ± 22.9% | | 1.01 | 1.31 | 754.38 |
| imported/leipzig/word-ending-nn | 262 | 533.61 ± 1.0% | not timed | not timed | 532.40 ± 1.3% | 21.52 ± 2.0% | not timed | not timed | 532.93 ± 0.2% | | 1.00 | 1.00 | 24.80 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 9928.51 ± 2.1% | not timed | not timed | 3160.05 ± 2.7% | 9.68 ± 1.2% | not timed | not timed | 9925.21 ± 1.1% | | 1.00 | 3.14 | 1025.24 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 17206.51 ± 8.8% | not timed | not timed | 14275.24 ± 0.8% | 14.93 ± 1.5% | not timed | not timed | 17331.32 ± 5.7% | | 0.99 | 1.21 | 1152.18 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4976.39 ± 1.5% | not timed | not timed | 704.13 ± 0.6% | 8.92 ± 0.5% | not timed | not timed | 4974.21 ± 0.3% | | 1.00 | 7.07 | 558.13 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 531.04 ± 0.4% | not timed | not timed | 530.91 ± 0.3% | 9.88 ± 0.9% | not timed | not timed | 531.70 ± 0.1% | | 1.00 | 1.00 | 53.77 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 532.36 ± 0.7% | not timed | not timed | 531.54 ± 0.2% | 8.49 ± 1.2% | not timed | not timed | 531.48 ± 0.3% | | 1.00 | 1.00 | 62.68 |
| imported/leipzig/tom-river | 2 | 10951.56 ± 1.9% | not timed | not timed | 11160.38 ± 9.3% | 27.06 ± 0.8% | not timed | not timed | 10854.78 ± 1.5% | | 1.01 | 0.98 | 404.70 |
| imported/leipzig/ing | 78424 | 523.31 ± 1.5% | not timed | not timed | 492.06 ± 0.2% | 24.21 ± 5.1% | not timed | not timed | 523.81 ± 0.5% | | 1.00 | 1.06 | 21.62 |
| imported/leipzig/ing-whitespace | 55248 | 641.79 ± 0.5% | not timed | not timed | 1815.71 ± 2.0% | 17.48 ± 3.1% | not timed | not timed | 649.92 ± 2.1% | | 0.99 | 0.35 | 36.71 |
| imported/leipzig/awyer-inn | 209 | 672.97 ± 1.2% | not timed | not timed | 11429.83 ± 0.3% | 19.33 ± 2.0% | not timed | not timed | 672.66 ± 1.5% | | 1.00 | 0.0589 | 34.82 |
| imported/leipzig/quotes-bounded | 8886 | 1610.80 ± 0.3% | not timed | not timed | 2838.29 ± 1.2% | 31.69 ± 2.2% | not timed | not timed | 1616.98 ± 6.9% | | 1.00 | 0.57 | 50.83 |
| imported/leipzig/non-ascii-alternate | 2 | 30155.79 ± 5.1% | not timed | not timed | 16346.89 ± 2.0% | 42.66 ± 0.7% | not timed | not timed | 30488.76 ± 2.3% | | 0.99 | 1.84 | 706.93 |
| imported/leipzig/math-symbols | 69 | 1602.82 ± 11.2% | not timed | not timed | 533.24 ± 0.1% | 31.38 ± 2.8% | not timed | not timed | 1602.71 ± 0.2% | | 1.00 | 3.01 | 51.08 |
| imported/leipzig/bounded-strings-ending-z | 0 | 534.71 ± 0.7% | not timed | not timed | 532.92 ± 0.2% | 20.13 ± 0.3% | not timed | not timed | 534.97 ± 1.0% | | 1.00 | 1.00 | 26.56 |
| imported/lh3lh3-reb/uri | 17549 | 662.65 ± 0.9% | not timed | not timed | 883.39 ± 1.6% | 18.57 ± 2.9% | not timed | not timed | 664.12 ± 0.5% | | 1.00 | 0.75 | 35.68 |
| imported/lh3lh3-reb/email | 15057 | 659.43 ± 0.5% | not timed | not timed | 912.86 ± 2.7% | 18.96 ± 1.7% | not timed | not timed | 655.75 ± 2.4% | | 1.01 | 0.72 | 34.78 |
| imported/lh3lh3-reb/date | 668 | 784.12 ± 1.5% | not timed | not timed | 814.09 ± 6.6% | 43.08 ± 5.0% | not timed | not timed | 787.00 ± 0.6% | | 1.00 | 0.96 | 18.20 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 619.01 ± 0.3% | not timed | not timed | 370.33 ± 3.3% | 9.61 ± 1.1% | not timed | not timed | 619.20 ± 1.1% | | 1.00 | 1.67 | 64.44 |
| imported/mariomka/email | 92 | 29430.27 ± 4.0% | not timed | not timed | 38730.42 ± 2.9% | 28.29 ± 0.4% | not timed | not timed | 29377.87 ± 3.3% | | 1.00 | 0.76 | 1040.19 |
| imported/mariomka/uri | 5301 | 5570.80 ± 0.8% | not timed | not timed | 6543.79 ± 1.1% | 28.34 ± 2.0% | not timed | not timed | 5576.01 ± 1.1% | | 1.00 | 0.85 | 196.55 |
| imported/mariomka/ip | 5 | 1551.84 ± 4.4% | not timed | not timed | 2034.89 ± 0.5% | 18.02 ± 1.9% | not timed | not timed | 1555.08 ± 3.3% | | 1.00 | 0.76 | 86.10 |
| imported/rsc/no-exponential | 0 | 629.66 ± 3.3% | not timed | not timed | 333.65 ± 1.5% | 14.00 ± 0.4% | not timed | not timed | 666.22 ± 1.7% | | 0.95 | 1.89 | 44.97 |
| imported/rsc/literal | 1 | 744.70 ± 2.9% | not timed | not timed | 1749.63 ± 1.3% | 154.72 ± 11.0% | not timed | not timed | 750.19 ± 4.4% | | 0.99 | 0.43 | 4.81 |
| imported/rsc/not-literal | 2 | 706.14 ± 1.5% | not timed | not timed | 723.35 ± 0.4% | 20.69 ± 0.3% | not timed | not timed | 708.48 ± 1.6% | | 1.00 | 0.98 | 34.13 |
| imported/rsc/match-class | 1 | 1340.88 ± 18.9% | not timed | not timed | 1488.04 ± 0.4% | 49.98 ± 12.6% | not timed | not timed | 1359.38 ± 0.9% | | 0.99 | 0.90 | 26.83 |
| imported/rsc/match-class-in-range | 1 | 1358.61 ± 0.2% | not timed | not timed | 2685.75 ± 2.2% | 51.51 ± 0.6% | not timed | not timed | 1359.30 ± 0.7% | | 1.00 | 0.51 | 26.38 |
| imported/rsc/match-class-unicode | 1 | 481.97 ± 0.9% | not timed | not timed | 455.73 ± 0.8% | 61.39 ± 1.2% | not timed | not timed | 480.31 ± 7.2% | | 1.00 | 1.06 | 7.85 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1294.19 ± 36.9% | not timed | not timed | 876.68 ± 4.3% | 255.24 ± 21.7% | not timed | not timed | 1294.32 ± 2.6% | | 1.00 | 1.48 | 5.07 |
| imported/rsc/anchored-literal-long-non-match | 0 | 19812.20 ± 0.8% | not timed | not timed | 13451.50 ± 1.1% | 3922.49 ± 2.5% | not timed | not timed | 19848.90 ± 1.2% | | 1.00 | 1.47 | 5.05 |
| imported/rsc/anchored-literal-short-match | 4 | 687.50 ± 2.5% | not timed | not timed | 507.76 ± 1.8% | 80.79 ± 14.0% | not timed | not timed | 686.53 ± 1.3% | | 1.00 | 1.35 | 8.51 |
| imported/rsc/anchored-literal-long-match | 4 | 10179.74 ± 2.4% | not timed | not timed | 7656.72 ± 0.6% | 1196.23 ± 1.5% | not timed | not timed | 10291.53 ± 3.8% | | 0.99 | 1.33 | 8.51 |
| imported/rsc/one-pass-short | 17 | 342.01 ± 2.2% | not timed | not timed | 220.71 ± 0.8% | 27.18 ± 10.1% | not timed | not timed | 343.25 ± 2.9% | | 1.00 | 1.55 | 12.59 |
| imported/rsc/one-pass-short-not | 17 | 245.92 ± 9.2% | not timed | not timed | 229.37 ± 1.9% | 25.09 ± 9.8% | not timed | not timed | 244.61 ± 1.5% | | 1.01 | 1.07 | 9.80 |
| imported/rsc/one-pass-long-prefix | 26 | 345.13 ± 1.9% | not timed | not timed | 278.81 ± 0.4% | 91.40 ± 20.4% | not timed | not timed | 353.17 ± 0.7% | | 0.98 | 1.24 | 3.78 |
| imported/rsc/one-pass-long-prefix-not | 26 | 350.73 ± 1.8% | not timed | not timed | 280.55 ± 0.3% | 61.61 ± 21.1% | not timed | not timed | 352.44 ± 4.8% | | 1.00 | 1.25 | 5.69 |
| imported/rsc/long-needle1 | 31 | 57474.12 ± 2.8% | not timed | not timed | 39431.58 ± 1.9% | 3.22 ± 0.6% | not timed | not timed | 57186.21 ± 3.7% | | 1.01 | 1.46 | 17867.25 |
| imported/rsc/long-needle2 | 31 | 55962.36 ± 1.9% | not timed | not timed | 172.10 ± 0.4% | 3.22 ± 2.0% | not timed | not timed | 55743.91 ± 3.3% | | 1.00 | 325.17 | 17353.16 |
| imported/rsc/easy0-32 | 26 | 1046.04 ± 0.3% | not timed | not timed | 1511.89 ± 2.1% | 62.44 ± 2.3% | not timed | not timed | 1045.76 ± 11.5% | | 1.00 | 0.69 | 16.75 |
| imported/rsc/easy0-1k | 26 | 17342.73 ± 1.0% | not timed | not timed | 16245.38 ± 0.3% | 1036.02 ± 12.7% | not timed | not timed | 17212.31 ± 1.6% | | 1.01 | 1.07 | 16.74 |
| imported/rsc/easy0-32k | 26 | 55498.84 ± 0.5% | not timed | not timed | 38511.19 ± 0.7% | 20643.34 ± 1.2% | not timed | not timed | 55579.02 ± 0.4% | | 1.00 | 1.44 | 2.69 |
| imported/rsc/easy0-1mb | 26 | 54865.30 ± 2.1% | not timed | not timed | 39784.17 ± 1.2% | 54291.30 ± 3.0% | not timed | not timed | 54741.22 ± 0.8% | | 1.00 | 1.38 | 1.01 |
| imported/rsc/easy1-32 | 19 | 711.88 ± 0.4% | not timed | not timed | 647.09 ± 0.9% | 76.40 ± 22.3% | not timed | not timed | 711.63 ± 1.8% | | 1.00 | 1.10 | 9.32 |
| imported/rsc/easy1-1k | 19 | 14481.36 ± 6.9% | not timed | not timed | 13264.88 ± 1.2% | 1340.78 ± 6.7% | not timed | not timed | 14542.12 ± 0.5% | | 1.00 | 1.09 | 10.80 |
| imported/rsc/easy1-32k | 19 | 457050.79 ± 1.9% | not timed | not timed | 414075.58 ± 1.2% | 22669.08 ± 37.1% | not timed | not timed | 457409.15 ± 0.6% | | 1.00 | 1.10 | 20.16 |
| imported/rsc/easy1-1mb | 19 | 14603724.58 ± 0.5% | not timed | not timed | 13295711.95 ± 1.0% | 54024.61 ± 1.5% | not timed | not timed | 14561946.58 ± 1.9% | | 1.00 | 1.10 | 270.32 |
| imported/rsc/medium-32 | 27 | 684.42 ± 1.3% | not timed | not timed | 628.22 ± 2.4% | 39.48 ± 28.3% | not timed | not timed | 681.43 ± 1.2% | | 1.00 | 1.09 | 17.33 |
| imported/rsc/medium-1k | 27 | 12168.39 ± 1.8% | not timed | not timed | 11202.85 ± 0.7% | 59.52 ± 0.8% | not timed | not timed | 12108.52 ± 0.5% | | 1.00 | 1.09 | 204.46 |
| imported/rsc/medium-32k | 27 | 380429.69 ± 0.5% | not timed | not timed | 349416.15 ± 3.9% | 41.58 ± 0.8% | not timed | not timed | 377654.67 ± 11.0% | | 1.01 | 1.09 | 9148.94 |
| imported/rsc/medium-1mb | 27 | 12174387.52 ± 0.8% | not timed | not timed | 11063659.99 ± 0.3% | 41.56 ± 1.3% | not timed | not timed | 12094375.68 ± 0.9% | | 1.01 | 1.10 | 292949.33 |
| imported/rsc/hard-32 | 58 | 365.49 ± 0.1% | not timed | not timed | 342.64 ± 21.2% | 24.69 ± 0.2% | not timed | not timed | 367.44 ± 0.3% | | 0.99 | 1.07 | 14.81 |
| imported/rsc/hard-1k | 27 | 11304.82 ± 0.3% | not timed | not timed | 10859.45 ± 2.3% | 20.31 ± 0.5% | not timed | not timed | 11430.04 ± 8.0% | | 0.99 | 1.04 | 556.63 |
| imported/rsc/hard-32k | 27 | 353292.06 ± 0.4% | not timed | not timed | 350821.29 ± 0.8% | 25.59 ± 2.5% | not timed | not timed | 356951.10 ± 0.2% | | 0.99 | 1.01 | 13808.04 |
| imported/rsc/hard-1mb | 51 | 7233901.30 ± 0.3% | not timed | not timed | 6778524.38 ± 0.8% | 25.70 ± 0.8% | not timed | not timed | 7292583.57 ± 0.2% | | 0.99 | 1.07 | 281429.44 |
| imported/rsc/reallyhard0-32 | 58 | 239.69 ± 0.5% | not timed | not timed | 214.27 ± 0.4% | 24.72 ± 17.8% | not timed | not timed | 240.18 ± 1.8% | | 1.00 | 1.12 | 9.70 |
| imported/rsc/reallyhard0-1k | 27 | 516.72 ± 0.3% | not timed | not timed | 510.10 ± 0.9% | 20.30 ± 0.6% | not timed | not timed | 517.14 ± 0.1% | | 1.00 | 1.01 | 25.45 |
| imported/rsc/reallyhard0-32k | 27 | 533.58 ± 0.2% | not timed | not timed | 531.65 ± 0.3% | 25.43 ± 1.1% | not timed | not timed | 533.66 ± 0.3% | | 1.00 | 1.00 | 20.98 |
| imported/rsc/reallyhard0-1mb | 51 | 533.71 ± 0.3% | not timed | not timed | 532.70 ± 0.3% | 25.62 ± 0.6% | not timed | not timed | 533.88 ± 0.9% | | 1.00 | 1.00 | 20.84 |
| imported/rsc/reallyreallyhard0-32 | 47 | 273.96 ± 2.3% | not timed | not timed | 183.62 ± 0.5% | 44.31 ± 9.6% | not timed | not timed | 273.43 ± 1.5% | | 1.00 | 1.49 | 6.18 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6826.38 ± 0.8% | not timed | not timed | 6413.66 ± 0.3% | 27.15 ± 3.0% | not timed | not timed | 6808.16 ± 0.2% | | 1.00 | 1.06 | 251.46 |
| imported/rsc/reallyreallyhard0-32k | 16 | 45320.24 ± 1.1% | not timed | not timed | 32532.82 ± 0.6% | 20.99 ± 0.3% | not timed | not timed | 45473.35 ± 0.2% | | 1.00 | 1.39 | 2159.28 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 56421.34 ± 2.6% | not timed | not timed | 39283.50 ± 0.8% | 20.92 ± 0.7% | not timed | not timed | 56737.29 ± 4.2% | | 0.99 | 1.44 | 2697.17 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 265.99 ± 9.8% | not timed | not timed | 189.65 ± 4.9% | 45.15 ± 3.7% | not timed | not timed | 266.98 ± 2.8% | | 1.00 | 1.40 | 5.89 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5538.74 ± 0.8% | not timed | not timed | 6561.48 ± 0.4% | 27.26 ± 0.4% | not timed | not timed | 5542.31 ± 0.2% | | 1.00 | 0.84 | 203.18 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 43289.34 ± 0.4% | not timed | not timed | 32854.43 ± 22.7% | 21.01 ± 0.2% | not timed | not timed | 43102.00 ± 2.4% | | 1.00 | 1.32 | 2060.00 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 52561.04 ± 1.1% | not timed | not timed | 39221.46 ± 1.2% | 20.89 ± 1.7% | not timed | not timed | 52506.16 ± 1.3% | | 1.00 | 1.34 | 2516.43 |
| imported/sherlock/name-sherlock | 776 | 37870.27 ± 2.1% | not timed | not timed | 31784.46 ± 0.7% | 9439.06 ± 21.8% | not timed | not timed | 38086.40 ± 1.4% | | 0.99 | 1.19 | 4.01 |
| imported/sherlock/name-holmes | 2766 | 19860.97 ± 2.2% | not timed | not timed | 18288.07 ± 2.9% | 2942.69 ± 19.0% | not timed | not timed | 19756.16 ± 1.7% | | 1.01 | 1.09 | 6.75 |
| imported/sherlock/name-sherlock-holmes | 1365 | 38184.38 ± 8.8% | not timed | not timed | 32115.66 ± 2.8% | 7413.48 ± 33.0% | not timed | not timed | 38595.76 ± 1.7% | | 0.99 | 1.19 | 5.15 |
| imported/sherlock/name-sherlock-casei | 816 | 31425.14 ± 0.6% | not timed | not timed | 9461.62 ± 0.7% | 24.12 ± 0.9% | not timed | not timed | 31264.83 ± 1.4% | | 1.01 | 3.32 | 1302.87 |
| imported/sherlock/name-holmes-casei | 2802 | 17113.56 ± 1.2% | not timed | not timed | 5908.19 ± 0.3% | 35.12 ± 0.8% | not timed | not timed | 17024.02 ± 1.2% | | 1.01 | 2.90 | 487.27 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 27949.57 ± 16.3% | not timed | not timed | 9082.62 ± 0.5% | 24.11 ± 1.4% | not timed | not timed | 27872.21 ± 0.8% | | 1.00 | 3.08 | 1159.33 |
| imported/sherlock/name-whitespace | 1461 | 22329.23 ± 11.1% | not timed | not timed | 21656.37 ± 1.6% | 6786.84 ± 16.8% | not timed | not timed | 22466.85 ± 15.8% | | 0.99 | 1.03 | 3.29 |
| imported/sherlock/name-alt1 | 1142 | 21682.83 ± 1.8% | not timed | not timed | 22890.95 ± 8.9% | 3758.86 ± 22.3% | not timed | not timed | 21629.08 ± 0.4% | | 1.00 | 0.95 | 5.77 |
| imported/sherlock/name-alt2 | 3542 | 13657.36 ± 0.6% | not timed | not timed | 7775.64 ± 1.0% | 27.14 ± 1.6% | not timed | not timed | 13593.33 ± 0.5% | | 1.00 | 1.76 | 503.15 |
| imported/sherlock/name-alt3 | 4507 | 9296.66 ± 1.4% | not timed | not timed | 6988.12 ± 0.3% | 8.72 ± 0.3% | not timed | not timed | 9336.33 ± 1.0% | | 1.00 | 1.33 | 1066.14 |
| imported/sherlock/name-alt3-casei | 4593 | 1582.25 ± 1.7% | not timed | not timed | 1077.17 ± 0.1% | 5.49 ± 1.7% | not timed | not timed | 1582.59 ± 4.5% | | 1.00 | 1.47 | 288.39 |
| imported/sherlock/name-alt4 | 3686 | 7286.26 ± 0.6% | not timed | not timed | 6046.85 ± 0.3% | 27.13 ± 3.7% | not timed | not timed | 7300.69 ± 21.0% | | 1.00 | 1.20 | 268.57 |
| imported/sherlock/name-alt4-casei | 4254 | 3165.59 ± 15.6% | not timed | not timed | 3103.24 ± 3.7% | 15.00 ± 2.5% | not timed | not timed | 3160.86 ± 4.5% | | 1.00 | 1.02 | 211.01 |
| imported/sherlock/name-alt5 | 4028 | 11480.38 ± 1.1% | not timed | not timed | 7395.02 ± 0.1% | 19.21 ± 3.1% | not timed | not timed | 11432.13 ± 3.7% | | 1.00 | 1.55 | 597.71 |
| imported/sherlock/name-alt5-casei | 4104 | 4827.59 ± 1.5% | not timed | not timed | 2390.33 ± 0.4% | 11.26 ± 22.2% | not timed | not timed | 4867.73 ± 2.3% | | 0.99 | 2.02 | 428.92 |
| imported/sherlock/no-match-uncommon | 0 | 53337.50 ± 1.7% | not timed | not timed | 49536.09 ± 7.2% | 44029.61 ± 10.5% | not timed | not timed | 53401.09 ± 0.5% | | 1.00 | 1.08 | 1.21 |
| imported/sherlock/no-match-common | 0 | 51962.31 ± 15.8% | not timed | not timed | 49412.74 ± 1.9% | 1571.57 ± 0.5% | not timed | not timed | 51727.92 ± 0.6% | | 1.00 | 1.05 | 33.06 |
| imported/sherlock/no-match-really-common | 0 | 32514.67 ± 14.6% | not timed | not timed | 30485.88 ± 1.3% | 1576.89 ± 0.3% | not timed | not timed | 32502.05 ± 1.0% | | 1.00 | 1.07 | 20.62 |
| imported/sherlock/the-lower | 21654 | 2482.61 ± 1.0% | not timed | not timed | 2077.35 ± 1.1% | 231.91 ± 11.8% | not timed | not timed | 2486.36 ± 0.7% | | 1.00 | 1.20 | 10.70 |
| imported/sherlock/the-upper | 2223 | 14647.51 ± 2.5% | not timed | not timed | 18636.34 ± 28.7% | 2499.00 ± 16.3% | not timed | not timed | 14678.51 ± 2.0% | | 1.00 | 0.79 | 5.86 |
| imported/sherlock/the-casei | 23961 | 2209.18 ± 0.4% | not timed | not timed | 1129.55 ± 0.3% | 32.39 ± 36.9% | not timed | not timed | 2196.91 ± 1.2% | | 1.01 | 1.96 | 68.21 |
| imported/sherlock/everything-greedy | 581881 | 246.26 ± 0.4% | not timed | not timed | 145.50 ± 1.6% | 23.61 ± 28.1% | not timed | not timed | 246.65 ± 0.2% | | 1.00 | 1.69 | 10.43 |
| imported/sherlock/everything-greedy-nl | 594933 | 406.78 ± 1.3% | not timed | not timed | 188.71 ± 0.3% | 27.10 ± 25.7% | not timed | not timed | 407.05 ± 3.5% | | 1.00 | 2.16 | 15.01 |
| imported/sherlock/letters | 447175 | 56.70 ± 24.9% | not timed | not timed | 29.84 ± 0.6% | 5.39 ± 44.2% | not timed | not timed | 56.75 ± 0.8% | | 1.00 | 1.90 | 10.52 |
| imported/sherlock/letters-upper | 14180 | 389.44 ± 0.9% | not timed | not timed | 324.65 ± 10.1% | 25.03 ± 20.1% | not timed | not timed | 390.09 ± 0.3% | | 1.00 | 1.20 | 15.56 |
| imported/sherlock/letters-lower | 432995 | 57.45 ± 0.6% | not timed | not timed | 30.08 ± 10.9% | 4.92 ± 23.2% | not timed | not timed | 57.42 ± 23.8% | | 1.00 | 1.91 | 11.68 |
| imported/sherlock/words | 447639 | 103.80 ± 6.5% | not timed | not timed | 71.91 ± 1.6% | 11.82 ± 17.6% | not timed | not timed | 104.41 ± 1.0% | | 0.99 | 1.44 | 8.78 |
| imported/sherlock/before-holmes | 4073 | 10573.89 ± 2.9% | not timed | not timed | 9763.30 ± 0.5% | 19.94 ± 0.3% | not timed | not timed | 10691.48 ± 3.2% | | 0.99 | 1.08 | 530.39 |
| imported/sherlock/before-after-holmes | 2593 | 10579.45 ± 3.0% | not timed | not timed | 11124.32 ± 1.9% | 20.24 ± 0.8% | not timed | not timed | 10530.79 ± 5.7% | | 1.00 | 0.95 | 522.78 |
| imported/sherlock/holmes-cochar-watson | 150 | 7384.15 ± 0.4% | not timed | not timed | 5917.50 ± 0.7% | 26.95 ± 1.1% | not timed | not timed | 7412.13 ± 0.8% | | 1.00 | 1.25 | 274.04 |
| imported/sherlock/holmes-coword-watson | 14309 | 1118.28 ± 0.1% | not timed | not timed | 1077.89 ± 0.5% | 5.85 ± 17.2% | not timed | not timed | 1120.05 ± 0.6% | | 1.00 | 1.04 | 191.01 |
| imported/sherlock/quotes | 14437 | 1112.14 ± 1.7% | not timed | not timed | 1550.36 ± 0.1% | 29.34 ± 26.7% | not timed | not timed | 1122.24 ± 0.3% | | 0.99 | 0.72 | 37.90 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 533.76 ± 0.2% | not timed | not timed | 24883.77 ± 2.7% | 31.79 ± 0.8% | not timed | not timed | 533.63 ± 0.8% | | 1.00 | 0.0215 | 16.79 |
| imported/sherlock/word-ending-n | 35297 | 410.95 ± 0.5% | not timed | not timed | 353.10 ± 0.3% | 20.35 ± 1.7% | not timed | not timed | 411.04 ± 0.7% | | 1.00 | 1.16 | 20.19 |
| imported/sherlock/repeated-class-negation | 2130 | 12190.57 ± 5.3% | not timed | not timed | 11935.86 ± 11.3% | 9.76 ± 0.4% | not timed | not timed | 12208.14 ± 4.3% | | 1.00 | 1.02 | 1249.54 |
| imported/sherlock/ing-suffix | 20547 | 491.87 ± 1.3% | not timed | not timed | 446.54 ± 1.5% | 24.56 ± 20.2% | not timed | not timed | 491.24 ± 2.7% | | 1.00 | 1.10 | 20.03 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 523.53 ± 0.3% | not timed | not timed | 1935.23 ± 0.3% | 17.84 ± 0.3% | not timed | not timed | 521.88 ± 3.3% | | 1.00 | 0.27 | 29.34 |
| opt/accelerate/whole-line | 239963 | 442.80 ± 13.5% | not timed | not timed | 343.52 ± 0.4% | 75.70 ± 17.9% | not timed | not timed | 446.44 ± 0.3% | | 0.99 | 1.29 | 5.85 |
| opt/accelerate/non-dna | 16745 | 392.99 ± 5.8% | not timed | not timed | 368.39 ± 0.8% | 25.20 ± 18.8% | not timed | not timed | 394.59 ± 0.4% | | 1.00 | 1.07 | 15.59 |
| opt/backtrack/words-english | 40536 | 107.64 ± 3.7% | not timed | not timed | 86.65 ± 20.4% | 16.49 ± 8.3% | not timed | not timed | 106.59 ± 1.6% | | 1.01 | 1.24 | 6.53 |
| opt/fixed-length/too-small-ascii | 0 | 285.19 ± 4.0% | not timed | not timed | 609.20 ± 2.4% | 94.49 ± 3.3% | not timed | not timed | 285.42 ± 1.0% | | 1.00 | 0.47 | 3.02 |
| opt/fixed-length/too-big-ascii | 0 | 3336.19 ± 2.5% | not timed | not timed | 4910.48 ± 1.2% | 114.99 ± 0.7% | not timed | not timed | 3340.11 ± 31.2% | | 1.00 | 0.68 | 29.01 |
| opt/fixed-length/go33484-1 | 0 | 640618.53 ± 31.5% | not timed | not timed | 945486.38 ± 21.3% | 66868.02 ± 3.0% | not timed | not timed | 641293.97 ± 2.4% | | 1.00 | 0.68 | 9.58 |
| opt/fixed-length/go33484-2 | 0 | 639512.24 ± 20.9% | not timed | not timed | 945272.22 ± 0.3% | 19373.18 ± 4.5% | not timed | not timed | 639514.29 ± 3.2% | | 1.00 | 0.68 | 33.01 |
| opt/fixed-length/go33484-3 | 0 | 2171.73 ± 3.1% | not timed | not timed | 94121.99 ± 0.6% | 715.36 ± 0.9% | not timed | not timed | 2178.58 ± 2.3% | | 1.00 | 0.0231 | 3.04 |
| opt/literal-alt/one-pattern | 1 | 475.60 ± 1.6% | not timed | not timed | 482.01 ± 0.8% | 0.32 ± 0.9% | not timed | not timed | 490.89 ± 1.4% | | 0.97 | 0.99 | 1497.70 |
| opt/onepass/fn-predicate | 916 | 313.46 ± 12.8% | not timed | not timed | 329.07 ± 0.4% | 175.56 ± 43.0% | not timed | not timed | 313.76 ± 0.9% | | 1.00 | 0.95 | 1.79 |
| opt/onepass/first-three-words-english | 35128 | 124.35 ± 10.3% | not timed | not timed | 187.68 ± 1.1% | 55.68 ± 21.6% | not timed | not timed | 127.56 ± 0.6% | | 0.97 | 0.66 | 2.23 |
| opt/prefilter/literal-english | 1 | 53891.24 ± 3.2% | not timed | not timed | 40023.54 ± 26.2% | 19153.18 ± 1.4% | not timed | not timed | 53862.57 ± 1.5% | | 1.00 | 1.35 | 2.81 |
| opt/prefilter/literal-casei-english | 1 | 33644.58 ± 1.2% | not timed | not timed | 11877.22 ± 0.4% | 24.08 ± 1.2% | not timed | not timed | 33728.25 ± 1.4% | | 1.00 | 2.83 | 1396.98 |
| opt/prefilter/literal-russian | 1 | 54408.47 ± 3.5% | not timed | not timed | 39577.97 ± 0.4% | 1578.00 ± 0.4% | not timed | not timed | 54550.92 ± 15.5% | | 1.00 | 1.37 | 34.48 |
| opt/prefilter/literal-casei-russian | 1 | 21844.56 ± 1.4% | not timed | not timed | 8218.56 ± 0.3% | 30.58 ± 1.7% | not timed | not timed | 21743.53 ± 0.7% | | 1.00 | 2.66 | 714.26 |
| opt/prefilter/rust-functions | 948 | 11630.52 ± 0.2% | not timed | not timed | 10357.73 ± 1.4% | 1551.50 ± 0.3% | not timed | not timed | 11615.76 ± 0.2% | | 1.00 | 1.12 | 7.50 |
| opt/reverse-anchored/word-end | 1 | 25107849.58 ± 0.5% | not timed | not timed | 22595597.69 ± 0.5% | 41.80 ± 3.2% | not timed | not timed | 24550510.82 ± 0.3% | | 1.02 | 1.11 | 600705.78 |
| opt/reverse-inner/holmes | 2593 | 10550.39 ± 3.0% | not timed | not timed | 11068.35 ± 1.1% | 20.26 ± 0.3% | not timed | not timed | 10507.57 ± 1.6% | | 1.00 | 0.95 | 520.67 |
| opt/reverse-inner/email | 47 | 53814.64 ± 4.5% | not timed | not timed | 57522.15 ± 0.8% | 27.69 ± 5.9% | not timed | not timed | 54047.06 ± 6.9% | | 1.00 | 0.94 | 1943.37 |
| opt/reverse-inner/factored-prefix | 3542 | 524.72 ± 0.3% | not timed | not timed | 516.21 ± 0.1% | 11.02 ± 0.3% | not timed | not timed | 525.57 ± 0.1% | | 1.00 | 1.02 | 47.62 |
| opt/reverse-inner/no-quadratic-backward | 0 | 3644.26 ± 0.2% | not timed | not timed | 532.48 ± 0.3% | 63.21 ± 3.2% | not timed | not timed | 3642.11 ± 0.1% | | 1.00 | 6.84 | 57.65 |
| opt/reverse-inner/no-quadratic-forward | 0 | 621.06 ± 11.9% | not timed | not timed | 246.58 ± 0.3% | 11.58 ± 1.2% | not timed | not timed | 621.47 ± 4.9% | | 1.00 | 2.52 | 53.61 |
| opt/reverse-suffix/holmes | 4073 | 10563.19 ± 1.1% | not timed | not timed | 9802.52 ± 18.3% | 20.13 ± 0.4% | not timed | not timed | 10666.31 ± 0.9% | | 0.99 | 1.08 | 524.79 |
| opt/reverse-suffix/no-quadratic | 0 | 3647.50 ± 0.2% | not timed | not timed | 532.36 ± 0.2% | 63.10 ± 24.6% | not timed | not timed | 3644.26 ± 0.2% | | 1.00 | 6.85 | 57.81 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 108.72 ± 2.0% | not timed | not timed | 134.23 ± 0.6% | 9.82 ± 20.4% | not timed | not timed | 108.90 ± 9.5% | | 1.00 | 0.81 | 11.07 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 108.96 ± 23.4% | not timed | not timed | 135.95 ± 0.7% | 9.61 ± 22.6% | not timed | not timed | 108.98 ± 1.6% | | 1.00 | 0.80 | 11.33 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.26 ± 0.2% | not timed | not timed | 0.40 ± 1.3% | 93.02 ± 0.3% | not timed | not timed | 0.26 ± 0.6% | | 0.97 | 0.65 | 0.0028 |
| reported/i1095-word-repetition/ascii-search | 256 | 266.96 ± 4.1% | not timed | not timed | 247.03 ± 0.1% | 81.14 ± 0.2% | not timed | not timed | 267.66 ± 0.3% | | 1.00 | 1.08 | 3.29 |
| reported/i13-subset-regex/original-ascii | 4094 | 9933.17 ± 1.8% | not timed | not timed | 3172.46 ± 1.4% | 9.67 ± 1.2% | not timed | not timed | 9876.61 ± 14.2% | | 1.01 | 3.13 | 1027.27 |
| reported/i13-subset-regex/original-unicode | 4094 | 9890.67 ± 0.6% | not timed | not timed | 175.41 ± 2.2% | 9.64 ± 2.2% | not timed | not timed | 9889.70 ± 1.2% | | 1.00 | 56.39 | 1026.50 |
| reported/i13-subset-regex/big-ascii | 1955 | 9351.39 ± 2.9% | not timed | not timed | 43.69 ± 2.5% | 8.23 ± 0.6% | not timed | not timed | 9378.79 ± 0.8% | | 1.00 | 214.05 | 1136.01 |
| reported/i13-subset-regex/big-unicode | 1955 | 9316.39 ± 1.3% | not timed | not timed | 7.67 ± 55.1% | 8.24 ± 1.9% | not timed | not timed | 9306.13 ± 2.8% | | 1.00 | 1214.31 | 1130.15 |
| reported/i13-subset-regex/huge-ascii | 55 | 8755.31 ± 2.0% | not timed | not timed | 7.27 ± 1.4% | 7.32 ± 1.2% | not timed | not timed | 8737.32 ± 1.3% | | 1.00 | 1204.55 | 1196.11 |
| reported/i13-subset-regex/huge-unicode | 55 | 8683.88 ± 4.2% | not timed | not timed | 7.09 ± 0.7% | 7.27 ± 2.0% | not timed | not timed | 8704.10 ± 1.2% | | 1.00 | 1224.82 | 1195.00 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.11 ± 0.6% | not timed | not timed | 7.27 ± 1.6% | 7.32 ± 1.1% | not timed | not timed | 3.10 ± 0.4% | | 1.00 | 0.43 | 0.42 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.38 ± 0.9% | not timed | not timed | 7.12 ± 2.3% | 7.30 ± 0.9% | not timed | not timed | 4.34 ± 0.9% | | 1.01 | 0.62 | 0.60 |
| reported/i787-keywords/ascii | 5674 | 417.57 ± 0.5% | not timed | not timed | 121.16 ± 0.5% | 5.49 ± 1.4% | not timed | not timed | 422.17 ± 6.6% | | 0.99 | 3.45 | 76.06 |
| reported/i787-keywords/opt-ascii | 5674 | 416.70 ± 2.0% | not timed | not timed | 206.23 ± 4.4% | 8.82 ± 23.7% | not timed | not timed | 421.80 ± 2.6% | | 0.99 | 2.02 | 47.25 |
| slow/quadratic-regex-1x | 100 | 6.30 ± 7.0% | not timed | not timed | 4.62 ± 1.7% | 0.02 ± 2.0% | not timed | not timed | 6.33 ± 7.8% | | 1.00 | 1.36 | 336.93 |
| slow/quadratic-regex-2x | 199 | 3.01 ± 4.6% | not timed | not timed | 2.49 ± 0.3% | 0.00 ± 0.8% | not timed | not timed | 2.94 ± 10.6% | | 1.02 | 1.21 | 628.16 |
| slow/quadratic-haystack-1x | 100 | 21.42 ± 9.1% | not timed | not timed | 9.12 ± 0.4% | 0.82 ± 8.9% | not timed | not timed | 21.44 ± 9.1% | | 1.00 | 2.35 | 26.14 |
| slow/quadratic-haystack-2x | 200 | 16.29 ± 1.9% | not timed | not timed | 4.91 ± 1.3% | 0.44 ± 16.6% | not timed | not timed | 16.10 ± 3.3% | | 1.01 | 3.31 | 37.20 |
| unicode/codepoints/any-one | 1112064 | 277.61 ± 1.9% | not timed | not timed | 184.85 ± 0.8% | 16.14 ± 20.6% | not timed | not timed | 277.87 ± 16.4% | | 1.00 | 1.50 | 17.20 |
| unicode/codepoints/any-all | 4382592 | 235.14 ± 0.8% | not timed | not timed | 235.75 ± 0.4% | 96.70 ± 0.2% | not timed | not timed | 235.41 ± 1.2% | | 1.00 | 1.00 | 2.43 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 6.27 ± 2.5% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 533.64 ± 0.3% | not timed | not timed | 532.27 ± 0.3% | 121.60 ± 17.5% | not timed | not timed | 533.02 ± 0.2% | | 1.00 | 1.00 | 4.39 |
| unicode/overlapping-words/ascii | 6156 | 21.18 ± 6.3% | not timed | not timed | 33.87 ± 18.4% | 3.41 ± 2.9% | not timed | not timed | 20.92 ± 1.5% | | 1.01 | 0.63 | 6.22 |
| unicode/overlapping-words/english | 6156 | 1.11 ± 0.4% | not timed | not timed | 2.44 ± 0.8% | 2.17 ± 0.4% | not timed | not timed | 1.13 ± 1.6% | | 0.98 | 0.46 | 0.51 |
| unicode/overlapping-words/russian | 5710 | 1.02 ± 14.4% | not timed | not timed | 2.19 ± 0.4% | 5.38 ± 8.1% | not timed | not timed | 1.04 ± 0.4% | | 0.98 | 0.46 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 113.46 ± 3.4% | not timed | not timed | 72.55 ± 102.0% | 8.94 ± 48.5% | not timed | not timed | 113.39 ± 25.6% | | 1.00 | 1.56 | 12.69 |
| unicode/word/boundary-long-english | 3466 | 535.60 ± 4.5% | not timed | not timed | 521.02 ± 1.3% | 26.45 ± 1.3% | not timed | not timed | 535.84 ± 0.3% | | 1.00 | 1.03 | 20.25 |
| unicode/word/around-holmes-english | 27 | 41993.48 ± 1.9% | not timed | not timed | 38469.38 ± 1.1% | 17.90 ± 0.6% | not timed | not timed | 42166.63 ± 1.3% | | 1.00 | 1.09 | 2345.70 |
| wild/bibleref/long | 874 | 487.88 ± 0.8% | not timed | not timed | 498.52 ± 1.9% | 5.36 ± 0.1% | not timed | not timed | 486.80 ± 2.0% | | 1.00 | 0.98 | 90.95 |
| wild/bibleref/short | 30 | 16.78 ± 9.8% | not timed | not timed | 26.54 ± 0.8% | 10.67 ± 11.2% | not timed | not timed | 17.23 ± 9.7% | | 0.97 | 0.63 | 1.57 |
| wild/bibleref/line | 874 | 395.73 ± 1.6% | not timed | not timed | 211.72 ± 0.6% | 7.13 ± 11.0% | not timed | not timed | 398.59 ± 0.4% | | 0.99 | 1.87 | 55.51 |
| wild/caddy/caddy | 6 | 346.18 ± 21.6% | not timed | not timed | 243.28 ± 0.6% | 62.87 ± 12.0% | not timed | not timed | 345.23 ± 1.2% | | 1.00 | 1.42 | 5.51 |
| wild/dot-star-capture/rust-src-tools | 6 | 1276.02 ± 21.0% | not timed | not timed | 352.78 ± 3.9% | 11.08 ± 4.1% | not timed | not timed | 1277.87 ± 1.4% | | 1.00 | 3.62 | 115.20 |
| wild/ruff/noqa | 84 | 433.98 ± 0.2% | not timed | not timed | 441.12 ± 0.8% | 15.81 ± 7.8% | not timed | not timed | 434.46 ± 0.5% | | 1.00 | 0.98 | 27.45 |
| wild/ruff/unnecessary-coding-comment | 16 | 915.30 ± 10.8% | not timed | not timed | 598.88 ± 1.9% | 64.56 ± 7.5% | not timed | not timed | 917.25 ± 2.4% | | 1.00 | 1.53 | 14.18 |
| wild/ruff/string-quote-prefix | 2972 | 1290.97 ± 0.7% | not timed | not timed | 322.96 ± 0.1% | 303.98 ± 33.5% | not timed | not timed | 1299.79 ± 0.6% | | 0.99 | 4.00 | 4.25 |
| wild/ruff/space-around-operator | 1224378 | 187.85 ± 2.1% | not timed | not timed | 174.87 ± 0.3% | 14.79 ± 2.5% | not timed | not timed | 186.84 ± 2.4% | | 1.01 | 1.07 | 12.70 |
| wild/ruff/shebang | 282 | 902.60 ± 0.6% | not timed | not timed | 328.63 ± 0.5% | 81.26 ± 20.6% | not timed | not timed | 926.83 ± 0.6% | | 0.97 | 2.75 | 11.11 |
| wild/rustsec-cargo-audit/original-unix | 471 | 16871.19 ± 4.7% | not timed | not timed | 19636.23 ± 1.3% | 6301.99 ± 2.2% | not timed | not timed | 16619.67 ± 1.0% | | 1.02 | 0.86 | 2.68 |
| wild/rustsec-cargo-audit/original-windows | 462 | 15197.60 ± 33.6% | not timed | not timed | 18617.77 ± 0.9% | 5948.99 ± 1.4% | not timed | not timed | 15426.83 ± 3.8% | | 0.99 | 0.82 | 2.55 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 16804.45 ± 3.0% | not timed | not timed | 19096.00 ± 0.4% | 6073.91 ± 22.9% | not timed | not timed | 16737.26 ± 10.7% | | 1.00 | 0.88 | 2.77 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 13833.83 ± 1.6% | not timed | not timed | 19061.50 ± 19.4% | 6146.38 ± 0.8% | not timed | not timed | 13843.19 ± 0.8% | | 1.00 | 0.73 | 2.25 |
| wild/url/search | 234965 | 101.86 ± 14.4% | not timed | not timed | 49.39 ± 1.7% | 1.86 ± 1.5% | not timed | not timed | 103.84 ± 14.5% | | 0.98 | 2.06 | 54.74 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.02 ± 57.1% | not timed | not timed | 0.01 ± 1.9% | 0.01 ± 23.4% | not timed | not timed | 0.02 ± 33.4% | | 0.99 | 2.51 | 3.69 |
| dictionary/compile/english-15 | 1 | 0.29 ± 0.4% | not timed | not timed | 0.08 ± 2.5% | 0.09 ± 22.9% | not timed | not timed | 0.28 ± 35.7% | | 1.00 | 3.76 | 3.16 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.21 ± 1.6% | not timed | not timed | 0.02 ± 2.5% | 30.29 ± 7.0% | not timed | not timed | 0.21 ± 16.0% | | 1.00 | 10.93 | 0.0071 |
| reported/i1095-word-repetition/ascii-compile | 1 | 35.24 ± 1.8% | not timed | not timed | 13.16 ± 0.9% | 51.11 ± 30.8% | not timed | not timed | 35.07 ± 9.0% | | 1.00 | 2.68 | 0.69 |
| reported/i787-keywords/compile | 1 | 29.89 ± 17.5% | not timed | not timed | 1.96 ± 0.5% | 15.17 ± 31.3% | not timed | not timed | 30.45 ± 2.0% | | 0.98 | 15.28 | 1.97 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 299.22 ± 3.2% | not timed | not timed | 114.53 ± 0.9% | 480.46 ± 14.5% | not timed | not timed | 300.16 ± 21.5% | | 1.00 | 2.61 | 0.62 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 41.19 ± 3.1% | not timed | not timed | 4.23 ± 1.7% | 38.00 ± 2.9% | not timed | not timed | 41.15 ± 3.7% | | 1.00 | 9.75 | 1.08 |
| unicode/compile/one-letter | 53 | 5.38 ± 19.2% | not timed | not timed | 4.47 ± 1.3% | 53.92 ± 9.9% | not timed | not timed | 5.46 ± 0.8% | | 0.99 | 1.21 | 0.0998 |
| unicode/compile/fifty-letters | 1 | 0.91 ± 13.7% | not timed | not timed | 0.10 ± 1.1% | 57.93 ± 17.2% | not timed | not timed | 0.92 ± 3.9% | | 0.99 | 8.91 | 0.0158 |
| unicode/compile/fifty-letters-ascii | 1 | 158.54 ± 8.1% | not timed | not timed | 55.68 ± 4.3% | 164.02 ± 30.0% | not timed | not timed | 162.70 ± 14.9% | | 0.97 | 2.85 | 0.97 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 363.99 ± 1.3% | not timed | not timed | 37.50 ± 9.3% | 568.81 ± 14.8% | not timed | not timed | 363.12 ± 2.1% | | 1.00 | 9.71 | 0.64 |
| unicode/compile/match-every-line-ascii | 4 | 548.82 ± 6.0% | not timed | not timed | 131.03 ± 2.1% | 565.34 ± 21.6% | not timed | not timed | 547.17 ± 0.7% | | 1.00 | 4.19 | 0.97 |
| unicode/compile/negated-class-matches-codepoint | 1 | 299.19 ± 5.4% | not timed | not timed | 42.23 ± 41.8% | 1048.65 ± 12.1% | not timed | not timed | 300.61 ± 4.5% | | 1.00 | 7.08 | 0.29 |
| wild/bibleref/compile | 3 | 4.68 ± 14.4% | not timed | not timed | 1.93 ± 3.8% | 26.16 ± 15.8% | not timed | not timed | 4.83 ± 5.1% | | 0.97 | 2.43 | 0.18 |
| wild/url/compile | 1 | 0.56 ± 14.5% | not timed | not timed | 0.17 ± 0.6% | 0.35 ± 25.3% | not timed | not timed | 0.56 ± 1.6% | | 1.01 | 3.39 | 1.59 |

