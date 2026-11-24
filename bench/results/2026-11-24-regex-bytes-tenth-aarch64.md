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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391528096 |
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
| literal: a word | 217 | 18674.52 ± 2.8% | 5029.23 ± 0.3% | 27.67 ± 0.2% | 17688.84 ± 2.2% | 9162.06 ± 7.2% | 17.60 ± 0.4% | 84.39 ± 0.7% | 18774.02 ± 1.9% | 3.71 | 0.99 | 1.06 | 2.04 |
| literal: a word that is not there | 0 | 20696.96 ± 4.9% | 4910.58 ± 0.6% | 27.81 ± 0.5% | 19277.76 ± 1.3% | 27455.39 ± 4.3% | 17.48 ± 0.2% | 79.82 ± 0.4% | 20762.75 ± 3.6% | 4.21 | 1.00 | 1.07 | 0.75 |
| literal: one of four words | 661 | 6354.07 ± 0.2% | 1946.96 ± 0.1% | 14.20 ± 0.1% | 3948.26 ± 0.2% | 21.91 ± 0.1% | 5.30 ± 0.3% | 6.86 ± 0.3% | 6358.32 ± 0.3% | 3.26 | 1.00 | 1.61 | 289.99 |
| literal: a word in any case | 217 | 14925.01 ± 1.3% | 2085.99 ± 0.2% | 21.09 ± 0.2% | 3970.45 ± 0.1% | 38.03 ± 0.2% | refused | differs | 15048.24 ± 0.4% | 7.15 | 0.99 | 3.76 | 392.49 |
| literal: an href attribute | 33 | 16468.44 ± 3.1% | 609.16 ± 1.1% | 26.56 ± 0.2% | 16652.53 ± 1.9% | 2264.52 ± 0.4% | 13.40 ± 0.4% | 74.10 ± 0.4% | 16646.36 ± 2.7% | 27.03 | 0.99 | 0.99 | 7.27 |
| literal: a word, second text | 123 | 19316.89 ± 9.3% | 3394.19 ± 0.3% | 27.26 ± 0.2% | 18161.31 ± 2.7% | 7668.64 ± 6.4% | 19.75 ± 3.2% | 70.19 ± 1.6% | 19696.09 ± 2.5% | 5.69 | 0.98 | 1.06 | 2.52 |
| class: two capitalized words | 1331 | 1070.69 ± 0.5% | 597.46 ± 0.7% | 25.38 ± 0.1% | 585.26 ± 0.1% | 40.67 ± 0.1% | 15.00 ± 0.2% | 67.41 ± 0.3% | 1071.03 ± 0.2% | 1.79 | 1.00 | 1.83 | 26.33 |
| class: a word that ends in ing | 3399 | 573.17 ± 0.1% | 573.10 ± 0.3% | 17.72 ± 0.1% | 547.66 ± 0.1% | 29.68 ± 2.9% | 8.24 ± 0.2% | 18.42 ± 0.4% | 574.05 ± 0.3% | 1.00 | 1.00 | 1.05 | 19.31 |
| class: a word in capitals | 2332 | 1376.92 ± 0.6% | 604.64 ± 0.2% | 26.86 ± 0.2% | 572.47 ± 0.1% | 43.58 ± 16.7% | 17.27 ± 0.6% | 82.61 ± 0.3% | 1378.09 ± 0.4% | 2.28 | 1.00 | 2.41 | 31.60 |
| class: a number | 8288 | 1993.86 ± 0.2% | 828.87 ± 0.1% | 27.07 ± 0.0% | 1732.54 ± 0.2% | 42.96 ± 16.9% | 0.56 ± 0.5% | 57.48 ± 0.3% | 2000.07 ± 0.2% | 2.41 | 1.00 | 1.15 | 46.41 |
| class: two capitalized words, second text | 5359 | 517.02 ± 0.5% | 524.87 ± 0.4% | 22.70 ± 0.1% | 485.21 ± 0.1% | 35.46 ± 6.6% | 16.74 ± 0.5% | 62.91 ± 0.1% | 516.97 ± 0.3% | 0.99 | 1.00 | 1.07 | 14.58 |
| other: a word between two words | 6104 | 792.18 ± 0.1% | 592.23 ± 0.2% | 23.07 ± 0.1% | 734.64 ± 0.1% | 108.74 ± 16.2% | 11.30 ± 0.2% | 68.39 ± 1.5% | 792.03 ± 0.3% | 1.34 | 1.00 | 1.08 | 7.29 |
| other: a number before a unit, second text | 1481 | 5973.57 ± 1.3% | 1122.95 ± 0.2% | 25.43 ± 0.2% | 5665.92 ± 0.2% | 40.82 ± 0.2% | 17.83 ± 0.2% | 65.85 ± 0.2% | 5963.42 ± 0.9% | 5.32 | 1.00 | 1.05 | 146.35 |
| other: a heading's start tag | 110 | 13828.20 ± 0.9% | 742.80 ± 0.5% | 26.75 ± 0.1% | 1707.53 ± 0.5% | 1574.43 ± 6.3% | 16.34 ± 0.6% | 86.37 ± 0.4% | 13868.35 ± 2.0% | 18.62 | 1.00 | 8.10 | 8.78 |
| other: a whole word | 217 | 15598.75 ± 0.8% | 602.20 ± 0.3% | 28.62 ± 0.2% | 14308.46 ± 1.8% | 49.50 ± 0.3% | 13.85 ± 0.3% | 54.90 ± 0.3% | 15603.05 ± 2.4% | 25.90 | 1.00 | 1.09 | 315.13 |
| other: a line's first word, second text | 3716 | 2029.32 ± 0.3% | 587.48 ± 0.1% | 30.02 ± 0.1% | 1723.59 ± 0.8% | 62.42 ± 8.3% | refused | refused | 2036.94 ± 0.7% | 3.45 | 1.00 | 1.18 | 32.51 |
| other: fourteen octets before an x | 87 | 23037.92 ± 3.7% | 240.94 ± 0.5% | 6.28 ± 0.1% | 3980.54 ± 1.2% | 10.66 ± 0.1% | differs | 17.75 ± 0.4% | 22850.40 ± 5.3% | 95.62 | 1.01 | 5.79 | 2161.18 |
| other: a Greek word | 21815 | 497.58 ± 0.3% | 412.93 ± 0.1% | 30.34 ± 0.2% | 289.21 ± 0.3% | 48.31 ± 10.1% | differs | refused | 499.33 ± 0.3% | 1.21 | 1.00 | 1.72 | 10.30 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.58 ± 0.3% | 19.53 ± 0.4% | 0.85 ± 0.1% | 19.78 ± 0.2% | 2.77 ± 8.0% | differs | 4.03 ± 0.0% | 19.51 ± 0.4% | 1.00 | 1.00 | 0.99 | 7.07 |
| a UUID | 32895 | 21.12 ± 0.2% | 21.06 ± 0.2% | 0.64 ± 0.1% | 15.07 ± 0.6% | 3.09 ± 0.3% | 0.73 ± 0.4% | 3.62 ± 0.4% | 21.06 ± 0.2% | 1.00 | 1.00 | 1.40 | 6.84 |
| an IPv4 address | 33176 | 35.99 ± 0.2% | 35.98 ± 0.1% | 2.05 ± 0.1% | 29.30 ± 0.2% | 6.69 ± 0.1% | differs | 4.14 ± 0.1% | 35.97 ± 0.1% | 1.00 | 1.00 | 1.23 | 5.38 |
| a date and time | 32954 | 31.02 ± 0.7% | 30.87 ± 0.5% | 1.43 ± 0.2% | 21.42 ± 0.4% | 7.04 ± 0.2% | 1.19 ± 0.1% | 7.01 ± 0.7% | 31.02 ± 0.3% | 1.00 | 1.00 | 1.45 | 4.41 |
| a field path | 32606 | 23.15 ± 0.1% | 23.08 ± 0.1% | 1.01 ± 1.0% | 23.18 ± 0.1% | 3.48 ± 1.4% | differs | 2.97 ± 0.3% | 23.09 ± 0.1% | 1.00 | 1.00 | 1.00 | 6.65 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.14 ± 1.2% | 11.13 ± 0.4% | 11.16 ± 1.8% | 11.39 ± 0.2% | 4.98 ± 1.6% | 0.91 ± 0.5% | none | 11.15 ± 0.4% | 1.00 | 1.00 | 0.98 | 2.24 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 226.41 ± 0.8% | 227.63 ± 0.8% | 275.34 ± 0.6% | 87.05 ± 0.9% | 221.04 ± 18.6% | 481.23 ± 0.2% | 3781.65 ± 0.9% | 225.64 ± 0.6% | 0.99 | 1.00 | 2.60 | 1.02 |
| a UUID | 62 | 147.54 ± 0.9% | 148.50 ± 1.1% | 169.24 ± 0.5% | 46.05 ± 0.8% | 98.53 ± 7.8% | 184.44 ± 2.2% | 4154.58 ± 0.6% | 148.11 ± 0.4% | 0.99 | 1.00 | 3.20 | 1.50 |
| an IPv4 address | 29 | 405.29 ± 0.4% | 410.85 ± 0.4% | 594.72 ± 0.4% | 79.32 ± 0.7% | 131.66 ± 0.8% | 303.07 ± 1.4% | 7461.83 ± 0.3% | 405.75 ± 0.2% | 0.99 | 1.00 | 5.11 | 3.08 |
| a date and time | 56 | 294.38 ± 0.2% | 296.64 ± 0.3% | 381.77 ± 0.1% | 73.39 ± 0.3% | 137.33 ± 1.0% | 324.40 ± 3.0% | 4771.57 ± 0.6% | 294.33 ± 0.3% | 0.99 | 1.00 | 4.01 | 2.14 |
| a field path | 39 | 218.63 ± 0.2% | 218.90 ± 1.8% | 263.47 ± 1.1% | 79.52 ± 1.4% | 205.74 ± 1.3% | 492.22 ± 1.8% | 4836.90 ± 3.7% | 216.92 ± 0.5% | 1.00 | 1.01 | 2.75 | 1.06 |
| literal: a word | 7 | 596.11 ± 0.4% | 643.76 ± 0.5% | 1221.81 ± 0.9% | 497.78 ± 0.2% | 633.01 ± 1.7% | 938.19 ± 0.4% | 29662.38 ± 0.2% | 596.60 ± 0.5% | 0.93 | 1.00 | 1.20 | 0.94 |
| literal: a word that is not there | 8 | 574.00 ± 0.2% | 623.07 ± 0.8% | 1151.33 ± 0.6% | 456.35 ± 0.4% | 609.15 ± 1.6% | 883.07 ± 0.2% | 28670.13 ± 0.4% | 574.58 ± 0.1% | 0.92 | 1.00 | 1.26 | 0.94 |
| literal: one of four words | 26 | 234.85 ± 0.4% | 383.84 ± 0.3% | 541.37 ± 0.8% | 50.83 ± 0.6% | 243.92 ± 2.9% | 367.39 ± 0.6% | 15734.69 ± 0.3% | 235.06 ± 0.2% | 0.61 | 1.00 | 4.62 | 0.96 |
| literal: a word in any case | 11 | 432.33 ± 0.5% | 461.32 ± 0.3% | 707.07 ± 0.5% | 15.73 ± 0.1% | 650.67 ± 4.9% | refused | 23540.61 ± 0.3% | 432.41 ± 0.3% | 0.94 | 1.00 | 27.48 | 0.66 |
| literal: an href attribute | 12 | 329.81 ± 0.4% | 342.15 ± 0.2% | 465.79 ± 0.2% | 45.46 ± 0.7% | 503.01 ± 1.4% | 779.63 ± 0.2% | 21396.38 ± 0.4% | 330.24 ± 0.3% | 0.96 | 1.00 | 7.26 | 0.66 |
| literal: a word, second text | 10 | 534.60 ± 0.4% | 586.52 ± 0.4% | 1031.83 ± 0.5% | 411.19 ± 1.9% | 537.79 ± 1.7% | 809.50 ± 0.3% | 26578.11 ± 0.2% | 533.82 ± 0.4% | 0.91 | 1.00 | 1.30 | 0.99 |
| class: two capitalized words | 23 | 414.21 ± 0.6% | 449.35 ± 0.4% | 670.81 ± 0.7% | 101.87 ± 0.9% | 501.47 ± 1.2% | 748.04 ± 0.4% | 6416.36 ± 0.8% | 415.08 ± 0.2% | 0.92 | 1.00 | 4.07 | 0.83 |
| class: a word that ends in ing | 9 | 518.73 ± 0.2% | 587.41 ± 0.7% | 1092.37 ± 0.6% | 133.33 ± 0.7% | 760.03 ± 1.7% | 1107.34 ± 0.7% | 15825.41 ± 1.5% | 519.41 ± 0.3% | 0.88 | 1.00 | 3.89 | 0.68 |
| class: a word in capitals | 16 | 460.25 ± 0.2% | 505.08 ± 0.5% | 849.84 ± 0.2% | 135.58 ± 0.9% | 755.89 ± 0.8% | 1013.66 ± 1.9% | 8470.17 ± 0.2% | 460.25 ± 0.3% | 0.91 | 1.00 | 3.39 | 0.61 |
| class: a number | 6 | 576.77 ± 0.4% | 649.45 ± 0.6% | 1305.71 ± 0.1% | 41.94 ± 1.5% | 1404.36 ± 2.1% | 1863.33 ± 1.7% | 22425.85 ± 0.1% | 577.28 ± 0.4% | 0.89 | 1.00 | 13.75 | 0.41 |
| class: two capitalized words, second text | 23 | 414.98 ± 0.6% | 449.97 ± 0.6% | 672.88 ± 0.7% | 102.25 ± 1.3% | 502.49 ± 1.3% | 736.27 ± 0.8% | 6435.62 ± 0.6% | 415.08 ± 0.3% | 0.92 | 1.00 | 4.06 | 0.83 |
| other: a word between two words | 13 | 515.21 ± 0.4% | 534.25 ± 0.3% | 890.84 ± 0.1% | 133.23 ± 0.5% | 500.90 ± 2.9% | 805.67 ± 0.7% | 14480.55 ± 0.2% | 515.22 ± 0.5% | 0.96 | 1.00 | 3.87 | 1.03 |
| other: a number before a unit, second text | 15 | 377.46 ± 0.4% | 418.92 ± 0.5% | 613.04 ± 0.5% | 39.38 ± 0.5% | 639.20 ± 0.9% | 884.14 ± 0.3% | 15058.13 ± 1.0% | 377.69 ± 0.6% | 0.90 | 1.00 | 9.59 | 0.59 |
| other: a heading's start tag | 13 | 343.23 ± 0.6% | 350.68 ± 0.3% | 475.02 ± 0.7% | 44.03 ± 0.7% | 636.46 ± 0.6% | 865.72 ± 0.6% | 17757.03 ± 0.5% | 343.69 ± 0.5% | 0.98 | 1.00 | 7.80 | 0.54 |
| other: a whole word | 11 | 552.66 ± 0.7% | 589.49 ± 0.6% | 1035.72 ± 0.3% | 118.54 ± 0.5% | 570.30 ± 1.7% | 831.00 ± 0.8% | 26868.09 ± 0.2% | 552.99 ± 0.6% | 0.94 | 1.00 | 4.66 | 0.97 |
| other: a line's first word, second text | 17 | 495.61 ± 0.7% | 518.38 ± 0.3% | 874.89 ± 0.7% | 129.83 ± 0.2% | 710.23 ± 1.3% | refused | refused | 496.06 ± 0.6% | 0.96 | 1.00 | 3.82 | 0.70 |
| other: fourteen octets before an x | 16 | 107.41 ± 1.2% | 152.94 ± 0.6% | 180.49 ± 0.8% | 15.08 ± 0.5% | 459.72 ± 0.7% | 410.11 ± 0.6% | 12668.78 ± 0.5% | 107.48 ± 0.7% | 0.70 | 1.00 | 7.12 | 0.23 |
| other: a Greek word | 8 | 405.52 ± 0.3% | 560.47 ± 0.6% | 1000.82 ± 0.6% | 59.19 ± 0.5% | 1393.30 ± 1.5% | 1862.47 ± 0.4% | refused | 406.13 ± 0.3% | 0.72 | 1.00 | 6.85 | 0.29 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15542.05 ± 0.6% | not timed | not timed | 16014.94 ± 0.5% | 2070.41 ± 9.9% | not timed | not timed | 15504.13 ± 0.9% | | 1.00 | 0.97 | 7.51 |
| 01-literal/sherlock-casei-en | 522 | 10764.98 ± 6.7% | not timed | not timed | 3587.31 ± 0.4% | 32.52 ± 6.0% | not timed | not timed | 10911.84 ± 1.9% | | 0.99 | 3.00 | 331.05 |
| 01-literal/sherlock-ru | 724 | 17168.20 ± 0.9% | not timed | not timed | 17253.25 ± 0.5% | 1535.64 ± 14.6% | not timed | not timed | 17182.09 ± 0.3% | | 1.00 | 1.00 | 11.18 |
| 01-literal/sherlock-casei-ru | 746 | 6170.24 ± 0.2% | not timed | not timed | 3328.89 ± 0.1% | 30.91 ± 0.5% | not timed | not timed | 6178.48 ± 0.1% | | 1.00 | 1.85 | 199.61 |
| 01-literal/sherlock-zh | 30 | 19398.72 ± 0.6% | not timed | not timed | 18387.10 ± 1.5% | 2610.13 ± 2.1% | not timed | not timed | 19413.01 ± 1.2% | | 1.00 | 1.06 | 7.43 |
| 02-literal-alternate/sherlock-en | 714 | 6042.05 ± 0.5% | not timed | not timed | 3934.06 ± 0.3% | 16.62 ± 0.2% | not timed | not timed | 6058.90 ± 0.9% | | 1.00 | 1.54 | 363.59 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1980.57 ± 1.1% | not timed | not timed | 699.16 ± 0.3% | 11.11 ± 0.2% | not timed | not timed | 1986.26 ± 0.9% | | 1.00 | 2.83 | 178.24 |
| 02-literal-alternate/sherlock-ru | 899 | 5563.39 ± 0.2% | not timed | not timed | 3261.90 ± 0.2% | 22.64 ± 0.1% | not timed | not timed | 5570.57 ± 0.3% | | 1.00 | 1.71 | 245.69 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2057.93 ± 0.6% | not timed | not timed | 1233.89 ± 0.4% | 9.12 ± 0.2% | not timed | not timed | 2058.47 ± 0.7% | | 1.00 | 1.67 | 225.76 |
| 02-literal-alternate/sherlock-zh | 207 | 7292.90 ± 0.7% | not timed | not timed | 4162.42 ± 0.1% | 31.53 ± 0.1% | not timed | not timed | 7301.93 ± 0.6% | | 1.00 | 1.75 | 231.29 |
| 03-date/ascii | 111817 | 124.78 ± 1.0% | not timed | not timed | 95.57 ± 0.1% | 0.20 ± 2.4% | not timed | not timed | 124.73 ± 0.5% | | 1.00 | 1.31 | 612.96 |
| 04-ruff-noqa/real | 84 | 404.20 ± 0.2% | not timed | not timed | 458.33 ± 0.1% | 19.53 ± 0.3% | not timed | not timed | 404.69 ± 0.2% | | 1.00 | 0.88 | 20.69 |
| 04-ruff-noqa/tweaked | 44 | 557.40 ± 0.4% | not timed | not timed | 457.87 ± 0.1% | 366.44 ± 0.4% | not timed | not timed | 557.42 ± 0.4% | | 1.00 | 1.22 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.31 ± 0.2% | not timed | not timed | 4.94 ± 0.2% | 0.20 ± 4.6% | not timed | not timed | 5.32 ± 1.2% | | 1.00 | 1.08 | 26.20 |
| 06-cloud-flare-redos/original | 107 | 415.18 ± 0.3% | not timed | not timed | 217.41 ± 0.0% | 24.80 ± 0.1% | not timed | not timed | 415.35 ± 0.2% | | 1.00 | 1.91 | 16.74 |
| 06-cloud-flare-redos/simplified-short | 102 | 415.49 ± 0.1% | not timed | not timed | 228.50 ± 0.1% | 26.64 ± 0.4% | not timed | not timed | 409.83 ± 0.3% | | 1.01 | 1.82 | 15.60 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.81 ± 0.1% | not timed | not timed | 255.05 ± 0.1% | 28.82 ± 0.0% | not timed | not timed | 578.35 ± 0.1% | | 1.02 | 2.30 | 20.39 |
| 07-unicode-character-data/parse-line | 558784 | 242.45 ± 2.3% | not timed | not timed | 173.01 ± 0.1% | 43.26 ± 6.5% | not timed | not timed | 243.08 ± 1.6% | | 1.00 | 1.40 | 5.60 |
| 08-words/all-english | 56691 | 116.64 ± 0.8% | not timed | not timed | 82.80 ± 0.1% | 12.75 ± 8.4% | not timed | not timed | 116.63 ± 0.5% | | 1.00 | 1.41 | 9.15 |
| 08-words/long-english | 839 | 612.94 ± 0.5% | not timed | not timed | 596.42 ± 0.1% | 32.45 ± 0.9% | not timed | not timed | 613.33 ± 0.6% | | 1.00 | 1.03 | 18.89 |
| 09-aws-keys/full | 0 | 409.16 ± 0.1% | not timed | not timed | 462.93 ± 0.1% | 64.64 ± 3.5% | not timed | not timed | 410.24 ± 0.1% | | 1.00 | 0.88 | 6.33 |
| 09-aws-keys/quick | 0 | 872.69 ± 0.3% | not timed | not timed | 986.35 ± 0.3% | 422.95 ± 1.3% | not timed | not timed | 874.00 ± 0.2% | | 1.00 | 0.88 | 2.06 |
| 10-bounded-repeat/letters-en | 1833 | 581.28 ± 2.4% | not timed | not timed | 516.75 ± 0.5% | 19.58 ± 0.5% | not timed | not timed | 580.24 ± 1.0% | | 1.00 | 1.12 | 29.69 |
| 10-bounded-repeat/letters-ru | 3475 | 510.27 ± 1.7% | not timed | not timed | 477.80 ± 0.2% | 22.41 ± 16.4% | not timed | not timed | 511.30 ± 0.6% | | 1.00 | 1.07 | 22.77 |
| 10-bounded-repeat/context | 53 | 85.19 ± 1.6% | not timed | not timed | 65.84 ± 0.6% | 19.83 ± 0.1% | not timed | not timed | 85.17 ± 1.6% | | 1.00 | 1.29 | 4.30 |
| 10-bounded-repeat/capitals | 11 | 641.56 ± 8.0% | not timed | not timed | 618.38 ± 0.0% | 36.55 ± 0.2% | not timed | not timed | 640.64 ± 8.1% | | 1.00 | 1.04 | 17.55 |
| 11-unstructured-to-json/extract | 600 | 56.87 ± 1.1% | not timed | not timed | 77.33 ± 0.1% | 49.06 ± 7.2% | not timed | not timed | 56.90 ± 0.8% | | 1.00 | 0.74 | 1.16 |
| 12-dictionary/single | 1 | 567.43 ± 0.3% | not timed | not timed | 560.28 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 568.87 ± 0.2% | | 1.00 | 1.01 | 1418.44 |
| 14-quadratic/1x | 100 | 21.17 ± 0.7% | not timed | not timed | 9.98 ± 0.1% | 0.97 ± 2.9% | not timed | not timed | 21.17 ± 1.6% | | 1.00 | 2.12 | 21.88 |
| 14-quadratic/2x | 200 | 17.42 ± 0.7% | not timed | not timed | 5.54 ± 0.4% | 0.53 ± 1.5% | not timed | not timed | 17.39 ± 0.5% | | 1.00 | 3.14 | 32.94 |
| 14-quadratic/10x | 1000 | 7.68 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 7.70 ± 0.5% | | 1.00 | 6.35 | 66.66 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.22 ± 1.2% | not timed | not timed | 0.34 ± 0.9% | 0.55 ± 7.1% | not timed | not timed | 1.23 ± 0.6% | | 0.99 | 3.56 | 2.23 |
| 04-ruff-noqa/compile-real | 1 | 104.81 ± 1.1% | not timed | not timed | 13.65 ± 0.6% | 140.36 ± 1.3% | not timed | not timed | 104.94 ± 1.4% | | 1.00 | 7.68 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 14.03 ± 0.7% | not timed | not timed | 2.52 ± 1.2% | 6.48 ± 1.8% | not timed | not timed | 14.06 ± 1.1% | | 1.00 | 5.57 | 2.17 |
| 07-unicode-character-data/compile | 1 | 107.20 ± 0.2% | not timed | not timed | 25.97 ± 0.4% | 36.23 ± 3.3% | not timed | not timed | 107.54 ± 1.0% | | 1.00 | 4.13 | 2.96 |
| 09-aws-keys/compile-full | 1 | 52.85 ± 0.3% | not timed | not timed | 8.27 ± 0.6% | 23.42 ± 0.5% | not timed | not timed | 53.01 ± 0.4% | | 1.00 | 6.39 | 2.26 |
| 09-aws-keys/compile-quick | 1 | 181.91 ± 0.7% | not timed | not timed | 47.35 ± 0.2% | 134.71 ± 2.8% | not timed | not timed | 182.19 ± 0.9% | | 1.00 | 3.84 | 1.35 |
| 10-bounded-repeat/compile-context | 1 | 70.70 ± 1.5% | not timed | not timed | 11.24 ± 0.3% | 16.13 ± 1.6% | not timed | not timed | 71.54 ± 1.9% | | 0.99 | 6.29 | 4.38 |
| 10-bounded-repeat/compile-capitals | 1 | 84.08 ± 0.8% | not timed | not timed | 8.01 ± 0.3% | 23.74 ± 0.6% | not timed | not timed | 83.98 ± 0.1% | | 1.00 | 10.49 | 3.54 |
| 11-unstructured-to-json/compile | 1 | 169.21 ± 1.0% | not timed | not timed | 41.29 ± 0.3% | 68.60 ± 2.6% | not timed | not timed | 169.66 ± 0.6% | | 1.00 | 4.10 | 2.47 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.3% | not timed | not timed | 0.07 ± 0.1% | 0.10 ± 18.7% | not timed | not timed | 0.35 ± 0.6% | | 1.00 | 4.96 | 3.54 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.55 ± 0.7% | not timed | not timed | 6.48 ± 0.2% | 0.55 ± 5.5% | not timed | not timed | 7.55 ± 2.4% | | 1.00 | 1.16 | 13.72 |
| dictionary/search/english-10 | 690 | 1.05 ± 0.4% | not timed | not timed | 165.00 ± 1.0% | 0.00 ± 0.2% | not timed | not timed | 1.05 ± 0.4% | | 1.00 | 0.0064 | 365.55 |
| dictionary/search/english-15 | 15 | 560.45 ± 0.3% | not timed | not timed | 560.05 ± 0.1% | 0.37 ± 0.1% | not timed | not timed | 561.24 ± 0.8% | | 1.00 | 1.00 | 1515.75 |
| folly/awyer-inn-busted | 1 | 5586.76 ± 0.2% | not timed | not timed | 142.22 ± 0.3% | 44.04 ± 0.2% | not timed | not timed | 5572.77 ± 0.2% | | 1.00 | 39.28 | 126.86 |
| folly/literal-never-match-rare | 0 | 21111.63 ± 0.5% | not timed | not timed | 19897.56 ± 0.2% | 40843.90 ± 1.1% | not timed | not timed | 21120.14 ± 0.4% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12535.69 ± 1.6% | not timed | not timed | 19852.28 ± 0.7% | 2197.69 ± 0.2% | not timed | not timed | 12577.51 ± 1.1% | | 1.00 | 0.63 | 5.70 |
| folly/literal-never-match-tricksy | 1 | 3261.04 ± 0.2% | not timed | not timed | 4408.31 ± 0.1% | 3055.26 ± 0.2% | not timed | not timed | 3245.56 ± 0.4% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1312.47 ± 0.5% | not timed | not timed | 951.84 ± 0.2% | 387.43 ± 18.2% | not timed | not timed | 1313.65 ± 0.5% | | 1.00 | 1.38 | 3.39 |
| grep/long-words-ascii | 5073 | 459.84 ± 0.1% | not timed | not timed | 469.51 ± 0.1% | 46.23 ± 7.6% | not timed | not timed | 459.89 ± 0.3% | | 1.00 | 0.98 | 9.95 |
| imported/leipzig/twain | 811 | 20684.78 ± 3.7% | not timed | not timed | 19541.87 ± 0.4% | 11960.26 ± 10.9% | not timed | not timed | 20712.61 ± 0.8% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9061.60 ± 1.1% | not timed | not timed | 4250.95 ± 0.1% | 37.76 ± 0.2% | not timed | not timed | 9089.00 ± 1.0% | | 1.00 | 2.13 | 240.00 |
| imported/leipzig/shing | 1540 | 629.40 ± 0.1% | not timed | not timed | 13209.97 ± 1.1% | 34.03 ± 0.1% | not timed | not timed | 631.67 ± 0.1% | | 1.00 | 0.0476 | 18.49 |
| imported/leipzig/huck-saw | 262 | 8226.72 ± 3.0% | not timed | not timed | 5601.83 ± 0.1% | 31.99 ± 0.1% | not timed | not timed | 8464.46 ± 3.1% | | 0.97 | 1.47 | 257.16 |
| imported/leipzig/word-ending-nn | 262 | 607.46 ± 0.3% | not timed | not timed | 616.89 ± 0.1% | 24.58 ± 0.8% | not timed | not timed | 611.06 ± 0.1% | | 0.99 | 0.98 | 24.72 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11100.77 ± 0.7% | not timed | not timed | 4525.96 ± 0.5% | 11.50 ± 0.2% | not timed | not timed | 11112.21 ± 1.1% | | 1.00 | 2.45 | 965.08 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7813.33 ± 2.2% | not timed | not timed | 5491.28 ± 0.1% | 16.85 ± 0.0% | not timed | not timed | 7922.98 ± 2.1% | | 0.99 | 1.42 | 463.81 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4183.95 ± 1.3% | not timed | not timed | 414.37 ± 3.4% | 11.10 ± 0.1% | not timed | not timed | 4201.04 ± 1.1% | | 1.00 | 10.10 | 376.85 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 609.90 ± 0.1% | not timed | not timed | 614.86 ± 0.4% | 11.14 ± 0.2% | not timed | not timed | 608.92 ± 0.3% | | 1.00 | 0.99 | 54.77 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.39 ± 0.1% | not timed | not timed | 615.48 ± 0.1% | 9.75 ± 0.1% | not timed | not timed | 610.32 ± 0.1% | | 1.00 | 0.99 | 62.53 |
| imported/leipzig/tom-river | 2 | 6518.41 ± 1.8% | not timed | not timed | 5150.51 ± 0.2% | 30.93 ± 0.1% | not timed | not timed | 6621.74 ± 2.2% | | 0.98 | 1.27 | 210.75 |
| imported/leipzig/ing | 78424 | 609.29 ± 0.5% | not timed | not timed | 572.07 ± 0.2% | 28.14 ± 3.3% | not timed | not timed | 607.59 ± 0.7% | | 1.00 | 1.07 | 21.65 |
| imported/leipzig/ing-whitespace | 55248 | 757.07 ± 1.0% | not timed | not timed | 2077.11 ± 0.6% | 20.53 ± 2.9% | not timed | not timed | 759.88 ± 0.5% | | 1.00 | 0.36 | 36.88 |
| imported/leipzig/awyer-inn | 209 | 774.39 ± 1.5% | not timed | not timed | 4270.49 ± 0.2% | 22.68 ± 0.0% | not timed | not timed | 775.46 ± 1.3% | | 1.00 | 0.18 | 34.15 |
| imported/leipzig/quotes-bounded | 8886 | 2125.01 ± 0.4% | not timed | not timed | 3017.67 ± 0.4% | 38.24 ± 0.0% | not timed | not timed | 2122.78 ± 0.4% | | 1.00 | 0.70 | 55.57 |
| imported/leipzig/non-ascii-alternate | 2 | 12838.27 ± 2.9% | not timed | not timed | 5671.53 ± 0.1% | 50.59 ± 0.1% | not timed | not timed | 13092.61 ± 2.5% | | 0.98 | 2.26 | 253.78 |
| imported/leipzig/math-symbols | 69 | 1970.40 ± 0.4% | not timed | not timed | 619.14 ± 0.1% | 36.49 ± 0.2% | not timed | not timed | 1968.89 ± 0.6% | | 1.00 | 3.18 | 53.99 |
| imported/leipzig/bounded-strings-ending-z | 0 | 596.04 ± 0.1% | not timed | not timed | 616.37 ± 0.1% | 22.58 ± 0.3% | not timed | not timed | 595.54 ± 0.3% | | 1.00 | 0.97 | 26.40 |
| imported/lh3lh3-reb/uri | 17549 | 632.14 ± 0.1% | not timed | not timed | 1060.02 ± 0.2% | 28.12 ± 4.1% | not timed | not timed | 633.10 ± 0.1% | | 1.00 | 0.60 | 22.48 |
| imported/lh3lh3-reb/email | 15057 | 668.19 ± 0.3% | not timed | not timed | 1158.29 ± 0.1% | 30.87 ± 2.3% | not timed | not timed | 668.51 ± 0.1% | | 1.00 | 0.58 | 21.64 |
| imported/lh3lh3-reb/date | 668 | 865.61 ± 0.2% | not timed | not timed | 1032.90 ± 0.2% | 49.77 ± 3.8% | not timed | not timed | 865.09 ± 0.1% | | 1.00 | 0.84 | 17.39 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 642.59 ± 0.1% | not timed | not timed | 421.62 ± 0.1% | 15.75 ± 1.4% | not timed | not timed | 643.40 ± 0.1% | | 1.00 | 1.52 | 40.79 |
| imported/mariomka/email | 92 | 704.95 ± 0.2% | not timed | not timed | 29528.51 ± 0.8% | 32.82 ± 0.2% | not timed | not timed | 706.29 ± 0.1% | | 1.00 | 0.0239 | 21.48 |
| imported/mariomka/uri | 5301 | 608.52 ± 0.1% | not timed | not timed | 6078.01 ± 0.3% | 32.62 ± 0.7% | not timed | not timed | 606.13 ± 0.2% | | 1.00 | 0.10 | 18.65 |
| imported/mariomka/ip | 5 | 2158.52 ± 2.2% | not timed | not timed | 2973.41 ± 0.2% | 21.12 ± 0.4% | not timed | not timed | 2151.02 ± 2.3% | | 1.00 | 0.73 | 102.21 |
| imported/rsc/no-exponential | 0 | 567.16 ± 0.1% | not timed | not timed | 318.68 ± 0.1% | 23.84 ± 0.1% | not timed | not timed | 570.18 ± 0.1% | | 0.99 | 1.78 | 23.79 |
| imported/rsc/literal | 1 | 737.60 ± 3.2% | not timed | not timed | 1601.08 ± 8.6% | 185.44 ± 15.8% | not timed | not timed | 742.35 ± 4.8% | | 0.99 | 0.46 | 3.98 |
| imported/rsc/not-literal | 2 | 706.92 ± 0.1% | not timed | not timed | 735.87 ± 0.5% | 46.51 ± 4.0% | not timed | not timed | 708.53 ± 6.9% | | 1.00 | 0.96 | 15.20 |
| imported/rsc/match-class | 1 | 1304.13 ± 0.3% | not timed | not timed | 1188.10 ± 0.1% | 58.78 ± 13.8% | not timed | not timed | 1310.77 ± 2.1% | | 0.99 | 1.10 | 22.18 |
| imported/rsc/match-class-in-range | 1 | 1310.44 ± 0.3% | not timed | not timed | 2350.95 ± 8.0% | 60.27 ± 7.1% | not timed | not timed | 1312.85 ± 2.1% | | 1.00 | 0.56 | 21.74 |
| imported/rsc/match-class-unicode | 1 | 525.24 ± 0.2% | not timed | not timed | 515.26 ± 0.2% | 72.54 ± 0.3% | not timed | not timed | 525.48 ± 0.1% | | 1.00 | 1.02 | 7.24 |
| imported/rsc/anchored-literal-short-non-match | 0 | 536.89 ± 0.9% | not timed | not timed | 933.26 ± 0.1% | 227.66 ± 0.4% | not timed | not timed | 534.93 ± 0.5% | | 1.00 | 0.58 | 2.36 |
| imported/rsc/anchored-literal-long-non-match | 0 | 7949.92 ± 0.2% | not timed | not timed | 14243.90 ± 0.1% | 3416.38 ± 0.4% | not timed | not timed | 7934.23 ± 0.2% | | 1.00 | 0.56 | 2.33 |
| imported/rsc/anchored-literal-short-match | 4 | 416.61 ± 2.0% | not timed | not timed | 474.96 ± 0.4% | 83.42 ± 3.8% | not timed | not timed | 421.32 ± 5.9% | | 0.99 | 0.88 | 4.99 |
| imported/rsc/anchored-literal-long-match | 4 | 3018.14 ± 1.5% | not timed | not timed | 7318.91 ± 0.3% | 1238.47 ± 4.7% | not timed | not timed | 3027.60 ± 1.7% | | 1.00 | 0.41 | 2.44 |
| imported/rsc/one-pass-short | 17 | 312.21 ± 2.1% | not timed | not timed | 213.40 ± 0.3% | 32.07 ± 13.7% | not timed | not timed | 312.71 ± 11.0% | | 1.00 | 1.46 | 9.73 |
| imported/rsc/one-pass-short-not | 17 | 219.76 ± 6.4% | not timed | not timed | 225.44 ± 0.3% | 31.37 ± 12.2% | not timed | not timed | 219.59 ± 1.9% | | 1.00 | 0.97 | 7.01 |
| imported/rsc/one-pass-long-prefix | 26 | 231.77 ± 8.3% | not timed | not timed | 284.14 ± 0.2% | 97.46 ± 17.4% | not timed | not timed | 238.29 ± 0.2% | | 0.97 | 0.82 | 2.38 |
| imported/rsc/one-pass-long-prefix-not | 26 | 314.92 ± 1.9% | not timed | not timed | 284.53 ± 0.5% | 64.44 ± 13.0% | not timed | not timed | 313.49 ± 2.1% | | 1.00 | 1.11 | 4.89 |
| imported/rsc/long-needle1 | 31 | 21942.00 ± 0.2% | not timed | not timed | 20122.11 ± 0.1% | 3.78 ± 0.4% | not timed | not timed | 21962.00 ± 0.3% | | 1.00 | 1.09 | 5811.77 |
| imported/rsc/long-needle2 | 31 | 22090.40 ± 0.1% | not timed | not timed | 215.85 ± 0.5% | 3.76 ± 0.1% | not timed | not timed | 22127.89 ± 0.2% | | 1.00 | 102.34 | 5869.54 |
| imported/rsc/easy0-32 | 26 | 1052.34 ± 10.5% | not timed | not timed | 1574.53 ± 4.8% | 145.28 ± 18.8% | not timed | not timed | 1046.79 ± 2.8% | | 1.01 | 0.67 | 7.24 |
| imported/rsc/easy0-1k | 26 | 15014.87 ± 0.1% | not timed | not timed | 12530.89 ± 1.9% | 2272.86 ± 12.4% | not timed | not timed | 14999.88 ± 1.6% | | 1.00 | 1.20 | 6.61 |
| imported/rsc/easy0-32k | 26 | 22898.56 ± 1.6% | not timed | not timed | 20329.27 ± 0.2% | 18797.32 ± 28.0% | not timed | not timed | 22910.74 ± 0.2% | | 1.00 | 1.13 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21293.57 ± 3.5% | not timed | not timed | 19553.16 ± 2.7% | 34902.31 ± 2.3% | not timed | not timed | 21234.37 ± 2.7% | | 1.00 | 1.09 | 0.61 |
| imported/rsc/easy1-32 | 19 | 359.41 ± 1.7% | not timed | not timed | 638.72 ± 0.3% | 128.89 ± 15.2% | not timed | not timed | 360.61 ± 1.8% | | 1.00 | 0.56 | 2.79 |
| imported/rsc/easy1-1k | 19 | 584.14 ± 2.5% | not timed | not timed | 12964.38 ± 0.2% | 2433.91 ± 15.2% | not timed | not timed | 582.83 ± 0.4% | | 1.00 | 0.0451 | 0.24 |
| imported/rsc/easy1-32k | 19 | 602.37 ± 0.4% | not timed | not timed | 403821.28 ± 0.1% | 20463.14 ± 0.4% | not timed | not timed | 600.33 ± 0.4% | | 1.00 | 0.0015 | 0.0294 |
| imported/rsc/easy1-1mb | 19 | 602.24 ± 0.8% | not timed | not timed | 13077448.98 ± 0.2% | 36375.80 ± 6.5% | not timed | not timed | 602.15 ± 1.1% | | 1.00 | 0.0000 | 0.0166 |
| imported/rsc/medium-32 | 27 | 424.59 ± 2.2% | not timed | not timed | 641.06 ± 0.4% | 69.49 ± 11.2% | not timed | not timed | 425.40 ± 0.1% | | 1.00 | 0.66 | 6.11 |
| imported/rsc/medium-1k | 27 | 6744.12 ± 0.1% | not timed | not timed | 11352.14 ± 0.3% | 72.19 ± 0.2% | not timed | not timed | 6743.26 ± 0.2% | | 1.00 | 0.59 | 93.42 |
| imported/rsc/medium-32k | 27 | 21569.94 ± 0.1% | not timed | not timed | 347464.77 ± 0.2% | 48.70 ± 0.1% | not timed | not timed | 21576.37 ± 0.1% | | 1.00 | 0.0621 | 442.96 |
| imported/rsc/medium-1mb | 27 | 20983.38 ± 3.2% | not timed | not timed | 11324630.69 ± 0.2% | 48.62 ± 0.2% | not timed | not timed | 21173.48 ± 2.6% | | 0.99 | 0.0019 | 431.60 |
| imported/rsc/hard-32 | 58 | 255.31 ± 2.0% | not timed | not timed | 368.44 ± 0.1% | 49.18 ± 6.8% | not timed | not timed | 255.74 ± 0.1% | | 1.00 | 0.69 | 5.19 |
| imported/rsc/hard-1k | 27 | 577.32 ± 0.3% | not timed | not timed | 11645.93 ± 0.0% | 40.75 ± 0.1% | not timed | not timed | 574.26 ± 0.3% | | 1.01 | 0.0496 | 14.17 |
| imported/rsc/hard-32k | 27 | 601.48 ± 0.6% | not timed | not timed | 362692.70 ± 0.5% | 29.36 ± 0.1% | not timed | not timed | 598.56 ± 0.6% | | 1.00 | 0.0017 | 20.48 |
| imported/rsc/hard-1mb | 51 | 604.11 ± 0.7% | not timed | not timed | 7244768.42 ± 0.1% | 29.41 ± 0.3% | not timed | not timed | 599.90 ± 0.8% | | 1.01 | 0.0001 | 20.54 |
| imported/rsc/reallyhard0-32 | 58 | 254.35 ± 0.2% | not timed | not timed | 222.59 ± 0.1% | 49.29 ± 6.7% | not timed | not timed | 255.33 ± 2.6% | | 1.00 | 1.14 | 5.16 |
| imported/rsc/reallyhard0-1k | 27 | 575.00 ± 0.4% | not timed | not timed | 572.38 ± 0.2% | 40.70 ± 0.1% | not timed | not timed | 578.05 ± 0.3% | | 0.99 | 1.00 | 14.13 |
| imported/rsc/reallyhard0-32k | 27 | 600.12 ± 0.5% | not timed | not timed | 619.03 ± 0.1% | 29.38 ± 0.1% | not timed | not timed | 603.25 ± 0.7% | | 0.99 | 0.97 | 20.43 |
| imported/rsc/reallyhard0-1mb | 51 | 592.97 ± 0.5% | not timed | not timed | 612.93 ± 0.2% | 29.42 ± 0.1% | not timed | not timed | 591.91 ± 1.2% | | 1.00 | 0.97 | 20.16 |
| imported/rsc/reallyreallyhard0-32 | 47 | 274.02 ± 0.1% | not timed | not timed | 196.77 ± 0.9% | 60.42 ± 8.7% | not timed | not timed | 274.30 ± 4.5% | | 1.00 | 1.39 | 4.54 |
| imported/rsc/reallyreallyhard0-1k | 16 | 886.16 ± 0.9% | not timed | not timed | 5924.56 ± 0.1% | 33.47 ± 2.4% | not timed | not timed | 886.00 ± 1.3% | | 1.00 | 0.15 | 26.47 |
| imported/rsc/reallyreallyhard0-32k | 16 | 625.55 ± 4.1% | not timed | not timed | 19311.72 ± 0.1% | 24.86 ± 0.3% | not timed | not timed | 620.60 ± 5.2% | | 1.01 | 0.0324 | 25.16 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 591.19 ± 0.7% | not timed | not timed | 19910.06 ± 1.4% | 24.88 ± 2.1% | not timed | not timed | 586.29 ± 1.3% | | 1.01 | 0.0297 | 23.76 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 269.37 ± 3.0% | not timed | not timed | 214.47 ± 0.5% | 60.36 ± 11.3% | not timed | not timed | 268.64 ± 0.2% | | 1.00 | 1.26 | 4.46 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 842.75 ± 1.3% | not timed | not timed | 6243.56 ± 0.1% | 34.14 ± 1.7% | not timed | not timed | 841.65 ± 1.4% | | 1.00 | 0.13 | 24.69 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 641.75 ± 8.7% | not timed | not timed | 19236.35 ± 0.1% | 25.05 ± 1.4% | not timed | not timed | 635.61 ± 7.8% | | 1.01 | 0.0334 | 25.62 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 594.91 ± 1.0% | not timed | not timed | 19184.32 ± 3.5% | 24.98 ± 0.2% | not timed | not timed | 589.76 ± 1.2% | | 1.01 | 0.0310 | 23.81 |
| imported/sherlock/name-sherlock | 776 | 19620.64 ± 3.7% | not timed | not timed | 18396.10 ± 0.2% | 8738.01 ± 22.4% | not timed | not timed | 19664.23 ± 2.4% | | 1.00 | 1.07 | 2.25 |
| imported/sherlock/name-holmes | 2766 | 14723.94 ± 5.3% | not timed | not timed | 15444.00 ± 0.6% | 3335.46 ± 5.8% | not timed | not timed | 15258.47 ± 5.7% | | 0.96 | 0.95 | 4.41 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19604.56 ± 1.5% | not timed | not timed | 18316.33 ± 0.3% | 8072.54 ± 13.8% | not timed | not timed | 19654.80 ± 0.4% | | 1.00 | 1.07 | 2.43 |
| imported/sherlock/name-sherlock-casei | 816 | 15553.00 ± 0.3% | not timed | not timed | 4012.13 ± 0.1% | 32.46 ± 0.3% | not timed | not timed | 15535.27 ± 0.5% | | 1.00 | 3.88 | 479.15 |
| imported/sherlock/name-holmes-casei | 2802 | 9372.81 ± 6.8% | not timed | not timed | 3316.88 ± 0.3% | 37.57 ± 0.4% | not timed | not timed | 9369.55 ± 7.7% | | 1.00 | 2.83 | 249.50 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13000.18 ± 2.8% | not timed | not timed | 3952.03 ± 0.1% | 32.59 ± 0.2% | not timed | not timed | 12980.08 ± 1.2% | | 1.00 | 3.29 | 398.92 |
| imported/sherlock/name-whitespace | 1461 | 14956.11 ± 0.2% | not timed | not timed | 14367.21 ± 0.3% | 7433.44 ± 32.0% | not timed | not timed | 14940.99 ± 5.8% | | 1.00 | 1.04 | 2.01 |
| imported/sherlock/name-alt1 | 1142 | 11344.72 ± 2.0% | not timed | not timed | 16209.79 ± 0.7% | 4155.45 ± 52.6% | not timed | not timed | 11354.83 ± 0.8% | | 1.00 | 0.70 | 2.73 |
| imported/sherlock/name-alt2 | 3542 | 8534.80 ± 0.7% | not timed | not timed | 3772.23 ± 0.1% | 31.28 ± 0.0% | not timed | not timed | 8517.16 ± 0.4% | | 1.00 | 2.26 | 272.85 |
| imported/sherlock/name-alt3 | 4507 | 5440.02 ± 0.3% | not timed | not timed | 3562.19 ± 0.1% | 9.95 ± 2.5% | not timed | not timed | 5443.94 ± 0.3% | | 1.00 | 1.53 | 547.00 |
| imported/sherlock/name-alt3-casei | 4593 | 1515.82 ± 2.2% | not timed | not timed | 285.87 ± 0.3% | 6.47 ± 0.2% | not timed | not timed | 1511.07 ± 1.4% | | 1.00 | 5.30 | 234.13 |
| imported/sherlock/name-alt4 | 3686 | 6174.60 ± 0.3% | not timed | not timed | 3783.07 ± 0.1% | 31.31 ± 0.1% | not timed | not timed | 6187.94 ± 0.2% | | 1.00 | 1.63 | 197.19 |
| imported/sherlock/name-alt4-casei | 4254 | 2759.81 ± 3.8% | not timed | not timed | 2597.90 ± 0.2% | 19.92 ± 20.8% | not timed | not timed | 2763.65 ± 1.1% | | 1.00 | 1.06 | 138.57 |
| imported/sherlock/name-alt5 | 4028 | 6198.12 ± 0.4% | not timed | not timed | 3686.72 ± 0.2% | 21.73 ± 0.0% | not timed | not timed | 6216.39 ± 0.4% | | 1.00 | 1.68 | 285.25 |
| imported/sherlock/name-alt5-casei | 4104 | 3453.01 ± 2.0% | not timed | not timed | 2221.46 ± 0.1% | 14.38 ± 0.1% | not timed | not timed | 3447.96 ± 1.0% | | 1.00 | 1.55 | 240.20 |
| imported/sherlock/no-match-uncommon | 0 | 21396.47 ± 0.7% | not timed | not timed | 19404.72 ± 0.5% | 34909.64 ± 1.4% | not timed | not timed | 21410.53 ± 0.6% | | 1.00 | 1.10 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21210.23 ± 0.9% | not timed | not timed | 19410.21 ± 0.7% | 1280.98 ± 0.7% | not timed | not timed | 21240.63 ± 0.4% | | 1.00 | 1.09 | 16.56 |
| imported/sherlock/no-match-really-common | 0 | 16221.51 ± 3.8% | not timed | not timed | 18661.39 ± 1.3% | 1277.24 ± 0.7% | not timed | not timed | 16285.71 ± 3.1% | | 1.00 | 0.87 | 12.70 |
| imported/sherlock/the-lower | 21654 | 2321.31 ± 1.1% | not timed | not timed | 2337.89 ± 0.3% | 243.09 ± 18.2% | not timed | not timed | 2324.07 ± 1.1% | | 1.00 | 0.99 | 9.55 |
| imported/sherlock/the-upper | 2223 | 12661.23 ± 1.2% | not timed | not timed | 13520.30 ± 0.3% | 2669.12 ± 11.9% | not timed | not timed | 12731.66 ± 1.1% | | 0.99 | 0.94 | 4.74 |
| imported/sherlock/the-casei | 23961 | 2010.71 ± 0.8% | not timed | not timed | 1224.52 ± 0.3% | 34.95 ± 35.0% | not timed | not timed | 2013.84 ± 1.2% | | 1.00 | 1.64 | 57.53 |
| imported/sherlock/everything-greedy | 581881 | 270.17 ± 1.0% | not timed | not timed | 164.14 ± 0.1% | 28.95 ± 31.2% | not timed | not timed | 271.37 ± 0.2% | | 1.00 | 1.65 | 9.33 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.64 ± 0.0% | not timed | not timed | 212.26 ± 0.2% | 32.96 ± 0.3% | not timed | not timed | 463.64 ± 0.1% | | 1.00 | 2.18 | 14.04 |
| imported/sherlock/letters | 447175 | 54.50 ± 0.4% | not timed | not timed | 32.87 ± 0.4% | 6.55 ± 12.7% | not timed | not timed | 54.33 ± 0.8% | | 1.00 | 1.66 | 8.32 |
| imported/sherlock/letters-upper | 14180 | 433.63 ± 1.3% | not timed | not timed | 371.63 ± 0.2% | 29.84 ± 21.5% | not timed | not timed | 434.20 ± 0.3% | | 1.00 | 1.17 | 14.53 |
| imported/sherlock/letters-lower | 432995 | 55.39 ± 0.9% | not timed | not timed | 33.77 ± 0.1% | 5.64 ± 36.2% | not timed | not timed | 55.47 ± 0.8% | | 1.00 | 1.64 | 9.82 |
| imported/sherlock/words | 447639 | 107.28 ± 0.6% | not timed | not timed | 83.15 ± 0.1% | 14.34 ± 31.5% | not timed | not timed | 107.58 ± 0.6% | | 1.00 | 1.29 | 7.48 |
| imported/sherlock/before-holmes | 4073 | 597.93 ± 0.6% | not timed | not timed | 8487.39 ± 0.3% | 23.91 ± 0.9% | not timed | not timed | 596.74 ± 0.7% | | 1.00 | 0.0704 | 25.01 |
| imported/sherlock/before-after-holmes | 2593 | 597.73 ± 0.6% | not timed | not timed | 9425.39 ± 0.2% | 23.78 ± 1.2% | not timed | not timed | 598.17 ± 0.6% | | 1.00 | 0.0634 | 25.14 |
| imported/sherlock/holmes-cochar-watson | 150 | 5221.00 ± 0.2% | not timed | not timed | 3432.85 ± 0.2% | 30.97 ± 0.2% | not timed | not timed | 5231.80 ± 0.2% | | 1.00 | 1.52 | 168.60 |
| imported/sherlock/holmes-coword-watson | 14309 | 1264.88 ± 0.5% | not timed | not timed | 1125.15 ± 0.1% | 6.74 ± 0.2% | not timed | not timed | 1260.14 ± 0.8% | | 1.00 | 1.12 | 187.80 |
| imported/sherlock/quotes | 14437 | 1415.65 ± 0.3% | not timed | not timed | 1762.75 ± 0.4% | 35.11 ± 0.2% | not timed | not timed | 1412.26 ± 0.3% | | 1.00 | 0.80 | 40.32 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 600.62 ± 0.6% | not timed | not timed | 15803.74 ± 0.3% | 36.85 ± 0.2% | not timed | not timed | 601.02 ± 1.0% | | 1.00 | 0.0380 | 16.30 |
| imported/sherlock/word-ending-n | 35297 | 468.66 ± 2.2% | not timed | not timed | 410.76 ± 0.2% | 23.54 ± 17.9% | not timed | not timed | 468.35 ± 0.1% | | 1.00 | 1.14 | 19.91 |
| imported/sherlock/repeated-class-negation | 2130 | 14383.49 ± 0.4% | not timed | not timed | 10856.35 ± 0.3% | 11.58 ± 0.3% | not timed | not timed | 14389.19 ± 0.5% | | 1.00 | 1.32 | 1242.60 |
| imported/sherlock/ing-suffix | 20547 | 555.94 ± 0.2% | not timed | not timed | 517.06 ± 0.4% | 28.87 ± 0.1% | not timed | not timed | 554.41 ± 0.3% | | 1.00 | 1.08 | 19.26 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 594.83 ± 0.3% | not timed | not timed | 2076.73 ± 0.3% | 20.54 ± 0.2% | not timed | not timed | 595.14 ± 0.2% | | 1.00 | 0.29 | 28.96 |
| opt/accelerate/whole-line | 239963 | 459.61 ± 0.1% | not timed | not timed | 370.71 ± 0.1% | 92.48 ± 16.3% | not timed | not timed | 459.09 ± 0.3% | | 1.00 | 1.24 | 4.97 |
| opt/accelerate/non-dna | 16745 | 412.08 ± 0.7% | not timed | not timed | 400.33 ± 0.1% | 28.85 ± 19.8% | not timed | not timed | 412.99 ± 0.3% | | 1.00 | 1.03 | 14.28 |
| opt/backtrack/words-english | 40536 | 137.21 ± 0.2% | not timed | not timed | 94.51 ± 0.2% | 19.91 ± 8.8% | not timed | not timed | 137.13 ± 2.0% | | 1.00 | 1.45 | 6.89 |
| opt/fixed-length/too-small-ascii | 0 | 312.11 ± 0.4% | not timed | not timed | 688.51 ± 1.9% | 80.06 ± 0.6% | not timed | not timed | 309.87 ± 0.4% | | 1.01 | 0.45 | 3.90 |
| opt/fixed-length/too-big-ascii | 0 | 645.62 ± 0.6% | not timed | not timed | 5793.92 ± 0.7% | 127.09 ± 0.3% | not timed | not timed | 653.97 ± 0.6% | | 0.99 | 0.11 | 5.08 |
| opt/fixed-length/go33484-1 | 0 | 45.45 ± 0.0% | not timed | not timed | 1116747.12 ± 0.3% | 61512.41 ± 0.7% | not timed | not timed | 45.34 ± 0.1% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5527.54 ± 0.0% | not timed | not timed | 1103619.07 ± 0.3% | 32024.69 ± 1.4% | not timed | not timed | 5520.08 ± 0.0% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1796.45 ± 1.5% | not timed | not timed | 110255.08 ± 0.3% | 765.53 ± 0.0% | not timed | not timed | 1758.14 ± 0.7% | | 1.02 | 0.0163 | 2.35 |
| opt/literal-alt/one-pattern | 1 | 555.30 ± 2.1% | not timed | not timed | 542.01 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 554.70 ± 0.2% | | 1.00 | 1.02 | 1380.63 |
| opt/onepass/fn-predicate | 916 | 367.63 ± 1.1% | not timed | not timed | 331.35 ± 0.2% | 202.51 ± 14.6% | not timed | not timed | 370.58 ± 1.1% | | 0.99 | 1.11 | 1.82 |
| opt/onepass/first-three-words-english | 35128 | 148.77 ± 1.7% | not timed | not timed | 203.40 ± 0.1% | 81.04 ± 5.2% | not timed | not timed | 149.50 ± 8.1% | | 1.00 | 0.73 | 1.84 |
| opt/prefilter/literal-english | 1 | 20566.85 ± 0.3% | not timed | not timed | 19387.28 ± 0.2% | 17385.60 ± 0.2% | not timed | not timed | 20580.03 ± 0.5% | | 1.00 | 1.06 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14505.59 ± 0.9% | not timed | not timed | 4313.77 ± 0.2% | 32.72 ± 0.7% | not timed | not timed | 14501.46 ± 0.2% | | 1.00 | 3.36 | 443.37 |
| opt/prefilter/literal-russian | 1 | 21844.04 ± 0.4% | not timed | not timed | 20257.03 ± 0.2% | 3326.66 ± 0.3% | not timed | not timed | 21822.82 ± 0.3% | | 1.00 | 1.08 | 6.57 |
| opt/prefilter/literal-casei-russian | 1 | 8587.94 ± 0.3% | not timed | not timed | 3892.06 ± 0.2% | 30.92 ± 0.1% | not timed | not timed | 8575.45 ± 0.4% | | 1.00 | 2.21 | 277.71 |
| opt/prefilter/rust-functions | 948 | 6838.58 ± 0.3% | not timed | not timed | 8947.56 ± 0.4% | 1877.72 ± 0.4% | not timed | not timed | 6831.75 ± 0.3% | | 1.00 | 0.76 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 5580.76 ± 0.1% | not timed | not timed | 21616025.53 ± 0.1% | 50.11 ± 0.2% | not timed | not timed | 5580.81 ± 0.3% | | 1.00 | 0.0003 | 111.36 |
| opt/reverse-inner/holmes | 2593 | 597.98 ± 0.4% | not timed | not timed | 9392.35 ± 0.3% | 23.77 ± 2.1% | not timed | not timed | 599.00 ± 0.4% | | 1.00 | 0.0637 | 25.15 |
| opt/reverse-inner/email | 47 | 1045.34 ± 0.1% | not timed | not timed | 45024.09 ± 1.0% | 32.46 ± 0.1% | not timed | not timed | 1044.61 ± 0.1% | | 1.00 | 0.0232 | 32.20 |
| opt/reverse-inner/factored-prefix | 3542 | 590.39 ± 0.5% | not timed | not timed | 597.61 ± 0.1% | 12.56 ± 0.2% | not timed | not timed | 592.40 ± 0.4% | | 1.00 | 0.99 | 47.00 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5511.40 ± 0.1% | not timed | not timed | 614.52 ± 0.5% | 75.10 ± 0.1% | not timed | not timed | 5520.61 ± 0.0% | | 1.00 | 8.97 | 73.39 |
| opt/reverse-inner/no-quadratic-forward | 0 | 687.35 ± 2.2% | not timed | not timed | 288.01 ± 0.1% | 24.83 ± 0.5% | not timed | not timed | 686.54 ± 1.5% | | 1.00 | 2.39 | 27.68 |
| opt/reverse-suffix/holmes | 4073 | 600.18 ± 0.5% | not timed | not timed | 8506.76 ± 0.2% | 23.75 ± 1.2% | not timed | not timed | 597.43 ± 0.4% | | 1.00 | 0.0706 | 25.27 |
| opt/reverse-suffix/no-quadratic | 0 | 5520.42 ± 0.1% | not timed | not timed | 616.67 ± 0.1% | 75.25 ± 0.1% | not timed | not timed | 5505.10 ± 0.0% | | 1.00 | 8.95 | 73.36 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.69 ± 9.4% | not timed | not timed | 131.39 ± 0.0% | 13.10 ± 15.6% | not timed | not timed | 120.83 ± 0.6% | | 1.00 | 0.92 | 9.21 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 121.17 ± 0.2% | not timed | not timed | 131.47 ± 0.3% | 12.98 ± 15.2% | not timed | not timed | 120.97 ± 2.7% | | 1.00 | 0.92 | 9.33 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 3.3% | not timed | not timed | 0.55 ± 0.2% | 113.71 ± 7.4% | not timed | not timed | 0.28 ± 0.3% | | 1.01 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 316.84 ± 0.2% | not timed | not timed | 293.84 ± 0.3% | 103.83 ± 1.8% | not timed | not timed | 309.24 ± 0.1% | | 1.02 | 1.08 | 3.05 |
| reported/i13-subset-regex/original-ascii | 4094 | 11073.62 ± 1.0% | not timed | not timed | 4539.54 ± 0.2% | 11.52 ± 0.1% | not timed | not timed | 11090.40 ± 1.2% | | 1.00 | 2.44 | 961.18 |
| reported/i13-subset-regex/original-unicode | 4094 | 10971.52 ± 1.2% | not timed | not timed | 252.02 ± 3.0% | 11.51 ± 0.2% | not timed | not timed | 11137.52 ± 1.1% | | 0.99 | 43.54 | 953.12 |
| reported/i13-subset-regex/big-ascii | 1955 | 10665.75 ± 1.4% | not timed | not timed | 68.37 ± 3.6% | 9.87 ± 0.2% | not timed | not timed | 10741.23 ± 1.0% | | 0.99 | 156.00 | 1080.98 |
| reported/i13-subset-regex/big-unicode | 1955 | 10632.88 ± 2.6% | not timed | not timed | 12.21 ± 54.9% | 9.86 ± 1.3% | not timed | not timed | 10731.08 ± 11.0% | | 0.99 | 870.95 | 1078.82 |
| reported/i13-subset-regex/huge-ascii | 55 | 10127.37 ± 1.2% | not timed | not timed | 11.00 ± 0.1% | 8.77 ± 0.1% | not timed | not timed | 10055.46 ± 2.5% | | 1.01 | 920.36 | 1155.36 |
| reported/i13-subset-regex/huge-unicode | 55 | 10077.37 ± 0.7% | not timed | not timed | 11.02 ± 0.4% | 8.70 ± 0.1% | not timed | not timed | 9899.32 ± 3.1% | | 1.02 | 914.57 | 1158.63 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.0% | not timed | not timed | 11.07 ± 0.1% | 8.76 ± 1.1% | not timed | not timed | 3.53 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.0% | not timed | not timed | 10.97 ± 0.3% | 8.77 ± 0.3% | not timed | not timed | 5.02 ± 0.0% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 470.12 ± 0.2% | not timed | not timed | 104.80 ± 0.2% | 6.63 ± 0.1% | not timed | not timed | 469.81 ± 0.4% | | 1.00 | 4.49 | 70.93 |
| reported/i787-keywords/opt-ascii | 5674 | 471.25 ± 0.1% | not timed | not timed | 276.00 ± 0.3% | 10.28 ± 0.1% | not timed | not timed | 470.86 ± 0.2% | | 1.00 | 1.71 | 45.83 |
| slow/quadratic-regex-1x | 100 | 6.94 ± 0.2% | not timed | not timed | 4.98 ± 0.1% | 0.05 ± 0.3% | not timed | not timed | 6.94 ± 0.2% | | 1.00 | 1.39 | 140.28 |
| slow/quadratic-regex-2x | 199 | 3.41 ± 0.1% | not timed | not timed | 2.72 ± 0.1% | 0.01 ± 0.1% | not timed | not timed | 3.40 ± 0.3% | | 1.00 | 1.25 | 268.07 |
| slow/quadratic-haystack-1x | 100 | 21.17 ± 7.4% | not timed | not timed | 10.01 ± 0.5% | 1.01 ± 14.7% | not timed | not timed | 21.17 ± 1.7% | | 1.00 | 2.12 | 20.88 |
| slow/quadratic-haystack-2x | 200 | 17.39 ± 0.2% | not timed | not timed | 5.54 ± 0.3% | 0.55 ± 1.4% | not timed | not timed | 17.38 ± 11.2% | | 1.00 | 3.14 | 31.89 |
| unicode/codepoints/any-one | 1112064 | 285.51 ± 0.2% | not timed | not timed | 175.44 ± 0.2% | 18.67 ± 2.5% | not timed | not timed | 284.37 ± 0.1% | | 1.00 | 1.63 | 15.29 |
| unicode/codepoints/any-all | 4382592 | 289.33 ± 1.0% | not timed | not timed | 247.03 ± 0.2% | 117.48 ± 0.2% | not timed | not timed | 290.28 ± 0.9% | | 1.00 | 1.17 | 2.46 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.74 ± 1.0% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 610.14 ± 0.2% | not timed | not timed | 615.03 ± 0.1% | 135.16 ± 0.4% | not timed | not timed | 610.82 ± 0.3% | | 1.00 | 0.99 | 4.51 |
| unicode/overlapping-words/ascii | 6156 | 31.78 ± 0.1% | not timed | not timed | 38.83 ± 0.1% | 3.95 ± 0.3% | not timed | not timed | 31.89 ± 0.2% | | 1.00 | 0.82 | 8.05 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 0.1% | not timed | not timed | 4.46 ± 0.3% | 2.35 ± 0.1% | not timed | not timed | 1.35 ± 0.4% | | 1.00 | 0.30 | 0.58 |
| unicode/overlapping-words/russian | 5710 | 1.22 ± 8.5% | not timed | not timed | 3.86 ± 0.1% | 6.22 ± 10.4% | not timed | not timed | 1.22 ± 0.4% | | 1.00 | 0.32 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 117.63 ± 3.4% | not timed | not timed | 82.56 ± 0.1% | 12.01 ± 16.6% | not timed | not timed | 117.27 ± 0.6% | | 1.00 | 1.42 | 9.79 |
| unicode/word/boundary-long-english | 3466 | 606.56 ± 0.7% | not timed | not timed | 607.40 ± 0.1% | 32.59 ± 0.7% | not timed | not timed | 509.13 ± 1.4% | | 1.19 | 1.00 | 18.61 |
| unicode/word/around-holmes-english | 27 | 603.60 ± 0.7% | not timed | not timed | 19092.77 ± 0.6% | 22.34 ± 0.4% | not timed | not timed | 600.42 ± 0.9% | | 1.01 | 0.0316 | 27.02 |
| wild/bibleref/long | 874 | 565.17 ± 0.3% | not timed | not timed | 583.59 ± 0.1% | 6.36 ± 0.1% | not timed | not timed | 564.72 ± 0.1% | | 1.00 | 0.97 | 88.85 |
| wild/bibleref/short | 30 | 24.74 ± 1.6% | not timed | not timed | 30.73 ± 0.3% | 14.58 ± 11.7% | not timed | not timed | 24.68 ± 6.9% | | 1.00 | 0.80 | 1.70 |
| wild/bibleref/line | 874 | 358.99 ± 2.9% | not timed | not timed | 212.38 ± 0.2% | 9.28 ± 8.4% | not timed | not timed | 359.69 ± 0.1% | | 1.00 | 1.69 | 38.70 |
| wild/caddy/caddy | 6 | 416.89 ± 7.3% | not timed | not timed | 248.38 ± 0.0% | 68.27 ± 12.6% | not timed | not timed | 418.91 ± 0.1% | | 1.00 | 1.68 | 6.11 |
| wild/dot-star-capture/rust-src-tools | 6 | 1059.55 ± 0.7% | not timed | not timed | 348.33 ± 0.3% | 13.51 ± 0.2% | not timed | not timed | 1060.46 ± 0.4% | | 1.00 | 3.04 | 78.41 |
| wild/ruff/noqa | 84 | 404.55 ± 0.1% | not timed | not timed | 465.00 ± 0.0% | 19.64 ± 2.1% | not timed | not timed | 404.68 ± 0.1% | | 1.00 | 0.87 | 20.60 |
| wild/ruff/unnecessary-coding-comment | 16 | 490.43 ± 0.6% | not timed | not timed | 701.10 ± 0.2% | 135.95 ± 10.9% | not timed | not timed | 489.61 ± 0.8% | | 1.00 | 0.70 | 3.61 |
| wild/ruff/string-quote-prefix | 2972 | 408.23 ± 0.5% | not timed | not timed | 445.47 ± 0.1% | 381.72 ± 31.5% | not timed | not timed | 408.39 ± 0.6% | | 1.00 | 0.92 | 1.07 |
| wild/ruff/space-around-operator | 1224378 | 217.60 ± 1.7% | not timed | not timed | 186.66 ± 0.1% | 18.31 ± 1.7% | not timed | not timed | 218.20 ± 1.8% | | 1.00 | 1.17 | 11.89 |
| wild/ruff/shebang | 282 | 401.96 ± 0.4% | not timed | not timed | 327.27 ± 0.1% | 119.65 ± 9.6% | not timed | not timed | 402.07 ± 0.6% | | 1.00 | 1.23 | 3.36 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13846.90 ± 0.5% | not timed | not timed | 13775.50 ± 0.6% | 6921.58 ± 0.5% | not timed | not timed | 13863.00 ± 0.3% | | 1.00 | 1.01 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12799.55 ± 0.7% | not timed | not timed | 13392.06 ± 0.6% | 6436.12 ± 0.7% | not timed | not timed | 12831.04 ± 0.3% | | 1.00 | 0.96 | 1.99 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13198.23 ± 1.0% | not timed | not timed | 13614.86 ± 0.6% | 6704.36 ± 35.9% | not timed | not timed | 13212.38 ± 4.9% | | 1.00 | 0.97 | 1.97 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9575.09 ± 1.2% | not timed | not timed | 13475.61 ± 0.1% | 6785.97 ± 0.8% | not timed | not timed | 9579.85 ± 0.3% | | 1.00 | 0.71 | 1.41 |
| wild/url/search | 234965 | 122.63 ± 14.7% | not timed | not timed | 65.92 ± 0.7% | 2.24 ± 0.8% | not timed | not timed | 122.10 ± 14.0% | | 1.00 | 1.86 | 54.69 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 55.1% | not timed | not timed | 0.01 ± 1.4% | 0.01 ± 15.3% | not timed | not timed | 0.03 ± 10.7% | | 1.00 | 3.05 | 3.56 |
| dictionary/compile/english-15 | 1 | 0.35 ± 32.5% | not timed | not timed | 0.07 ± 0.4% | 0.10 ± 11.6% | not timed | not timed | 0.35 ± 3.9% | | 1.00 | 5.02 | 3.41 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 8.9% | not timed | not timed | 0.02 ± 1.1% | 36.61 ± 13.5% | not timed | not timed | 0.25 ± 3.7% | | 0.98 | 12.78 | 0.0067 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.57 ± 1.9% | not timed | not timed | 11.53 ± 0.7% | 62.35 ± 20.7% | not timed | not timed | 46.71 ± 2.0% | | 1.00 | 4.04 | 0.75 |
| reported/i787-keywords/compile | 1 | 34.02 ± 16.2% | not timed | not timed | 2.12 ± 0.8% | 17.12 ± 26.4% | not timed | not timed | 34.68 ± 0.6% | | 0.98 | 16.07 | 1.99 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 341.44 ± 1.8% | not timed | not timed | 124.85 ± 0.2% | 574.07 ± 8.0% | not timed | not timed | 345.01 ± 1.5% | | 0.99 | 2.73 | 0.59 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.30 ± 1.7% | not timed | not timed | 4.10 ± 0.8% | 43.93 ± 4.5% | not timed | not timed | 47.88 ± 1.9% | | 0.99 | 11.52 | 1.08 |
| unicode/compile/one-letter | 53 | 6.60 ± 11.1% | not timed | not timed | 4.54 ± 0.9% | 65.32 ± 4.8% | not timed | not timed | 6.71 ± 10.3% | | 0.98 | 1.45 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.07 ± 16.3% | not timed | not timed | 0.10 ± 0.6% | 66.79 ± 4.7% | not timed | not timed | 1.06 ± 3.8% | | 1.00 | 10.70 | 0.0160 |
| unicode/compile/fifty-letters-ascii | 1 | 214.28 ± 2.9% | not timed | not timed | 52.47 ± 0.7% | 198.36 ± 18.4% | not timed | not timed | 215.47 ± 8.7% | | 0.99 | 4.08 | 1.08 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 372.33 ± 1.4% | not timed | not timed | 47.15 ± 0.4% | 674.47 ± 8.9% | not timed | not timed | 372.90 ± 2.3% | | 1.00 | 7.90 | 0.55 |
| unicode/compile/match-every-line-ascii | 4 | 575.49 ± 3.2% | not timed | not timed | 146.44 ± 0.0% | 673.26 ± 40.2% | not timed | not timed | 584.45 ± 7.7% | | 0.98 | 3.93 | 0.85 |
| unicode/compile/negated-class-matches-codepoint | 1 | 300.62 ± 4.2% | not timed | not timed | 49.27 ± 0.3% | 1243.43 ± 2.9% | not timed | not timed | 310.67 ± 4.2% | | 0.97 | 6.10 | 0.24 |
| wild/bibleref/compile | 3 | 5.82 ± 20.1% | not timed | not timed | 1.93 ± 1.2% | 31.76 ± 15.8% | not timed | not timed | 5.88 ± 5.9% | | 0.99 | 3.01 | 0.18 |
| wild/url/compile | 1 | 0.55 ± 16.2% | not timed | not timed | 0.14 ± 0.3% | 0.46 ± 6.0% | not timed | not timed | 0.63 ± 18.1% | | 0.87 | 3.77 | 1.19 |

