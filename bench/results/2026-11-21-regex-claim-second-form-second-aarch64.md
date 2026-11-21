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
| Run URL | https://github.com/c4milo/stdx/actions/runs/44945335519 |
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
| prose: a word | 217 | 5224.70 ± 0.3% | 573.91 ± 0.3% | 28.87 ± 0.2% | 18414.58 ± 2.0% | 9209.54 ± 8.9% | 17.25 ± 0.4% | 84.23 ± 0.7% | 9.10 | 0.28 | 0.57 |
| prose: a word that is not there | 0 | 5373.90 ± 0.9% | 576.17 ± 0.2% | 28.99 ± 0.2% | 19733.60 ± 3.0% | 29314.94 ± 2.9% | 17.02 ± 0.7% | 79.27 ± 0.9% | 9.33 | 0.27 | 0.18 |
| prose: one of four words | 661 | 2395.08 ± 1.3% | 565.69 ± 0.6% | 15.17 ± 0.1% | 3987.11 ± 0.2% | 21.88 ± 0.2% | 5.36 ± 0.3% | 6.87 ± 0.4% | 4.23 | 0.60 | 109.48 |
| prose: a word in any case | 217 | 2656.91 ± 1.9% | 574.01 ± 0.1% | 21.95 ± 0.1% | 4069.94 ± 0.5% | 37.96 ± 0.4% | refused | differs | 4.63 | 0.65 | 69.99 |
| prose: a word between two words | 6104 | 473.13 ± 0.2% | 472.94 ± 0.2% | 23.91 ± 0.4% | 910.35 ± 0.2% | 109.16 ± 11.6% | 11.27 ± 0.4% | 68.37 ± 0.7% | 1.00 | 0.52 | 4.33 |
| prose: two capitalized words | 1331 | 1118.60 ± 0.4% | 549.47 ± 0.1% | 26.78 ± 0.1% | 600.15 ± 0.1% | 40.76 ± 0.2% | 14.78 ± 0.4% | 67.48 ± 0.2% | 2.04 | 1.86 | 27.44 |
| prose: a word that ends in ing | 3399 | 515.75 ± 0.1% | 516.18 ± 0.1% | 18.52 ± 0.2% | 586.38 ± 0.1% | 29.32 ± 12.1% | 8.15 ± 0.1% | 18.40 ± 0.1% | 1.00 | 0.88 | 17.59 |
| prose: a word in capitals | 2332 | 1413.08 ± 0.3% | 541.35 ± 0.4% | 28.17 ± 0.5% | 597.49 ± 0.1% | 43.52 ± 17.2% | 17.18 ± 0.3% | 82.62 ± 0.2% | 2.61 | 2.37 | 32.47 |
| markup: an href attribute | 33 | 1606.74 ± 0.7% | 576.66 ± 0.4% | 27.83 ± 0.3% | 17639.23 ± 3.8% | 2256.33 ± 0.4% | 13.10 ± 0.1% | 74.05 ± 0.2% | 2.79 | 0.09 | 0.71 |
| markup: a heading's start tag | 110 | 1419.91 ± 0.4% | 574.05 ± 1.0% | 27.79 ± 0.3% | 1742.58 ± 0.2% | 1585.54 ± 5.2% | 15.91 ± 0.3% | 86.19 ± 0.3% | 2.47 | 0.81 | 0.90 |
| markup: a number | 8288 | 1717.37 ± 0.1% | 483.50 ± 0.1% | 28.41 ± 0.2% | 2434.60 ± 0.2% | 42.61 ± 13.1% | 0.55 ± 0.2% | 57.33 ± 0.2% | 3.55 | 0.71 | 40.31 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 512 | 19.27 ± 0.2% | 20.47 ± 0.3% | 0.48 ± 0.1% | 18.60 ± 0.6% | 2.70 ± 0.7% | differs | 3.90 ± 0.1% | 0.94 | 1.04 | 7.14 |
| a UUID | 512 | 13.89 ± 0.4% | 14.75 ± 0.5% | 0.66 ± 0.2% | 13.76 ± 0.1% | 3.02 ± 0.7% | 0.73 ± 0.4% | 3.49 ± 0.7% | 0.94 | 1.01 | 4.59 |
| an IPv4 address | 512 | 32.98 ± 0.6% | 33.68 ± 0.5% | 2.17 ± 0.1% | 32.50 ± 1.1% | 6.38 ± 0.2% | differs | 4.09 ± 0.3% | 0.98 | 1.01 | 5.17 |
| a date and time | 512 | 22.13 ± 0.2% | 23.76 ± 0.6% | 1.49 ± 0.2% | 20.97 ± 0.1% | 6.69 ± 0.1% | 1.22 ± 0.1% | 6.85 ± 0.4% | 0.93 | 1.06 | 3.31 |
| a field path | 512 | 23.28 ± 0.3% | 24.43 ± 0.5% | 0.83 ± 0.2% | 23.60 ± 1.3% | 3.46 ± 0.3% | differs | 2.91 ± 0.1% | 0.95 | 0.99 | 6.73 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 512 | 2.50 ± 0.4% | 2.48 ± 0.4% | 1.14 ± 0.1% | 10.00 ± 0.2% | 4.75 ± 3.8% | 0.92 ± 0.2% | none | 1.01 | 0.25 | 0.53 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 242.65 ± 0.1% | 243.01 ± 0.2% | 353.05 ± 0.1% | 87.50 ± 0.5% | 220.98 ± 1.4% | 479.41 ± 4.4% | 3748.26 ± 0.2% | 1.00 | 2.77 | 1.10 |
| a UUID | 62 | 189.90 ± 0.3% | 190.46 ± 0.3% | 253.12 ± 0.3% | 46.72 ± 1.4% | 98.69 ± 1.1% | 191.97 ± 1.9% | 4338.86 ± 0.3% | 1.00 | 4.06 | 1.92 |
| an IPv4 address | 29 | 359.67 ± 0.8% | 361.72 ± 0.5% | 604.91 ± 0.3% | 78.57 ± 0.3% | 130.24 ± 2.4% | 297.66 ± 0.7% | 7537.41 ± 0.7% | 0.99 | 4.58 | 2.76 |
| a date and time | 56 | 240.94 ± 0.2% | 241.40 ± 0.2% | 356.58 ± 0.2% | 73.14 ± 0.6% | 135.82 ± 1.7% | 329.61 ± 2.7% | 4974.08 ± 0.7% | 1.00 | 3.29 | 1.77 |
| a field path | 39 | 247.04 ± 0.4% | 247.37 ± 0.2% | 409.19 ± 0.3% | 80.81 ± 1.7% | 206.35 ± 0.9% | 508.33 ± 5.2% | 4835.37 ± 3.4% | 1.00 | 3.06 | 1.20 |
| prose: a word | 7 | 548.61 ± 1.6% | 549.30 ± 1.5% | 1401.11 ± 0.6% | 530.79 ± 0.2% | 629.85 ± 1.0% | 949.00 ± 1.1% | 30157.67 ± 0.1% | 1.00 | 1.03 | 0.87 |
| prose: a word that is not there | 8 | 563.03 ± 0.6% | 563.36 ± 0.7% | 1317.96 ± 0.2% | 475.92 ± 0.2% | 605.39 ± 1.3% | 896.83 ± 0.3% | 29024.64 ± 0.8% | 1.00 | 1.18 | 0.93 |
| prose: one of four words | 26 | 344.93 ± 0.3% | 345.76 ± 0.3% | 603.49 ± 0.2% | 50.14 ± 0.9% | 238.52 ± 1.7% | 377.07 ± 1.5% | 15628.86 ± 0.1% | 1.00 | 6.88 | 1.45 |
| prose: a word in any case | 11 | 465.14 ± 0.6% | 465.07 ± 1.0% | 1140.13 ± 0.2% | 15.51 ± 0.3% | 643.37 ± 1.4% | refused | 23713.75 ± 0.4% | 1.00 | 29.99 | 0.72 |
| prose: a word between two words | 13 | 409.21 ± 0.1% | 410.08 ± 0.5% | 968.44 ± 0.2% | 135.87 ± 1.0% | 500.67 ± 2.1% | 803.92 ± 1.1% | 14578.99 ± 0.2% | 1.00 | 3.01 | 0.82 |
| prose: two capitalized words | 23 | 320.95 ± 0.9% | 321.47 ± 0.3% | 614.37 ± 0.8% | 100.87 ± 0.2% | 501.36 ± 2.0% | 784.90 ± 0.1% | 6305.00 ± 0.1% | 1.00 | 3.18 | 0.64 |
| prose: a word that ends in ing | 9 | 448.23 ± 0.8% | 448.32 ± 0.7% | 1167.41 ± 0.4% | 135.37 ± 0.4% | 760.01 ± 2.4% | 1145.89 ± 0.9% | 15673.20 ± 0.2% | 1.00 | 3.31 | 0.59 |
| prose: a word in capitals | 16 | 341.26 ± 0.7% | 342.67 ± 0.4% | 798.13 ± 0.1% | 139.64 ± 1.1% | 755.30 ± 1.6% | 1052.62 ± 0.4% | 8283.21 ± 0.2% | 1.00 | 2.44 | 0.45 |
| markup: an href attribute | 12 | 343.43 ± 0.6% | 344.49 ± 0.2% | 544.23 ± 0.2% | 43.60 ± 0.7% | 501.87 ± 2.3% | 771.42 ± 0.4% | 21678.78 ± 1.0% | 1.00 | 7.88 | 0.68 |
| markup: a heading's start tag | 13 | 327.29 ± 1.4% | 327.87 ± 0.8% | 521.16 ± 0.5% | 12.24 ± 26.8% | 628.43 ± 2.4% | 864.69 ± 0.3% | 18022.68 ± 0.1% | 1.00 | 26.73 | 0.52 |
| markup: a number | 6 | 421.08 ± 0.9% | 421.11 ± 0.7% | 1377.30 ± 0.3% | 41.65 ± 0.8% | 1397.62 ± 0.7% | 1876.39 ± 1.0% | 22736.19 ± 0.2% | 1.00 | 10.11 | 0.30 |

