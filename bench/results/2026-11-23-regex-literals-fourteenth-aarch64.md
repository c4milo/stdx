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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243538212 |
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
| literal: a word | 217 | 19498.41 ± 2.1% | 4988.36 ± 0.3% | 28.34 ± 0.1% | 18130.46 ± 2.8% | 9125.78 ± 7.6% | 17.44 ± 0.3% | 84.47 ± 0.2% | 19607.36 ± 3.5% | 3.91 | 0.99 | 1.08 | 2.14 |
| literal: a word that is not there | 0 | 21778.21 ± 1.6% | 4871.85 ± 0.4% | 28.38 ± 1.2% | 19904.87 ± 2.8% | 29143.07 ± 2.1% | 17.19 ± 0.2% | 79.68 ± 2.2% | 21926.38 ± 1.2% | 4.47 | 0.99 | 1.09 | 0.75 |
| literal: one of four words | 661 | 6373.10 ± 0.5% | 1932.26 ± 0.1% | 14.42 ± 0.1% | 3948.06 ± 0.2% | 21.86 ± 0.2% | 5.43 ± 0.4% | 6.74 ± 0.3% | 6350.94 ± 0.4% | 3.30 | 1.00 | 1.61 | 291.54 |
| literal: a word in any case | 217 | 15108.79 ± 1.2% | 2073.32 ± 0.2% | 21.43 ± 0.1% | 3969.86 ± 0.8% | 39.44 ± 2.3% | refused | differs | 15061.23 ± 0.5% | 7.29 | 1.00 | 3.81 | 383.04 |
| literal: an href attribute | 33 | 17202.81 ± 2.8% | 608.64 ± 0.8% | 27.37 ± 0.2% | 17154.26 ± 1.9% | 2264.38 ± 0.2% | 13.19 ± 0.1% | 73.96 ± 1.0% | 17200.71 ± 0.6% | 28.26 | 1.00 | 1.00 | 7.60 |
| literal: a word, second text | 123 | 19971.72 ± 1.1% | 3356.59 ± 0.3% | 28.04 ± 0.4% | 18464.65 ± 2.7% | 7508.53 ± 9.2% | 20.17 ± 0.6% | 70.40 ± 0.5% | 20056.22 ± 1.3% | 5.95 | 1.00 | 1.08 | 2.66 |
| class: two capitalized words | 1331 | 1056.57 ± 0.4% | 599.36 ± 0.2% | 26.05 ± 0.3% | 585.02 ± 0.1% | 40.64 ± 12.6% | 14.77 ± 0.2% | 67.28 ± 0.6% | 1055.58 ± 0.1% | 1.76 | 1.00 | 1.81 | 26.00 |
| class: a word that ends in ing | 3399 | 572.88 ± 0.3% | 572.59 ± 0.4% | 18.02 ± 0.1% | 547.15 ± 0.1% | 29.65 ± 9.5% | 8.21 ± 0.2% | 18.25 ± 0.2% | 571.60 ± 0.5% | 1.00 | 1.00 | 1.05 | 19.32 |
| class: a word in capitals | 2332 | 1370.46 ± 0.2% | 601.61 ± 0.5% | 27.70 ± 0.2% | 571.75 ± 0.7% | 43.55 ± 0.2% | 17.23 ± 0.3% | 82.66 ± 0.1% | 1369.79 ± 0.6% | 2.28 | 1.00 | 2.40 | 31.47 |
| class: a number | 8288 | 1959.40 ± 0.5% | 827.89 ± 0.1% | 27.88 ± 0.3% | 1689.56 ± 0.3% | 42.63 ± 16.4% | 0.55 ± 0.1% | 57.47 ± 1.0% | 1958.49 ± 0.2% | 2.37 | 1.00 | 1.16 | 45.97 |
| class: two capitalized words, second text | 5359 | 516.04 ± 0.3% | 523.93 ± 0.1% | 23.32 ± 0.3% | 484.18 ± 0.1% | 35.14 ± 7.2% | 17.12 ± 0.2% | 62.65 ± 0.5% | 515.47 ± 0.1% | 0.98 | 1.00 | 1.07 | 14.69 |
| other: a word between two words | 6104 | 789.96 ± 0.2% | 593.85 ± 0.3% | 23.57 ± 0.3% | 735.39 ± 0.2% | 107.96 ± 15.1% | 11.21 ± 0.2% | 68.43 ± 0.3% | 790.64 ± 0.1% | 1.33 | 1.00 | 1.07 | 7.32 |
| other: a number before a unit, second text | 1481 | 5998.47 ± 1.2% | 1122.06 ± 0.2% | 26.12 ± 0.3% | 5698.08 ± 0.7% | 40.75 ± 15.5% | 18.23 ± 0.2% | 65.78 ± 0.2% | 5946.92 ± 0.4% | 5.35 | 1.01 | 1.05 | 147.22 |
| other: a heading's start tag | 110 | 14258.47 ± 1.3% | 742.73 ± 0.3% | 27.48 ± 0.2% | 1710.10 ± 0.1% | 1584.57 ± 5.3% | 16.17 ± 0.6% | 86.07 ± 0.8% | 14253.36 ± 0.2% | 19.20 | 1.00 | 8.34 | 9.00 |
| other: a whole word | 217 | 15942.79 ± 0.9% | 598.57 ± 1.1% | 29.46 ± 0.5% | 14449.91 ± 0.8% | 49.35 ± 0.6% | 13.39 ± 0.1% | 55.03 ± 0.6% | 15881.13 ± 0.7% | 26.63 | 1.00 | 1.10 | 323.08 |
| other: a line's first word, second text | 3716 | 2047.77 ± 0.7% | 587.53 ± 0.2% | 31.04 ± 0.5% | 1724.62 ± 0.5% | 61.91 ± 8.0% | refused | refused | 2041.03 ± 0.4% | 3.49 | 1.00 | 1.19 | 33.07 |
| other: fourteen octets before an x | 87 | 24081.47 ± 1.6% | 250.67 ± 0.3% | 6.56 ± 0.0% | 4020.17 ± 0.4% | 10.65 ± 0.1% | differs | 17.74 ± 0.3% | 24026.12 ± 0.8% | 96.07 | 1.00 | 5.99 | 2260.33 |
| other: a Greek word | 21815 | 484.35 ± 0.3% | 407.89 ± 0.1% | 30.90 ± 0.2% | 288.29 ± 0.1% | 43.81 ± 10.3% | differs | refused | 483.94 ± 0.3% | 1.19 | 1.00 | 1.68 | 11.05 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.44 ± 0.2% | 18.49 ± 0.3% | 0.86 ± 0.4% | 19.82 ± 0.5% | 2.76 ± 0.5% | differs | 3.96 ± 0.0% | 18.49 ± 0.2% | 1.00 | 1.00 | 0.93 | 6.69 |
| a UUID | 32895 | 20.10 ± 0.2% | 20.09 ± 0.2% | 0.64 ± 0.1% | 15.13 ± 0.5% | 3.08 ± 0.6% | 0.73 ± 0.2% | 3.65 ± 0.4% | 20.08 ± 0.0% | 1.00 | 1.00 | 1.33 | 6.52 |
| an IPv4 address | 33176 | 33.61 ± 0.2% | 33.16 ± 0.3% | 2.08 ± 0.6% | 29.38 ± 0.4% | 6.53 ± 0.4% | differs | 4.17 ± 0.2% | 33.54 ± 0.5% | 1.01 | 1.00 | 1.14 | 5.15 |
| a date and time | 32954 | 28.89 ± 0.3% | 28.82 ± 0.2% | 1.43 ± 0.1% | 21.36 ± 0.8% | 7.04 ± 0.2% | 1.26 ± 0.1% | 7.19 ± 0.7% | 28.87 ± 0.2% | 1.00 | 1.00 | 1.35 | 4.10 |
| a field path | 32606 | 21.76 ± 0.1% | 21.75 ± 0.2% | 1.02 ± 0.2% | 23.25 ± 0.3% | 3.46 ± 0.8% | differs | 2.94 ± 0.3% | 21.73 ± 0.1% | 1.00 | 1.00 | 0.94 | 6.29 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.09 ± 0.2% | 11.10 ± 0.3% | 11.07 ± 0.3% | 11.82 ± 0.2% | 4.98 ± 1.0% | 0.94 ± 0.4% | none | 11.12 ± 0.3% | 1.00 | 1.00 | 0.94 | 2.23 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 221.60 ± 0.1% | 222.50 ± 0.1% | 258.92 ± 0.2% | 86.15 ± 0.6% | 222.26 ± 1.3% | 482.34 ± 2.0% | 3825.65 ± 0.4% | 221.53 ± 0.2% | 1.00 | 1.00 | 2.57 | 1.00 |
| a UUID | 62 | 151.12 ± 0.2% | 151.45 ± 0.4% | 168.27 ± 0.1% | 46.26 ± 0.6% | 99.46 ± 0.9% | 189.91 ± 3.4% | 4294.93 ± 0.6% | 151.23 ± 0.2% | 1.00 | 1.00 | 3.27 | 1.52 |
| an IPv4 address | 29 | 429.41 ± 0.3% | 432.76 ± 0.6% | 597.13 ± 0.3% | 76.63 ± 0.3% | 132.94 ± 1.2% | 302.43 ± 1.4% | 7627.21 ± 0.3% | 429.19 ± 0.3% | 0.99 | 1.00 | 5.60 | 3.23 |
| a date and time | 56 | 282.68 ± 0.3% | 283.89 ± 0.2% | 346.41 ± 0.1% | 72.24 ± 0.6% | 138.42 ± 11.1% | 323.61 ± 0.9% | 4955.91 ± 0.3% | 282.36 ± 0.2% | 1.00 | 1.00 | 3.91 | 2.04 |
| a field path | 39 | 220.20 ± 0.2% | 221.46 ± 0.3% | 258.01 ± 0.3% | 80.30 ± 1.2% | 205.99 ± 1.0% | 499.77 ± 2.9% | 4857.46 ± 0.6% | 220.32 ± 0.4% | 0.99 | 1.00 | 2.74 | 1.07 |
| literal: a word | 7 | 644.26 ± 0.8% | 697.91 ± 1.0% | 1236.57 ± 0.3% | 512.70 ± 0.2% | 630.86 ± 1.8% | 957.55 ± 0.5% | 31124.46 ± 0.2% | 643.15 ± 0.6% | 0.92 | 1.00 | 1.26 | 1.02 |
| literal: a word that is not there | 8 | 616.66 ± 0.3% | 674.30 ± 0.4% | 1167.71 ± 0.2% | 471.41 ± 0.2% | 603.07 ± 1.9% | 907.14 ± 0.5% | 29533.67 ± 0.1% | 616.92 ± 0.3% | 0.91 | 1.00 | 1.31 | 1.02 |
| literal: one of four words | 26 | 248.20 ± 0.2% | 403.23 ± 0.2% | 540.23 ± 0.5% | 49.87 ± 1.2% | 244.65 ± 1.7% | 374.17 ± 1.1% | 16063.33 ± 0.3% | 248.24 ± 0.3% | 0.62 | 1.00 | 4.98 | 1.01 |
| literal: a word in any case | 11 | 451.34 ± 0.3% | 483.85 ± 0.4% | 698.81 ± 0.3% | 15.80 ± 1.5% | 652.92 ± 2.1% | refused | 23685.42 ± 0.2% | 451.01 ± 0.3% | 0.93 | 1.00 | 28.56 | 0.69 |
| literal: an href attribute | 12 | 348.71 ± 0.4% | 361.94 ± 0.5% | 470.21 ± 0.3% | 45.16 ± 0.5% | 503.47 ± 1.3% | 772.65 ± 0.9% | 22079.23 ± 0.3% | 348.46 ± 0.3% | 0.96 | 1.00 | 7.72 | 0.69 |
| literal: a word, second text | 10 | 573.10 ± 0.2% | 635.05 ± 0.4% | 1052.20 ± 0.1% | 394.98 ± 0.1% | 540.00 ± 1.5% | 799.05 ± 0.4% | 27436.34 ± 0.1% | 572.54 ± 0.2% | 0.90 | 1.00 | 1.45 | 1.06 |
| class: two capitalized words | 23 | 445.52 ± 0.2% | 475.48 ± 0.5% | 683.01 ± 0.1% | 98.72 ± 0.1% | 504.83 ± 4.2% | 740.65 ± 0.4% | 6495.79 ± 0.5% | 445.59 ± 0.7% | 0.94 | 1.00 | 4.51 | 0.88 |
| class: a word that ends in ing | 9 | 579.03 ± 0.3% | 648.45 ± 0.3% | 1127.08 ± 0.0% | 130.99 ± 1.7% | 760.47 ± 1.2% | 1099.83 ± 0.6% | 16046.47 ± 0.3% | 578.99 ± 0.3% | 0.89 | 1.00 | 4.42 | 0.76 |
| class: a word in capitals | 16 | 509.19 ± 0.9% | 549.35 ± 0.9% | 875.71 ± 0.2% | 134.15 ± 0.7% | 754.88 ± 1.7% | 1020.17 ± 0.7% | 8545.95 ± 0.7% | 508.53 ± 1.0% | 0.93 | 1.00 | 3.80 | 0.67 |
| class: a number | 6 | 645.53 ± 0.4% | 714.61 ± 0.6% | 1329.87 ± 0.1% | 41.62 ± 0.6% | 1402.65 ± 0.7% | 1856.83 ± 1.6% | 22838.08 ± 0.2% | 645.16 ± 0.2% | 0.90 | 1.00 | 15.51 | 0.46 |
| class: two capitalized words, second text | 23 | 445.02 ± 0.4% | 475.49 ± 0.3% | 683.07 ± 0.5% | 99.99 ± 0.3% | 505.52 ± 0.9% | 761.69 ± 0.4% | 6491.67 ± 0.5% | 445.80 ± 0.5% | 0.94 | 1.00 | 4.45 | 0.88 |
| other: a word between two words | 13 | 556.32 ± 0.8% | 580.15 ± 0.7% | 915.23 ± 0.9% | 132.33 ± 0.7% | 507.12 ± 1.4% | 810.01 ± 0.3% | 14887.07 ± 0.3% | 555.34 ± 0.8% | 0.96 | 1.00 | 4.20 | 1.10 |
| other: a number before a unit, second text | 15 | 407.36 ± 0.6% | 446.99 ± 0.5% | 623.44 ± 0.4% | 39.34 ± 0.4% | 639.50 ± 2.2% | 888.62 ± 1.1% | 15237.43 ± 0.4% | 406.82 ± 0.2% | 0.91 | 1.00 | 10.36 | 0.64 |
| other: a heading's start tag | 13 | 360.63 ± 0.4% | 367.69 ± 0.7% | 481.30 ± 0.4% | 43.68 ± 0.4% | 633.22 ± 0.8% | 874.65 ± 1.0% | 18347.31 ± 0.3% | 359.94 ± 0.5% | 0.98 | 1.00 | 8.26 | 0.57 |
| other: a whole word | 11 | 582.54 ± 0.8% | 624.78 ± 0.5% | 1034.83 ± 0.2% | 117.05 ± 0.6% | 567.54 ± 1.8% | 832.59 ± 0.6% | 27217.33 ± 0.2% | 582.75 ± 0.9% | 0.93 | 1.00 | 4.98 | 1.03 |
| other: a line's first word, second text | 17 | 537.24 ± 0.7% | 564.53 ± 0.6% | 894.37 ± 0.7% | 128.12 ± 0.1% | 715.58 ± 0.8% | refused | refused | 534.27 ± 0.5% | 0.95 | 1.01 | 4.19 | 0.75 |
| other: fourteen octets before an x | 16 | 107.64 ± 0.6% | 154.32 ± 0.6% | 175.27 ± 1.0% | 15.00 ± 0.3% | 455.15 ± 2.5% | 413.80 ± 0.5% | 12947.04 ± 0.1% | 107.69 ± 0.3% | 0.70 | 1.00 | 7.18 | 0.24 |
| other: a Greek word | 8 | 460.91 ± 0.2% | 616.41 ± 0.3% | 1038.38 ± 0.2% | 59.02 ± 0.3% | 1380.29 ± 0.7% | 1794.58 ± 0.4% | refused | 460.70 ± 0.1% | 0.75 | 1.00 | 7.81 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15712.21 ± 0.7% | not timed | not timed | 16268.17 ± 1.8% | 2093.91 ± 8.6% | not timed | not timed | 15694.42 ± 0.6% | | 1.00 | 0.97 | 7.50 |
| 01-literal/sherlock-casei-en | 522 | 5156.06 ± 1.5% | not timed | not timed | 3589.95 ± 0.4% | 32.58 ± 1.2% | not timed | not timed | 5157.26 ± 0.3% | | 1.00 | 1.44 | 158.24 |
| 01-literal/sherlock-ru | 724 | 17163.41 ± 0.7% | not timed | not timed | 17306.90 ± 0.5% | 1368.91 ± 12.5% | not timed | not timed | 17107.90 ± 0.4% | | 1.00 | 0.99 | 12.54 |
| 01-literal/sherlock-casei-ru | 746 | 6164.68 ± 0.1% | not timed | not timed | 3326.82 ± 0.2% | 30.98 ± 0.2% | not timed | not timed | 6179.57 ± 0.1% | | 1.00 | 1.85 | 198.96 |
| 01-literal/sherlock-zh | 30 | 19660.90 ± 0.6% | not timed | not timed | 18626.66 ± 0.6% | 2642.31 ± 11.5% | not timed | not timed | 19590.39 ± 0.9% | | 1.00 | 1.06 | 7.44 |
| 02-literal-alternate/sherlock-en | 714 | 6026.23 ± 0.2% | not timed | not timed | 3934.52 ± 0.2% | 16.40 ± 0.1% | not timed | not timed | 6055.63 ± 0.2% | | 1.00 | 1.53 | 367.56 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1928.85 ± 1.4% | not timed | not timed | 697.36 ± 0.2% | 11.13 ± 0.3% | not timed | not timed | 1932.15 ± 0.7% | | 1.00 | 2.77 | 173.29 |
| 02-literal-alternate/sherlock-ru | 899 | 5550.12 ± 0.2% | not timed | not timed | 3245.73 ± 0.1% | 22.57 ± 0.1% | not timed | not timed | 5562.50 ± 0.2% | | 1.00 | 1.71 | 245.92 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2049.63 ± 0.3% | not timed | not timed | 1231.64 ± 0.3% | 9.07 ± 0.2% | not timed | not timed | 2054.27 ± 0.2% | | 1.00 | 1.66 | 225.86 |
| 02-literal-alternate/sherlock-zh | 207 | 7260.62 ± 0.6% | not timed | not timed | 4164.93 ± 0.3% | 31.43 ± 0.2% | not timed | not timed | 7268.90 ± 0.3% | | 1.00 | 1.74 | 231.02 |
| 03-date/ascii | 111817 | 123.84 ± 0.7% | not timed | not timed | 96.41 ± 0.1% | 0.20 ± 6.5% | not timed | not timed | 123.65 ± 1.1% | | 1.00 | 1.28 | 607.21 |
| 04-ruff-noqa/real | 84 | 402.25 ± 0.1% | not timed | not timed | 480.19 ± 0.0% | 19.10 ± 1.1% | not timed | not timed | 402.33 ± 0.1% | | 1.00 | 0.84 | 21.06 |
| 04-ruff-noqa/tweaked | 44 | 558.69 ± 0.2% | not timed | not timed | 458.84 ± 0.3% | 366.19 ± 0.6% | not timed | not timed | 559.85 ± 0.1% | | 1.00 | 1.22 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.34 ± 0.3% | not timed | not timed | 5.18 ± 0.2% | 0.21 ± 2.5% | not timed | not timed | 5.35 ± 2.5% | | 1.00 | 1.03 | 25.81 |
| 06-cloud-flare-redos/original | 107 | 415.11 ± 0.1% | not timed | not timed | 216.36 ± 0.1% | 24.93 ± 0.1% | not timed | not timed | 414.69 ± 0.2% | | 1.00 | 1.92 | 16.65 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.60 ± 0.2% | not timed | not timed | 228.44 ± 0.1% | 26.74 ± 0.2% | not timed | not timed | 411.38 ± 0.2% | | 1.00 | 1.80 | 15.35 |
| 06-cloud-flare-redos/simplified-long | 10000 | 583.43 ± 0.8% | not timed | not timed | 255.54 ± 0.1% | 28.85 ± 0.1% | not timed | not timed | 582.74 ± 0.1% | | 1.00 | 2.28 | 20.22 |
| 07-unicode-character-data/parse-line | 558784 | 231.31 ± 2.1% | not timed | not timed | 179.99 ± 0.6% | 43.11 ± 5.4% | not timed | not timed | 232.29 ± 1.8% | | 1.00 | 1.29 | 5.37 |
| 08-words/all-english | 56691 | 117.15 ± 0.1% | not timed | not timed | 82.74 ± 0.0% | 12.70 ± 11.6% | not timed | not timed | 116.71 ± 0.5% | | 1.00 | 1.42 | 9.23 |
| 08-words/long-english | 839 | 614.10 ± 0.3% | not timed | not timed | 597.46 ± 0.1% | 32.53 ± 0.5% | not timed | not timed | 615.03 ± 1.6% | | 1.00 | 1.03 | 18.88 |
| 09-aws-keys/full | 0 | 408.47 ± 0.0% | not timed | not timed | 492.84 ± 0.1% | 64.64 ± 3.4% | not timed | not timed | 408.13 ± 0.1% | | 1.00 | 0.83 | 6.32 |
| 09-aws-keys/quick | 0 | 943.19 ± 0.1% | not timed | not timed | 1001.41 ± 0.2% | 422.30 ± 0.7% | not timed | not timed | 953.28 ± 0.1% | | 0.99 | 0.94 | 2.23 |
| 10-bounded-repeat/letters-en | 1833 | 547.97 ± 2.6% | not timed | not timed | 518.31 ± 0.3% | 19.57 ± 0.7% | not timed | not timed | 581.70 ± 1.3% | | 0.94 | 1.06 | 28.00 |
| 10-bounded-repeat/letters-ru | 3475 | 510.30 ± 1.2% | not timed | not timed | 478.12 ± 0.1% | 22.41 ± 17.2% | not timed | not timed | 506.46 ± 1.1% | | 1.01 | 1.07 | 22.77 |
| 10-bounded-repeat/context | 53 | 77.29 ± 0.4% | not timed | not timed | 66.04 ± 0.4% | 19.81 ± 0.2% | not timed | not timed | 77.56 ± 0.4% | | 1.00 | 1.17 | 3.90 |
| 10-bounded-repeat/capitals | 11 | 635.43 ± 8.2% | not timed | not timed | 616.65 ± 0.1% | 36.49 ± 0.1% | not timed | not timed | 635.11 ± 8.2% | | 1.00 | 1.03 | 17.41 |
| 11-unstructured-to-json/extract | 600 | 79.34 ± 0.2% | not timed | not timed | 76.72 ± 0.2% | 49.21 ± 1.2% | not timed | not timed | 80.68 ± 0.2% | | 0.98 | 1.03 | 1.61 |
| 12-dictionary/single | 1 | 560.28 ± 0.5% | not timed | not timed | 555.93 ± 0.2% | 0.41 ± 0.1% | not timed | not timed | 559.86 ± 0.2% | | 1.00 | 1.01 | 1374.03 |
| 14-quadratic/1x | 100 | 21.25 ± 1.4% | not timed | not timed | 9.97 ± 0.4% | 0.99 ± 4.2% | not timed | not timed | 21.23 ± 1.6% | | 1.00 | 2.13 | 21.56 |
| 14-quadratic/2x | 200 | 17.58 ± 1.0% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 1.8% | not timed | not timed | 17.52 ± 1.1% | | 1.00 | 3.17 | 32.95 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.3% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 1.8% | not timed | not timed | 7.69 ± 0.3% | | 1.00 | 6.34 | 66.56 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.29 ± 0.2% | not timed | not timed | 0.35 ± 0.4% | 0.54 ± 5.0% | not timed | not timed | 1.29 ± 0.9% | | 1.00 | 3.72 | 2.39 |
| 04-ruff-noqa/compile-real | 1 | 93.05 ± 0.2% | not timed | not timed | 13.96 ± 0.4% | 141.77 ± 2.4% | not timed | not timed | 92.48 ± 0.8% | | 1.01 | 6.67 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 13.93 ± 1.3% | not timed | not timed | 2.53 ± 0.4% | 6.48 ± 2.2% | not timed | not timed | 13.88 ± 1.5% | | 1.00 | 5.51 | 2.15 |
| 07-unicode-character-data/compile | 1 | 55.74 ± 0.2% | not timed | not timed | 26.11 ± 0.6% | 36.29 ± 2.5% | not timed | not timed | 55.56 ± 0.4% | | 1.00 | 2.14 | 1.54 |
| 09-aws-keys/compile-full | 1 | 42.06 ± 0.2% | not timed | not timed | 8.38 ± 0.2% | 23.58 ± 1.2% | not timed | not timed | 41.87 ± 0.5% | | 1.00 | 5.02 | 1.78 |
| 09-aws-keys/compile-quick | 1 | 188.20 ± 0.1% | not timed | not timed | 48.56 ± 0.3% | 136.57 ± 2.2% | not timed | not timed | 187.26 ± 0.2% | | 1.01 | 3.88 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 13.75 ± 1.0% | not timed | not timed | 11.25 ± 0.2% | 16.19 ± 2.8% | not timed | not timed | 13.73 ± 1.2% | | 1.00 | 1.22 | 0.85 |
| 10-bounded-repeat/compile-capitals | 1 | 83.03 ± 0.3% | not timed | not timed | 8.16 ± 0.2% | 24.02 ± 1.8% | not timed | not timed | 82.89 ± 0.2% | | 1.00 | 10.17 | 3.46 |
| 11-unstructured-to-json/compile | 1 | 86.98 ± 0.1% | not timed | not timed | 40.53 ± 0.3% | 68.97 ± 2.5% | not timed | not timed | 86.53 ± 0.3% | | 1.01 | 2.15 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.1% | not timed | not timed | 0.07 ± 0.8% | 0.09 ± 21.1% | not timed | not timed | 0.34 ± 1.7% | | 1.01 | 4.93 | 3.76 |

