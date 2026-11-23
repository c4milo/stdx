# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117684414 |
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
| literal: a word | 217 | 16237.10 ± 1.5% | 1037.14 ± 0.3% | 28.33 ± 0.2% | 18311.46 ± 1.4% | 9098.44 ± 7.7% | 17.24 ± 0.3% | 86.62 ± 0.1% | 16292.84 ± 1.4% | 15.66 | 1.00 | 0.89 | 1.78 |
| literal: a word that is not there | 0 | 18870.70 ± 1.9% | 1048.50 ± 0.4% | 28.34 ± 0.2% | 19911.93 ± 2.0% | 29340.85 ± 0.9% | 17.06 ± 0.1% | 82.65 ± 0.1% | 18949.29 ± 1.6% | 18.00 | 1.00 | 0.95 | 0.64 |
| literal: one of four words | 661 | 6091.32 ± 0.5% | 1014.98 ± 0.2% | 14.54 ± 0.2% | 3951.49 ± 0.9% | 21.91 ± 0.1% | 5.39 ± 0.4% | 6.95 ± 1.2% | 6069.80 ± 0.5% | 6.00 | 1.00 | 1.54 | 277.98 |
| literal: a word in any case | 217 | 12554.05 ± 0.3% | 1038.22 ± 0.1% | 21.58 ± 2.4% | 3973.57 ± 0.1% | 38.03 ± 1.2% | refused | differs | 12557.10 ± 0.3% | 12.09 | 1.00 | 3.16 | 330.10 |
| literal: an href attribute | 33 | 13801.06 ± 1.2% | 1045.99 ± 0.2% | 27.07 ± 0.1% | 17079.46 ± 1.0% | 2250.06 ± 0.5% | 13.06 ± 0.2% | 75.60 ± 0.3% | 13746.76 ± 0.4% | 13.19 | 1.00 | 0.81 | 6.13 |
| literal: a word, second text | 123 | 16542.46 ± 1.1% | 1041.85 ± 0.1% | 27.99 ± 0.3% | 18213.64 ± 1.9% | 7745.88 ± 3.6% | 20.00 ± 0.5% | 70.70 ± 0.3% | 16620.19 ± 0.7% | 15.88 | 1.00 | 0.91 | 2.14 |
| class: two capitalized words | 1331 | 1126.06 ± 0.4% | 953.67 ± 0.1% | 25.96 ± 0.4% | 585.22 ± 0.1% | 40.74 ± 0.7% | 14.64 ± 0.3% | 68.96 ± 0.3% | 1125.48 ± 0.4% | 1.18 | 1.00 | 1.92 | 27.64 |
| class: a word that ends in ing | 3399 | 876.76 ± 0.1% | 876.86 ± 0.0% | 17.99 ± 0.2% | 547.72 ± 0.1% | 29.61 ± 1.7% | 8.18 ± 0.3% | 18.27 ± 0.5% | 876.56 ± 0.1% | 1.00 | 1.00 | 1.60 | 29.61 |
| class: a word in capitals | 2332 | 1476.58 ± 0.4% | 937.24 ± 0.3% | 27.58 ± 0.2% | 572.49 ± 0.2% | 43.54 ± 12.9% | 17.04 ± 0.3% | 83.21 ± 0.2% | 1472.83 ± 0.4% | 1.58 | 1.00 | 2.58 | 33.91 |
| class: a number | 8288 | 2002.10 ± 0.2% | 787.09 ± 0.1% | 27.69 ± 0.2% | 1730.83 ± 0.2% | 41.69 ± 13.3% | 0.54 ± 0.1% | 56.84 ± 0.4% | 1989.21 ± 0.1% | 2.54 | 1.01 | 1.16 | 48.03 |
| class: two capitalized words, second text | 5359 | 683.62 ± 0.2% | 679.90 ± 0.1% | 23.25 ± 0.1% | 484.93 ± 0.1% | 34.41 ± 14.7% | 17.04 ± 0.6% | 64.07 ± 0.2% | 683.41 ± 0.1% | 1.01 | 1.00 | 1.41 | 19.87 |
| other: a word between two words | 6104 | 767.58 ± 0.2% | 739.08 ± 0.2% | 23.43 ± 0.2% | 735.65 ± 0.3% | 102.52 ± 18.9% | 11.13 ± 0.1% | 69.86 ± 0.3% | 766.84 ± 0.3% | 1.04 | 1.00 | 1.04 | 7.49 |
| other: a number before a unit, second text | 1481 | 5600.78 ± 0.6% | 972.58 ± 0.1% | 25.77 ± 0.3% | 5679.91 ± 0.3% | 40.91 ± 9.3% | 18.19 ± 0.2% | 66.86 ± 0.3% | 5590.07 ± 0.7% | 5.76 | 1.00 | 0.99 | 136.90 |
| other: a heading's start tag | 110 | 12668.80 ± 1.0% | 1035.02 ± 0.1% | 27.28 ± 0.2% | 1715.61 ± 0.2% | 1566.73 ± 5.9% | 16.02 ± 0.5% | 88.95 ± 0.4% | 12687.14 ± 0.5% | 12.24 | 1.00 | 7.38 | 8.09 |
| other: a whole word | 217 | 14052.63 ± 0.6% | 1036.90 ± 0.1% | 29.13 ± 0.5% | 14621.17 ± 0.9% | 49.42 ± 0.3% | 13.19 ± 0.1% | 56.33 ± 0.2% | 14054.77 ± 0.3% | 13.55 | 1.00 | 0.96 | 284.32 |
| other: a line's first word, second text | 3716 | 1979.75 ± 0.7% | 856.02 ± 0.2% | 30.84 ± 0.1% | 1721.40 ± 0.6% | 62.24 ± 5.7% | refused | refused | 1972.75 ± 0.4% | 2.31 | 1.00 | 1.15 | 31.81 |
| other: fourteen octets before an x | 87 | 19718.91 ± 1.5% | 237.85 ± 0.2% | 6.10 ± 0.2% | 4003.26 ± 0.7% | 10.62 ± 0.1% | differs | 17.81 ± 0.3% | 19763.60 ± 0.3% | 82.90 | 1.00 | 4.93 | 1856.61 |
| other: a Greek word | 21815 | 485.89 ± 0.6% | 308.65 ± 0.3% | 30.91 ± 0.8% | 291.06 ± 0.3% | 43.97 ± 11.5% | differs | refused | 483.88 ± 0.9% | 1.57 | 1.00 | 1.67 | 11.05 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.84 ± 0.1% | 25.86 ± 0.1% | 0.82 ± 0.4% | 19.84 ± 0.6% | 2.78 ± 0.7% | differs | 4.02 ± 0.2% | 25.85 ± 0.1% | 1.00 | 1.00 | 1.30 | 9.28 |
| a UUID | 32895 | 21.14 ± 0.2% | 21.22 ± 0.2% | 0.65 ± 0.1% | 15.09 ± 0.3% | 3.10 ± 0.8% | 0.73 ± 0.3% | 3.60 ± 0.5% | 21.16 ± 0.1% | 1.00 | 1.00 | 1.40 | 6.82 |
| an IPv4 address | 33176 | 36.85 ± 0.2% | 36.84 ± 0.4% | 2.10 ± 0.5% | 29.34 ± 0.6% | 6.68 ± 0.2% | differs | 4.15 ± 0.2% | 36.89 ± 0.1% | 1.00 | 1.00 | 1.26 | 5.52 |
| a date and time | 32954 | 31.10 ± 0.3% | 31.09 ± 0.4% | 1.47 ± 0.1% | 21.47 ± 0.7% | 7.05 ± 0.2% | 1.25 ± 0.3% | 7.15 ± 0.3% | 31.11 ± 0.2% | 1.00 | 1.00 | 1.45 | 4.41 |
| a field path | 32606 | 29.31 ± 0.3% | 29.32 ± 0.2% | 1.01 ± 0.3% | 23.29 ± 0.3% | 3.48 ± 0.9% | differs | 2.97 ± 0.6% | 29.42 ± 0.4% | 1.00 | 1.00 | 1.26 | 8.42 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.62 ± 1.2% | 11.59 ± 0.6% | 11.63 ± 0.4% | 11.83 ± 0.1% | 4.95 ± 1.6% | 0.93 ± 0.3% | none | 11.65 ± 0.6% | 1.00 | 1.00 | 0.98 | 2.35 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 236.63 ± 0.3% | 237.87 ± 0.2% | 287.36 ± 0.3% | 86.58 ± 0.1% | 221.15 ± 10.0% | 485.27 ± 0.7% | 3874.07 ± 0.9% | 236.61 ± 0.2% | 0.99 | 1.00 | 2.73 | 1.07 |
| a UUID | 62 | 157.97 ± 0.3% | 158.42 ± 0.2% | 179.39 ± 0.3% | 45.53 ± 0.1% | 99.60 ± 0.8% | 181.43 ± 0.9% | 4352.55 ± 2.0% | 158.09 ± 0.2% | 1.00 | 1.00 | 3.47 | 1.59 |
| an IPv4 address | 29 | 425.78 ± 0.5% | 431.07 ± 0.3% | 619.59 ± 0.3% | 76.21 ± 0.9% | 132.14 ± 0.8% | 291.10 ± 0.8% | 7633.23 ± 0.3% | 425.60 ± 0.2% | 0.99 | 1.00 | 5.59 | 3.22 |
| a date and time | 56 | 307.31 ± 0.4% | 310.46 ± 0.4% | 396.57 ± 0.5% | 71.85 ± 0.2% | 138.29 ± 1.0% | 320.92 ± 1.1% | 4902.22 ± 0.7% | 307.18 ± 0.2% | 0.99 | 1.00 | 4.28 | 2.22 |
| a field path | 39 | 227.91 ± 0.5% | 229.28 ± 0.3% | 274.58 ± 0.5% | 79.38 ± 0.4% | 206.11 ± 1.1% | 488.11 ± 0.9% | 4910.08 ± 1.2% | 227.87 ± 0.5% | 0.99 | 1.00 | 2.87 | 1.11 |
| literal: a word | 7 | 637.87 ± 0.4% | 686.07 ± 0.3% | 1291.15 ± 0.1% | 503.53 ± 1.7% | 634.17 ± 1.9% | 924.17 ± 0.6% | 30445.53 ± 0.1% | 637.78 ± 0.5% | 0.93 | 1.00 | 1.27 | 1.01 |
| literal: a word that is not there | 8 | 612.34 ± 0.3% | 663.34 ± 0.4% | 1215.89 ± 0.2% | 459.99 ± 0.6% | 607.45 ± 0.9% | 882.43 ± 0.2% | 29126.06 ± 0.2% | 612.46 ± 0.3% | 0.92 | 1.00 | 1.33 | 1.01 |
| literal: one of four words | 26 | 244.06 ± 0.4% | 407.68 ± 0.5% | 570.58 ± 0.1% | 49.23 ± 0.3% | 243.19 ± 1.9% | 360.43 ± 0.5% | 15617.09 ± 0.5% | 244.24 ± 0.3% | 0.60 | 1.00 | 4.96 | 1.00 |
| literal: a word in any case | 11 | 493.11 ± 0.3% | 526.51 ± 0.3% | 848.90 ± 0.2% | 15.40 ± 0.9% | 664.66 ± 2.2% | refused | 23741.19 ± 0.3% | 493.60 ± 0.2% | 0.94 | 1.00 | 32.03 | 0.74 |
| literal: an href attribute | 12 | 352.97 ± 0.5% | 366.06 ± 0.6% | 496.19 ± 0.3% | 44.69 ± 0.5% | 505.44 ± 1.0% | 772.37 ± 1.8% | 21643.65 ± 0.1% | 353.70 ± 0.2% | 0.96 | 1.00 | 7.90 | 0.70 |
| literal: a word, second text | 10 | 570.91 ± 0.3% | 628.63 ± 0.3% | 1094.06 ± 0.1% | 407.22 ± 0.4% | 539.21 ± 1.5% | 803.85 ± 0.3% | 27077.62 ± 0.3% | 570.94 ± 0.5% | 0.91 | 1.00 | 1.40 | 1.06 |
| class: two capitalized words | 23 | 444.26 ± 0.6% | 472.61 ± 0.4% | 710.11 ± 0.5% | 101.24 ± 0.2% | 501.77 ± 8.3% | 738.31 ± 0.7% | 6590.08 ± 0.3% | 444.29 ± 0.2% | 0.94 | 1.00 | 4.39 | 0.89 |
| class: a word that ends in ing | 9 | 573.69 ± 0.3% | 641.56 ± 0.4% | 1176.40 ± 0.3% | 133.13 ± 0.9% | 761.01 ± 1.4% | 1084.67 ± 2.1% | 16103.57 ± 0.5% | 573.33 ± 0.6% | 0.89 | 1.00 | 4.31 | 0.75 |
| class: a word in capitals | 16 | 507.23 ± 0.3% | 543.55 ± 0.3% | 906.45 ± 0.3% | 135.71 ± 1.0% | 752.24 ± 0.7% | 1011.14 ± 0.7% | 8690.17 ± 0.3% | 506.45 ± 0.7% | 0.93 | 1.00 | 3.74 | 0.67 |
| class: a number | 6 | 636.20 ± 0.5% | 703.21 ± 0.4% | 1385.56 ± 0.0% | 41.76 ± 0.4% | 1414.08 ± 1.1% | 1942.42 ± 1.2% | 22823.19 ± 0.2% | 637.13 ± 0.2% | 0.90 | 1.00 | 15.23 | 0.45 |
| class: two capitalized words, second text | 23 | 444.60 ± 0.3% | 472.76 ± 0.4% | 710.21 ± 0.2% | 103.13 ± 0.3% | 502.93 ± 1.8% | 737.58 ± 0.8% | 6597.35 ± 1.3% | 443.92 ± 0.4% | 0.94 | 1.00 | 4.31 | 0.88 |
| other: a word between two words | 13 | 562.41 ± 0.5% | 581.00 ± 0.4% | 968.09 ± 0.2% | 135.71 ± 0.4% | 506.07 ± 0.9% | 818.00 ± 0.4% | 14940.43 ± 0.3% | 562.09 ± 0.3% | 0.97 | 1.00 | 4.14 | 1.11 |
| other: a number before a unit, second text | 15 | 411.68 ± 0.3% | 450.95 ± 0.6% | 653.83 ± 0.3% | 39.16 ± 1.1% | 638.38 ± 1.0% | 896.71 ± 0.5% | 15185.32 ± 0.4% | 412.11 ± 0.3% | 0.91 | 1.00 | 10.51 | 0.64 |
| other: a heading's start tag | 13 | 361.73 ± 0.3% | 367.28 ± 0.3% | 498.54 ± 0.2% | 43.25 ± 0.2% | 631.37 ± 0.7% | 862.71 ± 0.2% | 18079.83 ± 0.5% | 362.08 ± 0.3% | 0.98 | 1.00 | 8.36 | 0.57 |
| other: a whole word | 11 | 595.51 ± 0.4% | 632.71 ± 0.4% | 1098.87 ± 0.4% | 120.06 ± 0.4% | 566.80 ± 1.7% | 824.17 ± 0.8% | 26952.14 ± 0.3% | 595.88 ± 0.2% | 0.94 | 1.00 | 4.96 | 1.05 |
| other: a line's first word, second text | 17 | 541.82 ± 0.3% | 563.99 ± 0.5% | 946.97 ± 0.1% | 128.64 ± 0.2% | 707.50 ± 1.6% | refused | refused | 540.17 ± 1.5% | 0.96 | 1.00 | 4.21 | 0.77 |
| other: fourteen octets before an x | 16 | 111.65 ± 0.6% | 162.64 ± 0.8% | 189.82 ± 0.4% | 14.94 ± 0.6% | 450.09 ± 1.6% | 416.83 ± 0.6% | 12654.32 ± 0.9% | 111.59 ± 0.6% | 0.69 | 1.00 | 7.47 | 0.25 |
| other: a Greek word | 8 | 434.67 ± 0.2% | 599.84 ± 1.1% | 1057.00 ± 0.1% | 58.28 ± 0.3% | 1392.64 ± 0.9% | 1855.01 ± 0.5% | refused | 434.32 ± 0.4% | 0.72 | 1.00 | 7.46 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12907.56 ± 0.9% | not timed | not timed | 16069.41 ± 2.1% | 2155.69 ± 4.5% | not timed | not timed | 12884.30 ± 0.8% | | 1.00 | 0.80 | 5.99 |
| 01-literal/sherlock-casei-en | 522 | 3908.52 ± 0.5% | not timed | not timed | 3595.57 ± 0.1% | 32.35 ± 0.3% | not timed | not timed | 3903.65 ± 0.2% | | 1.00 | 1.09 | 120.83 |
| 01-literal/sherlock-ru | 724 | 13613.76 ± 0.5% | not timed | not timed | 17320.87 ± 0.7% | 1516.66 ± 8.3% | not timed | not timed | 13591.94 ± 0.3% | | 1.00 | 0.79 | 8.98 |
| 01-literal/sherlock-casei-ru | 746 | 5314.16 ± 0.1% | not timed | not timed | 3330.27 ± 0.1% | 30.50 ± 0.3% | not timed | not timed | 5321.00 ± 0.2% | | 1.00 | 1.60 | 174.24 |
| 01-literal/sherlock-zh | 30 | 17019.26 ± 0.2% | not timed | not timed | 18587.09 ± 0.8% | 2796.88 ± 10.5% | not timed | not timed | 16990.16 ± 0.2% | | 1.00 | 0.92 | 6.09 |
| 02-literal-alternate/sherlock-en | 714 | 5817.97 ± 0.1% | not timed | not timed | 3940.69 ± 0.3% | 16.65 ± 0.1% | not timed | not timed | 5816.77 ± 0.3% | | 1.00 | 1.48 | 349.39 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1679.09 ± 0.7% | not timed | not timed | 695.88 ± 0.1% | 11.03 ± 0.1% | not timed | not timed | 1675.75 ± 0.5% | | 1.00 | 2.41 | 152.23 |
| 02-literal-alternate/sherlock-ru | 899 | 4716.78 ± 0.3% | not timed | not timed | 3254.86 ± 0.2% | 22.66 ± 22.1% | not timed | not timed | 4725.37 ± 0.2% | | 1.00 | 1.45 | 208.16 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1797.60 ± 0.6% | not timed | not timed | 1231.18 ± 0.1% | 9.06 ± 0.1% | not timed | not timed | 1793.41 ± 0.1% | | 1.00 | 1.46 | 198.41 |
| 02-literal-alternate/sherlock-zh | 207 | 7072.60 ± 0.1% | not timed | not timed | 4162.13 ± 0.1% | 31.53 ± 0.1% | not timed | not timed | 7072.54 ± 0.1% | | 1.00 | 1.70 | 224.34 |
| 03-date/ascii | 111817 | 124.22 ± 0.8% | not timed | not timed | 96.23 ± 0.1% | 0.20 ± 2.8% | not timed | not timed | 123.68 ± 0.6% | | 1.00 | 1.29 | 608.34 |
| 04-ruff-noqa/real | 84 | 555.56 ± 0.1% | not timed | not timed | 465.13 ± 0.2% | 19.59 ± 1.2% | not timed | not timed | 554.87 ± 0.2% | | 1.00 | 1.19 | 28.36 |
| 04-ruff-noqa/tweaked | 44 | 559.12 ± 0.2% | not timed | not timed | 461.35 ± 0.1% | 365.88 ± 0.4% | not timed | not timed | 558.06 ± 0.4% | | 1.00 | 1.21 | 1.53 |
| 05-lexer-veryl/single | 124800 | 3.51 ± 0.5% | not timed | not timed | 5.14 ± 0.0% | 0.21 ± 4.3% | not timed | not timed | 3.60 ± 2.2% | | 0.98 | 0.68 | 17.06 |
| 06-cloud-flare-redos/original | 107 | 184.56 ± 0.6% | not timed | not timed | 215.26 ± 0.1% | 24.95 ± 0.2% | not timed | not timed | 182.82 ± 0.6% | | 1.01 | 0.86 | 7.40 |
| 06-cloud-flare-redos/simplified-short | 102 | 145.25 ± 0.2% | not timed | not timed | 229.68 ± 0.2% | 26.73 ± 0.4% | not timed | not timed | 145.07 ± 0.1% | | 1.00 | 0.63 | 5.43 |
| 06-cloud-flare-redos/simplified-long | 10000 | 154.86 ± 2.8% | not timed | not timed | 256.17 ± 0.2% | 28.86 ± 0.2% | not timed | not timed | 154.55 ± 1.9% | | 1.00 | 0.60 | 5.37 |
| 07-unicode-character-data/parse-line | 558784 | 231.47 ± 2.0% | not timed | not timed | 180.88 ± 0.2% | 43.10 ± 5.6% | not timed | not timed | 227.69 ± 1.7% | | 1.02 | 1.28 | 5.37 |
| 08-words/all-english | 56691 | 103.35 ± 0.2% | not timed | not timed | 83.09 ± 0.1% | 11.91 ± 4.5% | not timed | not timed | 102.73 ± 0.5% | | 1.01 | 1.24 | 8.68 |
| 08-words/long-english | 839 | 999.39 ± 0.1% | not timed | not timed | 596.33 ± 0.2% | 32.70 ± 0.3% | not timed | not timed | 999.06 ± 0.1% | | 1.00 | 1.68 | 30.56 |
| 09-aws-keys/full | 0 | 424.12 ± 0.1% | not timed | not timed | 490.92 ± 0.1% | 64.41 ± 3.6% | not timed | not timed | 424.62 ± 0.0% | | 1.00 | 0.86 | 6.58 |
| 09-aws-keys/quick | 0 | 743.73 ± 0.2% | not timed | not timed | 997.30 ± 0.3% | 420.40 ± 0.7% | not timed | not timed | 741.19 ± 0.1% | | 1.00 | 0.75 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 586.25 ± 0.3% | not timed | not timed | 517.62 ± 0.9% | 19.45 ± 0.2% | not timed | not timed | 556.39 ± 0.3% | | 1.05 | 1.13 | 30.14 |
| 10-bounded-repeat/letters-ru | 3475 | 401.29 ± 0.4% | not timed | not timed | 479.65 ± 0.1% | 22.55 ± 16.0% | not timed | not timed | 399.42 ± 0.4% | | 1.00 | 0.84 | 17.79 |
| 10-bounded-repeat/context | 53 | 80.21 ± 1.1% | not timed | not timed | 66.31 ± 0.4% | 19.78 ± 0.3% | not timed | not timed | 80.07 ± 1.1% | | 1.00 | 1.21 | 4.05 |
| 10-bounded-repeat/capitals | 11 | 1046.20 ± 0.2% | not timed | not timed | 618.09 ± 0.1% | 36.54 ± 0.1% | not timed | not timed | 1046.61 ± 0.1% | | 1.00 | 1.69 | 28.64 |
| 11-unstructured-to-json/extract | 600 | 47.78 ± 0.1% | not timed | not timed | 76.12 ± 0.2% | 49.02 ± 0.1% | not timed | not timed | 47.54 ± 0.8% | | 1.00 | 0.63 | 0.97 |
| 12-dictionary/single | 1 | 605.03 ± 0.5% | not timed | not timed | 557.07 ± 0.2% | 0.40 ± 0.2% | not timed | not timed | 603.62 ± 0.5% | | 1.00 | 1.09 | 1501.97 |
| 14-quadratic/1x | 100 | 12.59 ± 0.4% | not timed | not timed | 10.11 ± 0.5% | 0.96 ± 2.7% | not timed | not timed | 12.50 ± 1.0% | | 1.01 | 1.25 | 13.09 |
| 14-quadratic/2x | 200 | 7.83 ± 0.3% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 1.9% | not timed | not timed | 7.80 ± 0.4% | | 1.00 | 1.41 | 14.67 |
| 14-quadratic/10x | 1000 | 1.87 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 1.86 ± 0.4% | | 1.00 | 1.54 | 16.17 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.2% | not timed | not timed | 0.35 ± 1.3% | 0.54 ± 5.4% | not timed | not timed | 1.44 ± 0.8% | | 1.01 | 4.19 | 2.68 |
| 04-ruff-noqa/compile-real | 1 | 92.74 ± 0.5% | not timed | not timed | 13.84 ± 0.1% | 140.73 ± 1.6% | not timed | not timed | 92.25 ± 1.3% | | 1.01 | 6.70 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.67 ± 0.2% | not timed | not timed | 2.53 ± 0.7% | 6.48 ± 1.2% | not timed | not timed | 14.62 ± 1.0% | | 1.00 | 5.81 | 2.26 |
| 07-unicode-character-data/compile | 1 | 58.34 ± 0.1% | not timed | not timed | 26.06 ± 0.6% | 36.01 ± 3.3% | not timed | not timed | 58.44 ± 1.5% | | 1.00 | 2.24 | 1.62 |
| 09-aws-keys/compile-full | 1 | 43.68 ± 0.2% | not timed | not timed | 8.28 ± 0.5% | 23.46 ± 14.2% | not timed | not timed | 43.48 ± 0.3% | | 1.00 | 5.27 | 1.86 |
| 09-aws-keys/compile-quick | 1 | 188.48 ± 0.2% | not timed | not timed | 47.44 ± 0.2% | 136.17 ± 3.8% | not timed | not timed | 190.17 ± 0.9% | | 0.99 | 3.97 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 14.68 ± 1.1% | not timed | not timed | 11.05 ± 0.2% | 16.12 ± 2.9% | not timed | not timed | 14.53 ± 0.7% | | 1.01 | 1.33 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 86.05 ± 1.2% | not timed | not timed | 7.95 ± 0.3% | 23.97 ± 2.0% | not timed | not timed | 85.96 ± 1.2% | | 1.00 | 10.82 | 3.59 |
| 11-unstructured-to-json/compile | 1 | 90.87 ± 0.2% | not timed | not timed | 40.64 ± 0.9% | 68.18 ± 2.3% | not timed | not timed | 90.77 ± 1.2% | | 1.00 | 2.24 | 1.33 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 1.0% | 0.10 ± 12.7% | not timed | not timed | 0.36 ± 3.4% | | 1.00 | 5.21 | 3.74 |

