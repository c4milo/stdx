# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215458463 |
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
| literal: a word | 217 | 16055.88 ± 0.9% | 5002.02 ± 0.3% | 27.94 ± 0.5% | 18041.99 ± 1.2% | 9297.61 ± 8.9% | 17.49 ± 0.2% | 83.65 ± 2.1% | 16096.99 ± 1.5% | 3.21 | 1.00 | 0.89 | 1.73 |
| literal: a word that is not there | 0 | 18642.26 ± 1.4% | 4882.89 ± 0.2% | 28.03 ± 0.2% | 19554.02 ± 1.9% | 27271.64 ± 2.2% | 17.21 ± 0.1% | 79.43 ± 0.9% | 18647.63 ± 1.1% | 3.82 | 1.00 | 0.95 | 0.68 |
| literal: one of four words | 661 | 6075.43 ± 0.5% | 1933.60 ± 0.3% | 14.28 ± 0.1% | 3941.88 ± 0.2% | 21.92 ± 0.2% | 5.47 ± 0.2% | 6.89 ± 0.6% | 6067.91 ± 0.9% | 3.14 | 1.00 | 1.54 | 277.14 |
| literal: a word in any case | 217 | 12614.11 ± 1.2% | 2074.20 ± 0.2% | 21.02 ± 1.8% | 3971.22 ± 0.2% | 36.77 ± 1.5% | refused | differs | 12601.37 ± 0.7% | 6.08 | 1.00 | 3.18 | 343.06 |
| literal: an href attribute | 33 | 13760.70 ± 0.5% | 616.05 ± 0.2% | 27.05 ± 0.2% | 16948.60 ± 1.1% | 2265.75 ± 0.4% | 13.22 ± 0.3% | 73.53 ± 1.0% | 13753.68 ± 0.6% | 22.34 | 1.00 | 0.81 | 6.07 |
| literal: a word, second text | 123 | 16520.92 ± 0.8% | 3353.73 ± 0.2% | 27.78 ± 0.3% | 18177.44 ± 0.8% | 7664.89 ± 4.8% | 20.16 ± 0.7% | 69.81 ± 1.6% | 16598.08 ± 1.0% | 4.93 | 1.00 | 0.91 | 2.16 |
| class: two capitalized words | 1331 | 1065.29 ± 0.3% | 603.84 ± 0.4% | 25.79 ± 0.2% | 585.42 ± 0.1% | 40.54 ± 0.1% | 14.81 ± 0.2% | 67.37 ± 1.4% | 1064.46 ± 0.0% | 1.76 | 1.00 | 1.82 | 26.28 |
| class: a word that ends in ing | 3399 | 580.59 ± 0.1% | 579.28 ± 0.3% | 17.88 ± 0.1% | 547.93 ± 0.1% | 29.63 ± 12.7% | 8.23 ± 0.2% | 18.39 ± 0.6% | 580.05 ± 0.1% | 1.00 | 1.00 | 1.06 | 19.59 |
| class: a word in capitals | 2332 | 1373.86 ± 0.4% | 614.77 ± 0.2% | 27.34 ± 0.3% | 572.50 ± 0.0% | 43.44 ± 17.4% | 17.22 ± 0.3% | 82.32 ± 0.8% | 1371.43 ± 0.7% | 2.23 | 1.00 | 2.40 | 31.63 |
| class: a number | 8288 | 2001.82 ± 0.4% | 833.91 ± 0.1% | 27.59 ± 0.3% | 1723.65 ± 0.4% | 42.03 ± 15.3% | 0.55 ± 0.1% | 57.37 ± 1.1% | 1996.98 ± 0.3% | 2.40 | 1.00 | 1.16 | 47.63 |
| class: two capitalized words, second text | 5359 | 514.63 ± 0.3% | 528.51 ± 0.2% | 23.08 ± 0.1% | 485.11 ± 0.1% | 35.28 ± 15.1% | 17.14 ± 0.6% | 62.68 ± 1.6% | 521.61 ± 0.1% | 0.97 | 0.99 | 1.06 | 14.59 |
| other: a word between two words | 6104 | 741.66 ± 0.1% | 598.84 ± 0.1% | 23.33 ± 0.1% | 735.71 ± 0.2% | 109.70 ± 9.2% | 11.29 ± 0.1% | 68.18 ± 1.7% | 740.39 ± 0.2% | 1.24 | 1.00 | 1.01 | 6.76 |
| other: a number before a unit, second text | 1481 | 5335.08 ± 0.6% | 1108.32 ± 0.2% | 25.87 ± 0.2% | 5670.78 ± 0.3% | 40.68 ± 9.8% | 18.21 ± 0.3% | 65.35 ± 0.4% | 5341.92 ± 0.6% | 4.81 | 1.00 | 0.94 | 131.15 |
| other: a heading's start tag | 110 | 12598.28 ± 0.3% | 750.95 ± 0.2% | 27.10 ± 0.2% | 1709.33 ± 0.3% | 1581.54 ± 0.9% | 16.26 ± 0.4% | 85.17 ± 2.0% | 12608.32 ± 0.4% | 16.78 | 1.00 | 7.37 | 7.97 |
| other: a whole word | 217 | 14038.01 ± 0.6% | 608.27 ± 0.2% | 29.12 ± 0.3% | 14562.69 ± 1.4% | 47.63 ± 9.0% | 13.48 ± 0.1% | 55.00 ± 0.6% | 14040.53 ± 0.4% | 23.08 | 1.00 | 0.96 | 294.75 |
| other: a line's first word, second text | 3716 | 1954.01 ± 0.5% | 594.52 ± 0.2% | 30.97 ± 0.3% | 1724.80 ± 0.3% | 61.86 ± 8.1% | refused | refused | 1948.67 ± 0.5% | 3.29 | 1.00 | 1.13 | 31.59 |
| other: fourteen octets before an x | 87 | 19720.34 ± 0.6% | 251.17 ± 0.8% | 6.30 ± 0.2% | 4030.02 ± 0.2% | 10.62 ± 0.2% | differs | 17.75 ± 0.1% | 19772.59 ± 0.7% | 78.51 | 1.00 | 4.89 | 1857.63 |
| other: a Greek word | 21815 | 501.45 ± 0.9% | 413.17 ± 0.1% | 30.73 ± 0.2% | 289.69 ± 0.2% | 46.82 ± 27.2% | differs | refused | 498.50 ± 0.6% | 1.21 | 1.01 | 1.73 | 10.71 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.86 ± 0.3% | 19.89 ± 0.2% | 0.84 ± 0.2% | 19.86 ± 0.5% | 2.78 ± 0.9% | differs | 4.07 ± 0.1% | 19.92 ± 0.3% | 1.00 | 1.00 | 1.00 | 7.15 |
| a UUID | 32895 | 21.32 ± 0.3% | 21.35 ± 0.4% | 0.64 ± 0.1% | 15.16 ± 0.7% | 3.08 ± 0.8% | 0.73 ± 0.2% | 3.63 ± 0.7% | 21.40 ± 0.2% | 1.00 | 1.00 | 1.41 | 6.91 |
| an IPv4 address | 33176 | 36.85 ± 0.5% | 36.89 ± 0.5% | 2.05 ± 0.2% | 29.52 ± 0.5% | 6.67 ± 0.2% | differs | 4.16 ± 0.2% | 36.91 ± 0.4% | 1.00 | 1.00 | 1.25 | 5.53 |
| a date and time | 32954 | 31.54 ± 0.2% | 31.41 ± 0.2% | 1.41 ± 0.2% | 21.41 ± 0.8% | 7.05 ± 0.3% | 1.26 ± 0.1% | 7.20 ± 0.5% | 31.43 ± 0.4% | 1.00 | 1.00 | 1.47 | 4.48 |
| a field path | 32606 | 23.52 ± 0.3% | 23.57 ± 0.3% | 1.00 ± 0.4% | 23.29 ± 0.4% | 3.49 ± 1.4% | differs | 2.97 ± 0.3% | 23.58 ± 0.1% | 1.00 | 1.00 | 1.01 | 6.74 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.08 ± 0.2% | 11.11 ± 0.4% | 11.07 ± 0.2% | 11.83 ± 0.2% | 4.98 ± 2.4% | 0.94 ± 0.6% | none | 11.11 ± 0.2% | 1.00 | 1.00 | 0.94 | 2.23 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 230.87 ± 0.3% | 231.72 ± 0.2% | 277.27 ± 0.4% | 86.53 ± 0.7% | 225.21 ± 1.8% | 483.43 ± 1.1% | 3801.54 ± 2.7% | 230.58 ± 0.3% | 1.00 | 1.00 | 2.67 | 1.03 |
| a UUID | 62 | 151.04 ± 0.2% | 151.45 ± 0.1% | 170.35 ± 0.2% | 46.66 ± 0.7% | 100.53 ± 0.6% | 190.82 ± 2.9% | 4236.75 ± 0.6% | 151.06 ± 0.1% | 1.00 | 1.00 | 3.24 | 1.50 |
| an IPv4 address | 29 | 417.30 ± 0.7% | 420.99 ± 0.7% | 603.71 ± 0.8% | 77.28 ± 0.2% | 133.05 ± 1.4% | 303.81 ± 1.5% | 7576.31 ± 0.3% | 417.09 ± 0.5% | 0.99 | 1.00 | 5.40 | 3.14 |
| a date and time | 56 | 301.01 ± 0.3% | 303.14 ± 0.2% | 384.63 ± 0.2% | 73.45 ± 0.4% | 139.64 ± 2.5% | 323.60 ± 0.9% | 4910.55 ± 0.8% | 301.07 ± 0.2% | 0.99 | 1.00 | 4.10 | 2.16 |
| a field path | 39 | 226.36 ± 0.1% | 226.99 ± 0.2% | 269.67 ± 0.3% | 81.18 ± 1.2% | 207.77 ± 1.0% | 499.44 ± 3.0% | 4846.51 ± 0.4% | 226.10 ± 0.2% | 1.00 | 1.00 | 2.79 | 1.09 |
| literal: a word | 7 | 629.40 ± 1.0% | 676.89 ± 0.9% | 1245.80 ± 0.7% | 526.27 ± 0.1% | 640.45 ± 1.1% | 959.60 ± 0.5% | 31089.07 ± 0.3% | 627.73 ± 0.5% | 0.93 | 1.00 | 1.20 | 0.98 |
| literal: a word that is not there | 8 | 607.32 ± 0.8% | 656.27 ± 0.6% | 1172.77 ± 0.2% | 483.74 ± 0.1% | 615.90 ± 2.1% | 908.86 ± 0.2% | 29546.88 ± 0.1% | 606.72 ± 0.2% | 0.93 | 1.00 | 1.26 | 0.99 |
| literal: one of four words | 26 | 239.54 ± 0.3% | 398.92 ± 0.4% | 551.34 ± 0.5% | 50.24 ± 1.1% | 246.87 ± 2.2% | 375.34 ± 0.8% | 16044.00 ± 0.1% | 239.57 ± 0.3% | 0.60 | 1.00 | 4.77 | 0.97 |
| literal: a word in any case | 11 | 445.43 ± 0.2% | 474.56 ± 0.2% | 705.34 ± 0.3% | 15.83 ± 1.6% | 672.06 ± 1.0% | refused | 23709.07 ± 0.3% | 445.36 ± 0.3% | 0.94 | 1.00 | 28.13 | 0.66 |
| literal: an href attribute | 12 | 342.14 ± 0.6% | 354.23 ± 0.5% | 473.26 ± 0.4% | 45.70 ± 0.5% | 512.90 ± 1.3% | 775.15 ± 0.4% | 22001.45 ± 0.4% | 342.10 ± 0.4% | 0.97 | 1.00 | 7.49 | 0.67 |
| literal: a word, second text | 10 | 559.54 ± 1.6% | 614.24 ± 1.1% | 1056.40 ± 1.0% | 404.36 ± 0.2% | 547.76 ± 1.4% | 803.32 ± 0.5% | 27331.14 ± 0.6% | 559.93 ± 0.3% | 0.91 | 1.00 | 1.38 | 1.02 |
| class: two capitalized words | 23 | 427.67 ± 0.9% | 462.99 ± 0.5% | 685.05 ± 0.6% | 100.33 ± 0.1% | 515.29 ± 0.9% | 744.04 ± 0.4% | 6489.15 ± 0.4% | 428.37 ± 0.3% | 0.92 | 1.00 | 4.26 | 0.83 |
| class: a word that ends in ing | 9 | 548.70 ± 0.3% | 624.91 ± 0.6% | 1131.74 ± 0.2% | 132.65 ± 2.0% | 775.89 ± 1.2% | 1108.59 ± 0.5% | 16067.18 ± 0.2% | 547.97 ± 0.3% | 0.88 | 1.00 | 4.14 | 0.71 |
| class: a word in capitals | 16 | 481.42 ± 0.2% | 525.81 ± 0.2% | 881.60 ± 0.2% | 135.77 ± 0.6% | 766.04 ± 1.0% | 1024.05 ± 0.7% | 8547.45 ± 0.2% | 481.82 ± 0.2% | 0.92 | 1.00 | 3.55 | 0.63 |
| class: a number | 6 | 605.86 ± 0.5% | 676.06 ± 0.3% | 1351.35 ± 0.1% | 41.83 ± 0.7% | 1430.03 ± 0.4% | 1862.61 ± 1.2% | 22840.31 ± 0.1% | 606.49 ± 0.3% | 0.90 | 1.00 | 14.49 | 0.42 |
| class: two capitalized words, second text | 23 | 427.88 ± 0.3% | 462.44 ± 0.3% | 685.25 ± 0.7% | 101.77 ± 0.3% | 511.40 ± 1.5% | 764.50 ± 0.2% | 6486.29 ± 0.2% | 426.87 ± 0.5% | 0.93 | 1.00 | 4.20 | 0.84 |
| other: a word between two words | 13 | 541.52 ± 0.3% | 559.11 ± 0.6% | 921.20 ± 0.3% | 133.34 ± 0.7% | 511.77 ± 1.1% | 815.25 ± 0.5% | 14899.97 ± 0.2% | 540.35 ± 0.7% | 0.97 | 1.00 | 4.06 | 1.06 |
| other: a number before a unit, second text | 15 | 395.13 ± 0.4% | 437.25 ± 0.3% | 625.31 ± 0.2% | 39.57 ± 0.3% | 644.76 ± 0.6% | 892.12 ± 1.0% | 15265.23 ± 0.3% | 395.01 ± 0.3% | 0.90 | 1.00 | 9.98 | 0.61 |
| other: a heading's start tag | 13 | 354.63 ± 0.4% | 359.99 ± 0.3% | 486.01 ± 0.3% | 43.80 ± 0.5% | 638.53 ± 0.6% | 879.18 ± 0.6% | 18239.13 ± 0.5% | 354.86 ± 0.4% | 0.99 | 1.00 | 8.10 | 0.56 |
| other: a whole word | 11 | 575.35 ± 0.2% | 606.45 ± 0.8% | 1037.99 ± 0.2% | 118.22 ± 0.5% | 578.36 ± 1.2% | 836.25 ± 0.5% | 27324.07 ± 0.3% | 575.16 ± 0.2% | 0.95 | 1.00 | 4.87 | 0.99 |
| other: a line's first word, second text | 17 | 524.57 ± 0.3% | 544.01 ± 0.3% | 894.94 ± 0.4% | 129.68 ± 0.2% | 724.77 ± 1.0% | refused | refused | 522.84 ± 0.7% | 0.96 | 1.00 | 4.05 | 0.72 |
| other: fourteen octets before an x | 16 | 107.79 ± 0.4% | 155.12 ± 0.6% | 180.45 ± 0.3% | 15.16 ± 0.4% | 462.31 ± 0.7% | 413.47 ± 0.3% | 12965.94 ± 0.4% | 107.61 ± 0.3% | 0.69 | 1.00 | 7.11 | 0.23 |
| other: a Greek word | 8 | 423.07 ± 0.4% | 586.88 ± 0.6% | 1047.43 ± 0.6% | 59.12 ± 0.2% | 1415.39 ± 0.7% | 1797.42 ± 0.4% | refused | 423.13 ± 0.3% | 0.72 | 1.00 | 7.16 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12854.68 ± 0.5% | not timed | not timed | 16567.05 ± 0.9% | 1974.82 ± 23.5% | not timed | not timed | 12838.29 ± 0.7% | | 1.00 | 0.78 | 6.51 |
| 01-literal/sherlock-casei-en | 522 | 4955.26 ± 0.9% | not timed | not timed | 3591.36 ± 0.2% | 32.10 ± 8.7% | not timed | not timed | 4956.64 ± 0.8% | | 1.00 | 1.38 | 154.39 |
| 01-literal/sherlock-ru | 724 | 13536.02 ± 0.8% | not timed | not timed | 17325.86 ± 0.7% | 1584.89 ± 14.1% | not timed | not timed | 13492.99 ± 0.5% | | 1.00 | 0.78 | 8.54 |
| 01-literal/sherlock-casei-ru | 746 | 5983.32 ± 0.1% | not timed | not timed | 3331.44 ± 0.1% | 31.55 ± 0.6% | not timed | not timed | 5986.52 ± 0.2% | | 1.00 | 1.80 | 189.66 |
| 01-literal/sherlock-zh | 30 | 17187.57 ± 1.0% | not timed | not timed | 18832.65 ± 0.8% | 2841.11 ± 5.1% | not timed | not timed | 17173.26 ± 0.3% | | 1.00 | 0.91 | 6.05 |
| 02-literal-alternate/sherlock-en | 714 | 5771.69 ± 0.2% | not timed | not timed | 3939.09 ± 0.1% | 16.65 ± 0.1% | not timed | not timed | 5768.82 ± 0.2% | | 1.00 | 1.47 | 346.61 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1801.68 ± 0.9% | not timed | not timed | 695.89 ± 0.4% | 10.99 ± 0.3% | not timed | not timed | 1793.83 ± 0.3% | | 1.00 | 2.59 | 163.90 |
| 02-literal-alternate/sherlock-ru | 899 | 5343.08 ± 0.1% | not timed | not timed | 3266.57 ± 0.1% | 22.69 ± 0.1% | not timed | not timed | 5342.71 ± 0.2% | | 1.00 | 1.64 | 235.47 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1917.09 ± 0.3% | not timed | not timed | 1233.34 ± 0.1% | 9.15 ± 0.2% | not timed | not timed | 1912.74 ± 0.3% | | 1.00 | 1.55 | 209.57 |
| 02-literal-alternate/sherlock-zh | 207 | 7055.51 ± 0.5% | not timed | not timed | 4161.82 ± 0.2% | 31.35 ± 0.1% | not timed | not timed | 7049.70 ± 0.7% | | 1.00 | 1.70 | 225.07 |
| 03-date/ascii | 111817 | 126.22 ± 0.2% | not timed | not timed | 96.26 ± 0.1% | 0.21 ± 5.8% | not timed | not timed | 125.40 ± 0.8% | | 1.01 | 1.31 | 611.94 |
| 04-ruff-noqa/real | 84 | 409.32 ± 0.1% | not timed | not timed | 478.98 ± 0.2% | 19.53 ± 1.2% | not timed | not timed | 408.12 ± 0.1% | | 1.00 | 0.85 | 20.96 |
| 04-ruff-noqa/tweaked | 44 | 550.05 ± 0.3% | not timed | not timed | 462.27 ± 0.1% | 366.01 ± 0.7% | not timed | not timed | 549.67 ± 0.3% | | 1.00 | 1.19 | 1.50 |
| 05-lexer-veryl/single | 124800 | 5.34 ± 0.9% | not timed | not timed | 5.19 ± 0.2% | 0.21 ± 2.2% | not timed | not timed | 5.36 ± 0.9% | | 1.00 | 1.03 | 25.97 |
| 06-cloud-flare-redos/original | 107 | 415.44 ± 0.1% | not timed | not timed | 217.00 ± 0.0% | 24.88 ± 0.1% | not timed | not timed | 414.15 ± 0.4% | | 1.00 | 1.91 | 16.69 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.08 ± 0.1% | not timed | not timed | 228.43 ± 0.2% | 26.75 ± 0.4% | not timed | not timed | 410.69 ± 0.3% | | 1.00 | 1.80 | 15.33 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.28 ± 0.1% | not timed | not timed | 255.68 ± 0.3% | 28.77 ± 0.2% | not timed | not timed | 586.77 ± 0.1% | | 1.00 | 2.30 | 20.41 |
| 07-unicode-character-data/parse-line | 558784 | 230.94 ± 3.0% | not timed | not timed | 178.32 ± 0.1% | 43.31 ± 5.5% | not timed | not timed | 231.85 ± 2.0% | | 1.00 | 1.30 | 5.33 |
| 08-words/all-english | 56691 | 116.97 ± 0.5% | not timed | not timed | 82.58 ± 0.2% | 12.64 ± 12.5% | not timed | not timed | 116.64 ± 0.3% | | 1.00 | 1.42 | 9.25 |
| 08-words/long-english | 839 | 620.32 ± 0.2% | not timed | not timed | 597.49 ± 0.0% | 32.20 ± 0.5% | not timed | not timed | 620.60 ± 0.2% | | 1.00 | 1.04 | 19.26 |
| 09-aws-keys/full | 0 | 415.48 ± 0.1% | not timed | not timed | 495.76 ± 0.1% | 64.75 ± 3.5% | not timed | not timed | 414.64 ± 0.1% | | 1.00 | 0.84 | 6.42 |
| 09-aws-keys/quick | 0 | 732.49 ± 0.1% | not timed | not timed | 1000.12 ± 0.3% | 424.55 ± 1.4% | not timed | not timed | 729.68 ± 0.1% | | 1.00 | 0.73 | 1.73 |
| 10-bounded-repeat/letters-en | 1833 | 584.75 ± 1.7% | not timed | not timed | 517.98 ± 0.3% | 19.49 ± 0.5% | not timed | not timed | 581.49 ± 2.5% | | 1.01 | 1.13 | 30.00 |
| 10-bounded-repeat/letters-ru | 3475 | 509.77 ± 1.1% | not timed | not timed | 478.44 ± 0.1% | 22.19 ± 13.7% | not timed | not timed | 507.22 ± 1.3% | | 1.01 | 1.07 | 22.98 |
| 10-bounded-repeat/context | 53 | 77.68 ± 0.5% | not timed | not timed | 66.05 ± 0.5% | 19.78 ± 0.3% | not timed | not timed | 77.44 ± 0.8% | | 1.00 | 1.18 | 3.93 |
| 10-bounded-repeat/capitals | 11 | 631.97 ± 8.2% | not timed | not timed | 618.81 ± 0.0% | 36.60 ± 1.0% | not timed | not timed | 630.60 ± 8.6% | | 1.00 | 1.02 | 17.27 |
| 11-unstructured-to-json/extract | 600 | 79.42 ± 0.3% | not timed | not timed | 76.89 ± 0.2% | 49.31 ± 0.2% | not timed | not timed | 81.08 ± 0.2% | | 0.98 | 1.03 | 1.61 |
| 12-dictionary/single | 1 | 559.94 ± 0.7% | not timed | not timed | 561.89 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 560.70 ± 0.1% | | 1.00 | 1.00 | 1394.64 |
| 14-quadratic/1x | 100 | 21.56 ± 2.3% | not timed | not timed | 9.92 ± 0.1% | 0.97 ± 3.2% | not timed | not timed | 21.47 ± 0.6% | | 1.00 | 2.17 | 22.12 |
| 14-quadratic/2x | 200 | 17.69 ± 3.1% | not timed | not timed | 5.52 ± 0.2% | 0.53 ± 0.5% | not timed | not timed | 17.62 ± 0.6% | | 1.00 | 3.20 | 33.18 |
| 14-quadratic/10x | 1000 | 7.71 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.9% | not timed | not timed | 7.67 ± 0.5% | | 1.01 | 6.35 | 66.76 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.30 ± 0.1% | not timed | not timed | 0.35 ± 0.4% | 0.56 ± 1.3% | not timed | not timed | 1.29 ± 0.3% | | 1.00 | 3.72 | 2.33 |
| 04-ruff-noqa/compile-real | 1 | 91.11 ± 0.2% | not timed | not timed | 13.70 ± 0.2% | 142.12 ± 2.6% | not timed | not timed | 91.09 ± 0.3% | | 1.00 | 6.65 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 13.97 ± 0.3% | not timed | not timed | 2.53 ± 0.7% | 6.50 ± 1.4% | not timed | not timed | 13.88 ± 1.3% | | 1.01 | 5.51 | 2.15 |
| 07-unicode-character-data/compile | 1 | 55.53 ± 0.1% | not timed | not timed | 26.00 ± 0.3% | 36.73 ± 2.6% | not timed | not timed | 54.76 ± 1.0% | | 1.01 | 2.14 | 1.51 |
| 09-aws-keys/compile-full | 1 | 42.21 ± 0.1% | not timed | not timed | 8.27 ± 0.4% | 23.71 ± 0.9% | not timed | not timed | 41.92 ± 0.4% | | 1.01 | 5.11 | 1.78 |
| 09-aws-keys/compile-quick | 1 | 181.87 ± 0.2% | not timed | not timed | 46.88 ± 0.1% | 135.81 ± 2.4% | not timed | not timed | 181.05 ± 0.7% | | 1.00 | 3.88 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 13.88 ± 0.9% | not timed | not timed | 11.07 ± 0.4% | 16.48 ± 2.1% | not timed | not timed | 13.81 ± 0.7% | | 1.00 | 1.25 | 0.84 |
| 10-bounded-repeat/compile-capitals | 1 | 82.66 ± 0.4% | not timed | not timed | 7.99 ± 0.2% | 24.13 ± 1.8% | not timed | not timed | 81.50 ± 2.1% | | 1.01 | 10.35 | 3.43 |
| 11-unstructured-to-json/compile | 1 | 86.59 ± 0.2% | not timed | not timed | 40.93 ± 0.6% | 69.02 ± 3.7% | not timed | not timed | 86.19 ± 0.2% | | 1.00 | 2.12 | 1.25 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 12.2% | 0.10 ± 13.0% | not timed | not timed | 0.34 ± 1.9% | | 1.01 | 4.90 | 3.35 |

