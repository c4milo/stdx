# bench-regex

| Field | Value |
|---|---|
| Commit | 4354b93 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44939231333 |
| Date | 2026-11-21 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

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

| Pattern | Matches | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| prose: a word | 217 | 573.99 ± 0.6% | 28.46 ± 0.7% | 18569.20 ± 2.0% | 9242.09 ± 5.6% | 17.42 ± 0.6% | 86.50 ± 0.2% | 0.03 | 0.06 |
| prose: a word that is not there | 0 | 576.16 ± 0.3% | 28.79 ± 0.3% | 19864.16 ± 2.2% | 28428.56 ± 1.4% | 17.27 ± 0.1% | 83.57 ± 0.4% | 0.03 | 0.02 |
| prose: one of four words | 661 | 568.73 ± 0.2% | 14.76 ± 1.8% | 3989.95 ± 0.2% | 21.89 ± 0.1% | 5.36 ± 0.3% | 6.72 ± 0.2% | 0.14 | 25.98 |
| prose: a word in any case | 217 | 573.01 ± 0.2% | 21.89 ± 0.3% | 4064.37 ± 0.3% | 38.02 ± 0.4% | refused | differs | 0.14 | 15.07 |
| prose: a word between two words | 6104 | 482.62 ± 0.1% | 23.66 ± 0.5% | 912.81 ± 0.2% | 104.36 ± 8.7% | 11.34 ± 0.3% | 70.28 ± 0.4% | 0.53 | 4.62 |
| prose: two capitalized words | 1331 | 552.53 ± 0.1% | 26.36 ± 0.4% | 600.21 ± 0.2% | 40.70 ± 3.8% | 14.88 ± 0.1% | 69.27 ± 0.3% | 0.92 | 13.58 |
| prose: a word that ends in ing | 3399 | 525.01 ± 0.2% | 18.47 ± 1.2% | 586.51 ± 0.2% | 29.53 ± 3.4% | 8.16 ± 0.1% | 18.46 ± 0.5% | 0.90 | 17.78 |
| prose: a word in capitals | 2332 | 551.15 ± 0.1% | 27.96 ± 0.2% | 597.46 ± 0.0% | 43.47 ± 0.2% | 17.13 ± 0.2% | 83.89 ± 0.4% | 0.92 | 12.68 |
| markup: an href attribute | 33 | 576.32 ± 0.3% | 27.69 ± 0.2% | 17824.08 ± 2.1% | 2252.55 ± 1.4% | 13.30 ± 0.4% | 76.23 ± 0.2% | 0.03 | 0.26 |
| markup: a heading's start tag | 110 | 572.67 ± 0.1% | 27.45 ± 0.2% | 1742.62 ± 0.4% | 1583.04 ± 6.3% | 16.22 ± 0.5% | 90.09 ± 0.4% | 0.33 | 0.36 |
| markup: a number | 8288 | 505.19 ± 0.1% | 28.14 ± 0.3% | 2436.59 ± 0.2% | 41.28 ± 15.8% | 0.56 ± 0.1% | 57.44 ± 0.5% | 0.21 | 12.24 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| an email address | 512 | 21.82 ± 0.6% | 0.49 ± 0.2% | 18.63 ± 0.2% | 2.70 ± 0.7% | differs | 3.90 ± 0.2% | 1.17 | 8.07 |
| a UUID | 512 | 14.70 ± 0.3% | 0.66 ± 0.1% | 13.74 ± 0.1% | 3.00 ± 0.5% | 0.72 ± 0.1% | 3.50 ± 0.5% | 1.07 | 4.90 |
| an IPv4 address | 512 | 38.30 ± 0.1% | 2.18 ± 0.2% | 32.23 ± 0.2% | 6.40 ± 0.2% | differs | 4.05 ± 0.2% | 1.19 | 5.99 |
| a date and time | 512 | 25.82 ± 0.6% | 1.52 ± 0.2% | 20.96 ± 0.2% | 6.66 ± 0.5% | 1.23 ± 0.4% | 6.63 ± 0.8% | 1.23 | 3.88 |
| a field path | 512 | 27.10 ± 0.7% | 0.83 ± 0.3% | 23.77 ± 1.6% | 3.44 ± 0.4% | differs | 2.95 ± 0.2% | 1.14 | 7.89 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 512 | 2.54 ± 1.1% | 1.13 ± 0.1% | 10.02 ± 0.2% | 4.88 ± 4.5% | 0.92 ± 0.6% | none | 0.25 | 0.52 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 242.04 ± 0.3% | 347.29 ± 0.3% | 87.15 ± 0.6% | 222.69 ± 9.1% | 478.52 ± 4.5% | 3850.99 ± 0.6% | 2.78 | 1.09 |
| a UUID | 62 | 184.52 ± 0.2% | 251.42 ± 0.5% | 46.76 ± 1.4% | 100.16 ± 1.0% | 195.25 ± 1.2% | 4359.89 ± 0.6% | 3.95 | 1.84 |
| an IPv4 address | 29 | 306.55 ± 0.4% | 592.74 ± 0.6% | 78.10 ± 0.2% | 131.77 ± 1.9% | 300.32 ± 0.8% | 7723.48 ± 0.3% | 3.93 | 2.33 |
| a date and time | 56 | 248.20 ± 1.1% | 350.77 ± 0.2% | 73.13 ± 0.4% | 137.66 ± 1.1% | 330.56 ± 2.0% | 4860.66 ± 0.3% | 3.39 | 1.80 |
| a field path | 39 | 279.42 ± 0.8% | 404.16 ± 0.1% | 80.68 ± 1.5% | 209.27 ± 1.7% | 503.17 ± 5.8% | 4924.38 ± 3.4% | 3.46 | 1.34 |
| prose: a word | 7 | 542.70 ± 2.9% | 1373.79 ± 0.1% | 525.24 ± 0.1% | 634.58 ± 0.8% | 946.84 ± 1.0% | 30394.03 ± 0.2% | 1.03 | 0.86 |
| prose: a word that is not there | 8 | 567.88 ± 1.6% | 1293.78 ± 0.1% | 473.56 ± 0.1% | 613.60 ± 0.6% | 895.43 ± 0.5% | 28609.08 ± 0.2% | 1.20 | 0.93 |
| prose: one of four words | 26 | 366.46 ± 0.6% | 594.97 ± 0.6% | 50.18 ± 0.5% | 245.46 ± 1.8% | 372.62 ± 1.5% | 16005.95 ± 0.2% | 7.30 | 1.49 |
| prose: a word in any case | 11 | 468.31 ± 0.9% | 1103.63 ± 0.2% | 15.51 ± 0.3% | 665.54 ± 2.4% | refused | 23432.68 ± 0.3% | 30.19 | 0.70 |
| prose: a word between two words | 13 | 441.80 ± 0.6% | 949.76 ± 0.1% | 134.82 ± 1.2% | 509.51 ± 1.0% | 798.39 ± 0.9% | 14743.84 ± 0.1% | 3.28 | 0.87 |
| prose: two capitalized words | 23 | 302.94 ± 0.4% | 603.45 ± 0.3% | 100.66 ± 0.2% | 515.01 ± 1.3% | 781.42 ± 1.1% | 6508.76 ± 0.6% | 3.01 | 0.59 |
| prose: a word that ends in ing | 9 | 418.19 ± 0.9% | 1153.11 ± 0.3% | 134.76 ± 0.3% | 767.60 ± 0.9% | 1157.99 ± 0.4% | 15996.21 ± 0.2% | 3.10 | 0.54 |
| prose: a word in capitals | 16 | 340.59 ± 1.1% | 792.28 ± 0.1% | 138.64 ± 1.3% | 764.25 ± 1.3% | 1054.38 ± 0.7% | 8535.84 ± 0.7% | 2.46 | 0.45 |
| markup: an href attribute | 12 | 354.51 ± 0.7% | 534.38 ± 0.8% | 44.12 ± 0.6% | 503.07 ± 22.8% | 770.05 ± 1.3% | 21668.09 ± 0.2% | 8.04 | 0.70 |
| markup: a heading's start tag | 13 | 344.12 ± 1.2% | 517.72 ± 0.4% | 41.96 ± 0.1% | 640.80 ± 1.0% | 869.92 ± 0.6% | 18391.10 ± 0.1% | 8.20 | 0.54 |
| markup: a number | 6 | 378.97 ± 0.5% | 1356.66 ± 0.2% | 41.77 ± 0.7% | 1412.95 ± 0.6% | 1925.38 ± 0.4% | 22862.82 ± 0.2% | 9.07 | 0.27 |

