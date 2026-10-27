# bench-zstd

| Field | Value |
|---|---|
| Commit | 27063af |
| Runner label | ubuntu-24.04 |
| Image version | 20261023.334.3 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/40590088368 |
| Date | 2026-10-27 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 672.2 ±1.0% | 872.3 ±0.9% | 1.30 |
| silesia/mozilla | 51220480 | 35.6 | 833.8 ±3.1% | 1014.9 ±1.1% | 1.22 |
| silesia/mr | 9970564 | 35.6 | 704.0 ±12.0% | 928.7 ±7.0% | 1.32 |
| silesia/nci | 33553445 | 8.4 | 1573.9 ±0.9% | 1918.2 ±0.8% | 1.22 |
| silesia/ooffice | 6152192 | 50.8 | 686.6 ±0.4% | 840.5 ±1.8% | 1.22 |
| silesia/osdb | 10085684 | 34.7 | 1042.8 ±0.7% | 1216.0 ±0.8% | 1.17 |
| silesia/reymont | 6627202 | 29.2 | 793.8 ±1.2% | 999.2 ±0.8% | 1.26 |
| silesia/samba | 21606400 | 22.9 | 1165.1 ±1.6% | 1359.8 ±5.2% | 1.17 |
| silesia/sao | 7251944 | 76.2 | 630.1 ±3.3% | 765.3 ±3.2% | 1.21 |
| silesia/webster | 41458703 | 29.2 | 804.4 ±2.6% | 980.5 ±13.8% | 1.22 |
| silesia/x-ray | 8474240 | 71.8 | 593.1 ±3.7% | 779.9 ±2.2% | 1.31 |
| silesia/xml | 5345280 | 11.9 | 1501.3 ±0.2% | 1788.3 ±0.3% | 1.19 |
| canterbury/alice29.txt | 152089 | 37.5 | 624.8 ±0.3% | 832.3 ±0.3% | 1.33 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 709.0 ±0.1% | 923.8 ±0.2% | 1.30 |
| canterbury/cp.html | 24603 | 34.4 | 877.4 ±5.3% | 1040.8 ±3.5% | 1.19 |
| canterbury/fields.c | 11150 | 30.3 | 711.8 ±22.3% | 881.9 ±1.9% | 1.24 |
| canterbury/grammar.lsp | 3721 | 34.8 | 552.7 ±0.3% | 631.4 ±0.4% | 1.14 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 876.4 ±0.3% | 1031.5 ±0.3% | 1.18 |
| canterbury/lcet10.txt | 426754 | 33.0 | 771.9 ±4.2% | 1010.0 ±0.7% | 1.31 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 660.7 ±0.2% | 878.1 ±0.4% | 1.33 |
| canterbury/ptt5 | 513216 | 10.6 | 1711.2 ±0.4% | 2066.0 ±0.1% | 1.21 |
| canterbury/sum | 38240 | 35.0 | 870.9 ±0.2% | 1008.7 ±0.5% | 1.16 |
| canterbury/xargs.1 | 4227 | 42.7 | 536.3 ±0.4% | 618.7 ±0.5% | 1.15 |
| canterbury-large/E.coli | 4638690 | 30.0 | 715.4 ±0.4% | 943.4 ±0.4% | 1.32 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 793.4 ±0.7% | 1011.3 ±0.5% | 1.27 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 943.1 ±0.5% | 1136.0 ±1.0% | 1.20 |
| http/html-1kx1024 | 1048576 | 39.3 | 334.6 ±0.2% | 329.0 ±0.1% | 0.98 |
| http/html-16kx64 | 1048576 | 21.9 | 868.4 ±1.6% | 968.4 ±0.2% | 1.12 |
| http/html-1m | 1048576 | 17.7 | 1132.5 ±0.2% | 1344.2 ±0.4% | 1.19 |
| http/json-1kx1024 | 1048576 | 21.9 | 397.0 ±0.2% | 403.6 ±0.1% | 1.02 |
| http/json-16kx64 | 1048576 | 12.6 | 1137.6 ±1.0% | 1281.8 ±0.4% | 1.13 |
| http/json-1m | 1048576 | 12.2 | 1347.1 ±0.4% | 1660.9 ±0.8% | 1.23 |
| http/js-1kx1024 | 1048576 | 44.5 | 290.2 ±0.4% | 270.4 ±0.5% | 0.93 |
| http/js-16kx64 | 1048576 | 26.0 | 774.7 ±0.1% | 884.8 ±0.2% | 1.14 |
| http/js-1m | 1048576 | 19.0 | 1104.7 ±0.5% | 1316.0 ±0.2% | 1.19 |
| http/css-1kx1024 | 1048576 | 29.5 | 359.2 ±0.3% | 362.6 ±0.1% | 1.01 |
| http/css-16kx64 | 1048576 | 15.9 | 1033.3 ±0.5% | 1128.3 ±0.3% | 1.09 |
| http/css-1m | 1048576 | 3.6 | 3438.9 ±1.2% | 3640.9 ±0.4% | 1.06 |
| shuffled/dickens-1m | 1048576 | 58.8 | 900.0 ±1.0% | 1030.0 ±4.1% | 1.14 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 209.2 ±0.6% | 875.5 ±4.5% | 4.19 |
| silesia/mozilla | 51220480 | 35.6 | 252.9 ±0.3% | 1019.6 ±0.5% | 4.03 |
| silesia/mr | 9970564 | 35.6 | 217.9 ±17.2% | 974.1 ±12.7% | 4.47 |
| silesia/nci | 33553445 | 8.4 | 591.8 ±0.5% | 1931.1 ±1.1% | 3.26 |
| silesia/ooffice | 6152192 | 50.8 | 183.6 ±0.1% | 839.5 ±0.7% | 4.57 |
| silesia/osdb | 10085684 | 34.7 | 293.9 ±0.9% | 1219.3 ±0.5% | 4.15 |
| silesia/reymont | 6627202 | 29.2 | 252.9 ±4.0% | 993.8 ±2.7% | 3.93 |
| silesia/samba | 21606400 | 22.9 | 363.3 ±7.1% | 1294.7 ±3.5% | 3.56 |
| silesia/sao | 7251944 | 76.2 | 168.5 ±0.2% | 778.8 ±0.6% | 4.62 |
| silesia/webster | 41458703 | 29.2 | 251.0 ±0.9% | 992.5 ±0.3% | 3.95 |
| silesia/x-ray | 8474240 | 71.8 | 157.4 ±1.0% | 792.4 ±1.1% | 5.03 |
| silesia/xml | 5345280 | 11.9 | 526.5 ±0.5% | 1791.6 ±0.1% | 3.40 |
| canterbury/alice29.txt | 152089 | 37.5 | 183.3 ±1.1% | 832.2 ±0.2% | 4.54 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 181.3 ±0.2% | 923.5 ±0.8% | 5.09 |
| canterbury/cp.html | 24603 | 34.4 | 239.4 ±0.4% | 1041.1 ±0.1% | 4.35 |
| canterbury/fields.c | 11150 | 30.3 | 218.2 ±0.5% | 867.0 ±0.5% | 3.97 |
| canterbury/grammar.lsp | 3721 | 34.8 | 189.7 ±0.4% | 637.1 ±0.2% | 3.36 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 261.9 ±0.1% | 1031.2 ±0.3% | 3.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 223.3 ±1.0% | 1004.0 ±0.3% | 4.50 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 185.1 ±0.2% | 870.1 ±0.2% | 4.70 |
| canterbury/ptt5 | 513216 | 10.6 | 420.7 ±0.3% | 2076.1 ±0.4% | 4.94 |
| canterbury/sum | 38240 | 35.0 | 235.0 ±0.2% | 1018.6 ±0.3% | 4.34 |
| canterbury/xargs.1 | 4227 | 42.7 | 166.8 ±7.4% | 619.4 ±0.6% | 3.71 |
| canterbury-large/E.coli | 4638690 | 30.0 | 224.0 ±0.3% | 943.4 ±0.6% | 4.21 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 255.9 ±0.4% | 1007.7 ±0.6% | 3.94 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 280.9 ±4.2% | 1118.4 ±5.7% | 3.98 |
| http/html-1kx1024 | 1048576 | 39.3 | 163.9 ±0.3% | 328.2 ±0.5% | 2.00 |
| http/html-16kx64 | 1048576 | 21.9 | 283.7 ±4.6% | 971.4 ±2.8% | 3.42 |
| http/html-1m | 1048576 | 17.7 | 375.0 ±10.7% | 1344.6 ±32.6% | 3.59 |
| http/json-1kx1024 | 1048576 | 21.9 | 231.4 ±0.3% | 401.7 ±0.8% | 1.74 |
| http/json-16kx64 | 1048576 | 12.6 | 400.4 ±0.2% | 1284.0 ±0.3% | 3.21 |
| http/json-1m | 1048576 | 12.2 | 450.0 ±0.1% | 1661.8 ±0.5% | 3.69 |
| http/js-1kx1024 | 1048576 | 44.5 | 135.6 ±0.5% | 267.8 ±0.4% | 1.97 |
| http/js-16kx64 | 1048576 | 26.0 | 245.1 ±0.2% | 884.8 ±6.2% | 3.61 |
| http/js-1m | 1048576 | 19.0 | 355.9 ±0.9% | 1311.9 ±1.1% | 3.69 |
| http/css-1kx1024 | 1048576 | 29.5 | 199.4 ±0.2% | 361.8 ±2.0% | 1.81 |
| http/css-16kx64 | 1048576 | 15.9 | 352.1 ±0.3% | 1130.4 ±0.6% | 3.21 |
| http/css-1m | 1048576 | 3.6 | 1432.9 ±0.6% | 3634.3 ±0.4% | 2.54 |
| shuffled/dickens-1m | 1048576 | 58.8 | 171.4 ±0.3% | 1031.4 ±0.3% | 6.02 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 871.6 ±0.8% | 0.92 ±6.4% | 1.00 ±9.4% | 0.49 ±6.0% | 0.99 ±1.5% | 0.32 ±0.9% |
| silesia/mozilla | 51220480 | 35.6 | 1014.6 ±0.6% | 0.72 ±0.2% | 1.00 ±0.3% | 0.55 ±0.2% | 1.00 ±0.5% | 0.39 ±0.6% |
| silesia/mr | 9970564 | 35.6 | 984.8 ±0.7% | 0.80 ±0.7% | 0.99 ±1.0% | 0.49 ±0.3% | 0.98 ±4.8% | 0.32 ±1.4% |
| silesia/nci | 33553445 | 8.4 | 1927.0 ±1.0% | 0.93 ±0.4% | 1.00 ±1.0% | 0.57 ±0.3% | 1.00 ±0.6% | 0.38 ±3.9% |
| silesia/ooffice | 6152192 | 50.8 | 840.1 ±0.8% | 0.60 ±0.3% | 1.00 ±1.0% | 0.54 ±0.1% | 0.98 ±2.1% | 0.40 ±3.9% |
| silesia/osdb | 10085684 | 34.7 | 1216.6 ±0.9% | 0.64 ±1.0% | 1.00 ±3.3% | 0.62 ±0.5% | 0.98 ±4.0% | 0.40 ±0.2% |
| silesia/reymont | 6627202 | 29.2 | 988.2 ±0.5% | 0.94 ±3.9% | 1.00 ±3.2% | 0.52 ±1.3% | 0.99 ±0.5% | 0.33 ±0.7% |
| silesia/samba | 21606400 | 22.9 | 1338.2 ±6.2% | 0.84 ±11.2% | 0.96 ±5.9% | 0.54 ±5.6% | 0.98 ±7.6% | 0.37 ±5.7% |
| silesia/sao | 7251944 | 76.2 | 776.4 ±0.8% | 0.49 ±5.2% | 1.00 ±21.9% | 0.65 ±0.8% | 0.99 ±2.5% | 0.47 ±4.1% |
| silesia/webster | 41458703 | 29.2 | 987.0 ±0.7% | 0.91 ±0.5% | 1.00 ±3.6% | 0.52 ±0.4% | 1.00 ±0.3% | 0.34 ±0.5% |
| silesia/x-ray | 8474240 | 71.8 | 790.7 ±0.7% | 0.49 ±0.3% | 1.00 ±0.4% | 0.61 ±1.2% | 0.98 ±0.4% | 0.43 ±0.8% |
| silesia/xml | 5345280 | 11.9 | 1790.0 ±0.4% | 0.92 ±0.2% | 1.00 ±1.6% | 0.57 ±2.1% | 0.99 ±0.7% | 0.38 ±1.4% |
| canterbury/alice29.txt | 152089 | 37.5 | 818.4 ±0.3% | 0.95 ±8.0% | 1.02 ±0.5% | 0.49 ±0.7% | 1.01 ±0.3% | 0.31 ±0.3% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 912.7 ±0.1% | 0.85 ±0.1% | 0.99 ±0.3% | 0.48 ±0.2% | 0.99 ±0.7% | 0.32 ±5.7% |
| canterbury/cp.html | 24603 | 34.4 | 1049.0 ±0.2% | 0.62 ±0.3% | 1.00 ±0.2% | 0.64 ±0.2% | 0.99 ±0.2% | 0.42 ±0.4% |
| canterbury/fields.c | 11150 | 30.3 | 876.6 ±0.1% | 0.80 ±0.6% | 1.00 ±0.4% | 0.59 ±0.5% | 0.96 ±0.3% | 0.37 ±0.6% |
| canterbury/grammar.lsp | 3721 | 34.8 | 629.5 ±0.4% | 0.79 ±0.8% | 1.00 ±0.5% | 0.66 ±0.1% | 1.00 ±0.3% | 0.46 ±0.5% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1027.5 ±0.3% | 0.86 ±0.1% | 1.01 ±4.2% | 0.51 ±0.2% | 1.00 ±0.4% | 0.32 ±0.1% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1002.0 ±0.2% | 0.89 ±0.4% | 1.00 ±0.6% | 0.49 ±0.2% | 0.98 ±4.8% | 0.32 ±4.2% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 873.1 ±2.2% | 0.90 ±0.4% | 0.99 ±0.1% | 0.46 ±0.4% | 0.98 ±0.3% | 0.31 ±0.3% |
| canterbury/ptt5 | 513216 | 10.6 | 2070.0 ±0.3% | 0.80 ±0.2% | 1.01 ±0.7% | 0.51 ±0.1% | 0.99 ±0.3% | 0.40 ±0.2% |
| canterbury/sum | 38240 | 35.0 | 1016.0 ±1.5% | 0.63 ±0.3% | 1.00 ±0.1% | 0.65 ±0.6% | 0.99 ±0.2% | 0.42 ±1.2% |
| canterbury/xargs.1 | 4227 | 42.7 | 612.7 ±0.4% | 0.72 ±0.3% | 0.99 ±0.6% | 0.64 ±0.2% | 1.00 ±1.5% | 0.43 ±0.3% |
| canterbury-large/E.coli | 4638690 | 30.0 | 940.4 ±1.2% | 0.98 ±0.9% | 1.00 ±0.9% | 0.50 ±0.5% | 0.98 ±0.6% | 0.31 ±0.4% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1004.2 ±1.3% | 0.94 ±4.6% | 1.00 ±3.6% | 0.51 ±5.3% | 0.99 ±0.4% | 0.32 ±0.5% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1134.5 ±0.6% | 0.88 ±0.3% | 1.00 ±0.6% | 0.53 ±0.5% | 0.99 ±0.5% | 0.35 ±0.5% |
| http/html-1kx1024 | 1048576 | 39.3 | 328.5 ±0.1% | 0.88 ±0.4% | 1.00 ±3.4% | 0.78 ±0.3% | 0.98 ±0.1% | 0.65 ±0.4% |
| http/html-16kx64 | 1048576 | 21.9 | 970.6 ±0.3% | 0.83 ±0.5% | 1.00 ±0.2% | 0.59 ±0.2% | 1.00 ±0.3% | 0.42 ±0.2% |
| http/html-1m | 1048576 | 17.7 | 1343.8 ±0.3% | 0.94 ±0.3% | 1.00 ±0.2% | 0.55 ±0.2% | 0.99 ±0.3% | 0.35 ±0.6% |
| http/json-1kx1024 | 1048576 | 21.9 | 402.0 ±0.3% | 0.98 ±0.2% | 0.99 ±0.1% | 0.81 ±0.6% | 0.99 ±0.1% | 0.67 ±0.6% |
| http/json-16kx64 | 1048576 | 12.6 | 1289.1 ±0.5% | 0.84 ±0.3% | 0.98 ±0.6% | 0.61 ±0.2% | 0.99 ±0.4% | 0.43 ±0.4% |
| http/json-1m | 1048576 | 12.2 | 1665.0 ±0.2% | 0.87 ±0.5% | 1.00 ±0.4% | 0.54 ±2.8% | 0.99 ±0.4% | 0.36 ±0.1% |
| http/js-1kx1024 | 1048576 | 44.5 | 268.1 ±0.5% | 0.88 ±0.2% | 1.01 ±0.6% | 0.78 ±0.3% | 1.00 ±0.3% | 0.66 ±0.4% |
| http/js-16kx64 | 1048576 | 26.0 | 818.7 ±0.3% | 0.88 ±0.2% | 1.09 ±0.6% | 0.61 ±0.3% | 1.08 ±0.2% | 0.44 ±0.2% |
| http/js-1m | 1048576 | 19.0 | 1315.5 ±0.5% | 0.91 ±0.2% | 1.00 ±0.3% | 0.55 ±0.2% | 0.99 ±0.4% | 0.35 ±0.8% |
| http/css-1kx1024 | 1048576 | 29.5 | 360.0 ±5.4% | 0.95 ±0.3% | 1.00 ±0.4% | 0.79 ±0.5% | 0.99 ±1.2% | 0.65 ±0.3% |
| http/css-16kx64 | 1048576 | 15.9 | 1124.3 ±0.4% | 0.88 ±0.3% | 1.01 ±0.4% | 0.62 ±0.4% | 1.00 ±0.1% | 0.42 ±0.2% |
| http/css-1m | 1048576 | 3.6 | 3643.5 ±0.7% | 0.95 ±0.4% | 1.00 ±0.5% | 0.70 ±1.1% | 0.99 ±0.4% | 0.44 ±0.4% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1030.8 ±0.8% | 0.50 ±0.6% | 0.86 ±0.4% | 0.70 ±0.2% | 0.98 ±3.6% | 0.50 ±0.2% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 267.3 ± 47.2% | 92.6 ± 4.7% | 0.35 |
| silesia/dickens | 10192446 | 3 | 147.9 ± 0.2% | 80.2 ± 0.4% | 0.54 |
| silesia/mozilla | 51220480 | 1 | 394.0 ± 4.1% | 130.4 ± 0.5% | 0.33 |
| silesia/mozilla | 51220480 | 3 | 213.1 ± 0.4% | 113.2 ± 0.4% | 0.53 |
| silesia/mr | 9970564 | 1 | 358.1 ± 0.2% | 116.8 ± 0.5% | 0.33 |
| silesia/mr | 9970564 | 3 | 174.3 ± 5.2% | 93.1 ± 0.4% | 0.53 |
| silesia/nci | 33553445 | 1 | 806.0 ± 3.9% | 296.3 ± 0.6% | 0.37 |
| silesia/nci | 33553445 | 3 | 629.1 ± 1.0% | 261.1 ± 0.2% | 0.42 |
| silesia/ooffice | 6152192 | 1 | 323.0 ± 0.7% | 100.5 ± 0.2% | 0.31 |
| silesia/ooffice | 6152192 | 3 | 146.1 ± 0.4% | 83.2 ± 0.7% | 0.57 |
| silesia/osdb | 10085684 | 1 | 390.0 ± 0.3% | 142.8 ± 0.3% | 0.37 |
| silesia/osdb | 10085684 | 3 | 207.8 ± 0.3% | 117.5 ± 1.0% | 0.57 |
| silesia/reymont | 6627202 | 1 | 276.0 ± 0.4% | 111.5 ± 0.8% | 0.40 |
| silesia/reymont | 6627202 | 3 | 195.9 ± 0.3% | 101.6 ± 0.7% | 0.52 |
| silesia/samba | 21606400 | 1 | 462.4 ± 0.5% | 168.5 ± 0.3% | 0.36 |
| silesia/samba | 21606400 | 3 | 294.8 ± 0.4% | 149.6 ± 1.0% | 0.51 |
| silesia/sao | 7251944 | 1 | 302.0 ± 0.3% | 94.1 ± 0.3% | 0.31 |
| silesia/sao | 7251944 | 3 | 110.7 ± 1.0% | 72.6 ± 0.5% | 0.66 |
| silesia/webster | 41458703 | 1 | 310.8 ± 0.4% | 112.5 ± 0.1% | 0.36 |
| silesia/webster | 41458703 | 3 | 183.8 ± 0.3% | 98.1 ± 0.4% | 0.53 |
| silesia/x-ray | 8474240 | 1 | 658.7 ± 0.1% | 97.6 ± 1.7% | 0.15 |
| silesia/x-ray | 8474240 | 3 | 107.4 ± 0.7% | 74.4 ± 1.4% | 0.69 |
| silesia/xml | 5345280 | 1 | 653.3 ± 0.1% | 223.8 ± 0.4% | 0.34 |
| silesia/xml | 5345280 | 3 | 479.5 ± 0.7% | 217.9 ± 0.5% | 0.45 |
| canterbury/alice29.txt | 152089 | 1 | 243.8 ± 0.3% | 98.1 ± 0.4% | 0.40 |
| canterbury/alice29.txt | 152089 | 3 | 169.3 ± 0.8% | 84.4 ± 0.4% | 0.50 |
| canterbury/asyoulik.txt | 125179 | 1 | 262.7 ± 0.1% | 92.7 ± 0.4% | 0.35 |
| canterbury/asyoulik.txt | 125179 | 3 | 173.5 ± 3.7% | 80.4 ± 0.7% | 0.46 |
| canterbury/cp.html | 24603 | 1 | 420.4 ± 0.3% | 142.4 ± 0.6% | 0.34 |
| canterbury/cp.html | 24603 | 3 | 277.6 ± 0.7% | 132.8 ± 0.4% | 0.48 |
| canterbury/fields.c | 11150 | 1 | 344.9 ± 0.8% | 157.3 ± 1.4% | 0.46 |
| canterbury/fields.c | 11150 | 3 | 288.4 ± 0.3% | 148.2 ± 0.7% | 0.51 |
| canterbury/grammar.lsp | 3721 | 1 | 284.9 ± 0.3% | 126.6 ± 0.2% | 0.44 |
| canterbury/grammar.lsp | 3721 | 3 | 231.0 ± 0.3% | 123.3 ± 1.0% | 0.53 |
| canterbury/kennedy.xls | 1029744 | 1 | 429.1 ± 0.3% | 159.1 ± 0.5% | 0.37 |
| canterbury/kennedy.xls | 1029744 | 3 | 377.8 ± 0.3% | 140.0 ± 0.5% | 0.37 |
| canterbury/lcet10.txt | 426754 | 1 | 267.0 ± 0.4% | 103.7 ± 0.5% | 0.39 |
| canterbury/lcet10.txt | 426754 | 3 | 173.8 ± 2.5% | 90.6 ± 2.1% | 0.52 |
| canterbury/plrabn12.txt | 481861 | 1 | 256.8 ± 0.5% | 87.8 ± 0.3% | 0.34 |
| canterbury/plrabn12.txt | 481861 | 3 | 142.6 ± 0.9% | 76.0 ± 0.8% | 0.53 |
| canterbury/ptt5 | 513216 | 1 | 865.0 ± 1.3% | 293.3 ± 0.4% | 0.34 |
| canterbury/ptt5 | 513216 | 3 | 619.0 ± 1.1% | 273.0 ± 0.8% | 0.44 |
| canterbury/sum | 38240 | 1 | 434.1 ± 0.3% | 133.5 ± 0.4% | 0.31 |
| canterbury/sum | 38240 | 3 | 291.9 ± 1.6% | 121.8 ± 0.7% | 0.42 |
| canterbury/xargs.1 | 4227 | 1 | 274.6 ± 0.2% | 121.0 ± 0.4% | 0.44 |
| canterbury/xargs.1 | 4227 | 3 | 206.6 ± 1.2% | 114.3 ± 0.4% | 0.55 |
| canterbury-large/E.coli | 4638690 | 1 | 253.2 ± 0.1% | 104.9 ± 0.6% | 0.41 |
| canterbury-large/E.coli | 4638690 | 3 | 197.7 ± 0.3% | 102.9 ± 0.2% | 0.52 |
| canterbury-large/bible.txt | 4047392 | 1 | 274.9 ± 1.9% | 111.8 ± 0.4% | 0.41 |
| canterbury-large/bible.txt | 4047392 | 3 | 190.1 ± 1.0% | 100.6 ± 0.6% | 0.53 |
| canterbury-large/world192.txt | 2473400 | 1 | 328.3 ± 0.4% | 123.0 ± 0.5% | 0.37 |
| canterbury-large/world192.txt | 2473400 | 3 | 212.0 ± 0.3% | 114.2 ± 4.6% | 0.54 |
| http/html-1kx1024 | 1048576 | 1 | 152.7 ± 0.4% | 64.7 ± 4.7% | 0.42 |
| http/html-1kx1024 | 1048576 | 3 | 129.4 ± 0.2% | 63.4 ± 0.6% | 0.49 |
| http/html-16kx64 | 1048576 | 1 | 348.4 ± 0.2% | 153.5 ± 0.2% | 0.44 |
| http/html-16kx64 | 1048576 | 3 | 296.6 ± 0.2% | 148.7 ± 0.5% | 0.50 |
| http/html-1m | 1048576 | 1 | 428.7 ± 0.2% | 173.8 ± 3.1% | 0.41 |
| http/html-1m | 1048576 | 3 | 324.6 ± 0.6% | 162.9 ± 0.4% | 0.50 |
| http/json-1kx1024 | 1048576 | 1 | 186.6 ± 0.5% | 80.1 ± 0.3% | 0.43 |
| http/json-1kx1024 | 1048576 | 3 | 174.2 ± 0.4% | 78.6 ± 0.5% | 0.45 |
| http/json-16kx64 | 1048576 | 1 | 577.3 ± 0.4% | 225.1 ± 0.2% | 0.39 |
| http/json-16kx64 | 1048576 | 3 | 494.3 ± 0.4% | 215.3 ± 0.4% | 0.44 |
| http/json-1m | 1048576 | 1 | 684.4 ± 0.2% | 247.6 ± 0.6% | 0.36 |
| http/json-1m | 1048576 | 3 | 502.5 ± 2.7% | 226.3 ± 0.5% | 0.45 |
| http/js-1kx1024 | 1048576 | 1 | 139.4 ± 0.2% | 57.6 ± 0.8% | 0.41 |
| http/js-1kx1024 | 1048576 | 3 | 113.8 ± 0.9% | 56.3 ± 0.5% | 0.50 |
| http/js-16kx64 | 1048576 | 1 | 302.9 ± 2.8% | 128.4 ± 6.3% | 0.42 |
| http/js-16kx64 | 1048576 | 3 | 258.6 ± 0.2% | 127.9 ± 0.6% | 0.49 |
| http/js-1m | 1048576 | 1 | 406.9 ± 0.9% | 158.6 ± 0.4% | 0.39 |
| http/js-1m | 1048576 | 3 | 305.5 ± 0.6% | 152.3 ± 0.2% | 0.50 |
| http/css-1kx1024 | 1048576 | 1 | 168.7 ± 0.2% | 72.5 ± 0.2% | 0.43 |
| http/css-1kx1024 | 1048576 | 3 | 151.3 ± 0.3% | 71.5 ± 0.7% | 0.47 |
| http/css-16kx64 | 1048576 | 1 | 448.3 ± 0.3% | 174.7 ± 0.3% | 0.39 |
| http/css-16kx64 | 1048576 | 3 | 404.1 ± 0.3% | 176.0 ± 0.5% | 0.44 |
| http/css-1m | 1048576 | 1 | 1925.5 ± 0.7% | 596.0 ± 0.7% | 0.31 |
| http/css-1m | 1048576 | 3 | 1516.0 ± 0.4% | 635.2 ± 0.8% | 0.42 |
| shuffled/dickens-1m | 1048576 | 1 | 977.6 ± 1.6% | 191.2 ± 0.3% | 0.20 |
| shuffled/dickens-1m | 1048576 | 3 | 117.8 ± 6.2% | 121.0 ± 1.0% | 1.03 |

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
| silesia/dickens | 10192446 | 35.9 | 575.3 ±0.1% | 895.9 ±0.4% | 1.56 |
| silesia/mozilla | 51220480 | 35.6 | 751.8 ±0.8% | 1016.6 ±1.5% | 1.35 |
| silesia/mr | 9970564 | 35.6 | 667.4 ±0.3% | 1023.6 ±0.3% | 1.53 |
| silesia/nci | 33553445 | 8.4 | 1481.8 ±1.0% | 1947.9 ±1.2% | 1.31 |
| silesia/ooffice | 6152192 | 50.8 | 622.6 ±0.6% | 854.9 ±0.6% | 1.37 |
| silesia/osdb | 10085684 | 34.7 | 934.6 ±0.7% | 1240.1 ±0.5% | 1.33 |
| silesia/reymont | 6627202 | 29.2 | 685.9 ±0.3% | 1014.8 ±0.1% | 1.48 |
| silesia/samba | 21606400 | 22.9 | 1046.9 ±0.6% | 1397.4 ±1.0% | 1.33 |
| silesia/sao | 7251944 | 76.2 | 596.5 ±0.2% | 795.1 ±1.0% | 1.33 |
| silesia/webster | 41458703 | 29.2 | 707.3 ±2.7% | 1004.4 ±1.9% | 1.42 |
| silesia/x-ray | 8474240 | 71.8 | 551.9 ±0.4% | 804.8 ±0.3% | 1.46 |
| silesia/xml | 5345280 | 11.9 | 1368.9 ±0.2% | 1804.6 ±0.3% | 1.32 |
| canterbury/alice29.txt | 152089 | 37.5 | 518.5 ±0.2% | 832.8 ±0.1% | 1.61 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 595.0 ±0.4% | 913.4 ±0.2% | 1.54 |
| canterbury/cp.html | 24603 | 34.4 | 771.1 ±0.2% | 1040.7 ±0.1% | 1.35 |
| canterbury/fields.c | 11150 | 30.3 | 580.7 ±0.2% | 869.0 ±0.4% | 1.50 |
| canterbury/grammar.lsp | 3721 | 34.8 | 549.6 ±0.3% | 622.3 ±0.6% | 1.13 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 748.7 ±0.2% | 1037.2 ±0.2% | 1.39 |
| canterbury/lcet10.txt | 426754 | 33.0 | 649.0 ±0.6% | 1004.2 ±0.2% | 1.55 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 548.5 ±0.3% | 879.1 ±0.3% | 1.60 |
| canterbury/ptt5 | 513216 | 10.6 | 1614.5 ±0.3% | 2106.7 ±0.2% | 1.30 |
| canterbury/sum | 38240 | 35.0 | 760.4 ±0.2% | 1020.9 ±0.1% | 1.34 |
| canterbury/xargs.1 | 4227 | 42.7 | 536.5 ±0.6% | 614.2 ±0.3% | 1.14 |
| canterbury-large/E.coli | 4638690 | 30.0 | 599.0 ±0.6% | 852.3 ±0.1% | 1.42 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 674.5 ±0.3% | 1025.2 ±0.4% | 1.52 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 828.0 ±0.2% | 1148.6 ±0.5% | 1.39 |
| http/html-1kx1024 | 1048576 | 39.3 | 331.6 ±0.6% | 338.7 ±0.2% | 1.02 |
| http/html-16kx64 | 1048576 | 21.9 | 770.9 ±0.4% | 973.0 ±0.2% | 1.26 |
| http/html-1m | 1048576 | 17.7 | 1006.7 ±0.3% | 1356.3 ±0.2% | 1.35 |
| http/json-1kx1024 | 1048576 | 21.9 | 396.6 ±0.4% | 419.7 ±0.2% | 1.06 |
| http/json-16kx64 | 1048576 | 12.6 | 1073.3 ±0.1% | 1228.1 ±0.2% | 1.14 |
| http/json-1m | 1048576 | 12.2 | 1244.3 ±0.6% | 1673.6 ±0.5% | 1.34 |
| http/js-1kx1024 | 1048576 | 44.5 | 288.5 ±0.1% | 278.5 ±0.3% | 0.97 |
| http/js-16kx64 | 1048576 | 26.0 | 682.5 ±0.2% | 890.6 ±0.9% | 1.30 |
| http/js-1m | 1048576 | 19.0 | 972.6 ±0.3% | 1328.2 ±1.0% | 1.37 |
| http/css-1kx1024 | 1048576 | 29.5 | 359.0 ±2.0% | 376.8 ±0.3% | 1.05 |
| http/css-16kx64 | 1048576 | 15.9 | 890.7 ±0.2% | 1137.8 ±0.4% | 1.28 |
| http/css-1m | 1048576 | 3.6 | 3187.0 ±0.7% | 3581.0 ±0.4% | 1.12 |
| shuffled/dickens-1m | 1048576 | 58.8 | 867.7 ±0.4% | 1040.7 ±0.5% | 1.20 |
