# bench-zstd

| Field | Value |
|---|---|
| Commit | 10fa46b |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261101.172.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/41962193660 |
| Date | 2026-11-05 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 936.8 ±2.7% | 907.8 ±2.9% | 0.97 |
| silesia/mozilla | 51220480 | 35.6 | 1169.4 ±0.2% | 1173.7 ±0.6% | 1.00 |
| silesia/mr | 9970564 | 35.6 | 1086.1 ±1.5% | 1068.9 ±2.0% | 0.98 |
| silesia/nci | 33553445 | 8.4 | 1992.9 ±5.1% | 1825.9 ±2.5% | 0.92 |
| silesia/ooffice | 6152192 | 50.8 | 975.0 ±0.5% | 1000.0 ±1.0% | 1.03 |
| silesia/osdb | 10085684 | 34.7 | 1420.8 ±1.1% | 1376.0 ±1.2% | 0.97 |
| silesia/reymont | 6627202 | 29.2 | 1057.3 ±1.5% | 1018.7 ±1.1% | 0.96 |
| silesia/samba | 21606400 | 22.9 | 1600.1 ±2.9% | 1507.7 ±3.9% | 0.94 |
| silesia/sao | 7251944 | 76.2 | 870.1 ±0.9% | 941.9 ±1.3% | 1.08 |
| silesia/webster | 41458703 | 29.2 | 1026.9 ±1.5% | 979.9 ±0.6% | 0.95 |
| silesia/x-ray | 8474240 | 71.8 | 838.4 ±0.4% | 924.9 ±1.2% | 1.10 |
| silesia/xml | 5345280 | 11.9 | 2182.0 ±1.3% | 2206.2 ±3.4% | 1.01 |
| canterbury/alice29.txt | 152089 | 37.5 | 1007.3 ±0.1% | 1028.0 ±0.1% | 1.02 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1128.4 ±0.4% | 1138.3 ±0.1% | 1.01 |
| canterbury/cp.html | 24603 | 34.4 | 1251.6 ±0.2% | 1338.0 ±1.6% | 1.07 |
| canterbury/fields.c | 11150 | 30.3 | 1070.7 ±0.3% | 1123.8 ±0.3% | 1.05 |
| canterbury/grammar.lsp | 3721 | 34.8 | 790.1 ±0.2% | 822.8 ±0.1% | 1.04 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1355.8 ±0.2% | 1267.9 ±0.4% | 0.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1234.3 ±0.3% | 1257.9 ±0.3% | 1.02 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1061.6 ±0.4% | 1067.7 ±0.2% | 1.01 |
| canterbury/ptt5 | 513216 | 10.6 | 2373.4 ±0.3% | 2540.1 ±1.6% | 1.07 |
| canterbury/sum | 38240 | 35.0 | 1237.4 ±0.2% | 1295.4 ±0.2% | 1.05 |
| canterbury/xargs.1 | 4227 | 42.7 | 784.3 ±0.4% | 795.8 ±0.1% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1110.7 ±0.5% | 1078.9 ±0.2% | 0.97 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1145.7 ±0.7% | 1094.2 ±1.4% | 0.96 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1328.7 ±0.1% | 1278.8 ±1.0% | 0.96 |
| http/html-1kx1024 | 1048576 | 39.3 | 457.4 ±0.1% | 452.2 ±0.3% | 0.99 |
| http/html-16kx64 | 1048576 | 21.9 | 1271.2 ±0.2% | 1274.2 ±0.4% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1694.1 ±0.3% | 1681.0 ±0.9% | 0.99 |
| http/json-1kx1024 | 1048576 | 21.9 | 529.8 ±0.2% | 542.9 ±0.1% | 1.02 |
| http/json-16kx64 | 1048576 | 12.6 | 1650.3 ±0.1% | 1682.5 ±0.5% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1942.9 ±0.5% | 2093.9 ±0.6% | 1.08 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.0 ±0.0% | 374.2 ±0.1% | 0.93 |
| http/js-16kx64 | 1048576 | 26.0 | 1155.9 ±0.1% | 1145.2 ±0.1% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1643.4 ±0.4% | 1629.2 ±0.4% | 0.99 |
| http/css-1kx1024 | 1048576 | 29.5 | 477.3 ±0.1% | 493.4 ±0.1% | 1.03 |
| http/css-16kx64 | 1048576 | 15.9 | 1470.6 ±0.2% | 1493.7 ±0.2% | 1.02 |
| http/css-1m | 1048576 | 3.6 | 5026.2 ±0.5% | 4891.9 ±1.0% | 0.97 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1197.7 ±0.2% | 1236.0 ±1.1% | 1.03 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 238.3 ±1.3% | 945.8 ±2.0% | 3.97 |
| silesia/mozilla | 51220480 | 35.6 | 277.6 ±0.5% | 1188.0 ±0.3% | 4.28 |
| silesia/mr | 9970564 | 35.6 | 244.2 ±0.7% | 1120.9 ±2.1% | 4.59 |
| silesia/nci | 33553445 | 8.4 | 682.4 ±1.1% | 1938.2 ±4.3% | 2.84 |
| silesia/ooffice | 6152192 | 50.8 | 193.4 ±0.5% | 1008.0 ±0.3% | 5.21 |
| silesia/osdb | 10085684 | 34.7 | 303.2 ±0.6% | 1419.6 ±1.6% | 4.68 |
| silesia/reymont | 6627202 | 29.2 | 285.6 ±1.6% | 1048.2 ±2.7% | 3.67 |
| silesia/samba | 21606400 | 22.9 | 448.5 ±0.7% | 1580.9 ±1.9% | 3.53 |
| silesia/sao | 7251944 | 76.2 | 163.5 ±0.2% | 951.3 ±1.6% | 5.82 |
| silesia/webster | 41458703 | 29.2 | 280.7 ±0.4% | 997.5 ±1.3% | 3.55 |
| silesia/x-ray | 8474240 | 71.8 | 153.1 ±0.6% | 934.2 ±2.2% | 6.10 |
| silesia/xml | 5345280 | 11.9 | 627.4 ±0.7% | 2234.6 ±0.7% | 3.56 |
| canterbury/alice29.txt | 152089 | 37.5 | 221.4 ±0.3% | 1027.6 ±0.2% | 4.64 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 207.2 ±1.0% | 1138.8 ±0.1% | 5.50 |
| canterbury/cp.html | 24603 | 34.4 | 253.5 ±0.1% | 1337.7 ±0.1% | 5.28 |
| canterbury/fields.c | 11150 | 30.3 | 250.4 ±0.4% | 1130.5 ±0.4% | 4.51 |
| canterbury/grammar.lsp | 3721 | 34.8 | 214.3 ±0.4% | 825.7 ±0.1% | 3.85 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 296.6 ±0.3% | 1265.6 ±0.2% | 4.27 |
| canterbury/lcet10.txt | 426754 | 33.0 | 265.1 ±0.5% | 1263.5 ±0.5% | 4.77 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 218.9 ±0.4% | 1074.8 ±0.1% | 4.91 |
| canterbury/ptt5 | 513216 | 10.6 | 470.3 ±0.4% | 2590.7 ±0.7% | 5.51 |
| canterbury/sum | 38240 | 35.0 | 250.0 ±0.1% | 1296.5 ±0.2% | 5.19 |
| canterbury/xargs.1 | 4227 | 42.7 | 182.4 ±0.1% | 797.1 ±0.1% | 4.37 |
| canterbury-large/E.coli | 4638690 | 30.0 | 264.6 ±0.8% | 1088.9 ±0.5% | 4.12 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 297.7 ±1.1% | 1108.6 ±0.3% | 3.72 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 332.1 ±0.5% | 1313.8 ±0.2% | 3.96 |
| http/html-1kx1024 | 1048576 | 39.3 | 187.5 ±0.1% | 452.3 ±0.2% | 2.41 |
| http/html-16kx64 | 1048576 | 21.9 | 334.9 ±0.2% | 1282.9 ±0.3% | 3.83 |
| http/html-1m | 1048576 | 17.7 | 452.2 ±0.2% | 1714.8 ±0.4% | 3.79 |
| http/json-1kx1024 | 1048576 | 21.9 | 278.4 ±0.1% | 544.2 ±0.1% | 1.95 |
| http/json-16kx64 | 1048576 | 12.6 | 466.8 ±0.2% | 1682.7 ±0.2% | 3.60 |
| http/json-1m | 1048576 | 12.2 | 526.3 ±0.4% | 2098.4 ±0.8% | 3.99 |
| http/js-1kx1024 | 1048576 | 44.5 | 158.2 ±0.0% | 374.3 ±0.2% | 2.37 |
| http/js-16kx64 | 1048576 | 26.0 | 285.7 ±0.3% | 1152.8 ±0.4% | 4.03 |
| http/js-1m | 1048576 | 19.0 | 427.3 ±0.5% | 1652.0 ±1.2% | 3.87 |
| http/css-1kx1024 | 1048576 | 29.5 | 234.5 ±0.0% | 494.8 ±0.1% | 2.11 |
| http/css-16kx64 | 1048576 | 15.9 | 421.6 ±0.4% | 1498.3 ±0.2% | 3.55 |
| http/css-1m | 1048576 | 3.6 | 1767.9 ±0.5% | 4892.3 ±0.8% | 2.77 |
| shuffled/dickens-1m | 1048576 | 58.8 | 152.6 ±0.4% | 1251.4 ±0.3% | 8.20 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 942.9 ±2.4% | 0.93 ±2.6% | 1.01 ±2.9% | 0.59 ±1.6% | 0.96 ±2.3% | 0.38 ±0.2% |
| silesia/mozilla | 51220480 | 35.6 | 1182.6 ±1.2% | 0.74 ±0.7% | 1.00 ±1.8% | 0.61 ±0.4% | 0.99 ±1.5% | 0.45 ±1.5% |
| silesia/mr | 9970564 | 35.6 | 1096.5 ±3.0% | 0.81 ±3.9% | 1.01 ±3.7% | 0.58 ±1.9% | 0.99 ±2.6% | 0.39 ±1.9% |
| silesia/nci | 33553445 | 8.4 | 1932.0 ±8.0% | 0.96 ±7.7% | 1.02 ±8.7% | 0.70 ±2.2% | 1.00 ±7.0% | 0.49 ±2.1% |
| silesia/ooffice | 6152192 | 50.8 | 994.1 ±13.1% | 0.62 ±5.7% | 0.96 ±9.7% | 0.58 ±3.5% | 0.98 ±22.2% | 0.45 ±6.8% |
| silesia/osdb | 10085684 | 34.7 | 1411.6 ±2.8% | 0.67 ±2.2% | 1.00 ±2.1% | 0.68 ±1.6% | 0.96 ±1.0% | 0.45 ±1.0% |
| silesia/reymont | 6627202 | 29.2 | 1042.3 ±0.9% | 0.95 ±2.2% | 1.00 ±1.2% | 0.62 ±0.9% | 0.97 ±1.1% | 0.40 ±2.8% |
| silesia/samba | 21606400 | 22.9 | 1505.7 ±4.9% | 0.92 ±4.2% | 1.02 ±2.9% | 0.65 ±1.8% | 1.01 ±4.2% | 0.44 ±1.7% |
| silesia/sao | 7251944 | 76.2 | 948.2 ±2.5% | 0.52 ±0.7% | 0.99 ±1.3% | 0.69 ±1.3% | 0.97 ±2.8% | 0.53 ±1.5% |
| silesia/webster | 41458703 | 29.2 | 994.2 ±2.9% | 0.93 ±2.0% | 1.00 ±2.1% | 0.63 ±3.7% | 0.97 ±2.5% | 0.42 ±2.9% |
| silesia/x-ray | 8474240 | 71.8 | 942.3 ±1.5% | 0.51 ±1.3% | 1.00 ±1.4% | 0.66 ±0.8% | 0.97 ±0.9% | 0.48 ±0.7% |
| silesia/xml | 5345280 | 11.9 | 2231.1 ±1.1% | 0.93 ±0.5% | 1.00 ±0.8% | 0.61 ±1.4% | 0.99 ±0.8% | 0.41 ±1.2% |
| canterbury/alice29.txt | 152089 | 37.5 | 1027.8 ±0.2% | 0.94 ±0.1% | 1.00 ±0.0% | 0.53 ±0.3% | 0.99 ±0.1% | 0.36 ±0.6% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1136.1 ±0.0% | 0.85 ±0.1% | 0.98 ±0.1% | 0.51 ±0.2% | 0.99 ±0.1% | 0.37 ±0.1% |
| canterbury/cp.html | 24603 | 34.4 | 1339.0 ±0.3% | 0.63 ±0.3% | 1.00 ±0.4% | 0.62 ±0.5% | 0.99 ±0.3% | 0.45 ±0.2% |
| canterbury/fields.c | 11150 | 30.3 | 1132.8 ±0.6% | 0.81 ±0.5% | 1.00 ±0.3% | 0.59 ±0.3% | 0.99 ±0.1% | 0.41 ±0.4% |
| canterbury/grammar.lsp | 3721 | 34.8 | 825.2 ±0.2% | 0.79 ±0.2% | 1.00 ±0.2% | 0.67 ±0.7% | 0.99 ±0.1% | 0.49 ±0.2% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1267.8 ±0.5% | 0.86 ±0.4% | 1.01 ±0.6% | 0.58 ±0.4% | 1.00 ±0.4% | 0.39 ±0.2% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1263.1 ±0.2% | 0.89 ±0.1% | 1.00 ±0.2% | 0.54 ±0.1% | 0.99 ±0.1% | 0.35 ±0.5% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1073.6 ±0.1% | 0.91 ±0.1% | 1.00 ±0.2% | 0.52 ±0.3% | 0.99 ±0.2% | 0.36 ±0.4% |
| canterbury/ptt5 | 513216 | 10.6 | 2582.2 ±1.1% | 0.81 ±0.5% | 1.01 ±0.8% | 0.55 ±0.1% | 1.00 ±0.8% | 0.43 ±0.2% |
| canterbury/sum | 38240 | 35.0 | 1297.6 ±0.2% | 0.64 ±0.1% | 1.00 ±0.1% | 0.62 ±0.3% | 0.99 ±0.2% | 0.45 ±0.2% |
| canterbury/xargs.1 | 4227 | 42.7 | 798.2 ±0.2% | 0.74 ±0.2% | 1.00 ±0.1% | 0.65 ±0.2% | 0.99 ±0.2% | 0.46 ±0.0% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1095.4 ±1.4% | 0.98 ±1.0% | 1.00 ±1.1% | 0.58 ±0.5% | 0.97 ±1.8% | 0.36 ±2.3% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1107.3 ±1.4% | 0.96 ±0.7% | 1.01 ±0.8% | 0.61 ±0.6% | 0.97 ±1.7% | 0.38 ±2.4% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1312.3 ±1.0% | 0.89 ±1.4% | 0.99 ±0.5% | 0.60 ±0.3% | 0.97 ±2.1% | 0.41 ±0.6% |
| http/html-1kx1024 | 1048576 | 39.3 | 453.9 ±0.2% | 0.86 ±0.2% | 1.00 ±0.3% | 0.79 ±0.2% | 0.99 ±0.2% | 0.67 ±0.2% |
| http/html-16kx64 | 1048576 | 21.9 | 1277.7 ±0.9% | 0.83 ±0.4% | 1.00 ±2.3% | 0.63 ±0.6% | 0.99 ±0.6% | 0.46 ±0.2% |
| http/html-1m | 1048576 | 17.7 | 1699.5 ±1.2% | 0.94 ±1.0% | 1.00 ±1.2% | 0.60 ±3.9% | 0.99 ±0.3% | 0.40 ±0.9% |
| http/json-1kx1024 | 1048576 | 21.9 | 545.7 ±0.1% | 0.95 ±0.1% | 1.00 ±0.1% | 0.81 ±0.2% | 0.99 ±0.1% | 0.68 ±0.1% |
| http/json-16kx64 | 1048576 | 12.6 | 1690.4 ±0.3% | 0.85 ±0.3% | 1.00 ±0.3% | 0.64 ±0.3% | 0.99 ±0.2% | 0.47 ±0.1% |
| http/json-1m | 1048576 | 12.2 | 2100.1 ±0.8% | 0.88 ±0.4% | 1.00 ±0.8% | 0.58 ±0.5% | 0.99 ±0.6% | 0.40 ±0.5% |
| http/js-1kx1024 | 1048576 | 44.5 | 375.1 ±0.1% | 0.86 ±0.1% | 1.00 ±0.1% | 0.78 ±0.2% | 0.99 ±0.1% | 0.67 ±0.1% |
| http/js-16kx64 | 1048576 | 26.0 | 1150.0 ±0.5% | 0.82 ±0.6% | 1.00 ±0.3% | 0.61 ±0.1% | 0.99 ±0.3% | 0.45 ±0.3% |
| http/js-1m | 1048576 | 19.0 | 1656.5 ±0.4% | 0.91 ±0.5% | 1.00 ±0.2% | 0.59 ±0.4% | 0.99 ±0.5% | 0.40 ±0.2% |
| http/css-1kx1024 | 1048576 | 29.5 | 494.2 ±0.1% | 0.94 ±0.1% | 1.00 ±0.1% | 0.79 ±0.1% | 0.99 ±0.2% | 0.67 ±0.1% |
| http/css-16kx64 | 1048576 | 15.9 | 1494.6 ±0.2% | 0.89 ±0.3% | 1.00 ±0.2% | 0.65 ±0.2% | 0.99 ±0.3% | 0.45 ±0.1% |
| http/css-1m | 1048576 | 3.6 | 4930.9 ±2.2% | 0.95 ±0.9% | 1.00 ±0.2% | 0.70 ±0.1% | 0.98 ±0.3% | 0.46 ±0.4% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1238.7 ±0.7% | 0.52 ±0.2% | 0.86 ±0.4% | 0.75 ±0.4% | 0.99 ±0.7% | 0.56 ±0.7% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 333.2 ± 0.3% | 116.5 ± 0.5% | 0.35 |
| silesia/dickens | 10192446 | 3 | 149.5 ± 1.1% | 86.8 ± 0.4% | 0.58 |
| silesia/mozilla | 51220480 | 1 | 480.0 ± 0.3% | 162.1 ± 0.3% | 0.34 |
| silesia/mozilla | 51220480 | 3 | 196.9 ± 1.2% | 102.0 ± 0.3% | 0.52 |
| silesia/mr | 9970564 | 1 | 439.3 ± 0.3% | 143.7 ± 0.5% | 0.33 |
| silesia/mr | 9970564 | 3 | 165.9 ± 0.9% | 92.0 ± 0.5% | 0.55 |
| silesia/nci | 33553445 | 1 | 950.1 ± 0.4% | 369.0 ± 0.5% | 0.39 |
| silesia/nci | 33553445 | 3 | 618.3 ± 0.7% | 270.8 ± 0.5% | 0.44 |
| silesia/ooffice | 6152192 | 1 | 394.3 ± 0.4% | 122.2 ± 0.4% | 0.31 |
| silesia/ooffice | 6152192 | 3 | 139.4 ± 0.3% | 74.4 ± 0.4% | 0.53 |
| silesia/osdb | 10085684 | 1 | 473.3 ± 0.3% | 172.8 ± 0.3% | 0.37 |
| silesia/osdb | 10085684 | 3 | 187.1 ± 0.9% | 99.6 ± 0.8% | 0.53 |
| silesia/reymont | 6627202 | 1 | 342.4 ± 0.4% | 141.3 ± 0.4% | 0.41 |
| silesia/reymont | 6627202 | 3 | 183.8 ± 1.1% | 109.5 ± 0.2% | 0.60 |
| silesia/samba | 21606400 | 1 | 562.4 ± 0.2% | 211.3 ± 0.3% | 0.38 |
| silesia/samba | 21606400 | 3 | 281.4 ± 1.2% | 152.4 ± 0.5% | 0.54 |
| silesia/sao | 7251944 | 1 | 373.5 ± 0.5% | 107.3 ± 0.8% | 0.29 |
| silesia/sao | 7251944 | 3 | 105.6 ± 0.4% | 61.2 ± 0.4% | 0.58 |
| silesia/webster | 41458703 | 1 | 386.5 ± 0.8% | 142.0 ± 0.5% | 0.37 |
| silesia/webster | 41458703 | 3 | 177.1 ± 1.1% | 101.0 ± 1.0% | 0.57 |
| silesia/x-ray | 8474240 | 1 | 713.7 ± 0.3% | 114.4 ± 0.3% | 0.16 |
| silesia/x-ray | 8474240 | 3 | 102.5 ± 0.8% | 64.4 ± 1.1% | 0.63 |
| silesia/xml | 5345280 | 1 | 784.2 ± 0.5% | 276.6 ± 0.8% | 0.35 |
| silesia/xml | 5345280 | 3 | 484.7 ± 0.9% | 236.7 ± 0.9% | 0.49 |
| canterbury/alice29.txt | 152089 | 1 | 309.9 ± 0.1% | 126.0 ± 0.1% | 0.41 |
| canterbury/alice29.txt | 152089 | 3 | 207.4 ± 0.5% | 109.3 ± 0.6% | 0.53 |
| canterbury/asyoulik.txt | 125179 | 1 | 347.3 ± 0.1% | 117.7 ± 0.6% | 0.34 |
| canterbury/asyoulik.txt | 125179 | 3 | 213.0 ± 0.2% | 104.2 ± 0.4% | 0.49 |
| canterbury/cp.html | 24603 | 1 | 491.0 ± 0.2% | 175.8 ± 0.3% | 0.36 |
| canterbury/cp.html | 24603 | 3 | 346.9 ± 0.9% | 158.8 ± 0.4% | 0.46 |
| canterbury/fields.c | 11150 | 1 | 392.2 ± 0.7% | 178.8 ± 0.7% | 0.46 |
| canterbury/fields.c | 11150 | 3 | 379.3 ± 0.4% | 176.8 ± 0.9% | 0.47 |
| canterbury/grammar.lsp | 3721 | 1 | 358.4 ± 0.3% | 152.0 ± 0.3% | 0.42 |
| canterbury/grammar.lsp | 3721 | 3 | 319.5 ± 0.1% | 146.4 ± 0.6% | 0.46 |
| canterbury/kennedy.xls | 1029744 | 1 | 562.7 ± 0.2% | 197.5 ± 0.5% | 0.35 |
| canterbury/kennedy.xls | 1029744 | 3 | 388.5 ± 0.6% | 151.2 ± 0.6% | 0.39 |
| canterbury/lcet10.txt | 426754 | 1 | 341.2 ± 0.2% | 132.5 ± 0.3% | 0.39 |
| canterbury/lcet10.txt | 426754 | 3 | 198.4 ± 0.9% | 112.2 ± 0.8% | 0.57 |
| canterbury/plrabn12.txt | 481861 | 1 | 326.6 ± 0.2% | 110.6 ± 1.1% | 0.34 |
| canterbury/plrabn12.txt | 481861 | 3 | 160.4 ± 0.5% | 94.5 ± 0.4% | 0.59 |
| canterbury/ptt5 | 513216 | 1 | 1087.2 ± 0.3% | 377.9 ± 0.3% | 0.35 |
| canterbury/ptt5 | 513216 | 3 | 669.0 ± 0.6% | 312.1 ± 1.0% | 0.47 |
| canterbury/sum | 38240 | 1 | 524.8 ± 0.4% | 169.1 ± 0.5% | 0.32 |
| canterbury/sum | 38240 | 3 | 374.8 ± 0.8% | 146.1 ± 0.4% | 0.39 |
| canterbury/xargs.1 | 4227 | 1 | 340.2 ± 0.4% | 143.6 ± 0.2% | 0.42 |
| canterbury/xargs.1 | 4227 | 3 | 283.1 ± 0.2% | 133.0 ± 0.5% | 0.47 |
| canterbury-large/E.coli | 4638690 | 1 | 321.0 ± 0.3% | 133.0 ± 0.3% | 0.41 |
| canterbury-large/E.coli | 4638690 | 3 | 215.8 ± 1.5% | 123.9 ± 1.3% | 0.57 |
| canterbury-large/bible.txt | 4047392 | 1 | 342.2 ± 0.5% | 140.6 ± 0.5% | 0.41 |
| canterbury-large/bible.txt | 4047392 | 3 | 184.1 ± 0.6% | 109.6 ± 0.8% | 0.59 |
| canterbury-large/world192.txt | 2473400 | 1 | 411.6 ± 0.3% | 154.9 ± 0.5% | 0.38 |
| canterbury-large/world192.txt | 2473400 | 3 | 214.7 ± 0.9% | 121.9 ± 0.9% | 0.57 |
| http/html-1kx1024 | 1048576 | 1 | 198.0 ± 0.3% | 87.0 ± 0.4% | 0.44 |
| http/html-1kx1024 | 1048576 | 3 | 175.9 ± 0.2% | 81.8 ± 0.2% | 0.46 |
| http/html-16kx64 | 1048576 | 1 | 433.2 ± 0.1% | 199.1 ± 0.4% | 0.46 |
| http/html-16kx64 | 1048576 | 3 | 379.9 ± 0.4% | 186.3 ± 0.9% | 0.49 |
| http/html-1m | 1048576 | 1 | 533.5 ± 0.3% | 219.9 ± 0.5% | 0.41 |
| http/html-1m | 1048576 | 3 | 351.2 ± 0.6% | 189.5 ± 1.0% | 0.54 |
| http/json-1kx1024 | 1048576 | 1 | 236.4 ± 0.2% | 107.8 ± 0.3% | 0.46 |
| http/json-1kx1024 | 1048576 | 3 | 227.0 ± 0.3% | 103.3 ± 0.5% | 0.45 |
| http/json-16kx64 | 1048576 | 1 | 705.5 ± 0.1% | 292.6 ± 0.3% | 0.41 |
| http/json-16kx64 | 1048576 | 3 | 624.9 ± 0.2% | 271.9 ± 0.2% | 0.44 |
| http/json-1m | 1048576 | 1 | 827.2 ± 0.3% | 311.5 ± 0.8% | 0.38 |
| http/json-1m | 1048576 | 3 | 526.9 ± 0.3% | 258.1 ± 0.2% | 0.49 |
| http/js-1kx1024 | 1048576 | 1 | 182.2 ± 0.1% | 77.6 ± 0.3% | 0.43 |
| http/js-1kx1024 | 1048576 | 3 | 157.2 ± 0.1% | 73.5 ± 0.5% | 0.47 |
| http/js-16kx64 | 1048576 | 1 | 377.3 ± 0.2% | 169.6 ± 0.1% | 0.45 |
| http/js-16kx64 | 1048576 | 3 | 330.6 ± 0.3% | 161.0 ± 1.0% | 0.49 |
| http/js-1m | 1048576 | 1 | 507.1 ± 0.3% | 202.0 ± 0.8% | 0.40 |
| http/js-1m | 1048576 | 3 | 328.4 ± 0.7% | 175.4 ± 1.6% | 0.53 |
| http/css-1kx1024 | 1048576 | 1 | 216.8 ± 0.1% | 97.8 ± 0.2% | 0.45 |
| http/css-1kx1024 | 1048576 | 3 | 201.8 ± 0.2% | 93.5 ± 0.3% | 0.46 |
| http/css-16kx64 | 1048576 | 1 | 545.1 ± 0.2% | 227.6 ± 0.3% | 0.42 |
| http/css-16kx64 | 1048576 | 3 | 512.3 ± 0.3% | 221.9 ± 0.4% | 0.43 |
| http/css-1m | 1048576 | 1 | 2273.7 ± 0.3% | 742.8 ± 0.5% | 0.33 |
| http/css-1m | 1048576 | 3 | 1703.0 ± 0.4% | 759.1 ± 0.8% | 0.45 |
| shuffled/dickens-1m | 1048576 | 1 | 961.5 ± 0.5% | 235.2 ± 0.9% | 0.24 |
| shuffled/dickens-1m | 1048576 | 3 | 113.8 ± 0.3% | 129.0 ± 0.2% | 1.13 |

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
| silesia/dickens | 10192446 | 35.9 | 919.1 ±2.4% | 893.8 ±3.5% | 0.97 |
| silesia/mozilla | 51220480 | 35.6 | 1170.8 ±0.4% | 1179.2 ±0.4% | 1.01 |
| silesia/mr | 9970564 | 35.6 | 1078.1 ±2.2% | 1070.6 ±1.5% | 0.99 |
| silesia/nci | 33553445 | 8.4 | 1983.4 ±0.8% | 1842.4 ±1.7% | 0.93 |
| silesia/ooffice | 6152192 | 50.8 | 967.9 ±0.5% | 992.8 ±2.5% | 1.03 |
| silesia/osdb | 10085684 | 34.7 | 1383.8 ±0.7% | 1353.9 ±1.1% | 0.98 |
| silesia/reymont | 6627202 | 29.2 | 1045.2 ±0.7% | 1007.3 ±0.8% | 0.96 |
| silesia/samba | 21606400 | 22.9 | 1563.6 ±1.0% | 1501.0 ±2.6% | 0.96 |
| silesia/sao | 7251944 | 76.2 | 866.8 ±1.8% | 946.6 ±0.9% | 1.09 |
| silesia/webster | 41458703 | 29.2 | 1039.3 ±1.6% | 987.2 ±1.4% | 0.95 |
| silesia/x-ray | 8474240 | 71.8 | 843.3 ±0.5% | 937.4 ±0.5% | 1.11 |
| silesia/xml | 5345280 | 11.9 | 2183.0 ±1.2% | 2217.8 ±0.6% | 1.02 |
| canterbury/alice29.txt | 152089 | 37.5 | 1010.5 ±0.3% | 1025.5 ±0.2% | 1.01 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1127.4 ±2.0% | 1136.3 ±0.2% | 1.01 |
| canterbury/cp.html | 24603 | 34.4 | 1271.3 ±0.3% | 1333.3 ±0.2% | 1.05 |
| canterbury/fields.c | 11150 | 30.3 | 1081.0 ±0.1% | 1118.1 ±0.1% | 1.03 |
| canterbury/grammar.lsp | 3721 | 34.8 | 798.8 ±0.1% | 823.9 ±0.1% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1347.9 ±0.3% | 1267.7 ±0.2% | 0.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1234.3 ±0.2% | 1254.6 ±0.7% | 1.02 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1059.5 ±0.3% | 1068.0 ±0.4% | 1.01 |
| canterbury/ptt5 | 513216 | 10.6 | 2362.2 ±0.3% | 2567.6 ±1.6% | 1.09 |
| canterbury/sum | 38240 | 35.0 | 1273.1 ±0.2% | 1292.9 ±0.1% | 1.02 |
| canterbury/xargs.1 | 4227 | 42.7 | 790.0 ±0.0% | 796.8 ±0.1% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1085.9 ±1.4% | 1062.7 ±1.5% | 0.98 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1113.4 ±0.9% | 1098.3 ±0.6% | 0.99 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1318.8 ±0.4% | 1277.8 ±0.8% | 0.97 |
| http/html-1kx1024 | 1048576 | 39.3 | 457.3 ±0.1% | 476.7 ±0.3% | 1.04 |
| http/html-16kx64 | 1048576 | 21.9 | 1270.9 ±0.3% | 1276.3 ±0.2% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1682.5 ±0.5% | 1687.5 ±0.4% | 1.00 |
| http/json-1kx1024 | 1048576 | 21.9 | 531.1 ±0.1% | 573.3 ±0.1% | 1.08 |
| http/json-16kx64 | 1048576 | 12.6 | 1660.2 ±0.2% | 1697.2 ±0.3% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1963.2 ±0.5% | 2091.1 ±0.3% | 1.07 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.4 ±0.2% | 390.8 ±0.1% | 0.97 |
| http/js-16kx64 | 1048576 | 26.0 | 1160.1 ±0.2% | 1148.4 ±0.3% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1662.5 ±0.5% | 1615.2 ±0.9% | 0.97 |
| http/css-1kx1024 | 1048576 | 29.5 | 482.1 ±0.1% | 517.1 ±0.1% | 1.07 |
| http/css-16kx64 | 1048576 | 15.9 | 1512.5 ±0.2% | 1507.9 ±0.2% | 1.00 |
| http/css-1m | 1048576 | 3.6 | 5119.4 ±0.6% | 4856.0 ±1.4% | 0.95 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1202.2 ±0.4% | 1235.0 ±0.8% | 1.03 |
