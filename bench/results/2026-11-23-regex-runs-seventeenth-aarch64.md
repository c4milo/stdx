# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148132263 |
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
| literal: a word | 217 | 16084.98 ± 1.0% | 1039.69 ± 0.2% | 28.84 ± 0.3% | 18147.70 ± 1.9% | 9213.93 ± 7.2% | 17.33 ± 0.1% | 86.93 ± 0.1% | 16070.57 ± 1.3% | 15.47 | 1.00 | 0.89 | 1.75 |
| literal: a word that is not there | 0 | 18609.73 ± 1.0% | 1048.29 ± 0.2% | 28.84 ± 0.3% | 19748.77 ± 2.8% | 28645.26 ± 2.8% | 17.08 ± 0.2% | 82.88 ± 0.2% | 18650.32 ± 1.1% | 17.75 | 1.00 | 0.94 | 0.65 |
| literal: one of four words | 661 | 6048.55 ± 0.6% | 1024.18 ± 0.1% | 14.75 ± 0.1% | 3943.57 ± 0.2% | 21.85 ± 0.3% | 5.43 ± 0.6% | 6.94 ± 0.2% | 6015.76 ± 0.5% | 5.91 | 1.01 | 1.53 | 276.77 |
| literal: a word in any case | 217 | 12574.12 ± 0.7% | 1040.57 ± 0.2% | 21.64 ± 2.4% | 3971.49 ± 0.3% | 37.64 ± 0.2% | refused | differs | 12551.35 ± 1.0% | 12.08 | 1.00 | 3.17 | 334.07 |
| literal: an href attribute | 33 | 13793.80 ± 0.7% | 1047.95 ± 0.1% | 27.52 ± 0.4% | 17122.60 ± 2.0% | 2269.44 ± 0.5% | 13.12 ± 0.3% | 75.89 ± 0.3% | 13802.84 ± 0.4% | 13.16 | 1.00 | 0.81 | 6.08 |
| literal: a word, second text | 123 | 16389.52 ± 1.6% | 1044.45 ± 0.1% | 28.39 ± 0.2% | 18362.85 ± 1.6% | 7848.11 ± 5.1% | 19.98 ± 0.8% | 71.14 ± 0.6% | 16487.01 ± 0.9% | 15.69 | 0.99 | 0.89 | 2.09 |
| class: two capitalized words | 1331 | 1107.49 ± 0.4% | 978.63 ± 0.1% | 26.22 ± 0.1% | 585.20 ± 0.1% | 40.55 ± 12.7% | 14.65 ± 0.2% | 68.84 ± 0.3% | 1105.18 ± 0.3% | 1.13 | 1.00 | 1.89 | 27.31 |
| class: a word that ends in ing | 3399 | 894.63 ± 0.2% | 892.64 ± 0.2% | 18.26 ± 0.1% | 547.75 ± 0.1% | 29.62 ± 3.3% | 8.19 ± 0.2% | 18.44 ± 0.5% | 893.42 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.20 |
| class: a word in capitals | 2332 | 1454.19 ± 0.2% | 949.47 ± 0.1% | 27.98 ± 0.4% | 572.43 ± 0.2% | 43.49 ± 2.1% | 17.06 ± 1.2% | 83.37 ± 1.5% | 1451.55 ± 0.5% | 1.53 | 1.00 | 2.54 | 33.44 |
| class: a number | 8288 | 1991.57 ± 0.1% | 836.53 ± 0.1% | 28.13 ± 0.1% | 1721.04 ± 0.2% | 42.94 ± 16.5% | 0.55 ± 0.1% | 56.58 ± 0.6% | 1974.60 ± 0.2% | 2.38 | 1.01 | 1.16 | 46.38 |
| class: two capitalized words, second text | 5359 | 743.92 ± 0.2% | 744.34 ± 0.1% | 23.50 ± 0.3% | 483.88 ± 0.2% | 35.39 ± 13.3% | 17.05 ± 0.2% | 63.94 ± 0.6% | 743.62 ± 0.1% | 1.00 | 1.00 | 1.54 | 21.02 |
| other: a word between two words | 6104 | 756.11 ± 0.3% | 776.82 ± 0.2% | 23.72 ± 0.3% | 739.54 ± 0.3% | 108.96 ± 15.0% | 11.20 ± 0.1% | 69.90 ± 0.3% | 755.56 ± 0.1% | 0.97 | 1.00 | 1.02 | 6.94 |
| other: a number before a unit, second text | 1481 | 5450.86 ± 0.3% | 985.36 ± 0.1% | 26.15 ± 0.3% | 5642.73 ± 0.5% | 40.75 ± 0.2% | 18.14 ± 0.5% | 67.07 ± 0.5% | 5456.10 ± 0.3% | 5.53 | 1.00 | 0.97 | 133.76 |
| other: a heading's start tag | 110 | 12628.37 ± 0.8% | 1036.90 ± 0.1% | 27.66 ± 0.3% | 1712.48 ± 0.2% | 1586.96 ± 5.7% | 16.09 ± 0.5% | 88.97 ± 0.4% | 12648.53 ± 0.4% | 12.18 | 1.00 | 7.37 | 7.96 |
| other: a whole word | 217 | 14027.57 ± 0.3% | 1038.46 ± 0.2% | 29.82 ± 0.1% | 14538.94 ± 1.1% | 49.44 ± 0.3% | 13.21 ± 0.3% | 56.34 ± 0.4% | 14006.44 ± 0.6% | 13.51 | 1.00 | 0.96 | 283.73 |
| other: a line's first word, second text | 3716 | 1978.80 ± 0.9% | 877.00 ± 0.2% | 31.35 ± 0.4% | 1723.56 ± 0.6% | 62.44 ± 3.2% | refused | refused | 1964.76 ± 1.0% | 2.26 | 1.01 | 1.15 | 31.69 |
| other: fourteen octets before an x | 87 | 19849.90 ± 1.1% | 221.07 ± 0.5% | 6.60 ± 0.1% | 4022.85 ± 0.3% | 10.65 ± 0.1% | differs | 17.83 ± 0.2% | 19881.98 ± 0.5% | 89.79 | 1.00 | 4.93 | 1864.37 |
| other: a Greek word | 21815 | 514.40 ± 0.3% | 414.52 ± 0.1% | 31.32 ± 0.1% | 289.81 ± 0.2% | 44.75 ± 9.0% | differs | refused | 513.26 ± 0.5% | 1.24 | 1.00 | 1.77 | 11.50 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.88 ± 0.1% | 25.90 ± 0.2% | 0.87 ± 0.4% | 19.86 ± 0.5% | 2.78 ± 0.5% | differs | 4.02 ± 0.3% | 25.92 ± 0.1% | 1.00 | 1.00 | 1.30 | 9.32 |
| a UUID | 32895 | 21.10 ± 0.1% | 21.22 ± 0.1% | 0.65 ± 0.3% | 15.13 ± 0.5% | 3.11 ± 0.1% | 0.72 ± 0.4% | 3.60 ± 0.3% | 21.17 ± 0.4% | 0.99 | 1.00 | 1.39 | 6.79 |
| an IPv4 address | 33176 | 37.01 ± 0.4% | 36.99 ± 0.1% | 2.11 ± 0.5% | 29.34 ± 0.6% | 6.69 ± 0.3% | differs | 4.19 ± 0.2% | 37.05 ± 0.1% | 1.00 | 1.00 | 1.26 | 5.54 |
| a date and time | 32954 | 31.19 ± 0.5% | 31.27 ± 0.4% | 1.48 ± 0.2% | 21.46 ± 0.6% | 7.00 ± 0.3% | 1.23 ± 0.1% | 7.16 ± 0.9% | 31.26 ± 0.5% | 1.00 | 1.00 | 1.45 | 4.45 |
| a field path | 32606 | 29.56 ± 0.1% | 29.50 ± 0.3% | 1.04 ± 0.1% | 23.34 ± 0.3% | 3.51 ± 0.6% | differs | 2.94 ± 0.6% | 29.57 ± 0.1% | 1.00 | 1.00 | 1.27 | 8.41 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.48 ± 0.2% | 11.45 ± 0.4% | 11.47 ± 0.3% | 11.81 ± 0.2% | 4.96 ± 1.2% | 0.92 ± 0.3% | none | 11.47 ± 0.3% | 1.00 | 1.00 | 0.97 | 2.31 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.43 ± 0.2% | 237.35 ± 0.2% | 286.99 ± 0.3% | 86.61 ± 0.4% | 221.29 ± 2.5% | 480.54 ± 1.9% | 3864.49 ± 2.8% | 235.20 ± 0.1% | 0.99 | 1.00 | 2.72 | 1.06 |
| a UUID | 62 | 157.47 ± 0.2% | 157.81 ± 0.1% | 178.83 ± 0.1% | 46.49 ± 0.6% | 99.67 ± 1.3% | 187.28 ± 3.2% | 4387.57 ± 2.0% | 157.40 ± 0.2% | 1.00 | 1.00 | 3.39 | 1.58 |
| an IPv4 address | 29 | 421.53 ± 0.4% | 426.43 ± 0.4% | 612.76 ± 0.2% | 77.42 ± 0.3% | 131.90 ± 2.8% | 299.65 ± 1.4% | 7603.66 ± 0.1% | 422.08 ± 0.5% | 0.99 | 1.00 | 5.44 | 3.20 |
| a date and time | 56 | 305.24 ± 0.4% | 308.65 ± 0.2% | 393.22 ± 0.4% | 73.19 ± 0.1% | 137.49 ± 0.7% | 328.47 ± 1.5% | 4913.83 ± 0.5% | 305.14 ± 0.3% | 0.99 | 1.00 | 4.17 | 2.22 |
| a field path | 39 | 227.42 ± 0.3% | 229.06 ± 0.4% | 274.53 ± 0.2% | 80.96 ± 0.5% | 206.67 ± 1.4% | 501.97 ± 5.8% | 4937.30 ± 3.2% | 227.66 ± 0.5% | 0.99 | 1.00 | 2.81 | 1.10 |
| literal: a word | 7 | 630.19 ± 0.6% | 676.10 ± 0.7% | 1261.66 ± 0.8% | 519.11 ± 0.2% | 630.30 ± 2.0% | 954.84 ± 0.4% | 29634.13 ± 0.1% | 628.51 ± 0.9% | 0.93 | 1.00 | 1.21 | 1.00 |
| literal: a word that is not there | 8 | 604.46 ± 0.2% | 655.52 ± 0.3% | 1188.71 ± 0.1% | 467.75 ± 0.3% | 602.05 ± 1.5% | 907.55 ± 0.1% | 28477.71 ± 0.3% | 603.84 ± 0.2% | 0.92 | 1.00 | 1.29 | 1.00 |
| literal: one of four words | 26 | 242.96 ± 0.3% | 405.24 ± 0.2% | 565.57 ± 0.5% | 50.62 ± 0.7% | 244.77 ± 1.9% | 381.46 ± 0.8% | 15533.86 ± 0.2% | 242.55 ± 0.2% | 0.60 | 1.00 | 4.80 | 0.99 |
| literal: a word in any case | 11 | 487.89 ± 0.4% | 521.72 ± 0.3% | 842.90 ± 0.5% | 15.86 ± 1.5% | 658.07 ± 4.9% | refused | 23367.61 ± 0.3% | 488.10 ± 0.3% | 0.94 | 1.00 | 30.77 | 0.74 |
| literal: an href attribute | 12 | 352.96 ± 0.7% | 365.95 ± 0.6% | 497.78 ± 0.8% | 45.18 ± 0.4% | 503.23 ± 1.2% | 780.98 ± 0.9% | 21265.90 ± 0.3% | 353.19 ± 0.5% | 0.96 | 1.00 | 7.81 | 0.70 |
| literal: a word, second text | 10 | 566.77 ± 0.3% | 624.32 ± 0.2% | 1078.78 ± 0.1% | 396.08 ± 0.2% | 539.61 ± 1.5% | 809.46 ± 0.5% | 26473.93 ± 0.2% | 567.16 ± 0.5% | 0.91 | 1.00 | 1.43 | 1.05 |
| class: two capitalized words | 23 | 438.01 ± 0.7% | 467.74 ± 0.6% | 700.74 ± 1.0% | 101.29 ± 0.5% | 506.61 ± 1.2% | 745.65 ± 0.8% | 6569.91 ± 0.2% | 438.13 ± 0.4% | 0.94 | 1.00 | 4.32 | 0.86 |
| class: a word that ends in ing | 9 | 567.83 ± 0.2% | 635.58 ± 0.4% | 1162.29 ± 0.3% | 131.71 ± 1.2% | 761.40 ± 1.2% | 1119.86 ± 0.5% | 15864.49 ± 0.1% | 568.38 ± 0.2% | 0.89 | 1.00 | 4.31 | 0.75 |
| class: a word in capitals | 16 | 501.50 ± 0.3% | 538.49 ± 0.4% | 896.80 ± 0.3% | 136.16 ± 0.7% | 758.14 ± 0.8% | 1038.96 ± 1.3% | 8624.89 ± 0.4% | 501.28 ± 0.2% | 0.93 | 1.00 | 3.68 | 0.66 |
| class: a number | 6 | 629.17 ± 0.3% | 696.41 ± 0.3% | 1366.69 ± 0.0% | 41.62 ± 1.1% | 1411.45 ± 0.3% | 1867.53 ± 1.4% | 22464.23 ± 0.2% | 629.12 ± 0.2% | 0.90 | 1.00 | 15.12 | 0.45 |
| class: two capitalized words, second text | 23 | 438.38 ± 0.4% | 466.99 ± 0.5% | 699.03 ± 0.5% | 102.94 ± 0.6% | 508.58 ± 1.2% | 765.81 ± 1.0% | 6564.53 ± 0.4% | 438.40 ± 0.6% | 0.94 | 1.00 | 4.26 | 0.86 |
| other: a word between two words | 13 | 553.60 ± 0.9% | 571.85 ± 0.5% | 943.72 ± 0.8% | 134.73 ± 0.7% | 506.94 ± 1.3% | 812.47 ± 0.7% | 14749.21 ± 0.2% | 552.36 ± 0.9% | 0.97 | 1.00 | 4.11 | 1.09 |
| other: a number before a unit, second text | 15 | 408.89 ± 0.2% | 447.84 ± 0.9% | 649.22 ± 0.6% | 39.33 ± 0.4% | 637.62 ± 7.9% | 900.46 ± 0.5% | 15000.27 ± 0.2% | 409.03 ± 0.3% | 0.91 | 1.00 | 10.40 | 0.64 |
| other: a heading's start tag | 13 | 360.37 ± 0.4% | 366.18 ± 0.4% | 497.73 ± 0.5% | 43.92 ± 0.6% | 631.00 ± 0.9% | 864.18 ± 0.5% | 17841.24 ± 0.3% | 360.44 ± 0.3% | 0.98 | 1.00 | 8.21 | 0.57 |
| other: a whole word | 11 | 587.97 ± 0.4% | 624.64 ± 0.4% | 1086.81 ± 0.0% | 118.76 ± 0.3% | 568.40 ± 2.9% | 830.41 ± 1.2% | 26276.42 ± 0.6% | 588.34 ± 0.4% | 0.94 | 1.00 | 4.95 | 1.03 |
| other: a line's first word, second text | 17 | 538.48 ± 0.5% | 557.85 ± 0.8% | 937.25 ± 0.3% | 131.20 ± 0.3% | 704.58 ± 16.2% | refused | refused | 536.52 ± 0.7% | 0.97 | 1.00 | 4.10 | 0.76 |
| other: fourteen octets before an x | 16 | 112.09 ± 0.4% | 162.51 ± 0.6% | 190.56 ± 0.5% | 15.20 ± 0.7% | 453.87 ± 1.9% | 414.27 ± 0.8% | 12513.77 ± 0.6% | 112.15 ± 0.3% | 0.69 | 1.00 | 7.37 | 0.25 |
| other: a Greek word | 8 | 431.84 ± 0.3% | 593.26 ± 0.2% | 1039.83 ± 0.5% | 59.14 ± 0.4% | 1368.36 ± 3.6% | 1804.67 ± 0.4% | refused | 431.98 ± 0.3% | 0.73 | 1.00 | 7.30 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12890.24 ± 0.5% | not timed | not timed | 16427.67 ± 1.4% | 2086.80 ± 13.1% | not timed | not timed | 12876.27 ± 0.6% | | 1.00 | 0.78 | 6.18 |
| 01-literal/sherlock-casei-en | 522 | 4496.13 ± 1.0% | not timed | not timed | 3595.37 ± 0.3% | 32.53 ± 0.1% | not timed | not timed | 4485.36 ± 0.3% | | 1.00 | 1.25 | 138.20 |
| 01-literal/sherlock-ru | 724 | 13524.79 ± 0.6% | not timed | not timed | 17344.43 ± 0.3% | 1419.79 ± 13.6% | not timed | not timed | 13493.61 ± 0.5% | | 1.00 | 0.78 | 9.53 |
| 01-literal/sherlock-casei-ru | 746 | 5299.29 ± 0.2% | not timed | not timed | 3330.00 ± 0.2% | 31.68 ± 0.3% | not timed | not timed | 5283.59 ± 0.1% | | 1.00 | 1.59 | 167.29 |
| 01-literal/sherlock-zh | 30 | 17076.74 ± 0.3% | not timed | not timed | 18741.92 ± 0.8% | 2783.47 ± 7.9% | not timed | not timed | 17053.85 ± 0.4% | | 1.00 | 0.91 | 6.14 |
| 02-literal-alternate/sherlock-en | 714 | 5749.95 ± 0.4% | not timed | not timed | 3940.04 ± 0.2% | 16.47 ± 0.1% | not timed | not timed | 5762.65 ± 0.4% | | 1.00 | 1.46 | 349.03 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1708.45 ± 1.1% | not timed | not timed | 696.37 ± 0.4% | 11.13 ± 7.2% | not timed | not timed | 1702.91 ± 1.0% | | 1.00 | 2.45 | 153.46 |
| 02-literal-alternate/sherlock-ru | 899 | 4649.48 ± 0.2% | not timed | not timed | 3251.45 ± 0.1% | 22.63 ± 0.1% | not timed | not timed | 4637.01 ± 0.3% | | 1.00 | 1.43 | 205.44 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1811.62 ± 0.6% | not timed | not timed | 1225.89 ± 0.1% | 9.13 ± 0.1% | not timed | not timed | 1803.93 ± 0.3% | | 1.00 | 1.48 | 198.37 |
| 02-literal-alternate/sherlock-zh | 207 | 7024.42 ± 0.8% | not timed | not timed | 4164.83 ± 0.6% | 31.51 ± 0.1% | not timed | not timed | 7046.35 ± 0.7% | | 1.00 | 1.69 | 222.94 |
| 03-date/ascii | 111817 | 127.35 ± 0.7% | not timed | not timed | 95.51 ± 0.1% | 0.20 ± 3.7% | not timed | not timed | 123.77 ± 0.4% | | 1.03 | 1.33 | 623.69 |
| 04-ruff-noqa/real | 84 | 553.54 ± 0.0% | not timed | not timed | 461.12 ± 0.1% | 19.54 ± 1.2% | not timed | not timed | 548.39 ± 0.1% | | 1.01 | 1.20 | 28.32 |
| 04-ruff-noqa/tweaked | 44 | 547.83 ± 0.2% | not timed | not timed | 462.87 ± 0.1% | 366.98 ± 0.8% | not timed | not timed | 540.26 ± 0.2% | | 1.01 | 1.18 | 1.49 |
| 05-lexer-veryl/single | 124800 | 4.22 ± 0.2% | not timed | not timed | 5.23 ± 0.2% | 0.20 ± 2.8% | not timed | not timed | 4.22 ± 0.3% | | 1.00 | 0.81 | 20.96 |
| 06-cloud-flare-redos/original | 107 | 263.94 ± 0.2% | not timed | not timed | 214.89 ± 0.1% | 24.95 ± 0.1% | not timed | not timed | 262.22 ± 0.1% | | 1.01 | 1.23 | 10.58 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.36 ± 0.2% | not timed | not timed | 226.85 ± 0.1% | 26.76 ± 0.4% | not timed | not timed | 258.18 ± 0.2% | | 1.00 | 1.14 | 9.69 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.20 ± 0.2% | not timed | not timed | 255.66 ± 0.0% | 28.81 ± 0.2% | not timed | not timed | 286.19 ± 0.3% | | 1.00 | 1.12 | 9.93 |
| 07-unicode-character-data/parse-line | 558784 | 234.77 ± 2.9% | not timed | not timed | 178.39 ± 0.0% | 43.41 ± 5.9% | not timed | not timed | 228.17 ± 1.2% | | 1.03 | 1.32 | 5.41 |
| 08-words/all-english | 56691 | 120.03 ± 0.2% | not timed | not timed | 83.18 ± 0.2% | 12.16 ± 9.9% | not timed | not timed | 119.64 ± 0.7% | | 1.00 | 1.44 | 9.87 |
| 08-words/long-english | 839 | 1006.50 ± 0.1% | not timed | not timed | 597.71 ± 0.0% | 32.43 ± 0.4% | not timed | not timed | 1005.74 ± 0.0% | | 1.00 | 1.68 | 31.04 |
| 09-aws-keys/full | 0 | 409.01 ± 0.1% | not timed | not timed | 477.29 ± 0.1% | 64.70 ± 0.2% | not timed | not timed | 406.51 ± 0.1% | | 1.01 | 0.86 | 6.32 |
| 09-aws-keys/quick | 0 | 740.19 ± 0.1% | not timed | not timed | 998.62 ± 0.3% | 425.10 ± 1.1% | not timed | not timed | 738.46 ± 0.1% | | 1.00 | 0.74 | 1.74 |
| 10-bounded-repeat/letters-en | 1833 | 636.02 ± 0.5% | not timed | not timed | 512.94 ± 0.3% | 19.42 ± 0.3% | not timed | not timed | 629.80 ± 0.1% | | 1.01 | 1.24 | 32.75 |
| 10-bounded-repeat/letters-ru | 3475 | 385.25 ± 0.2% | not timed | not timed | 477.84 ± 0.0% | 21.49 ± 16.5% | not timed | not timed | 377.72 ± 0.5% | | 1.02 | 0.81 | 17.93 |
| 10-bounded-repeat/context | 53 | 79.28 ± 1.2% | not timed | not timed | 66.40 ± 1.0% | 19.83 ± 0.2% | not timed | not timed | 79.34 ± 0.8% | | 1.00 | 1.19 | 4.00 |
| 10-bounded-repeat/capitals | 11 | 1042.08 ± 0.3% | not timed | not timed | 618.69 ± 0.1% | 36.44 ± 0.1% | not timed | not timed | 1042.36 ± 0.1% | | 1.00 | 1.68 | 28.60 |
| 11-unstructured-to-json/extract | 600 | 49.29 ± 0.4% | not timed | not timed | 76.25 ± 0.4% | 49.35 ± 0.2% | not timed | not timed | 48.21 ± 0.2% | | 1.02 | 0.65 | 1.00 |
| 12-dictionary/single | 1 | 566.96 ± 0.2% | not timed | not timed | 561.95 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 567.67 ± 1.1% | | 1.00 | 1.01 | 1389.17 |
| 14-quadratic/1x | 100 | 9.64 ± 0.6% | not timed | not timed | 10.08 ± 0.3% | 0.98 ± 4.9% | not timed | not timed | 9.56 ± 1.2% | | 1.01 | 0.96 | 9.81 |
| 14-quadratic/2x | 200 | 5.56 ± 0.3% | not timed | not timed | 5.54 ± 0.3% | 0.54 ± 0.8% | not timed | not timed | 5.54 ± 0.8% | | 1.00 | 1.00 | 10.39 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.1% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 1.26 ± 0.6% | | 1.00 | 1.04 | 10.91 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.2% | not timed | not timed | 0.34 ± 0.1% | 0.56 ± 3.3% | not timed | not timed | 1.44 ± 0.5% | | 1.00 | 4.20 | 2.60 |
| 04-ruff-noqa/compile-real | 1 | 92.63 ± 1.3% | not timed | not timed | 13.97 ± 0.4% | 141.42 ± 3.0% | not timed | not timed | 91.95 ± 1.0% | | 1.01 | 6.63 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 14.69 ± 0.1% | not timed | not timed | 2.52 ± 0.7% | 6.59 ± 1.7% | not timed | not timed | 14.57 ± 1.5% | | 1.01 | 5.82 | 2.23 |
| 07-unicode-character-data/compile | 1 | 58.36 ± 0.3% | not timed | not timed | 26.18 ± 0.2% | 36.13 ± 12.9% | not timed | not timed | 58.26 ± 0.5% | | 1.00 | 2.23 | 1.62 |
| 09-aws-keys/compile-full | 1 | 43.75 ± 0.2% | not timed | not timed | 8.33 ± 0.3% | 23.71 ± 0.7% | not timed | not timed | 43.47 ± 0.3% | | 1.01 | 5.25 | 1.84 |
| 09-aws-keys/compile-quick | 1 | 187.77 ± 0.1% | not timed | not timed | 48.59 ± 0.8% | 134.71 ± 1.3% | not timed | not timed | 188.93 ± 0.8% | | 0.99 | 3.86 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 14.73 ± 0.4% | not timed | not timed | 11.21 ± 0.1% | 16.39 ± 1.0% | not timed | not timed | 14.56 ± 1.8% | | 1.01 | 1.31 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 86.01 ± 0.8% | not timed | not timed | 8.12 ± 0.2% | 24.16 ± 2.5% | not timed | not timed | 85.77 ± 0.9% | | 1.00 | 10.59 | 3.56 |
| 11-unstructured-to-json/compile | 1 | 90.95 ± 0.3% | not timed | not timed | 40.55 ± 1.0% | 69.58 ± 3.3% | not timed | not timed | 89.98 ± 1.1% | | 1.01 | 2.24 | 1.31 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.1% | not timed | not timed | 0.07 ± 1.5% | 0.10 ± 8.1% | not timed | not timed | 0.36 ± 0.8% | | 1.01 | 5.16 | 3.67 |

