# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117671569 |
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
| literal: a word | 217 | 22565.14 ± 1.0% | 840.59 ± 0.8% | 26.15 ± 4.0% | 23055.00 ± 0.8% | 8738.85 ± 8.5% | 11.65 ± 0.3% | 82.33 ± 2.0% | 22488.16 ± 0.7% | 26.84 | 1.00 | 0.98 | 2.58 |
| literal: a word that is not there | 0 | 28553.89 ± 1.3% | 848.12 ± 0.7% | 26.06 ± 0.8% | 25297.57 ± 0.8% | 28485.56 ± 1.4% | 11.34 ± 0.8% | 71.64 ± 0.9% | 28517.54 ± 1.1% | 33.67 | 1.00 | 1.13 | 1.00 |
| literal: one of four words | 661 | 9849.06 ± 3.3% | 822.13 ± 0.6% | 14.78 ± 1.5% | 7502.42 ± 0.4% | 22.51 ± 0.7% | 3.41 ± 0.4% | 5.84 ± 1.6% | 9726.26 ± 1.5% | 11.98 | 1.01 | 1.31 | 437.58 |
| literal: a word in any case | 217 | 19722.78 ± 1.8% | 840.14 ± 0.4% | 19.25 ± 1.4% | 7739.06 ± 0.5% | 43.17 ± 1.6% | refused | differs | 19679.32 ± 0.6% | 23.48 | 1.00 | 2.55 | 456.90 |
| literal: an href attribute | 33 | 20237.71 ± 1.3% | 845.31 ± 0.7% | 23.76 ± 0.2% | 20895.15 ± 1.2% | 1997.11 ± 1.0% | 8.35 ± 1.4% | 74.46 ± 0.7% | 20409.92 ± 0.6% | 23.94 | 0.99 | 0.97 | 10.13 |
| literal: a word, second text | 123 | 23610.48 ± 0.3% | 842.33 ± 0.6% | 25.79 ± 2.9% | 23031.35 ± 4.0% | 6809.75 ± 4.2% | 15.08 ± 3.0% | 71.49 ± 3.7% | 23623.26 ± 1.4% | 28.03 | 1.00 | 1.03 | 3.47 |
| class: two capitalized words | 1331 | 775.74 ± 0.3% | 774.47 ± 0.5% | 24.19 ± 0.4% | 473.91 ± 0.5% | 37.61 ± 3.0% | 9.91 ± 0.6% | 60.54 ± 1.1% | 776.32 ± 0.2% | 1.00 | 1.00 | 1.64 | 20.63 |
| class: a word that ends in ing | 3399 | 710.90 ± 0.4% | 708.62 ± 0.3% | 16.17 ± 4.7% | 445.22 ± 0.5% | 27.10 ± 9.7% | 5.57 ± 0.5% | 16.43 ± 1.0% | 709.93 ± 0.7% | 1.00 | 1.00 | 1.60 | 26.23 |
| class: a word in capitals | 2332 | 1059.32 ± 3.6% | 761.53 ± 0.5% | 25.65 ± 1.5% | 465.38 ± 0.6% | 40.96 ± 5.7% | 11.92 ± 4.6% | 77.39 ± 1.8% | 1048.54 ± 1.8% | 1.39 | 1.01 | 2.28 | 25.86 |
| class: a number | 8288 | 1518.03 ± 0.5% | 646.98 ± 0.2% | 25.35 ± 1.7% | 1616.76 ± 0.3% | 39.73 ± 11.8% | 0.33 ± 0.1% | 56.22 ± 0.5% | 1520.41 ± 0.5% | 2.35 | 1.00 | 0.94 | 38.21 |
| class: two capitalized words, second text | 5359 | 558.27 ± 0.6% | 558.45 ± 0.7% | 21.86 ± 2.1% | 392.70 ± 0.7% | 31.87 ± 5.9% | 12.97 ± 0.7% | 54.99 ± 2.7% | 557.26 ± 0.5% | 1.00 | 1.00 | 1.42 | 17.52 |
| other: a word between two words | 6104 | 604.34 ± 0.8% | 596.05 ± 1.4% | 21.57 ± 1.1% | 668.06 ± 0.4% | 103.65 ± 7.4% | 7.58 ± 0.5% | 65.18 ± 1.4% | 603.23 ± 0.2% | 1.01 | 1.00 | 0.90 | 5.83 |
| other: a number before a unit, second text | 1481 | 6793.70 ± 0.8% | 791.69 ± 0.7% | 24.09 ± 2.0% | 7014.46 ± 1.6% | 38.14 ± 5.0% | 13.53 ± 0.4% | 58.16 ± 1.1% | 6683.06 ± 3.3% | 8.58 | 1.02 | 0.97 | 178.11 |
| other: a heading's start tag | 110 | 15195.55 ± 0.6% | 838.09 ± 0.7% | 25.61 ± 3.7% | 2048.31 ± 0.7% | 1483.63 ± 3.9% | 10.38 ± 0.5% | 85.93 ± 1.6% | 15180.02 ± 0.4% | 18.13 | 1.00 | 7.42 | 10.24 |
| other: a whole word | 217 | 17947.33 ± 1.0% | 839.77 ± 0.3% | 26.67 ± 0.7% | 18621.53 ± 1.0% | 44.28 ± 0.7% | 9.89 ± 0.4% | 49.08 ± 0.5% | 17990.97 ± 0.6% | 21.37 | 1.00 | 0.96 | 405.29 |
| other: a line's first word, second text | 3716 | 1801.36 ± 1.0% | 692.71 ± 1.2% | 27.60 ± 6.0% | 1881.67 ± 4.3% | 60.59 ± 8.6% | refused | refused | 1782.96 ± 2.5% | 2.60 | 1.01 | 0.96 | 29.73 |
| other: fourteen octets before an x | 87 | 26261.15 ± 0.6% | 233.90 ± 0.6% | 5.53 ± 0.9% | 3251.76 ± 0.7% | 8.88 ± 1.1% | differs | 15.22 ± 2.4% | 26202.08 ± 1.2% | 112.27 | 1.00 | 8.08 | 2958.32 |
| other: a Greek word | 21815 | 399.47 ± 0.4% | 265.28 ± 1.4% | 28.82 ± 1.9% | 241.75 ± 0.7% | 46.55 ± 7.4% | differs | refused | 398.37 ± 0.8% | 1.51 | 1.00 | 1.65 | 8.58 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 22.07 ± 0.8% | 22.11 ± 0.7% | 0.81 ± 3.0% | 16.39 ± 0.6% | 2.35 ± 1.1% | differs | 3.61 ± 0.3% | 22.11 ± 0.4% | 1.00 | 1.00 | 1.35 | 9.39 |
| a UUID | 32895 | 19.86 ± 0.5% | 19.89 ± 0.2% | 0.58 ± 1.9% | 12.64 ± 0.5% | 2.48 ± 1.6% | 0.55 ± 0.3% | 3.09 ± 0.6% | 19.86 ± 0.8% | 1.00 | 1.00 | 1.57 | 8.01 |
| an IPv4 address | 33176 | 29.54 ± 1.0% | 29.72 ± 0.5% | 1.85 ± 0.3% | 24.03 ± 0.4% | 5.84 ± 0.7% | differs | 3.41 ± 1.2% | 29.62 ± 1.2% | 0.99 | 1.00 | 1.23 | 5.06 |
| a date and time | 32954 | 28.88 ± 0.4% | 28.87 ± 0.6% | 1.33 ± 2.2% | 18.30 ± 0.5% | 7.62 ± 0.9% | 1.01 ± 0.4% | 6.59 ± 3.2% | 28.88 ± 0.8% | 1.00 | 1.00 | 1.58 | 3.79 |
| a field path | 32606 | 24.02 ± 1.1% | 23.98 ± 0.6% | 0.96 ± 1.0% | 18.89 ± 1.1% | 2.74 ± 0.4% | differs | 2.33 ± 1.5% | 24.02 ± 0.8% | 1.00 | 1.00 | 1.27 | 8.77 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.51 ± 0.5% | 9.48 ± 0.4% | 9.47 ± 0.6% | 11.55 ± 0.6% | 5.04 ± 1.0% | 0.80 ± 0.7% | none | 9.50 ± 2.2% | 1.00 | 1.00 | 0.82 | 1.89 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 241.91 ± 1.8% | 242.83 ± 0.7% | 285.03 ± 1.1% | 85.10 ± 4.2% | 195.99 ± 1.2% | 544.94 ± 2.4% | 3193.77 ± 1.4% | 242.59 ± 0.7% | 1.00 | 1.00 | 2.84 | 1.23 |
| a UUID | 62 | 157.44 ± 0.7% | 158.22 ± 1.0% | 175.64 ± 2.0% | 45.85 ± 1.2% | 90.55 ± 25.3% | 191.54 ± 3.6% | 3939.14 ± 1.2% | 157.13 ± 1.0% | 1.00 | 1.00 | 3.43 | 1.74 |
| an IPv4 address | 29 | 468.97 ± 9.6% | 474.39 ± 3.0% | 658.67 ± 0.5% | 75.00 ± 0.4% | 118.26 ± 0.8% | 333.10 ± 0.3% | 6426.40 ± 3.1% | 468.79 ± 1.9% | 0.99 | 1.00 | 6.25 | 3.97 |
| a date and time | 56 | 360.02 ± 0.7% | 363.18 ± 0.7% | 457.53 ± 0.6% | 71.05 ± 0.6% | 123.52 ± 1.9% | 346.63 ± 2.6% | 4135.29 ± 2.9% | 360.28 ± 1.9% | 0.99 | 1.00 | 5.07 | 2.91 |
| a field path | 39 | 237.53 ± 0.5% | 238.83 ± 0.6% | 277.05 ± 0.7% | 77.63 ± 1.9% | 184.79 ± 2.2% | 556.80 ± 1.2% | 4001.45 ± 0.8% | 237.26 ± 0.1% | 0.99 | 1.00 | 3.06 | 1.29 |
| literal: a word | 7 | 736.94 ± 0.5% | 794.18 ± 0.4% | 1423.11 ± 0.7% | 511.77 ± 3.6% | 603.31 ± 1.8% | 1108.06 ± 1.0% | 25806.19 ± 1.8% | 735.38 ± 0.5% | 0.93 | 1.00 | 1.44 | 1.22 |
| literal: a word that is not there | 8 | 702.91 ± 0.6% | 765.60 ± 0.8% | 1337.29 ± 0.7% | 474.01 ± 2.3% | 567.66 ± 4.1% | 1044.79 ± 0.9% | 24448.58 ± 1.7% | 702.99 ± 0.4% | 0.92 | 1.00 | 1.48 | 1.24 |
| literal: one of four words | 26 | 273.44 ± 0.9% | 474.17 ± 0.6% | 646.62 ± 0.6% | 38.21 ± 1.2% | 226.59 ± 2.7% | 393.80 ± 2.4% | 12322.39 ± 0.9% | 273.39 ± 0.2% | 0.58 | 1.00 | 7.16 | 1.21 |
| literal: a word in any case | 11 | 539.87 ± 0.5% | 581.46 ± 2.1% | 866.17 ± 0.7% | 12.82 ± 0.8% | 617.85 ± 1.3% | refused | 19488.79 ± 1.8% | 540.14 ± 1.1% | 0.93 | 1.00 | 42.13 | 0.87 |
| literal: an href attribute | 12 | 380.28 ± 1.4% | 391.68 ± 0.6% | 511.36 ± 0.8% | 37.45 ± 0.3% | 455.39 ± 6.9% | 887.16 ± 0.4% | 17636.95 ± 0.8% | 381.38 ± 0.4% | 0.97 | 1.00 | 10.16 | 0.84 |
| literal: a word, second text | 10 | 649.89 ± 0.9% | 724.04 ± 0.8% | 1219.17 ± 4.8% | 432.24 ± 4.4% | 498.03 ± 1.4% | 913.63 ± 0.4% | 22291.44 ± 0.8% | 650.23 ± 0.8% | 0.90 | 1.00 | 1.50 | 1.30 |
| class: two capitalized words | 23 | 543.47 ± 3.8% | 578.39 ± 5.7% | 863.71 ± 5.5% | 100.30 ± 7.0% | 462.98 ± 7.3% | 833.22 ± 1.5% | 5585.31 ± 1.4% | 542.69 ± 5.6% | 0.94 | 1.00 | 5.42 | 1.17 |
| class: a word that ends in ing | 9 | 645.35 ± 2.8% | 728.21 ± 0.8% | 1298.38 ± 0.7% | 131.80 ± 0.2% | 679.77 ± 1.6% | 1300.81 ± 1.9% | 13808.11 ± 1.5% | 646.00 ± 1.6% | 0.89 | 1.00 | 4.90 | 0.95 |
| class: a word in capitals | 16 | 581.93 ± 0.8% | 632.41 ± 0.5% | 1038.15 ± 1.4% | 135.85 ± 2.3% | 688.45 ± 8.9% | 1174.92 ± 2.8% | 7493.60 ± 4.5% | 583.60 ± 0.2% | 0.92 | 1.00 | 4.28 | 0.85 |
| class: a number | 6 | 706.26 ± 4.1% | 779.48 ± 3.9% | 1467.27 ± 2.2% | 33.71 ± 0.4% | 1255.52 ± 1.8% | 2261.17 ± 2.5% | 20647.11 ± 3.1% | 710.38 ± 15.7% | 0.91 | 0.99 | 20.95 | 0.56 |
| class: two capitalized words, second text | 23 | 543.00 ± 0.4% | 579.62 ± 2.1% | 867.17 ± 1.0% | 101.73 ± 1.4% | 464.61 ± 2.6% | 861.05 ± 1.5% | 5590.49 ± 4.1% | 542.38 ± 1.1% | 0.94 | 1.00 | 5.34 | 1.17 |
| other: a word between two words | 13 | 627.32 ± 0.6% | 650.30 ± 0.3% | 1062.69 ± 4.1% | 134.21 ± 1.3% | 458.44 ± 1.7% | 936.94 ± 0.8% | 12292.22 ± 0.6% | 626.29 ± 2.4% | 0.96 | 1.00 | 4.67 | 1.37 |
| other: a number before a unit, second text | 15 | 455.59 ± 0.7% | 501.07 ± 0.6% | 700.82 ± 1.2% | 31.88 ± 0.9% | 571.43 ± 3.0% | 1067.58 ± 0.9% | 12602.71 ± 0.8% | 455.31 ± 1.1% | 0.91 | 1.00 | 14.29 | 0.80 |
| other: a heading's start tag | 13 | 393.85 ± 0.5% | 399.83 ± 0.6% | 521.64 ± 0.7% | 36.64 ± 1.3% | 568.59 ± 1.8% | 1008.95 ± 0.7% | 14641.80 ± 1.9% | 392.75 ± 0.6% | 0.99 | 1.00 | 10.75 | 0.69 |
| other: a whole word | 11 | 663.64 ± 4.6% | 704.34 ± 0.8% | 1173.84 ± 1.4% | 116.13 ± 0.8% | 521.90 ± 2.2% | 965.81 ± 2.7% | 21364.54 ± 1.3% | 665.09 ± 0.6% | 0.94 | 1.00 | 5.71 | 1.27 |
| other: a line's first word, second text | 17 | 612.42 ± 0.7% | 638.72 ± 0.6% | 1016.96 ± 1.9% | 131.17 ± 0.4% | 630.31 ± 2.4% | refused | refused | 609.55 ± 1.4% | 0.96 | 1.00 | 4.67 | 0.97 |
| other: fourteen octets before an x | 16 | 99.59 ± 0.6% | 147.72 ± 0.5% | 176.80 ± 0.8% | 14.20 ± 0.7% | 402.88 ± 24.5% | 460.40 ± 1.2% | 11194.31 ± 0.9% | 99.36 ± 4.8% | 0.67 | 1.00 | 7.02 | 0.25 |
| other: a Greek word | 8 | 473.85 ± 0.7% | 649.52 ± 1.9% | 1043.29 ± 1.0% | 47.15 ± 0.6% | 1248.48 ± 2.7% | 2184.41 ± 0.5% | refused | 473.59 ± 1.1% | 0.73 | 1.00 | 10.05 | 0.38 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 16445.75 ± 0.2% | not timed | not timed | 20109.11 ± 1.5% | 1967.27 ± 15.1% | not timed | not timed | 16495.04 ± 1.5% | | 1.00 | 0.82 | 8.36 |
| 01-literal/sherlock-casei-en | 522 | 4846.39 ± 1.4% | not timed | not timed | 6502.62 ± 1.0% | 29.18 ± 0.7% | not timed | not timed | 4803.39 ± 0.4% | | 1.01 | 0.75 | 166.06 |
| 01-literal/sherlock-ru | 724 | 17318.82 ± 1.0% | not timed | not timed | 20085.04 ± 1.0% | 1119.45 ± 7.0% | not timed | not timed | 17131.99 ± 1.6% | | 1.01 | 0.86 | 15.47 |
| 01-literal/sherlock-casei-ru | 746 | 6585.50 ± 0.3% | not timed | not timed | 5125.64 ± 1.6% | 31.85 ± 4.7% | not timed | not timed | 6575.67 ± 0.5% | | 1.00 | 1.28 | 206.74 |
| 01-literal/sherlock-zh | 30 | 26041.36 ± 2.1% | not timed | not timed | 24366.05 ± 1.3% | 1227.37 ± 0.5% | not timed | not timed | 26012.10 ± 1.5% | | 1.00 | 1.07 | 21.22 |
| 02-literal-alternate/sherlock-en | 714 | 9007.80 ± 1.9% | not timed | not timed | 7226.12 ± 1.0% | 17.17 ± 0.7% | not timed | not timed | 8973.79 ± 1.8% | | 1.00 | 1.25 | 524.73 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1591.17 ± 2.8% | not timed | not timed | 1860.29 ± 0.4% | 10.09 ± 8.1% | not timed | not timed | 1579.94 ± 0.3% | | 1.01 | 0.86 | 157.70 |
| 02-literal-alternate/sherlock-ru | 899 | 5663.96 ± 1.2% | not timed | not timed | 3955.48 ± 1.4% | 22.30 ± 1.6% | not timed | not timed | 5668.84 ± 0.6% | | 1.00 | 1.43 | 254.04 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1646.96 ± 1.6% | not timed | not timed | 952.18 ± 0.8% | 8.64 ± 0.4% | not timed | not timed | 1650.31 ± 2.5% | | 1.00 | 1.73 | 190.59 |
| 02-literal-alternate/sherlock-zh | 207 | 12088.01 ± 0.6% | not timed | not timed | 8255.51 ± 0.3% | 32.16 ± 2.9% | not timed | not timed | 12028.89 ± 4.0% | | 1.00 | 1.46 | 375.88 |
| 03-date/ascii | 111817 | 95.58 ± 0.6% | not timed | not timed | 85.31 ± 2.3% | 0.19 ± 4.3% | not timed | not timed | 95.40 ± 0.7% | | 1.00 | 1.12 | 490.86 |
| 04-ruff-noqa/real | 84 | 565.00 ± 1.1% | not timed | not timed | 433.71 ± 0.4% | 19.11 ± 1.6% | not timed | not timed | 566.03 ± 0.8% | | 1.00 | 1.30 | 29.57 |
| 04-ruff-noqa/tweaked | 44 | 481.62 ± 1.3% | not timed | not timed | 433.93 ± 0.5% | 307.77 ± 12.7% | not timed | not timed | 478.78 ± 0.8% | | 1.01 | 1.11 | 1.56 |
| 05-lexer-veryl/single | 124800 | 3.44 ± 1.0% | not timed | not timed | 4.51 ± 1.2% | 0.20 ± 2.2% | not timed | not timed | 3.43 ± 3.0% | | 1.00 | 0.76 | 17.05 |
| 06-cloud-flare-redos/original | 107 | 184.21 ± 1.0% | not timed | not timed | 191.28 ± 1.7% | 23.72 ± 1.7% | not timed | not timed | 184.09 ± 1.5% | | 1.00 | 0.96 | 7.77 |
| 06-cloud-flare-redos/simplified-short | 102 | 140.40 ± 1.4% | not timed | not timed | 173.21 ± 1.2% | 25.41 ± 0.8% | not timed | not timed | 140.46 ± 4.3% | | 1.00 | 0.81 | 5.52 |
| 06-cloud-flare-redos/simplified-long | 10000 | 146.30 ± 3.2% | not timed | not timed | 209.83 ± 2.2% | 28.14 ± 1.1% | not timed | not timed | 145.82 ± 3.2% | | 1.00 | 0.70 | 5.20 |
| 07-unicode-character-data/parse-line | 558784 | 217.00 ± 2.6% | not timed | not timed | 161.32 ± 0.9% | 36.19 ± 14.2% | not timed | not timed | 212.93 ± 2.2% | | 1.02 | 1.35 | 6.00 |
| 08-words/all-english | 56691 | 80.09 ± 0.9% | not timed | not timed | 71.69 ± 0.5% | 11.26 ± 1.3% | not timed | not timed | 80.40 ± 0.6% | | 1.00 | 1.12 | 7.11 |
| 08-words/long-english | 839 | 802.49 ± 0.6% | not timed | not timed | 480.22 ± 0.8% | 28.43 ± 0.7% | not timed | not timed | 802.31 ± 0.2% | | 1.00 | 1.67 | 28.23 |
| 09-aws-keys/full | 0 | 443.30 ± 0.8% | not timed | not timed | 444.42 ± 0.5% | 59.64 ± 0.4% | not timed | not timed | 444.50 ± 0.3% | | 1.00 | 1.00 | 7.43 |
| 09-aws-keys/quick | 0 | 841.98 ± 0.7% | not timed | not timed | 716.72 ± 1.2% | 348.74 ± 15.0% | not timed | not timed | 839.07 ± 1.5% | | 1.00 | 1.17 | 2.41 |
| 10-bounded-repeat/letters-en | 1833 | 468.73 ± 1.4% | not timed | not timed | 437.74 ± 1.6% | 18.64 ± 1.3% | not timed | not timed | 467.07 ± 0.7% | | 1.00 | 1.07 | 25.14 |
| 10-bounded-repeat/letters-ru | 3475 | 304.10 ± 0.4% | not timed | not timed | 390.71 ± 3.4% | 20.55 ± 6.9% | not timed | not timed | 303.62 ± 2.0% | | 1.00 | 0.78 | 14.79 |
| 10-bounded-repeat/context | 53 | 69.22 ± 1.4% | not timed | not timed | 57.99 ± 2.4% | 18.58 ± 0.8% | not timed | not timed | 70.48 ± 2.3% | | 0.98 | 1.19 | 3.72 |
| 10-bounded-repeat/capitals | 11 | 841.24 ± 1.0% | not timed | not timed | 494.62 ± 0.5% | 34.35 ± 0.8% | not timed | not timed | 839.01 ± 0.4% | | 1.00 | 1.70 | 24.49 |
| 11-unstructured-to-json/extract | 600 | 36.49 ± 1.9% | not timed | not timed | 62.41 ± 1.0% | 48.06 ± 1.7% | not timed | not timed | 36.42 ± 3.3% | | 1.00 | 0.58 | 0.76 |
| 12-dictionary/single | 1 | 440.07 ± 1.0% | not timed | not timed | 424.02 ± 1.2% | 0.36 ± 0.7% | not timed | not timed | 442.24 ± 0.1% | | 1.00 | 1.04 | 1211.47 |
| 14-quadratic/1x | 100 | 10.96 ± 0.4% | not timed | not timed | 10.57 ± 3.9% | 0.95 ± 3.7% | not timed | not timed | 10.93 ± 1.0% | | 1.00 | 1.04 | 11.58 |
| 14-quadratic/2x | 200 | 6.59 ± 2.5% | not timed | not timed | 5.16 ± 1.8% | 0.53 ± 2.1% | not timed | not timed | 6.58 ± 0.8% | | 1.00 | 1.28 | 12.46 |
| 14-quadratic/10x | 1000 | 1.49 ± 0.3% | not timed | not timed | 1.00 ± 0.8% | 0.11 ± 2.7% | not timed | not timed | 1.50 ± 0.4% | | 1.00 | 1.50 | 13.03 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.51 ± 4.4% | not timed | not timed | 0.33 ± 4.5% | 0.50 ± 6.7% | not timed | not timed | 1.50 ± 4.7% | | 1.01 | 4.60 | 3.05 |
| 04-ruff-noqa/compile-real | 1 | 93.11 ± 1.4% | not timed | not timed | 11.69 ± 0.8% | 128.94 ± 2.5% | not timed | not timed | 92.66 ± 1.6% | | 1.00 | 7.96 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 15.95 ± 2.0% | not timed | not timed | 2.22 ± 0.6% | 5.92 ± 2.3% | not timed | not timed | 15.97 ± 1.1% | | 1.00 | 7.17 | 2.69 |
| 07-unicode-character-data/compile | 1 | 56.68 ± 3.7% | not timed | not timed | 24.26 ± 0.5% | 32.54 ± 4.5% | not timed | not timed | 57.70 ± 0.7% | | 0.98 | 2.34 | 1.74 |
| 09-aws-keys/compile-full | 1 | 38.59 ± 0.6% | not timed | not timed | 6.75 ± 0.5% | 21.14 ± 8.0% | not timed | not timed | 38.59 ± 0.7% | | 1.00 | 5.72 | 1.83 |
| 09-aws-keys/compile-quick | 1 | 187.89 ± 1.9% | not timed | not timed | 45.11 ± 0.3% | 121.76 ± 17.8% | not timed | not timed | 187.77 ± 1.0% | | 1.00 | 4.17 | 1.54 |
| 10-bounded-repeat/compile-context | 1 | 11.72 ± 1.5% | not timed | not timed | 10.60 ± 1.0% | 15.50 ± 3.7% | not timed | not timed | 11.68 ± 1.9% | | 1.00 | 1.11 | 0.76 |
| 10-bounded-repeat/compile-capitals | 1 | 70.24 ± 1.4% | not timed | not timed | 7.99 ± 1.0% | 22.46 ± 3.0% | not timed | not timed | 71.33 ± 0.6% | | 0.98 | 8.79 | 3.13 |
| 11-unstructured-to-json/compile | 1 | 88.93 ± 1.2% | not timed | not timed | 38.31 ± 1.8% | 61.92 ± 2.7% | not timed | not timed | 88.75 ± 0.7% | | 1.00 | 2.32 | 1.44 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.1% | not timed | not timed | 0.06 ± 17.8% | 0.09 ± 14.9% | not timed | not timed | 0.28 ± 2.9% | | 1.01 | 4.86 | 3.20 |

