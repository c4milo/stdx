# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159251544 |
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
| literal: a word | 217 | 32432.90 ± 43.0% | 1089.02 ± 3.4% | 36.21 ± 73.2% | 32831.17 ± 56.0% | 12946.67 ± 2.4% | 13.96 ± 0.6% | 115.52 ± 0.8% | 32401.12 ± 43.4% | 29.78 | 1.00 | 0.99 | 2.51 |
| literal: a word that is not there | 0 | 42021.25 ± 1.9% | 1099.85 ± 0.3% | 36.78 ± 1.9% | 36301.12 ± 0.4% | 40462.02 ± 0.2% | 13.69 ± 0.2% | 108.83 ± 1.0% | 42658.88 ± 0.8% | 38.21 | 0.99 | 1.16 | 1.04 |
| literal: one of four words | 661 | 13421.49 ± 2.2% | 1063.02 ± 0.4% | 19.17 ± 2.2% | 9679.10 ± 0.3% | 29.09 ± 6.0% | 4.32 ± 0.3% | 9.21 ± 0.7% | 13315.24 ± 1.7% | 12.63 | 1.01 | 1.39 | 461.36 |
| literal: a word in any case | 217 | 27712.88 ± 0.8% | 1088.08 ± 0.2% | 25.74 ± 0.5% | 10060.56 ± 0.2% | 58.32 ± 1.0% | refused | differs | 27530.52 ± 1.5% | 25.47 | 1.01 | 2.75 | 475.21 |
| literal: an href attribute | 33 | 28308.74 ± 0.3% | 1097.32 ± 0.6% | 32.11 ± 0.4% | 29288.32 ± 0.7% | 2605.30 ± 0.3% | 10.38 ± 0.2% | 99.46 ± 0.4% | 28283.00 ± 0.2% | 25.80 | 1.00 | 0.97 | 10.87 |
| literal: a word, second text | 123 | 33836.78 ± 0.4% | 1092.28 ± 0.2% | 35.41 ± 0.6% | 32713.05 ± 0.2% | 8973.12 ± 5.0% | 16.38 ± 0.4% | 96.89 ± 0.5% | 33828.18 ± 2.1% | 30.98 | 1.00 | 1.03 | 3.77 |
| class: two capitalized words | 1331 | 1020.51 ± 1.1% | 1009.42 ± 0.3% | 33.27 ± 1.2% | 611.68 ± 0.4% | 48.93 ± 0.4% | 11.97 ± 0.1% | 82.14 ± 1.1% | 1018.73 ± 0.2% | 1.01 | 1.00 | 1.67 | 20.86 |
| class: a word that ends in ing | 3399 | 923.44 ± 0.2% | 922.18 ± 0.2% | 21.30 ± 0.9% | 574.87 ± 0.3% | 35.34 ± 3.9% | 6.67 ± 0.2% | 22.87 ± 0.3% | 922.12 ± 0.2% | 1.00 | 1.00 | 1.61 | 26.13 |
| class: a word in capitals | 2332 | 1390.74 ± 0.4% | 989.24 ± 0.1% | 35.29 ± 1.9% | 602.77 ± 1.5% | 52.72 ± 7.6% | 13.83 ± 0.4% | 101.45 ± 0.2% | 1386.40 ± 0.1% | 1.41 | 1.00 | 2.31 | 26.38 |
| class: a number | 8288 | 1994.70 ± 0.4% | 858.92 ± 0.6% | 34.27 ± 1.4% | 2115.20 ± 1.2% | 55.08 ± 15.4% | 0.42 ± 0.5% | 71.03 ± 0.7% | 1988.92 ± 0.3% | 2.32 | 1.00 | 0.94 | 36.22 |
| class: two capitalized words, second text | 5359 | 751.50 ± 0.3% | 752.19 ± 0.5% | 29.46 ± 1.0% | 504.30 ± 0.5% | 42.07 ± 16.0% | 14.30 ± 0.2% | 74.61 ± 1.6% | 750.32 ± 0.3% | 1.00 | 1.00 | 1.49 | 17.86 |
| other: a word between two words | 6104 | 833.79 ± 0.3% | 793.29 ± 0.6% | 28.92 ± 1.0% | 835.48 ± 1.2% | 127.58 ± 10.8% | 9.21 ± 0.6% | 85.24 ± 0.7% | 836.43 ± 0.5% | 1.05 | 1.00 | 1.00 | 6.54 |
| other: a number before a unit, second text | 1481 | 9362.46 ± 1.6% | 1020.27 ± 0.4% | 32.69 ± 2.3% | 8906.89 ± 2.6% | 49.00 ± 0.9% | 15.03 ± 0.2% | 79.99 ± 0.3% | 9202.76 ± 0.7% | 9.18 | 1.02 | 1.05 | 191.07 |
| other: a heading's start tag | 110 | 20605.35 ± 0.7% | 1084.64 ± 1.0% | 35.02 ± 1.7% | 2693.96 ± 1.5% | 1899.82 ± 6.9% | 12.71 ± 0.5% | 117.04 ± 0.8% | 20635.14 ± 1.2% | 19.00 | 1.00 | 7.65 | 10.85 |
| other: a whole word | 217 | 25408.12 ± 1.9% | 1088.01 ± 0.2% | 37.19 ± 0.8% | 26217.75 ± 0.3% | 60.19 ± 0.5% | 12.13 ± 0.6% | 67.68 ± 0.6% | 25366.69 ± 0.1% | 23.35 | 1.00 | 0.97 | 422.11 |
| other: a line's first word, second text | 3716 | 2536.91 ± 0.6% | 911.77 ± 0.4% | 37.45 ± 2.2% | 2458.56 ± 0.5% | 81.70 ± 3.1% | refused | refused | 2531.20 ± 3.3% | 2.78 | 1.00 | 1.03 | 31.05 |
| other: fourteen octets before an x | 87 | 35657.31 ± 2.4% | 291.30 ± 0.4% | 7.79 ± 0.6% | 4123.23 ± 0.2% | 11.60 ± 0.7% | differs | 20.13 ± 0.8% | 35897.27 ± 1.1% | 122.41 | 0.99 | 8.65 | 3075.19 |
| other: a Greek word | 21815 | 526.62 ± 1.0% | 404.32 ± 0.5% | 36.30 ± 1.3% | 311.51 ± 0.7% | 61.45 ± 13.2% | differs | refused | 525.95 ± 0.8% | 1.30 | 1.00 | 1.69 | 8.57 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.36 ± 0.6% | 29.48 ± 0.6% | 1.07 ± 1.5% | 21.48 ± 0.3% | 3.21 ± 0.7% | differs | 4.92 ± 2.2% | 29.44 ± 0.8% | 1.00 | 1.00 | 1.37 | 9.13 |
| a UUID | 32895 | 26.51 ± 0.4% | 26.47 ± 2.2% | 0.74 ± 1.2% | 16.49 ± 0.3% | 3.25 ± 1.4% | 0.71 ± 1.3% | 4.09 ± 0.6% | 26.47 ± 0.6% | 1.00 | 1.00 | 1.61 | 8.16 |
| an IPv4 address | 33176 | 39.08 ± 3.1% | 39.12 ± 1.0% | 2.41 ± 0.5% | 31.54 ± 0.2% | 8.07 ± 0.8% | differs | 4.65 ± 0.8% | 38.94 ± 0.6% | 1.00 | 1.00 | 1.24 | 4.84 |
| a date and time | 32954 | 39.25 ± 3.2% | 39.43 ± 1.1% | 1.72 ± 0.4% | 23.95 ± 0.2% | 10.26 ± 0.6% | 1.31 ± 0.2% | 9.10 ± 0.7% | 39.36 ± 0.3% | 1.00 | 1.00 | 1.64 | 3.83 |
| a field path | 32606 | 31.61 ± 0.8% | 31.64 ± 2.5% | 1.24 ± 0.6% | 24.79 ± 1.2% | 3.70 ± 2.4% | differs | 3.09 ± 0.5% | 31.53 ± 0.5% | 1.00 | 1.00 | 1.27 | 8.54 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.37 ± 0.3% | 12.31 ± 3.8% | 12.33 ± 0.8% | 14.72 ± 1.0% | 6.81 ± 2.8% | 1.04 ± 0.6% | none | 12.29 ± 1.0% | 1.01 | 1.01 | 0.84 | 1.82 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 279.46 ± 0.3% | 281.39 ± 4.5% | 324.16 ± 0.4% | 116.39 ± 1.4% | 260.59 ± 5.7% | 693.08 ± 1.1% | 4337.11 ± 0.8% | 279.29 ± 0.6% | 0.99 | 1.00 | 2.40 | 1.07 |
| a UUID | 62 | 179.81 ± 0.4% | 181.07 ± 1.0% | 199.61 ± 0.1% | 61.83 ± 1.1% | 119.16 ± 0.4% | 257.59 ± 2.0% | 5723.54 ± 1.4% | 179.98 ± 1.0% | 0.99 | 1.00 | 2.91 | 1.51 |
| an IPv4 address | 29 | 590.72 ± 0.5% | 599.40 ± 0.2% | 836.64 ± 0.6% | 100.10 ± 0.3% | 156.92 ± 1.6% | 432.39 ± 3.2% | 10255.05 ± 0.4% | 590.75 ± 0.6% | 0.99 | 1.00 | 5.90 | 3.76 |
| a date and time | 56 | 456.73 ± 4.3% | 461.87 ± 0.3% | 585.46 ± 0.3% | 96.74 ± 3.4% | 167.32 ± 2.9% | 455.53 ± 0.5% | 5764.18 ± 0.3% | 458.38 ± 0.1% | 0.99 | 1.00 | 4.72 | 2.73 |
| a field path | 39 | 264.42 ± 0.6% | 265.89 ± 0.3% | 304.47 ± 0.7% | 105.38 ± 1.3% | 247.35 ± 18.4% | 710.22 ± 1.9% | 5535.59 ± 0.2% | 264.23 ± 0.5% | 0.99 | 1.00 | 2.51 | 1.07 |
| literal: a word | 7 | 927.55 ± 4.5% | 1017.83 ± 0.3% | 1830.19 ± 0.8% | 694.14 ± 1.2% | 812.10 ± 2.0% | 1426.14 ± 0.3% | 38628.14 ± 0.4% | 927.02 ± 0.5% | 0.91 | 1.00 | 1.34 | 1.14 |
| literal: a word that is not there | 8 | 892.16 ± 0.4% | 984.17 ± 0.6% | 1729.21 ± 0.5% | 627.32 ± 0.5% | 773.62 ± 3.7% | 1360.13 ± 0.5% | 38048.94 ± 0.3% | 890.79 ± 1.0% | 0.91 | 1.00 | 1.42 | 1.15 |
| literal: one of four words | 26 | 350.39 ± 0.3% | 609.91 ± 0.3% | 840.30 ± 4.7% | 50.84 ± 0.8% | 300.32 ± 1.7% | 502.84 ± 1.6% | 21860.75 ± 1.7% | 349.79 ± 3.3% | 0.57 | 1.00 | 6.89 | 1.17 |
| literal: a word in any case | 11 | 691.43 ± 2.8% | 753.36 ± 0.3% | 1132.50 ± 0.7% | 17.78 ± 0.7% | 860.31 ± 12.6% | refused | 31249.44 ± 0.4% | 693.03 ± 0.5% | 0.92 | 1.00 | 38.89 | 0.80 |
| literal: an href attribute | 12 | 469.45 ± 0.5% | 482.13 ± 0.6% | 631.42 ± 1.1% | 50.04 ± 0.2% | 625.52 ± 1.3% | 1156.22 ± 0.4% | 27747.92 ± 3.6% | 469.67 ± 0.5% | 0.97 | 1.00 | 9.38 | 0.75 |
| literal: a word, second text | 10 | 825.32 ± 0.6% | 928.98 ± 0.5% | 1565.27 ± 0.5% | 591.68 ± 0.4% | 673.93 ± 19.7% | 1176.23 ± 0.9% | 35757.36 ± 1.3% | 825.17 ± 0.6% | 0.89 | 1.00 | 1.39 | 1.22 |
| class: two capitalized words | 23 | 660.57 ± 0.4% | 723.91 ± 0.4% | 1067.66 ± 0.4% | 135.47 ± 0.9% | 629.07 ± 17.7% | 1119.84 ± 0.5% | 7768.24 ± 0.2% | 660.23 ± 2.0% | 0.91 | 1.00 | 4.88 | 1.05 |
| class: a word that ends in ing | 9 | 804.85 ± 0.7% | 924.83 ± 0.6% | 1649.86 ± 2.2% | 173.10 ± 0.6% | 933.60 ± 13.0% | 1726.69 ± 1.3% | 20286.00 ± 1.2% | 804.41 ± 0.3% | 0.87 | 1.00 | 4.65 | 0.86 |
| class: a word in capitals | 16 | 727.97 ± 0.2% | 806.05 ± 0.3% | 1338.16 ± 2.1% | 180.96 ± 2.1% | 940.83 ± 1.1% | 1612.73 ± 2.1% | 10300.62 ± 4.0% | 726.57 ± 3.1% | 0.90 | 1.00 | 4.02 | 0.77 |
| class: a number | 6 | 881.68 ± 0.5% | 996.60 ± 0.5% | 1913.35 ± 0.4% | 44.11 ± 1.7% | 1737.39 ± 11.9% | 3007.63 ± 0.8% | 29949.31 ± 0.5% | 880.86 ± 3.9% | 0.88 | 1.00 | 19.99 | 0.51 |
| class: two capitalized words, second text | 23 | 660.51 ± 0.5% | 724.38 ± 0.8% | 1067.72 ± 5.0% | 135.01 ± 0.5% | 635.63 ± 16.1% | 1129.11 ± 3.6% | 7744.36 ± 1.2% | 659.50 ± 1.1% | 0.91 | 1.00 | 4.89 | 1.04 |
| other: a word between two words | 13 | 794.07 ± 0.4% | 829.69 ± 3.9% | 1336.88 ± 0.7% | 180.94 ± 0.8% | 625.07 ± 1.8% | 1223.17 ± 2.5% | 18480.26 ± 1.0% | 791.46 ± 0.8% | 0.96 | 1.00 | 4.39 | 1.27 |
| other: a number before a unit, second text | 15 | 524.76 ± 0.7% | 584.34 ± 0.7% | 797.28 ± 0.9% | 41.46 ± 0.9% | 791.07 ± 1.7% | 1355.68 ± 1.6% | 19798.64 ± 0.7% | 525.19 ± 0.8% | 0.90 | 1.00 | 12.66 | 0.66 |
| other: a heading's start tag | 13 | 479.90 ± 0.5% | 489.25 ± 0.7% | 640.61 ± 1.1% | 47.76 ± 0.4% | 768.61 ± 1.0% | 1306.26 ± 0.8% | 23418.71 ± 0.5% | 480.31 ± 0.3% | 0.98 | 1.00 | 10.05 | 0.62 |
| other: a whole word | 11 | 838.13 ± 0.7% | 900.92 ± 0.4% | 1483.49 ± 0.7% | 160.60 ± 0.6% | 716.80 ± 10.2% | 1251.61 ± 2.5% | 34171.32 ± 0.5% | 837.48 ± 0.4% | 0.93 | 1.00 | 5.22 | 1.17 |
| other: a line's first word, second text | 17 | 761.79 ± 0.9% | 802.67 ± 0.6% | 1305.97 ± 0.5% | 172.64 ± 0.7% | 873.31 ± 11.8% | refused | refused | 762.56 ± 0.3% | 0.95 | 1.00 | 4.41 | 0.87 |
| other: fourteen octets before an x | 16 | 134.47 ± 0.7% | 194.29 ± 1.1% | 224.66 ± 0.7% | 18.61 ± 0.7% | 547.86 ± 1.4% | 588.32 ± 0.6% | 16596.80 ± 0.8% | 134.28 ± 1.4% | 0.69 | 1.00 | 7.22 | 0.25 |
| other: a Greek word | 8 | 571.73 ± 0.5% | 792.53 ± 1.1% | 1259.72 ± 6.1% | 60.86 ± 0.9% | 1710.30 ± 10.5% | 2832.25 ± 1.4% | refused | 571.70 ± 0.6% | 0.72 | 1.00 | 9.39 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 24148.80 ± 1.1% | not timed | not timed | 28616.73 ± 1.7% | 2677.78 ± 8.6% | not timed | not timed | 24048.45 ± 2.1% | | 1.00 | 0.84 | 9.02 |
| 01-literal/sherlock-casei-en | 522 | 7509.31 ± 1.2% | not timed | not timed | 8410.57 ± 0.3% | 40.01 ± 6.4% | not timed | not timed | 7453.42 ± 0.4% | | 1.01 | 0.89 | 187.67 |
| 01-literal/sherlock-ru | 724 | 24110.55 ± 1.1% | not timed | not timed | 27349.51 ± 0.9% | 1547.50 ± 6.5% | not timed | not timed | 24270.73 ± 1.1% | | 0.99 | 0.88 | 15.58 |
| 01-literal/sherlock-casei-ru | 746 | 8190.35 ± 0.5% | not timed | not timed | 6471.74 ± 0.8% | 42.32 ± 4.2% | not timed | not timed | 8190.53 ± 0.5% | | 1.00 | 1.27 | 193.53 |
| 01-literal/sherlock-zh | 30 | 38149.31 ± 0.9% | not timed | not timed | 35099.24 ± 0.9% | 1593.16 ± 1.8% | not timed | not timed | 38309.36 ± 1.2% | | 1.00 | 1.09 | 23.95 |
| 02-literal-alternate/sherlock-en | 714 | 12102.00 ± 4.4% | not timed | not timed | 9373.07 ± 0.3% | 22.26 ± 9.8% | not timed | not timed | 12025.34 ± 1.0% | | 1.01 | 1.29 | 543.66 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2037.30 ± 3.0% | not timed | not timed | 2294.54 ± 0.7% | 13.59 ± 0.8% | not timed | not timed | 2027.40 ± 0.7% | | 1.00 | 0.89 | 149.88 |
| 02-literal-alternate/sherlock-ru | 899 | 6769.98 ± 0.8% | not timed | not timed | 5103.07 ± 1.1% | 28.76 ± 1.0% | not timed | not timed | 6770.06 ± 1.1% | | 1.00 | 1.33 | 235.40 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2144.95 ± 2.4% | not timed | not timed | 1243.98 ± 0.5% | 11.68 ± 2.5% | not timed | not timed | 2148.76 ± 0.8% | | 1.00 | 1.72 | 183.62 |
| 02-literal-alternate/sherlock-zh | 207 | 16437.96 ± 1.0% | not timed | not timed | 10701.88 ± 0.8% | 41.28 ± 6.1% | not timed | not timed | 16438.53 ± 0.7% | | 1.00 | 1.54 | 398.17 |
| 03-date/ascii | 111817 | 128.39 ± 1.0% | not timed | not timed | 109.74 ± 0.5% | 0.27 ± 2.0% | not timed | not timed | 127.83 ± 1.2% | | 1.00 | 1.17 | 472.34 |
| 04-ruff-noqa/real | 84 | 728.83 ± 2.1% | not timed | not timed | 566.17 ± 1.2% | 25.64 ± 1.7% | not timed | not timed | 733.91 ± 2.3% | | 0.99 | 1.29 | 28.43 |
| 04-ruff-noqa/tweaked | 44 | 625.28 ± 0.8% | not timed | not timed | 563.41 ± 0.3% | 401.13 ± 12.8% | not timed | not timed | 624.13 ± 0.7% | | 1.00 | 1.11 | 1.56 |
| 05-lexer-veryl/single | 124800 | 4.40 ± 0.5% | not timed | not timed | 5.88 ± 0.4% | 0.27 ± 2.4% | not timed | not timed | 4.41 ± 0.6% | | 1.00 | 0.75 | 16.15 |
| 06-cloud-flare-redos/original | 107 | 282.45 ± 1.4% | not timed | not timed | 261.82 ± 0.1% | 31.87 ± 3.7% | not timed | not timed | 281.97 ± 10.2% | | 1.00 | 1.08 | 8.86 |
| 06-cloud-flare-redos/simplified-short | 102 | 252.09 ± 1.7% | not timed | not timed | 267.12 ± 0.2% | 34.96 ± 1.3% | not timed | not timed | 251.18 ± 0.7% | | 1.00 | 0.94 | 7.21 |
| 06-cloud-flare-redos/simplified-long | 10000 | 271.06 ± 0.4% | not timed | not timed | 279.73 ± 0.5% | 38.26 ± 0.2% | not timed | not timed | 270.80 ± 0.2% | | 1.00 | 0.97 | 7.08 |
| 07-unicode-character-data/parse-line | 558784 | 269.40 ± 1.3% | not timed | not timed | 208.27 ± 2.3% | 53.77 ± 1.2% | not timed | not timed | 269.23 ± 0.6% | | 1.00 | 1.29 | 5.01 |
| 08-words/all-english | 56691 | 115.25 ± 0.5% | not timed | not timed | 92.87 ± 0.3% | 15.14 ± 6.8% | not timed | not timed | 115.24 ± 0.7% | | 1.00 | 1.24 | 7.61 |
| 08-words/long-english | 839 | 1048.36 ± 0.5% | not timed | not timed | 622.11 ± 0.8% | 37.81 ± 0.7% | not timed | not timed | 1048.15 ± 0.5% | | 1.00 | 1.69 | 27.73 |
| 09-aws-keys/full | 0 | 569.66 ± 0.8% | not timed | not timed | 572.82 ± 0.2% | 83.10 ± 6.0% | not timed | not timed | 569.14 ± 1.0% | | 1.00 | 0.99 | 6.85 |
| 09-aws-keys/quick | 0 | 1120.56 ± 2.4% | not timed | not timed | 907.73 ± 1.8% | 527.68 ± 18.5% | not timed | not timed | 1116.40 ± 3.3% | | 1.00 | 1.23 | 2.12 |
| 10-bounded-repeat/letters-en | 1833 | 623.07 ± 0.7% | not timed | not timed | 549.20 ± 0.7% | 24.10 ± 2.8% | not timed | not timed | 623.33 ± 0.8% | | 1.00 | 1.13 | 25.85 |
| 10-bounded-repeat/letters-ru | 3475 | 390.66 ± 0.3% | not timed | not timed | 494.01 ± 0.8% | 25.64 ± 9.0% | not timed | not timed | 389.55 ± 0.2% | | 1.00 | 0.79 | 15.24 |
| 10-bounded-repeat/context | 53 | 90.86 ± 1.5% | not timed | not timed | 73.65 ± 1.3% | 24.23 ± 0.2% | not timed | not timed | 90.95 ± 0.7% | | 1.00 | 1.23 | 3.75 |
| 10-bounded-repeat/capitals | 11 | 1089.45 ± 0.3% | not timed | not timed | 641.21 ± 0.1% | 44.35 ± 0.4% | not timed | not timed | 1088.54 ± 0.1% | | 1.00 | 1.70 | 24.57 |
| 11-unstructured-to-json/extract | 600 | 49.26 ± 0.2% | not timed | not timed | 80.51 ± 0.4% | 64.39 ± 4.1% | not timed | not timed | 49.19 ± 0.6% | | 1.00 | 0.61 | 0.76 |
| 12-dictionary/single | 1 | 569.15 ± 0.7% | not timed | not timed | 545.27 ± 0.7% | 0.52 ± 3.8% | not timed | not timed | 572.36 ± 0.1% | | 0.99 | 1.04 | 1094.92 |
| 14-quadratic/1x | 100 | 14.07 ± 0.3% | not timed | not timed | 13.51 ± 0.2% | 1.26 ± 4.9% | not timed | not timed | 14.06 ± 0.2% | | 1.00 | 1.04 | 11.20 |
| 14-quadratic/2x | 200 | 8.50 ± 1.1% | not timed | not timed | 6.61 ± 0.2% | 0.70 ± 0.9% | not timed | not timed | 8.49 ± 0.2% | | 1.00 | 1.29 | 12.20 |
| 14-quadratic/10x | 1000 | 1.93 ± 0.2% | not timed | not timed | 1.29 ± 0.6% | 0.15 ± 1.0% | not timed | not timed | 1.93 ± 0.4% | | 1.00 | 1.49 | 12.66 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.02 ± 0.2% | not timed | not timed | 0.44 ± 3.5% | 0.67 ± 3.6% | not timed | not timed | 2.02 ± 4.8% | | 1.00 | 4.55 | 3.03 |
| 04-ruff-noqa/compile-real | 1 | 130.91 ± 0.4% | not timed | not timed | 15.92 ± 0.4% | 176.19 ± 2.1% | not timed | not timed | 130.35 ± 0.9% | | 1.00 | 8.22 | 0.74 |
| 05-lexer-veryl/compile-single | 1 | 21.55 ± 0.3% | not timed | not timed | 3.05 ± 0.7% | 7.84 ± 2.3% | not timed | not timed | 21.60 ± 7.5% | | 1.00 | 7.07 | 2.75 |
| 07-unicode-character-data/compile | 1 | 78.68 ± 1.3% | not timed | not timed | 31.96 ± 0.1% | 44.01 ± 1.1% | not timed | not timed | 78.54 ± 1.0% | | 1.00 | 2.46 | 1.79 |
| 09-aws-keys/compile-full | 1 | 53.21 ± 0.2% | not timed | not timed | 9.03 ± 4.4% | 28.28 ± 1.9% | not timed | not timed | 53.67 ± 3.8% | | 0.99 | 5.89 | 1.88 |
| 09-aws-keys/compile-quick | 1 | 242.53 ± 0.5% | not timed | not timed | 60.39 ± 0.2% | 165.35 ± 1.8% | not timed | not timed | 240.51 ± 0.6% | | 1.01 | 4.02 | 1.47 |
| 10-bounded-repeat/compile-context | 1 | 16.70 ± 0.3% | not timed | not timed | 14.54 ± 0.9% | 20.77 ± 5.5% | not timed | not timed | 16.72 ± 1.3% | | 1.00 | 1.15 | 0.80 |
| 10-bounded-repeat/compile-capitals | 1 | 102.16 ± 0.5% | not timed | not timed | 10.91 ± 0.3% | 29.44 ± 1.5% | not timed | not timed | 103.00 ± 0.2% | | 0.99 | 9.36 | 3.47 |
| 11-unstructured-to-json/compile | 1 | 119.67 ± 1.0% | not timed | not timed | 50.65 ± 0.7% | 83.30 ± 2.5% | not timed | not timed | 119.46 ± 1.3% | | 1.00 | 2.36 | 1.44 |
| 12-dictionary/compile-single | 1 | 0.37 ± 3.3% | not timed | not timed | 0.08 ± 2.7% | 0.11 ± 20.8% | not timed | not timed | 0.37 ± 1.0% | | 1.01 | 4.65 | 3.46 |

