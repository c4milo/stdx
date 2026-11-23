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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215464555 |
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
| literal: a word | 217 | 15983.45 ± 1.7% | 4997.19 ± 0.1% | 28.00 ± 0.6% | 17956.77 ± 1.6% | 9101.84 ± 8.3% | 17.43 ± 0.4% | 83.77 ± 1.0% | 16070.81 ± 1.6% | 3.20 | 0.99 | 0.89 | 1.76 |
| literal: a word that is not there | 0 | 18311.36 ± 1.5% | 4886.15 ± 0.4% | 27.99 ± 0.3% | 19265.15 ± 1.5% | 27333.76 ± 2.9% | 17.09 ± 0.3% | 79.66 ± 0.8% | 18627.37 ± 2.5% | 3.75 | 0.98 | 0.95 | 0.67 |
| literal: one of four words | 661 | 6079.08 ± 0.3% | 1935.80 ± 0.7% | 14.28 ± 0.2% | 3940.45 ± 0.1% | 21.92 ± 0.1% | 5.44 ± 0.6% | 6.89 ± 0.8% | 6069.19 ± 0.2% | 3.14 | 1.00 | 1.54 | 277.29 |
| literal: a word in any case | 217 | 12494.24 ± 0.6% | 2072.04 ± 0.3% | 21.02 ± 2.1% | 3969.48 ± 0.2% | 36.84 ± 0.3% | refused | differs | 12481.03 ± 0.7% | 6.03 | 1.00 | 3.15 | 339.16 |
| literal: an href attribute | 33 | 13754.26 ± 1.1% | 616.19 ± 0.1% | 27.05 ± 0.3% | 16987.16 ± 1.9% | 2256.26 ± 0.4% | 13.10 ± 0.1% | 73.95 ± 1.0% | 13712.06 ± 3.3% | 22.32 | 1.00 | 0.81 | 6.10 |
| literal: a word, second text | 123 | 16267.86 ± 2.0% | 3356.55 ± 0.2% | 27.82 ± 0.8% | 17675.42 ± 3.6% | 7502.65 ± 9.6% | 20.18 ± 0.4% | 70.10 ± 1.3% | 16287.25 ± 2.6% | 4.85 | 1.00 | 0.92 | 2.17 |
| class: two capitalized words | 1331 | 1063.04 ± 0.6% | 603.85 ± 0.1% | 25.81 ± 0.5% | 585.41 ± 0.1% | 40.53 ± 8.1% | 14.71 ± 0.2% | 67.51 ± 0.5% | 1063.14 ± 0.3% | 1.76 | 1.00 | 1.82 | 26.23 |
| class: a word that ends in ing | 3399 | 580.45 ± 0.1% | 579.17 ± 0.3% | 17.87 ± 0.2% | 547.95 ± 0.4% | 29.62 ± 6.4% | 8.21 ± 0.2% | 18.42 ± 0.8% | 580.00 ± 0.1% | 1.00 | 1.00 | 1.06 | 19.60 |
| class: a word in capitals | 2332 | 1374.37 ± 0.5% | 614.88 ± 0.1% | 27.31 ± 0.2% | 572.30 ± 0.1% | 43.21 ± 6.4% | 17.19 ± 0.3% | 82.12 ± 1.7% | 1370.27 ± 0.5% | 2.24 | 1.00 | 2.40 | 31.81 |
| class: a number | 8288 | 2005.90 ± 0.7% | 834.04 ± 0.1% | 27.50 ± 0.2% | 1725.58 ± 0.2% | 39.38 ± 13.6% | 0.55 ± 0.3% | 57.52 ± 1.0% | 2002.01 ± 0.1% | 2.41 | 1.00 | 1.16 | 50.94 |
| class: two capitalized words, second text | 5359 | 521.76 ± 0.2% | 528.66 ± 0.2% | 23.06 ± 0.4% | 485.26 ± 0.1% | 34.06 ± 10.1% | 17.13 ± 0.3% | 62.83 ± 0.8% | 520.95 ± 0.3% | 0.99 | 1.00 | 1.08 | 15.32 |
| other: a word between two words | 6104 | 741.02 ± 0.1% | 598.65 ± 0.1% | 23.32 ± 0.3% | 733.16 ± 0.4% | 109.49 ± 13.8% | 11.17 ± 0.2% | 68.30 ± 0.2% | 740.44 ± 0.1% | 1.24 | 1.00 | 1.01 | 6.77 |
| other: a number before a unit, second text | 1481 | 5328.80 ± 0.8% | 1109.61 ± 0.3% | 25.87 ± 0.1% | 5631.77 ± 0.7% | 40.74 ± 8.1% | 18.23 ± 0.2% | 65.69 ± 0.8% | 5333.22 ± 0.7% | 4.80 | 1.00 | 0.95 | 130.79 |
| other: a heading's start tag | 110 | 12541.27 ± 1.1% | 750.85 ± 0.1% | 27.10 ± 0.1% | 1707.70 ± 0.2% | 1576.82 ± 6.0% | 16.23 ± 0.4% | 86.06 ± 0.6% | 12590.84 ± 0.7% | 16.70 | 1.00 | 7.34 | 7.95 |
| other: a whole word | 217 | 13901.45 ± 1.1% | 608.34 ± 0.2% | 29.17 ± 0.5% | 14230.55 ± 1.2% | 47.64 ± 0.2% | 13.40 ± 0.1% | 54.99 ± 0.4% | 13974.92 ± 1.5% | 22.85 | 0.99 | 0.98 | 291.82 |
| other: a line's first word, second text | 3716 | 1946.42 ± 0.5% | 594.57 ± 0.1% | 30.95 ± 0.1% | 1727.61 ± 0.7% | 61.58 ± 8.6% | refused | refused | 1942.26 ± 0.6% | 3.27 | 1.00 | 1.13 | 31.61 |
| other: fourteen octets before an x | 87 | 19409.94 ± 1.3% | 245.98 ± 0.4% | 6.30 ± 0.0% | 3990.57 ± 0.6% | 10.62 ± 0.4% | differs | 17.75 ± 0.3% | 19434.64 ± 0.6% | 78.91 | 1.00 | 4.86 | 1827.28 |
| other: a Greek word | 21815 | 501.58 ± 0.7% | 412.65 ± 0.3% | 30.73 ± 0.3% | 289.84 ± 0.2% | 43.87 ± 9.7% | differs | refused | 498.83 ± 0.6% | 1.22 | 1.01 | 1.73 | 11.43 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.95 ± 0.2% | 19.98 ± 0.1% | 0.84 ± 0.1% | 19.89 ± 0.4% | 2.77 ± 0.6% | differs | 4.07 ± 0.2% | 19.96 ± 0.1% | 1.00 | 1.00 | 1.00 | 7.19 |
| a UUID | 32895 | 21.35 ± 0.2% | 21.40 ± 0.2% | 0.64 ± 0.3% | 15.12 ± 0.3% | 3.08 ± 0.3% | 0.73 ± 0.4% | 3.64 ± 0.5% | 21.41 ± 0.0% | 1.00 | 1.00 | 1.41 | 6.93 |
| an IPv4 address | 33176 | 36.90 ± 0.7% | 36.94 ± 0.8% | 2.05 ± 0.1% | 29.51 ± 0.5% | 6.66 ± 0.1% | differs | 4.16 ± 0.2% | 36.97 ± 0.4% | 1.00 | 1.00 | 1.25 | 5.54 |
| a date and time | 32954 | 31.54 ± 0.1% | 31.45 ± 0.3% | 1.41 ± 0.1% | 21.47 ± 0.8% | 7.03 ± 0.1% | 1.26 ± 0.2% | 7.21 ± 0.3% | 31.46 ± 0.3% | 1.00 | 1.00 | 1.47 | 4.48 |
| a field path | 32606 | 23.51 ± 0.2% | 23.58 ± 0.1% | 1.00 ± 0.3% | 23.28 ± 0.5% | 3.52 ± 0.4% | differs | 2.98 ± 0.1% | 23.56 ± 0.2% | 1.00 | 1.00 | 1.01 | 6.69 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.07 ± 0.4% | 11.11 ± 0.3% | 11.04 ± 0.3% | 11.83 ± 0.2% | 4.93 ± 1.2% | 0.94 ± 0.2% | none | 11.11 ± 0.2% | 1.00 | 1.00 | 0.94 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 230.72 ± 0.5% | 232.00 ± 0.3% | 277.49 ± 0.3% | 85.76 ± 0.7% | 220.60 ± 1.7% | 481.47 ± 1.2% | 3800.21 ± 0.3% | 230.83 ± 0.5% | 0.99 | 1.00 | 2.69 | 1.05 |
| a UUID | 62 | 151.86 ± 0.3% | 152.34 ± 0.2% | 171.41 ± 0.2% | 46.16 ± 0.4% | 98.16 ± 0.5% | 190.38 ± 2.8% | 4235.04 ± 0.2% | 151.81 ± 0.3% | 1.00 | 1.00 | 3.29 | 1.55 |
| an IPv4 address | 29 | 416.93 ± 0.3% | 421.73 ± 0.5% | 603.52 ± 0.2% | 76.29 ± 0.4% | 130.34 ± 1.1% | 303.32 ± 1.7% | 7572.03 ± 0.5% | 416.73 ± 0.5% | 0.99 | 1.00 | 5.47 | 3.20 |
| a date and time | 56 | 300.78 ± 0.3% | 303.08 ± 0.2% | 384.42 ± 0.2% | 72.26 ± 0.4% | 137.13 ± 1.5% | 325.05 ± 1.3% | 4906.32 ± 0.6% | 300.56 ± 0.2% | 0.99 | 1.00 | 4.16 | 2.19 |
| a field path | 39 | 226.49 ± 0.4% | 227.24 ± 0.3% | 269.62 ± 0.3% | 79.91 ± 1.3% | 205.05 ± 0.7% | 499.81 ± 2.9% | 4858.90 ± 2.3% | 226.70 ± 0.4% | 1.00 | 1.00 | 2.83 | 1.10 |
| literal: a word | 7 | 627.28 ± 0.6% | 675.01 ± 0.8% | 1245.01 ± 0.7% | 514.46 ± 0.2% | 630.91 ± 4.5% | 959.95 ± 0.5% | 31023.81 ± 0.2% | 626.60 ± 0.4% | 0.93 | 1.00 | 1.22 | 0.99 |
| literal: a word that is not there | 8 | 607.35 ± 0.5% | 655.28 ± 0.9% | 1172.79 ± 0.6% | 472.22 ± 0.4% | 607.76 ± 1.7% | 909.19 ± 0.4% | 29476.24 ± 0.3% | 607.23 ± 0.5% | 0.93 | 1.00 | 1.29 | 1.00 |
| literal: one of four words | 26 | 239.73 ± 0.3% | 399.01 ± 0.3% | 551.48 ± 0.3% | 50.05 ± 1.2% | 243.20 ± 1.2% | 374.42 ± 1.2% | 16044.61 ± 0.1% | 239.54 ± 0.2% | 0.60 | 1.00 | 4.79 | 0.99 |
| literal: a word in any case | 11 | 445.26 ± 0.3% | 474.35 ± 0.3% | 705.49 ± 0.2% | 15.80 ± 1.5% | 651.86 ± 2.2% | refused | 23684.35 ± 0.4% | 445.04 ± 0.1% | 0.94 | 1.00 | 28.18 | 0.68 |
| literal: an href attribute | 12 | 343.13 ± 0.2% | 355.77 ± 0.7% | 475.06 ± 0.4% | 43.84 ± 0.9% | 503.74 ± 1.7% | 773.60 ± 0.8% | 21926.74 ± 0.5% | 343.13 ± 0.5% | 0.96 | 1.00 | 7.83 | 0.68 |
| literal: a word, second text | 10 | 559.24 ± 1.3% | 612.88 ± 0.8% | 1056.01 ± 0.6% | 395.26 ± 0.4% | 537.00 ± 0.9% | 802.74 ± 0.5% | 27347.09 ± 0.2% | 559.36 ± 0.2% | 0.91 | 1.00 | 1.41 | 1.04 |
| class: two capitalized words | 23 | 428.34 ± 0.4% | 463.01 ± 0.6% | 686.56 ± 0.5% | 99.29 ± 0.2% | 498.46 ± 2.0% | 740.91 ± 0.6% | 6489.25 ± 0.4% | 427.84 ± 0.3% | 0.93 | 1.00 | 4.31 | 0.86 |
| class: a word that ends in ing | 9 | 550.97 ± 0.8% | 626.37 ± 0.5% | 1134.10 ± 0.4% | 131.65 ± 1.9% | 753.28 ± 1.3% | 1106.52 ± 0.7% | 16034.88 ± 0.2% | 549.78 ± 0.2% | 0.88 | 1.00 | 4.19 | 0.73 |
| class: a word in capitals | 16 | 482.16 ± 0.7% | 525.59 ± 1.0% | 883.44 ± 1.6% | 134.09 ± 0.5% | 757.98 ± 1.0% | 1019.09 ± 1.1% | 8540.07 ± 0.1% | 481.94 ± 0.8% | 0.92 | 1.00 | 3.60 | 0.64 |
| class: a number | 6 | 606.97 ± 0.3% | 676.49 ± 0.7% | 1351.52 ± 0.0% | 41.60 ± 0.7% | 1399.50 ± 2.1% | 1860.67 ± 1.5% | 22790.21 ± 0.1% | 607.22 ± 0.3% | 0.90 | 1.00 | 14.59 | 0.43 |
| class: two capitalized words, second text | 23 | 427.95 ± 0.4% | 462.36 ± 0.4% | 685.71 ± 0.3% | 100.38 ± 0.3% | 499.19 ± 1.0% | 762.20 ± 0.3% | 6491.70 ± 0.3% | 427.64 ± 0.3% | 0.93 | 1.00 | 4.26 | 0.86 |
| other: a word between two words | 13 | 542.23 ± 0.3% | 560.25 ± 0.2% | 922.49 ± 0.3% | 131.99 ± 0.6% | 502.43 ± 1.1% | 813.76 ± 0.5% | 14873.69 ± 0.1% | 542.76 ± 0.3% | 0.97 | 1.00 | 4.11 | 1.08 |
| other: a number before a unit, second text | 15 | 395.83 ± 0.6% | 438.64 ± 0.2% | 626.91 ± 0.3% | 39.32 ± 0.4% | 639.60 ± 1.5% | 891.37 ± 1.2% | 15214.02 ± 0.4% | 395.17 ± 0.4% | 0.90 | 1.00 | 10.07 | 0.62 |
| other: a heading's start tag | 13 | 354.89 ± 0.6% | 360.62 ± 0.6% | 485.66 ± 0.4% | 43.58 ± 0.6% | 634.40 ± 1.0% | 876.64 ± 0.7% | 18220.90 ± 0.4% | 355.14 ± 0.5% | 0.98 | 1.00 | 8.14 | 0.56 |
| other: a whole word | 11 | 574.40 ± 0.3% | 606.53 ± 0.3% | 1037.26 ± 0.3% | 117.16 ± 0.5% | 562.85 ± 2.2% | 838.47 ± 0.6% | 27165.90 ± 0.4% | 574.92 ± 0.3% | 0.95 | 1.00 | 4.90 | 1.02 |
| other: a line's first word, second text | 17 | 524.49 ± 0.4% | 542.31 ± 0.5% | 893.95 ± 0.1% | 128.00 ± 0.1% | 710.04 ± 1.8% | refused | refused | 523.18 ± 0.5% | 0.97 | 1.00 | 4.10 | 0.74 |
| other: fourteen octets before an x | 16 | 108.05 ± 0.5% | 155.61 ± 0.2% | 180.95 ± 0.3% | 14.87 ± 0.5% | 452.60 ± 0.8% | 412.30 ± 0.5% | 12929.27 ± 0.4% | 107.84 ± 0.3% | 0.69 | 1.00 | 7.27 | 0.24 |
| other: a Greek word | 8 | 423.12 ± 0.3% | 586.99 ± 0.2% | 1046.16 ± 0.1% | 58.63 ± 0.6% | 1389.23 ± 1.8% | 1791.51 ± 0.6% | refused | 422.92 ± 0.2% | 0.72 | 1.00 | 7.22 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12575.94 ± 0.9% | not timed | not timed | 15953.20 ± 2.2% | 2083.68 ± 8.0% | not timed | not timed | 12530.57 ± 0.9% | | 1.00 | 0.79 | 6.04 |
| 01-literal/sherlock-casei-en | 522 | 4948.39 ± 1.0% | not timed | not timed | 3593.05 ± 0.9% | 31.47 ± 3.2% | not timed | not timed | 4938.09 ± 0.4% | | 1.00 | 1.38 | 157.25 |
| 01-literal/sherlock-ru | 724 | 13506.70 ± 0.9% | not timed | not timed | 17294.49 ± 0.5% | 1539.58 ± 24.8% | not timed | not timed | 13482.90 ± 0.3% | | 1.00 | 0.78 | 8.77 |
| 01-literal/sherlock-casei-ru | 746 | 5982.03 ± 0.1% | not timed | not timed | 3330.91 ± 0.2% | 31.50 ± 7.9% | not timed | not timed | 5974.54 ± 0.6% | | 1.00 | 1.80 | 189.92 |
| 01-literal/sherlock-zh | 30 | 16816.39 ± 0.6% | not timed | not timed | 18344.62 ± 1.2% | 2902.10 ± 10.7% | not timed | not timed | 16742.35 ± 0.7% | | 1.00 | 0.92 | 5.79 |
| 02-literal-alternate/sherlock-en | 714 | 5760.96 ± 0.6% | not timed | not timed | 3940.60 ± 0.3% | 16.67 ± 0.2% | not timed | not timed | 5755.80 ± 0.2% | | 1.00 | 1.46 | 345.68 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1805.89 ± 1.4% | not timed | not timed | 695.83 ± 0.1% | 11.05 ± 0.1% | not timed | not timed | 1794.42 ± 0.6% | | 1.01 | 2.60 | 163.37 |
| 02-literal-alternate/sherlock-ru | 899 | 5336.27 ± 11.0% | not timed | not timed | 3265.65 ± 1.3% | 22.67 ± 0.1% | not timed | not timed | 5329.00 ± 0.5% | | 1.00 | 1.63 | 235.42 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1916.80 ± 0.6% | not timed | not timed | 1232.16 ± 0.2% | 9.15 ± 0.2% | not timed | not timed | 1910.96 ± 0.2% | | 1.00 | 1.56 | 209.49 |
| 02-literal-alternate/sherlock-zh | 207 | 7072.74 ± 0.2% | not timed | not timed | 4164.35 ± 0.1% | 31.56 ± 0.0% | not timed | not timed | 7065.98 ± 0.1% | | 1.00 | 1.70 | 224.08 |
| 03-date/ascii | 111817 | 126.44 ± 0.7% | not timed | not timed | 95.96 ± 0.1% | 0.20 ± 5.7% | not timed | not timed | 125.75 ± 0.5% | | 1.01 | 1.32 | 619.53 |
| 04-ruff-noqa/real | 84 | 409.18 ± 0.1% | not timed | not timed | 474.45 ± 0.0% | 19.55 ± 1.3% | not timed | not timed | 408.05 ± 0.1% | | 1.00 | 0.86 | 20.93 |
| 04-ruff-noqa/tweaked | 44 | 550.14 ± 0.2% | not timed | not timed | 469.58 ± 0.2% | 360.23 ± 0.5% | not timed | not timed | 549.47 ± 0.2% | | 1.00 | 1.17 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.35 ± 0.2% | not timed | not timed | 5.24 ± 0.1% | 0.20 ± 2.4% | not timed | not timed | 5.36 ± 1.8% | | 1.00 | 1.02 | 26.52 |
| 06-cloud-flare-redos/original | 107 | 415.39 ± 0.2% | not timed | not timed | 216.87 ± 0.0% | 24.83 ± 0.1% | not timed | not timed | 414.93 ± 0.2% | | 1.00 | 1.92 | 16.73 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.21 ± 0.2% | not timed | not timed | 226.57 ± 0.1% | 26.80 ± 0.2% | not timed | not timed | 410.48 ± 0.2% | | 1.00 | 1.81 | 15.31 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.91 ± 0.2% | not timed | not timed | 254.88 ± 1.3% | 28.82 ± 0.1% | not timed | not timed | 587.00 ± 0.1% | | 1.00 | 2.31 | 20.40 |
| 07-unicode-character-data/parse-line | 558784 | 230.88 ± 0.1% | not timed | not timed | 178.28 ± 0.1% | 42.08 ± 16.6% | not timed | not timed | 231.50 ± 2.0% | | 1.00 | 1.30 | 5.49 |
| 08-words/all-english | 56691 | 116.84 ± 0.6% | not timed | not timed | 83.11 ± 0.1% | 12.97 ± 5.2% | not timed | not timed | 116.14 ± 0.1% | | 1.01 | 1.41 | 9.01 |
| 08-words/long-english | 839 | 620.81 ± 0.2% | not timed | not timed | 596.39 ± 0.1% | 32.13 ± 0.6% | not timed | not timed | 620.81 ± 0.1% | | 1.00 | 1.04 | 19.32 |
| 09-aws-keys/full | 0 | 415.48 ± 0.1% | not timed | not timed | 493.28 ± 0.2% | 66.97 ± 3.6% | not timed | not timed | 414.68 ± 0.1% | | 1.00 | 0.84 | 6.20 |
| 09-aws-keys/quick | 0 | 732.50 ± 0.1% | not timed | not timed | 977.43 ± 0.2% | 418.44 ± 0.5% | not timed | not timed | 729.76 ± 0.0% | | 1.00 | 0.75 | 1.75 |
| 10-bounded-repeat/letters-en | 1833 | 581.16 ± 1.5% | not timed | not timed | 517.31 ± 0.5% | 19.49 ± 1.0% | not timed | not timed | 578.16 ± 0.6% | | 1.01 | 1.12 | 29.82 |
| 10-bounded-repeat/letters-ru | 3475 | 510.27 ± 1.0% | not timed | not timed | 479.10 ± 0.2% | 22.44 ± 8.4% | not timed | not timed | 506.87 ± 1.0% | | 1.01 | 1.07 | 22.74 |
| 10-bounded-repeat/context | 53 | 77.60 ± 0.6% | not timed | not timed | 65.58 ± 0.5% | 19.81 ± 0.2% | not timed | not timed | 77.17 ± 0.4% | | 1.01 | 1.18 | 3.92 |
| 10-bounded-repeat/capitals | 11 | 631.20 ± 8.4% | not timed | not timed | 618.40 ± 0.1% | 35.12 ± 0.0% | not timed | not timed | 630.80 ± 8.3% | | 1.00 | 1.02 | 17.98 |
| 11-unstructured-to-json/extract | 600 | 79.49 ± 0.1% | not timed | not timed | 77.00 ± 0.2% | 49.00 ± 0.3% | not timed | not timed | 81.37 ± 0.2% | | 0.98 | 1.03 | 1.62 |
| 12-dictionary/single | 1 | 560.93 ± 0.3% | not timed | not timed | 562.48 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 560.17 ± 0.1% | | 1.00 | 1.00 | 1387.12 |
| 14-quadratic/1x | 100 | 21.48 ± 2.8% | not timed | not timed | 10.04 ± 0.2% | 0.98 ± 3.9% | not timed | not timed | 21.42 ± 2.8% | | 1.00 | 2.14 | 21.92 |
| 14-quadratic/2x | 200 | 17.68 ± 0.9% | not timed | not timed | 5.55 ± 0.2% | 0.53 ± 2.2% | not timed | not timed | 17.64 ± 0.5% | | 1.00 | 3.19 | 33.39 |
| 14-quadratic/10x | 1000 | 7.70 ± 0.7% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 7.65 ± 0.8% | | 1.01 | 6.34 | 66.69 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.29 ± 0.9% | not timed | not timed | 0.34 ± 0.2% | 0.54 ± 3.5% | not timed | not timed | 1.29 ± 3.0% | | 1.00 | 3.77 | 2.40 |
| 04-ruff-noqa/compile-real | 1 | 91.32 ± 0.2% | not timed | not timed | 13.73 ± 0.2% | 136.88 ± 2.1% | not timed | not timed | 90.97 ± 0.8% | | 1.00 | 6.65 | 0.67 |
| 05-lexer-veryl/compile-single | 1 | 13.95 ± 0.8% | not timed | not timed | 2.51 ± 0.2% | 6.33 ± 1.3% | not timed | not timed | 13.91 ± 0.9% | | 1.00 | 5.55 | 2.21 |
| 07-unicode-character-data/compile | 1 | 55.50 ± 0.2% | not timed | not timed | 25.91 ± 0.4% | 35.31 ± 1.9% | not timed | not timed | 55.08 ± 1.6% | | 1.01 | 2.14 | 1.57 |
| 09-aws-keys/compile-full | 1 | 42.20 ± 0.7% | not timed | not timed | 8.22 ± 0.5% | 22.93 ± 1.9% | not timed | not timed | 41.84 ± 0.5% | | 1.01 | 5.14 | 1.84 |
| 09-aws-keys/compile-quick | 1 | 181.35 ± 0.1% | not timed | not timed | 46.81 ± 0.1% | 131.04 ± 1.1% | not timed | not timed | 180.31 ± 0.8% | | 1.01 | 3.87 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 13.89 ± 0.8% | not timed | not timed | 11.12 ± 0.1% | 15.66 ± 2.0% | not timed | not timed | 13.81 ± 1.3% | | 1.01 | 1.25 | 0.89 |
| 10-bounded-repeat/compile-capitals | 1 | 82.46 ± 0.2% | not timed | not timed | 7.96 ± 0.7% | 23.49 ± 1.9% | not timed | not timed | 82.38 ± 0.1% | | 1.00 | 10.36 | 3.51 |
| 11-unstructured-to-json/compile | 1 | 86.52 ± 0.4% | not timed | not timed | 40.83 ± 0.2% | 66.58 ± 3.3% | not timed | not timed | 85.87 ± 0.9% | | 1.01 | 2.12 | 1.30 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.1% | not timed | not timed | 0.07 ± 1.1% | 0.09 ± 7.8% | not timed | not timed | 0.34 ± 1.7% | | 1.01 | 5.07 | 3.73 |

