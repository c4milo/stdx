# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243499820 |
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
| literal: a word | 217 | 39395.22 ± 5.5% | 3352.19 ± 0.5% | 20.12 ± 6.2% | 31094.75 ± 0.8% | 9074.39 ± 7.0% | 10.75 ± 0.1% | 76.27 ± 0.6% | 38550.87 ± 1.9% | 11.75 | 1.02 | 1.27 | 4.34 |
| literal: a word that is not there | 0 | 53085.67 ± 1.9% | 3244.10 ± 0.3% | 20.17 ± 4.9% | 39515.91 ± 0.4% | 30019.64 ± 0.6% | 10.72 ± 0.3% | 72.11 ± 1.1% | 52550.60 ± 1.4% | 16.36 | 1.01 | 1.34 | 1.77 |
| literal: one of four words | 661 | 11566.91 ± 1.5% | 1395.58 ± 0.5% | 10.94 ± 3.1% | 9133.40 ± 0.4% | 19.31 ± 1.9% | 3.99 ± 0.5% | 6.02 ± 1.6% | 11613.65 ± 0.8% | 8.29 | 1.00 | 1.27 | 599.14 |
| literal: a word in any case | 217 | 29541.55 ± 1.7% | 1455.29 ± 0.1% | 15.06 ± 0.7% | 9254.25 ± 0.2% | 37.30 ± 0.3% | refused | differs | 30050.54 ± 0.4% | 20.30 | 0.98 | 3.19 | 791.97 |
| literal: an href attribute | 33 | 29251.31 ± 2.6% | 539.74 ± 0.1% | 18.56 ± 2.0% | 27319.44 ± 0.8% | 2052.15 ± 1.0% | 8.24 ± 0.1% | 63.25 ± 1.0% | 28681.40 ± 2.2% | 54.19 | 1.02 | 1.07 | 14.25 |
| literal: a word, second text | 123 | 37931.55 ± 2.4% | 2380.77 ± 0.4% | 19.74 ± 4.3% | 31791.94 ± 0.5% | 7400.94 ± 3.8% | 11.83 ± 0.2% | 65.29 ± 2.0% | 37084.52 ± 1.5% | 15.93 | 1.02 | 1.19 | 5.13 |
| class: two capitalized words | 1331 | 765.46 ± 0.9% | 526.91 ± 0.9% | 18.68 ± 1.1% | 506.09 ± 0.1% | 34.33 ± 0.2% | 9.33 ± 0.4% | 56.83 ± 1.8% | 765.20 ± 1.6% | 1.45 | 1.00 | 1.51 | 22.29 |
| class: a word that ends in ing | 3399 | 499.91 ± 0.3% | 499.14 ± 0.6% | 12.93 ± 0.5% | 472.19 ± 0.4% | 25.67 ± 8.9% | 5.36 ± 0.3% | 16.43 ± 2.0% | 500.13 ± 1.4% | 1.00 | 1.00 | 1.06 | 19.48 |
| class: a word in capitals | 2332 | 942.32 ± 1.4% | 531.27 ± 1.3% | 19.34 ± 1.7% | 497.68 ± 1.2% | 36.48 ± 5.1% | 10.31 ± 1.1% | 77.44 ± 2.2% | 942.35 ± 0.8% | 1.77 | 1.00 | 1.89 | 25.83 |
| class: a number | 8288 | 1449.74 ± 0.4% | 701.00 ± 0.5% | 19.53 ± 4.8% | 1490.38 ± 2.1% | 36.57 ± 10.0% | 0.34 ± 0.7% | 55.61 ± 0.7% | 1454.28 ± 0.1% | 2.07 | 1.00 | 0.97 | 39.65 |
| class: two capitalized words, second text | 5359 | 443.42 ± 1.0% | 448.98 ± 0.7% | 16.99 ± 3.2% | 416.82 ± 0.4% | 29.21 ± 3.4% | 10.47 ± 0.3% | 52.21 ± 2.0% | 443.24 ± 0.7% | 0.99 | 1.00 | 1.06 | 15.18 |
| other: a word between two words | 6104 | 707.48 ± 0.5% | 511.04 ± 0.5% | 16.71 ± 1.4% | 698.27 ± 3.2% | 102.10 ± 13.7% | 7.26 ± 0.4% | 57.74 ± 0.9% | 709.61 ± 4.3% | 1.38 | 1.00 | 1.01 | 6.93 |
| other: a number before a unit, second text | 1481 | 7280.14 ± 0.7% | 834.29 ± 0.4% | 18.83 ± 3.5% | 6291.95 ± 0.4% | 35.18 ± 10.9% | 10.88 ± 0.7% | 56.16 ± 4.0% | 7240.82 ± 1.0% | 8.73 | 1.01 | 1.16 | 206.93 |
| other: a heading's start tag | 110 | 19619.19 ± 1.6% | 654.60 ± 0.1% | 19.25 ± 3.4% | 2012.25 ± 0.4% | 1477.60 ± 3.4% | 10.01 ± 0.3% | 73.27 ± 2.1% | 19715.29 ± 1.5% | 29.97 | 1.00 | 9.75 | 13.28 |
| other: a whole word | 217 | 23690.71 ± 2.3% | 532.19 ± 0.1% | 19.80 ± 1.2% | 22666.82 ± 0.4% | 40.27 ± 0.3% | 9.47 ± 0.2% | 46.56 ± 1.6% | 23212.99 ± 1.1% | 44.52 | 1.02 | 1.05 | 588.31 |
| other: a line's first word, second text | 3716 | 1962.36 ± 3.3% | 513.09 ± 0.4% | 22.39 ± 0.6% | 1748.18 ± 3.3% | 52.88 ± 4.5% | refused | refused | 1998.11 ± 5.2% | 3.82 | 0.98 | 1.12 | 37.11 |
| other: fourteen octets before an x | 87 | 26816.26 ± 1.3% | 204.79 ± 1.0% | 5.42 ± 0.4% | 2848.65 ± 1.1% | 9.00 ± 0.2% | differs | 14.68 ± 3.9% | 26845.80 ± 1.5% | 130.95 | 1.00 | 9.41 | 2978.52 |
| other: a Greek word | 21815 | 384.31 ± 4.1% | 334.43 ± 0.4% | 23.82 ± 1.9% | 265.18 ± 1.2% | 44.57 ± 16.0% | differs | refused | 383.42 ± 4.0% | 1.15 | 1.00 | 1.45 | 8.62 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 16.64 ± 0.3% | 16.98 ± 1.2% | 0.77 ± 6.8% | 16.85 ± 2.7% | 2.33 ± 0.4% | differs | 3.60 ± 0.8% | 16.91 ± 0.8% | 0.98 | 0.98 | 0.99 | 7.14 |
| a UUID | 32895 | 18.30 ± 2.1% | 18.33 ± 2.1% | 0.55 ± 1.6% | 12.90 ± 2.2% | 2.51 ± 3.1% | 0.44 ± 1.5% | 2.98 ± 7.7% | 18.39 ± 1.9% | 1.00 | 0.99 | 1.42 | 7.28 |
| an IPv4 address | 33176 | 30.06 ± 4.3% | 30.14 ± 1.7% | 1.76 ± 0.3% | 24.14 ± 0.3% | 5.70 ± 0.3% | differs | 3.39 ± 5.3% | 29.16 ± 5.3% | 1.00 | 1.03 | 1.24 | 5.27 |
| a date and time | 32954 | 27.18 ± 9.1% | 27.04 ± 0.4% | 1.24 ± 1.1% | 18.10 ± 0.1% | 6.61 ± 0.3% | 0.75 ± 1.1% | 5.95 ± 8.8% | 27.10 ± 6.8% | 1.01 | 1.00 | 1.50 | 4.11 |
| a field path | 32606 | 19.88 ± 1.0% | 19.92 ± 0.5% | 0.88 ± 2.7% | 19.43 ± 0.2% | 2.90 ± 0.7% | differs | 2.42 ± 0.8% | 19.91 ± 0.7% | 1.00 | 1.00 | 1.02 | 6.86 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.70 ± 1.9% | 8.71 ± 0.8% | 8.61 ± 0.7% | 10.64 ± 0.4% | 4.72 ± 2.4% | 0.46 ± 2.3% | none | 8.71 ± 1.5% | 1.00 | 1.00 | 0.82 | 1.85 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 204.55 ± 2.6% | 205.88 ± 8.9% | 242.79 ± 0.5% | 80.93 ± 3.2% | 185.53 ± 2.6% | 527.31 ± 4.5% | 3436.83 ± 2.6% | 204.36 ± 7.8% | 0.99 | 1.00 | 2.53 | 1.10 |
| a UUID | 62 | 132.42 ± 0.3% | 132.78 ± 0.6% | 148.76 ± 0.3% | 46.53 ± 1.5% | 90.17 ± 14.3% | 203.34 ± 10.0% | 3861.31 ± 0.8% | 132.23 ± 0.5% | 1.00 | 1.00 | 2.85 | 1.47 |
| an IPv4 address | 29 | 381.35 ± 0.7% | 385.24 ± 8.4% | 534.21 ± 0.9% | 70.92 ± 2.1% | 114.94 ± 23.7% | 331.79 ± 1.0% | 6578.42 ± 12.8% | 381.62 ± 0.5% | 0.99 | 1.00 | 5.38 | 3.32 |
| a date and time | 56 | 278.14 ± 10.6% | 279.78 ± 0.4% | 348.52 ± 0.2% | 69.16 ± 0.9% | 123.62 ± 1.9% | 372.43 ± 1.0% | 3919.20 ± 1.4% | 277.92 ± 0.3% | 0.99 | 1.00 | 4.02 | 2.25 |
| a field path | 39 | 204.63 ± 2.2% | 205.58 ± 0.7% | 242.93 ± 1.6% | 75.24 ± 0.6% | 175.51 ± 16.4% | 593.28 ± 3.1% | 4436.23 ± 0.8% | 204.28 ± 0.5% | 1.00 | 1.00 | 2.72 | 1.17 |
| literal: a word | 7 | 567.38 ± 4.5% | 613.80 ± 12.9% | 1076.57 ± 0.4% | 476.74 ± 1.6% | 586.19 ± 2.0% | 1271.26 ± 0.6% | 24495.00 ± 0.6% | 569.94 ± 0.6% | 0.92 | 1.00 | 1.19 | 0.97 |
| literal: a word that is not there | 8 | 546.81 ± 0.6% | 593.54 ± 12.9% | 1006.87 ± 11.1% | 451.87 ± 0.4% | 566.35 ± 0.8% | 1200.48 ± 1.1% | 23433.65 ± 1.4% | 545.13 ± 0.9% | 0.92 | 1.00 | 1.21 | 0.97 |
| literal: one of four words | 26 | 212.08 ± 0.9% | 354.09 ± 7.2% | 474.42 ± 0.1% | 41.78 ± 1.9% | 220.39 ± 1.0% | 445.09 ± 2.0% | 9211.19 ± 7.8% | 212.12 ± 0.4% | 0.60 | 1.00 | 5.08 | 0.96 |
| literal: a word in any case | 11 | 395.19 ± 0.7% | 417.58 ± 1.1% | 600.30 ± 0.5% | 14.49 ± 1.3% | 615.21 ± 1.1% | refused | 18630.47 ± 1.9% | 393.92 ± 1.0% | 0.95 | 1.00 | 27.28 | 0.64 |
| literal: an href attribute | 12 | 320.82 ± 0.7% | 332.97 ± 0.6% | 443.68 ± 0.4% | 37.32 ± 3.2% | 431.78 ± 1.7% | 943.95 ± 1.1% | 17317.97 ± 0.8% | 319.93 ± 0.5% | 0.96 | 1.00 | 8.60 | 0.74 |
| literal: a word, second text | 10 | 501.18 ± 0.5% | 552.44 ± 0.5% | 900.64 ± 1.2% | 411.65 ± 0.4% | 489.57 ± 1.2% | 985.70 ± 0.6% | 19775.52 ± 2.6% | 500.32 ± 0.7% | 0.91 | 1.00 | 1.22 | 1.02 |
| class: two capitalized words | 23 | 412.04 ± 0.3% | 442.04 ± 2.2% | 647.66 ± 12.3% | 95.67 ± 0.7% | 453.91 ± 2.4% | 933.18 ± 0.8% | 6122.69 ± 0.9% | 411.88 ± 8.2% | 0.93 | 1.00 | 4.31 | 0.91 |
| class: a word that ends in ing | 9 | 489.28 ± 1.6% | 560.54 ± 9.2% | 979.14 ± 16.9% | 115.71 ± 1.5% | 636.89 ± 2.6% | 1412.54 ± 12.8% | 14823.49 ± 14.9% | 489.09 ± 3.6% | 0.87 | 1.00 | 4.23 | 0.77 |
| class: a word in capitals | 16 | 428.11 ± 1.7% | 461.91 ± 0.9% | 771.18 ± 4.1% | 122.04 ± 5.5% | 648.54 ± 16.2% | 1268.47 ± 5.0% | 8221.34 ± 0.4% | 428.41 ± 0.4% | 0.93 | 1.00 | 3.51 | 0.66 |
| class: a number | 6 | 547.81 ± 0.7% | 603.38 ± 1.9% | 1167.38 ± 1.1% | 36.50 ± 12.6% | 1198.22 ± 1.6% | 2183.55 ± 16.1% | 20182.87 ± 0.4% | 546.74 ± 0.8% | 0.91 | 1.00 | 15.01 | 0.46 |
| class: two capitalized words, second text | 23 | 412.02 ± 7.3% | 444.56 ± 5.3% | 647.41 ± 5.6% | 95.84 ± 3.7% | 457.76 ± 6.1% | 933.24 ± 11.1% | 6122.55 ± 2.8% | 411.69 ± 2.3% | 0.93 | 1.00 | 4.30 | 0.90 |
| other: a word between two words | 13 | 484.11 ± 2.7% | 510.04 ± 2.0% | 796.36 ± 2.2% | 123.08 ± 2.7% | 439.71 ± 10.9% | 1007.32 ± 2.4% | 12401.07 ± 3.6% | 486.54 ± 1.0% | 0.95 | 0.99 | 3.93 | 1.10 |
| other: a number before a unit, second text | 15 | 365.53 ± 0.7% | 411.37 ± 0.4% | 582.41 ± 0.9% | 33.61 ± 1.0% | 542.60 ± 4.4% | 1126.62 ± 4.0% | 12865.49 ± 2.3% | 365.55 ± 12.7% | 0.89 | 1.00 | 10.88 | 0.67 |
| other: a heading's start tag | 13 | 332.06 ± 12.4% | 339.98 ± 0.3% | 454.39 ± 10.2% | 35.69 ± 0.4% | 535.85 ± 1.5% | 1044.95 ± 0.7% | 15451.92 ± 5.4% | 331.81 ± 1.9% | 0.98 | 1.00 | 9.30 | 0.62 |
| other: a whole word | 11 | 493.65 ± 0.6% | 524.42 ± 0.6% | 834.28 ± 0.6% | 110.60 ± 0.6% | 507.25 ± 3.1% | 1037.49 ± 0.7% | 19108.28 ± 4.1% | 491.70 ± 0.6% | 0.94 | 1.00 | 4.46 | 0.97 |
| other: a line's first word, second text | 17 | 464.59 ± 3.5% | 492.38 ± 1.0% | 803.07 ± 0.8% | 116.43 ± 2.1% | 607.79 ± 1.9% | refused | refused | 465.41 ± 0.6% | 0.94 | 1.00 | 3.99 | 0.76 |
| other: fourteen octets before an x | 16 | 87.98 ± 0.6% | 124.77 ± 0.6% | 143.65 ± 1.1% | 14.30 ± 0.7% | 401.89 ± 2.8% | 449.07 ± 0.9% | 11761.53 ± 0.5% | 87.82 ± 7.1% | 0.71 | 1.00 | 6.15 | 0.22 |
| other: a Greek word | 8 | 373.75 ± 0.6% | 532.37 ± 3.8% | 933.63 ± 0.1% | 47.69 ± 0.7% | 1179.85 ± 4.8% | 2193.08 ± 0.9% | refused | 373.53 ± 1.7% | 0.70 | 1.00 | 7.84 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 26809.26 ± 4.6% | not timed | not timed | 27027.27 ± 0.9% | 1966.46 ± 9.1% | not timed | not timed | 26990.71 ± 1.5% | | 0.99 | 0.99 | 13.63 |
| 01-literal/sherlock-casei-en | 522 | 7982.60 ± 1.0% | not timed | not timed | 7003.88 ± 0.6% | 23.52 ± 0.8% | not timed | not timed | 7963.24 ± 0.9% | | 1.00 | 1.14 | 339.43 |
| 01-literal/sherlock-ru | 724 | 27850.86 ± 1.5% | not timed | not timed | 27646.17 ± 1.7% | 1067.65 ± 8.0% | not timed | not timed | 28013.49 ± 1.5% | | 0.99 | 1.01 | 26.09 |
| 01-literal/sherlock-casei-ru | 746 | 9760.43 ± 1.2% | not timed | not timed | 5527.00 ± 2.2% | 29.88 ± 2.6% | not timed | not timed | 9759.00 ± 0.5% | | 1.00 | 1.77 | 326.68 |
| 01-literal/sherlock-zh | 30 | 46017.53 ± 1.8% | not timed | not timed | 36848.04 ± 0.7% | 1265.67 ± 1.4% | not timed | not timed | 45859.43 ± 3.0% | | 1.00 | 1.25 | 36.36 |
| 02-literal-alternate/sherlock-en | 714 | 10001.62 ± 0.3% | not timed | not timed | 8908.72 ± 0.4% | 14.74 ± 4.7% | not timed | not timed | 10049.76 ± 0.3% | | 1.00 | 1.12 | 678.44 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2036.95 ± 1.6% | not timed | not timed | 1817.64 ± 0.2% | 8.86 ± 1.0% | not timed | not timed | 2016.09 ± 3.4% | | 1.01 | 1.12 | 229.79 |
| 02-literal-alternate/sherlock-ru | 899 | 8203.22 ± 0.2% | not timed | not timed | 4264.72 ± 0.3% | 19.69 ± 1.2% | not timed | not timed | 8186.44 ± 0.4% | | 1.00 | 1.92 | 416.56 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2097.71 ± 0.3% | not timed | not timed | 998.95 ± 0.1% | 8.47 ± 1.5% | not timed | not timed | 2092.97 ± 0.5% | | 1.00 | 2.10 | 247.79 |
| 02-literal-alternate/sherlock-zh | 207 | 14483.23 ± 2.5% | not timed | not timed | 10459.34 ± 0.3% | 27.09 ± 0.9% | not timed | not timed | 14493.80 ± 0.3% | | 1.00 | 1.38 | 534.63 |
| 03-date/ascii | 111817 | 96.24 ± 0.2% | not timed | not timed | 84.64 ± 8.1% | 0.17 ± 3.0% | not timed | not timed | 96.04 ± 1.0% | | 1.00 | 1.14 | 553.95 |
| 04-ruff-noqa/real | 84 | 410.08 ± 1.9% | not timed | not timed | 442.78 ± 2.2% | 15.90 ± 0.8% | not timed | not timed | 407.73 ± 1.6% | | 1.01 | 0.93 | 25.78 |
| 04-ruff-noqa/tweaked | 44 | 513.12 ± 0.2% | not timed | not timed | 430.40 ± 0.7% | 294.18 ± 10.0% | not timed | not timed | 511.90 ± 2.8% | | 1.00 | 1.19 | 1.74 |
| 05-lexer-veryl/single | 124800 | 3.41 ± 19.5% | not timed | not timed | 4.20 ± 13.2% | 0.22 ± 4.3% | not timed | not timed | 3.42 ± 2.5% | | 1.00 | 0.81 | 15.78 |
| 06-cloud-flare-redos/original | 107 | 349.58 ± 5.3% | not timed | not timed | 191.29 ± 2.1% | 20.58 ± 0.7% | not timed | not timed | 348.50 ± 0.6% | | 1.00 | 1.83 | 16.98 |
| 06-cloud-flare-redos/simplified-short | 102 | 330.34 ± 1.2% | not timed | not timed | 191.62 ± 0.3% | 21.96 ± 0.8% | not timed | not timed | 330.20 ± 8.1% | | 1.00 | 1.72 | 15.04 |
| 06-cloud-flare-redos/simplified-long | 10000 | 465.36 ± 0.1% | not timed | not timed | 211.38 ± 0.8% | 24.10 ± 0.6% | not timed | not timed | 464.47 ± 1.4% | | 1.00 | 2.20 | 19.31 |
| 07-unicode-character-data/parse-line | 558784 | 204.56 ± 0.3% | not timed | not timed | 156.85 ± 0.3% | 36.99 ± 15.0% | not timed | not timed | 201.06 ± 5.5% | | 1.02 | 1.30 | 5.53 |
| 08-words/all-english | 56691 | 96.53 ± 0.5% | not timed | not timed | 73.67 ± 0.3% | 10.15 ± 5.3% | not timed | not timed | 96.48 ± 1.2% | | 1.00 | 1.31 | 9.51 |
| 08-words/long-english | 839 | 536.38 ± 0.7% | not timed | not timed | 514.46 ± 0.3% | 26.26 ± 10.1% | not timed | not timed | 536.14 ± 0.3% | | 1.00 | 1.04 | 20.43 |
| 09-aws-keys/full | 0 | 416.09 ± 0.1% | not timed | not timed | 449.58 ± 11.5% | 47.72 ± 4.2% | not timed | not timed | 416.13 ± 0.2% | | 1.00 | 0.93 | 8.72 |
| 09-aws-keys/quick | 0 | 960.73 ± 1.4% | not timed | not timed | 802.62 ± 0.5% | 329.93 ± 0.6% | not timed | not timed | 959.78 ± 0.2% | | 1.00 | 1.20 | 2.91 |
| 10-bounded-repeat/letters-en | 1833 | 482.54 ± 1.7% | not timed | not timed | 430.83 ± 1.3% | 16.84 ± 30.3% | not timed | not timed | 483.31 ± 1.2% | | 1.00 | 1.12 | 28.66 |
| 10-bounded-repeat/letters-ru | 3475 | 429.43 ± 3.0% | not timed | not timed | 408.48 ± 2.6% | 19.68 ± 17.1% | not timed | not timed | 428.66 ± 0.6% | | 1.00 | 1.05 | 21.82 |
| 10-bounded-repeat/context | 53 | 65.29 ± 0.7% | not timed | not timed | 56.20 ± 7.6% | 16.96 ± 0.4% | not timed | not timed | 63.85 ± 0.9% | | 1.02 | 1.16 | 3.85 |
| 10-bounded-repeat/capitals | 11 | 557.39 ± 8.3% | not timed | not timed | 532.87 ± 0.1% | 30.96 ± 0.5% | not timed | not timed | 553.20 ± 8.5% | | 1.01 | 1.05 | 18.00 |
| 11-unstructured-to-json/extract | 600 | 55.81 ± 5.4% | not timed | not timed | 61.91 ± 0.9% | 40.77 ± 0.5% | not timed | not timed | 56.40 ± 5.0% | | 0.99 | 0.90 | 1.37 |
| 12-dictionary/single | 1 | 459.32 ± 1.3% | not timed | not timed | 442.35 ± 0.3% | 0.31 ± 0.5% | not timed | not timed | 458.09 ± 1.0% | | 1.00 | 1.04 | 1458.76 |
| 14-quadratic/1x | 100 | 21.13 ± 0.6% | not timed | not timed | 9.10 ± 0.2% | 0.79 ± 5.8% | not timed | not timed | 21.18 ± 1.7% | | 1.00 | 2.32 | 26.66 |
| 14-quadratic/2x | 200 | 16.18 ± 0.6% | not timed | not timed | 4.91 ± 0.1% | 0.43 ± 2.2% | not timed | not timed | 16.22 ± 1.1% | | 1.00 | 3.29 | 37.66 |
| 14-quadratic/10x | 1000 | 5.62 ± 2.1% | not timed | not timed | 1.05 ± 0.9% | 0.09 ± 1.0% | not timed | not timed | 5.61 ± 0.9% | | 1.00 | 5.36 | 61.15 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.18 ± 4.0% | not timed | not timed | 0.39 ± 0.6% | 0.48 ± 6.8% | not timed | not timed | 1.17 ± 1.6% | | 1.01 | 3.05 | 2.44 |
| 04-ruff-noqa/compile-real | 1 | 84.63 ± 0.8% | not timed | not timed | 12.91 ± 0.5% | 126.65 ± 3.8% | not timed | not timed | 83.32 ± 7.2% | | 1.02 | 6.56 | 0.67 |
| 05-lexer-veryl/compile-single | 1 | 12.69 ± 0.4% | not timed | not timed | 2.38 ± 19.1% | 5.88 ± 2.3% | not timed | not timed | 12.68 ± 0.6% | | 1.00 | 5.33 | 2.16 |
| 07-unicode-character-data/compile | 1 | 52.32 ± 2.1% | not timed | not timed | 24.17 ± 0.8% | 32.88 ± 18.3% | not timed | not timed | 52.02 ± 1.0% | | 1.01 | 2.16 | 1.59 |
| 09-aws-keys/compile-full | 1 | 34.57 ± 7.7% | not timed | not timed | 7.04 ± 12.6% | 19.77 ± 4.8% | not timed | not timed | 34.36 ± 2.2% | | 1.01 | 4.91 | 1.75 |
| 09-aws-keys/compile-quick | 1 | 154.16 ± 2.2% | not timed | not timed | 44.77 ± 4.5% | 118.82 ± 5.6% | not timed | not timed | 153.51 ± 1.8% | | 1.00 | 3.44 | 1.30 |
| 10-bounded-repeat/compile-context | 1 | 10.50 ± 1.1% | not timed | not timed | 11.80 ± 11.6% | 15.32 ± 3.1% | not timed | not timed | 10.41 ± 0.6% | | 1.01 | 0.89 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 72.20 ± 0.9% | not timed | not timed | 8.95 ± 0.4% | 22.46 ± 1.8% | not timed | not timed | 72.17 ± 1.7% | | 1.00 | 8.07 | 3.21 |
| 11-unstructured-to-json/compile | 1 | 77.60 ± 0.8% | not timed | not timed | 37.69 ± 1.8% | 60.82 ± 2.6% | not timed | not timed | 77.44 ± 1.6% | | 1.00 | 2.06 | 1.28 |
| 12-dictionary/compile-single | 1 | 0.28 ± 0.6% | not timed | not timed | 0.07 ± 3.9% | 0.09 ± 17.8% | not timed | not timed | 0.28 ± 2.8% | | 1.01 | 4.13 | 3.27 |

