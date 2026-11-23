# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
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
| literal: a word | 217 | 16183.08 ± 0.7% | 1049.50 ± 0.1% | 28.69 ± 0.6% | 18469.62 ± 1.5% | 9201.92 ± 7.9% | 17.22 ± 0.2% | 86.55 ± 0.2% | 16236.17 ± 0.5% | 15.42 | 1.00 | 0.88 | 1.76 |
| literal: a word that is not there | 0 | 18756.38 ± 1.3% | 1057.11 ± 0.8% | 28.76 ± 0.3% | 19885.34 ± 2.1% | 29553.33 ± 0.6% | 17.02 ± 0.3% | 82.32 ± 0.2% | 18823.27 ± 1.5% | 17.74 | 1.00 | 0.94 | 0.63 |
| literal: one of four words | 661 | 6072.04 ± 0.5% | 1031.42 ± 0.1% | 14.68 ± 0.6% | 3950.07 ± 0.1% | 21.86 ± 0.1% | 5.34 ± 0.2% | 6.94 ± 1.2% | 6065.36 ± 0.3% | 5.89 | 1.00 | 1.54 | 277.80 |
| literal: a word in any case | 217 | 12632.56 ± 0.6% | 1048.07 ± 0.5% | 21.88 ± 0.4% | 3976.94 ± 0.1% | 38.07 ± 0.2% | refused | differs | 12631.04 ± 0.4% | 12.05 | 1.00 | 3.18 | 331.78 |
| literal: an href attribute | 33 | 13532.23 ± 0.5% | 1053.70 ± 0.3% | 27.33 ± 0.1% | 17089.29 ± 2.2% | 2255.05 ± 0.5% | 13.10 ± 0.2% | 75.23 ± 0.6% | 13477.55 ± 1.2% | 12.84 | 1.00 | 0.79 | 6.00 |
| literal: a word, second text | 123 | 16330.15 ± 0.8% | 1050.54 ± 0.3% | 28.12 ± 0.2% | 18400.61 ± 0.8% | 7998.56 ± 8.0% | 20.13 ± 0.9% | 70.19 ± 0.4% | 16294.10 ± 0.6% | 15.54 | 1.00 | 0.89 | 2.04 |
| class: two capitalized words | 1331 | 1120.36 ± 0.4% | 980.57 ± 0.6% | 26.08 ± 0.3% | 585.53 ± 0.1% | 40.54 ± 13.0% | 14.67 ± 0.3% | 68.91 ± 0.3% | 1122.24 ± 0.3% | 1.14 | 1.00 | 1.91 | 27.63 |
| class: a word that ends in ing | 3399 | 901.86 ± 0.3% | 902.33 ± 0.2% | 18.20 ± 0.2% | 547.49 ± 0.0% | 29.62 ± 3.4% | 8.14 ± 0.2% | 18.41 ± 0.4% | 901.95 ± 0.2% | 1.00 | 1.00 | 1.65 | 30.45 |
| class: a word in capitals | 2332 | 1465.85 ± 0.7% | 956.68 ± 0.2% | 27.67 ± 0.2% | 572.65 ± 0.1% | 43.47 ± 2.6% | 17.09 ± 0.3% | 83.14 ± 0.3% | 1462.57 ± 0.6% | 1.53 | 1.00 | 2.56 | 33.72 |
| class: a number | 8288 | 2001.75 ± 0.4% | 839.14 ± 0.1% | 27.93 ± 0.2% | 1719.19 ± 0.2% | 41.51 ± 16.0% | 0.54 ± 0.1% | 56.66 ± 0.4% | 2003.02 ± 0.1% | 2.39 | 1.00 | 1.16 | 48.22 |
| class: two capitalized words, second text | 5359 | 743.68 ± 0.1% | 745.45 ± 0.1% | 23.39 ± 0.2% | 485.15 ± 0.1% | 35.01 ± 10.8% | 17.12 ± 0.2% | 64.03 ± 0.1% | 743.66 ± 0.1% | 1.00 | 1.00 | 1.53 | 21.24 |
| other: a word between two words | 6104 | 752.75 ± 0.2% | 781.67 ± 0.4% | 23.52 ± 0.2% | 738.44 ± 0.2% | 107.16 ± 9.5% | 11.14 ± 0.1% | 69.69 ± 0.1% | 749.81 ± 0.1% | 0.96 | 1.00 | 1.02 | 7.02 |
| other: a number before a unit, second text | 1481 | 5386.79 ± 0.3% | 991.30 ± 0.1% | 26.07 ± 0.2% | 5661.19 ± 0.5% | 40.68 ± 8.9% | 18.17 ± 0.2% | 66.95 ± 0.3% | 5368.36 ± 0.5% | 5.43 | 1.00 | 0.95 | 132.41 |
| other: a heading's start tag | 110 | 12572.14 ± 1.2% | 1044.70 ± 0.2% | 27.60 ± 0.3% | 1715.12 ± 0.3% | 1585.52 ± 5.0% | 15.95 ± 0.4% | 88.78 ± 0.2% | 12570.04 ± 0.3% | 12.03 | 1.00 | 7.33 | 7.93 |
| other: a whole word | 217 | 14156.03 ± 1.2% | 1047.52 ± 0.2% | 29.63 ± 1.2% | 14638.62 ± 1.4% | 49.43 ± 0.4% | 12.99 ± 0.1% | 55.63 ± 0.2% | 14093.59 ± 1.3% | 13.51 | 1.00 | 0.97 | 286.36 |
| other: a line's first word, second text | 3716 | 1959.20 ± 0.9% | 879.02 ± 0.2% | 31.20 ± 0.1% | 1725.29 ± 0.4% | 63.29 ± 7.0% | refused | refused | 1951.20 ± 0.4% | 2.23 | 1.00 | 1.14 | 30.95 |
| other: fourteen octets before an x | 87 | 19982.67 ± 0.6% | 228.95 ± 0.3% | 6.64 ± 0.1% | 4020.16 ± 0.6% | 10.65 ± 0.2% | differs | 17.77 ± 0.1% | 20055.46 ± 0.8% | 87.28 | 1.00 | 4.97 | 1875.67 |
| other: a Greek word | 21815 | 514.14 ± 0.3% | 411.20 ± 0.2% | 31.29 ± 0.2% | 284.95 ± 0.2% | 49.15 ± 11.8% | differs | refused | 511.57 ± 0.5% | 1.25 | 1.01 | 1.80 | 10.46 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.86 ± 0.3% | 25.84 ± 0.3% | 0.87 ± 0.2% | 19.64 ± 0.5% | 2.75 ± 0.5% | differs | 4.03 ± 0.2% | 25.86 ± 0.4% | 1.00 | 1.00 | 1.32 | 9.40 |
| a UUID | 32895 | 21.07 ± 0.4% | 21.14 ± 0.2% | 0.65 ± 0.1% | 15.21 ± 0.6% | 3.08 ± 0.5% | 0.74 ± 0.3% | 3.61 ± 0.6% | 21.20 ± 0.2% | 1.00 | 0.99 | 1.38 | 6.84 |
| an IPv4 address | 33176 | 36.86 ± 0.3% | 36.73 ± 0.1% | 2.11 ± 0.3% | 29.31 ± 0.7% | 6.63 ± 0.1% | differs | 4.14 ± 0.2% | 36.89 ± 0.2% | 1.00 | 1.00 | 1.26 | 5.56 |
| a date and time | 32954 | 31.04 ± 0.6% | 31.11 ± 0.6% | 1.48 ± 0.4% | 21.63 ± 0.1% | 7.03 ± 0.5% | 1.25 ± 0.1% | 7.16 ± 0.4% | 30.98 ± 0.5% | 1.00 | 1.00 | 1.44 | 4.42 |
| a field path | 32606 | 29.50 ± 0.1% | 29.44 ± 0.1% | 1.04 ± 0.2% | 23.29 ± 0.4% | 3.50 ± 0.3% | differs | 2.96 ± 0.1% | 29.45 ± 0.1% | 1.00 | 1.00 | 1.27 | 8.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.54 ± 0.3% | 11.38 ± 0.6% | 11.53 ± 0.8% | 11.42 ± 0.1% | 4.96 ± 1.2% | 0.94 ± 0.5% | none | 11.49 ± 0.2% | 1.01 | 1.00 | 1.01 | 2.32 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.35 ± 0.2% | 235.89 ± 0.3% | 286.71 ± 0.3% | 86.96 ± 0.4% | 218.75 ± 1.9% | 450.90 ± 0.6% | 3868.82 ± 1.2% | 234.29 ± 0.1% | 0.99 | 1.00 | 2.69 | 1.07 |
| a UUID | 62 | 157.27 ± 0.3% | 157.79 ± 0.2% | 179.43 ± 0.2% | 46.14 ± 1.0% | 99.16 ± 0.8% | 183.47 ± 3.2% | 4438.97 ± 1.6% | 157.25 ± 0.4% | 1.00 | 1.00 | 3.41 | 1.59 |
| an IPv4 address | 29 | 418.21 ± 0.5% | 423.97 ± 0.1% | 613.33 ± 0.3% | 77.44 ± 0.5% | 130.72 ± 2.5% | 286.67 ± 1.1% | 7629.19 ± 0.5% | 418.36 ± 0.5% | 0.99 | 1.00 | 5.40 | 3.20 |
| a date and time | 56 | 307.07 ± 0.2% | 310.12 ± 0.3% | 399.73 ± 0.1% | 72.89 ± 1.0% | 135.36 ± 10.1% | 316.32 ± 3.8% | 4911.68 ± 0.4% | 307.26 ± 0.2% | 0.99 | 1.00 | 4.21 | 2.27 |
| a field path | 39 | 226.64 ± 0.4% | 228.10 ± 0.2% | 274.91 ± 0.1% | 80.85 ± 2.4% | 205.65 ± 0.9% | 478.01 ± 1.6% | 4942.27 ± 0.6% | 226.45 ± 0.3% | 0.99 | 1.00 | 2.80 | 1.10 |
| literal: a word | 7 | 620.42 ± 0.7% | 663.32 ± 0.3% | 1246.89 ± 0.2% | 506.46 ± 1.0% | 629.13 ± 0.9% | 916.52 ± 0.5% | 29516.00 ± 0.1% | 620.24 ± 0.5% | 0.94 | 1.00 | 1.23 | 0.99 |
| literal: a word that is not there | 8 | 598.29 ± 0.3% | 645.89 ± 0.1% | 1171.68 ± 0.6% | 468.59 ± 0.2% | 604.57 ± 1.3% | 859.66 ± 0.4% | 28521.14 ± 0.1% | 597.76 ± 0.3% | 0.93 | 1.00 | 1.28 | 0.99 |
| literal: one of four words | 26 | 241.33 ± 0.2% | 399.77 ± 0.3% | 562.52 ± 0.2% | 50.56 ± 1.0% | 243.28 ± 1.8% | 346.77 ± 0.4% | 15408.06 ± 0.1% | 241.41 ± 0.2% | 0.60 | 1.00 | 4.77 | 0.99 |
| literal: a word in any case | 11 | 482.36 ± 0.2% | 514.93 ± 0.2% | 838.44 ± 0.1% | 15.64 ± 0.2% | 650.61 ± 2.6% | refused | 23401.86 ± 0.3% | 482.06 ± 0.3% | 0.94 | 1.00 | 30.83 | 0.74 |
| literal: an href attribute | 12 | 348.47 ± 0.4% | 361.22 ± 0.5% | 489.97 ± 0.6% | 45.60 ± 0.8% | 499.86 ± 4.4% | 733.55 ± 0.8% | 21457.10 ± 0.2% | 348.89 ± 0.3% | 0.96 | 1.00 | 7.64 | 0.70 |
| literal: a word, second text | 10 | 557.73 ± 0.2% | 610.34 ± 0.2% | 1060.78 ± 0.1% | 394.12 ± 0.1% | 536.17 ± 1.5% | 765.64 ± 0.6% | 26460.99 ± 0.3% | 556.86 ± 0.3% | 0.91 | 1.00 | 1.42 | 1.04 |
| class: two capitalized words | 23 | 433.45 ± 0.5% | 465.84 ± 0.5% | 704.90 ± 0.5% | 101.04 ± 0.3% | 503.45 ± 1.8% | 718.58 ± 0.5% | 6573.34 ± 0.8% | 433.73 ± 0.3% | 0.93 | 1.00 | 4.29 | 0.86 |
| class: a word that ends in ing | 9 | 550.33 ± 0.4% | 621.95 ± 0.4% | 1160.65 ± 0.1% | 133.33 ± 0.9% | 755.79 ± 1.0% | 1049.14 ± 0.4% | 16007.61 ± 0.2% | 550.84 ± 0.1% | 0.88 | 1.00 | 4.13 | 0.73 |
| class: a word in capitals | 16 | 485.06 ± 0.4% | 528.88 ± 0.3% | 901.88 ± 0.5% | 135.57 ± 0.6% | 747.34 ± 1.6% | 1006.40 ± 2.2% | 8641.85 ± 0.1% | 485.65 ± 0.2% | 0.92 | 1.00 | 3.58 | 0.65 |
| class: a number | 6 | 603.23 ± 0.4% | 675.60 ± 0.4% | 1359.19 ± 0.1% | 41.57 ± 0.8% | 1397.93 ± 1.2% | 1758.35 ± 1.8% | 22495.86 ± 0.0% | 602.84 ± 0.4% | 0.89 | 1.00 | 14.51 | 0.43 |
| class: two capitalized words, second text | 23 | 433.13 ± 0.3% | 465.66 ± 0.8% | 704.66 ± 0.3% | 100.75 ± 0.5% | 504.38 ± 0.7% | 735.74 ± 0.8% | 6574.37 ± 0.2% | 433.56 ± 0.2% | 0.93 | 1.00 | 4.30 | 0.86 |
| other: a word between two words | 13 | 547.79 ± 0.3% | 565.52 ± 0.2% | 944.02 ± 0.4% | 133.32 ± 0.1% | 503.87 ± 0.6% | 768.99 ± 0.5% | 14805.84 ± 0.1% | 547.42 ± 0.3% | 0.97 | 1.00 | 4.11 | 1.09 |
| other: a number before a unit, second text | 15 | 403.14 ± 0.2% | 445.41 ± 0.3% | 652.45 ± 0.2% | 39.25 ± 0.5% | 635.55 ± 1.5% | 837.59 ± 0.5% | 15081.89 ± 0.1% | 403.34 ± 0.2% | 0.91 | 1.00 | 10.27 | 0.63 |
| other: a heading's start tag | 13 | 359.32 ± 0.5% | 364.58 ± 0.8% | 498.80 ± 1.0% | 43.13 ± 0.2% | 628.77 ± 1.5% | 821.37 ± 1.1% | 17857.76 ± 0.2% | 358.63 ± 0.2% | 0.99 | 1.00 | 8.33 | 0.57 |
| other: a whole word | 11 | 580.30 ± 0.5% | 615.02 ± 0.6% | 1081.30 ± 0.4% | 117.85 ± 0.2% | 560.21 ± 1.1% | 773.87 ± 1.0% | 26467.12 ± 0.5% | 580.68 ± 0.4% | 0.94 | 1.00 | 4.92 | 1.04 |
| other: a line's first word, second text | 17 | 528.03 ± 0.6% | 546.46 ± 0.7% | 934.18 ± 0.6% | 129.50 ± 0.3% | 713.70 ± 1.8% | refused | refused | 527.44 ± 0.8% | 0.97 | 1.00 | 4.08 | 0.74 |
| other: fourteen octets before an x | 16 | 111.58 ± 0.5% | 161.88 ± 0.5% | 190.94 ± 0.8% | 15.16 ± 0.2% | 453.75 ± 1.8% | 394.74 ± 0.3% | 12581.97 ± 1.1% | 111.78 ± 0.7% | 0.69 | 1.00 | 7.36 | 0.25 |
| other: a Greek word | 8 | 420.42 ± 0.2% | 580.62 ± 0.6% | 1041.39 ± 0.2% | 59.13 ± 0.3% | 1392.55 ± 9.6% | 1677.33 ± 1.3% | refused | 419.97 ± 0.4% | 0.72 | 1.00 | 7.11 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12885.03 ± 0.7% | not timed | not timed | 16477.56 ± 1.3% | 2016.03 ± 15.9% | not timed | not timed | 12901.36 ± 1.4% | | 1.00 | 0.78 | 6.39 |
| 01-literal/sherlock-casei-en | 522 | 4489.95 ± 1.3% | not timed | not timed | 3593.73 ± 0.1% | 32.53 ± 0.0% | not timed | not timed | 4479.00 ± 0.2% | | 1.00 | 1.25 | 138.03 |
| 01-literal/sherlock-ru | 724 | 13552.26 ± 0.6% | not timed | not timed | 17339.44 ± 0.3% | 1600.75 ± 4.8% | not timed | not timed | 13531.64 ± 0.4% | | 1.00 | 0.78 | 8.47 |
| 01-literal/sherlock-casei-ru | 746 | 5301.63 ± 0.6% | not timed | not timed | 3320.37 ± 0.1% | 31.78 ± 5.0% | not timed | not timed | 5284.56 ± 0.5% | | 1.00 | 1.60 | 166.82 |
| 01-literal/sherlock-zh | 30 | 17005.39 ± 0.6% | not timed | not timed | 18712.15 ± 0.7% | 2726.28 ± 14.6% | not timed | not timed | 17050.32 ± 0.7% | | 1.00 | 0.91 | 6.24 |
| 02-literal-alternate/sherlock-en | 714 | 5758.42 ± 0.5% | not timed | not timed | 3938.78 ± 0.2% | 16.62 ± 0.1% | not timed | not timed | 5760.96 ± 0.3% | | 1.00 | 1.46 | 346.41 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1711.95 ± 1.1% | not timed | not timed | 695.74 ± 0.2% | 11.13 ± 0.1% | not timed | not timed | 1701.77 ± 0.6% | | 1.01 | 2.46 | 153.86 |
| 02-literal-alternate/sherlock-ru | 899 | 4648.93 ± 0.2% | not timed | not timed | 3255.61 ± 0.1% | 22.62 ± 0.1% | not timed | not timed | 4653.19 ± 0.2% | | 1.00 | 1.43 | 205.52 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1807.25 ± 0.5% | not timed | not timed | 1230.90 ± 0.2% | 9.15 ± 0.1% | not timed | not timed | 1800.70 ± 0.3% | | 1.00 | 1.47 | 197.56 |
| 02-literal-alternate/sherlock-zh | 207 | 7076.16 ± 0.3% | not timed | not timed | 4162.97 ± 0.1% | 31.55 ± 0.1% | not timed | not timed | 7073.52 ± 0.9% | | 1.00 | 1.70 | 224.26 |
| 03-date/ascii | 111817 | 126.51 ± 0.6% | not timed | not timed | 96.13 ± 0.1% | 0.20 ± 6.1% | not timed | not timed | 125.80 ± 1.1% | | 1.01 | 1.32 | 634.67 |
| 04-ruff-noqa/real | 84 | 555.95 ± 0.0% | not timed | not timed | 474.95 ± 0.1% | 19.54 ± 0.3% | not timed | not timed | 555.64 ± 0.1% | | 1.00 | 1.17 | 28.45 |
| 04-ruff-noqa/tweaked | 44 | 541.83 ± 0.2% | not timed | not timed | 465.17 ± 0.1% | 367.31 ± 0.1% | not timed | not timed | 539.72 ± 0.3% | | 1.00 | 1.16 | 1.48 |
| 05-lexer-veryl/single | 124800 | 4.25 ± 0.5% | not timed | not timed | 5.20 ± 0.4% | 0.21 ± 2.9% | not timed | not timed | 4.27 ± 0.4% | | 1.00 | 0.82 | 20.74 |
| 06-cloud-flare-redos/original | 107 | 260.82 ± 0.1% | not timed | not timed | 217.36 ± 0.1% | 24.96 ± 0.2% | not timed | not timed | 260.19 ± 0.6% | | 1.00 | 1.20 | 10.45 |
| 06-cloud-flare-redos/simplified-short | 102 | 255.19 ± 0.1% | not timed | not timed | 228.07 ± 0.0% | 26.76 ± 0.4% | not timed | not timed | 255.25 ± 0.1% | | 1.00 | 1.12 | 9.54 |
| 06-cloud-flare-redos/simplified-long | 10000 | 292.24 ± 0.2% | not timed | not timed | 255.50 ± 0.4% | 28.82 ± 0.1% | not timed | not timed | 292.26 ± 0.1% | | 1.00 | 1.14 | 10.14 |
| 07-unicode-character-data/parse-line | 558784 | 234.98 ± 0.4% | not timed | not timed | 179.09 ± 0.3% | 41.86 ± 13.6% | not timed | not timed | 231.24 ± 2.7% | | 1.02 | 1.31 | 5.61 |
| 08-words/all-english | 56691 | 121.52 ± 0.3% | not timed | not timed | 82.91 ± 0.2% | 11.80 ± 15.4% | not timed | not timed | 120.81 ± 0.3% | | 1.01 | 1.47 | 10.30 |
| 08-words/long-english | 839 | 1012.68 ± 0.1% | not timed | not timed | 596.39 ± 0.1% | 32.49 ± 0.5% | not timed | not timed | 1011.08 ± 0.6% | | 1.00 | 1.70 | 31.17 |
| 09-aws-keys/full | 0 | 408.70 ± 0.1% | not timed | not timed | 493.56 ± 0.1% | 64.62 ± 3.5% | not timed | not timed | 408.59 ± 0.0% | | 1.00 | 0.83 | 6.32 |
| 09-aws-keys/quick | 0 | 741.01 ± 0.1% | not timed | not timed | 1001.05 ± 0.2% | 419.32 ± 4.5% | not timed | not timed | 738.29 ± 0.1% | | 1.00 | 0.74 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 638.16 ± 0.7% | not timed | not timed | 513.20 ± 0.7% | 19.50 ± 0.2% | not timed | not timed | 637.05 ± 0.3% | | 1.00 | 1.24 | 32.73 |
| 10-bounded-repeat/letters-ru | 3475 | 382.68 ± 0.1% | not timed | not timed | 477.20 ± 0.1% | 21.95 ± 9.2% | not timed | not timed | 381.57 ± 0.5% | | 1.00 | 0.80 | 17.43 |
| 10-bounded-repeat/context | 53 | 79.91 ± 1.1% | not timed | not timed | 65.69 ± 0.4% | 19.81 ± 0.2% | not timed | not timed | 79.70 ± 1.0% | | 1.00 | 1.22 | 4.03 |
| 10-bounded-repeat/capitals | 11 | 1054.99 ± 0.3% | not timed | not timed | 618.43 ± 0.1% | 36.49 ± 0.3% | not timed | not timed | 1054.90 ± 0.1% | | 1.00 | 1.71 | 28.91 |
| 11-unstructured-to-json/extract | 600 | 49.94 ± 0.2% | not timed | not timed | 77.35 ± 0.1% | 49.05 ± 0.4% | not timed | not timed | 48.55 ± 0.2% | | 1.03 | 0.65 | 1.02 |
| 12-dictionary/single | 1 | 567.96 ± 0.5% | not timed | not timed | 558.78 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 569.28 ± 0.4% | | 1.00 | 1.02 | 1403.89 |
| 14-quadratic/1x | 100 | 12.84 ± 0.2% | not timed | not timed | 10.03 ± 0.1% | 0.98 ± 2.6% | not timed | not timed | 12.68 ± 1.7% | | 1.01 | 1.28 | 13.08 |
| 14-quadratic/2x | 200 | 7.94 ± 0.4% | not timed | not timed | 5.52 ± 0.1% | 0.54 ± 0.9% | not timed | not timed | 7.89 ± 1.2% | | 1.01 | 1.44 | 14.83 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.5% | not timed | not timed | 1.21 ± 0.3% | 0.12 ± 1.7% | not timed | not timed | 1.87 ± 0.5% | | 1.01 | 1.55 | 16.29 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.3% | not timed | not timed | 0.35 ± 0.4% | 0.55 ± 4.6% | not timed | not timed | 1.45 ± 1.3% | | 1.00 | 4.20 | 2.66 |
| 04-ruff-noqa/compile-real | 1 | 92.41 ± 0.1% | not timed | not timed | 13.80 ± 0.2% | 140.28 ± 2.9% | not timed | not timed | 92.42 ± 1.1% | | 1.00 | 6.70 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.56 ± 1.3% | not timed | not timed | 2.54 ± 0.6% | 6.51 ± 2.4% | not timed | not timed | 14.39 ± 1.5% | | 1.01 | 5.74 | 2.24 |
| 07-unicode-character-data/compile | 1 | 58.36 ± 0.1% | not timed | not timed | 26.10 ± 0.3% | 36.07 ± 4.5% | not timed | not timed | 58.38 ± 0.8% | | 1.00 | 2.24 | 1.62 |
| 09-aws-keys/compile-full | 1 | 43.67 ± 0.2% | not timed | not timed | 8.26 ± 0.4% | 23.30 ± 1.3% | not timed | not timed | 43.53 ± 0.3% | | 1.00 | 5.29 | 1.87 |
| 09-aws-keys/compile-quick | 1 | 187.33 ± 0.2% | not timed | not timed | 46.90 ± 0.2% | 131.83 ± 3.3% | not timed | not timed | 187.72 ± 0.2% | | 1.00 | 3.99 | 1.42 |
| 10-bounded-repeat/compile-context | 1 | 14.66 ± 1.4% | not timed | not timed | 11.08 ± 0.2% | 16.16 ± 1.4% | not timed | not timed | 14.54 ± 1.3% | | 1.01 | 1.32 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 85.28 ± 0.3% | not timed | not timed | 8.01 ± 0.3% | 23.91 ± 0.6% | not timed | not timed | 85.22 ± 0.5% | | 1.00 | 10.65 | 3.57 |
| 11-unstructured-to-json/compile | 1 | 90.62 ± 0.2% | not timed | not timed | 40.57 ± 0.4% | 67.66 ± 2.4% | not timed | not timed | 89.85 ± 1.1% | | 1.01 | 2.23 | 1.34 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.1% | not timed | not timed | 0.07 ± 1.1% | 0.09 ± 6.9% | not timed | not timed | 0.36 ± 0.5% | | 1.01 | 5.25 | 3.84 |

