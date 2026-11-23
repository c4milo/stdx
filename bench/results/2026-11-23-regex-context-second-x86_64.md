# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117637541 |
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
| literal: a word | 217 | 33599.66 ± 4.1% | 894.29 ± 0.6% | 20.06 ± 1.1% | 31318.76 ± 1.0% | 8992.72 ± 8.6% | 10.79 ± 0.2% | 75.36 ± 0.3% | 32960.06 ± 2.7% | 37.57 | 1.02 | 1.07 | 3.74 |
| literal: a word that is not there | 0 | 50168.32 ± 1.7% | 906.09 ± 0.5% | 20.09 ± 0.3% | 39379.46 ± 3.8% | 30373.16 ± 1.7% | 10.75 ± 0.1% | 71.46 ± 3.1% | 49102.31 ± 2.4% | 55.37 | 1.02 | 1.27 | 1.65 |
| literal: one of four words | 661 | 10838.28 ± 1.8% | 867.93 ± 0.1% | 10.82 ± 1.5% | 9069.99 ± 7.6% | 19.03 ± 0.9% | 3.95 ± 0.4% | 6.42 ± 3.1% | 10873.05 ± 7.9% | 12.49 | 1.00 | 1.19 | 569.57 |
| literal: a word in any case | 217 | 26067.40 ± 0.3% | 893.65 ± 0.2% | 15.51 ± 0.8% | 9236.69 ± 0.5% | 37.27 ± 0.5% | refused | differs | 25858.29 ± 3.6% | 29.17 | 1.01 | 2.82 | 699.33 |
| literal: an href attribute | 33 | 26545.50 ± 1.0% | 901.79 ± 1.1% | 18.75 ± 6.6% | 27344.52 ± 0.8% | 2059.27 ± 0.5% | 8.28 ± 0.4% | 60.96 ± 1.2% | 26411.87 ± 4.9% | 29.44 | 1.01 | 0.97 | 12.89 |
| literal: a word, second text | 123 | 34006.32 ± 1.3% | 898.95 ± 1.8% | 19.83 ± 0.5% | 31854.41 ± 0.4% | 7167.43 ± 4.9% | 11.79 ± 0.2% | 65.34 ± 1.2% | 33817.68 ± 2.2% | 37.83 | 1.01 | 1.07 | 4.74 |
| class: two capitalized words | 1331 | 780.53 ± 0.1% | 813.34 ± 1.2% | 18.86 ± 0.4% | 505.87 ± 0.1% | 34.47 ± 15.0% | 9.47 ± 0.5% | 54.71 ± 9.1% | 780.66 ± 0.1% | 0.96 | 1.00 | 1.54 | 22.64 |
| class: a word that ends in ing | 3399 | 735.30 ± 1.3% | 736.99 ± 0.3% | 13.11 ± 0.5% | 473.07 ± 0.3% | 25.69 ± 5.5% | 5.33 ± 0.7% | 15.77 ± 1.2% | 729.73 ± 1.9% | 1.00 | 1.01 | 1.55 | 28.62 |
| class: a word in capitals | 2332 | 984.25 ± 0.3% | 794.15 ± 0.1% | 19.82 ± 8.4% | 497.31 ± 0.7% | 36.75 ± 9.6% | 10.61 ± 0.6% | 76.47 ± 0.2% | 985.63 ± 3.2% | 1.24 | 1.00 | 1.98 | 26.78 |
| class: a number | 8288 | 1370.35 ± 0.3% | 648.71 ± 0.1% | 19.54 ± 0.4% | 1484.62 ± 1.0% | 36.21 ± 11.9% | 0.33 ± 1.5% | 54.19 ± 10.3% | 1367.75 ± 0.5% | 2.11 | 1.00 | 0.92 | 37.84 |
| class: two capitalized words, second text | 5359 | 580.19 ± 0.4% | 579.68 ± 0.8% | 17.29 ± 0.3% | 417.35 ± 1.4% | 29.70 ± 10.1% | 10.78 ± 0.2% | 50.46 ± 0.5% | 578.73 ± 1.1% | 1.00 | 1.00 | 1.39 | 19.53 |
| other: a word between two words | 6104 | 646.28 ± 0.2% | 619.60 ± 0.5% | 17.04 ± 8.2% | 697.27 ± 0.5% | 104.83 ± 16.1% | 7.27 ± 0.1% | 55.39 ± 0.1% | 648.71 ± 0.3% | 1.04 | 1.00 | 0.93 | 6.17 |
| other: a number before a unit, second text | 1481 | 6701.99 ± 0.8% | 825.51 ± 1.7% | 18.72 ± 0.2% | 6427.04 ± 1.9% | 35.21 ± 5.3% | 11.20 ± 0.2% | 53.86 ± 10.6% | 6683.52 ± 0.4% | 8.12 | 1.00 | 1.04 | 190.32 |
| other: a heading's start tag | 110 | 18941.40 ± 3.5% | 894.19 ± 0.2% | 19.54 ± 1.0% | 1990.64 ± 1.4% | 1471.41 ± 1.6% | 10.08 ± 0.2% | 71.30 ± 6.5% | 18821.23 ± 0.8% | 21.18 | 1.01 | 9.52 | 12.87 |
| other: a whole word | 217 | 22722.81 ± 2.3% | 893.83 ± 0.0% | 20.73 ± 0.4% | 22732.24 ± 14.8% | 40.64 ± 0.2% | 9.52 ± 0.3% | 46.40 ± 0.6% | 22365.66 ± 0.8% | 25.42 | 1.02 | 1.00 | 559.06 |
| other: a line's first word, second text | 3716 | 1732.02 ± 0.5% | 718.66 ± 0.4% | 24.15 ± 0.2% | 1695.65 ± 1.5% | 53.22 ± 6.9% | refused | refused | 1733.59 ± 0.6% | 2.41 | 1.00 | 1.02 | 32.55 |
| other: fourteen octets before an x | 87 | 25682.19 ± 8.3% | 195.03 ± 0.5% | 5.08 ± 4.8% | 2775.32 ± 1.4% | 9.00 ± 0.4% | differs | 15.03 ± 0.3% | 25674.28 ± 6.4% | 131.69 | 1.00 | 9.25 | 2853.32 |
| other: a Greek word | 21815 | 412.42 ± 2.0% | 267.22 ± 0.3% | 23.84 ± 1.9% | 261.61 ± 0.8% | 43.51 ± 11.1% | differs | refused | 409.75 ± 0.7% | 1.54 | 1.01 | 1.58 | 9.48 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.27 ± 3.8% | 24.34 ± 2.8% | 0.72 ± 2.1% | 16.84 ± 0.3% | 1.61 ± 4.0% | differs | 3.40 ± 18.6% | 24.38 ± 11.2% | 1.00 | 1.00 | 1.44 | 15.09 |
| a UUID | 32895 | 20.48 ± 0.7% | 20.37 ± 3.4% | 0.53 ± 7.1% | 12.74 ± 3.8% | 2.48 ± 2.1% | 0.43 ± 1.1% | 2.97 ± 12.0% | 20.41 ± 1.7% | 1.01 | 1.00 | 1.61 | 8.25 |
| an IPv4 address | 33176 | 34.45 ± 6.8% | 32.89 ± 11.3% | 1.80 ± 14.1% | 24.29 ± 6.3% | 5.68 ± 8.7% | differs | 3.36 ± 1.7% | 34.37 ± 13.3% | 1.05 | 1.00 | 1.42 | 6.07 |
| a date and time | 32954 | 30.71 ± 10.0% | 30.72 ± 0.3% | 1.28 ± 0.4% | 18.07 ± 0.2% | 6.65 ± 1.9% | 0.76 ± 1.8% | 5.60 ± 8.2% | 30.68 ± 0.3% | 1.00 | 1.00 | 1.70 | 4.62 |
| a field path | 32606 | 27.45 ± 0.4% | 27.24 ± 0.8% | 0.88 ± 2.0% | 19.65 ± 0.2% | 2.94 ± 0.2% | differs | 2.37 ± 3.0% | 27.30 ± 10.3% | 1.01 | 1.01 | 1.40 | 9.33 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.23 ± 0.6% | 8.21 ± 0.3% | 8.23 ± 14.9% | 10.48 ± 0.2% | 4.78 ± 1.6% | 0.62 ± 0.3% | none | 8.21 ± 0.8% | 1.00 | 1.00 | 0.78 | 1.72 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 182.92 ± 2.2% | 181.47 ± 6.5% | 217.03 ± 2.7% | 79.17 ± 16.1% | 183.11 ± 3.0% | 529.29 ± 5.7% | 3735.39 ± 16.0% | 183.86 ± 2.6% | 1.01 | 0.99 | 2.31 | 1.00 |
| a UUID | 62 | 120.37 ± 9.0% | 120.81 ± 0.6% | 134.81 ± 0.4% | 46.66 ± 1.5% | 88.72 ± 19.5% | 200.16 ± 1.7% | 3939.61 ± 15.2% | 120.40 ± 0.4% | 1.00 | 1.00 | 2.58 | 1.36 |
| an IPv4 address | 29 | 350.77 ± 0.6% | 354.77 ± 7.2% | 491.09 ± 9.6% | 69.14 ± 0.7% | 113.46 ± 3.0% | 330.69 ± 1.3% | 6754.62 ± 13.1% | 349.79 ± 0.6% | 0.99 | 1.00 | 5.07 | 3.09 |
| a date and time | 56 | 270.58 ± 0.6% | 272.44 ± 0.8% | 345.65 ± 0.2% | 69.23 ± 1.6% | 123.48 ± 14.6% | 365.79 ± 9.1% | 4117.42 ± 1.9% | 270.52 ± 0.4% | 0.99 | 1.00 | 3.91 | 2.19 |
| a field path | 39 | 182.44 ± 0.4% | 183.21 ± 5.1% | 213.94 ± 14.2% | 75.48 ± 3.3% | 171.55 ± 2.5% | 578.34 ± 4.4% | 4544.52 ± 0.2% | 182.31 ± 7.1% | 1.00 | 1.00 | 2.42 | 1.06 |
| literal: a word | 7 | 531.98 ± 0.6% | 574.22 ± 0.3% | 1017.23 ± 0.7% | 507.97 ± 15.5% | 570.49 ± 1.6% | 1241.82 ± 0.6% | 21117.86 ± 1.0% | 532.14 ± 0.4% | 0.93 | 1.00 | 1.05 | 0.93 |
| literal: a word that is not there | 8 | 519.38 ± 0.5% | 564.52 ± 3.6% | 985.51 ± 2.0% | 460.04 ± 12.9% | 549.95 ± 3.1% | 1166.83 ± 1.1% | 20655.39 ± 5.3% | 519.21 ± 0.4% | 0.92 | 1.00 | 1.13 | 0.94 |
| literal: one of four words | 26 | 211.88 ± 7.9% | 347.28 ± 3.9% | 475.79 ± 0.3% | 41.67 ± 15.4% | 215.64 ± 2.1% | 453.50 ± 3.1% | 10549.46 ± 1.1% | 212.05 ± 0.4% | 0.61 | 1.00 | 5.09 | 0.98 |
| literal: a word in any case | 11 | 413.26 ± 0.7% | 441.62 ± 8.2% | 677.47 ± 0.5% | 14.40 ± 0.2% | 599.35 ± 1.0% | refused | 17095.68 ± 1.2% | 412.16 ± 0.8% | 0.94 | 1.00 | 28.69 | 0.69 |
| literal: an href attribute | 12 | 305.68 ± 0.3% | 317.51 ± 0.5% | 432.00 ± 0.9% | 37.99 ± 0.3% | 432.80 ± 5.5% | 956.07 ± 0.3% | 15317.26 ± 1.7% | 305.42 ± 0.3% | 0.96 | 1.00 | 8.05 | 0.71 |
| literal: a word, second text | 10 | 485.76 ± 10.0% | 531.76 ± 11.4% | 898.61 ± 9.5% | 417.95 ± 0.7% | 485.75 ± 1.5% | 1004.17 ± 0.8% | 18198.02 ± 0.8% | 486.21 ± 0.5% | 0.91 | 1.00 | 1.16 | 1.00 |
| class: two capitalized words | 23 | 391.99 ± 4.8% | 420.00 ± 0.5% | 622.79 ± 0.6% | 95.21 ± 2.0% | 452.88 ± 2.7% | 932.72 ± 6.4% | 6098.91 ± 13.4% | 392.03 ± 0.3% | 0.93 | 1.00 | 4.12 | 0.87 |
| class: a word that ends in ing | 9 | 461.19 ± 0.6% | 515.30 ± 0.5% | 911.72 ± 0.6% | 116.56 ± 0.9% | 643.32 ± 0.7% | 1363.65 ± 4.6% | 13763.77 ± 12.9% | 461.40 ± 0.2% | 0.89 | 1.00 | 3.96 | 0.72 |
| class: a word in capitals | 16 | 406.59 ± 7.3% | 437.11 ± 1.4% | 732.80 ± 37.1% | 124.84 ± 1.2% | 662.91 ± 4.5% | 1267.79 ± 2.1% | 8205.67 ± 27.6% | 406.07 ± 1.4% | 0.93 | 1.00 | 3.26 | 0.61 |
| class: a number | 6 | 500.35 ± 2.6% | 549.33 ± 1.8% | 1041.81 ± 1.1% | 36.61 ± 1.5% | 1184.75 ± 18.7% | 2260.77 ± 2.4% | 18923.60 ± 0.5% | 500.20 ± 0.3% | 0.91 | 1.00 | 13.67 | 0.42 |
| class: two capitalized words, second text | 23 | 392.06 ± 0.6% | 420.03 ± 0.6% | 621.10 ± 0.6% | 96.23 ± 8.2% | 450.20 ± 4.3% | 935.44 ± 0.9% | 6103.65 ± 12.7% | 391.45 ± 0.4% | 0.93 | 1.00 | 4.07 | 0.87 |
| other: a word between two words | 13 | 467.62 ± 0.9% | 487.41 ± 3.1% | 786.46 ± 6.3% | 123.85 ± 9.5% | 441.48 ± 2.8% | 978.66 ± 3.2% | 12876.96 ± 0.6% | 467.46 ± 0.5% | 0.96 | 1.00 | 3.78 | 1.06 |
| other: a number before a unit, second text | 15 | 343.76 ± 2.2% | 378.33 ± 6.0% | 533.35 ± 0.3% | 34.12 ± 1.5% | 545.24 ± 2.5% | 1115.82 ± 5.1% | 12703.06 ± 23.4% | 343.99 ± 0.4% | 0.91 | 1.00 | 10.08 | 0.63 |
| other: a heading's start tag | 13 | 308.50 ± 1.9% | 313.55 ± 0.3% | 420.18 ± 0.3% | 35.96 ± 0.2% | 526.02 ± 1.3% | 1053.64 ± 2.0% | 14905.73 ± 0.9% | 308.05 ± 0.6% | 0.98 | 1.00 | 8.58 | 0.59 |
| other: a whole word | 11 | 476.28 ± 0.8% | 506.70 ± 2.2% | 827.62 ± 1.5% | 112.92 ± 0.4% | 506.90 ± 1.8% | 1021.08 ± 0.8% | 18536.79 ± 1.7% | 474.68 ± 0.7% | 0.94 | 1.00 | 4.22 | 0.94 |
| other: a line's first word, second text | 17 | 448.02 ± 0.9% | 468.68 ± 0.2% | 775.98 ± 0.3% | 115.44 ± 0.7% | 603.21 ± 1.3% | refused | refused | 447.36 ± 0.2% | 0.96 | 1.00 | 3.88 | 0.74 |
| other: fourteen octets before an x | 16 | 77.69 ± 0.3% | 106.89 ± 6.2% | 122.00 ± 0.1% | 14.20 ± 1.2% | 395.11 ± 7.5% | 453.10 ± 1.6% | 11081.02 ± 0.9% | 77.52 ± 0.4% | 0.73 | 1.00 | 5.47 | 0.20 |
| other: a Greek word | 8 | 338.24 ± 1.8% | 468.40 ± 1.4% | 787.52 ± 0.8% | 46.87 ± 4.1% | 1128.65 ± 14.1% | 2051.38 ± 2.6% | refused | 341.22 ± 7.5% | 0.72 | 0.99 | 7.22 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21379.41 ± 1.2% | not timed | not timed | 27137.72 ± 1.7% | 2046.28 ± 29.3% | not timed | not timed | 21344.62 ± 1.3% | | 1.00 | 0.79 | 10.45 |
| 01-literal/sherlock-casei-en | 522 | 4648.60 ± 0.6% | not timed | not timed | 7027.95 ± 5.2% | 28.73 ± 12.3% | not timed | not timed | 4646.15 ± 0.6% | | 1.00 | 0.66 | 161.82 |
| 01-literal/sherlock-ru | 724 | 22885.86 ± 1.6% | not timed | not timed | 27873.79 ± 0.4% | 1055.80 ± 8.3% | not timed | not timed | 22870.73 ± 0.8% | | 1.00 | 0.82 | 21.68 |
| 01-literal/sherlock-casei-ru | 746 | 7307.98 ± 0.4% | not timed | not timed | 5502.46 ± 0.4% | 30.49 ± 0.8% | not timed | not timed | 7264.17 ± 14.5% | | 1.01 | 1.33 | 239.65 |
| 01-literal/sherlock-zh | 30 | 42567.23 ± 2.4% | not timed | not timed | 36871.91 ± 25.3% | 1264.94 ± 0.3% | not timed | not timed | 42501.31 ± 0.6% | | 1.00 | 1.15 | 33.65 |
| 02-literal-alternate/sherlock-en | 714 | 9477.39 ± 13.6% | not timed | not timed | 8889.55 ± 3.3% | 14.53 ± 21.6% | not timed | not timed | 9565.72 ± 1.8% | | 0.99 | 1.07 | 652.09 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1732.11 ± 0.3% | not timed | not timed | 1819.72 ± 11.3% | 9.49 ± 1.3% | not timed | not timed | 1711.58 ± 0.9% | | 1.01 | 0.95 | 182.47 |
| 02-literal-alternate/sherlock-ru | 899 | 5978.49 ± 1.3% | not timed | not timed | 4253.35 ± 0.4% | 19.55 ± 21.6% | not timed | not timed | 5985.93 ± 0.5% | | 1.00 | 1.41 | 305.86 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1800.33 ± 0.4% | not timed | not timed | 1041.43 ± 5.4% | 8.55 ± 1.4% | not timed | not timed | 1795.86 ± 0.8% | | 1.00 | 1.73 | 210.54 |
| 02-literal-alternate/sherlock-zh | 207 | 13786.49 ± 0.1% | not timed | not timed | 10402.12 ± 6.8% | 27.18 ± 0.4% | not timed | not timed | 13853.51 ± 0.9% | | 1.00 | 1.33 | 507.15 |
| 03-date/ascii | 111817 | 104.08 ± 1.0% | not timed | not timed | 84.23 ± 0.3% | 0.18 ± 1.7% | not timed | not timed | 104.49 ± 1.5% | | 1.00 | 1.24 | 586.61 |
| 04-ruff-noqa/real | 84 | 564.17 ± 0.8% | not timed | not timed | 433.08 ± 0.7% | 14.00 ± 1.8% | not timed | not timed | 560.97 ± 0.1% | | 1.01 | 1.30 | 40.31 |
| 04-ruff-noqa/tweaked | 44 | 449.54 ± 4.9% | not timed | not timed | 429.68 ± 0.6% | 287.56 ± 1.8% | not timed | not timed | 446.33 ± 0.8% | | 1.01 | 1.05 | 1.56 |
| 05-lexer-veryl/single | 124800 | 2.93 ± 2.8% | not timed | not timed | 4.18 ± 1.9% | 0.22 ± 2.6% | not timed | not timed | 2.90 ± 4.0% | | 1.01 | 0.70 | 13.41 |
| 06-cloud-flare-redos/original | 107 | 184.20 ± 0.4% | not timed | not timed | 191.78 ± 0.6% | 13.09 ± 0.1% | not timed | not timed | 183.75 ± 14.7% | | 1.00 | 0.96 | 14.07 |
| 06-cloud-flare-redos/simplified-short | 102 | 127.12 ± 2.3% | not timed | not timed | 190.30 ± 2.0% | 13.86 ± 5.5% | not timed | not timed | 124.96 ± 17.1% | | 1.02 | 0.67 | 9.17 |
| 06-cloud-flare-redos/simplified-long | 10000 | 136.04 ± 8.1% | not timed | not timed | 211.08 ± 4.5% | 14.80 ± 2.2% | not timed | not timed | 136.33 ± 2.4% | | 1.00 | 0.64 | 9.19 |
| 07-unicode-character-data/parse-line | 558784 | 195.58 ± 17.7% | not timed | not timed | 158.40 ± 0.3% | 37.81 ± 3.0% | not timed | not timed | 192.00 ± 19.8% | | 1.02 | 1.23 | 5.17 |
| 08-words/all-english | 56691 | 74.57 ± 8.4% | not timed | not timed | 73.25 ± 0.4% | 10.15 ± 8.4% | not timed | not timed | 74.69 ± 0.4% | | 1.00 | 1.02 | 7.35 |
| 08-words/long-english | 839 | 845.95 ± 0.2% | not timed | not timed | 515.56 ± 1.1% | 26.33 ± 9.3% | not timed | not timed | 848.92 ± 0.3% | | 1.00 | 1.64 | 32.13 |
| 09-aws-keys/full | 0 | 430.59 ± 9.6% | not timed | not timed | 433.87 ± 0.8% | 53.40 ± 7.4% | not timed | not timed | 431.23 ± 9.3% | | 1.00 | 0.99 | 8.06 |
| 09-aws-keys/quick | 0 | 811.19 ± 0.4% | not timed | not timed | 802.43 ± 1.6% | 301.64 ± 12.0% | not timed | not timed | 812.18 ± 1.0% | | 1.00 | 1.01 | 2.69 |
| 10-bounded-repeat/letters-en | 1833 | 471.20 ± 0.4% | not timed | not timed | 430.51 ± 0.3% | 16.36 ± 0.9% | not timed | not timed | 468.24 ± 2.9% | | 1.01 | 1.09 | 28.81 |
| 10-bounded-repeat/letters-ru | 3475 | 325.41 ± 0.6% | not timed | not timed | 404.75 ± 1.0% | 18.13 ± 13.0% | not timed | not timed | 323.97 ± 3.9% | | 1.00 | 0.80 | 17.95 |
| 10-bounded-repeat/context | 53 | 66.73 ± 1.2% | not timed | not timed | 56.10 ± 0.9% | 16.93 ± 3.4% | not timed | not timed | 66.24 ± 8.9% | | 1.01 | 1.19 | 3.94 |
| 10-bounded-repeat/capitals | 11 | 897.44 ± 4.3% | not timed | not timed | 533.12 ± 0.5% | 30.98 ± 0.3% | not timed | not timed | 896.95 ± 0.1% | | 1.00 | 1.68 | 28.97 |
| 11-unstructured-to-json/extract | 600 | 36.34 ± 0.4% | not timed | not timed | 62.30 ± 0.8% | 23.01 ± 2.1% | not timed | not timed | 36.45 ± 10.8% | | 1.00 | 0.58 | 1.58 |
| 12-dictionary/single | 1 | 461.20 ± 1.8% | not timed | not timed | 444.42 ± 0.2% | 0.32 ± 4.4% | not timed | not timed | 464.27 ± 0.2% | | 0.99 | 1.04 | 1453.81 |
| 14-quadratic/1x | 100 | 11.45 ± 1.1% | not timed | not timed | 9.11 ± 0.5% | 0.80 ± 2.1% | not timed | not timed | 11.30 ± 1.0% | | 1.01 | 1.26 | 14.30 |
| 14-quadratic/2x | 200 | 6.90 ± 2.0% | not timed | not timed | 4.91 ± 0.3% | 0.43 ± 0.5% | not timed | not timed | 6.87 ± 0.4% | | 1.00 | 1.40 | 16.07 |
| 14-quadratic/10x | 1000 | 1.59 ± 0.3% | not timed | not timed | 1.05 ± 0.2% | 0.09 ± 11.8% | not timed | not timed | 1.59 ± 1.2% | | 1.00 | 1.51 | 17.17 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.31 ± 1.0% | not timed | not timed | 0.37 ± 0.7% | 0.47 ± 2.7% | not timed | not timed | 1.31 ± 1.1% | | 1.00 | 3.51 | 2.79 |
| 04-ruff-noqa/compile-real | 1 | 76.40 ± 0.3% | not timed | not timed | 12.84 ± 3.2% | 123.31 ± 2.4% | not timed | not timed | 75.88 ± 1.4% | | 1.01 | 5.95 | 0.62 |
| 05-lexer-veryl/compile-single | 1 | 12.64 ± 1.0% | not timed | not timed | 2.34 ± 1.7% | 5.89 ± 3.1% | not timed | not timed | 12.56 ± 2.3% | | 1.01 | 5.41 | 2.15 |
| 07-unicode-character-data/compile | 1 | 50.74 ± 0.7% | not timed | not timed | 23.82 ± 2.3% | 32.55 ± 1.4% | not timed | not timed | 50.58 ± 0.4% | | 1.00 | 2.13 | 1.56 |
| 09-aws-keys/compile-full | 1 | 34.66 ± 0.6% | not timed | not timed | 7.39 ± 7.8% | 20.28 ± 5.9% | not timed | not timed | 34.38 ± 1.1% | | 1.01 | 4.69 | 1.71 |
| 09-aws-keys/compile-quick | 1 | 153.22 ± 1.0% | not timed | not timed | 45.35 ± 0.3% | 117.51 ± 5.0% | not timed | not timed | 152.33 ± 1.1% | | 1.01 | 3.38 | 1.30 |
| 10-bounded-repeat/compile-context | 1 | 10.44 ± 0.2% | not timed | not timed | 11.40 ± 2.3% | 15.16 ± 0.7% | not timed | not timed | 10.40 ± 0.8% | | 1.00 | 0.92 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 72.86 ± 4.4% | not timed | not timed | 8.78 ± 1.0% | 22.42 ± 1.8% | not timed | not timed | 71.69 ± 1.4% | | 1.02 | 8.30 | 3.25 |
| 11-unstructured-to-json/compile | 1 | 77.09 ± 1.4% | not timed | not timed | 36.48 ± 1.1% | 60.68 ± 2.6% | not timed | not timed | 76.90 ± 0.9% | | 1.00 | 2.11 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.29 ± 2.7% | not timed | not timed | 0.07 ± 5.8% | 0.09 ± 13.3% | not timed | not timed | 0.29 ± 1.5% | | 1.01 | 4.23 | 3.11 |

