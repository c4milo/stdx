# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215344370 |
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
| literal: a word | 217 | 33618.85 ± 2.9% | 3359.51 ± 0.3% | 20.06 ± 0.5% | 31242.64 ± 0.7% | 9102.41 ± 8.9% | 10.76 ± 0.1% | 76.25 ± 1.9% | 32685.97 ± 2.0% | 10.01 | 1.03 | 1.08 | 3.69 |
| literal: a word that is not there | 0 | 50171.86 ± 2.6% | 3242.47 ± 1.0% | 20.09 ± 9.3% | 39901.92 ± 0.2% | 30176.48 ± 0.5% | 10.71 ± 1.9% | 71.97 ± 2.6% | 49392.79 ± 3.9% | 15.47 | 1.02 | 1.26 | 1.66 |
| literal: one of four words | 661 | 11163.65 ± 1.1% | 1399.48 ± 2.4% | 10.91 ± 3.4% | 8456.65 ± 0.1% | 19.28 ± 1.7% | 3.96 ± 0.7% | 6.67 ± 0.9% | 11187.39 ± 2.2% | 7.98 | 1.00 | 1.32 | 578.90 |
| literal: a word in any case | 217 | 25880.70 ± 12.6% | 1496.30 ± 3.0% | 15.44 ± 0.2% | 9185.92 ± 0.5% | 37.22 ± 1.4% | refused | differs | 25624.13 ± 0.9% | 17.30 | 1.01 | 2.82 | 695.35 |
| literal: an href attribute | 33 | 27344.87 ± 5.6% | 538.09 ± 0.6% | 18.51 ± 0.8% | 27352.08 ± 6.1% | 2068.70 ± 0.7% | 8.26 ± 2.7% | 61.68 ± 0.6% | 27005.48 ± 4.7% | 50.82 | 1.01 | 1.00 | 13.22 |
| literal: a word, second text | 123 | 34055.61 ± 7.9% | 2383.53 ± 5.8% | 19.92 ± 3.1% | 32067.32 ± 2.7% | 7251.07 ± 6.2% | 11.63 ± 1.3% | 65.41 ± 1.9% | 33300.08 ± 2.6% | 14.29 | 1.02 | 1.06 | 4.70 |
| class: two capitalized words | 1331 | 770.25 ± 0.2% | 524.89 ± 0.6% | 18.55 ± 0.6% | 506.34 ± 0.1% | 34.04 ± 0.3% | 9.39 ± 0.2% | 55.76 ± 0.6% | 770.25 ± 1.1% | 1.47 | 1.00 | 1.52 | 22.63 |
| class: a word that ends in ing | 3399 | 496.44 ± 0.9% | 497.30 ± 0.4% | 12.76 ± 0.4% | 471.77 ± 0.2% | 25.59 ± 0.5% | 5.33 ± 0.2% | 17.16 ± 7.8% | 485.35 ± 0.1% | 1.00 | 1.02 | 1.05 | 19.40 |
| class: a word in capitals | 2332 | 955.40 ± 0.1% | 529.50 ± 0.3% | 19.63 ± 0.8% | 497.35 ± 0.9% | 36.36 ± 10.8% | 10.47 ± 0.4% | 76.19 ± 2.7% | 955.81 ± 0.1% | 1.80 | 1.00 | 1.92 | 26.27 |
| class: a number | 8288 | 1458.16 ± 0.9% | 700.99 ± 0.6% | 19.64 ± 1.4% | 1469.35 ± 1.0% | 34.56 ± 11.4% | 0.34 ± 1.1% | 55.73 ± 0.2% | 1456.93 ± 0.3% | 2.08 | 1.00 | 0.99 | 42.19 |
| class: two capitalized words, second text | 5359 | 441.49 ± 0.2% | 448.21 ± 0.3% | 15.49 ± 0.4% | 416.89 ± 0.4% | 29.48 ± 10.4% | 10.62 ± 0.2% | 51.53 ± 0.4% | 440.34 ± 2.8% | 0.99 | 1.00 | 1.06 | 14.98 |
| other: a word between two words | 6104 | 663.53 ± 0.4% | 509.17 ± 0.2% | 16.77 ± 0.4% | 695.24 ± 0.7% | 104.79 ± 14.9% | 7.25 ± 0.3% | 56.75 ± 0.7% | 689.13 ± 0.7% | 1.30 | 0.96 | 0.95 | 6.33 |
| other: a number before a unit, second text | 1481 | 7132.37 ± 0.8% | 863.09 ± 1.1% | 18.79 ± 0.5% | 6466.57 ± 0.6% | 35.14 ± 1.1% | 11.01 ± 0.1% | 55.14 ± 0.4% | 7104.60 ± 0.6% | 8.26 | 1.00 | 1.10 | 202.96 |
| other: a heading's start tag | 110 | 18756.97 ± 3.1% | 652.94 ± 0.5% | 19.44 ± 1.1% | 2002.35 ± 7.7% | 1472.87 ± 1.7% | 10.03 ± 0.0% | 72.71 ± 0.6% | 18346.35 ± 3.4% | 28.73 | 1.02 | 9.37 | 12.73 |
| other: a whole word | 217 | 23223.10 ± 9.8% | 530.82 ± 0.2% | 20.52 ± 0.4% | 22495.12 ± 2.0% | 39.75 ± 0.5% | 9.45 ± 0.3% | 47.05 ± 0.9% | 22447.40 ± 3.7% | 43.75 | 1.03 | 1.03 | 584.16 |
| other: a line's first word, second text | 3716 | 1911.59 ± 1.0% | 511.91 ± 0.2% | 24.20 ± 0.2% | 1708.38 ± 2.2% | 52.82 ± 6.1% | refused | refused | 1901.29 ± 0.6% | 3.73 | 1.01 | 1.12 | 36.19 |
| other: fourteen octets before an x | 87 | 25556.77 ± 4.5% | 209.16 ± 4.4% | 5.10 ± 2.2% | 2841.72 ± 3.6% | 8.90 ± 2.4% | differs | 15.43 ± 3.4% | 25263.50 ± 2.6% | 122.19 | 1.01 | 8.99 | 2871.15 |
| other: a Greek word | 21815 | 386.52 ± 0.4% | 333.32 ± 0.5% | 24.06 ± 0.7% | 264.64 ± 2.7% | 42.71 ± 18.5% | differs | refused | 382.51 ± 0.2% | 1.16 | 1.01 | 1.46 | 9.05 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.60 ± 7.6% | 18.62 ± 0.8% | 0.79 ± 0.3% | 16.80 ± 0.2% | 2.32 ± 0.4% | differs | 3.61 ± 13.1% | 18.64 ± 0.3% | 1.00 | 1.00 | 1.11 | 8.01 |
| a UUID | 32895 | 20.42 ± 0.3% | 20.04 ± 0.3% | 0.55 ± 7.1% | 12.83 ± 0.1% | 2.53 ± 8.0% | 0.43 ± 0.1% | 3.11 ± 0.5% | 20.38 ± 7.1% | 1.02 | 1.00 | 1.59 | 8.06 |
| an IPv4 address | 33176 | 34.02 ± 0.4% | 34.01 ± 0.3% | 1.75 ± 0.8% | 23.96 ± 0.6% | 5.69 ± 5.6% | differs | 3.44 ± 11.8% | 34.07 ± 0.2% | 1.00 | 1.00 | 1.42 | 5.98 |
| a date and time | 32954 | 29.40 ± 0.3% | 30.22 ± 0.2% | 1.25 ± 1.0% | 17.93 ± 0.2% | 6.47 ± 2.0% | 0.73 ± 0.9% | 6.19 ± 11.8% | 30.20 ± 10.2% | 0.97 | 0.97 | 1.64 | 4.55 |
| a field path | 32606 | 21.79 ± 4.5% | 21.79 ± 0.2% | 0.89 ± 1.7% | 19.31 ± 1.3% | 2.92 ± 1.2% | differs | 2.42 ± 9.9% | 21.73 ± 3.7% | 1.00 | 1.00 | 1.13 | 7.47 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.68 ± 2.5% | 8.83 ± 3.4% | 8.79 ± 3.0% | 10.63 ± 0.3% | 4.68 ± 1.9% | 0.62 ± 1.1% | none | 8.53 ± 0.3% | 0.98 | 1.02 | 0.82 | 1.85 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 185.88 ± 0.3% | 187.12 ± 0.2% | 217.24 ± 1.0% | 79.13 ± 3.8% | 181.09 ± 2.2% | 533.58 ± 2.4% | 3939.06 ± 0.9% | 186.33 ± 0.3% | 0.99 | 1.00 | 2.35 | 1.03 |
| a UUID | 62 | 121.20 ± 0.4% | 121.45 ± 0.7% | 134.92 ± 0.3% | 46.54 ± 1.9% | 89.56 ± 0.9% | 200.44 ± 1.8% | 4117.33 ± 0.8% | 121.12 ± 0.3% | 1.00 | 1.00 | 2.60 | 1.35 |
| an IPv4 address | 29 | 378.40 ± 1.3% | 379.89 ± 0.8% | 533.71 ± 0.3% | 69.55 ± 13.2% | 113.23 ± 4.5% | 321.70 ± 3.7% | 7123.44 ± 0.9% | 381.14 ± 1.2% | 1.00 | 0.99 | 5.44 | 3.34 |
| a date and time | 56 | 275.48 ± 13.2% | 275.72 ± 14.3% | 347.81 ± 0.4% | 67.96 ± 1.7% | 121.25 ± 4.0% | 370.88 ± 2.6% | 4216.81 ± 16.6% | 276.11 ± 1.6% | 1.00 | 1.00 | 4.05 | 2.27 |
| a field path | 39 | 183.99 ± 0.6% | 184.84 ± 0.2% | 214.90 ± 7.9% | 74.01 ± 2.5% | 171.34 ± 11.8% | 599.80 ± 6.1% | 4737.57 ± 0.9% | 183.79 ± 0.3% | 1.00 | 1.00 | 2.49 | 1.07 |
| literal: a word | 7 | 578.04 ± 0.7% | 617.18 ± 4.3% | 1103.76 ± 1.1% | 492.94 ± 0.8% | 575.84 ± 1.3% | 1255.12 ± 1.0% | 24716.93 ± 10.4% | 576.84 ± 0.7% | 0.94 | 1.00 | 1.17 | 1.00 |
| literal: a word that is not there | 8 | 553.31 ± 14.5% | 597.75 ± 0.4% | 1032.26 ± 0.6% | 456.07 ± 0.8% | 545.08 ± 3.4% | 1179.03 ± 0.5% | 23505.68 ± 1.1% | 552.14 ± 14.8% | 0.93 | 1.00 | 1.21 | 1.02 |
| literal: one of four words | 26 | 212.70 ± 0.4% | 356.82 ± 1.0% | 479.12 ± 3.3% | 41.83 ± 1.2% | 211.01 ± 2.7% | 443.44 ± 5.1% | 11520.59 ± 3.7% | 212.54 ± 1.3% | 0.60 | 1.00 | 5.08 | 1.01 |
| literal: a word in any case | 11 | 395.38 ± 1.0% | 415.55 ± 0.7% | 595.84 ± 2.1% | 14.45 ± 2.6% | 588.25 ± 12.1% | refused | 19194.23 ± 8.2% | 395.87 ± 33.1% | 0.95 | 1.00 | 27.36 | 0.67 |
| literal: an href attribute | 12 | 312.79 ± 0.4% | 320.73 ± 0.2% | 425.49 ± 0.3% | 36.47 ± 4.5% | 420.02 ± 4.8% | 929.38 ± 0.3% | 18915.50 ± 1.1% | 312.12 ± 15.9% | 0.98 | 1.00 | 8.58 | 0.74 |
| literal: a word, second text | 10 | 511.80 ± 0.5% | 556.57 ± 1.2% | 925.24 ± 0.4% | 406.17 ± 1.4% | 474.19 ± 4.8% | 991.17 ± 1.4% | 21292.32 ± 5.7% | 511.46 ± 0.7% | 0.92 | 1.00 | 1.26 | 1.08 |
| class: two capitalized words | 23 | 404.90 ± 2.1% | 427.04 ± 3.1% | 620.71 ± 3.4% | 94.82 ± 0.6% | 427.39 ± 3.8% | 902.81 ± 0.3% | 6382.04 ± 0.7% | 405.87 ± 1.9% | 0.95 | 1.00 | 4.27 | 0.95 |
| class: a word that ends in ing | 9 | 487.96 ± 2.2% | 549.53 ± 2.5% | 988.37 ± 12.8% | 111.50 ± 3.5% | 604.21 ± 6.4% | 1346.42 ± 12.9% | 14732.74 ± 2.8% | 487.08 ± 2.4% | 0.89 | 1.00 | 4.38 | 0.81 |
| class: a word in capitals | 16 | 420.48 ± 0.3% | 452.07 ± 0.7% | 755.47 ± 0.3% | 120.79 ± 1.8% | 624.27 ± 3.4% | 1233.92 ± 1.0% | 8371.25 ± 3.0% | 419.34 ± 0.6% | 0.93 | 1.00 | 3.48 | 0.67 |
| class: a number | 6 | 535.72 ± 1.8% | 587.56 ± 0.7% | 1131.68 ± 3.8% | 36.32 ± 0.5% | 1154.06 ± 4.2% | 2189.61 ± 0.8% | 20376.55 ± 11.6% | 534.20 ± 0.4% | 0.91 | 1.00 | 14.75 | 0.46 |
| class: two capitalized words, second text | 23 | 400.88 ± 2.2% | 433.77 ± 2.5% | 637.24 ± 3.3% | 95.80 ± 12.8% | 443.32 ± 3.3% | 933.03 ± 0.7% | 6379.59 ± 0.5% | 405.82 ± 1.4% | 0.92 | 0.99 | 4.18 | 0.90 |
| other: a word between two words | 13 | 491.78 ± 13.4% | 507.46 ± 0.7% | 805.65 ± 0.6% | 122.80 ± 0.6% | 429.29 ± 2.5% | 1006.06 ± 10.6% | 14045.82 ± 1.9% | 491.74 ± 0.9% | 0.97 | 1.00 | 4.00 | 1.15 |
| other: a number before a unit, second text | 15 | 352.77 ± 0.9% | 389.21 ± 8.9% | 545.29 ± 0.6% | 33.69 ± 1.0% | 531.69 ± 2.3% | 1099.29 ± 4.5% | 13913.58 ± 0.5% | 353.54 ± 0.6% | 0.91 | 1.00 | 10.47 | 0.66 |
| other: a heading's start tag | 13 | 321.94 ± 0.7% | 326.76 ± 0.1% | 434.54 ± 0.3% | 34.89 ± 3.9% | 512.67 ± 3.4% | 1059.15 ± 0.3% | 16192.23 ± 17.1% | 321.62 ± 15.8% | 0.99 | 1.00 | 9.23 | 0.63 |
| other: a whole word | 11 | 491.48 ± 5.1% | 519.37 ± 1.1% | 824.30 ± 1.2% | 109.06 ± 6.8% | 497.77 ± 13.1% | 1052.15 ± 0.8% | 20723.67 ± 1.3% | 489.82 ± 0.4% | 0.95 | 1.00 | 4.51 | 0.99 |
| other: a line's first word, second text | 17 | 466.42 ± 4.0% | 481.66 ± 1.8% | 791.40 ± 0.4% | 114.00 ± 15.0% | 580.49 ± 6.9% | refused | refused | 464.33 ± 9.2% | 0.97 | 1.00 | 4.09 | 0.80 |
| other: fourteen octets before an x | 16 | 86.62 ± 1.1% | 121.85 ± 0.7% | 140.68 ± 0.4% | 13.98 ± 1.8% | 387.51 ± 4.1% | 452.33 ± 0.7% | 11754.82 ± 0.3% | 86.70 ± 0.3% | 0.71 | 1.00 | 6.20 | 0.22 |
| other: a Greek word | 8 | 367.30 ± 0.5% | 511.79 ± 1.0% | 872.75 ± 0.8% | 47.05 ± 3.7% | 1162.07 ± 3.2% | 2176.40 ± 0.3% | refused | 366.77 ± 0.6% | 0.72 | 1.00 | 7.81 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 22064.53 ± 3.2% | not timed | not timed | 27275.46 ± 0.8% | 1889.23 ± 28.3% | not timed | not timed | 22025.92 ± 11.7% | | 1.00 | 0.81 | 11.68 |
| 01-literal/sherlock-casei-en | 522 | 7606.33 ± 6.3% | not timed | not timed | 6982.65 ± 4.3% | 28.49 ± 0.5% | not timed | not timed | 7554.50 ± 11.4% | | 1.01 | 1.09 | 266.95 |
| 01-literal/sherlock-ru | 724 | 23729.28 ± 2.9% | not timed | not timed | 27933.13 ± 12.0% | 1055.11 ± 5.2% | not timed | not timed | 23495.24 ± 1.4% | | 1.01 | 0.85 | 22.49 |
| 01-literal/sherlock-casei-ru | 746 | 9429.11 ± 1.9% | not timed | not timed | 5482.77 ± 2.7% | 30.39 ± 15.1% | not timed | not timed | 9418.88 ± 6.3% | | 1.00 | 1.72 | 310.23 |
| 01-literal/sherlock-zh | 30 | 42693.11 ± 2.7% | not timed | not timed | 36848.09 ± 0.9% | 1262.76 ± 0.2% | not timed | not timed | 42208.70 ± 1.5% | | 1.01 | 1.16 | 33.81 |
| 02-literal-alternate/sherlock-en | 714 | 9629.24 ± 18.1% | not timed | not timed | 8916.76 ± 0.6% | 14.32 ± 3.4% | not timed | not timed | 9610.73 ± 0.5% | | 1.00 | 1.08 | 672.45 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1984.65 ± 0.6% | not timed | not timed | 1813.52 ± 0.5% | 9.47 ± 0.5% | not timed | not timed | 1969.41 ± 1.5% | | 1.01 | 1.09 | 209.66 |
| 02-literal-alternate/sherlock-ru | 899 | 7820.25 ± 3.0% | not timed | not timed | 4267.35 ± 0.4% | 19.42 ± 4.5% | not timed | not timed | 7809.43 ± 2.2% | | 1.00 | 1.83 | 402.74 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2065.12 ± 2.2% | not timed | not timed | 1040.49 ± 0.8% | 8.54 ± 0.5% | not timed | not timed | 2067.61 ± 0.9% | | 1.00 | 1.98 | 241.75 |
| 02-literal-alternate/sherlock-zh | 207 | 13943.51 ± 0.3% | not timed | not timed | 10401.76 ± 0.9% | 27.11 ± 2.2% | not timed | not timed | 13930.01 ± 0.6% | | 1.00 | 1.34 | 514.28 |
| 03-date/ascii | 111817 | 98.16 ± 0.4% | not timed | not timed | 85.39 ± 0.9% | 0.17 ± 4.7% | not timed | not timed | 98.08 ± 1.2% | | 1.00 | 1.15 | 562.17 |
| 04-ruff-noqa/real | 84 | 418.46 ± 1.4% | not timed | not timed | 425.38 ± 0.5% | 15.66 ± 1.3% | not timed | not timed | 418.39 ± 1.1% | | 1.00 | 0.98 | 26.72 |
| 04-ruff-noqa/tweaked | 44 | 476.68 ± 0.6% | not timed | not timed | 418.55 ± 1.6% | 293.45 ± 15.2% | not timed | not timed | 475.59 ± 1.3% | | 1.00 | 1.14 | 1.62 |
| 05-lexer-veryl/single | 124800 | 3.29 ± 3.6% | not timed | not timed | 3.66 ± 2.0% | 0.21 ± 6.9% | not timed | not timed | 3.18 ± 6.3% | | 1.04 | 0.90 | 15.59 |
| 06-cloud-flare-redos/original | 107 | 347.39 ± 0.6% | not timed | not timed | 190.03 ± 0.5% | 20.43 ± 0.2% | not timed | not timed | 348.83 ± 0.4% | | 1.00 | 1.83 | 17.01 |
| 06-cloud-flare-redos/simplified-short | 102 | 334.40 ± 0.5% | not timed | not timed | 191.85 ± 8.1% | 21.76 ± 7.6% | not timed | not timed | 333.80 ± 8.8% | | 1.00 | 1.74 | 15.37 |
| 06-cloud-flare-redos/simplified-long | 10000 | 464.53 ± 1.6% | not timed | not timed | 211.68 ± 0.1% | 23.97 ± 1.4% | not timed | not timed | 464.37 ± 0.3% | | 1.00 | 2.19 | 19.38 |
| 07-unicode-character-data/parse-line | 558784 | 198.05 ± 1.8% | not timed | not timed | 162.25 ± 0.3% | 37.42 ± 4.2% | not timed | not timed | 195.08 ± 2.8% | | 1.02 | 1.22 | 5.29 |
| 08-words/all-english | 56691 | 95.92 ± 0.6% | not timed | not timed | 51.49 ± 0.9% | 10.10 ± 13.9% | not timed | not timed | 98.00 ± 9.5% | | 0.98 | 1.86 | 9.49 |
| 08-words/long-english | 839 | 535.67 ± 1.0% | not timed | not timed | 514.53 ± 0.9% | 25.97 ± 1.7% | not timed | not timed | 535.61 ± 0.3% | | 1.00 | 1.04 | 20.63 |
| 09-aws-keys/full | 0 | 426.51 ± 1.1% | not timed | not timed | 448.01 ± 0.9% | 53.61 ± 6.1% | not timed | not timed | 425.80 ± 0.4% | | 1.00 | 0.95 | 7.96 |
| 09-aws-keys/quick | 0 | 783.95 ± 5.7% | not timed | not timed | 799.63 ± 4.7% | 325.09 ± 2.0% | not timed | not timed | 782.90 ± 10.5% | | 1.00 | 0.98 | 2.41 |
| 10-bounded-repeat/letters-en | 1833 | 486.10 ± 10.9% | not timed | not timed | 430.87 ± 0.3% | 16.82 ± 1.8% | not timed | not timed | 484.17 ± 0.4% | | 1.00 | 1.13 | 28.89 |
| 10-bounded-repeat/letters-ru | 3475 | 431.39 ± 0.9% | not timed | not timed | 409.02 ± 3.5% | 19.87 ± 6.9% | not timed | not timed | 430.58 ± 1.4% | | 1.00 | 1.05 | 21.71 |
| 10-bounded-repeat/context | 53 | 64.28 ± 0.8% | not timed | not timed | 56.32 ± 1.3% | 16.91 ± 0.3% | not timed | not timed | 64.08 ± 0.8% | | 1.00 | 1.14 | 3.80 |
| 10-bounded-repeat/capitals | 11 | 557.60 ± 8.8% | not timed | not timed | 532.85 ± 0.1% | 30.90 ± 0.4% | not timed | not timed | 556.96 ± 8.0% | | 1.00 | 1.05 | 18.05 |
| 11-unstructured-to-json/extract | 600 | 54.62 ± 10.7% | not timed | not timed | 60.03 ± 12.5% | 40.37 ± 2.3% | not timed | not timed | 54.64 ± 0.8% | | 1.00 | 0.91 | 1.35 |
| 12-dictionary/single | 1 | 462.98 ± 1.3% | not timed | not timed | 438.69 ± 0.6% | 0.32 ± 0.9% | not timed | not timed | 463.89 ± 0.4% | | 1.00 | 1.06 | 1458.02 |
| 14-quadratic/1x | 100 | 20.66 ± 0.9% | not timed | not timed | 9.07 ± 0.7% | 0.78 ± 3.1% | not timed | not timed | 20.70 ± 0.9% | | 1.00 | 2.28 | 26.58 |
| 14-quadratic/2x | 200 | 15.97 ± 3.7% | not timed | not timed | 4.90 ± 0.2% | 0.40 ± 1.2% | not timed | not timed | 15.90 ± 26.3% | | 1.00 | 3.26 | 40.22 |
| 14-quadratic/10x | 1000 | 5.60 ± 9.4% | not timed | not timed | 1.05 ± 0.3% | 0.09 ± 1.3% | not timed | not timed | 5.61 ± 2.2% | | 1.00 | 5.33 | 61.09 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.11 ± 2.3% | not timed | not timed | 0.37 ± 3.4% | 0.45 ± 3.5% | not timed | not timed | 1.10 ± 3.4% | | 1.01 | 2.98 | 2.46 |
| 04-ruff-noqa/compile-real | 1 | 77.81 ± 0.3% | not timed | not timed | 12.64 ± 10.0% | 118.58 ± 2.6% | not timed | not timed | 76.31 ± 1.9% | | 1.02 | 6.15 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 12.44 ± 0.7% | not timed | not timed | 2.33 ± 2.5% | 5.76 ± 6.1% | not timed | not timed | 12.39 ± 22.0% | | 1.00 | 5.33 | 2.16 |
| 07-unicode-character-data/compile | 1 | 49.41 ± 0.7% | not timed | not timed | 24.48 ± 2.5% | 31.85 ± 6.1% | not timed | not timed | 49.13 ± 1.1% | | 1.01 | 2.02 | 1.55 |
| 09-aws-keys/compile-full | 1 | 34.03 ± 0.6% | not timed | not timed | 7.36 ± 3.5% | 19.95 ± 7.6% | not timed | not timed | 33.55 ± 1.5% | | 1.01 | 4.62 | 1.71 |
| 09-aws-keys/compile-quick | 1 | 150.94 ± 0.6% | not timed | not timed | 45.13 ± 2.8% | 115.76 ± 3.0% | not timed | not timed | 148.05 ± 3.9% | | 1.02 | 3.34 | 1.30 |
| 10-bounded-repeat/compile-context | 1 | 10.30 ± 9.6% | not timed | not timed | 11.69 ± 0.9% | 15.11 ± 1.6% | not timed | not timed | 10.27 ± 1.8% | | 1.00 | 0.88 | 0.68 |
| 10-bounded-repeat/compile-capitals | 1 | 71.88 ± 0.3% | not timed | not timed | 8.82 ± 2.0% | 22.04 ± 8.3% | not timed | not timed | 71.64 ± 14.4% | | 1.00 | 8.15 | 3.26 |
| 11-unstructured-to-json/compile | 1 | 74.21 ± 16.6% | not timed | not timed | 36.80 ± 1.9% | 55.91 ± 11.5% | not timed | not timed | 73.93 ± 18.6% | | 1.00 | 2.02 | 1.33 |
| 12-dictionary/compile-single | 1 | 0.28 ± 2.2% | not timed | not timed | 0.06 ± 1.7% | 0.08 ± 20.3% | not timed | not timed | 0.28 ± 0.7% | | 1.01 | 4.42 | 3.56 |

