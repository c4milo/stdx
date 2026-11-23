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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243553228 |
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
| literal: a word | 217 | 19487.73 ± 2.2% | 4983.34 ± 0.3% | 27.74 ± 0.2% | 18248.19 ± 2.0% | 9189.89 ± 6.1% | 17.60 ± 0.3% | 84.37 ± 0.4% | 19312.55 ± 3.8% | 3.91 | 1.01 | 1.07 | 2.12 |
| literal: a word that is not there | 0 | 21573.56 ± 2.4% | 4866.51 ± 0.5% | 27.84 ± 0.3% | 19887.47 ± 1.3% | 28934.37 ± 2.6% | 17.42 ± 0.1% | 79.54 ± 0.6% | 21679.52 ± 1.6% | 4.43 | 1.00 | 1.08 | 0.75 |
| literal: one of four words | 661 | 6374.13 ± 0.4% | 1932.68 ± 0.3% | 14.25 ± 0.3% | 3946.72 ± 0.2% | 21.90 ± 0.1% | 5.30 ± 0.4% | 6.84 ± 0.6% | 6350.06 ± 0.2% | 3.30 | 1.00 | 1.62 | 291.11 |
| literal: a word in any case | 217 | 15155.48 ± 0.5% | 2072.07 ± 0.2% | 21.12 ± 0.2% | 3962.53 ± 0.1% | 38.08 ± 0.7% | refused | differs | 15107.29 ± 1.0% | 7.31 | 1.00 | 3.82 | 398.00 |
| literal: an href attribute | 33 | 16629.56 ± 1.0% | 609.75 ± 0.3% | 26.62 ± 0.4% | 16817.53 ± 1.2% | 2258.45 ± 0.4% | 13.45 ± 0.4% | 74.03 ± 1.5% | 16648.68 ± 1.0% | 27.27 | 1.00 | 0.99 | 7.36 |
| literal: a word, second text | 123 | 19727.17 ± 2.5% | 3359.46 ± 0.2% | 27.37 ± 0.2% | 18358.12 ± 1.4% | 7600.78 ± 5.1% | 19.55 ± 0.5% | 70.17 ± 0.6% | 20025.99 ± 3.4% | 5.87 | 0.99 | 1.07 | 2.60 |
| class: two capitalized words | 1331 | 1056.31 ± 0.2% | 599.74 ± 0.2% | 25.41 ± 0.1% | 582.14 ± 0.1% | 40.55 ± 2.7% | 15.07 ± 0.4% | 67.12 ± 2.0% | 1056.44 ± 0.2% | 1.76 | 1.00 | 1.81 | 26.05 |
| class: a word that ends in ing | 3399 | 573.02 ± 0.3% | 572.97 ± 0.4% | 17.72 ± 0.2% | 545.13 ± 0.1% | 29.60 ± 5.2% | 8.21 ± 0.1% | 18.25 ± 0.3% | 573.63 ± 0.3% | 1.00 | 1.00 | 1.05 | 19.36 |
| class: a word in capitals | 2332 | 1370.18 ± 0.5% | 603.29 ± 0.1% | 26.99 ± 0.7% | 572.49 ± 0.1% | 43.50 ± 2.3% | 17.30 ± 0.3% | 82.57 ± 0.5% | 1370.90 ± 0.5% | 2.27 | 1.00 | 2.39 | 31.50 |
| class: a number | 8288 | 1946.31 ± 0.3% | 827.55 ± 0.2% | 27.22 ± 0.1% | 1709.19 ± 0.1% | 42.26 ± 10.1% | 0.57 ± 0.1% | 57.56 ± 0.6% | 1947.21 ± 0.1% | 2.35 | 1.00 | 1.14 | 46.06 |
| class: two capitalized words, second text | 5359 | 516.64 ± 0.3% | 524.51 ± 0.2% | 22.81 ± 0.1% | 486.10 ± 0.2% | 35.41 ± 8.4% | 17.01 ± 0.2% | 62.61 ± 0.8% | 516.31 ± 0.1% | 0.99 | 1.00 | 1.06 | 14.59 |
| other: a word between two words | 6104 | 796.27 ± 0.2% | 593.65 ± 0.3% | 23.07 ± 0.2% | 736.00 ± 0.2% | 101.81 ± 17.8% | 11.48 ± 0.1% | 67.98 ± 1.5% | 797.03 ± 0.1% | 1.34 | 1.00 | 1.08 | 7.82 |
| other: a number before a unit, second text | 1481 | 5962.67 ± 1.0% | 1122.32 ± 0.4% | 25.49 ± 0.2% | 5666.52 ± 0.5% | 40.75 ± 0.1% | 17.85 ± 0.1% | 65.45 ± 0.9% | 5901.67 ± 0.6% | 5.31 | 1.01 | 1.05 | 146.34 |
| other: a heading's start tag | 110 | 14007.53 ± 8.0% | 742.44 ± 1.1% | 26.81 ± 0.3% | 1717.11 ± 0.2% | 1577.39 ± 4.7% | 16.37 ± 0.7% | 86.22 ± 0.3% | 13955.76 ± 6.0% | 18.87 | 1.00 | 8.16 | 8.88 |
| other: a whole word | 217 | 15824.60 ± 0.7% | 602.19 ± 0.3% | 28.67 ± 0.1% | 14392.38 ± 1.4% | 49.31 ± 0.8% | 13.88 ± 0.2% | 54.94 ± 0.3% | 15435.37 ± 1.2% | 26.28 | 1.03 | 1.10 | 320.95 |
| other: a line's first word, second text | 3716 | 2040.72 ± 0.4% | 587.59 ± 0.3% | 29.98 ± 0.8% | 1730.35 ± 0.4% | 62.38 ± 3.8% | refused | refused | 2033.12 ± 0.4% | 3.47 | 1.00 | 1.18 | 32.71 |
| other: fourteen octets before an x | 87 | 23593.46 ± 1.0% | 249.79 ± 2.0% | 6.51 ± 0.2% | 3973.74 ± 0.5% | 10.66 ± 0.1% | differs | 17.71 ± 0.1% | 23500.98 ± 1.1% | 94.45 | 1.00 | 5.94 | 2213.81 |
| other: a Greek word | 21815 | 485.17 ± 0.5% | 409.21 ± 0.1% | 30.48 ± 0.2% | 289.36 ± 0.4% | 49.09 ± 11.0% | differs | refused | 482.81 ± 0.1% | 1.19 | 1.00 | 1.68 | 9.88 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.51 ± 0.3% | 18.53 ± 0.2% | 0.85 ± 0.3% | 19.51 ± 0.2% | 2.77 ± 0.9% | differs | 3.99 ± 0.2% | 18.54 ± 0.2% | 1.00 | 1.00 | 0.95 | 6.68 |
| a UUID | 32895 | 20.09 ± 0.4% | 20.10 ± 0.4% | 0.64 ± 0.2% | 15.11 ± 0.3% | 3.10 ± 0.6% | 0.72 ± 0.3% | 3.63 ± 0.5% | 20.13 ± 0.3% | 1.00 | 1.00 | 1.33 | 6.49 |
| an IPv4 address | 33176 | 33.63 ± 0.3% | 33.71 ± 0.1% | 2.08 ± 0.4% | 28.97 ± 0.1% | 6.64 ± 0.1% | differs | 4.14 ± 0.1% | 33.69 ± 0.3% | 1.00 | 1.00 | 1.16 | 5.07 |
| a date and time | 32954 | 28.73 ± 0.3% | 28.90 ± 0.3% | 1.44 ± 0.2% | 21.34 ± 0.5% | 7.04 ± 0.1% | 1.19 ± 0.1% | 7.14 ± 0.5% | 28.87 ± 0.2% | 0.99 | 1.00 | 1.35 | 4.08 |
| a field path | 32606 | 21.73 ± 0.2% | 21.78 ± 0.1% | 0.97 ± 0.2% | 23.12 ± 0.1% | 3.49 ± 0.6% | differs | 2.93 ± 0.4% | 21.78 ± 0.2% | 1.00 | 1.00 | 0.94 | 6.23 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.07 ± 0.1% | 11.10 ± 0.2% | 11.08 ± 0.1% | 11.55 ± 0.1% | 4.91 ± 1.1% | 0.91 ± 0.1% | none | 11.10 ± 0.3% | 1.00 | 1.00 | 0.96 | 2.26 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 220.98 ± 0.2% | 221.73 ± 0.3% | 263.70 ± 0.2% | 87.49 ± 0.2% | 219.11 ± 1.8% | 477.81 ± 0.5% | 3796.89 ± 0.5% | 220.90 ± 0.3% | 1.00 | 1.00 | 2.53 | 1.01 |
| a UUID | 62 | 143.54 ± 0.5% | 143.76 ± 0.2% | 161.08 ± 0.0% | 46.60 ± 0.3% | 97.05 ± 3.4% | 182.26 ± 1.8% | 4255.90 ± 1.0% | 143.39 ± 0.2% | 1.00 | 1.00 | 3.08 | 1.48 |
| an IPv4 address | 29 | 412.01 ± 0.3% | 416.68 ± 0.3% | 596.01 ± 0.2% | 77.54 ± 0.5% | 130.91 ± 1.6% | 290.39 ± 0.8% | 7548.29 ± 0.3% | 411.97 ± 0.3% | 0.99 | 1.00 | 5.31 | 3.15 |
| a date and time | 56 | 295.35 ± 0.2% | 297.19 ± 0.1% | 376.07 ± 0.1% | 73.32 ± 0.6% | 136.09 ± 30.6% | 312.90 ± 0.5% | 4919.38 ± 1.4% | 295.31 ± 0.4% | 0.99 | 1.00 | 4.03 | 2.17 |
| a field path | 39 | 212.74 ± 0.4% | 213.48 ± 0.3% | 251.46 ± 0.3% | 81.02 ± 0.7% | 205.94 ± 1.1% | 498.73 ± 2.1% | 4820.91 ± 3.2% | 213.04 ± 0.1% | 1.00 | 1.00 | 2.63 | 1.03 |
| literal: a word | 7 | 610.02 ± 0.5% | 665.07 ± 0.2% | 1224.63 ± 0.1% | 520.06 ± 0.1% | 624.69 ± 1.0% | 933.35 ± 0.5% | 29695.50 ± 0.4% | 610.41 ± 0.8% | 0.92 | 1.00 | 1.17 | 0.98 |
| literal: a word that is not there | 8 | 593.38 ± 0.5% | 645.31 ± 0.4% | 1155.93 ± 0.2% | 469.71 ± 0.0% | 594.82 ± 9.4% | 884.30 ± 0.6% | 28560.77 ± 0.2% | 593.16 ± 0.3% | 0.92 | 1.00 | 1.26 | 1.00 |
| literal: one of four words | 26 | 236.93 ± 0.4% | 393.14 ± 0.4% | 544.51 ± 0.6% | 49.28 ± 0.5% | 240.71 ± 2.5% | 360.41 ± 2.3% | 15713.11 ± 0.2% | 237.31 ± 0.4% | 0.60 | 1.00 | 4.81 | 0.98 |
| literal: a word in any case | 11 | 434.36 ± 0.4% | 465.48 ± 0.2% | 690.51 ± 0.2% | 15.73 ± 0.3% | 648.93 ± 1.8% | refused | 23424.82 ± 0.2% | 433.99 ± 0.2% | 0.93 | 1.00 | 27.61 | 0.67 |
| literal: an href attribute | 12 | 332.46 ± 0.4% | 345.73 ± 0.5% | 459.47 ± 0.3% | 45.75 ± 0.6% | 495.42 ± 1.4% | 772.31 ± 0.8% | 21276.08 ± 0.4% | 332.72 ± 0.7% | 0.96 | 1.00 | 7.27 | 0.67 |
| literal: a word, second text | 10 | 547.26 ± 0.4% | 604.68 ± 0.4% | 1039.85 ± 0.2% | 422.82 ± 0.7% | 534.27 ± 1.5% | 799.89 ± 0.4% | 26405.84 ± 0.1% | 547.34 ± 0.2% | 0.91 | 1.00 | 1.29 | 1.02 |
| class: two capitalized words | 23 | 419.46 ± 0.2% | 454.31 ± 0.6% | 672.19 ± 0.5% | 101.23 ± 0.3% | 499.60 ± 1.0% | 737.63 ± 0.7% | 6443.07 ± 0.4% | 419.45 ± 0.3% | 0.92 | 1.00 | 4.14 | 0.84 |
| class: a word that ends in ing | 9 | 540.26 ± 0.2% | 611.32 ± 0.4% | 1103.15 ± 0.3% | 132.52 ± 1.1% | 758.45 ± 4.9% | 1085.05 ± 1.8% | 15760.61 ± 0.2% | 539.84 ± 0.5% | 0.88 | 1.00 | 4.08 | 0.71 |
| class: a word in capitals | 16 | 472.55 ± 0.2% | 520.49 ± 0.2% | 867.05 ± 0.1% | 136.28 ± 0.5% | 747.71 ± 0.5% | 1001.01 ± 0.3% | 8494.92 ± 0.5% | 473.46 ± 0.3% | 0.91 | 1.00 | 3.47 | 0.63 |
| class: a number | 6 | 596.79 ± 0.3% | 670.37 ± 0.5% | 1323.58 ± 0.0% | 41.96 ± 0.8% | 1394.00 ± 0.7% | 1907.14 ± 1.5% | 22280.29 ± 0.2% | 597.11 ± 0.2% | 0.89 | 1.00 | 14.22 | 0.43 |
| class: two capitalized words, second text | 23 | 419.72 ± 0.5% | 454.79 ± 0.5% | 672.27 ± 0.1% | 104.19 ± 0.3% | 498.64 ± 0.9% | 723.83 ± 0.3% | 6436.77 ± 0.5% | 420.09 ± 0.4% | 0.92 | 1.00 | 4.03 | 0.84 |
| other: a word between two words | 13 | 528.98 ± 0.3% | 549.73 ± 0.4% | 903.46 ± 0.5% | 135.35 ± 1.1% | 499.23 ± 0.8% | 804.02 ± 0.6% | 14663.80 ± 0.1% | 528.73 ± 0.4% | 0.96 | 1.00 | 3.91 | 1.06 |
| other: a number before a unit, second text | 15 | 381.00 ± 0.3% | 421.25 ± 0.6% | 595.54 ± 0.5% | 39.48 ± 0.3% | 632.49 ± 1.6% | 878.99 ± 0.3% | 14939.95 ± 0.6% | 380.75 ± 0.3% | 0.90 | 1.00 | 9.65 | 0.60 |
| other: a heading's start tag | 13 | 342.34 ± 0.3% | 349.91 ± 0.3% | 467.65 ± 0.4% | 44.54 ± 0.2% | 627.15 ± 1.7% | 859.34 ± 0.1% | 17688.68 ± 0.2% | 341.98 ± 0.3% | 0.98 | 1.00 | 7.69 | 0.55 |
| other: a whole word | 11 | 567.11 ± 0.4% | 604.62 ± 0.3% | 1038.64 ± 0.3% | 122.05 ± 0.7% | 561.63 ± 1.4% | 809.11 ± 0.9% | 26632.25 ± 0.3% | 566.81 ± 0.3% | 0.94 | 1.00 | 4.65 | 1.01 |
| other: a line's first word, second text | 17 | 519.70 ± 0.1% | 543.42 ± 0.3% | 894.53 ± 0.3% | 130.08 ± 0.2% | 707.58 ± 3.8% | refused | refused | 516.69 ± 0.7% | 0.96 | 1.01 | 4.00 | 0.73 |
| other: fourteen octets before an x | 16 | 105.53 ± 0.7% | 151.46 ± 0.6% | 175.64 ± 1.3% | 15.17 ± 0.9% | 448.10 ± 3.3% | 402.77 ± 0.5% | 12628.75 ± 1.2% | 105.46 ± 0.4% | 0.70 | 1.00 | 6.96 | 0.24 |
| other: a Greek word | 8 | 412.30 ± 0.4% | 569.02 ± 0.6% | 988.20 ± 0.5% | 59.35 ± 0.4% | 1379.75 ± 1.1% | 1830.04 ± 0.6% | refused | 412.46 ± 0.2% | 0.72 | 1.00 | 6.95 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15390.51 ± 1.2% | not timed | not timed | 16000.53 ± 0.7% | 1966.12 ± 13.9% | not timed | not timed | 15402.53 ± 0.8% | | 1.00 | 0.96 | 7.83 |
| 01-literal/sherlock-casei-en | 522 | 5165.21 ± 0.9% | not timed | not timed | 3592.87 ± 0.1% | 32.60 ± 0.1% | not timed | not timed | 5160.71 ± 0.6% | | 1.00 | 1.44 | 158.44 |
| 01-literal/sherlock-ru | 724 | 17101.57 ± 0.9% | not timed | not timed | 17276.06 ± 1.4% | 1378.54 ± 18.0% | not timed | not timed | 17095.72 ± 1.1% | | 1.00 | 0.99 | 12.41 |
| 01-literal/sherlock-casei-ru | 746 | 6174.95 ± 0.2% | not timed | not timed | 3333.00 ± 0.1% | 30.82 ± 0.2% | not timed | not timed | 6171.60 ± 0.1% | | 1.00 | 1.85 | 200.33 |
| 01-literal/sherlock-zh | 30 | 19471.33 ± 0.3% | not timed | not timed | 18444.76 ± 1.3% | 2700.19 ± 6.0% | not timed | not timed | 19460.24 ± 0.7% | | 1.00 | 1.06 | 7.21 |
| 02-literal-alternate/sherlock-en | 714 | 6047.44 ± 0.5% | not timed | not timed | 3944.44 ± 0.1% | 16.65 ± 0.1% | not timed | not timed | 6054.49 ± 0.5% | | 1.00 | 1.53 | 363.28 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1938.03 ± 1.3% | not timed | not timed | 695.48 ± 0.3% | 11.12 ± 0.1% | not timed | not timed | 1930.34 ± 0.4% | | 1.00 | 2.79 | 174.33 |
| 02-literal-alternate/sherlock-ru | 899 | 5565.07 ± 0.2% | not timed | not timed | 3254.69 ± 0.1% | 22.62 ± 0.2% | not timed | not timed | 5557.14 ± 0.2% | | 1.00 | 1.71 | 245.98 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2059.16 ± 0.4% | not timed | not timed | 1230.88 ± 0.3% | 9.07 ± 0.2% | not timed | not timed | 2051.18 ± 0.1% | | 1.00 | 1.67 | 227.00 |
| 02-literal-alternate/sherlock-zh | 207 | 7285.90 ± 0.8% | not timed | not timed | 4162.35 ± 0.2% | 31.53 ± 0.1% | not timed | not timed | 7292.50 ± 0.5% | | 1.00 | 1.75 | 231.10 |
| 03-date/ascii | 111817 | 124.04 ± 0.7% | not timed | not timed | 96.32 ± 0.2% | 0.20 ± 5.2% | not timed | not timed | 123.24 ± 1.0% | | 1.01 | 1.29 | 612.07 |
| 04-ruff-noqa/real | 84 | 401.87 ± 0.1% | not timed | not timed | 462.79 ± 0.0% | 19.58 ± 1.3% | not timed | not timed | 401.49 ± 0.1% | | 1.00 | 0.87 | 20.52 |
| 04-ruff-noqa/tweaked | 44 | 561.53 ± 0.1% | not timed | not timed | 458.87 ± 0.1% | 366.60 ± 0.9% | not timed | not timed | 562.08 ± 0.1% | | 1.00 | 1.22 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.13 ± 0.4% | not timed | not timed | 5.08 ± 0.3% | 0.20 ± 2.2% | not timed | not timed | 5.05 ± 0.4% | | 1.02 | 1.01 | 25.21 |
| 06-cloud-flare-redos/original | 107 | 414.81 ± 0.2% | not timed | not timed | 214.90 ± 0.0% | 24.85 ± 1.4% | not timed | not timed | 415.22 ± 0.1% | | 1.00 | 1.93 | 16.69 |
| 06-cloud-flare-redos/simplified-short | 102 | 411.33 ± 0.1% | not timed | not timed | 226.93 ± 0.1% | 26.74 ± 0.6% | not timed | not timed | 411.67 ± 0.1% | | 1.00 | 1.81 | 15.38 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.59 ± 0.5% | not timed | not timed | 253.38 ± 0.2% | 28.85 ± 0.1% | not timed | not timed | 583.36 ± 0.1% | | 1.00 | 2.30 | 20.23 |
| 07-unicode-character-data/parse-line | 558784 | 235.33 ± 2.5% | not timed | not timed | 171.44 ± 0.1% | 42.75 ± 5.1% | not timed | not timed | 235.21 ± 2.1% | | 1.00 | 1.37 | 5.50 |
| 08-words/all-english | 56691 | 116.65 ± 0.2% | not timed | not timed | 83.39 ± 0.0% | 11.97 ± 10.2% | not timed | not timed | 116.70 ± 0.4% | | 1.00 | 1.40 | 9.74 |
| 08-words/long-english | 839 | 614.21 ± 0.2% | not timed | not timed | 597.72 ± 0.1% | 32.39 ± 0.5% | not timed | not timed | 614.96 ± 0.6% | | 1.00 | 1.03 | 18.97 |
| 09-aws-keys/full | 0 | 407.99 ± 0.1% | not timed | not timed | 461.26 ± 0.1% | 64.62 ± 3.4% | not timed | not timed | 407.70 ± 0.2% | | 1.00 | 0.88 | 6.31 |
| 09-aws-keys/quick | 0 | 943.75 ± 0.2% | not timed | not timed | 992.44 ± 0.2% | 420.39 ± 0.8% | not timed | not timed | 942.25 ± 0.2% | | 1.00 | 0.95 | 2.24 |
| 10-bounded-repeat/letters-en | 1833 | 585.98 ± 2.0% | not timed | not timed | 518.11 ± 0.3% | 19.53 ± 0.7% | not timed | not timed | 577.12 ± 1.8% | | 1.02 | 1.13 | 30.00 |
| 10-bounded-repeat/letters-ru | 3475 | 510.85 ± 1.0% | not timed | not timed | 477.97 ± 0.0% | 21.79 ± 17.3% | not timed | not timed | 507.31 ± 1.2% | | 1.01 | 1.07 | 23.44 |
| 10-bounded-repeat/context | 53 | 77.31 ± 0.3% | not timed | not timed | 65.87 ± 0.4% | 19.83 ± 0.1% | not timed | not timed | 77.01 ± 0.6% | | 1.00 | 1.17 | 3.90 |
| 10-bounded-repeat/capitals | 11 | 635.27 ± 8.2% | not timed | not timed | 616.55 ± 0.2% | 36.57 ± 0.1% | not timed | not timed | 635.04 ± 8.3% | | 1.00 | 1.03 | 17.37 |
| 11-unstructured-to-json/extract | 600 | 82.82 ± 0.1% | not timed | not timed | 77.94 ± 0.4% | 48.99 ± 0.6% | not timed | not timed | 82.47 ± 0.6% | | 1.00 | 1.06 | 1.69 |
| 12-dictionary/single | 1 | 560.77 ± 0.8% | not timed | not timed | 560.67 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 559.66 ± 0.3% | | 1.00 | 1.00 | 1368.45 |
| 14-quadratic/1x | 100 | 21.22 ± 1.0% | not timed | not timed | 9.99 ± 0.2% | 0.97 ± 4.3% | not timed | not timed | 21.27 ± 1.6% | | 1.00 | 2.12 | 21.89 |
| 14-quadratic/2x | 200 | 17.51 ± 0.7% | not timed | not timed | 5.54 ± 0.2% | 0.53 ± 1.4% | not timed | not timed | 17.52 ± 0.9% | | 1.00 | 3.16 | 33.01 |
| 14-quadratic/10x | 1000 | 7.68 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 7.68 ± 0.2% | | 1.00 | 6.33 | 66.56 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 0.2% | not timed | not timed | 0.34 ± 0.5% | 0.53 ± 5.8% | not timed | not timed | 1.25 ± 2.1% | | 1.01 | 3.69 | 2.36 |
| 04-ruff-noqa/compile-real | 1 | 82.91 ± 0.2% | not timed | not timed | 13.76 ± 0.2% | 137.39 ± 1.2% | not timed | not timed | 82.59 ± 1.7% | | 1.00 | 6.03 | 0.60 |
| 05-lexer-veryl/compile-single | 1 | 13.88 ± 1.5% | not timed | not timed | 2.52 ± 1.2% | 6.40 ± 3.0% | not timed | not timed | 13.83 ± 1.2% | | 1.00 | 5.51 | 2.17 |
| 07-unicode-character-data/compile | 1 | 53.67 ± 0.2% | not timed | not timed | 25.87 ± 0.3% | 35.76 ± 2.2% | not timed | not timed | 53.31 ± 1.1% | | 1.01 | 2.07 | 1.50 |
| 09-aws-keys/compile-full | 1 | 41.03 ± 0.4% | not timed | not timed | 8.30 ± 0.2% | 23.14 ± 1.4% | not timed | not timed | 40.69 ± 0.5% | | 1.01 | 4.94 | 1.77 |
| 09-aws-keys/compile-quick | 1 | 164.13 ± 0.1% | not timed | not timed | 47.00 ± 0.1% | 131.97 ± 3.1% | not timed | not timed | 163.64 ± 0.5% | | 1.00 | 3.49 | 1.24 |
| 10-bounded-repeat/compile-context | 1 | 13.42 ± 0.7% | not timed | not timed | 11.16 ± 0.3% | 15.77 ± 3.0% | not timed | not timed | 13.31 ± 1.8% | | 1.01 | 1.20 | 0.85 |
| 10-bounded-repeat/compile-capitals | 1 | 80.73 ± 0.4% | not timed | not timed | 8.10 ± 0.2% | 23.61 ± 1.8% | not timed | not timed | 80.62 ± 0.6% | | 1.00 | 9.97 | 3.42 |
| 11-unstructured-to-json/compile | 1 | 83.90 ± 0.3% | not timed | not timed | 40.77 ± 0.3% | 67.32 ± 2.3% | not timed | not timed | 83.30 ± 2.2% | | 1.01 | 2.06 | 1.25 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.7% | not timed | not timed | 0.07 ± 11.2% | 0.10 ± 9.6% | not timed | not timed | 0.35 ± 1.5% | | 1.02 | 5.21 | 3.63 |

