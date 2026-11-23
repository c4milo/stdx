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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243455127 |
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
| literal: a word | 217 | 19508.10 ± 4.0% | 4995.06 ± 0.3% | 28.30 ± 0.4% | 17801.36 ± 3.0% | 9081.08 ± 7.9% | 16.57 ± 0.2% | 83.97 ± 0.2% | 19743.64 ± 0.7% | 3.91 | 0.99 | 1.10 | 2.15 |
| literal: a word that is not there | 0 | 21045.72 ± 3.0% | 4866.98 ± 0.3% | 28.22 ± 0.2% | 19357.44 ± 3.2% | 28252.96 ± 1.5% | 16.23 ± 0.3% | 79.38 ± 0.8% | 21392.28 ± 3.7% | 4.32 | 0.98 | 1.09 | 0.74 |
| literal: one of four words | 661 | 6357.59 ± 0.2% | 1932.60 ± 0.2% | 14.45 ± 0.2% | 3929.33 ± 0.2% | 21.88 ± 0.3% | 4.94 ± 0.1% | 6.88 ± 0.2% | 6342.24 ± 0.2% | 3.29 | 1.00 | 1.62 | 290.53 |
| literal: a word in any case | 217 | 14994.24 ± 0.9% | 2074.55 ± 0.4% | 21.53 ± 0.3% | 3961.60 ± 0.2% | 38.07 ± 0.8% | refused | differs | 14957.90 ± 0.8% | 7.23 | 1.00 | 3.78 | 393.83 |
| literal: an href attribute | 33 | 16686.57 ± 1.6% | 609.78 ± 0.2% | 27.38 ± 0.2% | 17089.19 ± 1.6% | 2257.65 ± 0.7% | 12.30 ± 0.1% | 73.51 ± 1.6% | 16566.92 ± 1.9% | 27.36 | 1.01 | 0.98 | 7.39 |
| literal: a word, second text | 123 | 19504.68 ± 2.9% | 3356.54 ± 0.2% | 28.01 ± 0.4% | 18094.91 ± 1.2% | 7809.67 ± 5.0% | 20.12 ± 0.5% | 69.94 ± 0.5% | 19786.83 ± 5.1% | 5.81 | 0.99 | 1.08 | 2.50 |
| class: two capitalized words | 1331 | 1057.31 ± 0.3% | 599.86 ± 0.3% | 25.95 ± 0.2% | 584.60 ± 0.1% | 40.57 ± 3.3% | 14.03 ± 0.2% | 67.20 ± 0.3% | 1057.41 ± 0.4% | 1.76 | 1.00 | 1.81 | 26.06 |
| class: a word that ends in ing | 3399 | 572.51 ± 0.1% | 572.35 ± 0.2% | 18.01 ± 0.2% | 546.76 ± 0.1% | 29.63 ± 9.4% | 7.79 ± 0.1% | 18.26 ± 0.1% | 572.74 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.33 |
| class: a word in capitals | 2332 | 1367.65 ± 0.5% | 602.58 ± 0.3% | 27.70 ± 0.4% | 571.81 ± 0.0% | 43.50 ± 10.2% | 16.79 ± 0.3% | 82.50 ± 0.3% | 1370.87 ± 0.3% | 2.27 | 1.00 | 2.39 | 31.44 |
| class: a number | 8288 | 1956.66 ± 0.3% | 827.31 ± 0.1% | 27.77 ± 0.6% | 1687.38 ± 0.2% | 38.85 ± 15.9% | 0.51 ± 0.1% | 57.39 ± 0.3% | 1956.19 ± 0.3% | 2.37 | 1.00 | 1.16 | 50.36 |
| class: two capitalized words, second text | 5359 | 516.57 ± 0.3% | 524.17 ± 0.3% | 23.39 ± 0.1% | 484.13 ± 0.1% | 35.42 ± 14.8% | 17.14 ± 0.4% | 62.59 ± 0.2% | 516.10 ± 0.3% | 0.99 | 1.00 | 1.07 | 14.58 |
| other: a word between two words | 6104 | 791.73 ± 0.2% | 593.85 ± 0.2% | 23.55 ± 0.2% | 735.48 ± 0.2% | 109.40 ± 16.3% | 10.59 ± 0.0% | 68.01 ± 0.3% | 791.95 ± 0.2% | 1.33 | 1.00 | 1.08 | 7.24 |
| other: a number before a unit, second text | 1481 | 5946.52 ± 1.3% | 1119.39 ± 0.1% | 26.08 ± 0.2% | 5621.17 ± 0.8% | 40.72 ± 0.1% | 18.25 ± 0.1% | 65.48 ± 0.3% | 5926.27 ± 1.3% | 5.31 | 1.00 | 1.06 | 146.04 |
| other: a heading's start tag | 110 | 13888.61 ± 1.0% | 742.42 ± 0.1% | 27.42 ± 0.4% | 1713.75 ± 0.3% | 1580.69 ± 3.0% | 15.16 ± 0.4% | 86.13 ± 1.6% | 13931.50 ± 3.8% | 18.71 | 1.00 | 8.10 | 8.79 |
| other: a whole word | 217 | 15720.61 ± 1.0% | 602.19 ± 0.7% | 29.20 ± 0.0% | 14414.10 ± 0.6% | 49.39 ± 0.3% | 12.21 ± 0.1% | 54.84 ± 1.3% | 15683.27 ± 1.5% | 26.11 | 1.00 | 1.09 | 318.27 |
| other: a line's first word, second text | 3716 | 1912.64 ± 0.6% | 587.55 ± 0.4% | 30.88 ± 0.2% | 1715.33 ± 0.3% | 62.04 ± 6.5% | refused | refused | 2030.44 ± 0.4% | 3.26 | 0.94 | 1.12 | 30.83 |
| other: fourteen octets before an x | 87 | 23257.90 ± 1.6% | 236.13 ± 0.2% | 6.55 ± 0.0% | 3942.86 ± 1.1% | 10.65 ± 0.2% | differs | 17.69 ± 0.1% | 23216.13 ± 1.7% | 98.49 | 1.00 | 5.90 | 2182.98 |
| other: a Greek word | 21815 | 487.23 ± 0.7% | 407.51 ± 0.1% | 30.87 ± 0.5% | 288.52 ± 0.3% | 47.85 ± 4.1% | differs | refused | 483.52 ± 0.7% | 1.20 | 1.01 | 1.69 | 10.18 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.45 ± 0.2% | 18.49 ± 0.2% | 0.86 ± 0.5% | 19.80 ± 0.3% | 2.77 ± 0.4% | differs | 4.00 ± 0.1% | 18.50 ± 0.2% | 1.00 | 1.00 | 0.93 | 6.66 |
| a UUID | 32895 | 20.09 ± 0.2% | 20.10 ± 0.2% | 0.64 ± 0.1% | 15.07 ± 0.4% | 3.12 ± 0.2% | 0.73 ± 0.2% | 3.64 ± 0.4% | 20.10 ± 0.1% | 1.00 | 1.00 | 1.33 | 6.44 |
| an IPv4 address | 33176 | 33.68 ± 0.1% | 33.57 ± 0.1% | 2.08 ± 0.4% | 29.27 ± 0.2% | 6.61 ± 0.1% | differs | 4.16 ± 0.1% | 33.67 ± 0.2% | 1.00 | 1.00 | 1.15 | 5.09 |
| a date and time | 32954 | 28.88 ± 0.3% | 28.93 ± 0.3% | 1.45 ± 0.4% | 21.50 ± 0.5% | 7.05 ± 0.2% | 1.26 ± 0.0% | 7.21 ± 0.2% | 28.89 ± 0.2% | 1.00 | 1.00 | 1.34 | 4.10 |
| a field path | 32606 | 21.78 ± 0.1% | 21.79 ± 0.3% | 1.02 ± 0.2% | 23.13 ± 0.2% | 3.46 ± 0.7% | differs | 2.93 ± 0.1% | 21.78 ± 0.1% | 1.00 | 1.00 | 0.94 | 6.29 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.10 ± 0.4% | 11.09 ± 0.3% | 11.11 ± 0.4% | 11.54 ± 0.2% | 4.93 ± 1.1% | 0.94 ± 0.6% | none | 11.09 ± 0.3% | 1.00 | 1.00 | 0.96 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 228.88 ± 0.7% | 229.60 ± 0.4% | 269.04 ± 0.6% | 86.04 ± 0.8% | 218.92 ± 0.5% | 482.44 ± 1.7% | 3803.29 ± 0.4% | 228.60 ± 0.1% | 1.00 | 1.00 | 2.66 | 1.05 |
| a UUID | 62 | 148.11 ± 0.1% | 148.46 ± 0.3% | 164.66 ± 0.1% | 46.27 ± 0.7% | 97.90 ± 0.9% | 189.46 ± 2.8% | 4255.17 ± 1.4% | 148.14 ± 0.2% | 1.00 | 1.00 | 3.20 | 1.51 |
| an IPv4 address | 29 | 425.89 ± 0.6% | 429.79 ± 0.3% | 592.79 ± 0.4% | 76.43 ± 0.4% | 130.10 ± 1.3% | 300.47 ± 2.3% | 7506.23 ± 0.3% | 426.07 ± 0.2% | 0.99 | 1.00 | 5.57 | 3.27 |
| a date and time | 56 | 306.28 ± 0.4% | 307.58 ± 0.1% | 381.96 ± 0.1% | 72.13 ± 0.2% | 135.70 ± 1.1% | 323.21 ± 0.5% | 4938.20 ± 0.4% | 305.96 ± 0.2% | 1.00 | 1.00 | 4.25 | 2.26 |
| a field path | 39 | 220.90 ± 0.3% | 221.77 ± 0.2% | 258.65 ± 0.2% | 80.16 ± 1.0% | 203.83 ± 1.5% | 503.08 ± 2.9% | 4817.59 ± 1.2% | 220.84 ± 0.3% | 1.00 | 1.00 | 2.76 | 1.08 |
| literal: a word | 7 | 641.47 ± 0.6% | 696.15 ± 0.3% | 1213.41 ± 0.2% | 513.81 ± 0.1% | 614.60 ± 1.8% | 958.67 ± 0.7% | 29014.04 ± 0.5% | 640.73 ± 0.4% | 0.92 | 1.00 | 1.25 | 1.04 |
| literal: a word that is not there | 8 | 615.33 ± 0.3% | 672.78 ± 0.1% | 1156.29 ± 0.1% | 471.76 ± 0.7% | 591.47 ± 7.5% | 907.54 ± 0.5% | 27618.84 ± 0.1% | 614.21 ± 0.3% | 0.91 | 1.00 | 1.30 | 1.04 |
| literal: one of four words | 26 | 247.14 ± 0.3% | 402.84 ± 0.4% | 540.14 ± 0.3% | 49.88 ± 1.3% | 238.65 ± 1.4% | 374.69 ± 1.4% | 15793.24 ± 0.2% | 247.19 ± 0.4% | 0.61 | 1.00 | 4.95 | 1.04 |
| literal: a word in any case | 11 | 442.30 ± 0.5% | 479.01 ± 0.4% | 689.42 ± 0.4% | 15.80 ± 1.5% | 633.72 ± 2.6% | refused | 22949.38 ± 0.8% | 442.06 ± 0.4% | 0.92 | 1.00 | 28.00 | 0.70 |
| literal: an href attribute | 12 | 350.26 ± 0.4% | 364.04 ± 0.5% | 472.84 ± 0.3% | 45.05 ± 0.4% | 492.42 ± 2.9% | 772.82 ± 0.7% | 21354.44 ± 0.2% | 350.38 ± 0.4% | 0.96 | 1.00 | 7.77 | 0.71 |
| literal: a word, second text | 10 | 571.76 ± 0.5% | 634.41 ± 0.4% | 1049.02 ± 0.9% | 396.04 ± 0.3% | 530.71 ± 1.0% | 801.58 ± 0.6% | 25914.35 ± 0.1% | 570.83 ± 0.2% | 0.90 | 1.00 | 1.44 | 1.08 |
| class: two capitalized words | 23 | 441.52 ± 0.5% | 472.80 ± 0.3% | 673.77 ± 0.4% | 98.87 ± 0.2% | 488.51 ± 2.5% | 740.75 ± 0.5% | 6403.12 ± 0.4% | 441.19 ± 0.6% | 0.93 | 1.00 | 4.47 | 0.90 |
| class: a word that ends in ing | 9 | 573.62 ± 0.3% | 645.10 ± 0.1% | 1111.88 ± 0.1% | 130.64 ± 1.9% | 751.68 ± 7.6% | 1109.96 ± 0.7% | 15562.51 ± 0.4% | 573.16 ± 0.3% | 0.89 | 1.00 | 4.39 | 0.76 |
| class: a word in capitals | 16 | 503.00 ± 1.1% | 544.71 ± 1.0% | 862.24 ± 1.9% | 134.18 ± 0.7% | 735.48 ± 2.7% | 1016.48 ± 1.3% | 8406.07 ± 0.4% | 503.23 ± 1.1% | 0.92 | 1.00 | 3.75 | 0.68 |
| class: a number | 6 | 642.54 ± 0.2% | 710.69 ± 0.9% | 1317.60 ± 0.1% | 41.67 ± 0.5% | 1366.73 ± 0.5% | 1855.13 ± 1.4% | 22182.35 ± 0.1% | 642.14 ± 0.4% | 0.90 | 1.00 | 15.42 | 0.47 |
| class: two capitalized words, second text | 23 | 441.86 ± 0.4% | 473.24 ± 0.6% | 674.13 ± 0.8% | 100.04 ± 0.4% | 491.51 ± 1.4% | 761.07 ± 0.5% | 6420.70 ± 0.3% | 441.98 ± 0.2% | 0.93 | 1.00 | 4.42 | 0.90 |
| other: a word between two words | 13 | 556.28 ± 0.3% | 578.92 ± 0.5% | 913.73 ± 0.4% | 132.39 ± 0.7% | 494.69 ± 2.0% | 812.33 ± 0.7% | 14460.51 ± 0.1% | 555.85 ± 0.3% | 0.96 | 1.00 | 4.20 | 1.12 |
| other: a number before a unit, second text | 15 | 392.57 ± 0.4% | 436.47 ± 0.4% | 603.81 ± 0.5% | 39.38 ± 0.4% | 628.11 ± 1.5% | 892.37 ± 1.1% | 14861.18 ± 0.2% | 391.32 ± 0.6% | 0.90 | 1.00 | 9.97 | 0.62 |
| other: a heading's start tag | 13 | 358.84 ± 0.4% | 366.68 ± 0.2% | 479.36 ± 0.5% | 43.62 ± 0.3% | 619.49 ± 1.1% | 874.90 ± 0.8% | 17729.66 ± 0.3% | 358.92 ± 0.5% | 0.98 | 1.00 | 8.23 | 0.58 |
| other: a whole word | 11 | 584.07 ± 0.1% | 626.31 ± 0.3% | 1039.32 ± 0.2% | 117.09 ± 0.6% | 553.70 ± 2.0% | 836.00 ± 0.7% | 26551.79 ± 0.1% | 584.50 ± 0.3% | 0.93 | 1.00 | 4.99 | 1.05 |
| other: a line's first word, second text | 17 | 531.97 ± 0.4% | 560.32 ± 0.5% | 885.14 ± 0.5% | 127.71 ± 0.1% | 696.37 ± 0.8% | refused | refused | 531.19 ± 0.6% | 0.95 | 1.00 | 4.17 | 0.76 |
| other: fourteen octets before an x | 16 | 106.89 ± 0.7% | 151.61 ± 0.2% | 171.60 ± 0.7% | 15.13 ± 0.3% | 440.98 ± 2.0% | 411.20 ± 0.5% | 12632.95 ± 0.5% | 107.15 ± 0.7% | 0.71 | 1.00 | 7.07 | 0.24 |
| other: a Greek word | 8 | 457.93 ± 0.4% | 614.68 ± 0.7% | 1029.21 ± 0.2% | 58.82 ± 0.3% | 1356.71 ± 0.9% | 1795.91 ± 0.4% | refused | 458.79 ± 0.4% | 0.74 | 1.00 | 7.79 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15226.38 ± 0.5% | not timed | not timed | 15835.63 ± 0.9% | 2106.58 ± 12.4% | not timed | not timed | 15245.54 ± 0.5% | | 1.00 | 0.96 | 7.23 |
| 01-literal/sherlock-casei-en | 522 | 5154.24 ± 1.1% | not timed | not timed | 3586.11 ± 0.1% | 32.53 ± 0.2% | not timed | not timed | 5159.10 ± 0.5% | | 1.00 | 1.44 | 158.45 |
| 01-literal/sherlock-ru | 724 | 17136.53 ± 0.8% | not timed | not timed | 17295.68 ± 0.4% | 1452.58 ± 6.8% | not timed | not timed | 17127.23 ± 0.6% | | 1.00 | 0.99 | 11.80 |
| 01-literal/sherlock-casei-ru | 746 | 6176.67 ± 0.2% | not timed | not timed | 3331.75 ± 0.1% | 30.98 ± 0.1% | not timed | not timed | 6169.54 ± 0.1% | | 1.00 | 1.85 | 199.37 |
| 01-literal/sherlock-zh | 30 | 19553.36 ± 0.6% | not timed | not timed | 18549.96 ± 0.4% | 2589.47 ± 13.9% | not timed | not timed | 19456.07 ± 0.3% | | 1.01 | 1.05 | 7.55 |
| 02-literal-alternate/sherlock-en | 714 | 6027.63 ± 0.5% | not timed | not timed | 3933.58 ± 0.3% | 16.60 ± 0.2% | not timed | not timed | 6033.78 ± 0.1% | | 1.00 | 1.53 | 363.10 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1936.55 ± 1.4% | not timed | not timed | 696.11 ± 0.2% | 11.11 ± 0.1% | not timed | not timed | 1930.18 ± 0.4% | | 1.00 | 2.78 | 174.27 |
| 02-literal-alternate/sherlock-ru | 899 | 5561.10 ± 0.3% | not timed | not timed | 3252.49 ± 0.1% | 22.59 ± 0.1% | not timed | not timed | 5551.45 ± 0.3% | | 1.00 | 1.71 | 246.14 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2059.00 ± 0.6% | not timed | not timed | 1226.74 ± 0.1% | 9.08 ± 0.2% | not timed | not timed | 2049.34 ± 0.2% | | 1.00 | 1.68 | 226.75 |
| 02-literal-alternate/sherlock-zh | 207 | 7292.47 ± 0.2% | not timed | not timed | 4162.41 ± 0.1% | 31.48 ± 0.1% | not timed | not timed | 7286.28 ± 0.4% | | 1.00 | 1.75 | 231.67 |
| 03-date/ascii | 111817 | 123.22 ± 0.5% | not timed | not timed | 96.26 ± 0.1% | 0.20 ± 3.2% | not timed | not timed | 123.03 ± 0.2% | | 1.00 | 1.28 | 608.41 |
| 04-ruff-noqa/real | 84 | 402.14 ± 0.1% | not timed | not timed | 477.49 ± 0.1% | 18.80 ± 0.2% | not timed | not timed | 402.16 ± 0.4% | | 1.00 | 0.84 | 21.39 |
| 04-ruff-noqa/tweaked | 44 | 559.52 ± 0.2% | not timed | not timed | 465.12 ± 0.1% | 364.85 ± 0.9% | not timed | not timed | 560.55 ± 0.2% | | 1.00 | 1.20 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.33 ± 0.2% | not timed | not timed | 5.23 ± 0.3% | 0.21 ± 4.7% | not timed | not timed | 5.33 ± 3.0% | | 1.00 | 1.02 | 26.02 |
| 06-cloud-flare-redos/original | 107 | 415.25 ± 1.7% | not timed | not timed | 217.28 ± 0.0% | 24.87 ± 0.4% | not timed | not timed | 415.24 ± 0.9% | | 1.00 | 1.91 | 16.70 |
| 06-cloud-flare-redos/simplified-short | 102 | 411.60 ± 0.1% | not timed | not timed | 226.93 ± 0.1% | 26.71 ± 0.1% | not timed | not timed | 412.24 ± 0.2% | | 1.00 | 1.81 | 15.41 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.74 ± 0.3% | not timed | not timed | 254.64 ± 0.2% | 28.76 ± 0.2% | not timed | not timed | 583.17 ± 0.0% | | 1.00 | 2.29 | 20.30 |
| 07-unicode-character-data/parse-line | 558784 | 232.05 ± 3.2% | not timed | not timed | 179.00 ± 0.1% | 42.65 ± 3.7% | not timed | not timed | 231.74 ± 0.9% | | 1.00 | 1.30 | 5.44 |
| 08-words/all-english | 56691 | 116.20 ± 0.3% | not timed | not timed | 82.69 ± 0.1% | 12.87 ± 10.2% | not timed | not timed | 116.10 ± 0.2% | | 1.00 | 1.41 | 9.03 |
| 08-words/long-english | 839 | 614.11 ± 0.3% | not timed | not timed | 596.22 ± 0.2% | 32.64 ± 0.3% | not timed | not timed | 614.15 ± 0.2% | | 1.00 | 1.03 | 18.82 |
| 09-aws-keys/full | 0 | 407.74 ± 0.1% | not timed | not timed | 491.33 ± 0.1% | 64.46 ± 3.5% | not timed | not timed | 407.92 ± 0.1% | | 1.00 | 0.83 | 6.33 |
| 09-aws-keys/quick | 0 | 947.23 ± 0.3% | not timed | not timed | 1002.65 ± 0.1% | 418.32 ± 0.4% | not timed | not timed | 946.54 ± 0.2% | | 1.00 | 0.94 | 2.26 |
| 10-bounded-repeat/letters-en | 1833 | 583.46 ± 2.0% | not timed | not timed | 517.06 ± 0.2% | 19.49 ± 0.6% | not timed | not timed | 584.58 ± 2.2% | | 1.00 | 1.13 | 29.93 |
| 10-bounded-repeat/letters-ru | 3475 | 507.76 ± 1.2% | not timed | not timed | 478.73 ± 0.2% | 21.78 ± 8.7% | not timed | not timed | 506.12 ± 1.2% | | 1.00 | 1.06 | 23.31 |
| 10-bounded-repeat/context | 53 | 76.81 ± 0.6% | not timed | not timed | 65.24 ± 0.5% | 19.83 ± 0.3% | not timed | not timed | 76.69 ± 0.7% | | 1.00 | 1.18 | 3.87 |
| 10-bounded-repeat/capitals | 11 | 635.69 ± 8.1% | not timed | not timed | 618.20 ± 0.0% | 36.55 ± 0.3% | not timed | not timed | 634.85 ± 8.5% | | 1.00 | 1.03 | 17.39 |
| 11-unstructured-to-json/extract | 600 | 79.58 ± 0.1% | not timed | not timed | 76.29 ± 0.2% | 48.93 ± 0.6% | not timed | not timed | 82.53 ± 0.8% | | 0.96 | 1.04 | 1.63 |
| 12-dictionary/single | 1 | 560.80 ± 0.3% | not timed | not timed | 562.35 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 560.32 ± 0.2% | | 1.00 | 1.00 | 1379.65 |
| 14-quadratic/1x | 100 | 21.31 ± 1.5% | not timed | not timed | 10.11 ± 0.8% | 0.96 ± 2.9% | not timed | not timed | 21.27 ± 1.4% | | 1.00 | 2.11 | 22.18 |
| 14-quadratic/2x | 200 | 17.53 ± 0.4% | not timed | not timed | 5.56 ± 0.1% | 0.53 ± 1.4% | not timed | not timed | 17.48 ± 1.4% | | 1.00 | 3.16 | 32.82 |
| 14-quadratic/10x | 1000 | 7.68 ± 0.3% | not timed | not timed | 1.19 ± 0.1% | 0.12 ± 1.5% | not timed | not timed | 7.67 ± 0.4% | | 1.00 | 6.46 | 66.80 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.28 ± 0.2% | not timed | not timed | 0.34 ± 0.7% | 0.54 ± 4.4% | not timed | not timed | 1.28 ± 0.2% | | 1.00 | 3.77 | 2.35 |
| 04-ruff-noqa/compile-real | 1 | 90.42 ± 0.2% | not timed | not timed | 13.79 ± 0.2% | 137.98 ± 2.3% | not timed | not timed | 90.36 ± 0.9% | | 1.00 | 6.56 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 13.92 ± 1.3% | not timed | not timed | 2.52 ± 0.3% | 6.40 ± 1.7% | not timed | not timed | 13.84 ± 1.2% | | 1.01 | 5.53 | 2.17 |
| 07-unicode-character-data/compile | 1 | 55.43 ± 0.1% | not timed | not timed | 25.71 ± 0.1% | 35.29 ± 1.9% | not timed | not timed | 54.87 ± 1.2% | | 1.01 | 2.16 | 1.57 |
| 09-aws-keys/compile-full | 1 | 41.79 ± 0.3% | not timed | not timed | 8.25 ± 0.3% | 22.95 ± 2.5% | not timed | not timed | 41.50 ± 0.6% | | 1.01 | 5.07 | 1.82 |
| 09-aws-keys/compile-quick | 1 | 187.06 ± 0.1% | not timed | not timed | 47.56 ± 0.2% | 131.81 ± 1.7% | not timed | not timed | 186.25 ± 0.8% | | 1.00 | 3.93 | 1.42 |
| 10-bounded-repeat/compile-context | 1 | 13.70 ± 0.4% | not timed | not timed | 11.01 ± 0.1% | 15.65 ± 1.6% | not timed | not timed | 13.58 ± 2.2% | | 1.01 | 1.24 | 0.88 |
| 10-bounded-repeat/compile-capitals | 1 | 82.61 ± 0.5% | not timed | not timed | 8.00 ± 0.1% | 23.39 ± 3.3% | not timed | not timed | 82.53 ± 0.6% | | 1.00 | 10.33 | 3.53 |
| 11-unstructured-to-json/compile | 1 | 86.63 ± 0.2% | not timed | not timed | 41.10 ± 0.8% | 66.71 ± 4.5% | not timed | not timed | 86.33 ± 0.8% | | 1.00 | 2.11 | 1.30 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.7% | not timed | not timed | 0.07 ± 0.8% | 0.09 ± 7.3% | not timed | not timed | 0.35 ± 0.3% | | 1.00 | 5.21 | 3.80 |

