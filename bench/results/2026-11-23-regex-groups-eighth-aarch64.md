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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215386835 |
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
| literal: a word | 217 | 16176.93 ± 1.3% | 4997.67 ± 0.3% | 27.95 ± 1.0% | 18275.79 ± 1.8% | 9126.39 ± 11.6% | 17.37 ± 0.3% | 83.61 ± 0.7% | 16227.08 ± 1.4% | 3.24 | 1.00 | 0.89 | 1.77 |
| literal: a word that is not there | 0 | 18664.97 ± 1.3% | 4881.61 ± 0.3% | 28.01 ± 0.3% | 19835.59 ± 2.7% | 29128.59 ± 0.6% | 17.13 ± 0.2% | 79.62 ± 0.7% | 18757.43 ± 1.5% | 3.82 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6076.87 ± 0.2% | 1934.64 ± 0.2% | 13.98 ± 0.4% | 3943.48 ± 0.5% | 21.91 ± 0.2% | 5.44 ± 0.2% | 6.90 ± 0.2% | 6068.46 ± 0.4% | 3.14 | 1.00 | 1.54 | 277.30 |
| literal: a word in any case | 217 | 12587.02 ± 0.3% | 2073.95 ± 0.2% | 20.97 ± 0.3% | 3966.56 ± 0.3% | 36.84 ± 0.2% | refused | differs | 12583.33 ± 0.1% | 6.07 | 1.00 | 3.17 | 341.68 |
| literal: an href attribute | 33 | 13744.12 ± 0.7% | 616.09 ± 0.0% | 27.03 ± 0.1% | 17072.96 ± 0.4% | 2254.89 ± 6.7% | 13.04 ± 0.4% | 73.84 ± 1.5% | 13755.97 ± 0.7% | 22.31 | 1.00 | 0.81 | 6.10 |
| literal: a word, second text | 123 | 16404.28 ± 0.7% | 3351.03 ± 0.3% | 27.67 ± 0.2% | 18277.81 ± 1.7% | 7415.19 ± 2.4% | 20.10 ± 0.7% | 70.03 ± 0.9% | 16408.31 ± 0.3% | 4.90 | 1.00 | 0.90 | 2.21 |
| class: two capitalized words | 1331 | 1063.34 ± 0.3% | 603.83 ± 0.1% | 25.77 ± 0.3% | 585.28 ± 0.1% | 40.49 ± 0.3% | 14.75 ± 0.2% | 67.18 ± 1.4% | 1064.31 ± 0.3% | 1.76 | 1.00 | 1.82 | 26.26 |
| class: a word that ends in ing | 3399 | 580.32 ± 0.2% | 578.31 ± 0.7% | 17.87 ± 0.3% | 547.76 ± 0.0% | 29.59 ± 11.0% | 8.21 ± 0.1% | 18.42 ± 1.0% | 579.59 ± 0.1% | 1.00 | 1.00 | 1.06 | 19.61 |
| class: a word in capitals | 2332 | 1374.33 ± 0.4% | 614.93 ± 0.2% | 27.26 ± 0.5% | 571.22 ± 0.1% | 43.28 ± 8.9% | 17.17 ± 0.4% | 82.67 ± 0.5% | 1373.44 ± 0.3% | 2.23 | 1.00 | 2.41 | 31.76 |
| class: a number | 8288 | 2005.87 ± 0.6% | 834.19 ± 0.1% | 27.56 ± 0.2% | 1723.53 ± 0.2% | 40.81 ± 11.8% | 0.53 ± 0.6% | 57.78 ± 0.4% | 1999.01 ± 0.4% | 2.40 | 1.00 | 1.16 | 49.15 |
| class: two capitalized words, second text | 5359 | 521.55 ± 0.2% | 519.96 ± 0.1% | 23.05 ± 0.2% | 484.94 ± 0.0% | 35.29 ± 6.0% | 17.12 ± 0.2% | 62.88 ± 0.3% | 521.14 ± 0.1% | 1.00 | 1.00 | 1.08 | 14.78 |
| other: a word between two words | 6104 | 740.99 ± 0.2% | 592.58 ± 0.1% | 23.31 ± 0.2% | 734.18 ± 0.4% | 109.35 ± 9.6% | 11.21 ± 0.2% | 68.35 ± 0.3% | 740.28 ± 0.1% | 1.25 | 1.00 | 1.01 | 6.78 |
| other: a number before a unit, second text | 1481 | 5323.87 ± 0.6% | 1103.74 ± 0.1% | 25.85 ± 0.1% | 5670.29 ± 0.3% | 40.61 ± 0.2% | 18.20 ± 0.1% | 65.88 ± 0.2% | 5328.81 ± 0.2% | 4.82 | 1.00 | 0.94 | 131.10 |
| other: a heading's start tag | 110 | 12607.47 ± 0.4% | 750.91 ± 0.1% | 27.11 ± 0.2% | 1706.39 ± 0.3% | 1572.60 ± 1.6% | 16.05 ± 0.2% | 86.05 ± 0.8% | 12628.41 ± 0.2% | 16.79 | 1.00 | 7.39 | 8.02 |
| other: a whole word | 217 | 14066.51 ± 0.7% | 608.55 ± 0.1% | 29.12 ± 0.7% | 14479.72 ± 0.6% | 47.61 ± 0.4% | 13.38 ± 0.0% | 55.16 ± 0.2% | 14042.84 ± 0.9% | 23.11 | 1.00 | 0.97 | 295.43 |
| other: a line's first word, second text | 3716 | 1944.95 ± 0.8% | 594.19 ± 0.1% | 30.88 ± 0.5% | 1726.17 ± 0.3% | 62.56 ± 6.8% | refused | refused | 1940.65 ± 0.5% | 3.27 | 1.00 | 1.13 | 31.09 |
| other: fourteen octets before an x | 87 | 19653.24 ± 1.0% | 250.59 ± 0.4% | 6.30 ± 0.1% | 4034.00 ± 0.3% | 10.63 ± 0.2% | differs | 17.76 ± 0.1% | 19665.14 ± 1.5% | 78.43 | 1.00 | 4.87 | 1849.37 |
| other: a Greek word | 21815 | 502.51 ± 0.9% | 412.64 ± 0.2% | 30.70 ± 0.2% | 289.79 ± 0.2% | 46.59 ± 9.8% | differs | refused | 500.12 ± 0.8% | 1.22 | 1.00 | 1.73 | 10.79 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.89 ± 0.2% | 19.92 ± 0.1% | 0.84 ± 0.1% | 19.89 ± 0.4% | 2.78 ± 1.2% | differs | 4.07 ± 0.3% | 19.91 ± 0.1% | 1.00 | 1.00 | 1.00 | 7.16 |
| a UUID | 32895 | 21.35 ± 0.2% | 21.41 ± 0.6% | 0.64 ± 0.1% | 15.14 ± 0.3% | 3.09 ± 0.5% | 0.73 ± 0.3% | 3.65 ± 0.4% | 21.41 ± 0.1% | 1.00 | 1.00 | 1.41 | 6.91 |
| an IPv4 address | 33176 | 36.79 ± 0.3% | 36.90 ± 0.1% | 2.05 ± 0.1% | 29.53 ± 0.3% | 6.64 ± 0.1% | differs | 4.15 ± 0.4% | 36.86 ± 0.1% | 1.00 | 1.00 | 1.25 | 5.54 |
| a date and time | 32954 | 31.54 ± 0.1% | 31.40 ± 0.2% | 1.41 ± 0.3% | 21.54 ± 0.4% | 7.04 ± 0.3% | 1.26 ± 0.2% | 7.17 ± 0.4% | 31.40 ± 0.3% | 1.00 | 1.00 | 1.46 | 4.48 |
| a field path | 32606 | 23.48 ± 0.1% | 23.57 ± 0.1% | 1.00 ± 0.3% | 23.36 ± 0.2% | 3.48 ± 2.0% | differs | 2.98 ± 0.1% | 23.55 ± 0.2% | 1.00 | 1.00 | 1.01 | 6.74 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.07 ± 0.2% | 11.10 ± 0.2% | 11.08 ± 0.4% | 11.83 ± 0.1% | 4.91 ± 2.0% | 0.94 ± 0.4% | none | 11.10 ± 0.5% | 1.00 | 1.00 | 0.94 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 231.04 ± 0.4% | 231.85 ± 0.2% | 277.23 ± 0.2% | 86.84 ± 0.6% | 220.36 ± 0.6% | 480.90 ± 1.1% | 3798.66 ± 0.9% | 230.97 ± 0.3% | 1.00 | 1.00 | 2.66 | 1.05 |
| a UUID | 62 | 151.70 ± 0.2% | 152.06 ± 0.2% | 171.35 ± 0.3% | 46.63 ± 0.7% | 100.05 ± 1.5% | 190.44 ± 2.8% | 4239.04 ± 0.7% | 151.65 ± 0.2% | 1.00 | 1.00 | 3.25 | 1.52 |
| an IPv4 address | 29 | 416.88 ± 0.6% | 420.94 ± 0.3% | 602.58 ± 0.3% | 77.13 ± 0.5% | 131.73 ± 1.7% | 304.64 ± 1.4% | 7563.73 ± 0.3% | 416.98 ± 0.2% | 0.99 | 1.00 | 5.40 | 3.16 |
| a date and time | 56 | 300.78 ± 0.1% | 303.39 ± 0.5% | 384.13 ± 0.3% | 73.31 ± 0.4% | 137.82 ± 3.1% | 324.16 ± 0.8% | 4913.22 ± 0.7% | 300.62 ± 0.2% | 0.99 | 1.00 | 4.10 | 2.18 |
| a field path | 39 | 226.40 ± 0.2% | 227.11 ± 0.4% | 269.69 ± 0.2% | 81.25 ± 1.3% | 207.78 ± 1.8% | 500.80 ± 3.2% | 4857.14 ± 1.1% | 226.54 ± 0.1% | 1.00 | 1.00 | 2.79 | 1.09 |
| literal: a word | 7 | 626.70 ± 0.4% | 676.11 ± 0.6% | 1244.23 ± 0.2% | 526.43 ± 0.2% | 634.08 ± 5.0% | 958.10 ± 0.7% | 30984.35 ± 0.3% | 626.30 ± 0.2% | 0.93 | 1.00 | 1.19 | 0.99 |
| literal: a word that is not there | 8 | 606.30 ± 0.3% | 654.92 ± 0.5% | 1171.55 ± 0.4% | 483.97 ± 0.1% | 608.42 ± 1.0% | 909.21 ± 0.5% | 29464.82 ± 0.2% | 605.88 ± 0.3% | 0.93 | 1.00 | 1.25 | 1.00 |
| literal: one of four words | 26 | 239.37 ± 0.1% | 398.57 ± 0.3% | 549.75 ± 0.4% | 50.24 ± 1.2% | 241.66 ± 1.8% | 375.39 ± 0.9% | 16054.04 ± 0.2% | 239.34 ± 0.2% | 0.60 | 1.00 | 4.76 | 0.99 |
| literal: a word in any case | 11 | 445.16 ± 0.2% | 474.01 ± 0.2% | 705.26 ± 0.1% | 15.89 ± 1.7% | 661.95 ± 2.6% | refused | 23721.14 ± 0.2% | 445.01 ± 0.1% | 0.94 | 1.00 | 28.01 | 0.67 |
| literal: an href attribute | 12 | 343.17 ± 0.4% | 356.12 ± 0.4% | 475.86 ± 0.5% | 45.89 ± 0.2% | 502.21 ± 1.5% | 773.13 ± 0.9% | 21975.17 ± 0.6% | 343.34 ± 0.7% | 0.96 | 1.00 | 7.48 | 0.68 |
| literal: a word, second text | 10 | 556.42 ± 0.9% | 613.78 ± 0.7% | 1054.69 ± 1.0% | 402.89 ± 0.2% | 534.88 ± 1.5% | 803.03 ± 0.6% | 27328.62 ± 0.3% | 556.46 ± 0.1% | 0.91 | 1.00 | 1.38 | 1.04 |
| class: two capitalized words | 23 | 428.07 ± 0.6% | 461.85 ± 0.5% | 685.79 ± 0.6% | 100.34 ± 0.2% | 505.59 ± 5.6% | 742.82 ± 0.6% | 6489.74 ± 0.5% | 428.16 ± 0.6% | 0.93 | 1.00 | 4.27 | 0.85 |
| class: a word that ends in ing | 9 | 549.67 ± 0.3% | 625.76 ± 0.5% | 1132.82 ± 0.3% | 132.68 ± 2.1% | 761.74 ± 0.9% | 1108.41 ± 0.5% | 15976.27 ± 0.2% | 549.20 ± 0.2% | 0.88 | 1.00 | 4.14 | 0.72 |
| class: a word in capitals | 16 | 481.27 ± 0.5% | 525.02 ± 0.5% | 880.15 ± 0.4% | 135.84 ± 0.5% | 754.97 ± 1.4% | 1023.14 ± 0.7% | 8534.54 ± 0.2% | 481.16 ± 0.2% | 0.92 | 1.00 | 3.54 | 0.64 |
| class: a number | 6 | 605.49 ± 0.3% | 676.36 ± 0.4% | 1350.47 ± 0.1% | 41.86 ± 0.8% | 1417.88 ± 1.5% | 1852.50 ± 1.3% | 22791.37 ± 0.1% | 605.15 ± 0.4% | 0.90 | 1.00 | 14.47 | 0.43 |
| class: two capitalized words, second text | 23 | 427.54 ± 0.7% | 461.87 ± 0.7% | 685.09 ± 0.7% | 101.74 ± 0.5% | 503.89 ± 2.2% | 763.33 ± 0.8% | 6485.81 ± 0.5% | 427.43 ± 0.3% | 0.93 | 1.00 | 4.20 | 0.85 |
| other: a word between two words | 13 | 541.70 ± 0.3% | 559.16 ± 0.2% | 921.68 ± 0.2% | 133.54 ± 0.7% | 504.06 ± 1.1% | 814.64 ± 0.9% | 14869.28 ± 0.1% | 541.61 ± 0.3% | 0.97 | 1.00 | 4.06 | 1.07 |
| other: a number before a unit, second text | 15 | 394.97 ± 0.1% | 437.31 ± 0.5% | 624.87 ± 0.3% | 39.60 ± 0.4% | 636.76 ± 1.3% | 890.79 ± 0.9% | 15239.27 ± 0.4% | 394.88 ± 0.1% | 0.90 | 1.00 | 9.97 | 0.62 |
| other: a heading's start tag | 13 | 354.57 ± 0.2% | 359.97 ± 0.2% | 485.20 ± 0.1% | 44.05 ± 0.6% | 633.33 ± 0.4% | 879.18 ± 0.6% | 18270.35 ± 0.6% | 354.35 ± 0.3% | 0.98 | 1.00 | 8.05 | 0.56 |
| other: a whole word | 11 | 574.59 ± 0.4% | 607.86 ± 0.2% | 1036.15 ± 0.2% | 118.41 ± 0.4% | 563.60 ± 3.1% | 836.92 ± 0.3% | 27248.73 ± 0.4% | 575.40 ± 0.1% | 0.95 | 1.00 | 4.85 | 1.02 |
| other: a line's first word, second text | 17 | 523.42 ± 0.1% | 543.12 ± 0.4% | 893.50 ± 0.2% | 129.74 ± 0.1% | 712.64 ± 1.0% | refused | refused | 521.09 ± 0.5% | 0.96 | 1.00 | 4.03 | 0.73 |
| other: fourteen octets before an x | 16 | 107.70 ± 0.9% | 154.84 ± 0.3% | 180.51 ± 0.3% | 15.24 ± 0.4% | 452.29 ± 3.6% | 413.12 ± 1.0% | 12940.13 ± 0.4% | 107.76 ± 0.5% | 0.70 | 1.00 | 7.07 | 0.24 |
| other: a Greek word | 8 | 422.52 ± 0.3% | 585.67 ± 0.4% | 1044.26 ± 0.6% | 59.21 ± 0.8% | 1400.71 ± 0.9% | 1791.53 ± 0.7% | refused | 422.61 ± 0.2% | 0.72 | 1.00 | 7.14 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12845.25 ± 0.2% | not timed | not timed | 16483.89 ± 0.6% | 2007.74 ± 21.1% | not timed | not timed | 12828.15 ± 0.7% | | 1.00 | 0.78 | 6.40 |
| 01-literal/sherlock-casei-en | 522 | 4956.69 ± 1.0% | not timed | not timed | 3591.06 ± 0.2% | 32.17 ± 2.2% | not timed | not timed | 4947.14 ± 0.4% | | 1.00 | 1.38 | 154.10 |
| 01-literal/sherlock-ru | 724 | 13518.27 ± 0.5% | not timed | not timed | 17337.03 ± 0.2% | 1538.05 ± 6.6% | not timed | not timed | 13488.64 ± 0.7% | | 1.00 | 0.78 | 8.79 |
| 01-literal/sherlock-casei-ru | 746 | 5981.94 ± 0.3% | not timed | not timed | 3330.14 ± 0.2% | 31.50 ± 0.8% | not timed | not timed | 5984.08 ± 0.3% | | 1.00 | 1.80 | 189.92 |
| 01-literal/sherlock-zh | 30 | 17252.94 ± 0.3% | not timed | not timed | 18914.89 ± 0.5% | 2706.71 ± 9.5% | not timed | not timed | 17211.10 ± 0.2% | | 1.00 | 0.91 | 6.37 |
| 02-literal-alternate/sherlock-en | 714 | 5760.84 ± 0.4% | not timed | not timed | 3937.29 ± 0.2% | 16.67 ± 0.5% | not timed | not timed | 5755.68 ± 0.2% | | 1.00 | 1.46 | 345.63 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1801.74 ± 1.4% | not timed | not timed | 694.66 ± 0.6% | 11.05 ± 0.4% | not timed | not timed | 1793.27 ± 1.0% | | 1.00 | 2.59 | 163.00 |
| 02-literal-alternate/sherlock-ru | 899 | 5345.02 ± 1.1% | not timed | not timed | 3265.60 ± 0.6% | 22.67 ± 0.1% | not timed | not timed | 5339.35 ± 0.4% | | 1.00 | 1.64 | 235.74 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1919.26 ± 0.6% | not timed | not timed | 1229.76 ± 0.4% | 9.14 ± 0.1% | not timed | not timed | 1911.92 ± 0.2% | | 1.00 | 1.56 | 209.94 |
| 02-literal-alternate/sherlock-zh | 207 | 7039.40 ± 0.2% | not timed | not timed | 4164.92 ± 0.2% | 31.49 ± 0.1% | not timed | not timed | 7041.74 ± 0.2% | | 1.00 | 1.69 | 223.57 |
| 03-date/ascii | 111817 | 126.21 ± 0.6% | not timed | not timed | 96.05 ± 0.1% | 0.20 ± 3.7% | not timed | not timed | 125.77 ± 0.8% | | 1.00 | 1.31 | 623.04 |
| 04-ruff-noqa/real | 84 | 409.40 ± 0.0% | not timed | not timed | 478.94 ± 0.1% | 19.55 ± 1.4% | not timed | not timed | 408.09 ± 0.1% | | 1.00 | 0.85 | 20.94 |
| 04-ruff-noqa/tweaked | 44 | 550.42 ± 0.2% | not timed | not timed | 462.34 ± 0.1% | 363.50 ± 1.1% | not timed | not timed | 549.52 ± 0.2% | | 1.00 | 1.19 | 1.51 |
| 05-lexer-veryl/single | 124800 | 5.34 ± 0.3% | not timed | not timed | 5.19 ± 0.5% | 0.21 ± 4.1% | not timed | not timed | 5.36 ± 2.9% | | 1.00 | 1.03 | 25.82 |
| 06-cloud-flare-redos/original | 107 | 412.66 ± 0.1% | not timed | not timed | 216.97 ± 0.1% | 24.99 ± 0.1% | not timed | not timed | 414.51 ± 0.2% | | 1.00 | 1.90 | 16.51 |
| 06-cloud-flare-redos/simplified-short | 102 | 409.68 ± 0.1% | not timed | not timed | 228.44 ± 0.1% | 26.74 ± 0.1% | not timed | not timed | 410.48 ± 0.2% | | 1.00 | 1.79 | 15.32 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.03 ± 0.2% | not timed | not timed | 255.85 ± 0.4% | 28.86 ± 0.1% | not timed | not timed | 587.03 ± 0.1% | | 1.00 | 2.30 | 20.38 |
| 07-unicode-character-data/parse-line | 558784 | 231.00 ± 0.3% | not timed | not timed | 178.34 ± 0.1% | 42.64 ± 4.7% | not timed | not timed | 231.01 ± 2.0% | | 1.00 | 1.30 | 5.42 |
| 08-words/all-english | 56691 | 116.73 ± 0.3% | not timed | not timed | 82.53 ± 0.1% | 12.81 ± 12.2% | not timed | not timed | 116.46 ± 0.6% | | 1.00 | 1.41 | 9.11 |
| 08-words/long-english | 839 | 620.56 ± 0.2% | not timed | not timed | 597.50 ± 0.1% | 32.21 ± 0.6% | not timed | not timed | 620.85 ± 0.2% | | 1.00 | 1.04 | 19.26 |
| 09-aws-keys/full | 0 | 415.43 ± 0.1% | not timed | not timed | 495.82 ± 0.1% | 64.32 ± 3.4% | not timed | not timed | 414.58 ± 0.5% | | 1.00 | 0.84 | 6.46 |
| 09-aws-keys/quick | 0 | 731.97 ± 0.1% | not timed | not timed | 997.80 ± 0.3% | 420.12 ± 0.4% | not timed | not timed | 729.79 ± 0.2% | | 1.00 | 0.73 | 1.74 |
| 10-bounded-repeat/letters-en | 1833 | 585.15 ± 2.6% | not timed | not timed | 518.42 ± 0.3% | 19.48 ± 0.4% | not timed | not timed | 579.27 ± 1.9% | | 1.01 | 1.13 | 30.04 |
| 10-bounded-repeat/letters-ru | 3475 | 510.38 ± 0.6% | not timed | not timed | 479.05 ± 0.1% | 22.54 ± 16.6% | not timed | not timed | 503.54 ± 1.0% | | 1.01 | 1.07 | 22.64 |
| 10-bounded-repeat/context | 53 | 77.79 ± 0.4% | not timed | not timed | 65.89 ± 0.4% | 19.78 ± 0.2% | not timed | not timed | 77.28 ± 0.5% | | 1.01 | 1.18 | 3.93 |
| 10-bounded-repeat/capitals | 11 | 631.51 ± 8.4% | not timed | not timed | 618.17 ± 0.0% | 36.49 ± 0.1% | not timed | not timed | 630.90 ± 8.3% | | 1.00 | 1.02 | 17.31 |
| 11-unstructured-to-json/extract | 600 | 79.49 ± 0.1% | not timed | not timed | 77.32 ± 0.4% | 49.11 ± 1.5% | not timed | not timed | 80.86 ± 0.6% | | 0.98 | 1.03 | 1.62 |
| 12-dictionary/single | 1 | 560.23 ± 0.5% | not timed | not timed | 560.12 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 560.25 ± 0.3% | | 1.00 | 1.00 | 1387.25 |
| 14-quadratic/1x | 100 | 21.54 ± 1.6% | not timed | not timed | 10.04 ± 0.2% | 0.96 ± 3.4% | not timed | not timed | 21.42 ± 1.3% | | 1.01 | 2.15 | 22.34 |
| 14-quadratic/2x | 200 | 17.70 ± 0.5% | not timed | not timed | 5.55 ± 0.1% | 0.48 ± 0.8% | not timed | not timed | 17.56 ± 0.6% | | 1.01 | 3.19 | 37.09 |
| 14-quadratic/10x | 1000 | 7.69 ± 1.9% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 7.68 ± 2.2% | | 1.00 | 6.38 | 66.68 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.29 ± 0.9% | not timed | not timed | 0.34 ± 0.3% | 0.54 ± 6.0% | not timed | not timed | 1.29 ± 0.8% | | 1.00 | 3.76 | 2.38 |
| 04-ruff-noqa/compile-real | 1 | 91.22 ± 0.1% | not timed | not timed | 13.93 ± 0.4% | 138.29 ± 3.9% | not timed | not timed | 91.18 ± 0.5% | | 1.00 | 6.55 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 13.95 ± 0.2% | not timed | not timed | 2.53 ± 0.7% | 6.44 ± 2.6% | not timed | not timed | 13.90 ± 0.6% | | 1.00 | 5.51 | 2.17 |
| 07-unicode-character-data/compile | 1 | 55.51 ± 0.2% | not timed | not timed | 26.04 ± 0.2% | 35.67 ± 2.8% | not timed | not timed | 55.02 ± 0.8% | | 1.01 | 2.13 | 1.56 |
| 09-aws-keys/compile-full | 1 | 42.19 ± 0.3% | not timed | not timed | 8.29 ± 0.4% | 23.36 ± 1.3% | not timed | not timed | 41.94 ± 0.2% | | 1.01 | 5.09 | 1.81 |
| 09-aws-keys/compile-quick | 1 | 182.25 ± 0.1% | not timed | not timed | 47.91 ± 0.8% | 132.68 ± 1.9% | not timed | not timed | 180.19 ± 1.0% | | 1.01 | 3.80 | 1.37 |
| 10-bounded-repeat/compile-context | 1 | 13.77 ± 0.2% | not timed | not timed | 11.15 ± 0.1% | 15.92 ± 2.7% | not timed | not timed | 13.85 ± 1.5% | | 0.99 | 1.24 | 0.87 |
| 10-bounded-repeat/compile-capitals | 1 | 82.63 ± 0.5% | not timed | not timed | 7.98 ± 0.3% | 23.99 ± 1.6% | not timed | not timed | 82.42 ± 2.5% | | 1.00 | 10.35 | 3.44 |
| 11-unstructured-to-json/compile | 1 | 86.48 ± 1.4% | not timed | not timed | 41.06 ± 0.4% | 68.19 ± 3.2% | not timed | not timed | 85.43 ± 0.8% | | 1.01 | 2.11 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.4% | not timed | not timed | 0.07 ± 1.7% | 0.09 ± 7.5% | not timed | not timed | 0.34 ± 1.1% | | 1.02 | 5.06 | 3.68 |

