# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159297919 |
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
| literal: a word | 217 | 16015.19 ± 1.0% | 1049.27 ± 0.1% | 27.86 ± 0.2% | 18310.59 ± 1.8% | 9156.70 ± 8.4% | 17.37 ± 0.8% | 87.18 ± 0.1% | 16032.19 ± 1.5% | 15.26 | 1.00 | 0.87 | 1.75 |
| literal: a word that is not there | 0 | 18725.65 ± 1.5% | 1057.04 ± 0.2% | 27.86 ± 0.2% | 20002.04 ± 2.1% | 29191.85 ± 1.4% | 17.17 ± 0.1% | 83.02 ± 0.2% | 18838.06 ± 1.1% | 17.72 | 0.99 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6074.36 ± 0.3% | 1031.50 ± 0.1% | 14.54 ± 0.2% | 3948.81 ± 0.2% | 21.87 ± 0.1% | 5.24 ± 0.4% | 6.91 ± 0.3% | 6060.71 ± 0.3% | 5.89 | 1.00 | 1.54 | 277.80 |
| literal: a word in any case | 217 | 12601.16 ± 0.5% | 1048.91 ± 0.1% | 21.42 ± 0.4% | 3972.41 ± 0.2% | 38.06 ± 1.0% | refused | differs | 12570.64 ± 0.8% | 12.01 | 1.00 | 3.17 | 331.10 |
| literal: an href attribute | 33 | 13569.94 ± 0.4% | 1054.26 ± 0.2% | 26.88 ± 0.2% | 16941.75 ± 0.4% | 2256.23 ± 0.7% | 13.30 ± 0.3% | 76.04 ± 0.2% | 13526.27 ± 0.5% | 12.87 | 1.00 | 0.80 | 6.01 |
| literal: a word, second text | 123 | 16366.50 ± 1.3% | 1051.77 ± 0.3% | 27.62 ± 0.5% | 18539.52 ± 1.8% | 7894.67 ± 5.5% | 19.69 ± 0.6% | 71.21 ± 0.6% | 16368.72 ± 1.6% | 15.56 | 1.00 | 0.88 | 2.07 |
| class: two capitalized words | 1331 | 1124.28 ± 0.5% | 978.81 ± 0.1% | 25.67 ± 0.3% | 585.73 ± 0.1% | 40.54 ± 2.8% | 14.72 ± 0.2% | 68.99 ± 0.3% | 1122.62 ± 0.3% | 1.15 | 1.00 | 1.92 | 27.73 |
| class: a word that ends in ing | 3399 | 901.93 ± 0.1% | 902.06 ± 0.1% | 17.93 ± 0.1% | 547.69 ± 0.2% | 29.57 ± 10.3% | 8.17 ± 0.2% | 18.30 ± 0.9% | 900.28 ± 0.6% | 1.00 | 1.00 | 1.65 | 30.50 |
| class: a word in capitals | 2332 | 1460.20 ± 0.8% | 955.60 ± 0.1% | 27.26 ± 0.1% | 572.67 ± 0.0% | 43.47 ± 3.7% | 17.08 ± 0.3% | 83.02 ± 0.6% | 1460.40 ± 0.1% | 1.53 | 1.00 | 2.55 | 33.59 |
| class: a number | 8288 | 2015.56 ± 0.4% | 839.93 ± 0.1% | 27.34 ± 0.3% | 1721.72 ± 0.1% | 38.63 ± 14.7% | 0.55 ± 0.2% | 56.57 ± 0.4% | 2009.60 ± 0.2% | 2.40 | 1.00 | 1.17 | 52.18 |
| class: two capitalized words, second text | 5359 | 744.62 ± 0.1% | 745.41 ± 0.1% | 23.04 ± 0.2% | 485.63 ± 0.1% | 35.31 ± 8.2% | 16.69 ± 0.2% | 64.09 ± 0.2% | 743.78 ± 0.2% | 1.00 | 1.00 | 1.53 | 21.09 |
| other: a word between two words | 6104 | 752.16 ± 0.1% | 780.73 ± 0.1% | 23.21 ± 0.2% | 738.71 ± 0.3% | 109.12 ± 19.8% | 11.27 ± 0.2% | 70.14 ± 0.4% | 753.21 ± 0.1% | 0.96 | 1.00 | 1.02 | 6.89 |
| other: a number before a unit, second text | 1481 | 5418.88 ± 0.7% | 991.49 ± 0.2% | 25.55 ± 0.1% | 5682.98 ± 0.4% | 40.73 ± 0.1% | 17.82 ± 0.2% | 67.06 ± 0.6% | 5398.90 ± 0.3% | 5.47 | 1.00 | 0.95 | 133.06 |
| other: a heading's start tag | 110 | 12578.50 ± 0.7% | 1045.08 ± 0.1% | 27.07 ± 0.3% | 1710.35 ± 0.6% | 1577.57 ± 3.7% | 16.15 ± 0.3% | 88.96 ± 0.4% | 12546.38 ± 0.4% | 12.04 | 1.00 | 7.35 | 7.97 |
| other: a whole word | 217 | 13995.27 ± 1.8% | 1045.93 ± 0.2% | 28.90 ± 0.4% | 14535.51 ± 0.4% | 49.46 ± 0.3% | 13.62 ± 0.2% | 56.07 ± 0.3% | 13950.22 ± 0.6% | 13.38 | 1.00 | 0.96 | 282.94 |
| other: a line's first word, second text | 3716 | 1970.25 ± 0.4% | 879.32 ± 0.2% | 30.33 ± 0.2% | 1724.30 ± 0.5% | 62.26 ± 8.5% | refused | refused | 1960.62 ± 0.8% | 2.24 | 1.00 | 1.14 | 31.64 |
| other: fourteen octets before an x | 87 | 19835.75 ± 3.4% | 238.12 ± 0.7% | 6.62 ± 0.2% | 4052.12 ± 0.4% | 10.65 ± 0.1% | differs | 17.80 ± 0.1% | 19733.69 ± 1.0% | 83.30 | 1.01 | 4.90 | 1862.40 |
| other: a Greek word | 21815 | 512.64 ± 0.5% | 410.87 ± 0.3% | 31.05 ± 1.4% | 289.05 ± 0.3% | 49.46 ± 9.4% | differs | refused | 510.98 ± 0.3% | 1.25 | 1.00 | 1.77 | 10.36 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.87 ± 0.2% | 25.90 ± 0.1% | 0.88 ± 0.3% | 19.78 ± 0.3% | 2.76 ± 1.4% | differs | 4.01 ± 0.2% | 25.87 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.37 |
| a UUID | 32895 | 21.11 ± 0.2% | 21.15 ± 0.3% | 0.65 ± 0.2% | 15.20 ± 0.3% | 3.11 ± 0.6% | 0.72 ± 0.4% | 3.60 ± 0.5% | 21.18 ± 0.2% | 1.00 | 1.00 | 1.39 | 6.79 |
| an IPv4 address | 33176 | 36.84 ± 0.3% | 36.76 ± 0.2% | 2.12 ± 0.2% | 28.98 ± 0.2% | 6.63 ± 0.2% | differs | 4.14 ± 0.5% | 36.85 ± 0.2% | 1.00 | 1.00 | 1.27 | 5.56 |
| a date and time | 32954 | 30.95 ± 0.4% | 31.10 ± 0.6% | 1.47 ± 0.3% | 21.19 ± 0.2% | 7.04 ± 0.2% | 1.19 ± 0.3% | 7.09 ± 0.5% | 31.00 ± 0.1% | 1.00 | 1.00 | 1.46 | 4.39 |
| a field path | 32606 | 29.45 ± 0.2% | 29.42 ± 0.3% | 1.04 ± 0.1% | 23.06 ± 0.1% | 3.49 ± 0.7% | differs | 2.95 ± 0.2% | 29.44 ± 0.3% | 1.00 | 1.00 | 1.28 | 8.44 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.47 ± 0.7% | 11.55 ± 1.0% | 11.55 ± 0.3% | 11.44 ± 0.2% | 4.93 ± 1.1% | 0.91 ± 0.6% | none | 11.53 ± 0.8% | 0.99 | 0.99 | 1.00 | 2.32 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.48 ± 0.3% | 221.93 ± 0.3% | 258.00 ± 0.1% | 86.17 ± 0.5% | 220.68 ± 1.2% | 480.67 ± 1.4% | 3883.92 ± 3.3% | 221.41 ± 0.1% | 1.00 | 1.00 | 2.57 | 1.00 |
| a UUID | 62 | 145.32 ± 0.2% | 145.69 ± 0.2% | 161.05 ± 0.2% | 46.14 ± 0.5% | 99.22 ± 12.6% | 189.18 ± 2.8% | 4460.77 ± 0.7% | 145.30 ± 0.2% | 1.00 | 1.00 | 3.15 | 1.46 |
| an IPv4 address | 29 | 437.13 ± 0.6% | 440.28 ± 0.7% | 610.29 ± 0.4% | 76.16 ± 0.3% | 131.46 ± 0.9% | 300.29 ± 1.5% | 7662.25 ± 0.1% | 435.86 ± 0.5% | 0.99 | 1.00 | 5.74 | 3.33 |
| a date and time | 56 | 319.45 ± 0.2% | 320.90 ± 0.2% | 402.20 ± 0.2% | 72.39 ± 0.4% | 136.77 ± 1.6% | 324.25 ± 1.5% | 4939.34 ± 0.6% | 319.44 ± 0.2% | 1.00 | 1.00 | 4.41 | 2.34 |
| a field path | 39 | 208.55 ± 0.2% | 209.07 ± 0.2% | 241.04 ± 0.4% | 80.16 ± 1.0% | 206.45 ± 0.4% | 499.43 ± 3.1% | 4971.56 ± 7.9% | 208.42 ± 0.2% | 1.00 | 1.00 | 2.60 | 1.01 |
| literal: a word | 7 | 659.71 ± 0.3% | 709.20 ± 0.2% | 1254.27 ± 0.3% | 513.71 ± 0.2% | 627.66 ± 8.8% | 954.36 ± 0.3% | 30735.43 ± 0.3% | 659.60 ± 0.2% | 0.93 | 1.00 | 1.28 | 1.05 |
| literal: a word that is not there | 8 | 632.83 ± 0.3% | 684.72 ± 0.5% | 1170.71 ± 0.7% | 470.06 ± 0.4% | 604.21 ± 1.4% | 901.55 ± 0.4% | 29721.34 ± 0.1% | 632.55 ± 0.5% | 0.92 | 1.00 | 1.35 | 1.05 |
| literal: one of four words | 26 | 254.31 ± 0.4% | 414.16 ± 0.9% | 557.97 ± 0.6% | 49.90 ± 0.9% | 242.83 ± 2.8% | 372.48 ± 1.1% | 15874.60 ± 0.3% | 253.65 ± 0.3% | 0.61 | 1.00 | 5.10 | 1.05 |
| literal: a word in any case | 11 | 515.70 ± 0.4% | 554.92 ± 0.2% | 859.52 ± 0.6% | 15.78 ± 1.8% | 660.56 ± 11.9% | refused | 23908.48 ± 0.3% | 516.07 ± 0.2% | 0.93 | 1.00 | 32.69 | 0.78 |
| literal: an href attribute | 12 | 348.49 ± 0.2% | 359.74 ± 0.4% | 466.46 ± 0.3% | 45.44 ± 0.5% | 500.99 ± 1.3% | 771.93 ± 1.1% | 22494.87 ± 0.3% | 348.31 ± 0.6% | 0.97 | 1.00 | 7.67 | 0.70 |
| literal: a word, second text | 10 | 586.64 ± 0.5% | 644.42 ± 0.3% | 1069.33 ± 0.2% | 394.32 ± 0.4% | 544.98 ± 1.6% | 796.85 ± 0.7% | 27799.62 ± 0.1% | 586.68 ± 0.3% | 0.91 | 1.00 | 1.49 | 1.08 |
| class: two capitalized words | 23 | 457.99 ± 0.6% | 486.06 ± 0.4% | 701.36 ± 0.3% | 98.91 ± 0.1% | 508.01 ± 5.9% | 747.49 ± 0.2% | 6651.32 ± 0.2% | 458.54 ± 0.6% | 0.94 | 1.00 | 4.63 | 0.90 |
| class: a word that ends in ing | 9 | 592.55 ± 0.3% | 658.38 ± 0.4% | 1154.20 ± 0.4% | 131.24 ± 1.9% | 759.60 ± 7.7% | 1105.91 ± 0.2% | 16328.63 ± 0.3% | 591.74 ± 0.3% | 0.90 | 1.00 | 4.51 | 0.78 |
| class: a word in capitals | 16 | 522.14 ± 0.3% | 562.31 ± 0.2% | 896.97 ± 0.5% | 133.90 ± 0.8% | 753.59 ± 1.4% | 1023.86 ± 0.6% | 8725.59 ± 0.2% | 523.02 ± 0.7% | 0.93 | 1.00 | 3.90 | 0.69 |
| class: a number | 6 | 656.51 ± 0.2% | 717.57 ± 0.6% | 1338.79 ± 0.2% | 41.71 ± 0.4% | 1401.63 ± 1.2% | 1859.35 ± 1.1% | 23338.94 ± 0.1% | 656.66 ± 0.3% | 0.91 | 1.00 | 15.74 | 0.47 |
| class: two capitalized words, second text | 23 | 457.45 ± 0.6% | 486.45 ± 0.3% | 702.58 ± 0.4% | 100.53 ± 0.5% | 496.59 ± 1.8% | 766.21 ± 0.3% | 6652.05 ± 0.6% | 457.63 ± 0.5% | 0.94 | 1.00 | 4.55 | 0.92 |
| other: a word between two words | 13 | 572.77 ± 1.0% | 590.87 ± 0.6% | 934.57 ± 0.2% | 132.31 ± 0.8% | 505.22 ± 3.7% | 808.13 ± 0.8% | 15108.68 ± 0.9% | 572.45 ± 0.1% | 0.97 | 1.00 | 4.33 | 1.13 |
| other: a number before a unit, second text | 15 | 401.39 ± 0.4% | 436.40 ± 0.2% | 601.78 ± 0.1% | 39.38 ± 0.4% | 636.73 ± 0.7% | 891.51 ± 1.1% | 15400.79 ± 0.2% | 401.69 ± 0.2% | 0.92 | 1.00 | 10.19 | 0.63 |
| other: a heading's start tag | 13 | 360.50 ± 0.8% | 364.35 ± 0.6% | 475.53 ± 0.5% | 43.73 ± 0.4% | 631.80 ± 0.6% | 875.64 ± 0.4% | 18604.81 ± 0.3% | 360.57 ± 0.3% | 0.99 | 1.00 | 8.24 | 0.57 |
| other: a whole word | 11 | 606.18 ± 0.6% | 644.52 ± 0.4% | 1069.12 ± 0.1% | 117.66 ± 0.5% | 568.11 ± 1.6% | 835.17 ± 0.6% | 27225.13 ± 1.0% | 607.06 ± 0.5% | 0.94 | 1.00 | 5.15 | 1.07 |
| other: a line's first word, second text | 17 | 553.52 ± 0.3% | 574.97 ± 0.4% | 923.33 ± 0.1% | 128.00 ± 0.0% | 712.60 ± 1.4% | refused | refused | 551.69 ± 0.8% | 0.96 | 1.00 | 4.32 | 0.78 |
| other: fourteen octets before an x | 16 | 112.85 ± 0.4% | 163.25 ± 0.7% | 186.51 ± 0.6% | 15.01 ± 0.2% | 455.19 ± 4.0% | 412.42 ± 0.4% | 12874.92 ± 0.3% | 112.87 ± 0.6% | 0.69 | 1.00 | 7.52 | 0.25 |
| other: a Greek word | 8 | 447.03 ± 0.3% | 585.62 ± 0.2% | 950.81 ± 0.1% | 58.85 ± 0.3% | 1392.31 ± 6.6% | 1788.09 ± 0.4% | refused | 446.91 ± 0.3% | 0.76 | 1.00 | 7.60 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12908.95 ± 0.7% | not timed | not timed | 16260.83 ± 0.7% | 2135.17 ± 25.4% | not timed | not timed | 12889.19 ± 1.3% | | 1.00 | 0.79 | 6.05 |
| 01-literal/sherlock-casei-en | 522 | 4474.31 ± 1.9% | not timed | not timed | 3588.42 ± 0.2% | 32.53 ± 0.5% | not timed | not timed | 4471.73 ± 0.4% | | 1.00 | 1.25 | 137.54 |
| 01-literal/sherlock-ru | 724 | 13516.30 ± 0.4% | not timed | not timed | 17313.39 ± 0.2% | 1452.61 ± 16.7% | not timed | not timed | 13513.16 ± 0.5% | | 1.00 | 0.78 | 9.30 |
| 01-literal/sherlock-casei-ru | 746 | 5281.28 ± 2.1% | not timed | not timed | 3329.40 ± 0.8% | 31.70 ± 0.1% | not timed | not timed | 5290.97 ± 1.0% | | 1.00 | 1.59 | 166.60 |
| 01-literal/sherlock-zh | 30 | 17053.05 ± 0.5% | not timed | not timed | 18682.24 ± 1.0% | 2795.48 ± 16.6% | not timed | not timed | 17030.14 ± 0.2% | | 1.00 | 0.91 | 6.10 |
| 02-literal-alternate/sherlock-en | 714 | 5756.19 ± 0.6% | not timed | not timed | 3935.24 ± 0.3% | 16.61 ± 0.1% | not timed | not timed | 5765.30 ± 0.3% | | 1.00 | 1.46 | 346.62 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1707.23 ± 1.0% | not timed | not timed | 697.05 ± 0.2% | 11.10 ± 7.2% | not timed | not timed | 1697.57 ± 1.3% | | 1.01 | 2.45 | 153.78 |
| 02-literal-alternate/sherlock-ru | 899 | 4643.33 ± 0.1% | not timed | not timed | 3255.44 ± 0.1% | 22.58 ± 0.2% | not timed | not timed | 4644.32 ± 0.1% | | 1.00 | 1.43 | 205.68 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1808.25 ± 0.6% | not timed | not timed | 1229.20 ± 0.4% | 9.15 ± 0.2% | not timed | not timed | 1798.94 ± 0.2% | | 1.01 | 1.47 | 197.72 |
| 02-literal-alternate/sherlock-zh | 207 | 7055.58 ± 0.3% | not timed | not timed | 4165.45 ± 0.1% | 31.50 ± 0.1% | not timed | not timed | 7064.31 ± 0.2% | | 1.00 | 1.69 | 223.95 |
| 03-date/ascii | 111817 | 126.97 ± 0.5% | not timed | not timed | 95.55 ± 0.1% | 0.20 ± 3.6% | not timed | not timed | 126.17 ± 0.5% | | 1.01 | 1.33 | 635.86 |
| 04-ruff-noqa/real | 84 | 555.84 ± 0.6% | not timed | not timed | 461.55 ± 0.2% | 19.58 ± 1.3% | not timed | not timed | 556.24 ± 0.1% | | 1.00 | 1.20 | 28.39 |
| 04-ruff-noqa/tweaked | 44 | 541.22 ± 0.1% | not timed | not timed | 460.30 ± 0.1% | 368.06 ± 0.6% | not timed | not timed | 539.97 ± 0.2% | | 1.00 | 1.18 | 1.47 |
| 05-lexer-veryl/single | 124800 | 3.98 ± 0.6% | not timed | not timed | 5.07 ± 0.2% | 0.21 ± 3.8% | not timed | not timed | 4.17 ± 2.0% | | 0.96 | 0.79 | 19.34 |
| 06-cloud-flare-redos/original | 107 | 260.08 ± 1.7% | not timed | not timed | 217.72 ± 0.3% | 24.91 ± 0.2% | not timed | not timed | 259.42 ± 0.3% | | 1.00 | 1.19 | 10.44 |
| 06-cloud-flare-redos/simplified-short | 102 | 254.98 ± 0.3% | not timed | not timed | 229.01 ± 0.1% | 26.77 ± 0.3% | not timed | not timed | 255.08 ± 0.1% | | 1.00 | 1.11 | 9.53 |
| 06-cloud-flare-redos/simplified-long | 10000 | 291.34 ± 0.2% | not timed | not timed | 233.84 ± 18.6% | 28.84 ± 0.1% | not timed | not timed | 292.01 ± 0.1% | | 1.00 | 1.25 | 10.10 |
| 07-unicode-character-data/parse-line | 558784 | 239.71 ± 0.2% | not timed | not timed | 172.82 ± 0.1% | 42.80 ± 5.3% | not timed | not timed | 240.30 ± 2.4% | | 1.00 | 1.39 | 5.60 |
| 08-words/all-english | 56691 | 121.75 ± 0.7% | not timed | not timed | 82.85 ± 0.7% | 11.83 ± 14.9% | not timed | not timed | 121.22 ± 0.3% | | 1.00 | 1.47 | 10.29 |
| 08-words/long-english | 839 | 1012.49 ± 0.0% | not timed | not timed | 597.83 ± 0.1% | 32.50 ± 0.6% | not timed | not timed | 1011.68 ± 0.0% | | 1.00 | 1.69 | 31.16 |
| 09-aws-keys/full | 0 | 409.39 ± 0.1% | not timed | not timed | 461.28 ± 0.1% | 64.61 ± 0.2% | not timed | not timed | 408.46 ± 0.1% | | 1.00 | 0.89 | 6.34 |
| 09-aws-keys/quick | 0 | 739.50 ± 0.1% | not timed | not timed | 991.53 ± 0.1% | 418.07 ± 1.3% | not timed | not timed | 737.06 ± 0.0% | | 1.00 | 0.75 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 636.91 ± 0.4% | not timed | not timed | 516.49 ± 0.8% | 19.54 ± 0.9% | not timed | not timed | 637.12 ± 0.2% | | 1.00 | 1.23 | 32.60 |
| 10-bounded-repeat/letters-ru | 3475 | 382.76 ± 0.3% | not timed | not timed | 478.76 ± 0.1% | 21.95 ± 8.4% | not timed | not timed | 380.12 ± 0.6% | | 1.01 | 0.80 | 17.43 |
| 10-bounded-repeat/context | 53 | 79.60 ± 1.8% | not timed | not timed | 65.72 ± 2.6% | 19.82 ± 0.2% | not timed | not timed | 79.77 ± 1.1% | | 1.00 | 1.21 | 4.02 |
| 10-bounded-repeat/capitals | 11 | 1055.31 ± 0.3% | not timed | not timed | 618.27 ± 0.2% | 36.52 ± 0.2% | not timed | not timed | 1054.91 ± 0.3% | | 1.00 | 1.71 | 28.89 |
| 11-unstructured-to-json/extract | 600 | 49.84 ± 0.1% | not timed | not timed | 77.68 ± 0.3% | 49.06 ± 0.9% | not timed | not timed | 49.54 ± 0.9% | | 1.01 | 0.64 | 1.02 |
| 12-dictionary/single | 1 | 567.56 ± 0.5% | not timed | not timed | 562.69 ± 0.2% | 0.41 ± 0.1% | not timed | not timed | 568.31 ± 0.4% | | 1.00 | 1.01 | 1386.69 |
| 14-quadratic/1x | 100 | 12.84 ± 0.3% | not timed | not timed | 10.05 ± 0.1% | 0.98 ± 3.8% | not timed | not timed | 12.78 ± 1.5% | | 1.01 | 1.28 | 13.14 |
| 14-quadratic/2x | 200 | 7.96 ± 0.3% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 1.5% | not timed | not timed | 7.92 ± 0.6% | | 1.00 | 1.44 | 14.96 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.9% | not timed | not timed | 1.88 ± 0.2% | | 1.00 | 1.55 | 16.27 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.55 ± 1.3% | not timed | not timed | 0.34 ± 0.6% | 0.54 ± 3.1% | not timed | not timed | 1.54 ± 1.2% | | 1.01 | 4.52 | 2.86 |
| 04-ruff-noqa/compile-real | 1 | 86.96 ± 0.3% | not timed | not timed | 13.93 ± 0.3% | 134.36 ± 1.9% | not timed | not timed | 86.75 ± 1.1% | | 1.00 | 6.24 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 14.28 ± 0.2% | not timed | not timed | 2.51 ± 0.6% | 6.27 ± 3.2% | not timed | not timed | 14.16 ± 1.4% | | 1.01 | 5.68 | 2.28 |
| 07-unicode-character-data/compile | 1 | 55.29 ± 0.1% | not timed | not timed | 26.20 ± 0.3% | 35.42 ± 3.6% | not timed | not timed | 54.84 ± 1.2% | | 1.01 | 2.11 | 1.56 |
| 09-aws-keys/compile-full | 1 | 42.35 ± 0.6% | not timed | not timed | 8.31 ± 0.4% | 22.94 ± 2.2% | not timed | not timed | 42.15 ± 0.8% | | 1.00 | 5.10 | 1.85 |
| 09-aws-keys/compile-quick | 1 | 189.48 ± 0.3% | not timed | not timed | 47.76 ± 0.1% | 131.92 ± 4.2% | not timed | not timed | 188.79 ± 1.1% | | 1.00 | 3.97 | 1.44 |
| 10-bounded-repeat/compile-context | 1 | 14.68 ± 0.6% | not timed | not timed | 11.16 ± 0.4% | 15.92 ± 2.7% | not timed | not timed | 14.58 ± 1.8% | | 1.01 | 1.32 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 85.17 ± 0.2% | not timed | not timed | 8.13 ± 0.2% | 23.38 ± 1.2% | not timed | not timed | 84.75 ± 0.6% | | 1.00 | 10.47 | 3.64 |
| 11-unstructured-to-json/compile | 1 | 86.68 ± 1.5% | not timed | not timed | 40.06 ± 0.6% | 67.16 ± 1.8% | not timed | not timed | 85.57 ± 0.7% | | 1.01 | 2.16 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 2.2% | 0.09 ± 17.5% | not timed | not timed | 0.35 ± 1.5% | | 1.01 | 5.28 | 3.81 |

