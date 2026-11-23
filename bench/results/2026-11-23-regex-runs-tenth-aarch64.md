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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148092409 |
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
| literal: a word | 217 | 15964.78 ± 0.9% | 1040.41 ± 0.1% | 28.72 ± 0.4% | 18170.06 ± 0.8% | 9279.14 ± 5.3% | 16.78 ± 0.5% | 86.51 ± 0.4% | 15952.39 ± 1.0% | 15.34 | 1.00 | 0.88 | 1.72 |
| literal: a word that is not there | 0 | 18597.50 ± 2.6% | 1049.18 ± 0.2% | 28.80 ± 0.3% | 19842.25 ± 2.2% | 28619.78 ± 3.2% | 16.68 ± 0.1% | 82.20 ± 1.3% | 18623.25 ± 2.7% | 17.73 | 1.00 | 0.94 | 0.65 |
| literal: one of four words | 661 | 6059.61 ± 0.1% | 1023.28 ± 0.1% | 14.72 ± 0.6% | 3947.53 ± 0.6% | 21.92 ± 0.1% | 5.30 ± 0.2% | 6.93 ± 0.8% | 6051.63 ± 0.2% | 5.92 | 1.00 | 1.54 | 276.44 |
| literal: a word in any case | 217 | 12610.72 ± 0.5% | 1040.42 ± 0.1% | 21.48 ± 2.2% | 3975.31 ± 0.2% | 37.88 ± 0.3% | refused | differs | 12599.58 ± 0.8% | 12.12 | 1.00 | 3.17 | 332.91 |
| literal: an href attribute | 33 | 13638.62 ± 1.6% | 1047.29 ± 0.2% | 27.33 ± 0.2% | 16732.01 ± 2.0% | 2258.28 ± 0.4% | 12.99 ± 0.3% | 75.29 ± 0.1% | 13678.35 ± 2.0% | 13.02 | 1.00 | 0.82 | 6.04 |
| literal: a word, second text | 123 | 16308.46 ± 1.7% | 1043.58 ± 0.3% | 28.15 ± 0.1% | 18293.81 ± 3.4% | 7641.14 ± 6.2% | 18.67 ± 0.7% | 70.15 ± 0.5% | 16491.41 ± 1.8% | 15.63 | 0.99 | 0.89 | 2.13 |
| class: two capitalized words | 1331 | 1104.50 ± 0.2% | 978.03 ± 0.1% | 26.11 ± 0.2% | 585.26 ± 0.1% | 40.54 ± 2.9% | 14.31 ± 0.3% | 68.77 ± 0.2% | 1102.32 ± 0.4% | 1.13 | 1.00 | 1.89 | 27.24 |
| class: a word that ends in ing | 3399 | 895.22 ± 0.1% | 894.65 ± 0.1% | 18.20 ± 0.6% | 548.05 ± 0.5% | 29.59 ± 5.1% | 7.76 ± 0.1% | 18.40 ± 0.5% | 894.74 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.25 |
| class: a word in capitals | 2332 | 1457.51 ± 0.5% | 949.90 ± 0.4% | 27.73 ± 0.4% | 572.58 ± 0.3% | 43.50 ± 2.9% | 16.41 ± 0.1% | 83.16 ± 0.4% | 1456.30 ± 0.3% | 1.53 | 1.00 | 2.55 | 33.51 |
| class: a number | 8288 | 1964.63 ± 0.4% | 835.40 ± 0.5% | 27.99 ± 0.1% | 1723.39 ± 0.1% | 41.92 ± 16.1% | 0.54 ± 0.1% | 56.56 ± 0.2% | 1982.92 ± 0.3% | 2.35 | 0.99 | 1.14 | 46.87 |
| class: two capitalized words, second text | 5359 | 743.41 ± 0.4% | 744.34 ± 0.2% | 23.42 ± 0.2% | 483.99 ± 0.1% | 35.37 ± 2.6% | 16.07 ± 0.1% | 63.81 ± 0.4% | 743.17 ± 0.1% | 1.00 | 1.00 | 1.54 | 21.02 |
| other: a word between two words | 6104 | 754.30 ± 0.1% | 777.37 ± 0.1% | 23.63 ± 0.2% | 740.84 ± 0.1% | 108.69 ± 13.9% | 10.94 ± 0.3% | 69.52 ± 0.3% | 752.78 ± 0.2% | 0.97 | 1.00 | 1.02 | 6.94 |
| other: a number before a unit, second text | 1481 | 5429.91 ± 0.9% | 984.89 ± 0.1% | 26.09 ± 0.2% | 5634.53 ± 0.6% | 40.73 ± 0.1% | 16.89 ± 0.1% | 66.90 ± 0.2% | 5432.85 ± 0.6% | 5.51 | 1.00 | 0.96 | 133.31 |
| other: a heading's start tag | 110 | 12533.23 ± 0.5% | 1036.53 ± 0.1% | 27.59 ± 0.3% | 1707.70 ± 0.7% | 1579.53 ± 2.3% | 15.68 ± 0.6% | 88.84 ± 0.5% | 12518.33 ± 0.5% | 12.09 | 1.00 | 7.34 | 7.93 |
| other: a whole word | 217 | 14071.40 ± 0.7% | 1038.46 ± 0.5% | 29.78 ± 0.1% | 14526.69 ± 1.6% | 49.40 ± 0.2% | 12.79 ± 0.1% | 55.68 ± 0.4% | 14020.23 ± 0.5% | 13.55 | 1.00 | 0.97 | 284.85 |
| other: a line's first word, second text | 3716 | 1975.39 ± 0.8% | 877.22 ± 0.5% | 31.25 ± 0.2% | 1722.11 ± 0.3% | 62.08 ± 8.1% | refused | refused | 1961.91 ± 0.3% | 2.25 | 1.01 | 1.15 | 31.82 |
| other: fourteen octets before an x | 87 | 19652.64 ± 1.6% | 229.13 ± 0.2% | 6.60 ± 0.1% | 4011.37 ± 0.4% | 10.66 ± 0.1% | differs | 17.77 ± 0.5% | 19721.75 ± 1.4% | 85.77 | 1.00 | 4.90 | 1844.35 |
| other: a Greek word | 21815 | 514.68 ± 0.2% | 398.01 ± 0.2% | 31.14 ± 0.1% | 289.58 ± 0.1% | 49.51 ± 10.4% | differs | refused | 511.74 ± 0.3% | 1.29 | 1.01 | 1.78 | 10.40 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.89 ± 0.2% | 25.86 ± 0.4% | 0.87 ± 0.4% | 19.83 ± 0.3% | 2.76 ± 0.5% | differs | 4.01 ± 0.1% | 25.88 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.37 |
| a UUID | 32895 | 21.12 ± 0.2% | 21.17 ± 0.1% | 0.65 ± 0.2% | 15.05 ± 0.6% | 3.11 ± 0.5% | 0.73 ± 0.2% | 3.60 ± 0.5% | 21.25 ± 0.1% | 1.00 | 0.99 | 1.40 | 6.80 |
| an IPv4 address | 33176 | 36.98 ± 0.5% | 36.96 ± 0.4% | 2.10 ± 0.3% | 29.34 ± 0.7% | 6.66 ± 0.1% | differs | 4.18 ± 0.3% | 37.02 ± 0.3% | 1.00 | 1.00 | 1.26 | 5.56 |
| a date and time | 32954 | 31.28 ± 0.4% | 31.38 ± 0.3% | 1.47 ± 0.1% | 21.53 ± 0.3% | 7.07 ± 0.1% | 1.25 ± 0.2% | 7.16 ± 0.2% | 31.31 ± 0.6% | 1.00 | 1.00 | 1.45 | 4.43 |
| a field path | 32606 | 29.57 ± 0.2% | 29.52 ± 0.5% | 1.03 ± 0.3% | 23.16 ± 0.6% | 3.51 ± 1.0% | differs | 2.93 ± 0.2% | 29.54 ± 0.2% | 1.00 | 1.00 | 1.28 | 8.41 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.51 ± 0.3% | 11.47 ± 0.4% | 11.40 ± 0.7% | 11.55 ± 0.1% | 4.91 ± 1.0% | 0.93 ± 0.7% | none | 11.47 ± 0.2% | 1.00 | 1.00 | 1.00 | 2.34 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 233.09 ± 0.4% | 234.98 ± 0.5% | 286.17 ± 0.2% | 86.65 ± 0.3% | 219.07 ± 0.6% | 482.57 ± 0.5% | 3856.51 ± 2.0% | 233.18 ± 0.3% | 0.99 | 1.00 | 2.69 | 1.06 |
| a UUID | 62 | 156.63 ± 0.3% | 157.01 ± 0.2% | 178.82 ± 0.1% | 45.57 ± 0.2% | 98.07 ± 1.1% | 180.55 ± 0.7% | 4376.20 ± 2.2% | 156.56 ± 0.2% | 1.00 | 1.00 | 3.44 | 1.60 |
| an IPv4 address | 29 | 417.77 ± 0.1% | 423.32 ± 0.2% | 612.10 ± 0.6% | 76.59 ± 0.9% | 129.64 ± 15.5% | 286.19 ± 0.9% | 7616.84 ± 0.3% | 417.49 ± 0.8% | 0.99 | 1.00 | 5.45 | 3.22 |
| a date and time | 56 | 305.33 ± 0.4% | 307.87 ± 0.1% | 397.02 ± 0.2% | 72.35 ± 0.2% | 134.81 ± 2.3% | 316.19 ± 0.6% | 4912.90 ± 0.6% | 305.26 ± 0.3% | 0.99 | 1.00 | 4.22 | 2.26 |
| a field path | 39 | 226.25 ± 0.3% | 227.75 ± 0.2% | 274.37 ± 0.3% | 79.79 ± 0.5% | 203.62 ± 0.7% | 482.33 ± 0.6% | 4940.54 ± 0.7% | 226.42 ± 0.2% | 0.99 | 1.00 | 2.84 | 1.11 |
| literal: a word | 7 | 619.25 ± 0.4% | 661.82 ± 0.7% | 1253.39 ± 0.7% | 512.00 ± 1.6% | 613.95 ± 2.8% | 909.82 ± 0.5% | 29421.20 ± 0.3% | 618.90 ± 0.5% | 0.94 | 1.00 | 1.21 | 1.01 |
| literal: a word that is not there | 8 | 595.76 ± 0.2% | 645.01 ± 0.4% | 1184.29 ± 0.1% | 468.74 ± 0.2% | 586.81 ± 1.5% | 864.07 ± 0.4% | 28530.05 ± 0.1% | 596.20 ± 0.3% | 0.92 | 1.00 | 1.27 | 1.02 |
| literal: one of four words | 26 | 240.67 ± 0.1% | 400.23 ± 0.3% | 562.98 ± 0.5% | 49.42 ± 0.2% | 236.62 ± 0.8% | 353.66 ± 0.6% | 15397.31 ± 0.5% | 240.75 ± 0.3% | 0.60 | 1.00 | 4.87 | 1.02 |
| literal: a word in any case | 11 | 482.48 ± 0.3% | 514.51 ± 0.3% | 841.71 ± 0.3% | 15.80 ± 0.9% | 631.59 ± 2.7% | refused | 23434.90 ± 0.3% | 482.20 ± 0.3% | 0.94 | 1.00 | 30.54 | 0.76 |
| literal: an href attribute | 12 | 350.36 ± 0.2% | 362.92 ± 0.4% | 497.31 ± 0.3% | 44.86 ± 0.4% | 487.52 ± 1.9% | 779.71 ± 1.7% | 21457.33 ± 0.1% | 350.17 ± 0.3% | 0.97 | 1.00 | 7.81 | 0.72 |
| literal: a word, second text | 10 | 556.52 ± 0.3% | 607.45 ± 0.3% | 1068.37 ± 0.1% | 414.86 ± 0.5% | 520.12 ± 16.6% | 794.72 ± 0.8% | 26454.63 ± 0.4% | 556.41 ± 0.2% | 0.92 | 1.00 | 1.34 | 1.07 |
| class: two capitalized words | 23 | 434.01 ± 0.4% | 466.00 ± 0.4% | 704.49 ± 0.4% | 101.52 ± 0.2% | 490.06 ± 0.7% | 739.66 ± 0.4% | 6571.97 ± 0.8% | 432.98 ± 0.3% | 0.93 | 1.00 | 4.28 | 0.89 |
| class: a word that ends in ing | 9 | 550.38 ± 0.8% | 623.32 ± 0.5% | 1160.39 ± 0.3% | 133.67 ± 1.3% | 739.48 ± 1.8% | 1086.26 ± 1.0% | 16003.08 ± 0.2% | 551.46 ± 0.5% | 0.88 | 1.00 | 4.12 | 0.74 |
| class: a word in capitals | 16 | 484.46 ± 0.2% | 528.64 ± 0.2% | 901.34 ± 0.2% | 137.32 ± 0.9% | 742.44 ± 1.4% | 1041.02 ± 1.3% | 8642.04 ± 0.8% | 484.63 ± 0.2% | 0.92 | 1.00 | 3.53 | 0.65 |
| class: a number | 6 | 604.71 ± 0.2% | 678.15 ± 0.3% | 1361.78 ± 0.1% | 41.83 ± 1.1% | 1393.18 ± 1.2% | 1928.17 ± 1.2% | 22492.78 ± 0.2% | 604.27 ± 0.2% | 0.89 | 1.00 | 14.46 | 0.43 |
| class: two capitalized words, second text | 23 | 433.37 ± 0.2% | 465.75 ± 0.1% | 704.93 ± 0.3% | 103.75 ± 0.2% | 493.93 ± 2.5% | 761.89 ± 0.8% | 6568.67 ± 0.3% | 433.65 ± 0.2% | 0.93 | 1.00 | 4.18 | 0.88 |
| other: a word between two words | 13 | 548.91 ± 0.2% | 566.72 ± 0.3% | 949.66 ± 0.1% | 135.71 ± 0.6% | 488.11 ± 6.8% | 812.27 ± 0.5% | 14801.59 ± 0.7% | 549.11 ± 0.5% | 0.97 | 1.00 | 4.04 | 1.12 |
| other: a number before a unit, second text | 15 | 403.47 ± 0.3% | 445.11 ± 0.5% | 650.95 ± 0.6% | 39.56 ± 0.4% | 625.61 ± 2.5% | 889.41 ± 0.1% | 15087.01 ± 0.3% | 404.14 ± 0.5% | 0.91 | 1.00 | 10.20 | 0.64 |
| other: a heading's start tag | 13 | 358.58 ± 0.2% | 364.17 ± 0.2% | 499.98 ± 0.2% | 43.66 ± 1.6% | 614.51 ± 1.1% | 876.35 ± 0.2% | 17861.86 ± 0.5% | 357.93 ± 0.6% | 0.98 | 1.00 | 8.21 | 0.58 |
| other: a whole word | 11 | 581.12 ± 0.5% | 615.66 ± 0.4% | 1085.75 ± 0.1% | 121.67 ± 0.6% | 552.65 ± 1.4% | 820.33 ± 2.2% | 26524.13 ± 0.3% | 581.36 ± 0.4% | 0.94 | 1.00 | 4.78 | 1.05 |
| other: a line's first word, second text | 17 | 529.10 ± 0.2% | 547.34 ± 0.5% | 932.63 ± 0.3% | 128.86 ± 0.3% | 702.42 ± 0.7% | refused | refused | 526.19 ± 0.7% | 0.97 | 1.01 | 4.11 | 0.75 |
| other: fourteen octets before an x | 16 | 111.83 ± 0.3% | 162.22 ± 0.2% | 190.59 ± 0.5% | 15.04 ± 0.6% | 445.98 ± 2.0% | 402.93 ± 1.2% | 12569.94 ± 0.8% | 111.86 ± 0.4% | 0.69 | 1.00 | 7.44 | 0.25 |
| other: a Greek word | 8 | 420.20 ± 0.2% | 580.58 ± 0.6% | 1039.13 ± 0.6% | 58.88 ± 0.7% | 1365.25 ± 0.8% | 1813.00 ± 0.7% | refused | 420.16 ± 0.1% | 0.72 | 1.00 | 7.14 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12764.35 ± 0.5% | not timed | not timed | 16118.65 ± 2.0% | 2153.38 ± 11.8% | not timed | not timed | 12747.47 ± 0.9% | | 1.00 | 0.79 | 5.93 |
| 01-literal/sherlock-casei-en | 522 | 4489.84 ± 0.7% | not timed | not timed | 3591.43 ± 0.2% | 32.54 ± 0.2% | not timed | not timed | 4477.05 ± 0.3% | | 1.00 | 1.25 | 138.00 |
| 01-literal/sherlock-ru | 724 | 13527.40 ± 0.6% | not timed | not timed | 17269.95 ± 0.4% | 1499.30 ± 20.6% | not timed | not timed | 13523.70 ± 0.6% | | 1.00 | 0.78 | 9.02 |
| 01-literal/sherlock-casei-ru | 746 | 5291.99 ± 1.5% | not timed | not timed | 3326.43 ± 2.6% | 31.35 ± 1.3% | not timed | not timed | 5252.44 ± 2.6% | | 1.01 | 1.59 | 168.78 |
| 01-literal/sherlock-zh | 30 | 17052.48 ± 0.6% | not timed | not timed | 18727.93 ± 0.4% | 2684.03 ± 7.4% | not timed | not timed | 17015.24 ± 0.8% | | 1.00 | 0.91 | 6.35 |
| 02-literal-alternate/sherlock-en | 714 | 5736.03 ± 0.4% | not timed | not timed | 3939.29 ± 0.2% | 16.65 ± 0.2% | not timed | not timed | 5733.69 ± 0.2% | | 1.00 | 1.46 | 344.50 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1711.53 ± 1.0% | not timed | not timed | 697.17 ± 0.1% | 11.03 ± 0.1% | not timed | not timed | 1703.34 ± 0.2% | | 1.00 | 2.45 | 155.17 |
| 02-literal-alternate/sherlock-ru | 899 | 4642.65 ± 0.3% | not timed | not timed | 3249.99 ± 0.1% | 22.59 ± 0.1% | not timed | not timed | 4643.60 ± 0.2% | | 1.00 | 1.43 | 205.48 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1811.02 ± 0.8% | not timed | not timed | 1231.03 ± 0.1% | 9.13 ± 0.2% | not timed | not timed | 1805.78 ± 0.4% | | 1.00 | 1.47 | 198.28 |
| 02-literal-alternate/sherlock-zh | 207 | 7044.98 ± 0.6% | not timed | not timed | 4158.33 ± 0.1% | 30.27 ± 0.1% | not timed | not timed | 7038.82 ± 0.3% | | 1.00 | 1.69 | 232.73 |
| 03-date/ascii | 111817 | 127.07 ± 0.6% | not timed | not timed | 95.85 ± 0.1% | 0.20 ± 3.7% | not timed | not timed | 126.50 ± 0.5% | | 1.00 | 1.33 | 637.21 |
| 04-ruff-noqa/real | 84 | 553.87 ± 0.1% | not timed | not timed | 469.80 ± 0.1% | 19.56 ± 1.1% | not timed | not timed | 553.68 ± 0.1% | | 1.00 | 1.18 | 28.31 |
| 04-ruff-noqa/tweaked | 44 | 549.51 ± 0.3% | not timed | not timed | 463.83 ± 0.1% | 366.03 ± 0.3% | not timed | not timed | 547.57 ± 0.1% | | 1.00 | 1.18 | 1.50 |
| 05-lexer-veryl/single | 124800 | 4.23 ± 0.7% | not timed | not timed | 5.23 ± 0.3% | 0.21 ± 3.0% | not timed | not timed | 4.22 ± 2.4% | | 1.00 | 0.81 | 20.54 |
| 06-cloud-flare-redos/original | 107 | 263.89 ± 0.2% | not timed | not timed | 216.40 ± 0.1% | 24.93 ± 0.1% | not timed | not timed | 263.64 ± 0.1% | | 1.00 | 1.22 | 10.59 |
| 06-cloud-flare-redos/simplified-short | 102 | 258.94 ± 0.6% | not timed | not timed | 227.44 ± 0.0% | 26.76 ± 0.2% | not timed | not timed | 259.34 ± 0.6% | | 1.00 | 1.14 | 9.68 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.19 ± 0.3% | not timed | not timed | 255.91 ± 0.1% | 28.83 ± 0.1% | not timed | not timed | 286.29 ± 0.3% | | 1.00 | 1.12 | 9.93 |
| 07-unicode-character-data/parse-line | 558784 | 232.64 ± 0.3% | not timed | not timed | 178.66 ± 0.2% | 42.70 ± 5.9% | not timed | not timed | 229.62 ± 2.2% | | 1.01 | 1.30 | 5.45 |
| 08-words/all-english | 56691 | 120.79 ± 0.1% | not timed | not timed | 83.12 ± 0.2% | 11.86 ± 13.4% | not timed | not timed | 119.94 ± 0.3% | | 1.01 | 1.45 | 10.18 |
| 08-words/long-english | 839 | 1006.73 ± 0.1% | not timed | not timed | 598.01 ± 0.1% | 32.45 ± 0.1% | not timed | not timed | 1006.72 ± 0.1% | | 1.00 | 1.68 | 31.02 |
| 09-aws-keys/full | 0 | 408.95 ± 0.0% | not timed | not timed | 474.25 ± 0.0% | 64.55 ± 0.2% | not timed | not timed | 409.20 ± 0.1% | | 1.00 | 0.86 | 6.34 |
| 09-aws-keys/quick | 0 | 743.56 ± 0.1% | not timed | not timed | 996.61 ± 0.1% | 420.75 ± 1.0% | not timed | not timed | 740.17 ± 0.1% | | 1.00 | 0.75 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 638.94 ± 0.4% | not timed | not timed | 516.49 ± 0.1% | 19.47 ± 0.9% | not timed | not timed | 637.90 ± 0.1% | | 1.00 | 1.24 | 32.81 |
| 10-bounded-repeat/letters-ru | 3475 | 384.65 ± 0.3% | not timed | not timed | 478.40 ± 0.1% | 22.00 ± 8.6% | not timed | not timed | 382.74 ± 1.6% | | 1.01 | 0.80 | 17.49 |
| 10-bounded-repeat/context | 53 | 79.16 ± 1.3% | not timed | not timed | 66.04 ± 0.4% | 19.81 ± 0.3% | not timed | not timed | 79.15 ± 1.0% | | 1.00 | 1.20 | 4.00 |
| 10-bounded-repeat/capitals | 11 | 1041.86 ± 0.1% | not timed | not timed | 615.65 ± 0.0% | 36.56 ± 0.1% | not timed | not timed | 1041.41 ± 0.1% | | 1.00 | 1.69 | 28.50 |
| 11-unstructured-to-json/extract | 600 | 49.88 ± 0.3% | not timed | not timed | 77.30 ± 0.3% | 48.92 ± 0.7% | not timed | not timed | 48.48 ± 1.0% | | 1.03 | 0.65 | 1.02 |
| 12-dictionary/single | 1 | 564.88 ± 0.4% | not timed | not timed | 556.36 ± 0.5% | 0.41 ± 0.1% | not timed | not timed | 567.44 ± 0.2% | | 1.00 | 1.02 | 1380.37 |
| 14-quadratic/1x | 100 | 9.65 ± 0.4% | not timed | not timed | 10.05 ± 0.1% | 0.98 ± 3.5% | not timed | not timed | 9.64 ± 1.0% | | 1.00 | 0.96 | 9.85 |
| 14-quadratic/2x | 200 | 5.57 ± 0.3% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 2.2% | not timed | not timed | 5.56 ± 0.3% | | 1.00 | 1.00 | 10.42 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.11 ± 1.4% | not timed | not timed | 1.26 ± 1.7% | | 1.00 | 1.04 | 11.00 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 1.2% | not timed | not timed | 0.34 ± 0.6% | 0.55 ± 4.1% | not timed | not timed | 1.44 ± 1.1% | | 1.00 | 4.22 | 2.61 |
| 04-ruff-noqa/compile-real | 1 | 92.38 ± 0.2% | not timed | not timed | 13.76 ± 0.2% | 138.44 ± 0.8% | not timed | not timed | 91.52 ± 1.1% | | 1.01 | 6.71 | 0.67 |
| 05-lexer-veryl/compile-single | 1 | 14.59 ± 0.1% | not timed | not timed | 2.53 ± 1.1% | 6.33 ± 2.0% | not timed | not timed | 14.58 ± 0.6% | | 1.00 | 5.77 | 2.30 |
| 07-unicode-character-data/compile | 1 | 58.08 ± 0.2% | not timed | not timed | 25.83 ± 0.2% | 35.65 ± 2.6% | not timed | not timed | 57.77 ± 0.9% | | 1.01 | 2.25 | 1.63 |
| 09-aws-keys/compile-full | 1 | 43.73 ± 0.2% | not timed | not timed | 8.27 ± 0.7% | 23.22 ± 2.1% | not timed | not timed | 43.26 ± 1.3% | | 1.01 | 5.29 | 1.88 |
| 09-aws-keys/compile-quick | 1 | 186.97 ± 0.1% | not timed | not timed | 47.11 ± 0.4% | 131.12 ± 8.8% | not timed | not timed | 187.03 ± 1.1% | | 1.00 | 3.97 | 1.43 |
| 10-bounded-repeat/compile-context | 1 | 14.67 ± 0.8% | not timed | not timed | 11.13 ± 0.3% | 15.96 ± 2.8% | not timed | not timed | 14.60 ± 1.1% | | 1.00 | 1.32 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 85.19 ± 0.8% | not timed | not timed | 8.08 ± 0.1% | 23.66 ± 1.5% | not timed | not timed | 84.99 ± 0.8% | | 1.00 | 10.54 | 3.60 |
| 11-unstructured-to-json/compile | 1 | 90.22 ± 0.2% | not timed | not timed | 41.41 ± 0.3% | 67.25 ± 2.5% | not timed | not timed | 90.00 ± 0.3% | | 1.00 | 2.18 | 1.34 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.3% | not timed | not timed | 0.07 ± 13.8% | 0.10 ± 14.7% | not timed | not timed | 0.36 ± 1.2% | | 1.01 | 5.25 | 3.78 |

