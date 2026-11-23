# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117640907 |
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
| literal: a word | 217 | 15773.49 ± 2.6% | 1036.81 ± 0.1% | 28.57 ± 0.6% | 17811.83 ± 2.6% | 9129.77 ± 8.0% | 17.38 ± 0.3% | 86.87 ± 0.2% | 15893.04 ± 2.8% | 15.21 | 0.99 | 0.89 | 1.73 |
| literal: a word that is not there | 0 | 18207.61 ± 3.5% | 1048.34 ± 0.2% | 28.60 ± 0.4% | 19441.75 ± 3.2% | 28014.33 ± 3.1% | 17.22 ± 0.4% | 82.78 ± 0.4% | 18566.74 ± 3.6% | 17.37 | 0.98 | 0.94 | 0.65 |
| literal: one of four words | 661 | 6063.56 ± 0.4% | 1013.70 ± 0.1% | 14.58 ± 0.4% | 3943.12 ± 0.3% | 21.85 ± 0.3% | 5.24 ± 0.1% | 6.90 ± 1.1% | 6068.61 ± 0.4% | 5.98 | 1.00 | 1.54 | 277.50 |
| literal: a word in any case | 217 | 12491.66 ± 0.3% | 1037.47 ± 0.1% | 21.74 ± 0.6% | 3971.15 ± 0.2% | 38.04 ± 0.3% | refused | differs | 12463.84 ± 0.8% | 12.04 | 1.00 | 3.15 | 328.35 |
| literal: an href attribute | 33 | 13843.78 ± 2.4% | 1045.44 ± 0.2% | 27.33 ± 0.4% | 17081.42 ± 2.4% | 2249.66 ± 0.7% | 13.26 ± 0.4% | 75.77 ± 0.3% | 13929.86 ± 2.1% | 13.24 | 0.99 | 0.81 | 6.15 |
| literal: a word, second text | 123 | 16219.62 ± 0.9% | 1041.69 ± 0.1% | 28.12 ± 0.1% | 17965.82 ± 2.8% | 7899.01 ± 6.4% | 19.71 ± 0.3% | 70.77 ± 0.6% | 16309.69 ± 2.8% | 15.57 | 0.99 | 0.90 | 2.05 |
| class: two capitalized words | 1331 | 1122.13 ± 0.5% | 952.95 ± 0.2% | 26.01 ± 0.2% | 585.10 ± 0.2% | 40.04 ± 7.6% | 14.72 ± 0.3% | 68.90 ± 0.3% | 1125.18 ± 0.5% | 1.18 | 1.00 | 1.92 | 28.03 |
| class: a word that ends in ing | 3399 | 876.03 ± 0.2% | 875.65 ± 0.1% | 18.07 ± 0.1% | 547.94 ± 0.4% | 29.64 ± 3.3% | 8.15 ± 0.4% | 18.46 ± 0.4% | 874.57 ± 0.2% | 1.00 | 1.00 | 1.60 | 29.56 |
| class: a word in capitals | 2332 | 1469.61 ± 0.9% | 937.31 ± 0.1% | 27.65 ± 0.6% | 572.45 ± 0.1% | 43.54 ± 16.7% | 17.10 ± 0.3% | 82.89 ± 0.4% | 1471.92 ± 0.4% | 1.57 | 1.00 | 2.57 | 33.75 |
| class: a number | 8288 | 1997.09 ± 0.2% | 785.26 ± 0.1% | 27.81 ± 0.4% | 1734.57 ± 0.7% | 41.44 ± 16.3% | 0.55 ± 0.1% | 56.51 ± 0.7% | 1997.18 ± 0.2% | 2.54 | 1.00 | 1.15 | 48.19 |
| class: two capitalized words, second text | 5359 | 683.01 ± 0.2% | 678.98 ± 0.1% | 23.33 ± 0.1% | 485.68 ± 0.2% | 35.38 ± 8.1% | 16.62 ± 0.8% | 64.02 ± 0.4% | 682.20 ± 0.1% | 1.01 | 1.00 | 1.41 | 19.30 |
| other: a word between two words | 6104 | 767.30 ± 0.3% | 737.63 ± 0.1% | 23.47 ± 0.2% | 736.82 ± 0.2% | 108.73 ± 14.9% | 11.24 ± 0.1% | 70.00 ± 0.2% | 767.21 ± 0.1% | 1.04 | 1.00 | 1.04 | 7.06 |
| other: a number before a unit, second text | 1481 | 5565.62 ± 1.4% | 972.12 ± 0.5% | 25.85 ± 0.1% | 5649.75 ± 0.8% | 40.85 ± 0.3% | 17.85 ± 0.1% | 66.82 ± 0.2% | 5543.85 ± 1.3% | 5.73 | 1.00 | 0.99 | 136.26 |
| other: a heading's start tag | 110 | 12637.36 ± 1.8% | 1035.51 ± 0.2% | 27.34 ± 0.3% | 1709.04 ± 0.1% | 1565.65 ± 6.8% | 16.12 ± 0.4% | 88.99 ± 0.4% | 12672.53 ± 1.3% | 12.20 | 1.00 | 7.39 | 8.07 |
| other: a whole word | 217 | 13812.40 ± 0.8% | 1036.36 ± 0.1% | 29.32 ± 0.4% | 14340.42 ± 2.4% | 49.28 ± 0.3% | 13.41 ± 0.1% | 56.21 ± 0.2% | 13830.39 ± 1.0% | 13.33 | 1.00 | 0.96 | 280.26 |
| other: a line's first word, second text | 3716 | 1981.47 ± 0.4% | 855.32 ± 0.2% | 31.15 ± 0.2% | 1715.16 ± 0.5% | 61.79 ± 8.4% | refused | refused | 1970.72 ± 0.2% | 2.32 | 1.01 | 1.16 | 32.07 |
| other: fourteen octets before an x | 87 | 19298.31 ± 4.1% | 228.26 ± 0.8% | 6.12 ± 0.1% | 3957.13 ± 0.5% | 10.63 ± 0.3% | differs | 17.79 ± 0.2% | 19504.80 ± 0.8% | 84.54 | 0.99 | 4.88 | 1814.95 |
| other: a Greek word | 21815 | 485.06 ± 0.9% | 308.37 ± 0.3% | 30.52 ± 0.5% | 289.85 ± 0.1% | 44.32 ± 9.1% | differs | refused | 483.08 ± 0.6% | 1.57 | 1.00 | 1.67 | 10.94 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.88 ± 0.2% | 25.90 ± 0.1% | 0.82 ± 0.1% | 19.81 ± 0.6% | 2.79 ± 0.8% | differs | 3.99 ± 0.2% | 25.86 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.27 |
| a UUID | 32895 | 21.14 ± 0.1% | 21.16 ± 0.1% | 0.65 ± 0.1% | 15.17 ± 0.5% | 3.09 ± 0.7% | 0.71 ± 0.3% | 3.60 ± 0.9% | 21.17 ± 0.2% | 1.00 | 1.00 | 1.39 | 6.83 |
| an IPv4 address | 33176 | 36.91 ± 0.1% | 36.88 ± 0.2% | 2.10 ± 0.2% | 29.01 ± 0.2% | 6.69 ± 0.1% | differs | 4.14 ± 0.1% | 36.94 ± 0.3% | 1.00 | 1.00 | 1.27 | 5.52 |
| a date and time | 32954 | 31.01 ± 0.6% | 31.10 ± 0.5% | 1.46 ± 0.5% | 21.19 ± 0.4% | 7.05 ± 1.5% | 1.20 ± 0.1% | 6.98 ± 0.5% | 29.94 ± 0.4% | 1.00 | 1.04 | 1.46 | 4.40 |
| a field path | 32606 | 29.38 ± 0.1% | 29.36 ± 0.1% | 1.01 ± 0.2% | 23.09 ± 0.1% | 3.48 ± 1.0% | differs | 2.97 ± 0.2% | 29.38 ± 0.1% | 1.00 | 1.00 | 1.27 | 8.44 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.61 ± 1.0% | 11.58 ± 0.9% | 11.62 ± 0.2% | 11.38 ± 0.1% | 4.98 ± 1.2% | 0.91 ± 0.5% | none | 11.63 ± 0.3% | 1.00 | 1.00 | 1.02 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.91 ± 0.3% | 222.43 ± 0.3% | 258.23 ± 0.1% | 86.66 ± 0.2% | 219.86 ± 1.4% | 483.99 ± 0.3% | 3880.21 ± 0.6% | 221.96 ± 0.3% | 1.00 | 1.00 | 2.56 | 1.01 |
| a UUID | 62 | 145.02 ± 0.3% | 145.31 ± 0.2% | 160.37 ± 0.2% | 45.76 ± 0.2% | 97.84 ± 0.8% | 181.51 ± 1.1% | 4427.23 ± 1.5% | 144.98 ± 0.1% | 1.00 | 1.00 | 3.17 | 1.48 |
| an IPv4 address | 29 | 436.12 ± 0.2% | 439.69 ± 0.3% | 607.02 ± 0.2% | 76.79 ± 1.0% | 130.44 ± 1.1% | 293.16 ± 0.7% | 7640.03 ± 0.3% | 435.83 ± 0.3% | 0.99 | 1.00 | 5.68 | 3.34 |
| a date and time | 56 | 313.35 ± 0.5% | 314.12 ± 0.4% | 391.41 ± 0.6% | 72.68 ± 0.2% | 136.65 ± 1.3% | 318.76 ± 0.7% | 4929.45 ± 0.6% | 313.01 ± 0.4% | 1.00 | 1.00 | 4.31 | 2.29 |
| a field path | 39 | 208.63 ± 0.6% | 209.23 ± 0.5% | 240.63 ± 0.4% | 79.93 ± 0.2% | 204.55 ± 1.6% | 485.08 ± 0.3% | 4919.32 ± 1.6% | 208.43 ± 0.5% | 1.00 | 1.00 | 2.61 | 1.02 |
| literal: a word | 7 | 669.83 ± 0.2% | 719.67 ± 0.3% | 1287.57 ± 0.2% | 514.19 ± 1.6% | 624.89 ± 4.8% | 919.13 ± 0.5% | 30847.75 ± 0.1% | 668.77 ± 0.5% | 0.93 | 1.00 | 1.30 | 1.07 |
| literal: a word that is not there | 8 | 641.49 ± 0.4% | 695.67 ± 0.4% | 1210.97 ± 0.2% | 470.28 ± 0.2% | 599.25 ± 1.7% | 873.99 ± 0.5% | 29572.64 ± 0.2% | 641.53 ± 0.3% | 0.92 | 1.00 | 1.36 | 1.07 |
| literal: one of four words | 26 | 254.22 ± 0.3% | 418.09 ± 0.6% | 563.93 ± 0.3% | 49.49 ± 0.3% | 242.51 ± 1.5% | 354.40 ± 0.6% | 15861.48 ± 0.3% | 254.43 ± 0.3% | 0.61 | 1.00 | 5.14 | 1.05 |
| literal: a word in any case | 11 | 523.85 ± 0.4% | 565.11 ± 0.4% | 870.43 ± 0.1% | 15.48 ± 1.0% | 651.49 ± 0.7% | refused | 23818.80 ± 0.5% | 523.35 ± 0.3% | 0.93 | 1.00 | 33.84 | 0.80 |
| literal: an href attribute | 12 | 349.83 ± 0.3% | 360.76 ± 0.1% | 468.20 ± 0.3% | 45.05 ± 0.1% | 496.84 ± 2.2% | 783.20 ± 1.7% | 22333.35 ± 0.3% | 349.70 ± 0.3% | 0.97 | 1.00 | 7.77 | 0.70 |
| literal: a word, second text | 10 | 594.75 ± 0.5% | 655.29 ± 0.4% | 1097.85 ± 0.7% | 420.18 ± 0.3% | 534.99 ± 7.1% | 799.62 ± 0.4% | 27788.59 ± 0.3% | 594.79 ± 0.3% | 0.91 | 1.00 | 1.42 | 1.11 |
| class: two capitalized words | 23 | 454.66 ± 0.7% | 483.60 ± 0.4% | 692.70 ± 0.4% | 101.83 ± 0.3% | 500.43 ± 1.3% | 741.81 ± 0.5% | 6634.96 ± 0.4% | 454.99 ± 0.3% | 0.94 | 1.00 | 4.47 | 0.91 |
| class: a word that ends in ing | 9 | 596.97 ± 0.7% | 663.55 ± 0.4% | 1157.24 ± 0.3% | 133.75 ± 1.2% | 753.94 ± 1.8% | 1097.69 ± 0.5% | 16308.02 ± 0.1% | 598.32 ± 0.4% | 0.90 | 1.00 | 4.46 | 0.79 |
| class: a word in capitals | 16 | 522.96 ± 0.4% | 561.55 ± 0.7% | 891.35 ± 0.4% | 137.40 ± 1.0% | 750.80 ± 1.4% | 1037.66 ± 0.5% | 8721.69 ± 0.2% | 521.92 ± 0.5% | 0.93 | 1.00 | 3.81 | 0.70 |
| class: a number | 6 | 662.23 ± 0.5% | 723.55 ± 0.5% | 1347.06 ± 0.1% | 41.90 ± 1.1% | 1404.74 ± 1.0% | 1907.79 ± 1.0% | 23210.04 ± 0.3% | 662.49 ± 0.6% | 0.92 | 1.00 | 15.81 | 0.47 |
| class: two capitalized words, second text | 23 | 454.79 ± 0.4% | 483.90 ± 0.6% | 692.87 ± 0.2% | 103.88 ± 0.1% | 502.90 ± 2.0% | 762.94 ± 0.6% | 6639.62 ± 0.2% | 455.30 ± 0.5% | 0.94 | 1.00 | 4.38 | 0.90 |
| other: a word between two words | 13 | 579.62 ± 0.7% | 599.17 ± 0.6% | 951.84 ± 0.1% | 136.07 ± 0.6% | 505.78 ± 1.5% | 811.10 ± 0.8% | 15080.53 ± 0.2% | 579.64 ± 0.7% | 0.97 | 1.00 | 4.26 | 1.15 |
| other: a number before a unit, second text | 15 | 402.82 ± 0.5% | 438.44 ± 0.2% | 602.26 ± 0.1% | 39.68 ± 0.4% | 635.30 ± 1.7% | 888.24 ± 0.4% | 15384.60 ± 0.2% | 403.79 ± 0.1% | 0.92 | 1.00 | 10.15 | 0.63 |
| other: a heading's start tag | 13 | 359.10 ± 0.4% | 363.44 ± 0.1% | 472.65 ± 0.3% | 44.00 ± 1.8% | 631.32 ± 0.7% | 873.22 ± 0.1% | 18612.60 ± 0.6% | 358.78 ± 0.3% | 0.99 | 1.00 | 8.16 | 0.57 |
| other: a whole word | 11 | 616.82 ± 0.2% | 655.33 ± 0.3% | 1087.48 ± 0.6% | 121.60 ± 1.0% | 565.26 ± 1.2% | 824.33 ± 1.5% | 27259.67 ± 0.2% | 616.50 ± 0.2% | 0.94 | 1.00 | 5.07 | 1.09 |
| other: a line's first word, second text | 17 | 557.38 ± 0.6% | 579.52 ± 0.6% | 924.29 ± 0.4% | 128.99 ± 0.1% | 707.36 ± 0.5% | refused | refused | 554.63 ± 1.2% | 0.96 | 1.00 | 4.32 | 0.79 |
| other: fourteen octets before an x | 16 | 111.83 ± 0.6% | 161.35 ± 0.5% | 184.30 ± 0.6% | 14.94 ± 0.5% | 453.03 ± 0.8% | 407.50 ± 1.4% | 12854.82 ± 1.0% | 111.81 ± 0.6% | 0.69 | 1.00 | 7.48 | 0.25 |
| other: a Greek word | 8 | 446.28 ± 0.3% | 591.01 ± 0.6% | 952.56 ± 0.5% | 59.09 ± 0.2% | 1389.14 ± 0.7% | 1771.18 ± 0.5% | refused | 446.38 ± 0.3% | 0.76 | 1.00 | 7.55 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12646.74 ± 1.0% | not timed | not timed | 15748.09 ± 1.4% | 1981.85 ± 21.2% | not timed | not timed | 12714.90 ± 1.5% | | 0.99 | 0.80 | 6.38 |
| 01-literal/sherlock-casei-en | 522 | 3888.85 ± 0.4% | not timed | not timed | 3585.26 ± 0.3% | 32.33 ± 0.2% | not timed | not timed | 3898.71 ± 0.2% | | 1.00 | 1.08 | 120.29 |
| 01-literal/sherlock-ru | 724 | 13651.91 ± 0.4% | not timed | not timed | 17066.67 ± 1.4% | 1485.53 ± 9.6% | not timed | not timed | 13642.09 ± 0.5% | | 1.00 | 0.80 | 9.19 |
| 01-literal/sherlock-casei-ru | 746 | 5311.43 ± 0.3% | not timed | not timed | 3331.56 ± 0.1% | 30.77 ± 0.2% | not timed | not timed | 5312.57 ± 0.3% | | 1.00 | 1.59 | 172.64 |
| 01-literal/sherlock-zh | 30 | 16672.99 ± 0.6% | not timed | not timed | 18096.20 ± 1.5% | 2610.98 ± 11.2% | not timed | not timed | 16623.05 ± 0.3% | | 1.00 | 0.92 | 6.39 |
| 02-literal-alternate/sherlock-en | 714 | 5803.60 ± 0.5% | not timed | not timed | 3921.25 ± 0.3% | 16.65 ± 0.3% | not timed | not timed | 5800.05 ± 0.3% | | 1.00 | 1.48 | 348.56 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1678.48 ± 0.6% | not timed | not timed | 695.60 ± 0.1% | 11.03 ± 7.4% | not timed | not timed | 1675.05 ± 1.0% | | 1.00 | 2.41 | 152.13 |
| 02-literal-alternate/sherlock-ru | 899 | 4700.71 ± 0.4% | not timed | not timed | 3257.50 ± 0.1% | 22.64 ± 0.2% | not timed | not timed | 4711.96 ± 0.3% | | 1.00 | 1.44 | 207.61 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1793.11 ± 0.8% | not timed | not timed | 1228.61 ± 0.2% | 9.06 ± 0.2% | not timed | not timed | 1791.09 ± 0.2% | | 1.00 | 1.46 | 197.85 |
| 02-literal-alternate/sherlock-zh | 207 | 7032.93 ± 1.2% | not timed | not timed | 4159.62 ± 0.7% | 31.49 ± 0.2% | not timed | not timed | 7035.16 ± 1.2% | | 1.00 | 1.69 | 223.37 |
| 03-date/ascii | 111817 | 124.47 ± 1.2% | not timed | not timed | 95.89 ± 0.2% | 0.21 ± 4.6% | not timed | not timed | 123.80 ± 0.5% | | 1.01 | 1.30 | 600.36 |
| 04-ruff-noqa/real | 84 | 525.12 ± 0.1% | not timed | not timed | 459.79 ± 0.1% | 18.43 ± 1.3% | not timed | not timed | 552.87 ± 0.1% | | 0.95 | 1.14 | 28.49 |
| 04-ruff-noqa/tweaked | 44 | 559.08 ± 0.1% | not timed | not timed | 458.61 ± 0.1% | 367.70 ± 0.5% | not timed | not timed | 558.32 ± 0.1% | | 1.00 | 1.22 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.70 ± 0.4% | not timed | not timed | 5.05 ± 0.1% | 0.21 ± 4.4% | not timed | not timed | 3.71 ± 0.6% | | 1.00 | 0.73 | 17.84 |
| 06-cloud-flare-redos/original | 107 | 184.38 ± 0.4% | not timed | not timed | 217.58 ± 0.6% | 24.92 ± 0.3% | not timed | not timed | 184.08 ± 0.4% | | 1.00 | 0.85 | 7.40 |
| 06-cloud-flare-redos/simplified-short | 102 | 145.37 ± 0.1% | not timed | not timed | 229.84 ± 0.1% | 26.70 ± 0.4% | not timed | not timed | 145.26 ± 0.1% | | 1.00 | 0.63 | 5.45 |
| 06-cloud-flare-redos/simplified-long | 10000 | 154.61 ± 2.3% | not timed | not timed | 256.77 ± 0.1% | 28.85 ± 0.2% | not timed | not timed | 154.55 ± 2.6% | | 1.00 | 0.60 | 5.36 |
| 07-unicode-character-data/parse-line | 558784 | 241.84 ± 2.3% | not timed | not timed | 174.81 ± 0.1% | 43.07 ± 4.2% | not timed | not timed | 239.16 ± 2.0% | | 1.01 | 1.38 | 5.61 |
| 08-words/all-english | 56691 | 102.90 ± 0.8% | not timed | not timed | 83.40 ± 0.2% | 12.15 ± 15.2% | not timed | not timed | 102.62 ± 0.2% | | 1.00 | 1.23 | 8.47 |
| 08-words/long-english | 839 | 998.32 ± 0.1% | not timed | not timed | 597.76 ± 0.0% | 32.65 ± 0.2% | not timed | not timed | 998.89 ± 0.1% | | 1.00 | 1.67 | 30.57 |
| 09-aws-keys/full | 0 | 423.66 ± 0.0% | not timed | not timed | 462.14 ± 0.2% | 64.75 ± 3.5% | not timed | not timed | 423.98 ± 0.4% | | 1.00 | 0.92 | 6.54 |
| 09-aws-keys/quick | 0 | 743.88 ± 0.1% | not timed | not timed | 992.33 ± 0.7% | 421.23 ± 1.1% | not timed | not timed | 735.61 ± 0.2% | | 1.01 | 0.75 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 586.51 ± 0.4% | not timed | not timed | 515.86 ± 1.0% | 19.46 ± 0.3% | not timed | not timed | 585.19 ± 0.2% | | 1.00 | 1.14 | 30.14 |
| 10-bounded-repeat/letters-ru | 3475 | 401.86 ± 0.2% | not timed | not timed | 480.67 ± 0.2% | 21.72 ± 8.5% | not timed | not timed | 401.11 ± 0.5% | | 1.00 | 0.84 | 18.51 |
| 10-bounded-repeat/context | 53 | 79.12 ± 1.0% | not timed | not timed | 65.53 ± 0.5% | 19.79 ± 0.2% | not timed | not timed | 79.62 ± 0.8% | | 0.99 | 1.21 | 4.00 |
| 10-bounded-repeat/capitals | 11 | 1047.06 ± 0.1% | not timed | not timed | 617.95 ± 0.2% | 36.64 ± 0.1% | not timed | not timed | 1047.08 ± 0.1% | | 1.00 | 1.69 | 28.58 |
| 11-unstructured-to-json/extract | 600 | 47.71 ± 0.4% | not timed | not timed | 77.51 ± 0.3% | 49.25 ± 0.4% | not timed | not timed | 46.87 ± 0.2% | | 1.02 | 0.62 | 0.97 |
| 12-dictionary/single | 1 | 605.26 ± 0.4% | not timed | not timed | 558.21 ± 0.2% | 0.40 ± 0.2% | not timed | not timed | 603.92 ± 0.4% | | 1.00 | 1.08 | 1502.55 |
| 14-quadratic/1x | 100 | 12.61 ± 0.6% | not timed | not timed | 10.02 ± 0.1% | 0.97 ± 2.3% | not timed | not timed | 12.52 ± 2.0% | | 1.01 | 1.26 | 12.93 |
| 14-quadratic/2x | 200 | 7.83 ± 0.3% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 2.1% | not timed | not timed | 7.82 ± 0.6% | | 1.00 | 1.41 | 14.79 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.5% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.8% | not timed | not timed | 1.86 ± 0.4% | | 1.00 | 1.54 | 16.20 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.2% | not timed | not timed | 0.34 ± 0.2% | 0.54 ± 4.3% | not timed | not timed | 1.53 ± 0.6% | | 1.01 | 4.51 | 2.83 |
| 04-ruff-noqa/compile-real | 1 | 86.93 ± 0.2% | not timed | not timed | 13.77 ± 0.3% | 139.79 ± 2.9% | not timed | not timed | 86.95 ± 0.5% | | 1.00 | 6.32 | 0.62 |
| 05-lexer-veryl/compile-single | 1 | 14.18 ± 0.3% | not timed | not timed | 2.53 ± 0.7% | 6.47 ± 2.4% | not timed | not timed | 14.06 ± 1.3% | | 1.01 | 5.61 | 2.19 |
| 07-unicode-character-data/compile | 1 | 55.52 ± 0.1% | not timed | not timed | 26.02 ± 0.2% | 36.07 ± 2.7% | not timed | not timed | 55.46 ± 1.3% | | 1.00 | 2.13 | 1.54 |
| 09-aws-keys/compile-full | 1 | 42.33 ± 0.2% | not timed | not timed | 8.35 ± 0.3% | 23.25 ± 1.4% | not timed | not timed | 42.18 ± 0.2% | | 1.00 | 5.07 | 1.82 |
| 09-aws-keys/compile-quick | 1 | 189.20 ± 0.2% | not timed | not timed | 48.37 ± 0.2% | 134.32 ± 11.2% | not timed | not timed | 188.99 ± 1.1% | | 1.00 | 3.91 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 14.63 ± 1.2% | not timed | not timed | 11.26 ± 0.3% | 15.97 ± 3.1% | not timed | not timed | 14.45 ± 2.7% | | 1.01 | 1.30 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 84.90 ± 0.4% | not timed | not timed | 8.08 ± 0.3% | 23.65 ± 1.1% | not timed | not timed | 84.34 ± 0.9% | | 1.01 | 10.51 | 3.59 |
| 11-unstructured-to-json/compile | 1 | 86.76 ± 0.6% | not timed | not timed | 40.76 ± 0.6% | 68.15 ± 3.8% | not timed | not timed | 86.52 ± 0.8% | | 1.00 | 2.13 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.07 ± 0.5% | 0.10 ± 10.7% | not timed | not timed | 0.35 ± 1.1% | | 1.00 | 5.08 | 3.68 |

