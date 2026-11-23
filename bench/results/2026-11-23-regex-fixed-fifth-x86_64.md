# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159262992 |
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
| literal: a word | 217 | 22452.27 ± 0.6% | 840.27 ± 0.2% | 26.91 ± 2.0% | 22922.21 ± 1.7% | 8722.32 ± 8.2% | 11.72 ± 0.2% | 88.87 ± 1.1% | 22440.35 ± 0.5% | 26.72 | 1.00 | 0.98 | 2.57 |
| literal: a word that is not there | 0 | 28546.56 ± 0.3% | 847.36 ± 0.2% | 27.27 ± 2.1% | 25375.18 ± 7.4% | 28732.67 ± 2.1% | 11.38 ± 0.5% | 83.51 ± 0.2% | 28521.35 ± 0.3% | 33.69 | 1.00 | 1.12 | 0.99 |
| literal: one of four words | 661 | 9752.35 ± 1.5% | 824.89 ± 0.1% | 14.75 ± 3.4% | 7444.39 ± 1.9% | 22.56 ± 0.4% | 3.40 ± 0.5% | 6.59 ± 1.1% | 9658.25 ± 0.5% | 11.82 | 1.01 | 1.31 | 432.34 |
| literal: a word in any case | 217 | 19478.41 ± 0.5% | 840.48 ± 0.2% | 19.64 ± 2.5% | 7729.17 ± 1.1% | 43.23 ± 2.2% | refused | differs | 19392.90 ± 1.3% | 23.18 | 1.00 | 2.52 | 450.54 |
| literal: an href attribute | 33 | 20239.46 ± 1.7% | 845.58 ± 0.1% | 24.30 ± 1.3% | 20689.29 ± 1.6% | 1983.30 ± 3.1% | 8.30 ± 0.9% | 76.31 ± 1.3% | 20217.64 ± 0.4% | 23.94 | 1.00 | 0.98 | 10.20 |
| literal: a word, second text | 123 | 23486.32 ± 0.5% | 842.80 ± 0.3% | 26.76 ± 1.8% | 23006.08 ± 0.5% | 7032.96 ± 4.6% | 15.13 ± 0.5% | 75.05 ± 0.6% | 23430.46 ± 1.4% | 27.87 | 1.00 | 1.02 | 3.34 |
| class: two capitalized words | 1331 | 780.75 ± 1.2% | 783.27 ± 0.3% | 25.00 ± 1.2% | 473.13 ± 0.4% | 37.63 ± 7.2% | 9.95 ± 0.2% | 63.65 ± 3.1% | 779.85 ± 0.2% | 1.00 | 1.00 | 1.65 | 20.75 |
| class: a word that ends in ing | 3399 | 715.67 ± 0.6% | 713.84 ± 0.2% | 15.85 ± 1.4% | 445.18 ± 0.4% | 27.07 ± 4.4% | 5.60 ± 0.6% | 16.93 ± 0.8% | 714.25 ± 0.5% | 1.00 | 1.00 | 1.61 | 26.44 |
| class: a word in capitals | 2332 | 1055.21 ± 0.9% | 765.28 ± 0.5% | 26.20 ± 4.1% | 466.30 ± 0.3% | 40.81 ± 14.2% | 11.94 ± 1.1% | 79.50 ± 0.3% | 1052.10 ± 0.4% | 1.38 | 1.00 | 2.26 | 25.86 |
| class: a number | 8288 | 1530.83 ± 0.6% | 662.21 ± 0.5% | 26.06 ± 1.5% | 1622.26 ± 0.3% | 41.47 ± 14.8% | 0.33 ± 0.4% | 55.77 ± 0.6% | 1534.11 ± 0.5% | 2.31 | 1.00 | 0.94 | 36.92 |
| class: two capitalized words, second text | 5359 | 582.91 ± 0.3% | 582.69 ± 0.5% | 22.24 ± 0.6% | 392.53 ± 0.4% | 31.68 ± 8.0% | 12.94 ± 0.2% | 58.00 ± 0.4% | 582.49 ± 0.4% | 1.00 | 1.00 | 1.49 | 18.40 |
| other: a word between two words | 6104 | 661.22 ± 0.1% | 614.91 ± 0.5% | 21.91 ± 1.2% | 669.65 ± 1.2% | 102.46 ± 12.6% | 7.60 ± 0.1% | 66.85 ± 0.4% | 659.55 ± 0.2% | 1.08 | 1.00 | 0.99 | 6.45 |
| other: a number before a unit, second text | 1481 | 7177.94 ± 3.4% | 794.71 ± 0.2% | 24.63 ± 1.6% | 6976.91 ± 0.9% | 38.20 ± 0.8% | 13.56 ± 0.2% | 62.23 ± 0.7% | 6991.26 ± 2.4% | 9.03 | 1.03 | 1.03 | 187.90 |
| other: a heading's start tag | 110 | 15036.76 ± 0.5% | 838.06 ± 0.1% | 26.27 ± 2.1% | 2041.93 ± 0.8% | 1484.83 ± 1.3% | 10.38 ± 0.5% | 90.72 ± 1.0% | 15060.08 ± 0.5% | 17.94 | 1.00 | 7.36 | 10.13 |
| other: a whole word | 217 | 17868.18 ± 0.5% | 839.95 ± 0.3% | 27.00 ± 2.1% | 18557.58 ± 1.3% | 44.29 ± 1.2% | 9.92 ± 0.3% | 52.25 ± 0.5% | 17820.96 ± 2.3% | 21.27 | 1.00 | 0.96 | 403.39 |
| other: a line's first word, second text | 3716 | 1946.87 ± 0.6% | 701.38 ± 0.2% | 27.90 ± 1.0% | 1897.45 ± 2.6% | 62.08 ± 6.3% | refused | refused | 1936.41 ± 0.6% | 2.78 | 1.01 | 1.03 | 31.36 |
| other: fourteen octets before an x | 87 | 26007.43 ± 1.2% | 233.15 ± 0.4% | 5.75 ± 1.6% | 3282.84 ± 0.3% | 8.88 ± 2.0% | differs | 16.08 ± 0.4% | 25820.09 ± 3.1% | 111.55 | 1.01 | 7.92 | 2929.11 |
| other: a Greek word | 21815 | 408.43 ± 1.0% | 317.67 ± 1.3% | 28.24 ± 1.3% | 242.13 ± 0.2% | 46.83 ± 9.2% | differs | refused | 407.48 ± 0.3% | 1.29 | 1.00 | 1.69 | 8.72 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 22.68 ± 0.4% | 22.68 ± 0.3% | 0.80 ± 0.6% | 16.40 ± 0.3% | 2.44 ± 0.7% | differs | 3.76 ± 2.6% | 22.60 ± 2.2% | 1.00 | 1.00 | 1.38 | 9.31 |
| a UUID | 32895 | 20.20 ± 3.9% | 20.21 ± 0.2% | 0.56 ± 2.1% | 12.64 ± 1.2% | 2.44 ± 0.5% | 0.55 ± 1.1% | 3.10 ± 1.3% | 20.20 ± 0.2% | 1.00 | 1.00 | 1.60 | 8.29 |
| an IPv4 address | 33176 | 29.79 ± 0.5% | 29.85 ± 0.4% | 1.79 ± 0.5% | 24.04 ± 0.6% | 5.83 ± 0.3% | differs | 3.46 ± 0.4% | 29.79 ± 0.3% | 1.00 | 1.00 | 1.24 | 5.11 |
| a date and time | 32954 | 29.91 ± 0.9% | 29.84 ± 1.4% | 1.25 ± 1.0% | 18.32 ± 0.5% | 7.57 ± 0.5% | 1.01 ± 0.3% | 6.83 ± 2.4% | 29.88 ± 0.7% | 1.00 | 1.00 | 1.63 | 3.95 |
| a field path | 32606 | 24.37 ± 0.7% | 24.36 ± 0.7% | 0.94 ± 0.8% | 18.90 ± 0.3% | 2.73 ± 3.0% | differs | 2.30 ± 0.7% | 24.36 ± 0.3% | 1.00 | 1.00 | 1.29 | 8.92 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.42 ± 5.4% | 9.50 ± 5.3% | 9.50 ± 5.4% | 11.39 ± 5.3% | 4.93 ± 3.0% | 0.79 ± 2.2% | none | 9.43 ± 1.8% | 0.99 | 1.00 | 0.83 | 1.91 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 236.47 ± 0.3% | 237.59 ± 0.3% | 276.95 ± 5.7% | 84.44 ± 3.9% | 196.05 ± 6.2% | 551.31 ± 1.9% | 3260.46 ± 0.6% | 236.38 ± 0.6% | 1.00 | 1.00 | 2.80 | 1.21 |
| a UUID | 62 | 155.74 ± 4.9% | 157.16 ± 11.9% | 174.25 ± 0.8% | 45.90 ± 1.3% | 89.51 ± 2.5% | 192.00 ± 2.2% | 4194.21 ± 1.7% | 155.47 ± 1.4% | 0.99 | 1.00 | 3.39 | 1.74 |
| an IPv4 address | 29 | 462.26 ± 0.3% | 468.29 ± 0.9% | 649.93 ± 0.6% | 74.78 ± 1.3% | 119.29 ± 2.7% | 335.87 ± 1.2% | 7037.80 ± 2.1% | 460.40 ± 1.2% | 0.99 | 1.00 | 6.18 | 3.87 |
| a date and time | 56 | 355.86 ± 1.3% | 359.16 ± 4.3% | 451.51 ± 0.3% | 70.74 ± 0.5% | 124.85 ± 0.7% | 351.75 ± 1.9% | 4394.62 ± 0.6% | 355.46 ± 2.6% | 0.99 | 1.00 | 5.03 | 2.85 |
| a field path | 39 | 232.60 ± 2.1% | 233.37 ± 4.2% | 271.15 ± 0.4% | 77.09 ± 1.1% | 186.20 ± 31.4% | 557.93 ± 0.9% | 4130.45 ± 0.7% | 232.44 ± 0.7% | 1.00 | 1.00 | 3.02 | 1.25 |
| literal: a word | 7 | 719.76 ± 0.4% | 769.67 ± 0.5% | 1382.12 ± 2.5% | 512.98 ± 0.4% | 604.22 ± 3.6% | 1116.40 ± 0.5% | 28414.77 ± 1.4% | 720.30 ± 0.4% | 0.94 | 1.00 | 1.40 | 1.19 |
| literal: a word that is not there | 8 | 690.84 ± 1.1% | 742.00 ± 0.9% | 1300.05 ± 1.2% | 475.50 ± 0.4% | 581.33 ± 2.2% | 1049.22 ± 0.6% | 27429.21 ± 1.4% | 689.98 ± 0.7% | 0.93 | 1.00 | 1.45 | 1.19 |
| literal: one of four words | 26 | 269.19 ± 1.0% | 461.56 ± 0.6% | 639.26 ± 0.8% | 37.96 ± 0.4% | 226.71 ± 2.5% | 405.21 ± 1.2% | 15745.72 ± 1.8% | 269.51 ± 0.5% | 0.58 | 1.00 | 7.09 | 1.19 |
| literal: a word in any case | 11 | 536.54 ± 0.5% | 577.05 ± 0.3% | 860.13 ± 0.4% | 12.76 ± 0.5% | 629.49 ± 3.5% | refused | 21604.63 ± 2.0% | 537.67 ± 0.4% | 0.93 | 1.00 | 42.04 | 0.85 |
| literal: an href attribute | 12 | 371.99 ± 0.5% | 381.82 ± 2.4% | 502.38 ± 1.2% | 37.62 ± 1.1% | 460.58 ± 0.6% | 916.98 ± 1.5% | 19447.20 ± 1.5% | 371.39 ± 1.0% | 0.97 | 1.00 | 9.89 | 0.81 |
| literal: a word, second text | 10 | 639.04 ± 1.5% | 703.20 ± 0.9% | 1179.23 ± 1.1% | 430.58 ± 1.1% | 503.80 ± 14.2% | 945.04 ± 1.6% | 25406.58 ± 1.2% | 638.03 ± 0.8% | 0.91 | 1.00 | 1.48 | 1.27 |
| class: two capitalized words | 23 | 526.49 ± 0.9% | 565.98 ± 0.4% | 841.41 ± 0.5% | 101.23 ± 1.1% | 468.87 ± 2.6% | 859.27 ± 1.5% | 5934.34 ± 2.9% | 524.50 ± 2.4% | 0.93 | 1.00 | 5.20 | 1.12 |
| class: a word that ends in ing | 9 | 623.08 ± 1.7% | 709.36 ± 0.7% | 1234.89 ± 1.7% | 131.92 ± 1.4% | 690.69 ± 1.0% | 1322.39 ± 0.2% | 14944.61 ± 1.2% | 624.22 ± 6.2% | 0.88 | 1.00 | 4.72 | 0.90 |
| class: a word in capitals | 16 | 569.22 ± 12.0% | 620.66 ± 1.2% | 1024.10 ± 0.5% | 136.49 ± 0.8% | 696.64 ± 1.6% | 1209.92 ± 1.2% | 7894.21 ± 0.4% | 569.95 ± 0.8% | 0.92 | 1.00 | 4.17 | 0.82 |
| class: a number | 6 | 684.66 ± 0.3% | 766.96 ± 1.0% | 1420.84 ± 0.4% | 33.16 ± 1.5% | 1258.40 ± 3.9% | 2255.54 ± 3.0% | 22108.97 ± 1.5% | 684.68 ± 1.7% | 0.89 | 1.00 | 20.65 | 0.54 |
| class: two capitalized words, second text | 23 | 527.25 ± 0.7% | 567.35 ± 0.5% | 841.39 ± 1.1% | 101.96 ± 1.1% | 473.56 ± 1.6% | 871.23 ± 1.2% | 5936.04 ± 0.7% | 527.51 ± 0.7% | 0.93 | 1.00 | 5.17 | 1.11 |
| other: a word between two words | 13 | 617.47 ± 0.6% | 638.14 ± 4.0% | 1019.98 ± 0.9% | 134.18 ± 1.2% | 462.71 ± 1.4% | 952.95 ± 0.5% | 13244.18 ± 0.7% | 618.53 ± 1.1% | 0.97 | 1.00 | 4.60 | 1.33 |
| other: a number before a unit, second text | 15 | 439.52 ± 0.8% | 486.05 ± 1.1% | 675.98 ± 0.2% | 31.69 ± 0.7% | 584.67 ± 1.6% | 1048.25 ± 3.7% | 14298.44 ± 0.8% | 438.75 ± 1.8% | 0.90 | 1.00 | 13.87 | 0.75 |
| other: a heading's start tag | 13 | 382.49 ± 0.6% | 388.75 ± 2.1% | 510.26 ± 0.9% | 36.79 ± 0.8% | 566.21 ± 1.1% | 1016.35 ± 1.0% | 16634.36 ± 1.6% | 383.62 ± 0.4% | 0.98 | 1.00 | 10.40 | 0.68 |
| other: a whole word | 11 | 650.51 ± 0.8% | 690.22 ± 0.6% | 1144.29 ± 0.9% | 116.59 ± 5.1% | 536.42 ± 6.6% | 973.05 ± 5.4% | 24040.65 ± 2.5% | 650.51 ± 5.5% | 0.94 | 1.00 | 5.58 | 1.21 |
| other: a line's first word, second text | 17 | 591.12 ± 5.8% | 622.75 ± 4.8% | 994.01 ± 0.5% | 132.21 ± 1.6% | 640.64 ± 1.0% | refused | refused | 590.50 ± 3.3% | 0.95 | 1.00 | 4.47 | 0.92 |
| other: fourteen octets before an x | 16 | 105.03 ± 0.6% | 149.33 ± 1.0% | 178.87 ± 0.6% | 14.22 ± 0.7% | 415.94 ± 2.5% | 462.19 ± 1.0% | 12146.48 ± 2.1% | 104.89 ± 0.2% | 0.70 | 1.00 | 7.38 | 0.25 |
| other: a Greek word | 8 | 453.08 ± 1.3% | 622.61 ± 1.2% | 1001.70 ± 0.3% | 46.86 ± 0.7% | 1258.82 ± 3.0% | 2189.25 ± 0.8% | refused | 452.66 ± 0.5% | 0.73 | 1.00 | 9.67 | 0.36 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 16734.46 ± 2.1% | not timed | not timed | 19882.65 ± 2.3% | 1941.71 ± 18.8% | not timed | not timed | 16789.41 ± 0.6% | | 1.00 | 0.84 | 8.62 |
| 01-literal/sherlock-casei-en | 522 | 6040.25 ± 2.3% | not timed | not timed | 6427.66 ± 1.9% | 29.22 ± 0.9% | not timed | not timed | 6025.81 ± 2.2% | | 1.00 | 0.94 | 206.69 |
| 01-literal/sherlock-ru | 724 | 17275.14 ± 2.4% | not timed | not timed | 19796.23 ± 1.3% | 1086.44 ± 4.0% | not timed | not timed | 17263.48 ± 1.1% | | 1.00 | 0.87 | 15.90 |
| 01-literal/sherlock-casei-ru | 746 | 6624.29 ± 0.4% | not timed | not timed | 5150.37 ± 1.1% | 31.26 ± 2.0% | not timed | not timed | 6593.63 ± 0.6% | | 1.00 | 1.29 | 211.93 |
| 01-literal/sherlock-zh | 30 | 26150.56 ± 0.2% | not timed | not timed | 24325.37 ± 0.2% | 1222.32 ± 1.2% | not timed | not timed | 26176.99 ± 1.2% | | 1.00 | 1.08 | 21.39 |
| 02-literal-alternate/sherlock-en | 714 | 8814.86 ± 0.7% | not timed | not timed | 7129.30 ± 0.8% | 17.22 ± 9.7% | not timed | not timed | 8825.32 ± 1.1% | | 1.00 | 1.24 | 512.03 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1598.91 ± 1.1% | not timed | not timed | 1853.77 ± 0.6% | 10.10 ± 1.2% | not timed | not timed | 1579.56 ± 1.0% | | 1.01 | 0.86 | 158.26 |
| 02-literal-alternate/sherlock-ru | 899 | 5632.08 ± 0.5% | not timed | not timed | 3932.87 ± 4.0% | 22.42 ± 0.7% | not timed | not timed | 5561.31 ± 0.6% | | 1.01 | 1.43 | 251.19 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1693.80 ± 1.7% | not timed | not timed | 957.69 ± 0.7% | 8.49 ± 0.9% | not timed | not timed | 1679.00 ± 3.2% | | 1.01 | 1.77 | 199.61 |
| 02-literal-alternate/sherlock-zh | 207 | 12229.25 ± 0.5% | not timed | not timed | 8293.22 ± 0.2% | 32.01 ± 1.2% | not timed | not timed | 12239.58 ± 0.4% | | 1.00 | 1.47 | 382.10 |
| 03-date/ascii | 111817 | 97.43 ± 0.4% | not timed | not timed | 85.04 ± 0.9% | 0.19 ± 3.9% | not timed | not timed | 97.32 ± 1.1% | | 1.00 | 1.15 | 503.81 |
| 04-ruff-noqa/real | 84 | 576.48 ± 0.4% | not timed | not timed | 437.87 ± 3.7% | 19.19 ± 0.3% | not timed | not timed | 576.00 ± 1.0% | | 1.00 | 1.32 | 30.04 |
| 04-ruff-noqa/tweaked | 44 | 483.97 ± 0.5% | not timed | not timed | 437.85 ± 1.3% | 307.94 ± 12.3% | not timed | not timed | 483.04 ± 0.7% | | 1.00 | 1.11 | 1.57 |
| 05-lexer-veryl/single | 124800 | 3.55 ± 0.9% | not timed | not timed | 4.39 ± 0.4% | 0.20 ± 2.7% | not timed | not timed | 3.56 ± 1.0% | | 1.00 | 0.81 | 17.75 |
| 06-cloud-flare-redos/original | 107 | 209.51 ± 0.5% | not timed | not timed | 195.72 ± 0.5% | 24.06 ± 1.9% | not timed | not timed | 209.31 ± 0.7% | | 1.00 | 1.07 | 8.71 |
| 06-cloud-flare-redos/simplified-short | 102 | 203.41 ± 1.5% | not timed | not timed | 174.14 ± 2.6% | 25.30 ± 2.3% | not timed | not timed | 204.17 ± 0.8% | | 1.00 | 1.17 | 8.04 |
| 06-cloud-flare-redos/simplified-long | 10000 | 209.00 ± 2.8% | not timed | not timed | 209.23 ± 1.6% | 27.94 ± 5.3% | not timed | not timed | 209.40 ± 2.8% | | 1.00 | 1.00 | 7.48 |
| 07-unicode-character-data/parse-line | 558784 | 215.38 ± 2.4% | not timed | not timed | 163.31 ± 1.9% | 37.69 ± 7.9% | not timed | not timed | 213.00 ± 1.8% | | 1.01 | 1.32 | 5.72 |
| 08-words/all-english | 56691 | 87.31 ± 0.4% | not timed | not timed | 72.23 ± 0.9% | 10.67 ± 11.3% | not timed | not timed | 86.89 ± 0.6% | | 1.00 | 1.21 | 8.18 |
| 08-words/long-english | 839 | 807.10 ± 0.2% | not timed | not timed | 480.91 ± 0.6% | 28.58 ± 1.2% | not timed | not timed | 806.46 ± 0.6% | | 1.00 | 1.68 | 28.24 |
| 09-aws-keys/full | 0 | 442.51 ± 0.8% | not timed | not timed | 449.74 ± 5.5% | 59.91 ± 1.4% | not timed | not timed | 443.00 ± 0.5% | | 1.00 | 0.98 | 7.39 |
| 09-aws-keys/quick | 0 | 851.63 ± 4.8% | not timed | not timed | 725.60 ± 2.5% | 350.12 ± 0.3% | not timed | not timed | 851.43 ± 2.2% | | 1.00 | 1.17 | 2.43 |
| 10-bounded-repeat/letters-en | 1833 | 499.53 ± 0.9% | not timed | not timed | 432.14 ± 3.0% | 18.72 ± 1.2% | not timed | not timed | 497.03 ± 1.0% | | 1.01 | 1.16 | 26.68 |
| 10-bounded-repeat/letters-ru | 3475 | 303.79 ± 0.5% | not timed | not timed | 389.68 ± 2.9% | 20.49 ± 6.2% | not timed | not timed | 301.37 ± 1.2% | | 1.01 | 0.78 | 14.83 |
| 10-bounded-repeat/context | 53 | 70.34 ± 0.9% | not timed | not timed | 58.44 ± 0.2% | 18.61 ± 0.5% | not timed | not timed | 70.44 ± 1.5% | | 1.00 | 1.20 | 3.78 |
| 10-bounded-repeat/capitals | 11 | 842.24 ± 0.2% | not timed | not timed | 494.67 ± 0.2% | 34.33 ± 0.8% | not timed | not timed | 840.34 ± 0.4% | | 1.00 | 1.70 | 24.53 |
| 11-unstructured-to-json/extract | 600 | 37.47 ± 1.5% | not timed | not timed | 62.30 ± 1.0% | 48.27 ± 1.2% | not timed | not timed | 37.57 ± 1.0% | | 1.00 | 0.60 | 0.78 |
| 12-dictionary/single | 1 | 440.38 ± 0.5% | not timed | not timed | 423.31 ± 0.3% | 0.36 ± 0.9% | not timed | not timed | 444.16 ± 0.9% | | 0.99 | 1.04 | 1223.86 |
| 14-quadratic/1x | 100 | 10.82 ± 0.8% | not timed | not timed | 10.61 ± 0.6% | 0.95 ± 4.3% | not timed | not timed | 10.76 ± 1.0% | | 1.01 | 1.02 | 11.42 |
| 14-quadratic/2x | 200 | 6.53 ± 0.4% | not timed | not timed | 5.16 ± 0.5% | 0.53 ± 6.2% | not timed | not timed | 6.53 ± 1.0% | | 1.00 | 1.26 | 12.39 |
| 14-quadratic/10x | 1000 | 1.49 ± 0.6% | not timed | not timed | 1.00 ± 1.4% | 0.12 ± 0.9% | not timed | not timed | 1.49 ± 1.5% | | 1.00 | 1.49 | 12.89 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.55 ± 1.0% | not timed | not timed | 0.33 ± 0.6% | 0.50 ± 3.1% | not timed | not timed | 1.54 ± 1.5% | | 1.01 | 4.66 | 3.09 |
| 04-ruff-noqa/compile-real | 1 | 94.49 ± 0.3% | not timed | not timed | 11.78 ± 0.7% | 130.07 ± 3.9% | not timed | not timed | 93.73 ± 0.7% | | 1.01 | 8.02 | 0.73 |
| 05-lexer-veryl/compile-single | 1 | 16.25 ± 0.8% | not timed | not timed | 2.22 ± 3.6% | 5.89 ± 2.6% | not timed | not timed | 16.01 ± 1.1% | | 1.02 | 7.32 | 2.76 |
| 07-unicode-character-data/compile | 1 | 58.76 ± 1.5% | not timed | not timed | 24.19 ± 1.0% | 33.07 ± 1.8% | not timed | not timed | 58.41 ± 1.4% | | 1.01 | 2.43 | 1.78 |
| 09-aws-keys/compile-full | 1 | 39.14 ± 0.6% | not timed | not timed | 6.75 ± 1.1% | 21.30 ± 5.8% | not timed | not timed | 38.86 ± 1.7% | | 1.01 | 5.80 | 1.84 |
| 09-aws-keys/compile-quick | 1 | 183.82 ± 0.5% | not timed | not timed | 45.89 ± 1.0% | 122.76 ± 7.8% | not timed | not timed | 183.85 ± 1.5% | | 1.00 | 4.01 | 1.50 |
| 10-bounded-repeat/compile-context | 1 | 11.84 ± 1.5% | not timed | not timed | 10.58 ± 0.6% | 15.71 ± 14.2% | not timed | not timed | 11.80 ± 1.1% | | 1.00 | 1.12 | 0.75 |
| 10-bounded-repeat/compile-capitals | 1 | 72.80 ± 1.1% | not timed | not timed | 7.97 ± 0.7% | 22.82 ± 3.9% | not timed | not timed | 70.35 ± 7.6% | | 1.03 | 9.13 | 3.19 |
| 11-unstructured-to-json/compile | 1 | 89.63 ± 11.6% | not timed | not timed | 37.41 ± 0.8% | 62.83 ± 2.8% | not timed | not timed | 87.93 ± 1.2% | | 1.02 | 2.40 | 1.43 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.3% | not timed | not timed | 0.06 ± 1.0% | 0.09 ± 16.9% | not timed | not timed | 0.28 ± 2.3% | | 1.01 | 4.81 | 3.17 |

