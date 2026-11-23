# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102059804 |
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
| literal: a word | 217 | 15988.39 ± 0.6% | 1041.15 ± 0.1% | 27.68 ± 0.1% | 18009.90 ± 2.3% | 9145.95 ± 8.6% | 17.19 ± 0.5% | 86.37 ± 0.2% | 16005.58 ± 0.8% | 15.36 | 1.00 | 0.89 | 1.75 |
| literal: a word that is not there | 0 | 18650.75 ± 1.8% | 1045.41 ± 0.2% | 27.66 ± 0.1% | 19592.34 ± 3.1% | 28578.67 ± 2.5% | 17.01 ± 0.2% | 82.12 ± 0.1% | 18740.05 ± 2.6% | 17.84 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6177.32 ± 0.5% | 1019.71 ± 0.1% | 14.29 ± 0.1% | 3940.65 ± 0.4% | 21.90 ± 0.0% | 5.34 ± 0.1% | 6.91 ± 0.7% | 6155.32 ± 0.5% | 6.06 | 1.00 | 1.57 | 282.10 |
| literal: a word in any case | 217 | 12474.93 ± 1.4% | 1040.15 ± 0.3% | 20.74 ± 2.3% | 3972.46 ± 0.2% | 38.05 ± 0.4% | refused | differs | 12455.00 ± 0.6% | 11.99 | 1.00 | 3.14 | 327.84 |
| literal: an href attribute | 33 | 13831.40 ± 0.6% | 1045.44 ± 0.2% | 26.71 ± 0.1% | 17093.71 ± 1.6% | 2263.99 ± 0.5% | 13.10 ± 0.8% | 75.10 ± 0.4% | 13765.12 ± 1.0% | 13.23 | 1.00 | 0.81 | 6.11 |
| literal: a word, second text | 123 | 16392.60 ± 0.9% | 1048.47 ± 0.3% | 27.39 ± 0.1% | 18195.69 ± 0.8% | 7706.50 ± 7.3% | 20.14 ± 0.3% | 70.26 ± 0.2% | 16413.15 ± 0.6% | 15.63 | 1.00 | 0.90 | 2.13 |
| class: two capitalized words | 1331 | 1101.64 ± 0.5% | 958.81 ± 0.1% | 25.50 ± 0.2% | 584.99 ± 0.1% | 40.67 ± 8.2% | 14.65 ± 0.3% | 68.86 ± 0.2% | 1101.90 ± 0.5% | 1.15 | 1.00 | 1.88 | 27.09 |
| class: a word that ends in ing | 3399 | 878.94 ± 0.1% | 880.29 ± 0.1% | 17.72 ± 0.3% | 547.01 ± 0.4% | 29.65 ± 5.9% | 8.13 ± 0.1% | 18.36 ± 0.4% | 878.14 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.64 |
| class: a word in capitals | 2332 | 1468.65 ± 0.5% | 944.88 ± 0.1% | 27.15 ± 0.1% | 572.60 ± 0.1% | 43.47 ± 2.3% | 17.07 ± 0.3% | 83.09 ± 0.6% | 1468.43 ± 0.3% | 1.55 | 1.00 | 2.56 | 33.79 |
| class: a number | 8288 | 2060.72 ± 0.2% | 791.80 ± 0.2% | 27.20 ± 0.2% | 1723.62 ± 0.2% | 42.43 ± 15.4% | 0.54 ± 0.1% | 56.53 ± 0.5% | 2061.45 ± 0.1% | 2.60 | 1.00 | 1.20 | 48.57 |
| class: two capitalized words, second text | 5359 | 688.71 ± 0.3% | 687.21 ± 0.0% | 22.85 ± 0.2% | 485.00 ± 0.1% | 34.23 ± 11.9% | 17.09 ± 0.8% | 63.95 ± 0.2% | 688.10 ± 0.1% | 1.00 | 1.00 | 1.42 | 20.12 |
| other: a word between two words | 6104 | 775.96 ± 0.1% | 742.31 ± 0.1% | 23.09 ± 0.1% | 736.94 ± 0.3% | 109.01 ± 15.2% | 11.14 ± 0.2% | 69.55 ± 0.2% | 778.28 ± 0.2% | 1.05 | 1.00 | 1.05 | 7.12 |
| other: a number before a unit, second text | 1481 | 5477.11 ± 0.4% | 978.11 ± 0.1% | 25.41 ± 0.1% | 5673.02 ± 0.4% | 40.86 ± 7.6% | 18.15 ± 0.3% | 66.77 ± 0.5% | 5450.75 ± 0.4% | 5.60 | 1.00 | 0.97 | 134.04 |
| other: a heading's start tag | 110 | 12689.58 ± 1.2% | 1030.41 ± 0.2% | 26.82 ± 0.2% | 1710.30 ± 0.6% | 1586.73 ± 3.8% | 15.94 ± 0.3% | 88.60 ± 0.4% | 12715.02 ± 1.1% | 12.32 | 1.00 | 7.42 | 8.00 |
| other: a whole word | 217 | 14005.42 ± 0.7% | 1039.58 ± 0.3% | 28.60 ± 0.3% | 14628.77 ± 1.5% | 49.41 ± 0.1% | 12.89 ± 0.1% | 55.55 ± 0.5% | 14016.58 ± 0.7% | 13.47 | 1.00 | 0.96 | 283.47 |
| other: a line's first word, second text | 3716 | 1948.96 ± 0.6% | 854.84 ± 0.2% | 30.05 ± 0.1% | 1725.47 ± 0.3% | 63.31 ± 7.2% | refused | refused | 1941.89 ± 0.4% | 2.28 | 1.00 | 1.13 | 30.78 |
| other: fourteen octets before an x | 87 | 19394.59 ± 2.1% | 233.93 ± 0.5% | 5.30 ± 0.1% | 4055.21 ± 0.3% | 10.65 ± 0.1% | differs | 17.77 ± 0.2% | 19505.90 ± 0.8% | 82.91 | 0.99 | 4.78 | 1820.49 |
| other: a Greek word | 21815 | 470.67 ± 0.2% | 315.91 ± 0.3% | 30.27 ± 0.2% | 289.09 ± 0.4% | 49.37 ± 10.5% | differs | refused | 468.98 ± 0.4% | 1.49 | 1.00 | 1.63 | 9.53 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.05 ± 0.1% | 26.07 ± 0.1% | 0.82 ± 0.2% | 19.80 ± 0.4% | 2.76 ± 0.5% | differs | 4.00 ± 0.3% | 26.03 ± 0.2% | 1.00 | 1.00 | 1.32 | 9.44 |
| a UUID | 32895 | 21.20 ± 0.5% | 21.33 ± 0.3% | 0.64 ± 0.2% | 15.07 ± 0.5% | 3.10 ± 0.8% | 0.73 ± 0.3% | 3.61 ± 0.3% | 21.33 ± 0.1% | 0.99 | 0.99 | 1.41 | 6.85 |
| an IPv4 address | 33176 | 36.90 ± 0.3% | 36.87 ± 0.1% | 2.08 ± 0.4% | 29.37 ± 0.2% | 6.65 ± 0.2% | differs | 4.12 ± 0.2% | 36.93 ± 0.1% | 1.00 | 1.00 | 1.26 | 5.55 |
| a date and time | 32954 | 31.18 ± 0.1% | 31.25 ± 0.3% | 1.45 ± 0.1% | 21.50 ± 0.5% | 7.04 ± 0.1% | 1.25 ± 0.2% | 7.15 ± 0.7% | 31.17 ± 0.2% | 1.00 | 1.00 | 1.45 | 4.43 |
| a field path | 32606 | 29.53 ± 0.1% | 29.47 ± 0.2% | 0.97 ± 0.1% | 23.12 ± 0.2% | 3.50 ± 0.4% | differs | 2.95 ± 0.3% | 29.59 ± 0.2% | 1.00 | 1.00 | 1.28 | 8.44 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.03 ± 0.3% | 9.05 ± 0.4% | 9.02 ± 0.3% | 11.57 ± 0.2% | 4.93 ± 2.8% | 0.93 ± 0.5% | none | 9.04 ± 0.2% | 1.00 | 1.00 | 0.78 | 1.83 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.01 ± 0.4% | 236.69 ± 0.4% | 288.22 ± 0.3% | 87.42 ± 0.2% | 219.67 ± 6.6% | 484.05 ± 0.3% | 3872.36 ± 2.5% | 235.07 ± 0.3% | 0.99 | 1.00 | 2.69 | 1.07 |
| a UUID | 62 | 157.59 ± 0.6% | 157.94 ± 0.4% | 179.37 ± 0.4% | 45.97 ± 0.4% | 98.54 ± 1.0% | 181.28 ± 0.7% | 4242.96 ± 0.6% | 157.45 ± 0.2% | 1.00 | 1.00 | 3.43 | 1.60 |
| an IPv4 address | 29 | 421.78 ± 0.4% | 425.61 ± 0.3% | 618.93 ± 0.5% | 77.29 ± 0.8% | 131.16 ± 10.2% | 288.85 ± 0.8% | 7562.92 ± 0.7% | 421.59 ± 0.4% | 0.99 | 1.00 | 5.46 | 3.22 |
| a date and time | 56 | 305.82 ± 0.3% | 307.25 ± 0.3% | 397.67 ± 0.2% | 72.78 ± 0.3% | 136.02 ± 2.0% | 317.27 ± 1.1% | 4848.74 ± 0.4% | 305.82 ± 0.2% | 1.00 | 1.00 | 4.20 | 2.25 |
| a field path | 39 | 227.15 ± 0.2% | 228.50 ± 0.2% | 275.31 ± 0.2% | 80.32 ± 0.5% | 205.23 ± 4.2% | 485.25 ± 0.9% | 4928.46 ± 4.9% | 227.09 ± 0.1% | 0.99 | 1.00 | 2.83 | 1.11 |
| literal: a word | 7 | 623.18 ± 0.5% | 666.52 ± 0.4% | 1275.16 ± 0.8% | 512.56 ± 1.7% | 632.52 ± 2.0% | 916.54 ± 0.5% | 29571.76 ± 0.0% | 622.45 ± 0.6% | 0.93 | 1.00 | 1.22 | 0.99 |
| literal: a word that is not there | 8 | 595.76 ± 0.4% | 645.62 ± 0.5% | 1197.13 ± 0.7% | 467.54 ± 0.2% | 604.64 ± 2.6% | 867.35 ± 1.3% | 28587.69 ± 0.1% | 594.77 ± 0.2% | 0.92 | 1.00 | 1.27 | 0.99 |
| literal: one of four words | 26 | 241.03 ± 0.2% | 398.81 ± 0.2% | 563.98 ± 0.5% | 49.69 ± 0.2% | 244.00 ± 3.0% | 353.52 ± 0.2% | 15467.24 ± 0.4% | 240.96 ± 0.2% | 0.60 | 1.00 | 4.85 | 0.99 |
| literal: a word in any case | 11 | 483.48 ± 0.4% | 516.76 ± 0.2% | 845.92 ± 0.3% | 15.81 ± 1.0% | 646.37 ± 1.1% | refused | 23426.23 ± 0.4% | 483.68 ± 0.2% | 0.94 | 1.00 | 30.58 | 0.75 |
| literal: an href attribute | 12 | 350.83 ± 0.3% | 362.21 ± 0.5% | 498.33 ± 0.4% | 9.45 ± 44.7% | 497.24 ± 0.8% | 753.84 ± 2.7% | 21471.57 ± 0.2% | 350.32 ± 0.2% | 0.97 | 1.00 | 37.12 | 0.71 |
| literal: a word, second text | 10 | 560.74 ± 0.7% | 614.22 ± 0.8% | 1088.18 ± 1.3% | 417.29 ± 0.4% | 534.21 ± 1.9% | 780.96 ± 0.3% | 26598.65 ± 0.3% | 560.59 ± 0.1% | 0.91 | 1.00 | 1.34 | 1.05 |
| class: two capitalized words | 23 | 433.63 ± 0.9% | 466.00 ± 0.7% | 707.73 ± 0.8% | 102.26 ± 0.1% | 498.47 ± 0.9% | 730.11 ± 0.6% | 6567.01 ± 0.3% | 434.78 ± 0.8% | 0.93 | 1.00 | 4.24 | 0.87 |
| class: a word that ends in ing | 9 | 556.02 ± 0.3% | 625.13 ± 0.3% | 1176.75 ± 0.2% | 133.07 ± 1.7% | 762.25 ± 0.7% | 1096.57 ± 2.1% | 16018.86 ± 0.4% | 555.92 ± 0.2% | 0.89 | 1.00 | 4.18 | 0.73 |
| class: a word in capitals | 16 | 490.72 ± 0.3% | 533.04 ± 0.3% | 914.55 ± 0.2% | 136.60 ± 1.5% | 758.38 ± 1.0% | 1029.20 ± 0.7% | 8613.45 ± 0.7% | 491.43 ± 0.2% | 0.92 | 1.00 | 3.59 | 0.65 |
| class: a number | 6 | 611.21 ± 0.8% | 680.89 ± 0.9% | 1388.62 ± 1.8% | 42.13 ± 1.3% | 1412.42 ± 0.7% | 1893.17 ± 0.4% | 22415.83 ± 0.1% | 610.86 ± 0.7% | 0.90 | 1.00 | 14.51 | 0.43 |
| class: two capitalized words, second text | 23 | 435.84 ± 0.2% | 467.32 ± 0.4% | 710.31 ± 0.5% | 102.85 ± 0.6% | 503.34 ± 1.3% | 761.25 ± 0.3% | 6563.13 ± 1.0% | 435.42 ± 0.4% | 0.93 | 1.00 | 4.24 | 0.87 |
| other: a word between two words | 13 | 550.73 ± 0.2% | 567.86 ± 0.4% | 957.06 ± 0.4% | 136.01 ± 0.6% | 503.65 ± 0.7% | 811.17 ± 0.8% | 14744.89 ± 0.4% | 550.32 ± 0.5% | 0.97 | 1.00 | 4.05 | 1.09 |
| other: a number before a unit, second text | 15 | 406.18 ± 0.5% | 446.94 ± 0.7% | 657.78 ± 0.3% | 39.56 ± 2.5% | 640.72 ± 0.9% | 880.53 ± 0.5% | 15110.14 ± 0.0% | 405.92 ± 0.4% | 0.91 | 1.00 | 10.27 | 0.63 |
| other: a heading's start tag | 13 | 360.12 ± 0.2% | 365.32 ± 0.6% | 501.77 ± 0.4% | 9.91 ± 15.3% | 631.25 ± 0.6% | 860.94 ± 0.4% | 17951.25 ± 0.4% | 359.82 ± 0.3% | 0.99 | 1.00 | 36.34 | 0.57 |
| other: a whole word | 11 | 579.41 ± 0.6% | 613.25 ± 1.2% | 1085.96 ± 1.1% | 121.82 ± 0.3% | 568.10 ± 1.1% | 809.55 ± 0.5% | 26672.40 ± 0.6% | 581.59 ± 0.4% | 0.94 | 1.00 | 4.76 | 1.02 |
| other: a line's first word, second text | 17 | 533.41 ± 0.4% | 549.97 ± 0.6% | 943.24 ± 0.4% | 130.61 ± 0.3% | 710.46 ± 1.0% | refused | refused | 531.76 ± 0.3% | 0.97 | 1.00 | 4.08 | 0.75 |
| other: fourteen octets before an x | 16 | 111.85 ± 0.3% | 160.70 ± 0.9% | 189.69 ± 1.0% | 6.80 ± 14.4% | 452.56 ± 0.7% | 407.68 ± 0.7% | 12442.79 ± 0.3% | 112.14 ± 0.4% | 0.70 | 1.00 | 16.46 | 0.25 |
| other: a Greek word | 8 | 423.70 ± 0.4% | 586.12 ± 0.5% | 1063.47 ± 0.9% | 10.70 ± 29.9% | 1389.44 ± 1.1% | 1811.59 ± 1.5% | refused | 423.79 ± 0.2% | 0.72 | 1.00 | 39.60 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12847.28 ± 1.1% | not timed | not timed | 16358.31 ± 0.5% | 2077.45 ± 15.6% | not timed | not timed | 12847.06 ± 1.0% | | 1.00 | 0.79 | 6.18 |
| 01-literal/sherlock-casei-en | 522 | 3935.39 ± 0.5% | not timed | not timed | 3582.63 ± 0.2% | 32.46 ± 0.5% | not timed | not timed | 3930.61 ± 0.2% | | 1.00 | 1.10 | 121.25 |
| 01-literal/sherlock-ru | 724 | 13568.46 ± 0.5% | not timed | not timed | 17223.89 ± 0.5% | 1557.56 ± 13.7% | not timed | not timed | 13552.99 ± 0.3% | | 1.00 | 0.79 | 8.71 |
| 01-literal/sherlock-casei-ru | 746 | 5396.89 ± 0.1% | not timed | not timed | 3328.77 ± 0.1% | 30.85 ± 0.4% | not timed | not timed | 5401.15 ± 0.1% | | 1.00 | 1.62 | 174.97 |
| 01-literal/sherlock-zh | 30 | 17112.08 ± 0.6% | not timed | not timed | 18667.23 ± 0.9% | 2809.64 ± 27.5% | not timed | not timed | 17079.16 ± 0.7% | | 1.00 | 0.92 | 6.09 |
| 02-literal-alternate/sherlock-en | 714 | 5902.37 ± 0.5% | not timed | not timed | 3933.10 ± 0.3% | 16.63 ± 0.1% | not timed | not timed | 5886.66 ± 0.5% | | 1.00 | 1.50 | 354.82 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1706.08 ± 0.4% | not timed | not timed | 698.24 ± 0.2% | 11.03 ± 0.2% | not timed | not timed | 1699.02 ± 0.3% | | 1.00 | 2.44 | 154.63 |
| 02-literal-alternate/sherlock-ru | 899 | 4797.05 ± 0.2% | not timed | not timed | 3259.70 ± 0.1% | 22.64 ± 0.1% | not timed | not timed | 4801.21 ± 0.2% | | 1.00 | 1.47 | 211.85 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1822.98 ± 0.3% | not timed | not timed | 1232.82 ± 0.2% | 9.10 ± 0.1% | not timed | not timed | 1815.18 ± 0.2% | | 1.00 | 1.48 | 200.26 |
| 02-literal-alternate/sherlock-zh | 207 | 7093.05 ± 0.6% | not timed | not timed | 4157.82 ± 0.2% | 31.52 ± 0.1% | not timed | not timed | 7079.30 ± 0.3% | | 1.00 | 1.71 | 225.05 |
| 03-date/ascii | 111817 | 123.93 ± 0.6% | not timed | not timed | 95.76 ± 0.1% | 0.20 ± 3.6% | not timed | not timed | 122.44 ± 0.2% | | 1.01 | 1.29 | 614.44 |
| 04-ruff-noqa/real | 84 | 551.47 ± 0.1% | not timed | not timed | 476.06 ± 0.1% | 19.54 ± 0.9% | not timed | not timed | 552.83 ± 0.2% | | 1.00 | 1.16 | 28.22 |
| 04-ruff-noqa/tweaked | 44 | 552.69 ± 0.2% | not timed | not timed | 466.27 ± 0.1% | 364.52 ± 0.4% | not timed | not timed | 552.83 ± 0.3% | | 1.00 | 1.19 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.52 ± 0.1% | not timed | not timed | 5.19 ± 0.1% | 0.21 ± 3.8% | not timed | not timed | 3.61 ± 2.9% | | 0.97 | 0.68 | 17.13 |
| 06-cloud-flare-redos/original | 107 | 183.78 ± 9.1% | not timed | not timed | 215.30 ± 2.0% | 24.59 ± 4.0% | not timed | not timed | 183.02 ± 4.5% | | 1.00 | 0.85 | 7.47 |
| 06-cloud-flare-redos/simplified-short | 102 | 143.79 ± 0.4% | not timed | not timed | 227.64 ± 0.2% | 26.47 ± 3.3% | not timed | not timed | 146.76 ± 1.7% | | 0.98 | 0.63 | 5.43 |
| 06-cloud-flare-redos/simplified-long | 10000 | 157.02 ± 2.0% | not timed | not timed | 255.04 ± 0.2% | 28.83 ± 0.3% | not timed | not timed | 156.83 ± 1.6% | | 1.00 | 0.62 | 5.45 |
| 07-unicode-character-data/parse-line | 558784 | 40.00 ± 0.3% | not timed | not timed | 179.34 ± 0.1% | 43.05 ± 1.7% | not timed | not timed | 39.88 ± 0.8% | | 1.00 | 0.22 | 0.93 |
| 08-words/all-english | 56691 | 103.17 ± 0.4% | not timed | not timed | 82.97 ± 0.2% | 11.58 ± 5.7% | not timed | not timed | 102.33 ± 0.3% | | 1.01 | 1.24 | 8.91 |
| 08-words/long-english | 839 | 997.54 ± 0.3% | not timed | not timed | 595.98 ± 0.1% | 32.62 ± 0.3% | not timed | not timed | 997.40 ± 0.1% | | 1.00 | 1.67 | 30.58 |
| 09-aws-keys/full | 0 | 421.54 ± 0.2% | not timed | not timed | 492.49 ± 0.0% | 64.64 ± 3.5% | not timed | not timed | 421.33 ± 0.1% | | 1.00 | 0.86 | 6.52 |
| 09-aws-keys/quick | 0 | 413.89 ± 0.1% | not timed | not timed | 996.02 ± 0.2% | 421.41 ± 2.0% | not timed | not timed | 410.07 ± 0.1% | | 1.01 | 0.42 | 0.98 |
| 10-bounded-repeat/letters-en | 1833 | 592.63 ± 0.3% | not timed | not timed | 515.88 ± 0.2% | 19.58 ± 0.5% | not timed | not timed | 590.85 ± 0.1% | | 1.00 | 1.15 | 30.26 |
| 10-bounded-repeat/letters-ru | 3475 | 404.40 ± 0.1% | not timed | not timed | 478.89 ± 0.5% | 21.91 ± 19.2% | not timed | not timed | 403.08 ± 0.8% | | 1.00 | 0.84 | 18.46 |
| 10-bounded-repeat/context | 53 | 73.36 ± 1.1% | not timed | not timed | 65.95 ± 0.6% | 19.38 ± 0.1% | not timed | not timed | 73.43 ± 1.1% | | 1.00 | 1.11 | 3.79 |
| 10-bounded-repeat/capitals | 11 | 1039.63 ± 0.1% | not timed | not timed | 616.64 ± 0.1% | 35.58 ± 0.2% | not timed | not timed | 1038.67 ± 0.2% | | 1.00 | 1.69 | 29.22 |
| 11-unstructured-to-json/extract | 600 | 24.58 ± 0.1% | not timed | not timed | 76.69 ± 0.3% | 48.81 ± 1.3% | not timed | not timed | 24.46 ± 0.4% | | 1.00 | 0.32 | 0.50 |
| 12-dictionary/single | 1 | 600.51 ± 0.4% | not timed | not timed | 563.01 ± 0.5% | 0.41 ± 0.3% | not timed | not timed | 601.89 ± 0.2% | | 1.00 | 1.07 | 1470.84 |
| 14-quadratic/1x | 100 | 12.64 ± 0.5% | not timed | not timed | 10.02 ± 0.1% | 0.96 ± 3.6% | not timed | not timed | 12.61 ± 1.6% | | 1.00 | 1.26 | 13.15 |
| 14-quadratic/2x | 200 | 7.80 ± 0.9% | not timed | not timed | 5.55 ± 0.2% | 0.53 ± 1.6% | not timed | not timed | 7.78 ± 1.3% | | 1.00 | 1.41 | 14.72 |
| 14-quadratic/10x | 1000 | 1.83 ± 0.8% | not timed | not timed | 1.21 ± 0.1% | 0.11 ± 1.4% | not timed | not timed | 1.82 ± 1.0% | | 1.00 | 1.51 | 15.99 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.44 ± 0.3% | not timed | not timed | 0.34 ± 0.4% | 0.55 ± 9.3% | not timed | not timed | 1.44 ± 1.5% | | 1.01 | 4.20 | 2.64 |
| 04-ruff-noqa/compile-real | 1 | 92.60 ± 0.1% | not timed | not timed | 13.98 ± 0.2% | 141.69 ± 2.3% | not timed | not timed | 92.61 ± 2.0% | | 1.00 | 6.63 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 14.58 ± 0.4% | not timed | not timed | 2.55 ± 1.0% | 6.51 ± 2.2% | not timed | not timed | 14.56 ± 0.5% | | 1.00 | 5.71 | 2.24 |
| 07-unicode-character-data/compile | 1 | 58.47 ± 0.4% | not timed | not timed | 26.18 ± 0.3% | 36.71 ± 4.1% | not timed | not timed | 58.58 ± 0.2% | | 1.00 | 2.23 | 1.59 |
| 09-aws-keys/compile-full | 1 | 43.66 ± 1.3% | not timed | not timed | 8.35 ± 0.1% | 23.58 ± 1.5% | not timed | not timed | 43.49 ± 0.2% | | 1.00 | 5.23 | 1.85 |
| 09-aws-keys/compile-quick | 1 | 187.82 ± 0.3% | not timed | not timed | 48.10 ± 1.0% | 135.69 ± 1.5% | not timed | not timed | 188.49 ± 0.4% | | 1.00 | 3.90 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 14.58 ± 1.1% | not timed | not timed | 11.16 ± 0.2% | 16.37 ± 2.0% | not timed | not timed | 14.47 ± 1.2% | | 1.01 | 1.31 | 0.89 |
| 10-bounded-repeat/compile-capitals | 1 | 85.25 ± 0.3% | not timed | not timed | 8.04 ± 0.2% | 24.25 ± 2.5% | not timed | not timed | 84.98 ± 1.2% | | 1.00 | 10.60 | 3.52 |
| 11-unstructured-to-json/compile | 1 | 90.87 ± 0.1% | not timed | not timed | 40.37 ± 0.6% | 69.63 ± 2.8% | not timed | not timed | 90.55 ± 0.9% | | 1.00 | 2.25 | 1.31 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.4% | not timed | not timed | 0.07 ± 0.8% | 0.09 ± 19.0% | not timed | not timed | 0.36 ± 0.4% | | 1.00 | 5.22 | 3.91 |

