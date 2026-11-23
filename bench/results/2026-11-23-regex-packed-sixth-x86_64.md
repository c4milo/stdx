# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102068513 |
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
| literal: a word | 217 | 31757.96 ± 3.7% | 895.17 ± 0.4% | 20.27 ± 1.1% | 31163.60 ± 0.7% | 8929.77 ± 9.1% | 10.74 ± 0.1% | 76.56 ± 1.3% | 31360.98 ± 1.0% | 35.48 | 1.01 | 1.02 | 3.56 |
| literal: a word that is not there | 0 | 43470.64 ± 2.8% | 906.05 ± 0.3% | 20.24 ± 0.5% | 39483.86 ± 1.9% | 29968.59 ± 5.3% | 10.67 ± 0.8% | 72.21 ± 1.1% | 43057.77 ± 1.7% | 47.98 | 1.01 | 1.10 | 1.45 |
| literal: one of four words | 661 | 11318.34 ± 2.0% | 867.86 ± 13.0% | 11.10 ± 24.3% | 9133.75 ± 0.2% | 19.27 ± 2.0% | 3.99 ± 4.7% | 6.68 ± 0.5% | 11305.08 ± 0.7% | 13.04 | 1.00 | 1.24 | 587.47 |
| literal: a word in any case | 217 | 25738.06 ± 2.7% | 893.66 ± 0.1% | 15.67 ± 0.6% | 9255.46 ± 0.3% | 37.24 ± 0.5% | refused | differs | 25267.54 ± 0.9% | 28.80 | 1.02 | 2.78 | 691.22 |
| literal: an href attribute | 33 | 26249.68 ± 2.8% | 902.29 ± 0.1% | 19.15 ± 0.4% | 27370.97 ± 0.6% | 2055.47 ± 0.9% | 8.20 ± 0.3% | 61.71 ± 1.7% | 25945.25 ± 1.2% | 29.09 | 1.01 | 0.96 | 12.77 |
| literal: a word, second text | 123 | 32171.34 ± 2.7% | 898.41 ± 0.2% | 20.13 ± 0.5% | 31848.01 ± 1.2% | 7101.11 ± 7.0% | 11.82 ± 0.2% | 65.38 ± 1.2% | 31858.01 ± 2.6% | 35.81 | 1.01 | 1.01 | 4.53 |
| class: two capitalized words | 1331 | 766.38 ± 0.3% | 815.53 ± 0.4% | 19.11 ± 0.5% | 506.46 ± 0.3% | 34.32 ± 10.3% | 9.32 ± 0.2% | 55.66 ± 0.6% | 764.81 ± 0.4% | 0.94 | 1.00 | 1.51 | 22.33 |
| class: a word that ends in ing | 3399 | 734.42 ± 0.2% | 735.38 ± 0.4% | 13.70 ± 0.3% | 472.25 ± 0.4% | 25.68 ± 7.5% | 5.34 ± 0.3% | 17.21 ± 0.6% | 733.57 ± 1.2% | 1.00 | 1.00 | 1.56 | 28.60 |
| class: a word in capitals | 2332 | 983.66 ± 3.1% | 796.82 ± 0.2% | 19.98 ± 0.3% | 497.43 ± 1.0% | 36.59 ± 14.4% | 10.29 ± 0.2% | 76.30 ± 5.6% | 982.49 ± 0.2% | 1.23 | 1.00 | 1.98 | 26.89 |
| class: a number | 8288 | 1454.80 ± 2.1% | 644.73 ± 1.5% | 19.78 ± 0.5% | 1474.91 ± 0.6% | 36.40 ± 13.5% | 0.33 ± 0.6% | 55.54 ± 2.4% | 1457.42 ± 2.1% | 2.26 | 1.00 | 0.99 | 39.97 |
| class: two capitalized words, second text | 5359 | 578.11 ± 3.1% | 579.31 ± 0.3% | 17.58 ± 0.3% | 418.48 ± 0.2% | 29.05 ± 7.9% | 10.52 ± 0.4% | 51.66 ± 0.8% | 579.08 ± 0.1% | 1.00 | 1.00 | 1.38 | 19.90 |
| other: a word between two words | 6104 | 653.50 ± 2.5% | 617.38 ± 1.6% | 17.42 ± 0.4% | 698.72 ± 2.5% | 101.80 ± 13.8% | 7.24 ± 0.7% | 56.42 ± 1.3% | 650.74 ± 0.7% | 1.06 | 1.00 | 0.94 | 6.42 |
| other: a number before a unit, second text | 1481 | 6795.18 ± 4.0% | 825.10 ± 0.5% | 19.03 ± 0.5% | 6465.11 ± 0.4% | 35.07 ± 0.6% | 10.88 ± 0.2% | 55.01 ± 0.4% | 6774.93 ± 3.5% | 8.24 | 1.00 | 1.05 | 193.76 |
| other: a heading's start tag | 110 | 18734.31 ± 1.8% | 893.78 ± 0.2% | 19.73 ± 0.7% | 2010.04 ± 0.4% | 1469.71 ± 1.9% | 9.98 ± 0.2% | 72.65 ± 1.0% | 18428.38 ± 1.1% | 20.96 | 1.02 | 9.32 | 12.75 |
| other: a whole word | 217 | 22115.79 ± 4.6% | 894.00 ± 0.1% | 20.96 ± 0.2% | 22364.75 ± 0.6% | 41.34 ± 0.5% | 9.47 ± 0.1% | 46.77 ± 0.4% | 21292.26 ± 2.1% | 24.74 | 1.04 | 0.99 | 535.01 |
| other: a line's first word, second text | 3716 | 1751.96 ± 2.4% | 716.14 ± 0.1% | 24.31 ± 0.3% | 1699.61 ± 4.7% | 53.27 ± 6.1% | refused | refused | 1755.80 ± 0.9% | 2.45 | 1.00 | 1.03 | 32.89 |
| other: fourteen octets before an x | 87 | 25645.73 ± 2.1% | 197.99 ± 1.5% | 4.43 ± 0.4% | 2938.66 ± 1.0% | 8.99 ± 0.4% | differs | 15.47 ± 0.4% | 25440.53 ± 0.4% | 129.53 | 1.01 | 8.73 | 2851.26 |
| other: a Greek word | 21815 | 384.15 ± 0.8% | 265.43 ± 0.6% | 24.28 ± 17.8% | 264.65 ± 14.6% | 44.17 ± 6.9% | differs | refused | 382.02 ± 0.6% | 1.45 | 1.01 | 1.45 | 8.70 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.32 ± 0.4% | 25.30 ± 0.7% | 0.74 ± 0.5% | 16.87 ± 4.4% | 1.72 ± 0.5% | differs | 3.63 ± 1.4% | 25.34 ± 3.8% | 1.00 | 1.00 | 1.50 | 14.68 |
| a UUID | 32895 | 20.76 ± 0.5% | 20.69 ± 0.9% | 0.57 ± 0.7% | 12.88 ± 0.5% | 2.51 ± 0.7% | 0.44 ± 0.3% | 3.09 ± 1.2% | 20.83 ± 0.2% | 1.00 | 1.00 | 1.61 | 8.28 |
| an IPv4 address | 33176 | 35.46 ± 0.9% | 35.20 ± 9.9% | 1.84 ± 0.3% | 24.15 ± 0.2% | 5.75 ± 0.9% | differs | 3.42 ± 0.7% | 35.81 ± 0.2% | 1.01 | 0.99 | 1.47 | 6.16 |
| a date and time | 32954 | 31.06 ± 0.3% | 30.99 ± 0.5% | 1.25 ± 5.3% | 18.12 ± 2.5% | 6.64 ± 0.6% | 0.75 ± 0.2% | 6.18 ± 0.4% | 31.09 ± 2.0% | 1.00 | 1.00 | 1.71 | 4.67 |
| a field path | 32606 | 28.05 ± 1.9% | 27.89 ± 2.0% | 0.83 ± 12.3% | 19.34 ± 1.5% | 2.93 ± 2.5% | differs | 2.45 ± 4.1% | 28.32 ± 2.1% | 1.01 | 0.99 | 1.45 | 9.56 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 7.73 ± 2.2% | 7.71 ± 2.7% | 7.71 ± 3.3% | 10.65 ± 0.4% | 4.70 ± 1.2% | 0.62 ± 1.2% | none | 7.70 ± 1.3% | 1.00 | 1.00 | 0.73 | 1.64 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 184.57 ± 6.7% | 185.61 ± 0.9% | 213.91 ± 0.1% | 79.60 ± 16.5% | 181.85 ± 3.7% | 526.71 ± 2.7% | 3935.14 ± 1.7% | 184.75 ± 0.5% | 0.99 | 1.00 | 2.32 | 1.01 |
| a UUID | 62 | 121.16 ± 0.3% | 121.39 ± 1.4% | 134.01 ± 0.2% | 46.78 ± 2.9% | 88.91 ± 1.7% | 198.59 ± 2.2% | 4095.56 ± 1.5% | 121.19 ± 0.4% | 1.00 | 1.00 | 2.59 | 1.36 |
| an IPv4 address | 29 | 391.03 ± 1.0% | 394.95 ± 6.4% | 555.22 ± 1.3% | 69.69 ± 11.5% | 112.21 ± 1.5% | 325.45 ± 2.6% | 6949.69 ± 1.0% | 391.86 ± 3.6% | 0.99 | 1.00 | 5.61 | 3.48 |
| a date and time | 56 | 283.45 ± 1.1% | 286.50 ± 0.5% | 359.58 ± 0.5% | 68.04 ± 1.4% | 118.34 ± 7.5% | 359.44 ± 8.1% | 4271.93 ± 0.7% | 283.89 ± 0.5% | 0.99 | 1.00 | 4.17 | 2.40 |
| a field path | 39 | 180.99 ± 0.3% | 181.52 ± 6.1% | 208.97 ± 0.3% | 74.36 ± 9.3% | 163.13 ± 8.5% | 585.19 ± 7.2% | 4759.99 ± 1.5% | 180.88 ± 0.6% | 1.00 | 1.00 | 2.43 | 1.11 |
| literal: a word | 7 | 585.22 ± 1.1% | 626.48 ± 0.3% | 1119.44 ± 0.4% | 499.91 ± 0.4% | 568.52 ± 2.9% | 1238.18 ± 0.4% | 22428.26 ± 0.2% | 588.58 ± 0.4% | 0.93 | 0.99 | 1.17 | 1.03 |
| literal: a word that is not there | 8 | 559.04 ± 3.0% | 605.96 ± 0.7% | 1049.65 ± 1.0% | 456.85 ± 0.8% | 547.18 ± 1.7% | 1163.75 ± 0.9% | 21587.64 ± 0.7% | 563.50 ± 0.8% | 0.92 | 0.99 | 1.22 | 1.02 |
| literal: one of four words | 26 | 223.03 ± 8.4% | 357.84 ± 1.9% | 479.08 ± 0.5% | 41.92 ± 0.7% | 212.53 ± 9.5% | 445.19 ± 10.0% | 11557.95 ± 1.4% | 222.84 ± 0.2% | 0.62 | 1.00 | 5.32 | 1.05 |
| literal: a word in any case | 11 | 451.00 ± 0.6% | 480.10 ± 0.5% | 726.12 ± 0.2% | 14.56 ± 0.6% | 601.12 ± 10.2% | refused | 17105.58 ± 0.7% | 450.15 ± 0.3% | 0.94 | 1.00 | 30.98 | 0.75 |
| literal: an href attribute | 12 | 319.27 ± 0.2% | 330.15 ± 0.7% | 435.59 ± 0.9% | 36.57 ± 2.3% | 418.57 ± 3.3% | 931.40 ± 1.1% | 15075.66 ± 0.3% | 317.96 ± 0.8% | 0.97 | 1.00 | 8.73 | 0.76 |
| literal: a word, second text | 10 | 526.79 ± 0.7% | 571.72 ± 0.3% | 945.71 ± 2.0% | 411.05 ± 1.1% | 467.85 ± 3.7% | 980.11 ± 1.0% | 19741.64 ± 1.2% | 525.65 ± 3.2% | 0.92 | 1.00 | 1.28 | 1.13 |
| class: two capitalized words | 23 | 417.91 ± 1.2% | 446.32 ± 1.9% | 650.51 ± 0.5% | 95.73 ± 0.6% | 445.42 ± 1.9% | 918.47 ± 1.7% | 6389.03 ± 0.3% | 417.43 ± 0.9% | 0.94 | 1.00 | 4.37 | 0.94 |
| class: a word that ends in ing | 9 | 508.88 ± 0.4% | 570.65 ± 0.2% | 1014.31 ± 1.7% | 114.26 ± 1.3% | 608.02 ± 3.3% | 1430.14 ± 0.5% | 14366.93 ± 0.6% | 509.63 ± 0.7% | 0.89 | 1.00 | 4.45 | 0.84 |
| class: a word in capitals | 16 | 448.69 ± 0.3% | 483.56 ± 0.8% | 796.63 ± 0.6% | 121.47 ± 0.8% | 629.72 ± 2.3% | 1310.57 ± 3.7% | 8351.36 ± 0.3% | 448.30 ± 0.5% | 0.93 | 1.00 | 3.69 | 0.71 |
| class: a number | 6 | 562.77 ± 1.6% | 617.62 ± 1.5% | 1184.27 ± 0.6% | 36.43 ± 1.4% | 1155.45 ± 2.9% | 2214.73 ± 3.5% | 20154.46 ± 1.3% | 562.81 ± 0.5% | 0.91 | 1.00 | 15.45 | 0.49 |
| class: two capitalized words, second text | 23 | 417.92 ± 0.8% | 446.61 ± 0.8% | 649.67 ± 0.4% | 96.71 ± 0.7% | 438.60 ± 2.4% | 949.16 ± 1.8% | 6387.79 ± 0.3% | 416.80 ± 0.6% | 0.94 | 1.00 | 4.32 | 0.95 |
| other: a word between two words | 13 | 500.41 ± 0.5% | 516.44 ± 1.9% | 815.61 ± 0.4% | 122.71 ± 0.5% | 424.01 ± 9.3% | 1037.83 ± 0.9% | 13346.35 ± 0.6% | 500.50 ± 0.8% | 0.97 | 1.00 | 4.08 | 1.18 |
| other: a number before a unit, second text | 15 | 351.55 ± 0.6% | 385.61 ± 0.5% | 530.26 ± 0.3% | 33.95 ± 0.6% | 528.95 ± 4.2% | 1125.38 ± 3.5% | 13871.58 ± 0.8% | 351.14 ± 0.8% | 0.91 | 1.00 | 10.35 | 0.66 |
| other: a heading's start tag | 13 | 332.52 ± 0.8% | 336.94 ± 28.6% | 448.76 ± 3.1% | 35.97 ± 3.3% | 526.10 ± 1.3% | 1065.46 ± 2.1% | 15102.84 ± 0.5% | 332.61 ± 0.6% | 0.99 | 1.00 | 9.25 | 0.63 |
| other: a whole word | 11 | 503.63 ± 1.2% | 531.68 ± 0.5% | 846.41 ± 0.4% | 110.31 ± 1.4% | 504.60 ± 6.9% | 1076.29 ± 2.0% | 20935.47 ± 1.5% | 504.25 ± 0.3% | 0.95 | 1.00 | 4.57 | 1.00 |
| other: a line's first word, second text | 17 | 486.55 ± 0.8% | 508.25 ± 4.2% | 836.20 ± 0.5% | 114.99 ± 1.2% | 569.11 ± 3.5% | refused | refused | 482.95 ± 2.5% | 0.96 | 1.01 | 4.23 | 0.85 |
| other: fourteen octets before an x | 16 | 87.45 ± 2.9% | 124.40 ± 2.1% | 143.36 ± 2.8% | 14.07 ± 4.8% | 386.01 ± 7.6% | 462.29 ± 2.4% | 11238.55 ± 4.1% | 87.48 ± 2.4% | 0.70 | 1.00 | 6.22 | 0.23 |
| other: a Greek word | 8 | 383.40 ± 0.9% | 513.07 ± 0.4% | 840.04 ± 8.3% | 46.50 ± 4.5% | 1141.79 ± 9.3% | 2234.95 ± 1.0% | refused | 382.22 ± 0.6% | 0.75 | 1.00 | 8.24 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20312.69 ± 1.6% | not timed | not timed | 26947.84 ± 0.5% | 1908.22 ± 21.8% | not timed | not timed | 20274.52 ± 0.4% | | 1.00 | 0.75 | 10.64 |
| 01-literal/sherlock-casei-en | 522 | 4568.85 ± 0.4% | not timed | not timed | 7035.36 ± 0.4% | 28.62 ± 1.0% | not timed | not timed | 4552.44 ± 3.4% | | 1.00 | 0.65 | 159.65 |
| 01-literal/sherlock-ru | 724 | 22264.40 ± 2.6% | not timed | not timed | 27570.91 ± 0.8% | 1056.19 ± 2.7% | not timed | not timed | 22094.11 ± 0.9% | | 1.01 | 0.81 | 21.08 |
| 01-literal/sherlock-casei-ru | 746 | 7356.10 ± 0.9% | not timed | not timed | 5524.18 ± 0.3% | 30.55 ± 0.8% | not timed | not timed | 7319.66 ± 0.5% | | 1.00 | 1.33 | 240.80 |
| 01-literal/sherlock-zh | 30 | 38768.34 ± 2.1% | not timed | not timed | 36926.48 ± 0.1% | 1261.00 ± 0.9% | not timed | not timed | 38670.26 ± 0.5% | | 1.00 | 1.05 | 30.74 |
| 02-literal-alternate/sherlock-en | 714 | 9883.51 ± 0.4% | not timed | not timed | 8931.63 ± 0.4% | 14.18 ± 10.9% | not timed | not timed | 9868.57 ± 0.9% | | 1.00 | 1.11 | 697.14 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1741.00 ± 1.1% | not timed | not timed | 1799.66 ± 0.2% | 9.51 ± 0.8% | not timed | not timed | 1718.95 ± 0.6% | | 1.01 | 0.97 | 183.12 |
| 02-literal-alternate/sherlock-ru | 899 | 6023.43 ± 10.9% | not timed | not timed | 4261.20 ± 0.2% | 19.43 ± 0.6% | not timed | not timed | 5993.79 ± 0.6% | | 1.00 | 1.41 | 310.07 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1812.68 ± 7.3% | not timed | not timed | 1039.98 ± 0.4% | 8.52 ± 4.0% | not timed | not timed | 1812.90 ± 0.2% | | 1.00 | 1.74 | 212.72 |
| 02-literal-alternate/sherlock-zh | 207 | 13917.08 ± 0.6% | not timed | not timed | 10401.38 ± 0.4% | 27.55 ± 2.5% | not timed | not timed | 13973.24 ± 0.5% | | 1.00 | 1.34 | 505.18 |
| 03-date/ascii | 111817 | 106.10 ± 1.0% | not timed | not timed | 85.61 ± 0.8% | 0.18 ± 2.9% | not timed | not timed | 106.20 ± 0.5% | | 1.00 | 1.24 | 591.33 |
| 04-ruff-noqa/real | 84 | 562.50 ± 0.6% | not timed | not timed | 426.07 ± 0.8% | 15.52 ± 2.2% | not timed | not timed | 561.63 ± 1.7% | | 1.00 | 1.32 | 36.25 |
| 04-ruff-noqa/tweaked | 44 | 487.99 ± 0.4% | not timed | not timed | 420.35 ± 0.4% | 284.17 ± 1.4% | not timed | not timed | 488.64 ± 0.2% | | 1.00 | 1.16 | 1.72 |
| 05-lexer-veryl/single | 124800 | 2.83 ± 18.3% | not timed | not timed | 4.10 ± 0.6% | 0.21 ± 0.9% | not timed | not timed | 2.84 ± 5.3% | | 1.00 | 0.69 | 13.41 |
| 06-cloud-flare-redos/original | 107 | 176.97 ± 3.8% | not timed | not timed | 181.32 ± 25.7% | 13.14 ± 6.5% | not timed | not timed | 173.72 ± 2.9% | | 1.02 | 0.98 | 13.46 |
| 06-cloud-flare-redos/simplified-short | 102 | 124.38 ± 2.6% | not timed | not timed | 189.00 ± 2.5% | 13.87 ± 2.5% | not timed | not timed | 123.98 ± 2.3% | | 1.00 | 0.66 | 8.97 |
| 06-cloud-flare-redos/simplified-long | 10000 | 136.34 ± 1.1% | not timed | not timed | 211.60 ± 1.4% | 15.05 ± 0.7% | not timed | not timed | 135.98 ± 2.4% | | 1.00 | 0.64 | 9.06 |
| 07-unicode-character-data/parse-line | 558784 | 36.13 ± 2.7% | not timed | not timed | 160.89 ± 1.5% | 36.49 ± 5.5% | not timed | not timed | 34.97 ± 0.9% | | 1.03 | 0.22 | 0.99 |
| 08-words/all-english | 56691 | 72.49 ± 0.7% | not timed | not timed | 73.62 ± 0.6% | 10.03 ± 8.5% | not timed | not timed | 72.24 ± 0.9% | | 1.00 | 0.98 | 7.23 |
| 08-words/long-english | 839 | 847.41 ± 2.4% | not timed | not timed | 513.51 ± 0.2% | 26.57 ± 0.3% | not timed | not timed | 843.34 ± 0.1% | | 1.00 | 1.65 | 31.89 |
| 09-aws-keys/full | 0 | 431.99 ± 0.6% | not timed | not timed | 440.40 ± 0.5% | 47.51 ± 6.2% | not timed | not timed | 432.66 ± 0.6% | | 1.00 | 0.98 | 9.09 |
| 09-aws-keys/quick | 0 | 443.64 ± 1.1% | not timed | not timed | 804.88 ± 0.6% | 300.45 ± 0.6% | not timed | not timed | 442.97 ± 0.2% | | 1.00 | 0.55 | 1.48 |
| 10-bounded-repeat/letters-en | 1833 | 466.20 ± 4.9% | not timed | not timed | 431.92 ± 0.2% | 16.87 ± 1.6% | not timed | not timed | 465.60 ± 0.3% | | 1.00 | 1.08 | 27.63 |
| 10-bounded-repeat/letters-ru | 3475 | 323.13 ± 0.2% | not timed | not timed | 386.64 ± 0.2% | 19.71 ± 14.8% | not timed | not timed | 322.72 ± 6.4% | | 1.00 | 0.84 | 16.39 |
| 10-bounded-repeat/context | 53 | 57.74 ± 12.6% | not timed | not timed | 54.52 ± 3.0% | 16.95 ± 0.4% | not timed | not timed | 58.64 ± 5.4% | | 0.98 | 1.06 | 3.41 |
| 10-bounded-repeat/capitals | 11 | 894.11 ± 0.4% | not timed | not timed | 533.13 ± 0.1% | 30.85 ± 0.8% | not timed | not timed | 891.99 ± 0.2% | | 1.00 | 1.68 | 28.98 |
| 11-unstructured-to-json/extract | 600 | 20.74 ± 0.9% | not timed | not timed | 62.70 ± 6.2% | 22.95 ± 1.5% | not timed | not timed | 20.80 ± 0.3% | | 1.00 | 0.33 | 0.90 |
| 12-dictionary/single | 1 | 460.94 ± 0.5% | not timed | not timed | 442.84 ± 0.8% | 0.32 ± 8.9% | not timed | not timed | 462.91 ± 0.6% | | 1.00 | 1.04 | 1462.02 |
| 14-quadratic/1x | 100 | 10.96 ± 0.6% | not timed | not timed | 9.11 ± 1.5% | 0.80 ± 3.4% | not timed | not timed | 10.93 ± 1.1% | | 1.00 | 1.20 | 13.71 |
| 14-quadratic/2x | 200 | 6.66 ± 9.0% | not timed | not timed | 4.91 ± 3.0% | 0.43 ± 1.6% | not timed | not timed | 6.71 ± 7.1% | | 0.99 | 1.36 | 15.48 |
| 14-quadratic/10x | 1000 | 1.56 ± 0.8% | not timed | not timed | 1.05 ± 1.1% | 0.09 ± 3.4% | not timed | not timed | 1.56 ± 0.4% | | 1.00 | 1.48 | 16.80 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.34 ± 0.2% | not timed | not timed | 0.38 ± 1.3% | 0.47 ± 3.9% | not timed | not timed | 1.34 ± 1.1% | | 1.00 | 3.50 | 2.87 |
| 04-ruff-noqa/compile-real | 1 | 78.69 ± 0.9% | not timed | not timed | 12.96 ± 1.0% | 125.48 ± 1.9% | not timed | not timed | 78.21 ± 1.6% | | 1.01 | 6.07 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 12.65 ± 0.7% | not timed | not timed | 2.37 ± 2.3% | 5.94 ± 16.4% | not timed | not timed | 12.62 ± 1.5% | | 1.00 | 5.35 | 2.13 |
| 07-unicode-character-data/compile | 1 | 50.50 ± 1.1% | not timed | not timed | 24.30 ± 1.6% | 32.55 ± 3.1% | not timed | not timed | 50.52 ± 11.6% | | 1.00 | 2.08 | 1.55 |
| 09-aws-keys/compile-full | 1 | 34.48 ± 0.3% | not timed | not timed | 7.41 ± 0.7% | 20.13 ± 3.7% | not timed | not timed | 34.24 ± 0.8% | | 1.01 | 4.65 | 1.71 |
| 09-aws-keys/compile-quick | 1 | 158.58 ± 0.3% | not timed | not timed | 45.15 ± 0.4% | 116.79 ± 6.3% | not timed | not timed | 157.92 ± 1.3% | | 1.00 | 3.51 | 1.36 |
| 10-bounded-repeat/compile-context | 1 | 10.56 ± 0.3% | not timed | not timed | 11.55 ± 1.7% | 15.22 ± 3.3% | not timed | not timed | 10.54 ± 1.1% | | 1.00 | 0.91 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 74.04 ± 1.1% | not timed | not timed | 8.70 ± 2.5% | 22.21 ± 3.2% | not timed | not timed | 73.58 ± 1.4% | | 1.01 | 8.51 | 3.33 |
| 11-unstructured-to-json/compile | 1 | 76.61 ± 1.3% | not timed | not timed | 37.72 ± 2.4% | 59.54 ± 18.3% | not timed | not timed | 75.52 ± 2.0% | | 1.01 | 2.03 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.29 ± 0.4% | not timed | not timed | 0.07 ± 37.4% | 0.08 ± 5.5% | not timed | not timed | 0.29 ± 2.4% | | 1.01 | 4.27 | 3.57 |

