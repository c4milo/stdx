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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159329785 |
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
| literal: a word | 217 | 31659.51 ± 1.0% | 1090.32 ± 0.2% | 36.46 ± 1.4% | 32013.80 ± 0.3% | 12509.07 ± 3.1% | 14.83 ± 0.2% | 115.92 ± 0.8% | 31676.95 ± 0.3% | 29.04 | 1.00 | 0.99 | 2.53 |
| literal: a word that is not there | 0 | 41689.64 ± 0.2% | 1101.63 ± 0.1% | 36.72 ± 1.7% | 35390.36 ± 0.2% | 39389.89 ± 0.1% | 14.41 ± 0.0% | 108.48 ± 0.8% | 41724.11 ± 0.1% | 37.84 | 1.00 | 1.18 | 1.06 |
| literal: one of four words | 661 | 13292.86 ± 1.4% | 1069.29 ± 0.1% | 19.24 ± 1.7% | 9746.54 ± 0.2% | 29.18 ± 0.7% | 4.37 ± 0.1% | 9.26 ± 0.3% | 13216.40 ± 0.7% | 12.43 | 1.01 | 1.36 | 455.49 |
| literal: a word in any case | 217 | 27021.78 ± 0.6% | 1089.09 ± 0.1% | 25.83 ± 0.9% | 10075.35 ± 0.3% | 58.78 ± 0.7% | refused | differs | 26980.98 ± 0.3% | 24.81 | 1.00 | 2.68 | 459.72 |
| literal: an href attribute | 33 | 27672.47 ± 0.3% | 1098.15 ± 0.2% | 32.17 ± 1.9% | 28620.92 ± 0.4% | 2612.95 ± 0.5% | 10.66 ± 0.4% | 99.35 ± 0.6% | 27621.86 ± 0.3% | 25.20 | 1.00 | 0.97 | 10.59 |
| literal: a word, second text | 123 | 32985.98 ± 0.8% | 1092.22 ± 0.1% | 35.50 ± 1.4% | 31933.74 ± 0.6% | 9119.07 ± 8.3% | 19.38 ± 0.3% | 97.21 ± 0.3% | 32987.79 ± 0.7% | 30.20 | 1.00 | 1.03 | 3.62 |
| class: two capitalized words | 1331 | 1022.87 ± 0.3% | 1011.80 ± 0.2% | 33.17 ± 1.6% | 613.31 ± 0.4% | 49.16 ± 0.7% | 12.58 ± 0.1% | 82.41 ± 0.4% | 1021.86 ± 0.1% | 1.01 | 1.00 | 1.67 | 20.81 |
| class: a word that ends in ing | 3399 | 924.61 ± 0.2% | 923.33 ± 0.1% | 21.44 ± 0.8% | 576.24 ± 0.3% | 35.46 ± 10.2% | 7.19 ± 0.5% | 22.97 ± 0.7% | 923.19 ± 0.3% | 1.00 | 1.00 | 1.60 | 26.07 |
| class: a word in capitals | 2332 | 1391.07 ± 1.1% | 991.63 ± 0.4% | 34.74 ± 3.0% | 604.51 ± 0.1% | 53.00 ± 13.3% | 15.27 ± 0.2% | 101.79 ± 1.8% | 1388.00 ± 0.1% | 1.40 | 1.00 | 2.30 | 26.25 |
| class: a number | 8288 | 2000.26 ± 0.2% | 861.39 ± 0.1% | 34.48 ± 1.7% | 2113.13 ± 0.4% | 52.78 ± 13.1% | 0.42 ± 0.2% | 71.15 ± 0.3% | 1996.17 ± 0.2% | 2.32 | 1.00 | 0.95 | 37.90 |
| class: two capitalized words, second text | 5359 | 755.98 ± 0.1% | 755.29 ± 0.1% | 29.63 ± 1.2% | 506.81 ± 0.6% | 42.36 ± 11.5% | 16.51 ± 0.3% | 75.18 ± 1.4% | 753.06 ± 0.4% | 1.00 | 1.00 | 1.49 | 17.85 |
| other: a word between two words | 6104 | 840.13 ± 0.4% | 799.06 ± 0.1% | 29.13 ± 0.8% | 878.06 ± 1.5% | 135.31 ± 13.7% | 9.69 ± 0.2% | 85.67 ± 0.2% | 841.20 ± 1.8% | 1.05 | 1.00 | 0.96 | 6.21 |
| other: a number before a unit, second text | 1481 | 9265.98 ± 2.1% | 1024.43 ± 0.3% | 33.30 ± 2.8% | 9347.67 ± 1.0% | 49.10 ± 18.0% | 17.25 ± 0.1% | 80.21 ± 0.5% | 9135.01 ± 0.5% | 9.04 | 1.01 | 0.99 | 188.71 |
| other: a heading's start tag | 110 | 20199.49 ± 2.4% | 1089.16 ± 0.1% | 34.88 ± 1.3% | 2712.35 ± 0.3% | 1923.29 ± 1.7% | 13.27 ± 0.3% | 117.31 ± 2.2% | 20164.42 ± 0.6% | 18.55 | 1.00 | 7.45 | 10.50 |
| other: a whole word | 217 | 24752.56 ± 0.4% | 1090.18 ± 0.1% | 36.92 ± 2.9% | 25559.87 ± 0.5% | 60.45 ± 0.6% | 12.64 ± 0.2% | 67.88 ± 0.7% | 24798.37 ± 0.2% | 22.71 | 1.00 | 0.97 | 409.46 |
| other: a line's first word, second text | 3716 | 2540.48 ± 0.7% | 914.09 ± 0.1% | 37.70 ± 0.3% | 2470.53 ± 1.0% | 82.42 ± 3.4% | refused | refused | 2527.06 ± 0.3% | 2.78 | 1.01 | 1.03 | 30.82 |
| other: fourteen octets before an x | 87 | 34844.97 ± 0.5% | 296.33 ± 0.3% | 7.72 ± 1.1% | 4164.51 ± 0.3% | 11.66 ± 0.8% | differs | 20.24 ± 0.2% | 34821.91 ± 0.3% | 117.59 | 1.00 | 8.37 | 2989.18 |
| other: a Greek word | 21815 | 529.59 ± 0.4% | 405.91 ± 0.5% | 37.15 ± 2.5% | 312.78 ± 0.4% | 63.81 ± 10.9% | differs | refused | 527.76 ± 0.3% | 1.30 | 1.00 | 1.69 | 8.30 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.62 ± 0.7% | 29.58 ± 0.3% | 1.07 ± 2.3% | 21.46 ± 0.1% | 3.23 ± 0.6% | differs | 4.96 ± 1.1% | 29.49 ± 0.9% | 1.00 | 1.00 | 1.38 | 9.18 |
| a UUID | 32895 | 26.53 ± 0.3% | 26.53 ± 0.2% | 0.75 ± 0.5% | 16.48 ± 0.2% | 3.27 ± 0.7% | 0.71 ± 0.1% | 4.11 ± 1.5% | 26.52 ± 0.3% | 1.00 | 1.00 | 1.61 | 8.12 |
| an IPv4 address | 33176 | 39.24 ± 0.5% | 39.14 ± 2.3% | 2.40 ± 0.4% | 31.46 ± 0.2% | 8.09 ± 3.4% | differs | 4.66 ± 0.5% | 39.14 ± 0.5% | 1.00 | 1.00 | 1.25 | 4.85 |
| a date and time | 32954 | 39.41 ± 3.6% | 39.39 ± 0.6% | 1.72 ± 0.7% | 23.91 ± 0.1% | 10.26 ± 0.8% | 1.30 ± 2.6% | 9.13 ± 1.3% | 39.32 ± 4.0% | 1.00 | 1.00 | 1.65 | 3.84 |
| a field path | 32606 | 31.58 ± 0.5% | 31.64 ± 3.0% | 1.23 ± 0.8% | 24.78 ± 1.1% | 3.72 ± 0.4% | differs | 3.10 ± 0.5% | 31.55 ± 0.3% | 1.00 | 1.00 | 1.27 | 8.50 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.39 ± 0.3% | 12.35 ± 3.3% | 12.37 ± 0.4% | 14.66 ± 1.0% | 6.74 ± 5.4% | 1.03 ± 0.8% | none | 12.39 ± 0.7% | 1.00 | 1.00 | 0.85 | 1.84 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 300.40 ± 4.8% | 302.80 ± 0.3% | 353.37 ± 0.4% | 116.44 ± 1.6% | 260.48 ± 2.2% | 696.10 ± 2.7% | 4335.18 ± 1.0% | 300.96 ± 4.6% | 0.99 | 1.00 | 2.58 | 1.15 |
| a UUID | 62 | 194.22 ± 3.0% | 195.39 ± 0.2% | 217.38 ± 0.2% | 61.07 ± 3.5% | 117.50 ± 2.2% | 256.86 ± 2.8% | 5735.62 ± 0.4% | 194.13 ± 0.2% | 0.99 | 1.00 | 3.18 | 1.65 |
| an IPv4 address | 29 | 593.11 ± 0.2% | 600.82 ± 0.7% | 842.62 ± 0.3% | 99.54 ± 0.3% | 155.42 ± 4.5% | 432.48 ± 0.4% | 10329.30 ± 1.0% | 593.90 ± 0.5% | 0.99 | 1.00 | 5.96 | 3.82 |
| a date and time | 56 | 459.22 ± 0.5% | 462.78 ± 0.3% | 585.34 ± 0.1% | 96.15 ± 0.8% | 165.31 ± 4.6% | 455.89 ± 0.6% | 5806.86 ± 3.1% | 459.13 ± 0.5% | 0.99 | 1.00 | 4.78 | 2.78 |
| a field path | 39 | 291.52 ± 0.3% | 293.14 ± 0.7% | 339.81 ± 2.8% | 104.69 ± 0.8% | 246.67 ± 9.3% | 706.16 ± 1.6% | 5571.78 ± 0.5% | 290.97 ± 4.5% | 0.99 | 1.00 | 2.78 | 1.18 |
| literal: a word | 7 | 931.21 ± 0.5% | 1021.47 ± 0.7% | 1833.64 ± 0.5% | 721.04 ± 1.1% | 811.14 ± 2.1% | 1442.63 ± 0.4% | 38658.61 ± 0.6% | 929.83 ± 0.3% | 0.91 | 1.00 | 1.29 | 1.15 |
| literal: a word that is not there | 8 | 892.24 ± 1.3% | 983.68 ± 0.8% | 1730.01 ± 4.1% | 643.42 ± 0.2% | 775.72 ± 3.0% | 1356.06 ± 0.6% | 37642.67 ± 0.3% | 891.88 ± 0.2% | 0.91 | 1.00 | 1.39 | 1.15 |
| literal: one of four words | 26 | 347.14 ± 0.6% | 606.71 ± 2.3% | 835.75 ± 2.3% | 50.79 ± 0.8% | 301.01 ± 1.9% | 510.10 ± 2.3% | 21918.95 ± 1.9% | 347.43 ± 0.3% | 0.57 | 1.00 | 6.83 | 1.15 |
| literal: a word in any case | 11 | 699.07 ± 0.3% | 760.77 ± 0.4% | 1146.05 ± 0.4% | 17.85 ± 0.3% | 846.88 ± 7.6% | refused | 31195.32 ± 0.8% | 700.00 ± 0.2% | 0.92 | 1.00 | 39.17 | 0.83 |
| literal: an href attribute | 12 | 474.83 ± 0.3% | 491.61 ± 0.7% | 642.34 ± 1.2% | 49.95 ± 0.2% | 613.94 ± 0.9% | 1159.94 ± 0.6% | 27344.71 ± 0.4% | 475.47 ± 0.9% | 0.97 | 1.00 | 9.51 | 0.77 |
| literal: a word, second text | 10 | 827.33 ± 0.3% | 932.39 ± 0.1% | 1568.04 ± 0.8% | 597.54 ± 0.7% | 673.51 ± 17.3% | 1182.17 ± 0.7% | 35548.76 ± 1.0% | 827.58 ± 0.3% | 0.89 | 1.00 | 1.38 | 1.23 |
| class: two capitalized words | 23 | 666.54 ± 0.3% | 727.41 ± 0.4% | 1072.92 ± 0.3% | 135.71 ± 0.5% | 636.92 ± 3.0% | 1113.85 ± 0.5% | 7792.26 ± 0.7% | 666.55 ± 0.2% | 0.92 | 1.00 | 4.91 | 1.05 |
| class: a word that ends in ing | 9 | 815.06 ± 0.2% | 931.00 ± 0.6% | 1658.29 ± 0.4% | 172.71 ± 0.5% | 937.62 ± 1.3% | 1737.32 ± 0.5% | 20352.70 ± 1.1% | 815.12 ± 0.2% | 0.88 | 1.00 | 4.72 | 0.87 |
| class: a word in capitals | 16 | 734.60 ± 0.4% | 807.16 ± 1.0% | 1341.30 ± 0.3% | 180.94 ± 4.3% | 943.08 ± 2.3% | 1611.24 ± 0.6% | 10312.70 ± 0.6% | 733.26 ± 0.6% | 0.91 | 1.00 | 4.06 | 0.78 |
| class: a number | 6 | 892.31 ± 0.1% | 1003.10 ± 0.4% | 1921.44 ± 0.1% | 44.38 ± 1.8% | 1724.87 ± 1.8% | 3048.15 ± 1.4% | 30334.13 ± 0.8% | 891.58 ± 0.2% | 0.89 | 1.00 | 20.11 | 0.52 |
| class: two capitalized words, second text | 23 | 667.33 ± 0.2% | 727.35 ± 0.4% | 1073.05 ± 0.2% | 135.14 ± 0.2% | 625.59 ± 1.3% | 1132.46 ± 1.1% | 7785.93 ± 1.0% | 666.36 ± 0.2% | 0.92 | 1.00 | 4.94 | 1.07 |
| other: a word between two words | 13 | 802.45 ± 0.2% | 842.57 ± 0.2% | 1355.99 ± 0.4% | 181.29 ± 1.1% | 626.08 ± 1.0% | 1228.14 ± 1.6% | 18777.26 ± 0.9% | 801.81 ± 0.2% | 0.95 | 1.00 | 4.43 | 1.28 |
| other: a number before a unit, second text | 15 | 555.73 ± 0.3% | 618.42 ± 0.3% | 857.94 ± 0.3% | 41.70 ± 0.5% | 787.05 ± 7.0% | 1369.15 ± 1.6% | 19937.17 ± 1.9% | 555.17 ± 0.4% | 0.90 | 1.00 | 13.33 | 0.71 |
| other: a heading's start tag | 13 | 488.90 ± 0.5% | 500.08 ± 0.8% | 653.53 ± 1.1% | 47.83 ± 0.1% | 769.58 ± 1.0% | 1330.97 ± 0.7% | 23570.62 ± 0.7% | 489.55 ± 0.1% | 0.98 | 1.00 | 10.22 | 0.64 |
| other: a whole word | 11 | 845.08 ± 0.5% | 909.93 ± 0.3% | 1497.77 ± 1.1% | 161.33 ± 3.8% | 718.92 ± 1.7% | 1257.01 ± 0.8% | 34084.58 ± 3.4% | 844.08 ± 0.4% | 0.93 | 1.00 | 5.24 | 1.18 |
| other: a line's first word, second text | 17 | 765.19 ± 0.6% | 805.16 ± 0.9% | 1299.71 ± 0.6% | 173.71 ± 2.4% | 875.24 ± 0.5% | refused | refused | 763.04 ± 0.3% | 0.95 | 1.00 | 4.40 | 0.87 |
| other: fourteen octets before an x | 16 | 136.18 ± 0.2% | 196.76 ± 0.2% | 228.25 ± 0.7% | 18.66 ± 0.2% | 549.48 ± 1.8% | 594.78 ± 4.5% | 16734.94 ± 0.4% | 136.14 ± 0.2% | 0.69 | 1.00 | 7.30 | 0.25 |
| other: a Greek word | 8 | 585.92 ± 0.5% | 814.55 ± 0.3% | 1347.37 ± 0.1% | 61.54 ± 0.1% | 1717.96 ± 1.2% | 2907.57 ± 0.5% | refused | 586.03 ± 0.2% | 0.72 | 1.00 | 9.52 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 23836.66 ± 0.4% | not timed | not timed | 28218.58 ± 0.7% | 2914.38 ± 16.5% | not timed | not timed | 23797.03 ± 0.1% | | 1.00 | 0.84 | 8.18 |
| 01-literal/sherlock-casei-en | 522 | 7568.83 ± 0.7% | not timed | not timed | 8482.74 ± 0.1% | 40.31 ± 0.6% | not timed | not timed | 7525.07 ± 0.8% | | 1.01 | 0.89 | 187.79 |
| 01-literal/sherlock-ru | 724 | 24312.06 ± 3.5% | not timed | not timed | 27251.99 ± 0.5% | 1631.76 ± 4.5% | not timed | not timed | 24318.50 ± 0.1% | | 1.00 | 0.89 | 14.90 |
| 01-literal/sherlock-casei-ru | 746 | 8154.60 ± 0.8% | not timed | not timed | 6385.85 ± 1.3% | 42.88 ± 0.3% | not timed | not timed | 8286.22 ± 0.4% | | 0.98 | 1.28 | 190.16 |
| 01-literal/sherlock-zh | 30 | 37640.01 ± 0.2% | not timed | not timed | 34426.26 ± 0.2% | 1600.71 ± 1.2% | not timed | not timed | 37579.00 ± 2.3% | | 1.00 | 1.09 | 23.51 |
| 02-literal-alternate/sherlock-en | 714 | 12125.26 ± 0.2% | not timed | not timed | 9448.91 ± 3.1% | 22.44 ± 3.3% | not timed | not timed | 12087.93 ± 0.4% | | 1.00 | 1.28 | 540.27 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2061.13 ± 1.0% | not timed | not timed | 2315.56 ± 0.2% | 13.71 ± 0.3% | not timed | not timed | 2047.27 ± 0.3% | | 1.01 | 0.89 | 150.31 |
| 02-literal-alternate/sherlock-ru | 899 | 6780.30 ± 0.3% | not timed | not timed | 5133.17 ± 0.4% | 29.06 ± 0.5% | not timed | not timed | 6846.34 ± 0.1% | | 0.99 | 1.32 | 233.35 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2162.85 ± 0.3% | not timed | not timed | 1251.47 ± 1.8% | 11.81 ± 0.9% | not timed | not timed | 2156.24 ± 0.2% | | 1.00 | 1.73 | 183.15 |
| 02-literal-alternate/sherlock-zh | 207 | 16358.99 ± 0.3% | not timed | not timed | 10792.01 ± 0.4% | 41.62 ± 20.4% | not timed | not timed | 16334.76 ± 0.4% | | 1.00 | 1.52 | 393.09 |
| 03-date/ascii | 111817 | 129.20 ± 0.6% | not timed | not timed | 109.95 ± 2.6% | 0.27 ± 5.3% | not timed | not timed | 128.27 ± 0.5% | | 1.01 | 1.18 | 477.43 |
| 04-ruff-noqa/real | 84 | 743.34 ± 0.5% | not timed | not timed | 565.20 ± 0.1% | 26.10 ± 1.5% | not timed | not timed | 737.17 ± 1.9% | | 1.01 | 1.32 | 28.48 |
| 04-ruff-noqa/tweaked | 44 | 627.29 ± 0.3% | not timed | not timed | 563.94 ± 0.2% | 454.07 ± 14.1% | not timed | not timed | 624.70 ± 0.3% | | 1.00 | 1.11 | 1.38 |
| 05-lexer-veryl/single | 124800 | 4.40 ± 0.4% | not timed | not timed | 5.69 ± 0.7% | 0.27 ± 8.5% | not timed | not timed | 4.42 ± 2.0% | | 1.00 | 0.77 | 16.15 |
| 06-cloud-flare-redos/original | 107 | 282.91 ± 0.4% | not timed | not timed | 262.61 ± 0.6% | 32.17 ± 0.6% | not timed | not timed | 283.55 ± 0.3% | | 1.00 | 1.08 | 8.79 |
| 06-cloud-flare-redos/simplified-short | 102 | 252.87 ± 1.3% | not timed | not timed | 267.79 ± 1.8% | 32.17 ± 1.0% | not timed | not timed | 253.03 ± 0.2% | | 1.00 | 0.94 | 7.86 |
| 06-cloud-flare-redos/simplified-long | 10000 | 271.91 ± 0.2% | not timed | not timed | 280.77 ± 0.5% | 38.12 ± 0.9% | not timed | not timed | 271.72 ± 0.3% | | 1.00 | 0.97 | 7.13 |
| 07-unicode-character-data/parse-line | 558784 | 269.87 ± 1.4% | not timed | not timed | 206.97 ± 0.6% | 53.14 ± 10.3% | not timed | not timed | 268.50 ± 2.3% | | 1.01 | 1.30 | 5.08 |
| 08-words/all-english | 56691 | 115.70 ± 0.4% | not timed | not timed | 92.66 ± 0.5% | 15.47 ± 8.4% | not timed | not timed | 115.44 ± 1.0% | | 1.00 | 1.25 | 7.48 |
| 08-words/long-english | 839 | 1052.67 ± 0.8% | not timed | not timed | 625.13 ± 0.2% | 37.59 ± 0.4% | not timed | not timed | 1052.19 ± 0.8% | | 1.00 | 1.68 | 28.00 |
| 09-aws-keys/full | 0 | 572.10 ± 0.4% | not timed | not timed | 573.04 ± 0.2% | 83.44 ± 4.8% | not timed | not timed | 572.61 ± 1.6% | | 1.00 | 1.00 | 6.86 |
| 09-aws-keys/quick | 0 | 1121.68 ± 0.7% | not timed | not timed | 911.25 ± 2.4% | 526.15 ± 14.3% | not timed | not timed | 1118.88 ± 0.3% | | 1.00 | 1.23 | 2.13 |
| 10-bounded-repeat/letters-en | 1833 | 627.78 ± 0.5% | not timed | not timed | 551.47 ± 0.5% | 24.27 ± 3.7% | not timed | not timed | 627.26 ± 0.4% | | 1.00 | 1.14 | 25.87 |
| 10-bounded-repeat/letters-ru | 3475 | 391.47 ± 0.8% | not timed | not timed | 494.91 ± 1.8% | 25.57 ± 7.5% | not timed | not timed | 391.02 ± 0.2% | | 1.00 | 0.79 | 15.31 |
| 10-bounded-repeat/context | 53 | 90.43 ± 1.0% | not timed | not timed | 74.37 ± 3.3% | 24.33 ± 0.4% | not timed | not timed | 91.03 ± 3.9% | | 0.99 | 1.22 | 3.72 |
| 10-bounded-repeat/capitals | 11 | 1090.49 ± 0.2% | not timed | not timed | 642.06 ± 0.1% | 44.56 ± 1.6% | not timed | not timed | 1088.22 ± 0.3% | | 1.00 | 1.70 | 24.47 |
| 11-unstructured-to-json/extract | 600 | 49.41 ± 0.2% | not timed | not timed | 81.23 ± 2.2% | 64.87 ± 0.7% | not timed | not timed | 49.21 ± 0.5% | | 1.00 | 0.61 | 0.76 |
| 12-dictionary/single | 1 | 572.01 ± 0.4% | not timed | not timed | 548.11 ± 0.1% | 0.52 ± 3.8% | not timed | not timed | 574.25 ± 1.9% | | 1.00 | 1.04 | 1093.49 |
| 14-quadratic/1x | 100 | 14.10 ± 0.2% | not timed | not timed | 13.52 ± 4.0% | 1.26 ± 2.3% | not timed | not timed | 14.09 ± 0.1% | | 1.00 | 1.04 | 11.19 |
| 14-quadratic/2x | 200 | 8.53 ± 0.4% | not timed | not timed | 6.63 ± 0.2% | 0.70 ± 0.5% | not timed | not timed | 8.50 ± 1.2% | | 1.00 | 1.29 | 12.24 |
| 14-quadratic/10x | 1000 | 1.94 ± 0.5% | not timed | not timed | 1.30 ± 0.3% | 0.15 ± 0.9% | not timed | not timed | 1.94 ± 1.4% | | 1.00 | 1.50 | 12.68 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.04 ± 4.7% | not timed | not timed | 0.45 ± 0.9% | 0.66 ± 0.5% | not timed | not timed | 2.03 ± 1.4% | | 1.00 | 4.56 | 3.07 |
| 04-ruff-noqa/compile-real | 1 | 128.22 ± 0.5% | not timed | not timed | 15.68 ± 0.4% | 175.21 ± 1.7% | not timed | not timed | 127.77 ± 0.3% | | 1.00 | 8.18 | 0.73 |
| 05-lexer-veryl/compile-single | 1 | 21.70 ± 0.6% | not timed | not timed | 3.07 ± 0.5% | 7.77 ± 1.5% | not timed | not timed | 21.67 ± 0.3% | | 1.00 | 7.07 | 2.79 |
| 07-unicode-character-data/compile | 1 | 78.23 ± 0.6% | not timed | not timed | 32.15 ± 0.4% | 43.72 ± 1.6% | not timed | not timed | 78.05 ± 0.9% | | 1.00 | 2.43 | 1.79 |
| 09-aws-keys/compile-full | 1 | 53.42 ± 0.5% | not timed | not timed | 9.02 ± 0.3% | 28.09 ± 0.6% | not timed | not timed | 53.14 ± 0.7% | | 1.01 | 5.92 | 1.90 |
| 09-aws-keys/compile-quick | 1 | 237.03 ± 0.4% | not timed | not timed | 58.91 ± 0.3% | 165.06 ± 2.6% | not timed | not timed | 235.51 ± 0.6% | | 1.01 | 4.02 | 1.44 |
| 10-bounded-repeat/compile-context | 1 | 16.28 ± 0.4% | not timed | not timed | 14.52 ± 0.2% | 20.77 ± 3.4% | not timed | not timed | 16.20 ± 1.6% | | 1.01 | 1.12 | 0.78 |
| 10-bounded-repeat/compile-capitals | 1 | 101.25 ± 4.8% | not timed | not timed | 10.98 ± 0.1% | 29.48 ± 1.1% | not timed | not timed | 100.11 ± 0.2% | | 1.01 | 9.22 | 3.43 |
| 11-unstructured-to-json/compile | 1 | 118.94 ± 1.0% | not timed | not timed | 50.34 ± 1.1% | 81.71 ± 6.7% | not timed | not timed | 118.03 ± 0.5% | | 1.01 | 2.36 | 1.46 |
| 12-dictionary/compile-single | 1 | 0.37 ± 0.3% | not timed | not timed | 0.08 ± 1.1% | 0.12 ± 29.4% | not timed | not timed | 0.37 ± 2.7% | | 1.01 | 4.67 | 3.17 |

