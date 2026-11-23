# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117677710 |
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
| literal: a word | 217 | 23228.05 ± 1.3% | 854.53 ± 0.8% | 26.41 ± 2.5% | 24015.98 ± 0.8% | 8999.88 ± 6.3% | 11.89 ± 1.1% | 84.55 ± 2.2% | 23429.24 ± 1.0% | 27.18 | 0.99 | 0.97 | 2.58 |
| literal: a word that is not there | 0 | 29818.22 ± 1.6% | 865.28 ± 1.1% | 26.52 ± 3.2% | 26301.81 ± 2.6% | 29356.97 ± 2.7% | 11.58 ± 1.0% | 72.78 ± 3.3% | 29625.13 ± 1.5% | 34.46 | 1.01 | 1.13 | 1.02 |
| literal: one of four words | 661 | 10098.11 ± 5.8% | 837.20 ± 10.1% | 14.89 ± 2.5% | 7636.76 ± 0.7% | 22.95 ± 0.7% | 3.48 ± 1.0% | 5.93 ± 1.5% | 9927.46 ± 3.4% | 12.06 | 1.02 | 1.32 | 439.99 |
| literal: a word in any case | 217 | 20266.31 ± 1.1% | 854.67 ± 0.9% | 19.41 ± 2.4% | 7900.57 ± 1.2% | 43.42 ± 2.9% | refused | differs | 20498.14 ± 3.4% | 23.71 | 0.99 | 2.57 | 466.76 |
| literal: an href attribute | 33 | 21149.41 ± 1.2% | 858.86 ± 1.7% | 24.05 ± 1.5% | 21684.36 ± 3.2% | 2039.34 ± 3.4% | 8.47 ± 0.7% | 75.42 ± 2.4% | 21209.12 ± 1.1% | 24.62 | 1.00 | 0.98 | 10.37 |
| literal: a word, second text | 123 | 24213.29 ± 2.3% | 858.68 ± 0.5% | 25.90 ± 1.8% | 23817.29 ± 1.2% | 7108.70 ± 2.9% | 15.42 ± 0.9% | 72.90 ± 1.0% | 24408.60 ± 1.9% | 28.20 | 0.99 | 1.02 | 3.41 |
| class: two capitalized words | 1331 | 789.31 ± 0.9% | 785.77 ± 1.2% | 24.62 ± 0.7% | 481.62 ± 0.5% | 38.02 ± 6.4% | 10.16 ± 1.2% | 61.66 ± 0.8% | 787.64 ± 0.6% | 1.00 | 1.00 | 1.64 | 20.76 |
| class: a word that ends in ing | 3399 | 724.36 ± 0.8% | 724.60 ± 1.3% | 16.37 ± 1.4% | 453.31 ± 0.5% | 27.44 ± 10.5% | 5.71 ± 0.4% | 16.78 ± 2.4% | 722.13 ± 0.4% | 1.00 | 1.00 | 1.60 | 26.40 |
| class: a word in capitals | 2332 | 1078.49 ± 0.9% | 776.34 ± 0.4% | 26.02 ± 1.1% | 473.26 ± 1.0% | 41.84 ± 4.1% | 12.22 ± 0.7% | 78.64 ± 1.0% | 1075.83 ± 0.6% | 1.39 | 1.00 | 2.28 | 25.78 |
| class: a number | 8288 | 1531.91 ± 4.4% | 654.48 ± 4.1% | 25.84 ± 2.1% | 1649.05 ± 0.7% | 42.62 ± 16.5% | 0.34 ± 0.4% | 57.30 ± 4.1% | 1537.12 ± 5.0% | 2.34 | 1.00 | 0.93 | 35.94 |
| class: two capitalized words, second text | 5359 | 567.90 ± 1.7% | 566.14 ± 2.1% | 22.38 ± 1.0% | 399.89 ± 10.5% | 32.68 ± 11.6% | 13.23 ± 1.3% | 56.03 ± 0.5% | 571.29 ± 1.0% | 1.00 | 0.99 | 1.42 | 17.38 |
| other: a word between two words | 6104 | 613.19 ± 2.3% | 610.11 ± 1.8% | 22.06 ± 1.7% | 683.34 ± 0.8% | 104.60 ± 15.9% | 7.72 ± 0.2% | 66.44 ± 1.7% | 613.53 ± 5.4% | 1.01 | 1.00 | 0.90 | 5.86 |
| other: a number before a unit, second text | 1481 | 6870.31 ± 3.3% | 803.46 ± 0.9% | 24.47 ± 2.6% | 7186.49 ± 1.1% | 39.12 ± 2.2% | 13.86 ± 1.0% | 60.13 ± 2.1% | 6672.63 ± 2.3% | 8.55 | 1.03 | 0.96 | 175.61 |
| other: a heading's start tag | 110 | 15767.88 ± 2.1% | 853.33 ± 1.0% | 26.02 ± 3.3% | 2081.97 ± 1.9% | 1510.49 ± 5.4% | 10.51 ± 1.3% | 87.80 ± 1.3% | 15751.62 ± 2.5% | 18.48 | 1.00 | 7.57 | 10.44 |
| other: a whole word | 217 | 18860.47 ± 2.5% | 859.04 ± 0.6% | 26.90 ± 2.4% | 19564.72 ± 3.4% | 45.19 ± 2.6% | 10.10 ± 1.1% | 50.37 ± 5.0% | 18960.26 ± 2.1% | 21.96 | 0.99 | 0.96 | 417.40 |
| other: a line's first word, second text | 3716 | 1824.94 ± 1.4% | 704.65 ± 0.6% | 28.04 ± 2.0% | 1917.06 ± 1.3% | 62.72 ± 5.9% | refused | refused | 1821.52 ± 1.2% | 2.59 | 1.00 | 0.95 | 29.10 |
| other: fourteen octets before an x | 87 | 26839.67 ± 1.7% | 239.05 ± 0.4% | 5.63 ± 0.6% | 3320.00 ± 0.7% | 9.05 ± 1.3% | differs | 15.51 ± 1.0% | 26502.94 ± 1.8% | 112.28 | 1.01 | 8.08 | 2964.57 |
| other: a Greek word | 21815 | 404.49 ± 1.3% | 269.96 ± 1.0% | 29.23 ± 1.3% | 245.18 ± 1.5% | 49.38 ± 13.5% | differs | refused | 404.93 ± 1.4% | 1.50 | 1.00 | 1.65 | 8.19 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 22.48 ± 0.9% | 22.47 ± 1.4% | 0.83 ± 2.0% | 16.69 ± 0.9% | 2.48 ± 1.1% | differs | 3.68 ± 1.1% | 22.54 ± 0.6% | 1.00 | 1.00 | 1.35 | 9.07 |
| a UUID | 32895 | 20.23 ± 4.1% | 20.21 ± 1.0% | 0.59 ± 1.0% | 12.85 ± 1.5% | 2.52 ± 1.0% | 0.56 ± 0.8% | 3.16 ± 1.6% | 20.20 ± 2.5% | 1.00 | 1.00 | 1.57 | 8.03 |
| an IPv4 address | 33176 | 30.12 ± 1.7% | 30.31 ± 0.6% | 1.88 ± 0.9% | 24.67 ± 0.4% | 5.94 ± 1.1% | differs | 3.48 ± 1.4% | 30.03 ± 1.4% | 0.99 | 1.00 | 1.22 | 5.07 |
| a date and time | 32954 | 29.53 ± 1.6% | 29.41 ± 2.7% | 1.33 ± 9.2% | 18.75 ± 12.2% | 7.68 ± 2.0% | 1.04 ± 0.8% | 6.73 ± 0.9% | 29.43 ± 3.1% | 1.00 | 1.00 | 1.58 | 3.84 |
| a field path | 32606 | 24.33 ± 4.2% | 24.43 ± 2.2% | 0.98 ± 3.0% | 19.20 ± 1.7% | 2.79 ± 1.9% | differs | 2.37 ± 0.7% | 24.08 ± 2.9% | 1.00 | 1.01 | 1.27 | 8.72 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.67 ± 1.2% | 9.64 ± 3.9% | 9.65 ± 0.5% | 11.79 ± 1.2% | 5.12 ± 1.0% | 0.82 ± 4.7% | none | 9.68 ± 1.3% | 1.00 | 1.00 | 0.82 | 1.89 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 233.07 ± 1.8% | 234.34 ± 1.5% | 276.08 ± 1.6% | 85.89 ± 3.9% | 196.51 ± 1.1% | 551.12 ± 3.0% | 3233.81 ± 2.1% | 231.01 ± 3.9% | 0.99 | 1.01 | 2.71 | 1.19 |
| a UUID | 62 | 150.32 ± 1.0% | 151.79 ± 0.6% | 168.87 ± 1.5% | 46.43 ± 1.4% | 87.00 ± 11.7% | 192.81 ± 1.2% | 4015.83 ± 1.7% | 150.28 ± 0.8% | 0.99 | 1.00 | 3.24 | 1.73 |
| an IPv4 address | 29 | 461.86 ± 0.6% | 468.66 ± 1.6% | 677.55 ± 3.9% | 75.87 ± 1.4% | 117.86 ± 4.2% | 337.88 ± 5.4% | 6501.99 ± 2.2% | 462.06 ± 1.0% | 0.99 | 1.00 | 6.09 | 3.92 |
| a date and time | 56 | 358.01 ± 5.0% | 360.66 ± 6.0% | 467.70 ± 5.1% | 71.66 ± 6.7% | 124.36 ± 6.9% | 347.85 ± 2.6% | 4209.62 ± 2.7% | 357.37 ± 5.0% | 0.99 | 1.00 | 5.00 | 2.88 |
| a field path | 39 | 225.84 ± 1.1% | 226.57 ± 1.5% | 265.29 ± 1.6% | 79.02 ± 1.6% | 184.56 ± 12.0% | 565.66 ± 6.0% | 4050.18 ± 1.4% | 225.57 ± 0.6% | 1.00 | 1.00 | 2.86 | 1.22 |
| literal: a word | 7 | 722.77 ± 10.6% | 774.02 ± 8.3% | 1476.16 ± 4.2% | 527.51 ± 1.3% | 613.81 ± 22.2% | 1143.50 ± 1.1% | 26360.12 ± 2.6% | 722.52 ± 4.4% | 0.93 | 1.00 | 1.37 | 1.18 |
| literal: a word that is not there | 8 | 695.27 ± 1.0% | 743.44 ± 1.7% | 1376.52 ± 6.1% | 485.82 ± 0.9% | 584.14 ± 17.5% | 1072.64 ± 2.0% | 24931.16 ± 0.7% | 692.66 ± 3.6% | 0.94 | 1.00 | 1.43 | 1.19 |
| literal: one of four words | 26 | 271.99 ± 1.7% | 479.66 ± 1.2% | 678.93 ± 2.1% | 38.61 ± 2.3% | 228.27 ± 6.9% | 408.32 ± 4.0% | 12453.36 ± 3.4% | 272.31 ± 2.3% | 0.57 | 1.00 | 7.04 | 1.19 |
| literal: a word in any case | 11 | 535.66 ± 1.4% | 575.96 ± 1.0% | 903.42 ± 1.0% | 12.92 ± 2.5% | 628.71 ± 23.5% | refused | 19801.97 ± 2.4% | 536.97 ± 17.7% | 0.93 | 1.00 | 41.46 | 0.85 |
| literal: an href attribute | 12 | 383.01 ± 4.0% | 391.68 ± 1.6% | 528.99 ± 8.6% | 38.56 ± 14.7% | 465.05 ± 3.1% | 925.01 ± 0.6% | 18135.54 ± 0.9% | 384.27 ± 2.9% | 0.98 | 1.00 | 9.93 | 0.82 |
| literal: a word, second text | 10 | 644.54 ± 2.7% | 709.32 ± 4.5% | 1267.72 ± 1.2% | 442.26 ± 4.5% | 515.01 ± 0.9% | 947.26 ± 2.0% | 22691.90 ± 1.5% | 641.15 ± 1.7% | 0.91 | 1.01 | 1.46 | 1.25 |
| class: two capitalized words | 23 | 526.55 ± 1.8% | 564.50 ± 3.8% | 884.88 ± 1.8% | 102.00 ± 4.4% | 471.99 ± 2.6% | 858.40 ± 2.5% | 5680.72 ± 2.6% | 526.57 ± 2.5% | 0.93 | 1.00 | 5.16 | 1.12 |
| class: a word that ends in ing | 9 | 618.48 ± 1.2% | 701.32 ± 1.3% | 1344.77 ± 1.2% | 134.53 ± 1.9% | 692.27 ± 1.7% | 1330.69 ± 0.8% | 14106.51 ± 1.0% | 618.32 ± 1.3% | 0.88 | 1.00 | 4.60 | 0.89 |
| class: a word in capitals | 16 | 553.28 ± 1.3% | 603.69 ± 2.5% | 1062.39 ± 1.1% | 138.03 ± 1.7% | 704.01 ± 22.8% | 1186.00 ± 3.8% | 7608.83 ± 0.4% | 551.24 ± 1.1% | 0.92 | 1.00 | 4.01 | 0.79 |
| class: a number | 6 | 669.65 ± 0.7% | 747.24 ± 1.4% | 1525.45 ± 0.8% | 33.88 ± 1.2% | 1272.73 ± 3.6% | 2301.97 ± 4.0% | 20960.71 ± 2.2% | 669.17 ± 1.6% | 0.90 | 1.00 | 19.77 | 0.53 |
| class: two capitalized words, second text | 23 | 527.49 ± 0.9% | 568.02 ± 0.8% | 887.61 ± 0.7% | 103.31 ± 1.5% | 470.13 ± 31.3% | 855.40 ± 8.3% | 5672.50 ± 12.5% | 531.30 ± 1.4% | 0.93 | 0.99 | 5.11 | 1.12 |
| other: a word between two words | 13 | 615.71 ± 13.0% | 641.41 ± 2.2% | 1108.83 ± 1.9% | 136.47 ± 0.9% | 474.62 ± 24.2% | 963.04 ± 4.4% | 12583.15 ± 2.9% | 619.32 ± 6.1% | 0.96 | 0.99 | 4.51 | 1.30 |
| other: a number before a unit, second text | 15 | 436.85 ± 0.9% | 479.02 ± 2.1% | 688.51 ± 3.9% | 32.56 ± 2.2% | 580.20 ± 2.4% | 1029.35 ± 3.7% | 12883.65 ± 2.3% | 436.36 ± 1.4% | 0.91 | 1.00 | 13.42 | 0.75 |
| other: a heading's start tag | 13 | 390.70 ± 1.3% | 397.87 ± 0.5% | 535.80 ± 1.1% | 37.48 ± 1.1% | 567.36 ± 0.9% | 1016.55 ± 1.5% | 14731.69 ± 1.9% | 390.72 ± 1.5% | 0.98 | 1.00 | 10.42 | 0.69 |
| other: a whole word | 11 | 654.86 ± 1.2% | 687.08 ± 5.8% | 1215.24 ± 0.7% | 117.92 ± 0.9% | 531.98 ± 22.4% | 990.01 ± 0.7% | 21575.12 ± 2.3% | 656.30 ± 1.5% | 0.95 | 1.00 | 5.55 | 1.23 |
| other: a line's first word, second text | 17 | 598.85 ± 0.9% | 625.25 ± 1.7% | 1074.48 ± 1.7% | 133.41 ± 2.1% | 638.76 ± 19.9% | refused | refused | 599.78 ± 1.3% | 0.96 | 1.00 | 4.49 | 0.94 |
| other: fourteen octets before an x | 16 | 103.72 ± 1.1% | 144.13 ± 1.2% | 178.66 ± 1.7% | 14.47 ± 1.3% | 408.36 ± 3.9% | 459.86 ± 0.7% | 11323.29 ± 1.8% | 103.56 ± 1.0% | 0.72 | 1.00 | 7.17 | 0.25 |
| other: a Greek word | 8 | 440.64 ± 1.4% | 622.31 ± 1.3% | 1059.45 ± 1.4% | 47.77 ± 3.2% | 1265.25 ± 3.8% | 2226.88 ± 1.3% | refused | 438.00 ± 3.0% | 0.71 | 1.01 | 9.22 | 0.35 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 17030.76 ± 2.2% | not timed | not timed | 20687.10 ± 1.6% | 1924.96 ± 17.0% | not timed | not timed | 16968.13 ± 2.2% | | 1.00 | 0.82 | 8.85 |
| 01-literal/sherlock-casei-en | 522 | 4927.15 ± 0.9% | not timed | not timed | 6630.97 ± 1.2% | 29.78 ± 1.2% | not timed | not timed | 4896.34 ± 1.7% | | 1.01 | 0.74 | 165.46 |
| 01-literal/sherlock-ru | 724 | 17989.95 ± 4.4% | not timed | not timed | 20853.84 ± 6.4% | 1140.79 ± 7.5% | not timed | not timed | 18086.56 ± 2.9% | | 0.99 | 0.86 | 15.77 |
| 01-literal/sherlock-casei-ru | 746 | 6869.86 ± 1.5% | not timed | not timed | 5246.36 ± 2.1% | 32.33 ± 0.8% | not timed | not timed | 6855.97 ± 1.1% | | 1.00 | 1.31 | 212.48 |
| 01-literal/sherlock-zh | 30 | 26741.38 ± 1.7% | not timed | not timed | 25274.81 ± 2.0% | 1245.42 ± 2.6% | not timed | not timed | 27011.79 ± 3.3% | | 0.99 | 1.06 | 21.47 |
| 02-literal-alternate/sherlock-en | 714 | 9287.94 ± 1.5% | not timed | not timed | 7342.12 ± 1.9% | 17.48 ± 1.6% | not timed | not timed | 9315.53 ± 2.0% | | 1.00 | 1.27 | 531.39 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1617.29 ± 3.2% | not timed | not timed | 1890.42 ± 6.8% | 10.25 ± 5.8% | not timed | not timed | 1598.70 ± 2.6% | | 1.01 | 0.86 | 157.72 |
| 02-literal-alternate/sherlock-ru | 899 | 5823.45 ± 1.2% | not timed | not timed | 4019.41 ± 3.5% | 22.63 ± 1.1% | not timed | not timed | 5794.35 ± 3.4% | | 1.01 | 1.45 | 257.28 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1674.03 ± 2.4% | not timed | not timed | 966.67 ± 0.8% | 8.77 ± 1.0% | not timed | not timed | 1662.57 ± 3.8% | | 1.01 | 1.73 | 190.96 |
| 02-literal-alternate/sherlock-zh | 207 | 12523.47 ± 6.1% | not timed | not timed | 8400.20 ± 1.0% | 32.62 ± 0.8% | not timed | not timed | 12359.34 ± 2.9% | | 1.01 | 1.49 | 383.88 |
| 03-date/ascii | 111817 | 97.99 ± 1.3% | not timed | not timed | 86.74 ± 0.6% | 0.19 ± 4.2% | not timed | not timed | 97.64 ± 0.7% | | 1.00 | 1.13 | 509.19 |
| 04-ruff-noqa/real | 84 | 575.11 ± 1.7% | not timed | not timed | 444.46 ± 0.9% | 17.66 ± 1.8% | not timed | not timed | 574.59 ± 0.9% | | 1.00 | 1.29 | 32.57 |
| 04-ruff-noqa/tweaked | 44 | 486.66 ± 1.3% | not timed | not timed | 444.65 ± 1.1% | 310.68 ± 12.5% | not timed | not timed | 485.49 ± 1.2% | | 1.00 | 1.09 | 1.57 |
| 05-lexer-veryl/single | 124800 | 3.43 ± 1.1% | not timed | not timed | 4.71 ± 1.2% | 0.20 ± 4.7% | not timed | not timed | 3.48 ± 0.8% | | 0.99 | 0.73 | 17.23 |
| 06-cloud-flare-redos/original | 107 | 186.22 ± 2.0% | not timed | not timed | 193.52 ± 1.9% | 23.97 ± 5.7% | not timed | not timed | 185.74 ± 15.5% | | 1.00 | 0.96 | 7.77 |
| 06-cloud-flare-redos/simplified-short | 102 | 143.49 ± 2.4% | not timed | not timed | 176.80 ± 1.0% | 25.67 ± 1.2% | not timed | not timed | 143.36 ± 1.1% | | 1.00 | 0.81 | 5.59 |
| 06-cloud-flare-redos/simplified-long | 10000 | 149.16 ± 3.6% | not timed | not timed | 212.88 ± 1.0% | 28.20 ± 1.0% | not timed | not timed | 148.28 ± 8.5% | | 1.01 | 0.70 | 5.29 |
| 07-unicode-character-data/parse-line | 558784 | 222.48 ± 1.8% | not timed | not timed | 164.75 ± 1.6% | 37.89 ± 7.2% | not timed | not timed | 221.74 ± 2.6% | | 1.00 | 1.35 | 5.87 |
| 08-words/all-english | 56691 | 82.50 ± 1.3% | not timed | not timed | 73.15 ± 1.4% | 11.39 ± 7.2% | not timed | not timed | 81.52 ± 1.6% | | 1.01 | 1.13 | 7.24 |
| 08-words/long-english | 839 | 816.10 ± 1.6% | not timed | not timed | 489.47 ± 1.0% | 28.91 ± 1.4% | not timed | not timed | 811.41 ± 2.0% | | 1.01 | 1.67 | 28.23 |
| 09-aws-keys/full | 0 | 450.80 ± 3.2% | not timed | not timed | 455.48 ± 1.7% | 60.58 ± 1.0% | not timed | not timed | 449.76 ± 3.0% | | 1.00 | 0.99 | 7.44 |
| 09-aws-keys/quick | 0 | 854.32 ± 0.5% | not timed | not timed | 733.13 ± 1.6% | 354.69 ± 14.2% | not timed | not timed | 851.94 ± 1.5% | | 1.00 | 1.17 | 2.41 |
| 10-bounded-repeat/letters-en | 1833 | 474.91 ± 1.3% | not timed | not timed | 434.99 ± 3.1% | 18.81 ± 0.7% | not timed | not timed | 473.72 ± 1.1% | | 1.00 | 1.09 | 25.25 |
| 10-bounded-repeat/letters-ru | 3475 | 310.28 ± 1.5% | not timed | not timed | 394.75 ± 4.2% | 20.82 ± 9.1% | not timed | not timed | 308.82 ± 1.7% | | 1.00 | 0.79 | 14.90 |
| 10-bounded-repeat/context | 53 | 71.83 ± 1.9% | not timed | not timed | 59.15 ± 0.3% | 18.85 ± 1.4% | not timed | not timed | 56.87 ± 3.3% | | 1.26 | 1.21 | 3.81 |
| 10-bounded-repeat/capitals | 11 | 853.57 ± 2.9% | not timed | not timed | 497.45 ± 0.7% | 34.88 ± 2.2% | not timed | not timed | 851.42 ± 1.1% | | 1.00 | 1.72 | 24.47 |
| 11-unstructured-to-json/extract | 600 | 36.67 ± 0.4% | not timed | not timed | 63.02 ± 1.3% | 49.10 ± 1.5% | not timed | not timed | 36.56 ± 0.6% | | 1.00 | 0.58 | 0.75 |
| 12-dictionary/single | 1 | 446.00 ± 2.2% | not timed | not timed | 429.98 ± 1.4% | 0.38 ± 2.3% | not timed | not timed | 448.37 ± 0.8% | | 0.99 | 1.04 | 1186.73 |
| 14-quadratic/1x | 100 | 11.24 ± 1.5% | not timed | not timed | 10.73 ± 1.0% | 0.97 ± 3.6% | not timed | not timed | 11.10 ± 2.2% | | 1.01 | 1.05 | 11.61 |
| 14-quadratic/2x | 200 | 6.70 ± 1.7% | not timed | not timed | 5.24 ± 2.5% | 0.54 ± 2.3% | not timed | not timed | 6.69 ± 0.7% | | 1.00 | 1.28 | 12.47 |
| 14-quadratic/10x | 1000 | 1.52 ± 0.6% | not timed | not timed | 1.01 ± 0.9% | 0.12 ± 4.1% | not timed | not timed | 1.52 ± 1.3% | | 1.00 | 1.50 | 12.83 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.53 ± 1.9% | not timed | not timed | 0.34 ± 1.0% | 0.50 ± 3.9% | not timed | not timed | 1.52 ± 2.3% | | 1.01 | 4.57 | 3.04 |
| 04-ruff-noqa/compile-real | 1 | 100.85 ± 4.8% | not timed | not timed | 11.92 ± 1.6% | 128.85 ± 5.2% | not timed | not timed | 101.01 ± 12.5% | | 1.00 | 8.46 | 0.78 |
| 05-lexer-veryl/compile-single | 1 | 16.53 ± 2.1% | not timed | not timed | 2.29 ± 1.9% | 6.04 ± 1.6% | not timed | not timed | 16.52 ± 1.6% | | 1.00 | 7.23 | 2.74 |
| 07-unicode-character-data/compile | 1 | 60.09 ± 1.7% | not timed | not timed | 24.62 ± 0.6% | 33.52 ± 2.7% | not timed | not timed | 61.01 ± 6.5% | | 0.99 | 2.44 | 1.79 |
| 09-aws-keys/compile-full | 1 | 40.02 ± 1.4% | not timed | not timed | 6.91 ± 1.0% | 21.40 ± 15.1% | not timed | not timed | 39.76 ± 2.0% | | 1.01 | 5.79 | 1.87 |
| 09-aws-keys/compile-quick | 1 | 194.51 ± 1.1% | not timed | not timed | 45.87 ± 0.9% | 123.26 ± 4.2% | not timed | not timed | 193.49 ± 5.6% | | 1.01 | 4.24 | 1.58 |
| 10-bounded-repeat/compile-context | 1 | 11.89 ± 1.7% | not timed | not timed | 10.76 ± 1.0% | 15.60 ± 23.4% | not timed | not timed | 11.96 ± 3.5% | | 0.99 | 1.10 | 0.76 |
| 10-bounded-repeat/compile-capitals | 1 | 72.41 ± 1.2% | not timed | not timed | 8.07 ± 2.0% | 22.96 ± 6.0% | not timed | not timed | 72.20 ± 1.0% | | 1.00 | 8.97 | 3.15 |
| 11-unstructured-to-json/compile | 1 | 90.73 ± 6.2% | not timed | not timed | 37.69 ± 2.0% | 61.49 ± 3.4% | not timed | not timed | 92.52 ± 1.6% | | 0.98 | 2.41 | 1.48 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.4% | not timed | not timed | 0.06 ± 6.7% | 0.09 ± 11.6% | not timed | not timed | 0.29 ± 0.4% | | 1.01 | 4.90 | 3.21 |

