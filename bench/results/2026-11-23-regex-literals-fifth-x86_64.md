# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243478352 |
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
| literal: a word | 217 | 31302.09 ± 0.1% | 3832.18 ± 0.3% | 33.52 ± 1.3% | 28653.29 ± 0.5% | 11107.37 ± 9.6% | 13.90 ± 0.7% | 102.63 ± 1.3% | 31300.64 ± 0.2% | 8.17 | 1.00 | 1.09 | 2.82 |
| literal: a word that is not there | 0 | 35918.13 ± 0.2% | 3765.68 ± 0.2% | 33.87 ± 0.5% | 31587.36 ± 0.1% | 35167.70 ± 2.0% | 13.51 ± 2.7% | 89.79 ± 0.7% | 35922.77 ± 0.4% | 9.54 | 1.00 | 1.14 | 1.02 |
| literal: one of four words | 661 | 12515.85 ± 1.3% | 1795.12 ± 0.7% | 17.68 ± 1.0% | 8917.67 ± 3.8% | 27.13 ± 0.5% | 4.09 ± 0.2% | 7.62 ± 0.7% | 12342.83 ± 2.4% | 6.97 | 1.01 | 1.40 | 461.26 |
| literal: a word in any case | 217 | 27401.02 ± 0.7% | 1908.71 ± 0.5% | 23.84 ± 1.7% | 9295.99 ± 1.4% | 51.68 ± 2.7% | refused | differs | 27197.57 ± 1.0% | 14.36 | 1.01 | 2.95 | 530.25 |
| literal: an href attribute | 33 | 27098.90 ± 39.7% | 600.14 ± 0.1% | 29.19 ± 0.5% | 25910.24 ± 1.2% | 2391.65 ± 6.6% | 9.84 ± 2.2% | 92.29 ± 10.3% | 27019.36 ± 13.0% | 45.15 | 1.00 | 1.05 | 11.33 |
| literal: a word, second text | 123 | 32434.63 ± 3.6% | 2872.19 ± 6.9% | 33.04 ± 3.1% | 28556.65 ± 2.0% | 8028.97 ± 8.8% | 18.29 ± 12.4% | 90.17 ± 1.5% | 32479.47 ± 0.3% | 11.29 | 1.00 | 1.14 | 4.04 |
| class: two capitalized words | 1331 | 899.25 ± 3.6% | 587.86 ± 3.2% | 30.28 ± 5.9% | 567.56 ± 0.4% | 45.17 ± 1.1% | 11.72 ± 0.7% | 74.52 ± 0.5% | 905.45 ± 2.0% | 1.53 | 0.99 | 1.58 | 19.91 |
| class: a word that ends in ing | 3399 | 558.18 ± 0.3% | 556.69 ± 0.5% | 18.84 ± 1.1% | 533.42 ± 0.3% | 32.68 ± 3.6% | 6.69 ± 0.5% | 19.76 ± 1.4% | 557.87 ± 0.2% | 1.00 | 1.00 | 1.05 | 17.08 |
| class: a word in capitals | 2332 | 1238.49 ± 1.5% | 592.92 ± 0.2% | 32.29 ± 3.1% | 559.80 ± 0.2% | 48.75 ± 10.6% | 14.32 ± 0.3% | 96.45 ± 0.3% | 1234.53 ± 1.0% | 2.09 | 1.00 | 2.21 | 25.40 |
| class: a number | 8288 | 1883.53 ± 0.4% | 783.24 ± 0.2% | 31.80 ± 3.0% | 1954.06 ± 0.6% | 50.91 ± 12.6% | 0.39 ± 0.9% | 65.95 ± 1.1% | 1881.76 ± 0.6% | 2.40 | 1.00 | 0.96 | 37.00 |
| class: two capitalized words, second text | 5359 | 496.17 ± 0.4% | 502.38 ± 0.4% | 26.81 ± 5.7% | 471.22 ± 0.4% | 38.99 ± 5.9% | 15.65 ± 0.5% | 67.66 ± 0.4% | 493.99 ± 8.1% | 0.99 | 1.00 | 1.05 | 12.73 |
| other: a word between two words | 6104 | 809.97 ± 0.9% | 564.90 ± 0.6% | 26.50 ± 2.4% | 804.51 ± 0.4% | 124.85 ± 13.8% | 8.98 ± 1.7% | 78.71 ± 0.3% | 810.32 ± 3.2% | 1.43 | 1.00 | 1.01 | 6.49 |
| other: a number before a unit, second text | 1481 | 8227.98 ± 1.8% | 1057.73 ± 2.0% | 30.51 ± 3.6% | 8468.26 ± 2.9% | 45.91 ± 1.2% | 16.53 ± 0.2% | 72.33 ± 0.8% | 8146.91 ± 3.1% | 7.78 | 1.01 | 0.97 | 179.24 |
| other: a heading's start tag | 110 | 19508.27 ± 0.7% | 721.75 ± 0.1% | 32.69 ± 1.2% | 2450.54 ± 0.7% | 1781.65 ± 7.1% | 12.25 ± 0.3% | 104.57 ± 0.7% | 19495.12 ± 0.2% | 27.03 | 1.00 | 7.96 | 10.95 |
| other: a whole word | 217 | 23265.09 ± 0.2% | 593.08 ± 0.2% | 33.24 ± 1.0% | 23126.46 ± 2.0% | 53.28 ± 1.0% | 11.75 ± 0.1% | 61.22 ± 1.2% | 23218.24 ± 0.8% | 39.23 | 1.00 | 1.01 | 436.70 |
| other: a line's first word, second text | 3716 | 2362.71 ± 0.7% | 569.28 ± 0.2% | 33.62 ± 3.3% | 2254.28 ± 1.3% | 75.29 ± 3.6% | refused | refused | 2350.48 ± 0.6% | 4.15 | 1.01 | 1.05 | 31.38 |
| other: fourteen octets before an x | 87 | 33864.08 ± 2.1% | 290.03 ± 5.7% | 7.02 ± 0.2% | 3913.09 ± 0.7% | 10.56 ± 0.9% | differs | 17.56 ± 1.8% | 33277.30 ± 3.1% | 116.76 | 1.02 | 8.65 | 3206.84 |
| other: a Greek word | 21815 | 492.97 ± 0.4% | 379.02 ± 1.0% | 34.91 ± 1.0% | 289.81 ± 0.9% | 57.05 ± 14.1% | differs | refused | 491.53 ± 0.4% | 1.30 | 1.00 | 1.70 | 8.64 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 20.44 ± 2.5% | 20.48 ± 0.5% | 0.98 ± 3.8% | 19.72 ± 3.7% | 2.93 ± 4.8% | differs | 4.40 ± 6.0% | 20.40 ± 0.8% | 1.00 | 1.00 | 1.04 | 6.97 |
| a UUID | 32895 | 22.52 ± 0.5% | 22.48 ± 1.7% | 0.67 ± 2.2% | 15.24 ± 0.8% | 2.97 ± 0.2% | 0.66 ± 1.3% | 3.48 ± 2.6% | 22.52 ± 0.1% | 1.00 | 1.00 | 1.48 | 7.59 |
| an IPv4 address | 33176 | 32.69 ± 1.1% | 32.80 ± 0.6% | 2.16 ± 0.5% | 28.98 ± 6.1% | 7.01 ± 0.3% | differs | 4.18 ± 0.9% | 32.79 ± 1.6% | 1.00 | 1.00 | 1.13 | 4.66 |
| a date and time | 32954 | 31.73 ± 0.2% | 31.77 ± 9.4% | 1.53 ± 15.4% | 22.07 ± 0.1% | 9.08 ± 0.6% | 1.22 ± 0.5% | 7.88 ± 1.1% | 31.72 ± 0.6% | 1.00 | 1.00 | 1.44 | 3.49 |
| a field path | 32606 | 22.84 ± 0.5% | 22.82 ± 0.5% | 1.13 ± 0.6% | 22.74 ± 0.9% | 3.28 ± 2.4% | differs | 2.75 ± 3.2% | 22.77 ± 3.0% | 1.00 | 1.00 | 1.00 | 6.96 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.19 ± 0.8% | 11.18 ± 2.3% | 11.20 ± 2.8% | 13.82 ± 1.1% | 5.95 ± 3.2% | 0.96 ± 3.3% | none | 11.17 ± 0.9% | 1.00 | 1.00 | 0.81 | 1.88 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 275.92 ± 4.6% | 276.02 ± 4.1% | 326.80 ± 0.6% | 102.11 ± 2.0% | 206.88 ± 12.2% | 650.31 ± 3.3% | 3574.57 ± 0.6% | 276.09 ± 0.2% | 1.00 | 1.00 | 2.70 | 1.33 |
| a UUID | 62 | 181.89 ± 0.4% | 182.52 ± 0.2% | 201.59 ± 0.9% | 54.34 ± 0.4% | 106.04 ± 13.8% | 229.99 ± 1.8% | 4047.50 ± 1.7% | 181.91 ± 0.4% | 1.00 | 1.00 | 3.35 | 1.72 |
| an IPv4 address | 29 | 552.53 ± 0.6% | 559.18 ± 1.4% | 785.28 ± 0.7% | 89.51 ± 0.9% | 140.62 ± 0.9% | 407.33 ± 1.7% | 7425.81 ± 1.0% | 553.41 ± 0.2% | 0.99 | 1.00 | 6.17 | 3.93 |
| a date and time | 56 | 407.10 ± 0.9% | 410.56 ± 0.7% | 511.93 ± 0.8% | 86.82 ± 2.4% | 145.05 ± 7.0% | 427.36 ± 22.3% | 4326.71 ± 8.2% | 406.40 ± 0.8% | 0.99 | 1.00 | 4.69 | 2.81 |
| a field path | 39 | 272.95 ± 0.6% | 274.93 ± 9.7% | 321.00 ± 0.6% | 93.70 ± 3.1% | 220.88 ± 1.8% | 666.34 ± 12.8% | 4328.97 ± 0.8% | 272.70 ± 1.4% | 0.99 | 1.00 | 2.91 | 1.24 |
| literal: a word | 7 | 783.98 ± 2.7% | 848.80 ± 0.6% | 1541.42 ± 1.1% | 639.36 ± 4.9% | 723.09 ± 7.6% | 1381.01 ± 15.7% | 28817.40 ± 24.2% | 783.38 ± 2.3% | 0.92 | 1.00 | 1.23 | 1.08 |
| literal: a word that is not there | 8 | 743.08 ± 16.0% | 819.62 ± 10.1% | 1441.02 ± 17.4% | 593.65 ± 23.6% | 694.45 ± 15.7% | 1292.24 ± 3.5% | 27338.75 ± 2.3% | 744.33 ± 0.6% | 0.91 | 1.00 | 1.25 | 1.07 |
| literal: one of four words | 26 | 309.02 ± 0.5% | 498.97 ± 3.5% | 678.04 ± 4.7% | 45.84 ± 13.3% | 270.67 ± 20.0% | 474.96 ± 32.4% | 13363.63 ± 34.4% | 308.61 ± 3.7% | 0.62 | 1.00 | 6.74 | 1.14 |
| literal: a word in any case | 11 | 565.75 ± 1.9% | 604.31 ± 3.9% | 864.33 ± 7.7% | 15.30 ± 9.0% | 753.92 ± 11.6% | refused | 21965.95 ± 14.2% | 546.15 ± 8.6% | 0.94 | 1.04 | 36.98 | 0.75 |
| literal: an href attribute | 12 | 434.31 ± 13.5% | 447.93 ± 38.2% | 580.26 ± 24.0% | 45.40 ± 2.6% | 548.86 ± 3.9% | 1110.91 ± 3.5% | 19288.37 ± 8.2% | 433.64 ± 4.5% | 0.97 | 1.00 | 9.57 | 0.79 |
| literal: a word, second text | 10 | 683.20 ± 2.8% | 757.77 ± 3.9% | 1296.07 ± 6.6% | 542.00 ± 1.1% | 592.48 ± 23.3% | 1132.43 ± 4.5% | 24684.29 ± 8.3% | 695.69 ± 6.3% | 0.90 | 0.98 | 1.26 | 1.15 |
| class: two capitalized words | 23 | 601.27 ± 1.2% | 655.00 ± 0.3% | 961.19 ± 0.7% | 126.40 ± 0.4% | 557.98 ± 2.2% | 1043.67 ± 4.5% | 6541.88 ± 1.1% | 600.03 ± 4.7% | 0.92 | 1.00 | 4.76 | 1.08 |
| class: a word that ends in ing | 9 | 732.22 ± 0.5% | 840.43 ± 3.6% | 1444.80 ± 1.1% | 160.31 ± 0.5% | 817.68 ± 6.3% | 1633.56 ± 3.2% | 15842.34 ± 2.8% | 732.69 ± 0.2% | 0.87 | 1.00 | 4.57 | 0.90 |
| class: a word in capitals | 16 | 685.76 ± 15.1% | 738.22 ± 29.5% | 1188.65 ± 9.8% | 166.30 ± 5.9% | 830.29 ± 1.0% | 1534.49 ± 1.8% | 8712.19 ± 1.1% | 684.64 ± 0.2% | 0.93 | 1.00 | 4.12 | 0.83 |
| class: a number | 6 | 853.28 ± 0.4% | 949.09 ± 0.7% | 1723.38 ± 3.8% | 41.20 ± 8.2% | 1514.24 ± 1.0% | 2810.46 ± 3.6% | 21184.03 ± 8.7% | 851.60 ± 6.7% | 0.90 | 1.00 | 20.71 | 0.56 |
| class: two capitalized words, second text | 23 | 600.33 ± 6.0% | 651.50 ± 6.8% | 961.32 ± 0.4% | 125.36 ± 0.2% | 549.72 ± 3.1% | 1044.13 ± 2.9% | 6564.93 ± 0.4% | 602.44 ± 0.6% | 0.92 | 1.00 | 4.79 | 1.09 |
| other: a word between two words | 13 | 699.03 ± 0.9% | 731.50 ± 2.5% | 1144.69 ± 0.8% | 164.73 ± 1.3% | 553.17 ± 1.6% | 1142.57 ± 0.8% | 13870.17 ± 0.8% | 699.18 ± 2.4% | 0.96 | 1.00 | 4.24 | 1.26 |
| other: a number before a unit, second text | 15 | 510.43 ± 3.2% | 569.52 ± 0.5% | 786.96 ± 0.8% | 39.09 ± 1.5% | 690.22 ± 11.8% | 1256.28 ± 17.0% | 13670.22 ± 23.8% | 511.08 ± 6.9% | 0.90 | 1.00 | 13.06 | 0.74 |
| other: a heading's start tag | 13 | 449.46 ± 0.6% | 457.88 ± 0.6% | 598.78 ± 3.2% | 44.10 ± 9.1% | 684.04 ± 5.2% | 1224.50 ± 1.3% | 17105.45 ± 1.0% | 446.74 ± 10.9% | 0.98 | 1.01 | 10.19 | 0.66 |
| other: a whole word | 11 | 719.34 ± 0.7% | 770.70 ± 1.3% | 1258.92 ± 4.2% | 140.31 ± 2.5% | 636.46 ± 1.4% | 1166.03 ± 1.8% | 24173.61 ± 2.1% | 720.54 ± 0.6% | 0.93 | 1.00 | 5.13 | 1.13 |
| other: a line's first word, second text | 17 | 698.08 ± 0.3% | 742.85 ± 0.3% | 1201.09 ± 0.4% | 158.31 ± 0.4% | 768.53 ± 1.4% | refused | refused | 697.90 ± 3.9% | 0.94 | 1.00 | 4.41 | 0.91 |
| other: fourteen octets before an x | 16 | 124.15 ± 1.0% | 176.31 ± 2.2% | 204.10 ± 1.6% | 16.91 ± 0.5% | 488.96 ± 1.9% | 541.81 ± 3.2% | 13017.51 ± 1.3% | 123.95 ± 0.5% | 0.70 | 1.00 | 7.34 | 0.25 |
| other: a Greek word | 8 | 558.10 ± 0.6% | 768.60 ± 0.3% | 1294.66 ± 0.5% | 56.31 ± 0.5% | 1510.71 ± 1.8% | 2688.75 ± 0.4% | refused | 557.93 ± 0.3% | 0.73 | 1.00 | 9.91 | 0.37 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 25669.78 ± 2.1% | not timed | not timed | 25098.55 ± 0.7% | 2261.13 ± 23.1% | not timed | not timed | 23462.16 ± 25.1% | | 1.09 | 1.02 | 11.35 |
| 01-literal/sherlock-casei-en | 522 | 9704.69 ± 2.5% | not timed | not timed | 7826.20 ± 0.3% | 35.33 ± 1.3% | not timed | not timed | 9583.51 ± 1.3% | | 1.01 | 1.24 | 274.66 |
| 01-literal/sherlock-ru | 724 | 26058.35 ± 31.9% | not timed | not timed | 25174.49 ± 3.5% | 1243.91 ± 13.9% | not timed | not timed | 25941.30 ± 11.9% | | 1.00 | 1.04 | 20.95 |
| 01-literal/sherlock-casei-ru | 746 | 10664.04 ± 0.8% | not timed | not timed | 6160.52 ± 1.7% | 38.11 ± 2.1% | not timed | not timed | 10703.71 ± 2.3% | | 1.00 | 1.73 | 279.82 |
| 01-literal/sherlock-zh | 30 | 33860.91 ± 2.5% | not timed | not timed | 29929.78 ± 4.5% | 1464.30 ± 8.3% | not timed | not timed | 33827.77 ± 12.8% | | 1.00 | 1.13 | 23.12 |
| 02-literal-alternate/sherlock-en | 714 | 11428.66 ± 7.9% | not timed | not timed | 8677.22 ± 0.5% | 20.85 ± 2.6% | not timed | not timed | 11413.23 ± 1.4% | | 1.00 | 1.32 | 548.25 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2051.33 ± 1.0% | not timed | not timed | 2231.50 ± 4.1% | 12.19 ± 0.6% | not timed | not timed | 2040.97 ± 4.1% | | 1.01 | 0.92 | 168.32 |
| 02-literal-alternate/sherlock-ru | 899 | 9246.56 ± 0.3% | not timed | not timed | 4707.52 ± 0.6% | 26.80 ± 0.3% | not timed | not timed | 9255.80 ± 0.3% | | 1.00 | 1.96 | 345.02 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2210.95 ± 4.3% | not timed | not timed | 1147.25 ± 20.9% | 10.19 ± 18.9% | not timed | not timed | 2197.11 ± 0.7% | | 1.01 | 1.93 | 216.99 |
| 02-literal-alternate/sherlock-zh | 207 | 15670.59 ± 0.5% | not timed | not timed | 9934.42 ± 0.2% | 38.59 ± 0.3% | not timed | not timed | 15665.45 ± 0.4% | | 1.00 | 1.58 | 406.09 |
| 03-date/ascii | 111817 | 116.23 ± 21.4% | not timed | not timed | 102.15 ± 1.4% | 0.23 ± 3.0% | not timed | not timed | 115.61 ± 12.3% | | 1.01 | 1.14 | 497.07 |
| 04-ruff-noqa/real | 84 | 513.44 ± 0.2% | not timed | not timed | 526.54 ± 0.4% | 23.15 ± 0.9% | not timed | not timed | 513.03 ± 0.4% | | 1.00 | 0.98 | 22.18 |
| 04-ruff-noqa/tweaked | 44 | 587.55 ± 22.0% | not timed | not timed | 520.77 ± 0.5% | 417.46 ± 0.8% | not timed | not timed | 590.65 ± 2.2% | | 0.99 | 1.13 | 1.41 |
| 05-lexer-veryl/single | 124800 | 5.15 ± 4.7% | not timed | not timed | 5.43 ± 11.8% | 0.24 ± 5.7% | not timed | not timed | 5.09 ± 6.3% | | 1.01 | 0.95 | 21.85 |
| 06-cloud-flare-redos/original | 107 | 437.15 ± 3.5% | not timed | not timed | 229.61 ± 1.0% | 28.75 ± 1.3% | not timed | not timed | 439.11 ± 2.5% | | 1.00 | 1.90 | 15.20 |
| 06-cloud-flare-redos/simplified-short | 102 | 429.36 ± 7.3% | not timed | not timed | 207.67 ± 4.8% | 30.74 ± 17.8% | not timed | not timed | 429.06 ± 29.8% | | 1.00 | 2.07 | 13.97 |
| 06-cloud-flare-redos/simplified-long | 10000 | 516.76 ± 4.2% | not timed | not timed | 248.03 ± 4.7% | 33.72 ± 5.9% | not timed | not timed | 517.99 ± 3.2% | | 1.00 | 2.08 | 15.33 |
| 07-unicode-character-data/parse-line | 558784 | 264.29 ± 3.8% | not timed | not timed | 195.44 ± 3.7% | 46.05 ± 7.5% | not timed | not timed | 245.76 ± 14.6% | | 1.08 | 1.35 | 5.74 |
| 08-words/all-english | 56691 | 104.18 ± 0.7% | not timed | not timed | 86.34 ± 3.8% | 13.06 ± 11.1% | not timed | not timed | 103.92 ± 4.2% | | 1.00 | 1.21 | 7.98 |
| 08-words/long-english | 839 | 598.61 ± 3.1% | not timed | not timed | 577.38 ± 2.7% | 34.03 ± 1.6% | not timed | not timed | 599.39 ± 1.6% | | 1.00 | 1.04 | 17.59 |
| 09-aws-keys/full | 0 | 523.88 ± 2.1% | not timed | not timed | 530.31 ± 5.6% | 73.19 ± 2.2% | not timed | not timed | 523.54 ± 0.4% | | 1.00 | 0.99 | 7.16 |
| 09-aws-keys/quick | 0 | 1146.85 ± 3.8% | not timed | not timed | 871.84 ± 1.8% | 495.47 ± 17.7% | not timed | not timed | 1146.58 ± 3.8% | | 1.00 | 1.32 | 2.31 |
| 10-bounded-repeat/letters-en | 1833 | 618.52 ± 2.9% | not timed | not timed | 527.12 ± 0.5% | 22.04 ± 0.6% | not timed | not timed | 603.82 ± 2.4% | | 1.02 | 1.17 | 28.07 |
| 10-bounded-repeat/letters-ru | 3475 | 514.71 ± 0.9% | not timed | not timed | 473.82 ± 0.6% | 22.88 ± 8.8% | not timed | not timed | 510.15 ± 1.7% | | 1.01 | 1.09 | 22.50 |
| 10-bounded-repeat/context | 53 | 82.20 ± 1.7% | not timed | not timed | 69.69 ± 0.6% | 22.35 ± 1.2% | not timed | not timed | 81.74 ± 2.9% | | 1.01 | 1.18 | 3.68 |
| 10-bounded-repeat/capitals | 11 | 621.95 ± 8.1% | not timed | not timed | 594.92 ± 0.2% | 41.26 ± 9.6% | not timed | not timed | 620.35 ± 8.2% | | 1.00 | 1.05 | 15.07 |
| 11-unstructured-to-json/extract | 600 | 76.19 ± 0.2% | not timed | not timed | 75.18 ± 0.4% | 57.91 ± 2.0% | not timed | not timed | 76.15 ± 0.8% | | 1.00 | 1.01 | 1.32 |
| 12-dictionary/single | 1 | 528.61 ± 0.3% | not timed | not timed | 506.30 ± 0.3% | 0.44 ± 0.2% | not timed | not timed | 529.23 ± 0.1% | | 1.00 | 1.04 | 1195.20 |
| 14-quadratic/1x | 100 | 26.87 ± 0.9% | not timed | not timed | 12.71 ± 0.5% | 1.15 ± 0.8% | not timed | not timed | 26.91 ± 3.1% | | 1.00 | 2.12 | 23.30 |
| 14-quadratic/2x | 200 | 20.96 ± 1.6% | not timed | not timed | 6.20 ± 0.5% | 0.64 ± 2.0% | not timed | not timed | 20.92 ± 4.1% | | 1.00 | 3.38 | 32.79 |
| 14-quadratic/10x | 1000 | 6.59 ± 0.2% | not timed | not timed | 1.20 ± 0.7% | 0.14 ± 3.0% | not timed | not timed | 6.58 ± 0.6% | | 1.00 | 5.50 | 47.87 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.51 ± 0.2% | not timed | not timed | 0.39 ± 2.2% | 0.61 ± 5.5% | not timed | not timed | 1.50 ± 0.8% | | 1.00 | 3.84 | 2.47 |
| 04-ruff-noqa/compile-real | 1 | 113.62 ± 0.3% | not timed | not timed | 14.17 ± 0.8% | 157.25 ± 2.6% | not timed | not timed | 113.15 ± 0.7% | | 1.00 | 8.02 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 17.88 ± 0.6% | not timed | not timed | 2.69 ± 0.3% | 7.16 ± 2.4% | not timed | not timed | 17.79 ± 0.7% | | 1.00 | 6.65 | 2.50 |
| 07-unicode-character-data/compile | 1 | 67.61 ± 0.4% | not timed | not timed | 28.80 ± 0.2% | 39.55 ± 2.6% | not timed | not timed | 66.77 ± 0.9% | | 1.01 | 2.35 | 1.71 |
| 09-aws-keys/compile-full | 1 | 44.70 ± 0.9% | not timed | not timed | 8.01 ± 2.2% | 25.76 ± 1.5% | not timed | not timed | 43.90 ± 0.7% | | 1.02 | 5.58 | 1.73 |
| 09-aws-keys/compile-quick | 1 | 214.45 ± 2.8% | not timed | not timed | 54.32 ± 10.5% | 147.10 ± 12.1% | not timed | not timed | 213.23 ± 1.4% | | 1.01 | 3.95 | 1.46 |
| 10-bounded-repeat/compile-context | 1 | 13.53 ± 0.6% | not timed | not timed | 12.78 ± 0.2% | 18.62 ± 3.8% | not timed | not timed | 13.50 ± 0.9% | | 1.00 | 1.06 | 0.73 |
| 10-bounded-repeat/compile-capitals | 1 | 82.01 ± 2.6% | not timed | not timed | 9.56 ± 0.7% | 27.14 ± 3.3% | not timed | not timed | 79.82 ± 1.5% | | 1.03 | 8.57 | 3.02 |
| 11-unstructured-to-json/compile | 1 | 102.38 ± 0.6% | not timed | not timed | 45.57 ± 2.9% | 74.70 ± 2.9% | not timed | not timed | 100.75 ± 1.4% | | 1.02 | 2.25 | 1.37 |
| 12-dictionary/compile-single | 1 | 0.34 ± 2.5% | not timed | not timed | 0.07 ± 0.7% | 0.11 ± 12.1% | not timed | not timed | 0.34 ± 1.7% | | 1.01 | 4.64 | 3.01 |

