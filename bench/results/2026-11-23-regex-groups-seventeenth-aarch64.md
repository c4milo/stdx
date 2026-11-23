# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215468936 |
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
| literal: a word | 217 | 16273.05 ± 0.7% | 5002.67 ± 0.3% | 27.91 ± 0.3% | 18511.11 ± 0.9% | 9102.52 ± 8.3% | 17.41 ± 0.5% | 84.21 ± 0.3% | 16305.47 ± 1.0% | 3.25 | 1.00 | 0.88 | 1.79 |
| literal: a word that is not there | 0 | 18871.52 ± 0.8% | 4884.80 ± 0.1% | 27.98 ± 0.2% | 20083.41 ± 1.4% | 29669.32 ± 0.5% | 17.20 ± 0.1% | 79.67 ± 1.0% | 18906.25 ± 0.6% | 3.86 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6091.69 ± 0.6% | 1932.30 ± 0.3% | 14.27 ± 0.1% | 3950.50 ± 0.1% | 21.89 ± 0.1% | 5.43 ± 0.2% | 6.89 ± 0.5% | 6073.80 ± 0.3% | 3.15 | 1.00 | 1.54 | 278.23 |
| literal: a word in any case | 217 | 12659.58 ± 0.2% | 2074.61 ± 0.1% | 21.03 ± 1.8% | 3971.87 ± 0.1% | 36.82 ± 0.1% | refused | differs | 12631.05 ± 0.2% | 6.10 | 1.00 | 3.19 | 343.82 |
| literal: an href attribute | 33 | 13748.27 ± 0.2% | 615.76 ± 0.1% | 27.07 ± 0.1% | 17082.06 ± 0.7% | 2258.44 ± 0.4% | 13.17 ± 0.2% | 73.93 ± 0.3% | 13746.76 ± 0.4% | 22.33 | 1.00 | 0.80 | 6.09 |
| literal: a word, second text | 123 | 16627.54 ± 0.4% | 3352.96 ± 0.2% | 27.67 ± 0.3% | 18602.54 ± 0.6% | 7689.56 ± 5.3% | 20.15 ± 0.3% | 70.38 ± 0.7% | 16643.75 ± 0.6% | 4.96 | 1.00 | 0.89 | 2.16 |
| class: two capitalized words | 1331 | 1062.98 ± 0.5% | 603.53 ± 0.1% | 25.81 ± 0.1% | 585.34 ± 0.1% | 40.46 ± 8.3% | 14.75 ± 0.3% | 67.47 ± 0.3% | 1063.82 ± 0.3% | 1.76 | 1.00 | 1.82 | 26.27 |
| class: a word that ends in ing | 3399 | 580.32 ± 0.1% | 579.23 ± 0.2% | 17.87 ± 0.3% | 547.80 ± 0.2% | 29.60 ± 6.3% | 8.22 ± 0.1% | 18.42 ± 0.4% | 580.34 ± 0.1% | 1.00 | 1.00 | 1.06 | 19.60 |
| class: a word in capitals | 2332 | 1375.60 ± 0.4% | 614.94 ± 0.3% | 27.34 ± 0.4% | 572.52 ± 0.1% | 43.20 ± 6.6% | 17.21 ± 0.3% | 81.73 ± 3.0% | 1372.67 ± 0.2% | 2.24 | 1.00 | 2.40 | 31.84 |
| class: a number | 8288 | 2004.19 ± 0.7% | 833.93 ± 0.1% | 27.44 ± 0.6% | 1724.98 ± 0.2% | 41.67 ± 5.0% | 0.55 ± 0.4% | 57.65 ± 1.0% | 1994.79 ± 0.4% | 2.40 | 1.00 | 1.16 | 48.10 |
| class: two capitalized words, second text | 5359 | 521.46 ± 0.1% | 528.42 ± 0.1% | 23.04 ± 0.2% | 484.77 ± 0.1% | 35.31 ± 8.7% | 17.13 ± 0.4% | 63.03 ± 0.2% | 520.92 ± 0.1% | 0.99 | 1.00 | 1.08 | 14.77 |
| other: a word between two words | 6104 | 741.57 ± 0.2% | 598.73 ± 0.1% | 23.30 ± 0.1% | 732.73 ± 0.6% | 108.28 ± 19.6% | 11.22 ± 0.1% | 68.30 ± 1.6% | 740.60 ± 0.2% | 1.24 | 1.00 | 1.01 | 6.85 |
| other: a number before a unit, second text | 1481 | 5340.68 ± 0.6% | 1108.17 ± 0.2% | 25.85 ± 0.2% | 5670.54 ± 0.3% | 40.63 ± 0.1% | 18.17 ± 0.1% | 65.88 ± 0.5% | 5341.60 ± 0.6% | 4.82 | 1.00 | 0.94 | 131.43 |
| other: a heading's start tag | 110 | 12607.77 ± 0.6% | 750.54 ± 0.1% | 27.09 ± 0.3% | 1707.54 ± 0.1% | 1573.04 ± 4.4% | 16.21 ± 0.4% | 86.26 ± 1.5% | 12592.27 ± 0.3% | 16.80 | 1.00 | 7.38 | 8.01 |
| other: a whole word | 217 | 14142.10 ± 1.1% | 608.70 ± 0.1% | 29.21 ± 0.3% | 14695.37 ± 0.4% | 47.67 ± 0.4% | 13.32 ± 0.1% | 54.75 ± 1.0% | 14205.05 ± 0.9% | 23.23 | 1.00 | 0.96 | 296.64 |
| other: a line's first word, second text | 3716 | 1950.94 ± 0.4% | 594.24 ± 0.3% | 30.91 ± 0.3% | 1722.02 ± 0.4% | 62.49 ± 8.0% | refused | refused | 1943.60 ± 0.3% | 3.28 | 1.00 | 1.13 | 31.22 |
| other: fourteen octets before an x | 87 | 20104.01 ± 0.6% | 248.86 ± 0.6% | 6.30 ± 0.1% | 4056.92 ± 0.5% | 10.62 ± 0.2% | differs | 17.75 ± 0.2% | 20053.17 ± 0.6% | 80.78 | 1.00 | 4.96 | 1893.92 |
| other: a Greek word | 21815 | 501.43 ± 0.5% | 412.48 ± 0.2% | 30.71 ± 0.2% | 289.66 ± 0.1% | 44.31 ± 2.8% | differs | refused | 497.40 ± 0.5% | 1.22 | 1.01 | 1.73 | 11.32 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.85 ± 0.4% | 19.88 ± 0.5% | 0.84 ± 0.1% | 19.87 ± 0.4% | 2.76 ± 0.7% | differs | 4.07 ± 0.2% | 19.88 ± 0.2% | 1.00 | 1.00 | 1.00 | 7.20 |
| a UUID | 32895 | 21.24 ± 0.2% | 21.36 ± 0.1% | 0.64 ± 0.1% | 15.16 ± 0.6% | 3.08 ± 0.7% | 0.73 ± 0.4% | 3.66 ± 0.6% | 21.39 ± 0.2% | 0.99 | 0.99 | 1.40 | 6.90 |
| an IPv4 address | 33176 | 36.79 ± 0.3% | 36.84 ± 0.2% | 2.05 ± 0.1% | 29.28 ± 0.9% | 6.63 ± 0.2% | differs | 4.16 ± 0.2% | 36.81 ± 0.2% | 1.00 | 1.00 | 1.26 | 5.55 |
| a date and time | 32954 | 31.49 ± 0.3% | 31.38 ± 0.3% | 1.41 ± 0.4% | 21.55 ± 0.4% | 7.05 ± 0.1% | 1.25 ± 0.0% | 7.20 ± 0.3% | 31.35 ± 0.3% | 1.00 | 1.00 | 1.46 | 4.47 |
| a field path | 32606 | 23.49 ± 0.2% | 23.56 ± 0.0% | 1.00 ± 0.1% | 23.27 ± 0.5% | 3.50 ± 1.0% | differs | 2.97 ± 0.2% | 23.54 ± 0.2% | 1.00 | 1.00 | 1.01 | 6.72 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.07 ± 0.2% | 11.07 ± 0.1% | 11.07 ± 0.1% | 11.82 ± 0.1% | 4.89 ± 2.4% | 0.94 ± 0.5% | none | 11.12 ± 0.3% | 1.00 | 1.00 | 0.94 | 2.26 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 227.32 ± 0.2% | 228.50 ± 0.3% | 272.74 ± 0.2% | 86.96 ± 0.6% | 222.35 ± 1.2% | 480.67 ± 1.0% | 3796.99 ± 0.3% | 227.27 ± 0.4% | 0.99 | 1.00 | 2.61 | 1.02 |
| a UUID | 62 | 151.98 ± 0.2% | 152.36 ± 0.3% | 171.53 ± 0.2% | 46.56 ± 0.6% | 100.08 ± 0.6% | 191.19 ± 2.8% | 4234.28 ± 0.3% | 151.93 ± 0.2% | 1.00 | 1.00 | 3.26 | 1.52 |
| an IPv4 address | 29 | 416.45 ± 0.4% | 421.56 ± 0.3% | 603.21 ± 0.3% | 77.12 ± 0.3% | 132.22 ± 1.0% | 303.12 ± 1.6% | 7571.58 ± 0.4% | 416.19 ± 0.5% | 0.99 | 1.00 | 5.40 | 3.15 |
| a date and time | 56 | 300.73 ± 0.5% | 302.65 ± 0.4% | 384.29 ± 0.3% | 73.31 ± 0.3% | 137.96 ± 2.0% | 324.54 ± 1.2% | 4919.70 ± 0.6% | 300.44 ± 0.4% | 0.99 | 1.00 | 4.10 | 2.18 |
| a field path | 39 | 224.34 ± 0.3% | 224.99 ± 0.1% | 266.57 ± 0.2% | 81.38 ± 1.1% | 205.62 ± 1.2% | 500.87 ± 3.3% | 4860.33 ± 0.9% | 224.02 ± 0.4% | 1.00 | 1.00 | 2.76 | 1.09 |
| literal: a word | 7 | 626.03 ± 0.5% | 675.40 ± 0.6% | 1244.52 ± 0.7% | 526.79 ± 0.1% | 635.84 ± 2.0% | 958.13 ± 0.4% | 30975.31 ± 0.3% | 625.88 ± 0.3% | 0.93 | 1.00 | 1.19 | 0.98 |
| literal: a word that is not there | 8 | 606.46 ± 0.4% | 655.01 ± 0.5% | 1172.31 ± 0.3% | 484.36 ± 0.2% | 603.93 ± 2.5% | 908.61 ± 0.4% | 29444.83 ± 0.1% | 606.80 ± 0.2% | 0.93 | 1.00 | 1.25 | 1.00 |
| literal: one of four words | 26 | 238.71 ± 0.2% | 398.60 ± 0.7% | 549.28 ± 0.4% | 50.26 ± 1.3% | 242.03 ± 1.4% | 374.79 ± 1.2% | 16043.34 ± 0.1% | 238.46 ± 0.2% | 0.60 | 1.00 | 4.75 | 0.99 |
| literal: a word in any case | 11 | 443.14 ± 0.3% | 470.75 ± 0.4% | 700.11 ± 0.1% | 15.86 ± 1.9% | 654.43 ± 2.4% | refused | 23712.66 ± 0.3% | 442.92 ± 0.2% | 0.94 | 1.00 | 27.94 | 0.68 |
| literal: an href attribute | 12 | 338.87 ± 0.6% | 350.28 ± 0.5% | 466.90 ± 0.5% | 45.96 ± 0.3% | 505.65 ± 0.9% | 774.16 ± 1.2% | 21973.18 ± 0.3% | 339.02 ± 0.3% | 0.97 | 1.00 | 7.37 | 0.67 |
| literal: a word, second text | 10 | 557.79 ± 0.7% | 613.26 ± 0.3% | 1054.63 ± 0.4% | 403.37 ± 0.4% | 532.75 ± 3.5% | 801.98 ± 0.4% | 27321.63 ± 0.2% | 557.85 ± 0.7% | 0.91 | 1.00 | 1.38 | 1.05 |
| class: two capitalized words | 23 | 427.24 ± 0.4% | 461.58 ± 0.4% | 683.87 ± 0.6% | 100.21 ± 0.5% | 497.77 ± 6.9% | 742.72 ± 0.4% | 6472.39 ± 0.8% | 428.01 ± 0.4% | 0.93 | 1.00 | 4.26 | 0.86 |
| class: a word that ends in ing | 9 | 549.95 ± 0.5% | 625.96 ± 0.2% | 1132.43 ± 0.3% | 132.93 ± 2.0% | 759.81 ± 1.2% | 1104.11 ± 0.8% | 16037.62 ± 0.4% | 549.69 ± 0.3% | 0.88 | 1.00 | 4.14 | 0.72 |
| class: a word in capitals | 16 | 481.70 ± 0.7% | 526.02 ± 0.3% | 880.28 ± 0.2% | 135.82 ± 0.4% | 755.37 ± 0.6% | 1022.48 ± 0.7% | 8536.34 ± 0.2% | 481.76 ± 0.3% | 0.92 | 1.00 | 3.55 | 0.64 |
| class: a number | 6 | 606.78 ± 0.4% | 677.80 ± 0.3% | 1350.25 ± 0.3% | 41.79 ± 0.6% | 1412.94 ± 1.1% | 1858.73 ± 1.8% | 22778.40 ± 0.1% | 606.98 ± 0.1% | 0.90 | 1.00 | 14.52 | 0.43 |
| class: two capitalized words, second text | 23 | 428.55 ± 0.4% | 462.22 ± 0.4% | 685.89 ± 0.6% | 101.75 ± 0.4% | 501.11 ± 1.5% | 762.69 ± 0.6% | 6489.36 ± 0.5% | 428.46 ± 0.4% | 0.93 | 1.00 | 4.21 | 0.86 |
| other: a word between two words | 13 | 541.63 ± 0.4% | 558.82 ± 0.4% | 920.44 ± 0.4% | 133.57 ± 0.6% | 497.09 ± 1.5% | 815.82 ± 0.5% | 14870.06 ± 0.2% | 541.35 ± 0.5% | 0.97 | 1.00 | 4.05 | 1.09 |
| other: a number before a unit, second text | 15 | 395.71 ± 0.3% | 438.63 ± 0.2% | 627.27 ± 0.2% | 39.61 ± 0.3% | 626.58 ± 1.6% | 890.08 ± 0.9% | 15233.26 ± 0.4% | 395.65 ± 0.3% | 0.90 | 1.00 | 9.99 | 0.63 |
| other: a heading's start tag | 13 | 349.46 ± 0.5% | 354.53 ± 0.3% | 477.50 ± 0.2% | 44.05 ± 0.4% | 622.74 ± 1.7% | 877.03 ± 0.5% | 18247.72 ± 0.5% | 349.56 ± 0.2% | 0.99 | 1.00 | 7.93 | 0.56 |
| other: a whole word | 11 | 575.52 ± 0.2% | 608.58 ± 0.7% | 1036.74 ± 0.2% | 118.59 ± 0.5% | 568.04 ± 2.9% | 837.26 ± 0.8% | 27282.56 ± 0.1% | 575.92 ± 0.7% | 0.95 | 1.00 | 4.85 | 1.01 |
| other: a line's first word, second text | 17 | 523.01 ± 0.6% | 542.70 ± 0.3% | 892.45 ± 0.4% | 129.90 ± 0.2% | 710.19 ± 1.7% | refused | refused | 522.45 ± 1.0% | 0.96 | 1.00 | 4.03 | 0.74 |
| other: fourteen octets before an x | 16 | 107.55 ± 0.4% | 154.34 ± 0.4% | 179.43 ± 0.5% | 15.27 ± 0.2% | 445.48 ± 7.9% | 414.15 ± 0.2% | 12937.03 ± 0.4% | 107.52 ± 0.5% | 0.70 | 1.00 | 7.04 | 0.24 |
| other: a Greek word | 8 | 423.42 ± 0.2% | 586.86 ± 0.5% | 1045.99 ± 0.1% | 59.19 ± 0.8% | 1400.04 ± 2.3% | 1794.31 ± 0.7% | refused | 423.24 ± 0.2% | 0.72 | 1.00 | 7.15 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12797.10 ± 0.6% | not timed | not timed | 16378.34 ± 1.3% | 2157.28 ± 28.2% | not timed | not timed | 12787.13 ± 1.0% | | 1.00 | 0.78 | 5.93 |
| 01-literal/sherlock-casei-en | 522 | 4957.03 ± 1.0% | not timed | not timed | 3593.73 ± 0.2% | 32.12 ± 2.1% | not timed | not timed | 4949.91 ± 0.5% | | 1.00 | 1.38 | 154.35 |
| 01-literal/sherlock-ru | 724 | 13509.26 ± 0.2% | not timed | not timed | 17317.44 ± 0.2% | 1410.65 ± 17.7% | not timed | not timed | 13459.02 ± 0.3% | | 1.00 | 0.78 | 9.58 |
| 01-literal/sherlock-casei-ru | 746 | 5978.00 ± 0.3% | not timed | not timed | 3323.25 ± 0.1% | 31.60 ± 0.3% | not timed | not timed | 5974.16 ± 0.2% | | 1.00 | 1.80 | 189.18 |
| 01-literal/sherlock-zh | 30 | 17105.18 ± 0.6% | not timed | not timed | 18700.88 ± 0.7% | 2672.02 ± 11.5% | not timed | not timed | 17096.02 ± 0.6% | | 1.00 | 0.91 | 6.40 |
| 02-literal-alternate/sherlock-en | 714 | 5762.29 ± 0.3% | not timed | not timed | 3943.06 ± 0.1% | 16.64 ± 0.3% | not timed | not timed | 5754.54 ± 0.4% | | 1.00 | 1.46 | 346.35 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1805.23 ± 1.3% | not timed | not timed | 695.90 ± 0.4% | 11.03 ± 0.1% | not timed | not timed | 1795.61 ± 0.4% | | 1.01 | 2.59 | 163.63 |
| 02-literal-alternate/sherlock-ru | 899 | 5339.99 ± 0.1% | not timed | not timed | 3259.78 ± 0.2% | 22.67 ± 0.2% | not timed | not timed | 5333.17 ± 0.2% | | 1.00 | 1.64 | 235.60 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1918.34 ± 0.4% | not timed | not timed | 1232.45 ± 0.1% | 9.14 ± 4.4% | not timed | not timed | 1910.87 ± 0.3% | | 1.00 | 1.56 | 209.90 |
| 02-literal-alternate/sherlock-zh | 207 | 7049.28 ± 0.3% | not timed | not timed | 4167.52 ± 0.3% | 31.51 ± 0.3% | not timed | not timed | 7033.58 ± 0.2% | | 1.00 | 1.69 | 223.75 |
| 03-date/ascii | 111817 | 126.42 ± 0.7% | not timed | not timed | 96.17 ± 0.0% | 0.20 ± 2.7% | not timed | not timed | 125.67 ± 0.2% | | 1.01 | 1.31 | 634.27 |
| 04-ruff-noqa/real | 84 | 409.19 ± 0.1% | not timed | not timed | 478.16 ± 0.1% | 19.63 ± 1.4% | not timed | not timed | 407.85 ± 0.2% | | 1.00 | 0.86 | 20.84 |
| 04-ruff-noqa/tweaked | 44 | 549.77 ± 0.2% | not timed | not timed | 462.14 ± 0.2% | 362.73 ± 0.4% | not timed | not timed | 549.39 ± 0.5% | | 1.00 | 1.19 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.33 ± 0.7% | not timed | not timed | 5.20 ± 0.1% | 0.20 ± 3.4% | not timed | not timed | 5.35 ± 3.7% | | 1.00 | 1.03 | 26.09 |
| 06-cloud-flare-redos/original | 107 | 415.05 ± 0.2% | not timed | not timed | 216.92 ± 0.1% | 24.92 ± 0.1% | not timed | not timed | 414.09 ± 0.7% | | 1.00 | 1.91 | 16.65 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.04 ± 0.3% | not timed | not timed | 228.53 ± 0.0% | 26.79 ± 3.8% | not timed | not timed | 410.47 ± 11.2% | | 1.00 | 1.79 | 15.30 |
| 06-cloud-flare-redos/simplified-long | 10000 | 586.94 ± 0.2% | not timed | not timed | 255.65 ± 0.2% | 28.80 ± 0.1% | not timed | not timed | 586.73 ± 0.0% | | 1.00 | 2.30 | 20.38 |
| 07-unicode-character-data/parse-line | 558784 | 230.84 ± 4.7% | not timed | not timed | 178.25 ± 0.1% | 42.93 ± 2.1% | not timed | not timed | 231.74 ± 0.3% | | 1.00 | 1.30 | 5.38 |
| 08-words/all-english | 56691 | 116.83 ± 0.8% | not timed | not timed | 82.50 ± 0.3% | 12.16 ± 12.2% | not timed | not timed | 116.46 ± 0.6% | | 1.00 | 1.42 | 9.61 |
| 08-words/long-english | 839 | 620.41 ± 0.2% | not timed | not timed | 597.48 ± 0.0% | 32.16 ± 0.1% | not timed | not timed | 620.11 ± 0.2% | | 1.00 | 1.04 | 19.29 |
| 09-aws-keys/full | 0 | 415.46 ± 0.3% | not timed | not timed | 495.56 ± 0.2% | 64.62 ± 3.6% | not timed | not timed | 414.61 ± 0.0% | | 1.00 | 0.84 | 6.43 |
| 09-aws-keys/quick | 0 | 732.01 ± 0.2% | not timed | not timed | 998.97 ± 0.3% | 417.66 ± 1.0% | not timed | not timed | 729.64 ± 0.1% | | 1.00 | 0.73 | 1.75 |
| 10-bounded-repeat/letters-en | 1833 | 587.67 ± 2.6% | not timed | not timed | 518.37 ± 0.2% | 19.50 ± 0.4% | not timed | not timed | 583.08 ± 0.8% | | 1.01 | 1.13 | 30.14 |
| 10-bounded-repeat/letters-ru | 3475 | 511.38 ± 1.1% | not timed | not timed | 478.69 ± 0.0% | 22.02 ± 8.1% | not timed | not timed | 508.68 ± 1.3% | | 1.01 | 1.07 | 23.23 |
| 10-bounded-repeat/context | 53 | 77.95 ± 0.5% | not timed | not timed | 65.87 ± 0.7% | 19.80 ± 0.3% | not timed | not timed | 77.37 ± 0.8% | | 1.01 | 1.18 | 3.94 |
| 10-bounded-repeat/capitals | 11 | 632.04 ± 8.3% | not timed | not timed | 615.64 ± 0.2% | 35.43 ± 0.5% | not timed | not timed | 630.93 ± 8.4% | | 1.00 | 1.03 | 17.84 |
| 11-unstructured-to-json/extract | 600 | 79.50 ± 0.1% | not timed | not timed | 77.17 ± 0.2% | 49.02 ± 0.3% | not timed | not timed | 81.34 ± 0.1% | | 0.98 | 1.03 | 1.62 |
| 12-dictionary/single | 1 | 561.43 ± 0.3% | not timed | not timed | 560.97 ± 0.1% | 0.40 ± 0.0% | not timed | not timed | 560.72 ± 0.3% | | 1.00 | 1.00 | 1400.78 |
| 14-quadratic/1x | 100 | 21.46 ± 1.6% | not timed | not timed | 10.07 ± 0.1% | 0.96 ± 2.9% | not timed | not timed | 21.40 ± 0.6% | | 1.00 | 2.13 | 22.37 |
| 14-quadratic/2x | 200 | 17.65 ± 0.6% | not timed | not timed | 5.54 ± 0.2% | 0.53 ± 1.9% | not timed | not timed | 17.61 ± 0.8% | | 1.00 | 3.19 | 33.30 |
| 14-quadratic/10x | 1000 | 7.70 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.9% | not timed | not timed | 7.68 ± 0.6% | | 1.00 | 6.35 | 66.74 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.29 ± 1.0% | not timed | not timed | 0.35 ± 0.2% | 0.55 ± 2.6% | not timed | not timed | 1.29 ± 0.7% | | 1.00 | 3.72 | 2.34 |
| 04-ruff-noqa/compile-real | 1 | 90.96 ± 0.2% | not timed | not timed | 13.92 ± 0.1% | 140.71 ± 2.6% | not timed | not timed | 90.58 ± 1.0% | | 1.00 | 6.53 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 13.93 ± 0.1% | not timed | not timed | 2.53 ± 0.8% | 6.52 ± 2.4% | not timed | not timed | 13.89 ± 1.0% | | 1.00 | 5.51 | 2.14 |
| 07-unicode-character-data/compile | 1 | 55.53 ± 0.1% | not timed | not timed | 26.02 ± 0.3% | 36.39 ± 4.0% | not timed | not timed | 55.11 ± 0.8% | | 1.01 | 2.13 | 1.53 |
| 09-aws-keys/compile-full | 1 | 42.18 ± 0.2% | not timed | not timed | 8.28 ± 0.3% | 23.52 ± 1.5% | not timed | not timed | 41.90 ± 0.6% | | 1.01 | 5.09 | 1.79 |
| 09-aws-keys/compile-quick | 1 | 182.43 ± 0.2% | not timed | not timed | 48.73 ± 1.1% | 136.83 ± 1.7% | not timed | not timed | 179.35 ± 1.1% | | 1.02 | 3.74 | 1.33 |
| 10-bounded-repeat/compile-context | 1 | 13.90 ± 0.7% | not timed | not timed | 11.23 ± 0.5% | 16.42 ± 2.9% | not timed | not timed | 13.77 ± 1.6% | | 1.01 | 1.24 | 0.85 |
| 10-bounded-repeat/compile-capitals | 1 | 82.44 ± 0.3% | not timed | not timed | 8.04 ± 0.6% | 24.15 ± 1.2% | not timed | not timed | 80.87 ± 2.6% | | 1.02 | 10.26 | 3.41 |
| 11-unstructured-to-json/compile | 1 | 86.12 ± 1.4% | not timed | not timed | 41.31 ± 0.5% | 68.90 ± 8.5% | not timed | not timed | 85.31 ± 1.0% | | 1.01 | 2.08 | 1.25 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.07 ± 0.2% | 0.10 ± 7.4% | not timed | not timed | 0.34 ± 1.2% | | 1.01 | 4.91 | 3.49 |

