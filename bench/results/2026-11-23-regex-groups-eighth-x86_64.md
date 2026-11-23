# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215386835 |
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
| literal: a word | 217 | 33525.86 ± 4.0% | 3361.65 ± 0.1% | 20.29 ± 3.7% | 31430.92 ± 0.8% | 9079.74 ± 8.4% | 10.72 ± 0.1% | 75.75 ± 0.6% | 32713.17 ± 0.4% | 9.97 | 1.02 | 1.07 | 3.69 |
| literal: a word that is not there | 0 | 49901.84 ± 1.3% | 3250.24 ± 2.5% | 20.04 ± 1.4% | 39804.84 ± 0.6% | 30275.15 ± 0.6% | 10.64 ± 0.7% | 71.85 ± 1.7% | 48982.18 ± 0.7% | 15.35 | 1.02 | 1.25 | 1.65 |
| literal: one of four words | 661 | 11195.90 ± 1.1% | 1402.71 ± 0.2% | 11.00 ± 1.1% | 9148.53 ± 0.3% | 19.33 ± 0.9% | 4.00 ± 0.3% | 6.66 ± 1.3% | 11185.67 ± 2.4% | 7.98 | 1.00 | 1.22 | 579.27 |
| literal: a word in any case | 217 | 26180.68 ± 0.7% | 1495.15 ± 0.7% | 15.27 ± 1.2% | 9242.74 ± 0.6% | 37.32 ± 0.3% | refused | differs | 25861.45 ± 0.3% | 17.51 | 1.01 | 2.83 | 701.56 |
| literal: an href attribute | 33 | 27114.57 ± 1.9% | 538.57 ± 0.2% | 18.64 ± 2.3% | 27558.22 ± 0.2% | 2063.66 ± 0.8% | 8.21 ± 0.1% | 61.17 ± 1.5% | 26891.86 ± 0.5% | 50.35 | 1.01 | 0.98 | 13.14 |
| literal: a word, second text | 123 | 33990.02 ± 1.8% | 2390.08 ± 0.3% | 20.09 ± 2.8% | 32162.44 ± 1.2% | 7329.66 ± 5.5% | 11.80 ± 0.3% | 64.35 ± 3.4% | 34197.40 ± 18.7% | 14.22 | 0.99 | 1.06 | 4.64 |
| class: two capitalized words | 1331 | 770.36 ± 0.4% | 526.24 ± 0.3% | 18.69 ± 0.9% | 506.48 ± 0.1% | 34.40 ± 0.4% | 9.27 ± 0.1% | 55.73 ± 0.4% | 770.66 ± 0.1% | 1.46 | 1.00 | 1.52 | 22.40 |
| class: a word that ends in ing | 3399 | 499.03 ± 0.8% | 498.80 ± 3.6% | 12.99 ± 1.1% | 472.59 ± 0.2% | 25.76 ± 2.7% | 5.33 ± 0.6% | 17.20 ± 0.5% | 498.84 ± 1.1% | 1.00 | 1.00 | 1.06 | 19.37 |
| class: a word in capitals | 2332 | 954.48 ± 0.3% | 530.64 ± 0.2% | 19.79 ± 2.2% | 497.89 ± 0.4% | 36.71 ± 11.6% | 10.30 ± 0.6% | 76.50 ± 1.3% | 955.08 ± 0.4% | 1.80 | 1.00 | 1.92 | 26.00 |
| class: a number | 8288 | 1459.52 ± 0.4% | 701.81 ± 0.2% | 19.81 ± 1.7% | 1477.59 ± 0.3% | 35.53 ± 14.2% | 0.33 ± 0.7% | 55.79 ± 0.4% | 1457.61 ± 3.8% | 2.08 | 1.00 | 0.99 | 41.07 |
| class: two capitalized words, second text | 5359 | 441.97 ± 0.5% | 448.57 ± 0.4% | 15.42 ± 1.9% | 416.58 ± 1.2% | 30.00 ± 14.2% | 10.50 ± 0.8% | 51.61 ± 0.5% | 441.65 ± 1.2% | 0.99 | 1.00 | 1.06 | 14.73 |
| other: a word between two words | 6104 | 683.90 ± 0.2% | 511.94 ± 1.1% | 16.65 ± 1.5% | 697.18 ± 0.3% | 96.38 ± 11.5% | 7.24 ± 0.2% | 56.68 ± 0.7% | 683.20 ± 0.1% | 1.34 | 1.00 | 0.98 | 7.10 |
| other: a number before a unit, second text | 1481 | 7194.94 ± 1.3% | 862.90 ± 1.7% | 18.58 ± 1.5% | 6471.64 ± 0.4% | 35.16 ± 14.5% | 10.62 ± 0.2% | 55.14 ± 3.2% | 7129.83 ± 1.0% | 8.34 | 1.01 | 1.11 | 204.65 |
| other: a heading's start tag | 110 | 18715.47 ± 0.9% | 653.74 ± 0.8% | 19.36 ± 2.0% | 2005.22 ± 0.3% | 1482.89 ± 1.2% | 9.98 ± 0.4% | 72.71 ± 1.5% | 18632.06 ± 1.4% | 28.63 | 1.00 | 9.33 | 12.62 |
| other: a whole word | 217 | 23242.55 ± 2.1% | 530.73 ± 0.7% | 19.97 ± 1.1% | 22699.03 ± 0.5% | 39.84 ± 11.0% | 9.45 ± 0.2% | 46.87 ± 0.3% | 22769.79 ± 1.8% | 43.79 | 1.02 | 1.02 | 583.33 |
| other: a line's first word, second text | 3716 | 1907.72 ± 0.4% | 514.11 ± 0.1% | 22.33 ± 1.2% | 1721.52 ± 2.7% | 53.30 ± 1.7% | refused | refused | 1633.42 ± 0.7% | 3.71 | 1.17 | 1.11 | 35.79 |
| other: fourteen octets before an x | 87 | 25981.17 ± 1.3% | 208.28 ± 2.5% | 5.21 ± 0.7% | 2946.60 ± 0.5% | 9.01 ± 0.2% | differs | 15.42 ± 0.3% | 25803.32 ± 0.5% | 124.74 | 1.01 | 8.82 | 2884.52 |
| other: a Greek word | 21815 | 381.24 ± 0.4% | 336.14 ± 0.4% | 23.75 ± 1.0% | 263.11 ± 0.2% | 39.59 ± 8.8% | differs | refused | 387.38 ± 0.2% | 1.13 | 0.98 | 1.45 | 9.63 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.64 ± 0.4% | 18.66 ± 0.1% | 0.79 ± 1.1% | 16.77 ± 0.2% | 2.34 ± 0.4% | differs | 3.62 ± 1.6% | 18.64 ± 0.9% | 1.00 | 1.00 | 1.11 | 7.96 |
| a UUID | 32895 | 20.44 ± 0.2% | 20.40 ± 4.9% | 0.55 ± 0.4% | 12.83 ± 0.2% | 2.52 ± 1.5% | 0.44 ± 0.5% | 3.09 ± 0.6% | 20.42 ± 0.7% | 1.00 | 1.00 | 1.59 | 8.13 |
| an IPv4 address | 33176 | 34.04 ± 0.2% | 33.41 ± 9.7% | 1.71 ± 1.7% | 24.04 ± 0.6% | 5.80 ± 1.2% | differs | 3.41 ± 0.7% | 34.04 ± 0.3% | 1.02 | 1.00 | 1.42 | 5.87 |
| a date and time | 32954 | 30.14 ± 0.3% | 30.26 ± 1.3% | 1.25 ± 0.4% | 17.90 ± 0.6% | 6.70 ± 0.5% | 0.76 ± 1.7% | 6.18 ± 0.8% | 30.27 ± 0.3% | 1.00 | 1.00 | 1.68 | 4.50 |
| a field path | 32606 | 21.80 ± 0.7% | 21.74 ± 0.2% | 0.89 ± 0.4% | 19.37 ± 0.4% | 2.93 ± 0.7% | differs | 2.47 ± 1.3% | 21.81 ± 0.5% | 1.00 | 1.00 | 1.13 | 7.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.65 ± 4.3% | 8.71 ± 3.6% | 8.62 ± 3.2% | 10.14 ± 0.1% | 4.33 ± 1.5% | 0.62 ± 0.4% | none | 8.71 ± 2.8% | 0.99 | 0.99 | 0.85 | 2.00 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 203.69 ± 2.4% | 204.47 ± 2.6% | 236.97 ± 2.4% | 79.00 ± 5.0% | 185.98 ± 1.9% | 530.22 ± 3.1% | 3916.82 ± 2.4% | 203.80 ± 3.3% | 1.00 | 1.00 | 2.58 | 1.10 |
| a UUID | 62 | 130.49 ± 0.5% | 130.79 ± 1.0% | 144.88 ± 0.4% | 47.12 ± 1.0% | 91.28 ± 0.5% | 201.73 ± 1.6% | 4095.42 ± 0.4% | 130.49 ± 1.1% | 1.00 | 1.00 | 2.77 | 1.43 |
| an IPv4 address | 29 | 377.46 ± 1.5% | 377.29 ± 1.4% | 514.53 ± 1.7% | 70.23 ± 3.1% | 114.83 ± 1.9% | 323.46 ± 3.3% | 7106.01 ± 0.4% | 377.84 ± 5.7% | 1.00 | 1.00 | 5.37 | 3.29 |
| a date and time | 56 | 263.23 ± 4.6% | 263.44 ± 0.3% | 320.27 ± 0.4% | 68.42 ± 1.0% | 122.90 ± 1.7% | 367.41 ± 5.7% | 4242.89 ± 0.2% | 262.93 ± 10.6% | 1.00 | 1.00 | 3.85 | 2.14 |
| a field path | 39 | 202.51 ± 0.8% | 202.55 ± 0.5% | 236.20 ± 0.9% | 74.50 ± 2.2% | 175.33 ± 4.4% | 599.46 ± 6.6% | 4716.45 ± 14.9% | 202.16 ± 1.9% | 1.00 | 1.00 | 2.72 | 1.16 |
| literal: a word | 7 | 591.29 ± 0.7% | 634.18 ± 0.6% | 1088.35 ± 1.0% | 496.23 ± 0.8% | 575.09 ± 2.9% | 1255.28 ± 0.4% | 22245.32 ± 0.6% | 593.33 ± 0.5% | 0.93 | 1.00 | 1.19 | 1.03 |
| literal: a word that is not there | 8 | 568.27 ± 0.8% | 613.41 ± 0.4% | 1021.27 ± 0.8% | 458.98 ± 2.0% | 565.00 ± 1.4% | 1184.45 ± 0.6% | 21159.48 ± 0.9% | 566.68 ± 0.7% | 0.93 | 1.00 | 1.24 | 1.01 |
| literal: one of four words | 26 | 216.97 ± 0.6% | 353.14 ± 0.5% | 462.89 ± 0.8% | 41.48 ± 0.6% | 223.43 ± 4.4% | 431.63 ± 1.7% | 11542.66 ± 0.3% | 217.65 ± 0.2% | 0.61 | 1.00 | 5.23 | 0.97 |
| literal: a word in any case | 11 | 414.58 ± 0.3% | 435.88 ± 0.9% | 617.05 ± 0.9% | 14.51 ± 0.5% | 621.96 ± 1.4% | refused | 18260.47 ± 1.8% | 413.75 ± 0.9% | 0.95 | 1.00 | 28.57 | 0.67 |
| literal: an href attribute | 12 | 325.41 ± 1.2% | 334.49 ± 6.1% | 436.33 ± 0.7% | 37.32 ± 0.5% | 445.40 ± 1.7% | 939.76 ± 2.6% | 16787.93 ± 0.6% | 324.76 ± 3.5% | 0.97 | 1.00 | 8.72 | 0.73 |
| literal: a word, second text | 10 | 524.95 ± 0.6% | 571.07 ± 10.0% | 913.77 ± 1.4% | 407.79 ± 1.3% | 490.12 ± 3.9% | 997.15 ± 0.3% | 19438.61 ± 0.6% | 525.59 ± 12.5% | 0.92 | 1.00 | 1.29 | 1.07 |
| class: two capitalized words | 23 | 394.43 ± 1.3% | 421.18 ± 2.5% | 589.31 ± 3.4% | 95.10 ± 1.0% | 457.48 ± 1.0% | 901.03 ± 0.8% | 6388.07 ± 0.2% | 394.55 ± 0.6% | 0.94 | 1.00 | 4.15 | 0.86 |
| class: a word that ends in ing | 9 | 508.11 ± 0.5% | 564.41 ± 0.5% | 961.07 ± 0.5% | 112.90 ± 1.8% | 644.10 ± 1.4% | 1417.27 ± 1.7% | 14256.79 ± 1.0% | 506.01 ± 0.5% | 0.90 | 1.00 | 4.50 | 0.79 |
| class: a word in capitals | 16 | 423.30 ± 1.3% | 453.31 ± 0.9% | 712.24 ± 0.1% | 119.83 ± 1.9% | 652.48 ± 3.6% | 1243.13 ± 1.1% | 8354.30 ± 0.6% | 423.33 ± 0.3% | 0.93 | 1.00 | 3.53 | 0.65 |
| class: a number | 6 | 556.62 ± 10.2% | 610.35 ± 0.1% | 1120.73 ± 2.4% | 36.47 ± 0.9% | 1208.21 ± 2.6% | 2217.55 ± 3.1% | 19812.97 ± 3.3% | 555.18 ± 1.1% | 0.91 | 1.00 | 15.26 | 0.46 |
| class: two capitalized words, second text | 23 | 394.17 ± 7.1% | 420.82 ± 23.6% | 588.63 ± 88.1% | 95.27 ± 19.1% | 454.36 ± 1.6% | 889.28 ± 1.2% | 6368.00 ± 72.4% | 395.27 ± 34.8% | 0.94 | 1.00 | 4.14 | 0.87 |
| other: a word between two words | 13 | 498.44 ± 0.5% | 510.23 ± 1.4% | 774.38 ± 1.7% | 123.78 ± 0.5% | 444.51 ± 4.4% | 1003.47 ± 0.7% | 13338.31 ± 1.3% | 497.31 ± 11.8% | 0.98 | 1.00 | 4.03 | 1.12 |
| other: a number before a unit, second text | 15 | 367.57 ± 0.2% | 404.41 ± 2.8% | 557.58 ± 5.9% | 33.80 ± 5.6% | 544.56 ± 17.6% | 1108.34 ± 2.2% | 13592.01 ± 58.4% | 367.71 ± 0.3% | 0.91 | 1.00 | 10.87 | 0.67 |
| other: a heading's start tag | 13 | 332.17 ± 0.2% | 336.63 ± 0.7% | 439.50 ± 0.2% | 35.80 ± 0.8% | 540.95 ± 3.3% | 1078.70 ± 0.6% | 15620.15 ± 0.3% | 332.14 ± 0.3% | 0.99 | 1.00 | 9.28 | 0.61 |
| other: a whole word | 11 | 510.78 ± 1.8% | 540.50 ± 0.7% | 838.31 ± 0.4% | 110.08 ± 3.9% | 513.68 ± 0.8% | 1042.87 ± 1.1% | 20823.78 ± 3.8% | 510.43 ± 0.4% | 0.95 | 1.00 | 4.64 | 0.99 |
| other: a line's first word, second text | 17 | 476.16 ± 0.4% | 490.45 ± 11.4% | 775.24 ± 1.4% | 113.35 ± 10.3% | 605.20 ± 2.3% | refused | refused | 475.37 ± 1.2% | 0.97 | 1.00 | 4.20 | 0.79 |
| other: fourteen octets before an x | 16 | 88.09 ± 0.5% | 124.24 ± 5.8% | 141.51 ± 0.3% | 14.22 ± 9.9% | 398.60 ± 1.1% | 453.27 ± 5.1% | 11394.44 ± 0.4% | 88.03 ± 1.1% | 0.71 | 1.00 | 6.19 | 0.22 |
| other: a Greek word | 8 | 391.61 ± 2.3% | 535.86 ± 2.5% | 890.73 ± 2.6% | 45.17 ± 17.3% | 1179.73 ± 4.9% | 2206.89 ± 3.4% | refused | 393.65 ± 2.2% | 0.73 | 0.99 | 8.67 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 22042.63 ± 1.6% | not timed | not timed | 27047.74 ± 1.1% | 1830.40 ± 14.8% | not timed | not timed | 22104.33 ± 9.3% | | 1.00 | 0.81 | 12.04 |
| 01-literal/sherlock-casei-en | 522 | 7627.62 ± 0.9% | not timed | not timed | 7070.16 ± 0.4% | 28.25 ± 12.1% | not timed | not timed | 7584.46 ± 0.8% | | 1.01 | 1.08 | 269.98 |
| 01-literal/sherlock-ru | 724 | 23664.03 ± 1.5% | not timed | not timed | 27917.05 ± 0.6% | 1061.11 ± 3.5% | not timed | not timed | 23639.90 ± 2.2% | | 1.00 | 0.85 | 22.30 |
| 01-literal/sherlock-casei-ru | 746 | 9455.19 ± 0.5% | not timed | not timed | 5535.89 ± 0.7% | 30.58 ± 8.7% | not timed | not timed | 9446.80 ± 1.0% | | 1.00 | 1.71 | 309.23 |
| 01-literal/sherlock-zh | 30 | 42502.76 ± 1.5% | not timed | not timed | 36945.24 ± 1.5% | 1261.95 ± 0.2% | not timed | not timed | 42383.24 ± 2.5% | | 1.00 | 1.15 | 33.68 |
| 02-literal-alternate/sherlock-en | 714 | 9613.44 ± 12.2% | not timed | not timed | 8873.94 ± 0.2% | 14.21 ± 1.2% | not timed | not timed | 9669.08 ± 0.2% | | 0.99 | 1.08 | 676.29 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1989.39 ± 0.8% | not timed | not timed | 1822.64 ± 0.2% | 9.19 ± 1.6% | not timed | not timed | 1969.47 ± 0.6% | | 1.01 | 1.09 | 216.45 |
| 02-literal-alternate/sherlock-ru | 899 | 7896.84 ± 0.7% | not timed | not timed | 4251.35 ± 0.1% | 19.48 ± 1.2% | not timed | not timed | 7849.26 ± 0.5% | | 1.01 | 1.86 | 405.47 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2066.53 ± 0.5% | not timed | not timed | 1043.67 ± 0.4% | 8.56 ± 5.3% | not timed | not timed | 2064.26 ± 0.3% | | 1.00 | 1.98 | 241.32 |
| 02-literal-alternate/sherlock-zh | 207 | 13987.97 ± 1.9% | not timed | not timed | 10437.29 ± 0.2% | 26.90 ± 1.0% | not timed | not timed | 13995.95 ± 0.3% | | 1.00 | 1.34 | 520.02 |
| 03-date/ascii | 111817 | 98.54 ± 0.3% | not timed | not timed | 83.91 ± 0.7% | 0.18 ± 4.0% | not timed | not timed | 98.33 ± 7.4% | | 1.00 | 1.17 | 549.26 |
| 04-ruff-noqa/real | 84 | 419.34 ± 7.1% | not timed | not timed | 446.26 ± 0.2% | 15.83 ± 1.1% | not timed | not timed | 419.57 ± 0.7% | | 1.00 | 0.94 | 26.50 |
| 04-ruff-noqa/tweaked | 44 | 475.62 ± 0.7% | not timed | not timed | 430.19 ± 0.1% | 294.41 ± 0.9% | not timed | not timed | 475.74 ± 0.8% | | 1.00 | 1.11 | 1.62 |
| 05-lexer-veryl/single | 124800 | 3.35 ± 3.0% | not timed | not timed | 4.00 ± 1.1% | 0.21 ± 6.3% | not timed | not timed | 3.30 ± 5.3% | | 1.01 | 0.84 | 15.79 |
| 06-cloud-flare-redos/original | 107 | 347.56 ± 0.6% | not timed | not timed | 191.20 ± 5.2% | 20.29 ± 2.0% | not timed | not timed | 348.53 ± 0.5% | | 1.00 | 1.82 | 17.13 |
| 06-cloud-flare-redos/simplified-short | 102 | 334.95 ± 0.4% | not timed | not timed | 192.34 ± 0.6% | 21.90 ± 2.6% | not timed | not timed | 334.28 ± 3.5% | | 1.00 | 1.74 | 15.29 |
| 06-cloud-flare-redos/simplified-long | 10000 | 460.42 ± 1.2% | not timed | not timed | 208.14 ± 10.4% | 23.62 ± 3.3% | not timed | not timed | 461.06 ± 1.2% | | 1.00 | 2.21 | 19.49 |
| 07-unicode-character-data/parse-line | 558784 | 197.72 ± 1.0% | not timed | not timed | 161.02 ± 0.3% | 36.11 ± 7.9% | not timed | not timed | 194.48 ± 2.9% | | 1.02 | 1.23 | 5.47 |
| 08-words/all-english | 56691 | 97.76 ± 1.0% | not timed | not timed | 73.68 ± 0.3% | 10.40 ± 13.0% | not timed | not timed | 97.77 ± 0.8% | | 1.00 | 1.33 | 9.40 |
| 08-words/long-english | 839 | 536.15 ± 0.9% | not timed | not timed | 515.19 ± 0.6% | 26.20 ± 1.0% | not timed | not timed | 535.89 ± 0.2% | | 1.00 | 1.04 | 20.46 |
| 09-aws-keys/full | 0 | 426.11 ± 8.9% | not timed | not timed | 435.62 ± 0.3% | 53.92 ± 6.2% | not timed | not timed | 426.16 ± 0.1% | | 1.00 | 0.98 | 7.90 |
| 09-aws-keys/quick | 0 | 786.93 ± 8.6% | not timed | not timed | 803.91 ± 0.6% | 333.27 ± 0.4% | not timed | not timed | 784.74 ± 6.8% | | 1.00 | 0.98 | 2.36 |
| 10-bounded-repeat/letters-en | 1833 | 487.03 ± 0.6% | not timed | not timed | 431.36 ± 0.2% | 16.94 ± 0.9% | not timed | not timed | 487.00 ± 3.0% | | 1.00 | 1.13 | 28.75 |
| 10-bounded-repeat/letters-ru | 3475 | 431.91 ± 2.6% | not timed | not timed | 409.42 ± 0.7% | 19.81 ± 5.7% | not timed | not timed | 431.75 ± 1.0% | | 1.00 | 1.05 | 21.80 |
| 10-bounded-repeat/context | 53 | 63.72 ± 1.4% | not timed | not timed | 55.44 ± 2.1% | 16.90 ± 0.7% | not timed | not timed | 63.64 ± 0.9% | | 1.00 | 1.15 | 3.77 |
| 10-bounded-repeat/capitals | 11 | 558.64 ± 7.8% | not timed | not timed | 533.58 ± 0.8% | 30.94 ± 0.5% | not timed | not timed | 557.16 ± 8.1% | | 1.00 | 1.05 | 18.05 |
| 11-unstructured-to-json/extract | 600 | 54.09 ± 0.4% | not timed | not timed | 62.36 ± 6.1% | 40.36 ± 5.9% | not timed | not timed | 53.95 ± 0.5% | | 1.00 | 0.87 | 1.34 |
| 12-dictionary/single | 1 | 463.03 ± 0.3% | not timed | not timed | 441.55 ± 0.3% | 0.32 ± 5.0% | not timed | not timed | 463.92 ± 0.6% | | 1.00 | 1.05 | 1457.37 |
| 14-quadratic/1x | 100 | 20.72 ± 1.3% | not timed | not timed | 9.10 ± 0.3% | 0.78 ± 22.1% | not timed | not timed | 20.76 ± 16.8% | | 1.00 | 2.28 | 26.44 |
| 14-quadratic/2x | 200 | 16.05 ± 0.3% | not timed | not timed | 4.92 ± 0.3% | 0.43 ± 17.5% | not timed | not timed | 16.02 ± 3.4% | | 1.00 | 3.27 | 37.38 |
| 14-quadratic/10x | 1000 | 5.62 ± 0.3% | not timed | not timed | 1.05 ± 1.4% | 0.09 ± 15.3% | not timed | not timed | 5.61 ± 1.2% | | 1.00 | 5.35 | 60.51 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.20 ± 0.4% | not timed | not timed | 0.39 ± 0.9% | 0.48 ± 2.8% | not timed | not timed | 1.19 ± 2.1% | | 1.01 | 3.09 | 2.51 |
| 04-ruff-noqa/compile-real | 1 | 85.52 ± 16.0% | not timed | not timed | 12.86 ± 0.6% | 125.66 ± 2.5% | not timed | not timed | 84.95 ± 0.8% | | 1.01 | 6.65 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 12.75 ± 10.4% | not timed | not timed | 2.35 ± 4.8% | 5.91 ± 2.5% | not timed | not timed | 12.68 ± 0.6% | | 1.01 | 5.43 | 2.16 |
| 07-unicode-character-data/compile | 1 | 52.59 ± 0.2% | not timed | not timed | 24.33 ± 1.3% | 33.30 ± 2.7% | not timed | not timed | 52.35 ± 1.3% | | 1.00 | 2.16 | 1.58 |
| 09-aws-keys/compile-full | 1 | 35.44 ± 2.7% | not timed | not timed | 7.43 ± 19.8% | 20.80 ± 4.9% | not timed | not timed | 35.23 ± 1.1% | | 1.01 | 4.77 | 1.70 |
| 09-aws-keys/compile-quick | 1 | 159.51 ± 0.5% | not timed | not timed | 45.50 ± 2.8% | 119.09 ± 3.1% | not timed | not timed | 155.82 ± 1.7% | | 1.02 | 3.51 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 10.58 ± 0.5% | not timed | not timed | 11.68 ± 1.3% | 15.24 ± 2.3% | not timed | not timed | 10.58 ± 0.5% | | 1.00 | 0.91 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 72.57 ± 0.7% | not timed | not timed | 8.81 ± 1.2% | 22.47 ± 4.4% | not timed | not timed | 72.75 ± 1.5% | | 1.00 | 8.24 | 3.23 |
| 11-unstructured-to-json/compile | 1 | 77.40 ± 1.1% | not timed | not timed | 36.59 ± 1.1% | 61.11 ± 2.9% | not timed | not timed | 77.95 ± 0.4% | | 0.99 | 2.12 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.6% | not timed | not timed | 0.07 ± 4.0% | 0.09 ± 14.6% | not timed | not timed | 0.28 ± 3.0% | | 1.01 | 4.19 | 3.29 |

