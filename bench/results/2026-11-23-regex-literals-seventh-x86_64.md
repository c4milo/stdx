# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243495094 |
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
| literal: a word | 217 | 67928.05 ± 0.3% | 6536.87 ± 0.3% | 47.75 ± 0.1% | 55452.91 ± 1.1% | 17155.07 ± 3.8% | 16.84 ± 0.7% | 169.37 ± 0.2% | 67732.74 ± 0.5% | 10.39 | 1.00 | 1.22 | 3.96 |
| literal: a word that is not there | 0 | 89718.14 ± 0.6% | 6391.87 ± 0.2% | 47.79 ± 0.4% | 68674.25 ± 0.4% | 58613.47 ± 1.2% | 16.29 ± 0.4% | 151.17 ± 1.6% | 89787.82 ± 2.6% | 14.04 | 1.00 | 1.31 | 1.53 |
| literal: one of four words | 661 | 20360.33 ± 1.7% | 2440.88 ± 1.6% | 26.11 ± 0.3% | 15150.58 ± 1.3% | 40.56 ± 2.2% | 5.33 ± 2.0% | 13.63 ± 8.9% | 20375.35 ± 0.9% | 8.34 | 1.00 | 1.34 | 501.93 |
| literal: a word in any case | 217 | 63309.74 ± 0.5% | 2656.44 ± 0.2% | 34.69 ± 0.9% | 15067.15 ± 0.8% | 75.11 ± 4.8% | refused | differs | 62917.24 ± 0.8% | 23.83 | 1.01 | 4.20 | 842.89 |
| literal: an href attribute | 33 | 54665.00 ± 0.6% | 761.95 ± 2.6% | 40.02 ± 2.8% | 48225.33 ± 0.5% | 3706.46 ± 3.8% | 11.92 ± 0.3% | 140.82 ± 5.8% | 54648.96 ± 0.6% | 71.74 | 1.00 | 1.13 | 14.75 |
| literal: a word, second text | 123 | 68857.39 ± 1.0% | 4630.93 ± 1.6% | 46.38 ± 0.4% | 51421.99 ± 5.4% | 15920.77 ± 5.1% | 22.02 ± 0.5% | 139.08 ± 1.6% | 68583.24 ± 3.5% | 14.87 | 1.00 | 1.34 | 4.33 |
| class: two capitalized words | 1331 | 1164.09 ± 0.8% | 749.17 ± 0.1% | 43.62 ± 2.1% | 719.13 ± 1.7% | 64.51 ± 18.3% | 14.40 ± 2.1% | 110.44 ± 9.5% | 1159.43 ± 0.5% | 1.55 | 1.00 | 1.62 | 18.04 |
| class: a word that ends in ing | 3399 | 717.86 ± 1.7% | 717.10 ± 0.9% | 28.87 ± 1.1% | 674.65 ± 0.4% | 48.25 ± 10.0% | 8.25 ± 0.3% | 32.24 ± 2.0% | 716.67 ± 0.3% | 1.00 | 1.00 | 1.06 | 14.88 |
| class: a word in capitals | 2332 | 1663.89 ± 2.9% | 752.53 ± 0.4% | 42.55 ± 0.8% | 705.15 ± 0.9% | 69.46 ± 9.7% | 17.43 ± 1.1% | 142.43 ± 5.0% | 1648.19 ± 4.1% | 2.21 | 1.01 | 2.36 | 23.95 |
| class: a number | 8288 | 2786.78 ± 0.2% | 1018.33 ± 0.9% | 45.30 ± 0.3% | 2422.01 ± 0.4% | 68.21 ± 15.6% | 0.48 ± 1.3% | 101.50 ± 6.1% | 2788.02 ± 0.2% | 2.74 | 1.00 | 1.15 | 40.85 |
| class: two capitalized words, second text | 5359 | 635.33 ± 0.6% | 641.86 ± 0.4% | 39.04 ± 0.7% | 601.50 ± 0.8% | 51.59 ± 22.2% | 18.85 ± 2.2% | 100.43 ± 4.0% | 635.39 ± 0.3% | 0.99 | 1.00 | 1.06 | 12.32 |
| other: a word between two words | 6104 | 1144.30 ± 0.4% | 729.17 ± 0.2% | 36.90 ± 5.3% | 1026.96 ± 1.2% | 184.13 ± 16.9% | 10.87 ± 1.0% | 119.77 ± 1.4% | 1141.70 ± 4.6% | 1.57 | 1.00 | 1.11 | 6.21 |
| other: a number before a unit, second text | 1481 | 13563.16 ± 0.7% | 1477.47 ± 2.3% | 42.75 ± 1.2% | 11289.22 ± 0.3% | 63.86 ± 11.8% | 19.52 ± 0.2% | 112.55 ± 2.4% | 13390.00 ± 0.3% | 9.18 | 1.01 | 1.20 | 212.38 |
| other: a heading's start tag | 110 | 32980.95 ± 1.1% | 924.20 ± 0.1% | 43.09 ± 2.6% | 3479.11 ± 4.8% | 2707.54 ± 11.8% | 14.93 ± 0.5% | 174.22 ± 3.8% | 32869.34 ± 2.8% | 35.69 | 1.00 | 9.48 | 12.18 |
| other: a whole word | 217 | 41926.33 ± 0.2% | 751.76 ± 0.2% | 47.52 ± 7.6% | 38740.36 ± 1.2% | 79.38 ± 8.5% | 14.52 ± 4.4% | 88.04 ± 4.8% | 41797.32 ± 0.4% | 55.77 | 1.00 | 1.08 | 528.19 |
| other: a line's first word, second text | 3716 | 3608.40 ± 1.7% | 733.60 ± 0.1% | 51.81 ± 2.4% | 3659.89 ± 1.6% | 105.80 ± 4.3% | refused | refused | 3584.77 ± 3.1% | 4.92 | 1.01 | 0.99 | 34.11 |
| other: fourteen octets before an x | 87 | 53971.28 ± 2.8% | 373.28 ± 0.7% | 9.70 ± 1.1% | 5098.46 ± 8.1% | 14.84 ± 3.4% | differs | 26.49 ± 3.1% | 54480.42 ± 3.3% | 144.59 | 0.99 | 10.59 | 3637.97 |
| other: a Greek word | 21815 | 616.30 ± 1.0% | 497.36 ± 0.4% | 49.56 ± 1.0% | 377.08 ± 0.3% | 83.93 ± 2.8% | differs | refused | 627.14 ± 0.7% | 1.24 | 0.98 | 1.63 | 7.34 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 27.25 ± 1.3% | 27.67 ± 0.9% | 1.55 ± 1.9% | 25.14 ± 0.1% | 3.84 ± 2.3% | differs | 6.08 ± 2.3% | 27.65 ± 0.7% | 0.98 | 0.99 | 1.08 | 7.09 |
| a UUID | 32895 | 30.15 ± 0.3% | 30.17 ± 1.7% | 1.04 ± 4.6% | 19.17 ± 1.9% | 3.77 ± 7.0% | 0.77 ± 1.3% | 4.84 ± 8.6% | 29.74 ± 0.8% | 1.00 | 1.01 | 1.57 | 7.99 |
| an IPv4 address | 33176 | 46.53 ± 1.4% | 46.43 ± 0.6% | 3.34 ± 0.9% | 36.56 ± 0.2% | 9.63 ± 2.5% | differs | 6.10 ± 1.9% | 46.22 ± 5.0% | 1.00 | 1.01 | 1.27 | 4.83 |
| a date and time | 32954 | 43.97 ± 0.4% | 43.16 ± 4.3% | 2.52 ± 1.1% | 27.55 ± 0.2% | 11.12 ± 6.4% | 1.36 ± 0.4% | 11.95 ± 7.5% | 43.62 ± 4.2% | 1.02 | 1.01 | 1.60 | 3.96 |
| a field path | 32606 | 31.43 ± 1.3% | 31.41 ± 1.1% | 1.79 ± 1.2% | 29.13 ± 0.1% | 4.97 ± 1.0% | differs | 4.29 ± 1.5% | 31.47 ± 0.3% | 1.00 | 1.00 | 1.08 | 6.33 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 16.14 ± 8.9% | 15.46 ± 1.5% | 16.35 ± 0.6% | 18.12 ± 0.4% | 8.23 ± 8.0% | 1.13 ± 0.7% | none | 16.01 ± 2.5% | 1.04 | 1.01 | 0.89 | 1.96 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 394.21 ± 6.5% | 398.31 ± 1.4% | 460.62 ± 1.4% | 142.63 ± 1.1% | 354.68 ± 13.2% | 939.42 ± 7.3% | 6133.62 ± 0.5% | 392.43 ± 1.6% | 0.99 | 1.00 | 2.76 | 1.11 |
| a UUID | 62 | 254.09 ± 1.1% | 255.50 ± 0.4% | 281.21 ± 0.9% | 78.38 ± 1.7% | 170.62 ± 19.2% | 329.58 ± 1.8% | 7301.19 ± 12.2% | 254.57 ± 4.8% | 0.99 | 1.00 | 3.24 | 1.49 |
| an IPv4 address | 29 | 765.89 ± 1.6% | 776.09 ± 1.3% | 1056.33 ± 0.8% | 126.86 ± 0.6% | 219.70 ± 2.4% | 599.69 ± 1.7% | 13367.79 ± 0.6% | 767.14 ± 1.4% | 0.99 | 1.00 | 6.04 | 3.49 |
| a date and time | 56 | 543.54 ± 1.0% | 547.07 ± 0.7% | 666.67 ± 0.5% | 122.10 ± 1.4% | 238.48 ± 7.9% | 611.83 ± 1.7% | 7779.01 ± 2.1% | 541.78 ± 1.1% | 0.99 | 1.00 | 4.45 | 2.28 |
| a field path | 39 | 391.04 ± 4.7% | 396.09 ± 0.6% | 458.74 ± 5.2% | 132.78 ± 3.2% | 338.84 ± 4.4% | 970.63 ± 2.2% | 7770.17 ± 0.9% | 391.81 ± 1.2% | 0.99 | 1.00 | 2.95 | 1.15 |
| literal: a word | 7 | 1185.42 ± 1.3% | 1298.85 ± 0.9% | 2224.11 ± 1.4% | 842.52 ± 0.8% | 1102.41 ± 2.0% | 1962.59 ± 0.2% | 49937.32 ± 0.2% | 1178.83 ± 1.7% | 0.91 | 1.01 | 1.41 | 1.08 |
| literal: a word that is not there | 8 | 1129.48 ± 1.6% | 1244.69 ± 1.4% | 2058.08 ± 2.1% | 796.21 ± 0.7% | 1061.32 ± 2.1% | 1847.71 ± 0.1% | 48809.06 ± 0.2% | 1119.27 ± 1.3% | 0.91 | 1.01 | 1.42 | 1.06 |
| literal: one of four words | 26 | 438.25 ± 1.0% | 692.21 ± 1.2% | 894.27 ± 2.3% | 70.24 ± 0.5% | 416.58 ± 1.9% | 693.21 ± 1.8% | 25047.24 ± 1.7% | 439.61 ± 1.2% | 0.63 | 1.00 | 6.24 | 1.05 |
| literal: a word in any case | 11 | 819.78 ± 0.8% | 872.20 ± 1.5% | 1226.50 ± 1.0% | 24.17 ± 5.5% | 1170.57 ± 22.8% | refused | 39565.08 ± 6.4% | 820.15 ± 2.1% | 0.94 | 1.00 | 33.92 | 0.70 |
| literal: an href attribute | 12 | 618.09 ± 2.1% | 646.71 ± 1.5% | 833.82 ± 2.0% | 64.49 ± 0.9% | 804.42 ± 9.7% | 1559.16 ± 0.6% | 37163.41 ± 0.7% | 616.63 ± 1.0% | 0.96 | 1.00 | 9.58 | 0.77 |
| literal: a word, second text | 10 | 1023.09 ± 3.1% | 1135.50 ± 0.9% | 1803.28 ± 2.3% | 721.69 ± 6.6% | 926.03 ± 16.0% | 1610.11 ± 0.5% | 47163.44 ± 0.5% | 1028.82 ± 2.0% | 0.90 | 0.99 | 1.42 | 1.10 |
| class: two capitalized words | 23 | 840.46 ± 1.8% | 898.70 ± 4.9% | 1291.79 ± 1.7% | 168.90 ± 4.5% | 848.69 ± 0.6% | 1529.57 ± 0.3% | 10012.97 ± 0.5% | 838.61 ± 1.2% | 0.94 | 1.00 | 4.98 | 0.99 |
| class: a word that ends in ing | 9 | 1028.42 ± 3.8% | 1181.65 ± 2.1% | 1974.91 ± 3.2% | 217.58 ± 1.5% | 1169.96 ± 2.6% | 2331.96 ± 2.4% | 25639.89 ± 3.1% | 1029.21 ± 4.2% | 0.87 | 1.00 | 4.73 | 0.88 |
| class: a word in capitals | 16 | 942.70 ± 1.0% | 1026.77 ± 1.3% | 1612.25 ± 0.7% | 220.61 ± 1.1% | 1245.24 ± 13.5% | 2169.31 ± 0.3% | 12914.72 ± 3.5% | 941.26 ± 8.4% | 0.92 | 1.00 | 4.27 | 0.76 |
| class: a number | 6 | 1167.18 ± 1.8% | 1300.15 ± 1.8% | 2342.79 ± 3.8% | 61.78 ± 2.4% | 2267.34 ± 12.8% | 3937.00 ± 0.7% | 37570.74 ± 0.5% | 1164.39 ± 3.0% | 0.90 | 1.00 | 18.89 | 0.51 |
| class: two capitalized words, second text | 23 | 841.74 ± 0.6% | 910.98 ± 1.4% | 1287.00 ± 1.7% | 165.70 ± 0.3% | 851.51 ± 8.6% | 1539.48 ± 0.4% | 10007.06 ± 0.8% | 843.44 ± 1.4% | 0.92 | 1.00 | 5.08 | 0.99 |
| other: a word between two words | 13 | 1008.47 ± 1.1% | 1071.10 ± 1.1% | 1624.38 ± 1.3% | 222.78 ± 7.4% | 817.79 ± 11.4% | 1636.55 ± 5.9% | 24334.90 ± 0.4% | 1008.85 ± 1.1% | 0.94 | 1.00 | 4.53 | 1.23 |
| other: a number before a unit, second text | 15 | 716.95 ± 4.7% | 821.57 ± 1.1% | 1120.34 ± 1.5% | 59.07 ± 6.0% | 1018.89 ± 1.3% | 1837.24 ± 1.5% | 25084.81 ± 1.4% | 716.34 ± 3.1% | 0.87 | 1.00 | 12.14 | 0.70 |
| other: a heading's start tag | 13 | 636.97 ± 9.4% | 667.67 ± 9.9% | 860.51 ± 1.3% | 61.99 ± 4.4% | 995.44 ± 4.6% | 1746.79 ± 1.2% | 30097.40 ± 14.0% | 640.32 ± 4.6% | 0.95 | 0.99 | 10.28 | 0.64 |
| other: a whole word | 11 | 1025.62 ± 3.3% | 1118.02 ± 1.6% | 1759.83 ± 9.0% | 197.09 ± 6.4% | 959.10 ± 4.7% | 1683.14 ± 4.9% | 44599.23 ± 1.7% | 1032.60 ± 2.3% | 0.92 | 0.99 | 5.20 | 1.07 |
| other: a line's first word, second text | 17 | 988.20 ± 1.8% | 1062.14 ± 1.3% | 1647.89 ± 1.7% | 208.54 ± 1.0% | 1115.87 ± 2.5% | refused | refused | 981.27 ± 1.0% | 0.93 | 1.01 | 4.74 | 0.89 |
| other: fourteen octets before an x | 16 | 186.76 ± 0.4% | 266.75 ± 0.9% | 301.36 ± 0.6% | 23.49 ± 0.5% | 743.45 ± 0.8% | 791.90 ± 1.4% | 21828.75 ± 0.3% | 186.75 ± 6.3% | 0.70 | 1.00 | 7.95 | 0.25 |
| other: a Greek word | 8 | 793.67 ± 0.7% | 1072.43 ± 1.7% | 1696.45 ± 1.1% | 78.74 ± 0.3% | 2235.17 ± 1.7% | 3628.26 ± 0.6% | refused | 793.10 ± 2.9% | 0.74 | 1.00 | 10.08 | 0.36 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 47116.16 ± 0.5% | not timed | not timed | 45710.57 ± 2.5% | 3723.32 ± 19.0% | not timed | not timed | 46993.92 ± 0.7% | | 1.00 | 1.03 | 12.65 |
| 01-literal/sherlock-casei-en | 522 | 15493.43 ± 0.2% | not timed | not timed | 12013.81 ± 0.4% | 53.95 ± 22.3% | not timed | not timed | 15523.17 ± 0.7% | | 1.00 | 1.29 | 287.20 |
| 01-literal/sherlock-ru | 724 | 47384.34 ± 0.5% | not timed | not timed | 44817.06 ± 1.4% | 2396.81 ± 6.7% | not timed | not timed | 47255.33 ± 0.2% | | 1.00 | 1.06 | 19.77 |
| 01-literal/sherlock-casei-ru | 746 | 15602.38 ± 0.2% | not timed | not timed | 9816.26 ± 3.6% | 59.66 ± 0.6% | not timed | not timed | 15609.41 ± 0.1% | | 1.00 | 1.59 | 261.53 |
| 01-literal/sherlock-zh | 30 | 82893.24 ± 3.0% | not timed | not timed | 60557.40 ± 16.5% | 2217.75 ± 0.8% | not timed | not timed | 82605.96 ± 0.8% | | 1.00 | 1.37 | 37.38 |
| 02-literal-alternate/sherlock-en | 714 | 17123.96 ± 1.7% | not timed | not timed | 14075.60 ± 0.4% | 30.12 ± 1.9% | not timed | not timed | 17159.49 ± 8.5% | | 1.00 | 1.22 | 568.52 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3144.59 ± 6.3% | not timed | not timed | 3090.19 ± 0.6% | 18.94 ± 2.2% | not timed | not timed | 3000.69 ± 2.1% | | 1.05 | 1.02 | 166.01 |
| 02-literal-alternate/sherlock-ru | 899 | 13202.09 ± 0.5% | not timed | not timed | 7789.10 ± 2.0% | 39.63 ± 8.2% | not timed | not timed | 13222.73 ± 0.6% | | 1.00 | 1.69 | 333.17 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2915.20 ± 1.9% | not timed | not timed | 1518.54 ± 0.6% | 16.76 ± 2.0% | not timed | not timed | 2878.36 ± 0.6% | | 1.01 | 1.92 | 173.94 |
| 02-literal-alternate/sherlock-zh | 207 | 24878.51 ± 0.7% | not timed | not timed | 16576.03 ± 2.9% | 56.12 ± 0.5% | not timed | not timed | 24865.19 ± 6.7% | | 1.00 | 1.50 | 443.34 |
| 03-date/ascii | 111817 | 161.62 ± 0.3% | not timed | not timed | 130.64 ± 0.5% | 0.32 ± 5.2% | not timed | not timed | 156.81 ± 3.0% | | 1.03 | 1.24 | 507.94 |
| 04-ruff-noqa/real | 84 | 692.84 ± 0.3% | not timed | not timed | 715.33 ± 13.2% | 32.49 ± 1.2% | not timed | not timed | 660.59 ± 1.3% | | 1.05 | 0.97 | 21.33 |
| 04-ruff-noqa/tweaked | 44 | 845.93 ± 1.1% | not timed | not timed | 726.82 ± 4.2% | 502.69 ± 1.7% | not timed | not timed | 839.31 ± 6.4% | | 1.01 | 1.16 | 1.68 |
| 05-lexer-veryl/single | 124800 | 7.29 ± 10.8% | not timed | not timed | 8.09 ± 6.2% | 0.38 ± 7.1% | not timed | not timed | 7.03 ± 14.1% | | 1.04 | 0.90 | 19.29 |
| 06-cloud-flare-redos/original | 107 | 558.59 ± 0.2% | not timed | not timed | 295.81 ± 0.9% | 41.05 ± 0.4% | not timed | not timed | 563.78 ± 1.1% | | 0.99 | 1.89 | 13.61 |
| 06-cloud-flare-redos/simplified-short | 102 | 564.69 ± 3.1% | not timed | not timed | 315.41 ± 0.8% | 43.48 ± 0.9% | not timed | not timed | 564.67 ± 0.3% | | 1.00 | 1.79 | 12.99 |
| 06-cloud-flare-redos/simplified-long | 10000 | 681.55 ± 0.1% | not timed | not timed | 337.61 ± 0.3% | 47.92 ± 2.2% | not timed | not timed | 681.30 ± 0.1% | | 1.00 | 2.02 | 14.22 |
| 07-unicode-character-data/parse-line | 558784 | 341.80 ± 12.1% | not timed | not timed | 260.98 ± 0.6% | 70.98 ± 7.7% | not timed | not timed | 344.22 ± 4.6% | | 0.99 | 1.31 | 4.82 |
| 08-words/all-english | 56691 | 141.37 ± 0.3% | not timed | not timed | 112.97 ± 0.5% | 21.41 ± 9.8% | not timed | not timed | 141.57 ± 0.3% | | 1.00 | 1.25 | 6.60 |
| 08-words/long-english | 839 | 760.10 ± 0.1% | not timed | not timed | 728.25 ± 0.3% | 52.06 ± 1.1% | not timed | not timed | 759.87 ± 0.3% | | 1.00 | 1.04 | 14.60 |
| 09-aws-keys/full | 0 | 695.51 ± 0.3% | not timed | not timed | 756.96 ± 1.6% | 101.95 ± 13.2% | not timed | not timed | 688.19 ± 0.6% | | 1.01 | 0.92 | 6.82 |
| 09-aws-keys/quick | 0 | 1583.89 ± 2.1% | not timed | not timed | 1296.60 ± 0.7% | 576.30 ± 0.6% | not timed | not timed | 1577.11 ± 3.3% | | 1.00 | 1.22 | 2.75 |
| 10-bounded-repeat/letters-en | 1833 | 875.03 ± 6.3% | not timed | not timed | 771.28 ± 1.3% | 30.70 ± 3.0% | not timed | not timed | 876.66 ± 0.1% | | 1.00 | 1.13 | 28.50 |
| 10-bounded-repeat/letters-ru | 3475 | 746.96 ± 4.8% | not timed | not timed | 672.29 ± 1.1% | 31.74 ± 8.6% | not timed | not timed | 742.21 ± 1.3% | | 1.01 | 1.11 | 23.53 |
| 10-bounded-repeat/context | 53 | 114.34 ± 2.5% | not timed | not timed | 95.28 ± 0.7% | 31.00 ± 0.3% | not timed | not timed | 115.24 ± 1.1% | | 0.99 | 1.20 | 3.69 |
| 10-bounded-repeat/capitals | 11 | 794.88 ± 8.1% | not timed | not timed | 753.40 ± 0.4% | 55.17 ± 3.1% | not timed | not timed | 793.29 ± 8.1% | | 1.00 | 1.06 | 14.41 |
| 11-unstructured-to-json/extract | 600 | 113.62 ± 1.3% | not timed | not timed | 109.94 ± 0.6% | 80.13 ± 1.7% | not timed | not timed | 112.71 ± 16.9% | | 1.01 | 1.03 | 1.42 |
| 12-dictionary/single | 1 | 677.62 ± 0.1% | not timed | not timed | 650.28 ± 0.2% | 0.68 ± 9.5% | not timed | not timed | 678.16 ± 1.4% | | 1.00 | 1.04 | 998.04 |
| 14-quadratic/1x | 100 | 41.34 ± 0.4% | not timed | not timed | 17.84 ± 0.4% | 1.53 ± 2.7% | not timed | not timed | 41.85 ± 0.1% | | 0.99 | 2.32 | 27.10 |
| 14-quadratic/2x | 200 | 32.91 ± 0.3% | not timed | not timed | 8.35 ± 0.6% | 0.83 ± 2.1% | not timed | not timed | 33.21 ± 0.6% | | 0.99 | 3.94 | 39.62 |
| 14-quadratic/10x | 1000 | 11.37 ± 21.9% | not timed | not timed | 1.54 ± 32.4% | 0.18 ± 7.0% | not timed | not timed | 11.40 ± 5.1% | | 1.00 | 7.38 | 62.24 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.14 ± 7.6% | not timed | not timed | 0.56 ± 18.6% | 0.89 ± 4.9% | not timed | not timed | 2.13 ± 2.7% | | 1.00 | 3.80 | 2.40 |
| 04-ruff-noqa/compile-real | 1 | 166.30 ± 0.4% | not timed | not timed | 22.22 ± 0.5% | 239.59 ± 3.5% | not timed | not timed | 165.60 ± 0.9% | | 1.00 | 7.48 | 0.69 |
| 05-lexer-veryl/compile-single | 1 | 23.89 ± 1.7% | not timed | not timed | 4.09 ± 0.8% | 11.47 ± 2.7% | not timed | not timed | 23.63 ± 1.4% | | 1.01 | 5.84 | 2.08 |
| 07-unicode-character-data/compile | 1 | 93.82 ± 0.2% | not timed | not timed | 42.43 ± 1.7% | 64.38 ± 2.3% | not timed | not timed | 93.00 ± 0.6% | | 1.01 | 2.21 | 1.46 |
| 09-aws-keys/compile-full | 1 | 64.08 ± 0.8% | not timed | not timed | 13.19 ± 1.4% | 39.49 ± 1.8% | not timed | not timed | 63.89 ± 1.0% | | 1.00 | 4.86 | 1.62 |
| 09-aws-keys/compile-quick | 1 | 309.13 ± 1.6% | not timed | not timed | 81.42 ± 0.6% | 225.89 ± 5.8% | not timed | not timed | 307.23 ± 0.9% | | 1.01 | 3.80 | 1.37 |
| 10-bounded-repeat/compile-context | 1 | 23.21 ± 3.8% | not timed | not timed | 18.41 ± 0.6% | 28.34 ± 2.0% | not timed | not timed | 23.20 ± 3.0% | | 1.00 | 1.26 | 0.82 |
| 10-bounded-repeat/compile-capitals | 1 | 134.84 ± 0.9% | not timed | not timed | 13.40 ± 0.2% | 40.86 ± 3.7% | not timed | not timed | 134.39 ± 0.4% | | 1.00 | 10.06 | 3.30 |
| 11-unstructured-to-json/compile | 1 | 144.21 ± 0.4% | not timed | not timed | 65.62 ± 1.2% | 119.30 ± 13.6% | not timed | not timed | 143.45 ± 0.8% | | 1.01 | 2.20 | 1.21 |
| 12-dictionary/compile-single | 1 | 0.47 ± 1.8% | not timed | not timed | 0.10 ± 0.5% | 0.15 ± 25.6% | not timed | not timed | 0.47 ± 1.1% | | 1.01 | 4.65 | 3.18 |

