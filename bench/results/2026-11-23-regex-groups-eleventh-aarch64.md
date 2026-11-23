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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215406562 |
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
| literal: a word | 217 | 15815.58 ± 1.0% | 4987.26 ± 0.1% | 27.88 ± 0.3% | 17949.84 ± 1.4% | 9066.69 ± 10.7% | 17.37 ± 0.6% | 83.79 ± 1.2% | 15873.97 ± 1.4% | 3.17 | 1.00 | 0.88 | 1.74 |
| literal: a word that is not there | 0 | 18380.78 ± 2.1% | 4874.41 ± 0.2% | 27.95 ± 0.1% | 19174.11 ± 4.3% | 28129.62 ± 2.9% | 17.21 ± 0.2% | 79.29 ± 0.2% | 18528.22 ± 1.9% | 3.77 | 0.99 | 0.96 | 0.65 |
| literal: one of four words | 661 | 6072.21 ± 0.7% | 1930.72 ± 0.5% | 14.24 ± 0.3% | 3941.98 ± 0.1% | 21.89 ± 0.1% | 5.34 ± 0.3% | 6.87 ± 1.1% | 6055.84 ± 0.3% | 3.15 | 1.00 | 1.54 | 277.35 |
| literal: a word in any case | 217 | 12522.90 ± 0.5% | 2069.99 ± 0.1% | 20.98 ± 2.1% | 3967.36 ± 0.3% | 36.80 ± 0.4% | refused | differs | 12498.86 ± 0.6% | 6.05 | 1.00 | 3.16 | 340.32 |
| literal: an href attribute | 33 | 13494.41 ± 1.3% | 615.49 ± 0.1% | 27.04 ± 0.2% | 16684.57 ± 2.4% | 2250.11 ± 1.7% | 12.66 ± 0.9% | 73.56 ± 0.5% | 13508.10 ± 0.7% | 21.92 | 1.00 | 0.81 | 6.00 |
| literal: a word, second text | 123 | 15958.80 ± 1.8% | 3348.90 ± 0.1% | 27.63 ± 0.2% | 17788.78 ± 3.8% | 7462.70 ± 5.1% | 19.88 ± 0.5% | 69.45 ± 0.7% | 16238.22 ± 3.4% | 4.77 | 0.98 | 0.90 | 2.14 |
| class: two capitalized words | 1331 | 1061.23 ± 0.6% | 603.55 ± 0.2% | 25.78 ± 0.2% | 582.15 ± 0.1% | 40.46 ± 0.1% | 14.82 ± 0.2% | 67.44 ± 0.4% | 1064.09 ± 0.1% | 1.76 | 1.00 | 1.82 | 26.23 |
| class: a word that ends in ing | 3399 | 579.92 ± 0.1% | 578.89 ± 0.3% | 17.85 ± 0.1% | 545.36 ± 0.1% | 29.57 ± 11.1% | 8.15 ± 0.2% | 18.26 ± 0.2% | 579.57 ± 0.6% | 1.00 | 1.00 | 1.06 | 19.61 |
| class: a word in capitals | 2332 | 1373.59 ± 0.3% | 590.27 ± 0.5% | 27.30 ± 0.4% | 572.30 ± 0.1% | 43.32 ± 17.5% | 17.16 ± 0.3% | 82.46 ± 0.2% | 1373.01 ± 0.4% | 2.33 | 1.00 | 2.40 | 31.71 |
| class: a number | 8288 | 1999.32 ± 0.7% | 833.35 ± 0.1% | 27.60 ± 0.3% | 1724.40 ± 0.1% | 41.82 ± 7.2% | 0.56 ± 0.1% | 57.43 ± 0.3% | 1999.70 ± 0.3% | 2.40 | 1.00 | 1.16 | 47.80 |
| class: two capitalized words, second text | 5359 | 520.63 ± 0.6% | 527.87 ± 0.1% | 23.05 ± 0.1% | 486.64 ± 0.1% | 35.22 ± 13.8% | 17.34 ± 0.1% | 62.71 ± 0.6% | 520.66 ± 0.1% | 0.99 | 1.00 | 1.07 | 14.78 |
| other: a word between two words | 6104 | 739.57 ± 0.1% | 597.97 ± 0.1% | 23.36 ± 0.2% | 735.08 ± 0.2% | 104.52 ± 12.1% | 11.18 ± 0.2% | 67.59 ± 1.0% | 738.13 ± 0.0% | 1.24 | 1.00 | 1.01 | 7.08 |
| other: a number before a unit, second text | 1481 | 5331.68 ± 1.1% | 1108.26 ± 0.3% | 25.87 ± 0.2% | 5622.32 ± 0.5% | 40.63 ± 10.0% | 18.25 ± 0.3% | 65.22 ± 0.8% | 5309.43 ± 1.0% | 4.81 | 1.00 | 0.95 | 131.23 |
| other: a heading's start tag | 110 | 12375.10 ± 1.1% | 750.50 ± 0.2% | 27.16 ± 0.3% | 1704.42 ± 0.4% | 1576.12 ± 1.0% | 16.08 ± 0.3% | 85.80 ± 2.4% | 12433.94 ± 0.8% | 16.49 | 1.00 | 7.26 | 7.85 |
| other: a whole word | 217 | 13744.70 ± 0.9% | 608.03 ± 0.1% | 29.16 ± 0.1% | 14496.95 ± 1.2% | 47.65 ± 6.2% | 13.26 ± 0.3% | 54.92 ± 1.0% | 13761.43 ± 1.5% | 22.61 | 1.00 | 0.95 | 288.47 |
| other: a line's first word, second text | 3716 | 1952.60 ± 0.2% | 594.19 ± 0.1% | 30.89 ± 0.1% | 1739.95 ± 0.2% | 61.71 ± 6.2% | refused | refused | 1937.70 ± 0.5% | 3.29 | 1.01 | 1.12 | 31.64 |
| other: fourteen octets before an x | 87 | 19120.06 ± 1.4% | 250.43 ± 0.4% | 6.30 ± 0.1% | 3968.64 ± 0.6% | 10.62 ± 0.1% | differs | 17.74 ± 0.1% | 19065.16 ± 1.1% | 76.35 | 1.00 | 4.82 | 1800.59 |
| other: a Greek word | 21815 | 499.69 ± 0.8% | 412.37 ± 0.2% | 30.67 ± 0.4% | 289.24 ± 0.2% | 46.62 ± 5.4% | differs | refused | 498.90 ± 0.8% | 1.21 | 1.00 | 1.73 | 10.72 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.87 ± 0.2% | 19.85 ± 0.2% | 0.84 ± 0.2% | 19.82 ± 0.2% | 2.74 ± 0.9% | differs | 4.06 ± 0.2% | 19.86 ± 0.1% | 1.00 | 1.00 | 1.00 | 7.26 |
| a UUID | 32895 | 21.32 ± 0.2% | 21.34 ± 0.2% | 0.64 ± 0.2% | 15.20 ± 0.1% | 3.09 ± 0.3% | 0.73 ± 0.3% | 3.65 ± 0.5% | 21.33 ± 0.1% | 1.00 | 1.00 | 1.40 | 6.90 |
| an IPv4 address | 33176 | 36.94 ± 0.3% | 36.90 ± 0.1% | 2.06 ± 0.1% | 29.17 ± 1.1% | 6.65 ± 0.2% | differs | 4.15 ± 0.2% | 36.87 ± 0.4% | 1.00 | 1.00 | 1.27 | 5.56 |
| a date and time | 32954 | 31.42 ± 0.2% | 31.44 ± 0.1% | 1.41 ± 0.2% | 21.67 ± 0.3% | 7.05 ± 0.2% | 1.25 ± 0.2% | 7.16 ± 0.9% | 31.52 ± 0.3% | 1.00 | 1.00 | 1.45 | 4.46 |
| a field path | 32606 | 23.49 ± 0.2% | 23.55 ± 0.1% | 1.00 ± 0.4% | 23.35 ± 0.4% | 3.50 ± 0.8% | differs | 2.97 ± 0.2% | 23.53 ± 0.2% | 1.00 | 1.00 | 1.01 | 6.71 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.12 ± 0.8% | 11.09 ± 0.7% | 11.10 ± 0.5% | 11.52 ± 0.1% | 4.87 ± 1.3% | 0.94 ± 0.8% | none | 11.11 ± 0.4% | 1.00 | 1.00 | 0.97 | 2.28 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 227.63 ± 0.3% | 228.61 ± 0.4% | 270.28 ± 0.3% | 87.16 ± 0.2% | 217.88 ± 2.3% | 480.33 ± 0.6% | 3795.36 ± 0.4% | 227.76 ± 0.1% | 1.00 | 1.00 | 2.61 | 1.04 |
| a UUID | 62 | 148.66 ± 0.4% | 148.99 ± 0.1% | 166.55 ± 0.3% | 46.61 ± 0.4% | 95.33 ± 4.5% | 185.81 ± 2.5% | 4232.16 ± 0.6% | 148.75 ± 0.2% | 1.00 | 1.00 | 3.19 | 1.56 |
| an IPv4 address | 29 | 422.36 ± 0.2% | 425.49 ± 0.3% | 600.46 ± 0.4% | 77.30 ± 0.5% | 126.85 ± 12.4% | 297.01 ± 0.6% | 7565.81 ± 0.3% | 421.60 ± 0.3% | 0.99 | 1.00 | 5.46 | 3.33 |
| a date and time | 56 | 302.30 ± 0.4% | 304.63 ± 0.3% | 382.61 ± 0.2% | 73.43 ± 0.6% | 132.54 ± 5.3% | 317.07 ± 1.1% | 4919.77 ± 0.8% | 302.69 ± 0.1% | 0.99 | 1.00 | 4.12 | 2.28 |
| a field path | 39 | 221.10 ± 0.1% | 221.61 ± 0.2% | 259.78 ± 0.2% | 80.92 ± 0.4% | 200.19 ± 2.2% | 503.15 ± 1.9% | 4848.51 ± 2.7% | 221.03 ± 0.1% | 1.00 | 1.00 | 2.73 | 1.10 |
| literal: a word | 7 | 642.81 ± 0.5% | 693.45 ± 0.5% | 1256.35 ± 0.1% | 526.61 ± 0.1% | 610.52 ± 2.2% | 946.56 ± 0.5% | 30788.90 ± 0.0% | 643.03 ± 0.6% | 0.93 | 1.00 | 1.22 | 1.05 |
| literal: a word that is not there | 8 | 621.00 ± 1.7% | 672.38 ± 0.7% | 1182.00 ± 0.6% | 474.78 ± 0.4% | 581.59 ± 2.9% | 898.99 ± 0.5% | 29565.84 ± 0.1% | 621.43 ± 0.4% | 0.92 | 1.00 | 1.31 | 1.07 |
| literal: one of four words | 26 | 242.98 ± 0.2% | 403.38 ± 0.1% | 549.05 ± 0.1% | 49.41 ± 0.5% | 232.98 ± 2.6% | 362.22 ± 1.8% | 16078.04 ± 0.1% | 242.75 ± 0.2% | 0.60 | 1.00 | 4.92 | 1.04 |
| literal: a word in any case | 11 | 452.19 ± 0.3% | 481.54 ± 0.2% | 707.17 ± 0.0% | 15.70 ± 0.1% | 626.11 ± 2.5% | refused | 23848.21 ± 0.5% | 452.01 ± 0.3% | 0.94 | 1.00 | 28.81 | 0.72 |
| literal: an href attribute | 12 | 350.36 ± 0.7% | 362.57 ± 0.5% | 479.62 ± 0.4% | 45.62 ± 0.6% | 480.42 ± 4.3% | 776.12 ± 0.4% | 22201.94 ± 0.5% | 350.11 ± 0.3% | 0.97 | 1.00 | 7.68 | 0.73 |
| literal: a word, second text | 10 | 573.18 ± 0.7% | 629.84 ± 1.2% | 1065.93 ± 1.3% | 429.58 ± 0.6% | 521.41 ± 2.5% | 806.78 ± 0.6% | 27543.05 ± 0.1% | 572.39 ± 1.0% | 0.91 | 1.00 | 1.33 | 1.10 |
| class: two capitalized words | 23 | 436.82 ± 0.5% | 467.18 ± 0.6% | 681.97 ± 0.8% | 101.14 ± 0.2% | 489.74 ± 3.0% | 741.58 ± 0.7% | 6520.28 ± 0.4% | 437.55 ± 0.3% | 0.94 | 1.00 | 4.32 | 0.89 |
| class: a word that ends in ing | 9 | 570.22 ± 0.2% | 643.49 ± 0.5% | 1128.70 ± 0.5% | 132.41 ± 1.2% | 739.07 ± 2.5% | 1104.06 ± 1.8% | 16098.14 ± 0.1% | 570.05 ± 0.3% | 0.89 | 1.00 | 4.31 | 0.77 |
| class: a word in capitals | 16 | 501.50 ± 0.4% | 542.98 ± 0.3% | 880.57 ± 0.5% | 136.35 ± 0.5% | 737.98 ± 4.8% | 1011.12 ± 1.2% | 8571.86 ± 0.2% | 500.85 ± 0.5% | 0.92 | 1.00 | 3.68 | 0.68 |
| class: a number | 6 | 637.99 ± 0.7% | 701.92 ± 0.3% | 1351.56 ± 0.1% | 41.86 ± 0.6% | 1373.25 ± 2.0% | 1892.73 ± 1.1% | 23145.09 ± 0.2% | 638.73 ± 0.3% | 0.91 | 1.00 | 15.24 | 0.46 |
| class: two capitalized words, second text | 23 | 437.16 ± 0.3% | 468.30 ± 0.3% | 683.60 ± 0.6% | 104.18 ± 0.4% | 489.37 ± 1.9% | 732.96 ± 0.7% | 6509.44 ± 0.1% | 436.73 ± 0.5% | 0.93 | 1.00 | 4.20 | 0.89 |
| other: a word between two words | 13 | 550.32 ± 0.4% | 569.05 ± 0.4% | 922.09 ± 0.4% | 135.13 ± 1.0% | 488.09 ± 2.6% | 808.79 ± 0.7% | 14880.41 ± 0.3% | 549.99 ± 0.4% | 0.97 | 1.00 | 4.07 | 1.13 |
| other: a number before a unit, second text | 15 | 397.66 ± 0.5% | 437.17 ± 0.5% | 612.27 ± 0.2% | 39.40 ± 0.2% | 616.89 ± 1.6% | 885.27 ± 0.2% | 15311.24 ± 0.5% | 398.65 ± 0.5% | 0.91 | 1.00 | 10.09 | 0.64 |
| other: a heading's start tag | 13 | 360.39 ± 0.3% | 365.88 ± 0.1% | 487.26 ± 0.2% | 44.61 ± 0.1% | 610.22 ± 1.6% | 863.01 ± 0.4% | 18392.50 ± 0.4% | 360.36 ± 0.4% | 0.99 | 1.00 | 8.08 | 0.59 |
| other: a whole word | 11 | 588.84 ± 0.5% | 623.14 ± 0.1% | 1048.62 ± 0.6% | 121.96 ± 0.5% | 547.25 ± 2.4% | 818.57 ± 1.2% | 27262.94 ± 0.3% | 588.37 ± 0.2% | 0.94 | 1.00 | 4.83 | 1.08 |
| other: a line's first word, second text | 17 | 536.02 ± 0.7% | 556.34 ± 0.5% | 891.11 ± 0.8% | 130.16 ± 0.1% | 695.49 ± 0.9% | refused | refused | 534.84 ± 0.9% | 0.96 | 1.00 | 4.12 | 0.77 |
| other: fourteen octets before an x | 16 | 109.37 ± 0.3% | 156.98 ± 0.5% | 180.30 ± 0.3% | 15.18 ± 0.2% | 435.23 ± 3.5% | 412.13 ± 1.0% | 13017.29 ± 1.1% | 109.21 ± 0.4% | 0.70 | 1.00 | 7.20 | 0.25 |
| other: a Greek word | 8 | 437.48 ± 0.4% | 606.07 ± 0.5% | 1049.58 ± 0.2% | 59.22 ± 0.6% | 1352.90 ± 0.2% | 1785.90 ± 0.4% | refused | 437.56 ± 0.5% | 0.72 | 1.00 | 7.39 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12574.16 ± 1.1% | not timed | not timed | 15703.54 ± 1.0% | 2153.11 ± 16.3% | not timed | not timed | 12549.47 ± 0.9% | | 1.00 | 0.80 | 5.84 |
| 01-literal/sherlock-casei-en | 522 | 4943.33 ± 0.8% | not timed | not timed | 3592.51 ± 0.1% | 32.00 ± 2.8% | not timed | not timed | 4950.83 ± 0.2% | | 1.00 | 1.38 | 154.49 |
| 01-literal/sherlock-ru | 724 | 13451.65 ± 0.5% | not timed | not timed | 17189.25 ± 1.0% | 1349.31 ± 21.6% | not timed | not timed | 13434.73 ± 0.6% | | 1.00 | 0.78 | 9.97 |
| 01-literal/sherlock-casei-ru | 746 | 5971.91 ± 0.4% | not timed | not timed | 3322.41 ± 0.2% | 31.29 ± 0.6% | not timed | not timed | 5972.69 ± 0.2% | | 1.00 | 1.80 | 190.83 |
| 01-literal/sherlock-zh | 30 | 16751.11 ± 0.2% | not timed | not timed | 18211.72 ± 0.3% | 2706.22 ± 7.1% | not timed | not timed | 16713.55 ± 0.2% | | 1.00 | 0.92 | 6.19 |
| 02-literal-alternate/sherlock-en | 714 | 5744.97 ± 0.6% | not timed | not timed | 3943.32 ± 0.2% | 16.59 ± 0.2% | not timed | not timed | 5768.37 ± 0.2% | | 1.00 | 1.46 | 346.29 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1805.35 ± 1.4% | not timed | not timed | 694.86 ± 0.3% | 11.05 ± 0.2% | not timed | not timed | 1794.24 ± 0.4% | | 1.01 | 2.60 | 163.38 |
| 02-literal-alternate/sherlock-ru | 899 | 5331.59 ± 0.1% | not timed | not timed | 3263.57 ± 0.2% | 22.68 ± 13.1% | not timed | not timed | 5335.54 ± 0.3% | | 1.00 | 1.63 | 235.11 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1917.04 ± 0.6% | not timed | not timed | 1231.90 ± 0.2% | 9.14 ± 0.1% | not timed | not timed | 1909.06 ± 0.1% | | 1.00 | 1.56 | 209.67 |
| 02-literal-alternate/sherlock-zh | 207 | 7002.02 ± 0.3% | not timed | not timed | 4156.92 ± 0.2% | 31.46 ± 0.1% | not timed | not timed | 7033.11 ± 0.4% | | 1.00 | 1.68 | 222.58 |
| 03-date/ascii | 111817 | 126.58 ± 0.7% | not timed | not timed | 96.00 ± 0.3% | 0.20 ± 5.4% | not timed | not timed | 125.82 ± 0.4% | | 1.01 | 1.32 | 625.83 |
| 04-ruff-noqa/real | 84 | 408.13 ± 0.2% | not timed | not timed | 472.36 ± 0.1% | 19.06 ± 1.2% | not timed | not timed | 407.56 ± 0.0% | | 1.00 | 0.86 | 21.41 |
| 04-ruff-noqa/tweaked | 44 | 550.66 ± 0.1% | not timed | not timed | 463.13 ± 0.2% | 361.37 ± 0.4% | not timed | not timed | 550.27 ± 0.2% | | 1.00 | 1.19 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.35 ± 0.3% | not timed | not timed | 5.23 ± 0.1% | 0.21 ± 3.4% | not timed | not timed | 5.36 ± 6.9% | | 1.00 | 1.02 | 26.04 |
| 06-cloud-flare-redos/original | 107 | 414.84 ± 1.8% | not timed | not timed | 214.66 ± 0.3% | 24.27 ± 4.9% | not timed | not timed | 414.14 ± 6.9% | | 1.00 | 1.93 | 17.09 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.74 ± 0.3% | not timed | not timed | 226.44 ± 0.1% | 26.69 ± 3.3% | not timed | not timed | 409.67 ± 0.6% | | 1.00 | 1.81 | 15.39 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.84 ± 0.2% | not timed | not timed | 253.56 ± 0.1% | 28.83 ± 0.1% | not timed | not timed | 586.66 ± 0.1% | | 1.00 | 2.32 | 20.39 |
| 07-unicode-character-data/parse-line | 558784 | 231.02 ± 0.3% | not timed | not timed | 178.98 ± 0.1% | 42.15 ± 2.9% | not timed | not timed | 232.84 ± 0.4% | | 0.99 | 1.29 | 5.48 |
| 08-words/all-english | 56691 | 116.93 ± 0.4% | not timed | not timed | 83.06 ± 0.3% | 12.64 ± 4.2% | not timed | not timed | 116.61 ± 0.8% | | 1.00 | 1.41 | 9.25 |
| 08-words/long-english | 839 | 621.00 ± 0.2% | not timed | not timed | 597.65 ± 0.1% | 32.21 ± 0.2% | not timed | not timed | 621.15 ± 0.2% | | 1.00 | 1.04 | 19.28 |
| 09-aws-keys/full | 0 | 414.12 ± 0.1% | not timed | not timed | 495.90 ± 0.1% | 64.60 ± 0.3% | not timed | not timed | 414.18 ± 0.0% | | 1.00 | 0.84 | 6.41 |
| 09-aws-keys/quick | 0 | 728.55 ± 0.1% | not timed | not timed | 998.43 ± 0.4% | 413.35 ± 1.2% | not timed | not timed | 726.29 ± 0.1% | | 1.00 | 0.73 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 581.01 ± 1.8% | not timed | not timed | 518.15 ± 0.3% | 19.55 ± 0.5% | not timed | not timed | 578.05 ± 0.9% | | 1.01 | 1.12 | 29.73 |
| 10-bounded-repeat/letters-ru | 3475 | 487.19 ± 0.9% | not timed | not timed | 478.16 ± 0.3% | 21.87 ± 11.4% | not timed | not timed | 508.17 ± 1.2% | | 0.96 | 1.02 | 22.28 |
| 10-bounded-repeat/context | 53 | 76.95 ± 0.4% | not timed | not timed | 65.22 ± 0.6% | 19.79 ± 0.2% | not timed | not timed | 76.05 ± 0.9% | | 1.01 | 1.18 | 3.89 |
| 10-bounded-repeat/capitals | 11 | 631.16 ± 8.3% | not timed | not timed | 615.21 ± 0.1% | 36.65 ± 0.1% | not timed | not timed | 630.61 ± 8.4% | | 1.00 | 1.03 | 17.22 |
| 11-unstructured-to-json/extract | 600 | 79.56 ± 0.1% | not timed | not timed | 76.59 ± 0.3% | 48.95 ± 0.6% | not timed | not timed | 82.64 ± 0.7% | | 0.96 | 1.04 | 1.63 |
| 12-dictionary/single | 1 | 561.11 ± 0.5% | not timed | not timed | 554.76 ± 0.3% | 0.41 ± 0.1% | not timed | not timed | 559.82 ± 0.6% | | 1.00 | 1.01 | 1382.43 |
| 14-quadratic/1x | 100 | 21.09 ± 0.7% | not timed | not timed | 10.01 ± 0.2% | 0.96 ± 3.1% | not timed | not timed | 21.01 ± 2.9% | | 1.00 | 2.11 | 21.96 |
| 14-quadratic/2x | 200 | 17.63 ± 3.4% | not timed | not timed | 5.53 ± 0.2% | 0.53 ± 1.5% | not timed | not timed | 17.53 ± 3.0% | | 1.01 | 3.19 | 33.39 |
| 14-quadratic/10x | 1000 | 7.71 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.8% | not timed | not timed | 7.69 ± 0.3% | | 1.00 | 6.35 | 66.83 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.29 ± 0.4% | not timed | not timed | 0.34 ± 0.5% | 0.53 ± 28.8% | not timed | not timed | 1.28 ± 3.1% | | 1.00 | 3.79 | 2.44 |
| 04-ruff-noqa/compile-real | 1 | 89.25 ± 0.2% | not timed | not timed | 13.98 ± 0.5% | 133.69 ± 2.4% | not timed | not timed | 89.10 ± 1.3% | | 1.00 | 6.38 | 0.67 |
| 05-lexer-veryl/compile-single | 1 | 13.97 ± 0.2% | not timed | not timed | 2.53 ± 0.2% | 6.20 ± 4.9% | not timed | not timed | 13.84 ± 1.5% | | 1.01 | 5.53 | 2.25 |
| 07-unicode-character-data/compile | 1 | 55.31 ± 0.2% | not timed | not timed | 26.17 ± 0.2% | 34.58 ± 4.1% | not timed | not timed | 54.94 ± 1.0% | | 1.01 | 2.11 | 1.60 |
| 09-aws-keys/compile-full | 1 | 42.12 ± 0.2% | not timed | not timed | 8.31 ± 0.3% | 22.70 ± 1.9% | not timed | not timed | 41.61 ± 0.6% | | 1.01 | 5.07 | 1.85 |
| 09-aws-keys/compile-quick | 1 | 182.32 ± 0.3% | not timed | not timed | 47.89 ± 0.2% | 126.69 ± 9.8% | not timed | not timed | 180.18 ± 1.5% | | 1.01 | 3.81 | 1.44 |
| 10-bounded-repeat/compile-context | 1 | 13.74 ± 0.9% | not timed | not timed | 11.16 ± 0.2% | 15.68 ± 3.8% | not timed | not timed | 13.75 ± 0.8% | | 1.00 | 1.23 | 0.88 |
| 10-bounded-repeat/compile-capitals | 1 | 82.68 ± 0.5% | not timed | not timed | 8.01 ± 0.2% | 23.06 ± 2.2% | not timed | not timed | 82.79 ± 0.3% | | 1.00 | 10.32 | 3.59 |
| 11-unstructured-to-json/compile | 1 | 86.54 ± 0.3% | not timed | not timed | 41.20 ± 0.4% | 63.27 ± 4.3% | not timed | not timed | 85.34 ± 0.9% | | 1.01 | 2.10 | 1.37 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.4% | not timed | not timed | 0.07 ± 40.7% | 0.09 ± 3.1% | not timed | not timed | 0.35 ± 0.5% | | 1.01 | 5.36 | 3.83 |

