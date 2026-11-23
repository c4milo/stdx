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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159278988 |
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
| literal: a word | 217 | 15895.70 ± 1.0% | 1049.14 ± 0.2% | 27.90 ± 0.4% | 17930.69 ± 1.9% | 9128.16 ± 7.8% | 17.33 ± 0.5% | 87.17 ± 0.1% | 15946.72 ± 0.9% | 15.15 | 1.00 | 0.89 | 1.74 |
| literal: a word that is not there | 0 | 18573.92 ± 1.6% | 1056.19 ± 0.4% | 27.87 ± 0.4% | 19516.75 ± 1.6% | 28589.97 ± 1.0% | 17.19 ± 0.1% | 82.99 ± 0.0% | 18594.05 ± 0.9% | 17.59 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6063.33 ± 0.7% | 1030.86 ± 0.1% | 14.52 ± 0.3% | 3942.00 ± 0.2% | 21.86 ± 0.0% | 5.25 ± 2.8% | 6.90 ± 0.6% | 6059.37 ± 0.3% | 5.88 | 1.00 | 1.54 | 277.42 |
| literal: a word in any case | 217 | 12568.36 ± 0.5% | 1047.81 ± 0.2% | 21.45 ± 0.2% | 3972.00 ± 0.6% | 38.09 ± 0.3% | refused | differs | 12553.03 ± 0.4% | 11.99 | 1.00 | 3.16 | 329.94 |
| literal: an href attribute | 33 | 13513.56 ± 0.9% | 1054.61 ± 0.2% | 26.91 ± 0.3% | 17022.72 ± 1.3% | 2252.53 ± 0.8% | 13.18 ± 5.0% | 76.05 ± 0.3% | 13511.47 ± 0.8% | 12.81 | 1.00 | 0.79 | 6.00 |
| literal: a word, second text | 123 | 16499.24 ± 1.9% | 1050.93 ± 0.5% | 27.63 ± 0.2% | 18431.42 ± 0.6% | 7974.02 ± 5.4% | 19.68 ± 0.5% | 71.37 ± 0.4% | 16504.06 ± 0.8% | 15.70 | 1.00 | 0.90 | 2.07 |
| class: two capitalized words | 1331 | 1123.34 ± 0.7% | 979.06 ± 0.1% | 25.68 ± 0.1% | 585.10 ± 0.1% | 40.59 ± 7.4% | 14.72 ± 0.5% | 68.95 ± 0.1% | 1122.59 ± 0.3% | 1.15 | 1.00 | 1.92 | 27.67 |
| class: a word that ends in ing | 3399 | 901.69 ± 0.2% | 901.39 ± 0.0% | 17.92 ± 0.2% | 547.63 ± 0.1% | 29.63 ± 2.7% | 8.17 ± 0.2% | 18.40 ± 0.2% | 900.18 ± 0.2% | 1.00 | 1.00 | 1.65 | 30.44 |
| class: a word in capitals | 2332 | 1455.80 ± 0.5% | 955.50 ± 0.4% | 27.36 ± 0.3% | 572.10 ± 0.1% | 43.47 ± 13.6% | 17.09 ± 0.4% | 82.90 ± 0.5% | 1454.09 ± 0.6% | 1.52 | 1.00 | 2.54 | 33.49 |
| class: a number | 8288 | 2012.78 ± 0.2% | 839.27 ± 0.1% | 27.35 ± 0.3% | 1720.66 ± 0.1% | 38.73 ± 14.9% | 0.53 ± 0.8% | 56.53 ± 0.3% | 2008.02 ± 0.1% | 2.40 | 1.00 | 1.17 | 51.98 |
| class: two capitalized words, second text | 5359 | 744.17 ± 0.2% | 744.65 ± 0.2% | 23.05 ± 0.1% | 485.49 ± 0.1% | 35.32 ± 15.1% | 16.70 ± 0.4% | 63.92 ± 1.0% | 743.05 ± 0.2% | 1.00 | 1.00 | 1.53 | 21.07 |
| other: a word between two words | 6104 | 751.63 ± 0.2% | 780.58 ± 0.2% | 23.24 ± 0.2% | 737.75 ± 0.2% | 109.47 ± 22.3% | 11.25 ± 0.2% | 70.22 ± 0.6% | 752.21 ± 0.2% | 0.96 | 1.00 | 1.02 | 6.87 |
| other: a number before a unit, second text | 1481 | 5408.87 ± 0.8% | 989.56 ± 0.1% | 25.53 ± 0.4% | 5651.51 ± 0.6% | 40.67 ± 0.2% | 17.84 ± 0.2% | 67.12 ± 0.3% | 5395.13 ± 0.5% | 5.47 | 1.00 | 0.96 | 133.00 |
| other: a heading's start tag | 110 | 12446.63 ± 0.9% | 1044.57 ± 0.2% | 27.04 ± 0.4% | 1714.01 ± 0.4% | 1580.21 ± 2.6% | 15.99 ± 0.4% | 88.90 ± 0.5% | 12498.53 ± 0.7% | 11.92 | 1.00 | 7.26 | 7.88 |
| other: a whole word | 217 | 13926.18 ± 0.6% | 1046.40 ± 0.2% | 28.95 ± 0.2% | 14417.54 ± 1.4% | 49.41 ± 0.3% | 13.40 ± 0.2% | 56.06 ± 0.1% | 13885.50 ± 0.6% | 13.31 | 1.00 | 0.97 | 281.84 |
| other: a line's first word, second text | 3716 | 1963.11 ± 0.3% | 879.18 ± 0.1% | 30.33 ± 0.2% | 1719.74 ± 0.7% | 62.04 ± 6.3% | refused | refused | 1957.45 ± 0.7% | 2.23 | 1.00 | 1.14 | 31.64 |
| other: fourteen octets before an x | 87 | 19679.18 ± 0.8% | 234.44 ± 3.1% | 6.63 ± 0.1% | 3892.51 ± 0.8% | 10.66 ± 0.1% | differs | 17.80 ± 0.1% | 19645.97 ± 0.6% | 83.94 | 1.00 | 5.06 | 1845.53 |
| other: a Greek word | 21815 | 512.54 ± 0.3% | 411.08 ± 0.3% | 31.00 ± 1.3% | 288.76 ± 0.2% | 49.42 ± 14.1% | differs | refused | 510.22 ± 0.4% | 1.25 | 1.00 | 1.77 | 10.37 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.86 ± 0.4% | 25.87 ± 0.4% | 0.88 ± 0.2% | 19.74 ± 0.1% | 2.77 ± 0.5% | differs | 4.00 ± 0.3% | 25.83 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.32 |
| a UUID | 32895 | 21.13 ± 0.2% | 21.15 ± 0.2% | 0.65 ± 0.1% | 15.19 ± 0.3% | 3.10 ± 0.6% | 0.72 ± 0.4% | 3.59 ± 0.4% | 21.18 ± 0.4% | 1.00 | 1.00 | 1.39 | 6.82 |
| an IPv4 address | 33176 | 36.87 ± 0.2% | 36.77 ± 0.3% | 2.12 ± 0.5% | 28.89 ± 0.2% | 6.56 ± 0.1% | differs | 4.15 ± 0.1% | 36.86 ± 0.2% | 1.00 | 1.00 | 1.28 | 5.62 |
| a date and time | 32954 | 30.95 ± 0.3% | 31.04 ± 0.5% | 1.47 ± 0.5% | 21.18 ± 0.1% | 7.02 ± 0.2% | 1.20 ± 0.2% | 7.05 ± 0.7% | 31.01 ± 0.5% | 1.00 | 1.00 | 1.46 | 4.41 |
| a field path | 32606 | 29.45 ± 0.1% | 29.40 ± 0.2% | 1.04 ± 0.1% | 23.05 ± 0.1% | 3.50 ± 1.0% | differs | 2.95 ± 0.2% | 29.41 ± 0.2% | 1.00 | 1.00 | 1.28 | 8.42 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.47 ± 0.2% | 11.56 ± 0.2% | 11.55 ± 0.2% | 11.43 ± 0.1% | 4.90 ± 0.8% | 0.91 ± 0.7% | none | 11.53 ± 0.3% | 0.99 | 1.00 | 1.00 | 2.34 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.35 ± 0.2% | 221.81 ± 0.3% | 258.16 ± 0.1% | 86.80 ± 0.5% | 220.24 ± 0.9% | 480.21 ± 0.8% | 3882.26 ± 0.7% | 221.24 ± 0.2% | 1.00 | 1.00 | 2.55 | 1.01 |
| a UUID | 62 | 145.59 ± 0.3% | 145.97 ± 0.2% | 161.12 ± 0.4% | 46.57 ± 0.7% | 98.52 ± 0.9% | 189.72 ± 2.6% | 4412.04 ± 2.2% | 145.45 ± 0.3% | 1.00 | 1.00 | 3.13 | 1.48 |
| an IPv4 address | 29 | 436.29 ± 0.4% | 440.49 ± 0.4% | 611.12 ± 0.3% | 77.23 ± 0.2% | 130.28 ± 1.1% | 303.25 ± 1.2% | 7620.28 ± 0.2% | 436.52 ± 0.3% | 0.99 | 1.00 | 5.65 | 3.35 |
| a date and time | 56 | 319.73 ± 0.3% | 320.90 ± 0.4% | 402.49 ± 0.3% | 73.35 ± 0.5% | 135.90 ± 2.0% | 324.94 ± 1.6% | 4921.47 ± 0.5% | 319.22 ± 0.5% | 1.00 | 1.00 | 4.36 | 2.35 |
| a field path | 39 | 208.34 ± 0.1% | 209.09 ± 0.2% | 241.11 ± 0.2% | 81.07 ± 1.2% | 203.46 ± 1.9% | 501.23 ± 2.4% | 4941.90 ± 4.0% | 208.33 ± 0.3% | 1.00 | 1.00 | 2.57 | 1.02 |
| literal: a word | 7 | 659.58 ± 0.2% | 709.31 ± 0.4% | 1255.32 ± 0.2% | 529.67 ± 0.1% | 627.03 ± 1.8% | 955.39 ± 0.3% | 30149.08 ± 0.3% | 659.11 ± 0.1% | 0.93 | 1.00 | 1.25 | 1.05 |
| literal: a word that is not there | 8 | 632.28 ± 0.3% | 684.47 ± 0.3% | 1171.67 ± 0.3% | 486.81 ± 0.6% | 596.87 ± 1.2% | 905.76 ± 0.4% | 28887.65 ± 0.1% | 632.45 ± 0.4% | 0.92 | 1.00 | 1.30 | 1.06 |
| literal: one of four words | 26 | 253.54 ± 0.3% | 416.60 ± 0.3% | 561.05 ± 0.4% | 50.22 ± 1.3% | 239.46 ± 1.8% | 373.86 ± 1.6% | 15602.34 ± 0.1% | 253.59 ± 0.2% | 0.61 | 1.00 | 5.05 | 1.06 |
| literal: a word in any case | 11 | 517.39 ± 0.3% | 556.62 ± 0.3% | 857.73 ± 0.3% | 15.91 ± 1.5% | 648.32 ± 0.9% | refused | 23267.33 ± 0.5% | 518.05 ± 0.1% | 0.93 | 1.00 | 32.52 | 0.80 |
| literal: an href attribute | 12 | 348.41 ± 0.3% | 359.81 ± 0.3% | 466.62 ± 0.2% | 45.98 ± 0.4% | 497.68 ± 1.7% | 773.95 ± 1.1% | 21913.63 ± 0.2% | 348.43 ± 0.5% | 0.97 | 1.00 | 7.58 | 0.70 |
| literal: a word, second text | 10 | 586.28 ± 0.3% | 645.09 ± 0.5% | 1071.43 ± 0.2% | 404.76 ± 0.1% | 534.41 ± 2.2% | 799.56 ± 0.4% | 26870.21 ± 0.3% | 585.67 ± 0.6% | 0.91 | 1.00 | 1.45 | 1.10 |
| class: two capitalized words | 23 | 458.26 ± 0.4% | 486.71 ± 0.4% | 701.39 ± 0.7% | 100.11 ± 0.1% | 500.63 ± 1.2% | 746.05 ± 0.4% | 6610.84 ± 0.3% | 457.20 ± 0.3% | 0.94 | 1.00 | 4.58 | 0.92 |
| class: a word that ends in ing | 9 | 592.02 ± 0.6% | 660.33 ± 0.2% | 1154.98 ± 0.1% | 132.54 ± 2.1% | 763.43 ± 1.5% | 1109.25 ± 0.6% | 15976.52 ± 0.2% | 593.17 ± 0.3% | 0.90 | 1.00 | 4.47 | 0.78 |
| class: a word in capitals | 16 | 522.58 ± 0.6% | 561.95 ± 0.7% | 899.41 ± 0.4% | 135.45 ± 0.5% | 744.90 ± 5.5% | 1026.26 ± 0.9% | 8659.07 ± 0.8% | 522.16 ± 0.3% | 0.93 | 1.00 | 3.86 | 0.70 |
| class: a number | 6 | 657.23 ± 0.2% | 719.83 ± 0.2% | 1339.15 ± 0.1% | 41.96 ± 0.4% | 1381.46 ± 8.2% | 1856.65 ± 1.1% | 22844.94 ± 0.1% | 657.40 ± 0.5% | 0.91 | 1.00 | 15.66 | 0.48 |
| class: two capitalized words, second text | 23 | 458.51 ± 0.6% | 487.55 ± 0.4% | 702.10 ± 0.3% | 101.72 ± 0.4% | 498.79 ± 3.0% | 766.65 ± 0.6% | 6607.44 ± 0.2% | 458.18 ± 0.7% | 0.94 | 1.00 | 4.51 | 0.92 |
| other: a word between two words | 13 | 572.21 ± 0.3% | 589.56 ± 0.4% | 935.55 ± 0.5% | 133.52 ± 0.6% | 498.79 ± 2.5% | 812.39 ± 0.7% | 14845.76 ± 0.2% | 571.39 ± 0.2% | 0.97 | 1.00 | 4.29 | 1.15 |
| other: a number before a unit, second text | 15 | 401.85 ± 0.2% | 436.92 ± 0.3% | 602.61 ± 0.3% | 39.62 ± 0.4% | 632.40 ± 1.0% | 893.05 ± 1.1% | 15073.10 ± 0.2% | 401.66 ± 0.2% | 0.92 | 1.00 | 10.14 | 0.64 |
| other: a heading's start tag | 13 | 359.81 ± 0.3% | 364.97 ± 0.7% | 476.60 ± 0.8% | 44.07 ± 0.3% | 627.67 ± 0.8% | 877.14 ± 0.9% | 18130.16 ± 0.1% | 360.03 ± 0.5% | 0.99 | 1.00 | 8.17 | 0.57 |
| other: a whole word | 11 | 606.31 ± 0.5% | 643.91 ± 0.6% | 1070.30 ± 0.6% | 118.78 ± 0.5% | 559.45 ± 2.0% | 835.89 ± 0.6% | 26221.44 ± 0.7% | 605.99 ± 0.5% | 0.94 | 1.00 | 5.10 | 1.08 |
| other: a line's first word, second text | 17 | 552.73 ± 0.6% | 575.63 ± 0.4% | 924.78 ± 0.2% | 129.76 ± 0.1% | 703.61 ± 1.0% | refused | refused | 552.12 ± 0.8% | 0.96 | 1.00 | 4.26 | 0.79 |
| other: fourteen octets before an x | 16 | 112.87 ± 0.3% | 162.95 ± 0.5% | 186.19 ± 0.5% | 15.25 ± 0.5% | 452.37 ± 3.8% | 412.73 ± 0.6% | 12710.07 ± 1.2% | 112.79 ± 0.3% | 0.69 | 1.00 | 7.40 | 0.25 |
| other: a Greek word | 8 | 447.33 ± 0.3% | 587.67 ± 0.2% | 951.33 ± 0.4% | 59.42 ± 0.2% | 1370.02 ± 1.2% | 1792.78 ± 0.6% | refused | 447.43 ± 0.2% | 0.76 | 1.00 | 7.53 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12823.83 ± 0.8% | not timed | not timed | 16168.25 ± 2.2% | 2131.60 ± 14.0% | not timed | not timed | 12820.07 ± 0.5% | | 1.00 | 0.79 | 6.02 |
| 01-literal/sherlock-casei-en | 522 | 4469.45 ± 1.0% | not timed | not timed | 3587.04 ± 0.2% | 32.50 ± 0.2% | not timed | not timed | 4468.52 ± 1.2% | | 1.00 | 1.25 | 137.54 |
| 01-literal/sherlock-ru | 724 | 13506.85 ± 0.4% | not timed | not timed | 17342.44 ± 0.3% | 1528.36 ± 10.4% | not timed | not timed | 13499.52 ± 0.2% | | 1.00 | 0.78 | 8.84 |
| 01-literal/sherlock-casei-ru | 746 | 5290.75 ± 1.3% | not timed | not timed | 3319.22 ± 0.2% | 31.75 ± 0.3% | not timed | not timed | 5293.19 ± 0.3% | | 1.00 | 1.59 | 166.61 |
| 01-literal/sherlock-zh | 30 | 16942.74 ± 0.3% | not timed | not timed | 18528.72 ± 1.2% | 2671.03 ± 4.0% | not timed | not timed | 16940.06 ± 0.6% | | 1.00 | 0.91 | 6.34 |
| 02-literal-alternate/sherlock-en | 714 | 5769.49 ± 0.3% | not timed | not timed | 3942.08 ± 0.1% | 16.62 ± 0.0% | not timed | not timed | 5765.43 ± 0.1% | | 1.00 | 1.46 | 347.24 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1709.05 ± 1.3% | not timed | not timed | 695.64 ± 0.2% | 11.12 ± 0.2% | not timed | not timed | 1698.40 ± 0.5% | | 1.01 | 2.46 | 153.67 |
| 02-literal-alternate/sherlock-ru | 899 | 4647.47 ± 0.1% | not timed | not timed | 3254.99 ± 0.2% | 22.57 ± 0.1% | not timed | not timed | 4646.15 ± 0.2% | | 1.00 | 1.43 | 205.92 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1806.24 ± 0.6% | not timed | not timed | 1231.46 ± 0.1% | 9.14 ± 0.2% | not timed | not timed | 1801.11 ± 0.1% | | 1.00 | 1.47 | 197.64 |
| 02-literal-alternate/sherlock-zh | 207 | 7060.21 ± 0.2% | not timed | not timed | 4159.70 ± 0.3% | 31.40 ± 11.4% | not timed | not timed | 7055.58 ± 0.3% | | 1.00 | 1.70 | 224.86 |
| 03-date/ascii | 111817 | 126.93 ± 0.7% | not timed | not timed | 96.50 ± 0.2% | 0.20 ± 3.8% | not timed | not timed | 126.36 ± 0.6% | | 1.00 | 1.32 | 623.01 |
| 04-ruff-noqa/real | 84 | 555.83 ± 0.1% | not timed | not timed | 460.67 ± 0.2% | 19.58 ± 0.2% | not timed | not timed | 556.22 ± 0.1% | | 1.00 | 1.21 | 28.39 |
| 04-ruff-noqa/tweaked | 44 | 540.71 ± 0.1% | not timed | not timed | 454.79 ± 0.1% | 364.67 ± 0.7% | not timed | not timed | 539.43 ± 0.2% | | 1.00 | 1.19 | 1.48 |
| 05-lexer-veryl/single | 124800 | 3.98 ± 0.4% | not timed | not timed | 5.11 ± 0.5% | 0.20 ± 3.1% | not timed | not timed | 4.17 ± 0.2% | | 0.95 | 0.78 | 19.48 |
| 06-cloud-flare-redos/original | 107 | 260.03 ± 0.5% | not timed | not timed | 217.62 ± 0.1% | 24.96 ± 5.7% | not timed | not timed | 259.30 ± 4.4% | | 1.00 | 1.19 | 10.42 |
| 06-cloud-flare-redos/simplified-short | 102 | 255.16 ± 0.1% | not timed | not timed | 228.79 ± 1.9% | 26.28 ± 3.4% | not timed | not timed | 255.00 ± 10.0% | | 1.00 | 1.12 | 9.71 |
| 06-cloud-flare-redos/simplified-long | 10000 | 291.91 ± 0.2% | not timed | not timed | 255.21 ± 0.3% | 28.85 ± 0.1% | not timed | not timed | 291.69 ± 0.9% | | 1.00 | 1.14 | 10.12 |
| 07-unicode-character-data/parse-line | 558784 | 239.61 ± 0.3% | not timed | not timed | 172.67 ± 0.1% | 42.53 ± 0.6% | not timed | not timed | 240.31 ± 0.5% | | 1.00 | 1.39 | 5.63 |
| 08-words/all-english | 56691 | 121.51 ± 0.2% | not timed | not timed | 82.73 ± 0.1% | 11.79 ± 7.5% | not timed | not timed | 121.29 ± 0.2% | | 1.00 | 1.47 | 10.31 |
| 08-words/long-english | 839 | 1012.80 ± 0.2% | not timed | not timed | 597.72 ± 0.1% | 32.52 ± 10.5% | not timed | not timed | 1011.01 ± 0.2% | | 1.00 | 1.69 | 31.14 |
| 09-aws-keys/full | 0 | 409.27 ± 0.0% | not timed | not timed | 460.78 ± 0.2% | 64.53 ± 0.1% | not timed | not timed | 397.67 ± 0.1% | | 1.03 | 0.89 | 6.34 |
| 09-aws-keys/quick | 0 | 739.74 ± 0.2% | not timed | not timed | 991.83 ± 0.2% | 417.61 ± 1.4% | not timed | not timed | 737.47 ± 0.1% | | 1.00 | 0.75 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 638.80 ± 0.4% | not timed | not timed | 516.32 ± 0.6% | 19.53 ± 1.2% | not timed | not timed | 635.83 ± 0.2% | | 1.00 | 1.24 | 32.70 |
| 10-bounded-repeat/letters-ru | 3475 | 383.09 ± 0.2% | not timed | not timed | 478.05 ± 0.1% | 21.73 ± 17.0% | not timed | not timed | 380.18 ± 0.7% | | 1.01 | 0.80 | 17.63 |
| 10-bounded-repeat/context | 53 | 79.68 ± 0.9% | not timed | not timed | 65.76 ± 0.6% | 19.83 ± 0.1% | not timed | not timed | 79.55 ± 1.5% | | 1.00 | 1.21 | 4.02 |
| 10-bounded-repeat/capitals | 11 | 1055.47 ± 0.2% | not timed | not timed | 618.36 ± 0.1% | 36.45 ± 0.2% | not timed | not timed | 1055.02 ± 0.1% | | 1.00 | 1.71 | 28.96 |
| 11-unstructured-to-json/extract | 600 | 49.82 ± 0.2% | not timed | not timed | 77.57 ± 0.1% | 48.94 ± 0.6% | not timed | not timed | 49.63 ± 0.1% | | 1.00 | 0.64 | 1.02 |
| 12-dictionary/single | 1 | 567.58 ± 0.6% | not timed | not timed | 556.30 ± 0.5% | 0.41 ± 0.2% | not timed | not timed | 568.23 ± 0.4% | | 1.00 | 1.02 | 1396.82 |
| 14-quadratic/1x | 100 | 12.85 ± 0.3% | not timed | not timed | 10.00 ± 0.2% | 0.96 ± 3.1% | not timed | not timed | 12.78 ± 1.3% | | 1.01 | 1.29 | 13.38 |
| 14-quadratic/2x | 200 | 7.96 ± 0.5% | not timed | not timed | 5.53 ± 0.2% | 0.53 ± 1.7% | not timed | not timed | 7.91 ± 0.5% | | 1.01 | 1.44 | 15.01 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.2% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 0.2% | not timed | not timed | 1.88 ± 1.7% | | 1.00 | 1.55 | 16.29 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.55 ± 0.1% | not timed | not timed | 0.34 ± 0.3% | 0.54 ± 3.4% | not timed | not timed | 1.54 ± 1.3% | | 1.01 | 4.59 | 2.86 |
| 04-ruff-noqa/compile-real | 1 | 86.92 ± 0.1% | not timed | not timed | 13.96 ± 0.1% | 135.72 ± 3.5% | not timed | not timed | 86.50 ± 1.1% | | 1.00 | 6.23 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 14.30 ± 0.3% | not timed | not timed | 2.52 ± 0.8% | 6.42 ± 2.1% | not timed | not timed | 14.24 ± 1.6% | | 1.00 | 5.68 | 2.23 |
| 07-unicode-character-data/compile | 1 | 55.34 ± 0.3% | not timed | not timed | 25.94 ± 0.4% | 35.61 ± 2.7% | not timed | not timed | 55.19 ± 0.7% | | 1.00 | 2.13 | 1.55 |
| 09-aws-keys/compile-full | 1 | 42.38 ± 0.2% | not timed | not timed | 8.33 ± 0.2% | 22.90 ± 1.5% | not timed | not timed | 42.21 ± 0.2% | | 1.00 | 5.09 | 1.85 |
| 09-aws-keys/compile-quick | 1 | 189.18 ± 0.1% | not timed | not timed | 47.52 ± 0.2% | 130.79 ± 3.1% | not timed | not timed | 188.60 ± 0.9% | | 1.00 | 3.98 | 1.45 |
| 10-bounded-repeat/compile-context | 1 | 14.70 ± 0.9% | not timed | not timed | 11.19 ± 0.1% | 15.95 ± 28.0% | not timed | not timed | 14.57 ± 1.2% | | 1.01 | 1.31 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 85.10 ± 0.8% | not timed | not timed | 8.15 ± 0.2% | 23.68 ± 2.3% | not timed | not timed | 84.61 ± 0.5% | | 1.01 | 10.44 | 3.59 |
| 11-unstructured-to-json/compile | 1 | 86.68 ± 0.4% | not timed | not timed | 40.47 ± 0.3% | 66.58 ± 3.4% | not timed | not timed | 86.23 ± 0.9% | | 1.01 | 2.14 | 1.30 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.1% | not timed | not timed | 0.07 ± 1.1% | 0.10 ± 8.8% | not timed | not timed | 0.35 ± 1.3% | | 1.01 | 5.25 | 3.63 |

