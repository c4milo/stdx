# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
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
| literal: a word | 217 | 34822.12 ± 2.2% | 9513.56 ± 0.2% | 19.88 ± 3.0% | 31315.96 ± 0.9% | 8896.96 ± 8.9% | 10.77 ± 0.2% | 75.86 ± 1.0% | 35797.59 ± 3.4% | 3.66 | 0.97 | 1.11 | 3.91 |
| literal: a word that is not there | 0 | 52842.36 ± 0.8% | 8425.04 ± 2.9% | 19.65 ± 21.1% | 39622.11 ± 28.1% | 30261.18 ± 0.6% | 10.70 ± 0.3% | 71.94 ± 1.2% | 54107.89 ± 2.4% | 6.27 | 0.98 | 1.33 | 1.75 |
| literal: one of four words | 661 | 11818.24 ± 1.2% | 1379.89 ± 21.6% | 10.86 ± 2.7% | 9106.17 ± 0.8% | 19.29 ± 0.7% | 3.98 ± 0.2% | 6.45 ± 0.4% | 11768.23 ± 0.9% | 8.56 | 1.00 | 1.30 | 612.63 |
| literal: a word in any case | 217 | 28408.03 ± 1.2% | 1471.13 ± 0.6% | 15.03 ± 2.3% | 9235.69 ± 0.5% | 37.26 ± 0.4% | refused | differs | 28488.41 ± 1.0% | 19.31 | 1.00 | 3.08 | 762.42 |
| literal: an href attribute | 33 | 28598.10 ± 0.9% | 537.13 ± 0.5% | 18.26 ± 2.5% | 27236.61 ± 1.5% | 2046.49 ± 0.7% | 8.22 ± 0.3% | 60.23 ± 2.3% | 28970.08 ± 3.1% | 53.24 | 0.99 | 1.05 | 13.97 |
| literal: a word, second text | 123 | 35744.51 ± 2.4% | 3760.01 ± 0.6% | 19.60 ± 1.9% | 31780.71 ± 0.3% | 7127.75 ± 6.8% | 11.98 ± 0.3% | 65.56 ± 1.9% | 35866.24 ± 7.5% | 9.51 | 1.00 | 1.12 | 5.01 |
| class: two capitalized words | 1331 | 975.99 ± 0.3% | 529.03 ± 0.4% | 18.48 ± 2.6% | 503.88 ± 0.6% | 34.37 ± 5.8% | 9.30 ± 0.7% | 54.81 ± 0.1% | 976.37 ± 0.2% | 1.84 | 1.00 | 1.94 | 28.40 |
| class: a word that ends in ing | 3399 | 504.43 ± 0.3% | 504.40 ± 0.2% | 13.32 ± 1.7% | 472.92 ± 1.0% | 25.62 ± 9.6% | 5.34 ± 0.2% | 15.72 ± 2.5% | 505.01 ± 0.5% | 1.00 | 1.00 | 1.07 | 19.69 |
| class: a word in capitals | 2332 | 1312.46 ± 1.0% | 536.46 ± 0.1% | 19.27 ± 10.4% | 496.96 ± 0.4% | 36.43 ± 7.1% | 10.40 ± 1.2% | 75.98 ± 0.6% | 1314.08 ± 0.4% | 2.45 | 1.00 | 2.64 | 36.02 |
| class: a number | 8288 | 2173.52 ± 0.6% | 730.11 ± 0.4% | 19.33 ± 2.5% | 1481.34 ± 0.2% | 36.20 ± 16.1% | 0.33 ± 0.9% | 54.23 ± 0.4% | 2383.06 ± 0.4% | 2.98 | 0.91 | 1.47 | 60.05 |
| class: two capitalized words, second text | 5359 | 449.51 ± 0.1% | 455.53 ± 1.1% | 16.87 ± 6.4% | 417.27 ± 0.3% | 28.90 ± 11.4% | 10.56 ± 0.2% | 50.42 ± 0.4% | 449.36 ± 0.5% | 0.99 | 1.00 | 1.08 | 15.55 |
| other: a word between two words | 6104 | 713.94 ± 4.7% | 525.33 ± 0.3% | 16.75 ± 1.6% | 696.62 ± 3.3% | 95.89 ± 14.6% | 7.25 ± 0.7% | 55.84 ± 1.9% | 714.79 ± 0.3% | 1.36 | 1.00 | 1.02 | 7.45 |
| other: a number before a unit, second text | 1481 | 7198.88 ± 2.8% | 968.41 ± 2.8% | 18.50 ± 2.9% | 6429.96 ± 1.3% | 35.18 ± 0.5% | 10.99 ± 1.2% | 53.61 ± 12.0% | 7192.87 ± 1.3% | 7.43 | 1.00 | 1.12 | 204.62 |
| other: a heading's start tag | 110 | 18395.09 ± 7.4% | 653.56 ± 1.0% | 19.23 ± 2.2% | 2004.81 ± 0.2% | 1478.17 ± 1.8% | 10.03 ± 0.4% | 71.27 ± 17.7% | 18455.14 ± 2.1% | 28.15 | 1.00 | 9.18 | 12.44 |
| other: a whole word | 217 | 23347.79 ± 1.1% | 530.13 ± 0.3% | 19.15 ± 12.8% | 22687.54 ± 0.4% | 41.31 ± 0.4% | 9.42 ± 0.3% | 46.38 ± 0.5% | 24112.77 ± 4.0% | 44.04 | 0.97 | 1.03 | 565.13 |
| other: a line's first word, second text | 3716 | 1794.34 ± 2.1% | 520.10 ± 0.3% | 21.44 ± 1.9% | 1702.97 ± 1.1% | 52.88 ± 7.1% | refused | refused | 1775.78 ± 3.2% | 3.45 | 1.01 | 1.05 | 33.93 |
| other: fourteen octets before an x | 87 | 25324.85 ± 5.2% | 219.95 ± 0.2% | 5.56 ± 3.8% | 2731.69 ± 1.4% | 9.00 ± 5.4% | differs | 15.05 ± 1.9% | 25593.83 ± 2.1% | 115.14 | 0.99 | 9.27 | 2814.65 |
| other: a Greek word | 21815 | 464.33 ± 0.3% | 373.42 ± 0.9% | 23.22 ± 0.5% | 265.29 ± 0.3% | 38.73 ± 14.2% | differs | refused | 463.64 ± 0.4% | 1.24 | 1.00 | 1.75 | 11.99 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.69 ± 1.5% | 26.53 ± 0.7% | 0.79 ± 0.9% | 16.86 ± 0.3% | 2.34 ± 0.5% | differs | 3.43 ± 1.1% | 26.37 ± 9.8% | 1.01 | 1.01 | 1.58 | 11.43 |
| a UUID | 32895 | 23.25 ± 0.2% | 23.26 ± 0.4% | 0.54 ± 6.4% | 12.90 ± 0.3% | 2.52 ± 0.7% | 0.44 ± 0.4% | 2.99 ± 2.0% | 22.89 ± 0.4% | 1.00 | 1.02 | 1.80 | 9.21 |
| an IPv4 address | 33176 | 34.58 ± 0.5% | 34.53 ± 0.8% | 1.77 ± 0.5% | 24.09 ± 0.2% | 5.80 ± 1.3% | differs | 3.35 ± 0.6% | 34.61 ± 0.4% | 1.00 | 1.00 | 1.44 | 5.96 |
| a date and time | 32954 | 31.38 ± 0.4% | 31.52 ± 0.4% | 1.25 ± 0.1% | 18.13 ± 0.3% | 6.69 ± 6.3% | 0.76 ± 0.4% | 5.59 ± 0.9% | 31.46 ± 0.3% | 1.00 | 1.00 | 1.73 | 4.69 |
| a field path | 32606 | 29.04 ± 1.1% | 29.04 ± 1.3% | 0.89 ± 1.6% | 19.41 ± 2.1% | 2.92 ± 2.0% | differs | 2.37 ± 1.5% | 29.10 ± 2.6% | 1.00 | 1.00 | 1.50 | 9.93 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.84 ± 2.4% | 8.73 ± 2.9% | 8.85 ± 2.6% | 10.42 ± 2.0% | 4.72 ± 4.5% | 0.63 ± 1.6% | none | 8.69 ± 2.4% | 1.01 | 1.02 | 0.85 | 1.87 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 181.12 ± 0.6% | 181.58 ± 0.2% | 212.94 ± 1.1% | 80.46 ± 2.3% | 184.12 ± 4.3% | 530.36 ± 2.6% | 3841.13 ± 2.8% | 181.40 ± 0.4% | 1.00 | 1.00 | 2.25 | 0.98 |
| a UUID | 62 | 118.75 ± 9.9% | 118.98 ± 0.3% | 132.83 ± 1.5% | 47.01 ± 2.4% | 89.35 ± 1.2% | 201.47 ± 2.8% | 4039.26 ± 0.6% | 118.74 ± 0.3% | 1.00 | 1.00 | 2.53 | 1.33 |
| an IPv4 address | 29 | 357.12 ± 0.3% | 357.08 ± 2.0% | 503.88 ± 0.4% | 70.21 ± 0.9% | 113.78 ± 0.6% | 319.61 ± 0.9% | 6984.82 ± 0.8% | 356.87 ± 1.1% | 1.00 | 1.00 | 5.09 | 3.14 |
| a date and time | 56 | 256.59 ± 1.0% | 257.30 ± 0.6% | 324.59 ± 0.5% | 68.52 ± 1.7% | 122.09 ± 3.1% | 363.45 ± 2.0% | 4144.62 ± 1.1% | 257.09 ± 0.3% | 1.00 | 1.00 | 3.75 | 2.10 |
| a field path | 39 | 178.44 ± 9.0% | 178.66 ± 0.6% | 209.23 ± 0.4% | 73.45 ± 0.7% | 173.67 ± 2.2% | 573.59 ± 4.4% | 4645.97 ± 19.4% | 178.68 ± 0.5% | 1.00 | 1.00 | 2.43 | 1.03 |
| literal: a word | 7 | 510.73 ± 0.8% | 545.44 ± 0.8% | 949.96 ± 0.8% | 486.47 ± 13.6% | 588.52 ± 3.3% | 1165.09 ± 1.1% | 24683.62 ± 0.9% | 508.27 ± 1.1% | 0.94 | 1.00 | 1.05 | 0.87 |
| literal: a word that is not there | 8 | 488.02 ± 0.8% | 525.99 ± 12.5% | 890.54 ± 0.5% | 445.67 ± 0.6% | 568.02 ± 1.8% | 1098.84 ± 0.9% | 23228.51 ± 1.4% | 490.03 ± 0.4% | 0.93 | 1.00 | 1.10 | 0.86 |
| literal: one of four words | 26 | 204.97 ± 2.6% | 319.74 ± 10.9% | 426.76 ± 4.7% | 41.66 ± 1.5% | 218.46 ± 2.2% | 457.66 ± 1.0% | 10652.35 ± 1.1% | 204.06 ± 1.7% | 0.64 | 1.00 | 4.92 | 0.94 |
| literal: a word in any case | 11 | 371.35 ± 0.8% | 391.99 ± 8.4% | 576.19 ± 0.5% | 14.55 ± 1.0% | 620.62 ± 1.1% | refused | 19020.84 ± 8.0% | 370.97 ± 0.2% | 0.95 | 1.00 | 25.52 | 0.60 |
| literal: an href attribute | 12 | 287.83 ± 0.6% | 299.02 ± 0.5% | 395.65 ± 0.3% | 36.97 ± 1.8% | 428.45 ± 8.9% | 931.18 ± 0.3% | 18276.08 ± 17.5% | 287.77 ± 2.0% | 0.96 | 1.00 | 7.79 | 0.67 |
| literal: a word, second text | 10 | 453.08 ± 0.7% | 497.79 ± 2.3% | 820.36 ± 10.8% | 417.15 ± 9.0% | 489.18 ± 14.1% | 960.54 ± 0.7% | 20524.90 ± 0.8% | 454.47 ± 1.3% | 0.91 | 1.00 | 1.09 | 0.93 |
| class: two capitalized words | 23 | 371.54 ± 2.5% | 403.57 ± 2.4% | 593.92 ± 3.5% | 93.61 ± 1.1% | 449.60 ± 2.0% | 862.65 ± 10.4% | 6189.58 ± 27.1% | 373.51 ± 2.7% | 0.92 | 0.99 | 3.97 | 0.83 |
| class: a word that ends in ing | 9 | 447.37 ± 0.3% | 507.41 ± 0.7% | 901.78 ± 0.7% | 113.37 ± 0.8% | 633.38 ± 0.9% | 1318.92 ± 6.3% | 15131.44 ± 0.2% | 447.55 ± 0.7% | 0.88 | 1.00 | 3.95 | 0.71 |
| class: a word in capitals | 16 | 399.44 ± 0.4% | 429.78 ± 9.8% | 727.19 ± 1.2% | 121.10 ± 2.1% | 645.75 ± 2.3% | 1131.16 ± 1.9% | 8349.65 ± 0.2% | 398.68 ± 5.2% | 0.93 | 1.00 | 3.30 | 0.62 |
| class: a number | 6 | 510.10 ± 0.4% | 564.95 ± 0.7% | 1119.58 ± 15.4% | 36.37 ± 1.3% | 1172.28 ± 6.3% | 2101.00 ± 30.7% | 20510.30 ± 1.2% | 506.92 ± 1.5% | 0.90 | 1.01 | 14.02 | 0.44 |
| class: two capitalized words, second text | 23 | 375.74 ± 2.4% | 404.95 ± 1.2% | 598.25 ± 1.4% | 93.45 ± 1.8% | 446.03 ± 2.5% | 872.12 ± 5.7% | 6180.69 ± 4.3% | 375.47 ± 2.5% | 0.93 | 1.00 | 4.02 | 0.84 |
| other: a word between two words | 13 | 440.51 ± 0.4% | 457.69 ± 0.6% | 719.16 ± 0.3% | 119.56 ± 1.1% | 439.48 ± 6.3% | 964.77 ± 2.0% | 13257.86 ± 1.2% | 440.66 ± 0.5% | 0.96 | 1.00 | 3.68 | 1.00 |
| other: a number before a unit, second text | 15 | 324.38 ± 1.9% | 359.73 ± 1.1% | 504.03 ± 1.3% | 33.62 ± 1.5% | 539.57 ± 2.0% | 1104.75 ± 3.2% | 13698.38 ± 0.4% | 325.46 ± 0.3% | 0.90 | 1.00 | 9.65 | 0.60 |
| other: a heading's start tag | 13 | 299.91 ± 0.5% | 307.63 ± 0.4% | 409.60 ± 0.7% | 34.94 ± 2.6% | 524.62 ± 1.2% | 1031.17 ± 2.6% | 15970.94 ± 1.7% | 300.83 ± 0.5% | 0.97 | 1.00 | 8.58 | 0.57 |
| other: a whole word | 11 | 450.57 ± 20.0% | 477.46 ± 0.3% | 770.82 ± 2.5% | 111.44 ± 2.0% | 506.15 ± 1.5% | 1006.58 ± 3.6% | 20001.27 ± 3.2% | 449.31 ± 1.4% | 0.94 | 1.00 | 4.04 | 0.89 |
| other: a line's first word, second text | 17 | 415.06 ± 2.4% | 445.37 ± 3.8% | 741.32 ± 3.4% | 111.32 ± 11.6% | 571.91 ± 6.5% | refused | refused | 422.82 ± 2.3% | 0.93 | 0.98 | 3.73 | 0.73 |
| other: fourteen octets before an x | 16 | 84.18 ± 1.4% | 118.64 ± 0.2% | 137.89 ± 0.5% | 13.99 ± 3.3% | 391.90 ± 12.7% | 447.06 ± 10.9% | 11985.17 ± 0.4% | 84.32 ± 15.4% | 0.71 | 1.00 | 6.02 | 0.21 |
| other: a Greek word | 8 | 350.48 ± 5.3% | 485.46 ± 0.3% | 843.44 ± 0.5% | 46.20 ± 1.1% | 1155.67 ± 18.1% | 1996.16 ± 13.5% | refused | 350.59 ± 0.6% | 0.72 | 1.00 | 7.59 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 24567.97 ± 3.3% | not timed | not timed | 27099.61 ± 0.5% | 1908.72 ± 24.3% | not timed | not timed | 24458.82 ± 1.2% | | 1.00 | 0.91 | 12.87 |
| 01-literal/sherlock-casei-en | 522 | 20339.93 ± 3.0% | not timed | not timed | 7057.36 ± 0.4% | 28.63 ± 1.3% | not timed | not timed | 20261.06 ± 1.4% | | 1.00 | 2.88 | 710.52 |
| 01-literal/sherlock-ru | 724 | 25604.98 ± 2.1% | not timed | not timed | 27389.22 ± 1.8% | 1063.44 ± 2.3% | not timed | not timed | 25421.17 ± 0.9% | | 1.01 | 0.93 | 24.08 |
| 01-literal/sherlock-casei-ru | 746 | 9469.45 ± 0.6% | not timed | not timed | 5510.31 ± 0.2% | 30.56 ± 8.1% | not timed | not timed | 9462.72 ± 0.9% | | 1.00 | 1.72 | 309.88 |
| 01-literal/sherlock-zh | 30 | 45838.61 ± 2.6% | not timed | not timed | 36850.84 ± 0.5% | 1259.19 ± 0.4% | not timed | not timed | 45783.53 ± 12.0% | | 1.00 | 1.24 | 36.40 |
| 02-literal-alternate/sherlock-en | 714 | 10403.68 ± 0.9% | not timed | not timed | 8877.57 ± 11.1% | 14.58 ± 29.0% | not timed | not timed | 10395.52 ± 0.4% | | 1.00 | 1.17 | 713.49 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2102.98 ± 0.8% | not timed | not timed | 1814.35 ± 1.3% | 9.53 ± 0.2% | not timed | not timed | 2102.88 ± 7.1% | | 1.00 | 1.16 | 220.73 |
| 02-literal-alternate/sherlock-ru | 899 | 7950.43 ± 7.6% | not timed | not timed | 4220.16 ± 0.3% | 19.59 ± 0.6% | not timed | not timed | 7957.10 ± 10.2% | | 1.00 | 1.88 | 405.79 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2083.88 ± 3.9% | not timed | not timed | 1045.47 ± 0.3% | 8.54 ± 7.6% | not timed | not timed | 2083.69 ± 0.5% | | 1.00 | 1.99 | 243.90 |
| 02-literal-alternate/sherlock-zh | 207 | 14653.75 ± 0.8% | not timed | not timed | 10389.58 ± 6.8% | 27.71 ± 1.1% | not timed | not timed | 14671.55 ± 0.6% | | 1.00 | 1.41 | 528.86 |
| 03-date/ascii | 111817 | 114.51 ± 0.9% | not timed | not timed | 84.95 ± 0.5% | 0.18 ± 5.2% | not timed | not timed | 112.87 ± 2.8% | | 1.01 | 1.35 | 652.19 |
| 04-ruff-noqa/real | 84 | 425.15 ± 0.3% | not timed | not timed | 431.99 ± 1.4% | 15.65 ± 1.9% | not timed | not timed | 422.97 ± 0.4% | | 1.01 | 0.98 | 27.16 |
| 04-ruff-noqa/tweaked | 44 | 713.19 ± 0.7% | not timed | not timed | 427.53 ± 10.9% | 295.04 ± 0.3% | not timed | not timed | 712.06 ± 7.6% | | 1.00 | 1.67 | 2.42 |
| 05-lexer-veryl/single | 124800 | 3.48 ± 10.2% | not timed | not timed | 4.10 ± 4.6% | 0.21 ± 9.0% | not timed | not timed | 3.49 ± 31.0% | | 1.00 | 0.85 | 16.62 |
| 06-cloud-flare-redos/original | 107 | 375.15 ± 0.3% | not timed | not timed | 192.76 ± 1.1% | 20.70 ± 0.4% | not timed | not timed | 378.11 ± 0.1% | | 0.99 | 1.95 | 18.12 |
| 06-cloud-flare-redos/simplified-short | 102 | 356.67 ± 0.2% | not timed | not timed | 191.05 ± 9.2% | 22.01 ± 1.3% | not timed | not timed | 351.96 ± 0.5% | | 1.01 | 1.87 | 16.21 |
| 06-cloud-flare-redos/simplified-long | 10000 | 511.78 ± 0.2% | not timed | not timed | 211.87 ± 0.2% | 24.12 ± 1.1% | not timed | not timed | 506.53 ± 1.3% | | 1.01 | 2.42 | 21.21 |
| 07-unicode-character-data/parse-line | 558784 | 192.50 ± 5.4% | not timed | not timed | 160.22 ± 0.3% | 36.65 ± 11.2% | not timed | not timed | 192.06 ± 4.0% | | 1.00 | 1.20 | 5.25 |
| 08-words/all-english | 56691 | 109.22 ± 0.7% | not timed | not timed | 73.47 ± 0.3% | 10.54 ± 10.9% | not timed | not timed | 107.83 ± 20.7% | | 1.01 | 1.49 | 10.36 |
| 08-words/long-english | 839 | 538.39 ± 0.1% | not timed | not timed | 514.12 ± 0.3% | 26.71 ± 31.7% | not timed | not timed | 536.85 ± 1.2% | | 1.00 | 1.05 | 20.16 |
| 09-aws-keys/full | 0 | 439.18 ± 0.3% | not timed | not timed | 434.24 ± 0.6% | 50.50 ± 4.7% | not timed | not timed | 433.75 ± 0.9% | | 1.01 | 1.01 | 8.70 |
| 09-aws-keys/quick | 0 | 930.96 ± 0.3% | not timed | not timed | 802.59 ± 0.7% | 331.75 ± 0.3% | not timed | not timed | 932.15 ± 0.1% | | 1.00 | 1.16 | 2.81 |
| 10-bounded-repeat/letters-en | 1833 | 482.36 ± 0.3% | not timed | not timed | 432.02 ± 0.3% | 16.97 ± 0.6% | not timed | not timed | 479.71 ± 0.8% | | 1.01 | 1.12 | 28.43 |
| 10-bounded-repeat/letters-ru | 3475 | 428.66 ± 1.1% | not timed | not timed | 408.98 ± 0.0% | 19.68 ± 4.4% | not timed | not timed | 428.03 ± 0.3% | | 1.00 | 1.05 | 21.78 |
| 10-bounded-repeat/context | 53 | 69.73 ± 2.0% | not timed | not timed | 55.49 ± 1.7% | 16.92 ± 3.6% | not timed | not timed | 70.68 ± 1.9% | | 0.99 | 1.26 | 4.12 |
| 10-bounded-repeat/capitals | 11 | 559.47 ± 8.2% | not timed | not timed | 533.29 ± 0.1% | 30.99 ± 0.4% | not timed | not timed | 556.98 ± 8.4% | | 1.00 | 1.05 | 18.06 |
| 11-unstructured-to-json/extract | 600 | 37.76 ± 0.3% | not timed | not timed | 60.95 ± 0.7% | 38.99 ± 4.9% | not timed | not timed | 37.73 ± 0.3% | | 1.00 | 0.62 | 0.97 |
| 12-dictionary/single | 1 | 460.12 ± 2.0% | not timed | not timed | 442.18 ± 0.6% | 0.32 ± 8.4% | not timed | not timed | 462.96 ± 1.9% | | 0.99 | 1.04 | 1424.55 |
| 14-quadratic/1x | 100 | 22.01 ± 7.9% | not timed | not timed | 9.05 ± 0.5% | 0.80 ± 10.9% | not timed | not timed | 22.16 ± 19.7% | | 0.99 | 2.43 | 27.60 |
| 14-quadratic/2x | 200 | 20.03 ± 8.9% | not timed | not timed | 4.92 ± 0.1% | 0.43 ± 4.9% | not timed | not timed | 20.04 ± 1.1% | | 1.00 | 4.07 | 46.64 |
| 14-quadratic/10x | 1000 | 11.61 ± 2.6% | not timed | not timed | 1.05 ± 0.2% | 0.09 ± 4.2% | not timed | not timed | 11.63 ± 0.9% | | 1.00 | 11.04 | 124.74 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.02 ± 2.0% | not timed | not timed | 0.38 ± 0.6% | 0.47 ± 3.0% | not timed | not timed | 1.03 ± 3.2% | | 1.00 | 2.68 | 2.16 |
| 04-ruff-noqa/compile-real | 1 | 93.19 ± 0.8% | not timed | not timed | 12.99 ± 0.5% | 122.99 ± 1.2% | not timed | not timed | 93.62 ± 0.8% | | 1.00 | 7.17 | 0.76 |
| 05-lexer-veryl/compile-single | 1 | 11.80 ± 1.5% | not timed | not timed | 2.39 ± 1.0% | 5.84 ± 3.8% | not timed | not timed | 11.87 ± 0.8% | | 0.99 | 4.94 | 2.02 |
| 07-unicode-character-data/compile | 1 | 93.34 ± 1.2% | not timed | not timed | 24.40 ± 0.6% | 32.03 ± 3.4% | not timed | not timed | 93.52 ± 0.9% | | 1.00 | 3.83 | 2.91 |
| 09-aws-keys/compile-full | 1 | 42.77 ± 0.2% | not timed | not timed | 7.39 ± 0.3% | 20.24 ± 4.4% | not timed | not timed | 42.73 ± 1.3% | | 1.00 | 5.79 | 2.11 |
| 09-aws-keys/compile-quick | 1 | 150.37 ± 0.2% | not timed | not timed | 44.74 ± 1.0% | 115.56 ± 2.0% | not timed | not timed | 150.74 ± 0.9% | | 1.00 | 3.36 | 1.30 |
| 10-bounded-repeat/compile-context | 1 | 49.17 ± 8.0% | not timed | not timed | 11.49 ± 0.6% | 14.84 ± 2.8% | not timed | not timed | 49.28 ± 0.7% | | 1.00 | 4.28 | 3.31 |
| 10-bounded-repeat/compile-capitals | 1 | 72.83 ± 20.6% | not timed | not timed | 8.71 ± 0.7% | 21.97 ± 1.5% | not timed | not timed | 72.68 ± 0.4% | | 1.00 | 8.36 | 3.32 |
| 11-unstructured-to-json/compile | 1 | 142.95 ± 1.4% | not timed | not timed | 36.63 ± 1.0% | 59.73 ± 18.9% | not timed | not timed | 143.39 ± 15.1% | | 1.00 | 3.90 | 2.39 |
| 12-dictionary/compile-single | 1 | 0.27 ± 18.0% | not timed | not timed | 0.07 ± 1.2% | 0.09 ± 15.2% | not timed | not timed | 0.28 ± 2.2% | | 0.96 | 4.03 | 3.15 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 5.24 ± 15.3% | not timed | not timed | 5.39 ± 0.8% | 0.52 ± 0.9% | not timed | not timed | 5.30 ± 1.0% | | 0.99 | 0.97 | 10.12 |
| dictionary/search/english-10 | 690 | 148.39 ± 2.2% | not timed | not timed | 108.67 ± 0.9% | 0.00 ± 0.7% | not timed | not timed | 151.19 ± 0.7% | | 0.98 | 1.37 | 32319.82 |
| dictionary/search/english-15 | 15 | 461.17 ± 2.0% | not timed | not timed | 441.04 ± 2.2% | 0.29 ± 0.7% | not timed | not timed | 463.39 ± 1.9% | | 1.00 | 1.05 | 1599.87 |
| folly/awyer-inn-busted | 1 | 18829.69 ± 0.4% | not timed | not timed | 113.14 ± 0.7% | 37.29 ± 1.5% | not timed | not timed | 18841.02 ± 0.7% | | 1.00 | 166.43 | 504.91 |
| folly/literal-never-match-rare | 0 | 54784.93 ± 1.6% | not timed | not timed | 40114.45 ± 1.8% | 56175.67 ± 1.1% | not timed | not timed | 54944.54 ± 1.5% | | 1.00 | 1.37 | 0.98 |
| folly/literal-never-match-frequent | 0 | 18899.68 ± 1.4% | not timed | not timed | 39778.77 ± 0.5% | 2083.09 ± 0.2% | not timed | not timed | 18993.45 ± 1.6% | | 1.00 | 0.48 | 9.07 |
| folly/literal-never-match-tricksy | 1 | 3227.89 ± 5.7% | not timed | not timed | 4757.23 ± 2.2% | 1509.76 ± 0.4% | not timed | not timed | 3238.42 ± 0.7% | | 1.00 | 0.68 | 2.14 |
| grep/every-line | 239963 | 1217.01 ± 31.5% | not timed | not timed | 788.76 ± 0.3% | 279.52 ± 41.8% | not timed | not timed | 1219.65 ± 0.5% | | 1.00 | 1.54 | 4.35 |
| grep/long-words-ascii | 5073 | 435.45 ± 1.9% | not timed | not timed | 397.84 ± 12.0% | 37.71 ± 7.6% | not timed | not timed | 434.00 ± 11.5% | | 1.00 | 1.09 | 11.55 |
| imported/leipzig/twain | 811 | 32062.77 ± 19.8% | not timed | not timed | 28658.13 ± 13.9% | 9592.12 ± 3.6% | not timed | not timed | 31266.32 ± 18.1% | | 1.03 | 1.12 | 3.34 |
| imported/leipzig/twain-insensitive | 965 | 12251.74 ± 2.7% | not timed | not timed | 10887.22 ± 1.0% | 35.27 ± 3.4% | not timed | not timed | 12163.39 ± 2.0% | | 1.01 | 1.13 | 347.32 |
| imported/leipzig/shing | 1540 | 21072.89 ± 7.6% | not timed | not timed | 17665.76 ± 8.8% | 29.73 ± 2.3% | not timed | not timed | 20483.03 ± 15.5% | | 1.03 | 1.19 | 708.89 |
| imported/leipzig/huck-saw | 262 | 18727.85 ± 23.7% | not timed | not timed | 14793.44 ± 10.0% | 27.33 ± 2.8% | not timed | not timed | 18633.68 ± 18.7% | | 1.01 | 1.27 | 685.18 |
| imported/leipzig/word-ending-nn | 262 | 527.86 ± 1.0% | not timed | not timed | 531.80 ± 0.2% | 21.54 ± 0.4% | not timed | not timed | 531.69 ± 0.5% | | 0.99 | 0.99 | 24.51 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 8864.25 ± 30.1% | not timed | not timed | 3101.96 ± 1.8% | 9.66 ± 1.5% | not timed | not timed | 8734.01 ± 5.5% | | 1.01 | 2.86 | 917.20 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 16763.69 ± 3.0% | not timed | not timed | 14029.83 ± 3.1% | 15.07 ± 2.5% | not timed | not timed | 16668.91 ± 1.4% | | 1.01 | 1.19 | 1112.41 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4963.99 ± 0.4% | not timed | not timed | 704.74 ± 0.3% | 9.44 ± 0.6% | not timed | not timed | 4967.29 ± 3.7% | | 1.00 | 7.04 | 525.68 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 13677.76 ± 3.3% | not timed | not timed | 530.12 ± 0.1% | 9.89 ± 0.2% | not timed | not timed | 13465.62 ± 3.7% | | 1.02 | 25.80 | 1383.42 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 12224.15 ± 13.6% | not timed | not timed | 530.52 ± 1.3% | 8.52 ± 0.9% | not timed | not timed | 12633.77 ± 6.4% | | 0.97 | 23.04 | 1434.25 |
| imported/leipzig/tom-river | 2 | 10536.50 ± 5.5% | not timed | not timed | 10881.47 ± 4.0% | 26.75 ± 2.8% | not timed | not timed | 10401.82 ± 4.9% | | 1.01 | 0.97 | 393.88 |
| imported/leipzig/ing | 78424 | 521.34 ± 0.8% | not timed | not timed | 492.02 ± 0.7% | 24.23 ± 3.4% | not timed | not timed | 518.33 ± 0.9% | | 1.01 | 1.06 | 21.51 |
| imported/leipzig/ing-whitespace | 55248 | 1527.29 ± 0.7% | not timed | not timed | 1881.65 ± 0.6% | 17.75 ± 2.3% | not timed | not timed | 1530.65 ± 1.1% | | 1.00 | 0.81 | 86.03 |
| imported/leipzig/awyer-inn | 209 | 8878.05 ± 2.0% | not timed | not timed | 11245.50 ± 1.1% | 19.24 ± 2.1% | not timed | not timed | 8918.43 ± 1.0% | | 1.00 | 0.79 | 461.53 |
| imported/leipzig/quotes-bounded | 8886 | 2026.95 ± 0.5% | not timed | not timed | 2825.66 ± 0.7% | 31.97 ± 3.0% | not timed | not timed | 2030.42 ± 0.3% | | 1.00 | 0.72 | 63.41 |
| imported/leipzig/non-ascii-alternate | 2 | 30046.89 ± 1.5% | not timed | not timed | 16468.73 ± 0.7% | 42.65 ± 4.2% | not timed | not timed | 30055.66 ± 2.7% | | 1.00 | 1.82 | 704.53 |
| imported/leipzig/math-symbols | 69 | 2122.89 ± 0.7% | not timed | not timed | 532.75 ± 0.3% | 31.33 ± 3.1% | not timed | not timed | 2127.26 ± 4.5% | | 1.00 | 3.98 | 67.75 |
| imported/leipzig/bounded-strings-ending-z | 0 | 533.35 ± 0.9% | not timed | not timed | 532.30 ± 0.4% | 20.09 ± 0.4% | not timed | not timed | 533.90 ± 13.8% | | 1.00 | 1.00 | 26.55 |
| imported/lh3lh3-reb/uri | 17549 | 659.43 ± 1.1% | not timed | not timed | 883.39 ± 0.8% | 23.98 ± 2.7% | not timed | not timed | 662.37 ± 0.5% | | 1.00 | 0.75 | 27.50 |
| imported/lh3lh3-reb/email | 15057 | 655.41 ± 0.6% | not timed | not timed | 915.81 ± 0.5% | 25.74 ± 1.1% | not timed | not timed | 660.34 ± 1.1% | | 0.99 | 0.72 | 25.47 |
| imported/lh3lh3-reb/date | 668 | 795.31 ± 27.6% | not timed | not timed | 815.10 ± 1.4% | 43.81 ± 4.6% | not timed | not timed | 800.28 ± 0.6% | | 0.99 | 0.98 | 18.15 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 615.22 ± 0.5% | not timed | not timed | 371.61 ± 2.3% | 12.75 ± 1.7% | not timed | not timed | 620.23 ± 1.3% | | 0.99 | 1.66 | 48.27 |
| imported/mariomka/email | 92 | 28265.17 ± 7.5% | not timed | not timed | 42560.32 ± 1.2% | 28.16 ± 1.8% | not timed | not timed | 28720.53 ± 6.1% | | 0.98 | 0.66 | 1003.57 |
| imported/mariomka/uri | 5301 | 5315.97 ± 2.7% | not timed | not timed | 6367.76 ± 23.9% | 28.41 ± 9.7% | not timed | not timed | 5255.35 ± 9.1% | | 1.01 | 0.83 | 187.14 |
| imported/mariomka/ip | 5 | 2170.63 ± 3.0% | not timed | not timed | 2032.18 ± 0.5% | 17.88 ± 2.1% | not timed | not timed | 2168.49 ± 3.2% | | 1.00 | 1.07 | 121.39 |
| imported/rsc/no-exponential | 0 | 664.08 ± 0.5% | not timed | not timed | 332.41 ± 0.1% | 18.82 ± 7.8% | not timed | not timed | 673.78 ± 1.0% | | 0.99 | 2.00 | 35.28 |
| imported/rsc/literal | 1 | 1473.32 ± 3.0% | not timed | not timed | 1742.82 ± 0.4% | 166.14 ± 13.6% | not timed | not timed | 1470.83 ± 1.5% | | 1.00 | 0.85 | 8.87 |
| imported/rsc/not-literal | 2 | 731.75 ± 4.1% | not timed | not timed | 708.35 ± 1.3% | 40.07 ± 5.9% | not timed | not timed | 727.90 ± 0.4% | | 1.01 | 1.03 | 18.26 |
| imported/rsc/match-class | 1 | 1452.53 ± 2.0% | not timed | not timed | 1509.37 ± 0.4% | 50.17 ± 0.9% | not timed | not timed | 1464.71 ± 0.5% | | 0.99 | 0.96 | 28.95 |
| imported/rsc/match-class-in-range | 1 | 1454.89 ± 0.7% | not timed | not timed | 2714.52 ± 21.9% | 51.47 ± 2.8% | not timed | not timed | 1461.69 ± 11.0% | | 1.00 | 0.54 | 28.27 |
| imported/rsc/match-class-unicode | 1 | 482.05 ± 0.2% | not timed | not timed | 457.63 ± 0.4% | 62.11 ± 0.9% | not timed | not timed | 480.62 ± 3.3% | | 1.00 | 1.05 | 7.76 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1244.18 ± 33.8% | not timed | not timed | 895.90 ± 5.5% | 263.12 ± 2.7% | not timed | not timed | 1244.68 ± 0.2% | | 1.00 | 1.39 | 4.73 |
| imported/rsc/anchored-literal-long-non-match | 0 | 18642.66 ± 1.2% | not timed | not timed | 13444.70 ± 0.4% | 3935.00 ± 2.4% | not timed | not timed | 18694.22 ± 0.3% | | 1.00 | 1.39 | 4.74 |
| imported/rsc/anchored-literal-short-match | 4 | 642.71 ± 14.1% | not timed | not timed | 498.03 ± 0.5% | 80.67 ± 23.5% | not timed | not timed | 639.60 ± 8.0% | | 1.00 | 1.29 | 7.97 |
| imported/rsc/anchored-literal-long-match | 4 | 9749.75 ± 2.2% | not timed | not timed | 7434.41 ± 0.9% | 1184.87 ± 22.1% | not timed | not timed | 9616.18 ± 2.2% | | 1.01 | 1.31 | 8.23 |
| imported/rsc/one-pass-short | 17 | 314.98 ± 2.5% | not timed | not timed | 219.07 ± 0.5% | 27.09 ± 10.8% | not timed | not timed | 316.83 ± 3.3% | | 0.99 | 1.44 | 11.63 |
| imported/rsc/one-pass-short-not | 17 | 240.82 ± 1.8% | not timed | not timed | 226.26 ± 6.6% | 22.21 ± 22.6% | not timed | not timed | 241.44 ± 41.6% | | 1.00 | 1.06 | 10.84 |
| imported/rsc/one-pass-long-prefix | 26 | 339.31 ± 1.5% | not timed | not timed | 280.10 ± 0.3% | 91.18 ± 16.1% | not timed | not timed | 317.47 ± 10.6% | | 1.07 | 1.21 | 3.72 |
| imported/rsc/one-pass-long-prefix-not | 26 | 316.70 ± 13.1% | not timed | not timed | 280.00 ± 0.8% | 64.98 ± 20.1% | not timed | not timed | 337.67 ± 1.7% | | 0.94 | 1.13 | 4.87 |
| imported/rsc/long-needle1 | 31 | 54848.92 ± 0.8% | not timed | not timed | 39620.02 ± 20.0% | 3.32 ± 0.7% | not timed | not timed | 55059.40 ± 0.5% | | 1.00 | 1.38 | 16539.68 |
| imported/rsc/long-needle2 | 31 | 55870.63 ± 24.1% | not timed | not timed | 171.77 ± 0.3% | 3.32 ± 0.2% | not timed | not timed | 55996.72 ± 1.1% | | 1.00 | 325.26 | 16817.85 |
| imported/rsc/easy0-32 | 26 | 1564.37 ± 19.8% | not timed | not timed | 1504.94 ± 0.8% | 127.82 ± 19.3% | not timed | not timed | 1577.67 ± 0.4% | | 0.99 | 1.04 | 12.24 |
| imported/rsc/easy0-1k | 26 | 13137.00 ± 1.4% | not timed | not timed | 16166.46 ± 23.3% | 1852.86 ± 6.1% | not timed | not timed | 13157.47 ± 1.8% | | 1.00 | 0.81 | 7.09 |
| imported/rsc/easy0-32k | 26 | 52038.00 ± 0.2% | not timed | not timed | 38265.49 ± 1.0% | 20744.20 ± 31.3% | not timed | not timed | 51611.71 ± 1.4% | | 1.01 | 1.36 | 2.51 |
| imported/rsc/easy0-1mb | 26 | 54614.53 ± 2.2% | not timed | not timed | 40130.04 ± 32.6% | 56652.31 ± 15.0% | not timed | not timed | 54657.09 ± 0.7% | | 1.00 | 1.36 | 0.96 |
| imported/rsc/easy1-32 | 19 | 724.26 ± 1.6% | not timed | not timed | 642.07 ± 6.3% | 117.47 ± 20.8% | not timed | not timed | 743.79 ± 3.4% | | 0.97 | 1.13 | 6.17 |
| imported/rsc/easy1-1k | 19 | 14880.79 ± 1.2% | not timed | not timed | 13004.28 ± 7.2% | 1906.16 ± 13.5% | not timed | not timed | 15211.50 ± 2.9% | | 0.98 | 1.14 | 7.81 |
| imported/rsc/easy1-32k | 19 | 467942.62 ± 0.6% | not timed | not timed | 414754.77 ± 0.8% | 22859.21 ± 3.3% | not timed | not timed | 477632.67 ± 14.2% | | 0.98 | 1.13 | 20.47 |
| imported/rsc/easy1-1mb | 19 | 14991341.76 ± 1.0% | not timed | not timed | 13352568.05 ± 7.4% | 54942.48 ± 14.0% | not timed | not timed | 15259071.12 ± 2.4% | | 0.98 | 1.12 | 272.86 |
| imported/rsc/medium-32 | 27 | 705.10 ± 1.3% | not timed | not timed | 626.06 ± 0.4% | 60.21 ± 10.9% | not timed | not timed | 702.85 ± 1.8% | | 1.00 | 1.13 | 11.71 |
| imported/rsc/medium-1k | 27 | 12571.83 ± 1.6% | not timed | not timed | 11202.67 ± 0.5% | 60.64 ± 0.2% | not timed | not timed | 12568.37 ± 0.8% | | 1.00 | 1.12 | 207.32 |
| imported/rsc/medium-32k | 27 | 392773.32 ± 0.7% | not timed | not timed | 349293.51 ± 0.5% | 41.26 ± 1.6% | not timed | not timed | 391589.34 ± 0.7% | | 1.00 | 1.12 | 9519.37 |
| imported/rsc/medium-1mb | 27 | 12109839.65 ± 0.4% | not timed | not timed | 11107449.52 ± 0.2% | 41.55 ± 23.2% | not timed | not timed | 12569487.58 ± 2.4% | | 0.96 | 1.09 | 291485.72 |
| imported/rsc/hard-32 | 58 | 366.80 ± 2.9% | not timed | not timed | 339.13 ± 0.2% | 41.37 ± 14.8% | not timed | not timed | 364.58 ± 1.4% | | 1.01 | 1.08 | 8.87 |
| imported/rsc/hard-1k | 27 | 11425.22 ± 0.7% | not timed | not timed | 11144.75 ± 1.6% | 33.51 ± 0.1% | not timed | not timed | 11393.80 ± 0.4% | | 1.00 | 1.03 | 340.95 |
| imported/rsc/hard-32k | 27 | 358021.26 ± 0.3% | not timed | not timed | 338295.03 ± 0.5% | 25.29 ± 0.9% | not timed | not timed | 355370.67 ± 0.3% | | 1.01 | 1.06 | 14158.09 |
| imported/rsc/hard-1mb | 51 | 7281283.13 ± 0.8% | not timed | not timed | 6784030.02 ± 18.8% | 25.46 ± 0.3% | not timed | not timed | 7221829.55 ± 6.2% | | 1.01 | 1.07 | 285979.75 |
| imported/rsc/reallyhard0-32 | 58 | 243.25 ± 0.3% | not timed | not timed | 214.38 ± 0.3% | 40.53 ± 7.5% | not timed | not timed | 236.60 ± 11.0% | | 1.03 | 1.13 | 6.00 |
| imported/rsc/reallyhard0-1k | 27 | 507.50 ± 3.9% | not timed | not timed | 510.76 ± 0.8% | 33.33 ± 1.3% | not timed | not timed | 515.91 ± 1.1% | | 0.98 | 0.99 | 15.23 |
| imported/rsc/reallyhard0-32k | 27 | 530.96 ± 0.6% | not timed | not timed | 531.30 ± 0.3% | 25.11 ± 31.0% | not timed | not timed | 531.45 ± 0.4% | | 1.00 | 1.00 | 21.15 |
| imported/rsc/reallyhard0-1mb | 51 | 531.04 ± 2.2% | not timed | not timed | 532.77 ± 1.4% | 25.21 ± 40.7% | not timed | not timed | 527.84 ± 1.9% | | 1.01 | 1.00 | 21.07 |
| imported/rsc/reallyreallyhard0-32 | 47 | 264.52 ± 3.6% | not timed | not timed | 183.43 ± 2.2% | 49.79 ± 12.3% | not timed | not timed | 264.58 ± 3.6% | | 1.00 | 1.44 | 5.31 |
| imported/rsc/reallyreallyhard0-1k | 16 | 5942.30 ± 0.9% | not timed | not timed | 6426.26 ± 0.6% | 28.15 ± 40.3% | not timed | not timed | 5943.86 ± 0.6% | | 1.00 | 0.92 | 211.06 |
| imported/rsc/reallyreallyhard0-32k | 16 | 43422.93 ± 25.5% | not timed | not timed | 32439.83 ± 0.7% | 20.83 ± 0.9% | not timed | not timed | 43582.41 ± 0.3% | | 1.00 | 1.34 | 2084.37 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 54729.25 ± 1.8% | not timed | not timed | 39445.19 ± 0.5% | 20.85 ± 0.4% | not timed | not timed | 54915.65 ± 2.4% | | 1.00 | 1.39 | 2624.53 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 255.54 ± 2.4% | not timed | not timed | 189.74 ± 4.9% | 51.05 ± 9.8% | not timed | not timed | 257.16 ± 2.2% | | 0.99 | 1.35 | 5.01 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5248.16 ± 0.5% | not timed | not timed | 6603.10 ± 0.4% | 28.20 ± 0.7% | not timed | not timed | 5260.93 ± 1.0% | | 1.00 | 0.79 | 186.09 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 41028.29 ± 0.5% | not timed | not timed | 33039.81 ± 0.8% | 20.98 ± 0.7% | not timed | not timed | 41009.48 ± 23.5% | | 1.00 | 1.24 | 1955.98 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 53568.39 ± 17.6% | not timed | not timed | 39468.65 ± 1.0% | 20.89 ± 1.1% | not timed | not timed | 53922.56 ± 0.9% | | 0.99 | 1.36 | 2564.02 |
| imported/sherlock/name-sherlock | 776 | 35655.12 ± 2.5% | not timed | not timed | 31652.64 ± 21.1% | 9467.98 ± 24.9% | not timed | not timed | 35549.67 ± 6.8% | | 1.00 | 1.13 | 3.77 |
| imported/sherlock/name-holmes | 2766 | 16216.89 ± 1.9% | not timed | not timed | 18497.33 ± 0.5% | 3031.08 ± 0.9% | not timed | not timed | 16216.00 ± 12.1% | | 1.00 | 0.88 | 5.35 |
| imported/sherlock/name-sherlock-holmes | 1365 | 36123.12 ± 21.5% | not timed | not timed | 32107.21 ± 1.0% | 7439.62 ± 31.1% | not timed | not timed | 35818.84 ± 2.1% | | 1.01 | 1.13 | 4.86 |
| imported/sherlock/name-sherlock-casei | 816 | 30482.28 ± 0.3% | not timed | not timed | 9441.02 ± 0.6% | 28.73 ± 0.6% | not timed | not timed | 30227.32 ± 2.9% | | 1.01 | 3.23 | 1061.03 |
| imported/sherlock/name-holmes-casei | 2802 | 14933.29 ± 0.7% | not timed | not timed | 5875.85 ± 0.5% | 35.35 ± 8.8% | not timed | not timed | 14767.32 ± 1.3% | | 1.01 | 2.54 | 422.39 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 26925.05 ± 0.6% | not timed | not timed | 9080.93 ± 0.6% | 28.67 ± 0.6% | not timed | not timed | 26808.30 ± 2.5% | | 1.00 | 2.97 | 939.03 |
| imported/sherlock/name-whitespace | 1461 | 21508.71 ± 2.8% | not timed | not timed | 22605.10 ± 0.5% | 6019.92 ± 13.8% | not timed | not timed | 21470.40 ± 2.1% | | 1.00 | 0.95 | 3.57 |
| imported/sherlock/name-alt1 | 1142 | 20919.09 ± 9.5% | not timed | not timed | 22563.61 ± 1.2% | 3747.00 ± 9.2% | not timed | not timed | 20861.54 ± 0.6% | | 1.00 | 0.93 | 5.58 |
| imported/sherlock/name-alt2 | 3542 | 12365.48 ± 2.2% | not timed | not timed | 7748.19 ± 0.4% | 27.18 ± 3.5% | not timed | not timed | 12511.71 ± 22.9% | | 0.99 | 1.60 | 454.92 |
| imported/sherlock/name-alt3 | 4507 | 8577.45 ± 3.8% | not timed | not timed | 6951.27 ± 0.3% | 8.71 ± 0.6% | not timed | not timed | 8523.92 ± 1.2% | | 1.01 | 1.23 | 984.48 |
| imported/sherlock/name-alt3-casei | 4593 | 1576.74 ± 6.7% | not timed | not timed | 1084.93 ± 3.0% | 5.67 ± 14.3% | not timed | not timed | 1592.85 ± 0.9% | | 0.99 | 1.45 | 277.87 |
| imported/sherlock/name-alt4 | 3686 | 7238.73 ± 0.4% | not timed | not timed | 5969.70 ± 4.9% | 27.14 ± 1.6% | not timed | not timed | 7137.72 ± 7.1% | | 1.01 | 1.21 | 266.68 |
| imported/sherlock/name-alt4-casei | 4254 | 3191.63 ± 0.8% | not timed | not timed | 3129.60 ± 7.2% | 16.67 ± 8.1% | not timed | not timed | 3183.91 ± 10.3% | | 1.00 | 1.02 | 191.41 |
| imported/sherlock/name-alt5 | 4028 | 10502.36 ± 1.8% | not timed | not timed | 7351.88 ± 6.5% | 19.37 ± 2.0% | not timed | not timed | 10501.77 ± 1.1% | | 1.00 | 1.43 | 542.28 |
| imported/sherlock/name-alt5-casei | 4104 | 4828.09 ± 2.1% | not timed | not timed | 2389.03 ± 0.2% | 12.29 ± 0.4% | not timed | not timed | 4796.93 ± 2.8% | | 1.01 | 2.02 | 392.84 |
| imported/sherlock/no-match-uncommon | 0 | 53861.79 ± 1.7% | not timed | not timed | 49963.05 ± 1.1% | 44530.34 ± 1.2% | not timed | not timed | 54330.51 ± 1.4% | | 0.99 | 1.08 | 1.21 |
| imported/sherlock/no-match-common | 0 | 52378.04 ± 2.3% | not timed | not timed | 49521.71 ± 1.0% | 1570.56 ± 0.3% | not timed | not timed | 52758.45 ± 1.7% | | 0.99 | 1.06 | 33.35 |
| imported/sherlock/no-match-really-common | 0 | 33091.21 ± 2.8% | not timed | not timed | 30817.09 ± 2.0% | 1572.30 ± 0.5% | not timed | not timed | 33125.14 ± 0.8% | | 1.00 | 1.07 | 21.05 |
| imported/sherlock/the-lower | 21654 | 2061.31 ± 0.5% | not timed | not timed | 2191.11 ± 0.9% | 223.80 ± 15.2% | not timed | not timed | 2031.58 ± 2.3% | | 1.01 | 0.94 | 9.21 |
| imported/sherlock/the-upper | 2223 | 11644.05 ± 1.3% | not timed | not timed | 18879.52 ± 0.9% | 2529.83 ± 3.3% | not timed | not timed | 11599.49 ± 1.3% | | 1.00 | 0.62 | 4.60 |
| imported/sherlock/the-casei | 23961 | 1923.31 ± 1.4% | not timed | not timed | 1085.87 ± 0.4% | 32.27 ± 35.4% | not timed | not timed | 1885.66 ± 1.6% | | 1.02 | 1.77 | 59.60 |
| imported/sherlock/everything-greedy | 581881 | 245.45 ± 3.5% | not timed | not timed | 143.95 ± 0.8% | 23.99 ± 16.8% | not timed | not timed | 244.20 ± 0.6% | | 1.01 | 1.71 | 10.23 |
| imported/sherlock/everything-greedy-nl | 594933 | 445.40 ± 0.3% | not timed | not timed | 186.96 ± 1.1% | 27.17 ± 0.4% | not timed | not timed | 444.78 ± 0.7% | | 1.00 | 2.38 | 16.40 |
| imported/sherlock/letters | 447175 | 54.57 ± 10.1% | not timed | not timed | 29.09 ± 0.2% | 4.58 ± 24.0% | not timed | not timed | 52.33 ± 2.6% | | 1.04 | 1.88 | 11.91 |
| imported/sherlock/letters-upper | 14180 | 388.77 ± 1.1% | not timed | not timed | 316.89 ± 0.5% | 24.99 ± 23.4% | not timed | not timed | 386.96 ± 0.3% | | 1.00 | 1.23 | 15.56 |
| imported/sherlock/letters-lower | 432995 | 55.46 ± 0.8% | not timed | not timed | 29.52 ± 0.7% | 4.92 ± 23.1% | not timed | not timed | 54.58 ± 21.6% | | 1.02 | 1.88 | 11.27 |
| imported/sherlock/words | 447639 | 94.87 ± 0.8% | not timed | not timed | 72.40 ± 0.6% | 10.95 ± 48.1% | not timed | not timed | 92.72 ± 0.7% | | 1.02 | 1.31 | 8.66 |
| imported/sherlock/before-holmes | 4073 | 9613.26 ± 1.6% | not timed | not timed | 9794.36 ± 0.3% | 20.32 ± 1.3% | not timed | not timed | 9594.78 ± 1.0% | | 1.00 | 0.98 | 473.01 |
| imported/sherlock/before-after-holmes | 2593 | 9459.32 ± 0.7% | not timed | not timed | 10885.82 ± 1.2% | 20.32 ± 1.1% | not timed | not timed | 9491.41 ± 1.3% | | 1.00 | 0.87 | 465.50 |
| imported/sherlock/holmes-cochar-watson | 150 | 7236.13 ± 1.7% | not timed | not timed | 5866.87 ± 1.6% | 26.37 ± 3.8% | not timed | not timed | 7246.12 ± 1.6% | | 1.00 | 1.23 | 274.42 |
| imported/sherlock/holmes-coword-watson | 14309 | 1119.66 ± 1.3% | not timed | not timed | 1073.94 ± 0.8% | 5.70 ± 0.4% | not timed | not timed | 1118.52 ± 0.3% | | 1.00 | 1.04 | 196.26 |
| imported/sherlock/quotes | 14437 | 1278.71 ± 18.7% | not timed | not timed | 1551.35 ± 0.2% | 29.31 ± 0.6% | not timed | not timed | 1277.82 ± 0.5% | | 1.00 | 0.82 | 43.63 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 26201.26 ± 12.1% | not timed | not timed | 25120.34 ± 1.1% | 31.81 ± 0.6% | not timed | not timed | 26292.28 ± 1.1% | | 1.00 | 1.04 | 823.76 |
| imported/sherlock/word-ending-n | 35297 | 408.47 ± 0.2% | not timed | not timed | 350.91 ± 7.6% | 20.41 ± 20.6% | not timed | not timed | 400.43 ± 0.2% | | 1.02 | 1.16 | 20.01 |
| imported/sherlock/repeated-class-negation | 2130 | 10957.69 ± 5.0% | not timed | not timed | 12015.13 ± 1.1% | 9.76 ± 1.3% | not timed | not timed | 10658.72 ± 14.9% | | 1.03 | 0.91 | 1122.88 |
| imported/sherlock/ing-suffix | 20547 | 488.84 ± 1.6% | not timed | not timed | 445.72 ± 0.1% | 24.55 ± 25.4% | not timed | not timed | 485.70 ± 0.8% | | 1.01 | 1.10 | 19.91 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1314.51 ± 0.6% | not timed | not timed | 1898.49 ± 0.5% | 17.83 ± 0.7% | not timed | not timed | 1307.93 ± 0.8% | | 1.01 | 0.69 | 73.74 |
| opt/accelerate/whole-line | 239963 | 438.68 ± 1.8% | not timed | not timed | 342.29 ± 1.2% | 75.12 ± 18.2% | not timed | not timed | 436.91 ± 28.5% | | 1.00 | 1.28 | 5.84 |
| opt/accelerate/non-dna | 16745 | 383.94 ± 0.6% | not timed | not timed | 368.17 ± 0.6% | 22.12 ± 17.2% | not timed | not timed | 383.24 ± 0.5% | | 1.00 | 1.04 | 17.36 |
| opt/backtrack/words-english | 40536 | 106.41 ± 0.7% | not timed | not timed | 84.85 ± 2.0% | 15.95 ± 9.0% | not timed | not timed | 105.18 ± 17.7% | | 1.01 | 1.25 | 6.67 |
| opt/fixed-length/too-small-ascii | 0 | 296.19 ± 0.3% | not timed | not timed | 622.07 ± 40.8% | 98.51 ± 2.4% | not timed | not timed | 295.91 ± 0.3% | | 1.00 | 0.48 | 3.01 |
| opt/fixed-length/too-big-ascii | 0 | 3274.57 ± 0.7% | not timed | not timed | 4918.85 ± 28.6% | 114.95 ± 5.3% | not timed | not timed | 3273.66 ± 0.2% | | 1.00 | 0.67 | 28.49 |
| opt/fixed-length/go33484-1 | 0 | 628850.76 ± 7.2% | not timed | not timed | 944110.42 ± 24.5% | 65150.70 ± 1.8% | not timed | not timed | 628977.85 ± 0.2% | | 1.00 | 0.67 | 9.65 |
| opt/fixed-length/go33484-2 | 0 | 628381.20 ± 0.3% | not timed | not timed | 945464.59 ± 0.6% | 23913.50 ± 1.1% | not timed | not timed | 628738.81 ± 31.5% | | 1.00 | 0.66 | 26.28 |
| opt/fixed-length/go33484-3 | 0 | 62821.50 ± 0.8% | not timed | not timed | 94484.65 ± 1.1% | 741.48 ± 34.1% | not timed | not timed | 62889.58 ± 1.0% | | 1.00 | 0.66 | 84.72 |
| opt/literal-alt/one-pattern | 1 | 486.57 ± 7.0% | not timed | not timed | 483.46 ± 0.4% | 0.32 ± 9.0% | not timed | not timed | 486.32 ± 2.8% | | 1.00 | 1.01 | 1542.53 |
| opt/onepass/fn-predicate | 916 | 332.79 ± 6.5% | not timed | not timed | 329.51 ± 0.7% | 162.61 ± 43.9% | not timed | not timed | 332.96 ± 0.6% | | 1.00 | 1.01 | 2.05 |
| opt/onepass/first-three-words-english | 35128 | 126.39 ± 3.6% | not timed | not timed | 190.11 ± 1.6% | 57.53 ± 13.3% | not timed | not timed | 127.07 ± 0.4% | | 0.99 | 0.66 | 2.20 |
| opt/prefilter/literal-english | 1 | 53858.54 ± 1.8% | not timed | not timed | 39688.27 ± 3.6% | 19432.38 ± 0.8% | not timed | not timed | 53887.77 ± 2.1% | | 1.00 | 1.36 | 2.77 |
| opt/prefilter/literal-casei-english | 1 | 34977.34 ± 1.2% | not timed | not timed | 11872.02 ± 0.5% | 28.94 ± 0.6% | not timed | not timed | 34826.31 ± 1.5% | | 1.00 | 2.95 | 1208.73 |
| opt/prefilter/literal-russian | 1 | 54413.37 ± 1.6% | not timed | not timed | 40019.75 ± 2.1% | 1581.86 ± 20.6% | not timed | not timed | 54490.69 ± 1.1% | | 1.00 | 1.36 | 34.40 |
| opt/prefilter/literal-casei-russian | 1 | 22084.83 ± 21.1% | not timed | not timed | 8278.20 ± 0.9% | 30.69 ± 1.3% | not timed | not timed | 22074.59 ± 3.0% | | 1.00 | 2.67 | 719.64 |
| opt/prefilter/rust-functions | 948 | 11688.65 ± 1.1% | not timed | not timed | 10537.59 ± 1.6% | 1554.98 ± 0.2% | not timed | not timed | 11683.80 ± 31.3% | | 1.00 | 1.11 | 7.52 |
| opt/reverse-anchored/word-end | 1 | 28863551.61 ± 13.8% | not timed | not timed | 22707085.76 ± 0.7% | 41.85 ± 0.3% | not timed | not timed | 28691286.19 ± 0.3% | | 1.01 | 1.27 | 689645.25 |
| opt/reverse-inner/holmes | 2593 | 9510.33 ± 1.2% | not timed | not timed | 11125.92 ± 1.1% | 20.27 ± 19.7% | not timed | not timed | 9537.45 ± 1.2% | | 1.00 | 0.85 | 469.23 |
| opt/reverse-inner/email | 47 | 62087.61 ± 5.3% | not timed | not timed | 72510.11 ± 0.8% | 27.58 ± 9.8% | not timed | not timed | 64437.08 ± 7.9% | | 0.96 | 0.86 | 2250.91 |
| opt/reverse-inner/factored-prefix | 3542 | 523.19 ± 0.4% | not timed | not timed | 515.03 ± 0.4% | 11.10 ± 0.4% | not timed | not timed | 523.23 ± 0.4% | | 1.00 | 1.02 | 47.15 |
| opt/reverse-inner/no-quadratic-backward | 0 | 17901.49 ± 0.2% | not timed | not timed | 533.63 ± 0.1% | 63.21 ± 2.0% | not timed | not timed | 17885.10 ± 0.9% | | 1.00 | 33.55 | 283.22 |
| opt/reverse-inner/no-quadratic-forward | 0 | 619.89 ± 4.9% | not timed | not timed | 246.47 ± 3.4% | 20.96 ± 0.6% | not timed | not timed | 621.62 ± 5.9% | | 1.00 | 2.52 | 29.57 |
| opt/reverse-suffix/holmes | 4073 | 9619.35 ± 2.2% | not timed | not timed | 9756.68 ± 1.8% | 20.30 ± 0.7% | not timed | not timed | 9565.78 ± 5.9% | | 1.01 | 0.99 | 473.94 |
| opt/reverse-suffix/no-quadratic | 0 | 17912.12 ± 12.7% | not timed | not timed | 533.77 ± 0.7% | 63.10 ± 7.1% | not timed | not timed | 17902.50 ± 0.3% | | 1.00 | 33.56 | 283.86 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 110.34 ± 2.3% | not timed | not timed | 136.06 ± 0.5% | 12.02 ± 28.3% | not timed | not timed | 109.82 ± 22.0% | | 1.00 | 0.81 | 9.18 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 109.37 ± 2.2% | not timed | not timed | 136.26 ± 1.2% | 11.84 ± 12.4% | not timed | not timed | 109.94 ± 0.4% | | 0.99 | 0.80 | 9.23 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.27 ± 25.0% | not timed | not timed | 0.39 ± 0.6% | 92.94 ± 0.8% | not timed | not timed | 0.27 ± 0.7% | | 1.00 | 0.69 | 0.0029 |
| reported/i1095-word-repetition/ascii-search | 256 | 268.14 ± 0.5% | not timed | not timed | 245.80 ± 0.4% | 81.25 ± 0.4% | not timed | not timed | 265.35 ± 0.7% | | 1.01 | 1.09 | 3.30 |
| reported/i13-subset-regex/original-ascii | 4094 | 9020.59 ± 1.4% | not timed | not timed | 3260.01 ± 19.5% | 9.64 ± 3.0% | not timed | not timed | 8923.56 ± 7.0% | | 1.01 | 2.77 | 935.56 |
| reported/i13-subset-regex/original-unicode | 4094 | 8856.50 ± 5.9% | not timed | not timed | 170.62 ± 1.7% | 9.68 ± 0.9% | not timed | not timed | 8867.72 ± 3.4% | | 1.00 | 51.91 | 914.86 |
| reported/i13-subset-regex/big-ascii | 1955 | 8475.76 ± 2.1% | not timed | not timed | 43.48 ± 2.0% | 8.26 ± 1.2% | not timed | not timed | 8468.11 ± 0.9% | | 1.00 | 194.93 | 1026.30 |
| reported/i13-subset-regex/big-unicode | 1955 | 8455.79 ± 3.9% | not timed | not timed | 7.77 ± 55.2% | 8.19 ± 1.6% | not timed | not timed | 8339.63 ± 2.9% | | 1.01 | 1088.14 | 1032.60 |
| reported/i13-subset-regex/huge-ascii | 55 | 7961.42 ± 2.3% | not timed | not timed | 7.26 ± 1.0% | 7.32 ± 0.8% | not timed | not timed | 7973.21 ± 0.7% | | 1.00 | 1096.87 | 1087.47 |
| reported/i13-subset-regex/huge-unicode | 55 | 7873.04 ± 1.7% | not timed | not timed | 7.09 ± 2.1% | 7.28 ± 1.7% | not timed | not timed | 7827.73 ± 1.6% | | 1.01 | 1110.02 | 1081.18 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.07 ± 0.8% | not timed | not timed | 7.21 ± 1.3% | 7.21 ± 1.5% | not timed | not timed | 3.06 ± 1.0% | | 1.00 | 0.43 | 0.43 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.29 ± 1.1% | not timed | not timed | 7.13 ± 1.6% | 7.28 ± 1.1% | not timed | not timed | 4.29 ± 1.0% | | 1.00 | 0.60 | 0.59 |
| reported/i787-keywords/ascii | 5674 | 418.84 ± 0.6% | not timed | not timed | 118.70 ± 2.1% | 5.44 ± 10.9% | not timed | not timed | 417.40 ± 3.7% | | 1.00 | 3.53 | 76.95 |
| reported/i787-keywords/opt-ascii | 5674 | 418.67 ± 0.6% | not timed | not timed | 213.53 ± 0.3% | 9.02 ± 26.4% | not timed | not timed | 416.66 ± 2.8% | | 1.00 | 1.96 | 46.40 |
| slow/quadratic-regex-1x | 100 | 6.31 ± 0.3% | not timed | not timed | 4.63 ± 0.4% | 0.04 ± 0.6% | not timed | not timed | 6.30 ± 0.3% | | 1.00 | 1.36 | 149.21 |
| slow/quadratic-regex-2x | 199 | 2.97 ± 2.4% | not timed | not timed | 2.50 ± 4.0% | 0.01 ± 0.1% | not timed | not timed | 2.97 ± 0.6% | | 1.00 | 1.19 | 273.45 |
| slow/quadratic-haystack-1x | 100 | 22.16 ± 64.3% | not timed | not timed | 9.12 ± 5.5% | 0.83 ± 10.6% | not timed | not timed | 22.26 ± 1.1% | | 1.00 | 2.43 | 26.73 |
| slow/quadratic-haystack-2x | 200 | 19.98 ± 9.3% | not timed | not timed | 4.91 ± 0.2% | 0.44 ± 1.7% | not timed | not timed | 20.08 ± 0.4% | | 1.00 | 4.07 | 45.35 |
| unicode/codepoints/any-one | 1112064 | 267.43 ± 17.1% | not timed | not timed | 184.21 ± 0.2% | 15.29 ± 18.8% | not timed | not timed | 266.40 ± 16.2% | | 1.00 | 1.45 | 17.50 |
| unicode/codepoints/any-all | 4382592 | 234.67 ± 0.4% | not timed | not timed | 232.51 ± 1.9% | 99.08 ± 14.6% | not timed | not timed | 235.03 ± 0.3% | | 1.00 | 1.01 | 2.37 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 5.27 ± 0.6% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 530.80 ± 0.5% | not timed | not timed | 532.55 ± 0.3% | 114.44 ± 1.0% | not timed | not timed | 531.60 ± 0.1% | | 1.00 | 1.00 | 4.64 |
| unicode/overlapping-words/ascii | 6156 | 21.25 ± 4.9% | not timed | not timed | 33.83 ± 0.2% | 3.50 ± 0.5% | not timed | not timed | 21.22 ± 5.3% | | 1.00 | 0.63 | 6.07 |
| unicode/overlapping-words/english | 6156 | 1.15 ± 0.1% | not timed | not timed | 2.33 ± 10.5% | 2.18 ± 9.6% | not timed | not timed | 1.13 ± 4.2% | | 1.01 | 0.49 | 0.53 |
| unicode/overlapping-words/russian | 5710 | 1.04 ± 2.4% | not timed | not timed | 2.34 ± 0.8% | 5.14 ± 7.2% | not timed | not timed | 1.04 ± 1.3% | | 0.99 | 0.44 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 111.26 ± 0.8% | not timed | not timed | 73.94 ± 0.5% | 9.81 ± 26.6% | not timed | not timed | 109.52 ± 10.3% | | 1.02 | 1.50 | 11.34 |
| unicode/word/boundary-long-english | 3466 | 533.50 ± 0.3% | not timed | not timed | 521.34 ± 1.1% | 26.79 ± 0.2% | not timed | not timed | 532.88 ± 0.1% | | 1.00 | 1.02 | 19.92 |
| unicode/word/around-holmes-english | 27 | 41571.54 ± 3.2% | not timed | not timed | 38495.12 ± 1.0% | 18.58 ± 0.2% | not timed | not timed | 41804.52 ± 0.9% | | 0.99 | 1.08 | 2237.05 |
| wild/bibleref/long | 874 | 491.80 ± 0.3% | not timed | not timed | 499.55 ± 2.1% | 6.53 ± 2.5% | not timed | not timed | 492.99 ± 0.3% | | 1.00 | 0.98 | 75.30 |
| wild/bibleref/short | 30 | 16.30 ± 7.1% | not timed | not timed | 26.67 ± 0.7% | 13.45 ± 24.6% | not timed | not timed | 16.76 ± 6.2% | | 0.97 | 0.61 | 1.21 |
| wild/bibleref/line | 874 | 392.38 ± 2.4% | not timed | not timed | 217.43 ± 6.2% | 7.73 ± 0.3% | not timed | not timed | 390.52 ± 10.5% | | 1.00 | 1.80 | 50.74 |
| wild/caddy/caddy | 6 | 342.93 ± 46.9% | not timed | not timed | 243.97 ± 0.6% | 62.10 ± 14.4% | not timed | not timed | 345.12 ± 20.7% | | 0.99 | 1.41 | 5.52 |
| wild/dot-star-capture/rust-src-tools | 6 | 1275.22 ± 44.9% | not timed | not timed | 353.37 ± 0.7% | 11.51 ± 2.7% | not timed | not timed | 1279.12 ± 0.6% | | 1.00 | 3.61 | 110.83 |
| wild/ruff/noqa | 84 | 425.71 ± 0.2% | not timed | not timed | 431.95 ± 0.4% | 16.35 ± 4.2% | not timed | not timed | 424.72 ± 0.4% | | 1.00 | 0.99 | 26.04 |
| wild/ruff/unnecessary-coding-comment | 16 | 905.49 ± 0.3% | not timed | not timed | 602.05 ± 2.2% | 114.92 ± 13.2% | not timed | not timed | 904.28 ± 0.8% | | 1.00 | 1.50 | 7.88 |
| wild/ruff/string-quote-prefix | 2972 | 1279.72 ± 0.4% | not timed | not timed | 325.85 ± 0.2% | 285.85 ± 31.4% | not timed | not timed | 1273.39 ± 0.6% | | 1.00 | 3.93 | 4.48 |
| wild/ruff/space-around-operator | 1224378 | 185.34 ± 1.9% | not timed | not timed | 185.60 ± 6.3% | 15.29 ± 3.0% | not timed | not timed | 184.57 ± 1.1% | | 1.00 | 1.00 | 12.12 |
| wild/ruff/shebang | 282 | 897.43 ± 0.3% | not timed | not timed | 326.47 ± 0.4% | 94.32 ± 9.0% | not timed | not timed | 886.53 ± 0.4% | | 1.01 | 2.75 | 9.52 |
| wild/rustsec-cargo-audit/original-unix | 471 | 16827.55 ± 7.7% | not timed | not timed | 19807.34 ± 5.9% | 6302.19 ± 0.9% | not timed | not timed | 16938.31 ± 32.0% | | 0.99 | 0.85 | 2.67 |
| wild/rustsec-cargo-audit/original-windows | 462 | 15240.51 ± 1.2% | not timed | not timed | 18729.44 ± 1.4% | 5935.69 ± 1.1% | not timed | not timed | 15171.88 ± 1.7% | | 1.00 | 0.81 | 2.57 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 17023.80 ± 1.6% | not timed | not timed | 19363.42 ± 2.9% | 6036.97 ± 2.0% | not timed | not timed | 16777.77 ± 0.9% | | 1.01 | 0.88 | 2.82 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 13755.89 ± 0.9% | not timed | not timed | 19357.76 ± 1.2% | 6254.84 ± 40.5% | not timed | not timed | 13753.66 ± 8.6% | | 1.00 | 0.71 | 2.20 |
| wild/url/search | 234965 | 103.04 ± 17.6% | not timed | not timed | 49.68 ± 0.6% | 1.90 ± 3.7% | not timed | not timed | 102.56 ± 12.2% | | 1.00 | 2.07 | 54.32 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.02 ± 1.6% | not timed | not timed | 0.01 ± 2.0% | 0.01 ± 13.4% | not timed | not timed | 0.02 ± 67.0% | | 0.99 | 2.48 | 3.85 |
| dictionary/compile/english-15 | 1 | 0.28 ± 21.1% | not timed | not timed | 0.08 ± 0.8% | 0.09 ± 8.0% | not timed | not timed | 0.28 ± 0.4% | | 0.98 | 3.63 | 2.98 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.21 ± 1.3% | not timed | not timed | 0.02 ± 30.8% | 31.56 ± 7.2% | not timed | not timed | 0.21 ± 16.5% | | 0.99 | 11.54 | 0.0067 |
| reported/i1095-word-repetition/ascii-compile | 1 | 35.46 ± 3.2% | not timed | not timed | 13.36 ± 0.4% | 53.15 ± 24.7% | not timed | not timed | 35.48 ± 3.3% | | 1.00 | 2.65 | 0.67 |
| reported/i787-keywords/compile | 1 | 28.78 ± 27.0% | not timed | not timed | 1.97 ± 1.1% | 15.33 ± 31.3% | not timed | not timed | 29.34 ± 0.7% | | 0.98 | 14.65 | 1.88 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 268.12 ± 4.8% | not timed | not timed | 114.75 ± 0.4% | 496.07 ± 1.6% | not timed | not timed | 283.53 ± 5.7% | | 0.95 | 2.34 | 0.54 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 39.98 ± 2.5% | not timed | not timed | 4.26 ± 0.8% | 39.07 ± 3.9% | not timed | not timed | 40.88 ± 4.8% | | 0.98 | 9.39 | 1.02 |
| unicode/compile/one-letter | 53 | 5.40 ± 16.0% | not timed | not timed | 4.50 ± 2.4% | 54.40 ± 3.3% | not timed | not timed | 5.48 ± 1.7% | | 0.98 | 1.20 | 0.0993 |
| unicode/compile/fifty-letters | 1 | 0.91 ± 8.7% | not timed | not timed | 0.10 ± 2.8% | 54.61 ± 21.7% | not timed | not timed | 0.92 ± 3.7% | | 0.99 | 9.00 | 0.0167 |
| unicode/compile/fifty-letters-ascii | 1 | 154.54 ± 11.8% | not timed | not timed | 56.42 ± 18.1% | 175.52 ± 45.5% | not timed | not timed | 160.01 ± 16.4% | | 0.97 | 2.74 | 0.88 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 338.37 ± 0.6% | not timed | not timed | 37.62 ± 21.1% | 589.53 ± 37.2% | not timed | not timed | 339.46 ± 6.0% | | 1.00 | 8.99 | 0.57 |
| unicode/compile/match-every-line-ascii | 4 | 498.63 ± 21.6% | not timed | not timed | 132.69 ± 5.3% | 582.41 ± 36.2% | not timed | not timed | 505.00 ± 17.6% | | 0.99 | 3.76 | 0.86 |
| unicode/compile/negated-class-matches-codepoint | 1 | 273.09 ± 5.1% | not timed | not timed | 42.42 ± 32.5% | 1109.41 ± 24.8% | not timed | not timed | 277.74 ± 10.5% | | 0.98 | 6.44 | 0.25 |
| wild/bibleref/compile | 3 | 4.66 ± 15.4% | not timed | not timed | 1.93 ± 1.1% | 28.29 ± 21.7% | not timed | not timed | 4.85 ± 5.5% | | 0.96 | 2.41 | 0.16 |
| wild/url/compile | 1 | 0.53 ± 11.7% | not timed | not timed | 0.16 ± 1.1% | 0.35 ± 36.6% | not timed | not timed | 0.54 ± 1.1% | | 0.99 | 3.24 | 1.51 |

