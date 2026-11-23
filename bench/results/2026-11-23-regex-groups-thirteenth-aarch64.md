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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215443992 |
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
| literal: a word | 217 | 15933.52 ± 0.9% | 4992.78 ± 0.3% | 27.98 ± 0.3% | 17752.81 ± 2.9% | 8934.78 ± 7.8% | 17.39 ± 0.1% | 84.04 ± 0.3% | 15972.33 ± 2.8% | 3.19 | 1.00 | 0.90 | 1.78 |
| literal: a word that is not there | 0 | 18394.00 ± 2.3% | 4881.18 ± 0.4% | 27.97 ± 0.3% | 19336.02 ± 2.5% | 28246.28 ± 2.0% | 17.04 ± 0.4% | 79.63 ± 0.5% | 18527.00 ± 1.2% | 3.77 | 0.99 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6084.13 ± 0.2% | 1934.73 ± 0.2% | 14.28 ± 0.1% | 3946.42 ± 0.3% | 21.90 ± 0.2% | 5.43 ± 0.4% | 6.90 ± 0.4% | 6067.99 ± 0.1% | 3.14 | 1.00 | 1.54 | 277.84 |
| literal: a word in any case | 217 | 12551.98 ± 0.5% | 2075.09 ± 0.2% | 21.01 ± 1.8% | 3967.95 ± 0.5% | 36.82 ± 0.4% | refused | differs | 12548.30 ± 0.7% | 6.05 | 1.00 | 3.16 | 340.91 |
| literal: an href attribute | 33 | 13511.41 ± 2.7% | 615.68 ± 0.1% | 27.08 ± 0.1% | 16667.21 ± 1.2% | 2249.64 ± 0.5% | 13.07 ± 0.3% | 73.77 ± 1.1% | 13643.80 ± 2.8% | 21.95 | 0.99 | 0.81 | 6.01 |
| literal: a word, second text | 123 | 16077.46 ± 1.2% | 3351.65 ± 0.0% | 27.77 ± 0.5% | 17497.06 ± 1.0% | 7504.70 ± 3.9% | 20.12 ± 1.3% | 70.35 ± 0.3% | 16195.82 ± 3.7% | 4.80 | 0.99 | 0.92 | 2.14 |
| class: two capitalized words | 1331 | 1064.95 ± 0.4% | 603.91 ± 0.1% | 25.79 ± 0.2% | 585.43 ± 0.1% | 40.41 ± 12.1% | 14.68 ± 0.4% | 67.39 ± 1.6% | 1062.83 ± 0.3% | 1.76 | 1.00 | 1.82 | 26.35 |
| class: a word that ends in ing | 3399 | 580.24 ± 0.2% | 579.00 ± 0.2% | 17.87 ± 0.3% | 547.81 ± 0.2% | 29.56 ± 4.5% | 8.21 ± 0.1% | 18.42 ± 0.2% | 579.51 ± 0.5% | 1.00 | 1.00 | 1.06 | 19.63 |
| class: a word in capitals | 2332 | 1373.72 ± 0.6% | 614.87 ± 0.2% | 27.35 ± 0.2% | 572.67 ± 0.1% | 42.95 ± 12.3% | 17.19 ± 0.3% | 82.23 ± 2.2% | 1372.70 ± 0.8% | 2.23 | 1.00 | 2.40 | 31.98 |
| class: a number | 8288 | 2006.22 ± 0.4% | 834.37 ± 0.1% | 27.49 ± 0.2% | 1723.33 ± 0.2% | 41.53 ± 2.4% | 0.55 ± 0.2% | 57.58 ± 0.9% | 2003.52 ± 0.5% | 2.40 | 1.00 | 1.16 | 48.31 |
| class: two capitalized words, second text | 5359 | 520.22 ± 0.2% | 528.44 ± 0.2% | 23.06 ± 0.3% | 485.03 ± 0.3% | 35.33 ± 9.1% | 17.13 ± 0.2% | 62.77 ± 1.1% | 521.34 ± 0.1% | 0.98 | 1.00 | 1.07 | 14.72 |
| other: a word between two words | 6104 | 741.38 ± 0.0% | 595.12 ± 0.1% | 23.33 ± 0.2% | 734.71 ± 0.1% | 108.77 ± 22.6% | 11.16 ± 0.2% | 68.22 ± 1.1% | 740.64 ± 0.1% | 1.25 | 1.00 | 1.01 | 6.82 |
| other: a number before a unit, second text | 1481 | 5316.83 ± 0.6% | 1108.73 ± 0.3% | 25.89 ± 0.3% | 5619.96 ± 0.8% | 40.51 ± 0.2% | 18.22 ± 0.1% | 65.66 ± 0.4% | 5310.30 ± 0.1% | 4.80 | 1.00 | 0.95 | 131.25 |
| other: a heading's start tag | 110 | 12452.62 ± 1.4% | 751.25 ± 0.2% | 27.12 ± 0.2% | 1708.53 ± 0.5% | 1572.65 ± 5.1% | 16.16 ± 0.7% | 86.06 ± 0.4% | 12666.54 ± 2.2% | 16.58 | 0.98 | 7.29 | 7.92 |
| other: a whole word | 217 | 13859.12 ± 1.2% | 608.45 ± 0.2% | 29.13 ± 0.4% | 14346.40 ± 2.2% | 47.45 ± 0.2% | 13.39 ± 0.1% | 55.10 ± 0.4% | 13900.25 ± 1.3% | 22.78 | 1.00 | 0.97 | 292.07 |
| other: a line's first word, second text | 3716 | 1950.91 ± 0.4% | 594.13 ± 0.1% | 30.89 ± 0.2% | 1729.32 ± 0.5% | 62.33 ± 3.2% | refused | refused | 1945.29 ± 0.8% | 3.28 | 1.00 | 1.13 | 31.30 |
| other: fourteen octets before an x | 87 | 19362.04 ± 3.1% | 220.11 ± 0.6% | 6.30 ± 0.0% | 3947.20 ± 0.5% | 10.60 ± 0.2% | differs | 17.72 ± 0.3% | 19265.44 ± 1.6% | 87.97 | 1.01 | 4.91 | 1826.44 |
| other: a Greek word | 21815 | 502.46 ± 1.0% | 412.52 ± 0.2% | 30.72 ± 0.3% | 289.81 ± 0.2% | 44.44 ± 8.9% | differs | refused | 497.30 ± 1.1% | 1.22 | 1.01 | 1.73 | 11.31 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.86 ± 0.3% | 19.91 ± 0.2% | 0.84 ± 0.2% | 19.83 ± 0.4% | 2.76 ± 1.2% | differs | 4.07 ± 0.1% | 19.89 ± 0.1% | 1.00 | 1.00 | 1.00 | 7.20 |
| a UUID | 32895 | 21.32 ± 0.1% | 21.41 ± 0.1% | 0.64 ± 0.1% | 15.16 ± 0.4% | 3.08 ± 0.9% | 0.73 ± 0.3% | 3.66 ± 0.5% | 21.40 ± 0.1% | 1.00 | 1.00 | 1.41 | 6.93 |
| an IPv4 address | 33176 | 36.76 ± 0.1% | 36.81 ± 0.2% | 2.05 ± 0.1% | 29.49 ± 0.3% | 6.66 ± 0.2% | differs | 4.16 ± 0.1% | 36.83 ± 0.4% | 1.00 | 1.00 | 1.25 | 5.52 |
| a date and time | 32954 | 31.51 ± 0.2% | 31.42 ± 0.3% | 1.41 ± 0.2% | 21.54 ± 0.2% | 7.02 ± 0.1% | 1.26 ± 0.2% | 7.23 ± 0.4% | 31.42 ± 0.2% | 1.00 | 1.00 | 1.46 | 4.49 |
| a field path | 32606 | 23.51 ± 0.2% | 23.57 ± 0.2% | 1.00 ± 0.2% | 23.28 ± 0.3% | 3.48 ± 0.9% | differs | 2.98 ± 0.1% | 23.55 ± 0.1% | 1.00 | 1.00 | 1.01 | 6.76 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.08 ± 0.1% | 11.12 ± 0.2% | 11.07 ± 0.3% | 11.81 ± 0.2% | 4.94 ± 1.3% | 0.94 ± 0.3% | none | 11.12 ± 0.1% | 1.00 | 1.00 | 0.94 | 2.24 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 230.52 ± 0.9% | 231.89 ± 0.3% | 277.35 ± 0.3% | 86.93 ± 0.3% | 218.49 ± 0.9% | 484.45 ± 0.4% | 3789.24 ± 0.3% | 230.80 ± 0.2% | 0.99 | 1.00 | 2.65 | 1.06 |
| a UUID | 62 | 151.88 ± 0.1% | 152.24 ± 0.2% | 171.55 ± 0.2% | 45.84 ± 0.1% | 97.15 ± 1.7% | 184.89 ± 0.8% | 4215.12 ± 0.4% | 151.80 ± 0.2% | 1.00 | 1.00 | 3.31 | 1.56 |
| an IPv4 address | 29 | 417.84 ± 0.4% | 421.95 ± 0.4% | 603.77 ± 0.3% | 77.41 ± 1.0% | 128.25 ± 2.2% | 294.85 ± 0.6% | 7532.70 ± 0.3% | 416.27 ± 0.4% | 0.99 | 1.00 | 5.40 | 3.26 |
| a date and time | 56 | 300.27 ± 0.5% | 303.12 ± 0.1% | 384.48 ± 0.5% | 72.65 ± 0.1% | 131.50 ± 0.9% | 321.31 ± 0.9% | 4877.15 ± 0.5% | 300.74 ± 0.4% | 0.99 | 1.00 | 4.13 | 2.28 |
| a field path | 39 | 226.83 ± 0.3% | 227.25 ± 0.3% | 269.84 ± 0.1% | 80.27 ± 0.4% | 197.43 ± 11.7% | 481.75 ± 0.8% | 4852.19 ± 0.5% | 226.65 ± 0.2% | 1.00 | 1.00 | 2.83 | 1.15 |
| literal: a word | 7 | 627.25 ± 0.6% | 676.47 ± 0.7% | 1245.31 ± 0.1% | 518.71 ± 1.6% | 614.92 ± 1.6% | 929.24 ± 0.7% | 30816.69 ± 0.2% | 627.66 ± 0.6% | 0.93 | 1.00 | 1.21 | 1.02 |
| literal: a word that is not there | 8 | 607.41 ± 0.5% | 657.05 ± 0.9% | 1173.14 ± 0.5% | 474.30 ± 0.3% | 597.29 ± 1.6% | 879.52 ± 0.5% | 29368.20 ± 0.1% | 606.64 ± 0.7% | 0.92 | 1.00 | 1.28 | 1.02 |
| literal: one of four words | 26 | 239.38 ± 0.2% | 398.75 ± 0.6% | 550.62 ± 0.3% | 49.65 ± 0.4% | 234.63 ± 1.7% | 356.48 ± 0.5% | 15935.64 ± 0.1% | 239.46 ± 0.2% | 0.60 | 1.00 | 4.82 | 1.02 |
| literal: a word in any case | 11 | 445.34 ± 0.2% | 474.35 ± 0.3% | 705.42 ± 0.2% | 15.77 ± 0.9% | 638.05 ± 2.4% | refused | 23577.75 ± 0.1% | 445.25 ± 0.2% | 0.94 | 1.00 | 28.24 | 0.70 |
| literal: an href attribute | 12 | 343.11 ± 0.7% | 355.36 ± 0.4% | 474.90 ± 1.0% | 44.86 ± 0.4% | 491.45 ± 3.1% | 771.40 ± 2.9% | 21879.17 ± 0.2% | 343.11 ± 0.4% | 0.97 | 1.00 | 7.65 | 0.70 |
| literal: a word, second text | 10 | 558.23 ± 0.4% | 612.53 ± 0.3% | 1055.14 ± 0.5% | 422.94 ± 0.5% | 526.10 ± 0.6% | 804.02 ± 0.8% | 27271.99 ± 0.1% | 558.92 ± 0.8% | 0.91 | 1.00 | 1.32 | 1.06 |
| class: two capitalized words | 23 | 427.99 ± 0.7% | 462.89 ± 0.4% | 685.41 ± 0.6% | 102.22 ± 0.2% | 491.51 ± 2.0% | 739.35 ± 0.4% | 6474.50 ± 0.2% | 428.28 ± 0.3% | 0.92 | 1.00 | 4.19 | 0.87 |
| class: a word that ends in ing | 9 | 550.05 ± 0.3% | 626.73 ± 0.4% | 1133.55 ± 0.1% | 134.80 ± 0.7% | 748.00 ± 2.6% | 1090.49 ± 1.7% | 15967.17 ± 0.1% | 549.19 ± 0.1% | 0.88 | 1.00 | 4.08 | 0.74 |
| class: a word in capitals | 16 | 481.34 ± 0.4% | 526.29 ± 0.5% | 881.61 ± 0.4% | 136.99 ± 1.0% | 738.07 ± 2.2% | 1007.97 ± 1.0% | 8514.01 ± 0.3% | 482.24 ± 0.3% | 0.91 | 1.00 | 3.51 | 0.65 |
| class: a number | 6 | 606.74 ± 0.2% | 676.85 ± 0.2% | 1351.04 ± 0.1% | 42.10 ± 0.6% | 1383.70 ± 1.0% | 1901.89 ± 0.9% | 22470.98 ± 0.2% | 606.22 ± 0.4% | 0.90 | 1.00 | 14.41 | 0.44 |
| class: two capitalized words, second text | 23 | 427.29 ± 0.9% | 462.59 ± 0.9% | 686.47 ± 1.1% | 104.03 ± 0.2% | 492.18 ± 0.7% | 741.96 ± 0.7% | 6471.63 ± 0.5% | 427.64 ± 0.6% | 0.92 | 1.00 | 4.11 | 0.87 |
| other: a word between two words | 13 | 542.98 ± 0.4% | 560.21 ± 0.2% | 922.80 ± 0.2% | 137.01 ± 0.3% | 494.27 ± 1.4% | 814.85 ± 0.9% | 14835.66 ± 0.2% | 541.98 ± 0.3% | 0.97 | 1.00 | 3.96 | 1.10 |
| other: a number before a unit, second text | 15 | 395.30 ± 0.2% | 437.59 ± 0.3% | 626.32 ± 0.3% | 39.37 ± 0.5% | 621.30 ± 0.4% | 892.11 ± 0.6% | 15107.29 ± 0.1% | 394.99 ± 0.4% | 0.90 | 1.00 | 10.04 | 0.64 |
| other: a heading's start tag | 13 | 354.76 ± 0.4% | 360.35 ± 0.4% | 485.21 ± 0.3% | 43.67 ± 0.2% | 617.56 ± 1.0% | 860.33 ± 0.2% | 18097.05 ± 0.4% | 354.49 ± 0.5% | 0.98 | 1.00 | 8.12 | 0.57 |
| other: a whole word | 11 | 574.87 ± 0.3% | 607.02 ± 0.2% | 1039.70 ± 0.4% | 121.62 ± 0.1% | 554.39 ± 2.5% | 823.67 ± 0.9% | 27089.09 ± 0.4% | 575.58 ± 0.2% | 0.95 | 1.00 | 4.73 | 1.04 |
| other: a line's first word, second text | 17 | 524.50 ± 0.3% | 543.57 ± 0.5% | 893.28 ± 0.4% | 129.79 ± 0.2% | 696.58 ± 1.5% | refused | refused | 521.88 ± 0.6% | 0.96 | 1.01 | 4.04 | 0.75 |
| other: fourteen octets before an x | 16 | 107.87 ± 0.4% | 155.32 ± 0.3% | 180.63 ± 0.1% | 15.15 ± 0.2% | 442.34 ± 2.2% | 424.74 ± 0.9% | 12863.45 ± 0.1% | 107.93 ± 0.4% | 0.69 | 1.00 | 7.12 | 0.24 |
| other: a Greek word | 8 | 423.14 ± 0.5% | 586.40 ± 0.6% | 1044.20 ± 0.6% | 58.60 ± 0.7% | 1373.46 ± 1.1% | 1777.01 ± 0.2% | refused | 423.14 ± 0.3% | 0.72 | 1.00 | 7.22 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12577.57 ± 1.3% | not timed | not timed | 15888.09 ± 1.7% | 1928.02 ± 21.8% | not timed | not timed | 12538.79 ± 1.5% | | 1.00 | 0.79 | 6.52 |
| 01-literal/sherlock-casei-en | 522 | 4955.75 ± 0.6% | not timed | not timed | 3589.46 ± 0.1% | 32.23 ± 2.0% | not timed | not timed | 4944.41 ± 0.4% | | 1.00 | 1.38 | 153.77 |
| 01-literal/sherlock-ru | 724 | 13429.27 ± 0.9% | not timed | not timed | 17175.58 ± 1.0% | 1575.69 ± 7.6% | not timed | not timed | 13385.09 ± 0.4% | | 1.00 | 0.78 | 8.52 |
| 01-literal/sherlock-casei-ru | 746 | 5979.48 ± 0.7% | not timed | not timed | 3325.68 ± 0.2% | 31.18 ± 1.3% | not timed | not timed | 5960.16 ± 0.4% | | 1.00 | 1.80 | 191.77 |
| 01-literal/sherlock-zh | 30 | 16736.12 ± 0.7% | not timed | not timed | 18227.82 ± 1.2% | 2881.39 ± 7.6% | not timed | not timed | 16703.63 ± 1.1% | | 1.00 | 0.92 | 5.81 |
| 02-literal-alternate/sherlock-en | 714 | 5742.83 ± 0.4% | not timed | not timed | 3938.70 ± 0.1% | 16.66 ± 0.1% | not timed | not timed | 5756.29 ± 0.3% | | 1.00 | 1.46 | 344.74 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1805.39 ± 1.5% | not timed | not timed | 696.70 ± 0.2% | 11.04 ± 0.1% | not timed | not timed | 1794.40 ± 0.4% | | 1.01 | 2.59 | 163.47 |
| 02-literal-alternate/sherlock-ru | 899 | 5331.93 ± 0.3% | not timed | not timed | 3258.03 ± 0.2% | 22.64 ± 0.2% | not timed | not timed | 5325.71 ± 0.2% | | 1.00 | 1.64 | 235.54 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1916.33 ± 0.3% | not timed | not timed | 1232.22 ± 0.3% | 9.14 ± 0.1% | not timed | not timed | 1909.83 ± 0.3% | | 1.00 | 1.56 | 209.61 |
| 02-literal-alternate/sherlock-zh | 207 | 7060.28 ± 0.5% | not timed | not timed | 4159.17 ± 0.1% | 31.50 ± 1.2% | not timed | not timed | 7048.88 ± 0.3% | | 1.00 | 1.70 | 224.15 |
| 03-date/ascii | 111817 | 126.45 ± 0.5% | not timed | not timed | 95.51 ± 0.3% | 0.20 ± 3.0% | not timed | not timed | 125.75 ± 0.3% | | 1.01 | 1.32 | 628.85 |
| 04-ruff-noqa/real | 84 | 409.06 ± 0.1% | not timed | not timed | 467.59 ± 0.1% | 19.70 ± 1.2% | not timed | not timed | 407.82 ± 0.1% | | 1.00 | 0.87 | 20.76 |
| 04-ruff-noqa/tweaked | 44 | 549.89 ± 0.5% | not timed | not timed | 470.43 ± 0.3% | 361.28 ± 0.4% | not timed | not timed | 549.25 ± 0.2% | | 1.00 | 1.17 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.35 ± 0.8% | not timed | not timed | 5.24 ± 0.3% | 0.20 ± 5.0% | not timed | not timed | 5.36 ± 2.6% | | 1.00 | 1.02 | 26.70 |
| 06-cloud-flare-redos/original | 107 | 414.61 ± 0.2% | not timed | not timed | 216.91 ± 0.2% | 24.99 ± 0.1% | not timed | not timed | 414.50 ± 0.2% | | 1.00 | 1.91 | 16.59 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.18 ± 0.1% | not timed | not timed | 228.49 ± 0.1% | 26.73 ± 0.3% | not timed | not timed | 410.51 ± 0.1% | | 1.00 | 1.80 | 15.35 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.86 ± 0.1% | not timed | not timed | 255.80 ± 0.9% | 28.82 ± 0.1% | not timed | not timed | 586.94 ± 0.1% | | 1.00 | 2.30 | 20.40 |
| 07-unicode-character-data/parse-line | 558784 | 230.85 ± 0.1% | not timed | not timed | 178.63 ± 0.1% | 41.53 ± 4.3% | not timed | not timed | 230.27 ± 3.1% | | 1.00 | 1.29 | 5.56 |
| 08-words/all-english | 56691 | 116.85 ± 0.5% | not timed | not timed | 83.22 ± 0.1% | 12.27 ± 11.3% | not timed | not timed | 116.50 ± 0.2% | | 1.00 | 1.40 | 9.53 |
| 08-words/long-english | 839 | 620.53 ± 0.3% | not timed | not timed | 595.48 ± 0.2% | 32.22 ± 0.3% | not timed | not timed | 620.77 ± 0.2% | | 1.00 | 1.04 | 19.26 |
| 09-aws-keys/full | 0 | 415.48 ± 0.2% | not timed | not timed | 479.29 ± 0.1% | 64.17 ± 3.4% | not timed | not timed | 414.43 ± 0.2% | | 1.00 | 0.87 | 6.47 |
| 09-aws-keys/quick | 0 | 732.65 ± 0.1% | not timed | not timed | 997.75 ± 0.6% | 418.17 ± 1.4% | not timed | not timed | 729.52 ± 0.0% | | 1.00 | 0.73 | 1.75 |
| 10-bounded-repeat/letters-en | 1833 | 582.00 ± 3.1% | not timed | not timed | 516.87 ± 0.3% | 19.52 ± 0.9% | not timed | not timed | 582.67 ± 2.5% | | 1.00 | 1.13 | 29.82 |
| 10-bounded-repeat/letters-ru | 3475 | 510.10 ± 0.9% | not timed | not timed | 479.91 ± 0.2% | 22.09 ± 18.7% | not timed | not timed | 505.71 ± 0.6% | | 1.01 | 1.06 | 23.09 |
| 10-bounded-repeat/context | 53 | 76.94 ± 0.5% | not timed | not timed | 65.30 ± 0.5% | 19.81 ± 0.3% | not timed | not timed | 76.94 ± 0.3% | | 1.00 | 1.18 | 3.88 |
| 10-bounded-repeat/capitals | 11 | 631.75 ± 8.2% | not timed | not timed | 616.43 ± 0.1% | 36.56 ± 0.2% | not timed | not timed | 630.24 ± 8.4% | | 1.00 | 1.02 | 17.28 |
| 11-unstructured-to-json/extract | 600 | 79.54 ± 0.2% | not timed | not timed | 76.70 ± 0.1% | 49.25 ± 1.5% | not timed | not timed | 81.08 ± 0.3% | | 0.98 | 1.04 | 1.62 |
| 12-dictionary/single | 1 | 560.69 ± 0.3% | not timed | not timed | 560.34 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 560.14 ± 0.1% | | 1.00 | 1.00 | 1371.84 |
| 14-quadratic/1x | 100 | 21.52 ± 2.0% | not timed | not timed | 10.01 ± 0.2% | 0.97 ± 4.8% | not timed | not timed | 21.34 ± 1.7% | | 1.01 | 2.15 | 22.21 |
| 14-quadratic/2x | 200 | 17.69 ± 1.7% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 1.8% | not timed | not timed | 17.61 ± 0.9% | | 1.00 | 3.19 | 33.39 |
| 14-quadratic/10x | 1000 | 7.70 ± 2.9% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 7.68 ± 3.2% | | 1.00 | 6.35 | 66.75 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.29 ± 0.2% | not timed | not timed | 0.34 ± 0.3% | 0.54 ± 5.2% | not timed | not timed | 1.28 ± 0.6% | | 1.01 | 3.81 | 2.40 |
| 04-ruff-noqa/compile-real | 1 | 91.23 ± 0.3% | not timed | not timed | 13.86 ± 0.2% | 133.73 ± 3.0% | not timed | not timed | 91.12 ± 0.9% | | 1.00 | 6.58 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 13.95 ± 0.3% | not timed | not timed | 2.51 ± 0.3% | 6.23 ± 3.5% | not timed | not timed | 13.78 ± 1.7% | | 1.01 | 5.55 | 2.24 |
| 07-unicode-character-data/compile | 1 | 55.50 ± 0.1% | not timed | not timed | 26.20 ± 0.2% | 35.16 ± 1.2% | not timed | not timed | 55.21 ± 0.2% | | 1.01 | 2.12 | 1.58 |
| 09-aws-keys/compile-full | 1 | 42.22 ± 0.2% | not timed | not timed | 8.34 ± 0.1% | 23.07 ± 2.5% | not timed | not timed | 41.83 ± 0.8% | | 1.01 | 5.06 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 181.70 ± 0.3% | not timed | not timed | 48.53 ± 0.2% | 130.52 ± 2.0% | not timed | not timed | 180.35 ± 1.1% | | 1.01 | 3.74 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 13.90 ± 0.8% | not timed | not timed | 11.18 ± 0.6% | 15.44 ± 2.0% | not timed | not timed | 13.79 ± 1.6% | | 1.01 | 1.24 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 82.48 ± 0.2% | not timed | not timed | 8.02 ± 0.3% | 23.08 ± 2.9% | not timed | not timed | 82.45 ± 2.7% | | 1.00 | 10.29 | 3.57 |
| 11-unstructured-to-json/compile | 1 | 86.37 ± 0.4% | not timed | not timed | 40.62 ± 0.2% | 67.15 ± 0.6% | not timed | not timed | 85.64 ± 0.8% | | 1.01 | 2.13 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 1.3% | 0.10 ± 7.8% | not timed | not timed | 0.34 ± 2.7% | | 1.01 | 5.19 | 3.58 |

