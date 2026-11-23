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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215344370 |
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
| literal: a word | 217 | 16104.21 ± 0.5% | 4992.74 ± 0.2% | 27.97 ± 0.2% | 18275.66 ± 1.0% | 9120.96 ± 9.2% | 17.37 ± 0.7% | 84.08 ± 0.2% | 16106.61 ± 0.5% | 3.23 | 1.00 | 0.88 | 1.77 |
| literal: a word that is not there | 0 | 18669.16 ± 8.5% | 4880.03 ± 1.2% | 28.02 ± 0.3% | 19762.93 ± 2.7% | 28638.08 ± 2.5% | 17.16 ± 0.3% | 79.58 ± 0.3% | 18724.40 ± 7.5% | 3.83 | 1.00 | 0.94 | 0.65 |
| literal: one of four words | 661 | 6093.51 ± 0.6% | 1929.09 ± 0.1% | 14.27 ± 0.4% | 3944.43 ± 0.5% | 21.86 ± 0.1% | 5.43 ± 0.3% | 6.88 ± 0.5% | 6075.48 ± 0.2% | 3.16 | 1.00 | 1.54 | 278.70 |
| literal: a word in any case | 217 | 12605.53 ± 0.3% | 2072.88 ± 0.2% | 21.01 ± 0.5% | 3969.66 ± 0.2% | 36.86 ± 0.8% | refused | differs | 12594.46 ± 0.7% | 6.08 | 1.00 | 3.18 | 341.95 |
| literal: an href attribute | 33 | 13753.04 ± 1.0% | 615.96 ± 0.1% | 27.01 ± 0.3% | 16945.85 ± 0.9% | 2250.74 ± 0.4% | 13.12 ± 0.1% | 73.83 ± 0.5% | 13708.95 ± 1.0% | 22.33 | 1.00 | 0.81 | 6.11 |
| literal: a word, second text | 123 | 16614.00 ± 1.0% | 3354.43 ± 0.2% | 27.71 ± 0.2% | 18523.56 ± 1.2% | 7578.93 ± 6.2% | 20.14 ± 0.3% | 70.34 ± 1.0% | 16605.11 ± 1.1% | 4.95 | 1.00 | 0.90 | 2.19 |
| class: two capitalized words | 1331 | 1063.83 ± 0.4% | 603.69 ± 0.2% | 25.80 ± 0.2% | 584.97 ± 0.3% | 40.50 ± 7.8% | 14.76 ± 0.2% | 67.48 ± 0.2% | 1062.83 ± 0.2% | 1.76 | 1.00 | 1.82 | 26.26 |
| class: a word that ends in ing | 3399 | 580.08 ± 0.1% | 578.87 ± 0.2% | 17.87 ± 0.3% | 547.71 ± 0.1% | 29.58 ± 6.6% | 8.20 ± 0.3% | 18.42 ± 1.6% | 579.15 ± 0.1% | 1.00 | 1.00 | 1.06 | 19.61 |
| class: a word in capitals | 2332 | 1373.53 ± 0.4% | 614.56 ± 0.1% | 27.30 ± 0.3% | 572.29 ± 0.1% | 43.08 ± 6.2% | 17.19 ± 0.3% | 82.53 ± 0.2% | 1368.67 ± 0.5% | 2.23 | 1.00 | 2.40 | 31.88 |
| class: a number | 8288 | 2006.16 ± 0.6% | 833.51 ± 0.1% | 27.54 ± 0.2% | 1721.65 ± 0.7% | 39.20 ± 14.0% | 0.53 ± 0.8% | 57.58 ± 2.1% | 1997.15 ± 0.5% | 2.41 | 1.00 | 1.17 | 51.18 |
| class: two capitalized words, second text | 5359 | 521.53 ± 0.5% | 527.96 ± 0.3% | 23.06 ± 0.1% | 484.65 ± 0.3% | 33.89 ± 10.1% | 17.11 ± 0.3% | 62.83 ± 0.4% | 521.04 ± 0.6% | 0.99 | 1.00 | 1.08 | 15.39 |
| other: a word between two words | 6104 | 740.89 ± 0.2% | 598.00 ± 0.1% | 23.31 ± 0.2% | 733.41 ± 0.4% | 108.98 ± 11.8% | 11.20 ± 0.1% | 68.20 ± 2.0% | 739.84 ± 0.1% | 1.24 | 1.00 | 1.01 | 6.80 |
| other: a number before a unit, second text | 1481 | 5326.17 ± 0.7% | 1109.31 ± 0.3% | 25.86 ± 0.2% | 5658.91 ± 0.3% | 40.64 ± 8.9% | 18.20 ± 0.2% | 65.88 ± 0.5% | 5329.24 ± 1.0% | 4.80 | 1.00 | 0.94 | 131.05 |
| other: a heading's start tag | 110 | 12546.83 ± 0.6% | 750.37 ± 0.1% | 27.09 ± 0.1% | 1707.59 ± 0.5% | 1574.46 ± 6.4% | 16.00 ± 7.2% | 86.03 ± 0.4% | 12577.68 ± 0.6% | 16.72 | 1.00 | 7.35 | 7.97 |
| other: a whole word | 217 | 14026.82 ± 0.5% | 608.13 ± 0.5% | 29.18 ± 0.3% | 14467.15 ± 1.6% | 47.59 ± 0.4% | 13.18 ± 0.2% | 55.06 ± 1.2% | 14040.79 ± 0.7% | 23.07 | 1.00 | 0.97 | 294.75 |
| other: a line's first word, second text | 3716 | 1945.15 ± 0.8% | 594.44 ± 0.2% | 30.90 ± 0.2% | 1727.69 ± 0.4% | 61.60 ± 9.0% | refused | refused | 1937.42 ± 0.6% | 3.27 | 1.00 | 1.13 | 31.57 |
| other: fourteen octets before an x | 87 | 19513.08 ± 1.2% | 248.74 ± 0.6% | 6.29 ± 0.1% | 4004.32 ± 0.6% | 10.61 ± 0.2% | differs | 17.76 ± 0.1% | 19478.07 ± 1.1% | 78.45 | 1.00 | 4.87 | 1839.11 |
| other: a Greek word | 21815 | 501.08 ± 0.6% | 412.80 ± 0.3% | 30.71 ± 0.1% | 289.51 ± 0.0% | 44.48 ± 8.6% | differs | refused | 497.56 ± 0.3% | 1.21 | 1.01 | 1.73 | 11.26 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.89 ± 0.5% | 19.91 ± 0.4% | 0.84 ± 0.2% | 19.87 ± 0.4% | 2.76 ± 0.4% | differs | 4.07 ± 0.2% | 19.88 ± 0.4% | 1.00 | 1.00 | 1.00 | 7.21 |
| a UUID | 32895 | 21.33 ± 0.7% | 21.38 ± 0.5% | 0.64 ± 0.1% | 15.13 ± 0.6% | 3.09 ± 0.3% | 0.73 ± 0.3% | 3.65 ± 1.1% | 21.41 ± 0.7% | 1.00 | 1.00 | 1.41 | 6.91 |
| an IPv4 address | 33176 | 36.80 ± 0.7% | 36.83 ± 0.3% | 2.05 ± 0.2% | 29.42 ± 0.1% | 6.64 ± 0.8% | differs | 4.16 ± 0.1% | 36.89 ± 0.5% | 1.00 | 1.00 | 1.25 | 5.54 |
| a date and time | 32954 | 31.55 ± 0.2% | 31.42 ± 0.2% | 1.41 ± 0.8% | 21.51 ± 0.4% | 7.03 ± 0.1% | 1.26 ± 0.2% | 7.21 ± 0.3% | 31.40 ± 0.2% | 1.00 | 1.00 | 1.47 | 4.49 |
| a field path | 32606 | 23.50 ± 0.1% | 23.57 ± 0.1% | 1.00 ± 0.4% | 23.38 ± 0.4% | 3.49 ± 0.4% | differs | 2.96 ± 0.2% | 23.56 ± 0.1% | 1.00 | 1.00 | 1.01 | 6.73 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.05 ± 0.4% | 11.10 ± 0.3% | 11.06 ± 0.5% | 11.80 ± 0.3% | 4.88 ± 1.0% | 0.94 ± 0.7% | none | 11.11 ± 0.5% | 1.00 | 0.99 | 0.94 | 2.26 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 229.90 ± 0.3% | 230.88 ± 0.3% | 275.85 ± 0.4% | 87.23 ± 0.3% | 212.75 ± 3.3% | 484.55 ± 0.4% | 3795.71 ± 0.5% | 229.81 ± 0.3% | 1.00 | 1.00 | 2.64 | 1.08 |
| a UUID | 62 | 151.09 ± 0.2% | 151.54 ± 0.2% | 170.49 ± 0.2% | 45.81 ± 0.1% | 95.40 ± 2.6% | 183.98 ± 0.9% | 4235.14 ± 0.3% | 151.13 ± 0.1% | 1.00 | 1.00 | 3.30 | 1.58 |
| an IPv4 address | 29 | 417.07 ± 0.2% | 421.01 ± 0.5% | 603.09 ± 0.5% | 76.84 ± 1.0% | 126.86 ± 2.4% | 294.84 ± 0.7% | 7578.35 ± 0.5% | 417.04 ± 0.2% | 0.99 | 1.00 | 5.43 | 3.29 |
| a date and time | 56 | 300.78 ± 0.1% | 302.88 ± 0.1% | 384.06 ± 0.2% | 72.57 ± 0.2% | 129.77 ± 3.2% | 320.41 ± 0.8% | 4909.48 ± 0.4% | 300.65 ± 0.2% | 0.99 | 1.00 | 4.14 | 2.32 |
| a field path | 39 | 225.40 ± 0.5% | 226.09 ± 0.6% | 267.84 ± 0.5% | 80.07 ± 0.5% | 196.14 ± 2.4% | 480.60 ± 1.1% | 4877.26 ± 0.2% | 225.13 ± 0.5% | 1.00 | 1.00 | 2.81 | 1.15 |
| literal: a word | 7 | 626.43 ± 0.6% | 675.54 ± 0.2% | 1240.30 ± 0.3% | 510.91 ± 2.0% | 605.72 ± 3.4% | 924.40 ± 0.8% | 30867.83 ± 0.4% | 626.01 ± 0.4% | 0.93 | 1.00 | 1.23 | 1.03 |
| literal: a word that is not there | 8 | 605.02 ± 0.4% | 653.83 ± 0.6% | 1168.15 ± 0.2% | 467.75 ± 0.3% | 580.80 ± 3.0% | 876.24 ± 0.8% | 29435.46 ± 0.2% | 605.54 ± 0.2% | 0.93 | 1.00 | 1.29 | 1.04 |
| literal: one of four words | 26 | 239.27 ± 0.4% | 398.70 ± 0.2% | 549.68 ± 0.3% | 49.60 ± 0.2% | 230.83 ± 2.6% | 355.14 ± 0.5% | 16035.65 ± 0.2% | 239.25 ± 0.3% | 0.60 | 1.00 | 4.82 | 1.04 |
| literal: a word in any case | 11 | 445.28 ± 0.1% | 474.72 ± 0.4% | 705.68 ± 0.2% | 15.75 ± 0.9% | 621.70 ± 2.8% | refused | 23725.69 ± 0.2% | 445.33 ± 0.1% | 0.94 | 1.00 | 28.26 | 0.72 |
| literal: an href attribute | 12 | 342.60 ± 0.5% | 355.42 ± 0.6% | 474.03 ± 0.6% | 45.16 ± 0.5% | 483.81 ± 2.9% | 783.20 ± 2.2% | 21976.58 ± 0.2% | 342.04 ± 0.3% | 0.96 | 1.00 | 7.59 | 0.71 |
| literal: a word, second text | 10 | 558.15 ± 0.7% | 611.99 ± 0.7% | 1052.20 ± 0.6% | 416.72 ± 0.1% | 515.91 ± 2.7% | 802.78 ± 0.5% | 27326.49 ± 0.1% | 558.37 ± 0.4% | 0.91 | 1.00 | 1.34 | 1.08 |
| class: two capitalized words | 23 | 427.60 ± 0.6% | 461.80 ± 0.7% | 684.93 ± 1.0% | 101.79 ± 0.5% | 480.34 ± 2.7% | 740.29 ± 0.5% | 6473.35 ± 0.5% | 427.39 ± 0.5% | 0.93 | 1.00 | 4.20 | 0.89 |
| class: a word that ends in ing | 9 | 549.08 ± 0.4% | 626.10 ± 0.3% | 1132.27 ± 0.4% | 133.93 ± 1.2% | 735.01 ± 1.0% | 1097.06 ± 0.3% | 16049.23 ± 0.2% | 549.82 ± 0.3% | 0.88 | 1.00 | 4.10 | 0.75 |
| class: a word in capitals | 16 | 481.47 ± 0.8% | 525.33 ± 1.0% | 880.13 ± 1.4% | 137.46 ± 1.0% | 731.05 ± 1.9% | 1034.78 ± 1.0% | 8524.71 ± 0.5% | 480.22 ± 0.7% | 0.92 | 1.00 | 3.50 | 0.66 |
| class: a number | 6 | 607.45 ± 0.5% | 676.87 ± 0.4% | 1350.90 ± 0.1% | 41.85 ± 1.2% | 1379.32 ± 3.1% | 1899.19 ± 0.9% | 22803.94 ± 0.2% | 606.91 ± 0.4% | 0.90 | 1.00 | 14.52 | 0.44 |
| class: two capitalized words, second text | 23 | 427.34 ± 0.3% | 461.42 ± 0.4% | 684.84 ± 0.2% | 103.88 ± 0.1% | 484.00 ± 2.6% | 762.22 ± 0.4% | 6490.98 ± 0.2% | 427.85 ± 0.5% | 0.93 | 1.00 | 4.11 | 0.88 |
| other: a word between two words | 13 | 541.15 ± 0.3% | 557.04 ± 0.8% | 921.05 ± 0.6% | 135.28 ± 0.4% | 483.94 ± 0.9% | 816.08 ± 0.2% | 14856.60 ± 0.6% | 541.65 ± 0.3% | 0.97 | 1.00 | 4.00 | 1.12 |
| other: a number before a unit, second text | 15 | 394.41 ± 0.7% | 436.31 ± 0.3% | 622.64 ± 0.3% | 39.56 ± 0.8% | 611.65 ± 2.1% | 884.45 ± 0.6% | 15226.32 ± 0.4% | 394.22 ± 0.4% | 0.90 | 1.00 | 9.97 | 0.64 |
| other: a heading's start tag | 13 | 352.46 ± 0.3% | 358.37 ± 0.4% | 481.83 ± 0.3% | 43.87 ± 1.2% | 609.15 ± 13.6% | 874.59 ± 0.5% | 18270.04 ± 0.4% | 352.82 ± 0.4% | 0.98 | 1.00 | 8.03 | 0.58 |
| other: a whole word | 11 | 575.24 ± 0.3% | 607.43 ± 0.3% | 1036.27 ± 0.3% | 121.37 ± 0.6% | 538.54 ± 4.9% | 825.45 ± 1.4% | 27157.00 ± 0.4% | 575.20 ± 0.6% | 0.95 | 1.00 | 4.74 | 1.07 |
| other: a line's first word, second text | 17 | 524.49 ± 0.4% | 542.89 ± 0.4% | 892.80 ± 0.3% | 128.60 ± 0.2% | 685.11 ± 2.0% | refused | refused | 521.91 ± 0.5% | 0.97 | 1.00 | 4.08 | 0.77 |
| other: fourteen octets before an x | 16 | 107.63 ± 0.5% | 155.23 ± 0.6% | 180.38 ± 0.7% | 14.95 ± 0.3% | 437.77 ± 2.8% | 413.46 ± 1.7% | 12953.41 ± 0.5% | 107.74 ± 0.6% | 0.69 | 1.00 | 7.20 | 0.25 |
| other: a Greek word | 8 | 422.32 ± 0.1% | 585.06 ± 0.2% | 1040.64 ± 0.1% | 59.00 ± 0.4% | 1360.10 ± 1.1% | 1763.50 ± 0.6% | refused | 422.06 ± 0.5% | 0.72 | 1.00 | 7.16 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12763.97 ± 0.8% | not timed | not timed | 16353.64 ± 1.4% | 2093.04 ± 17.7% | not timed | not timed | 12741.32 ± 1.1% | | 1.00 | 0.78 | 6.10 |
| 01-literal/sherlock-casei-en | 522 | 4964.07 ± 0.8% | not timed | not timed | 3590.04 ± 0.1% | 32.17 ± 1.3% | not timed | not timed | 4952.68 ± 0.8% | | 1.00 | 1.38 | 154.29 |
| 01-literal/sherlock-ru | 724 | 13511.10 ± 0.5% | not timed | not timed | 17248.72 ± 0.3% | 1377.27 ± 11.6% | not timed | not timed | 13470.56 ± 0.4% | | 1.00 | 0.78 | 9.81 |
| 01-literal/sherlock-casei-ru | 746 | 5967.72 ± 0.2% | not timed | not timed | 3332.57 ± 0.1% | 31.10 ± 1.1% | not timed | not timed | 5964.54 ± 0.3% | | 1.00 | 1.79 | 191.87 |
| 01-literal/sherlock-zh | 30 | 17077.21 ± 0.5% | not timed | not timed | 18595.18 ± 0.8% | 2880.82 ± 6.1% | not timed | not timed | 17038.93 ± 0.2% | | 1.00 | 0.92 | 5.93 |
| 02-literal-alternate/sherlock-en | 714 | 5760.82 ± 0.3% | not timed | not timed | 3941.03 ± 0.2% | 16.65 ± 0.1% | not timed | not timed | 5757.07 ± 0.2% | | 1.00 | 1.46 | 346.03 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1803.49 ± 0.9% | not timed | not timed | 696.74 ± 0.2% | 11.04 ± 0.2% | not timed | not timed | 1792.73 ± 0.5% | | 1.01 | 2.59 | 163.39 |
| 02-literal-alternate/sherlock-ru | 899 | 5326.22 ± 0.4% | not timed | not timed | 3260.04 ± 0.1% | 22.60 ± 0.1% | not timed | not timed | 5326.76 ± 0.1% | | 1.00 | 1.63 | 235.64 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1917.99 ± 0.5% | not timed | not timed | 1232.87 ± 0.1% | 9.14 ± 0.1% | not timed | not timed | 1912.40 ± 0.2% | | 1.00 | 1.56 | 209.87 |
| 02-literal-alternate/sherlock-zh | 207 | 7028.56 ± 0.9% | not timed | not timed | 4165.14 ± 0.2% | 31.51 ± 0.1% | not timed | not timed | 7046.37 ± 0.3% | | 1.00 | 1.69 | 223.09 |
| 03-date/ascii | 111817 | 126.53 ± 0.7% | not timed | not timed | 95.87 ± 0.1% | 0.20 ± 1.7% | not timed | not timed | 125.29 ± 0.2% | | 1.01 | 1.32 | 633.24 |
| 04-ruff-noqa/real | 84 | 409.11 ± 0.1% | not timed | not timed | 468.41 ± 0.2% | 19.68 ± 1.5% | not timed | not timed | 407.76 ± 0.0% | | 1.00 | 0.87 | 20.79 |
| 04-ruff-noqa/tweaked | 44 | 550.12 ± 0.2% | not timed | not timed | 465.24 ± 0.1% | 361.52 ± 0.5% | not timed | not timed | 549.46 ± 0.2% | | 1.00 | 1.18 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.34 ± 0.1% | not timed | not timed | 5.25 ± 0.2% | 0.21 ± 2.6% | not timed | not timed | 5.36 ± 1.8% | | 1.00 | 1.02 | 25.87 |
| 06-cloud-flare-redos/original | 107 | 414.96 ± 0.2% | not timed | not timed | 216.16 ± 0.2% | 24.94 ± 0.1% | not timed | not timed | 414.06 ± 0.3% | | 1.00 | 1.92 | 16.64 |
| 06-cloud-flare-redos/simplified-short | 102 | 409.72 ± 0.3% | not timed | not timed | 227.93 ± 0.2% | 26.72 ± 0.4% | not timed | not timed | 410.67 ± 0.3% | | 1.00 | 1.80 | 15.34 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.78 ± 0.1% | not timed | not timed | 255.90 ± 0.1% | 28.83 ± 0.1% | not timed | not timed | 586.73 ± 0.1% | | 1.00 | 2.30 | 20.39 |
| 07-unicode-character-data/parse-line | 558784 | 230.78 ± 0.2% | not timed | not timed | 178.69 ± 0.3% | 40.97 ± 4.7% | not timed | not timed | 231.11 ± 3.0% | | 1.00 | 1.29 | 5.63 |
| 08-words/all-english | 56691 | 116.80 ± 0.3% | not timed | not timed | 82.96 ± 0.2% | 12.48 ± 12.9% | not timed | not timed | 115.93 ± 0.6% | | 1.01 | 1.41 | 9.36 |
| 08-words/long-english | 839 | 620.36 ± 0.6% | not timed | not timed | 597.58 ± 0.1% | 32.32 ± 0.3% | not timed | not timed | 620.68 ± 0.2% | | 1.00 | 1.04 | 19.19 |
| 09-aws-keys/full | 0 | 415.62 ± 0.0% | not timed | not timed | 475.06 ± 0.1% | 64.50 ± 0.1% | not timed | not timed | 414.61 ± 0.1% | | 1.00 | 0.87 | 6.44 |
| 09-aws-keys/quick | 0 | 731.60 ± 0.1% | not timed | not timed | 994.93 ± 0.3% | 418.86 ± 1.3% | not timed | not timed | 729.47 ± 0.1% | | 1.00 | 0.74 | 1.75 |
| 10-bounded-repeat/letters-en | 1833 | 587.30 ± 2.3% | not timed | not timed | 516.51 ± 0.3% | 19.55 ± 0.3% | not timed | not timed | 583.37 ± 2.3% | | 1.01 | 1.14 | 30.05 |
| 10-bounded-repeat/letters-ru | 3475 | 510.94 ± 1.4% | not timed | not timed | 479.56 ± 0.0% | 21.83 ± 9.3% | not timed | not timed | 506.84 ± 1.1% | | 1.01 | 1.07 | 23.40 |
| 10-bounded-repeat/context | 53 | 77.05 ± 0.7% | not timed | not timed | 65.51 ± 0.3% | 19.76 ± 0.4% | not timed | not timed | 77.20 ± 0.5% | | 1.00 | 1.18 | 3.90 |
| 10-bounded-repeat/capitals | 11 | 631.06 ± 8.5% | not timed | not timed | 618.24 ± 0.1% | 36.44 ± 1.2% | not timed | not timed | 630.23 ± 8.5% | | 1.00 | 1.02 | 17.32 |
| 11-unstructured-to-json/extract | 600 | 79.46 ± 0.2% | not timed | not timed | 76.80 ± 0.2% | 48.99 ± 1.0% | not timed | not timed | 81.28 ± 1.1% | | 0.98 | 1.03 | 1.62 |
| 12-dictionary/single | 1 | 562.16 ± 0.6% | not timed | not timed | 559.18 ± 0.1% | 0.40 ± 0.3% | not timed | not timed | 561.49 ± 1.0% | | 1.00 | 1.01 | 1410.10 |
| 14-quadratic/1x | 100 | 21.49 ± 1.3% | not timed | not timed | 10.02 ± 0.2% | 0.96 ± 2.6% | not timed | not timed | 21.43 ± 1.4% | | 1.00 | 2.15 | 22.49 |
| 14-quadratic/2x | 200 | 17.67 ± 2.8% | not timed | not timed | 5.53 ± 0.1% | 0.52 ± 2.0% | not timed | not timed | 17.60 ± 3.0% | | 1.00 | 3.19 | 33.66 |
| 14-quadratic/10x | 1000 | 7.71 ± 2.0% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 2.0% | not timed | not timed | 7.68 ± 0.6% | | 1.00 | 6.35 | 66.91 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.29 ± 0.2% | not timed | not timed | 0.35 ± 0.8% | 0.53 ± 3.1% | not timed | not timed | 1.29 ± 1.1% | | 1.00 | 3.75 | 2.42 |
| 04-ruff-noqa/compile-real | 1 | 91.48 ± 0.7% | not timed | not timed | 13.70 ± 0.1% | 132.82 ± 3.1% | not timed | not timed | 90.53 ± 1.3% | | 1.01 | 6.68 | 0.69 |
| 05-lexer-veryl/compile-single | 1 | 13.94 ± 0.4% | not timed | not timed | 2.53 ± 1.4% | 6.17 ± 14.6% | not timed | not timed | 13.90 ± 1.8% | | 1.00 | 5.50 | 2.26 |
| 07-unicode-character-data/compile | 1 | 55.55 ± 0.2% | not timed | not timed | 25.72 ± 0.5% | 33.85 ± 19.8% | not timed | not timed | 54.85 ± 1.4% | | 1.01 | 2.16 | 1.64 |
| 09-aws-keys/compile-full | 1 | 42.25 ± 0.2% | not timed | not timed | 8.27 ± 0.2% | 23.04 ± 4.7% | not timed | not timed | 41.93 ± 1.2% | | 1.01 | 5.11 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 182.26 ± 0.2% | not timed | not timed | 46.92 ± 0.2% | 128.88 ± 2.5% | not timed | not timed | 181.11 ± 0.9% | | 1.01 | 3.88 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 13.87 ± 0.5% | not timed | not timed | 11.11 ± 0.2% | 15.21 ± 2.7% | not timed | not timed | 13.83 ± 3.7% | | 1.00 | 1.25 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 82.47 ± 0.2% | not timed | not timed | 7.99 ± 0.1% | 23.30 ± 2.2% | not timed | not timed | 82.45 ± 0.9% | | 1.00 | 10.32 | 3.54 |
| 11-unstructured-to-json/compile | 1 | 86.58 ± 0.2% | not timed | not timed | 41.22 ± 0.4% | 63.94 ± 4.7% | not timed | not timed | 85.71 ± 1.0% | | 1.01 | 2.10 | 1.35 |
| 12-dictionary/compile-single | 1 | 0.34 ± 0.1% | not timed | not timed | 0.07 ± 32.7% | 0.09 ± 13.2% | not timed | not timed | 0.34 ± 2.6% | | 1.02 | 5.19 | 3.70 |

