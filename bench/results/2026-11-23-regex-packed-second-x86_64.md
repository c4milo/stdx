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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102057264 |
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
| literal: a word | 217 | 31366.38 ± 1.2% | 894.91 ± 0.3% | 20.25 ± 0.5% | 31308.82 ± 1.1% | 9052.87 ± 7.9% | 10.74 ± 0.8% | 76.78 ± 3.2% | 31130.91 ± 1.6% | 35.05 | 1.01 | 1.00 | 3.46 |
| literal: a word that is not there | 0 | 43506.97 ± 0.7% | 905.60 ± 0.2% | 20.26 ± 0.4% | 39665.32 ± 3.1% | 30039.05 ± 0.4% | 10.69 ± 0.4% | 72.52 ± 0.9% | 42454.15 ± 7.7% | 48.04 | 1.02 | 1.10 | 1.45 |
| literal: one of four words | 661 | 11408.71 ± 0.9% | 869.08 ± 0.1% | 11.10 ± 0.4% | 9122.36 ± 0.9% | 19.31 ± 1.2% | 3.99 ± 0.2% | 6.65 ± 0.3% | 11370.60 ± 0.4% | 13.13 | 1.00 | 1.25 | 590.75 |
| literal: a word in any case | 217 | 25225.57 ± 2.2% | 892.69 ± 1.1% | 15.42 ± 4.0% | 9072.68 ± 2.3% | 36.52 ± 2.5% | refused | differs | 24909.36 ± 2.6% | 28.26 | 1.01 | 2.78 | 690.77 |
| literal: an href attribute | 33 | 26214.11 ± 1.5% | 901.29 ± 0.2% | 19.13 ± 0.5% | 27329.65 ± 0.4% | 2047.01 ± 1.2% | 8.21 ± 0.3% | 61.66 ± 1.5% | 25989.76 ± 1.1% | 29.09 | 1.01 | 0.96 | 12.81 |
| literal: a word, second text | 123 | 31996.32 ± 0.8% | 897.95 ± 0.1% | 19.92 ± 1.7% | 32082.94 ± 24.1% | 7211.33 ± 2.5% | 11.75 ± 0.7% | 65.23 ± 0.8% | 32314.50 ± 1.4% | 35.63 | 0.99 | 1.00 | 4.44 |
| class: two capitalized words | 1331 | 765.58 ± 0.3% | 814.45 ± 0.1% | 18.92 ± 0.4% | 505.63 ± 0.1% | 34.31 ± 3.2% | 9.26 ± 0.7% | 55.72 ± 0.2% | 765.47 ± 0.2% | 0.94 | 1.00 | 1.51 | 22.31 |
| class: a word that ends in ing | 3399 | 734.62 ± 0.2% | 734.18 ± 0.1% | 13.68 ± 0.4% | 469.91 ± 0.4% | 25.67 ± 4.4% | 5.31 ± 0.2% | 17.24 ± 0.6% | 734.33 ± 0.2% | 1.00 | 1.00 | 1.56 | 28.62 |
| class: a word in capitals | 2332 | 982.62 ± 0.2% | 795.71 ± 0.2% | 19.99 ± 0.6% | 498.31 ± 0.8% | 36.60 ± 6.2% | 10.28 ± 0.2% | 76.56 ± 0.3% | 983.24 ± 0.3% | 1.23 | 1.00 | 1.97 | 26.85 |
| class: a number | 8288 | 1464.20 ± 0.4% | 648.18 ± 0.1% | 19.75 ± 6.8% | 1472.48 ± 4.7% | 37.47 ± 13.7% | 0.33 ± 0.3% | 55.80 ± 0.4% | 1463.79 ± 0.9% | 2.26 | 1.00 | 0.99 | 39.08 |
| class: two capitalized words, second text | 5359 | 578.95 ± 0.3% | 576.60 ± 0.2% | 17.59 ± 0.6% | 417.31 ± 0.2% | 29.15 ± 12.9% | 10.45 ± 0.2% | 51.62 ± 0.4% | 578.04 ± 1.2% | 1.00 | 1.00 | 1.39 | 19.86 |
| other: a word between two words | 6104 | 650.02 ± 0.6% | 616.59 ± 0.3% | 17.42 ± 0.3% | 698.11 ± 0.7% | 100.65 ± 13.3% | 7.23 ± 0.2% | 56.66 ± 0.7% | 652.56 ± 0.8% | 1.05 | 1.00 | 0.93 | 6.46 |
| other: a number before a unit, second text | 1481 | 6712.95 ± 3.5% | 826.00 ± 0.9% | 18.92 ± 0.6% | 6408.89 ± 0.1% | 35.16 ± 0.3% | 10.86 ± 0.1% | 54.99 ± 1.2% | 6725.79 ± 3.6% | 8.13 | 1.00 | 1.05 | 190.91 |
| other: a heading's start tag | 110 | 18773.54 ± 1.2% | 893.77 ± 0.7% | 19.75 ± 0.5% | 2005.83 ± 0.2% | 1470.53 ± 15.2% | 9.92 ± 0.3% | 72.72 ± 0.3% | 18688.16 ± 1.2% | 21.00 | 1.00 | 9.36 | 12.77 |
| other: a whole word | 217 | 21906.25 ± 2.5% | 891.15 ± 1.3% | 20.94 ± 1.8% | 22213.13 ± 2.1% | 40.31 ± 9.5% | 9.44 ± 1.9% | 47.26 ± 1.4% | 21166.60 ± 3.6% | 24.58 | 1.03 | 0.99 | 543.41 |
| other: a line's first word, second text | 3716 | 1690.52 ± 4.6% | 716.22 ± 0.1% | 24.30 ± 0.3% | 1713.55 ± 2.5% | 53.37 ± 4.6% | refused | refused | 1751.80 ± 0.9% | 2.36 | 0.97 | 0.99 | 31.68 |
| other: fourteen octets before an x | 87 | 25470.38 ± 6.3% | 193.96 ± 0.2% | 4.43 ± 2.1% | 2968.00 ± 0.8% | 9.00 ± 5.8% | differs | 15.46 ± 1.5% | 25586.18 ± 0.9% | 131.32 | 1.00 | 8.58 | 2831.61 |
| other: a Greek word | 21815 | 383.58 ± 2.5% | 265.02 ± 1.4% | 24.29 ± 12.7% | 264.49 ± 0.8% | 44.33 ± 5.9% | differs | refused | 385.52 ± 0.5% | 1.45 | 0.99 | 1.45 | 8.65 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.38 ± 0.8% | 25.29 ± 7.3% | 0.74 ± 7.5% | 16.83 ± 1.3% | 1.71 ± 0.4% | differs | 3.61 ± 0.8% | 25.42 ± 0.2% | 1.00 | 1.00 | 1.51 | 14.81 |
| a UUID | 32895 | 20.77 ± 0.2% | 20.79 ± 0.2% | 0.57 ± 2.1% | 12.82 ± 0.5% | 2.50 ± 1.2% | 0.44 ± 0.8% | 3.08 ± 0.5% | 20.79 ± 0.4% | 1.00 | 1.00 | 1.62 | 8.31 |
| an IPv4 address | 33176 | 35.72 ± 2.1% | 35.69 ± 0.2% | 1.81 ± 0.4% | 23.93 ± 4.3% | 5.72 ± 0.2% | differs | 3.41 ± 2.0% | 35.74 ± 0.2% | 1.00 | 1.00 | 1.49 | 6.24 |
| a date and time | 32954 | 31.04 ± 1.8% | 31.02 ± 0.2% | 1.27 ± 0.2% | 17.88 ± 0.2% | 6.65 ± 0.3% | 0.75 ± 1.5% | 6.17 ± 10.6% | 30.98 ± 0.3% | 1.00 | 1.00 | 1.74 | 4.67 |
| a field path | 32606 | 28.34 ± 0.5% | 28.39 ± 0.4% | 0.85 ± 1.0% | 19.35 ± 0.1% | 2.93 ± 0.5% | differs | 2.47 ± 4.9% | 28.35 ± 4.3% | 1.00 | 1.00 | 1.46 | 9.67 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 7.66 ± 1.0% | 7.64 ± 18.7% | 7.65 ± 0.7% | 10.63 ± 0.3% | 4.73 ± 6.6% | 0.62 ± 1.8% | none | 7.67 ± 1.9% | 1.00 | 1.00 | 0.72 | 1.62 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 188.04 ± 1.1% | 189.01 ± 0.1% | 217.83 ± 0.5% | 79.91 ± 3.7% | 183.65 ± 1.2% | 514.45 ± 4.2% | 3951.03 ± 1.6% | 188.03 ± 0.3% | 0.99 | 1.00 | 2.35 | 1.02 |
| a UUID | 62 | 122.02 ± 0.7% | 122.63 ± 0.4% | 135.37 ± 1.4% | 46.89 ± 0.9% | 89.57 ± 3.4% | 195.93 ± 1.1% | 4143.74 ± 1.8% | 122.02 ± 0.2% | 1.00 | 1.00 | 2.60 | 1.36 |
| an IPv4 address | 29 | 394.15 ± 1.1% | 396.03 ± 9.2% | 556.51 ± 0.4% | 69.41 ± 1.7% | 113.30 ± 16.4% | 331.31 ± 4.9% | 7198.13 ± 0.5% | 395.44 ± 1.4% | 1.00 | 1.00 | 5.68 | 3.48 |
| a date and time | 56 | 284.19 ± 11.9% | 286.76 ± 0.3% | 360.71 ± 0.1% | 68.84 ± 1.9% | 123.35 ± 2.2% | 369.92 ± 2.5% | 4244.84 ± 14.9% | 284.47 ± 0.3% | 0.99 | 1.00 | 4.13 | 2.30 |
| a field path | 39 | 182.64 ± 0.3% | 183.53 ± 12.9% | 211.30 ± 0.3% | 74.54 ± 1.4% | 171.89 ± 1.7% | 592.71 ± 3.9% | 4783.68 ± 1.2% | 182.49 ± 0.6% | 1.00 | 1.00 | 2.45 | 1.06 |
| literal: a word | 7 | 592.34 ± 14.0% | 629.56 ± 21.0% | 1128.18 ± 3.4% | 495.64 ± 1.8% | 576.00 ± 3.4% | 1245.87 ± 0.6% | 25037.91 ± 0.9% | 589.58 ± 1.6% | 0.94 | 1.00 | 1.20 | 1.03 |
| literal: a word that is not there | 8 | 566.94 ± 0.3% | 606.05 ± 1.6% | 1061.86 ± 0.5% | 456.95 ± 0.8% | 551.67 ± 4.9% | 1175.26 ± 0.7% | 23856.30 ± 1.5% | 568.00 ± 0.3% | 0.94 | 1.00 | 1.24 | 1.03 |
| literal: one of four words | 26 | 220.74 ± 1.2% | 364.32 ± 0.8% | 491.99 ± 0.6% | 41.67 ± 1.1% | 220.88 ± 1.2% | 449.75 ± 3.2% | 11003.50 ± 10.8% | 220.38 ± 0.5% | 0.61 | 1.00 | 5.30 | 1.00 |
| literal: a word in any case | 11 | 453.49 ± 1.0% | 482.79 ± 0.7% | 730.63 ± 0.7% | 14.52 ± 0.2% | 607.92 ± 1.8% | refused | 19393.51 ± 3.7% | 449.93 ± 5.9% | 0.94 | 1.01 | 31.24 | 0.75 |
| literal: an href attribute | 12 | 314.18 ± 5.0% | 327.36 ± 2.7% | 437.09 ± 2.3% | 37.29 ± 3.5% | 427.74 ± 4.1% | 949.19 ± 3.2% | 18362.47 ± 1.9% | 314.73 ± 15.8% | 0.96 | 1.00 | 8.43 | 0.73 |
| literal: a word, second text | 10 | 525.78 ± 8.5% | 575.00 ± 0.6% | 958.12 ± 0.8% | 417.85 ± 0.6% | 482.46 ± 3.4% | 991.34 ± 7.0% | 20749.59 ± 0.7% | 526.84 ± 3.8% | 0.91 | 1.00 | 1.26 | 1.09 |
| class: two capitalized words | 23 | 424.50 ± 0.6% | 452.82 ± 0.3% | 663.02 ± 7.1% | 94.29 ± 0.4% | 442.55 ± 1.8% | 924.26 ± 2.8% | 6379.96 ± 1.0% | 422.96 ± 1.1% | 0.94 | 1.00 | 4.50 | 0.96 |
| class: a word that ends in ing | 9 | 510.83 ± 0.6% | 572.66 ± 0.4% | 1017.42 ± 0.2% | 115.29 ± 2.1% | 625.15 ± 1.4% | 1442.94 ± 1.0% | 15281.60 ± 0.2% | 511.22 ± 0.4% | 0.89 | 1.00 | 4.43 | 0.82 |
| class: a word in capitals | 16 | 448.85 ± 0.4% | 481.36 ± 0.9% | 791.96 ± 8.3% | 122.21 ± 1.6% | 648.35 ± 1.2% | 1304.22 ± 3.2% | 8386.01 ± 0.2% | 448.56 ± 0.3% | 0.93 | 1.00 | 3.67 | 0.69 |
| class: a number | 6 | 563.93 ± 4.0% | 619.47 ± 0.9% | 1176.58 ± 1.3% | 36.74 ± 0.4% | 1172.83 ± 1.0% | 2316.05 ± 0.6% | 20458.48 ± 12.6% | 562.45 ± 0.3% | 0.91 | 1.00 | 15.35 | 0.48 |
| class: two capitalized words, second text | 23 | 423.96 ± 0.6% | 453.28 ± 0.2% | 664.41 ± 0.3% | 94.19 ± 0.8% | 449.13 ± 3.3% | 947.24 ± 10.7% | 6387.94 ± 0.3% | 423.98 ± 0.2% | 0.94 | 1.00 | 4.50 | 0.94 |
| other: a word between two words | 13 | 504.29 ± 0.7% | 520.24 ± 0.4% | 822.90 ± 1.6% | 122.92 ± 2.1% | 437.31 ± 39.5% | 1000.18 ± 2.0% | 14050.43 ± 0.8% | 503.73 ± 3.0% | 0.97 | 1.00 | 4.10 | 1.15 |
| other: a number before a unit, second text | 15 | 359.24 ± 1.1% | 393.91 ± 0.2% | 547.46 ± 0.6% | 34.23 ± 1.3% | 533.34 ± 2.9% | 1097.41 ± 5.9% | 13916.71 ± 1.7% | 358.66 ± 1.8% | 0.91 | 1.00 | 10.50 | 0.67 |
| other: a heading's start tag | 13 | 332.61 ± 0.2% | 337.71 ± 2.3% | 448.68 ± 1.4% | 35.46 ± 1.2% | 524.47 ± 1.1% | 1062.03 ± 0.7% | 16336.91 ± 0.8% | 332.04 ± 0.4% | 0.98 | 1.00 | 9.38 | 0.63 |
| other: a whole word | 11 | 515.43 ± 0.6% | 543.86 ± 0.9% | 876.48 ± 0.3% | 110.38 ± 1.2% | 508.73 ± 1.9% | 1035.92 ± 1.0% | 20974.24 ± 2.9% | 515.88 ± 0.6% | 0.95 | 1.00 | 4.67 | 1.01 |
| other: a line's first word, second text | 17 | 487.17 ± 0.8% | 511.02 ± 10.7% | 836.45 ± 0.3% | 114.84 ± 0.8% | 585.97 ± 13.1% | refused | refused | 486.74 ± 3.1% | 0.95 | 1.00 | 4.24 | 0.83 |
| other: fourteen octets before an x | 16 | 87.43 ± 11.2% | 124.46 ± 0.4% | 142.81 ± 0.1% | 14.14 ± 1.1% | 394.34 ± 2.0% | 452.00 ± 5.6% | 11849.40 ± 0.4% | 87.61 ± 0.4% | 0.70 | 1.00 | 6.18 | 0.22 |
| other: a Greek word | 8 | 382.11 ± 0.5% | 516.30 ± 0.5% | 845.84 ± 0.3% | 45.83 ± 1.1% | 1158.06 ± 1.4% | 2185.70 ± 18.6% | refused | 381.35 ± 12.7% | 0.74 | 1.00 | 8.34 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20182.61 ± 1.9% | not timed | not timed | 26397.31 ± 0.7% | 2087.18 ± 12.2% | not timed | not timed | 20271.35 ± 0.7% | | 1.00 | 0.76 | 9.67 |
| 01-literal/sherlock-casei-en | 522 | 4581.93 ± 0.5% | not timed | not timed | 7036.46 ± 1.3% | 28.61 ± 11.5% | not timed | not timed | 4576.69 ± 0.5% | | 1.00 | 0.65 | 160.16 |
| 01-literal/sherlock-ru | 724 | 22159.83 ± 3.1% | not timed | not timed | 27930.21 ± 0.6% | 1068.60 ± 3.2% | not timed | not timed | 22165.38 ± 10.7% | | 1.00 | 0.79 | 20.74 |
| 01-literal/sherlock-casei-ru | 746 | 7351.92 ± 15.1% | not timed | not timed | 5519.53 ± 0.5% | 30.49 ± 0.9% | not timed | not timed | 7309.97 ± 3.6% | | 1.01 | 1.33 | 241.17 |
| 01-literal/sherlock-zh | 30 | 38324.45 ± 2.4% | not timed | not timed | 36778.69 ± 1.4% | 1263.94 ± 0.6% | not timed | not timed | 38346.11 ± 0.9% | | 1.00 | 1.04 | 30.32 |
| 02-literal-alternate/sherlock-en | 714 | 9927.83 ± 0.5% | not timed | not timed | 8906.02 ± 0.5% | 14.77 ± 2.3% | not timed | not timed | 9933.84 ± 1.3% | | 1.00 | 1.11 | 672.10 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1742.62 ± 0.3% | not timed | not timed | 1817.36 ± 0.3% | 9.51 ± 0.2% | not timed | not timed | 1723.85 ± 0.4% | | 1.01 | 0.96 | 183.32 |
| 02-literal-alternate/sherlock-ru | 899 | 5991.41 ± 11.4% | not timed | not timed | 4258.16 ± 0.3% | 19.55 ± 3.0% | not timed | not timed | 6006.69 ± 0.9% | | 1.00 | 1.41 | 306.52 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1816.48 ± 1.0% | not timed | not timed | 1042.15 ± 0.1% | 8.56 ± 1.4% | not timed | not timed | 1813.84 ± 0.4% | | 1.00 | 1.74 | 212.27 |
| 02-literal-alternate/sherlock-zh | 207 | 14009.46 ± 0.5% | not timed | not timed | 10409.00 ± 1.1% | 27.65 ± 2.4% | not timed | not timed | 14074.56 ± 1.1% | | 1.00 | 1.35 | 506.61 |
| 03-date/ascii | 111817 | 107.96 ± 2.7% | not timed | not timed | 84.96 ± 2.4% | 0.18 ± 5.1% | not timed | not timed | 108.08 ± 2.5% | | 1.00 | 1.27 | 600.67 |
| 04-ruff-noqa/real | 84 | 564.57 ± 1.8% | not timed | not timed | 421.89 ± 0.7% | 15.72 ± 2.0% | not timed | not timed | 565.33 ± 1.0% | | 1.00 | 1.34 | 35.91 |
| 04-ruff-noqa/tweaked | 44 | 487.86 ± 0.3% | not timed | not timed | 419.64 ± 1.2% | 287.57 ± 10.1% | not timed | not timed | 489.08 ± 14.5% | | 1.00 | 1.16 | 1.70 |
| 05-lexer-veryl/single | 124800 | 2.85 ± 1.3% | not timed | not timed | 4.04 ± 2.0% | 0.21 ± 9.6% | not timed | not timed | 2.86 ± 1.7% | | 1.00 | 0.71 | 13.74 |
| 06-cloud-flare-redos/original | 107 | 178.49 ± 1.8% | not timed | not timed | 192.69 ± 5.6% | 13.14 ± 2.0% | not timed | not timed | 177.39 ± 1.2% | | 1.01 | 0.93 | 13.58 |
| 06-cloud-flare-redos/simplified-short | 102 | 127.22 ± 0.3% | not timed | not timed | 192.44 ± 0.5% | 14.07 ± 0.4% | not timed | not timed | 127.22 ± 4.3% | | 1.00 | 0.66 | 9.04 |
| 06-cloud-flare-redos/simplified-long | 10000 | 136.33 ± 1.8% | not timed | not timed | 211.76 ± 0.7% | 14.89 ± 0.5% | not timed | not timed | 136.23 ± 1.7% | | 1.00 | 0.64 | 9.16 |
| 07-unicode-character-data/parse-line | 558784 | 36.29 ± 4.5% | not timed | not timed | 162.69 ± 0.6% | 37.55 ± 5.2% | not timed | not timed | 35.66 ± 2.4% | | 1.02 | 0.22 | 0.97 |
| 08-words/all-english | 56691 | 73.65 ± 0.6% | not timed | not timed | 73.96 ± 0.3% | 10.08 ± 10.5% | not timed | not timed | 73.67 ± 0.4% | | 1.00 | 1.00 | 7.31 |
| 08-words/long-english | 839 | 849.41 ± 0.4% | not timed | not timed | 515.49 ± 0.9% | 26.73 ± 0.6% | not timed | not timed | 849.29 ± 0.2% | | 1.00 | 1.65 | 31.78 |
| 09-aws-keys/full | 0 | 432.78 ± 0.3% | not timed | not timed | 435.57 ± 0.5% | 53.48 ± 6.5% | not timed | not timed | 433.29 ± 0.2% | | 1.00 | 0.99 | 8.09 |
| 09-aws-keys/quick | 0 | 443.34 ± 0.7% | not timed | not timed | 805.06 ± 7.8% | 306.17 ± 18.5% | not timed | not timed | 442.83 ± 0.2% | | 1.00 | 0.55 | 1.45 |
| 10-bounded-repeat/letters-en | 1833 | 471.22 ± 0.3% | not timed | not timed | 431.99 ± 0.1% | 16.94 ± 1.2% | not timed | not timed | 470.45 ± 0.7% | | 1.00 | 1.09 | 27.81 |
| 10-bounded-repeat/letters-ru | 3475 | 325.73 ± 0.2% | not timed | not timed | 408.56 ± 0.3% | 19.60 ± 13.5% | not timed | not timed | 324.05 ± 1.0% | | 1.01 | 0.80 | 16.62 |
| 10-bounded-repeat/context | 53 | 58.65 ± 1.5% | not timed | not timed | 55.83 ± 0.6% | 17.00 ± 3.0% | not timed | not timed | 58.74 ± 6.0% | | 1.00 | 1.05 | 3.45 |
| 10-bounded-repeat/capitals | 11 | 894.65 ± 1.4% | not timed | not timed | 531.01 ± 1.3% | 30.94 ± 6.8% | not timed | not timed | 893.61 ± 1.4% | | 1.00 | 1.68 | 28.92 |
| 11-unstructured-to-json/extract | 600 | 20.81 ± 2.0% | not timed | not timed | 62.20 ± 19.5% | 22.77 ± 2.5% | not timed | not timed | 20.62 ± 10.8% | | 1.01 | 0.33 | 0.91 |
| 12-dictionary/single | 1 | 460.31 ± 0.3% | not timed | not timed | 442.44 ± 2.1% | 0.32 ± 0.6% | not timed | not timed | 461.93 ± 0.2% | | 1.00 | 1.04 | 1452.54 |
| 14-quadratic/1x | 100 | 11.40 ± 0.5% | not timed | not timed | 9.11 ± 0.3% | 0.80 ± 2.0% | not timed | not timed | 11.37 ± 1.4% | | 1.00 | 1.25 | 14.22 |
| 14-quadratic/2x | 200 | 6.88 ± 0.8% | not timed | not timed | 4.91 ± 0.4% | 0.43 ± 0.6% | not timed | not timed | 6.91 ± 0.5% | | 1.00 | 1.40 | 15.95 |
| 14-quadratic/10x | 1000 | 1.57 ± 1.9% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 16.5% | not timed | not timed | 1.57 ± 0.2% | | 1.00 | 1.49 | 16.80 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.35 ± 0.4% | not timed | not timed | 0.39 ± 1.0% | 0.48 ± 3.4% | not timed | not timed | 1.34 ± 7.2% | | 1.00 | 3.46 | 2.79 |
| 04-ruff-noqa/compile-real | 1 | 78.49 ± 0.2% | not timed | not timed | 12.82 ± 0.9% | 125.36 ± 2.6% | not timed | not timed | 78.30 ± 0.5% | | 1.00 | 6.12 | 0.63 |
| 05-lexer-veryl/compile-single | 1 | 12.65 ± 2.1% | not timed | not timed | 2.36 ± 1.2% | 5.97 ± 28.4% | not timed | not timed | 12.63 ± 1.0% | | 1.00 | 5.35 | 2.12 |
| 07-unicode-character-data/compile | 1 | 50.92 ± 0.9% | not timed | not timed | 23.77 ± 3.6% | 32.92 ± 1.7% | not timed | not timed | 50.82 ± 0.8% | | 1.00 | 2.14 | 1.55 |
| 09-aws-keys/compile-full | 1 | 34.57 ± 0.4% | not timed | not timed | 7.40 ± 0.6% | 20.74 ± 4.8% | not timed | not timed | 34.48 ± 2.5% | | 1.00 | 4.67 | 1.67 |
| 09-aws-keys/compile-quick | 1 | 157.91 ± 0.6% | not timed | not timed | 44.89 ± 3.9% | 119.32 ± 12.7% | not timed | not timed | 155.01 ± 1.7% | | 1.02 | 3.52 | 1.32 |
| 10-bounded-repeat/compile-context | 1 | 10.61 ± 0.5% | not timed | not timed | 11.62 ± 0.8% | 15.10 ± 2.4% | not timed | not timed | 10.56 ± 0.8% | | 1.01 | 0.91 | 0.70 |
| 10-bounded-repeat/compile-capitals | 1 | 73.32 ± 0.4% | not timed | not timed | 8.81 ± 0.3% | 22.15 ± 15.3% | not timed | not timed | 73.15 ± 1.5% | | 1.00 | 8.32 | 3.31 |
| 11-unstructured-to-json/compile | 1 | 77.02 ± 0.8% | not timed | not timed | 36.66 ± 0.3% | 60.60 ± 4.7% | not timed | not timed | 76.70 ± 14.4% | | 1.00 | 2.10 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.29 ± 3.4% | not timed | not timed | 0.07 ± 16.9% | 0.09 ± 14.8% | not timed | not timed | 0.28 ± 4.0% | | 1.02 | 4.22 | 3.36 |

