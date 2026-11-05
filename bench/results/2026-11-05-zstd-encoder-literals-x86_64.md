# bench-zstd

| Field | Value |
|---|---|
| Commit | 6347b4a |
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
| silesia/dickens | 10192446 | 35.9 | 664.7 ±0.3% | 857.6 ±1.0% | 1.29 |
| silesia/mozilla | 51220480 | 35.6 | 807.4 ±3.8% | 994.7 ±4.8% | 1.23 |
| silesia/mr | 9970564 | 35.6 | 760.5 ±5.2% | 970.7 ±3.1% | 1.28 |
| silesia/nci | 33553445 | 8.4 | 1516.9 ±5.6% | 1898.4 ±4.1% | 1.25 |
| silesia/ooffice | 6152192 | 50.8 | 688.8 ±1.0% | 843.7 ±0.7% | 1.22 |
| silesia/osdb | 10085684 | 34.7 | 1040.2 ±0.7% | 1217.6 ±0.5% | 1.17 |
| silesia/reymont | 6627202 | 29.2 | 778.4 ±0.8% | 993.0 ±0.8% | 1.28 |
| silesia/samba | 21606400 | 22.9 | 1171.4 ±0.4% | 1370.7 ±0.7% | 1.17 |
| silesia/sao | 7251944 | 76.2 | 638.0 ±1.3% | 790.6 ±2.5% | 1.24 |
| silesia/webster | 41458703 | 29.2 | 751.1 ±5.6% | 871.4 ±8.8% | 1.16 |
| silesia/x-ray | 8474240 | 71.8 | 605.1 ±0.3% | 793.9 ±0.3% | 1.31 |
| silesia/xml | 5345280 | 11.9 | 1497.8 ±0.3% | 1790.1 ±0.7% | 1.20 |
| canterbury/alice29.txt | 152089 | 37.5 | 627.0 ±0.3% | 831.2 ±3.2% | 1.33 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 709.6 ±0.3% | 918.6 ±0.3% | 1.29 |
| canterbury/cp.html | 24603 | 34.4 | 877.7 ±3.0% | 1051.3 ±0.2% | 1.20 |
| canterbury/fields.c | 11150 | 30.3 | 715.5 ±3.4% | 871.9 ±0.4% | 1.22 |
| canterbury/grammar.lsp | 3721 | 34.8 | 548.6 ±0.3% | 634.1 ±2.7% | 1.16 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 875.1 ±3.4% | 1034.0 ±0.5% | 1.18 |
| canterbury/lcet10.txt | 426754 | 33.0 | 774.2 ±0.5% | 1011.9 ±0.9% | 1.31 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 658.1 ±9.2% | 848.3 ±1.1% | 1.29 |
| canterbury/ptt5 | 513216 | 10.6 | 1691.6 ±0.5% | 2069.0 ±0.5% | 1.22 |
| canterbury/sum | 38240 | 35.0 | 873.1 ±0.6% | 1020.0 ±0.2% | 1.17 |
| canterbury/xargs.1 | 4227 | 42.7 | 529.3 ±0.6% | 617.1 ±0.9% | 1.17 |
| canterbury-large/E.coli | 4638690 | 30.0 | 713.1 ±2.9% | 938.4 ±0.6% | 1.32 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 786.2 ±1.2% | 999.5 ±2.1% | 1.27 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 933.9 ±20.2% | 1052.9 ±1.7% | 1.13 |
| http/html-1kx1024 | 1048576 | 39.3 | 330.6 ±0.4% | 327.6 ±0.6% | 0.99 |
| http/html-16kx64 | 1048576 | 21.9 | 866.4 ±0.4% | 974.9 ±2.3% | 1.13 |
| http/html-1m | 1048576 | 17.7 | 1132.5 ±2.1% | 1349.1 ±1.1% | 1.19 |
| http/json-1kx1024 | 1048576 | 21.9 | 393.5 ±1.0% | 402.8 ±28.6% | 1.02 |
| http/json-16kx64 | 1048576 | 12.6 | 1135.0 ±0.4% | 1284.7 ±0.3% | 1.13 |
| http/json-1m | 1048576 | 12.2 | 1349.7 ±3.2% | 1661.8 ±0.4% | 1.23 |
| http/js-1kx1024 | 1048576 | 44.5 | 289.6 ±0.5% | 269.9 ±1.5% | 0.93 |
| http/js-16kx64 | 1048576 | 26.0 | 771.8 ±0.3% | 889.0 ±0.4% | 1.15 |
| http/js-1m | 1048576 | 19.0 | 1108.2 ±0.1% | 1316.1 ±0.4% | 1.19 |
| http/css-1kx1024 | 1048576 | 29.5 | 358.7 ±2.1% | 360.1 ±3.7% | 1.00 |
| http/css-16kx64 | 1048576 | 15.9 | 1029.2 ±1.3% | 1128.8 ±0.3% | 1.10 |
| http/css-1m | 1048576 | 3.6 | 3459.4 ±1.2% | 3630.6 ±0.3% | 1.05 |
| shuffled/dickens-1m | 1048576 | 58.8 | 901.2 ±0.2% | 1002.6 ±0.3% | 1.11 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 209.3 ±2.2% | 865.7 ±0.6% | 4.14 |
| silesia/mozilla | 51220480 | 35.6 | 251.4 ±0.8% | 993.3 ±1.3% | 3.95 |
| silesia/mr | 9970564 | 35.6 | 218.5 ±0.2% | 980.9 ±0.7% | 4.49 |
| silesia/nci | 33553445 | 8.4 | 584.7 ±1.7% | 1816.5 ±1.7% | 3.11 |
| silesia/ooffice | 6152192 | 50.8 | 184.7 ±1.9% | 846.2 ±1.0% | 4.58 |
| silesia/osdb | 10085684 | 34.7 | 294.5 ±0.7% | 1221.2 ±0.5% | 4.15 |
| silesia/reymont | 6627202 | 29.2 | 253.4 ±0.6% | 981.3 ±0.4% | 3.87 |
| silesia/samba | 21606400 | 22.9 | 390.5 ±0.4% | 1368.7 ±1.0% | 3.51 |
| silesia/sao | 7251944 | 76.2 | 169.0 ±0.3% | 795.8 ±1.1% | 4.71 |
| silesia/webster | 41458703 | 29.2 | 245.7 ±1.4% | 925.9 ±4.3% | 3.77 |
| silesia/x-ray | 8474240 | 71.8 | 156.8 ±0.3% | 795.2 ±0.9% | 5.07 |
| silesia/xml | 5345280 | 11.9 | 494.4 ±0.5% | 1791.9 ±0.5% | 3.62 |
| canterbury/alice29.txt | 152089 | 37.5 | 185.9 ±0.4% | 829.6 ±0.4% | 4.46 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 181.7 ±0.1% | 924.4 ±0.4% | 5.09 |
| canterbury/cp.html | 24603 | 34.4 | 238.7 ±0.6% | 1050.9 ±0.6% | 4.40 |
| canterbury/fields.c | 11150 | 30.3 | 219.9 ±0.6% | 884.8 ±0.8% | 4.02 |
| canterbury/grammar.lsp | 3721 | 34.8 | 190.5 ±0.6% | 640.0 ±1.5% | 3.36 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 263.5 ±0.5% | 1035.3 ±0.3% | 3.93 |
| canterbury/lcet10.txt | 426754 | 33.0 | 223.8 ±0.8% | 1011.8 ±0.4% | 4.52 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 185.6 ±0.7% | 872.1 ±0.3% | 4.70 |
| canterbury/ptt5 | 513216 | 10.6 | 420.2 ±0.2% | 2077.7 ±0.4% | 4.95 |
| canterbury/sum | 38240 | 35.0 | 235.4 ±2.3% | 1026.9 ±0.2% | 4.36 |
| canterbury/xargs.1 | 4227 | 42.7 | 166.3 ±0.8% | 619.4 ±0.6% | 3.72 |
| canterbury-large/E.coli | 4638690 | 30.0 | 223.8 ±0.9% | 927.9 ±0.8% | 4.15 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 256.1 ±0.3% | 996.1 ±0.4% | 3.89 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 287.9 ±3.7% | 1127.6 ±0.7% | 3.92 |
| http/html-1kx1024 | 1048576 | 39.3 | 158.3 ±0.3% | 327.5 ±0.3% | 2.07 |
| http/html-16kx64 | 1048576 | 21.9 | 286.6 ±0.8% | 973.6 ±0.3% | 3.40 |
| http/html-1m | 1048576 | 17.7 | 377.0 ±0.2% | 1345.7 ±0.3% | 3.57 |
| http/json-1kx1024 | 1048576 | 21.9 | 234.4 ±0.2% | 399.8 ±0.3% | 1.71 |
| http/json-16kx64 | 1048576 | 12.6 | 402.1 ±0.7% | 1283.8 ±0.3% | 3.19 |
| http/json-1m | 1048576 | 12.2 | 452.6 ±0.7% | 1663.4 ±0.3% | 3.67 |
| http/js-1kx1024 | 1048576 | 44.5 | 135.4 ±0.4% | 268.2 ±0.3% | 1.98 |
| http/js-16kx64 | 1048576 | 26.0 | 245.6 ±0.5% | 885.5 ±2.2% | 3.60 |
| http/js-1m | 1048576 | 19.0 | 358.4 ±5.1% | 1308.2 ±0.8% | 3.65 |
| http/css-1kx1024 | 1048576 | 29.5 | 199.8 ±0.3% | 361.2 ±0.2% | 1.81 |
| http/css-16kx64 | 1048576 | 15.9 | 353.6 ±0.6% | 1128.4 ±0.3% | 3.19 |
| http/css-1m | 1048576 | 3.6 | 1444.2 ±0.8% | 3641.5 ±1.0% | 2.52 |
| shuffled/dickens-1m | 1048576 | 58.8 | 172.2 ±0.4% | 1036.1 ±0.4% | 6.02 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 855.5 ±1.8% | 0.93 ±1.0% | 1.00 ±1.4% | 0.50 ±25.1% | 0.99 ±1.4% | 0.32 ±1.8% |
| silesia/mozilla | 51220480 | 35.6 | 970.8 ±4.1% | 0.74 ±2.9% | 0.98 ±2.1% | 0.55 ±2.3% | 0.98 ±1.9% | 0.40 ±3.9% |
| silesia/mr | 9970564 | 35.6 | 969.0 ±0.7% | 0.80 ±0.5% | 1.01 ±0.7% | 0.50 ±1.0% | 1.00 ±5.7% | 0.33 ±3.1% |
| silesia/nci | 33553445 | 8.4 | 1774.0 ±10.1% | 0.94 ±8.8% | 1.00 ±3.5% | 0.59 ±6.5% | 1.02 ±5.8% | 0.41 ±1.6% |
| silesia/ooffice | 6152192 | 50.8 | 844.6 ±0.8% | 0.61 ±0.3% | 1.00 ±0.7% | 0.54 ±2.1% | 0.99 ±0.4% | 0.40 ±0.4% |
| silesia/osdb | 10085684 | 34.7 | 1218.0 ±3.1% | 0.65 ±0.3% | 1.00 ±0.4% | 0.62 ±0.9% | 0.99 ±0.7% | 0.40 ±3.3% |
| silesia/reymont | 6627202 | 29.2 | 984.1 ±0.5% | 0.94 ±0.9% | 1.00 ±0.5% | 0.52 ±1.3% | 0.99 ±0.3% | 0.33 ±1.6% |
| silesia/samba | 21606400 | 22.9 | 1375.0 ±0.6% | 0.90 ±0.7% | 1.00 ±0.7% | 0.56 ±1.0% | 0.99 ±0.9% | 0.37 ±0.6% |
| silesia/sao | 7251944 | 76.2 | 796.8 ±0.5% | 0.48 ±1.4% | 1.00 ±0.3% | 0.64 ±0.5% | 0.98 ±0.7% | 0.47 ±0.8% |
| silesia/webster | 41458703 | 29.2 | 941.3 ±1.4% | 0.91 ±2.7% | 1.00 ±2.6% | 0.53 ±4.2% | 0.99 ±1.2% | 0.35 ±1.2% |
| silesia/x-ray | 8474240 | 71.8 | 798.4 ±0.4% | 0.48 ±0.7% | 1.00 ±2.5% | 0.60 ±0.9% | 0.97 ±0.6% | 0.42 ±0.5% |
| silesia/xml | 5345280 | 11.9 | 1791.0 ±0.4% | 0.92 ±0.4% | 1.00 ±0.2% | 0.57 ±0.4% | 0.99 ±0.5% | 0.38 ±0.4% |
| canterbury/alice29.txt | 152089 | 37.5 | 824.7 ±1.0% | 0.95 ±0.2% | 1.01 ±0.3% | 0.48 ±0.6% | 1.00 ±0.3% | 0.31 ±0.9% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 924.4 ±0.2% | 0.85 ±0.3% | 0.98 ±0.3% | 0.47 ±0.2% | 0.99 ±2.1% | 0.32 ±0.4% |
| canterbury/cp.html | 24603 | 34.4 | 1043.7 ±0.1% | 0.63 ±0.2% | 0.99 ±0.6% | 0.65 ±0.3% | 1.00 ±0.2% | 0.42 ±0.3% |
| canterbury/fields.c | 11150 | 30.3 | 887.7 ±2.9% | 0.79 ±0.6% | 0.99 ±0.3% | 0.58 ±0.5% | 0.98 ±0.4% | 0.36 ±2.2% |
| canterbury/grammar.lsp | 3721 | 34.8 | 634.7 ±0.3% | 0.80 ±5.0% | 1.00 ±0.3% | 0.66 ±0.3% | 0.99 ±0.2% | 0.45 ±0.3% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1036.3 ±0.2% | 0.86 ±0.2% | 1.01 ±0.2% | 0.51 ±0.2% | 1.00 ±0.3% | 0.32 ±0.2% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1009.2 ±0.4% | 0.89 ±0.2% | 1.00 ±0.1% | 0.48 ±1.3% | 0.98 ±0.2% | 0.31 ±2.2% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 874.4 ±0.1% | 0.90 ±0.4% | 1.00 ±0.5% | 0.47 ±0.4% | 0.98 ±0.3% | 0.31 ±0.4% |
| canterbury/ptt5 | 513216 | 10.6 | 2072.9 ±0.6% | 0.80 ±0.3% | 1.01 ±0.5% | 0.50 ±0.4% | 1.00 ±0.2% | 0.40 ±0.3% |
| canterbury/sum | 38240 | 35.0 | 1021.4 ±0.3% | 0.64 ±1.9% | 1.00 ±1.8% | 0.65 ±0.6% | 0.98 ±1.8% | 0.42 ±0.4% |
| canterbury/xargs.1 | 4227 | 42.7 | 617.1 ±0.3% | 0.73 ±0.3% | 1.00 ±0.4% | 0.64 ±0.3% | 1.00 ±0.3% | 0.43 ±0.5% |
| canterbury-large/E.coli | 4638690 | 30.0 | 930.8 ±0.8% | 0.97 ±1.1% | 1.00 ±0.9% | 0.50 ±0.6% | 0.98 ±1.6% | 0.31 ±2.0% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 988.5 ±1.0% | 0.96 ±0.6% | 1.00 ±1.4% | 0.51 ±1.2% | 0.98 ±1.9% | 0.32 ±1.8% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1115.0 ±0.8% | 0.89 ±0.7% | 1.00 ±0.7% | 0.53 ±0.3% | 0.99 ±0.8% | 0.35 ±0.5% |
| http/html-1kx1024 | 1048576 | 39.3 | 327.1 ±1.9% | 0.87 ±0.6% | 1.01 ±1.2% | 0.78 ±0.5% | 0.98 ±4.5% | 0.65 ±3.0% |
| http/html-16kx64 | 1048576 | 21.9 | 970.7 ±0.5% | 0.83 ±0.4% | 1.00 ±0.2% | 0.59 ±0.4% | 0.99 ±0.3% | 0.42 ±0.3% |
| http/html-1m | 1048576 | 17.7 | 1343.2 ±0.4% | 0.93 ±0.8% | 1.00 ±0.6% | 0.55 ±0.4% | 0.99 ±2.0% | 0.35 ±0.7% |
| http/json-1kx1024 | 1048576 | 21.9 | 400.6 ±0.2% | 0.98 ±0.3% | 1.00 ±0.4% | 0.80 ±0.2% | 0.98 ±0.3% | 0.66 ±0.4% |
| http/json-16kx64 | 1048576 | 12.6 | 1288.2 ±0.4% | 0.85 ±4.4% | 1.00 ±4.6% | 0.61 ±0.7% | 1.00 ±2.0% | 0.43 ±0.2% |
| http/json-1m | 1048576 | 12.2 | 1669.1 ±0.2% | 0.87 ±1.6% | 1.00 ±0.3% | 0.54 ±0.3% | 0.99 ±0.5% | 0.36 ±0.7% |
| http/js-1kx1024 | 1048576 | 44.5 | 267.2 ±0.5% | 0.86 ±0.3% | 1.00 ±0.3% | 0.77 ±0.3% | 0.99 ±0.2% | 0.66 ±0.6% |
| http/js-16kx64 | 1048576 | 26.0 | 886.7 ±0.3% | 0.82 ±0.2% | 1.01 ±0.3% | 0.57 ±0.4% | 1.00 ±0.3% | 0.40 ±0.3% |
| http/js-1m | 1048576 | 19.0 | 1312.4 ±0.3% | 0.91 ±0.7% | 1.01 ±0.4% | 0.55 ±3.6% | 1.00 ±3.0% | 0.35 ±0.5% |
| http/css-1kx1024 | 1048576 | 29.5 | 361.4 ±0.7% | 0.94 ±0.1% | 1.00 ±0.2% | 0.78 ±0.1% | 0.98 ±0.3% | 0.63 ±0.1% |
| http/css-16kx64 | 1048576 | 15.9 | 1095.0 ±2.2% | 0.91 ±0.3% | 1.03 ±0.2% | 0.63 ±0.3% | 1.02 ±0.2% | 0.43 ±1.5% |
| http/css-1m | 1048576 | 3.6 | 3656.1 ±0.6% | 0.95 ±2.0% | 1.00 ±0.4% | 0.70 ±0.5% | 0.99 ±0.2% | 0.44 ±0.2% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1035.7 ±0.5% | 0.50 ±0.3% | 0.86 ±0.3% | 0.70 ±0.4% | 0.98 ±0.4% | 0.50 ±0.7% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 265.3 ± 0.3% | 111.9 ± 4.7% | 0.42 |
| silesia/dickens | 10192446 | 3 | 139.5 ± 2.4% | 90.4 ± 0.6% | 0.65 |
| silesia/mozilla | 51220480 | 1 | 385.7 ± 0.2% | 159.2 ± 0.2% | 0.41 |
| silesia/mozilla | 51220480 | 3 | 199.8 ± 0.2% | 128.6 ± 0.5% | 0.64 |
| silesia/mr | 9970564 | 1 | 356.6 ± 0.4% | 141.3 ± 0.3% | 0.40 |
| silesia/mr | 9970564 | 3 | 161.3 ± 0.3% | 105.1 ± 0.4% | 0.65 |
| silesia/nci | 33553445 | 1 | 792.3 ± 1.6% | 357.6 ± 0.3% | 0.45 |
| silesia/nci | 33553445 | 3 | 603.8 ± 1.2% | 295.2 ± 0.9% | 0.49 |
| silesia/ooffice | 6152192 | 1 | 322.3 ± 0.1% | 125.4 ± 0.2% | 0.39 |
| silesia/ooffice | 6152192 | 3 | 137.5 ± 0.8% | 95.8 ± 1.6% | 0.70 |
| silesia/osdb | 10085684 | 1 | 385.8 ± 0.8% | 176.4 ± 0.4% | 0.46 |
| silesia/osdb | 10085684 | 3 | 192.3 ± 3.9% | 132.2 ± 1.1% | 0.69 |
| silesia/reymont | 6627202 | 1 | 273.0 ± 0.4% | 136.4 ± 0.4% | 0.50 |
| silesia/reymont | 6627202 | 3 | 182.2 ± 0.8% | 111.4 ± 0.2% | 0.61 |
| silesia/samba | 21606400 | 1 | 456.2 ± 0.4% | 204.8 ± 0.2% | 0.45 |
| silesia/samba | 21606400 | 3 | 279.1 ± 0.8% | 170.0 ± 0.3% | 0.61 |
| silesia/sao | 7251944 | 1 | 299.5 ± 2.5% | 117.0 ± 1.7% | 0.39 |
| silesia/sao | 7251944 | 3 | 101.5 ± 1.4% | 82.1 ± 14.3% | 0.81 |
| silesia/webster | 41458703 | 1 | 307.0 ± 0.7% | 130.2 ± 0.2% | 0.42 |
| silesia/webster | 41458703 | 3 | 172.4 ± 1.5% | 106.5 ± 0.7% | 0.62 |
| silesia/x-ray | 8474240 | 1 | 653.4 ± 0.3% | 121.9 ± 0.6% | 0.19 |
| silesia/x-ray | 8474240 | 3 | 100.1 ± 0.9% | 85.1 ± 0.7% | 0.85 |
| silesia/xml | 5345280 | 1 | 646.2 ± 2.1% | 264.3 ± 3.7% | 0.41 |
| silesia/xml | 5345280 | 3 | 460.8 ± 0.4% | 239.0 ± 0.2% | 0.52 |
| canterbury/alice29.txt | 152089 | 1 | 243.3 ± 0.3% | 118.3 ± 1.5% | 0.49 |
| canterbury/alice29.txt | 152089 | 3 | 160.7 ± 20.8% | 95.3 ± 5.2% | 0.59 |
| canterbury/asyoulik.txt | 125179 | 1 | 264.8 ± 6.2% | 113.7 ± 1.6% | 0.43 |
| canterbury/asyoulik.txt | 125179 | 3 | 168.9 ± 0.5% | 89.7 ± 0.4% | 0.53 |
| canterbury/cp.html | 24603 | 1 | 411.5 ± 0.2% | 182.3 ± 0.7% | 0.44 |
| canterbury/cp.html | 24603 | 3 | 274.1 ± 0.5% | 156.8 ± 0.7% | 0.57 |
| canterbury/fields.c | 11150 | 1 | 346.3 ± 3.2% | 177.4 ± 1.1% | 0.51 |
| canterbury/fields.c | 11150 | 3 | 288.0 ± 0.4% | 160.5 ± 0.7% | 0.56 |
| canterbury/grammar.lsp | 3721 | 1 | 287.2 ± 1.4% | 141.9 ± 5.2% | 0.49 |
| canterbury/grammar.lsp | 3721 | 3 | 234.8 ± 0.3% | 133.9 ± 0.2% | 0.57 |
| canterbury/kennedy.xls | 1029744 | 1 | 429.1 ± 0.2% | 188.7 ± 0.5% | 0.44 |
| canterbury/kennedy.xls | 1029744 | 3 | 368.3 ± 2.8% | 153.6 ± 2.7% | 0.42 |
| canterbury/lcet10.txt | 426754 | 1 | 267.1 ± 0.9% | 124.9 ± 1.0% | 0.47 |
| canterbury/lcet10.txt | 426754 | 3 | 167.3 ± 0.7% | 100.2 ± 7.8% | 0.60 |
| canterbury/plrabn12.txt | 481861 | 1 | 255.5 ± 2.0% | 108.1 ± 1.3% | 0.42 |
| canterbury/plrabn12.txt | 481861 | 3 | 135.5 ± 0.7% | 83.2 ± 0.5% | 0.61 |
| canterbury/ptt5 | 513216 | 1 | 864.2 ± 0.6% | 344.3 ± 0.5% | 0.40 |
| canterbury/ptt5 | 513216 | 3 | 597.7 ± 1.0% | 306.2 ± 0.6% | 0.51 |
| canterbury/sum | 38240 | 1 | 431.4 ± 0.6% | 166.3 ± 1.0% | 0.39 |
| canterbury/sum | 38240 | 3 | 290.3 ± 0.7% | 142.6 ± 0.6% | 0.49 |
| canterbury/xargs.1 | 4227 | 1 | 274.7 ± 0.2% | 140.2 ± 0.6% | 0.51 |
| canterbury/xargs.1 | 4227 | 3 | 205.0 ± 0.9% | 126.7 ± 0.8% | 0.62 |
| canterbury-large/E.coli | 4638690 | 1 | 251.3 ± 1.5% | 129.0 ± 0.7% | 0.51 |
| canterbury-large/E.coli | 4638690 | 3 | 183.6 ± 0.3% | 113.5 ± 0.7% | 0.62 |
| canterbury-large/bible.txt | 4047392 | 1 | 272.3 ± 0.4% | 134.8 ± 0.6% | 0.49 |
| canterbury-large/bible.txt | 4047392 | 3 | 177.7 ± 1.4% | 109.7 ± 0.8% | 0.62 |
| canterbury-large/world192.txt | 2473400 | 1 | 324.1 ± 0.7% | 141.0 ± 0.5% | 0.44 |
| canterbury-large/world192.txt | 2473400 | 3 | 198.7 ± 0.7% | 124.3 ± 0.4% | 0.63 |
| http/html-1kx1024 | 1048576 | 1 | 152.7 ± 7.9% | 71.1 ± 1.8% | 0.47 |
| http/html-1kx1024 | 1048576 | 3 | 128.9 ± 8.7% | 68.2 ± 26.8% | 0.53 |
| http/html-16kx64 | 1048576 | 1 | 345.7 ± 0.5% | 184.4 ± 0.6% | 0.53 |
| http/html-16kx64 | 1048576 | 3 | 295.9 ± 0.8% | 171.6 ± 0.5% | 0.58 |
| http/html-1m | 1048576 | 1 | 424.1 ± 0.2% | 204.6 ± 0.7% | 0.48 |
| http/html-1m | 1048576 | 3 | 311.1 ± 1.1% | 181.0 ± 0.3% | 0.58 |
| http/json-1kx1024 | 1048576 | 1 | 186.9 ± 0.3% | 86.7 ± 0.1% | 0.46 |
| http/json-1kx1024 | 1048576 | 3 | 174.9 ± 0.1% | 83.4 ± 3.4% | 0.48 |
| http/json-16kx64 | 1048576 | 1 | 575.9 ± 0.6% | 274.5 ± 3.4% | 0.48 |
| http/json-16kx64 | 1048576 | 3 | 493.1 ± 0.4% | 251.0 ± 0.6% | 0.51 |
| http/json-1m | 1048576 | 1 | 676.5 ± 0.7% | 298.8 ± 0.8% | 0.44 |
| http/json-1m | 1048576 | 3 | 489.3 ± 0.7% | 256.3 ± 0.4% | 0.52 |
| http/js-1kx1024 | 1048576 | 1 | 138.8 ± 3.0% | 64.0 ± 0.4% | 0.46 |
| http/js-1kx1024 | 1048576 | 3 | 113.2 ± 0.1% | 61.6 ± 0.7% | 0.54 |
| http/js-16kx64 | 1048576 | 1 | 301.1 ± 0.1% | 157.8 ± 0.9% | 0.52 |
| http/js-16kx64 | 1048576 | 3 | 256.8 ± 0.4% | 148.9 ± 0.6% | 0.58 |
| http/js-1m | 1048576 | 1 | 402.7 ± 2.0% | 189.5 ± 0.2% | 0.47 |
| http/js-1m | 1048576 | 3 | 291.2 ± 1.3% | 168.8 ± 0.6% | 0.58 |
| http/css-1kx1024 | 1048576 | 1 | 169.1 ± 0.6% | 78.5 ± 0.2% | 0.46 |
| http/css-1kx1024 | 1048576 | 3 | 151.8 ± 0.1% | 76.2 ± 0.3% | 0.50 |
| http/css-16kx64 | 1048576 | 1 | 446.7 ± 0.6% | 212.1 ± 0.2% | 0.47 |
| http/css-16kx64 | 1048576 | 3 | 400.6 ± 0.6% | 203.6 ± 0.6% | 0.51 |
| http/css-1m | 1048576 | 1 | 1917.7 ± 0.5% | 705.9 ± 0.3% | 0.37 |
| http/css-1m | 1048576 | 3 | 1500.3 ± 0.4% | 718.8 ± 2.3% | 0.48 |
| shuffled/dickens-1m | 1048576 | 1 | 995.7 ± 0.3% | 324.9 ± 1.6% | 0.33 |
| shuffled/dickens-1m | 1048576 | 3 | 110.0 ± 1.0% | 122.3 ± 0.5% | 1.11 |

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
| silesia/dickens | 10192446 | 35.9 | 664.9 ±0.4% | 858.1 ±0.3% | 1.29 |
| silesia/mozilla | 51220480 | 35.6 | 816.9 ±3.4% | 1009.7 ±0.3% | 1.24 |
| silesia/mr | 9970564 | 35.6 | 760.5 ±0.4% | 973.6 ±0.4% | 1.28 |
| silesia/nci | 33553445 | 8.4 | 1571.2 ±0.7% | 1920.0 ±0.5% | 1.22 |
| silesia/ooffice | 6152192 | 50.8 | 690.7 ±0.4% | 848.7 ±0.5% | 1.23 |
| silesia/osdb | 10085684 | 34.7 | 1037.3 ±0.3% | 1217.1 ±0.6% | 1.17 |
| silesia/reymont | 6627202 | 29.2 | 784.0 ±0.7% | 978.8 ±0.4% | 1.25 |
| silesia/samba | 21606400 | 22.9 | 1162.1 ±0.4% | 1377.6 ±0.8% | 1.19 |
| silesia/sao | 7251944 | 76.2 | 638.3 ±1.1% | 790.4 ±1.0% | 1.24 |
| silesia/webster | 41458703 | 29.2 | 725.8 ±4.0% | 920.3 ±3.4% | 1.27 |
| silesia/x-ray | 8474240 | 71.8 | 605.2 ±3.4% | 770.5 ±1.6% | 1.27 |
| silesia/xml | 5345280 | 11.9 | 1500.2 ±0.3% | 1789.1 ±0.4% | 1.19 |
| canterbury/alice29.txt | 152089 | 37.5 | 626.8 ±0.4% | 829.6 ±0.4% | 1.32 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 709.3 ±0.2% | 920.0 ±0.2% | 1.30 |
| canterbury/cp.html | 24603 | 34.4 | 854.7 ±0.5% | 1044.9 ±0.0% | 1.22 |
| canterbury/fields.c | 11150 | 30.3 | 716.4 ±0.6% | 864.4 ±0.3% | 1.21 |
| canterbury/grammar.lsp | 3721 | 34.8 | 556.4 ±0.2% | 606.9 ±0.2% | 1.09 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 877.4 ±3.0% | 1040.2 ±0.8% | 1.19 |
| canterbury/lcet10.txt | 426754 | 33.0 | 771.9 ±0.3% | 995.3 ±0.7% | 1.29 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 659.4 ±0.5% | 869.7 ±0.5% | 1.32 |
| canterbury/ptt5 | 513216 | 10.6 | 1703.1 ±0.6% | 2091.8 ±0.2% | 1.23 |
| canterbury/sum | 38240 | 35.0 | 859.4 ±1.7% | 998.4 ±1.2% | 1.16 |
| canterbury/xargs.1 | 4227 | 42.7 | 538.8 ±1.0% | 614.4 ±1.6% | 1.14 |
| canterbury-large/E.coli | 4638690 | 30.0 | 704.7 ±0.4% | 923.8 ±0.3% | 1.31 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 781.5 ±0.4% | 996.9 ±0.6% | 1.28 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 932.5 ±2.7% | 1122.1 ±0.5% | 1.20 |
| http/html-1kx1024 | 1048576 | 39.3 | 336.9 ±0.3% | 339.0 ±0.4% | 1.01 |
| http/html-16kx64 | 1048576 | 21.9 | 870.0 ±0.3% | 974.1 ±0.2% | 1.12 |
| http/html-1m | 1048576 | 17.7 | 1127.2 ±0.6% | 1345.7 ±0.3% | 1.19 |
| http/json-1kx1024 | 1048576 | 21.9 | 399.2 ±0.2% | 417.9 ±0.2% | 1.05 |
| http/json-16kx64 | 1048576 | 12.6 | 1137.8 ±0.2% | 1295.0 ±0.6% | 1.14 |
| http/json-1m | 1048576 | 12.2 | 1346.4 ±0.3% | 1671.2 ±0.5% | 1.24 |
| http/js-1kx1024 | 1048576 | 44.5 | 292.0 ±0.4% | 277.5 ±0.7% | 0.95 |
| http/js-16kx64 | 1048576 | 26.0 | 774.1 ±2.0% | 887.3 ±0.1% | 1.15 |
| http/js-1m | 1048576 | 19.0 | 1104.5 ±0.7% | 1315.8 ±0.4% | 1.19 |
| http/css-1kx1024 | 1048576 | 29.5 | 362.0 ±1.8% | 375.8 ±1.1% | 1.04 |
| http/css-16kx64 | 1048576 | 15.9 | 1036.4 ±0.1% | 1134.6 ±0.3% | 1.09 |
| http/css-1m | 1048576 | 3.6 | 3494.7 ±0.5% | 3652.9 ±0.5% | 1.05 |
| shuffled/dickens-1m | 1048576 | 58.8 | 901.3 ±0.5% | 1001.3 ±0.3% | 1.11 |
