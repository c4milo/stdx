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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243543024 |
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
| literal: a word | 217 | 38482.30 ± 5.2% | 3350.17 ± 0.3% | 19.98 ± 5.2% | 30951.97 ± 2.1% | 9008.04 ± 9.0% | 10.73 ± 0.3% | 76.27 ± 0.6% | 37946.01 ± 4.9% | 11.49 | 1.01 | 1.24 | 4.27 |
| literal: a word that is not there | 0 | 52400.60 ± 2.9% | 3242.48 ± 0.4% | 20.02 ± 2.2% | 39464.83 ± 0.4% | 29943.20 ± 0.9% | 10.70 ± 0.8% | 71.94 ± 1.0% | 51517.81 ± 1.2% | 16.16 | 1.02 | 1.33 | 1.75 |
| literal: one of four words | 661 | 11553.19 ± 1.0% | 1396.76 ± 1.6% | 10.91 ± 1.7% | 9082.58 ± 0.3% | 19.27 ± 4.4% | 3.98 ± 1.4% | 6.02 ± 3.2% | 11480.97 ± 11.9% | 8.27 | 1.01 | 1.27 | 599.51 |
| literal: a word in any case | 217 | 29865.31 ± 3.4% | 1492.63 ± 1.3% | 14.97 ± 3.5% | 9223.24 ± 1.1% | 37.29 ± 0.4% | refused | differs | 29692.37 ± 1.4% | 20.01 | 1.01 | 3.24 | 800.92 |
| literal: an href attribute | 33 | 28994.84 ± 3.4% | 539.87 ± 0.1% | 18.55 ± 2.6% | 27469.38 ± 0.5% | 2051.65 ± 4.8% | 8.24 ± 1.0% | 63.40 ± 2.5% | 28952.58 ± 0.8% | 53.71 | 1.00 | 1.06 | 14.13 |
| literal: a word, second text | 123 | 36389.99 ± 4.9% | 2378.70 ± 0.5% | 20.03 ± 3.1% | 31523.51 ± 3.1% | 7223.96 ± 4.7% | 11.83 ± 0.2% | 65.22 ± 10.5% | 36471.57 ± 2.1% | 15.30 | 1.00 | 1.15 | 5.04 |
| class: two capitalized words | 1331 | 764.84 ± 0.1% | 526.83 ± 2.0% | 18.68 ± 1.5% | 506.33 ± 13.6% | 34.39 ± 7.4% | 9.32 ± 0.2% | 57.32 ± 2.3% | 764.79 ± 0.3% | 1.45 | 1.00 | 1.51 | 22.24 |
| class: a word that ends in ing | 3399 | 500.37 ± 0.3% | 499.31 ± 3.7% | 12.96 ± 0.6% | 473.19 ± 1.0% | 23.99 ± 4.4% | 5.35 ± 0.6% | 16.51 ± 0.7% | 500.31 ± 0.3% | 1.00 | 1.00 | 1.06 | 20.85 |
| class: a word in capitals | 2332 | 941.05 ± 1.7% | 531.22 ± 1.5% | 19.76 ± 4.3% | 495.43 ± 1.7% | 35.92 ± 13.9% | 10.27 ± 1.5% | 77.56 ± 2.6% | 932.90 ± 3.0% | 1.77 | 1.01 | 1.90 | 26.20 |
| class: a number | 8288 | 1448.88 ± 1.0% | 700.91 ± 8.1% | 19.52 ± 21.5% | 1434.20 ± 0.2% | 37.65 ± 9.8% | 0.34 ± 0.3% | 55.55 ± 0.6% | 1447.24 ± 0.7% | 2.07 | 1.00 | 1.01 | 38.48 |
| class: two capitalized words, second text | 5359 | 444.57 ± 0.3% | 451.00 ± 0.5% | 17.20 ± 8.1% | 416.77 ± 0.1% | 30.23 ± 8.0% | 10.45 ± 0.2% | 52.89 ± 1.1% | 445.06 ± 1.4% | 0.99 | 1.00 | 1.07 | 14.71 |
| other: a word between two words | 6104 | 707.36 ± 0.4% | 511.81 ± 1.9% | 16.89 ± 0.9% | 699.21 ± 0.4% | 102.03 ± 7.7% | 7.23 ± 0.6% | 58.28 ± 2.6% | 707.90 ± 0.4% | 1.38 | 1.00 | 1.01 | 6.93 |
| other: a number before a unit, second text | 1481 | 7233.80 ± 5.5% | 861.01 ± 0.1% | 18.86 ± 3.9% | 6357.39 ± 0.5% | 35.20 ± 4.0% | 10.87 ± 0.5% | 56.07 ± 0.7% | 7232.03 ± 0.9% | 8.40 | 1.00 | 1.14 | 205.48 |
| other: a heading's start tag | 110 | 19460.98 ± 1.0% | 653.76 ± 0.9% | 19.55 ± 7.3% | 2010.54 ± 0.4% | 1478.61 ± 3.7% | 10.01 ± 0.2% | 72.92 ± 2.7% | 19540.12 ± 1.0% | 29.77 | 1.00 | 9.68 | 13.16 |
| other: a whole word | 217 | 23631.01 ± 1.4% | 531.98 ± 0.5% | 19.71 ± 2.1% | 22531.85 ± 0.8% | 40.27 ± 0.4% | 9.46 ± 0.2% | 46.36 ± 0.6% | 23140.66 ± 0.5% | 44.42 | 1.02 | 1.05 | 586.87 |
| other: a line's first word, second text | 3716 | 1983.38 ± 3.8% | 513.41 ± 0.2% | 22.29 ± 1.2% | 1702.57 ± 0.9% | 52.94 ± 5.6% | refused | refused | 1955.86 ± 7.0% | 3.86 | 1.01 | 1.16 | 37.47 |
| other: fourteen octets before an x | 87 | 27536.74 ± 4.9% | 205.21 ± 0.3% | 5.42 ± 3.1% | 2759.04 ± 0.5% | 8.99 ± 6.2% | differs | 15.04 ± 9.1% | 27389.36 ± 0.9% | 134.19 | 1.01 | 9.98 | 3064.11 |
| other: a Greek word | 21815 | 385.55 ± 4.7% | 335.40 ± 0.4% | 23.79 ± 1.0% | 261.70 ± 0.6% | 44.60 ± 14.7% | differs | refused | 383.46 ± 0.4% | 1.15 | 1.01 | 1.47 | 8.64 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 16.88 ± 3.5% | 16.81 ± 2.7% | 0.78 ± 1.1% | 16.85 ± 0.6% | 2.33 ± 0.4% | differs | 3.60 ± 6.7% | 16.79 ± 0.3% | 1.00 | 1.01 | 1.00 | 7.23 |
| a UUID | 32895 | 18.37 ± 2.0% | 18.18 ± 2.3% | 0.54 ± 1.4% | 12.89 ± 1.6% | 2.50 ± 2.8% | 0.45 ± 0.8% | 2.99 ± 2.5% | 18.24 ± 0.4% | 1.01 | 1.01 | 1.43 | 7.36 |
| an IPv4 address | 33176 | 30.52 ± 2.3% | 30.50 ± 2.5% | 1.76 ± 0.4% | 21.88 ± 0.2% | 5.69 ± 0.9% | differs | 3.40 ± 0.8% | 30.44 ± 1.0% | 1.00 | 1.00 | 1.39 | 5.36 |
| a date and time | 32954 | 27.19 ± 0.2% | 27.09 ± 0.6% | 1.24 ± 0.6% | 17.76 ± 0.2% | 6.58 ± 11.8% | 0.75 ± 1.5% | 5.96 ± 1.8% | 27.09 ± 0.5% | 1.00 | 1.00 | 1.53 | 4.13 |
| a field path | 32606 | 19.93 ± 0.7% | 19.93 ± 10.8% | 0.88 ± 0.7% | 19.37 ± 0.1% | 2.91 ± 0.9% | differs | 2.44 ± 0.7% | 19.91 ± 0.4% | 1.00 | 1.00 | 1.03 | 6.84 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.58 ± 0.2% | 8.48 ± 0.3% | 7.42 ± 14.8% | 10.66 ± 0.5% | 4.71 ± 1.8% | 0.62 ± 0.3% | none | 8.70 ± 0.2% | 1.01 | 0.99 | 0.81 | 1.82 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 204.89 ± 7.9% | 205.75 ± 0.2% | 242.50 ± 0.5% | 80.43 ± 2.9% | 186.07 ± 1.6% | 547.36 ± 2.7% | 3474.76 ± 3.9% | 205.09 ± 0.4% | 1.00 | 1.00 | 2.55 | 1.10 |
| a UUID | 62 | 132.50 ± 0.6% | 132.57 ± 0.8% | 148.46 ± 1.1% | 45.10 ± 1.2% | 90.44 ± 2.0% | 200.35 ± 7.8% | 3849.71 ± 7.1% | 132.44 ± 27.0% | 1.00 | 1.00 | 2.94 | 1.47 |
| an IPv4 address | 29 | 381.13 ± 0.6% | 384.69 ± 0.4% | 533.09 ± 1.0% | 70.32 ± 11.8% | 114.65 ± 15.5% | 326.52 ± 6.4% | 6591.50 ± 0.7% | 381.24 ± 0.3% | 0.99 | 1.00 | 5.42 | 3.32 |
| a date and time | 56 | 278.30 ± 0.8% | 280.92 ± 0.2% | 348.54 ± 0.6% | 69.66 ± 1.4% | 123.67 ± 1.3% | 371.34 ± 0.5% | 3865.35 ± 2.1% | 278.59 ± 0.3% | 0.99 | 1.00 | 4.00 | 2.25 |
| a field path | 39 | 204.15 ± 3.0% | 205.37 ± 7.5% | 241.77 ± 1.6% | 75.34 ± 1.6% | 176.04 ± 1.1% | 590.59 ± 8.6% | 4425.45 ± 21.6% | 203.75 ± 6.9% | 0.99 | 1.00 | 2.71 | 1.16 |
| literal: a word | 7 | 569.48 ± 1.6% | 615.58 ± 1.0% | 1072.16 ± 0.9% | 495.29 ± 1.4% | 586.74 ± 0.8% | 1259.46 ± 14.0% | 24613.27 ± 5.6% | 567.69 ± 0.2% | 0.93 | 1.00 | 1.15 | 0.97 |
| literal: a word that is not there | 8 | 545.43 ± 1.5% | 594.12 ± 0.6% | 998.54 ± 0.7% | 456.62 ± 0.4% | 566.45 ± 1.8% | 1187.81 ± 12.7% | 23564.23 ± 1.5% | 543.76 ± 0.9% | 0.92 | 1.00 | 1.19 | 0.96 |
| literal: one of four words | 26 | 212.08 ± 1.2% | 355.67 ± 9.8% | 472.85 ± 0.4% | 42.00 ± 2.5% | 218.80 ± 2.1% | 454.40 ± 1.9% | 9869.77 ± 0.9% | 211.38 ± 1.3% | 0.60 | 1.00 | 5.05 | 0.97 |
| literal: a word in any case | 11 | 399.18 ± 3.6% | 421.36 ± 0.3% | 599.25 ± 0.2% | 14.48 ± 1.3% | 605.79 ± 2.1% | refused | 18560.57 ± 8.7% | 399.04 ± 0.8% | 0.95 | 1.00 | 27.57 | 0.66 |
| literal: an href attribute | 12 | 321.61 ± 0.6% | 335.82 ± 0.6% | 445.95 ± 0.3% | 37.09 ± 1.0% | 433.74 ± 4.8% | 960.30 ± 0.6% | 17538.64 ± 0.8% | 320.79 ± 0.4% | 0.96 | 1.00 | 8.67 | 0.74 |
| literal: a word, second text | 10 | 503.79 ± 0.9% | 555.60 ± 0.5% | 899.28 ± 0.9% | 401.80 ± 0.5% | 488.40 ± 1.6% | 1009.85 ± 1.1% | 20598.46 ± 4.2% | 503.71 ± 0.5% | 0.91 | 1.00 | 1.25 | 1.03 |
| class: two capitalized words | 23 | 413.99 ± 0.4% | 445.28 ± 2.0% | 649.13 ± 3.8% | 94.49 ± 0.6% | 460.19 ± 0.5% | 940.52 ± 1.1% | 6128.68 ± 0.6% | 414.39 ± 1.3% | 0.93 | 1.00 | 4.38 | 0.90 |
| class: a word that ends in ing | 9 | 492.20 ± 0.6% | 565.09 ± 0.7% | 981.05 ± 1.2% | 115.75 ± 8.8% | 640.19 ± 1.9% | 1415.19 ± 0.9% | 14842.00 ± 0.4% | 492.49 ± 0.3% | 0.87 | 1.00 | 4.25 | 0.77 |
| class: a word in capitals | 16 | 429.13 ± 1.0% | 464.97 ± 0.7% | 772.02 ± 0.3% | 122.39 ± 1.9% | 654.42 ± 2.9% | 1279.74 ± 2.2% | 8223.05 ± 1.7% | 428.72 ± 1.2% | 0.92 | 1.00 | 3.51 | 0.66 |
| class: a number | 6 | 547.03 ± 0.7% | 609.48 ± 0.4% | 1173.06 ± 0.4% | 36.51 ± 0.7% | 1197.35 ± 1.3% | 2170.83 ± 2.3% | 20196.95 ± 0.4% | 550.10 ± 0.5% | 0.90 | 0.99 | 14.98 | 0.46 |
| class: two capitalized words, second text | 23 | 414.49 ± 1.0% | 446.20 ± 2.9% | 649.37 ± 4.1% | 95.11 ± 0.5% | 459.65 ± 1.2% | 959.65 ± 1.0% | 6112.46 ± 0.4% | 414.91 ± 0.2% | 0.93 | 1.00 | 4.36 | 0.90 |
| other: a word between two words | 13 | 489.76 ± 2.1% | 503.45 ± 10.8% | 798.19 ± 2.4% | 123.84 ± 14.4% | 438.99 ± 4.3% | 1021.48 ± 8.4% | 12513.66 ± 5.4% | 481.64 ± 10.2% | 0.97 | 1.02 | 3.95 | 1.12 |
| other: a number before a unit, second text | 15 | 367.17 ± 1.0% | 413.51 ± 0.5% | 581.23 ± 10.9% | 33.60 ± 1.7% | 549.61 ± 15.4% | 1120.01 ± 1.9% | 12844.13 ± 24.6% | 367.23 ± 0.2% | 0.89 | 1.00 | 10.93 | 0.67 |
| other: a heading's start tag | 13 | 333.54 ± 0.3% | 341.54 ± 0.3% | 455.95 ± 10.0% | 35.45 ± 0.9% | 531.47 ± 0.9% | 1078.68 ± 1.8% | 14955.06 ± 4.3% | 334.06 ± 0.6% | 0.98 | 1.00 | 9.41 | 0.63 |
| other: a whole word | 11 | 495.00 ± 1.7% | 528.98 ± 9.0% | 831.01 ± 0.8% | 111.43 ± 0.5% | 517.83 ± 1.6% | 1057.11 ± 1.0% | 19072.96 ± 0.9% | 492.40 ± 9.7% | 0.94 | 1.01 | 4.44 | 0.96 |
| other: a line's first word, second text | 17 | 471.38 ± 0.2% | 502.51 ± 0.3% | 812.84 ± 0.6% | 117.80 ± 0.8% | 611.40 ± 4.0% | refused | refused | 470.48 ± 0.8% | 0.94 | 1.00 | 4.00 | 0.77 |
| other: fourteen octets before an x | 16 | 87.91 ± 0.5% | 124.69 ± 0.4% | 144.04 ± 0.8% | 13.99 ± 0.7% | 402.03 ± 11.0% | 454.74 ± 1.0% | 11739.41 ± 7.9% | 87.90 ± 0.1% | 0.71 | 1.00 | 6.28 | 0.22 |
| other: a Greek word | 8 | 375.87 ± 1.7% | 538.09 ± 0.3% | 937.32 ± 0.4% | 47.53 ± 0.6% | 1164.44 ± 1.7% | 2233.34 ± 1.7% | refused | 375.24 ± 0.7% | 0.70 | 1.00 | 7.91 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 26588.96 ± 0.8% | not timed | not timed | 26767.52 ± 1.3% | 1996.74 ± 15.2% | not timed | not timed | 26151.65 ± 13.2% | | 1.02 | 0.99 | 13.32 |
| 01-literal/sherlock-casei-en | 522 | 7985.49 ± 1.3% | not timed | not timed | 7034.85 ± 1.2% | 23.53 ± 0.1% | not timed | not timed | 7928.20 ± 1.0% | | 1.01 | 1.14 | 339.41 |
| 01-literal/sherlock-ru | 724 | 27666.46 ± 0.7% | not timed | not timed | 27646.13 ± 0.7% | 1067.60 ± 8.8% | not timed | not timed | 27192.84 ± 1.8% | | 1.02 | 1.00 | 25.91 |
| 01-literal/sherlock-casei-ru | 746 | 9683.15 ± 1.9% | not timed | not timed | 5539.57 ± 0.4% | 29.91 ± 7.9% | not timed | not timed | 9711.46 ± 4.7% | | 1.00 | 1.75 | 323.79 |
| 01-literal/sherlock-zh | 30 | 44864.70 ± 2.0% | not timed | not timed | 36652.34 ± 0.9% | 1265.72 ± 0.3% | not timed | not timed | 44385.68 ± 3.0% | | 1.01 | 1.22 | 35.45 |
| 02-literal-alternate/sherlock-en | 714 | 10053.15 ± 0.9% | not timed | not timed | 8885.00 ± 0.5% | 14.82 ± 8.8% | not timed | not timed | 10048.49 ± 0.3% | | 1.00 | 1.13 | 678.41 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2037.46 ± 1.4% | not timed | not timed | 1819.32 ± 0.2% | 8.91 ± 0.5% | not timed | not timed | 2033.27 ± 2.2% | | 1.00 | 1.12 | 228.74 |
| 02-literal-alternate/sherlock-ru | 899 | 8143.39 ± 0.5% | not timed | not timed | 4243.25 ± 0.3% | 18.23 ± 12.1% | not timed | not timed | 8109.60 ± 6.2% | | 1.00 | 1.92 | 446.69 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2091.73 ± 7.6% | not timed | not timed | 1045.66 ± 0.3% | 8.53 ± 2.4% | not timed | not timed | 2091.28 ± 0.2% | | 1.00 | 2.00 | 245.31 |
| 02-literal-alternate/sherlock-zh | 207 | 14297.93 ± 0.6% | not timed | not timed | 10412.37 ± 0.5% | 27.84 ± 13.9% | not timed | not timed | 14308.48 ± 0.3% | | 1.00 | 1.37 | 513.66 |
| 03-date/ascii | 111817 | 96.26 ± 0.5% | not timed | not timed | 84.80 ± 0.4% | 0.18 ± 3.0% | not timed | not timed | 95.41 ± 1.0% | | 1.01 | 1.14 | 535.17 |
| 04-ruff-noqa/real | 84 | 410.29 ± 4.4% | not timed | not timed | 443.06 ± 4.2% | 15.96 ± 1.5% | not timed | not timed | 409.32 ± 1.8% | | 1.00 | 0.93 | 25.71 |
| 04-ruff-noqa/tweaked | 44 | 511.02 ± 0.3% | not timed | not timed | 429.33 ± 0.6% | 294.52 ± 0.5% | not timed | not timed | 512.13 ± 0.8% | | 1.00 | 1.19 | 1.74 |
| 05-lexer-veryl/single | 124800 | 3.43 ± 10.5% | not timed | not timed | 4.18 ± 1.4% | 0.22 ± 2.3% | not timed | not timed | 3.20 ± 17.6% | | 1.07 | 0.82 | 15.81 |
| 06-cloud-flare-redos/original | 107 | 349.21 ± 0.5% | not timed | not timed | 192.61 ± 5.5% | 20.63 ± 0.2% | not timed | not timed | 320.27 ± 0.9% | | 1.09 | 1.81 | 16.93 |
| 06-cloud-flare-redos/simplified-short | 102 | 329.44 ± 7.8% | not timed | not timed | 192.23 ± 12.8% | 22.00 ± 7.8% | not timed | not timed | 328.06 ± 2.5% | | 1.00 | 1.71 | 14.97 |
| 06-cloud-flare-redos/simplified-long | 10000 | 465.31 ± 0.3% | not timed | not timed | 211.78 ± 0.4% | 24.16 ± 0.6% | not timed | not timed | 464.96 ± 0.1% | | 1.00 | 2.20 | 19.26 |
| 07-unicode-character-data/parse-line | 558784 | 204.21 ± 18.5% | not timed | not timed | 160.85 ± 4.1% | 37.31 ± 1.4% | not timed | not timed | 205.43 ± 0.5% | | 0.99 | 1.27 | 5.47 |
| 08-words/all-english | 56691 | 96.31 ± 4.3% | not timed | not timed | 72.86 ± 6.0% | 10.53 ± 14.9% | not timed | not timed | 96.42 ± 0.6% | | 1.00 | 1.32 | 9.15 |
| 08-words/long-english | 839 | 537.05 ± 0.1% | not timed | not timed | 515.72 ± 0.1% | 26.22 ± 13.8% | not timed | not timed | 536.42 ± 1.2% | | 1.00 | 1.04 | 20.48 |
| 09-aws-keys/full | 0 | 415.64 ± 0.2% | not timed | not timed | 448.37 ± 0.4% | 52.42 ± 5.2% | not timed | not timed | 415.38 ± 0.3% | | 1.00 | 0.93 | 7.93 |
| 09-aws-keys/quick | 0 | 960.96 ± 16.9% | not timed | not timed | 803.55 ± 0.2% | 331.58 ± 1.0% | not timed | not timed | 959.38 ± 4.1% | | 1.00 | 1.20 | 2.90 |
| 10-bounded-repeat/letters-en | 1833 | 483.11 ± 0.3% | not timed | not timed | 432.28 ± 0.2% | 16.87 ± 1.1% | not timed | not timed | 483.07 ± 1.2% | | 1.00 | 1.12 | 28.64 |
| 10-bounded-repeat/letters-ru | 3475 | 429.82 ± 0.4% | not timed | not timed | 408.94 ± 5.4% | 17.58 ± 50.9% | not timed | not timed | 429.95 ± 0.3% | | 1.00 | 1.05 | 24.45 |
| 10-bounded-repeat/context | 53 | 64.88 ± 0.7% | not timed | not timed | 56.28 ± 0.9% | 16.55 ± 3.6% | not timed | not timed | 63.80 ± 1.0% | | 1.02 | 1.15 | 3.92 |
| 10-bounded-repeat/capitals | 11 | 558.51 ± 8.2% | not timed | not timed | 531.82 ± 3.9% | 30.92 ± 7.0% | not timed | not timed | 554.65 ± 8.3% | | 1.01 | 1.05 | 18.06 |
| 11-unstructured-to-json/extract | 600 | 55.70 ± 3.2% | not timed | not timed | 62.36 ± 3.8% | 40.52 ± 8.3% | not timed | not timed | 55.55 ± 20.9% | | 1.00 | 0.89 | 1.37 |
| 12-dictionary/single | 1 | 459.18 ± 2.2% | not timed | not timed | 442.47 ± 0.2% | 0.31 ± 5.0% | not timed | not timed | 460.53 ± 0.5% | | 1.00 | 1.04 | 1491.27 |
| 14-quadratic/1x | 100 | 21.15 ± 4.2% | not timed | not timed | 9.10 ± 4.0% | 0.80 ± 3.0% | not timed | not timed | 20.85 ± 33.4% | | 1.01 | 2.32 | 26.46 |
| 14-quadratic/2x | 200 | 16.15 ± 3.3% | not timed | not timed | 4.84 ± 1.3% | 0.43 ± 3.9% | not timed | not timed | 16.14 ± 0.9% | | 1.00 | 3.34 | 37.50 |
| 14-quadratic/10x | 1000 | 5.62 ± 0.1% | not timed | not timed | 1.05 ± 0.2% | 0.09 ± 0.7% | not timed | not timed | 5.62 ± 1.2% | | 1.00 | 5.35 | 60.43 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.10 ± 0.7% | not timed | not timed | 0.39 ± 0.6% | 0.48 ± 18.1% | not timed | not timed | 1.09 ± 0.9% | | 1.01 | 2.86 | 2.29 |
| 04-ruff-noqa/compile-real | 1 | 84.55 ± 0.3% | not timed | not timed | 12.96 ± 1.8% | 125.95 ± 2.1% | not timed | not timed | 84.61 ± 1.2% | | 1.00 | 6.52 | 0.67 |
| 05-lexer-veryl/compile-single | 1 | 12.17 ± 9.5% | not timed | not timed | 2.37 ± 0.8% | 5.87 ± 1.8% | not timed | not timed | 12.14 ± 1.0% | | 1.00 | 5.15 | 2.07 |
| 07-unicode-character-data/compile | 1 | 51.87 ± 0.4% | not timed | not timed | 24.69 ± 1.6% | 32.84 ± 2.0% | not timed | not timed | 51.63 ± 1.2% | | 1.00 | 2.10 | 1.58 |
| 09-aws-keys/compile-full | 1 | 34.56 ± 5.6% | not timed | not timed | 7.36 ± 1.0% | 20.35 ± 5.7% | not timed | not timed | 34.04 ± 9.3% | | 1.02 | 4.69 | 1.70 |
| 09-aws-keys/compile-quick | 1 | 149.81 ± 15.4% | not timed | not timed | 45.31 ± 0.9% | 117.57 ± 2.3% | not timed | not timed | 149.67 ± 2.3% | | 1.00 | 3.31 | 1.27 |
| 10-bounded-repeat/compile-context | 1 | 10.49 ± 6.1% | not timed | not timed | 11.76 ± 0.5% | 15.11 ± 2.5% | not timed | not timed | 10.38 ± 6.1% | | 1.01 | 0.89 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 72.20 ± 1.1% | not timed | not timed | 8.83 ± 1.0% | 21.73 ± 2.8% | not timed | not timed | 72.15 ± 0.3% | | 1.00 | 8.17 | 3.32 |
| 11-unstructured-to-json/compile | 1 | 77.37 ± 0.5% | not timed | not timed | 36.57 ± 1.4% | 60.00 ± 4.4% | not timed | not timed | 77.00 ± 1.9% | | 1.00 | 2.12 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.28 ± 0.5% | not timed | not timed | 0.07 ± 1.3% | 0.09 ± 35.9% | not timed | not timed | 0.28 ± 3.3% | | 1.01 | 4.18 | 3.24 |

