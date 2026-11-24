# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391564911 |
| Date | 2026-11-24 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache and the CPU features it detected at start, as Rust's regex detects them, `stdx, no skip` the same with claims R1 to R5 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. Each round times the other candidates from one place later than the round before, so none of them takes one place in every round. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

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
| literal: a word | 217 | 27879.90 ± 8.0% | 3503.68 ± 10.0% | 27.17 ± 3.7% | 25965.74 ± 5.8% | 9855.81 ± 11.9% | 13.00 ± 6.4% | 90.80 ± 8.6% | 27687.42 ± 7.5% | 7.96 | 1.01 | 1.07 | 2.83 |
| literal: a word that is not there | 0 | 32641.47 ± 9.0% | 3434.85 ± 10.8% | 27.87 ± 2.6% | 28356.40 ± 8.5% | 31567.81 ± 7.9% | 12.68 ± 8.5% | 86.43 ± 6.6% | 33181.61 ± 8.7% | 9.50 | 0.98 | 1.15 | 1.03 |
| literal: one of four words | 661 | 10564.58 ± 11.7% | 1645.98 ± 9.2% | 15.50 ± 6.5% | 8437.62 ± 4.2% | 24.48 ± 7.6% | 3.83 ± 4.8% | 6.44 ± 3.7% | 11048.37 ± 13.9% | 6.42 | 0.96 | 1.25 | 431.63 |
| literal: a word in any case | 217 | 23149.66 ± 10.1% | 1742.52 ± 5.4% | 20.37 ± 7.0% | 8589.85 ± 8.1% | 46.69 ± 3.1% | refused | differs | 24305.38 ± 4.3% | 13.29 | 0.95 | 2.70 | 495.81 |
| literal: an href attribute | 33 | 24538.55 ± 4.7% | 541.54 ± 8.4% | 24.47 ± 8.1% | 23100.68 ± 2.8% | 2176.85 ± 11.0% | 8.89 ± 7.3% | 77.44 ± 10.6% | 24264.71 ± 10.3% | 45.31 | 1.01 | 1.06 | 11.27 |
| literal: a word, second text | 123 | 29543.03 ± 8.4% | 2655.49 ± 6.7% | 26.87 ± 13.0% | 24750.10 ± 8.5% | 7424.08 ± 2.8% | 16.66 ± 4.7% | 78.06 ± 4.2% | 27879.46 ± 7.9% | 11.13 | 1.06 | 1.19 | 3.98 |
| class: two capitalized words | 1331 | 825.26 ± 8.0% | 537.56 ± 5.1% | 24.66 ± 4.8% | 504.70 ± 7.9% | 38.91 ± 11.7% | 10.78 ± 1.9% | 65.43 ± 9.1% | 831.62 ± 10.0% | 1.54 | 0.99 | 1.64 | 21.21 |
| class: a word that ends in ing | 3399 | 502.64 ± 9.4% | 498.10 ± 8.8% | 16.68 ± 8.9% | 482.77 ± 8.2% | 29.27 ± 12.8% | 6.03 ± 6.5% | 18.27 ± 6.8% | 497.12 ± 6.6% | 1.01 | 1.01 | 1.04 | 17.17 |
| class: a word in capitals | 2332 | 1105.95 ± 5.1% | 531.96 ± 11.4% | 27.63 ± 7.0% | 499.63 ± 3.4% | 44.06 ± 3.5% | 12.98 ± 5.8% | 80.06 ± 6.3% | 1098.99 ± 6.0% | 2.08 | 1.01 | 2.21 | 25.10 |
| class: a number | 8288 | 1689.94 ± 6.7% | 709.19 ± 4.8% | 26.38 ± 3.8% | 1744.80 ± 2.6% | 41.46 ± 19.0% | 0.35 ± 1.5% | 60.43 ± 7.1% | 1699.95 ± 3.8% | 2.38 | 0.99 | 0.97 | 40.76 |
| class: two capitalized words, second text | 5359 | 451.83 ± 9.5% | 464.47 ± 4.0% | 22.61 ± 3.4% | 428.89 ± 7.3% | 35.68 ± 13.4% | 14.17 ± 13.3% | 58.72 ± 14.4% | 449.83 ± 10.9% | 0.97 | 1.00 | 1.05 | 12.66 |
| other: a word between two words | 6104 | 717.54 ± 4.6% | 500.42 ± 7.0% | 21.92 ± 5.4% | 721.52 ± 3.6% | 112.28 ± 14.0% | 8.15 ± 4.2% | 67.35 ± 3.9% | 717.88 ± 7.0% | 1.43 | 1.00 | 0.99 | 6.39 |
| other: a number before a unit, second text | 1481 | 7447.23 ± 6.8% | 959.37 ± 6.1% | 26.30 ± 5.8% | 7321.58 ± 14.4% | 42.73 ± 10.2% | 14.87 ± 18.6% | 62.74 ± 12.9% | 7358.87 ± 9.1% | 7.76 | 1.01 | 1.02 | 174.30 |
| other: a heading's start tag | 110 | 17017.89 ± 14.7% | 641.70 ± 6.6% | 26.22 ± 2.1% | 2169.68 ± 6.7% | 1563.51 ± 4.0% | 11.09 ± 8.4% | 93.73 ± 6.0% | 17715.22 ± 11.6% | 26.52 | 0.96 | 7.84 | 10.88 |
| other: a whole word | 217 | 20732.30 ± 8.7% | 542.57 ± 13.7% | 27.24 ± 13.2% | 19861.06 ± 3.5% | 47.43 ± 6.5% | 10.88 ± 3.2% | 51.14 ± 8.8% | 20741.18 ± 13.9% | 38.21 | 1.00 | 1.04 | 437.13 |
| other: a line's first word, second text | 3716 | 2158.33 ± 5.9% | 523.96 ± 7.9% | 29.82 ± 7.1% | 2055.44 ± 6.9% | 67.35 ± 12.2% | refused | refused | 2132.86 ± 10.8% | 4.12 | 1.01 | 1.05 | 32.05 |
| other: fourteen octets before an x | 87 | 29773.51 ± 6.5% | 260.95 ± 8.7% | 6.23 ± 9.5% | 3484.94 ± 9.4% | 9.42 ± 4.4% | differs | 16.52 ± 4.0% | 29713.21 ± 9.6% | 114.10 | 1.00 | 8.54 | 3159.42 |
| other: a Greek word | 21815 | 437.88 ± 4.3% | 341.34 ± 6.1% | 30.41 ± 7.8% | 257.47 ± 7.3% | 48.79 ± 11.1% | differs | refused | 432.78 ± 3.1% | 1.28 | 1.01 | 1.70 | 8.97 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.91 ± 4.8% | 18.98 ± 8.9% | 0.89 ± 7.0% | 17.64 ± 3.7% | 2.63 ± 10.0% | differs | 3.79 ± 4.6% | 19.31 ± 6.9% | 1.00 | 0.98 | 1.07 | 7.20 |
| a UUID | 32895 | 21.72 ± 5.4% | 21.21 ± 8.4% | 0.60 ± 5.3% | 13.55 ± 4.0% | 2.68 ± 5.1% | 0.60 ± 5.0% | 3.34 ± 7.2% | 21.32 ± 5.8% | 1.02 | 1.02 | 1.60 | 8.11 |
| an IPv4 address | 33176 | 31.91 ± 4.6% | 30.95 ± 9.0% | 1.96 ± 3.1% | 26.65 ± 10.1% | 6.33 ± 4.9% | differs | 3.72 ± 4.0% | 31.65 ± 6.9% | 1.03 | 1.01 | 1.20 | 5.04 |
| a date and time | 32954 | 31.12 ± 7.4% | 30.98 ± 7.6% | 1.42 ± 3.5% | 20.01 ± 4.1% | 8.37 ± 8.8% | 1.09 ± 8.8% | 7.07 ± 7.6% | 31.35 ± 7.0% | 1.00 | 0.99 | 1.56 | 3.72 |
| a field path | 32606 | 21.30 ± 4.8% | 21.48 ± 7.0% | 1.04 ± 5.1% | 20.43 ± 6.1% | 2.99 ± 3.0% | differs | 2.51 ± 5.8% | 21.72 ± 4.0% | 0.99 | 0.98 | 1.04 | 7.13 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.46 ± 1.7% | 10.27 ± 4.5% | 10.52 ± 2.3% | 12.36 ± 5.0% | 5.40 ± 6.1% | 0.86 ± 6.1% | none | 10.50 ± 6.4% | 1.02 | 1.00 | 0.85 | 1.94 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 230.80 ± 5.8% | 228.84 ± 3.0% | 271.12 ± 4.4% | 93.97 ± 11.8% | 208.00 ± 7.2% | 589.30 ± 6.8% | 3382.19 ± 8.0% | 233.51 ± 6.4% | 1.01 | 0.99 | 2.46 | 1.11 |
| a UUID | 62 | 148.92 ± 8.1% | 144.03 ± 7.7% | 164.29 ± 8.4% | 50.50 ± 7.1% | 96.98 ± 2.5% | 205.08 ± 6.6% | 4081.67 ± 8.4% | 152.35 ± 12.0% | 1.03 | 0.98 | 2.95 | 1.54 |
| an IPv4 address | 29 | 466.20 ± 6.4% | 470.80 ± 7.5% | 664.89 ± 8.5% | 78.01 ± 8.6% | 123.94 ± 21.5% | 355.01 ± 4.8% | 7013.20 ± 5.6% | 450.74 ± 10.3% | 0.99 | 1.03 | 5.98 | 3.76 |
| a date and time | 56 | 352.01 ± 4.4% | 348.83 ± 3.3% | 459.45 ± 5.3% | 75.58 ± 4.5% | 130.31 ± 9.0% | 378.93 ± 3.7% | 4525.73 ± 8.3% | 351.28 ± 3.8% | 1.01 | 1.00 | 4.66 | 2.70 |
| a field path | 39 | 234.05 ± 2.9% | 231.43 ± 6.9% | 272.34 ± 8.3% | 87.41 ± 5.6% | 199.30 ± 8.8% | 579.72 ± 5.5% | 4310.19 ± 5.7% | 232.38 ± 12.0% | 1.01 | 1.01 | 2.68 | 1.17 |
| literal: a word | 7 | 672.34 ± 4.5% | 726.06 ± 4.3% | 1344.92 ± 2.7% | 541.86 ± 6.8% | 628.62 ± 6.2% | 1182.37 ± 8.1% | 26062.69 ± 6.6% | 646.98 ± 4.0% | 0.93 | 1.04 | 1.24 | 1.07 |
| literal: a word that is not there | 8 | 633.57 ± 7.3% | 693.10 ± 9.7% | 1278.10 ± 6.8% | 535.20 ± 4.7% | 627.93 ± 24.6% | 1147.85 ± 2.7% | 25871.42 ± 4.7% | 620.41 ± 10.0% | 0.91 | 1.02 | 1.18 | 1.01 |
| literal: one of four words | 26 | 261.47 ± 10.0% | 431.83 ± 5.2% | 610.08 ± 10.3% | 41.58 ± 8.2% | 241.82 ± 19.1% | 421.08 ± 4.4% | 13042.70 ± 5.4% | 276.69 ± 6.7% | 0.61 | 0.94 | 6.29 | 1.08 |
| literal: a word in any case | 11 | 491.87 ± 9.0% | 519.71 ± 6.0% | 773.34 ± 5.2% | 14.03 ± 4.4% | 702.32 ± 5.6% | refused | 20643.37 ± 7.4% | 491.62 ± 9.1% | 0.95 | 1.00 | 35.07 | 0.70 |
| literal: an href attribute | 12 | 363.67 ± 4.2% | 381.46 ± 3.2% | 503.63 ± 8.5% | 41.92 ± 8.7% | 489.99 ± 9.1% | 984.00 ± 7.1% | 18863.36 ± 7.9% | 374.20 ± 6.8% | 0.95 | 0.97 | 8.67 | 0.74 |
| literal: a word, second text | 10 | 605.86 ± 7.9% | 657.12 ± 4.1% | 1128.43 ± 6.7% | 480.65 ± 3.2% | 548.34 ± 18.0% | 1008.14 ± 6.3% | 23448.39 ± 9.1% | 611.66 ± 10.5% | 0.92 | 0.99 | 1.26 | 1.10 |
| class: two capitalized words | 23 | 522.15 ± 7.5% | 560.71 ± 6.5% | 841.12 ± 12.1% | 116.33 ± 2.8% | 514.12 ± 5.3% | 935.39 ± 7.1% | 6257.87 ± 4.0% | 504.16 ± 9.7% | 0.93 | 1.04 | 4.49 | 1.02 |
| class: a word that ends in ing | 9 | 582.95 ± 8.4% | 704.58 ± 3.2% | 1298.25 ± 6.5% | 152.06 ± 5.7% | 745.20 ± 7.2% | 1488.75 ± 6.6% | 14759.02 ± 7.6% | 595.58 ± 10.2% | 0.83 | 0.98 | 3.83 | 0.78 |
| class: a word in capitals | 16 | 527.58 ± 11.6% | 588.93 ± 5.9% | 1014.44 ± 12.3% | 150.23 ± 11.3% | 743.68 ± 17.3% | 1374.07 ± 4.7% | 8039.49 ± 8.4% | 542.19 ± 11.5% | 0.90 | 0.97 | 3.51 | 0.71 |
| class: a number | 6 | 639.93 ± 13.2% | 738.21 ± 10.2% | 1542.95 ± 10.7% | 36.13 ± 29.8% | 1339.83 ± 7.3% | 2460.85 ± 8.4% | 21461.71 ± 9.1% | 649.03 ± 8.6% | 0.87 | 0.99 | 17.71 | 0.48 |
| class: two capitalized words, second text | 23 | 529.99 ± 13.7% | 578.78 ± 9.3% | 878.69 ± 11.5% | 117.05 ± 7.8% | 531.96 ± 4.0% | 966.83 ± 6.5% | 6278.36 ± 6.4% | 529.85 ± 14.2% | 0.92 | 1.00 | 4.53 | 1.00 |
| other: a word between two words | 13 | 614.81 ± 18.2% | 639.40 ± 5.7% | 1027.50 ± 10.6% | 150.14 ± 22.5% | 481.78 ± 16.8% | 1042.23 ± 8.0% | 13161.84 ± 7.5% | 606.47 ± 6.5% | 0.96 | 1.01 | 4.10 | 1.28 |
| other: a number before a unit, second text | 15 | 418.86 ± 6.8% | 473.80 ± 13.3% | 680.37 ± 9.7% | 35.43 ± 7.9% | 651.28 ± 10.5% | 1139.01 ± 6.8% | 13745.59 ± 7.4% | 414.30 ± 10.1% | 0.88 | 1.01 | 11.82 | 0.64 |
| other: a heading's start tag | 13 | 367.53 ± 7.0% | 384.39 ± 9.3% | 517.50 ± 7.4% | 40.43 ± 7.9% | 601.67 ± 4.4% | 1100.72 ± 4.9% | 15358.69 ± 15.7% | 374.47 ± 4.6% | 0.96 | 0.98 | 9.09 | 0.61 |
| other: a whole word | 11 | 626.12 ± 9.3% | 642.79 ± 8.9% | 1107.74 ± 8.5% | 127.91 ± 7.6% | 595.07 ± 6.3% | 1017.61 ± 9.4% | 23105.48 ± 2.3% | 599.74 ± 12.4% | 0.97 | 1.04 | 4.90 | 1.05 |
| other: a line's first word, second text | 17 | 587.11 ± 10.7% | 621.07 ± 12.7% | 1083.97 ± 10.7% | 143.19 ± 6.9% | 714.73 ± 4.3% | refused | refused | 587.09 ± 8.6% | 0.95 | 1.00 | 4.10 | 0.82 |
| other: fourteen octets before an x | 16 | 113.34 ± 10.0% | 158.91 ± 10.4% | 185.87 ± 7.1% | 15.85 ± 18.7% | 464.23 ± 16.8% | 502.83 ± 5.0% | 12301.44 ± 7.8% | 116.95 ± 7.3% | 0.71 | 0.97 | 7.15 | 0.24 |
| other: a Greek word | 8 | 430.29 ± 3.8% | 595.92 ± 16.8% | 1063.14 ± 12.7% | 49.41 ± 7.3% | 1369.32 ± 5.4% | 2367.59 ± 8.1% | refused | 451.18 ± 3.7% | 0.72 | 0.95 | 8.71 | 0.31 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 22983.81 ± 10.8% | not timed | not timed | 23134.69 ± 7.5% | 2115.79 ± 10.3% | not timed | not timed | 23079.31 ± 19.2% | | 1.00 | 0.99 | 10.86 |
| 01-literal/sherlock-casei-en | 522 | 19106.24 ± 13.9% | not timed | not timed | 7115.60 ± 8.4% | 32.26 ± 3.9% | not timed | not timed | 19104.83 ± 4.5% | | 1.00 | 2.69 | 592.25 |
| 01-literal/sherlock-ru | 724 | 23308.90 ± 12.1% | not timed | not timed | 23770.67 ± 10.8% | 1238.44 ± 8.7% | not timed | not timed | 23137.89 ± 8.5% | | 1.01 | 0.98 | 18.82 |
| 01-literal/sherlock-casei-ru | 746 | 9836.77 ± 6.2% | not timed | not timed | 5558.10 ± 11.2% | 36.52 ± 4.9% | not timed | not timed | 10247.11 ± 2.6% | | 0.96 | 1.77 | 269.33 |
| 01-literal/sherlock-zh | 30 | 31430.83 ± 13.6% | not timed | not timed | 27854.24 ± 11.3% | 1342.05 ± 2.7% | not timed | not timed | 31432.13 ± 8.8% | | 1.00 | 1.13 | 23.42 |
| 02-literal-alternate/sherlock-en | 714 | 10636.55 ± 14.1% | not timed | not timed | 8052.32 ± 14.1% | 19.29 ± 7.0% | not timed | not timed | 10412.89 ± 22.5% | | 1.02 | 1.32 | 551.41 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1980.21 ± 10.9% | not timed | not timed | 2145.98 ± 11.6% | 11.17 ± 5.1% | not timed | not timed | 1936.57 ± 4.9% | | 1.02 | 0.92 | 177.32 |
| 02-literal-alternate/sherlock-ru | 899 | 8254.88 ± 12.4% | not timed | not timed | 4261.29 ± 7.6% | 24.61 ± 10.4% | not timed | not timed | 8499.75 ± 4.0% | | 0.97 | 1.94 | 335.46 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1928.12 ± 11.6% | not timed | not timed | 1050.21 ± 9.8% | 9.29 ± 10.8% | not timed | not timed | 1888.42 ± 3.1% | | 1.02 | 1.84 | 207.53 |
| 02-literal-alternate/sherlock-zh | 207 | 14012.39 ± 16.6% | not timed | not timed | 8771.11 ± 8.8% | 33.61 ± 8.6% | not timed | not timed | 14182.87 ± 13.6% | | 0.99 | 1.60 | 416.91 |
| 03-date/ascii | 111817 | 106.30 ± 4.9% | not timed | not timed | 94.57 ± 2.1% | 0.22 ± 6.6% | not timed | not timed | 104.46 ± 8.5% | | 1.02 | 1.12 | 490.46 |
| 04-ruff-noqa/real | 84 | 465.37 ± 9.2% | not timed | not timed | 481.41 ± 9.7% | 21.43 ± 3.0% | not timed | not timed | 474.46 ± 4.3% | | 0.98 | 0.97 | 21.72 |
| 04-ruff-noqa/tweaked | 44 | 579.64 ± 6.9% | not timed | not timed | 469.48 ± 6.9% | 355.80 ± 30.7% | not timed | not timed | 551.40 ± 8.8% | | 1.05 | 1.23 | 1.63 |
| 05-lexer-veryl/single | 124800 | 4.62 ± 5.3% | not timed | not timed | 4.90 ± 5.0% | 0.22 ± 5.1% | not timed | not timed | 4.65 ± 4.6% | | 0.99 | 0.94 | 21.16 |
| 06-cloud-flare-redos/original | 107 | 384.93 ± 4.7% | not timed | not timed | 198.99 ± 10.1% | 26.09 ± 6.9% | not timed | not timed | 381.04 ± 7.1% | | 1.01 | 1.93 | 14.75 |
| 06-cloud-flare-redos/simplified-short | 102 | 374.60 ± 7.7% | not timed | not timed | 186.32 ± 5.6% | 27.25 ± 7.8% | not timed | not timed | 384.79 ± 5.2% | | 0.97 | 2.01 | 13.75 |
| 06-cloud-flare-redos/simplified-long | 10000 | 458.20 ± 2.5% | not timed | not timed | 227.80 ± 6.4% | 29.64 ± 7.3% | not timed | not timed | 458.29 ± 6.1% | | 1.00 | 2.01 | 15.46 |
| 07-unicode-character-data/parse-line | 558784 | 198.19 ± 6.3% | not timed | not timed | 174.30 ± 8.1% | 42.08 ± 4.3% | not timed | not timed | 237.48 ± 5.9% | | 0.83 | 1.14 | 4.71 |
| 08-words/all-english | 56691 | 92.10 ± 6.7% | not timed | not timed | 77.06 ± 6.9% | 11.10 ± 3.8% | not timed | not timed | 94.19 ± 7.0% | | 0.98 | 1.20 | 8.30 |
| 08-words/long-english | 839 | 548.75 ± 4.1% | not timed | not timed | 516.80 ± 3.4% | 30.60 ± 8.6% | not timed | not timed | 537.74 ± 7.9% | | 1.02 | 1.06 | 17.93 |
| 09-aws-keys/full | 0 | 489.23 ± 4.0% | not timed | not timed | 500.53 ± 6.6% | 65.49 ± 7.7% | not timed | not timed | 491.05 ± 6.5% | | 1.00 | 0.98 | 7.47 |
| 09-aws-keys/quick | 0 | 1042.65 ± 10.9% | not timed | not timed | 805.02 ± 7.2% | 400.56 ± 5.1% | not timed | not timed | 1026.81 ± 8.9% | | 1.02 | 1.30 | 2.60 |
| 10-bounded-repeat/letters-en | 1833 | 569.16 ± 10.5% | not timed | not timed | 502.44 ± 3.5% | 20.19 ± 4.9% | not timed | not timed | 564.75 ± 4.4% | | 1.01 | 1.13 | 28.19 |
| 10-bounded-repeat/letters-ru | 3475 | 469.04 ± 10.4% | not timed | not timed | 441.22 ± 5.6% | 21.85 ± 15.9% | not timed | not timed | 460.96 ± 6.4% | | 1.02 | 1.06 | 21.47 |
| 10-bounded-repeat/context | 53 | 80.15 ± 6.5% | not timed | not timed | 63.60 ± 10.3% | 20.22 ± 2.0% | not timed | not timed | 82.11 ± 5.3% | | 0.98 | 1.26 | 3.96 |
| 10-bounded-repeat/capitals | 11 | 559.25 ± 14.2% | not timed | not timed | 500.16 ± 9.7% | 36.48 ± 13.0% | not timed | not timed | 535.34 ± 20.7% | | 1.04 | 1.12 | 15.33 |
| 11-unstructured-to-json/extract | 600 | 42.95 ± 3.9% | not timed | not timed | 65.33 ± 4.6% | 50.06 ± 4.6% | not timed | not timed | 42.42 ± 6.7% | | 1.01 | 0.66 | 0.86 |
| 12-dictionary/single | 1 | 453.77 ± 8.3% | not timed | not timed | 437.73 ± 3.8% | 0.39 ± 5.0% | not timed | not timed | 464.08 ± 6.1% | | 0.98 | 1.04 | 1158.78 |
| 14-quadratic/1x | 100 | 23.68 ± 9.8% | not timed | not timed | 10.81 ± 3.7% | 0.93 ± 13.1% | not timed | not timed | 23.41 ± 10.5% | | 1.01 | 2.19 | 25.56 |
| 14-quadratic/2x | 200 | 18.13 ± 2.4% | not timed | not timed | 5.31 ± 5.6% | 0.52 ± 11.1% | not timed | not timed | 17.97 ± 12.9% | | 1.01 | 3.41 | 35.07 |
| 14-quadratic/10x | 1000 | 5.72 ± 5.6% | not timed | not timed | 1.06 ± 7.5% | 0.12 ± 9.2% | not timed | not timed | 5.86 ± 6.8% | | 0.98 | 5.41 | 47.96 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.28 ± 7.3% | not timed | not timed | 0.36 ± 4.7% | 0.54 ± 6.8% | not timed | not timed | 1.30 ± 7.3% | | 0.98 | 3.58 | 2.37 |
| 04-ruff-noqa/compile-real | 1 | 128.02 ± 5.1% | not timed | not timed | 12.43 ± 3.4% | 142.16 ± 6.7% | not timed | not timed | 128.67 ± 8.7% | | 0.99 | 10.30 | 0.90 |
| 05-lexer-veryl/compile-single | 1 | 15.65 ± 9.5% | not timed | not timed | 2.43 ± 5.2% | 6.66 ± 6.9% | not timed | not timed | 15.84 ± 7.0% | | 0.99 | 6.45 | 2.35 |
| 07-unicode-character-data/compile | 1 | 127.38 ± 12.5% | not timed | not timed | 25.34 ± 5.5% | 34.99 ± 9.7% | not timed | not timed | 129.73 ± 3.3% | | 0.98 | 5.03 | 3.64 |
| 09-aws-keys/compile-full | 1 | 52.16 ± 6.7% | not timed | not timed | 7.03 ± 5.4% | 22.97 ± 5.4% | not timed | not timed | 53.12 ± 5.3% | | 0.98 | 7.42 | 2.27 |
| 09-aws-keys/compile-quick | 1 | 187.56 ± 9.6% | not timed | not timed | 48.95 ± 5.6% | 135.23 ± 5.0% | not timed | not timed | 187.54 ± 5.9% | | 1.00 | 3.83 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 52.36 ± 7.6% | not timed | not timed | 11.29 ± 14.1% | 16.62 ± 10.2% | not timed | not timed | 54.70 ± 8.3% | | 0.96 | 4.64 | 3.15 |
| 10-bounded-repeat/compile-capitals | 1 | 75.04 ± 10.1% | not timed | not timed | 8.78 ± 14.5% | 24.16 ± 4.8% | not timed | not timed | 74.66 ± 6.8% | | 1.01 | 8.55 | 3.11 |
| 11-unstructured-to-json/compile | 1 | 199.93 ± 9.6% | not timed | not timed | 40.39 ± 8.0% | 68.13 ± 7.3% | not timed | not timed | 200.65 ± 8.3% | | 1.00 | 4.95 | 2.93 |
| 12-dictionary/compile-single | 1 | 0.31 ± 6.7% | not timed | not timed | 0.07 ± 5.7% | 0.10 ± 10.9% | not timed | not timed | 0.30 ± 8.2% | | 1.02 | 4.51 | 3.18 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 6.38 ± 10.9% | not timed | not timed | 6.52 ± 13.0% | 0.64 ± 18.5% | not timed | not timed | 6.35 ± 3.8% | | 1.00 | 0.98 | 10.04 |
| dictionary/search/english-10 | 690 | 1.22 ± 9.7% | not timed | not timed | 105.13 ± 11.5% | 0.01 ± 0.9% | not timed | not timed | 1.24 ± 5.2% | | 0.98 | 0.0116 | 192.38 |
| dictionary/search/english-15 | 15 | 484.28 ± 4.4% | not timed | not timed | 460.00 ± 2.8% | 0.37 ± 8.3% | not timed | not timed | 481.14 ± 3.4% | | 1.01 | 1.05 | 1293.70 |
| folly/awyer-inn-busted | 1 | 3714.89 ± 8.6% | not timed | not timed | 115.00 ± 3.7% | 41.87 ± 4.7% | not timed | not timed | 3600.95 ± 2.8% | | 1.03 | 32.30 | 88.72 |
| folly/literal-never-match-rare | 0 | 25463.31 ± 5.9% | not timed | not timed | 22682.28 ± 5.6% | 30108.60 ± 3.5% | not timed | not timed | 26333.56 ± 6.1% | | 0.97 | 1.12 | 0.85 |
| folly/literal-never-match-frequent | 0 | 14798.43 ± 6.6% | not timed | not timed | 23200.58 ± 9.7% | 2163.06 ± 8.5% | not timed | not timed | 15327.90 ± 5.4% | | 0.97 | 0.64 | 6.84 |
| folly/literal-never-match-tricksy | 1 | 3488.41 ± 7.2% | not timed | not timed | 4191.73 ± 7.6% | 1374.08 ± 7.8% | not timed | not timed | 3504.80 ± 7.7% | | 1.00 | 0.83 | 2.54 |
| grep/every-line | 239963 | 1195.96 ± 13.7% | not timed | not timed | 771.15 ± 7.9% | 354.44 ± 37.7% | not timed | not timed | 1184.76 ± 18.0% | | 1.01 | 1.55 | 3.37 |
| grep/long-words-ascii | 5073 | 462.48 ± 7.3% | not timed | not timed | 433.18 ± 9.1% | 43.73 ± 11.8% | not timed | not timed | 455.11 ± 11.4% | | 1.02 | 1.07 | 10.58 |
| imported/leipzig/twain | 811 | 24647.45 ± 5.6% | not timed | not timed | 22920.57 ± 7.8% | 10400.24 ± 9.2% | not timed | not timed | 24332.96 ± 8.2% | | 1.01 | 1.08 | 2.37 |
| imported/leipzig/twain-insensitive | 965 | 11144.20 ± 8.0% | not timed | not timed | 9537.29 ± 8.5% | 42.31 ± 4.6% | not timed | not timed | 11090.06 ± 4.0% | | 1.00 | 1.17 | 263.41 |
| imported/leipzig/shing | 1540 | 554.89 ± 7.0% | not timed | not timed | 14662.84 ± 5.2% | 34.05 ± 3.5% | not timed | not timed | 541.20 ± 1.8% | | 1.03 | 0.0378 | 16.30 |
| imported/leipzig/huck-saw | 262 | 15367.43 ± 7.5% | not timed | not timed | 14367.18 ± 8.0% | 35.19 ± 4.1% | not timed | not timed | 16079.13 ± 10.7% | | 0.96 | 1.07 | 436.69 |
| imported/leipzig/word-ending-nn | 262 | 543.27 ± 9.1% | not timed | not timed | 547.20 ± 9.8% | 23.95 ± 3.9% | not timed | not timed | 538.53 ± 10.3% | | 1.01 | 0.99 | 22.68 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 9463.24 ± 7.7% | not timed | not timed | 3687.32 ± 11.0% | 10.22 ± 2.9% | not timed | not timed | 9411.24 ± 6.0% | | 1.01 | 2.57 | 925.74 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 13596.41 ± 9.5% | not timed | not timed | 13137.37 ± 3.5% | 18.82 ± 0.8% | not timed | not timed | 13482.43 ± 9.0% | | 1.01 | 1.03 | 722.43 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4879.58 ± 9.2% | not timed | not timed | 840.38 ± 7.1% | 10.51 ± 2.7% | not timed | not timed | 4623.27 ± 11.3% | | 1.06 | 5.81 | 464.21 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 523.86 ± 1.9% | not timed | not timed | 523.10 ± 7.9% | 11.57 ± 1.6% | not timed | not timed | 509.46 ± 7.3% | | 1.03 | 1.00 | 45.27 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 537.64 ± 8.9% | not timed | not timed | 518.93 ± 6.5% | 9.83 ± 1.5% | not timed | not timed | 522.55 ± 2.5% | | 1.03 | 1.04 | 54.67 |
| imported/leipzig/tom-river | 2 | 9696.35 ± 7.1% | not timed | not timed | 10726.88 ± 3.2% | 33.48 ± 3.2% | not timed | not timed | 9673.26 ± 7.8% | | 1.00 | 0.90 | 289.61 |
| imported/leipzig/ing | 78424 | 518.79 ± 5.6% | not timed | not timed | 490.39 ± 1.9% | 27.50 ± 5.3% | not timed | not timed | 525.35 ± 10.2% | | 0.99 | 1.06 | 18.86 |
| imported/leipzig/ing-whitespace | 55248 | 647.80 ± 5.8% | not timed | not timed | 1850.84 ± 8.5% | 19.98 ± 4.3% | not timed | not timed | 652.30 ± 2.0% | | 0.99 | 0.35 | 32.43 |
| imported/leipzig/awyer-inn | 209 | 702.13 ± 7.5% | not timed | not timed | 9477.47 ± 6.7% | 22.56 ± 7.6% | not timed | not timed | 687.49 ± 2.9% | | 1.02 | 0.0741 | 31.12 |
| imported/leipzig/quotes-bounded | 8886 | 1719.29 ± 9.0% | not timed | not timed | 2851.11 ± 6.7% | 37.03 ± 1.2% | not timed | not timed | 1778.05 ± 9.8% | | 0.97 | 0.60 | 46.43 |
| imported/leipzig/non-ascii-alternate | 2 | 19166.21 ± 6.4% | not timed | not timed | 15003.99 ± 6.4% | 48.58 ± 2.1% | not timed | not timed | 20026.02 ± 13.8% | | 0.96 | 1.28 | 394.50 |
| imported/leipzig/math-symbols | 69 | 2154.20 ± 5.1% | not timed | not timed | 537.16 ± 3.8% | 36.27 ± 4.6% | not timed | not timed | 2082.19 ± 10.6% | | 1.03 | 4.01 | 59.39 |
| imported/leipzig/bounded-strings-ending-z | 0 | 522.01 ± 5.0% | not timed | not timed | 528.54 ± 6.2% | 24.69 ± 2.4% | not timed | not timed | 527.81 ± 3.1% | | 0.99 | 0.99 | 21.14 |
| imported/lh3lh3-reb/uri | 17549 | 648.52 ± 5.9% | not timed | not timed | 891.74 ± 4.3% | 26.10 ± 4.1% | not timed | not timed | 645.75 ± 13.6% | | 1.00 | 0.73 | 24.85 |
| imported/lh3lh3-reb/email | 15057 | 728.44 ± 5.6% | not timed | not timed | 890.82 ± 4.5% | 30.00 ± 5.9% | not timed | not timed | 724.14 ± 7.1% | | 1.01 | 0.82 | 24.28 |
| imported/lh3lh3-reb/date | 668 | 752.98 ± 3.7% | not timed | not timed | 797.72 ± 3.0% | 47.15 ± 5.0% | not timed | not timed | 763.81 ± 7.0% | | 0.99 | 0.94 | 15.97 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 652.43 ± 11.0% | not timed | not timed | 396.74 ± 7.2% | 14.87 ± 3.3% | not timed | not timed | 665.33 ± 4.8% | | 0.98 | 1.64 | 43.86 |
| imported/mariomka/email | 92 | 619.78 ± 9.9% | not timed | not timed | 26478.94 ± 7.4% | 31.73 ± 3.1% | not timed | not timed | 628.31 ± 7.4% | | 0.99 | 0.0234 | 19.53 |
| imported/mariomka/uri | 5301 | 536.21 ± 3.4% | not timed | not timed | 6175.65 ± 6.5% | 32.37 ± 4.1% | not timed | not timed | 527.00 ± 4.3% | | 1.02 | 0.0868 | 16.57 |
| imported/mariomka/ip | 5 | 1610.62 ± 10.9% | not timed | not timed | 2027.16 ± 4.8% | 21.74 ± 4.1% | not timed | not timed | 1589.57 ± 3.4% | | 1.01 | 0.79 | 74.10 |
| imported/rsc/no-exponential | 0 | 828.59 ± 10.7% | not timed | not timed | 527.89 ± 8.1% | 23.76 ± 7.9% | not timed | not timed | 796.68 ± 11.9% | | 1.04 | 1.57 | 34.88 |
| imported/rsc/literal | 1 | 831.53 ± 10.5% | not timed | not timed | 2271.00 ± 7.1% | 208.50 ± 21.4% | not timed | not timed | 836.38 ± 10.1% | | 0.99 | 0.37 | 3.99 |
| imported/rsc/not-literal | 2 | 762.01 ± 6.9% | not timed | not timed | 1153.21 ± 11.6% | 47.27 ± 16.1% | not timed | not timed | 778.67 ± 11.9% | | 0.98 | 0.66 | 16.12 |
| imported/rsc/match-class | 1 | 1390.04 ± 13.5% | not timed | not timed | 2194.74 ± 10.8% | 53.48 ± 5.6% | not timed | not timed | 1391.50 ± 4.5% | | 1.00 | 0.63 | 25.99 |
| imported/rsc/match-class-in-range | 1 | 1401.23 ± 3.9% | not timed | not timed | 3665.27 ± 4.1% | 58.15 ± 14.3% | not timed | not timed | 1395.49 ± 2.3% | | 1.00 | 0.38 | 24.10 |
| imported/rsc/match-class-unicode | 1 | 510.03 ± 8.3% | not timed | not timed | 493.32 ± 5.5% | 66.36 ± 1.7% | not timed | not timed | 503.03 ± 2.9% | | 1.01 | 1.03 | 7.69 |
| imported/rsc/anchored-literal-short-non-match | 0 | 563.42 ± 12.2% | not timed | not timed | 1283.38 ± 9.6% | 302.01 ± 6.9% | not timed | not timed | 584.43 ± 7.1% | | 0.96 | 0.44 | 1.87 |
| imported/rsc/anchored-literal-long-non-match | 0 | 9732.89 ± 7.5% | not timed | not timed | 18842.06 ± 5.6% | 4404.46 ± 13.5% | not timed | not timed | 9724.59 ± 5.7% | | 1.00 | 0.52 | 2.21 |
| imported/rsc/anchored-literal-short-match | 4 | 475.02 ± 8.8% | not timed | not timed | 808.22 ± 7.4% | 85.54 ± 22.6% | not timed | not timed | 468.49 ± 22.3% | | 1.01 | 0.59 | 5.55 |
| imported/rsc/anchored-literal-long-match | 4 | 2667.52 ± 10.0% | not timed | not timed | 12882.76 ± 8.4% | 1360.73 ± 17.3% | not timed | not timed | 2617.77 ± 9.5% | | 1.02 | 0.21 | 1.96 |
| imported/rsc/one-pass-short | 17 | 408.08 ± 5.4% | not timed | not timed | 399.29 ± 8.5% | 34.49 ± 15.4% | not timed | not timed | 405.07 ± 8.2% | | 1.01 | 1.02 | 11.83 |
| imported/rsc/one-pass-short-not | 17 | 252.41 ± 9.7% | not timed | not timed | 385.18 ± 7.0% | 31.44 ± 13.6% | not timed | not timed | 258.83 ± 4.8% | | 0.98 | 0.66 | 8.03 |
| imported/rsc/one-pass-long-prefix | 26 | 264.01 ± 9.9% | not timed | not timed | 451.22 ± 14.9% | 101.86 ± 20.3% | not timed | not timed | 263.27 ± 6.5% | | 1.00 | 0.59 | 2.59 |
| imported/rsc/one-pass-long-prefix-not | 26 | 435.52 ± 13.8% | not timed | not timed | 462.01 ± 4.7% | 76.43 ± 15.0% | not timed | not timed | 426.45 ± 10.7% | | 1.02 | 0.94 | 5.70 |
| imported/rsc/long-needle1 | 31 | 32501.48 ± 9.3% | not timed | not timed | 29118.93 ± 9.8% | 4.24 ± 5.0% | not timed | not timed | 31382.92 ± 6.6% | | 1.04 | 1.12 | 7660.90 |
| imported/rsc/long-needle2 | 31 | 32449.56 ± 9.1% | not timed | not timed | 181.77 ± 9.5% | 3.98 ± 7.0% | not timed | not timed | 30018.79 ± 9.7% | | 1.08 | 178.52 | 8158.35 |
| imported/rsc/easy0-32 | 26 | 1204.98 ± 12.5% | not timed | not timed | 2129.81 ± 8.5% | 149.58 ± 21.4% | not timed | not timed | 1197.51 ± 2.7% | | 1.01 | 0.57 | 8.06 |
| imported/rsc/easy0-1k | 26 | 19497.10 ± 1.8% | not timed | not timed | 18142.81 ± 4.4% | 2435.49 ± 20.1% | not timed | not timed | 19428.20 ± 4.5% | | 1.00 | 1.07 | 8.01 |
| imported/rsc/easy0-32k | 26 | 37399.76 ± 7.9% | not timed | not timed | 31643.68 ± 6.9% | 19997.18 ± 27.9% | not timed | not timed | 37252.73 ± 12.7% | | 1.00 | 1.18 | 1.87 |
| imported/rsc/easy0-1mb | 26 | 30419.24 ± 10.2% | not timed | not timed | 29956.32 ± 7.4% | 39892.21 ± 5.2% | not timed | not timed | 29790.61 ± 12.4% | | 1.02 | 1.02 | 0.76 |
| imported/rsc/easy1-32 | 19 | 382.91 ± 13.4% | not timed | not timed | 1063.55 ± 3.5% | 144.72 ± 24.6% | not timed | not timed | 388.65 ± 8.5% | | 0.99 | 0.36 | 2.65 |
| imported/rsc/easy1-1k | 19 | 510.55 ± 5.3% | not timed | not timed | 22350.28 ± 3.6% | 2591.07 ± 19.9% | not timed | not timed | 520.39 ± 5.1% | | 0.98 | 0.0228 | 0.20 |
| imported/rsc/easy1-32k | 19 | 556.26 ± 8.1% | not timed | not timed | 710604.67 ± 6.8% | 22888.31 ± 27.0% | not timed | not timed | 536.58 ± 4.7% | | 1.04 | 0.0008 | 0.0243 |
| imported/rsc/easy1-1mb | 19 | 552.75 ± 18.4% | not timed | not timed | 23703020.35 ± 10.9% | 46948.70 ± 5.4% | not timed | not timed | 535.12 ± 10.2% | | 1.03 | 0.0000 | 0.0118 |
| imported/rsc/medium-32 | 27 | 503.10 ± 6.3% | not timed | not timed | 1041.95 ± 9.1% | 71.45 ± 10.1% | not timed | not timed | 485.36 ± 6.9% | | 1.04 | 0.48 | 7.04 |
| imported/rsc/medium-1k | 27 | 7419.30 ± 5.9% | not timed | not timed | 18563.31 ± 7.9% | 77.48 ± 4.9% | not timed | not timed | 7340.13 ± 3.7% | | 1.01 | 0.40 | 95.76 |
| imported/rsc/medium-32k | 27 | 38167.56 ± 15.0% | not timed | not timed | 591754.91 ± 9.4% | 55.50 ± 10.2% | not timed | not timed | 38703.52 ± 9.5% | | 0.99 | 0.0645 | 687.69 |
| imported/rsc/medium-1mb | 27 | 32180.40 ± 11.3% | not timed | not timed | 17776018.43 ± 17.7% | 53.52 ± 8.6% | not timed | not timed | 32378.40 ± 7.8% | | 0.99 | 0.0018 | 601.32 |
| imported/rsc/hard-32 | 58 | 289.85 ± 6.7% | not timed | not timed | 419.71 ± 7.6% | 53.14 ± 14.7% | not timed | not timed | 281.69 ± 9.5% | | 1.03 | 0.69 | 5.45 |
| imported/rsc/hard-1k | 27 | 524.53 ± 8.6% | not timed | not timed | 16427.01 ± 8.4% | 44.37 ± 6.3% | not timed | not timed | 530.91 ± 7.0% | | 0.99 | 0.0319 | 11.82 |
| imported/rsc/hard-32k | 27 | 557.26 ± 6.2% | not timed | not timed | 510845.78 ± 6.3% | 30.87 ± 4.3% | not timed | not timed | 552.11 ± 3.3% | | 1.01 | 0.0011 | 18.05 |
| imported/rsc/hard-1mb | 51 | 543.55 ± 8.5% | not timed | not timed | 8561655.53 ± 5.5% | 31.51 ± 6.6% | not timed | not timed | 545.68 ± 4.7% | | 1.00 | 0.0001 | 17.25 |
| imported/rsc/reallyhard0-32 | 58 | 277.42 ± 1.7% | not timed | not timed | 256.38 ± 15.4% | 54.12 ± 11.8% | not timed | not timed | 279.16 ± 2.6% | | 0.99 | 1.08 | 5.13 |
| imported/rsc/reallyhard0-1k | 27 | 524.13 ± 4.8% | not timed | not timed | 522.29 ± 7.4% | 43.59 ± 4.4% | not timed | not timed | 526.40 ± 17.8% | | 1.00 | 1.00 | 12.02 |
| imported/rsc/reallyhard0-32k | 27 | 534.48 ± 4.3% | not timed | not timed | 537.49 ± 4.8% | 30.57 ± 6.7% | not timed | not timed | 527.74 ± 6.0% | | 1.01 | 0.99 | 17.49 |
| imported/rsc/reallyhard0-1mb | 51 | 550.05 ± 3.3% | not timed | not timed | 547.47 ± 12.6% | 31.62 ± 9.7% | not timed | not timed | 541.24 ± 4.6% | | 1.02 | 1.00 | 17.40 |
| imported/rsc/reallyreallyhard0-32 | 47 | 296.11 ± 6.6% | not timed | not timed | 225.36 ± 2.7% | 64.51 ± 16.9% | not timed | not timed | 295.85 ± 10.7% | | 1.00 | 1.31 | 4.59 |
| imported/rsc/reallyreallyhard0-1k | 16 | 790.92 ± 7.1% | not timed | not timed | 8703.30 ± 8.6% | 35.57 ± 8.9% | not timed | not timed | 802.77 ± 5.1% | | 0.99 | 0.0909 | 22.24 |
| imported/rsc/reallyreallyhard0-32k | 16 | 579.48 ± 7.8% | not timed | not timed | 31645.56 ± 12.4% | 25.97 ± 7.4% | not timed | not timed | 562.95 ± 6.5% | | 1.03 | 0.0183 | 22.31 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 548.34 ± 7.4% | not timed | not timed | 31549.02 ± 10.1% | 25.81 ± 3.8% | not timed | not timed | 547.99 ± 5.4% | | 1.00 | 0.0174 | 21.24 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 294.08 ± 4.5% | not timed | not timed | 232.99 ± 7.3% | 64.94 ± 10.0% | not timed | not timed | 302.61 ± 11.6% | | 0.97 | 1.26 | 4.53 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 790.85 ± 7.1% | not timed | not timed | 8636.17 ± 7.3% | 34.31 ± 9.2% | not timed | not timed | 760.55 ± 5.5% | | 1.04 | 0.0916 | 23.05 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 572.03 ± 7.7% | not timed | not timed | 30859.22 ± 8.7% | 26.04 ± 4.0% | not timed | not timed | 568.57 ± 9.7% | | 1.01 | 0.0185 | 21.97 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 529.03 ± 14.9% | not timed | not timed | 29294.22 ± 16.6% | 26.63 ± 10.9% | not timed | not timed | 548.28 ± 4.5% | | 0.96 | 0.0181 | 19.87 |
| imported/sherlock/name-sherlock | 776 | 28586.39 ± 4.9% | not timed | not timed | 26354.32 ± 7.7% | 9528.43 ± 22.2% | not timed | not timed | 29167.78 ± 14.0% | | 0.98 | 1.08 | 3.00 |
| imported/sherlock/name-holmes | 2766 | 19012.92 ± 13.3% | not timed | not timed | 20654.68 ± 11.5% | 3402.16 ± 2.8% | not timed | not timed | 18706.77 ± 8.2% | | 1.02 | 0.92 | 5.59 |
| imported/sherlock/name-sherlock-holmes | 1365 | 28054.89 ± 5.8% | not timed | not timed | 24846.27 ± 14.5% | 8514.90 ± 28.2% | not timed | not timed | 29439.53 ± 12.0% | | 0.95 | 1.13 | 3.29 |
| imported/sherlock/name-sherlock-casei | 816 | 25867.42 ± 7.7% | not timed | not timed | 8933.63 ± 7.1% | 31.89 ± 10.6% | not timed | not timed | 26596.75 ± 7.5% | | 0.97 | 2.90 | 811.14 |
| imported/sherlock/name-holmes-casei | 2802 | 15678.92 ± 7.3% | not timed | not timed | 6098.27 ± 7.1% | 44.96 ± 9.8% | not timed | not timed | 16390.80 ± 10.5% | | 0.96 | 2.57 | 348.72 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 22644.88 ± 6.9% | not timed | not timed | 8792.49 ± 5.9% | 31.19 ± 8.3% | not timed | not timed | 22135.97 ± 11.8% | | 1.02 | 2.58 | 726.02 |
| imported/sherlock/name-whitespace | 1461 | 19289.45 ± 9.6% | not timed | not timed | 20149.06 ± 3.3% | 6994.98 ± 28.8% | not timed | not timed | 18822.53 ± 14.5% | | 1.02 | 0.96 | 2.76 |
| imported/sherlock/name-alt1 | 1142 | 18432.43 ± 8.4% | not timed | not timed | 29768.78 ± 8.2% | 4128.41 ± 16.4% | not timed | not timed | 18627.27 ± 14.5% | | 0.99 | 0.62 | 4.46 |
| imported/sherlock/name-alt2 | 3542 | 11784.76 ± 5.3% | not timed | not timed | 7562.21 ± 4.5% | 34.28 ± 14.6% | not timed | not timed | 12112.15 ± 6.5% | | 0.97 | 1.56 | 343.81 |
| imported/sherlock/name-alt3 | 4507 | 9037.83 ± 7.6% | not timed | not timed | 6766.37 ± 7.8% | 11.24 ± 9.6% | not timed | not timed | 9155.97 ± 7.6% | | 0.99 | 1.34 | 803.93 |
| imported/sherlock/name-alt3-casei | 4593 | 1503.58 ± 5.4% | not timed | not timed | 1227.55 ± 6.9% | 6.89 ± 2.6% | not timed | not timed | 1508.32 ± 5.1% | | 1.00 | 1.22 | 218.08 |
| imported/sherlock/name-alt4 | 3686 | 7262.32 ± 5.9% | not timed | not timed | 7037.86 ± 5.3% | 34.68 ± 11.8% | not timed | not timed | 7290.90 ± 7.2% | | 1.00 | 1.03 | 209.39 |
| imported/sherlock/name-alt4-casei | 4254 | 3286.45 ± 5.6% | not timed | not timed | 3795.06 ± 6.9% | 19.39 ± 5.4% | not timed | not timed | 3222.68 ± 8.1% | | 1.02 | 0.87 | 169.47 |
| imported/sherlock/name-alt5 | 4028 | 10171.73 ± 5.3% | not timed | not timed | 7359.06 ± 3.3% | 25.44 ± 4.8% | not timed | not timed | 10664.65 ± 10.1% | | 0.95 | 1.38 | 399.78 |
| imported/sherlock/name-alt5-casei | 4104 | 4623.95 ± 13.4% | not timed | not timed | 2466.58 ± 8.3% | 14.03 ± 5.8% | not timed | not timed | 4800.31 ± 9.0% | | 0.96 | 1.87 | 329.49 |
| imported/sherlock/no-match-uncommon | 0 | 32603.12 ± 5.2% | not timed | not timed | 27498.01 ± 6.5% | 41464.34 ± 5.5% | not timed | not timed | 32745.24 ± 9.2% | | 1.00 | 1.19 | 0.79 |
| imported/sherlock/no-match-common | 0 | 32429.55 ± 7.3% | not timed | not timed | 28417.35 ± 12.4% | 1710.21 ± 4.9% | not timed | not timed | 32470.36 ± 2.6% | | 1.00 | 1.14 | 18.96 |
| imported/sherlock/no-match-really-common | 0 | 26768.44 ± 10.7% | not timed | not timed | 27183.45 ± 8.6% | 1729.87 ± 3.6% | not timed | not timed | 27576.08 ± 9.1% | | 0.97 | 0.98 | 15.47 |
| imported/sherlock/the-lower | 21654 | 2448.69 ± 2.6% | not timed | not timed | 2086.55 ± 10.4% | 243.00 ± 20.1% | not timed | not timed | 2367.12 ± 10.2% | | 1.03 | 1.17 | 10.08 |
| imported/sherlock/the-upper | 2223 | 14958.40 ± 4.5% | not timed | not timed | 18023.80 ± 9.4% | 2835.27 ± 6.7% | not timed | not timed | 14616.71 ± 5.7% | | 1.02 | 0.83 | 5.28 |
| imported/sherlock/the-casei | 23961 | 2256.40 ± 7.3% | not timed | not timed | 1222.09 ± 3.1% | 39.95 ± 32.7% | not timed | not timed | 2289.98 ± 8.1% | | 0.99 | 1.85 | 56.48 |
| imported/sherlock/everything-greedy | 581881 | 263.82 ± 7.1% | not timed | not timed | 156.73 ± 8.6% | 25.89 ± 31.7% | not timed | not timed | 262.82 ± 8.3% | | 1.00 | 1.68 | 10.19 |
| imported/sherlock/everything-greedy-nl | 594933 | 401.88 ± 6.4% | not timed | not timed | 206.25 ± 5.7% | 28.98 ± 8.4% | not timed | not timed | 415.93 ± 7.3% | | 0.97 | 1.95 | 13.87 |
| imported/sherlock/letters | 447175 | 50.20 ± 11.1% | not timed | not timed | 36.06 ± 9.1% | 5.67 ± 4.6% | not timed | not timed | 49.00 ± 5.9% | | 1.02 | 1.39 | 8.86 |
| imported/sherlock/letters-upper | 14180 | 398.38 ± 3.8% | not timed | not timed | 336.51 ± 3.4% | 28.82 ± 37.6% | not timed | not timed | 391.49 ± 6.7% | | 1.02 | 1.18 | 13.82 |
| imported/sherlock/letters-lower | 432995 | 52.20 ± 6.7% | not timed | not timed | 36.05 ± 4.9% | 5.32 ± 18.0% | not timed | not timed | 52.48 ± 5.7% | | 0.99 | 1.45 | 9.82 |
| imported/sherlock/words | 447639 | 94.21 ± 16.8% | not timed | not timed | 79.42 ± 6.7% | 12.66 ± 41.6% | not timed | not timed | 94.49 ± 12.3% | | 1.00 | 1.19 | 7.44 |
| imported/sherlock/before-holmes | 4073 | 546.92 ± 10.0% | not timed | not timed | 13026.29 ± 4.3% | 24.24 ± 5.8% | not timed | not timed | 548.53 ± 8.8% | | 1.00 | 0.0420 | 22.56 |
| imported/sherlock/before-after-holmes | 2593 | 537.10 ± 8.8% | not timed | not timed | 13601.33 ± 4.3% | 23.99 ± 4.9% | not timed | not timed | 551.86 ± 8.9% | | 0.97 | 0.0395 | 22.39 |
| imported/sherlock/holmes-cochar-watson | 150 | 8061.66 ± 8.0% | not timed | not timed | 6065.81 ± 7.8% | 34.68 ± 8.8% | not timed | not timed | 8282.69 ± 8.8% | | 0.97 | 1.33 | 232.47 |
| imported/sherlock/holmes-coword-watson | 14309 | 1081.35 ± 5.0% | not timed | not timed | 1145.51 ± 6.9% | 7.02 ± 7.2% | not timed | not timed | 1119.49 ± 8.8% | | 0.97 | 0.94 | 153.98 |
| imported/sherlock/quotes | 14437 | 1197.76 ± 8.3% | not timed | not timed | 1767.64 ± 9.3% | 34.91 ± 8.9% | not timed | not timed | 1229.20 ± 3.3% | | 0.97 | 0.68 | 34.31 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 543.77 ± 3.2% | not timed | not timed | 22305.17 ± 6.0% | 41.23 ± 7.0% | not timed | not timed | 537.95 ± 6.1% | | 1.01 | 0.0244 | 13.19 |
| imported/sherlock/word-ending-n | 35297 | 407.13 ± 6.5% | not timed | not timed | 365.45 ± 4.9% | 22.76 ± 3.3% | not timed | not timed | 409.85 ± 6.7% | | 0.99 | 1.11 | 17.89 |
| imported/sherlock/repeated-class-negation | 2130 | 14780.29 ± 11.0% | not timed | not timed | 15368.28 ± 5.7% | 10.62 ± 8.7% | not timed | not timed | 14889.30 ± 4.8% | | 0.99 | 0.96 | 1391.38 |
| imported/sherlock/ing-suffix | 20547 | 485.49 ± 6.7% | not timed | not timed | 459.33 ± 9.3% | 28.55 ± 5.5% | not timed | not timed | 483.44 ± 3.3% | | 1.00 | 1.06 | 17.01 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 528.50 ± 4.9% | not timed | not timed | 2231.37 ± 6.3% | 20.07 ± 18.5% | not timed | not timed | 535.22 ± 10.4% | | 0.99 | 0.24 | 26.33 |
| opt/accelerate/whole-line | 239963 | 470.02 ± 4.4% | not timed | not timed | 379.71 ± 5.9% | 96.94 ± 20.7% | not timed | not timed | 445.33 ± 9.8% | | 1.06 | 1.24 | 4.85 |
| opt/accelerate/non-dna | 16745 | 399.17 ± 3.0% | not timed | not timed | 424.68 ± 5.5% | 31.19 ± 23.9% | not timed | not timed | 401.47 ± 7.6% | | 0.99 | 0.94 | 12.80 |
| opt/backtrack/words-english | 40536 | 130.14 ± 8.4% | not timed | not timed | 109.64 ± 8.0% | 19.36 ± 14.2% | not timed | not timed | 131.02 ± 7.9% | | 0.99 | 1.19 | 6.72 |
| opt/fixed-length/too-small-ascii | 0 | 339.22 ± 5.4% | not timed | not timed | 823.86 ± 8.2% | 112.60 ± 8.1% | not timed | not timed | 342.27 ± 8.7% | | 0.99 | 0.41 | 3.01 |
| opt/fixed-length/too-big-ascii | 0 | 838.87 ± 3.8% | not timed | not timed | 6663.98 ± 6.5% | 146.20 ± 1.5% | not timed | not timed | 842.34 ± 5.8% | | 1.00 | 0.13 | 5.74 |
| opt/fixed-length/go33484-1 | 0 | 65.79 ± 7.6% | not timed | not timed | 1332591.67 ± 12.3% | 73536.11 ± 7.1% | not timed | not timed | 65.45 ± 4.8% | | 1.01 | 0.0000 | 0.0009 |
| opt/fixed-length/go33484-2 | 0 | 3803.82 ± 10.9% | not timed | not timed | 1299906.64 ± 14.8% | 39515.28 ± 12.2% | not timed | not timed | 3792.07 ± 13.8% | | 1.00 | 0.0029 | 0.0963 |
| opt/fixed-length/go33484-3 | 0 | 1618.94 ± 3.8% | not timed | not timed | 131041.41 ± 15.1% | 957.57 ± 5.7% | not timed | not timed | 1516.62 ± 8.7% | | 1.07 | 0.0124 | 1.69 |
| opt/literal-alt/one-pattern | 1 | 556.84 ± 3.7% | not timed | not timed | 561.68 ± 7.3% | 0.39 ± 10.0% | not timed | not timed | 560.48 ± 12.2% | | 0.99 | 0.99 | 1424.50 |
| opt/onepass/fn-predicate | 916 | 410.27 ± 6.8% | not timed | not timed | 367.56 ± 10.2% | 200.79 ± 12.7% | not timed | not timed | 402.84 ± 5.7% | | 1.02 | 1.12 | 2.04 |
| opt/onepass/first-three-words-english | 35128 | 141.70 ± 8.2% | not timed | not timed | 210.54 ± 9.2% | 82.13 ± 12.8% | not timed | not timed | 141.75 ± 6.1% | | 1.00 | 0.67 | 1.73 |
| opt/prefilter/literal-english | 1 | 31897.11 ± 10.1% | not timed | not timed | 29342.70 ± 6.4% | 21352.99 ± 11.1% | not timed | not timed | 32270.54 ± 5.2% | | 0.99 | 1.09 | 1.49 |
| opt/prefilter/literal-casei-english | 1 | 25192.48 ± 10.4% | not timed | not timed | 10134.15 ± 4.0% | 32.52 ± 9.4% | not timed | not timed | 24527.28 ± 7.6% | | 1.03 | 2.49 | 774.67 |
| opt/prefilter/literal-russian | 1 | 33390.18 ± 13.8% | not timed | not timed | 28448.10 ± 11.3% | 1670.04 ± 2.7% | not timed | not timed | 33013.57 ± 14.3% | | 1.01 | 1.17 | 19.99 |
| opt/prefilter/literal-casei-russian | 1 | 19414.11 ± 13.0% | not timed | not timed | 7994.40 ± 3.7% | 36.29 ± 11.5% | not timed | not timed | 19293.02 ± 11.4% | | 1.01 | 2.43 | 534.92 |
| opt/prefilter/rust-functions | 948 | 11124.04 ± 3.7% | not timed | not timed | 9331.82 ± 9.2% | 1777.61 ± 10.0% | not timed | not timed | 10849.75 ± 11.4% | | 1.03 | 1.19 | 6.26 |
| opt/reverse-anchored/word-end | 1 | 3881.15 ± 7.0% | not timed | not timed | 32162977.27 ± 4.2% | 52.70 ± 3.6% | not timed | not timed | 3757.80 ± 6.4% | | 1.03 | 0.0001 | 73.65 |
| opt/reverse-inner/holmes | 2593 | 551.97 ± 5.0% | not timed | not timed | 13588.46 ± 14.1% | 23.38 ± 3.7% | not timed | not timed | 551.64 ± 5.3% | | 1.00 | 0.0406 | 23.61 |
| opt/reverse-inner/email | 47 | 955.00 ± 10.7% | not timed | not timed | 30879.10 ± 2.3% | 32.43 ± 1.8% | not timed | not timed | 910.03 ± 9.2% | | 1.05 | 0.0309 | 29.45 |
| opt/reverse-inner/factored-prefix | 3542 | 536.69 ± 4.3% | not timed | not timed | 540.45 ± 6.3% | 12.53 ± 7.8% | not timed | not timed | 532.09 ± 8.1% | | 1.01 | 0.99 | 42.85 |
| opt/reverse-inner/no-quadratic-backward | 0 | 3826.89 ± 5.3% | not timed | not timed | 551.01 ± 8.3% | 71.80 ± 5.8% | not timed | not timed | 3777.63 ± 11.7% | | 1.01 | 6.95 | 53.30 |
| opt/reverse-inner/no-quadratic-forward | 0 | 618.79 ± 5.2% | not timed | not timed | 258.74 ± 5.2% | 27.26 ± 11.4% | not timed | not timed | 611.27 ± 4.5% | | 1.01 | 2.39 | 22.70 |
| opt/reverse-suffix/holmes | 4073 | 553.26 ± 2.8% | not timed | not timed | 12403.05 ± 7.6% | 23.38 ± 5.6% | not timed | not timed | 540.03 ± 9.9% | | 1.02 | 0.0446 | 23.66 |
| opt/reverse-suffix/no-quadratic | 0 | 3684.71 ± 7.7% | not timed | not timed | 552.87 ± 7.2% | 72.82 ± 12.3% | not timed | not timed | 3716.28 ± 3.0% | | 0.99 | 6.66 | 50.60 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.41 ± 8.0% | not timed | not timed | 174.83 ± 3.2% | 14.73 ± 20.3% | not timed | not timed | 120.25 ± 8.1% | | 1.00 | 0.69 | 8.17 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 122.29 ± 8.8% | not timed | not timed | 179.04 ± 5.7% | 15.18 ± 18.1% | not timed | not timed | 119.47 ± 1.9% | | 1.02 | 0.68 | 8.05 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.33 ± 10.1% | not timed | not timed | 0.52 ± 4.6% | 106.90 ± 14.9% | not timed | not timed | 0.32 ± 6.6% | | 1.04 | 0.63 | 0.0031 |
| reported/i1095-word-repetition/ascii-search | 256 | 287.15 ± 11.6% | not timed | not timed | 269.65 ± 5.9% | 104.49 ± 6.1% | not timed | not timed | 294.92 ± 1.7% | | 0.97 | 1.06 | 2.75 |
| reported/i13-subset-regex/original-ascii | 4094 | 9918.31 ± 9.9% | not timed | not timed | 3940.35 ± 5.7% | 10.55 ± 1.4% | not timed | not timed | 9907.19 ± 7.6% | | 1.00 | 2.52 | 940.12 |
| reported/i13-subset-regex/original-unicode | 4094 | 9579.51 ± 7.3% | not timed | not timed | 206.78 ± 4.8% | 10.39 ± 2.7% | not timed | not timed | 9558.55 ± 6.4% | | 1.00 | 46.33 | 922.34 |
| reported/i13-subset-regex/big-ascii | 1955 | 8989.17 ± 8.7% | not timed | not timed | 56.65 ± 6.6% | 9.16 ± 1.5% | not timed | not timed | 9043.29 ± 7.7% | | 0.99 | 158.68 | 981.22 |
| reported/i13-subset-regex/big-unicode | 1955 | 8921.72 ± 9.1% | not timed | not timed | 10.06 ± 55.8% | 9.15 ± 1.1% | not timed | not timed | 9068.81 ± 8.6% | | 0.98 | 887.05 | 974.56 |
| reported/i13-subset-regex/huge-ascii | 55 | 8487.16 ± 7.0% | not timed | not timed | 9.21 ± 3.8% | 8.70 ± 3.3% | not timed | not timed | 8285.56 ± 7.5% | | 1.02 | 921.28 | 975.30 |
| reported/i13-subset-regex/huge-unicode | 55 | 8101.38 ± 11.4% | not timed | not timed | 9.14 ± 3.7% | 8.55 ± 2.3% | not timed | not timed | 8033.66 ± 27.5% | | 1.01 | 886.53 | 947.63 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.69 ± 6.0% | not timed | not timed | 9.25 ± 1.8% | 8.57 ± 1.3% | not timed | not timed | 3.76 ± 5.7% | | 0.98 | 0.40 | 0.43 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.95 ± 1.8% | not timed | not timed | 9.22 ± 2.1% | 8.47 ± 1.9% | not timed | not timed | 4.97 ± 4.3% | | 1.00 | 0.54 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 452.47 ± 7.0% | not timed | not timed | 127.21 ± 11.0% | 6.42 ± 9.1% | not timed | not timed | 447.58 ± 5.0% | | 1.01 | 3.56 | 70.44 |
| reported/i787-keywords/opt-ascii | 5674 | 421.90 ± 9.4% | not timed | not timed | 256.47 ± 8.2% | 9.29 ± 7.8% | not timed | not timed | 441.17 ± 4.4% | | 0.96 | 1.65 | 45.41 |
| slow/quadratic-regex-1x | 100 | 7.65 ± 8.6% | not timed | not timed | 5.44 ± 9.1% | 0.05 ± 6.1% | not timed | not timed | 7.53 ± 6.9% | | 1.02 | 1.41 | 146.93 |
| slow/quadratic-regex-2x | 199 | 3.29 ± 11.4% | not timed | not timed | 2.75 ± 10.2% | 0.01 ± 9.6% | not timed | not timed | 3.27 ± 9.0% | | 1.01 | 1.20 | 249.97 |
| slow/quadratic-haystack-1x | 100 | 24.15 ± 7.2% | not timed | not timed | 11.03 ± 7.0% | 1.00 ± 28.3% | not timed | not timed | 24.20 ± 5.8% | | 1.00 | 2.19 | 24.15 |
| slow/quadratic-haystack-2x | 200 | 18.87 ± 2.5% | not timed | not timed | 5.59 ± 6.1% | 0.56 ± 13.4% | not timed | not timed | 18.99 ± 15.2% | | 0.99 | 3.38 | 33.97 |
| unicode/codepoints/any-one | 1112064 | 323.56 ± 39.1% | not timed | not timed | 254.45 ± 7.8% | 16.76 ± 6.2% | not timed | not timed | 331.76 ± 3.9% | | 0.98 | 1.27 | 19.30 |
| unicode/codepoints/any-all | 4382592 | 245.55 ± 10.1% | not timed | not timed | 234.98 ± 5.4% | 100.67 ± 2.2% | not timed | not timed | 243.84 ± 5.2% | | 1.01 | 1.04 | 2.44 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.08 ± 4.3% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 537.32 ± 8.2% | not timed | not timed | 541.30 ± 7.8% | 145.50 ± 6.9% | not timed | not timed | 537.52 ± 6.2% | | 1.00 | 0.99 | 3.69 |
| unicode/overlapping-words/ascii | 6156 | 27.23 ± 3.5% | not timed | not timed | 41.41 ± 4.8% | 4.38 ± 4.0% | not timed | not timed | 28.46 ± 3.8% | | 0.96 | 0.66 | 6.22 |
| unicode/overlapping-words/english | 6156 | 1.33 ± 6.8% | not timed | not timed | 2.12 ± 4.6% | 2.37 ± 8.1% | not timed | not timed | 1.36 ± 7.2% | | 0.98 | 0.63 | 0.56 |
| unicode/overlapping-words/russian | 5710 | 1.18 ± 11.1% | not timed | not timed | 1.95 ± 5.8% | 5.98 ± 5.9% | not timed | not timed | 1.28 ± 1.9% | | 0.93 | 0.61 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 95.57 ± 15.1% | not timed | not timed | 79.07 ± 9.5% | 9.77 ± 33.0% | not timed | not timed | 94.25 ± 1.8% | | 1.01 | 1.21 | 9.78 |
| unicode/word/boundary-long-english | 3466 | 529.80 ± 7.1% | not timed | not timed | 534.64 ± 5.7% | 31.71 ± 7.4% | not timed | not timed | 539.39 ± 6.7% | | 0.98 | 0.99 | 16.71 |
| unicode/word/around-holmes-english | 27 | 527.79 ± 5.2% | not timed | not timed | 27140.79 ± 9.8% | 20.58 ± 5.2% | not timed | not timed | 528.66 ± 3.2% | | 1.00 | 0.0194 | 25.65 |
| wild/bibleref/long | 874 | 501.45 ± 3.6% | not timed | not timed | 511.09 ± 5.3% | 7.83 ± 4.6% | not timed | not timed | 496.85 ± 7.2% | | 1.01 | 0.98 | 64.02 |
| wild/bibleref/short | 30 | 20.64 ± 6.7% | not timed | not timed | 31.15 ± 8.5% | 14.00 ± 16.4% | not timed | not timed | 20.57 ± 10.9% | | 1.00 | 0.66 | 1.47 |
| wild/bibleref/line | 874 | 411.35 ± 5.7% | not timed | not timed | 234.75 ± 8.6% | 8.31 ± 9.7% | not timed | not timed | 417.40 ± 7.5% | | 0.99 | 1.75 | 49.48 |
| wild/caddy/caddy | 6 | 429.80 ± 8.5% | not timed | not timed | 248.32 ± 8.6% | 68.69 ± 20.6% | not timed | not timed | 433.93 ± 4.0% | | 0.99 | 1.73 | 6.26 |
| wild/dot-star-capture/rust-src-tools | 6 | 1080.35 ± 2.9% | not timed | not timed | 298.65 ± 3.9% | 13.65 ± 4.8% | not timed | not timed | 1059.57 ± 4.2% | | 1.02 | 3.62 | 79.13 |
| wild/ruff/noqa | 84 | 451.07 ± 5.4% | not timed | not timed | 464.38 ± 11.2% | 20.40 ± 4.0% | not timed | not timed | 464.50 ± 10.3% | | 0.97 | 0.97 | 22.12 |
| wild/ruff/unnecessary-coding-comment | 16 | 497.84 ± 4.3% | not timed | not timed | 609.58 ± 7.5% | 130.69 ± 14.7% | not timed | not timed | 497.99 ± 7.5% | | 1.00 | 0.82 | 3.81 |
| wild/ruff/string-quote-prefix | 2972 | 467.50 ± 5.8% | not timed | not timed | 441.84 ± 5.8% | 352.32 ± 33.4% | not timed | not timed | 472.70 ± 9.6% | | 0.99 | 1.06 | 1.33 |
| wild/ruff/space-around-operator | 1224378 | 211.95 ± 1.8% | not timed | not timed | 201.13 ± 6.5% | 17.64 ± 2.8% | not timed | not timed | 211.67 ± 7.7% | | 1.00 | 1.05 | 12.01 |
| wild/ruff/shebang | 282 | 452.81 ± 5.8% | not timed | not timed | 359.65 ± 4.4% | 117.81 ± 9.9% | not timed | not timed | 450.81 ± 3.9% | | 1.00 | 1.26 | 3.84 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13679.05 ± 9.5% | not timed | not timed | 15014.55 ± 2.0% | 6332.58 ± 6.2% | not timed | not timed | 13737.95 ± 4.1% | | 1.00 | 0.91 | 2.16 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12706.10 ± 6.4% | not timed | not timed | 14652.75 ± 8.7% | 6133.26 ± 9.8% | not timed | not timed | 12862.54 ± 4.4% | | 0.99 | 0.87 | 2.07 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13483.22 ± 5.4% | not timed | not timed | 14832.81 ± 6.5% | 6301.97 ± 5.3% | not timed | not timed | 13392.35 ± 4.7% | | 1.01 | 0.91 | 2.14 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 11597.86 ± 5.4% | not timed | not timed | 14462.17 ± 9.3% | 6161.67 ± 41.0% | not timed | not timed | 12027.05 ± 12.3% | | 0.96 | 0.80 | 1.88 |
| wild/url/search | 234965 | 121.83 ± 15.9% | not timed | not timed | 61.17 ± 2.6% | 2.18 ± 3.3% | not timed | not timed | 119.89 ± 11.4% | | 1.02 | 1.99 | 55.76 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.02 ± 47.3% | not timed | not timed | 0.01 ± 4.6% | 0.01 ± 19.5% | not timed | not timed | 0.02 ± 4.8% | | 0.98 | 3.27 | 3.82 |
| dictionary/compile/english-15 | 1 | 0.30 ± 10.3% | not timed | not timed | 0.07 ± 6.7% | 0.10 ± 27.6% | not timed | not timed | 0.30 ± 12.4% | | 1.01 | 4.29 | 3.07 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.23 ± 6.9% | not timed | not timed | 0.02 ± 7.4% | 32.46 ± 14.3% | not timed | not timed | 0.23 ± 17.9% | | 0.99 | 11.95 | 0.0070 |
| reported/i1095-word-repetition/ascii-compile | 1 | 38.28 ± 9.4% | not timed | not timed | 12.41 ± 7.5% | 50.39 ± 19.4% | not timed | not timed | 39.30 ± 5.0% | | 0.97 | 3.08 | 0.76 |
| reported/i787-keywords/compile | 1 | 36.26 ± 24.7% | not timed | not timed | 1.83 ± 5.0% | 16.43 ± 19.8% | not timed | not timed | 36.38 ± 6.9% | | 1.00 | 19.84 | 2.21 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 378.22 ± 7.0% | not timed | not timed | 131.33 ± 13.9% | 561.41 ± 23.9% | not timed | not timed | 385.38 ± 5.3% | | 0.98 | 2.88 | 0.67 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 53.50 ± 15.9% | not timed | not timed | 3.91 ± 9.8% | 41.52 ± 14.5% | not timed | not timed | 53.68 ± 7.7% | | 1.00 | 13.66 | 1.29 |
| unicode/compile/one-letter | 53 | 6.20 ± 32.2% | not timed | not timed | 4.90 ± 6.6% | 54.08 ± 12.2% | not timed | not timed | 6.30 ± 4.6% | | 0.98 | 1.27 | 0.11 |
| unicode/compile/fifty-letters | 1 | 0.90 ± 8.5% | not timed | not timed | 0.10 ± 5.6% | 56.53 ± 16.4% | not timed | not timed | 0.90 ± 7.8% | | 1.01 | 8.86 | 0.0160 |
| unicode/compile/fifty-letters-ascii | 1 | 217.31 ± 4.1% | not timed | not timed | 54.50 ± 4.8% | 195.51 ± 28.6% | not timed | not timed | 217.20 ± 7.5% | | 1.00 | 3.99 | 1.11 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 424.31 ± 6.4% | not timed | not timed | 40.71 ± 3.8% | 647.87 ± 11.8% | not timed | not timed | 423.31 ± 3.4% | | 1.00 | 10.42 | 0.65 |
| unicode/compile/match-every-line-ascii | 4 | 692.85 ± 11.6% | not timed | not timed | 150.23 ± 6.4% | 608.14 ± 28.1% | not timed | not timed | 685.73 ± 3.6% | | 1.01 | 4.61 | 1.14 |
| unicode/compile/negated-class-matches-codepoint | 1 | 351.35 ± 9.8% | not timed | not timed | 44.66 ± 4.1% | 1198.65 ± 29.2% | not timed | not timed | 342.05 ± 16.4% | | 1.03 | 7.87 | 0.29 |
| wild/bibleref/compile | 3 | 5.37 ± 19.7% | not timed | not timed | 1.88 ± 9.7% | 29.84 ± 17.3% | not timed | not timed | 5.41 ± 27.6% | | 0.99 | 2.85 | 0.18 |
| wild/url/compile | 1 | 0.66 ± 15.8% | not timed | not timed | 0.14 ± 8.4% | 0.40 ± 17.1% | not timed | not timed | 0.67 ± 10.9% | | 0.98 | 4.59 | 1.65 |

