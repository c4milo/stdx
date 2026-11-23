# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117651666 |
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
| literal: a word | 217 | 15997.95 ± 0.9% | 1036.63 ± 0.1% | 28.55 ± 0.3% | 17917.86 ± 0.8% | 9145.52 ± 7.5% | 17.54 ± 0.4% | 86.73 ± 0.1% | 16007.05 ± 1.2% | 15.43 | 1.00 | 0.89 | 1.75 |
| literal: a word that is not there | 0 | 18703.74 ± 1.1% | 1047.27 ± 0.1% | 28.53 ± 0.3% | 19420.13 ± 1.0% | 28545.00 ± 1.0% | 17.35 ± 0.2% | 82.47 ± 0.3% | 18737.76 ± 1.6% | 17.86 | 1.00 | 0.96 | 0.66 |
| literal: one of four words | 661 | 6080.47 ± 0.3% | 1014.61 ± 0.1% | 14.59 ± 0.4% | 3944.20 ± 0.1% | 21.87 ± 0.1% | 5.29 ± 0.2% | 6.89 ± 0.7% | 6076.31 ± 0.4% | 5.99 | 1.00 | 1.54 | 278.02 |
| literal: a word in any case | 217 | 12465.58 ± 0.9% | 1037.62 ± 0.1% | 21.71 ± 0.8% | 3964.52 ± 0.2% | 38.04 ± 0.6% | refused | differs | 12482.86 ± 0.2% | 12.01 | 1.00 | 3.14 | 327.66 |
| literal: an href attribute | 33 | 13832.21 ± 1.4% | 1046.28 ± 0.1% | 27.24 ± 0.2% | 17056.59 ± 2.0% | 2251.73 ± 0.5% | 13.40 ± 0.3% | 75.68 ± 0.2% | 13834.75 ± 0.7% | 13.22 | 1.00 | 0.81 | 6.14 |
| literal: a word, second text | 123 | 16447.51 ± 0.5% | 1042.28 ± 0.1% | 28.04 ± 0.2% | 18261.80 ± 1.0% | 7771.62 ± 6.5% | 19.69 ± 0.5% | 69.72 ± 0.2% | 16467.66 ± 3.3% | 15.78 | 1.00 | 0.90 | 2.12 |
| class: two capitalized words | 1331 | 1122.75 ± 0.7% | 953.35 ± 0.3% | 26.03 ± 0.3% | 585.42 ± 0.1% | 40.68 ± 8.7% | 14.90 ± 0.2% | 68.97 ± 0.3% | 1123.73 ± 0.6% | 1.18 | 1.00 | 1.92 | 27.60 |
| class: a word that ends in ing | 3399 | 874.53 ± 0.1% | 876.58 ± 0.1% | 18.04 ± 0.3% | 547.94 ± 0.2% | 29.68 ± 9.5% | 8.21 ± 0.1% | 18.39 ± 1.0% | 875.67 ± 0.1% | 1.00 | 1.00 | 1.60 | 29.47 |
| class: a word in capitals | 2332 | 1454.68 ± 0.9% | 936.55 ± 0.4% | 27.57 ± 0.3% | 572.66 ± 0.1% | 43.69 ± 10.2% | 17.16 ± 0.3% | 83.18 ± 0.3% | 1458.33 ± 1.4% | 1.55 | 1.00 | 2.54 | 33.30 |
| class: a number | 8288 | 1993.82 ± 0.3% | 786.30 ± 0.0% | 27.86 ± 0.3% | 1731.71 ± 0.2% | 38.89 ± 14.4% | 0.56 ± 0.2% | 56.64 ± 0.7% | 1993.19 ± 0.1% | 2.54 | 1.00 | 1.15 | 51.27 |
| class: two capitalized words, second text | 5359 | 682.94 ± 0.2% | 678.71 ± 0.1% | 23.29 ± 0.2% | 484.98 ± 0.5% | 35.48 ± 15.3% | 16.71 ± 0.3% | 64.00 ± 0.2% | 682.34 ± 0.2% | 1.01 | 1.00 | 1.41 | 19.25 |
| other: a word between two words | 6104 | 767.44 ± 0.2% | 738.11 ± 0.1% | 23.48 ± 0.2% | 734.07 ± 0.1% | 108.56 ± 16.4% | 11.30 ± 0.1% | 69.75 ± 0.2% | 767.15 ± 0.4% | 1.04 | 1.00 | 1.05 | 7.07 |
| other: a number before a unit, second text | 1481 | 5636.60 ± 0.9% | 973.43 ± 0.2% | 25.88 ± 0.2% | 5678.81 ± 0.6% | 40.83 ± 0.1% | 17.83 ± 0.1% | 66.92 ± 0.2% | 5622.87 ± 1.5% | 5.79 | 1.00 | 0.99 | 138.06 |
| other: a heading's start tag | 110 | 12684.72 ± 0.5% | 1028.59 ± 0.4% | 27.41 ± 0.2% | 1710.62 ± 0.5% | 1565.34 ± 3.7% | 16.31 ± 0.4% | 88.91 ± 0.4% | 12692.08 ± 0.6% | 12.33 | 1.00 | 7.42 | 8.10 |
| other: a whole word | 217 | 13917.83 ± 0.8% | 1035.67 ± 0.2% | 29.41 ± 0.5% | 14379.19 ± 0.6% | 49.40 ± 0.3% | 13.68 ± 0.3% | 55.87 ± 0.1% | 13949.00 ± 1.4% | 13.44 | 1.00 | 0.97 | 281.74 |
| other: a line's first word, second text | 3716 | 1984.77 ± 0.4% | 855.77 ± 0.2% | 31.17 ± 0.1% | 1729.02 ± 0.4% | 62.09 ± 7.7% | refused | refused | 1969.74 ± 0.4% | 2.32 | 1.01 | 1.15 | 31.97 |
| other: fourteen octets before an x | 87 | 19702.20 ± 1.5% | 250.68 ± 0.3% | 6.12 ± 0.1% | 4055.21 ± 0.3% | 10.63 ± 0.1% | differs | 17.75 ± 0.2% | 19641.00 ± 0.7% | 78.59 | 1.00 | 4.86 | 1853.75 |
| other: a Greek word | 21815 | 486.12 ± 0.6% | 307.81 ± 0.4% | 30.99 ± 0.5% | 289.73 ± 0.2% | 49.32 ± 10.9% | differs | refused | 485.42 ± 0.5% | 1.58 | 1.00 | 1.68 | 9.86 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.88 ± 0.2% | 25.89 ± 0.2% | 0.82 ± 0.4% | 19.61 ± 0.4% | 2.78 ± 0.3% | differs | 4.00 ± 0.3% | 25.88 ± 0.2% | 1.00 | 1.00 | 1.32 | 9.31 |
| a UUID | 32895 | 21.08 ± 0.1% | 21.20 ± 0.2% | 0.64 ± 0.1% | 15.07 ± 0.6% | 3.11 ± 0.4% | 0.72 ± 0.5% | 3.60 ± 0.2% | 21.16 ± 0.4% | 0.99 | 1.00 | 1.40 | 6.78 |
| an IPv4 address | 33176 | 36.89 ± 0.1% | 36.78 ± 0.2% | 2.09 ± 0.3% | 29.12 ± 0.3% | 6.69 ± 0.3% | differs | 4.14 ± 0.3% | 36.88 ± 0.1% | 1.00 | 1.00 | 1.27 | 5.52 |
| a date and time | 32954 | 31.06 ± 0.1% | 31.12 ± 0.3% | 1.46 ± 0.1% | 21.25 ± 0.7% | 7.06 ± 0.2% | 1.20 ± 0.1% | 7.09 ± 0.7% | 31.08 ± 0.5% | 1.00 | 1.00 | 1.46 | 4.40 |
| a field path | 32606 | 29.40 ± 0.4% | 29.27 ± 0.2% | 1.00 ± 0.3% | 23.17 ± 0.4% | 3.49 ± 0.5% | differs | 2.95 ± 0.1% | 29.41 ± 0.2% | 1.00 | 1.00 | 1.27 | 8.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.65 ± 0.4% | 11.64 ± 0.9% | 11.67 ± 1.2% | 11.37 ± 0.1% | 4.91 ± 0.8% | 0.91 ± 0.8% | none | 11.63 ± 0.4% | 1.00 | 1.00 | 1.02 | 2.37 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 216.16 ± 0.2% | 216.89 ± 0.4% | 251.22 ± 0.4% | 87.44 ± 0.7% | 219.61 ± 2.2% | 472.17 ± 0.4% | 3844.56 ± 3.9% | 215.62 ± 0.1% | 1.00 | 1.00 | 2.47 | 0.98 |
| a UUID | 62 | 142.01 ± 0.2% | 142.52 ± 0.1% | 156.60 ± 0.4% | 46.21 ± 0.8% | 98.62 ± 1.2% | 192.06 ± 2.9% | 4391.31 ± 1.2% | 141.83 ± 0.2% | 1.00 | 1.00 | 3.07 | 1.44 |
| an IPv4 address | 29 | 436.37 ± 0.3% | 439.69 ± 0.4% | 609.45 ± 0.6% | 77.67 ± 0.4% | 129.94 ± 1.1% | 302.48 ± 0.7% | 7538.61 ± 0.1% | 435.42 ± 0.2% | 0.99 | 1.00 | 5.62 | 3.36 |
| a date and time | 56 | 317.52 ± 0.5% | 319.95 ± 0.3% | 400.59 ± 0.2% | 72.71 ± 0.4% | 136.24 ± 1.9% | 334.67 ± 0.7% | 4870.09 ± 0.2% | 317.17 ± 0.4% | 0.99 | 1.00 | 4.37 | 2.33 |
| a field path | 39 | 202.10 ± 0.6% | 202.97 ± 0.5% | 232.48 ± 0.4% | 80.17 ± 1.6% | 203.42 ± 1.7% | 499.67 ± 4.8% | 4891.19 ± 1.8% | 201.92 ± 0.4% | 1.00 | 1.00 | 2.52 | 0.99 |
| literal: a word | 7 | 663.70 ± 0.3% | 718.00 ± 0.8% | 1275.47 ± 0.2% | 498.33 ± 0.2% | 626.62 ± 2.0% | 953.65 ± 0.4% | 31178.92 ± 0.1% | 662.25 ± 0.3% | 0.92 | 1.00 | 1.33 | 1.06 |
| literal: a word that is not there | 8 | 633.61 ± 0.2% | 689.91 ± 0.4% | 1198.37 ± 0.1% | 459.15 ± 0.5% | 603.29 ± 1.5% | 899.98 ± 0.3% | 29540.39 ± 0.1% | 632.69 ± 0.3% | 0.92 | 1.00 | 1.38 | 1.05 |
| literal: one of four words | 26 | 254.92 ± 0.4% | 419.60 ± 0.4% | 565.33 ± 0.2% | 50.38 ± 0.6% | 237.73 ± 2.4% | 370.15 ± 0.5% | 15808.17 ± 0.4% | 255.30 ± 0.2% | 0.61 | 1.00 | 5.06 | 1.07 |
| literal: a word in any case | 11 | 515.15 ± 0.4% | 557.61 ± 0.2% | 853.82 ± 0.2% | 15.36 ± 0.2% | 645.75 ± 1.5% | refused | 23673.14 ± 0.1% | 514.68 ± 0.6% | 0.92 | 1.00 | 33.53 | 0.80 |
| literal: an href attribute | 12 | 348.57 ± 0.2% | 360.02 ± 0.4% | 466.62 ± 0.3% | 45.61 ± 1.1% | 496.82 ± 1.9% | 774.62 ± 0.4% | 21760.49 ± 0.5% | 348.12 ± 0.3% | 0.97 | 1.00 | 7.64 | 0.70 |
| literal: a word, second text | 10 | 589.05 ± 0.4% | 652.11 ± 0.4% | 1084.43 ± 0.6% | 404.76 ± 1.2% | 532.91 ± 1.3% | 803.93 ± 0.5% | 27449.94 ± 0.1% | 588.29 ± 0.5% | 0.90 | 1.00 | 1.46 | 1.11 |
| class: two capitalized words | 23 | 459.11 ± 0.4% | 490.21 ± 0.3% | 709.39 ± 0.4% | 103.13 ± 0.1% | 494.47 ± 1.8% | 741.47 ± 1.2% | 6552.27 ± 0.2% | 457.76 ± 0.3% | 0.94 | 1.00 | 4.45 | 0.93 |
| class: a word that ends in ing | 9 | 595.88 ± 0.3% | 666.06 ± 0.9% | 1165.69 ± 0.4% | 131.96 ± 0.4% | 759.88 ± 1.9% | 1100.53 ± 1.2% | 16193.18 ± 0.3% | 594.54 ± 0.4% | 0.89 | 1.00 | 4.52 | 0.78 |
| class: a word in capitals | 16 | 520.90 ± 0.6% | 561.03 ± 0.8% | 890.38 ± 0.5% | 135.57 ± 0.5% | 753.90 ± 1.9% | 1042.96 ± 0.9% | 8579.23 ± 0.5% | 520.04 ± 0.4% | 0.93 | 1.00 | 3.84 | 0.69 |
| class: a number | 6 | 658.35 ± 0.2% | 722.95 ± 0.3% | 1341.70 ± 0.1% | 41.61 ± 0.7% | 1403.17 ± 2.5% | 1834.73 ± 1.9% | 22393.96 ± 0.2% | 657.81 ± 0.2% | 0.91 | 1.00 | 15.82 | 0.47 |
| class: two capitalized words, second text | 23 | 459.08 ± 0.4% | 489.37 ± 0.3% | 707.48 ± 0.3% | 100.16 ± 0.2% | 495.98 ± 3.0% | 733.22 ± 3.1% | 6552.79 ± 0.1% | 458.34 ± 0.3% | 0.94 | 1.00 | 4.58 | 0.93 |
| other: a word between two words | 13 | 582.07 ± 0.7% | 602.63 ± 0.4% | 955.10 ± 0.1% | 132.66 ± 0.8% | 500.46 ± 11.2% | 808.66 ± 0.6% | 14948.37 ± 0.5% | 580.22 ± 0.6% | 0.97 | 1.00 | 4.39 | 1.16 |
| other: a number before a unit, second text | 15 | 400.16 ± 0.2% | 436.55 ± 0.2% | 595.44 ± 0.2% | 39.30 ± 0.6% | 631.52 ± 1.4% | 888.39 ± 0.4% | 15261.55 ± 0.2% | 399.77 ± 0.2% | 0.92 | 1.00 | 10.18 | 0.63 |
| other: a heading's start tag | 13 | 358.82 ± 0.3% | 364.10 ± 0.1% | 473.64 ± 0.3% | 43.95 ± 0.2% | 626.11 ± 3.8% | 872.64 ± 1.5% | 18193.98 ± 0.5% | 358.39 ± 0.3% | 0.99 | 1.00 | 8.16 | 0.57 |
| other: a whole word | 11 | 614.00 ± 0.2% | 655.03 ± 0.5% | 1082.31 ± 0.1% | 119.35 ± 0.7% | 561.90 ± 1.6% | 819.67 ± 0.5% | 27212.24 ± 0.3% | 613.59 ± 0.1% | 0.94 | 1.00 | 5.14 | 1.09 |
| other: a line's first word, second text | 17 | 555.17 ± 0.2% | 578.75 ± 0.6% | 921.25 ± 0.1% | 129.48 ± 0.4% | 698.12 ± 0.5% | refused | refused | 552.92 ± 1.1% | 0.96 | 1.00 | 4.29 | 0.80 |
| other: fourteen octets before an x | 16 | 109.76 ± 0.5% | 157.73 ± 0.8% | 178.55 ± 0.3% | 15.16 ± 0.3% | 441.77 ± 9.1% | 412.48 ± 0.9% | 12561.76 ± 1.0% | 109.47 ± 0.4% | 0.70 | 1.00 | 7.24 | 0.25 |
| other: a Greek word | 8 | 450.26 ± 0.2% | 594.16 ± 0.6% | 965.74 ± 0.1% | 59.00 ± 0.7% | 1368.77 ± 1.7% | 1811.12 ± 0.6% | refused | 449.01 ± 0.3% | 0.76 | 1.00 | 7.63 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12943.39 ± 0.5% | not timed | not timed | 16351.91 ± 1.5% | 2154.50 ± 15.1% | not timed | not timed | 12956.63 ± 0.8% | | 1.00 | 0.79 | 6.01 |
| 01-literal/sherlock-casei-en | 522 | 3909.65 ± 0.5% | not timed | not timed | 3596.24 ± 0.2% | 32.38 ± 12.4% | not timed | not timed | 3896.17 ± 0.6% | | 1.00 | 1.09 | 120.76 |
| 01-literal/sherlock-ru | 724 | 13651.22 ± 0.5% | not timed | not timed | 17329.00 ± 0.4% | 1348.08 ± 7.6% | not timed | not timed | 13626.49 ± 0.2% | | 1.00 | 0.79 | 10.13 |
| 01-literal/sherlock-casei-ru | 746 | 5313.82 ± 0.3% | not timed | not timed | 3325.62 ± 0.1% | 30.75 ± 0.4% | not timed | not timed | 5313.32 ± 0.2% | | 1.00 | 1.60 | 172.80 |
| 01-literal/sherlock-zh | 30 | 17061.95 ± 0.4% | not timed | not timed | 18674.57 ± 0.8% | 2696.51 ± 3.0% | not timed | not timed | 17059.95 ± 0.2% | | 1.00 | 0.91 | 6.33 |
| 02-literal-alternate/sherlock-en | 714 | 5817.17 ± 0.4% | not timed | not timed | 3938.04 ± 0.2% | 16.63 ± 6.1% | not timed | not timed | 5815.59 ± 0.4% | | 1.00 | 1.48 | 349.71 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1682.60 ± 0.5% | not timed | not timed | 696.23 ± 0.2% | 11.02 ± 0.1% | not timed | not timed | 1674.18 ± 0.5% | | 1.01 | 2.42 | 152.73 |
| 02-literal-alternate/sherlock-ru | 899 | 4721.54 ± 0.1% | not timed | not timed | 3256.20 ± 0.1% | 22.65 ± 0.2% | not timed | not timed | 4715.05 ± 0.4% | | 1.00 | 1.45 | 208.49 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1798.10 ± 0.5% | not timed | not timed | 1233.10 ± 0.1% | 9.07 ± 0.2% | not timed | not timed | 1792.48 ± 0.1% | | 1.00 | 1.46 | 198.15 |
| 02-literal-alternate/sherlock-zh | 207 | 7063.12 ± 0.3% | not timed | not timed | 4164.89 ± 0.1% | 31.53 ± 0.1% | not timed | not timed | 7061.65 ± 0.3% | | 1.00 | 1.70 | 224.01 |
| 03-date/ascii | 111817 | 123.60 ± 0.6% | not timed | not timed | 96.09 ± 0.1% | 0.20 ± 3.1% | not timed | not timed | 122.85 ± 0.2% | | 1.01 | 1.29 | 620.20 |
| 04-ruff-noqa/real | 84 | 555.44 ± 0.0% | not timed | not timed | 463.86 ± 0.1% | 19.92 ± 1.3% | not timed | not timed | 555.15 ± 0.0% | | 1.00 | 1.20 | 27.89 |
| 04-ruff-noqa/tweaked | 44 | 558.68 ± 0.3% | not timed | not timed | 459.91 ± 0.1% | 365.82 ± 1.5% | not timed | not timed | 559.43 ± 0.2% | | 1.00 | 1.21 | 1.53 |
| 05-lexer-veryl/single | 124800 | 3.68 ± 0.8% | not timed | not timed | 5.02 ± 0.2% | 0.20 ± 3.0% | not timed | not timed | 3.71 ± 2.3% | | 0.99 | 0.73 | 18.06 |
| 06-cloud-flare-redos/original | 107 | 183.35 ± 0.5% | not timed | not timed | 217.78 ± 0.0% | 25.02 ± 0.2% | not timed | not timed | 183.95 ± 0.5% | | 1.00 | 0.84 | 7.33 |
| 06-cloud-flare-redos/simplified-short | 102 | 142.35 ± 0.1% | not timed | not timed | 229.12 ± 0.1% | 26.80 ± 0.2% | not timed | not timed | 144.78 ± 0.2% | | 0.98 | 0.62 | 5.31 |
| 06-cloud-flare-redos/simplified-long | 10000 | 154.90 ± 2.3% | not timed | not timed | 254.58 ± 0.2% | 28.80 ± 0.1% | not timed | not timed | 154.58 ± 2.4% | | 1.00 | 0.61 | 5.38 |
| 07-unicode-character-data/parse-line | 558784 | 242.33 ± 0.4% | not timed | not timed | 173.07 ± 0.2% | 42.53 ± 5.5% | not timed | not timed | 237.79 ± 2.4% | | 1.02 | 1.40 | 5.70 |
| 08-words/all-english | 56691 | 103.00 ± 0.6% | not timed | not timed | 82.87 ± 0.1% | 11.72 ± 5.2% | not timed | not timed | 102.39 ± 0.4% | | 1.01 | 1.24 | 8.79 |
| 08-words/long-english | 839 | 999.32 ± 0.1% | not timed | not timed | 596.06 ± 0.1% | 32.62 ± 0.1% | not timed | not timed | 998.77 ± 0.1% | | 1.00 | 1.68 | 30.64 |
| 09-aws-keys/full | 0 | 424.31 ± 0.1% | not timed | not timed | 464.26 ± 0.1% | 64.73 ± 0.1% | not timed | not timed | 423.97 ± 0.1% | | 1.00 | 0.91 | 6.56 |
| 09-aws-keys/quick | 0 | 736.59 ± 0.1% | not timed | not timed | 985.65 ± 0.4% | 415.05 ± 1.8% | not timed | not timed | 732.49 ± 0.2% | | 1.01 | 0.75 | 1.77 |
| 10-bounded-repeat/letters-en | 1833 | 586.61 ± 0.4% | not timed | not timed | 517.30 ± 0.7% | 19.44 ± 0.7% | not timed | not timed | 585.60 ± 0.2% | | 1.00 | 1.13 | 30.17 |
| 10-bounded-repeat/letters-ru | 3475 | 401.72 ± 0.1% | not timed | not timed | 479.01 ± 0.2% | 22.62 ± 18.3% | not timed | not timed | 400.55 ± 0.8% | | 1.00 | 0.84 | 17.76 |
| 10-bounded-repeat/context | 53 | 80.06 ± 1.0% | not timed | not timed | 66.13 ± 0.8% | 19.79 ± 0.2% | not timed | not timed | 80.13 ± 1.0% | | 1.00 | 1.21 | 4.04 |
| 10-bounded-repeat/capitals | 11 | 1047.76 ± 0.1% | not timed | not timed | 616.84 ± 0.1% | 36.74 ± 0.1% | not timed | not timed | 1047.21 ± 0.1% | | 1.00 | 1.70 | 28.52 |
| 11-unstructured-to-json/extract | 600 | 48.26 ± 0.1% | not timed | not timed | 77.69 ± 0.5% | 48.82 ± 0.1% | not timed | not timed | 47.03 ± 0.8% | | 1.03 | 0.62 | 0.99 |
| 12-dictionary/single | 1 | 604.03 ± 0.3% | not timed | not timed | 559.88 ± 0.0% | 0.41 ± 0.1% | not timed | not timed | 603.77 ± 0.3% | | 1.00 | 1.08 | 1476.28 |
| 14-quadratic/1x | 100 | 12.57 ± 0.3% | not timed | not timed | 10.01 ± 0.3% | 0.96 ± 2.6% | not timed | not timed | 12.53 ± 1.3% | | 1.00 | 1.26 | 13.04 |
| 14-quadratic/2x | 200 | 7.83 ± 0.3% | not timed | not timed | 5.54 ± 0.3% | 0.53 ± 2.0% | not timed | not timed | 7.81 ± 0.4% | | 1.00 | 1.41 | 14.77 |
| 14-quadratic/10x | 1000 | 1.87 ± 0.2% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 2.2% | not timed | not timed | 1.87 ± 0.4% | | 1.00 | 1.54 | 16.15 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.54 ± 0.2% | not timed | not timed | 0.35 ± 0.3% | 0.55 ± 5.4% | not timed | not timed | 1.53 ± 0.9% | | 1.01 | 4.45 | 2.82 |
| 04-ruff-noqa/compile-real | 1 | 85.37 ± 0.2% | not timed | not timed | 13.69 ± 0.2% | 138.57 ± 2.6% | not timed | not timed | 85.04 ± 0.8% | | 1.00 | 6.23 | 0.62 |
| 05-lexer-veryl/compile-single | 1 | 14.49 ± 2.0% | not timed | not timed | 2.54 ± 0.7% | 6.38 ± 1.9% | not timed | not timed | 14.44 ± 0.7% | | 1.00 | 5.71 | 2.27 |
| 07-unicode-character-data/compile | 1 | 55.02 ± 0.2% | not timed | not timed | 25.58 ± 0.6% | 35.95 ± 3.6% | not timed | not timed | 54.53 ± 1.4% | | 1.01 | 2.15 | 1.53 |
| 09-aws-keys/compile-full | 1 | 42.15 ± 0.2% | not timed | not timed | 8.26 ± 0.3% | 23.09 ± 6.3% | not timed | not timed | 41.91 ± 3.1% | | 1.01 | 5.11 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 189.05 ± 0.2% | not timed | not timed | 46.32 ± 0.3% | 131.81 ± 3.1% | not timed | not timed | 187.94 ± 1.7% | | 1.01 | 4.08 | 1.43 |
| 10-bounded-repeat/compile-context | 1 | 14.51 ± 3.1% | not timed | not timed | 11.13 ± 0.1% | 16.04 ± 3.2% | not timed | not timed | 14.30 ± 2.7% | | 1.01 | 1.30 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 85.13 ± 1.1% | not timed | not timed | 7.98 ± 0.5% | 23.81 ± 1.5% | not timed | not timed | 84.23 ± 1.3% | | 1.01 | 10.67 | 3.58 |
| 11-unstructured-to-json/compile | 1 | 86.32 ± 0.3% | not timed | not timed | 41.27 ± 0.5% | 68.11 ± 1.9% | not timed | not timed | 86.02 ± 0.8% | | 1.00 | 2.09 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 35.2% | 0.10 ± 21.9% | not timed | not timed | 0.36 ± 1.4% | | 1.01 | 5.27 | 3.64 |

