# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507007418 |
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
| literal: a word | 217 | 36236.99 ± 0.6% | 4135.58 ± 0.2% | 35.75 ± 2.0% | 32701.64 ± 0.4% | 12801.54 ± 2.4% | 14.86 ± 0.4% | 114.72 ± 2.4% | 36313.52 ± 0.6% | 8.76 | 1.00 | 1.11 | 2.83 |
| literal: a word that is not there | 0 | 42450.98 ± 0.1% | 4042.84 ± 0.2% | 36.03 ± 0.4% | 36254.94 ± 0.5% | 40060.27 ± 0.6% | 14.41 ± 0.3% | 110.19 ± 0.4% | 42384.59 ± 0.2% | 10.50 | 1.00 | 1.17 | 1.06 |
| literal: one of four words | 661 | 14524.10 ± 0.8% | 1969.47 ± 0.7% | 19.02 ± 1.5% | 9674.18 ± 0.5% | 29.14 ± 1.4% | 4.32 ± 0.6% | 9.63 ± 6.7% | 14645.80 ± 1.3% | 7.37 | 0.99 | 1.50 | 498.42 |
| literal: a word in any case | 217 | 30593.86 ± 0.6% | 2077.98 ± 0.3% | 24.69 ± 2.5% | 10010.26 ± 0.1% | 58.30 ± 2.4% | refused | differs | 30642.77 ± 0.5% | 14.72 | 1.00 | 3.06 | 524.75 |
| literal: an href attribute | 33 | 30072.72 ± 0.3% | 636.22 ± 0.2% | 31.45 ± 0.3% | 29308.83 ± 0.4% | 2605.21 ± 2.3% | 10.61 ± 0.9% | 101.78 ± 0.3% | 30029.77 ± 0.4% | 47.27 | 1.00 | 1.03 | 11.54 |
| literal: a word, second text | 123 | 36856.00 ± 0.5% | 3124.38 ± 0.2% | 34.46 ± 2.4% | 32736.16 ± 1.1% | 9141.70 ± 5.5% | 19.32 ± 0.3% | 98.60 ± 2.0% | 36833.31 ± 0.4% | 11.80 | 1.00 | 1.13 | 4.03 |
| class: two capitalized words | 1331 | 1005.01 ± 0.4% | 629.64 ± 2.5% | 32.02 ± 9.6% | 612.55 ± 0.2% | 48.95 ± 2.0% | 12.62 ± 0.2% | 82.28 ± 0.2% | 1007.31 ± 0.2% | 1.60 | 1.00 | 1.64 | 20.53 |
| class: a word that ends in ing | 3399 | 600.23 ± 0.3% | 600.97 ± 0.5% | 20.96 ± 0.8% | 575.99 ± 0.1% | 35.47 ± 9.3% | 7.16 ± 0.3% | 23.00 ± 1.5% | 601.76 ± 0.7% | 1.00 | 1.00 | 1.04 | 16.92 |
| class: a word in capitals | 2332 | 1374.97 ± 4.1% | 638.19 ± 0.7% | 34.50 ± 2.5% | 603.13 ± 0.2% | 52.81 ± 1.1% | 15.22 ± 0.1% | 106.82 ± 0.2% | 1373.82 ± 0.7% | 2.15 | 1.00 | 2.28 | 26.03 |
| class: a number | 8288 | 2221.71 ± 0.8% | 897.05 ± 0.2% | 34.09 ± 3.4% | 2117.72 ± 0.7% | 50.74 ± 15.3% | 0.42 ± 0.1% | 80.05 ± 0.6% | 2218.55 ± 0.3% | 2.48 | 1.00 | 1.05 | 43.79 |
| class: two capitalized words, second text | 5359 | 536.47 ± 0.3% | 544.96 ± 0.2% | 28.34 ± 1.2% | 505.58 ± 0.4% | 40.31 ± 13.9% | 16.50 ± 0.2% | 74.99 ± 0.5% | 537.80 ± 0.3% | 0.98 | 1.00 | 1.06 | 13.31 |
| other: a word between two words | 6104 | 914.78 ± 0.3% | 628.97 ± 0.4% | 28.54 ± 1.9% | 874.44 ± 0.3% | 136.48 ± 13.7% | 9.66 ± 0.5% | 87.48 ± 0.5% | 914.23 ± 0.1% | 1.45 | 1.00 | 1.05 | 6.70 |
| other: a number before a unit, second text | 1481 | 9425.90 ± 0.7% | 1152.06 ± 0.6% | 31.96 ± 3.5% | 9540.31 ± 1.0% | 49.04 ± 8.6% | 17.24 ± 0.6% | 78.36 ± 1.3% | 9448.61 ± 3.6% | 8.18 | 1.00 | 0.99 | 192.19 |
| other: a heading's start tag | 110 | 21365.87 ± 0.2% | 777.35 ± 0.3% | 34.58 ± 1.3% | 2683.50 ± 1.1% | 1913.63 ± 1.2% | 13.24 ± 0.2% | 119.90 ± 0.5% | 21393.18 ± 0.6% | 27.49 | 1.00 | 7.96 | 11.17 |
| other: a whole word | 217 | 28710.65 ± 0.2% | 628.98 ± 0.3% | 35.41 ± 1.2% | 26137.19 ± 0.3% | 60.39 ± 0.6% | 12.62 ± 0.1% | 68.70 ± 0.6% | 28731.40 ± 0.3% | 45.65 | 1.00 | 1.10 | 475.45 |
| other: a line's first word, second text | 3716 | 2723.31 ± 0.7% | 621.19 ± 0.3% | 37.17 ± 0.4% | 2438.17 ± 0.8% | 82.29 ± 1.8% | refused | refused | 2724.41 ± 0.5% | 4.38 | 1.00 | 1.12 | 33.09 |
| other: fourteen octets before an x | 87 | 37474.52 ± 1.0% | 294.10 ± 0.3% | 7.84 ± 0.2% | 4193.45 ± 0.3% | 11.61 ± 0.5% | differs | 20.80 ± 0.4% | 37713.09 ± 1.0% | 127.42 | 0.99 | 8.94 | 3227.82 |
| other: a Greek word | 21815 | 602.08 ± 0.4% | 476.39 ± 0.5% | 37.26 ± 1.4% | 313.47 ± 0.3% | 53.77 ± 4.6% | differs | refused | 605.18 ± 2.4% | 1.26 | 0.99 | 1.92 | 11.20 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 32.00 ± 0.3% | 31.97 ± 0.5% | 1.08 ± 1.0% | 18.98 ± 0.1% | 3.23 ± 0.5% | differs | 5.00 ± 0.3% | 31.97 ± 0.3% | 1.00 | 1.00 | 1.69 | 9.92 |
| a UUID | 32895 | 29.97 ± 0.4% | 29.98 ± 0.4% | 0.71 ± 2.1% | 16.44 ± 0.1% | 3.24 ± 0.3% | 0.71 ± 0.2% | 4.13 ± 0.5% | 29.98 ± 0.2% | 1.00 | 1.00 | 1.82 | 9.24 |
| an IPv4 address | 33176 | 39.15 ± 0.4% | 39.15 ± 0.3% | 2.35 ± 0.6% | 31.36 ± 0.3% | 8.12 ± 1.1% | differs | 4.93 ± 0.4% | 39.11 ± 0.5% | 1.00 | 1.00 | 1.25 | 4.82 |
| a date and time | 32954 | 40.28 ± 0.3% | 40.38 ± 0.7% | 1.73 ± 0.4% | 23.90 ± 0.4% | 10.24 ± 0.5% | 1.31 ± 0.1% | 9.23 ± 1.2% | 40.27 ± 0.4% | 1.00 | 1.00 | 1.69 | 3.93 |
| a field path | 32606 | 33.64 ± 1.4% | 33.52 ± 1.8% | 1.20 ± 0.7% | 24.70 ± 0.3% | 3.72 ± 0.4% | differs | 3.16 ± 0.5% | 33.53 ± 1.7% | 1.00 | 1.00 | 1.36 | 9.05 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.98 ± 0.7% | 12.83 ± 0.5% | 12.97 ± 0.7% | 14.70 ± 1.1% | 6.85 ± 1.3% | 1.04 ± 0.6% | none | 12.86 ± 1.1% | 1.01 | 1.01 | 0.88 | 1.90 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 278.93 ± 0.5% | 279.86 ± 0.4% | 328.47 ± 0.7% | 116.59 ± 1.3% | 265.51 ± 1.2% | 689.59 ± 1.6% | 4345.79 ± 0.4% | 279.53 ± 0.3% | 1.00 | 1.00 | 2.39 | 1.05 |
| a UUID | 62 | 182.47 ± 0.4% | 182.72 ± 0.3% | 205.42 ± 0.4% | 61.80 ± 1.3% | 120.15 ± 1.8% | 251.57 ± 1.2% | 5636.24 ± 0.6% | 182.51 ± 0.6% | 1.00 | 1.00 | 2.95 | 1.52 |
| an IPv4 address | 29 | 563.65 ± 0.3% | 564.45 ± 0.8% | 801.96 ± 0.3% | 100.87 ± 0.4% | 158.14 ± 2.2% | 431.56 ± 0.6% | 10332.95 ± 0.4% | 562.65 ± 0.5% | 1.00 | 1.00 | 5.59 | 3.56 |
| a date and time | 56 | 417.52 ± 0.3% | 418.75 ± 0.7% | 538.02 ± 0.6% | 96.10 ± 0.7% | 166.13 ± 4.3% | 450.09 ± 1.9% | 5603.58 ± 1.5% | 418.53 ± 0.3% | 1.00 | 1.00 | 4.34 | 2.51 |
| a field path | 39 | 270.22 ± 0.9% | 270.35 ± 0.7% | 316.78 ± 0.6% | 105.14 ± 0.5% | 248.17 ± 2.0% | 711.24 ± 1.2% | 5397.19 ± 0.5% | 270.84 ± 0.4% | 1.00 | 1.00 | 2.57 | 1.09 |
| literal: a word | 7 | 822.31 ± 0.3% | 881.32 ± 0.4% | 1632.40 ± 0.2% | 723.35 ± 1.4% | 817.42 ± 0.8% | 1467.90 ± 0.5% | 37423.18 ± 0.3% | 822.87 ± 0.3% | 0.93 | 1.00 | 1.14 | 1.01 |
| literal: a word that is not there | 8 | 786.50 ± 0.5% | 851.16 ± 0.9% | 1545.07 ± 1.0% | 668.11 ± 1.0% | 774.69 ± 9.8% | 1373.63 ± 0.4% | 35675.48 ± 3.2% | 787.28 ± 0.6% | 0.92 | 1.00 | 1.18 | 1.02 |
| literal: one of four words | 26 | 311.77 ± 0.5% | 521.50 ± 0.3% | 718.57 ± 0.3% | 51.03 ± 1.1% | 299.84 ± 12.4% | 513.08 ± 1.3% | 19190.12 ± 0.2% | 311.73 ± 0.4% | 0.60 | 1.00 | 6.11 | 1.04 |
| literal: a word in any case | 11 | 588.83 ± 0.3% | 626.81 ± 0.2% | 933.88 ± 0.3% | 17.83 ± 1.1% | 856.18 ± 1.0% | refused | 30113.89 ± 0.6% | 589.49 ± 2.0% | 0.94 | 1.00 | 33.03 | 0.69 |
| literal: an href attribute | 12 | 432.81 ± 0.5% | 447.00 ± 0.5% | 590.65 ± 1.2% | 49.91 ± 0.6% | 618.03 ± 1.0% | 1170.03 ± 0.4% | 27088.39 ± 0.5% | 433.08 ± 0.3% | 0.97 | 1.00 | 8.67 | 0.70 |
| literal: a word, second text | 10 | 727.04 ± 0.3% | 799.35 ± 0.2% | 1371.88 ± 1.2% | 601.32 ± 0.4% | 676.47 ± 0.6% | 1188.98 ± 1.3% | 33033.14 ± 1.4% | 726.52 ± 0.3% | 0.91 | 1.00 | 1.21 | 1.07 |
| class: two capitalized words | 23 | 598.82 ± 0.4% | 657.02 ± 0.1% | 993.86 ± 0.2% | 134.05 ± 0.3% | 632.86 ± 1.5% | 1112.79 ± 0.5% | 7680.78 ± 0.4% | 599.82 ± 0.4% | 0.91 | 1.00 | 4.47 | 0.95 |
| class: a word that ends in ing | 9 | 714.25 ± 0.4% | 829.47 ± 0.4% | 1537.80 ± 0.3% | 172.24 ± 0.3% | 936.40 ± 1.8% | 1694.59 ± 0.8% | 20243.33 ± 5.8% | 715.07 ± 0.3% | 0.86 | 1.00 | 4.15 | 0.76 |
| class: a word in capitals | 16 | 654.35 ± 0.4% | 721.97 ± 0.2% | 1251.93 ± 0.3% | 181.74 ± 0.7% | 943.98 ± 1.8% | 1542.99 ± 1.3% | 10138.80 ± 1.0% | 654.94 ± 0.4% | 0.91 | 1.00 | 3.60 | 0.69 |
| class: a number | 6 | 799.70 ± 6.1% | 902.47 ± 0.3% | 1837.28 ± 0.3% | 44.36 ± 1.2% | 1741.35 ± 1.5% | 3043.81 ± 2.0% | 30233.76 ± 1.0% | 801.01 ± 0.5% | 0.89 | 1.00 | 18.03 | 0.46 |
| class: two capitalized words, second text | 23 | 599.07 ± 0.7% | 655.10 ± 0.2% | 990.77 ± 0.6% | 134.01 ± 0.9% | 633.25 ± 18.9% | 1124.83 ± 0.9% | 7644.28 ± 0.5% | 599.21 ± 0.2% | 0.91 | 1.00 | 4.47 | 0.95 |
| other: a word between two words | 13 | 716.78 ± 0.4% | 750.43 ± 0.3% | 1220.47 ± 0.4% | 184.08 ± 1.1% | 629.80 ± 1.0% | 1221.56 ± 0.8% | 18399.51 ± 1.0% | 718.39 ± 0.3% | 0.96 | 1.00 | 3.89 | 1.14 |
| other: a number before a unit, second text | 15 | 504.14 ± 0.2% | 564.92 ± 0.5% | 797.70 ± 0.3% | 42.45 ± 0.2% | 796.57 ± 1.4% | 1371.24 ± 0.3% | 18923.63 ± 1.7% | 504.12 ± 0.3% | 0.89 | 1.00 | 11.88 | 0.63 |
| other: a heading's start tag | 13 | 447.91 ± 0.4% | 456.77 ± 0.3% | 609.46 ± 0.3% | 48.27 ± 0.5% | 774.83 ± 0.6% | 1322.09 ± 0.3% | 22768.50 ± 1.8% | 448.02 ± 0.6% | 0.98 | 1.00 | 9.28 | 0.58 |
| other: a whole word | 11 | 741.16 ± 0.4% | 792.09 ± 0.2% | 1350.50 ± 0.3% | 160.22 ± 0.2% | 724.46 ± 2.6% | 1244.41 ± 1.8% | 32393.48 ± 0.8% | 742.07 ± 0.3% | 0.94 | 1.00 | 4.63 | 1.02 |
| other: a line's first word, second text | 17 | 694.67 ± 0.3% | 733.94 ± 0.2% | 1233.75 ± 0.3% | 172.03 ± 0.4% | 881.58 ± 2.0% | refused | refused | 695.90 ± 0.2% | 0.95 | 1.00 | 4.04 | 0.79 |
| other: fourteen octets before an x | 16 | 132.93 ± 0.6% | 181.85 ± 0.4% | 214.24 ± 0.5% | 18.62 ± 0.2% | 554.63 ± 24.7% | 587.49 ± 1.1% | 16231.04 ± 0.6% | 132.82 ± 0.2% | 0.73 | 1.00 | 7.14 | 0.24 |
| other: a Greek word | 8 | 537.76 ± 0.8% | 757.78 ± 0.2% | 1316.89 ± 0.2% | 61.74 ± 0.6% | 1715.15 ± 10.5% | 2857.24 ± 0.5% | refused | 539.06 ± 1.9% | 0.71 | 1.00 | 8.71 | 0.31 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 29388.33 ± 0.6% | not timed | not timed | 29141.25 ± 0.4% | 3020.61 ± 6.0% | not timed | not timed | 29483.64 ± 0.8% | | 1.00 | 1.01 | 9.73 |
| 01-literal/sherlock-casei-en | 522 | 23844.86 ± 6.7% | not timed | not timed | 8479.41 ± 0.1% | 40.17 ± 1.5% | not timed | not timed | 23895.22 ± 2.4% | | 1.00 | 2.81 | 593.61 |
| 01-literal/sherlock-ru | 724 | 29326.21 ± 0.6% | not timed | not timed | 28225.86 ± 0.4% | 1602.65 ± 7.2% | not timed | not timed | 29322.30 ± 0.7% | | 1.00 | 1.04 | 18.30 |
| 01-literal/sherlock-casei-ru | 746 | 11141.97 ± 0.8% | not timed | not timed | 6519.42 ± 0.8% | 42.84 ± 0.2% | not timed | not timed | 11159.60 ± 0.5% | | 1.00 | 1.71 | 260.08 |
| 01-literal/sherlock-zh | 30 | 39663.31 ± 0.1% | not timed | not timed | 35211.81 ± 0.1% | 1607.38 ± 1.8% | not timed | not timed | 39630.13 ± 0.3% | | 1.00 | 1.13 | 24.68 |
| 02-literal-alternate/sherlock-en | 714 | 13647.41 ± 0.6% | not timed | not timed | 9449.72 ± 0.3% | 22.48 ± 0.4% | not timed | not timed | 13662.71 ± 0.9% | | 1.00 | 1.44 | 607.05 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2272.68 ± 0.8% | not timed | not timed | 2306.24 ± 0.4% | 13.69 ± 0.7% | not timed | not timed | 2281.13 ± 1.5% | | 1.00 | 0.99 | 165.96 |
| 02-literal-alternate/sherlock-ru | 899 | 9535.09 ± 1.3% | not timed | not timed | 5089.84 ± 0.3% | 28.94 ± 1.2% | not timed | not timed | 9169.49 ± 1.1% | | 1.04 | 1.87 | 329.47 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2345.78 ± 0.6% | not timed | not timed | 1244.58 ± 0.3% | 11.90 ± 2.6% | not timed | not timed | 2350.58 ± 0.6% | | 1.00 | 1.88 | 197.06 |
| 02-literal-alternate/sherlock-zh | 207 | 17722.50 ± 0.3% | not timed | not timed | 10776.02 ± 0.6% | 41.65 ± 20.8% | not timed | not timed | 17690.24 ± 2.5% | | 1.00 | 1.64 | 425.55 |
| 03-date/ascii | 111817 | 144.75 ± 1.2% | not timed | not timed | 110.43 ± 0.2% | 0.27 ± 4.8% | not timed | not timed | 144.53 ± 1.1% | | 1.00 | 1.31 | 541.95 |
| 04-ruff-noqa/real | 84 | 622.54 ± 1.1% | not timed | not timed | 569.23 ± 0.5% | 25.96 ± 1.8% | not timed | not timed | 622.47 ± 2.2% | | 1.00 | 1.09 | 23.98 |
| 04-ruff-noqa/tweaked | 44 | 660.65 ± 1.2% | not timed | not timed | 562.78 ± 0.1% | 388.81 ± 7.0% | not timed | not timed | 656.11 ± 2.0% | | 1.01 | 1.17 | 1.70 |
| 05-lexer-veryl/single | 124800 | 5.36 ± 2.9% | not timed | not timed | 5.65 ± 0.5% | 0.28 ± 8.6% | not timed | not timed | 5.34 ± 4.5% | | 1.00 | 0.95 | 19.42 |
| 06-cloud-flare-redos/original | 107 | 495.35 ± 0.4% | not timed | not timed | 261.96 ± 0.3% | 30.17 ± 0.8% | not timed | not timed | 495.59 ± 0.4% | | 1.00 | 1.89 | 16.42 |
| 06-cloud-flare-redos/simplified-short | 102 | 424.63 ± 9.6% | not timed | not timed | 267.56 ± 0.2% | 33.82 ± 2.8% | not timed | not timed | 425.19 ± 1.9% | | 1.00 | 1.59 | 12.56 |
| 06-cloud-flare-redos/simplified-long | 10000 | 559.56 ± 0.4% | not timed | not timed | 280.31 ± 0.4% | 37.94 ± 0.3% | not timed | not timed | 559.77 ± 0.1% | | 1.00 | 2.00 | 14.75 |
| 07-unicode-character-data/parse-line | 558784 | 274.15 ± 0.5% | not timed | not timed | 205.82 ± 0.3% | 53.75 ± 1.6% | not timed | not timed | 274.97 ± 0.6% | | 1.00 | 1.33 | 5.10 |
| 08-words/all-english | 56691 | 132.92 ± 1.5% | not timed | not timed | 92.65 ± 0.7% | 14.29 ± 10.7% | not timed | not timed | 133.30 ± 0.4% | | 1.00 | 1.43 | 9.30 |
| 08-words/long-english | 839 | 641.07 ± 0.4% | not timed | not timed | 624.30 ± 0.2% | 37.81 ± 0.3% | not timed | not timed | 642.56 ± 0.1% | | 1.00 | 1.03 | 16.96 |
| 09-aws-keys/full | 0 | 646.20 ± 0.4% | not timed | not timed | 578.89 ± 0.3% | 83.42 ± 3.0% | not timed | not timed | 643.99 ± 0.8% | | 1.00 | 1.12 | 7.75 |
| 09-aws-keys/quick | 0 | 1203.89 ± 5.6% | not timed | not timed | 905.91 ± 0.6% | 443.67 ± 5.6% | not timed | not timed | 1204.91 ± 4.0% | | 1.00 | 1.33 | 2.71 |
| 10-bounded-repeat/letters-en | 1833 | 635.31 ± 1.4% | not timed | not timed | 549.65 ± 1.1% | 24.20 ± 0.6% | not timed | not timed | 638.19 ± 1.2% | | 1.00 | 1.16 | 26.25 |
| 10-bounded-repeat/letters-ru | 3475 | 535.83 ± 1.5% | not timed | not timed | 494.75 ± 0.2% | 25.94 ± 8.4% | not timed | not timed | 539.29 ± 1.4% | | 0.99 | 1.08 | 20.66 |
| 10-bounded-repeat/context | 53 | 95.44 ± 2.0% | not timed | not timed | 72.82 ± 3.2% | 24.27 ± 0.4% | not timed | not timed | 94.99 ± 1.6% | | 1.00 | 1.31 | 3.93 |
| 10-bounded-repeat/capitals | 11 | 669.73 ± 7.8% | not timed | not timed | 639.97 ± 0.2% | 44.45 ± 2.0% | not timed | not timed | 670.76 ± 8.1% | | 1.00 | 1.05 | 15.07 |
| 11-unstructured-to-json/extract | 600 | 54.78 ± 5.9% | not timed | not timed | 81.16 ± 0.3% | 64.11 ± 0.6% | not timed | not timed | 54.74 ± 2.1% | | 1.00 | 0.68 | 0.85 |
| 12-dictionary/single | 1 | 574.10 ± 0.9% | not timed | not timed | 549.36 ± 0.1% | 0.51 ± 0.3% | not timed | not timed | 573.34 ± 0.8% | | 1.00 | 1.05 | 1115.11 |
| 14-quadratic/1x | 100 | 29.68 ± 0.8% | not timed | not timed | 13.44 ± 0.4% | 1.24 ± 2.1% | not timed | not timed | 29.76 ± 0.5% | | 1.00 | 2.21 | 23.84 |
| 14-quadratic/2x | 200 | 22.85 ± 0.6% | not timed | not timed | 6.57 ± 0.7% | 0.69 ± 1.4% | not timed | not timed | 22.83 ± 5.4% | | 1.00 | 3.48 | 33.33 |
| 14-quadratic/10x | 1000 | 7.09 ± 1.3% | not timed | not timed | 1.29 ± 0.4% | 0.15 ± 1.1% | not timed | not timed | 7.09 ± 0.8% | | 1.00 | 5.51 | 46.65 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.6% | not timed | not timed | 0.45 ± 0.7% | 0.66 ± 1.9% | not timed | not timed | 1.54 ± 3.2% | | 1.00 | 3.43 | 2.34 |
| 04-ruff-noqa/compile-real | 1 | 146.40 ± 0.8% | not timed | not timed | 15.65 ± 0.6% | 175.20 ± 1.2% | not timed | not timed | 146.03 ± 0.5% | | 1.00 | 9.36 | 0.84 |
| 05-lexer-veryl/compile-single | 1 | 19.23 ± 0.5% | not timed | not timed | 3.04 ± 0.6% | 7.76 ± 2.3% | not timed | not timed | 19.28 ± 0.7% | | 1.00 | 6.33 | 2.48 |
| 07-unicode-character-data/compile | 1 | 151.81 ± 0.4% | not timed | not timed | 31.84 ± 1.4% | 43.89 ± 1.0% | not timed | not timed | 151.89 ± 1.9% | | 1.00 | 4.77 | 3.46 |
| 09-aws-keys/compile-full | 1 | 65.01 ± 1.0% | not timed | not timed | 8.98 ± 0.8% | 27.97 ± 1.7% | not timed | not timed | 65.17 ± 0.8% | | 1.00 | 7.24 | 2.32 |
| 09-aws-keys/compile-quick | 1 | 231.94 ± 0.9% | not timed | not timed | 59.41 ± 0.8% | 165.91 ± 2.9% | not timed | not timed | 230.43 ± 1.1% | | 1.01 | 3.90 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 66.91 ± 0.8% | not timed | not timed | 14.34 ± 0.5% | 20.46 ± 2.5% | not timed | not timed | 66.44 ± 0.5% | | 1.01 | 4.67 | 3.27 |
| 10-bounded-repeat/compile-capitals | 1 | 98.58 ± 1.2% | not timed | not timed | 10.83 ± 0.5% | 29.50 ± 0.9% | not timed | not timed | 98.50 ± 0.8% | | 1.00 | 9.11 | 3.34 |
| 11-unstructured-to-json/compile | 1 | 231.79 ± 0.7% | not timed | not timed | 49.73 ± 1.1% | 82.44 ± 2.4% | not timed | not timed | 231.35 ± 1.3% | | 1.00 | 4.66 | 2.81 |
| 12-dictionary/compile-single | 1 | 0.37 ± 1.4% | not timed | not timed | 0.08 ± 0.4% | 0.11 ± 22.2% | not timed | not timed | 0.37 ± 3.3% | | 1.01 | 4.60 | 3.47 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.37 ± 4.9% | not timed | not timed | 7.77 ± 0.7% | 0.83 ± 15.4% | not timed | not timed | 7.38 ± 2.7% | | 1.00 | 0.95 | 8.84 |
| dictionary/search/english-10 | 690 | 1.44 ± 0.4% | not timed | not timed | 131.18 ± 0.7% | 0.01 ± 0.2% | not timed | not timed | 1.45 ± 0.3% | | 1.00 | 0.0110 | 220.52 |
| dictionary/search/english-15 | 15 | 562.89 ± 1.1% | not timed | not timed | 544.58 ± 0.1% | 0.50 ± 0.4% | not timed | not timed | 563.49 ± 0.9% | | 1.00 | 1.03 | 1130.11 |
| folly/awyer-inn-busted | 1 | 4396.80 ± 0.2% | not timed | not timed | 135.74 ± 0.3% | 55.77 ± 0.4% | not timed | not timed | 4399.05 ± 0.4% | | 1.00 | 32.39 | 78.84 |
| folly/literal-never-match-rare | 0 | 29358.41 ± 0.7% | not timed | not timed | 28852.51 ± 0.7% | 28818.92 ± 0.9% | not timed | not timed | 29503.35 ± 0.5% | | 1.00 | 1.02 | 1.02 |
| folly/literal-never-match-frequent | 0 | 18137.82 ± 0.6% | not timed | not timed | 28763.96 ± 0.2% | 2583.45 ± 0.3% | not timed | not timed | 18191.65 ± 1.1% | | 1.00 | 0.63 | 7.02 |
| folly/literal-never-match-tricksy | 1 | 3371.10 ± 0.4% | not timed | not timed | 5560.62 ± 2.5% | 1625.96 ± 0.3% | not timed | not timed | 3375.96 ± 0.1% | | 1.00 | 0.61 | 2.07 |
| grep/every-line | 239963 | 1501.41 ± 3.2% | not timed | not timed | 937.57 ± 0.5% | 404.63 ± 23.3% | not timed | not timed | 1502.61 ± 0.6% | | 1.00 | 1.60 | 3.71 |
| grep/long-words-ascii | 5073 | 555.00 ± 0.5% | not timed | not timed | 518.77 ± 0.5% | 53.58 ± 6.8% | not timed | not timed | 555.46 ± 0.4% | | 1.00 | 1.07 | 10.36 |
| imported/leipzig/twain | 811 | 28645.82 ± 1.2% | not timed | not timed | 27967.40 ± 0.1% | 12418.10 ± 10.2% | not timed | not timed | 28658.87 ± 0.8% | | 1.00 | 1.02 | 2.31 |
| imported/leipzig/twain-insensitive | 965 | 13311.02 ± 2.4% | not timed | not timed | 7396.73 ± 1.2% | 53.43 ± 0.2% | not timed | not timed | 13561.44 ± 2.6% | | 0.98 | 1.80 | 249.13 |
| imported/leipzig/shing | 1540 | 21736.92 ± 1.2% | not timed | not timed | 17889.07 ± 0.3% | 41.71 ± 0.2% | not timed | not timed | 21930.45 ± 1.6% | | 0.99 | 1.22 | 521.10 |
| imported/leipzig/huck-saw | 262 | 18421.53 ± 4.7% | not timed | not timed | 16169.09 ± 0.3% | 42.46 ± 0.3% | not timed | not timed | 19111.39 ± 6.2% | | 0.96 | 1.14 | 433.86 |
| imported/leipzig/word-ending-nn | 262 | 641.00 ± 0.1% | not timed | not timed | 639.45 ± 0.2% | 30.39 ± 1.5% | not timed | not timed | 640.99 ± 0.2% | | 1.00 | 1.00 | 21.09 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11381.49 ± 1.5% | not timed | not timed | 4294.36 ± 0.3% | 12.57 ± 0.2% | not timed | not timed | 11495.93 ± 1.4% | | 0.99 | 2.65 | 905.35 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 16651.01 ± 2.9% | not timed | not timed | 14846.83 ± 0.4% | 22.84 ± 0.5% | not timed | not timed | 17089.17 ± 3.7% | | 0.97 | 1.12 | 729.14 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5716.66 ± 1.7% | not timed | not timed | 958.20 ± 1.1% | 13.71 ± 0.3% | not timed | not timed | 5779.95 ± 1.2% | | 0.99 | 5.97 | 417.07 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 640.09 ± 0.1% | not timed | not timed | 638.81 ± 0.2% | 14.42 ± 0.4% | not timed | not timed | 640.11 ± 0.2% | | 1.00 | 1.00 | 44.39 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 639.90 ± 0.3% | not timed | not timed | 639.00 ± 0.3% | 12.19 ± 0.6% | not timed | not timed | 640.57 ± 0.2% | | 1.00 | 1.00 | 52.49 |
| imported/leipzig/tom-river | 2 | 11029.29 ± 3.1% | not timed | not timed | 12113.48 ± 0.7% | 40.84 ± 0.6% | not timed | not timed | 11204.25 ± 3.3% | | 0.98 | 0.91 | 270.07 |
| imported/leipzig/ing | 78424 | 626.76 ± 0.8% | not timed | not timed | 590.96 ± 1.5% | 32.98 ± 3.6% | not timed | not timed | 626.75 ± 1.1% | | 1.00 | 1.06 | 19.00 |
| imported/leipzig/ing-whitespace | 55248 | 781.77 ± 1.1% | not timed | not timed | 2315.00 ± 0.9% | 24.41 ± 3.5% | not timed | not timed | 784.29 ± 1.1% | | 1.00 | 0.34 | 32.03 |
| imported/leipzig/awyer-inn | 209 | 808.62 ± 1.4% | not timed | not timed | 7456.83 ± 0.3% | 27.69 ± 0.7% | not timed | not timed | 808.98 ± 1.1% | | 1.00 | 0.11 | 29.21 |
| imported/leipzig/quotes-bounded | 8886 | 1838.51 ± 3.9% | not timed | not timed | 3405.04 ± 0.5% | 44.11 ± 1.3% | not timed | not timed | 1879.00 ± 3.8% | | 0.98 | 0.54 | 41.68 |
| imported/leipzig/non-ascii-alternate | 2 | 24724.45 ± 2.0% | not timed | not timed | 16865.87 ± 0.3% | 62.79 ± 2.1% | not timed | not timed | 25004.68 ± 1.4% | | 0.99 | 1.47 | 393.77 |
| imported/leipzig/math-symbols | 69 | 2145.99 ± 10.2% | not timed | not timed | 639.29 ± 0.2% | 44.64 ± 0.6% | not timed | not timed | 2326.15 ± 5.6% | | 0.92 | 3.36 | 48.08 |
| imported/leipzig/bounded-strings-ending-z | 0 | 639.18 ± 0.6% | not timed | not timed | 639.35 ± 2.0% | 30.14 ± 1.1% | not timed | not timed | 640.17 ± 0.3% | | 1.00 | 1.00 | 21.21 |
| imported/lh3lh3-reb/uri | 17549 | 863.70 ± 3.1% | not timed | not timed | 1051.43 ± 0.7% | 34.58 ± 2.6% | not timed | not timed | 865.01 ± 5.0% | | 1.00 | 0.82 | 24.98 |
| imported/lh3lh3-reb/email | 15057 | 854.60 ± 0.9% | not timed | not timed | 1077.88 ± 0.6% | 37.86 ± 2.9% | not timed | not timed | 856.16 ± 4.1% | | 1.00 | 0.79 | 22.57 |
| imported/lh3lh3-reb/date | 668 | 893.78 ± 4.1% | not timed | not timed | 972.68 ± 0.5% | 61.23 ± 1.8% | not timed | not timed | 899.42 ± 3.3% | | 0.99 | 0.92 | 14.60 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 811.08 ± 2.8% | not timed | not timed | 477.38 ± 0.4% | 19.00 ± 1.5% | not timed | not timed | 804.58 ± 4.1% | | 1.01 | 1.70 | 42.68 |
| imported/mariomka/email | 92 | 23651.80 ± 1.0% | not timed | not timed | 26362.59 ± 0.2% | 38.57 ± 2.7% | not timed | not timed | 23700.04 ± 1.8% | | 1.00 | 0.90 | 613.24 |
| imported/mariomka/uri | 5301 | 6762.68 ± 3.9% | not timed | not timed | 7249.75 ± 0.8% | 39.17 ± 0.7% | not timed | not timed | 6772.11 ± 3.5% | | 1.00 | 0.93 | 172.63 |
| imported/mariomka/ip | 5 | 1901.51 ± 4.3% | not timed | not timed | 2422.57 ± 0.8% | 26.22 ± 2.1% | not timed | not timed | 1918.98 ± 6.0% | | 0.99 | 0.78 | 72.53 |
| imported/rsc/no-exponential | 0 | 1058.14 ± 1.9% | not timed | not timed | 641.13 ± 8.4% | 30.53 ± 1.0% | not timed | not timed | 1055.52 ± 1.6% | | 1.00 | 1.65 | 34.66 |
| imported/rsc/literal | 1 | 796.40 ± 2.1% | not timed | not timed | 2752.31 ± 0.8% | 257.29 ± 15.4% | not timed | not timed | 786.87 ± 3.4% | | 1.01 | 0.29 | 3.10 |
| imported/rsc/not-literal | 2 | 1040.62 ± 10.1% | not timed | not timed | 1424.74 ± 0.8% | 64.51 ± 5.1% | not timed | not timed | 1035.93 ± 11.4% | | 1.00 | 0.73 | 16.13 |
| imported/rsc/match-class | 1 | 1888.92 ± 2.0% | not timed | not timed | 2763.28 ± 0.6% | 74.76 ± 3.0% | not timed | not timed | 1889.92 ± 12.8% | | 1.00 | 0.68 | 25.27 |
| imported/rsc/match-class-in-range | 1 | 1888.83 ± 13.0% | not timed | not timed | 4371.41 ± 0.7% | 77.98 ± 1.8% | not timed | not timed | 1893.75 ± 0.8% | | 1.00 | 0.43 | 24.22 |
| imported/rsc/match-class-unicode | 1 | 613.62 ± 0.5% | not timed | not timed | 594.66 ± 0.6% | 83.63 ± 9.2% | not timed | not timed | 613.10 ± 1.7% | | 1.00 | 1.03 | 7.34 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1848.15 ± 1.2% | not timed | not timed | 1563.10 ± 0.5% | 421.86 ± 4.0% | not timed | not timed | 1851.60 ± 1.2% | | 1.00 | 1.18 | 4.38 |
| imported/rsc/anchored-literal-long-non-match | 0 | 27642.85 ± 1.9% | not timed | not timed | 23060.75 ± 0.6% | 6320.82 ± 1.6% | not timed | not timed | 27683.73 ± 1.4% | | 1.00 | 1.20 | 4.37 |
| imported/rsc/anchored-literal-short-match | 4 | 887.46 ± 2.1% | not timed | not timed | 1013.29 ± 1.1% | 109.62 ± 7.0% | not timed | not timed | 895.84 ± 1.4% | | 0.99 | 0.88 | 8.10 |
| imported/rsc/anchored-literal-long-match | 4 | 13268.13 ± 1.9% | not timed | not timed | 15201.95 ± 0.8% | 1654.24 ± 1.4% | not timed | not timed | 13348.51 ± 2.2% | | 0.99 | 0.87 | 8.02 |
| imported/rsc/one-pass-short | 17 | 556.34 ± 17.2% | not timed | not timed | 484.87 ± 11.2% | 42.84 ± 9.2% | not timed | not timed | 566.35 ± 2.5% | | 0.98 | 1.15 | 12.99 |
| imported/rsc/one-pass-short-not | 17 | 467.36 ± 1.9% | not timed | not timed | 443.91 ± 0.7% | 41.77 ± 23.6% | not timed | not timed | 468.45 ± 0.2% | | 1.00 | 1.05 | 11.19 |
| imported/rsc/one-pass-long-prefix | 26 | 618.92 ± 6.8% | not timed | not timed | 551.69 ± 0.3% | 125.48 ± 14.9% | not timed | not timed | 624.68 ± 1.4% | | 0.99 | 1.12 | 4.93 |
| imported/rsc/one-pass-long-prefix-not | 26 | 625.16 ± 5.5% | not timed | not timed | 551.66 ± 0.5% | 97.89 ± 16.1% | not timed | not timed | 625.88 ± 2.1% | | 1.00 | 1.13 | 6.39 |
| imported/rsc/long-needle1 | 31 | 42385.45 ± 0.3% | not timed | not timed | 37625.39 ± 4.4% | 4.85 ± 25.6% | not timed | not timed | 42392.76 ± 0.3% | | 1.00 | 1.13 | 8732.31 |
| imported/rsc/long-needle2 | 31 | 42115.87 ± 0.6% | not timed | not timed | 258.22 ± 0.4% | 4.82 ± 1.6% | not timed | not timed | 42096.68 ± 3.7% | | 1.00 | 163.10 | 8730.05 |
| imported/rsc/easy0-32 | 26 | 1161.05 ± 12.6% | not timed | not timed | 2640.63 ± 0.5% | 193.22 ± 19.1% | not timed | not timed | 1186.77 ± 3.4% | | 0.98 | 0.44 | 6.01 |
| imported/rsc/easy0-1k | 26 | 25641.29 ± 5.1% | not timed | not timed | 19299.95 ± 0.7% | 3103.79 ± 10.6% | not timed | not timed | 25724.95 ± 3.6% | | 1.00 | 1.33 | 8.26 |
| imported/rsc/easy0-32k | 26 | 54615.40 ± 2.1% | not timed | not timed | 39581.91 ± 7.7% | 27945.35 ± 13.5% | not timed | not timed | 54694.28 ± 5.7% | | 1.00 | 1.38 | 1.95 |
| imported/rsc/easy0-1mb | 26 | 42920.72 ± 0.3% | not timed | not timed | 40886.08 ± 0.4% | 58045.40 ± 0.3% | not timed | not timed | 42914.52 ± 0.4% | | 1.00 | 1.05 | 0.74 |
| imported/rsc/easy1-32 | 19 | 1346.88 ± 1.3% | not timed | not timed | 1355.37 ± 9.2% | 182.52 ± 17.0% | not timed | not timed | 1352.78 ± 7.0% | | 1.00 | 0.99 | 7.38 |
| imported/rsc/easy1-1k | 19 | 27680.99 ± 7.4% | not timed | not timed | 27779.89 ± 2.1% | 3190.21 ± 10.6% | not timed | not timed | 27681.87 ± 5.9% | | 1.00 | 1.00 | 8.68 |
| imported/rsc/easy1-32k | 19 | 869298.04 ± 1.8% | not timed | not timed | 873562.38 ± 0.2% | 30323.54 ± 43.1% | not timed | not timed | 869332.41 ± 7.9% | | 1.00 | 1.00 | 28.67 |
| imported/rsc/easy1-1mb | 19 | 27790918.41 ± 0.3% | not timed | not timed | 27917140.52 ± 0.2% | 60451.03 ± 0.1% | not timed | not timed | 27824377.45 ± 0.1% | | 1.00 | 1.00 | 459.73 |
| imported/rsc/medium-32 | 27 | 870.05 ± 8.4% | not timed | not timed | 1260.25 ± 0.4% | 94.51 ± 9.7% | not timed | not timed | 879.69 ± 3.1% | | 0.99 | 0.69 | 9.21 |
| imported/rsc/medium-1k | 27 | 15674.04 ± 3.2% | not timed | not timed | 22441.49 ± 0.1% | 98.31 ± 0.6% | not timed | not timed | 15847.65 ± 3.5% | | 0.99 | 0.70 | 159.43 |
| imported/rsc/medium-32k | 27 | 483398.84 ± 3.8% | not timed | not timed | 701085.24 ± 0.4% | 64.84 ± 1.2% | not timed | not timed | 500517.31 ± 6.0% | | 0.97 | 0.69 | 7455.58 |
| imported/rsc/medium-1mb | 27 | 15771436.22 ± 6.5% | not timed | not timed | 22424868.04 ± 0.2% | 66.26 ± 0.7% | not timed | not timed | 15777331.92 ± 10.2% | | 1.00 | 0.70 | 238037.30 |
| imported/rsc/hard-32 | 58 | 542.49 ± 0.6% | not timed | not timed | 479.88 ± 0.4% | 64.79 ± 12.2% | not timed | not timed | 543.47 ± 3.0% | | 1.00 | 1.13 | 8.37 |
| imported/rsc/hard-1k | 27 | 17382.84 ± 2.6% | not timed | not timed | 19562.79 ± 0.3% | 53.15 ± 0.5% | not timed | not timed | 17731.31 ± 2.7% | | 0.98 | 0.89 | 327.08 |
| imported/rsc/hard-32k | 27 | 551959.99 ± 4.3% | not timed | not timed | 612426.96 ± 1.0% | 39.41 ± 0.5% | not timed | not timed | 550213.94 ± 5.4% | | 1.00 | 0.90 | 14006.73 |
| imported/rsc/hard-1mb | 51 | 10149777.39 ± 3.9% | not timed | not timed | 8634994.31 ± 0.3% | 39.58 ± 0.2% | not timed | not timed | 10314529.76 ± 5.1% | | 0.98 | 1.18 | 256431.73 |
| imported/rsc/reallyhard0-32 | 58 | 338.72 ± 0.1% | not timed | not timed | 291.56 ± 0.3% | 65.32 ± 11.8% | not timed | not timed | 338.39 ± 1.6% | | 1.00 | 1.16 | 5.19 |
| imported/rsc/reallyhard0-1k | 27 | 617.23 ± 0.3% | not timed | not timed | 625.57 ± 0.5% | 53.15 ± 0.5% | not timed | not timed | 618.46 ± 0.4% | | 1.00 | 0.99 | 11.61 |
| imported/rsc/reallyhard0-32k | 27 | 628.24 ± 0.1% | not timed | not timed | 641.43 ± 0.3% | 39.41 ± 0.7% | not timed | not timed | 628.21 ± 0.2% | | 1.00 | 0.98 | 15.94 |
| imported/rsc/reallyhard0-1mb | 51 | 640.30 ± 0.8% | not timed | not timed | 640.50 ± 0.3% | 39.84 ± 0.8% | not timed | not timed | 640.02 ± 0.3% | | 1.00 | 1.00 | 16.07 |
| imported/rsc/reallyreallyhard0-32 | 47 | 348.71 ± 2.4% | not timed | not timed | 263.55 ± 0.4% | 76.31 ± 9.9% | not timed | not timed | 351.41 ± 5.0% | | 0.99 | 1.32 | 4.57 |
| imported/rsc/reallyreallyhard0-1k | 16 | 9574.26 ± 0.5% | not timed | not timed | 9422.03 ± 10.5% | 41.21 ± 0.9% | not timed | not timed | 9582.85 ± 0.4% | | 1.00 | 1.02 | 232.31 |
| imported/rsc/reallyreallyhard0-32k | 16 | 49767.77 ± 0.4% | not timed | not timed | 37168.61 ± 1.2% | 30.61 ± 0.5% | not timed | not timed | 49686.91 ± 0.4% | | 1.00 | 1.34 | 1625.83 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 48896.30 ± 0.1% | not timed | not timed | 40605.70 ± 0.3% | 30.76 ± 0.1% | not timed | not timed | 48918.49 ± 0.2% | | 1.00 | 1.20 | 1589.54 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 342.49 ± 2.1% | not timed | not timed | 247.48 ± 0.5% | 76.73 ± 16.8% | not timed | not timed | 342.20 ± 1.2% | | 1.00 | 1.38 | 4.46 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 7684.61 ± 0.3% | not timed | not timed | 9024.24 ± 2.7% | 41.34 ± 1.0% | not timed | not timed | 7682.27 ± 0.3% | | 1.00 | 0.85 | 185.91 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 47256.14 ± 0.8% | not timed | not timed | 36728.48 ± 1.0% | 30.47 ± 0.5% | not timed | not timed | 47187.16 ± 0.5% | | 1.00 | 1.29 | 1550.96 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 41972.99 ± 0.8% | not timed | not timed | 35909.52 ± 0.6% | 30.72 ± 1.0% | not timed | not timed | 41851.13 ± 0.7% | | 1.00 | 1.17 | 1366.13 |
| imported/sherlock/name-sherlock | 776 | 35832.40 ± 1.8% | not timed | not timed | 33263.62 ± 0.4% | 11965.68 ± 23.9% | not timed | not timed | 36257.91 ± 2.1% | | 0.99 | 1.08 | 2.99 |
| imported/sherlock/name-holmes | 2766 | 23105.31 ± 6.9% | not timed | not timed | 25140.37 ± 1.2% | 3913.14 ± 8.0% | not timed | not timed | 23593.77 ± 4.1% | | 0.98 | 0.92 | 5.90 |
| imported/sherlock/name-sherlock-holmes | 1365 | 36258.61 ± 7.1% | not timed | not timed | 32672.67 ± 0.4% | 10420.85 ± 30.3% | not timed | not timed | 36472.30 ± 2.9% | | 0.99 | 1.11 | 3.48 |
| imported/sherlock/name-sherlock-casei | 816 | 31836.83 ± 0.7% | not timed | not timed | 10137.30 ± 3.7% | 40.05 ± 0.9% | not timed | not timed | 31800.83 ± 5.9% | | 1.00 | 3.14 | 794.88 |
| imported/sherlock/name-holmes-casei | 2802 | 18137.11 ± 7.1% | not timed | not timed | 7039.64 ± 0.6% | 54.22 ± 1.2% | not timed | not timed | 18456.28 ± 4.7% | | 0.98 | 2.58 | 334.53 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 28140.51 ± 1.5% | not timed | not timed | 9951.80 ± 0.4% | 39.98 ± 3.6% | not timed | not timed | 28113.50 ± 1.1% | | 1.00 | 2.83 | 703.87 |
| imported/sherlock/name-whitespace | 1461 | 25618.09 ± 10.5% | not timed | not timed | 26323.31 ± 0.3% | 8165.35 ± 19.9% | not timed | not timed | 25962.63 ± 1.7% | | 0.99 | 0.97 | 3.14 |
| imported/sherlock/name-alt1 | 1142 | 24036.27 ± 0.5% | not timed | not timed | 35053.29 ± 2.0% | 5228.90 ± 31.0% | not timed | not timed | 23918.91 ± 9.3% | | 1.00 | 0.69 | 4.60 |
| imported/sherlock/name-alt2 | 3542 | 16620.78 ± 0.7% | not timed | not timed | 8775.39 ± 0.6% | 41.55 ± 0.6% | not timed | not timed | 16612.83 ± 0.8% | | 1.00 | 1.89 | 400.05 |
| imported/sherlock/name-alt3 | 4507 | 11843.51 ± 2.1% | not timed | not timed | 7828.36 ± 2.1% | 13.17 ± 1.3% | not timed | not timed | 11817.53 ± 2.2% | | 1.00 | 1.51 | 899.35 |
| imported/sherlock/name-alt3-casei | 4593 | 1757.93 ± 1.8% | not timed | not timed | 1386.36 ± 0.3% | 8.29 ± 5.0% | not timed | not timed | 1764.17 ± 1.9% | | 1.00 | 1.27 | 212.17 |
| imported/sherlock/name-alt4 | 3686 | 10265.64 ± 0.3% | not timed | not timed | 8198.42 ± 0.8% | 41.63 ± 0.3% | not timed | not timed | 10251.21 ± 0.5% | | 1.00 | 1.25 | 246.59 |
| imported/sherlock/name-alt4-casei | 4254 | 3965.17 ± 7.0% | not timed | not timed | 4002.67 ± 0.8% | 23.92 ± 0.2% | not timed | not timed | 4005.08 ± 3.6% | | 0.99 | 0.99 | 165.75 |
| imported/sherlock/name-alt5 | 4028 | 14163.97 ± 0.8% | not timed | not timed | 8354.86 ± 0.3% | 28.73 ± 1.4% | not timed | not timed | 14159.58 ± 5.0% | | 1.00 | 1.70 | 492.92 |
| imported/sherlock/name-alt5-casei | 4104 | 5875.93 ± 16.5% | not timed | not timed | 2999.93 ± 4.4% | 17.50 ± 0.4% | not timed | not timed | 6062.25 ± 17.4% | | 0.97 | 1.96 | 335.77 |
| imported/sherlock/no-match-uncommon | 0 | 42437.98 ± 0.4% | not timed | not timed | 37099.21 ± 0.7% | 54318.32 ± 0.3% | not timed | not timed | 42454.37 ± 0.6% | | 1.00 | 1.14 | 0.78 |
| imported/sherlock/no-match-common | 0 | 42099.48 ± 0.5% | not timed | not timed | 37078.25 ± 0.4% | 1997.43 ± 0.6% | not timed | not timed | 42055.42 ± 0.3% | | 1.00 | 1.14 | 21.08 |
| imported/sherlock/no-match-really-common | 0 | 33165.25 ± 1.5% | not timed | not timed | 31924.15 ± 0.5% | 1995.47 ± 0.5% | not timed | not timed | 33172.77 ± 0.9% | | 1.00 | 1.04 | 16.62 |
| imported/sherlock/the-lower | 21654 | 2900.62 ± 1.7% | not timed | not timed | 2460.03 ± 0.5% | 280.73 ± 25.6% | not timed | not timed | 2953.38 ± 1.9% | | 0.98 | 1.18 | 10.33 |
| imported/sherlock/the-upper | 2223 | 17861.44 ± 2.0% | not timed | not timed | 21465.62 ± 0.9% | 3024.99 ± 20.4% | not timed | not timed | 17937.24 ± 1.5% | | 1.00 | 0.83 | 5.90 |
| imported/sherlock/the-casei | 23961 | 2598.93 ± 2.9% | not timed | not timed | 1467.93 ± 0.4% | 48.04 ± 42.9% | not timed | not timed | 2617.05 ± 1.3% | | 0.99 | 1.77 | 54.10 |
| imported/sherlock/everything-greedy | 581881 | 326.58 ± 0.7% | not timed | not timed | 199.92 ± 0.2% | 35.34 ± 36.7% | not timed | not timed | 327.08 ± 0.4% | | 1.00 | 1.63 | 9.24 |
| imported/sherlock/everything-greedy-nl | 594933 | 488.90 ± 0.4% | not timed | not timed | 255.28 ± 0.9% | 40.73 ± 0.6% | not timed | not timed | 489.59 ± 0.2% | | 1.00 | 1.92 | 12.00 |
| imported/sherlock/letters | 447175 | 67.86 ± 10.4% | not timed | not timed | 41.56 ± 0.3% | 5.89 ± 22.5% | not timed | not timed | 68.81 ± 8.6% | | 0.99 | 1.63 | 11.52 |
| imported/sherlock/letters-upper | 14180 | 467.03 ± 6.0% | not timed | not timed | 403.95 ± 0.1% | 33.76 ± 7.9% | not timed | not timed | 467.76 ± 0.4% | | 1.00 | 1.16 | 13.83 |
| imported/sherlock/letters-lower | 432995 | 70.23 ± 0.9% | not timed | not timed | 42.56 ± 0.1% | 5.40 ± 34.8% | not timed | not timed | 70.00 ± 1.1% | | 1.00 | 1.65 | 13.00 |
| imported/sherlock/words | 447639 | 132.43 ± 6.6% | not timed | not timed | 93.10 ± 0.5% | 15.01 ± 10.5% | not timed | not timed | 132.47 ± 6.8% | | 1.00 | 1.42 | 8.82 |
| imported/sherlock/before-holmes | 4073 | 14623.49 ± 0.2% | not timed | not timed | 14630.39 ± 0.7% | 28.15 ± 0.5% | not timed | not timed | 14594.80 ± 1.4% | | 1.00 | 1.00 | 519.58 |
| imported/sherlock/before-after-holmes | 2593 | 14422.37 ± 0.7% | not timed | not timed | 16030.98 ± 0.4% | 28.17 ± 0.5% | not timed | not timed | 14361.31 ± 0.8% | | 1.00 | 0.90 | 511.97 |
| imported/sherlock/holmes-cochar-watson | 150 | 8283.12 ± 0.5% | not timed | not timed | 7081.11 ± 0.5% | 41.60 ± 4.6% | not timed | not timed | 8288.61 ± 0.6% | | 1.00 | 1.17 | 199.09 |
| imported/sherlock/holmes-coword-watson | 14309 | 1327.11 ± 0.3% | not timed | not timed | 1297.83 ± 0.5% | 8.38 ± 0.5% | not timed | not timed | 1327.04 ± 2.3% | | 1.00 | 1.02 | 158.34 |
| imported/sherlock/quotes | 14437 | 1354.85 ± 0.2% | not timed | not timed | 2015.77 ± 2.7% | 40.84 ± 0.4% | not timed | not timed | 1356.09 ± 0.3% | | 1.00 | 0.67 | 33.17 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 627.12 ± 0.3% | not timed | not timed | 28405.28 ± 0.3% | 48.19 ± 4.6% | not timed | not timed | 628.44 ± 0.3% | | 1.00 | 0.0221 | 13.01 |
| imported/sherlock/word-ending-n | 35297 | 484.58 ± 0.8% | not timed | not timed | 434.28 ± 1.6% | 28.15 ± 0.4% | not timed | not timed | 485.11 ± 0.4% | | 1.00 | 1.12 | 17.21 |
| imported/sherlock/repeated-class-negation | 2130 | 18956.29 ± 1.8% | not timed | not timed | 18376.34 ± 1.8% | 12.63 ± 1.6% | not timed | not timed | 18856.83 ± 2.8% | | 1.01 | 1.03 | 1501.24 |
| imported/sherlock/ing-suffix | 20547 | 584.11 ± 0.8% | not timed | not timed | 545.93 ± 0.4% | 33.73 ± 22.9% | not timed | not timed | 584.52 ± 1.4% | | 1.00 | 1.07 | 17.32 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 623.47 ± 0.7% | not timed | not timed | 2712.33 ± 1.1% | 24.44 ± 5.1% | not timed | not timed | 623.42 ± 1.8% | | 1.00 | 0.23 | 25.51 |
| opt/accelerate/whole-line | 239963 | 561.85 ± 3.3% | not timed | not timed | 441.25 ± 0.3% | 111.80 ± 18.5% | not timed | not timed | 561.91 ± 0.2% | | 1.00 | 1.27 | 5.03 |
| opt/accelerate/non-dna | 16745 | 525.19 ± 0.8% | not timed | not timed | 505.90 ± 0.2% | 36.11 ± 23.2% | not timed | not timed | 526.82 ± 0.1% | | 1.00 | 1.04 | 14.55 |
| opt/backtrack/words-english | 40536 | 145.43 ± 0.9% | not timed | not timed | 123.99 ± 0.2% | 24.33 ± 8.9% | not timed | not timed | 145.15 ± 5.2% | | 1.00 | 1.17 | 5.98 |
| opt/fixed-length/too-small-ascii | 0 | 416.41 ± 4.8% | not timed | not timed | 991.51 ± 1.2% | 143.67 ± 4.1% | not timed | not timed | 415.85 ± 2.5% | | 1.00 | 0.42 | 2.90 |
| opt/fixed-length/too-big-ascii | 0 | 5287.90 ± 8.8% | not timed | not timed | 8255.75 ± 2.9% | 172.86 ± 1.6% | not timed | not timed | 5160.66 ± 5.1% | | 1.02 | 0.64 | 30.59 |
| opt/fixed-length/go33484-1 | 0 | 1016265.51 ± 2.5% | not timed | not timed | 1613900.36 ± 2.8% | 107943.72 ± 1.5% | not timed | not timed | 1015908.75 ± 1.0% | | 1.00 | 0.63 | 9.41 |
| opt/fixed-length/go33484-2 | 0 | 1038916.37 ± 3.5% | not timed | not timed | 1610652.45 ± 9.6% | 48750.16 ± 1.7% | not timed | not timed | 1018857.82 ± 3.2% | | 1.02 | 0.65 | 21.31 |
| opt/fixed-length/go33484-3 | 0 | 2700.83 ± 0.3% | not timed | not timed | 162739.47 ± 3.0% | 1111.50 ± 0.9% | not timed | not timed | 2560.57 ± 0.7% | | 1.05 | 0.0166 | 2.43 |
| opt/literal-alt/one-pattern | 1 | 650.14 ± 4.5% | not timed | not timed | 654.56 ± 0.3% | 0.52 ± 0.7% | not timed | not timed | 650.51 ± 1.6% | | 1.00 | 0.99 | 1256.07 |
| opt/onepass/fn-predicate | 916 | 461.46 ± 0.7% | not timed | not timed | 429.90 ± 0.2% | 232.61 ± 16.5% | not timed | not timed | 462.74 ± 0.6% | | 1.00 | 1.07 | 1.98 |
| opt/onepass/first-three-words-english | 35128 | 188.64 ± 8.5% | not timed | not timed | 243.19 ± 0.5% | 90.92 ± 14.6% | not timed | not timed | 188.18 ± 0.9% | | 1.00 | 0.78 | 2.07 |
| opt/prefilter/literal-english | 1 | 41217.58 ± 0.9% | not timed | not timed | 35937.35 ± 0.6% | 24355.29 ± 1.2% | not timed | not timed | 41162.48 ± 0.8% | | 1.00 | 1.15 | 1.69 |
| opt/prefilter/literal-casei-english | 1 | 31496.12 ± 1.1% | not timed | not timed | 11789.76 ± 0.6% | 40.39 ± 0.9% | not timed | not timed | 31589.57 ± 0.9% | | 1.00 | 2.67 | 779.77 |
| opt/prefilter/literal-russian | 1 | 42737.12 ± 2.9% | not timed | not timed | 36257.37 ± 0.9% | 2168.30 ± 3.8% | not timed | not timed | 42715.48 ± 1.1% | | 1.00 | 1.18 | 19.71 |
| opt/prefilter/literal-casei-russian | 1 | 23525.28 ± 9.3% | not timed | not timed | 8943.27 ± 1.5% | 42.26 ± 0.8% | not timed | not timed | 23574.30 ± 0.2% | | 1.00 | 2.63 | 556.62 |
| opt/prefilter/rust-functions | 948 | 12772.19 ± 5.4% | not timed | not timed | 11327.25 ± 1.2% | 2092.73 ± 0.6% | not timed | not timed | 12830.71 ± 0.6% | | 1.00 | 1.13 | 6.10 |
| opt/reverse-anchored/word-end | 1 | 43397334.71 ± 7.2% | not timed | not timed | 37365765.40 ± 0.8% | 63.74 ± 0.9% | not timed | not timed | 43305997.27 ± 0.9% | | 1.00 | 1.16 | 680858.83 |
| opt/reverse-inner/holmes | 2593 | 14344.27 ± 1.2% | not timed | not timed | 15943.45 ± 1.3% | 28.04 ± 0.9% | not timed | not timed | 14279.74 ± 1.1% | | 1.00 | 0.90 | 511.63 |
| opt/reverse-inner/email | 47 | 29143.99 ± 0.7% | not timed | not timed | 29406.55 ± 0.2% | 38.60 ± 0.8% | not timed | not timed | 29246.80 ± 0.5% | | 1.00 | 0.99 | 755.00 |
| opt/reverse-inner/factored-prefix | 3542 | 618.51 ± 0.3% | not timed | not timed | 624.66 ± 0.1% | 14.95 ± 0.7% | not timed | not timed | 617.90 ± 0.5% | | 1.00 | 0.99 | 41.39 |
| opt/reverse-inner/no-quadratic-backward | 0 | 4350.63 ± 0.5% | not timed | not timed | 641.23 ± 0.6% | 101.99 ± 2.8% | not timed | not timed | 4348.44 ± 0.3% | | 1.00 | 6.78 | 42.66 |
| opt/reverse-inner/no-quadratic-forward | 0 | 745.67 ± 1.5% | not timed | not timed | 294.85 ± 0.5% | 34.74 ± 0.7% | not timed | not timed | 744.33 ± 1.6% | | 1.00 | 2.53 | 21.46 |
| opt/reverse-suffix/holmes | 4073 | 14592.41 ± 1.2% | not timed | not timed | 14534.09 ± 0.6% | 28.16 ± 0.5% | not timed | not timed | 14558.82 ± 1.4% | | 1.00 | 1.00 | 518.25 |
| opt/reverse-suffix/no-quadratic | 0 | 4343.90 ± 0.5% | not timed | not timed | 640.87 ± 0.6% | 101.73 ± 1.2% | not timed | not timed | 4340.10 ± 0.6% | | 1.00 | 6.78 | 42.70 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 152.06 ± 8.0% | not timed | not timed | 224.49 ± 1.3% | 16.93 ± 18.4% | not timed | not timed | 152.39 ± 3.1% | | 1.00 | 0.68 | 8.98 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 153.09 ± 3.1% | not timed | not timed | 223.79 ± 2.0% | 17.45 ± 27.3% | not timed | not timed | 150.60 ± 3.8% | | 1.02 | 0.68 | 8.77 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.38 ± 2.1% | not timed | not timed | 0.60 ± 0.4% | 131.37 ± 8.2% | not timed | not timed | 0.38 ± 6.1% | | 1.02 | 0.63 | 0.0029 |
| reported/i1095-word-repetition/ascii-search | 256 | 335.46 ± 0.6% | not timed | not timed | 319.92 ± 0.6% | 119.71 ± 0.8% | not timed | not timed | 336.09 ± 0.2% | | 1.00 | 1.05 | 2.80 |
| reported/i13-subset-regex/original-ascii | 4094 | 11393.77 ± 1.3% | not timed | not timed | 4290.18 ± 0.4% | 12.37 ± 0.4% | not timed | not timed | 11415.93 ± 1.8% | | 1.00 | 2.66 | 921.34 |
| reported/i13-subset-regex/original-unicode | 4094 | 11309.51 ± 1.4% | not timed | not timed | 248.04 ± 2.6% | 12.34 ± 0.6% | not timed | not timed | 11367.50 ± 1.2% | | 0.99 | 45.60 | 916.14 |
| reported/i13-subset-regex/big-ascii | 1955 | 10354.18 ± 2.8% | not timed | not timed | 67.18 ± 3.3% | 10.83 ± 0.5% | not timed | not timed | 10365.36 ± 1.2% | | 1.00 | 154.12 | 956.13 |
| reported/i13-subset-regex/big-unicode | 1955 | 10364.04 ± 1.0% | not timed | not timed | 12.03 ± 55.1% | 10.85 ± 0.2% | not timed | not timed | 10369.82 ± 1.9% | | 1.00 | 861.42 | 955.60 |
| reported/i13-subset-regex/huge-ascii | 55 | 9748.87 ± 4.9% | not timed | not timed | 11.34 ± 0.3% | 10.13 ± 0.6% | not timed | not timed | 9762.55 ± 4.9% | | 1.00 | 859.53 | 962.20 |
| reported/i13-subset-regex/huge-unicode | 55 | 9655.43 ± 1.7% | not timed | not timed | 11.12 ± 0.7% | 10.13 ± 1.3% | not timed | not timed | 9640.03 ± 2.0% | | 1.00 | 867.92 | 952.87 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.47 ± 0.4% | not timed | not timed | 11.32 ± 0.3% | 10.13 ± 1.6% | not timed | not timed | 4.43 ± 0.3% | | 1.01 | 0.39 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 6.36 ± 0.5% | not timed | not timed | 11.14 ± 0.8% | 10.10 ± 0.7% | not timed | not timed | 6.36 ± 0.5% | | 1.00 | 0.57 | 0.63 |
| reported/i787-keywords/ascii | 5674 | 553.98 ± 2.7% | not timed | not timed | 153.18 ± 3.5% | 8.12 ± 0.6% | not timed | not timed | 554.04 ± 1.0% | | 1.00 | 3.62 | 68.24 |
| reported/i787-keywords/opt-ascii | 5674 | 553.21 ± 1.0% | not timed | not timed | 293.79 ± 0.6% | 12.72 ± 33.3% | not timed | not timed | 553.57 ± 1.9% | | 1.00 | 1.88 | 43.49 |
| slow/quadratic-regex-1x | 100 | 9.20 ± 0.2% | not timed | not timed | 6.78 ± 0.3% | 0.07 ± 1.4% | not timed | not timed | 9.19 ± 0.6% | | 1.00 | 1.36 | 141.08 |
| slow/quadratic-regex-2x | 199 | 4.06 ± 5.4% | not timed | not timed | 3.33 ± 0.2% | 0.02 ± 0.3% | not timed | not timed | 4.06 ± 0.2% | | 1.00 | 1.22 | 241.04 |
| slow/quadratic-haystack-1x | 100 | 29.79 ± 1.4% | not timed | not timed | 13.50 ± 0.2% | 1.30 ± 12.7% | not timed | not timed | 29.86 ± 2.0% | | 1.00 | 2.21 | 22.94 |
| slow/quadratic-haystack-2x | 200 | 22.96 ± 4.8% | not timed | not timed | 6.60 ± 0.2% | 0.71 ± 7.2% | not timed | not timed | 23.00 ± 1.5% | | 1.00 | 3.48 | 32.37 |
| unicode/codepoints/any-one | 1112064 | 391.09 ± 0.8% | not timed | not timed | 310.61 ± 0.4% | 19.17 ± 9.2% | not timed | not timed | 392.33 ± 0.6% | | 1.00 | 1.26 | 20.40 |
| unicode/codepoints/any-all | 4382592 | 292.08 ± 0.7% | not timed | not timed | 290.35 ± 0.4% | 145.38 ± 0.4% | not timed | not timed | 292.41 ± 0.5% | | 1.00 | 1.01 | 2.01 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.12 ± 0.6% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 640.69 ± 0.6% | not timed | not timed | 640.80 ± 0.3% | 181.47 ± 0.5% | not timed | not timed | 641.69 ± 0.6% | | 1.00 | 1.00 | 3.53 |
| unicode/overlapping-words/ascii | 6156 | 33.60 ± 1.2% | not timed | not timed | 53.07 ± 0.3% | 4.97 ± 2.5% | not timed | not timed | 33.22 ± 1.2% | | 1.01 | 0.63 | 6.76 |
| unicode/overlapping-words/english | 6156 | 1.49 ± 0.9% | not timed | not timed | 3.54 ± 0.4% | 2.96 ± 0.3% | not timed | not timed | 1.62 ± 0.9% | | 0.92 | 0.42 | 0.50 |
| unicode/overlapping-words/russian | 5710 | 1.46 ± 7.6% | not timed | not timed | 3.55 ± 0.3% | 7.52 ± 10.6% | not timed | not timed | 1.52 ± 0.5% | | 0.96 | 0.41 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 132.35 ± 1.0% | not timed | not timed | 92.38 ± 0.6% | 13.59 ± 12.7% | not timed | not timed | 132.78 ± 1.7% | | 1.00 | 1.43 | 9.74 |
| unicode/word/boundary-long-english | 3466 | 632.20 ± 0.8% | not timed | not timed | 631.29 ± 0.6% | 38.27 ± 0.6% | not timed | not timed | 633.13 ± 0.2% | | 1.00 | 1.00 | 16.52 |
| unicode/word/around-holmes-english | 27 | 37467.98 ± 0.2% | not timed | not timed | 36027.68 ± 0.3% | 26.32 ± 0.4% | not timed | not timed | 37526.89 ± 0.6% | | 1.00 | 1.04 | 1423.56 |
| wild/bibleref/long | 874 | 604.04 ± 0.3% | not timed | not timed | 611.80 ± 0.3% | 9.51 ± 0.4% | not timed | not timed | 604.17 ± 0.3% | | 1.00 | 0.99 | 63.53 |
| wild/bibleref/short | 30 | 26.19 ± 11.7% | not timed | not timed | 38.14 ± 0.3% | 18.00 ± 4.4% | not timed | not timed | 26.80 ± 8.1% | | 0.98 | 0.69 | 1.46 |
| wild/bibleref/line | 874 | 561.39 ± 6.3% | not timed | not timed | 287.43 ± 0.2% | 10.85 ± 0.5% | not timed | not timed | 562.36 ± 0.3% | | 1.00 | 1.95 | 51.75 |
| wild/caddy/caddy | 6 | 475.54 ± 7.7% | not timed | not timed | 281.60 ± 0.6% | 89.14 ± 8.7% | not timed | not timed | 471.95 ± 2.2% | | 1.01 | 1.69 | 5.33 |
| wild/dot-star-capture/rust-src-tools | 6 | 1521.38 ± 1.0% | not timed | not timed | 351.61 ± 0.4% | 17.99 ± 0.6% | not timed | not timed | 1523.87 ± 0.9% | | 1.00 | 4.33 | 84.56 |
| wild/ruff/noqa | 84 | 618.05 ± 5.0% | not timed | not timed | 567.67 ± 0.7% | 25.80 ± 2.5% | not timed | not timed | 620.04 ± 1.5% | | 1.00 | 1.09 | 23.95 |
| wild/ruff/unnecessary-coding-comment | 16 | 1110.48 ± 2.3% | not timed | not timed | 747.88 ± 2.2% | 164.37 ± 4.5% | not timed | not timed | 1132.58 ± 1.7% | | 0.98 | 1.48 | 6.76 |
| wild/ruff/string-quote-prefix | 2972 | 1603.88 ± 6.8% | not timed | not timed | 532.42 ± 0.5% | 423.21 ± 11.9% | not timed | not timed | 1612.79 ± 1.1% | | 0.99 | 3.01 | 3.79 |
| wild/ruff/space-around-operator | 1224378 | 270.41 ± 2.3% | not timed | not timed | 247.74 ± 2.9% | 22.21 ± 2.1% | not timed | not timed | 270.99 ± 2.5% | | 1.00 | 1.09 | 12.18 |
| wild/ruff/shebang | 282 | 1051.24 ± 12.5% | not timed | not timed | 430.07 ± 5.2% | 144.29 ± 13.7% | not timed | not timed | 1046.48 ± 7.5% | | 1.00 | 2.44 | 7.29 |
| wild/rustsec-cargo-audit/original-unix | 471 | 16459.10 ± 0.2% | not timed | not timed | 18281.28 ± 3.1% | 7763.03 ± 4.1% | not timed | not timed | 16446.42 ± 0.2% | | 1.00 | 0.90 | 2.12 |
| wild/rustsec-cargo-audit/original-windows | 462 | 15532.46 ± 0.5% | not timed | not timed | 17461.15 ± 0.2% | 7280.54 ± 0.5% | not timed | not timed | 15544.65 ± 0.4% | | 1.00 | 0.89 | 2.13 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 16489.58 ± 0.4% | not timed | not timed | 18248.89 ± 0.4% | 7490.63 ± 0.3% | not timed | not timed | 16505.44 ± 0.1% | | 1.00 | 0.90 | 2.20 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 14957.09 ± 3.7% | not timed | not timed | 18048.60 ± 0.2% | 7612.35 ± 15.8% | not timed | not timed | 14917.42 ± 0.3% | | 1.00 | 0.83 | 1.96 |
| wild/url/search | 234965 | 143.43 ± 13.0% | not timed | not timed | 75.41 ± 2.1% | 2.72 ± 0.8% | not timed | not timed | 145.06 ± 12.0% | | 0.99 | 1.90 | 52.72 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 2.5% | not timed | not timed | 0.01 ± 5.5% | 0.01 ± 21.7% | not timed | not timed | 0.03 ± 1.9% | | 0.99 | 3.48 | 4.05 |
| dictionary/compile/english-15 | 1 | 0.38 ± 1.0% | not timed | not timed | 0.09 ± 2.4% | 0.11 ± 4.7% | not timed | not timed | 0.38 ± 30.4% | | 1.00 | 4.29 | 3.27 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.28 ± 17.2% | not timed | not timed | 0.03 ± 2.4% | 38.96 ± 7.1% | not timed | not timed | 0.28 ± 2.9% | | 0.99 | 11.07 | 0.0072 |
| reported/i1095-word-repetition/ascii-compile | 1 | 52.01 ± 6.3% | not timed | not timed | 16.10 ± 0.4% | 67.03 ± 22.2% | not timed | not timed | 52.82 ± 1.0% | | 0.98 | 3.23 | 0.78 |
| reported/i787-keywords/compile | 1 | 45.12 ± 2.0% | not timed | not timed | 2.32 ± 0.7% | 21.01 ± 27.7% | not timed | not timed | 45.25 ± 2.4% | | 1.00 | 19.45 | 2.15 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 442.96 ± 10.1% | not timed | not timed | 161.20 ± 0.3% | 713.53 ± 15.1% | not timed | not timed | 454.61 ± 5.6% | | 0.97 | 2.75 | 0.62 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 61.69 ± 2.4% | not timed | not timed | 5.00 ± 8.0% | 53.49 ± 3.7% | not timed | not timed | 63.08 ± 2.9% | | 0.98 | 12.34 | 1.15 |
| unicode/compile/one-letter | 53 | 7.91 ± 7.0% | not timed | not timed | 6.11 ± 0.1% | 75.03 ± 7.7% | not timed | not timed | 7.97 ± 8.6% | | 0.99 | 1.30 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.19 ± 16.7% | not timed | not timed | 0.13 ± 2.0% | 76.89 ± 19.3% | not timed | not timed | 1.21 ± 4.3% | | 0.98 | 9.09 | 0.0155 |
| unicode/compile/fifty-letters-ascii | 1 | 262.96 ± 11.6% | not timed | not timed | 72.28 ± 0.6% | 254.78 ± 11.2% | not timed | not timed | 267.41 ± 1.6% | | 0.98 | 3.64 | 1.03 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 529.86 ± 5.9% | not timed | not timed | 50.95 ± 0.7% | 864.95 ± 16.6% | not timed | not timed | 530.30 ± 5.3% | | 1.00 | 10.40 | 0.61 |
| unicode/compile/match-every-line-ascii | 4 | 839.66 ± 6.7% | not timed | not timed | 193.34 ± 0.8% | 871.71 ± 24.3% | not timed | not timed | 849.26 ± 4.0% | | 0.99 | 4.34 | 0.96 |
| unicode/compile/negated-class-matches-codepoint | 1 | 424.45 ± 4.0% | not timed | not timed | 55.03 ± 0.2% | 1578.17 ± 9.2% | not timed | not timed | 433.09 ± 3.2% | | 0.98 | 7.71 | 0.27 |
| wild/bibleref/compile | 3 | 6.92 ± 2.9% | not timed | not timed | 2.41 ± 0.2% | 36.31 ± 16.9% | not timed | not timed | 6.99 ± 5.3% | | 0.99 | 2.87 | 0.19 |
| wild/url/compile | 1 | 0.81 ± 0.8% | not timed | not timed | 0.19 ± 1.6% | 0.50 ± 37.1% | not timed | not timed | 0.80 ± 10.9% | | 1.01 | 4.32 | 1.61 |

