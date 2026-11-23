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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159319674 |
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
| literal: a word | 217 | 15744.31 ± 1.0% | 1047.79 ± 0.4% | 28.35 ± 0.3% | 17621.08 ± 3.0% | 8929.18 ± 9.7% | 17.52 ± 0.2% | 86.85 ± 0.5% | 15683.70 ± 1.8% | 15.03 | 1.00 | 0.89 | 1.76 |
| literal: a word that is not there | 0 | 18356.38 ± 2.2% | 1055.62 ± 0.2% | 28.49 ± 0.3% | 19347.05 ± 2.2% | 27936.57 ± 2.9% | 17.36 ± 0.1% | 82.62 ± 0.2% | 18430.38 ± 2.3% | 17.39 | 1.00 | 0.95 | 0.66 |
| literal: one of four words | 661 | 6063.60 ± 1.0% | 1030.30 ± 0.3% | 14.64 ± 0.2% | 3939.78 ± 0.2% | 21.87 ± 0.2% | 5.29 ± 0.2% | 6.91 ± 0.4% | 6027.88 ± 0.5% | 5.89 | 1.01 | 1.54 | 277.27 |
| literal: a word in any case | 217 | 12538.88 ± 0.6% | 1048.14 ± 0.2% | 21.70 ± 2.0% | 3948.76 ± 0.4% | 38.03 ± 0.3% | refused | differs | 12529.48 ± 0.3% | 11.96 | 1.00 | 3.18 | 329.69 |
| literal: an href attribute | 33 | 13501.11 ± 1.5% | 1055.17 ± 0.2% | 27.18 ± 0.5% | 17095.08 ± 2.1% | 2251.27 ± 6.5% | 13.39 ± 0.3% | 75.64 ± 0.3% | 13544.92 ± 1.6% | 12.80 | 1.00 | 0.79 | 6.00 |
| literal: a word, second text | 123 | 16351.04 ± 1.7% | 1050.83 ± 0.1% | 28.12 ± 0.4% | 18051.43 ± 3.7% | 7609.11 ± 4.2% | 19.77 ± 0.4% | 69.64 ± 0.5% | 16466.23 ± 1.8% | 15.56 | 0.99 | 0.91 | 2.15 |
| class: two capitalized words | 1331 | 1124.55 ± 1.0% | 978.74 ± 0.1% | 26.04 ± 0.3% | 584.17 ± 0.1% | 40.60 ± 13.4% | 14.89 ± 0.3% | 68.92 ± 0.2% | 1122.29 ± 0.4% | 1.15 | 1.00 | 1.93 | 27.70 |
| class: a word that ends in ing | 3399 | 901.21 ± 0.3% | 901.68 ± 0.1% | 18.06 ± 0.1% | 546.21 ± 0.1% | 29.59 ± 2.5% | 8.23 ± 0.2% | 18.41 ± 0.7% | 899.88 ± 0.1% | 1.00 | 1.00 | 1.65 | 30.46 |
| class: a word in capitals | 2332 | 1451.03 ± 0.3% | 955.72 ± 0.1% | 27.72 ± 0.3% | 570.79 ± 0.3% | 43.57 ± 0.3% | 17.18 ± 0.1% | 83.16 ± 0.3% | 1460.10 ± 0.3% | 1.52 | 0.99 | 2.54 | 33.31 |
| class: a number | 8288 | 2007.31 ± 0.3% | 838.33 ± 0.1% | 27.85 ± 0.1% | 1680.97 ± 0.1% | 41.84 ± 9.7% | 0.56 ± 0.3% | 56.67 ± 0.5% | 2004.80 ± 0.2% | 2.39 | 1.00 | 1.19 | 47.98 |
| class: two capitalized words, second text | 5359 | 744.87 ± 0.0% | 745.04 ± 0.1% | 23.33 ± 0.2% | 483.30 ± 0.1% | 31.11 ± 13.7% | 16.72 ± 0.1% | 64.01 ± 0.2% | 743.72 ± 0.1% | 1.00 | 1.00 | 1.54 | 23.94 |
| other: a word between two words | 6104 | 754.10 ± 0.1% | 780.41 ± 0.1% | 23.48 ± 0.5% | 729.58 ± 0.3% | 104.48 ± 11.9% | 11.31 ± 0.1% | 69.87 ± 0.3% | 751.13 ± 0.2% | 0.97 | 1.00 | 1.03 | 7.22 |
| other: a number before a unit, second text | 1481 | 5381.81 ± 0.5% | 988.53 ± 0.1% | 25.93 ± 0.2% | 5650.55 ± 0.6% | 40.67 ± 9.9% | 17.84 ± 0.2% | 66.98 ± 0.3% | 5394.45 ± 0.4% | 5.44 | 1.00 | 0.95 | 132.32 |
| other: a heading's start tag | 110 | 12536.96 ± 0.7% | 1044.22 ± 0.1% | 27.41 ± 0.2% | 1713.47 ± 0.8% | 1579.58 ± 0.6% | 16.33 ± 0.2% | 88.89 ± 0.8% | 12503.61 ± 0.4% | 12.01 | 1.00 | 7.32 | 7.94 |
| other: a whole word | 217 | 13762.24 ± 0.9% | 1046.45 ± 0.3% | 29.42 ± 0.2% | 13951.89 ± 0.8% | 49.39 ± 7.7% | 13.68 ± 0.4% | 55.91 ± 0.1% | 13723.41 ± 1.2% | 13.15 | 1.00 | 0.99 | 278.63 |
| other: a line's first word, second text | 3716 | 1962.40 ± 0.6% | 879.08 ± 0.1% | 30.82 ± 0.3% | 1730.90 ± 0.4% | 61.77 ± 7.0% | refused | refused | 1951.09 ± 0.7% | 2.23 | 1.01 | 1.13 | 31.77 |
| other: fourteen octets before an x | 87 | 19212.10 ± 2.8% | 211.28 ± 0.5% | 6.64 ± 0.1% | 4029.47 ± 0.5% | 10.65 ± 0.1% | differs | 17.78 ± 0.1% | 19111.18 ± 0.8% | 90.93 | 1.01 | 4.77 | 1804.05 |
| other: a Greek word | 21815 | 513.32 ± 0.7% | 413.08 ± 0.3% | 31.08 ± 1.3% | 286.41 ± 0.3% | 47.92 ± 6.7% | differs | refused | 513.30 ± 0.2% | 1.24 | 1.00 | 1.79 | 10.71 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.88 ± 0.1% | 25.86 ± 0.2% | 0.87 ± 0.1% | 19.71 ± 0.3% | 2.76 ± 0.3% | differs | 4.02 ± 0.3% | 25.90 ± 0.3% | 1.00 | 1.00 | 1.31 | 9.37 |
| a UUID | 32895 | 21.09 ± 0.2% | 21.18 ± 0.4% | 0.65 ± 0.1% | 15.12 ± 0.6% | 3.10 ± 0.1% | 0.72 ± 0.4% | 3.59 ± 0.7% | 21.20 ± 0.3% | 1.00 | 0.99 | 1.40 | 6.80 |
| an IPv4 address | 33176 | 36.92 ± 0.4% | 36.89 ± 0.3% | 2.13 ± 0.1% | 28.94 ± 0.8% | 6.64 ± 0.2% | differs | 4.14 ± 0.5% | 36.97 ± 0.2% | 1.00 | 1.00 | 1.28 | 5.56 |
| a date and time | 32954 | 31.11 ± 0.2% | 31.14 ± 0.3% | 1.48 ± 0.1% | 21.18 ± 0.2% | 7.04 ± 0.2% | 1.20 ± 0.2% | 7.09 ± 0.3% | 31.10 ± 0.4% | 1.00 | 1.00 | 1.47 | 4.42 |
| a field path | 32606 | 29.52 ± 0.2% | 29.43 ± 0.1% | 1.04 ± 0.1% | 22.99 ± 0.6% | 3.46 ± 0.9% | differs | 2.96 ± 0.4% | 29.47 ± 0.1% | 1.00 | 1.00 | 1.28 | 8.53 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.50 ± 0.3% | 11.53 ± 1.2% | 11.49 ± 1.3% | 11.48 ± 0.2% | 4.90 ± 0.8% | 0.91 ± 0.7% | none | 11.53 ± 0.2% | 1.00 | 1.00 | 1.00 | 2.35 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 216.61 ± 0.1% | 217.02 ± 0.4% | 251.70 ± 0.1% | 87.66 ± 0.2% | 215.23 ± 2.4% | 487.83 ± 0.4% | 3898.94 ± 1.0% | 216.63 ± 0.1% | 1.00 | 1.00 | 2.47 | 1.01 |
| a UUID | 62 | 142.20 ± 0.1% | 142.67 ± 0.1% | 157.32 ± 0.1% | 45.98 ± 0.1% | 96.54 ± 4.6% | 185.05 ± 0.8% | 4451.57 ± 0.5% | 142.29 ± 0.2% | 1.00 | 1.00 | 3.09 | 1.47 |
| an IPv4 address | 29 | 436.14 ± 0.4% | 440.40 ± 0.3% | 612.00 ± 0.1% | 77.34 ± 1.0% | 126.58 ± 1.4% | 294.60 ± 0.6% | 7698.26 ± 0.2% | 435.87 ± 0.7% | 0.99 | 1.00 | 5.64 | 3.45 |
| a date and time | 56 | 319.71 ± 0.2% | 321.16 ± 0.4% | 403.62 ± 0.2% | 72.95 ± 0.2% | 132.51 ± 1.5% | 321.22 ± 1.0% | 4944.15 ± 0.3% | 319.94 ± 0.2% | 1.00 | 1.00 | 4.38 | 2.41 |
| a field path | 39 | 202.69 ± 0.2% | 203.45 ± 0.1% | 233.26 ± 0.2% | 80.58 ± 0.3% | 198.16 ± 3.3% | 485.40 ± 0.8% | 4973.79 ± 0.5% | 202.83 ± 0.1% | 1.00 | 1.00 | 2.52 | 1.02 |
| literal: a word | 7 | 660.78 ± 0.2% | 709.53 ± 0.8% | 1261.26 ± 0.1% | 519.67 ± 1.6% | 601.97 ± 4.2% | 924.46 ± 0.6% | 31210.84 ± 0.2% | 660.46 ± 0.6% | 0.93 | 1.00 | 1.27 | 1.10 |
| literal: a word that is not there | 8 | 631.41 ± 0.2% | 684.16 ± 0.5% | 1184.41 ± 0.5% | 473.80 ± 0.4% | 581.23 ± 4.3% | 874.45 ± 0.6% | 29440.52 ± 0.1% | 631.00 ± 0.2% | 0.92 | 1.00 | 1.33 | 1.09 |
| literal: one of four words | 26 | 254.03 ± 0.1% | 417.09 ± 0.6% | 562.50 ± 0.6% | 49.64 ± 0.3% | 232.79 ± 2.9% | 355.23 ± 0.6% | 15844.06 ± 0.1% | 254.35 ± 0.2% | 0.61 | 1.00 | 5.12 | 1.09 |
| literal: a word in any case | 11 | 517.08 ± 0.4% | 558.12 ± 0.4% | 857.30 ± 0.8% | 15.81 ± 0.8% | 625.27 ± 1.9% | refused | 23659.77 ± 0.2% | 516.85 ± 0.3% | 0.93 | 1.00 | 32.70 | 0.83 |
| literal: an href attribute | 12 | 346.81 ± 0.4% | 358.04 ± 0.6% | 465.25 ± 0.9% | 45.06 ± 0.9% | 482.48 ± 1.3% | 772.55 ± 1.9% | 22184.79 ± 0.2% | 347.19 ± 0.6% | 0.97 | 1.00 | 7.70 | 0.72 |
| literal: a word, second text | 10 | 587.06 ± 0.5% | 646.51 ± 0.4% | 1076.16 ± 0.5% | 421.30 ± 0.6% | 527.97 ± 1.3% | 801.08 ± 0.6% | 27445.99 ± 0.2% | 587.18 ± 0.8% | 0.91 | 1.00 | 1.39 | 1.11 |
| class: two capitalized words | 23 | 458.24 ± 0.2% | 486.87 ± 0.9% | 706.44 ± 0.2% | 102.25 ± 0.2% | 489.45 ± 3.0% | 744.75 ± 1.4% | 6628.01 ± 1.1% | 458.13 ± 0.3% | 0.94 | 1.00 | 4.48 | 0.94 |
| class: a word that ends in ing | 9 | 593.79 ± 0.2% | 660.16 ± 0.3% | 1161.48 ± 0.1% | 134.54 ± 0.7% | 739.69 ± 1.1% | 1091.38 ± 1.7% | 16315.27 ± 0.1% | 593.12 ± 0.2% | 0.90 | 1.00 | 4.41 | 0.80 |
| class: a word in capitals | 16 | 518.15 ± 0.5% | 557.17 ± 0.9% | 885.15 ± 0.4% | 137.40 ± 0.8% | 739.36 ± 1.8% | 1010.84 ± 0.2% | 8698.58 ± 0.2% | 519.33 ± 0.4% | 0.93 | 1.00 | 3.77 | 0.70 |
| class: a number | 6 | 651.82 ± 0.4% | 712.26 ± 0.2% | 1325.25 ± 0.0% | 42.18 ± 0.5% | 1366.11 ± 0.8% | 1904.18 ± 1.0% | 23055.44 ± 0.1% | 652.07 ± 0.4% | 0.92 | 1.00 | 15.45 | 0.48 |
| class: two capitalized words, second text | 23 | 458.40 ± 0.4% | 487.28 ± 0.3% | 706.50 ± 0.2% | 104.23 ± 0.2% | 488.36 ± 1.3% | 748.32 ± 1.3% | 6621.52 ± 0.5% | 458.31 ± 0.3% | 0.94 | 1.00 | 4.40 | 0.94 |
| other: a word between two words | 13 | 574.94 ± 0.3% | 592.76 ± 0.3% | 939.69 ± 0.4% | 137.27 ± 0.4% | 485.21 ± 4.7% | 814.81 ± 0.6% | 15097.56 ± 0.2% | 575.01 ± 0.1% | 0.97 | 1.00 | 4.19 | 1.18 |
| other: a number before a unit, second text | 15 | 399.11 ± 0.1% | 434.28 ± 0.3% | 595.76 ± 0.1% | 39.46 ± 0.4% | 605.66 ± 3.9% | 895.13 ± 0.7% | 15376.84 ± 0.2% | 399.14 ± 0.2% | 0.92 | 1.00 | 10.11 | 0.66 |
| other: a heading's start tag | 13 | 358.30 ± 0.4% | 363.23 ± 0.3% | 473.05 ± 0.7% | 43.77 ± 0.2% | 597.37 ± 1.8% | 860.46 ± 0.3% | 18457.56 ± 0.1% | 358.21 ± 0.1% | 0.99 | 1.00 | 8.19 | 0.60 |
| other: a whole word | 11 | 609.35 ± 0.7% | 646.91 ± 0.4% | 1078.60 ± 0.1% | 121.91 ± 0.4% | 533.06 ± 4.7% | 825.84 ± 1.0% | 27163.70 ± 0.4% | 610.55 ± 0.6% | 0.94 | 1.00 | 5.00 | 1.14 |
| other: a line's first word, second text | 17 | 553.76 ± 0.6% | 574.13 ± 0.3% | 920.71 ± 0.6% | 130.25 ± 0.1% | 672.80 ± 3.1% | refused | refused | 551.37 ± 0.5% | 0.96 | 1.00 | 4.25 | 0.82 |
| other: fourteen octets before an x | 16 | 112.52 ± 0.6% | 162.56 ± 0.6% | 185.81 ± 0.5% | 15.14 ± 0.2% | 424.24 ± 2.7% | 427.98 ± 0.8% | 12849.47 ± 0.2% | 112.67 ± 0.4% | 0.69 | 1.00 | 7.43 | 0.27 |
| other: a Greek word | 8 | 447.62 ± 0.2% | 585.32 ± 0.5% | 951.41 ± 0.1% | 58.88 ± 0.8% | 1304.37 ± 2.4% | 1793.15 ± 0.7% | refused | 448.00 ± 0.2% | 0.76 | 1.00 | 7.60 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12757.69 ± 0.8% | not timed | not timed | 15931.70 ± 1.8% | 2136.61 ± 6.4% | not timed | not timed | 12758.04 ± 1.2% | | 1.00 | 0.80 | 5.97 |
| 01-literal/sherlock-casei-en | 522 | 4478.41 ± 1.0% | not timed | not timed | 3585.74 ± 0.3% | 32.54 ± 0.2% | not timed | not timed | 4460.01 ± 0.3% | | 1.00 | 1.25 | 137.63 |
| 01-literal/sherlock-ru | 724 | 13453.73 ± 0.3% | not timed | not timed | 17194.10 ± 0.6% | 1277.74 ± 17.5% | not timed | not timed | 13437.30 ± 0.6% | | 1.00 | 0.78 | 10.53 |
| 01-literal/sherlock-casei-ru | 746 | 5272.46 ± 0.7% | not timed | not timed | 3319.09 ± 0.1% | 31.78 ± 0.2% | not timed | not timed | 5265.26 ± 0.9% | | 1.00 | 1.59 | 165.88 |
| 01-literal/sherlock-zh | 30 | 16728.81 ± 0.3% | not timed | not timed | 18137.01 ± 0.2% | 2625.74 ± 14.2% | not timed | not timed | 16691.08 ± 0.8% | | 1.00 | 0.92 | 6.37 |
| 02-literal-alternate/sherlock-en | 714 | 5772.15 ± 0.3% | not timed | not timed | 3939.28 ± 0.2% | 16.63 ± 0.1% | not timed | not timed | 5773.09 ± 0.3% | | 1.00 | 1.47 | 347.20 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1705.08 ± 1.0% | not timed | not timed | 696.92 ± 0.1% | 11.12 ± 13.3% | not timed | not timed | 1701.68 ± 1.0% | | 1.00 | 2.45 | 153.30 |
| 02-literal-alternate/sherlock-ru | 899 | 4641.79 ± 0.3% | not timed | not timed | 3255.90 ± 0.2% | 22.22 ± 0.2% | not timed | not timed | 4641.47 ± 0.1% | | 1.00 | 1.43 | 208.91 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1807.09 ± 0.6% | not timed | not timed | 1230.49 ± 0.2% | 9.14 ± 0.3% | not timed | not timed | 1798.14 ± 0.4% | | 1.00 | 1.47 | 197.64 |
| 02-literal-alternate/sherlock-zh | 207 | 7068.90 ± 0.4% | not timed | not timed | 4159.21 ± 0.2% | 31.52 ± 0.0% | not timed | not timed | 7057.04 ± 0.2% | | 1.00 | 1.70 | 224.25 |
| 03-date/ascii | 111817 | 126.82 ± 0.7% | not timed | not timed | 96.18 ± 0.2% | 0.20 ± 3.1% | not timed | not timed | 125.07 ± 1.1% | | 1.01 | 1.32 | 621.63 |
| 04-ruff-noqa/real | 84 | 555.56 ± 0.1% | not timed | not timed | 457.43 ± 0.1% | 19.51 ± 1.1% | not timed | not timed | 555.58 ± 0.1% | | 1.00 | 1.21 | 28.47 |
| 04-ruff-noqa/tweaked | 44 | 543.75 ± 0.1% | not timed | not timed | 462.34 ± 0.3% | 361.40 ± 1.5% | not timed | not timed | 542.06 ± 0.1% | | 1.00 | 1.18 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.97 ± 0.3% | not timed | not timed | 5.01 ± 0.2% | 0.20 ± 2.4% | not timed | not timed | 4.09 ± 0.3% | | 0.97 | 0.79 | 19.84 |
| 06-cloud-flare-redos/original | 107 | 260.37 ± 0.2% | not timed | not timed | 217.91 ± 0.2% | 24.96 ± 0.2% | not timed | not timed | 259.76 ± 0.0% | | 1.00 | 1.19 | 10.43 |
| 06-cloud-flare-redos/simplified-short | 102 | 254.81 ± 0.1% | not timed | not timed | 228.52 ± 0.1% | 26.77 ± 0.4% | not timed | not timed | 254.30 ± 0.1% | | 1.00 | 1.12 | 9.52 |
| 06-cloud-flare-redos/simplified-long | 10000 | 291.95 ± 0.1% | not timed | not timed | 255.71 ± 0.0% | 28.85 ± 0.1% | not timed | not timed | 291.89 ± 0.1% | | 1.00 | 1.14 | 10.12 |
| 07-unicode-character-data/parse-line | 558784 | 238.45 ± 0.6% | not timed | not timed | 170.65 ± 0.1% | 40.25 ± 11.2% | not timed | not timed | 238.74 ± 2.5% | | 1.00 | 1.40 | 5.92 |
| 08-words/all-english | 56691 | 121.99 ± 1.0% | not timed | not timed | 83.02 ± 0.1% | 11.37 ± 13.5% | not timed | not timed | 121.53 ± 0.7% | | 1.00 | 1.47 | 10.73 |
| 08-words/long-english | 839 | 1013.15 ± 0.2% | not timed | not timed | 595.55 ± 0.2% | 32.35 ± 1.2% | not timed | not timed | 1011.28 ± 0.3% | | 1.00 | 1.70 | 31.32 |
| 09-aws-keys/full | 0 | 408.74 ± 0.1% | not timed | not timed | 464.57 ± 0.1% | 64.33 ± 3.5% | not timed | not timed | 407.49 ± 0.1% | | 1.00 | 0.88 | 6.35 |
| 09-aws-keys/quick | 0 | 731.46 ± 0.3% | not timed | not timed | 991.15 ± 0.2% | 412.84 ± 0.7% | not timed | not timed | 737.16 ± 0.1% | | 0.99 | 0.74 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 638.06 ± 0.6% | not timed | not timed | 515.61 ± 1.0% | 19.55 ± 0.4% | not timed | not timed | 636.45 ± 0.4% | | 1.00 | 1.24 | 32.64 |
| 10-bounded-repeat/letters-ru | 3475 | 382.98 ± 0.2% | not timed | not timed | 478.14 ± 0.1% | 21.85 ± 17.6% | not timed | not timed | 378.14 ± 0.5% | | 1.01 | 0.80 | 17.53 |
| 10-bounded-repeat/context | 53 | 79.02 ± 1.0% | not timed | not timed | 65.03 ± 0.6% | 19.80 ± 0.2% | not timed | not timed | 79.08 ± 1.1% | | 1.00 | 1.22 | 3.99 |
| 10-bounded-repeat/capitals | 11 | 1055.30 ± 0.1% | not timed | not timed | 615.34 ± 0.1% | 36.52 ± 0.1% | not timed | not timed | 1055.09 ± 0.1% | | 1.00 | 1.71 | 28.90 |
| 11-unstructured-to-json/extract | 600 | 49.95 ± 0.2% | not timed | not timed | 77.17 ± 0.1% | 49.25 ± 1.2% | not timed | not timed | 49.43 ± 0.4% | | 1.01 | 0.65 | 1.01 |
| 12-dictionary/single | 1 | 567.56 ± 0.4% | not timed | not timed | 560.78 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 568.71 ± 0.1% | | 1.00 | 1.01 | 1416.69 |
| 14-quadratic/1x | 100 | 12.81 ± 0.5% | not timed | not timed | 10.05 ± 0.2% | 0.97 ± 4.3% | not timed | not timed | 12.78 ± 2.0% | | 1.00 | 1.28 | 13.14 |
| 14-quadratic/2x | 200 | 7.92 ± 0.3% | not timed | not timed | 5.54 ± 0.3% | 0.53 ± 1.8% | not timed | not timed | 7.91 ± 0.7% | | 1.00 | 1.43 | 14.95 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.3% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 2.2% | not timed | not timed | 1.88 ± 0.3% | | 1.00 | 1.56 | 16.30 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.3% | not timed | not timed | 0.34 ± 1.1% | 0.53 ± 5.3% | not timed | not timed | 1.53 ± 1.7% | | 1.01 | 4.54 | 2.91 |
| 04-ruff-noqa/compile-real | 1 | 85.40 ± 0.2% | not timed | not timed | 13.80 ± 0.2% | 129.41 ± 3.2% | not timed | not timed | 85.12 ± 0.4% | | 1.00 | 6.19 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.50 ± 0.3% | not timed | not timed | 2.51 ± 0.6% | 6.04 ± 3.9% | not timed | not timed | 14.45 ± 0.7% | | 1.00 | 5.78 | 2.40 |
| 07-unicode-character-data/compile | 1 | 54.91 ± 0.1% | not timed | not timed | 25.80 ± 0.3% | 33.97 ± 2.8% | not timed | not timed | 54.81 ± 0.3% | | 1.00 | 2.13 | 1.62 |
| 09-aws-keys/compile-full | 1 | 42.19 ± 0.2% | not timed | not timed | 8.28 ± 0.2% | 21.60 ± 2.0% | not timed | not timed | 41.93 ± 0.9% | | 1.01 | 5.10 | 1.95 |
| 09-aws-keys/compile-quick | 1 | 188.89 ± 0.3% | not timed | not timed | 47.42 ± 0.3% | 124.18 ± 3.6% | not timed | not timed | 187.56 ± 0.9% | | 1.01 | 3.98 | 1.52 |
| 10-bounded-repeat/compile-context | 1 | 14.63 ± 2.1% | not timed | not timed | 11.29 ± 0.3% | 14.83 ± 4.1% | not timed | not timed | 14.49 ± 2.1% | | 1.01 | 1.30 | 0.99 |
| 10-bounded-repeat/compile-capitals | 1 | 85.23 ± 0.4% | not timed | not timed | 8.14 ± 0.1% | 22.27 ± 6.3% | not timed | not timed | 84.64 ± 1.9% | | 1.01 | 10.47 | 3.83 |
| 11-unstructured-to-json/compile | 1 | 86.33 ± 0.2% | not timed | not timed | 41.20 ± 0.5% | 65.38 ± 3.6% | not timed | not timed | 85.47 ± 1.1% | | 1.01 | 2.10 | 1.32 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.3% | not timed | not timed | 0.07 ± 1.2% | 0.09 ± 18.8% | not timed | not timed | 0.36 ± 1.2% | | 1.01 | 5.46 | 3.82 |

