# bench-regex

| Field | Value |
|---|---|
| Commit | 8dc8c1d |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45243558241 |
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
| literal: a word | 217 | 39258.18 ± 5.9% | 3348.86 ± 1.2% | 19.94 ± 1.5% | 30980.73 ± 1.5% | 9005.37 ± 8.5% | 10.76 ± 0.3% | 76.39 ± 0.6% | 38355.32 ± 2.0% | 11.72 | 1.02 | 1.27 | 4.36 |
| literal: a word that is not there | 0 | 52274.58 ± 4.2% | 3249.85 ± 0.5% | 19.99 ± 1.9% | 39303.43 ± 2.5% | 29476.42 ± 1.0% | 10.71 ± 1.5% | 71.99 ± 1.7% | 51410.43 ± 3.5% | 16.09 | 1.02 | 1.33 | 1.77 |
| literal: one of four words | 661 | 11614.81 ± 2.0% | 1394.79 ± 2.6% | 11.15 ± 3.7% | 9143.45 ± 3.6% | 19.13 ± 2.0% | 3.99 ± 0.1% | 6.02 ± 0.1% | 11617.83 ± 0.9% | 8.33 | 1.00 | 1.27 | 607.16 |
| literal: a word in any case | 217 | 30044.21 ± 2.3% | 1493.46 ± 0.8% | 15.05 ± 3.7% | 9231.80 ± 0.7% | 37.20 ± 0.8% | refused | differs | 29263.97 ± 3.8% | 20.12 | 1.03 | 3.25 | 807.69 |
| literal: an href attribute | 33 | 29417.54 ± 4.1% | 539.86 ± 0.1% | 18.42 ± 1.6% | 27022.48 ± 0.6% | 2063.57 ± 0.9% | 8.23 ± 0.3% | 63.27 ± 0.6% | 28533.32 ± 2.8% | 54.49 | 1.03 | 1.09 | 14.26 |
| literal: a word, second text | 123 | 37297.22 ± 3.8% | 2376.51 ± 0.7% | 19.78 ± 5.9% | 31567.47 ± 1.2% | 7148.65 ± 4.2% | 11.82 ± 0.7% | 65.28 ± 1.0% | 36465.30 ± 2.3% | 15.69 | 1.02 | 1.18 | 5.22 |
| class: two capitalized words | 1331 | 764.37 ± 0.3% | 526.58 ± 0.2% | 18.65 ± 6.4% | 506.45 ± 0.1% | 34.36 ± 16.6% | 9.32 ± 0.6% | 57.46 ± 0.2% | 763.04 ± 2.1% | 1.45 | 1.00 | 1.51 | 22.25 |
| class: a word that ends in ing | 3399 | 499.57 ± 1.0% | 498.39 ± 5.8% | 12.94 ± 9.5% | 472.04 ± 0.3% | 25.58 ± 6.1% | 5.34 ± 0.6% | 16.44 ± 0.7% | 499.73 ± 1.0% | 1.00 | 1.00 | 1.06 | 19.53 |
| class: a word in capitals | 2332 | 942.29 ± 0.5% | 531.08 ± 0.3% | 19.70 ± 1.9% | 497.05 ± 0.7% | 36.59 ± 14.1% | 10.33 ± 0.8% | 77.63 ± 2.4% | 942.04 ± 0.1% | 1.77 | 1.00 | 1.90 | 25.75 |
| class: a number | 8288 | 1447.55 ± 1.0% | 697.97 ± 0.4% | 19.54 ± 0.8% | 1475.62 ± 0.4% | 35.08 ± 11.2% | 0.33 ± 1.0% | 55.58 ± 0.3% | 1447.30 ± 0.2% | 2.07 | 1.00 | 0.98 | 41.27 |
| class: two capitalized words, second text | 5359 | 433.49 ± 0.3% | 450.28 ± 0.6% | 16.87 ± 7.6% | 417.20 ± 0.2% | 29.17 ± 10.4% | 10.46 ± 0.2% | 52.79 ± 0.8% | 443.79 ± 0.3% | 0.96 | 0.98 | 1.04 | 14.86 |
| other: a word between two words | 6104 | 702.30 ± 4.3% | 509.93 ± 0.4% | 16.67 ± 1.2% | 699.12 ± 1.6% | 93.34 ± 12.6% | 7.26 ± 0.2% | 58.11 ± 0.8% | 708.38 ± 0.1% | 1.38 | 0.99 | 1.00 | 7.52 |
| other: a number before a unit, second text | 1481 | 7241.34 ± 10.9% | 856.37 ± 2.0% | 18.40 ± 3.4% | 6288.15 ± 5.7% | 34.54 ± 2.8% | 10.81 ± 0.9% | 56.07 ± 2.6% | 7231.07 ± 3.0% | 8.46 | 1.00 | 1.15 | 209.63 |
| other: a heading's start tag | 110 | 19744.79 ± 4.8% | 654.34 ± 0.1% | 19.47 ± 1.8% | 1999.98 ± 1.0% | 1478.87 ± 3.8% | 9.74 ± 0.6% | 74.25 ± 0.8% | 18931.59 ± 3.5% | 30.18 | 1.04 | 9.87 | 13.35 |
| other: a whole word | 217 | 23577.62 ± 3.4% | 531.54 ± 0.3% | 19.60 ± 1.3% | 22325.10 ± 1.7% | 40.13 ± 0.7% | 9.46 ± 0.2% | 46.30 ± 1.5% | 22665.05 ± 1.9% | 44.36 | 1.04 | 1.06 | 587.53 |
| other: a line's first word, second text | 3716 | 1938.80 ± 4.5% | 513.24 ± 0.4% | 22.44 ± 1.4% | 1679.76 ± 2.4% | 52.73 ± 3.0% | refused | refused | 1983.65 ± 4.8% | 3.78 | 0.98 | 1.15 | 36.77 |
| other: fourteen octets before an x | 87 | 27371.75 ± 4.6% | 207.36 ± 1.2% | 5.42 ± 3.5% | 2889.98 ± 3.5% | 8.99 ± 0.5% | differs | 14.65 ± 7.3% | 26782.46 ± 1.2% | 132.00 | 1.02 | 9.47 | 3043.79 |
| other: a Greek word | 21815 | 384.07 ± 0.8% | 335.75 ± 0.1% | 23.43 ± 2.2% | 264.85 ± 0.5% | 44.84 ± 8.6% | differs | refused | 383.49 ± 0.4% | 1.14 | 1.00 | 1.45 | 8.57 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 16.93 ± 1.0% | 16.92 ± 0.6% | 0.78 ± 0.8% | 16.77 ± 0.3% | 2.32 ± 0.4% | differs | 3.62 ± 0.6% | 16.88 ± 0.6% | 1.00 | 1.00 | 1.01 | 7.28 |
| a UUID | 32895 | 18.32 ± 0.2% | 18.27 ± 0.3% | 0.54 ± 0.5% | 12.84 ± 0.8% | 2.50 ± 1.2% | 0.44 ± 0.1% | 2.99 ± 3.3% | 18.29 ± 0.8% | 1.00 | 1.00 | 1.43 | 7.33 |
| an IPv4 address | 33176 | 30.46 ± 2.6% | 30.03 ± 1.1% | 1.76 ± 0.3% | 23.94 ± 0.2% | 5.71 ± 1.1% | differs | 3.37 ± 1.6% | 30.56 ± 1.1% | 1.01 | 1.00 | 1.27 | 5.34 |
| a date and time | 32954 | 27.09 ± 0.5% | 27.17 ± 0.2% | 1.24 ± 2.0% | 17.87 ± 0.3% | 6.57 ± 0.9% | 0.76 ± 1.3% | 5.93 ± 2.3% | 27.16 ± 9.4% | 1.00 | 1.00 | 1.52 | 4.12 |
| a field path | 32606 | 19.89 ± 0.6% | 19.91 ± 7.0% | 0.88 ± 11.7% | 19.34 ± 0.8% | 2.91 ± 0.3% | differs | 2.43 ± 0.6% | 19.93 ± 0.2% | 1.00 | 1.00 | 1.03 | 6.83 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.68 ± 0.1% | 8.69 ± 0.5% | 8.72 ± 0.4% | 10.64 ± 4.3% | 4.71 ± 1.4% | 0.62 ± 0.2% | none | 8.70 ± 0.8% | 1.00 | 1.00 | 0.82 | 1.84 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 203.33 ± 1.1% | 204.48 ± 1.5% | 239.81 ± 1.4% | 80.18 ± 3.6% | 184.03 ± 3.4% | 543.01 ± 5.3% | 3490.55 ± 4.5% | 203.18 ± 0.5% | 0.99 | 1.00 | 2.54 | 1.10 |
| a UUID | 62 | 132.08 ± 0.5% | 132.68 ± 0.8% | 148.28 ± 1.5% | 46.05 ± 1.7% | 88.65 ± 2.3% | 202.06 ± 2.5% | 3864.68 ± 1.6% | 131.98 ± 0.4% | 1.00 | 1.00 | 2.87 | 1.49 |
| an IPv4 address | 29 | 381.53 ± 1.1% | 386.60 ± 1.0% | 529.58 ± 1.2% | 70.27 ± 0.4% | 109.20 ± 37.4% | 316.92 ± 3.6% | 6590.67 ± 2.8% | 382.91 ± 0.6% | 0.99 | 1.00 | 5.43 | 3.49 |
| a date and time | 56 | 277.91 ± 0.2% | 279.40 ± 1.0% | 347.09 ± 0.3% | 68.81 ± 0.6% | 121.03 ± 4.7% | 371.63 ± 2.5% | 3870.24 ± 16.9% | 278.00 ± 11.7% | 0.99 | 1.00 | 4.04 | 2.30 |
| a field path | 39 | 204.24 ± 0.7% | 205.70 ± 0.5% | 241.88 ± 0.9% | 74.10 ± 0.9% | 172.91 ± 13.1% | 583.30 ± 7.1% | 4586.70 ± 3.0% | 204.44 ± 0.3% | 0.99 | 1.00 | 2.76 | 1.18 |
| literal: a word | 7 | 571.31 ± 1.4% | 618.13 ± 0.9% | 1077.90 ± 12.4% | 474.60 ± 11.9% | 586.47 ± 1.4% | 1246.26 ± 0.5% | 24422.39 ± 0.5% | 571.37 ± 0.8% | 0.92 | 1.00 | 1.20 | 0.97 |
| literal: a word that is not there | 8 | 545.55 ± 3.1% | 598.03 ± 0.6% | 1008.97 ± 1.3% | 443.70 ± 1.7% | 558.21 ± 3.7% | 1176.63 ± 0.7% | 23402.57 ± 0.7% | 546.54 ± 0.8% | 0.91 | 1.00 | 1.23 | 0.98 |
| literal: one of four words | 26 | 209.60 ± 2.2% | 348.08 ± 7.7% | 467.79 ± 2.9% | 41.62 ± 3.3% | 216.49 ± 16.0% | 443.89 ± 3.1% | 9664.08 ± 5.6% | 206.55 ± 4.3% | 0.60 | 1.01 | 5.04 | 0.97 |
| literal: a word in any case | 11 | 396.30 ± 1.9% | 419.14 ± 1.2% | 595.00 ± 4.0% | 14.67 ± 3.1% | 617.50 ± 2.2% | refused | 18624.42 ± 0.9% | 395.99 ± 0.3% | 0.95 | 1.00 | 27.01 | 0.64 |
| literal: an href attribute | 12 | 323.52 ± 0.7% | 337.72 ± 0.3% | 448.33 ± 0.4% | 36.65 ± 3.0% | 429.92 ± 2.8% | 933.48 ± 1.1% | 17311.32 ± 0.4% | 323.23 ± 0.4% | 0.96 | 1.00 | 8.83 | 0.75 |
| literal: a word, second text | 10 | 507.13 ± 0.5% | 557.63 ± 0.9% | 906.66 ± 1.5% | 405.80 ± 0.5% | 483.34 ± 1.8% | 988.54 ± 0.5% | 20174.58 ± 2.3% | 505.67 ± 6.2% | 0.91 | 1.00 | 1.25 | 1.05 |
| class: two capitalized words | 23 | 412.64 ± 2.5% | 444.95 ± 2.9% | 645.15 ± 4.7% | 96.23 ± 1.2% | 451.96 ± 2.0% | 882.83 ± 11.6% | 6114.94 ± 0.7% | 412.67 ± 8.0% | 0.93 | 1.00 | 4.29 | 0.91 |
| class: a word that ends in ing | 9 | 496.29 ± 1.1% | 571.15 ± 2.1% | 999.62 ± 0.7% | 112.62 ± 1.0% | 638.72 ± 1.8% | 1401.44 ± 0.9% | 14840.26 ± 0.3% | 495.79 ± 0.6% | 0.87 | 1.00 | 4.41 | 0.78 |
| class: a word in capitals | 16 | 429.60 ± 1.0% | 465.40 ± 0.5% | 772.53 ± 1.1% | 121.27 ± 1.5% | 646.26 ± 2.7% | 1252.19 ± 2.5% | 8227.95 ± 1.9% | 428.76 ± 0.4% | 0.92 | 1.00 | 3.54 | 0.66 |
| class: a number | 6 | 551.31 ± 0.4% | 609.72 ± 1.0% | 1173.90 ± 3.1% | 36.41 ± 1.1% | 1182.41 ± 3.8% | 2068.03 ± 4.0% | 20192.19 ± 0.7% | 550.51 ± 3.0% | 0.90 | 1.00 | 15.14 | 0.47 |
| class: two capitalized words, second text | 23 | 412.97 ± 8.0% | 446.12 ± 0.7% | 643.96 ± 1.8% | 96.81 ± 9.1% | 450.91 ± 3.3% | 860.99 ± 1.4% | 6125.21 ± 0.3% | 412.48 ± 1.0% | 0.93 | 1.00 | 4.27 | 0.92 |
| other: a word between two words | 13 | 491.49 ± 9.2% | 516.31 ± 2.1% | 803.69 ± 0.5% | 122.71 ± 0.8% | 437.31 ± 3.2% | 1021.96 ± 1.3% | 12342.57 ± 2.1% | 492.89 ± 0.4% | 0.95 | 1.00 | 4.01 | 1.12 |
| other: a number before a unit, second text | 15 | 367.13 ± 0.7% | 414.91 ± 0.9% | 584.83 ± 0.3% | 33.60 ± 1.1% | 535.35 ± 4.8% | 1121.08 ± 2.5% | 12858.66 ± 3.2% | 366.03 ± 2.8% | 0.88 | 1.00 | 10.93 | 0.69 |
| other: a heading's start tag | 13 | 335.98 ± 0.3% | 343.91 ± 0.4% | 458.31 ± 0.9% | 34.46 ± 2.2% | 519.26 ± 1.1% | 1053.72 ± 1.9% | 15244.74 ± 4.5% | 335.34 ± 2.6% | 0.98 | 1.00 | 9.75 | 0.65 |
| other: a whole word | 11 | 498.36 ± 0.7% | 533.04 ± 0.6% | 835.06 ± 0.8% | 110.43 ± 0.9% | 502.68 ± 1.4% | 1036.39 ± 12.7% | 19452.26 ± 4.2% | 500.11 ± 0.6% | 0.93 | 1.00 | 4.51 | 0.99 |
| other: a line's first word, second text | 17 | 473.16 ± 4.4% | 505.21 ± 0.4% | 815.55 ± 5.1% | 115.90 ± 0.8% | 601.77 ± 2.2% | refused | refused | 473.75 ± 9.9% | 0.94 | 1.00 | 4.08 | 0.79 |
| other: fourteen octets before an x | 16 | 87.87 ± 0.3% | 124.90 ± 0.8% | 143.92 ± 3.7% | 14.12 ± 1.1% | 396.89 ± 23.2% | 453.45 ± 0.9% | 11742.73 ± 0.4% | 87.69 ± 0.9% | 0.70 | 1.00 | 6.22 | 0.22 |
| other: a Greek word | 8 | 376.33 ± 0.6% | 540.36 ± 0.4% | 940.00 ± 0.3% | 45.44 ± 17.1% | 1172.23 ± 1.2% | 2246.33 ± 1.1% | refused | 376.34 ± 0.1% | 0.70 | 1.00 | 8.28 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 26625.81 ± 3.4% | not timed | not timed | 26709.60 ± 0.9% | 1872.97 ± 28.4% | not timed | not timed | 26375.31 ± 10.0% | | 1.01 | 1.00 | 14.22 |
| 01-literal/sherlock-casei-en | 522 | 8006.69 ± 0.9% | not timed | not timed | 7044.49 ± 0.4% | 23.50 ± 0.8% | not timed | not timed | 7987.82 ± 1.4% | | 1.00 | 1.14 | 340.70 |
| 01-literal/sherlock-ru | 724 | 28180.72 ± 4.8% | not timed | not timed | 27478.61 ± 2.2% | 1064.69 ± 7.1% | not timed | not timed | 28113.70 ± 1.2% | | 1.00 | 1.03 | 26.47 |
| 01-literal/sherlock-casei-ru | 746 | 9743.05 ± 0.4% | not timed | not timed | 5501.34 ± 0.6% | 29.82 ± 0.3% | not timed | not timed | 9713.93 ± 0.4% | | 1.00 | 1.77 | 326.76 |
| 01-literal/sherlock-zh | 30 | 46671.69 ± 0.9% | not timed | not timed | 36211.76 ± 0.6% | 1259.00 ± 1.7% | not timed | not timed | 46199.15 ± 3.3% | | 1.01 | 1.29 | 37.07 |
| 02-literal-alternate/sherlock-en | 714 | 10062.14 ± 0.4% | not timed | not timed | 8879.29 ± 0.3% | 14.76 ± 20.2% | not timed | not timed | 10067.41 ± 10.3% | | 1.00 | 1.13 | 681.85 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2043.01 ± 0.4% | not timed | not timed | 1816.36 ± 0.2% | 8.89 ± 2.6% | not timed | not timed | 2021.15 ± 1.2% | | 1.01 | 1.12 | 229.91 |
| 02-literal-alternate/sherlock-ru | 899 | 8187.13 ± 0.2% | not timed | not timed | 4246.66 ± 0.4% | 19.07 ± 0.7% | not timed | not timed | 8185.00 ± 6.4% | | 1.00 | 1.93 | 429.29 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2094.26 ± 7.8% | not timed | not timed | 1037.72 ± 2.9% | 8.47 ± 1.1% | not timed | not timed | 2096.70 ± 0.3% | | 1.00 | 2.02 | 247.22 |
| 02-literal-alternate/sherlock-zh | 207 | 14464.28 ± 0.5% | not timed | not timed | 10441.36 ± 0.4% | 19.25 ± 19.8% | not timed | not timed | 14456.01 ± 13.8% | | 1.00 | 1.39 | 751.32 |
| 03-date/ascii | 111817 | 96.03 ± 0.6% | not timed | not timed | 84.00 ± 1.5% | 0.18 ± 2.9% | not timed | not timed | 95.19 ± 0.7% | | 1.01 | 1.14 | 545.95 |
| 04-ruff-noqa/real | 84 | 410.08 ± 0.4% | not timed | not timed | 443.69 ± 1.5% | 14.86 ± 2.9% | not timed | not timed | 410.51 ± 0.9% | | 1.00 | 0.92 | 27.59 |
| 04-ruff-noqa/tweaked | 44 | 510.58 ± 0.6% | not timed | not timed | 428.67 ± 1.4% | 293.86 ± 0.9% | not timed | not timed | 510.26 ± 0.3% | | 1.00 | 1.19 | 1.74 |
| 05-lexer-veryl/single | 124800 | 3.48 ± 1.4% | not timed | not timed | 4.16 ± 0.8% | 0.21 ± 5.2% | not timed | not timed | 3.47 ± 1.3% | | 1.00 | 0.84 | 16.54 |
| 06-cloud-flare-redos/original | 107 | 349.16 ± 0.6% | not timed | not timed | 191.92 ± 9.3% | 14.68 ± 50.2% | not timed | not timed | 345.72 ± 5.1% | | 1.01 | 1.82 | 23.79 |
| 06-cloud-flare-redos/simplified-short | 102 | 330.71 ± 1.1% | not timed | not timed | 192.33 ± 0.3% | 21.75 ± 8.7% | not timed | not timed | 329.57 ± 6.8% | | 1.00 | 1.72 | 15.20 |
| 06-cloud-flare-redos/simplified-long | 10000 | 465.06 ± 1.2% | not timed | not timed | 211.72 ± 0.3% | 24.17 ± 0.3% | not timed | not timed | 465.03 ± 0.1% | | 1.00 | 2.20 | 19.24 |
| 07-unicode-character-data/parse-line | 558784 | 204.38 ± 0.4% | not timed | not timed | 160.41 ± 0.6% | 36.78 ± 2.0% | not timed | not timed | 204.10 ± 0.5% | | 1.00 | 1.27 | 5.56 |
| 08-words/all-english | 56691 | 95.52 ± 0.3% | not timed | not timed | 72.33 ± 12.6% | 10.22 ± 6.6% | not timed | not timed | 95.23 ± 0.7% | | 1.00 | 1.32 | 9.35 |
| 08-words/long-english | 839 | 536.14 ± 0.9% | not timed | not timed | 513.63 ± 0.2% | 26.14 ± 7.6% | not timed | not timed | 535.66 ± 0.6% | | 1.00 | 1.04 | 20.51 |
| 09-aws-keys/full | 0 | 414.90 ± 4.6% | not timed | not timed | 448.71 ± 0.8% | 54.45 ± 1.5% | not timed | not timed | 415.37 ± 0.2% | | 1.00 | 0.92 | 7.62 |
| 09-aws-keys/quick | 0 | 949.49 ± 0.1% | not timed | not timed | 802.34 ± 1.1% | 330.71 ± 1.0% | not timed | not timed | 946.13 ± 0.6% | | 1.00 | 1.18 | 2.87 |
| 10-bounded-repeat/letters-en | 1833 | 482.45 ± 0.9% | not timed | not timed | 431.02 ± 0.3% | 16.94 ± 1.2% | not timed | not timed | 482.31 ± 0.3% | | 1.00 | 1.12 | 28.49 |
| 10-bounded-repeat/letters-ru | 3475 | 429.44 ± 0.3% | not timed | not timed | 408.05 ± 1.1% | 18.87 ± 12.5% | not timed | not timed | 427.78 ± 0.9% | | 1.00 | 1.05 | 22.76 |
| 10-bounded-repeat/context | 53 | 64.94 ± 4.2% | not timed | not timed | 56.28 ± 1.9% | 16.89 ± 0.9% | not timed | not timed | 65.20 ± 0.5% | | 1.00 | 1.15 | 3.84 |
| 10-bounded-repeat/capitals | 11 | 557.41 ± 8.0% | not timed | not timed | 532.42 ± 0.1% | 30.88 ± 0.2% | not timed | not timed | 552.16 ± 8.1% | | 1.01 | 1.05 | 18.05 |
| 11-unstructured-to-json/extract | 600 | 55.04 ± 4.5% | not timed | not timed | 62.27 ± 0.6% | 40.54 ± 0.8% | not timed | not timed | 55.21 ± 3.9% | | 1.00 | 0.88 | 1.36 |
| 12-dictionary/single | 1 | 458.56 ± 2.8% | not timed | not timed | 442.28 ± 2.4% | 0.32 ± 5.8% | not timed | not timed | 459.76 ± 0.3% | | 1.00 | 1.04 | 1421.41 |
| 14-quadratic/1x | 100 | 21.19 ± 36.3% | not timed | not timed | 9.11 ± 0.8% | 0.79 ± 5.7% | not timed | not timed | 21.00 ± 1.5% | | 1.01 | 2.33 | 26.83 |
| 14-quadratic/2x | 200 | 16.14 ± 1.7% | not timed | not timed | 4.83 ± 0.2% | 0.43 ± 19.1% | not timed | not timed | 16.07 ± 1.6% | | 1.00 | 3.34 | 37.83 |
| 14-quadratic/10x | 1000 | 5.63 ± 0.6% | not timed | not timed | 1.05 ± 0.2% | 0.09 ± 1.9% | not timed | not timed | 5.61 ± 8.7% | | 1.00 | 5.35 | 60.59 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.18 ± 0.5% | not timed | not timed | 0.38 ± 13.6% | 0.48 ± 3.1% | not timed | not timed | 1.15 ± 3.0% | | 1.03 | 3.07 | 2.49 |
| 04-ruff-noqa/compile-real | 1 | 84.92 ± 4.9% | not timed | not timed | 12.80 ± 6.6% | 125.06 ± 4.1% | not timed | not timed | 84.40 ± 1.1% | | 1.01 | 6.63 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 12.63 ± 0.6% | not timed | not timed | 2.38 ± 4.1% | 5.83 ± 2.4% | not timed | not timed | 12.54 ± 1.1% | | 1.01 | 5.31 | 2.17 |
| 07-unicode-character-data/compile | 1 | 51.82 ± 1.8% | not timed | not timed | 24.65 ± 0.4% | 33.14 ± 2.1% | not timed | not timed | 51.06 ± 0.6% | | 1.01 | 2.10 | 1.56 |
| 09-aws-keys/compile-full | 1 | 35.38 ± 1.0% | not timed | not timed | 7.44 ± 4.5% | 20.08 ± 3.8% | not timed | not timed | 34.61 ± 1.8% | | 1.02 | 4.75 | 1.76 |
| 09-aws-keys/compile-quick | 1 | 154.83 ± 1.8% | not timed | not timed | 45.93 ± 1.1% | 114.30 ± 7.1% | not timed | not timed | 154.21 ± 2.2% | | 1.00 | 3.37 | 1.35 |
| 10-bounded-repeat/compile-context | 1 | 10.46 ± 1.1% | not timed | not timed | 11.63 ± 4.3% | 14.94 ± 4.2% | not timed | not timed | 10.41 ± 1.1% | | 1.01 | 0.90 | 0.70 |
| 10-bounded-repeat/compile-capitals | 1 | 71.96 ± 0.5% | not timed | not timed | 8.85 ± 0.5% | 22.08 ± 1.8% | not timed | not timed | 70.12 ± 2.1% | | 1.03 | 8.13 | 3.26 |
| 11-unstructured-to-json/compile | 1 | 77.19 ± 3.6% | not timed | not timed | 37.01 ± 1.5% | 58.95 ± 3.1% | not timed | not timed | 76.45 ± 1.5% | | 1.01 | 2.09 | 1.31 |
| 12-dictionary/compile-single | 1 | 0.28 ± 0.6% | not timed | not timed | 0.06 ± 16.1% | 0.08 ± 10.0% | not timed | not timed | 0.28 ± 2.6% | | 1.01 | 4.36 | 3.56 |

