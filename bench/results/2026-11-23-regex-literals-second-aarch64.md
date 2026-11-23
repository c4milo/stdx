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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243460149 |
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
| literal: a word | 217 | 18445.13 ± 6.8% | 4995.25 ± 0.2% | 28.31 ± 0.4% | 17791.61 ± 4.0% | 9083.55 ± 7.6% | 17.43 ± 0.1% | 84.31 ± 0.7% | 18296.14 ± 7.9% | 3.69 | 1.01 | 1.04 | 2.03 |
| literal: a word that is not there | 0 | 20007.93 ± 2.7% | 4879.30 ± 0.3% | 28.35 ± 0.3% | 18918.95 ± 2.7% | 27148.95 ± 3.6% | 17.18 ± 0.3% | 79.69 ± 0.9% | 19990.52 ± 7.3% | 4.10 | 1.00 | 1.06 | 0.74 |
| literal: one of four words | 661 | 6378.75 ± 0.5% | 1933.51 ± 0.1% | 14.43 ± 0.2% | 3948.67 ± 0.3% | 21.86 ± 0.2% | 5.44 ± 0.4% | 6.88 ± 1.2% | 6357.41 ± 0.3% | 3.30 | 1.00 | 1.62 | 291.76 |
| literal: a word in any case | 217 | 14981.24 ± 1.0% | 2076.90 ± 0.2% | 21.44 ± 0.4% | 3973.29 ± 0.2% | 38.12 ± 0.4% | refused | differs | 14942.89 ± 0.8% | 7.21 | 1.00 | 3.77 | 393.01 |
| literal: an href attribute | 33 | 16232.06 ± 0.7% | 607.12 ± 0.8% | 27.40 ± 0.3% | 16028.79 ± 0.8% | 2265.47 ± 0.6% | 13.17 ± 0.3% | 74.02 ± 1.9% | 16210.50 ± 0.8% | 26.74 | 1.00 | 1.01 | 7.16 |
| literal: a word, second text | 123 | 18926.25 ± 5.8% | 3356.37 ± 0.2% | 28.09 ± 0.2% | 17528.27 ± 1.5% | 7498.03 ± 5.2% | 20.17 ± 0.4% | 70.25 ± 0.5% | 19711.22 ± 4.0% | 5.64 | 0.96 | 1.08 | 2.52 |
| class: two capitalized words | 1331 | 1056.20 ± 0.1% | 597.31 ± 0.6% | 25.99 ± 0.5% | 585.13 ± 0.1% | 40.64 ± 7.2% | 14.78 ± 0.4% | 67.06 ± 1.7% | 1057.22 ± 0.2% | 1.77 | 1.00 | 1.81 | 25.99 |
| class: a word that ends in ing | 3399 | 572.61 ± 0.2% | 572.36 ± 0.5% | 18.03 ± 0.2% | 547.15 ± 0.1% | 29.59 ± 5.6% | 8.20 ± 0.2% | 18.17 ± 1.0% | 571.75 ± 0.4% | 1.00 | 1.00 | 1.05 | 19.35 |
| class: a word in capitals | 2332 | 1370.65 ± 0.4% | 602.75 ± 0.4% | 27.64 ± 0.5% | 572.63 ± 0.1% | 43.61 ± 2.7% | 17.22 ± 0.3% | 82.62 ± 0.1% | 1368.55 ± 0.4% | 2.27 | 1.00 | 2.39 | 31.43 |
| class: a number | 8288 | 1959.35 ± 0.4% | 828.01 ± 0.2% | 27.86 ± 0.9% | 1711.96 ± 0.1% | 42.34 ± 10.7% | 0.54 ± 0.5% | 57.81 ± 0.4% | 1953.51 ± 0.4% | 2.37 | 1.00 | 1.14 | 46.28 |
| class: two capitalized words, second text | 5359 | 516.18 ± 0.2% | 524.03 ± 0.1% | 23.35 ± 0.2% | 484.81 ± 0.1% | 35.27 ± 12.1% | 17.12 ± 0.2% | 62.57 ± 1.9% | 515.75 ± 0.2% | 0.99 | 1.00 | 1.06 | 14.63 |
| other: a word between two words | 6104 | 790.74 ± 0.3% | 593.88 ± 0.1% | 23.55 ± 0.3% | 738.48 ± 0.2% | 108.14 ± 21.0% | 11.22 ± 0.2% | 68.06 ± 1.7% | 791.21 ± 0.2% | 1.33 | 1.00 | 1.07 | 7.31 |
| other: a number before a unit, second text | 1481 | 5965.49 ± 1.6% | 1121.28 ± 0.4% | 26.02 ± 0.1% | 5607.43 ± 0.8% | 40.90 ± 0.3% | 18.24 ± 0.1% | 64.94 ± 0.4% | 5923.32 ± 1.9% | 5.32 | 1.01 | 1.06 | 145.84 |
| other: a heading's start tag | 110 | 13667.35 ± 1.9% | 741.98 ± 0.3% | 27.48 ± 0.3% | 1712.67 ± 0.3% | 1585.17 ± 2.5% | 16.17 ± 0.5% | 85.58 ± 0.4% | 13629.82 ± 0.8% | 18.42 | 1.00 | 7.98 | 8.62 |
| other: a whole word | 217 | 15334.06 ± 2.5% | 597.38 ± 1.1% | 29.43 ± 0.2% | 14086.55 ± 3.3% | 49.53 ± 0.2% | 13.38 ± 0.1% | 55.09 ± 1.4% | 15206.12 ± 2.5% | 25.67 | 1.01 | 1.09 | 309.58 |
| other: a line's first word, second text | 3716 | 2049.06 ± 0.5% | 586.82 ± 0.2% | 31.08 ± 0.3% | 1725.66 ± 0.3% | 62.23 ± 6.6% | refused | refused | 2042.98 ± 0.9% | 3.49 | 1.00 | 1.19 | 32.93 |
| other: fourteen octets before an x | 87 | 21912.05 ± 6.9% | 234.11 ± 0.4% | 6.55 ± 0.1% | 3919.78 ± 0.8% | 10.66 ± 0.1% | differs | 17.74 ± 0.4% | 21684.55 ± 5.3% | 93.60 | 1.01 | 5.59 | 2056.25 |
| other: a Greek word | 21815 | 486.81 ± 0.5% | 407.95 ± 0.1% | 30.90 ± 0.1% | 290.54 ± 0.3% | 49.42 ± 10.5% | differs | refused | 485.91 ± 0.4% | 1.19 | 1.00 | 1.68 | 9.85 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.41 ± 0.3% | 18.47 ± 0.2% | 0.86 ± 0.3% | 19.79 ± 0.6% | 2.76 ± 0.4% | differs | 4.00 ± 0.1% | 18.48 ± 0.2% | 1.00 | 1.00 | 0.93 | 6.66 |
| a UUID | 32895 | 20.10 ± 0.2% | 20.08 ± 0.1% | 0.64 ± 0.2% | 15.08 ± 0.6% | 3.11 ± 0.2% | 0.73 ± 0.4% | 3.65 ± 0.6% | 20.02 ± 0.2% | 1.00 | 1.00 | 1.33 | 6.46 |
| an IPv4 address | 33176 | 33.63 ± 0.2% | 33.65 ± 0.6% | 2.07 ± 0.7% | 29.23 ± 0.5% | 6.62 ± 0.4% | differs | 4.16 ± 0.2% | 33.62 ± 0.2% | 1.00 | 1.00 | 1.15 | 5.08 |
| a date and time | 32954 | 28.82 ± 0.2% | 28.85 ± 0.1% | 1.43 ± 0.4% | 21.40 ± 0.7% | 7.03 ± 0.2% | 1.25 ± 0.2% | 7.21 ± 0.4% | 28.83 ± 0.4% | 1.00 | 1.00 | 1.35 | 4.10 |
| a field path | 32606 | 21.78 ± 0.2% | 21.77 ± 0.3% | 1.02 ± 0.4% | 23.25 ± 0.5% | 3.50 ± 0.2% | differs | 2.94 ± 0.2% | 21.76 ± 0.1% | 1.00 | 1.00 | 0.94 | 6.22 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.10 ± 0.3% | 11.12 ± 0.3% | 11.09 ± 0.3% | 11.72 ± 0.1% | 4.94 ± 1.1% | 0.94 ± 0.2% | none | 11.12 ± 0.2% | 1.00 | 1.00 | 0.95 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 233.82 ± 0.4% | 234.77 ± 0.3% | 276.01 ± 0.2% | 87.02 ± 0.7% | 219.91 ± 1.8% | 480.71 ± 0.1% | 3822.48 ± 0.4% | 233.88 ± 0.2% | 1.00 | 1.00 | 2.69 | 1.06 |
| a UUID | 62 | 151.98 ± 0.2% | 152.26 ± 0.2% | 169.21 ± 0.3% | 45.81 ± 0.9% | 96.72 ± 1.8% | 185.76 ± 1.9% | 4299.67 ± 0.3% | 151.86 ± 0.1% | 1.00 | 1.00 | 3.32 | 1.57 |
| an IPv4 address | 29 | 429.34 ± 0.3% | 432.56 ± 0.6% | 597.65 ± 0.4% | 78.26 ± 0.1% | 129.88 ± 1.2% | 297.09 ± 0.6% | 7628.96 ± 0.3% | 429.54 ± 0.2% | 0.99 | 1.00 | 5.49 | 3.31 |
| a date and time | 56 | 306.91 ± 0.4% | 308.66 ± 0.2% | 384.49 ± 0.4% | 73.10 ± 1.1% | 135.31 ± 2.8% | 326.46 ± 1.2% | 4955.20 ± 0.9% | 307.00 ± 0.3% | 0.99 | 1.00 | 4.20 | 2.27 |
| a field path | 39 | 228.72 ± 0.2% | 229.71 ± 0.0% | 269.52 ± 0.1% | 80.08 ± 0.7% | 203.58 ± 0.9% | 492.97 ± 0.4% | 4862.96 ± 0.5% | 228.69 ± 0.4% | 1.00 | 1.00 | 2.86 | 1.12 |
| literal: a word | 7 | 635.78 ± 0.5% | 689.47 ± 0.3% | 1218.45 ± 0.2% | 492.55 ± 0.2% | 622.24 ± 3.3% | 956.93 ± 0.3% | 29214.44 ± 0.4% | 636.43 ± 0.4% | 0.92 | 1.00 | 1.29 | 1.02 |
| literal: a word that is not there | 8 | 617.44 ± 0.5% | 675.93 ± 0.3% | 1170.80 ± 0.3% | 453.05 ± 0.1% | 599.76 ± 1.6% | 904.39 ± 0.4% | 29523.22 ± 0.3% | 617.58 ± 0.8% | 0.91 | 1.00 | 1.36 | 1.03 |
| literal: one of four words | 26 | 246.99 ± 0.6% | 400.00 ± 0.3% | 534.95 ± 0.5% | 50.83 ± 0.7% | 241.82 ± 2.0% | 368.46 ± 0.4% | 15910.53 ± 0.1% | 246.97 ± 0.4% | 0.62 | 1.00 | 4.86 | 1.02 |
| literal: a word in any case | 11 | 448.56 ± 0.2% | 480.78 ± 0.5% | 692.39 ± 0.2% | 15.59 ± 0.4% | 646.35 ± 0.7% | refused | 22529.04 ± 0.5% | 448.19 ± 0.2% | 0.93 | 1.00 | 28.77 | 0.69 |
| literal: an href attribute | 12 | 348.86 ± 0.4% | 362.80 ± 0.3% | 470.29 ± 0.2% | 45.28 ± 0.2% | 497.59 ± 2.0% | 776.48 ± 0.4% | 22078.88 ± 0.4% | 348.61 ± 0.2% | 0.96 | 1.00 | 7.71 | 0.70 |
| literal: a word, second text | 10 | 572.88 ± 0.5% | 635.05 ± 0.4% | 1052.67 ± 0.2% | 401.08 ± 0.2% | 528.73 ± 1.4% | 805.89 ± 0.3% | 27430.35 ± 0.2% | 572.71 ± 0.4% | 0.90 | 1.00 | 1.43 | 1.08 |
| class: two capitalized words | 23 | 445.75 ± 0.3% | 475.58 ± 0.5% | 683.58 ± 0.2% | 100.02 ± 0.4% | 502.28 ± 1.5% | 744.63 ± 0.4% | 6483.29 ± 0.3% | 446.29 ± 0.4% | 0.94 | 1.00 | 4.46 | 0.89 |
| class: a word that ends in ing | 9 | 579.70 ± 0.3% | 650.30 ± 0.3% | 1126.80 ± 0.1% | 132.52 ± 0.8% | 756.76 ± 1.1% | 1090.68 ± 2.2% | 16037.11 ± 0.4% | 579.74 ± 0.2% | 0.89 | 1.00 | 4.37 | 0.77 |
| class: a word in capitals | 16 | 509.55 ± 0.3% | 549.63 ± 0.4% | 876.68 ± 0.3% | 135.98 ± 1.5% | 751.67 ± 0.9% | 1004.89 ± 0.6% | 8541.70 ± 0.6% | 509.75 ± 0.2% | 0.93 | 1.00 | 3.75 | 0.68 |
| class: a number | 6 | 645.46 ± 0.2% | 713.37 ± 0.6% | 1330.27 ± 0.1% | 41.78 ± 0.9% | 1396.87 ± 0.5% | 1849.58 ± 0.5% | 22794.61 ± 0.2% | 644.85 ± 0.2% | 0.90 | 1.00 | 15.45 | 0.46 |
| class: two capitalized words, second text | 23 | 446.28 ± 0.2% | 475.81 ± 0.2% | 683.80 ± 0.1% | 101.43 ± 0.1% | 500.56 ± 1.3% | 734.74 ± 0.2% | 6492.22 ± 0.3% | 445.30 ± 0.3% | 0.94 | 1.00 | 4.40 | 0.89 |
| other: a word between two words | 13 | 556.89 ± 0.4% | 581.17 ± 1.0% | 916.51 ± 0.5% | 132.58 ± 0.2% | 499.86 ± 0.9% | 809.96 ± 0.7% | 14912.41 ± 0.1% | 556.86 ± 0.6% | 0.96 | 1.00 | 4.20 | 1.11 |
| other: a number before a unit, second text | 15 | 402.90 ± 0.3% | 441.19 ± 0.3% | 613.12 ± 0.1% | 39.42 ± 0.4% | 631.18 ± 0.6% | 882.76 ± 0.2% | 15134.07 ± 0.7% | 402.55 ± 0.5% | 0.91 | 1.00 | 10.22 | 0.64 |
| other: a heading's start tag | 13 | 360.06 ± 0.4% | 367.52 ± 0.6% | 480.75 ± 0.3% | 43.86 ± 0.4% | 624.85 ± 0.7% | 865.97 ± 0.5% | 18359.16 ± 0.5% | 360.00 ± 0.4% | 0.98 | 1.00 | 8.21 | 0.58 |
| other: a whole word | 11 | 585.26 ± 0.3% | 628.26 ± 0.5% | 1036.29 ± 0.7% | 117.90 ± 0.3% | 567.84 ± 1.4% | 831.84 ± 1.3% | 27232.70 ± 0.5% | 584.71 ± 0.4% | 0.93 | 1.00 | 4.96 | 1.03 |
| other: a line's first word, second text | 17 | 537.71 ± 0.3% | 564.84 ± 0.4% | 895.27 ± 0.1% | 131.13 ± 0.2% | 711.26 ± 0.7% | refused | refused | 535.90 ± 0.7% | 0.95 | 1.00 | 4.10 | 0.76 |
| other: fourteen octets before an x | 16 | 107.87 ± 0.6% | 154.64 ± 0.5% | 176.07 ± 1.3% | 15.05 ± 0.8% | 452.06 ± 0.5% | 418.00 ± 0.4% | 12919.87 ± 0.5% | 107.94 ± 0.3% | 0.70 | 1.00 | 7.17 | 0.24 |
| other: a Greek word | 8 | 460.84 ± 0.5% | 616.85 ± 0.3% | 1038.41 ± 0.3% | 58.98 ± 0.6% | 1383.76 ± 0.5% | 1863.91 ± 0.4% | refused | 460.99 ± 0.2% | 0.75 | 1.00 | 7.81 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15336.43 ± 0.7% | not timed | not timed | 15984.06 ± 1.3% | 2126.73 ± 17.1% | not timed | not timed | 15249.43 ± 1.3% | | 1.01 | 0.96 | 7.21 |
| 01-literal/sherlock-casei-en | 522 | 5171.73 ± 1.2% | not timed | not timed | 3592.89 ± 0.2% | 32.55 ± 0.4% | not timed | not timed | 5158.57 ± 0.5% | | 1.00 | 1.44 | 158.89 |
| 01-literal/sherlock-ru | 724 | 17107.25 ± 0.8% | not timed | not timed | 17289.04 ± 0.5% | 1446.77 ± 18.1% | not timed | not timed | 17093.93 ± 0.5% | | 1.00 | 0.99 | 11.82 |
| 01-literal/sherlock-casei-ru | 746 | 6172.11 ± 0.2% | not timed | not timed | 3318.65 ± 0.1% | 30.92 ± 0.6% | not timed | not timed | 6183.35 ± 0.1% | | 1.00 | 1.86 | 199.65 |
| 01-literal/sherlock-zh | 30 | 19281.25 ± 1.3% | not timed | not timed | 18172.19 ± 1.0% | 2603.84 ± 8.9% | not timed | not timed | 19174.18 ± 0.5% | | 1.01 | 1.06 | 7.40 |
| 02-literal-alternate/sherlock-en | 714 | 6058.01 ± 0.4% | not timed | not timed | 3945.51 ± 0.1% | 16.62 ± 0.1% | not timed | not timed | 6054.99 ± 0.1% | | 1.00 | 1.54 | 364.46 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1934.59 ± 1.4% | not timed | not timed | 698.09 ± 0.2% | 11.12 ± 0.1% | not timed | not timed | 1926.62 ± 0.7% | | 1.00 | 2.77 | 173.99 |
| 02-literal-alternate/sherlock-ru | 899 | 5569.74 ± 0.1% | not timed | not timed | 3256.99 ± 0.1% | 22.60 ± 3.8% | not timed | not timed | 5566.42 ± 0.5% | | 1.00 | 1.71 | 246.50 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2056.19 ± 0.3% | not timed | not timed | 1232.91 ± 0.1% | 9.07 ± 0.3% | not timed | not timed | 2052.41 ± 0.4% | | 1.00 | 1.67 | 226.77 |
| 02-literal-alternate/sherlock-zh | 207 | 7275.15 ± 0.9% | not timed | not timed | 4168.74 ± 0.1% | 31.52 ± 0.4% | not timed | not timed | 7289.33 ± 0.1% | | 1.00 | 1.75 | 230.79 |
| 03-date/ascii | 111817 | 123.85 ± 0.5% | not timed | not timed | 96.08 ± 0.1% | 0.21 ± 4.2% | not timed | not timed | 123.64 ± 1.2% | | 1.00 | 1.29 | 597.99 |
| 04-ruff-noqa/real | 84 | 402.33 ± 0.1% | not timed | not timed | 466.76 ± 0.2% | 19.67 ± 0.6% | not timed | not timed | 402.32 ± 0.1% | | 1.00 | 0.86 | 20.45 |
| 04-ruff-noqa/tweaked | 44 | 558.90 ± 0.1% | not timed | not timed | 444.86 ± 0.2% | 371.79 ± 1.0% | not timed | not timed | 560.04 ± 0.1% | | 1.00 | 1.26 | 1.50 |
| 05-lexer-veryl/single | 124800 | 5.34 ± 0.2% | not timed | not timed | 5.22 ± 0.1% | 0.20 ± 4.5% | not timed | not timed | 5.35 ± 0.4% | | 1.00 | 1.02 | 26.11 |
| 06-cloud-flare-redos/original | 107 | 415.41 ± 0.2% | not timed | not timed | 216.64 ± 0.1% | 24.94 ± 0.1% | not timed | not timed | 415.97 ± 0.1% | | 1.00 | 1.92 | 16.66 |
| 06-cloud-flare-redos/simplified-short | 102 | 411.17 ± 0.2% | not timed | not timed | 228.40 ± 0.1% | 26.73 ± 0.0% | not timed | not timed | 411.87 ± 0.2% | | 1.00 | 1.80 | 15.39 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.86 ± 0.2% | not timed | not timed | 254.61 ± 0.2% | 28.80 ± 0.1% | not timed | not timed | 583.37 ± 0.1% | | 1.00 | 2.29 | 20.28 |
| 07-unicode-character-data/parse-line | 558784 | 231.46 ± 0.2% | not timed | not timed | 180.32 ± 0.0% | 42.93 ± 5.0% | not timed | not timed | 231.13 ± 2.9% | | 1.00 | 1.28 | 5.39 |
| 08-words/all-english | 56691 | 116.97 ± 0.3% | not timed | not timed | 83.34 ± 0.5% | 12.71 ± 10.9% | not timed | not timed | 116.73 ± 0.4% | | 1.00 | 1.40 | 9.20 |
| 08-words/long-english | 839 | 613.40 ± 0.5% | not timed | not timed | 597.26 ± 0.3% | 32.53 ± 0.4% | not timed | not timed | 613.93 ± 0.5% | | 1.00 | 1.03 | 18.86 |
| 09-aws-keys/full | 0 | 408.44 ± 0.1% | not timed | not timed | 494.70 ± 0.1% | 64.66 ± 2.1% | not timed | not timed | 408.24 ± 0.1% | | 1.00 | 0.83 | 6.32 |
| 09-aws-keys/quick | 0 | 953.65 ± 0.1% | not timed | not timed | 1004.24 ± 0.2% | 425.80 ± 0.8% | not timed | not timed | 953.40 ± 0.1% | | 1.00 | 0.95 | 2.24 |
| 10-bounded-repeat/letters-en | 1833 | 579.03 ± 0.4% | not timed | not timed | 519.11 ± 0.3% | 19.61 ± 0.1% | not timed | not timed | 577.32 ± 0.8% | | 1.00 | 1.12 | 29.52 |
| 10-bounded-repeat/letters-ru | 3475 | 507.95 ± 1.2% | not timed | not timed | 478.34 ± 0.1% | 23.66 ± 4.2% | not timed | not timed | 506.23 ± 1.5% | | 1.00 | 1.06 | 21.47 |
| 10-bounded-repeat/context | 53 | 77.78 ± 0.3% | not timed | not timed | 66.10 ± 0.6% | 19.71 ± 0.4% | not timed | not timed | 77.69 ± 0.4% | | 1.00 | 1.18 | 3.95 |
| 10-bounded-repeat/capitals | 11 | 635.75 ± 8.3% | not timed | not timed | 616.95 ± 0.1% | 36.42 ± 0.1% | not timed | not timed | 635.72 ± 8.3% | | 1.00 | 1.03 | 17.46 |
| 11-unstructured-to-json/extract | 600 | 79.45 ± 0.1% | not timed | not timed | 76.73 ± 0.2% | 49.43 ± 3.5% | not timed | not timed | 81.01 ± 0.1% | | 0.98 | 1.04 | 1.61 |
| 12-dictionary/single | 1 | 559.74 ± 0.3% | not timed | not timed | 559.58 ± 0.1% | 0.41 ± 0.3% | not timed | not timed | 558.99 ± 0.3% | | 1.00 | 1.00 | 1375.26 |
| 14-quadratic/1x | 100 | 21.33 ± 1.4% | not timed | not timed | 9.98 ± 0.2% | 0.97 ± 3.3% | not timed | not timed | 21.32 ± 1.2% | | 1.00 | 2.14 | 21.99 |
| 14-quadratic/2x | 200 | 17.49 ± 0.3% | not timed | not timed | 5.54 ± 0.2% | 0.53 ± 1.4% | not timed | not timed | 17.49 ± 0.3% | | 1.00 | 3.15 | 32.78 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.6% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.9% | not timed | not timed | 7.68 ± 0.2% | | 1.00 | 6.37 | 66.48 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.29 ± 0.2% | not timed | not timed | 0.34 ± 0.5% | 0.56 ± 4.1% | not timed | not timed | 1.29 ± 0.3% | | 1.00 | 3.75 | 2.31 |
| 04-ruff-noqa/compile-real | 1 | 92.93 ± 0.1% | not timed | not timed | 13.74 ± 0.4% | 144.55 ± 1.9% | not timed | not timed | 92.74 ± 0.5% | | 1.00 | 6.77 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 13.91 ± 0.9% | not timed | not timed | 2.53 ± 0.6% | 6.52 ± 2.0% | not timed | not timed | 13.89 ± 1.2% | | 1.00 | 5.50 | 2.14 |
| 07-unicode-character-data/compile | 1 | 55.65 ± 0.3% | not timed | not timed | 25.88 ± 0.2% | 36.63 ± 2.1% | not timed | not timed | 55.19 ± 1.3% | | 1.01 | 2.15 | 1.52 |
| 09-aws-keys/compile-full | 1 | 41.95 ± 0.1% | not timed | not timed | 8.29 ± 0.3% | 23.45 ± 2.7% | not timed | not timed | 41.81 ± 2.4% | | 1.00 | 5.06 | 1.79 |
| 09-aws-keys/compile-quick | 1 | 188.66 ± 0.4% | not timed | not timed | 47.56 ± 0.3% | 135.76 ± 2.9% | not timed | not timed | 187.60 ± 0.2% | | 1.01 | 3.97 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 13.77 ± 0.6% | not timed | not timed | 11.08 ± 0.2% | 16.23 ± 2.8% | not timed | not timed | 13.69 ± 0.9% | | 1.01 | 1.24 | 0.85 |
| 10-bounded-repeat/compile-capitals | 1 | 82.99 ± 0.1% | not timed | not timed | 8.04 ± 0.1% | 24.09 ± 1.5% | not timed | not timed | 82.91 ± 1.6% | | 1.00 | 10.32 | 3.44 |
| 11-unstructured-to-json/compile | 1 | 86.85 ± 0.3% | not timed | not timed | 41.21 ± 0.4% | 69.33 ± 2.7% | not timed | not timed | 86.64 ± 0.3% | | 1.00 | 2.11 | 1.25 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.1% | not timed | not timed | 0.07 ± 0.4% | 0.09 ± 4.4% | not timed | not timed | 0.34 ± 2.0% | | 1.01 | 4.94 | 3.66 |

