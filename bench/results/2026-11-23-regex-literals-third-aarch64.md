# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243465473 |
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
| literal: a word | 217 | 19706.10 ± 1.4% | 5000.40 ± 0.2% | 28.28 ± 0.3% | 18367.59 ± 2.1% | 9266.16 ± 6.0% | 17.31 ± 0.3% | 84.28 ± 0.4% | 19759.30 ± 1.1% | 3.94 | 1.00 | 1.07 | 2.13 |
| literal: a word that is not there | 0 | 21644.82 ± 2.1% | 4875.77 ± 0.5% | 28.41 ± 0.5% | 19801.83 ± 2.0% | 29296.04 ± 0.6% | 17.12 ± 0.2% | 79.50 ± 0.3% | 21843.97 ± 0.5% | 4.44 | 0.99 | 1.09 | 0.74 |
| literal: one of four words | 661 | 6389.99 ± 0.6% | 1931.07 ± 0.2% | 14.45 ± 0.2% | 3945.26 ± 0.2% | 21.92 ± 0.1% | 5.36 ± 0.3% | 6.88 ± 0.5% | 6365.39 ± 0.2% | 3.31 | 1.00 | 1.62 | 291.53 |
| literal: a word in any case | 217 | 15196.03 ± 0.1% | 2076.04 ± 0.2% | 21.46 ± 0.4% | 3973.54 ± 0.2% | 38.03 ± 0.5% | refused | differs | 15170.08 ± 0.5% | 7.32 | 1.00 | 3.82 | 399.54 |
| literal: an href attribute | 33 | 16823.83 ± 1.4% | 610.16 ± 0.2% | 27.33 ± 0.4% | 17032.72 ± 1.6% | 2257.03 ± 0.4% | 13.12 ± 0.3% | 73.79 ± 0.3% | 16756.46 ± 0.7% | 27.57 | 1.00 | 0.99 | 7.45 |
| literal: a word, second text | 123 | 19857.03 ± 2.4% | 3354.05 ± 0.2% | 28.01 ± 0.3% | 18502.23 ± 1.2% | 7659.57 ± 1.1% | 20.14 ± 0.5% | 69.94 ± 0.2% | 20014.60 ± 2.0% | 5.92 | 0.99 | 1.07 | 2.59 |
| class: two capitalized words | 1331 | 1057.48 ± 0.4% | 600.20 ± 0.3% | 25.99 ± 0.3% | 585.35 ± 0.1% | 40.58 ± 2.9% | 14.74 ± 0.3% | 67.25 ± 0.2% | 1057.58 ± 0.2% | 1.76 | 1.00 | 1.81 | 26.06 |
| class: a word that ends in ing | 3399 | 573.76 ± 0.2% | 573.04 ± 0.3% | 17.99 ± 0.4% | 547.57 ± 0.1% | 29.61 ± 2.7% | 8.16 ± 0.2% | 18.22 ± 0.5% | 572.66 ± 0.1% | 1.00 | 1.00 | 1.05 | 19.38 |
| class: a word in capitals | 2332 | 1368.15 ± 0.3% | 603.28 ± 0.1% | 27.66 ± 0.6% | 572.53 ± 0.1% | 43.47 ± 13.1% | 17.22 ± 0.3% | 82.57 ± 0.2% | 1364.01 ± 0.1% | 2.27 | 1.00 | 2.39 | 31.47 |
| class: a number | 8288 | 1957.54 ± 0.3% | 827.00 ± 0.1% | 27.78 ± 0.5% | 1713.59 ± 0.1% | 41.44 ± 16.3% | 0.55 ± 0.1% | 57.35 ± 0.4% | 1953.17 ± 0.4% | 2.37 | 1.00 | 1.14 | 47.24 |
| class: two capitalized words, second text | 5359 | 516.32 ± 0.2% | 523.93 ± 0.2% | 23.33 ± 0.1% | 485.34 ± 0.1% | 34.31 ± 14.9% | 17.11 ± 0.3% | 62.61 ± 0.5% | 516.01 ± 0.3% | 0.99 | 1.00 | 1.06 | 15.05 |
| other: a word between two words | 6104 | 792.14 ± 0.3% | 594.28 ± 0.2% | 23.54 ± 0.2% | 739.22 ± 0.1% | 101.93 ± 18.7% | 11.18 ± 0.2% | 68.07 ± 0.2% | 791.69 ± 0.1% | 1.33 | 1.00 | 1.07 | 7.77 |
| other: a number before a unit, second text | 1481 | 5983.66 ± 1.4% | 1119.77 ± 0.1% | 26.06 ± 0.2% | 5679.51 ± 0.8% | 40.80 ± 15.3% | 18.18 ± 0.2% | 65.52 ± 0.9% | 5955.52 ± 0.4% | 5.34 | 1.00 | 1.05 | 146.66 |
| other: a heading's start tag | 110 | 14082.98 ± 1.2% | 742.91 ± 0.2% | 27.41 ± 0.3% | 1709.55 ± 0.2% | 1582.52 ± 0.6% | 16.03 ± 0.3% | 86.16 ± 0.6% | 14091.40 ± 1.2% | 18.96 | 1.00 | 8.24 | 8.90 |
| other: a whole word | 217 | 15903.82 ± 0.8% | 602.62 ± 0.2% | 29.19 ± 0.3% | 14511.46 ± 1.4% | 49.36 ± 0.3% | 13.21 ± 0.1% | 54.92 ± 0.6% | 15875.43 ± 1.1% | 26.39 | 1.00 | 1.10 | 322.18 |
| other: a line's first word, second text | 3716 | 2048.04 ± 0.6% | 583.89 ± 0.2% | 30.91 ± 0.4% | 1725.16 ± 0.4% | 61.64 ± 8.2% | refused | refused | 2046.24 ± 0.3% | 3.51 | 1.00 | 1.19 | 33.22 |
| other: fourteen octets before an x | 87 | 24079.12 ± 1.8% | 239.04 ± 0.3% | 6.55 ± 0.2% | 4053.29 ± 0.2% | 10.64 ± 0.2% | differs | 17.68 ± 0.1% | 24047.26 ± 1.6% | 100.73 | 1.00 | 5.94 | 2262.32 |
| other: a Greek word | 21815 | 488.96 ± 0.9% | 408.03 ± 0.2% | 30.87 ± 0.3% | 289.54 ± 0.3% | 43.57 ± 10.3% | differs | refused | 484.19 ± 0.8% | 1.20 | 1.01 | 1.69 | 11.22 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.45 ± 0.1% | 18.51 ± 0.2% | 0.86 ± 0.3% | 19.66 ± 0.3% | 2.77 ± 0.6% | differs | 4.00 ± 0.1% | 18.52 ± 0.2% | 1.00 | 1.00 | 0.94 | 6.67 |
| a UUID | 32895 | 20.05 ± 0.3% | 20.08 ± 0.1% | 0.64 ± 0.1% | 15.19 ± 0.7% | 3.08 ± 0.6% | 0.74 ± 0.2% | 3.63 ± 0.4% | 20.09 ± 0.2% | 1.00 | 1.00 | 1.32 | 6.51 |
| an IPv4 address | 33176 | 33.64 ± 0.2% | 33.67 ± 0.2% | 2.08 ± 0.7% | 29.26 ± 0.3% | 6.62 ± 0.3% | differs | 4.15 ± 0.1% | 33.65 ± 0.2% | 1.00 | 1.00 | 1.15 | 5.08 |
| a date and time | 32954 | 28.86 ± 0.3% | 28.92 ± 0.7% | 1.45 ± 0.1% | 21.60 ± 0.5% | 7.04 ± 0.3% | 1.25 ± 0.2% | 7.19 ± 0.2% | 28.92 ± 0.2% | 1.00 | 1.00 | 1.34 | 4.10 |
| a field path | 32606 | 21.78 ± 0.3% | 21.80 ± 0.2% | 1.02 ± 0.1% | 23.21 ± 0.3% | 3.48 ± 0.5% | differs | 2.94 ± 0.1% | 21.78 ± 0.2% | 1.00 | 1.00 | 0.94 | 6.26 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.10 ± 0.3% | 11.10 ± 0.3% | 11.12 ± 0.3% | 11.41 ± 0.2% | 4.95 ± 1.2% | 0.94 ± 0.7% | none | 11.09 ± 0.2% | 1.00 | 1.00 | 0.97 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 229.75 ± 0.2% | 230.46 ± 0.2% | 270.14 ± 0.2% | 87.25 ± 0.3% | 219.23 ± 1.5% | 473.71 ± 0.5% | 3824.94 ± 2.7% | 229.55 ± 0.4% | 1.00 | 1.00 | 2.63 | 1.05 |
| a UUID | 62 | 148.13 ± 0.3% | 148.61 ± 0.1% | 164.73 ± 0.1% | 46.02 ± 0.7% | 99.08 ± 0.8% | 191.52 ± 2.9% | 4290.94 ± 0.4% | 148.26 ± 0.2% | 1.00 | 1.00 | 3.22 | 1.50 |
| an IPv4 address | 29 | 426.62 ± 0.5% | 430.52 ± 0.3% | 592.27 ± 0.3% | 77.19 ± 0.5% | 131.28 ± 1.4% | 304.67 ± 1.3% | 7619.62 ± 0.4% | 426.37 ± 0.1% | 0.99 | 1.00 | 5.53 | 3.25 |
| a date and time | 56 | 306.47 ± 0.2% | 308.04 ± 0.4% | 382.56 ± 0.3% | 72.36 ± 0.7% | 137.29 ± 1.4% | 334.10 ± 0.8% | 4940.06 ± 0.8% | 306.34 ± 0.1% | 0.99 | 1.00 | 4.24 | 2.23 |
| a field path | 39 | 221.80 ± 0.3% | 222.69 ± 0.4% | 259.15 ± 0.3% | 79.73 ± 1.6% | 203.27 ± 1.8% | 504.66 ± 3.5% | 4869.05 ± 0.7% | 221.72 ± 0.3% | 1.00 | 1.00 | 2.78 | 1.09 |
| literal: a word | 7 | 644.45 ± 0.9% | 696.78 ± 0.7% | 1238.99 ± 0.3% | 494.99 ± 0.1% | 630.62 ± 0.8% | 959.72 ± 0.5% | 30753.08 ± 0.2% | 643.14 ± 0.7% | 0.92 | 1.00 | 1.30 | 1.02 |
| literal: a word that is not there | 8 | 617.20 ± 0.2% | 673.47 ± 0.4% | 1166.57 ± 0.1% | 456.35 ± 0.3% | 601.81 ± 1.6% | 906.66 ± 0.4% | 29610.98 ± 0.2% | 616.86 ± 0.1% | 0.92 | 1.00 | 1.35 | 1.03 |
| literal: one of four words | 26 | 248.90 ± 0.6% | 404.03 ± 0.5% | 542.00 ± 0.2% | 50.40 ± 0.7% | 240.08 ± 7.9% | 370.51 ± 0.3% | 16097.82 ± 0.1% | 249.12 ± 0.5% | 0.62 | 1.00 | 4.94 | 1.04 |
| literal: a word in any case | 11 | 449.46 ± 0.2% | 482.51 ± 0.5% | 696.17 ± 0.6% | 15.64 ± 0.1% | 664.68 ± 3.9% | refused | 23859.29 ± 0.3% | 449.21 ± 0.6% | 0.93 | 1.00 | 28.73 | 0.68 |
| literal: an href attribute | 12 | 350.38 ± 0.1% | 364.91 ± 0.1% | 474.66 ± 0.3% | 45.37 ± 0.8% | 500.43 ± 1.5% | 779.03 ± 0.4% | 22192.69 ± 0.3% | 350.41 ± 0.4% | 0.96 | 1.00 | 7.72 | 0.70 |
| literal: a word, second text | 10 | 575.75 ± 0.8% | 635.89 ± 0.5% | 1056.78 ± 0.1% | 405.17 ± 0.8% | 534.17 ± 1.8% | 807.43 ± 0.4% | 27619.08 ± 0.3% | 575.17 ± 0.2% | 0.91 | 1.00 | 1.42 | 1.08 |
| class: two capitalized words | 23 | 443.82 ± 0.5% | 472.94 ± 0.4% | 679.80 ± 0.5% | 102.63 ± 0.3% | 504.94 ± 1.2% | 743.98 ± 1.1% | 6488.84 ± 0.6% | 443.10 ± 0.6% | 0.94 | 1.00 | 4.32 | 0.88 |
| class: a word that ends in ing | 9 | 576.46 ± 0.4% | 645.40 ± 0.5% | 1119.95 ± 0.2% | 131.94 ± 0.4% | 761.43 ± 0.6% | 1110.94 ± 0.9% | 16088.49 ± 0.1% | 576.68 ± 0.1% | 0.89 | 1.00 | 4.37 | 0.76 |
| class: a word in capitals | 16 | 506.32 ± 0.4% | 544.90 ± 0.3% | 863.54 ± 0.3% | 134.85 ± 0.4% | 746.66 ± 2.9% | 1045.34 ± 0.7% | 8568.58 ± 0.1% | 506.09 ± 0.4% | 0.93 | 1.00 | 3.75 | 0.68 |
| class: a number | 6 | 644.26 ± 0.1% | 708.60 ± 0.6% | 1317.15 ± 0.1% | 41.82 ± 0.5% | 1401.19 ± 1.9% | 1838.39 ± 1.2% | 23104.20 ± 0.1% | 644.31 ± 0.3% | 0.91 | 1.00 | 15.40 | 0.46 |
| class: two capitalized words, second text | 23 | 444.70 ± 0.5% | 474.45 ± 0.3% | 679.37 ± 0.1% | 99.67 ± 0.1% | 502.34 ± 9.1% | 739.92 ± 3.0% | 6498.72 ± 0.9% | 444.29 ± 0.1% | 0.94 | 1.00 | 4.46 | 0.89 |
| other: a word between two words | 13 | 556.31 ± 0.2% | 579.12 ± 0.2% | 915.74 ± 0.3% | 132.72 ± 0.7% | 500.84 ± 1.1% | 809.97 ± 1.1% | 14862.37 ± 0.1% | 554.82 ± 0.3% | 0.96 | 1.00 | 4.19 | 1.11 |
| other: a number before a unit, second text | 15 | 400.32 ± 0.3% | 437.73 ± 0.5% | 608.92 ± 0.7% | 39.50 ± 0.8% | 627.28 ± 1.5% | 894.26 ± 0.4% | 15325.40 ± 0.3% | 400.73 ± 0.5% | 0.91 | 1.00 | 10.13 | 0.64 |
| other: a heading's start tag | 13 | 360.42 ± 0.3% | 367.97 ± 0.2% | 481.59 ± 0.5% | 44.06 ± 0.2% | 622.19 ± 2.1% | 872.56 ± 0.7% | 18434.59 ± 0.2% | 360.26 ± 0.2% | 0.98 | 1.00 | 8.18 | 0.58 |
| other: a whole word | 11 | 585.46 ± 0.8% | 626.60 ± 0.6% | 1040.99 ± 0.4% | 119.36 ± 0.7% | 561.35 ± 3.8% | 823.55 ± 0.6% | 27294.61 ± 0.5% | 586.06 ± 0.5% | 0.93 | 1.00 | 4.90 | 1.04 |
| other: a line's first word, second text | 17 | 535.46 ± 0.5% | 562.16 ± 0.3% | 888.05 ± 0.5% | 129.45 ± 0.1% | 708.69 ± 0.9% | refused | refused | 534.71 ± 0.7% | 0.95 | 1.00 | 4.14 | 0.76 |
| other: fourteen octets before an x | 16 | 107.88 ± 0.7% | 154.48 ± 0.6% | 175.04 ± 0.7% | 15.12 ± 0.4% | 454.64 ± 1.6% | 410.47 ± 0.7% | 12984.45 ± 1.3% | 108.11 ± 0.6% | 0.70 | 1.00 | 7.14 | 0.24 |
| other: a Greek word | 8 | 462.03 ± 0.3% | 616.24 ± 0.6% | 1039.39 ± 0.7% | 59.08 ± 0.3% | 1386.19 ± 1.0% | 1819.68 ± 0.3% | refused | 462.26 ± 0.3% | 0.75 | 1.00 | 7.82 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15703.20 ± 1.5% | not timed | not timed | 16283.91 ± 1.5% | 1993.24 ± 19.1% | not timed | not timed | 15756.22 ± 1.2% | | 1.00 | 0.96 | 7.88 |
| 01-literal/sherlock-casei-en | 522 | 5155.35 ± 1.1% | not timed | not timed | 3594.78 ± 0.1% | 32.58 ± 0.3% | not timed | not timed | 5161.45 ± 0.7% | | 1.00 | 1.43 | 158.24 |
| 01-literal/sherlock-ru | 724 | 17099.59 ± 0.8% | not timed | not timed | 17343.93 ± 0.3% | 1487.35 ± 15.2% | not timed | not timed | 17067.95 ± 0.2% | | 1.00 | 0.99 | 11.50 |
| 01-literal/sherlock-casei-ru | 746 | 6183.90 ± 0.2% | not timed | not timed | 3331.65 ± 0.1% | 30.77 ± 0.1% | not timed | not timed | 6176.91 ± 0.1% | | 1.00 | 1.86 | 200.96 |
| 01-literal/sherlock-zh | 30 | 19968.17 ± 0.5% | not timed | not timed | 18789.05 ± 0.5% | 2751.18 ± 4.4% | not timed | not timed | 19971.41 ± 0.6% | | 1.00 | 1.06 | 7.26 |
| 02-literal-alternate/sherlock-en | 714 | 6044.90 ± 0.1% | not timed | not timed | 3942.20 ± 0.1% | 16.64 ± 0.5% | not timed | not timed | 6051.59 ± 0.3% | | 1.00 | 1.53 | 363.33 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1938.21 ± 1.5% | not timed | not timed | 696.29 ± 0.2% | 11.11 ± 7.3% | not timed | not timed | 1929.76 ± 1.3% | | 1.00 | 2.78 | 174.40 |
| 02-literal-alternate/sherlock-ru | 899 | 5575.90 ± 0.1% | not timed | not timed | 3253.61 ± 0.3% | 22.63 ± 0.1% | not timed | not timed | 5570.98 ± 0.2% | | 1.00 | 1.71 | 246.42 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2060.66 ± 0.6% | not timed | not timed | 1229.55 ± 0.2% | 9.07 ± 0.2% | not timed | not timed | 2054.53 ± 0.3% | | 1.00 | 1.68 | 227.32 |
| 02-literal-alternate/sherlock-zh | 207 | 7293.27 ± 0.4% | not timed | not timed | 4165.35 ± 0.1% | 31.54 ± 0.0% | not timed | not timed | 7296.67 ± 0.4% | | 1.00 | 1.75 | 231.23 |
| 03-date/ascii | 111817 | 123.69 ± 0.3% | not timed | not timed | 96.50 ± 0.1% | 0.20 ± 4.9% | not timed | not timed | 122.82 ± 0.5% | | 1.01 | 1.28 | 610.50 |
| 04-ruff-noqa/real | 84 | 402.18 ± 0.0% | not timed | not timed | 473.96 ± 0.1% | 19.54 ± 1.2% | not timed | not timed | 401.93 ± 0.1% | | 1.00 | 0.85 | 20.58 |
| 04-ruff-noqa/tweaked | 44 | 559.41 ± 0.1% | not timed | not timed | 461.59 ± 0.1% | 367.47 ± 0.2% | not timed | not timed | 560.74 ± 0.2% | | 1.00 | 1.21 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.34 ± 0.2% | not timed | not timed | 5.25 ± 0.4% | 0.21 ± 2.0% | not timed | not timed | 5.33 ± 0.4% | | 1.00 | 1.02 | 25.99 |
| 06-cloud-flare-redos/original | 107 | 415.40 ± 0.2% | not timed | not timed | 215.82 ± 0.0% | 24.93 ± 0.2% | not timed | not timed | 414.81 ± 0.2% | | 1.00 | 1.92 | 16.66 |
| 06-cloud-flare-redos/simplified-short | 102 | 411.42 ± 0.1% | not timed | not timed | 227.70 ± 0.3% | 26.78 ± 0.3% | not timed | not timed | 412.18 ± 0.2% | | 1.00 | 1.81 | 15.37 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.79 ± 0.2% | not timed | not timed | 253.58 ± 0.1% | 28.83 ± 0.1% | not timed | not timed | 583.44 ± 0.1% | | 1.00 | 2.30 | 20.25 |
| 07-unicode-character-data/parse-line | 558784 | 231.99 ± 0.3% | not timed | not timed | 179.86 ± 1.6% | 43.19 ± 5.5% | not timed | not timed | 231.58 ± 0.5% | | 1.00 | 1.29 | 5.37 |
| 08-words/all-english | 56691 | 116.38 ± 0.3% | not timed | not timed | 83.36 ± 0.1% | 12.12 ± 10.3% | not timed | not timed | 116.27 ± 0.2% | | 1.00 | 1.40 | 9.60 |
| 08-words/long-english | 839 | 613.80 ± 0.3% | not timed | not timed | 594.03 ± 0.2% | 32.64 ± 0.3% | not timed | not timed | 614.93 ± 0.2% | | 1.00 | 1.03 | 18.80 |
| 09-aws-keys/full | 0 | 408.12 ± 0.2% | not timed | not timed | 474.70 ± 0.0% | 64.62 ± 0.1% | not timed | not timed | 408.03 ± 0.2% | | 1.00 | 0.86 | 6.32 |
| 09-aws-keys/quick | 0 | 949.10 ± 0.1% | not timed | not timed | 1004.59 ± 0.3% | 420.39 ± 0.5% | not timed | not timed | 947.39 ± 0.2% | | 1.00 | 0.94 | 2.26 |
| 10-bounded-repeat/letters-en | 1833 | 582.14 ± 1.1% | not timed | not timed | 518.23 ± 0.2% | 19.63 ± 0.2% | not timed | not timed | 579.81 ± 0.9% | | 1.00 | 1.12 | 29.66 |
| 10-bounded-repeat/letters-ru | 3475 | 508.76 ± 1.4% | not timed | not timed | 478.54 ± 0.1% | 21.82 ± 8.3% | not timed | not timed | 505.85 ± 1.5% | | 1.01 | 1.06 | 23.32 |
| 10-bounded-repeat/context | 53 | 77.47 ± 0.5% | not timed | not timed | 66.24 ± 0.7% | 19.85 ± 0.2% | not timed | not timed | 77.19 ± 0.4% | | 1.00 | 1.17 | 3.90 |
| 10-bounded-repeat/capitals | 11 | 635.32 ± 8.2% | not timed | not timed | 618.14 ± 0.1% | 34.80 ± 0.0% | not timed | not timed | 635.60 ± 8.4% | | 1.00 | 1.03 | 18.26 |
| 11-unstructured-to-json/extract | 600 | 79.59 ± 0.3% | not timed | not timed | 76.03 ± 0.2% | 49.07 ± 0.2% | not timed | not timed | 82.47 ± 0.2% | | 0.97 | 1.05 | 1.62 |
| 12-dictionary/single | 1 | 560.11 ± 0.3% | not timed | not timed | 561.03 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 559.53 ± 0.2% | | 1.00 | 1.00 | 1379.19 |
| 14-quadratic/1x | 100 | 21.12 ± 1.4% | not timed | not timed | 10.05 ± 0.2% | 0.96 ± 3.4% | not timed | not timed | 21.21 ± 1.6% | | 1.00 | 2.10 | 21.98 |
| 14-quadratic/2x | 200 | 17.38 ± 0.7% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 1.6% | not timed | not timed | 17.55 ± 0.4% | | 0.99 | 3.13 | 32.74 |
| 14-quadratic/10x | 1000 | 7.63 ± 0.3% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 1.7% | not timed | not timed | 7.68 ± 0.5% | | 0.99 | 6.28 | 65.98 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.28 ± 0.3% | not timed | not timed | 0.35 ± 0.3% | 0.55 ± 2.9% | not timed | not timed | 1.28 ± 0.6% | | 1.00 | 3.70 | 2.31 |
| 04-ruff-noqa/compile-real | 1 | 90.52 ± 0.1% | not timed | not timed | 13.78 ± 0.2% | 139.69 ± 2.7% | not timed | not timed | 90.31 ± 0.8% | | 1.00 | 6.57 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 13.94 ± 1.8% | not timed | not timed | 2.53 ± 0.8% | 6.50 ± 13.3% | not timed | not timed | 13.87 ± 1.2% | | 1.01 | 5.51 | 2.15 |
| 07-unicode-character-data/compile | 1 | 55.50 ± 0.2% | not timed | not timed | 25.91 ± 0.3% | 36.97 ± 3.2% | not timed | not timed | 55.11 ± 1.3% | | 1.01 | 2.14 | 1.50 |
| 09-aws-keys/compile-full | 1 | 41.78 ± 2.7% | not timed | not timed | 8.31 ± 0.2% | 23.56 ± 0.4% | not timed | not timed | 41.72 ± 0.5% | | 1.00 | 5.03 | 1.77 |
| 09-aws-keys/compile-quick | 1 | 186.95 ± 0.2% | not timed | not timed | 47.55 ± 0.5% | 135.84 ± 1.8% | not timed | not timed | 186.27 ± 1.1% | | 1.00 | 3.93 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 13.64 ± 1.2% | not timed | not timed | 11.03 ± 0.1% | 16.42 ± 2.0% | not timed | not timed | 13.66 ± 1.3% | | 1.00 | 1.24 | 0.83 |
| 10-bounded-repeat/compile-capitals | 1 | 82.64 ± 2.8% | not timed | not timed | 8.06 ± 0.2% | 24.24 ± 1.0% | not timed | not timed | 82.44 ± 2.9% | | 1.00 | 10.26 | 3.41 |
| 11-unstructured-to-json/compile | 1 | 86.68 ± 0.2% | not timed | not timed | 41.14 ± 1.2% | 68.95 ± 1.9% | not timed | not timed | 86.18 ± 1.0% | | 1.01 | 2.11 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.6% | not timed | not timed | 0.07 ± 1.2% | 0.10 ± 7.2% | not timed | not timed | 0.35 ± 1.1% | | 1.00 | 5.04 | 3.62 |

