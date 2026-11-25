# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507003840 |
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
| literal: a word | 217 | 19671.10 ± 2.6% | 5083.73 ± 0.1% | 28.25 ± 0.4% | 18132.20 ± 1.4% | 8986.25 ± 8.4% | 17.54 ± 0.4% | 86.05 ± 0.3% | 19512.88 ± 3.1% | 3.87 | 1.01 | 1.08 | 2.19 |
| literal: a word that is not there | 0 | 21403.44 ± 1.2% | 4941.46 ± 0.3% | 28.20 ± 0.4% | 19636.33 ± 4.0% | 28302.16 ± 2.9% | 17.41 ± 0.1% | 81.86 ± 0.1% | 21327.94 ± 1.6% | 4.33 | 1.00 | 1.09 | 0.76 |
| literal: one of four words | 661 | 6425.92 ± 0.4% | 1975.46 ± 0.3% | 14.41 ± 0.2% | 3946.35 ± 0.1% | 21.92 ± 0.1% | 5.30 ± 0.1% | 6.73 ± 0.3% | 6431.13 ± 0.3% | 3.25 | 1.00 | 1.63 | 293.15 |
| literal: a word in any case | 217 | 15118.92 ± 1.0% | 2104.80 ± 0.4% | 21.50 ± 0.3% | 3965.79 ± 0.3% | 38.11 ± 0.6% | refused | differs | 15113.01 ± 0.9% | 7.18 | 1.00 | 3.81 | 396.67 |
| literal: an href attribute | 33 | 16478.94 ± 1.5% | 617.52 ± 0.1% | 27.24 ± 0.4% | 16671.48 ± 0.8% | 2258.64 ± 0.5% | 13.44 ± 0.1% | 75.26 ± 0.2% | 16507.86 ± 1.3% | 26.69 | 1.00 | 0.99 | 7.30 |
| literal: a word, second text | 123 | 19886.67 ± 2.2% | 3428.14 ± 0.1% | 27.97 ± 0.4% | 18160.85 ± 1.3% | 7698.50 ± 6.6% | 19.64 ± 0.5% | 68.93 ± 0.2% | 19742.46 ± 1.0% | 5.80 | 1.01 | 1.10 | 2.58 |
| class: two capitalized words | 1331 | 1065.87 ± 0.2% | 609.60 ± 0.1% | 25.98 ± 0.3% | 585.31 ± 0.0% | 40.62 ± 8.4% | 14.99 ± 0.3% | 68.24 ± 0.4% | 1064.18 ± 0.6% | 1.75 | 1.00 | 1.82 | 26.24 |
| class: a word that ends in ing | 3399 | 583.75 ± 0.1% | 583.10 ± 0.3% | 17.98 ± 0.2% | 548.05 ± 0.0% | 29.61 ± 11.6% | 8.24 ± 0.1% | 18.26 ± 0.0% | 584.12 ± 0.1% | 1.00 | 1.00 | 1.07 | 19.71 |
| class: a word in capitals | 2332 | 1389.70 ± 0.5% | 614.66 ± 0.1% | 27.59 ± 0.4% | 572.51 ± 0.1% | 43.61 ± 7.0% | 17.27 ± 0.3% | 82.31 ± 1.6% | 1390.46 ± 0.4% | 2.26 | 1.00 | 2.43 | 31.87 |
| class: a number | 8288 | 2126.31 ± 0.6% | 853.25 ± 0.1% | 27.84 ± 0.2% | 1719.79 ± 0.5% | 42.88 ± 16.4% | 0.57 ± 0.1% | 56.87 ± 0.1% | 2128.64 ± 0.5% | 2.49 | 1.00 | 1.24 | 49.59 |
| class: two capitalized words, second text | 5359 | 525.95 ± 0.2% | 535.16 ± 0.1% | 23.34 ± 0.1% | 483.72 ± 0.3% | 35.41 ± 13.8% | 16.71 ± 0.2% | 63.42 ± 0.2% | 526.11 ± 0.2% | 0.98 | 1.00 | 1.09 | 14.85 |
| other: a word between two words | 6104 | 810.79 ± 0.1% | 609.06 ± 0.3% | 23.56 ± 0.3% | 714.94 ± 0.3% | 110.39 ± 22.3% | 11.33 ± 0.2% | 69.32 ± 0.6% | 809.39 ± 0.4% | 1.33 | 1.00 | 1.13 | 7.35 |
| other: a number before a unit, second text | 1481 | 6193.50 ± 0.8% | 1132.66 ± 0.2% | 25.96 ± 0.2% | 5625.77 ± 0.3% | 40.81 ± 0.2% | 17.82 ± 0.2% | 66.55 ± 0.3% | 6165.69 ± 1.0% | 5.47 | 1.00 | 1.10 | 151.77 |
| other: a heading's start tag | 110 | 13938.60 ± 0.7% | 750.61 ± 0.1% | 27.41 ± 0.2% | 1712.00 ± 0.6% | 1585.77 ± 2.6% | 16.31 ± 0.7% | 88.43 ± 0.2% | 13994.03 ± 0.7% | 18.57 | 1.00 | 8.14 | 8.79 |
| other: a whole word | 217 | 16233.97 ± 2.1% | 607.45 ± 0.2% | 29.41 ± 0.3% | 14462.30 ± 0.5% | 48.06 ± 0.3% | 13.79 ± 0.3% | 55.23 ± 0.2% | 16236.82 ± 1.9% | 26.72 | 1.00 | 1.12 | 337.78 |
| other: a line's first word, second text | 3716 | 2100.09 ± 0.3% | 599.89 ± 0.1% | 31.04 ± 0.2% | 1725.54 ± 0.7% | 62.39 ± 8.3% | refused | refused | 2097.49 ± 0.8% | 3.50 | 1.00 | 1.22 | 33.66 |
| other: fourteen octets before an x | 87 | 23788.00 ± 1.9% | 220.31 ± 0.4% | 6.55 ± 0.1% | 3959.91 ± 1.1% | 10.63 ± 0.2% | differs | 17.49 ± 0.1% | 23679.06 ± 2.1% | 107.98 | 1.00 | 6.01 | 2237.82 |
| other: a Greek word | 21815 | 518.98 ± 0.2% | 424.81 ± 0.2% | 30.77 ± 0.2% | 289.13 ± 0.8% | 49.00 ± 13.9% | differs | refused | 520.84 ± 0.5% | 1.22 | 1.00 | 1.79 | 10.59 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.30 ± 0.3% | 29.24 ± 0.2% | 0.86 ± 0.3% | 19.61 ± 0.2% | 2.78 ± 0.5% | differs | 4.02 ± 0.2% | 29.20 ± 0.3% | 1.00 | 1.00 | 1.49 | 10.53 |
| a UUID | 32895 | 24.71 ± 0.2% | 24.66 ± 0.2% | 0.64 ± 0.2% | 15.09 ± 0.0% | 3.10 ± 0.4% | 0.72 ± 0.4% | 3.59 ± 0.5% | 24.71 ± 0.5% | 1.00 | 1.00 | 1.64 | 7.97 |
| an IPv4 address | 33176 | 38.39 ± 0.0% | 38.34 ± 0.2% | 2.07 ± 0.3% | 29.11 ± 0.3% | 6.50 ± 0.1% | differs | 4.15 ± 0.2% | 38.36 ± 0.2% | 1.00 | 1.00 | 1.32 | 5.90 |
| a date and time | 32954 | 34.28 ± 0.3% | 34.02 ± 0.3% | 1.44 ± 0.3% | 21.25 ± 0.2% | 7.03 ± 0.2% | 1.20 ± 0.3% | 7.03 ± 0.1% | 34.27 ± 0.3% | 1.01 | 1.00 | 1.61 | 4.87 |
| a field path | 32606 | 32.50 ± 0.2% | 32.48 ± 0.3% | 1.01 ± 0.3% | 23.14 ± 0.2% | 3.51 ± 0.3% | differs | 2.92 ± 0.1% | 32.50 ± 0.3% | 1.00 | 1.00 | 1.40 | 9.26 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.13 ± 0.4% | 11.05 ± 0.4% | 11.12 ± 0.3% | 11.33 ± 0.2% | 4.91 ± 3.5% | 0.90 ± 0.3% | none | 11.08 ± 0.4% | 1.01 | 1.00 | 0.98 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.42 ± 0.3% | 221.66 ± 0.3% | 258.61 ± 0.3% | 87.20 ± 0.4% | 213.93 ± 2.0% | 470.09 ± 0.3% | 3720.63 ± 2.8% | 221.60 ± 0.4% | 1.00 | 1.00 | 2.54 | 1.03 |
| a UUID | 62 | 143.24 ± 0.1% | 143.33 ± 0.2% | 158.38 ± 0.1% | 45.98 ± 1.0% | 96.68 ± 1.3% | 190.97 ± 2.4% | 4442.13 ± 0.2% | 143.22 ± 0.3% | 1.00 | 1.00 | 3.12 | 1.48 |
| an IPv4 address | 29 | 415.40 ± 0.5% | 415.77 ± 0.6% | 572.54 ± 0.4% | 77.92 ± 0.5% | 127.08 ± 1.2% | 299.62 ± 0.3% | 7599.48 ± 0.2% | 414.79 ± 0.3% | 1.00 | 1.00 | 5.33 | 3.27 |
| a date and time | 56 | 299.95 ± 0.3% | 300.14 ± 0.2% | 373.73 ± 0.4% | 72.38 ± 0.8% | 132.63 ± 2.9% | 324.79 ± 0.7% | 4930.25 ± 0.6% | 300.27 ± 0.2% | 1.00 | 1.00 | 4.14 | 2.26 |
| a field path | 39 | 211.44 ± 0.4% | 211.62 ± 0.3% | 245.43 ± 0.3% | 81.56 ± 1.1% | 200.32 ± 1.9% | 495.71 ± 1.1% | 4828.86 ± 0.3% | 211.54 ± 0.2% | 1.00 | 1.00 | 2.59 | 1.06 |
| literal: a word | 7 | 609.66 ± 0.8% | 660.86 ± 0.2% | 1154.19 ± 0.2% | 517.43 ± 1.1% | 606.33 ± 2.6% | 962.76 ± 0.6% | 29691.51 ± 0.2% | 611.64 ± 0.7% | 0.92 | 1.00 | 1.18 | 1.01 |
| literal: a word that is not there | 8 | 587.83 ± 0.3% | 644.61 ± 0.8% | 1092.14 ± 1.1% | 468.23 ± 0.2% | 585.51 ± 2.4% | 914.16 ± 0.4% | 28578.38 ± 0.1% | 589.08 ± 0.4% | 0.91 | 1.00 | 1.26 | 1.00 |
| literal: one of four words | 26 | 245.42 ± 0.3% | 393.11 ± 0.5% | 525.16 ± 0.4% | 48.85 ± 0.5% | 233.00 ± 1.7% | 378.13 ± 0.5% | 15422.41 ± 0.3% | 245.38 ± 0.2% | 0.62 | 1.00 | 5.02 | 1.05 |
| literal: a word in any case | 11 | 443.73 ± 0.3% | 474.32 ± 0.3% | 691.63 ± 0.1% | 15.74 ± 0.4% | 627.18 ± 3.0% | refused | 23274.40 ± 0.2% | 443.87 ± 0.3% | 0.94 | 1.00 | 28.20 | 0.71 |
| literal: an href attribute | 12 | 333.97 ± 0.5% | 344.91 ± 0.2% | 447.00 ± 0.4% | 45.17 ± 1.1% | 482.42 ± 1.6% | 784.26 ± 0.7% | 21494.95 ± 0.3% | 333.78 ± 0.4% | 0.97 | 1.00 | 7.39 | 0.69 |
| literal: a word, second text | 10 | 545.38 ± 0.5% | 605.81 ± 0.4% | 984.83 ± 0.7% | 411.38 ± 0.4% | 522.77 ± 1.0% | 807.90 ± 0.9% | 26354.98 ± 0.1% | 546.30 ± 0.4% | 0.90 | 1.00 | 1.33 | 1.04 |
| class: two capitalized words | 23 | 432.40 ± 0.6% | 459.71 ± 0.5% | 654.21 ± 0.8% | 100.77 ± 2.8% | 487.38 ± 12.4% | 752.44 ± 0.6% | 6332.40 ± 0.2% | 431.46 ± 0.3% | 0.94 | 1.00 | 4.29 | 0.89 |
| class: a word that ends in ing | 9 | 543.09 ± 0.2% | 611.28 ± 0.2% | 1037.07 ± 0.3% | 132.48 ± 0.8% | 731.27 ± 2.9% | 1077.45 ± 2.4% | 15680.34 ± 0.1% | 542.62 ± 0.3% | 0.89 | 1.00 | 4.10 | 0.74 |
| class: a word in capitals | 16 | 487.35 ± 0.3% | 523.09 ± 0.4% | 815.94 ± 0.3% | 136.86 ± 0.5% | 732.93 ± 1.0% | 994.49 ± 1.4% | 8321.12 ± 0.1% | 487.12 ± 0.3% | 0.93 | 1.00 | 3.56 | 0.66 |
| class: a number | 6 | 627.11 ± 0.3% | 686.71 ± 0.3% | 1261.65 ± 0.1% | 41.92 ± 1.2% | 1364.81 ± 1.0% | 1864.99 ± 0.8% | 22428.63 ± 0.2% | 626.62 ± 0.2% | 0.91 | 1.00 | 14.96 | 0.46 |
| class: two capitalized words, second text | 23 | 432.53 ± 0.3% | 460.36 ± 0.5% | 653.99 ± 0.2% | 100.26 ± 1.4% | 492.26 ± 1.1% | 730.34 ± 0.5% | 6331.87 ± 0.1% | 432.06 ± 0.3% | 0.94 | 1.00 | 4.31 | 0.88 |
| other: a word between two words | 13 | 526.87 ± 0.2% | 546.92 ± 0.3% | 854.08 ± 0.2% | 134.05 ± 1.4% | 487.14 ± 1.4% | 802.47 ± 1.2% | 14549.51 ± 0.1% | 525.46 ± 0.4% | 0.96 | 1.00 | 3.93 | 1.08 |
| other: a number before a unit, second text | 15 | 381.36 ± 0.1% | 420.93 ± 0.2% | 579.04 ± 0.2% | 39.58 ± 0.2% | 612.97 ± 1.0% | 885.13 ± 0.3% | 15084.60 ± 0.1% | 381.55 ± 0.1% | 0.91 | 1.00 | 9.63 | 0.62 |
| other: a heading's start tag | 13 | 344.19 ± 0.1% | 351.25 ± 0.3% | 456.96 ± 0.4% | 43.88 ± 0.3% | 606.92 ± 0.5% | 870.06 ± 0.2% | 17839.73 ± 0.3% | 344.13 ± 0.2% | 0.98 | 1.00 | 7.84 | 0.57 |
| other: a whole word | 11 | 564.31 ± 0.4% | 606.15 ± 0.4% | 989.75 ± 0.4% | 120.31 ± 0.5% | 553.38 ± 2.3% | 832.55 ± 0.6% | 26220.75 ± 0.2% | 564.64 ± 0.3% | 0.93 | 1.00 | 4.69 | 1.02 |
| other: a line's first word, second text | 17 | 511.92 ± 0.6% | 541.69 ± 0.4% | 852.28 ± 0.5% | 129.13 ± 0.3% | 697.65 ± 1.0% | refused | refused | 512.33 ± 0.5% | 0.95 | 1.00 | 3.96 | 0.73 |
| other: fourteen octets before an x | 16 | 107.37 ± 0.1% | 153.12 ± 0.3% | 174.26 ± 0.5% | 15.13 ± 0.7% | 449.00 ± 2.5% | 406.35 ± 0.5% | 12595.13 ± 0.4% | 107.26 ± 0.3% | 0.70 | 1.00 | 7.10 | 0.24 |
| other: a Greek word | 8 | 444.31 ± 0.5% | 579.52 ± 0.3% | 948.07 ± 0.4% | 58.70 ± 1.3% | 1361.72 ± 1.0% | 1837.53 ± 0.6% | refused | 444.29 ± 0.2% | 0.77 | 1.00 | 7.57 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15424.55 ± 1.7% | not timed | not timed | 15793.65 ± 0.3% | 2181.18 ± 18.8% | not timed | not timed | 15341.27 ± 0.6% | | 1.01 | 0.98 | 7.07 |
| 01-literal/sherlock-casei-en | 522 | 11115.76 ± 5.6% | not timed | not timed | 3590.35 ± 0.2% | 32.56 ± 0.2% | not timed | not timed | 11076.41 ± 1.0% | | 1.00 | 3.10 | 341.38 |
| 01-literal/sherlock-ru | 724 | 17172.80 ± 0.7% | not timed | not timed | 17251.12 ± 2.6% | 1533.34 ± 14.7% | not timed | not timed | 17222.60 ± 2.3% | | 1.00 | 1.00 | 11.20 |
| 01-literal/sherlock-casei-ru | 746 | 6146.50 ± 0.2% | not timed | not timed | 3332.35 ± 0.2% | 31.70 ± 1.3% | not timed | not timed | 6136.80 ± 0.2% | | 1.00 | 1.84 | 193.90 |
| 01-literal/sherlock-zh | 30 | 19194.35 ± 1.2% | not timed | not timed | 18120.91 ± 1.4% | 2713.67 ± 8.0% | not timed | not timed | 19169.78 ± 0.4% | | 1.00 | 1.06 | 7.07 |
| 02-literal-alternate/sherlock-en | 714 | 6146.65 ± 0.2% | not timed | not timed | 3933.73 ± 0.1% | 16.44 ± 0.1% | not timed | not timed | 6153.28 ± 0.2% | | 1.00 | 1.56 | 373.88 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1970.07 ± 1.0% | not timed | not timed | 696.88 ± 0.3% | 11.04 ± 1.2% | not timed | not timed | 1974.96 ± 0.8% | | 1.00 | 2.83 | 178.37 |
| 02-literal-alternate/sherlock-ru | 899 | 5529.20 ± 7.1% | not timed | not timed | 3248.69 ± 2.5% | 22.64 ± 0.1% | not timed | not timed | 5521.91 ± 0.1% | | 1.00 | 1.70 | 244.20 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2058.38 ± 0.5% | not timed | not timed | 1230.18 ± 0.1% | 9.15 ± 0.2% | not timed | not timed | 2053.10 ± 0.5% | | 1.00 | 1.67 | 225.06 |
| 02-literal-alternate/sherlock-zh | 207 | 7286.98 ± 0.5% | not timed | not timed | 4152.77 ± 0.1% | 31.44 ± 0.1% | not timed | not timed | 7281.93 ± 0.4% | | 1.00 | 1.75 | 231.79 |
| 03-date/ascii | 111817 | 132.94 ± 0.7% | not timed | not timed | 95.87 ± 0.1% | 0.20 ± 3.0% | not timed | not timed | 134.42 ± 0.7% | | 0.99 | 1.39 | 666.53 |
| 04-ruff-noqa/real | 84 | 435.91 ± 0.1% | not timed | not timed | 462.21 ± 0.5% | 19.57 ± 1.2% | not timed | not timed | 435.92 ± 0.2% | | 1.00 | 0.94 | 22.27 |
| 04-ruff-noqa/tweaked | 44 | 594.06 ± 0.3% | not timed | not timed | 462.46 ± 0.2% | 363.20 ± 0.5% | not timed | not timed | 595.26 ± 0.4% | | 1.00 | 1.28 | 1.64 |
| 05-lexer-veryl/single | 124800 | 5.35 ± 0.3% | not timed | not timed | 5.00 ± 0.1% | 0.20 ± 1.9% | not timed | not timed | 5.51 ± 2.5% | | 0.97 | 1.07 | 26.30 |
| 06-cloud-flare-redos/original | 107 | 426.52 ± 0.2% | not timed | not timed | 213.10 ± 0.1% | 24.98 ± 0.4% | not timed | not timed | 432.19 ± 0.1% | | 0.99 | 2.00 | 17.07 |
| 06-cloud-flare-redos/simplified-short | 102 | 431.78 ± 0.0% | not timed | not timed | 227.99 ± 0.1% | 26.76 ± 0.1% | not timed | not timed | 431.31 ± 0.1% | | 1.00 | 1.89 | 16.14 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.66 ± 0.1% | not timed | not timed | 257.11 ± 0.1% | 28.83 ± 0.1% | not timed | not timed | 588.73 ± 0.1% | | 1.00 | 2.29 | 20.42 |
| 07-unicode-character-data/parse-line | 558784 | 233.45 ± 2.4% | not timed | not timed | 170.32 ± 0.2% | 41.44 ± 4.7% | not timed | not timed | 232.63 ± 2.3% | | 1.00 | 1.37 | 5.63 |
| 08-words/all-english | 56691 | 127.88 ± 0.8% | not timed | not timed | 82.92 ± 0.3% | 11.77 ± 11.3% | not timed | not timed | 127.94 ± 0.9% | | 1.00 | 1.54 | 10.86 |
| 08-words/long-english | 839 | 623.54 ± 0.1% | not timed | not timed | 595.58 ± 0.1% | 32.34 ± 0.3% | not timed | not timed | 623.66 ± 0.2% | | 1.00 | 1.05 | 19.28 |
| 09-aws-keys/full | 0 | 440.44 ± 0.1% | not timed | not timed | 465.77 ± 0.3% | 64.48 ± 0.2% | not timed | not timed | 439.21 ± 0.0% | | 1.00 | 0.95 | 6.83 |
| 09-aws-keys/quick | 0 | 874.88 ± 0.2% | not timed | not timed | 990.80 ± 0.3% | 418.30 ± 21.6% | not timed | not timed | 874.89 ± 0.2% | | 1.00 | 0.88 | 2.09 |
| 10-bounded-repeat/letters-en | 1833 | 584.15 ± 3.2% | not timed | not timed | 515.43 ± 0.2% | 19.48 ± 0.7% | not timed | not timed | 587.41 ± 0.4% | | 0.99 | 1.13 | 29.99 |
| 10-bounded-repeat/letters-ru | 3475 | 506.02 ± 1.2% | not timed | not timed | 478.09 ± 0.1% | 21.71 ± 8.9% | not timed | not timed | 504.47 ± 1.3% | | 1.00 | 1.06 | 23.31 |
| 10-bounded-repeat/context | 53 | 84.75 ± 1.8% | not timed | not timed | 65.18 ± 0.6% | 19.77 ± 0.2% | not timed | not timed | 84.60 ± 1.6% | | 1.00 | 1.30 | 4.29 |
| 10-bounded-repeat/capitals | 11 | 631.88 ± 8.5% | not timed | not timed | 615.73 ± 0.1% | 36.53 ± 0.1% | not timed | not timed | 633.37 ± 8.3% | | 1.00 | 1.03 | 17.30 |
| 11-unstructured-to-json/extract | 600 | 57.18 ± 0.9% | not timed | not timed | 77.54 ± 0.3% | 49.01 ± 0.7% | not timed | not timed | 57.39 ± 0.2% | | 1.00 | 0.74 | 1.17 |
| 12-dictionary/single | 1 | 560.82 ± 1.2% | not timed | not timed | 559.14 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 562.20 ± 0.8% | | 1.00 | 1.00 | 1384.76 |
| 14-quadratic/1x | 100 | 21.36 ± 0.7% | not timed | not timed | 10.04 ± 0.5% | 0.98 ± 3.5% | not timed | not timed | 21.48 ± 1.5% | | 0.99 | 2.13 | 21.75 |
| 14-quadratic/2x | 200 | 17.73 ± 1.7% | not timed | not timed | 5.54 ± 0.3% | 0.53 ± 1.7% | not timed | not timed | 17.87 ± 1.3% | | 0.99 | 3.20 | 33.40 |
| 14-quadratic/10x | 1000 | 7.77 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 7.78 ± 0.3% | | 1.00 | 6.44 | 67.26 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.22 ± 0.6% | not timed | not timed | 0.34 ± 0.5% | 0.54 ± 5.0% | not timed | not timed | 1.22 ± 1.5% | | 1.00 | 3.58 | 2.26 |
| 04-ruff-noqa/compile-real | 1 | 105.80 ± 0.3% | not timed | not timed | 13.74 ± 0.5% | 136.84 ± 2.0% | not timed | not timed | 106.45 ± 1.0% | | 0.99 | 7.70 | 0.77 |
| 05-lexer-veryl/compile-single | 1 | 14.02 ± 1.3% | not timed | not timed | 2.52 ± 0.6% | 6.35 ± 1.8% | not timed | not timed | 14.03 ± 1.5% | | 1.00 | 5.57 | 2.21 |
| 07-unicode-character-data/compile | 1 | 107.68 ± 1.5% | not timed | not timed | 25.56 ± 0.3% | 35.24 ± 3.4% | not timed | not timed | 107.97 ± 1.0% | | 1.00 | 4.21 | 3.06 |
| 09-aws-keys/compile-full | 1 | 52.95 ± 1.2% | not timed | not timed | 8.31 ± 0.4% | 22.82 ± 2.1% | not timed | not timed | 53.04 ± 0.4% | | 1.00 | 6.37 | 2.32 |
| 09-aws-keys/compile-quick | 1 | 186.88 ± 0.4% | not timed | not timed | 47.62 ± 0.1% | 130.01 ± 3.1% | not timed | not timed | 187.61 ± 0.6% | | 1.00 | 3.92 | 1.44 |
| 10-bounded-repeat/compile-context | 1 | 72.21 ± 0.5% | not timed | not timed | 11.21 ± 0.3% | 15.75 ± 2.3% | not timed | not timed | 72.25 ± 0.6% | | 1.00 | 6.44 | 4.58 |
| 10-bounded-repeat/compile-capitals | 1 | 85.17 ± 1.1% | not timed | not timed | 8.07 ± 0.4% | 23.25 ± 2.3% | not timed | not timed | 85.02 ± 0.1% | | 1.00 | 10.55 | 3.66 |
| 11-unstructured-to-json/compile | 1 | 170.12 ± 0.7% | not timed | not timed | 40.91 ± 0.8% | 66.69 ± 3.3% | not timed | not timed | 170.53 ± 0.8% | | 1.00 | 4.16 | 2.55 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.7% | not timed | not timed | 0.07 ± 1.6% | 0.10 ± 15.2% | not timed | not timed | 0.35 ± 1.0% | | 0.99 | 5.14 | 3.63 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.36 ± 0.7% | not timed | not timed | 6.45 ± 0.1% | 0.54 ± 3.1% | not timed | not timed | 7.36 ± 0.9% | | 1.00 | 1.14 | 13.67 |
| dictionary/search/english-10 | 690 | 1.16 ± 4.7% | not timed | not timed | 164.78 ± 0.5% | 0.00 ± 0.6% | not timed | not timed | 1.16 ± 0.7% | | 1.00 | 0.0070 | 458.41 |
| dictionary/search/english-15 | 15 | 566.70 ± 1.0% | not timed | not timed | 559.72 ± 0.1% | 0.37 ± 0.5% | not timed | not timed | 567.59 ± 1.0% | | 1.00 | 1.01 | 1550.99 |
| folly/awyer-inn-busted | 1 | 5594.36 ± 0.2% | not timed | not timed | 141.82 ± 0.1% | 43.90 ± 0.1% | not timed | not timed | 5615.24 ± 0.1% | | 1.00 | 39.45 | 127.43 |
| folly/literal-never-match-rare | 0 | 21111.48 ± 0.3% | not timed | not timed | 19890.64 ± 0.6% | 40836.16 ± 0.7% | not timed | not timed | 21118.13 ± 0.4% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12466.12 ± 1.9% | not timed | not timed | 19797.94 ± 0.7% | 2192.46 ± 1.4% | not timed | not timed | 12521.70 ± 1.5% | | 1.00 | 0.63 | 5.69 |
| folly/literal-never-match-tricksy | 1 | 3244.45 ± 0.2% | not timed | not timed | 4411.97 ± 0.4% | 3054.88 ± 0.7% | not timed | not timed | 3237.95 ± 0.3% | | 1.00 | 0.74 | 1.06 |
| grep/every-line | 239963 | 1316.83 ± 1.7% | not timed | not timed | 946.44 ± 1.2% | 380.60 ± 21.6% | not timed | not timed | 1324.93 ± 2.7% | | 0.99 | 1.39 | 3.46 |
| grep/long-words-ascii | 5073 | 459.20 ± 0.2% | not timed | not timed | 468.08 ± 0.2% | 46.00 ± 6.2% | not timed | not timed | 458.91 ± 0.4% | | 1.00 | 0.98 | 9.98 |
| imported/leipzig/twain | 811 | 20695.72 ± 1.4% | not timed | not timed | 19591.82 ± 0.3% | 11942.49 ± 9.6% | not timed | not timed | 20736.80 ± 0.4% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9049.23 ± 1.1% | not timed | not timed | 4250.77 ± 0.1% | 37.70 ± 2.8% | not timed | not timed | 9109.17 ± 1.2% | | 0.99 | 2.13 | 240.03 |
| imported/leipzig/shing | 1540 | 15212.75 ± 1.6% | not timed | not timed | 13450.93 ± 1.3% | 33.71 ± 0.1% | not timed | not timed | 15370.13 ± 2.2% | | 0.99 | 1.13 | 451.29 |
| imported/leipzig/huck-saw | 262 | 8223.91 ± 3.3% | not timed | not timed | 5593.58 ± 1.1% | 31.52 ± 0.1% | not timed | not timed | 8412.55 ± 3.8% | | 0.98 | 1.47 | 260.89 |
| imported/leipzig/word-ending-nn | 262 | 605.45 ± 0.1% | not timed | not timed | 617.42 ± 0.2% | 24.63 ± 0.8% | not timed | not timed | 604.30 ± 0.7% | | 1.00 | 0.98 | 24.58 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11129.02 ± 1.1% | not timed | not timed | 4476.15 ± 0.6% | 11.35 ± 0.1% | not timed | not timed | 11162.70 ± 1.1% | | 1.00 | 2.49 | 980.93 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7801.14 ± 2.9% | not timed | not timed | 5480.76 ± 0.2% | 16.71 ± 0.1% | not timed | not timed | 7815.35 ± 3.2% | | 1.00 | 1.42 | 466.90 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4172.75 ± 0.6% | not timed | not timed | 410.93 ± 1.5% | 10.97 ± 0.0% | not timed | not timed | 4179.20 ± 1.0% | | 1.00 | 10.15 | 380.32 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 602.51 ± 0.3% | not timed | not timed | 614.50 ± 0.2% | 10.84 ± 0.1% | not timed | not timed | 602.77 ± 0.7% | | 1.00 | 0.98 | 55.59 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 603.92 ± 0.2% | not timed | not timed | 615.78 ± 0.1% | 9.60 ± 0.1% | not timed | not timed | 603.29 ± 0.1% | | 1.00 | 0.98 | 62.90 |
| imported/leipzig/tom-river | 2 | 6466.11 ± 1.9% | not timed | not timed | 5143.36 ± 0.3% | 30.73 ± 0.1% | not timed | not timed | 6583.71 ± 2.6% | | 0.98 | 1.26 | 210.41 |
| imported/leipzig/ing | 78424 | 600.21 ± 1.0% | not timed | not timed | 571.08 ± 0.2% | 28.84 ± 4.3% | not timed | not timed | 601.50 ± 0.6% | | 1.00 | 1.05 | 20.81 |
| imported/leipzig/ing-whitespace | 55248 | 750.72 ± 0.8% | not timed | not timed | 2062.85 ± 0.6% | 20.40 ± 2.8% | not timed | not timed | 752.80 ± 0.4% | | 1.00 | 0.36 | 36.79 |
| imported/leipzig/awyer-inn | 209 | 768.88 ± 1.0% | not timed | not timed | 4261.04 ± 0.2% | 22.46 ± 0.1% | not timed | not timed | 769.51 ± 1.3% | | 1.00 | 0.18 | 34.23 |
| imported/leipzig/quotes-bounded | 8886 | 2118.78 ± 0.8% | not timed | not timed | 2992.18 ± 1.5% | 37.92 ± 0.2% | not timed | not timed | 2125.15 ± 1.4% | | 1.00 | 0.71 | 55.87 |
| imported/leipzig/non-ascii-alternate | 2 | 12852.62 ± 2.1% | not timed | not timed | 5665.66 ± 0.1% | 50.20 ± 0.1% | not timed | not timed | 13030.10 ± 2.1% | | 0.99 | 2.27 | 256.05 |
| imported/leipzig/math-symbols | 69 | 1981.12 ± 0.5% | not timed | not timed | 618.35 ± 0.0% | 36.36 ± 0.2% | not timed | not timed | 1981.92 ± 0.7% | | 1.00 | 3.20 | 54.49 |
| imported/leipzig/bounded-strings-ending-z | 0 | 586.74 ± 2.0% | not timed | not timed | 615.95 ± 0.0% | 22.26 ± 0.1% | not timed | not timed | 587.32 ± 1.6% | | 1.00 | 0.95 | 26.36 |
| imported/lh3lh3-reb/uri | 17549 | 679.57 ± 0.1% | not timed | not timed | 1061.82 ± 0.2% | 27.85 ± 2.2% | not timed | not timed | 679.44 ± 0.1% | | 1.00 | 0.64 | 24.40 |
| imported/lh3lh3-reb/email | 15057 | 674.16 ± 0.1% | not timed | not timed | 1154.07 ± 0.2% | 30.15 ± 2.5% | not timed | not timed | 673.87 ± 0.2% | | 1.00 | 0.58 | 22.36 |
| imported/lh3lh3-reb/date | 668 | 860.02 ± 0.2% | not timed | not timed | 1028.34 ± 0.1% | 50.50 ± 3.8% | not timed | not timed | 860.62 ± 0.1% | | 1.00 | 0.84 | 17.03 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 646.58 ± 0.1% | not timed | not timed | 422.67 ± 0.4% | 15.55 ± 1.2% | not timed | not timed | 645.49 ± 0.1% | | 1.00 | 1.53 | 41.58 |
| imported/mariomka/email | 92 | 24262.55 ± 1.3% | not timed | not timed | 29421.97 ± 2.4% | 32.83 ± 0.2% | not timed | not timed | 24288.55 ± 1.5% | | 1.00 | 0.82 | 739.00 |
| imported/mariomka/uri | 5301 | 5340.68 ± 0.7% | not timed | not timed | 6109.12 ± 0.2% | 32.76 ± 0.3% | not timed | not timed | 5377.04 ± 1.0% | | 0.99 | 0.87 | 163.04 |
| imported/mariomka/ip | 5 | 2158.08 ± 2.1% | not timed | not timed | 2969.17 ± 0.1% | 21.03 ± 0.3% | not timed | not timed | 2156.42 ± 2.3% | | 1.00 | 0.73 | 102.60 |
| imported/rsc/no-exponential | 0 | 606.34 ± 0.1% | not timed | not timed | 320.90 ± 0.1% | 23.53 ± 0.3% | not timed | not timed | 602.06 ± 0.1% | | 1.01 | 1.89 | 25.77 |
| imported/rsc/literal | 1 | 759.10 ± 0.6% | not timed | not timed | 1658.34 ± 3.5% | 187.79 ± 17.2% | not timed | not timed | 755.60 ± 5.4% | | 1.00 | 0.46 | 4.04 |
| imported/rsc/not-literal | 2 | 781.53 ± 0.3% | not timed | not timed | 732.90 ± 0.7% | 45.78 ± 8.5% | not timed | not timed | 782.84 ± 2.2% | | 1.00 | 1.07 | 17.07 |
| imported/rsc/match-class | 1 | 1439.35 ± 2.2% | not timed | not timed | 1623.22 ± 0.3% | 58.46 ± 6.6% | not timed | not timed | 1439.38 ± 0.3% | | 1.00 | 0.89 | 24.62 |
| imported/rsc/match-class-in-range | 1 | 1446.49 ± 2.4% | not timed | not timed | 2335.85 ± 3.9% | 59.74 ± 10.8% | not timed | not timed | 1439.28 ± 0.2% | | 1.01 | 0.62 | 24.21 |
| imported/rsc/match-class-unicode | 1 | 548.36 ± 1.8% | not timed | not timed | 513.18 ± 0.1% | 72.52 ± 7.6% | not timed | not timed | 549.17 ± 0.1% | | 1.00 | 1.07 | 7.56 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1440.23 ± 0.1% | not timed | not timed | 949.02 ± 0.1% | 228.66 ± 0.4% | not timed | not timed | 1439.26 ± 0.1% | | 1.00 | 1.52 | 6.30 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21595.99 ± 0.1% | not timed | not timed | 14217.46 ± 0.0% | 3433.27 ± 0.6% | not timed | not timed | 21556.69 ± 0.3% | | 1.00 | 1.52 | 6.29 |
| imported/rsc/anchored-literal-short-match | 4 | 707.30 ± 1.9% | not timed | not timed | 488.55 ± 0.3% | 85.89 ± 5.9% | not timed | not timed | 708.03 ± 1.8% | | 1.00 | 1.45 | 8.23 |
| imported/rsc/anchored-literal-long-match | 4 | 10635.63 ± 0.7% | not timed | not timed | 7275.36 ± 0.1% | 1227.36 ± 1.9% | not timed | not timed | 10626.10 ± 0.1% | | 1.00 | 1.46 | 8.67 |
| imported/rsc/one-pass-short | 17 | 372.69 ± 10.6% | not timed | not timed | 215.71 ± 0.1% | 31.26 ± 13.7% | not timed | not timed | 370.27 ± 1.6% | | 1.01 | 1.73 | 11.92 |
| imported/rsc/one-pass-short-not | 17 | 281.05 ± 2.0% | not timed | not timed | 228.46 ± 0.2% | 29.66 ± 10.6% | not timed | not timed | 280.73 ± 2.1% | | 1.00 | 1.23 | 9.48 |
| imported/rsc/one-pass-long-prefix | 26 | 363.34 ± 2.1% | not timed | not timed | 281.74 ± 0.1% | 96.42 ± 13.6% | not timed | not timed | 366.94 ± 0.9% | | 0.99 | 1.29 | 3.77 |
| imported/rsc/one-pass-long-prefix-not | 26 | 363.40 ± 2.1% | not timed | not timed | 280.81 ± 0.5% | 63.84 ± 15.2% | not timed | not timed | 366.77 ± 6.1% | | 0.99 | 1.29 | 5.69 |
| imported/rsc/long-needle1 | 31 | 22201.72 ± 0.0% | not timed | not timed | 20174.52 ± 0.1% | 3.77 ± 0.2% | not timed | not timed | 22209.60 ± 0.1% | | 1.00 | 1.10 | 5890.02 |
| imported/rsc/long-needle2 | 31 | 22339.85 ± 0.3% | not timed | not timed | 216.41 ± 0.3% | 3.77 ± 0.1% | not timed | not timed | 22337.97 ± 0.1% | | 1.00 | 103.23 | 5923.19 |
| imported/rsc/easy0-32 | 26 | 1067.05 ± 3.0% | not timed | not timed | 1601.73 ± 4.2% | 148.67 ± 20.3% | not timed | not timed | 1069.34 ± 0.2% | | 1.00 | 0.67 | 7.18 |
| imported/rsc/easy0-1k | 26 | 14910.08 ± 2.0% | not timed | not timed | 12680.19 ± 1.8% | 2314.56 ± 14.6% | not timed | not timed | 14942.32 ± 0.2% | | 1.00 | 1.18 | 6.44 |
| imported/rsc/easy0-32k | 26 | 23014.04 ± 0.0% | not timed | not timed | 20340.17 ± 0.1% | 18775.27 ± 0.1% | not timed | not timed | 23015.78 ± 0.1% | | 1.00 | 1.13 | 1.23 |
| imported/rsc/easy0-1mb | 26 | 21587.19 ± 3.0% | not timed | not timed | 19887.56 ± 3.4% | 36428.28 ± 6.0% | not timed | not timed | 21511.48 ± 3.8% | | 1.00 | 1.09 | 0.59 |
| imported/rsc/easy1-32 | 19 | 804.70 ± 2.3% | not timed | not timed | 638.86 ± 0.4% | 130.19 ± 15.1% | not timed | not timed | 802.55 ± 2.3% | | 1.00 | 1.26 | 6.18 |
| imported/rsc/easy1-1k | 19 | 16482.88 ± 0.2% | not timed | not timed | 12818.52 ± 0.1% | 2487.19 ± 14.9% | not timed | not timed | 16427.21 ± 2.1% | | 1.00 | 1.29 | 6.63 |
| imported/rsc/easy1-32k | 19 | 517724.25 ± 2.5% | not timed | not timed | 407170.94 ± 0.3% | 20379.39 ± 19.9% | not timed | not timed | 517737.28 ± 0.3% | | 1.00 | 1.27 | 25.40 |
| imported/rsc/easy1-1mb | 19 | 16584705.28 ± 0.3% | not timed | not timed | 13095314.43 ± 0.3% | 37835.79 ± 2.1% | not timed | not timed | 16568159.08 ± 0.2% | | 1.00 | 1.27 | 438.33 |
| imported/rsc/medium-32 | 27 | 766.36 ± 0.1% | not timed | not timed | 639.75 ± 0.3% | 69.92 ± 11.3% | not timed | not timed | 768.94 ± 1.2% | | 1.00 | 1.20 | 10.96 |
| imported/rsc/medium-1k | 27 | 13616.94 ± 0.7% | not timed | not timed | 11133.36 ± 0.1% | 72.27 ± 0.1% | not timed | not timed | 13724.36 ± 1.0% | | 0.99 | 1.22 | 188.42 |
| imported/rsc/medium-32k | 27 | 424827.97 ± 0.5% | not timed | not timed | 348657.86 ± 0.2% | 48.89 ± 0.1% | not timed | not timed | 429161.15 ± 0.9% | | 0.99 | 1.22 | 8688.83 |
| imported/rsc/medium-1mb | 27 | 13601381.17 ± 0.2% | not timed | not timed | 11291096.86 ± 0.4% | 48.86 ± 0.1% | not timed | not timed | 13746368.88 ± 0.6% | | 0.99 | 1.20 | 278399.02 |
| imported/rsc/hard-32 | 58 | 423.27 ± 0.1% | not timed | not timed | 366.09 ± 0.2% | 49.84 ± 8.6% | not timed | not timed | 418.75 ± 2.0% | | 1.01 | 1.16 | 8.49 |
| imported/rsc/hard-1k | 27 | 13400.20 ± 0.2% | not timed | not timed | 11573.98 ± 0.2% | 40.86 ± 0.1% | not timed | not timed | 13348.20 ± 0.4% | | 1.00 | 1.16 | 327.97 |
| imported/rsc/hard-32k | 27 | 417779.47 ± 0.2% | not timed | not timed | 362130.53 ± 0.1% | 29.38 ± 0.1% | not timed | not timed | 417485.93 ± 0.5% | | 1.00 | 1.15 | 14219.55 |
| imported/rsc/hard-1mb | 51 | 8433792.54 ± 0.2% | not timed | not timed | 7252648.81 ± 0.2% | 29.39 ± 0.2% | not timed | not timed | 8335394.89 ± 0.1% | | 1.01 | 1.16 | 287005.56 |
| imported/rsc/reallyhard0-32 | 58 | 266.99 ± 0.2% | not timed | not timed | 224.48 ± 0.1% | 49.61 ± 8.0% | not timed | not timed | 267.16 ± 2.5% | | 1.00 | 1.19 | 5.38 |
| imported/rsc/reallyhard0-1k | 27 | 587.70 ± 0.3% | not timed | not timed | 583.07 ± 0.6% | 40.70 ± 0.1% | not timed | not timed | 589.34 ± 0.2% | | 1.00 | 1.01 | 14.44 |
| imported/rsc/reallyhard0-32k | 27 | 610.75 ± 0.4% | not timed | not timed | 619.06 ± 0.1% | 29.41 ± 0.2% | not timed | not timed | 611.81 ± 0.1% | | 1.00 | 0.99 | 20.76 |
| imported/rsc/reallyhard0-1mb | 51 | 593.49 ± 0.4% | not timed | not timed | 616.22 ± 0.2% | 29.37 ± 0.2% | not timed | not timed | 591.75 ± 0.7% | | 1.00 | 0.96 | 20.20 |
| imported/rsc/reallyreallyhard0-32 | 47 | 288.98 ± 1.8% | not timed | not timed | 196.29 ± 0.2% | 60.92 ± 12.5% | not timed | not timed | 289.44 ± 1.9% | | 1.00 | 1.47 | 4.74 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6770.92 ± 0.1% | not timed | not timed | 5939.96 ± 0.2% | 33.14 ± 3.6% | not timed | not timed | 6769.86 ± 0.1% | | 1.00 | 1.14 | 204.32 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21492.20 ± 0.1% | not timed | not timed | 19302.74 ± 0.1% | 25.17 ± 0.2% | not timed | not timed | 21502.88 ± 0.0% | | 1.00 | 1.11 | 853.78 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21795.25 ± 1.3% | not timed | not timed | 19749.35 ± 2.4% | 25.22 ± 0.1% | not timed | not timed | 21743.31 ± 0.9% | | 1.00 | 1.10 | 864.18 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.73 ± 1.4% | not timed | not timed | 214.54 ± 0.0% | 60.91 ± 11.8% | not timed | not timed | 282.39 ± 1.8% | | 1.00 | 1.32 | 4.64 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5889.17 ± 0.1% | not timed | not timed | 5749.87 ± 0.0% | 34.37 ± 0.6% | not timed | not timed | 5873.97 ± 0.1% | | 1.00 | 1.02 | 171.37 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21248.83 ± 0.4% | not timed | not timed | 19206.32 ± 0.1% | 24.91 ± 0.5% | not timed | not timed | 21425.37 ± 0.0% | | 0.99 | 1.11 | 853.17 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21174.27 ± 0.3% | not timed | not timed | 19548.79 ± 0.8% | 25.10 ± 0.3% | not timed | not timed | 21028.49 ± 0.9% | | 1.01 | 1.08 | 843.54 |
| imported/sherlock/name-sherlock | 776 | 19851.84 ± 1.9% | not timed | not timed | 18581.70 ± 0.4% | 10084.96 ± 24.2% | not timed | not timed | 19881.64 ± 2.5% | | 1.00 | 1.07 | 1.97 |
| imported/sherlock/name-holmes | 2766 | 15051.18 ± 6.3% | not timed | not timed | 15557.79 ± 0.7% | 3210.98 ± 32.1% | not timed | not timed | 15303.89 ± 4.7% | | 0.98 | 0.97 | 4.69 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19845.98 ± 1.8% | not timed | not timed | 18559.11 ± 0.2% | 8043.52 ± 35.1% | not timed | not timed | 19857.69 ± 0.3% | | 1.00 | 1.07 | 2.47 |
| imported/sherlock/name-sherlock-casei | 816 | 15739.72 ± 0.6% | not timed | not timed | 4009.37 ± 0.2% | 32.56 ± 0.9% | not timed | not timed | 15716.92 ± 0.9% | | 1.00 | 3.93 | 483.39 |
| imported/sherlock/name-holmes-casei | 2802 | 9497.14 ± 5.1% | not timed | not timed | 3310.70 ± 0.1% | 37.41 ± 11.3% | not timed | not timed | 9430.58 ± 4.3% | | 1.01 | 2.87 | 253.89 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13140.95 ± 6.2% | not timed | not timed | 3953.64 ± 0.2% | 32.51 ± 0.3% | not timed | not timed | 13119.63 ± 0.8% | | 1.00 | 3.32 | 404.22 |
| imported/sherlock/name-whitespace | 1461 | 15299.28 ± 5.9% | not timed | not timed | 14497.28 ± 0.2% | 7339.91 ± 32.9% | not timed | not timed | 15404.48 ± 0.3% | | 0.99 | 1.06 | 2.08 |
| imported/sherlock/name-alt1 | 1142 | 11575.39 ± 2.1% | not timed | not timed | 16409.44 ± 1.0% | 4097.04 ± 14.3% | not timed | not timed | 11613.58 ± 0.4% | | 1.00 | 0.71 | 2.83 |
| imported/sherlock/name-alt2 | 3542 | 8963.46 ± 0.3% | not timed | not timed | 3823.45 ± 0.1% | 31.27 ± 0.1% | not timed | not timed | 8968.80 ± 0.2% | | 1.00 | 2.34 | 286.60 |
| imported/sherlock/name-alt3 | 4507 | 5568.76 ± 0.3% | not timed | not timed | 3613.48 ± 0.3% | 9.95 ± 1.7% | not timed | not timed | 5578.49 ± 0.4% | | 1.00 | 1.54 | 559.82 |
| imported/sherlock/name-alt3-casei | 4593 | 1521.45 ± 2.6% | not timed | not timed | 285.51 ± 0.2% | 6.48 ± 0.1% | not timed | not timed | 1527.95 ± 1.4% | | 1.00 | 5.33 | 234.69 |
| imported/sherlock/name-alt4 | 3686 | 6394.72 ± 0.2% | not timed | not timed | 3773.74 ± 0.2% | 31.23 ± 0.1% | not timed | not timed | 6401.35 ± 0.2% | | 1.00 | 1.69 | 204.73 |
| imported/sherlock/name-alt4-casei | 4254 | 2816.18 ± 2.1% | not timed | not timed | 2573.31 ± 0.3% | 19.92 ± 0.1% | not timed | not timed | 2818.70 ± 0.8% | | 1.00 | 1.09 | 141.35 |
| imported/sherlock/name-alt5 | 4028 | 6449.11 ± 0.4% | not timed | not timed | 3739.78 ± 0.2% | 21.82 ± 0.1% | not timed | not timed | 6450.77 ± 0.3% | | 1.00 | 1.72 | 295.58 |
| imported/sherlock/name-alt5-casei | 4104 | 3515.40 ± 1.6% | not timed | not timed | 2218.20 ± 0.6% | 14.38 ± 0.1% | not timed | not timed | 3518.91 ± 0.9% | | 1.00 | 1.58 | 244.53 |
| imported/sherlock/no-match-uncommon | 0 | 21699.65 ± 0.7% | not timed | not timed | 19505.21 ± 0.4% | 35920.68 ± 0.6% | not timed | not timed | 21715.75 ± 0.4% | | 1.00 | 1.11 | 0.60 |
| imported/sherlock/no-match-common | 0 | 21365.79 ± 0.4% | not timed | not timed | 19538.51 ± 0.7% | 1282.78 ± 1.0% | not timed | not timed | 21383.61 ± 0.6% | | 1.00 | 1.09 | 16.66 |
| imported/sherlock/no-match-really-common | 0 | 15976.70 ± 4.1% | not timed | not timed | 18714.92 ± 0.5% | 1286.01 ± 1.1% | not timed | not timed | 16139.86 ± 1.8% | | 0.99 | 0.85 | 12.42 |
| imported/sherlock/the-lower | 21654 | 2323.09 ± 0.9% | not timed | not timed | 2333.80 ± 0.5% | 231.12 ± 15.0% | not timed | not timed | 2328.14 ± 1.1% | | 1.00 | 1.00 | 10.05 |
| imported/sherlock/the-upper | 2223 | 12726.92 ± 1.0% | not timed | not timed | 13601.08 ± 0.2% | 2706.87 ± 3.0% | not timed | not timed | 12798.25 ± 1.1% | | 0.99 | 0.94 | 4.70 |
| imported/sherlock/the-casei | 23961 | 2015.02 ± 1.3% | not timed | not timed | 1322.14 ± 0.3% | 34.50 ± 38.2% | not timed | not timed | 2011.73 ± 0.5% | | 1.00 | 1.52 | 58.41 |
| imported/sherlock/everything-greedy | 581881 | 283.19 ± 0.3% | not timed | not timed | 163.62 ± 0.1% | 28.64 ± 29.1% | not timed | not timed | 283.49 ± 0.7% | | 1.00 | 1.73 | 9.89 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.46 ± 0.2% | not timed | not timed | 211.87 ± 0.3% | 32.94 ± 0.1% | not timed | not timed | 462.25 ± 0.1% | | 1.00 | 2.18 | 14.04 |
| imported/sherlock/letters | 447175 | 62.19 ± 0.6% | not timed | not timed | 33.06 ± 0.1% | 6.53 ± 33.4% | not timed | not timed | 62.42 ± 1.0% | | 1.00 | 1.88 | 9.52 |
| imported/sherlock/letters-upper | 14180 | 453.13 ± 1.2% | not timed | not timed | 369.16 ± 0.1% | 29.48 ± 21.2% | not timed | not timed | 452.80 ± 0.2% | | 1.00 | 1.23 | 15.37 |
| imported/sherlock/letters-lower | 432995 | 63.27 ± 1.1% | not timed | not timed | 33.81 ± 0.1% | 5.24 ± 33.0% | not timed | not timed | 63.57 ± 0.7% | | 1.00 | 1.87 | 12.07 |
| imported/sherlock/words | 447639 | 115.74 ± 1.2% | not timed | not timed | 83.20 ± 0.2% | 13.52 ± 10.1% | not timed | not timed | 115.99 ± 2.4% | | 1.00 | 1.39 | 8.56 |
| imported/sherlock/before-holmes | 4073 | 10245.00 ± 0.4% | not timed | not timed | 8456.81 ± 0.3% | 24.06 ± 0.7% | not timed | not timed | 10281.80 ± 0.3% | | 1.00 | 1.21 | 425.75 |
| imported/sherlock/before-after-holmes | 2593 | 9852.15 ± 0.4% | not timed | not timed | 9526.05 ± 0.4% | 24.14 ± 0.8% | not timed | not timed | 9856.89 ± 0.6% | | 1.00 | 1.03 | 408.17 |
| imported/sherlock/holmes-cochar-watson | 150 | 5195.09 ± 0.2% | not timed | not timed | 3426.36 ± 0.3% | 30.98 ± 0.1% | not timed | not timed | 5200.01 ± 0.3% | | 1.00 | 1.52 | 167.68 |
| imported/sherlock/holmes-coword-watson | 14309 | 1189.43 ± 0.4% | not timed | not timed | 1119.89 ± 0.2% | 6.80 ± 0.3% | not timed | not timed | 1188.56 ± 1.2% | | 1.00 | 1.06 | 174.97 |
| imported/sherlock/quotes | 14437 | 1398.00 ± 0.2% | not timed | not timed | 1768.69 ± 1.1% | 35.05 ± 0.2% | not timed | not timed | 1400.05 ± 0.4% | | 1.00 | 0.79 | 39.89 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 609.65 ± 0.1% | not timed | not timed | 16058.13 ± 0.2% | 36.67 ± 0.2% | not timed | not timed | 609.47 ± 0.1% | | 1.00 | 0.0380 | 16.62 |
| imported/sherlock/word-ending-n | 35297 | 480.21 ± 1.0% | not timed | not timed | 410.44 ± 0.1% | 23.43 ± 18.0% | not timed | not timed | 480.32 ± 0.5% | | 1.00 | 1.17 | 20.49 |
| imported/sherlock/repeated-class-negation | 2130 | 14780.39 ± 1.7% | not timed | not timed | 11010.08 ± 0.6% | 11.57 ± 0.1% | not timed | not timed | 14767.26 ± 1.0% | | 1.00 | 1.34 | 1277.15 |
| imported/sherlock/ing-suffix | 20547 | 565.41 ± 0.3% | not timed | not timed | 516.31 ± 0.4% | 28.85 ± 0.1% | not timed | not timed | 566.22 ± 0.3% | | 1.00 | 1.10 | 19.60 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 606.71 ± 1.2% | not timed | not timed | 2095.11 ± 0.2% | 20.53 ± 25.9% | not timed | not timed | 607.20 ± 0.3% | | 1.00 | 0.29 | 29.55 |
| opt/accelerate/whole-line | 239963 | 457.97 ± 0.3% | not timed | not timed | 371.86 ± 0.1% | 92.35 ± 15.8% | not timed | not timed | 457.95 ± 0.4% | | 1.00 | 1.23 | 4.96 |
| opt/accelerate/non-dna | 16745 | 426.77 ± 1.5% | not timed | not timed | 399.65 ± 0.4% | 29.54 ± 22.4% | not timed | not timed | 429.10 ± 0.2% | | 0.99 | 1.07 | 14.45 |
| opt/backtrack/words-english | 40536 | 136.53 ± 8.2% | not timed | not timed | 94.96 ± 0.1% | 19.51 ± 7.9% | not timed | not timed | 136.44 ± 0.5% | | 1.00 | 1.44 | 7.00 |
| opt/fixed-length/too-small-ascii | 0 | 311.11 ± 0.4% | not timed | not timed | 683.21 ± 2.6% | 80.40 ± 0.4% | not timed | not timed | 314.32 ± 0.4% | | 0.99 | 0.46 | 3.87 |
| opt/fixed-length/too-big-ascii | 0 | 3504.62 ± 0.3% | not timed | not timed | 5769.57 ± 0.4% | 127.13 ± 0.1% | not timed | not timed | 3480.38 ± 0.4% | | 1.01 | 0.61 | 27.57 |
| opt/fixed-length/go33484-1 | 0 | 672952.57 ± 0.5% | not timed | not timed | 1112883.41 ± 0.6% | 61515.35 ± 0.4% | not timed | not timed | 670422.11 ± 0.3% | | 1.00 | 0.60 | 10.94 |
| opt/fixed-length/go33484-2 | 0 | 671085.40 ± 0.5% | not timed | not timed | 1110395.53 ± 0.4% | 32217.34 ± 2.4% | not timed | not timed | 668865.34 ± 0.3% | | 1.00 | 0.60 | 20.83 |
| opt/fixed-length/go33484-3 | 0 | 2463.83 ± 3.3% | not timed | not timed | 111307.36 ± 0.3% | 763.58 ± 0.2% | not timed | not timed | 2489.72 ± 3.4% | | 0.99 | 0.0221 | 3.23 |
| opt/literal-alt/one-pattern | 1 | 546.56 ± 1.4% | not timed | not timed | 542.90 ± 0.2% | 0.40 ± 0.3% | not timed | not timed | 548.86 ± 1.3% | | 1.00 | 1.01 | 1360.09 |
| opt/onepass/fn-predicate | 916 | 369.74 ± 0.8% | not timed | not timed | 334.13 ± 0.1% | 199.61 ± 13.8% | not timed | not timed | 373.30 ± 0.2% | | 0.99 | 1.11 | 1.85 |
| opt/onepass/first-three-words-english | 35128 | 174.60 ± 10.1% | not timed | not timed | 198.03 ± 0.1% | 81.69 ± 14.4% | not timed | not timed | 176.98 ± 2.3% | | 0.99 | 0.88 | 2.14 |
| opt/prefilter/literal-english | 1 | 20789.01 ± 0.5% | not timed | not timed | 19932.23 ± 0.4% | 17398.58 ± 0.3% | not timed | not timed | 20775.64 ± 0.5% | | 1.00 | 1.04 | 1.19 |
| opt/prefilter/literal-casei-english | 1 | 14593.51 ± 0.6% | not timed | not timed | 4315.92 ± 0.2% | 32.75 ± 0.5% | not timed | not timed | 14592.77 ± 0.3% | | 1.00 | 3.38 | 445.58 |
| opt/prefilter/literal-russian | 1 | 21816.93 ± 0.4% | not timed | not timed | 20243.96 ± 0.3% | 3324.67 ± 0.2% | not timed | not timed | 21822.50 ± 0.2% | | 1.00 | 1.08 | 6.56 |
| opt/prefilter/literal-casei-russian | 1 | 8567.74 ± 0.5% | not timed | not timed | 3891.25 ± 0.1% | 31.70 ± 0.5% | not timed | not timed | 8560.52 ± 0.2% | | 1.00 | 2.20 | 270.30 |
| opt/prefilter/rust-functions | 948 | 6810.72 ± 13.9% | not timed | not timed | 8932.07 ± 10.7% | 1862.23 ± 6.2% | not timed | not timed | 6800.63 ± 14.9% | | 1.00 | 0.76 | 3.66 |
| opt/reverse-anchored/word-end | 1 | 29937873.91 ± 0.1% | not timed | not timed | 21721219.98 ± 0.2% | 50.05 ± 0.2% | not timed | not timed | 29881854.00 ± 0.1% | | 1.00 | 1.38 | 598115.38 |
| opt/reverse-inner/holmes | 2593 | 9858.69 ± 0.9% | not timed | not timed | 9495.72 ± 0.7% | 23.85 ± 2.3% | not timed | not timed | 9872.66 ± 0.7% | | 1.00 | 1.04 | 413.38 |
| opt/reverse-inner/email | 47 | 36349.39 ± 0.8% | not timed | not timed | 44944.33 ± 0.9% | 32.33 ± 0.1% | not timed | not timed | 36459.66 ± 3.0% | | 1.00 | 0.81 | 1124.45 |
| opt/reverse-inner/factored-prefix | 3542 | 600.76 ± 0.3% | not timed | not timed | 597.05 ± 0.1% | 11.95 ± 1.1% | not timed | not timed | 600.37 ± 0.1% | | 1.00 | 1.01 | 50.28 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5556.62 ± 0.1% | not timed | not timed | 612.86 ± 0.2% | 75.11 ± 0.1% | not timed | not timed | 5533.51 ± 0.0% | | 1.00 | 9.07 | 73.98 |
| opt/reverse-inner/no-quadratic-forward | 0 | 689.44 ± 1.9% | not timed | not timed | 288.16 ± 0.1% | 24.83 ± 0.3% | not timed | not timed | 687.22 ± 2.1% | | 1.00 | 2.39 | 27.77 |
| opt/reverse-suffix/holmes | 4073 | 10237.58 ± 0.4% | not timed | not timed | 8438.12 ± 0.6% | 24.06 ± 0.6% | not timed | not timed | 10302.81 ± 1.4% | | 0.99 | 1.21 | 425.49 |
| opt/reverse-suffix/no-quadratic | 0 | 5533.87 ± 0.1% | not timed | not timed | 613.01 ± 0.3% | 75.20 ± 0.0% | not timed | not timed | 5560.65 ± 0.0% | | 1.00 | 9.03 | 73.59 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 122.29 ± 1.3% | not timed | not timed | 130.65 ± 0.1% | 13.65 ± 15.5% | not timed | not timed | 122.41 ± 2.4% | | 1.00 | 0.94 | 8.96 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 121.79 ± 2.7% | not timed | not timed | 130.67 ± 0.1% | 13.38 ± 14.0% | not timed | not timed | 122.11 ± 1.4% | | 1.00 | 0.93 | 9.11 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.5% | not timed | not timed | 0.55 ± 0.5% | 113.28 ± 0.4% | not timed | not timed | 0.28 ± 0.3% | | 0.99 | 0.50 | 0.0024 |
| reported/i1095-word-repetition/ascii-search | 256 | 317.64 ± 0.4% | not timed | not timed | 294.49 ± 0.1% | 101.79 ± 7.4% | not timed | not timed | 315.57 ± 3.0% | | 1.01 | 1.08 | 3.12 |
| reported/i13-subset-regex/original-ascii | 4094 | 11156.00 ± 0.8% | not timed | not timed | 4490.48 ± 0.7% | 11.32 ± 0.1% | not timed | not timed | 11195.30 ± 1.2% | | 1.00 | 2.48 | 985.80 |
| reported/i13-subset-regex/original-unicode | 4094 | 10989.91 ± 1.5% | not timed | not timed | 251.81 ± 3.4% | 11.48 ± 0.1% | not timed | not timed | 11139.92 ± 0.9% | | 0.99 | 43.64 | 956.98 |
| reported/i13-subset-regex/big-ascii | 1955 | 10637.98 ± 1.4% | not timed | not timed | 68.01 ± 3.6% | 9.83 ± 0.6% | not timed | not timed | 10692.73 ± 1.5% | | 0.99 | 156.43 | 1082.26 |
| reported/i13-subset-regex/big-unicode | 1955 | 10591.48 ± 27.7% | not timed | not timed | 12.18 ± 55.0% | 9.84 ± 0.1% | not timed | not timed | 10688.89 ± 10.0% | | 0.99 | 869.38 | 1076.31 |
| reported/i13-subset-regex/huge-ascii | 55 | 9927.47 ± 2.4% | not timed | not timed | 11.05 ± 0.0% | 8.73 ± 0.3% | not timed | not timed | 9899.80 ± 2.5% | | 1.00 | 898.77 | 1137.35 |
| reported/i13-subset-regex/huge-unicode | 55 | 9888.84 ± 3.3% | not timed | not timed | 11.02 ± 0.4% | 8.76 ± 0.1% | not timed | not timed | 9828.89 ± 2.6% | | 1.01 | 897.37 | 1128.41 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.56 ± 0.1% | not timed | not timed | 11.00 ± 0.1% | 8.77 ± 0.1% | not timed | not timed | 3.56 ± 0.1% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.05 ± 0.1% | not timed | not timed | 10.97 ± 0.3% | 8.76 ± 1.0% | not timed | not timed | 5.04 ± 0.0% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 486.90 ± 0.3% | not timed | not timed | 104.33 ± 0.2% | 6.63 ± 0.6% | not timed | not timed | 487.62 ± 0.4% | | 1.00 | 4.67 | 73.42 |
| reported/i787-keywords/opt-ascii | 5674 | 488.05 ± 0.3% | not timed | not timed | 273.54 ± 0.1% | 10.28 ± 0.3% | not timed | not timed | 488.32 ± 0.2% | | 1.00 | 1.78 | 47.50 |
| slow/quadratic-regex-1x | 100 | 7.12 ± 0.2% | not timed | not timed | 4.96 ± 0.2% | 0.05 ± 0.4% | not timed | not timed | 7.13 ± 0.3% | | 1.00 | 1.43 | 144.81 |
| slow/quadratic-regex-2x | 199 | 3.44 ± 0.2% | not timed | not timed | 2.76 ± 0.1% | 0.01 ± 0.1% | not timed | not timed | 3.44 ± 0.3% | | 1.00 | 1.24 | 269.76 |
| slow/quadratic-haystack-1x | 100 | 21.27 ± 7.4% | not timed | not timed | 10.00 ± 0.2% | 1.01 ± 13.1% | not timed | not timed | 21.38 ± 1.7% | | 0.99 | 2.13 | 20.96 |
| slow/quadratic-haystack-2x | 200 | 17.66 ± 1.7% | not timed | not timed | 5.53 ± 0.3% | 0.55 ± 6.4% | not timed | not timed | 17.80 ± 1.2% | | 0.99 | 3.19 | 32.35 |
| unicode/codepoints/any-one | 1112064 | 289.86 ± 0.1% | not timed | not timed | 175.44 ± 0.4% | 18.54 ± 1.0% | not timed | not timed | 289.86 ± 0.3% | | 1.00 | 1.65 | 15.63 |
| unicode/codepoints/any-all | 4382592 | 269.81 ± 0.2% | not timed | not timed | 246.68 ± 0.4% | 117.11 ± 0.1% | not timed | not timed | 269.64 ± 0.3% | | 1.00 | 1.09 | 2.30 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.74 ± 1.0% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 602.87 ± 1.1% | not timed | not timed | 615.67 ± 0.3% | 135.32 ± 0.1% | not timed | not timed | 603.22 ± 0.2% | | 1.00 | 0.98 | 4.46 |
| unicode/overlapping-words/ascii | 6156 | 31.57 ± 0.3% | not timed | not timed | 39.00 ± 0.2% | 3.96 ± 0.3% | not timed | not timed | 31.59 ± 0.2% | | 1.00 | 0.81 | 7.98 |
| unicode/overlapping-words/english | 6156 | 1.45 ± 0.1% | not timed | not timed | 4.12 ± 0.1% | 2.35 ± 0.3% | not timed | not timed | 1.45 ± 0.1% | | 1.00 | 0.35 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.6% | not timed | not timed | 4.09 ± 0.2% | 6.23 ± 10.4% | not timed | not timed | 1.29 ± 0.1% | | 0.99 | 0.31 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 128.60 ± 3.2% | not timed | not timed | 82.41 ± 0.1% | 11.45 ± 15.0% | not timed | not timed | 128.78 ± 0.5% | | 1.00 | 1.56 | 11.23 |
| unicode/word/boundary-long-english | 3466 | 615.29 ± 0.1% | not timed | not timed | 606.91 ± 0.1% | 31.99 ± 0.7% | not timed | not timed | 615.17 ± 0.2% | | 1.00 | 1.01 | 19.24 |
| unicode/word/around-holmes-english | 27 | 19902.00 ± 0.2% | not timed | not timed | 19650.11 ± 0.3% | 21.92 ± 0.5% | not timed | not timed | 19876.87 ± 0.2% | | 1.00 | 1.01 | 908.01 |
| wild/bibleref/long | 874 | 563.69 ± 0.1% | not timed | not timed | 583.18 ± 0.1% | 6.61 ± 0.1% | not timed | not timed | 563.79 ± 0.1% | | 1.00 | 0.97 | 85.31 |
| wild/bibleref/short | 30 | 24.77 ± 2.5% | not timed | not timed | 30.67 ± 0.4% | 14.13 ± 14.3% | not timed | not timed | 25.58 ± 4.2% | | 0.97 | 0.81 | 1.75 |
| wild/bibleref/line | 874 | 393.49 ± 5.4% | not timed | not timed | 212.61 ± 0.1% | 9.11 ± 9.2% | not timed | not timed | 393.67 ± 0.2% | | 1.00 | 1.85 | 43.18 |
| wild/caddy/caddy | 6 | 417.81 ± 8.5% | not timed | not timed | 246.95 ± 0.1% | 67.89 ± 13.9% | not timed | not timed | 418.50 ± 0.2% | | 1.00 | 1.69 | 6.15 |
| wild/dot-star-capture/rust-src-tools | 6 | 1068.82 ± 0.5% | not timed | not timed | 344.59 ± 0.6% | 13.47 ± 0.3% | not timed | not timed | 1071.07 ± 0.4% | | 1.00 | 3.10 | 79.35 |
| wild/ruff/noqa | 84 | 436.12 ± 0.1% | not timed | not timed | 463.83 ± 0.1% | 19.58 ± 2.1% | not timed | not timed | 433.84 ± 1.3% | | 1.01 | 0.94 | 22.28 |
| wild/ruff/unnecessary-coding-comment | 16 | 962.41 ± 0.5% | not timed | not timed | 702.41 ± 0.1% | 136.49 ± 10.8% | not timed | not timed | 960.27 ± 0.5% | | 1.00 | 1.37 | 7.05 |
| wild/ruff/string-quote-prefix | 2972 | 1356.71 ± 0.7% | not timed | not timed | 439.24 ± 0.2% | 316.42 ± 25.2% | not timed | not timed | 1356.40 ± 0.5% | | 1.00 | 3.09 | 4.29 |
| wild/ruff/space-around-operator | 1224378 | 220.16 ± 1.8% | not timed | not timed | 183.80 ± 0.1% | 18.45 ± 1.8% | not timed | not timed | 220.95 ± 1.9% | | 1.00 | 1.20 | 11.93 |
| wild/ruff/shebang | 282 | 984.27 ± 0.4% | not timed | not timed | 328.95 ± 0.1% | 118.74 ± 9.4% | not timed | not timed | 988.79 ± 0.4% | | 1.00 | 2.99 | 8.29 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13796.22 ± 0.1% | not timed | not timed | 13770.42 ± 0.2% | 6949.17 ± 0.7% | not timed | not timed | 13820.59 ± 0.3% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12837.47 ± 0.6% | not timed | not timed | 13474.75 ± 0.4% | 6394.97 ± 0.6% | not timed | not timed | 12839.52 ± 0.5% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13194.00 ± 0.3% | not timed | not timed | 13681.90 ± 0.3% | 6617.61 ± 1.2% | not timed | not timed | 13192.59 ± 0.5% | | 1.00 | 0.96 | 1.99 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9556.35 ± 0.3% | not timed | not timed | 13570.83 ± 0.3% | 6730.75 ± 1.6% | not timed | not timed | 9565.56 ± 0.2% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 121.73 ± 13.7% | not timed | not timed | 65.14 ± 0.4% | 2.21 ± 0.5% | not timed | not timed | 122.78 ± 13.9% | | 0.99 | 1.87 | 54.99 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 58.9% | not timed | not timed | 0.01 ± 1.6% | 0.01 ± 12.4% | not timed | not timed | 0.03 ± 2.5% | | 0.98 | 3.09 | 4.01 |
| dictionary/compile/english-15 | 1 | 0.35 ± 25.0% | not timed | not timed | 0.07 ± 1.4% | 0.10 ± 10.2% | not timed | not timed | 0.35 ± 2.6% | | 1.00 | 5.03 | 3.34 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 3.9% | not timed | not timed | 0.02 ± 0.7% | 34.03 ± 8.2% | not timed | not timed | 0.25 ± 17.6% | | 0.99 | 13.23 | 0.0072 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.47 ± 2.5% | not timed | not timed | 11.46 ± 0.2% | 58.84 ± 21.8% | not timed | not timed | 47.60 ± 22.0% | | 1.00 | 4.14 | 0.81 |
| reported/i787-keywords/compile | 1 | 34.03 ± 14.1% | not timed | not timed | 2.10 ± 1.3% | 16.54 ± 27.4% | not timed | not timed | 34.58 ± 2.1% | | 0.98 | 16.18 | 2.06 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 370.46 ± 1.7% | not timed | not timed | 126.40 ± 0.2% | 564.53 ± 9.0% | not timed | not timed | 371.13 ± 1.5% | | 1.00 | 2.93 | 0.66 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.31 ± 1.7% | not timed | not timed | 4.10 ± 0.8% | 43.56 ± 7.7% | not timed | not timed | 47.92 ± 3.1% | | 0.99 | 11.53 | 1.09 |
| unicode/compile/one-letter | 53 | 6.62 ± 8.3% | not timed | not timed | 4.52 ± 0.7% | 65.95 ± 8.8% | not timed | not timed | 6.71 ± 10.3% | | 0.99 | 1.47 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.07 ± 17.2% | not timed | not timed | 0.10 ± 0.6% | 66.79 ± 9.2% | not timed | not timed | 1.09 ± 4.1% | | 0.99 | 10.87 | 0.0160 |
| unicode/compile/fifty-letters-ascii | 1 | 221.12 ± 3.2% | not timed | not timed | 52.93 ± 0.0% | 206.04 ± 16.2% | not timed | not timed | 221.68 ± 3.6% | | 1.00 | 4.18 | 1.07 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 379.22 ± 22.3% | not timed | not timed | 47.14 ± 0.7% | 674.53 ± 29.6% | not timed | not timed | 386.34 ± 1.7% | | 0.98 | 8.04 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 610.50 ± 12.9% | not timed | not timed | 144.85 ± 0.2% | 676.58 ± 27.2% | not timed | not timed | 617.12 ± 3.8% | | 0.99 | 4.21 | 0.90 |
| unicode/compile/negated-class-matches-codepoint | 1 | 319.68 ± 4.5% | not timed | not timed | 50.95 ± 0.2% | 1248.34 ± 13.9% | not timed | not timed | 331.14 ± 4.3% | | 0.97 | 6.27 | 0.26 |
| wild/bibleref/compile | 3 | 5.73 ± 21.3% | not timed | not timed | 1.91 ± 0.6% | 31.32 ± 15.1% | not timed | not timed | 5.88 ± 4.2% | | 0.97 | 3.00 | 0.18 |
| wild/url/compile | 1 | 0.62 ± 17.6% | not timed | not timed | 0.14 ± 0.6% | 0.46 ± 6.7% | not timed | not timed | 0.63 ± 24.0% | | 1.00 | 4.33 | 1.35 |

