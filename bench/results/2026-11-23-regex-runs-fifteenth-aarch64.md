# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148122155 |
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
| literal: a word | 217 | 15884.61 ± 1.9% | 1039.46 ± 0.1% | 28.57 ± 0.3% | 17888.89 ± 2.4% | 9109.04 ± 12.5% | 17.46 ± 0.3% | 86.83 ± 0.4% | 15818.94 ± 1.6% | 15.28 | 1.00 | 0.89 | 1.74 |
| literal: a word that is not there | 0 | 18297.15 ± 3.1% | 1047.39 ± 0.5% | 28.65 ± 0.2% | 19257.02 ± 3.3% | 28392.31 ± 2.9% | 17.32 ± 0.3% | 82.69 ± 0.1% | 18446.52 ± 2.1% | 17.47 | 0.99 | 0.95 | 0.64 |
| literal: one of four words | 661 | 6030.97 ± 0.8% | 1023.16 ± 0.1% | 14.67 ± 0.1% | 3940.41 ± 0.3% | 21.89 ± 0.2% | 5.29 ± 0.1% | 6.91 ± 0.8% | 6010.64 ± 0.7% | 5.89 | 1.00 | 1.53 | 275.46 |
| literal: a word in any case | 217 | 12499.26 ± 1.0% | 1039.99 ± 0.1% | 21.52 ± 2.0% | 3960.15 ± 0.2% | 38.05 ± 0.9% | refused | differs | 12479.17 ± 0.6% | 12.02 | 1.00 | 3.16 | 328.52 |
| literal: an href attribute | 33 | 13584.14 ± 0.7% | 1045.79 ± 0.2% | 27.32 ± 0.3% | 16598.79 ± 2.2% | 2254.65 ± 0.7% | 13.30 ± 0.2% | 75.72 ± 0.5% | 13535.07 ± 1.0% | 12.99 | 1.00 | 0.82 | 6.02 |
| literal: a word, second text | 123 | 16281.53 ± 1.4% | 1042.93 ± 0.1% | 28.30 ± 0.4% | 18252.60 ± 1.6% | 7704.28 ± 6.2% | 19.60 ± 1.2% | 69.75 ± 0.6% | 16234.22 ± 1.2% | 15.61 | 1.00 | 0.89 | 2.11 |
| class: two capitalized words | 1331 | 1105.09 ± 0.5% | 978.20 ± 0.1% | 26.15 ± 0.1% | 585.24 ± 0.1% | 40.52 ± 9.0% | 14.89 ± 0.3% | 68.82 ± 0.2% | 1103.95 ± 0.4% | 1.13 | 1.00 | 1.89 | 27.27 |
| class: a word that ends in ing | 3399 | 895.38 ± 0.3% | 895.80 ± 0.1% | 18.06 ± 0.4% | 547.89 ± 0.3% | 29.63 ± 6.6% | 8.21 ± 0.1% | 18.41 ± 0.4% | 893.69 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.22 |
| class: a word in capitals | 2332 | 1455.82 ± 0.4% | 950.09 ± 0.0% | 27.82 ± 0.6% | 572.41 ± 0.1% | 43.43 ± 6.6% | 17.17 ± 0.1% | 83.26 ± 0.4% | 1453.73 ± 0.6% | 1.53 | 1.00 | 2.54 | 33.52 |
| class: a number | 8288 | 1991.01 ± 0.4% | 835.96 ± 0.3% | 28.04 ± 0.2% | 1718.56 ± 0.2% | 42.90 ± 6.7% | 0.55 ± 0.4% | 56.51 ± 0.2% | 1986.74 ± 0.3% | 2.38 | 1.00 | 1.16 | 46.41 |
| class: two capitalized words, second text | 5359 | 743.70 ± 0.3% | 744.41 ± 0.1% | 23.42 ± 0.3% | 483.74 ± 0.2% | 35.36 ± 8.2% | 16.72 ± 0.1% | 63.92 ± 0.2% | 742.86 ± 0.1% | 1.00 | 1.00 | 1.54 | 21.03 |
| other: a word between two words | 6104 | 746.38 ± 0.1% | 776.67 ± 0.1% | 23.56 ± 0.2% | 737.81 ± 0.4% | 109.64 ± 13.9% | 11.30 ± 0.2% | 69.87 ± 0.1% | 747.91 ± 0.0% | 0.96 | 1.00 | 1.01 | 6.81 |
| other: a number before a unit, second text | 1481 | 5402.84 ± 0.5% | 984.15 ± 0.6% | 26.09 ± 0.2% | 5587.55 ± 0.3% | 40.72 ± 0.2% | 17.82 ± 0.1% | 67.00 ± 1.0% | 5423.82 ± 0.6% | 5.49 | 1.00 | 0.97 | 132.70 |
| other: a heading's start tag | 110 | 12354.12 ± 1.5% | 1035.91 ± 0.0% | 27.55 ± 0.6% | 1710.73 ± 0.9% | 1581.53 ± 5.2% | 16.19 ± 7.6% | 89.03 ± 0.4% | 12407.83 ± 0.8% | 11.93 | 1.00 | 7.22 | 7.81 |
| other: a whole word | 217 | 13833.40 ± 0.9% | 1037.98 ± 0.1% | 29.63 ± 0.4% | 14268.76 ± 1.9% | 49.42 ± 0.2% | 13.61 ± 0.2% | 55.89 ± 0.3% | 13847.52 ± 0.8% | 13.33 | 1.00 | 0.97 | 279.91 |
| other: a line's first word, second text | 3716 | 1975.79 ± 0.4% | 876.55 ± 0.4% | 31.06 ± 0.4% | 1724.46 ± 0.6% | 62.28 ± 8.1% | refused | refused | 1961.99 ± 0.9% | 2.25 | 1.01 | 1.15 | 31.72 |
| other: fourteen octets before an x | 87 | 18751.90 ± 2.7% | 227.32 ± 1.1% | 6.59 ± 0.1% | 3968.92 ± 0.6% | 10.64 ± 0.2% | differs | 17.75 ± 0.1% | 19124.32 ± 0.9% | 82.49 | 0.98 | 4.72 | 1761.68 |
| other: a Greek word | 21815 | 514.66 ± 1.0% | 413.61 ± 0.2% | 31.20 ± 0.2% | 289.54 ± 0.2% | 47.10 ± 14.7% | differs | refused | 514.14 ± 0.5% | 1.24 | 1.00 | 1.78 | 10.93 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.84 ± 0.2% | 25.81 ± 0.1% | 0.87 ± 0.4% | 19.79 ± 0.1% | 2.76 ± 0.8% | differs | 3.99 ± 0.1% | 25.85 ± 0.3% | 1.00 | 1.00 | 1.31 | 9.36 |
| a UUID | 32895 | 21.02 ± 0.3% | 21.12 ± 0.2% | 0.65 ± 0.1% | 15.15 ± 0.2% | 3.12 ± 0.3% | 0.72 ± 0.5% | 3.59 ± 0.7% | 21.12 ± 0.2% | 0.99 | 1.00 | 1.39 | 6.74 |
| an IPv4 address | 33176 | 36.80 ± 0.2% | 36.75 ± 0.2% | 2.10 ± 0.3% | 29.01 ± 0.0% | 6.67 ± 0.3% | differs | 4.16 ± 0.5% | 36.65 ± 0.3% | 1.00 | 1.00 | 1.27 | 5.52 |
| a date and time | 32954 | 31.13 ± 0.3% | 31.16 ± 0.2% | 1.47 ± 0.2% | 21.18 ± 0.1% | 7.07 ± 0.1% | 1.20 ± 0.3% | 7.10 ± 0.5% | 31.09 ± 0.5% | 1.00 | 1.00 | 1.47 | 4.40 |
| a field path | 32606 | 29.45 ± 0.2% | 29.37 ± 0.2% | 1.03 ± 0.1% | 23.03 ± 0.4% | 3.49 ± 0.8% | differs | 2.91 ± 0.1% | 29.40 ± 0.1% | 1.00 | 1.00 | 1.28 | 8.44 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.46 ± 0.4% | 11.50 ± 0.9% | 11.44 ± 1.5% | 11.47 ± 0.1% | 4.95 ± 2.0% | 0.91 ± 0.7% | none | 11.50 ± 0.3% | 1.00 | 1.00 | 1.00 | 2.31 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 215.78 ± 0.4% | 216.48 ± 0.2% | 251.13 ± 0.2% | 87.23 ± 0.4% | 220.47 ± 0.9% | 485.73 ± 0.3% | 3888.06 ± 3.6% | 215.70 ± 0.3% | 1.00 | 1.00 | 2.47 | 0.98 |
| a UUID | 62 | 142.06 ± 0.2% | 142.51 ± 0.2% | 156.98 ± 0.1% | 45.80 ± 0.2% | 97.39 ± 1.7% | 183.91 ± 1.1% | 4417.49 ± 1.5% | 141.92 ± 0.5% | 1.00 | 1.00 | 3.10 | 1.46 |
| an IPv4 address | 29 | 435.57 ± 0.4% | 439.80 ± 0.5% | 610.72 ± 0.5% | 77.06 ± 1.0% | 129.02 ± 1.5% | 294.54 ± 0.7% | 7676.41 ± 0.2% | 436.19 ± 0.3% | 0.99 | 1.00 | 5.65 | 3.38 |
| a date and time | 56 | 318.25 ± 0.2% | 319.81 ± 0.1% | 400.75 ± 0.4% | 72.63 ± 0.2% | 135.24 ± 1.3% | 320.59 ± 1.1% | 4945.50 ± 0.4% | 317.67 ± 0.3% | 1.00 | 1.00 | 4.38 | 2.35 |
| a field path | 39 | 202.19 ± 0.4% | 203.07 ± 0.2% | 233.03 ± 0.4% | 80.11 ± 0.4% | 204.16 ± 0.9% | 482.10 ± 0.8% | 4957.81 ± 0.5% | 202.33 ± 0.2% | 1.00 | 1.00 | 2.52 | 0.99 |
| literal: a word | 7 | 659.94 ± 0.2% | 712.66 ± 0.3% | 1273.59 ± 0.2% | 513.19 ± 1.7% | 627.85 ± 0.7% | 918.90 ± 0.6% | 31221.42 ± 0.2% | 659.13 ± 0.3% | 0.93 | 1.00 | 1.29 | 1.05 |
| literal: a word that is not there | 8 | 630.36 ± 0.3% | 685.03 ± 0.6% | 1202.17 ± 0.1% | 469.73 ± 0.3% | 602.56 ± 1.3% | 874.57 ± 0.5% | 29459.47 ± 0.0% | 630.44 ± 0.4% | 0.92 | 1.00 | 1.34 | 1.05 |
| literal: one of four words | 26 | 253.87 ± 0.4% | 417.75 ± 0.4% | 565.11 ± 0.4% | 49.55 ± 0.3% | 242.17 ± 6.6% | 354.84 ± 0.4% | 15843.45 ± 0.2% | 253.85 ± 0.3% | 0.61 | 1.00 | 5.12 | 1.05 |
| literal: a word in any case | 11 | 515.30 ± 0.5% | 556.76 ± 0.4% | 858.48 ± 0.4% | 15.82 ± 1.2% | 651.23 ± 3.1% | refused | 23662.81 ± 0.3% | 515.44 ± 0.2% | 0.93 | 1.00 | 32.57 | 0.79 |
| literal: an href attribute | 12 | 346.01 ± 0.2% | 357.37 ± 0.3% | 464.56 ± 0.3% | 45.04 ± 0.4% | 496.19 ± 2.2% | 784.18 ± 1.6% | 22178.96 ± 0.2% | 346.17 ± 0.8% | 0.97 | 1.00 | 7.68 | 0.70 |
| literal: a word, second text | 10 | 587.66 ± 0.7% | 648.28 ± 0.8% | 1080.66 ± 1.0% | 416.53 ± 0.4% | 534.11 ± 2.5% | 801.96 ± 0.2% | 27410.96 ± 0.3% | 586.62 ± 0.4% | 0.91 | 1.00 | 1.41 | 1.10 |
| class: two capitalized words | 23 | 456.57 ± 0.2% | 486.12 ± 0.3% | 704.50 ± 0.3% | 101.90 ± 0.1% | 499.81 ± 1.7% | 741.84 ± 0.5% | 6620.26 ± 1.0% | 457.02 ± 0.3% | 0.94 | 1.00 | 4.48 | 0.91 |
| class: a word that ends in ing | 9 | 593.45 ± 0.6% | 661.65 ± 0.3% | 1162.31 ± 0.2% | 133.96 ± 1.4% | 760.64 ± 0.8% | 1098.51 ± 0.7% | 16310.16 ± 0.1% | 591.68 ± 0.7% | 0.90 | 1.00 | 4.43 | 0.78 |
| class: a word in capitals | 16 | 516.84 ± 0.3% | 555.27 ± 0.4% | 881.11 ± 0.5% | 137.62 ± 1.0% | 749.02 ± 1.0% | 1039.40 ± 0.9% | 8696.31 ± 0.1% | 516.21 ± 0.1% | 0.93 | 1.00 | 3.76 | 0.69 |
| class: a number | 6 | 649.65 ± 0.2% | 714.21 ± 0.5% | 1328.53 ± 0.1% | 41.90 ± 1.2% | 1397.25 ± 1.3% | 1904.49 ± 0.9% | 23082.49 ± 0.1% | 650.46 ± 0.3% | 0.91 | 1.00 | 15.50 | 0.46 |
| class: two capitalized words, second text | 23 | 456.49 ± 0.1% | 486.73 ± 0.4% | 703.28 ± 0.5% | 103.97 ± 0.2% | 503.80 ± 1.6% | 762.66 ± 0.5% | 6621.66 ± 1.0% | 456.40 ± 0.2% | 0.94 | 1.00 | 4.39 | 0.91 |
| other: a word between two words | 13 | 576.39 ± 0.2% | 596.10 ± 0.8% | 949.87 ± 0.1% | 135.62 ± 0.6% | 498.34 ± 1.0% | 813.64 ± 0.5% | 15109.48 ± 0.1% | 576.29 ± 0.4% | 0.97 | 1.00 | 4.25 | 1.16 |
| other: a number before a unit, second text | 15 | 398.47 ± 0.4% | 432.62 ± 0.5% | 595.08 ± 0.5% | 39.64 ± 0.5% | 630.73 ± 0.8% | 888.40 ± 0.2% | 15388.66 ± 0.2% | 398.35 ± 0.4% | 0.92 | 1.00 | 10.05 | 0.63 |
| other: a heading's start tag | 13 | 355.23 ± 0.5% | 360.29 ± 0.3% | 467.95 ± 0.3% | 43.85 ± 1.2% | 623.19 ± 1.6% | 876.76 ± 0.4% | 18451.57 ± 0.3% | 354.53 ± 0.3% | 0.99 | 1.00 | 8.10 | 0.57 |
| other: a whole word | 11 | 611.48 ± 0.5% | 650.91 ± 0.3% | 1086.19 ± 0.2% | 121.96 ± 0.9% | 564.05 ± 1.1% | 825.21 ± 1.6% | 27205.33 ± 0.3% | 609.68 ± 0.6% | 0.94 | 1.00 | 5.01 | 1.08 |
| other: a line's first word, second text | 17 | 552.47 ± 0.2% | 573.81 ± 0.5% | 916.15 ± 0.2% | 129.11 ± 0.1% | 709.10 ± 1.1% | refused | refused | 550.62 ± 0.5% | 0.96 | 1.00 | 4.28 | 0.78 |
| other: fourteen octets before an x | 16 | 112.10 ± 0.4% | 162.01 ± 0.6% | 185.18 ± 0.4% | 14.93 ± 0.7% | 450.49 ± 1.4% | 414.86 ± 1.4% | 12850.67 ± 2.1% | 112.18 ± 0.5% | 0.69 | 1.00 | 7.51 | 0.25 |
| other: a Greek word | 8 | 445.26 ± 0.3% | 582.40 ± 0.6% | 944.30 ± 0.1% | 59.12 ± 0.2% | 1395.32 ± 1.6% | 1772.11 ± 0.5% | refused | 445.14 ± 0.2% | 0.76 | 1.00 | 7.53 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12584.34 ± 1.4% | not timed | not timed | 15733.94 ± 1.5% | 2001.94 ± 16.0% | not timed | not timed | 12591.01 ± 0.5% | | 1.00 | 0.80 | 6.29 |
| 01-literal/sherlock-casei-en | 522 | 4494.98 ± 1.1% | not timed | not timed | 3591.82 ± 0.2% | 32.50 ± 0.2% | not timed | not timed | 4488.71 ± 0.6% | | 1.00 | 1.25 | 138.30 |
| 01-literal/sherlock-ru | 724 | 13548.41 ± 0.7% | not timed | not timed | 17258.53 ± 0.3% | 1413.39 ± 6.8% | not timed | not timed | 13523.19 ± 0.4% | | 1.00 | 0.79 | 9.59 |
| 01-literal/sherlock-casei-ru | 746 | 5283.59 ± 0.3% | not timed | not timed | 3331.63 ± 0.2% | 31.70 ± 0.4% | not timed | not timed | 5278.45 ± 0.3% | | 1.00 | 1.59 | 166.68 |
| 01-literal/sherlock-zh | 30 | 16575.61 ± 1.0% | not timed | not timed | 17920.91 ± 2.0% | 2634.20 ± 16.0% | not timed | not timed | 16497.58 ± 0.4% | | 1.00 | 0.92 | 6.29 |
| 02-literal-alternate/sherlock-en | 714 | 5758.15 ± 0.5% | not timed | not timed | 3937.71 ± 0.2% | 16.62 ± 0.3% | not timed | not timed | 5757.66 ± 0.3% | | 1.00 | 1.46 | 346.47 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1703.08 ± 0.8% | not timed | not timed | 697.49 ± 0.4% | 11.12 ± 7.2% | not timed | not timed | 1700.95 ± 1.3% | | 1.00 | 2.44 | 153.20 |
| 02-literal-alternate/sherlock-ru | 899 | 4641.06 ± 0.2% | not timed | not timed | 3253.82 ± 0.2% | 22.60 ± 0.1% | not timed | not timed | 4644.99 ± 0.2% | | 1.00 | 1.43 | 205.38 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1811.55 ± 0.7% | not timed | not timed | 1231.07 ± 0.1% | 9.13 ± 0.1% | not timed | not timed | 1806.03 ± 0.1% | | 1.00 | 1.47 | 198.33 |
| 02-literal-alternate/sherlock-zh | 207 | 7036.77 ± 0.2% | not timed | not timed | 4161.82 ± 0.2% | 31.47 ± 0.1% | not timed | not timed | 7036.31 ± 0.3% | | 1.00 | 1.69 | 223.62 |
| 03-date/ascii | 111817 | 127.29 ± 0.2% | not timed | not timed | 95.58 ± 0.2% | 0.20 ± 4.1% | not timed | not timed | 126.38 ± 0.3% | | 1.01 | 1.33 | 628.56 |
| 04-ruff-noqa/real | 84 | 553.48 ± 0.1% | not timed | not timed | 459.22 ± 0.1% | 19.55 ± 1.7% | not timed | not timed | 553.42 ± 0.1% | | 1.00 | 1.21 | 28.32 |
| 04-ruff-noqa/tweaked | 44 | 549.96 ± 0.1% | not timed | not timed | 461.95 ± 0.1% | 366.07 ± 0.3% | not timed | not timed | 548.31 ± 0.1% | | 1.00 | 1.19 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.96 ± 0.2% | not timed | not timed | 4.99 ± 0.2% | 0.20 ± 4.5% | not timed | not timed | 4.08 ± 1.1% | | 0.97 | 0.79 | 19.52 |
| 06-cloud-flare-redos/original | 107 | 263.98 ± 0.5% | not timed | not timed | 216.32 ± 0.1% | 24.99 ± 0.3% | not timed | not timed | 263.50 ± 0.3% | | 1.00 | 1.22 | 10.56 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.23 ± 0.0% | not timed | not timed | 228.37 ± 0.2% | 26.71 ± 0.1% | not timed | not timed | 259.18 ± 0.2% | | 1.00 | 1.14 | 9.71 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.09 ± 0.2% | not timed | not timed | 255.96 ± 0.1% | 28.74 ± 0.1% | not timed | not timed | 286.22 ± 0.4% | | 1.00 | 1.12 | 9.95 |
| 07-unicode-character-data/parse-line | 558784 | 239.16 ± 0.2% | not timed | not timed | 171.50 ± 0.2% | 39.40 ± 11.0% | not timed | not timed | 237.40 ± 1.7% | | 1.01 | 1.39 | 6.07 |
| 08-words/all-english | 56691 | 121.38 ± 0.3% | not timed | not timed | 83.18 ± 0.6% | 13.15 ± 10.0% | not timed | not timed | 120.94 ± 0.2% | | 1.00 | 1.46 | 9.23 |
| 08-words/long-english | 839 | 1006.99 ± 0.1% | not timed | not timed | 597.96 ± 0.0% | 32.60 ± 0.3% | not timed | not timed | 1006.75 ± 0.1% | | 1.00 | 1.68 | 30.89 |
| 09-aws-keys/full | 0 | 408.99 ± 0.1% | not timed | not timed | 464.07 ± 0.3% | 64.53 ± 0.1% | not timed | not timed | 408.55 ± 0.1% | | 1.00 | 0.88 | 6.34 |
| 09-aws-keys/quick | 0 | 737.06 ± 0.2% | not timed | not timed | 989.28 ± 0.4% | 418.88 ± 1.3% | not timed | not timed | 734.96 ± 0.0% | | 1.00 | 0.75 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 639.81 ± 0.5% | not timed | not timed | 516.31 ± 0.3% | 19.45 ± 0.9% | not timed | not timed | 637.61 ± 0.1% | | 1.00 | 1.24 | 32.89 |
| 10-bounded-repeat/letters-ru | 3475 | 385.41 ± 0.5% | not timed | not timed | 478.11 ± 0.0% | 21.93 ± 7.5% | not timed | not timed | 384.07 ± 0.4% | | 1.00 | 0.81 | 17.58 |
| 10-bounded-repeat/context | 53 | 78.37 ± 1.1% | not timed | not timed | 65.58 ± 0.4% | 19.80 ± 0.2% | not timed | not timed | 78.95 ± 1.3% | | 0.99 | 1.20 | 3.96 |
| 10-bounded-repeat/capitals | 11 | 1042.11 ± 0.2% | not timed | not timed | 615.89 ± 0.1% | 36.47 ± 0.2% | not timed | not timed | 1041.66 ± 0.2% | | 1.00 | 1.69 | 28.57 |
| 11-unstructured-to-json/extract | 600 | 49.86 ± 0.2% | not timed | not timed | 77.04 ± 0.2% | 49.14 ± 0.5% | not timed | not timed | 49.61 ± 0.2% | | 1.00 | 0.65 | 1.01 |
| 12-dictionary/single | 1 | 566.44 ± 0.1% | not timed | not timed | 559.09 ± 0.1% | 0.40 ± 0.4% | not timed | not timed | 567.37 ± 0.3% | | 1.00 | 1.01 | 1400.76 |
| 14-quadratic/1x | 100 | 9.66 ± 0.6% | not timed | not timed | 10.04 ± 0.2% | 0.96 ± 2.8% | not timed | not timed | 9.69 ± 1.1% | | 1.00 | 0.96 | 10.07 |
| 14-quadratic/2x | 200 | 5.57 ± 0.2% | not timed | not timed | 5.54 ± 0.3% | 0.53 ± 1.9% | not timed | not timed | 5.57 ± 0.6% | | 1.00 | 1.01 | 10.49 |
| 14-quadratic/10x | 1000 | 1.26 ± 1.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.9% | not timed | not timed | 1.26 ± 1.9% | | 1.00 | 1.04 | 10.88 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.53 ± 0.1% | not timed | not timed | 0.34 ± 0.3% | 0.54 ± 2.5% | not timed | not timed | 1.53 ± 1.7% | | 1.00 | 4.50 | 2.84 |
| 04-ruff-noqa/compile-real | 1 | 85.30 ± 0.2% | not timed | not timed | 13.62 ± 0.3% | 139.24 ± 2.2% | not timed | not timed | 84.42 ± 0.8% | | 1.01 | 6.26 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 14.52 ± 0.2% | not timed | not timed | 2.50 ± 0.4% | 6.38 ± 1.6% | not timed | not timed | 14.47 ± 0.8% | | 1.00 | 5.80 | 2.28 |
| 07-unicode-character-data/compile | 1 | 55.03 ± 0.3% | not timed | not timed | 26.10 ± 0.2% | 35.80 ± 1.7% | not timed | not timed | 54.94 ± 0.7% | | 1.00 | 2.11 | 1.54 |
| 09-aws-keys/compile-full | 1 | 42.27 ± 0.2% | not timed | not timed | 8.08 ± 1.1% | 23.14 ± 0.8% | not timed | not timed | 42.17 ± 0.7% | | 1.00 | 5.23 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 188.76 ± 0.1% | not timed | not timed | 47.26 ± 0.4% | 132.78 ± 13.0% | not timed | not timed | 188.22 ± 1.0% | | 1.00 | 3.99 | 1.42 |
| 10-bounded-repeat/compile-context | 1 | 14.62 ± 0.4% | not timed | not timed | 11.18 ± 0.3% | 15.86 ± 4.7% | not timed | not timed | 14.56 ± 2.2% | | 1.00 | 1.31 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 85.23 ± 0.1% | not timed | not timed | 8.09 ± 0.1% | 23.18 ± 1.7% | not timed | not timed | 84.71 ± 1.2% | | 1.01 | 10.53 | 3.68 |
| 11-unstructured-to-json/compile | 1 | 86.30 ± 0.2% | not timed | not timed | 41.20 ± 0.6% | 67.97 ± 1.5% | not timed | not timed | 85.95 ± 0.7% | | 1.00 | 2.09 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.1% | not timed | not timed | 0.07 ± 5.8% | 0.10 ± 16.5% | not timed | not timed | 0.35 ± 2.0% | | 1.02 | 5.21 | 3.79 |

