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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148102727 |
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
| literal: a word | 217 | 16068.52 ± 0.9% | 1039.62 ± 0.1% | 28.65 ± 0.4% | 18225.19 ± 1.7% | 9162.07 ± 7.0% | 17.53 ± 0.3% | 86.81 ± 0.2% | 16022.66 ± 0.5% | 15.46 | 1.00 | 0.88 | 1.75 |
| literal: a word that is not there | 0 | 18498.13 ± 0.4% | 1047.92 ± 0.1% | 28.68 ± 0.2% | 19799.94 ± 1.6% | 29301.38 ± 2.7% | 17.35 ± 0.4% | 82.63 ± 0.4% | 18528.56 ± 0.9% | 17.65 | 1.00 | 0.93 | 0.63 |
| literal: one of four words | 661 | 6045.21 ± 0.5% | 1023.18 ± 0.1% | 14.67 ± 0.3% | 3937.12 ± 0.5% | 21.90 ± 0.2% | 5.29 ± 0.6% | 6.94 ± 0.2% | 6035.07 ± 0.5% | 5.91 | 1.00 | 1.54 | 276.02 |
| literal: a word in any case | 217 | 12596.25 ± 0.6% | 1040.47 ± 0.1% | 21.47 ± 1.8% | 3962.90 ± 0.4% | 38.01 ± 0.3% | refused | differs | 12572.51 ± 0.5% | 12.11 | 1.00 | 3.18 | 331.38 |
| literal: an href attribute | 33 | 13650.05 ± 0.5% | 1046.32 ± 0.2% | 27.34 ± 0.1% | 16897.12 ± 1.3% | 2257.23 ± 0.9% | 12.98 ± 0.3% | 75.67 ± 0.2% | 13638.25 ± 0.6% | 13.05 | 1.00 | 0.81 | 6.05 |
| literal: a word, second text | 123 | 16272.92 ± 1.4% | 1043.80 ± 0.2% | 28.33 ± 0.3% | 18355.19 ± 2.1% | 7575.68 ± 7.3% | 19.46 ± 1.0% | 69.80 ± 0.3% | 16447.10 ± 1.7% | 15.59 | 0.99 | 0.89 | 2.15 |
| class: two capitalized words | 1331 | 1105.50 ± 0.3% | 977.87 ± 0.2% | 26.16 ± 0.2% | 582.12 ± 0.2% | 40.53 ± 12.7% | 14.96 ± 0.3% | 68.69 ± 1.0% | 1104.68 ± 0.4% | 1.13 | 1.00 | 1.90 | 27.28 |
| class: a word that ends in ing | 3399 | 895.20 ± 0.1% | 895.83 ± 0.1% | 18.02 ± 0.4% | 545.65 ± 0.3% | 29.66 ± 3.3% | 8.19 ± 0.1% | 18.42 ± 0.5% | 893.99 ± 0.2% | 1.00 | 1.00 | 1.64 | 30.18 |
| class: a word in capitals | 2332 | 1453.65 ± 0.7% | 950.01 ± 0.2% | 27.90 ± 0.2% | 572.71 ± 0.2% | 43.42 ± 6.2% | 17.17 ± 0.3% | 83.19 ± 0.4% | 1455.10 ± 0.4% | 1.53 | 1.00 | 2.54 | 33.48 |
| class: a number | 8288 | 1991.87 ± 0.3% | 836.42 ± 0.1% | 28.03 ± 0.3% | 1718.68 ± 0.7% | 38.64 ± 14.8% | 0.57 ± 0.1% | 56.62 ± 0.4% | 1977.15 ± 0.1% | 2.38 | 1.01 | 1.16 | 51.55 |
| class: two capitalized words, second text | 5359 | 744.57 ± 0.5% | 744.52 ± 0.2% | 23.41 ± 0.1% | 484.90 ± 0.1% | 33.26 ± 14.7% | 16.96 ± 0.3% | 63.86 ± 0.9% | 743.31 ± 0.1% | 1.00 | 1.00 | 1.54 | 22.39 |
| other: a word between two words | 6104 | 752.37 ± 0.2% | 777.08 ± 0.1% | 23.61 ± 0.3% | 737.93 ± 0.2% | 108.28 ± 11.8% | 11.43 ± 0.4% | 69.82 ± 0.5% | 748.19 ± 0.1% | 0.97 | 1.01 | 1.02 | 6.95 |
| other: a number before a unit, second text | 1481 | 5422.41 ± 1.4% | 984.83 ± 0.1% | 26.09 ± 0.2% | 5558.21 ± 1.0% | 40.70 ± 9.2% | 17.95 ± 0.2% | 66.95 ± 0.4% | 5416.94 ± 0.9% | 5.51 | 1.00 | 0.98 | 133.24 |
| other: a heading's start tag | 110 | 12515.80 ± 1.6% | 1035.44 ± 0.3% | 27.60 ± 0.1% | 1709.06 ± 0.5% | 1585.73 ± 5.9% | 16.30 ± 0.1% | 89.16 ± 0.4% | 12562.03 ± 1.4% | 12.09 | 1.00 | 7.32 | 7.89 |
| other: a whole word | 217 | 14049.42 ± 0.5% | 1038.19 ± 0.7% | 29.71 ± 0.4% | 14414.45 ± 1.2% | 49.40 ± 0.4% | 13.70 ± 0.1% | 55.93 ± 0.5% | 14041.35 ± 1.0% | 13.53 | 1.00 | 0.97 | 284.39 |
| other: a line's first word, second text | 3716 | 1977.15 ± 0.8% | 877.20 ± 0.2% | 31.11 ± 0.2% | 1728.34 ± 0.3% | 61.62 ± 8.1% | refused | refused | 1965.52 ± 1.1% | 2.25 | 1.01 | 1.14 | 32.09 |
| other: fourteen octets before an x | 87 | 19932.75 ± 1.9% | 230.30 ± 0.5% | 6.59 ± 0.1% | 4050.54 ± 0.5% | 10.64 ± 0.5% | differs | 17.76 ± 0.2% | 19977.53 ± 0.4% | 86.55 | 1.00 | 4.92 | 1873.97 |
| other: a Greek word | 21815 | 513.55 ± 0.5% | 413.70 ± 0.1% | 31.18 ± 0.1% | 289.81 ± 0.3% | 44.88 ± 8.9% | differs | refused | 512.90 ± 0.4% | 1.24 | 1.00 | 1.77 | 11.44 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.81 ± 0.2% | 25.78 ± 0.1% | 0.87 ± 0.4% | 19.52 ± 0.4% | 2.77 ± 5.1% | differs | 4.00 ± 0.3% | 25.85 ± 0.1% | 1.00 | 1.00 | 1.32 | 9.32 |
| a UUID | 32895 | 21.03 ± 0.1% | 21.13 ± 0.2% | 0.65 ± 0.2% | 15.09 ± 0.6% | 3.11 ± 0.1% | 0.72 ± 0.4% | 3.59 ± 0.6% | 21.15 ± 0.1% | 1.00 | 0.99 | 1.39 | 6.77 |
| an IPv4 address | 33176 | 36.87 ± 0.2% | 36.83 ± 0.1% | 2.10 ± 0.3% | 28.92 ± 0.5% | 6.67 ± 0.1% | differs | 4.15 ± 0.3% | 36.92 ± 0.2% | 1.00 | 1.00 | 1.27 | 5.53 |
| a date and time | 32954 | 31.16 ± 0.5% | 31.20 ± 0.4% | 1.47 ± 0.2% | 21.16 ± 0.4% | 7.03 ± 0.2% | 1.19 ± 0.3% | 7.12 ± 0.2% | 31.16 ± 0.3% | 1.00 | 1.00 | 1.47 | 4.44 |
| a field path | 32606 | 29.45 ± 0.2% | 29.37 ± 0.3% | 1.03 ± 0.2% | 23.15 ± 0.4% | 3.50 ± 1.3% | differs | 2.91 ± 0.3% | 29.41 ± 0.2% | 1.00 | 1.00 | 1.27 | 8.40 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.47 ± 0.4% | 11.47 ± 0.4% | 11.44 ± 0.2% | 11.55 ± 0.2% | 4.97 ± 2.9% | 0.91 ± 0.4% | none | 11.50 ± 0.3% | 1.00 | 1.00 | 0.99 | 2.31 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 216.30 ± 0.5% | 217.13 ± 0.2% | 251.46 ± 0.5% | 87.29 ± 0.2% | 218.91 ± 1.8% | 479.92 ± 0.8% | 3879.20 ± 3.2% | 216.34 ± 0.2% | 1.00 | 1.00 | 2.48 | 0.99 |
| a UUID | 62 | 142.25 ± 0.2% | 142.55 ± 0.1% | 156.93 ± 0.1% | 46.44 ± 0.3% | 98.54 ± 0.3% | 185.14 ± 2.8% | 4438.48 ± 1.4% | 142.28 ± 0.2% | 1.00 | 1.00 | 3.06 | 1.44 |
| an IPv4 address | 29 | 436.04 ± 0.4% | 440.02 ± 0.5% | 612.03 ± 0.7% | 77.16 ± 0.5% | 130.45 ± 8.8% | 294.51 ± 0.4% | 7679.38 ± 0.2% | 435.54 ± 0.5% | 0.99 | 1.00 | 5.65 | 3.34 |
| a date and time | 56 | 318.22 ± 0.3% | 319.71 ± 0.3% | 400.91 ± 0.2% | 73.05 ± 0.5% | 138.42 ± 1.7% | 314.50 ± 1.2% | 4943.25 ± 0.6% | 318.17 ± 0.5% | 1.00 | 1.00 | 4.36 | 2.30 |
| a field path | 39 | 202.42 ± 0.1% | 203.19 ± 0.2% | 233.07 ± 0.4% | 80.73 ± 0.4% | 206.32 ± 1.5% | 500.68 ± 2.9% | 4952.66 ± 2.6% | 202.25 ± 0.2% | 1.00 | 1.00 | 2.51 | 0.98 |
| literal: a word | 7 | 659.28 ± 0.2% | 711.80 ± 0.6% | 1273.98 ± 0.1% | 526.24 ± 0.2% | 627.42 ± 2.0% | 938.59 ± 0.5% | 31118.25 ± 0.3% | 658.32 ± 0.6% | 0.93 | 1.00 | 1.25 | 1.05 |
| literal: a word that is not there | 8 | 631.41 ± 0.3% | 685.83 ± 0.4% | 1201.46 ± 0.3% | 474.44 ± 0.1% | 597.81 ± 2.2% | 882.30 ± 0.5% | 29463.10 ± 0.2% | 631.22 ± 0.2% | 0.92 | 1.00 | 1.33 | 1.06 |
| literal: one of four words | 26 | 254.09 ± 0.3% | 417.73 ± 0.5% | 564.13 ± 0.3% | 49.29 ± 0.5% | 241.75 ± 2.1% | 357.71 ± 1.6% | 15844.13 ± 0.2% | 254.04 ± 0.4% | 0.61 | 1.00 | 5.16 | 1.05 |
| literal: a word in any case | 11 | 516.77 ± 0.2% | 559.51 ± 0.2% | 863.68 ± 0.6% | 15.74 ± 0.3% | 643.18 ± 2.8% | refused | 23669.80 ± 0.2% | 516.46 ± 0.3% | 0.92 | 1.00 | 32.83 | 0.80 |
| literal: an href attribute | 12 | 348.12 ± 0.4% | 359.54 ± 0.6% | 470.64 ± 0.3% | 45.59 ± 0.9% | 497.78 ± 1.0% | 770.12 ± 0.7% | 22189.12 ± 0.3% | 348.57 ± 0.5% | 0.97 | 1.00 | 7.64 | 0.70 |
| literal: a word, second text | 10 | 584.20 ± 0.8% | 645.68 ± 0.6% | 1075.81 ± 0.8% | 426.66 ± 0.9% | 536.95 ± 2.3% | 797.69 ± 0.4% | 27422.93 ± 0.3% | 583.15 ± 0.3% | 0.90 | 1.00 | 1.37 | 1.09 |
| class: two capitalized words | 23 | 457.00 ± 0.7% | 487.39 ± 0.5% | 705.37 ± 0.5% | 100.96 ± 0.1% | 503.67 ± 2.8% | 740.96 ± 0.9% | 6617.18 ± 0.4% | 456.01 ± 0.5% | 0.94 | 1.00 | 4.53 | 0.91 |
| class: a word that ends in ing | 9 | 593.98 ± 1.0% | 660.94 ± 0.5% | 1162.37 ± 0.4% | 131.79 ± 1.4% | 758.96 ± 1.9% | 1101.32 ± 2.2% | 16310.98 ± 0.1% | 592.98 ± 0.8% | 0.90 | 1.00 | 4.51 | 0.78 |
| class: a word in capitals | 16 | 517.74 ± 0.4% | 556.33 ± 0.5% | 883.19 ± 0.5% | 135.59 ± 0.4% | 752.48 ± 1.1% | 1013.66 ± 0.3% | 8690.86 ± 0.5% | 518.71 ± 0.3% | 0.93 | 1.00 | 3.82 | 0.69 |
| class: a number | 6 | 651.85 ± 0.5% | 714.14 ± 0.2% | 1329.10 ± 0.0% | 41.84 ± 0.5% | 1407.92 ± 1.3% | 1893.51 ± 0.9% | 23083.91 ± 0.0% | 653.25 ± 0.2% | 0.91 | 1.00 | 15.58 | 0.46 |
| class: two capitalized words, second text | 23 | 458.04 ± 0.4% | 486.80 ± 0.8% | 704.88 ± 0.4% | 103.92 ± 0.4% | 503.38 ± 2.5% | 729.53 ± 0.3% | 6614.22 ± 0.3% | 458.22 ± 0.4% | 0.94 | 1.00 | 4.41 | 0.91 |
| other: a word between two words | 13 | 576.72 ± 0.4% | 596.36 ± 0.3% | 949.55 ± 0.0% | 134.91 ± 1.2% | 499.27 ± 1.8% | 795.38 ± 0.9% | 15100.98 ± 0.6% | 576.96 ± 0.4% | 0.97 | 1.00 | 4.27 | 1.16 |
| other: a number before a unit, second text | 15 | 399.09 ± 0.5% | 432.29 ± 0.6% | 595.10 ± 0.7% | 39.36 ± 0.5% | 630.10 ± 1.6% | 878.98 ± 0.4% | 15377.38 ± 0.3% | 399.81 ± 0.5% | 0.92 | 1.00 | 10.14 | 0.63 |
| other: a heading's start tag | 13 | 358.29 ± 0.4% | 362.29 ± 1.0% | 473.46 ± 0.5% | 44.50 ± 0.3% | 626.28 ± 2.7% | 859.93 ± 0.1% | 18455.62 ± 0.4% | 357.85 ± 0.2% | 0.99 | 1.00 | 8.05 | 0.57 |
| other: a whole word | 11 | 610.39 ± 0.3% | 648.54 ± 0.3% | 1087.02 ± 0.4% | 122.06 ± 0.8% | 564.52 ± 0.9% | 812.56 ± 1.3% | 26910.80 ± 0.6% | 610.38 ± 0.3% | 0.94 | 1.00 | 5.00 | 1.08 |
| other: a line's first word, second text | 17 | 552.90 ± 0.4% | 572.78 ± 0.4% | 917.04 ± 0.1% | 130.10 ± 0.2% | 712.34 ± 0.6% | refused | refused | 551.44 ± 0.5% | 0.97 | 1.00 | 4.25 | 0.78 |
| other: fourteen octets before an x | 16 | 112.49 ± 0.8% | 162.52 ± 1.0% | 185.66 ± 0.8% | 15.09 ± 0.3% | 455.64 ± 1.1% | 413.55 ± 0.5% | 12836.29 ± 0.5% | 112.50 ± 0.3% | 0.69 | 1.00 | 7.45 | 0.25 |
| other: a Greek word | 8 | 447.35 ± 0.4% | 584.95 ± 0.3% | 954.76 ± 0.5% | 59.29 ± 0.3% | 1388.66 ± 0.9% | 1786.04 ± 0.6% | refused | 447.73 ± 0.2% | 0.76 | 1.00 | 7.54 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12870.81 ± 0.9% | not timed | not timed | 16241.50 ± 1.8% | 1958.24 ± 14.4% | not timed | not timed | 12836.20 ± 0.6% | | 1.00 | 0.79 | 6.57 |
| 01-literal/sherlock-casei-en | 522 | 4489.11 ± 1.3% | not timed | not timed | 3588.57 ± 0.2% | 32.51 ± 0.5% | not timed | not timed | 4490.02 ± 0.3% | | 1.00 | 1.25 | 138.07 |
| 01-literal/sherlock-ru | 724 | 13545.39 ± 0.4% | not timed | not timed | 17306.58 ± 0.3% | 1462.81 ± 12.3% | not timed | not timed | 13532.60 ± 0.8% | | 1.00 | 0.78 | 9.26 |
| 01-literal/sherlock-casei-ru | 746 | 5286.79 ± 0.2% | not timed | not timed | 3320.05 ± 0.2% | 31.66 ± 0.2% | not timed | not timed | 5290.05 ± 0.5% | | 1.00 | 1.59 | 167.00 |
| 01-literal/sherlock-zh | 30 | 16891.87 ± 0.6% | not timed | not timed | 18519.19 ± 0.9% | 2654.89 ± 7.5% | not timed | not timed | 16895.13 ± 0.3% | | 1.00 | 0.91 | 6.36 |
| 02-literal-alternate/sherlock-en | 714 | 5764.12 ± 0.3% | not timed | not timed | 3935.76 ± 0.3% | 16.62 ± 0.1% | not timed | not timed | 5764.45 ± 0.2% | | 1.00 | 1.46 | 346.79 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1711.54 ± 1.4% | not timed | not timed | 695.96 ± 0.3% | 11.12 ± 0.1% | not timed | not timed | 1702.18 ± 0.6% | | 1.01 | 2.46 | 153.98 |
| 02-literal-alternate/sherlock-ru | 899 | 4644.97 ± 0.3% | not timed | not timed | 3255.38 ± 0.2% | 22.58 ± 0.1% | not timed | not timed | 4655.75 ± 0.1% | | 1.00 | 1.43 | 205.69 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1814.51 ± 0.5% | not timed | not timed | 1230.67 ± 0.1% | 9.14 ± 0.3% | not timed | not timed | 1806.89 ± 0.2% | | 1.00 | 1.47 | 198.62 |
| 02-literal-alternate/sherlock-zh | 207 | 7039.93 ± 0.4% | not timed | not timed | 4159.57 ± 0.3% | 31.45 ± 0.1% | not timed | not timed | 7029.61 ± 0.2% | | 1.00 | 1.69 | 223.83 |
| 03-date/ascii | 111817 | 127.39 ± 0.7% | not timed | not timed | 95.68 ± 0.1% | 0.20 ± 6.2% | not timed | not timed | 126.60 ± 0.2% | | 1.01 | 1.33 | 629.76 |
| 04-ruff-noqa/real | 84 | 553.58 ± 0.1% | not timed | not timed | 456.00 ± 0.2% | 19.62 ± 1.4% | not timed | not timed | 553.35 ± 0.1% | | 1.00 | 1.21 | 28.22 |
| 04-ruff-noqa/tweaked | 44 | 549.71 ± 0.2% | not timed | not timed | 461.40 ± 0.2% | 366.13 ± 0.6% | not timed | not timed | 548.19 ± 0.3% | | 1.00 | 1.19 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.96 ± 0.4% | not timed | not timed | 4.97 ± 0.3% | 0.20 ± 5.0% | not timed | not timed | 4.08 ± 4.9% | | 0.97 | 0.80 | 19.77 |
| 06-cloud-flare-redos/original | 107 | 263.89 ± 0.1% | not timed | not timed | 215.28 ± 0.1% | 24.91 ± 0.2% | not timed | not timed | 263.96 ± 0.2% | | 1.00 | 1.23 | 10.59 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.23 ± 0.1% | not timed | not timed | 226.51 ± 0.1% | 26.65 ± 0.2% | not timed | not timed | 259.34 ± 0.4% | | 1.00 | 1.14 | 9.73 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.09 ± 0.3% | not timed | not timed | 253.45 ± 0.1% | 28.75 ± 0.1% | not timed | not timed | 286.23 ± 0.2% | | 1.00 | 1.13 | 9.95 |
| 07-unicode-character-data/parse-line | 558784 | 238.68 ± 2.5% | not timed | not timed | 170.32 ± 0.2% | 43.28 ± 7.0% | not timed | not timed | 239.13 ± 2.0% | | 1.00 | 1.40 | 5.51 |
| 08-words/all-english | 56691 | 121.16 ± 0.5% | not timed | not timed | 83.35 ± 0.2% | 11.88 ± 10.0% | not timed | not timed | 120.82 ± 0.3% | | 1.00 | 1.45 | 10.20 |
| 08-words/long-english | 839 | 1006.88 ± 0.1% | not timed | not timed | 597.59 ± 0.2% | 32.45 ± 0.5% | not timed | not timed | 1005.30 ± 0.1% | | 1.00 | 1.68 | 31.02 |
| 09-aws-keys/full | 0 | 408.93 ± 0.0% | not timed | not timed | 465.44 ± 0.1% | 64.45 ± 3.5% | not timed | not timed | 408.39 ± 0.1% | | 1.00 | 0.88 | 6.34 |
| 09-aws-keys/quick | 0 | 735.15 ± 0.2% | not timed | not timed | 987.09 ± 0.2% | 418.24 ± 0.4% | not timed | not timed | 734.33 ± 0.1% | | 1.00 | 0.74 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 639.59 ± 0.4% | not timed | not timed | 517.82 ± 0.5% | 19.46 ± 0.5% | not timed | not timed | 637.45 ± 0.1% | | 1.00 | 1.24 | 32.86 |
| 10-bounded-repeat/letters-ru | 3475 | 385.36 ± 0.2% | not timed | not timed | 477.54 ± 0.1% | 21.74 ± 7.2% | not timed | not timed | 384.14 ± 0.6% | | 1.00 | 0.81 | 17.72 |
| 10-bounded-repeat/context | 53 | 79.09 ± 1.2% | not timed | not timed | 66.01 ± 0.6% | 19.80 ± 0.2% | not timed | not timed | 79.29 ± 1.1% | | 1.00 | 1.20 | 3.99 |
| 10-bounded-repeat/capitals | 11 | 1041.93 ± 0.3% | not timed | not timed | 617.96 ± 0.1% | 36.53 ± 0.1% | not timed | not timed | 1042.03 ± 0.2% | | 1.00 | 1.69 | 28.52 |
| 11-unstructured-to-json/extract | 600 | 49.75 ± 0.3% | not timed | not timed | 77.31 ± 0.1% | 48.87 ± 1.1% | not timed | not timed | 49.47 ± 1.2% | | 1.01 | 0.64 | 1.02 |
| 12-dictionary/single | 1 | 565.57 ± 0.5% | not timed | not timed | 561.17 ± 0.0% | 0.40 ± 0.4% | not timed | not timed | 567.38 ± 0.6% | | 1.00 | 1.01 | 1413.09 |
| 14-quadratic/1x | 100 | 9.66 ± 0.3% | not timed | not timed | 10.05 ± 0.2% | 0.98 ± 3.0% | not timed | not timed | 9.65 ± 1.2% | | 1.00 | 0.96 | 9.81 |
| 14-quadratic/2x | 200 | 5.56 ± 0.1% | not timed | not timed | 5.55 ± 0.3% | 0.53 ± 2.1% | not timed | not timed | 5.56 ± 0.4% | | 1.00 | 1.00 | 10.44 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.7% | not timed | not timed | 1.20 ± 0.2% | 0.12 ± 1.5% | not timed | not timed | 1.26 ± 0.5% | | 1.00 | 1.05 | 10.90 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.5% | not timed | not timed | 0.34 ± 0.6% | 0.55 ± 4.1% | not timed | not timed | 1.54 ± 0.6% | | 1.00 | 4.48 | 2.82 |
| 04-ruff-noqa/compile-real | 1 | 85.23 ± 0.2% | not timed | not timed | 13.87 ± 0.2% | 138.65 ± 1.1% | not timed | not timed | 84.76 ± 1.0% | | 1.01 | 6.14 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 14.53 ± 0.2% | not timed | not timed | 2.51 ± 0.8% | 6.51 ± 2.3% | not timed | not timed | 14.46 ± 1.4% | | 1.00 | 5.79 | 2.23 |
| 07-unicode-character-data/compile | 1 | 54.96 ± 0.2% | not timed | not timed | 26.14 ± 0.4% | 36.12 ± 3.0% | not timed | not timed | 54.97 ± 1.2% | | 1.00 | 2.10 | 1.52 |
| 09-aws-keys/compile-full | 1 | 42.26 ± 0.2% | not timed | not timed | 8.30 ± 0.5% | 23.54 ± 0.9% | not timed | not timed | 42.18 ± 0.2% | | 1.00 | 5.09 | 1.80 |
| 09-aws-keys/compile-quick | 1 | 188.63 ± 0.4% | not timed | not timed | 47.36 ± 0.6% | 136.14 ± 2.4% | not timed | not timed | 188.64 ± 1.1% | | 1.00 | 3.98 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 14.63 ± 1.0% | not timed | not timed | 11.15 ± 0.6% | 16.31 ± 1.8% | not timed | not timed | 14.43 ± 1.7% | | 1.01 | 1.31 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 85.22 ± 0.9% | not timed | not timed | 8.10 ± 0.2% | 23.94 ± 2.5% | not timed | not timed | 84.68 ± 1.6% | | 1.01 | 10.52 | 3.56 |
| 11-unstructured-to-json/compile | 1 | 86.29 ± 0.1% | not timed | not timed | 40.42 ± 0.9% | 68.36 ± 2.9% | not timed | not timed | 85.68 ± 0.5% | | 1.01 | 2.13 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.4% | not timed | not timed | 0.07 ± 7.0% | 0.10 ± 27.6% | not timed | not timed | 0.36 ± 0.9% | | 1.01 | 5.18 | 3.65 |

