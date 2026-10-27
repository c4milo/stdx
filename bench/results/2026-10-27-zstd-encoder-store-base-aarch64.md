# bench-zstd

| Field | Value |
|---|---|
| Commit | 00ebfdb |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261023.149.3 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/40578095901 |
| Date | 2026-10-27 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 947.6 ±1.8% | 922.1 ±2.7% | 0.97 |
| silesia/mozilla | 51220480 | 35.6 | 1189.6 ±0.5% | 1177.0 ±0.9% | 0.99 |
| silesia/mr | 9970564 | 35.6 | 1117.8 ±0.9% | 1096.3 ±1.4% | 0.98 |
| silesia/nci | 33553445 | 8.4 | 2031.9 ±4.8% | 1865.9 ±5.3% | 0.92 |
| silesia/ooffice | 6152192 | 50.8 | 988.7 ±1.1% | 1005.9 ±2.5% | 1.02 |
| silesia/osdb | 10085684 | 34.7 | 1432.4 ±0.8% | 1385.3 ±1.3% | 0.97 |
| silesia/reymont | 6627202 | 29.2 | 1070.7 ±1.1% | 1022.3 ±0.9% | 0.95 |
| silesia/samba | 21606400 | 22.9 | 1623.0 ±1.8% | 1582.7 ±0.5% | 0.98 |
| silesia/sao | 7251944 | 76.2 | 887.3 ±2.1% | 963.5 ±1.4% | 1.09 |
| silesia/webster | 41458703 | 29.2 | 1064.7 ±1.5% | 1001.8 ±2.5% | 0.94 |
| silesia/x-ray | 8474240 | 71.8 | 845.0 ±1.5% | 933.1 ±1.5% | 1.10 |
| silesia/xml | 5345280 | 11.9 | 2174.5 ±0.6% | 2198.7 ±1.0% | 1.01 |
| canterbury/alice29.txt | 152089 | 37.5 | 1014.2 ±0.1% | 1025.3 ±0.2% | 1.01 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1133.0 ±0.0% | 1134.7 ±0.1% | 1.00 |
| canterbury/cp.html | 24603 | 34.4 | 1271.1 ±0.1% | 1333.0 ±0.1% | 1.05 |
| canterbury/fields.c | 11150 | 30.3 | 1079.8 ±0.2% | 1127.0 ±0.1% | 1.04 |
| canterbury/grammar.lsp | 3721 | 34.8 | 797.0 ±0.2% | 823.2 ±0.3% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1365.5 ±0.4% | 1263.1 ±0.5% | 0.93 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1237.8 ±0.6% | 1252.6 ±0.5% | 1.01 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1071.5 ±0.2% | 1065.4 ±0.2% | 0.99 |
| canterbury/ptt5 | 513216 | 10.6 | 2370.5 ±0.1% | 2563.2 ±1.1% | 1.08 |
| canterbury/sum | 38240 | 35.0 | 1278.6 ±0.1% | 1292.7 ±0.0% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 788.6 ±0.1% | 794.8 ±0.1% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1107.6 ±1.1% | 1068.1 ±1.1% | 0.96 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1150.3 ±0.4% | 1098.6 ±0.5% | 0.96 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1339.3 ±0.4% | 1299.6 ±1.0% | 0.97 |
| http/html-1kx1024 | 1048576 | 39.3 | 458.3 ±0.2% | 453.1 ±0.1% | 0.99 |
| http/html-16kx64 | 1048576 | 21.9 | 1270.4 ±0.2% | 1268.6 ±0.3% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1694.5 ±0.3% | 1702.5 ±0.4% | 1.00 |
| http/json-1kx1024 | 1048576 | 21.9 | 530.7 ±0.1% | 545.1 ±0.1% | 1.03 |
| http/json-16kx64 | 1048576 | 12.6 | 1659.6 ±0.2% | 1677.3 ±0.2% | 1.01 |
| http/json-1m | 1048576 | 12.2 | 1966.6 ±0.4% | 2095.6 ±0.5% | 1.07 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.9 ±0.1% | 375.8 ±0.2% | 0.94 |
| http/js-16kx64 | 1048576 | 26.0 | 1158.4 ±0.1% | 1144.1 ±0.3% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1674.4 ±0.1% | 1639.9 ±0.6% | 0.98 |
| http/css-1kx1024 | 1048576 | 29.5 | 482.5 ±0.1% | 495.1 ±0.1% | 1.03 |
| http/css-16kx64 | 1048576 | 15.9 | 1512.1 ±0.1% | 1495.6 ±0.2% | 0.99 |
| http/css-1m | 1048576 | 3.6 | 5133.1 ±0.5% | 4851.9 ±1.1% | 0.95 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1203.1 ±0.2% | 1226.4 ±0.4% | 1.02 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 238.0 ±1.0% | 950.0 ±2.4% | 3.99 |
| silesia/mozilla | 51220480 | 35.6 | 277.8 ±0.7% | 1176.4 ±0.5% | 4.23 |
| silesia/mr | 9970564 | 35.6 | 245.0 ±0.6% | 1113.1 ±1.8% | 4.54 |
| silesia/nci | 33553445 | 8.4 | 682.4 ±0.8% | 1934.3 ±3.8% | 2.83 |
| silesia/ooffice | 6152192 | 50.8 | 193.6 ±0.4% | 994.1 ±2.8% | 5.14 |
| silesia/osdb | 10085684 | 34.7 | 302.3 ±0.6% | 1403.2 ±2.9% | 4.64 |
| silesia/reymont | 6627202 | 29.2 | 291.1 ±2.3% | 1052.1 ±0.8% | 3.61 |
| silesia/samba | 21606400 | 22.9 | 450.6 ±1.1% | 1585.1 ±3.2% | 3.52 |
| silesia/sao | 7251944 | 76.2 | 163.6 ±0.2% | 960.2 ±1.0% | 5.87 |
| silesia/webster | 41458703 | 29.2 | 284.4 ±1.1% | 1019.9 ±1.8% | 3.59 |
| silesia/x-ray | 8474240 | 71.8 | 153.1 ±0.1% | 929.9 ±2.3% | 6.08 |
| silesia/xml | 5345280 | 11.9 | 628.6 ±0.3% | 2229.5 ±0.6% | 3.55 |
| canterbury/alice29.txt | 152089 | 37.5 | 221.2 ±0.6% | 1025.1 ±0.0% | 4.63 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 207.9 ±0.2% | 1134.3 ±0.1% | 5.46 |
| canterbury/cp.html | 24603 | 34.4 | 253.3 ±0.5% | 1329.1 ±0.2% | 5.25 |
| canterbury/fields.c | 11150 | 30.3 | 250.5 ±0.3% | 1124.7 ±0.0% | 4.49 |
| canterbury/grammar.lsp | 3721 | 34.8 | 213.3 ±0.5% | 824.5 ±0.1% | 3.87 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 296.6 ±0.4% | 1269.4 ±0.7% | 4.28 |
| canterbury/lcet10.txt | 426754 | 33.0 | 266.0 ±0.4% | 1258.2 ±0.2% | 4.73 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 220.0 ±0.4% | 1071.6 ±0.2% | 4.87 |
| canterbury/ptt5 | 513216 | 10.6 | 473.8 ±0.1% | 2568.5 ±0.9% | 5.42 |
| canterbury/sum | 38240 | 35.0 | 249.8 ±0.4% | 1293.7 ±0.1% | 5.18 |
| canterbury/xargs.1 | 4227 | 42.7 | 183.1 ±0.3% | 796.0 ±0.0% | 4.35 |
| canterbury-large/E.coli | 4638690 | 30.0 | 268.4 ±0.7% | 1103.3 ±0.4% | 4.11 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 299.6 ±1.6% | 1124.1 ±1.2% | 3.75 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 333.7 ±1.0% | 1320.0 ±0.7% | 3.96 |
| http/html-1kx1024 | 1048576 | 39.3 | 187.9 ±0.1% | 453.9 ±0.2% | 2.42 |
| http/html-16kx64 | 1048576 | 21.9 | 334.4 ±0.1% | 1276.7 ±0.3% | 3.82 |
| http/html-1m | 1048576 | 17.7 | 452.3 ±0.4% | 1712.5 ±1.1% | 3.79 |
| http/json-1kx1024 | 1048576 | 21.9 | 279.3 ±0.1% | 545.8 ±0.1% | 1.95 |
| http/json-16kx64 | 1048576 | 12.6 | 467.5 ±0.4% | 1682.3 ±0.2% | 3.60 |
| http/json-1m | 1048576 | 12.2 | 529.0 ±0.2% | 2099.0 ±0.9% | 3.97 |
| http/js-1kx1024 | 1048576 | 44.5 | 158.3 ±0.2% | 375.5 ±0.1% | 2.37 |
| http/js-16kx64 | 1048576 | 26.0 | 287.4 ±0.3% | 1150.7 ±0.3% | 4.00 |
| http/js-1m | 1048576 | 19.0 | 429.4 ±0.1% | 1663.2 ±0.8% | 3.87 |
| http/css-1kx1024 | 1048576 | 29.5 | 234.5 ±0.2% | 495.8 ±0.1% | 2.11 |
| http/css-16kx64 | 1048576 | 15.9 | 421.6 ±0.1% | 1495.8 ±0.1% | 3.55 |
| http/css-1m | 1048576 | 3.6 | 1775.2 ±0.7% | 4922.7 ±0.6% | 2.77 |
| shuffled/dickens-1m | 1048576 | 58.8 | 152.1 ±0.4% | 1254.6 ±0.7% | 8.25 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 941.5 ±3.5% | 0.93 ±3.5% | 0.99 ±3.4% | 0.59 ±3.0% | 0.96 ±3.1% | 0.38 ±1.8% |
| silesia/mozilla | 51220480 | 35.6 | 1182.4 ±0.9% | 0.74 ±0.7% | 1.00 ±0.8% | 0.61 ±0.5% | 0.99 ±1.2% | 0.45 ±0.9% |
| silesia/mr | 9970564 | 35.6 | 1122.4 ±1.4% | 0.82 ±1.2% | 1.01 ±1.2% | 0.57 ±1.0% | 0.97 ±2.3% | 0.38 ±1.0% |
| silesia/nci | 33553445 | 8.4 | 1930.3 ±4.5% | 0.94 ±4.3% | 1.01 ±6.1% | 0.69 ±1.6% | 0.98 ±4.3% | 0.48 ±1.0% |
| silesia/ooffice | 6152192 | 50.8 | 1017.4 ±1.5% | 0.62 ±1.4% | 1.00 ±1.2% | 0.59 ±1.5% | 0.98 ±1.3% | 0.45 ±1.3% |
| silesia/osdb | 10085684 | 34.7 | 1441.1 ±2.6% | 0.66 ±1.5% | 1.00 ±1.5% | 0.68 ±0.5% | 0.96 ±1.1% | 0.45 ±2.9% |
| silesia/reymont | 6627202 | 29.2 | 1060.3 ±0.9% | 0.95 ±0.3% | 1.00 ±0.7% | 0.62 ±0.6% | 0.98 ±0.3% | 0.40 ±1.3% |
| silesia/samba | 21606400 | 22.9 | 1552.7 ±5.2% | 0.91 ±4.9% | 1.02 ±3.2% | 0.64 ±2.0% | 0.99 ±3.3% | 0.43 ±1.2% |
| silesia/sao | 7251944 | 76.2 | 956.4 ±1.2% | 0.52 ±0.9% | 0.99 ±1.2% | 0.69 ±1.3% | 0.97 ±1.7% | 0.52 ±1.4% |
| silesia/webster | 41458703 | 29.2 | 1017.1 ±1.3% | 0.94 ±2.9% | 1.00 ±3.0% | 0.63 ±0.9% | 0.98 ±2.6% | 0.42 ±1.7% |
| silesia/x-ray | 8474240 | 71.8 | 946.1 ±1.8% | 0.51 ±1.1% | 1.00 ±1.1% | 0.65 ±1.1% | 0.96 ±2.2% | 0.48 ±1.3% |
| silesia/xml | 5345280 | 11.9 | 2242.6 ±0.6% | 0.92 ±0.5% | 1.00 ±0.6% | 0.61 ±0.7% | 0.99 ±0.3% | 0.41 ±0.3% |
| canterbury/alice29.txt | 152089 | 37.5 | 1024.1 ±0.2% | 0.94 ±0.3% | 1.00 ±0.4% | 0.54 ±0.3% | 0.99 ±0.1% | 0.36 ±0.3% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1134.5 ±0.0% | 0.85 ±0.2% | 0.98 ±0.1% | 0.51 ±0.2% | 0.99 ±0.1% | 0.37 ±0.1% |
| canterbury/cp.html | 24603 | 34.4 | 1336.3 ±0.1% | 0.63 ±0.2% | 1.00 ±0.1% | 0.62 ±0.5% | 0.99 ±0.1% | 0.45 ±0.2% |
| canterbury/fields.c | 11150 | 30.3 | 1127.2 ±0.1% | 0.81 ±0.1% | 1.00 ±0.2% | 0.60 ±0.6% | 0.99 ±0.3% | 0.41 ±0.1% |
| canterbury/grammar.lsp | 3721 | 34.8 | 823.8 ±0.2% | 0.79 ±0.1% | 1.00 ±0.3% | 0.67 ±0.7% | 0.99 ±0.1% | 0.49 ±0.2% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1269.2 ±0.5% | 0.86 ±0.2% | 1.01 ±0.4% | 0.58 ±0.1% | 1.00 ±0.4% | 0.38 ±0.2% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1259.6 ±0.3% | 0.89 ±0.3% | 1.00 ±0.6% | 0.54 ±0.4% | 0.99 ±0.3% | 0.35 ±0.2% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1072.1 ±0.3% | 0.91 ±0.3% | 1.00 ±0.4% | 0.53 ±0.5% | 0.99 ±0.4% | 0.35 ±2.7% |
| canterbury/ptt5 | 513216 | 10.6 | 2538.2 ±1.2% | 0.81 ±1.6% | 1.01 ±1.0% | 0.56 ±0.1% | 1.01 ±1.3% | 0.44 ±0.4% |
| canterbury/sum | 38240 | 35.0 | 1291.6 ±0.1% | 0.64 ±0.4% | 1.00 ±0.3% | 0.62 ±0.7% | 0.99 ±0.1% | 0.45 ±0.3% |
| canterbury/xargs.1 | 4227 | 42.7 | 795.7 ±0.2% | 0.74 ±0.2% | 1.00 ±0.2% | 0.65 ±0.6% | 0.99 ±0.0% | 0.46 ±0.2% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1101.6 ±0.1% | 0.98 ±0.5% | 1.00 ±0.8% | 0.58 ±0.8% | 0.98 ±1.2% | 0.35 ±0.6% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1123.4 ±0.5% | 0.96 ±0.5% | 1.00 ±0.9% | 0.61 ±0.9% | 0.98 ±1.8% | 0.38 ±1.9% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1320.1 ±0.5% | 0.90 ±0.3% | 1.01 ±0.3% | 0.60 ±0.4% | 0.98 ±0.3% | 0.41 ±0.5% |
| http/html-1kx1024 | 1048576 | 39.3 | 454.2 ±0.2% | 0.84 ±0.1% | 1.00 ±0.1% | 0.78 ±0.1% | 0.99 ±0.4% | 0.67 ±0.1% |
| http/html-16kx64 | 1048576 | 21.9 | 1274.4 ±0.3% | 0.83 ±0.2% | 1.00 ±0.4% | 0.63 ±0.2% | 1.00 ±0.2% | 0.46 ±0.1% |
| http/html-1m | 1048576 | 17.7 | 1718.2 ±0.3% | 0.93 ±0.3% | 1.00 ±0.4% | 0.60 ±0.3% | 0.99 ±0.6% | 0.39 ±0.1% |
| http/json-1kx1024 | 1048576 | 21.9 | 546.4 ±0.2% | 0.98 ±0.1% | 1.00 ±0.1% | 0.81 ±0.1% | 0.98 ±0.1% | 0.68 ±0.4% |
| http/json-16kx64 | 1048576 | 12.6 | 1678.3 ±0.2% | 0.85 ±0.3% | 1.00 ±0.2% | 0.65 ±0.1% | 0.99 ±0.1% | 0.47 ±0.1% |
| http/json-1m | 1048576 | 12.2 | 2106.5 ±0.3% | 0.88 ±0.5% | 1.00 ±0.5% | 0.58 ±0.6% | 0.99 ±0.9% | 0.40 ±0.2% |
| http/js-1kx1024 | 1048576 | 44.5 | 375.8 ±0.2% | 0.86 ±0.2% | 1.00 ±0.1% | 0.78 ±0.3% | 0.99 ±0.3% | 0.67 ±0.1% |
| http/js-16kx64 | 1048576 | 26.0 | 1149.0 ±0.2% | 0.82 ±0.3% | 1.01 ±0.4% | 0.61 ±0.2% | 1.00 ±0.3% | 0.45 ±0.2% |
| http/js-1m | 1048576 | 19.0 | 1659.8 ±0.7% | 0.92 ±0.5% | 1.00 ±0.6% | 0.60 ±0.1% | 0.99 ±0.2% | 0.39 ±1.3% |
| http/css-1kx1024 | 1048576 | 29.5 | 495.3 ±0.1% | 0.94 ±0.3% | 1.00 ±0.1% | 0.80 ±0.2% | 0.98 ±0.1% | 0.66 ±0.1% |
| http/css-16kx64 | 1048576 | 15.9 | 1491.1 ±1.1% | 0.89 ±0.1% | 1.01 ±0.2% | 0.65 ±0.3% | 1.00 ±0.2% | 0.45 ±0.2% |
| http/css-1m | 1048576 | 3.6 | 4951.5 ±0.4% | 0.95 ±0.5% | 1.00 ±1.4% | 0.70 ±0.5% | 0.99 ±0.5% | 0.46 ±0.2% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1251.1 ±0.3% | 0.52 ±0.4% | 0.86 ±0.4% | 0.74 ±0.3% | 0.98 ±0.4% | 0.56 ±0.5% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 333.9 ± 0.2% | 84.7 ± 0.2% | 0.25 |
| silesia/dickens | 10192446 | 3 | 152.3 ± 1.0% | 59.5 ± 0.4% | 0.39 |
| silesia/mozilla | 51220480 | 1 | 481.8 ± 0.3% | 119.8 ± 0.3% | 0.25 |
| silesia/mozilla | 51220480 | 3 | 202.4 ± 0.5% | 67.6 ± 0.3% | 0.33 |
| silesia/mr | 9970564 | 1 | 441.2 ± 0.5% | 104.7 ± 0.5% | 0.24 |
| silesia/mr | 9970564 | 3 | 172.2 ± 0.6% | 64.2 ± 0.2% | 0.37 |
| silesia/nci | 33553445 | 1 | 955.2 ± 0.4% | 227.4 ± 0.2% | 0.24 |
| silesia/nci | 33553445 | 3 | 629.1 ± 1.0% | 122.4 ± 0.1% | 0.19 |
| silesia/ooffice | 6152192 | 1 | 394.5 ± 0.3% | 94.6 ± 0.1% | 0.24 |
| silesia/ooffice | 6152192 | 3 | 143.9 ± 1.0% | 57.4 ± 0.4% | 0.40 |
| silesia/osdb | 10085684 | 1 | 476.2 ± 0.3% | 126.9 ± 0.3% | 0.27 |
| silesia/osdb | 10085684 | 3 | 192.3 ± 0.7% | 70.1 ± 0.4% | 0.36 |
| silesia/reymont | 6627202 | 1 | 344.2 ± 0.2% | 100.6 ± 0.3% | 0.29 |
| silesia/reymont | 6627202 | 3 | 187.9 ± 0.9% | 73.6 ± 1.1% | 0.39 |
| silesia/samba | 21606400 | 1 | 565.1 ± 0.7% | 146.4 ± 0.4% | 0.26 |
| silesia/samba | 21606400 | 3 | 289.0 ± 0.8% | 88.5 ± 0.3% | 0.31 |
| silesia/sao | 7251944 | 1 | 372.5 ± 0.5% | 85.1 ± 0.1% | 0.23 |
| silesia/sao | 7251944 | 3 | 109.0 ± 0.7% | 48.7 ± 0.3% | 0.45 |
| silesia/webster | 41458703 | 1 | 388.2 ± 0.1% | 102.1 ± 0.2% | 0.26 |
| silesia/webster | 41458703 | 3 | 180.4 ± 0.3% | 64.6 ± 0.3% | 0.36 |
| silesia/x-ray | 8474240 | 1 | 719.8 ± 1.3% | 90.5 ± 0.6% | 0.13 |
| silesia/x-ray | 8474240 | 3 | 106.9 ± 0.5% | 50.6 ± 0.4% | 0.47 |
| silesia/xml | 5345280 | 1 | 796.9 ± 0.3% | 186.2 ± 0.3% | 0.23 |
| silesia/xml | 5345280 | 3 | 496.4 ± 0.9% | 135.5 ± 0.7% | 0.27 |
| canterbury/alice29.txt | 152089 | 1 | 311.7 ± 0.2% | 101.4 ± 0.4% | 0.33 |
| canterbury/alice29.txt | 152089 | 3 | 216.4 ± 0.1% | 91.2 ± 0.6% | 0.42 |
| canterbury/asyoulik.txt | 125179 | 1 | 347.2 ± 0.3% | 95.2 ± 0.3% | 0.27 |
| canterbury/asyoulik.txt | 125179 | 3 | 218.8 ± 0.2% | 88.2 ± 0.1% | 0.40 |
| canterbury/cp.html | 24603 | 1 | 489.1 ± 0.2% | 143.4 ± 0.4% | 0.29 |
| canterbury/cp.html | 24603 | 3 | 368.2 ± 1.7% | 132.1 ± 0.3% | 0.36 |
| canterbury/fields.c | 11150 | 1 | 389.9 ± 0.9% | 138.5 ± 0.3% | 0.36 |
| canterbury/fields.c | 11150 | 3 | 378.6 ± 1.5% | 142.6 ± 0.9% | 0.38 |
| canterbury/grammar.lsp | 3721 | 1 | 357.3 ± 0.3% | 121.8 ± 0.3% | 0.34 |
| canterbury/grammar.lsp | 3721 | 3 | 319.9 ± 0.2% | 120.0 ± 0.6% | 0.38 |
| canterbury/kennedy.xls | 1029744 | 1 | 565.8 ± 0.7% | 155.2 ± 0.6% | 0.27 |
| canterbury/kennedy.xls | 1029744 | 3 | 395.0 ± 0.5% | 134.9 ± 1.1% | 0.34 |
| canterbury/lcet10.txt | 426754 | 1 | 342.8 ± 0.3% | 105.8 ± 0.3% | 0.31 |
| canterbury/lcet10.txt | 426754 | 3 | 203.9 ± 0.5% | 95.0 ± 0.5% | 0.47 |
| canterbury/plrabn12.txt | 481861 | 1 | 326.1 ± 0.3% | 88.1 ± 1.6% | 0.27 |
| canterbury/plrabn12.txt | 481861 | 3 | 164.1 ± 0.1% | 80.2 ± 0.3% | 0.49 |
| canterbury/ptt5 | 513216 | 1 | 1091.2 ± 0.2% | 322.0 ± 0.2% | 0.30 |
| canterbury/ptt5 | 513216 | 3 | 686.0 ± 0.4% | 275.4 ± 0.4% | 0.40 |
| canterbury/sum | 38240 | 1 | 521.0 ± 0.6% | 140.9 ± 0.6% | 0.27 |
| canterbury/sum | 38240 | 3 | 372.9 ± 2.2% | 126.6 ± 0.4% | 0.34 |
| canterbury/xargs.1 | 4227 | 1 | 340.4 ± 0.5% | 115.9 ± 0.6% | 0.34 |
| canterbury/xargs.1 | 4227 | 3 | 283.3 ± 0.3% | 109.9 ± 0.6% | 0.39 |
| canterbury-large/E.coli | 4638690 | 1 | 320.0 ± 0.2% | 95.0 ± 0.2% | 0.30 |
| canterbury-large/E.coli | 4638690 | 3 | 221.8 ± 0.4% | 83.3 ± 0.5% | 0.38 |
| canterbury-large/bible.txt | 4047392 | 1 | 343.8 ± 0.3% | 101.3 ± 0.5% | 0.29 |
| canterbury-large/bible.txt | 4047392 | 3 | 188.8 ± 0.9% | 79.4 ± 0.5% | 0.42 |
| canterbury-large/world192.txt | 2473400 | 1 | 414.1 ± 0.5% | 114.8 ± 0.5% | 0.28 |
| canterbury-large/world192.txt | 2473400 | 3 | 220.2 ± 0.9% | 100.8 ± 1.0% | 0.46 |
| http/html-1kx1024 | 1048576 | 1 | 198.9 ± 0.1% | 69.6 ± 0.1% | 0.35 |
| http/html-1kx1024 | 1048576 | 3 | 176.7 ± 0.2% | 66.0 ± 0.4% | 0.37 |
| http/html-16kx64 | 1048576 | 1 | 435.3 ± 0.2% | 166.0 ± 0.3% | 0.38 |
| http/html-16kx64 | 1048576 | 3 | 379.5 ± 0.6% | 155.7 ± 0.4% | 0.41 |
| http/html-1m | 1048576 | 1 | 538.6 ± 0.4% | 167.1 ± 0.4% | 0.31 |
| http/html-1m | 1048576 | 3 | 359.1 ± 0.6% | 161.5 ± 0.5% | 0.45 |
| http/json-1kx1024 | 1048576 | 1 | 237.5 ± 0.2% | 86.7 ± 0.3% | 0.37 |
| http/json-1kx1024 | 1048576 | 3 | 228.1 ± 0.1% | 83.8 ± 1.0% | 0.37 |
| http/json-16kx64 | 1048576 | 1 | 708.8 ± 0.1% | 241.5 ± 0.2% | 0.34 |
| http/json-16kx64 | 1048576 | 3 | 626.2 ± 0.2% | 228.6 ± 0.5% | 0.37 |
| http/json-1m | 1048576 | 1 | 836.0 ± 0.2% | 232.2 ± 0.7% | 0.28 |
| http/json-1m | 1048576 | 3 | 532.5 ± 0.2% | 221.3 ± 1.3% | 0.42 |
| http/js-1kx1024 | 1048576 | 1 | 183.1 ± 0.2% | 62.7 ± 0.5% | 0.34 |
| http/js-1kx1024 | 1048576 | 3 | 157.6 ± 0.1% | 59.8 ± 0.7% | 0.38 |
| http/js-16kx64 | 1048576 | 1 | 379.2 ± 0.0% | 139.4 ± 0.5% | 0.37 |
| http/js-16kx64 | 1048576 | 3 | 330.8 ± 0.1% | 135.9 ± 0.7% | 0.41 |
| http/js-1m | 1048576 | 1 | 512.7 ± 0.2% | 153.7 ± 0.5% | 0.30 |
| http/js-1m | 1048576 | 3 | 336.8 ± 0.4% | 150.2 ± 0.8% | 0.45 |
| http/css-1kx1024 | 1048576 | 1 | 217.9 ± 0.3% | 78.1 ± 0.4% | 0.36 |
| http/css-1kx1024 | 1048576 | 3 | 202.6 ± 0.1% | 75.3 ± 0.2% | 0.37 |
| http/css-16kx64 | 1048576 | 1 | 547.7 ± 0.2% | 185.5 ± 0.3% | 0.34 |
| http/css-16kx64 | 1048576 | 3 | 513.5 ± 0.2% | 183.8 ± 0.2% | 0.36 |
| http/css-1m | 1048576 | 1 | 2286.0 ± 0.4% | 494.0 ± 0.3% | 0.22 |
| http/css-1m | 1048576 | 3 | 1730.4 ± 0.7% | 649.9 ± 0.8% | 0.38 |
| shuffled/dickens-1m | 1048576 | 1 | 965.6 ± 0.4% | 186.2 ± 0.7% | 0.19 |
| shuffled/dickens-1m | 1048576 | 3 | 119.3 ± 0.7% | 116.8 ± 0.5% | 0.98 |

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
| silesia/dickens | 10192446 | 35.9 | 944.4 ±2.1% | 927.5 ±1.7% | 0.98 |
| silesia/mozilla | 51220480 | 35.6 | 1172.7 ±0.4% | 1177.4 ±0.6% | 1.00 |
| silesia/mr | 9970564 | 35.6 | 1098.5 ±0.7% | 1086.5 ±1.5% | 0.99 |
| silesia/nci | 33553445 | 8.4 | 2051.4 ±1.0% | 1929.0 ±6.4% | 0.94 |
| silesia/ooffice | 6152192 | 50.8 | 989.7 ±0.5% | 1013.2 ±0.4% | 1.02 |
| silesia/osdb | 10085684 | 34.7 | 1422.3 ±1.4% | 1386.6 ±0.7% | 0.97 |
| silesia/reymont | 6627202 | 29.2 | 1067.5 ±0.7% | 1021.9 ±0.7% | 0.96 |
| silesia/samba | 21606400 | 22.9 | 1585.7 ±2.1% | 1530.0 ±3.6% | 0.96 |
| silesia/sao | 7251944 | 76.2 | 860.3 ±1.0% | 943.5 ±1.1% | 1.10 |
| silesia/webster | 41458703 | 29.2 | 1037.3 ±1.3% | 985.8 ±2.5% | 0.95 |
| silesia/x-ray | 8474240 | 71.8 | 842.7 ±0.2% | 925.8 ±1.6% | 1.10 |
| silesia/xml | 5345280 | 11.9 | 2189.6 ±0.7% | 2225.6 ±1.5% | 1.02 |
| canterbury/alice29.txt | 152089 | 37.5 | 1010.6 ±0.1% | 1025.4 ±0.2% | 1.01 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1128.6 ±0.1% | 1137.8 ±0.1% | 1.01 |
| canterbury/cp.html | 24603 | 34.4 | 1268.7 ±0.2% | 1335.0 ±0.1% | 1.05 |
| canterbury/fields.c | 11150 | 30.3 | 1082.6 ±0.1% | 1118.8 ±0.1% | 1.03 |
| canterbury/grammar.lsp | 3721 | 34.8 | 801.5 ±0.3% | 822.2 ±0.2% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1355.8 ±0.2% | 1270.3 ±0.3% | 0.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1231.9 ±0.4% | 1254.2 ±0.3% | 1.02 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1068.6 ±0.3% | 1063.8 ±0.1% | 1.00 |
| canterbury/ptt5 | 513216 | 10.6 | 2366.0 ±0.6% | 2570.8 ±2.5% | 1.09 |
| canterbury/sum | 38240 | 35.0 | 1275.9 ±0.2% | 1293.0 ±0.1% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 789.0 ±0.1% | 796.4 ±0.2% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1107.4 ±0.8% | 1071.3 ±0.5% | 0.97 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1112.5 ±0.6% | 1086.0 ±0.8% | 0.98 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1319.7 ±0.1% | 1303.9 ±0.5% | 0.99 |
| http/html-1kx1024 | 1048576 | 39.3 | 458.3 ±1.2% | 477.7 ±0.2% | 1.04 |
| http/html-16kx64 | 1048576 | 21.9 | 1273.0 ±0.1% | 1276.1 ±0.3% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1691.5 ±0.7% | 1697.1 ±0.2% | 1.00 |
| http/json-1kx1024 | 1048576 | 21.9 | 531.9 ±0.1% | 572.7 ±0.2% | 1.08 |
| http/json-16kx64 | 1048576 | 12.6 | 1662.0 ±0.1% | 1696.4 ±0.2% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1967.2 ±0.4% | 2088.6 ±0.4% | 1.06 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.8 ±0.2% | 389.2 ±0.1% | 0.97 |
| http/js-16kx64 | 1048576 | 26.0 | 1160.2 ±0.2% | 1149.4 ±0.1% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1628.5 ±0.3% | 1652.4 ±0.7% | 1.01 |
| http/css-1kx1024 | 1048576 | 29.5 | 482.6 ±0.1% | 518.9 ±0.1% | 1.08 |
| http/css-16kx64 | 1048576 | 15.9 | 1513.0 ±0.1% | 1508.5 ±0.1% | 1.00 |
| http/css-1m | 1048576 | 3.6 | 5128.6 ±0.4% | 4915.3 ±0.8% | 0.96 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1205.0 ±0.3% | 1231.2 ±0.4% | 1.02 |
