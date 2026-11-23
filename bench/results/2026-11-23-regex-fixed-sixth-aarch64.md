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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159268337 |
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
| literal: a word | 217 | 16037.73 ± 1.7% | 1049.11 ± 0.1% | 28.71 ± 0.6% | 18181.95 ± 4.5% | 9286.70 ± 7.0% | 17.19 ± 0.2% | 86.53 ± 0.5% | 16184.87 ± 1.5% | 15.29 | 0.99 | 0.88 | 1.73 |
| literal: a word that is not there | 0 | 18639.37 ± 3.6% | 1056.00 ± 0.2% | 28.75 ± 0.7% | 19600.33 ± 2.2% | 29010.80 ± 0.6% | 17.06 ± 0.1% | 82.36 ± 0.2% | 18764.10 ± 2.1% | 17.65 | 0.99 | 0.95 | 0.64 |
| literal: one of four words | 661 | 6062.45 ± 0.4% | 1030.80 ± 0.1% | 14.69 ± 1.0% | 3946.40 ± 0.1% | 21.90 ± 0.1% | 5.35 ± 0.0% | 6.93 ± 0.4% | 6056.79 ± 0.5% | 5.88 | 1.00 | 1.54 | 276.86 |
| literal: a word in any case | 217 | 12583.12 ± 0.5% | 1048.40 ± 0.3% | 21.90 ± 0.3% | 3971.92 ± 0.2% | 38.09 ± 0.6% | refused | differs | 12574.40 ± 0.1% | 12.00 | 1.00 | 3.17 | 330.34 |
| literal: an href attribute | 33 | 13388.39 ± 1.5% | 1054.46 ± 0.2% | 27.33 ± 0.2% | 16797.04 ± 2.9% | 2261.17 ± 0.7% | 13.11 ± 0.3% | 75.37 ± 0.2% | 13415.93 ± 1.0% | 12.70 | 1.00 | 0.80 | 5.92 |
| literal: a word, second text | 123 | 16303.49 ± 0.7% | 1050.94 ± 0.3% | 28.18 ± 0.2% | 18278.58 ± 1.3% | 7719.20 ± 6.4% | 20.15 ± 0.3% | 70.22 ± 0.3% | 16320.79 ± 0.5% | 15.51 | 1.00 | 0.89 | 2.11 |
| class: two capitalized words | 1331 | 1123.83 ± 0.4% | 979.71 ± 0.1% | 26.10 ± 0.2% | 585.21 ± 0.1% | 40.58 ± 12.5% | 14.68 ± 0.2% | 68.80 ± 0.4% | 1123.75 ± 0.3% | 1.15 | 1.00 | 1.92 | 27.69 |
| class: a word that ends in ing | 3399 | 901.56 ± 0.1% | 901.63 ± 0.1% | 18.20 ± 0.4% | 547.58 ± 0.3% | 29.49 ± 5.9% | 8.15 ± 0.2% | 18.39 ± 0.9% | 885.70 ± 0.2% | 1.00 | 1.02 | 1.65 | 30.58 |
| class: a word in capitals | 2332 | 1458.20 ± 0.6% | 955.26 ± 0.2% | 27.69 ± 0.8% | 572.33 ± 0.4% | 43.48 ± 2.7% | 17.11 ± 0.1% | 83.00 ± 0.4% | 1458.29 ± 0.2% | 1.53 | 1.00 | 2.55 | 33.54 |
| class: a number | 8288 | 2001.61 ± 0.3% | 839.73 ± 0.1% | 27.90 ± 0.4% | 1716.70 ± 0.2% | 39.09 ± 15.1% | 0.54 ± 0.1% | 56.60 ± 0.2% | 2004.41 ± 0.1% | 2.38 | 1.00 | 1.17 | 51.21 |
| class: two capitalized words, second text | 5359 | 743.86 ± 0.1% | 745.47 ± 0.1% | 23.37 ± 0.1% | 485.29 ± 0.1% | 35.32 ± 10.8% | 17.11 ± 0.2% | 63.97 ± 0.2% | 744.29 ± 0.0% | 1.00 | 1.00 | 1.53 | 21.06 |
| other: a word between two words | 6104 | 752.38 ± 0.1% | 780.83 ± 0.1% | 23.55 ± 0.2% | 737.72 ± 0.3% | 107.16 ± 7.3% | 11.15 ± 0.3% | 69.64 ± 0.2% | 749.69 ± 0.2% | 0.96 | 1.00 | 1.02 | 7.02 |
| other: a number before a unit, second text | 1481 | 5382.56 ± 0.4% | 990.96 ± 0.1% | 26.07 ± 0.2% | 5654.85 ± 0.6% | 40.72 ± 11.3% | 18.15 ± 0.6% | 66.89 ± 0.5% | 5375.85 ± 0.3% | 5.43 | 1.00 | 0.95 | 132.17 |
| other: a heading's start tag | 110 | 12402.79 ± 1.4% | 1044.85 ± 0.1% | 27.54 ± 0.5% | 1712.33 ± 0.8% | 1583.15 ± 4.9% | 15.93 ± 0.4% | 88.71 ± 0.3% | 12440.92 ± 1.6% | 11.87 | 1.00 | 7.24 | 7.83 |
| other: a whole word | 217 | 13787.78 ± 1.7% | 1045.73 ± 0.3% | 29.61 ± 0.5% | 14154.44 ± 9.1% | 49.35 ± 7.3% | 13.04 ± 0.2% | 55.67 ± 0.6% | 13757.25 ± 14.9% | 13.18 | 1.00 | 0.97 | 279.40 |
| other: a line's first word, second text | 3716 | 1963.38 ± 0.6% | 879.85 ± 0.2% | 31.19 ± 0.1% | 1726.73 ± 0.3% | 62.62 ± 4.9% | refused | refused | 1955.13 ± 0.2% | 2.23 | 1.00 | 1.14 | 31.35 |
| other: fourteen octets before an x | 87 | 19481.77 ± 0.8% | 223.60 ± 0.6% | 6.64 ± 0.1% | 3928.12 ± 0.5% | 10.65 ± 0.1% | differs | 17.77 ± 0.2% | 19480.98 ± 0.5% | 87.13 | 1.00 | 4.96 | 1828.69 |
| other: a Greek word | 21815 | 514.54 ± 0.6% | 412.02 ± 0.2% | 31.21 ± 0.2% | 289.01 ± 0.1% | 48.87 ± 12.7% | differs | refused | 511.17 ± 0.3% | 1.25 | 1.01 | 1.78 | 10.53 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.86 ± 0.1% | 25.85 ± 0.1% | 0.87 ± 0.2% | 19.79 ± 0.3% | 2.77 ± 0.9% | differs | 4.03 ± 0.2% | 25.85 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.32 |
| a UUID | 32895 | 21.05 ± 0.3% | 21.13 ± 0.2% | 0.65 ± 0.2% | 15.05 ± 0.4% | 3.10 ± 0.9% | 0.70 ± 0.3% | 3.61 ± 0.4% | 21.18 ± 0.3% | 1.00 | 0.99 | 1.40 | 6.80 |
| an IPv4 address | 33176 | 36.96 ± 0.2% | 36.91 ± 0.5% | 2.11 ± 0.2% | 29.36 ± 0.2% | 6.64 ± 0.1% | differs | 4.16 ± 0.3% | 37.01 ± 0.1% | 1.00 | 1.00 | 1.26 | 5.57 |
| a date and time | 32954 | 31.02 ± 0.2% | 31.09 ± 0.3% | 1.48 ± 0.7% | 21.48 ± 0.5% | 7.03 ± 0.1% | 1.18 ± 0.1% | 7.17 ± 0.8% | 31.00 ± 0.3% | 1.00 | 1.00 | 1.44 | 4.41 |
| a field path | 32606 | 29.50 ± 0.2% | 29.45 ± 0.2% | 1.04 ± 0.1% | 23.24 ± 0.2% | 3.49 ± 0.7% | differs | 2.96 ± 0.3% | 29.46 ± 0.2% | 1.00 | 1.00 | 1.27 | 8.45 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.55 ± 0.8% | 11.52 ± 0.6% | 11.55 ± 0.5% | 11.57 ± 0.2% | 4.95 ± 1.6% | 0.89 ± 0.4% | none | 11.50 ± 0.5% | 1.00 | 1.00 | 1.00 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.18 ± 0.2% | 235.97 ± 0.1% | 286.92 ± 0.1% | 87.06 ± 0.2% | 220.00 ± 1.7% | 483.22 ± 0.9% | 3880.10 ± 1.4% | 234.23 ± 0.1% | 0.99 | 1.00 | 2.69 | 1.06 |
| a UUID | 62 | 156.93 ± 0.3% | 157.50 ± 0.2% | 179.04 ± 0.1% | 45.80 ± 0.2% | 98.70 ± 0.7% | 181.57 ± 0.9% | 4365.77 ± 2.1% | 156.90 ± 0.3% | 1.00 | 1.00 | 3.43 | 1.59 |
| an IPv4 address | 29 | 418.91 ± 0.4% | 423.88 ± 0.2% | 614.62 ± 0.3% | 77.17 ± 1.1% | 130.79 ± 2.2% | 290.41 ± 0.8% | 7640.17 ± 0.2% | 418.68 ± 0.3% | 0.99 | 1.00 | 5.43 | 3.20 |
| a date and time | 56 | 307.12 ± 0.6% | 309.78 ± 0.3% | 399.38 ± 0.2% | 72.57 ± 0.2% | 126.73 ± 11.1% | 317.04 ± 1.2% | 4910.37 ± 0.3% | 307.37 ± 0.4% | 0.99 | 1.00 | 4.23 | 2.42 |
| a field path | 39 | 226.32 ± 0.1% | 227.87 ± 0.1% | 274.81 ± 0.2% | 80.14 ± 0.4% | 205.06 ± 0.8% | 484.58 ± 1.1% | 4938.65 ± 0.7% | 226.38 ± 0.4% | 0.99 | 1.00 | 2.82 | 1.10 |
| literal: a word | 7 | 620.79 ± 0.3% | 663.99 ± 0.2% | 1247.84 ± 0.2% | 513.22 ± 1.7% | 627.16 ± 2.6% | 909.75 ± 0.3% | 29519.50 ± 0.2% | 619.96 ± 0.2% | 0.93 | 1.00 | 1.21 | 0.99 |
| literal: a word that is not there | 8 | 598.36 ± 0.4% | 644.80 ± 0.3% | 1171.48 ± 0.2% | 468.90 ± 0.2% | 604.43 ± 2.0% | 865.06 ± 0.5% | 28574.07 ± 0.2% | 598.67 ± 0.1% | 0.93 | 1.00 | 1.28 | 0.99 |
| literal: one of four words | 26 | 241.09 ± 0.1% | 399.62 ± 0.4% | 562.41 ± 0.5% | 49.63 ± 0.2% | 242.58 ± 3.0% | 353.10 ± 0.6% | 15416.48 ± 0.3% | 241.18 ± 0.4% | 0.60 | 1.00 | 4.86 | 0.99 |
| literal: a word in any case | 11 | 481.42 ± 0.4% | 512.98 ± 0.5% | 837.19 ± 0.3% | 15.78 ± 1.0% | 649.29 ± 0.6% | refused | 23401.74 ± 0.6% | 481.85 ± 0.2% | 0.94 | 1.00 | 30.51 | 0.74 |
| literal: an href attribute | 12 | 347.87 ± 0.5% | 360.01 ± 0.7% | 492.11 ± 0.4% | 45.57 ± 0.3% | 500.76 ± 1.0% | 765.58 ± 2.2% | 21484.69 ± 0.3% | 347.89 ± 0.6% | 0.97 | 1.00 | 7.63 | 0.69 |
| literal: a word, second text | 10 | 557.83 ± 0.2% | 610.00 ± 0.3% | 1062.11 ± 0.1% | 418.33 ± 0.3% | 535.79 ± 1.6% | 792.13 ± 0.2% | 26474.80 ± 0.2% | 558.28 ± 0.5% | 0.91 | 1.00 | 1.33 | 1.04 |
| class: two capitalized words | 23 | 434.20 ± 0.3% | 465.16 ± 0.4% | 704.36 ± 0.7% | 102.02 ± 0.2% | 496.37 ± 2.4% | 737.11 ± 0.7% | 6578.46 ± 0.4% | 433.69 ± 0.4% | 0.93 | 1.00 | 4.26 | 0.87 |
| class: a word that ends in ing | 9 | 550.46 ± 0.2% | 623.05 ± 0.3% | 1161.98 ± 0.0% | 134.65 ± 0.9% | 760.83 ± 0.8% | 1072.43 ± 1.7% | 16012.84 ± 0.9% | 549.69 ± 0.2% | 0.88 | 1.00 | 4.09 | 0.72 |
| class: a word in capitals | 16 | 486.26 ± 0.4% | 528.24 ± 0.2% | 900.68 ± 0.2% | 137.10 ± 1.1% | 748.58 ± 5.7% | 1012.35 ± 0.4% | 8643.53 ± 0.2% | 486.11 ± 0.2% | 0.92 | 1.00 | 3.55 | 0.65 |
| class: a number | 6 | 604.18 ± 0.3% | 674.91 ± 0.3% | 1358.97 ± 0.1% | 42.19 ± 0.4% | 1396.85 ± 1.0% | 1920.98 ± 1.0% | 22504.69 ± 0.1% | 604.13 ± 0.2% | 0.90 | 1.00 | 14.32 | 0.43 |
| class: two capitalized words, second text | 23 | 433.66 ± 0.4% | 465.23 ± 0.2% | 702.38 ± 0.6% | 104.02 ± 0.2% | 494.16 ± 0.8% | 740.40 ± 1.0% | 6578.81 ± 0.2% | 433.73 ± 0.3% | 0.93 | 1.00 | 4.17 | 0.88 |
| other: a word between two words | 13 | 548.28 ± 0.3% | 566.18 ± 0.4% | 944.45 ± 0.2% | 137.21 ± 0.5% | 500.44 ± 0.7% | 808.89 ± 0.5% | 14810.51 ± 0.1% | 547.10 ± 0.3% | 0.97 | 1.00 | 4.00 | 1.10 |
| other: a number before a unit, second text | 15 | 403.67 ± 0.2% | 445.36 ± 0.1% | 652.80 ± 0.1% | 39.54 ± 0.4% | 629.56 ± 1.0% | 890.21 ± 0.3% | 15064.90 ± 0.3% | 403.45 ± 0.2% | 0.91 | 1.00 | 10.21 | 0.64 |
| other: a heading's start tag | 13 | 358.36 ± 0.8% | 364.36 ± 0.6% | 498.77 ± 0.9% | 43.84 ± 0.2% | 623.95 ± 1.7% | 849.47 ± 0.2% | 17852.75 ± 0.6% | 358.33 ± 0.5% | 0.98 | 1.00 | 8.17 | 0.57 |
| other: a whole word | 11 | 580.61 ± 0.7% | 615.01 ± 0.8% | 1080.78 ± 0.2% | 121.79 ± 0.4% | 559.26 ± 1.9% | 819.74 ± 0.6% | 26557.33 ± 0.6% | 579.35 ± 1.5% | 0.94 | 1.00 | 4.77 | 1.04 |
| other: a line's first word, second text | 17 | 527.94 ± 0.6% | 547.24 ± 0.4% | 934.39 ± 0.6% | 129.62 ± 0.1% | 704.69 ± 1.9% | refused | refused | 526.41 ± 0.9% | 0.96 | 1.00 | 4.07 | 0.75 |
| other: fourteen octets before an x | 16 | 111.69 ± 0.4% | 162.08 ± 0.4% | 190.82 ± 0.4% | 15.21 ± 0.3% | 451.57 ± 2.4% | 416.95 ± 0.5% | 12563.73 ± 0.6% | 111.60 ± 0.7% | 0.69 | 1.00 | 7.34 | 0.25 |
| other: a Greek word | 8 | 420.99 ± 0.1% | 580.69 ± 0.2% | 1040.75 ± 0.2% | 58.99 ± 0.1% | 1373.65 ± 0.5% | 1837.18 ± 0.2% | refused | 420.34 ± 0.4% | 0.72 | 1.00 | 7.14 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12695.60 ± 1.1% | not timed | not timed | 15886.78 ± 1.0% | 1945.83 ± 22.1% | not timed | not timed | 12722.68 ± 1.1% | | 1.00 | 0.80 | 6.52 |
| 01-literal/sherlock-casei-en | 522 | 4476.85 ± 1.2% | not timed | not timed | 3588.98 ± 0.1% | 32.49 ± 5.1% | not timed | not timed | 4473.11 ± 1.0% | | 1.00 | 1.25 | 137.78 |
| 01-literal/sherlock-ru | 724 | 13545.84 ± 0.6% | not timed | not timed | 17333.93 ± 0.3% | 1470.08 ± 6.9% | not timed | not timed | 13527.36 ± 0.3% | | 1.00 | 0.78 | 9.21 |
| 01-literal/sherlock-casei-ru | 746 | 5303.38 ± 0.4% | not timed | not timed | 3326.88 ± 0.2% | 31.64 ± 0.4% | not timed | not timed | 5294.44 ± 0.3% | | 1.00 | 1.59 | 167.60 |
| 01-literal/sherlock-zh | 30 | 16697.14 ± 1.0% | not timed | not timed | 18084.21 ± 1.0% | 2746.94 ± 5.4% | not timed | not timed | 16708.51 ± 0.9% | | 1.00 | 0.92 | 6.08 |
| 02-literal-alternate/sherlock-en | 714 | 5752.34 ± 0.6% | not timed | not timed | 3943.58 ± 0.3% | 16.52 ± 0.1% | not timed | not timed | 5741.54 ± 0.5% | | 1.00 | 1.46 | 348.14 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1712.02 ± 1.5% | not timed | not timed | 697.55 ± 0.4% | 11.11 ± 0.1% | not timed | not timed | 1702.04 ± 0.3% | | 1.01 | 2.45 | 154.03 |
| 02-literal-alternate/sherlock-ru | 899 | 4648.55 ± 0.2% | not timed | not timed | 3254.86 ± 0.1% | 22.62 ± 0.1% | not timed | not timed | 4653.43 ± 0.1% | | 1.00 | 1.43 | 205.55 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1810.38 ± 0.8% | not timed | not timed | 1230.34 ± 0.1% | 9.15 ± 0.1% | not timed | not timed | 1802.17 ± 0.5% | | 1.00 | 1.47 | 197.82 |
| 02-literal-alternate/sherlock-zh | 207 | 7055.68 ± 0.4% | not timed | not timed | 4163.34 ± 0.3% | 31.50 ± 0.1% | not timed | not timed | 7045.38 ± 0.6% | | 1.00 | 1.69 | 223.98 |
| 03-date/ascii | 111817 | 126.48 ± 0.4% | not timed | not timed | 95.81 ± 0.1% | 0.20 ± 6.1% | not timed | not timed | 125.80 ± 0.1% | | 1.01 | 1.32 | 624.55 |
| 04-ruff-noqa/real | 84 | 556.18 ± 0.1% | not timed | not timed | 468.13 ± 0.2% | 19.63 ± 1.3% | not timed | not timed | 555.56 ± 0.3% | | 1.00 | 1.19 | 28.33 |
| 04-ruff-noqa/tweaked | 44 | 542.25 ± 0.2% | not timed | not timed | 465.39 ± 0.1% | 366.66 ± 1.3% | not timed | not timed | 540.96 ± 0.2% | | 1.00 | 1.17 | 1.48 |
| 05-lexer-veryl/single | 124800 | 4.25 ± 0.2% | not timed | not timed | 5.24 ± 0.1% | 0.20 ± 5.7% | not timed | not timed | 4.27 ± 0.1% | | 1.00 | 0.81 | 21.07 |
| 06-cloud-flare-redos/original | 107 | 260.63 ± 0.3% | not timed | not timed | 217.21 ± 0.0% | 24.94 ± 0.1% | not timed | not timed | 260.18 ± 0.1% | | 1.00 | 1.20 | 10.45 |
| 06-cloud-flare-redos/simplified-short | 102 | 255.03 ± 0.1% | not timed | not timed | 228.51 ± 0.1% | 26.70 ± 0.2% | not timed | not timed | 254.96 ± 0.0% | | 1.00 | 1.12 | 9.55 |
| 06-cloud-flare-redos/simplified-long | 10000 | 292.17 ± 0.1% | not timed | not timed | 255.85 ± 0.3% | 28.74 ± 0.1% | not timed | not timed | 292.35 ± 0.1% | | 1.00 | 1.14 | 10.17 |
| 07-unicode-character-data/parse-line | 558784 | 234.70 ± 3.3% | not timed | not timed | 180.88 ± 0.2% | 42.55 ± 18.9% | not timed | not timed | 231.35 ± 2.5% | | 1.01 | 1.30 | 5.52 |
| 08-words/all-english | 56691 | 121.53 ± 0.2% | not timed | not timed | 83.28 ± 0.2% | 11.94 ± 4.3% | not timed | not timed | 120.77 ± 0.3% | | 1.01 | 1.46 | 10.17 |
| 08-words/long-english | 839 | 1012.36 ± 0.1% | not timed | not timed | 595.82 ± 0.0% | 32.46 ± 0.6% | not timed | not timed | 1012.06 ± 0.1% | | 1.00 | 1.70 | 31.19 |
| 09-aws-keys/full | 0 | 408.55 ± 0.1% | not timed | not timed | 479.28 ± 0.2% | 64.52 ± 4.2% | not timed | not timed | 408.38 ± 0.1% | | 1.00 | 0.85 | 6.33 |
| 09-aws-keys/quick | 0 | 737.57 ± 0.3% | not timed | not timed | 1002.29 ± 0.1% | 417.93 ± 1.9% | not timed | not timed | 737.15 ± 0.1% | | 1.00 | 0.74 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 638.77 ± 0.6% | not timed | not timed | 514.07 ± 0.9% | 19.60 ± 0.5% | not timed | not timed | 638.09 ± 0.3% | | 1.00 | 1.24 | 32.59 |
| 10-bounded-repeat/letters-ru | 3475 | 383.03 ± 0.1% | not timed | not timed | 478.34 ± 0.2% | 22.17 ± 16.2% | not timed | not timed | 381.71 ± 0.5% | | 1.00 | 0.80 | 17.27 |
| 10-bounded-repeat/context | 53 | 79.76 ± 1.0% | not timed | not timed | 65.80 ± 0.5% | 19.81 ± 0.3% | not timed | not timed | 79.71 ± 0.9% | | 1.00 | 1.21 | 4.03 |
| 10-bounded-repeat/capitals | 11 | 1055.29 ± 0.2% | not timed | not timed | 618.30 ± 0.0% | 36.47 ± 0.1% | not timed | not timed | 1054.97 ± 0.1% | | 1.00 | 1.71 | 28.94 |
| 11-unstructured-to-json/extract | 600 | 49.91 ± 0.5% | not timed | not timed | 76.30 ± 0.2% | 48.86 ± 0.4% | not timed | not timed | 48.53 ± 1.0% | | 1.03 | 0.65 | 1.02 |
| 12-dictionary/single | 1 | 567.65 ± 0.4% | not timed | not timed | 561.33 ± 0.1% | 0.41 ± 0.0% | not timed | not timed | 570.04 ± 0.3% | | 1.00 | 1.01 | 1394.77 |
| 14-quadratic/1x | 100 | 12.81 ± 0.3% | not timed | not timed | 10.01 ± 0.1% | 0.97 ± 2.9% | not timed | not timed | 12.77 ± 2.0% | | 1.00 | 1.28 | 13.24 |
| 14-quadratic/2x | 200 | 7.93 ± 0.4% | not timed | not timed | 5.52 ± 0.2% | 0.53 ± 0.5% | not timed | not timed | 7.92 ± 1.5% | | 1.00 | 1.44 | 14.87 |
| 14-quadratic/10x | 1000 | 1.87 ± 0.2% | not timed | not timed | 1.20 ± 0.3% | 0.12 ± 1.8% | not timed | not timed | 1.87 ± 0.3% | | 1.00 | 1.55 | 16.21 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 1.2% | not timed | not timed | 0.34 ± 0.6% | 0.54 ± 3.5% | not timed | not timed | 1.44 ± 1.0% | | 1.00 | 4.23 | 2.69 |
| 04-ruff-noqa/compile-real | 1 | 92.66 ± 0.1% | not timed | not timed | 13.99 ± 0.2% | 138.29 ± 1.5% | not timed | not timed | 92.32 ± 0.9% | | 1.00 | 6.62 | 0.67 |
| 05-lexer-veryl/compile-single | 1 | 14.59 ± 0.2% | not timed | not timed | 2.53 ± 1.2% | 6.39 ± 2.8% | not timed | not timed | 14.51 ± 1.6% | | 1.01 | 5.76 | 2.28 |
| 07-unicode-character-data/compile | 1 | 58.40 ± 0.3% | not timed | not timed | 26.22 ± 0.4% | 35.49 ± 2.7% | not timed | not timed | 58.03 ± 1.0% | | 1.01 | 2.23 | 1.65 |
| 09-aws-keys/compile-full | 1 | 43.71 ± 0.2% | not timed | not timed | 8.32 ± 0.5% | 23.11 ± 1.5% | not timed | not timed | 43.50 ± 0.3% | | 1.00 | 5.25 | 1.89 |
| 09-aws-keys/compile-quick | 1 | 187.27 ± 0.2% | not timed | not timed | 47.82 ± 0.2% | 132.38 ± 2.9% | not timed | not timed | 187.74 ± 0.9% | | 1.00 | 3.92 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 14.67 ± 0.3% | not timed | not timed | 11.08 ± 0.3% | 15.74 ± 3.9% | not timed | not timed | 14.50 ± 1.1% | | 1.01 | 1.32 | 0.93 |
| 10-bounded-repeat/compile-capitals | 1 | 85.17 ± 0.9% | not timed | not timed | 8.06 ± 0.3% | 23.35 ± 1.6% | not timed | not timed | 84.55 ± 1.3% | | 1.01 | 10.56 | 3.65 |
| 11-unstructured-to-json/compile | 1 | 90.68 ± 0.2% | not timed | not timed | 40.74 ± 0.5% | 67.09 ± 4.3% | not timed | not timed | 90.27 ± 0.9% | | 1.00 | 2.23 | 1.35 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 33.9% | 0.10 ± 7.9% | not timed | not timed | 0.36 ± 1.5% | | 1.01 | 5.35 | 3.79 |

