# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127380362 |
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
| literal: a word | 217 | 16112.79 ± 1.3% | 1038.58 ± 0.1% | 28.66 ± 0.3% | 18164.60 ± 2.3% | 9033.18 ± 11.1% | 17.45 ± 0.2% | 86.16 ± 0.2% | 16125.33 ± 1.1% | 15.51 | 1.00 | 0.89 | 1.78 |
| literal: a word that is not there | 0 | 18652.19 ± 2.2% | 1047.44 ± 0.1% | 28.75 ± 0.4% | 19822.12 ± 2.2% | 28981.25 ± 2.2% | 17.24 ± 0.4% | 82.08 ± 0.1% | 18747.77 ± 1.6% | 17.81 | 0.99 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6068.90 ± 0.5% | 1021.02 ± 0.1% | 14.76 ± 0.2% | 3944.69 ± 0.3% | 21.86 ± 0.1% | 5.25 ± 0.3% | 6.72 ± 0.3% | 6048.99 ± 0.4% | 5.94 | 1.00 | 1.54 | 277.58 |
| literal: a word in any case | 217 | 12586.30 ± 0.7% | 1039.30 ± 0.1% | 21.55 ± 2.4% | 3975.63 ± 0.1% | 38.08 ± 0.3% | refused | differs | 12594.15 ± 0.4% | 12.11 | 1.00 | 3.17 | 330.54 |
| literal: an href attribute | 33 | 13622.32 ± 1.0% | 1045.22 ± 0.1% | 27.45 ± 0.2% | 16872.76 ± 2.3% | 2255.50 ± 4.7% | 13.21 ± 0.5% | 75.60 ± 0.4% | 13663.66 ± 0.9% | 13.03 | 1.00 | 0.81 | 6.04 |
| literal: a word, second text | 123 | 16197.18 ± 0.4% | 1042.43 ± 0.1% | 28.37 ± 0.4% | 18121.74 ± 1.8% | 7602.21 ± 2.7% | 19.65 ± 0.3% | 69.79 ± 0.3% | 16131.62 ± 1.1% | 15.54 | 1.00 | 0.89 | 2.13 |
| class: two capitalized words | 1331 | 1127.01 ± 0.3% | 977.42 ± 0.2% | 26.15 ± 0.2% | 585.47 ± 0.0% | 40.52 ± 8.1% | 14.84 ± 0.4% | 68.48 ± 0.7% | 1125.73 ± 0.4% | 1.15 | 1.00 | 1.92 | 27.82 |
| class: a word that ends in ing | 3399 | 890.55 ± 0.2% | 890.49 ± 0.1% | 18.25 ± 0.2% | 547.90 ± 0.1% | 29.54 ± 2.3% | 8.18 ± 0.2% | 18.20 ± 0.3% | 889.79 ± 0.1% | 1.00 | 1.00 | 1.63 | 30.14 |
| class: a word in capitals | 2332 | 1452.28 ± 0.3% | 950.62 ± 0.1% | 27.85 ± 0.2% | 572.54 ± 0.1% | 43.65 ± 0.3% | 17.17 ± 0.1% | 82.95 ± 0.3% | 1453.73 ± 0.1% | 1.53 | 1.00 | 2.54 | 33.27 |
| class: a number | 8288 | 1996.00 ± 0.2% | 827.18 ± 0.1% | 28.06 ± 0.2% | 1718.03 ± 0.1% | 42.22 ± 17.1% | 0.53 ± 0.7% | 56.63 ± 0.2% | 1989.96 ± 0.2% | 2.41 | 1.00 | 1.16 | 47.28 |
| class: two capitalized words, second text | 5359 | 738.21 ± 0.4% | 736.85 ± 0.2% | 23.44 ± 0.1% | 484.85 ± 0.1% | 35.17 ± 6.7% | 16.67 ± 0.5% | 63.57 ± 0.3% | 737.04 ± 0.1% | 1.00 | 1.00 | 1.52 | 20.99 |
| other: a word between two words | 6104 | 759.93 ± 0.1% | 763.76 ± 0.1% | 23.66 ± 0.3% | 739.42 ± 0.3% | 108.29 ± 9.6% | 11.29 ± 0.1% | 69.52 ± 0.4% | 756.82 ± 0.1% | 0.99 | 1.00 | 1.03 | 7.02 |
| other: a number before a unit, second text | 1481 | 5532.12 ± 0.7% | 982.61 ± 0.1% | 25.99 ± 0.1% | 5643.83 ± 0.6% | 40.69 ± 15.3% | 17.82 ± 0.2% | 66.50 ± 1.0% | 5509.91 ± 0.4% | 5.63 | 1.00 | 0.98 | 135.97 |
| other: a heading's start tag | 110 | 12557.14 ± 0.7% | 1034.91 ± 0.2% | 27.62 ± 0.3% | 1708.55 ± 0.4% | 1582.32 ± 0.7% | 16.03 ± 0.6% | 88.37 ± 0.5% | 12532.27 ± 0.7% | 12.13 | 1.00 | 7.35 | 7.94 |
| other: a whole word | 217 | 13969.46 ± 0.6% | 1038.63 ± 0.1% | 29.86 ± 0.3% | 14504.57 ± 0.8% | 49.40 ± 0.2% | 13.41 ± 0.2% | 55.84 ± 0.2% | 13950.73 ± 0.7% | 13.45 | 1.00 | 0.96 | 282.77 |
| other: a line's first word, second text | 3716 | 1959.96 ± 0.7% | 872.94 ± 0.1% | 31.31 ± 0.3% | 1725.27 ± 0.5% | 61.70 ± 7.9% | refused | refused | 1949.96 ± 0.4% | 2.25 | 1.01 | 1.14 | 31.77 |
| other: fourteen octets before an x | 87 | 19925.46 ± 0.8% | 238.65 ± 0.6% | 6.14 ± 0.1% | 4016.99 ± 0.7% | 10.64 ± 0.1% | differs | 17.66 ± 0.1% | 19879.07 ± 0.8% | 83.49 | 1.00 | 4.96 | 1873.23 |
| other: a Greek word | 21815 | 470.82 ± 0.6% | 358.37 ± 0.1% | 31.11 ± 0.1% | 289.49 ± 0.6% | 43.64 ± 11.5% | differs | refused | 467.49 ± 0.6% | 1.31 | 1.01 | 1.63 | 10.79 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.81 ± 0.3% | 25.83 ± 0.2% | 0.82 ± 0.4% | 19.64 ± 0.2% | 2.77 ± 11.5% | differs | 4.01 ± 0.2% | 25.83 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.32 |
| a UUID | 32895 | 21.06 ± 0.2% | 21.13 ± 0.2% | 0.65 ± 0.1% | 15.15 ± 0.8% | 3.08 ± 0.6% | 0.71 ± 0.5% | 3.62 ± 0.6% | 21.15 ± 0.4% | 1.00 | 1.00 | 1.39 | 6.83 |
| an IPv4 address | 33176 | 36.98 ± 0.3% | 36.83 ± 0.3% | 2.09 ± 0.3% | 28.96 ± 0.8% | 6.67 ± 0.2% | differs | 4.15 ± 0.3% | 36.96 ± 0.2% | 1.00 | 1.00 | 1.28 | 5.54 |
| a date and time | 32954 | 31.00 ± 0.3% | 31.10 ± 0.5% | 1.41 ± 0.2% | 21.12 ± 0.6% | 7.04 ± 0.4% | 1.20 ± 0.2% | 7.06 ± 0.2% | 31.03 ± 0.3% | 1.00 | 1.00 | 1.47 | 4.40 |
| a field path | 32606 | 29.47 ± 0.2% | 29.43 ± 0.1% | 1.01 ± 0.7% | 22.96 ± 0.2% | 3.53 ± 0.7% | differs | 2.92 ± 0.4% | 29.47 ± 0.1% | 1.00 | 1.00 | 1.28 | 8.36 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.52 ± 0.3% | 11.46 ± 0.4% | 11.49 ± 0.7% | 11.39 ± 0.2% | 4.91 ± 1.0% | 0.91 ± 0.5% | none | 11.54 ± 0.3% | 1.00 | 1.00 | 1.01 | 2.35 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.71 ± 0.3% | 223.28 ± 0.2% | 259.55 ± 0.2% | 86.64 ± 0.4% | 218.40 ± 2.7% | 480.49 ± 0.8% | 3766.16 ± 0.4% | 222.67 ± 0.2% | 1.00 | 1.00 | 2.57 | 1.02 |
| a UUID | 62 | 145.95 ± 0.1% | 146.12 ± 0.3% | 161.35 ± 0.2% | 46.59 ± 0.6% | 97.20 ± 9.7% | 190.45 ± 3.5% | 4474.31 ± 0.9% | 145.86 ± 0.1% | 1.00 | 1.00 | 3.13 | 1.50 |
| an IPv4 address | 29 | 439.97 ± 0.4% | 443.75 ± 0.1% | 613.73 ± 0.3% | 77.29 ± 0.5% | 128.54 ± 1.9% | 303.87 ± 0.7% | 7712.65 ± 0.5% | 439.74 ± 0.2% | 0.99 | 1.00 | 5.69 | 3.42 |
| a date and time | 56 | 318.92 ± 0.6% | 320.07 ± 0.7% | 400.72 ± 0.3% | 73.19 ± 0.5% | 133.65 ± 1.4% | 325.12 ± 1.7% | 4986.75 ± 0.5% | 318.05 ± 0.5% | 1.00 | 1.00 | 4.36 | 2.39 |
| a field path | 39 | 209.33 ± 0.5% | 210.04 ± 0.3% | 241.29 ± 0.4% | 81.06 ± 1.1% | 200.19 ± 2.8% | 503.43 ± 2.5% | 4857.29 ± 0.3% | 209.27 ± 0.4% | 1.00 | 1.00 | 2.58 | 1.05 |
| literal: a word | 7 | 667.81 ± 0.7% | 717.73 ± 0.7% | 1282.01 ± 0.6% | 527.20 ± 0.4% | 611.41 ± 0.5% | 952.47 ± 0.6% | 30654.59 ± 0.6% | 667.45 ± 0.5% | 0.93 | 1.00 | 1.27 | 1.09 |
| literal: a word that is not there | 8 | 640.16 ± 0.3% | 694.77 ± 0.3% | 1204.75 ± 0.1% | 484.80 ± 0.1% | 588.40 ± 2.6% | 902.94 ± 0.4% | 29605.24 ± 0.2% | 639.55 ± 0.3% | 0.92 | 1.00 | 1.32 | 1.09 |
| literal: one of four words | 26 | 255.96 ± 0.2% | 420.45 ± 0.4% | 567.61 ± 0.1% | 50.26 ± 1.2% | 236.57 ± 1.4% | 372.98 ± 1.1% | 15800.43 ± 0.2% | 255.93 ± 0.2% | 0.61 | 1.00 | 5.09 | 1.08 |
| literal: a word in any case | 11 | 523.63 ± 0.4% | 564.16 ± 0.6% | 871.10 ± 0.2% | 15.94 ± 1.9% | 634.97 ± 1.3% | refused | 23842.95 ± 0.7% | 523.82 ± 0.3% | 0.93 | 1.00 | 32.85 | 0.82 |
| literal: an href attribute | 12 | 351.83 ± 0.5% | 363.40 ± 0.5% | 472.54 ± 0.6% | 45.95 ± 0.5% | 487.91 ± 1.7% | 773.66 ± 1.5% | 22409.67 ± 0.2% | 351.88 ± 0.7% | 0.97 | 1.00 | 7.66 | 0.72 |
| literal: a word, second text | 10 | 594.32 ± 0.3% | 654.03 ± 0.5% | 1093.84 ± 0.1% | 404.43 ± 0.3% | 524.66 ± 1.9% | 799.95 ± 0.7% | 27513.09 ± 0.2% | 594.69 ± 0.2% | 0.91 | 1.00 | 1.47 | 1.13 |
| class: two capitalized words | 23 | 461.85 ± 0.2% | 491.68 ± 0.4% | 710.41 ± 0.2% | 99.99 ± 0.2% | 497.18 ± 1.1% | 748.12 ± 0.8% | 6391.08 ± 0.2% | 462.12 ± 0.3% | 0.94 | 1.00 | 4.62 | 0.93 |
| class: a word that ends in ing | 9 | 600.93 ± 0.3% | 668.38 ± 0.4% | 1170.72 ± 0.4% | 132.14 ± 2.0% | 742.88 ± 0.5% | 1106.41 ± 0.9% | 15984.55 ± 0.2% | 599.19 ± 0.3% | 0.90 | 1.00 | 4.55 | 0.81 |
| class: a word in capitals | 16 | 526.87 ± 0.4% | 566.58 ± 0.5% | 904.88 ± 0.7% | 135.32 ± 0.7% | 740.89 ± 1.1% | 1022.34 ± 1.3% | 8400.75 ± 0.1% | 526.93 ± 0.4% | 0.93 | 1.00 | 3.89 | 0.71 |
| class: a number | 6 | 667.80 ± 0.4% | 729.51 ± 0.6% | 1364.18 ± 0.1% | 41.90 ± 0.7% | 1383.68 ± 0.9% | 1855.96 ± 2.1% | 23172.46 ± 0.1% | 667.35 ± 0.2% | 0.92 | 1.00 | 15.94 | 0.48 |
| class: two capitalized words, second text | 23 | 461.79 ± 0.3% | 491.55 ± 0.3% | 708.76 ± 0.4% | 101.52 ± 0.3% | 494.04 ± 0.5% | 767.24 ± 0.3% | 6391.43 ± 0.1% | 461.75 ± 0.3% | 0.94 | 1.00 | 4.55 | 0.93 |
| other: a word between two words | 13 | 581.96 ± 0.2% | 601.08 ± 0.3% | 957.75 ± 0.1% | 133.80 ± 0.7% | 489.88 ± 1.9% | 811.66 ± 0.3% | 14753.36 ± 0.1% | 581.33 ± 0.3% | 0.97 | 1.00 | 4.35 | 1.19 |
| other: a number before a unit, second text | 15 | 405.55 ± 0.2% | 442.01 ± 0.5% | 609.68 ± 0.2% | 39.63 ± 0.4% | 623.61 ± 2.3% | 891.79 ± 1.3% | 15378.27 ± 0.1% | 405.48 ± 0.3% | 0.92 | 1.00 | 10.23 | 0.65 |
| other: a heading's start tag | 13 | 363.25 ± 0.4% | 367.56 ± 0.3% | 479.02 ± 0.4% | 43.93 ± 0.7% | 622.16 ± 1.7% | 877.99 ± 0.6% | 18579.25 ± 0.1% | 363.02 ± 0.2% | 0.99 | 1.00 | 8.27 | 0.58 |
| other: a whole word | 11 | 615.23 ± 0.5% | 653.79 ± 0.1% | 1085.57 ± 0.1% | 118.68 ± 0.5% | 565.34 ± 2.0% | 836.07 ± 0.6% | 26967.16 ± 0.1% | 615.58 ± 0.6% | 0.94 | 1.00 | 5.18 | 1.09 |
| other: a line's first word, second text | 17 | 561.20 ± 0.1% | 582.70 ± 0.6% | 933.34 ± 0.3% | 129.22 ± 0.3% | 712.07 ± 0.9% | refused | refused | 560.19 ± 0.5% | 0.96 | 1.00 | 4.34 | 0.79 |
| other: fourteen octets before an x | 16 | 112.83 ± 0.7% | 162.94 ± 0.6% | 186.77 ± 0.8% | 15.16 ± 0.3% | 454.23 ± 2.9% | 413.57 ± 0.3% | 13055.79 ± 0.2% | 112.93 ± 0.3% | 0.69 | 1.00 | 7.44 | 0.25 |
| other: a Greek word | 8 | 449.70 ± 0.2% | 593.36 ± 0.1% | 962.59 ± 0.3% | 59.15 ± 0.6% | 1378.76 ± 1.0% | 1789.96 ± 0.3% | refused | 449.92 ± 0.2% | 0.76 | 1.00 | 7.60 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12776.56 ± 1.2% | not timed | not timed | 16065.33 ± 0.8% | 1922.29 ± 18.2% | not timed | not timed | 12813.27 ± 1.6% | | 1.00 | 0.80 | 6.65 |
| 01-literal/sherlock-casei-en | 522 | 3881.30 ± 0.4% | not timed | not timed | 3583.55 ± 0.1% | 32.50 ± 0.2% | not timed | not timed | 3871.19 ± 0.5% | | 1.00 | 1.08 | 119.41 |
| 01-literal/sherlock-ru | 724 | 13596.11 ± 0.5% | not timed | not timed | 17258.00 ± 0.4% | 1535.45 ± 14.9% | not timed | not timed | 13610.07 ± 0.6% | | 1.00 | 0.79 | 8.85 |
| 01-literal/sherlock-casei-ru | 746 | 5236.43 ± 0.2% | not timed | not timed | 3319.24 ± 0.1% | 31.66 ± 0.2% | not timed | not timed | 5243.17 ± 0.3% | | 1.00 | 1.58 | 165.38 |
| 01-literal/sherlock-zh | 30 | 16917.29 ± 1.4% | not timed | not timed | 18410.78 ± 1.6% | 2559.79 ± 14.2% | not timed | not timed | 16890.26 ± 1.0% | | 1.00 | 0.92 | 6.61 |
| 02-literal-alternate/sherlock-en | 714 | 5833.03 ± 0.4% | not timed | not timed | 3946.35 ± 0.3% | 16.61 ± 0.1% | not timed | not timed | 5834.93 ± 0.2% | | 1.00 | 1.48 | 351.14 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1669.83 ± 0.9% | not timed | not timed | 696.84 ± 0.3% | 11.10 ± 1.0% | not timed | not timed | 1663.85 ± 0.3% | | 1.00 | 2.40 | 150.43 |
| 02-literal-alternate/sherlock-ru | 899 | 4652.81 ± 0.2% | not timed | not timed | 3257.83 ± 0.1% | 22.62 ± 0.1% | not timed | not timed | 4648.47 ± 0.1% | | 1.00 | 1.43 | 205.72 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1779.38 ± 0.7% | not timed | not timed | 1230.87 ± 0.2% | 9.15 ± 0.3% | not timed | not timed | 1776.53 ± 0.3% | | 1.00 | 1.45 | 194.47 |
| 02-literal-alternate/sherlock-zh | 207 | 7075.08 ± 0.5% | not timed | not timed | 4164.59 ± 0.1% | 31.47 ± 0.1% | not timed | not timed | 7075.06 ± 0.1% | | 1.00 | 1.70 | 224.80 |
| 03-date/ascii | 111817 | 124.76 ± 0.8% | not timed | not timed | 96.28 ± 0.0% | 0.20 ± 1.7% | not timed | not timed | 123.11 ± 0.7% | | 1.01 | 1.30 | 616.09 |
| 04-ruff-noqa/real | 84 | 554.92 ± 0.1% | not timed | not timed | 460.44 ± 0.1% | 19.66 ± 2.3% | not timed | not timed | 555.25 ± 0.2% | | 1.00 | 1.21 | 28.22 |
| 04-ruff-noqa/tweaked | 44 | 545.29 ± 0.1% | not timed | not timed | 460.45 ± 0.1% | 364.68 ± 0.4% | not timed | not timed | 544.45 ± 0.2% | | 1.00 | 1.18 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.67 ± 0.7% | not timed | not timed | 5.09 ± 0.3% | 0.20 ± 3.5% | not timed | not timed | 3.69 ± 5.8% | | 1.00 | 0.72 | 18.28 |
| 06-cloud-flare-redos/original | 107 | 270.79 ± 0.3% | not timed | not timed | 211.94 ± 0.2% | 24.78 ± 0.2% | not timed | not timed | 269.52 ± 0.2% | | 1.00 | 1.28 | 10.93 |
| 06-cloud-flare-redos/simplified-short | 102 | 264.52 ± 0.9% | not timed | not timed | 228.93 ± 0.1% | 26.62 ± 0.1% | not timed | not timed | 264.85 ± 0.3% | | 1.00 | 1.16 | 9.94 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.38 ± 0.1% | not timed | not timed | 255.76 ± 0.1% | 28.69 ± 0.1% | not timed | not timed | 294.27 ± 0.0% | | 1.00 | 1.15 | 10.26 |
| 07-unicode-character-data/parse-line | 558784 | 239.98 ± 0.3% | not timed | not timed | 168.34 ± 0.1% | 43.15 ± 5.7% | not timed | not timed | 240.74 ± 1.9% | | 1.00 | 1.43 | 5.56 |
| 08-words/all-english | 56691 | 119.64 ± 0.3% | not timed | not timed | 82.79 ± 0.0% | 12.58 ± 10.8% | not timed | not timed | 119.58 ± 0.4% | | 1.00 | 1.45 | 9.51 |
| 08-words/long-english | 839 | 1005.46 ± 0.1% | not timed | not timed | 597.74 ± 0.1% | 32.57 ± 0.8% | not timed | not timed | 1005.75 ± 0.0% | | 1.00 | 1.68 | 30.87 |
| 09-aws-keys/full | 0 | 413.00 ± 0.0% | not timed | not timed | 459.34 ± 0.1% | 64.52 ± 0.3% | not timed | not timed | 412.98 ± 0.1% | | 1.00 | 0.90 | 6.40 |
| 09-aws-keys/quick | 0 | 738.03 ± 0.1% | not timed | not timed | 992.51 ± 0.2% | 418.88 ± 1.3% | not timed | not timed | 735.29 ± 0.1% | | 1.00 | 0.74 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 634.24 ± 0.3% | not timed | not timed | 517.58 ± 0.1% | 19.52 ± 0.5% | not timed | not timed | 632.80 ± 0.4% | | 1.00 | 1.23 | 32.49 |
| 10-bounded-repeat/letters-ru | 3475 | 380.52 ± 0.2% | not timed | not timed | 477.62 ± 0.1% | 22.34 ± 17.0% | not timed | not timed | 379.51 ± 0.3% | | 1.00 | 0.80 | 17.04 |
| 10-bounded-repeat/context | 53 | 79.32 ± 1.1% | not timed | not timed | 65.52 ± 0.5% | 19.55 ± 0.5% | not timed | not timed | 79.02 ± 1.3% | | 1.00 | 1.21 | 4.06 |
| 10-bounded-repeat/capitals | 11 | 1045.56 ± 0.1% | not timed | not timed | 618.60 ± 0.0% | 36.65 ± 0.1% | not timed | not timed | 1045.02 ± 0.1% | | 1.00 | 1.69 | 28.53 |
| 11-unstructured-to-json/extract | 600 | 47.71 ± 0.1% | not timed | not timed | 77.30 ± 0.1% | 49.19 ± 0.3% | not timed | not timed | 47.05 ± 0.2% | | 1.01 | 0.62 | 0.97 |
| 12-dictionary/single | 1 | 572.13 ± 0.2% | not timed | not timed | 562.62 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 572.74 ± 0.4% | | 1.00 | 1.02 | 1422.34 |
| 14-quadratic/1x | 100 | 13.05 ± 0.2% | not timed | not timed | 10.04 ± 0.1% | 0.96 ± 2.9% | not timed | not timed | 12.99 ± 0.5% | | 1.00 | 1.30 | 13.58 |
| 14-quadratic/2x | 200 | 7.99 ± 0.3% | not timed | not timed | 5.55 ± 0.2% | 0.53 ± 1.9% | not timed | not timed | 7.99 ± 0.6% | | 1.00 | 1.44 | 15.08 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 1.86 ± 0.5% | | 1.00 | 1.54 | 16.02 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.52 ± 0.5% | not timed | not timed | 0.34 ± 0.5% | 0.55 ± 5.3% | not timed | not timed | 1.51 ± 0.9% | | 1.00 | 4.41 | 2.73 |
| 04-ruff-noqa/compile-real | 1 | 71.30 ± 0.1% | not timed | not timed | 13.87 ± 0.3% | 140.85 ± 1.9% | not timed | not timed | 71.26 ± 1.2% | | 1.00 | 5.14 | 0.51 |
| 05-lexer-veryl/compile-single | 1 | 13.49 ± 1.3% | not timed | not timed | 2.52 ± 0.4% | 6.46 ± 1.4% | not timed | not timed | 13.43 ± 1.1% | | 1.00 | 5.36 | 2.09 |
| 07-unicode-character-data/compile | 1 | 47.73 ± 0.2% | not timed | not timed | 25.95 ± 0.3% | 35.87 ± 2.3% | not timed | not timed | 47.71 ± 0.8% | | 1.00 | 1.84 | 1.33 |
| 09-aws-keys/compile-full | 1 | 38.59 ± 1.7% | not timed | not timed | 8.25 ± 0.2% | 23.58 ± 1.3% | not timed | not timed | 38.52 ± 0.3% | | 1.00 | 4.68 | 1.64 |
| 09-aws-keys/compile-quick | 1 | 178.30 ± 0.1% | not timed | not timed | 47.36 ± 0.1% | 134.61 ± 1.2% | not timed | not timed | 178.69 ± 1.1% | | 1.00 | 3.77 | 1.32 |
| 10-bounded-repeat/compile-context | 1 | 14.22 ± 0.7% | not timed | not timed | 11.17 ± 0.1% | 15.95 ± 5.5% | not timed | not timed | 14.14 ± 0.9% | | 1.01 | 1.27 | 0.89 |
| 10-bounded-repeat/compile-capitals | 1 | 82.59 ± 0.2% | not timed | not timed | 8.11 ± 0.3% | 23.85 ± 0.6% | not timed | not timed | 81.46 ± 2.1% | | 1.01 | 10.19 | 3.46 |
| 11-unstructured-to-json/compile | 1 | 76.10 ± 0.5% | not timed | not timed | 41.25 ± 0.2% | 68.65 ± 2.1% | not timed | not timed | 75.75 ± 2.0% | | 1.00 | 1.84 | 1.11 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.06 ± 35.8% | 0.09 ± 12.7% | not timed | not timed | 0.35 ± 1.3% | | 1.01 | 5.46 | 3.73 |

