# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102078946 |
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
| literal: a word | 217 | 16022.73 ± 1.2% | 1041.56 ± 0.6% | 28.13 ± 0.1% | 18203.97 ± 1.8% | 9184.97 ± 7.7% | 17.31 ± 0.3% | 86.65 ± 0.1% | 16048.77 ± 0.7% | 15.38 | 1.00 | 0.88 | 1.74 |
| literal: a word that is not there | 0 | 18814.77 ± 1.0% | 1046.68 ± 0.6% | 28.20 ± 0.1% | 19950.41 ± 1.1% | 29281.69 ± 1.6% | 17.08 ± 0.1% | 82.61 ± 0.1% | 18800.66 ± 1.3% | 17.98 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6157.15 ± 0.2% | 1021.62 ± 0.2% | 14.35 ± 0.1% | 3946.35 ± 0.3% | 21.85 ± 0.2% | 5.42 ± 0.1% | 6.82 ± 0.7% | 6146.24 ± 0.4% | 6.03 | 1.00 | 1.56 | 281.74 |
| literal: a word in any case | 217 | 12505.29 ± 0.2% | 1042.01 ± 0.5% | 21.45 ± 0.3% | 3968.55 ± 0.2% | 37.99 ± 0.1% | refused | differs | 12500.80 ± 0.3% | 12.00 | 1.00 | 3.15 | 329.21 |
| literal: an href attribute | 33 | 13840.79 ± 0.6% | 1046.64 ± 0.4% | 26.94 ± 0.2% | 16957.34 ± 0.8% | 2261.10 ± 1.8% | 13.10 ± 0.3% | 75.64 ± 0.2% | 13820.38 ± 0.3% | 13.22 | 1.00 | 0.82 | 6.12 |
| literal: a word, second text | 123 | 16492.77 ± 0.7% | 1048.29 ± 0.3% | 27.79 ± 0.3% | 18495.74 ± 0.8% | 7665.11 ± 3.4% | 20.02 ± 0.6% | 70.70 ± 0.4% | 16507.31 ± 0.9% | 15.73 | 1.00 | 0.89 | 2.15 |
| class: two capitalized words | 1331 | 1105.76 ± 0.4% | 959.32 ± 0.1% | 25.74 ± 0.2% | 584.52 ± 0.1% | 40.64 ± 8.0% | 14.65 ± 0.4% | 68.93 ± 0.3% | 1104.60 ± 0.3% | 1.15 | 1.00 | 1.89 | 27.21 |
| class: a word that ends in ing | 3399 | 879.73 ± 0.2% | 881.29 ± 0.2% | 17.82 ± 0.1% | 546.46 ± 0.1% | 29.50 ± 10.6% | 8.17 ± 0.2% | 18.47 ± 0.4% | 879.04 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.83 |
| class: a word in capitals | 2332 | 1468.21 ± 0.5% | 945.01 ± 0.3% | 27.22 ± 0.3% | 571.71 ± 0.1% | 43.51 ± 0.2% | 17.06 ± 0.3% | 83.26 ± 0.6% | 1461.42 ± 0.3% | 1.55 | 1.00 | 2.57 | 33.74 |
| class: a number | 8288 | 2059.25 ± 0.5% | 792.30 ± 0.3% | 27.47 ± 0.2% | 1695.56 ± 0.2% | 42.17 ± 14.6% | 0.55 ± 0.2% | 56.75 ± 0.6% | 2060.88 ± 0.3% | 2.60 | 1.00 | 1.21 | 48.84 |
| class: two capitalized words, second text | 5359 | 689.62 ± 0.1% | 687.37 ± 0.1% | 23.06 ± 0.2% | 483.59 ± 0.1% | 34.20 ± 10.4% | 17.06 ± 0.2% | 64.10 ± 0.4% | 689.26 ± 0.2% | 1.00 | 1.00 | 1.43 | 20.16 |
| other: a word between two words | 6104 | 779.46 ± 0.1% | 742.70 ± 0.2% | 23.25 ± 0.2% | 731.88 ± 0.3% | 109.50 ± 11.8% | 11.20 ± 0.2% | 69.82 ± 0.8% | 778.79 ± 0.2% | 1.05 | 1.00 | 1.07 | 7.12 |
| other: a number before a unit, second text | 1481 | 5454.80 ± 0.8% | 979.15 ± 0.2% | 25.65 ± 0.2% | 5662.43 ± 0.6% | 40.66 ± 8.9% | 18.17 ± 0.2% | 67.01 ± 0.3% | 5457.66 ± 0.5% | 5.57 | 1.00 | 0.96 | 134.17 |
| other: a heading's start tag | 110 | 12737.34 ± 0.3% | 1031.21 ± 0.3% | 27.00 ± 0.1% | 1706.06 ± 0.2% | 1582.29 ± 6.0% | 16.10 ± 0.3% | 88.78 ± 0.3% | 12718.13 ± 0.5% | 12.35 | 1.00 | 7.47 | 8.05 |
| other: a whole word | 217 | 14020.25 ± 0.6% | 1040.17 ± 0.3% | 28.75 ± 0.9% | 14504.17 ± 0.8% | 49.33 ± 0.2% | 13.20 ± 0.1% | 56.25 ± 0.3% | 14013.17 ± 0.5% | 13.48 | 1.00 | 0.97 | 284.19 |
| other: a line's first word, second text | 3716 | 1950.66 ± 0.4% | 855.70 ± 0.3% | 30.39 ± 0.1% | 1721.06 ± 0.3% | 62.25 ± 5.4% | refused | refused | 1948.43 ± 0.5% | 2.28 | 1.00 | 1.13 | 31.34 |
| other: fourteen octets before an x | 87 | 19506.20 ± 0.5% | 257.73 ± 0.2% | 5.31 ± 0.1% | 4004.43 ± 0.3% | 10.65 ± 0.2% | differs | 17.81 ± 0.1% | 19558.95 ± 0.5% | 75.68 | 1.00 | 4.87 | 1831.30 |
| other: a Greek word | 21815 | 470.57 ± 0.8% | 316.29 ± 0.4% | 30.36 ± 0.1% | 288.17 ± 0.7% | 49.01 ± 15.3% | differs | refused | 471.24 ± 1.0% | 1.49 | 1.00 | 1.63 | 9.60 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.04 ± 0.2% | 26.02 ± 0.2% | 0.81 ± 0.2% | 19.81 ± 0.3% | 2.77 ± 0.4% | differs | 4.01 ± 0.2% | 26.05 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.39 |
| a UUID | 32895 | 21.24 ± 0.2% | 21.32 ± 0.2% | 0.64 ± 0.3% | 15.15 ± 0.8% | 3.12 ± 0.2% | 0.73 ± 0.5% | 3.59 ± 0.3% | 21.34 ± 0.2% | 1.00 | 1.00 | 1.40 | 6.82 |
| an IPv4 address | 33176 | 36.81 ± 0.3% | 36.75 ± 0.1% | 2.08 ± 0.3% | 29.50 ± 0.3% | 6.64 ± 0.4% | differs | 4.12 ± 0.4% | 36.84 ± 0.3% | 1.00 | 1.00 | 1.25 | 5.55 |
| a date and time | 32954 | 31.20 ± 0.1% | 31.23 ± 0.3% | 1.45 ± 0.1% | 21.50 ± 0.5% | 7.06 ± 0.2% | 1.25 ± 0.3% | 7.16 ± 0.5% | 31.19 ± 0.1% | 1.00 | 1.00 | 1.45 | 4.42 |
| a field path | 32606 | 29.59 ± 0.3% | 29.54 ± 0.3% | 0.97 ± 0.0% | 23.33 ± 0.4% | 3.51 ± 0.5% | differs | 2.97 ± 0.3% | 29.54 ± 0.4% | 1.00 | 1.00 | 1.27 | 8.44 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.02 ± 0.3% | 9.02 ± 0.1% | 9.02 ± 0.1% | 11.84 ± 0.2% | 4.92 ± 3.0% | 0.93 ± 0.7% | none | 9.04 ± 0.3% | 1.00 | 1.00 | 0.76 | 1.83 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.72 ± 0.6% | 237.43 ± 0.2% | 287.70 ± 0.3% | 86.16 ± 0.1% | 222.91 ± 1.1% | 487.60 ± 0.4% | 3882.75 ± 0.8% | 235.80 ± 0.4% | 0.99 | 1.00 | 2.74 | 1.06 |
| a UUID | 62 | 157.72 ± 0.3% | 158.05 ± 0.2% | 178.65 ± 0.2% | 45.47 ± 0.2% | 99.15 ± 1.8% | 181.40 ± 0.7% | 4252.47 ± 0.9% | 157.82 ± 0.3% | 1.00 | 1.00 | 3.47 | 1.59 |
| an IPv4 address | 29 | 425.87 ± 0.3% | 429.18 ± 0.2% | 619.31 ± 0.2% | 76.32 ± 1.0% | 133.09 ± 2.9% | 290.80 ± 1.0% | 7596.87 ± 0.1% | 424.93 ± 0.3% | 0.99 | 1.00 | 5.58 | 3.20 |
| a date and time | 56 | 306.17 ± 0.4% | 308.23 ± 0.3% | 395.79 ± 0.4% | 71.66 ± 0.3% | 136.11 ± 17.8% | 318.96 ± 1.0% | 4864.38 ± 0.4% | 305.89 ± 0.4% | 0.99 | 1.00 | 4.27 | 2.25 |
| a field path | 39 | 227.32 ± 0.4% | 228.97 ± 0.2% | 274.43 ± 0.3% | 79.03 ± 0.4% | 204.55 ± 2.0% | 488.15 ± 0.5% | 4931.06 ± 2.8% | 227.18 ± 0.3% | 0.99 | 1.00 | 2.88 | 1.11 |
| literal: a word | 7 | 634.72 ± 1.0% | 682.37 ± 0.5% | 1293.92 ± 0.7% | 500.32 ± 1.2% | 631.48 ± 3.6% | 923.05 ± 0.8% | 30435.18 ± 0.2% | 635.54 ± 0.9% | 0.93 | 1.00 | 1.27 | 1.01 |
| literal: a word that is not there | 8 | 608.50 ± 0.8% | 661.25 ± 0.7% | 1217.79 ± 1.0% | 458.08 ± 0.1% | 602.66 ± 2.0% | 881.24 ± 0.5% | 29132.10 ± 0.1% | 610.34 ± 0.5% | 0.92 | 1.00 | 1.33 | 1.01 |
| literal: one of four words | 26 | 241.87 ± 0.3% | 405.75 ± 0.6% | 569.84 ± 0.4% | 49.20 ± 0.2% | 242.30 ± 2.4% | 360.17 ± 0.5% | 15617.61 ± 0.4% | 242.04 ± 0.6% | 0.60 | 1.00 | 4.92 | 1.00 |
| literal: a word in any case | 11 | 491.80 ± 0.5% | 526.21 ± 0.5% | 852.00 ± 0.2% | 15.66 ± 0.8% | 646.41 ± 1.6% | refused | 23712.01 ± 0.5% | 491.66 ± 0.2% | 0.93 | 1.00 | 31.40 | 0.76 |
| literal: an href attribute | 12 | 353.95 ± 0.5% | 365.60 ± 0.4% | 499.64 ± 0.6% | 10.74 ± 51.0% | 499.19 ± 1.5% | 761.16 ± 1.8% | 21609.87 ± 0.4% | 353.48 ± 0.4% | 0.97 | 1.00 | 32.97 | 0.71 |
| literal: a word, second text | 10 | 569.66 ± 1.1% | 626.04 ± 0.8% | 1090.12 ± 1.3% | 408.39 ± 0.2% | 531.39 ± 3.4% | 792.50 ± 0.7% | 27089.67 ± 0.2% | 568.78 ± 0.8% | 0.91 | 1.00 | 1.39 | 1.07 |
| class: two capitalized words | 23 | 441.57 ± 1.1% | 470.93 ± 0.5% | 707.70 ± 0.9% | 100.72 ± 0.1% | 488.89 ± 1.8% | 740.74 ± 0.4% | 6576.82 ± 0.1% | 442.08 ± 0.2% | 0.94 | 1.00 | 4.38 | 0.90 |
| class: a word that ends in ing | 9 | 572.14 ± 0.2% | 641.74 ± 0.9% | 1176.69 ± 0.5% | 131.77 ± 0.5% | 756.59 ± 1.8% | 1085.51 ± 1.5% | 16142.38 ± 0.1% | 571.44 ± 0.3% | 0.89 | 1.00 | 4.34 | 0.76 |
| class: a word in capitals | 16 | 506.09 ± 0.5% | 544.25 ± 0.5% | 907.93 ± 0.3% | 134.97 ± 1.3% | 757.39 ± 3.5% | 1022.30 ± 1.6% | 8692.56 ± 0.1% | 505.90 ± 0.3% | 0.93 | 1.00 | 3.75 | 0.67 |
| class: a number | 6 | 635.89 ± 0.5% | 702.06 ± 0.4% | 1389.52 ± 0.2% | 41.81 ± 0.3% | 1415.42 ± 1.3% | 1937.70 ± 0.6% | 22861.68 ± 0.1% | 636.55 ± 0.3% | 0.91 | 1.00 | 15.21 | 0.45 |
| class: two capitalized words, second text | 23 | 441.95 ± 0.3% | 469.92 ± 0.6% | 707.18 ± 0.5% | 100.77 ± 1.5% | 506.63 ± 0.9% | 742.34 ± 0.8% | 6575.66 ± 0.2% | 441.81 ± 0.3% | 0.94 | 1.00 | 4.39 | 0.87 |
| other: a word between two words | 13 | 560.93 ± 0.5% | 579.32 ± 0.6% | 964.35 ± 0.6% | 134.83 ± 1.3% | 502.54 ± 0.9% | 811.21 ± 0.6% | 14876.49 ± 0.6% | 560.60 ± 0.3% | 0.97 | 1.00 | 4.16 | 1.12 |
| other: a number before a unit, second text | 15 | 408.75 ± 0.3% | 447.58 ± 0.4% | 650.90 ± 0.7% | 39.04 ± 0.1% | 637.22 ± 1.4% | 894.80 ± 0.8% | 15208.16 ± 0.3% | 408.77 ± 0.3% | 0.91 | 1.00 | 10.47 | 0.64 |
| other: a heading's start tag | 13 | 361.90 ± 0.1% | 367.11 ± 0.2% | 499.20 ± 0.5% | 11.38 ± 21.1% | 629.26 ± 1.0% | 862.25 ± 0.3% | 18080.00 ± 0.2% | 361.52 ± 0.3% | 0.99 | 1.00 | 31.81 | 0.58 |
| other: a whole word | 11 | 592.30 ± 0.4% | 630.19 ± 0.5% | 1105.05 ± 0.1% | 120.17 ± 0.6% | 565.22 ± 2.2% | 825.35 ± 0.8% | 26928.71 ± 0.9% | 593.14 ± 0.5% | 0.94 | 1.00 | 4.93 | 1.05 |
| other: a line's first word, second text | 17 | 542.47 ± 0.3% | 561.97 ± 0.4% | 945.33 ± 0.3% | 127.76 ± 0.4% | 709.59 ± 1.2% | refused | refused | 540.87 ± 0.6% | 0.97 | 1.00 | 4.25 | 0.76 |
| other: fourteen octets before an x | 16 | 112.13 ± 0.5% | 162.68 ± 0.3% | 190.42 ± 0.5% | 6.77 ± 26.3% | 450.81 ± 4.0% | 405.76 ± 1.2% | 12551.18 ± 0.6% | 112.37 ± 0.6% | 0.69 | 1.00 | 16.57 | 0.25 |
| other: a Greek word | 8 | 433.18 ± 0.2% | 599.42 ± 0.5% | 1059.92 ± 0.1% | 12.25 ± 28.0% | 1392.22 ± 1.4% | 1832.63 ± 0.6% | refused | 433.09 ± 0.3% | 0.72 | 1.00 | 35.37 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12864.43 ± 0.4% | not timed | not timed | 16331.72 ± 0.4% | 1960.82 ± 20.1% | not timed | not timed | 12935.44 ± 0.9% | | 0.99 | 0.79 | 6.56 |
| 01-literal/sherlock-casei-en | 522 | 3948.03 ± 0.4% | not timed | not timed | 3599.36 ± 0.2% | 32.48 ± 0.2% | not timed | not timed | 3936.72 ± 0.3% | | 1.00 | 1.10 | 121.57 |
| 01-literal/sherlock-ru | 724 | 13577.82 ± 0.4% | not timed | not timed | 17274.31 ± 0.2% | 1452.81 ± 17.3% | not timed | not timed | 13554.37 ± 0.5% | | 1.00 | 0.79 | 9.35 |
| 01-literal/sherlock-casei-ru | 746 | 5396.71 ± 0.2% | not timed | not timed | 3330.67 ± 0.1% | 30.74 ± 0.5% | not timed | not timed | 5399.55 ± 0.7% | | 1.00 | 1.62 | 175.58 |
| 01-literal/sherlock-zh | 30 | 17233.07 ± 0.3% | not timed | not timed | 19022.53 ± 0.3% | 2540.64 ± 12.4% | not timed | not timed | 17177.94 ± 0.4% | | 1.00 | 0.91 | 6.78 |
| 02-literal-alternate/sherlock-en | 714 | 5911.76 ± 0.3% | not timed | not timed | 3932.48 ± 0.2% | 16.67 ± 0.2% | not timed | not timed | 5918.72 ± 0.3% | | 1.00 | 1.50 | 354.57 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1706.88 ± 1.4% | not timed | not timed | 699.21 ± 0.3% | 11.04 ± 0.1% | not timed | not timed | 1698.31 ± 0.2% | | 1.01 | 2.44 | 154.61 |
| 02-literal-alternate/sherlock-ru | 899 | 4804.40 ± 0.3% | not timed | not timed | 3259.33 ± 0.2% | 22.68 ± 0.1% | not timed | not timed | 4806.06 ± 0.2% | | 1.00 | 1.47 | 211.79 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1823.32 ± 0.6% | not timed | not timed | 1232.96 ± 0.2% | 9.10 ± 0.1% | not timed | not timed | 1814.03 ± 0.2% | | 1.01 | 1.48 | 200.39 |
| 02-literal-alternate/sherlock-zh | 207 | 7109.71 ± 0.4% | not timed | not timed | 4161.68 ± 0.2% | 31.44 ± 0.1% | not timed | not timed | 7105.78 ± 0.3% | | 1.00 | 1.71 | 226.10 |
| 03-date/ascii | 111817 | 123.96 ± 0.3% | not timed | not timed | 96.01 ± 0.1% | 0.20 ± 3.4% | not timed | not timed | 123.49 ± 0.4% | | 1.00 | 1.29 | 622.54 |
| 04-ruff-noqa/real | 84 | 552.21 ± 0.1% | not timed | not timed | 463.57 ± 0.1% | 19.65 ± 1.1% | not timed | not timed | 552.10 ± 0.2% | | 1.00 | 1.19 | 28.10 |
| 04-ruff-noqa/tweaked | 44 | 553.96 ± 0.3% | not timed | not timed | 467.48 ± 0.1% | 364.70 ± 0.6% | not timed | not timed | 554.14 ± 0.3% | | 1.00 | 1.18 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.53 ± 0.2% | not timed | not timed | 5.26 ± 0.2% | 0.20 ± 3.4% | not timed | not timed | 3.68 ± 0.2% | | 0.96 | 0.67 | 17.29 |
| 06-cloud-flare-redos/original | 107 | 183.53 ± 0.6% | not timed | not timed | 212.68 ± 0.2% | 24.85 ± 0.5% | not timed | not timed | 183.71 ± 0.3% | | 1.00 | 0.86 | 7.38 |
| 06-cloud-flare-redos/simplified-short | 102 | 147.38 ± 0.5% | not timed | not timed | 228.36 ± 0.1% | 26.72 ± 0.4% | not timed | not timed | 147.03 ± 1.5% | | 1.00 | 0.65 | 5.52 |
| 06-cloud-flare-redos/simplified-long | 10000 | 156.65 ± 1.7% | not timed | not timed | 255.15 ± 0.2% | 28.84 ± 0.2% | not timed | not timed | 156.53 ± 1.9% | | 1.00 | 0.61 | 5.43 |
| 07-unicode-character-data/parse-line | 558784 | 39.92 ± 0.3% | not timed | not timed | 180.15 ± 0.1% | 42.35 ± 5.6% | not timed | not timed | 39.94 ± 0.9% | | 1.00 | 0.22 | 0.94 |
| 08-words/all-english | 56691 | 103.30 ± 0.5% | not timed | not timed | 82.91 ± 0.2% | 11.84 ± 6.9% | not timed | not timed | 102.63 ± 0.5% | | 1.01 | 1.25 | 8.72 |
| 08-words/long-english | 839 | 996.22 ± 0.2% | not timed | not timed | 596.22 ± 0.1% | 32.56 ± 0.4% | not timed | not timed | 996.73 ± 0.1% | | 1.00 | 1.67 | 30.60 |
| 09-aws-keys/full | 0 | 421.99 ± 0.1% | not timed | not timed | 495.67 ± 0.2% | 64.27 ± 0.1% | not timed | not timed | 421.83 ± 0.1% | | 1.00 | 0.85 | 6.57 |
| 09-aws-keys/quick | 0 | 409.50 ± 0.1% | not timed | not timed | 997.55 ± 0.7% | 420.93 ± 1.1% | not timed | not timed | 410.65 ± 0.2% | | 1.00 | 0.41 | 0.97 |
| 10-bounded-repeat/letters-en | 1833 | 590.55 ± 0.2% | not timed | not timed | 517.82 ± 0.3% | 19.50 ± 0.6% | not timed | not timed | 590.22 ± 0.2% | | 1.00 | 1.14 | 30.28 |
| 10-bounded-repeat/letters-ru | 3475 | 403.43 ± 0.5% | not timed | not timed | 478.32 ± 0.1% | 21.89 ± 16.7% | not timed | not timed | 400.63 ± 1.3% | | 1.01 | 0.84 | 18.43 |
| 10-bounded-repeat/context | 53 | 73.37 ± 0.9% | not timed | not timed | 66.21 ± 0.3% | 19.64 ± 0.2% | not timed | not timed | 73.40 ± 1.1% | | 1.00 | 1.11 | 3.74 |
| 10-bounded-repeat/capitals | 11 | 1038.85 ± 0.1% | not timed | not timed | 618.51 ± 0.0% | 36.28 ± 0.1% | not timed | not timed | 1038.63 ± 0.2% | | 1.00 | 1.68 | 28.63 |
| 11-unstructured-to-json/extract | 600 | 24.57 ± 0.2% | not timed | not timed | 76.53 ± 0.2% | 49.27 ± 0.8% | not timed | not timed | 24.33 ± 0.7% | | 1.01 | 0.32 | 0.50 |
| 12-dictionary/single | 1 | 604.40 ± 0.2% | not timed | not timed | 562.83 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 602.75 ± 0.2% | | 1.00 | 1.07 | 1478.14 |
| 14-quadratic/1x | 100 | 12.61 ± 0.2% | not timed | not timed | 10.13 ± 0.5% | 0.96 ± 3.1% | not timed | not timed | 12.54 ± 1.2% | | 1.01 | 1.25 | 13.19 |
| 14-quadratic/2x | 200 | 7.78 ± 0.5% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 2.1% | not timed | not timed | 7.74 ± 0.5% | | 1.01 | 1.40 | 14.79 |
| 14-quadratic/10x | 1000 | 1.82 ± 0.6% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 2.0% | not timed | not timed | 1.82 ± 1.0% | | 1.00 | 1.50 | 15.81 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.4% | not timed | not timed | 0.35 ± 0.4% | 0.55 ± 2.9% | not timed | not timed | 1.44 ± 0.7% | | 1.01 | 4.18 | 2.62 |
| 04-ruff-noqa/compile-real | 1 | 92.75 ± 0.2% | not timed | not timed | 13.75 ± 0.3% | 138.78 ± 0.9% | not timed | not timed | 92.64 ± 1.1% | | 1.00 | 6.75 | 0.67 |
| 05-lexer-veryl/compile-single | 1 | 14.57 ± 0.2% | not timed | not timed | 2.53 ± 1.0% | 6.51 ± 3.0% | not timed | not timed | 14.50 ± 0.9% | | 1.00 | 5.76 | 2.24 |
| 07-unicode-character-data/compile | 1 | 58.40 ± 0.2% | not timed | not timed | 25.78 ± 0.3% | 36.17 ± 2.8% | not timed | not timed | 58.47 ± 1.4% | | 1.00 | 2.27 | 1.61 |
| 09-aws-keys/compile-full | 1 | 42.94 ± 0.4% | not timed | not timed | 8.23 ± 0.2% | 23.48 ± 1.1% | not timed | not timed | 42.81 ± 0.7% | | 1.00 | 5.22 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 188.54 ± 0.2% | not timed | not timed | 46.95 ± 0.1% | 134.91 ± 2.1% | not timed | not timed | 190.13 ± 0.9% | | 0.99 | 4.02 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 14.73 ± 0.7% | not timed | not timed | 11.08 ± 0.2% | 16.34 ± 3.3% | not timed | not timed | 14.58 ± 2.2% | | 1.01 | 1.33 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 85.93 ± 2.2% | not timed | not timed | 8.02 ± 0.3% | 24.14 ± 2.2% | not timed | not timed | 85.05 ± 1.3% | | 1.01 | 10.71 | 3.56 |
| 11-unstructured-to-json/compile | 1 | 91.26 ± 0.3% | not timed | not timed | 40.55 ± 0.3% | 68.52 ± 2.0% | not timed | not timed | 90.32 ± 1.1% | | 1.01 | 2.25 | 1.33 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 1.7% | 0.10 ± 16.7% | not timed | not timed | 0.35 ± 1.6% | | 1.01 | 5.23 | 3.71 |

