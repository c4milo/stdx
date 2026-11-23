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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148061474 |
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
| literal: a word | 217 | 16090.68 ± 0.4% | 1040.32 ± 0.1% | 28.84 ± 0.4% | 18354.72 ± 0.8% | 9040.49 ± 8.5% | 17.21 ± 0.2% | 86.60 ± 0.1% | 16066.82 ± 0.7% | 15.47 | 1.00 | 0.88 | 1.78 |
| literal: a word that is not there | 0 | 18686.52 ± 0.8% | 1048.21 ± 0.3% | 28.76 ± 0.4% | 19801.73 ± 0.7% | 29114.12 ± 2.9% | 17.02 ± 0.1% | 82.31 ± 0.2% | 18793.37 ± 0.6% | 17.83 | 0.99 | 0.94 | 0.64 |
| literal: one of four words | 661 | 6042.03 ± 0.6% | 1023.25 ± 0.1% | 14.77 ± 0.3% | 3949.06 ± 0.1% | 21.87 ± 0.1% | 5.38 ± 0.1% | 6.94 ± 0.7% | 6030.46 ± 0.3% | 5.90 | 1.00 | 1.53 | 276.29 |
| literal: a word in any case | 217 | 12648.43 ± 0.4% | 1040.51 ± 0.1% | 21.65 ± 1.9% | 3975.80 ± 0.1% | 38.05 ± 0.2% | refused | differs | 12643.93 ± 0.4% | 12.16 | 1.00 | 3.18 | 332.38 |
| literal: an href attribute | 33 | 13770.26 ± 0.7% | 1047.71 ± 0.1% | 27.51 ± 0.0% | 17074.52 ± 0.7% | 2267.23 ± 0.6% | 13.12 ± 0.2% | 75.39 ± 0.5% | 13793.86 ± 0.5% | 13.14 | 1.00 | 0.81 | 6.07 |
| literal: a word, second text | 123 | 16536.35 ± 1.1% | 1044.56 ± 0.0% | 28.35 ± 0.1% | 18500.60 ± 1.4% | 7943.92 ± 5.2% | 20.11 ± 0.8% | 70.07 ± 0.8% | 16550.90 ± 0.5% | 15.83 | 1.00 | 0.89 | 2.08 |
| class: two capitalized words | 1331 | 1106.05 ± 0.4% | 978.11 ± 0.1% | 26.27 ± 0.5% | 585.50 ± 0.1% | 40.57 ± 2.7% | 14.68 ± 0.5% | 68.82 ± 0.2% | 1107.35 ± 0.4% | 1.13 | 1.00 | 1.89 | 27.26 |
| class: a word that ends in ing | 3399 | 894.77 ± 0.3% | 894.95 ± 0.0% | 18.26 ± 0.3% | 547.87 ± 0.1% | 29.61 ± 9.2% | 8.14 ± 0.2% | 18.37 ± 1.1% | 893.86 ± 0.2% | 1.00 | 1.00 | 1.63 | 30.22 |
| class: a word in capitals | 2332 | 1452.80 ± 0.6% | 949.49 ± 0.1% | 27.87 ± 0.1% | 572.47 ± 0.1% | 43.45 ± 10.3% | 17.10 ± 0.4% | 83.13 ± 0.2% | 1454.08 ± 0.4% | 1.53 | 1.00 | 2.54 | 33.44 |
| class: a number | 8288 | 1985.51 ± 0.2% | 835.79 ± 0.1% | 28.16 ± 0.2% | 1716.40 ± 0.3% | 42.67 ± 12.9% | 0.54 ± 0.1% | 56.51 ± 0.6% | 1989.37 ± 0.1% | 2.38 | 1.00 | 1.16 | 46.53 |
| class: two capitalized words, second text | 5359 | 743.52 ± 0.2% | 744.57 ± 0.1% | 23.52 ± 0.1% | 484.36 ± 0.1% | 35.32 ± 6.5% | 17.04 ± 0.4% | 63.87 ± 0.4% | 738.01 ± 0.2% | 1.00 | 1.01 | 1.54 | 21.05 |
| other: a word between two words | 6104 | 754.55 ± 0.2% | 777.54 ± 0.1% | 23.73 ± 0.2% | 741.18 ± 0.3% | 107.05 ± 10.4% | 11.13 ± 0.2% | 69.60 ± 0.3% | 753.17 ± 0.2% | 0.97 | 1.00 | 1.02 | 7.05 |
| other: a number before a unit, second text | 1481 | 5442.19 ± 0.8% | 985.71 ± 0.1% | 26.25 ± 0.1% | 5652.56 ± 0.3% | 40.72 ± 9.2% | 18.14 ± 0.8% | 66.91 ± 0.1% | 5446.46 ± 0.5% | 5.52 | 1.00 | 0.96 | 133.65 |
| other: a heading's start tag | 110 | 12628.11 ± 0.8% | 1036.79 ± 0.2% | 27.75 ± 0.4% | 1711.57 ± 0.2% | 1585.99 ± 8.4% | 15.93 ± 0.3% | 88.87 ± 0.4% | 12597.25 ± 0.5% | 12.18 | 1.00 | 7.38 | 7.96 |
| other: a whole word | 217 | 14026.73 ± 0.4% | 1039.06 ± 0.0% | 29.87 ± 0.3% | 14673.59 ± 0.9% | 49.44 ± 0.2% | 13.07 ± 0.1% | 55.76 ± 0.1% | 14037.18 ± 0.6% | 13.50 | 1.00 | 0.96 | 283.71 |
| other: a line's first word, second text | 3716 | 1976.96 ± 0.3% | 877.00 ± 0.2% | 31.43 ± 0.2% | 1726.42 ± 0.3% | 62.55 ± 7.1% | refused | refused | 1969.68 ± 0.4% | 2.25 | 1.00 | 1.15 | 31.61 |
| other: fourteen octets before an x | 87 | 19729.29 ± 0.9% | 243.43 ± 0.4% | 6.60 ± 0.1% | 4032.17 ± 0.5% | 10.65 ± 0.2% | differs | 17.76 ± 0.1% | 19767.68 ± 0.7% | 81.05 | 1.00 | 4.89 | 1852.09 |
| other: a Greek word | 21815 | 515.93 ± 0.6% | 413.17 ± 0.1% | 31.35 ± 0.2% | 289.74 ± 0.4% | 48.20 ± 8.9% | differs | refused | 512.94 ± 0.2% | 1.25 | 1.01 | 1.78 | 10.70 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.92 ± 0.5% | 25.91 ± 0.5% | 0.87 ± 0.6% | 19.72 ± 0.2% | 2.74 ± 0.6% | differs | 4.01 ± 0.2% | 25.90 ± 0.4% | 1.00 | 1.00 | 1.31 | 9.45 |
| a UUID | 32895 | 21.10 ± 0.4% | 21.15 ± 0.3% | 0.65 ± 0.3% | 14.98 ± 0.4% | 3.10 ± 0.5% | 0.73 ± 0.1% | 3.59 ± 0.4% | 21.23 ± 0.2% | 1.00 | 0.99 | 1.41 | 6.80 |
| an IPv4 address | 33176 | 37.06 ± 0.2% | 36.99 ± 0.3% | 2.11 ± 0.1% | 29.27 ± 0.3% | 6.65 ± 0.2% | differs | 4.18 ± 0.1% | 37.14 ± 0.3% | 1.00 | 1.00 | 1.27 | 5.57 |
| a date and time | 32954 | 31.30 ± 0.2% | 31.37 ± 0.2% | 1.47 ± 0.3% | 21.48 ± 0.2% | 7.06 ± 0.1% | 1.25 ± 0.2% | 7.14 ± 0.7% | 31.31 ± 0.3% | 1.00 | 1.00 | 1.46 | 4.43 |
| a field path | 32606 | 29.53 ± 0.2% | 29.49 ± 0.4% | 1.03 ± 0.1% | 23.14 ± 0.2% | 3.53 ± 0.3% | differs | 2.93 ± 0.2% | 29.52 ± 0.2% | 1.00 | 1.00 | 1.28 | 8.37 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.48 ± 0.2% | 11.48 ± 0.8% | 11.51 ± 0.4% | 11.55 ± 0.2% | 4.93 ± 1.3% | 0.93 ± 0.8% | none | 11.44 ± 0.6% | 1.00 | 1.00 | 0.99 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 233.31 ± 0.2% | 235.39 ± 0.2% | 285.78 ± 0.3% | 87.13 ± 0.2% | 220.41 ± 0.9% | 483.11 ± 0.5% | 3870.81 ± 1.5% | 233.39 ± 0.3% | 0.99 | 1.00 | 2.68 | 1.06 |
| a UUID | 62 | 156.54 ± 0.1% | 157.32 ± 0.4% | 178.78 ± 0.1% | 45.88 ± 0.2% | 98.78 ± 0.5% | 181.10 ± 0.7% | 4399.26 ± 2.1% | 156.38 ± 0.1% | 1.00 | 1.00 | 3.41 | 1.58 |
| an IPv4 address | 29 | 418.61 ± 0.4% | 423.90 ± 0.3% | 613.41 ± 0.3% | 77.36 ± 1.1% | 130.11 ± 1.5% | 290.51 ± 0.8% | 7619.85 ± 0.4% | 418.03 ± 0.5% | 0.99 | 1.00 | 5.41 | 3.22 |
| a date and time | 56 | 306.07 ± 0.3% | 308.58 ± 0.3% | 397.38 ± 0.0% | 72.79 ± 0.1% | 136.01 ± 1.6% | 317.43 ± 0.7% | 4907.94 ± 0.6% | 306.09 ± 0.2% | 0.99 | 1.00 | 4.20 | 2.25 |
| a field path | 39 | 226.46 ± 0.3% | 227.84 ± 0.1% | 274.43 ± 0.2% | 80.10 ± 0.5% | 205.33 ± 0.8% | 483.79 ± 1.0% | 4916.68 ± 0.7% | 226.38 ± 0.1% | 0.99 | 1.00 | 2.83 | 1.10 |
| literal: a word | 7 | 618.25 ± 0.3% | 661.47 ± 0.3% | 1247.91 ± 0.7% | 518.38 ± 1.6% | 632.17 ± 1.7% | 915.80 ± 0.4% | 29515.04 ± 0.1% | 617.96 ± 0.4% | 0.93 | 1.00 | 1.19 | 0.98 |
| literal: a word that is not there | 8 | 594.81 ± 0.1% | 643.43 ± 0.2% | 1178.67 ± 0.2% | 473.88 ± 0.1% | 604.26 ± 1.4% | 869.48 ± 0.5% | 28545.47 ± 0.1% | 595.17 ± 0.2% | 0.92 | 1.00 | 1.26 | 0.98 |
| literal: one of four words | 26 | 239.32 ± 0.2% | 393.98 ± 0.3% | 553.41 ± 0.6% | 49.59 ± 0.3% | 242.03 ± 1.4% | 354.60 ± 0.5% | 15412.74 ± 0.1% | 239.46 ± 0.3% | 0.61 | 1.00 | 4.83 | 0.99 |
| literal: a word in any case | 11 | 482.67 ± 0.2% | 515.05 ± 0.3% | 842.58 ± 0.3% | 15.83 ± 0.8% | 650.33 ± 0.9% | refused | 23410.29 ± 0.5% | 482.43 ± 0.4% | 0.94 | 1.00 | 30.50 | 0.74 |
| literal: an href attribute | 12 | 350.45 ± 0.6% | 363.44 ± 0.3% | 499.19 ± 0.5% | 45.37 ± 0.4% | 499.70 ± 1.0% | 768.12 ± 2.1% | 21470.99 ± 0.2% | 349.94 ± 0.4% | 0.96 | 1.00 | 7.72 | 0.70 |
| literal: a word, second text | 10 | 555.24 ± 0.7% | 608.99 ± 0.6% | 1064.85 ± 0.6% | 419.82 ± 0.3% | 539.76 ± 1.3% | 795.14 ± 0.7% | 26466.77 ± 0.1% | 554.77 ± 0.4% | 0.91 | 1.00 | 1.32 | 1.03 |
| class: two capitalized words | 23 | 432.50 ± 0.2% | 464.92 ± 0.2% | 703.57 ± 0.2% | 102.43 ± 0.2% | 506.65 ± 0.9% | 736.11 ± 0.2% | 6568.68 ± 0.2% | 432.41 ± 0.6% | 0.93 | 1.00 | 4.22 | 0.85 |
| class: a word that ends in ing | 9 | 550.90 ± 0.5% | 621.20 ± 0.3% | 1158.02 ± 0.2% | 134.26 ± 0.7% | 755.04 ± 2.2% | 1072.05 ± 1.8% | 16006.43 ± 0.2% | 550.21 ± 0.4% | 0.89 | 1.00 | 4.10 | 0.73 |
| class: a word in capitals | 16 | 482.62 ± 0.5% | 527.39 ± 0.4% | 898.59 ± 0.1% | 137.27 ± 1.1% | 754.64 ± 7.3% | 1009.41 ± 0.3% | 8643.94 ± 0.2% | 483.63 ± 0.3% | 0.92 | 1.00 | 3.52 | 0.64 |
| class: a number | 6 | 601.62 ± 0.2% | 673.41 ± 0.7% | 1350.75 ± 0.1% | 42.12 ± 0.5% | 1405.23 ± 11.6% | 1886.26 ± 1.1% | 22494.93 ± 0.2% | 601.40 ± 0.3% | 0.89 | 1.00 | 14.28 | 0.43 |
| class: two capitalized words, second text | 23 | 432.47 ± 0.6% | 464.90 ± 0.1% | 703.42 ± 0.6% | 103.96 ± 0.2% | 507.14 ± 0.5% | 735.04 ± 0.6% | 6575.19 ± 0.3% | 432.65 ± 0.2% | 0.93 | 1.00 | 4.16 | 0.85 |
| other: a word between two words | 13 | 547.35 ± 0.2% | 565.70 ± 0.3% | 944.67 ± 0.4% | 137.36 ± 0.3% | 502.90 ± 1.5% | 808.73 ± 0.5% | 14802.63 ± 0.1% | 546.84 ± 0.4% | 0.97 | 1.00 | 3.98 | 1.09 |
| other: a number before a unit, second text | 15 | 402.77 ± 0.2% | 443.67 ± 0.2% | 650.48 ± 0.3% | 39.52 ± 0.2% | 627.95 ± 2.1% | 892.40 ± 1.6% | 15098.62 ± 0.1% | 402.94 ± 0.2% | 0.91 | 1.00 | 10.19 | 0.64 |
| other: a heading's start tag | 13 | 358.15 ± 0.5% | 364.31 ± 0.3% | 500.17 ± 0.6% | 43.65 ± 0.5% | 631.46 ± 0.6% | 856.47 ± 0.1% | 17803.37 ± 0.5% | 358.60 ± 0.5% | 0.98 | 1.00 | 8.21 | 0.57 |
| other: a whole word | 11 | 580.84 ± 0.6% | 614.69 ± 0.4% | 1084.12 ± 0.7% | 121.92 ± 0.3% | 566.89 ± 3.6% | 820.40 ± 0.9% | 26560.96 ± 0.3% | 581.34 ± 0.4% | 0.94 | 1.00 | 4.76 | 1.02 |
| other: a line's first word, second text | 17 | 528.14 ± 0.3% | 546.72 ± 0.1% | 930.17 ± 0.2% | 130.02 ± 0.1% | 715.09 ± 1.0% | refused | refused | 526.79 ± 0.5% | 0.97 | 1.00 | 4.06 | 0.74 |
| other: fourteen octets before an x | 16 | 111.44 ± 0.5% | 161.69 ± 0.3% | 190.31 ± 0.7% | 15.17 ± 0.2% | 452.42 ± 0.6% | 415.05 ± 0.3% | 12560.01 ± 0.8% | 111.36 ± 0.6% | 0.69 | 1.00 | 7.35 | 0.25 |
| other: a Greek word | 8 | 418.45 ± 0.1% | 579.16 ± 0.4% | 1033.69 ± 1.1% | 58.97 ± 0.5% | 1388.72 ± 0.8% | 1806.79 ± 0.6% | refused | 418.17 ± 0.4% | 0.72 | 1.00 | 7.10 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12919.26 ± 0.5% | not timed | not timed | 16572.88 ± 0.7% | 2135.24 ± 6.6% | not timed | not timed | 12932.93 ± 0.7% | | 1.00 | 0.78 | 6.05 |
| 01-literal/sherlock-casei-en | 522 | 4489.84 ± 1.1% | not timed | not timed | 3588.86 ± 0.2% | 32.50 ± 0.2% | not timed | not timed | 4480.53 ± 0.6% | | 1.00 | 1.25 | 138.15 |
| 01-literal/sherlock-ru | 724 | 13540.04 ± 0.7% | not timed | not timed | 17369.78 ± 0.6% | 1448.57 ± 8.1% | not timed | not timed | 13535.34 ± 0.3% | | 1.00 | 0.78 | 9.35 |
| 01-literal/sherlock-casei-ru | 746 | 5299.55 ± 0.2% | not timed | not timed | 3329.29 ± 0.2% | 31.58 ± 0.4% | not timed | not timed | 5297.27 ± 0.1% | | 1.00 | 1.59 | 167.82 |
| 01-literal/sherlock-zh | 30 | 17235.61 ± 0.7% | not timed | not timed | 18966.33 ± 0.6% | 3024.64 ± 9.1% | not timed | not timed | 17212.00 ± 0.5% | | 1.00 | 0.91 | 5.70 |
| 02-literal-alternate/sherlock-en | 714 | 5748.49 ± 0.3% | not timed | not timed | 3942.22 ± 0.1% | 16.59 ± 0.1% | not timed | not timed | 5751.06 ± 0.3% | | 1.00 | 1.46 | 346.53 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1715.87 ± 1.0% | not timed | not timed | 697.29 ± 0.3% | 11.13 ± 0.3% | not timed | not timed | 1706.92 ± 0.5% | | 1.01 | 2.46 | 154.15 |
| 02-literal-alternate/sherlock-ru | 899 | 4653.48 ± 0.6% | not timed | not timed | 3257.61 ± 1.0% | 22.61 ± 0.1% | not timed | not timed | 4656.06 ± 1.5% | | 1.00 | 1.43 | 205.78 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1813.27 ± 0.5% | not timed | not timed | 1231.19 ± 0.1% | 9.13 ± 0.1% | not timed | not timed | 1806.71 ± 0.2% | | 1.00 | 1.47 | 198.68 |
| 02-literal-alternate/sherlock-zh | 207 | 7045.94 ± 0.5% | not timed | not timed | 4164.86 ± 0.1% | 31.45 ± 0.2% | not timed | not timed | 7046.01 ± 0.6% | | 1.00 | 1.69 | 224.03 |
| 03-date/ascii | 111817 | 127.20 ± 0.6% | not timed | not timed | 95.73 ± 0.3% | 0.20 ± 2.0% | not timed | not timed | 126.47 ± 0.1% | | 1.01 | 1.33 | 628.82 |
| 04-ruff-noqa/real | 84 | 554.10 ± 0.1% | not timed | not timed | 479.47 ± 0.2% | 19.55 ± 0.6% | not timed | not timed | 553.73 ± 0.2% | | 1.00 | 1.16 | 28.34 |
| 04-ruff-noqa/tweaked | 44 | 549.65 ± 0.1% | not timed | not timed | 462.01 ± 0.1% | 365.54 ± 1.3% | not timed | not timed | 547.88 ± 0.1% | | 1.00 | 1.19 | 1.50 |
| 05-lexer-veryl/single | 124800 | 4.23 ± 0.6% | not timed | not timed | 5.13 ± 0.2% | 0.21 ± 2.1% | not timed | not timed | 4.23 ± 2.5% | | 1.00 | 0.82 | 20.52 |
| 06-cloud-flare-redos/original | 107 | 263.98 ± 2.1% | not timed | not timed | 213.85 ± 0.0% | 24.92 ± 0.6% | not timed | not timed | 263.47 ± 19.4% | | 1.00 | 1.23 | 10.59 |
| 06-cloud-flare-redos/simplified-short | 102 | 259.35 ± 0.2% | not timed | not timed | 227.75 ± 1.9% | 26.03 ± 5.6% | not timed | not timed | 257.59 ± 4.0% | | 1.01 | 1.14 | 9.96 |
| 06-cloud-flare-redos/simplified-long | 10000 | 286.13 ± 0.3% | not timed | not timed | 254.99 ± 0.2% | 28.82 ± 0.3% | not timed | not timed | 286.16 ± 0.3% | | 1.00 | 1.12 | 9.93 |
| 07-unicode-character-data/parse-line | 558784 | 196.45 ± 0.2% | not timed | not timed | 179.11 ± 0.3% | 43.05 ± 0.7% | not timed | not timed | 197.45 ± 0.7% | | 0.99 | 1.10 | 4.56 |
| 08-words/all-english | 56691 | 120.78 ± 0.3% | not timed | not timed | 82.93 ± 0.1% | 12.83 ± 4.2% | not timed | not timed | 120.01 ± 0.4% | | 1.01 | 1.46 | 9.41 |
| 08-words/long-english | 839 | 1006.67 ± 0.1% | not timed | not timed | 595.84 ± 0.1% | 32.62 ± 6.7% | not timed | not timed | 1006.73 ± 0.2% | | 1.00 | 1.69 | 30.86 |
| 09-aws-keys/full | 0 | 409.13 ± 0.1% | not timed | not timed | 494.71 ± 0.1% | 64.47 ± 0.5% | not timed | not timed | 409.41 ± 0.2% | | 1.00 | 0.83 | 6.35 |
| 09-aws-keys/quick | 0 | 741.45 ± 0.1% | not timed | not timed | 999.81 ± 0.2% | 420.55 ± 0.5% | not timed | not timed | 738.81 ± 0.1% | | 1.00 | 0.74 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 638.49 ± 0.2% | not timed | not timed | 518.06 ± 0.8% | 19.46 ± 0.4% | not timed | not timed | 637.75 ± 0.2% | | 1.00 | 1.23 | 32.81 |
| 10-bounded-repeat/letters-ru | 3475 | 385.03 ± 0.1% | not timed | not timed | 478.08 ± 0.1% | 21.73 ± 8.1% | not timed | not timed | 384.09 ± 0.5% | | 1.00 | 0.81 | 17.72 |
| 10-bounded-repeat/context | 53 | 78.04 ± 3.0% | not timed | not timed | 66.20 ± 3.7% | 19.84 ± 0.2% | not timed | not timed | 77.45 ± 3.0% | | 1.01 | 1.18 | 3.93 |
| 10-bounded-repeat/capitals | 11 | 1042.31 ± 0.2% | not timed | not timed | 616.74 ± 0.1% | 36.63 ± 0.1% | not timed | not timed | 1042.29 ± 0.2% | | 1.00 | 1.69 | 28.46 |
| 11-unstructured-to-json/extract | 600 | 49.85 ± 0.2% | not timed | not timed | 77.26 ± 0.3% | 49.04 ± 0.8% | not timed | not timed | 48.45 ± 0.9% | | 1.03 | 0.65 | 1.02 |
| 12-dictionary/single | 1 | 568.09 ± 0.4% | not timed | not timed | 561.51 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 569.50 ± 0.2% | | 1.00 | 1.01 | 1407.73 |
| 14-quadratic/1x | 100 | 9.67 ± 0.4% | not timed | not timed | 10.05 ± 0.2% | 0.98 ± 3.2% | not timed | not timed | 9.65 ± 1.1% | | 1.00 | 0.96 | 9.86 |
| 14-quadratic/2x | 200 | 5.56 ± 0.3% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 0.8% | not timed | not timed | 5.56 ± 1.1% | | 1.00 | 1.00 | 10.42 |
| 14-quadratic/10x | 1000 | 1.26 ± 0.1% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 1.26 ± 0.4% | | 1.00 | 1.04 | 10.93 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.2% | not timed | not timed | 0.35 ± 0.2% | 0.55 ± 4.3% | not timed | not timed | 1.45 ± 1.4% | | 1.00 | 4.19 | 2.65 |
| 04-ruff-noqa/compile-real | 1 | 92.64 ± 0.2% | not timed | not timed | 13.75 ± 0.2% | 139.07 ± 3.3% | not timed | not timed | 92.52 ± 1.2% | | 1.00 | 6.74 | 0.67 |
| 05-lexer-veryl/compile-single | 1 | 14.50 ± 0.2% | not timed | not timed | 2.56 ± 0.6% | 6.43 ± 1.9% | not timed | not timed | 14.45 ± 1.3% | | 1.00 | 5.67 | 2.26 |
| 07-unicode-character-data/compile | 1 | 58.44 ± 0.3% | not timed | not timed | 25.62 ± 0.3% | 35.44 ± 2.9% | not timed | not timed | 58.19 ± 1.4% | | 1.00 | 2.28 | 1.65 |
| 09-aws-keys/compile-full | 1 | 43.60 ± 0.4% | not timed | not timed | 8.30 ± 0.1% | 23.46 ± 2.0% | not timed | not timed | 43.40 ± 1.0% | | 1.00 | 5.25 | 1.86 |
| 09-aws-keys/compile-quick | 1 | 186.68 ± 0.1% | not timed | not timed | 46.99 ± 0.2% | 134.17 ± 1.9% | not timed | not timed | 186.58 ± 0.8% | | 1.00 | 3.97 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 14.67 ± 0.9% | not timed | not timed | 11.11 ± 0.4% | 16.21 ± 3.4% | not timed | not timed | 14.53 ± 2.0% | | 1.01 | 1.32 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 85.46 ± 0.7% | not timed | not timed | 8.08 ± 0.3% | 24.17 ± 2.7% | not timed | not timed | 85.40 ± 1.3% | | 1.00 | 10.58 | 3.54 |
| 11-unstructured-to-json/compile | 1 | 90.59 ± 0.3% | not timed | not timed | 41.09 ± 0.4% | 68.73 ± 1.7% | not timed | not timed | 89.34 ± 0.7% | | 1.01 | 2.20 | 1.32 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.3% | not timed | not timed | 0.07 ± 39.6% | 0.09 ± 11.1% | not timed | not timed | 0.36 ± 1.6% | | 1.00 | 5.32 | 3.88 |

