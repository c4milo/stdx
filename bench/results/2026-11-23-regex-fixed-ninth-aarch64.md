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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159288212 |
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
| literal: a word | 217 | 16132.80 ± 1.2% | 1049.88 ± 0.3% | 28.67 ± 1.6% | 18292.93 ± 1.9% | 9146.37 ± 7.5% | 17.16 ± 0.6% | 86.54 ± 0.1% | 16094.28 ± 1.3% | 15.37 | 1.00 | 0.88 | 1.76 |
| literal: a word that is not there | 0 | 18753.44 ± 0.9% | 1056.42 ± 0.2% | 28.85 ± 0.2% | 20152.96 ± 1.5% | 29384.33 ± 0.9% | 17.04 ± 0.1% | 82.30 ± 0.1% | 18765.73 ± 0.2% | 17.75 | 1.00 | 0.93 | 0.64 |
| literal: one of four words | 661 | 6078.06 ± 0.3% | 1031.96 ± 0.1% | 14.71 ± 0.2% | 3947.87 ± 0.2% | 21.90 ± 0.1% | 5.36 ± 0.1% | 6.91 ± 0.4% | 6060.20 ± 0.5% | 5.89 | 1.00 | 1.54 | 277.55 |
| literal: a word in any case | 217 | 12616.07 ± 0.6% | 1049.02 ± 0.1% | 21.86 ± 2.2% | 3974.92 ± 0.3% | 38.03 ± 0.6% | refused | differs | 12598.10 ± 0.5% | 12.03 | 1.00 | 3.17 | 331.72 |
| literal: an href attribute | 33 | 13592.86 ± 0.7% | 1055.40 ± 0.2% | 27.34 ± 0.3% | 16997.18 ± 1.2% | 2253.72 ± 0.5% | 13.02 ± 0.2% | 75.31 ± 0.3% | 13600.98 ± 0.7% | 12.88 | 1.00 | 0.80 | 6.03 |
| literal: a word, second text | 123 | 16495.97 ± 0.8% | 1051.39 ± 0.1% | 28.18 ± 0.4% | 18666.59 ± 1.1% | 7644.53 ± 6.3% | 20.15 ± 0.4% | 70.17 ± 0.4% | 16493.61 ± 0.5% | 15.69 | 1.00 | 0.88 | 2.16 |
| class: two capitalized words | 1331 | 1124.12 ± 0.6% | 980.05 ± 0.2% | 26.11 ± 0.3% | 585.40 ± 0.1% | 40.56 ± 12.3% | 14.69 ± 0.2% | 68.91 ± 0.2% | 1122.90 ± 0.5% | 1.15 | 1.00 | 1.92 | 27.72 |
| class: a word that ends in ing | 3399 | 902.11 ± 0.1% | 901.66 ± 0.1% | 18.21 ± 0.2% | 547.91 ± 0.1% | 29.57 ± 3.5% | 8.15 ± 0.2% | 18.33 ± 0.9% | 900.61 ± 0.2% | 1.00 | 1.00 | 1.65 | 30.50 |
| class: a word in capitals | 2332 | 1459.67 ± 0.5% | 956.70 ± 0.2% | 27.70 ± 0.4% | 572.63 ± 0.1% | 43.49 ± 6.5% | 17.11 ± 0.2% | 83.05 ± 0.4% | 1462.31 ± 0.4% | 1.53 | 1.00 | 2.55 | 33.56 |
| class: a number | 8288 | 2002.49 ± 0.2% | 839.26 ± 0.1% | 27.88 ± 0.6% | 1716.24 ± 0.7% | 40.34 ± 16.1% | 0.52 ± 0.6% | 56.58 ± 0.9% | 2001.10 ± 0.2% | 2.39 | 1.00 | 1.17 | 49.64 |
| class: two capitalized words, second text | 5359 | 744.24 ± 0.1% | 745.99 ± 0.2% | 23.39 ± 0.1% | 485.51 ± 0.1% | 34.10 ± 10.5% | 17.12 ± 0.3% | 64.00 ± 0.2% | 744.49 ± 0.1% | 1.00 | 1.00 | 1.53 | 21.82 |
| other: a word between two words | 6104 | 752.65 ± 0.3% | 781.15 ± 0.1% | 23.55 ± 0.2% | 738.45 ± 0.1% | 108.22 ± 13.9% | 11.15 ± 0.1% | 69.53 ± 0.7% | 750.43 ± 0.1% | 0.96 | 1.00 | 1.02 | 6.95 |
| other: a number before a unit, second text | 1481 | 5404.85 ± 0.5% | 991.72 ± 0.1% | 26.09 ± 0.1% | 5684.29 ± 0.5% | 40.76 ± 11.4% | 18.15 ± 2.2% | 66.84 ± 1.3% | 5386.29 ± 0.6% | 5.45 | 1.00 | 0.95 | 132.59 |
| other: a heading's start tag | 110 | 12620.20 ± 0.5% | 1044.72 ± 0.5% | 27.60 ± 0.2% | 1715.40 ± 0.5% | 1576.52 ± 6.1% | 15.77 ± 0.4% | 88.85 ± 0.3% | 12590.00 ± 0.3% | 12.08 | 1.00 | 7.36 | 8.01 |
| other: a whole word | 217 | 14112.49 ± 1.1% | 1046.74 ± 0.2% | 29.64 ± 0.4% | 14593.63 ± 3.0% | 49.37 ± 0.6% | 13.07 ± 0.2% | 55.65 ± 0.4% | 14054.45 ± 1.2% | 13.48 | 1.00 | 0.97 | 285.83 |
| other: a line's first word, second text | 3716 | 1966.89 ± 0.7% | 878.82 ± 0.1% | 31.17 ± 0.1% | 1724.66 ± 0.7% | 61.52 ± 6.8% | refused | refused | 1956.49 ± 0.8% | 2.24 | 1.01 | 1.14 | 31.97 |
| other: fourteen octets before an x | 87 | 20133.47 ± 1.1% | 231.82 ± 0.8% | 6.65 ± 0.1% | 4058.04 ± 0.6% | 10.66 ± 0.1% | differs | 17.77 ± 0.3% | 20102.96 ± 0.1% | 86.85 | 1.00 | 4.96 | 1889.53 |
| other: a Greek word | 21815 | 513.43 ± 0.2% | 411.75 ± 0.4% | 31.31 ± 0.3% | 289.20 ± 0.4% | 44.40 ± 9.2% | differs | refused | 509.15 ± 0.4% | 1.25 | 1.01 | 1.78 | 11.56 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.87 ± 0.2% | 25.88 ± 0.3% | 0.87 ± 0.2% | 19.80 ± 0.4% | 2.78 ± 1.0% | differs | 4.03 ± 0.4% | 25.88 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.30 |
| a UUID | 32895 | 21.04 ± 0.4% | 21.13 ± 0.3% | 0.65 ± 0.2% | 15.05 ± 0.4% | 3.08 ± 0.2% | 0.73 ± 0.3% | 3.60 ± 0.4% | 21.20 ± 0.2% | 1.00 | 0.99 | 1.40 | 6.83 |
| an IPv4 address | 33176 | 36.85 ± 0.4% | 36.81 ± 0.2% | 2.11 ± 0.2% | 29.37 ± 0.4% | 6.66 ± 0.1% | differs | 4.16 ± 0.2% | 36.90 ± 0.2% | 1.00 | 1.00 | 1.25 | 5.53 |
| a date and time | 32954 | 31.05 ± 0.5% | 31.06 ± 0.5% | 1.48 ± 0.6% | 21.53 ± 0.6% | 7.02 ± 0.2% | 1.25 ± 0.1% | 7.15 ± 0.4% | 31.01 ± 0.4% | 1.00 | 1.00 | 1.44 | 4.42 |
| a field path | 32606 | 29.49 ± 0.1% | 29.45 ± 0.2% | 1.04 ± 0.1% | 23.18 ± 0.5% | 3.49 ± 0.8% | differs | 2.97 ± 0.3% | 29.46 ± 0.2% | 1.00 | 1.00 | 1.27 | 8.44 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.20 ± 0.5% | 11.23 ± 0.4% | 11.21 ± 0.5% | 11.56 ± 0.0% | 4.93 ± 1.6% | 0.93 ± 0.3% | none | 11.21 ± 0.8% | 1.00 | 1.00 | 0.97 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.26 ± 0.3% | 235.90 ± 0.2% | 287.19 ± 0.2% | 86.16 ± 0.4% | 215.97 ± 2.7% | 474.19 ± 1.3% | 3877.03 ± 1.3% | 234.29 ± 0.2% | 0.99 | 1.00 | 2.72 | 1.08 |
| a UUID | 62 | 157.45 ± 0.4% | 157.76 ± 0.2% | 179.29 ± 0.3% | 46.61 ± 0.7% | 97.76 ± 2.3% | 187.43 ± 2.9% | 4368.78 ± 2.3% | 157.40 ± 0.2% | 1.00 | 1.00 | 3.38 | 1.61 |
| an IPv4 address | 29 | 418.74 ± 0.3% | 424.02 ± 0.6% | 613.53 ± 0.6% | 77.46 ± 0.5% | 130.29 ± 6.4% | 299.05 ± 2.2% | 7638.75 ± 0.1% | 418.55 ± 0.4% | 0.99 | 1.00 | 5.41 | 3.21 |
| a date and time | 56 | 307.40 ± 0.2% | 310.13 ± 0.1% | 400.22 ± 0.2% | 73.32 ± 0.5% | 133.94 ± 19.1% | 324.75 ± 1.1% | 4908.87 ± 0.4% | 307.19 ± 0.3% | 0.99 | 1.00 | 4.19 | 2.30 |
| a field path | 39 | 226.17 ± 0.6% | 227.67 ± 0.6% | 274.06 ± 0.3% | 81.09 ± 1.2% | 205.86 ± 2.7% | 500.15 ± 2.8% | 4929.02 ± 2.6% | 226.33 ± 0.5% | 0.99 | 1.00 | 2.79 | 1.10 |
| literal: a word | 7 | 620.87 ± 0.3% | 664.45 ± 0.1% | 1247.26 ± 0.1% | 525.06 ± 0.2% | 625.64 ± 5.3% | 948.66 ± 1.0% | 29561.54 ± 0.3% | 619.95 ± 0.6% | 0.93 | 1.00 | 1.18 | 0.99 |
| literal: a word that is not there | 8 | 597.63 ± 0.3% | 645.50 ± 0.3% | 1172.77 ± 0.5% | 481.30 ± 0.4% | 597.45 ± 5.5% | 897.90 ± 0.6% | 28524.82 ± 0.2% | 597.79 ± 0.4% | 0.93 | 1.00 | 1.24 | 1.00 |
| literal: one of four words | 26 | 241.22 ± 0.2% | 400.45 ± 0.5% | 561.91 ± 0.6% | 50.12 ± 1.2% | 238.75 ± 2.6% | 372.08 ± 1.4% | 15420.86 ± 0.3% | 241.27 ± 0.4% | 0.60 | 1.00 | 4.81 | 1.01 |
| literal: a word in any case | 11 | 482.78 ± 0.3% | 516.46 ± 0.6% | 840.88 ± 0.1% | 15.89 ± 1.9% | 649.48 ± 2.2% | refused | 23365.95 ± 0.5% | 482.41 ± 0.6% | 0.93 | 1.00 | 30.39 | 0.74 |
| literal: an href attribute | 12 | 347.98 ± 1.4% | 360.73 ± 0.3% | 491.13 ± 0.3% | 45.95 ± 0.5% | 496.65 ± 3.2% | 770.48 ± 1.0% | 21516.39 ± 0.4% | 348.36 ± 0.2% | 0.96 | 1.00 | 7.57 | 0.70 |
| literal: a word, second text | 10 | 557.97 ± 0.5% | 609.95 ± 0.7% | 1061.26 ± 0.7% | 401.88 ± 0.6% | 528.90 ± 4.9% | 794.73 ± 0.5% | 26472.10 ± 0.3% | 557.41 ± 0.3% | 0.91 | 1.00 | 1.39 | 1.05 |
| class: two capitalized words | 23 | 433.42 ± 0.2% | 465.70 ± 0.5% | 705.03 ± 0.2% | 100.19 ± 0.1% | 505.80 ± 3.5% | 740.44 ± 0.8% | 6577.77 ± 0.1% | 433.17 ± 0.2% | 0.93 | 1.00 | 4.33 | 0.86 |
| class: a word that ends in ing | 9 | 549.36 ± 0.3% | 621.38 ± 1.0% | 1158.56 ± 0.6% | 132.73 ± 1.7% | 760.61 ± 1.9% | 1096.43 ± 0.2% | 16024.40 ± 0.1% | 550.23 ± 0.3% | 0.88 | 1.00 | 4.14 | 0.72 |
| class: a word in capitals | 16 | 485.74 ± 0.3% | 528.56 ± 0.5% | 901.11 ± 0.4% | 136.03 ± 0.7% | 745.49 ± 2.6% | 1026.45 ± 1.5% | 8644.17 ± 0.2% | 485.74 ± 0.9% | 0.92 | 1.00 | 3.57 | 0.65 |
| class: a number | 6 | 603.76 ± 0.6% | 677.06 ± 0.2% | 1359.06 ± 0.1% | 41.97 ± 0.7% | 1394.08 ± 1.6% | 1873.89 ± 1.6% | 22500.87 ± 0.1% | 603.47 ± 0.2% | 0.89 | 1.00 | 14.38 | 0.43 |
| class: two capitalized words, second text | 23 | 432.88 ± 0.3% | 465.27 ± 0.6% | 703.72 ± 0.2% | 101.59 ± 0.5% | 497.74 ± 2.0% | 760.23 ± 0.3% | 6572.77 ± 0.2% | 432.82 ± 0.5% | 0.93 | 1.00 | 4.26 | 0.87 |
| other: a word between two words | 13 | 547.71 ± 0.3% | 565.86 ± 0.2% | 944.52 ± 0.3% | 134.02 ± 0.5% | 497.81 ± 1.7% | 809.43 ± 0.6% | 14798.48 ± 0.1% | 547.69 ± 0.1% | 0.97 | 1.00 | 4.09 | 1.10 |
| other: a number before a unit, second text | 15 | 403.82 ± 0.4% | 445.18 ± 0.5% | 652.78 ± 0.3% | 39.70 ± 0.5% | 621.64 ± 2.4% | 890.05 ± 1.0% | 15074.56 ± 0.2% | 403.52 ± 0.1% | 0.91 | 1.00 | 10.17 | 0.65 |
| other: a heading's start tag | 13 | 358.91 ± 0.4% | 364.44 ± 0.4% | 500.13 ± 0.3% | 43.98 ± 0.2% | 621.23 ± 2.6% | 880.74 ± 0.9% | 17860.46 ± 0.4% | 358.72 ± 0.6% | 0.98 | 1.00 | 8.16 | 0.58 |
| other: a whole word | 11 | 580.81 ± 0.4% | 615.44 ± 0.5% | 1081.92 ± 0.5% | 118.57 ± 0.6% | 558.68 ± 1.8% | 829.65 ± 0.4% | 26576.90 ± 0.3% | 581.12 ± 0.3% | 0.94 | 1.00 | 4.90 | 1.04 |
| other: a line's first word, second text | 17 | 529.55 ± 0.7% | 546.98 ± 0.7% | 933.60 ± 0.5% | 129.87 ± 0.2% | 710.06 ± 1.6% | refused | refused | 528.11 ± 0.3% | 0.97 | 1.00 | 4.08 | 0.75 |
| other: fourteen octets before an x | 16 | 111.65 ± 0.2% | 161.86 ± 0.9% | 190.73 ± 0.3% | 15.12 ± 0.2% | 448.09 ± 8.4% | 404.74 ± 0.4% | 12596.80 ± 0.3% | 111.36 ± 0.4% | 0.69 | 1.00 | 7.38 | 0.25 |
| other: a Greek word | 8 | 420.39 ± 0.3% | 579.52 ± 0.2% | 1037.55 ± 0.2% | 59.16 ± 0.3% | 1396.47 ± 5.7% | 1837.63 ± 0.6% | refused | 420.93 ± 0.2% | 0.73 | 1.00 | 7.11 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12937.55 ± 0.5% | not timed | not timed | 16553.44 ± 1.2% | 2097.95 ± 13.9% | not timed | not timed | 12950.79 ± 0.4% | | 1.00 | 0.78 | 6.17 |
| 01-literal/sherlock-casei-en | 522 | 4478.28 ± 1.0% | not timed | not timed | 3591.50 ± 0.2% | 32.53 ± 0.3% | not timed | not timed | 4466.56 ± 0.2% | | 1.00 | 1.25 | 137.68 |
| 01-literal/sherlock-ru | 724 | 13546.39 ± 0.8% | not timed | not timed | 17355.51 ± 0.4% | 1368.59 ± 18.6% | not timed | not timed | 13500.16 ± 1.2% | | 1.00 | 0.78 | 9.90 |
| 01-literal/sherlock-casei-ru | 746 | 5292.72 ± 0.3% | not timed | not timed | 3330.03 ± 0.2% | 31.78 ± 0.6% | not timed | not timed | 5285.19 ± 0.4% | | 1.00 | 1.59 | 166.54 |
| 01-literal/sherlock-zh | 30 | 17189.15 ± 0.3% | not timed | not timed | 18883.88 ± 0.9% | 2863.83 ± 13.2% | not timed | not timed | 17173.19 ± 0.4% | | 1.00 | 0.91 | 6.00 |
| 02-literal-alternate/sherlock-en | 714 | 5757.39 ± 1.0% | not timed | not timed | 3932.10 ± 0.3% | 16.60 ± 0.2% | not timed | not timed | 5754.74 ± 0.4% | | 1.00 | 1.46 | 346.88 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1712.11 ± 1.1% | not timed | not timed | 696.40 ± 0.1% | 11.01 ± 0.2% | not timed | not timed | 1701.69 ± 0.5% | | 1.01 | 2.46 | 155.57 |
| 02-literal-alternate/sherlock-ru | 899 | 4655.42 ± 0.3% | not timed | not timed | 3256.93 ± 0.1% | 22.63 ± 0.2% | not timed | not timed | 4659.09 ± 0.1% | | 1.00 | 1.43 | 205.74 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1809.54 ± 0.8% | not timed | not timed | 1232.25 ± 0.3% | 9.15 ± 0.2% | not timed | not timed | 1802.91 ± 0.4% | | 1.00 | 1.47 | 197.75 |
| 02-literal-alternate/sherlock-zh | 207 | 7062.97 ± 0.4% | not timed | not timed | 4163.78 ± 0.5% | 31.53 ± 0.2% | not timed | not timed | 7053.63 ± 0.2% | | 1.00 | 1.70 | 223.98 |
| 03-date/ascii | 111817 | 126.44 ± 0.6% | not timed | not timed | 96.41 ± 0.2% | 0.21 ± 5.1% | not timed | not timed | 125.97 ± 1.2% | | 1.00 | 1.31 | 609.33 |
| 04-ruff-noqa/real | 84 | 555.96 ± 0.0% | not timed | not timed | 479.27 ± 0.2% | 19.55 ± 1.0% | not timed | not timed | 555.46 ± 0.2% | | 1.00 | 1.16 | 28.44 |
| 04-ruff-noqa/tweaked | 44 | 542.28 ± 0.2% | not timed | not timed | 460.07 ± 0.3% | 367.62 ± 0.7% | not timed | not timed | 540.62 ± 0.1% | | 1.00 | 1.18 | 1.48 |
| 05-lexer-veryl/single | 124800 | 4.26 ± 0.5% | not timed | not timed | 5.19 ± 0.1% | 0.21 ± 4.0% | not timed | not timed | 4.26 ± 2.5% | | 1.00 | 0.82 | 20.71 |
| 06-cloud-flare-redos/original | 107 | 260.65 ± 0.2% | not timed | not timed | 217.07 ± 0.3% | 24.97 ± 0.3% | not timed | not timed | 260.00 ± 0.2% | | 1.00 | 1.20 | 10.44 |
| 06-cloud-flare-redos/simplified-short | 102 | 254.83 ± 0.1% | not timed | not timed | 227.98 ± 0.1% | 26.66 ± 0.3% | not timed | not timed | 255.08 ± 0.2% | | 1.00 | 1.12 | 9.56 |
| 06-cloud-flare-redos/simplified-long | 10000 | 292.08 ± 0.2% | not timed | not timed | 255.65 ± 0.3% | 28.73 ± 0.1% | not timed | not timed | 292.20 ± 0.1% | | 1.00 | 1.14 | 10.17 |
| 07-unicode-character-data/parse-line | 558784 | 234.89 ± 0.3% | not timed | not timed | 180.34 ± 0.5% | 41.04 ± 14.2% | not timed | not timed | 229.49 ± 2.2% | | 1.02 | 1.30 | 5.72 |
| 08-words/all-english | 56691 | 121.54 ± 0.3% | not timed | not timed | 82.67 ± 0.2% | 12.51 ± 8.9% | not timed | not timed | 120.62 ± 0.6% | | 1.01 | 1.47 | 9.72 |
| 08-words/long-english | 839 | 1013.08 ± 0.1% | not timed | not timed | 597.58 ± 0.1% | 32.55 ± 0.2% | not timed | not timed | 1011.52 ± 0.2% | | 1.00 | 1.70 | 31.12 |
| 09-aws-keys/full | 0 | 408.40 ± 0.1% | not timed | not timed | 494.81 ± 0.3% | 64.41 ± 0.2% | not timed | not timed | 408.56 ± 0.2% | | 1.00 | 0.83 | 6.34 |
| 09-aws-keys/quick | 0 | 740.08 ± 0.1% | not timed | not timed | 1001.87 ± 0.3% | 417.22 ± 0.9% | not timed | not timed | 738.00 ± 0.1% | | 1.00 | 0.74 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 638.39 ± 0.6% | not timed | not timed | 516.69 ± 0.7% | 19.50 ± 0.7% | not timed | not timed | 637.59 ± 0.2% | | 1.00 | 1.24 | 32.73 |
| 10-bounded-repeat/letters-ru | 3475 | 383.31 ± 0.2% | not timed | not timed | 478.57 ± 0.4% | 21.84 ± 9.1% | not timed | not timed | 381.17 ± 0.5% | | 1.01 | 0.80 | 17.55 |
| 10-bounded-repeat/context | 53 | 79.90 ± 0.6% | not timed | not timed | 65.95 ± 0.9% | 19.80 ± 0.2% | not timed | not timed | 79.02 ± 0.8% | | 1.01 | 1.21 | 4.04 |
| 10-bounded-repeat/capitals | 11 | 1054.56 ± 0.2% | not timed | not timed | 618.26 ± 0.1% | 36.44 ± 0.1% | not timed | not timed | 1054.98 ± 0.2% | | 1.00 | 1.71 | 28.94 |
| 11-unstructured-to-json/extract | 600 | 49.96 ± 0.2% | not timed | not timed | 77.10 ± 0.1% | 48.90 ± 1.1% | not timed | not timed | 48.56 ± 1.7% | | 1.03 | 0.65 | 1.02 |
| 12-dictionary/single | 1 | 567.69 ± 0.6% | not timed | not timed | 561.01 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 568.54 ± 0.3% | | 1.00 | 1.01 | 1379.63 |
| 14-quadratic/1x | 100 | 12.79 ± 0.3% | not timed | not timed | 10.01 ± 0.1% | 0.98 ± 3.1% | not timed | not timed | 12.75 ± 1.6% | | 1.00 | 1.28 | 13.07 |
| 14-quadratic/2x | 200 | 7.93 ± 0.5% | not timed | not timed | 5.51 ± 0.3% | 0.53 ± 2.3% | not timed | not timed | 7.88 ± 0.2% | | 1.01 | 1.44 | 14.85 |
| 14-quadratic/10x | 1000 | 1.88 ± 0.1% | not timed | not timed | 1.21 ± 0.5% | 0.12 ± 1.9% | not timed | not timed | 1.88 ± 2.2% | | 1.00 | 1.55 | 16.31 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.2% | not timed | not timed | 0.35 ± 0.6% | 0.54 ± 6.2% | not timed | not timed | 1.45 ± 0.7% | | 1.00 | 4.20 | 2.68 |
| 04-ruff-noqa/compile-real | 1 | 92.77 ± 0.2% | not timed | not timed | 13.70 ± 0.1% | 134.11 ± 3.8% | not timed | not timed | 91.76 ± 1.3% | | 1.01 | 6.77 | 0.69 |
| 05-lexer-veryl/compile-single | 1 | 14.58 ± 0.5% | not timed | not timed | 2.52 ± 0.6% | 6.37 ± 4.9% | not timed | not timed | 14.53 ± 1.0% | | 1.00 | 5.78 | 2.29 |
| 07-unicode-character-data/compile | 1 | 58.39 ± 0.2% | not timed | not timed | 25.52 ± 0.3% | 35.46 ± 5.9% | not timed | not timed | 58.30 ± 1.0% | | 1.00 | 2.29 | 1.65 |
| 09-aws-keys/compile-full | 1 | 43.80 ± 0.2% | not timed | not timed | 8.24 ± 0.1% | 22.78 ± 6.5% | not timed | not timed | 43.39 ± 1.9% | | 1.01 | 5.32 | 1.92 |
| 09-aws-keys/compile-quick | 1 | 187.08 ± 0.1% | not timed | not timed | 46.35 ± 0.1% | 127.66 ± 6.8% | not timed | not timed | 187.53 ± 1.5% | | 1.00 | 4.04 | 1.47 |
| 10-bounded-repeat/compile-context | 1 | 14.66 ± 0.8% | not timed | not timed | 11.09 ± 0.2% | 15.31 ± 7.7% | not timed | not timed | 14.59 ± 2.2% | | 1.00 | 1.32 | 0.96 |
| 10-bounded-repeat/compile-capitals | 1 | 85.34 ± 0.8% | not timed | not timed | 8.02 ± 0.1% | 23.06 ± 3.3% | not timed | not timed | 85.12 ± 0.5% | | 1.00 | 10.63 | 3.70 |
| 11-unstructured-to-json/compile | 1 | 90.67 ± 0.2% | not timed | not timed | 40.25 ± 0.7% | 63.57 ± 5.3% | not timed | not timed | 90.12 ± 1.3% | | 1.01 | 2.25 | 1.43 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.4% | not timed | not timed | 0.07 ± 1.4% | 0.09 ± 17.2% | not timed | not timed | 0.36 ± 2.9% | | 1.01 | 5.44 | 4.10 |

