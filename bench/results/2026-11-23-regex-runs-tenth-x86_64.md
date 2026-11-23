# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
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
| literal: a word | 217 | 40633.35 ± 0.8% | 1034.06 ± 0.5% | 29.98 ± 0.9% | 38689.84 ± 3.1% | 12274.40 ± 3.2% | 12.91 ± 0.2% | 104.44 ± 0.3% | 40674.78 ± 5.9% | 39.30 | 1.00 | 1.05 | 3.31 |
| literal: a word that is not there | 0 | 56681.05 ± 4.6% | 1044.36 ± 0.2% | 30.02 ± 0.3% | 45496.09 ± 0.1% | 44042.07 ± 5.5% | 12.79 ± 0.1% | 98.59 ± 0.5% | 56830.94 ± 0.3% | 54.27 | 1.00 | 1.25 | 1.29 |
| literal: one of four words | 661 | 14134.50 ± 0.3% | 1014.17 ± 0.1% | 16.85 ± 1.3% | 11139.84 ± 0.4% | 24.96 ± 0.2% | 4.46 ± 0.1% | 8.25 ± 0.8% | 14147.13 ± 0.6% | 13.94 | 1.00 | 1.27 | 566.35 |
| literal: a word in any case | 217 | 36413.90 ± 0.5% | 1032.49 ± 0.2% | 22.88 ± 0.3% | 11294.80 ± 0.1% | 47.20 ± 0.6% | refused | differs | 36439.97 ± 0.6% | 35.27 | 1.00 | 3.22 | 771.50 |
| literal: an href attribute | 33 | 35390.61 ± 4.7% | 1039.87 ± 0.1% | 29.03 ± 0.2% | 34838.66 ± 1.0% | 2924.53 ± 12.1% | 9.67 ± 0.2% | 91.54 ± 0.4% | 35437.25 ± 15.9% | 34.03 | 1.00 | 1.02 | 12.10 |
| literal: a word, second text | 123 | 44384.24 ± 0.3% | 1035.21 ± 0.5% | 29.70 ± 0.6% | 39471.77 ± 1.9% | 10590.14 ± 8.2% | 14.49 ± 0.4% | 88.15 ± 0.9% | 44230.32 ± 0.5% | 42.87 | 1.00 | 1.12 | 4.19 |
| class: two capitalized words | 1331 | 918.56 ± 0.4% | 962.89 ± 0.1% | 28.06 ± 0.4% | 576.02 ± 0.8% | 44.04 ± 10.2% | 11.08 ± 0.4% | 80.04 ± 0.4% | 919.47 ± 0.6% | 0.95 | 1.00 | 1.59 | 20.86 |
| class: a word that ends in ing | 3399 | 885.92 ± 0.1% | 884.70 ± 0.3% | 20.07 ± 0.5% | 540.61 ± 0.4% | 32.86 ± 2.0% | 6.24 ± 0.1% | 20.35 ± 1.8% | 882.27 ± 0.3% | 1.00 | 1.00 | 1.64 | 26.96 |
| class: a word in capitals | 2332 | 1157.43 ± 0.2% | 941.67 ± 0.2% | 29.41 ± 5.2% | 566.90 ± 0.4% | 47.91 ± 0.7% | 12.52 ± 0.3% | 100.85 ± 0.8% | 1157.05 ± 0.3% | 1.23 | 1.00 | 2.04 | 24.16 |
| class: a number | 8288 | 1700.33 ± 0.2% | 814.09 ± 0.2% | 29.61 ± 5.9% | 1804.99 ± 0.7% | 44.95 ± 12.9% | 0.39 ± 0.3% | 72.45 ± 0.5% | 1708.40 ± 0.4% | 2.09 | 1.00 | 0.94 | 37.82 |
| class: two capitalized words, second text | 5359 | 712.13 ± 0.2% | 723.50 ± 0.2% | 25.72 ± 0.5% | 477.04 ± 0.8% | 37.42 ± 14.3% | 12.78 ± 0.2% | 74.12 ± 6.2% | 723.62 ± 11.8% | 0.98 | 0.98 | 1.49 | 19.03 |
| other: a word between two words | 6104 | 839.03 ± 0.6% | 752.87 ± 0.6% | 25.31 ± 17.1% | 814.07 ± 8.0% | 123.53 ± 68.5% | 8.55 ± 0.5% | 81.48 ± 0.4% | 837.49 ± 0.3% | 1.11 | 1.00 | 1.03 | 6.79 |
| other: a number before a unit, second text | 1481 | 9829.82 ± 0.5% | 991.59 ± 0.2% | 28.17 ± 6.2% | 8056.61 ± 0.3% | 44.92 ± 6.4% | 13.34 ± 0.1% | 78.93 ± 0.5% | 9862.92 ± 0.3% | 9.91 | 1.00 | 1.22 | 218.83 |
| other: a heading's start tag | 110 | 24446.10 ± 3.8% | 1031.15 ± 0.2% | 28.60 ± 0.4% | 2574.31 ± 2.0% | 2003.54 ± 11.5% | 11.84 ± 0.4% | 107.29 ± 0.8% | 24528.45 ± 0.3% | 23.71 | 1.00 | 9.50 | 12.20 |
| other: a whole word | 217 | 29148.05 ± 0.6% | 1033.36 ± 0.5% | 30.12 ± 6.8% | 28352.70 ± 0.4% | 54.39 ± 0.6% | 11.19 ± 1.0% | 63.06 ± 6.2% | 29127.06 ± 0.4% | 28.21 | 1.00 | 1.03 | 535.89 |
| other: a line's first word, second text | 3716 | 2579.55 ± 6.9% | 862.11 ± 0.2% | 32.10 ± 1.0% | 2322.14 ± 1.6% | 71.12 ± 10.9% | refused | refused | 2546.41 ± 1.1% | 2.99 | 1.01 | 1.11 | 36.27 |
| other: fourteen octets before an x | 87 | 35580.28 ± 0.2% | 250.38 ± 0.8% | 7.68 ± 5.8% | 3546.92 ± 0.5% | 11.58 ± 1.1% | differs | 20.80 ± 2.3% | 35932.13 ± 0.2% | 142.11 | 0.99 | 10.03 | 3073.37 |
| other: a Greek word | 21815 | 480.48 ± 0.3% | 402.11 ± 0.1% | 33.74 ± 0.2% | 301.67 ± 0.2% | 57.37 ± 10.0% | differs | refused | 478.80 ± 0.2% | 1.19 | 1.00 | 1.59 | 8.38 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.16 ± 1.5% | 29.07 ± 1.7% | 1.04 ± 0.7% | 19.90 ± 0.2% | 2.66 ± 1.9% | differs | 4.31 ± 1.8% | 27.22 ± 0.5% | 1.00 | 1.07 | 1.47 | 10.98 |
| a UUID | 32895 | 24.13 ± 0.3% | 24.15 ± 0.1% | 0.73 ± 0.3% | 15.11 ± 0.6% | 3.03 ± 3.6% | 0.52 ± 0.2% | 3.90 ± 2.7% | 24.08 ± 4.4% | 1.00 | 1.00 | 1.60 | 7.95 |
| an IPv4 address | 33176 | 39.63 ± 0.7% | 39.40 ± 0.6% | 2.34 ± 8.3% | 28.51 ± 0.3% | 6.94 ± 1.9% | differs | 4.24 ± 0.9% | 39.98 ± 0.7% | 1.01 | 0.99 | 1.39 | 5.71 |
| a date and time | 32954 | 35.97 ± 0.5% | 35.88 ± 0.3% | 1.74 ± 1.3% | 21.68 ± 2.2% | 8.05 ± 5.4% | 0.91 ± 0.4% | 7.69 ± 2.9% | 35.94 ± 0.3% | 1.00 | 1.00 | 1.66 | 4.47 |
| a field path | 32606 | 32.48 ± 0.7% | 32.22 ± 0.7% | 1.15 ± 2.6% | 23.03 ± 0.3% | 3.52 ± 9.2% | differs | 2.98 ± 1.2% | 32.39 ± 9.2% | 1.01 | 1.00 | 1.41 | 9.22 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.90 ± 0.2% | 11.00 ± 0.4% | 10.99 ± 0.3% | 13.25 ± 1.0% | 5.90 ± 2.2% | 0.74 ± 0.7% | none | 11.01 ± 0.4% | 0.99 | 0.99 | 0.82 | 1.85 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 238.74 ± 0.3% | 240.70 ± 0.2% | 283.48 ± 0.5% | 101.03 ± 2.3% | 243.96 ± 15.2% | 699.45 ± 3.7% | 4702.55 ± 0.7% | 238.55 ± 0.3% | 0.99 | 1.00 | 2.36 | 0.98 |
| a UUID | 62 | 154.85 ± 0.3% | 155.03 ± 0.5% | 173.66 ± 0.9% | 58.19 ± 1.2% | 119.15 ± 1.7% | 255.74 ± 2.3% | 5396.10 ± 1.2% | 154.50 ± 0.5% | 1.00 | 1.00 | 2.66 | 1.30 |
| an IPv4 address | 29 | 491.45 ± 0.1% | 497.47 ± 1.0% | 735.49 ± 0.6% | 88.24 ± 0.4% | 148.59 ± 3.2% | 401.67 ± 6.0% | 8978.60 ± 6.5% | 490.96 ± 2.7% | 0.99 | 1.00 | 5.57 | 3.31 |
| a date and time | 56 | 365.96 ± 0.2% | 367.41 ± 0.2% | 476.63 ± 2.1% | 87.17 ± 0.7% | 158.53 ± 1.9% | 472.05 ± 3.4% | 5568.21 ± 0.4% | 366.00 ± 17.0% | 1.00 | 1.00 | 4.20 | 2.31 |
| a field path | 39 | 228.25 ± 0.2% | 229.19 ± 5.7% | 267.96 ± 3.4% | 96.56 ± 2.8% | 228.58 ± 3.0% | 728.18 ± 1.3% | 5623.90 ± 8.5% | 228.20 ± 2.3% | 1.00 | 1.00 | 2.36 | 1.00 |
| literal: a word | 7 | 735.08 ± 0.3% | 778.87 ± 5.5% | 1494.18 ± 0.2% | 657.54 ± 8.8% | 752.70 ± 25.2% | 1580.87 ± 1.7% | 34163.96 ± 1.0% | 735.49 ± 9.0% | 0.94 | 1.00 | 1.12 | 0.98 |
| literal: a word that is not there | 8 | 711.92 ± 0.8% | 757.42 ± 18.6% | 1415.21 ± 0.5% | 601.27 ± 1.3% | 759.90 ± 1.7% | 1490.09 ± 1.2% | 33468.64 ± 0.9% | 712.20 ± 0.1% | 0.94 | 1.00 | 1.18 | 0.94 |
| literal: one of four words | 26 | 267.45 ± 0.3% | 459.91 ± 0.4% | 644.61 ± 3.3% | 54.09 ± 1.9% | 294.54 ± 2.2% | 598.20 ± 3.4% | 18351.60 ± 0.5% | 267.21 ± 0.3% | 0.58 | 1.00 | 4.94 | 0.91 |
| literal: a word in any case | 11 | 580.46 ± 1.0% | 615.85 ± 0.2% | 996.23 ± 0.8% | 18.94 ± 1.2% | 831.28 ± 1.3% | refused | 24803.97 ± 1.6% | 577.04 ± 0.6% | 0.94 | 1.01 | 30.65 | 0.70 |
| literal: an href attribute | 12 | 398.53 ± 0.2% | 412.15 ± 0.3% | 564.70 ± 0.5% | 50.64 ± 1.2% | 578.59 ± 5.5% | 1278.86 ± 1.4% | 24631.26 ± 0.8% | 398.29 ± 5.4% | 0.97 | 1.00 | 7.87 | 0.69 |
| literal: a word, second text | 10 | 661.50 ± 0.5% | 713.03 ± 0.4% | 1268.79 ± 0.7% | 540.78 ± 4.7% | 665.77 ± 2.3% | 1349.31 ± 1.7% | 32113.79 ± 0.2% | 660.62 ± 0.3% | 0.93 | 1.00 | 1.22 | 0.99 |
| class: two capitalized words | 23 | 518.24 ± 0.4% | 564.14 ± 0.3% | 856.06 ± 0.3% | 123.23 ± 0.5% | 603.45 ± 1.3% | 1253.01 ± 0.7% | 7848.69 ± 0.5% | 518.02 ± 2.1% | 0.92 | 1.00 | 4.21 | 0.86 |
| class: a word that ends in ing | 9 | 624.80 ± 0.2% | 710.09 ± 0.3% | 1348.63 ± 0.5% | 153.08 ± 1.1% | 863.26 ± 0.9% | 1854.58 ± 2.7% | 19291.70 ± 0.4% | 623.72 ± 5.0% | 0.88 | 1.00 | 4.08 | 0.72 |
| class: a word in capitals | 16 | 561.52 ± 7.3% | 615.37 ± 0.2% | 1057.30 ± 0.2% | 157.97 ± 1.2% | 897.82 ± 3.1% | 1714.88 ± 2.2% | 10582.76 ± 10.6% | 562.55 ± 11.7% | 0.91 | 1.00 | 3.55 | 0.63 |
| class: a number | 6 | 687.81 ± 0.3% | 767.61 ± 0.5% | 1541.94 ± 0.2% | 47.19 ± 1.8% | 1646.39 ± 1.7% | 2885.53 ± 8.7% | 25892.87 ± 1.6% | 687.77 ± 7.2% | 0.90 | 1.00 | 14.58 | 0.42 |
| class: two capitalized words, second text | 23 | 517.94 ± 0.2% | 562.83 ± 0.4% | 856.73 ± 0.2% | 120.22 ± 0.7% | 603.41 ± 1.7% | 1250.08 ± 5.0% | 7802.58 ± 0.9% | 517.78 ± 0.3% | 0.92 | 1.00 | 4.31 | 0.86 |
| other: a word between two words | 13 | 636.63 ± 3.4% | 659.71 ± 0.2% | 1098.06 ± 0.3% | 157.90 ± 0.6% | 582.42 ± 0.7% | 1331.65 ± 1.0% | 17798.19 ± 17.7% | 636.83 ± 0.2% | 0.97 | 1.00 | 4.03 | 1.09 |
| other: a number before a unit, second text | 15 | 436.34 ± 0.1% | 487.35 ± 0.3% | 693.30 ± 0.3% | 44.69 ± 1.8% | 724.45 ± 28.8% | 1432.02 ± 1.7% | 17727.88 ± 0.7% | 435.85 ± 8.8% | 0.90 | 1.00 | 9.76 | 0.60 |
| other: a heading's start tag | 13 | 411.96 ± 0.9% | 419.66 ± 1.6% | 575.93 ± 0.2% | 47.87 ± 0.6% | 717.05 ± 1.9% | 1342.23 ± 0.5% | 20083.97 ± 3.2% | 411.70 ± 0.1% | 0.98 | 1.00 | 8.61 | 0.57 |
| other: a whole word | 11 | 657.06 ± 0.5% | 695.24 ± 0.3% | 1202.36 ± 0.7% | 142.88 ± 0.8% | 688.24 ± 1.1% | 1361.51 ± 1.3% | 31643.56 ± 0.8% | 652.91 ± 0.8% | 0.95 | 1.01 | 4.60 | 0.95 |
| other: a line's first word, second text | 17 | 610.09 ± 2.9% | 643.03 ± 0.2% | 1101.26 ± 0.3% | 149.59 ± 0.4% | 808.39 ± 0.9% | refused | refused | 609.17 ± 0.5% | 0.95 | 1.00 | 4.08 | 0.75 |
| other: fourteen octets before an x | 16 | 116.41 ± 1.4% | 172.93 ± 0.9% | 207.97 ± 1.1% | 17.96 ± 0.2% | 526.42 ± 13.9% | 563.33 ± 4.2% | 15767.86 ± 4.7% | 117.03 ± 1.4% | 0.67 | 0.99 | 6.48 | 0.22 |
| other: a Greek word | 8 | 428.18 ± 0.6% | 604.92 ± 0.6% | 1003.25 ± 9.0% | 61.68 ± 0.8% | 1627.71 ± 17.6% | 2656.70 ± 0.6% | refused | 427.51 ± 0.3% | 0.71 | 1.00 | 6.94 | 0.26 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 29351.23 ± 0.3% | not timed | not timed | 33574.62 ± 1.6% | 2832.36 ± 2.8% | not timed | not timed | 29305.92 ± 0.5% | | 1.00 | 0.87 | 10.36 |
| 01-literal/sherlock-casei-en | 522 | 8440.81 ± 1.0% | not timed | not timed | 9032.48 ± 0.2% | 34.16 ± 0.9% | not timed | not timed | 8404.93 ± 0.6% | | 1.00 | 0.93 | 247.07 |
| 01-literal/sherlock-ru | 724 | 30704.66 ± 5.7% | not timed | not timed | 34424.79 ± 5.0% | 1295.29 ± 3.3% | not timed | not timed | 30709.37 ± 5.8% | | 1.00 | 0.89 | 23.70 |
| 01-literal/sherlock-casei-ru | 746 | 8871.42 ± 0.4% | not timed | not timed | 7759.84 ± 0.6% | 37.71 ± 4.6% | not timed | not timed | 8818.53 ± 0.7% | | 1.01 | 1.14 | 235.28 |
| 01-literal/sherlock-zh | 30 | 53645.83 ± 0.7% | not timed | not timed | 43129.42 ± 4.7% | 1643.26 ± 4.4% | not timed | not timed | 53428.27 ± 0.3% | | 1.00 | 1.24 | 32.65 |
| 02-literal-alternate/sherlock-en | 714 | 12885.54 ± 0.5% | not timed | not timed | 10930.58 ± 0.6% | 19.13 ± 0.3% | not timed | not timed | 12886.96 ± 0.2% | | 1.00 | 1.18 | 673.45 |
| 02-literal-alternate/sherlock-casei-en | 725 | 4196.82 ± 8.7% | not timed | not timed | 2302.50 ± 0.7% | 12.26 ± 7.0% | not timed | not timed | 3835.46 ± 0.7% | | 1.09 | 1.82 | 342.29 |
| 02-literal-alternate/sherlock-ru | 899 | 7481.36 ± 0.7% | not timed | not timed | 9776.97 ± 0.6% | 25.35 ± 0.9% | not timed | not timed | 7448.43 ± 10.9% | | 1.00 | 0.77 | 295.13 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2142.24 ± 4.0% | not timed | not timed | 1190.98 ± 0.4% | 10.58 ± 0.9% | not timed | not timed | 2130.11 ± 2.0% | | 1.01 | 1.80 | 202.44 |
| 02-literal-alternate/sherlock-zh | 207 | 18597.35 ± 1.1% | not timed | not timed | 12661.19 ± 0.3% | 35.68 ± 0.6% | not timed | not timed | 18625.73 ± 0.3% | | 1.00 | 1.47 | 521.28 |
| 03-date/ascii | 111817 | 131.09 ± 0.3% | not timed | not timed | 100.27 ± 0.8% | 0.23 ± 4.9% | not timed | not timed | 130.95 ± 0.5% | | 1.00 | 1.31 | 560.60 |
| 04-ruff-noqa/real | 84 | 697.65 ± 0.1% | not timed | not timed | 500.02 ± 0.5% | 17.00 ± 1.8% | not timed | not timed | 698.81 ± 0.4% | | 1.00 | 1.40 | 41.03 |
| 04-ruff-noqa/tweaked | 44 | 588.90 ± 1.0% | not timed | not timed | 510.21 ± 0.9% | 365.05 ± 0.6% | not timed | not timed | 590.35 ± 0.4% | | 1.00 | 1.15 | 1.61 |
| 05-lexer-veryl/single | 124800 | 4.01 ± 0.7% | not timed | not timed | 5.26 ± 2.2% | 0.25 ± 4.5% | not timed | not timed | 4.01 ± 1.4% | | 1.00 | 0.76 | 15.90 |
| 06-cloud-flare-redos/original | 107 | 268.55 ± 0.8% | not timed | not timed | 227.83 ± 1.3% | 25.81 ± 0.4% | not timed | not timed | 269.02 ± 0.3% | | 1.00 | 1.18 | 10.40 |
| 06-cloud-flare-redos/simplified-short | 102 | 265.55 ± 0.3% | not timed | not timed | 236.08 ± 0.4% | 27.70 ± 1.9% | not timed | not timed | 264.52 ± 0.3% | | 1.00 | 1.12 | 9.59 |
| 06-cloud-flare-redos/simplified-long | 10000 | 280.83 ± 0.3% | not timed | not timed | 259.52 ± 0.3% | 29.74 ± 2.0% | not timed | not timed | 280.78 ± 0.4% | | 1.00 | 1.08 | 9.44 |
| 07-unicode-character-data/parse-line | 558784 | 239.27 ± 2.7% | not timed | not timed | 201.65 ± 0.2% | 48.22 ± 3.9% | not timed | not timed | 242.13 ± 1.7% | | 0.99 | 1.19 | 4.96 |
| 08-words/all-english | 56691 | 110.93 ± 7.0% | not timed | not timed | 84.72 ± 11.3% | 13.83 ± 12.3% | not timed | not timed | 111.96 ± 0.7% | | 0.99 | 1.31 | 8.02 |
| 08-words/long-english | 839 | 989.14 ± 0.3% | not timed | not timed | 585.16 ± 0.1% | 35.15 ± 0.9% | not timed | not timed | 987.72 ± 0.8% | | 1.00 | 1.69 | 28.14 |
| 09-aws-keys/full | 0 | 517.08 ± 0.2% | not timed | not timed | 540.18 ± 0.4% | 67.36 ± 3.9% | not timed | not timed | 517.22 ± 0.2% | | 1.00 | 0.96 | 7.68 |
| 09-aws-keys/quick | 0 | 981.23 ± 5.6% | not timed | not timed | 958.68 ± 2.4% | 415.54 ± 1.4% | not timed | not timed | 984.63 ± 0.7% | | 1.00 | 1.02 | 2.36 |
| 10-bounded-repeat/letters-en | 1833 | 672.39 ± 1.1% | not timed | not timed | 554.45 ± 1.0% | 22.72 ± 0.6% | not timed | not timed | 666.98 ± 2.0% | | 1.01 | 1.21 | 29.59 |
| 10-bounded-repeat/letters-ru | 3475 | 370.21 ± 1.0% | not timed | not timed | 474.28 ± 0.3% | 24.31 ± 18.6% | not timed | not timed | 369.70 ± 0.4% | | 1.00 | 0.78 | 15.23 |
| 10-bounded-repeat/context | 53 | 79.10 ± 1.1% | not timed | not timed | 71.10 ± 7.3% | 22.60 ± 4.7% | not timed | not timed | 79.22 ± 1.4% | | 1.00 | 1.11 | 3.50 |
| 10-bounded-repeat/capitals | 11 | 1033.74 ± 0.2% | not timed | not timed | 604.32 ± 0.1% | 39.94 ± 4.2% | not timed | not timed | 1031.91 ± 0.2% | | 1.00 | 1.71 | 25.88 |
| 11-unstructured-to-json/extract | 600 | 46.86 ± 0.5% | not timed | not timed | 76.19 ± 5.8% | 51.05 ± 2.2% | not timed | not timed | 46.63 ± 0.4% | | 1.00 | 0.61 | 0.92 |
| 12-dictionary/single | 1 | 509.09 ± 0.2% | not timed | not timed | 479.94 ± 0.4% | 0.38 ± 2.6% | not timed | not timed | 510.04 ± 0.4% | | 1.00 | 1.06 | 1337.80 |
| 14-quadratic/1x | 100 | 9.49 ± 0.4% | not timed | not timed | 12.20 ± 0.6% | 1.00 ± 2.5% | not timed | not timed | 9.46 ± 0.7% | | 1.00 | 0.78 | 9.45 |
| 14-quadratic/2x | 200 | 5.34 ± 0.2% | not timed | not timed | 6.12 ± 0.2% | 0.55 ± 1.3% | not timed | not timed | 5.34 ± 0.2% | | 1.00 | 0.87 | 9.79 |
| 14-quadratic/10x | 1000 | 1.19 ± 1.3% | not timed | not timed | 1.22 ± 0.1% | 0.12 ± 1.2% | not timed | not timed | 1.18 ± 0.3% | | 1.00 | 0.97 | 10.05 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.68 ± 0.8% | not timed | not timed | 0.48 ± 0.4% | 0.64 ± 6.7% | not timed | not timed | 1.67 ± 1.5% | | 1.01 | 3.53 | 2.61 |
| 04-ruff-noqa/compile-real | 1 | 102.26 ± 9.0% | not timed | not timed | 17.33 ± 0.8% | 168.83 ± 10.8% | not timed | not timed | 102.06 ± 0.7% | | 1.00 | 5.90 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 17.17 ± 0.4% | not timed | not timed | 3.00 ± 0.7% | 7.90 ± 4.3% | not timed | not timed | 17.02 ± 0.6% | | 1.01 | 5.72 | 2.17 |
| 07-unicode-character-data/compile | 1 | 63.94 ± 1.9% | not timed | not timed | 30.34 ± 0.6% | 44.91 ± 6.9% | not timed | not timed | 63.67 ± 13.1% | | 1.00 | 2.11 | 1.42 |
| 09-aws-keys/compile-full | 1 | 44.95 ± 0.3% | not timed | not timed | 9.93 ± 17.2% | 27.92 ± 5.5% | not timed | not timed | 44.41 ± 11.7% | | 1.01 | 4.53 | 1.61 |
| 09-aws-keys/compile-quick | 1 | 195.53 ± 0.1% | not timed | not timed | 58.07 ± 12.5% | 158.07 ± 3.0% | not timed | not timed | 194.67 ± 0.6% | | 1.00 | 3.37 | 1.24 |
| 10-bounded-repeat/compile-context | 1 | 15.21 ± 0.5% | not timed | not timed | 14.36 ± 0.6% | 20.80 ± 2.6% | not timed | not timed | 15.10 ± 1.0% | | 1.01 | 1.06 | 0.73 |
| 10-bounded-repeat/compile-capitals | 1 | 91.93 ± 0.3% | not timed | not timed | 10.39 ± 0.5% | 29.69 ± 3.2% | not timed | not timed | 89.45 ± 0.6% | | 1.03 | 8.85 | 3.10 |
| 11-unstructured-to-json/compile | 1 | 99.28 ± 7.2% | not timed | not timed | 47.26 ± 9.0% | 82.65 ± 3.0% | not timed | not timed | 98.50 ± 0.3% | | 1.01 | 2.10 | 1.20 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.6% | not timed | not timed | 0.09 ± 44.5% | 0.10 ± 24.3% | not timed | not timed | 0.35 ± 0.7% | | 1.00 | 4.09 | 3.56 |

