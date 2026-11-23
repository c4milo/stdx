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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215359522 |
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
| literal: a word | 217 | 16201.55 ± 1.6% | 4996.83 ± 0.5% | 27.50 ± 0.2% | 18067.08 ± 3.8% | 9178.63 ± 8.0% | 17.46 ± 0.3% | 84.33 ± 0.7% | 16186.11 ± 2.0% | 3.24 | 1.00 | 0.90 | 1.77 |
| literal: a word that is not there | 0 | 18823.73 ± 1.5% | 4881.54 ± 0.5% | 27.56 ± 0.1% | 19628.88 ± 1.5% | 29117.87 ± 1.9% | 17.26 ± 0.6% | 79.66 ± 0.5% | 18870.37 ± 1.6% | 3.86 | 1.00 | 0.96 | 0.65 |
| literal: one of four words | 661 | 6099.56 ± 0.6% | 1932.36 ± 0.2% | 14.15 ± 0.2% | 3945.97 ± 0.3% | 21.88 ± 0.2% | 5.25 ± 0.3% | 6.88 ± 0.7% | 6079.82 ± 0.3% | 3.16 | 1.00 | 1.55 | 278.81 |
| literal: a word in any case | 217 | 12595.80 ± 0.2% | 2074.46 ± 0.2% | 20.67 ± 2.1% | 3975.66 ± 0.4% | 36.83 ± 0.3% | refused | differs | 12598.27 ± 0.2% | 6.07 | 1.00 | 3.17 | 342.02 |
| literal: an href attribute | 33 | 13756.89 ± 0.4% | 615.87 ± 0.1% | 26.42 ± 0.1% | 17128.21 ± 0.6% | 2260.92 ± 0.3% | 13.33 ± 0.3% | 73.90 ± 1.1% | 13711.36 ± 0.4% | 22.34 | 1.00 | 0.80 | 6.08 |
| literal: a word, second text | 123 | 16647.84 ± 1.4% | 3359.91 ± 0.4% | 27.19 ± 0.1% | 18435.78 ± 1.8% | 7556.23 ± 6.9% | 19.65 ± 0.3% | 70.03 ± 1.4% | 16692.29 ± 1.1% | 4.95 | 1.00 | 0.90 | 2.20 |
| class: two capitalized words | 1331 | 1063.42 ± 0.5% | 603.83 ± 0.2% | 25.22 ± 0.1% | 585.76 ± 0.0% | 40.44 ± 13.1% | 14.80 ± 0.2% | 67.33 ± 0.9% | 1062.21 ± 0.4% | 1.76 | 1.00 | 1.82 | 26.30 |
| class: a word that ends in ing | 3399 | 580.51 ± 0.2% | 579.44 ± 0.2% | 17.68 ± 0.1% | 548.11 ± 0.1% | 29.55 ± 3.3% | 8.17 ± 0.2% | 18.40 ± 0.2% | 580.37 ± 0.2% | 1.00 | 1.00 | 1.06 | 19.64 |
| class: a word in capitals | 2332 | 1372.98 ± 0.8% | 614.62 ± 0.4% | 26.80 ± 0.2% | 572.50 ± 0.1% | 42.91 ± 6.7% | 17.19 ± 0.3% | 82.30 ± 1.4% | 1369.87 ± 0.5% | 2.23 | 1.00 | 2.40 | 32.00 |
| class: a number | 8288 | 2001.19 ± 0.3% | 834.32 ± 0.1% | 27.12 ± 0.1% | 1730.29 ± 0.2% | 38.73 ± 14.2% | 0.56 ± 0.1% | 57.38 ± 0.7% | 2000.60 ± 0.9% | 2.40 | 1.00 | 1.16 | 51.67 |
| class: two capitalized words, second text | 5359 | 521.53 ± 0.2% | 528.71 ± 0.1% | 22.63 ± 0.4% | 485.83 ± 0.2% | 34.09 ± 10.7% | 16.66 ± 0.2% | 62.91 ± 0.4% | 521.58 ± 0.1% | 0.99 | 1.00 | 1.07 | 15.30 |
| other: a word between two words | 6104 | 742.37 ± 0.2% | 598.19 ± 0.2% | 22.95 ± 0.2% | 735.36 ± 0.6% | 108.52 ± 13.3% | 11.30 ± 0.1% | 67.64 ± 1.1% | 743.29 ± 0.1% | 1.24 | 1.00 | 1.01 | 6.84 |
| other: a number before a unit, second text | 1481 | 5347.05 ± 0.8% | 1111.05 ± 0.3% | 25.37 ± 0.1% | 5666.07 ± 0.5% | 40.69 ± 9.6% | 17.81 ± 0.3% | 65.80 ± 0.5% | 5329.42 ± 0.6% | 4.81 | 1.00 | 0.94 | 131.42 |
| other: a heading's start tag | 110 | 12555.47 ± 0.6% | 751.17 ± 0.1% | 26.66 ± 0.2% | 1707.55 ± 0.3% | 1580.12 ± 6.6% | 16.24 ± 0.4% | 85.46 ± 1.0% | 12588.34 ± 1.0% | 16.71 | 1.00 | 7.35 | 7.95 |
| other: a whole word | 217 | 13968.14 ± 0.3% | 608.40 ± 0.1% | 28.66 ± 0.1% | 14651.75 ± 0.6% | 47.58 ± 0.3% | 13.60 ± 0.2% | 54.76 ± 1.1% | 13987.33 ± 0.6% | 22.96 | 1.00 | 0.95 | 293.59 |
| other: a line's first word, second text | 3716 | 1955.19 ± 0.9% | 594.67 ± 0.1% | 30.01 ± 0.3% | 1722.82 ± 0.5% | 61.72 ± 6.5% | refused | refused | 1951.38 ± 0.5% | 3.29 | 1.00 | 1.13 | 31.68 |
| other: fourteen octets before an x | 87 | 19787.98 ± 2.7% | 242.07 ± 0.7% | 6.27 ± 0.1% | 3976.80 ± 0.6% | 10.62 ± 0.2% | differs | 17.73 ± 0.3% | 19752.16 ± 1.6% | 81.74 | 1.00 | 4.98 | 1863.80 |
| other: a Greek word | 21815 | 499.52 ± 1.1% | 412.97 ± 0.1% | 30.41 ± 0.3% | 289.48 ± 0.7% | 47.24 ± 9.5% | differs | refused | 499.45 ± 1.0% | 1.21 | 1.00 | 1.73 | 10.57 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.83 ± 0.2% | 19.89 ± 0.2% | 0.85 ± 0.3% | 19.78 ± 0.4% | 2.78 ± 0.6% | differs | 4.05 ± 0.2% | 19.89 ± 0.2% | 1.00 | 1.00 | 1.00 | 7.14 |
| a UUID | 32895 | 21.31 ± 0.5% | 21.32 ± 0.2% | 0.64 ± 0.3% | 15.20 ± 0.6% | 3.10 ± 0.4% | 0.72 ± 0.4% | 3.65 ± 0.7% | 21.34 ± 0.1% | 1.00 | 1.00 | 1.40 | 6.87 |
| an IPv4 address | 33176 | 36.90 ± 0.4% | 36.88 ± 0.2% | 2.06 ± 0.3% | 28.94 ± 0.7% | 6.64 ± 0.2% | differs | 4.14 ± 0.2% | 36.89 ± 0.3% | 1.00 | 1.00 | 1.27 | 5.56 |
| a date and time | 32954 | 31.37 ± 0.3% | 31.37 ± 0.2% | 1.42 ± 0.2% | 21.12 ± 0.3% | 7.04 ± 0.2% | 1.20 ± 0.2% | 7.14 ± 0.8% | 31.32 ± 0.3% | 1.00 | 1.00 | 1.49 | 4.45 |
| a field path | 32606 | 23.50 ± 0.2% | 23.53 ± 0.2% | 1.00 ± 0.4% | 23.08 ± 0.2% | 3.51 ± 1.0% | differs | 2.96 ± 0.3% | 23.53 ± 0.2% | 1.00 | 1.00 | 1.02 | 6.70 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.14 ± 0.2% | 11.11 ± 0.5% | 11.12 ± 0.4% | 11.38 ± 0.1% | 4.91 ± 2.7% | 0.91 ± 0.7% | none | 11.11 ± 0.1% | 1.00 | 1.00 | 0.98 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.58 ± 0.2% | 235.51 ± 0.3% | 277.04 ± 0.3% | 86.64 ± 0.4% | 222.63 ± 1.4% | 487.53 ± 0.3% | 3777.64 ± 0.2% | 234.52 ± 0.1% | 1.00 | 1.00 | 2.71 | 1.05 |
| a UUID | 62 | 151.82 ± 0.3% | 152.24 ± 0.4% | 169.19 ± 0.3% | 45.60 ± 0.2% | 100.26 ± 0.4% | 181.97 ± 1.0% | 4205.82 ± 0.4% | 151.80 ± 0.3% | 1.00 | 1.00 | 3.33 | 1.51 |
| an IPv4 address | 29 | 429.87 ± 0.3% | 433.10 ± 0.1% | 599.55 ± 0.4% | 76.29 ± 1.0% | 130.81 ± 7.4% | 289.70 ± 1.1% | 7502.79 ± 0.2% | 429.89 ± 0.6% | 0.99 | 1.00 | 5.63 | 3.29 |
| a date and time | 56 | 301.73 ± 0.4% | 303.14 ± 0.3% | 374.38 ± 0.2% | 71.97 ± 0.2% | 138.46 ± 1.3% | 321.32 ± 0.9% | 4879.48 ± 0.6% | 301.89 ± 0.5% | 1.00 | 1.00 | 4.19 | 2.18 |
| a field path | 39 | 226.26 ± 1.2% | 226.92 ± 0.8% | 266.60 ± 1.4% | 79.49 ± 0.5% | 205.80 ± 2.3% | 489.96 ± 0.6% | 4826.88 ± 0.8% | 227.58 ± 0.8% | 1.00 | 0.99 | 2.85 | 1.10 |
| literal: a word | 7 | 651.61 ± 0.7% | 695.09 ± 0.5% | 1222.28 ± 0.2% | 499.52 ± 1.6% | 633.73 ± 4.9% | 934.89 ± 0.6% | 29654.68 ± 0.2% | 651.82 ± 0.7% | 0.94 | 1.00 | 1.30 | 1.03 |
| literal: a word that is not there | 8 | 624.99 ± 0.5% | 674.77 ± 0.9% | 1156.31 ± 0.5% | 457.30 ± 0.1% | 605.30 ± 2.3% | 885.74 ± 0.5% | 28626.27 ± 0.1% | 625.35 ± 0.5% | 0.93 | 1.00 | 1.37 | 1.03 |
| literal: one of four words | 26 | 249.86 ± 0.2% | 407.07 ± 0.3% | 545.82 ± 0.2% | 49.28 ± 0.2% | 242.73 ± 2.4% | 362.41 ± 0.5% | 15783.67 ± 0.1% | 249.87 ± 0.3% | 0.61 | 1.00 | 5.07 | 1.03 |
| literal: a word in any case | 11 | 456.80 ± 0.3% | 485.44 ± 0.3% | 702.31 ± 0.1% | 15.67 ± 0.9% | 649.37 ± 2.6% | refused | 23328.99 ± 0.7% | 456.38 ± 0.3% | 0.94 | 1.00 | 29.16 | 0.70 |
| literal: an href attribute | 12 | 348.04 ± 0.4% | 359.42 ± 0.2% | 465.43 ± 0.3% | 45.00 ± 1.0% | 498.73 ± 0.6% | 775.28 ± 1.8% | 21112.40 ± 0.3% | 348.19 ± 0.2% | 0.97 | 1.00 | 7.73 | 0.70 |
| literal: a word, second text | 10 | 577.84 ± 0.6% | 632.61 ± 0.4% | 1043.48 ± 0.3% | 404.79 ± 0.4% | 538.22 ± 11.3% | 808.46 ± 0.7% | 26550.65 ± 0.1% | 578.65 ± 0.3% | 0.91 | 1.00 | 1.43 | 1.07 |
| class: two capitalized words | 23 | 445.18 ± 0.7% | 475.83 ± 0.6% | 676.08 ± 1.1% | 101.03 ± 0.2% | 506.01 ± 0.9% | 740.66 ± 0.6% | 6443.68 ± 0.3% | 444.13 ± 0.3% | 0.94 | 1.00 | 4.41 | 0.88 |
| class: a word that ends in ing | 9 | 579.06 ± 0.6% | 643.13 ± 1.0% | 1104.27 ± 0.4% | 132.93 ± 0.9% | 764.42 ± 1.5% | 1092.20 ± 1.7% | 15638.48 ± 0.1% | 579.09 ± 0.4% | 0.90 | 1.00 | 4.36 | 0.76 |
| class: a word in capitals | 16 | 507.41 ± 0.4% | 546.53 ± 0.3% | 863.28 ± 0.4% | 135.29 ± 1.0% | 758.45 ± 0.7% | 1011.86 ± 0.8% | 8493.41 ± 0.2% | 507.64 ± 0.5% | 0.93 | 1.00 | 3.75 | 0.67 |
| class: a number | 6 | 647.66 ± 0.4% | 709.74 ± 0.4% | 1319.60 ± 0.2% | 41.75 ± 0.5% | 1416.60 ± 1.6% | 1945.90 ± 1.2% | 22407.54 ± 0.1% | 647.58 ± 0.2% | 0.91 | 1.00 | 15.51 | 0.46 |
| class: two capitalized words, second text | 23 | 445.88 ± 0.4% | 475.33 ± 0.3% | 676.81 ± 0.4% | 103.09 ± 0.2% | 504.04 ± 0.7% | 740.92 ± 0.3% | 6445.28 ± 0.6% | 446.00 ± 0.9% | 0.94 | 1.00 | 4.32 | 0.88 |
| other: a word between two words | 13 | 559.38 ± 0.6% | 578.33 ± 0.7% | 902.98 ± 0.2% | 135.92 ± 0.5% | 510.49 ± 1.1% | 819.32 ± 0.7% | 14595.29 ± 0.1% | 557.99 ± 0.5% | 0.97 | 1.00 | 4.12 | 1.10 |
| other: a number before a unit, second text | 15 | 406.77 ± 1.1% | 443.23 ± 0.8% | 619.49 ± 0.4% | 39.15 ± 0.5% | 643.04 ± 1.5% | 897.85 ± 1.0% | 14912.66 ± 0.3% | 406.02 ± 0.8% | 0.92 | 1.00 | 10.39 | 0.63 |
| other: a heading's start tag | 13 | 359.91 ± 0.7% | 365.09 ± 0.4% | 475.73 ± 0.5% | 43.52 ± 0.2% | 630.40 ± 0.9% | 868.30 ± 0.2% | 17624.96 ± 0.3% | 359.46 ± 0.5% | 0.99 | 1.00 | 8.27 | 0.57 |
| other: a whole word | 11 | 593.34 ± 0.5% | 628.02 ± 0.2% | 1034.95 ± 0.3% | 120.48 ± 0.2% | 567.38 ± 2.4% | 828.47 ± 0.6% | 26496.59 ± 0.3% | 593.88 ± 0.4% | 0.94 | 1.00 | 4.92 | 1.05 |
| other: a line's first word, second text | 17 | 546.57 ± 0.5% | 564.06 ± 0.4% | 894.73 ± 0.5% | 128.49 ± 0.0% | 710.84 ± 0.6% | refused | refused | 544.92 ± 0.8% | 0.97 | 1.00 | 4.25 | 0.77 |
| other: fourteen octets before an x | 16 | 109.01 ± 0.9% | 156.34 ± 1.1% | 178.06 ± 0.9% | 15.07 ± 0.3% | 456.45 ± 1.9% | 415.97 ± 0.7% | 12600.20 ± 0.3% | 108.95 ± 0.3% | 0.70 | 1.00 | 7.24 | 0.24 |
| other: a Greek word | 8 | 463.64 ± 0.3% | 615.01 ± 0.2% | 1026.51 ± 0.4% | 58.42 ± 0.3% | 1407.56 ± 1.4% | 1854.43 ± 0.5% | refused | 464.03 ± 0.2% | 0.75 | 1.00 | 7.94 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12842.75 ± 0.7% | not timed | not timed | 16201.95 ± 2.3% | 2033.89 ± 13.1% | not timed | not timed | 12809.94 ± 0.7% | | 1.00 | 0.79 | 6.31 |
| 01-literal/sherlock-casei-en | 522 | 4956.84 ± 1.0% | not timed | not timed | 3594.03 ± 0.1% | 32.06 ± 1.2% | not timed | not timed | 4937.67 ± 0.1% | | 1.00 | 1.38 | 154.60 |
| 01-literal/sherlock-ru | 724 | 13576.96 ± 0.8% | not timed | not timed | 17298.38 ± 0.5% | 1552.65 ± 18.0% | not timed | not timed | 13531.61 ± 1.1% | | 1.00 | 0.78 | 8.74 |
| 01-literal/sherlock-casei-ru | 746 | 5983.46 ± 0.2% | not timed | not timed | 3320.35 ± 0.2% | 31.41 ± 1.3% | not timed | not timed | 5977.48 ± 0.3% | | 1.00 | 1.80 | 190.50 |
| 01-literal/sherlock-zh | 30 | 17082.00 ± 0.5% | not timed | not timed | 18563.73 ± 1.1% | 2858.01 ± 12.3% | not timed | not timed | 17039.57 ± 0.4% | | 1.00 | 0.92 | 5.98 |
| 02-literal-alternate/sherlock-en | 714 | 5766.93 ± 0.3% | not timed | not timed | 3945.24 ± 0.2% | 16.60 ± 0.3% | not timed | not timed | 5758.10 ± 0.3% | | 1.00 | 1.46 | 347.45 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1806.73 ± 1.1% | not timed | not timed | 697.93 ± 0.4% | 11.05 ± 0.2% | not timed | not timed | 1795.47 ± 0.4% | | 1.01 | 2.59 | 163.48 |
| 02-literal-alternate/sherlock-ru | 899 | 5339.94 ± 0.3% | not timed | not timed | 3265.78 ± 0.2% | 22.65 ± 14.7% | not timed | not timed | 5326.19 ± 0.4% | | 1.00 | 1.64 | 235.73 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1922.08 ± 0.6% | not timed | not timed | 1233.03 ± 0.1% | 9.15 ± 0.1% | not timed | not timed | 1913.08 ± 0.2% | | 1.00 | 1.56 | 210.09 |
| 02-literal-alternate/sherlock-zh | 207 | 7077.58 ± 0.5% | not timed | not timed | 4168.57 ± 0.2% | 31.43 ± 0.2% | not timed | not timed | 7064.58 ± 0.2% | | 1.00 | 1.70 | 225.16 |
| 03-date/ascii | 111817 | 127.04 ± 0.5% | not timed | not timed | 95.64 ± 0.1% | 0.21 ± 6.0% | not timed | not timed | 126.29 ± 0.4% | | 1.01 | 1.33 | 614.78 |
| 04-ruff-noqa/real | 84 | 409.96 ± 0.1% | not timed | not timed | 457.90 ± 0.3% | 19.53 ± 1.3% | not timed | not timed | 408.29 ± 0.1% | | 1.00 | 0.90 | 20.99 |
| 04-ruff-noqa/tweaked | 44 | 552.71 ± 0.1% | not timed | not timed | 461.29 ± 0.1% | 363.54 ± 0.3% | not timed | not timed | 551.51 ± 0.3% | | 1.00 | 1.20 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.24 ± 0.6% | not timed | not timed | 4.94 ± 0.2% | 0.21 ± 4.9% | not timed | not timed | 5.09 ± 4.1% | | 1.03 | 1.06 | 25.51 |
| 06-cloud-flare-redos/original | 107 | 415.13 ± 0.3% | not timed | not timed | 214.78 ± 0.1% | 24.77 ± 0.3% | not timed | not timed | 414.91 ± 0.3% | | 1.00 | 1.93 | 16.76 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.76 ± 0.2% | not timed | not timed | 228.83 ± 0.1% | 26.70 ± 0.1% | not timed | not timed | 411.32 ± 0.1% | | 1.00 | 1.80 | 15.38 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.77 ± 0.2% | not timed | not timed | 256.04 ± 1.0% | 28.78 ± 0.2% | not timed | not timed | 586.96 ± 0.2% | | 1.00 | 2.30 | 20.42 |
| 07-unicode-character-data/parse-line | 558784 | 236.71 ± 0.2% | not timed | not timed | 172.50 ± 0.1% | 43.14 ± 5.1% | not timed | not timed | 236.50 ± 2.0% | | 1.00 | 1.37 | 5.49 |
| 08-words/all-english | 56691 | 117.31 ± 0.6% | not timed | not timed | 83.17 ± 0.1% | 11.73 ± 6.8% | not timed | not timed | 116.89 ± 0.5% | | 1.00 | 1.41 | 10.00 |
| 08-words/long-english | 839 | 621.03 ± 0.1% | not timed | not timed | 596.18 ± 0.2% | 32.23 ± 0.3% | not timed | not timed | 620.76 ± 0.0% | | 1.00 | 1.04 | 19.27 |
| 09-aws-keys/full | 0 | 415.99 ± 0.2% | not timed | not timed | 464.53 ± 0.1% | 64.73 ± 0.4% | not timed | not timed | 415.54 ± 0.1% | | 1.00 | 0.90 | 6.43 |
| 09-aws-keys/quick | 0 | 739.92 ± 0.1% | not timed | not timed | 990.70 ± 0.4% | 418.84 ± 0.6% | not timed | not timed | 736.06 ± 0.2% | | 1.01 | 0.75 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 582.57 ± 2.5% | not timed | not timed | 517.42 ± 0.3% | 19.51 ± 0.4% | not timed | not timed | 580.90 ± 2.3% | | 1.00 | 1.13 | 29.86 |
| 10-bounded-repeat/letters-ru | 3475 | 486.26 ± 1.1% | not timed | not timed | 478.10 ± 0.2% | 21.99 ± 8.5% | not timed | not timed | 509.20 ± 1.5% | | 0.95 | 1.02 | 22.11 |
| 10-bounded-repeat/context | 53 | 77.35 ± 0.5% | not timed | not timed | 65.54 ± 0.4% | 19.82 ± 0.1% | not timed | not timed | 77.47 ± 0.3% | | 1.00 | 1.18 | 3.90 |
| 10-bounded-repeat/capitals | 11 | 631.75 ± 8.3% | not timed | not timed | 615.78 ± 0.1% | 36.54 ± 0.3% | not timed | not timed | 630.31 ± 8.5% | | 1.00 | 1.03 | 17.29 |
| 11-unstructured-to-json/extract | 600 | 83.03 ± 0.1% | not timed | not timed | 76.98 ± 0.2% | 49.01 ± 0.5% | not timed | not timed | 82.89 ± 0.2% | | 1.00 | 1.08 | 1.69 |
| 12-dictionary/single | 1 | 560.85 ± 0.1% | not timed | not timed | 556.06 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 559.25 ± 0.1% | | 1.00 | 1.01 | 1383.48 |
| 14-quadratic/1x | 100 | 21.53 ± 1.3% | not timed | not timed | 10.01 ± 0.1% | 0.95 ± 2.8% | not timed | not timed | 21.45 ± 1.1% | | 1.00 | 2.15 | 22.56 |
| 14-quadratic/2x | 200 | 17.63 ± 3.3% | not timed | not timed | 5.52 ± 0.4% | 0.53 ± 2.6% | not timed | not timed | 17.60 ± 3.1% | | 1.00 | 3.19 | 33.14 |
| 14-quadratic/10x | 1000 | 7.71 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.1% | not timed | not timed | 7.69 ± 1.0% | | 1.00 | 6.35 | 66.82 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 2.2% | not timed | not timed | 0.34 ± 0.7% | 0.55 ± 3.3% | not timed | not timed | 1.27 ± 1.2% | | 1.00 | 3.69 | 2.32 |
| 04-ruff-noqa/compile-real | 1 | 92.87 ± 0.2% | not timed | not timed | 13.79 ± 0.2% | 137.42 ± 3.6% | not timed | not timed | 92.61 ± 1.3% | | 1.00 | 6.73 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 13.82 ± 0.3% | not timed | not timed | 2.51 ± 0.5% | 6.43 ± 4.0% | not timed | not timed | 13.68 ± 1.2% | | 1.01 | 5.51 | 2.15 |
| 07-unicode-character-data/compile | 1 | 54.85 ± 0.5% | not timed | not timed | 25.81 ± 0.3% | 35.77 ± 3.2% | not timed | not timed | 54.19 ± 1.0% | | 1.01 | 2.12 | 1.53 |
| 09-aws-keys/compile-full | 1 | 41.76 ± 0.2% | not timed | not timed | 8.23 ± 1.0% | 23.05 ± 3.7% | not timed | not timed | 41.57 ± 0.6% | | 1.00 | 5.07 | 1.81 |
| 09-aws-keys/compile-quick | 1 | 188.33 ± 0.3% | not timed | not timed | 46.98 ± 0.2% | 132.58 ± 3.5% | not timed | not timed | 185.76 ± 1.3% | | 1.01 | 4.01 | 1.42 |
| 10-bounded-repeat/compile-context | 1 | 13.99 ± 0.5% | not timed | not timed | 11.19 ± 0.3% | 16.33 ± 5.5% | not timed | not timed | 13.81 ± 1.4% | | 1.01 | 1.25 | 0.86 |
| 10-bounded-repeat/compile-capitals | 1 | 83.49 ± 0.2% | not timed | not timed | 8.00 ± 0.1% | 24.01 ± 1.0% | not timed | not timed | 82.91 ± 2.3% | | 1.01 | 10.44 | 3.48 |
| 11-unstructured-to-json/compile | 1 | 85.76 ± 0.2% | not timed | not timed | 41.14 ± 0.2% | 67.86 ± 2.7% | not timed | not timed | 85.35 ± 1.3% | | 1.00 | 2.08 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.07 ± 0.5% | 0.09 ± 19.1% | not timed | not timed | 0.35 ± 0.6% | | 1.01 | 5.11 | 3.83 |

