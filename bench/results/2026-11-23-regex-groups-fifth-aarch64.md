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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215353115 |
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
| literal: a word | 217 | 16079.11 ± 1.1% | 4993.23 ± 0.2% | 27.92 ± 0.3% | 18250.88 ± 2.0% | 9077.60 ± 9.4% | 17.28 ± 0.3% | 83.84 ± 0.1% | 16094.83 ± 1.1% | 3.22 | 1.00 | 0.88 | 1.77 |
| literal: a word that is not there | 0 | 18761.53 ± 0.7% | 4870.92 ± 0.3% | 28.02 ± 0.2% | 19852.21 ± 1.8% | 29165.88 ± 1.0% | 17.00 ± 0.2% | 79.60 ± 0.3% | 18840.22 ± 0.8% | 3.85 | 1.00 | 0.95 | 0.64 |
| literal: one of four words | 661 | 6085.38 ± 0.2% | 1935.14 ± 0.2% | 14.28 ± 0.1% | 3944.07 ± 0.3% | 21.92 ± 0.1% | 5.42 ± 0.4% | 6.88 ± 1.6% | 6070.14 ± 0.7% | 3.14 | 1.00 | 1.54 | 277.68 |
| literal: a word in any case | 217 | 12611.97 ± 0.7% | 2072.10 ± 0.3% | 21.01 ± 1.9% | 3970.28 ± 0.1% | 36.41 ± 1.4% | refused | differs | 12587.61 ± 0.2% | 6.09 | 1.00 | 3.18 | 346.39 |
| literal: an href attribute | 33 | 13860.60 ± 1.0% | 616.15 ± 0.1% | 27.05 ± 0.3% | 17155.33 ± 0.7% | 2254.67 ± 0.3% | 13.03 ± 0.2% | 73.90 ± 0.4% | 13835.66 ± 1.0% | 22.50 | 1.00 | 0.81 | 6.15 |
| literal: a word, second text | 123 | 16532.78 ± 1.0% | 3351.20 ± 0.5% | 27.75 ± 0.3% | 18295.68 ± 0.9% | 7789.46 ± 6.1% | 19.79 ± 0.4% | 70.24 ± 0.3% | 16526.92 ± 1.2% | 4.93 | 1.00 | 0.90 | 2.12 |
| class: two capitalized words | 1331 | 1063.79 ± 0.2% | 603.64 ± 0.1% | 25.83 ± 0.2% | 585.29 ± 0.1% | 40.47 ± 2.4% | 14.64 ± 0.6% | 67.43 ± 1.0% | 1063.54 ± 0.3% | 1.76 | 1.00 | 1.82 | 26.28 |
| class: a word that ends in ing | 3399 | 580.15 ± 0.1% | 577.42 ± 0.2% | 17.86 ± 0.2% | 547.64 ± 0.1% | 29.59 ± 9.5% | 8.19 ± 0.3% | 18.43 ± 0.2% | 579.71 ± 0.2% | 1.00 | 1.00 | 1.06 | 19.61 |
| class: a word in capitals | 2332 | 1374.84 ± 0.5% | 615.01 ± 0.2% | 27.33 ± 0.2% | 572.54 ± 0.2% | 43.20 ± 8.1% | 17.12 ± 0.3% | 82.63 ± 0.4% | 1375.14 ± 0.2% | 2.24 | 1.00 | 2.40 | 31.83 |
| class: a number | 8288 | 2005.99 ± 0.2% | 834.07 ± 0.8% | 27.54 ± 0.2% | 1722.78 ± 0.3% | 41.66 ± 2.6% | 0.55 ± 0.2% | 57.61 ± 0.7% | 1999.24 ± 1.2% | 2.41 | 1.00 | 1.16 | 48.15 |
| class: two capitalized words, second text | 5359 | 521.60 ± 0.2% | 528.32 ± 0.1% | 23.07 ± 0.4% | 484.84 ± 0.1% | 35.26 ± 8.3% | 16.91 ± 0.1% | 62.68 ± 1.3% | 520.77 ± 0.1% | 0.99 | 1.00 | 1.08 | 14.79 |
| other: a word between two words | 6104 | 741.13 ± 0.2% | 598.01 ± 0.2% | 23.33 ± 0.1% | 734.10 ± 0.1% | 109.26 ± 20.3% | 11.14 ± 0.3% | 68.34 ± 1.0% | 740.13 ± 0.2% | 1.24 | 1.00 | 1.01 | 6.78 |
| other: a number before a unit, second text | 1481 | 5329.86 ± 0.4% | 1108.18 ± 0.1% | 25.87 ± 0.1% | 5668.74 ± 0.0% | 40.64 ± 0.2% | 17.94 ± 0.1% | 65.91 ± 0.1% | 5322.32 ± 0.3% | 4.81 | 1.00 | 0.94 | 131.16 |
| other: a heading's start tag | 110 | 12607.49 ± 1.0% | 750.94 ± 0.1% | 27.11 ± 0.2% | 1710.92 ± 0.6% | 1572.39 ± 4.1% | 16.10 ± 0.7% | 86.09 ± 0.3% | 12611.05 ± 1.0% | 16.79 | 1.00 | 7.37 | 8.02 |
| other: a whole word | 217 | 14117.43 ± 0.4% | 608.28 ± 0.4% | 29.14 ± 0.3% | 14554.18 ± 0.9% | 47.67 ± 0.2% | 13.32 ± 0.1% | 55.06 ± 1.0% | 14090.15 ± 0.2% | 23.21 | 1.00 | 0.97 | 296.17 |
| other: a line's first word, second text | 3716 | 1941.53 ± 0.5% | 594.33 ± 0.1% | 30.91 ± 0.2% | 1723.53 ± 0.7% | 62.32 ± 8.1% | refused | refused | 1937.39 ± 1.0% | 3.27 | 1.00 | 1.13 | 31.16 |
| other: fourteen octets before an x | 87 | 19932.62 ± 1.0% | 255.58 ± 0.7% | 6.30 ± 0.1% | 3960.04 ± 0.7% | 10.60 ± 0.2% | differs | 17.75 ± 0.5% | 19775.44 ± 0.6% | 77.99 | 1.01 | 5.03 | 1879.65 |
| other: a Greek word | 21815 | 502.02 ± 0.9% | 412.59 ± 0.2% | 30.73 ± 0.1% | 289.57 ± 0.3% | 47.15 ± 12.6% | differs | refused | 498.77 ± 0.2% | 1.22 | 1.01 | 1.73 | 10.65 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.86 ± 0.3% | 19.88 ± 0.1% | 0.84 ± 0.2% | 19.87 ± 0.5% | 2.77 ± 0.6% | differs | 4.07 ± 0.2% | 19.87 ± 0.1% | 1.00 | 1.00 | 1.00 | 7.16 |
| a UUID | 32895 | 21.16 ± 0.4% | 21.36 ± 0.1% | 0.64 ± 0.1% | 15.15 ± 0.3% | 3.09 ± 0.3% | 0.73 ± 0.1% | 3.65 ± 0.5% | 21.35 ± 0.1% | 0.99 | 0.99 | 1.40 | 6.84 |
| an IPv4 address | 33176 | 36.84 ± 0.3% | 36.82 ± 0.4% | 2.05 ± 0.1% | 29.39 ± 0.6% | 6.66 ± 0.1% | differs | 4.15 ± 0.1% | 36.85 ± 0.2% | 1.00 | 1.00 | 1.25 | 5.54 |
| a date and time | 32954 | 31.48 ± 0.3% | 31.38 ± 0.3% | 1.41 ± 0.2% | 21.51 ± 0.3% | 7.02 ± 0.1% | 1.25 ± 0.2% | 7.20 ± 0.7% | 31.38 ± 0.4% | 1.00 | 1.00 | 1.46 | 4.48 |
| a field path | 32606 | 23.48 ± 0.1% | 23.56 ± 0.1% | 1.00 ± 0.5% | 23.29 ± 0.3% | 3.52 ± 0.3% | differs | 2.97 ± 0.1% | 23.54 ± 0.2% | 1.00 | 1.00 | 1.01 | 6.68 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.08 ± 0.2% | 11.11 ± 0.5% | 11.08 ± 0.5% | 11.80 ± 0.2% | 4.87 ± 2.0% | 0.94 ± 0.7% | none | 11.12 ± 0.4% | 1.00 | 1.00 | 0.94 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 230.13 ± 0.2% | 231.23 ± 0.4% | 276.91 ± 0.3% | 87.22 ± 0.2% | 210.82 ± 0.9% | 485.09 ± 1.3% | 3805.57 ± 0.2% | 230.19 ± 0.4% | 1.00 | 1.00 | 2.64 | 1.09 |
| a UUID | 62 | 151.36 ± 0.4% | 151.76 ± 0.4% | 170.94 ± 0.2% | 45.60 ± 0.2% | 95.83 ± 1.2% | 184.05 ± 0.8% | 4227.89 ± 0.6% | 151.31 ± 0.3% | 1.00 | 1.00 | 3.32 | 1.58 |
| an IPv4 address | 29 | 417.07 ± 0.5% | 420.74 ± 0.6% | 601.97 ± 0.5% | 76.24 ± 1.1% | 125.03 ± 2.3% | 294.89 ± 1.2% | 7560.27 ± 0.5% | 416.11 ± 0.5% | 0.99 | 1.00 | 5.47 | 3.34 |
| a date and time | 56 | 300.34 ± 0.2% | 302.66 ± 0.2% | 383.75 ± 0.3% | 71.88 ± 0.1% | 130.16 ± 4.6% | 320.44 ± 1.1% | 4906.49 ± 0.4% | 300.20 ± 0.3% | 0.99 | 1.00 | 4.18 | 2.31 |
| a field path | 39 | 226.08 ± 0.3% | 226.74 ± 0.2% | 269.12 ± 0.2% | 79.54 ± 0.4% | 198.33 ± 2.8% | 483.93 ± 0.6% | 4862.81 ± 0.4% | 225.82 ± 0.5% | 1.00 | 1.00 | 2.84 | 1.14 |
| literal: a word | 7 | 628.13 ± 0.5% | 676.77 ± 0.7% | 1244.20 ± 0.2% | 505.97 ± 1.7% | 602.71 ± 0.9% | 927.71 ± 0.8% | 30988.73 ± 0.2% | 627.00 ± 0.6% | 0.93 | 1.00 | 1.24 | 1.04 |
| literal: a word that is not there | 8 | 606.68 ± 0.2% | 655.64 ± 0.3% | 1171.88 ± 0.1% | 462.87 ± 1.0% | 576.05 ± 2.0% | 878.87 ± 0.5% | 29475.19 ± 0.1% | 606.93 ± 0.4% | 0.93 | 1.00 | 1.31 | 1.05 |
| literal: one of four words | 26 | 239.38 ± 0.1% | 399.39 ± 0.5% | 549.51 ± 0.7% | 49.38 ± 0.2% | 228.30 ± 15.8% | 356.39 ± 0.6% | 16062.73 ± 0.3% | 239.07 ± 0.3% | 0.60 | 1.00 | 4.85 | 1.05 |
| literal: a word in any case | 11 | 445.17 ± 0.4% | 473.14 ± 0.4% | 705.58 ± 0.2% | 15.70 ± 1.2% | 633.25 ± 3.2% | refused | 23709.99 ± 0.4% | 444.98 ± 0.1% | 0.94 | 1.00 | 28.36 | 0.70 |
| literal: an href attribute | 12 | 342.47 ± 0.4% | 354.07 ± 0.5% | 473.72 ± 0.8% | 44.37 ± 0.4% | 481.04 ± 1.7% | 771.04 ± 2.4% | 21987.29 ± 0.4% | 342.04 ± 0.4% | 0.97 | 1.00 | 7.72 | 0.71 |
| literal: a word, second text | 10 | 559.13 ± 0.8% | 611.41 ± 0.8% | 1054.59 ± 0.5% | 409.40 ± 0.3% | 515.50 ± 2.5% | 804.53 ± 0.6% | 27297.70 ± 0.1% | 559.20 ± 0.5% | 0.91 | 1.00 | 1.37 | 1.08 |
| class: two capitalized words | 23 | 426.06 ± 0.8% | 461.44 ± 0.7% | 683.98 ± 0.4% | 101.28 ± 0.3% | 485.10 ± 3.7% | 739.52 ± 0.4% | 6481.64 ± 0.4% | 426.55 ± 0.3% | 0.92 | 1.00 | 4.21 | 0.88 |
| class: a word that ends in ing | 9 | 548.38 ± 0.2% | 622.79 ± 0.5% | 1127.19 ± 0.3% | 133.04 ± 1.0% | 729.54 ± 0.2% | 1093.61 ± 1.9% | 16032.96 ± 0.2% | 548.02 ± 0.3% | 0.88 | 1.00 | 4.12 | 0.75 |
| class: a word in capitals | 16 | 479.60 ± 0.4% | 524.56 ± 0.1% | 878.96 ± 0.3% | 135.41 ± 1.0% | 723.18 ± 1.6% | 1005.60 ± 0.8% | 8542.04 ± 0.2% | 479.93 ± 0.5% | 0.91 | 1.00 | 3.54 | 0.66 |
| class: a number | 6 | 604.77 ± 0.6% | 676.05 ± 0.3% | 1346.24 ± 0.1% | 41.80 ± 0.5% | 1355.32 ± 2.2% | 1905.93 ± 1.4% | 22798.65 ± 0.2% | 604.53 ± 0.3% | 0.89 | 1.00 | 14.47 | 0.45 |
| class: two capitalized words, second text | 23 | 427.14 ± 0.6% | 460.90 ± 0.4% | 683.34 ± 0.7% | 103.15 ± 0.1% | 485.96 ± 5.0% | 742.72 ± 0.8% | 6485.64 ± 0.5% | 426.51 ± 0.4% | 0.93 | 1.00 | 4.14 | 0.88 |
| other: a word between two words | 13 | 539.95 ± 0.4% | 557.37 ± 0.5% | 917.30 ± 0.1% | 135.48 ± 0.4% | 483.93 ± 3.2% | 813.94 ± 0.6% | 14864.97 ± 0.2% | 539.17 ± 1.0% | 0.97 | 1.00 | 3.99 | 1.12 |
| other: a number before a unit, second text | 15 | 393.51 ± 0.5% | 435.93 ± 0.4% | 623.84 ± 0.1% | 39.13 ± 0.4% | 607.15 ± 1.5% | 893.54 ± 0.6% | 15229.36 ± 0.3% | 393.65 ± 0.4% | 0.90 | 1.00 | 10.06 | 0.65 |
| other: a heading's start tag | 13 | 353.95 ± 0.4% | 359.54 ± 0.3% | 484.02 ± 0.3% | 43.15 ± 0.3% | 598.94 ± 2.9% | 862.39 ± 0.2% | 18208.08 ± 0.2% | 354.08 ± 0.3% | 0.98 | 1.00 | 8.20 | 0.59 |
| other: a whole word | 11 | 574.15 ± 0.2% | 607.34 ± 0.7% | 1035.39 ± 0.3% | 120.32 ± 0.3% | 540.20 ± 1.6% | 823.56 ± 0.4% | 27213.84 ± 0.2% | 574.10 ± 0.3% | 0.95 | 1.00 | 4.77 | 1.06 |
| other: a line's first word, second text | 17 | 522.64 ± 0.4% | 542.08 ± 0.1% | 889.18 ± 0.2% | 128.46 ± 0.2% | 683.59 ± 1.3% | refused | refused | 520.08 ± 0.5% | 0.96 | 1.00 | 4.07 | 0.76 |
| other: fourteen octets before an x | 16 | 107.51 ± 0.6% | 154.72 ± 0.5% | 180.02 ± 0.8% | 15.06 ± 0.5% | 430.88 ± 3.8% | 425.36 ± 0.7% | 12958.66 ± 0.5% | 107.53 ± 0.3% | 0.69 | 1.00 | 7.14 | 0.25 |
| other: a Greek word | 8 | 421.80 ± 0.4% | 584.41 ± 0.5% | 1039.94 ± 0.6% | 58.55 ± 0.4% | 1342.36 ± 2.7% | 1790.52 ± 0.5% | refused | 421.05 ± 0.4% | 0.72 | 1.00 | 7.20 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12816.89 ± 0.5% | not timed | not timed | 16423.36 ± 1.1% | 1922.91 ± 15.0% | not timed | not timed | 12844.16 ± 0.6% | | 1.00 | 0.78 | 6.67 |
| 01-literal/sherlock-casei-en | 522 | 4955.69 ± 1.0% | not timed | not timed | 3588.22 ± 0.1% | 32.15 ± 0.1% | not timed | not timed | 4948.61 ± 0.5% | | 1.00 | 1.38 | 154.16 |
| 01-literal/sherlock-ru | 724 | 13472.49 ± 0.6% | not timed | not timed | 17254.01 ± 0.4% | 1388.20 ± 14.6% | not timed | not timed | 13409.73 ± 0.5% | | 1.00 | 0.78 | 9.71 |
| 01-literal/sherlock-casei-ru | 746 | 5964.43 ± 0.3% | not timed | not timed | 3322.38 ± 0.1% | 31.40 ± 0.8% | not timed | not timed | 5962.17 ± 0.2% | | 1.00 | 1.80 | 189.92 |
| 01-literal/sherlock-zh | 30 | 17191.18 ± 0.9% | not timed | not timed | 18818.10 ± 0.6% | 2826.30 ± 11.1% | not timed | not timed | 17196.90 ± 0.6% | | 1.00 | 0.91 | 6.08 |
| 02-literal-alternate/sherlock-en | 714 | 5764.56 ± 0.3% | not timed | not timed | 3943.66 ± 0.2% | 16.52 ± 0.2% | not timed | not timed | 5754.13 ± 0.1% | | 1.00 | 1.46 | 349.03 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1803.68 ± 1.3% | not timed | not timed | 696.74 ± 0.3% | 10.89 ± 0.2% | not timed | not timed | 1793.41 ± 0.7% | | 1.01 | 2.59 | 165.68 |
| 02-literal-alternate/sherlock-ru | 899 | 5330.14 ± 0.1% | not timed | not timed | 3261.50 ± 0.1% | 22.67 ± 0.1% | not timed | not timed | 5325.89 ± 0.3% | | 1.00 | 1.63 | 235.13 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1920.25 ± 0.6% | not timed | not timed | 1231.75 ± 0.5% | 9.14 ± 5.5% | not timed | not timed | 1909.56 ± 0.4% | | 1.01 | 1.56 | 210.18 |
| 02-literal-alternate/sherlock-zh | 207 | 7056.43 ± 0.8% | not timed | not timed | 4166.39 ± 0.2% | 31.52 ± 0.1% | not timed | not timed | 7044.58 ± 0.1% | | 1.00 | 1.69 | 223.87 |
| 03-date/ascii | 111817 | 126.57 ± 0.2% | not timed | not timed | 95.42 ± 0.1% | 0.20 ± 1.7% | not timed | not timed | 125.66 ± 0.1% | | 1.01 | 1.33 | 625.11 |
| 04-ruff-noqa/real | 84 | 409.26 ± 1.5% | not timed | not timed | 466.23 ± 2.7% | 19.51 ± 1.5% | not timed | not timed | 407.99 ± 0.0% | | 1.00 | 0.88 | 20.97 |
| 04-ruff-noqa/tweaked | 44 | 549.40 ± 0.3% | not timed | not timed | 463.42 ± 0.2% | 361.74 ± 0.4% | not timed | not timed | 549.33 ± 0.3% | | 1.00 | 1.19 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.34 ± 0.9% | not timed | not timed | 5.17 ± 0.2% | 0.20 ± 4.9% | not timed | not timed | 5.35 ± 3.5% | | 1.00 | 1.03 | 26.32 |
| 06-cloud-flare-redos/original | 107 | 415.56 ± 0.5% | not timed | not timed | 215.34 ± 0.1% | 24.81 ± 0.2% | not timed | not timed | 414.96 ± 0.6% | | 1.00 | 1.93 | 16.75 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.07 ± 0.1% | not timed | not timed | 228.49 ± 0.1% | 26.79 ± 0.3% | not timed | not timed | 410.47 ± 0.3% | | 1.00 | 1.79 | 15.30 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.91 ± 0.2% | not timed | not timed | 255.92 ± 0.6% | 28.80 ± 0.2% | not timed | not timed | 586.83 ± 0.1% | | 1.00 | 2.30 | 20.42 |
| 07-unicode-character-data/parse-line | 558784 | 230.78 ± 1.8% | not timed | not timed | 179.06 ± 0.1% | 40.29 ± 7.9% | not timed | not timed | 231.31 ± 2.3% | | 1.00 | 1.29 | 5.73 |
| 08-words/all-english | 56691 | 116.64 ± 0.6% | not timed | not timed | 82.43 ± 0.1% | 11.66 ± 4.9% | not timed | not timed | 116.36 ± 0.6% | | 1.00 | 1.41 | 10.01 |
| 08-words/long-english | 839 | 620.38 ± 0.2% | not timed | not timed | 596.01 ± 0.2% | 32.20 ± 0.3% | not timed | not timed | 620.70 ± 0.1% | | 1.00 | 1.04 | 19.27 |
| 09-aws-keys/full | 0 | 415.47 ± 0.1% | not timed | not timed | 492.35 ± 0.1% | 64.63 ± 3.4% | not timed | not timed | 414.69 ± 0.3% | | 1.00 | 0.84 | 6.43 |
| 09-aws-keys/quick | 0 | 732.68 ± 0.1% | not timed | not timed | 1000.07 ± 0.6% | 416.75 ± 2.1% | not timed | not timed | 729.92 ± 0.1% | | 1.00 | 0.73 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 585.60 ± 2.6% | not timed | not timed | 517.40 ± 0.3% | 19.53 ± 0.8% | not timed | not timed | 582.56 ± 1.7% | | 1.01 | 1.13 | 29.99 |
| 10-bounded-repeat/letters-ru | 3475 | 511.79 ± 1.1% | not timed | not timed | 477.23 ± 0.2% | 21.75 ± 17.3% | not timed | not timed | 508.92 ± 1.2% | | 1.01 | 1.07 | 23.54 |
| 10-bounded-repeat/context | 53 | 77.09 ± 0.5% | not timed | not timed | 65.00 ± 1.3% | 19.80 ± 0.1% | not timed | not timed | 77.23 ± 0.5% | | 1.00 | 1.19 | 3.89 |
| 10-bounded-repeat/capitals | 11 | 631.43 ± 8.3% | not timed | not timed | 616.73 ± 0.1% | 36.61 ± 1.2% | not timed | not timed | 630.44 ± 8.5% | | 1.00 | 1.02 | 17.25 |
| 11-unstructured-to-json/extract | 600 | 79.47 ± 0.1% | not timed | not timed | 76.59 ± 0.2% | 49.04 ± 0.3% | not timed | not timed | 81.05 ± 0.1% | | 0.98 | 1.04 | 1.62 |
| 12-dictionary/single | 1 | 560.79 ± 0.7% | not timed | not timed | 561.39 ± 0.3% | 0.40 ± 0.1% | not timed | not timed | 560.14 ± 0.3% | | 1.00 | 1.00 | 1402.46 |
| 14-quadratic/1x | 100 | 21.51 ± 0.5% | not timed | not timed | 10.06 ± 0.2% | 0.96 ± 2.9% | not timed | not timed | 21.43 ± 1.5% | | 1.00 | 2.14 | 22.31 |
| 14-quadratic/2x | 200 | 17.68 ± 3.5% | not timed | not timed | 5.52 ± 0.1% | 0.53 ± 0.6% | not timed | not timed | 17.62 ± 3.3% | | 1.00 | 3.20 | 33.22 |
| 14-quadratic/10x | 1000 | 7.71 ± 1.9% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 1.7% | not timed | not timed | 7.68 ± 1.7% | | 1.00 | 6.35 | 67.02 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.30 ± 0.1% | not timed | not timed | 0.34 ± 1.1% | 0.53 ± 6.4% | not timed | not timed | 1.29 ± 3.0% | | 1.00 | 3.78 | 2.45 |
| 04-ruff-noqa/compile-real | 1 | 91.45 ± 0.2% | not timed | not timed | 14.01 ± 0.0% | 127.70 ± 3.1% | not timed | not timed | 91.31 ± 1.0% | | 1.00 | 6.53 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 13.95 ± 0.4% | not timed | not timed | 2.53 ± 0.4% | 6.14 ± 4.6% | not timed | not timed | 13.89 ± 1.2% | | 1.00 | 5.51 | 2.27 |
| 07-unicode-character-data/compile | 1 | 55.57 ± 0.2% | not timed | not timed | 26.01 ± 0.2% | 35.20 ± 5.4% | not timed | not timed | 55.24 ± 1.1% | | 1.01 | 2.14 | 1.58 |
| 09-aws-keys/compile-full | 1 | 42.29 ± 0.2% | not timed | not timed | 8.31 ± 0.6% | 22.31 ± 4.9% | not timed | not timed | 41.93 ± 0.2% | | 1.01 | 5.09 | 1.90 |
| 09-aws-keys/compile-quick | 1 | 182.31 ± 0.6% | not timed | not timed | 48.39 ± 0.4% | 129.62 ± 3.8% | not timed | not timed | 181.22 ± 0.7% | | 1.01 | 3.77 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 13.87 ± 0.2% | not timed | not timed | 11.20 ± 0.2% | 15.55 ± 4.5% | not timed | not timed | 13.79 ± 1.8% | | 1.01 | 1.24 | 0.89 |
| 10-bounded-repeat/compile-capitals | 1 | 82.50 ± 0.2% | not timed | not timed | 8.04 ± 0.2% | 23.53 ± 2.2% | not timed | not timed | 82.57 ± 1.2% | | 1.00 | 10.26 | 3.51 |
| 11-unstructured-to-json/compile | 1 | 86.58 ± 0.2% | not timed | not timed | 40.34 ± 0.4% | 65.69 ± 3.4% | not timed | not timed | 85.18 ± 0.7% | | 1.02 | 2.15 | 1.32 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 0.9% | 0.09 ± 20.2% | not timed | not timed | 0.34 ± 1.1% | | 1.01 | 5.20 | 3.84 |

