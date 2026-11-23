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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243511213 |
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
| literal: a word | 217 | 19301.63 ± 1.4% | 4994.40 ± 0.2% | 27.75 ± 0.2% | 18227.85 ± 2.1% | 9288.11 ± 5.6% | 17.60 ± 0.4% | 84.15 ± 0.5% | 19354.66 ± 1.6% | 3.86 | 1.00 | 1.06 | 2.08 |
| literal: a word that is not there | 0 | 21121.26 ± 1.4% | 4874.19 ± 0.3% | 27.81 ± 0.2% | 19528.90 ± 2.0% | 27599.09 ± 2.4% | 17.40 ± 0.3% | 79.78 ± 0.5% | 21429.69 ± 1.3% | 4.33 | 0.99 | 1.08 | 0.77 |
| literal: one of four words | 661 | 6383.46 ± 0.4% | 1932.40 ± 0.2% | 14.25 ± 0.0% | 3949.70 ± 0.2% | 21.87 ± 0.2% | 5.31 ± 0.0% | 6.84 ± 0.9% | 6361.18 ± 0.3% | 3.30 | 1.00 | 1.62 | 291.82 |
| literal: a word in any case | 217 | 15162.35 ± 0.9% | 2076.41 ± 0.3% | 21.13 ± 0.1% | 3970.35 ± 0.3% | 38.12 ± 4.2% | refused | differs | 15128.77 ± 0.4% | 7.30 | 1.00 | 3.82 | 397.74 |
| literal: an href attribute | 33 | 16887.55 ± 0.3% | 608.81 ± 0.5% | 26.65 ± 0.3% | 17115.76 ± 1.8% | 2259.59 ± 0.4% | 13.44 ± 0.3% | 74.00 ± 0.8% | 16833.73 ± 1.6% | 27.74 | 1.00 | 0.99 | 7.47 |
| literal: a word, second text | 123 | 19871.51 ± 1.7% | 3359.58 ± 0.4% | 27.39 ± 0.2% | 18473.17 ± 1.9% | 7618.08 ± 6.0% | 19.77 ± 0.5% | 70.25 ± 0.4% | 19905.09 ± 1.4% | 5.91 | 1.00 | 1.08 | 2.61 |
| class: two capitalized words | 1331 | 1056.88 ± 0.4% | 599.06 ± 0.3% | 25.44 ± 0.3% | 585.39 ± 0.1% | 40.50 ± 0.1% | 15.01 ± 0.2% | 67.23 ± 0.4% | 1056.91 ± 0.2% | 1.76 | 1.00 | 1.81 | 26.09 |
| class: a word that ends in ing | 3399 | 572.08 ± 0.3% | 573.30 ± 0.4% | 17.73 ± 0.2% | 547.74 ± 0.3% | 28.98 ± 1.9% | 8.24 ± 0.2% | 18.24 ± 1.2% | 572.60 ± 0.5% | 1.00 | 1.00 | 1.04 | 19.74 |
| class: a word in capitals | 2332 | 1369.89 ± 0.3% | 603.58 ± 0.3% | 26.98 ± 0.1% | 572.64 ± 0.1% | 43.55 ± 16.9% | 17.30 ± 0.4% | 82.67 ± 0.6% | 1370.80 ± 0.4% | 2.27 | 1.00 | 2.39 | 31.46 |
| class: a number | 8288 | 1956.77 ± 0.3% | 827.39 ± 0.1% | 27.24 ± 0.1% | 1713.73 ± 0.1% | 42.81 ± 16.6% | 0.57 ± 0.1% | 57.61 ± 0.6% | 1957.45 ± 0.3% | 2.36 | 1.00 | 1.14 | 45.71 |
| class: two capitalized words, second text | 5359 | 515.61 ± 0.2% | 523.53 ± 0.6% | 22.81 ± 0.1% | 485.13 ± 0.2% | 35.38 ± 6.2% | 16.73 ± 0.3% | 62.63 ± 0.2% | 515.80 ± 0.2% | 0.98 | 1.00 | 1.06 | 14.57 |
| other: a word between two words | 6104 | 796.82 ± 0.2% | 594.23 ± 0.2% | 23.07 ± 0.4% | 736.92 ± 0.1% | 109.33 ± 15.8% | 11.35 ± 0.3% | 68.28 ± 1.5% | 796.63 ± 0.1% | 1.34 | 1.00 | 1.08 | 7.29 |
| other: a number before a unit, second text | 1481 | 5974.80 ± 1.0% | 1123.19 ± 0.4% | 25.49 ± 0.3% | 5691.41 ± 0.3% | 40.71 ± 0.6% | 17.88 ± 0.2% | 65.69 ± 0.7% | 5912.95 ± 0.4% | 5.32 | 1.01 | 1.05 | 146.77 |
| other: a heading's start tag | 110 | 14209.70 ± 1.1% | 742.62 ± 0.2% | 26.84 ± 0.2% | 1714.84 ± 0.2% | 1584.33 ± 7.1% | 16.38 ± 0.2% | 86.28 ± 0.3% | 14182.28 ± 1.4% | 19.13 | 1.00 | 8.29 | 8.97 |
| other: a whole word | 217 | 15839.85 ± 1.2% | 601.93 ± 1.0% | 28.65 ± 0.4% | 14423.35 ± 1.3% | 49.46 ± 0.2% | 13.86 ± 0.5% | 54.22 ± 3.0% | 15839.63 ± 1.0% | 26.32 | 1.00 | 1.10 | 320.23 |
| other: a line's first word, second text | 3716 | 2040.85 ± 0.4% | 587.75 ± 0.2% | 29.95 ± 0.2% | 1729.76 ± 0.4% | 62.45 ± 8.5% | refused | refused | 2037.88 ± 0.2% | 3.47 | 1.00 | 1.18 | 32.68 |
| other: fourteen octets before an x | 87 | 24091.78 ± 2.9% | 252.93 ± 1.7% | 6.51 ± 0.1% | 3973.09 ± 0.6% | 10.65 ± 0.2% | differs | 17.70 ± 0.3% | 23998.96 ± 1.4% | 95.25 | 1.00 | 6.06 | 2261.64 |
| other: a Greek word | 21815 | 487.06 ± 0.5% | 409.19 ± 0.5% | 30.43 ± 0.6% | 289.19 ± 0.6% | 49.01 ± 9.5% | differs | refused | 485.62 ± 0.5% | 1.19 | 1.00 | 1.68 | 9.94 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.46 ± 0.4% | 18.49 ± 0.3% | 0.85 ± 0.2% | 19.54 ± 0.6% | 2.75 ± 0.2% | differs | 3.99 ± 0.1% | 18.52 ± 0.2% | 1.00 | 1.00 | 0.94 | 6.71 |
| a UUID | 32895 | 20.11 ± 0.3% | 20.12 ± 0.1% | 0.64 ± 0.2% | 15.10 ± 0.4% | 2.92 ± 0.5% | 0.72 ± 0.3% | 3.63 ± 0.6% | 20.14 ± 0.3% | 1.00 | 1.00 | 1.33 | 6.88 |
| an IPv4 address | 33176 | 33.59 ± 0.2% | 33.61 ± 0.2% | 2.08 ± 0.1% | 29.09 ± 0.8% | 6.62 ± 0.2% | differs | 4.14 ± 0.1% | 33.63 ± 0.2% | 1.00 | 1.00 | 1.15 | 5.07 |
| a date and time | 32954 | 28.69 ± 0.3% | 28.87 ± 0.3% | 1.44 ± 0.4% | 21.27 ± 0.3% | 7.06 ± 0.2% | 1.20 ± 0.4% | 7.14 ± 0.4% | 28.88 ± 0.2% | 0.99 | 0.99 | 1.35 | 4.06 |
| a field path | 32606 | 21.72 ± 0.4% | 21.80 ± 0.2% | 1.01 ± 0.2% | 23.12 ± 0.3% | 3.48 ± 1.2% | differs | 2.93 ± 0.1% | 21.80 ± 0.4% | 1.00 | 1.00 | 0.94 | 6.24 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.08 ± 0.2% | 11.09 ± 0.2% | 11.07 ± 0.2% | 11.36 ± 0.2% | 4.95 ± 1.0% | 0.91 ± 0.6% | none | 11.10 ± 0.1% | 1.00 | 1.00 | 0.98 | 2.24 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 220.35 ± 0.3% | 221.51 ± 0.4% | 264.15 ± 0.3% | 87.25 ± 0.3% | 223.48 ± 0.5% | 470.78 ± 0.7% | 3799.60 ± 0.2% | 220.52 ± 0.3% | 0.99 | 1.00 | 2.53 | 0.99 |
| a UUID | 62 | 143.22 ± 0.2% | 143.71 ± 0.2% | 161.15 ± 0.2% | 46.17 ± 0.7% | 99.55 ± 1.0% | 189.34 ± 3.4% | 4265.54 ± 0.2% | 143.30 ± 0.1% | 1.00 | 1.00 | 3.10 | 1.44 |
| an IPv4 address | 29 | 411.28 ± 0.6% | 415.45 ± 0.7% | 595.45 ± 0.7% | 77.55 ± 0.4% | 132.56 ± 1.2% | 299.72 ± 1.2% | 7534.92 ± 0.4% | 411.94 ± 0.3% | 0.99 | 1.00 | 5.30 | 3.10 |
| a date and time | 56 | 294.84 ± 0.2% | 296.70 ± 0.2% | 375.83 ± 0.3% | 72.51 ± 0.7% | 137.82 ± 1.9% | 332.08 ± 0.4% | 4931.92 ± 0.4% | 295.06 ± 0.2% | 0.99 | 1.00 | 4.07 | 2.14 |
| a field path | 39 | 213.16 ± 0.1% | 214.09 ± 0.1% | 252.42 ± 0.2% | 79.85 ± 1.7% | 207.93 ± 2.9% | 500.60 ± 4.6% | 4827.41 ± 3.3% | 213.19 ± 0.2% | 1.00 | 1.00 | 2.67 | 1.03 |
| literal: a word | 7 | 610.79 ± 0.6% | 663.57 ± 0.4% | 1224.62 ± 0.2% | 493.65 ± 0.3% | 634.66 ± 3.3% | 954.98 ± 0.6% | 29705.39 ± 0.2% | 610.40 ± 0.2% | 0.92 | 1.00 | 1.24 | 0.96 |
| literal: a word that is not there | 8 | 593.42 ± 0.4% | 645.81 ± 0.2% | 1156.84 ± 0.2% | 455.80 ± 0.7% | 611.46 ± 2.0% | 899.60 ± 0.2% | 28553.04 ± 0.2% | 593.79 ± 0.6% | 0.92 | 1.00 | 1.30 | 0.97 |
| literal: one of four words | 26 | 237.76 ± 0.2% | 393.40 ± 0.4% | 545.35 ± 0.2% | 50.36 ± 0.5% | 244.85 ± 1.5% | 370.23 ± 0.4% | 15708.31 ± 0.3% | 237.75 ± 0.1% | 0.60 | 1.00 | 4.72 | 0.97 |
| literal: a word in any case | 11 | 434.05 ± 0.3% | 465.09 ± 0.6% | 690.67 ± 0.1% | 15.73 ± 0.3% | 670.36 ± 2.5% | refused | 23360.56 ± 0.5% | 433.74 ± 0.2% | 0.93 | 1.00 | 27.60 | 0.65 |
| literal: an href attribute | 12 | 332.34 ± 0.3% | 345.59 ± 0.5% | 460.28 ± 0.5% | 45.54 ± 0.9% | 508.50 ± 0.5% | 776.15 ± 0.5% | 21344.60 ± 0.6% | 332.23 ± 0.2% | 0.96 | 1.00 | 7.30 | 0.65 |
| literal: a word, second text | 10 | 547.53 ± 0.1% | 605.08 ± 0.2% | 1040.50 ± 0.1% | 403.31 ± 1.7% | 540.16 ± 2.8% | 803.98 ± 0.7% | 26379.36 ± 0.2% | 546.95 ± 0.4% | 0.90 | 1.00 | 1.36 | 1.01 |
| class: two capitalized words | 23 | 418.84 ± 0.3% | 454.39 ± 0.2% | 672.20 ± 0.6% | 102.89 ± 0.1% | 509.70 ± 1.0% | 743.53 ± 0.4% | 6445.98 ± 0.5% | 419.28 ± 0.4% | 0.92 | 1.00 | 4.07 | 0.82 |
| class: a word that ends in ing | 9 | 537.70 ± 0.4% | 609.70 ± 0.1% | 1103.66 ± 0.1% | 132.51 ± 0.4% | 766.09 ± 4.5% | 1101.45 ± 1.1% | 15740.05 ± 0.2% | 537.59 ± 0.1% | 0.88 | 1.00 | 4.06 | 0.70 |
| class: a word in capitals | 16 | 471.59 ± 0.2% | 517.50 ± 0.6% | 867.88 ± 0.2% | 135.88 ± 0.5% | 759.13 ± 1.5% | 1043.41 ± 0.2% | 8487.29 ± 0.5% | 471.32 ± 0.2% | 0.91 | 1.00 | 3.47 | 0.62 |
| class: a number | 6 | 596.68 ± 0.3% | 670.62 ± 0.7% | 1323.38 ± 0.1% | 41.99 ± 1.1% | 1407.47 ± 4.6% | 1862.15 ± 1.6% | 22257.29 ± 0.1% | 597.06 ± 0.3% | 0.89 | 1.00 | 14.21 | 0.42 |
| class: two capitalized words, second text | 23 | 418.36 ± 0.3% | 453.47 ± 0.3% | 670.71 ± 0.3% | 99.91 ± 0.1% | 505.50 ± 1.5% | 735.40 ± 3.1% | 6427.04 ± 0.4% | 419.22 ± 0.2% | 0.92 | 1.00 | 4.19 | 0.83 |
| other: a word between two words | 13 | 527.71 ± 0.4% | 549.05 ± 0.3% | 900.98 ± 0.5% | 133.44 ± 1.0% | 508.81 ± 1.4% | 804.59 ± 0.4% | 14652.47 ± 0.1% | 527.57 ± 0.4% | 0.96 | 1.00 | 3.95 | 1.04 |
| other: a number before a unit, second text | 15 | 379.50 ± 0.4% | 420.95 ± 0.1% | 598.64 ± 0.1% | 39.58 ± 0.7% | 638.60 ± 1.1% | 888.43 ± 0.6% | 14966.35 ± 0.4% | 378.93 ± 0.4% | 0.90 | 1.00 | 9.59 | 0.59 |
| other: a heading's start tag | 13 | 342.20 ± 0.7% | 348.84 ± 0.3% | 467.60 ± 0.4% | 44.13 ± 0.2% | 633.37 ± 1.2% | 872.47 ± 0.6% | 17672.94 ± 0.3% | 341.75 ± 0.3% | 0.98 | 1.00 | 7.75 | 0.54 |
| other: a whole word | 11 | 566.18 ± 0.7% | 605.03 ± 0.3% | 1037.09 ± 0.0% | 120.00 ± 0.6% | 570.11 ± 1.4% | 814.48 ± 0.4% | 26546.66 ± 0.5% | 566.94 ± 0.8% | 0.94 | 1.00 | 4.72 | 0.99 |
| other: a line's first word, second text | 17 | 517.95 ± 0.7% | 542.58 ± 0.2% | 894.46 ± 0.1% | 129.90 ± 0.3% | 721.63 ± 0.7% | refused | refused | 516.23 ± 0.6% | 0.95 | 1.00 | 3.99 | 0.72 |
| other: fourteen octets before an x | 16 | 105.74 ± 0.1% | 151.42 ± 0.2% | 175.50 ± 0.5% | 15.21 ± 0.4% | 458.51 ± 2.8% | 403.10 ± 0.5% | 12605.68 ± 2.1% | 105.49 ± 0.4% | 0.70 | 1.00 | 6.95 | 0.23 |
| other: a Greek word | 8 | 410.52 ± 0.1% | 566.49 ± 0.5% | 989.01 ± 0.1% | 59.10 ± 0.3% | 1403.14 ± 0.6% | 1839.49 ± 0.3% | refused | 410.55 ± 0.2% | 0.72 | 1.00 | 6.95 | 0.29 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15811.86 ± 0.5% | not timed | not timed | 16432.58 ± 2.1% | 2105.68 ± 19.1% | not timed | not timed | 15777.44 ± 0.5% | | 1.00 | 0.96 | 7.51 |
| 01-literal/sherlock-casei-en | 522 | 5176.78 ± 1.2% | not timed | not timed | 3590.28 ± 0.2% | 32.50 ± 0.2% | not timed | not timed | 5167.86 ± 0.5% | | 1.00 | 1.44 | 159.29 |
| 01-literal/sherlock-ru | 724 | 17130.58 ± 0.4% | not timed | not timed | 17302.94 ± 0.2% | 1354.65 ± 19.7% | not timed | not timed | 17101.56 ± 0.5% | | 1.00 | 0.99 | 12.65 |
| 01-literal/sherlock-casei-ru | 746 | 6168.09 ± 0.2% | not timed | not timed | 3328.29 ± 0.2% | 31.02 ± 0.8% | not timed | not timed | 6168.35 ± 0.2% | | 1.00 | 1.85 | 198.85 |
| 01-literal/sherlock-zh | 30 | 19759.19 ± 0.5% | not timed | not timed | 18605.93 ± 0.7% | 2707.38 ± 7.0% | not timed | not timed | 19763.81 ± 0.5% | | 1.00 | 1.06 | 7.30 |
| 02-literal-alternate/sherlock-en | 714 | 6055.28 ± 0.5% | not timed | not timed | 3940.99 ± 0.3% | 16.63 ± 0.2% | not timed | not timed | 6051.85 ± 0.3% | | 1.00 | 1.54 | 364.21 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1939.26 ± 1.8% | not timed | not timed | 697.49 ± 0.1% | 11.12 ± 0.1% | not timed | not timed | 1933.03 ± 0.4% | | 1.00 | 2.78 | 174.46 |
| 02-literal-alternate/sherlock-ru | 899 | 5570.43 ± 0.1% | not timed | not timed | 3258.24 ± 0.1% | 22.64 ± 0.2% | not timed | not timed | 5563.15 ± 0.1% | | 1.00 | 1.71 | 246.08 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2058.50 ± 0.7% | not timed | not timed | 1230.48 ± 0.3% | 9.07 ± 0.1% | not timed | not timed | 2049.20 ± 0.2% | | 1.00 | 1.67 | 226.85 |
| 02-literal-alternate/sherlock-zh | 207 | 7296.97 ± 0.3% | not timed | not timed | 4167.64 ± 0.2% | 31.50 ± 0.1% | not timed | not timed | 7293.03 ± 0.3% | | 1.00 | 1.75 | 231.66 |
| 03-date/ascii | 111817 | 124.11 ± 0.5% | not timed | not timed | 96.44 ± 0.1% | 0.20 ± 2.7% | not timed | not timed | 123.37 ± 0.5% | | 1.01 | 1.29 | 613.08 |
| 04-ruff-noqa/real | 84 | 401.92 ± 0.0% | not timed | not timed | 462.57 ± 0.0% | 19.55 ± 0.6% | not timed | not timed | 401.45 ± 0.0% | | 1.00 | 0.87 | 20.56 |
| 04-ruff-noqa/tweaked | 44 | 561.33 ± 0.2% | not timed | not timed | 459.97 ± 0.1% | 368.79 ± 0.6% | not timed | not timed | 562.06 ± 0.1% | | 1.00 | 1.22 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.13 ± 0.3% | not timed | not timed | 5.06 ± 0.1% | 0.20 ± 4.3% | not timed | not timed | 5.05 ± 2.0% | | 1.02 | 1.01 | 25.07 |
| 06-cloud-flare-redos/original | 107 | 415.04 ± 0.2% | not timed | not timed | 217.41 ± 0.5% | 24.80 ± 0.3% | not timed | not timed | 415.25 ± 0.1% | | 1.00 | 1.91 | 16.74 |
| 06-cloud-flare-redos/simplified-short | 102 | 411.27 ± 0.2% | not timed | not timed | 227.96 ± 0.0% | 26.67 ± 0.2% | not timed | not timed | 411.76 ± 0.2% | | 1.00 | 1.80 | 15.42 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.76 ± 0.1% | not timed | not timed | 253.40 ± 0.3% | 28.83 ± 0.1% | not timed | not timed | 583.10 ± 0.1% | | 1.00 | 2.30 | 20.25 |
| 07-unicode-character-data/parse-line | 558784 | 235.16 ± 0.3% | not timed | not timed | 172.94 ± 0.2% | 42.64 ± 6.1% | not timed | not timed | 235.51 ± 2.4% | | 1.00 | 1.36 | 5.51 |
| 08-words/all-english | 56691 | 116.67 ± 0.7% | not timed | not timed | 83.07 ± 0.4% | 11.63 ± 4.2% | not timed | not timed | 117.00 ± 0.5% | | 1.00 | 1.40 | 10.03 |
| 08-words/long-english | 839 | 612.89 ± 0.2% | not timed | not timed | 596.43 ± 0.1% | 32.75 ± 0.4% | not timed | not timed | 615.33 ± 0.9% | | 1.00 | 1.03 | 18.71 |
| 09-aws-keys/full | 0 | 408.03 ± 0.2% | not timed | not timed | 461.56 ± 0.2% | 64.58 ± 4.1% | not timed | not timed | 407.95 ± 0.1% | | 1.00 | 0.88 | 6.32 |
| 09-aws-keys/quick | 0 | 942.59 ± 0.2% | not timed | not timed | 994.33 ± 0.1% | 421.07 ± 3.9% | not timed | not timed | 942.17 ± 0.2% | | 1.00 | 0.95 | 2.24 |
| 10-bounded-repeat/letters-en | 1833 | 592.77 ± 1.6% | not timed | not timed | 517.50 ± 0.2% | 19.53 ± 0.9% | not timed | not timed | 583.06 ± 2.0% | | 1.02 | 1.15 | 30.35 |
| 10-bounded-repeat/letters-ru | 3475 | 501.19 ± 1.3% | not timed | not timed | 478.30 ± 0.2% | 22.54 ± 17.0% | not timed | not timed | 506.13 ± 1.6% | | 0.99 | 1.05 | 22.23 |
| 10-bounded-repeat/context | 53 | 77.38 ± 0.7% | not timed | not timed | 66.21 ± 0.3% | 19.82 ± 0.2% | not timed | not timed | 77.41 ± 0.6% | | 1.00 | 1.17 | 3.90 |
| 10-bounded-repeat/capitals | 11 | 635.53 ± 8.2% | not timed | not timed | 615.79 ± 0.1% | 36.62 ± 0.1% | not timed | not timed | 634.42 ± 8.5% | | 1.00 | 1.03 | 17.36 |
| 11-unstructured-to-json/extract | 600 | 82.92 ± 0.2% | not timed | not timed | 77.99 ± 0.5% | 49.02 ± 1.1% | not timed | not timed | 82.44 ± 0.2% | | 1.01 | 1.06 | 1.69 |
| 12-dictionary/single | 1 | 560.20 ± 0.2% | not timed | not timed | 555.28 ± 0.3% | 0.41 ± 0.1% | not timed | not timed | 560.36 ± 0.1% | | 1.00 | 1.01 | 1369.83 |
| 14-quadratic/1x | 100 | 21.24 ± 2.0% | not timed | not timed | 10.05 ± 0.1% | 0.96 ± 2.5% | not timed | not timed | 21.28 ± 0.9% | | 1.00 | 2.11 | 22.06 |
| 14-quadratic/2x | 200 | 17.50 ± 0.2% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 2.2% | not timed | not timed | 17.50 ± 0.5% | | 1.00 | 3.16 | 32.80 |
| 14-quadratic/10x | 1000 | 7.68 ± 0.4% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.9% | not timed | not timed | 7.68 ± 0.4% | | 1.00 | 6.36 | 66.50 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 0.2% | not timed | not timed | 0.35 ± 2.7% | 0.56 ± 11.8% | not timed | not timed | 1.26 ± 2.0% | | 1.00 | 3.66 | 2.24 |
| 04-ruff-noqa/compile-real | 1 | 88.31 ± 0.4% | not timed | not timed | 13.82 ± 0.2% | 141.02 ± 2.0% | not timed | not timed | 87.96 ± 1.1% | | 1.00 | 6.39 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 13.91 ± 0.2% | not timed | not timed | 2.56 ± 0.9% | 6.53 ± 2.2% | not timed | not timed | 13.87 ± 0.2% | | 1.00 | 5.45 | 2.13 |
| 07-unicode-character-data/compile | 1 | 53.64 ± 0.1% | not timed | not timed | 25.91 ± 0.3% | 36.69 ± 3.6% | not timed | not timed | 53.32 ± 1.0% | | 1.01 | 2.07 | 1.46 |
| 09-aws-keys/compile-full | 1 | 40.99 ± 0.3% | not timed | not timed | 8.34 ± 0.3% | 23.70 ± 1.1% | not timed | not timed | 40.74 ± 0.2% | | 1.01 | 4.91 | 1.73 |
| 09-aws-keys/compile-quick | 1 | 179.07 ± 0.5% | not timed | not timed | 47.51 ± 0.2% | 135.93 ± 2.7% | not timed | not timed | 178.78 ± 0.7% | | 1.00 | 3.77 | 1.32 |
| 10-bounded-repeat/compile-context | 1 | 13.56 ± 0.3% | not timed | not timed | 11.31 ± 0.1% | 16.46 ± 1.6% | not timed | not timed | 13.42 ± 1.2% | | 1.01 | 1.20 | 0.82 |
| 10-bounded-repeat/compile-capitals | 1 | 80.79 ± 0.4% | not timed | not timed | 8.20 ± 0.3% | 24.21 ± 2.3% | not timed | not timed | 80.67 ± 0.6% | | 1.00 | 9.85 | 3.34 |
| 11-unstructured-to-json/compile | 1 | 83.96 ± 0.2% | not timed | not timed | 40.66 ± 0.5% | 70.11 ± 1.7% | not timed | not timed | 83.42 ± 1.0% | | 1.01 | 2.06 | 1.20 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 0.7% | 0.09 ± 29.7% | not timed | not timed | 0.35 ± 1.7% | | 1.01 | 5.04 | 3.70 |

