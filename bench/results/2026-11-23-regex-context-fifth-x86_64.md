# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117648292 |
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
| literal: a word | 217 | 31766.60 ± 0.8% | 1090.01 ± 0.2% | 33.05 ± 1.5% | 32006.30 ± 0.3% | 12598.61 ± 2.1% | 14.96 ± 0.1% | 108.19 ± 1.0% | 31712.95 ± 0.5% | 29.14 | 1.00 | 0.99 | 2.52 |
| literal: a word that is not there | 0 | 41718.60 ± 0.1% | 1103.45 ± 0.1% | 33.23 ± 1.1% | 35435.28 ± 0.1% | 39402.71 ± 0.3% | 14.51 ± 0.1% | 103.00 ± 1.4% | 41729.27 ± 0.1% | 37.81 | 1.00 | 1.18 | 1.06 |
| literal: one of four words | 661 | 13448.48 ± 1.7% | 1067.60 ± 0.2% | 18.58 ± 2.2% | 9727.20 ± 0.4% | 29.35 ± 0.5% | 4.35 ± 0.1% | 7.99 ± 0.7% | 13319.39 ± 0.3% | 12.60 | 1.01 | 1.38 | 458.14 |
| literal: a word in any case | 217 | 27194.50 ± 0.5% | 1088.70 ± 0.8% | 24.56 ± 0.9% | 10063.05 ± 0.2% | 58.67 ± 0.6% | refused | differs | 27178.52 ± 1.3% | 24.98 | 1.00 | 2.70 | 463.51 |
| literal: an href attribute | 33 | 27713.16 ± 1.2% | 1096.33 ± 0.2% | 30.11 ± 1.0% | 28600.66 ± 0.5% | 2604.64 ± 1.3% | 10.69 ± 0.6% | 97.71 ± 1.4% | 27645.07 ± 0.8% | 25.28 | 1.00 | 0.97 | 10.64 |
| literal: a word, second text | 123 | 33308.29 ± 0.9% | 1094.24 ± 0.2% | 32.66 ± 1.1% | 31922.88 ± 0.2% | 9219.76 ± 7.6% | 19.43 ± 0.2% | 99.18 ± 1.6% | 33300.37 ± 6.0% | 30.44 | 1.00 | 1.04 | 3.61 |
| class: two capitalized words | 1331 | 1014.09 ± 0.5% | 1004.09 ± 0.4% | 30.49 ± 1.5% | 614.21 ± 0.1% | 49.30 ± 17.7% | 12.68 ± 0.1% | 80.25 ± 0.3% | 1013.27 ± 0.9% | 1.01 | 1.00 | 1.65 | 20.57 |
| class: a word that ends in ing | 3399 | 921.60 ± 0.1% | 921.97 ± 0.2% | 20.62 ± 0.4% | 578.16 ± 0.2% | 35.69 ± 13.6% | 7.18 ± 0.4% | 21.69 ± 0.7% | 920.65 ± 0.5% | 1.00 | 1.00 | 1.59 | 25.82 |
| class: a word in capitals | 2332 | 1381.11 ± 0.7% | 989.24 ± 0.4% | 32.08 ± 1.3% | 605.43 ± 0.1% | 53.58 ± 2.3% | 15.29 ± 0.1% | 97.44 ± 0.1% | 1376.83 ± 1.0% | 1.40 | 1.00 | 2.28 | 25.78 |
| class: a number | 8288 | 1972.53 ± 0.5% | 839.16 ± 0.1% | 31.48 ± 1.7% | 2123.35 ± 0.4% | 52.05 ± 16.1% | 0.43 ± 0.1% | 75.14 ± 1.6% | 1975.85 ± 0.2% | 2.35 | 1.00 | 0.93 | 37.89 |
| class: two capitalized words, second text | 5359 | 727.02 ± 0.2% | 727.65 ± 0.1% | 27.80 ± 2.2% | 508.38 ± 0.3% | 40.52 ± 14.1% | 16.61 ± 0.2% | 73.17 ± 1.9% | 728.11 ± 0.1% | 1.00 | 1.00 | 1.43 | 17.94 |
| other: a word between two words | 6104 | 751.21 ± 0.2% | 782.51 ± 0.2% | 27.43 ± 0.8% | 877.24 ± 0.3% | 137.66 ± 11.8% | 9.71 ± 0.1% | 86.47 ± 0.4% | 744.53 ± 0.6% | 0.96 | 1.01 | 0.86 | 5.46 |
| other: a number before a unit, second text | 1481 | 8893.84 ± 1.4% | 1028.44 ± 0.2% | 30.46 ± 1.5% | 9309.58 ± 1.6% | 49.46 ± 16.6% | 17.42 ± 0.2% | 79.37 ± 3.0% | 8762.67 ± 0.8% | 8.65 | 1.01 | 0.96 | 179.82 |
| other: a heading's start tag | 110 | 20336.22 ± 0.2% | 1086.52 ± 0.2% | 32.65 ± 0.3% | 2712.73 ± 1.1% | 1918.63 ± 1.7% | 13.32 ± 0.1% | 117.38 ± 1.4% | 20317.33 ± 0.6% | 18.72 | 1.00 | 7.50 | 10.60 |
| other: a whole word | 217 | 24969.03 ± 0.2% | 1089.77 ± 0.1% | 33.88 ± 0.3% | 25586.75 ± 0.3% | 60.43 ± 0.7% | 12.67 ± 0.1% | 64.52 ± 0.8% | 24971.89 ± 0.2% | 22.91 | 1.00 | 0.98 | 413.19 |
| other: a line's first word, second text | 3716 | 2377.18 ± 0.6% | 899.79 ± 0.1% | 35.50 ± 1.1% | 2453.60 ± 0.6% | 81.95 ± 4.5% | refused | refused | 2364.47 ± 0.3% | 2.64 | 1.01 | 0.97 | 29.01 |
| other: fourteen octets before an x | 87 | 35033.24 ± 0.7% | 300.86 ± 0.6% | 7.40 ± 0.4% | 4147.54 ± 0.9% | 11.67 ± 0.1% | differs | 20.15 ± 1.3% | 35045.58 ± 0.8% | 116.44 | 1.00 | 8.45 | 3002.39 |
| other: a Greek word | 21815 | 505.83 ± 0.3% | 346.98 ± 0.4% | 37.12 ± 0.9% | 313.97 ± 0.2% | 53.45 ± 1.8% | differs | refused | 504.21 ± 0.2% | 1.46 | 1.00 | 1.61 | 9.46 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.85 ± 0.6% | 28.75 ± 0.4% | 1.09 ± 1.3% | 21.47 ± 0.1% | 3.23 ± 0.3% | differs | 4.81 ± 0.6% | 28.80 ± 0.4% | 1.00 | 1.00 | 1.34 | 8.92 |
| a UUID | 32895 | 26.03 ± 0.3% | 26.05 ± 0.2% | 0.77 ± 0.3% | 16.48 ± 0.1% | 3.25 ± 1.3% | 0.71 ± 0.2% | 3.99 ± 1.0% | 26.03 ± 0.7% | 1.00 | 1.00 | 1.58 | 8.01 |
| an IPv4 address | 33176 | 39.17 ± 0.3% | 39.15 ± 0.3% | 2.49 ± 0.8% | 31.52 ± 0.3% | 8.18 ± 0.7% | differs | 4.61 ± 0.3% | 39.04 ± 0.2% | 1.00 | 1.00 | 1.24 | 4.79 |
| a date and time | 32954 | 37.47 ± 0.2% | 37.74 ± 0.3% | 1.81 ± 0.3% | 23.95 ± 0.1% | 10.26 ± 0.6% | 1.31 ± 0.1% | 8.50 ± 0.8% | 37.63 ± 0.4% | 0.99 | 1.00 | 1.56 | 3.65 |
| a field path | 32606 | 31.35 ± 0.4% | 31.31 ± 0.6% | 1.28 ± 0.5% | 24.78 ± 0.1% | 3.72 ± 0.3% | differs | 3.13 ± 1.3% | 31.28 ± 0.3% | 1.00 | 1.00 | 1.27 | 8.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.39 ± 0.5% | 12.50 ± 0.8% | 12.44 ± 0.6% | 14.37 ± 0.5% | 6.91 ± 0.4% | 1.03 ± 0.6% | none | 12.44 ± 0.4% | 0.99 | 1.00 | 0.86 | 1.79 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 302.30 ± 0.4% | 303.49 ± 0.6% | 354.27 ± 0.4% | 117.51 ± 1.7% | 265.53 ± 1.8% | 691.10 ± 1.7% | 4003.10 ± 1.2% | 301.73 ± 0.3% | 1.00 | 1.00 | 2.57 | 1.14 |
| a UUID | 62 | 193.86 ± 0.2% | 195.04 ± 0.3% | 215.87 ± 1.1% | 62.17 ± 1.2% | 118.66 ± 11.3% | 255.36 ± 2.7% | 5583.13 ± 0.5% | 194.00 ± 0.4% | 0.99 | 1.00 | 3.12 | 1.63 |
| an IPv4 address | 29 | 590.79 ± 0.4% | 595.98 ± 0.3% | 835.71 ± 1.7% | 100.61 ± 0.4% | 159.80 ± 1.4% | 432.79 ± 0.3% | 10076.37 ± 0.5% | 590.12 ± 0.5% | 0.99 | 1.00 | 5.87 | 3.70 |
| a date and time | 56 | 455.32 ± 0.2% | 459.19 ± 0.4% | 584.05 ± 0.3% | 96.99 ± 0.6% | 167.50 ± 3.2% | 450.54 ± 0.5% | 5597.37 ± 0.4% | 455.08 ± 0.2% | 0.99 | 1.00 | 4.69 | 2.72 |
| a field path | 39 | 291.57 ± 0.3% | 293.30 ± 0.2% | 340.15 ± 0.4% | 105.93 ± 1.1% | 246.94 ± 1.7% | 706.47 ± 2.0% | 5366.01 ± 0.5% | 291.57 ± 0.2% | 0.99 | 1.00 | 2.75 | 1.18 |
| literal: a word | 7 | 926.94 ± 0.4% | 1012.80 ± 0.3% | 1845.46 ± 0.5% | 719.48 ± 0.8% | 816.23 ± 0.8% | 1452.96 ± 0.3% | 31441.92 ± 0.1% | 927.36 ± 0.3% | 0.92 | 1.00 | 1.29 | 1.14 |
| literal: a word that is not there | 8 | 890.98 ± 0.4% | 978.61 ± 0.2% | 1743.34 ± 0.5% | 640.56 ± 0.5% | 785.52 ± 2.9% | 1363.34 ± 0.3% | 30932.95 ± 0.3% | 889.94 ± 0.2% | 0.91 | 1.00 | 1.39 | 1.13 |
| literal: one of four words | 26 | 353.64 ± 0.3% | 606.97 ± 0.4% | 833.37 ± 0.7% | 50.68 ± 0.9% | 308.51 ± 2.0% | 510.19 ± 2.1% | 16623.36 ± 1.4% | 353.69 ± 0.3% | 0.58 | 1.00 | 6.98 | 1.15 |
| literal: a word in any case | 11 | 703.06 ± 0.1% | 756.67 ± 0.3% | 1163.72 ± 0.3% | 17.82 ± 0.5% | 859.68 ± 14.0% | refused | 26904.04 ± 0.9% | 702.39 ± 0.2% | 0.93 | 1.00 | 39.46 | 0.82 |
| literal: an href attribute | 12 | 476.74 ± 0.7% | 492.73 ± 1.3% | 639.72 ± 0.6% | 50.19 ± 0.3% | 626.87 ± 1.7% | 1148.99 ± 0.6% | 23634.35 ± 0.2% | 477.05 ± 0.6% | 0.97 | 1.00 | 9.50 | 0.76 |
| literal: a word, second text | 10 | 823.71 ± 0.2% | 922.70 ± 0.1% | 1573.64 ± 0.5% | 595.38 ± 0.4% | 682.49 ± 1.8% | 1179.31 ± 0.6% | 29752.46 ± 0.1% | 824.24 ± 0.2% | 0.89 | 1.00 | 1.38 | 1.21 |
| class: two capitalized words | 23 | 676.50 ± 0.5% | 729.81 ± 0.3% | 1091.78 ± 0.2% | 136.90 ± 0.3% | 640.13 ± 2.2% | 1114.24 ± 0.3% | 6762.04 ± 0.5% | 676.76 ± 0.2% | 0.93 | 1.00 | 4.94 | 1.06 |
| class: a word that ends in ing | 9 | 817.57 ± 0.5% | 925.98 ± 0.2% | 1688.11 ± 0.6% | 172.67 ± 0.7% | 934.82 ± 8.5% | 1732.03 ± 0.6% | 19531.32 ± 1.3% | 818.29 ± 0.2% | 0.88 | 1.00 | 4.73 | 0.87 |
| class: a word in capitals | 16 | 742.08 ± 0.5% | 800.52 ± 0.3% | 1334.34 ± 0.2% | 181.75 ± 2.2% | 950.91 ± 11.9% | 1603.72 ± 0.6% | 9009.71 ± 0.5% | 741.27 ± 0.3% | 0.93 | 1.00 | 4.08 | 0.78 |
| class: a number | 6 | 906.73 ± 0.2% | 1002.67 ± 0.3% | 1932.63 ± 0.3% | 44.67 ± 1.4% | 1738.80 ± 10.7% | 3037.06 ± 1.3% | 26130.36 ± 0.6% | 907.23 ± 0.2% | 0.90 | 1.00 | 20.30 | 0.52 |
| class: two capitalized words, second text | 23 | 676.81 ± 0.3% | 729.12 ± 0.3% | 1089.71 ± 0.3% | 135.98 ± 0.4% | 642.95 ± 1.2% | 1130.88 ± 0.7% | 6770.69 ± 0.9% | 676.58 ± 0.4% | 0.93 | 1.00 | 4.98 | 1.05 |
| other: a word between two words | 13 | 802.83 ± 0.1% | 837.76 ± 0.3% | 1361.86 ± 0.2% | 181.82 ± 1.0% | 633.82 ± 0.9% | 1206.14 ± 1.0% | 17317.42 ± 1.1% | 802.84 ± 0.2% | 0.96 | 1.00 | 4.42 | 1.27 |
| other: a number before a unit, second text | 15 | 565.90 ± 0.1% | 623.54 ± 0.2% | 867.46 ± 0.2% | 41.94 ± 0.4% | 800.47 ± 7.0% | 1357.72 ± 2.3% | 18585.31 ± 1.0% | 566.30 ± 0.3% | 0.91 | 1.00 | 13.49 | 0.71 |
| other: a heading's start tag | 13 | 492.18 ± 0.4% | 501.86 ± 0.7% | 655.92 ± 0.5% | 48.18 ± 0.3% | 777.11 ± 1.3% | 1305.90 ± 1.3% | 20897.33 ± 0.2% | 492.24 ± 0.2% | 0.98 | 1.00 | 10.22 | 0.63 |
| other: a whole word | 11 | 849.65 ± 0.2% | 912.26 ± 0.3% | 1548.71 ± 0.4% | 162.13 ± 0.2% | 729.54 ± 1.9% | 1234.56 ± 1.4% | 29836.92 ± 0.5% | 850.03 ± 0.1% | 0.93 | 1.00 | 5.24 | 1.16 |
| other: a line's first word, second text | 17 | 775.99 ± 0.5% | 807.79 ± 0.2% | 1329.56 ± 1.1% | 173.86 ± 0.3% | 878.79 ± 1.3% | refused | refused | 772.78 ± 0.2% | 0.96 | 1.00 | 4.46 | 0.88 |
| other: fourteen octets before an x | 16 | 137.57 ± 0.4% | 200.64 ± 0.1% | 230.33 ± 0.6% | 18.73 ± 0.3% | 559.98 ± 2.2% | 598.71 ± 0.5% | 16019.19 ± 0.8% | 137.47 ± 0.2% | 0.69 | 1.00 | 7.35 | 0.25 |
| other: a Greek word | 8 | 603.03 ± 0.5% | 824.05 ± 0.2% | 1357.93 ± 0.3% | 61.84 ± 1.6% | 1737.25 ± 1.9% | 2902.35 ± 0.3% | refused | 602.31 ± 0.7% | 0.73 | 1.00 | 9.75 | 0.35 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 23094.34 ± 3.8% | not timed | not timed | 28327.20 ± 1.5% | 2866.97 ± 6.2% | not timed | not timed | 23036.57 ± 2.2% | | 1.00 | 0.82 | 8.06 |
| 01-literal/sherlock-casei-en | 522 | 5543.82 ± 0.2% | not timed | not timed | 8510.61 ± 0.2% | 40.42 ± 0.9% | not timed | not timed | 5543.76 ± 0.9% | | 1.00 | 0.65 | 137.16 |
| 01-literal/sherlock-ru | 724 | 24213.22 ± 0.5% | not timed | not timed | 27571.21 ± 4.5% | 1612.24 ± 2.8% | not timed | not timed | 24093.16 ± 6.2% | | 1.00 | 0.88 | 15.02 |
| 01-literal/sherlock-casei-ru | 746 | 8468.41 ± 0.9% | not timed | not timed | 6504.24 ± 3.5% | 42.88 ± 2.4% | not timed | not timed | 8356.34 ± 0.7% | | 1.01 | 1.30 | 197.47 |
| 01-literal/sherlock-zh | 30 | 37428.81 ± 2.4% | not timed | not timed | 34422.94 ± 0.7% | 1615.96 ± 1.6% | not timed | not timed | 37383.38 ± 0.3% | | 1.00 | 1.09 | 23.16 |
| 02-literal-alternate/sherlock-en | 714 | 12199.80 ± 0.7% | not timed | not timed | 9483.38 ± 0.2% | 22.46 ± 2.7% | not timed | not timed | 12145.20 ± 0.2% | | 1.00 | 1.29 | 543.08 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2041.61 ± 2.9% | not timed | not timed | 2315.82 ± 0.2% | 13.73 ± 3.2% | not timed | not timed | 2030.33 ± 0.3% | | 1.01 | 0.88 | 148.65 |
| 02-literal-alternate/sherlock-ru | 899 | 6965.32 ± 3.5% | not timed | not timed | 5099.22 ± 0.2% | 29.13 ± 0.5% | not timed | not timed | 6880.27 ± 0.6% | | 1.01 | 1.37 | 239.09 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2123.72 ± 1.7% | not timed | not timed | 1248.45 ± 0.1% | 11.94 ± 0.5% | not timed | not timed | 2124.11 ± 0.3% | | 1.00 | 1.70 | 177.83 |
| 02-literal-alternate/sherlock-zh | 207 | 16327.21 ± 0.4% | not timed | not timed | 10797.65 ± 0.1% | 41.85 ± 1.2% | not timed | not timed | 16277.70 ± 0.5% | | 1.00 | 1.51 | 390.10 |
| 03-date/ascii | 111817 | 125.76 ± 0.9% | not timed | not timed | 98.21 ± 0.3% | 0.27 ± 4.7% | not timed | not timed | 125.14 ± 2.0% | | 1.00 | 1.28 | 460.41 |
| 04-ruff-noqa/real | 84 | 735.65 ± 0.8% | not timed | not timed | 563.90 ± 0.3% | 25.68 ± 1.9% | not timed | not timed | 731.60 ± 1.1% | | 1.01 | 1.30 | 28.65 |
| 04-ruff-noqa/tweaked | 44 | 621.31 ± 0.5% | not timed | not timed | 567.82 ± 0.2% | 404.52 ± 12.0% | not timed | not timed | 619.33 ± 0.8% | | 1.00 | 1.09 | 1.54 |
| 05-lexer-veryl/single | 124800 | 4.13 ± 0.4% | not timed | not timed | 5.79 ± 0.3% | 0.27 ± 7.4% | not timed | not timed | 4.10 ± 3.2% | | 1.01 | 0.71 | 15.14 |
| 06-cloud-flare-redos/original | 107 | 244.44 ± 0.2% | not timed | not timed | 262.53 ± 0.3% | 32.15 ± 0.5% | not timed | not timed | 244.07 ± 0.3% | | 1.00 | 0.93 | 7.60 |
| 06-cloud-flare-redos/simplified-short | 102 | 172.92 ± 0.3% | not timed | not timed | 268.15 ± 0.1% | 34.94 ± 0.5% | not timed | not timed | 172.55 ± 0.7% | | 1.00 | 0.64 | 4.95 |
| 06-cloud-flare-redos/simplified-long | 10000 | 189.00 ± 4.5% | not timed | not timed | 280.47 ± 0.1% | 38.18 ± 0.4% | not timed | not timed | 189.00 ± 4.3% | | 1.00 | 0.67 | 4.95 |
| 07-unicode-character-data/parse-line | 558784 | 282.19 ± 1.0% | not timed | not timed | 205.21 ± 0.2% | 53.99 ± 1.3% | not timed | not timed | 243.74 ± 1.1% | | 1.16 | 1.38 | 5.23 |
| 08-words/all-english | 56691 | 107.62 ± 0.7% | not timed | not timed | 92.40 ± 0.7% | 15.64 ± 8.8% | not timed | not timed | 107.39 ± 0.4% | | 1.00 | 1.16 | 6.88 |
| 08-words/long-english | 839 | 1044.75 ± 0.2% | not timed | not timed | 626.00 ± 0.1% | 37.77 ± 0.8% | not timed | not timed | 1043.83 ± 0.1% | | 1.00 | 1.67 | 27.66 |
| 09-aws-keys/full | 0 | 575.55 ± 0.3% | not timed | not timed | 573.95 ± 0.2% | 82.94 ± 2.3% | not timed | not timed | 576.01 ± 0.2% | | 1.00 | 1.00 | 6.94 |
| 09-aws-keys/quick | 0 | 1102.06 ± 0.2% | not timed | not timed | 912.74 ± 0.5% | 542.40 ± 1.1% | not timed | not timed | 1099.27 ± 0.5% | | 1.00 | 1.21 | 2.03 |
| 10-bounded-repeat/letters-en | 1833 | 615.32 ± 0.7% | not timed | not timed | 552.55 ± 0.2% | 24.28 ± 0.6% | not timed | not timed | 612.58 ± 0.2% | | 1.00 | 1.11 | 25.35 |
| 10-bounded-repeat/letters-ru | 3475 | 394.32 ± 1.2% | not timed | not timed | 496.37 ± 1.4% | 25.27 ± 8.9% | not timed | not timed | 393.63 ± 1.2% | | 1.00 | 0.79 | 15.60 |
| 10-bounded-repeat/context | 53 | 91.70 ± 0.9% | not timed | not timed | 75.72 ± 0.3% | 24.39 ± 0.4% | not timed | not timed | 91.11 ± 1.5% | | 1.01 | 1.21 | 3.76 |
| 10-bounded-repeat/capitals | 11 | 1087.91 ± 0.2% | not timed | not timed | 642.44 ± 0.1% | 44.56 ± 0.4% | not timed | not timed | 1087.13 ± 0.1% | | 1.00 | 1.69 | 24.41 |
| 11-unstructured-to-json/extract | 600 | 47.43 ± 0.2% | not timed | not timed | 81.50 ± 2.2% | 64.43 ± 3.0% | not timed | not timed | 47.39 ± 0.5% | | 1.00 | 0.58 | 0.74 |
| 12-dictionary/single | 1 | 570.66 ± 0.3% | not timed | not timed | 549.12 ± 1.5% | 0.53 ± 0.2% | not timed | not timed | 574.15 ± 0.1% | | 0.99 | 1.04 | 1067.64 |
| 14-quadratic/1x | 100 | 14.32 ± 0.5% | not timed | not timed | 13.53 ± 0.0% | 1.21 ± 3.8% | not timed | not timed | 14.29 ± 3.2% | | 1.00 | 1.06 | 11.84 |
| 14-quadratic/2x | 200 | 8.60 ± 0.2% | not timed | not timed | 6.63 ± 0.2% | 0.68 ± 0.6% | not timed | not timed | 8.60 ± 1.1% | | 1.00 | 1.30 | 12.71 |
| 14-quadratic/10x | 1000 | 1.94 ± 1.0% | not timed | not timed | 1.30 ± 0.1% | 0.15 ± 1.2% | not timed | not timed | 1.94 ± 0.8% | | 1.00 | 1.50 | 12.73 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.04 ± 0.2% | not timed | not timed | 0.45 ± 3.0% | 0.66 ± 3.1% | not timed | not timed | 2.03 ± 0.6% | | 1.00 | 4.51 | 3.10 |
| 04-ruff-noqa/compile-real | 1 | 120.88 ± 0.5% | not timed | not timed | 15.67 ± 0.5% | 176.65 ± 0.6% | not timed | not timed | 120.02 ± 4.5% | | 1.01 | 7.71 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 21.54 ± 0.6% | not timed | not timed | 3.06 ± 0.7% | 7.96 ± 1.7% | not timed | not timed | 21.55 ± 0.3% | | 1.00 | 7.04 | 2.71 |
| 07-unicode-character-data/compile | 1 | 76.58 ± 0.7% | not timed | not timed | 32.13 ± 0.5% | 44.88 ± 0.6% | not timed | not timed | 76.51 ± 0.8% | | 1.00 | 2.38 | 1.71 |
| 09-aws-keys/compile-full | 1 | 53.08 ± 0.3% | not timed | not timed | 9.04 ± 0.4% | 28.45 ± 0.4% | not timed | not timed | 52.84 ± 1.0% | | 1.00 | 5.87 | 1.87 |
| 09-aws-keys/compile-quick | 1 | 237.12 ± 0.3% | not timed | not timed | 59.44 ± 0.3% | 167.95 ± 0.4% | not timed | not timed | 236.21 ± 0.1% | | 1.00 | 3.99 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 16.48 ± 0.3% | not timed | not timed | 14.63 ± 0.3% | 21.07 ± 1.5% | not timed | not timed | 16.43 ± 0.8% | | 1.00 | 1.13 | 0.78 |
| 10-bounded-repeat/compile-capitals | 1 | 99.46 ± 0.4% | not timed | not timed | 10.85 ± 2.7% | 30.09 ± 2.0% | not timed | not timed | 99.21 ± 0.7% | | 1.00 | 9.17 | 3.31 |
| 11-unstructured-to-json/compile | 1 | 117.98 ± 0.5% | not timed | not timed | 51.49 ± 0.8% | 84.36 ± 2.5% | not timed | not timed | 117.55 ± 0.7% | | 1.00 | 2.29 | 1.40 |
| 12-dictionary/compile-single | 1 | 0.38 ± 1.3% | not timed | not timed | 0.08 ± 1.0% | 0.11 ± 24.4% | not timed | not timed | 0.37 ± 2.0% | | 1.01 | 4.55 | 3.34 |

