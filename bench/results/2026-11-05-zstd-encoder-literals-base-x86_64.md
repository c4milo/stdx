# bench-zstd

| Field | Value |
|---|---|
| Commit | 10fa46b |
| Runner label | ubuntu-24.04 |
| Image version | 20261026.354.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/41962193660 |
| Date | 2026-11-05 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 657.6 ±1.4% | 841.8 ±3.8% | 1.28 |
| silesia/mozilla | 51220480 | 35.6 | 800.5 ±1.7% | 978.9 ±3.6% | 1.22 |
| silesia/mr | 9970564 | 35.6 | 759.3 ±0.5% | 977.3 ±1.9% | 1.29 |
| silesia/nci | 33553445 | 8.4 | 1484.7 ±4.3% | 1798.9 ±7.1% | 1.21 |
| silesia/ooffice | 6152192 | 50.8 | 687.7 ±0.2% | 845.1 ±0.3% | 1.23 |
| silesia/osdb | 10085684 | 34.7 | 1035.5 ±1.2% | 1220.2 ±1.1% | 1.18 |
| silesia/reymont | 6627202 | 29.2 | 764.4 ±6.8% | 966.4 ±5.5% | 1.26 |
| silesia/samba | 21606400 | 22.9 | 1158.5 ±4.7% | 1371.3 ±1.9% | 1.18 |
| silesia/sao | 7251944 | 76.2 | 639.2 ±0.9% | 793.5 ±1.8% | 1.24 |
| silesia/webster | 41458703 | 29.2 | 706.0 ±3.4% | 841.3 ±8.3% | 1.19 |
| silesia/x-ray | 8474240 | 71.8 | 605.5 ±0.4% | 796.9 ±0.5% | 1.32 |
| silesia/xml | 5345280 | 11.9 | 1505.5 ±0.6% | 1792.8 ±4.1% | 1.19 |
| canterbury/alice29.txt | 152089 | 37.5 | 623.3 ±0.3% | 826.0 ±0.5% | 1.33 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 707.5 ±0.2% | 928.6 ±2.8% | 1.31 |
| canterbury/cp.html | 24603 | 34.4 | 875.2 ±0.7% | 1052.3 ±0.9% | 1.20 |
| canterbury/fields.c | 11150 | 30.3 | 721.1 ±0.1% | 879.9 ±0.6% | 1.22 |
| canterbury/grammar.lsp | 3721 | 34.8 | 548.6 ±1.4% | 634.4 ±0.6% | 1.16 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 871.1 ±0.4% | 1037.3 ±0.4% | 1.19 |
| canterbury/lcet10.txt | 426754 | 33.0 | 768.6 ±1.8% | 1005.0 ±0.4% | 1.31 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 658.9 ±5.6% | 879.3 ±7.4% | 1.33 |
| canterbury/ptt5 | 513216 | 10.6 | 1694.6 ±0.9% | 2079.8 ±0.2% | 1.23 |
| canterbury/sum | 38240 | 35.0 | 870.6 ±1.7% | 1017.5 ±2.1% | 1.17 |
| canterbury/xargs.1 | 4227 | 42.7 | 539.3 ±0.5% | 505.8 ±0.3% | 0.94 |
| canterbury-large/E.coli | 4638690 | 30.0 | 714.2 ±0.7% | 945.5 ±1.0% | 1.32 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 792.1 ±1.0% | 1011.2 ±1.2% | 1.28 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 940.4 ±0.3% | 1137.0 ±0.2% | 1.21 |
| http/html-1kx1024 | 1048576 | 39.3 | 336.5 ±0.2% | 328.5 ±0.1% | 0.98 |
| http/html-16kx64 | 1048576 | 21.9 | 868.8 ±0.3% | 973.9 ±0.5% | 1.12 |
| http/html-1m | 1048576 | 17.7 | 1131.0 ±0.3% | 1348.0 ±0.3% | 1.19 |
| http/json-1kx1024 | 1048576 | 21.9 | 398.0 ±2.2% | 402.1 ±0.2% | 1.01 |
| http/json-16kx64 | 1048576 | 12.6 | 1137.2 ±0.3% | 1273.6 ±0.3% | 1.12 |
| http/json-1m | 1048576 | 12.2 | 1340.5 ±0.2% | 1661.7 ±2.2% | 1.24 |
| http/js-1kx1024 | 1048576 | 44.5 | 291.4 ±0.4% | 269.9 ±0.5% | 0.93 |
| http/js-16kx64 | 1048576 | 26.0 | 773.3 ±0.3% | 887.7 ±0.6% | 1.15 |
| http/js-1m | 1048576 | 19.0 | 1104.8 ±0.5% | 1321.4 ±0.7% | 1.20 |
| http/css-1kx1024 | 1048576 | 29.5 | 360.5 ±0.8% | 362.0 ±0.3% | 1.00 |
| http/css-16kx64 | 1048576 | 15.9 | 1030.1 ±0.3% | 1132.1 ±0.5% | 1.10 |
| http/css-1m | 1048576 | 3.6 | 3473.1 ±1.7% | 3645.2 ±0.9% | 1.05 |
| shuffled/dickens-1m | 1048576 | 58.8 | 900.0 ±0.3% | 1033.1 ±0.3% | 1.15 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 208.4 ±0.8% | 859.3 ±1.5% | 4.12 |
| silesia/mozilla | 51220480 | 35.6 | 250.4 ±0.2% | 976.8 ±1.0% | 3.90 |
| silesia/mr | 9970564 | 35.6 | 218.4 ±0.5% | 994.1 ±1.8% | 4.55 |
| silesia/nci | 33553445 | 8.4 | 572.4 ±0.9% | 1870.4 ±0.1% | 3.27 |
| silesia/ooffice | 6152192 | 50.8 | 184.8 ±0.3% | 851.0 ±0.3% | 4.60 |
| silesia/osdb | 10085684 | 34.7 | 292.8 ±0.4% | 1230.5 ±0.4% | 4.20 |
| silesia/reymont | 6627202 | 29.2 | 253.5 ±1.2% | 997.9 ±0.6% | 3.94 |
| silesia/samba | 21606400 | 22.9 | 390.5 ±0.7% | 1374.3 ±1.1% | 3.52 |
| silesia/sao | 7251944 | 76.2 | 169.3 ±0.2% | 797.1 ±0.6% | 4.71 |
| silesia/webster | 41458703 | 29.2 | 245.7 ±0.9% | 933.3 ±1.9% | 3.80 |
| silesia/x-ray | 8474240 | 71.8 | 157.8 ±0.8% | 801.4 ±0.7% | 5.08 |
| silesia/xml | 5345280 | 11.9 | 524.3 ±2.1% | 1788.4 ±0.6% | 3.41 |
| canterbury/alice29.txt | 152089 | 37.5 | 184.8 ±0.9% | 825.9 ±0.3% | 4.47 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 181.1 ±0.4% | 924.8 ±0.3% | 5.11 |
| canterbury/cp.html | 24603 | 34.4 | 239.0 ±1.0% | 1036.4 ±1.4% | 4.34 |
| canterbury/fields.c | 11150 | 30.3 | 217.9 ±0.7% | 873.8 ±0.5% | 4.01 |
| canterbury/grammar.lsp | 3721 | 34.8 | 190.1 ±0.7% | 630.0 ±0.3% | 3.31 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 262.7 ±0.1% | 1034.3 ±0.5% | 3.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 224.5 ±0.5% | 1009.6 ±0.7% | 4.50 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 184.4 ±0.4% | 877.5 ±0.4% | 4.76 |
| canterbury/ptt5 | 513216 | 10.6 | 420.4 ±0.3% | 2078.0 ±0.6% | 4.94 |
| canterbury/sum | 38240 | 35.0 | 234.3 ±0.4% | 1012.7 ±0.2% | 4.32 |
| canterbury/xargs.1 | 4227 | 42.7 | 166.2 ±0.4% | 613.6 ±0.4% | 3.69 |
| canterbury-large/E.coli | 4638690 | 30.0 | 224.4 ±0.5% | 943.4 ±2.8% | 4.20 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 256.0 ±1.0% | 1008.7 ±1.0% | 3.94 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 288.1 ±0.7% | 1139.3 ±0.7% | 3.95 |
| http/html-1kx1024 | 1048576 | 39.3 | 159.4 ±0.4% | 327.4 ±0.2% | 2.05 |
| http/html-16kx64 | 1048576 | 21.9 | 285.8 ±0.3% | 970.6 ±0.2% | 3.40 |
| http/html-1m | 1048576 | 17.7 | 375.5 ±0.4% | 1350.0 ±0.3% | 3.60 |
| http/json-1kx1024 | 1048576 | 21.9 | 234.8 ±0.3% | 402.3 ±0.4% | 1.71 |
| http/json-16kx64 | 1048576 | 12.6 | 400.0 ±0.5% | 1280.1 ±0.6% | 3.20 |
| http/json-1m | 1048576 | 12.2 | 451.2 ±2.8% | 1660.9 ±0.5% | 3.68 |
| http/js-1kx1024 | 1048576 | 44.5 | 134.7 ±0.3% | 270.3 ±0.3% | 2.01 |
| http/js-16kx64 | 1048576 | 26.0 | 245.9 ±0.3% | 884.1 ±0.3% | 3.60 |
| http/js-1m | 1048576 | 19.0 | 357.4 ±0.3% | 1321.0 ±0.4% | 3.70 |
| http/css-1kx1024 | 1048576 | 29.5 | 196.6 ±0.1% | 360.8 ±0.2% | 1.84 |
| http/css-16kx64 | 1048576 | 15.9 | 351.3 ±0.3% | 1126.2 ±0.2% | 3.21 |
| http/css-1m | 1048576 | 3.6 | 1438.5 ±1.6% | 3636.8 ±3.7% | 2.53 |
| shuffled/dickens-1m | 1048576 | 58.8 | 172.0 ±0.4% | 1034.9 ±2.6% | 6.02 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 825.3 ±3.1% | 0.98 ±7.6% | 1.06 ±59.4% | 0.53 ±3.4% | 1.05 ±1.1% | 0.34 ±4.2% |
| silesia/mozilla | 51220480 | 35.6 | 977.4 ±4.0% | 0.72 ±2.4% | 1.00 ±1.0% | 0.55 ±1.1% | 1.00 ±0.8% | 0.40 ±0.8% |
| silesia/mr | 9970564 | 35.6 | 971.3 ±1.1% | 0.80 ±1.1% | 1.03 ±4.5% | 0.50 ±1.0% | 1.00 ±3.4% | 0.34 ±2.2% |
| silesia/nci | 33553445 | 8.4 | 1879.8 ±8.0% | 0.93 ±5.0% | 0.99 ±13.8% | 0.57 ±1.7% | 0.99 ±5.8% | 0.38 ±3.1% |
| silesia/ooffice | 6152192 | 50.8 | 845.3 ±0.4% | 0.60 ±0.3% | 1.00 ±0.6% | 0.54 ±0.3% | 0.98 ±1.4% | 0.40 ±0.6% |
| silesia/osdb | 10085684 | 34.7 | 1218.9 ±0.5% | 0.64 ±0.7% | 0.99 ±1.2% | 0.62 ±0.3% | 0.99 ±1.5% | 0.40 ±0.9% |
| silesia/reymont | 6627202 | 29.2 | 981.1 ±1.0% | 0.93 ±1.7% | 1.00 ±1.2% | 0.52 ±0.5% | 0.99 ±0.9% | 0.33 ±0.8% |
| silesia/samba | 21606400 | 22.9 | 1361.0 ±6.0% | 0.89 ±3.9% | 1.00 ±1.9% | 0.56 ±4.3% | 0.98 ±2.8% | 0.37 ±2.4% |
| silesia/sao | 7251944 | 76.2 | 786.1 ±2.2% | 0.48 ±1.8% | 0.99 ±2.1% | 0.64 ±2.0% | 0.98 ±1.9% | 0.47 ±2.9% |
| silesia/webster | 41458703 | 29.2 | 874.6 ±10.0% | 0.91 ±4.7% | 1.01 ±5.1% | 0.55 ±5.8% | 1.01 ±9.8% | 0.37 ±7.5% |
| silesia/x-ray | 8474240 | 71.8 | 796.5 ±0.7% | 0.48 ±2.5% | 1.00 ±0.6% | 0.60 ±0.2% | 0.91 ±0.6% | 0.42 ±0.6% |
| silesia/xml | 5345280 | 11.9 | 1795.1 ±0.2% | 0.92 ±0.3% | 1.00 ±0.3% | 0.57 ±0.3% | 0.99 ±1.2% | 0.38 ±0.3% |
| canterbury/alice29.txt | 152089 | 37.5 | 832.4 ±0.3% | 0.94 ±0.2% | 1.00 ±0.5% | 0.48 ±0.4% | 0.99 ±0.1% | 0.30 ±2.4% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 912.8 ±4.0% | 0.85 ±0.3% | 0.99 ±0.2% | 0.47 ±0.4% | 0.93 ±0.1% | 0.32 ±0.5% |
| canterbury/cp.html | 24603 | 34.4 | 1039.5 ±0.9% | 0.63 ±0.4% | 1.00 ±0.9% | 0.64 ±0.5% | 1.00 ±0.6% | 0.42 ±0.5% |
| canterbury/fields.c | 11150 | 30.3 | 886.4 ±0.6% | 0.78 ±0.2% | 1.00 ±0.6% | 0.58 ±0.3% | 0.98 ±0.2% | 0.36 ±0.5% |
| canterbury/grammar.lsp | 3721 | 34.8 | 629.7 ±0.4% | 0.80 ±0.4% | 1.01 ±0.1% | 0.67 ±0.2% | 1.00 ±0.3% | 0.46 ±0.3% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1025.2 ±1.3% | 0.86 ±24.2% | 1.01 ±0.2% | 0.52 ±0.6% | 1.00 ±0.4% | 0.32 ±0.6% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1001.3 ±0.7% | 0.89 ±0.3% | 1.00 ±6.4% | 0.49 ±0.5% | 1.00 ±0.3% | 0.32 ±0.6% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 875.6 ±1.3% | 0.91 ±1.4% | 0.99 ±4.3% | 0.46 ±0.4% | 0.99 ±0.4% | 0.31 ±0.4% |
| canterbury/ptt5 | 513216 | 10.6 | 2076.2 ±0.4% | 0.80 ±0.5% | 1.00 ±8.1% | 0.51 ±0.4% | 0.99 ±0.5% | 0.40 ±0.7% |
| canterbury/sum | 38240 | 35.0 | 1012.8 ±0.5% | 0.63 ±0.2% | 1.00 ±0.2% | 0.65 ±0.4% | 0.99 ±0.4% | 0.42 ±0.7% |
| canterbury/xargs.1 | 4227 | 42.7 | 611.0 ±0.3% | 0.73 ±0.3% | 1.01 ±0.8% | 0.64 ±4.0% | 1.00 ±0.9% | 0.43 ±0.4% |
| canterbury-large/E.coli | 4638690 | 30.0 | 936.8 ±0.7% | 0.98 ±1.1% | 1.00 ±0.8% | 0.50 ±0.5% | 0.99 ±0.5% | 0.31 ±0.5% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1003.3 ±0.7% | 0.96 ±0.9% | 1.00 ±0.6% | 0.51 ±1.8% | 0.99 ±5.2% | 0.32 ±0.6% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1132.1 ±0.3% | 0.89 ±0.7% | 1.00 ±0.5% | 0.53 ±0.7% | 0.99 ±0.4% | 0.35 ±0.6% |
| http/html-1kx1024 | 1048576 | 39.3 | 325.8 ±0.6% | 0.88 ±1.4% | 1.01 ±0.4% | 0.78 ±0.4% | 0.99 ±0.2% | 0.65 ±0.1% |
| http/html-16kx64 | 1048576 | 21.9 | 971.4 ±0.5% | 0.83 ±0.2% | 1.00 ±0.5% | 0.59 ±0.2% | 0.99 ±0.5% | 0.42 ±3.7% |
| http/html-1m | 1048576 | 17.7 | 1343.7 ±0.4% | 0.93 ±0.5% | 1.00 ±0.5% | 0.55 ±0.1% | 0.99 ±0.4% | 0.35 ±0.7% |
| http/json-1kx1024 | 1048576 | 21.9 | 401.6 ±0.4% | 0.98 ±0.2% | 1.00 ±0.2% | 0.80 ±0.2% | 0.96 ±0.3% | 0.66 ±0.2% |
| http/json-16kx64 | 1048576 | 12.6 | 1289.6 ±0.6% | 0.84 ±0.3% | 0.99 ±0.3% | 0.61 ±0.1% | 0.99 ±0.3% | 0.43 ±0.3% |
| http/json-1m | 1048576 | 12.2 | 1658.8 ±0.4% | 0.88 ±0.5% | 1.00 ±0.3% | 0.55 ±0.6% | 1.00 ±0.9% | 0.36 ±1.5% |
| http/js-1kx1024 | 1048576 | 44.5 | 268.6 ±0.3% | 0.88 ±0.4% | 0.99 ±0.6% | 0.77 ±0.1% | 0.99 ±0.3% | 0.65 ±0.6% |
| http/js-16kx64 | 1048576 | 26.0 | 890.0 ±0.3% | 0.81 ±0.7% | 1.00 ±0.7% | 0.56 ±1.1% | 0.97 ±0.2% | 0.40 ±0.4% |
| http/js-1m | 1048576 | 19.0 | 1312.5 ±0.6% | 0.91 ±0.4% | 1.00 ±0.3% | 0.55 ±0.2% | 0.99 ±0.3% | 0.35 ±0.8% |
| http/css-1kx1024 | 1048576 | 29.5 | 362.1 ±0.3% | 0.94 ±0.1% | 0.99 ±0.2% | 0.78 ±0.7% | 0.98 ±0.3% | 0.64 ±0.5% |
| http/css-16kx64 | 1048576 | 15.9 | 1134.8 ±5.4% | 0.88 ±0.4% | 1.00 ±0.1% | 0.62 ±0.5% | 0.99 ±0.4% | 0.41 ±0.5% |
| http/css-1m | 1048576 | 3.6 | 3633.8 ±1.1% | 0.95 ±1.9% | 1.01 ±0.9% | 0.71 ±0.6% | 1.00 ±0.6% | 0.44 ±0.2% |
| shuffled/dickens-1m | 1048576 | 58.8 | 980.6 ±2.3% | 0.53 ±0.5% | 0.91 ±49.4% | 0.74 ±0.4% | 1.04 ±0.4% | 0.53 ±0.2% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 265.2 ± 1.1% | 92.7 ± 0.3% | 0.35 |
| silesia/dickens | 10192446 | 3 | 140.5 ± 4.1% | 75.7 ± 0.3% | 0.54 |
| silesia/mozilla | 51220480 | 1 | 389.8 ± 0.4% | 126.5 ± 0.4% | 0.32 |
| silesia/mozilla | 51220480 | 3 | 203.8 ± 0.3% | 107.1 ± 0.4% | 0.53 |
| silesia/mr | 9970564 | 1 | 354.5 ± 0.6% | 113.3 ± 0.5% | 0.32 |
| silesia/mr | 9970564 | 3 | 161.9 ± 2.4% | 88.6 ± 1.2% | 0.55 |
| silesia/nci | 33553445 | 1 | 794.6 ± 0.6% | 290.2 ± 0.7% | 0.37 |
| silesia/nci | 33553445 | 3 | 610.7 ± 0.7% | 254.1 ± 0.6% | 0.42 |
| silesia/ooffice | 6152192 | 1 | 321.7 ± 0.5% | 97.5 ± 0.6% | 0.30 |
| silesia/ooffice | 6152192 | 3 | 138.0 ± 1.9% | 79.0 ± 1.1% | 0.57 |
| silesia/osdb | 10085684 | 1 | 383.9 ± 0.4% | 138.6 ± 0.7% | 0.36 |
| silesia/osdb | 10085684 | 3 | 194.2 ± 3.6% | 110.9 ± 2.2% | 0.57 |
| silesia/reymont | 6627202 | 1 | 273.3 ± 0.7% | 109.1 ± 0.6% | 0.40 |
| silesia/reymont | 6627202 | 3 | 183.3 ± 1.8% | 95.6 ± 2.2% | 0.52 |
| silesia/samba | 21606400 | 1 | 456.0 ± 0.3% | 164.1 ± 1.0% | 0.36 |
| silesia/samba | 21606400 | 3 | 281.0 ± 3.7% | 141.6 ± 2.5% | 0.50 |
| silesia/sao | 7251944 | 1 | 299.9 ± 0.3% | 90.2 ± 0.5% | 0.30 |
| silesia/sao | 7251944 | 3 | 103.6 ± 0.5% | 68.5 ± 0.6% | 0.66 |
| silesia/webster | 41458703 | 1 | 307.2 ± 0.7% | 108.6 ± 0.3% | 0.35 |
| silesia/webster | 41458703 | 3 | 173.0 ± 0.5% | 92.6 ± 3.8% | 0.54 |
| silesia/x-ray | 8474240 | 1 | 652.2 ± 0.4% | 93.8 ± 2.4% | 0.14 |
| silesia/x-ray | 8474240 | 3 | 99.9 ± 0.4% | 70.0 ± 0.4% | 0.70 |
| silesia/xml | 5345280 | 1 | 644.2 ± 0.5% | 219.5 ± 0.7% | 0.34 |
| silesia/xml | 5345280 | 3 | 459.4 ± 2.4% | 206.2 ± 0.4% | 0.45 |
| canterbury/alice29.txt | 152089 | 1 | 242.1 ± 0.5% | 96.0 ± 0.5% | 0.40 |
| canterbury/alice29.txt | 152089 | 3 | 164.1 ± 0.6% | 80.9 ± 0.4% | 0.49 |
| canterbury/asyoulik.txt | 125179 | 1 | 263.8 ± 0.4% | 90.7 ± 0.3% | 0.34 |
| canterbury/asyoulik.txt | 125179 | 3 | 169.9 ± 0.5% | 76.2 ± 0.7% | 0.45 |
| canterbury/cp.html | 24603 | 1 | 420.9 ± 1.1% | 144.3 ± 2.8% | 0.34 |
| canterbury/cp.html | 24603 | 3 | 271.2 ± 0.5% | 131.0 ± 1.1% | 0.48 |
| canterbury/fields.c | 11150 | 1 | 345.9 ± 0.6% | 154.9 ± 0.6% | 0.45 |
| canterbury/fields.c | 11150 | 3 | 289.6 ± 0.4% | 144.6 ± 0.3% | 0.50 |
| canterbury/grammar.lsp | 3721 | 1 | 285.7 ± 0.7% | 126.3 ± 6.1% | 0.44 |
| canterbury/grammar.lsp | 3721 | 3 | 231.7 ± 0.2% | 119.7 ± 2.0% | 0.52 |
| canterbury/kennedy.xls | 1029744 | 1 | 427.9 ± 0.5% | 156.8 ± 0.3% | 0.37 |
| canterbury/kennedy.xls | 1029744 | 3 | 374.5 ± 0.6% | 134.2 ± 0.6% | 0.36 |
| canterbury/lcet10.txt | 426754 | 1 | 266.5 ± 0.2% | 101.7 ± 0.4% | 0.38 |
| canterbury/lcet10.txt | 426754 | 3 | 167.8 ± 0.4% | 86.4 ± 0.5% | 0.51 |
| canterbury/plrabn12.txt | 481861 | 1 | 254.7 ± 0.5% | 85.1 ± 4.3% | 0.33 |
| canterbury/plrabn12.txt | 481861 | 3 | 135.7 ± 0.6% | 72.4 ± 0.8% | 0.53 |
| canterbury/ptt5 | 513216 | 1 | 858.8 ± 0.4% | 285.3 ± 0.5% | 0.33 |
| canterbury/ptt5 | 513216 | 3 | 602.2 ± 0.8% | 262.8 ± 0.4% | 0.44 |
| canterbury/sum | 38240 | 1 | 434.0 ± 0.4% | 132.5 ± 0.7% | 0.31 |
| canterbury/sum | 38240 | 3 | 286.4 ± 0.6% | 118.0 ± 0.4% | 0.41 |
| canterbury/xargs.1 | 4227 | 1 | 273.6 ± 0.2% | 120.3 ± 0.6% | 0.44 |
| canterbury/xargs.1 | 4227 | 3 | 206.8 ± 0.8% | 111.5 ± 0.8% | 0.54 |
| canterbury-large/E.coli | 4638690 | 1 | 250.7 ± 0.5% | 104.1 ± 0.4% | 0.42 |
| canterbury-large/E.coli | 4638690 | 3 | 184.7 ± 0.5% | 96.7 ± 0.6% | 0.52 |
| canterbury-large/bible.txt | 4047392 | 1 | 271.8 ± 0.4% | 108.9 ± 0.6% | 0.40 |
| canterbury-large/bible.txt | 4047392 | 3 | 178.7 ± 0.8% | 94.0 ± 0.4% | 0.53 |
| canterbury-large/world192.txt | 2473400 | 1 | 324.5 ± 0.5% | 119.0 ± 0.5% | 0.37 |
| canterbury-large/world192.txt | 2473400 | 3 | 200.1 ± 0.6% | 108.3 ± 0.6% | 0.54 |
| http/html-1kx1024 | 1048576 | 1 | 152.8 ± 2.9% | 64.9 ± 0.2% | 0.42 |
| http/html-1kx1024 | 1048576 | 3 | 131.0 ± 0.5% | 62.8 ± 0.6% | 0.48 |
| http/html-16kx64 | 1048576 | 1 | 348.4 ± 0.1% | 152.5 ± 0.2% | 0.44 |
| http/html-16kx64 | 1048576 | 3 | 297.5 ± 0.3% | 145.3 ± 0.9% | 0.49 |
| http/html-1m | 1048576 | 1 | 422.5 ± 0.2% | 169.4 ± 0.9% | 0.40 |
| http/html-1m | 1048576 | 3 | 313.7 ± 0.8% | 155.2 ± 0.8% | 0.49 |
| http/json-1kx1024 | 1048576 | 1 | 186.4 ± 0.4% | 80.1 ± 0.4% | 0.43 |
| http/json-1kx1024 | 1048576 | 3 | 174.8 ± 0.3% | 78.0 ± 0.5% | 0.45 |
| http/json-16kx64 | 1048576 | 1 | 579.2 ± 0.4% | 223.4 ± 0.4% | 0.39 |
| http/json-16kx64 | 1048576 | 3 | 493.8 ± 1.1% | 209.4 ± 0.5% | 0.42 |
| http/json-1m | 1048576 | 1 | 673.9 ± 0.5% | 243.9 ± 0.2% | 0.36 |
| http/json-1m | 1048576 | 3 | 491.7 ± 0.3% | 217.6 ± 0.5% | 0.44 |
| http/js-1kx1024 | 1048576 | 1 | 139.3 ± 0.4% | 57.6 ± 0.4% | 0.41 |
| http/js-1kx1024 | 1048576 | 3 | 114.8 ± 0.3% | 55.9 ± 0.3% | 0.49 |
| http/js-16kx64 | 1048576 | 1 | 304.5 ± 0.1% | 128.2 ± 0.3% | 0.42 |
| http/js-16kx64 | 1048576 | 3 | 259.0 ± 0.5% | 124.2 ± 0.5% | 0.48 |
| http/js-1m | 1048576 | 1 | 403.9 ± 0.3% | 155.3 ± 0.5% | 0.38 |
| http/js-1m | 1048576 | 3 | 297.2 ± 0.7% | 144.7 ± 0.5% | 0.49 |
| http/css-1kx1024 | 1048576 | 1 | 169.2 ± 0.1% | 72.7 ± 0.2% | 0.43 |
| http/css-1kx1024 | 1048576 | 3 | 152.1 ± 0.2% | 71.0 ± 0.7% | 0.47 |
| http/css-16kx64 | 1048576 | 1 | 450.0 ± 0.1% | 173.5 ± 0.2% | 0.39 |
| http/css-16kx64 | 1048576 | 3 | 404.7 ± 0.2% | 171.5 ± 0.5% | 0.42 |
| http/css-1m | 1048576 | 1 | 1897.0 ± 0.4% | 589.4 ± 0.5% | 0.31 |
| http/css-1m | 1048576 | 3 | 1490.3 ± 1.1% | 612.4 ± 1.0% | 0.41 |
| shuffled/dickens-1m | 1048576 | 1 | 979.5 ± 0.4% | 189.8 ± 0.3% | 0.19 |
| shuffled/dickens-1m | 1048576 | 3 | 110.5 ± 0.7% | 117.2 ± 0.9% | 1.06 |

## Encoding ratio

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, ratio | stdx, ratio | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 2.392 | 2.513 | 1.051 |
| silesia/dickens | 10192446 | 3 | 2.782 | 2.770 | 0.996 |
| silesia/mozilla | 51220480 | 1 | 2.565 | 2.627 | 1.024 |
| silesia/mozilla | 51220480 | 3 | 2.810 | 2.718 | 0.967 |
| silesia/mr | 9970564 | 1 | 2.615 | 2.765 | 1.058 |
| silesia/mr | 9970564 | 3 | 2.811 | 2.793 | 0.994 |
| silesia/nci | 33553445 | 1 | 11.779 | 9.291 | 0.789 |
| silesia/nci | 33553445 | 3 | 11.840 | 10.252 | 0.866 |
| silesia/ooffice | 6152192 | 1 | 1.712 | 1.907 | 1.114 |
| silesia/ooffice | 6152192 | 3 | 1.968 | 1.947 | 0.990 |
| silesia/osdb | 10085684 | 1 | 2.704 | 2.824 | 1.045 |
| silesia/osdb | 10085684 | 3 | 2.880 | 2.869 | 0.996 |
| silesia/reymont | 6627202 | 1 | 3.084 | 2.989 | 0.969 |
| silesia/reymont | 6627202 | 3 | 3.420 | 3.397 | 0.993 |
| silesia/samba | 21606400 | 1 | 3.937 | 3.888 | 0.987 |
| silesia/samba | 21606400 | 3 | 4.360 | 4.237 | 0.972 |
| silesia/sao | 7251944 | 1 | 1.160 | 1.291 | 1.112 |
| silesia/sao | 7251944 | 3 | 1.312 | 1.304 | 0.994 |
| silesia/webster | 41458703 | 1 | 3.035 | 3.107 | 1.024 |
| silesia/webster | 41458703 | 3 | 3.427 | 3.406 | 0.994 |
| silesia/x-ray | 8474240 | 1 | 1.251 | 1.363 | 1.089 |
| silesia/x-ray | 8474240 | 3 | 1.393 | 1.363 | 0.979 |
| silesia/xml | 5345280 | 1 | 7.710 | 6.565 | 0.851 |
| silesia/xml | 5345280 | 3 | 8.414 | 7.806 | 0.928 |
| canterbury/alice29.txt | 152089 | 1 | 2.549 | 2.555 | 1.002 |
| canterbury/alice29.txt | 152089 | 3 | 2.670 | 2.713 | 1.016 |
| canterbury/asyoulik.txt | 125179 | 1 | 2.296 | 2.397 | 1.044 |
| canterbury/asyoulik.txt | 125179 | 3 | 2.487 | 2.488 | 1.000 |
| canterbury/cp.html | 24603 | 1 | 2.789 | 2.838 | 1.017 |
| canterbury/cp.html | 24603 | 3 | 2.907 | 2.905 | 1.000 |
| canterbury/fields.c | 11150 | 1 | 3.136 | 3.136 | 1.000 |
| canterbury/fields.c | 11150 | 3 | 3.299 | 3.277 | 0.993 |
| canterbury/grammar.lsp | 3721 | 1 | 2.783 | 2.769 | 0.995 |
| canterbury/grammar.lsp | 3721 | 3 | 2.882 | 2.845 | 0.987 |
| canterbury/kennedy.xls | 1029744 | 1 | 8.924 | 7.381 | 0.827 |
| canterbury/kennedy.xls | 1029744 | 3 | 9.208 | 8.369 | 0.909 |
| canterbury/lcet10.txt | 426754 | 1 | 2.692 | 2.754 | 1.023 |
| canterbury/lcet10.txt | 426754 | 3 | 3.026 | 3.007 | 0.994 |
| canterbury/plrabn12.txt | 481861 | 1 | 2.212 | 2.355 | 1.065 |
| canterbury/plrabn12.txt | 481861 | 3 | 2.514 | 2.504 | 0.996 |
| canterbury/ptt5 | 513216 | 1 | 9.933 | 8.713 | 0.877 |
| canterbury/ptt5 | 513216 | 3 | 9.431 | 8.870 | 0.941 |
| canterbury/sum | 38240 | 1 | 2.808 | 2.765 | 0.985 |
| canterbury/sum | 38240 | 3 | 2.859 | 2.809 | 0.982 |
| canterbury/xargs.1 | 4227 | 1 | 2.273 | 2.269 | 0.998 |
| canterbury/xargs.1 | 4227 | 3 | 2.350 | 2.294 | 0.976 |
| canterbury-large/E.coli | 4638690 | 1 | 3.285 | 3.186 | 0.970 |
| canterbury-large/E.coli | 4638690 | 3 | 3.332 | 3.293 | 0.988 |
| canterbury-large/bible.txt | 4047392 | 1 | 3.124 | 3.040 | 0.973 |
| canterbury-large/bible.txt | 4047392 | 3 | 3.455 | 3.430 | 0.993 |
| canterbury-large/world192.txt | 2473400 | 1 | 3.228 | 3.329 | 1.031 |
| canterbury-large/world192.txt | 2473400 | 3 | 3.774 | 3.723 | 0.986 |
| http/html-1kx1024 | 1048576 | 1 | 2.541 | 2.550 | 1.004 |
| http/html-1kx1024 | 1048576 | 3 | 2.573 | 2.576 | 1.001 |
| http/html-16kx64 | 1048576 | 1 | 4.415 | 4.388 | 0.994 |
| http/html-16kx64 | 1048576 | 3 | 4.576 | 4.548 | 0.994 |
| http/html-1m | 1048576 | 1 | 5.232 | 5.110 | 0.977 |
| http/html-1m | 1048576 | 3 | 5.645 | 5.561 | 0.985 |
| http/json-1kx1024 | 1048576 | 1 | 4.607 | 4.560 | 0.990 |
| http/json-1kx1024 | 1048576 | 3 | 4.647 | 4.636 | 0.998 |
| http/json-16kx64 | 1048576 | 1 | 7.939 | 7.289 | 0.918 |
| http/json-16kx64 | 1048576 | 3 | 7.950 | 7.526 | 0.947 |
| http/json-1m | 1048576 | 1 | 7.648 | 7.267 | 0.950 |
| http/json-1m | 1048576 | 3 | 8.223 | 7.541 | 0.917 |
| http/js-1kx1024 | 1048576 | 1 | 2.233 | 2.236 | 1.001 |
| http/js-1kx1024 | 1048576 | 3 | 2.268 | 2.265 | 0.999 |
| http/js-16kx64 | 1048576 | 1 | 3.697 | 3.662 | 0.990 |
| http/js-16kx64 | 1048576 | 3 | 3.850 | 3.831 | 0.995 |
| http/js-1m | 1048576 | 1 | 4.776 | 4.676 | 0.979 |
| http/js-1m | 1048576 | 3 | 5.251 | 5.193 | 0.989 |
| http/css-1kx1024 | 1048576 | 1 | 3.381 | 3.397 | 1.005 |
| http/css-1kx1024 | 1048576 | 3 | 3.439 | 3.453 | 1.004 |
| http/css-16kx64 | 1048576 | 1 | 6.065 | 5.679 | 0.936 |
| http/css-16kx64 | 1048576 | 3 | 6.307 | 5.940 | 0.942 |
| http/css-1m | 1048576 | 1 | 26.317 | 21.892 | 0.832 |
| http/css-1m | 1048576 | 3 | 27.466 | 25.155 | 0.916 |
| shuffled/dickens-1m | 1048576 | 1 | 1.756 | 1.745 | 0.994 |
| shuffled/dickens-1m | 1048576 | 3 | 1.702 | 1.732 | 1.018 |

## stdx built ReleaseFast against libzstd, libzstd level 3 (decision 17)

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 657.8 ±1.2% | 848.0 ±6.6% | 1.29 |
| silesia/mozilla | 51220480 | 35.6 | 800.9 ±1.4% | 989.5 ±3.7% | 1.24 |
| silesia/mr | 9970564 | 35.6 | 763.9 ±0.9% | 962.0 ±0.9% | 1.26 |
| silesia/nci | 33553445 | 8.4 | 1569.0 ±8.9% | 1841.5 ±7.8% | 1.17 |
| silesia/ooffice | 6152192 | 50.8 | 688.2 ±0.6% | 846.4 ±0.6% | 1.23 |
| silesia/osdb | 10085684 | 34.7 | 1038.3 ±0.5% | 1217.3 ±0.4% | 1.17 |
| silesia/reymont | 6627202 | 29.2 | 777.4 ±2.3% | 993.4 ±1.0% | 1.28 |
| silesia/samba | 21606400 | 22.9 | 1160.4 ±1.9% | 1366.4 ±1.2% | 1.18 |
| silesia/sao | 7251944 | 76.2 | 639.6 ±2.0% | 793.9 ±2.2% | 1.24 |
| silesia/webster | 41458703 | 29.2 | 738.7 ±14.7% | 965.8 ±1.5% | 1.31 |
| silesia/x-ray | 8474240 | 71.8 | 606.0 ±0.4% | 796.3 ±0.5% | 1.31 |
| silesia/xml | 5345280 | 11.9 | 1500.0 ±1.5% | 1788.2 ±0.6% | 1.19 |
| canterbury/alice29.txt | 152089 | 37.5 | 621.0 ±0.4% | 832.3 ±0.3% | 1.34 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 708.7 ±0.5% | 922.8 ±0.3% | 1.30 |
| canterbury/cp.html | 24603 | 34.4 | 878.9 ±0.2% | 1050.4 ±0.4% | 1.20 |
| canterbury/fields.c | 11150 | 30.3 | 716.3 ±0.5% | 861.4 ±0.5% | 1.20 |
| canterbury/grammar.lsp | 3721 | 34.8 | 556.2 ±0.5% | 630.3 ±0.2% | 1.13 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 876.5 ±0.5% | 1037.4 ±0.1% | 1.18 |
| canterbury/lcet10.txt | 426754 | 33.0 | 771.8 ±0.5% | 1001.3 ±0.6% | 1.30 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 658.8 ±0.5% | 866.0 ±0.5% | 1.31 |
| canterbury/ptt5 | 513216 | 10.6 | 1702.1 ±0.8% | 2090.0 ±2.1% | 1.23 |
| canterbury/sum | 38240 | 35.0 | 860.2 ±0.1% | 1016.3 ±0.3% | 1.18 |
| canterbury/xargs.1 | 4227 | 42.7 | 539.7 ±0.6% | 607.0 ±0.1% | 1.12 |
| canterbury-large/E.coli | 4638690 | 30.0 | 708.7 ±0.6% | 924.8 ±0.3% | 1.30 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 781.1 ±0.3% | 993.7 ±1.0% | 1.27 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 932.5 ±0.6% | 1135.3 ±0.6% | 1.22 |
| http/html-1kx1024 | 1048576 | 39.3 | 337.3 ±0.1% | 339.7 ±0.7% | 1.01 |
| http/html-16kx64 | 1048576 | 21.9 | 868.2 ±0.7% | 970.3 ±0.5% | 1.12 |
| http/html-1m | 1048576 | 17.7 | 1117.6 ±0.4% | 1350.0 ±0.4% | 1.21 |
| http/json-1kx1024 | 1048576 | 21.9 | 397.2 ±1.0% | 419.6 ±0.3% | 1.06 |
| http/json-16kx64 | 1048576 | 12.6 | 1135.2 ±0.6% | 1294.7 ±0.3% | 1.14 |
| http/json-1m | 1048576 | 12.2 | 1346.5 ±0.2% | 1664.2 ±1.1% | 1.24 |
| http/js-1kx1024 | 1048576 | 44.5 | 292.6 ±0.4% | 277.3 ±0.5% | 0.95 |
| http/js-16kx64 | 1048576 | 26.0 | 771.8 ±0.5% | 889.4 ±2.0% | 1.15 |
| http/js-1m | 1048576 | 19.0 | 1101.2 ±0.5% | 1313.6 ±0.5% | 1.19 |
| http/css-1kx1024 | 1048576 | 29.5 | 361.4 ±0.3% | 372.7 ±1.7% | 1.03 |
| http/css-16kx64 | 1048576 | 15.9 | 999.1 ±0.3% | 1127.4 ±31.1% | 1.13 |
| http/css-1m | 1048576 | 3.6 | 3471.6 ±0.5% | 3670.0 ±0.5% | 1.06 |
| shuffled/dickens-1m | 1048576 | 58.8 | 900.7 ±0.4% | 1035.4 ±0.4% | 1.15 |
