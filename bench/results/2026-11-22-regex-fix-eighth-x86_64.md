# bench-regex

| Field | Value |
|---|---|
| Commit | f2b7425 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45063438911 |
| Date | 2026-11-22 |
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
| literal: a word | 217 | 35909.72 ± 2.3% | 1086.01 ± 1.0% | 35.70 ± 0.7% | 33128.30 ± 1.3% | 12392.44 ± 5.0% | 14.89 ± 1.3% | 115.13 ± 1.1% | 35856.60 ± 1.6% | 33.07 | 1.00 | 1.08 | 2.90 |
| literal: a word that is not there | 0 | 45622.33 ± 1.2% | 1096.37 ± 0.4% | 32.07 ± 0.6% | 35865.69 ± 1.6% | 40425.68 ± 1.6% | 14.31 ± 0.5% | 107.99 ± 0.8% | 45547.30 ± 0.6% | 41.61 | 1.00 | 1.27 | 1.13 |
| literal: one of four words | 661 | 12103.80 ± 1.6% | 1061.45 ± 0.9% | 18.93 ± 1.1% | 9773.54 ± 1.4% | 27.73 ± 1.0% | 4.33 ± 0.8% | 9.19 ± 0.7% | 12071.82 ± 3.5% | 11.40 | 1.00 | 1.24 | 436.47 |
| literal: a word in any case | 217 | 28677.30 ± 1.2% | 1084.26 ± 0.4% | 26.11 ± 0.7% | 10025.84 ± 0.4% | 58.20 ± 0.9% | refused | differs | 28661.98 ± 0.2% | 26.45 | 1.00 | 2.86 | 492.77 |
| literal: an href attribute | 33 | 34853.98 ± 0.2% | 1092.01 ± 0.3% | 31.91 ± 1.1% | 29562.44 ± 0.4% | 2590.12 ± 2.0% | 10.60 ± 0.5% | 98.66 ± 0.6% | 34807.99 ± 0.4% | 31.92 | 1.00 | 1.18 | 13.46 |
| literal: a word, second text | 123 | 37117.10 ± 0.6% | 1088.45 ± 0.6% | 32.01 ± 0.4% | 32958.40 ± 0.6% | 9075.00 ± 11.0% | 19.31 ± 0.6% | 96.22 ± 0.6% | 37103.61 ± 0.4% | 34.10 | 1.00 | 1.13 | 4.09 |
| class: two capitalized words | 1331 | 998.48 ± 0.1% | 1001.79 ± 0.2% | 32.87 ± 1.1% | 612.24 ± 0.5% | 48.22 ± 0.5% | 12.64 ± 0.6% | 81.38 ± 1.0% | 994.45 ± 0.3% | 1.00 | 1.00 | 1.63 | 20.71 |
| class: a word that ends in ing | 3399 | 913.81 ± 1.0% | 913.95 ± 0.6% | 22.06 ± 1.5% | 575.77 ± 0.8% | 35.43 ± 9.6% | 7.13 ± 0.5% | 22.69 ± 0.9% | 910.43 ± 0.6% | 1.00 | 1.00 | 1.59 | 25.79 |
| class: a word in capitals | 2332 | 1362.37 ± 1.7% | 978.28 ± 0.6% | 31.83 ± 0.3% | 602.59 ± 0.3% | 51.13 ± 12.3% | 15.15 ± 1.2% | 100.59 ± 0.7% | 1363.24 ± 0.4% | 1.39 | 1.00 | 2.26 | 26.65 |
| class: a number | 8288 | 2040.49 ± 2.6% | 831.09 ± 1.4% | 31.38 ± 0.6% | 2159.36 ± 1.1% | 51.58 ± 14.5% | 0.42 ± 0.4% | 70.44 ± 0.7% | 2042.92 ± 0.5% | 2.46 | 1.00 | 0.94 | 39.56 |
| class: two capitalized words, second text | 5359 | 726.67 ± 0.5% | 725.87 ± 0.5% | 29.61 ± 2.2% | 510.41 ± 0.5% | 41.57 ± 9.1% | 16.42 ± 0.6% | 73.95 ± 1.6% | 726.97 ± 0.7% | 1.00 | 1.00 | 1.42 | 17.48 |
| other: a word between two words | 6104 | 841.67 ± 0.8% | 778.09 ± 0.8% | 29.56 ± 0.9% | 879.72 ± 0.4% | 126.31 ± 8.0% | 9.61 ± 0.7% | 84.79 ± 0.6% | 842.76 ± 0.9% | 1.08 | 1.00 | 0.96 | 6.66 |
| other: a number before a unit, second text | 1481 | 9986.53 ± 2.6% | 1019.16 ± 0.4% | 29.98 ± 0.5% | 9868.01 ± 1.3% | 47.76 ± 6.1% | 17.20 ± 0.7% | 79.04 ± 0.5% | 9831.50 ± 0.9% | 9.80 | 1.02 | 1.01 | 209.11 |
| other: a heading's start tag | 110 | 21371.61 ± 2.3% | 1080.90 ± 0.8% | 31.08 ± 0.6% | 2645.87 ± 0.7% | 1885.18 ± 7.6% | 13.10 ± 0.6% | 116.52 ± 1.1% | 21264.50 ± 1.4% | 19.77 | 1.01 | 8.08 | 11.34 |
| other: a whole word | 217 | 27082.31 ± 0.7% | 1077.02 ± 0.4% | 35.30 ± 0.2% | 26071.58 ± 2.2% | 59.26 ± 1.0% | 12.57 ± 0.8% | 67.27 ± 0.7% | 27132.57 ± 1.7% | 25.15 | 1.00 | 1.04 | 457.04 |
| other: a line's first word, second text | 3716 | 2703.41 ± 0.4% | 897.08 ± 0.3% | 37.13 ± 1.4% | 2518.86 ± 1.1% | 79.47 ± 3.1% | refused | refused | 2692.74 ± 0.6% | 3.01 | 1.00 | 1.07 | 34.02 |
| other: fourteen octets before an x | 87 | 37256.16 ± 1.3% | 1.77 ± 0.4% | 1.73 ± 0.2% | 4183.38 ± 1.8% | 11.52 ± 1.3% | differs | 20.13 ± 0.3% | 37071.66 ± 0.4% | 21038.14 | 1.00 | 8.91 | 3234.64 |
| other: a Greek word | 21815 | 472.79 ± 0.9% | 344.75 ± 0.8% | 37.52 ± 0.6% | 317.83 ± 0.3% | 61.02 ± 10.8% | differs | refused | 474.42 ± 0.5% | 1.37 | 1.00 | 1.49 | 7.75 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 30.60 ± 0.9% | 30.59 ± 1.0% | 0.61 ± 1.5% | 28.53 ± 0.7% | 3.26 ± 0.5% | differs | 4.93 ± 0.4% | 30.55 ± 1.3% | 1.00 | 1.00 | 1.07 | 9.38 |
| a UUID | 32895 | 27.01 ± 1.6% | 26.99 ± 0.5% | 0.76 ± 0.6% | 21.09 ± 1.6% | 3.09 ± 1.2% | 0.71 ± 0.4% | 4.08 ± 0.6% | 26.99 ± 1.0% | 1.00 | 1.00 | 1.28 | 8.74 |
| an IPv4 address | 33176 | 41.65 ± 0.8% | 41.69 ± 0.6% | 2.46 ± 0.6% | 38.85 ± 0.7% | 7.84 ± 0.7% | differs | 4.61 ± 0.4% | 41.65 ± 0.5% | 1.00 | 1.00 | 1.07 | 5.31 |
| a date and time | 32954 | 40.32 ± 0.4% | 40.36 ± 0.6% | 1.75 ± 1.1% | 34.57 ± 1.7% | 10.06 ± 0.5% | 1.30 ± 0.7% | 8.97 ± 1.1% | 40.25 ± 0.1% | 1.00 | 1.00 | 1.17 | 4.01 |
| a field path | 32606 | 33.52 ± 0.6% | 33.55 ± 1.5% | 1.08 ± 0.5% | 31.11 ± 0.8% | 3.65 ± 0.5% | differs | 3.08 ± 0.2% | 33.43 ± 1.2% | 1.00 | 1.00 | 1.08 | 9.18 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.35 ± 1.7% | 11.35 ± 0.4% | 11.33 ± 0.7% | 14.60 ± 0.5% | 6.56 ± 1.6% | 1.02 ± 1.0% | none | 11.35 ± 1.0% | 1.00 | 1.00 | 0.78 | 1.73 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 362.01 ± 0.9% | 363.66 ± 0.4% | 420.50 ± 0.6% | 115.01 ± 1.3% | 259.97 ± 2.1% | 686.18 ± 2.3% | 3583.89 ± 0.7% | 361.63 ± 0.3% | 1.00 | 1.00 | 3.15 | 1.39 |
| a UUID | 62 | 244.33 ± 2.9% | 245.89 ± 0.7% | 277.09 ± 0.8% | 61.15 ± 0.7% | 118.54 ± 0.6% | 251.96 ± 3.0% | 4462.07 ± 0.9% | 244.19 ± 0.8% | 0.99 | 1.00 | 4.00 | 2.06 |
| an IPv4 address | 29 | 633.62 ± 1.0% | 637.60 ± 0.6% | 852.79 ± 0.8% | 99.44 ± 0.5% | 156.56 ± 1.5% | 427.69 ± 0.7% | 8431.15 ± 1.5% | 618.71 ± 3.1% | 0.99 | 1.02 | 6.37 | 4.05 |
| a date and time | 56 | 472.05 ± 0.8% | 473.77 ± 0.3% | 589.17 ± 0.4% | 94.34 ± 1.0% | 166.50 ± 2.5% | 443.87 ± 1.3% | 4691.77 ± 1.3% | 472.67 ± 0.8% | 1.00 | 1.00 | 5.00 | 2.84 |
| a field path | 39 | 384.78 ± 1.0% | 386.20 ± 1.0% | 450.98 ± 0.8% | 104.74 ± 1.1% | 246.13 ± 1.4% | 708.13 ± 1.1% | 4604.21 ± 2.4% | 384.07 ± 0.5% | 1.00 | 1.00 | 3.67 | 1.56 |
| literal: a word | 7 | 1126.84 ± 1.5% | 1172.84 ± 3.3% | 1903.02 ± 1.6% | 701.91 ± 1.8% | 807.76 ± 12.1% | 1439.25 ± 0.9% | 30518.14 ± 3.3% | 1126.54 ± 0.4% | 0.96 | 1.00 | 1.61 | 1.40 |
| literal: a word that is not there | 8 | 1090.96 ± 0.9% | 1129.45 ± 1.3% | 1802.75 ± 0.9% | 624.75 ± 3.1% | 771.22 ± 20.9% | 1348.68 ± 1.4% | 28893.91 ± 4.0% | 1090.40 ± 0.8% | 0.97 | 1.00 | 1.75 | 1.41 |
| literal: one of four words | 26 | 592.27 ± 1.2% | 664.53 ± 0.6% | 864.07 ± 1.1% | 51.80 ± 1.2% | 303.02 ± 3.2% | 497.56 ± 1.8% | 14354.60 ± 1.8% | 591.95 ± 0.8% | 0.89 | 1.00 | 11.43 | 1.95 |
| literal: a word in any case | 11 | 817.95 ± 0.6% | 854.30 ± 0.6% | 1192.14 ± 3.1% | 16.93 ± 0.7% | 855.33 ± 1.0% | refused | 22426.32 ± 2.8% | 816.60 ± 1.4% | 0.96 | 1.00 | 48.31 | 0.96 |
| literal: an href attribute | 12 | 586.31 ± 1.2% | 594.47 ± 1.9% | 751.86 ± 1.5% | 49.29 ± 0.6% | 619.56 ± 1.8% | 1145.30 ± 1.0% | 22118.50 ± 2.4% | 584.35 ± 3.8% | 0.99 | 1.00 | 11.90 | 0.95 |
| literal: a word, second text | 10 | 1019.94 ± 1.1% | 1060.69 ± 1.0% | 1632.05 ± 1.0% | 586.18 ± 1.4% | 678.35 ± 10.2% | 1162.77 ± 3.0% | 23089.31 ± 3.9% | 1014.12 ± 1.2% | 0.96 | 1.01 | 1.74 | 1.50 |
| class: two capitalized words | 23 | 762.40 ± 0.9% | 783.20 ± 0.8% | 1081.28 ± 1.6% | 134.34 ± 1.0% | 631.62 ± 0.7% | 1115.57 ± 1.4% | 7004.12 ± 2.5% | 760.67 ± 0.9% | 0.97 | 1.00 | 5.68 | 1.21 |
| class: a word that ends in ing | 9 | 1009.42 ± 2.2% | 1069.70 ± 0.5% | 1716.60 ± 2.2% | 170.39 ± 0.6% | 937.05 ± 13.5% | 1732.02 ± 1.0% | 17593.26 ± 5.3% | 1011.35 ± 1.2% | 0.94 | 1.00 | 5.92 | 1.08 |
| class: a word in capitals | 16 | 893.24 ± 2.5% | 927.69 ± 0.7% | 1370.11 ± 0.2% | 178.92 ± 1.6% | 940.29 ± 0.7% | 1627.64 ± 1.4% | 8787.07 ± 1.1% | 892.99 ± 0.4% | 0.96 | 1.00 | 4.99 | 0.95 |
| class: a number | 6 | 1133.64 ± 1.4% | 1199.20 ± 1.6% | 2016.17 ± 2.8% | 44.50 ± 0.8% | 1713.50 ± 2.8% | 3042.73 ± 2.7% | 25326.31 ± 4.7% | 1130.25 ± 2.6% | 0.95 | 1.00 | 25.48 | 0.66 |
| class: two capitalized words, second text | 23 | 764.63 ± 1.9% | 788.48 ± 1.3% | 1087.93 ± 1.6% | 134.46 ± 1.2% | 636.24 ± 2.1% | 1126.01 ± 1.5% | 7031.37 ± 1.5% | 760.86 ± 1.3% | 0.97 | 1.00 | 5.69 | 1.20 |
| other: a word between two words | 13 | 923.36 ± 0.6% | 940.46 ± 1.0% | 1395.71 ± 0.5% | 177.90 ± 0.7% | 627.51 ± 1.3% | 1195.29 ± 1.6% | 15338.68 ± 1.8% | 921.23 ± 0.4% | 0.98 | 1.00 | 5.19 | 1.47 |
| other: a number before a unit, second text | 15 | 720.70 ± 0.5% | 771.38 ± 0.3% | 1055.36 ± 0.2% | 41.50 ± 0.7% | 789.40 ± 11.5% | 1368.67 ± 2.0% | 15643.15 ± 1.5% | 719.23 ± 1.1% | 0.93 | 1.00 | 17.37 | 0.91 |
| other: a heading's start tag | 13 | 589.58 ± 0.5% | 599.22 ± 0.8% | 763.64 ± 0.9% | 47.52 ± 2.4% | 773.32 ± 10.6% | 1326.76 ± 1.4% | 18737.25 ± 2.8% | 588.72 ± 1.5% | 0.98 | 1.00 | 12.41 | 0.76 |
| other: a whole word | 11 | 1006.38 ± 1.3% | 1040.29 ± 3.6% | 1593.45 ± 0.8% | 164.54 ± 0.5% | 728.69 ± 12.4% | 1241.99 ± 1.3% | 26277.20 ± 2.8% | 1005.38 ± 1.1% | 0.97 | 1.00 | 6.12 | 1.38 |
| other: a line's first word, second text | 17 | 878.26 ± 0.8% | 920.72 ± 3.4% | 1371.24 ± 1.8% | 172.74 ± 0.4% | 873.55 ± 11.4% | refused | refused | 875.87 ± 0.9% | 0.95 | 1.00 | 5.08 | 1.01 |
| other: fourteen octets before an x | 16 | 144.31 ± 1.4% | 198.20 ± 0.8% | 227.99 ± 1.3% | 18.65 ± 0.9% | 554.52 ± 1.2% | 596.18 ± 1.1% | 14584.55 ± 3.6% | 144.01 ± 0.7% | 0.73 | 1.00 | 7.74 | 0.26 |
| other: a Greek word | 8 | 1018.00 ± 0.8% | 1082.90 ± 0.2% | 1730.03 ± 2.4% | 61.10 ± 0.5% | 1724.62 ± 2.7% | 2863.80 ± 1.4% | refused | 1016.31 ± 0.7% | 0.94 | 1.00 | 16.66 | 0.59 |

