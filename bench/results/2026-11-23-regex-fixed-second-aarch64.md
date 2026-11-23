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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159246121 |
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
| literal: a word | 217 | 16096.86 ± 0.8% | 1049.42 ± 0.2% | 28.35 ± 0.5% | 18370.41 ± 1.7% | 9409.88 ± 7.5% | 17.52 ± 0.4% | 86.85 ± 0.1% | 16132.47 ± 0.7% | 15.34 | 1.00 | 0.88 | 1.71 |
| literal: a word that is not there | 0 | 18794.79 ± 0.6% | 1056.34 ± 0.2% | 28.40 ± 0.1% | 19996.98 ± 1.1% | 29499.39 ± 0.4% | 17.25 ± 0.5% | 82.67 ± 0.2% | 18870.01 ± 0.6% | 17.79 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6085.70 ± 0.5% | 1031.33 ± 0.4% | 14.64 ± 0.6% | 3945.21 ± 0.6% | 21.84 ± 0.2% | 5.29 ± 0.0% | 6.92 ± 0.4% | 6066.72 ± 0.3% | 5.90 | 1.00 | 1.54 | 278.61 |
| literal: a word in any case | 217 | 12628.62 ± 0.3% | 1048.39 ± 0.9% | 21.72 ± 0.8% | 3969.15 ± 0.2% | 38.07 ± 4.4% | refused | differs | 12618.36 ± 0.3% | 12.05 | 1.00 | 3.18 | 331.73 |
| literal: an href attribute | 33 | 13588.30 ± 0.4% | 1055.67 ± 0.2% | 27.15 ± 0.2% | 17001.39 ± 2.0% | 2253.22 ± 0.6% | 13.32 ± 0.3% | 75.58 ± 0.4% | 13577.91 ± 0.4% | 12.87 | 1.00 | 0.80 | 6.03 |
| literal: a word, second text | 123 | 16353.78 ± 0.6% | 1051.39 ± 0.6% | 28.12 ± 0.1% | 18382.26 ± 1.1% | 7771.64 ± 7.4% | 19.73 ± 0.5% | 69.58 ± 0.6% | 16392.12 ± 0.3% | 15.55 | 1.00 | 0.89 | 2.10 |
| class: two capitalized words | 1331 | 1124.48 ± 0.3% | 980.26 ± 0.2% | 26.06 ± 0.4% | 585.16 ± 0.1% | 40.53 ± 1.7% | 14.79 ± 0.2% | 68.89 ± 0.3% | 1120.90 ± 0.2% | 1.15 | 1.00 | 1.92 | 27.74 |
| class: a word that ends in ing | 3399 | 901.61 ± 0.1% | 902.44 ± 0.1% | 18.05 ± 0.2% | 547.02 ± 0.2% | 29.54 ± 2.5% | 8.22 ± 0.1% | 18.36 ± 1.0% | 900.50 ± 0.1% | 1.00 | 1.00 | 1.65 | 30.52 |
| class: a word in capitals | 2332 | 1464.85 ± 0.9% | 957.28 ± 0.1% | 27.72 ± 0.2% | 572.48 ± 0.0% | 43.47 ± 13.9% | 17.16 ± 0.4% | 83.31 ± 0.4% | 1459.51 ± 0.8% | 1.53 | 1.00 | 2.56 | 33.70 |
| class: a number | 8288 | 2009.16 ± 0.2% | 840.52 ± 0.2% | 27.81 ± 0.3% | 1718.28 ± 0.2% | 42.18 ± 16.0% | 0.56 ± 0.2% | 56.68 ± 0.3% | 2007.77 ± 0.1% | 2.39 | 1.00 | 1.17 | 47.63 |
| class: two capitalized words, second text | 5359 | 744.23 ± 0.1% | 744.67 ± 0.0% | 23.30 ± 0.5% | 484.76 ± 0.3% | 35.36 ± 14.3% | 16.72 ± 0.2% | 64.08 ± 0.2% | 743.58 ± 0.1% | 1.00 | 1.00 | 1.54 | 21.05 |
| other: a word between two words | 6104 | 754.55 ± 0.2% | 781.09 ± 0.2% | 23.46 ± 0.3% | 736.33 ± 0.5% | 110.02 ± 7.3% | 11.30 ± 0.1% | 69.90 ± 0.2% | 752.61 ± 0.2% | 0.97 | 1.00 | 1.02 | 6.86 |
| other: a number before a unit, second text | 1481 | 5377.60 ± 0.4% | 990.87 ± 0.2% | 25.92 ± 0.2% | 5665.84 ± 0.6% | 40.66 ± 0.2% | 17.84 ± 0.2% | 67.02 ± 0.8% | 5377.96 ± 0.2% | 5.43 | 1.00 | 0.95 | 132.27 |
| other: a heading's start tag | 110 | 12634.74 ± 0.7% | 1045.46 ± 0.0% | 27.36 ± 0.2% | 1710.86 ± 0.1% | 1587.85 ± 2.7% | 16.28 ± 0.2% | 89.07 ± 0.7% | 12633.35 ± 1.1% | 12.09 | 1.00 | 7.39 | 7.96 |
| other: a whole word | 217 | 14067.09 ± 0.5% | 1046.85 ± 0.1% | 29.38 ± 0.3% | 14504.38 ± 0.7% | 49.08 ± 0.2% | 13.64 ± 0.1% | 55.89 ± 0.2% | 14075.49 ± 0.7% | 13.44 | 1.00 | 0.97 | 286.63 |
| other: a line's first word, second text | 3716 | 1971.22 ± 0.8% | 879.17 ± 0.2% | 30.87 ± 0.3% | 1728.82 ± 0.3% | 62.14 ± 6.6% | refused | refused | 1955.96 ± 0.8% | 2.24 | 1.01 | 1.14 | 31.72 |
| other: fourteen octets before an x | 87 | 20084.60 ± 1.3% | 252.26 ± 0.5% | 6.63 ± 0.1% | 4018.61 ± 0.3% | 10.66 ± 0.1% | differs | 17.75 ± 0.1% | 20085.29 ± 0.7% | 79.62 | 1.00 | 5.00 | 1883.42 |
| other: a Greek word | 21815 | 513.41 ± 0.8% | 413.46 ± 0.4% | 31.06 ± 1.4% | 288.70 ± 0.2% | 49.05 ± 11.0% | differs | refused | 512.93 ± 0.5% | 1.24 | 1.00 | 1.78 | 10.47 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.87 ± 0.2% | 25.70 ± 0.1% | 0.87 ± 0.2% | 19.58 ± 0.4% | 2.79 ± 0.5% | differs | 4.02 ± 0.2% | 25.89 ± 0.2% | 1.01 | 1.00 | 1.32 | 9.28 |
| a UUID | 32895 | 21.09 ± 0.5% | 21.18 ± 0.5% | 0.65 ± 0.1% | 15.11 ± 0.2% | 3.09 ± 0.6% | 0.72 ± 0.5% | 3.59 ± 0.9% | 21.19 ± 0.1% | 1.00 | 0.99 | 1.40 | 6.83 |
| an IPv4 address | 33176 | 36.94 ± 0.4% | 36.87 ± 0.4% | 2.12 ± 0.3% | 29.20 ± 0.4% | 6.65 ± 0.2% | differs | 4.14 ± 0.2% | 36.96 ± 0.2% | 1.00 | 1.00 | 1.27 | 5.55 |
| a date and time | 32954 | 31.04 ± 0.4% | 31.06 ± 0.4% | 1.48 ± 0.3% | 21.25 ± 0.3% | 7.03 ± 0.2% | 1.20 ± 0.1% | 7.11 ± 0.8% | 31.03 ± 0.6% | 1.00 | 1.00 | 1.46 | 4.42 |
| a field path | 32606 | 29.52 ± 0.1% | 29.44 ± 0.2% | 1.04 ± 0.4% | 23.19 ± 0.2% | 3.48 ± 1.2% | differs | 2.95 ± 0.5% | 28.69 ± 0.2% | 1.00 | 1.03 | 1.27 | 8.48 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.51 ± 0.4% | 11.53 ± 0.3% | 11.49 ± 0.4% | 11.36 ± 0.3% | 4.94 ± 2.3% | 0.91 ± 0.5% | none | 11.53 ± 0.4% | 1.00 | 1.00 | 1.01 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 216.81 ± 0.6% | 217.09 ± 0.6% | 252.03 ± 0.4% | 86.97 ± 0.3% | 223.79 ± 1.0% | 472.73 ± 0.7% | 3882.35 ± 1.6% | 216.83 ± 0.1% | 1.00 | 1.00 | 2.49 | 0.97 |
| a UUID | 62 | 142.35 ± 0.1% | 142.58 ± 0.1% | 157.35 ± 0.2% | 46.18 ± 0.6% | 99.51 ± 1.2% | 192.29 ± 2.7% | 4441.33 ± 1.8% | 142.23 ± 0.3% | 1.00 | 1.00 | 3.08 | 1.43 |
| an IPv4 address | 29 | 437.63 ± 0.4% | 440.77 ± 0.4% | 611.33 ± 0.6% | 77.40 ± 0.4% | 131.13 ± 30.0% | 304.60 ± 1.4% | 7692.54 ± 0.3% | 436.59 ± 0.5% | 0.99 | 1.00 | 5.65 | 3.34 |
| a date and time | 56 | 319.50 ± 0.7% | 320.90 ± 0.3% | 403.37 ± 0.4% | 72.47 ± 0.5% | 136.96 ± 2.9% | 334.97 ± 0.3% | 4936.03 ± 0.3% | 319.94 ± 0.9% | 1.00 | 1.00 | 4.41 | 2.33 |
| a field path | 39 | 202.61 ± 0.1% | 203.22 ± 0.2% | 233.14 ± 0.1% | 79.60 ± 1.5% | 203.58 ± 1.8% | 500.45 ± 3.8% | 4983.31 ± 4.5% | 202.69 ± 0.3% | 1.00 | 1.00 | 2.55 | 1.00 |
| literal: a word | 7 | 660.88 ± 0.3% | 712.16 ± 0.4% | 1265.00 ± 0.1% | 486.79 ± 2.0% | 626.62 ± 1.9% | 952.23 ± 0.5% | 31234.46 ± 0.2% | 660.62 ± 0.2% | 0.93 | 1.00 | 1.36 | 1.05 |
| literal: a word that is not there | 8 | 631.52 ± 0.2% | 684.22 ± 0.4% | 1188.24 ± 0.3% | 448.26 ± 1.8% | 595.78 ± 3.0% | 898.87 ± 0.5% | 29452.79 ± 0.2% | 632.56 ± 0.1% | 0.92 | 1.00 | 1.41 | 1.06 |
| literal: one of four words | 26 | 253.71 ± 0.1% | 417.69 ± 0.3% | 564.79 ± 0.2% | 50.44 ± 0.8% | 241.57 ± 2.7% | 370.35 ± 0.5% | 15851.98 ± 0.1% | 253.96 ± 0.4% | 0.61 | 1.00 | 5.03 | 1.05 |
| literal: a word in any case | 11 | 516.66 ± 0.2% | 556.93 ± 0.7% | 859.56 ± 0.2% | 15.72 ± 0.2% | 651.06 ± 2.6% | refused | 23675.30 ± 0.3% | 517.23 ± 0.2% | 0.93 | 1.00 | 32.88 | 0.79 |
| literal: an href attribute | 12 | 346.37 ± 0.4% | 358.21 ± 0.3% | 464.91 ± 0.6% | 45.61 ± 1.2% | 495.41 ± 7.4% | 776.27 ± 0.4% | 22179.82 ± 0.2% | 346.78 ± 0.5% | 0.97 | 1.00 | 7.59 | 0.70 |
| literal: a word, second text | 10 | 587.04 ± 0.2% | 647.28 ± 0.6% | 1078.79 ± 0.1% | 404.65 ± 1.2% | 534.36 ± 0.6% | 803.67 ± 0.4% | 27416.43 ± 0.2% | 587.54 ± 0.2% | 0.91 | 1.00 | 1.45 | 1.10 |
| class: two capitalized words | 23 | 457.71 ± 0.5% | 486.96 ± 0.5% | 705.42 ± 0.1% | 102.74 ± 0.2% | 502.42 ± 1.8% | 746.93 ± 0.4% | 6624.61 ± 0.5% | 458.06 ± 0.1% | 0.94 | 1.00 | 4.46 | 0.91 |
| class: a word that ends in ing | 9 | 591.69 ± 0.2% | 658.61 ± 0.9% | 1160.04 ± 0.2% | 132.14 ± 0.2% | 756.25 ± 2.0% | 1110.16 ± 0.7% | 16310.54 ± 1.1% | 591.78 ± 0.2% | 0.90 | 1.00 | 4.48 | 0.78 |
| class: a word in capitals | 16 | 519.97 ± 0.5% | 556.76 ± 0.5% | 885.67 ± 0.3% | 135.34 ± 0.4% | 747.50 ± 1.9% | 1048.70 ± 1.4% | 8693.93 ± 0.2% | 519.26 ± 0.2% | 0.93 | 1.00 | 3.84 | 0.70 |
| class: a number | 6 | 651.24 ± 0.6% | 713.09 ± 0.2% | 1326.22 ± 0.2% | 41.90 ± 0.8% | 1390.04 ± 7.5% | 1837.23 ± 2.2% | 23056.09 ± 0.1% | 650.88 ± 0.3% | 0.91 | 1.00 | 15.54 | 0.47 |
| class: two capitalized words, second text | 23 | 457.74 ± 0.9% | 487.19 ± 0.3% | 704.92 ± 0.4% | 99.79 ± 0.3% | 502.54 ± 2.7% | 747.39 ± 3.1% | 6626.13 ± 0.2% | 457.45 ± 0.4% | 0.94 | 1.00 | 4.59 | 0.91 |
| other: a word between two words | 13 | 575.38 ± 0.2% | 594.00 ± 0.3% | 942.99 ± 0.4% | 132.41 ± 1.2% | 504.22 ± 1.9% | 805.29 ± 0.7% | 15099.60 ± 0.2% | 575.36 ± 0.4% | 0.97 | 1.00 | 4.35 | 1.14 |
| other: a number before a unit, second text | 15 | 399.46 ± 0.1% | 433.94 ± 0.4% | 596.54 ± 0.3% | 39.53 ± 0.5% | 635.87 ± 1.5% | 891.21 ± 0.4% | 15372.36 ± 0.2% | 399.75 ± 0.1% | 0.92 | 1.00 | 10.10 | 0.63 |
| other: a heading's start tag | 13 | 358.59 ± 0.3% | 363.05 ± 0.4% | 474.50 ± 0.4% | 44.04 ± 0.2% | 627.24 ± 2.3% | 877.81 ± 0.1% | 18474.56 ± 0.3% | 358.50 ± 0.2% | 0.99 | 1.00 | 8.14 | 0.57 |
| other: a whole word | 11 | 610.10 ± 0.2% | 647.74 ± 0.4% | 1081.99 ± 0.2% | 119.75 ± 0.7% | 563.37 ± 0.6% | 821.00 ± 1.5% | 27161.69 ± 0.2% | 610.46 ± 0.3% | 0.94 | 1.00 | 5.09 | 1.08 |
| other: a line's first word, second text | 17 | 552.19 ± 0.4% | 573.89 ± 0.4% | 920.35 ± 0.1% | 129.52 ± 0.4% | 712.12 ± 0.8% | refused | refused | 552.05 ± 0.7% | 0.96 | 1.00 | 4.26 | 0.78 |
| other: fourteen octets before an x | 16 | 112.26 ± 0.5% | 162.70 ± 0.6% | 185.69 ± 0.7% | 15.01 ± 0.4% | 453.95 ± 1.1% | 414.33 ± 0.6% | 12872.89 ± 0.3% | 112.33 ± 0.3% | 0.69 | 1.00 | 7.48 | 0.25 |
| other: a Greek word | 8 | 446.33 ± 0.3% | 585.60 ± 0.4% | 954.26 ± 0.1% | 59.05 ± 0.4% | 1398.90 ± 1.1% | 1820.43 ± 0.4% | refused | 446.67 ± 0.2% | 0.76 | 1.00 | 7.56 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12962.22 ± 0.6% | not timed | not timed | 16491.38 ± 1.4% | 2100.31 ± 22.2% | not timed | not timed | 12973.67 ± 0.8% | | 1.00 | 0.79 | 6.17 |
| 01-literal/sherlock-casei-en | 522 | 4491.75 ± 1.1% | not timed | not timed | 3591.93 ± 0.2% | 32.44 ± 0.5% | not timed | not timed | 4475.88 ± 0.2% | | 1.00 | 1.25 | 138.45 |
| 01-literal/sherlock-ru | 724 | 13546.50 ± 0.5% | not timed | not timed | 17364.97 ± 0.3% | 1386.01 ± 14.4% | not timed | not timed | 13529.65 ± 0.5% | | 1.00 | 0.78 | 9.77 |
| 01-literal/sherlock-casei-ru | 746 | 5293.16 ± 0.4% | not timed | not timed | 3326.98 ± 0.2% | 31.78 ± 0.4% | not timed | not timed | 5300.07 ± 0.5% | | 1.00 | 1.59 | 166.57 |
| 01-literal/sherlock-zh | 30 | 17196.85 ± 0.4% | not timed | not timed | 18838.53 ± 0.4% | 2711.30 ± 15.8% | not timed | not timed | 17198.42 ± 0.2% | | 1.00 | 0.91 | 6.34 |
| 02-literal-alternate/sherlock-en | 714 | 5778.54 ± 0.3% | not timed | not timed | 3937.11 ± 0.2% | 16.61 ± 6.9% | not timed | not timed | 5769.78 ± 0.5% | | 1.00 | 1.47 | 347.84 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1711.80 ± 0.9% | not timed | not timed | 696.83 ± 0.2% | 10.95 ± 0.1% | not timed | not timed | 1703.05 ± 0.3% | | 1.01 | 2.46 | 156.32 |
| 02-literal-alternate/sherlock-ru | 899 | 4660.29 ± 0.2% | not timed | not timed | 3256.30 ± 0.1% | 22.16 ± 0.4% | not timed | not timed | 4658.82 ± 0.3% | | 1.00 | 1.43 | 210.29 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1805.01 ± 0.3% | not timed | not timed | 1230.38 ± 0.1% | 9.14 ± 0.1% | not timed | not timed | 1800.48 ± 0.1% | | 1.00 | 1.47 | 197.38 |
| 02-literal-alternate/sherlock-zh | 207 | 7073.54 ± 0.3% | not timed | not timed | 4164.98 ± 0.2% | 31.45 ± 0.3% | not timed | not timed | 7063.60 ± 0.3% | | 1.00 | 1.70 | 224.95 |
| 03-date/ascii | 111817 | 126.75 ± 0.6% | not timed | not timed | 95.87 ± 0.1% | 0.20 ± 2.8% | not timed | not timed | 126.07 ± 0.4% | | 1.01 | 1.32 | 635.42 |
| 04-ruff-noqa/real | 84 | 555.32 ± 0.1% | not timed | not timed | 462.62 ± 0.1% | 19.69 ± 1.3% | not timed | not timed | 553.73 ± 0.1% | | 1.00 | 1.20 | 28.21 |
| 04-ruff-noqa/tweaked | 44 | 544.05 ± 0.1% | not timed | not timed | 451.41 ± 0.1% | 366.45 ± 0.5% | not timed | not timed | 541.66 ± 0.3% | | 1.00 | 1.21 | 1.48 |
| 05-lexer-veryl/single | 124800 | 3.98 ± 0.4% | not timed | not timed | 5.01 ± 0.4% | 0.21 ± 2.7% | not timed | not timed | 4.10 ± 2.2% | | 0.97 | 0.80 | 19.30 |
| 06-cloud-flare-redos/original | 107 | 260.28 ± 0.3% | not timed | not timed | 217.75 ± 0.0% | 24.96 ± 0.4% | not timed | not timed | 260.20 ± 0.2% | | 1.00 | 1.20 | 10.43 |
| 06-cloud-flare-redos/simplified-short | 102 | 254.91 ± 1.7% | not timed | not timed | 227.96 ± 0.1% | 26.72 ± 0.1% | not timed | not timed | 254.41 ± 0.1% | | 1.00 | 1.12 | 9.54 |
| 06-cloud-flare-redos/simplified-long | 10000 | 291.99 ± 0.2% | not timed | not timed | 253.43 ± 0.1% | 28.78 ± 0.1% | not timed | not timed | 292.07 ± 0.1% | | 1.00 | 1.15 | 10.14 |
| 07-unicode-character-data/parse-line | 558784 | 238.22 ± 0.4% | not timed | not timed | 171.69 ± 0.1% | 42.51 ± 5.4% | not timed | not timed | 239.80 ± 2.6% | | 0.99 | 1.39 | 5.60 |
| 08-words/all-english | 56691 | 122.06 ± 0.7% | not timed | not timed | 82.75 ± 0.4% | 12.98 ± 4.5% | not timed | not timed | 121.12 ± 0.4% | | 1.01 | 1.47 | 9.40 |
| 08-words/long-english | 839 | 1012.80 ± 0.1% | not timed | not timed | 596.32 ± 0.2% | 32.45 ± 0.2% | not timed | not timed | 1011.13 ± 0.4% | | 1.00 | 1.70 | 31.21 |
| 09-aws-keys/full | 0 | 408.61 ± 0.1% | not timed | not timed | 463.49 ± 0.0% | 64.26 ± 0.1% | not timed | not timed | 407.53 ± 0.1% | | 1.00 | 0.88 | 6.36 |
| 09-aws-keys/quick | 0 | 738.73 ± 0.1% | not timed | not timed | 980.57 ± 0.2% | 418.35 ± 0.7% | not timed | not timed | 735.21 ± 0.1% | | 1.00 | 0.75 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 636.61 ± 0.4% | not timed | not timed | 516.79 ± 0.9% | 19.58 ± 0.8% | not timed | not timed | 636.51 ± 0.3% | | 1.00 | 1.23 | 32.51 |
| 10-bounded-repeat/letters-ru | 3475 | 383.20 ± 0.4% | not timed | not timed | 477.16 ± 0.2% | 21.83 ± 10.3% | not timed | not timed | 380.83 ± 0.5% | | 1.01 | 0.80 | 17.55 |
| 10-bounded-repeat/context | 53 | 79.94 ± 0.8% | not timed | not timed | 66.00 ± 0.3% | 19.74 ± 0.2% | not timed | not timed | 80.00 ± 1.0% | | 1.00 | 1.21 | 4.05 |
| 10-bounded-repeat/capitals | 11 | 1055.46 ± 0.2% | not timed | not timed | 616.74 ± 0.0% | 36.58 ± 0.0% | not timed | not timed | 1055.36 ± 0.1% | | 1.00 | 1.71 | 28.85 |
| 11-unstructured-to-json/extract | 600 | 49.91 ± 0.3% | not timed | not timed | 76.01 ± 0.6% | 49.01 ± 0.7% | not timed | not timed | 49.70 ± 1.0% | | 1.00 | 0.66 | 1.02 |
| 12-dictionary/single | 1 | 566.89 ± 0.2% | not timed | not timed | 559.41 ± 0.0% | 0.40 ± 0.1% | not timed | not timed | 567.32 ± 0.2% | | 1.00 | 1.01 | 1414.73 |
| 14-quadratic/1x | 100 | 12.79 ± 0.3% | not timed | not timed | 10.05 ± 0.2% | 0.95 ± 2.6% | not timed | not timed | 12.78 ± 1.4% | | 1.00 | 1.27 | 13.41 |
| 14-quadratic/2x | 200 | 7.96 ± 0.4% | not timed | not timed | 5.55 ± 0.2% | 0.53 ± 1.0% | not timed | not timed | 7.90 ± 1.7% | | 1.01 | 1.43 | 15.07 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.1% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 1.88 ± 0.4% | | 1.00 | 1.55 | 16.26 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.55 ± 0.2% | not timed | not timed | 0.35 ± 0.3% | 0.55 ± 4.0% | not timed | not timed | 1.54 ± 1.6% | | 1.01 | 4.48 | 2.80 |
| 04-ruff-noqa/compile-real | 1 | 85.41 ± 0.1% | not timed | not timed | 13.65 ± 0.3% | 139.42 ± 2.4% | not timed | not timed | 84.71 ± 3.7% | | 1.01 | 6.26 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 14.50 ± 0.2% | not timed | not timed | 2.53 ± 0.4% | 6.48 ± 2.8% | not timed | not timed | 14.37 ± 1.9% | | 1.01 | 5.74 | 2.24 |
| 07-unicode-character-data/compile | 1 | 54.88 ± 0.2% | not timed | not timed | 25.49 ± 0.1% | 35.75 ± 4.3% | not timed | not timed | 54.82 ± 1.6% | | 1.00 | 2.15 | 1.53 |
| 09-aws-keys/compile-full | 1 | 42.21 ± 0.1% | not timed | not timed | 8.20 ± 0.2% | 23.34 ± 3.2% | not timed | not timed | 42.08 ± 0.6% | | 1.00 | 5.15 | 1.81 |
| 09-aws-keys/compile-quick | 1 | 188.63 ± 0.2% | not timed | not timed | 46.56 ± 0.1% | 133.49 ± 3.2% | not timed | not timed | 188.32 ± 1.4% | | 1.00 | 4.05 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 14.60 ± 1.3% | not timed | not timed | 11.18 ± 0.3% | 16.21 ± 3.2% | not timed | not timed | 14.52 ± 1.1% | | 1.01 | 1.31 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 85.14 ± 0.2% | not timed | not timed | 8.10 ± 0.2% | 24.02 ± 2.0% | not timed | not timed | 84.70 ± 1.5% | | 1.01 | 10.51 | 3.54 |
| 11-unstructured-to-json/compile | 1 | 86.39 ± 0.1% | not timed | not timed | 40.41 ± 0.4% | 67.98 ± 1.5% | not timed | not timed | 85.67 ± 0.8% | | 1.01 | 2.14 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.3% | not timed | not timed | 0.07 ± 1.2% | 0.09 ± 13.8% | not timed | not timed | 0.36 ± 1.7% | | 1.01 | 5.24 | 4.01 |

