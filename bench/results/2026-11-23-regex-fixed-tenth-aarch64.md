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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159292968 |
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
| literal: a word | 217 | 15836.87 ± 1.0% | 1049.27 ± 0.1% | 28.42 ± 0.3% | 17967.78 ± 2.4% | 9024.01 ± 8.9% | 17.53 ± 0.2% | 86.83 ± 0.3% | 15861.94 ± 0.6% | 15.09 | 1.00 | 0.88 | 1.75 |
| literal: a word that is not there | 0 | 18162.93 ± 1.9% | 1055.74 ± 0.4% | 28.43 ± 0.7% | 19240.68 ± 3.0% | 27545.93 ± 2.6% | 17.35 ± 0.6% | 82.63 ± 0.2% | 18376.08 ± 1.5% | 17.20 | 0.99 | 0.94 | 0.66 |
| literal: one of four words | 661 | 6066.96 ± 0.7% | 1030.04 ± 0.2% | 14.61 ± 0.4% | 3940.51 ± 1.6% | 21.86 ± 0.1% | 5.28 ± 0.3% | 6.89 ± 0.8% | 6062.38 ± 1.3% | 5.89 | 1.00 | 1.54 | 277.48 |
| literal: a word in any case | 217 | 12566.25 ± 1.3% | 1047.69 ± 0.3% | 21.78 ± 0.4% | 3961.19 ± 0.3% | 38.09 ± 0.9% | refused | differs | 12496.59 ± 0.7% | 11.99 | 1.01 | 3.17 | 329.91 |
| literal: an href attribute | 33 | 13458.86 ± 1.5% | 1053.57 ± 0.2% | 27.16 ± 0.4% | 16773.80 ± 2.0% | 2263.24 ± 0.7% | 13.30 ± 0.3% | 75.67 ± 0.3% | 13516.17 ± 0.6% | 12.77 | 1.00 | 0.80 | 5.95 |
| literal: a word, second text | 123 | 16273.08 ± 0.6% | 1050.90 ± 0.2% | 28.18 ± 0.3% | 18305.62 ± 1.9% | 7766.70 ± 5.7% | 19.73 ± 0.4% | 69.73 ± 0.4% | 16299.01 ± 0.3% | 15.48 | 1.00 | 0.89 | 2.10 |
| class: two capitalized words | 1331 | 1123.41 ± 0.5% | 979.24 ± 0.2% | 26.00 ± 0.1% | 585.10 ± 0.1% | 40.58 ± 7.6% | 14.94 ± 0.3% | 68.83 ± 0.2% | 1121.87 ± 1.1% | 1.15 | 1.00 | 1.92 | 27.69 |
| class: a word that ends in ing | 3399 | 901.63 ± 0.2% | 901.66 ± 0.1% | 18.07 ± 0.1% | 547.46 ± 0.1% | 29.61 ± 2.2% | 8.24 ± 0.1% | 18.45 ± 0.3% | 900.38 ± 0.3% | 1.00 | 1.00 | 1.65 | 30.45 |
| class: a word in capitals | 2332 | 1461.45 ± 0.4% | 956.15 ± 0.0% | 27.78 ± 0.6% | 572.66 ± 0.1% | 43.49 ± 13.2% | 17.21 ± 0.3% | 83.19 ± 0.2% | 1459.14 ± 0.1% | 1.53 | 1.00 | 2.55 | 33.61 |
| class: a number | 8288 | 2009.07 ± 0.1% | 840.67 ± 0.2% | 27.88 ± 0.1% | 1716.75 ± 0.3% | 43.14 ± 4.3% | 0.55 ± 1.0% | 56.76 ± 0.3% | 2007.17 ± 0.1% | 2.39 | 1.00 | 1.17 | 46.57 |
| class: two capitalized words, second text | 5359 | 744.17 ± 0.2% | 744.71 ± 0.1% | 23.30 ± 0.2% | 485.05 ± 0.3% | 35.39 ± 8.1% | 16.73 ± 0.2% | 63.91 ± 0.4% | 744.36 ± 0.1% | 1.00 | 1.00 | 1.53 | 21.03 |
| other: a word between two words | 6104 | 754.10 ± 0.2% | 780.85 ± 0.1% | 23.51 ± 0.3% | 737.22 ± 0.3% | 109.57 ± 18.8% | 11.31 ± 0.2% | 69.90 ± 0.2% | 751.13 ± 0.1% | 0.97 | 1.00 | 1.02 | 6.88 |
| other: a number before a unit, second text | 1481 | 5377.93 ± 0.5% | 991.18 ± 0.1% | 25.98 ± 0.3% | 5665.04 ± 0.6% | 40.68 ± 0.1% | 17.84 ± 0.2% | 66.88 ± 0.3% | 5370.74 ± 0.8% | 5.43 | 1.00 | 0.95 | 132.19 |
| other: a heading's start tag | 110 | 12548.62 ± 0.8% | 1043.93 ± 0.2% | 27.39 ± 0.2% | 1710.84 ± 0.7% | 1583.73 ± 0.6% | 16.15 ± 0.4% | 88.88 ± 0.6% | 12558.02 ± 1.5% | 12.02 | 1.00 | 7.33 | 7.92 |
| other: a whole word | 217 | 13838.85 ± 0.9% | 1045.61 ± 0.1% | 29.29 ± 0.8% | 14377.64 ± 2.4% | 49.49 ± 0.1% | 13.70 ± 0.1% | 55.79 ± 0.5% | 13880.76 ± 1.8% | 13.24 | 1.00 | 0.96 | 279.62 |
| other: a line's first word, second text | 3716 | 1966.57 ± 0.6% | 879.41 ± 0.1% | 30.86 ± 0.4% | 1726.94 ± 0.6% | 62.75 ± 4.2% | refused | refused | 1953.13 ± 0.4% | 2.24 | 1.01 | 1.14 | 31.34 |
| other: fourteen octets before an x | 87 | 19141.59 ± 2.0% | 243.47 ± 0.3% | 6.62 ± 0.1% | 3967.41 ± 0.5% | 10.64 ± 0.1% | differs | 17.77 ± 0.3% | 19108.88 ± 1.9% | 78.62 | 1.00 | 4.82 | 1798.49 |
| other: a Greek word | 21815 | 513.59 ± 0.7% | 412.99 ± 0.3% | 31.17 ± 1.3% | 289.18 ± 0.5% | 48.49 ± 12.1% | differs | refused | 514.00 ± 0.6% | 1.24 | 1.00 | 1.78 | 10.59 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.88 ± 0.1% | 25.86 ± 0.1% | 0.88 ± 0.3% | 19.72 ± 0.5% | 2.76 ± 1.3% | differs | 4.02 ± 0.1% | 25.90 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.39 |
| a UUID | 32895 | 21.08 ± 0.2% | 21.17 ± 0.1% | 0.65 ± 0.1% | 15.11 ± 0.3% | 3.10 ± 0.1% | 0.72 ± 0.7% | 3.60 ± 0.6% | 21.19 ± 0.2% | 1.00 | 0.99 | 1.39 | 6.80 |
| an IPv4 address | 33176 | 36.96 ± 0.2% | 36.85 ± 0.2% | 2.13 ± 0.2% | 28.98 ± 0.4% | 6.66 ± 0.1% | differs | 4.15 ± 0.3% | 36.96 ± 0.3% | 1.00 | 1.00 | 1.28 | 5.55 |
| a date and time | 32954 | 31.10 ± 0.3% | 31.15 ± 0.5% | 1.49 ± 0.3% | 21.10 ± 0.6% | 7.02 ± 0.3% | 1.20 ± 0.1% | 7.11 ± 0.3% | 31.12 ± 0.3% | 1.00 | 1.00 | 1.47 | 4.43 |
| a field path | 32606 | 29.49 ± 0.1% | 29.41 ± 0.2% | 1.04 ± 0.2% | 22.94 ± 0.3% | 3.50 ± 0.5% | differs | 2.95 ± 0.3% | 29.44 ± 0.1% | 1.00 | 1.00 | 1.29 | 8.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.50 ± 0.2% | 11.50 ± 0.3% | 11.47 ± 0.2% | 11.50 ± 0.1% | 5.00 ± 2.3% | 0.91 ± 0.4% | none | 11.52 ± 0.3% | 1.00 | 1.00 | 1.00 | 2.30 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 216.04 ± 0.4% | 216.94 ± 0.4% | 252.15 ± 0.4% | 86.80 ± 0.6% | 221.07 ± 0.9% | 481.11 ± 0.7% | 3855.33 ± 1.6% | 216.02 ± 0.4% | 1.00 | 1.00 | 2.49 | 0.98 |
| a UUID | 62 | 142.34 ± 0.4% | 142.68 ± 0.3% | 157.37 ± 0.3% | 46.58 ± 0.6% | 99.38 ± 7.8% | 190.66 ± 2.8% | 4416.55 ± 1.9% | 142.22 ± 0.3% | 1.00 | 1.00 | 3.06 | 1.43 |
| an IPv4 address | 29 | 435.98 ± 0.6% | 440.46 ± 0.4% | 612.56 ± 1.0% | 77.19 ± 0.3% | 132.09 ± 2.2% | 303.27 ± 1.2% | 7577.68 ± 0.2% | 436.68 ± 0.7% | 0.99 | 1.00 | 5.65 | 3.30 |
| a date and time | 56 | 319.21 ± 0.5% | 321.19 ± 0.2% | 403.30 ± 0.3% | 73.22 ± 0.2% | 136.63 ± 15.6% | 324.98 ± 1.3% | 4908.22 ± 0.6% | 319.60 ± 0.8% | 0.99 | 1.00 | 4.36 | 2.34 |
| a field path | 39 | 202.48 ± 0.3% | 203.27 ± 0.3% | 233.38 ± 0.3% | 81.16 ± 1.1% | 206.65 ± 13.2% | 500.89 ± 2.8% | 4927.27 ± 1.0% | 202.33 ± 0.2% | 1.00 | 1.00 | 2.49 | 0.98 |
| literal: a word | 7 | 659.60 ± 0.8% | 709.42 ± 1.0% | 1264.49 ± 0.3% | 525.39 ± 0.4% | 626.36 ± 1.6% | 955.74 ± 0.5% | 29470.54 ± 0.5% | 659.86 ± 0.4% | 0.93 | 1.00 | 1.26 | 1.05 |
| literal: a word that is not there | 8 | 632.13 ± 0.3% | 684.10 ± 0.1% | 1188.72 ± 0.7% | 482.84 ± 0.3% | 602.09 ± 1.2% | 905.62 ± 0.3% | 28303.53 ± 0.3% | 631.91 ± 0.3% | 0.92 | 1.00 | 1.31 | 1.05 |
| literal: one of four words | 26 | 254.32 ± 0.1% | 417.98 ± 0.1% | 563.99 ± 0.5% | 50.10 ± 1.0% | 241.85 ± 1.7% | 374.64 ± 1.2% | 15346.52 ± 0.4% | 254.27 ± 0.3% | 0.61 | 1.00 | 5.08 | 1.05 |
| literal: a word in any case | 11 | 517.09 ± 0.4% | 557.19 ± 0.5% | 858.86 ± 0.3% | 15.89 ± 1.7% | 645.23 ± 1.8% | refused | 22681.16 ± 0.6% | 517.23 ± 0.5% | 0.93 | 1.00 | 32.54 | 0.80 |
| literal: an href attribute | 12 | 346.54 ± 0.2% | 357.89 ± 0.4% | 465.14 ± 0.4% | 45.81 ± 0.7% | 499.43 ± 5.5% | 774.18 ± 1.6% | 21118.56 ± 0.2% | 346.47 ± 0.3% | 0.97 | 1.00 | 7.57 | 0.69 |
| literal: a word, second text | 10 | 587.98 ± 0.6% | 647.43 ± 0.4% | 1079.20 ± 0.1% | 402.52 ± 0.4% | 540.98 ± 1.6% | 799.10 ± 0.2% | 26139.71 ± 0.5% | 587.62 ± 0.3% | 0.91 | 1.00 | 1.46 | 1.09 |
| class: two capitalized words | 23 | 457.68 ± 0.3% | 486.64 ± 0.3% | 705.22 ± 0.5% | 100.34 ± 0.1% | 503.73 ± 2.6% | 746.45 ± 0.6% | 6559.72 ± 0.3% | 457.89 ± 0.5% | 0.94 | 1.00 | 4.56 | 0.91 |
| class: a word that ends in ing | 9 | 592.85 ± 0.1% | 659.95 ± 0.3% | 1161.16 ± 0.2% | 132.39 ± 2.0% | 756.20 ± 2.8% | 1106.76 ± 0.4% | 15770.68 ± 0.1% | 593.06 ± 0.2% | 0.90 | 1.00 | 4.48 | 0.78 |
| class: a word in capitals | 16 | 518.98 ± 0.3% | 556.71 ± 0.3% | 886.04 ± 0.4% | 135.55 ± 0.5% | 755.60 ± 0.9% | 1027.03 ± 1.2% | 8574.22 ± 0.2% | 519.61 ± 0.3% | 0.93 | 1.00 | 3.83 | 0.69 |
| class: a number | 6 | 651.23 ± 0.5% | 713.47 ± 0.5% | 1326.58 ± 0.1% | 41.95 ± 0.6% | 1394.84 ± 14.7% | 1866.03 ± 1.9% | 22272.44 ± 0.1% | 651.89 ± 0.5% | 0.91 | 1.00 | 15.52 | 0.47 |
| class: two capitalized words, second text | 23 | 457.01 ± 0.4% | 486.79 ± 0.1% | 704.88 ± 0.2% | 101.82 ± 0.5% | 502.59 ± 1.7% | 766.60 ± 0.5% | 6555.45 ± 0.1% | 457.43 ± 0.5% | 0.94 | 1.00 | 4.49 | 0.91 |
| other: a word between two words | 13 | 573.43 ± 0.4% | 591.20 ± 0.2% | 941.72 ± 0.2% | 133.11 ± 0.7% | 504.59 ± 1.4% | 815.29 ± 0.2% | 14631.30 ± 0.1% | 573.96 ± 0.3% | 0.97 | 1.00 | 4.31 | 1.14 |
| other: a number before a unit, second text | 15 | 398.83 ± 0.3% | 433.53 ± 0.3% | 596.74 ± 0.1% | 39.67 ± 0.3% | 635.39 ± 1.0% | 894.27 ± 1.2% | 14843.93 ± 0.2% | 399.24 ± 0.2% | 0.92 | 1.00 | 10.05 | 0.63 |
| other: a heading's start tag | 13 | 358.33 ± 0.6% | 362.26 ± 0.2% | 473.51 ± 0.9% | 44.08 ± 0.1% | 625.61 ± 1.8% | 883.72 ± 1.0% | 17703.49 ± 0.2% | 358.18 ± 0.2% | 0.99 | 1.00 | 8.13 | 0.57 |
| other: a whole word | 11 | 610.09 ± 0.7% | 648.34 ± 0.4% | 1081.63 ± 0.6% | 118.29 ± 0.6% | 564.22 ± 0.9% | 840.38 ± 0.5% | 25024.65 ± 1.3% | 610.57 ± 0.5% | 0.94 | 1.00 | 5.16 | 1.08 |
| other: a line's first word, second text | 17 | 553.37 ± 0.6% | 573.52 ± 0.5% | 920.77 ± 0.6% | 129.36 ± 0.3% | 710.47 ± 0.8% | refused | refused | 551.45 ± 0.7% | 0.96 | 1.00 | 4.28 | 0.78 |
| other: fourteen octets before an x | 16 | 112.26 ± 0.7% | 162.26 ± 0.9% | 185.40 ± 0.5% | 15.19 ± 0.3% | 453.92 ± 1.9% | 415.44 ± 0.5% | 12511.75 ± 0.3% | 112.34 ± 0.7% | 0.69 | 1.00 | 7.39 | 0.25 |
| other: a Greek word | 8 | 447.33 ± 0.1% | 586.83 ± 0.5% | 954.83 ± 0.5% | 59.26 ± 0.4% | 1388.59 ± 1.7% | 1797.17 ± 0.4% | refused | 447.93 ± 0.1% | 0.76 | 1.00 | 7.55 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12803.40 ± 0.6% | not timed | not timed | 16150.50 ± 2.0% | 2034.14 ± 17.1% | not timed | not timed | 12813.73 ± 0.2% | | 1.00 | 0.79 | 6.29 |
| 01-literal/sherlock-casei-en | 522 | 4485.33 ± 1.1% | not timed | not timed | 3582.96 ± 0.3% | 32.53 ± 0.5% | not timed | not timed | 4474.09 ± 0.3% | | 1.00 | 1.25 | 137.89 |
| 01-literal/sherlock-ru | 724 | 13536.93 ± 0.3% | not timed | not timed | 17351.74 ± 1.1% | 1273.02 ± 8.3% | not timed | not timed | 13501.13 ± 0.3% | | 1.00 | 0.78 | 10.63 |
| 01-literal/sherlock-casei-ru | 746 | 5291.65 ± 0.3% | not timed | not timed | 3332.08 ± 0.2% | 31.68 ± 4.0% | not timed | not timed | 5282.84 ± 0.5% | | 1.00 | 1.59 | 167.06 |
| 01-literal/sherlock-zh | 30 | 16751.31 ± 2.3% | not timed | not timed | 18286.64 ± 4.4% | 2880.27 ± 8.8% | not timed | not timed | 16839.13 ± 2.3% | | 0.99 | 0.92 | 5.82 |
| 02-literal-alternate/sherlock-en | 714 | 5784.24 ± 0.5% | not timed | not timed | 3941.35 ± 0.2% | 16.62 ± 0.2% | not timed | not timed | 5776.08 ± 0.2% | | 1.00 | 1.47 | 348.13 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1711.69 ± 1.1% | not timed | not timed | 697.25 ± 0.3% | 11.12 ± 0.2% | not timed | not timed | 1702.16 ± 0.5% | | 1.01 | 2.45 | 153.96 |
| 02-literal-alternate/sherlock-ru | 899 | 4655.77 ± 0.2% | not timed | not timed | 3258.88 ± 0.1% | 22.63 ± 0.4% | not timed | not timed | 4660.65 ± 0.1% | | 1.00 | 1.43 | 205.70 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1809.31 ± 0.6% | not timed | not timed | 1230.79 ± 0.3% | 9.14 ± 0.1% | not timed | not timed | 1801.28 ± 0.4% | | 1.00 | 1.47 | 197.91 |
| 02-literal-alternate/sherlock-zh | 207 | 7076.72 ± 0.3% | not timed | not timed | 4163.25 ± 0.2% | 31.50 ± 0.1% | not timed | not timed | 7071.82 ± 0.2% | | 1.00 | 1.70 | 224.64 |
| 03-date/ascii | 111817 | 126.63 ± 0.5% | not timed | not timed | 96.58 ± 0.1% | 0.20 ± 4.5% | not timed | not timed | 126.17 ± 0.4% | | 1.00 | 1.31 | 621.22 |
| 04-ruff-noqa/real | 84 | 555.39 ± 0.1% | not timed | not timed | 461.62 ± 0.5% | 19.59 ± 0.3% | not timed | not timed | 555.61 ± 0.1% | | 1.00 | 1.20 | 28.35 |
| 04-ruff-noqa/tweaked | 44 | 543.88 ± 0.1% | not timed | not timed | 458.66 ± 0.1% | 339.01 ± 0.9% | not timed | not timed | 542.81 ± 0.2% | | 1.00 | 1.19 | 1.60 |
| 05-lexer-veryl/single | 124800 | 3.98 ± 0.3% | not timed | not timed | 4.94 ± 0.3% | 0.20 ± 3.9% | not timed | not timed | 4.09 ± 3.7% | | 0.97 | 0.80 | 19.41 |
| 06-cloud-flare-redos/original | 107 | 260.50 ± 2.2% | not timed | not timed | 216.69 ± 0.1% | 24.99 ± 0.2% | not timed | not timed | 260.11 ± 0.1% | | 1.00 | 1.20 | 10.43 |
| 06-cloud-flare-redos/simplified-short | 102 | 254.69 ± 0.1% | not timed | not timed | 228.91 ± 0.1% | 26.70 ± 0.1% | not timed | not timed | 254.74 ± 0.1% | | 1.00 | 1.11 | 9.54 |
| 06-cloud-flare-redos/simplified-long | 10000 | 291.96 ± 0.2% | not timed | not timed | 255.70 ± 0.1% | 28.74 ± 0.1% | not timed | not timed | 291.98 ± 0.2% | | 1.00 | 1.14 | 10.16 |
| 07-unicode-character-data/parse-line | 558784 | 238.64 ± 0.3% | not timed | not timed | 173.19 ± 0.1% | 43.28 ± 6.0% | not timed | not timed | 239.01 ± 2.1% | | 1.00 | 1.38 | 5.51 |
| 08-words/all-english | 56691 | 122.05 ± 0.7% | not timed | not timed | 82.98 ± 0.3% | 12.74 ± 14.1% | not timed | not timed | 121.65 ± 0.7% | | 1.00 | 1.47 | 9.58 |
| 08-words/long-english | 839 | 1012.98 ± 0.1% | not timed | not timed | 597.45 ± 0.1% | 32.63 ± 0.2% | not timed | not timed | 1011.98 ± 0.2% | | 1.00 | 1.70 | 31.04 |
| 09-aws-keys/full | 0 | 408.63 ± 0.1% | not timed | not timed | 466.78 ± 0.2% | 63.49 ± 4.8% | not timed | not timed | 407.85 ± 0.1% | | 1.00 | 0.88 | 6.44 |
| 09-aws-keys/quick | 0 | 738.80 ± 0.1% | not timed | not timed | 987.26 ± 0.3% | 382.72 ± 1.3% | not timed | not timed | 737.33 ± 0.1% | | 1.00 | 0.75 | 1.93 |
| 10-bounded-repeat/letters-en | 1833 | 636.09 ± 0.3% | not timed | not timed | 516.94 ± 0.5% | 19.48 ± 0.4% | not timed | not timed | 636.07 ± 0.3% | | 1.00 | 1.23 | 32.65 |
| 10-bounded-repeat/letters-ru | 3475 | 383.36 ± 0.1% | not timed | not timed | 478.08 ± 0.1% | 21.72 ± 9.6% | not timed | not timed | 381.10 ± 0.5% | | 1.01 | 0.80 | 17.65 |
| 10-bounded-repeat/context | 53 | 79.77 ± 0.9% | not timed | not timed | 65.81 ± 0.5% | 19.84 ± 0.1% | not timed | not timed | 79.88 ± 1.2% | | 1.00 | 1.21 | 4.02 |
| 10-bounded-repeat/capitals | 11 | 1055.89 ± 0.2% | not timed | not timed | 618.51 ± 0.1% | 36.63 ± 0.1% | not timed | not timed | 1056.01 ± 0.1% | | 1.00 | 1.71 | 28.83 |
| 11-unstructured-to-json/extract | 600 | 49.76 ± 0.2% | not timed | not timed | 77.15 ± 0.2% | 49.21 ± 0.8% | not timed | not timed | 49.52 ± 0.8% | | 1.00 | 0.64 | 1.01 |
| 12-dictionary/single | 1 | 568.02 ± 0.3% | not timed | not timed | 562.07 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 568.40 ± 0.3% | | 1.00 | 1.01 | 1411.20 |
| 14-quadratic/1x | 100 | 12.81 ± 0.3% | not timed | not timed | 9.99 ± 0.2% | 0.98 ± 3.8% | not timed | not timed | 12.80 ± 1.5% | | 1.00 | 1.28 | 13.05 |
| 14-quadratic/2x | 200 | 7.95 ± 0.4% | not timed | not timed | 5.53 ± 0.4% | 0.53 ± 1.7% | not timed | not timed | 7.90 ± 0.8% | | 1.01 | 1.44 | 14.99 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.2% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 1.7% | not timed | not timed | 1.88 ± 0.3% | | 1.00 | 1.55 | 16.32 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.2% | not timed | not timed | 0.34 ± 0.9% | 0.56 ± 4.4% | not timed | not timed | 1.54 ± 0.5% | | 1.00 | 4.47 | 2.75 |
| 04-ruff-noqa/compile-real | 1 | 85.44 ± 0.1% | not timed | not timed | 13.73 ± 0.1% | 140.75 ± 2.6% | not timed | not timed | 85.18 ± 0.3% | | 1.00 | 6.22 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 14.52 ± 0.1% | not timed | not timed | 2.51 ± 0.5% | 6.51 ± 2.3% | not timed | not timed | 14.43 ± 0.8% | | 1.01 | 5.79 | 2.23 |
| 07-unicode-character-data/compile | 1 | 55.00 ± 0.1% | not timed | not timed | 25.51 ± 0.2% | 36.44 ± 1.4% | not timed | not timed | 54.97 ± 0.6% | | 1.00 | 2.16 | 1.51 |
| 09-aws-keys/compile-full | 1 | 42.22 ± 0.1% | not timed | not timed | 8.20 ± 0.7% | 23.63 ± 1.0% | not timed | not timed | 42.05 ± 0.3% | | 1.00 | 5.15 | 1.79 |
| 09-aws-keys/compile-quick | 1 | 188.49 ± 0.2% | not timed | not timed | 46.43 ± 0.3% | 136.05 ± 2.8% | not timed | not timed | 188.30 ± 0.3% | | 1.00 | 4.06 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 14.63 ± 0.2% | not timed | not timed | 11.21 ± 0.2% | 16.18 ± 3.3% | not timed | not timed | 14.56 ± 0.9% | | 1.00 | 1.31 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 85.23 ± 0.3% | not timed | not timed | 8.11 ± 0.3% | 23.85 ± 2.1% | not timed | not timed | 84.84 ± 0.9% | | 1.00 | 10.51 | 3.57 |
| 11-unstructured-to-json/compile | 1 | 86.23 ± 1.4% | not timed | not timed | 40.93 ± 1.6% | 69.06 ± 2.6% | not timed | not timed | 85.71 ± 0.8% | | 1.01 | 2.11 | 1.25 |
| 12-dictionary/compile-single | 1 | 0.36 ± 2.2% | not timed | not timed | 0.07 ± 24.2% | 0.09 ± 20.0% | not timed | not timed | 0.36 ± 1.9% | | 1.01 | 5.17 | 3.87 |

