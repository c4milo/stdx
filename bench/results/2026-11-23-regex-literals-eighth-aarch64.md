# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243499820 |
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
| literal: a word | 217 | 19414.99 ± 3.1% | 4987.59 ± 0.3% | 27.75 ± 0.2% | 18332.68 ± 2.7% | 9219.00 ± 8.1% | 17.60 ± 0.1% | 84.30 ± 0.5% | 19441.33 ± 2.5% | 3.89 | 1.00 | 1.06 | 2.11 |
| literal: a word that is not there | 0 | 21626.01 ± 2.4% | 4876.72 ± 0.4% | 27.83 ± 0.2% | 19883.37 ± 2.1% | 29068.80 ± 2.4% | 17.42 ± 0.3% | 79.81 ± 0.4% | 21771.87 ± 1.4% | 4.43 | 0.99 | 1.09 | 0.74 |
| literal: one of four words | 661 | 6377.78 ± 0.3% | 1933.80 ± 0.3% | 14.26 ± 0.1% | 3944.66 ± 0.3% | 21.88 ± 0.1% | 5.31 ± 0.1% | 6.83 ± 0.8% | 6358.95 ± 0.3% | 3.30 | 1.00 | 1.62 | 291.50 |
| literal: a word in any case | 217 | 15178.19 ± 1.1% | 2074.10 ± 0.2% | 21.08 ± 0.1% | 3968.73 ± 0.4% | 38.06 ± 1.1% | refused | differs | 15085.34 ± 0.6% | 7.32 | 1.01 | 3.82 | 398.77 |
| literal: an href attribute | 33 | 16643.54 ± 1.5% | 607.83 ± 0.3% | 26.67 ± 0.3% | 16805.30 ± 2.4% | 2252.68 ± 0.5% | 13.12 ± 0.8% | 73.92 ± 0.3% | 16685.23 ± 2.1% | 27.38 | 1.00 | 0.99 | 7.39 |
| literal: a word, second text | 123 | 19392.72 ± 2.5% | 3354.82 ± 0.2% | 27.39 ± 0.2% | 18028.97 ± 1.9% | 7726.68 ± 5.7% | 19.55 ± 0.4% | 70.16 ± 0.3% | 19463.23 ± 3.2% | 5.78 | 1.00 | 1.08 | 2.51 |
| class: two capitalized words | 1331 | 1057.63 ± 0.4% | 598.30 ± 0.2% | 25.40 ± 0.1% | 582.45 ± 0.0% | 40.56 ± 12.7% | 15.06 ± 0.3% | 67.11 ± 0.8% | 1056.74 ± 0.4% | 1.77 | 1.00 | 1.82 | 26.07 |
| class: a word that ends in ing | 3399 | 572.74 ± 0.2% | 572.34 ± 0.2% | 17.73 ± 0.2% | 545.60 ± 0.1% | 29.60 ± 3.1% | 8.22 ± 0.3% | 18.25 ± 0.3% | 572.29 ± 0.3% | 1.00 | 1.00 | 1.05 | 19.35 |
| class: a word in capitals | 2332 | 1369.42 ± 0.6% | 601.88 ± 0.2% | 27.01 ± 0.2% | 572.31 ± 0.1% | 43.53 ± 16.3% | 17.27 ± 0.4% | 82.61 ± 0.6% | 1370.83 ± 0.2% | 2.28 | 1.00 | 2.39 | 31.46 |
| class: a number | 8288 | 1953.24 ± 0.8% | 826.80 ± 1.0% | 27.17 ± 0.2% | 1709.22 ± 0.3% | 43.26 ± 17.4% | 0.57 ± 0.2% | 57.55 ± 0.2% | 1951.01 ± 0.9% | 2.36 | 1.00 | 1.14 | 45.15 |
| class: two capitalized words, second text | 5359 | 515.31 ± 0.3% | 523.14 ± 0.2% | 22.81 ± 0.2% | 485.78 ± 0.2% | 35.40 ± 15.4% | 16.90 ± 0.5% | 62.42 ± 1.0% | 514.96 ± 0.4% | 0.99 | 1.00 | 1.06 | 14.56 |
| other: a word between two words | 6104 | 795.72 ± 0.2% | 594.12 ± 0.1% | 23.09 ± 0.3% | 735.68 ± 0.2% | 106.37 ± 10.9% | 11.48 ± 0.1% | 68.12 ± 1.5% | 796.22 ± 0.2% | 1.34 | 1.00 | 1.08 | 7.48 |
| other: a number before a unit, second text | 1481 | 5946.06 ± 1.1% | 1120.13 ± 0.4% | 25.49 ± 0.3% | 5638.12 ± 0.7% | 40.78 ± 11.6% | 17.96 ± 0.2% | 65.55 ± 0.2% | 5883.33 ± 0.4% | 5.31 | 1.01 | 1.05 | 145.81 |
| other: a heading's start tag | 110 | 14075.97 ± 1.9% | 741.94 ± 0.1% | 26.86 ± 0.1% | 1717.62 ± 0.5% | 1586.52 ± 1.4% | 16.37 ± 1.0% | 86.04 ± 0.3% | 13948.51 ± 2.2% | 18.97 | 1.01 | 8.20 | 8.87 |
| other: a whole word | 217 | 15926.76 ± 1.4% | 600.26 ± 0.5% | 28.69 ± 0.1% | 14425.80 ± 1.9% | 49.32 ± 9.9% | 13.88 ± 0.3% | 54.61 ± 0.9% | 15780.86 ± 1.4% | 26.53 | 1.01 | 1.10 | 322.91 |
| other: a line's first word, second text | 3716 | 2036.12 ± 0.4% | 587.54 ± 0.3% | 29.99 ± 0.4% | 1730.98 ± 0.5% | 62.87 ± 5.1% | refused | refused | 2032.97 ± 0.7% | 3.47 | 1.00 | 1.18 | 32.39 |
| other: fourteen octets before an x | 87 | 23999.15 ± 2.5% | 238.73 ± 0.3% | 6.52 ± 0.1% | 3958.65 ± 0.5% | 10.63 ± 0.2% | differs | 17.67 ± 0.2% | 23630.43 ± 1.4% | 100.53 | 1.02 | 6.06 | 2257.28 |
| other: a Greek word | 21815 | 487.29 ± 0.7% | 409.19 ± 0.2% | 30.45 ± 0.5% | 289.19 ± 0.1% | 49.03 ± 8.9% | differs | refused | 485.79 ± 0.6% | 1.19 | 1.00 | 1.69 | 9.94 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.45 ± 0.1% | 18.45 ± 0.2% | 0.86 ± 0.3% | 19.49 ± 0.3% | 2.78 ± 0.9% | differs | 3.98 ± 0.1% | 18.45 ± 0.3% | 1.00 | 1.00 | 0.95 | 6.64 |
| a UUID | 32895 | 20.11 ± 0.2% | 20.08 ± 0.2% | 0.64 ± 0.2% | 15.07 ± 0.6% | 3.10 ± 0.2% | 0.72 ± 0.5% | 3.63 ± 0.5% | 20.11 ± 0.2% | 1.00 | 1.00 | 1.33 | 6.48 |
| an IPv4 address | 33176 | 33.53 ± 0.1% | 33.61 ± 0.1% | 2.07 ± 0.3% | 28.96 ± 0.8% | 6.61 ± 0.2% | differs | 4.14 ± 0.2% | 33.63 ± 0.4% | 1.00 | 1.00 | 1.16 | 5.07 |
| a date and time | 32954 | 28.66 ± 0.3% | 28.84 ± 0.3% | 1.44 ± 0.2% | 21.32 ± 0.1% | 7.05 ± 0.3% | 1.19 ± 0.2% | 7.13 ± 0.5% | 28.81 ± 0.3% | 0.99 | 0.99 | 1.34 | 4.06 |
| a field path | 32606 | 21.75 ± 0.2% | 21.77 ± 0.1% | 1.02 ± 0.4% | 23.08 ± 0.3% | 3.49 ± 0.8% | differs | 2.92 ± 0.1% | 21.80 ± 0.3% | 1.00 | 1.00 | 0.94 | 6.23 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.06 ± 0.2% | 11.09 ± 0.2% | 11.07 ± 0.2% | 11.52 ± 0.1% | 4.92 ± 1.9% | 0.91 ± 0.7% | none | 11.09 ± 0.2% | 1.00 | 1.00 | 0.96 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 219.80 ± 0.4% | 220.62 ± 0.5% | 262.28 ± 0.2% | 87.33 ± 0.4% | 216.69 ± 1.1% | 477.99 ± 0.7% | 3799.68 ± 0.5% | 219.81 ± 0.5% | 1.00 | 1.00 | 2.52 | 1.01 |
| a UUID | 62 | 142.62 ± 0.2% | 142.85 ± 0.3% | 159.78 ± 0.3% | 46.44 ± 0.3% | 95.97 ± 1.5% | 181.91 ± 2.1% | 4270.60 ± 0.3% | 142.51 ± 0.2% | 1.00 | 1.00 | 3.07 | 1.49 |
| an IPv4 address | 29 | 406.53 ± 1.6% | 409.92 ± 0.8% | 583.87 ± 0.9% | 77.15 ± 0.6% | 128.05 ± 1.7% | 290.44 ± 0.5% | 7552.17 ± 0.3% | 406.57 ± 0.8% | 0.99 | 1.00 | 5.27 | 3.17 |
| a date and time | 56 | 293.44 ± 0.3% | 295.40 ± 0.1% | 373.02 ± 0.1% | 73.25 ± 0.6% | 133.64 ± 2.1% | 314.41 ± 1.6% | 4922.21 ± 0.7% | 293.41 ± 0.3% | 0.99 | 1.00 | 4.01 | 2.20 |
| a field path | 39 | 212.04 ± 0.6% | 212.45 ± 0.4% | 250.10 ± 0.5% | 80.92 ± 0.5% | 201.36 ± 1.8% | 499.67 ± 2.1% | 4825.95 ± 3.1% | 211.82 ± 0.4% | 1.00 | 1.00 | 2.62 | 1.05 |
| literal: a word | 7 | 599.75 ± 0.6% | 651.90 ± 0.4% | 1181.71 ± 0.5% | 519.96 ± 0.1% | 618.30 ± 2.1% | 941.28 ± 0.4% | 29752.37 ± 0.4% | 599.48 ± 0.6% | 0.92 | 1.00 | 1.15 | 0.97 |
| literal: a word that is not there | 8 | 584.13 ± 1.0% | 635.94 ± 0.4% | 1122.26 ± 0.4% | 469.84 ± 0.3% | 596.75 ± 1.7% | 891.80 ± 0.5% | 28555.61 ± 0.1% | 584.97 ± 0.4% | 0.92 | 1.00 | 1.24 | 0.98 |
| literal: one of four words | 26 | 236.61 ± 0.2% | 391.44 ± 0.7% | 538.53 ± 0.8% | 49.27 ± 0.6% | 236.41 ± 2.2% | 362.39 ± 2.3% | 15701.25 ± 0.3% | 236.62 ± 0.3% | 0.60 | 1.00 | 4.80 | 1.00 |
| literal: a word in any case | 11 | 431.69 ± 0.3% | 461.73 ± 0.1% | 683.27 ± 0.4% | 15.74 ± 0.3% | 641.53 ± 1.9% | refused | 23325.58 ± 0.7% | 430.81 ± 0.6% | 0.93 | 1.00 | 27.42 | 0.67 |
| literal: an href attribute | 12 | 330.75 ± 0.5% | 343.33 ± 0.4% | 455.58 ± 0.3% | 45.85 ± 0.8% | 492.70 ± 1.4% | 776.91 ± 0.8% | 21253.72 ± 0.5% | 331.07 ± 0.3% | 0.96 | 1.00 | 7.21 | 0.67 |
| literal: a word, second text | 10 | 539.06 ± 0.2% | 595.28 ± 0.5% | 1010.32 ± 0.4% | 422.18 ± 0.3% | 527.27 ± 1.2% | 804.97 ± 1.0% | 26401.70 ± 0.2% | 538.64 ± 0.3% | 0.91 | 1.00 | 1.28 | 1.02 |
| class: two capitalized words | 23 | 415.49 ± 0.3% | 449.10 ± 0.2% | 660.32 ± 0.2% | 100.86 ± 0.3% | 498.37 ± 2.7% | 740.50 ± 0.5% | 6443.23 ± 0.5% | 415.44 ± 0.4% | 0.93 | 1.00 | 4.12 | 0.83 |
| class: a word that ends in ing | 9 | 535.39 ± 0.3% | 606.14 ± 0.4% | 1081.64 ± 0.4% | 132.53 ± 1.3% | 750.67 ± 1.1% | 1100.98 ± 2.1% | 15768.77 ± 0.1% | 534.72 ± 0.5% | 0.88 | 1.00 | 4.04 | 0.71 |
| class: a word in capitals | 16 | 469.01 ± 0.2% | 514.86 ± 0.3% | 852.13 ± 0.1% | 136.25 ± 0.5% | 745.55 ± 1.0% | 1014.88 ± 0.4% | 8488.66 ± 0.3% | 468.68 ± 0.2% | 0.91 | 1.00 | 3.44 | 0.63 |
| class: a number | 6 | 597.45 ± 0.2% | 670.63 ± 0.6% | 1323.62 ± 0.1% | 41.93 ± 0.7% | 1391.31 ± 1.4% | 1916.06 ± 1.1% | 22279.79 ± 0.2% | 597.72 ± 0.2% | 0.89 | 1.00 | 14.25 | 0.43 |
| class: two capitalized words, second text | 23 | 415.76 ± 0.3% | 449.66 ± 0.3% | 659.63 ± 0.2% | 104.00 ± 0.6% | 492.35 ± 2.0% | 727.66 ± 0.4% | 6439.23 ± 0.5% | 415.82 ± 0.2% | 0.92 | 1.00 | 4.00 | 0.84 |
| other: a word between two words | 13 | 523.53 ± 0.6% | 544.18 ± 0.4% | 887.89 ± 0.3% | 135.62 ± 1.1% | 499.52 ± 1.1% | 810.55 ± 1.7% | 14656.89 ± 0.3% | 523.00 ± 0.5% | 0.96 | 1.00 | 3.86 | 1.05 |
| other: a number before a unit, second text | 15 | 377.92 ± 0.3% | 418.03 ± 0.4% | 589.32 ± 0.4% | 39.45 ± 0.4% | 626.90 ± 1.3% | 888.25 ± 0.7% | 14931.55 ± 0.3% | 378.00 ± 0.3% | 0.90 | 1.00 | 9.58 | 0.60 |
| other: a heading's start tag | 13 | 339.99 ± 1.1% | 347.49 ± 0.8% | 463.85 ± 1.2% | 44.70 ± 0.2% | 622.93 ± 0.8% | 861.97 ± 0.3% | 17650.68 ± 0.3% | 340.05 ± 1.0% | 0.98 | 1.00 | 7.61 | 0.55 |
| other: a whole word | 11 | 555.99 ± 0.7% | 592.21 ± 0.4% | 1001.81 ± 0.7% | 121.98 ± 0.8% | 558.29 ± 2.0% | 814.30 ± 1.2% | 26622.36 ± 0.3% | 555.03 ± 0.9% | 0.94 | 1.00 | 4.56 | 1.00 |
| other: a line's first word, second text | 17 | 514.61 ± 0.6% | 538.44 ± 0.1% | 880.34 ± 0.4% | 130.32 ± 0.1% | 703.57 ± 1.5% | refused | refused | 513.59 ± 0.9% | 0.96 | 1.00 | 3.95 | 0.73 |
| other: fourteen octets before an x | 16 | 105.46 ± 0.3% | 150.79 ± 1.0% | 174.52 ± 1.0% | 15.20 ± 0.4% | 446.63 ± 2.0% | 404.72 ± 0.6% | 12651.98 ± 0.3% | 105.27 ± 0.4% | 0.70 | 1.00 | 6.94 | 0.24 |
| other: a Greek word | 8 | 411.97 ± 0.5% | 567.75 ± 0.5% | 986.58 ± 0.2% | 59.33 ± 0.6% | 1377.60 ± 8.3% | 1833.94 ± 0.6% | refused | 411.98 ± 0.1% | 0.73 | 1.00 | 6.94 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15436.46 ± 0.7% | not timed | not timed | 16065.61 ± 0.9% | 1964.52 ± 13.4% | not timed | not timed | 15391.27 ± 0.7% | | 1.00 | 0.96 | 7.86 |
| 01-literal/sherlock-casei-en | 522 | 5151.46 ± 1.0% | not timed | not timed | 3584.92 ± 2.2% | 32.49 ± 0.4% | not timed | not timed | 5115.40 ± 0.5% | | 1.01 | 1.44 | 158.54 |
| 01-literal/sherlock-ru | 724 | 17047.30 ± 0.8% | not timed | not timed | 17210.23 ± 0.6% | 1381.62 ± 8.6% | not timed | not timed | 17044.06 ± 1.2% | | 1.00 | 0.99 | 12.34 |
| 01-literal/sherlock-casei-ru | 746 | 6170.47 ± 0.3% | not timed | not timed | 3322.82 ± 0.2% | 30.95 ± 0.3% | not timed | not timed | 6161.60 ± 0.1% | | 1.00 | 1.86 | 199.39 |
| 01-literal/sherlock-zh | 30 | 19201.92 ± 0.7% | not timed | not timed | 18221.74 ± 1.0% | 2545.08 ± 10.3% | not timed | not timed | 19180.07 ± 0.7% | | 1.00 | 1.05 | 7.54 |
| 02-literal-alternate/sherlock-en | 714 | 6017.15 ± 0.6% | not timed | not timed | 3936.44 ± 0.2% | 16.44 ± 0.3% | not timed | not timed | 6030.42 ± 0.5% | | 1.00 | 1.53 | 366.00 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1926.92 ± 1.4% | not timed | not timed | 693.84 ± 0.2% | 11.13 ± 0.1% | not timed | not timed | 1906.41 ± 0.5% | | 1.01 | 2.78 | 173.20 |
| 02-literal-alternate/sherlock-ru | 899 | 5557.35 ± 0.1% | not timed | not timed | 3253.42 ± 0.2% | 22.60 ± 0.3% | not timed | not timed | 5547.07 ± 0.2% | | 1.00 | 1.71 | 245.91 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2057.30 ± 0.6% | not timed | not timed | 1231.54 ± 0.5% | 9.07 ± 5.1% | not timed | not timed | 2046.67 ± 0.5% | | 1.01 | 1.67 | 226.77 |
| 02-literal-alternate/sherlock-zh | 207 | 7241.54 ± 0.9% | not timed | not timed | 4150.57 ± 0.2% | 31.50 ± 0.1% | not timed | not timed | 7227.59 ± 0.7% | | 1.00 | 1.74 | 229.92 |
| 03-date/ascii | 111817 | 123.95 ± 0.6% | not timed | not timed | 96.08 ± 0.1% | 0.20 ± 0.3% | not timed | not timed | 119.95 ± 0.8% | | 1.03 | 1.29 | 612.04 |
| 04-ruff-noqa/real | 84 | 401.80 ± 0.1% | not timed | not timed | 462.60 ± 0.2% | 19.66 ± 1.2% | not timed | not timed | 399.10 ± 0.2% | | 1.01 | 0.87 | 20.44 |
| 04-ruff-noqa/tweaked | 44 | 561.18 ± 0.3% | not timed | not timed | 458.61 ± 0.2% | 366.14 ± 0.1% | not timed | not timed | 560.86 ± 0.3% | | 1.00 | 1.22 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.08 ± 0.6% | not timed | not timed | 5.08 ± 0.2% | 0.20 ± 3.3% | not timed | not timed | 5.04 ± 0.7% | | 1.01 | 1.00 | 24.92 |
| 06-cloud-flare-redos/original | 107 | 414.43 ± 0.4% | not timed | not timed | 215.02 ± 0.2% | 24.95 ± 0.5% | not timed | not timed | 409.51 ± 0.5% | | 1.01 | 1.93 | 16.61 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.97 ± 0.4% | not timed | not timed | 226.85 ± 0.2% | 26.56 ± 0.3% | not timed | not timed | 408.52 ± 0.3% | | 1.01 | 1.81 | 15.47 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.58 ± 0.1% | not timed | not timed | 253.61 ± 0.4% | 28.78 ± 0.1% | not timed | not timed | 582.76 ± 0.2% | | 1.00 | 2.30 | 20.28 |
| 07-unicode-character-data/parse-line | 558784 | 235.24 ± 0.3% | not timed | not timed | 171.70 ± 0.1% | 42.43 ± 2.0% | not timed | not timed | 235.33 ± 0.7% | | 1.00 | 1.37 | 5.54 |
| 08-words/all-english | 56691 | 116.46 ± 0.5% | not timed | not timed | 83.41 ± 0.0% | 11.79 ± 4.3% | not timed | not timed | 113.38 ± 0.8% | | 1.03 | 1.40 | 9.87 |
| 08-words/long-english | 839 | 613.25 ± 0.2% | not timed | not timed | 597.37 ± 0.1% | 32.64 ± 0.2% | not timed | not timed | 612.53 ± 0.6% | | 1.00 | 1.03 | 18.79 |
| 09-aws-keys/full | 0 | 407.99 ± 1.4% | not timed | not timed | 461.15 ± 0.5% | 64.33 ± 3.5% | not timed | not timed | 405.37 ± 0.1% | | 1.01 | 0.88 | 6.34 |
| 09-aws-keys/quick | 0 | 942.42 ± 0.2% | not timed | not timed | 991.11 ± 0.2% | 415.40 ± 2.3% | not timed | not timed | 941.35 ± 0.1% | | 1.00 | 0.95 | 2.27 |
| 10-bounded-repeat/letters-en | 1833 | 546.14 ± 1.9% | not timed | not timed | 518.16 ± 0.2% | 19.57 ± 0.7% | not timed | not timed | 579.80 ± 1.6% | | 0.94 | 1.05 | 27.90 |
| 10-bounded-repeat/letters-ru | 3475 | 509.76 ± 0.8% | not timed | not timed | 477.77 ± 0.1% | 21.87 ± 18.6% | not timed | not timed | 507.63 ± 2.7% | | 1.00 | 1.07 | 23.31 |
| 10-bounded-repeat/context | 53 | 77.11 ± 0.4% | not timed | not timed | 65.55 ± 0.6% | 19.78 ± 0.2% | not timed | not timed | 77.00 ± 0.5% | | 1.00 | 1.18 | 3.90 |
| 10-bounded-repeat/capitals | 11 | 635.33 ± 8.3% | not timed | not timed | 618.45 ± 0.1% | 36.54 ± 0.1% | not timed | not timed | 634.30 ± 8.2% | | 1.00 | 1.03 | 17.39 |
| 11-unstructured-to-json/extract | 600 | 82.78 ± 1.0% | not timed | not timed | 77.55 ± 0.4% | 49.09 ± 0.8% | not timed | not timed | 82.35 ± 0.3% | | 1.01 | 1.07 | 1.69 |
| 12-dictionary/single | 1 | 559.30 ± 0.5% | not timed | not timed | 558.68 ± 0.2% | 0.40 ± 0.2% | not timed | not timed | 560.07 ± 0.1% | | 1.00 | 1.00 | 1388.96 |
| 14-quadratic/1x | 100 | 21.27 ± 0.6% | not timed | not timed | 10.01 ± 0.2% | 0.97 ± 2.1% | not timed | not timed | 21.17 ± 1.3% | | 1.00 | 2.12 | 21.91 |
| 14-quadratic/2x | 200 | 17.47 ± 0.7% | not timed | not timed | 5.54 ± 0.2% | 0.53 ± 1.9% | not timed | not timed | 17.47 ± 0.9% | | 1.00 | 3.15 | 32.79 |
| 14-quadratic/10x | 1000 | 7.68 ± 0.4% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 7.68 ± 0.3% | | 1.00 | 6.34 | 66.43 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 0.3% | not timed | not timed | 0.34 ± 0.5% | 0.54 ± 3.9% | not timed | not timed | 1.25 ± 1.9% | | 1.01 | 3.69 | 2.34 |
| 04-ruff-noqa/compile-real | 1 | 88.18 ± 0.2% | not timed | not timed | 13.76 ± 0.3% | 135.24 ± 3.4% | not timed | not timed | 87.94 ± 1.0% | | 1.00 | 6.41 | 0.65 |
| 05-lexer-veryl/compile-single | 1 | 13.89 ± 0.7% | not timed | not timed | 2.49 ± 1.1% | 5.65 ± 10.9% | not timed | not timed | 13.80 ± 1.6% | | 1.01 | 5.57 | 2.46 |
| 07-unicode-character-data/compile | 1 | 53.66 ± 0.1% | not timed | not timed | 25.97 ± 0.3% | 35.52 ± 18.9% | not timed | not timed | 53.29 ± 0.8% | | 1.01 | 2.07 | 1.51 |
| 09-aws-keys/compile-full | 1 | 40.88 ± 2.6% | not timed | not timed | 8.28 ± 0.4% | 23.00 ± 0.7% | not timed | not timed | 40.58 ± 0.7% | | 1.01 | 4.94 | 1.78 |
| 09-aws-keys/compile-quick | 1 | 179.05 ± 0.3% | not timed | not timed | 47.12 ± 0.1% | 131.82 ± 2.6% | not timed | not timed | 178.68 ± 1.4% | | 1.00 | 3.80 | 1.36 |
| 10-bounded-repeat/compile-context | 1 | 13.54 ± 1.9% | not timed | not timed | 11.08 ± 0.1% | 15.58 ± 8.0% | not timed | not timed | 13.46 ± 1.0% | | 1.01 | 1.22 | 0.87 |
| 10-bounded-repeat/compile-capitals | 1 | 80.83 ± 0.4% | not timed | not timed | 8.11 ± 0.2% | 23.29 ± 1.3% | not timed | not timed | 80.71 ± 1.4% | | 1.00 | 9.96 | 3.47 |
| 11-unstructured-to-json/compile | 1 | 83.80 ± 0.3% | not timed | not timed | 41.12 ± 0.2% | 67.59 ± 2.8% | not timed | not timed | 83.32 ± 0.8% | | 1.01 | 2.04 | 1.24 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.3% | not timed | not timed | 0.07 ± 0.5% | 0.09 ± 13.5% | not timed | not timed | 0.35 ± 1.6% | | 1.01 | 5.07 | 3.80 |

