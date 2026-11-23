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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127328395 |
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
| literal: a word | 217 | 16053.62 ± 1.7% | 1039.59 ± 0.1% | 28.72 ± 0.1% | 18257.92 ± 3.4% | 9022.83 ± 9.0% | 17.45 ± 0.2% | 86.09 ± 0.3% | 16260.37 ± 2.8% | 15.44 | 0.99 | 0.88 | 1.78 |
| literal: a word that is not there | 0 | 18821.05 ± 1.8% | 1048.85 ± 0.1% | 28.75 ± 0.2% | 19932.89 ± 2.6% | 29520.33 ± 1.8% | 17.25 ± 0.1% | 82.20 ± 0.2% | 18850.94 ± 1.2% | 17.94 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6064.24 ± 0.3% | 1021.25 ± 0.4% | 14.76 ± 0.2% | 3943.76 ± 0.6% | 21.84 ± 0.1% | 5.25 ± 1.3% | 6.74 ± 0.1% | 6052.18 ± 0.2% | 5.94 | 1.00 | 1.54 | 277.63 |
| literal: a word in any case | 217 | 12619.50 ± 0.5% | 1039.74 ± 1.2% | 21.94 ± 2.4% | 3977.27 ± 0.4% | 38.10 ± 2.8% | refused | differs | 12588.99 ± 0.7% | 12.14 | 1.00 | 3.17 | 331.26 |
| literal: an href attribute | 33 | 13821.99 ± 1.0% | 1047.47 ± 0.2% | 27.50 ± 0.2% | 16869.65 ± 2.9% | 2262.83 ± 7.0% | 13.23 ± 0.5% | 75.69 ± 0.2% | 13792.56 ± 0.5% | 13.20 | 1.00 | 0.82 | 6.11 |
| literal: a word, second text | 123 | 16371.30 ± 1.3% | 1043.17 ± 0.3% | 28.37 ± 0.2% | 18320.74 ± 1.6% | 7706.78 ± 2.9% | 19.61 ± 0.7% | 69.75 ± 0.5% | 16358.00 ± 1.9% | 15.69 | 1.00 | 0.89 | 2.12 |
| class: two capitalized words | 1331 | 1127.13 ± 0.5% | 977.72 ± 0.1% | 26.14 ± 0.2% | 585.51 ± 0.1% | 40.56 ± 12.6% | 14.83 ± 0.3% | 68.62 ± 0.5% | 1126.91 ± 0.3% | 1.15 | 1.00 | 1.93 | 27.79 |
| class: a word that ends in ing | 3399 | 890.51 ± 0.2% | 891.12 ± 0.4% | 18.25 ± 0.1% | 548.17 ± 0.1% | 29.67 ± 6.2% | 8.18 ± 0.2% | 18.20 ± 0.6% | 890.04 ± 0.7% | 1.00 | 1.00 | 1.62 | 30.02 |
| class: a word in capitals | 2332 | 1453.63 ± 0.6% | 950.74 ± 0.1% | 27.82 ± 0.3% | 572.54 ± 0.0% | 43.59 ± 0.1% | 17.19 ± 0.1% | 82.67 ± 0.3% | 1453.72 ± 0.3% | 1.53 | 1.00 | 2.54 | 33.35 |
| class: a number | 8288 | 1996.77 ± 0.3% | 827.62 ± 0.1% | 28.06 ± 0.3% | 1716.75 ± 0.1% | 40.41 ± 16.2% | 0.53 ± 0.7% | 56.43 ± 0.6% | 1989.92 ± 0.2% | 2.41 | 1.00 | 1.16 | 49.41 |
| class: two capitalized words, second text | 5359 | 737.62 ± 0.2% | 737.06 ± 0.3% | 23.42 ± 0.1% | 484.68 ± 0.1% | 33.71 ± 9.5% | 16.65 ± 0.2% | 63.54 ± 0.4% | 737.04 ± 0.1% | 1.00 | 1.00 | 1.52 | 21.88 |
| other: a word between two words | 6104 | 759.86 ± 0.4% | 763.55 ± 0.1% | 23.67 ± 0.1% | 738.99 ± 0.3% | 108.83 ± 13.6% | 11.27 ± 0.3% | 69.51 ± 0.4% | 756.38 ± 0.1% | 1.00 | 1.00 | 1.03 | 6.98 |
| other: a number before a unit, second text | 1481 | 5531.47 ± 0.7% | 983.44 ± 0.1% | 26.01 ± 0.1% | 5650.68 ± 0.4% | 40.69 ± 11.4% | 17.82 ± 0.2% | 66.95 ± 0.2% | 5501.73 ± 0.4% | 5.62 | 1.01 | 0.98 | 135.93 |
| other: a heading's start tag | 110 | 12560.09 ± 1.3% | 1036.18 ± 0.1% | 27.59 ± 0.1% | 1709.02 ± 0.1% | 1576.86 ± 5.6% | 15.87 ± 0.2% | 87.85 ± 1.1% | 12589.04 ± 1.4% | 12.12 | 1.00 | 7.35 | 7.97 |
| other: a whole word | 217 | 13939.97 ± 1.8% | 1038.91 ± 0.1% | 29.84 ± 0.2% | 14576.81 ± 1.5% | 49.40 ± 0.2% | 13.30 ± 0.4% | 55.75 ± 1.8% | 13839.84 ± 4.8% | 13.42 | 1.01 | 0.96 | 282.16 |
| other: a line's first word, second text | 3716 | 1957.38 ± 0.7% | 873.58 ± 0.3% | 31.33 ± 0.5% | 1725.66 ± 1.1% | 62.47 ± 6.9% | refused | refused | 1947.21 ± 1.1% | 2.24 | 1.01 | 1.13 | 31.33 |
| other: fourteen octets before an x | 87 | 19638.53 ± 0.7% | 242.21 ± 0.7% | 6.08 ± 0.1% | 3980.94 ± 0.5% | 10.62 ± 0.1% | differs | 17.68 ± 0.2% | 19681.05 ± 0.7% | 81.08 | 1.00 | 4.93 | 1848.86 |
| other: a Greek word | 21815 | 470.33 ± 0.7% | 357.87 ± 0.1% | 31.11 ± 0.1% | 289.43 ± 0.3% | 47.56 ± 9.8% | differs | refused | 468.01 ± 0.5% | 1.31 | 1.00 | 1.63 | 9.89 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.87 ± 0.1% | 25.89 ± 0.2% | 0.82 ± 0.4% | 19.74 ± 0.1% | 2.78 ± 0.3% | differs | 4.01 ± 0.2% | 25.86 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.31 |
| a UUID | 32895 | 21.07 ± 0.2% | 21.13 ± 0.2% | 0.65 ± 0.2% | 15.21 ± 0.7% | 3.09 ± 0.5% | 0.71 ± 0.4% | 3.61 ± 0.6% | 21.13 ± 0.1% | 1.00 | 1.00 | 1.39 | 6.83 |
| an IPv4 address | 33176 | 37.00 ± 0.1% | 36.89 ± 0.2% | 2.09 ± 0.3% | 29.00 ± 0.4% | 6.67 ± 0.1% | differs | 4.15 ± 0.2% | 36.67 ± 0.2% | 1.00 | 1.01 | 1.28 | 5.54 |
| a date and time | 32954 | 31.01 ± 0.3% | 31.14 ± 0.1% | 1.42 ± 0.2% | 21.16 ± 0.2% | 7.03 ± 0.2% | 1.20 ± 0.3% | 7.06 ± 0.1% | 31.04 ± 0.2% | 1.00 | 1.00 | 1.47 | 4.41 |
| a field path | 32606 | 29.52 ± 0.2% | 29.42 ± 0.2% | 1.01 ± 0.7% | 22.97 ± 0.3% | 3.50 ± 1.0% | differs | 2.92 ± 0.2% | 29.50 ± 0.1% | 1.00 | 1.00 | 1.29 | 8.42 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.42 ± 0.2% | 11.47 ± 0.3% | 11.50 ± 0.5% | 11.39 ± 0.1% | 4.86 ± 1.8% | 0.91 ± 1.0% | none | 11.52 ± 0.3% | 1.00 | 0.99 | 1.00 | 2.35 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.63 ± 0.2% | 223.18 ± 0.1% | 259.32 ± 0.1% | 87.00 ± 0.5% | 210.43 ± 2.5% | 481.71 ± 1.1% | 3749.94 ± 0.7% | 222.58 ± 0.2% | 1.00 | 1.00 | 2.56 | 1.06 |
| a UUID | 62 | 145.89 ± 0.2% | 146.01 ± 0.2% | 161.19 ± 0.5% | 46.69 ± 0.6% | 94.18 ± 8.3% | 190.73 ± 2.8% | 4474.42 ± 0.6% | 145.77 ± 0.3% | 1.00 | 1.00 | 3.12 | 1.55 |
| an IPv4 address | 29 | 439.38 ± 0.6% | 443.21 ± 0.3% | 614.23 ± 0.3% | 77.38 ± 0.3% | 123.94 ± 4.1% | 304.10 ± 1.4% | 7714.96 ± 0.5% | 438.79 ± 0.5% | 0.99 | 1.00 | 5.68 | 3.54 |
| a date and time | 56 | 319.48 ± 0.3% | 320.70 ± 0.3% | 401.33 ± 0.2% | 73.42 ± 0.4% | 130.33 ± 3.2% | 324.81 ± 1.5% | 4983.23 ± 0.3% | 319.45 ± 0.2% | 1.00 | 1.00 | 4.35 | 2.45 |
| a field path | 39 | 208.85 ± 0.3% | 209.36 ± 0.4% | 240.82 ± 1.0% | 81.12 ± 1.1% | 194.91 ± 2.9% | 501.85 ± 2.9% | 4858.17 ± 2.9% | 208.99 ± 0.3% | 1.00 | 1.00 | 2.57 | 1.07 |
| literal: a word | 7 | 666.53 ± 0.2% | 717.49 ± 0.4% | 1281.97 ± 0.1% | 528.73 ± 0.2% | 602.50 ± 5.7% | 952.45 ± 0.7% | 30699.93 ± 0.8% | 666.16 ± 0.3% | 0.93 | 1.00 | 1.26 | 1.11 |
| literal: a word that is not there | 8 | 640.82 ± 0.5% | 693.03 ± 0.6% | 1205.19 ± 0.1% | 484.52 ± 0.2% | 578.84 ± 3.3% | 902.48 ± 0.5% | 29596.44 ± 0.4% | 640.06 ± 0.4% | 0.92 | 1.00 | 1.32 | 1.11 |
| literal: one of four words | 26 | 256.04 ± 0.4% | 420.75 ± 0.4% | 567.22 ± 0.2% | 50.29 ± 1.3% | 224.40 ± 5.5% | 374.04 ± 1.7% | 15779.67 ± 0.4% | 256.25 ± 0.3% | 0.61 | 1.00 | 5.09 | 1.14 |
| literal: a word in any case | 11 | 522.37 ± 0.4% | 563.13 ± 0.6% | 871.20 ± 0.3% | 15.94 ± 1.6% | 604.94 ± 4.1% | refused | 23738.89 ± 0.7% | 522.91 ± 0.5% | 0.93 | 1.00 | 32.77 | 0.86 |
| literal: an href attribute | 12 | 346.39 ± 0.5% | 357.73 ± 0.3% | 462.26 ± 0.2% | 45.84 ± 0.5% | 472.38 ± 2.9% | 773.74 ± 0.7% | 22419.28 ± 0.3% | 346.35 ± 0.2% | 0.97 | 1.00 | 7.56 | 0.73 |
| literal: a word, second text | 10 | 593.14 ± 0.8% | 653.13 ± 0.3% | 1094.24 ± 0.2% | 403.53 ± 0.6% | 516.99 ± 4.0% | 799.47 ± 0.7% | 27530.15 ± 0.6% | 593.28 ± 0.1% | 0.91 | 1.00 | 1.47 | 1.15 |
| class: two capitalized words | 23 | 455.67 ± 0.2% | 484.79 ± 0.3% | 695.41 ± 0.3% | 100.46 ± 0.2% | 490.31 ± 2.5% | 748.46 ± 0.3% | 6392.60 ± 0.2% | 455.54 ± 0.3% | 0.94 | 1.00 | 4.54 | 0.93 |
| class: a word that ends in ing | 9 | 599.23 ± 0.3% | 666.10 ± 0.3% | 1173.38 ± 0.1% | 132.70 ± 1.9% | 736.07 ± 2.5% | 1106.15 ± 0.4% | 15983.40 ± 0.3% | 599.09 ± 0.3% | 0.90 | 1.00 | 4.52 | 0.81 |
| class: a word in capitals | 16 | 525.41 ± 0.6% | 565.70 ± 0.6% | 901.09 ± 0.5% | 135.67 ± 0.6% | 734.90 ± 1.0% | 1023.06 ± 1.7% | 8400.22 ± 0.2% | 525.80 ± 0.3% | 0.93 | 1.00 | 3.87 | 0.71 |
| class: a number | 6 | 667.83 ± 0.5% | 728.27 ± 0.5% | 1363.52 ± 0.1% | 41.86 ± 0.6% | 1371.78 ± 1.4% | 1855.90 ± 1.2% | 23173.04 ± 0.1% | 666.82 ± 0.4% | 0.92 | 1.00 | 15.95 | 0.49 |
| class: two capitalized words, second text | 23 | 455.41 ± 0.5% | 484.14 ± 0.4% | 695.55 ± 0.6% | 101.96 ± 0.4% | 490.27 ± 2.4% | 768.10 ± 0.4% | 6392.88 ± 0.2% | 456.20 ± 0.3% | 0.94 | 1.00 | 4.47 | 0.93 |
| other: a word between two words | 13 | 581.30 ± 0.2% | 601.40 ± 0.4% | 958.66 ± 0.2% | 133.83 ± 0.6% | 488.84 ± 0.7% | 816.10 ± 0.7% | 14753.22 ± 0.2% | 582.17 ± 0.3% | 0.97 | 1.00 | 4.34 | 1.19 |
| other: a number before a unit, second text | 15 | 406.31 ± 0.2% | 441.95 ± 0.3% | 610.52 ± 0.1% | 39.62 ± 0.5% | 614.59 ± 9.8% | 892.61 ± 1.0% | 15372.72 ± 0.1% | 406.14 ± 0.1% | 0.92 | 1.00 | 10.25 | 0.66 |
| other: a heading's start tag | 13 | 357.83 ± 0.6% | 362.43 ± 0.3% | 470.91 ± 0.2% | 43.95 ± 1.3% | 610.27 ± 1.5% | 879.34 ± 0.7% | 18582.70 ± 0.3% | 358.26 ± 0.4% | 0.99 | 1.00 | 8.14 | 0.59 |
| other: a whole word | 11 | 615.60 ± 0.3% | 653.96 ± 0.3% | 1086.77 ± 0.6% | 118.66 ± 0.4% | 545.42 ± 1.3% | 837.50 ± 0.7% | 27010.00 ± 0.4% | 615.81 ± 0.2% | 0.94 | 1.00 | 5.19 | 1.13 |
| other: a line's first word, second text | 17 | 558.77 ± 0.3% | 581.23 ± 0.6% | 933.39 ± 0.3% | 129.40 ± 0.3% | 686.79 ± 11.9% | refused | refused | 556.33 ± 1.0% | 0.96 | 1.00 | 4.32 | 0.81 |
| other: fourteen octets before an x | 16 | 112.30 ± 0.2% | 161.09 ± 0.5% | 184.81 ± 0.3% | 15.21 ± 0.8% | 440.16 ± 2.9% | 413.51 ± 0.4% | 13063.65 ± 0.5% | 112.33 ± 0.2% | 0.70 | 1.00 | 7.38 | 0.26 |
| other: a Greek word | 8 | 441.45 ± 0.4% | 578.62 ± 0.6% | 928.56 ± 0.6% | 59.21 ± 0.1% | 1356.65 ± 1.2% | 1787.37 ± 0.6% | refused | 441.46 ± 0.2% | 0.76 | 1.00 | 7.46 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12788.99 ± 0.8% | not timed | not timed | 16064.21 ± 1.9% | 2141.21 ± 17.2% | not timed | not timed | 12837.62 ± 1.2% | | 1.00 | 0.80 | 5.97 |
| 01-literal/sherlock-casei-en | 522 | 3872.39 ± 0.8% | not timed | not timed | 3586.40 ± 0.2% | 32.48 ± 0.6% | not timed | not timed | 3874.84 ± 0.2% | | 1.00 | 1.08 | 119.23 |
| 01-literal/sherlock-ru | 724 | 13612.71 ± 0.2% | not timed | not timed | 17298.73 ± 0.3% | 1395.40 ± 10.7% | not timed | not timed | 13600.17 ± 0.3% | | 1.00 | 0.79 | 9.76 |
| 01-literal/sherlock-casei-ru | 746 | 5232.51 ± 0.2% | not timed | not timed | 3329.57 ± 0.1% | 31.69 ± 0.5% | not timed | not timed | 5237.59 ± 0.1% | | 1.00 | 1.57 | 165.10 |
| 01-literal/sherlock-zh | 30 | 16848.62 ± 0.5% | not timed | not timed | 18505.00 ± 0.5% | 2650.09 ± 12.0% | not timed | not timed | 16817.89 ± 0.5% | | 1.00 | 0.91 | 6.36 |
| 02-literal-alternate/sherlock-en | 714 | 5821.71 ± 0.5% | not timed | not timed | 3940.48 ± 0.2% | 16.57 ± 0.3% | not timed | not timed | 5824.93 ± 0.3% | | 1.00 | 1.48 | 351.41 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1663.92 ± 0.7% | not timed | not timed | 696.81 ± 0.2% | 11.09 ± 12.6% | not timed | not timed | 1656.45 ± 0.6% | | 1.00 | 2.39 | 150.07 |
| 02-literal-alternate/sherlock-ru | 899 | 4643.37 ± 0.3% | not timed | not timed | 3258.04 ± 0.1% | 22.60 ± 0.1% | not timed | not timed | 4636.55 ± 0.2% | | 1.00 | 1.43 | 205.48 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1777.58 ± 0.5% | not timed | not timed | 1230.96 ± 0.3% | 9.15 ± 0.1% | not timed | not timed | 1767.86 ± 0.3% | | 1.01 | 1.44 | 194.30 |
| 02-literal-alternate/sherlock-zh | 207 | 7037.17 ± 0.3% | not timed | not timed | 4159.61 ± 0.0% | 31.48 ± 0.1% | not timed | not timed | 7039.37 ± 0.1% | | 1.00 | 1.69 | 223.55 |
| 03-date/ascii | 111817 | 124.71 ± 0.7% | not timed | not timed | 96.23 ± 0.4% | 0.20 ± 1.6% | not timed | not timed | 123.29 ± 0.3% | | 1.01 | 1.30 | 626.55 |
| 04-ruff-noqa/real | 84 | 554.88 ± 0.1% | not timed | not timed | 445.28 ± 0.1% | 19.53 ± 1.1% | not timed | not timed | 554.57 ± 0.1% | | 1.00 | 1.25 | 28.40 |
| 04-ruff-noqa/tweaked | 44 | 545.22 ± 0.2% | not timed | not timed | 457.30 ± 0.1% | 362.53 ± 1.4% | not timed | not timed | 544.19 ± 0.1% | | 1.00 | 1.19 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.66 ± 0.5% | not timed | not timed | 5.11 ± 0.2% | 0.20 ± 4.3% | not timed | not timed | 3.68 ± 1.7% | | 0.99 | 0.72 | 18.02 |
| 06-cloud-flare-redos/original | 107 | 270.72 ± 0.3% | not timed | not timed | 217.12 ± 0.1% | 24.90 ± 0.2% | not timed | not timed | 269.64 ± 0.3% | | 1.00 | 1.25 | 10.87 |
| 06-cloud-flare-redos/simplified-short | 102 | 264.64 ± 0.3% | not timed | not timed | 228.96 ± 0.0% | 26.75 ± 0.1% | not timed | not timed | 264.63 ± 0.6% | | 1.00 | 1.16 | 9.89 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.36 ± 0.2% | not timed | not timed | 255.60 ± 0.3% | 28.86 ± 0.1% | not timed | not timed | 294.25 ± 0.2% | | 1.00 | 1.15 | 10.20 |
| 07-unicode-character-data/parse-line | 558784 | 240.05 ± 0.6% | not timed | not timed | 158.28 ± 0.3% | 41.33 ± 5.3% | not timed | not timed | 239.83 ± 2.0% | | 1.00 | 1.52 | 5.81 |
| 08-words/all-english | 56691 | 119.61 ± 0.8% | not timed | not timed | 82.74 ± 0.1% | 11.65 ± 9.3% | not timed | not timed | 119.62 ± 0.2% | | 1.00 | 1.45 | 10.26 |
| 08-words/long-english | 839 | 1006.01 ± 0.2% | not timed | not timed | 597.70 ± 0.1% | 32.52 ± 0.8% | not timed | not timed | 1003.82 ± 0.2% | | 1.00 | 1.68 | 30.94 |
| 09-aws-keys/full | 0 | 412.86 ± 0.2% | not timed | not timed | 362.96 ± 0.1% | 64.60 ± 3.4% | not timed | not timed | 412.75 ± 0.2% | | 1.00 | 1.14 | 6.39 |
| 09-aws-keys/quick | 0 | 737.97 ± 0.1% | not timed | not timed | 992.24 ± 0.2% | 417.85 ± 0.2% | not timed | not timed | 736.20 ± 0.1% | | 1.00 | 0.74 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 635.31 ± 0.5% | not timed | not timed | 517.80 ± 0.2% | 19.50 ± 0.3% | not timed | not timed | 632.90 ± 0.6% | | 1.00 | 1.23 | 32.57 |
| 10-bounded-repeat/letters-ru | 3475 | 380.41 ± 0.3% | not timed | not timed | 477.99 ± 0.1% | 21.85 ± 17.9% | not timed | not timed | 379.36 ± 0.7% | | 1.00 | 0.80 | 17.41 |
| 10-bounded-repeat/context | 53 | 78.65 ± 1.1% | not timed | not timed | 65.37 ± 0.6% | 19.73 ± 0.4% | not timed | not timed | 78.77 ± 1.0% | | 1.00 | 1.20 | 3.99 |
| 10-bounded-repeat/capitals | 11 | 1044.24 ± 0.2% | not timed | not timed | 615.52 ± 0.0% | 36.56 ± 0.1% | not timed | not timed | 1044.45 ± 0.1% | | 1.00 | 1.70 | 28.56 |
| 11-unstructured-to-json/extract | 600 | 47.72 ± 0.1% | not timed | not timed | 77.23 ± 0.2% | 49.45 ± 1.0% | not timed | not timed | 46.67 ± 0.9% | | 1.02 | 0.62 | 0.97 |
| 12-dictionary/single | 1 | 570.54 ± 0.3% | not timed | not timed | 558.28 ± 0.3% | 0.40 ± 0.1% | not timed | not timed | 572.30 ± 0.2% | | 1.00 | 1.02 | 1426.19 |
| 14-quadratic/1x | 100 | 13.04 ± 0.3% | not timed | not timed | 10.04 ± 0.4% | 0.97 ± 2.6% | not timed | not timed | 13.01 ± 1.2% | | 1.00 | 1.30 | 13.43 |
| 14-quadratic/2x | 200 | 7.99 ± 0.2% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 1.7% | not timed | not timed | 7.97 ± 0.7% | | 1.00 | 1.44 | 15.10 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 1.86 ± 0.5% | | 1.00 | 1.53 | 16.12 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.53 ± 1.3% | not timed | not timed | 0.34 ± 0.6% | 0.53 ± 3.4% | not timed | not timed | 1.52 ± 0.8% | | 1.01 | 4.48 | 2.87 |
| 04-ruff-noqa/compile-real | 1 | 87.23 ± 0.1% | not timed | not timed | 13.91 ± 0.3% | 132.84 ± 2.3% | not timed | not timed | 87.14 ± 1.3% | | 1.00 | 6.27 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.35 ± 0.3% | not timed | not timed | 2.52 ± 0.3% | 6.22 ± 3.3% | not timed | not timed | 14.28 ± 1.4% | | 1.00 | 5.69 | 2.31 |
| 07-unicode-character-data/compile | 1 | 55.36 ± 0.2% | not timed | not timed | 26.11 ± 0.4% | 34.91 ± 1.9% | not timed | not timed | 55.12 ± 1.0% | | 1.00 | 2.12 | 1.59 |
| 09-aws-keys/compile-full | 1 | 42.35 ± 0.2% | not timed | not timed | 8.35 ± 0.6% | 22.69 ± 1.5% | not timed | not timed | 42.21 ± 0.8% | | 1.00 | 5.07 | 1.87 |
| 09-aws-keys/compile-quick | 1 | 190.75 ± 0.2% | not timed | not timed | 48.33 ± 0.3% | 128.35 ± 3.2% | not timed | not timed | 191.07 ± 1.2% | | 1.00 | 3.95 | 1.49 |
| 10-bounded-repeat/compile-context | 1 | 14.63 ± 1.3% | not timed | not timed | 11.20 ± 0.3% | 15.41 ± 2.2% | not timed | not timed | 14.54 ± 1.2% | | 1.01 | 1.31 | 0.95 |
| 10-bounded-repeat/compile-capitals | 1 | 85.27 ± 0.4% | not timed | not timed | 8.12 ± 0.3% | 23.03 ± 5.1% | not timed | not timed | 84.75 ± 0.8% | | 1.01 | 10.50 | 3.70 |
| 11-unstructured-to-json/compile | 1 | 86.81 ± 0.3% | not timed | not timed | 40.61 ± 0.2% | 65.70 ± 2.8% | not timed | not timed | 86.29 ± 0.5% | | 1.01 | 2.14 | 1.32 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.4% | not timed | not timed | 0.07 ± 0.9% | 0.10 ± 15.6% | not timed | not timed | 0.35 ± 2.3% | | 1.01 | 5.25 | 3.63 |

