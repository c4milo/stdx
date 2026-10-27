# bench-zstd

| Field | Value |
|---|---|
| Commit | 9cd44f7 |
| Runner label | ubuntu-24.04 |
| Image version | 20261023.334.3 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/40535059200 |
| Date | 2026-10-27 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 855.4 ±1.2% | 1142.2 ±1.4% | 1.34 |
| silesia/mozilla | 51220480 | 35.6 | 963.7 ±14.0% | 1224.1 ±8.7% | 1.27 |
| silesia/mr | 9970564 | 35.6 | 958.8 ±7.0% | 1267.8 ±2.6% | 1.32 |
| silesia/nci | 33553445 | 8.4 | 1686.3 ±6.4% | 2368.5 ±5.9% | 1.40 |
| silesia/ooffice | 6152192 | 50.8 | 832.3 ±0.4% | 1053.8 ±0.4% | 1.27 |
| silesia/osdb | 10085684 | 34.7 | 1271.7 ±0.4% | 1529.9 ±1.8% | 1.20 |
| silesia/reymont | 6627202 | 29.2 | 982.4 ±1.3% | 1282.5 ±0.5% | 1.31 |
| silesia/samba | 21606400 | 22.9 | 1379.4 ±0.7% | 1704.8 ±1.2% | 1.24 |
| silesia/sao | 7251944 | 76.2 | 799.0 ±3.8% | 1022.6 ±4.4% | 1.28 |
| silesia/webster | 41458703 | 29.2 | 950.5 ±2.8% | 1197.9 ±12.7% | 1.26 |
| silesia/x-ray | 8474240 | 71.8 | 791.9 ±0.2% | 993.5 ±0.4% | 1.25 |
| silesia/xml | 5345280 | 11.9 | 1713.6 ±1.2% | 2224.1 ±0.7% | 1.30 |
| canterbury/alice29.txt | 152089 | 37.5 | 777.5 ±0.2% | 1036.1 ±0.5% | 1.33 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 883.5 ±0.4% | 1148.9 ±0.2% | 1.30 |
| canterbury/cp.html | 24603 | 34.4 | 1112.6 ±0.1% | 1347.0 ±0.1% | 1.21 |
| canterbury/fields.c | 11150 | 30.3 | 917.7 ±0.5% | 1095.5 ±0.2% | 1.19 |
| canterbury/grammar.lsp | 3721 | 34.8 | 730.9 ±0.6% | 829.1 ±0.1% | 1.13 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1033.3 ±0.4% | 1256.3 ±0.6% | 1.22 |
| canterbury/lcet10.txt | 426754 | 33.0 | 950.7 ±0.2% | 1278.9 ±0.1% | 1.35 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 829.6 ±1.5% | 1100.3 ±0.9% | 1.33 |
| canterbury/ptt5 | 513216 | 10.6 | 2482.4 ±0.3% | 2932.0 ±0.1% | 1.18 |
| canterbury/sum | 38240 | 35.0 | 1108.4 ±0.1% | 1297.3 ±0.1% | 1.17 |
| canterbury/xargs.1 | 4227 | 42.7 | 710.7 ±0.3% | 807.9 ±0.2% | 1.14 |
| canterbury-large/E.coli | 4638690 | 30.0 | 897.7 ±0.1% | 1210.6 ±0.8% | 1.35 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 979.9 ±0.6% | 1300.9 ±0.3% | 1.33 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1139.1 ±0.3% | 1423.7 ±0.4% | 1.25 |
| http/html-1kx1024 | 1048576 | 39.3 | 429.9 ±0.2% | 421.8 ±1.3% | 0.98 |
| http/html-16kx64 | 1048576 | 21.9 | 1053.5 ±0.4% | 1236.7 ±1.0% | 1.17 |
| http/html-1m | 1048576 | 17.7 | 1344.8 ±2.6% | 1738.4 ±9.1% | 1.29 |
| http/json-1kx1024 | 1048576 | 21.9 | 501.1 ±0.2% | 519.7 ±0.2% | 1.04 |
| http/json-16kx64 | 1048576 | 12.6 | 1368.9 ±0.7% | 1759.3 ±0.4% | 1.29 |
| http/json-1m | 1048576 | 12.2 | 1564.4 ±0.5% | 2301.8 ±0.2% | 1.47 |
| http/js-1kx1024 | 1048576 | 44.5 | 376.1 ±0.1% | 349.4 ±0.4% | 0.93 |
| http/js-16kx64 | 1048576 | 26.0 | 952.3 ±2.3% | 1142.2 ±0.3% | 1.20 |
| http/js-1m | 1048576 | 19.0 | 1329.9 ±0.1% | 1762.0 ±0.6% | 1.32 |
| http/css-1kx1024 | 1048576 | 29.5 | 460.8 ±0.4% | 463.7 ±1.7% | 1.01 |
| http/css-16kx64 | 1048576 | 15.9 | 1294.9 ±0.9% | 1524.2 ±0.5% | 1.18 |
| http/css-1m | 1048576 | 3.6 | 4063.4 ±0.2% | 5206.4 ±0.2% | 1.28 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1154.6 ±0.4% | 1353.2 ±0.8% | 1.17 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 269.5 ±1.2% | 1140.0 ±2.0% | 4.23 |
| silesia/mozilla | 51220480 | 35.6 | 313.1 ±1.4% | 1224.5 ±2.3% | 3.91 |
| silesia/mr | 9970564 | 35.6 | 278.4 ±2.8% | 1271.2 ±0.7% | 4.57 |
| silesia/nci | 33553445 | 8.4 | 746.2 ±2.0% | 2353.0 ±2.2% | 3.15 |
| silesia/ooffice | 6152192 | 50.8 | 226.1 ±0.8% | 1050.4 ±0.6% | 4.65 |
| silesia/osdb | 10085684 | 34.7 | 367.7 ±11.2% | 1534.1 ±0.6% | 4.17 |
| silesia/reymont | 6627202 | 29.2 | 328.5 ±0.7% | 1284.9 ±0.7% | 3.91 |
| silesia/samba | 21606400 | 22.9 | 493.1 ±0.4% | 1707.0 ±1.0% | 3.46 |
| silesia/sao | 7251944 | 76.2 | 204.1 ±1.3% | 1031.3 ±4.1% | 5.05 |
| silesia/webster | 41458703 | 29.2 | 309.7 ±4.2% | 1164.1 ±8.3% | 3.76 |
| silesia/x-ray | 8474240 | 71.8 | 190.2 ±0.3% | 990.3 ±0.6% | 5.21 |
| silesia/xml | 5345280 | 11.9 | 666.5 ±0.5% | 2225.2 ±0.3% | 3.34 |
| canterbury/alice29.txt | 152089 | 37.5 | 236.5 ±0.2% | 1023.8 ±0.5% | 4.33 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 227.3 ±0.3% | 1146.0 ±0.5% | 5.04 |
| canterbury/cp.html | 24603 | 34.4 | 323.8 ±1.3% | 1343.7 ±0.6% | 4.15 |
| canterbury/fields.c | 11150 | 30.3 | 306.8 ±0.2% | 1143.5 ±0.1% | 3.73 |
| canterbury/grammar.lsp | 3721 | 34.8 | 261.8 ±0.9% | 849.4 ±0.2% | 3.24 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 333.6 ±0.6% | 1259.0 ±0.3% | 3.77 |
| canterbury/lcet10.txt | 426754 | 33.0 | 284.0 ±0.5% | 1282.2 ±0.3% | 4.51 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 233.6 ±1.9% | 1099.2 ±21.0% | 4.71 |
| canterbury/ptt5 | 513216 | 10.6 | 520.5 ±0.5% | 2911.5 ±0.7% | 5.59 |
| canterbury/sum | 38240 | 35.0 | 313.6 ±0.5% | 1284.4 ±0.3% | 4.10 |
| canterbury/xargs.1 | 4227 | 42.7 | 227.4 ±1.8% | 812.4 ±0.2% | 3.57 |
| canterbury-large/E.coli | 4638690 | 30.0 | 287.6 ±2.2% | 1212.4 ±1.2% | 4.22 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 332.4 ±2.6% | 1302.4 ±0.7% | 3.92 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 364.7 ±1.1% | 1425.3 ±0.5% | 3.91 |
| http/html-1kx1024 | 1048576 | 39.3 | 208.0 ±1.4% | 422.6 ±0.1% | 2.03 |
| http/html-16kx64 | 1048576 | 21.9 | 357.8 ±0.3% | 1236.1 ±0.9% | 3.45 |
| http/html-1m | 1048576 | 17.7 | 470.5 ±0.3% | 1774.0 ±0.3% | 3.77 |
| http/json-1kx1024 | 1048576 | 21.9 | 300.8 ±0.4% | 518.2 ±0.5% | 1.72 |
| http/json-16kx64 | 1048576 | 12.6 | 507.6 ±2.3% | 1754.1 ±0.9% | 3.46 |
| http/json-1m | 1048576 | 12.2 | 562.5 ±10.7% | 2314.2 ±6.0% | 4.11 |
| http/js-1kx1024 | 1048576 | 44.5 | 172.5 ±0.3% | 349.2 ±0.2% | 2.02 |
| http/js-16kx64 | 1048576 | 26.0 | 307.4 ±2.5% | 1134.8 ±1.2% | 3.69 |
| http/js-1m | 1048576 | 19.0 | 450.6 ±0.2% | 1754.6 ±0.6% | 3.89 |
| http/css-1kx1024 | 1048576 | 29.5 | 253.9 ±2.8% | 464.6 ±0.2% | 1.83 |
| http/css-16kx64 | 1048576 | 15.9 | 446.4 ±0.4% | 1525.4 ±0.2% | 3.42 |
| http/css-1m | 1048576 | 3.6 | 1839.9 ±0.6% | 5227.3 ±0.7% | 2.84 |
| shuffled/dickens-1m | 1048576 | 58.8 | 201.9 ±1.6% | 1361.2 ±1.0% | 6.74 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 1142.1 ±1.2% | 0.92 ±0.8% | 1.00 ±1.4% | 0.49 ±1.0% | 0.98 ±0.8% | 0.32 ±2.1% |
| silesia/mozilla | 51220480 | 35.6 | 1216.3 ±2.7% | 0.71 ±2.4% | 1.00 ±2.0% | 0.56 ±3.9% | 0.99 ±2.6% | 0.40 ±1.9% |
| silesia/mr | 9970564 | 35.6 | 1269.5 ±0.7% | 0.78 ±0.6% | 1.00 ±0.3% | 0.49 ±0.7% | 0.99 ±0.9% | 0.34 ±1.1% |
| silesia/nci | 33553445 | 8.4 | 2422.2 ±2.0% | 0.93 ±4.8% | 0.99 ±6.8% | 0.57 ±7.5% | 1.00 ±1.3% | 0.39 ±2.8% |
| silesia/ooffice | 6152192 | 50.8 | 1051.7 ±0.3% | 0.59 ±0.1% | 1.00 ±0.6% | 0.55 ±0.1% | 0.98 ±0.7% | 0.41 ±0.6% |
| silesia/osdb | 10085684 | 34.7 | 1534.7 ±0.8% | 0.63 ±0.8% | 1.00 ±13.0% | 0.64 ±1.4% | 0.99 ±0.8% | 0.42 ±0.9% |
| silesia/reymont | 6627202 | 29.2 | 1253.9 ±1.5% | 0.95 ±0.3% | 0.94 ±0.7% | 0.53 ±1.2% | 1.01 ±0.5% | 0.34 ±1.0% |
| silesia/samba | 21606400 | 22.9 | 1700.3 ±1.2% | 0.91 ±0.9% | 1.00 ±1.8% | 0.58 ±1.0% | 1.00 ±0.5% | 0.39 ±1.6% |
| silesia/sao | 7251944 | 76.2 | 1032.2 ±0.4% | 0.48 ±0.2% | 1.00 ±0.3% | 0.63 ±0.6% | 0.98 ±0.6% | 0.48 ±1.2% |
| silesia/webster | 41458703 | 29.2 | 1177.8 ±15.4% | 0.92 ±14.3% | 1.02 ±13.5% | 0.55 ±5.1% | 1.01 ±3.0% | 0.37 ±7.3% |
| silesia/x-ray | 8474240 | 71.8 | 996.3 ±0.1% | 0.48 ±0.2% | 1.00 ±0.2% | 0.61 ±0.1% | 0.98 ±0.4% | 0.44 ±0.2% |
| silesia/xml | 5345280 | 11.9 | 2228.7 ±0.7% | 0.89 ±0.6% | 1.00 ±0.5% | 0.58 ±0.4% | 0.99 ±0.3% | 0.39 ±0.2% |
| canterbury/alice29.txt | 152089 | 37.5 | 1035.6 ±1.7% | 0.92 ±0.3% | 1.00 ±1.3% | 0.53 ±0.2% | 0.99 ±0.4% | 0.32 ±0.1% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1140.7 ±0.3% | 0.83 ±3.1% | 0.99 ±0.4% | 0.54 ±0.5% | 0.98 ±0.1% | 0.34 ±0.4% |
| canterbury/cp.html | 24603 | 34.4 | 1350.8 ±0.1% | 0.61 ±0.2% | 1.00 ±0.1% | 0.65 ±0.2% | 0.99 ±0.2% | 0.44 ±0.1% |
| canterbury/fields.c | 11150 | 30.3 | 1136.2 ±0.2% | 0.81 ±0.2% | 1.02 ±0.7% | 0.59 ±1.0% | 1.01 ±0.8% | 0.39 ±0.2% |
| canterbury/grammar.lsp | 3721 | 34.8 | 844.7 ±0.1% | 0.78 ±0.1% | 1.00 ±0.1% | 0.65 ±0.3% | 0.79 ±0.3% | 0.46 ±0.3% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1256.0 ±14.4% | 0.85 ±0.8% | 1.00 ±0.2% | 0.53 ±0.2% | 1.00 ±0.5% | 0.34 ±1.5% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1270.5 ±3.0% | 0.88 ±1.3% | 1.00 ±0.6% | 0.50 ±0.1% | 1.00 ±0.5% | 0.33 ±2.8% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1079.7 ±0.1% | 0.90 ±0.7% | 1.01 ±1.8% | 0.48 ±0.4% | 1.00 ±0.2% | 0.33 ±0.7% |
| canterbury/ptt5 | 513216 | 10.6 | 2913.8 ±0.5% | 0.76 ±0.5% | 1.00 ±0.9% | 0.60 ±0.2% | 1.00 ±1.5% | 0.40 ±2.5% |
| canterbury/sum | 38240 | 35.0 | 1291.7 ±0.2% | 0.61 ±0.1% | 1.00 ±0.2% | 0.66 ±0.3% | 0.99 ±0.2% | 0.44 ±0.2% |
| canterbury/xargs.1 | 4227 | 42.7 | 810.2 ±0.3% | 0.72 ±0.2% | 1.00 ±1.2% | 0.64 ±0.3% | 1.00 ±0.2% | 0.44 ±0.1% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1212.8 ±0.5% | 0.98 ±1.8% | 1.00 ±0.6% | 0.50 ±0.8% | 0.98 ±0.5% | 0.31 ±0.4% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1301.8 ±0.6% | 0.96 ±0.3% | 1.00 ±0.3% | 0.52 ±0.4% | 0.99 ±0.1% | 0.33 ±0.9% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1424.8 ±0.6% | 0.88 ±0.7% | 1.00 ±0.8% | 0.54 ±0.5% | 0.99 ±0.9% | 0.36 ±1.1% |
| http/html-1kx1024 | 1048576 | 39.3 | 421.8 ±0.9% | 0.87 ±0.1% | 1.01 ±0.1% | 0.77 ±0.2% | 0.99 ±0.3% | 0.65 ±2.0% |
| http/html-16kx64 | 1048576 | 21.9 | 1238.7 ±12.6% | 0.82 ±2.1% | 1.00 ±0.6% | 0.59 ±0.2% | 0.99 ±0.7% | 0.43 ±0.4% |
| http/html-1m | 1048576 | 17.7 | 1775.7 ±0.3% | 0.94 ±0.8% | 1.02 ±0.5% | 0.54 ±0.3% | 1.00 ±0.2% | 0.34 ±2.5% |
| http/json-1kx1024 | 1048576 | 21.9 | 516.8 ±0.2% | 0.99 ±0.2% | 1.02 ±0.3% | 0.80 ±0.4% | 1.00 ±0.2% | 0.67 ±0.4% |
| http/json-16kx64 | 1048576 | 12.6 | 1764.6 ±1.0% | 0.83 ±0.5% | 1.00 ±1.0% | 0.56 ±0.2% | 0.99 ±0.2% | 0.40 ±0.9% |
| http/json-1m | 1048576 | 12.2 | 2311.1 ±0.4% | 0.86 ±0.3% | 1.01 ±0.7% | 0.50 ±0.7% | 0.99 ±1.4% | 0.33 ±0.5% |
| http/js-1kx1024 | 1048576 | 44.5 | 349.8 ±0.1% | 0.86 ±0.2% | 1.00 ±0.1% | 0.77 ±0.2% | 0.99 ±0.4% | 0.65 ±0.2% |
| http/js-16kx64 | 1048576 | 26.0 | 1141.6 ±0.4% | 0.81 ±0.5% | 1.00 ±0.6% | 0.56 ±0.3% | 0.99 ±0.4% | 0.41 ±0.3% |
| http/js-1m | 1048576 | 19.0 | 1773.5 ±2.6% | 0.90 ±1.5% | 1.00 ±1.1% | 0.52 ±0.3% | 0.99 ±0.7% | 0.34 ±0.2% |
| http/css-1kx1024 | 1048576 | 29.5 | 463.2 ±0.2% | 0.95 ±0.2% | 1.01 ±0.3% | 0.79 ±0.2% | 1.00 ±0.9% | 0.65 ±0.2% |
| http/css-16kx64 | 1048576 | 15.9 | 1521.3 ±0.2% | 0.87 ±0.6% | 0.98 ±0.4% | 0.62 ±0.4% | 1.00 ±0.3% | 0.41 ±0.4% |
| http/css-1m | 1048576 | 3.6 | 5214.3 ±0.5% | 0.95 ±0.3% | 1.00 ±0.2% | 0.72 ±2.0% | 1.00 ±0.2% | 0.42 ±3.1% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1362.4 ±0.7% | 0.45 ±0.9% | 0.85 ±1.2% | 0.67 ±0.4% | 0.98 ±0.2% | 0.48 ±0.1% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 308.7 ± 0.3% | 91.3 ± 0.2% | 0.30 |
| silesia/dickens | 10192446 | 3 | 190.4 ± 1.2% | 72.1 ± 0.4% | 0.38 |
| silesia/mozilla | 51220480 | 1 | 474.0 ± 0.2% | 126.9 ± 0.1% | 0.27 |
| silesia/mozilla | 51220480 | 3 | 277.7 ± 0.5% | 90.9 ± 1.6% | 0.33 |
| silesia/mr | 9970564 | 1 | 426.1 ± 0.3% | 114.0 ± 2.4% | 0.27 |
| silesia/mr | 9970564 | 3 | 233.3 ± 2.3% | 83.1 ± 9.8% | 0.36 |
| silesia/nci | 33553445 | 1 | 954.1 ± 0.3% | 254.0 ± 0.3% | 0.27 |
| silesia/nci | 33553445 | 3 | 774.2 ± 2.6% | 153.5 ± 0.5% | 0.20 |
| silesia/ooffice | 6152192 | 1 | 387.4 ± 0.2% | 101.1 ± 0.4% | 0.26 |
| silesia/ooffice | 6152192 | 3 | 197.7 ± 0.7% | 79.8 ± 0.5% | 0.40 |
| silesia/osdb | 10085684 | 1 | 465.7 ± 0.4% | 139.4 ± 0.6% | 0.30 |
| silesia/osdb | 10085684 | 3 | 277.7 ± 7.5% | 99.3 ± 0.8% | 0.36 |
| silesia/reymont | 6627202 | 1 | 320.2 ± 1.4% | 108.4 ± 0.3% | 0.34 |
| silesia/reymont | 6627202 | 3 | 245.9 ± 1.1% | 88.7 ± 0.6% | 0.36 |
| silesia/samba | 21606400 | 1 | 543.0 ± 0.8% | 156.6 ± 0.9% | 0.29 |
| silesia/samba | 21606400 | 3 | 375.9 ± 0.7% | 111.0 ± 0.2% | 0.30 |
| silesia/sao | 7251944 | 1 | 369.6 ± 0.3% | 96.3 ± 0.4% | 0.26 |
| silesia/sao | 7251944 | 3 | 156.8 ± 0.9% | 72.2 ± 0.5% | 0.46 |
| silesia/webster | 41458703 | 1 | 358.1 ± 1.0% | 108.4 ± 0.5% | 0.30 |
| silesia/webster | 41458703 | 3 | 230.7 ± 1.0% | 80.6 ± 0.3% | 0.35 |
| silesia/x-ray | 8474240 | 1 | 777.8 ± 0.6% | 100.7 ± 0.3% | 0.13 |
| silesia/x-ray | 8474240 | 3 | 151.6 ± 1.3% | 73.2 ± 0.6% | 0.48 |
| silesia/xml | 5345280 | 1 | 756.7 ± 0.3% | 201.7 ± 0.2% | 0.27 |
| silesia/xml | 5345280 | 3 | 589.9 ± 2.5% | 161.7 ± 0.9% | 0.27 |
| canterbury/alice29.txt | 152089 | 1 | 300.9 ± 2.0% | 103.0 ± 0.4% | 0.34 |
| canterbury/alice29.txt | 152089 | 3 | 217.5 ± 0.9% | 93.5 ± 0.3% | 0.43 |
| canterbury/asyoulik.txt | 125179 | 1 | 418.9 ± 7.0% | 96.1 ± 11.7% | 0.23 |
| canterbury/asyoulik.txt | 125179 | 3 | 230.1 ± 1.3% | 90.2 ± 0.4% | 0.39 |
| canterbury/cp.html | 24603 | 1 | 532.4 ± 0.2% | 196.0 ± 1.0% | 0.37 |
| canterbury/cp.html | 24603 | 3 | 387.8 ± 0.5% | 180.5 ± 0.8% | 0.47 |
| canterbury/fields.c | 11150 | 1 | 439.4 ± 0.6% | 178.0 ± 4.5% | 0.41 |
| canterbury/fields.c | 11150 | 3 | 384.9 ± 0.7% | 171.3 ± 0.2% | 0.44 |
| canterbury/grammar.lsp | 3721 | 1 | 374.4 ± 0.4% | 140.9 ± 0.2% | 0.38 |
| canterbury/grammar.lsp | 3721 | 3 | 311.0 ± 0.4% | 135.8 ± 0.3% | 0.44 |
| canterbury/kennedy.xls | 1029744 | 1 | 559.0 ± 2.1% | 169.8 ± 0.6% | 0.30 |
| canterbury/kennedy.xls | 1029744 | 3 | 496.8 ± 2.8% | 158.5 ± 17.1% | 0.32 |
| canterbury/lcet10.txt | 426754 | 1 | 308.8 ± 0.5% | 107.8 ± 0.5% | 0.35 |
| canterbury/lcet10.txt | 426754 | 3 | 227.6 ± 1.6% | 100.6 ± 1.0% | 0.44 |
| canterbury/plrabn12.txt | 481861 | 1 | 298.9 ± 0.9% | 91.4 ± 0.8% | 0.31 |
| canterbury/plrabn12.txt | 481861 | 3 | 186.7 ± 0.6% | 84.6 ± 1.8% | 0.45 |
| canterbury/ptt5 | 513216 | 1 | 1074.3 ± 2.0% | 316.2 ± 0.6% | 0.29 |
| canterbury/ptt5 | 513216 | 3 | 838.5 ± 1.7% | 297.0 ± 0.4% | 0.35 |
| canterbury/sum | 38240 | 1 | 558.7 ± 3.3% | 185.5 ± 14.0% | 0.33 |
| canterbury/sum | 38240 | 3 | 419.7 ± 0.4% | 172.9 ± 1.2% | 0.41 |
| canterbury/xargs.1 | 4227 | 1 | 354.9 ± 0.2% | 135.8 ± 0.3% | 0.38 |
| canterbury/xargs.1 | 4227 | 3 | 274.6 ± 0.5% | 127.4 ± 0.1% | 0.46 |
| canterbury-large/E.coli | 4638690 | 1 | 304.8 ± 0.4% | 105.0 ± 1.9% | 0.34 |
| canterbury-large/E.coli | 4638690 | 3 | 276.7 ± 0.7% | 95.4 ± 0.5% | 0.34 |
| canterbury-large/bible.txt | 4047392 | 1 | 318.3 ± 0.3% | 108.8 ± 0.4% | 0.34 |
| canterbury-large/bible.txt | 4047392 | 3 | 239.7 ± 2.7% | 93.7 ± 1.1% | 0.39 |
| canterbury-large/world192.txt | 2473400 | 1 | 377.1 ± 2.2% | 119.9 ± 0.9% | 0.32 |
| canterbury-large/world192.txt | 2473400 | 3 | 270.7 ± 1.0% | 118.8 ± 1.2% | 0.44 |
| http/html-1kx1024 | 1048576 | 1 | 186.3 ± 0.4% | 65.8 ± 0.5% | 0.35 |
| http/html-1kx1024 | 1048576 | 3 | 159.8 ± 0.5% | 63.9 ± 2.2% | 0.40 |
| http/html-16kx64 | 1048576 | 1 | 412.8 ± 0.1% | 161.8 ± 0.3% | 0.39 |
| http/html-16kx64 | 1048576 | 3 | 353.0 ± 0.6% | 159.1 ± 1.0% | 0.45 |
| http/html-1m | 1048576 | 1 | 496.8 ± 0.3% | 172.1 ± 0.7% | 0.35 |
| http/html-1m | 1048576 | 3 | 405.4 ± 0.2% | 170.3 ± 0.5% | 0.42 |
| http/json-1kx1024 | 1048576 | 1 | 230.6 ± 0.3% | 83.0 ± 0.2% | 0.36 |
| http/json-1kx1024 | 1048576 | 3 | 216.8 ± 0.1% | 80.7 ± 0.5% | 0.37 |
| http/json-16kx64 | 1048576 | 1 | 697.9 ± 0.2% | 237.9 ± 0.4% | 0.34 |
| http/json-16kx64 | 1048576 | 3 | 602.1 ± 0.4% | 230.0 ± 0.3% | 0.38 |
| http/json-1m | 1048576 | 1 | 823.7 ± 0.4% | 245.5 ± 2.1% | 0.30 |
| http/json-1m | 1048576 | 3 | 636.5 ± 1.6% | 241.8 ± 1.4% | 0.38 |
| http/js-1kx1024 | 1048576 | 1 | 171.0 ± 1.1% | 59.0 ± 0.4% | 0.35 |
| http/js-1kx1024 | 1048576 | 3 | 141.1 ± 0.2% | 58.0 ± 0.9% | 0.41 |
| http/js-16kx64 | 1048576 | 1 | 362.4 ± 0.2% | 135.2 ± 3.3% | 0.37 |
| http/js-16kx64 | 1048576 | 3 | 308.0 ± 0.4% | 137.0 ± 1.4% | 0.44 |
| http/js-1m | 1048576 | 1 | 473.6 ± 0.3% | 158.6 ± 0.5% | 0.33 |
| http/js-1m | 1048576 | 3 | 386.6 ± 0.2% | 163.9 ± 0.4% | 0.42 |
| http/css-1kx1024 | 1048576 | 1 | 209.8 ± 0.1% | 74.4 ± 0.5% | 0.35 |
| http/css-1kx1024 | 1048576 | 3 | 188.3 ± 0.5% | 73.4 ± 0.4% | 0.39 |
| http/css-16kx64 | 1048576 | 1 | 554.3 ± 0.2% | 185.3 ± 0.2% | 0.33 |
| http/css-16kx64 | 1048576 | 3 | 500.0 ± 0.2% | 186.9 ± 0.4% | 0.37 |
| http/css-1m | 1048576 | 1 | 2485.6 ± 3.8% | 538.8 ± 0.6% | 0.22 |
| http/css-1m | 1048576 | 3 | 2103.4 ± 5.2% | 694.5 ± 0.5% | 0.33 |
| shuffled/dickens-1m | 1048576 | 1 | 1165.2 ± 0.7% | 187.0 ± 0.9% | 0.16 |
| shuffled/dickens-1m | 1048576 | 3 | 172.1 ± 0.2% | 135.7 ± 1.1% | 0.79 |

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
| silesia/dickens | 10192446 | 35.9 | 839.8 ±2.5% | 1136.3 ±3.0% | 1.35 |
| silesia/mozilla | 51220480 | 35.6 | 971.8 ±3.7% | 1233.6 ±0.9% | 1.27 |
| silesia/mr | 9970564 | 35.6 | 959.2 ±0.2% | 1271.6 ±0.9% | 1.33 |
| silesia/nci | 33553445 | 8.4 | 1754.3 ±4.9% | 2373.4 ±5.3% | 1.35 |
| silesia/ooffice | 6152192 | 50.8 | 832.0 ±0.3% | 1050.7 ±2.0% | 1.26 |
| silesia/osdb | 10085684 | 34.7 | 1182.2 ±11.6% | 1509.4 ±6.1% | 1.28 |
| silesia/reymont | 6627202 | 29.2 | 974.8 ±2.2% | 1059.2 ±8.5% | 1.09 |
| silesia/samba | 21606400 | 22.9 | 1339.0 ±14.6% | 1680.0 ±7.6% | 1.25 |
| silesia/sao | 7251944 | 76.2 | 792.0 ±3.9% | 1025.9 ±2.4% | 1.30 |
| silesia/webster | 41458703 | 29.2 | 935.8 ±5.8% | 1218.2 ±7.0% | 1.30 |
| silesia/x-ray | 8474240 | 71.8 | 783.1 ±0.9% | 991.3 ±1.5% | 1.27 |
| silesia/xml | 5345280 | 11.9 | 1717.3 ±9.9% | 2226.1 ±10.2% | 1.30 |
| canterbury/alice29.txt | 152089 | 37.5 | 758.4 ±0.3% | 1026.3 ±0.3% | 1.35 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 877.0 ±0.1% | 1151.8 ±1.1% | 1.31 |
| canterbury/cp.html | 24603 | 34.4 | 1102.8 ±0.2% | 1310.3 ±0.2% | 1.19 |
| canterbury/fields.c | 11150 | 30.3 | 899.1 ±5.9% | 1154.0 ±0.6% | 1.28 |
| canterbury/grammar.lsp | 3721 | 34.8 | 708.7 ±0.3% | 847.8 ±0.2% | 1.20 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1028.6 ±0.2% | 1259.4 ±0.1% | 1.22 |
| canterbury/lcet10.txt | 426754 | 33.0 | 951.4 ±0.7% | 1280.5 ±0.5% | 1.35 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 822.3 ±0.4% | 1083.2 ±0.2% | 1.32 |
| canterbury/ptt5 | 513216 | 10.6 | 2465.8 ±1.2% | 2924.4 ±0.4% | 1.19 |
| canterbury/sum | 38240 | 35.0 | 1091.9 ±0.2% | 1289.0 ±0.2% | 1.18 |
| canterbury/xargs.1 | 4227 | 42.7 | 690.2 ±0.1% | 823.2 ±0.3% | 1.19 |
| canterbury-large/E.coli | 4638690 | 30.0 | 886.7 ±0.7% | 1199.2 ±1.1% | 1.35 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 973.1 ±0.5% | 1291.9 ±0.6% | 1.33 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1137.4 ±0.2% | 1432.0 ±0.4% | 1.26 |
| http/html-1kx1024 | 1048576 | 39.3 | 429.7 ±0.3% | 450.8 ±0.3% | 1.05 |
| http/html-16kx64 | 1048576 | 21.9 | 1048.9 ±0.2% | 1246.1 ±1.7% | 1.19 |
| http/html-1m | 1048576 | 17.7 | 1340.4 ±0.2% | 1761.0 ±1.3% | 1.31 |
| http/json-1kx1024 | 1048576 | 21.9 | 501.7 ±0.1% | 558.4 ±0.0% | 1.11 |
| http/json-16kx64 | 1048576 | 12.6 | 1365.1 ±0.5% | 1786.8 ±0.9% | 1.31 |
| http/json-1m | 1048576 | 12.2 | 1563.6 ±0.3% | 2308.1 ±0.4% | 1.48 |
| http/js-1kx1024 | 1048576 | 44.5 | 374.4 ±0.3% | 368.3 ±0.2% | 0.98 |
| http/js-16kx64 | 1048576 | 26.0 | 949.2 ±0.1% | 1141.0 ±2.0% | 1.20 |
| http/js-1m | 1048576 | 19.0 | 1320.4 ±0.3% | 1758.2 ±2.8% | 1.33 |
| http/css-1kx1024 | 1048576 | 29.5 | 461.4 ±0.3% | 497.4 ±0.1% | 1.08 |
| http/css-16kx64 | 1048576 | 15.9 | 1270.3 ±0.7% | 1546.3 ±0.6% | 1.22 |
| http/css-1m | 1048576 | 3.6 | 4028.9 ±0.3% | 5218.9 ±0.6% | 1.30 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1147.8 ±0.6% | 1374.4 ±1.4% | 1.20 |
