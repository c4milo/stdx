# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102071050 |
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
| literal: a word | 217 | 40658.58 ± 0.4% | 1029.14 ± 0.3% | 33.20 ± 1.0% | 38674.81 ± 3.2% | 11360.87 ± 30.0% | 12.33 ± 3.7% | 103.90 ± 0.7% | 40545.29 ± 5.1% | 39.51 | 1.00 | 1.05 | 3.58 |
| literal: a word that is not there | 0 | 57057.52 ± 0.4% | 1039.50 ± 0.5% | 33.19 ± 0.7% | 45365.89 ± 3.5% | 42514.36 ± 6.6% | 12.27 ± 2.5% | 98.47 ± 3.7% | 57062.12 ± 1.5% | 54.89 | 1.00 | 1.26 | 1.34 |
| literal: one of four words | 661 | 14664.09 ± 0.8% | 1005.35 ± 0.4% | 17.43 ± 0.3% | 11139.51 ± 0.1% | 24.92 ± 0.3% | 4.46 ± 0.3% | 8.66 ± 3.4% | 14635.03 ± 0.4% | 14.59 | 1.00 | 1.32 | 588.51 |
| literal: a word in any case | 217 | 35991.08 ± 2.0% | 1026.97 ± 0.6% | 24.25 ± 3.7% | 11282.72 ± 0.6% | 47.34 ± 1.4% | refused | differs | 35990.21 ± 1.4% | 35.05 | 1.00 | 3.19 | 760.26 |
| literal: an href attribute | 33 | 35109.70 ± 0.7% | 1035.02 ± 0.2% | 31.89 ± 1.5% | 34772.04 ± 0.3% | 2971.26 ± 15.1% | 9.54 ± 0.1% | 91.43 ± 0.9% | 35042.66 ± 0.4% | 33.92 | 1.00 | 1.01 | 11.82 |
| literal: a word, second text | 123 | 44160.23 ± 0.5% | 1030.28 ± 0.4% | 32.52 ± 0.4% | 39270.52 ± 1.1% | 10671.99 ± 16.7% | 13.04 ± 0.4% | 87.49 ± 2.5% | 44213.76 ± 0.4% | 42.86 | 1.00 | 1.12 | 4.14 |
| class: two capitalized words | 1331 | 899.42 ± 0.2% | 950.89 ± 0.5% | 30.58 ± 6.3% | 576.49 ± 0.2% | 44.42 ± 1.9% | 10.59 ± 0.3% | 79.85 ± 5.4% | 894.98 ± 1.7% | 0.95 | 1.00 | 1.56 | 20.25 |
| class: a word that ends in ing | 3399 | 870.48 ± 0.4% | 871.23 ± 0.5% | 20.58 ± 1.2% | 540.43 ± 6.7% | 32.72 ± 3.8% | 5.89 ± 0.3% | 20.65 ± 0.3% | 869.39 ± 0.5% | 1.00 | 1.00 | 1.61 | 26.60 |
| class: a word in capitals | 2332 | 1150.61 ± 0.4% | 928.89 ± 0.7% | 32.40 ± 0.7% | 565.33 ± 0.5% | 47.30 ± 9.3% | 11.59 ± 0.4% | 102.26 ± 5.4% | 1153.42 ± 3.4% | 1.24 | 1.00 | 2.04 | 24.33 |
| class: a number | 8288 | 1786.39 ± 0.1% | 788.51 ± 0.1% | 32.77 ± 1.0% | 1798.77 ± 0.2% | 46.11 ± 9.6% | 0.39 ± 0.6% | 73.36 ± 5.7% | 1798.84 ± 0.0% | 2.27 | 0.99 | 0.99 | 38.74 |
| class: two capitalized words, second text | 5359 | 683.36 ± 0.2% | 683.06 ± 0.8% | 27.19 ± 0.7% | 478.42 ± 0.1% | 38.49 ± 4.1% | 11.46 ± 0.5% | 74.04 ± 0.9% | 683.93 ± 0.8% | 1.00 | 1.00 | 1.43 | 17.75 |
| other: a word between two words | 6104 | 774.46 ± 0.4% | 732.23 ± 0.2% | 27.09 ± 2.3% | 811.96 ± 0.6% | 127.21 ± 10.1% | 8.33 ± 0.6% | 82.54 ± 0.2% | 768.57 ± 0.6% | 1.06 | 1.01 | 0.95 | 6.09 |
| other: a number before a unit, second text | 1481 | 9402.44 ± 4.4% | 979.97 ± 0.8% | 30.46 ± 0.6% | 8174.47 ± 0.3% | 44.69 ± 9.0% | 12.00 ± 0.6% | 77.99 ± 5.2% | 9371.78 ± 4.2% | 9.59 | 1.00 | 1.15 | 210.40 |
| other: a heading's start tag | 110 | 24666.12 ± 1.3% | 1025.12 ± 0.1% | 32.89 ± 2.2% | 2575.55 ± 26.3% | 1948.14 ± 3.8% | 11.57 ± 3.9% | 105.58 ± 14.8% | 24685.88 ± 0.4% | 24.06 | 1.00 | 9.58 | 12.66 |
| other: a whole word | 217 | 28976.18 ± 0.3% | 1028.09 ± 0.3% | 32.68 ± 4.2% | 28158.76 ± 1.0% | 54.19 ± 1.3% | 10.88 ± 0.2% | 63.32 ± 0.5% | 28593.74 ± 4.9% | 28.18 | 1.01 | 1.03 | 534.70 |
| other: a line's first word, second text | 3716 | 2296.54 ± 2.1% | 848.96 ± 0.3% | 36.19 ± 0.7% | 2319.62 ± 1.7% | 70.91 ± 4.9% | refused | refused | 2269.96 ± 3.1% | 2.71 | 1.01 | 0.99 | 32.39 |
| other: fourteen octets before an x | 87 | 35569.41 ± 1.0% | 247.44 ± 2.4% | 6.07 ± 0.1% | 3565.33 ± 0.2% | 11.52 ± 1.5% | differs | 21.51 ± 2.7% | 35826.06 ± 0.9% | 143.75 | 0.99 | 9.98 | 3086.90 |
| other: a Greek word | 21815 | 463.64 ± 0.4% | 327.13 ± 1.2% | 33.72 ± 7.9% | 303.47 ± 1.2% | 57.88 ± 22.6% | differs | refused | 462.93 ± 0.7% | 1.42 | 1.00 | 1.53 | 8.01 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 30.25 ± 7.3% | 30.23 ± 1.7% | 1.00 ± 0.4% | 19.85 ± 0.3% | 2.12 ± 1.4% | differs | 4.33 ± 5.2% | 30.23 ± 0.4% | 1.00 | 1.00 | 1.52 | 14.27 |
| a UUID | 32895 | 24.47 ± 0.3% | 24.43 ± 0.2% | 0.73 ± 0.9% | 15.13 ± 0.2% | 3.07 ± 4.8% | 0.52 ± 0.4% | 3.84 ± 1.3% | 24.44 ± 0.6% | 1.00 | 1.00 | 1.62 | 7.97 |
| an IPv4 address | 33176 | 41.75 ± 0.4% | 41.75 ± 0.3% | 2.35 ± 9.1% | 28.41 ± 0.1% | 6.99 ± 10.1% | differs | 4.32 ± 1.2% | 41.91 ± 5.2% | 1.00 | 1.00 | 1.47 | 5.98 |
| a date and time | 32954 | 36.51 ± 0.1% | 36.55 ± 0.3% | 1.72 ± 1.4% | 21.61 ± 0.4% | 8.22 ± 5.6% | 0.91 ± 0.3% | 8.07 ± 20.3% | 36.54 ± 0.9% | 1.00 | 1.00 | 1.69 | 4.44 |
| a field path | 32606 | 33.65 ± 8.4% | 33.67 ± 0.3% | 1.10 ± 0.5% | 22.92 ± 0.2% | 3.53 ± 3.7% | differs | 3.03 ± 10.8% | 33.57 ± 0.5% | 1.00 | 1.00 | 1.47 | 9.52 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.58 ± 0.3% | 10.54 ± 0.7% | 10.58 ± 0.6% | 13.41 ± 0.8% | 5.77 ± 5.1% | 0.75 ± 1.2% | none | 10.45 ± 0.2% | 1.00 | 1.01 | 0.79 | 1.83 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 241.40 ± 0.2% | 242.56 ± 0.2% | 284.65 ± 1.7% | 101.07 ± 2.0% | 233.47 ± 13.8% | 688.03 ± 9.0% | 4947.91 ± 0.5% | 241.31 ± 0.5% | 1.00 | 1.00 | 2.39 | 1.03 |
| a UUID | 62 | 155.91 ± 2.6% | 156.44 ± 7.7% | 175.41 ± 0.2% | 58.66 ± 1.6% | 117.31 ± 13.1% | 256.72 ± 1.9% | 5520.19 ± 1.3% | 156.22 ± 15.5% | 1.00 | 1.00 | 2.66 | 1.33 |
| an IPv4 address | 29 | 502.89 ± 0.2% | 508.64 ± 1.0% | 744.37 ± 0.1% | 88.94 ± 0.8% | 145.18 ± 2.9% | 409.77 ± 0.6% | 8996.67 ± 0.3% | 502.15 ± 0.5% | 0.99 | 1.00 | 5.65 | 3.46 |
| a date and time | 56 | 373.95 ± 8.6% | 376.50 ± 0.8% | 487.95 ± 0.2% | 87.17 ± 12.4% | 157.43 ± 5.1% | 475.96 ± 13.0% | 5696.10 ± 10.4% | 374.07 ± 0.3% | 0.99 | 1.00 | 4.29 | 2.38 |
| a field path | 39 | 231.02 ± 0.8% | 232.04 ± 1.3% | 271.18 ± 0.3% | 95.83 ± 1.0% | 224.71 ± 2.0% | 755.26 ± 0.4% | 6036.54 ± 0.8% | 230.71 ± 0.2% | 1.00 | 1.00 | 2.41 | 1.03 |
| literal: a word | 7 | 745.57 ± 1.8% | 791.55 ± 0.7% | 1516.85 ± 0.4% | 626.44 ± 0.5% | 772.94 ± 5.1% | 1653.56 ± 2.3% | 34134.85 ± 11.3% | 743.36 ± 0.2% | 0.94 | 1.00 | 1.19 | 0.96 |
| literal: a word that is not there | 8 | 721.48 ± 0.3% | 767.59 ± 0.3% | 1427.31 ± 0.3% | 577.83 ± 1.1% | 744.54 ± 35.1% | 1552.44 ± 0.8% | 33378.28 ± 0.6% | 720.11 ± 0.7% | 0.94 | 1.00 | 1.25 | 0.97 |
| literal: one of four words | 26 | 274.39 ± 2.5% | 464.48 ± 2.3% | 647.17 ± 3.3% | 53.16 ± 5.2% | 283.09 ± 10.7% | 568.36 ± 2.2% | 18885.40 ± 1.9% | 273.97 ± 0.8% | 0.59 | 1.00 | 5.16 | 0.97 |
| literal: a word in any case | 11 | 575.26 ± 0.4% | 611.49 ± 0.3% | 987.12 ± 0.5% | 18.90 ± 1.9% | 812.44 ± 1.5% | refused | 27079.99 ± 5.1% | 570.00 ± 1.4% | 0.94 | 1.01 | 30.43 | 0.71 |
| literal: an href attribute | 12 | 407.61 ± 0.2% | 421.55 ± 1.0% | 578.73 ± 1.5% | 50.40 ± 0.5% | 570.21 ± 2.3% | 1267.04 ± 0.8% | 24540.59 ± 1.8% | 407.25 ± 0.2% | 0.97 | 1.00 | 8.09 | 0.71 |
| literal: a word, second text | 10 | 666.58 ± 0.4% | 722.48 ± 16.4% | 1281.65 ± 0.3% | 520.27 ± 0.6% | 649.34 ± 17.7% | 1345.63 ± 0.5% | 31754.94 ± 11.2% | 665.33 ± 3.7% | 0.92 | 1.00 | 1.28 | 1.03 |
| class: two capitalized words | 23 | 523.68 ± 0.3% | 565.69 ± 0.2% | 857.25 ± 0.6% | 120.80 ± 8.7% | 605.10 ± 4.0% | 1215.95 ± 0.6% | 7974.08 ± 2.2% | 524.02 ± 0.2% | 0.93 | 1.00 | 4.33 | 0.87 |
| class: a word that ends in ing | 9 | 645.94 ± 0.4% | 728.91 ± 0.5% | 1354.01 ± 15.3% | 149.05 ± 10.7% | 857.58 ± 1.8% | 1804.48 ± 0.8% | 19285.36 ± 0.2% | 645.46 ± 0.4% | 0.89 | 1.00 | 4.33 | 0.75 |
| class: a word in capitals | 16 | 562.02 ± 0.6% | 612.03 ± 2.2% | 1046.05 ± 10.7% | 155.45 ± 1.1% | 884.18 ± 1.5% | 1712.44 ± 0.4% | 10555.52 ± 0.2% | 560.87 ± 0.3% | 0.92 | 1.00 | 3.62 | 0.64 |
| class: a number | 6 | 695.78 ± 0.3% | 776.27 ± 0.2% | 1550.49 ± 0.3% | 46.95 ± 1.5% | 1632.50 ± 2.5% | 2902.37 ± 2.0% | 25884.86 ± 0.3% | 695.36 ± 0.3% | 0.90 | 1.00 | 14.82 | 0.43 |
| class: two capitalized words, second text | 23 | 522.83 ± 1.8% | 564.66 ± 0.8% | 860.59 ± 1.1% | 120.18 ± 1.3% | 595.50 ± 21.7% | 1249.17 ± 1.0% | 7998.20 ± 0.2% | 522.34 ± 0.4% | 0.93 | 1.00 | 4.35 | 0.88 |
| other: a word between two words | 13 | 644.32 ± 2.8% | 666.21 ± 0.4% | 1108.60 ± 0.3% | 157.96 ± 1.7% | 575.26 ± 1.9% | 1330.77 ± 0.8% | 17921.54 ± 1.0% | 644.18 ± 0.5% | 0.97 | 1.00 | 4.08 | 1.12 |
| other: a number before a unit, second text | 15 | 441.28 ± 0.8% | 493.01 ± 1.0% | 700.15 ± 12.9% | 43.72 ± 13.5% | 719.59 ± 11.1% | 1442.59 ± 2.0% | 17819.28 ± 0.3% | 441.33 ± 5.0% | 0.90 | 1.00 | 10.09 | 0.61 |
| other: a heading's start tag | 13 | 420.92 ± 0.5% | 429.55 ± 0.2% | 590.98 ± 6.2% | 47.97 ± 0.9% | 708.77 ± 0.8% | 1402.25 ± 1.5% | 20716.11 ± 0.4% | 420.95 ± 0.2% | 0.98 | 1.00 | 8.77 | 0.59 |
| other: a whole word | 11 | 669.63 ± 0.5% | 703.67 ± 1.8% | 1218.81 ± 0.6% | 140.21 ± 0.6% | 681.39 ± 1.7% | 1403.57 ± 0.9% | 31946.32 ± 0.5% | 667.27 ± 1.6% | 0.95 | 1.00 | 4.78 | 0.98 |
| other: a line's first word, second text | 17 | 617.98 ± 0.9% | 652.29 ± 0.4% | 1105.30 ± 1.0% | 150.46 ± 0.5% | 798.91 ± 25.7% | refused | refused | 613.76 ± 2.9% | 0.95 | 1.01 | 4.11 | 0.77 |
| other: fourteen octets before an x | 16 | 117.87 ± 1.7% | 175.94 ± 0.6% | 211.62 ± 0.3% | 18.24 ± 7.2% | 519.83 ± 18.4% | 581.15 ± 8.5% | 15722.88 ± 13.3% | 117.83 ± 0.8% | 0.67 | 1.00 | 6.46 | 0.23 |
| other: a Greek word | 8 | 438.49 ± 0.7% | 619.77 ± 2.6% | 1032.81 ± 3.8% | 62.03 ± 10.4% | 1612.12 ± 14.7% | 2705.84 ± 4.0% | refused | 434.71 ± 7.6% | 0.71 | 1.01 | 7.07 | 0.27 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 27106.96 ± 0.4% | not timed | not timed | 33687.60 ± 1.9% | 2689.22 ± 30.9% | not timed | not timed | 27109.75 ± 0.5% | | 1.00 | 0.80 | 10.08 |
| 01-literal/sherlock-casei-en | 522 | 6448.10 ± 1.3% | not timed | not timed | 9040.53 ± 0.2% | 31.74 ± 5.4% | not timed | not timed | 6415.21 ± 0.7% | | 1.01 | 0.71 | 203.13 |
| 01-literal/sherlock-ru | 724 | 29687.25 ± 0.3% | not timed | not timed | 34353.88 ± 1.0% | 1265.70 ± 5.8% | not timed | not timed | 29659.06 ± 0.7% | | 1.00 | 0.86 | 23.46 |
| 01-literal/sherlock-casei-ru | 746 | 8943.29 ± 0.6% | not timed | not timed | 7825.81 ± 4.2% | 36.87 ± 3.6% | not timed | not timed | 8905.79 ± 0.9% | | 1.00 | 1.14 | 242.56 |
| 01-literal/sherlock-zh | 30 | 52159.04 ± 1.2% | not timed | not timed | 42638.93 ± 9.4% | 1636.93 ± 0.8% | not timed | not timed | 52257.81 ± 0.4% | | 1.00 | 1.22 | 31.86 |
| 02-literal-alternate/sherlock-en | 714 | 13148.71 ± 0.5% | not timed | not timed | 10933.12 ± 0.2% | 19.09 ± 0.8% | not timed | not timed | 13159.72 ± 0.6% | | 1.00 | 1.20 | 688.84 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2153.21 ± 1.3% | not timed | not timed | 2298.14 ± 1.6% | 12.22 ± 5.9% | not timed | not timed | 2107.47 ± 1.0% | | 1.02 | 0.94 | 176.16 |
| 02-literal-alternate/sherlock-ru | 899 | 7567.15 ± 0.9% | not timed | not timed | 9812.22 ± 0.7% | 25.31 ± 0.9% | not timed | not timed | 7575.97 ± 1.2% | | 1.00 | 0.77 | 298.92 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2104.50 ± 0.4% | not timed | not timed | 1189.68 ± 4.4% | 10.59 ± 0.5% | not timed | not timed | 2092.63 ± 3.6% | | 1.01 | 1.77 | 198.72 |
| 02-literal-alternate/sherlock-zh | 207 | 18922.17 ± 0.2% | not timed | not timed | 12681.14 ± 0.2% | 35.61 ± 0.5% | not timed | not timed | 18877.59 ± 0.7% | | 1.00 | 1.49 | 531.44 |
| 03-date/ascii | 111817 | 128.44 ± 5.3% | not timed | not timed | 98.62 ± 1.3% | 0.23 ± 3.5% | not timed | not timed | 128.84 ± 5.4% | | 1.00 | 1.30 | 562.01 |
| 04-ruff-noqa/real | 84 | 685.26 ± 5.9% | not timed | not timed | 505.87 ± 0.9% | 20.53 ± 4.3% | not timed | not timed | 685.06 ± 0.3% | | 1.00 | 1.35 | 33.38 |
| 04-ruff-noqa/tweaked | 44 | 615.27 ± 3.9% | not timed | not timed | 511.14 ± 6.1% | 366.39 ± 3.1% | not timed | not timed | 606.55 ± 2.0% | | 1.01 | 1.20 | 1.68 |
| 05-lexer-veryl/single | 124800 | 3.72 ± 0.3% | not timed | not timed | 5.44 ± 2.2% | 0.25 ± 7.7% | not timed | not timed | 3.66 ± 4.1% | | 1.02 | 0.68 | 14.76 |
| 06-cloud-flare-redos/original | 107 | 218.87 ± 3.0% | not timed | not timed | 228.46 ± 0.3% | 25.85 ± 1.3% | not timed | not timed | 218.86 ± 12.4% | | 1.00 | 0.96 | 8.47 |
| 06-cloud-flare-redos/simplified-short | 102 | 161.09 ± 0.3% | not timed | not timed | 236.68 ± 0.3% | 27.70 ± 2.0% | not timed | not timed | 161.02 ± 27.7% | | 1.00 | 0.68 | 5.81 |
| 06-cloud-flare-redos/simplified-long | 10000 | 168.06 ± 19.1% | not timed | not timed | 258.21 ± 4.1% | 29.56 ± 17.7% | not timed | not timed | 167.81 ± 3.0% | | 1.00 | 0.65 | 5.68 |
| 07-unicode-character-data/parse-line | 558784 | 48.72 ± 9.0% | not timed | not timed | 196.96 ± 0.4% | 48.25 ± 2.2% | not timed | not timed | 48.95 ± 1.5% | | 1.00 | 0.25 | 1.01 |
| 08-words/all-english | 56691 | 98.74 ± 0.4% | not timed | not timed | 84.02 ± 0.2% | 14.03 ± 12.4% | not timed | not timed | 99.78 ± 0.4% | | 0.99 | 1.18 | 7.04 |
| 08-words/long-english | 839 | 984.21 ± 0.1% | not timed | not timed | 584.87 ± 0.1% | 35.01 ± 0.5% | not timed | not timed | 984.17 ± 0.3% | | 1.00 | 1.68 | 28.11 |
| 09-aws-keys/full | 0 | 523.01 ± 1.5% | not timed | not timed | 532.60 ± 3.4% | 66.29 ± 3.2% | not timed | not timed | 523.00 ± 0.2% | | 1.00 | 0.98 | 7.89 |
| 09-aws-keys/quick | 0 | 547.18 ± 0.1% | not timed | not timed | 965.02 ± 1.2% | 399.16 ± 0.6% | not timed | not timed | 543.44 ± 1.6% | | 1.01 | 0.57 | 1.37 |
| 10-bounded-repeat/letters-en | 1833 | 634.55 ± 1.8% | not timed | not timed | 556.01 ± 0.6% | 22.55 ± 1.8% | not timed | not timed | 629.80 ± 2.4% | | 1.01 | 1.14 | 28.14 |
| 10-bounded-repeat/letters-ru | 3475 | 370.87 ± 0.1% | not timed | not timed | 482.85 ± 0.7% | 25.07 ± 9.1% | not timed | not timed | 370.49 ± 0.5% | | 1.00 | 0.77 | 14.79 |
| 10-bounded-repeat/context | 53 | 75.46 ± 10.0% | not timed | not timed | 70.39 ± 1.3% | 22.41 ± 1.8% | not timed | not timed | 76.71 ± 5.0% | | 0.98 | 1.07 | 3.37 |
| 10-bounded-repeat/capitals | 11 | 1021.93 ± 6.7% | not timed | not timed | 604.50 ± 1.5% | 40.23 ± 0.3% | not timed | not timed | 1027.90 ± 1.2% | | 0.99 | 1.69 | 25.40 |
| 11-unstructured-to-json/extract | 600 | 26.61 ± 0.2% | not timed | not timed | 81.21 ± 0.2% | 31.22 ± 42.0% | not timed | not timed | 26.58 ± 0.7% | | 1.00 | 0.33 | 0.85 |
| 12-dictionary/single | 1 | 508.36 ± 0.1% | not timed | not timed | 479.49 ± 0.2% | 0.39 ± 2.8% | not timed | not timed | 511.41 ± 1.7% | | 0.99 | 1.06 | 1302.51 |
| 14-quadratic/1x | 100 | 13.48 ± 4.0% | not timed | not timed | 12.16 ± 3.4% | 1.02 ± 7.8% | not timed | not timed | 13.48 ± 15.1% | | 1.00 | 1.11 | 13.20 |
| 14-quadratic/2x | 200 | 7.99 ± 0.7% | not timed | not timed | 6.06 ± 0.4% | 0.56 ± 1.3% | not timed | not timed | 8.03 ± 0.5% | | 1.00 | 1.32 | 14.39 |
| 14-quadratic/10x | 1000 | 1.83 ± 3.4% | not timed | not timed | 1.22 ± 0.2% | 0.12 ± 1.9% | not timed | not timed | 1.83 ± 0.7% | | 1.00 | 1.50 | 15.28 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.65 ± 12.0% | not timed | not timed | 0.47 ± 7.2% | 0.61 ± 8.5% | not timed | not timed | 1.65 ± 2.5% | | 1.00 | 3.50 | 2.70 |
| 04-ruff-noqa/compile-real | 1 | 101.23 ± 0.7% | not timed | not timed | 17.10 ± 1.6% | 161.24 ± 2.4% | not timed | not timed | 100.92 ± 1.0% | | 1.00 | 5.92 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 17.11 ± 0.6% | not timed | not timed | 3.00 ± 0.6% | 7.70 ± 14.4% | not timed | not timed | 17.02 ± 1.0% | | 1.01 | 5.70 | 2.22 |
| 07-unicode-character-data/compile | 1 | 64.56 ± 0.2% | not timed | not timed | 30.60 ± 0.6% | 40.59 ± 8.4% | not timed | not timed | 64.24 ± 2.9% | | 1.00 | 2.11 | 1.59 |
| 09-aws-keys/compile-full | 1 | 45.27 ± 2.2% | not timed | not timed | 9.85 ± 1.2% | 27.13 ± 72.3% | not timed | not timed | 44.76 ± 20.2% | | 1.01 | 4.60 | 1.67 |
| 09-aws-keys/compile-quick | 1 | 197.37 ± 8.7% | not timed | not timed | 57.15 ± 0.7% | 153.26 ± 6.8% | not timed | not timed | 198.17 ± 1.0% | | 1.00 | 3.45 | 1.29 |
| 10-bounded-repeat/compile-context | 1 | 15.52 ± 0.5% | not timed | not timed | 14.63 ± 0.4% | 20.02 ± 3.8% | not timed | not timed | 15.46 ± 1.0% | | 1.00 | 1.06 | 0.78 |
| 10-bounded-repeat/compile-capitals | 1 | 93.86 ± 1.5% | not timed | not timed | 10.82 ± 3.9% | 28.41 ± 7.3% | not timed | not timed | 92.91 ± 0.8% | | 1.01 | 8.67 | 3.30 |
| 11-unstructured-to-json/compile | 1 | 99.81 ± 1.1% | not timed | not timed | 47.06 ± 0.6% | 77.99 ± 5.8% | not timed | not timed | 98.89 ± 3.2% | | 1.01 | 2.12 | 1.28 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.1% | not timed | not timed | 0.08 ± 3.3% | 0.11 ± 8.9% | not timed | not timed | 0.35 ± 1.8% | | 1.00 | 4.21 | 3.20 |

