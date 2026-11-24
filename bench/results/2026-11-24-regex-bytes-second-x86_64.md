# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391480100 |
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
| literal: a word | 217 | 38731.07 ± 2.1% | 3348.92 ± 0.2% | 20.20 ± 0.2% | 31336.28 ± 0.5% | 9083.60 ± 11.7% | 10.83 ± 0.3% | 75.60 ± 0.5% | 39159.03 ± 2.8% | 11.57 | 0.99 | 1.24 | 4.26 |
| literal: a word that is not there | 0 | 52595.86 ± 1.8% | 3236.14 ± 2.0% | 20.20 ± 0.2% | 39998.68 ± 99.5% | 29888.15 ± 6.9% | 10.76 ± 0.3% | 72.32 ± 1.3% | 52250.56 ± 59.3% | 16.25 | 1.01 | 1.31 | 1.76 |
| literal: one of four words | 661 | 11581.31 ± 0.3% | 1401.76 ± 2.6% | 10.80 ± 0.3% | 9102.23 ± 2.2% | 19.30 ± 1.9% | 3.95 ± 0.2% | 6.43 ± 0.2% | 11560.31 ± 1.2% | 8.26 | 1.00 | 1.27 | 600.03 |
| literal: a word in any case | 217 | 30320.18 ± 1.1% | 1496.84 ± 0.7% | 15.47 ± 0.8% | 9249.32 ± 0.5% | 37.25 ± 7.2% | refused | differs | 30108.25 ± 0.7% | 20.26 | 1.01 | 3.28 | 813.99 |
| literal: an href attribute | 33 | 29077.26 ± 0.4% | 538.17 ± 0.5% | 18.75 ± 0.9% | 27446.37 ± 0.6% | 2063.52 ± 0.9% | 8.30 ± 0.2% | 60.12 ± 0.8% | 29343.76 ± 1.1% | 54.03 | 0.99 | 1.06 | 14.09 |
| literal: a word, second text | 123 | 37873.42 ± 4.0% | 2385.58 ± 0.5% | 20.10 ± 0.5% | 32120.15 ± 0.6% | 7181.44 ± 5.4% | 11.78 ± 0.3% | 65.44 ± 1.2% | 37988.41 ± 2.2% | 15.88 | 1.00 | 1.18 | 5.27 |
| class: two capitalized words | 1331 | 772.25 ± 0.4% | 525.44 ± 0.7% | 18.93 ± 0.5% | 506.30 ± 0.1% | 34.42 ± 1.6% | 9.48 ± 0.1% | 54.83 ± 0.6% | 772.14 ± 0.3% | 1.47 | 1.00 | 1.53 | 22.44 |
| class: a word that ends in ing | 3399 | 499.85 ± 0.4% | 499.85 ± 0.1% | 12.76 ± 0.6% | 472.73 ± 0.1% | 25.74 ± 6.1% | 5.33 ± 0.3% | 15.67 ± 0.4% | 499.60 ± 0.1% | 1.00 | 1.00 | 1.06 | 19.42 |
| class: a word in capitals | 2332 | 952.27 ± 0.3% | 530.46 ± 0.9% | 19.86 ± 0.5% | 496.25 ± 0.4% | 36.75 ± 1.4% | 10.60 ± 0.1% | 76.41 ± 0.5% | 954.43 ± 0.6% | 1.80 | 1.00 | 1.92 | 25.91 |
| class: a number | 8288 | 1461.28 ± 2.1% | 702.07 ± 1.7% | 19.80 ± 0.7% | 1475.02 ± 0.4% | 34.54 ± 12.4% | 0.34 ± 0.2% | 54.10 ± 0.4% | 1456.32 ± 0.2% | 2.08 | 1.00 | 0.99 | 42.31 |
| class: two capitalized words, second text | 5359 | 443.45 ± 1.3% | 449.50 ± 1.2% | 17.19 ± 2.2% | 417.92 ± 1.3% | 29.13 ± 8.9% | 10.74 ± 1.2% | 49.94 ± 2.0% | 443.29 ± 0.9% | 0.99 | 1.00 | 1.06 | 15.22 |
| other: a word between two words | 6104 | 711.91 ± 0.2% | 510.78 ± 1.8% | 16.99 ± 0.6% | 696.20 ± 0.7% | 94.31 ± 20.1% | 7.27 ± 0.2% | 55.68 ± 12.6% | 710.74 ± 0.4% | 1.39 | 1.00 | 1.02 | 7.55 |
| other: a number before a unit, second text | 1481 | 7184.56 ± 0.8% | 861.81 ± 0.3% | 18.76 ± 11.6% | 6410.12 ± 0.7% | 35.15 ± 3.6% | 11.18 ± 0.1% | 53.80 ± 0.3% | 7312.90 ± 0.9% | 8.34 | 0.98 | 1.12 | 204.38 |
| other: a heading's start tag | 110 | 19614.45 ± 2.3% | 653.61 ± 0.2% | 19.48 ± 1.2% | 1933.77 ± 0.2% | 1485.10 ± 4.2% | 10.10 ± 7.5% | 71.36 ± 0.5% | 19662.76 ± 1.2% | 30.01 | 1.00 | 10.14 | 13.21 |
| other: a whole word | 217 | 23911.34 ± 1.6% | 530.94 ± 0.1% | 20.79 ± 13.9% | 22816.57 ± 0.4% | 41.36 ± 2.9% | 9.52 ± 0.1% | 46.27 ± 1.3% | 23875.83 ± 1.8% | 45.04 | 1.00 | 1.05 | 578.12 |
| other: a line's first word, second text | 3716 | 1939.21 ± 0.9% | 512.91 ± 0.4% | 24.03 ± 18.2% | 1695.49 ± 3.3% | 53.49 ± 3.6% | refused | refused | 1935.43 ± 0.9% | 3.78 | 1.00 | 1.14 | 36.25 |
| other: fourteen octets before an x | 87 | 27248.79 ± 1.5% | 203.13 ± 2.0% | 5.43 ± 0.3% | 2814.02 ± 0.8% | 9.01 ± 4.6% | differs | 15.01 ± 0.5% | 26580.19 ± 1.3% | 134.14 | 1.03 | 9.68 | 3023.84 |
| other: a Greek word | 21815 | 387.95 ± 0.1% | 335.29 ± 0.2% | 23.71 ± 0.7% | 264.84 ± 0.4% | 45.82 ± 8.4% | differs | refused | 389.33 ± 0.3% | 1.16 | 1.00 | 1.46 | 8.47 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.47 ± 0.3% | 18.45 ± 0.4% | 0.78 ± 0.2% | 16.81 ± 0.3% | 2.34 ± 0.2% | differs | 3.37 ± 1.5% | 18.47 ± 0.9% | 1.00 | 1.00 | 1.10 | 7.88 |
| a UUID | 32895 | 20.29 ± 1.7% | 20.14 ± 0.3% | 0.55 ± 0.6% | 12.84 ± 0.1% | 2.48 ± 3.2% | 0.44 ± 0.3% | 3.01 ± 2.4% | 20.29 ± 0.1% | 1.01 | 1.00 | 1.58 | 8.18 |
| an IPv4 address | 33176 | 33.32 ± 0.8% | 33.09 ± 0.3% | 1.77 ± 0.8% | 23.98 ± 0.2% | 5.81 ± 1.6% | differs | 3.29 ± 1.4% | 32.97 ± 0.4% | 1.01 | 1.01 | 1.39 | 5.74 |
| a date and time | 32954 | 29.71 ± 1.4% | 29.72 ± 0.2% | 1.27 ± 1.7% | 17.73 ± 0.2% | 6.66 ± 0.4% | 0.76 ± 0.2% | 5.62 ± 1.6% | 29.72 ± 2.6% | 1.00 | 1.00 | 1.68 | 4.46 |
| a field path | 32606 | 21.51 ± 0.3% | 21.57 ± 0.4% | 0.77 ± 1.2% | 19.39 ± 1.0% | 2.93 ± 1.0% | differs | 2.37 ± 0.6% | 21.51 ± 0.5% | 1.00 | 1.00 | 1.11 | 7.33 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.25 ± 0.3% | 8.73 ± 0.2% | 8.61 ± 1.1% | 10.45 ± 0.2% | 4.79 ± 2.8% | 0.63 ± 0.3% | none | 8.75 ± 0.6% | 0.94 | 0.94 | 0.79 | 1.72 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 182.68 ± 2.7% | 184.08 ± 0.4% | 217.43 ± 0.2% | 80.38 ± 2.7% | 186.72 ± 1.0% | 538.04 ± 3.4% | 3845.91 ± 0.7% | 182.91 ± 0.6% | 0.99 | 1.00 | 2.27 | 0.98 |
| a UUID | 62 | 119.23 ± 4.4% | 120.64 ± 5.6% | 135.77 ± 0.5% | 46.67 ± 1.0% | 89.44 ± 22.9% | 199.28 ± 2.4% | 3959.88 ± 15.8% | 120.39 ± 0.9% | 0.99 | 0.99 | 2.55 | 1.33 |
| an IPv4 address | 29 | 364.65 ± 0.6% | 366.53 ± 1.2% | 528.47 ± 1.6% | 71.18 ± 0.8% | 114.67 ± 23.8% | 327.03 ± 1.2% | 6628.85 ± 1.0% | 364.69 ± 0.9% | 0.99 | 1.00 | 5.12 | 3.18 |
| a date and time | 56 | 264.98 ± 3.5% | 266.44 ± 0.7% | 340.63 ± 1.2% | 68.84 ± 0.6% | 122.35 ± 2.4% | 371.38 ± 1.0% | 4051.66 ± 1.8% | 265.54 ± 2.4% | 0.99 | 1.00 | 3.85 | 2.17 |
| a field path | 39 | 180.44 ± 2.1% | 181.19 ± 2.6% | 214.67 ± 2.6% | 72.87 ± 3.1% | 169.60 ± 6.8% | 567.05 ± 14.4% | 4448.59 ± 2.3% | 180.08 ± 2.5% | 1.00 | 1.00 | 2.48 | 1.06 |
| literal: a word | 7 | 527.09 ± 2.6% | 571.03 ± 0.7% | 1062.25 ± 0.6% | 502.85 ± 14.1% | 582.12 ± 2.3% | 1228.51 ± 0.2% | 24366.44 ± 10.7% | 528.50 ± 0.3% | 0.92 | 1.00 | 1.05 | 0.91 |
| literal: a word that is not there | 8 | 508.48 ± 10.9% | 550.13 ± 13.9% | 990.91 ± 0.3% | 466.24 ± 1.5% | 557.40 ± 1.6% | 1149.46 ± 8.2% | 22443.36 ± 2.0% | 509.33 ± 0.3% | 0.92 | 1.00 | 1.09 | 0.91 |
| literal: one of four words | 26 | 209.23 ± 1.0% | 340.42 ± 1.9% | 467.39 ± 5.3% | 42.10 ± 8.8% | 221.72 ± 2.7% | 451.69 ± 0.3% | 10471.02 ± 8.4% | 208.97 ± 9.9% | 0.61 | 1.00 | 4.97 | 0.94 |
| literal: a word in any case | 11 | 371.88 ± 0.3% | 397.26 ± 0.3% | 587.01 ± 1.0% | 14.31 ± 10.0% | 603.51 ± 4.4% | refused | 19183.28 ± 4.7% | 372.63 ± 0.2% | 0.94 | 1.00 | 25.99 | 0.62 |
| literal: an href attribute | 12 | 297.54 ± 0.4% | 308.19 ± 0.2% | 416.44 ± 0.7% | 37.61 ± 0.5% | 426.14 ± 1.8% | 964.07 ± 0.7% | 17343.66 ± 1.4% | 297.94 ± 0.3% | 0.97 | 1.00 | 7.91 | 0.70 |
| literal: a word, second text | 10 | 470.96 ± 0.6% | 516.67 ± 0.3% | 884.50 ± 0.4% | 411.92 ± 4.6% | 485.58 ± 3.7% | 1008.16 ± 0.9% | 19857.37 ± 0.4% | 471.36 ± 0.9% | 0.91 | 1.00 | 1.14 | 0.97 |
| class: two capitalized words | 23 | 376.02 ± 2.1% | 408.18 ± 2.2% | 617.00 ± 3.5% | 95.03 ± 0.7% | 455.02 ± 1.8% | 907.81 ± 5.7% | 6134.94 ± 1.5% | 376.11 ± 1.9% | 0.92 | 1.00 | 3.96 | 0.83 |
| class: a word that ends in ing | 9 | 458.07 ± 0.2% | 522.96 ± 0.4% | 980.12 ± 1.5% | 115.65 ± 0.3% | 640.87 ± 1.9% | 1338.81 ± 0.3% | 14741.96 ± 3.0% | 457.33 ± 0.8% | 0.88 | 1.00 | 3.96 | 0.71 |
| class: a word in capitals | 16 | 402.54 ± 0.1% | 435.24 ± 0.2% | 760.76 ± 0.2% | 120.87 ± 0.4% | 660.87 ± 3.4% | 1278.54 ± 0.8% | 8161.96 ± 1.4% | 402.62 ± 0.3% | 0.92 | 1.00 | 3.33 | 0.61 |
| class: a number | 6 | 506.88 ± 3.6% | 562.83 ± 0.2% | 1158.54 ± 14.9% | 36.81 ± 1.9% | 1196.72 ± 1.0% | 2284.06 ± 6.6% | 19681.40 ± 20.4% | 507.86 ± 0.5% | 0.90 | 1.00 | 13.77 | 0.42 |
| class: two capitalized words, second text | 23 | 378.55 ± 1.6% | 407.60 ± 2.0% | 616.79 ± 3.5% | 95.23 ± 1.2% | 452.59 ± 15.5% | 925.03 ± 0.5% | 6100.67 ± 20.6% | 376.24 ± 2.1% | 0.93 | 1.01 | 3.97 | 0.84 |
| other: a word between two words | 13 | 461.84 ± 1.0% | 480.55 ± 1.2% | 794.28 ± 0.4% | 123.06 ± 0.2% | 439.80 ± 16.2% | 1010.65 ± 25.4% | 12193.33 ± 27.1% | 462.17 ± 1.3% | 0.96 | 1.00 | 3.75 | 1.05 |
| other: a number before a unit, second text | 15 | 332.03 ± 0.3% | 371.02 ± 5.4% | 533.73 ± 0.2% | 34.08 ± 1.2% | 545.03 ± 1.4% | 1095.96 ± 0.5% | 12125.52 ± 0.4% | 332.71 ± 0.7% | 0.89 | 1.00 | 9.74 | 0.61 |
| other: a heading's start tag | 13 | 307.57 ± 0.4% | 313.57 ± 1.1% | 426.29 ± 0.4% | 36.10 ± 1.8% | 530.22 ± 0.9% | 1099.53 ± 2.1% | 14759.35 ± 2.2% | 307.99 ± 0.3% | 0.98 | 1.00 | 8.52 | 0.58 |
| other: a whole word | 11 | 464.54 ± 1.0% | 492.68 ± 1.0% | 812.79 ± 1.9% | 110.67 ± 7.3% | 507.28 ± 6.7% | 1059.12 ± 12.4% | 20847.97 ± 4.9% | 463.19 ± 8.4% | 0.94 | 1.00 | 4.20 | 0.92 |
| other: a line's first word, second text | 17 | 443.34 ± 0.7% | 465.70 ± 0.3% | 800.50 ± 7.9% | 114.36 ± 0.7% | 607.40 ± 2.1% | refused | refused | 443.49 ± 0.3% | 0.95 | 1.00 | 3.88 | 0.73 |
| other: fourteen octets before an x | 16 | 87.84 ± 2.8% | 120.74 ± 0.5% | 141.68 ± 0.3% | 14.31 ± 0.8% | 396.09 ± 2.6% | 454.74 ± 11.5% | 11992.58 ± 1.5% | 87.78 ± 8.1% | 0.73 | 1.00 | 6.14 | 0.22 |
| other: a Greek word | 8 | 350.97 ± 0.9% | 482.83 ± 0.8% | 871.15 ± 0.8% | 47.46 ± 0.9% | 1179.96 ± 1.9% | 2104.76 ± 0.8% | refused | 350.24 ± 0.9% | 0.73 | 1.00 | 7.39 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 26844.87 ± 1.8% | not timed | not timed | 26747.91 ± 11.9% | 2004.31 ± 14.7% | not timed | not timed | 26630.53 ± 1.2% | | 1.01 | 1.00 | 13.39 |
| 01-literal/sherlock-casei-en | 522 | 21241.91 ± 3.2% | not timed | not timed | 7039.26 ± 8.9% | 28.78 ± 4.2% | not timed | not timed | 21290.44 ± 2.7% | | 1.00 | 3.02 | 738.10 |
| 01-literal/sherlock-ru | 724 | 28418.46 ± 2.0% | not timed | not timed | 27759.43 ± 10.6% | 1069.59 ± 6.5% | not timed | not timed | 28181.16 ± 0.4% | | 1.01 | 1.02 | 26.57 |
| 01-literal/sherlock-casei-ru | 746 | 9431.99 ± 7.2% | not timed | not timed | 5528.13 ± 1.1% | 30.58 ± 1.2% | not timed | not timed | 9457.93 ± 0.6% | | 1.00 | 1.71 | 308.43 |
| 01-literal/sherlock-zh | 30 | 46607.06 ± 1.2% | not timed | not timed | 36856.71 ± 0.6% | 1261.65 ± 1.0% | not timed | not timed | 46494.60 ± 1.6% | | 1.00 | 1.26 | 36.94 |
| 02-literal-alternate/sherlock-en | 714 | 9882.23 ± 1.9% | not timed | not timed | 8754.24 ± 1.6% | 14.28 ± 3.7% | not timed | not timed | 9915.85 ± 7.8% | | 1.00 | 1.13 | 691.83 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2095.86 ± 0.7% | not timed | not timed | 1820.48 ± 0.1% | 9.54 ± 0.7% | not timed | not timed | 2094.32 ± 7.5% | | 1.00 | 1.15 | 219.72 |
| 02-literal-alternate/sherlock-ru | 899 | 7908.56 ± 0.7% | not timed | not timed | 4272.53 ± 0.2% | 19.53 ± 0.9% | not timed | not timed | 7916.44 ± 1.7% | | 1.00 | 1.85 | 404.86 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2077.76 ± 1.5% | not timed | not timed | 1046.19 ± 0.1% | 8.63 ± 0.9% | not timed | not timed | 2074.13 ± 5.7% | | 1.00 | 1.99 | 240.85 |
| 02-literal-alternate/sherlock-zh | 207 | 14457.14 ± 14.8% | not timed | not timed | 10429.72 ± 0.6% | 27.25 ± 1.5% | not timed | not timed | 14544.54 ± 1.6% | | 0.99 | 1.39 | 530.49 |
| 03-date/ascii | 111817 | 96.99 ± 0.8% | not timed | not timed | 85.40 ± 0.4% | 0.18 ± 2.7% | not timed | not timed | 97.04 ± 0.2% | | 1.00 | 1.14 | 538.44 |
| 04-ruff-noqa/real | 84 | 419.85 ± 0.1% | not timed | not timed | 417.47 ± 0.7% | 15.77 ± 1.4% | not timed | not timed | 419.29 ± 1.0% | | 1.00 | 1.01 | 26.62 |
| 04-ruff-noqa/tweaked | 44 | 514.44 ± 1.1% | not timed | not timed | 418.95 ± 0.5% | 294.95 ± 0.7% | not timed | not timed | 516.36 ± 0.7% | | 1.00 | 1.23 | 1.74 |
| 05-lexer-veryl/single | 124800 | 3.47 ± 15.5% | not timed | not timed | 4.20 ± 0.5% | 0.21 ± 4.0% | not timed | not timed | 3.39 ± 3.4% | | 1.02 | 0.83 | 16.50 |
| 06-cloud-flare-redos/original | 107 | 351.30 ± 1.4% | not timed | not timed | 191.12 ± 1.1% | 20.57 ± 0.5% | not timed | not timed | 351.29 ± 0.6% | | 1.00 | 1.84 | 17.08 |
| 06-cloud-flare-redos/simplified-short | 102 | 334.32 ± 0.8% | not timed | not timed | 192.24 ± 0.1% | 20.59 ± 0.9% | not timed | not timed | 331.82 ± 1.4% | | 1.01 | 1.74 | 16.24 |
| 06-cloud-flare-redos/simplified-long | 10000 | 464.58 ± 0.2% | not timed | not timed | 211.85 ± 0.1% | 24.24 ± 5.4% | not timed | not timed | 460.91 ± 0.7% | | 1.01 | 2.19 | 19.17 |
| 07-unicode-character-data/parse-line | 558784 | 203.62 ± 2.1% | not timed | not timed | 142.87 ± 7.3% | 36.14 ± 9.5% | not timed | not timed | 204.07 ± 2.0% | | 1.00 | 1.43 | 5.63 |
| 08-words/all-english | 56691 | 98.00 ± 0.5% | not timed | not timed | 72.62 ± 0.6% | 10.03 ± 4.8% | not timed | not timed | 98.20 ± 0.9% | | 1.00 | 1.35 | 9.77 |
| 08-words/long-english | 839 | 535.86 ± 0.3% | not timed | not timed | 513.85 ± 0.1% | 26.07 ± 9.6% | not timed | not timed | 535.82 ± 0.1% | | 1.00 | 1.04 | 20.56 |
| 09-aws-keys/full | 0 | 421.03 ± 2.8% | not timed | not timed | 448.39 ± 2.2% | 53.32 ± 5.8% | not timed | not timed | 424.21 ± 6.8% | | 0.99 | 0.94 | 7.90 |
| 09-aws-keys/quick | 0 | 925.09 ± 0.3% | not timed | not timed | 803.86 ± 0.3% | 331.54 ± 0.7% | not timed | not timed | 925.43 ± 1.8% | | 1.00 | 1.15 | 2.79 |
| 10-bounded-repeat/letters-en | 1833 | 486.14 ± 0.8% | not timed | not timed | 431.78 ± 0.2% | 16.87 ± 2.8% | not timed | not timed | 485.98 ± 0.3% | | 1.00 | 1.13 | 28.82 |
| 10-bounded-repeat/letters-ru | 3475 | 430.05 ± 0.4% | not timed | not timed | 408.21 ± 0.1% | 19.61 ± 13.8% | not timed | not timed | 430.69 ± 0.7% | | 1.00 | 1.05 | 21.93 |
| 10-bounded-repeat/context | 53 | 68.28 ± 2.1% | not timed | not timed | 56.28 ± 2.4% | 16.90 ± 0.6% | not timed | not timed | 68.24 ± 1.2% | | 1.00 | 1.21 | 4.04 |
| 10-bounded-repeat/capitals | 11 | 557.26 ± 8.0% | not timed | not timed | 533.34 ± 0.2% | 30.99 ± 1.0% | not timed | not timed | 556.77 ± 8.0% | | 1.00 | 1.04 | 17.98 |
| 11-unstructured-to-json/extract | 600 | 37.56 ± 4.4% | not timed | not timed | 62.39 ± 2.4% | 41.14 ± 1.6% | not timed | not timed | 37.54 ± 5.6% | | 1.00 | 0.60 | 0.91 |
| 12-dictionary/single | 1 | 464.98 ± 1.0% | not timed | not timed | 442.69 ± 0.6% | 0.32 ± 0.6% | not timed | not timed | 465.16 ± 0.6% | | 1.00 | 1.05 | 1444.57 |
| 14-quadratic/1x | 100 | 21.71 ± 1.3% | not timed | not timed | 9.10 ± 0.2% | 0.79 ± 3.3% | not timed | not timed | 21.68 ± 1.1% | | 1.00 | 2.39 | 27.48 |
| 14-quadratic/2x | 200 | 16.54 ± 1.1% | not timed | not timed | 4.89 ± 0.9% | 0.38 ± 1.1% | not timed | not timed | 16.58 ± 1.7% | | 1.00 | 3.38 | 43.62 |
| 14-quadratic/10x | 1000 | 5.63 ± 1.1% | not timed | not timed | 1.05 ± 0.3% | 0.09 ± 0.1% | not timed | not timed | 5.65 ± 0.5% | | 1.00 | 5.36 | 60.95 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.08 ± 2.5% | not timed | not timed | 0.39 ± 0.8% | 0.48 ± 3.9% | not timed | not timed | 1.08 ± 0.4% | | 1.00 | 2.77 | 2.25 |
| 04-ruff-noqa/compile-real | 1 | 96.82 ± 0.6% | not timed | not timed | 12.89 ± 0.8% | 123.94 ± 4.6% | not timed | not timed | 96.02 ± 1.7% | | 1.01 | 7.51 | 0.78 |
| 05-lexer-veryl/compile-single | 1 | 12.65 ± 1.7% | not timed | not timed | 2.37 ± 1.2% | 5.88 ± 12.0% | not timed | not timed | 12.67 ± 1.6% | | 1.00 | 5.33 | 2.15 |
| 07-unicode-character-data/compile | 1 | 100.29 ± 0.3% | not timed | not timed | 24.29 ± 3.5% | 33.17 ± 2.2% | not timed | not timed | 100.53 ± 8.0% | | 1.00 | 4.13 | 3.02 |
| 09-aws-keys/compile-full | 1 | 43.54 ± 1.0% | not timed | not timed | 7.43 ± 15.2% | 20.27 ± 4.6% | not timed | not timed | 43.38 ± 9.1% | | 1.00 | 5.86 | 2.15 |
| 09-aws-keys/compile-quick | 1 | 154.30 ± 1.9% | not timed | not timed | 45.08 ± 1.4% | 118.30 ± 4.6% | not timed | not timed | 154.83 ± 1.4% | | 1.00 | 3.42 | 1.30 |
| 10-bounded-repeat/compile-context | 1 | 50.19 ± 0.5% | not timed | not timed | 11.59 ± 0.6% | 15.17 ± 2.7% | not timed | not timed | 49.85 ± 0.9% | | 1.01 | 4.33 | 3.31 |
| 10-bounded-repeat/compile-capitals | 1 | 73.99 ± 0.5% | not timed | not timed | 8.85 ± 2.6% | 22.43 ± 2.6% | not timed | not timed | 73.89 ± 0.5% | | 1.00 | 8.36 | 3.30 |
| 11-unstructured-to-json/compile | 1 | 150.87 ± 4.6% | not timed | not timed | 37.08 ± 9.2% | 61.27 ± 4.5% | not timed | not timed | 150.91 ± 0.5% | | 1.00 | 4.07 | 2.46 |
| 12-dictionary/compile-single | 1 | 0.28 ± 1.5% | not timed | not timed | 0.07 ± 18.3% | 0.09 ± 11.3% | not timed | not timed | 0.29 ± 1.3% | | 1.00 | 4.08 | 3.17 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 5.26 ± 2.8% | not timed | not timed | 5.49 ± 0.4% | 0.53 ± 22.6% | not timed | not timed | 5.29 ± 3.2% | | 1.00 | 0.96 | 10.01 |
| dictionary/search/english-10 | 690 | 0.92 ± 1.4% | not timed | not timed | 114.59 ± 1.8% | 0.00 ± 0.5% | not timed | not timed | 0.92 ± 2.5% | | 1.00 | 0.0080 | 185.49 |
| dictionary/search/english-15 | 15 | 464.32 ± 0.3% | not timed | not timed | 437.76 ± 0.5% | 0.29 ± 0.5% | not timed | not timed | 464.17 ± 0.2% | | 1.00 | 1.06 | 1586.45 |
| folly/awyer-inn-busted | 1 | 3675.00 ± 0.3% | not timed | not timed | 112.84 ± 0.2% | 37.35 ± 16.0% | not timed | not timed | 3681.02 ± 12.4% | | 1.00 | 32.57 | 98.38 |
| folly/literal-never-match-rare | 0 | 53714.27 ± 2.1% | not timed | not timed | 40371.64 ± 0.1% | 54198.40 ± 12.1% | not timed | not timed | 53748.66 ± 2.2% | | 1.00 | 1.33 | 0.99 |
| folly/literal-never-match-frequent | 0 | 18027.41 ± 1.3% | not timed | not timed | 39923.12 ± 0.7% | 2087.82 ± 1.1% | not timed | not timed | 18045.94 ± 1.7% | | 1.00 | 0.45 | 8.63 |
| folly/literal-never-match-tricksy | 1 | 3060.13 ± 5.5% | not timed | not timed | 4846.43 ± 1.3% | 1510.67 ± 0.5% | not timed | not timed | 3062.62 ± 5.8% | | 1.00 | 0.63 | 2.03 |
| grep/every-line | 239963 | 1215.64 ± 2.1% | not timed | not timed | 794.10 ± 0.7% | 305.78 ± 31.7% | not timed | not timed | 1217.13 ± 0.3% | | 1.00 | 1.53 | 3.98 |
| grep/long-words-ascii | 5073 | 434.83 ± 0.4% | not timed | not timed | 415.01 ± 1.3% | 38.11 ± 7.2% | not timed | not timed | 434.72 ± 1.7% | | 1.00 | 1.05 | 11.41 |
| imported/leipzig/twain | 811 | 44497.92 ± 1.4% | not timed | not timed | 36910.23 ± 1.0% | 10272.38 ± 13.0% | not timed | not timed | 44540.76 ± 2.6% | | 1.00 | 1.21 | 4.33 |
| imported/leipzig/twain-insensitive | 965 | 12985.07 ± 0.5% | not timed | not timed | 11212.82 ± 0.7% | 35.38 ± 0.5% | not timed | not timed | 12992.26 ± 0.7% | | 1.00 | 1.16 | 367.03 |
| imported/leipzig/shing | 1540 | 550.40 ± 0.4% | not timed | not timed | 18824.43 ± 0.7% | 30.03 ± 1.7% | not timed | not timed | 551.00 ± 0.2% | | 1.00 | 0.0292 | 18.33 |
| imported/leipzig/huck-saw | 262 | 20851.58 ± 1.5% | not timed | not timed | 15785.65 ± 0.5% | 25.18 ± 0.3% | not timed | not timed | 20917.60 ± 0.8% | | 1.00 | 1.32 | 828.03 |
| imported/leipzig/word-ending-nn | 262 | 533.06 ± 0.1% | not timed | not timed | 532.71 ± 0.2% | 21.61 ± 0.1% | not timed | not timed | 533.60 ± 0.2% | | 1.00 | 1.00 | 24.67 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 10019.82 ± 2.2% | not timed | not timed | 3151.57 ± 1.6% | 9.66 ± 2.8% | not timed | not timed | 9986.29 ± 2.7% | | 1.00 | 3.18 | 1037.58 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 17109.59 ± 0.6% | not timed | not timed | 14352.68 ± 9.8% | 14.89 ± 2.9% | not timed | not timed | 17172.93 ± 1.0% | | 1.00 | 1.19 | 1148.95 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4965.33 ± 0.4% | not timed | not timed | 705.51 ± 1.9% | 9.50 ± 1.2% | not timed | not timed | 4967.35 ± 7.9% | | 1.00 | 7.04 | 522.89 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 531.17 ± 0.4% | not timed | not timed | 530.42 ± 0.1% | 9.89 ± 1.7% | not timed | not timed | 532.12 ± 0.8% | | 1.00 | 1.00 | 53.72 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 532.18 ± 0.1% | not timed | not timed | 531.70 ± 0.3% | 8.46 ± 1.0% | not timed | not timed | 532.37 ± 0.4% | | 1.00 | 1.00 | 62.91 |
| imported/leipzig/tom-river | 2 | 10961.06 ± 2.0% | not timed | not timed | 11256.51 ± 1.1% | 27.25 ± 1.0% | not timed | not timed | 11024.77 ± 1.1% | | 0.99 | 0.97 | 402.18 |
| imported/leipzig/ing | 78424 | 522.68 ± 1.9% | not timed | not timed | 490.34 ± 1.3% | 24.33 ± 7.7% | not timed | not timed | 521.74 ± 1.3% | | 1.00 | 1.07 | 21.48 |
| imported/leipzig/ing-whitespace | 55248 | 646.60 ± 0.1% | not timed | not timed | 1892.66 ± 0.4% | 17.87 ± 1.8% | not timed | not timed | 650.31 ± 0.6% | | 0.99 | 0.34 | 36.18 |
| imported/leipzig/awyer-inn | 209 | 672.84 ± 1.4% | not timed | not timed | 11487.44 ± 0.4% | 19.47 ± 1.7% | not timed | not timed | 672.65 ± 1.3% | | 1.00 | 0.0586 | 34.57 |
| imported/leipzig/quotes-bounded | 8886 | 1621.66 ± 0.5% | not timed | not timed | 2852.04 ± 0.3% | 31.93 ± 0.2% | not timed | not timed | 1621.31 ± 0.6% | | 1.00 | 0.57 | 50.79 |
| imported/leipzig/non-ascii-alternate | 2 | 30820.64 ± 1.1% | not timed | not timed | 16561.64 ± 0.6% | 42.60 ± 0.3% | not timed | not timed | 30941.88 ± 2.4% | | 1.00 | 1.86 | 723.54 |
| imported/leipzig/math-symbols | 69 | 1598.98 ± 0.4% | not timed | not timed | 530.65 ± 0.4% | 31.33 ± 0.3% | not timed | not timed | 1604.23 ± 0.1% | | 1.00 | 3.01 | 51.04 |
| imported/leipzig/bounded-strings-ending-z | 0 | 534.68 ± 3.6% | not timed | not timed | 532.41 ± 0.3% | 19.97 ± 2.1% | not timed | not timed | 534.51 ± 0.2% | | 1.00 | 1.00 | 26.77 |
| imported/lh3lh3-reb/uri | 17549 | 604.52 ± 0.4% | not timed | not timed | 894.23 ± 5.8% | 24.05 ± 3.4% | not timed | not timed | 604.41 ± 0.6% | | 1.00 | 0.68 | 25.13 |
| imported/lh3lh3-reb/email | 15057 | 656.25 ± 1.0% | not timed | not timed | 921.49 ± 3.4% | 25.63 ± 0.8% | not timed | not timed | 656.64 ± 2.6% | | 1.00 | 0.71 | 25.60 |
| imported/lh3lh3-reb/date | 668 | 755.55 ± 0.5% | not timed | not timed | 821.19 ± 1.2% | 43.70 ± 6.2% | not timed | not timed | 757.04 ± 0.4% | | 1.00 | 0.92 | 17.29 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 616.97 ± 2.5% | not timed | not timed | 373.39 ± 0.2% | 12.61 ± 1.3% | not timed | not timed | 614.54 ± 9.8% | | 1.00 | 1.65 | 48.94 |
| imported/mariomka/email | 92 | 614.67 ± 0.2% | not timed | not timed | 38131.24 ± 2.3% | 28.30 ± 0.7% | not timed | not timed | 614.72 ± 0.1% | | 1.00 | 0.0161 | 21.72 |
| imported/mariomka/uri | 5301 | 524.62 ± 0.3% | not timed | not timed | 6486.86 ± 0.5% | 28.43 ± 0.9% | not timed | not timed | 525.28 ± 0.3% | | 1.00 | 0.0809 | 18.45 |
| imported/mariomka/ip | 5 | 1553.32 ± 3.4% | not timed | not timed | 2039.42 ± 3.1% | 17.96 ± 1.7% | not timed | not timed | 1556.82 ± 3.7% | | 1.00 | 0.76 | 86.48 |
| imported/rsc/no-exponential | 0 | 620.64 ± 0.3% | not timed | not timed | 326.17 ± 0.9% | 19.63 ± 0.8% | not timed | not timed | 626.54 ± 0.9% | | 0.99 | 1.90 | 31.62 |
| imported/rsc/literal | 1 | 752.31 ± 2.7% | not timed | not timed | 1738.36 ± 1.5% | 165.23 ± 12.4% | not timed | not timed | 751.97 ± 2.3% | | 1.00 | 0.43 | 4.55 |
| imported/rsc/not-literal | 2 | 629.68 ± 8.2% | not timed | not timed | 714.23 ± 1.2% | 41.31 ± 2.9% | not timed | not timed | 633.63 ± 0.3% | | 0.99 | 0.88 | 15.24 |
| imported/rsc/match-class | 1 | 1037.37 ± 1.8% | not timed | not timed | 1523.16 ± 0.9% | 50.01 ± 1.5% | not timed | not timed | 1045.16 ± 0.9% | | 0.99 | 0.68 | 20.74 |
| imported/rsc/match-class-in-range | 1 | 1042.04 ± 7.0% | not timed | not timed | 2810.54 ± 0.3% | 51.45 ± 10.2% | not timed | not timed | 1046.18 ± 4.3% | | 1.00 | 0.37 | 20.25 |
| imported/rsc/match-class-unicode | 1 | 466.50 ± 1.9% | not timed | not timed | 459.74 ± 0.7% | 61.96 ± 1.3% | not timed | not timed | 466.09 ± 0.3% | | 1.00 | 1.01 | 7.53 |
| imported/rsc/anchored-literal-short-non-match | 0 | 500.30 ± 0.7% | not timed | not timed | 898.04 ± 3.5% | 265.08 ± 1.4% | not timed | not timed | 501.13 ± 1.1% | | 1.00 | 0.56 | 1.89 |
| imported/rsc/anchored-literal-long-non-match | 0 | 7722.72 ± 0.2% | not timed | not timed | 13461.75 ± 1.0% | 3978.82 ± 32.0% | not timed | not timed | 7723.80 ± 0.3% | | 1.00 | 0.57 | 1.94 |
| imported/rsc/anchored-literal-short-match | 4 | 348.53 ± 7.8% | not timed | not timed | 520.72 ± 1.2% | 79.65 ± 47.8% | not timed | not timed | 351.82 ± 10.0% | | 0.99 | 0.67 | 4.38 |
| imported/rsc/anchored-literal-long-match | 4 | 2310.96 ± 0.8% | not timed | not timed | 7746.08 ± 1.0% | 1208.50 ± 24.2% | not timed | not timed | 2290.31 ± 2.0% | | 1.01 | 0.30 | 1.91 |
| imported/rsc/one-pass-short | 17 | 257.91 ± 1.4% | not timed | not timed | 221.51 ± 0.4% | 27.79 ± 14.3% | not timed | not timed | 258.25 ± 2.3% | | 1.00 | 1.16 | 9.28 |
| imported/rsc/one-pass-short-not | 17 | 186.24 ± 3.2% | not timed | not timed | 226.35 ± 2.3% | 25.04 ± 22.1% | not timed | not timed | 186.68 ± 3.3% | | 1.00 | 0.82 | 7.44 |
| imported/rsc/one-pass-long-prefix | 26 | 205.24 ± 2.4% | not timed | not timed | 279.06 ± 0.3% | 90.28 ± 14.4% | not timed | not timed | 204.22 ± 2.3% | | 1.00 | 0.74 | 2.27 |
| imported/rsc/one-pass-long-prefix-not | 26 | 286.01 ± 0.4% | not timed | not timed | 282.00 ± 0.4% | 66.90 ± 29.8% | not timed | not timed | 273.05 ± 11.9% | | 1.05 | 1.01 | 4.28 |
| imported/rsc/long-needle1 | 31 | 57342.05 ± 0.4% | not timed | not timed | 39811.51 ± 13.0% | 3.32 ± 0.2% | not timed | not timed | 57180.46 ± 3.0% | | 1.00 | 1.44 | 17282.68 |
| imported/rsc/long-needle2 | 31 | 56170.26 ± 2.1% | not timed | not timed | 171.87 ± 0.2% | 3.32 ± 0.7% | not timed | not timed | 55896.55 ± 1.1% | | 1.00 | 326.82 | 16933.02 |
| imported/rsc/easy0-32 | 26 | 1042.94 ± 11.5% | not timed | not timed | 1523.43 ± 7.6% | 128.05 ± 27.1% | not timed | not timed | 1045.36 ± 0.1% | | 1.00 | 0.68 | 8.14 |
| imported/rsc/easy0-1k | 26 | 17517.09 ± 7.7% | not timed | not timed | 16236.51 ± 0.9% | 1875.19 ± 16.1% | not timed | not timed | 17450.59 ± 1.0% | | 1.00 | 1.08 | 9.34 |
| imported/rsc/easy0-32k | 26 | 55650.73 ± 1.3% | not timed | not timed | 38434.47 ± 0.4% | 20598.24 ± 35.3% | not timed | not timed | 55694.54 ± 8.9% | | 1.00 | 1.45 | 2.70 |
| imported/rsc/easy0-1mb | 26 | 54796.04 ± 1.0% | not timed | not timed | 39991.52 ± 0.6% | 54279.90 ± 1.2% | not timed | not timed | 54523.58 ± 1.7% | | 1.00 | 1.37 | 1.01 |
| imported/rsc/easy1-32 | 19 | 324.04 ± 1.3% | not timed | not timed | 648.06 ± 0.6% | 117.28 ± 21.1% | not timed | not timed | 324.98 ± 0.5% | | 1.00 | 0.50 | 2.76 |
| imported/rsc/easy1-1k | 19 | 514.58 ± 3.5% | not timed | not timed | 13162.00 ± 1.2% | 1902.48 ± 13.8% | not timed | not timed | 512.92 ± 2.1% | | 1.00 | 0.0391 | 0.27 |
| imported/rsc/easy1-32k | 19 | 530.79 ± 10.2% | not timed | not timed | 417316.03 ± 39.0% | 22735.25 ± 22.6% | not timed | not timed | 531.78 ± 0.7% | | 1.00 | 0.0013 | 0.0233 |
| imported/rsc/easy1-1mb | 19 | 532.24 ± 1.1% | not timed | not timed | 13312635.32 ± 0.2% | 54231.36 ± 2.1% | not timed | not timed | 531.07 ± 1.1% | | 1.00 | 0.0000 | 0.0098 |
| imported/rsc/medium-32 | 27 | 386.57 ± 1.9% | not timed | not timed | 628.87 ± 10.2% | 60.22 ± 24.8% | not timed | not timed | 387.33 ± 0.3% | | 1.00 | 0.61 | 6.42 |
| imported/rsc/medium-1k | 27 | 6359.59 ± 9.1% | not timed | not timed | 11143.75 ± 0.3% | 61.18 ± 0.7% | not timed | not timed | 6355.87 ± 0.2% | | 1.00 | 0.57 | 103.95 |
| imported/rsc/medium-32k | 27 | 45396.84 ± 10.7% | not timed | not timed | 350771.31 ± 1.7% | 41.61 ± 0.9% | not timed | not timed | 45110.29 ± 6.3% | | 1.01 | 0.13 | 1091.02 |
| imported/rsc/medium-1mb | 27 | 52539.36 ± 2.3% | not timed | not timed | 11148789.79 ± 0.3% | 41.61 ± 0.3% | not timed | not timed | 52599.12 ± 12.2% | | 1.00 | 0.0047 | 1262.77 |
| imported/rsc/hard-32 | 58 | 232.17 ± 1.7% | not timed | not timed | 341.35 ± 19.9% | 41.45 ± 8.1% | not timed | not timed | 232.17 ± 0.6% | | 1.00 | 0.68 | 5.60 |
| imported/rsc/hard-1k | 27 | 513.25 ± 0.2% | not timed | not timed | 10945.93 ± 1.3% | 33.44 ± 20.7% | not timed | not timed | 512.82 ± 0.9% | | 1.00 | 0.0469 | 15.35 |
| imported/rsc/hard-32k | 27 | 532.53 ± 0.9% | not timed | not timed | 334185.06 ± 1.2% | 25.60 ± 1.7% | not timed | not timed | 531.88 ± 0.3% | | 1.00 | 0.0016 | 20.80 |
| imported/rsc/hard-1mb | 51 | 533.53 ± 0.1% | not timed | not timed | 6744784.84 ± 0.7% | 25.72 ± 0.6% | not timed | not timed | 531.35 ± 0.7% | | 1.00 | 0.0001 | 20.74 |
| imported/rsc/reallyhard0-32 | 58 | 231.17 ± 8.9% | not timed | not timed | 212.90 ± 0.9% | 40.05 ± 4.8% | not timed | not timed | 232.29 ± 0.1% | | 1.00 | 1.09 | 5.77 |
| imported/rsc/reallyhard0-1k | 27 | 512.13 ± 0.5% | not timed | not timed | 510.72 ± 0.4% | 33.32 ± 0.5% | not timed | not timed | 513.95 ± 2.1% | | 1.00 | 1.00 | 15.37 |
| imported/rsc/reallyhard0-32k | 27 | 531.17 ± 0.2% | not timed | not timed | 531.72 ± 0.2% | 25.46 ± 1.1% | not timed | not timed | 533.21 ± 0.2% | | 1.00 | 1.00 | 20.86 |
| imported/rsc/reallyhard0-1mb | 51 | 533.79 ± 0.8% | not timed | not timed | 533.58 ± 0.1% | 25.63 ± 0.7% | not timed | not timed | 533.82 ± 0.2% | | 1.00 | 1.00 | 20.83 |
| imported/rsc/reallyreallyhard0-32 | 47 | 256.93 ± 1.2% | not timed | not timed | 184.05 ± 8.6% | 50.29 ± 10.2% | not timed | not timed | 256.65 ± 0.2% | | 1.00 | 1.40 | 5.11 |
| imported/rsc/reallyreallyhard0-1k | 16 | 757.93 ± 0.9% | not timed | not timed | 6402.14 ± 0.5% | 28.20 ± 5.3% | not timed | not timed | 758.58 ± 0.9% | | 1.00 | 0.12 | 26.87 |
| imported/rsc/reallyreallyhard0-32k | 16 | 557.27 ± 4.8% | not timed | not timed | 32652.98 ± 0.4% | 20.98 ± 0.5% | not timed | not timed | 555.18 ± 4.6% | | 1.00 | 0.0171 | 26.56 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 534.24 ± 0.7% | not timed | not timed | 39536.83 ± 0.8% | 20.89 ± 12.9% | not timed | not timed | 534.92 ± 0.3% | | 1.00 | 0.0135 | 25.57 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 250.46 ± 10.2% | not timed | not timed | 190.51 ± 3.8% | 50.85 ± 3.4% | not timed | not timed | 250.98 ± 1.9% | | 1.00 | 1.31 | 4.93 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 739.08 ± 1.1% | not timed | not timed | 6613.44 ± 0.4% | 28.23 ± 0.4% | not timed | not timed | 738.76 ± 0.7% | | 1.00 | 0.11 | 26.18 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 558.31 ± 4.7% | not timed | not timed | 32982.82 ± 1.1% | 21.01 ± 1.3% | not timed | not timed | 556.53 ± 4.9% | | 1.00 | 0.0169 | 26.58 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 534.97 ± 0.2% | not timed | not timed | 39494.04 ± 0.9% | 20.92 ± 0.4% | not timed | not timed | 535.00 ± 0.4% | | 1.00 | 0.0135 | 25.57 |
| imported/sherlock/name-sherlock | 776 | 37959.72 ± 9.2% | not timed | not timed | 31495.56 ± 0.5% | 9575.31 ± 16.4% | not timed | not timed | 37799.96 ± 3.0% | | 1.00 | 1.21 | 3.96 |
| imported/sherlock/name-holmes | 2766 | 19865.65 ± 1.2% | not timed | not timed | 18409.88 ± 0.9% | 3150.76 ± 1.6% | not timed | not timed | 19852.61 ± 1.5% | | 1.00 | 1.08 | 6.31 |
| imported/sherlock/name-sherlock-holmes | 1365 | 37963.24 ± 2.1% | not timed | not timed | 31920.85 ± 1.0% | 7557.60 ± 48.2% | not timed | not timed | 38186.02 ± 2.1% | | 0.99 | 1.19 | 5.02 |
| imported/sherlock/name-sherlock-casei | 816 | 31020.93 ± 0.3% | not timed | not timed | 9458.07 ± 0.1% | 28.56 ± 2.6% | not timed | not timed | 30967.20 ± 0.9% | | 1.00 | 3.28 | 1086.34 |
| imported/sherlock/name-holmes-casei | 2802 | 16787.59 ± 1.1% | not timed | not timed | 5888.25 ± 0.6% | 35.29 ± 1.7% | not timed | not timed | 16802.47 ± 1.7% | | 1.00 | 2.85 | 475.76 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 27122.05 ± 1.2% | not timed | not timed | 9055.82 ± 0.4% | 28.69 ± 1.4% | not timed | not timed | 27304.51 ± 0.9% | | 0.99 | 2.99 | 945.41 |
| imported/sherlock/name-whitespace | 1461 | 21681.60 ± 13.7% | not timed | not timed | 22520.72 ± 0.6% | 6892.27 ± 33.4% | not timed | not timed | 21748.44 ± 3.7% | | 1.00 | 0.96 | 3.15 |
| imported/sherlock/name-alt1 | 1142 | 20299.77 ± 2.5% | not timed | not timed | 23211.70 ± 3.2% | 3720.87 ± 29.3% | not timed | not timed | 20410.18 ± 15.8% | | 0.99 | 0.87 | 5.46 |
| imported/sherlock/name-alt2 | 3542 | 11961.07 ± 2.7% | not timed | not timed | 7771.98 ± 1.7% | 26.80 ± 2.8% | not timed | not timed | 11763.61 ± 20.4% | | 1.02 | 1.54 | 446.38 |
| imported/sherlock/name-alt3 | 4507 | 8338.45 ± 1.0% | not timed | not timed | 6995.62 ± 0.5% | 8.74 ± 27.1% | not timed | not timed | 8367.35 ± 1.2% | | 1.00 | 1.19 | 953.85 |
| imported/sherlock/name-alt3-casei | 4593 | 1564.72 ± 2.1% | not timed | not timed | 1090.31 ± 0.9% | 5.67 ± 18.9% | not timed | not timed | 1565.72 ± 0.2% | | 1.00 | 1.44 | 275.77 |
| imported/sherlock/name-alt4 | 3686 | 6828.24 ± 8.9% | not timed | not timed | 6079.23 ± 1.0% | 27.13 ± 27.6% | not timed | not timed | 6821.08 ± 0.3% | | 1.00 | 1.12 | 251.67 |
| imported/sherlock/name-alt4-casei | 4254 | 3071.77 ± 3.7% | not timed | not timed | 3168.25 ± 13.2% | 16.66 ± 10.6% | not timed | not timed | 3081.38 ± 4.5% | | 1.00 | 0.97 | 184.39 |
| imported/sherlock/name-alt5 | 4028 | 10229.03 ± 2.8% | not timed | not timed | 7422.40 ± 0.4% | 19.44 ± 2.5% | not timed | not timed | 10212.07 ± 1.0% | | 1.00 | 1.38 | 526.09 |
| imported/sherlock/name-alt5-casei | 4104 | 4594.31 ± 5.0% | not timed | not timed | 2385.41 ± 1.0% | 12.33 ± 0.5% | not timed | not timed | 4613.03 ± 8.4% | | 1.00 | 1.93 | 372.60 |
| imported/sherlock/no-match-uncommon | 0 | 52146.47 ± 1.7% | not timed | not timed | 47936.12 ± 19.6% | 44618.29 ± 8.0% | not timed | not timed | 52445.51 ± 0.9% | | 0.99 | 1.09 | 1.17 |
| imported/sherlock/no-match-common | 0 | 50843.47 ± 0.5% | not timed | not timed | 48433.20 ± 2.7% | 1573.02 ± 0.4% | not timed | not timed | 51000.61 ± 19.1% | | 1.00 | 1.05 | 32.32 |
| imported/sherlock/no-match-really-common | 0 | 32154.14 ± 1.5% | not timed | not timed | 29490.59 ± 36.9% | 1575.46 ± 0.1% | not timed | not timed | 32098.81 ± 0.6% | | 1.00 | 1.09 | 20.41 |
| imported/sherlock/the-lower | 21654 | 2459.07 ± 1.3% | not timed | not timed | 2194.55 ± 0.6% | 221.78 ± 19.6% | not timed | not timed | 2453.48 ± 0.7% | | 1.00 | 1.12 | 11.09 |
| imported/sherlock/the-upper | 2223 | 14451.80 ± 0.9% | not timed | not timed | 18582.48 ± 1.6% | 2395.67 ± 14.9% | not timed | not timed | 14345.06 ± 1.6% | | 1.01 | 0.78 | 6.03 |
| imported/sherlock/the-casei | 23961 | 2198.67 ± 0.9% | not timed | not timed | 1112.77 ± 0.8% | 32.44 ± 6.3% | not timed | not timed | 2187.03 ± 0.4% | | 1.01 | 1.98 | 67.77 |
| imported/sherlock/everything-greedy | 581881 | 229.97 ± 0.2% | not timed | not timed | 145.27 ± 0.2% | 24.17 ± 20.8% | not timed | not timed | 234.26 ± 1.0% | | 0.98 | 1.58 | 9.52 |
| imported/sherlock/everything-greedy-nl | 594933 | 405.94 ± 0.5% | not timed | not timed | 186.08 ± 0.7% | 27.15 ± 0.2% | not timed | not timed | 407.01 ± 0.2% | | 1.00 | 2.18 | 14.95 |
| imported/sherlock/letters | 447175 | 43.94 ± 1.1% | not timed | not timed | 30.05 ± 18.4% | 5.42 ± 35.8% | not timed | not timed | 43.82 ± 5.5% | | 1.00 | 1.46 | 8.11 |
| imported/sherlock/letters-upper | 14180 | 374.59 ± 11.3% | not timed | not timed | 320.94 ± 8.1% | 24.93 ± 23.5% | not timed | not timed | 375.74 ± 0.1% | | 1.00 | 1.17 | 15.02 |
| imported/sherlock/letters-lower | 432995 | 44.33 ± 0.3% | not timed | not timed | 29.89 ± 1.1% | 5.14 ± 20.0% | not timed | not timed | 44.61 ± 1.4% | | 0.99 | 1.48 | 8.63 |
| imported/sherlock/words | 447639 | 78.22 ± 10.6% | not timed | not timed | 72.79 ± 0.5% | 12.07 ± 35.2% | not timed | not timed | 78.07 ± 11.1% | | 1.00 | 1.07 | 6.48 |
| imported/sherlock/before-holmes | 4073 | 525.79 ± 0.3% | not timed | not timed | 9817.66 ± 0.5% | 20.30 ± 0.3% | not timed | not timed | 525.67 ± 0.2% | | 1.00 | 0.0536 | 25.90 |
| imported/sherlock/before-after-holmes | 2593 | 527.51 ± 1.0% | not timed | not timed | 11039.57 ± 2.1% | 20.32 ± 0.7% | not timed | not timed | 528.62 ± 0.2% | | 1.00 | 0.0478 | 25.96 |
| imported/sherlock/holmes-cochar-watson | 150 | 7343.18 ± 0.8% | not timed | not timed | 5940.40 ± 0.4% | 26.94 ± 27.3% | not timed | not timed | 7390.81 ± 0.7% | | 0.99 | 1.24 | 272.53 |
| imported/sherlock/holmes-coword-watson | 14309 | 1116.10 ± 0.3% | not timed | not timed | 1076.40 ± 1.0% | 5.07 ± 12.8% | not timed | not timed | 1120.57 ± 0.5% | | 1.00 | 1.04 | 220.02 |
| imported/sherlock/quotes | 14437 | 1120.24 ± 0.6% | not timed | not timed | 1557.11 ± 0.7% | 29.34 ± 0.2% | not timed | not timed | 1121.82 ± 0.3% | | 1.00 | 0.72 | 38.18 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 531.13 ± 0.8% | not timed | not timed | 25120.36 ± 24.5% | 31.74 ± 1.0% | not timed | not timed | 530.97 ± 0.5% | | 1.00 | 0.0211 | 16.73 |
| imported/sherlock/word-ending-n | 35297 | 398.52 ± 0.2% | not timed | not timed | 351.90 ± 0.5% | 20.43 ± 20.4% | not timed | not timed | 398.44 ± 0.6% | | 1.00 | 1.13 | 19.51 |
| imported/sherlock/repeated-class-negation | 2130 | 12184.41 ± 4.8% | not timed | not timed | 11961.81 ± 2.4% | 9.80 ± 0.7% | not timed | not timed | 12179.26 ± 4.2% | | 1.00 | 1.02 | 1243.72 |
| imported/sherlock/ing-suffix | 20547 | 481.70 ± 0.5% | not timed | not timed | 446.67 ± 0.2% | 24.73 ± 0.9% | not timed | not timed | 481.66 ± 0.2% | | 1.00 | 1.08 | 19.48 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 515.17 ± 1.3% | not timed | not timed | 1934.23 ± 1.3% | 17.80 ± 2.3% | not timed | not timed | 515.11 ± 0.3% | | 1.00 | 0.27 | 28.95 |
| opt/accelerate/whole-line | 239963 | 433.14 ± 0.7% | not timed | not timed | 345.15 ± 0.2% | 75.94 ± 16.8% | not timed | not timed | 435.83 ± 0.6% | | 0.99 | 1.25 | 5.70 |
| opt/accelerate/non-dna | 16745 | 370.70 ± 1.3% | not timed | not timed | 369.95 ± 0.9% | 25.52 ± 62.1% | not timed | not timed | 370.64 ± 0.3% | | 1.00 | 1.00 | 14.52 |
| opt/backtrack/words-english | 40536 | 104.35 ± 5.9% | not timed | not timed | 81.89 ± 22.5% | 16.81 ± 8.4% | not timed | not timed | 104.60 ± 3.0% | | 1.00 | 1.27 | 6.21 |
| opt/fixed-length/too-small-ascii | 0 | 300.39 ± 0.4% | not timed | not timed | 621.55 ± 0.2% | 99.80 ± 2.7% | not timed | not timed | 300.30 ± 28.0% | | 1.00 | 0.48 | 3.01 |
| opt/fixed-length/too-big-ascii | 0 | 664.23 ± 7.7% | not timed | not timed | 4919.20 ± 0.2% | 114.77 ± 0.4% | not timed | not timed | 664.25 ± 0.8% | | 1.00 | 0.14 | 5.79 |
| opt/fixed-length/go33484-1 | 0 | 50.73 ± 0.4% | not timed | not timed | 943955.90 ± 0.6% | 67183.31 ± 1.7% | not timed | not timed | 51.70 ± 0.8% | | 0.98 | 0.0001 | 0.0008 |
| opt/fixed-length/go33484-2 | 0 | 3638.68 ± 6.0% | not timed | not timed | 945408.36 ± 0.6% | 23948.61 ± 2.1% | not timed | not timed | 3645.49 ± 0.8% | | 1.00 | 0.0038 | 0.15 |
| opt/fixed-length/go33484-3 | 0 | 1430.42 ± 2.4% | not timed | not timed | 92582.72 ± 2.2% | 707.93 ± 7.4% | not timed | not timed | 1413.20 ± 3.3% | | 1.01 | 0.0155 | 2.02 |
| opt/literal-alt/one-pattern | 1 | 490.20 ± 1.1% | not timed | not timed | 483.92 ± 4.5% | 0.31 ± 0.4% | not timed | not timed | 492.41 ± 0.5% | | 1.00 | 1.01 | 1603.79 |
| opt/onepass/fn-predicate | 916 | 329.56 ± 1.4% | not timed | not timed | 324.48 ± 13.8% | 175.88 ± 43.3% | not timed | not timed | 329.60 ± 1.5% | | 1.00 | 1.02 | 1.87 |
| opt/onepass/first-three-words-english | 35128 | 112.90 ± 2.7% | not timed | not timed | 187.59 ± 0.6% | 60.17 ± 23.5% | not timed | not timed | 112.79 ± 32.2% | | 1.00 | 0.60 | 1.88 |
| opt/prefilter/literal-english | 1 | 54285.87 ± 0.9% | not timed | not timed | 39774.78 ± 0.4% | 19219.10 ± 15.3% | not timed | not timed | 54358.45 ± 0.7% | | 1.00 | 1.36 | 2.82 |
| opt/prefilter/literal-casei-english | 1 | 32911.12 ± 2.5% | not timed | not timed | 11883.85 ± 15.2% | 28.38 ± 1.3% | not timed | not timed | 33180.76 ± 2.1% | | 0.99 | 2.77 | 1159.69 |
| opt/prefilter/literal-russian | 1 | 54879.23 ± 0.6% | not timed | not timed | 39484.06 ± 0.5% | 1580.78 ± 20.9% | not timed | not timed | 55022.41 ± 0.5% | | 1.00 | 1.39 | 34.72 |
| opt/prefilter/literal-casei-russian | 1 | 22108.90 ± 24.6% | not timed | not timed | 8215.25 ± 10.5% | 30.28 ± 0.7% | not timed | not timed | 22107.43 ± 0.2% | | 1.00 | 2.69 | 730.11 |
| opt/prefilter/rust-functions | 948 | 11804.58 ± 7.1% | not timed | not timed | 10287.63 ± 1.9% | 1485.59 ± 1.2% | not timed | not timed | 11681.57 ± 0.7% | | 1.01 | 1.15 | 7.95 |
| opt/reverse-anchored/word-end | 1 | 3672.45 ± 0.3% | not timed | not timed | 22638944.47 ± 1.1% | 41.48 ± 0.4% | not timed | not timed | 3677.30 ± 0.7% | | 1.00 | 0.0002 | 88.53 |
| opt/reverse-inner/holmes | 2593 | 527.66 ± 0.2% | not timed | not timed | 11034.43 ± 0.6% | 18.54 ± 1.4% | not timed | not timed | 528.36 ± 0.2% | | 1.00 | 0.0478 | 28.46 |
| opt/reverse-inner/email | 47 | 908.11 ± 0.4% | not timed | not timed | 57572.25 ± 0.7% | 24.34 ± 5.4% | not timed | not timed | 907.81 ± 0.2% | | 1.00 | 0.0158 | 37.30 |
| opt/reverse-inner/factored-prefix | 3542 | 521.17 ± 0.5% | not timed | not timed | 514.95 ± 0.8% | 10.11 ± 0.4% | not timed | not timed | 521.67 ± 0.6% | | 1.00 | 1.01 | 51.57 |
| opt/reverse-inner/no-quadratic-backward | 0 | 3634.72 ± 0.1% | not timed | not timed | 530.71 ± 1.3% | 62.89 ± 1.8% | not timed | not timed | 3634.47 ± 0.3% | | 1.00 | 6.85 | 57.79 |
| opt/reverse-inner/no-quadratic-forward | 0 | 622.87 ± 4.9% | not timed | not timed | 244.90 ± 0.4% | 21.01 ± 15.7% | not timed | not timed | 622.14 ± 4.6% | | 1.00 | 2.54 | 29.64 |
| opt/reverse-suffix/holmes | 4073 | 525.81 ± 1.2% | not timed | not timed | 9743.35 ± 0.4% | 18.58 ± 17.1% | not timed | not timed | 525.64 ± 0.1% | | 1.00 | 0.0540 | 28.30 |
| opt/reverse-suffix/no-quadratic | 0 | 3636.15 ± 0.2% | not timed | not timed | 531.95 ± 0.3% | 64.37 ± 18.5% | not timed | not timed | 3634.16 ± 0.3% | | 1.00 | 6.84 | 56.49 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 111.39 ± 4.8% | not timed | not timed | 129.14 ± 1.1% | 12.09 ± 14.5% | not timed | not timed | 110.81 ± 2.9% | | 1.01 | 0.86 | 9.21 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 111.47 ± 1.7% | not timed | not timed | 132.03 ± 0.7% | 12.02 ± 29.0% | not timed | not timed | 111.38 ± 1.3% | | 1.00 | 0.84 | 9.28 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.26 ± 0.6% | not timed | not timed | 0.40 ± 0.5% | 92.56 ± 2.3% | not timed | not timed | 0.26 ± 1.8% | | 0.99 | 0.65 | 0.0028 |
| reported/i1095-word-repetition/ascii-search | 256 | 261.97 ± 0.3% | not timed | not timed | 246.43 ± 0.6% | 81.14 ± 0.3% | not timed | not timed | 263.04 ± 0.4% | | 1.00 | 1.06 | 3.23 |
| reported/i13-subset-regex/original-ascii | 4094 | 9995.69 ± 0.7% | not timed | not timed | 3169.49 ± 0.3% | 9.67 ± 1.4% | not timed | not timed | 10007.47 ± 6.5% | | 1.00 | 3.15 | 1033.99 |
| reported/i13-subset-regex/original-unicode | 4094 | 9924.02 ± 2.0% | not timed | not timed | 164.23 ± 2.0% | 9.66 ± 0.7% | not timed | not timed | 9985.07 ± 1.6% | | 0.99 | 60.43 | 1027.35 |
| reported/i13-subset-regex/big-ascii | 1955 | 9425.91 ± 1.4% | not timed | not timed | 44.09 ± 2.2% | 8.26 ± 0.4% | not timed | not timed | 9450.06 ± 0.8% | | 1.00 | 213.77 | 1140.81 |
| reported/i13-subset-regex/big-unicode | 1955 | 9422.78 ± 0.6% | not timed | not timed | 7.86 ± 55.8% | 8.23 ± 0.9% | not timed | not timed | 9448.71 ± 2.1% | | 1.00 | 1198.95 | 1145.09 |
| reported/i13-subset-regex/huge-ascii | 55 | 8848.37 ± 3.2% | not timed | not timed | 6.14 ± 1.3% | 7.26 ± 1.3% | not timed | not timed | 8871.78 ± 1.2% | | 1.00 | 1441.96 | 1217.99 |
| reported/i13-subset-regex/huge-unicode | 55 | 8831.20 ± 4.4% | not timed | not timed | 6.88 ± 0.5% | 7.33 ± 0.5% | not timed | not timed | 8806.89 ± 0.8% | | 1.00 | 1283.10 | 1205.31 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.07 ± 0.4% | not timed | not timed | 6.86 ± 0.5% | 7.29 ± 0.6% | not timed | not timed | 3.02 ± 0.8% | | 1.01 | 0.45 | 0.42 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.32 ± 0.8% | not timed | not timed | 7.11 ± 1.6% | 7.27 ± 0.8% | not timed | not timed | 4.31 ± 0.7% | | 1.00 | 0.61 | 0.59 |
| reported/i787-keywords/ascii | 5674 | 400.37 ± 0.1% | not timed | not timed | 120.90 ± 0.4% | 5.56 ± 0.8% | not timed | not timed | 404.54 ± 0.5% | | 0.99 | 3.31 | 72.07 |
| reported/i787-keywords/opt-ascii | 5674 | 402.52 ± 3.1% | not timed | not timed | 212.22 ± 3.8% | 9.21 ± 0.8% | not timed | not timed | 405.14 ± 0.5% | | 0.99 | 1.90 | 43.69 |
| slow/quadratic-regex-1x | 100 | 6.32 ± 17.1% | not timed | not timed | 4.61 ± 0.1% | 0.04 ± 0.1% | not timed | not timed | 6.31 ± 8.1% | | 1.00 | 1.37 | 149.91 |
| slow/quadratic-regex-2x | 199 | 3.04 ± 6.7% | not timed | not timed | 2.48 ± 3.8% | 0.01 ± 2.9% | not timed | not timed | 2.98 ± 5.1% | | 1.02 | 1.22 | 282.25 |
| slow/quadratic-haystack-1x | 100 | 21.07 ± 12.9% | not timed | not timed | 9.09 ± 1.3% | 0.81 ± 16.4% | not timed | not timed | 21.70 ± 3.6% | | 0.97 | 2.32 | 26.03 |
| slow/quadratic-haystack-2x | 200 | 16.25 ± 3.6% | not timed | not timed | 4.91 ± 0.4% | 0.44 ± 1.0% | not timed | not timed | 16.51 ± 4.8% | | 0.98 | 3.31 | 36.99 |
| unicode/codepoints/any-one | 1112064 | 276.71 ± 0.3% | not timed | not timed | 185.01 ± 1.6% | 15.88 ± 22.9% | not timed | not timed | 277.35 ± 2.3% | | 1.00 | 1.50 | 17.43 |
| unicode/codepoints/any-all | 4382592 | 238.60 ± 0.2% | not timed | not timed | 234.79 ± 4.4% | 97.42 ± 9.3% | not timed | not timed | 237.58 ± 6.7% | | 1.00 | 1.02 | 2.45 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 6.30 ± 1.6% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 533.35 ± 0.2% | not timed | not timed | 533.07 ± 0.4% | 121.52 ± 10.2% | not timed | not timed | 533.03 ± 0.2% | | 1.00 | 1.00 | 4.39 |
| unicode/overlapping-words/ascii | 6156 | 21.40 ± 5.7% | not timed | not timed | 33.67 ± 1.5% | 3.49 ± 0.7% | not timed | not timed | 21.49 ± 5.2% | | 1.00 | 0.64 | 6.14 |
| unicode/overlapping-words/english | 6156 | 1.13 ± 0.8% | not timed | not timed | 2.58 ± 0.1% | 2.16 ± 4.8% | not timed | not timed | 1.14 ± 10.8% | | 0.99 | 0.44 | 0.52 |
| unicode/overlapping-words/russian | 5710 | 1.04 ± 3.9% | not timed | not timed | 2.60 ± 0.4% | 5.28 ± 12.2% | not timed | not timed | 1.06 ± 1.0% | | 0.98 | 0.40 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 98.05 ± 1.5% | not timed | not timed | 73.87 ± 1.4% | 10.09 ± 14.0% | not timed | not timed | 99.50 ± 1.1% | | 0.99 | 1.33 | 9.71 |
| unicode/word/boundary-long-english | 3466 | 532.55 ± 0.1% | not timed | not timed | 522.04 ± 0.2% | 26.76 ± 1.9% | not timed | not timed | 532.89 ± 0.2% | | 1.00 | 1.02 | 19.90 |
| unicode/word/around-holmes-english | 27 | 532.72 ± 0.2% | not timed | not timed | 38015.61 ± 0.8% | 18.48 ± 13.0% | not timed | not timed | 533.05 ± 0.1% | | 1.00 | 0.0140 | 28.83 |
| wild/bibleref/long | 874 | 487.39 ± 0.3% | not timed | not timed | 499.21 ± 1.5% | 6.04 ± 8.9% | not timed | not timed | 487.63 ± 0.4% | | 1.00 | 0.98 | 80.69 |
| wild/bibleref/short | 30 | 16.47 ± 2.1% | not timed | not timed | 25.27 ± 3.5% | 12.58 ± 11.6% | not timed | not timed | 17.19 ± 2.0% | | 0.96 | 0.65 | 1.31 |
| wild/bibleref/line | 874 | 380.52 ± 0.5% | not timed | not timed | 218.13 ± 0.6% | 7.75 ± 0.9% | not timed | not timed | 379.58 ± 1.5% | | 1.00 | 1.74 | 49.13 |
| wild/caddy/caddy | 6 | 355.61 ± 1.2% | not timed | not timed | 248.34 ± 0.5% | 63.08 ± 15.9% | not timed | not timed | 353.01 ± 1.6% | | 1.01 | 1.43 | 5.64 |
| wild/dot-star-capture/rust-src-tools | 6 | 1276.83 ± 0.3% | not timed | not timed | 353.33 ± 1.0% | 11.42 ± 2.0% | not timed | not timed | 1276.30 ± 0.2% | | 1.00 | 3.61 | 111.85 |
| wild/ruff/noqa | 84 | 416.54 ± 0.4% | not timed | not timed | 421.01 ± 1.1% | 16.47 ± 3.6% | not timed | not timed | 419.08 ± 4.6% | | 0.99 | 0.99 | 25.29 |
| wild/ruff/unnecessary-coding-comment | 16 | 467.68 ± 0.6% | not timed | not timed | 605.93 ± 0.5% | 116.67 ± 4.2% | not timed | not timed | 469.37 ± 0.5% | | 1.00 | 0.77 | 4.01 |
| wild/ruff/string-quote-prefix | 2972 | 421.97 ± 1.4% | not timed | not timed | 347.56 ± 0.8% | 308.15 ± 33.7% | not timed | not timed | 423.61 ± 1.2% | | 1.00 | 1.21 | 1.37 |
| wild/ruff/space-around-operator | 1224378 | 183.08 ± 1.3% | not timed | not timed | 184.26 ± 0.2% | 14.73 ± 3.1% | not timed | not timed | 182.87 ± 8.8% | | 1.00 | 0.99 | 12.43 |
| wild/ruff/shebang | 282 | 416.74 ± 0.9% | not timed | not timed | 320.73 ± 11.5% | 94.57 ± 13.3% | not timed | not timed | 417.94 ± 0.4% | | 1.00 | 1.30 | 4.41 |
| wild/rustsec-cargo-audit/original-unix | 471 | 16770.92 ± 4.0% | not timed | not timed | 19511.89 ± 5.5% | 6329.48 ± 25.0% | not timed | not timed | 16943.42 ± 1.4% | | 0.99 | 0.86 | 2.65 |
| wild/rustsec-cargo-audit/original-windows | 462 | 15502.24 ± 1.5% | not timed | not timed | 18706.18 ± 26.8% | 5990.29 ± 0.6% | not timed | not timed | 15600.57 ± 1.5% | | 0.99 | 0.83 | 2.59 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 16772.80 ± 2.2% | not timed | not timed | 19287.25 ± 0.6% | 6081.48 ± 0.8% | not timed | not timed | 16772.84 ± 2.5% | | 1.00 | 0.87 | 2.76 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 13902.37 ± 0.8% | not timed | not timed | 19389.88 ± 0.5% | 6214.98 ± 0.6% | not timed | not timed | 13907.06 ± 1.4% | | 1.00 | 0.72 | 2.24 |
| wild/url/search | 234965 | 102.37 ± 13.7% | not timed | not timed | 48.54 ± 2.4% | 1.89 ± 1.7% | not timed | not timed | 101.48 ± 13.9% | | 1.01 | 2.11 | 54.08 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.02 ± 2.5% | not timed | not timed | 0.01 ± 3.4% | 0.01 ± 25.6% | not timed | not timed | 0.02 ± 26.0% | | 0.99 | 2.44 | 4.12 |
| dictionary/compile/english-15 | 1 | 0.28 ± 34.8% | not timed | not timed | 0.08 ± 2.4% | 0.09 ± 20.6% | not timed | not timed | 0.28 ± 3.6% | | 1.00 | 3.75 | 3.10 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.21 ± 2.6% | not timed | not timed | 0.02 ± 6.1% | 31.64 ± 16.6% | not timed | not timed | 0.22 ± 73.0% | | 0.99 | 10.81 | 0.0068 |
| reported/i1095-word-repetition/ascii-compile | 1 | 35.15 ± 13.0% | not timed | not timed | 13.90 ± 22.8% | 51.01 ± 16.8% | not timed | not timed | 34.56 ± 16.2% | | 1.02 | 2.53 | 0.69 |
| reported/i787-keywords/compile | 1 | 30.32 ± 8.5% | not timed | not timed | 1.97 ± 1.0% | 14.44 ± 26.5% | not timed | not timed | 30.31 ± 15.1% | | 1.00 | 15.41 | 2.10 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 291.56 ± 4.5% | not timed | not timed | 115.37 ± 42.6% | 500.91 ± 26.3% | not timed | not timed | 293.40 ± 4.9% | | 0.99 | 2.53 | 0.58 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 41.86 ± 1.5% | not timed | not timed | 4.22 ± 1.8% | 37.96 ± 7.1% | not timed | not timed | 42.24 ± 1.7% | | 0.99 | 9.91 | 1.10 |
| unicode/compile/one-letter | 53 | 5.44 ± 2.7% | not timed | not timed | 4.52 ± 0.8% | 55.19 ± 50.1% | not timed | not timed | 5.47 ± 3.5% | | 0.99 | 1.20 | 0.0986 |
| unicode/compile/fifty-letters | 1 | 0.91 ± 22.8% | not timed | not timed | 0.10 ± 0.9% | 58.50 ± 21.7% | not timed | not timed | 0.92 ± 10.6% | | 0.99 | 8.86 | 0.0156 |
| unicode/compile/fifty-letters-ascii | 1 | 158.76 ± 16.1% | not timed | not timed | 56.54 ± 0.3% | 146.99 ± 36.3% | not timed | not timed | 161.35 ± 3.4% | | 0.98 | 2.81 | 1.08 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 353.98 ± 2.1% | not timed | not timed | 38.08 ± 0.8% | 590.97 ± 11.4% | not timed | not timed | 354.95 ± 2.5% | | 1.00 | 9.30 | 0.60 |
| unicode/compile/match-every-line-ascii | 4 | 510.24 ± 4.9% | not timed | not timed | 132.65 ± 0.4% | 584.44 ± 29.9% | not timed | not timed | 534.64 ± 7.2% | | 0.95 | 3.85 | 0.87 |
| unicode/compile/negated-class-matches-codepoint | 1 | 293.13 ± 2.5% | not timed | not timed | 42.61 ± 1.1% | 1072.01 ± 11.8% | not timed | not timed | 296.49 ± 2.6% | | 0.99 | 6.88 | 0.27 |
| wild/bibleref/compile | 3 | 4.86 ± 5.7% | not timed | not timed | 1.94 ± 1.1% | 27.02 ± 5.6% | not timed | not timed | 4.87 ± 20.3% | | 1.00 | 2.50 | 0.18 |
| wild/url/compile | 1 | 0.56 ± 0.9% | not timed | not timed | 0.17 ± 1.5% | 0.35 ± 28.7% | not timed | not timed | 0.55 ± 20.9% | | 1.03 | 3.35 | 1.59 |

