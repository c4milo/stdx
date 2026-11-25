# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507021102 |
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
| literal: a word | 217 | 31263.11 ± 0.6% | 3864.47 ± 0.8% | 33.10 ± 2.2% | 28651.08 ± 3.1% | 11266.34 ± 10.2% | 13.97 ± 0.4% | 105.05 ± 2.7% | 31233.75 ± 8.6% | 8.09 | 1.00 | 1.09 | 2.77 |
| literal: a word that is not there | 0 | 35902.05 ± 34.7% | 3765.97 ± 33.8% | 33.26 ± 72.8% | 31472.33 ± 14.8% | 34993.58 ± 1.2% | 13.65 ± 0.1% | 98.86 ± 15.7% | 35904.83 ± 3.9% | 9.53 | 1.00 | 1.14 | 1.03 |
| literal: one of four words | 661 | 13314.27 ± 1.6% | 1786.63 ± 0.9% | 17.26 ± 3.6% | 9102.06 ± 4.5% | 27.13 ± 0.3% | 4.10 ± 0.3% | 8.90 ± 0.5% | 13271.34 ± 4.3% | 7.45 | 1.00 | 1.46 | 490.76 |
| literal: a word in any case | 217 | 27435.08 ± 0.7% | 1884.18 ± 0.2% | 23.30 ± 1.4% | 9317.48 ± 0.1% | 51.42 ± 1.6% | refused | differs | 27147.35 ± 1.8% | 14.56 | 1.01 | 2.94 | 533.55 |
| literal: an href attribute | 33 | 27213.43 ± 0.9% | 598.87 ± 0.6% | 29.05 ± 1.6% | 25822.89 ± 1.3% | 2405.43 ± 1.4% | 10.03 ± 0.1% | 93.06 ± 1.0% | 27248.69 ± 1.2% | 45.44 | 1.00 | 1.05 | 11.31 |
| literal: a word, second text | 123 | 32628.74 ± 0.7% | 2879.64 ± 0.6% | 31.56 ± 0.9% | 28548.46 ± 0.3% | 8286.02 ± 5.2% | 18.06 ± 0.6% | 89.20 ± 0.6% | 32525.67 ± 0.3% | 11.33 | 1.00 | 1.14 | 3.94 |
| class: two capitalized words | 1331 | 938.72 ± 0.4% | 594.05 ± 0.6% | 29.35 ± 0.5% | 568.13 ± 0.3% | 45.27 ± 0.9% | 11.93 ± 0.2% | 73.77 ± 0.2% | 937.25 ± 7.3% | 1.58 | 1.00 | 1.65 | 20.74 |
| class: a word that ends in ing | 3399 | 565.54 ± 0.9% | 565.88 ± 1.2% | 19.37 ± 0.7% | 533.13 ± 10.2% | 32.63 ± 6.4% | 6.65 ± 15.4% | 20.17 ± 11.6% | 565.52 ± 0.5% | 1.00 | 1.00 | 1.06 | 17.33 |
| class: a word in capitals | 2332 | 1266.03 ± 3.9% | 599.44 ± 0.6% | 31.49 ± 1.0% | 558.92 ± 0.3% | 48.92 ± 3.1% | 14.29 ± 0.1% | 94.05 ± 0.5% | 1266.58 ± 0.8% | 2.11 | 1.00 | 2.27 | 25.88 |
| class: a number | 8288 | 2015.57 ± 0.3% | 830.40 ± 0.2% | 31.59 ± 1.8% | 1940.42 ± 3.2% | 48.21 ± 9.7% | 0.39 ± 1.1% | 68.37 ± 0.6% | 2015.98 ± 0.6% | 2.43 | 1.00 | 1.04 | 41.80 |
| class: two capitalized words, second text | 5359 | 498.29 ± 0.4% | 507.69 ± 0.2% | 26.18 ± 4.5% | 470.99 ± 1.2% | 38.91 ± 9.5% | 15.44 ± 8.3% | 67.36 ± 1.9% | 500.59 ± 3.0% | 0.98 | 1.00 | 1.06 | 12.80 |
| other: a word between two words | 6104 | 875.77 ± 3.5% | 585.32 ± 3.5% | 26.18 ± 3.7% | 802.38 ± 3.2% | 124.44 ± 25.3% | 9.07 ± 6.9% | 78.90 ± 4.5% | 878.14 ± 0.4% | 1.50 | 1.00 | 1.09 | 7.04 |
| other: a number before a unit, second text | 1481 | 8845.27 ± 4.4% | 1048.22 ± 0.7% | 28.76 ± 1.7% | 8493.58 ± 0.4% | 45.88 ± 0.9% | 16.19 ± 0.2% | 71.90 ± 0.3% | 8876.24 ± 2.8% | 8.44 | 1.00 | 1.04 | 192.78 |
| other: a heading's start tag | 110 | 19910.22 ± 0.4% | 726.54 ± 2.0% | 30.99 ± 2.1% | 2454.51 ± 2.8% | 1784.12 ± 7.1% | 12.42 ± 0.3% | 107.73 ± 0.6% | 19846.70 ± 1.0% | 27.40 | 1.00 | 8.11 | 11.16 |
| other: a whole word | 217 | 25067.80 ± 2.5% | 591.67 ± 0.3% | 31.73 ± 1.2% | 23102.53 ± 0.7% | 53.33 ± 0.6% | 11.91 ± 0.2% | 62.51 ± 0.3% | 25128.73 ± 0.2% | 42.37 | 1.00 | 1.09 | 470.07 |
| other: a line's first word, second text | 3716 | 2482.14 ± 4.5% | 577.82 ± 2.1% | 32.20 ± 5.9% | 2266.86 ± 4.5% | 75.36 ± 3.9% | refused | refused | 2470.30 ± 5.2% | 4.30 | 1.00 | 1.09 | 32.94 |
| other: fourteen octets before an x | 87 | 33923.27 ± 1.0% | 278.18 ± 1.0% | 7.20 ± 0.2% | 3909.98 ± 0.6% | 10.61 ± 1.1% | differs | 19.52 ± 3.1% | 34220.90 ± 2.2% | 121.95 | 0.99 | 8.68 | 3197.48 |
| other: a Greek word | 21815 | 548.30 ± 1.0% | 431.04 ± 3.0% | 34.28 ± 1.7% | 288.40 ± 1.2% | 58.13 ± 11.3% | differs | refused | 549.37 ± 4.4% | 1.27 | 1.00 | 1.90 | 9.43 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.19 ± 1.3% | 29.22 ± 0.4% | 0.95 ± 2.5% | 19.69 ± 0.1% | 2.92 ± 1.3% | differs | 4.54 ± 1.0% | 29.20 ± 0.4% | 1.00 | 1.00 | 1.48 | 9.98 |
| a UUID | 32895 | 27.32 ± 0.5% | 27.32 ± 0.4% | 0.66 ± 1.0% | 15.23 ± 1.3% | 2.97 ± 0.3% | 0.66 ± 0.3% | 3.80 ± 3.1% | 27.35 ± 0.3% | 1.00 | 1.00 | 1.79 | 9.19 |
| an IPv4 address | 33176 | 35.97 ± 0.2% | 35.98 ± 2.7% | 2.12 ± 0.9% | 29.03 ± 1.0% | 7.02 ± 0.4% | differs | 4.43 ± 1.8% | 36.01 ± 0.7% | 1.00 | 1.00 | 1.24 | 5.13 |
| a date and time | 32954 | 36.97 ± 0.9% | 36.85 ± 0.5% | 1.51 ± 0.6% | 22.11 ± 0.1% | 9.12 ± 0.2% | 1.23 ± 0.2% | 8.59 ± 1.1% | 36.90 ± 0.5% | 1.00 | 1.00 | 1.67 | 4.05 |
| a field path | 32606 | 30.84 ± 0.4% | 30.86 ± 0.4% | 1.10 ± 1.4% | 22.71 ± 0.2% | 3.28 ± 0.6% | differs | 2.91 ± 0.5% | 30.84 ± 0.8% | 1.00 | 1.00 | 1.36 | 9.40 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.52 ± 0.8% | 11.32 ± 0.6% | 11.54 ± 0.8% | 13.88 ± 0.7% | 6.07 ± 1.3% | 0.97 ± 0.5% | none | 11.33 ± 0.4% | 1.02 | 1.02 | 0.83 | 1.90 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 268.74 ± 0.4% | 269.44 ± 0.2% | 316.08 ± 0.9% | 101.20 ± 27.6% | 228.03 ± 10.6% | 656.85 ± 1.3% | 3862.03 ± 0.9% | 268.65 ± 2.7% | 1.00 | 1.00 | 2.66 | 1.18 |
| a UUID | 62 | 179.39 ± 0.4% | 179.19 ± 5.7% | 199.95 ± 0.5% | 54.36 ± 0.9% | 107.28 ± 1.3% | 228.90 ± 2.8% | 4925.35 ± 10.4% | 179.29 ± 0.5% | 1.00 | 1.00 | 3.30 | 1.67 |
| an IPv4 address | 29 | 546.54 ± 0.6% | 547.18 ± 2.7% | 754.76 ± 0.8% | 88.32 ± 2.6% | 141.62 ± 3.6% | 396.77 ± 4.8% | 7910.26 ± 3.0% | 548.31 ± 0.5% | 1.00 | 1.00 | 6.19 | 3.86 |
| a date and time | 56 | 402.15 ± 4.2% | 410.15 ± 0.2% | 516.40 ± 0.3% | 85.71 ± 1.0% | 147.25 ± 10.0% | 418.26 ± 0.5% | 4982.98 ± 4.6% | 408.74 ± 0.8% | 0.98 | 0.98 | 4.69 | 2.73 |
| a field path | 39 | 266.03 ± 0.6% | 266.13 ± 0.6% | 313.04 ± 6.2% | 93.93 ± 4.7% | 222.43 ± 5.4% | 666.43 ± 3.2% | 4860.81 ± 1.4% | 266.20 ± 0.7% | 1.00 | 1.00 | 2.83 | 1.20 |
| literal: a word | 7 | 814.40 ± 0.7% | 872.86 ± 0.4% | 1561.15 ± 0.7% | 622.42 ± 0.6% | 738.70 ± 1.0% | 1355.33 ± 0.4% | 31618.71 ± 0.9% | 814.71 ± 0.5% | 0.93 | 1.00 | 1.31 | 1.10 |
| literal: a word that is not there | 8 | 774.55 ± 1.4% | 840.17 ± 1.3% | 1464.59 ± 1.6% | 586.40 ± 0.9% | 698.91 ± 2.3% | 1280.07 ± 0.5% | 30452.75 ± 2.1% | 775.52 ± 0.7% | 0.92 | 1.00 | 1.32 | 1.11 |
| literal: one of four words | 26 | 304.69 ± 8.7% | 505.11 ± 0.2% | 684.60 ± 0.8% | 45.60 ± 1.0% | 275.49 ± 1.5% | 471.17 ± 3.6% | 16545.25 ± 1.1% | 304.49 ± 3.2% | 0.60 | 1.00 | 6.68 | 1.11 |
| literal: a word in any case | 11 | 563.28 ± 1.6% | 602.94 ± 0.6% | 862.25 ± 0.6% | 15.42 ± 1.3% | 762.10 ± 1.9% | refused | 25250.59 ± 1.3% | 565.62 ± 0.4% | 0.93 | 1.00 | 36.53 | 0.74 |
| literal: an href attribute | 12 | 428.46 ± 0.4% | 443.20 ± 0.2% | 577.75 ± 0.8% | 45.24 ± 0.7% | 554.22 ± 1.5% | 1073.35 ± 0.7% | 22739.16 ± 2.8% | 428.71 ± 0.3% | 0.97 | 1.00 | 9.47 | 0.77 |
| literal: a word, second text | 10 | 713.52 ± 1.3% | 789.30 ± 0.6% | 1301.34 ± 0.7% | 537.77 ± 4.5% | 604.09 ± 15.0% | 1104.92 ± 29.5% | 27894.11 ± 1.5% | 716.35 ± 0.6% | 0.90 | 1.00 | 1.33 | 1.18 |
| class: two capitalized words | 23 | 607.45 ± 0.4% | 646.86 ± 0.3% | 959.95 ± 0.4% | 119.18 ± 1.0% | 561.18 ± 12.5% | 1027.89 ± 0.5% | 6935.22 ± 0.5% | 608.04 ± 0.5% | 0.94 | 1.00 | 5.10 | 1.08 |
| class: a word that ends in ing | 9 | 726.12 ± 1.8% | 823.22 ± 8.0% | 1428.58 ± 5.7% | 159.55 ± 4.9% | 829.46 ± 7.2% | 1592.40 ± 2.5% | 17156.18 ± 2.3% | 727.59 ± 5.8% | 0.88 | 1.00 | 4.55 | 0.88 |
| class: a word in capitals | 16 | 666.23 ± 3.0% | 707.90 ± 0.3% | 1176.58 ± 0.6% | 161.77 ± 2.4% | 828.71 ± 2.7% | 1474.63 ± 2.4% | 9227.08 ± 0.8% | 664.63 ± 1.9% | 0.94 | 1.00 | 4.12 | 0.80 |
| class: a number | 6 | 819.18 ± 0.5% | 890.06 ± 0.5% | 1669.94 ± 2.6% | 40.26 ± 1.5% | 1516.17 ± 1.2% | 2742.65 ± 7.1% | 24293.08 ± 1.5% | 818.06 ± 1.9% | 0.92 | 1.00 | 20.35 | 0.54 |
| class: two capitalized words, second text | 23 | 605.43 ± 0.5% | 646.45 ± 0.6% | 959.77 ± 1.0% | 119.95 ± 1.6% | 566.13 ± 1.2% | 1023.96 ± 1.5% | 6959.01 ± 1.1% | 607.28 ± 0.7% | 0.94 | 1.00 | 5.05 | 1.07 |
| other: a word between two words | 13 | 704.53 ± 0.6% | 731.22 ± 0.5% | 1163.39 ± 0.4% | 161.20 ± 0.7% | 560.86 ± 1.0% | 1109.65 ± 1.4% | 15715.50 ± 1.2% | 703.98 ± 0.9% | 0.96 | 1.00 | 4.37 | 1.26 |
| other: a number before a unit, second text | 15 | 506.31 ± 0.4% | 554.94 ± 3.0% | 776.93 ± 0.3% | 38.32 ± 2.3% | 698.97 ± 1.4% | 1244.67 ± 2.1% | 15712.87 ± 0.8% | 504.11 ± 2.7% | 0.91 | 1.00 | 13.21 | 0.72 |
| other: a heading's start tag | 13 | 441.28 ± 0.4% | 452.98 ± 0.3% | 592.13 ± 0.6% | 43.84 ± 0.1% | 683.31 ± 1.2% | 1195.83 ± 6.0% | 18938.05 ± 1.8% | 442.14 ± 0.8% | 0.97 | 1.00 | 10.07 | 0.65 |
| other: a whole word | 11 | 728.05 ± 2.9% | 777.83 ± 1.2% | 1274.87 ± 6.0% | 143.26 ± 1.3% | 635.55 ± 1.4% | 1169.29 ± 1.4% | 27295.61 ± 1.8% | 729.39 ± 3.8% | 0.94 | 1.00 | 5.08 | 1.15 |
| other: a line's first word, second text | 17 | 693.43 ± 0.4% | 728.74 ± 0.2% | 1184.11 ± 1.0% | 157.61 ± 0.5% | 777.72 ± 40.3% | refused | refused | 694.23 ± 2.0% | 0.95 | 1.00 | 4.40 | 0.89 |
| other: fourteen octets before an x | 16 | 120.72 ± 2.0% | 169.87 ± 0.3% | 198.90 ± 0.4% | 17.10 ± 0.3% | 493.93 ± 1.8% | 553.09 ± 2.9% | 14050.58 ± 1.2% | 120.75 ± 0.7% | 0.71 | 1.00 | 7.06 | 0.24 |
| other: a Greek word | 8 | 552.82 ± 0.4% | 774.62 ± 0.4% | 1306.29 ± 0.9% | 56.60 ± 0.5% | 1518.10 ± 1.5% | 2628.82 ± 1.1% | refused | 554.89 ± 0.2% | 0.71 | 1.00 | 9.77 | 0.36 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 25766.08 ± 0.4% | not timed | not timed | 24968.26 ± 0.8% | 2272.98 ± 6.3% | not timed | not timed | 25800.67 ± 0.9% | | 1.00 | 1.03 | 11.34 |
| 01-literal/sherlock-casei-en | 522 | 21314.56 ± 2.0% | not timed | not timed | 7817.31 ± 0.2% | 34.88 ± 2.1% | not timed | not timed | 21497.45 ± 1.1% | | 0.99 | 2.73 | 611.16 |
| 01-literal/sherlock-ru | 724 | 25628.45 ± 0.8% | not timed | not timed | 24925.71 ± 0.5% | 1326.07 ± 14.2% | not timed | not timed | 25701.34 ± 0.6% | | 1.00 | 1.03 | 19.33 |
| 01-literal/sherlock-casei-ru | 746 | 10692.56 ± 0.2% | not timed | not timed | 6143.11 ± 0.4% | 38.10 ± 3.0% | not timed | not timed | 10669.73 ± 1.0% | | 1.00 | 1.74 | 280.67 |
| 01-literal/sherlock-zh | 30 | 33704.57 ± 0.4% | not timed | not timed | 30279.14 ± 0.5% | 1476.12 ± 0.3% | not timed | not timed | 33717.13 ± 0.4% | | 1.00 | 1.11 | 22.83 |
| 02-literal-alternate/sherlock-en | 714 | 12543.44 ± 1.4% | not timed | not timed | 8680.59 ± 1.0% | 20.76 ± 1.2% | not timed | not timed | 12585.50 ± 1.1% | | 1.00 | 1.44 | 604.13 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2104.48 ± 1.9% | not timed | not timed | 2230.82 ± 0.4% | 12.14 ± 1.1% | not timed | not timed | 2117.33 ± 1.9% | | 0.99 | 0.94 | 173.35 |
| 02-literal-alternate/sherlock-ru | 899 | 9213.61 ± 0.4% | not timed | not timed | 4730.25 ± 2.7% | 26.78 ± 28.0% | not timed | not timed | 9138.04 ± 22.1% | | 1.01 | 1.95 | 344.03 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2193.01 ± 0.6% | not timed | not timed | 1147.67 ± 5.9% | 10.34 ± 4.0% | not timed | not timed | 2196.45 ± 13.7% | | 1.00 | 1.91 | 212.06 |
| 02-literal-alternate/sherlock-zh | 207 | 16226.39 ± 0.3% | not timed | not timed | 9919.77 ± 1.8% | 38.52 ± 4.0% | not timed | not timed | 16230.89 ± 1.9% | | 1.00 | 1.64 | 421.21 |
| 03-date/ascii | 111817 | 131.06 ± 0.9% | not timed | not timed | 102.41 ± 1.7% | 0.23 ± 1.5% | not timed | not timed | 131.31 ± 1.0% | | 1.00 | 1.28 | 564.60 |
| 04-ruff-noqa/real | 84 | 567.36 ± 6.9% | not timed | not timed | 506.87 ± 0.4% | 18.34 ± 0.6% | not timed | not timed | 567.61 ± 0.2% | | 1.00 | 1.12 | 30.94 |
| 04-ruff-noqa/tweaked | 44 | 606.87 ± 1.2% | not timed | not timed | 521.22 ± 4.6% | 379.97 ± 1.5% | not timed | not timed | 607.23 ± 3.3% | | 1.00 | 1.16 | 1.60 |
| 05-lexer-veryl/single | 124800 | 4.97 ± 0.6% | not timed | not timed | 5.58 ± 0.9% | 0.24 ± 4.5% | not timed | not timed | 4.95 ± 1.5% | | 1.01 | 0.89 | 20.64 |
| 06-cloud-flare-redos/original | 107 | 456.13 ± 0.4% | not timed | not timed | 229.78 ± 2.2% | 28.99 ± 1.0% | not timed | not timed | 456.48 ± 1.7% | | 1.00 | 1.99 | 15.74 |
| 06-cloud-flare-redos/simplified-short | 102 | 444.56 ± 0.7% | not timed | not timed | 205.88 ± 1.6% | 30.55 ± 0.5% | not timed | not timed | 444.84 ± 0.4% | | 1.00 | 2.16 | 14.55 |
| 06-cloud-flare-redos/simplified-long | 10000 | 517.51 ± 0.1% | not timed | not timed | 248.22 ± 2.4% | 33.43 ± 1.5% | not timed | not timed | 517.87 ± 0.3% | | 1.00 | 2.08 | 15.48 |
| 07-unicode-character-data/parse-line | 558784 | 265.43 ± 0.6% | not timed | not timed | 196.23 ± 1.3% | 46.93 ± 7.5% | not timed | not timed | 266.50 ± 2.1% | | 1.00 | 1.35 | 5.66 |
| 08-words/all-english | 56691 | 123.65 ± 0.9% | not timed | not timed | 86.51 ± 0.9% | 12.67 ± 4.9% | not timed | not timed | 124.05 ± 0.9% | | 1.00 | 1.43 | 9.76 |
| 08-words/long-english | 839 | 602.28 ± 0.2% | not timed | not timed | 576.75 ± 0.4% | 34.28 ± 7.7% | not timed | not timed | 602.35 ± 0.6% | | 1.00 | 1.04 | 17.57 |
| 09-aws-keys/full | 0 | 590.45 ± 0.6% | not timed | not timed | 536.03 ± 1.8% | 75.65 ± 2.7% | not timed | not timed | 590.33 ± 0.6% | | 1.00 | 1.10 | 7.81 |
| 09-aws-keys/quick | 0 | 1143.98 ± 0.3% | not timed | not timed | 871.99 ± 0.3% | 497.51 ± 16.3% | not timed | not timed | 1144.95 ± 1.2% | | 1.00 | 1.31 | 2.30 |
| 10-bounded-repeat/letters-en | 1833 | 618.68 ± 2.9% | not timed | not timed | 528.76 ± 2.0% | 22.26 ± 0.5% | not timed | not timed | 617.70 ± 2.1% | | 1.00 | 1.17 | 27.80 |
| 10-bounded-repeat/letters-ru | 3475 | 507.07 ± 1.3% | not timed | not timed | 455.13 ± 0.9% | 24.35 ± 20.0% | not timed | not timed | 508.81 ± 3.2% | | 1.00 | 1.11 | 20.82 |
| 10-bounded-repeat/context | 53 | 88.54 ± 1.9% | not timed | not timed | 69.81 ± 20.6% | 22.23 ± 1.4% | not timed | not timed | 88.19 ± 2.2% | | 1.00 | 1.27 | 3.98 |
| 10-bounded-repeat/capitals | 11 | 621.40 ± 8.0% | not timed | not timed | 594.22 ± 0.4% | 41.25 ± 0.5% | not timed | not timed | 620.47 ± 13.8% | | 1.00 | 1.05 | 15.06 |
| 11-unstructured-to-json/extract | 600 | 50.33 ± 2.2% | not timed | not timed | 74.35 ± 0.7% | 58.44 ± 1.3% | not timed | not timed | 50.29 ± 8.9% | | 1.00 | 0.68 | 0.86 |
| 12-dictionary/single | 1 | 530.97 ± 1.6% | not timed | not timed | 507.85 ± 0.9% | 0.45 ± 1.8% | not timed | not timed | 530.24 ± 3.4% | | 1.00 | 1.05 | 1190.00 |
| 14-quadratic/1x | 100 | 27.40 ± 1.2% | not timed | not timed | 12.69 ± 2.2% | 1.17 ± 2.0% | not timed | not timed | 27.40 ± 1.6% | | 1.00 | 2.16 | 23.48 |
| 14-quadratic/2x | 200 | 21.11 ± 1.2% | not timed | not timed | 6.18 ± 0.9% | 0.64 ± 0.9% | not timed | not timed | 21.16 ± 1.8% | | 1.00 | 3.41 | 32.84 |
| 14-quadratic/10x | 1000 | 6.61 ± 1.8% | not timed | not timed | 1.20 ± 0.9% | 0.14 ± 1.2% | not timed | not timed | 6.61 ± 0.2% | | 1.00 | 5.53 | 47.80 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.44 ± 0.5% | not timed | not timed | 0.40 ± 0.6% | 0.62 ± 5.1% | not timed | not timed | 1.44 ± 1.5% | | 1.00 | 3.64 | 2.32 |
| 04-ruff-noqa/compile-real | 1 | 143.92 ± 0.9% | not timed | not timed | 13.98 ± 0.6% | 158.48 ± 3.4% | not timed | not timed | 144.18 ± 2.4% | | 1.00 | 10.30 | 0.91 |
| 05-lexer-veryl/compile-single | 1 | 17.57 ± 1.0% | not timed | not timed | 2.68 ± 0.6% | 7.09 ± 3.8% | not timed | not timed | 17.60 ± 0.7% | | 1.00 | 6.56 | 2.48 |
| 07-unicode-character-data/compile | 1 | 145.35 ± 1.1% | not timed | not timed | 28.65 ± 1.9% | 40.44 ± 1.5% | not timed | not timed | 145.43 ± 0.4% | | 1.00 | 5.07 | 3.59 |
| 09-aws-keys/compile-full | 1 | 59.04 ± 0.9% | not timed | not timed | 8.05 ± 2.6% | 25.75 ± 1.1% | not timed | not timed | 58.97 ± 1.2% | | 1.00 | 7.34 | 2.29 |
| 09-aws-keys/compile-quick | 1 | 214.09 ± 1.0% | not timed | not timed | 54.53 ± 0.8% | 151.58 ± 1.8% | not timed | not timed | 213.40 ± 0.7% | | 1.00 | 3.93 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 61.14 ± 1.0% | not timed | not timed | 12.80 ± 1.8% | 18.96 ± 1.9% | not timed | not timed | 61.21 ± 1.5% | | 1.00 | 4.78 | 3.22 |
| 10-bounded-repeat/compile-capitals | 1 | 84.44 ± 4.8% | not timed | not timed | 9.59 ± 6.0% | 27.36 ± 0.8% | not timed | not timed | 85.01 ± 5.6% | | 0.99 | 8.80 | 3.09 |
| 11-unstructured-to-json/compile | 1 | 219.37 ± 1.2% | not timed | not timed | 45.92 ± 3.4% | 75.83 ± 2.2% | not timed | not timed | 219.03 ± 1.2% | | 1.00 | 4.78 | 2.89 |
| 12-dictionary/compile-single | 1 | 0.34 ± 2.6% | not timed | not timed | 0.07 ± 0.3% | 0.12 ± 19.4% | not timed | not timed | 0.34 ± 2.3% | | 1.00 | 4.56 | 2.93 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.30 ± 0.5% | not timed | not timed | 7.22 ± 1.1% | 0.71 ± 7.5% | not timed | not timed | 7.31 ± 1.1% | | 1.00 | 1.01 | 10.27 |
| dictionary/search/english-10 | 690 | 1.34 ± 1.0% | not timed | not timed | 113.76 ± 1.8% | 0.01 ± 0.6% | not timed | not timed | 1.35 ± 0.9% | | 0.99 | 0.0117 | 204.31 |
| dictionary/search/english-15 | 15 | 529.72 ± 1.0% | not timed | not timed | 508.29 ± 0.7% | 0.41 ± 5.8% | not timed | not timed | 525.99 ± 1.3% | | 1.01 | 1.04 | 1295.70 |
| folly/awyer-inn-busted | 1 | 4097.52 ± 3.3% | not timed | not timed | 125.38 ± 0.8% | 48.56 ± 1.0% | not timed | not timed | 4092.50 ± 0.8% | | 1.00 | 32.68 | 84.39 |
| folly/literal-never-match-rare | 0 | 27693.58 ± 5.8% | not timed | not timed | 25493.85 ± 2.7% | 31677.73 ± 0.5% | not timed | not timed | 27675.27 ± 1.2% | | 1.00 | 1.09 | 0.87 |
| folly/literal-never-match-frequent | 0 | 16529.73 ± 2.1% | not timed | not timed | 25496.06 ± 0.8% | 2437.38 ± 0.4% | not timed | not timed | 16544.60 ± 2.7% | | 1.00 | 0.65 | 6.78 |
| folly/literal-never-match-tricksy | 1 | 3898.48 ± 0.4% | not timed | not timed | 4841.31 ± 2.4% | 1510.11 ± 0.2% | not timed | not timed | 3882.53 ± 1.2% | | 1.00 | 0.81 | 2.58 |
| grep/every-line | 239963 | 1388.71 ± 1.0% | not timed | not timed | 868.67 ± 1.7% | 367.72 ± 25.7% | not timed | not timed | 1391.76 ± 2.7% | | 1.00 | 1.60 | 3.78 |
| grep/long-words-ascii | 5073 | 509.69 ± 0.3% | not timed | not timed | 481.93 ± 0.4% | 47.79 ± 6.7% | not timed | not timed | 509.53 ± 0.3% | | 1.00 | 1.06 | 10.67 |
| imported/leipzig/twain | 811 | 26258.59 ± 4.6% | not timed | not timed | 24775.00 ± 0.4% | 11700.97 ± 10.9% | not timed | not timed | 26240.16 ± 0.2% | | 1.00 | 1.06 | 2.24 |
| imported/leipzig/twain-insensitive | 965 | 12125.09 ± 0.6% | not timed | not timed | 10457.76 ± 0.3% | 46.53 ± 1.9% | not timed | not timed | 12165.78 ± 0.4% | | 1.00 | 1.16 | 260.60 |
| imported/leipzig/shing | 1540 | 19449.84 ± 0.8% | not timed | not timed | 16002.16 ± 0.5% | 37.70 ± 0.2% | not timed | not timed | 19453.28 ± 1.2% | | 1.00 | 1.22 | 515.89 |
| imported/leipzig/huck-saw | 262 | 17885.85 ± 2.3% | not timed | not timed | 15880.70 ± 0.4% | 39.03 ± 0.9% | not timed | not timed | 17907.58 ± 4.7% | | 1.00 | 1.13 | 458.26 |
| imported/leipzig/word-ending-nn | 262 | 593.06 ± 0.2% | not timed | not timed | 594.79 ± 0.4% | 26.65 ± 0.8% | not timed | not timed | 591.98 ± 0.5% | | 1.00 | 1.00 | 22.25 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 10448.42 ± 1.5% | not timed | not timed | 4067.24 ± 0.6% | 11.48 ± 0.2% | not timed | not timed | 10479.87 ± 0.8% | | 1.00 | 2.57 | 910.25 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 15976.79 ± 4.5% | not timed | not timed | 14603.37 ± 7.0% | 21.04 ± 0.8% | not timed | not timed | 15976.90 ± 7.5% | | 1.00 | 1.09 | 759.26 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5360.62 ± 0.5% | not timed | not timed | 942.26 ± 3.1% | 11.86 ± 0.3% | not timed | not timed | 5358.76 ± 0.5% | | 1.00 | 5.69 | 451.89 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 591.98 ± 0.2% | not timed | not timed | 592.13 ± 0.4% | 13.22 ± 1.8% | not timed | not timed | 591.37 ± 1.0% | | 1.00 | 1.00 | 44.79 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 592.05 ± 0.2% | not timed | not timed | 592.50 ± 0.4% | 10.98 ± 1.0% | not timed | not timed | 591.89 ± 0.2% | | 1.00 | 1.00 | 53.90 |
| imported/leipzig/tom-river | 2 | 11112.35 ± 0.2% | not timed | not timed | 11904.39 ± 2.6% | 37.68 ± 2.0% | not timed | not timed | 11088.24 ± 2.6% | | 1.00 | 0.93 | 294.90 |
| imported/leipzig/ing | 78424 | 580.41 ± 1.1% | not timed | not timed | 551.36 ± 0.7% | 30.71 ± 4.1% | not timed | not timed | 582.31 ± 0.0% | | 1.00 | 1.05 | 18.90 |
| imported/leipzig/ing-whitespace | 55248 | 730.28 ± 1.6% | not timed | not timed | 2117.41 ± 1.3% | 22.49 ± 2.6% | not timed | not timed | 731.09 ± 0.5% | | 1.00 | 0.34 | 32.46 |
| imported/leipzig/awyer-inn | 209 | 752.49 ± 1.1% | not timed | not timed | 10638.21 ± 0.5% | 25.21 ± 0.8% | not timed | not timed | 752.49 ± 1.3% | | 1.00 | 0.0707 | 29.85 |
| imported/leipzig/quotes-bounded | 8886 | 1940.41 ± 0.2% | not timed | not timed | 3189.12 ± 0.6% | 41.40 ± 1.4% | not timed | not timed | 1939.62 ± 0.2% | | 1.00 | 0.61 | 46.87 |
| imported/leipzig/non-ascii-alternate | 2 | 21822.37 ± 0.3% | not timed | not timed | 16284.78 ± 1.1% | 54.10 ± 1.0% | not timed | not timed | 21643.18 ± 3.2% | | 1.01 | 1.34 | 403.36 |
| imported/leipzig/math-symbols | 69 | 2366.81 ± 0.4% | not timed | not timed | 594.55 ± 0.2% | 40.05 ± 1.2% | not timed | not timed | 2366.36 ± 8.1% | | 1.00 | 3.98 | 59.09 |
| imported/leipzig/bounded-strings-ending-z | 0 | 594.10 ± 0.1% | not timed | not timed | 594.94 ± 0.5% | 27.65 ± 0.8% | not timed | not timed | 594.63 ± 0.2% | | 1.00 | 1.00 | 21.49 |
| imported/lh3lh3-reb/uri | 17549 | 817.50 ± 0.2% | not timed | not timed | 992.38 ± 1.0% | 29.91 ± 3.0% | not timed | not timed | 816.98 ± 1.9% | | 1.00 | 0.82 | 27.34 |
| imported/lh3lh3-reb/email | 15057 | 812.20 ± 0.5% | not timed | not timed | 988.63 ± 1.2% | 33.51 ± 0.8% | not timed | not timed | 812.50 ± 0.4% | | 1.00 | 0.82 | 24.24 |
| imported/lh3lh3-reb/date | 668 | 853.09 ± 0.4% | not timed | not timed | 888.74 ± 0.7% | 53.26 ± 1.4% | not timed | not timed | 855.90 ± 0.3% | | 1.00 | 0.96 | 16.02 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 754.61 ± 0.4% | not timed | not timed | 440.40 ± 0.1% | 16.72 ± 1.2% | not timed | not timed | 753.97 ± 0.4% | | 1.00 | 1.71 | 45.14 |
| imported/mariomka/email | 92 | 24380.06 ± 0.9% | not timed | not timed | 27396.46 ± 5.4% | 35.32 ± 6.9% | not timed | not timed | 24259.15 ± 4.7% | | 1.00 | 0.89 | 690.22 |
| imported/mariomka/uri | 5301 | 6230.50 ± 4.2% | not timed | not timed | 6829.56 ± 0.4% | 36.11 ± 0.7% | not timed | not timed | 6231.70 ± 3.2% | | 1.00 | 0.91 | 172.52 |
| imported/mariomka/ip | 5 | 1795.39 ± 3.8% | not timed | not timed | 2264.08 ± 2.7% | 24.23 ± 0.8% | not timed | not timed | 1800.09 ± 4.0% | | 1.00 | 0.79 | 74.09 |
| imported/rsc/no-exponential | 0 | 944.95 ± 1.0% | not timed | not timed | 603.39 ± 0.4% | 26.70 ± 0.5% | not timed | not timed | 942.90 ± 1.8% | | 1.00 | 1.57 | 35.39 |
| imported/rsc/literal | 1 | 881.74 ± 3.4% | not timed | not timed | 2556.82 ± 0.3% | 226.42 ± 19.4% | not timed | not timed | 887.28 ± 5.0% | | 0.99 | 0.34 | 3.89 |
| imported/rsc/not-literal | 2 | 899.95 ± 1.7% | not timed | not timed | 1278.96 ± 0.7% | 53.41 ± 9.3% | not timed | not timed | 903.37 ± 4.6% | | 1.00 | 0.70 | 16.85 |
| imported/rsc/match-class | 1 | 1699.14 ± 1.9% | not timed | not timed | 2556.23 ± 0.2% | 62.28 ± 7.6% | not timed | not timed | 1693.55 ± 2.0% | | 1.00 | 0.66 | 27.28 |
| imported/rsc/match-class-in-range | 1 | 1686.22 ± 5.8% | not timed | not timed | 4061.36 ± 0.8% | 66.90 ± 5.2% | not timed | not timed | 1695.88 ± 1.0% | | 0.99 | 0.42 | 25.21 |
| imported/rsc/match-class-unicode | 1 | 573.79 ± 0.2% | not timed | not timed | 551.08 ± 0.4% | 74.61 ± 1.1% | not timed | not timed | 574.12 ± 0.2% | | 1.00 | 1.04 | 7.69 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1489.10 ± 0.8% | not timed | not timed | 1326.01 ± 3.3% | 335.69 ± 2.0% | not timed | not timed | 1483.69 ± 1.5% | | 1.00 | 1.12 | 4.44 |
| imported/rsc/anchored-literal-long-non-match | 0 | 22341.30 ± 1.8% | not timed | not timed | 19667.67 ± 1.4% | 5064.17 ± 1.8% | not timed | not timed | 22333.57 ± 0.9% | | 1.00 | 1.14 | 4.41 |
| imported/rsc/anchored-literal-short-match | 4 | 707.19 ± 0.9% | not timed | not timed | 934.95 ± 1.0% | 96.47 ± 17.1% | not timed | not timed | 707.29 ± 2.3% | | 1.00 | 0.76 | 7.33 |
| imported/rsc/anchored-literal-long-match | 4 | 10843.78 ± 4.3% | not timed | not timed | 14052.15 ± 1.1% | 1435.09 ± 2.0% | not timed | not timed | 10906.99 ± 5.3% | | 0.99 | 0.77 | 7.56 |
| imported/rsc/one-pass-short | 17 | 479.19 ± 6.1% | not timed | not timed | 433.08 ± 0.7% | 36.05 ± 13.2% | not timed | not timed | 473.98 ± 3.4% | | 1.01 | 1.11 | 13.29 |
| imported/rsc/one-pass-short-not | 17 | 419.07 ± 1.6% | not timed | not timed | 417.61 ± 0.5% | 33.18 ± 12.6% | not timed | not timed | 423.25 ± 0.6% | | 0.99 | 1.00 | 12.63 |
| imported/rsc/one-pass-long-prefix | 26 | 562.28 ± 13.4% | not timed | not timed | 506.66 ± 0.4% | 106.98 ± 40.0% | not timed | not timed | 562.96 ± 6.4% | | 1.00 | 1.11 | 5.26 |
| imported/rsc/one-pass-long-prefix-not | 26 | 569.20 ± 7.7% | not timed | not timed | 498.51 ± 2.4% | 82.78 ± 12.0% | not timed | not timed | 570.06 ± 1.3% | | 1.00 | 1.14 | 6.88 |
| imported/rsc/long-needle1 | 31 | 35756.53 ± 0.1% | not timed | not timed | 31955.66 ± 6.7% | 4.60 ± 1.5% | not timed | not timed | 35762.35 ± 2.2% | | 1.00 | 1.12 | 7769.83 |
| imported/rsc/long-needle2 | 31 | 35487.78 ± 0.1% | not timed | not timed | 201.91 ± 1.7% | 4.60 ± 2.7% | not timed | not timed | 35470.44 ± 1.2% | | 1.00 | 175.76 | 7712.88 |
| imported/rsc/easy0-32 | 26 | 1298.21 ± 2.3% | not timed | not timed | 2387.15 ± 1.4% | 175.15 ± 8.1% | not timed | not timed | 1312.77 ± 2.0% | | 0.99 | 0.54 | 7.41 |
| imported/rsc/easy0-1k | 26 | 22720.47 ± 4.6% | not timed | not timed | 21032.43 ± 1.6% | 2481.35 ± 19.1% | not timed | not timed | 22723.23 ± 1.7% | | 1.00 | 1.08 | 9.16 |
| imported/rsc/easy0-32k | 26 | 45557.03 ± 2.1% | not timed | not timed | 36682.51 ± 0.2% | 23907.80 ± 25.1% | not timed | not timed | 45559.93 ± 0.3% | | 1.00 | 1.24 | 1.91 |
| imported/rsc/easy0-1mb | 26 | 36173.70 ± 0.2% | not timed | not timed | 35595.82 ± 2.7% | 48327.88 ± 0.8% | not timed | not timed | 36217.28 ± 5.1% | | 1.00 | 1.02 | 0.75 |
| imported/rsc/easy1-32 | 19 | 1214.21 ± 14.3% | not timed | not timed | 1237.15 ± 2.1% | 162.19 ± 12.8% | not timed | not timed | 1224.66 ± 1.4% | | 0.99 | 0.98 | 7.49 |
| imported/rsc/easy1-1k | 19 | 24880.63 ± 1.9% | not timed | not timed | 25232.53 ± 0.4% | 2840.68 ± 21.3% | not timed | not timed | 24964.05 ± 2.1% | | 1.00 | 0.99 | 8.76 |
| imported/rsc/easy1-32k | 19 | 784265.63 ± 0.6% | not timed | not timed | 795411.48 ± 0.5% | 26630.83 ± 19.5% | not timed | not timed | 785895.68 ± 1.4% | | 1.00 | 0.99 | 29.45 |
| imported/rsc/easy1-1mb | 19 | 25075598.15 ± 0.2% | not timed | not timed | 25284942.89 ± 0.5% | 50959.70 ± 6.6% | not timed | not timed | 25156581.89 ± 14.8% | | 1.00 | 0.99 | 492.07 |
| imported/rsc/medium-32 | 27 | 1121.35 ± 2.3% | not timed | not timed | 1146.87 ± 13.9% | 80.33 ± 13.8% | not timed | not timed | 1125.47 ± 0.1% | | 1.00 | 0.98 | 13.96 |
| imported/rsc/medium-1k | 27 | 19972.29 ± 9.5% | not timed | not timed | 20556.81 ± 0.5% | 84.05 ± 1.1% | not timed | not timed | 20008.62 ± 1.3% | | 1.00 | 0.97 | 237.63 |
| imported/rsc/medium-32k | 27 | 624377.20 ± 0.4% | not timed | not timed | 642141.36 ± 0.2% | 60.19 ± 0.8% | not timed | not timed | 624356.88 ± 0.4% | | 1.00 | 0.97 | 10373.81 |
| imported/rsc/medium-1mb | 27 | 19934851.52 ± 0.3% | not timed | not timed | 20521190.90 ± 0.3% | 61.04 ± 0.7% | not timed | not timed | 19953298.61 ± 1.9% | | 1.00 | 0.97 | 326564.16 |
| imported/rsc/hard-32 | 58 | 512.65 ± 1.1% | not timed | not timed | 461.69 ± 0.2% | 58.42 ± 9.9% | not timed | not timed | 512.08 ± 2.5% | | 1.00 | 1.11 | 8.78 |
| imported/rsc/hard-1k | 27 | 19289.01 ± 0.2% | not timed | not timed | 18119.73 ± 0.2% | 47.96 ± 0.1% | not timed | not timed | 19289.49 ± 1.4% | | 1.00 | 1.06 | 402.21 |
| imported/rsc/hard-32k | 27 | 602395.06 ± 0.2% | not timed | not timed | 560679.14 ± 0.2% | 33.80 ± 1.4% | not timed | not timed | 602434.99 ± 0.5% | | 1.00 | 1.07 | 17819.94 |
| imported/rsc/hard-1mb | 51 | 10350703.16 ± 0.9% | not timed | not timed | 8465042.21 ± 0.3% | 34.04 ± 0.8% | not timed | not timed | 10361474.48 ± 0.4% | | 1.00 | 1.22 | 304080.21 |
| imported/rsc/reallyhard0-32 | 58 | 313.83 ± 1.3% | not timed | not timed | 277.54 ± 0.2% | 59.42 ± 9.2% | not timed | not timed | 313.87 ± 3.5% | | 1.00 | 1.13 | 5.28 |
| imported/rsc/reallyhard0-1k | 27 | 580.93 ± 0.2% | not timed | not timed | 579.36 ± 0.3% | 48.06 ± 1.4% | not timed | not timed | 580.56 ± 0.2% | | 1.00 | 1.00 | 12.09 |
| imported/rsc/reallyhard0-32k | 27 | 592.03 ± 0.2% | not timed | not timed | 594.34 ± 0.2% | 33.53 ± 0.5% | not timed | not timed | 591.28 ± 0.1% | | 1.00 | 1.00 | 17.66 |
| imported/rsc/reallyhard0-1mb | 51 | 594.38 ± 0.4% | not timed | not timed | 594.80 ± 0.6% | 34.17 ± 0.7% | not timed | not timed | 594.44 ± 0.1% | | 1.00 | 1.00 | 17.40 |
| imported/rsc/reallyreallyhard0-32 | 47 | 348.87 ± 1.5% | not timed | not timed | 253.42 ± 1.2% | 69.56 ± 15.1% | not timed | not timed | 347.77 ± 3.8% | | 1.00 | 1.38 | 5.02 |
| imported/rsc/reallyreallyhard0-1k | 16 | 8735.33 ± 5.5% | not timed | not timed | 9740.35 ± 6.2% | 37.76 ± 6.5% | not timed | not timed | 8712.31 ± 5.6% | | 1.00 | 0.90 | 231.34 |
| imported/rsc/reallyreallyhard0-32k | 16 | 41837.65 ± 0.5% | not timed | not timed | 34400.78 ± 0.1% | 27.94 ± 0.3% | not timed | not timed | 41871.39 ± 0.2% | | 1.00 | 1.22 | 1497.61 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 40464.21 ± 1.8% | not timed | not timed | 35036.94 ± 1.7% | 28.00 ± 0.6% | not timed | not timed | 40491.55 ± 0.4% | | 1.00 | 1.15 | 1445.26 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 329.24 ± 6.4% | not timed | not timed | 257.82 ± 1.3% | 69.40 ± 16.2% | not timed | not timed | 335.81 ± 1.2% | | 0.98 | 1.28 | 4.74 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 7035.15 ± 0.6% | not timed | not timed | 9314.47 ± 0.5% | 37.99 ± 0.4% | not timed | not timed | 7057.44 ± 1.8% | | 1.00 | 0.76 | 185.16 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 39912.38 ± 0.1% | not timed | not timed | 34228.50 ± 0.6% | 28.22 ± 0.4% | not timed | not timed | 39878.50 ± 0.3% | | 1.00 | 1.17 | 1414.38 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 35720.34 ± 0.2% | not timed | not timed | 31403.47 ± 0.6% | 28.19 ± 0.6% | not timed | not timed | 35711.14 ± 0.4% | | 1.00 | 1.14 | 1267.12 |
| imported/sherlock/name-sherlock | 776 | 31573.05 ± 2.1% | not timed | not timed | 29050.86 ± 0.3% | 11717.72 ± 17.8% | not timed | not timed | 31583.86 ± 7.1% | | 1.00 | 1.09 | 2.69 |
| imported/sherlock/name-holmes | 2766 | 20870.78 ± 1.7% | not timed | not timed | 22829.19 ± 1.2% | 3580.25 ± 5.1% | not timed | not timed | 21098.43 ± 2.9% | | 0.99 | 0.91 | 5.83 |
| imported/sherlock/name-sherlock-holmes | 1365 | 31687.90 ± 1.1% | not timed | not timed | 28574.65 ± 0.1% | 9619.44 ± 28.1% | not timed | not timed | 31681.65 ± 1.0% | | 1.00 | 1.11 | 3.29 |
| imported/sherlock/name-sherlock-casei | 816 | 28569.43 ± 0.7% | not timed | not timed | 9477.25 ± 4.0% | 34.56 ± 4.1% | not timed | not timed | 28587.44 ± 0.3% | | 1.00 | 3.01 | 826.61 |
| imported/sherlock/name-holmes-casei | 2802 | 17465.65 ± 6.3% | not timed | not timed | 6622.12 ± 0.4% | 47.91 ± 0.7% | not timed | not timed | 17468.74 ± 2.1% | | 1.00 | 2.64 | 364.54 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 24853.80 ± 0.9% | not timed | not timed | 9241.51 ± 3.7% | 34.74 ± 7.6% | not timed | not timed | 24831.87 ± 0.6% | | 1.00 | 2.69 | 715.33 |
| imported/sherlock/name-whitespace | 1461 | 22966.18 ± 7.6% | not timed | not timed | 22930.56 ± 0.4% | 7389.49 ± 47.1% | not timed | not timed | 22996.41 ± 2.1% | | 1.00 | 1.00 | 3.11 |
| imported/sherlock/name-alt1 | 1142 | 21341.54 ± 5.5% | not timed | not timed | 32569.45 ± 1.4% | 4660.62 ± 16.5% | not timed | not timed | 21383.86 ± 2.0% | | 1.00 | 0.66 | 4.58 |
| imported/sherlock/name-alt2 | 3542 | 15044.08 ± 1.2% | not timed | not timed | 8245.62 ± 3.5% | 38.49 ± 0.5% | not timed | not timed | 15098.95 ± 1.3% | | 1.00 | 1.82 | 390.90 |
| imported/sherlock/name-alt3 | 4507 | 11110.38 ± 3.0% | not timed | not timed | 7489.42 ± 1.4% | 12.23 ± 0.2% | not timed | not timed | 11000.76 ± 2.3% | | 1.01 | 1.48 | 908.49 |
| imported/sherlock/name-alt3-casei | 4593 | 1652.88 ± 1.2% | not timed | not timed | 1328.96 ± 0.4% | 7.38 ± 1.5% | not timed | not timed | 1652.08 ± 2.1% | | 1.00 | 1.24 | 223.89 |
| imported/sherlock/name-alt4 | 3686 | 9393.72 ± 0.8% | not timed | not timed | 7767.88 ± 0.8% | 38.32 ± 0.6% | not timed | not timed | 9381.93 ± 7.0% | | 1.00 | 1.21 | 245.13 |
| imported/sherlock/name-alt4-casei | 4254 | 3779.76 ± 2.0% | not timed | not timed | 3935.88 ± 6.0% | 20.94 ± 0.5% | not timed | not timed | 3748.64 ± 5.7% | | 1.01 | 0.96 | 180.48 |
| imported/sherlock/name-alt5 | 4028 | 13176.31 ± 1.7% | not timed | not timed | 8010.53 ± 1.2% | 26.75 ± 6.5% | not timed | not timed | 13174.76 ± 0.7% | | 1.00 | 1.64 | 492.52 |
| imported/sherlock/name-alt5-casei | 4104 | 5774.85 ± 5.2% | not timed | not timed | 2759.28 ± 0.6% | 15.29 ± 1.1% | not timed | not timed | 5901.69 ± 6.2% | | 0.98 | 2.09 | 377.78 |
| imported/sherlock/no-match-uncommon | 0 | 35917.16 ± 1.4% | not timed | not timed | 30551.03 ± 0.5% | 45454.84 ± 0.1% | not timed | not timed | 35951.85 ± 0.2% | | 1.00 | 1.18 | 0.79 |
| imported/sherlock/no-match-common | 0 | 35578.31 ± 0.2% | not timed | not timed | 30567.73 ± 0.2% | 1863.11 ± 1.3% | not timed | not timed | 35577.20 ± 0.4% | | 1.00 | 1.16 | 19.10 |
| imported/sherlock/no-match-really-common | 0 | 29705.15 ± 0.6% | not timed | not timed | 29978.75 ± 3.8% | 1864.17 ± 0.5% | not timed | not timed | 29692.67 ± 1.4% | | 1.00 | 0.99 | 15.93 |
| imported/sherlock/the-lower | 21654 | 2689.71 ± 2.3% | not timed | not timed | 2265.68 ± 1.0% | 256.09 ± 22.3% | not timed | not timed | 2709.34 ± 3.2% | | 0.99 | 1.19 | 10.50 |
| imported/sherlock/the-upper | 2223 | 16024.48 ± 1.9% | not timed | not timed | 19639.76 ± 7.7% | 2995.67 ± 8.3% | not timed | not timed | 15959.29 ± 3.9% | | 1.00 | 0.82 | 5.35 |
| imported/sherlock/the-casei | 23961 | 2380.47 ± 2.1% | not timed | not timed | 1350.40 ± 1.7% | 42.59 ± 33.4% | not timed | not timed | 2378.24 ± 8.0% | | 1.00 | 1.76 | 55.90 |
| imported/sherlock/everything-greedy | 581881 | 302.22 ± 0.9% | not timed | not timed | 175.21 ± 0.5% | 29.79 ± 24.6% | not timed | not timed | 301.68 ± 1.2% | | 1.00 | 1.72 | 10.14 |
| imported/sherlock/everything-greedy-nl | 594933 | 453.25 ± 0.1% | not timed | not timed | 225.33 ± 0.6% | 31.40 ± 3.1% | not timed | not timed | 452.96 ± 0.2% | | 1.00 | 2.01 | 14.44 |
| imported/sherlock/letters | 447175 | 64.96 ± 2.2% | not timed | not timed | 39.37 ± 0.6% | 6.74 ± 28.5% | not timed | not timed | 64.82 ± 1.8% | | 1.00 | 1.65 | 9.64 |
| imported/sherlock/letters-upper | 14180 | 433.55 ± 1.9% | not timed | not timed | 374.42 ± 7.5% | 29.90 ± 20.8% | not timed | not timed | 434.59 ± 23.9% | | 1.00 | 1.16 | 14.50 |
| imported/sherlock/letters-lower | 432995 | 65.71 ± 0.8% | not timed | not timed | 40.18 ± 0.6% | 5.46 ± 34.1% | not timed | not timed | 65.51 ± 2.0% | | 1.00 | 1.64 | 12.03 |
| imported/sherlock/words | 447639 | 118.74 ± 3.0% | not timed | not timed | 86.73 ± 3.1% | 14.60 ± 8.3% | not timed | not timed | 118.77 ± 3.1% | | 1.00 | 1.37 | 8.13 |
| imported/sherlock/before-holmes | 4073 | 12931.88 ± 3.3% | not timed | not timed | 13876.84 ± 4.8% | 26.08 ± 0.4% | not timed | not timed | 13135.04 ± 1.7% | | 0.98 | 0.93 | 495.85 |
| imported/sherlock/before-after-holmes | 2593 | 13171.04 ± 1.0% | not timed | not timed | 14399.52 ± 4.3% | 26.07 ± 3.3% | not timed | not timed | 13057.87 ± 3.7% | | 1.01 | 0.91 | 505.27 |
| imported/sherlock/holmes-cochar-watson | 150 | 9015.19 ± 1.2% | not timed | not timed | 6827.51 ± 1.7% | 38.65 ± 0.7% | not timed | not timed | 8941.54 ± 4.0% | | 1.01 | 1.32 | 233.23 |
| imported/sherlock/holmes-coword-watson | 14309 | 1221.74 ± 0.8% | not timed | not timed | 1210.85 ± 0.2% | 7.70 ± 0.7% | not timed | not timed | 1223.10 ± 0.3% | | 1.00 | 1.01 | 158.60 |
| imported/sherlock/quotes | 14437 | 1343.52 ± 0.6% | not timed | not timed | 1902.62 ± 5.7% | 38.03 ± 1.0% | not timed | not timed | 1342.03 ± 0.8% | | 1.00 | 0.71 | 35.33 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 590.99 ± 0.8% | not timed | not timed | 24751.84 ± 4.1% | 44.62 ± 5.9% | not timed | not timed | 591.27 ± 2.8% | | 1.00 | 0.0239 | 13.24 |
| imported/sherlock/word-ending-n | 35297 | 453.38 ± 3.3% | not timed | not timed | 401.98 ± 1.2% | 24.99 ± 2.9% | not timed | not timed | 453.11 ± 1.4% | | 1.00 | 1.13 | 18.14 |
| imported/sherlock/repeated-class-negation | 2130 | 17223.65 ± 3.0% | not timed | not timed | 16984.46 ± 4.6% | 11.51 ± 1.5% | not timed | not timed | 17645.14 ± 3.6% | | 0.98 | 1.01 | 1496.23 |
| imported/sherlock/ing-suffix | 20547 | 552.16 ± 1.1% | not timed | not timed | 505.44 ± 0.3% | 31.08 ± 30.2% | not timed | not timed | 550.10 ± 1.3% | | 1.00 | 1.09 | 17.77 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 589.50 ± 0.9% | not timed | not timed | 2415.40 ± 5.8% | 22.52 ± 1.1% | not timed | not timed | 589.20 ± 0.9% | | 1.00 | 0.24 | 26.17 |
| opt/accelerate/whole-line | 239963 | 515.14 ± 0.3% | not timed | not timed | 409.12 ± 0.5% | 103.99 ± 17.8% | not timed | not timed | 515.24 ± 1.0% | | 1.00 | 1.26 | 4.95 |
| opt/accelerate/non-dna | 16745 | 497.48 ± 29.7% | not timed | not timed | 464.53 ± 4.9% | 34.73 ± 18.0% | not timed | not timed | 497.49 ± 0.9% | | 1.00 | 1.07 | 14.33 |
| opt/backtrack/words-english | 40536 | 139.18 ± 2.7% | not timed | not timed | 114.59 ± 0.1% | 21.84 ± 5.6% | not timed | not timed | 141.15 ± 0.8% | | 0.99 | 1.21 | 6.37 |
| opt/fixed-length/too-small-ascii | 0 | 368.65 ± 2.8% | not timed | not timed | 908.83 ± 1.4% | 125.53 ± 1.9% | not timed | not timed | 372.19 ± 2.3% | | 0.99 | 0.41 | 2.94 |
| opt/fixed-length/too-big-ascii | 0 | 4686.16 ± 2.2% | not timed | not timed | 7491.51 ± 0.5% | 156.01 ± 4.0% | not timed | not timed | 4731.61 ± 2.0% | | 0.99 | 0.63 | 30.04 |
| opt/fixed-length/go33484-1 | 0 | 906964.55 ± 5.5% | not timed | not timed | 1449037.37 ± 1.9% | 81909.86 ± 0.5% | not timed | not timed | 906169.49 ± 2.2% | | 1.00 | 0.63 | 11.07 |
| opt/fixed-length/go33484-2 | 0 | 894288.03 ± 5.4% | not timed | not timed | 1440985.59 ± 6.0% | 43238.93 ± 8.5% | not timed | not timed | 903512.34 ± 4.3% | | 0.99 | 0.62 | 20.68 |
| opt/fixed-length/go33484-3 | 0 | 2715.17 ± 4.5% | not timed | not timed | 144412.23 ± 8.7% | 1024.86 ± 0.3% | not timed | not timed | 2450.68 ± 0.4% | | 1.11 | 0.0188 | 2.65 |
| opt/literal-alt/one-pattern | 1 | 601.96 ± 1.3% | not timed | not timed | 605.82 ± 0.8% | 0.42 ± 0.2% | not timed | not timed | 602.34 ± 1.2% | | 1.00 | 0.99 | 1419.12 |
| opt/onepass/fn-predicate | 916 | 425.49 ± 0.7% | not timed | not timed | 407.91 ± 17.2% | 215.00 ± 34.6% | not timed | not timed | 426.16 ± 4.5% | | 1.00 | 1.04 | 1.98 |
| opt/onepass/first-three-words-english | 35128 | 172.54 ± 1.7% | not timed | not timed | 225.43 ± 1.6% | 87.53 ± 10.3% | not timed | not timed | 173.47 ± 2.9% | | 0.99 | 0.77 | 1.97 |
| opt/prefilter/literal-english | 1 | 35266.61 ± 0.8% | not timed | not timed | 30934.04 ± 9.9% | 22219.58 ± 5.6% | not timed | not timed | 35270.36 ± 0.3% | | 1.00 | 1.14 | 1.59 |
| opt/prefilter/literal-casei-english | 1 | 28066.36 ± 0.4% | not timed | not timed | 10973.79 ± 3.8% | 34.96 ± 1.5% | not timed | not timed | 28103.08 ± 0.4% | | 1.00 | 2.56 | 802.81 |
| opt/prefilter/literal-russian | 1 | 36469.61 ± 3.1% | not timed | not timed | 31706.16 ± 0.6% | 1774.45 ± 1.7% | not timed | not timed | 36483.68 ± 0.8% | | 1.00 | 1.15 | 20.55 |
| opt/prefilter/literal-casei-russian | 1 | 20790.72 ± 0.5% | not timed | not timed | 8689.85 ± 2.3% | 38.57 ± 1.7% | not timed | not timed | 20853.76 ± 6.2% | | 1.00 | 2.39 | 538.97 |
| opt/prefilter/rust-functions | 948 | 12107.30 ± 3.7% | not timed | not timed | 10451.66 ± 3.3% | 1935.82 ± 23.2% | not timed | not timed | 12150.19 ± 1.1% | | 1.00 | 1.16 | 6.25 |
| opt/reverse-anchored/word-end | 1 | 37711936.53 ± 1.2% | not timed | not timed | 35219296.11 ± 3.3% | 55.39 ± 1.4% | not timed | not timed | 38441088.05 ± 6.9% | | 0.98 | 1.07 | 680883.58 |
| opt/reverse-inner/holmes | 2593 | 13127.27 ± 5.2% | not timed | not timed | 14482.46 ± 2.9% | 26.13 ± 0.3% | not timed | not timed | 13118.99 ± 1.1% | | 1.00 | 0.91 | 502.34 |
| opt/reverse-inner/email | 47 | 33249.54 ± 0.9% | not timed | not timed | 32086.29 ± 0.3% | 35.72 ± 0.5% | not timed | not timed | 33289.74 ± 0.9% | | 1.00 | 1.04 | 930.90 |
| opt/reverse-inner/factored-prefix | 3542 | 581.91 ± 1.1% | not timed | not timed | 579.29 ± 0.5% | 13.73 ± 0.9% | not timed | not timed | 582.13 ± 0.2% | | 1.00 | 1.00 | 42.39 |
| opt/reverse-inner/no-quadratic-backward | 0 | 4056.36 ± 0.2% | not timed | not timed | 594.98 ± 0.2% | 80.94 ± 4.2% | not timed | not timed | 4059.46 ± 0.5% | | 1.00 | 6.82 | 50.11 |
| opt/reverse-inner/no-quadratic-forward | 0 | 691.92 ± 2.2% | not timed | not timed | 273.94 ± 0.6% | 30.59 ± 0.9% | not timed | not timed | 692.25 ± 2.4% | | 1.00 | 2.53 | 22.62 |
| opt/reverse-suffix/holmes | 4073 | 13194.71 ± 1.2% | not timed | not timed | 13682.53 ± 0.8% | 26.12 ± 0.9% | not timed | not timed | 13114.49 ± 3.5% | | 1.01 | 0.96 | 505.11 |
| opt/reverse-suffix/no-quadratic | 0 | 4058.48 ± 0.2% | not timed | not timed | 595.02 ± 0.2% | 79.38 ± 3.4% | not timed | not timed | 4057.18 ± 0.2% | | 1.00 | 6.82 | 51.12 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 131.57 ± 2.5% | not timed | not timed | 193.03 ± 1.6% | 16.48 ± 20.7% | not timed | not timed | 130.97 ± 4.3% | | 1.00 | 0.68 | 7.98 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 130.18 ± 6.0% | not timed | not timed | 191.14 ± 1.6% | 15.84 ± 17.8% | not timed | not timed | 130.13 ± 2.6% | | 1.00 | 0.68 | 8.22 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.35 ± 0.4% | not timed | not timed | 0.56 ± 0.3% | 122.09 ± 1.6% | not timed | not timed | 0.35 ± 1.7% | | 1.01 | 0.63 | 0.0029 |
| reported/i1095-word-repetition/ascii-search | 256 | 318.01 ± 0.3% | not timed | not timed | 296.55 ± 0.3% | 109.59 ± 1.3% | not timed | not timed | 317.95 ± 2.1% | | 1.00 | 1.07 | 2.90 |
| reported/i13-subset-regex/original-ascii | 4094 | 10413.53 ± 1.9% | not timed | not timed | 4076.23 ± 0.5% | 11.20 ± 1.2% | not timed | not timed | 10396.42 ± 0.9% | | 1.00 | 2.55 | 930.16 |
| reported/i13-subset-regex/original-unicode | 4094 | 10394.36 ± 2.7% | not timed | not timed | 227.87 ± 13.7% | 11.42 ± 0.6% | not timed | not timed | 10405.74 ± 26.1% | | 1.00 | 45.62 | 910.16 |
| reported/i13-subset-regex/big-ascii | 1955 | 9686.96 ± 2.8% | not timed | not timed | 60.91 ± 2.5% | 9.99 ± 0.3% | not timed | not timed | 9752.35 ± 4.9% | | 0.99 | 159.05 | 970.03 |
| reported/i13-subset-regex/big-unicode | 1955 | 9745.90 ± 1.2% | not timed | not timed | 10.93 ± 55.1% | 9.98 ± 0.7% | not timed | not timed | 9755.56 ± 1.3% | | 1.00 | 891.64 | 976.50 |
| reported/i13-subset-regex/huge-ascii | 55 | 9070.80 ± 1.6% | not timed | not timed | 10.31 ± 0.9% | 9.44 ± 0.3% | not timed | not timed | 9097.67 ± 1.3% | | 1.00 | 880.19 | 960.51 |
| reported/i13-subset-regex/huge-unicode | 55 | 8991.22 ± 1.3% | not timed | not timed | 10.30 ± 0.3% | 9.46 ± 0.5% | not timed | not timed | 8979.87 ± 1.4% | | 1.00 | 872.92 | 950.75 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.14 ± 0.6% | not timed | not timed | 9.75 ± 0.4% | 9.42 ± 1.8% | not timed | not timed | 3.90 ± 0.4% | | 1.06 | 0.42 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.80 ± 1.1% | not timed | not timed | 10.01 ± 0.2% | 9.43 ± 1.9% | not timed | not timed | 5.81 ± 1.3% | | 1.00 | 0.58 | 0.61 |
| reported/i787-keywords/ascii | 5674 | 532.70 ± 2.5% | not timed | not timed | 135.46 ± 0.4% | 7.67 ± 0.9% | not timed | not timed | 526.47 ± 1.8% | | 1.01 | 3.93 | 69.42 |
| reported/i787-keywords/opt-ascii | 5674 | 526.54 ± 2.8% | not timed | not timed | 278.96 ± 2.8% | 12.13 ± 22.6% | not timed | not timed | 532.41 ± 2.3% | | 0.99 | 1.89 | 43.41 |
| slow/quadratic-regex-1x | 100 | 8.65 ± 0.4% | not timed | not timed | 6.38 ± 0.5% | 0.06 ± 1.9% | not timed | not timed | 8.63 ± 0.6% | | 1.00 | 1.36 | 147.75 |
| slow/quadratic-regex-2x | 199 | 3.75 ± 0.9% | not timed | not timed | 3.12 ± 0.3% | 0.02 ± 2.6% | not timed | not timed | 3.75 ± 0.5% | | 1.00 | 1.20 | 246.88 |
| slow/quadratic-haystack-1x | 100 | 27.34 ± 1.5% | not timed | not timed | 12.70 ± 0.6% | 1.20 ± 8.5% | not timed | not timed | 27.43 ± 2.5% | | 1.00 | 2.15 | 22.76 |
| slow/quadratic-haystack-2x | 200 | 21.11 ± 1.2% | not timed | not timed | 6.18 ± 0.4% | 0.66 ± 7.6% | not timed | not timed | 21.16 ± 2.4% | | 1.00 | 3.41 | 32.07 |
| unicode/codepoints/any-one | 1112064 | 363.82 ± 4.2% | not timed | not timed | 282.35 ± 5.3% | 19.42 ± 5.1% | not timed | not timed | 364.30 ± 0.4% | | 1.00 | 1.29 | 18.73 |
| unicode/codepoints/any-all | 4382592 | 271.48 ± 0.2% | not timed | not timed | 270.25 ± 0.3% | 116.72 ± 3.2% | not timed | not timed | 271.65 ± 0.2% | | 1.00 | 1.00 | 2.33 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.75 ± 5.6% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 594.33 ± 0.1% | not timed | not timed | 593.84 ± 0.6% | 161.87 ± 1.4% | not timed | not timed | 594.28 ± 1.1% | | 1.00 | 1.00 | 3.67 |
| unicode/overlapping-words/ascii | 6156 | 31.14 ± 9.8% | not timed | not timed | 47.19 ± 1.6% | 4.07 ± 5.6% | not timed | not timed | 31.20 ± 4.2% | | 1.00 | 0.66 | 7.65 |
| unicode/overlapping-words/english | 6156 | 1.36 ± 1.9% | not timed | not timed | 2.05 ± 2.2% | 2.54 ± 1.3% | not timed | not timed | 1.56 ± 1.5% | | 0.87 | 0.66 | 0.53 |
| unicode/overlapping-words/russian | 5710 | 1.38 ± 3.8% | not timed | not timed | 1.98 ± 0.4% | 6.57 ± 11.2% | not timed | not timed | 1.47 ± 2.9% | | 0.94 | 0.69 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 124.50 ± 2.0% | not timed | not timed | 86.07 ± 2.5% | 11.75 ± 19.9% | not timed | not timed | 124.45 ± 1.9% | | 1.00 | 1.45 | 10.60 |
| unicode/word/boundary-long-english | 3466 | 594.16 ± 0.6% | not timed | not timed | 585.47 ± 0.2% | 34.29 ± 0.7% | not timed | not timed | 594.98 ± 0.3% | | 1.00 | 1.01 | 17.33 |
| unicode/word/around-holmes-english | 27 | 34068.74 ± 0.5% | not timed | not timed | 31325.71 ± 0.2% | 23.16 ± 0.7% | not timed | not timed | 34103.55 ± 0.3% | | 1.00 | 1.09 | 1471.26 |
| wild/bibleref/long | 874 | 558.67 ± 0.3% | not timed | not timed | 565.82 ± 0.2% | 8.66 ± 0.8% | not timed | not timed | 558.31 ± 0.4% | | 1.00 | 0.99 | 64.53 |
| wild/bibleref/short | 30 | 24.87 ± 10.1% | not timed | not timed | 35.75 ± 0.5% | 17.15 ± 14.5% | not timed | not timed | 25.59 ± 8.0% | | 0.97 | 0.70 | 1.45 |
| wild/bibleref/line | 874 | 510.98 ± 0.4% | not timed | not timed | 268.26 ± 0.3% | 9.60 ± 0.7% | not timed | not timed | 510.57 ± 0.7% | | 1.00 | 1.90 | 53.22 |
| wild/caddy/caddy | 6 | 456.90 ± 3.7% | not timed | not timed | 275.51 ± 0.6% | 80.36 ± 11.4% | not timed | not timed | 454.77 ± 5.4% | | 1.00 | 1.66 | 5.69 |
| wild/dot-star-capture/rust-src-tools | 6 | 1194.21 ± 1.3% | not timed | not timed | 340.30 ± 0.2% | 15.76 ± 1.8% | not timed | not timed | 1192.99 ± 6.6% | | 1.00 | 3.51 | 75.77 |
| wild/ruff/noqa | 84 | 567.52 ± 0.7% | not timed | not timed | 528.02 ± 3.2% | 23.10 ± 4.1% | not timed | not timed | 564.52 ± 7.4% | | 1.01 | 1.07 | 24.57 |
| wild/ruff/unnecessary-coding-comment | 16 | 1039.99 ± 0.5% | not timed | not timed | 680.83 ± 1.2% | 149.46 ± 12.2% | not timed | not timed | 1038.72 ± 2.0% | | 1.00 | 1.53 | 6.96 |
| wild/ruff/string-quote-prefix | 2972 | 1503.60 ± 1.0% | not timed | not timed | 491.94 ± 0.2% | 325.44 ± 26.9% | not timed | not timed | 1495.38 ± 5.5% | | 1.01 | 3.06 | 4.62 |
| wild/ruff/space-around-operator | 1224378 | 247.28 ± 2.8% | not timed | not timed | 227.35 ± 0.2% | 19.69 ± 2.6% | not timed | not timed | 247.11 ± 2.2% | | 1.00 | 1.09 | 12.56 |
| wild/ruff/shebang | 282 | 1041.58 ± 1.2% | not timed | not timed | 403.37 ± 0.7% | 130.97 ± 13.1% | not timed | not timed | 1039.95 ± 1.3% | | 1.00 | 2.58 | 7.95 |
| wild/rustsec-cargo-audit/original-unix | 471 | 15686.85 ± 2.2% | not timed | not timed | 16917.91 ± 3.1% | 7300.93 ± 2.0% | not timed | not timed | 15695.58 ± 0.6% | | 1.00 | 0.93 | 2.15 |
| wild/rustsec-cargo-audit/original-windows | 462 | 14713.26 ± 1.0% | not timed | not timed | 16379.28 ± 0.5% | 6808.03 ± 0.5% | not timed | not timed | 14729.78 ± 0.8% | | 1.00 | 0.90 | 2.16 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 15531.16 ± 0.4% | not timed | not timed | 16333.72 ± 4.6% | 6994.00 ± 20.0% | not timed | not timed | 15545.74 ± 0.2% | | 1.00 | 0.95 | 2.22 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 13669.72 ± 0.2% | not timed | not timed | 16667.17 ± 0.9% | 7061.67 ± 1.6% | not timed | not timed | 13656.89 ± 0.3% | | 1.00 | 0.82 | 1.94 |
| wild/url/search | 234965 | 132.10 ± 13.5% | not timed | not timed | 68.83 ± 5.0% | 2.45 ± 0.9% | not timed | not timed | 132.27 ± 13.6% | | 1.00 | 1.92 | 53.96 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 57.0% | not timed | not timed | 0.01 ± 10.6% | 0.01 ± 18.0% | not timed | not timed | 0.03 ± 58.8% | | 0.98 | 3.04 | 3.56 |
| dictionary/compile/english-15 | 1 | 0.34 ± 1.3% | not timed | not timed | 0.08 ± 0.7% | 0.12 ± 22.7% | not timed | not timed | 0.34 ± 0.7% | | 1.00 | 4.35 | 2.92 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 5.3% | not timed | not timed | 0.02 ± 2.7% | 36.23 ± 13.1% | not timed | not timed | 0.26 ± 1.9% | | 0.99 | 10.83 | 0.0070 |
| reported/i1095-word-repetition/ascii-compile | 1 | 44.57 ± 16.0% | not timed | not timed | 14.26 ± 0.5% | 66.46 ± 17.3% | not timed | not timed | 44.64 ± 1.2% | | 1.00 | 3.13 | 0.67 |
| reported/i787-keywords/compile | 1 | 40.18 ± 3.2% | not timed | not timed | 2.05 ± 0.7% | 19.05 ± 24.3% | not timed | not timed | 41.14 ± 0.9% | | 0.98 | 19.56 | 2.11 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 438.39 ± 7.2% | not timed | not timed | 144.86 ± 0.3% | 661.86 ± 20.5% | not timed | not timed | 440.22 ± 2.8% | | 1.00 | 3.03 | 0.66 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 59.38 ± 2.4% | not timed | not timed | 4.34 ± 1.5% | 50.18 ± 2.0% | not timed | not timed | 60.40 ± 11.6% | | 0.98 | 13.67 | 1.18 |
| unicode/compile/one-letter | 53 | 7.46 ± 4.0% | not timed | not timed | 5.56 ± 0.1% | 66.94 ± 10.2% | not timed | not timed | 7.30 ± 13.3% | | 1.02 | 1.34 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.08 ± 3.1% | not timed | not timed | 0.12 ± 0.4% | 71.52 ± 14.5% | not timed | not timed | 1.09 ± 16.5% | | 0.99 | 8.94 | 0.0151 |
| unicode/compile/fifty-letters-ascii | 1 | 241.16 ± 7.7% | not timed | not timed | 63.06 ± 0.7% | 228.58 ± 20.3% | not timed | not timed | 242.98 ± 4.3% | | 0.99 | 3.82 | 1.06 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 505.68 ± 9.7% | not timed | not timed | 46.64 ± 0.3% | 795.03 ± 3.5% | not timed | not timed | 492.24 ± 3.3% | | 1.03 | 10.84 | 0.64 |
| unicode/compile/match-every-line-ascii | 4 | 805.69 ± 4.1% | not timed | not timed | 174.72 ± 0.2% | 778.99 ± 6.7% | not timed | not timed | 811.40 ± 7.4% | | 0.99 | 4.61 | 1.03 |
| unicode/compile/negated-class-matches-codepoint | 1 | 409.04 ± 7.7% | not timed | not timed | 50.46 ± 1.6% | 1411.99 ± 15.5% | not timed | not timed | 412.91 ± 1.8% | | 0.99 | 8.11 | 0.29 |
| wild/bibleref/compile | 3 | 6.11 ± 8.1% | not timed | not timed | 2.08 ± 1.7% | 39.20 ± 21.7% | not timed | not timed | 6.48 ± 58.2% | | 0.94 | 2.93 | 0.16 |
| wild/url/compile | 1 | 0.75 ± 9.3% | not timed | not timed | 0.16 ± 1.0% | 0.52 ± 22.3% | not timed | not timed | 0.75 ± 10.7% | | 1.00 | 4.59 | 1.43 |

