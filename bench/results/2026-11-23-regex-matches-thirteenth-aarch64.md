# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127370160 |
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
| literal: a word | 217 | 15802.46 ± 2.0% | 1037.43 ± 0.1% | 28.71 ± 0.1% | 17825.50 ± 1.8% | 9171.33 ± 8.5% | 17.58 ± 0.4% | 86.09 ± 0.3% | 15874.09 ± 2.5% | 15.23 | 1.00 | 0.89 | 1.72 |
| literal: a word that is not there | 0 | 18488.29 ± 4.7% | 1047.50 ± 0.1% | 28.66 ± 0.6% | 19367.24 ± 1.5% | 28360.24 ± 2.2% | 17.41 ± 0.1% | 81.87 ± 0.2% | 18545.41 ± 3.9% | 17.65 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6034.51 ± 0.4% | 1018.04 ± 0.2% | 14.76 ± 0.3% | 3940.58 ± 0.2% | 21.86 ± 0.2% | 5.30 ± 0.1% | 6.70 ± 0.1% | 6014.91 ± 0.3% | 5.93 | 1.00 | 1.53 | 276.04 |
| literal: a word in any case | 217 | 12449.57 ± 0.6% | 1037.72 ± 0.1% | 21.56 ± 2.4% | 3959.12 ± 0.4% | 38.01 ± 0.5% | refused | differs | 12454.02 ± 0.4% | 12.00 | 1.00 | 3.14 | 327.50 |
| literal: an href attribute | 33 | 13624.20 ± 1.5% | 1045.07 ± 0.2% | 27.40 ± 0.5% | 16577.61 ± 1.2% | 2261.49 ± 0.3% | 13.38 ± 0.2% | 75.34 ± 0.3% | 13552.65 ± 3.2% | 13.04 | 1.01 | 0.82 | 6.02 |
| literal: a word, second text | 123 | 16045.01 ± 0.6% | 1041.60 ± 0.1% | 28.27 ± 0.2% | 17801.32 ± 2.2% | 7718.19 ± 3.4% | 19.70 ± 0.5% | 68.81 ± 0.4% | 16104.49 ± 1.1% | 15.40 | 1.00 | 0.90 | 2.08 |
| class: two capitalized words | 1331 | 1122.64 ± 0.2% | 972.09 ± 0.2% | 26.09 ± 0.3% | 585.12 ± 0.1% | 40.63 ± 8.6% | 14.96 ± 0.2% | 68.37 ± 0.4% | 1121.56 ± 0.2% | 1.15 | 1.00 | 1.92 | 27.63 |
| class: a word that ends in ing | 3399 | 882.16 ± 0.1% | 883.39 ± 0.1% | 18.21 ± 0.2% | 547.95 ± 0.1% | 29.65 ± 6.4% | 8.21 ± 0.2% | 18.24 ± 0.6% | 881.73 ± 0.2% | 1.00 | 1.00 | 1.61 | 29.75 |
| class: a word in capitals | 2332 | 1438.79 ± 0.5% | 943.40 ± 0.2% | 27.76 ± 0.1% | 570.02 ± 0.2% | 43.62 ± 6.5% | 17.24 ± 0.4% | 83.03 ± 0.3% | 1434.58 ± 0.4% | 1.53 | 1.00 | 2.52 | 32.99 |
| class: a number | 8288 | 1906.46 ± 0.1% | 812.58 ± 0.1% | 27.90 ± 0.4% | 1714.13 ± 0.2% | 43.06 ± 17.6% | 0.55 ± 0.5% | 56.83 ± 0.3% | 1899.15 ± 0.1% | 2.35 | 1.00 | 1.11 | 44.28 |
| class: two capitalized words, second text | 5359 | 734.10 ± 0.2% | 731.23 ± 0.3% | 23.38 ± 0.1% | 484.18 ± 0.2% | 35.11 ± 12.6% | 16.66 ± 0.3% | 63.57 ± 0.2% | 733.11 ± 0.1% | 1.00 | 1.00 | 1.52 | 20.91 |
| other: a word between two words | 6104 | 750.85 ± 0.2% | 757.16 ± 0.2% | 23.57 ± 0.2% | 737.67 ± 0.2% | 109.42 ± 13.5% | 11.34 ± 0.3% | 69.27 ± 0.2% | 747.44 ± 0.1% | 0.99 | 1.00 | 1.02 | 6.86 |
| other: a number before a unit, second text | 1481 | 5424.57 ± 0.5% | 977.03 ± 0.1% | 26.05 ± 0.3% | 5625.55 ± 0.6% | 40.85 ± 15.7% | 17.80 ± 0.2% | 66.81 ± 0.3% | 5418.13 ± 0.9% | 5.55 | 1.00 | 0.96 | 132.79 |
| other: a heading's start tag | 110 | 12357.77 ± 0.5% | 1034.52 ± 0.1% | 27.69 ± 0.2% | 1709.36 ± 0.4% | 1584.70 ± 5.5% | 16.25 ± 0.5% | 88.47 ± 0.2% | 12400.85 ± 0.7% | 11.95 | 1.00 | 7.23 | 7.80 |
| other: a whole word | 217 | 13675.92 ± 0.9% | 1036.94 ± 0.2% | 29.97 ± 0.4% | 14233.13 ± 1.0% | 49.50 ± 0.3% | 13.76 ± 0.2% | 55.56 ± 0.1% | 13665.11 ± 1.8% | 13.19 | 1.00 | 0.96 | 276.26 |
| other: a line's first word, second text | 3716 | 1933.93 ± 0.7% | 867.11 ± 0.1% | 31.36 ± 0.3% | 1727.53 ± 0.6% | 61.61 ± 7.9% | refused | refused | 1920.08 ± 0.7% | 2.23 | 1.01 | 1.12 | 31.39 |
| other: fourteen octets before an x | 87 | 19179.09 ± 1.9% | 238.76 ± 0.2% | 6.14 ± 0.1% | 3974.58 ± 0.6% | 10.64 ± 0.2% | differs | 17.68 ± 0.4% | 19347.41 ± 1.0% | 80.33 | 0.99 | 4.83 | 1803.16 |
| other: a Greek word | 21815 | 461.01 ± 0.3% | 353.80 ± 0.1% | 31.16 ± 0.1% | 289.62 ± 0.1% | 43.84 ± 9.8% | differs | refused | 458.68 ± 0.6% | 1.30 | 1.01 | 1.59 | 10.52 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.85 ± 0.3% | 25.83 ± 0.1% | 0.82 ± 0.3% | 19.71 ± 0.4% | 2.75 ± 0.9% | differs | 4.03 ± 0.6% | 25.86 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.39 |
| a UUID | 32895 | 21.05 ± 0.3% | 21.15 ± 0.3% | 0.65 ± 0.3% | 15.12 ± 0.5% | 3.10 ± 0.2% | 0.72 ± 0.3% | 3.61 ± 0.7% | 21.13 ± 0.2% | 1.00 | 1.00 | 1.39 | 6.79 |
| an IPv4 address | 33176 | 36.98 ± 0.1% | 36.88 ± 0.4% | 2.09 ± 0.2% | 29.01 ± 0.1% | 6.67 ± 0.1% | differs | 4.15 ± 0.2% | 36.99 ± 0.3% | 1.00 | 1.00 | 1.28 | 5.55 |
| a date and time | 32954 | 31.05 ± 0.4% | 31.08 ± 0.2% | 1.42 ± 0.2% | 21.18 ± 0.2% | 7.02 ± 0.4% | 1.19 ± 0.2% | 7.04 ± 0.2% | 31.02 ± 0.3% | 1.00 | 1.00 | 1.47 | 4.43 |
| a field path | 32606 | 29.52 ± 0.2% | 29.43 ± 0.4% | 1.01 ± 0.7% | 22.95 ± 0.2% | 3.53 ± 1.0% | differs | 2.92 ± 0.1% | 29.46 ± 0.1% | 1.00 | 1.00 | 1.29 | 8.37 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.49 ± 0.3% | 11.52 ± 0.3% | 11.53 ± 0.3% | 11.46 ± 0.4% | 4.91 ± 1.6% | 0.91 ± 0.7% | none | 11.48 ± 0.1% | 1.00 | 1.00 | 1.00 | 2.34 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 216.80 ± 0.2% | 217.59 ± 0.2% | 252.05 ± 0.2% | 86.19 ± 0.4% | 216.91 ± 10.9% | 480.90 ± 1.6% | 3744.33 ± 0.5% | 216.79 ± 0.4% | 1.00 | 1.00 | 2.52 | 1.00 |
| a UUID | 62 | 142.55 ± 0.3% | 142.85 ± 0.2% | 157.35 ± 0.2% | 46.34 ± 0.8% | 97.92 ± 1.2% | 190.71 ± 3.2% | 4474.11 ± 0.5% | 142.58 ± 0.3% | 1.00 | 1.00 | 3.08 | 1.46 |
| an IPv4 address | 29 | 438.38 ± 0.4% | 442.69 ± 0.3% | 614.37 ± 0.6% | 77.12 ± 0.2% | 128.73 ± 2.5% | 302.62 ± 1.4% | 7706.26 ± 0.5% | 438.57 ± 0.1% | 0.99 | 1.00 | 5.68 | 3.41 |
| a date and time | 56 | 318.62 ± 0.3% | 319.91 ± 0.4% | 401.72 ± 0.5% | 72.76 ± 0.5% | 133.99 ± 0.8% | 324.87 ± 1.5% | 4963.96 ± 1.0% | 318.34 ± 0.3% | 1.00 | 1.00 | 4.38 | 2.38 |
| a field path | 39 | 202.40 ± 0.4% | 203.18 ± 0.4% | 233.08 ± 0.1% | 80.72 ± 1.1% | 204.02 ± 1.5% | 502.02 ± 2.9% | 4850.69 ± 0.5% | 202.32 ± 0.4% | 1.00 | 1.00 | 2.51 | 0.99 |
| literal: a word | 7 | 668.19 ± 0.2% | 722.11 ± 0.2% | 1291.91 ± 0.8% | 521.66 ± 0.1% | 619.42 ± 1.6% | 952.68 ± 0.6% | 30897.78 ± 0.6% | 668.95 ± 0.5% | 0.93 | 1.00 | 1.28 | 1.08 |
| literal: a word that is not there | 8 | 638.77 ± 0.4% | 695.06 ± 0.4% | 1219.15 ± 0.1% | 479.59 ± 0.5% | 587.23 ± 3.2% | 904.07 ± 0.3% | 29401.02 ± 0.1% | 639.52 ± 0.2% | 0.92 | 1.00 | 1.33 | 1.09 |
| literal: one of four words | 26 | 256.63 ± 0.4% | 422.14 ± 0.2% | 570.91 ± 0.3% | 50.20 ± 1.2% | 237.45 ± 1.5% | 374.77 ± 1.3% | 15701.05 ± 0.3% | 256.85 ± 0.3% | 0.61 | 1.00 | 5.11 | 1.08 |
| literal: a word in any case | 11 | 523.76 ± 0.3% | 567.44 ± 0.5% | 872.81 ± 0.2% | 15.94 ± 1.6% | 640.49 ± 1.4% | refused | 23612.77 ± 0.7% | 522.68 ± 0.3% | 0.92 | 1.00 | 32.85 | 0.82 |
| literal: an href attribute | 12 | 349.98 ± 0.4% | 361.12 ± 0.5% | 470.72 ± 0.8% | 46.01 ± 0.5% | 496.58 ± 0.9% | 773.50 ± 1.3% | 22086.93 ± 0.3% | 350.08 ± 0.4% | 0.97 | 1.00 | 7.61 | 0.70 |
| literal: a word, second text | 10 | 596.37 ± 0.5% | 658.13 ± 0.8% | 1102.44 ± 0.6% | 400.61 ± 0.7% | 533.87 ± 1.5% | 799.88 ± 0.5% | 27271.82 ± 0.2% | 595.97 ± 0.5% | 0.91 | 1.00 | 1.49 | 1.12 |
| class: two capitalized words | 23 | 460.49 ± 0.1% | 490.64 ± 0.5% | 712.24 ± 0.2% | 99.54 ± 0.2% | 499.56 ± 0.9% | 744.37 ± 0.4% | 6372.45 ± 0.1% | 460.83 ± 0.3% | 0.94 | 1.00 | 4.63 | 0.92 |
| class: a word that ends in ing | 9 | 599.51 ± 0.3% | 667.32 ± 0.4% | 1178.30 ± 0.3% | 131.88 ± 2.0% | 746.54 ± 1.2% | 1104.10 ± 0.6% | 15931.51 ± 0.1% | 598.47 ± 0.3% | 0.90 | 1.00 | 4.55 | 0.80 |
| class: a word in capitals | 16 | 521.29 ± 0.3% | 559.53 ± 0.6% | 883.81 ± 0.3% | 134.78 ± 0.6% | 742.39 ± 2.2% | 1024.88 ± 1.5% | 8378.50 ± 0.1% | 520.73 ± 0.3% | 0.93 | 1.00 | 3.87 | 0.70 |
| class: a number | 6 | 659.95 ± 0.3% | 723.46 ± 0.3% | 1335.68 ± 0.1% | 41.81 ± 0.7% | 1380.33 ± 0.8% | 1853.42 ± 1.7% | 22780.17 ± 0.0% | 659.62 ± 0.2% | 0.91 | 1.00 | 15.78 | 0.48 |
| class: two capitalized words, second text | 23 | 460.19 ± 0.3% | 490.67 ± 0.9% | 711.25 ± 0.6% | 101.01 ± 0.4% | 496.45 ± 3.3% | 765.29 ± 0.6% | 6371.01 ± 0.1% | 460.24 ± 0.4% | 0.94 | 1.00 | 4.56 | 0.93 |
| other: a word between two words | 13 | 583.83 ± 0.1% | 604.16 ± 0.4% | 962.27 ± 0.3% | 133.28 ± 0.7% | 495.59 ± 11.4% | 812.93 ± 0.4% | 14763.50 ± 0.1% | 582.93 ± 0.2% | 0.97 | 1.00 | 4.38 | 1.18 |
| other: a number before a unit, second text | 15 | 401.32 ± 0.3% | 436.69 ± 0.1% | 599.39 ± 0.2% | 39.60 ± 0.4% | 635.27 ± 0.8% | 891.05 ± 1.2% | 15284.28 ± 0.1% | 401.06 ± 0.2% | 0.92 | 1.00 | 10.14 | 0.63 |
| other: a heading's start tag | 13 | 361.32 ± 0.5% | 366.96 ± 0.5% | 477.79 ± 0.3% | 43.89 ± 0.5% | 623.69 ± 0.9% | 882.34 ± 1.1% | 18388.72 ± 0.1% | 361.20 ± 0.3% | 0.98 | 1.00 | 8.23 | 0.58 |
| other: a whole word | 11 | 618.14 ± 0.6% | 658.52 ± 0.7% | 1097.39 ± 0.3% | 118.43 ± 0.5% | 558.54 ± 2.0% | 839.40 ± 0.9% | 26909.71 ± 0.2% | 618.01 ± 0.6% | 0.94 | 1.00 | 5.22 | 1.11 |
| other: a line's first word, second text | 17 | 556.88 ± 0.6% | 579.20 ± 0.4% | 930.15 ± 0.2% | 129.27 ± 0.1% | 704.35 ± 1.0% | refused | refused | 556.18 ± 0.5% | 0.96 | 1.00 | 4.31 | 0.79 |
| other: fourteen octets before an x | 16 | 113.09 ± 0.4% | 162.83 ± 1.1% | 185.69 ± 1.7% | 15.18 ± 0.3% | 448.58 ± 1.8% | 415.26 ± 0.6% | 13018.56 ± 0.3% | 112.92 ± 0.2% | 0.69 | 1.00 | 7.45 | 0.25 |
| other: a Greek word | 8 | 450.44 ± 0.2% | 591.25 ± 0.5% | 966.37 ± 0.0% | 59.04 ± 0.5% | 1369.52 ± 0.9% | 1799.04 ± 0.5% | refused | 450.61 ± 0.2% | 0.76 | 1.00 | 7.63 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12648.63 ± 0.9% | not timed | not timed | 15930.53 ± 2.0% | 2042.91 ± 16.2% | not timed | not timed | 12699.86 ± 1.1% | | 1.00 | 0.79 | 6.19 |
| 01-literal/sherlock-casei-en | 522 | 3879.50 ± 1.2% | not timed | not timed | 3588.61 ± 0.5% | 32.49 ± 0.1% | not timed | not timed | 3869.52 ± 0.7% | | 1.00 | 1.08 | 119.42 |
| 01-literal/sherlock-ru | 724 | 13590.17 ± 0.5% | not timed | not timed | 17321.35 ± 0.5% | 1456.95 ± 8.3% | not timed | not timed | 13573.48 ± 0.4% | | 1.00 | 0.78 | 9.33 |
| 01-literal/sherlock-casei-ru | 746 | 5225.16 ± 0.1% | not timed | not timed | 3318.41 ± 0.1% | 31.73 ± 0.2% | not timed | not timed | 5254.02 ± 0.1% | | 0.99 | 1.57 | 164.65 |
| 01-literal/sherlock-zh | 30 | 16856.19 ± 0.9% | not timed | not timed | 18259.47 ± 1.5% | 2677.65 ± 13.6% | not timed | not timed | 16820.76 ± 0.4% | | 1.00 | 0.92 | 6.30 |
| 02-literal-alternate/sherlock-en | 714 | 5809.26 ± 0.4% | not timed | not timed | 3935.91 ± 0.3% | 16.58 ± 0.2% | not timed | not timed | 5803.60 ± 0.2% | | 1.00 | 1.48 | 350.30 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1664.71 ± 0.3% | not timed | not timed | 696.80 ± 0.2% | 11.10 ± 0.1% | not timed | not timed | 1660.91 ± 0.4% | | 1.00 | 2.39 | 149.99 |
| 02-literal-alternate/sherlock-ru | 899 | 4647.96 ± 0.2% | not timed | not timed | 3256.21 ± 0.2% | 22.58 ± 14.7% | not timed | not timed | 4646.31 ± 0.4% | | 1.00 | 1.43 | 205.84 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1776.36 ± 0.5% | not timed | not timed | 1209.43 ± 0.2% | 9.15 ± 0.1% | not timed | not timed | 1773.62 ± 0.3% | | 1.00 | 1.47 | 194.18 |
| 02-literal-alternate/sherlock-zh | 207 | 7046.34 ± 0.3% | not timed | not timed | 4163.53 ± 0.2% | 31.44 ± 0.1% | not timed | not timed | 7055.27 ± 0.3% | | 1.00 | 1.69 | 224.12 |
| 03-date/ascii | 111817 | 124.88 ± 0.8% | not timed | not timed | 96.31 ± 0.1% | 0.20 ± 4.1% | not timed | not timed | 123.52 ± 1.2% | | 1.01 | 1.30 | 616.10 |
| 04-ruff-noqa/real | 84 | 554.12 ± 0.4% | not timed | not timed | 460.63 ± 0.2% | 19.55 ± 1.3% | not timed | not timed | 553.58 ± 0.2% | | 1.00 | 1.20 | 28.34 |
| 04-ruff-noqa/tweaked | 44 | 544.80 ± 0.3% | not timed | not timed | 459.18 ± 0.0% | 362.52 ± 0.5% | not timed | not timed | 543.88 ± 0.1% | | 1.00 | 1.19 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.67 ± 0.7% | not timed | not timed | 4.94 ± 0.2% | 0.20 ± 5.9% | not timed | not timed | 3.68 ± 4.0% | | 1.00 | 0.74 | 18.34 |
| 06-cloud-flare-redos/original | 107 | 271.02 ± 0.2% | not timed | not timed | 216.56 ± 0.2% | 24.74 ± 0.7% | not timed | not timed | 269.73 ± 0.1% | | 1.00 | 1.25 | 10.96 |
| 06-cloud-flare-redos/simplified-short | 102 | 264.34 ± 0.7% | not timed | not timed | 228.81 ± 0.1% | 26.61 ± 0.2% | not timed | not timed | 264.07 ± 0.9% | | 1.00 | 1.16 | 9.93 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.38 ± 0.1% | not timed | not timed | 255.74 ± 0.1% | 28.71 ± 0.1% | not timed | not timed | 294.27 ± 0.1% | | 1.00 | 1.15 | 10.25 |
| 07-unicode-character-data/parse-line | 558784 | 242.47 ± 0.4% | not timed | not timed | 167.92 ± 0.1% | 42.14 ± 5.5% | not timed | not timed | 240.05 ± 2.2% | | 1.01 | 1.44 | 5.75 |
| 08-words/all-english | 56691 | 119.68 ± 0.7% | not timed | not timed | 82.86 ± 0.2% | 12.75 ± 8.1% | not timed | not timed | 119.62 ± 0.5% | | 1.00 | 1.44 | 9.39 |
| 08-words/long-english | 839 | 1005.72 ± 0.2% | not timed | not timed | 597.77 ± 0.1% | 32.65 ± 0.2% | not timed | not timed | 1005.34 ± 0.4% | | 1.00 | 1.68 | 30.80 |
| 09-aws-keys/full | 0 | 412.51 ± 0.0% | not timed | not timed | 460.45 ± 0.1% | 64.39 ± 3.4% | not timed | not timed | 412.52 ± 0.1% | | 1.00 | 0.90 | 6.41 |
| 09-aws-keys/quick | 0 | 733.80 ± 0.1% | not timed | not timed | 987.91 ± 0.1% | 419.01 ± 0.8% | not timed | not timed | 730.31 ± 0.1% | | 1.00 | 0.74 | 1.75 |
| 10-bounded-repeat/letters-en | 1833 | 635.25 ± 0.5% | not timed | not timed | 517.74 ± 0.6% | 19.45 ± 0.7% | not timed | not timed | 633.48 ± 0.2% | | 1.00 | 1.23 | 32.66 |
| 10-bounded-repeat/letters-ru | 3475 | 380.69 ± 0.2% | not timed | not timed | 477.56 ± 0.2% | 21.74 ± 10.2% | not timed | not timed | 379.62 ± 0.3% | | 1.00 | 0.80 | 17.51 |
| 10-bounded-repeat/context | 53 | 79.00 ± 1.2% | not timed | not timed | 65.30 ± 0.6% | 19.81 ± 0.4% | not timed | not timed | 79.12 ± 1.1% | | 1.00 | 1.21 | 3.99 |
| 10-bounded-repeat/capitals | 11 | 1044.80 ± 0.1% | not timed | not timed | 618.09 ± 0.0% | 36.33 ± 0.1% | not timed | not timed | 1045.29 ± 0.1% | | 1.00 | 1.69 | 28.76 |
| 11-unstructured-to-json/extract | 600 | 48.25 ± 0.1% | not timed | not timed | 77.60 ± 0.3% | 48.91 ± 1.3% | not timed | not timed | 47.07 ± 1.0% | | 1.03 | 0.62 | 0.99 |
| 12-dictionary/single | 1 | 571.19 ± 0.2% | not timed | not timed | 561.97 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 572.41 ± 0.1% | | 1.00 | 1.02 | 1392.09 |
| 14-quadratic/1x | 100 | 13.05 ± 0.1% | not timed | not timed | 10.07 ± 0.3% | 0.96 ± 2.8% | not timed | not timed | 12.98 ± 1.6% | | 1.01 | 1.30 | 13.53 |
| 14-quadratic/2x | 200 | 8.00 ± 0.3% | not timed | not timed | 5.55 ± 0.2% | 0.53 ± 2.0% | not timed | not timed | 7.96 ± 0.3% | | 1.00 | 1.44 | 15.00 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 1.86 ± 0.3% | | 1.00 | 1.53 | 16.08 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.7% | not timed | not timed | 0.34 ± 0.3% | 0.54 ± 3.2% | not timed | not timed | 1.54 ± 1.1% | | 1.00 | 4.51 | 2.86 |
| 04-ruff-noqa/compile-real | 1 | 85.25 ± 0.1% | not timed | not timed | 13.87 ± 0.2% | 137.74 ± 2.2% | not timed | not timed | 84.86 ± 1.2% | | 1.00 | 6.14 | 0.62 |
| 05-lexer-veryl/compile-single | 1 | 14.51 ± 0.1% | not timed | not timed | 2.50 ± 0.7% | 6.39 ± 2.4% | not timed | not timed | 14.45 ± 1.1% | | 1.00 | 5.79 | 2.27 |
| 07-unicode-character-data/compile | 1 | 54.95 ± 0.1% | not timed | not timed | 26.14 ± 0.1% | 35.61 ± 1.8% | not timed | not timed | 54.37 ± 1.0% | | 1.01 | 2.10 | 1.54 |
| 09-aws-keys/compile-full | 1 | 42.19 ± 0.1% | not timed | not timed | 8.32 ± 0.3% | 23.09 ± 0.8% | not timed | not timed | 41.98 ± 0.7% | | 1.00 | 5.07 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 188.88 ± 0.2% | not timed | not timed | 47.51 ± 0.2% | 130.00 ± 8.0% | not timed | not timed | 187.56 ± 0.9% | | 1.01 | 3.98 | 1.45 |
| 10-bounded-repeat/compile-context | 1 | 14.50 ± 1.5% | not timed | not timed | 11.15 ± 0.4% | 15.59 ± 0.7% | not timed | not timed | 14.49 ± 0.5% | | 1.00 | 1.30 | 0.93 |
| 10-bounded-repeat/compile-capitals | 1 | 85.30 ± 0.3% | not timed | not timed | 8.15 ± 0.3% | 23.28 ± 1.2% | not timed | not timed | 84.65 ± 0.8% | | 1.01 | 10.46 | 3.66 |
| 11-unstructured-to-json/compile | 1 | 86.28 ± 0.2% | not timed | not timed | 40.74 ± 0.2% | 66.52 ± 2.9% | not timed | not timed | 86.13 ± 0.7% | | 1.00 | 2.12 | 1.30 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 1.9% | 0.09 ± 10.2% | not timed | not timed | 0.36 ± 1.1% | | 1.01 | 5.25 | 3.86 |

