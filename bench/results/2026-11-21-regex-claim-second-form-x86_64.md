# bench-regex

| Field | Value |
|---|---|
| Commit | 4ce909a |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
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
| prose: a word | 217 | 5536.73 ± 1.2% | 614.20 ± 1.7% | 38.80 ± 2.7% | 33610.21 ± 21.7% | 14101.72 ± 3.2% | 13.55 ± 1.4% | 137.35 ± 6.2% | 9.01 | 0.16 | 0.39 |
| prose: a word that is not there | 0 | 5613.79 ± 1.4% | 619.72 ± 0.8% | 38.93 ± 1.9% | 46031.06 ± 1.4% | 48428.34 ± 0.7% | 13.09 ± 0.9% | 127.70 ± 2.6% | 9.06 | 0.12 | 0.12 |
| prose: one of four words | 661 | 2557.84 ± 22.4% | 605.69 ± 17.8% | 21.06 ± 17.6% | 12557.20 ± 17.3% | 33.00 ± 17.8% | 4.38 ± 17.8% | 11.22 ± 23.9% | 4.22 | 0.20 | 77.51 |
| prose: a word in any case | 217 | 3824.61 ± 2.0% | 743.17 ± 0.1% | 34.06 ± 0.3% | 16100.86 ± 0.3% | 76.07 ± 0.6% | refused | differs | 5.15 | 0.24 | 50.28 |
| prose: a word between two words | 6104 | 598.57 ± 1.1% | 598.25 ± 1.1% | 37.79 ± 1.0% | 1256.02 ± 0.6% | 175.58 ± 21.1% | 10.65 ± 1.5% | 116.52 ± 3.2% | 1.00 | 0.48 | 3.41 |
| prose: two capitalized words | 1331 | 1158.31 ± 3.0% | 708.22 ± 0.4% | 43.24 ± 0.6% | 734.44 ± 0.4% | 64.02 ± 4.9% | 14.22 ± 5.6% | 109.05 ± 3.6% | 1.64 | 1.58 | 18.09 |
| prose: a word that ends in ing | 3399 | 661.57 ± 1.3% | 666.89 ± 0.7% | 30.12 ± 1.1% | 724.19 ± 1.0% | 47.95 ± 1.8% | 8.21 ± 0.6% | 30.28 ± 5.5% | 0.99 | 0.91 | 13.80 |
| prose: a word in capitals | 2332 | 1608.82 ± 38.3% | 688.45 ± 49.3% | 44.80 ± 22.7% | 723.24 ± 40.5% | 67.57 ± 23.8% | 17.17 ± 0.4% | 142.34 ± 12.6% | 2.34 | 2.22 | 23.81 |
| markup: an href attribute | 33 | 1931.16 ± 39.0% | 741.40 ± 1.3% | 40.29 ± 6.5% | 42362.97 ± 3.8% | 3674.49 ± 7.8% | 11.54 ± 4.0% | 137.08 ± 8.6% | 2.60 | 0.05 | 0.53 |
| markup: a heading's start tag | 110 | 1837.37 ± 5.3% | 742.09 ± 19.1% | 42.94 ± 4.8% | 3513.76 ± 17.3% | 2649.88 ± 12.2% | 14.80 ± 3.5% | 165.32 ± 2.9% | 2.48 | 0.52 | 0.69 |
| markup: a number | 8288 | 2406.00 ± 2.4% | 618.81 ± 4.6% | 44.55 ± 0.8% | 3560.68 ± 0.8% | 59.00 ± 19.2% | 0.47 ± 0.9% | 99.36 ± 3.5% | 3.89 | 0.68 | 40.78 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 512 | 33.84 ± 1.6% | 34.05 ± 0.9% | 0.90 ± 1.5% | 36.61 ± 4.7% | 3.96 ± 2.6% | differs | 5.85 ± 3.0% | 0.99 | 0.92 | 8.54 |
| a UUID | 512 | 24.30 ± 1.3% | 24.04 ± 2.0% | 1.09 ± 0.4% | 20.37 ± 2.9% | 3.86 ± 1.7% | 0.78 ± 0.5% | 4.87 ± 2.8% | 1.01 | 1.19 | 6.30 |
| an IPv4 address | 512 | 57.27 ± 0.8% | 58.25 ± 2.7% | 3.57 ± 1.4% | 67.64 ± 0.6% | 9.48 ± 2.2% | differs | 6.05 ± 1.6% | 0.98 | 0.85 | 6.04 |
| a date and time | 512 | 39.73 ± 3.8% | 40.30 ± 12.9% | 2.59 ± 2.4% | 38.11 ± 1.5% | 11.32 ± 2.3% | 1.36 ± 3.8% | 10.21 ± 12.2% | 0.99 | 1.04 | 3.51 |
| a field path | 512 | 22.10 ± 65.3% | 22.94 ± 58.4% | 0.83 ± 69.8% | 34.72 ± 89.2% | 3.14 ± 77.3% | differs | 2.37 ± 52.9% | 0.96 | 0.64 | 7.04 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 512 | 3.48 ± 39.0% | 3.51 ± 1.7% | 1.68 ± 0.6% | 17.23 ± 0.9% | 7.91 ± 8.2% | 1.11 ± 0.9% | none | 0.99 | 0.20 | 0.44 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 418.21 ± 2.9% | 419.17 ± 5.6% | 556.83 ± 6.6% | 145.39 ± 2.3% | 342.99 ± 2.1% | 941.88 ± 2.7% | 6138.92 ± 0.9% | 1.00 | 2.88 | 1.22 |
| a UUID | 62 | 300.54 ± 4.4% | 298.94 ± 4.3% | 379.94 ± 4.8% | 79.44 ± 2.2% | 168.31 ± 1.6% | 330.60 ± 3.0% | 7625.57 ± 0.4% | 1.01 | 3.78 | 1.79 |
| an IPv4 address | 29 | 600.02 ± 0.4% | 601.26 ± 2.0% | 1002.17 ± 1.3% | 128.53 ± 0.9% | 216.00 ± 2.1% | 590.68 ± 0.6% | 13648.48 ± 1.0% | 1.00 | 4.67 | 2.78 |
| a date and time | 56 | 430.22 ± 2.5% | 432.07 ± 0.7% | 589.34 ± 1.4% | 121.31 ± 0.7% | 233.39 ± 0.4% | 600.31 ± 0.6% | 8539.58 ± 4.2% | 1.00 | 3.55 | 1.84 |
| a field path | 39 | 452.31 ± 2.5% | 452.00 ± 3.7% | 649.32 ± 4.0% | 138.09 ± 5.6% | 323.15 ± 6.7% | 969.48 ± 0.9% | 7884.40 ± 0.9% | 1.00 | 3.28 | 1.40 |
| prose: a word | 7 | 893.31 ± 1.8% | 896.01 ± 4.5% | 2382.94 ± 1.8% | 943.31 ± 1.9% | 1059.81 ± 0.8% | 1947.80 ± 0.3% | 49995.46 ± 1.5% | 1.00 | 0.95 | 0.84 |
| prose: a word that is not there | 8 | 948.95 ± 0.8% | 948.26 ± 1.2% | 2237.37 ± 2.5% | 863.77 ± 0.8% | 1035.71 ± 0.6% | 1814.13 ± 0.3% | 48915.50 ± 0.2% | 1.00 | 1.10 | 0.92 |
| prose: one of four words | 26 | 639.82 ± 1.3% | 640.99 ± 0.4% | 1003.22 ± 1.1% | 75.83 ± 1.8% | 411.04 ± 1.4% | 672.35 ± 0.4% | 28944.60 ± 4.3% | 1.00 | 8.44 | 1.56 |
| prose: a word in any case | 11 | 936.38 ± 0.5% | 936.37 ± 1.0% | 2054.72 ± 2.3% | 25.35 ± 0.9% | 1126.03 ± 1.1% | refused | 40564.02 ± 0.8% | 1.00 | 36.93 | 0.83 |
| prose: a word between two words | 13 | 807.19 ± 4.5% | 807.89 ± 1.6% | 1678.29 ± 2.3% | 228.35 ± 5.1% | 800.07 ± 2.8% | 1611.12 ± 1.9% | 24917.44 ± 3.1% | 1.00 | 3.53 | 1.01 |
| prose: two capitalized words | 23 | 564.84 ± 1.6% | 566.01 ± 1.3% | 1009.12 ± 2.2% | 170.96 ± 0.2% | 849.65 ± 2.7% | 1506.56 ± 0.6% | 10074.86 ± 0.2% | 1.00 | 3.30 | 0.66 |
| prose: a word that ends in ing | 9 | 807.61 ± 1.6% | 809.36 ± 1.3% | 2000.87 ± 4.5% | 217.48 ± 46.6% | 1163.86 ± 50.1% | 2333.63 ± 1.2% | 26411.21 ± 2.5% | 1.00 | 3.71 | 0.69 |
| prose: a word in capitals | 16 | 615.02 ± 1.7% | 616.54 ± 8.6% | 1376.04 ± 6.7% | 221.62 ± 4.1% | 1238.92 ± 1.4% | 2126.94 ± 2.2% | 13087.24 ± 0.3% | 1.00 | 2.78 | 0.50 |
| markup: an href attribute | 12 | 609.42 ± 1.4% | 616.39 ± 1.3% | 930.47 ± 1.9% | 64.05 ± 1.2% | 782.56 ± 2.5% | 1571.91 ± 2.9% | 35694.00 ± 0.8% | 0.99 | 9.51 | 0.78 |
| markup: a heading's start tag | 13 | 582.90 ± 2.8% | 583.37 ± 9.6% | 889.89 ± 10.8% | 60.77 ± 2.8% | 966.69 ± 2.2% | 1719.17 ± 4.1% | 29752.18 ± 4.1% | 1.00 | 9.59 | 0.60 |
| markup: a number | 6 | 767.74 ± 2.7% | 768.86 ± 3.2% | 2368.34 ± 6.1% | 63.82 ± 4.5% | 2281.33 ± 1.1% | 3868.90 ± 0.7% | 36479.65 ± 0.4% | 1.00 | 12.03 | 0.34 |

