# bench-regex

| Field | Value |
|---|---|
| Commit | c519449 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44949411942 |
| Date | 2026-11-21 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache, `stdx, no skip` the same with claim R1 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

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
- class: a distance, second text, in canterbury-large/world192.txt: `[0-9][0-9,]* km`
- other: a word between two words, in canterbury-large/bible.txt: `the [a-z]+ of`
- other: a heading's start tag, in http/html-1m: `<h[1-6][^>]*>`
- other: a whole word, in canterbury-large/bible.txt: `\bPharaoh\b`, which Rust's regex takes as `(?-u:\b)Pharaoh(?-u:\b)`
- other: a line's first word, second text, in canterbury-large/world192.txt: `(?m)^[A-Z][a-z]+:`
- other: fourteen octets before an x, in canterbury-large/bible.txt: `[a-q][^u-z]{13}x`
- other: a Greek word, in generated: words in four scripts: `[α-ω]+`

## Search in 1 MiB, MB/s

| Pattern | Matches | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| literal: a word | 217 | 4269.14 ± 0.9% | 606.71 ± 0.1% | 33.21 ± 0.2% | 40634.38 ± 1.3% | 12075.86 ± 3.1% | 12.74 ± 0.6% | 103.75 ± 0.7% | 7.04 | 0.11 | 0.35 |
| literal: a word that is not there | 0 | 4263.45 ± 0.3% | 610.00 ± 0.2% | 33.29 ± 0.9% | 45939.66 ± 0.3% | 43961.48 ± 1.2% | 12.62 ± 0.5% | 98.34 ± 0.7% | 6.99 | 0.09 | 0.10 |
| literal: one of four words | 661 | 1961.78 ± 0.5% | 599.84 ± 0.3% | 17.04 ± 0.4% | 11553.46 ± 0.8% | 24.69 ± 0.8% | 4.46 ± 4.7% | 8.65 ± 0.6% | 3.27 | 0.17 | 79.46 |
| literal: a word in any case | 217 | 2134.23 ± 0.8% | 606.99 ± 0.2% | 24.25 ± 0.5% | 11376.13 ± 0.2% | 46.24 ± 1.3% | refused | differs | 3.52 | 0.19 | 46.16 |
| literal: an href attribute | 33 | 1341.94 ± 0.6% | 608.32 ± 0.5% | 31.00 ± 0.4% | 35259.27 ± 0.2% | 2896.45 ± 2.3% | 9.51 ± 0.2% | 91.52 ± 0.3% | 2.21 | 0.04 | 0.46 |
| literal: a word, second text | 123 | 3577.48 ± 0.5% | 607.93 ± 0.1% | 32.82 ± 0.3% | 40672.94 ± 1.5% | 10999.27 ± 7.5% | 14.52 ± 0.6% | 87.72 ± 6.3% | 5.88 | 0.09 | 0.33 |
| class: two capitalized words | 1331 | 928.77 ± 2.2% | 585.87 ± 2.2% | 30.69 ± 0.3% | 576.30 ± 0.4% | 45.00 ± 0.4% | 10.94 ± 0.3% | 79.57 ± 5.4% | 1.59 | 1.61 | 20.64 |
| class: a word that ends in ing | 3399 | 554.19 ± 0.2% | 554.59 ± 0.1% | 20.61 ± 9.5% | 540.53 ± 2.2% | 33.08 ± 7.7% | 6.20 ± 3.0% | 20.62 ± 0.7% | 1.00 | 1.03 | 16.75 |
| class: a word in capitals | 2332 | 1186.74 ± 0.3% | 578.52 ± 0.0% | 32.20 ± 2.0% | 566.76 ± 0.6% | 48.49 ± 11.8% | 12.30 ± 0.2% | 102.49 ± 0.1% | 2.05 | 2.09 | 24.47 |
| class: a number | 8288 | 1885.56 ± 0.5% | 531.63 ± 0.5% | 32.94 ± 6.3% | 1864.51 ± 5.3% | 48.69 ± 18.1% | 0.38 ± 0.2% | 73.39 ± 0.2% | 3.55 | 1.01 | 38.73 |
| class: a distance, second text | 1481 | 1246.65 ± 0.1% | 588.60 ± 0.1% | 30.85 ± 0.8% | 9230.50 ± 0.5% | 46.03 ± 12.0% | 13.33 ± 0.3% | 78.24 ± 0.9% | 2.12 | 0.14 | 27.08 |
| other: a word between two words | 6104 | 500.07 ± 0.1% | 500.20 ± 0.2% | 27.21 ± 1.4% | 838.10 ± 0.3% | 124.04 ± 14.9% | 8.49 ± 0.3% | 73.01 ± 0.1% | 1.00 | 0.60 | 4.03 |
| other: a heading's start tag | 110 | 1254.27 ± 1.4% | 605.27 ± 0.2% | 32.69 ± 0.4% | 2643.89 ± 0.9% | 1975.86 ± 7.7% | 11.63 ± 0.5% | 107.36 ± 0.9% | 2.07 | 0.47 | 0.63 |
| other: a whole word | 217 | 606.77 ± 0.0% | 606.69 ± 0.2% | 33.54 ± 0.7% | 29252.47 ± 0.5% | 54.75 ± 1.3% | 11.03 ± 0.7% | 63.52 ± 1.4% | 1.00 | 0.02 | 11.08 |
| other: a line's first word, second text | 3716 | 544.40 ± 0.2% | 544.87 ± 0.5% | 36.65 ± 11.9% | 2430.68 ± 15.2% | 70.61 ± 3.3% | refused | refused | 1.00 | 0.22 | 7.71 |
| other: fourteen octets before an x | 87 | 1.73 ± 0.3% | 1.78 ± 2.8% | 1.66 ± 0.5% | 3455.81 ± 1.3% | 11.83 ± 0.6% | differs | 21.39 ± 2.1% | 0.97 | 0.00 | 0.15 |
| other: a Greek word | 21815 | 482.61 ± 1.5% | 342.38 ± 0.6% | 35.84 ± 0.8% | 308.04 ± 0.2% | 58.92 ± 9.0% | differs | refused | 1.41 | 1.57 | 8.19 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 21.83 ± 0.3% | 21.97 ± 0.4% | 0.62 ± 0.4% | 25.83 ± 0.5% | 2.86 ± 0.8% | differs | 4.33 ± 1.6% | 0.99 | 0.85 | 7.64 |
| a UUID | 32895 | 15.30 ± 0.2% | 15.29 ± 0.2% | 0.70 ± 1.5% | 18.90 ± 2.4% | 3.06 ± 4.7% | 0.52 ± 0.4% | 3.83 ± 0.7% | 1.00 | 0.81 | 5.00 |
| an IPv4 address | 33176 | 36.19 ± 1.0% | 36.17 ± 0.5% | 2.43 ± 0.2% | 36.58 ± 0.6% | 7.05 ± 1.9% | differs | 3.94 ± 2.4% | 1.00 | 0.99 | 5.13 |
| a date and time | 32954 | 25.29 ± 1.4% | 25.35 ± 1.5% | 1.78 ± 6.4% | 29.42 ± 0.2% | 8.54 ± 0.4% | 0.91 ± 0.3% | 8.02 ± 4.6% | 1.00 | 0.86 | 2.96 |
| a field path | 32606 | 26.29 ± 4.5% | 26.35 ± 1.9% | 0.96 ± 0.3% | 29.28 ± 4.6% | 3.57 ± 3.2% | differs | 3.10 ± 0.8% | 1.00 | 0.90 | 7.37 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 2.42 ± 6.7% | 2.44 ± 0.3% | 1.17 ± 0.2% | 13.46 ± 1.3% | 5.83 ± 1.4% | 0.76 ± 2.1% | none | 0.99 | 0.18 | 0.42 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 255.59 ± 4.4% | 255.62 ± 1.3% | 374.34 ± 0.1% | 101.87 ± 4.2% | 239.40 ± 2.4% | 714.44 ± 3.4% | 4759.49 ± 0.4% | 1.00 | 2.51 | 1.07 |
| a UUID | 62 | 194.52 ± 7.9% | 194.56 ± 4.9% | 266.45 ± 4.8% | 58.73 ± 1.2% | 117.85 ± 2.6% | 255.05 ± 2.6% | 5099.13 ± 0.7% | 1.00 | 3.31 | 1.65 |
| an IPv4 address | 29 | 358.08 ± 0.1% | 358.10 ± 1.3% | 708.34 ± 0.3% | 86.63 ± 0.9% | 148.03 ± 1.4% | 413.06 ± 2.0% | 8628.07 ± 0.7% | 1.00 | 4.13 | 2.42 |
| a date and time | 56 | 264.43 ± 0.2% | 264.56 ± 0.2% | 397.85 ± 0.6% | 84.83 ± 0.6% | 159.69 ± 2.0% | 469.46 ± 0.4% | 5239.22 ± 4.0% | 1.00 | 3.12 | 1.66 |
| a field path | 39 | 276.54 ± 0.5% | 276.57 ± 0.5% | 448.73 ± 0.5% | 93.13 ± 1.9% | 226.25 ± 65.4% | 735.52 ± 3.2% | 5778.99 ± 0.7% | 1.00 | 2.97 | 1.22 |
| literal: a word | 7 | 492.01 ± 0.2% | 492.46 ± 0.3% | 1698.30 ± 0.1% | 663.97 ± 0.8% | 788.88 ± 3.2% | 1550.07 ± 0.5% | 27008.35 ± 2.3% | 1.00 | 0.74 | 0.62 |
| literal: a word that is not there | 8 | 549.23 ± 6.8% | 552.19 ± 1.2% | 1596.85 ± 0.2% | 600.62 ± 1.7% | 763.44 ± 2.0% | 1456.86 ± 0.5% | 26649.62 ± 1.7% | 0.99 | 0.91 | 0.72 |
| literal: one of four words | 26 | 386.27 ± 0.2% | 386.54 ± 0.3% | 689.42 ± 0.5% | 58.44 ± 0.4% | 287.77 ± 23.8% | 574.37 ± 7.2% | 15394.16 ± 9.7% | 1.00 | 6.61 | 1.34 |
| literal: a word in any case | 11 | 511.25 ± 6.3% | 511.32 ± 6.2% | 1345.48 ± 0.1% | 19.43 ± 2.4% | 814.55 ± 2.8% | refused | 21129.75 ± 2.6% | 1.00 | 26.31 | 0.63 |
| literal: an href attribute | 12 | 365.33 ± 0.3% | 365.83 ± 0.3% | 639.71 ± 11.0% | 49.61 ± 6.3% | 565.79 ± 3.3% | 1255.03 ± 0.5% | 20836.17 ± 0.4% | 1.00 | 7.36 | 0.65 |
| literal: a word, second text | 10 | 565.18 ± 0.1% | 565.51 ± 0.2% | 1417.53 ± 0.2% | 530.45 ± 11.7% | 648.47 ± 5.1% | 1323.52 ± 0.5% | 25828.86 ± 1.0% | 1.00 | 1.07 | 0.87 |
| class: two capitalized words | 23 | 326.08 ± 3.7% | 326.41 ± 0.2% | 694.11 ± 0.3% | 122.27 ± 0.5% | 595.46 ± 5.1% | 1215.94 ± 7.6% | 7763.30 ± 0.3% | 1.00 | 2.67 | 0.55 |
| class: a word that ends in ing | 9 | 442.13 ± 0.8% | 442.80 ± 0.3% | 1371.60 ± 0.4% | 149.16 ± 1.4% | 860.82 ± 1.0% | 1825.12 ± 0.7% | 18482.68 ± 0.6% | 1.00 | 2.96 | 0.51 |
| class: a word in capitals | 16 | 326.86 ± 6.4% | 337.70 ± 0.2% | 895.74 ± 0.1% | 153.45 ± 1.0% | 884.20 ± 47.5% | 1679.58 ± 0.3% | 10313.69 ± 0.6% | 0.97 | 2.13 | 0.37 |
| class: a number | 6 | 405.25 ± 0.3% | 405.45 ± 0.2% | 1581.94 ± 0.5% | 48.52 ± 5.0% | 1673.71 ± 2.0% | 2974.35 ± 5.1% | 22926.78 ± 8.1% | 1.00 | 8.35 | 0.24 |
| class: a distance, second text | 15 | 400.04 ± 0.3% | 400.11 ± 0.3% | 947.21 ± 0.9% | 45.19 ± 0.8% | 722.95 ± 3.4% | 1368.65 ± 4.2% | 16346.69 ± 0.5% | 1.00 | 8.85 | 0.55 |
| other: a word between two words | 13 | 449.01 ± 0.2% | 448.92 ± 0.4% | 1127.67 ± 0.5% | 158.44 ± 1.5% | 578.36 ± 2.4% | 1326.94 ± 1.3% | 15835.96 ± 9.6% | 1.00 | 2.83 | 0.78 |
| other: a heading's start tag | 13 | 352.60 ± 0.5% | 353.35 ± 0.2% | 613.62 ± 0.7% | 48.93 ± 0.8% | 704.31 ± 2.0% | 1384.41 ± 1.4% | 18089.07 ± 1.0% | 1.00 | 7.21 | 0.50 |
| other: a whole word | 11 | 532.56 ± 0.2% | 532.55 ± 0.3% | 1394.97 ± 0.1% | 127.84 ± 0.5% | 653.45 ± 4.8% | 1346.87 ± 0.7% | 25849.74 ± 0.9% | 1.00 | 4.17 | 0.81 |
| other: a line's first word, second text | 17 | 497.49 ± 1.6% | 501.07 ± 0.1% | 1083.26 ± 0.6% | 147.40 ± 0.7% | 794.20 ± 3.5% | refused | refused | 0.99 | 3.38 | 0.63 |
| other: fourteen octets before an x | 16 | 159.44 ± 0.2% | 159.64 ± 0.4% | 202.30 ± 1.0% | 17.82 ± 1.1% | 514.06 ± 2.4% | 563.18 ± 1.5% | 14784.43 ± 1.6% | 1.00 | 8.95 | 0.31 |
| other: a Greek word | 8 | 424.19 ± 0.2% | 424.76 ± 0.1% | 1445.79 ± 0.2% | 63.26 ± 0.2% | 1644.03 ± 1.5% | 2717.12 ± 0.5% | refused | 1.00 | 6.71 | 0.26 |

