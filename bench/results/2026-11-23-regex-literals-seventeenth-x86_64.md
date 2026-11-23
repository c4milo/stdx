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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243553228 |
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
| literal: a word | 217 | 39373.19 ± 4.6% | 3339.95 ± 0.5% | 19.98 ± 2.8% | 31151.41 ± 0.9% | 8966.95 ± 8.1% | 10.74 ± 2.1% | 75.99 ± 1.3% | 38231.42 ± 2.1% | 11.79 | 1.03 | 1.26 | 4.39 |
| literal: a word that is not there | 0 | 53256.04 ± 3.9% | 3233.93 ± 0.1% | 20.12 ± 3.9% | 39548.00 ± 0.5% | 29828.31 ± 2.0% | 10.69 ± 0.4% | 71.56 ± 1.0% | 52319.08 ± 1.4% | 16.47 | 1.02 | 1.35 | 1.79 |
| literal: one of four words | 661 | 11563.46 ± 0.7% | 1381.09 ± 1.0% | 10.99 ± 4.7% | 9112.67 ± 0.5% | 19.27 ± 10.3% | 3.98 ± 0.7% | 6.02 ± 0.6% | 11603.91 ± 0.4% | 8.37 | 1.00 | 1.27 | 600.12 |
| literal: a word in any case | 217 | 29920.67 ± 2.1% | 1491.26 ± 0.3% | 15.07 ± 1.5% | 9244.69 ± 0.1% | 37.26 ± 1.2% | refused | differs | 29645.55 ± 1.3% | 20.06 | 1.01 | 3.24 | 802.94 |
| literal: an href attribute | 33 | 28983.82 ± 7.8% | 539.44 ± 17.5% | 18.46 ± 2.4% | 27453.33 ± 0.7% | 2055.13 ± 1.2% | 8.23 ± 13.3% | 63.11 ± 1.6% | 28804.75 ± 1.2% | 53.73 | 1.01 | 1.06 | 14.10 |
| literal: a word, second text | 123 | 37423.21 ± 2.8% | 2365.48 ± 1.9% | 19.53 ± 2.6% | 31209.00 ± 6.8% | 7230.24 ± 3.1% | 11.74 ± 1.3% | 64.82 ± 7.7% | 37082.74 ± 8.3% | 15.82 | 1.01 | 1.20 | 5.18 |
| class: two capitalized words | 1331 | 764.37 ± 0.2% | 526.20 ± 0.4% | 18.59 ± 1.2% | 506.46 ± 0.2% | 34.31 ± 0.7% | 9.31 ± 0.5% | 57.37 ± 0.3% | 764.39 ± 0.3% | 1.45 | 1.00 | 1.51 | 22.28 |
| class: a word that ends in ing | 3399 | 499.90 ± 0.3% | 498.69 ± 0.5% | 12.90 ± 0.4% | 472.80 ± 0.4% | 25.65 ± 2.8% | 5.29 ± 0.3% | 16.50 ± 0.3% | 499.23 ± 0.3% | 1.00 | 1.00 | 1.06 | 19.49 |
| class: a word in capitals | 2332 | 941.60 ± 0.9% | 531.19 ± 0.3% | 19.33 ± 1.6% | 498.44 ± 0.5% | 36.63 ± 2.8% | 9.17 ± 0.4% | 77.66 ± 0.4% | 942.09 ± 0.3% | 1.77 | 1.00 | 1.89 | 25.71 |
| class: a number | 8288 | 1453.35 ± 0.2% | 700.13 ± 0.3% | 19.39 ± 11.1% | 1461.92 ± 0.6% | 36.20 ± 14.3% | 0.33 ± 0.8% | 55.59 ± 10.5% | 1448.11 ± 0.3% | 2.08 | 1.00 | 0.99 | 40.15 |
| class: two capitalized words, second text | 5359 | 442.44 ± 0.5% | 448.14 ± 1.8% | 17.10 ± 3.1% | 417.00 ± 1.3% | 30.21 ± 9.2% | 10.41 ± 0.9% | 52.81 ± 1.2% | 442.02 ± 0.4% | 0.99 | 1.00 | 1.06 | 14.64 |
| other: a word between two words | 6104 | 709.68 ± 0.2% | 510.87 ± 2.3% | 16.78 ± 1.2% | 698.41 ± 0.2% | 105.57 ± 11.2% | 7.23 ± 0.6% | 58.04 ± 0.5% | 708.60 ± 0.6% | 1.39 | 1.00 | 1.02 | 6.72 |
| other: a number before a unit, second text | 1481 | 7291.33 ± 1.4% | 855.78 ± 3.9% | 18.85 ± 3.1% | 6374.25 ± 0.6% | 35.16 ± 7.1% | 10.83 ± 0.2% | 56.10 ± 11.1% | 7250.16 ± 1.7% | 8.52 | 1.01 | 1.14 | 207.38 |
| other: a heading's start tag | 110 | 19383.28 ± 2.9% | 653.70 ± 0.1% | 18.86 ± 3.2% | 2005.80 ± 1.3% | 1479.43 ± 7.0% | 10.03 ± 4.9% | 73.43 ± 30.1% | 18659.81 ± 5.3% | 29.65 | 1.04 | 9.66 | 13.10 |
| other: a whole word | 217 | 23642.06 ± 3.1% | 531.22 ± 0.5% | 19.37 ± 3.2% | 22605.45 ± 35.6% | 40.21 ± 3.5% | 9.41 ± 1.2% | 46.11 ± 1.1% | 22720.37 ± 2.1% | 44.51 | 1.04 | 1.05 | 587.99 |
| other: a line's first word, second text | 3716 | 1926.54 ± 20.0% | 512.36 ± 0.7% | 22.28 ± 1.6% | 1634.74 ± 2.1% | 51.96 ± 4.3% | refused | refused | 1975.59 ± 2.3% | 3.76 | 0.98 | 1.18 | 37.08 |
| other: fourteen octets before an x | 87 | 26788.98 ± 5.0% | 206.95 ± 4.0% | 5.37 ± 5.1% | 2861.06 ± 4.4% | 8.99 ± 3.4% | differs | 14.68 ± 4.8% | 26740.89 ± 4.2% | 129.44 | 1.00 | 9.36 | 2980.81 |
| other: a Greek word | 21815 | 384.96 ± 0.2% | 333.76 ± 0.5% | 23.49 ± 0.6% | 265.39 ± 0.8% | 42.34 ± 12.5% | differs | refused | 383.86 ± 0.6% | 1.15 | 1.00 | 1.45 | 9.09 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 16.94 ± 0.9% | 16.96 ± 0.3% | 0.78 ± 0.6% | 16.76 ± 0.9% | 2.31 ± 0.9% | differs | 3.61 ± 0.4% | 16.97 ± 0.5% | 1.00 | 1.00 | 1.01 | 7.32 |
| a UUID | 32895 | 18.43 ± 0.7% | 18.22 ± 0.4% | 0.54 ± 0.6% | 12.70 ± 0.1% | 2.49 ± 1.2% | 0.44 ± 0.5% | 2.99 ± 4.4% | 18.21 ± 0.7% | 1.01 | 1.01 | 1.45 | 7.40 |
| an IPv4 address | 33176 | 29.52 ± 1.8% | 29.96 ± 2.9% | 1.76 ± 6.9% | 23.92 ± 0.5% | 5.66 ± 2.0% | differs | 3.39 ± 2.2% | 30.51 ± 26.5% | 0.99 | 0.97 | 1.23 | 5.22 |
| a date and time | 32954 | 27.11 ± 0.6% | 27.23 ± 1.1% | 1.23 ± 2.0% | 17.87 ± 0.3% | 6.60 ± 0.8% | 0.76 ± 0.3% | 6.06 ± 1.3% | 27.13 ± 8.7% | 1.00 | 1.00 | 1.52 | 4.11 |
| a field path | 32606 | 19.96 ± 0.6% | 19.95 ± 0.9% | 0.87 ± 2.4% | 19.29 ± 0.8% | 2.90 ± 2.4% | differs | 2.44 ± 1.1% | 19.87 ± 0.4% | 1.00 | 1.00 | 1.03 | 6.87 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.71 ± 0.6% | 8.71 ± 0.3% | 8.55 ± 0.8% | 10.61 ± 0.7% | 4.73 ± 2.7% | 0.63 ± 0.1% | none | 8.68 ± 0.7% | 1.00 | 1.00 | 0.82 | 1.84 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 203.93 ± 8.1% | 203.93 ± 1.1% | 240.80 ± 8.4% | 79.30 ± 4.6% | 183.05 ± 38.3% | 539.04 ± 2.7% | 3533.43 ± 17.1% | 203.70 ± 0.6% | 1.00 | 1.00 | 2.57 | 1.11 |
| a UUID | 62 | 130.74 ± 2.5% | 132.68 ± 10.0% | 148.23 ± 0.6% | 46.56 ± 1.5% | 89.37 ± 19.6% | 200.39 ± 2.0% | 3853.17 ± 5.2% | 131.82 ± 0.3% | 0.99 | 0.99 | 2.81 | 1.46 |
| an IPv4 address | 29 | 380.60 ± 1.0% | 382.76 ± 1.1% | 531.35 ± 1.3% | 70.10 ± 1.6% | 112.13 ± 16.2% | 325.25 ± 2.8% | 6561.33 ± 2.3% | 380.67 ± 1.0% | 0.99 | 1.00 | 5.43 | 3.39 |
| a date and time | 56 | 277.06 ± 0.6% | 278.45 ± 0.6% | 346.14 ± 0.4% | 68.31 ± 1.7% | 120.58 ± 14.1% | 370.85 ± 1.8% | 3837.77 ± 4.0% | 277.45 ± 1.5% | 1.00 | 1.00 | 4.06 | 2.30 |
| a field path | 39 | 204.36 ± 0.8% | 205.68 ± 0.6% | 241.97 ± 0.7% | 74.62 ± 2.7% | 172.37 ± 2.5% | 600.26 ± 6.4% | 4433.50 ± 0.5% | 204.36 ± 0.1% | 0.99 | 1.00 | 2.74 | 1.19 |
| literal: a word | 7 | 568.70 ± 1.2% | 611.80 ± 0.7% | 1053.97 ± 11.5% | 483.86 ± 0.6% | 579.83 ± 1.6% | 1224.67 ± 1.9% | 24325.12 ± 19.4% | 566.83 ± 1.1% | 0.93 | 1.00 | 1.18 | 0.98 |
| literal: a word that is not there | 8 | 540.41 ± 10.3% | 587.62 ± 15.8% | 1000.93 ± 9.3% | 445.17 ± 1.4% | 558.29 ± 1.9% | 1163.69 ± 1.0% | 23352.29 ± 2.0% | 544.81 ± 1.7% | 0.92 | 0.99 | 1.21 | 0.97 |
| literal: one of four words | 26 | 210.84 ± 7.5% | 353.32 ± 0.4% | 473.37 ± 1.5% | 41.52 ± 4.1% | 216.59 ± 1.9% | 439.83 ± 8.4% | 9877.75 ± 0.3% | 210.74 ± 1.4% | 0.60 | 1.00 | 5.08 | 0.97 |
| literal: a word in any case | 11 | 395.93 ± 0.5% | 403.94 ± 6.9% | 593.38 ± 4.1% | 14.53 ± 1.1% | 602.22 ± 3.3% | refused | 18609.34 ± 11.6% | 394.75 ± 0.3% | 0.98 | 1.00 | 27.25 | 0.66 |
| literal: an href attribute | 12 | 321.02 ± 33.7% | 335.97 ± 32.9% | 446.14 ± 10.1% | 36.51 ± 5.5% | 425.24 ± 3.8% | 963.00 ± 2.2% | 17281.96 ± 1.6% | 318.60 ± 2.7% | 0.96 | 1.01 | 8.79 | 0.75 |
| literal: a word, second text | 10 | 500.28 ± 3.9% | 551.42 ± 11.6% | 895.38 ± 1.2% | 411.66 ± 1.5% | 480.79 ± 2.1% | 1028.52 ± 0.4% | 20243.45 ± 1.0% | 501.15 ± 0.4% | 0.91 | 1.00 | 1.22 | 1.04 |
| class: two capitalized words | 23 | 410.11 ± 1.3% | 437.28 ± 20.2% | 642.97 ± 3.8% | 95.85 ± 0.4% | 446.36 ± 11.3% | 900.53 ± 3.0% | 6102.30 ± 2.0% | 403.10 ± 2.4% | 0.94 | 1.02 | 4.28 | 0.92 |
| class: a word that ends in ing | 9 | 480.78 ± 3.5% | 561.43 ± 3.2% | 983.41 ± 2.5% | 114.13 ± 3.5% | 615.56 ± 4.1% | 1446.21 ± 9.0% | 14726.70 ± 14.4% | 490.89 ± 3.2% | 0.86 | 0.98 | 4.21 | 0.78 |
| class: a word in capitals | 16 | 424.84 ± 1.4% | 459.92 ± 1.1% | 762.30 ± 2.4% | 121.45 ± 1.1% | 635.38 ± 1.7% | 1256.31 ± 1.9% | 8222.29 ± 1.0% | 425.64 ± 1.1% | 0.92 | 1.00 | 3.50 | 0.67 |
| class: a number | 6 | 543.70 ± 0.7% | 602.15 ± 0.8% | 1166.02 ± 0.3% | 36.45 ± 0.7% | 1158.61 ± 16.0% | 2239.39 ± 3.6% | 20169.69 ± 1.0% | 545.26 ± 0.4% | 0.90 | 1.00 | 14.92 | 0.47 |
| class: two capitalized words, second text | 23 | 410.03 ± 3.3% | 437.20 ± 2.3% | 623.32 ± 3.5% | 96.66 ± 0.7% | 443.34 ± 2.5% | 912.28 ± 1.7% | 6126.00 ± 30.8% | 410.13 ± 1.9% | 0.94 | 1.00 | 4.24 | 0.92 |
| other: a word between two words | 13 | 488.91 ± 0.3% | 511.75 ± 0.3% | 797.06 ± 0.4% | 123.38 ± 1.5% | 430.28 ± 2.4% | 993.72 ± 27.0% | 12377.05 ± 9.3% | 489.48 ± 1.4% | 0.96 | 1.00 | 3.96 | 1.14 |
| other: a number before a unit, second text | 15 | 365.50 ± 7.7% | 411.48 ± 0.7% | 581.27 ± 0.5% | 33.72 ± 6.5% | 524.56 ± 2.2% | 1123.05 ± 2.1% | 12752.08 ± 8.2% | 365.72 ± 0.4% | 0.89 | 1.00 | 10.84 | 0.70 |
| other: a heading's start tag | 13 | 333.23 ± 3.2% | 341.58 ± 0.6% | 455.36 ± 0.8% | 35.01 ± 3.7% | 517.65 ± 2.1% | 1081.72 ± 3.9% | 15368.38 ± 6.5% | 333.29 ± 3.0% | 0.98 | 1.00 | 9.52 | 0.64 |
| other: a whole word | 11 | 491.18 ± 0.9% | 525.09 ± 1.3% | 825.34 ± 6.0% | 110.81 ± 2.3% | 500.79 ± 3.0% | 1073.65 ± 1.9% | 18882.44 ± 0.9% | 492.09 ± 1.1% | 0.94 | 1.00 | 4.43 | 0.98 |
| other: a line's first word, second text | 17 | 470.54 ± 1.2% | 497.92 ± 0.8% | 816.13 ± 5.1% | 114.63 ± 1.9% | 590.50 ± 6.0% | refused | refused | 470.15 ± 0.1% | 0.95 | 1.00 | 4.10 | 0.80 |
| other: fourteen octets before an x | 16 | 87.02 ± 1.1% | 123.04 ± 0.8% | 142.13 ± 0.3% | 14.13 ± 0.9% | 395.50 ± 2.9% | 459.55 ± 1.3% | 11737.29 ± 0.8% | 87.00 ± 0.5% | 0.71 | 1.00 | 6.16 | 0.22 |
| other: a Greek word | 8 | 375.03 ± 3.7% | 533.60 ± 0.6% | 933.89 ± 0.4% | 46.33 ± 3.5% | 1153.54 ± 1.9% | 2095.65 ± 0.9% | refused | 374.40 ± 6.9% | 0.70 | 1.00 | 8.10 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 26754.82 ± 1.9% | not timed | not timed | 26713.44 ± 1.4% | 1923.64 ± 25.4% | not timed | not timed | 26651.96 ± 1.2% | | 1.00 | 1.00 | 13.91 |
| 01-literal/sherlock-casei-en | 522 | 8032.64 ± 13.4% | not timed | not timed | 6976.44 ± 0.8% | 23.35 ± 1.1% | not timed | not timed | 7858.08 ± 14.7% | | 1.02 | 1.15 | 343.99 |
| 01-literal/sherlock-ru | 724 | 27705.33 ± 2.4% | not timed | not timed | 27447.72 ± 1.3% | 1036.50 ± 7.6% | not timed | not timed | 27765.88 ± 2.3% | | 1.00 | 1.01 | 26.73 |
| 01-literal/sherlock-casei-ru | 746 | 9720.98 ± 0.5% | not timed | not timed | 5526.67 ± 1.0% | 29.61 ± 0.5% | not timed | not timed | 9704.84 ± 1.8% | | 1.00 | 1.76 | 328.33 |
| 01-literal/sherlock-zh | 30 | 46488.34 ± 2.4% | not timed | not timed | 36907.30 ± 0.5% | 1263.75 ± 3.4% | not timed | not timed | 46168.47 ± 0.7% | | 1.01 | 1.26 | 36.79 |
| 02-literal-alternate/sherlock-en | 714 | 10030.26 ± 0.4% | not timed | not timed | 8847.66 ± 0.5% | 14.57 ± 5.0% | not timed | not timed | 10023.06 ± 0.3% | | 1.00 | 1.13 | 688.35 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2035.51 ± 1.2% | not timed | not timed | 1822.12 ± 0.9% | 8.87 ± 1.5% | not timed | not timed | 2024.86 ± 1.6% | | 1.01 | 1.12 | 229.39 |
| 02-literal-alternate/sherlock-ru | 899 | 8154.64 ± 0.5% | not timed | not timed | 4241.55 ± 0.4% | 19.54 ± 3.2% | not timed | not timed | 8146.61 ± 0.9% | | 1.00 | 1.92 | 417.35 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2096.23 ± 0.4% | not timed | not timed | 1042.16 ± 0.7% | 8.46 ± 2.5% | not timed | not timed | 2096.60 ± 0.3% | | 1.00 | 2.01 | 247.85 |
| 02-literal-alternate/sherlock-zh | 207 | 14484.90 ± 0.2% | not timed | not timed | 10396.18 ± 0.3% | 27.15 ± 0.8% | not timed | not timed | 14446.14 ± 0.7% | | 1.00 | 1.39 | 533.58 |
| 03-date/ascii | 111817 | 96.11 ± 0.4% | not timed | not timed | 84.37 ± 2.0% | 0.18 ± 5.7% | not timed | not timed | 95.77 ± 0.7% | | 1.00 | 1.14 | 548.34 |
| 04-ruff-noqa/real | 84 | 392.91 ± 1.8% | not timed | not timed | 440.25 ± 1.9% | 15.84 ± 1.0% | not timed | not timed | 394.05 ± 2.6% | | 1.00 | 0.89 | 24.80 |
| 04-ruff-noqa/tweaked | 44 | 504.34 ± 3.4% | not timed | not timed | 425.27 ± 1.1% | 294.16 ± 1.8% | not timed | not timed | 503.95 ± 1.8% | | 1.00 | 1.19 | 1.71 |
| 05-lexer-veryl/single | 124800 | 3.48 ± 3.3% | not timed | not timed | 4.23 ± 0.5% | 0.21 ± 5.6% | not timed | not timed | 3.39 ± 1.7% | | 1.02 | 0.82 | 16.55 |
| 06-cloud-flare-redos/original | 107 | 347.91 ± 0.6% | not timed | not timed | 191.31 ± 1.7% | 17.51 ± 1.2% | not timed | not timed | 345.89 ± 0.6% | | 1.01 | 1.82 | 19.87 |
| 06-cloud-flare-redos/simplified-short | 102 | 329.38 ± 1.3% | not timed | not timed | 192.06 ± 0.4% | 21.92 ± 1.5% | not timed | not timed | 329.55 ± 0.9% | | 1.00 | 1.71 | 15.03 |
| 06-cloud-flare-redos/simplified-long | 10000 | 465.09 ± 0.1% | not timed | not timed | 211.53 ± 0.6% | 24.08 ± 0.4% | not timed | not timed | 464.89 ± 0.6% | | 1.00 | 2.20 | 19.32 |
| 07-unicode-character-data/parse-line | 558784 | 204.71 ± 0.2% | not timed | not timed | 161.22 ± 0.3% | 35.44 ± 1.2% | not timed | not timed | 202.05 ± 1.9% | | 1.01 | 1.27 | 5.78 |
| 08-words/all-english | 56691 | 94.38 ± 2.3% | not timed | not timed | 72.81 ± 1.5% | 11.14 ± 6.2% | not timed | not timed | 95.39 ± 2.1% | | 0.99 | 1.30 | 8.47 |
| 08-words/long-english | 839 | 535.75 ± 0.2% | not timed | not timed | 514.16 ± 0.4% | 26.15 ± 0.5% | not timed | not timed | 535.24 ± 0.6% | | 1.00 | 1.04 | 20.49 |
| 09-aws-keys/full | 0 | 402.04 ± 1.4% | not timed | not timed | 436.49 ± 6.1% | 52.20 ± 8.2% | not timed | not timed | 401.91 ± 1.0% | | 1.00 | 0.92 | 7.70 |
| 09-aws-keys/quick | 0 | 945.20 ± 9.1% | not timed | not timed | 803.13 ± 0.6% | 324.20 ± 5.4% | not timed | not timed | 948.07 ± 0.5% | | 1.00 | 1.18 | 2.92 |
| 10-bounded-repeat/letters-en | 1833 | 481.68 ± 1.5% | not timed | not timed | 419.60 ± 0.8% | 16.76 ± 1.1% | not timed | not timed | 483.37 ± 1.9% | | 1.00 | 1.15 | 28.73 |
| 10-bounded-repeat/letters-ru | 3475 | 427.87 ± 0.5% | not timed | not timed | 408.72 ± 0.6% | 19.25 ± 10.6% | not timed | not timed | 428.54 ± 0.8% | | 1.00 | 1.05 | 22.23 |
| 10-bounded-repeat/context | 53 | 64.68 ± 0.7% | not timed | not timed | 56.22 ± 2.7% | 16.74 ± 0.3% | not timed | not timed | 65.14 ± 5.9% | | 0.99 | 1.15 | 3.86 |
| 10-bounded-repeat/capitals | 11 | 554.92 ± 8.4% | not timed | not timed | 532.58 ± 0.4% | 30.79 ± 2.2% | not timed | not timed | 551.13 ± 7.5% | | 1.01 | 1.04 | 18.02 |
| 11-unstructured-to-json/extract | 600 | 55.48 ± 2.0% | not timed | not timed | 62.02 ± 16.3% | 39.82 ± 4.1% | not timed | not timed | 54.94 ± 1.0% | | 1.01 | 0.89 | 1.39 |
| 12-dictionary/single | 1 | 458.16 ± 0.2% | not timed | not timed | 440.74 ± 1.7% | 0.31 ± 0.5% | not timed | not timed | 458.53 ± 1.1% | | 1.00 | 1.04 | 1464.14 |
| 14-quadratic/1x | 100 | 21.17 ± 1.1% | not timed | not timed | 9.03 ± 1.2% | 0.80 ± 2.7% | not timed | not timed | 21.07 ± 3.3% | | 1.00 | 2.35 | 26.56 |
| 14-quadratic/2x | 200 | 16.18 ± 0.3% | not timed | not timed | 4.90 ± 0.3% | 0.43 ± 20.4% | not timed | not timed | 16.18 ± 1.1% | | 1.00 | 3.30 | 37.95 |
| 14-quadratic/10x | 1000 | 5.62 ± 0.7% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 3.3% | not timed | not timed | 5.61 ± 0.2% | | 1.00 | 5.35 | 60.70 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.18 ± 1.0% | not timed | not timed | 0.39 ± 1.9% | 0.49 ± 5.0% | not timed | not timed | 1.17 ± 2.1% | | 1.01 | 3.07 | 2.43 |
| 04-ruff-noqa/compile-real | 1 | 83.24 ± 20.9% | not timed | not timed | 12.39 ± 10.1% | 121.62 ± 2.6% | not timed | not timed | 81.82 ± 4.8% | | 1.02 | 6.72 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 12.61 ± 1.9% | not timed | not timed | 2.37 ± 0.8% | 5.85 ± 2.3% | not timed | not timed | 12.60 ± 1.2% | | 1.00 | 5.31 | 2.16 |
| 07-unicode-character-data/compile | 1 | 52.32 ± 0.1% | not timed | not timed | 24.36 ± 3.4% | 32.78 ± 1.2% | not timed | not timed | 51.62 ± 1.4% | | 1.01 | 2.15 | 1.60 |
| 09-aws-keys/compile-full | 1 | 35.22 ± 3.2% | not timed | not timed | 7.39 ± 1.2% | 19.90 ± 4.8% | not timed | not timed | 34.82 ± 6.5% | | 1.01 | 4.77 | 1.77 |
| 09-aws-keys/compile-quick | 1 | 154.89 ± 15.6% | not timed | not timed | 44.54 ± 0.9% | 118.24 ± 3.2% | not timed | not timed | 154.38 ± 1.6% | | 1.00 | 3.48 | 1.31 |
| 10-bounded-repeat/compile-context | 1 | 10.47 ± 8.3% | not timed | not timed | 11.72 ± 1.5% | 15.27 ± 1.4% | not timed | not timed | 10.47 ± 29.0% | | 1.00 | 0.89 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 72.22 ± 1.6% | not timed | not timed | 8.90 ± 1.5% | 22.43 ± 22.9% | not timed | not timed | 71.70 ± 0.4% | | 1.01 | 8.11 | 3.22 |
| 11-unstructured-to-json/compile | 1 | 77.80 ± 0.3% | not timed | not timed | 37.25 ± 0.9% | 60.23 ± 2.1% | not timed | not timed | 77.09 ± 1.2% | | 1.01 | 2.09 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.28 ± 2.6% | not timed | not timed | 0.07 ± 1.2% | 0.09 ± 5.2% | not timed | not timed | 0.28 ± 4.0% | | 1.00 | 4.09 | 3.15 |

