# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215413015 |
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
| literal: a word | 217 | 54968.99 ± 4.4% | 6393.52 ± 1.1% | 46.38 ± 1.8% | 53658.38 ± 1.2% | 16026.23 ± 3.6% | 16.38 ± 2.8% | 166.78 ± 6.5% | 55830.42 ± 4.6% | 8.60 | 0.98 | 1.02 | 3.43 |
| literal: a word that is not there | 0 | 82250.67 ± 4.6% | 6312.43 ± 3.6% | 46.49 ± 1.0% | 66131.20 ± 0.9% | 56575.39 ± 1.1% | 15.96 ± 2.5% | 151.60 ± 1.9% | 81838.53 ± 1.5% | 13.03 | 1.01 | 1.24 | 1.45 |
| literal: one of four words | 661 | 20080.44 ± 0.7% | 2414.97 ± 0.8% | 25.54 ± 0.8% | 14711.70 ± 3.8% | 38.79 ± 20.8% | 5.16 ± 2.3% | 13.13 ± 2.4% | 20016.64 ± 2.8% | 8.31 | 1.00 | 1.36 | 517.65 |
| literal: a word in any case | 217 | 49347.76 ± 2.7% | 2601.42 ± 3.1% | 33.81 ± 5.1% | 14645.88 ± 4.9% | 73.42 ± 3.6% | refused | differs | 48433.64 ± 3.8% | 18.97 | 1.02 | 3.37 | 672.09 |
| literal: an href attribute | 33 | 47509.38 ± 1.0% | 753.70 ± 1.2% | 38.90 ± 2.4% | 46390.25 ± 3.5% | 3658.94 ± 8.5% | 11.63 ± 5.7% | 137.95 ± 5.7% | 47526.19 ± 3.7% | 63.03 | 1.00 | 1.02 | 12.98 |
| literal: a word, second text | 123 | 55137.66 ± 8.0% | 4452.30 ± 4.0% | 43.52 ± 4.3% | 48961.16 ± 14.2% | 14340.40 ± 12.5% | 20.93 ± 27.5% | 131.73 ± 34.2% | 55266.01 ± 8.6% | 12.38 | 1.00 | 1.13 | 3.84 |
| class: two capitalized words | 1331 | 1101.25 ± 1.5% | 708.86 ± 2.5% | 40.24 ± 3.1% | 679.27 ± 2.6% | 61.38 ± 26.1% | 13.71 ± 1.8% | 103.51 ± 4.5% | 1094.23 ± 8.8% | 1.55 | 1.01 | 1.62 | 17.94 |
| class: a word that ends in ing | 3399 | 685.53 ± 5.4% | 685.01 ± 5.4% | 26.24 ± 5.5% | 638.48 ± 4.1% | 45.81 ± 7.3% | 7.99 ± 4.3% | 32.28 ± 5.6% | 703.10 ± 4.7% | 1.00 | 0.98 | 1.07 | 14.96 |
| class: a word in capitals | 2332 | 1597.31 ± 5.1% | 726.21 ± 5.5% | 42.91 ± 5.3% | 673.75 ± 3.4% | 65.61 ± 37.2% | 16.40 ± 34.9% | 137.80 ± 4.4% | 1622.10 ± 6.7% | 2.20 | 0.98 | 2.37 | 24.35 |
| class: a number | 8288 | 2772.41 ± 2.8% | 1005.13 ± 3.5% | 44.44 ± 1.6% | 2366.52 ± 2.4% | 63.07 ± 18.2% | 0.46 ± 1.9% | 99.59 ± 5.2% | 2767.13 ± 3.8% | 2.76 | 1.00 | 1.17 | 43.96 |
| class: two capitalized words, second text | 5359 | 627.59 ± 3.4% | 631.20 ± 0.5% | 33.47 ± 0.8% | 591.15 ± 1.7% | 53.31 ± 7.1% | 18.49 ± 3.0% | 100.44 ± 2.2% | 626.34 ± 2.2% | 0.99 | 1.00 | 1.06 | 11.77 |
| other: a word between two words | 6104 | 1103.84 ± 4.2% | 712.04 ± 3.7% | 36.18 ± 5.0% | 1001.98 ± 5.1% | 170.74 ± 34.7% | 10.69 ± 4.3% | 117.38 ± 3.3% | 1101.70 ± 3.2% | 1.55 | 1.00 | 1.10 | 6.46 |
| other: a number before a unit, second text | 1481 | 13336.95 ± 1.4% | 1428.07 ± 0.3% | 42.29 ± 1.0% | 11275.69 ± 3.3% | 62.03 ± 3.8% | 19.90 ± 0.8% | 110.13 ± 2.1% | 13270.40 ± 2.4% | 9.34 | 1.01 | 1.18 | 215.01 |
| other: a heading's start tag | 110 | 31104.98 ± 1.1% | 914.36 ± 0.8% | 42.28 ± 0.7% | 3446.42 ± 0.6% | 2581.29 ± 14.9% | 14.56 ± 2.3% | 168.97 ± 1.9% | 31057.14 ± 4.6% | 34.02 | 1.00 | 9.03 | 12.05 |
| other: a whole word | 217 | 39547.02 ± 0.9% | 742.60 ± 0.8% | 46.50 ± 0.8% | 37436.50 ± 0.6% | 76.81 ± 2.4% | 13.87 ± 3.1% | 87.54 ± 63.4% | 39386.70 ± 14.4% | 53.25 | 1.00 | 1.06 | 514.87 |
| other: a line's first word, second text | 3716 | 3478.56 ± 4.6% | 719.95 ± 2.8% | 50.41 ± 3.1% | 3639.03 ± 16.7% | 103.18 ± 5.2% | refused | refused | 3413.74 ± 3.1% | 4.83 | 1.02 | 0.96 | 33.71 |
| other: fourteen octets before an x | 87 | 48723.92 ± 4.3% | 365.46 ± 1.0% | 9.05 ± 0.5% | 5010.27 ± 0.5% | 14.90 ± 2.7% | differs | 27.07 ± 2.8% | 48041.18 ± 2.7% | 133.32 | 1.01 | 9.72 | 3269.92 |
| other: a Greek word | 21815 | 614.04 ± 4.0% | 484.89 ± 3.8% | 49.81 ± 3.9% | 363.15 ± 1.6% | 60.94 ± 8.1% | differs | refused | 616.06 ± 6.8% | 1.27 | 1.00 | 1.69 | 10.08 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.02 ± 3.1% | 28.20 ± 3.9% | 1.49 ± 4.2% | 24.82 ± 4.3% | 3.77 ± 5.0% | differs | 5.99 ± 3.9% | 28.07 ± 2.8% | 0.99 | 1.00 | 1.13 | 7.43 |
| a UUID | 32895 | 30.58 ± 6.1% | 30.63 ± 4.8% | 1.05 ± 4.7% | 18.93 ± 1.9% | 3.64 ± 5.1% | 0.76 ± 4.5% | 4.80 ± 6.4% | 29.00 ± 4.8% | 1.00 | 1.05 | 1.62 | 8.40 |
| an IPv4 address | 33176 | 47.42 ± 29.0% | 46.65 ± 34.6% | 3.12 ± 39.6% | 34.34 ± 4.4% | 9.30 ± 4.4% | differs | 6.06 ± 9.6% | 47.04 ± 47.6% | 1.02 | 1.01 | 1.38 | 5.10 |
| a date and time | 32954 | 44.17 ± 14.8% | 44.57 ± 5.2% | 2.37 ± 4.2% | 26.01 ± 4.7% | 10.85 ± 27.3% | 1.30 ± 4.5% | 11.99 ± 12.1% | 43.00 ± 5.8% | 0.99 | 1.03 | 1.70 | 4.07 |
| a field path | 32606 | 31.37 ± 10.1% | 32.13 ± 7.6% | 1.74 ± 5.3% | 28.37 ± 4.4% | 4.76 ± 5.7% | differs | 4.22 ± 4.5% | 31.91 ± 4.4% | 0.98 | 0.98 | 1.11 | 6.60 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 15.92 ± 6.8% | 15.45 ± 7.1% | 15.83 ± 6.2% | 18.02 ± 4.2% | 7.95 ± 11.3% | 1.09 ± 4.0% | none | 15.83 ± 6.5% | 1.03 | 1.01 | 0.88 | 2.00 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 382.94 ± 0.8% | 386.11 ± 1.3% | 448.74 ± 6.7% | 139.05 ± 1.7% | 344.83 ± 15.4% | 897.30 ± 5.2% | 6115.04 ± 2.2% | 379.28 ± 6.0% | 0.99 | 1.01 | 2.75 | 1.11 |
| a UUID | 62 | 248.15 ± 1.0% | 250.14 ± 2.2% | 275.94 ± 5.3% | 77.05 ± 3.6% | 161.24 ± 24.7% | 318.40 ± 9.0% | 7469.98 ± 3.8% | 248.34 ± 0.7% | 0.99 | 1.00 | 3.22 | 1.54 |
| an IPv4 address | 29 | 731.34 ± 1.9% | 736.54 ± 3.9% | 993.58 ± 5.2% | 122.70 ± 3.8% | 205.01 ± 5.1% | 551.28 ± 4.3% | 13425.74 ± 2.6% | 724.43 ± 1.7% | 0.99 | 1.01 | 5.96 | 3.57 |
| a date and time | 56 | 525.41 ± 0.7% | 529.31 ± 0.8% | 644.65 ± 1.4% | 119.33 ± 0.7% | 232.81 ± 2.6% | 596.36 ± 1.5% | 8414.08 ± 3.8% | 523.86 ± 3.2% | 0.99 | 1.00 | 4.40 | 2.26 |
| a field path | 39 | 381.14 ± 54.6% | 381.40 ± 2.7% | 442.92 ± 2.2% | 131.55 ± 5.6% | 322.32 ± 6.4% | 920.73 ± 2.1% | 7654.53 ± 0.8% | 379.44 ± 18.3% | 1.00 | 1.00 | 2.90 | 1.18 |
| literal: a word | 7 | 1135.06 ± 4.9% | 1221.66 ± 6.4% | 2028.56 ± 3.9% | 874.90 ± 1.2% | 1059.67 ± 14.2% | 1825.53 ± 10.4% | 45035.33 ± 13.5% | 1141.41 ± 3.7% | 0.93 | 0.99 | 1.30 | 1.07 |
| literal: a word that is not there | 8 | 1086.08 ± 1.7% | 1179.21 ± 1.5% | 1921.30 ± 2.0% | 826.34 ± 0.8% | 1025.33 ± 4.6% | 1798.40 ± 5.5% | 49169.52 ± 1.6% | 1081.99 ± 2.7% | 0.92 | 1.00 | 1.31 | 1.06 |
| literal: one of four words | 26 | 422.10 ± 5.7% | 655.65 ± 1.3% | 845.61 ± 6.0% | 70.27 ± 2.5% | 400.24 ± 9.8% | 694.31 ± 1.7% | 28346.82 ± 10.4% | 422.63 ± 1.2% | 0.64 | 1.00 | 6.01 | 1.05 |
| literal: a word in any case | 11 | 790.05 ± 2.1% | 836.15 ± 1.6% | 1173.44 ± 2.3% | 23.43 ± 5.5% | 1129.97 ± 5.0% | refused | 41682.02 ± 2.1% | 790.93 ± 1.4% | 0.94 | 1.00 | 33.72 | 0.70 |
| literal: an href attribute | 12 | 604.22 ± 1.2% | 621.26 ± 0.6% | 797.78 ± 1.8% | 63.84 ± 1.5% | 781.35 ± 1.7% | 1536.64 ± 1.5% | 35493.96 ± 2.3% | 602.21 ± 0.8% | 0.97 | 1.00 | 9.46 | 0.77 |
| literal: a word, second text | 10 | 997.00 ± 1.2% | 1096.91 ± 1.0% | 1711.10 ± 1.8% | 733.57 ± 1.5% | 905.90 ± 13.6% | 1610.62 ± 0.7% | 47573.97 ± 0.4% | 998.86 ± 1.5% | 0.91 | 1.00 | 1.36 | 1.10 |
| class: two capitalized words | 23 | 804.39 ± 1.2% | 868.60 ± 3.5% | 1217.74 ± 3.5% | 166.44 ± 2.8% | 836.09 ± 2.1% | 1495.55 ± 2.4% | 10103.25 ± 5.0% | 807.97 ± 2.8% | 0.93 | 1.00 | 4.83 | 0.96 |
| class: a word that ends in ing | 9 | 1000.17 ± 1.1% | 1137.95 ± 1.6% | 1878.77 ± 1.3% | 210.74 ± 1.6% | 1149.28 ± 14.3% | 2289.07 ± 1.0% | 25832.45 ± 2.6% | 994.97 ± 1.1% | 0.88 | 1.01 | 4.75 | 0.87 |
| class: a word in capitals | 16 | 900.90 ± 0.5% | 973.81 ± 2.7% | 1522.70 ± 3.6% | 211.90 ± 2.3% | 1220.52 ± 1.8% | 2075.42 ± 1.3% | 13105.80 ± 2.2% | 902.98 ± 2.3% | 0.93 | 1.00 | 4.25 | 0.74 |
| class: a number | 6 | 1129.37 ± 2.8% | 1232.54 ± 3.5% | 2199.88 ± 3.7% | 61.38 ± 3.1% | 2228.06 ± 1.9% | 3648.84 ± 0.8% | 38021.12 ± 0.3% | 1126.63 ± 3.4% | 0.92 | 1.00 | 18.40 | 0.51 |
| class: two capitalized words, second text | 23 | 802.34 ± 1.8% | 873.91 ± 1.9% | 1229.83 ± 0.8% | 164.48 ± 0.5% | 823.87 ± 5.6% | 1434.99 ± 2.7% | 10118.78 ± 1.4% | 804.10 ± 1.4% | 0.92 | 1.00 | 4.88 | 0.97 |
| other: a word between two words | 13 | 965.06 ± 6.6% | 1003.73 ± 1.9% | 1546.41 ± 2.4% | 211.27 ± 3.3% | 800.67 ± 4.1% | 1599.14 ± 1.9% | 24738.62 ± 3.6% | 967.15 ± 1.8% | 0.96 | 1.00 | 4.57 | 1.21 |
| other: a number before a unit, second text | 15 | 707.69 ± 2.7% | 791.19 ± 2.1% | 1079.25 ± 3.5% | 58.73 ± 1.0% | 989.47 ± 0.6% | 1805.43 ± 2.9% | 25435.86 ± 1.0% | 704.85 ± 0.6% | 0.89 | 1.00 | 12.05 | 0.72 |
| other: a heading's start tag | 13 | 621.14 ± 2.4% | 633.19 ± 5.8% | 822.65 ± 5.2% | 61.12 ± 0.7% | 960.47 ± 10.4% | 1712.95 ± 0.7% | 29681.30 ± 1.5% | 622.18 ± 2.3% | 0.98 | 1.00 | 10.16 | 0.65 |
| other: a whole word | 11 | 986.74 ± 1.9% | 1047.52 ± 2.1% | 1625.68 ± 4.4% | 191.80 ± 0.3% | 934.73 ± 1.5% | 1656.34 ± 1.4% | 46136.72 ± 0.7% | 986.08 ± 1.4% | 0.94 | 1.00 | 5.14 | 1.06 |
| other: a line's first word, second text | 17 | 948.28 ± 3.0% | 1006.61 ± 2.5% | 1558.37 ± 2.5% | 203.38 ± 2.0% | 1084.77 ± 1.8% | refused | refused | 944.51 ± 2.0% | 0.94 | 1.00 | 4.66 | 0.87 |
| other: fourteen octets before an x | 16 | 188.51 ± 0.7% | 266.24 ± 1.7% | 303.82 ± 0.4% | 23.26 ± 0.8% | 718.59 ± 1.1% | 771.48 ± 1.4% | 21347.84 ± 2.4% | 188.23 ± 1.5% | 0.71 | 1.00 | 8.10 | 0.26 |
| other: a Greek word | 8 | 754.50 ± 40.6% | 1008.17 ± 24.1% | 1596.18 ± 2.3% | 77.35 ± 0.4% | 2205.38 ± 1.8% | 3570.89 ± 0.5% | refused | 751.23 ± 6.3% | 0.75 | 1.00 | 9.76 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 36607.73 ± 1.1% | not timed | not timed | 45806.13 ± 3.1% | 3864.98 ± 13.6% | not timed | not timed | 36597.33 ± 15.4% | | 1.00 | 0.80 | 9.47 |
| 01-literal/sherlock-casei-en | 522 | 14978.22 ± 0.6% | not timed | not timed | 11912.12 ± 5.6% | 52.34 ± 2.1% | not timed | not timed | 15085.26 ± 0.8% | | 0.99 | 1.26 | 286.15 |
| 01-literal/sherlock-ru | 724 | 37532.48 ± 2.2% | not timed | not timed | 46418.03 ± 5.9% | 2442.52 ± 15.0% | not timed | not timed | 37266.35 ± 3.5% | | 1.01 | 0.81 | 15.37 |
| 01-literal/sherlock-casei-ru | 746 | 15415.96 ± 0.5% | not timed | not timed | 9662.82 ± 0.6% | 58.39 ± 2.7% | not timed | not timed | 15330.65 ± 1.1% | | 1.01 | 1.60 | 264.01 |
| 01-literal/sherlock-zh | 30 | 75494.63 ± 1.9% | not timed | not timed | 60910.07 ± 1.3% | 2183.98 ± 0.8% | not timed | not timed | 75313.46 ± 0.4% | | 1.00 | 1.24 | 34.57 |
| 02-literal-alternate/sherlock-en | 714 | 16279.17 ± 1.6% | not timed | not timed | 13959.46 ± 2.2% | 30.13 ± 2.8% | not timed | not timed | 16588.94 ± 3.9% | | 0.98 | 1.17 | 540.35 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3028.30 ± 6.9% | not timed | not timed | 3041.75 ± 5.3% | 18.76 ± 3.7% | not timed | not timed | 2993.38 ± 2.2% | | 1.01 | 1.00 | 161.43 |
| 02-literal-alternate/sherlock-ru | 899 | 12642.53 ± 1.3% | not timed | not timed | 7659.36 ± 1.1% | 39.17 ± 1.1% | not timed | not timed | 12583.41 ± 1.3% | | 1.00 | 1.65 | 322.72 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2767.44 ± 4.4% | not timed | not timed | 1484.51 ± 0.7% | 16.48 ± 4.3% | not timed | not timed | 2758.07 ± 3.6% | | 1.00 | 1.86 | 167.95 |
| 02-literal-alternate/sherlock-zh | 207 | 24058.78 ± 1.5% | not timed | not timed | 16389.76 ± 1.1% | 55.57 ± 1.1% | not timed | not timed | 24027.99 ± 1.3% | | 1.00 | 1.47 | 432.91 |
| 03-date/ascii | 111817 | 158.38 ± 0.4% | not timed | not timed | 130.44 ± 0.3% | 0.31 ± 3.1% | not timed | not timed | 159.31 ± 0.6% | | 0.99 | 1.21 | 507.29 |
| 04-ruff-noqa/real | 84 | 672.67 ± 0.8% | not timed | not timed | 694.75 ± 3.9% | 31.70 ± 2.0% | not timed | not timed | 642.85 ± 0.6% | | 1.05 | 0.97 | 21.22 |
| 04-ruff-noqa/tweaked | 44 | 819.33 ± 0.5% | not timed | not timed | 708.78 ± 0.6% | 499.05 ± 24.8% | not timed | not timed | 820.93 ± 0.5% | | 1.00 | 1.16 | 1.64 |
| 05-lexer-veryl/single | 124800 | 7.57 ± 4.9% | not timed | not timed | 7.88 ± 2.1% | 0.36 ± 8.6% | not timed | not timed | 7.54 ± 4.7% | | 1.00 | 0.96 | 21.27 |
| 06-cloud-flare-redos/original | 107 | 551.46 ± 0.8% | not timed | not timed | 297.18 ± 1.9% | 40.22 ± 0.4% | not timed | not timed | 552.72 ± 0.9% | | 1.00 | 1.86 | 13.71 |
| 06-cloud-flare-redos/simplified-short | 102 | 556.80 ± 0.5% | not timed | not timed | 310.17 ± 2.0% | 43.43 ± 1.8% | not timed | not timed | 559.13 ± 0.2% | | 1.00 | 1.80 | 12.82 |
| 06-cloud-flare-redos/simplified-long | 10000 | 674.57 ± 0.2% | not timed | not timed | 333.66 ± 0.6% | 47.22 ± 2.2% | not timed | not timed | 673.89 ± 0.9% | | 1.00 | 2.02 | 14.28 |
| 07-unicode-character-data/parse-line | 558784 | 340.47 ± 4.4% | not timed | not timed | 264.35 ± 11.1% | 66.02 ± 13.2% | not timed | not timed | 343.91 ± 2.1% | | 0.99 | 1.29 | 5.16 |
| 08-words/all-english | 56691 | 140.85 ± 1.2% | not timed | not timed | 108.77 ± 1.8% | 19.83 ± 13.1% | not timed | not timed | 140.59 ± 0.8% | | 1.00 | 1.29 | 7.10 |
| 08-words/long-english | 839 | 748.46 ± 0.9% | not timed | not timed | 721.25 ± 0.8% | 51.49 ± 1.6% | not timed | not timed | 747.55 ± 1.5% | | 1.00 | 1.04 | 14.54 |
| 09-aws-keys/full | 0 | 687.53 ± 0.4% | not timed | not timed | 712.09 ± 0.7% | 97.77 ± 1.0% | not timed | not timed | 702.33 ± 0.4% | | 0.98 | 0.97 | 7.03 |
| 09-aws-keys/quick | 0 | 1354.69 ± 0.6% | not timed | not timed | 1286.64 ± 0.4% | 568.87 ± 13.1% | not timed | not timed | 1348.37 ± 0.5% | | 1.00 | 1.05 | 2.38 |
| 10-bounded-repeat/letters-en | 1833 | 864.56 ± 0.1% | not timed | not timed | 760.83 ± 0.3% | 30.86 ± 1.1% | not timed | not timed | 865.05 ± 0.1% | | 1.00 | 1.14 | 28.02 |
| 10-bounded-repeat/letters-ru | 3475 | 731.06 ± 3.4% | not timed | not timed | 670.73 ± 1.3% | 31.63 ± 9.9% | not timed | not timed | 737.97 ± 0.5% | | 0.99 | 1.09 | 23.11 |
| 10-bounded-repeat/context | 53 | 111.40 ± 1.1% | not timed | not timed | 95.04 ± 1.4% | 30.73 ± 2.1% | not timed | not timed | 111.61 ± 1.3% | | 1.00 | 1.17 | 3.62 |
| 10-bounded-repeat/capitals | 11 | 786.80 ± 6.9% | not timed | not timed | 745.35 ± 1.7% | 54.66 ± 2.9% | not timed | not timed | 783.79 ± 8.7% | | 1.00 | 1.06 | 14.39 |
| 11-unstructured-to-json/extract | 600 | 111.20 ± 0.9% | not timed | not timed | 107.44 ± 0.5% | 78.42 ± 1.2% | not timed | not timed | 110.74 ± 1.8% | | 1.00 | 1.03 | 1.42 |
| 12-dictionary/single | 1 | 671.30 ± 0.6% | not timed | not timed | 644.32 ± 0.3% | 0.65 ± 3.3% | not timed | not timed | 669.72 ± 0.6% | | 1.00 | 1.04 | 1031.34 |
| 14-quadratic/1x | 100 | 39.99 ± 0.9% | not timed | not timed | 17.77 ± 4.0% | 1.48 ± 2.6% | not timed | not timed | 40.92 ± 1.4% | | 0.98 | 2.25 | 27.01 |
| 14-quadratic/2x | 200 | 31.96 ± 1.4% | not timed | not timed | 8.27 ± 2.4% | 0.82 ± 1.4% | not timed | not timed | 32.33 ± 9.5% | | 0.99 | 3.86 | 39.06 |
| 14-quadratic/10x | 1000 | 11.18 ± 0.8% | not timed | not timed | 1.52 ± 1.7% | 0.18 ± 1.1% | not timed | not timed | 11.26 ± 0.4% | | 0.99 | 7.36 | 61.95 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.14 ± 1.8% | not timed | not timed | 0.56 ± 0.6% | 0.87 ± 4.9% | not timed | not timed | 2.12 ± 9.3% | | 1.01 | 3.84 | 2.44 |
| 04-ruff-noqa/compile-real | 1 | 163.60 ± 0.7% | not timed | not timed | 21.97 ± 0.9% | 232.78 ± 1.1% | not timed | not timed | 163.00 ± 1.4% | | 1.00 | 7.45 | 0.70 |
| 05-lexer-veryl/compile-single | 1 | 23.55 ± 0.2% | not timed | not timed | 4.01 ± 0.5% | 11.23 ± 3.6% | not timed | not timed | 23.49 ± 0.7% | | 1.00 | 5.87 | 2.10 |
| 07-unicode-character-data/compile | 1 | 92.81 ± 0.3% | not timed | not timed | 41.81 ± 1.4% | 62.29 ± 5.0% | not timed | not timed | 92.27 ± 4.2% | | 1.01 | 2.22 | 1.49 |
| 09-aws-keys/compile-full | 1 | 64.22 ± 1.0% | not timed | not timed | 12.86 ± 0.5% | 38.33 ± 2.1% | not timed | not timed | 63.53 ± 0.4% | | 1.01 | 5.00 | 1.68 |
| 09-aws-keys/compile-quick | 1 | 301.71 ± 9.3% | not timed | not timed | 79.39 ± 0.5% | 220.52 ± 1.2% | not timed | not timed | 298.48 ± 1.2% | | 1.01 | 3.80 | 1.37 |
| 10-bounded-repeat/compile-context | 1 | 23.85 ± 0.8% | not timed | not timed | 17.93 ± 1.1% | 27.01 ± 2.8% | not timed | not timed | 23.72 ± 0.6% | | 1.01 | 1.33 | 0.88 |
| 10-bounded-repeat/compile-capitals | 1 | 134.51 ± 0.5% | not timed | not timed | 13.21 ± 5.4% | 39.54 ± 11.2% | not timed | not timed | 133.82 ± 1.1% | | 1.01 | 10.18 | 3.40 |
| 11-unstructured-to-json/compile | 1 | 143.08 ± 0.7% | not timed | not timed | 65.31 ± 1.1% | 116.80 ± 9.7% | not timed | not timed | 142.42 ± 1.3% | | 1.00 | 2.19 | 1.23 |
| 12-dictionary/compile-single | 1 | 0.48 ± 0.4% | not timed | not timed | 0.10 ± 26.8% | 0.15 ± 7.5% | not timed | not timed | 0.47 ± 8.1% | | 1.02 | 4.84 | 3.07 |

