# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127345398 |
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
| literal: a word | 217 | 40361.52 ± 0.6% | 1020.28 ± 11.7% | 31.28 ± 0.2% | 38488.48 ± 1.6% | 11970.86 ± 4.2% | 12.81 ± 0.5% | 103.92 ± 1.3% | 40458.12 ± 1.2% | 39.56 | 1.00 | 1.05 | 3.37 |
| literal: a word that is not there | 0 | 56097.19 ± 1.1% | 1035.34 ± 0.5% | 31.41 ± 0.2% | 45601.09 ± 7.0% | 43598.57 ± 0.5% | 12.67 ± 0.4% | 98.44 ± 1.6% | 56175.19 ± 36.1% | 54.18 | 1.00 | 1.23 | 1.29 |
| literal: one of four words | 661 | 13829.91 ± 0.4% | 998.28 ± 0.5% | 17.33 ± 0.5% | 11190.12 ± 0.8% | 24.87 ± 57.3% | 4.45 ± 3.5% | 8.64 ± 4.0% | 13611.44 ± 5.1% | 13.85 | 1.02 | 1.24 | 556.05 |
| literal: a word in any case | 217 | 36596.70 ± 5.2% | 1018.20 ± 0.4% | 24.30 ± 0.6% | 11396.85 ± 0.5% | 47.10 ± 9.9% | refused | differs | 36369.22 ± 1.0% | 35.94 | 1.01 | 3.21 | 777.00 |
| literal: an href attribute | 33 | 35266.41 ± 0.8% | 1025.71 ± 0.2% | 30.29 ± 0.3% | 35023.95 ± 0.3% | 2932.66 ± 4.2% | 9.60 ± 1.1% | 91.44 ± 0.8% | 35310.94 ± 0.8% | 34.38 | 1.00 | 1.01 | 12.03 |
| literal: a word, second text | 123 | 44786.73 ± 5.8% | 1015.57 ± 0.1% | 30.97 ± 0.3% | 39771.95 ± 0.2% | 10480.75 ± 8.3% | 14.42 ± 0.8% | 88.94 ± 1.8% | 44796.09 ± 0.3% | 44.10 | 1.00 | 1.13 | 4.27 |
| class: two capitalized words | 1331 | 915.20 ± 0.2% | 940.17 ± 0.1% | 28.04 ± 0.4% | 575.25 ± 0.4% | 44.31 ± 0.3% | 11.02 ± 0.1% | 79.28 ± 0.9% | 914.64 ± 0.3% | 0.97 | 1.00 | 1.59 | 20.65 |
| class: a word that ends in ing | 3399 | 861.78 ± 1.0% | 866.70 ± 0.4% | 19.49 ± 1.7% | 539.30 ± 0.3% | 31.58 ± 7.9% | 6.20 ± 4.1% | 20.35 ± 1.3% | 866.27 ± 0.5% | 0.99 | 0.99 | 1.60 | 27.29 |
| class: a word in capitals | 2332 | 1136.78 ± 25.9% | 916.78 ± 4.0% | 30.70 ± 0.4% | 564.40 ± 2.5% | 47.60 ± 18.6% | 12.50 ± 2.7% | 101.79 ± 1.1% | 1149.54 ± 2.5% | 1.24 | 0.99 | 2.01 | 23.88 |
| class: a number | 8288 | 1699.88 ± 0.4% | 803.25 ± 3.4% | 31.95 ± 2.4% | 1802.78 ± 1.3% | 44.81 ± 13.0% | 0.39 ± 0.5% | 72.28 ± 25.1% | 1728.65 ± 2.1% | 2.12 | 0.98 | 0.94 | 37.94 |
| class: two capitalized words, second text | 5359 | 708.22 ± 0.1% | 708.57 ± 2.3% | 26.31 ± 5.7% | 477.69 ± 0.7% | 38.62 ± 12.4% | 12.73 ± 0.3% | 73.64 ± 0.4% | 707.94 ± 0.5% | 1.00 | 1.00 | 1.48 | 18.34 |
| other: a word between two words | 6104 | 770.96 ± 3.0% | 738.61 ± 0.3% | 26.10 ± 0.5% | 817.07 ± 1.2% | 128.47 ± 9.6% | 8.54 ± 0.3% | 82.37 ± 1.2% | 769.75 ± 18.8% | 1.04 | 1.00 | 0.94 | 6.00 |
| other: a number before a unit, second text | 1481 | 9186.43 ± 0.8% | 970.33 ± 0.8% | 28.50 ± 0.3% | 8226.28 ± 0.6% | 44.91 ± 15.3% | 13.30 ± 0.7% | 77.37 ± 0.9% | 9122.89 ± 5.8% | 9.47 | 1.01 | 1.12 | 204.55 |
| other: a heading's start tag | 110 | 24391.60 ± 0.1% | 1011.76 ± 0.1% | 30.72 ± 0.8% | 2564.52 ± 0.9% | 2018.44 ± 3.1% | 11.81 ± 0.4% | 107.27 ± 0.3% | 24501.68 ± 0.3% | 24.11 | 1.00 | 9.51 | 12.08 |
| other: a whole word | 217 | 28975.63 ± 0.4% | 1018.83 ± 0.2% | 32.13 ± 0.3% | 27986.18 ± 1.2% | 53.91 ± 1.1% | 11.18 ± 0.3% | 63.57 ± 0.4% | 29003.97 ± 0.2% | 28.44 | 1.00 | 1.04 | 537.53 |
| other: a line's first word, second text | 3716 | 2316.05 ± 1.5% | 847.58 ± 0.5% | 36.14 ± 0.8% | 2307.33 ± 0.8% | 69.95 ± 3.6% | refused | refused | 2224.69 ± 0.6% | 2.73 | 1.04 | 1.00 | 33.11 |
| other: fourteen octets before an x | 87 | 35218.29 ± 0.2% | 246.84 ± 19.5% | 7.12 ± 2.0% | 3577.32 ± 0.7% | 11.49 ± 1.7% | differs | 21.01 ± 24.6% | 35580.27 ± 1.0% | 142.68 | 0.99 | 9.84 | 3064.98 |
| other: a Greek word | 21815 | 472.72 ± 0.3% | 356.61 ± 0.9% | 34.81 ± 0.5% | 304.47 ± 0.3% | 56.35 ± 11.6% | differs | refused | 472.57 ± 0.8% | 1.33 | 1.00 | 1.55 | 8.39 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.60 ± 1.0% | 29.56 ± 0.2% | 1.00 ± 3.6% | 19.91 ± 0.6% | 2.30 ± 0.5% | differs | 4.21 ± 1.4% | 29.27 ± 0.8% | 1.00 | 1.01 | 1.49 | 12.85 |
| a UUID | 32895 | 24.05 ± 0.8% | 24.01 ± 1.1% | 0.73 ± 0.8% | 15.14 ± 0.3% | 3.06 ± 2.9% | 0.48 ± 0.2% | 3.79 ± 1.4% | 24.01 ± 0.2% | 1.00 | 1.00 | 1.59 | 7.85 |
| an IPv4 address | 33176 | 40.56 ± 0.7% | 40.62 ± 0.3% | 2.30 ± 2.4% | 28.55 ± 0.2% | 7.01 ± 1.8% | differs | 4.12 ± 1.9% | 40.56 ± 8.7% | 1.00 | 1.00 | 1.42 | 5.78 |
| a date and time | 32954 | 36.07 ± 10.2% | 36.10 ± 12.6% | 1.72 ± 1.0% | 21.69 ± 0.6% | 8.31 ± 4.5% | 0.85 ± 0.3% | 7.65 ± 9.4% | 36.07 ± 0.6% | 1.00 | 1.00 | 1.66 | 4.34 |
| a field path | 32606 | 32.87 ± 0.3% | 32.77 ± 9.1% | 1.11 ± 0.9% | 23.03 ± 0.4% | 3.47 ± 4.1% | differs | 3.10 ± 2.0% | 32.87 ± 0.2% | 1.00 | 1.00 | 1.43 | 9.47 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.72 ± 9.4% | 10.79 ± 0.4% | 10.69 ± 9.2% | 13.51 ± 0.7% | 5.77 ± 6.3% | 0.71 ± 0.3% | none | 10.83 ± 1.6% | 0.99 | 0.99 | 0.79 | 1.86 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 241.60 ± 1.3% | 243.14 ± 0.2% | 286.12 ± 0.7% | 102.00 ± 1.8% | 238.85 ± 5.2% | 707.74 ± 10.1% | 4941.02 ± 12.2% | 242.22 ± 0.2% | 0.99 | 1.00 | 2.37 | 1.01 |
| a UUID | 62 | 157.15 ± 3.5% | 157.62 ± 0.3% | 176.63 ± 0.8% | 58.33 ± 0.7% | 117.92 ± 2.8% | 256.77 ± 1.4% | 5529.13 ± 0.6% | 157.18 ± 0.2% | 1.00 | 1.00 | 2.69 | 1.33 |
| an IPv4 address | 29 | 497.78 ± 1.9% | 501.90 ± 0.5% | 737.03 ± 0.2% | 86.14 ± 0.6% | 145.95 ± 2.5% | 423.10 ± 3.2% | 8981.68 ± 0.2% | 497.63 ± 0.4% | 0.99 | 1.00 | 5.78 | 3.41 |
| a date and time | 56 | 371.75 ± 0.2% | 373.51 ± 0.8% | 485.77 ± 1.1% | 85.75 ± 0.9% | 153.73 ± 23.0% | 473.14 ± 2.4% | 5699.34 ± 0.4% | 371.47 ± 0.3% | 1.00 | 1.00 | 4.34 | 2.42 |
| a field path | 39 | 232.09 ± 0.6% | 232.96 ± 0.6% | 272.78 ± 0.5% | 93.41 ± 11.4% | 222.23 ± 5.6% | 750.25 ± 6.1% | 6003.35 ± 1.4% | 231.46 ± 0.3% | 1.00 | 1.00 | 2.48 | 1.04 |
| literal: a word | 7 | 721.64 ± 16.6% | 783.83 ± 1.0% | 1499.11 ± 20.3% | 627.47 ± 2.0% | 776.24 ± 14.2% | 1617.35 ± 10.4% | 34210.02 ± 3.0% | 737.17 ± 5.4% | 0.92 | 0.98 | 1.15 | 0.93 |
| literal: a word that is not there | 8 | 710.00 ± 1.1% | 760.35 ± 22.1% | 1412.47 ± 0.3% | 584.80 ± 1.3% | 742.32 ± 20.5% | 1524.35 ± 8.5% | 33403.23 ± 0.4% | 711.29 ± 0.8% | 0.93 | 1.00 | 1.21 | 0.96 |
| literal: one of four words | 26 | 269.31 ± 0.6% | 459.27 ± 1.2% | 638.10 ± 1.7% | 53.76 ± 0.5% | 285.59 ± 5.0% | 581.84 ± 10.6% | 18074.13 ± 1.9% | 269.41 ± 1.5% | 0.59 | 1.00 | 5.01 | 0.94 |
| literal: a word in any case | 11 | 566.40 ± 2.0% | 597.91 ± 0.9% | 951.03 ± 0.9% | 18.99 ± 1.3% | 815.48 ± 29.9% | refused | 26324.67 ± 1.3% | 558.72 ± 4.1% | 0.95 | 1.01 | 29.83 | 0.69 |
| literal: an href attribute | 12 | 401.12 ± 1.8% | 416.55 ± 2.6% | 568.94 ± 2.1% | 51.10 ± 10.3% | 553.81 ± 5.4% | 1273.81 ± 1.4% | 24399.43 ± 10.6% | 403.20 ± 0.3% | 0.96 | 0.99 | 7.85 | 0.72 |
| literal: a word, second text | 10 | 659.62 ± 4.0% | 714.72 ± 17.7% | 1265.01 ± 1.3% | 540.79 ± 0.5% | 635.83 ± 16.3% | 1347.60 ± 0.5% | 31852.40 ± 0.8% | 658.47 ± 0.2% | 0.92 | 1.00 | 1.22 | 1.04 |
| class: two capitalized words | 23 | 523.01 ± 0.4% | 566.58 ± 3.4% | 864.93 ± 1.0% | 120.12 ± 0.7% | 583.86 ± 4.1% | 1278.99 ± 0.8% | 8075.38 ± 13.8% | 523.44 ± 0.4% | 0.92 | 1.00 | 4.35 | 0.90 |
| class: a word that ends in ing | 9 | 642.69 ± 1.2% | 724.20 ± 0.4% | 1354.93 ± 0.3% | 151.21 ± 1.5% | 842.75 ± 15.7% | 1852.78 ± 0.6% | 18685.66 ± 0.3% | 642.88 ± 0.1% | 0.89 | 1.00 | 4.25 | 0.76 |
| class: a word in capitals | 16 | 565.00 ± 1.9% | 610.65 ± 12.2% | 1056.50 ± 10.4% | 155.59 ± 0.8% | 878.12 ± 3.3% | 1718.83 ± 1.0% | 10607.72 ± 0.5% | 564.68 ± 0.4% | 0.93 | 1.00 | 3.63 | 0.64 |
| class: a number | 6 | 693.60 ± 0.2% | 769.64 ± 0.4% | 1547.05 ± 0.9% | 48.12 ± 2.9% | 1622.15 ± 1.7% | 2978.64 ± 1.3% | 25928.28 ± 0.3% | 692.44 ± 0.3% | 0.90 | 1.00 | 14.41 | 0.43 |
| class: two capitalized words, second text | 23 | 523.36 ± 16.9% | 566.42 ± 1.3% | 863.46 ± 1.0% | 120.20 ± 2.3% | 594.14 ± 3.5% | 1251.00 ± 2.5% | 8130.83 ± 0.5% | 522.62 ± 0.3% | 0.92 | 1.00 | 4.35 | 0.88 |
| other: a word between two words | 13 | 638.81 ± 4.2% | 657.97 ± 1.2% | 1097.02 ± 1.4% | 157.56 ± 0.6% | 571.55 ± 3.4% | 1318.34 ± 2.1% | 17453.61 ± 1.1% | 636.83 ± 1.1% | 0.97 | 1.00 | 4.05 | 1.12 |
| other: a number before a unit, second text | 15 | 442.57 ± 0.4% | 491.87 ± 0.4% | 702.15 ± 0.1% | 44.75 ± 1.4% | 712.42 ± 9.9% | 1451.54 ± 15.0% | 17229.23 ± 0.3% | 441.85 ± 0.7% | 0.90 | 1.00 | 9.89 | 0.62 |
| other: a heading's start tag | 13 | 418.02 ± 0.4% | 422.83 ± 0.6% | 579.26 ± 0.3% | 48.15 ± 14.6% | 687.38 ± 11.9% | 1405.59 ± 1.6% | 20524.62 ± 1.3% | 417.53 ± 1.4% | 0.99 | 1.00 | 8.68 | 0.61 |
| other: a whole word | 11 | 662.33 ± 0.9% | 698.76 ± 0.6% | 1210.10 ± 0.7% | 140.73 ± 1.2% | 651.73 ± 34.5% | 1369.63 ± 5.0% | 31712.53 ± 16.2% | 660.77 ± 0.6% | 0.95 | 1.00 | 4.71 | 1.02 |
| other: a line's first word, second text | 17 | 611.33 ± 1.3% | 641.48 ± 4.5% | 1090.49 ± 7.3% | 149.50 ± 4.2% | 779.23 ± 3.5% | refused | refused | 609.10 ± 0.7% | 0.95 | 1.00 | 4.09 | 0.78 |
| other: fourteen octets before an x | 16 | 117.00 ± 0.5% | 175.66 ± 0.6% | 210.98 ± 0.5% | 17.99 ± 0.5% | 497.55 ± 14.8% | 575.92 ± 1.2% | 15648.96 ± 1.0% | 116.95 ± 3.8% | 0.67 | 1.00 | 6.50 | 0.24 |
| other: a Greek word | 8 | 438.23 ± 0.6% | 623.62 ± 1.2% | 1052.86 ± 0.6% | 63.21 ± 0.3% | 1569.30 ± 1.9% | 2787.49 ± 0.9% | refused | 439.11 ± 0.2% | 0.70 | 1.00 | 6.93 | 0.28 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 27253.02 ± 1.8% | not timed | not timed | 33552.95 ± 27.3% | 2756.73 ± 13.6% | not timed | not timed | 27219.85 ± 1.4% | | 1.00 | 0.81 | 9.89 |
| 01-literal/sherlock-casei-en | 522 | 6066.43 ± 1.0% | not timed | not timed | 9003.05 ± 0.8% | 34.13 ± 2.2% | not timed | not timed | 6366.01 ± 0.5% | | 0.95 | 0.67 | 177.72 |
| 01-literal/sherlock-ru | 724 | 29836.40 ± 1.7% | not timed | not timed | 34679.21 ± 5.4% | 1284.24 ± 16.8% | not timed | not timed | 29885.23 ± 0.9% | | 1.00 | 0.86 | 23.23 |
| 01-literal/sherlock-casei-ru | 746 | 8385.00 ± 1.6% | not timed | not timed | 7699.94 ± 28.3% | 37.60 ± 8.7% | not timed | not timed | 8781.42 ± 0.2% | | 0.95 | 1.09 | 222.99 |
| 01-literal/sherlock-zh | 30 | 52799.71 ± 0.4% | not timed | not timed | 42934.38 ± 0.3% | 1635.88 ± 3.3% | not timed | not timed | 52491.24 ± 13.7% | | 1.01 | 1.23 | 32.28 |
| 02-literal-alternate/sherlock-en | 714 | 11057.26 ± 0.4% | not timed | not timed | 10912.01 ± 4.1% | 19.07 ± 0.3% | not timed | not timed | 12545.79 ± 1.6% | | 0.88 | 1.01 | 579.81 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1993.86 ± 1.1% | not timed | not timed | 2282.98 ± 11.5% | 12.25 ± 1.4% | not timed | not timed | 2068.06 ± 1.0% | | 0.96 | 0.87 | 162.76 |
| 02-literal-alternate/sherlock-ru | 899 | 6991.63 ± 8.6% | not timed | not timed | 9792.98 ± 1.9% | 25.41 ± 5.6% | not timed | not timed | 7373.39 ± 4.6% | | 0.95 | 0.71 | 275.18 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1951.46 ± 1.6% | not timed | not timed | 1191.06 ± 0.6% | 10.52 ± 3.3% | not timed | not timed | 2066.33 ± 0.5% | | 0.94 | 1.64 | 185.48 |
| 02-literal-alternate/sherlock-zh | 207 | 16862.45 ± 0.3% | not timed | not timed | 12659.70 ± 0.4% | 35.45 ± 1.0% | not timed | not timed | 18097.93 ± 16.4% | | 0.93 | 1.33 | 475.65 |
| 03-date/ascii | 111817 | 128.41 ± 1.2% | not timed | not timed | 99.95 ± 3.5% | 0.22 ± 7.5% | not timed | not timed | 127.88 ± 1.0% | | 1.00 | 1.28 | 572.73 |
| 04-ruff-noqa/real | 84 | 666.26 ± 1.3% | not timed | not timed | 475.87 ± 0.4% | 17.37 ± 1.2% | not timed | not timed | 669.21 ± 1.6% | | 1.00 | 1.40 | 38.36 |
| 04-ruff-noqa/tweaked | 44 | 593.14 ± 1.7% | not timed | not timed | 514.21 ± 1.1% | 368.29 ± 0.6% | not timed | not timed | 610.91 ± 0.2% | | 0.97 | 1.15 | 1.61 |
| 05-lexer-veryl/single | 124800 | 3.72 ± 9.2% | not timed | not timed | 5.51 ± 14.8% | 0.25 ± 4.3% | not timed | not timed | 3.72 ± 2.6% | | 1.00 | 0.68 | 14.85 |
| 06-cloud-flare-redos/original | 107 | 268.76 ± 0.8% | not timed | not timed | 227.90 ± 1.4% | 25.31 ± 1.2% | not timed | not timed | 268.53 ± 0.1% | | 1.00 | 1.18 | 10.62 |
| 06-cloud-flare-redos/simplified-short | 102 | 263.44 ± 0.4% | not timed | not timed | 236.89 ± 0.4% | 22.47 ± 0.4% | not timed | not timed | 263.33 ± 0.8% | | 1.00 | 1.11 | 11.72 |
| 06-cloud-flare-redos/simplified-long | 10000 | 281.22 ± 0.2% | not timed | not timed | 259.43 ± 0.8% | 29.66 ± 0.9% | not timed | not timed | 281.02 ± 0.3% | | 1.00 | 1.08 | 9.48 |
| 07-unicode-character-data/parse-line | 558784 | 242.77 ± 0.3% | not timed | not timed | 199.60 ± 14.3% | 46.02 ± 13.2% | not timed | not timed | 240.05 ± 2.3% | | 1.01 | 1.22 | 5.27 |
| 08-words/all-english | 56691 | 114.32 ± 1.0% | not timed | not timed | 84.49 ± 0.9% | 13.44 ± 5.0% | not timed | not timed | 113.61 ± 0.3% | | 1.01 | 1.35 | 8.50 |
| 08-words/long-english | 839 | 971.56 ± 0.2% | not timed | not timed | 584.32 ± 2.4% | 35.11 ± 0.5% | not timed | not timed | 970.19 ± 0.9% | | 1.00 | 1.66 | 27.67 |
| 09-aws-keys/full | 0 | 516.76 ± 0.2% | not timed | not timed | 539.78 ± 5.5% | 66.73 ± 0.4% | not timed | not timed | 516.02 ± 1.2% | | 1.00 | 0.96 | 7.74 |
| 09-aws-keys/quick | 0 | 655.53 ± 0.2% | not timed | not timed | 960.22 ± 1.6% | 408.73 ± 20.7% | not timed | not timed | 974.89 ± 1.4% | | 0.67 | 0.68 | 1.60 |
| 10-bounded-repeat/letters-en | 1833 | 647.53 ± 1.7% | not timed | not timed | 556.17 ± 0.7% | 22.84 ± 0.5% | not timed | not timed | 644.75 ± 0.7% | | 1.00 | 1.16 | 28.36 |
| 10-bounded-repeat/letters-ru | 3475 | 365.70 ± 0.3% | not timed | not timed | 483.74 ± 0.2% | 25.27 ± 26.6% | not timed | not timed | 364.04 ± 0.9% | | 1.00 | 0.76 | 14.47 |
| 10-bounded-repeat/context | 53 | 82.66 ± 3.0% | not timed | not timed | 69.51 ± 3.4% | 22.23 ± 4.6% | not timed | not timed | 82.37 ± 10.5% | | 1.00 | 1.19 | 3.72 |
| 10-bounded-repeat/capitals | 11 | 1022.92 ± 0.5% | not timed | not timed | 603.51 ± 0.3% | 40.23 ± 0.3% | not timed | not timed | 1021.21 ± 0.4% | | 1.00 | 1.69 | 25.43 |
| 11-unstructured-to-json/extract | 600 | 45.58 ± 0.6% | not timed | not timed | 79.86 ± 1.1% | 50.20 ± 4.7% | not timed | not timed | 45.56 ± 0.2% | | 1.00 | 0.57 | 0.91 |
| 12-dictionary/single | 1 | 508.09 ± 0.3% | not timed | not timed | 482.86 ± 0.7% | 0.39 ± 1.8% | not timed | not timed | 511.76 ± 0.1% | | 0.99 | 1.05 | 1314.89 |
| 14-quadratic/1x | 100 | 13.62 ± 0.9% | not timed | not timed | 12.20 ± 0.3% | 1.01 ± 1.6% | not timed | not timed | 13.45 ± 1.9% | | 1.01 | 1.12 | 13.50 |
| 14-quadratic/2x | 200 | 8.06 ± 0.4% | not timed | not timed | 6.12 ± 0.3% | 0.55 ± 2.3% | not timed | not timed | 8.05 ± 1.1% | | 1.00 | 1.32 | 14.67 |
| 14-quadratic/10x | 1000 | 1.83 ± 1.0% | not timed | not timed | 1.22 ± 0.1% | 0.12 ± 4.3% | not timed | not timed | 1.83 ± 0.5% | | 1.00 | 1.50 | 15.38 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.65 ± 0.8% | not timed | not timed | 0.48 ± 1.0% | 0.62 ± 7.1% | not timed | not timed | 1.64 ± 1.0% | | 1.01 | 3.47 | 2.67 |
| 04-ruff-noqa/compile-real | 1 | 100.46 ± 0.3% | not timed | not timed | 17.37 ± 1.1% | 155.96 ± 4.8% | not timed | not timed | 101.86 ± 0.9% | | 0.99 | 5.79 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 17.08 ± 3.7% | not timed | not timed | 3.02 ± 1.5% | 7.53 ± 6.2% | not timed | not timed | 17.01 ± 16.0% | | 1.00 | 5.66 | 2.27 |
| 07-unicode-character-data/compile | 1 | 64.37 ± 0.5% | not timed | not timed | 30.69 ± 0.5% | 42.84 ± 4.1% | not timed | not timed | 64.48 ± 1.6% | | 1.00 | 2.10 | 1.50 |
| 09-aws-keys/compile-full | 1 | 45.10 ± 0.5% | not timed | not timed | 9.95 ± 2.1% | 25.12 ± 3.6% | not timed | not timed | 45.10 ± 2.8% | | 1.00 | 4.53 | 1.80 |
| 09-aws-keys/compile-quick | 1 | 193.53 ± 21.4% | not timed | not timed | 58.60 ± 1.0% | 135.84 ± 8.8% | not timed | not timed | 196.29 ± 7.0% | | 0.99 | 3.30 | 1.42 |
| 10-bounded-repeat/compile-context | 1 | 15.47 ± 0.9% | not timed | not timed | 14.47 ± 0.3% | 19.52 ± 3.6% | not timed | not timed | 15.40 ± 0.8% | | 1.00 | 1.07 | 0.79 |
| 10-bounded-repeat/compile-capitals | 1 | 91.95 ± 0.7% | not timed | not timed | 10.50 ± 0.9% | 28.30 ± 9.1% | not timed | not timed | 92.30 ± 1.2% | | 1.00 | 8.76 | 3.25 |
| 11-unstructured-to-json/compile | 1 | 99.23 ± 0.2% | not timed | not timed | 47.55 ± 1.2% | 76.16 ± 5.1% | not timed | not timed | 99.36 ± 2.1% | | 1.00 | 2.09 | 1.30 |
| 12-dictionary/compile-single | 1 | 0.33 ± 10.0% | not timed | not timed | 0.08 ± 9.9% | 0.10 ± 18.7% | not timed | not timed | 0.35 ± 5.5% | | 0.95 | 4.22 | 3.26 |

