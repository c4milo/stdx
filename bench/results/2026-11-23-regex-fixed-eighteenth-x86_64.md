# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159340522 |
| Date | 2026-11-23 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache and the CPU features it detected at start, as Rust's regex detects them, `stdx, no skip` the same with claims R1 to R5 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

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
| literal: a word | 217 | 31655.21 ± 0.3% | 801.38 ± 0.4% | 25.77 ± 2.6% | 30316.88 ± 0.8% | 9037.80 ± 10.3% | 9.89 ± 0.3% | 80.96 ± 0.2% | 31595.93 ± 2.8% | 39.50 | 1.00 | 1.04 | 3.50 |
| literal: a word that is not there | 0 | 44376.90 ± 6.3% | 809.26 ± 2.2% | 25.59 ± 16.4% | 35703.26 ± 0.7% | 32999.28 ± 3.1% | 9.79 ± 0.2% | 75.56 ± 0.4% | 44266.14 ± 2.0% | 54.84 | 1.00 | 1.24 | 1.34 |
| literal: one of four words | 661 | 11100.56 ± 0.4% | 785.82 ± 0.2% | 13.55 ± 0.6% | 8873.85 ± 0.4% | 19.20 ± 0.4% | 3.47 ± 0.1% | 6.15 ± 1.3% | 11065.58 ± 0.2% | 14.13 | 1.00 | 1.25 | 578.12 |
| literal: a word in any case | 217 | 28525.22 ± 9.0% | 800.67 ± 0.2% | 18.98 ± 3.1% | 8950.22 ± 3.5% | 36.50 ± 1.8% | refused | differs | 28590.83 ± 4.2% | 35.63 | 1.00 | 3.19 | 781.52 |
| literal: an href attribute | 33 | 27634.01 ± 0.5% | 806.02 ± 0.1% | 24.60 ± 0.5% | 27052.92 ± 0.7% | 2222.43 ± 4.0% | 7.41 ± 0.1% | 70.78 ± 0.4% | 27557.45 ± 0.4% | 34.28 | 1.00 | 1.02 | 12.43 |
| literal: a word, second text | 123 | 34173.45 ± 0.4% | 803.13 ± 0.5% | 25.30 ± 0.6% | 30520.40 ± 0.6% | 8536.06 ± 7.8% | 11.16 ± 0.5% | 68.36 ± 0.5% | 34171.16 ± 0.4% | 42.55 | 1.00 | 1.12 | 4.00 |
| class: two capitalized words | 1331 | 707.29 ± 0.1% | 746.11 ± 0.1% | 23.00 ± 0.6% | 446.89 ± 0.2% | 34.37 ± 1.1% | 8.47 ± 0.1% | 62.29 ± 0.4% | 706.44 ± 0.1% | 0.95 | 1.00 | 1.58 | 20.58 |
| class: a word that ends in ing | 3399 | 686.60 ± 0.6% | 686.02 ± 0.6% | 15.95 ± 0.3% | 417.09 ± 0.2% | 25.42 ± 5.8% | 4.47 ± 0.1% | 15.40 ± 0.4% | 686.09 ± 0.2% | 1.00 | 1.00 | 1.65 | 27.01 |
| class: a word in capitals | 2332 | 890.13 ± 0.3% | 727.61 ± 0.2% | 25.10 ± 5.3% | 439.31 ± 0.6% | 37.12 ± 7.9% | 9.56 ± 0.3% | 78.79 ± 4.2% | 888.72 ± 0.3% | 1.22 | 1.00 | 2.03 | 23.98 |
| class: a number | 8288 | 1323.62 ± 0.8% | 629.23 ± 0.2% | 25.29 ± 0.4% | 1353.85 ± 0.2% | 35.39 ± 11.2% | 0.30 ± 0.4% | 53.72 ± 1.0% | 1332.85 ± 0.6% | 2.10 | 0.99 | 0.98 | 37.40 |
| class: two capitalized words, second text | 5359 | 555.47 ± 0.1% | 555.19 ± 0.2% | 21.27 ± 0.5% | 371.18 ± 0.3% | 27.95 ± 12.5% | 9.80 ± 0.1% | 57.53 ± 0.9% | 554.97 ± 0.8% | 1.00 | 1.00 | 1.50 | 19.88 |
| other: a word between two words | 6104 | 646.82 ± 0.4% | 583.30 ± 1.1% | 20.33 ± 0.2% | 632.51 ± 0.6% | 97.81 ± 8.5% | 6.56 ± 0.4% | 63.64 ± 0.2% | 645.07 ± 0.3% | 1.11 | 1.00 | 1.02 | 6.61 |
| other: a number before a unit, second text | 1481 | 7696.38 ± 0.8% | 768.66 ± 0.2% | 23.72 ± 0.2% | 6405.78 ± 0.5% | 34.57 ± 1.8% | 10.24 ± 0.9% | 60.63 ± 0.7% | 7428.83 ± 7.0% | 10.01 | 1.04 | 1.20 | 222.62 |
| other: a heading's start tag | 110 | 19004.75 ± 0.5% | 799.22 ± 0.1% | 25.60 ± 6.4% | 2000.56 ± 1.8% | 1561.67 ± 4.9% | 9.07 ± 0.3% | 82.98 ± 9.1% | 19025.54 ± 0.4% | 23.78 | 1.00 | 9.50 | 12.17 |
| other: a whole word | 217 | 22572.16 ± 1.6% | 800.26 ± 0.1% | 25.54 ± 0.9% | 21955.57 ± 0.3% | 42.05 ± 0.5% | 8.56 ± 0.2% | 48.71 ± 0.4% | 22590.66 ± 0.2% | 28.21 | 1.00 | 1.03 | 536.76 |
| other: a line's first word, second text | 3716 | 1982.47 ± 1.8% | 667.84 ± 0.2% | 27.96 ± 1.7% | 1761.06 ± 2.5% | 55.40 ± 9.5% | refused | refused | 1978.21 ± 0.3% | 2.97 | 1.00 | 1.13 | 35.79 |
| other: fourteen octets before an x | 87 | 27421.35 ± 0.2% | 192.40 ± 2.2% | 5.97 ± 0.5% | 2653.68 ± 0.5% | 8.86 ± 1.2% | differs | 16.93 ± 2.9% | 27956.07 ± 0.2% | 142.52 | 0.98 | 10.33 | 3096.01 |
| other: a Greek word | 21815 | 359.62 ± 0.8% | 303.06 ± 0.4% | 27.11 ± 1.3% | 236.56 ± 0.5% | 38.74 ± 10.4% | differs | refused | 359.61 ± 0.7% | 1.19 | 1.00 | 1.52 | 9.28 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 22.92 ± 1.3% | 22.78 ± 1.6% | 0.80 ± 0.9% | 15.34 ± 3.8% | 2.18 ± 0.5% | differs | 3.13 ± 3.1% | 22.91 ± 0.2% | 1.01 | 1.00 | 1.49 | 10.50 |
| a UUID | 32895 | 18.73 ± 0.2% | 18.77 ± 2.3% | 0.57 ± 0.4% | 11.70 ± 0.4% | 2.33 ± 4.0% | 0.41 ± 0.2% | 2.91 ± 0.8% | 18.70 ± 0.3% | 1.00 | 1.00 | 1.60 | 8.04 |
| an IPv4 address | 33176 | 31.00 ± 1.6% | 31.01 ± 1.8% | 1.81 ± 0.3% | 21.93 ± 0.4% | 5.36 ± 2.5% | differs | 3.22 ± 0.9% | 31.28 ± 0.6% | 1.00 | 0.99 | 1.41 | 5.78 |
| a date and time | 32954 | 28.02 ± 1.6% | 27.95 ± 0.1% | 1.34 ± 0.5% | 16.75 ± 0.1% | 6.16 ± 3.9% | 0.70 ± 0.5% | 6.01 ± 2.6% | 27.96 ± 0.4% | 1.00 | 1.00 | 1.67 | 4.55 |
| a field path | 32606 | 25.01 ± 0.3% | 25.20 ± 0.8% | 0.88 ± 0.7% | 17.68 ± 0.3% | 2.70 ± 0.7% | differs | 2.29 ± 0.7% | 25.20 ± 8.1% | 0.99 | 0.99 | 1.41 | 9.25 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.43 ± 18.3% | 8.40 ± 0.9% | 8.40 ± 0.2% | 10.13 ± 0.7% | 4.55 ± 2.4% | 0.58 ± 0.3% | none | 8.41 ± 0.2% | 1.00 | 1.00 | 0.83 | 1.85 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 182.74 ± 0.4% | 183.91 ± 0.1% | 212.46 ± 0.3% | 77.97 ± 4.0% | 188.83 ± 1.5% | 556.78 ± 3.5% | 3718.66 ± 1.0% | 182.98 ± 0.3% | 0.99 | 1.00 | 2.34 | 0.97 |
| a UUID | 62 | 118.66 ± 0.3% | 119.21 ± 0.3% | 131.58 ± 0.3% | 44.94 ± 1.9% | 91.23 ± 2.6% | 196.66 ± 2.6% | 4316.94 ± 1.8% | 118.53 ± 0.3% | 1.00 | 1.00 | 2.64 | 1.30 |
| an IPv4 address | 29 | 393.30 ± 0.4% | 397.55 ± 0.3% | 562.93 ± 0.7% | 65.85 ± 0.6% | 114.31 ± 3.1% | 317.46 ± 4.5% | 6918.85 ± 1.4% | 392.38 ± 1.1% | 0.99 | 1.00 | 5.97 | 3.44 |
| a date and time | 56 | 293.02 ± 5.4% | 295.15 ± 6.0% | 373.44 ± 10.0% | 65.99 ± 8.2% | 123.08 ± 3.2% | 366.40 ± 3.8% | 4469.44 ± 0.9% | 292.71 ± 3.0% | 0.99 | 1.00 | 4.44 | 2.38 |
| a field path | 39 | 173.62 ± 0.5% | 174.59 ± 12.9% | 199.76 ± 0.8% | 72.87 ± 2.6% | 159.68 ± 14.2% | 598.85 ± 9.6% | 4548.13 ± 1.8% | 173.60 ± 13.1% | 0.99 | 1.00 | 2.38 | 1.09 |
| literal: a word | 7 | 595.00 ± 0.2% | 633.99 ± 1.1% | 1151.21 ± 13.1% | 478.16 ± 9.2% | 593.80 ± 12.9% | 1264.29 ± 4.4% | 25230.71 ± 2.0% | 594.10 ± 0.7% | 0.94 | 1.00 | 1.24 | 1.00 |
| literal: a word that is not there | 8 | 571.81 ± 0.3% | 614.83 ± 0.4% | 1083.59 ± 0.5% | 440.45 ± 1.1% | 574.47 ± 10.4% | 1167.61 ± 20.4% | 24073.79 ± 1.0% | 571.19 ± 0.4% | 0.93 | 1.00 | 1.30 | 1.00 |
| literal: one of four words | 26 | 218.79 ± 2.4% | 361.96 ± 0.3% | 489.98 ± 8.7% | 41.11 ± 1.2% | 225.36 ± 2.6% | 453.03 ± 2.5% | 16306.20 ± 2.6% | 219.00 ± 1.1% | 0.60 | 1.00 | 5.32 | 0.97 |
| literal: a word in any case | 11 | 451.33 ± 4.8% | 476.47 ± 0.5% | 724.38 ± 1.2% | 14.60 ± 1.0% | 625.75 ± 1.5% | refused | 21419.86 ± 1.3% | 450.53 ± 1.5% | 0.95 | 1.00 | 30.90 | 0.72 |
| literal: an href attribute | 12 | 314.25 ± 0.6% | 326.11 ± 0.3% | 432.12 ± 0.4% | 39.33 ± 0.8% | 443.06 ± 3.1% | 1001.06 ± 0.8% | 18412.42 ± 1.2% | 315.05 ± 0.4% | 0.96 | 1.00 | 7.99 | 0.71 |
| literal: a word, second text | 10 | 529.05 ± 1.5% | 576.09 ± 0.4% | 975.07 ± 1.0% | 404.32 ± 1.0% | 505.52 ± 3.5% | 1053.90 ± 1.7% | 23222.55 ± 3.1% | 529.90 ± 0.5% | 0.92 | 1.00 | 1.31 | 1.05 |
| class: two capitalized words | 23 | 412.75 ± 0.3% | 447.09 ± 0.6% | 654.09 ± 0.7% | 93.97 ± 0.7% | 461.30 ± 1.6% | 1002.48 ± 1.6% | 6292.70 ± 0.3% | 412.60 ± 1.5% | 0.92 | 1.00 | 4.39 | 0.89 |
| class: a word that ends in ing | 9 | 511.09 ± 0.3% | 583.01 ± 0.2% | 1019.20 ± 3.2% | 115.90 ± 2.7% | 644.90 ± 4.1% | 1484.03 ± 0.7% | 15006.96 ± 0.4% | 510.03 ± 0.3% | 0.88 | 1.00 | 4.41 | 0.79 |
| class: a word in capitals | 16 | 455.99 ± 0.4% | 500.06 ± 1.4% | 812.59 ± 0.8% | 120.51 ± 1.8% | 682.03 ± 5.1% | 1370.31 ± 0.2% | 8252.18 ± 1.6% | 456.64 ± 0.4% | 0.91 | 1.00 | 3.78 | 0.67 |
| class: a number | 6 | 560.62 ± 2.0% | 629.50 ± 3.2% | 1189.00 ± 0.7% | 36.41 ± 0.4% | 1253.02 ± 4.0% | 2367.54 ± 8.0% | 20025.31 ± 1.3% | 560.76 ± 2.8% | 0.89 | 1.00 | 15.40 | 0.45 |
| class: two capitalized words, second text | 23 | 412.97 ± 0.5% | 448.09 ± 10.7% | 655.95 ± 0.5% | 94.36 ± 0.4% | 463.88 ± 4.0% | 994.13 ± 0.9% | 6289.46 ± 24.0% | 412.25 ± 0.3% | 0.92 | 1.00 | 4.38 | 0.89 |
| other: a word between two words | 13 | 506.32 ± 1.0% | 524.84 ± 0.4% | 836.99 ± 0.2% | 122.97 ± 1.4% | 450.15 ± 1.3% | 1066.91 ± 14.2% | 13500.50 ± 0.4% | 507.19 ± 2.0% | 0.96 | 1.00 | 4.12 | 1.12 |
| other: a number before a unit, second text | 15 | 341.80 ± 0.2% | 381.18 ± 0.1% | 520.26 ± 1.2% | 34.01 ± 0.8% | 557.21 ± 3.4% | 1149.94 ± 2.2% | 13899.88 ± 0.4% | 341.69 ± 0.1% | 0.90 | 1.00 | 10.05 | 0.61 |
| other: a heading's start tag | 13 | 326.19 ± 0.2% | 332.16 ± 0.2% | 440.72 ± 0.3% | 37.23 ± 7.1% | 546.07 ± 10.0% | 1119.07 ± 0.7% | 15573.00 ± 1.9% | 325.96 ± 1.2% | 0.98 | 1.00 | 8.76 | 0.60 |
| other: a whole word | 11 | 522.69 ± 1.2% | 551.86 ± 0.4% | 911.91 ± 1.3% | 109.52 ± 2.1% | 518.17 ± 0.9% | 1080.86 ± 0.6% | 23458.29 ± 0.3% | 521.46 ± 0.7% | 0.95 | 1.00 | 4.77 | 1.01 |
| other: a line's first word, second text | 17 | 489.72 ± 2.9% | 511.68 ± 0.2% | 816.99 ± 0.2% | 113.57 ± 0.8% | 615.96 ± 1.5% | refused | refused | 488.34 ± 0.6% | 0.96 | 1.00 | 4.31 | 0.80 |
| other: fourteen octets before an x | 16 | 91.20 ± 8.9% | 138.63 ± 0.5% | 162.93 ± 0.4% | 14.18 ± 1.1% | 403.67 ± 26.6% | 446.43 ± 2.0% | 12127.90 ± 12.4% | 91.99 ± 1.9% | 0.66 | 0.99 | 6.43 | 0.23 |
| other: a Greek word | 8 | 357.06 ± 1.0% | 492.03 ± 0.9% | 771.89 ± 0.8% | 48.89 ± 0.7% | 1234.32 ± 2.6% | 2210.43 ± 0.7% | refused | 357.35 ± 0.3% | 0.73 | 1.00 | 7.30 | 0.29 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 22448.56 ± 1.9% | not timed | not timed | 26203.82 ± 0.8% | 1887.16 ± 20.5% | not timed | not timed | 22441.44 ± 0.5% | | 1.00 | 0.86 | 11.90 |
| 01-literal/sherlock-casei-en | 522 | 6639.99 ± 0.5% | not timed | not timed | 7092.85 ± 0.2% | 26.46 ± 1.1% | not timed | not timed | 6599.35 ± 0.4% | | 1.01 | 0.94 | 250.96 |
| 01-literal/sherlock-ru | 724 | 23959.41 ± 0.6% | not timed | not timed | 26546.05 ± 0.3% | 994.90 ± 5.5% | not timed | not timed | 23894.33 ± 0.3% | | 1.00 | 0.90 | 24.08 |
| 01-literal/sherlock-casei-ru | 746 | 6357.40 ± 0.3% | not timed | not timed | 6120.03 ± 0.3% | 28.64 ± 2.4% | not timed | not timed | 6888.14 ± 1.8% | | 0.92 | 1.04 | 221.97 |
| 01-literal/sherlock-zh | 30 | 40929.16 ± 2.7% | not timed | not timed | 33265.28 ± 25.0% | 1274.18 ± 9.9% | not timed | not timed | 40875.64 ± 6.0% | | 1.00 | 1.23 | 32.12 |
| 02-literal-alternate/sherlock-en | 714 | 10031.84 ± 0.4% | not timed | not timed | 8576.49 ± 0.5% | 14.49 ± 0.8% | not timed | not timed | 10016.74 ± 0.7% | | 1.00 | 1.17 | 692.36 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3276.29 ± 7.4% | not timed | not timed | 1781.65 ± 0.4% | 9.52 ± 0.4% | not timed | not timed | 2987.44 ± 1.4% | | 1.10 | 1.84 | 344.14 |
| 02-literal-alternate/sherlock-ru | 899 | 5816.46 ± 0.4% | not timed | not timed | 7763.19 ± 0.8% | 19.75 ± 0.1% | not timed | not timed | 5812.82 ± 0.1% | | 1.00 | 0.75 | 294.54 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1702.93 ± 1.9% | not timed | not timed | 917.84 ± 1.1% | 8.17 ± 1.3% | not timed | not timed | 1676.07 ± 1.6% | | 1.02 | 1.86 | 208.38 |
| 02-literal-alternate/sherlock-zh | 207 | 14451.22 ± 0.3% | not timed | not timed | 9953.85 ± 2.0% | 27.53 ± 0.6% | not timed | not timed | 14419.16 ± 0.7% | | 1.00 | 1.45 | 524.99 |
| 03-date/ascii | 111817 | 98.97 ± 0.2% | not timed | not timed | 77.95 ± 0.9% | 0.18 ± 4.8% | not timed | not timed | 98.95 ± 0.6% | | 1.00 | 1.27 | 545.68 |
| 04-ruff-noqa/real | 84 | 536.45 ± 0.4% | not timed | not timed | 388.30 ± 0.2% | 16.16 ± 2.2% | not timed | not timed | 539.16 ± 0.5% | | 0.99 | 1.38 | 33.19 |
| 04-ruff-noqa/tweaked | 44 | 458.08 ± 0.2% | not timed | not timed | 398.85 ± 0.4% | 289.33 ± 1.9% | not timed | not timed | 456.70 ± 0.3% | | 1.00 | 1.15 | 1.58 |
| 05-lexer-veryl/single | 124800 | 3.18 ± 1.6% | not timed | not timed | 4.12 ± 10.2% | 0.20 ± 6.9% | not timed | not timed | 3.19 ± 25.3% | | 1.00 | 0.77 | 15.88 |
| 06-cloud-flare-redos/original | 107 | 201.19 ± 1.1% | not timed | not timed | 177.56 ± 0.4% | 19.16 ± 0.7% | not timed | not timed | 201.28 ± 0.4% | | 1.00 | 1.13 | 10.50 |
| 06-cloud-flare-redos/simplified-short | 102 | 198.67 ± 0.3% | not timed | not timed | 183.09 ± 0.7% | 20.84 ± 0.8% | not timed | not timed | 198.48 ± 1.1% | | 1.00 | 1.09 | 9.53 |
| 06-cloud-flare-redos/simplified-long | 10000 | 217.67 ± 0.7% | not timed | not timed | 200.47 ± 0.7% | 22.97 ± 0.4% | not timed | not timed | 217.55 ± 0.2% | | 1.00 | 1.09 | 9.48 |
| 07-unicode-character-data/parse-line | 558784 | 189.70 ± 0.3% | not timed | not timed | 156.30 ± 1.1% | 36.45 ± 5.5% | not timed | not timed | 190.29 ± 2.0% | | 1.00 | 1.21 | 5.20 |
| 08-words/all-english | 56691 | 86.72 ± 1.0% | not timed | not timed | 65.75 ± 0.4% | 10.33 ± 3.0% | not timed | not timed | 85.98 ± 1.1% | | 1.01 | 1.32 | 8.40 |
| 08-words/long-english | 839 | 766.48 ± 0.1% | not timed | not timed | 453.64 ± 0.3% | 27.33 ± 2.3% | not timed | not timed | 764.74 ± 0.9% | | 1.00 | 1.69 | 28.05 |
| 09-aws-keys/full | 0 | 403.48 ± 0.3% | not timed | not timed | 417.57 ± 1.8% | 44.80 ± 2.3% | not timed | not timed | 403.26 ± 0.2% | | 1.00 | 0.97 | 9.01 |
| 09-aws-keys/quick | 0 | 664.70 ± 0.0% | not timed | not timed | 734.26 ± 1.0% | 317.27 ± 0.2% | not timed | not timed | 750.29 ± 0.6% | | 0.89 | 0.91 | 2.10 |
| 10-bounded-repeat/letters-en | 1833 | 509.73 ± 1.3% | not timed | not timed | 431.09 ± 1.0% | 17.42 ± 1.1% | not timed | not timed | 509.63 ± 1.6% | | 1.00 | 1.18 | 29.26 |
| 10-bounded-repeat/letters-ru | 3475 | 281.94 ± 2.1% | not timed | not timed | 371.89 ± 2.4% | 20.36 ± 16.4% | not timed | not timed | 281.86 ± 2.0% | | 1.00 | 0.76 | 13.85 |
| 10-bounded-repeat/context | 53 | 63.73 ± 12.0% | not timed | not timed | 54.85 ± 1.4% | 17.57 ± 3.8% | not timed | not timed | 63.88 ± 1.0% | | 1.00 | 1.16 | 3.63 |
| 10-bounded-repeat/capitals | 11 | 801.32 ± 0.4% | not timed | not timed | 468.80 ± 0.1% | 31.10 ± 1.3% | not timed | not timed | 799.63 ± 0.9% | | 1.00 | 1.71 | 25.76 |
| 11-unstructured-to-json/extract | 600 | 35.68 ± 0.2% | not timed | not timed | 57.47 ± 13.1% | 38.64 ± 2.5% | not timed | not timed | 35.90 ± 9.7% | | 0.99 | 0.62 | 0.92 |
| 12-dictionary/single | 1 | 394.81 ± 0.2% | not timed | not timed | 372.95 ± 0.1% | 0.30 ± 4.8% | not timed | not timed | 396.86 ± 0.2% | | 0.99 | 1.06 | 1298.20 |
| 14-quadratic/1x | 100 | 9.95 ± 0.9% | not timed | not timed | 9.44 ± 0.6% | 0.78 ± 1.1% | not timed | not timed | 9.96 ± 0.3% | | 1.00 | 1.05 | 12.69 |
| 14-quadratic/2x | 200 | 6.06 ± 0.1% | not timed | not timed | 4.74 ± 0.3% | 0.42 ± 1.2% | not timed | not timed | 6.04 ± 1.4% | | 1.00 | 1.28 | 14.31 |
| 14-quadratic/10x | 1000 | 1.41 ± 0.8% | not timed | not timed | 0.94 ± 1.1% | 0.09 ± 1.6% | not timed | not timed | 1.41 ± 0.3% | | 1.00 | 1.50 | 15.32 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.31 ± 0.3% | not timed | not timed | 0.37 ± 0.7% | 0.49 ± 6.1% | not timed | not timed | 1.30 ± 1.6% | | 1.00 | 3.53 | 2.66 |
| 04-ruff-noqa/compile-real | 1 | 77.57 ± 0.5% | not timed | not timed | 13.29 ± 1.7% | 126.12 ± 6.6% | not timed | not timed | 76.40 ± 1.4% | | 1.02 | 5.84 | 0.62 |
| 05-lexer-veryl/compile-single | 1 | 13.14 ± 0.7% | not timed | not timed | 2.31 ± 0.9% | 6.00 ± 18.2% | not timed | not timed | 12.99 ± 2.6% | | 1.01 | 5.70 | 2.19 |
| 07-unicode-character-data/compile | 1 | 48.70 ± 2.1% | not timed | not timed | 23.48 ± 0.6% | 33.78 ± 2.2% | not timed | not timed | 49.07 ± 2.0% | | 0.99 | 2.07 | 1.44 |
| 09-aws-keys/compile-full | 1 | 34.57 ± 15.9% | not timed | not timed | 7.68 ± 4.0% | 21.09 ± 7.1% | not timed | not timed | 34.34 ± 1.2% | | 1.01 | 4.50 | 1.64 |
| 09-aws-keys/compile-quick | 1 | 154.80 ± 17.3% | not timed | not timed | 44.76 ± 0.2% | 121.02 ± 3.8% | not timed | not timed | 154.44 ± 1.3% | | 1.00 | 3.46 | 1.28 |
| 10-bounded-repeat/compile-context | 1 | 12.28 ± 0.5% | not timed | not timed | 11.26 ± 1.0% | 15.63 ± 14.6% | not timed | not timed | 12.20 ± 4.4% | | 1.01 | 1.09 | 0.79 |
| 10-bounded-repeat/compile-capitals | 1 | 69.12 ± 0.7% | not timed | not timed | 8.03 ± 1.4% | 22.33 ± 3.9% | not timed | not timed | 72.05 ± 1.1% | | 0.96 | 8.61 | 3.10 |
| 11-unstructured-to-json/compile | 1 | 75.57 ± 0.5% | not timed | not timed | 36.87 ± 16.8% | 61.94 ± 4.3% | not timed | not timed | 75.88 ± 1.1% | | 1.00 | 2.05 | 1.22 |
| 12-dictionary/compile-single | 1 | 0.27 ± 1.1% | not timed | not timed | 0.07 ± 10.1% | 0.08 ± 13.2% | not timed | not timed | 0.27 ± 2.5% | | 1.01 | 4.16 | 3.27 |

