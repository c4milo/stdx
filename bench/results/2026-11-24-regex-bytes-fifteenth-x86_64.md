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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391553475 |
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
| literal: a word | 217 | 25955.90 ± 1.7% | 3245.40 ± 1.6% | 25.54 ± 2.5% | 23705.71 ± 3.4% | 8966.49 ± 9.2% | 11.85 ± 1.6% | 82.90 ± 5.2% | 26022.59 ± 7.7% | 8.00 | 1.00 | 1.09 | 2.89 |
| literal: a word that is not there | 0 | 29854.43 ± 1.7% | 3166.79 ± 0.7% | 25.50 ± 2.6% | 25924.48 ± 2.6% | 29372.11 ± 1.6% | 11.46 ± 1.9% | 78.33 ± 2.1% | 29496.24 ± 1.5% | 9.43 | 1.01 | 1.15 | 1.02 |
| literal: one of four words | 661 | 10046.92 ± 3.4% | 1523.92 ± 1.7% | 14.37 ± 1.0% | 7635.52 ± 1.6% | 22.65 ± 1.9% | 3.43 ± 1.0% | 5.94 ± 0.9% | 10000.71 ± 4.0% | 6.59 | 1.00 | 1.32 | 443.56 |
| literal: a word in any case | 217 | 22362.87 ± 0.8% | 1617.32 ± 1.7% | 18.60 ± 3.6% | 7835.61 ± 1.2% | 42.93 ± 1.7% | refused | differs | 22410.92 ± 1.5% | 13.83 | 1.00 | 2.85 | 520.94 |
| literal: an href attribute | 33 | 22102.94 ± 1.9% | 498.28 ± 1.4% | 22.59 ± 1.5% | 21211.50 ± 2.6% | 2010.97 ± 1.1% | 8.28 ± 2.1% | 73.78 ± 1.3% | 22115.38 ± 1.9% | 44.36 | 1.00 | 1.04 | 10.99 |
| literal: a word, second text | 123 | 26252.49 ± 4.1% | 2417.81 ± 2.7% | 25.40 ± 3.6% | 23441.98 ± 2.9% | 7081.77 ± 4.3% | 15.23 ± 2.0% | 70.71 ± 2.2% | 26763.34 ± 2.2% | 10.86 | 0.98 | 1.12 | 3.71 |
| class: two capitalized words | 1331 | 765.71 ± 0.8% | 494.30 ± 1.0% | 24.26 ± 2.1% | 478.49 ± 1.8% | 37.50 ± 12.7% | 10.06 ± 0.7% | 61.39 ± 0.7% | 766.50 ± 1.9% | 1.55 | 1.00 | 1.60 | 20.42 |
| class: a word that ends in ing | 3399 | 470.75 ± 1.2% | 470.43 ± 1.3% | 15.64 ± 1.8% | 448.09 ± 1.3% | 27.04 ± 1.7% | 5.66 ± 1.4% | 16.67 ± 8.0% | 471.57 ± 1.4% | 1.00 | 1.00 | 1.05 | 17.41 |
| class: a word in capitals | 2332 | 1041.65 ± 0.5% | 501.86 ± 1.2% | 25.75 ± 2.0% | 473.63 ± 0.9% | 40.26 ± 9.4% | 12.21 ± 1.3% | 78.38 ± 2.2% | 1041.48 ± 0.7% | 2.08 | 1.00 | 2.20 | 25.87 |
| class: a number | 8288 | 1596.16 ± 1.2% | 676.62 ± 0.9% | 25.08 ± 1.3% | 1641.06 ± 1.1% | 42.76 ± 3.6% | 0.33 ± 0.7% | 56.20 ± 2.3% | 1601.44 ± 2.0% | 2.36 | 1.00 | 0.97 | 37.33 |
| class: two capitalized words, second text | 5359 | 415.16 ± 1.7% | 419.93 ± 2.2% | 21.88 ± 1.1% | 394.04 ± 1.6% | 31.62 ± 8.2% | 13.08 ± 1.5% | 55.28 ± 1.4% | 414.19 ± 1.3% | 0.99 | 1.00 | 1.05 | 13.13 |
| other: a word between two words | 6104 | 680.92 ± 1.0% | 478.35 ± 2.7% | 21.38 ± 3.0% | 667.51 ± 1.6% | 102.82 ± 15.8% | 7.58 ± 0.7% | 63.95 ± 1.7% | 677.65 ± 2.2% | 1.42 | 1.00 | 1.02 | 6.62 |
| other: a number before a unit, second text | 1481 | 6924.78 ± 3.9% | 896.63 ± 2.0% | 24.33 ± 2.2% | 7016.88 ± 1.2% | 38.05 ± 3.4% | 13.72 ± 2.0% | 58.60 ± 2.2% | 6942.04 ± 4.5% | 7.72 | 1.00 | 0.99 | 181.98 |
| other: a heading's start tag | 110 | 16186.41 ± 6.9% | 613.55 ± 1.1% | 24.48 ± 2.0% | 2063.55 ± 1.4% | 1485.80 ± 5.9% | 10.42 ± 1.3% | 86.95 ± 2.9% | 16241.06 ± 1.2% | 26.38 | 1.00 | 7.84 | 10.89 |
| other: a whole word | 217 | 19461.60 ± 9.6% | 501.02 ± 1.9% | 26.08 ± 1.2% | 19377.28 ± 2.6% | 44.81 ± 1.3% | 10.01 ± 5.6% | 47.85 ± 11.0% | 19322.53 ± 1.2% | 38.84 | 1.01 | 1.00 | 434.35 |
| other: a line's first word, second text | 3716 | 1974.69 ± 2.0% | 483.64 ± 1.0% | 27.47 ± 1.3% | 1930.04 ± 1.9% | 63.19 ± 2.5% | refused | refused | 1969.83 ± 0.9% | 4.08 | 1.00 | 1.02 | 31.25 |
| other: fourteen octets before an x | 87 | 27764.79 ± 3.8% | 244.52 ± 3.4% | 5.85 ± 1.4% | 3299.18 ± 1.5% | 8.96 ± 2.0% | differs | 15.34 ± 3.3% | 27609.56 ± 2.6% | 113.55 | 1.01 | 8.42 | 3098.36 |
| other: a Greek word | 21815 | 414.37 ± 0.5% | 323.83 ± 1.2% | 28.87 ± 1.3% | 242.76 ± 1.9% | 43.49 ± 10.1% | differs | refused | 416.23 ± 1.2% | 1.28 | 1.00 | 1.71 | 9.53 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 17.89 ± 0.8% | 17.98 ± 1.4% | 0.84 ± 0.7% | 16.68 ± 0.6% | 2.48 ± 0.7% | differs | 3.66 ± 2.1% | 17.98 ± 0.9% | 0.99 | 0.99 | 1.07 | 7.21 |
| a UUID | 32895 | 20.27 ± 0.5% | 20.33 ± 0.4% | 0.57 ± 2.5% | 12.85 ± 0.8% | 2.46 ± 1.5% | 0.56 ± 1.1% | 3.13 ± 1.0% | 20.41 ± 2.8% | 1.00 | 0.99 | 1.58 | 8.25 |
| an IPv4 address | 33176 | 29.71 ± 1.8% | 29.62 ± 0.5% | 1.84 ± 0.3% | 24.50 ± 1.3% | 5.93 ± 0.6% | differs | 3.47 ± 1.3% | 29.61 ± 1.5% | 1.00 | 1.00 | 1.21 | 5.01 |
| a date and time | 32954 | 29.43 ± 1.7% | 29.36 ± 1.3% | 1.33 ± 4.7% | 18.65 ± 3.5% | 7.70 ± 5.2% | 1.04 ± 4.7% | 6.74 ± 4.9% | 29.49 ± 3.5% | 1.00 | 1.00 | 1.58 | 3.82 |
| a field path | 32606 | 20.18 ± 1.3% | 20.23 ± 0.8% | 0.97 ± 2.2% | 19.14 ± 1.4% | 2.76 ± 2.2% | differs | 2.35 ± 6.2% | 20.21 ± 0.7% | 1.00 | 1.00 | 1.05 | 7.30 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.83 ± 0.4% | 9.85 ± 0.3% | 9.83 ± 1.5% | 11.73 ± 1.3% | 5.07 ± 1.3% | 0.82 ± 0.5% | none | 9.80 ± 0.7% | 1.00 | 1.00 | 0.84 | 1.94 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.55 ± 1.0% | 223.43 ± 0.5% | 258.66 ± 0.6% | 87.62 ± 4.4% | 197.71 ± 1.9% | 554.96 ± 1.6% | 3199.28 ± 1.2% | 222.28 ± 0.7% | 0.99 | 1.00 | 2.53 | 1.12 |
| a UUID | 62 | 145.66 ± 1.8% | 146.37 ± 1.2% | 162.88 ± 0.7% | 46.46 ± 3.4% | 91.54 ± 24.0% | 194.60 ± 3.3% | 3934.75 ± 2.8% | 145.69 ± 0.7% | 1.00 | 1.00 | 3.14 | 1.59 |
| an IPv4 address | 29 | 433.49 ± 1.3% | 437.71 ± 1.4% | 595.89 ± 1.5% | 74.14 ± 5.8% | 120.65 ± 1.7% | 336.91 ± 1.5% | 6343.23 ± 1.2% | 434.50 ± 0.2% | 0.99 | 1.00 | 5.85 | 3.59 |
| a date and time | 56 | 305.24 ± 1.6% | 306.36 ± 1.8% | 378.64 ± 1.4% | 71.72 ± 1.6% | 126.28 ± 1.7% | 351.01 ± 2.4% | 4187.48 ± 0.8% | 305.49 ± 0.9% | 1.00 | 1.00 | 4.26 | 2.42 |
| a field path | 39 | 220.49 ± 0.6% | 220.83 ± 1.9% | 257.03 ± 2.4% | 78.38 ± 7.2% | 186.27 ± 1.5% | 548.72 ± 3.9% | 4017.69 ± 3.7% | 221.01 ± 1.9% | 1.00 | 1.00 | 2.81 | 1.18 |
| literal: a word | 7 | 619.09 ± 0.9% | 671.58 ± 0.8% | 1128.88 ± 2.6% | 522.38 ± 0.5% | 600.79 ± 27.0% | 1114.91 ± 1.4% | 25300.07 ± 1.8% | 617.62 ± 2.2% | 0.92 | 1.00 | 1.19 | 1.03 |
| literal: a word that is not there | 8 | 598.15 ± 1.9% | 643.17 ± 7.6% | 1047.37 ± 1.5% | 475.61 ± 0.9% | 578.57 ± 2.5% | 1042.87 ± 1.6% | 23971.65 ± 2.3% | 592.82 ± 2.4% | 0.93 | 1.01 | 1.26 | 1.03 |
| literal: one of four words | 26 | 236.18 ± 2.9% | 366.96 ± 5.4% | 477.80 ± 0.6% | 38.52 ± 1.3% | 230.38 ± 1.8% | 396.41 ± 1.6% | 12245.72 ± 1.6% | 237.86 ± 4.1% | 0.64 | 0.99 | 6.13 | 1.03 |
| literal: a word in any case | 11 | 443.55 ± 1.5% | 474.97 ± 0.5% | 664.44 ± 0.5% | 13.13 ± 2.1% | 631.36 ± 1.5% | refused | 19058.03 ± 2.0% | 443.27 ± 2.8% | 0.93 | 1.00 | 33.78 | 0.70 |
| literal: an href attribute | 12 | 333.88 ± 1.4% | 347.04 ± 0.8% | 447.67 ± 14.5% | 38.25 ± 0.8% | 457.86 ± 17.4% | 910.06 ± 1.3% | 17352.93 ± 0.9% | 335.00 ± 1.4% | 0.96 | 1.00 | 8.73 | 0.73 |
| literal: a word, second text | 10 | 544.17 ± 1.7% | 603.27 ± 2.1% | 936.69 ± 1.0% | 453.19 ± 0.6% | 506.48 ± 16.6% | 937.55 ± 0.6% | 22245.04 ± 2.2% | 547.79 ± 1.2% | 0.90 | 0.99 | 1.20 | 1.07 |
| class: two capitalized words | 23 | 471.47 ± 1.0% | 509.91 ± 1.5% | 740.19 ± 3.5% | 103.12 ± 1.3% | 477.69 ± 17.7% | 887.42 ± 4.4% | 5618.58 ± 0.9% | 470.23 ± 2.6% | 0.92 | 1.00 | 4.57 | 0.99 |
| class: a word that ends in ing | 9 | 555.71 ± 2.2% | 646.70 ± 2.8% | 1099.10 ± 6.0% | 133.54 ± 1.7% | 686.85 ± 3.0% | 1358.88 ± 4.5% | 13671.73 ± 0.9% | 566.68 ± 3.1% | 0.86 | 0.98 | 4.16 | 0.81 |
| class: a word in capitals | 16 | 515.59 ± 1.6% | 561.49 ± 2.6% | 903.58 ± 1.8% | 139.13 ± 1.3% | 696.38 ± 2.3% | 1248.96 ± 1.3% | 7471.16 ± 2.4% | 516.45 ± 1.8% | 0.92 | 1.00 | 3.71 | 0.74 |
| class: a number | 6 | 654.76 ± 1.1% | 733.74 ± 1.1% | 1376.41 ± 2.0% | 34.08 ± 10.7% | 1272.41 ± 5.9% | 2319.03 ± 2.9% | 20184.07 ± 0.9% | 653.08 ± 2.0% | 0.89 | 1.00 | 19.21 | 0.51 |
| class: two capitalized words, second text | 23 | 469.38 ± 0.6% | 508.33 ± 1.3% | 734.01 ± 1.3% | 102.71 ± 1.5% | 473.97 ± 15.6% | 849.47 ± 5.3% | 5569.67 ± 0.9% | 468.53 ± 1.2% | 0.92 | 1.00 | 4.57 | 0.99 |
| other: a word between two words | 13 | 532.04 ± 0.5% | 553.42 ± 8.5% | 842.47 ± 4.8% | 136.78 ± 1.6% | 466.33 ± 1.6% | 944.45 ± 1.8% | 12149.52 ± 1.0% | 532.12 ± 8.5% | 0.96 | 1.00 | 3.89 | 1.14 |
| other: a number before a unit, second text | 15 | 399.09 ± 4.9% | 442.44 ± 1.0% | 615.53 ± 1.3% | 32.77 ± 1.9% | 574.76 ± 9.0% | 1007.69 ± 7.8% | 12473.60 ± 2.4% | 398.14 ± 4.0% | 0.90 | 1.00 | 12.18 | 0.69 |
| other: a heading's start tag | 13 | 339.52 ± 4.8% | 361.01 ± 0.7% | 466.08 ± 1.2% | 36.43 ± 1.0% | 572.21 ± 0.9% | 1014.44 ± 1.5% | 14457.02 ± 3.7% | 352.66 ± 0.8% | 0.94 | 0.96 | 9.32 | 0.59 |
| other: a whole word | 11 | 561.62 ± 6.0% | 601.11 ± 7.5% | 919.20 ± 3.4% | 120.54 ± 3.6% | 537.53 ± 6.5% | 989.01 ± 3.9% | 20994.28 ± 1.8% | 558.67 ± 14.1% | 0.93 | 1.01 | 4.66 | 1.04 |
| other: a line's first word, second text | 17 | 547.64 ± 1.3% | 583.50 ± 1.0% | 928.65 ± 1.6% | 133.21 ± 1.2% | 647.32 ± 3.1% | refused | refused | 549.56 ± 1.3% | 0.94 | 1.00 | 4.11 | 0.85 |
| other: fourteen octets before an x | 16 | 103.06 ± 0.6% | 143.84 ± 1.0% | 168.43 ± 0.8% | 14.48 ± 0.9% | 417.96 ± 13.2% | 472.62 ± 1.0% | 11258.85 ± 0.7% | 103.47 ± 0.9% | 0.72 | 1.00 | 7.12 | 0.25 |
| other: a Greek word | 8 | 450.32 ± 1.2% | 612.96 ± 0.9% | 1035.09 ± 0.6% | 47.43 ± 0.8% | 1272.55 ± 2.3% | 2234.17 ± 0.9% | refused | 451.55 ± 1.3% | 0.73 | 1.00 | 9.50 | 0.35 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21850.72 ± 1.7% | not timed | not timed | 20998.33 ± 2.1% | 1956.35 ± 21.8% | not timed | not timed | 21905.07 ± 9.6% | | 1.00 | 1.04 | 11.17 |
| 01-literal/sherlock-casei-en | 522 | 17962.00 ± 3.4% | not timed | not timed | 6657.03 ± 1.3% | 29.87 ± 1.3% | not timed | not timed | 18044.00 ± 8.5% | | 1.00 | 2.70 | 601.40 |
| 01-literal/sherlock-ru | 724 | 21739.93 ± 2.7% | not timed | not timed | 21022.20 ± 1.2% | 1128.36 ± 2.5% | not timed | not timed | 21746.43 ± 1.1% | | 1.00 | 1.03 | 19.27 |
| 01-literal/sherlock-casei-ru | 746 | 9044.58 ± 2.2% | not timed | not timed | 5229.43 ± 4.1% | 32.47 ± 1.0% | not timed | not timed | 8993.51 ± 2.7% | | 1.01 | 1.73 | 278.55 |
| 01-literal/sherlock-zh | 30 | 28106.60 ± 2.5% | not timed | not timed | 25321.60 ± 2.0% | 1247.85 ± 0.7% | not timed | not timed | 28069.09 ± 1.3% | | 1.00 | 1.11 | 22.52 |
| 02-literal-alternate/sherlock-en | 714 | 9541.74 ± 2.5% | not timed | not timed | 7333.65 ± 0.9% | 17.47 ± 1.1% | not timed | not timed | 9602.56 ± 3.4% | | 0.99 | 1.30 | 546.16 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1792.88 ± 1.3% | not timed | not timed | 1895.29 ± 0.6% | 10.24 ± 1.8% | not timed | not timed | 1798.51 ± 1.3% | | 1.00 | 0.95 | 175.06 |
| 02-literal-alternate/sherlock-ru | 899 | 7713.96 ± 3.2% | not timed | not timed | 3989.01 ± 5.0% | 22.62 ± 3.8% | not timed | not timed | 7740.99 ± 2.3% | | 1.00 | 1.93 | 341.06 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1856.53 ± 1.1% | not timed | not timed | 968.55 ± 4.1% | 8.66 ± 0.6% | not timed | not timed | 1837.97 ± 1.8% | | 1.01 | 1.92 | 214.36 |
| 02-literal-alternate/sherlock-zh | 207 | 12940.15 ± 1.7% | not timed | not timed | 8361.52 ± 1.4% | 32.61 ± 0.9% | not timed | not timed | 12993.04 ± 1.6% | | 1.00 | 1.55 | 396.83 |
| 03-date/ascii | 111817 | 99.39 ± 0.3% | not timed | not timed | 86.74 ± 1.1% | 0.20 ± 2.1% | not timed | not timed | 99.33 ± 1.6% | | 1.00 | 1.15 | 508.24 |
| 04-ruff-noqa/real | 84 | 435.62 ± 1.3% | not timed | not timed | 448.52 ± 0.9% | 19.55 ± 1.4% | not timed | not timed | 436.27 ± 0.6% | | 1.00 | 0.97 | 22.28 |
| 04-ruff-noqa/tweaked | 44 | 516.47 ± 5.4% | not timed | not timed | 441.81 ± 1.9% | 312.99 ± 3.2% | not timed | not timed | 515.85 ± 7.9% | | 1.00 | 1.17 | 1.65 |
| 05-lexer-veryl/single | 124800 | 4.34 ± 5.6% | not timed | not timed | 4.32 ± 1.6% | 0.21 ± 5.0% | not timed | not timed | 4.35 ± 5.5% | | 1.00 | 1.00 | 21.16 |
| 06-cloud-flare-redos/original | 107 | 371.72 ± 1.2% | not timed | not timed | 193.02 ± 1.7% | 24.27 ± 0.7% | not timed | not timed | 371.15 ± 1.4% | | 1.00 | 1.93 | 15.31 |
| 06-cloud-flare-redos/simplified-short | 102 | 362.33 ± 1.8% | not timed | not timed | 176.26 ± 2.4% | 25.97 ± 1.5% | not timed | not timed | 360.92 ± 0.6% | | 1.00 | 2.06 | 13.95 |
| 06-cloud-flare-redos/simplified-long | 10000 | 437.46 ± 0.9% | not timed | not timed | 210.80 ± 0.9% | 28.31 ± 6.5% | not timed | not timed | 437.85 ± 0.4% | | 1.00 | 2.08 | 15.45 |
| 07-unicode-character-data/parse-line | 558784 | 221.10 ± 1.5% | not timed | not timed | 164.36 ± 0.8% | 38.56 ± 8.0% | not timed | not timed | 222.16 ± 12.1% | | 1.00 | 1.35 | 5.73 |
| 08-words/all-english | 56691 | 88.68 ± 1.3% | not timed | not timed | 73.35 ± 0.6% | 10.64 ± 12.3% | not timed | not timed | 88.49 ± 1.3% | | 1.00 | 1.21 | 8.34 |
| 08-words/long-english | 839 | 507.24 ± 1.0% | not timed | not timed | 488.84 ± 0.8% | 29.07 ± 1.8% | not timed | not timed | 508.47 ± 0.4% | | 1.00 | 1.04 | 17.45 |
| 09-aws-keys/full | 0 | 443.55 ± 0.1% | not timed | not timed | 453.55 ± 1.0% | 60.30 ± 1.2% | not timed | not timed | 443.51 ± 3.4% | | 1.00 | 0.98 | 7.36 |
| 09-aws-keys/quick | 0 | 947.46 ± 0.5% | not timed | not timed | 733.04 ± 1.5% | 355.79 ± 1.5% | not timed | not timed | 941.54 ± 2.2% | | 1.01 | 1.29 | 2.66 |
| 10-bounded-repeat/letters-en | 1833 | 522.81 ± 3.5% | not timed | not timed | 449.38 ± 2.6% | 18.99 ± 1.6% | not timed | not timed | 524.88 ± 3.6% | | 1.00 | 1.16 | 27.53 |
| 10-bounded-repeat/letters-ru | 3475 | 431.70 ± 2.5% | not timed | not timed | 399.61 ± 1.7% | 20.95 ± 6.7% | not timed | not timed | 431.63 ± 2.4% | | 1.00 | 1.08 | 20.60 |
| 10-bounded-repeat/context | 53 | 76.10 ± 6.0% | not timed | not timed | 59.50 ± 1.2% | 18.71 ± 2.2% | not timed | not timed | 76.41 ± 6.2% | | 1.00 | 1.28 | 4.07 |
| 10-bounded-repeat/capitals | 11 | 526.08 ± 9.4% | not timed | not timed | 506.68 ± 1.3% | 35.07 ± 0.6% | not timed | not timed | 524.67 ± 9.7% | | 1.00 | 1.04 | 15.00 |
| 11-unstructured-to-json/extract | 600 | 41.02 ± 1.2% | not timed | not timed | 63.39 ± 1.0% | 49.41 ± 2.2% | not timed | not timed | 41.01 ± 1.6% | | 1.00 | 0.65 | 0.83 |
| 12-dictionary/single | 1 | 450.36 ± 0.9% | not timed | not timed | 429.99 ± 1.1% | 0.37 ± 1.5% | not timed | not timed | 452.10 ± 1.7% | | 1.00 | 1.05 | 1215.46 |
| 14-quadratic/1x | 100 | 23.14 ± 0.6% | not timed | not timed | 10.69 ± 5.2% | 0.97 ± 4.7% | not timed | not timed | 23.04 ± 1.4% | | 1.00 | 2.16 | 23.76 |
| 14-quadratic/2x | 200 | 17.83 ± 0.5% | not timed | not timed | 5.21 ± 1.2% | 0.50 ± 10.6% | not timed | not timed | 17.78 ± 2.2% | | 1.00 | 3.42 | 35.71 |
| 14-quadratic/10x | 1000 | 5.64 ± 1.3% | not timed | not timed | 1.01 ± 0.9% | 0.11 ± 7.4% | not timed | not timed | 5.66 ± 2.9% | | 1.00 | 5.58 | 49.03 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.19 ± 2.4% | not timed | not timed | 0.34 ± 1.4% | 0.52 ± 3.7% | not timed | not timed | 1.20 ± 3.1% | | 0.99 | 3.54 | 2.30 |
| 04-ruff-noqa/compile-real | 1 | 115.13 ± 1.4% | not timed | not timed | 11.99 ± 1.5% | 132.02 ± 5.0% | not timed | not timed | 116.12 ± 7.0% | | 0.99 | 9.60 | 0.87 |
| 05-lexer-veryl/compile-single | 1 | 14.96 ± 1.3% | not timed | not timed | 2.26 ± 1.3% | 6.10 ± 2.3% | not timed | not timed | 14.95 ± 1.1% | | 1.00 | 6.62 | 2.45 |
| 07-unicode-character-data/compile | 1 | 119.33 ± 0.7% | not timed | not timed | 24.57 ± 1.3% | 33.89 ± 7.6% | not timed | not timed | 119.54 ± 2.6% | | 1.00 | 4.86 | 3.52 |
| 09-aws-keys/compile-full | 1 | 48.66 ± 1.1% | not timed | not timed | 6.82 ± 1.5% | 21.87 ± 2.3% | not timed | not timed | 48.78 ± 2.4% | | 1.00 | 7.14 | 2.22 |
| 09-aws-keys/compile-quick | 1 | 177.56 ± 1.3% | not timed | not timed | 45.73 ± 0.6% | 126.96 ± 2.2% | not timed | not timed | 179.71 ± 0.7% | | 0.99 | 3.88 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 48.17 ± 1.0% | not timed | not timed | 10.71 ± 2.0% | 15.90 ± 1.8% | not timed | not timed | 48.52 ± 2.0% | | 0.99 | 4.50 | 3.03 |
| 10-bounded-repeat/compile-capitals | 1 | 67.68 ± 1.3% | not timed | not timed | 8.06 ± 0.8% | 23.30 ± 0.9% | not timed | not timed | 68.87 ± 0.5% | | 0.98 | 8.39 | 2.90 |
| 11-unstructured-to-json/compile | 1 | 180.15 ± 1.5% | not timed | not timed | 37.84 ± 0.6% | 64.18 ± 2.1% | not timed | not timed | 181.54 ± 0.9% | | 0.99 | 4.76 | 2.81 |
| 12-dictionary/compile-single | 1 | 0.29 ± 2.6% | not timed | not timed | 0.06 ± 34.7% | 0.09 ± 15.0% | not timed | not timed | 0.29 ± 2.2% | | 0.99 | 4.83 | 3.08 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 5.95 ± 2.7% | not timed | not timed | 6.10 ± 7.9% | 0.62 ± 20.6% | not timed | not timed | 6.02 ± 4.0% | | 0.99 | 0.98 | 9.53 |
| dictionary/search/english-10 | 690 | 1.15 ± 1.7% | not timed | not timed | 97.58 ± 1.0% | 0.01 ± 0.4% | not timed | not timed | 1.13 ± 2.0% | | 1.01 | 0.0117 | 188.55 |
| dictionary/search/english-15 | 15 | 448.45 ± 1.2% | not timed | not timed | 426.27 ± 1.8% | 0.35 ± 1.1% | not timed | not timed | 448.83 ± 1.6% | | 1.00 | 1.05 | 1278.60 |
| folly/awyer-inn-busted | 1 | 3462.26 ± 0.9% | not timed | not timed | 105.92 ± 0.8% | 41.02 ± 1.1% | not timed | not timed | 3468.86 ± 2.6% | | 1.00 | 32.69 | 84.41 |
| folly/literal-never-match-rare | 0 | 24707.38 ± 1.2% | not timed | not timed | 22618.03 ± 2.0% | 29022.06 ± 0.6% | not timed | not timed | 24818.83 ± 2.6% | | 1.00 | 1.09 | 0.85 |
| folly/literal-never-match-frequent | 0 | 14534.72 ± 0.8% | not timed | not timed | 22456.77 ± 2.5% | 2056.50 ± 0.4% | not timed | not timed | 14542.98 ± 1.8% | | 1.00 | 0.65 | 7.07 |
| folly/literal-never-match-tricksy | 1 | 3292.40 ± 1.0% | not timed | not timed | 4097.76 ± 3.4% | 1270.37 ± 0.8% | not timed | not timed | 3279.86 ± 2.1% | | 1.00 | 0.80 | 2.59 |
| grep/every-line | 239963 | 1139.11 ± 0.8% | not timed | not timed | 738.07 ± 7.6% | 315.17 ± 29.7% | not timed | not timed | 1139.63 ± 5.5% | | 1.00 | 1.54 | 3.61 |
| grep/long-words-ascii | 5073 | 429.31 ± 1.1% | not timed | not timed | 408.31 ± 1.2% | 40.94 ± 6.5% | not timed | not timed | 430.12 ± 3.3% | | 1.00 | 1.05 | 10.49 |
| imported/leipzig/twain | 811 | 23440.39 ± 6.6% | not timed | not timed | 22228.22 ± 3.3% | 9916.47 ± 6.5% | not timed | not timed | 23579.85 ± 2.9% | | 0.99 | 1.05 | 2.36 |
| imported/leipzig/twain-insensitive | 965 | 10433.48 ± 1.8% | not timed | not timed | 8837.75 ± 1.1% | 39.75 ± 2.0% | not timed | not timed | 10539.08 ± 1.9% | | 0.99 | 1.18 | 262.44 |
| imported/leipzig/shing | 1540 | 518.12 ± 1.1% | not timed | not timed | 13749.32 ± 1.5% | 31.98 ± 0.6% | not timed | not timed | 517.16 ± 0.6% | | 1.00 | 0.0377 | 16.20 |
| imported/leipzig/huck-saw | 262 | 14659.22 ± 5.7% | not timed | not timed | 13727.92 ± 0.4% | 32.32 ± 1.5% | not timed | not timed | 15201.17 ± 5.2% | | 0.96 | 1.07 | 453.52 |
| imported/leipzig/word-ending-nn | 262 | 507.39 ± 0.8% | not timed | not timed | 504.22 ± 0.7% | 22.14 ± 1.7% | not timed | not timed | 505.28 ± 0.7% | | 1.00 | 1.01 | 22.91 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 8905.19 ± 4.2% | not timed | not timed | 3479.47 ± 2.8% | 9.68 ± 1.1% | not timed | not timed | 8967.44 ± 2.9% | | 0.99 | 2.56 | 919.62 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 12857.15 ± 5.3% | not timed | not timed | 12490.96 ± 1.2% | 17.61 ± 2.9% | not timed | not timed | 13260.40 ± 5.9% | | 0.97 | 1.03 | 730.18 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4490.17 ± 2.3% | not timed | not timed | 793.29 ± 0.9% | 10.05 ± 0.8% | not timed | not timed | 4473.99 ± 2.5% | | 1.00 | 5.66 | 446.68 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 502.01 ± 0.8% | not timed | not timed | 500.31 ± 1.0% | 11.15 ± 0.7% | not timed | not timed | 500.74 ± 0.4% | | 1.00 | 1.00 | 45.04 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 502.86 ± 0.8% | not timed | not timed | 499.66 ± 0.8% | 9.33 ± 0.6% | not timed | not timed | 505.28 ± 1.1% | | 1.00 | 1.01 | 53.90 |
| imported/leipzig/tom-river | 2 | 9236.33 ± 3.8% | not timed | not timed | 10281.49 ± 0.5% | 31.71 ± 1.1% | not timed | not timed | 9487.61 ± 5.7% | | 0.97 | 0.90 | 291.30 |
| imported/leipzig/ing | 78424 | 494.54 ± 0.9% | not timed | not timed | 464.23 ± 1.1% | 25.88 ± 4.2% | not timed | not timed | 493.49 ± 1.3% | | 1.00 | 1.07 | 19.11 |
| imported/leipzig/ing-whitespace | 55248 | 619.74 ± 0.8% | not timed | not timed | 1800.23 ± 0.9% | 18.98 ± 3.1% | not timed | not timed | 620.35 ± 2.7% | | 1.00 | 0.34 | 32.66 |
| imported/leipzig/awyer-inn | 209 | 641.25 ± 1.9% | not timed | not timed | 8903.66 ± 1.4% | 21.44 ± 0.6% | not timed | not timed | 639.62 ± 1.7% | | 1.00 | 0.0720 | 29.90 |
| imported/leipzig/quotes-bounded | 8886 | 1629.47 ± 2.4% | not timed | not timed | 2704.81 ± 1.3% | 35.09 ± 1.0% | not timed | not timed | 1643.06 ± 1.8% | | 0.99 | 0.60 | 46.44 |
| imported/leipzig/non-ascii-alternate | 2 | 18001.36 ± 3.6% | not timed | not timed | 14114.30 ± 0.4% | 46.39 ± 3.0% | not timed | not timed | 18372.53 ± 4.3% | | 0.98 | 1.28 | 388.01 |
| imported/leipzig/math-symbols | 69 | 1972.36 ± 2.9% | not timed | not timed | 504.26 ± 1.2% | 33.82 ± 1.3% | not timed | not timed | 1978.12 ± 9.1% | | 1.00 | 3.91 | 58.31 |
| imported/leipzig/bounded-strings-ending-z | 0 | 503.87 ± 0.6% | not timed | not timed | 501.68 ± 0.8% | 23.53 ± 0.4% | not timed | not timed | 503.64 ± 0.8% | | 1.00 | 1.00 | 21.41 |
| imported/lh3lh3-reb/uri | 17549 | 615.59 ± 1.1% | not timed | not timed | 843.05 ± 1.1% | 24.74 ± 3.2% | not timed | not timed | 615.97 ± 0.6% | | 1.00 | 0.73 | 24.89 |
| imported/lh3lh3-reb/email | 15057 | 679.59 ± 3.3% | not timed | not timed | 844.12 ± 1.0% | 28.51 ± 2.4% | not timed | not timed | 684.95 ± 1.4% | | 0.99 | 0.81 | 23.84 |
| imported/lh3lh3-reb/date | 668 | 707.55 ± 1.3% | not timed | not timed | 756.27 ± 0.7% | 44.52 ± 3.7% | not timed | not timed | 705.60 ± 1.2% | | 1.00 | 0.94 | 15.89 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 633.98 ± 0.8% | not timed | not timed | 375.33 ± 0.6% | 14.15 ± 1.4% | not timed | not timed | 634.34 ± 1.6% | | 1.00 | 1.69 | 44.82 |
| imported/mariomka/email | 92 | 582.06 ± 0.8% | not timed | not timed | 24841.95 ± 0.9% | 30.12 ± 1.0% | not timed | not timed | 582.58 ± 0.5% | | 1.00 | 0.0234 | 19.33 |
| imported/mariomka/uri | 5301 | 499.09 ± 1.1% | not timed | not timed | 5833.13 ± 1.2% | 30.66 ± 2.4% | not timed | not timed | 499.22 ± 0.3% | | 1.00 | 0.0856 | 16.28 |
| imported/mariomka/ip | 5 | 1524.02 ± 3.0% | not timed | not timed | 1933.46 ± 0.9% | 20.61 ± 0.4% | not timed | not timed | 1522.41 ± 3.7% | | 1.00 | 0.79 | 73.95 |
| imported/rsc/no-exponential | 0 | 781.74 ± 0.8% | not timed | not timed | 508.31 ± 0.8% | 22.54 ± 2.5% | not timed | not timed | 779.22 ± 0.8% | | 1.00 | 1.54 | 34.69 |
| imported/rsc/literal | 1 | 734.57 ± 9.9% | not timed | not timed | 2161.39 ± 1.0% | 218.05 ± 17.8% | not timed | not timed | 796.79 ± 9.3% | | 0.92 | 0.34 | 3.37 |
| imported/rsc/not-literal | 2 | 736.25 ± 1.5% | not timed | not timed | 1085.61 ± 2.0% | 44.99 ± 3.0% | not timed | not timed | 734.59 ± 8.1% | | 1.00 | 0.68 | 16.36 |
| imported/rsc/match-class | 1 | 1355.48 ± 0.9% | not timed | not timed | 2248.65 ± 1.0% | 52.15 ± 2.3% | not timed | not timed | 1352.34 ± 1.2% | | 1.00 | 0.60 | 25.99 |
| imported/rsc/match-class-in-range | 1 | 1336.95 ± 4.2% | not timed | not timed | 3440.02 ± 0.8% | 55.78 ± 7.7% | not timed | not timed | 1352.89 ± 2.0% | | 0.99 | 0.39 | 23.97 |
| imported/rsc/match-class-unicode | 1 | 478.62 ± 1.3% | not timed | not timed | 465.48 ± 2.1% | 62.32 ± 5.8% | not timed | not timed | 475.50 ± 3.4% | | 1.01 | 1.03 | 7.68 |
| imported/rsc/anchored-literal-short-non-match | 0 | 539.11 ± 1.3% | not timed | not timed | 1196.48 ± 1.8% | 282.69 ± 1.7% | not timed | not timed | 538.68 ± 1.2% | | 1.00 | 0.45 | 1.91 |
| imported/rsc/anchored-literal-long-non-match | 0 | 9005.04 ± 1.8% | not timed | not timed | 17952.24 ± 1.6% | 4238.26 ± 2.4% | not timed | not timed | 9098.20 ± 4.7% | | 0.99 | 0.50 | 2.12 |
| imported/rsc/anchored-literal-short-match | 4 | 435.59 ± 3.1% | not timed | not timed | 790.36 ± 1.3% | 83.11 ± 8.7% | not timed | not timed | 436.17 ± 1.8% | | 1.00 | 0.55 | 5.24 |
| imported/rsc/anchored-literal-long-match | 4 | 2471.39 ± 3.1% | not timed | not timed | 11931.40 ± 0.5% | 1239.90 ± 12.0% | not timed | not timed | 2466.72 ± 1.7% | | 1.00 | 0.21 | 1.99 |
| imported/rsc/one-pass-short | 17 | 378.58 ± 14.2% | not timed | not timed | 367.32 ± 1.0% | 31.18 ± 11.2% | not timed | not timed | 380.01 ± 13.6% | | 1.00 | 1.03 | 12.14 |
| imported/rsc/one-pass-short-not | 17 | 234.41 ± 7.6% | not timed | not timed | 355.83 ± 0.6% | 29.12 ± 10.6% | not timed | not timed | 237.91 ± 7.9% | | 0.99 | 0.66 | 8.05 |
| imported/rsc/one-pass-long-prefix | 26 | 249.90 ± 9.8% | not timed | not timed | 433.07 ± 6.1% | 97.61 ± 13.6% | not timed | not timed | 252.33 ± 8.5% | | 0.99 | 0.58 | 2.56 |
| imported/rsc/one-pass-long-prefix-not | 26 | 402.52 ± 3.2% | not timed | not timed | 431.28 ± 1.0% | 77.28 ± 28.6% | not timed | not timed | 395.74 ± 11.3% | | 1.02 | 0.93 | 5.21 |
| imported/rsc/long-needle1 | 31 | 30066.20 ± 1.4% | not timed | not timed | 26951.99 ± 0.7% | 3.74 ± 7.2% | not timed | not timed | 29985.24 ± 1.7% | | 1.00 | 1.12 | 8038.99 |
| imported/rsc/long-needle2 | 31 | 29585.31 ± 2.6% | not timed | not timed | 169.45 ± 4.0% | 3.78 ± 1.7% | not timed | not timed | 29740.59 ± 1.4% | | 0.99 | 174.60 | 7816.65 |
| imported/rsc/easy0-32 | 26 | 1125.87 ± 4.1% | not timed | not timed | 2030.75 ± 2.8% | 146.11 ± 19.0% | not timed | not timed | 1163.75 ± 0.9% | | 0.97 | 0.55 | 7.71 |
| imported/rsc/easy0-1k | 26 | 19234.68 ± 5.1% | not timed | not timed | 17970.29 ± 1.1% | 2543.81 ± 18.0% | not timed | not timed | 19249.15 ± 1.2% | | 1.00 | 1.07 | 7.56 |
| imported/rsc/easy0-32k | 26 | 38128.44 ± 1.8% | not timed | not timed | 31059.61 ± 0.8% | 20231.02 ± 0.8% | not timed | not timed | 37984.60 ± 1.8% | | 1.00 | 1.23 | 1.88 |
| imported/rsc/easy0-1mb | 26 | 30316.51 ± 3.1% | not timed | not timed | 29250.23 ± 1.6% | 40376.73 ± 1.6% | not timed | not timed | 30223.41 ± 1.3% | | 1.00 | 1.04 | 0.75 |
| imported/rsc/easy1-32 | 19 | 368.85 ± 9.2% | not timed | not timed | 1048.55 ± 3.3% | 145.52 ± 22.8% | not timed | not timed | 366.91 ± 2.3% | | 1.01 | 0.35 | 2.53 |
| imported/rsc/easy1-1k | 19 | 496.07 ± 3.4% | not timed | not timed | 21228.68 ± 1.5% | 2559.68 ± 30.3% | not timed | not timed | 492.23 ± 2.2% | | 1.01 | 0.0234 | 0.19 |
| imported/rsc/easy1-32k | 19 | 504.78 ± 1.3% | not timed | not timed | 675628.04 ± 1.1% | 22587.56 ± 6.8% | not timed | not timed | 503.19 ± 10.8% | | 1.00 | 0.0007 | 0.0223 |
| imported/rsc/easy1-1mb | 19 | 500.88 ± 2.8% | not timed | not timed | 21335136.20 ± 12.1% | 42058.91 ± 7.6% | not timed | not timed | 503.81 ± 2.9% | | 0.99 | 0.0000 | 0.0119 |
| imported/rsc/medium-32 | 27 | 458.90 ± 1.7% | not timed | not timed | 970.57 ± 1.0% | 67.35 ± 14.2% | not timed | not timed | 458.54 ± 2.3% | | 1.00 | 0.47 | 6.81 |
| imported/rsc/medium-1k | 27 | 7055.53 ± 2.1% | not timed | not timed | 17331.77 ± 2.2% | 70.90 ± 8.9% | not timed | not timed | 7063.06 ± 1.2% | | 1.00 | 0.41 | 99.51 |
| imported/rsc/medium-32k | 27 | 34379.98 ± 1.9% | not timed | not timed | 540342.48 ± 3.4% | 50.86 ± 1.0% | not timed | not timed | 34661.34 ± 0.7% | | 0.99 | 0.0636 | 676.03 |
| imported/rsc/medium-1mb | 27 | 30022.61 ± 1.9% | not timed | not timed | 17322551.75 ± 0.8% | 51.63 ± 1.4% | not timed | not timed | 30235.37 ± 1.7% | | 0.99 | 0.0017 | 581.45 |
| imported/rsc/hard-32 | 58 | 255.75 ± 4.4% | not timed | not timed | 391.45 ± 0.6% | 48.88 ± 8.6% | not timed | not timed | 256.11 ± 0.7% | | 1.00 | 0.65 | 5.23 |
| imported/rsc/hard-1k | 27 | 493.82 ± 0.9% | not timed | not timed | 15350.49 ± 0.4% | 40.63 ± 0.3% | not timed | not timed | 493.02 ± 1.5% | | 1.00 | 0.0322 | 12.15 |
| imported/rsc/hard-32k | 27 | 504.07 ± 1.2% | not timed | not timed | 480026.32 ± 0.7% | 28.46 ± 1.1% | not timed | not timed | 504.16 ± 0.7% | | 1.00 | 0.0011 | 17.71 |
| imported/rsc/hard-1mb | 51 | 503.70 ± 0.9% | not timed | not timed | 7987980.39 ± 1.2% | 28.51 ± 4.1% | not timed | not timed | 502.51 ± 0.6% | | 1.00 | 0.0001 | 17.67 |
| imported/rsc/reallyhard0-32 | 58 | 255.69 ± 3.6% | not timed | not timed | 235.09 ± 1.5% | 50.05 ± 10.0% | not timed | not timed | 256.35 ± 1.5% | | 1.00 | 1.09 | 5.11 |
| imported/rsc/reallyhard0-1k | 27 | 493.18 ± 0.4% | not timed | not timed | 492.30 ± 0.5% | 40.39 ± 1.3% | not timed | not timed | 491.59 ± 0.3% | | 1.00 | 1.00 | 12.21 |
| imported/rsc/reallyhard0-32k | 27 | 502.89 ± 3.3% | not timed | not timed | 503.32 ± 0.6% | 28.40 ± 0.8% | not timed | not timed | 501.61 ± 2.8% | | 1.00 | 1.00 | 17.71 |
| imported/rsc/reallyhard0-1mb | 51 | 503.53 ± 0.9% | not timed | not timed | 504.05 ± 1.3% | 28.51 ± 0.9% | not timed | not timed | 499.23 ± 1.2% | | 1.01 | 1.00 | 17.66 |
| imported/rsc/reallyreallyhard0-32 | 47 | 278.98 ± 16.0% | not timed | not timed | 214.62 ± 1.0% | 58.44 ± 1.9% | not timed | not timed | 279.08 ± 5.3% | | 1.00 | 1.30 | 4.77 |
| imported/rsc/reallyreallyhard0-1k | 16 | 729.69 ± 1.5% | not timed | not timed | 8231.60 ± 0.6% | 31.84 ± 1.0% | not timed | not timed | 730.84 ± 1.4% | | 1.00 | 0.0886 | 22.92 |
| imported/rsc/reallyreallyhard0-32k | 16 | 523.02 ± 5.4% | not timed | not timed | 29116.24 ± 0.9% | 23.93 ± 7.4% | not timed | not timed | 524.01 ± 4.8% | | 1.00 | 0.0180 | 21.86 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 504.25 ± 1.3% | not timed | not timed | 29041.29 ± 3.2% | 23.72 ± 3.9% | not timed | not timed | 503.56 ± 0.4% | | 1.00 | 0.0174 | 21.26 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 271.47 ± 4.8% | not timed | not timed | 212.20 ± 2.1% | 58.78 ± 9.0% | not timed | not timed | 271.90 ± 3.2% | | 1.00 | 1.28 | 4.62 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 708.46 ± 2.0% | not timed | not timed | 7840.74 ± 1.1% | 31.95 ± 0.9% | not timed | not timed | 703.63 ± 1.2% | | 1.01 | 0.0904 | 22.17 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 521.75 ± 5.9% | not timed | not timed | 28930.41 ± 7.5% | 23.76 ± 1.0% | not timed | not timed | 523.46 ± 5.3% | | 1.00 | 0.0180 | 21.96 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 501.21 ± 1.4% | not timed | not timed | 26066.97 ± 1.2% | 23.84 ± 0.6% | not timed | not timed | 502.59 ± 1.2% | | 1.00 | 0.0192 | 21.02 |
| imported/sherlock/name-sherlock | 776 | 26051.36 ± 3.4% | not timed | not timed | 24072.30 ± 0.8% | 9814.13 ± 29.3% | not timed | not timed | 26308.33 ± 1.9% | | 0.99 | 1.08 | 2.65 |
| imported/sherlock/name-holmes | 2766 | 17571.36 ± 2.7% | not timed | not timed | 19226.16 ± 1.3% | 3052.08 ± 2.4% | not timed | not timed | 17793.04 ± 2.3% | | 0.99 | 0.91 | 5.76 |
| imported/sherlock/name-sherlock-holmes | 1365 | 26085.19 ± 1.7% | not timed | not timed | 23712.20 ± 2.0% | 7942.50 ± 20.9% | not timed | not timed | 26121.80 ± 2.4% | | 1.00 | 1.10 | 3.28 |
| imported/sherlock/name-sherlock-casei | 816 | 23798.44 ± 1.5% | not timed | not timed | 7983.14 ± 3.3% | 29.13 ± 1.7% | not timed | not timed | 23834.99 ± 1.3% | | 1.00 | 2.98 | 817.04 |
| imported/sherlock/name-holmes-casei | 2802 | 14314.84 ± 4.4% | not timed | not timed | 5566.21 ± 5.6% | 40.18 ± 2.4% | not timed | not timed | 14558.68 ± 2.1% | | 0.98 | 2.57 | 356.25 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 20533.46 ± 1.5% | not timed | not timed | 7807.74 ± 3.5% | 29.40 ± 0.9% | not timed | not timed | 20576.58 ± 1.8% | | 1.00 | 2.63 | 698.50 |
| imported/sherlock/name-whitespace | 1461 | 18045.84 ± 8.9% | not timed | not timed | 18923.49 ± 2.4% | 6704.03 ± 44.6% | not timed | not timed | 18002.91 ± 2.6% | | 1.00 | 0.95 | 2.69 |
| imported/sherlock/name-alt1 | 1142 | 16842.85 ± 2.1% | not timed | not timed | 27209.24 ± 1.7% | 3929.70 ± 19.2% | not timed | not timed | 16734.84 ± 3.5% | | 1.01 | 0.62 | 4.29 |
| imported/sherlock/name-alt2 | 3542 | 11160.20 ± 1.8% | not timed | not timed | 6976.63 ± 1.5% | 32.01 ± 1.1% | not timed | not timed | 11179.46 ± 1.2% | | 1.00 | 1.60 | 348.66 |
| imported/sherlock/name-alt3 | 4507 | 8253.65 ± 3.1% | not timed | not timed | 6272.01 ± 2.3% | 10.23 ± 0.8% | not timed | not timed | 8253.00 ± 3.0% | | 1.00 | 1.32 | 806.92 |
| imported/sherlock/name-alt3-casei | 4593 | 1341.62 ± 5.6% | not timed | not timed | 1121.51 ± 1.2% | 6.20 ± 1.2% | not timed | not timed | 1347.73 ± 2.9% | | 1.00 | 1.20 | 216.53 |
| imported/sherlock/name-alt4 | 3686 | 6870.66 ± 0.7% | not timed | not timed | 6538.97 ± 1.4% | 32.04 ± 1.5% | not timed | not timed | 6869.16 ± 0.8% | | 1.00 | 1.05 | 214.47 |
| imported/sherlock/name-alt4-casei | 4254 | 2943.52 ± 3.8% | not timed | not timed | 3334.17 ± 2.0% | 17.75 ± 1.1% | not timed | not timed | 2947.85 ± 3.3% | | 1.00 | 0.88 | 165.85 |
| imported/sherlock/name-alt5 | 4028 | 9722.05 ± 1.8% | not timed | not timed | 6756.53 ± 0.6% | 22.72 ± 1.5% | not timed | not timed | 9771.67 ± 1.5% | | 0.99 | 1.44 | 427.94 |
| imported/sherlock/name-alt5-casei | 4104 | 4465.43 ± 13.0% | not timed | not timed | 2339.26 ± 1.5% | 12.97 ± 2.5% | not timed | not timed | 4489.71 ± 5.3% | | 0.99 | 1.91 | 344.16 |
| imported/sherlock/no-match-uncommon | 0 | 30218.83 ± 1.3% | not timed | not timed | 25655.99 ± 1.4% | 37863.80 ± 1.4% | not timed | not timed | 30231.51 ± 1.4% | | 1.00 | 1.18 | 0.80 |
| imported/sherlock/no-match-common | 0 | 29849.74 ± 3.3% | not timed | not timed | 25719.75 ± 1.7% | 1587.29 ± 1.4% | not timed | not timed | 29846.40 ± 2.5% | | 1.00 | 1.16 | 18.81 |
| imported/sherlock/no-match-really-common | 0 | 24420.17 ± 8.7% | not timed | not timed | 24930.69 ± 4.8% | 1579.84 ± 1.0% | not timed | not timed | 24590.79 ± 1.6% | | 0.99 | 0.98 | 15.46 |
| imported/sherlock/the-lower | 21654 | 2236.37 ± 3.8% | not timed | not timed | 1910.66 ± 1.4% | 226.26 ± 14.9% | not timed | not timed | 2253.96 ± 3.0% | | 0.99 | 1.17 | 9.88 |
| imported/sherlock/the-upper | 2223 | 13525.97 ± 2.5% | not timed | not timed | 16909.19 ± 4.8% | 2557.43 ± 2.5% | not timed | not timed | 13598.56 ± 1.6% | | 0.99 | 0.80 | 5.29 |
| imported/sherlock/the-casei | 23961 | 2027.19 ± 6.0% | not timed | not timed | 1143.73 ± 4.0% | 36.25 ± 11.2% | not timed | not timed | 2029.27 ± 6.3% | | 1.00 | 1.77 | 55.93 |
| imported/sherlock/everything-greedy | 581881 | 239.09 ± 3.2% | not timed | not timed | 147.57 ± 2.5% | 25.15 ± 27.6% | not timed | not timed | 241.08 ± 0.5% | | 0.99 | 1.62 | 9.51 |
| imported/sherlock/everything-greedy-nl | 594933 | 383.94 ± 0.6% | not timed | not timed | 188.76 ± 7.4% | 27.31 ± 2.0% | not timed | not timed | 382.95 ± 1.2% | | 1.00 | 2.03 | 14.06 |
| imported/sherlock/letters | 447175 | 47.01 ± 0.4% | not timed | not timed | 33.27 ± 4.8% | 5.47 ± 22.1% | not timed | not timed | 46.63 ± 1.4% | | 1.01 | 1.41 | 8.59 |
| imported/sherlock/letters-upper | 14180 | 358.75 ± 3.3% | not timed | not timed | 314.87 ± 1.4% | 25.56 ± 23.6% | not timed | not timed | 357.94 ± 1.1% | | 1.00 | 1.14 | 14.04 |
| imported/sherlock/letters-lower | 432995 | 48.19 ± 11.8% | not timed | not timed | 34.63 ± 3.1% | 6.42 ± 42.8% | not timed | not timed | 48.11 ± 1.1% | | 1.00 | 1.39 | 7.51 |
| imported/sherlock/words | 447639 | 87.13 ± 2.4% | not timed | not timed | 74.45 ± 0.6% | 13.13 ± 18.0% | not timed | not timed | 87.49 ± 0.5% | | 1.00 | 1.17 | 6.63 |
| imported/sherlock/before-holmes | 4073 | 502.66 ± 0.6% | not timed | not timed | 11723.45 ± 3.0% | 22.21 ± 0.5% | not timed | not timed | 503.70 ± 0.4% | | 1.00 | 0.0429 | 22.64 |
| imported/sherlock/before-after-holmes | 2593 | 505.54 ± 0.4% | not timed | not timed | 12778.69 ± 2.0% | 22.28 ± 4.1% | not timed | not timed | 505.54 ± 0.6% | | 1.00 | 0.0396 | 22.69 |
| imported/sherlock/holmes-cochar-watson | 150 | 7605.54 ± 5.2% | not timed | not timed | 5788.18 ± 0.9% | 32.71 ± 0.9% | not timed | not timed | 7640.79 ± 1.7% | | 1.00 | 1.31 | 232.48 |
| imported/sherlock/holmes-coword-watson | 14309 | 1046.58 ± 1.6% | not timed | not timed | 1039.17 ± 0.4% | 6.49 ± 1.1% | not timed | not timed | 1048.23 ± 0.6% | | 1.00 | 1.01 | 161.15 |
| imported/sherlock/quotes | 14437 | 1114.54 ± 0.3% | not timed | not timed | 1629.42 ± 4.0% | 32.47 ± 0.9% | not timed | not timed | 1116.51 ± 0.9% | | 1.00 | 0.68 | 34.33 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 507.33 ± 0.5% | not timed | not timed | 21279.42 ± 1.4% | 38.17 ± 0.5% | not timed | not timed | 506.45 ± 0.3% | | 1.00 | 0.0238 | 13.29 |
| imported/sherlock/word-ending-n | 35297 | 380.08 ± 0.5% | not timed | not timed | 344.35 ± 1.1% | 21.24 ± 21.5% | not timed | not timed | 378.53 ± 0.8% | | 1.00 | 1.10 | 17.90 |
| imported/sherlock/repeated-class-negation | 2130 | 14324.24 ± 4.7% | not timed | not timed | 14556.99 ± 3.3% | 9.90 ± 7.1% | not timed | not timed | 14067.86 ± 7.0% | | 1.02 | 0.98 | 1446.37 |
| imported/sherlock/ing-suffix | 20547 | 464.11 ± 0.4% | not timed | not timed | 433.77 ± 0.9% | 26.62 ± 0.7% | not timed | not timed | 463.83 ± 1.5% | | 1.00 | 1.07 | 17.43 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 498.91 ± 0.4% | not timed | not timed | 2072.78 ± 3.9% | 19.09 ± 0.6% | not timed | not timed | 497.66 ± 1.0% | | 1.00 | 0.24 | 26.14 |
| opt/accelerate/whole-line | 239963 | 437.22 ± 0.7% | not timed | not timed | 348.50 ± 1.1% | 89.16 ± 16.4% | not timed | not timed | 436.37 ± 1.0% | | 1.00 | 1.25 | 4.90 |
| opt/accelerate/non-dna | 16745 | 374.28 ± 0.6% | not timed | not timed | 399.99 ± 0.3% | 28.89 ± 20.8% | not timed | not timed | 374.13 ± 0.8% | | 1.00 | 0.94 | 12.96 |
| opt/backtrack/words-english | 40536 | 122.08 ± 0.8% | not timed | not timed | 98.93 ± 0.8% | 18.94 ± 8.6% | not timed | not timed | 122.38 ± 2.1% | | 1.00 | 1.23 | 6.44 |
| opt/fixed-length/too-small-ascii | 0 | 320.92 ± 0.6% | not timed | not timed | 765.41 ± 7.1% | 107.05 ± 1.4% | not timed | not timed | 320.35 ± 7.2% | | 1.00 | 0.42 | 3.00 |
| opt/fixed-length/too-big-ascii | 0 | 772.41 ± 8.5% | not timed | not timed | 6388.97 ± 2.7% | 132.94 ± 8.9% | not timed | not timed | 773.74 ± 0.4% | | 1.00 | 0.12 | 5.81 |
| opt/fixed-length/go33484-1 | 0 | 60.32 ± 1.0% | not timed | not timed | 1238338.20 ± 2.9% | 70430.85 ± 0.3% | not timed | not timed | 60.26 ± 1.5% | | 1.00 | 0.0000 | 0.0009 |
| opt/fixed-length/go33484-2 | 0 | 3464.49 ± 1.1% | not timed | not timed | 1230917.13 ± 3.8% | 37351.42 ± 1.1% | not timed | not timed | 3466.40 ± 0.3% | | 1.00 | 0.0028 | 0.0928 |
| opt/fixed-length/go33484-3 | 0 | 1471.78 ± 0.4% | not timed | not timed | 125041.29 ± 4.5% | 876.87 ± 10.4% | not timed | not timed | 1419.35 ± 2.5% | | 1.04 | 0.0118 | 1.68 |
| opt/literal-alt/one-pattern | 1 | 518.03 ± 1.2% | not timed | not timed | 521.89 ± 0.9% | 0.37 ± 0.5% | not timed | not timed | 518.38 ± 0.8% | | 1.00 | 0.99 | 1396.81 |
| opt/onepass/fn-predicate | 916 | 377.25 ± 1.0% | not timed | not timed | 349.38 ± 1.4% | 185.93 ± 39.4% | not timed | not timed | 378.91 ± 1.1% | | 1.00 | 1.08 | 2.03 |
| opt/onepass/first-three-words-english | 35128 | 130.05 ± 2.8% | not timed | not timed | 194.84 ± 15.6% | 70.51 ± 15.7% | not timed | not timed | 132.62 ± 1.1% | | 0.98 | 0.67 | 1.84 |
| opt/prefilter/literal-english | 1 | 30092.05 ± 0.6% | not timed | not timed | 26910.48 ± 1.8% | 19060.26 ± 0.6% | not timed | not timed | 30114.64 ± 0.4% | | 1.00 | 1.12 | 1.58 |
| opt/prefilter/literal-casei-english | 1 | 23899.04 ± 0.5% | not timed | not timed | 9375.57 ± 1.6% | 30.35 ± 2.3% | not timed | not timed | 23816.42 ± 2.3% | | 1.00 | 2.55 | 787.36 |
| opt/prefilter/literal-russian | 1 | 31230.64 ± 0.7% | not timed | not timed | 27077.83 ± 1.5% | 1518.83 ± 0.8% | not timed | not timed | 31258.60 ± 0.7% | | 1.00 | 1.15 | 20.56 |
| opt/prefilter/literal-casei-russian | 1 | 17754.20 ± 1.0% | not timed | not timed | 7462.13 ± 1.0% | 32.96 ± 0.5% | not timed | not timed | 17829.65 ± 0.6% | | 1.00 | 2.38 | 538.58 |
| opt/prefilter/rust-functions | 948 | 10528.79 ± 1.6% | not timed | not timed | 9029.05 ± 1.4% | 1659.42 ± 1.4% | not timed | not timed | 10556.23 ± 1.5% | | 1.00 | 1.17 | 6.34 |
| opt/reverse-anchored/word-end | 1 | 3510.27 ± 0.3% | not timed | not timed | 30136500.29 ± 0.7% | 48.65 ± 2.2% | not timed | not timed | 3513.19 ± 1.1% | | 1.00 | 0.0001 | 72.15 |
| opt/reverse-inner/holmes | 2593 | 504.42 ± 0.7% | not timed | not timed | 12609.83 ± 2.2% | 22.22 ± 6.0% | not timed | not timed | 504.02 ± 0.5% | | 1.00 | 0.0400 | 22.70 |
| opt/reverse-inner/email | 47 | 863.44 ± 1.4% | not timed | not timed | 29755.09 ± 0.7% | 30.40 ± 1.7% | not timed | not timed | 866.39 ± 1.0% | | 1.00 | 0.0290 | 28.40 |
| opt/reverse-inner/factored-prefix | 3542 | 497.92 ± 3.2% | not timed | not timed | 495.71 ± 4.0% | 11.62 ± 4.2% | not timed | not timed | 496.51 ± 2.6% | | 1.00 | 1.00 | 42.87 |
| opt/reverse-inner/no-quadratic-backward | 0 | 3471.26 ± 0.5% | not timed | not timed | 508.59 ± 0.4% | 68.34 ± 2.3% | not timed | not timed | 3467.50 ± 0.8% | | 1.00 | 6.83 | 50.79 |
| opt/reverse-inner/no-quadratic-forward | 0 | 592.20 ± 4.7% | not timed | not timed | 234.38 ± 0.4% | 26.04 ± 1.0% | not timed | not timed | 593.50 ± 4.9% | | 1.00 | 2.53 | 22.74 |
| opt/reverse-suffix/holmes | 4073 | 503.85 ± 0.6% | not timed | not timed | 11737.78 ± 1.0% | 22.20 ± 0.9% | not timed | not timed | 502.79 ± 0.5% | | 1.00 | 0.0429 | 22.70 |
| opt/reverse-suffix/no-quadratic | 0 | 3459.06 ± 0.7% | not timed | not timed | 508.64 ± 1.5% | 66.43 ± 2.0% | not timed | not timed | 3473.24 ± 0.4% | | 1.00 | 6.80 | 52.07 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 113.99 ± 9.9% | not timed | not timed | 163.99 ± 8.8% | 13.65 ± 17.5% | not timed | not timed | 113.93 ± 2.5% | | 1.00 | 0.70 | 8.35 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 114.12 ± 1.1% | not timed | not timed | 164.67 ± 2.3% | 13.85 ± 17.0% | not timed | not timed | 110.95 ± 6.5% | | 1.03 | 0.69 | 8.24 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.29 ± 1.9% | not timed | not timed | 0.48 ± 0.6% | 106.82 ± 0.9% | not timed | not timed | 0.30 ± 1.2% | | 0.97 | 0.61 | 0.0027 |
| reported/i1095-word-repetition/ascii-search | 256 | 267.64 ± 0.8% | not timed | not timed | 254.69 ± 1.2% | 94.60 ± 7.5% | not timed | not timed | 266.28 ± 3.0% | | 1.01 | 1.05 | 2.83 |
| reported/i13-subset-regex/original-ascii | 4094 | 9059.83 ± 5.9% | not timed | not timed | 3520.72 ± 9.2% | 9.57 ± 0.7% | not timed | not timed | 9239.57 ± 12.0% | | 0.98 | 2.57 | 946.38 |
| reported/i13-subset-regex/original-unicode | 4094 | 9003.98 ± 6.1% | not timed | not timed | 197.72 ± 2.6% | 9.57 ± 0.4% | not timed | not timed | 9030.85 ± 8.8% | | 1.00 | 45.54 | 940.42 |
| reported/i13-subset-regex/big-ascii | 1955 | 8508.98 ± 2.0% | not timed | not timed | 52.62 ± 3.0% | 8.35 ± 0.2% | not timed | not timed | 8425.70 ± 4.9% | | 1.01 | 161.70 | 1019.23 |
| reported/i13-subset-regex/big-unicode | 1955 | 8376.60 ± 1.9% | not timed | not timed | 9.31 ± 56.5% | 8.22 ± 1.8% | not timed | not timed | 8308.58 ± 3.9% | | 1.01 | 900.16 | 1018.57 |
| reported/i13-subset-regex/huge-ascii | 55 | 7639.62 ± 3.1% | not timed | not timed | 8.72 ± 1.3% | 7.74 ± 2.3% | not timed | not timed | 7727.44 ± 3.4% | | 0.99 | 876.09 | 986.69 |
| reported/i13-subset-regex/huge-unicode | 55 | 7726.10 ± 3.2% | not timed | not timed | 8.82 ± 1.0% | 7.83 ± 1.5% | not timed | not timed | 7706.56 ± 6.5% | | 1.00 | 875.74 | 986.94 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.47 ± 2.0% | not timed | not timed | 8.69 ± 2.5% | 7.73 ± 1.6% | not timed | not timed | 3.48 ± 2.5% | | 1.00 | 0.40 | 0.45 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.70 ± 0.4% | not timed | not timed | 8.65 ± 0.5% | 7.72 ± 1.6% | not timed | not timed | 4.70 ± 0.3% | | 1.00 | 0.54 | 0.61 |
| reported/i787-keywords/ascii | 5674 | 398.11 ± 1.7% | not timed | not timed | 113.56 ± 0.4% | 6.32 ± 0.9% | not timed | not timed | 399.87 ± 2.1% | | 1.00 | 3.51 | 63.03 |
| reported/i787-keywords/opt-ascii | 5674 | 399.27 ± 1.8% | not timed | not timed | 237.20 ± 1.0% | 10.24 ± 9.4% | not timed | not timed | 397.94 ± 1.9% | | 1.00 | 1.68 | 38.97 |
| slow/quadratic-regex-1x | 100 | 7.27 ± 3.7% | not timed | not timed | 5.38 ± 0.9% | 0.05 ± 1.7% | not timed | not timed | 7.27 ± 5.5% | | 1.00 | 1.35 | 148.46 |
| slow/quadratic-regex-2x | 199 | 3.14 ± 3.3% | not timed | not timed | 2.62 ± 4.0% | 0.01 ± 5.1% | not timed | not timed | 3.16 ± 0.6% | | 0.99 | 1.20 | 246.73 |
| slow/quadratic-haystack-1x | 100 | 22.42 ± 3.8% | not timed | not timed | 10.60 ± 5.6% | 0.94 ± 16.2% | not timed | not timed | 22.82 ± 2.0% | | 0.98 | 2.11 | 23.96 |
| slow/quadratic-haystack-2x | 200 | 17.57 ± 1.6% | not timed | not timed | 5.16 ± 0.5% | 0.51 ± 7.3% | not timed | not timed | 17.65 ± 0.5% | | 0.99 | 3.40 | 34.77 |
| unicode/codepoints/any-one | 1112064 | 303.44 ± 0.6% | not timed | not timed | 236.88 ± 1.5% | 14.90 ± 21.2% | not timed | not timed | 302.81 ± 0.4% | | 1.00 | 1.28 | 20.37 |
| unicode/codepoints/any-all | 4382592 | 230.07 ± 1.1% | not timed | not timed | 225.49 ± 2.7% | 97.49 ± 2.1% | not timed | not timed | 230.54 ± 0.5% | | 1.00 | 1.02 | 2.36 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.44 ± 1.8% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 496.16 ± 0.9% | not timed | not timed | 497.05 ± 0.8% | 136.05 ± 1.1% | not timed | not timed | 495.59 ± 1.4% | | 1.00 | 1.00 | 3.65 |
| unicode/overlapping-words/ascii | 6156 | 25.67 ± 0.8% | not timed | not timed | 39.21 ± 0.9% | 3.96 ± 1.1% | not timed | not timed | 24.98 ± 0.9% | | 1.03 | 0.65 | 6.47 |
| unicode/overlapping-words/english | 6156 | 1.29 ± 0.7% | not timed | not timed | 1.97 ± 3.1% | 2.28 ± 0.8% | not timed | not timed | 1.23 ± 11.1% | | 1.05 | 0.65 | 0.57 |
| unicode/overlapping-words/russian | 5710 | 1.21 ± 1.5% | not timed | not timed | 1.94 ± 2.0% | 5.88 ± 1.8% | not timed | not timed | 1.13 ± 0.9% | | 1.08 | 0.63 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 87.70 ± 16.2% | not timed | not timed | 72.66 ± 0.7% | 10.15 ± 25.0% | not timed | not timed | 87.96 ± 14.5% | | 1.00 | 1.21 | 8.64 |
| unicode/word/boundary-long-english | 3466 | 499.06 ± 1.9% | not timed | not timed | 490.30 ± 2.0% | 28.76 ± 9.1% | not timed | not timed | 499.72 ± 2.0% | | 1.00 | 1.02 | 17.35 |
| unicode/word/around-holmes-english | 27 | 503.27 ± 1.4% | not timed | not timed | 26261.92 ± 1.8% | 19.79 ± 2.1% | not timed | not timed | 505.46 ± 0.6% | | 1.00 | 0.0192 | 25.43 |
| wild/bibleref/long | 874 | 473.21 ± 0.4% | not timed | not timed | 484.35 ± 0.8% | 7.35 ± 1.9% | not timed | not timed | 473.48 ± 8.5% | | 1.00 | 0.98 | 64.35 |
| wild/bibleref/short | 30 | 19.12 ± 3.8% | not timed | not timed | 27.90 ± 2.3% | 13.94 ± 9.4% | not timed | not timed | 19.73 ± 11.1% | | 0.97 | 0.69 | 1.37 |
| wild/bibleref/line | 874 | 405.07 ± 0.7% | not timed | not timed | 227.53 ± 0.9% | 8.24 ± 0.7% | not timed | not timed | 405.26 ± 0.6% | | 1.00 | 1.78 | 49.17 |
| wild/caddy/caddy | 6 | 412.59 ± 9.6% | not timed | not timed | 233.79 ± 1.4% | 70.10 ± 17.0% | not timed | not timed | 406.33 ± 1.4% | | 1.02 | 1.76 | 5.89 |
| wild/dot-star-capture/rust-src-tools | 6 | 1016.52 ± 3.6% | not timed | not timed | 289.86 ± 1.6% | 13.14 ± 1.1% | not timed | not timed | 1016.67 ± 2.0% | | 1.00 | 3.51 | 77.36 |
| wild/ruff/noqa | 84 | 438.60 ± 1.2% | not timed | not timed | 445.01 ± 0.8% | 19.44 ± 2.4% | not timed | not timed | 437.56 ± 3.1% | | 1.00 | 0.99 | 22.56 |
| wild/ruff/unnecessary-coding-comment | 16 | 481.88 ± 0.5% | not timed | not timed | 577.10 ± 1.1% | 125.19 ± 11.4% | not timed | not timed | 481.48 ± 0.8% | | 1.00 | 0.83 | 3.85 |
| wild/ruff/string-quote-prefix | 2972 | 439.55 ± 1.9% | not timed | not timed | 416.61 ± 1.0% | 270.93 ± 26.1% | not timed | not timed | 440.37 ± 1.5% | | 1.00 | 1.06 | 1.62 |
| wild/ruff/space-around-operator | 1224378 | 201.87 ± 2.8% | not timed | not timed | 193.66 ± 0.5% | 16.65 ± 2.6% | not timed | not timed | 202.70 ± 1.4% | | 1.00 | 1.04 | 12.12 |
| wild/ruff/shebang | 282 | 433.91 ± 1.3% | not timed | not timed | 344.77 ± 0.7% | 112.71 ± 10.7% | not timed | not timed | 433.60 ± 1.1% | | 1.00 | 1.26 | 3.85 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13162.00 ± 1.8% | not timed | not timed | 14780.37 ± 1.9% | 6189.14 ± 0.9% | not timed | not timed | 13218.67 ± 1.9% | | 1.00 | 0.89 | 2.13 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12427.00 ± 1.8% | not timed | not timed | 14198.97 ± 6.3% | 5817.80 ± 11.3% | not timed | not timed | 12419.60 ± 1.0% | | 1.00 | 0.88 | 2.14 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13061.63 ± 11.9% | not timed | not timed | 14436.70 ± 2.2% | 6031.91 ± 5.8% | not timed | not timed | 13301.50 ± 6.7% | | 0.98 | 0.90 | 2.17 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 11559.28 ± 2.7% | not timed | not timed | 14626.49 ± 1.4% | 6177.17 ± 33.2% | not timed | not timed | 11549.04 ± 2.6% | | 1.00 | 0.79 | 1.87 |
| wild/url/search | 234965 | 113.75 ± 12.3% | not timed | not timed | 57.61 ± 1.7% | 2.08 ± 0.5% | not timed | not timed | 113.05 ± 13.3% | | 1.01 | 1.97 | 54.66 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.02 ± 50.9% | not timed | not timed | 0.01 ± 0.5% | 0.01 ± 22.5% | not timed | not timed | 0.02 ± 68.0% | | 1.00 | 3.35 | 4.09 |
| dictionary/compile/english-15 | 1 | 0.29 ± 12.3% | not timed | not timed | 0.07 ± 1.3% | 0.10 ± 15.7% | not timed | not timed | 0.29 ± 19.5% | | 1.01 | 4.38 | 3.03 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.21 ± 14.2% | not timed | not timed | 0.02 ± 2.5% | 30.19 ± 6.3% | not timed | not timed | 0.21 ± 3.9% | | 1.00 | 10.96 | 0.0068 |
| reported/i1095-word-repetition/ascii-compile | 1 | 36.79 ± 4.5% | not timed | not timed | 11.94 ± 0.7% | 51.40 ± 46.6% | not timed | not timed | 36.94 ± 3.2% | | 1.00 | 3.08 | 0.72 |
| reported/i787-keywords/compile | 1 | 34.49 ± 18.3% | not timed | not timed | 1.74 ± 1.2% | 15.88 ± 31.2% | not timed | not timed | 35.31 ± 5.9% | | 0.98 | 19.83 | 2.17 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 351.52 ± 26.2% | not timed | not timed | 122.31 ± 7.2% | 532.82 ± 14.8% | not timed | not timed | 361.48 ± 4.8% | | 0.97 | 2.87 | 0.66 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 48.42 ± 2.5% | not timed | not timed | 3.70 ± 0.6% | 39.53 ± 13.4% | not timed | not timed | 49.18 ± 2.1% | | 0.98 | 13.09 | 1.23 |
| unicode/compile/one-letter | 53 | 5.97 ± 25.7% | not timed | not timed | 4.70 ± 0.6% | 51.69 ± 3.2% | not timed | not timed | 5.99 ± 30.6% | | 1.00 | 1.27 | 0.12 |
| unicode/compile/fifty-letters | 1 | 0.91 ± 10.8% | not timed | not timed | 0.10 ± 0.7% | 54.13 ± 14.2% | not timed | not timed | 0.91 ± 5.1% | | 1.00 | 8.73 | 0.0168 |
| unicode/compile/fifty-letters-ascii | 1 | 202.41 ± 27.5% | not timed | not timed | 52.67 ± 2.4% | 191.91 ± 31.9% | not timed | not timed | 202.08 ± 6.0% | | 1.00 | 3.84 | 1.05 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 413.53 ± 4.7% | not timed | not timed | 39.56 ± 1.2% | 620.44 ± 1.3% | not timed | not timed | 415.87 ± 2.3% | | 0.99 | 10.45 | 0.67 |
| unicode/compile/match-every-line-ascii | 4 | 675.96 ± 1.5% | not timed | not timed | 146.03 ± 0.5% | 595.68 ± 6.6% | not timed | not timed | 678.08 ± 2.3% | | 1.00 | 4.63 | 1.13 |
| unicode/compile/negated-class-matches-codepoint | 1 | 346.36 ± 9.2% | not timed | not timed | 42.46 ± 1.1% | 1126.79 ± 2.0% | not timed | not timed | 344.38 ± 2.3% | | 1.01 | 8.16 | 0.31 |
| wild/bibleref/compile | 3 | 5.21 ± 1.2% | not timed | not timed | 1.80 ± 1.4% | 27.44 ± 7.2% | not timed | not timed | 5.22 ± 1.8% | | 1.00 | 2.89 | 0.19 |
| wild/url/compile | 1 | 0.58 ± 16.9% | not timed | not timed | 0.14 ± 1.2% | 0.38 ± 31.5% | not timed | not timed | 0.63 ± 1.0% | | 0.92 | 4.19 | 1.51 |

