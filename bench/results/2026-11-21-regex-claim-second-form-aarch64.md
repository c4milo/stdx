# bench-regex

| Field | Value |
|---|---|
| Commit | 4ce909a |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44945332342 |
| Date | 2026-11-21 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache, `stdx, no skip` the same with claim R1 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed.

The patterns of the search table:

- prose: a word, in canterbury-large/bible.txt: `Pharaoh`
- prose: a word that is not there, in canterbury-large/bible.txt: `Sherlock`
- prose: one of four words, in canterbury-large/bible.txt: `Abraham|Isaac|Jacob|Joseph`
- prose: a word in any case, in canterbury-large/bible.txt: `(?i)pharaoh`
- prose: a word between two words, in canterbury-large/bible.txt: `the [a-z]+ of`
- prose: two capitalized words, in canterbury-large/bible.txt: `[A-Z][a-z]+ [A-Z][a-z]+`
- prose: a word that ends in ing, in canterbury-large/bible.txt: `[a-z]+ing`
- prose: a word in capitals, in canterbury-large/bible.txt: `[A-Z][A-Z][A-Z]+`
- markup: an href attribute, in http/html-1m: `href="[^"]*"`
- markup: a heading's start tag, in http/html-1m: `<h[1-6][^>]*>`
- markup: a number, in http/html-1m: `[0-9]+`

## Search in 1 MiB, MB/s

| Pattern | Matches | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| prose: a word | 217 | 5220.02 ± 0.4% | 573.51 ± 0.2% | 28.85 ± 0.2% | 18677.83 ± 1.2% | 9233.09 ± 7.2% | 17.24 ± 0.8% | 84.20 ± 0.9% | 9.10 | 0.28 | 0.57 |
| prose: a word that is not there | 0 | 5380.47 ± 0.4% | 575.41 ± 0.7% | 29.00 ± 0.3% | 19961.39 ± 2.6% | 29314.20 ± 0.6% | 17.07 ± 0.2% | 79.43 ± 0.5% | 9.35 | 0.27 | 0.18 |
| prose: one of four words | 661 | 2409.33 ± 1.6% | 566.55 ± 0.1% | 15.17 ± 0.2% | 3988.69 ± 0.1% | 21.91 ± 0.4% | 5.38 ± 0.3% | 6.89 ± 0.4% | 4.25 | 0.60 | 109.95 |
| prose: a word in any case | 217 | 2652.26 ± 1.9% | 574.21 ± 0.1% | 22.00 ± 0.5% | 4071.20 ± 0.2% | 37.94 ± 0.3% | refused | differs | 4.62 | 0.65 | 69.91 |
| prose: a word between two words | 6104 | 473.12 ± 0.2% | 473.05 ± 0.3% | 23.88 ± 0.2% | 905.07 ± 0.3% | 106.58 ± 14.3% | 11.27 ± 0.3% | 68.37 ± 0.2% | 1.00 | 0.52 | 4.44 |
| prose: two capitalized words | 1331 | 1118.08 ± 0.4% | 549.08 ± 0.4% | 26.77 ± 0.1% | 600.24 ± 0.2% | 40.76 ± 0.3% | 14.81 ± 0.2% | 67.43 ± 0.3% | 2.04 | 1.86 | 27.43 |
| prose: a word that ends in ing | 3399 | 514.27 ± 0.1% | 516.29 ± 0.1% | 18.48 ± 0.3% | 586.28 ± 0.2% | 29.53 ± 12.7% | 8.15 ± 0.1% | 18.21 ± 0.9% | 1.00 | 0.88 | 17.42 |
| prose: a word in capitals | 2332 | 1363.17 ± 0.4% | 538.25 ± 0.3% | 28.27 ± 0.2% | 597.47 ± 0.1% | 43.52 ± 16.7% | 17.22 ± 0.3% | 82.57 ± 0.3% | 2.53 | 2.28 | 31.33 |
| markup: an href attribute | 33 | 1601.45 ± 0.7% | 575.95 ± 0.1% | 27.91 ± 0.3% | 17703.86 ± 3.5% | 2258.70 ± 0.5% | 13.09 ± 0.2% | 73.99 ± 0.9% | 2.78 | 0.09 | 0.71 |
| markup: a heading's start tag | 110 | 1413.65 ± 0.5% | 573.27 ± 0.4% | 27.82 ± 0.2% | 1740.08 ± 0.3% | 1583.12 ± 5.4% | 15.96 ± 0.5% | 85.44 ± 1.1% | 2.47 | 0.81 | 0.89 |
| markup: a number | 8288 | 1736.57 ± 0.1% | 483.68 ± 0.2% | 28.46 ± 0.3% | 2438.85 ± 0.1% | 42.35 ± 4.1% | 0.55 ± 0.2% | 57.32 ± 0.2% | 3.59 | 0.71 | 41.01 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 512 | 19.31 ± 0.3% | 20.45 ± 0.3% | 0.49 ± 0.2% | 18.55 ± 0.2% | 2.71 ± 0.4% | differs | 3.91 ± 0.1% | 0.94 | 1.04 | 7.13 |
| a UUID | 512 | 13.90 ± 0.3% | 14.83 ± 1.3% | 0.66 ± 0.3% | 13.78 ± 0.3% | 3.02 ± 0.2% | 0.73 ± 0.2% | 3.50 ± 0.4% | 0.94 | 1.01 | 4.61 |
| an IPv4 address | 512 | 33.07 ± 0.4% | 33.70 ± 0.2% | 2.14 ± 0.4% | 32.35 ± 0.8% | 6.39 ± 0.2% | differs | 4.08 ± 0.4% | 0.98 | 1.02 | 5.18 |
| a date and time | 512 | 22.12 ± 0.5% | 23.79 ± 0.4% | 1.49 ± 0.2% | 20.95 ± 0.2% | 6.66 ± 0.3% | 1.23 ± 0.1% | 6.84 ± 0.3% | 0.93 | 1.06 | 3.32 |
| a field path | 512 | 23.27 ± 0.5% | 24.43 ± 0.4% | 0.83 ± 0.3% | 23.64 ± 1.5% | 3.43 ± 0.6% | differs | 2.92 ± 0.4% | 0.95 | 0.98 | 6.78 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 512 | 2.50 ± 0.7% | 2.48 ± 0.6% | 1.14 ± 0.2% | 10.00 ± 0.3% | 4.80 ± 3.6% | 0.91 ± 0.5% | none | 1.01 | 0.25 | 0.52 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 242.10 ± 0.3% | 242.23 ± 0.3% | 352.84 ± 0.3% | 87.54 ± 0.6% | 221.37 ± 1.2% | 480.83 ± 4.8% | 3753.16 ± 0.2% | 1.00 | 2.77 | 1.09 |
| a UUID | 62 | 190.45 ± 0.1% | 190.64 ± 0.2% | 254.12 ± 0.2% | 47.02 ± 1.3% | 99.24 ± 1.9% | 191.97 ± 1.8% | 4341.65 ± 0.4% | 1.00 | 4.05 | 1.92 |
| an IPv4 address | 29 | 359.46 ± 1.1% | 360.38 ± 1.2% | 604.64 ± 0.3% | 79.35 ± 0.4% | 131.47 ± 1.4% | 299.15 ± 0.6% | 7529.19 ± 0.6% | 1.00 | 4.53 | 2.73 |
| a date and time | 56 | 241.65 ± 0.3% | 241.54 ± 0.3% | 357.18 ± 0.2% | 74.02 ± 0.3% | 137.15 ± 1.8% | 326.90 ± 2.2% | 4971.09 ± 0.4% | 1.00 | 3.26 | 1.76 |
| a field path | 39 | 246.87 ± 0.3% | 247.18 ± 0.5% | 408.82 ± 0.4% | 81.85 ± 0.9% | 207.44 ± 1.4% | 500.80 ± 7.0% | 4830.75 ± 2.5% | 1.00 | 3.02 | 1.19 |
| prose: a word | 7 | 544.88 ± 1.2% | 549.41 ± 1.8% | 1400.16 ± 0.2% | 530.04 ± 0.3% | 635.14 ± 1.3% | 970.72 ± 0.6% | 30112.24 ± 0.2% | 0.99 | 1.03 | 0.86 |
| prose: a word that is not there | 8 | 563.57 ± 1.5% | 564.87 ± 1.6% | 1318.32 ± 0.2% | 476.35 ± 0.4% | 610.25 ± 1.2% | 914.28 ± 0.6% | 29030.56 ± 0.2% | 1.00 | 1.18 | 0.92 |
| prose: one of four words | 26 | 344.77 ± 0.4% | 344.97 ± 0.7% | 602.52 ± 0.8% | 50.41 ± 0.7% | 243.12 ± 1.5% | 376.51 ± 0.4% | 15679.82 ± 0.1% | 1.00 | 6.84 | 1.42 |
| prose: a word in any case | 11 | 463.91 ± 0.6% | 463.62 ± 0.2% | 1140.07 ± 0.4% | 15.55 ± 0.3% | 653.16 ± 7.8% | refused | 23670.56 ± 0.4% | 1.00 | 29.84 | 0.71 |
| prose: a word between two words | 13 | 409.13 ± 0.2% | 409.53 ± 0.1% | 968.92 ± 0.2% | 137.71 ± 1.2% | 491.90 ± 15.8% | 809.23 ± 1.1% | 14586.11 ± 0.1% | 1.00 | 2.97 | 0.83 |
| prose: two capitalized words | 23 | 321.62 ± 0.7% | 321.59 ± 0.6% | 614.14 ± 0.5% | 103.43 ± 0.1% | 498.24 ± 0.8% | 753.58 ± 2.0% | 6299.84 ± 0.2% | 1.00 | 3.11 | 0.65 |
| prose: a word that ends in ing | 9 | 449.07 ± 0.6% | 449.58 ± 0.6% | 1170.11 ± 0.3% | 136.34 ± 0.8% | 753.97 ± 1.2% | 1092.41 ± 2.0% | 15664.22 ± 0.2% | 1.00 | 3.29 | 0.60 |
| prose: a word in capitals | 16 | 342.73 ± 2.2% | 343.62 ± 0.3% | 798.77 ± 0.1% | 140.57 ± 1.0% | 748.79 ± 1.0% | 1039.57 ± 0.5% | 8284.22 ± 0.1% | 1.00 | 2.44 | 0.46 |
| markup: an href attribute | 12 | 344.09 ± 0.4% | 344.58 ± 0.4% | 543.43 ± 0.2% | 45.72 ± 0.7% | 487.32 ± 25.9% | 776.96 ± 4.6% | 21630.14 ± 0.6% | 1.00 | 7.53 | 0.71 |
| markup: a heading's start tag | 13 | 328.87 ± 0.7% | 329.44 ± 0.7% | 521.66 ± 0.5% | 43.35 ± 0.6% | 624.60 ± 2.1% | 841.83 ± 0.5% | 17987.81 ± 0.1% | 1.00 | 7.59 | 0.53 |
| markup: a number | 6 | 418.59 ± 0.6% | 418.77 ± 0.4% | 1378.30 ± 0.2% | 41.87 ± 0.7% | 1387.73 ± 1.5% | 1870.13 ± 1.4% | 22702.42 ± 0.4% | 1.00 | 10.00 | 0.30 |

