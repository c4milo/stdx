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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243511213 |
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
| literal: a word | 217 | 39491.26 ± 3.3% | 3349.10 ± 0.2% | 20.07 ± 2.9% | 30944.73 ± 0.6% | 8909.50 ± 6.4% | 10.90 ± 0.2% | 75.97 ± 2.5% | 38346.99 ± 0.8% | 11.79 | 1.03 | 1.28 | 4.43 |
| literal: a word that is not there | 0 | 52230.58 ± 2.5% | 3245.07 ± 0.2% | 19.98 ± 0.2% | 39014.81 ± 5.2% | 29871.78 ± 0.5% | 10.85 ± 0.3% | 71.78 ± 1.5% | 51603.66 ± 1.0% | 16.10 | 1.01 | 1.34 | 1.75 |
| literal: one of four words | 661 | 11586.54 ± 0.9% | 1394.97 ± 0.2% | 11.08 ± 0.8% | 9136.12 ± 0.2% | 18.75 ± 2.5% | 3.97 ± 0.8% | 6.02 ± 46.9% | 11606.89 ± 2.0% | 8.31 | 1.00 | 1.27 | 618.04 |
| literal: a word in any case | 217 | 30011.87 ± 0.7% | 1481.86 ± 0.5% | 15.53 ± 0.2% | 9252.14 ± 0.4% | 36.86 ± 0.2% | refused | differs | 29830.00 ± 1.5% | 20.25 | 1.01 | 3.24 | 814.27 |
| literal: an href attribute | 33 | 29190.49 ± 2.1% | 539.46 ± 0.1% | 18.79 ± 0.4% | 26981.53 ± 1.0% | 2044.93 ± 0.4% | 8.35 ± 0.3% | 63.33 ± 1.6% | 28696.13 ± 1.4% | 54.11 | 1.02 | 1.08 | 14.27 |
| literal: a word, second text | 123 | 37219.29 ± 0.5% | 2377.32 ± 0.3% | 19.99 ± 0.2% | 31523.24 ± 2.6% | 7284.57 ± 5.8% | 11.98 ± 0.2% | 65.07 ± 1.4% | 37165.77 ± 3.6% | 15.66 | 1.00 | 1.18 | 5.11 |
| class: two capitalized words | 1331 | 762.80 ± 0.7% | 526.75 ± 1.1% | 18.65 ± 3.9% | 506.10 ± 1.0% | 34.04 ± 2.6% | 9.46 ± 1.2% | 57.23 ± 1.4% | 764.40 ± 1.6% | 1.45 | 1.00 | 1.51 | 22.41 |
| class: a word that ends in ing | 3399 | 499.30 ± 0.3% | 499.14 ± 0.2% | 12.92 ± 0.6% | 473.58 ± 0.2% | 25.11 ± 4.7% | 5.32 ± 0.6% | 16.50 ± 0.5% | 499.60 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.89 |
| class: a word in capitals | 2332 | 942.09 ± 0.3% | 531.36 ± 0.1% | 19.79 ± 1.8% | 496.67 ± 0.5% | 36.40 ± 4.7% | 10.50 ± 0.3% | 77.58 ± 5.8% | 942.72 ± 0.3% | 1.77 | 1.00 | 1.90 | 25.88 |
| class: a number | 8288 | 1447.49 ± 0.2% | 701.50 ± 0.1% | 19.69 ± 0.3% | 1487.39 ± 4.7% | 37.11 ± 13.1% | 0.34 ± 0.1% | 55.61 ± 10.1% | 1445.54 ± 0.3% | 2.06 | 1.00 | 0.97 | 39.01 |
| class: two capitalized words, second text | 5359 | 443.46 ± 1.3% | 449.08 ± 0.2% | 17.18 ± 0.8% | 418.19 ± 0.2% | 29.98 ± 9.6% | 10.62 ± 0.1% | 51.89 ± 7.8% | 444.81 ± 0.2% | 0.99 | 1.00 | 1.06 | 14.79 |
| other: a word between two words | 6104 | 713.07 ± 0.3% | 511.51 ± 0.3% | 16.94 ± 0.3% | 699.35 ± 3.6% | 97.00 ± 5.9% | 7.34 ± 0.2% | 57.99 ± 1.9% | 714.70 ± 4.2% | 1.39 | 1.00 | 1.02 | 7.35 |
| other: a number before a unit, second text | 1481 | 7156.68 ± 9.5% | 858.57 ± 0.3% | 18.84 ± 8.8% | 6338.85 ± 0.8% | 34.85 ± 5.4% | 11.02 ± 0.3% | 56.18 ± 1.7% | 7245.33 ± 5.9% | 8.34 | 0.99 | 1.13 | 205.36 |
| other: a heading's start tag | 110 | 19326.70 ± 1.1% | 654.34 ± 0.1% | 19.54 ± 0.3% | 2008.75 ± 2.4% | 1464.91 ± 7.9% | 10.17 ± 0.1% | 74.01 ± 2.1% | 18766.82 ± 0.9% | 29.54 | 1.03 | 9.62 | 13.19 |
| other: a whole word | 217 | 23300.13 ± 2.0% | 532.19 ± 0.3% | 20.39 ± 0.2% | 22544.40 ± 0.5% | 40.30 ± 0.4% | 9.60 ± 0.4% | 46.02 ± 0.7% | 22741.70 ± 0.6% | 43.78 | 1.02 | 1.03 | 578.14 |
| other: a line's first word, second text | 3716 | 1920.03 ± 3.7% | 514.04 ± 0.1% | 24.18 ± 0.3% | 1713.99 ± 2.9% | 52.54 ± 7.3% | refused | refused | 2000.95 ± 7.4% | 3.74 | 0.96 | 1.12 | 36.54 |
| other: fourteen octets before an x | 87 | 27006.68 ± 0.9% | 205.20 ± 1.9% | 5.44 ± 0.8% | 2785.09 ± 0.5% | 8.96 ± 0.5% | differs | 14.67 ± 2.7% | 26864.21 ± 5.0% | 131.61 | 1.01 | 9.70 | 3013.37 |
| other: a Greek word | 21815 | 334.72 ± 2.7% | 333.24 ± 1.8% | 23.83 ± 2.0% | 264.12 ± 2.4% | 39.41 ± 8.9% | differs | refused | 382.16 ± 4.4% | 1.00 | 0.88 | 1.27 | 8.49 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 16.99 ± 0.6% | 16.95 ± 1.2% | 0.78 ± 0.5% | 17.03 ± 0.6% | 2.33 ± 0.4% | differs | 3.61 ± 0.7% | 16.96 ± 0.6% | 1.00 | 1.00 | 1.00 | 7.30 |
| a UUID | 32895 | 18.46 ± 0.2% | 18.34 ± 0.2% | 0.55 ± 7.2% | 12.89 ± 0.1% | 2.51 ± 1.0% | 0.43 ± 0.3% | 3.04 ± 11.8% | 18.42 ± 0.3% | 1.01 | 1.00 | 1.43 | 7.37 |
| an IPv4 address | 33176 | 30.59 ± 1.5% | 30.40 ± 1.9% | 1.76 ± 0.2% | 24.30 ± 0.2% | 5.74 ± 1.4% | differs | 3.41 ± 1.3% | 30.57 ± 2.5% | 1.01 | 1.00 | 1.26 | 5.33 |
| a date and time | 32954 | 27.33 ± 1.5% | 27.37 ± 1.4% | 1.25 ± 0.7% | 18.08 ± 0.2% | 6.61 ± 2.6% | 0.75 ± 0.2% | 5.96 ± 9.9% | 27.42 ± 1.0% | 1.00 | 1.00 | 1.51 | 4.14 |
| a field path | 32606 | 19.61 ± 0.4% | 20.04 ± 0.5% | 0.87 ± 13.5% | 19.65 ± 0.3% | 2.92 ± 0.5% | differs | 2.43 ± 0.6% | 19.99 ± 0.5% | 0.98 | 0.98 | 1.00 | 6.72 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.73 ± 0.4% | 8.69 ± 0.3% | 8.75 ± 0.6% | 10.66 ± 0.6% | 4.70 ± 3.1% | 0.62 ± 0.0% | none | 8.77 ± 0.5% | 1.00 | 1.00 | 0.82 | 1.86 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 187.68 ± 0.3% | 187.80 ± 0.3% | 215.47 ± 7.7% | 80.07 ± 3.9% | 183.82 ± 1.1% | 536.21 ± 10.6% | 3530.39 ± 3.7% | 187.50 ± 0.7% | 1.00 | 1.00 | 2.34 | 1.02 |
| a UUID | 62 | 123.19 ± 1.0% | 123.43 ± 0.3% | 135.61 ± 5.6% | 46.37 ± 1.3% | 89.74 ± 0.9% | 200.45 ± 1.9% | 3868.28 ± 1.7% | 122.95 ± 0.8% | 1.00 | 1.00 | 2.66 | 1.37 |
| an IPv4 address | 29 | 387.83 ± 1.4% | 390.48 ± 1.2% | 529.07 ± 1.4% | 70.33 ± 5.6% | 114.58 ± 14.5% | 330.28 ± 1.8% | 6571.33 ± 0.4% | 390.39 ± 1.1% | 0.99 | 0.99 | 5.51 | 3.38 |
| a date and time | 56 | 282.34 ± 1.3% | 282.83 ± 0.5% | 348.10 ± 0.5% | 69.32 ± 3.0% | 123.72 ± 1.8% | 369.23 ± 1.0% | 3845.02 ± 2.7% | 282.25 ± 0.4% | 1.00 | 1.00 | 4.07 | 2.28 |
| a field path | 39 | 186.46 ± 0.3% | 187.16 ± 0.3% | 214.77 ± 0.3% | 75.13 ± 0.7% | 173.18 ± 1.9% | 598.31 ± 1.5% | 4423.34 ± 1.7% | 186.55 ± 0.8% | 1.00 | 1.00 | 2.48 | 1.08 |
| literal: a word | 7 | 595.05 ± 0.6% | 639.83 ± 1.2% | 1098.30 ± 0.7% | 482.85 ± 1.6% | 580.56 ± 4.7% | 1267.49 ± 1.5% | 24662.04 ± 0.4% | 595.48 ± 0.4% | 0.93 | 1.00 | 1.23 | 1.02 |
| literal: a word that is not there | 8 | 570.14 ± 0.6% | 619.92 ± 0.7% | 1022.83 ± 1.3% | 450.24 ± 1.9% | 556.03 ± 1.8% | 1186.80 ± 0.5% | 23343.47 ± 0.6% | 569.86 ± 1.1% | 0.92 | 1.00 | 1.27 | 1.03 |
| literal: one of four words | 26 | 218.00 ± 1.2% | 364.17 ± 0.5% | 479.46 ± 0.9% | 41.91 ± 1.3% | 218.64 ± 1.5% | 439.26 ± 1.5% | 9879.50 ± 0.2% | 218.01 ± 0.4% | 0.60 | 1.00 | 5.20 | 1.00 |
| literal: a word in any case | 11 | 400.52 ± 1.0% | 422.16 ± 0.3% | 585.02 ± 1.4% | 14.53 ± 2.3% | 603.45 ± 7.9% | refused | 18599.47 ± 8.8% | 400.65 ± 0.3% | 0.95 | 1.00 | 27.57 | 0.66 |
| literal: an href attribute | 12 | 321.18 ± 0.5% | 333.89 ± 0.4% | 432.39 ± 0.8% | 37.59 ± 0.7% | 426.60 ± 2.3% | 955.48 ± 0.8% | 17367.28 ± 0.6% | 321.09 ± 0.4% | 0.96 | 1.00 | 8.54 | 0.75 |
| literal: a word, second text | 10 | 524.82 ± 0.3% | 577.56 ± 0.5% | 917.51 ± 2.1% | 398.69 ± 1.2% | 482.69 ± 1.3% | 1014.69 ± 0.7% | 20557.26 ± 1.2% | 525.20 ± 0.5% | 0.91 | 1.00 | 1.32 | 1.09 |
| class: two capitalized words | 23 | 422.46 ± 0.7% | 455.59 ± 0.6% | 645.27 ± 0.3% | 92.99 ± 0.7% | 447.31 ± 1.3% | 946.40 ± 0.8% | 6120.06 ± 0.4% | 421.87 ± 1.2% | 0.93 | 1.00 | 4.54 | 0.94 |
| class: a word that ends in ing | 9 | 511.93 ± 1.0% | 588.17 ± 6.7% | 1005.84 ± 4.6% | 113.13 ± 2.0% | 626.30 ± 1.9% | 1413.40 ± 0.8% | 14825.70 ± 0.6% | 513.29 ± 0.4% | 0.87 | 1.00 | 4.53 | 0.82 |
| class: a word in capitals | 16 | 446.85 ± 3.1% | 484.28 ± 0.4% | 779.11 ± 5.5% | 121.07 ± 3.5% | 639.65 ± 1.9% | 1307.16 ± 3.0% | 8212.36 ± 0.9% | 449.38 ± 0.4% | 0.92 | 0.99 | 3.69 | 0.70 |
| class: a number | 6 | 575.45 ± 2.4% | 637.47 ± 2.3% | 1162.31 ± 1.9% | 35.13 ± 3.7% | 1123.80 ± 3.8% | 2307.04 ± 2.2% | 20041.90 ± 16.8% | 575.46 ± 2.3% | 0.90 | 1.00 | 16.38 | 0.51 |
| class: two capitalized words, second text | 23 | 419.92 ± 2.3% | 450.20 ± 2.4% | 631.93 ± 3.6% | 94.39 ± 0.8% | 422.49 ± 40.0% | 946.52 ± 0.5% | 6109.61 ± 25.5% | 422.25 ± 0.4% | 0.93 | 0.99 | 4.45 | 0.99 |
| other: a word between two words | 13 | 507.71 ± 6.5% | 530.88 ± 6.0% | 809.91 ± 5.6% | 122.55 ± 0.7% | 435.74 ± 1.0% | 1028.86 ± 0.5% | 12698.37 ± 3.1% | 508.50 ± 11.6% | 0.96 | 1.00 | 4.14 | 1.17 |
| other: a number before a unit, second text | 15 | 360.68 ± 0.5% | 403.88 ± 0.3% | 550.85 ± 0.6% | 33.56 ± 1.3% | 535.47 ± 0.5% | 1126.94 ± 13.8% | 12876.50 ± 1.5% | 359.77 ± 0.9% | 0.89 | 1.00 | 10.75 | 0.67 |
| other: a heading's start tag | 13 | 330.46 ± 7.8% | 336.16 ± 0.4% | 438.77 ± 9.3% | 35.40 ± 0.8% | 521.50 ± 1.4% | 1066.77 ± 1.1% | 15316.12 ± 4.6% | 330.33 ± 0.2% | 0.98 | 1.00 | 9.34 | 0.63 |
| other: a whole word | 11 | 506.87 ± 6.8% | 539.94 ± 2.2% | 828.79 ± 0.6% | 111.01 ± 0.8% | 494.29 ± 13.2% | 1033.33 ± 1.5% | 18911.18 ± 3.4% | 506.86 ± 11.0% | 0.94 | 1.00 | 4.57 | 1.03 |
| other: a line's first word, second text | 17 | 485.52 ± 5.5% | 511.92 ± 1.7% | 807.00 ± 0.4% | 117.39 ± 0.4% | 591.75 ± 2.5% | refused | refused | 483.17 ± 1.1% | 0.95 | 1.00 | 4.14 | 0.82 |
| other: fourteen octets before an x | 16 | 88.09 ± 0.3% | 125.04 ± 0.4% | 141.60 ± 0.9% | 14.30 ± 0.7% | 394.13 ± 2.7% | 452.41 ± 2.1% | 11752.80 ± 0.2% | 88.01 ± 0.6% | 0.70 | 1.00 | 6.16 | 0.22 |
| other: a Greek word | 8 | 387.67 ± 0.3% | 539.21 ± 0.6% | 882.51 ± 0.1% | 46.94 ± 0.7% | 1134.81 ± 5.5% | 2214.81 ± 1.4% | refused | 388.10 ± 0.4% | 0.72 | 1.00 | 8.26 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 26740.01 ± 3.0% | not timed | not timed | 26961.49 ± 0.6% | 1849.80 ± 12.5% | not timed | not timed | 26544.51 ± 1.0% | | 1.01 | 0.99 | 14.46 |
| 01-literal/sherlock-casei-en | 522 | 7987.58 ± 1.3% | not timed | not timed | 7052.76 ± 1.8% | 23.44 ± 8.8% | not timed | not timed | 7975.50 ± 1.9% | | 1.00 | 1.13 | 340.73 |
| 01-literal/sherlock-ru | 724 | 27951.88 ± 1.5% | not timed | not timed | 27577.76 ± 1.2% | 1084.15 ± 5.8% | not timed | not timed | 27799.48 ± 0.6% | | 1.01 | 1.01 | 25.78 |
| 01-literal/sherlock-casei-ru | 746 | 9688.77 ± 0.1% | not timed | not timed | 5436.05 ± 0.3% | 29.78 ± 1.8% | not timed | not timed | 9652.01 ± 0.7% | | 1.00 | 1.78 | 325.36 |
| 01-literal/sherlock-zh | 30 | 46229.02 ± 3.1% | not timed | not timed | 36333.37 ± 1.3% | 1263.72 ± 0.6% | not timed | not timed | 45906.34 ± 0.8% | | 1.01 | 1.27 | 36.58 |
| 02-literal-alternate/sherlock-en | 714 | 10054.01 ± 7.9% | not timed | not timed | 8915.01 ± 0.3% | 14.30 ± 1.6% | not timed | not timed | 10084.79 ± 0.6% | | 1.00 | 1.13 | 703.21 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2035.59 ± 1.6% | not timed | not timed | 1822.10 ± 0.3% | 8.72 ± 10.0% | not timed | not timed | 2039.51 ± 1.6% | | 1.00 | 1.12 | 233.32 |
| 02-literal-alternate/sherlock-ru | 899 | 8163.71 ± 3.7% | not timed | not timed | 4265.56 ± 0.3% | 19.04 ± 0.5% | not timed | not timed | 8189.19 ± 0.3% | | 1.00 | 1.91 | 428.74 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2092.59 ± 0.3% | not timed | not timed | 1045.74 ± 0.2% | 8.41 ± 2.7% | not timed | not timed | 2095.82 ± 0.2% | | 1.00 | 2.00 | 248.96 |
| 02-literal-alternate/sherlock-zh | 207 | 14459.16 ± 5.2% | not timed | not timed | 10443.29 ± 0.3% | 26.56 ± 1.0% | not timed | not timed | 14487.11 ± 8.8% | | 1.00 | 1.38 | 544.47 |
| 03-date/ascii | 111817 | 96.65 ± 0.5% | not timed | not timed | 84.88 ± 0.7% | 0.18 ± 4.4% | not timed | not timed | 96.25 ± 0.6% | | 1.00 | 1.14 | 544.17 |
| 04-ruff-noqa/real | 84 | 411.28 ± 0.3% | not timed | not timed | 427.00 ± 0.3% | 16.29 ± 1.9% | not timed | not timed | 411.65 ± 7.8% | | 1.00 | 0.96 | 25.25 |
| 04-ruff-noqa/tweaked | 44 | 514.92 ± 0.3% | not timed | not timed | 406.90 ± 0.4% | 295.18 ± 0.4% | not timed | not timed | 510.62 ± 0.5% | | 1.01 | 1.27 | 1.74 |
| 05-lexer-veryl/single | 124800 | 3.46 ± 6.1% | not timed | not timed | 4.10 ± 0.6% | 0.21 ± 4.2% | not timed | not timed | 3.40 ± 1.7% | | 1.02 | 0.85 | 16.65 |
| 06-cloud-flare-redos/original | 107 | 347.48 ± 0.7% | not timed | not timed | 192.86 ± 1.3% | 20.48 ± 0.8% | not timed | not timed | 348.05 ± 0.2% | | 1.00 | 1.80 | 16.97 |
| 06-cloud-flare-redos/simplified-short | 102 | 329.76 ± 0.3% | not timed | not timed | 192.36 ± 0.2% | 21.88 ± 1.2% | not timed | not timed | 330.73 ± 0.5% | | 1.00 | 1.71 | 15.07 |
| 06-cloud-flare-redos/simplified-long | 10000 | 464.95 ± 1.2% | not timed | not timed | 211.79 ± 0.1% | 24.12 ± 0.5% | not timed | not timed | 464.78 ± 1.4% | | 1.00 | 2.20 | 19.27 |
| 07-unicode-character-data/parse-line | 558784 | 191.19 ± 6.0% | not timed | not timed | 161.87 ± 0.6% | 37.73 ± 6.4% | not timed | not timed | 205.74 ± 2.0% | | 0.93 | 1.18 | 5.07 |
| 08-words/all-english | 56691 | 96.66 ± 19.2% | not timed | not timed | 72.07 ± 2.4% | 10.17 ± 5.5% | not timed | not timed | 96.53 ± 0.6% | | 1.00 | 1.34 | 9.51 |
| 08-words/long-english | 839 | 536.53 ± 0.2% | not timed | not timed | 515.64 ± 0.6% | 26.24 ± 9.6% | not timed | not timed | 536.30 ± 1.1% | | 1.00 | 1.04 | 20.45 |
| 09-aws-keys/full | 0 | 416.25 ± 7.1% | not timed | not timed | 444.81 ± 2.0% | 54.59 ± 6.1% | not timed | not timed | 414.92 ± 0.8% | | 1.00 | 0.94 | 7.62 |
| 09-aws-keys/quick | 0 | 970.19 ± 0.1% | not timed | not timed | 804.67 ± 8.0% | 331.56 ± 0.1% | not timed | not timed | 968.14 ± 5.7% | | 1.00 | 1.21 | 2.93 |
| 10-bounded-repeat/letters-en | 1833 | 482.96 ± 3.4% | not timed | not timed | 432.10 ± 2.6% | 16.90 ± 1.1% | not timed | not timed | 484.01 ± 0.4% | | 1.00 | 1.12 | 28.58 |
| 10-bounded-repeat/letters-ru | 3475 | 428.64 ± 0.4% | not timed | not timed | 409.17 ± 0.1% | 18.06 ± 13.4% | not timed | not timed | 429.52 ± 1.0% | | 1.00 | 1.05 | 23.73 |
| 10-bounded-repeat/context | 53 | 65.60 ± 1.3% | not timed | not timed | 56.10 ± 0.7% | 16.93 ± 2.7% | not timed | not timed | 65.34 ± 0.9% | | 1.00 | 1.17 | 3.87 |
| 10-bounded-repeat/capitals | 11 | 558.21 ± 7.9% | not timed | not timed | 531.67 ± 0.1% | 30.92 ± 4.8% | not timed | not timed | 554.07 ± 8.4% | | 1.01 | 1.05 | 18.05 |
| 11-unstructured-to-json/extract | 600 | 56.67 ± 0.3% | not timed | not timed | 62.02 ± 1.0% | 40.77 ± 1.7% | not timed | not timed | 56.67 ± 1.5% | | 1.00 | 0.91 | 1.39 |
| 12-dictionary/single | 1 | 458.44 ± 0.4% | not timed | not timed | 443.03 ± 0.8% | 0.32 ± 0.9% | not timed | not timed | 460.44 ± 0.3% | | 1.00 | 1.03 | 1427.66 |
| 14-quadratic/1x | 100 | 21.14 ± 0.6% | not timed | not timed | 9.12 ± 0.4% | 0.81 ± 2.6% | not timed | not timed | 21.01 ± 1.1% | | 1.01 | 2.32 | 26.26 |
| 14-quadratic/2x | 200 | 16.20 ± 0.9% | not timed | not timed | 4.92 ± 0.3% | 0.43 ± 1.2% | not timed | not timed | 16.17 ± 0.4% | | 1.00 | 3.29 | 37.60 |
| 14-quadratic/10x | 1000 | 5.62 ± 0.2% | not timed | not timed | 1.05 ± 0.3% | 0.09 ± 6.7% | not timed | not timed | 5.63 ± 0.4% | | 1.00 | 5.35 | 60.96 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.13 ± 2.4% | not timed | not timed | 0.39 ± 0.4% | 0.48 ± 3.6% | not timed | not timed | 1.11 ± 1.8% | | 1.02 | 2.93 | 2.35 |
| 04-ruff-noqa/compile-real | 1 | 79.54 ± 0.9% | not timed | not timed | 12.96 ± 4.7% | 124.27 ± 4.0% | not timed | not timed | 79.35 ± 1.3% | | 1.00 | 6.14 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 12.00 ± 2.0% | not timed | not timed | 2.29 ± 4.8% | 5.57 ± 4.4% | not timed | not timed | 11.99 ± 2.9% | | 1.00 | 5.24 | 2.16 |
| 07-unicode-character-data/compile | 1 | 49.63 ± 8.6% | not timed | not timed | 24.37 ± 0.9% | 32.48 ± 4.9% | not timed | not timed | 49.40 ± 2.8% | | 1.00 | 2.04 | 1.53 |
| 09-aws-keys/compile-full | 1 | 34.01 ± 0.7% | not timed | not timed | 7.44 ± 0.7% | 19.71 ± 5.5% | not timed | not timed | 33.79 ± 3.0% | | 1.01 | 4.57 | 1.73 |
| 09-aws-keys/compile-quick | 1 | 155.25 ± 2.1% | not timed | not timed | 45.22 ± 12.3% | 116.69 ± 4.5% | not timed | not timed | 153.53 ± 0.9% | | 1.01 | 3.43 | 1.33 |
| 10-bounded-repeat/compile-context | 1 | 10.56 ± 0.2% | not timed | not timed | 11.83 ± 0.6% | 14.87 ± 3.7% | not timed | not timed | 10.50 ± 1.0% | | 1.01 | 0.89 | 0.71 |
| 10-bounded-repeat/compile-capitals | 1 | 72.16 ± 1.5% | not timed | not timed | 8.86 ± 2.6% | 21.98 ± 2.6% | not timed | not timed | 72.91 ± 1.2% | | 0.99 | 8.14 | 3.28 |
| 11-unstructured-to-json/compile | 1 | 74.83 ± 0.7% | not timed | not timed | 37.32 ± 6.2% | 60.30 ± 3.7% | not timed | not timed | 74.73 ± 0.0% | | 1.00 | 2.01 | 1.24 |
| 12-dictionary/compile-single | 1 | 0.28 ± 0.7% | not timed | not timed | 0.07 ± 39.9% | 0.09 ± 15.3% | not timed | not timed | 0.28 ± 1.5% | | 1.02 | 4.10 | 3.27 |

