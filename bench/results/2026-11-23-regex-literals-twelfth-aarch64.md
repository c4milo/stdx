# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243520475 |
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
| literal: a word | 217 | 19807.46 ± 2.2% | 4999.15 ± 0.3% | 28.29 ± 0.3% | 18320.59 ± 3.8% | 9223.86 ± 8.8% | 17.19 ± 0.4% | 84.15 ± 0.3% | 19797.93 ± 2.7% | 3.96 | 1.00 | 1.08 | 2.15 |
| literal: a word that is not there | 0 | 21560.77 ± 2.7% | 4879.71 ± 0.2% | 28.38 ± 0.2% | 19704.16 ± 2.4% | 29160.06 ± 0.6% | 17.03 ± 0.1% | 79.31 ± 0.3% | 21693.26 ± 1.7% | 4.42 | 0.99 | 1.09 | 0.74 |
| literal: one of four words | 661 | 6380.39 ± 0.8% | 1933.78 ± 0.2% | 14.46 ± 0.3% | 3946.27 ± 1.1% | 21.86 ± 0.2% | 5.38 ± 0.2% | 6.87 ± 0.2% | 6355.26 ± 0.2% | 3.30 | 1.00 | 1.62 | 291.82 |
| literal: a word in any case | 217 | 15168.39 ± 0.2% | 2077.74 ± 0.3% | 21.49 ± 0.2% | 3975.19 ± 0.2% | 38.07 ± 0.2% | refused | differs | 15149.30 ± 0.2% | 7.30 | 1.00 | 3.82 | 398.45 |
| literal: an href attribute | 33 | 16930.70 ± 1.1% | 609.10 ± 0.4% | 27.37 ± 0.4% | 17082.34 ± 0.9% | 2251.98 ± 6.1% | 12.88 ± 0.6% | 73.95 ± 0.6% | 16877.47 ± 0.3% | 27.80 | 1.00 | 0.99 | 7.52 |
| literal: a word, second text | 123 | 19933.47 ± 1.3% | 3356.96 ± 0.2% | 28.06 ± 0.3% | 18614.69 ± 1.0% | 7635.87 ± 5.1% | 19.98 ± 0.3% | 69.91 ± 0.4% | 19795.91 ± 1.7% | 5.94 | 1.01 | 1.07 | 2.61 |
| class: two capitalized words | 1331 | 1057.77 ± 0.2% | 599.36 ± 0.3% | 26.00 ± 0.3% | 582.42 ± 0.1% | 40.59 ± 2.8% | 14.78 ± 0.3% | 67.25 ± 1.6% | 1057.66 ± 0.2% | 1.76 | 1.00 | 1.82 | 26.06 |
| class: a word that ends in ing | 3399 | 573.80 ± 0.1% | 573.02 ± 0.3% | 17.99 ± 0.1% | 545.41 ± 0.1% | 29.62 ± 9.2% | 8.13 ± 0.1% | 18.24 ± 0.3% | 573.32 ± 0.3% | 1.00 | 1.00 | 1.05 | 19.37 |
| class: a word in capitals | 2332 | 1356.61 ± 0.4% | 603.07 ± 0.3% | 27.70 ± 0.2% | 572.72 ± 0.1% | 43.67 ± 0.2% | 17.15 ± 0.3% | 82.48 ± 0.3% | 1372.33 ± 0.2% | 2.25 | 0.99 | 2.37 | 31.07 |
| class: a number | 8288 | 1956.55 ± 0.3% | 826.84 ± 0.1% | 27.79 ± 0.7% | 1713.54 ± 0.1% | 41.00 ± 16.2% | 0.52 ± 0.8% | 57.29 ± 1.0% | 1954.33 ± 0.6% | 2.37 | 1.00 | 1.14 | 47.72 |
| class: two capitalized words, second text | 5359 | 515.70 ± 0.3% | 524.30 ± 0.4% | 23.33 ± 0.2% | 486.68 ± 0.1% | 32.84 ± 9.3% | 17.39 ± 0.2% | 62.74 ± 0.4% | 515.56 ± 0.2% | 0.98 | 1.00 | 1.06 | 15.70 |
| other: a word between two words | 6104 | 792.33 ± 0.1% | 594.12 ± 0.2% | 23.54 ± 0.3% | 739.53 ± 0.2% | 110.43 ± 10.9% | 11.28 ± 0.2% | 68.06 ± 1.5% | 790.92 ± 0.2% | 1.33 | 1.00 | 1.07 | 7.18 |
| other: a number before a unit, second text | 1481 | 5969.25 ± 1.2% | 1118.43 ± 0.2% | 26.07 ± 0.2% | 5343.53 ± 0.6% | 40.73 ± 10.9% | 18.26 ± 0.2% | 65.63 ± 1.0% | 5945.54 ± 0.5% | 5.34 | 1.00 | 1.12 | 146.56 |
| other: a heading's start tag | 110 | 14123.08 ± 0.7% | 742.43 ± 0.2% | 27.43 ± 0.3% | 1717.00 ± 0.5% | 1585.55 ± 6.0% | 16.12 ± 0.3% | 86.16 ± 0.9% | 14162.24 ± 0.7% | 19.02 | 1.00 | 8.23 | 8.91 |
| other: a whole word | 217 | 16000.50 ± 0.8% | 603.73 ± 0.3% | 29.26 ± 0.1% | 14606.36 ± 0.7% | 49.48 ± 0.1% | 13.30 ± 0.2% | 54.43 ± 1.7% | 15952.13 ± 1.1% | 26.50 | 1.00 | 1.10 | 323.40 |
| other: a line's first word, second text | 3716 | 2043.36 ± 0.6% | 587.70 ± 0.3% | 30.96 ± 0.3% | 1733.80 ± 0.8% | 62.72 ± 7.0% | refused | refused | 2039.64 ± 0.3% | 3.48 | 1.00 | 1.18 | 32.58 |
| other: fourteen octets before an x | 87 | 23929.77 ± 0.8% | 241.56 ± 0.6% | 6.55 ± 0.1% | 4020.30 ± 0.7% | 10.65 ± 0.2% | differs | 17.68 ± 0.2% | 23807.46 ± 0.2% | 99.06 | 1.01 | 5.95 | 2247.33 |
| other: a Greek word | 21815 | 488.59 ± 0.6% | 407.78 ± 0.2% | 30.88 ± 0.2% | 289.81 ± 0.8% | 48.77 ± 11.2% | differs | refused | 484.39 ± 0.5% | 1.20 | 1.01 | 1.69 | 10.02 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.44 ± 0.2% | 18.48 ± 0.1% | 0.86 ± 0.5% | 19.79 ± 0.2% | 2.77 ± 0.5% | differs | 3.90 ± 0.2% | 18.49 ± 0.2% | 1.00 | 1.00 | 0.93 | 6.65 |
| a UUID | 32895 | 20.08 ± 0.3% | 20.10 ± 0.1% | 0.64 ± 0.2% | 15.19 ± 0.3% | 3.10 ± 0.5% | 0.73 ± 0.2% | 3.64 ± 0.7% | 20.11 ± 0.1% | 1.00 | 1.00 | 1.32 | 6.48 |
| an IPv4 address | 33176 | 33.69 ± 0.3% | 33.69 ± 0.1% | 2.09 ± 0.3% | 29.34 ± 0.7% | 6.61 ± 0.1% | differs | 4.15 ± 0.3% | 33.68 ± 0.2% | 1.00 | 1.00 | 1.15 | 5.10 |
| a date and time | 32954 | 28.85 ± 0.3% | 28.90 ± 0.3% | 1.45 ± 0.2% | 21.65 ± 0.4% | 7.05 ± 0.1% | 1.25 ± 0.2% | 7.19 ± 0.8% | 28.92 ± 0.2% | 1.00 | 1.00 | 1.33 | 4.09 |
| a field path | 32606 | 21.78 ± 0.3% | 21.78 ± 0.2% | 1.02 ± 0.2% | 23.29 ± 0.3% | 3.51 ± 0.8% | differs | 2.94 ± 0.2% | 21.79 ± 0.3% | 1.00 | 1.00 | 0.93 | 6.21 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.10 ± 0.3% | 11.00 ± 0.1% | 11.11 ± 0.3% | 11.50 ± 0.2% | 4.96 ± 1.6% | 0.94 ± 0.5% | none | 11.10 ± 0.3% | 1.01 | 1.00 | 0.97 | 2.24 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 229.55 ± 0.3% | 230.35 ± 0.2% | 269.84 ± 0.2% | 87.27 ± 0.5% | 219.92 ± 4.2% | 483.09 ± 0.8% | 3822.02 ± 0.3% | 229.25 ± 0.2% | 1.00 | 1.00 | 2.63 | 1.04 |
| a UUID | 62 | 147.95 ± 0.6% | 148.20 ± 0.3% | 164.26 ± 0.3% | 46.55 ± 0.3% | 99.38 ± 0.7% | 185.86 ± 2.8% | 4290.78 ± 0.6% | 148.00 ± 0.2% | 1.00 | 1.00 | 3.18 | 1.49 |
| an IPv4 address | 29 | 426.16 ± 0.3% | 429.22 ± 0.2% | 590.75 ± 0.5% | 77.58 ± 0.7% | 131.20 ± 1.4% | 294.61 ± 1.6% | 7635.35 ± 0.4% | 425.75 ± 0.4% | 0.99 | 1.00 | 5.49 | 3.25 |
| a date and time | 56 | 306.51 ± 0.2% | 308.00 ± 0.3% | 382.53 ± 0.2% | 73.49 ± 0.6% | 137.46 ± 0.7% | 317.55 ± 1.3% | 4965.18 ± 0.4% | 306.48 ± 0.2% | 1.00 | 1.00 | 4.17 | 2.23 |
| a field path | 39 | 220.99 ± 0.2% | 221.70 ± 0.3% | 258.06 ± 0.4% | 80.94 ± 0.2% | 205.07 ± 0.6% | 503.60 ± 2.1% | 4874.21 ± 0.7% | 221.11 ± 0.5% | 1.00 | 1.00 | 2.73 | 1.08 |
| literal: a word | 7 | 644.14 ± 0.2% | 697.34 ± 0.5% | 1237.23 ± 0.2% | 525.49 ± 0.2% | 628.95 ± 3.2% | 946.43 ± 0.2% | 30749.41 ± 0.2% | 643.83 ± 0.4% | 0.92 | 1.00 | 1.23 | 1.02 |
| literal: a word that is not there | 8 | 616.39 ± 0.8% | 672.82 ± 0.9% | 1164.84 ± 0.4% | 473.73 ± 0.5% | 603.00 ± 1.9% | 899.27 ± 0.5% | 29654.33 ± 0.2% | 616.23 ± 0.2% | 0.92 | 1.00 | 1.30 | 1.02 |
| literal: one of four words | 26 | 248.80 ± 0.4% | 404.19 ± 0.6% | 543.21 ± 1.1% | 49.41 ± 0.5% | 242.79 ± 2.0% | 362.84 ± 1.6% | 16113.69 ± 0.2% | 248.71 ± 0.2% | 0.62 | 1.00 | 5.03 | 1.02 |
| literal: a word in any case | 11 | 448.99 ± 0.2% | 481.89 ± 0.4% | 693.86 ± 0.1% | 15.74 ± 0.2% | 654.23 ± 3.2% | refused | 23843.33 ± 0.4% | 448.55 ± 0.1% | 0.93 | 1.00 | 28.52 | 0.69 |
| literal: an href attribute | 12 | 349.99 ± 0.5% | 364.03 ± 0.8% | 473.22 ± 0.5% | 45.74 ± 0.7% | 504.46 ± 1.1% | 777.44 ± 0.6% | 22175.61 ± 0.3% | 349.78 ± 0.3% | 0.96 | 1.00 | 7.65 | 0.69 |
| literal: a word, second text | 10 | 574.79 ± 0.2% | 635.60 ± 0.3% | 1054.91 ± 0.4% | 427.93 ± 0.7% | 536.62 ± 1.0% | 809.93 ± 0.3% | 27624.59 ± 0.3% | 574.89 ± 0.4% | 0.90 | 1.00 | 1.34 | 1.07 |
| class: two capitalized words | 23 | 443.59 ± 0.4% | 473.55 ± 0.4% | 679.00 ± 0.3% | 101.13 ± 0.1% | 506.81 ± 0.9% | 741.85 ± 0.4% | 6486.49 ± 0.6% | 443.60 ± 0.2% | 0.94 | 1.00 | 4.39 | 0.88 |
| class: a word that ends in ing | 9 | 577.69 ± 0.4% | 646.07 ± 0.3% | 1118.99 ± 0.2% | 131.64 ± 1.1% | 766.05 ± 2.3% | 1111.90 ± 2.5% | 16014.21 ± 0.3% | 576.68 ± 0.3% | 0.89 | 1.00 | 4.39 | 0.75 |
| class: a word in capitals | 16 | 505.49 ± 0.6% | 544.55 ± 0.8% | 861.50 ± 1.6% | 135.72 ± 0.3% | 758.11 ± 1.5% | 1015.17 ± 0.8% | 8566.78 ± 0.4% | 504.43 ± 1.0% | 0.93 | 1.00 | 3.72 | 0.67 |
| class: a number | 6 | 644.71 ± 0.3% | 709.65 ± 0.6% | 1317.03 ± 0.3% | 41.97 ± 0.6% | 1409.14 ± 0.9% | 1900.21 ± 1.7% | 23116.50 ± 0.1% | 645.01 ± 0.2% | 0.91 | 1.00 | 15.36 | 0.46 |
| class: two capitalized words, second text | 23 | 444.27 ± 0.5% | 474.17 ± 0.2% | 678.99 ± 0.5% | 104.03 ± 0.5% | 503.81 ± 2.3% | 731.93 ± 0.5% | 6507.43 ± 0.6% | 443.42 ± 0.5% | 0.94 | 1.00 | 4.27 | 0.88 |
| other: a word between two words | 13 | 556.00 ± 0.3% | 578.91 ± 0.3% | 914.53 ± 0.6% | 135.26 ± 1.0% | 500.25 ± 7.9% | 811.03 ± 1.2% | 14866.48 ± 0.3% | 555.79 ± 0.5% | 0.96 | 1.00 | 4.11 | 1.11 |
| other: a number before a unit, second text | 15 | 400.64 ± 0.4% | 437.91 ± 0.5% | 608.85 ± 0.3% | 39.48 ± 0.4% | 634.17 ± 0.9% | 887.04 ± 0.2% | 15334.22 ± 0.4% | 399.87 ± 0.4% | 0.91 | 1.00 | 10.15 | 0.63 |
| other: a heading's start tag | 13 | 360.30 ± 0.3% | 368.23 ± 0.7% | 480.58 ± 0.5% | 44.56 ± 0.4% | 625.13 ± 9.6% | 862.45 ± 1.0% | 18423.35 ± 0.3% | 360.04 ± 0.4% | 0.98 | 1.00 | 8.09 | 0.58 |
| other: a whole word | 11 | 585.91 ± 0.6% | 627.42 ± 0.4% | 1040.89 ± 0.5% | 122.05 ± 0.7% | 567.45 ± 1.3% | 820.36 ± 0.9% | 27312.32 ± 0.2% | 586.03 ± 0.4% | 0.93 | 1.00 | 4.80 | 1.03 |
| other: a line's first word, second text | 17 | 535.90 ± 0.4% | 561.34 ± 0.2% | 888.75 ± 0.2% | 130.10 ± 0.5% | 718.99 ± 0.5% | refused | refused | 534.28 ± 0.6% | 0.95 | 1.00 | 4.12 | 0.75 |
| other: fourteen octets before an x | 16 | 108.12 ± 0.3% | 154.76 ± 1.2% | 175.76 ± 0.5% | 15.17 ± 0.3% | 458.01 ± 1.4% | 413.88 ± 0.4% | 13014.94 ± 0.6% | 108.05 ± 0.4% | 0.70 | 1.00 | 7.13 | 0.24 |
| other: a Greek word | 8 | 461.57 ± 0.5% | 617.31 ± 0.2% | 1038.46 ± 0.1% | 59.28 ± 0.3% | 1403.54 ± 0.8% | 1790.78 ± 1.2% | refused | 461.87 ± 0.2% | 0.75 | 1.00 | 7.79 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15740.17 ± 0.9% | not timed | not timed | 16212.43 ± 1.6% | 1999.84 ± 13.4% | not timed | not timed | 15677.95 ± 0.7% | | 1.00 | 0.97 | 7.87 |
| 01-literal/sherlock-casei-en | 522 | 5169.62 ± 1.4% | not timed | not timed | 3593.32 ± 0.1% | 32.55 ± 0.1% | not timed | not timed | 5172.23 ± 0.6% | | 1.00 | 1.44 | 158.81 |
| 01-literal/sherlock-ru | 724 | 17120.01 ± 0.5% | not timed | not timed | 17288.78 ± 0.8% | 1392.34 ± 17.3% | not timed | not timed | 17088.66 ± 1.0% | | 1.00 | 0.99 | 12.30 |
| 01-literal/sherlock-casei-ru | 746 | 6186.02 ± 0.3% | not timed | not timed | 3335.83 ± 0.4% | 30.95 ± 0.3% | not timed | not timed | 6178.46 ± 0.1% | | 1.00 | 1.85 | 199.89 |
| 01-literal/sherlock-zh | 30 | 19884.67 ± 0.3% | not timed | not timed | 18784.57 ± 0.3% | 2667.49 ± 17.9% | not timed | not timed | 19866.65 ± 0.4% | | 1.00 | 1.06 | 7.45 |
| 02-literal-alternate/sherlock-en | 714 | 6054.96 ± 0.3% | not timed | not timed | 3942.56 ± 0.1% | 16.62 ± 0.3% | not timed | not timed | 6053.78 ± 0.1% | | 1.00 | 1.54 | 364.36 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1937.43 ± 0.8% | not timed | not timed | 695.51 ± 0.2% | 11.11 ± 0.1% | not timed | not timed | 1931.34 ± 0.6% | | 1.00 | 2.79 | 174.40 |
| 02-literal-alternate/sherlock-ru | 899 | 5573.74 ± 0.2% | not timed | not timed | 3254.71 ± 0.1% | 22.65 ± 0.2% | not timed | not timed | 5574.07 ± 0.3% | | 1.00 | 1.71 | 246.10 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2061.97 ± 0.6% | not timed | not timed | 1231.83 ± 0.1% | 9.07 ± 0.1% | not timed | not timed | 2052.71 ± 0.1% | | 1.00 | 1.67 | 227.30 |
| 02-literal-alternate/sherlock-zh | 207 | 7258.64 ± 0.3% | not timed | not timed | 4163.84 ± 0.1% | 31.52 ± 0.1% | not timed | not timed | 7270.88 ± 0.3% | | 1.00 | 1.74 | 230.28 |
| 03-date/ascii | 111817 | 123.80 ± 0.3% | not timed | not timed | 96.43 ± 0.2% | 0.20 ± 1.1% | not timed | not timed | 123.10 ± 1.0% | | 1.01 | 1.28 | 611.48 |
| 04-ruff-noqa/real | 84 | 402.25 ± 0.0% | not timed | not timed | 463.18 ± 0.1% | 19.56 ± 1.4% | not timed | not timed | 402.37 ± 0.1% | | 1.00 | 0.87 | 20.57 |
| 04-ruff-noqa/tweaked | 44 | 559.63 ± 0.2% | not timed | not timed | 461.64 ± 0.1% | 365.37 ± 0.5% | not timed | not timed | 560.75 ± 0.3% | | 1.00 | 1.21 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.35 ± 0.3% | not timed | not timed | 5.17 ± 0.2% | 0.21 ± 3.3% | not timed | not timed | 5.33 ± 4.1% | | 1.00 | 1.04 | 25.97 |
| 06-cloud-flare-redos/original | 107 | 415.47 ± 0.1% | not timed | not timed | 216.90 ± 0.1% | 24.84 ± 0.1% | not timed | not timed | 415.45 ± 0.1% | | 1.00 | 1.92 | 16.73 |
| 06-cloud-flare-redos/simplified-short | 102 | 411.30 ± 0.1% | not timed | not timed | 227.88 ± 0.1% | 26.71 ± 0.1% | not timed | not timed | 411.94 ± 0.2% | | 1.00 | 1.80 | 15.40 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.82 ± 0.2% | not timed | not timed | 255.41 ± 0.1% | 28.83 ± 0.1% | not timed | not timed | 583.25 ± 0.1% | | 1.00 | 2.29 | 20.25 |
| 07-unicode-character-data/parse-line | 558784 | 231.88 ± 1.3% | not timed | not timed | 181.19 ± 0.1% | 43.25 ± 5.5% | not timed | not timed | 231.63 ± 2.2% | | 1.00 | 1.28 | 5.36 |
| 08-words/all-english | 56691 | 116.55 ± 0.4% | not timed | not timed | 83.01 ± 0.1% | 12.11 ± 9.7% | not timed | not timed | 116.41 ± 0.7% | | 1.00 | 1.40 | 9.62 |
| 08-words/long-english | 839 | 613.43 ± 0.2% | not timed | not timed | 597.51 ± 0.1% | 32.64 ± 0.1% | not timed | not timed | 613.72 ± 0.3% | | 1.00 | 1.03 | 18.79 |
| 09-aws-keys/full | 0 | 407.63 ± 0.2% | not timed | not timed | 494.58 ± 0.2% | 64.68 ± 0.1% | not timed | not timed | 407.91 ± 0.1% | | 1.00 | 0.82 | 6.30 |
| 09-aws-keys/quick | 0 | 947.27 ± 0.1% | not timed | not timed | 1001.91 ± 0.2% | 421.04 ± 0.7% | not timed | not timed | 946.40 ± 0.1% | | 1.00 | 0.95 | 2.25 |
| 10-bounded-repeat/letters-en | 1833 | 581.81 ± 1.6% | not timed | not timed | 517.92 ± 0.2% | 19.59 ± 0.6% | not timed | not timed | 580.87 ± 1.7% | | 1.00 | 1.12 | 29.69 |
| 10-bounded-repeat/letters-ru | 3475 | 509.81 ± 1.2% | not timed | not timed | 478.89 ± 0.1% | 21.84 ± 8.1% | not timed | not timed | 505.41 ± 1.2% | | 1.01 | 1.06 | 23.35 |
| 10-bounded-repeat/context | 53 | 77.58 ± 0.6% | not timed | not timed | 66.27 ± 0.5% | 19.79 ± 0.1% | not timed | not timed | 77.31 ± 0.6% | | 1.00 | 1.17 | 3.92 |
| 10-bounded-repeat/capitals | 11 | 636.80 ± 8.3% | not timed | not timed | 615.83 ± 0.1% | 36.58 ± 0.1% | not timed | not timed | 634.84 ± 8.5% | | 1.00 | 1.03 | 17.41 |
| 11-unstructured-to-json/extract | 600 | 79.62 ± 0.2% | not timed | not timed | 76.53 ± 0.1% | 49.13 ± 0.3% | not timed | not timed | 82.54 ± 0.2% | | 0.96 | 1.04 | 1.62 |
| 12-dictionary/single | 1 | 560.22 ± 0.1% | not timed | not timed | 561.42 ± 0.1% | 0.41 ± 0.3% | not timed | not timed | 560.22 ± 0.2% | | 1.00 | 1.00 | 1380.55 |
| 14-quadratic/1x | 100 | 21.24 ± 1.4% | not timed | not timed | 10.02 ± 0.3% | 0.97 ± 2.6% | not timed | not timed | 21.21 ± 1.3% | | 1.00 | 2.12 | 21.99 |
| 14-quadratic/2x | 200 | 17.51 ± 0.2% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 1.8% | not timed | not timed | 17.49 ± 0.4% | | 1.00 | 3.16 | 32.78 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 7.68 ± 0.3% | | 1.00 | 6.34 | 66.62 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.28 ± 0.6% | not timed | not timed | 0.34 ± 0.8% | 0.56 ± 3.3% | not timed | not timed | 1.28 ± 2.7% | | 1.00 | 3.72 | 2.29 |
| 04-ruff-noqa/compile-real | 1 | 90.53 ± 0.1% | not timed | not timed | 13.95 ± 0.4% | 141.00 ± 2.7% | not timed | not timed | 90.46 ± 0.5% | | 1.00 | 6.49 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 13.93 ± 0.3% | not timed | not timed | 2.53 ± 0.2% | 6.47 ± 2.3% | not timed | not timed | 13.92 ± 0.4% | | 1.00 | 5.51 | 2.15 |
| 07-unicode-character-data/compile | 1 | 55.41 ± 0.1% | not timed | not timed | 26.15 ± 0.5% | 36.58 ± 3.9% | not timed | not timed | 54.86 ± 1.1% | | 1.01 | 2.12 | 1.51 |
| 09-aws-keys/compile-full | 1 | 41.86 ± 0.3% | not timed | not timed | 8.31 ± 0.3% | 23.53 ± 0.5% | not timed | not timed | 41.65 ± 0.1% | | 1.01 | 5.04 | 1.78 |
| 09-aws-keys/compile-quick | 1 | 187.14 ± 0.2% | not timed | not timed | 48.17 ± 0.2% | 135.66 ± 1.6% | not timed | not timed | 186.17 ± 1.0% | | 1.01 | 3.89 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 13.64 ± 1.8% | not timed | not timed | 11.20 ± 0.1% | 16.08 ± 15.2% | not timed | not timed | 13.54 ± 4.1% | | 1.01 | 1.22 | 0.85 |
| 10-bounded-repeat/compile-capitals | 1 | 82.75 ± 0.3% | not timed | not timed | 8.09 ± 0.4% | 24.03 ± 2.5% | not timed | not timed | 82.78 ± 0.6% | | 1.00 | 10.23 | 3.44 |
| 11-unstructured-to-json/compile | 1 | 86.66 ± 0.5% | not timed | not timed | 41.00 ± 0.9% | 68.96 ± 3.1% | not timed | not timed | 86.15 ± 0.9% | | 1.01 | 2.11 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.4% | not timed | not timed | 0.07 ± 0.5% | 0.09 ± 15.3% | not timed | not timed | 0.35 ± 0.8% | | 1.01 | 5.10 | 3.79 |

