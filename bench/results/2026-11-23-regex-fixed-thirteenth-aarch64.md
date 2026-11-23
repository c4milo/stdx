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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159314380 |
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
| literal: a word | 217 | 16016.06 ± 0.7% | 1049.78 ± 0.1% | 28.38 ± 0.2% | 18288.53 ± 0.9% | 9150.15 ± 9.4% | 17.53 ± 0.3% | 86.85 ± 0.0% | 16069.83 ± 1.2% | 15.26 | 1.00 | 0.88 | 1.75 |
| literal: a word that is not there | 0 | 18716.17 ± 1.8% | 1058.15 ± 0.1% | 28.45 ± 0.4% | 19892.30 ± 2.5% | 29353.31 ± 1.0% | 17.34 ± 0.3% | 82.74 ± 0.1% | 18777.87 ± 4.5% | 17.69 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6078.69 ± 0.4% | 1031.33 ± 0.2% | 14.64 ± 0.3% | 3947.32 ± 0.7% | 21.86 ± 0.1% | 5.29 ± 0.1% | 6.90 ± 0.4% | 6057.82 ± 0.4% | 5.89 | 1.00 | 1.54 | 278.03 |
| literal: a word in any case | 217 | 12635.12 ± 0.6% | 1048.50 ± 0.1% | 21.71 ± 1.0% | 3969.81 ± 0.2% | 38.05 ± 0.2% | refused | differs | 12601.74 ± 0.6% | 12.05 | 1.00 | 3.18 | 332.02 |
| literal: an href attribute | 33 | 13613.54 ± 0.7% | 1055.60 ± 0.2% | 27.14 ± 0.2% | 17029.31 ± 2.1% | 2252.52 ± 4.9% | 13.38 ± 0.2% | 75.68 ± 0.2% | 13623.73 ± 0.8% | 12.90 | 1.00 | 0.80 | 6.04 |
| literal: a word, second text | 123 | 16386.27 ± 0.6% | 1051.45 ± 0.4% | 28.09 ± 0.4% | 18421.58 ± 1.3% | 7714.75 ± 4.3% | 19.75 ± 0.4% | 69.72 ± 0.9% | 16401.38 ± 0.8% | 15.58 | 1.00 | 0.89 | 2.12 |
| class: two capitalized words | 1331 | 1121.61 ± 0.5% | 980.16 ± 0.1% | 26.03 ± 0.4% | 585.27 ± 0.4% | 40.58 ± 7.6% | 14.74 ± 0.2% | 68.55 ± 0.4% | 1122.64 ± 0.4% | 1.14 | 1.00 | 1.92 | 27.64 |
| class: a word that ends in ing | 3399 | 902.31 ± 0.2% | 902.76 ± 0.1% | 18.06 ± 0.1% | 548.03 ± 0.1% | 29.60 ± 6.2% | 8.23 ± 0.1% | 18.28 ± 1.1% | 900.98 ± 0.1% | 1.00 | 1.00 | 1.65 | 30.48 |
| class: a word in capitals | 2332 | 1460.32 ± 0.9% | 957.37 ± 0.1% | 27.71 ± 0.5% | 572.56 ± 0.1% | 43.63 ± 0.3% | 17.18 ± 0.1% | 83.31 ± 0.4% | 1457.87 ± 0.6% | 1.53 | 1.00 | 2.55 | 33.47 |
| class: a number | 8288 | 2010.11 ± 0.3% | 840.99 ± 0.1% | 27.84 ± 0.2% | 1720.49 ± 0.1% | 41.60 ± 8.2% | 0.56 ± 0.1% | 56.68 ± 0.4% | 2007.90 ± 0.3% | 2.39 | 1.00 | 1.17 | 48.32 |
| class: two capitalized words, second text | 5359 | 744.76 ± 0.1% | 745.33 ± 0.1% | 23.29 ± 0.2% | 485.12 ± 0.1% | 32.79 ± 9.8% | 16.73 ± 0.1% | 63.91 ± 0.2% | 744.38 ± 0.1% | 1.00 | 1.00 | 1.54 | 22.71 |
| other: a word between two words | 6104 | 753.84 ± 0.4% | 781.00 ± 0.0% | 23.51 ± 0.2% | 736.58 ± 0.2% | 101.94 ± 17.0% | 11.30 ± 0.1% | 69.80 ± 0.2% | 752.48 ± 0.1% | 0.97 | 1.00 | 1.02 | 7.39 |
| other: a number before a unit, second text | 1481 | 5389.13 ± 0.3% | 991.76 ± 0.1% | 25.91 ± 0.1% | 5675.26 ± 0.4% | 40.72 ± 11.0% | 17.83 ± 0.2% | 66.99 ± 0.2% | 5391.16 ± 0.4% | 5.43 | 1.00 | 0.95 | 132.35 |
| other: a heading's start tag | 110 | 12640.94 ± 0.7% | 1042.62 ± 0.1% | 27.33 ± 0.3% | 1713.15 ± 0.2% | 1585.66 ± 0.8% | 16.29 ± 0.5% | 89.01 ± 0.4% | 12675.50 ± 0.6% | 12.12 | 1.00 | 7.38 | 7.97 |
| other: a whole word | 217 | 14043.59 ± 1.2% | 1047.41 ± 0.3% | 29.28 ± 0.3% | 14474.99 ± 0.5% | 49.35 ± 9.6% | 13.64 ± 0.4% | 55.85 ± 0.4% | 14022.19 ± 0.2% | 13.41 | 1.00 | 0.97 | 284.58 |
| other: a line's first word, second text | 3716 | 1972.77 ± 0.9% | 879.42 ± 0.2% | 30.87 ± 0.1% | 1725.09 ± 0.7% | 63.33 ± 5.1% | refused | refused | 1957.49 ± 0.1% | 2.24 | 1.01 | 1.14 | 31.15 |
| other: fourteen octets before an x | 87 | 19871.77 ± 1.7% | 244.78 ± 0.7% | 6.63 ± 0.1% | 4050.99 ± 0.3% | 10.64 ± 0.2% | differs | 17.74 ± 0.3% | 19935.10 ± 0.9% | 81.18 | 1.00 | 4.91 | 1867.36 |
| other: a Greek word | 21815 | 513.03 ± 0.3% | 413.43 ± 0.5% | 30.92 ± 1.3% | 281.31 ± 0.4% | 49.01 ± 11.1% | differs | refused | 512.91 ± 0.4% | 1.24 | 1.00 | 1.82 | 10.47 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.89 ± 0.2% | 25.82 ± 0.3% | 0.88 ± 0.3% | 19.78 ± 0.7% | 2.78 ± 1.1% | differs | 4.02 ± 0.1% | 25.94 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.31 |
| a UUID | 32895 | 21.09 ± 0.2% | 21.19 ± 0.2% | 0.65 ± 0.2% | 15.13 ± 0.5% | 3.09 ± 0.4% | 0.72 ± 0.5% | 3.59 ± 0.4% | 21.21 ± 0.1% | 1.00 | 0.99 | 1.39 | 6.82 |
| an IPv4 address | 33176 | 36.97 ± 0.3% | 36.87 ± 0.4% | 2.12 ± 0.2% | 28.92 ± 0.5% | 6.61 ± 0.3% | differs | 4.13 ± 0.3% | 36.93 ± 0.4% | 1.00 | 1.00 | 1.28 | 5.60 |
| a date and time | 32954 | 31.08 ± 0.5% | 31.15 ± 0.3% | 1.48 ± 0.8% | 21.09 ± 0.7% | 7.04 ± 0.1% | 1.20 ± 0.2% | 7.11 ± 0.3% | 31.11 ± 0.3% | 1.00 | 1.00 | 1.47 | 4.42 |
| a field path | 32606 | 29.51 ± 0.2% | 29.41 ± 0.2% | 1.04 ± 0.3% | 23.02 ± 0.1% | 3.49 ± 0.5% | differs | 2.95 ± 0.3% | 29.46 ± 0.1% | 1.00 | 1.00 | 1.28 | 8.45 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.49 ± 0.5% | 11.54 ± 0.6% | 11.47 ± 0.6% | 11.50 ± 0.1% | 4.93 ± 1.7% | 0.91 ± 0.4% | none | 11.54 ± 0.2% | 1.00 | 1.00 | 1.00 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 216.66 ± 0.3% | 217.33 ± 0.5% | 251.91 ± 0.2% | 86.89 ± 0.7% | 221.50 ± 2.0% | 480.85 ± 1.0% | 3879.30 ± 1.5% | 216.48 ± 0.4% | 1.00 | 1.00 | 2.49 | 0.98 |
| a UUID | 62 | 142.54 ± 0.2% | 142.74 ± 0.2% | 157.44 ± 0.2% | 46.65 ± 0.8% | 100.51 ± 0.3% | 190.75 ± 2.8% | 4461.07 ± 1.9% | 142.55 ± 0.2% | 1.00 | 1.00 | 3.06 | 1.42 |
| an IPv4 address | 29 | 436.09 ± 0.7% | 439.78 ± 0.9% | 612.01 ± 1.2% | 77.34 ± 0.5% | 133.06 ± 1.2% | 302.84 ± 1.6% | 7686.84 ± 0.2% | 437.02 ± 0.5% | 0.99 | 1.00 | 5.64 | 3.28 |
| a date and time | 56 | 319.61 ± 0.2% | 320.89 ± 0.3% | 403.32 ± 0.1% | 73.33 ± 0.4% | 138.99 ± 2.0% | 324.99 ± 1.3% | 4932.72 ± 0.5% | 319.39 ± 0.3% | 1.00 | 1.00 | 4.36 | 2.30 |
| a field path | 39 | 202.80 ± 0.2% | 203.42 ± 0.2% | 233.20 ± 0.3% | 81.24 ± 1.0% | 207.62 ± 0.8% | 498.81 ± 2.9% | 4976.35 ± 0.4% | 202.68 ± 0.3% | 1.00 | 1.00 | 2.50 | 0.98 |
| literal: a word | 7 | 659.72 ± 0.3% | 711.42 ± 0.4% | 1264.30 ± 0.1% | 526.73 ± 0.2% | 631.22 ± 2.1% | 956.16 ± 0.4% | 31153.53 ± 0.1% | 660.45 ± 0.2% | 0.93 | 1.00 | 1.25 | 1.05 |
| literal: a word that is not there | 8 | 631.59 ± 0.3% | 685.06 ± 0.2% | 1186.19 ± 0.7% | 484.15 ± 0.5% | 601.75 ± 2.5% | 904.31 ± 0.3% | 29435.57 ± 0.2% | 631.66 ± 0.3% | 0.92 | 1.00 | 1.30 | 1.05 |
| literal: one of four words | 26 | 254.58 ± 0.2% | 417.92 ± 0.3% | 564.41 ± 0.2% | 50.29 ± 1.3% | 241.31 ± 2.0% | 374.30 ± 1.4% | 15855.02 ± 0.3% | 254.39 ± 0.3% | 0.61 | 1.00 | 5.06 | 1.06 |
| literal: a word in any case | 11 | 516.59 ± 0.3% | 558.39 ± 0.5% | 861.18 ± 0.3% | 15.88 ± 1.7% | 644.19 ± 5.0% | refused | 23629.21 ± 0.2% | 517.15 ± 0.3% | 0.93 | 1.00 | 32.54 | 0.80 |
| literal: an href attribute | 12 | 347.30 ± 0.5% | 358.77 ± 0.5% | 465.98 ± 0.4% | 45.80 ± 0.9% | 500.99 ± 1.6% | 772.51 ± 1.5% | 22171.62 ± 0.2% | 347.05 ± 0.4% | 0.97 | 1.00 | 7.58 | 0.69 |
| literal: a word, second text | 10 | 587.65 ± 0.2% | 644.60 ± 0.9% | 1078.50 ± 0.1% | 403.52 ± 0.2% | 540.43 ± 1.0% | 799.04 ± 0.5% | 27415.73 ± 0.3% | 587.81 ± 0.2% | 0.91 | 1.00 | 1.46 | 1.09 |
| class: two capitalized words | 23 | 458.02 ± 0.1% | 487.27 ± 0.4% | 705.63 ± 0.5% | 100.29 ± 0.1% | 507.81 ± 1.0% | 746.55 ± 0.4% | 6617.89 ± 0.4% | 458.54 ± 0.3% | 0.94 | 1.00 | 4.57 | 0.90 |
| class: a word that ends in ing | 9 | 594.30 ± 0.2% | 660.77 ± 0.4% | 1161.84 ± 0.2% | 132.90 ± 1.8% | 756.98 ± 4.4% | 1107.20 ± 0.6% | 16319.48 ± 0.2% | 594.61 ± 0.3% | 0.90 | 1.00 | 4.47 | 0.79 |
| class: a word in capitals | 16 | 519.34 ± 0.5% | 556.83 ± 0.3% | 884.50 ± 0.4% | 135.74 ± 0.6% | 751.52 ± 1.2% | 1025.46 ± 0.8% | 8706.20 ± 0.2% | 519.48 ± 0.3% | 0.93 | 1.00 | 3.83 | 0.69 |
| class: a number | 6 | 651.82 ± 0.4% | 712.04 ± 0.4% | 1327.49 ± 0.1% | 41.94 ± 0.6% | 1403.56 ± 1.0% | 1858.02 ± 1.5% | 23069.94 ± 0.2% | 653.06 ± 0.4% | 0.92 | 1.00 | 15.54 | 0.46 |
| class: two capitalized words, second text | 23 | 457.69 ± 0.4% | 487.00 ± 0.5% | 705.73 ± 0.1% | 101.54 ± 0.3% | 504.54 ± 1.1% | 764.72 ± 0.9% | 6624.52 ± 0.3% | 457.78 ± 0.3% | 0.94 | 1.00 | 4.51 | 0.91 |
| other: a word between two words | 13 | 575.21 ± 0.2% | 593.41 ± 0.4% | 943.49 ± 0.4% | 133.22 ± 0.7% | 503.25 ± 2.4% | 814.50 ± 0.7% | 15114.42 ± 0.1% | 574.38 ± 0.4% | 0.97 | 1.00 | 4.32 | 1.14 |
| other: a number before a unit, second text | 15 | 399.62 ± 0.2% | 434.08 ± 0.2% | 596.88 ± 0.3% | 39.66 ± 0.4% | 632.27 ± 1.3% | 894.70 ± 1.0% | 15366.26 ± 0.3% | 399.84 ± 0.3% | 0.92 | 1.00 | 10.08 | 0.63 |
| other: a heading's start tag | 13 | 358.64 ± 0.8% | 363.80 ± 0.2% | 474.38 ± 0.3% | 43.90 ± 0.4% | 623.48 ± 1.7% | 881.68 ± 0.9% | 18463.02 ± 0.4% | 358.86 ± 0.2% | 0.99 | 1.00 | 8.17 | 0.58 |
| other: a whole word | 11 | 610.51 ± 0.2% | 649.19 ± 0.6% | 1082.42 ± 0.4% | 118.10 ± 0.4% | 562.81 ± 7.0% | 835.02 ± 1.2% | 27090.60 ± 0.9% | 610.37 ± 0.1% | 0.94 | 1.00 | 5.17 | 1.08 |
| other: a line's first word, second text | 17 | 552.43 ± 0.6% | 572.94 ± 0.5% | 920.35 ± 0.2% | 129.68 ± 0.2% | 713.80 ± 0.6% | refused | refused | 549.21 ± 0.6% | 0.96 | 1.01 | 4.26 | 0.77 |
| other: fourteen octets before an x | 16 | 112.31 ± 0.7% | 162.77 ± 0.7% | 186.05 ± 0.5% | 15.15 ± 0.2% | 454.50 ± 0.8% | 415.63 ± 0.6% | 12899.86 ± 1.7% | 112.46 ± 0.5% | 0.69 | 1.00 | 7.42 | 0.25 |
| other: a Greek word | 8 | 447.83 ± 0.2% | 587.18 ± 0.7% | 955.86 ± 0.1% | 59.47 ± 0.2% | 1390.27 ± 4.1% | 1797.83 ± 1.6% | refused | 448.52 ± 0.2% | 0.76 | 1.00 | 7.53 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12951.23 ± 0.6% | not timed | not timed | 16418.71 ± 1.3% | 2140.43 ± 18.2% | not timed | not timed | 12946.85 ± 0.7% | | 1.00 | 0.79 | 6.05 |
| 01-literal/sherlock-casei-en | 522 | 4489.22 ± 0.7% | not timed | not timed | 3595.51 ± 0.2% | 32.52 ± 0.1% | not timed | not timed | 4471.51 ± 0.5% | | 1.00 | 1.25 | 138.04 |
| 01-literal/sherlock-ru | 724 | 13512.68 ± 0.4% | not timed | not timed | 17324.24 ± 0.7% | 1477.37 ± 10.3% | not timed | not timed | 13518.20 ± 0.7% | | 1.00 | 0.78 | 9.15 |
| 01-literal/sherlock-casei-ru | 746 | 5302.42 ± 0.3% | not timed | not timed | 3333.09 ± 0.1% | 31.75 ± 0.3% | not timed | not timed | 5297.61 ± 0.2% | | 1.00 | 1.59 | 167.01 |
| 01-literal/sherlock-zh | 30 | 17132.39 ± 0.6% | not timed | not timed | 18668.45 ± 1.2% | 2828.67 ± 8.0% | not timed | not timed | 17113.96 ± 0.7% | | 1.00 | 0.92 | 6.06 |
| 02-literal-alternate/sherlock-en | 714 | 5775.21 ± 0.3% | not timed | not timed | 3943.49 ± 0.3% | 16.65 ± 0.1% | not timed | not timed | 5778.19 ± 0.2% | | 1.00 | 1.46 | 346.96 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1711.57 ± 1.3% | not timed | not timed | 697.14 ± 0.3% | 11.11 ± 0.1% | not timed | not timed | 1703.14 ± 0.8% | | 1.00 | 2.46 | 154.07 |
| 02-literal-alternate/sherlock-ru | 899 | 4654.01 ± 0.2% | not timed | not timed | 3257.42 ± 0.1% | 22.21 ± 0.1% | not timed | not timed | 4655.96 ± 0.1% | | 1.00 | 1.43 | 209.59 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1808.60 ± 0.8% | not timed | not timed | 1232.51 ± 0.2% | 9.13 ± 0.2% | not timed | not timed | 1804.67 ± 0.2% | | 1.00 | 1.47 | 198.05 |
| 02-literal-alternate/sherlock-zh | 207 | 7071.86 ± 0.1% | not timed | not timed | 4164.67 ± 0.1% | 31.53 ± 0.3% | not timed | not timed | 7068.65 ± 0.3% | | 1.00 | 1.70 | 224.27 |
| 03-date/ascii | 111817 | 126.91 ± 0.6% | not timed | not timed | 96.59 ± 0.1% | 0.20 ± 3.8% | not timed | not timed | 126.07 ± 1.1% | | 1.01 | 1.31 | 622.82 |
| 04-ruff-noqa/real | 84 | 555.57 ± 0.1% | not timed | not timed | 461.59 ± 0.3% | 19.55 ± 2.1% | not timed | not timed | 555.84 ± 0.1% | | 1.00 | 1.20 | 28.42 |
| 04-ruff-noqa/tweaked | 44 | 543.62 ± 0.3% | not timed | not timed | 458.52 ± 0.1% | 366.98 ± 0.6% | not timed | not timed | 541.92 ± 0.1% | | 1.00 | 1.19 | 1.48 |
| 05-lexer-veryl/single | 124800 | 3.98 ± 0.4% | not timed | not timed | 4.97 ± 0.3% | 0.21 ± 1.9% | not timed | not timed | 4.09 ± 0.4% | | 0.97 | 0.80 | 19.31 |
| 06-cloud-flare-redos/original | 107 | 260.61 ± 0.2% | not timed | not timed | 212.10 ± 0.1% | 24.96 ± 0.3% | not timed | not timed | 260.16 ± 0.1% | | 1.00 | 1.23 | 10.44 |
| 06-cloud-flare-redos/simplified-short | 102 | 254.90 ± 0.1% | not timed | not timed | 228.84 ± 0.1% | 26.76 ± 0.1% | not timed | not timed | 254.81 ± 0.1% | | 1.00 | 1.11 | 9.52 |
| 06-cloud-flare-redos/simplified-long | 10000 | 291.89 ± 0.2% | not timed | not timed | 255.47 ± 0.1% | 28.84 ± 0.1% | not timed | not timed | 292.08 ± 0.1% | | 1.00 | 1.14 | 10.12 |
| 07-unicode-character-data/parse-line | 558784 | 238.46 ± 0.3% | not timed | not timed | 172.72 ± 0.1% | 42.76 ± 4.6% | not timed | not timed | 240.36 ± 2.3% | | 0.99 | 1.38 | 5.58 |
| 08-words/all-english | 56691 | 121.82 ± 0.2% | not timed | not timed | 82.97 ± 0.3% | 12.00 ± 5.5% | not timed | not timed | 121.49 ± 0.5% | | 1.00 | 1.47 | 10.16 |
| 08-words/long-english | 839 | 1013.26 ± 0.1% | not timed | not timed | 597.73 ± 0.1% | 32.52 ± 0.2% | not timed | not timed | 1012.04 ± 0.2% | | 1.00 | 1.70 | 31.15 |
| 09-aws-keys/full | 0 | 408.66 ± 0.0% | not timed | not timed | 465.80 ± 0.1% | 64.63 ± 3.4% | not timed | not timed | 407.56 ± 0.1% | | 1.00 | 0.88 | 6.32 |
| 09-aws-keys/quick | 0 | 730.37 ± 0.3% | not timed | not timed | 988.22 ± 0.2% | 417.84 ± 0.4% | not timed | not timed | 737.46 ± 0.1% | | 0.99 | 0.74 | 1.75 |
| 10-bounded-repeat/letters-en | 1833 | 636.13 ± 0.4% | not timed | not timed | 516.96 ± 0.7% | 19.63 ± 0.2% | not timed | not timed | 635.98 ± 0.2% | | 1.00 | 1.23 | 32.41 |
| 10-bounded-repeat/letters-ru | 3475 | 383.15 ± 0.1% | not timed | not timed | 477.79 ± 0.2% | 21.95 ± 16.8% | not timed | not timed | 381.11 ± 1.4% | | 1.01 | 0.80 | 17.46 |
| 10-bounded-repeat/context | 53 | 80.09 ± 1.3% | not timed | not timed | 65.97 ± 0.4% | 19.82 ± 0.4% | not timed | not timed | 80.22 ± 1.1% | | 1.00 | 1.21 | 4.04 |
| 10-bounded-repeat/capitals | 11 | 1055.22 ± 0.1% | not timed | not timed | 618.27 ± 0.1% | 36.49 ± 0.1% | not timed | not timed | 1054.52 ± 0.1% | | 1.00 | 1.71 | 28.92 |
| 11-unstructured-to-json/extract | 600 | 49.96 ± 0.1% | not timed | not timed | 77.82 ± 0.1% | 49.46 ± 1.0% | not timed | not timed | 49.46 ± 0.7% | | 1.01 | 0.64 | 1.01 |
| 12-dictionary/single | 1 | 568.12 ± 0.5% | not timed | not timed | 562.51 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 570.62 ± 1.0% | | 1.00 | 1.01 | 1410.84 |
| 14-quadratic/1x | 100 | 12.80 ± 0.1% | not timed | not timed | 10.03 ± 0.2% | 0.96 ± 2.2% | not timed | not timed | 12.78 ± 1.2% | | 1.00 | 1.28 | 13.30 |
| 14-quadratic/2x | 200 | 7.92 ± 0.3% | not timed | not timed | 5.52 ± 0.3% | 0.53 ± 1.6% | not timed | not timed | 7.89 ± 1.7% | | 1.00 | 1.44 | 14.81 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.4% | not timed | not timed | 1.88 ± 1.2% | | 1.00 | 1.55 | 16.32 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.5% | not timed | not timed | 0.35 ± 0.3% | 0.56 ± 2.2% | not timed | not timed | 1.53 ± 1.2% | | 1.01 | 4.47 | 2.76 |
| 04-ruff-noqa/compile-real | 1 | 85.41 ± 0.2% | not timed | not timed | 13.90 ± 0.3% | 140.96 ± 1.2% | not timed | not timed | 84.65 ± 1.2% | | 1.01 | 6.14 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 14.49 ± 0.2% | not timed | not timed | 2.53 ± 0.5% | 6.51 ± 2.6% | not timed | not timed | 14.45 ± 1.5% | | 1.00 | 5.74 | 2.23 |
| 07-unicode-character-data/compile | 1 | 54.92 ± 0.3% | not timed | not timed | 26.08 ± 0.2% | 36.28 ± 4.4% | not timed | not timed | 54.70 ± 1.2% | | 1.00 | 2.11 | 1.51 |
| 09-aws-keys/compile-full | 1 | 42.19 ± 0.1% | not timed | not timed | 8.33 ± 0.3% | 23.65 ± 1.5% | not timed | not timed | 42.10 ± 0.3% | | 1.00 | 5.06 | 1.78 |
| 09-aws-keys/compile-quick | 1 | 188.79 ± 0.2% | not timed | not timed | 48.14 ± 0.2% | 136.80 ± 3.5% | not timed | not timed | 188.69 ± 1.0% | | 1.00 | 3.92 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 14.57 ± 0.7% | not timed | not timed | 11.28 ± 0.3% | 16.28 ± 2.3% | not timed | not timed | 14.55 ± 1.3% | | 1.00 | 1.29 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 85.21 ± 0.2% | not timed | not timed | 8.16 ± 0.2% | 24.32 ± 1.2% | not timed | not timed | 84.81 ± 0.8% | | 1.00 | 10.44 | 3.50 |
| 11-unstructured-to-json/compile | 1 | 86.26 ± 0.3% | not timed | not timed | 40.87 ± 0.5% | 68.71 ± 2.2% | not timed | not timed | 85.44 ± 1.2% | | 1.01 | 2.11 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.4% | not timed | not timed | 0.07 ± 1.3% | 0.10 ± 26.7% | not timed | not timed | 0.36 ± 2.1% | | 1.01 | 5.20 | 3.61 |

