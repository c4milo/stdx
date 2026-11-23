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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117640907 |
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
| literal: a word | 217 | 30756.92 ± 0.4% | 892.06 ± 0.1% | 19.94 ± 3.2% | 30958.27 ± 0.8% | 8974.92 ± 8.3% | 10.79 ± 0.2% | 75.71 ± 0.9% | 30506.85 ± 2.8% | 34.48 | 1.01 | 0.99 | 3.43 |
| literal: a word that is not there | 0 | 48560.61 ± 2.0% | 905.63 ± 0.1% | 20.09 ± 1.2% | 39563.12 ± 2.3% | 29610.28 ± 1.0% | 10.72 ± 0.1% | 71.35 ± 1.5% | 47896.42 ± 2.0% | 53.62 | 1.01 | 1.23 | 1.64 |
| literal: one of four words | 661 | 10319.82 ± 0.5% | 863.72 ± 0.2% | 11.12 ± 1.3% | 9106.66 ± 11.0% | 19.00 ± 8.1% | 3.96 ± 0.6% | 6.44 ± 2.8% | 10317.42 ± 0.7% | 11.95 | 1.00 | 1.13 | 543.08 |
| literal: a word in any case | 217 | 24432.65 ± 0.8% | 890.82 ± 0.2% | 15.41 ± 1.0% | 9247.42 ± 0.5% | 37.27 ± 0.4% | refused | differs | 24491.70 ± 0.9% | 27.43 | 1.00 | 2.64 | 655.63 |
| literal: an href attribute | 33 | 26095.12 ± 0.9% | 900.65 ± 0.1% | 18.77 ± 0.1% | 27324.93 ± 5.7% | 2045.49 ± 2.9% | 8.28 ± 0.4% | 60.70 ± 1.0% | 26292.69 ± 7.4% | 28.97 | 0.99 | 0.95 | 12.76 |
| literal: a word, second text | 123 | 32196.40 ± 6.8% | 896.75 ± 0.9% | 19.82 ± 0.4% | 32006.47 ± 0.9% | 7158.48 ± 12.0% | 11.79 ± 0.3% | 64.97 ± 3.7% | 32293.77 ± 0.7% | 35.90 | 1.00 | 1.01 | 4.50 |
| class: two capitalized words | 1331 | 772.99 ± 1.5% | 805.15 ± 1.4% | 18.85 ± 9.2% | 505.77 ± 1.3% | 34.31 ± 5.6% | 9.45 ± 1.4% | 54.76 ± 1.5% | 771.50 ± 2.4% | 0.96 | 1.00 | 1.53 | 22.53 |
| class: a word that ends in ing | 3399 | 720.39 ± 1.4% | 718.09 ± 0.2% | 13.02 ± 5.1% | 471.90 ± 0.2% | 25.73 ± 8.2% | 5.30 ± 0.5% | 15.75 ± 0.9% | 720.40 ± 0.4% | 1.00 | 1.00 | 1.53 | 28.00 |
| class: a word in capitals | 2332 | 964.85 ± 0.1% | 779.57 ± 1.1% | 19.77 ± 0.2% | 497.19 ± 0.4% | 36.79 ± 6.6% | 10.55 ± 0.3% | 76.24 ± 5.8% | 963.59 ± 0.2% | 1.24 | 1.00 | 1.94 | 26.23 |
| class: a number | 8288 | 1234.90 ± 0.2% | 614.29 ± 0.1% | 19.49 ± 0.6% | 1479.70 ± 4.4% | 36.66 ± 14.6% | 0.34 ± 0.6% | 54.14 ± 0.8% | 1234.06 ± 0.2% | 2.01 | 1.00 | 0.83 | 33.69 |
| class: two capitalized words, second text | 5359 | 562.57 ± 2.9% | 563.32 ± 0.1% | 17.27 ± 0.7% | 417.07 ± 0.2% | 30.15 ± 3.4% | 10.75 ± 0.2% | 50.38 ± 0.9% | 562.51 ± 0.0% | 1.00 | 1.00 | 1.35 | 18.66 |
| other: a word between two words | 6104 | 623.11 ± 0.4% | 597.79 ± 0.3% | 17.03 ± 0.4% | 685.16 ± 0.6% | 102.44 ± 9.1% | 7.25 ± 0.2% | 55.42 ± 1.1% | 624.13 ± 0.2% | 1.04 | 1.00 | 0.91 | 6.08 |
| other: a number before a unit, second text | 1481 | 6225.66 ± 4.3% | 817.55 ± 0.3% | 18.72 ± 0.3% | 6462.64 ± 0.1% | 35.19 ± 11.7% | 11.22 ± 0.8% | 53.90 ± 0.3% | 6192.97 ± 0.4% | 7.61 | 1.01 | 0.96 | 176.90 |
| other: a heading's start tag | 110 | 18317.59 ± 8.0% | 891.28 ± 0.4% | 19.49 ± 1.0% | 1989.51 ± 8.8% | 1479.05 ± 2.9% | 10.07 ± 0.5% | 71.23 ± 1.0% | 18292.08 ± 2.3% | 20.55 | 1.00 | 9.21 | 12.38 |
| other: a whole word | 217 | 21532.69 ± 1.7% | 890.22 ± 1.7% | 20.66 ± 0.5% | 22709.29 ± 1.1% | 40.58 ± 1.7% | 9.51 ± 1.3% | 46.43 ± 0.9% | 21431.68 ± 0.8% | 24.19 | 1.00 | 0.95 | 530.60 |
| other: a line's first word, second text | 3716 | 1651.19 ± 5.2% | 702.22 ± 0.2% | 24.10 ± 2.0% | 1733.96 ± 3.4% | 50.75 ± 3.6% | refused | refused | 1661.39 ± 0.4% | 2.35 | 0.99 | 0.95 | 32.54 |
| other: fourteen octets before an x | 87 | 24497.04 ± 1.5% | 198.00 ± 4.4% | 5.05 ± 2.3% | 2908.92 ± 2.9% | 8.99 ± 2.4% | differs | 14.80 ± 2.2% | 24494.12 ± 3.5% | 123.72 | 1.00 | 8.42 | 2724.23 |
| other: a Greek word | 21815 | 376.84 ± 0.3% | 250.44 ± 0.3% | 23.75 ± 0.4% | 263.90 ± 0.3% | 44.08 ± 8.8% | differs | refused | 375.62 ± 0.4% | 1.50 | 1.00 | 1.43 | 8.55 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.45 ± 1.4% | 24.43 ± 0.5% | 0.72 ± 0.2% | 16.97 ± 0.9% | 1.72 ± 0.2% | differs | 3.44 ± 0.6% | 24.62 ± 1.3% | 1.00 | 0.99 | 1.44 | 14.22 |
| a UUID | 32895 | 20.66 ± 0.2% | 20.11 ± 0.2% | 0.55 ± 2.3% | 12.83 ± 0.5% | 2.50 ± 0.7% | 0.43 ± 0.1% | 3.01 ± 1.5% | 20.61 ± 0.7% | 1.03 | 1.00 | 1.61 | 8.27 |
| an IPv4 address | 33176 | 34.18 ± 1.6% | 33.82 ± 0.5% | 1.80 ± 0.8% | 24.21 ± 0.7% | 5.75 ± 1.5% | differs | 3.37 ± 0.9% | 34.40 ± 1.4% | 1.01 | 0.99 | 1.41 | 5.94 |
| a date and time | 32954 | 30.72 ± 0.3% | 30.42 ± 0.2% | 1.28 ± 0.4% | 18.06 ± 0.1% | 6.69 ± 0.5% | 0.76 ± 0.3% | 5.66 ± 2.8% | 30.72 ± 0.2% | 1.01 | 1.00 | 1.70 | 4.59 |
| a field path | 32606 | 27.34 ± 0.1% | 27.25 ± 0.3% | 0.88 ± 1.6% | 19.64 ± 2.6% | 2.93 ± 6.3% | differs | 2.37 ± 0.4% | 27.19 ± 0.6% | 1.00 | 1.01 | 1.39 | 9.32 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.21 ± 0.6% | 8.22 ± 0.3% | 8.15 ± 0.9% | 10.48 ± 0.5% | 4.85 ± 1.9% | 0.62 ± 2.5% | none | 8.20 ± 10.9% | 1.00 | 1.00 | 0.78 | 1.69 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 185.71 ± 13.8% | 186.43 ± 0.3% | 217.22 ± 8.6% | 80.01 ± 3.6% | 186.77 ± 5.3% | 539.99 ± 13.8% | 3865.36 ± 1.0% | 186.08 ± 0.1% | 1.00 | 1.00 | 2.32 | 0.99 |
| a UUID | 62 | 122.31 ± 0.2% | 122.50 ± 0.4% | 136.66 ± 0.7% | 46.88 ± 1.3% | 90.06 ± 1.6% | 197.32 ± 1.5% | 4020.25 ± 15.0% | 122.06 ± 0.6% | 1.00 | 1.00 | 2.61 | 1.36 |
| an IPv4 address | 29 | 380.00 ± 1.7% | 384.02 ± 0.8% | 543.83 ± 0.4% | 69.81 ± 1.0% | 114.90 ± 2.9% | 320.72 ± 11.4% | 7001.28 ± 2.7% | 380.58 ± 0.8% | 0.99 | 1.00 | 5.44 | 3.31 |
| a date and time | 56 | 278.44 ± 0.5% | 279.54 ± 0.4% | 355.10 ± 0.2% | 67.86 ± 1.5% | 124.43 ± 4.2% | 367.78 ± 2.6% | 4120.48 ± 0.3% | 277.82 ± 0.4% | 1.00 | 1.00 | 4.10 | 2.24 |
| a field path | 39 | 187.29 ± 4.5% | 188.29 ± 0.8% | 219.40 ± 0.5% | 73.82 ± 1.8% | 174.63 ± 0.5% | 581.34 ± 14.0% | 4611.46 ± 2.1% | 187.50 ± 0.4% | 0.99 | 1.00 | 2.54 | 1.07 |
| literal: a word | 7 | 572.05 ± 0.3% | 619.42 ± 0.6% | 1157.88 ± 0.8% | 505.79 ± 1.6% | 582.13 ± 3.7% | 1235.84 ± 0.3% | 23215.94 ± 0.8% | 571.88 ± 0.3% | 0.92 | 1.00 | 1.13 | 0.98 |
| literal: a word that is not there | 8 | 549.98 ± 0.5% | 598.44 ± 0.5% | 1087.76 ± 0.8% | 464.96 ± 1.6% | 565.13 ± 4.1% | 1162.11 ± 0.5% | 22622.25 ± 0.5% | 549.94 ± 0.2% | 0.92 | 1.00 | 1.18 | 0.97 |
| literal: one of four words | 26 | 218.43 ± 0.3% | 358.42 ± 7.4% | 495.75 ± 0.2% | 41.62 ± 14.6% | 223.64 ± 2.0% | 450.24 ± 2.4% | 10561.63 ± 15.2% | 218.28 ± 0.4% | 0.61 | 1.00 | 5.25 | 0.98 |
| literal: a word in any case | 11 | 443.19 ± 7.3% | 465.58 ± 8.2% | 747.67 ± 1.1% | 14.39 ± 0.9% | 614.70 ± 1.4% | refused | 18952.05 ± 8.9% | 442.61 ± 0.3% | 0.95 | 1.00 | 30.80 | 0.72 |
| literal: an href attribute | 12 | 318.98 ± 1.2% | 331.41 ± 0.7% | 450.24 ± 0.2% | 36.90 ± 1.6% | 434.99 ± 0.8% | 971.21 ± 0.5% | 18467.07 ± 0.4% | 318.90 ± 1.5% | 0.96 | 1.00 | 8.64 | 0.73 |
| literal: a word, second text | 10 | 510.25 ± 1.4% | 563.36 ± 0.8% | 976.43 ± 0.6% | 421.85 ± 2.1% | 490.70 ± 1.2% | 1021.50 ± 0.4% | 20130.29 ± 2.2% | 508.98 ± 0.5% | 0.91 | 1.00 | 1.21 | 1.04 |
| class: two capitalized words | 23 | 410.06 ± 1.9% | 431.36 ± 2.6% | 640.19 ± 2.7% | 95.77 ± 0.6% | 457.10 ± 11.2% | 951.07 ± 1.7% | 6187.39 ± 0.7% | 410.45 ± 4.9% | 0.95 | 1.00 | 4.28 | 0.90 |
| class: a word that ends in ing | 9 | 499.74 ± 0.4% | 557.69 ± 0.3% | 1028.85 ± 1.1% | 116.10 ± 4.2% | 640.78 ± 5.7% | 1414.90 ± 3.0% | 14761.71 ± 3.0% | 497.89 ± 6.4% | 0.90 | 1.00 | 4.30 | 0.78 |
| class: a word in capitals | 16 | 426.29 ± 2.2% | 456.92 ± 2.4% | 777.15 ± 2.1% | 121.63 ± 4.2% | 668.86 ± 8.0% | 1297.86 ± 4.0% | 8310.37 ± 2.6% | 426.46 ± 2.1% | 0.93 | 1.00 | 3.50 | 0.64 |
| class: a number | 6 | 540.86 ± 0.3% | 590.87 ± 0.1% | 1184.78 ± 11.6% | 36.51 ± 1.2% | 1196.40 ± 4.6% | 2257.30 ± 0.8% | 20161.42 ± 0.3% | 539.24 ± 0.3% | 0.92 | 1.00 | 14.81 | 0.45 |
| class: two capitalized words, second text | 23 | 410.00 ± 2.0% | 437.44 ± 2.2% | 653.03 ± 2.5% | 94.60 ± 0.5% | 455.63 ± 3.5% | 901.51 ± 0.9% | 6184.11 ± 1.2% | 410.33 ± 0.5% | 0.94 | 1.00 | 4.33 | 0.90 |
| other: a word between two words | 13 | 489.82 ± 0.6% | 509.86 ± 0.7% | 831.75 ± 1.2% | 119.86 ± 3.0% | 441.55 ± 0.6% | 993.11 ± 2.6% | 13228.09 ± 0.3% | 489.24 ± 0.3% | 0.96 | 1.00 | 4.09 | 1.11 |
| other: a number before a unit, second text | 15 | 358.79 ± 0.2% | 394.73 ± 0.3% | 558.65 ± 0.6% | 33.32 ± 1.1% | 545.99 ± 0.9% | 1083.07 ± 5.8% | 13536.78 ± 0.4% | 357.97 ± 1.2% | 0.91 | 1.00 | 10.77 | 0.66 |
| other: a heading's start tag | 13 | 331.69 ± 0.8% | 338.61 ± 2.3% | 457.38 ± 7.5% | 35.68 ± 2.7% | 520.47 ± 10.9% | 1044.13 ± 5.5% | 16019.60 ± 0.8% | 331.23 ± 7.3% | 0.98 | 1.00 | 9.30 | 0.64 |
| other: a whole word | 11 | 500.66 ± 0.5% | 534.95 ± 0.6% | 895.32 ± 9.3% | 110.92 ± 1.0% | 518.81 ± 2.1% | 1024.20 ± 0.9% | 19756.41 ± 1.8% | 501.14 ± 1.1% | 0.94 | 1.00 | 4.51 | 0.97 |
| other: a line's first word, second text | 17 | 475.42 ± 9.6% | 499.89 ± 1.1% | 849.66 ± 0.2% | 114.68 ± 0.8% | 606.88 ± 1.7% | refused | refused | 475.26 ± 0.9% | 0.95 | 1.00 | 4.15 | 0.78 |
| other: fourteen octets before an x | 16 | 87.33 ± 0.5% | 123.25 ± 9.1% | 143.92 ± 0.3% | 14.21 ± 1.1% | 398.63 ± 3.2% | 447.92 ± 9.6% | 11792.70 ± 1.4% | 87.08 ± 6.4% | 0.71 | 1.00 | 6.14 | 0.22 |
| other: a Greek word | 8 | 365.40 ± 3.0% | 505.14 ± 1.1% | 874.57 ± 0.4% | 47.11 ± 1.8% | 1165.19 ± 10.3% | 2089.18 ± 0.4% | refused | 364.88 ± 6.3% | 0.72 | 1.00 | 7.76 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21099.07 ± 0.8% | not timed | not timed | 26812.19 ± 1.4% | 1948.66 ± 10.5% | not timed | not timed | 20902.93 ± 11.1% | | 1.01 | 0.79 | 10.83 |
| 01-literal/sherlock-casei-en | 522 | 4679.95 ± 0.5% | not timed | not timed | 7013.80 ± 0.4% | 28.45 ± 13.1% | not timed | not timed | 4660.62 ± 8.0% | | 1.00 | 0.67 | 164.50 |
| 01-literal/sherlock-ru | 724 | 22721.49 ± 1.4% | not timed | not timed | 27646.49 ± 1.0% | 1042.59 ± 7.1% | not timed | not timed | 22636.62 ± 0.8% | | 1.00 | 0.82 | 21.79 |
| 01-literal/sherlock-casei-ru | 746 | 7301.72 ± 0.8% | not timed | not timed | 5501.90 ± 0.9% | 30.27 ± 8.3% | not timed | not timed | 7286.19 ± 0.5% | | 1.00 | 1.33 | 241.24 |
| 01-literal/sherlock-zh | 30 | 41120.87 ± 2.2% | not timed | not timed | 36748.27 ± 1.9% | 1259.44 ± 0.5% | not timed | not timed | 41146.65 ± 0.8% | | 1.00 | 1.12 | 32.65 |
| 02-literal-alternate/sherlock-en | 714 | 9571.17 ± 1.1% | not timed | not timed | 8885.19 ± 10.0% | 14.15 ± 5.1% | not timed | not timed | 9547.99 ± 16.2% | | 1.00 | 1.08 | 676.37 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1733.77 ± 0.5% | not timed | not timed | 1817.71 ± 0.3% | 9.50 ± 6.5% | not timed | not timed | 1714.23 ± 0.1% | | 1.01 | 0.95 | 182.56 |
| 02-literal-alternate/sherlock-ru | 899 | 5956.43 ± 0.4% | not timed | not timed | 4246.18 ± 0.2% | 19.44 ± 1.1% | not timed | not timed | 5949.23 ± 1.6% | | 1.00 | 1.40 | 306.48 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1798.06 ± 0.3% | not timed | not timed | 1045.96 ± 0.3% | 8.52 ± 5.3% | not timed | not timed | 1795.52 ± 0.3% | | 1.00 | 1.72 | 210.94 |
| 02-literal-alternate/sherlock-zh | 207 | 13820.27 ± 3.0% | not timed | not timed | 10383.99 ± 0.3% | 27.14 ± 1.7% | not timed | not timed | 13836.90 ± 0.8% | | 1.00 | 1.33 | 509.15 |
| 03-date/ascii | 111817 | 103.98 ± 0.9% | not timed | not timed | 84.82 ± 0.3% | 0.18 ± 2.9% | not timed | not timed | 103.99 ± 0.4% | | 1.00 | 1.23 | 584.78 |
| 04-ruff-noqa/real | 84 | 561.28 ± 17.8% | not timed | not timed | 434.95 ± 0.2% | 13.71 ± 2.2% | not timed | not timed | 552.48 ± 1.0% | | 1.02 | 1.29 | 40.94 |
| 04-ruff-noqa/tweaked | 44 | 449.54 ± 0.2% | not timed | not timed | 428.64 ± 0.7% | 286.79 ± 3.5% | not timed | not timed | 449.43 ± 0.8% | | 1.00 | 1.05 | 1.57 |
| 05-lexer-veryl/single | 124800 | 2.88 ± 0.6% | not timed | not timed | 4.20 ± 0.6% | 0.21 ± 5.2% | not timed | not timed | 2.92 ± 3.3% | | 0.99 | 0.69 | 13.48 |
| 06-cloud-flare-redos/original | 107 | 184.37 ± 0.8% | not timed | not timed | 191.00 ± 1.3% | 13.08 ± 1.1% | not timed | not timed | 183.69 ± 0.5% | | 1.00 | 0.97 | 14.09 |
| 06-cloud-flare-redos/simplified-short | 102 | 127.61 ± 0.3% | not timed | not timed | 191.75 ± 0.9% | 14.05 ± 1.6% | not timed | not timed | 127.11 ± 1.2% | | 1.00 | 0.67 | 9.08 |
| 06-cloud-flare-redos/simplified-long | 10000 | 136.36 ± 5.8% | not timed | not timed | 211.29 ± 0.3% | 14.85 ± 0.5% | not timed | not timed | 136.38 ± 4.4% | | 1.00 | 0.65 | 9.18 |
| 07-unicode-character-data/parse-line | 558784 | 195.68 ± 1.0% | not timed | not timed | 160.32 ± 8.7% | 37.48 ± 5.5% | not timed | not timed | 192.37 ± 1.9% | | 1.02 | 1.22 | 5.22 |
| 08-words/all-english | 56691 | 74.74 ± 0.6% | not timed | not timed | 72.93 ± 0.4% | 11.33 ± 4.5% | not timed | not timed | 74.34 ± 0.7% | | 1.01 | 1.02 | 6.60 |
| 08-words/long-english | 839 | 824.62 ± 2.0% | not timed | not timed | 515.06 ± 0.2% | 26.42 ± 0.8% | not timed | not timed | 848.76 ± 2.2% | | 0.97 | 1.60 | 31.21 |
| 09-aws-keys/full | 0 | 430.98 ± 1.6% | not timed | not timed | 450.84 ± 0.4% | 52.75 ± 5.3% | not timed | not timed | 431.32 ± 7.4% | | 1.00 | 0.96 | 8.17 |
| 09-aws-keys/quick | 0 | 817.41 ± 0.2% | not timed | not timed | 802.63 ± 8.1% | 313.87 ± 12.9% | not timed | not timed | 818.40 ± 0.1% | | 1.00 | 1.02 | 2.60 |
| 10-bounded-repeat/letters-en | 1833 | 469.45 ± 0.9% | not timed | not timed | 432.05 ± 2.6% | 16.95 ± 1.2% | not timed | not timed | 472.14 ± 0.3% | | 0.99 | 1.09 | 27.70 |
| 10-bounded-repeat/letters-ru | 3475 | 324.81 ± 0.3% | not timed | not timed | 405.16 ± 0.9% | 19.78 ± 14.1% | not timed | not timed | 324.26 ± 0.3% | | 1.00 | 0.80 | 16.42 |
| 10-bounded-repeat/context | 53 | 66.00 ± 1.4% | not timed | not timed | 56.22 ± 1.3% | 16.81 ± 0.7% | not timed | not timed | 65.93 ± 7.2% | | 1.00 | 1.17 | 3.92 |
| 10-bounded-repeat/capitals | 11 | 897.36 ± 1.0% | not timed | not timed | 531.53 ± 0.6% | 30.90 ± 3.0% | not timed | not timed | 895.60 ± 18.1% | | 1.00 | 1.69 | 29.04 |
| 11-unstructured-to-json/extract | 600 | 36.33 ± 1.3% | not timed | not timed | 61.32 ± 0.5% | 23.04 ± 1.0% | not timed | not timed | 36.41 ± 2.3% | | 1.00 | 0.59 | 1.58 |
| 12-dictionary/single | 1 | 461.10 ± 0.7% | not timed | not timed | 441.62 ± 0.5% | 0.31 ± 1.3% | not timed | not timed | 462.92 ± 0.3% | | 1.00 | 1.04 | 1483.27 |
| 14-quadratic/1x | 100 | 11.42 ± 1.6% | not timed | not timed | 9.13 ± 0.2% | 0.81 ± 2.6% | not timed | not timed | 11.29 ± 1.3% | | 1.01 | 1.25 | 14.05 |
| 14-quadratic/2x | 200 | 6.87 ± 2.6% | not timed | not timed | 4.87 ± 3.2% | 0.42 ± 2.1% | not timed | not timed | 6.77 ± 2.3% | | 1.01 | 1.41 | 16.40 |
| 14-quadratic/10x | 1000 | 1.59 ± 1.8% | not timed | not timed | 1.05 ± 1.0% | 0.09 ± 2.6% | not timed | not timed | 1.59 ± 1.7% | | 1.00 | 1.52 | 17.23 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.31 ± 0.6% | not timed | not timed | 0.39 ± 1.3% | 0.49 ± 3.3% | not timed | not timed | 1.30 ± 1.3% | | 1.01 | 3.39 | 2.69 |
| 04-ruff-noqa/compile-real | 1 | 80.16 ± 0.3% | not timed | not timed | 12.89 ± 1.2% | 126.66 ± 3.6% | not timed | not timed | 79.65 ± 0.8% | | 1.01 | 6.22 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 12.68 ± 0.8% | not timed | not timed | 2.37 ± 1.0% | 5.94 ± 1.4% | not timed | not timed | 12.57 ± 1.7% | | 1.01 | 5.36 | 2.13 |
| 07-unicode-character-data/compile | 1 | 50.61 ± 0.1% | not timed | not timed | 24.21 ± 6.3% | 32.94 ± 1.9% | not timed | not timed | 50.23 ± 0.7% | | 1.01 | 2.09 | 1.54 |
| 09-aws-keys/compile-full | 1 | 34.63 ± 0.1% | not timed | not timed | 7.38 ± 2.0% | 20.69 ± 3.8% | not timed | not timed | 34.41 ± 1.4% | | 1.01 | 4.70 | 1.67 |
| 09-aws-keys/compile-quick | 1 | 156.99 ± 0.3% | not timed | not timed | 45.05 ± 1.6% | 116.78 ± 17.8% | not timed | not timed | 156.15 ± 2.3% | | 1.01 | 3.48 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 10.40 ± 1.0% | not timed | not timed | 11.53 ± 0.4% | 15.00 ± 10.6% | not timed | not timed | 10.44 ± 0.8% | | 1.00 | 0.90 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 72.90 ± 0.4% | not timed | not timed | 8.79 ± 1.0% | 22.13 ± 3.6% | not timed | not timed | 72.00 ± 1.1% | | 1.01 | 8.30 | 3.29 |
| 11-unstructured-to-json/compile | 1 | 76.63 ± 0.8% | not timed | not timed | 37.11 ± 5.6% | 61.68 ± 1.9% | not timed | not timed | 75.99 ± 1.6% | | 1.01 | 2.06 | 1.24 |
| 12-dictionary/compile-single | 1 | 0.29 ± 0.5% | not timed | not timed | 0.07 ± 15.4% | 0.09 ± 21.8% | not timed | not timed | 0.29 ± 1.3% | | 1.00 | 4.16 | 3.35 |

