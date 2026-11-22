# bench-regex

| Field | Value |
|---|---|
| Commit | f2b7425 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45065556363 |
| Date | 2026-11-22 |
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
| literal: a word | 217 | 35102.75 ± 3.8% | 894.66 ± 0.1% | 20.45 ± 1.6% | 32942.74 ± 1.4% | 8758.51 ± 8.7% | 9.64 ± 0.1% | 76.87 ± 0.9% | 34319.09 ± 2.5% | 39.24 | 1.02 | 1.07 | 4.01 |
| literal: a word that is not there | 0 | 51288.52 ± 4.2% | 904.61 ± 1.2% | 20.48 ± 8.2% | 37906.51 ± 17.1% | 30088.96 ± 0.7% | 10.76 ± 0.1% | 72.25 ± 3.1% | 50582.01 ± 4.4% | 56.70 | 1.01 | 1.35 | 1.70 |
| literal: one of four words | 661 | 9986.17 ± 3.7% | 871.29 ± 1.6% | 11.22 ± 1.4% | 9544.17 ± 2.0% | 17.81 ± 2.0% | 3.59 ± 0.9% | 6.51 ± 2.2% | 9962.44 ± 0.3% | 11.46 | 1.00 | 1.05 | 560.57 |
| literal: a word in any case | 217 | 26167.32 ± 1.8% | 894.63 ± 0.1% | 15.91 ± 1.0% | 8759.07 ± 3.5% | 36.71 ± 4.2% | refused | differs | 25744.53 ± 1.7% | 29.25 | 1.02 | 2.99 | 712.82 |
| literal: an href attribute | 33 | 35689.24 ± 4.4% | 902.54 ± 0.8% | 18.96 ± 0.7% | 24867.97 ± 0.9% | 2046.72 ± 4.0% | 8.26 ± 0.2% | 68.08 ± 2.1% | 33838.42 ± 2.6% | 39.54 | 1.05 | 1.44 | 17.44 |
| literal: a word, second text | 123 | 35508.08 ± 2.0% | 899.18 ± 1.0% | 20.17 ± 0.4% | 28474.94 ± 0.6% | 7164.66 ± 9.7% | 11.87 ± 0.3% | 65.89 ± 3.0% | 35031.58 ± 1.7% | 39.49 | 1.01 | 1.25 | 4.96 |
| class: two capitalized words | 1331 | 773.39 ± 0.9% | 816.37 ± 0.2% | 19.23 ± 0.3% | 506.80 ± 0.1% | 33.51 ± 5.7% | 9.41 ± 0.5% | 58.85 ± 2.5% | 775.49 ± 0.2% | 0.95 | 1.00 | 1.53 | 23.08 |
| class: a word that ends in ing | 3399 | 741.43 ± 0.2% | 741.85 ± 0.8% | 14.11 ± 0.2% | 473.99 ± 0.6% | 24.23 ± 5.5% | 5.35 ± 0.6% | 17.15 ± 6.4% | 741.57 ± 0.2% | 1.00 | 1.00 | 1.56 | 30.60 |
| class: a word in capitals | 2332 | 978.88 ± 1.6% | 799.04 ± 0.1% | 20.17 ± 0.5% | 497.32 ± 0.5% | 34.60 ± 12.4% | 10.52 ± 0.7% | 77.36 ± 0.2% | 979.45 ± 0.3% | 1.23 | 1.00 | 1.97 | 28.29 |
| class: a number | 8288 | 1508.58 ± 0.5% | 662.40 ± 0.2% | 19.94 ± 0.5% | 1523.18 ± 0.2% | 34.53 ± 10.0% | 0.34 ± 0.2% | 56.49 ± 0.9% | 1521.31 ± 0.1% | 2.28 | 0.99 | 0.99 | 43.68 |
| class: two capitalized words, second text | 5359 | 584.78 ± 0.3% | 586.09 ± 0.2% | 17.66 ± 0.1% | 419.33 ± 0.2% | 27.76 ± 6.2% | 10.64 ± 0.6% | 54.76 ± 2.2% | 584.71 ± 0.3% | 1.00 | 1.00 | 1.39 | 21.06 |
| other: a word between two words | 6104 | 691.55 ± 2.4% | 630.80 ± 1.7% | 17.55 ± 2.0% | 722.06 ± 2.3% | 91.50 ± 12.5% | 7.27 ± 1.4% | 59.41 ± 2.8% | 691.31 ± 1.4% | 1.10 | 1.00 | 0.96 | 7.56 |
| other: a number before a unit, second text | 1481 | 7573.68 ± 4.8% | 830.80 ± 2.1% | 19.21 ± 0.3% | 6916.64 ± 1.0% | 34.26 ± 0.3% | 11.07 ± 0.2% | 58.87 ± 7.2% | 7519.14 ± 4.8% | 9.12 | 1.01 | 1.09 | 221.08 |
| other: a heading's start tag | 110 | 19715.04 ± 3.8% | 894.00 ± 0.2% | 19.79 ± 0.6% | 2046.11 ± 7.5% | 1466.00 ± 1.5% | 10.07 ± 0.4% | 78.34 ± 0.6% | 19199.84 ± 2.7% | 22.05 | 1.03 | 9.64 | 13.45 |
| other: a whole word | 217 | 23963.33 ± 2.3% | 893.17 ± 0.7% | 20.82 ± 6.2% | 23222.13 ± 4.2% | 39.88 ± 0.2% | 9.56 ± 0.1% | 46.20 ± 4.6% | 23279.52 ± 3.6% | 26.83 | 1.03 | 1.03 | 600.88 |
| other: a line's first word, second text | 3716 | 1898.76 ± 4.4% | 728.22 ± 0.1% | 24.51 ± 2.0% | 1766.66 ± 4.3% | 53.85 ± 5.4% | refused | refused | 1941.54 ± 2.0% | 2.61 | 0.98 | 1.07 | 35.26 |
| other: fourteen octets before an x | 87 | 27779.92 ± 2.2% | 1.34 ± 0.5% | 1.31 ± 0.6% | 2656.06 ± 3.9% | 8.87 ± 0.2% | differs | 17.07 ± 1.6% | 27379.48 ± 1.0% | 20792.26 | 1.01 | 10.46 | 3132.21 |
| other: a Greek word | 21815 | 394.82 ± 1.5% | 272.95 ± 0.2% | 24.67 ± 0.2% | 268.71 ± 2.0% | 42.55 ± 5.0% | differs | refused | 393.93 ± 1.2% | 1.45 | 1.00 | 1.47 | 9.28 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.61 ± 6.7% | 26.26 ± 2.0% | 0.39 ± 2.4% | 20.12 ± 2.6% | 2.30 ± 0.3% | differs | 3.45 ± 0.4% | 26.66 ± 0.7% | 1.01 | 1.00 | 1.32 | 11.55 |
| a UUID | 32895 | 22.02 ± 0.2% | 22.03 ± 3.5% | 0.56 ± 0.3% | 14.66 ± 0.5% | 2.44 ± 4.1% | 0.43 ± 0.1% | 3.17 ± 6.7% | 22.02 ± 0.2% | 1.00 | 1.00 | 1.50 | 9.02 |
| an IPv4 address | 33176 | 38.25 ± 3.2% | 37.41 ± 3.1% | 1.73 ± 0.5% | 30.08 ± 0.2% | 5.63 ± 0.9% | differs | 3.32 ± 0.8% | 38.40 ± 1.5% | 1.02 | 1.00 | 1.27 | 6.80 |
| a date and time | 32954 | 33.53 ± 1.0% | 33.49 ± 0.4% | 1.31 ± 1.2% | 22.15 ± 0.3% | 6.49 ± 0.1% | 0.75 ± 0.2% | 6.03 ± 1.0% | 33.52 ± 0.1% | 1.00 | 1.00 | 1.51 | 5.17 |
| a field path | 32606 | 29.80 ± 0.1% | 29.95 ± 1.2% | 0.63 ± 1.1% | 23.39 ± 0.5% | 2.90 ± 1.0% | differs | 2.31 ± 0.6% | 29.41 ± 0.4% | 0.99 | 1.01 | 1.27 | 10.27 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.09 ± 11.1% | 9.11 ± 0.4% | 9.00 ± 0.8% | 10.68 ± 0.2% | 4.50 ± 0.8% | 0.62 ± 0.5% | none | 9.14 ± 0.5% | 1.00 | 0.99 | 0.85 | 2.02 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 237.72 ± 0.6% | 239.38 ± 0.5% | 277.98 ± 0.4% | 79.30 ± 3.4% | 182.86 ± 1.8% | 552.49 ± 3.0% | 3503.65 ± 1.0% | 238.40 ± 0.9% | 0.99 | 1.00 | 3.00 | 1.30 |
| a UUID | 62 | 158.21 ± 0.6% | 158.47 ± 0.9% | 180.44 ± 1.9% | 46.59 ± 1.9% | 88.99 ± 2.6% | 202.64 ± 2.1% | 3888.31 ± 1.0% | 158.42 ± 1.1% | 1.00 | 1.00 | 3.40 | 1.78 |
| an IPv4 address | 29 | 428.05 ± 3.4% | 428.94 ± 2.2% | 578.70 ± 2.3% | 68.99 ± 3.2% | 109.76 ± 3.1% | 327.87 ± 4.1% | 6527.43 ± 4.8% | 423.55 ± 3.1% | 1.00 | 1.01 | 6.20 | 3.90 |
| a date and time | 56 | 305.38 ± 8.5% | 307.54 ± 2.7% | 376.23 ± 2.8% | 68.82 ± 4.1% | 120.16 ± 5.5% | 383.59 ± 2.1% | 3859.16 ± 0.6% | 305.56 ± 0.3% | 0.99 | 1.00 | 4.44 | 2.54 |
| a field path | 39 | 252.16 ± 6.1% | 252.97 ± 0.3% | 297.23 ± 0.6% | 75.26 ± 3.4% | 172.93 ± 6.2% | 631.76 ± 5.1% | 4421.22 ± 1.2% | 251.72 ± 8.3% | 1.00 | 1.00 | 3.35 | 1.46 |
| literal: a word | 7 | 709.35 ± 0.5% | 726.61 ± 0.8% | 1221.96 ± 0.5% | 493.84 ± 0.4% | 581.63 ± 0.9% | 1257.68 ± 0.7% | 24662.51 ± 0.9% | 707.83 ± 0.8% | 0.98 | 1.00 | 1.44 | 1.22 |
| literal: a word that is not there | 8 | 680.13 ± 0.5% | 698.71 ± 0.5% | 1139.10 ± 1.1% | 445.00 ± 0.4% | 549.47 ± 2.0% | 1181.69 ± 1.3% | 23475.09 ± 3.2% | 679.66 ± 0.6% | 0.97 | 1.00 | 1.53 | 1.24 |
| literal: one of four words | 26 | 365.62 ± 0.5% | 397.24 ± 1.3% | 517.25 ± 0.8% | 45.14 ± 0.8% | 216.70 ± 3.7% | 440.64 ± 2.0% | 9649.74 ± 1.2% | 364.88 ± 0.6% | 0.92 | 1.00 | 8.10 | 1.69 |
| literal: a word in any case | 11 | 529.65 ± 0.9% | 544.36 ± 1.2% | 789.63 ± 1.2% | 14.86 ± 1.2% | 599.47 ± 2.2% | refused | 18201.82 ± 1.8% | 527.87 ± 0.8% | 0.97 | 1.00 | 35.65 | 0.88 |
| literal: an href attribute | 12 | 396.29 ± 0.7% | 399.36 ± 0.8% | 526.02 ± 0.9% | 35.86 ± 4.9% | 423.53 ± 3.6% | 966.02 ± 9.2% | 16598.26 ± 3.6% | 396.49 ± 0.3% | 0.99 | 1.00 | 11.05 | 0.94 |
| literal: a word, second text | 10 | 630.98 ± 0.4% | 650.02 ± 0.9% | 1024.36 ± 0.5% | 423.85 ± 2.9% | 482.63 ± 2.9% | 1015.73 ± 7.2% | 19609.44 ± 1.0% | 631.05 ± 1.2% | 0.97 | 1.00 | 1.49 | 1.31 |
| class: two capitalized words | 23 | 482.47 ± 7.2% | 498.74 ± 0.5% | 692.21 ± 0.8% | 93.66 ± 4.4% | 446.79 ± 2.0% | 916.46 ± 6.9% | 6073.52 ± 1.5% | 482.86 ± 0.3% | 0.97 | 1.00 | 5.15 | 1.08 |
| class: a word that ends in ing | 9 | 638.71 ± 0.9% | 685.69 ± 1.6% | 1087.98 ± 0.5% | 113.72 ± 7.2% | 626.71 ± 10.7% | 1404.11 ± 5.8% | 14641.42 ± 0.5% | 640.48 ± 0.6% | 0.93 | 1.00 | 5.62 | 1.02 |
| class: a word in capitals | 16 | 543.09 ± 1.5% | 565.66 ± 0.5% | 822.35 ± 5.2% | 120.51 ± 5.4% | 651.67 ± 5.3% | 1303.42 ± 0.8% | 8136.21 ± 0.4% | 543.92 ± 0.4% | 0.96 | 1.00 | 4.51 | 0.83 |
| class: a number | 6 | 712.97 ± 1.3% | 749.81 ± 1.4% | 1277.16 ± 0.6% | 37.20 ± 1.8% | 1199.92 ± 2.3% | 2322.66 ± 4.1% | 19587.49 ± 0.1% | 713.53 ± 0.7% | 0.95 | 1.00 | 19.17 | 0.59 |
| class: two capitalized words, second text | 23 | 483.15 ± 0.2% | 498.90 ± 0.9% | 692.72 ± 0.4% | 95.00 ± 1.0% | 450.00 ± 4.6% | 938.03 ± 1.1% | 6078.29 ± 0.9% | 481.81 ± 1.0% | 0.97 | 1.00 | 5.09 | 1.07 |
| other: a word between two words | 13 | 583.27 ± 0.7% | 589.69 ± 0.3% | 875.89 ± 0.2% | 123.04 ± 1.0% | 437.29 ± 3.0% | 1018.31 ± 7.9% | 12483.61 ± 2.1% | 583.12 ± 1.2% | 0.99 | 1.00 | 4.74 | 1.33 |
| other: a number before a unit, second text | 15 | 475.10 ± 1.2% | 505.85 ± 0.3% | 709.18 ± 5.3% | 34.41 ± 0.8% | 531.92 ± 8.9% | 1126.52 ± 2.3% | 12680.07 ± 0.8% | 474.22 ± 0.5% | 0.94 | 1.00 | 13.81 | 0.89 |
| other: a heading's start tag | 13 | 400.30 ± 0.2% | 402.95 ± 1.8% | 541.66 ± 0.5% | 34.51 ± 3.6% | 511.79 ± 3.1% | 1075.54 ± 1.1% | 14950.44 ± 9.1% | 400.26 ± 0.3% | 0.99 | 1.00 | 11.60 | 0.78 |
| other: a whole word | 11 | 602.89 ± 0.7% | 618.75 ± 0.9% | 932.06 ± 0.9% | 113.58 ± 0.8% | 500.91 ± 2.0% | 1042.07 ± 7.9% | 18498.70 ± 13.7% | 601.16 ± 0.1% | 0.97 | 1.00 | 5.31 | 1.20 |
| other: a line's first word, second text | 17 | 580.76 ± 1.0% | 613.19 ± 0.9% | 917.61 ± 5.5% | 115.34 ± 1.8% | 590.51 ± 2.8% | refused | refused | 579.89 ± 1.2% | 0.95 | 1.00 | 5.04 | 0.98 |
| other: fourteen octets before an x | 16 | 94.34 ± 0.2% | 120.66 ± 6.5% | 141.47 ± 1.0% | 14.10 ± 2.3% | 393.74 ± 1.1% | 449.88 ± 1.1% | 11750.98 ± 2.6% | 94.25 ± 0.6% | 0.78 | 1.00 | 6.69 | 0.24 |
| other: a Greek word | 8 | 659.68 ± 1.2% | 702.45 ± 0.7% | 1159.49 ± 1.3% | 45.64 ± 1.3% | 1176.99 ± 3.4% | 2231.35 ± 0.7% | refused | 659.38 ± 1.6% | 0.94 | 1.00 | 14.45 | 0.56 |

