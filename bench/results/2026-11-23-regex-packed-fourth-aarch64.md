# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102062604 |
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
| literal: a word | 217 | 15896.27 ± 1.9% | 1041.79 ± 0.3% | 28.14 ± 0.5% | 18163.90 ± 2.1% | 9017.26 ± 9.0% | 17.33 ± 0.4% | 86.67 ± 0.2% | 15923.45 ± 1.4% | 15.26 | 1.00 | 0.88 | 1.76 |
| literal: a word that is not there | 0 | 18594.38 ± 1.8% | 1049.63 ± 0.8% | 28.19 ± 0.2% | 19666.99 ± 1.7% | 28317.01 ± 7.3% | 17.15 ± 0.2% | 82.66 ± 0.2% | 18673.03 ± 1.5% | 17.72 | 1.00 | 0.95 | 0.66 |
| literal: one of four words | 661 | 6151.13 ± 0.7% | 1020.43 ± 0.2% | 14.34 ± 0.1% | 3947.99 ± 0.2% | 21.90 ± 0.2% | 5.42 ± 0.1% | 6.93 ± 0.4% | 6115.11 ± 0.2% | 6.03 | 1.01 | 1.56 | 280.85 |
| literal: a word in any case | 217 | 12432.60 ± 0.9% | 1041.69 ± 0.2% | 21.38 ± 2.4% | 3969.54 ± 0.3% | 38.01 ± 0.4% | refused | differs | 12384.74 ± 0.8% | 11.94 | 1.00 | 3.13 | 327.09 |
| literal: an href attribute | 33 | 13724.67 ± 1.5% | 1045.83 ± 0.3% | 26.93 ± 0.2% | 16866.07 ± 1.1% | 2261.16 ± 0.5% | 13.09 ± 0.2% | 75.71 ± 0.4% | 13754.46 ± 1.0% | 13.12 | 1.00 | 0.81 | 6.07 |
| literal: a word, second text | 123 | 16222.28 ± 1.4% | 1048.60 ± 0.1% | 27.74 ± 0.2% | 18074.59 ± 2.4% | 7764.80 ± 4.6% | 20.02 ± 0.3% | 70.77 ± 0.5% | 16194.93 ± 1.6% | 15.47 | 1.00 | 0.90 | 2.09 |
| class: two capitalized words | 1331 | 1103.93 ± 0.6% | 959.25 ± 0.1% | 25.75 ± 0.4% | 584.99 ± 0.2% | 40.73 ± 1.5% | 14.63 ± 0.2% | 68.97 ± 1.0% | 1104.52 ± 0.4% | 1.15 | 1.00 | 1.89 | 27.10 |
| class: a word that ends in ing | 3399 | 880.25 ± 0.1% | 881.84 ± 0.1% | 17.81 ± 0.1% | 547.05 ± 0.1% | 29.62 ± 6.4% | 8.19 ± 0.2% | 18.45 ± 1.1% | 868.47 ± 0.1% | 1.00 | 1.01 | 1.61 | 29.72 |
| class: a word in capitals | 2332 | 1471.43 ± 0.6% | 945.34 ± 0.1% | 27.45 ± 0.2% | 572.25 ± 0.0% | 43.44 ± 6.6% | 17.08 ± 0.2% | 83.53 ± 0.4% | 1471.68 ± 0.3% | 1.56 | 1.00 | 2.57 | 33.87 |
| class: a number | 8288 | 2060.50 ± 0.4% | 792.49 ± 0.1% | 27.50 ± 0.2% | 1718.37 ± 0.3% | 41.65 ± 16.4% | 0.54 ± 0.4% | 56.99 ± 0.3% | 2061.14 ± 0.2% | 2.60 | 1.00 | 1.20 | 49.47 |
| class: two capitalized words, second text | 5359 | 689.39 ± 0.3% | 687.34 ± 0.1% | 23.08 ± 0.1% | 484.40 ± 0.1% | 34.16 ± 10.5% | 17.04 ± 0.2% | 64.09 ± 0.3% | 689.19 ± 0.1% | 1.00 | 1.00 | 1.42 | 20.18 |
| other: a word between two words | 6104 | 779.29 ± 0.2% | 743.29 ± 0.3% | 23.26 ± 0.1% | 735.06 ± 0.4% | 108.93 ± 11.5% | 11.15 ± 0.2% | 69.93 ± 0.2% | 779.38 ± 0.1% | 1.05 | 1.00 | 1.06 | 7.15 |
| other: a number before a unit, second text | 1481 | 5446.15 ± 0.7% | 978.29 ± 0.2% | 25.64 ± 0.2% | 5620.93 ± 0.8% | 40.81 ± 9.0% | 18.18 ± 0.4% | 66.98 ± 0.3% | 5449.84 ± 0.8% | 5.57 | 1.00 | 0.97 | 133.47 |
| other: a heading's start tag | 110 | 12643.37 ± 0.4% | 1029.50 ± 0.2% | 26.98 ± 0.2% | 1708.46 ± 0.6% | 1584.97 ± 6.0% | 16.02 ± 0.5% | 88.92 ± 0.6% | 12660.15 ± 0.9% | 12.28 | 1.00 | 7.40 | 7.98 |
| other: a whole word | 217 | 13762.23 ± 0.4% | 1041.47 ± 0.3% | 28.77 ± 0.5% | 14285.11 ± 1.9% | 49.43 ± 0.1% | 13.20 ± 0.1% | 56.28 ± 0.6% | 13795.39 ± 0.9% | 13.21 | 1.00 | 0.96 | 278.43 |
| other: a line's first word, second text | 3716 | 1947.82 ± 0.5% | 855.20 ± 0.2% | 30.40 ± 0.1% | 1721.48 ± 0.4% | 62.31 ± 5.4% | refused | refused | 1942.40 ± 0.7% | 2.28 | 1.00 | 1.13 | 31.26 |
| other: fourteen octets before an x | 87 | 19278.45 ± 2.9% | 228.31 ± 0.5% | 5.30 ± 0.1% | 3990.77 ± 0.9% | 10.66 ± 0.2% | differs | 17.82 ± 0.1% | 19341.76 ± 1.1% | 84.44 | 1.00 | 4.83 | 1807.95 |
| other: a Greek word | 21815 | 471.45 ± 0.9% | 316.41 ± 0.5% | 30.39 ± 0.2% | 289.41 ± 1.0% | 47.12 ± 13.9% | differs | refused | 470.26 ± 0.5% | 1.49 | 1.00 | 1.63 | 10.01 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.05 ± 0.2% | 26.03 ± 0.1% | 0.81 ± 0.3% | 19.87 ± 0.3% | 2.78 ± 0.3% | differs | 3.98 ± 0.2% | 26.04 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.36 |
| a UUID | 32895 | 21.25 ± 0.2% | 21.35 ± 0.3% | 0.64 ± 0.2% | 15.14 ± 0.9% | 3.11 ± 0.5% | 0.73 ± 0.3% | 3.59 ± 0.6% | 21.36 ± 0.2% | 1.00 | 0.99 | 1.40 | 6.84 |
| an IPv4 address | 33176 | 36.95 ± 0.2% | 36.88 ± 0.2% | 2.08 ± 0.4% | 29.26 ± 0.1% | 6.65 ± 0.3% | differs | 4.13 ± 0.2% | 36.98 ± 0.1% | 1.00 | 1.00 | 1.26 | 5.56 |
| a date and time | 32954 | 31.21 ± 0.3% | 31.24 ± 0.2% | 1.45 ± 0.2% | 21.54 ± 0.5% | 7.06 ± 0.1% | 1.25 ± 0.4% | 7.14 ± 0.7% | 31.22 ± 0.3% | 1.00 | 1.00 | 1.45 | 4.42 |
| a field path | 32606 | 29.57 ± 0.1% | 29.52 ± 0.3% | 0.97 ± 0.1% | 23.30 ± 0.2% | 3.50 ± 0.3% | differs | 2.97 ± 0.2% | 29.54 ± 0.2% | 1.00 | 1.00 | 1.27 | 8.46 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.01 ± 0.4% | 9.02 ± 0.3% | 9.00 ± 0.5% | 11.71 ± 0.1% | 4.95 ± 2.3% | 0.93 ± 0.3% | none | 9.04 ± 0.2% | 1.00 | 1.00 | 0.77 | 1.82 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.85 ± 0.2% | 237.03 ± 0.2% | 286.75 ± 0.2% | 86.58 ± 0.8% | 220.13 ± 1.6% | 482.87 ± 0.5% | 3856.34 ± 2.8% | 234.68 ± 0.2% | 0.99 | 1.00 | 2.71 | 1.07 |
| a UUID | 62 | 156.91 ± 0.3% | 157.15 ± 0.7% | 177.54 ± 0.2% | 45.61 ± 0.9% | 97.06 ± 0.5% | 182.96 ± 2.5% | 4242.55 ± 0.8% | 156.87 ± 0.1% | 1.00 | 1.00 | 3.44 | 1.62 |
| an IPv4 address | 29 | 422.99 ± 0.5% | 426.85 ± 0.3% | 614.33 ± 0.2% | 77.69 ± 0.2% | 129.43 ± 1.3% | 295.53 ± 0.6% | 7593.86 ± 0.1% | 422.40 ± 0.3% | 0.99 | 1.00 | 5.44 | 3.27 |
| a date and time | 56 | 302.37 ± 0.4% | 305.26 ± 0.5% | 389.89 ± 0.3% | 73.01 ± 1.2% | 135.15 ± 1.4% | 330.71 ± 1.1% | 4861.82 ± 1.1% | 302.62 ± 0.3% | 0.99 | 1.00 | 4.14 | 2.24 |
| a field path | 39 | 227.03 ± 0.3% | 228.67 ± 0.4% | 273.89 ± 0.3% | 80.30 ± 0.9% | 203.84 ± 1.8% | 528.91 ± 5.3% | 4948.97 ± 3.5% | 227.06 ± 0.3% | 0.99 | 1.00 | 2.83 | 1.11 |
| literal: a word | 7 | 631.61 ± 0.6% | 676.90 ± 0.4% | 1275.72 ± 0.3% | 495.97 ± 0.3% | 626.52 ± 1.4% | 955.33 ± 0.3% | 30459.46 ± 0.1% | 631.13 ± 0.4% | 0.93 | 1.00 | 1.27 | 1.01 |
| literal: a word that is not there | 8 | 603.87 ± 0.7% | 656.62 ± 0.7% | 1200.72 ± 0.7% | 448.11 ± 0.2% | 604.07 ± 1.6% | 903.86 ± 0.6% | 29133.95 ± 0.1% | 604.49 ± 0.4% | 0.92 | 1.00 | 1.35 | 1.00 |
| literal: one of four words | 26 | 241.63 ± 0.1% | 400.58 ± 0.3% | 559.31 ± 0.1% | 50.21 ± 1.0% | 241.18 ± 1.3% | 378.04 ± 0.9% | 15615.74 ± 0.1% | 241.43 ± 0.5% | 0.60 | 1.00 | 4.81 | 1.00 |
| literal: a word in any case | 11 | 484.99 ± 0.3% | 517.65 ± 0.3% | 829.78 ± 0.5% | 15.48 ± 0.2% | 645.29 ± 1.2% | refused | 23714.27 ± 0.3% | 485.40 ± 0.2% | 0.94 | 1.00 | 31.33 | 0.75 |
| literal: an href attribute | 12 | 349.78 ± 0.4% | 360.52 ± 0.2% | 489.43 ± 0.3% | 45.53 ± 0.6% | 494.27 ± 1.9% | 778.55 ± 0.5% | 21629.02 ± 0.2% | 349.61 ± 0.5% | 0.97 | 1.00 | 7.68 | 0.71 |
| literal: a word, second text | 10 | 564.49 ± 0.8% | 621.85 ± 1.0% | 1078.83 ± 1.8% | 397.83 ± 0.4% | 534.41 ± 2.9% | 807.05 ± 0.8% | 27094.44 ± 0.2% | 564.25 ± 0.5% | 0.91 | 1.00 | 1.42 | 1.06 |
| class: two capitalized words | 23 | 437.93 ± 0.4% | 466.90 ± 0.4% | 699.38 ± 0.8% | 98.70 ± 0.2% | 498.41 ± 2.5% | 750.77 ± 0.7% | 6582.70 ± 0.2% | 438.04 ± 0.5% | 0.94 | 1.00 | 4.44 | 0.88 |
| class: a word that ends in ing | 9 | 566.35 ± 0.6% | 635.20 ± 0.3% | 1161.59 ± 0.3% | 130.63 ± 1.4% | 762.69 ± 0.5% | 1106.60 ± 0.4% | 16128.09 ± 0.1% | 566.29 ± 0.4% | 0.89 | 1.00 | 4.34 | 0.74 |
| class: a word in capitals | 16 | 503.97 ± 0.8% | 541.59 ± 1.1% | 902.88 ± 1.1% | 134.73 ± 1.2% | 755.57 ± 1.7% | 1031.84 ± 0.4% | 8692.47 ± 0.2% | 504.26 ± 0.7% | 0.93 | 1.00 | 3.74 | 0.67 |
| class: a number | 6 | 636.46 ± 0.4% | 700.99 ± 0.3% | 1390.31 ± 0.1% | 41.85 ± 1.0% | 1411.30 ± 1.8% | 1855.89 ± 1.0% | 22876.89 ± 0.1% | 636.38 ± 0.8% | 0.91 | 1.00 | 15.21 | 0.45 |
| class: two capitalized words, second text | 23 | 437.55 ± 0.3% | 465.81 ± 0.7% | 696.90 ± 0.5% | 100.05 ± 0.2% | 494.74 ± 2.1% | 742.01 ± 2.9% | 6576.51 ± 0.4% | 438.63 ± 0.1% | 0.94 | 1.00 | 4.37 | 0.88 |
| other: a word between two words | 13 | 551.91 ± 0.7% | 569.65 ± 0.4% | 941.28 ± 0.4% | 132.83 ± 0.5% | 500.21 ± 2.7% | 809.46 ± 0.9% | 14871.91 ± 0.5% | 552.91 ± 0.5% | 0.97 | 1.00 | 4.15 | 1.10 |
| other: a number before a unit, second text | 15 | 408.49 ± 0.7% | 447.08 ± 0.6% | 649.07 ± 1.0% | 39.48 ± 0.3% | 631.93 ± 1.1% | 890.84 ± 0.3% | 15208.81 ± 0.5% | 409.05 ± 0.4% | 0.91 | 1.00 | 10.35 | 0.65 |
| other: a heading's start tag | 13 | 359.16 ± 0.3% | 364.56 ± 0.5% | 494.75 ± 0.7% | 44.18 ± 0.4% | 626.02 ± 0.8% | 879.14 ± 0.4% | 18094.53 ± 0.6% | 358.62 ± 0.1% | 0.99 | 1.00 | 8.13 | 0.57 |
| other: a whole word | 11 | 586.14 ± 0.6% | 622.21 ± 0.7% | 1084.28 ± 1.0% | 118.36 ± 0.5% | 559.14 ± 2.5% | 834.95 ± 0.5% | 26942.53 ± 0.9% | 585.80 ± 0.5% | 0.94 | 1.00 | 4.95 | 1.05 |
| other: a line's first word, second text | 17 | 537.96 ± 0.1% | 557.85 ± 0.2% | 936.45 ± 0.1% | 128.14 ± 0.1% | 703.19 ± 0.8% | refused | refused | 535.81 ± 0.4% | 0.96 | 1.00 | 4.20 | 0.77 |
| other: fourteen octets before an x | 16 | 112.14 ± 0.3% | 162.12 ± 0.6% | 190.17 ± 0.6% | 15.18 ± 0.5% | 452.46 ± 2.5% | 414.60 ± 0.4% | 12574.79 ± 0.8% | 112.07 ± 0.6% | 0.69 | 1.00 | 7.39 | 0.25 |
| other: a Greek word | 8 | 433.03 ± 0.2% | 599.30 ± 0.5% | 1061.90 ± 0.1% | 59.08 ± 0.4% | 1389.00 ± 2.5% | 1823.07 ± 0.4% | refused | 432.86 ± 0.2% | 0.72 | 1.00 | 7.33 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12712.20 ± 0.9% | not timed | not timed | 15864.63 ± 1.9% | 2117.33 ± 14.9% | not timed | not timed | 12705.83 ± 0.9% | | 1.00 | 0.80 | 6.00 |
| 01-literal/sherlock-casei-en | 522 | 3938.84 ± 0.5% | not timed | not timed | 3592.14 ± 0.6% | 32.43 ± 0.6% | not timed | not timed | 3935.56 ± 0.6% | | 1.00 | 1.10 | 121.46 |
| 01-literal/sherlock-ru | 724 | 13563.88 ± 0.7% | not timed | not timed | 17171.69 ± 0.9% | 1539.99 ± 14.0% | not timed | not timed | 13552.28 ± 0.4% | | 1.00 | 0.79 | 8.81 |
| 01-literal/sherlock-casei-ru | 746 | 5396.56 ± 0.2% | not timed | not timed | 3333.40 ± 0.0% | 30.76 ± 0.3% | not timed | not timed | 5395.80 ± 0.2% | | 1.00 | 1.62 | 175.43 |
| 01-literal/sherlock-zh | 30 | 16763.72 ± 1.0% | not timed | not timed | 18153.15 ± 0.9% | 2519.68 ± 15.7% | not timed | not timed | 16735.55 ± 1.8% | | 1.00 | 0.92 | 6.65 |
| 02-literal-alternate/sherlock-en | 714 | 5894.01 ± 0.6% | not timed | not timed | 3930.86 ± 0.6% | 16.66 ± 0.1% | not timed | not timed | 5900.87 ± 0.1% | | 1.00 | 1.50 | 353.78 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1704.24 ± 0.7% | not timed | not timed | 699.46 ± 0.5% | 11.05 ± 0.1% | not timed | not timed | 1696.57 ± 0.3% | | 1.00 | 2.44 | 154.21 |
| 02-literal-alternate/sherlock-ru | 899 | 4797.51 ± 0.1% | not timed | not timed | 3256.01 ± 0.1% | 22.22 ± 4.9% | not timed | not timed | 4800.69 ± 0.2% | | 1.00 | 1.47 | 215.92 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1821.18 ± 0.5% | not timed | not timed | 1228.43 ± 0.2% | 9.11 ± 0.1% | not timed | not timed | 1814.62 ± 0.1% | | 1.00 | 1.48 | 199.98 |
| 02-literal-alternate/sherlock-zh | 207 | 7098.35 ± 0.4% | not timed | not timed | 4162.14 ± 0.8% | 31.50 ± 0.2% | not timed | not timed | 7094.45 ± 0.1% | | 1.00 | 1.71 | 225.34 |
| 03-date/ascii | 111817 | 123.17 ± 0.7% | not timed | not timed | 95.72 ± 0.1% | 0.20 ± 1.6% | not timed | not timed | 121.97 ± 0.1% | | 1.01 | 1.29 | 609.90 |
| 04-ruff-noqa/real | 84 | 552.51 ± 0.3% | not timed | not timed | 462.96 ± 0.1% | 19.49 ± 0.5% | not timed | not timed | 551.65 ± 0.2% | | 1.00 | 1.19 | 28.35 |
| 04-ruff-noqa/tweaked | 44 | 553.63 ± 0.5% | not timed | not timed | 462.22 ± 0.1% | 364.16 ± 0.5% | not timed | not timed | 554.50 ± 0.3% | | 1.00 | 1.20 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.53 ± 0.4% | not timed | not timed | 5.18 ± 0.2% | 0.20 ± 5.1% | not timed | not timed | 3.66 ± 2.7% | | 0.96 | 0.68 | 17.28 |
| 06-cloud-flare-redos/original | 107 | 183.24 ± 0.1% | not timed | not timed | 215.79 ± 0.1% | 24.87 ± 4.4% | not timed | not timed | 182.70 ± 3.6% | | 1.00 | 0.85 | 7.37 |
| 06-cloud-flare-redos/simplified-short | 102 | 142.67 ± 1.5% | not timed | not timed | 227.58 ± 0.2% | 26.11 ± 5.3% | not timed | not timed | 146.25 ± 4.2% | | 0.98 | 0.63 | 5.46 |
| 06-cloud-flare-redos/simplified-long | 10000 | 156.62 ± 0.9% | not timed | not timed | 254.91 ± 0.2% | 28.80 ± 0.2% | not timed | not timed | 156.54 ± 2.2% | | 1.00 | 0.61 | 5.44 |
| 07-unicode-character-data/parse-line | 558784 | 40.02 ± 0.1% | not timed | not timed | 179.62 ± 0.1% | 42.81 ± 1.1% | not timed | not timed | 40.01 ± 0.1% | | 1.00 | 0.22 | 0.93 |
| 08-words/all-english | 56691 | 102.91 ± 0.2% | not timed | not timed | 83.24 ± 0.2% | 12.70 ± 13.7% | not timed | not timed | 102.04 ± 0.4% | | 1.01 | 1.24 | 8.10 |
| 08-words/long-english | 839 | 997.55 ± 0.2% | not timed | not timed | 595.63 ± 0.1% | 32.55 ± 0.2% | not timed | not timed | 996.81 ± 0.1% | | 1.00 | 1.67 | 30.65 |
| 09-aws-keys/full | 0 | 422.20 ± 0.0% | not timed | not timed | 479.33 ± 0.1% | 64.65 ± 3.4% | not timed | not timed | 422.11 ± 0.2% | | 1.00 | 0.88 | 6.53 |
| 09-aws-keys/quick | 0 | 410.13 ± 0.1% | not timed | not timed | 996.25 ± 0.2% | 419.93 ± 1.4% | not timed | not timed | 410.58 ± 0.1% | | 1.00 | 0.41 | 0.98 |
| 10-bounded-repeat/letters-en | 1833 | 590.74 ± 0.4% | not timed | not timed | 518.06 ± 0.2% | 19.52 ± 0.6% | not timed | not timed | 589.62 ± 0.4% | | 1.00 | 1.14 | 30.26 |
| 10-bounded-repeat/letters-ru | 3475 | 402.89 ± 0.6% | not timed | not timed | 478.66 ± 0.2% | 21.87 ± 8.5% | not timed | not timed | 401.88 ± 0.5% | | 1.00 | 0.84 | 18.43 |
| 10-bounded-repeat/context | 53 | 72.97 ± 1.0% | not timed | not timed | 65.52 ± 0.4% | 19.85 ± 0.1% | not timed | not timed | 73.00 ± 0.9% | | 1.00 | 1.11 | 3.68 |
| 10-bounded-repeat/capitals | 11 | 1038.92 ± 0.1% | not timed | not timed | 618.51 ± 0.0% | 36.57 ± 0.1% | not timed | not timed | 1038.35 ± 0.1% | | 1.00 | 1.68 | 28.41 |
| 11-unstructured-to-json/extract | 600 | 24.59 ± 0.1% | not timed | not timed | 76.63 ± 0.7% | 48.83 ± 0.5% | not timed | not timed | 24.49 ± 0.9% | | 1.00 | 0.32 | 0.50 |
| 12-dictionary/single | 1 | 602.60 ± 0.2% | not timed | not timed | 554.26 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 602.59 ± 0.2% | | 1.00 | 1.09 | 1481.75 |
| 14-quadratic/1x | 100 | 12.59 ± 0.5% | not timed | not timed | 10.06 ± 0.3% | 0.95 ± 3.0% | not timed | not timed | 12.51 ± 0.7% | | 1.01 | 1.25 | 13.19 |
| 14-quadratic/2x | 200 | 7.77 ± 0.4% | not timed | not timed | 5.55 ± 0.2% | 0.53 ± 0.7% | not timed | not timed | 7.73 ± 1.4% | | 1.01 | 1.40 | 14.58 |
| 14-quadratic/10x | 1000 | 1.83 ± 0.4% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 1.82 ± 0.6% | | 1.00 | 1.51 | 15.88 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.2% | not timed | not timed | 0.34 ± 0.5% | 0.54 ± 4.1% | not timed | not timed | 1.43 ± 1.3% | | 1.01 | 4.24 | 2.69 |
| 04-ruff-noqa/compile-real | 1 | 92.79 ± 0.2% | not timed | not timed | 13.90 ± 0.5% | 133.79 ± 3.7% | not timed | not timed | 92.90 ± 0.9% | | 1.00 | 6.67 | 0.69 |
| 05-lexer-veryl/compile-single | 1 | 14.68 ± 1.8% | not timed | not timed | 2.50 ± 0.6% | 6.36 ± 3.5% | not timed | not timed | 14.66 ± 1.7% | | 1.00 | 5.88 | 2.31 |
| 07-unicode-character-data/compile | 1 | 58.39 ± 0.2% | not timed | not timed | 26.07 ± 0.1% | 34.81 ± 3.8% | not timed | not timed | 58.47 ± 1.4% | | 1.00 | 2.24 | 1.68 |
| 09-aws-keys/compile-full | 1 | 43.73 ± 0.2% | not timed | not timed | 8.29 ± 0.2% | 22.65 ± 1.4% | not timed | not timed | 43.51 ± 1.0% | | 1.01 | 5.28 | 1.93 |
| 09-aws-keys/compile-quick | 1 | 188.56 ± 0.2% | not timed | not timed | 48.53 ± 0.1% | 127.93 ± 2.4% | not timed | not timed | 189.97 ± 1.2% | | 0.99 | 3.89 | 1.47 |
| 10-bounded-repeat/compile-context | 1 | 14.74 ± 2.3% | not timed | not timed | 11.09 ± 0.2% | 15.39 ± 3.2% | not timed | not timed | 14.63 ± 0.8% | | 1.01 | 1.33 | 0.96 |
| 10-bounded-repeat/compile-capitals | 1 | 85.88 ± 0.5% | not timed | not timed | 8.04 ± 0.1% | 23.15 ± 1.5% | not timed | not timed | 85.86 ± 1.2% | | 1.00 | 10.68 | 3.71 |
| 11-unstructured-to-json/compile | 1 | 91.30 ± 0.3% | not timed | not timed | 40.44 ± 0.6% | 66.44 ± 3.2% | not timed | not timed | 90.92 ± 1.1% | | 1.00 | 2.26 | 1.37 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.4% | not timed | not timed | 0.07 ± 1.7% | 0.09 ± 18.1% | not timed | not timed | 0.36 ± 0.2% | | 1.01 | 5.33 | 4.00 |

