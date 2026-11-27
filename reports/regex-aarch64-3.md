# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261122.195.1 |
| CPU model | Neoverse-N2 |
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
| literal: a word | 217 | 19204.26 ± 1.7% | 10731.74 ± 1.1% | 28.20 ± 0.3% | 17457.16 ± 4.1% | 9012.04 ± 8.1% | 17.57 ± 0.3% | 86.48 ± 0.4% | 18968.44 ± 2.4% | 1.79 | 1.01 | 1.10 | 2.13 |
| literal: a word that is not there | 0 | 20901.19 ± 1.6% | 9782.30 ± 0.6% | 28.31 ± 0.4% | 18870.33 ± 3.5% | 26890.25 ± 3.8% | 17.34 ± 0.2% | 80.67 ± 0.4% | 20760.68 ± 3.2% | 2.14 | 1.01 | 1.11 | 0.78 |
| literal: one of four words | 661 | 6433.14 ± 2.4% | 1788.05 ± 1.2% | 14.39 ± 0.1% | 3940.51 ± 0.2% | 21.90 ± 0.1% | 5.27 ± 0.1% | 6.93 ± 0.3% | 6432.24 ± 0.5% | 3.60 | 1.00 | 1.63 | 293.79 |
| literal: a word in any case | 217 | 14909.22 ± 0.9% | 1913.06 ± 0.3% | 21.47 ± 0.4% | 3957.16 ± 0.2% | 38.03 ± 0.4% | refused | differs | 14949.15 ± 0.9% | 7.79 | 1.00 | 3.77 | 392.03 |
| literal: an href attribute | 33 | 16609.84 ± 2.6% | 608.14 ± 0.6% | 27.26 ± 0.2% | 16682.66 ± 1.0% | 2252.25 ± 0.4% | 13.35 ± 3.3% | 75.10 ± 0.5% | 16630.82 ± 2.2% | 27.31 | 1.00 | 1.00 | 7.37 |
| literal: a word, second text | 123 | 19909.13 ± 3.9% | 4582.18 ± 0.4% | 27.92 ± 0.2% | 18087.38 ± 2.0% | 7650.02 ± 5.6% | 19.80 ± 0.7% | 70.57 ± 0.4% | 20036.88 ± 3.5% | 4.34 | 0.99 | 1.10 | 2.60 |
| class: two capitalized words | 1331 | 1176.40 ± 0.5% | 598.51 ± 0.3% | 25.96 ± 0.2% | 584.11 ± 0.1% | 40.71 ± 8.9% | 14.93 ± 0.6% | 67.79 ± 0.5% | 1177.40 ± 0.6% | 1.97 | 1.00 | 2.01 | 28.90 |
| class: a word that ends in ing | 3399 | 574.82 ± 0.2% | 545.95 ± 0.8% | 17.86 ± 0.3% | 547.62 ± 0.1% | 29.65 ± 6.5% | 8.19 ± 0.2% | 18.40 ± 0.4% | 575.25 ± 0.2% | 1.05 | 1.00 | 1.05 | 19.38 |
| class: a word in capitals | 2332 | 1537.01 ± 0.4% | 608.82 ± 0.8% | 27.53 ± 0.1% | 572.81 ± 0.1% | 43.46 ± 6.6% | 17.23 ± 0.2% | 83.31 ± 0.2% | 1534.21 ± 0.1% | 2.52 | 1.00 | 2.68 | 35.36 |
| class: a number | 8288 | 2672.39 ± 0.5% | 840.38 ± 0.2% | 27.56 ± 0.4% | 1707.11 ± 0.5% | 42.40 ± 16.7% | 0.56 ± 0.6% | 57.27 ± 0.3% | 2668.26 ± 0.4% | 3.18 | 1.00 | 1.57 | 63.02 |
| class: two capitalized words, second text | 5359 | 521.49 ± 0.2% | 528.18 ± 0.4% | 23.20 ± 0.2% | 483.73 ± 0.2% | 35.21 ± 12.1% | 16.71 ± 0.3% | 63.23 ± 0.3% | 521.96 ± 0.3% | 0.99 | 1.00 | 1.08 | 14.81 |
| other: a word between two words | 6104 | 810.14 ± 0.2% | 602.24 ± 0.3% | 23.44 ± 0.1% | 736.35 ± 0.2% | 108.74 ± 17.6% | 11.38 ± 0.2% | 69.09 ± 0.7% | 811.49 ± 0.2% | 1.35 | 1.00 | 1.10 | 7.45 |
| other: a number before a unit, second text | 1481 | 6289.08 ± 1.9% | 1143.29 ± 0.3% | 25.90 ± 0.3% | 5628.02 ± 0.8% | 40.90 ± 0.2% | 17.80 ± 0.2% | 65.62 ± 0.2% | 6257.29 ± 1.7% | 5.50 | 1.01 | 1.12 | 153.78 |
| other: a heading's start tag | 110 | 14040.94 ± 1.4% | 740.50 ± 0.1% | 27.25 ± 0.2% | 1705.17 ± 0.9% | 1583.71 ± 3.8% | 16.38 ± 0.6% | 87.92 ± 0.2% | 14024.01 ± 0.6% | 18.96 | 1.00 | 8.23 | 8.87 |
| other: a whole word | 217 | 16071.66 ± 2.2% | 600.86 ± 0.7% | 28.49 ± 0.3% | 14216.41 ± 0.7% | 49.40 ± 0.4% | 13.83 ± 0.3% | 55.07 ± 0.5% | 16080.41 ± 1.1% | 26.75 | 1.00 | 1.13 | 325.32 |
| other: a line's first word, second text | 3716 | 2102.45 ± 0.4% | 592.44 ± 0.2% | 30.74 ± 0.3% | 1728.30 ± 0.4% | 62.33 ± 9.3% | refused | refused | 2070.81 ± 0.8% | 3.55 | 1.02 | 1.22 | 33.73 |
| other: fourteen octets before an x | 87 | 23574.91 ± 1.9% | 236.96 ± 0.3% | 6.47 ± 0.1% | 3975.61 ± 1.3% | 10.64 ± 0.1% | differs | 17.89 ± 0.2% | 23462.44 ± 8.5% | 99.49 | 1.00 | 5.93 | 2215.16 |
| other: a Greek word | 21815 | 528.28 ± 0.7% | 423.88 ± 0.3% | 30.39 ± 0.2% | 289.92 ± 0.4% | 47.71 ± 10.4% | differs | refused | 530.84 ± 0.8% | 1.25 | 1.00 | 1.82 | 11.07 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.67 ± 0.1% | 29.66 ± 0.2% | 0.85 ± 0.2% | 19.54 ± 0.3% | 2.73 ± 0.4% | differs | 4.05 ± 0.1% | 29.56 ± 0.2% | 1.00 | 1.00 | 1.52 | 10.88 |
| a UUID | 32895 | 24.75 ± 0.3% | 24.79 ± 0.3% | 0.64 ± 0.1% | 15.17 ± 0.7% | 2.97 ± 0.7% | 0.72 ± 0.4% | 3.60 ± 0.8% | 24.85 ± 0.1% | 1.00 | 1.00 | 1.63 | 8.33 |
| an IPv4 address | 33176 | 38.77 ± 0.3% | 38.71 ± 0.3% | 2.07 ± 0.3% | 28.99 ± 0.4% | 6.62 ± 0.2% | differs | 4.21 ± 0.2% | 38.63 ± 0.3% | 1.00 | 1.00 | 1.34 | 5.86 |
| a date and time | 32954 | 34.15 ± 0.1% | 34.25 ± 0.2% | 1.44 ± 0.5% | 20.86 ± 0.7% | 7.05 ± 0.1% | 1.19 ± 0.1% | 7.09 ± 0.2% | 34.27 ± 0.1% | 1.00 | 1.00 | 1.64 | 4.84 |
| a field path | 32606 | 32.76 ± 0.3% | 32.83 ± 0.3% | 1.01 ± 0.1% | 23.05 ± 1.0% | 3.45 ± 0.4% | differs | 2.95 ± 0.3% | 32.73 ± 0.3% | 1.00 | 1.00 | 1.42 | 9.50 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.19 ± 0.3% | 11.14 ± 0.5% | 11.18 ± 0.4% | 11.47 ± 0.2% | 4.92 ± 3.2% | 0.91 ± 0.6% | none | 11.21 ± 0.5% | 1.00 | 1.00 | 0.98 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.46 ± 0.3% | 222.41 ± 0.4% | 261.78 ± 0.1% | 88.63 ± 4.4% | 218.14 ± 10.6% | 471.68 ± 2.3% | 3727.18 ± 0.4% | 222.56 ± 0.4% | 1.00 | 1.00 | 2.51 | 1.02 |
| a UUID | 62 | 147.53 ± 0.3% | 147.85 ± 0.3% | 164.13 ± 0.2% | 46.63 ± 0.3% | 96.28 ± 5.4% | 181.76 ± 2.0% | 4358.67 ± 0.3% | 147.83 ± 0.2% | 1.00 | 1.00 | 3.16 | 1.53 |
| an IPv4 address | 29 | 415.04 ± 0.5% | 415.52 ± 0.2% | 575.96 ± 0.5% | 77.66 ± 0.4% | 128.65 ± 23.1% | 298.48 ± 1.4% | 7541.48 ± 0.4% | 415.85 ± 0.3% | 1.00 | 1.00 | 5.34 | 3.23 |
| a date and time | 56 | 302.14 ± 0.3% | 301.61 ± 0.2% | 377.85 ± 0.1% | 73.22 ± 0.4% | 134.72 ± 1.1% | 326.16 ± 0.8% | 4932.91 ± 0.2% | 302.26 ± 0.3% | 1.00 | 1.00 | 4.13 | 2.24 |
| a field path | 39 | 216.61 ± 0.1% | 216.33 ± 0.4% | 252.69 ± 0.6% | 81.25 ± 1.5% | 201.92 ± 0.8% | 498.38 ± 1.6% | 4726.11 ± 0.2% | 216.63 ± 0.2% | 1.00 | 1.00 | 2.67 | 1.07 |
| literal: a word | 7 | 598.34 ± 0.6% | 641.94 ± 0.4% | 1107.96 ± 0.1% | 511.32 ± 0.2% | 617.63 ± 3.0% | 971.33 ± 0.7% | 29592.67 ± 0.0% | 598.95 ± 0.3% | 0.93 | 1.00 | 1.17 | 0.97 |
| literal: a word that is not there | 8 | 580.17 ± 0.3% | 627.40 ± 0.4% | 1070.46 ± 0.6% | 462.64 ± 0.5% | 596.33 ± 1.5% | 920.61 ± 0.4% | 28641.95 ± 0.2% | 580.72 ± 0.5% | 0.92 | 1.00 | 1.25 | 0.97 |
| literal: one of four words | 26 | 244.81 ± 0.9% | 387.24 ± 0.6% | 526.34 ± 0.5% | 49.74 ± 1.0% | 240.34 ± 1.2% | 373.66 ± 0.4% | 15553.23 ± 0.8% | 244.77 ± 0.2% | 0.63 | 1.00 | 4.92 | 1.02 |
| literal: a word in any case | 11 | 436.55 ± 0.5% | 465.06 ± 0.8% | 675.13 ± 0.5% | 15.75 ± 0.3% | 639.24 ± 1.0% | refused | 23399.65 ± 0.7% | 436.75 ± 0.4% | 0.94 | 1.00 | 27.72 | 0.68 |
| literal: an href attribute | 12 | 338.94 ± 0.1% | 350.92 ± 0.2% | 458.87 ± 0.3% | 45.46 ± 1.3% | 492.12 ± 1.5% | 794.37 ± 0.4% | 21575.56 ± 0.3% | 339.29 ± 0.2% | 0.97 | 1.00 | 7.46 | 0.69 |
| literal: a word, second text | 10 | 532.18 ± 0.3% | 582.75 ± 0.3% | 952.73 ± 0.2% | 423.64 ± 0.3% | 528.20 ± 2.2% | 822.65 ± 0.2% | 26605.31 ± 0.5% | 531.74 ± 0.1% | 0.91 | 1.00 | 1.26 | 1.01 |
| class: two capitalized words | 23 | 429.06 ± 0.4% | 455.32 ± 0.3% | 652.97 ± 0.4% | 103.86 ± 1.2% | 494.61 ± 1.9% | 775.57 ± 1.0% | 6277.14 ± 0.2% | 429.33 ± 0.5% | 0.94 | 1.00 | 4.13 | 0.87 |
| class: a word that ends in ing | 9 | 544.79 ± 0.3% | 608.94 ± 0.4% | 1042.51 ± 0.1% | 134.70 ± 0.4% | 751.08 ± 1.1% | 1115.94 ± 0.3% | 15654.01 ± 0.1% | 545.77 ± 0.4% | 0.89 | 1.00 | 4.04 | 0.73 |
| class: a word in capitals | 16 | 488.89 ± 0.2% | 523.73 ± 0.3% | 823.14 ± 0.1% | 138.58 ± 1.3% | 747.59 ± 1.8% | 1038.25 ± 0.9% | 8240.56 ± 0.2% | 489.02 ± 0.4% | 0.93 | 1.00 | 3.53 | 0.65 |
| class: a number | 6 | 621.47 ± 0.4% | 679.47 ± 0.5% | 1252.79 ± 0.2% | 42.03 ± 0.1% | 1389.29 ± 1.3% | 1866.82 ± 1.6% | 22267.52 ± 0.0% | 621.20 ± 0.3% | 0.91 | 1.00 | 14.79 | 0.45 |
| class: two capitalized words, second text | 23 | 429.30 ± 0.5% | 455.51 ± 0.5% | 652.94 ± 0.6% | 102.53 ± 1.3% | 495.38 ± 1.0% | 765.29 ± 0.5% | 6278.00 ± 0.2% | 428.96 ± 0.4% | 0.94 | 1.00 | 4.19 | 0.87 |
| other: a word between two words | 13 | 527.01 ± 0.3% | 546.58 ± 0.3% | 860.77 ± 0.1% | 136.23 ± 0.8% | 497.56 ± 0.6% | 815.86 ± 1.0% | 14478.86 ± 0.1% | 527.25 ± 0.2% | 0.96 | 1.00 | 3.87 | 1.06 |
| other: a number before a unit, second text | 15 | 383.42 ± 0.4% | 420.91 ± 0.6% | 583.14 ± 0.1% | 39.68 ± 0.8% | 629.39 ± 0.7% | 885.35 ± 0.5% | 15050.21 ± 0.1% | 383.84 ± 0.1% | 0.91 | 1.00 | 9.66 | 0.61 |
| other: a heading's start tag | 13 | 350.04 ± 0.3% | 355.80 ± 0.4% | 466.66 ± 0.2% | 43.51 ± 0.3% | 622.08 ± 0.8% | 870.90 ± 0.3% | 17775.97 ± 0.3% | 350.17 ± 0.2% | 0.98 | 1.00 | 8.05 | 0.56 |
| other: a whole word | 11 | 550.63 ± 1.1% | 589.88 ± 0.8% | 965.91 ± 1.6% | 120.16 ± 0.5% | 565.63 ± 1.6% | 830.08 ± 1.1% | 26649.30 ± 0.1% | 553.52 ± 1.3% | 0.93 | 0.99 | 4.58 | 0.97 |
| other: a line's first word, second text | 17 | 506.16 ± 0.5% | 541.44 ± 0.6% | 855.84 ± 0.2% | 130.16 ± 0.2% | 702.35 ± 0.7% | refused | refused | 508.02 ± 0.6% | 0.93 | 1.00 | 3.89 | 0.72 |
| other: fourteen octets before an x | 16 | 108.66 ± 0.6% | 156.66 ± 0.4% | 179.16 ± 0.4% | 15.25 ± 0.4% | 447.82 ± 2.0% | 408.23 ± 0.8% | 12717.76 ± 0.3% | 109.06 ± 0.4% | 0.69 | 1.00 | 7.12 | 0.24 |
| other: a Greek word | 8 | 449.00 ± 0.4% | 589.19 ± 0.5% | 983.65 ± 0.5% | 58.37 ± 0.4% | 1383.41 ± 1.1% | 1809.31 ± 0.4% | refused | 449.53 ± 0.3% | 0.76 | 1.00 | 7.69 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15193.00 ± 1.6% | not timed | not timed | 15852.39 ± 1.9% | 1956.57 ± 15.9% | not timed | not timed | 15242.23 ± 0.9% | | 1.00 | 0.96 | 7.77 |
| 01-literal/sherlock-casei-en | 522 | 10962.11 ± 5.1% | not timed | not timed | 3588.47 ± 0.1% | 32.51 ± 0.1% | not timed | not timed | 10992.10 ± 1.3% | | 1.00 | 3.05 | 337.21 |
| 01-literal/sherlock-ru | 724 | 17101.61 ± 1.0% | not timed | not timed | 17226.21 ± 1.2% | 1518.22 ± 14.0% | not timed | not timed | 17126.36 ± 0.6% | | 1.00 | 0.99 | 11.26 |
| 01-literal/sherlock-casei-ru | 746 | 6131.52 ± 0.5% | not timed | not timed | 3333.32 ± 0.1% | 31.66 ± 1.1% | not timed | not timed | 6126.68 ± 0.3% | | 1.00 | 1.84 | 193.66 |
| 01-literal/sherlock-zh | 30 | 19134.89 ± 1.1% | not timed | not timed | 18117.62 ± 1.3% | 2837.38 ± 7.0% | not timed | not timed | 19174.79 ± 0.9% | | 1.00 | 1.06 | 6.74 |
| 02-literal-alternate/sherlock-en | 714 | 6142.28 ± 0.6% | not timed | not timed | 3939.75 ± 0.2% | 16.65 ± 0.1% | not timed | not timed | 6121.34 ± 0.6% | | 1.00 | 1.56 | 368.89 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1969.92 ± 1.2% | not timed | not timed | 698.67 ± 0.2% | 11.05 ± 0.2% | not timed | not timed | 1971.83 ± 1.0% | | 1.00 | 2.82 | 178.25 |
| 02-literal-alternate/sherlock-ru | 899 | 5498.71 ± 1.6% | not timed | not timed | 3249.68 ± 2.4% | 22.68 ± 0.1% | not timed | not timed | 5502.67 ± 13.5% | | 1.00 | 1.69 | 242.47 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2046.38 ± 0.6% | not timed | not timed | 1227.23 ± 0.9% | 9.14 ± 2.0% | not timed | not timed | 2048.18 ± 0.5% | | 1.00 | 1.67 | 223.99 |
| 02-literal-alternate/sherlock-zh | 207 | 7335.63 ± 0.8% | not timed | not timed | 4150.61 ± 0.3% | 31.53 ± 0.0% | not timed | not timed | 7313.01 ± 0.7% | | 1.00 | 1.77 | 232.69 |
| 03-date/ascii | 111817 | 134.13 ± 0.7% | not timed | not timed | 96.21 ± 0.2% | 0.20 ± 3.7% | not timed | not timed | 135.01 ± 0.7% | | 0.99 | 1.39 | 662.30 |
| 04-ruff-noqa/real | 84 | 439.21 ± 0.2% | not timed | not timed | 464.85 ± 0.3% | 19.67 ± 1.2% | not timed | not timed | 437.71 ± 0.1% | | 1.00 | 0.94 | 22.33 |
| 04-ruff-noqa/tweaked | 44 | 846.89 ± 0.1% | not timed | not timed | 461.04 ± 0.1% | 364.06 ± 0.4% | not timed | not timed | 847.22 ± 0.1% | | 1.00 | 1.84 | 2.33 |
| 05-lexer-veryl/single | 124800 | 5.35 ± 3.5% | not timed | not timed | 4.99 ± 0.1% | 0.21 ± 2.6% | not timed | not timed | 5.34 ± 0.4% | | 1.00 | 1.07 | 25.96 |
| 06-cloud-flare-redos/original | 107 | 440.81 ± 0.2% | not timed | not timed | 217.37 ± 0.1% | 24.92 ± 0.4% | not timed | not timed | 440.78 ± 0.2% | | 1.00 | 2.03 | 17.69 |
| 06-cloud-flare-redos/simplified-short | 102 | 437.98 ± 0.1% | not timed | not timed | 230.12 ± 0.1% | 26.66 ± 0.1% | not timed | not timed | 437.58 ± 0.2% | | 1.00 | 1.90 | 16.43 |
| 06-cloud-flare-redos/simplified-long | 10000 | 628.81 ± 0.1% | not timed | not timed | 253.93 ± 0.2% | 28.82 ± 0.1% | not timed | not timed | 629.40 ± 0.5% | | 1.00 | 2.48 | 21.82 |
| 07-unicode-character-data/parse-line | 558784 | 239.94 ± 2.2% | not timed | not timed | 170.97 ± 0.1% | 41.96 ± 6.8% | not timed | not timed | 240.97 ± 2.0% | | 1.00 | 1.40 | 5.72 |
| 08-words/all-english | 56691 | 129.20 ± 0.7% | not timed | not timed | 83.37 ± 0.2% | 11.76 ± 4.6% | not timed | not timed | 129.60 ± 0.4% | | 1.00 | 1.55 | 10.99 |
| 08-words/long-english | 839 | 616.65 ± 0.1% | not timed | not timed | 595.34 ± 0.1% | 32.60 ± 1.2% | not timed | not timed | 616.95 ± 0.2% | | 1.00 | 1.04 | 18.92 |
| 09-aws-keys/full | 0 | 443.15 ± 0.2% | not timed | not timed | 465.54 ± 0.1% | 64.48 ± 3.5% | not timed | not timed | 443.42 ± 0.2% | | 1.00 | 0.95 | 6.87 |
| 09-aws-keys/quick | 0 | 875.76 ± 0.3% | not timed | not timed | 988.44 ± 0.3% | 417.67 ± 0.8% | not timed | not timed | 876.53 ± 0.2% | | 1.00 | 0.89 | 2.10 |
| 10-bounded-repeat/letters-en | 1833 | 580.00 ± 2.3% | not timed | not timed | 518.11 ± 0.1% | 19.60 ± 0.7% | not timed | not timed | 583.08 ± 2.2% | | 0.99 | 1.12 | 29.59 |
| 10-bounded-repeat/letters-ru | 3475 | 509.71 ± 1.5% | not timed | not timed | 478.23 ± 0.1% | 21.76 ± 18.7% | not timed | not timed | 505.22 ± 1.3% | | 1.01 | 1.07 | 23.43 |
| 10-bounded-repeat/context | 53 | 84.72 ± 1.7% | not timed | not timed | 65.57 ± 0.6% | 19.79 ± 0.2% | not timed | not timed | 85.10 ± 2.0% | | 1.00 | 1.29 | 4.28 |
| 10-bounded-repeat/capitals | 11 | 635.94 ± 8.3% | not timed | not timed | 618.32 ± 0.1% | 36.65 ± 0.1% | not timed | not timed | 637.67 ± 8.1% | | 1.00 | 1.03 | 17.35 |
| 11-unstructured-to-json/extract | 600 | 57.79 ± 0.4% | not timed | not timed | 77.63 ± 0.3% | 49.02 ± 0.2% | not timed | not timed | 57.86 ± 0.6% | | 1.00 | 0.74 | 1.18 |
| 12-dictionary/single | 1 | 560.76 ± 1.7% | not timed | not timed | 562.29 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 561.31 ± 1.7% | | 1.00 | 1.00 | 1397.51 |
| 14-quadratic/1x | 100 | 22.06 ± 1.2% | not timed | not timed | 10.02 ± 0.3% | 0.98 ± 2.5% | not timed | not timed | 22.08 ± 1.2% | | 1.00 | 2.20 | 22.55 |
| 14-quadratic/2x | 200 | 19.65 ± 0.7% | not timed | not timed | 5.55 ± 0.3% | 0.53 ± 1.7% | not timed | not timed | 19.78 ± 0.4% | | 0.99 | 3.54 | 37.09 |
| 14-quadratic/10x | 1000 | 12.31 ± 0.8% | not timed | not timed | 1.21 ± 0.1% | 0.11 ± 2.1% | not timed | not timed | 12.32 ± 1.3% | | 1.00 | 10.14 | 107.20 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 2.3% | not timed | not timed | 0.34 ± 0.4% | 0.55 ± 2.4% | not timed | not timed | 1.28 ± 0.4% | | 0.99 | 3.73 | 2.33 |
| 04-ruff-noqa/compile-real | 1 | 107.15 ± 1.1% | not timed | not timed | 13.71 ± 0.5% | 136.35 ± 3.4% | not timed | not timed | 107.38 ± 1.3% | | 1.00 | 7.82 | 0.79 |
| 05-lexer-veryl/compile-single | 1 | 14.18 ± 0.8% | not timed | not timed | 2.51 ± 0.9% | 6.38 ± 3.1% | not timed | not timed | 14.19 ± 1.4% | | 1.00 | 5.65 | 2.22 |
| 07-unicode-character-data/compile | 1 | 109.93 ± 1.1% | not timed | not timed | 25.55 ± 0.3% | 36.16 ± 2.1% | not timed | not timed | 110.19 ± 1.2% | | 1.00 | 4.30 | 3.04 |
| 09-aws-keys/compile-full | 1 | 53.44 ± 1.0% | not timed | not timed | 8.18 ± 0.5% | 23.14 ± 2.8% | not timed | not timed | 53.57 ± 0.5% | | 1.00 | 6.54 | 2.31 |
| 09-aws-keys/compile-quick | 1 | 189.11 ± 0.4% | not timed | not timed | 46.86 ± 0.2% | 130.62 ± 2.3% | not timed | not timed | 189.62 ± 0.5% | | 1.00 | 4.04 | 1.45 |
| 10-bounded-repeat/compile-context | 1 | 72.78 ± 1.8% | not timed | not timed | 11.14 ± 0.3% | 15.73 ± 3.7% | not timed | not timed | 72.76 ± 1.5% | | 1.00 | 6.53 | 4.63 |
| 10-bounded-repeat/compile-capitals | 1 | 85.79 ± 1.6% | not timed | not timed | 8.10 ± 0.3% | 23.28 ± 2.4% | not timed | not timed | 85.94 ± 0.8% | | 1.00 | 10.59 | 3.69 |
| 11-unstructured-to-json/compile | 1 | 175.14 ± 0.6% | not timed | not timed | 40.83 ± 0.4% | 67.03 ± 2.8% | not timed | not timed | 174.87 ± 0.6% | | 1.00 | 4.29 | 2.61 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.8% | not timed | not timed | 0.07 ± 1.6% | 0.09 ± 14.7% | not timed | not timed | 0.35 ± 0.4% | | 1.00 | 5.13 | 3.71 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.49 ± 0.3% | not timed | not timed | 6.48 ± 0.1% | 0.52 ± 27.1% | not timed | not timed | 7.45 ± 1.4% | | 1.00 | 1.16 | 14.30 |
| dictionary/search/english-10 | 690 | 201.81 ± 5.2% | not timed | not timed | 166.49 ± 0.4% | 0.00 ± 1.0% | not timed | not timed | 208.62 ± 2.4% | | 0.97 | 1.21 | 81609.14 |
| dictionary/search/english-15 | 15 | 560.44 ± 1.5% | not timed | not timed | 560.78 ± 0.1% | 0.37 ± 0.1% | not timed | not timed | 561.91 ± 1.4% | | 1.00 | 1.00 | 1526.39 |
| folly/awyer-inn-busted | 1 | 21496.39 ± 0.1% | not timed | not timed | 142.31 ± 0.1% | 43.87 ± 0.1% | not timed | not timed | 21572.24 ± 0.1% | | 1.00 | 151.06 | 489.99 |
| folly/literal-never-match-rare | 0 | 21003.95 ± 0.5% | not timed | not timed | 19771.93 ± 0.9% | 40637.52 ± 1.7% | not timed | not timed | 21060.07 ± 4.8% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12514.58 ± 5.3% | not timed | not timed | 19775.74 ± 0.5% | 2186.11 ± 1.1% | not timed | not timed | 12525.00 ± 5.7% | | 1.00 | 0.63 | 5.72 |
| folly/literal-never-match-tricksy | 1 | 3252.79 ± 0.5% | not timed | not timed | 4411.32 ± 0.1% | 3040.24 ± 0.4% | not timed | not timed | 3259.41 ± 0.3% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1304.05 ± 0.5% | not timed | not timed | 952.25 ± 0.2% | 383.66 ± 19.7% | not timed | not timed | 1310.32 ± 0.6% | | 1.00 | 1.37 | 3.40 |
| grep/long-words-ascii | 5073 | 460.09 ± 0.1% | not timed | not timed | 468.28 ± 0.4% | 46.03 ± 8.4% | not timed | not timed | 458.90 ± 0.5% | | 1.00 | 0.98 | 10.00 |
| imported/leipzig/twain | 811 | 20568.34 ± 2.6% | not timed | not timed | 19412.87 ± 0.4% | 11903.34 ± 9.6% | not timed | not timed | 20573.05 ± 0.1% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9092.90 ± 1.5% | not timed | not timed | 4244.67 ± 0.2% | 37.73 ± 0.2% | not timed | not timed | 9135.63 ± 1.0% | | 1.00 | 2.14 | 240.97 |
| imported/leipzig/shing | 1540 | 15223.35 ± 1.8% | not timed | not timed | 13369.61 ± 0.4% | 34.01 ± 0.1% | not timed | not timed | 15471.35 ± 1.9% | | 0.98 | 1.14 | 447.56 |
| imported/leipzig/huck-saw | 262 | 8172.34 ± 2.4% | not timed | not timed | 5588.61 ± 0.2% | 31.74 ± 0.1% | not timed | not timed | 8367.71 ± 3.9% | | 0.98 | 1.46 | 257.51 |
| imported/leipzig/word-ending-nn | 262 | 604.09 ± 1.4% | not timed | not timed | 617.63 ± 0.1% | 24.84 ± 0.6% | not timed | not timed | 605.01 ± 0.8% | | 1.00 | 0.98 | 24.32 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11184.30 ± 1.0% | not timed | not timed | 4452.03 ± 0.4% | 11.50 ± 0.1% | not timed | not timed | 10712.70 ± 1.8% | | 1.04 | 2.51 | 972.53 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7806.82 ± 1.6% | not timed | not timed | 5483.40 ± 0.4% | 16.90 ± 0.0% | not timed | not timed | 7824.06 ± 2.2% | | 1.00 | 1.42 | 462.05 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4168.78 ± 2.0% | not timed | not timed | 425.81 ± 0.2% | 11.09 ± 0.2% | not timed | not timed | 4170.03 ± 1.0% | | 1.00 | 9.79 | 375.90 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7309.16 ± 3.0% | not timed | not timed | 614.79 ± 0.1% | 11.14 ± 0.0% | not timed | not timed | 7264.89 ± 17.6% | | 1.01 | 11.89 | 655.87 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7180.03 ± 23.7% | not timed | not timed | 615.18 ± 0.2% | 9.72 ± 0.1% | not timed | not timed | 7141.20 ± 2.1% | | 1.01 | 11.67 | 738.41 |
| imported/leipzig/tom-river | 2 | 6454.12 ± 2.2% | not timed | not timed | 5135.75 ± 0.5% | 30.91 ± 0.2% | not timed | not timed | 6562.72 ± 1.9% | | 0.98 | 1.26 | 208.80 |
| imported/leipzig/ing | 78424 | 603.07 ± 0.7% | not timed | not timed | 571.60 ± 0.1% | 28.12 ± 3.3% | not timed | not timed | 602.54 ± 0.6% | | 1.00 | 1.06 | 21.45 |
| imported/leipzig/ing-whitespace | 55248 | 1907.58 ± 1.3% | not timed | not timed | 2080.79 ± 0.9% | 20.59 ± 2.9% | not timed | not timed | 1929.14 ± 0.6% | | 0.99 | 0.92 | 92.65 |
| imported/leipzig/awyer-inn | 209 | 6365.59 ± 1.3% | not timed | not timed | 4281.15 ± 0.3% | 22.29 ± 0.1% | not timed | not timed | 6405.09 ± 1.0% | | 0.99 | 1.49 | 285.61 |
| imported/leipzig/quotes-bounded | 8886 | 2484.26 ± 0.9% | not timed | not timed | 2903.77 ± 0.2% | 38.19 ± 0.1% | not timed | not timed | 2494.06 ± 1.0% | | 1.00 | 0.86 | 65.05 |
| imported/leipzig/non-ascii-alternate | 2 | 12842.56 ± 1.7% | not timed | not timed | 5665.76 ± 0.2% | 50.62 ± 0.1% | not timed | not timed | 13039.42 ± 2.2% | | 0.98 | 2.27 | 253.72 |
| imported/leipzig/math-symbols | 69 | 1980.49 ± 0.3% | not timed | not timed | 618.60 ± 0.0% | 36.52 ± 0.3% | not timed | not timed | 1979.02 ± 0.5% | | 1.00 | 3.20 | 54.22 |
| imported/leipzig/bounded-strings-ending-z | 0 | 632.97 ± 2.2% | not timed | not timed | 614.93 ± 0.3% | 22.48 ± 0.2% | not timed | not timed | 630.19 ± 1.4% | | 1.00 | 1.03 | 28.16 |
| imported/lh3lh3-reb/uri | 17549 | 678.88 ± 0.1% | not timed | not timed | 1066.10 ± 0.4% | 28.31 ± 2.3% | not timed | not timed | 680.31 ± 0.1% | | 1.00 | 0.64 | 23.98 |
| imported/lh3lh3-reb/email | 15057 | 675.11 ± 0.1% | not timed | not timed | 1154.85 ± 0.1% | 30.76 ± 2.4% | not timed | not timed | 677.27 ± 0.1% | | 1.00 | 0.58 | 21.95 |
| imported/lh3lh3-reb/date | 668 | 892.44 ± 0.2% | not timed | not timed | 1029.67 ± 0.3% | 50.89 ± 3.8% | not timed | not timed | 893.72 ± 0.2% | | 1.00 | 0.87 | 17.54 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 644.69 ± 0.2% | not timed | not timed | 422.86 ± 0.1% | 15.68 ± 1.3% | not timed | not timed | 647.01 ± 0.1% | | 1.00 | 1.52 | 41.12 |
| imported/mariomka/email | 92 | 24172.09 ± 0.9% | not timed | not timed | 29202.73 ± 3.5% | 32.59 ± 0.2% | not timed | not timed | 24350.30 ± 1.0% | | 0.99 | 0.83 | 741.70 |
| imported/mariomka/uri | 5301 | 5520.22 ± 0.8% | not timed | not timed | 6112.21 ± 0.3% | 32.57 ± 0.3% | not timed | not timed | 5567.38 ± 2.4% | | 0.99 | 0.90 | 169.50 |
| imported/mariomka/ip | 5 | 2589.18 ± 3.2% | not timed | not timed | 2964.12 ± 0.2% | 20.88 ± 0.1% | not timed | not timed | 2591.73 ± 3.4% | | 1.00 | 0.87 | 123.98 |
| imported/rsc/no-exponential | 0 | 610.90 ± 0.2% | not timed | not timed | 317.58 ± 0.1% | 23.76 ± 0.2% | not timed | not timed | 608.98 ± 0.0% | | 1.00 | 1.92 | 25.71 |
| imported/rsc/literal | 1 | 1493.75 ± 2.2% | not timed | not timed | 1610.81 ± 4.2% | 187.74 ± 36.4% | not timed | not timed | 1499.84 ± 6.4% | | 1.00 | 0.93 | 7.96 |
| imported/rsc/not-literal | 2 | 776.75 ± 0.4% | not timed | not timed | 740.06 ± 0.2% | 46.30 ± 7.2% | not timed | not timed | 776.78 ± 4.5% | | 1.00 | 1.05 | 16.78 |
| imported/rsc/match-class | 1 | 1474.51 ± 0.3% | not timed | not timed | 1607.12 ± 0.3% | 58.90 ± 13.4% | not timed | not timed | 1471.45 ± 2.9% | | 1.00 | 0.92 | 25.04 |
| imported/rsc/match-class-in-range | 1 | 1472.44 ± 0.3% | not timed | not timed | 2310.03 ± 1.9% | 60.11 ± 6.9% | not timed | not timed | 1475.61 ± 2.7% | | 1.00 | 0.64 | 24.49 |
| imported/rsc/match-class-unicode | 1 | 540.34 ± 0.4% | not timed | not timed | 512.33 ± 0.1% | 72.31 ± 0.4% | not timed | not timed | 541.51 ± 0.2% | | 1.00 | 1.05 | 7.47 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1457.27 ± 0.1% | not timed | not timed | 952.62 ± 0.1% | 228.81 ± 0.6% | not timed | not timed | 1456.54 ± 0.1% | | 1.00 | 1.53 | 6.37 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21878.34 ± 0.2% | not timed | not timed | 13996.56 ± 0.2% | 3442.74 ± 0.5% | not timed | not timed | 21843.12 ± 0.2% | | 1.00 | 1.56 | 6.35 |
| imported/rsc/anchored-literal-short-match | 4 | 720.36 ± 4.6% | not timed | not timed | 487.56 ± 0.5% | 84.78 ± 9.8% | not timed | not timed | 723.66 ± 1.7% | | 1.00 | 1.48 | 8.50 |
| imported/rsc/anchored-literal-long-match | 4 | 10800.64 ± 1.7% | not timed | not timed | 7263.75 ± 0.1% | 1223.22 ± 10.4% | not timed | not timed | 10863.26 ± 0.6% | | 0.99 | 1.49 | 8.83 |
| imported/rsc/one-pass-short | 17 | 367.80 ± 11.3% | not timed | not timed | 216.37 ± 0.3% | 30.11 ± 10.2% | not timed | not timed | 372.06 ± 1.9% | | 0.99 | 1.70 | 12.21 |
| imported/rsc/one-pass-short-not | 17 | 268.07 ± 2.7% | not timed | not timed | 225.83 ± 0.5% | 30.13 ± 10.8% | not timed | not timed | 268.83 ± 1.5% | | 1.00 | 1.19 | 8.90 |
| imported/rsc/one-pass-long-prefix | 26 | 356.81 ± 2.6% | not timed | not timed | 283.24 ± 0.3% | 97.58 ± 17.9% | not timed | not timed | 363.23 ± 0.1% | | 0.98 | 1.26 | 3.66 |
| imported/rsc/one-pass-long-prefix-not | 26 | 358.06 ± 2.3% | not timed | not timed | 283.60 ± 0.9% | 60.47 ± 18.1% | not timed | not timed | 364.07 ± 2.3% | | 0.98 | 1.26 | 5.92 |
| imported/rsc/long-needle1 | 31 | 21936.47 ± 0.2% | not timed | not timed | 20115.63 ± 0.2% | 3.75 ± 0.1% | not timed | not timed | 21950.05 ± 0.2% | | 1.00 | 1.09 | 5850.77 |
| imported/rsc/long-needle2 | 31 | 22098.56 ± 0.1% | not timed | not timed | 216.25 ± 0.3% | 3.75 ± 0.1% | not timed | not timed | 22105.63 ± 0.2% | | 1.00 | 102.19 | 5891.17 |
| imported/rsc/easy0-32 | 26 | 1539.53 ± 2.4% | not timed | not timed | 1606.08 ± 2.9% | 148.20 ± 18.5% | not timed | not timed | 1539.74 ± 0.1% | | 1.00 | 0.96 | 10.39 |
| imported/rsc/easy0-1k | 26 | 13475.83 ± 1.9% | not timed | not timed | 12689.19 ± 1.3% | 2317.71 ± 13.3% | not timed | not timed | 13555.18 ± 0.4% | | 0.99 | 1.06 | 5.81 |
| imported/rsc/easy0-32k | 26 | 22789.43 ± 0.3% | not timed | not timed | 20305.92 ± 0.1% | 18668.27 ± 0.1% | not timed | not timed | 22822.90 ± 0.1% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21152.96 ± 3.8% | not timed | not timed | 19407.44 ± 4.4% | 34939.97 ± 6.9% | not timed | not timed | 20934.42 ± 10.7% | | 1.01 | 1.09 | 0.61 |
| imported/rsc/easy1-32 | 19 | 771.89 ± 2.2% | not timed | not timed | 638.84 ± 0.5% | 129.55 ± 16.3% | not timed | not timed | 769.38 ± 2.3% | | 1.00 | 1.21 | 5.96 |
| imported/rsc/easy1-1k | 19 | 15804.16 ± 8.0% | not timed | not timed | 12959.60 ± 0.1% | 2467.05 ± 17.1% | not timed | not timed | 15740.07 ± 2.1% | | 1.00 | 1.22 | 6.41 |
| imported/rsc/easy1-32k | 19 | 494929.25 ± 1.9% | not timed | not timed | 406051.92 ± 0.4% | 20243.15 ± 31.5% | not timed | not timed | 492720.60 ± 0.3% | | 1.00 | 1.22 | 24.45 |
| imported/rsc/easy1-1mb | 19 | 15944036.87 ± 0.1% | not timed | not timed | 13239912.70 ± 0.2% | 36603.26 ± 2.1% | not timed | not timed | 15860422.55 ± 0.2% | | 1.01 | 1.20 | 435.59 |
| imported/rsc/medium-32 | 27 | 732.63 ± 2.0% | not timed | not timed | 642.24 ± 0.8% | 69.65 ± 11.1% | not timed | not timed | 736.96 ± 0.3% | | 0.99 | 1.14 | 10.52 |
| imported/rsc/medium-1k | 27 | 13079.35 ± 0.2% | not timed | not timed | 11309.66 ± 0.5% | 72.29 ± 0.1% | not timed | not timed | 13093.20 ± 0.3% | | 1.00 | 1.16 | 180.94 |
| imported/rsc/medium-32k | 27 | 408046.78 ± 0.3% | not timed | not timed | 349577.59 ± 0.1% | 48.78 ± 0.1% | not timed | not timed | 408710.05 ± 0.3% | | 1.00 | 1.17 | 8364.37 |
| imported/rsc/medium-1mb | 27 | 13064299.75 ± 0.3% | not timed | not timed | 11311489.62 ± 0.3% | 48.74 ± 0.1% | not timed | not timed | 13031216.20 ± 0.1% | | 1.00 | 1.15 | 268026.68 |
| imported/rsc/hard-32 | 58 | 423.79 ± 2.3% | not timed | not timed | 366.05 ± 0.2% | 49.34 ± 7.4% | not timed | not timed | 421.26 ± 0.2% | | 1.01 | 1.16 | 8.59 |
| imported/rsc/hard-1k | 27 | 12928.52 ± 0.1% | not timed | not timed | 11684.74 ± 0.8% | 40.60 ± 0.1% | not timed | not timed | 12826.84 ± 0.3% | | 1.01 | 1.11 | 318.46 |
| imported/rsc/hard-32k | 27 | 403597.66 ± 0.3% | not timed | not timed | 363144.87 ± 0.4% | 29.42 ± 0.1% | not timed | not timed | 400808.40 ± 0.1% | | 1.01 | 1.11 | 13718.94 |
| imported/rsc/hard-1mb | 51 | 8395454.77 ± 0.4% | not timed | not timed | 7148456.61 ± 0.0% | 29.43 ± 0.1% | not timed | not timed | 8376715.14 ± 0.1% | | 1.00 | 1.17 | 285285.81 |
| imported/rsc/reallyhard0-32 | 58 | 264.36 ± 2.5% | not timed | not timed | 223.55 ± 0.1% | 49.64 ± 8.6% | not timed | not timed | 263.98 ± 0.3% | | 1.00 | 1.18 | 5.33 |
| imported/rsc/reallyhard0-1k | 27 | 580.98 ± 0.4% | not timed | not timed | 584.06 ± 0.1% | 40.57 ± 0.2% | not timed | not timed | 581.31 ± 0.4% | | 1.00 | 0.99 | 14.32 |
| imported/rsc/reallyhard0-32k | 27 | 603.30 ± 0.3% | not timed | not timed | 618.22 ± 0.1% | 29.44 ± 0.1% | not timed | not timed | 600.63 ± 0.7% | | 1.00 | 0.98 | 20.49 |
| imported/rsc/reallyhard0-1mb | 51 | 623.26 ± 1.1% | not timed | not timed | 617.59 ± 0.2% | 29.41 ± 0.2% | not timed | not timed | 626.00 ± 0.7% | | 1.00 | 1.01 | 21.19 |
| imported/rsc/reallyreallyhard0-32 | 47 | 285.40 ± 2.0% | not timed | not timed | 196.90 ± 0.1% | 60.61 ± 14.8% | not timed | not timed | 286.56 ± 1.5% | | 1.00 | 1.45 | 4.71 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7001.25 ± 0.1% | not timed | not timed | 5926.75 ± 0.2% | 34.03 ± 2.2% | not timed | not timed | 6997.71 ± 0.1% | | 1.00 | 1.18 | 205.77 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21445.14 ± 0.4% | not timed | not timed | 19252.65 ± 0.1% | 25.00 ± 0.5% | not timed | not timed | 21441.68 ± 0.0% | | 1.00 | 1.11 | 857.75 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 20816.29 ± 2.0% | not timed | not timed | 18918.95 ± 1.8% | 24.81 ± 1.4% | not timed | not timed | 20668.95 ± 2.6% | | 1.01 | 1.10 | 839.09 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 281.55 ± 11.3% | not timed | not timed | 215.01 ± 0.2% | 60.71 ± 2.5% | not timed | not timed | 282.55 ± 1.3% | | 1.00 | 1.31 | 4.64 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5932.41 ± 0.2% | not timed | not timed | 6243.31 ± 0.1% | 34.35 ± 1.7% | not timed | not timed | 5936.36 ± 0.1% | | 1.00 | 0.95 | 172.71 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21361.37 ± 0.1% | not timed | not timed | 19241.10 ± 0.1% | 25.08 ± 0.2% | not timed | not timed | 21224.12 ± 0.1% | | 1.01 | 1.11 | 851.59 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 20947.52 ± 0.9% | not timed | not timed | 19386.84 ± 1.0% | 25.20 ± 0.8% | not timed | not timed | 20871.19 ± 0.6% | | 1.00 | 1.08 | 831.25 |
| imported/sherlock/name-sherlock | 776 | 19109.97 ± 2.2% | not timed | not timed | 18169.63 ± 0.9% | 10092.97 ± 27.7% | not timed | not timed | 19116.36 ± 1.9% | | 1.00 | 1.05 | 1.89 |
| imported/sherlock/name-holmes | 2766 | 14772.94 ± 2.1% | not timed | not timed | 15398.67 ± 0.7% | 3134.47 ± 15.3% | not timed | not timed | 15006.15 ± 2.0% | | 0.98 | 0.96 | 4.71 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19152.03 ± 1.5% | not timed | not timed | 18216.40 ± 0.4% | 8035.27 ± 19.3% | not timed | not timed | 19170.04 ± 1.7% | | 1.00 | 1.05 | 2.38 |
| imported/sherlock/name-sherlock-casei | 816 | 15537.25 ± 1.1% | not timed | not timed | 4017.41 ± 0.1% | 32.45 ± 0.7% | not timed | not timed | 15511.96 ± 0.7% | | 1.00 | 3.87 | 478.74 |
| imported/sherlock/name-holmes-casei | 2802 | 9306.48 ± 5.5% | not timed | not timed | 3319.06 ± 0.1% | 37.40 ± 1.0% | not timed | not timed | 9338.72 ± 0.8% | | 1.00 | 2.80 | 248.83 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12874.35 ± 9.5% | not timed | not timed | 3945.24 ± 0.2% | 32.46 ± 0.3% | not timed | not timed | 12865.27 ± 1.8% | | 1.00 | 3.26 | 396.58 |
| imported/sherlock/name-whitespace | 1461 | 14947.58 ± 7.5% | not timed | not timed | 14252.70 ± 0.6% | 7185.45 ± 27.2% | not timed | not timed | 14998.51 ± 6.2% | | 1.00 | 1.05 | 2.08 |
| imported/sherlock/name-alt1 | 1142 | 11562.02 ± 0.2% | not timed | not timed | 16061.62 ± 0.8% | 4113.17 ± 21.1% | not timed | not timed | 11554.08 ± 3.0% | | 1.00 | 0.72 | 2.81 |
| imported/sherlock/name-alt2 | 3542 | 8924.92 ± 0.5% | not timed | not timed | 3835.52 ± 0.0% | 31.12 ± 0.7% | not timed | not timed | 8901.92 ± 1.3% | | 1.00 | 2.33 | 286.81 |
| imported/sherlock/name-alt3 | 4507 | 5531.88 ± 0.6% | not timed | not timed | 3634.49 ± 0.2% | 9.95 ± 0.9% | not timed | not timed | 5514.56 ± 0.3% | | 1.00 | 1.52 | 556.18 |
| imported/sherlock/name-alt3-casei | 4593 | 1526.49 ± 2.1% | not timed | not timed | 284.74 ± 0.2% | 6.44 ± 0.1% | not timed | not timed | 1528.30 ± 1.6% | | 1.00 | 5.36 | 237.12 |
| imported/sherlock/name-alt4 | 3686 | 6395.06 ± 0.5% | not timed | not timed | 3786.72 ± 0.2% | 31.32 ± 0.0% | not timed | not timed | 6405.23 ± 0.1% | | 1.00 | 1.69 | 204.21 |
| imported/sherlock/name-alt4-casei | 4254 | 2806.08 ± 1.7% | not timed | not timed | 2585.28 ± 0.5% | 19.82 ± 0.2% | not timed | not timed | 2806.76 ± 1.6% | | 1.00 | 1.09 | 141.56 |
| imported/sherlock/name-alt5 | 4028 | 6394.72 ± 0.4% | not timed | not timed | 3753.31 ± 0.1% | 21.78 ± 0.2% | not timed | not timed | 6387.30 ± 0.3% | | 1.00 | 1.70 | 293.57 |
| imported/sherlock/name-alt5-casei | 4104 | 3478.37 ± 1.8% | not timed | not timed | 2227.72 ± 0.1% | 14.30 ± 0.1% | not timed | not timed | 3482.79 ± 0.7% | | 1.00 | 1.56 | 243.20 |
| imported/sherlock/no-match-uncommon | 0 | 20911.50 ± 1.0% | not timed | not timed | 19069.26 ± 2.1% | 34053.89 ± 0.5% | not timed | not timed | 20954.41 ± 0.8% | | 1.00 | 1.10 | 0.61 |
| imported/sherlock/no-match-common | 0 | 20542.33 ± 1.0% | not timed | not timed | 19047.37 ± 0.8% | 1283.16 ± 1.3% | not timed | not timed | 20523.83 ± 1.3% | | 1.00 | 1.08 | 16.01 |
| imported/sherlock/no-match-really-common | 0 | 15718.32 ± 2.3% | not timed | not timed | 18268.21 ± 1.0% | 1276.11 ± 0.6% | not timed | not timed | 15792.74 ± 1.6% | | 1.00 | 0.86 | 12.32 |
| imported/sherlock/the-lower | 21654 | 2297.44 ± 1.2% | not timed | not timed | 2346.51 ± 0.3% | 241.46 ± 16.0% | not timed | not timed | 2314.84 ± 1.5% | | 0.99 | 0.98 | 9.51 |
| imported/sherlock/the-upper | 2223 | 12477.87 ± 1.2% | not timed | not timed | 13463.54 ± 1.2% | 2729.79 ± 16.5% | not timed | not timed | 12558.08 ± 1.4% | | 0.99 | 0.93 | 4.57 |
| imported/sherlock/the-casei | 23961 | 2001.31 ± 0.5% | not timed | not timed | 1316.18 ± 0.6% | 34.86 ± 1.6% | not timed | not timed | 2001.08 ± 0.4% | | 1.00 | 1.52 | 57.41 |
| imported/sherlock/everything-greedy | 581881 | 282.55 ± 1.1% | not timed | not timed | 165.73 ± 0.1% | 28.81 ± 35.9% | not timed | not timed | 281.77 ± 0.8% | | 1.00 | 1.70 | 9.81 |
| imported/sherlock/everything-greedy-nl | 594933 | 490.93 ± 0.1% | not timed | not timed | 212.90 ± 0.2% | 32.95 ± 0.1% | not timed | not timed | 489.98 ± 0.1% | | 1.00 | 2.31 | 14.90 |
| imported/sherlock/letters | 447175 | 61.82 ± 1.0% | not timed | not timed | 32.91 ± 0.2% | 6.52 ± 31.5% | not timed | not timed | 62.00 ± 0.6% | | 1.00 | 1.88 | 9.48 |
| imported/sherlock/letters-upper | 14180 | 448.01 ± 1.4% | not timed | not timed | 371.04 ± 0.1% | 29.54 ± 21.7% | not timed | not timed | 446.19 ± 0.4% | | 1.00 | 1.21 | 15.17 |
| imported/sherlock/letters-lower | 432995 | 62.62 ± 1.2% | not timed | not timed | 33.79 ± 0.2% | 6.70 ± 41.4% | not timed | not timed | 62.91 ± 0.8% | | 1.00 | 1.85 | 9.35 |
| imported/sherlock/words | 447639 | 112.75 ± 1.5% | not timed | not timed | 82.74 ± 0.2% | 13.93 ± 4.3% | not timed | not timed | 113.47 ± 0.9% | | 0.99 | 1.36 | 8.09 |
| imported/sherlock/before-holmes | 4073 | 10148.10 ± 0.7% | not timed | not timed | 8435.49 ± 0.6% | 23.95 ± 0.7% | not timed | not timed | 10149.80 ± 0.5% | | 1.00 | 1.20 | 423.74 |
| imported/sherlock/before-after-holmes | 2593 | 9820.99 ± 0.6% | not timed | not timed | 9442.79 ± 0.2% | 23.93 ± 0.8% | not timed | not timed | 9845.33 ± 0.8% | | 1.00 | 1.04 | 410.33 |
| imported/sherlock/holmes-cochar-watson | 150 | 5182.68 ± 0.2% | not timed | not timed | 3429.02 ± 0.2% | 31.07 ± 0.1% | not timed | not timed | 5197.14 ± 0.1% | | 1.00 | 1.51 | 166.79 |
| imported/sherlock/holmes-coword-watson | 14309 | 1153.53 ± 0.2% | not timed | not timed | 1125.26 ± 0.2% | 6.77 ± 0.3% | not timed | not timed | 1153.76 ± 1.2% | | 1.00 | 1.03 | 170.49 |
| imported/sherlock/quotes | 14437 | 1571.88 ± 0.3% | not timed | not timed | 1753.20 ± 0.8% | 35.16 ± 0.3% | not timed | not timed | 1575.86 ± 0.3% | | 1.00 | 0.90 | 44.70 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 16834.11 ± 0.3% | not timed | not timed | 15614.34 ± 0.5% | 36.84 ± 0.1% | not timed | not timed | 16824.26 ± 0.4% | | 1.00 | 1.08 | 456.98 |
| imported/sherlock/word-ending-n | 35297 | 480.24 ± 1.0% | not timed | not timed | 408.69 ± 0.1% | 23.43 ± 21.8% | not timed | not timed | 480.08 ± 0.2% | | 1.00 | 1.18 | 20.50 |
| imported/sherlock/repeated-class-negation | 2130 | 14483.44 ± 0.9% | not timed | not timed | 10919.75 ± 0.6% | 11.59 ± 0.2% | not timed | not timed | 14220.41 ± 0.7% | | 1.02 | 1.33 | 1250.05 |
| imported/sherlock/ing-suffix | 20547 | 559.09 ± 0.6% | not timed | not timed | 517.63 ± 0.1% | 28.87 ± 0.1% | not timed | not timed | 558.15 ± 0.2% | | 1.00 | 1.08 | 19.37 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1671.88 ± 0.8% | not timed | not timed | 2105.01 ± 0.6% | 20.52 ± 0.3% | not timed | not timed | 1672.46 ± 0.4% | | 1.00 | 0.79 | 81.47 |
| opt/accelerate/whole-line | 239963 | 458.30 ± 0.3% | not timed | not timed | 372.08 ± 0.5% | 92.66 ± 17.7% | not timed | not timed | 457.85 ± 0.2% | | 1.00 | 1.23 | 4.95 |
| opt/accelerate/non-dna | 16745 | 433.56 ± 0.2% | not timed | not timed | 401.06 ± 0.1% | 29.48 ± 22.2% | not timed | not timed | 432.38 ± 1.6% | | 1.00 | 1.08 | 14.71 |
| opt/backtrack/words-english | 40536 | 141.54 ± 0.3% | not timed | not timed | 92.85 ± 0.3% | 19.77 ± 6.8% | not timed | not timed | 141.43 ± 2.1% | | 1.00 | 1.52 | 7.16 |
| opt/fixed-length/too-small-ascii | 0 | 316.36 ± 0.3% | not timed | not timed | 691.44 ± 1.1% | 80.71 ± 0.7% | not timed | not timed | 317.12 ± 0.3% | | 1.00 | 0.46 | 3.92 |
| opt/fixed-length/too-big-ascii | 0 | 3433.56 ± 0.2% | not timed | not timed | 5814.92 ± 0.2% | 125.11 ± 0.4% | not timed | not timed | 3425.84 ± 0.1% | | 1.00 | 0.59 | 27.44 |
| opt/fixed-length/go33484-1 | 0 | 659340.76 ± 0.1% | not timed | not timed | 1110063.82 ± 0.2% | 61454.20 ± 0.4% | not timed | not timed | 660026.25 ± 0.1% | | 1.00 | 0.59 | 10.73 |
| opt/fixed-length/go33484-2 | 0 | 658787.04 ± 0.1% | not timed | not timed | 1106668.20 ± 0.1% | 32490.54 ± 2.2% | not timed | not timed | 659347.89 ± 0.1% | | 1.00 | 0.60 | 20.28 |
| opt/fixed-length/go33484-3 | 0 | 65868.19 ± 0.7% | not timed | not timed | 110757.73 ± 0.3% | 767.15 ± 0.3% | not timed | not timed | 65916.31 ± 0.5% | | 1.00 | 0.59 | 85.86 |
| opt/literal-alt/one-pattern | 1 | 549.70 ± 1.9% | not timed | not timed | 543.75 ± 0.5% | 0.40 ± 0.1% | not timed | not timed | 549.60 ± 1.6% | | 1.00 | 1.01 | 1389.59 |
| opt/onepass/fn-predicate | 916 | 368.03 ± 0.9% | not timed | not timed | 335.36 ± 0.2% | 199.46 ± 13.6% | not timed | not timed | 370.94 ± 0.8% | | 0.99 | 1.10 | 1.85 |
| opt/onepass/first-three-words-english | 35128 | 181.81 ± 12.0% | not timed | not timed | 201.51 ± 0.2% | 81.14 ± 14.5% | not timed | not timed | 181.51 ± 2.0% | | 1.00 | 0.90 | 2.24 |
| opt/prefilter/literal-english | 1 | 19700.50 ± 0.8% | not timed | not timed | 18759.65 ± 0.4% | 16988.01 ± 0.3% | not timed | not timed | 19758.38 ± 0.7% | | 1.00 | 1.05 | 1.16 |
| opt/prefilter/literal-casei-english | 1 | 14250.53 ± 1.2% | not timed | not timed | 4313.34 ± 0.1% | 32.55 ± 6.3% | not timed | not timed | 14253.98 ± 0.5% | | 1.00 | 3.30 | 437.75 |
| opt/prefilter/literal-russian | 1 | 20509.48 ± 0.5% | not timed | not timed | 19308.63 ± 0.6% | 3313.90 ± 0.2% | not timed | not timed | 20515.48 ± 0.3% | | 1.00 | 1.06 | 6.19 |
| opt/prefilter/literal-casei-russian | 1 | 8565.33 ± 0.8% | not timed | not timed | 3880.78 ± 0.2% | 31.93 ± 0.2% | not timed | not timed | 8557.78 ± 0.9% | | 1.00 | 2.21 | 268.27 |
| opt/prefilter/rust-functions | 948 | 6791.30 ± 47.0% | not timed | not timed | 8878.75 ± 68.0% | 1862.74 ± 4.9% | not timed | not timed | 6766.51 ± 10.1% | | 1.00 | 0.76 | 3.65 |
| opt/reverse-anchored/word-end | 1 | 29563845.95 ± 0.1% | not timed | not timed | 21399098.22 ± 0.2% | 50.45 ± 0.2% | not timed | not timed | 29589913.42 ± 0.2% | | 1.00 | 1.38 | 585990.17 |
| opt/reverse-inner/holmes | 2593 | 9864.91 ± 1.3% | not timed | not timed | 9487.36 ± 0.5% | 23.89 ± 2.2% | not timed | not timed | 9869.67 ± 0.9% | | 1.00 | 1.04 | 412.87 |
| opt/reverse-inner/email | 47 | 36174.85 ± 1.3% | not timed | not timed | 44581.32 ± 2.1% | 32.43 ± 0.3% | not timed | not timed | 36285.31 ± 3.4% | | 1.00 | 0.81 | 1115.55 |
| opt/reverse-inner/factored-prefix | 3542 | 592.37 ± 0.6% | not timed | not timed | 597.79 ± 0.0% | 12.54 ± 0.7% | not timed | not timed | 591.50 ± 0.2% | | 1.00 | 0.99 | 47.22 |
| opt/reverse-inner/no-quadratic-backward | 0 | 21009.39 ± 0.1% | not timed | not timed | 613.85 ± 0.7% | 74.93 ± 0.1% | not timed | not timed | 21160.64 ± 0.1% | | 0.99 | 34.23 | 280.38 |
| opt/reverse-inner/no-quadratic-forward | 0 | 729.41 ± 2.7% | not timed | not timed | 288.09 ± 0.3% | 24.65 ± 0.1% | not timed | not timed | 738.34 ± 2.7% | | 0.99 | 2.53 | 29.60 |
| opt/reverse-suffix/holmes | 4073 | 10160.64 ± 0.3% | not timed | not timed | 8413.60 ± 0.4% | 23.95 ± 1.4% | not timed | not timed | 10146.15 ± 0.8% | | 1.00 | 1.21 | 424.29 |
| opt/reverse-suffix/no-quadratic | 0 | 21073.30 ± 0.1% | not timed | not timed | 614.24 ± 0.4% | 74.82 ± 0.1% | not timed | not timed | 21144.77 ± 0.0% | | 1.00 | 34.31 | 281.66 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.12 ± 9.1% | not timed | not timed | 132.32 ± 0.2% | 13.38 ± 15.2% | not timed | not timed | 120.78 ± 2.7% | | 1.00 | 0.92 | 9.05 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 119.55 ± 2.4% | not timed | not timed | 130.83 ± 0.2% | 13.02 ± 13.0% | not timed | not timed | 120.92 ± 0.5% | | 0.99 | 0.91 | 9.19 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.3% | not timed | not timed | 0.54 ± 0.1% | 113.12 ± 1.1% | not timed | not timed | 0.28 ± 0.2% | | 0.99 | 0.51 | 0.0024 |
| reported/i1095-word-repetition/ascii-search | 256 | 320.91 ± 0.2% | not timed | not timed | 294.32 ± 0.1% | 103.47 ± 7.5% | not timed | not timed | 323.14 ± 3.5% | | 0.99 | 1.09 | 3.10 |
| reported/i13-subset-regex/original-ascii | 4094 | 11196.35 ± 0.9% | not timed | not timed | 4482.25 ± 0.7% | 11.51 ± 0.1% | not timed | not timed | 11212.27 ± 0.8% | | 1.00 | 2.50 | 972.87 |
| reported/i13-subset-regex/original-unicode | 4094 | 10651.86 ± 2.3% | not timed | not timed | 249.90 ± 3.4% | 11.50 ± 0.1% | not timed | not timed | 11236.66 ± 1.1% | | 0.95 | 42.63 | 925.98 |
| reported/i13-subset-regex/big-ascii | 1955 | 10656.52 ± 0.8% | not timed | not timed | 67.98 ± 3.7% | 9.86 ± 0.2% | not timed | not timed | 10717.82 ± 1.5% | | 0.99 | 156.76 | 1080.78 |
| reported/i13-subset-regex/big-unicode | 1955 | 10588.43 ± 1.3% | not timed | not timed | 12.14 ± 54.9% | 9.86 ± 0.1% | not timed | not timed | 10738.04 ± 0.9% | | 0.99 | 872.34 | 1073.92 |
| reported/i13-subset-regex/huge-ascii | 55 | 9875.92 ± 2.6% | not timed | not timed | 11.02 ± 0.1% | 8.78 ± 0.5% | not timed | not timed | 9816.09 ± 3.2% | | 1.01 | 896.04 | 1124.31 |
| reported/i13-subset-regex/huge-unicode | 55 | 9836.23 ± 2.8% | not timed | not timed | 10.94 ± 0.3% | 8.77 ± 0.1% | not timed | not timed | 9816.18 ± 2.3% | | 1.00 | 899.38 | 1121.68 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.53 ± 0.1% | not timed | not timed | 11.04 ± 0.1% | 8.77 ± 0.1% | not timed | not timed | 3.53 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.96 ± 0.2% | not timed | not timed | 10.97 ± 0.3% | 8.77 ± 1.0% | not timed | not timed | 4.97 ± 0.3% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 484.06 ± 0.4% | not timed | not timed | 103.30 ± 0.1% | 6.66 ± 0.3% | not timed | not timed | 484.81 ± 0.5% | | 1.00 | 4.69 | 72.73 |
| reported/i787-keywords/opt-ascii | 5674 | 486.07 ± 0.3% | not timed | not timed | 270.08 ± 0.1% | 10.31 ± 0.0% | not timed | not timed | 483.78 ± 0.3% | | 1.00 | 1.80 | 47.17 |
| slow/quadratic-regex-1x | 100 | 7.08 ± 0.1% | not timed | not timed | 4.96 ± 0.1% | 0.05 ± 0.3% | not timed | not timed | 6.91 ± 0.5% | | 1.03 | 1.43 | 143.67 |
| slow/quadratic-regex-2x | 199 | 3.42 ± 0.1% | not timed | not timed | 2.77 ± 0.1% | 0.01 ± 0.2% | not timed | not timed | 3.43 ± 0.1% | | 1.00 | 1.24 | 269.30 |
| slow/quadratic-haystack-1x | 100 | 22.04 ± 6.5% | not timed | not timed | 10.04 ± 0.3% | 1.01 ± 14.2% | not timed | not timed | 22.02 ± 1.3% | | 1.00 | 2.19 | 21.86 |
| slow/quadratic-haystack-2x | 200 | 19.83 ± 1.1% | not timed | not timed | 5.54 ± 0.3% | 0.54 ± 0.6% | not timed | not timed | 19.77 ± 7.6% | | 1.00 | 3.58 | 36.44 |
| unicode/codepoints/any-one | 1112064 | 280.59 ± 0.6% | not timed | not timed | 173.72 ± 0.1% | 18.49 ± 3.8% | not timed | not timed | 280.05 ± 1.1% | | 1.00 | 1.62 | 15.17 |
| unicode/codepoints/any-all | 4382592 | 283.32 ± 1.1% | not timed | not timed | 247.09 ± 0.2% | 117.61 ± 0.0% | not timed | not timed | 282.96 ± 0.7% | | 1.00 | 1.15 | 2.41 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.72 ± 1.0% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 602.32 ± 0.3% | not timed | not timed | 616.24 ± 0.2% | 134.69 ± 0.5% | not timed | not timed | 602.63 ± 0.6% | | 1.00 | 0.98 | 4.47 |
| unicode/overlapping-words/ascii | 6156 | 32.29 ± 0.3% | not timed | not timed | 38.91 ± 0.1% | 3.93 ± 0.6% | not timed | not timed | 32.35 ± 0.3% | | 1.00 | 0.83 | 8.22 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.1% | not timed | not timed | 4.45 ± 0.1% | 2.33 ± 0.2% | not timed | not timed | 1.43 ± 0.1% | | 1.01 | 0.32 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.5% | not timed | not timed | 4.13 ± 0.5% | 6.20 ± 10.7% | not timed | not timed | 1.27 ± 0.1% | | 1.00 | 0.31 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 129.57 ± 8.3% | not timed | not timed | 82.65 ± 0.5% | 11.79 ± 22.7% | not timed | not timed | 129.86 ± 1.4% | | 1.00 | 1.57 | 10.99 |
| unicode/word/boundary-long-english | 3466 | 607.95 ± 0.2% | not timed | not timed | 605.35 ± 0.1% | 32.75 ± 0.6% | not timed | not timed | 607.36 ± 0.4% | | 1.00 | 1.00 | 18.56 |
| unicode/word/around-holmes-english | 27 | 18960.07 ± 0.6% | not timed | not timed | 18681.14 ± 0.5% | 22.07 ± 0.9% | not timed | not timed | 19029.09 ± 0.7% | | 1.00 | 1.01 | 858.97 |
| wild/bibleref/long | 874 | 565.34 ± 0.1% | not timed | not timed | 582.83 ± 0.1% | 6.82 ± 0.1% | not timed | not timed | 567.34 ± 0.2% | | 1.00 | 0.97 | 82.84 |
| wild/bibleref/short | 30 | 25.13 ± 4.8% | not timed | not timed | 30.39 ± 0.7% | 13.95 ± 10.9% | not timed | not timed | 25.00 ± 2.5% | | 1.01 | 0.83 | 1.80 |
| wild/bibleref/line | 874 | 398.23 ± 0.1% | not timed | not timed | 213.92 ± 0.1% | 9.21 ± 0.2% | not timed | not timed | 400.14 ± 0.1% | | 1.00 | 1.86 | 43.26 |
| wild/caddy/caddy | 6 | 418.76 ± 2.3% | not timed | not timed | 247.74 ± 0.3% | 67.36 ± 14.2% | not timed | not timed | 422.11 ± 0.7% | | 0.99 | 1.69 | 6.22 |
| wild/dot-star-capture/rust-src-tools | 6 | 1069.76 ± 0.5% | not timed | not timed | 344.84 ± 0.3% | 13.51 ± 0.3% | not timed | not timed | 1063.98 ± 2.1% | | 1.01 | 3.10 | 79.16 |
| wild/ruff/noqa | 84 | 439.86 ± 0.1% | not timed | not timed | 462.91 ± 0.3% | 19.50 ± 1.9% | not timed | not timed | 439.35 ± 0.1% | | 1.00 | 0.95 | 22.55 |
| wild/ruff/unnecessary-coding-comment | 16 | 961.13 ± 0.4% | not timed | not timed | 699.08 ± 0.1% | 133.60 ± 10.8% | not timed | not timed | 960.80 ± 0.4% | | 1.00 | 1.37 | 7.19 |
| wild/ruff/string-quote-prefix | 2972 | 1370.24 ± 0.7% | not timed | not timed | 439.19 ± 0.5% | 366.82 ± 31.6% | not timed | not timed | 1370.91 ± 0.6% | | 1.00 | 3.12 | 3.74 |
| wild/ruff/space-around-operator | 1224378 | 223.20 ± 1.9% | not timed | not timed | 187.06 ± 0.0% | 18.38 ± 1.7% | not timed | not timed | 223.99 ± 2.0% | | 1.00 | 1.19 | 12.14 |
| wild/ruff/shebang | 282 | 972.61 ± 0.4% | not timed | not timed | 327.92 ± 0.2% | 111.11 ± 12.8% | not timed | not timed | 979.42 ± 0.4% | | 0.99 | 2.97 | 8.75 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13811.34 ± 0.1% | not timed | not timed | 13792.00 ± 0.8% | 6902.62 ± 1.1% | not timed | not timed | 13812.50 ± 0.1% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12814.84 ± 0.6% | not timed | not timed | 13454.43 ± 0.7% | 6393.25 ± 0.7% | not timed | not timed | 12809.82 ± 0.5% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13166.01 ± 1.0% | not timed | not timed | 13593.13 ± 1.5% | 6591.90 ± 1.1% | not timed | not timed | 13171.47 ± 1.2% | | 1.00 | 0.97 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9548.71 ± 0.4% | not timed | not timed | 13501.35 ± 1.9% | 6697.48 ± 6.0% | not timed | not timed | 9555.47 ± 4.2% | | 1.00 | 0.71 | 1.43 |
| wild/url/search | 234965 | 120.24 ± 14.1% | not timed | not timed | 65.11 ± 1.1% | 2.20 ± 0.8% | not timed | not timed | 120.47 ± 14.2% | | 1.00 | 1.85 | 54.63 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 46.2% | not timed | not timed | 0.01 ± 0.6% | 0.01 ± 12.6% | not timed | not timed | 0.03 ± 3.0% | | 1.00 | 3.11 | 3.94 |
| dictionary/compile/english-15 | 1 | 0.35 ± 3.8% | not timed | not timed | 0.07 ± 8.3% | 0.10 ± 30.5% | not timed | not timed | 0.35 ± 1.2% | | 0.98 | 5.02 | 3.37 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 2.1% | not timed | not timed | 0.02 ± 1.0% | 34.85 ± 10.0% | not timed | not timed | 0.25 ± 1.0% | | 1.00 | 13.49 | 0.0072 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.98 ± 2.4% | not timed | not timed | 11.57 ± 0.2% | 52.70 ± 18.7% | not timed | not timed | 48.06 ± 2.5% | | 1.00 | 4.15 | 0.91 |
| reported/i787-keywords/compile | 1 | 35.37 ± 5.0% | not timed | not timed | 2.10 ± 0.4% | 16.66 ± 36.7% | not timed | not timed | 35.42 ± 5.1% | | 1.00 | 16.82 | 2.12 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 366.42 ± 6.4% | not timed | not timed | 118.19 ± 0.5% | 571.97 ± 30.7% | not timed | not timed | 369.13 ± 4.7% | | 0.99 | 3.10 | 0.64 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 48.79 ± 1.7% | not timed | not timed | 4.09 ± 0.6% | 42.86 ± 3.0% | not timed | not timed | 49.35 ± 1.7% | | 0.99 | 11.92 | 1.14 |
| unicode/compile/one-letter | 53 | 6.75 ± 3.0% | not timed | not timed | 4.49 ± 0.7% | 63.47 ± 3.5% | not timed | not timed | 6.81 ± 14.0% | | 0.99 | 1.50 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.08 ± 38.3% | not timed | not timed | 0.10 ± 1.3% | 65.70 ± 10.2% | not timed | not timed | 1.07 ± 18.3% | | 1.02 | 11.07 | 0.0165 |
| unicode/compile/fifty-letters-ascii | 1 | 223.31 ± 4.3% | not timed | not timed | 53.56 ± 0.2% | 189.19 ± 14.4% | not timed | not timed | 225.62 ± 8.2% | | 0.99 | 4.17 | 1.18 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 386.44 ± 26.0% | not timed | not timed | 47.17 ± 0.3% | 666.59 ± 30.5% | not timed | not timed | 384.35 ± 2.2% | | 1.01 | 8.19 | 0.58 |
| unicode/compile/match-every-line-ascii | 4 | 596.83 ± 12.4% | not timed | not timed | 145.96 ± 0.3% | 654.40 ± 29.5% | not timed | not timed | 615.17 ± 1.0% | | 0.97 | 4.09 | 0.91 |
| unicode/compile/negated-class-matches-codepoint | 1 | 324.98 ± 14.9% | not timed | not timed | 50.73 ± 0.9% | 1227.37 ± 27.9% | not timed | not timed | 330.69 ± 2.5% | | 0.98 | 6.41 | 0.26 |
| wild/bibleref/compile | 3 | 5.82 ± 22.0% | not timed | not timed | 1.93 ± 0.4% | 31.77 ± 13.6% | not timed | not timed | 5.99 ± 20.3% | | 0.97 | 3.02 | 0.18 |
| wild/url/compile | 1 | 0.56 ± 16.2% | not timed | not timed | 0.14 ± 0.5% | 0.44 ± 8.2% | not timed | not timed | 0.65 ± 17.8% | | 0.86 | 3.91 | 1.27 |

