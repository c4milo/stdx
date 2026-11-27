# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45895089065 |
| Date | 2026-11-26 |
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
| literal: a word | 217 | 45633.63 ± 0.2% | 11926.48 ± 2.7% | 29.84 ± 0.6% | 38617.65 ± 0.4% | 12113.01 ± 3.3% | 12.93 ± 0.2% | 104.53 ± 0.3% | 45603.48 ± 1.2% | 3.83 | 1.00 | 1.18 | 3.77 |
| literal: a word that is not there | 0 | 64905.87 ± 0.2% | 11100.45 ± 0.3% | 29.85 ± 0.2% | 45846.64 ± 0.4% | 44105.23 ± 0.4% | 12.78 ± 0.2% | 98.47 ± 0.7% | 64733.26 ± 0.3% | 5.85 | 1.00 | 1.42 | 1.47 |
| literal: one of four words | 661 | 15676.77 ± 0.9% | 1645.51 ± 0.3% | 16.44 ± 0.6% | 11235.42 ± 0.1% | 24.94 ± 0.6% | 4.49 ± 1.0% | 8.26 ± 0.5% | 15699.38 ± 0.5% | 9.53 | 1.00 | 1.40 | 628.67 |
| literal: a word in any case | 217 | 40426.91 ± 0.8% | 1773.46 ± 0.4% | 22.46 ± 0.3% | 11434.39 ± 0.9% | 46.29 ± 0.3% | refused | differs | 40365.15 ± 0.5% | 22.80 | 1.00 | 3.54 | 873.29 |
| literal: an href attribute | 33 | 41055.15 ± 0.3% | 616.29 ± 0.4% | 28.78 ± 2.5% | 35114.18 ± 0.8% | 3039.64 ± 8.2% | 9.68 ± 0.4% | 91.29 ± 0.4% | 41203.67 ± 8.1% | 66.62 | 1.00 | 1.17 | 13.51 |
| literal: a word, second text | 123 | 49412.49 ± 0.4% | 6103.56 ± 3.8% | 29.58 ± 0.9% | 39640.08 ± 0.3% | 11189.42 ± 7.1% | 14.53 ± 0.4% | 87.35 ± 7.5% | 49336.40 ± 0.3% | 8.10 | 1.00 | 1.25 | 4.42 |
| class: two capitalized words | 1331 | 1151.63 ± 0.3% | 611.37 ± 0.2% | 27.98 ± 0.6% | 575.90 ± 0.9% | 44.52 ± 9.2% | 11.08 ± 0.6% | 79.38 ± 0.3% | 1151.42 ± 0.4% | 1.88 | 1.00 | 2.00 | 25.87 |
| class: a word that ends in ing | 3399 | 582.11 ± 0.2% | 582.64 ± 0.5% | 20.05 ± 0.3% | 538.04 ± 0.3% | 32.75 ± 6.5% | 6.23 ± 0.1% | 20.68 ± 0.6% | 582.11 ± 0.2% | 1.00 | 1.00 | 1.08 | 17.78 |
| class: a word in capitals | 2332 | 1575.44 ± 0.4% | 616.90 ± 0.3% | 29.34 ± 0.4% | 566.55 ± 0.4% | 48.02 ± 1.0% | 12.53 ± 0.1% | 102.03 ± 1.7% | 1578.17 ± 0.9% | 2.55 | 1.00 | 2.78 | 32.81 |
| class: a number | 8288 | 3223.69 ± 7.4% | 853.23 ± 0.5% | 29.58 ± 0.9% | 1807.32 ± 2.7% | 48.43 ± 19.8% | 0.39 ± 0.7% | 71.80 ± 0.4% | 3201.55 ± 0.8% | 3.78 | 1.01 | 1.78 | 66.57 |
| class: two capitalized words, second text | 5359 | 522.44 ± 0.2% | 528.47 ± 0.3% | 25.48 ± 0.8% | 478.96 ± 0.1% | 38.64 ± 15.7% | 12.79 ± 0.3% | 73.87 ± 4.5% | 520.08 ± 0.4% | 0.99 | 1.00 | 1.09 | 13.52 |
| other: a word between two words | 6104 | 850.85 ± 0.7% | 606.04 ± 0.4% | 25.25 ± 5.8% | 815.38 ± 1.4% | 121.81 ± 20.2% | 8.54 ± 0.4% | 81.30 ± 8.0% | 862.99 ± 0.5% | 1.40 | 0.99 | 1.04 | 6.99 |
| other: a number before a unit, second text | 1481 | 10548.69 ± 0.5% | 1166.57 ± 0.3% | 27.82 ± 0.4% | 8311.12 ± 0.3% | 44.96 ± 0.2% | 13.37 ± 0.9% | 77.57 ± 1.1% | 10585.68 ± 0.5% | 9.04 | 1.00 | 1.27 | 234.63 |
| other: a heading's start tag | 110 | 25025.34 ± 1.1% | 747.84 ± 0.3% | 29.60 ± 1.1% | 2566.19 ± 1.1% | 1978.95 ± 5.0% | 11.84 ± 0.6% | 107.06 ± 0.4% | 25037.64 ± 0.3% | 33.46 | 1.00 | 9.75 | 12.65 |
| other: a whole word | 217 | 32569.63 ± 0.5% | 609.00 ± 0.1% | 30.12 ± 0.3% | 27968.13 ± 0.9% | 54.29 ± 1.6% | 11.15 ± 0.1% | 62.29 ± 0.4% | 32619.37 ± 0.3% | 53.48 | 1.00 | 1.16 | 599.92 |
| other: a line's first word, second text | 3716 | 2425.38 ± 1.2% | 598.10 ± 0.5% | 32.09 ± 0.5% | 2328.82 ± 3.6% | 70.12 ± 3.0% | refused | refused | 2448.44 ± 1.6% | 4.06 | 0.99 | 1.04 | 34.59 |
| other: fourteen octets before an x | 87 | 35402.72 ± 2.2% | 252.74 ± 0.9% | 7.52 ± 1.0% | 3433.80 ± 0.2% | 11.54 ± 0.7% | differs | 20.27 ± 1.2% | 35364.22 ± 0.4% | 140.08 | 1.00 | 10.31 | 3067.22 |
| other: a Greek word | 21815 | 571.70 ± 0.4% | 439.26 ± 0.3% | 33.13 ± 0.3% | 305.04 ± 0.8% | 53.96 ± 7.5% | differs | refused | 574.42 ± 0.9% | 1.30 | 1.00 | 1.87 | 10.60 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 31.59 ± 1.0% | 31.28 ± 0.6% | 1.02 ± 0.4% | 19.90 ± 0.1% | 2.69 ± 0.3% | differs | 4.23 ± 1.4% | 31.43 ± 1.8% | 1.01 | 1.01 | 1.59 | 11.73 |
| a UUID | 32895 | 27.77 ± 1.2% | 27.84 ± 1.7% | 0.72 ± 0.7% | 13.63 ± 0.6% | 3.06 ± 2.7% | 0.52 ± 0.6% | 3.86 ± 1.2% | 27.66 ± 1.2% | 1.00 | 1.00 | 2.04 | 9.09 |
| an IPv4 address | 33176 | 39.86 ± 2.0% | 39.79 ± 1.6% | 2.30 ± 0.2% | 28.55 ± 0.4% | 7.01 ± 0.9% | differs | 4.18 ± 1.1% | 39.41 ± 1.1% | 1.00 | 1.01 | 1.40 | 5.69 |
| a date and time | 32954 | 36.98 ± 8.7% | 37.71 ± 2.7% | 1.70 ± 0.2% | 19.67 ± 1.8% | 8.20 ± 2.6% | 0.91 ± 0.1% | 7.68 ± 16.0% | 38.09 ± 0.2% | 0.98 | 0.97 | 1.88 | 4.51 |
| a field path | 32606 | 33.68 ± 1.2% | 33.55 ± 0.4% | 1.13 ± 0.5% | 22.87 ± 0.1% | 3.52 ± 2.5% | differs | 2.99 ± 1.0% | 33.60 ± 0.9% | 1.00 | 1.00 | 1.47 | 9.58 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.95 ± 0.3% | 10.93 ± 0.4% | 10.89 ± 0.7% | 13.37 ± 0.9% | 5.75 ± 3.2% | 0.75 ± 0.4% | none | 10.86 ± 0.3% | 1.00 | 1.01 | 0.82 | 1.90 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 252.61 ± 0.2% | 252.88 ± 0.4% | 296.99 ± 0.2% | 102.45 ± 1.4% | 245.76 ± 2.1% | 708.27 ± 0.5% | 4902.44 ± 1.7% | 252.78 ± 0.3% | 1.00 | 1.00 | 2.47 | 1.03 |
| a UUID | 62 | 167.25 ± 7.0% | 167.58 ± 0.9% | 187.35 ± 0.6% | 57.41 ± 4.4% | 119.27 ± 50.8% | 253.92 ± 6.9% | 5376.86 ± 4.1% | 167.73 ± 0.5% | 1.00 | 1.00 | 2.91 | 1.40 |
| an IPv4 address | 29 | 495.81 ± 0.4% | 495.47 ± 0.3% | 684.08 ± 0.4% | 87.08 ± 0.8% | 149.69 ± 1.1% | 406.43 ± 7.7% | 9011.30 ± 0.4% | 493.64 ± 0.5% | 1.00 | 1.00 | 5.69 | 3.31 |
| a date and time | 56 | 358.28 ± 0.5% | 358.67 ± 0.2% | 446.71 ± 9.7% | 85.88 ± 6.3% | 161.51 ± 3.9% | 475.92 ± 0.6% | 5569.95 ± 0.3% | 357.51 ± 0.5% | 1.00 | 1.00 | 4.17 | 2.22 |
| a field path | 39 | 253.16 ± 0.4% | 253.35 ± 2.6% | 297.15 ± 0.1% | 94.18 ± 6.8% | 229.79 ± 7.9% | 742.99 ± 2.3% | 5943.99 ± 1.4% | 253.16 ± 0.3% | 1.00 | 1.00 | 2.69 | 1.10 |
| literal: a word | 7 | 736.80 ± 0.8% | 789.04 ± 0.3% | 1399.67 ± 18.1% | 647.50 ± 1.8% | 800.96 ± 1.7% | 1592.19 ± 0.4% | 33822.95 ± 0.9% | 736.07 ± 1.7% | 0.93 | 1.00 | 1.14 | 0.92 |
| literal: a word that is not there | 8 | 708.99 ± 3.1% | 759.56 ± 0.3% | 1312.00 ± 0.3% | 591.36 ± 0.4% | 769.54 ± 2.0% | 1502.88 ± 0.7% | 33291.06 ± 0.7% | 707.20 ± 33.1% | 0.93 | 1.00 | 1.20 | 0.92 |
| literal: one of four words | 26 | 272.40 ± 0.5% | 440.59 ± 0.3% | 586.14 ± 3.7% | 53.64 ± 4.3% | 292.08 ± 15.4% | 586.07 ± 2.6% | 18400.12 ± 0.3% | 272.17 ± 0.5% | 0.62 | 1.00 | 5.08 | 0.93 |
| literal: a word in any case | 11 | 503.52 ± 1.6% | 537.30 ± 0.4% | 770.67 ± 0.8% | 18.98 ± 0.3% | 814.81 ± 60.0% | refused | 24846.76 ± 3.4% | 503.78 ± 1.3% | 0.94 | 1.00 | 26.53 | 0.62 |
| literal: an href attribute | 12 | 396.89 ± 0.3% | 412.49 ± 0.2% | 542.38 ± 0.4% | 50.89 ± 1.9% | 573.31 ± 2.6% | 1260.99 ± 1.5% | 24548.78 ± 0.4% | 396.57 ± 0.3% | 0.96 | 1.00 | 7.80 | 0.69 |
| literal: a word, second text | 10 | 654.01 ± 0.4% | 712.69 ± 0.1% | 1181.08 ± 0.5% | 530.24 ± 1.1% | 667.43 ± 8.2% | 1326.18 ± 0.9% | 31782.49 ± 0.6% | 654.29 ± 0.3% | 0.92 | 1.00 | 1.23 | 0.98 |
| class: two capitalized words | 23 | 508.74 ± 0.4% | 546.35 ± 0.8% | 783.73 ± 0.8% | 122.03 ± 0.1% | 595.49 ± 23.7% | 1231.42 ± 0.8% | 7926.72 ± 1.1% | 507.83 ± 2.5% | 0.93 | 1.00 | 4.17 | 0.85 |
| class: a word that ends in ing | 9 | 625.88 ± 0.1% | 722.93 ± 3.3% | 1240.65 ± 0.5% | 150.85 ± 0.5% | 859.63 ± 13.4% | 1810.48 ± 2.6% | 19216.42 ± 13.7% | 624.83 ± 8.1% | 0.87 | 1.00 | 4.15 | 0.73 |
| class: a word in capitals | 16 | 561.37 ± 9.2% | 614.72 ± 0.3% | 962.83 ± 0.4% | 156.12 ± 1.3% | 892.32 ± 1.8% | 1706.29 ± 0.5% | 10590.29 ± 2.1% | 562.04 ± 0.3% | 0.91 | 1.00 | 3.60 | 0.63 |
| class: a number | 6 | 702.31 ± 0.6% | 790.04 ± 0.2% | 1456.50 ± 1.6% | 46.92 ± 0.5% | 1622.63 ± 1.0% | 2910.39 ± 3.9% | 25866.52 ± 0.3% | 702.90 ± 0.5% | 0.89 | 1.00 | 14.97 | 0.43 |
| class: two capitalized words, second text | 23 | 509.25 ± 0.5% | 548.39 ± 0.7% | 784.40 ± 0.7% | 121.58 ± 0.7% | 595.31 ± 3.9% | 1257.45 ± 2.1% | 7942.74 ± 10.3% | 509.05 ± 0.5% | 0.93 | 1.00 | 4.19 | 0.86 |
| other: a word between two words | 13 | 629.40 ± 1.1% | 652.84 ± 0.4% | 1016.18 ± 2.3% | 159.62 ± 0.9% | 583.17 ± 2.2% | 1337.97 ± 0.2% | 17898.52 ± 0.4% | 628.08 ± 0.4% | 0.96 | 1.00 | 3.94 | 1.08 |
| other: a number before a unit, second text | 15 | 445.84 ± 0.5% | 506.57 ± 0.4% | 703.86 ± 0.8% | 44.07 ± 1.8% | 726.93 ± 10.5% | 1477.92 ± 3.7% | 17707.98 ± 0.5% | 445.88 ± 0.3% | 0.88 | 1.00 | 10.12 | 0.61 |
| other: a heading's start tag | 13 | 408.87 ± 0.2% | 417.31 ± 0.5% | 551.36 ± 0.3% | 48.90 ± 0.6% | 711.26 ± 6.9% | 1386.73 ± 1.0% | 20560.69 ± 0.4% | 407.01 ± 2.0% | 0.98 | 1.00 | 8.36 | 0.57 |
| other: a whole word | 11 | 654.80 ± 1.4% | 694.66 ± 0.4% | 1121.53 ± 0.6% | 142.30 ± 2.3% | 686.34 ± 2.6% | 1376.82 ± 0.3% | 31605.27 ± 0.4% | 653.50 ± 0.6% | 0.94 | 1.00 | 4.60 | 0.95 |
| other: a line's first word, second text | 17 | 592.73 ± 0.4% | 635.27 ± 0.1% | 1003.32 ± 0.6% | 148.12 ± 1.5% | 794.79 ± 19.6% | refused | refused | 592.66 ± 0.6% | 0.93 | 1.00 | 4.00 | 0.75 |
| other: fourteen octets before an x | 16 | 114.25 ± 2.5% | 173.51 ± 10.8% | 205.58 ± 10.5% | 17.87 ± 0.5% | 519.30 ± 2.7% | 581.19 ± 0.3% | 13920.38 ± 6.3% | 114.27 ± 0.3% | 0.66 | 1.00 | 6.39 | 0.22 |
| other: a Greek word | 8 | 466.54 ± 5.6% | 668.76 ± 0.5% | 1092.04 ± 0.4% | 62.93 ± 1.3% | 1547.10 ± 10.1% | 2769.75 ± 4.4% | refused | 467.21 ± 3.8% | 0.70 | 1.00 | 7.41 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 34140.29 ± 1.0% | not timed | not timed | 33836.64 ± 1.3% | 2906.01 ± 11.7% | not timed | not timed | 34187.22 ± 0.1% | | 1.00 | 1.01 | 11.75 |
| 01-literal/sherlock-casei-en | 522 | 27778.89 ± 0.3% | not timed | not timed | 8941.24 ± 0.2% | 33.89 ± 2.0% | not timed | not timed | 27769.64 ± 0.3% | | 1.00 | 3.11 | 819.58 |
| 01-literal/sherlock-ru | 724 | 35619.22 ± 0.6% | not timed | not timed | 34346.58 ± 0.3% | 1302.51 ± 4.8% | not timed | not timed | 35644.95 ± 0.5% | | 1.00 | 1.04 | 27.35 |
| 01-literal/sherlock-casei-ru | 746 | 12375.04 ± 2.2% | not timed | not timed | 7823.79 ± 1.1% | 37.58 ± 1.7% | not timed | not timed | 12295.63 ± 0.5% | | 1.01 | 1.58 | 329.33 |
| 01-literal/sherlock-zh | 30 | 60830.16 ± 0.2% | not timed | not timed | 42897.77 ± 0.3% | 1639.40 ± 4.4% | not timed | not timed | 60713.51 ± 1.1% | | 1.00 | 1.42 | 37.11 |
| 02-literal-alternate/sherlock-en | 714 | 14172.26 ± 0.4% | not timed | not timed | 10873.46 ± 0.7% | 19.13 ± 0.5% | not timed | not timed | 14206.56 ± 0.9% | | 1.00 | 1.30 | 740.77 |
| 02-literal-alternate/sherlock-casei-en | 725 | 5186.73 ± 3.2% | not timed | not timed | 2296.50 ± 0.8% | 12.29 ± 0.6% | not timed | not timed | 5198.17 ± 2.6% | | 1.00 | 2.26 | 421.99 |
| 02-literal-alternate/sherlock-ru | 899 | 10787.76 ± 1.0% | not timed | not timed | 9782.07 ± 1.1% | 25.47 ± 1.5% | not timed | not timed | 10702.68 ± 0.3% | | 1.01 | 1.10 | 423.47 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2528.10 ± 4.1% | not timed | not timed | 1185.30 ± 0.6% | 10.52 ± 1.8% | not timed | not timed | 2523.76 ± 4.3% | | 1.00 | 2.13 | 240.29 |
| 02-literal-alternate/sherlock-zh | 207 | 20014.81 ± 6.9% | not timed | not timed | 12620.83 ± 10.6% | 35.64 ± 0.4% | not timed | not timed | 20037.82 ± 0.2% | | 1.00 | 1.59 | 561.60 |
| 03-date/ascii | 111817 | 145.61 ± 0.9% | not timed | not timed | 99.04 ± 7.5% | 0.23 ± 1.8% | not timed | not timed | 146.29 ± 0.8% | | 1.00 | 1.47 | 641.77 |
| 04-ruff-noqa/real | 84 | 507.90 ± 0.4% | not timed | not timed | 510.60 ± 0.4% | 20.84 ± 0.6% | not timed | not timed | 505.47 ± 0.6% | | 1.00 | 0.99 | 24.37 |
| 04-ruff-noqa/tweaked | 44 | 890.92 ± 1.7% | not timed | not timed | 515.65 ± 0.2% | 368.60 ± 10.7% | not timed | not timed | 896.92 ± 0.3% | | 0.99 | 1.73 | 2.42 |
| 05-lexer-veryl/single | 124800 | 4.84 ± 4.3% | not timed | not timed | 5.19 ± 12.8% | 0.26 ± 4.8% | not timed | not timed | 4.90 ± 7.1% | | 0.99 | 0.93 | 18.72 |
| 06-cloud-flare-redos/original | 107 | 451.12 ± 0.2% | not timed | not timed | 228.37 ± 2.7% | 25.83 ± 0.9% | not timed | not timed | 448.59 ± 4.5% | | 1.01 | 1.98 | 17.47 |
| 06-cloud-flare-redos/simplified-short | 102 | 450.34 ± 0.2% | not timed | not timed | 235.85 ± 0.8% | 27.70 ± 0.2% | not timed | not timed | 450.17 ± 0.6% | | 1.00 | 1.91 | 16.26 |
| 06-cloud-flare-redos/simplified-long | 10000 | 584.22 ± 0.2% | not timed | not timed | 259.78 ± 0.8% | 29.83 ± 1.0% | not timed | not timed | 584.20 ± 0.3% | | 1.00 | 2.25 | 19.58 |
| 07-unicode-character-data/parse-line | 558784 | 252.24 ± 1.5% | not timed | not timed | 202.50 ± 2.3% | 48.50 ± 8.6% | not timed | not timed | 235.14 ± 2.3% | | 1.07 | 1.25 | 5.20 |
| 08-words/all-english | 56691 | 131.08 ± 2.2% | not timed | not timed | 84.86 ± 0.4% | 13.54 ± 2.9% | not timed | not timed | 132.03 ± 1.2% | | 0.99 | 1.54 | 9.68 |
| 08-words/long-english | 839 | 620.00 ± 0.6% | not timed | not timed | 584.89 ± 0.5% | 35.25 ± 1.0% | not timed | not timed | 618.90 ± 0.2% | | 1.00 | 1.06 | 17.59 |
| 09-aws-keys/full | 0 | 518.16 ± 4.9% | not timed | not timed | 540.35 ± 0.7% | 65.85 ± 1.8% | not timed | not timed | 518.52 ± 0.2% | | 1.00 | 0.96 | 7.87 |
| 09-aws-keys/quick | 0 | 1144.09 ± 0.5% | not timed | not timed | 963.11 ± 0.5% | 416.49 ± 12.7% | not timed | not timed | 1140.72 ± 0.4% | | 1.00 | 1.19 | 2.75 |
| 10-bounded-repeat/letters-en | 1833 | 681.25 ± 0.7% | not timed | not timed | 556.26 ± 0.8% | 22.63 ± 0.8% | not timed | not timed | 682.55 ± 1.0% | | 1.00 | 1.22 | 30.10 |
| 10-bounded-repeat/letters-ru | 3475 | 521.14 ± 1.3% | not timed | not timed | 483.13 ± 0.5% | 23.32 ± 10.7% | not timed | not timed | 526.20 ± 1.3% | | 0.99 | 1.08 | 22.35 |
| 10-bounded-repeat/context | 53 | 91.10 ± 12.4% | not timed | not timed | 70.78 ± 0.4% | 22.46 ± 1.1% | not timed | not timed | 91.05 ± 1.4% | | 1.00 | 1.29 | 4.06 |
| 10-bounded-repeat/capitals | 11 | 641.14 ± 8.0% | not timed | not timed | 605.50 ± 0.3% | 40.26 ± 0.8% | not timed | not timed | 643.47 ± 8.2% | | 1.00 | 1.06 | 15.92 |
| 11-unstructured-to-json/extract | 600 | 51.98 ± 0.9% | not timed | not timed | 71.44 ± 1.3% | 50.64 ± 1.1% | not timed | not timed | 51.99 ± 1.3% | | 1.00 | 0.73 | 1.03 |
| 12-dictionary/single | 1 | 511.22 ± 3.6% | not timed | not timed | 479.70 ± 0.1% | 0.38 ± 2.9% | not timed | not timed | 515.53 ± 2.1% | | 0.99 | 1.07 | 1340.43 |
| 14-quadratic/1x | 100 | 28.53 ± 0.4% | not timed | not timed | 12.16 ± 0.8% | 1.00 ± 10.1% | not timed | not timed | 28.40 ± 1.3% | | 1.00 | 2.35 | 28.57 |
| 14-quadratic/2x | 200 | 25.64 ± 0.3% | not timed | not timed | 6.12 ± 0.3% | 0.55 ± 1.1% | not timed | not timed | 25.50 ± 1.3% | | 1.01 | 4.19 | 46.60 |
| 14-quadratic/10x | 1000 | 15.03 ± 0.5% | not timed | not timed | 1.22 ± 0.2% | 0.12 ± 2.2% | not timed | not timed | 15.03 ± 0.6% | | 1.00 | 12.36 | 126.74 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.39 ± 2.5% | not timed | not timed | 0.47 ± 0.6% | 0.64 ± 7.3% | not timed | not timed | 1.40 ± 0.7% | | 0.99 | 2.98 | 2.17 |
| 04-ruff-noqa/compile-real | 1 | 123.39 ± 1.8% | not timed | not timed | 17.28 ± 0.8% | 169.04 ± 6.3% | not timed | not timed | 122.54 ± 0.8% | | 1.01 | 7.14 | 0.73 |
| 05-lexer-veryl/compile-single | 1 | 16.50 ± 1.5% | not timed | not timed | 2.93 ± 0.3% | 7.85 ± 3.9% | not timed | not timed | 16.59 ± 0.4% | | 0.99 | 5.63 | 2.10 |
| 07-unicode-character-data/compile | 1 | 126.64 ± 0.2% | not timed | not timed | 29.95 ± 1.4% | 44.99 ± 1.3% | not timed | not timed | 125.27 ± 1.0% | | 1.01 | 4.23 | 2.81 |
| 09-aws-keys/compile-full | 1 | 55.48 ± 0.8% | not timed | not timed | 9.87 ± 3.0% | 27.97 ± 2.1% | not timed | not timed | 55.65 ± 0.3% | | 1.00 | 5.62 | 1.98 |
| 09-aws-keys/compile-quick | 1 | 195.58 ± 1.0% | not timed | not timed | 57.51 ± 0.6% | 155.81 ± 3.6% | not timed | not timed | 192.27 ± 0.9% | | 1.02 | 3.40 | 1.26 |
| 10-bounded-repeat/compile-context | 1 | 60.28 ± 1.0% | not timed | not timed | 14.38 ± 0.7% | 20.42 ± 3.6% | not timed | not timed | 60.11 ± 1.3% | | 1.00 | 4.19 | 2.95 |
| 10-bounded-repeat/compile-capitals | 1 | 94.46 ± 1.0% | not timed | not timed | 10.59 ± 1.9% | 29.20 ± 1.8% | not timed | not timed | 94.22 ± 25.1% | | 1.00 | 8.92 | 3.24 |
| 11-unstructured-to-json/compile | 1 | 191.76 ± 8.8% | not timed | not timed | 46.97 ± 0.6% | 80.64 ± 2.5% | not timed | not timed | 189.09 ± 1.1% | | 1.01 | 4.08 | 2.38 |
| 12-dictionary/compile-single | 1 | 0.34 ± 4.0% | not timed | not timed | 0.08 ± 19.2% | 0.11 ± 22.7% | not timed | not timed | 0.34 ± 1.8% | | 0.99 | 4.02 | 3.07 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.27 ± 0.5% | not timed | not timed | 6.91 ± 0.8% | 0.64 ± 15.9% | not timed | not timed | 7.22 ± 12.6% | | 1.01 | 1.05 | 11.40 |
| dictionary/search/english-10 | 690 | 213.38 ± 2.6% | not timed | not timed | 150.70 ± 1.2% | 0.01 ± 0.3% | not timed | not timed | 213.03 ± 0.4% | | 1.00 | 1.42 | 30725.27 |
| dictionary/search/english-15 | 15 | 510.38 ± 2.3% | not timed | not timed | 482.02 ± 0.7% | 0.37 ± 7.1% | not timed | not timed | 515.36 ± 1.8% | | 0.99 | 1.06 | 1393.25 |
| folly/awyer-inn-busted | 1 | 24119.80 ± 14.0% | not timed | not timed | 132.42 ± 8.9% | 48.19 ± 0.3% | not timed | not timed | 24097.89 ± 0.8% | | 1.00 | 182.14 | 500.47 |
| folly/literal-never-match-rare | 0 | 67745.60 ± 1.0% | not timed | not timed | 46454.07 ± 0.3% | 69430.23 ± 1.0% | not timed | not timed | 67882.62 ± 0.9% | | 1.00 | 1.46 | 0.98 |
| folly/literal-never-match-frequent | 0 | 28846.47 ± 14.4% | not timed | not timed | 46156.82 ± 0.3% | 2589.55 ± 0.2% | not timed | not timed | 28938.86 ± 8.0% | | 1.00 | 0.62 | 11.14 |
| folly/literal-never-match-tricksy | 1 | 3988.40 ± 1.6% | not timed | not timed | 6148.62 ± 0.2% | 1725.46 ± 0.2% | not timed | not timed | 3984.94 ± 1.3% | | 1.00 | 0.65 | 2.31 |
| grep/every-line | 239963 | 1416.29 ± 0.5% | not timed | not timed | 968.58 ± 1.3% | 373.30 ± 18.0% | not timed | not timed | 1417.88 ± 1.1% | | 1.00 | 1.46 | 3.79 |
| grep/long-words-ascii | 5073 | 499.11 ± 1.0% | not timed | not timed | 498.06 ± 0.1% | 50.94 ± 6.9% | not timed | not timed | 501.47 ± 0.2% | | 1.00 | 1.00 | 9.80 |
| imported/leipzig/twain | 811 | 56614.17 ± 2.4% | not timed | not timed | 43647.34 ± 1.4% | 12842.13 ± 10.6% | not timed | not timed | 57108.94 ± 1.5% | | 0.99 | 1.30 | 4.41 |
| imported/leipzig/twain-insensitive | 965 | 15215.28 ± 0.3% | not timed | not timed | 13480.22 ± 0.8% | 44.36 ± 0.3% | not timed | not timed | 15238.41 ± 0.5% | | 1.00 | 1.13 | 343.00 |
| imported/leipzig/shing | 1540 | 29042.66 ± 1.1% | not timed | not timed | 22291.51 ± 0.2% | 38.09 ± 3.2% | not timed | not timed | 29122.07 ± 1.0% | | 1.00 | 1.30 | 762.46 |
| imported/leipzig/huck-saw | 262 | 24965.38 ± 0.7% | not timed | not timed | 18691.68 ± 15.0% | 35.90 ± 0.3% | not timed | not timed | 24916.23 ± 0.6% | | 1.00 | 1.34 | 695.41 |
| imported/leipzig/word-ending-nn | 262 | 609.62 ± 0.1% | not timed | not timed | 603.57 ± 0.3% | 27.48 ± 0.6% | not timed | not timed | 609.65 ± 0.0% | | 1.00 | 1.01 | 22.18 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 10811.88 ± 0.8% | not timed | not timed | 3930.38 ± 6.3% | 12.22 ± 1.3% | not timed | not timed | 10837.22 ± 0.9% | | 1.00 | 2.75 | 884.57 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 21655.30 ± 1.1% | not timed | not timed | 17641.16 ± 0.3% | 19.30 ± 1.6% | not timed | not timed | 21600.10 ± 1.3% | | 1.00 | 1.23 | 1121.98 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5530.66 ± 0.4% | not timed | not timed | 791.88 ± 0.2% | 12.35 ± 3.9% | not timed | not timed | 5504.07 ± 4.9% | | 1.00 | 6.98 | 447.68 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 17994.93 ± 0.8% | not timed | not timed | 602.16 ± 0.4% | 12.26 ± 0.0% | not timed | not timed | 17987.02 ± 1.0% | | 1.00 | 29.88 | 1467.48 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 16995.59 ± 1.1% | not timed | not timed | 602.82 ± 0.1% | 10.59 ± 1.4% | not timed | not timed | 16910.54 ± 12.5% | | 1.01 | 28.19 | 1604.11 |
| imported/leipzig/tom-river | 2 | 12938.17 ± 0.5% | not timed | not timed | 13406.66 ± 0.6% | 33.59 ± 0.5% | not timed | not timed | 12935.70 ± 11.2% | | 1.00 | 0.97 | 385.14 |
| imported/leipzig/ing | 78424 | 599.46 ± 0.5% | not timed | not timed | 560.79 ± 0.5% | 30.73 ± 3.6% | not timed | not timed | 600.08 ± 0.5% | | 1.00 | 1.07 | 19.51 |
| imported/leipzig/ing-whitespace | 55248 | 1922.71 ± 1.0% | not timed | not timed | 2135.48 ± 0.7% | 22.68 ± 2.3% | not timed | not timed | 1922.35 ± 0.4% | | 1.00 | 0.90 | 84.77 |
| imported/leipzig/awyer-inn | 209 | 10930.44 ± 16.4% | not timed | not timed | 13784.74 ± 0.3% | 24.59 ± 2.1% | not timed | not timed | 10907.27 ± 0.2% | | 1.00 | 0.79 | 444.58 |
| imported/leipzig/quotes-bounded | 8886 | 2316.00 ± 4.7% | not timed | not timed | 3285.68 ± 0.7% | 41.03 ± 3.1% | not timed | not timed | 2316.92 ± 1.2% | | 1.00 | 0.70 | 56.44 |
| imported/leipzig/non-ascii-alternate | 2 | 40739.03 ± 19.2% | not timed | not timed | 19596.93 ± 0.8% | 57.00 ± 0.5% | not timed | not timed | 40816.04 ± 0.5% | | 1.00 | 2.08 | 714.69 |
| imported/leipzig/math-symbols | 69 | 2431.43 ± 0.2% | not timed | not timed | 602.46 ± 0.3% | 39.47 ± 0.4% | not timed | not timed | 2435.96 ± 0.3% | | 1.00 | 4.04 | 61.60 |
| imported/leipzig/bounded-strings-ending-z | 0 | 609.89 ± 0.6% | not timed | not timed | 603.08 ± 0.7% | 25.88 ± 2.5% | not timed | not timed | 609.76 ± 0.4% | | 1.00 | 1.01 | 23.57 |
| imported/lh3lh3-reb/uri | 17549 | 806.14 ± 0.4% | not timed | not timed | 1130.49 ± 0.7% | 30.96 ± 4.4% | not timed | not timed | 805.29 ± 7.7% | | 1.00 | 0.71 | 26.04 |
| imported/lh3lh3-reb/email | 15057 | 799.57 ± 0.9% | not timed | not timed | 1134.87 ± 0.9% | 33.08 ± 2.7% | not timed | not timed | 800.95 ± 0.4% | | 1.00 | 0.70 | 24.17 |
| imported/lh3lh3-reb/date | 668 | 948.85 ± 0.2% | not timed | not timed | 1013.82 ± 5.2% | 53.87 ± 6.5% | not timed | not timed | 947.91 ± 0.5% | | 1.00 | 0.94 | 17.61 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 744.92 ± 0.4% | not timed | not timed | 443.53 ± 0.1% | 16.09 ± 2.4% | not timed | not timed | 745.59 ± 0.3% | | 1.00 | 1.68 | 46.30 |
| imported/mariomka/email | 92 | 39261.07 ± 0.5% | not timed | not timed | 60076.56 ± 0.5% | 35.94 ± 0.2% | not timed | not timed | 39320.53 ± 2.0% | | 1.00 | 0.65 | 1092.48 |
| imported/mariomka/uri | 5301 | 6563.30 ± 0.9% | not timed | not timed | 7897.74 ± 0.8% | 35.91 ± 8.7% | not timed | not timed | 6582.27 ± 17.5% | | 1.00 | 0.83 | 182.77 |
| imported/mariomka/ip | 5 | 2550.55 ± 2.9% | not timed | not timed | 2325.12 ± 0.2% | 22.88 ± 4.4% | not timed | not timed | 2538.36 ± 10.3% | | 1.00 | 1.10 | 111.45 |
| imported/rsc/no-exponential | 0 | 887.30 ± 0.2% | not timed | not timed | 425.84 ± 0.8% | 25.98 ± 23.1% | not timed | not timed | 885.51 ± 1.4% | | 1.00 | 2.08 | 34.16 |
| imported/rsc/literal | 1 | 1908.16 ± 3.7% | not timed | not timed | 2229.99 ± 0.6% | 252.18 ± 11.4% | not timed | not timed | 1938.90 ± 8.1% | | 0.98 | 0.86 | 7.57 |
| imported/rsc/not-literal | 2 | 962.01 ± 2.4% | not timed | not timed | 791.22 ± 1.4% | 50.89 ± 20.6% | not timed | not timed | 957.95 ± 0.3% | | 1.00 | 1.22 | 18.90 |
| imported/rsc/match-class | 1 | 1904.15 ± 1.2% | not timed | not timed | 1756.39 ± 1.5% | 66.69 ± 6.7% | not timed | not timed | 1900.72 ± 30.9% | | 1.00 | 1.08 | 28.55 |
| imported/rsc/match-class-in-range | 1 | 1890.58 ± 4.4% | not timed | not timed | 3434.53 ± 0.5% | 69.92 ± 3.7% | not timed | not timed | 1893.46 ± 5.6% | | 1.00 | 0.55 | 27.04 |
| imported/rsc/match-class-unicode | 1 | 571.40 ± 4.7% | not timed | not timed | 523.72 ± 0.4% | 83.09 ± 0.7% | not timed | not timed | 570.62 ± 0.1% | | 1.00 | 1.09 | 6.88 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1587.13 ± 0.3% | not timed | not timed | 1165.16 ± 0.6% | 344.72 ± 2.6% | not timed | not timed | 1586.06 ± 0.3% | | 1.00 | 1.36 | 4.60 |
| imported/rsc/anchored-literal-long-non-match | 0 | 23794.81 ± 0.3% | not timed | not timed | 17241.16 ± 1.1% | 5145.20 ± 2.2% | not timed | not timed | 23800.78 ± 0.3% | | 1.00 | 1.38 | 4.62 |
| imported/rsc/anchored-literal-short-match | 4 | 838.62 ± 1.3% | not timed | not timed | 575.04 ± 0.5% | 108.78 ± 6.4% | not timed | not timed | 835.42 ± 1.4% | | 1.00 | 1.46 | 7.71 |
| imported/rsc/anchored-literal-long-match | 4 | 12554.64 ± 1.4% | not timed | not timed | 8638.32 ± 1.1% | 1664.06 ± 4.0% | not timed | not timed | 12572.17 ± 1.3% | | 1.00 | 1.45 | 7.54 |
| imported/rsc/one-pass-short | 17 | 483.05 ± 2.9% | not timed | not timed | 261.17 ± 0.5% | 38.95 ± 12.2% | not timed | not timed | 478.49 ± 6.8% | | 1.01 | 1.85 | 12.40 |
| imported/rsc/one-pass-short-not | 17 | 318.28 ± 5.4% | not timed | not timed | 268.69 ± 1.9% | 35.06 ± 15.8% | not timed | not timed | 329.68 ± 1.6% | | 0.97 | 1.18 | 9.08 |
| imported/rsc/one-pass-long-prefix | 26 | 438.00 ± 2.4% | not timed | not timed | 322.79 ± 0.4% | 126.39 ± 15.0% | not timed | not timed | 431.31 ± 0.5% | | 1.02 | 1.36 | 3.47 |
| imported/rsc/one-pass-long-prefix-not | 26 | 431.53 ± 2.2% | not timed | not timed | 314.92 ± 0.5% | 86.71 ± 7.5% | not timed | not timed | 439.34 ± 7.2% | | 0.98 | 1.37 | 4.98 |
| imported/rsc/long-needle1 | 31 | 67983.75 ± 0.4% | not timed | not timed | 45874.90 ± 0.4% | 4.20 ± 0.9% | not timed | not timed | 68088.04 ± 11.3% | | 1.00 | 1.48 | 16205.50 |
| imported/rsc/long-needle2 | 31 | 67581.12 ± 0.2% | not timed | not timed | 227.76 ± 0.6% | 4.20 ± 1.2% | not timed | not timed | 67624.51 ± 10.9% | | 1.00 | 296.73 | 16079.07 |
| imported/rsc/easy0-32 | 26 | 2009.31 ± 2.0% | not timed | not timed | 1931.68 ± 1.2% | 164.31 ± 16.0% | not timed | not timed | 2018.20 ± 4.4% | | 1.00 | 1.04 | 12.23 |
| imported/rsc/easy0-1k | 26 | 16774.01 ± 17.3% | not timed | not timed | 19910.34 ± 5.1% | 2310.31 ± 13.7% | not timed | not timed | 16479.84 ± 2.9% | | 1.02 | 0.84 | 7.26 |
| imported/rsc/easy0-32k | 26 | 63155.68 ± 2.7% | not timed | not timed | 43716.20 ± 0.2% | 26076.35 ± 47.0% | not timed | not timed | 62900.39 ± 0.6% | | 1.00 | 1.44 | 2.42 |
| imported/rsc/easy0-1mb | 26 | 66737.02 ± 8.1% | not timed | not timed | 46066.23 ± 0.4% | 68273.17 ± 1.6% | not timed | not timed | 66765.29 ± 0.3% | | 1.00 | 1.45 | 0.98 |
| imported/rsc/easy1-32 | 19 | 931.40 ± 2.7% | not timed | not timed | 761.54 ± 0.6% | 147.34 ± 7.5% | not timed | not timed | 935.62 ± 1.3% | | 1.00 | 1.22 | 6.32 |
| imported/rsc/easy1-1k | 19 | 18999.52 ± 2.1% | not timed | not timed | 15643.18 ± 1.6% | 2799.23 ± 19.7% | not timed | not timed | 19215.61 ± 19.3% | | 0.99 | 1.21 | 6.79 |
| imported/rsc/easy1-32k | 19 | 599159.72 ± 2.4% | not timed | not timed | 485867.99 ± 1.5% | 28939.72 ± 18.1% | not timed | not timed | 602471.85 ± 1.5% | | 0.99 | 1.23 | 20.70 |
| imported/rsc/easy1-1mb | 19 | 19248885.09 ± 1.3% | not timed | not timed | 15640038.66 ± 1.0% | 68221.88 ± 0.3% | not timed | not timed | 19195250.28 ± 1.0% | | 1.00 | 1.23 | 282.15 |
| imported/rsc/medium-32 | 27 | 877.18 ± 12.4% | not timed | not timed | 743.53 ± 0.3% | 82.97 ± 14.6% | not timed | not timed | 877.48 ± 0.2% | | 1.00 | 1.18 | 10.57 |
| imported/rsc/medium-1k | 27 | 15675.62 ± 0.1% | not timed | not timed | 7929.18 ± 2.7% | 82.90 ± 8.2% | not timed | not timed | 15596.37 ± 1.4% | | 1.01 | 1.98 | 189.09 |
| imported/rsc/medium-32k | 27 | 488181.95 ± 0.3% | not timed | not timed | 414436.66 ± 0.4% | 53.81 ± 42.1% | not timed | not timed | 487920.84 ± 0.4% | | 1.00 | 1.18 | 9072.93 |
| imported/rsc/medium-1mb | 27 | 15621489.46 ± 0.5% | not timed | not timed | 13265181.19 ± 7.0% | 54.28 ± 1.0% | not timed | not timed | 15588089.47 ± 0.3% | | 1.00 | 1.18 | 287810.45 |
| imported/rsc/hard-32 | 58 | 450.54 ± 5.3% | not timed | not timed | 392.90 ± 0.3% | 53.57 ± 4.3% | not timed | not timed | 451.40 ± 0.3% | | 1.00 | 1.15 | 8.41 |
| imported/rsc/hard-1k | 27 | 14918.02 ± 0.6% | not timed | not timed | 13149.91 ± 0.2% | 44.82 ± 0.9% | not timed | not timed | 15010.30 ± 0.5% | | 0.99 | 1.13 | 332.82 |
| imported/rsc/hard-32k | 27 | 467512.64 ± 0.8% | not timed | not timed | 400822.30 ± 1.0% | 32.96 ± 0.5% | not timed | not timed | 468721.79 ± 0.3% | | 1.00 | 1.17 | 14183.56 |
| imported/rsc/hard-1mb | 51 | 9041028.63 ± 0.1% | not timed | not timed | 7821702.13 ± 0.4% | 33.13 ± 0.9% | not timed | not timed | 9018149.63 ± 1.8% | | 1.00 | 1.16 | 272936.03 |
| imported/rsc/reallyhard0-32 | 58 | 280.77 ± 7.7% | not timed | not timed | 246.22 ± 0.3% | 53.46 ± 2.7% | not timed | not timed | 274.90 ± 0.1% | | 1.02 | 1.14 | 5.25 |
| imported/rsc/reallyhard0-1k | 27 | 590.52 ± 0.4% | not timed | not timed | 579.55 ± 0.1% | 44.51 ± 0.8% | not timed | not timed | 592.07 ± 0.2% | | 1.00 | 1.02 | 13.27 |
| imported/rsc/reallyhard0-32k | 27 | 608.61 ± 0.4% | not timed | not timed | 603.94 ± 0.1% | 32.85 ± 1.4% | not timed | not timed | 609.18 ± 0.2% | | 1.00 | 1.01 | 18.53 |
| imported/rsc/reallyhard0-1mb | 51 | 606.85 ± 1.2% | not timed | not timed | 604.46 ± 0.3% | 33.15 ± 1.8% | not timed | not timed | 609.98 ± 0.3% | | 0.99 | 1.00 | 18.31 |
| imported/rsc/reallyreallyhard0-32 | 47 | 331.72 ± 1.5% | not timed | not timed | 207.65 ± 0.2% | 67.25 ± 6.8% | not timed | not timed | 331.02 ± 1.3% | | 1.00 | 1.60 | 4.93 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7638.64 ± 1.8% | not timed | not timed | 7733.23 ± 0.3% | 36.70 ± 6.9% | not timed | not timed | 7661.02 ± 0.4% | | 1.00 | 0.99 | 208.16 |
| imported/rsc/reallyreallyhard0-32k | 16 | 52169.35 ± 1.8% | not timed | not timed | 36538.43 ± 0.3% | 26.81 ± 0.8% | not timed | not timed | 52084.96 ± 0.2% | | 1.00 | 1.43 | 1945.53 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 70394.07 ± 1.2% | not timed | not timed | 45803.28 ± 0.1% | 27.06 ± 0.7% | not timed | not timed | 70449.17 ± 0.5% | | 1.00 | 1.54 | 2601.81 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 310.91 ± 1.3% | not timed | not timed | 216.53 ± 0.7% | 66.21 ± 12.1% | not timed | not timed | 319.55 ± 1.1% | | 0.97 | 1.44 | 4.70 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 6389.65 ± 0.1% | not timed | not timed | 7522.51 ± 0.4% | 36.87 ± 0.6% | not timed | not timed | 6374.72 ± 0.5% | | 1.00 | 0.85 | 173.29 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 48800.36 ± 1.3% | not timed | not timed | 37119.08 ± 1.2% | 27.09 ± 0.2% | not timed | not timed | 48983.52 ± 0.2% | | 1.00 | 1.31 | 1801.53 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 63369.13 ± 0.6% | not timed | not timed | 45611.37 ± 0.3% | 27.13 ± 1.0% | not timed | not timed | 63170.37 ± 0.4% | | 1.00 | 1.39 | 2335.63 |
| imported/sherlock/name-sherlock | 776 | 47287.57 ± 10.5% | not timed | not timed | 39956.72 ± 1.4% | 13100.23 ± 21.9% | not timed | not timed | 47673.83 ± 7.1% | | 0.99 | 1.18 | 3.61 |
| imported/sherlock/name-holmes | 2766 | 23391.89 ± 1.7% | not timed | not timed | 30229.48 ± 0.6% | 3850.50 ± 5.2% | not timed | not timed | 23557.71 ± 1.7% | | 0.99 | 0.77 | 6.08 |
| imported/sherlock/name-sherlock-holmes | 1365 | 48107.93 ± 1.9% | not timed | not timed | 40134.03 ± 1.7% | 10624.25 ± 30.7% | not timed | not timed | 48085.41 ± 2.1% | | 1.00 | 1.20 | 4.53 |
| imported/sherlock/name-sherlock-casei | 816 | 43757.14 ± 0.5% | not timed | not timed | 11562.05 ± 0.2% | 34.06 ± 1.5% | not timed | not timed | 43665.37 ± 0.2% | | 1.00 | 3.78 | 1284.81 |
| imported/sherlock/name-holmes-casei | 2802 | 19750.48 ± 21.7% | not timed | not timed | 7670.29 ± 0.1% | 44.87 ± 28.4% | not timed | not timed | 19687.49 ± 6.2% | | 1.00 | 2.57 | 440.13 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 35023.53 ± 2.2% | not timed | not timed | 11192.70 ± 16.4% | 34.02 ± 1.9% | not timed | not timed | 34958.03 ± 0.2% | | 1.00 | 3.13 | 1029.36 |
| imported/sherlock/name-whitespace | 1461 | 28017.52 ± 1.1% | not timed | not timed | 28115.87 ± 17.0% | 7741.07 ± 23.6% | not timed | not timed | 28155.08 ± 1.0% | | 1.00 | 1.00 | 3.62 |
| imported/sherlock/name-alt1 | 1142 | 29110.28 ± 1.2% | not timed | not timed | 29627.00 ± 0.7% | 5666.02 ± 38.0% | not timed | not timed | 29042.78 ± 0.6% | | 1.00 | 0.98 | 5.14 |
| imported/sherlock/name-alt2 | 3542 | 17876.12 ± 0.2% | not timed | not timed | 10098.18 ± 1.1% | 36.15 ± 0.6% | not timed | not timed | 17874.35 ± 0.6% | | 1.00 | 1.77 | 494.50 |
| imported/sherlock/name-alt3 | 4507 | 11737.64 ± 0.8% | not timed | not timed | 9234.50 ± 0.1% | 11.31 ± 0.6% | not timed | not timed | 11758.36 ± 23.7% | | 1.00 | 1.27 | 1037.86 |
| imported/sherlock/name-alt3-casei | 4593 | 3571.40 ± 3.2% | not timed | not timed | 1314.17 ± 0.4% | 7.57 ± 1.4% | not timed | not timed | 3591.73 ± 3.0% | | 0.99 | 2.72 | 472.00 |
| imported/sherlock/name-alt4 | 3686 | 9957.94 ± 0.4% | not timed | not timed | 8205.48 ± 0.3% | 35.98 ± 1.1% | not timed | not timed | 9962.89 ± 0.9% | | 1.00 | 1.21 | 276.74 |
| imported/sherlock/name-alt4-casei | 4254 | 5461.73 ± 1.1% | not timed | not timed | 4464.22 ± 1.1% | 20.50 ± 1.5% | not timed | not timed | 5474.42 ± 1.2% | | 1.00 | 1.22 | 266.41 |
| imported/sherlock/name-alt5 | 4028 | 14913.09 ± 0.2% | not timed | not timed | 9695.47 ± 0.7% | 24.85 ± 0.6% | not timed | not timed | 14932.21 ± 0.2% | | 1.00 | 1.54 | 600.15 |
| imported/sherlock/name-alt5-casei | 4104 | 7013.39 ± 4.6% | not timed | not timed | 3007.56 ± 2.5% | 15.47 ± 18.5% | not timed | not timed | 7016.94 ± 0.3% | | 1.00 | 2.33 | 453.23 |
| imported/sherlock/no-match-uncommon | 0 | 68089.86 ± 3.6% | not timed | not timed | 57915.41 ± 6.5% | 57336.55 ± 1.2% | not timed | not timed | 68243.38 ± 0.4% | | 1.00 | 1.18 | 1.19 |
| imported/sherlock/no-match-common | 0 | 66817.13 ± 0.5% | not timed | not timed | 57800.72 ± 1.3% | 2136.66 ± 2.3% | not timed | not timed | 66870.19 ± 0.5% | | 1.00 | 1.16 | 31.27 |
| imported/sherlock/no-match-really-common | 0 | 43048.39 ± 0.3% | not timed | not timed | 49759.78 ± 8.7% | 2162.41 ± 1.0% | not timed | not timed | 42928.57 ± 10.0% | | 1.00 | 0.87 | 19.91 |
| imported/sherlock/the-lower | 21654 | 3368.36 ± 4.1% | not timed | not timed | 4586.11 ± 1.4% | 265.85 ± 26.5% | not timed | not timed | 3388.77 ± 1.3% | | 0.99 | 0.73 | 12.67 |
| imported/sherlock/the-upper | 2223 | 17152.40 ± 1.1% | not timed | not timed | 27288.51 ± 1.4% | 3069.52 ± 15.0% | not timed | not timed | 17172.19 ± 1.1% | | 1.00 | 0.63 | 5.59 |
| imported/sherlock/the-casei | 23961 | 3020.61 ± 24.4% | not timed | not timed | 1364.03 ± 0.9% | 41.38 ± 40.3% | not timed | not timed | 3028.31 ± 2.2% | | 1.00 | 2.21 | 73.00 |
| imported/sherlock/everything-greedy | 581881 | 292.56 ± 0.9% | not timed | not timed | 173.81 ± 0.2% | 27.34 ± 30.5% | not timed | not timed | 292.03 ± 2.1% | | 1.00 | 1.68 | 10.70 |
| imported/sherlock/everything-greedy-nl | 594933 | 510.57 ± 0.4% | not timed | not timed | 225.35 ± 0.7% | 34.70 ± 0.4% | not timed | not timed | 510.68 ± 0.1% | | 1.00 | 2.27 | 14.71 |
| imported/sherlock/letters | 447175 | 68.18 ± 9.1% | not timed | not timed | 33.62 ± 0.2% | 6.12 ± 22.3% | not timed | not timed | 68.00 ± 9.6% | | 1.00 | 2.03 | 11.14 |
| imported/sherlock/letters-upper | 14180 | 453.24 ± 3.8% | not timed | not timed | 370.57 ± 0.1% | 31.30 ± 15.5% | not timed | not timed | 453.96 ± 0.5% | | 1.00 | 1.22 | 14.48 |
| imported/sherlock/letters-lower | 432995 | 68.71 ± 29.4% | not timed | not timed | 34.69 ± 1.3% | 6.74 ± 24.5% | not timed | not timed | 68.42 ± 21.1% | | 1.00 | 1.98 | 10.19 |
| imported/sherlock/words | 447639 | 122.04 ± 5.8% | not timed | not timed | 83.21 ± 18.2% | 14.80 ± 11.3% | not timed | not timed | 123.21 ± 0.9% | | 0.99 | 1.47 | 8.24 |
| imported/sherlock/before-holmes | 4073 | 13838.38 ± 0.3% | not timed | not timed | 13277.63 ± 0.3% | 25.82 ± 6.7% | not timed | not timed | 13791.24 ± 7.6% | | 1.00 | 1.04 | 535.96 |
| imported/sherlock/before-after-holmes | 2593 | 13432.72 ± 0.1% | not timed | not timed | 14961.16 ± 0.3% | 25.95 ± 1.0% | not timed | not timed | 13461.05 ± 0.3% | | 1.00 | 0.90 | 517.73 |
| imported/sherlock/holmes-cochar-watson | 150 | 9997.42 ± 0.3% | not timed | not timed | 7712.48 ± 3.1% | 34.92 ± 0.6% | not timed | not timed | 10034.65 ± 1.3% | | 1.00 | 1.30 | 286.27 |
| imported/sherlock/holmes-coword-watson | 14309 | 1273.66 ± 0.2% | not timed | not timed | 1233.42 ± 0.1% | 7.60 ± 1.0% | not timed | not timed | 1276.15 ± 0.1% | | 1.00 | 1.03 | 167.52 |
| imported/sherlock/quotes | 14437 | 1549.85 ± 0.5% | not timed | not timed | 2251.01 ± 5.0% | 37.57 ± 0.7% | not timed | not timed | 1553.26 ± 0.8% | | 1.00 | 0.69 | 41.26 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 34791.65 ± 0.1% | not timed | not timed | 31228.75 ± 1.2% | 40.47 ± 0.9% | not timed | not timed | 34860.96 ± 0.5% | | 1.00 | 1.11 | 859.75 |
| imported/sherlock/word-ending-n | 35297 | 472.89 ± 1.0% | not timed | not timed | 404.99 ± 12.2% | 25.61 ± 1.4% | not timed | not timed | 472.13 ± 0.7% | | 1.00 | 1.17 | 18.47 |
| imported/sherlock/repeated-class-negation | 2130 | 16537.91 ± 0.7% | not timed | not timed | 16338.86 ± 0.4% | 12.35 ± 0.4% | not timed | not timed | 16521.22 ± 0.3% | | 1.00 | 1.01 | 1338.60 |
| imported/sherlock/ing-suffix | 20547 | 566.53 ± 2.3% | not timed | not timed | 512.99 ± 1.3% | 30.47 ± 18.5% | not timed | not timed | 568.38 ± 3.8% | | 1.00 | 1.10 | 18.59 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1745.97 ± 1.2% | not timed | not timed | 2905.71 ± 1.4% | 22.58 ± 1.2% | not timed | not timed | 1752.49 ± 0.5% | | 1.00 | 0.60 | 77.33 |
| opt/accelerate/whole-line | 239963 | 502.68 ± 0.4% | not timed | not timed | 414.72 ± 0.4% | 87.58 ± 16.8% | not timed | not timed | 502.72 ± 0.4% | | 1.00 | 1.21 | 5.74 |
| opt/accelerate/non-dna | 16745 | 454.08 ± 0.5% | not timed | not timed | 435.26 ± 0.1% | 32.70 ± 24.8% | not timed | not timed | 456.21 ± 0.3% | | 1.00 | 1.04 | 13.88 |
| opt/backtrack/words-english | 40536 | 139.49 ± 4.5% | not timed | not timed | 111.49 ± 0.4% | 21.57 ± 8.7% | not timed | not timed | 135.42 ± 3.8% | | 1.03 | 1.25 | 6.47 |
| opt/fixed-length/too-small-ascii | 0 | 390.30 ± 18.3% | not timed | not timed | 709.09 ± 0.2% | 122.84 ± 3.5% | not timed | not timed | 388.98 ± 6.0% | | 1.00 | 0.55 | 3.18 |
| opt/fixed-length/too-big-ascii | 0 | 4298.38 ± 3.5% | not timed | not timed | 6316.02 ± 0.4% | 151.37 ± 0.7% | not timed | not timed | 4247.81 ± 0.4% | | 1.01 | 0.68 | 28.40 |
| opt/fixed-length/go33484-1 | 0 | 826262.93 ± 13.5% | not timed | not timed | 1216202.65 ± 0.3% | 89181.58 ± 1.5% | not timed | not timed | 825501.05 ± 16.4% | | 1.00 | 0.68 | 9.26 |
| opt/fixed-length/go33484-2 | 0 | 827792.37 ± 11.8% | not timed | not timed | 1217383.18 ± 0.4% | 29640.89 ± 14.3% | not timed | not timed | 827116.54 ± 0.3% | | 1.00 | 0.68 | 27.93 |
| opt/fixed-length/go33484-3 | 0 | 82551.44 ± 0.6% | not timed | not timed | 121610.54 ± 0.4% | 938.63 ± 0.8% | not timed | not timed | 82558.62 ± 5.4% | | 1.00 | 0.68 | 87.95 |
| opt/literal-alt/one-pattern | 1 | 580.65 ± 3.5% | not timed | not timed | 569.68 ± 0.4% | 0.38 ± 1.8% | not timed | not timed | 579.93 ± 1.9% | | 1.00 | 1.02 | 1532.29 |
| opt/onepass/fn-predicate | 916 | 427.72 ± 1.1% | not timed | not timed | 399.16 ± 1.1% | 210.95 ± 17.5% | not timed | not timed | 436.19 ± 0.9% | | 0.98 | 1.07 | 2.03 |
| opt/onepass/first-three-words-english | 35128 | 177.13 ± 7.6% | not timed | not timed | 235.30 ± 0.7% | 79.30 ± 12.4% | not timed | not timed | 179.31 ± 7.7% | | 0.99 | 0.75 | 2.23 |
| opt/prefilter/literal-english | 1 | 67616.54 ± 1.4% | not timed | not timed | 46437.23 ± 4.9% | 26693.62 ± 0.6% | not timed | not timed | 67722.88 ± 12.1% | | 1.00 | 1.46 | 2.53 |
| opt/prefilter/literal-casei-english | 1 | 47521.35 ± 0.5% | not timed | not timed | 14319.89 ± 5.9% | 34.08 ± 1.2% | not timed | not timed | 47458.59 ± 0.4% | | 1.00 | 3.32 | 1394.44 |
| opt/prefilter/literal-russian | 1 | 68622.94 ± 0.3% | not timed | not timed | 46133.90 ± 0.2% | 1808.95 ± 0.3% | not timed | not timed | 68500.03 ± 0.6% | | 1.00 | 1.49 | 37.94 |
| opt/prefilter/literal-casei-russian | 1 | 26153.59 ± 12.6% | not timed | not timed | 11016.12 ± 0.3% | 37.80 ± 1.8% | not timed | not timed | 26219.60 ± 16.8% | | 1.00 | 2.37 | 691.94 |
| opt/prefilter/rust-functions | 948 | 14665.17 ± 1.1% | not timed | not timed | 12850.92 ± 0.9% | 1897.45 ± 0.3% | not timed | not timed | 14693.49 ± 1.1% | | 1.00 | 1.14 | 7.73 |
| opt/reverse-anchored/word-end | 1 | 36241633.92 ± 1.4% | not timed | not timed | 27385861.75 ± 1.3% | 52.33 ± 0.5% | not timed | not timed | 36332761.78 ± 0.3% | | 1.00 | 1.32 | 692585.85 |
| opt/reverse-inner/holmes | 2593 | 13395.86 ± 4.2% | not timed | not timed | 14977.54 ± 1.0% | 23.92 ± 3.5% | not timed | not timed | 13479.78 ± 4.6% | | 0.99 | 0.89 | 560.13 |
| opt/reverse-inner/email | 47 | 83255.67 ± 0.8% | not timed | not timed | 92606.01 ± 0.8% | 34.17 ± 9.0% | not timed | not timed | 83175.36 ± 0.7% | | 1.00 | 0.90 | 2436.18 |
| opt/reverse-inner/factored-prefix | 3542 | 599.99 ± 4.9% | not timed | not timed | 586.61 ± 0.2% | 13.62 ± 0.6% | not timed | not timed | 600.11 ± 0.3% | | 1.00 | 1.02 | 44.04 |
| opt/reverse-inner/no-quadratic-backward | 0 | 23286.82 ± 0.2% | not timed | not timed | 603.91 ± 0.3% | 59.13 ± 0.6% | not timed | not timed | 23297.07 ± 0.5% | | 1.00 | 38.56 | 393.84 |
| opt/reverse-inner/no-quadratic-forward | 0 | 707.78 ± 2.0% | not timed | not timed | 278.36 ± 0.7% | 26.66 ± 40.4% | not timed | not timed | 709.43 ± 7.3% | | 1.00 | 2.54 | 26.55 |
| opt/reverse-suffix/holmes | 4073 | 13835.50 ± 0.4% | not timed | not timed | 13290.43 ± 0.1% | 24.04 ± 0.3% | not timed | not timed | 13833.97 ± 19.5% | | 1.00 | 1.04 | 575.60 |
| opt/reverse-suffix/no-quadratic | 0 | 23274.30 ± 0.2% | not timed | not timed | 605.05 ± 0.3% | 85.81 ± 0.9% | not timed | not timed | 23284.41 ± 1.0% | | 1.00 | 38.47 | 271.24 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 141.67 ± 2.5% | not timed | not timed | 177.54 ± 0.6% | 16.96 ± 13.1% | not timed | not timed | 140.69 ± 2.2% | | 1.01 | 0.80 | 8.35 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 142.38 ± 3.5% | not timed | not timed | 181.32 ± 2.9% | 15.88 ± 21.3% | not timed | not timed | 140.88 ± 0.1% | | 1.01 | 0.79 | 8.97 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.32 ± 0.2% | not timed | not timed | 0.47 ± 0.6% | 120.30 ± 0.4% | not timed | not timed | 0.31 ± 1.7% | | 1.05 | 0.68 | 0.0027 |
| reported/i1095-word-repetition/ascii-search | 256 | 303.36 ± 3.3% | not timed | not timed | 282.32 ± 0.1% | 109.99 ± 0.2% | not timed | not timed | 280.38 ± 0.9% | | 1.08 | 1.07 | 2.76 |
| reported/i13-subset-regex/original-ascii | 4094 | 10781.68 ± 2.1% | not timed | not timed | 3955.67 ± 0.4% | 12.23 ± 2.7% | not timed | not timed | 10813.80 ± 1.2% | | 1.00 | 2.73 | 881.77 |
| reported/i13-subset-regex/original-unicode | 4094 | 10756.69 ± 0.7% | not timed | not timed | 210.12 ± 1.9% | 11.80 ± 1.9% | not timed | not timed | 10824.80 ± 0.4% | | 0.99 | 51.19 | 911.40 |
| reported/i13-subset-regex/big-ascii | 1955 | 10193.22 ± 0.6% | not timed | not timed | 54.72 ± 2.4% | 10.47 ± 1.1% | not timed | not timed | 10216.00 ± 0.3% | | 1.00 | 186.28 | 973.44 |
| reported/i13-subset-regex/big-unicode | 1955 | 10123.71 ± 1.2% | not timed | not timed | 9.72 ± 55.5% | 10.52 ± 1.2% | not timed | not timed | 10202.44 ± 0.6% | | 0.99 | 1041.51 | 962.78 |
| reported/i13-subset-regex/huge-ascii | 55 | 9400.44 ± 1.0% | not timed | not timed | 8.27 ± 0.9% | 9.48 ± 1.7% | not timed | not timed | 9422.10 ± 0.8% | | 1.00 | 1136.64 | 991.93 |
| reported/i13-subset-regex/huge-unicode | 55 | 9325.22 ± 0.9% | not timed | not timed | 8.90 ± 1.0% | 9.47 ± 2.7% | not timed | not timed | 9209.92 ± 0.8% | | 1.01 | 1047.64 | 984.90 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.15 ± 1.3% | not timed | not timed | 9.02 ± 0.5% | 9.39 ± 3.2% | not timed | not timed | 4.14 ± 1.0% | | 1.00 | 0.46 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.83 ± 0.6% | not timed | not timed | 8.92 ± 0.9% | 9.54 ± 0.8% | not timed | not timed | 5.78 ± 0.7% | | 1.01 | 0.65 | 0.61 |
| reported/i787-keywords/ascii | 5674 | 556.00 ± 1.3% | not timed | not timed | 170.46 ± 1.1% | 7.38 ± 1.1% | not timed | not timed | 554.87 ± 0.4% | | 1.00 | 3.26 | 75.35 |
| reported/i787-keywords/opt-ascii | 5674 | 554.36 ± 0.6% | not timed | not timed | 272.44 ± 0.4% | 12.11 ± 1.1% | not timed | not timed | 557.11 ± 2.0% | | 1.00 | 2.03 | 45.78 |
| slow/quadratic-regex-1x | 100 | 8.06 ± 1.5% | not timed | not timed | 5.98 ± 0.2% | 0.05 ± 8.0% | not timed | not timed | 8.24 ± 0.9% | | 0.98 | 1.35 | 155.19 |
| slow/quadratic-regex-2x | 199 | 3.70 ± 0.3% | not timed | not timed | 3.05 ± 0.2% | 0.01 ± 0.9% | not timed | not timed | 3.70 ± 0.3% | | 1.00 | 1.21 | 279.91 |
| slow/quadratic-haystack-1x | 100 | 28.48 ± 1.1% | not timed | not timed | 12.17 ± 0.4% | 1.01 ± 13.8% | not timed | not timed | 28.38 ± 2.0% | | 1.00 | 2.34 | 28.27 |
| slow/quadratic-haystack-2x | 200 | 25.59 ± 1.6% | not timed | not timed | 6.10 ± 0.2% | 0.56 ± 6.8% | not timed | not timed | 25.50 ± 0.8% | | 1.00 | 4.20 | 45.78 |
| unicode/codepoints/any-one | 1112064 | 337.72 ± 0.3% | not timed | not timed | 241.37 ± 0.3% | 21.01 ± 18.9% | not timed | not timed | 338.53 ± 1.4% | | 1.00 | 1.40 | 16.08 |
| unicode/codepoints/any-all | 4382592 | 271.95 ± 1.0% | not timed | not timed | 261.28 ± 2.0% | 125.74 ± 0.6% | not timed | not timed | 272.97 ± 0.7% | | 1.00 | 1.04 | 2.16 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.79 ± 2.1% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 609.97 ± 0.1% | not timed | not timed | 603.80 ± 1.2% | 153.52 ± 16.6% | not timed | not timed | 609.79 ± 15.2% | | 1.00 | 1.01 | 3.97 |
| unicode/overlapping-words/ascii | 6156 | 29.78 ± 2.2% | not timed | not timed | 43.15 ± 10.6% | 4.27 ± 16.4% | not timed | not timed | 30.01 ± 3.0% | | 0.99 | 0.69 | 6.98 |
| unicode/overlapping-words/english | 6156 | 1.41 ± 0.7% | not timed | not timed | 3.04 ± 2.6% | 2.86 ± 3.4% | not timed | not timed | 1.48 ± 25.2% | | 0.96 | 0.47 | 0.49 |
| unicode/overlapping-words/russian | 5710 | 1.29 ± 5.0% | not timed | not timed | 3.43 ± 20.9% | 7.22 ± 31.0% | not timed | not timed | 1.33 ± 11.9% | | 0.97 | 0.38 | 0.18 |
| unicode/word/boundary-any-english | 450561 | 135.08 ± 17.2% | not timed | not timed | 85.66 ± 1.3% | 14.11 ± 26.5% | not timed | not timed | 135.31 ± 7.8% | | 1.00 | 1.58 | 9.57 |
| unicode/word/boundary-long-english | 3466 | 612.52 ± 0.2% | not timed | not timed | 592.96 ± 0.7% | 35.15 ± 0.9% | not timed | not timed | 612.61 ± 0.5% | | 1.00 | 1.03 | 17.43 |
| unicode/word/around-holmes-english | 27 | 63183.46 ± 0.3% | not timed | not timed | 44941.52 ± 0.4% | 23.91 ± 1.7% | not timed | not timed | 63026.17 ± 0.9% | | 1.00 | 1.41 | 2642.25 |
| wild/bibleref/long | 874 | 567.70 ± 0.2% | not timed | not timed | 573.55 ± 0.2% | 8.01 ± 0.2% | not timed | not timed | 569.31 ± 2.2% | | 1.00 | 0.99 | 70.91 |
| wild/bibleref/short | 30 | 22.93 ± 1.6% | not timed | not timed | 32.87 ± 0.6% | 15.18 ± 24.1% | not timed | not timed | 23.78 ± 8.4% | | 0.96 | 0.70 | 1.51 |
| wild/bibleref/line | 874 | 506.57 ± 1.6% | not timed | not timed | 273.91 ± 13.4% | 9.97 ± 8.7% | not timed | not timed | 507.29 ± 0.9% | | 1.00 | 1.85 | 50.81 |
| wild/caddy/caddy | 6 | 454.26 ± 4.0% | not timed | not timed | 292.74 ± 0.4% | 79.83 ± 20.4% | not timed | not timed | 457.56 ± 1.9% | | 0.99 | 1.55 | 5.69 |
| wild/dot-star-capture/rust-src-tools | 6 | 1454.43 ± 0.4% | not timed | not timed | 404.45 ± 0.3% | 15.87 ± 0.4% | not timed | not timed | 1457.65 ± 0.2% | | 1.00 | 3.60 | 91.62 |
| wild/ruff/noqa | 84 | 507.03 ± 2.7% | not timed | not timed | 510.17 ± 0.4% | 21.72 ± 4.0% | not timed | not timed | 508.29 ± 1.0% | | 1.00 | 0.99 | 23.35 |
| wild/ruff/unnecessary-coding-comment | 16 | 1070.79 ± 0.7% | not timed | not timed | 723.78 ± 0.7% | 140.29 ± 12.7% | not timed | not timed | 1070.42 ± 0.4% | | 1.00 | 1.48 | 7.63 |
| wild/ruff/string-quote-prefix | 2972 | 1582.71 ± 2.0% | not timed | not timed | 489.62 ± 0.9% | 323.21 ± 29.3% | not timed | not timed | 1582.17 ± 0.9% | | 1.00 | 3.23 | 4.90 |
| wild/ruff/space-around-operator | 1224378 | 231.83 ± 1.4% | not timed | not timed | 227.32 ± 3.8% | 19.66 ± 2.3% | not timed | not timed | 234.32 ± 1.6% | | 0.99 | 1.02 | 11.79 |
| wild/ruff/shebang | 282 | 1102.18 ± 0.9% | not timed | not timed | 390.76 ± 0.1% | 114.86 ± 15.6% | not timed | not timed | 1101.69 ± 0.5% | | 1.00 | 2.82 | 9.60 |
| wild/rustsec-cargo-audit/original-unix | 471 | 22413.71 ± 15.6% | not timed | not timed | 23732.51 ± 0.3% | 9008.44 ± 2.0% | not timed | not timed | 22434.16 ± 7.2% | | 1.00 | 0.94 | 2.49 |
| wild/rustsec-cargo-audit/original-windows | 462 | 20429.41 ± 0.9% | not timed | not timed | 22422.91 ± 0.3% | 8433.41 ± 25.9% | not timed | not timed | 20564.81 ± 2.0% | | 0.99 | 0.91 | 2.42 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 22917.44 ± 1.8% | not timed | not timed | 23425.11 ± 0.3% | 8351.60 ± 3.6% | not timed | not timed | 22863.95 ± 1.0% | | 1.00 | 0.98 | 2.74 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 18250.00 ± 5.6% | not timed | not timed | 23335.78 ± 1.5% | 8694.24 ± 27.5% | not timed | not timed | 18331.37 ± 0.9% | | 1.00 | 0.78 | 2.10 |
| wild/url/search | 234965 | 129.40 ± 13.2% | not timed | not timed | 61.55 ± 7.5% | 2.47 ± 2.0% | not timed | not timed | 131.17 ± 14.1% | | 0.99 | 2.10 | 52.35 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 67.0% | not timed | not timed | 0.01 ± 2.5% | 0.01 ± 15.6% | not timed | not timed | 0.03 ± 58.4% | | 0.99 | 2.53 | 3.82 |
| dictionary/compile/english-15 | 1 | 0.34 ± 1.3% | not timed | not timed | 0.10 ± 0.5% | 0.12 ± 25.3% | not timed | not timed | 0.34 ± 2.4% | | 1.01 | 3.58 | 2.95 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.29 ± 10.7% | not timed | not timed | 0.02 ± 15.8% | 38.46 ± 7.3% | not timed | not timed | 0.30 ± 4.5% | | 0.98 | 12.90 | 0.0076 |
| reported/i1095-word-repetition/ascii-compile | 1 | 42.61 ± 10.8% | not timed | not timed | 16.99 ± 0.7% | 63.57 ± 11.6% | not timed | not timed | 43.04 ± 8.8% | | 0.99 | 2.51 | 0.67 |
| reported/i787-keywords/compile | 1 | 40.13 ± 3.4% | not timed | not timed | 2.37 ± 0.8% | 17.24 ± 21.3% | not timed | not timed | 40.43 ± 11.4% | | 0.99 | 16.90 | 2.33 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 368.64 ± 10.0% | not timed | not timed | 146.08 ± 5.5% | 626.78 ± 9.3% | not timed | not timed | 376.49 ± 23.0% | | 0.98 | 2.52 | 0.59 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 53.70 ± 3.2% | not timed | not timed | 5.51 ± 1.0% | 48.69 ± 6.4% | not timed | not timed | 55.09 ± 2.8% | | 0.97 | 9.75 | 1.10 |
| unicode/compile/one-letter | 53 | 7.08 ± 11.3% | not timed | not timed | 5.85 ± 1.0% | 67.14 ± 5.5% | not timed | not timed | 7.12 ± 3.1% | | 0.99 | 1.21 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.23 ± 16.3% | not timed | not timed | 0.12 ± 1.9% | 68.02 ± 8.7% | not timed | not timed | 1.24 ± 28.5% | | 0.99 | 9.92 | 0.0180 |
| unicode/compile/fifty-letters-ascii | 1 | 199.06 ± 10.2% | not timed | not timed | 68.56 ± 0.4% | 225.49 ± 16.2% | not timed | not timed | 206.78 ± 11.7% | | 0.96 | 2.90 | 0.88 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 439.77 ± 3.2% | not timed | not timed | 50.96 ± 0.8% | 754.96 ± 11.8% | not timed | not timed | 449.20 ± 6.4% | | 0.98 | 8.63 | 0.58 |
| unicode/compile/match-every-line-ascii | 4 | 690.02 ± 11.1% | not timed | not timed | 166.81 ± 1.1% | 747.93 ± 8.9% | not timed | not timed | 702.80 ± 2.4% | | 0.98 | 4.14 | 0.92 |
| unicode/compile/negated-class-matches-codepoint | 1 | 367.70 ± 3.3% | not timed | not timed | 56.25 ± 0.4% | 1428.48 ± 12.0% | not timed | not timed | 370.69 ± 2.7% | | 0.99 | 6.54 | 0.26 |
| wild/bibleref/compile | 3 | 6.21 ± 2.0% | not timed | not timed | 2.43 ± 0.6% | 34.89 ± 3.6% | not timed | not timed | 6.28 ± 4.2% | | 0.99 | 2.56 | 0.18 |
| wild/url/compile | 1 | 0.73 ± 1.0% | not timed | not timed | 0.20 ± 0.4% | 0.47 ± 28.9% | not timed | not timed | 0.73 ± 9.1% | | 1.00 | 3.64 | 1.54 |

