# bench-regex

| Field | Value |
|---|---|
| Commit | 4354b93 |
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
| prose: a word | 217 | 743.50 ± 0.4% | 46.84 ± 1.4% | 42691.59 ± 1.8% | 16906.67 ± 4.9% | 16.84 ± 0.6% | 166.83 ± 1.3% | 0.02 | 0.04 |
| prose: a word that is not there | 0 | 747.97 ± 0.3% | 46.76 ± 0.7% | 56299.83 ± 2.5% | 57524.38 ± 0.4% | 16.42 ± 0.3% | 152.86 ± 1.1% | 0.01 | 0.01 |
| prose: one of four words | 661 | 734.24 ± 4.7% | 26.20 ± 0.3% | 15149.29 ± 0.2% | 39.62 ± 0.4% | 5.25 ± 2.4% | 13.95 ± 3.6% | 0.05 | 18.53 |
| prose: a word in any case | 217 | 743.48 ± 0.3% | 34.27 ± 0.5% | 16114.84 ± 0.5% | 75.94 ± 3.3% | refused | differs | 0.05 | 9.79 |
| prose: a word between two words | 6104 | 602.22 ± 1.2% | 37.23 ± 0.3% | 1262.01 ± 1.2% | 187.00 ± 3.3% | 10.88 ± 2.0% | 118.61 ± 2.1% | 0.48 | 3.22 |
| prose: two capitalized words | 1331 | 713.45 ± 25.1% | 41.12 ± 0.9% | 734.60 ± 0.3% | 64.65 ± 6.8% | 14.39 ± 3.6% | 109.53 ± 1.9% | 0.97 | 11.04 |
| prose: a word that ends in ing | 3399 | 674.04 ± 0.2% | 29.87 ± 1.3% | 722.72 ± 0.5% | 47.98 ± 3.3% | 8.20 ± 1.8% | 31.03 ± 3.0% | 0.93 | 14.05 |
| prose: a word in capitals | 2332 | 703.77 ± 1.4% | 44.50 ± 0.5% | 723.72 ± 0.3% | 69.79 ± 24.5% | 17.44 ± 1.2% | 141.97 ± 1.9% | 0.97 | 10.08 |
| markup: an href attribute | 33 | 746.87 ± 0.0% | 40.08 ± 0.4% | 44083.23 ± 2.9% | 3712.61 ± 3.3% | 11.98 ± 0.2% | 138.21 ± 4.0% | 0.02 | 0.20 |
| markup: a heading's start tag | 110 | 742.72 ± 0.1% | 42.84 ± 0.9% | 3552.61 ± 0.2% | 2651.48 ± 8.2% | 14.83 ± 1.5% | 171.36 ± 4.0% | 0.21 | 0.28 |
| markup: a number | 8288 | 639.41 ± 0.4% | 41.98 ± 3.2% | 3506.26 ± 2.5% | 62.82 ± 24.1% | 0.47 ± 0.3% | 101.83 ± 0.7% | 0.18 | 10.18 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| an email address | 512 | 37.67 ± 1.7% | 0.92 ± 0.4% | 36.87 ± 2.0% | 3.70 ± 0.7% | differs | 5.95 ± 5.9% | 1.02 | 10.17 |
| a UUID | 512 | 25.64 ± 117.3% | 1.06 ± 118.3% | 20.75 ± 21.4% | 3.83 ± 27.9% | 0.77 ± 95.8% | 4.84 ± 114.1% | 1.24 | 6.69 |
| an IPv4 address | 512 | 70.44 ± 7.4% | 3.62 ± 2.9% | 70.36 ± 4.8% | 9.49 ± 12.0% | differs | 6.02 ± 2.4% | 1.00 | 7.42 |
| a date and time | 512 | 46.23 ± 1.0% | 2.58 ± 0.5% | 39.11 ± 3.3% | 11.24 ± 6.8% | 1.35 ± 1.5% | 12.30 ± 2.4% | 1.18 | 4.11 |
| a field path | 512 | 48.75 ± 2.4% | 1.52 ± 2.5% | 47.03 ± 3.3% | 4.81 ± 8.1% | differs | 4.49 ± 3.3% | 1.04 | 10.14 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 512 | 3.47 ± 2.1% | 1.67 ± 2.1% | 16.76 ± 5.8% | 7.78 ± 8.8% | 1.10 ± 3.1% | none | 0.21 | 0.45 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 430.02 ± 3.3% | 565.56 ± 5.5% | 144.36 ± 4.9% | 348.77 ± 1.6% | 942.68 ± 3.5% | 5911.79 ± 1.6% | 2.98 | 1.23 |
| a UUID | 62 | 307.70 ± 1.5% | 388.29 ± 0.9% | 78.55 ± 2.7% | 170.93 ± 1.3% | 331.15 ± 1.9% | 7236.42 ± 3.1% | 3.92 | 1.80 |
| an IPv4 address | 29 | 612.24 ± 1.9% | 1016.77 ± 1.7% | 128.29 ± 1.1% | 217.41 ± 0.7% | 590.40 ± 0.7% | 13390.90 ± 0.4% | 4.77 | 2.82 |
| a date and time | 56 | 441.37 ± 0.9% | 593.75 ± 1.7% | 120.58 ± 1.3% | 235.97 ± 2.5% | 607.46 ± 2.0% | 7657.55 ± 1.7% | 3.66 | 1.87 |
| a field path | 39 | 457.33 ± 0.8% | 647.59 ± 1.2% | 132.02 ± 1.2% | 331.37 ± 2.6% | 964.75 ± 1.8% | 7714.67 ± 6.5% | 3.46 | 1.38 |
| prose: a word | 7 | 941.75 ± 0.9% | 2581.35 ± 1.7% | 914.90 ± 1.8% | 1089.77 ± 1.7% | 1919.41 ± 0.5% | 49864.21 ± 3.3% | 1.03 | 0.86 |
| prose: a word that is not there | 8 | 1010.71 ± 2.0% | 2403.22 ± 3.5% | 862.47 ± 1.5% | 1041.84 ± 2.4% | 1795.94 ± 2.2% | 49014.62 ± 1.1% | 1.17 | 0.97 |
| prose: one of four words | 26 | 658.87 ± 1.7% | 1025.97 ± 2.0% | 75.86 ± 1.3% | 419.80 ± 0.5% | 666.10 ± 1.1% | 24877.35 ± 2.7% | 8.69 | 1.57 |
| prose: a word in any case | 11 | 972.31 ± 2.8% | 2154.07 ± 3.2% | 24.89 ± 1.8% | 1151.35 ± 2.2% | refused | 37749.09 ± 2.3% | 39.06 | 0.84 |
| prose: a word between two words | 13 | 832.12 ± 1.3% | 1746.24 ± 1.7% | 226.15 ± 1.7% | 806.58 ± 1.7% | 1582.47 ± 0.4% | 24633.28 ± 2.2% | 3.68 | 1.03 |
| prose: two capitalized words | 23 | 600.81 ± 8.2% | 1076.73 ± 56.7% | 163.90 ± 13.6% | 856.21 ± 2.3% | 1470.37 ± 0.3% | 10266.57 ± 2.9% | 3.67 | 0.70 |
| prose: a word that ends in ing | 9 | 833.37 ± 2.7% | 2081.05 ± 7.5% | 214.63 ± 56.5% | 1164.15 ± 9.7% | 2278.01 ± 0.9% | 26576.85 ± 2.2% | 3.88 | 0.72 |
| prose: a word in capitals | 16 | 630.77 ± 0.9% | 1396.53 ± 1.2% | 217.86 ± 1.8% | 1247.14 ± 0.7% | 2095.73 ± 26.9% | 13256.62 ± 32.5% | 2.90 | 0.51 |
| markup: an href attribute | 12 | 627.92 ± 3.4% | 948.65 ± 2.3% | 64.16 ± 3.7% | 805.18 ± 3.7% | 1586.16 ± 1.4% | 35303.61 ± 24.3% | 9.79 | 0.78 |
| markup: a heading's start tag | 13 | 604.36 ± 7.8% | 901.92 ± 6.1% | 61.24 ± 6.9% | 964.18 ± 7.5% | 1720.65 ± 3.9% | 30508.01 ± 3.6% | 9.87 | 0.63 |
| markup: a number | 6 | 749.54 ± 7.8% | 2435.73 ± 6.2% | 64.01 ± 1.6% | 2266.88 ± 4.1% | 3872.76 ± 1.8% | 36792.06 ± 5.5% | 11.71 | 0.33 |

