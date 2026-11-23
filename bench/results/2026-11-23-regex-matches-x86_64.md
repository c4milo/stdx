# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127322370 |
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
| literal: a word | 217 | 32347.84 ± 4.4% | 841.72 ± 0.3% | 19.90 ± 3.6% | 31029.07 ± 0.2% | 8880.40 ± 9.4% | 10.67 ± 0.3% | 76.24 ± 1.1% | 31990.21 ± 1.4% | 38.43 | 1.01 | 1.04 | 3.64 |
| literal: a word that is not there | 0 | 49259.15 ± 2.8% | 848.54 ± 0.4% | 19.63 ± 1.5% | 39496.11 ± 4.8% | 30286.03 ± 0.4% | 10.63 ± 0.1% | 72.51 ± 0.7% | 48457.91 ± 30.8% | 58.05 | 1.02 | 1.25 | 1.63 |
| literal: one of four words | 661 | 10988.71 ± 0.4% | 823.15 ± 0.2% | 10.94 ± 0.5% | 9122.41 ± 0.4% | 19.03 ± 1.9% | 3.99 ± 0.1% | 6.67 ± 0.3% | 10975.16 ± 1.0% | 13.35 | 1.00 | 1.20 | 577.49 |
| literal: a word in any case | 217 | 25794.36 ± 0.7% | 841.26 ± 0.2% | 14.73 ± 1.1% | 9232.52 ± 0.6% | 37.12 ± 5.8% | refused | differs | 25598.31 ± 0.4% | 30.66 | 1.01 | 2.79 | 694.91 |
| literal: an href attribute | 33 | 27367.98 ± 1.7% | 847.42 ± 0.2% | 18.24 ± 0.3% | 27359.33 ± 0.4% | 2055.44 ± 0.9% | 8.17 ± 0.4% | 61.16 ± 0.8% | 26947.43 ± 1.7% | 32.30 | 1.02 | 1.00 | 13.31 |
| literal: a word, second text | 123 | 33827.92 ± 1.2% | 844.62 ± 0.6% | 19.79 ± 2.9% | 31929.72 ± 1.0% | 7159.06 ± 6.5% | 11.72 ± 4.2% | 65.44 ± 18.0% | 33204.36 ± 7.7% | 40.05 | 1.02 | 1.06 | 4.73 |
| class: two capitalized words | 1331 | 785.24 ± 1.9% | 787.00 ± 0.2% | 18.56 ± 2.2% | 505.96 ± 1.1% | 34.22 ± 10.0% | 9.23 ± 0.4% | 55.63 ± 0.3% | 785.34 ± 0.4% | 1.00 | 1.00 | 1.55 | 22.95 |
| class: a word that ends in ing | 3399 | 715.28 ± 1.4% | 715.84 ± 3.7% | 12.86 ± 2.9% | 472.59 ± 1.3% | 25.55 ± 6.9% | 5.33 ± 2.1% | 17.12 ± 9.6% | 707.88 ± 1.5% | 1.00 | 1.01 | 1.51 | 27.99 |
| class: a word in capitals | 2332 | 986.92 ± 0.2% | 763.60 ± 2.8% | 17.19 ± 0.7% | 495.49 ± 0.6% | 36.36 ± 6.6% | 10.28 ± 0.2% | 76.38 ± 0.2% | 986.03 ± 3.3% | 1.29 | 1.00 | 1.99 | 27.15 |
| class: a number | 8288 | 1422.53 ± 0.2% | 658.59 ± 1.7% | 19.12 ± 0.8% | 1456.84 ± 0.5% | 34.99 ± 12.4% | 0.33 ± 0.4% | 55.70 ± 6.1% | 1425.95 ± 0.3% | 2.16 | 1.00 | 0.98 | 40.66 |
| class: two capitalized words, second text | 5359 | 593.60 ± 2.6% | 593.46 ± 0.2% | 16.75 ± 7.3% | 417.84 ± 0.2% | 29.07 ± 6.8% | 10.47 ± 0.1% | 51.63 ± 0.4% | 593.24 ± 0.3% | 1.00 | 1.00 | 1.42 | 20.42 |
| other: a word between two words | 6104 | 641.91 ± 0.9% | 618.97 ± 0.3% | 16.79 ± 2.4% | 693.07 ± 0.2% | 96.10 ± 15.3% | 7.20 ± 0.5% | 56.55 ± 0.8% | 641.79 ± 0.4% | 1.04 | 1.00 | 0.93 | 6.68 |
| other: a number before a unit, second text | 1481 | 6621.64 ± 0.7% | 792.53 ± 1.2% | 18.55 ± 2.3% | 6422.82 ± 0.4% | 34.95 ± 7.5% | 10.87 ± 0.5% | 55.12 ± 0.3% | 6534.11 ± 4.2% | 8.36 | 1.01 | 1.03 | 189.48 |
| other: a heading's start tag | 110 | 18752.77 ± 3.8% | 840.19 ± 0.6% | 19.25 ± 1.2% | 2006.66 ± 0.5% | 1476.29 ± 3.7% | 9.95 ± 0.2% | 72.63 ± 0.3% | 18451.50 ± 1.1% | 22.32 | 1.02 | 9.35 | 12.70 |
| other: a whole word | 217 | 22800.70 ± 10.0% | 842.34 ± 0.2% | 19.45 ± 4.4% | 22259.49 ± 5.3% | 40.66 ± 2.3% | 9.40 ± 0.2% | 46.98 ± 0.5% | 22333.74 ± 5.0% | 27.07 | 1.02 | 1.02 | 560.73 |
| other: a line's first word, second text | 3716 | 1714.54 ± 0.3% | 705.17 ± 0.2% | 22.06 ± 0.5% | 1700.38 ± 1.1% | 53.27 ± 3.4% | refused | refused | 1708.91 ± 0.4% | 2.43 | 1.00 | 1.01 | 32.19 |
| other: fourteen octets before an x | 87 | 25594.50 ± 1.8% | 218.72 ± 1.0% | 5.10 ± 0.5% | 2763.99 ± 1.4% | 9.00 ± 6.0% | differs | 15.55 ± 1.8% | 25433.56 ± 0.7% | 117.02 | 1.01 | 9.26 | 2845.14 |
| other: a Greek word | 21815 | 396.14 ± 1.1% | 289.15 ± 0.5% | 23.18 ± 0.9% | 265.30 ± 0.3% | 43.89 ± 7.3% | differs | refused | 395.14 ± 1.2% | 1.37 | 1.00 | 1.49 | 9.03 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.53 ± 3.0% | 24.33 ± 11.1% | 0.71 ± 1.3% | 16.78 ± 2.1% | 2.34 ± 2.7% | differs | 3.57 ± 2.4% | 24.22 ± 3.3% | 1.01 | 1.01 | 1.46 | 10.48 |
| a UUID | 32895 | 20.61 ± 0.4% | 20.61 ± 0.3% | 0.55 ± 4.1% | 12.82 ± 0.7% | 2.55 ± 1.0% | 0.44 ± 0.1% | 3.10 ± 0.4% | 20.60 ± 0.4% | 1.00 | 1.00 | 1.61 | 8.09 |
| an IPv4 address | 33176 | 33.31 ± 0.5% | 33.95 ± 0.2% | 1.75 ± 6.8% | 23.92 ± 0.1% | 5.77 ± 0.6% | differs | 3.41 ± 0.6% | 34.40 ± 0.3% | 0.98 | 0.97 | 1.39 | 5.78 |
| a date and time | 32954 | 30.34 ± 0.9% | 30.36 ± 0.1% | 1.27 ± 2.7% | 17.87 ± 0.4% | 6.68 ± 13.1% | 0.76 ± 10.3% | 6.19 ± 0.5% | 30.33 ± 0.4% | 1.00 | 1.00 | 1.70 | 4.54 |
| a field path | 32606 | 27.22 ± 1.3% | 27.33 ± 0.4% | 0.78 ± 10.2% | 19.15 ± 8.0% | 2.93 ± 15.1% | differs | 2.46 ± 0.9% | 27.29 ± 0.6% | 1.00 | 1.00 | 1.42 | 9.28 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.25 ± 2.5% | 8.30 ± 2.2% | 8.35 ± 0.4% | 10.66 ± 0.1% | 4.71 ± 2.3% | 0.62 ± 2.4% | none | 8.34 ± 2.0% | 0.99 | 0.99 | 0.77 | 1.75 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 186.56 ± 7.0% | 187.33 ± 0.8% | 217.27 ± 7.7% | 79.93 ± 3.0% | 183.10 ± 1.9% | 534.94 ± 4.2% | 3973.31 ± 0.8% | 187.04 ± 0.4% | 1.00 | 1.00 | 2.33 | 1.02 |
| a UUID | 62 | 121.79 ± 0.2% | 121.85 ± 7.7% | 134.65 ± 0.3% | 46.67 ± 8.5% | 90.46 ± 9.5% | 198.87 ± 1.8% | 4110.54 ± 4.2% | 120.74 ± 5.7% | 1.00 | 1.01 | 2.61 | 1.35 |
| an IPv4 address | 29 | 395.96 ± 1.2% | 395.12 ± 1.1% | 549.29 ± 9.3% | 69.72 ± 1.1% | 113.00 ± 2.1% | 332.16 ± 2.4% | 7179.83 ± 6.5% | 395.72 ± 1.5% | 1.00 | 1.00 | 5.68 | 3.50 |
| a date and time | 56 | 285.42 ± 0.3% | 286.66 ± 0.5% | 358.67 ± 0.4% | 68.64 ± 1.5% | 121.86 ± 1.5% | 371.12 ± 1.1% | 4236.50 ± 11.7% | 285.16 ± 0.4% | 1.00 | 1.00 | 4.16 | 2.34 |
| a field path | 39 | 182.34 ± 0.2% | 182.69 ± 0.4% | 211.09 ± 0.8% | 74.43 ± 3.0% | 171.50 ± 16.1% | 577.09 ± 3.9% | 4810.94 ± 2.2% | 182.26 ± 0.1% | 1.00 | 1.00 | 2.45 | 1.06 |
| literal: a word | 7 | 595.23 ± 0.9% | 630.75 ± 0.9% | 1109.20 ± 0.9% | 489.68 ± 0.4% | 569.60 ± 6.2% | 1243.30 ± 2.6% | 25015.41 ± 1.3% | 594.15 ± 0.6% | 0.94 | 1.00 | 1.22 | 1.04 |
| literal: a word that is not there | 8 | 571.86 ± 0.2% | 609.53 ± 19.2% | 1045.30 ± 1.0% | 448.42 ± 0.8% | 549.69 ± 3.3% | 1172.13 ± 0.8% | 23859.98 ± 0.7% | 570.33 ± 0.9% | 0.94 | 1.00 | 1.28 | 1.04 |
| literal: one of four words | 26 | 220.49 ± 0.5% | 364.92 ± 0.2% | 489.62 ± 0.2% | 41.51 ± 1.0% | 211.78 ± 5.6% | 455.10 ± 2.2% | 11533.86 ± 0.8% | 220.46 ± 0.6% | 0.60 | 1.00 | 5.31 | 1.04 |
| literal: a word in any case | 11 | 451.04 ± 0.6% | 475.76 ± 6.3% | 724.41 ± 0.3% | 14.38 ± 1.4% | 599.08 ± 0.6% | refused | 19294.59 ± 3.5% | 449.90 ± 0.8% | 0.95 | 1.00 | 31.38 | 0.75 |
| literal: an href attribute | 12 | 317.93 ± 0.6% | 329.95 ± 1.2% | 431.28 ± 0.7% | 36.12 ± 2.0% | 420.91 ± 2.1% | 962.83 ± 2.4% | 18541.74 ± 1.5% | 318.43 ± 1.4% | 0.96 | 1.00 | 8.80 | 0.76 |
| literal: a word, second text | 10 | 528.51 ± 1.2% | 574.51 ± 1.3% | 949.76 ± 0.4% | 406.25 ± 1.8% | 478.62 ± 2.1% | 995.14 ± 0.8% | 21266.44 ± 0.8% | 527.95 ± 0.3% | 0.92 | 1.00 | 1.30 | 1.10 |
| class: two capitalized words | 23 | 421.58 ± 0.3% | 450.58 ± 2.2% | 652.45 ± 2.9% | 93.98 ± 1.3% | 437.07 ± 1.0% | 939.84 ± 0.5% | 6387.18 ± 1.1% | 422.15 ± 0.7% | 0.94 | 1.00 | 4.49 | 0.96 |
| class: a word that ends in ing | 9 | 513.91 ± 0.7% | 575.83 ± 0.6% | 1006.26 ± 0.4% | 112.31 ± 1.7% | 608.36 ± 1.7% | 1400.76 ± 0.6% | 15286.34 ± 0.9% | 512.97 ± 1.5% | 0.89 | 1.00 | 4.58 | 0.84 |
| class: a word in capitals | 16 | 447.11 ± 0.4% | 480.86 ± 5.2% | 784.45 ± 1.6% | 119.81 ± 0.6% | 627.34 ± 3.0% | 1308.16 ± 1.6% | 8379.89 ± 0.1% | 446.91 ± 1.1% | 0.93 | 1.00 | 3.73 | 0.71 |
| class: a number | 6 | 562.24 ± 0.4% | 614.56 ± 0.6% | 1158.04 ± 4.1% | 35.88 ± 1.6% | 1126.95 ± 2.8% | 2334.71 ± 6.4% | 20416.27 ± 1.4% | 561.46 ± 0.5% | 0.91 | 1.00 | 15.67 | 0.50 |
| class: two capitalized words, second text | 23 | 422.11 ± 3.1% | 446.96 ± 2.2% | 639.00 ± 3.4% | 94.38 ± 4.0% | 435.37 ± 7.1% | 940.56 ± 3.2% | 6362.38 ± 6.1% | 415.79 ± 2.5% | 0.94 | 1.02 | 4.47 | 0.97 |
| other: a word between two words | 13 | 505.58 ± 1.9% | 521.62 ± 0.5% | 813.46 ± 0.6% | 120.43 ± 0.7% | 422.99 ± 1.5% | 1023.12 ± 1.1% | 14059.74 ± 0.5% | 505.30 ± 2.4% | 0.97 | 1.00 | 4.20 | 1.20 |
| other: a number before a unit, second text | 15 | 358.77 ± 0.6% | 393.39 ± 0.5% | 543.18 ± 0.2% | 33.41 ± 1.3% | 529.53 ± 1.0% | 1129.58 ± 2.3% | 13891.92 ± 1.1% | 357.75 ± 1.0% | 0.91 | 1.00 | 10.74 | 0.68 |
| other: a heading's start tag | 13 | 330.96 ± 0.4% | 336.26 ± 0.9% | 442.39 ± 1.5% | 35.11 ± 0.7% | 511.83 ± 3.3% | 1102.59 ± 1.8% | 16387.08 ± 0.4% | 330.54 ± 1.8% | 0.98 | 1.00 | 9.43 | 0.65 |
| other: a whole word | 11 | 513.68 ± 0.6% | 543.69 ± 0.8% | 869.86 ± 0.6% | 110.71 ± 0.9% | 498.83 ± 2.0% | 1054.67 ± 10.1% | 20844.62 ± 0.4% | 514.01 ± 0.2% | 0.94 | 1.00 | 4.64 | 1.03 |
| other: a line's first word, second text | 17 | 487.57 ± 1.7% | 507.71 ± 2.8% | 827.37 ± 0.6% | 114.20 ± 1.5% | 572.04 ± 1.8% | refused | refused | 486.31 ± 0.5% | 0.96 | 1.00 | 4.27 | 0.85 |
| other: fourteen octets before an x | 16 | 87.16 ± 0.8% | 124.21 ± 0.3% | 142.49 ± 0.5% | 14.18 ± 0.8% | 392.42 ± 2.8% | 447.41 ± 1.8% | 11695.64 ± 0.4% | 87.17 ± 1.8% | 0.70 | 1.00 | 6.14 | 0.22 |
| other: a Greek word | 8 | 375.48 ± 0.5% | 511.25 ± 0.2% | 838.47 ± 1.0% | 46.65 ± 0.5% | 1113.24 ± 2.0% | 2266.82 ± 1.3% | refused | 375.21 ± 0.5% | 0.73 | 1.00 | 8.05 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21175.60 ± 1.9% | not timed | not timed | 26759.69 ± 1.3% | 1944.24 ± 14.6% | not timed | not timed | 20963.03 ± 0.9% | | 1.01 | 0.79 | 10.89 |
| 01-literal/sherlock-casei-en | 522 | 4647.13 ± 0.6% | not timed | not timed | 7023.48 ± 0.7% | 28.52 ± 0.8% | not timed | not timed | 4595.30 ± 0.5% | | 1.01 | 0.66 | 162.95 |
| 01-literal/sherlock-ru | 724 | 22961.20 ± 1.3% | not timed | not timed | 27752.04 ± 9.8% | 1069.97 ± 3.4% | not timed | not timed | 22624.05 ± 1.0% | | 1.01 | 0.83 | 21.46 |
| 01-literal/sherlock-casei-ru | 746 | 7265.70 ± 0.9% | not timed | not timed | 5518.61 ± 0.3% | 30.39 ± 1.5% | not timed | not timed | 7250.90 ± 0.4% | | 1.00 | 1.32 | 239.04 |
| 01-literal/sherlock-zh | 30 | 41731.81 ± 2.1% | not timed | not timed | 36749.36 ± 23.8% | 1262.29 ± 1.4% | not timed | not timed | 41387.13 ± 1.4% | | 1.01 | 1.14 | 33.06 |
| 02-literal-alternate/sherlock-en | 714 | 9577.31 ± 8.2% | not timed | not timed | 8898.46 ± 0.4% | 14.78 ± 19.5% | not timed | not timed | 9569.98 ± 0.6% | | 1.00 | 1.08 | 647.92 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1734.67 ± 0.3% | not timed | not timed | 1817.56 ± 10.4% | 9.50 ± 0.9% | not timed | not timed | 1715.29 ± 0.5% | | 1.01 | 0.95 | 182.62 |
| 02-literal-alternate/sherlock-ru | 899 | 5934.24 ± 0.4% | not timed | not timed | 4228.27 ± 6.7% | 19.18 ± 14.2% | not timed | not timed | 5951.25 ± 0.7% | | 1.00 | 1.40 | 309.32 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1794.60 ± 0.3% | not timed | not timed | 1037.57 ± 0.3% | 8.44 ± 2.3% | not timed | not timed | 1797.28 ± 0.4% | | 1.00 | 1.73 | 212.67 |
| 02-literal-alternate/sherlock-zh | 207 | 13718.54 ± 0.6% | not timed | not timed | 10254.50 ± 1.2% | 26.82 ± 1.1% | not timed | not timed | 13768.45 ± 0.7% | | 1.00 | 1.34 | 511.46 |
| 03-date/ascii | 111817 | 99.84 ± 8.5% | not timed | not timed | 84.65 ± 0.6% | 0.18 ± 3.4% | not timed | not timed | 99.78 ± 0.3% | | 1.00 | 1.18 | 562.27 |
| 04-ruff-noqa/real | 84 | 540.60 ± 2.5% | not timed | not timed | 426.32 ± 0.9% | 16.26 ± 1.2% | not timed | not timed | 544.71 ± 4.5% | | 0.99 | 1.27 | 33.25 |
| 04-ruff-noqa/tweaked | 44 | 483.81 ± 0.2% | not timed | not timed | 421.26 ± 0.9% | 294.66 ± 22.3% | not timed | not timed | 482.24 ± 1.2% | | 1.00 | 1.15 | 1.64 |
| 05-lexer-veryl/single | 124800 | 2.76 ± 1.4% | not timed | not timed | 4.13 ± 0.7% | 0.21 ± 3.9% | not timed | not timed | 2.75 ± 3.6% | | 1.00 | 0.67 | 12.87 |
| 06-cloud-flare-redos/original | 107 | 230.87 ± 0.7% | not timed | not timed | 191.29 ± 5.5% | 20.50 ± 6.6% | not timed | not timed | 230.60 ± 0.2% | | 1.00 | 1.21 | 11.26 |
| 06-cloud-flare-redos/simplified-short | 102 | 220.09 ± 0.5% | not timed | not timed | 192.19 ± 0.6% | 21.86 ± 0.3% | not timed | not timed | 220.13 ± 0.3% | | 1.00 | 1.15 | 10.07 |
| 06-cloud-flare-redos/simplified-long | 10000 | 246.56 ± 0.2% | not timed | not timed | 211.62 ± 12.2% | 24.13 ± 0.5% | not timed | not timed | 246.70 ± 2.0% | | 1.00 | 1.17 | 10.22 |
| 07-unicode-character-data/parse-line | 558784 | 195.38 ± 0.1% | not timed | not timed | 161.73 ± 1.6% | 37.17 ± 3.0% | not timed | not timed | 193.01 ± 8.6% | | 1.01 | 1.21 | 5.26 |
| 08-words/all-english | 56691 | 90.69 ± 2.3% | not timed | not timed | 74.22 ± 12.0% | 10.09 ± 4.0% | not timed | not timed | 90.27 ± 0.9% | | 1.00 | 1.22 | 8.99 |
| 08-words/long-english | 839 | 808.51 ± 0.2% | not timed | not timed | 514.46 ± 0.5% | 26.33 ± 0.7% | not timed | not timed | 807.72 ± 0.3% | | 1.00 | 1.57 | 30.70 |
| 09-aws-keys/full | 0 | 424.13 ± 0.8% | not timed | not timed | 449.59 ± 0.4% | 54.31 ± 6.2% | not timed | not timed | 424.38 ± 0.1% | | 1.00 | 0.94 | 7.81 |
| 09-aws-keys/quick | 0 | 808.59 ± 8.4% | not timed | not timed | 806.89 ± 0.1% | 332.25 ± 0.7% | not timed | not timed | 815.20 ± 8.1% | | 0.99 | 1.00 | 2.43 |
| 10-bounded-repeat/letters-en | 1833 | 489.97 ± 0.3% | not timed | not timed | 432.05 ± 0.1% | 16.78 ± 0.6% | not timed | not timed | 490.63 ± 0.6% | | 1.00 | 1.13 | 29.20 |
| 10-bounded-repeat/letters-ru | 3475 | 318.18 ± 0.6% | not timed | not timed | 408.39 ± 0.8% | 19.67 ± 14.6% | not timed | not timed | 317.99 ± 0.9% | | 1.00 | 0.78 | 16.17 |
| 10-bounded-repeat/context | 53 | 65.28 ± 1.6% | not timed | not timed | 55.76 ± 0.6% | 16.84 ± 0.6% | not timed | not timed | 65.65 ± 0.7% | | 0.99 | 1.17 | 3.88 |
| 10-bounded-repeat/capitals | 11 | 846.02 ± 0.1% | not timed | not timed | 531.94 ± 0.3% | 30.88 ± 5.5% | not timed | not timed | 843.48 ± 0.3% | | 1.00 | 1.59 | 27.40 |
| 11-unstructured-to-json/extract | 600 | 35.51 ± 0.3% | not timed | not timed | 61.62 ± 0.8% | 40.00 ± 7.6% | not timed | not timed | 35.72 ± 0.6% | | 0.99 | 0.58 | 0.89 |
| 12-dictionary/single | 1 | 461.72 ± 0.5% | not timed | not timed | 440.74 ± 0.4% | 0.32 ± 0.9% | not timed | not timed | 464.56 ± 2.1% | | 0.99 | 1.05 | 1448.40 |
| 14-quadratic/1x | 100 | 10.03 ± 0.2% | not timed | not timed | 9.11 ± 3.0% | 0.79 ± 5.4% | not timed | not timed | 10.03 ± 1.2% | | 1.00 | 1.10 | 12.71 |
| 14-quadratic/2x | 200 | 6.29 ± 0.4% | not timed | not timed | 4.91 ± 0.3% | 0.43 ± 2.0% | not timed | not timed | 6.29 ± 1.0% | | 1.00 | 1.28 | 14.61 |
| 14-quadratic/10x | 1000 | 1.50 ± 0.3% | not timed | not timed | 1.05 ± 0.2% | 0.09 ± 1.3% | not timed | not timed | 1.50 ± 1.6% | | 1.00 | 1.43 | 16.20 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 0.7% | not timed | not timed | 0.39 ± 1.2% | 0.48 ± 3.8% | not timed | not timed | 1.25 ± 2.9% | | 1.02 | 3.29 | 2.64 |
| 04-ruff-noqa/compile-real | 1 | 79.42 ± 0.5% | not timed | not timed | 12.95 ± 0.6% | 124.45 ± 1.5% | not timed | not timed | 77.70 ± 7.0% | | 1.02 | 6.13 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 12.71 ± 1.4% | not timed | not timed | 2.36 ± 1.0% | 5.86 ± 17.5% | not timed | not timed | 12.72 ± 0.8% | | 1.00 | 5.38 | 2.17 |
| 07-unicode-character-data/compile | 1 | 50.08 ± 0.6% | not timed | not timed | 24.09 ± 23.3% | 32.97 ± 19.0% | not timed | not timed | 50.10 ± 1.0% | | 1.00 | 2.08 | 1.52 |
| 09-aws-keys/compile-full | 1 | 34.67 ± 2.3% | not timed | not timed | 7.41 ± 12.9% | 20.27 ± 7.1% | not timed | not timed | 34.19 ± 3.7% | | 1.01 | 4.68 | 1.71 |
| 09-aws-keys/compile-quick | 1 | 156.13 ± 6.7% | not timed | not timed | 43.35 ± 16.9% | 114.76 ± 9.2% | not timed | not timed | 153.62 ± 2.5% | | 1.02 | 3.60 | 1.36 |
| 10-bounded-repeat/compile-context | 1 | 10.59 ± 0.3% | not timed | not timed | 11.51 ± 3.0% | 15.25 ± 2.5% | not timed | not timed | 10.58 ± 1.1% | | 1.00 | 0.92 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 73.83 ± 1.3% | not timed | not timed | 8.85 ± 1.6% | 22.11 ± 1.6% | not timed | not timed | 73.42 ± 2.3% | | 1.01 | 8.35 | 3.34 |
| 11-unstructured-to-json/compile | 1 | 76.02 ± 3.0% | not timed | not timed | 37.19 ± 4.6% | 60.36 ± 16.7% | not timed | not timed | 75.59 ± 0.5% | | 1.01 | 2.04 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.29 ± 2.9% | not timed | not timed | 0.07 ± 0.3% | 0.09 ± 17.8% | not timed | not timed | 0.29 ± 1.6% | | 1.01 | 4.20 | 3.18 |

